#!/usr/bin/env python3
"""Add a bounded, non-writable ARM64 repair segment to this plugin image.

This is intentionally NOT a general-purpose Mach-O rewriter.  It accepts the
three-segment, chained-fixup layout of the supplied FanqieAdBlock image (including
same-layout local code/version edits), and rejects unfamiliar structures.

Public API:
    extend(input_bytes, extension_bytes, capacity=0x4000, identifier=None) -> bytes
    verify_extension(input_bytes, output_bytes, extension_bytes=None) -> dict
    verify_signature(image_bytes) -> dict

__TEXT and __DATA_CONST keep their VM addresses, file offsets, protections,
sections, code, and pointer slots.  The 16/32 KiB RX __FQPATCH segment is inserted
at 0x14000, immediately before __LINKEDIT.  __LINKEDIT is moved by that capacity.
No new import, entitlement, fixup target, or section number is introduced.

The existing fixup blob has four unused bytes after its 28-byte header.  Moving
starts_offset from 32 to 28 makes room for the new zero segment entry without
moving its segment starts, import records, or symbols.  Its size stays 0x2a0.

The signature is a fresh SHA-256 ad-hoc CodeDirectory.  Its codeLimit and page
count cover every byte of the new segment.  As in LLVM LLD's Mach-O signer,
execSegBase/execSegLimit describe __TEXT; they are not a permission map for all
segments.  Segment VM protection remains the separate LC_SEGMENT_64 property.

Primary format references:
https://github.com/apple-oss-distributions/dyld/blob/main/include/mach-o/fixup-chains.h
https://github.com/apple-oss-distributions/xnu/blob/main/EXTERNAL_HEADERS/mach-o/loader.h
https://github.com/apple-oss-distributions/Security/blob/main/OSX/libsecurity_codesigning/lib/codedirectory.h
https://reviews.llvm.org/D109803?id=372757

Verification here is structural and cryptographic.  It does not execute dyld,
prove iOS installation/signing acceptance, or test UIKit rendering.
"""
from __future__ import annotations

import argparse
import hashlib
import json
from pathlib import Path
import struct
from typing import Iterable


EXT_BASE = 0x14000
PAGE = 0x4000
HEADER_LIMIT = 0x800
SEGMENT_NAME = b"__FQPATCH"
LC_SEGMENT_64 = 0x19
LC_SYMTAB = 0x2
LC_DYSYMTAB = 0xB
LC_ID_DYLIB = 0xD
LC_CODE_SIGNATURE = 0x1D
LC_FUNCTION_STARTS = 0x26
LC_DATA_IN_CODE = 0x29
LC_DYLD_EXPORTS_TRIE = 0x80000033
LC_DYLD_CHAINED_FIXUPS = 0x80000034
LINKEDIT_DATA = {
    LC_CODE_SIGNATURE, LC_FUNCTION_STARTS, LC_DATA_IN_CODE,
    LC_DYLD_EXPORTS_TRIE, LC_DYLD_CHAINED_FIXUPS,
}
ALLOWED_COMMANDS = LINKEDIT_DATA | {
    LC_SEGMENT_64, LC_SYMTAB, LC_DYSYMTAB, LC_ID_DYLIB,
    0xC,       # LC_LOAD_DYLIB, whose string offset is command-relative.
    0x1B,      # LC_UUID.
    0x2C,      # LC_ENCRYPTION_INFO_64; the supported image is unencrypted.
    0x32,      # LC_BUILD_VERSION.
}


def need(condition: bool, message: str) -> None:
    if not condition:
        raise ValueError(message)


def align(value: int, alignment: int) -> int:
    return (value + alignment - 1) // alignment * alignment


def commands(data: bytes) -> list[dict]:
    need(len(data) >= 32, "Truncated Mach-O header")
    magic, cpu, subtype, kind, count, length, flags, reserved = struct.unpack_from("<8I", data)
    need((magic, cpu, kind) == (0xFEEDFACF, 0x100000C, 6), "Expected ARM64 Mach-O dylib")
    need(count <= 64 and 32 + length <= len(data), "Invalid load-command span")
    result, cursor = [], 32
    for _ in range(count):
        need(cursor + 8 <= 32 + length, "Truncated load command")
        cmd, size = struct.unpack_from("<II", data, cursor)
        need(size >= 8 and size % 8 == 0 and cursor + size <= 32 + length,
             "Invalid load-command size")
        need(cmd in ALLOWED_COMMANDS, f"Unsupported load command {cmd:#x}")
        result.append({"cmd": cmd, "offset": cursor, "size": size,
                       "raw": data[cursor:cursor + size]})
        cursor += size
    need(cursor == 32 + length, "Load commands do not fill sizeofcmds")
    return result


def one(items: Iterable[dict], kind: int) -> dict:
    found = [item for item in items if item["cmd"] == kind]
    need(len(found) == 1, f"Expected exactly one command {kind:#x}")
    return found[0]


def segments(data: bytes) -> list[dict]:
    result = []
    for command in commands(data):
        if command["cmd"] != LC_SEGMENT_64:
            continue
        raw = command["raw"]
        need(len(raw) >= 72, "Short LC_SEGMENT_64")
        name, vm, vmsize, off, size, maximum, initial, nsect, flags = struct.unpack_from(
            "<16s4Q4I", raw, 8)
        need(len(raw) == 72 + nsect * 80, "Invalid segment section count")
        result.append({"name": name.rstrip(b"\0").decode("ascii"),
                       "vmaddr": vm, "vmsize": vmsize,
                       "fileoff": off, "filesize": size,
                       "maxprot": maximum, "initprot": initial,
                       "nsects": nsect, "flags": flags,
                       "command_offset": command["offset"],
                       "raw": raw})
    return result


def _linkedit_range(data: bytes, command: dict) -> tuple[int, int]:
    need(command["size"] == 16, "Invalid linkedit_data_command size")
    off, size = struct.unpack_from("<II", command["raw"], 8)
    need(off + size <= len(data), "Linkedit data range exceeds image")
    return off, size


def _signature(data: bytes) -> dict:
    command = one(commands(data), LC_CODE_SIGNATURE)
    off, size = _linkedit_range(data, command)
    need(off + size == len(data) and size >= 24 + 88, "Signature must end image")
    magic, length, count = struct.unpack_from(">III", data, off)
    need((magic, length, count) == (0xFADE0CC0, size, 1), "Unsupported signature envelope")
    slot, relative = struct.unpack_from(">II", data, off + 12)
    need(slot == 0 and relative == 24 and data[off + 20:off + 24] == bytes(4),
         "Expected one aligned CodeDirectory signature slot")
    cd = off + relative
    values = struct.unpack_from(">9I", data, cd)
    cmagic, clen, version, flags, hash_offset, ident_offset, special, slots, limit = values
    need(cmagic == 0xFADE0C02 and cd + clen == len(data), "Invalid CodeDirectory span")
    need(version == 0x20400 and flags == 0x20002 and special == 0,
         "Unsupported ad-hoc CodeDirectory type")
    hash_size, hash_type, platform, page_log = struct.unpack_from(">4B", data, cd + 36)
    need((hash_size, hash_type, platform, page_log) == (32, 2, 0, 12),
         "Expected SHA-256 code hashes with 4 KiB pages")
    need(limit == off and slots == (limit + 4095) // 4096,
         "Invalid signature codeLimit/page count")
    need(ident_offset == 88 and hash_offset >= ident_offset + 1 and
         hash_offset + slots * hash_size == clen, "Invalid signature hash/identifier offsets")
    need(data[cd + 40:cd + 64] == bytes(24), "Unsupported scatter/team/64-bit-limit fields")
    ident_end = data.find(b"\0", cd + ident_offset, cd + hash_offset)
    need(ident_end != -1, "Unterminated CodeDirectory identifier")
    need(not any(data[ident_end:cd + hash_offset]), "Nonzero signature identifier padding")
    identifier = data[cd + ident_offset:ident_end].decode("utf-8")
    exec_base, exec_limit, exec_flags = struct.unpack_from(">3Q", data, cd + 64)
    need((exec_base, exec_limit, exec_flags) == (0, 0x10000, 0),
         "Unsupported CodeDirectory __TEXT range/flags")
    return {"signature_offset": off, "signature_size": size,
            "directory_offset": cd, "directory_size": clen,
            "code_limit": limit, "code_slots": slots, "hash_offset": hash_offset,
            "identifier": identifier, "version": version, "flags": flags,
            "exec_segment_base": exec_base, "exec_segment_limit": exec_limit,
            "exec_segment_flags": exec_flags}


def verify_signature(data: bytes) -> dict:
    """Verify all signed pages, including the appended executable segment."""
    data = bytes(data)
    result = _signature(data)
    bad = []
    for slot in range(result["code_slots"]):
        start = slot * 4096
        digest = hashlib.sha256(data[start:min(start + 4096, result["code_limit"])]).digest()
        at = result["directory_offset"] + result["hash_offset"] + 32 * slot
        if data[at:at + 32] != digest:
            bad.append(slot)
    result.update(page_hashes_valid=not bad, invalid_pages=bad,
                  sha256=hashlib.sha256(data).hexdigest(),
                  cdhash=hashlib.sha256(data[result["directory_offset"]:]).digest()[:20].hex(),
                  device_acceptance_tested=False)
    return result


def fixup_semantics(data: bytes) -> dict:
    """Parse every supported chained slot instead of trusting unchanged counts."""
    command = one(commands(data), LC_DYLD_CHAINED_FIXUPS)
    base, size = _linkedit_range(data, command)
    need(size == 0x2A0, "Unsupported chained-fixup blob size")
    blob = data[base:base + size]
    version, start, imports_off, symbols_off, count, form, symbol_form = struct.unpack_from("<7I", blob)
    need((version, imports_off, symbols_off, count, form, symbol_form) == (0, 72, 164, 23, 1, 0),
         "Unsupported chained-fixup header")
    need(start in (28, 32), "Unexpected chained starts offset")
    segment_count = struct.unpack_from("<I", blob, start)[0]
    image_segments = segments(data)
    need(segment_count == len(image_segments), "Chained starts/segment count mismatch")
    offsets = list(struct.unpack_from("<" + "I" * segment_count, blob, start + 4))
    expected = [0, 16, 0] if segment_count == 3 else [0, 20, 0, 0]
    need(offsets == expected and start + offsets[1] == 48,
         "Unsupported chained starts segment table")
    imports = []
    for ordinal in range(count):
        packed = struct.unpack_from("<I", blob, imports_off + 4 * ordinal)[0]
        name_off = symbols_off + (packed >> 9)
        need(symbols_off <= name_off < len(blob), "Import name outside string pool")
        end = blob.find(b"\0", name_off)
        need(end != -1, "Unterminated chained import name")
        imports.append((packed, blob[name_off:end].decode("utf-8")))
    chains = []
    for index, relative in enumerate(offsets):
        if relative == 0:
            continue
        at = start + relative
        s_size, page_size, pointer_format, segment_offset, max_pointer, page_count = struct.unpack_from(
            "<IHHQIH", blob, at)
        need((s_size, page_size, pointer_format, segment_offset, max_pointer, page_count) ==
             (24, 0x4000, 2, 0x10000, 0, 1), "Unsupported chained segment starts")
        segment = image_segments[index]
        need(segment["vmaddr"] == segment_offset and segment["name"] == "__DATA_CONST",
             "Chained segment index targets the wrong mapped segment")
        for page_index in range(page_count):
            page_start = struct.unpack_from("<H", blob, at + 22 + page_index * 2)[0]
            if page_start == 0xFFFF:
                continue
            need(page_start < 0x8000, "Multi-start chain is outside supported image format")
            location = page_index * page_size + page_start
            seen = set()
            while True:
                need(location not in seen, "Chained fixup loop")
                seen.add(location)
                need(location + 8 <= min(segment["filesize"], (page_index + 1) * page_size),
                     "Chained fixup exceeds segment/page")
                file_at = segment["fileoff"] + location
                raw = struct.unpack_from("<Q", data, file_at)[0]
                next_units = (raw >> 51) & 0xFFF
                if raw >> 63:
                    ordinal = raw & 0xFFFFFF
                    need(ordinal < count and (raw >> 32) & 0x7FFFF == 0,
                         "Invalid chained bind ordinal/reserved fields")
                    addend = (raw >> 24) & 0xFF
                    addend = addend - 256 if addend >= 128 else addend
                    target = ("bind", ordinal, addend, imports[ordinal])
                else:
                    need((raw >> 44) & 0x7F == 0, "Invalid chained rebase reserved bits")
                    target = ("rebase", (raw & ((1 << 36) - 1)) | (((raw >> 36) & 0xFF) << 56))
                chains.append((segment["vmaddr"] + location, raw, next_units, target))
                if next_units == 0:
                    break
                location += next_units * 4
    need(len(chains) == 656, "Unexpected number of chained fixup slots")
    need(len({item[0] for item in chains}) == len(chains), "Duplicate chained pointer location")
    return {"segment_count": segment_count, "starts_offset": start,
            "segment_offsets": offsets, "imports": imports, "chains": chains,
            "imports_and_symbols": blob[imports_off:], "segment_starts": blob[48:72]}


def _validate_source(data: bytes) -> tuple[list[dict], list[dict], dict]:
    cmds, segs, signature = commands(data), segments(data), _signature(data)
    need([s["name"] for s in segs] == ["__TEXT", "__DATA_CONST", "__LINKEDIT"],
         "Input already extended or has unfamiliar segments")
    need([(s["vmaddr"], s["fileoff"], s["filesize"], s["vmsize"],
           s["initprot"], s["maxprot"], s["nsects"]) for s in segs[:2]] ==
         [(0, 0, 0x10000, 0x10000, 5, 5, 8),
          (0x10000, 0x10000, 0x4000, 0x4000, 3, 3, 4)],
         "Original executable/data layout does not match the supported image")
    last = segs[-1]
    need(last["vmaddr"] == last["fileoff"] == EXT_BASE and
         last["fileoff"] + last["filesize"] == len(data) and
         last["nsects"] == 0 and last["initprot"] == last["maxprot"] == 1,
         "Unsupported original LINKEDIT mapping")
    header_end = 32 + struct.unpack_from("<I", data, 20)[0]
    need(header_end + 72 <= HEADER_LIMIT and not any(data[header_end:header_end + 72]),
         "No unused header padding for one segment load command")
    crypt = one(cmds, 0x2C)
    need(struct.unpack_from("<4I", crypt["raw"], 8) == (0x4000, 0xC000, 0, 0),
         "Unsupported encryption range or nonzero cryptid")
    need(signature["signature_offset"] >= EXT_BASE, "Signature is outside LINKEDIT")
    fixups = fixup_semantics(data)
    need(all(row[3][0] != "rebase" or 0 <= row[3][1] < EXT_BASE
             for row in fixups["chains"]),
         "A source rebase points into the LINKEDIT range that would move")
    return cmds, segs, signature


def _relocate_offset(offset: int, size: int, old_start: int, old_limit: int, delta: int) -> int:
    if offset == 0:
        need(size == 0, "Nonempty LINKEDIT table with zero offset")
        return 0
    need(old_start <= offset <= old_limit and offset + size <= old_limit,
         f"LINKEDIT reference outside preserved range: {offset:#x}+{size:#x}")
    return offset + delta


def _code_directory(identifier: str, limit: int, source_signature: dict) -> bytearray:
    identity = identifier.encode("utf-8") + b"\0"
    need(1 < len(identity) <= 256 and b"\0" not in identity[:-1], "Invalid signing identifier")
    # A 24-byte SuperBlob prefix plus this hash offset is 16-byte aligned.
    hash_offset = align(88 + len(identity) + 8, 16) - 8
    slots = (limit + 4095) // 4096
    directory_length = hash_offset + slots * 32
    result = bytearray(24 + directory_length)
    struct.pack_into(">5I", result, 0, 0xFADE0CC0, len(result), 1, 0, 24)
    struct.pack_into(">9I", result, 24, 0xFADE0C02, directory_length, 0x20400,
                     0x20002, hash_offset, 88, 0, slots, limit)
    struct.pack_into(">4B", result, 24 + 36, 32, 2, 0, 12)
    struct.pack_into(">3Q", result, 24 + 64,
                     source_signature["exec_segment_base"],
                     source_signature["exec_segment_limit"],
                     source_signature["exec_segment_flags"])
    result[24 + 88:24 + 88 + len(identity)] = identity
    return result


def extend(input_bytes: bytes, extension_bytes: bytes, *, capacity: int | None = None,
           identifier: str | None = None) -> bytes:
    """Return an extended and rehashed copy; input may contain prior code edits.

    Caller owns all code/version/UUID edits before invoking this function.  It
    may pass a stale ad-hoc page-hash array because the final image is signed
    here after every load-command byte has its final value.
    """
    data, extension = bytes(input_bytes), bytes(extension_bytes)
    cmds, segs, old_signature = _validate_source(data)
    if capacity is None:
        capacity = align(max(len(extension), 1), PAGE)
    need(capacity in (PAGE, 2 * PAGE, 3 * PAGE), "Extension capacity must be 0x4000, 0x8000 or 0xc000")
    need(0 < len(extension) <= capacity and len(extension) % 4 == 0,
         "Extension must contain aligned ARM64 bytes within capacity")
    if identifier is None:
        id_command = one(cmds, LC_ID_DYLIB)["raw"]
        at = struct.unpack_from("<I", id_command, 8)[0]
        need(24 <= at < len(id_command), "Invalid install-name offset")
        end = id_command.find(b"\0", at)
        need(end != -1, "Unterminated install name")
        identifier = id_command[at:end].decode("utf-8").rsplit("/", 1)[-1]
    new_signature_offset = old_signature["signature_offset"] + capacity
    signature = _code_directory(identifier, new_signature_offset, old_signature)
    new_total = new_signature_offset + len(signature)
    new_linkedit_size = new_total - (EXT_BASE + capacity)
    extension_command = struct.pack("<II16s4Q4I", LC_SEGMENT_64, 72,
                                    SEGMENT_NAME, EXT_BASE, capacity, EXT_BASE,
                                    capacity, 5, 5, 0, 0)
    built_commands = []
    for item in cmds:
        raw = bytearray(item["raw"])
        kind = item["cmd"]
        if kind == LC_SEGMENT_64 and raw[8:24].rstrip(b"\0") == b"__LINKEDIT":
            built_commands.append(extension_command)
            struct.pack_into("<4Q", raw, 24, EXT_BASE + capacity,
                             align(new_linkedit_size, PAGE), EXT_BASE + capacity,
                             new_linkedit_size)
        elif kind in LINKEDIT_DATA:
            offset, size = struct.unpack_from("<II", raw, 8)
            if kind == LC_CODE_SIGNATURE:
                offset, size = new_signature_offset, len(signature)
            else:
                offset = _relocate_offset(offset, size, EXT_BASE,
                                          old_signature["signature_offset"], capacity)
            struct.pack_into("<II", raw, 8, offset, size)
        elif kind == LC_SYMTAB:
            symbol_off, symbol_count, string_off, string_size = struct.unpack_from("<4I", raw, 8)
            struct.pack_into("<4I", raw, 8,
                             _relocate_offset(symbol_off, symbol_count * 16, EXT_BASE,
                                              old_signature["signature_offset"], capacity),
                             symbol_count,
                             _relocate_offset(string_off, string_size, EXT_BASE,
                                              old_signature["signature_offset"], capacity),
                             string_size)
        elif kind == LC_DYSYMTAB:
            fields = list(struct.unpack_from("<18I", raw, 8))
            for field, unit_size in ((6, 8), (8, 56), (10, 4), (12, 4), (14, 8), (16, 8)):
                fields[field] = _relocate_offset(fields[field], fields[field + 1] * unit_size,
                                                 EXT_BASE, old_signature["signature_offset"], capacity)
            struct.pack_into("<18I", raw, 8, *fields)
        built_commands.append(bytes(raw))
    header = b"".join(built_commands)
    need(32 + len(header) <= HEADER_LIMIT, "Expanded load commands exceed header padding")
    output = bytearray(data[:EXT_BASE])
    output.extend(extension)
    output.extend(bytes(capacity - len(extension)))
    output.extend(data[EXT_BASE:old_signature["signature_offset"]])
    output.extend(signature)
    output[32:32 + len(header)] = header
    struct.pack_into("<II", output, 16, len(built_commands), len(header))
    # Segment-starts stays at +48, imports at +72, symbols at +164.
    fixup_offset, _ = _linkedit_range(bytes(output), one(commands(bytes(output)), LC_DYLD_CHAINED_FIXUPS))
    need(output[fixup_offset + 28:fixup_offset + 32] == bytes(4),
         "Required chained-header padding is occupied")
    struct.pack_into("<I", output, fixup_offset + 4, 28)
    struct.pack_into("<5I", output, fixup_offset + 28, 4, 0, 20, 0, 0)
    cd = new_signature_offset + 24
    hash_offset = struct.unpack_from(">I", output, cd + 16)[0]
    slots = struct.unpack_from(">I", output, cd + 28)[0]
    for slot in range(slots):
        start = slot * 4096
        digest = hashlib.sha256(output[start:min(start + 4096, new_signature_offset)]).digest()
        output[cd + hash_offset + slot * 32:cd + hash_offset + (slot + 1) * 32] = digest
    result = bytes(output)
    verify_extension(data, result, extension)
    return result


def verify_extension(input_bytes: bytes, output_bytes: bytes,
                     extension_bytes: bytes | None = None) -> dict:
    """Check maps, command relocation, all fixups/imports and signed pages."""
    old, new = bytes(input_bytes), bytes(output_bytes)
    old_cmds, old_segs, old_sig = _validate_source(old)
    new_cmds, new_segs = commands(new), segments(new)
    need([s["name"] for s in new_segs] == ["__TEXT", "__DATA_CONST", "__FQPATCH", "__LINKEDIT"],
         "Unexpected output segment order")
    extension = new_segs[2]
    capacity = extension["filesize"]
    need(capacity in (PAGE, 2 * PAGE, 3 * PAGE) and
         extension["vmaddr"] == extension["fileoff"] == EXT_BASE and
         extension["vmsize"] == capacity and extension["initprot"] == extension["maxprot"] == 5 and
         extension["nsects"] == extension["flags"] == 0,
         "Invalid extension mapping/protections")
    need([s["raw"] for s in old_segs[:2]] == [s["raw"] for s in new_segs[:2]],
         "Original TEXT/DATA load commands changed")
    for index, seg in enumerate(new_segs):
        need(seg["vmaddr"] == seg["fileoff"], "File offset/VM address identity lost")
        need(seg["filesize"] <= seg["vmsize"] and seg["fileoff"] + seg["filesize"] <= len(new),
             "Output segment exceeds its VM or file mapping")
        need(seg["fileoff"] % PAGE == 0, "Non-16-KiB segment start")
        need(not (seg["initprot"] & 2 and seg["initprot"] & 4), "Writable executable segment")
        if index:
            prev = new_segs[index - 1]
            need(prev["vmaddr"] + prev["vmsize"] <= seg["vmaddr"] and
                 prev["fileoff"] + prev["filesize"] <= seg["fileoff"], "Overlapping segments")
    need(new_segs[-1]["initprot"] == new_segs[-1]["maxprot"] == 1 and
         new_segs[-1]["fileoff"] == EXT_BASE + capacity and
         new_segs[-1]["fileoff"] + new_segs[-1]["filesize"] == len(new),
         "LINKEDIT is not the final read-only mapping")
    old_header_end = 32 + struct.unpack_from("<I", old, 20)[0]
    new_header_end = 32 + struct.unpack_from("<I", new, 20)[0]
    need(new_header_end == old_header_end + 72 <= HEADER_LIMIT,
         "Incorrect expanded header length")
    need(new[:16] == old[:16] and new[24:32] == old[24:32], "Unexpected Mach-O header change")
    need(new[new_header_end:EXT_BASE] == old[new_header_end:EXT_BASE],
         "Extension altered existing code, constants, original pointer slots or padding")
    old_fixups, new_fixups = fixup_semantics(old), fixup_semantics(new)
    for field in ("chains", "imports", "imports_and_symbols", "segment_starts"):
        need(old_fixups[field] == new_fixups[field], "Changed chained-fixup semantics: " + field)
    new_sig = verify_signature(new)
    need(new_sig["page_hashes_valid"], "Expanded image page hashes do not verify")
    need(new_sig["signature_offset"] == old_sig["signature_offset"] + capacity,
         "Signature offset does not follow preserved LINKEDIT data")
    moved_old = old[EXT_BASE:old_sig["signature_offset"]]
    moved_new = new[EXT_BASE + capacity:new_sig["signature_offset"]]
    need(len(moved_old) == len(moved_new), "LINKEDIT content length changed")
    fixup_old_base, _ = _linkedit_range(old, one(old_cmds, LC_DYLD_CHAINED_FIXUPS))
    permit = {fixup_old_base - EXT_BASE + i for i in (*range(4, 8), *range(28, 48))}
    need(all(a == b or i in permit for i, (a, b) in enumerate(zip(moved_old, moved_new))),
         "Unexpected relocated LINKEDIT content mutation")
    stripped = [c for c in new_cmds if not (c["cmd"] == LC_SEGMENT_64 and
                 c["raw"][8:24].rstrip(b"\0") == SEGMENT_NAME)]
    need(len(stripped) == len(old_cmds), "Added or removed an unrelated load command")
    for before, after in zip(old_cmds, stripped):
        need(before["cmd"] == after["cmd"] and before["size"] == after["size"],
             "Original command order or size changed")
        kind = before["cmd"]
        a, b = before["raw"], after["raw"]
        if kind in LINKEDIT_DATA:
            ao, az = struct.unpack_from("<II", a, 8)
            bo, bz = struct.unpack_from("<II", b, 8)
            need(bo == (ao + capacity if ao else 0), "Incorrect linkedit_data relocation")
            if kind == LC_CODE_SIGNATURE:
                need(bz == new_sig["signature_size"], "Wrong signature load-command size")
            else:
                need(az == bz, "Changed non-signature LINKEDIT data size")
        elif kind == LC_SYMTAB:
            x, y = struct.unpack_from("<4I", a, 8), struct.unpack_from("<4I", b, 8)
            need(y == (x[0] + capacity, x[1], x[2] + capacity, x[3]),
                 "Incorrect symbol/string table relocation")
        elif kind == LC_DYSYMTAB:
            x, y = list(struct.unpack_from("<18I", a, 8)), list(struct.unpack_from("<18I", b, 8))
            for index in (6, 8, 10, 12, 14, 16):
                if x[index]:
                    x[index] += capacity
            need(x == y, "Incorrect dynamic-symbol table relocation")
        elif kind == LC_SEGMENT_64 and a[8:24].rstrip(b"\0") == b"__LINKEDIT":
            need(a[:24] == b[:24] and a[56:] == b[56:], "Unexpected LINKEDIT metadata change")
        else:
            need(a == b, "Unrelated load-command bytes changed")
    if extension_bytes is not None:
        payload = bytes(extension_bytes)
        need(new[EXT_BASE:EXT_BASE + len(payload)] == payload,
             "Extension payload differs from assembly bytes")
        need(not any(new[EXT_BASE + len(payload):EXT_BASE + capacity]),
             "Nonzero unused extension padding")
    return {"passed": True, "extension_base": EXT_BASE, "capacity": capacity,
            "payload_bytes": len(extension_bytes) if extension_bytes is not None else None,
            "source_sha256": hashlib.sha256(old).hexdigest(),
            "candidate_sha256": hashlib.sha256(new).hexdigest(), "size_bytes": len(new),
            "header_end": new_header_end,
            "segments": [{k: v for k, v in s.items() if k != "raw"} for s in new_segs],
            "original_text_data_bytes_preserved": True,
            "original_section_numbers_preserved": True,
            "original_fixup_slots_preserved": len(old_fixups["chains"]),
            "original_import_records_preserved": len(old_fixups["imports"]),
            "chained_starts_offset": new_fixups["starts_offset"],
            "chained_segment_count": new_fixups["segment_count"],
            "signature": new_sig,
            "limits": ["No iOS/dyld load or signing-policy acceptance was executed.",
                       "No new unwind table or function-start metadata is supplied for the assembly extension.",
                       "ARM64 instruction/ABI and UIKit behavior require separate audits."]}


def main() -> None:
    parser = argparse.ArgumentParser(description=__doc__)
    sub = parser.add_subparsers(dest="command", required=True)
    build = sub.add_parser("build")
    build.add_argument("source", type=Path)
    build.add_argument("extension", type=Path)
    build.add_argument("output", type=Path)
    build.add_argument("--capacity", type=lambda value: int(value, 0))
    build.add_argument("--identifier")
    check = sub.add_parser("verify")
    check.add_argument("source", type=Path)
    check.add_argument("candidate", type=Path)
    check.add_argument("--extension", type=Path)
    args = parser.parse_args()
    original = args.source.read_bytes()
    if args.command == "build":
        need(args.source.resolve() != args.output.resolve(), "Refusing to overwrite input")
        payload = args.extension.read_bytes()
        candidate = extend(original, payload, capacity=args.capacity, identifier=args.identifier)
        report = verify_extension(original, candidate, payload)
        args.output.parent.mkdir(parents=True, exist_ok=True)
        args.output.write_bytes(candidate)
    else:
        payload = args.extension.read_bytes() if args.extension else None
        report = verify_extension(original, args.candidate.read_bytes(), payload)
    print(json.dumps(report, ensure_ascii=False, indent=2))


if __name__ == "__main__":
    main()
