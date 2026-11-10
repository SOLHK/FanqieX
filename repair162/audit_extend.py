#!/usr/bin/env python3
"""Independent verifier and negative controls for the RX-segment extension.

The verifier below neither imports nor calls extend_macho.  --selftest imports
the builder only to produce in-memory fixtures, then checks them independently.
It never executes the ARM64 fixture, the host application, or UIKit.
"""
import argparse
import hashlib
import json
from pathlib import Path
import struct


def require(condition, message):
    if not condition:
        raise ValueError(message)


def parse(data):
    require(len(data) >= 32, "header truncated")
    h = struct.unpack_from("<8I", data)
    require(h[:2] == (0xFEEDFACF, 0x100000C) and h[3] == 6, "architecture/type")
    p, result, segs = 32, [], []
    for _ in range(h[4]):
        require(p + 8 <= 32 + h[5] <= len(data), "command bounds")
        kind, size = struct.unpack_from("<II", data, p)
        require(size >= 8 and size % 8 == 0 and p + size <= 32 + h[5], "command size")
        raw = data[p:p + size]
        result.append((kind, p, raw))
        if kind == 0x19:
            require(size >= 72, "segment header")
            name, vm, vs, off, fs, maximum, initial, ns, flags = struct.unpack_from("<16s4Q4I", raw, 8)
            require(size == 72 + 80 * ns, "section extent")
            segs.append({"name": name.rstrip(b"\0").decode(), "vm": vm, "vs": vs,
                         "off": off, "fs": fs, "max": maximum, "prot": initial,
                         "ns": ns, "flags": flags, "raw": raw, "lc": p})
        p += size
    require(p == 32 + h[5], "sizeofcmds")
    return h, result, segs


def single(items, kind):
    values = [item for item in items if item[0] == kind]
    require(len(values) == 1, "unique load command " + hex(kind))
    return values[0]


def blob_range(items, kind):
    return struct.unpack_from("<II", single(items, kind)[2], 8)


def signature(data, commands):
    sig, size = blob_range(commands, 0x1D)
    require(sig + size == len(data), "signature at image end")
    magic, size2, count, slot, rel = struct.unpack_from(">5I", data, sig)
    require((magic, size2, count, slot, rel) == (0xFADE0CC0, size, 1, 0, 24), "signature envelope")
    cd = sig + rel
    m, n, version, flags, hoff, ioff, special, slots, limit = struct.unpack_from(">9I", data, cd)
    require((m, version, flags, special, limit) == (0xFADE0C02, 0x20400, 0x20002, 0, sig),
            "CodeDirectory header")
    require(cd + n == len(data) and slots == -(-sig // 4096), "CodeDirectory length/count")
    require(struct.unpack_from(">4B", data, cd + 36) == (32, 2, 0, 12), "hash format")
    require(ioff == 88 and ioff < hoff and hoff + slots * 32 == n, "hash array bounds")
    require(data[cd + 40:cd + 64] == bytes(24), "unexpected signature features")
    require(struct.unpack_from(">3Q", data, cd + 64) == (0, 0x10000, 0), "TEXT signing metadata")
    end = data.find(b"\0", cd + ioff, cd + hoff)
    require(end != -1 and not any(data[end:cd + hoff]), "identifier terminator/padding")
    for page in range(slots):
        start = page * 4096
        got = data[cd + hoff + page * 32:cd + hoff + (page + 1) * 32]
        want = hashlib.sha256(data[start:min(start + 4096, sig)]).digest()
        require(got == want, "signed page " + str(page))
    return {"offset": sig, "size": size, "pages": slots,
            "identifier": data[cd + ioff:end].decode(),
            "cdhash": hashlib.sha256(data[cd:]).digest()[:20].hex()}


def chain_rows(data, items, segs):
    base, size = blob_range(items, 0x80000034)
    require(base + size <= len(data), "chained blob bounds")
    block = data[base:base + size]
    v, start, im, sy, ni, fmt, sf = struct.unpack_from("<7I", block)
    require((v, fmt, sf) == (0, 1, 0) and sy >= im + ni * 4, "chained format")
    nseg = struct.unpack_from("<I", block, start)[0]
    require(nseg == len(segs), "starts segment count")
    records = []
    for i in range(nseg):
        q = struct.unpack_from("<I", block, start + 4 + i * 4)[0]
        if not q:
            continue
        at = start + q
        n, ps, pf, vo, maximum, pc = struct.unpack_from("<IHHQIH", block, at)
        require(pf == 2 and ps == 0x4000 and vo == segs[i]["vm"] and at + n <= im,
                "segment-starts semantics")
        require(n >= 22 + pc * 2 and maximum == 0, "segment-starts extent")
        for page in range(pc):
            step = struct.unpack_from("<H", block, at + 22 + page * 2)[0]
            if step == 0xFFFF:
                continue
            require(step < 0x8000, "unsupported multi-start chain")
            seen = set()
            while True:
                require(step not in seen and step + 8 <= ps, "chain loop/page overflow")
                seen.add(step)
                off = segs[i]["off"] + ps * page + step
                require(off + 8 <= segs[i]["off"] + segs[i]["fs"], "chain segment overflow")
                raw = int.from_bytes(data[off:off + 8], "little")
                bind = raw >> 63
                next_step = (raw >> 51) & 4095
                if bind:
                    ordinal = raw & 0xFFFFFF
                    require(ordinal < ni and not ((raw >> 32) & 0x7FFFF), "bind target")
                    target = ("bind", ordinal, (raw >> 24) & 255)
                else:
                    require(not ((raw >> 44) & 127), "rebase reserved bits")
                    target = ("rebase", (raw & 0xFFFFFFFFF) | (((raw >> 36) & 255) << 56))
                records.append((segs[i]["vm"] + ps * page + step, raw, target))
                if not next_step:
                    break
                step += next_step * 4
    return records, block[im:], nseg, start


def audit(source, candidate, payload=None):
    oh, old, os = parse(source)
    nh, new, ns = parse(candidate)
    require([s["name"] for s in os] == ["__TEXT", "__DATA_CONST", "__LINKEDIT"], "source layout")
    require([s["name"] for s in ns] == ["__TEXT", "__DATA_CONST", "__FQPATCH", "__LINKEDIT"], "output order")
    require(nh[:4] == oh[:4] and nh[6:] == oh[6:] and nh[4] == oh[4] + 1 and nh[5] == oh[5] + 72,
            "header delta")
    require(32 + nh[5] <= 0x800, "load commands overlap repair")
    require([s["raw"] for s in ns[:2]] == [s["raw"] for s in os[:2]], "original segment descriptors")
    patch = ns[2]
    delta = patch["fs"]
    require(delta in (0x4000, 0x8000, 0xc000, 0x10000, 0x20000, 0x24000, 0x28000), "patch size")
    require((patch["vm"], patch["off"], patch["vs"], patch["max"], patch["prot"], patch["ns"], patch["flags"]) ==
            (0x14000, 0x14000, delta, 5, 5, 0, 0), "patch permissions/map")
    for i, seg in enumerate(ns):
        require(seg["off"] == seg["vm"] and seg["off"] % 0x4000 == 0, "VM/file identity and alignment")
        require(seg["fs"] <= seg["vs"] and seg["off"] + seg["fs"] <= len(candidate), "segment extent")
        require((seg["prot"] & 6) != 6, "W+X mapping")
        if i:
            prior = ns[i - 1]
            require(prior["vm"] + prior["vs"] <= seg["vm"] and prior["off"] + prior["fs"] <= seg["off"],
                    "segment overlap")
    require((ns[-1]["vm"], ns[-1]["off"], ns[-1]["max"], ns[-1]["prot"], ns[-1]["ns"]) ==
            (0x14000 + delta, 0x14000 + delta, 1, 1, 0), "LINKEDIT mapping")
    require(ns[-1]["off"] + ns[-1]["fs"] == len(candidate), "LINKEDIT end")
    require(source[32 + nh[5]:0x14000] == candidate[32 + nh[5]:0x14000], "original mapped bytes")
    filtered = [item for item in new if item[1] != patch["lc"]]
    require(len(old) == len(filtered), "unrelated command count")
    for a, b in zip(old, filtered):
        require(a[0] == b[0] and len(a[2]) == len(b[2]), "command kind/length")
        kind, _, ar = a
        br = b[2]
        if kind in (0x1D, 0x26, 0x29, 0x80000033, 0x80000034):
            af, az = struct.unpack_from("<II", ar, 8)
            bf, bz = struct.unpack_from("<II", br, 8)
            require(bf == (af + delta if af else 0), "LINKEDIT offset")
            if kind != 0x1D:
                require(az == bz, "LINKEDIT table size")
        elif kind == 2:
            av, bv = struct.unpack_from("<4I", ar, 8), struct.unpack_from("<4I", br, 8)
            require(bv == (av[0] + delta, av[1], av[2] + delta, av[3]), "symbol table offsets")
        elif kind == 0xB:
            av, bv = struct.unpack_from("<18I", ar, 8), struct.unpack_from("<18I", br, 8)
            for i, (aa, bb) in enumerate(zip(av, bv)):
                require(bb == aa + (delta if i in (6, 8, 10, 12, 14, 16) and aa else 0), "dysymtab relocation")
        elif kind == 0x19 and ar[8:24].rstrip(b"\0") == b"__LINKEDIT":
            require(ar[:24] == br[:24] and ar[56:] == br[56:], "LINKEDIT metadata")
        else:
            require(ar == br, "unrelated command changed")
    osig, _ = blob_range(old, 0x1D)
    nsig = signature(candidate, new)
    require(nsig["offset"] == osig + delta, "signature relocation")
    require(nsig["offset"] >= patch["off"] + patch["fs"], "new code outside signed range")
    ob = source[0x14000:osig]
    nb = candidate[0x14000 + delta:nsig["offset"]]
    require(len(ob) == len(nb), "preserved LINKEDIT length")
    fix, _ = blob_range(old, 0x80000034)
    allowed = set(range(fix - 0x14000 + 4, fix - 0x14000 + 8))
    allowed.update(range(fix - 0x14000 + 28, fix - 0x14000 + 48))
    require(all(x == y or i in allowed for i, (x, y) in enumerate(zip(ob, nb))), "LINKEDIT payload changed")
    oc, oi, on, ost = chain_rows(source, old, os)
    nc, ni, nn, nst = chain_rows(candidate, new, ns)
    require(oc == nc and oi == ni and (on, ost, nn, nst) == (3, 32, 4, 28), "fixup semantics")
    require(len(oc) == 656, "pointer count")
    require(all(row[2][0] != "rebase" or row[2][1] < 0x14000 for row in oc),
            "rebase targets a moved LINKEDIT address")
    if payload is not None:
        require(candidate[patch["off"]:patch["off"] + len(payload)] == payload, "extension payload")
        require(not any(candidate[patch["off"] + len(payload):patch["off"] + delta]), "extension padding")
    return {"passed": True, "candidate_sha256": hashlib.sha256(candidate).hexdigest(),
            "extension_capacity": delta, "file_bytes": len(candidate), "header_end": 32 + nh[5],
            "unchanged_original_fixups": len(oc), "unchanged_import_records": 23,
            "signature": nsig, "device_tested": False}


def selftest(source):
    from extend_macho import extend
    payload = bytes.fromhex("1f2003d5c0035fd6")
    reports = []
    for size in (0x4000, 0x8000, 0xc000, 0x10000, 0x20000):
        candidate = extend(source, payload, capacity=size, identifier="FanqieAdBlock-1.5.7.dylib")
        reports.append(audit(source, candidate, payload))
    # Exercise the fourth page with actual bytes above the former 48 KiB limit.
    large_payload = bytes.fromhex("1f2003d5") * (0xc000 // 4) + bytes.fromhex("c0035fd6")
    large = extend(source, large_payload, capacity=0x10000)
    reports.append(audit(source, large, large_payload))
    # Place real payload bytes in the ninth page and verify its relocated signature.
    nine_page_payload = bytes.fromhex("1f2003d5") * (0x20000 // 4) + bytes.fromhex("c0035fd6")
    nine_page = extend(source, nine_page_payload, capacity=0x24000)
    reports.append(audit(source, nine_page, nine_page_payload))
    ten_page_payload = bytes.fromhex("1f2003d5") * (0x24000 // 4) + bytes.fromhex("c0035fd6")
    ten_page = extend(source, ten_page_payload, capacity=0x28000)
    reports.append(audit(source, ten_page, ten_page_payload))
    candidate = extend(source, payload, capacity=0x4000)
    _, items, segs = parse(candidate)
    sig, _ = blob_range(items, 0x1D)
    fix, _ = blob_range(items, 0x80000034)
    mutations = {
        "new_rx_code_not_signed": (0x14000, b"\0"),
        "chained_segment_count_not_updated": (fix + 28, struct.pack("<I", 3)),
        "new_segment_is_writable": (segs[2]["lc"] + 60, struct.pack("<I", 7)),
        "old_pointer_slot_changed": (0x10000, b"\0"),
        "old_code_changed": (0x4000, b"\0"),
        "original_import_table_changed": (fix + 72, b"\0"),
        "original_indirect_symbol_offset_not_moved": (single(items, 0xB)[1] + 8 + 12 * 4,
                                                      struct.pack("<I", 0x14F58)),
        "signature_code_slots_too_small": (sig + 24 + 28, struct.pack(">I", 22)),
    }
    rejected = []
    for name, (at, raw) in mutations.items():
        changed = bytearray(candidate)
        # Ensure even zero-valued first bytes actually differ.
        if changed[at:at + len(raw)] == raw:
            raw = bytes([raw[0] ^ 1]) + raw[1:]
        changed[at:at + len(raw)] = raw
        rehashed = name not in ("new_rx_code_not_signed", "signature_code_slots_too_small")
        if rehashed:
            # Structural controls remain malformed even after a valid ad-hoc
            # checksum has been supplied.  Do not let hash rejection stand in
            # for checking segment order, chained indices or import identity.
            cd = sig + 24
            hoff = struct.unpack_from(">I", changed, cd + 16)[0]
            slots = struct.unpack_from(">I", changed, cd + 28)[0]
            for page in range(slots):
                start = page * 4096
                changed[cd + hoff + page * 32:cd + hoff + (page + 1) * 32] = hashlib.sha256(
                    changed[start:min(start + 4096, sig)]).digest()
        try:
            audit(source, bytes(changed), payload)
        except (ValueError, struct.error) as exc:
            rejected.append({"case": name, "rejected": True, "rehashed": rehashed, "reason": str(exc)})
        else:
            raise AssertionError("Mutation escaped independent audit: " + name)
    builder_cases = [
        ("already_extended", candidate, payload, 0x4000),
        ("unaligned_payload", source, b"123", 0x4000),
        ("payload_over_capacity", source, bytes(0x4004), 0x4000),
        ("unsupported_capacity", source, payload, 0x1000),
        ("over_reviewed_capacity", source, payload, 0x14000),
        ("four_page_overflow", source, bytes(0x10004), 0x10000),
        ("eight_page_overflow", source, bytes(0x20004), 0x20000),
        ("nine_page_overflow", source, bytes(0x24004), 0x24000),
        ("ten_page_overflow", source, bytes(0x28004), 0x28000),
        ("eleven_page_capacity", source, payload, 0x2c000),
    ]
    occupied = bytearray(source)
    _, cmds, _ = parse(source)
    occupied[32 + struct.unpack_from("<I", source, 20)[0]] = 1
    builder_cases.append(("occupied_header_padding", bytes(occupied), payload, 0x4000))
    encrypted = bytearray(source)
    struct.pack_into("<I", encrypted, single(cmds, 0x2C)[1] + 16, 1)
    builder_cases.append(("encrypted_input", bytes(encrypted), payload, 0x4000))
    for name, data, code, capacity in builder_cases:
        try:
            extend(data, code, capacity=capacity)
        except ValueError as exc:
            rejected.append({"case": name, "rejected": True, "reason": str(exc)})
        else:
            raise AssertionError("Invalid input accepted: " + name)
    return {"passed": True, "fixture_only": "NOP/RET bytes are never executed",
            "valid_layouts": reports, "negative_controls": rejected,
            "device_tested": False}


def main():
    parser = argparse.ArgumentParser(description=__doc__)
    parser.add_argument("source", type=Path)
    parser.add_argument("candidate", type=Path, nargs="?")
    parser.add_argument("--extension", type=Path)
    parser.add_argument("--selftest", action="store_true")
    args = parser.parse_args()
    original = args.source.read_bytes()
    if args.selftest:
        report = selftest(original)
    else:
        require(args.candidate is not None, "candidate path is required")
        report = audit(original, args.candidate.read_bytes(),
                       args.extension.read_bytes() if args.extension else None)
    print(json.dumps(report, ensure_ascii=False, indent=2))


if __name__ == "__main__":
    main()
