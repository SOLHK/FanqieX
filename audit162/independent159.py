#!/usr/bin/env python3
"""Independent, standard-library-only audit of a rebuilt FanqieAdBlock image.

This module deliberately imports no production builder, Mach-O helper, runtime
mock, disassembler, or validator.  It reads the exact candidate bytes and checks
them against the pinned user-supplied 1.5.8 image.  A passing report establishes
the checks named in it; it does not establish iOS loading or UIKit behaviour.

The accepted format is intentionally narrow: this project's ARM64 dylib, its
reviewed patch sites, four segments, and 16/32/48/64 KiB executable extension.
"""
from __future__ import annotations

import argparse
import hashlib
import json
from pathlib import Path
import re
import struct
import sys


BASELINE_SHA256 = "55a2c02e5962ad740816aaf2f8f2f6d9269eb9ecce37c69402897ff3776a4354"
BASE = 0x800
EXT = 0x14000
PAGE = 0x4000
MAIN_NAMES = (
    "ratio layout installer repair strings end version reserved frame background restore "
    "edge_update edge_restore find round sync eligible visible message install_method "
    "busy_key scroll_key edge_key hidden_key parent_key selected_key sync_original "
    "restore_original proxy_frame material_update material_reset settings_boot ui_install "
    "ui_export ui_present diagnostic_init diagnostic_enqueue diagnostic_tick "
    "diagnostic_maintenance diagnostic_observe diagnostic_snapshot diagnostic_snapshot_all "
    "diagnostic_heartbeat describe_view describe_children string number dict_set uint now "
    "settings_trampoline signature_key bars_key ui_busy_key ui_sender_key code_end window "
    "find_record capture_edge restore_removed extension extension_code_end extension_strings "
    "extension_end"
).split()
EXT_NAMES = (
    "update restore native_update native_restore same_bottom_rect safe_tree monitor_start "
    "poll snapshot interaction_update interaction_restore pan should_begin style_control "
    "style_glyph code_end strings end native_key monitor_key owner_key timer_key tick_key "
    "rejected_key reserved24 reserved25 reserved26 reserved27"
).split()
READER_NAMES = (
    "reader_panel walk back_prepare back_restore image_alignment layout_observe finish "
    "control_busy_key busy_key owner_back_key back_owned_key back_original_key back_mode_key "
    "last_log_key"
).split()
PATCH_SITES = (
    (0x41D8, "installer", True), (0x4704, "settings_boot", False),
    (0x4CBC, "ui_install", True), (0x5B94, "ratio", False),
    (0x60B8, "sync", False), (0x6C84, "frame", True),
    (0x6CE8, "proxy_frame", True), (0x6DB4, "restore", False),
)
MODERN_LAYOUT_VERSIONS = ("1.6.2", "1.6.3", "1.6.4", "1.6.5", "1.6.6", "1.6.7", "1.6.9")
EXTENSION_PATCH_SITES = {
    "1.6.3": ((0x4878, "reserved24", False),),
    "1.6.4": ((0x4878, "reserved24", False), (0x4650, "reserved25", False),
              (0x6568, "reserved26", False), (0x46d8, "reserved27", True)),
}
EXTENSION_PATCH_SITES["1.6.5"] = EXTENSION_PATCH_SITES["1.6.4"]
EXTENSION_PATCH_SITES["1.6.6"] = EXTENSION_PATCH_SITES["1.6.5"]
EXTENSION_PATCH_SITES["1.6.9"] = EXTENSION_PATCH_SITES["1.6.6"]
ALLOWED_SECTION_BYTES = {
    address for start in [item[0] for item in PATCH_SITES] + [0x5D50, 0x5DA0, 0x5DEC, 0x5E38, 0x649C, 0x7848, 0x7AC4]
    for address in range(start, start + 4)
} | set(range(0xEC84, 0xEC8E))
LINK_DATA_COMMANDS = (0x1D, 0x26, 0x29, 0x80000033, 0x80000034)
ACCEPTED_COMMANDS = {0x19, 0x2, 0xB, 0xD, 0xC, 0x1B, 0x2C, 0x32, *LINK_DATA_COMMANDS}


class AuditError(ValueError):
    pass


def require(condition: bool, message: str):
    if not condition:
        raise AuditError(message)


def sha256(data: bytes) -> str:
    return hashlib.sha256(data).hexdigest()


def unpack(fmt: str, data: bytes, offset: int = 0):
    length = struct.calcsize(fmt)
    require(0 <= offset <= len(data) - length, f"Truncated {fmt} at {offset:#x}")
    return struct.unpack_from(fmt, data, offset)


def cstring(data: bytes, start: int, end: int) -> str:
    require(0 <= start < end <= len(data), "Invalid C-string bounds")
    stop = data.find(b"\0", start, end)
    require(stop >= 0, f"Unterminated C string at {start:#x}")
    return data[start:stop].decode("utf-8")


def rounded(value: int, boundary: int) -> int:
    return (value + boundary - 1) // boundary * boundary


def signed(value: int, bits: int) -> int:
    return value - (1 << bits) if value & (1 << (bits - 1)) else value


class Image:
    def __init__(self, data: bytes):
        self.data = data
        self.header = unpack("<8I", data)
        magic, cpu, subtype, kind, count, span, flags, reserved = self.header
        require((magic, cpu, subtype, kind, flags, reserved) ==
                (0xFEEDFACF, 0x100000C, 0, 6, 0x100085, 0),
                "Unexpected Mach-O magic/CPU/subtype/type/flags/reserved")
        require(count == 20 and 32 + span == 0x7C0,
                "Unexpected load-command count or header boundary")
        self.commands = []
        self.segments = []
        self.sections = []
        cursor = 32
        for _ in range(count):
            command, size = unpack("<2I", data, cursor)
            require(command in ACCEPTED_COMMANDS, f"Unreviewed load command {command:#x}")
            require(size >= 8 and size % 8 == 0 and cursor + size <= 32 + span,
                    f"Invalid load command at {cursor:#x}")
            raw = data[cursor:cursor + size]
            entry = {"kind": command, "offset": cursor, "size": size, "raw": raw}
            self.commands.append(entry)
            if command == 0x19:
                values = unpack("<16s4Q4I", raw, 8)
                name = values[0].rstrip(b"\0").decode("ascii")
                keys = ("vmaddr", "vmsize", "fileoff", "filesize", "maxprot",
                        "initprot", "nsects", "flags")
                segment = dict(zip(keys, values[1:]))
                segment.update(name=name, command=entry)
                require(size == 72 + 80 * segment["nsects"], "Invalid section table size")
                require(segment["fileoff"] + segment["filesize"] <= len(data),
                        f"Segment exceeds file: {name}")
                self.segments.append(segment)
                for index in range(segment["nsects"]):
                    fields = unpack("<16s16sQQ8I", raw, 72 + index * 80)
                    section = dict(zip(
                        ("name", "segment", "address", "size", "offset", "align",
                         "reloff", "nreloc", "flags", "reserved1", "reserved2", "reserved3"),
                        fields))
                    section["name"] = fields[0].rstrip(b"\0").decode("ascii")
                    section["segment"] = fields[1].rstrip(b"\0").decode("ascii")
                    require(section["segment"] == name, "Section names wrong segment")
                    require(section["offset"] + section["size"] <= len(data), "Section exceeds file")
                    require(section["reloff"] == section["nreloc"] == 0,
                            "Unexpected section relocations")
                    self.sections.append(section)
            cursor += size
        require(cursor == 32 + span, "Commands do not exactly fill sizeofcmds")
        require([s["name"] for s in self.segments] ==
                ["__TEXT", "__DATA_CONST", "__FQPATCH", "__LINKEDIT"],
                "Expected the four reviewed segments in order")

    def one(self, kind: int) -> dict:
        found = [c for c in self.commands if c["kind"] == kind]
        require(len(found) == 1, f"Expected one load command {kind:#x}")
        return found[0]

    def segment(self, name: str) -> dict:
        return next(s for s in self.segments if s["name"] == name)

    def link_range(self, kind: int) -> tuple[int, int]:
        command = self.one(kind)
        require(command["size"] == 16, "Invalid linkedit_data_command size")
        start, length = unpack("<2I", command["raw"], 8)
        require(start + length <= len(self.data), "LINKEDIT command exceeds file")
        return start, length

    def vm_file(self, address: int, length: int = 1) -> int:
        for segment in self.segments:
            delta = address - segment["vmaddr"]
            if 0 <= delta and delta + length <= segment["filesize"]:
                return segment["fileoff"] + delta
        raise AuditError(f"Unmapped file-backed address {address:#x}+{length:#x}")


def check_layout(old: Image, new: Image) -> dict:
    require(new.header == old.header, "Original Mach-O header changed")
    require(new.sections == old.sections, "Original section metadata changed")
    for name in ("__TEXT", "__DATA_CONST"):
        require(new.segment(name)["command"]["raw"] == old.segment(name)["command"]["raw"],
                f"Original segment changed: {name}")
    patch = new.segment("__FQPATCH")
    require(patch["vmaddr"] == patch["fileoff"] == EXT, "Extension has wrong start address")
    require(patch["vmsize"] == patch["filesize"] and
            patch["vmsize"] in (0x4000, 0x8000, 0xC000, 0x10000, 0x20000), "Unsupported reviewed extension capacity")
    require((patch["maxprot"], patch["initprot"], patch["nsects"], patch["flags"]) == (5, 5, 0, 0),
            "Extension must be RX, sectionless, and have no flags")
    link = new.segment("__LINKEDIT")
    require(link["vmaddr"] == link["fileoff"] == EXT + patch["vmsize"],
            "LINKEDIT did not move immediately after extension")
    require(link["filesize"] == len(new.data) - link["fileoff"] and
            link["vmsize"] == rounded(link["filesize"], PAGE), "Invalid LINKEDIT mapped size")
    require((link["maxprot"], link["initprot"], link["nsects"], link["flags"]) == (1, 1, 0, 0),
            "LINKEDIT must remain read-only and sectionless")
    for previous, current in zip(new.segments, new.segments[1:]):
        require(previous["vmaddr"] + previous["vmsize"] <= current["vmaddr"], "Overlapping VM segments")
        require(previous["fileoff"] + previous["filesize"] <= current["fileoff"], "Overlapping file segments")
    for segment in new.segments:
        require(segment["vmaddr"] % PAGE == segment["fileoff"] % PAGE ==
                segment["vmsize"] % PAGE == 0, "Segment violates 16 KiB alignment")
        require(segment["filesize"] <= segment["vmsize"], "Segment file size exceeds VM size")
        require(not (segment["maxprot"] & 2 and segment["maxprot"] & 4) and
                not (segment["initprot"] & 2 and segment["initprot"] & 4), "W+X segment found")
    require(not any(new.data[0x7C0:BASE]), "Nonzero header padding")
    crypt = new.one(0x2C)
    require(unpack("<I", crypt["raw"], 16)[0] == 0, "Encrypted input is not supported")
    return {"segment_count": 4, "original_section_count": len(new.sections),
            "extension_capacity": patch["filesize"], "extension_protection": "RX",
            "linkedit_fileoff": link["fileoff"], "writable_executable_segments": 0}


def check_sections(old: Image, new: Image, version: str) -> dict:
    extra_sites = [pc for pc, _, _ in EXTENSION_PATCH_SITES.get(version, ())]
    allowed = ALLOWED_SECTION_BYTES | {byte for pc in extra_sites for byte in range(pc, pc + 4)}
    if version in ("1.6.5", "1.6.6", "1.6.7", "1.6.9"):
        allowed |= set(range(0x4018,0x4020))
    unwind = None
    if version in ('1.6.4', '1.6.5', '1.6.6', '1.6.7', '1.6.9'):
        # Allow only a completely validated, compiler-frame-matching replacement
        # of this metadata slot; every original function entry stays identical.
        from unwind_audit import check_native_unwind
        unwind = check_native_unwind(old.data, new.data)
        slot = next(section for section in old.sections if section['name'] == '__unwind_info')
        allowed |= set(range(slot['offset'], slot['offset'] + slot['size']))
    changed = []
    for section in old.sections:
        start, size = section["offset"], section["size"]
        changes = [start + i for i, (a, b) in enumerate(zip(
            old.data[start:start + size], new.data[start:start + size])) if a != b]
        unexpected = [address for address in changes if address not in allowed]
        require(not unexpected, f"Unreviewed original section edits: {[hex(a) for a in unexpected[:8]]}")
        changed.extend(changes)
    # Also protect original gaps, not merely named sections. Header and the two
    # dedicated repair padding regions are checked separately.
    excluded = set(range(0, BASE)) | set(range(BASE, 0x4000)) | set(range(0x11900, EXT))
    unexpected = [i for i in range(EXT) if old.data[i] != new.data[i] and
                  i not in excluded and i not in allowed]
    require(not unexpected, "Unexpected edit in original non-payload bytes")
    for address, expected in {
        0x4B34: "1f2003d5", 0x6798: "02008052", 0x681C: "1f2003d5",
        0x6C28: "e003271e", 0x6C40: "e003679e", 0x6CD0: "1f2003d5",
    }.items():
        require(new.data[address:address + 4] == bytes.fromhex(expected),
                f"Earlier fix changed at {address:#x}")
    return {"compared_sections": len(old.sections), "changed_original_section_bytes": len(changed),
            "allowed_code_sites": [hex(item[0]) for item in PATCH_SITES] + ["0x5d50", "0x5da0", "0x5dec", "0x5e38", "0x649c", "0x7848", "0x7ac4"]
            + [hex(pc) for pc in extra_sites],
            "allowed_utf16_version_range": ["0xec84", "0xec8e"],
            "native_unwind": unwind}


def version_word(version: str) -> int:
    require(re.fullmatch(r"\d+\.\d+\.\d+", version) is not None, "Invalid expected version")
    major, minor, patch = map(int, version.split("."))
    require(major < 65536 and minor < 256 and patch < 256, "Version component out of range")
    return major << 16 | minor << 8 | patch


def read_tables(image: Image, version: str) -> dict:
    data = image.data
    main = dict(zip(MAIN_NAMES, unpack("<64I", data, BASE)))
    require(main["reserved"] == 0, "Nonzero main directory reserved word")
    require(256 <= main["ratio"] < main["code_end"] <= 0x4000 - BASE, "Main code bounds invalid")
    require(main["strings"] == 0x11900 - BASE and main["strings"] < main["end"] <= EXT - BASE,
            "Main data bounds invalid")
    main_code = MAIN_NAMES[:4] + MAIN_NAMES[8:20] + MAIN_NAMES[26:51] + MAIN_NAMES[56:60]
    for name in main_code:
        require(256 <= main[name] < main["code_end"] and main[name] % 4 == 0,
                f"Invalid main code entry {name}")
    for name in MAIN_NAMES[20:26] + MAIN_NAMES[51:55]:
        require(main["strings"] <= main[name] < main["end"], f"Invalid main data key {name}")
    require(main["extension"] == EXT - BASE, "Wrong extension address in main directory")
    require(main["extension"] + 128 < main["extension_code_end"] <= main["extension_strings"] <
            main["extension_end"] <= EXT - BASE + image.segment("__FQPATCH")["filesize"],
            "Extension bounds invalid")
    modern_reader = version in MODERN_LAYOUT_VERSIONS
    version_bytes = b"162" if modern_reader else version.replace(".", "").encode("ascii")
    require(data[EXT:EXT + 8] == b"FQ" + version_bytes + b"EXT", "Extension marker/version mismatch")
    encoded, words = unpack("<2I", data, EXT + 8)
    require(words == 32, "Extension directory length changed")
    extension = dict(zip(EXT_NAMES, unpack("<28I", data, EXT + 16)))
    require(tuple(extension[k] for k in ("code_end", "strings", "end")) ==
            tuple(main["extension_" + k] for k in ("code_end", "strings", "end")),
            "Main/extension directory bounds disagree")
    for name in EXT_NAMES[:15]:
        require(EXT + 128 - BASE <= extension[name] < extension["code_end"] and extension[name] % 4 == 0,
                f"Invalid extension entry {name}")
    for name in EXT_NAMES[18:24]:
        require(extension["strings"] <= extension[name] < extension["end"], f"Invalid extension key {name}")
    extension_sites = EXTENSION_PATCH_SITES.get(version, ())
    for pc, name, _ in extension_sites:
        entry = extension[name]
        require(EXT + 128 - BASE <= entry < extension["code_end"] and entry % 4 == 0,
                f"Invalid extension entry for patch site {pc:#x}")
    require(all(extension[name] == 0 for name in EXT_NAMES[24 + len(extension_sites):]),
            "Nonzero extension reserved word")
    reader_marker = b"FQ" + version_bytes + b"RDR"
    require(data.count(reader_marker) == 1, "Reader entry table absent or duplicated")
    reader_at = data.index(reader_marker)
    reader_names = READER_NAMES + (["settle_control"] if modern_reader else [])
    reader_size = 8 + len(reader_names) * 4
    require(BASE + extension["strings"] <= reader_at and reader_at + reader_size <= BASE + extension["end"],
            "Reader table outside extension data")
    reader = dict(zip(reader_names, unpack("<" + str(len(reader_names)) + "I", data, reader_at + 8)))
    reader_code = READER_NAMES[:7] + (["settle_control"] if modern_reader else [])
    for name in reader_code:
        require(EXT + 128 - BASE <= reader[name] < extension["code_end"] and reader[name] % 4 == 0,
                f"Invalid reader entry {name}")
    for name in READER_NAMES[7:]:
        require(extension["strings"] <= reader[name] < extension["end"], f"Invalid reader key {name}")
    code_padding = data[BASE + extension["code_end"]:BASE + extension["strings"]]
    require(extension["strings"] == rounded(extension["code_end"], 8) and
            code_padding in (b"", bytes.fromhex("1f2003d5")),
            "Invalid extension code-to-data alignment padding")
    for first, end in (
        (BASE + main["code_end"], 0x4000), (BASE + main["end"], EXT),
        (BASE + extension["end"], image.segment("__LINKEDIT")["fileoff"]),
    ):
        require(not any(data[first:end]), f"Nonzero unused repair space {first:#x}..{end:#x}")
    return {"main": main, "extension": extension, "reader": reader, "expected_version": version,
            "main_version": main["version"], "extension_version": encoded,
            "reader_table_address": reader_at,
            "code_ranges": [(BASE + 256, BASE + main["code_end"]),
                            (EXT + 128, BASE + extension["code_end"])]}


def direct_instruction(word: int, pc: int):
    if word & 0x7C000000 == 0x14000000:
        return ("BL" if word & 0x80000000 else "B", pc + (signed(word & 0x3FFFFFF, 26) << 2))
    if word & 0xFF000010 == 0x54000000:
        return ("B.cond", pc + (signed((word >> 5) & 0x7FFFF, 19) << 2))
    if word & 0x7E000000 == 0x34000000:
        return ("CBZ/CBNZ", pc + (signed((word >> 5) & 0x7FFFF, 19) << 2))
    if word & 0x7E000000 == 0x36000000:
        return ("TBZ/TBNZ", pc + (signed((word >> 5) & 0x3FFF, 14) << 2))
    if word & 0x9F000000 in (0x10000000, 0x90000000):
        offset = signed(((word >> 5) & 0x7FFFF) << 2 | ((word >> 29) & 3), 21)
        return ("ADRP", (pc & ~0xFFF) + (offset << 12)) if word & 0x80000000 else ("ADR", pc + offset)
    if word & 0x3B000000 == 0x18000000:
        return ("LDR-literal", pc + (signed((word >> 5) & 0x7FFFF, 19) << 2))
    return None


def check_instructions(image: Image, tables: dict) -> dict:
    branches = []
    adr_refs = []
    counts = {}
    valid_code = tables["code_ranges"] + [
        (s["address"], s["address"] + s["size"]) for s in image.sections
        if s["segment"] == "__TEXT" and s["name"] in ("__text", "__stubs")]
    # Scan every instruction in the emitted repair ranges, plus each modified
    # entry instruction in the original text. The original code is byte-checked.
    addresses = [pc for first, end in tables["code_ranges"] for pc in range(first, end, 4)]
    addresses += [entry[0] for entry in PATCH_SITES] + [0x5D50, 0x5DA0, 0x5DEC, 0x5E38, 0x649C, 0x7848, 0x7AC4]
    version = tables["expected_version"]
    extension_sites = EXTENSION_PATCH_SITES.get(version, ())
    addresses += [pc for pc, _, _ in extension_sites]
    if version in ("1.6.5", "1.6.6", "1.6.7", "1.6.9"):
        data=image.data
        require(data.count(b"FQ165HOM")==1,"One home compatibility entry table")
        at=data.index(b"FQ165HOM")
        ext=tables["extension"]
        require(BASE+ext["strings"]<=at and at+16<=BASE+ext["end"],"Home table inside constants")
        gate,check=unpack("<II",data,at+8)
        for pc,entry,kind in ((0x4018,check,"BL"),(0x401c,gate,"B")):
            require(EXT+128<=BASE+entry<BASE+ext["code_end"],"Home entry inside code")
            require(direct_instruction(unpack("<I",data,pc)[0],pc)==(kind,BASE+entry),"Constructor routes to checked home entry")
        addresses += [0x4018,0x401c]
    for pc in addresses:
        word = unpack("<I", image.data, image.vm_file(pc, 4))[0]
        require(word != 0, f"Zero instruction in repair code at {pc:#x}")
        decoded = direct_instruction(word, pc)
        if not decoded:
            continue
        kind, target = decoded
        counts[kind] = counts.get(kind, 0) + 1
        if kind in ("ADR", "ADRP", "LDR-literal"):
            image.vm_file(target)
            require(target < image.segment("__LINKEDIT")["vmaddr"],
                    f"Repair instruction references LINKEDIT at {pc:#x}")
            if kind == "ADR":
                adr_refs.append({"pc": pc, "target": target, "register": word & 31})
        else:
            require(target % 4 == 0 and any(a <= target < b for a, b in valid_code),
                    f"{kind} at {pc:#x} reaches non-code {target:#x}")
            branches.append({"pc": pc, "target": target, "kind": kind})
    expected_sites = [(pc, BASE + tables["main"][name], link) for pc, name, link in PATCH_SITES]
    expected_sites.append((0x5D50, BASE + tables["reader"]["reader_panel"], False))
    if version in MODERN_LAYOUT_VERSIONS:
        expected_sites += [(pc, BASE + tables["reader"]["reader_panel"], False)
                           for pc in (0x5DA0, 0x5DEC, 0x5E38)]
    else:
        # The pinned 1.5.8 negative control retains these original tails. Check
        # their actual historical targets so its stale export is the only
        # rejection; all four new 1.6.0 destinations remain mandatory above.
        expected_sites += [(0x5DA0, 0x746C, False), (0x5DEC, 0x75D4, False),
                           (0x5E38, 0x75D4, False)]
    expected_sites += [(0x7848, BASE + tables["extension"]["style_control"], False),
                       (0x7AC4, BASE + tables["extension"]["style_glyph"], False)]
    expected_sites += [(pc, BASE + tables["extension"][name], link) for pc, name, link in extension_sites]
    for pc, target, linked in expected_sites:
        require(direct_instruction(unpack("<I", image.data, pc)[0], pc) ==
                ("BL" if linked else "B", target), f"Wrong patched branch target at {pc:#x}")
    expected_style = 0x52800002 if version in MODERN_LAYOUT_VERSIONS else 0x52800022
    require(unpack("<I", image.data, 0x649C)[0] == expected_style,
            "Initial proxy glass style must match the versioned Regular/Clear contract")
    return {"instruction_words_checked": len(addresses), "direct_reference_counts": counts,
            "branch_target_count": len(branches), "adr_references": adr_refs,
            "scope": "All direct branches/ADR/ADRP/literal addresses in emitted repair code; not a full ISA proof"}


def read_signature(image: Image) -> dict:
    data = image.data
    start, length = image.link_range(0x1D)
    require(start + length == len(data) and length >= 112 and start % 16 == 0,
            "Code signature must be aligned and end the image")
    require(unpack(">3I", data, start) == (0xFADE0CC0, length, 1), "Invalid ad-hoc SuperBlob envelope")
    require(unpack(">2I", data, start + 12) == (0, 24) and data[start + 20:start + 24] == bytes(4),
            "Expected one aligned CodeDirectory slot")
    cd = start + 24
    magic, size, version, flags, hash_off, ident_off, special, slots, limit = unpack(">9I", data, cd)
    require((magic, version, flags, special) == (0xFADE0C02, 0x20400, 0x20002, 0),
            "Unexpected CodeDirectory version/flags/special slots")
    require(cd + size == len(data) and ident_off == 88 and hash_off % 8 == 0 and hash_off > ident_off,
            "Invalid CodeDirectory/identifier bounds")
    require(unpack(">4B", data, cd + 36) == (32, 2, 0, 12), "Expected SHA256, 4 KiB CodeDirectory pages")
    require(data[cd + 40:cd + 64] == bytes(24), "Unsupported scatter/team/64-bit-limit fields")
    require(unpack(">3Q", data, cd + 64) == (0, 0x10000, 0), "CodeDirectory __TEXT exec range changed")
    require(limit == start and slots == (limit + 4095) // 4096 and hash_off + slots * 32 == size,
            "CodeDirectory does not cover every signed byte exactly")
    identifier = cstring(data, cd + ident_off, cd + hash_off)
    ident_end = cd + ident_off + len(identifier.encode("utf-8"))
    require(not any(data[ident_end:cd + hash_off]), "Nonzero CodeDirectory identifier padding")
    bad = []
    for slot in range(slots):
        page_start = slot * 4096
        expected = hashlib.sha256(data[page_start:min(page_start + 4096, limit)]).digest()
        observed = data[cd + hash_off + slot * 32:cd + hash_off + (slot + 1) * 32]
        if expected != observed:
            bad.append(slot)
    require(not bad, f"Invalid signed page hashes: {bad}")
    return {"signature_offset": start, "signature_size": length, "directory_offset": cd,
            "directory_size": size, "code_limit": limit, "code_slots": slots,
            "hash_offset": hash_off, "identifier": identifier, "all_page_hashes_valid": True,
            "cdhash": hashlib.sha256(data[cd:cd + size]).digest()[:20].hex(),
            "device_acceptance_tested": False}


def parse_chains(image: Image) -> dict:
    start, size = image.link_range(0x80000034)
    require(size == 0x2A0, "Chained-fixup blob size changed")
    blob = image.data[start:start + size]
    require(unpack("<7I", blob) == (0, 28, 72, 164, 23, 1, 0), "Chained-fixup header changed")
    require(unpack("<5I", blob, 28) == (4, 0, 20, 0, 0), "Chained segment starts mismatch")
    require(unpack("<IHHQIH", blob, 48) == (24, 0x4000, 2, 0x10000, 0, 1),
            "Unsupported chained page description")
    page_start = unpack("<H", blob, 70)[0]
    require(page_start < 0x8000 and page_start < PAGE, "Unsupported chained page start")
    imports = []
    for index in range(23):
        packed = unpack("<I", blob, 72 + 4 * index)[0]
        name = cstring(blob, 164 + (packed >> 9), len(blob))
        ordinal = signed(packed & 255, 8)
        require(1 <= ordinal <= 5, "Import uses unexpected dylib ordinal")
        imports.append({"record": packed, "name": name, "library_ordinal": ordinal,
                        "weak": bool(packed & 256)})
    slots = []
    address = 0x10000 + page_start
    seen = set()
    while True:
        require(address not in seen and 0x10000 <= address <= 0x14000 - 8 and address % 4 == 0,
                "Chained pointer loops or leaves its page")
        seen.add(address)
        raw = unpack("<Q", image.data, image.vm_file(address, 8))[0]
        delta = ((raw >> 51) & 0xFFF) * 4
        if raw >> 63:
            ordinal = raw & 0xFFFFFF
            require(ordinal < len(imports) and (raw >> 32) & 0x7FFFF == 0,
                    "Invalid chained bind ordinal/reserved bits")
            meaning = ("bind", ordinal, signed((raw >> 24) & 255, 8))
        else:
            require((raw >> 44) & 0x7F == 0, "Nonzero chained rebase reserved bits")
            target = (raw & ((1 << 36) - 1)) | (((raw >> 36) & 255) << 56)
            require(target < EXT, "Original pointer rebases into the moved LINKEDIT/extension")
            image.vm_file(target)
            meaning = ("rebase", target)
        slots.append((address, raw, meaning))
        if not delta:
            break
        require(delta >= 4 and len(slots) < 4096, "Invalid chained next delta")
        address += delta
    require(len(slots) == 656, f"Expected 656 chained slots, got {len(slots)}")
    return {"imports": imports, "slots": slots, "blob_sha256": sha256(blob)}


def check_linkedit(old: Image, new: Image) -> dict:
    old_link = old.segment("__LINKEDIT")["fileoff"]
    new_link = new.segment("__LINKEDIT")["fileoff"]
    delta = new_link - old_link
    tables = []

    def compare_table(label, a, b, size):
        require(a >= old_link and b >= new_link, f"{label} lies outside LINKEDIT")
        require(b == a + delta and a + size <= len(old.data) and b + size <= len(new.data),
                f"{label} was not correctly relocated")
        require(old.data[a:a + size] == new.data[b:b + size], f"{label} contents changed")
        tables.append({"name": label, "size": size, "old_offset": a, "new_offset": b,
                       "sha256": sha256(new.data[b:b + size])})

    for kind in LINK_DATA_COMMANDS:
        a, alen = old.link_range(kind)
        b, blen = new.link_range(kind)
        if kind == 0x1D:
            require(b == a + delta, "Signature start did not move by extension delta")
            continue
        require(alen == blen, f"LINKEDIT command {kind:#x} size changed")
        if a == 0:
            require(b == 0 and alen == 0, "Unexpected newly populated LINKEDIT command")
        else:
            compare_table(hex(kind), a, b, alen)
    a = unpack("<4I", old.one(0x2)["raw"], 8)
    b = unpack("<4I", new.one(0x2)["raw"], 8)
    require(a[1] == b[1] == 192 and a[3] == b[3], "Symbol/string table sizes changed")
    compare_table("symbols", a[0], b[0], a[1] * 16)
    compare_table("symbol_strings", a[2], b[2], a[3])
    a = unpack("<18I", old.one(0xB)["raw"], 8)
    b = unpack("<18I", new.one(0xB)["raw"], 8)
    # The only populated dysymtab offset/count pair is indirect symbols.
    require(a[:12] == b[:12] and a[14:] == b[14:] and a[13] == b[13] == 43,
            "Dysymtab non-offset fields changed")
    require(a[6:12] == b[6:12] == (0,) * 6 and a[14:] == b[14:] == (0,) * 4,
            "Unexpected table-of-contents/module/reference/relocation tables")
    compare_table("indirect_symbols", a[12], b[12], a[13] * 4)
    old_sig, _ = old.link_range(0x1D)
    new_sig, _ = new.link_range(0x1D)
    require(old_sig - old_link == new_sig - new_link, "Unsigned LINKEDIT span changed")
    compare_table("entire_unsigned_linkedit", old_link, new_link, old_sig - old_link)
    old_chains, new_chains = parse_chains(old), parse_chains(new)
    require(old_chains == new_chains, "Chained-fixup imports, pointers or semantics changed")
    return {"relocation_delta": delta, "tables": tables, "chained_slots": len(new_chains["slots"]),
            "chained_import_count": len(new_chains["imports"]),
            "chained_imports": new_chains["imports"], "chained_blob_sha256": new_chains["blob_sha256"]}


def check_commands(old: Image, new: Image, expected_version: str) -> dict:
    require(len(old.commands) == len(new.commands), "Load-command count changed")
    dependencies = []
    mutable = {0x19, 0x1D, 0x26, 0x29, 0x80000033, 0x80000034, 0x2, 0xB, 0xD, 0x1B}
    for a, b in zip(old.commands, new.commands):
        require((a["kind"], a["size"], a["offset"]) == (b["kind"], b["size"], b["offset"]),
                "Load-command order/size/location changed")
        if a["kind"] not in mutable:
            require(a["raw"] == b["raw"], f"Immutable load command changed: {a['kind']:#x}")
        if b["kind"] == 0xC:
            string_offset = unpack("<I", b["raw"], 8)[0]
            dependencies.append(cstring(b["raw"], string_offset, b["size"]))
    old_id, new_id = old.one(0xD), new.one(0xD)
    expected_id = bytearray(old_id["raw"])
    require(expected_id.count(b"1.5.8") == 1, "Unexpected baseline install-name format")
    string_offset = unpack("<I", expected_id, 8)[0]
    # The pinned 1.5.8 control must retain its historical name so that its
    # stale diagnostic version is the only expected failure in fault tests.
    product = "FanqieAdBlock" if expected_version == "1.5.8" else "FanqieX"
    install_name = f"@rpath/{product}-{expected_version}.dylib".encode("ascii") + b"\0"
    require(len(install_name) <= len(expected_id) - string_offset, "Product install name exceeds command")
    expected_id[string_offset:] = install_name.ljust(len(expected_id) - string_offset, b"\0")
    struct.pack_into("<I", expected_id, 16, version_word(expected_version))
    require(bytes(expected_id) == new_id["raw"], "LC_ID_DYLIB version/install-name fields inconsistent")
    identity = new.one(0x1B)["raw"][8:24]
    require(len(identity) == 16 and identity[6] >> 4 == 5 and identity[8] >> 6 == 2,
            "UUID format differs from the deterministic build format")
    require(len(dependencies) == 5, "Dependency count changed")
    return {"dependencies": dependencies, "uuid": identity.hex(),
            "install_name": cstring(new_id["raw"], unpack("<I", new_id["raw"], 8)[0], new_id["size"])}


def check_versions(image: Image, version: str, tables: dict, instructions: dict, signature: dict) -> dict:
    data = image.data
    expected = version.encode("ascii")
    require(tables["main_version"] == tables["extension_version"] == version_word(version),
            "Main/extension numeric versions differ")
    require(data[0xEC84:0xEC8E] == version.encode("utf-16le"), "Settings UTF16 version mismatch")
    product = "FanqieAdBlock" if version == "1.5.8" else "FanqieX"
    require(signature["identifier"] == f"{product}-{version}.dylib", "Signature identifier version mismatch")
    constants_start = BASE + tables["main"]["strings"]
    constants_end = BASE + tables["main"]["end"]
    constants = [{"address": constants_start + match.start(), "value": match.group().decode("ascii")}
                 for match in re.finditer(rb"\b\d+\.\d+\.\d+\b", data[constants_start:constants_end])]
    require(constants and all(item["value"] == version for item in constants),
            f"Runtime/event/export version constants are inconsistent: {constants}; expected {version}")
    # 1.5.8 is an explicit negative-control option: its export says 1.5.7.  A
    # genuine 1.6.0 must furthermore use a single shared runtime constant.
    require(len(constants) == 1, "Events/export do not share exactly one runtime version constant")
    runtime_address = constants[0]["address"]
    refs = [item for item in instructions["adr_references"]
            if item["target"] == runtime_address and item["register"] == 0]
    require(len(refs) >= 2, "Shared version is not referenced by two emitted code paths")
    field_refs = []
    # Identify the real event/export dictionary writes, rather than count any
    # arbitrary ADR to the string: ADR x0(version), BL Lstr, MOV x2,x0,
    # MOV x0,dict, ADR x1(pluginVersion), BL Ldict_set.
    for item in refs:
        pc = item["pc"]
        words = unpack("<6I", data, pc)
        field_adr = direct_instruction(words[4], pc + 16)
        first_call = direct_instruction(words[1], pc + 4)
        last_call = direct_instruction(words[5], pc + 20)
        if first_call == ("BL", BASE + tables["main"]["string"]) and words[2] == 0xAA0003E2 and \
                words[3] & 0xFFE0FFFF == 0xAA0003E0 and \
                field_adr and field_adr[0] == "ADR" and words[4] & 31 == 1 and \
                last_call == ("BL", BASE + tables["main"]["dict_set"]):
            field = cstring(data, image.vm_file(field_adr[1]), len(data))
            if field == "pluginVersion":
                field_refs.append({"pc": pc, "key_address": field_adr[1],
                                   "dictionary_register": (words[3] >> 16) & 31})
    require(len(field_refs) >= 2 and len({item["dictionary_register"] for item in field_refs}) >= 2,
            "Cannot establish distinct event/export writes of the shared version")
    dotted = [{"address": match.start(), "value": match.group().decode("ascii")}
              for match in re.finditer(rb"\b\d+\.\d+\.\d+\b", data)]
    if version in ("1.6.5", "1.6.6", "1.6.7", "1.6.9"):
        host=[item for item in dotted if data[item["address"]:item["address"]+9]==b"7.4.3.33\0"]
        require(len(host)==1,"Exactly one pinned host build identifier")
        dotted=[item for item in dotted if item not in host]
    require(all(item["value"] == version for item in dotted) and len(dotted) == 3,
            f"Unexpected displayed ASCII version strings: {dotted}")
    return {"version": version, "settings_utf16": version, "runtime_constants": constants,
            "shared_event_export_writes": field_refs, "ascii_version_occurrences": dotted,
            "events_and_export_share_constant": True}


def audit(baseline: bytes, candidate: bytes, expected_version: str = "1.6.2") -> dict:
    report = {
        "schema": "fanqiex.independent159.v1", "baseline_sha256": sha256(baseline),
        "candidate_sha256": sha256(candidate), "candidate_size": len(candidate),
        "expected_version": expected_version, "passed": False, "checks": {},
        "device_tested": False,
        "limitations": ["No iOS/dyld acceptance or injected-process execution was performed.",
                        "UIKit rendering, touch behaviour and real-device latency are outside this binary audit.",
                        "Direct instruction address checks do not prove every instruction's semantics."],
    }

    def run(name, action):
        try:
            details = action()
            report["checks"][name] = {"passed": True, "details": details}
            return details
        except (AuditError, UnicodeError, struct.error, ValueError, IndexError, StopIteration) as error:
            report["checks"][name] = {"passed": False, "error": str(error)}
            return None

    if sha256(baseline) != BASELINE_SHA256:
        report["checks"]["baseline_identity"] = {"passed": False, "error": "Pinned 1.5.8 baseline SHA256 mismatch"}
        return report
    report["checks"]["baseline_identity"] = {"passed": True}
    try:
        old, new = Image(baseline), Image(candidate)
    except (AuditError, UnicodeError, struct.error) as error:
        report["checks"]["parse"] = {"passed": False, "error": str(error)}
        return report
    report["checks"]["parse"] = {"passed": True}
    run("layout", lambda: check_layout(old, new))
    run("original_sections", lambda: check_sections(old, new, expected_version))
    run("load_commands", lambda: check_commands(old, new, expected_version))
    run("linkedit_and_chained_fixups", lambda: check_linkedit(old, new))
    signature = run("code_signature", lambda: read_signature(new))
    tables = run("repair_directories", lambda: read_tables(new, expected_version))
    instructions = run("instruction_addresses", lambda: check_instructions(new, tables)) if tables else None
    if tables and instructions and signature:
        run("version_consistency", lambda: check_versions(new, expected_version, tables, instructions, signature))
    else:
        report["checks"]["version_consistency"] = {"passed": False, "error": "Required structural checks unavailable"}
    # Do not repeat the full reference table in the saved report.
    if instructions:
        instructions["adr_reference_count"] = len(instructions.pop("adr_references"))
    report["passed"] = all(check["passed"] for check in report["checks"].values())
    return report


def main():
    parser = argparse.ArgumentParser(description=__doc__)
    parser.add_argument("--baseline", type=Path, required=True)
    parser.add_argument("--candidate", type=Path, required=True)
    parser.add_argument("--expected-version", default="1.6.2",
                        help="Use 1.5.8 only to expose the known stale 1.5.7 export negative control")
    parser.add_argument("--report", type=Path)
    args = parser.parse_args()
    report = audit(args.baseline.read_bytes(), args.candidate.read_bytes(), args.expected_version)
    if args.report:
        args.report.parent.mkdir(parents=True, exist_ok=True)
        args.report.write_text(json.dumps(report, ensure_ascii=False, indent=2) + "\n")
    print(json.dumps({"passed": report["passed"], "candidate_sha256": report["candidate_sha256"],
                      "failed_checks": {name: check["error"] for name, check in report["checks"].items()
                                        if not check["passed"]}, "report": str(args.report) if args.report else None},
                     ensure_ascii=False, indent=2))
    return 0 if report["passed"] else 1


if __name__ == "__main__":
    sys.exit(main())
