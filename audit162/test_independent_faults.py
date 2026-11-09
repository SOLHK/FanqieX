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
    parser.add_argument("--expected-version", choices=("1.6.2", "1.6.3", "1.6.4", "1.6.5", "1.6.6", "1.6.7", "1.6.8"), default="1.6.2")
    args = parser.parse_args()
    data, baseline = args.candidate.read_bytes(), args.baseline.read_bytes()
    good = audit(baseline, data, expected_version=args.expected_version)
    require(good["passed"], "Positive control must pass before mutation tests")
    image = Image(data)
    tables = read_tables(image, args.expected_version)
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
        result = audit(baseline, bytes(mutated), expected_version=args.expected_version)
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
    case("initial_material_reverted_to_clear", u32(0x649C, 0x52800022), "instruction_addresses")
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
        slice(identifier_start, identifier_start + len(f"FanqieX-{args.expected_version}.dylib")),
        b"FanqieX-1.5.8.dylib"), "version_consistency", resign=False)
    case("stale_settings_version", lambda blob: blob.__setitem__(0xEC84 + 8, ord("0")), "version_consistency")
    case("stale_shared_runtime_version", lambda blob: blob.__setitem__(runtime_version + 4, ord("0")),
         "version_consistency")
    reserved_word = {"1.6.2": 24, "1.6.3": 25, "1.6.4": 27, "1.6.5": 27, "1.6.6": 27, "1.6.8": 27}[args.expected_version]
    case("nonzero_extension_reserved_word", u32(0x14010 + reserved_word * 4, 1), "repair_directories")
    if args.expected_version in ("1.6.3", "1.6.4", "1.6.5", "1.6.6", "1.6.7", "1.6.8"):
        case("unaligned_hook_resolver", u32(0x14010 + 24 * 4, 1), "repair_directories")
    if args.expected_version in ("1.6.4", "1.6.5", "1.6.6", "1.6.7", "1.6.8"):
        unwind_slot = next(section for section in image.sections if section['name'] == '__unwind_info')
        unwind_at = unwind_slot['offset']
        page = unpack('<I', data, unwind_at + 32)[0]
        entry_at, entry_count = unpack('<HH', data, unwind_at + page + 4)
        native_frame = next(unwind_at + page + entry_at + 8 * i
            for i in range(entry_count)
            if unpack('<II', data, unwind_at + page + entry_at + 8 * i)[0] >= 0x14080
            and unpack('<II', data, unwind_at + page + entry_at + 8 * i)[1] & 0xFF000000 == 0x04000000)
        case('wrong_native_frame_registers', flip(native_frame + 4), 'original_sections')
        case('missing_native_frame_encoding', u32(native_frame + 4, 0), 'original_sections')
        case('wrong_unwind_page_kind', u32(unwind_at + page, 3), 'original_sections')
        case('nonzero_unwind_padding', flip(unwind_at + unwind_slot['size'] - 1), 'original_sections')
        case("unaligned_startup_installer", u32(0x14010 + 25 * 4, 1), "repair_directories")
        startup_branch = unpack("<I", data, 0x4650)[0]
        case("wrong_startup_installer_target", u32(0x4650, startup_branch + 1), "instruction_addresses")
        case("unreviewed_startup_adjacent_edit", flip(0x4654), "original_sections")
        case("unaligned_tabbar_spacing", u32(0x14010 + 26 * 4, 1), "repair_directories")
        tabbar_branch = unpack("<I", data, 0x6568)[0]
        case("wrong_tabbar_spacing_target", u32(0x6568, tabbar_branch + 1), "instruction_addresses")
        case("unreviewed_tabbar_adjacent_edit", flip(0x656C), "original_sections")
    gap_start = 0x800 + tables["main"]["end"]
    require(gap_start < 0x14000, "Expected main constants reserve for padding fault")
    case("occupied_reserved_data_gap", u32(gap_start, 1), "repair_directories")
    for pc in (0x5D50, 0x5DA0, 0x5DEC, 0x5E38):
        reader_branch = unpack("<I", data, pc)[0]
        case(f"wrong_reader_entry_target_{pc:x}", u32(pc, reader_branch + 1), "instruction_addresses")

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
    field_writes = {row['pc'] for row in good['checks']['version_consistency']['details']['shared_event_export_writes']}
    shared_refs = [row for row in references if row[2] == runtime_version and row[1] & 31 == 0
                   and row[0] in field_writes]
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
