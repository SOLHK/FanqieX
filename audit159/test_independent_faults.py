#!/usr/bin/env python3
"""Fault-injection tests for the independent audit, never the production builder.

Most mutations are rehashed with an independent local SHA256 implementation so
that a bad layout/reference cannot pass merely because its page signature is
valid. Mutated candidates exist only in memory and are never delivered.
"""
import argparse
import hashlib
import json
from pathlib import Path
import struct

from independent159 import (
    Image, audit, direct_instruction, read_signature, read_tables, require, unpack,
)


def main():
    parser = argparse.ArgumentParser(description=__doc__)
    parser.add_argument("candidate", type=Path)
    parser.add_argument("--baseline", type=Path, required=True)
    parser.add_argument("--report", type=Path, required=True)
    args = parser.parse_args()
    data, baseline = args.candidate.read_bytes(), args.baseline.read_bytes()
    good = audit(baseline, data)
    require(good["passed"], "Positive control must pass before mutation tests")
    image = Image(data)
    tables = read_tables(image, "1.5.9")
    signature = read_signature(image)
    cd = signature["directory_offset"]
    rows = []

    def rehash(mutated):
        for slot in range(signature["code_slots"]):
            start = slot * 4096
            at = cd + signature["hash_offset"] + slot * 32
            mutated[at:at + 32] = hashlib.sha256(mutated[start:min(start + 4096, cd - 24)]).digest()

    def case(name, mutate, expected_check, resign=True):
        mutated = bytearray(data)
        mutate(mutated)
        if resign:
            rehash(mutated)
        result = audit(baseline, bytes(mutated))
        check = result["checks"].get(expected_check)
        require(not result["passed"] and check and not check["passed"],
                f"Fault escaped its gate: {name}, expected {expected_check}")
        if resign and expected_check != "parse":
            require(result["checks"]["code_signature"]["passed"],
                    f"Rehashed fault {name} failed only because of signing")
        rows.append({"name": name, "expected_rejection": expected_check,
                     "rejected": True, "page_hashes_recomputed": resign,
                     "reason": check["error"]})

    def u32(offset, value):
        return lambda blob: struct.pack_into("<I", blob, offset, value)

    def u64(offset, value):
        return lambda blob: struct.pack_into("<Q", blob, offset, value)

    def be32(offset, value):
        return lambda blob: struct.pack_into(">I", blob, offset, value)

    def flip(offset, mask=1):
        return lambda blob: blob.__setitem__(offset, blob[offset] ^ mask)

    patch = image.segment("__FQPATCH")["command"]["offset"]
    fixups, _ = image.link_range(0x80000034)
    dysym = image.one(0xB)["offset"]
    symtab = image.one(0x2)["offset"]
    symoff = unpack("<I", data, symtab + 8)[0]
    dependency = next(c for c in image.commands if c["kind"] == 0xC)
    dependency_string = dependency["offset"] + unpack("<I", dependency["raw"], 8)[0]
    runtime_version = good["checks"]["version_consistency"]["details"]["runtime_constants"][0]["address"]

    case("unsigned_instruction_corruption", flip(0x14081), "code_signature", resign=False)
    case("wrong_macho_magic", flip(0), "parse")
    case("unreviewed_original_text_edit", flip(0x4010), "original_sections")
    case("changed_dylib_dependency", flip(dependency_string + 10), "load_commands")
    case("extension_initial_writable_executable", u32(patch + 60, 7), "layout")
    case("extension_maximum_writable_executable", u32(patch + 56, 7), "layout")
    case("unaligned_extension_capacity", u64(patch + 32, 0x9000), "layout")
    case("wrong_chained_segment_count", u32(fixups + 28, 3), "linkedit_and_chained_fixups")
    case("altered_chained_pointer", flip(0x10000), "linkedit_and_chained_fixups")
    case("changed_import_symbol", flip(fixups + 165), "linkedit_and_chained_fixups")
    indirect = unpack("<I", data, dysym + 56)[0]
    case("unmoved_indirect_symbols", u32(dysym + 56, indirect - 0x4000), "linkedit_and_chained_fixups")
    case("altered_nlist_table", flip(symoff + 8), "linkedit_and_chained_fixups")
    case("wrong_signature_slot_count", be32(cd + 28, signature["code_slots"] - 1),
         "code_signature", resign=False)
    case("wrong_signature_code_limit", be32(cd + 32, signature["code_limit"] - 4096),
         "code_signature", resign=False)
    identifier_start = cd + 88
    case("stale_signature_version", lambda blob: blob.__setitem__(
        slice(identifier_start, identifier_start + len(b"FanqieAdBlock-1.5.9.dylib")),
        b"FanqieAdBlock-1.5.8.dylib"), "version_consistency", resign=False)
    case("stale_settings_version", lambda blob: blob.__setitem__(0xEC84 + 8, ord("8")), "version_consistency")
    case("stale_shared_runtime_version", lambda blob: blob.__setitem__(runtime_version + 4, ord("8")),
         "version_consistency")
    case("nonzero_extension_reserved_word", u32(0x14010 + 24 * 4, 1), "repair_directories")
    gap_start = 0x800 + tables["main"]["end"]
    require(gap_start < 0x14000, "Expected main constants reserve for padding fault")
    case("occupied_reserved_data_gap", u32(gap_start, 1), "repair_directories")
    reader_branch = unpack("<I", data, 0x5D50)[0]
    case("wrong_reader_entry_target", u32(0x5D50, reader_branch + 1), "instruction_addresses")

    references = []
    for start, end in tables["code_ranges"]:
        for pc in range(start, end, 4):
            word = unpack("<I", data, pc)[0]
            decoded = direct_instruction(word, pc)
            if decoded and decoded[0] == "ADR":
                references.append((pc, word, decoded[1]))

    def adr_word(pc, target, register):
        delta = target - pc
        require(-(1 << 20) <= delta < (1 << 20), "ADR mutation is in ISA range")
        encoded = delta & ((1 << 21) - 1)
        return 0x10000000 | ((encoded & 3) << 29) | (((encoded >> 2) & 0x7FFFF) << 5) | register

    pc, word, _ = references[0]
    case("adr_to_unmapped_memory", u32(pc, adr_word(pc, 0x70000, word & 31)), "instruction_addresses")
    shared_refs = [row for row in references if row[2] == runtime_version and row[1] & 31 == 0]
    require(len(shared_refs) >= 2, "Shared version fault requires both event and export references")
    pc, word, target = shared_refs[-1]
    case("export_stops_using_shared_constant", u32(pc, adr_word(pc, target + 1, 0)), "version_consistency")

    old = audit(baseline, baseline, expected_version="1.5.8")
    require(not old["passed"] and not old["checks"]["version_consistency"]["passed"] and
            "1.5.7" in old["checks"]["version_consistency"]["error"],
            "The known 1.5.8 export-version bug must be rejected explicitly")
    require(all(value["passed"] for name, value in old["checks"].items() if name != "version_consistency"),
            "1.5.8 negative control must fail specifically on its stale version, not an unrelated gate")
    rows.append({"name": "original_158_stale_export_157", "expected_rejection": "version_consistency",
                 "rejected": True, "page_hashes_recomputed": False,
                 "reason": old["checks"]["version_consistency"]["error"]})
    report = {"passed": True, "candidate_sha256": good["candidate_sha256"],
              "positive_control_passed": True, "negative_controls": len(rows), "cases": rows,
              "device_tested": False}
    args.report.parent.mkdir(parents=True, exist_ok=True)
    args.report.write_text(json.dumps(report, indent=2) + "\n")
    print(json.dumps({"passed": True, "candidate_sha256": good["candidate_sha256"],
                      "negative_controls": len(rows), "report": str(args.report)}, indent=2))


if __name__ == "__main__":
    main()
