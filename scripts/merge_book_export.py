#!/usr/bin/env python3
"""Join the pinned FanqieX core and the independently linked export code in one iOS image.

Both inputs have preferred base zero and page-aligned mappings. The linked
export may end its __DATA segment with zero-fill pages absent from the file.
The core moves by one constant so its ARM64 code/data references stay intact.
dyld itself resolves all chained pointers and both initializers.
"""
from __future__ import annotations

import argparse
import hashlib
import json
from pathlib import Path
import struct
import sys
from uuid import UUID

from signing_compat import LOADS, cstring, inspect, version
from build_book_export import ROOT, integrated_release

sys.path.insert(0, str(ROOT / "repair162"))
from extend_macho import LC_SOURCE_VERSION, _code_directory, align, commands, need, segments
from macho_tools import sections, verify_signature
from native_unwind import decode_unwind

PAGE = 0x4000
FIXUPS = 0x80000034
EXPORTS = 0x80000033
SIGNATURE = 0x1D
FUNCTIONS = 0x26
DATA_IN_CODE = 0x29
START_OFFSETS = 0x16
LC_UUID = 0x1B
LC_ID_DYLIB = 0xD
LC_BUILD_VERSION = 0x32
TARGET_MASK = (1 << 36) - 1
BIND_MASK = (1 << 24) - 1


def find(items, kind):
    matches = [item for item in items if item["cmd"] == kind]
    need(len(matches) == 1, f"Expected one load command {kind:#x}")
    return matches[0]


def linkedit(data, items, kind):
    offset, size = struct.unpack_from("<II", find(items, kind)["raw"], 8)
    need(offset + size <= len(data), "LINKEDIT table extends outside image")
    return data[offset:offset + size]


def library_commands(items):
    return [item for item in items if item["cmd"] in LOADS]


def dylib_name(item):
    raw = item["raw"]
    return cstring(raw, struct.unpack_from("<I", raw, 8)[0], len(raw))


def source_sections(data):
    return {item["name"]: item for item in sections(data) if item["segment"] == "__TEXT"}


def content(data, item):
    return data[item["offset"]:item["offset"] + item["size"]]


def fixup_input(data, items, image_segments):
    blob = linkedit(data, items, FIXUPS)
    version, start, imports, symbols, count, encoding, compressed = struct.unpack_from("<7I", blob)
    need((version, encoding, compressed) == (0, 1, 0), "Expected uncompressed DYLD_CHAINED_IMPORT")
    need(28 <= start < imports <= symbols <= len(blob) and imports + 4 * count == symbols,
         "Invalid chained table header")
    seg_count, = struct.unpack_from("<I", blob, start)
    need(seg_count == len(image_segments), "Chained segment count does not match image")
    starts = []
    for index in range(seg_count):
        relative, = struct.unpack_from("<I", blob, start + 4 * (index + 1))
        if relative == 0:
            starts.append(b"")
            continue
        at = start + relative
        need(start + 4 * (seg_count + 1) <= at <= imports - 22,
             "Chained segment header outside starts table")
        size, page_size, pointer_format, segment_offset, max_pointer, page_count = struct.unpack_from(
            "<IHHQIH", blob, at)
        row_size = 22 + page_count * 2
        # LLD rounds segment starts records to 8 bytes. Only zero alignment
        # padding is accepted here; walk_fixups still requires one start per page.
        need(pointer_format in (2, 6) and page_size == PAGE and not max_pointer and
             size in (row_size, align(row_size, 8)) and at + size <= imports and
             not any(blob[at + row_size:at + size]) and
             page_count <= image_segments[index]["vmsize"] // PAGE and
             image_segments[index]["initprot"] == 3 and
             segment_offset == image_segments[index]["vmaddr"],
             "Unsupported chained segment layout")
        starts.append(blob[at:at + size])
    imported = []
    libraries = library_commands(items)
    for index in range(count):
        value, = struct.unpack_from("<I", blob, imports + index * 4)
        ordinal = value & 255
        name = cstring(blob, symbols + (value >> 9), len(blob))
        need(ordinal == 0 or ordinal >= 0xF1 or ordinal <= len(libraries), "Invalid import dylib ordinal")
        imported.append((ordinal, bool(value & 256), name))
    return starts, imported


def verify_dyld_layout(data, items, image_segments):
    image_uuid = find(items, LC_UUID)["raw"]
    need(len(image_uuid) == 24 and any(image_uuid[8:]), "Missing or invalid LC_UUID required by dyld")
    headers = [item["name"] for item in image_segments]
    need(len(headers) == len(set(headers)) and headers[0] == "__TEXT" and headers[-1] == "__LINKEDIT",
         "Invalid segment name or order")
    text, link = image_segments[0], image_segments[-1]
    header_end = 32 + struct.unpack_from("<I", data, 20)[0]
    need(text["fileoff"] == text["vmaddr"] == 0 and text["initprot"] == 5 and
         header_end <= min(text["filesize"], text["vmsize"]) and link["initprot"] == 1,
         "Invalid __TEXT or __LINKEDIT mapping")
    for index, segment in enumerate(image_segments):
        raw = segment["raw"]
        vm, fileoff = segment["vmaddr"], segment["fileoff"]
        vm_end, file_end = vm + segment["vmsize"], fileoff + segment["filesize"]
        need(vm == fileoff and vm % PAGE == 0 and file_end <= len(data) and
             segment["filesize"] <= segment["vmsize"] and segment["initprot"] in (1, 3, 5),
             "Invalid mapped segment bounds or permissions")
        if index:
            previous = image_segments[index - 1]
            need(vm >= previous["vmaddr"] + previous["vmsize"] and
                 fileoff >= previous["fileoff"] + previous["filesize"],
                 "Out-of-order or overlapping mapped segments")
        if segment["name"] in ("__DATA", "__DATA_CONST"):
            need(segment["initprot"] == 3, "Invalid data segment permissions")
        if segment["name"] == "__DATA_CONST":
            need(segment["flags"] & 0x10, "Missing SG_READ_ONLY on __DATA_CONST")
        for at in range(72, len(raw), 80):
            _, owner, address, size, offset, alignment, reloc, reloc_count, flags = struct.unpack_from(
                "<16s16sQQ5I", raw, at)
            need(owner == raw[8:24] and vm <= address <= address + size <= vm_end and
                 alignment <= 31 and address % (1 << alignment) == 0 and not reloc and not reloc_count,
                 "A section is outside its native segment or has unresolved relocations")
            if flags & 255 not in (1, 0xC, 0x12):  # zero-fill section types
                need(fileoff <= offset and offset + size <= file_end and address == offset,
                     "A file-backed section is outside its segment")
    sign_at, sign_size = struct.unpack_from("<II", find(items, SIGNATURE)["raw"], 8)
    need(sign_at % 16 == 0 and sign_at + sign_size == len(data) and
         link["fileoff"] + link["filesize"] == len(data), "Invalid code signature or LINKEDIT bounds")
    _, fields = linkedit_tables(data, items, link["fileoff"], sign_at, {})
    for command_at, word in fields:
        # Source offsets in the existing image, prior to normalization.
        offset, = struct.unpack_from("<I", data, command_at + word)
        need(offset % 8 == 0, "Misaligned LINKEDIT table")


def walk_fixups(data, image_segments, starts):
    locations = {}
    for segment, row in zip(image_segments, starts):
        if not row:
            continue
        _, page_size, pointer_format, _, _, count = struct.unpack_from("<IHHQIH", row)
        for page in range(count):
            offset, = struct.unpack_from("<H", row, 22 + page * 2)
            if offset == 0xFFFF:
                continue
            need(offset < page_size, "Unsupported chained multi-start page")
            local = page * page_size + offset
            while True:
                need(local + 8 <= min((page + 1) * page_size, segment["filesize"]),
                     "Chained fixup exceeds mapped page")
                file_at = segment["fileoff"] + local
                need(file_at not in locations, "Repeated chained pointer")
                value, = struct.unpack_from("<Q", data, file_at)
                locations[file_at] = (pointer_format, value)
                units = (value >> 51) & 0xFFF
                if not units:
                    break
                local += units * 4
    return locations


def nonlazy_classes(image, slots):
    """Read class names from the runtime's non-lazy class registration list."""
    entries = [item for item in sections(image) if item["name"] == "__objc_nlclslist"]
    need(len(entries) == 1 and entries[0]["size"] % 8 == 0, "Missing export non-lazy classes")
    section = entries[0]

    def rebase(offset, clear_low_flags=False):
        _, pointer = slots[offset]
        need(not pointer >> 63, "Expected local Objective-C metadata pointer")
        target = pointer & TARGET_MASK
        return target & ~7 if clear_low_flags else target

    names = []
    for offset in range(section["offset"], section["offset"] + section["size"], 8):
        class_address = rebase(offset)
        read_only = rebase(class_address + 32, clear_low_flags=True)
        names.append(cstring(image, rebase(read_only + 24), len(image)))
    return names


def imports_blob(starts, imports):
    table = bytearray(struct.pack("<I", len(starts)) + bytes(4 * len(starts)))
    for index, row in enumerate(starts):
        if row:
            struct.pack_into("<I", table, 4 * (index + 1), len(table))
            table.extend(row)
    imports_offset = 32 + len(table)
    symbols_offset = imports_offset + 4 * len(imports)
    symbols = bytearray()
    import_words = []
    for ordinal, weak, name in imports:
        import_words.append(ordinal | (int(weak) << 8) | (len(symbols) << 9))
        symbols.extend(name.encode("utf-8") + b"\0")
    header = struct.pack("<8I", 0, 32, imports_offset, symbols_offset, len(imports), 1, 0, 0)
    return header + table + struct.pack(f"<{len(import_words)}I", *import_words) + symbols


def starts_decode(blob):
    addresses = []
    at = address = 0
    while at < len(blob) and blob[at]:
        delta = shift = 0
        while True:
            byte = blob[at]
            at += 1
            delta |= (byte & 127) << shift
            if byte < 128:
                break
            shift += 7
            need(shift < 35 and at < len(blob), "Invalid function-start ULEB128")
        need(delta > 0, "Repeated function start")
        address += delta
        addresses.append(address)
    need(at < len(blob) and not any(blob[at:]), "Missing function-start sentinel")
    return addresses


def starts_encode(addresses):
    table = bytearray()
    previous = 0
    for address in addresses:
        delta = address - previous
        need(delta > 0, "Overlapping function starts")
        while delta >= 128:
            table.append((delta & 127) | 128)
            delta >>= 7
        table.append(delta)
        previous = address
    return table + b"\0"


def linkedit_tables(data, items, start, end, replacements):
    """Keep the order/alignment of the linker-produced LINKEDIT tables."""
    ranges = []
    for item in items:
        kind, raw = item["cmd"], item["raw"]
        if kind in (FIXUPS, EXPORTS, FUNCTIONS, DATA_IN_CODE):
            offset, size = struct.unpack_from("<II", raw, 8)
            words = [(8, offset, size)]
        elif kind == 0x2:
            symoff, symbols, stroff, size = struct.unpack_from("<4I", raw, 8)
            words = [(8, symoff, symbols * 16), (16, stroff, size)]
        elif kind == 0xB:
            words = []
            for at, width in ((32, 8), (40, 56), (48, 4), (56, 4), (64, 8), (72, 8)):
                offset, count = struct.unpack_from("<II", raw, at)
                words.append((at, offset, count * width))
        else:
            continue
        for word, offset, size in words:
            if offset:
                need(start <= offset <= end and offset + size <= end, "LINKEDIT table outside mapped bytes")
                ranges.append((offset, size, item["offset"], kind, word))
            else:
                need(size == 0, "Missing LINKEDIT table")
    old, blob, fields = start, bytearray(), {}
    for offset, size, command_at, kind, word in sorted(ranges):
        need(offset >= old and not any(data[old:offset]), "Overlapping LINKEDIT tables or nonzero padding")
        blob.extend(bytes(align(len(blob), 8) - len(blob)))
        table = replacements.get(kind, data[offset:offset + size])
        fields[command_at, word] = (len(blob), len(table))
        blob.extend(table)
        old = offset + size
    need(not any(data[old:end]), "Unexpected unreferenced LINKEDIT data")
    return blob, fields


def outer_unwind(blob):
    version, common_at, common_count, personality_at, count, index_at, index_count = struct.unpack_from(
        "<7I", blob)
    need(version == 1 and 2 <= index_count and count <= 3, "Unsupported export compact unwind")
    common = struct.unpack_from(f"<{common_count}I", blob, common_at)
    personalities = struct.unpack_from(f"<{count}I", blob, personality_at)
    index = list(struct.iter_unpack("<III", blob[index_at:index_at + 12 * index_count]))
    need(len(index) == index_count and index[-1][1] == 0, "Missing export unwind sentinel")
    lsda_start, lsda_end = index[0][2], index[-1][2]
    lsda = list(struct.iter_unpack("<II", blob[lsda_start:lsda_end]))
    result = []
    for (base, at, _), (limit, _, _) in zip(index, index[1:]):
        kind, offset, count = struct.unpack_from("<IHH", blob, at)
        need(base < limit and count > 0, "Invalid export unwind index")
        if kind == 2:
            entries = [struct.unpack_from("<II", blob, at + offset + 8 * i)
                       for i in range(count)]
        else:
            need(kind == 3, "Unknown export unwind page")
            local_at, local_count = struct.unpack_from("<HH", blob, at + 8)
            encodings = common + struct.unpack_from(f"<{local_count}I", blob, at + local_at)
            words = struct.unpack_from(f"<{count}I", blob, at + offset)
            entries = [(base + (word & 0xFFFFFF), encodings[word >> 24]) for word in words]
        need(entries[0][0] == base and entries[-1][0] < limit and
             all(a[0] < b[0] for a, b in zip(entries, entries[1:])), "Invalid unwind function order")
        result.extend(entries)
    return result, index[-1][0], personalities, lsda


def unwind_blob(entries, limit, personalities, lsda):
    pages = [entries[index:index + 511] for index in range(0, len(entries), 511)]
    personality_at = 28
    index_at = personality_at + 4 * len(personalities)
    lsda_at = index_at + 12 * (len(pages) + 1)
    next_page = align(lsda_at + 8 * len(lsda), 4)
    index = bytearray()
    table = bytearray()
    lsda_cursor = 0
    for page, following in zip(pages, [item[0][0] for item in pages[1:]] + [limit]):
        index.extend(struct.pack("<III", page[0][0], next_page + len(table), lsda_at + 8 * lsda_cursor))
        while lsda_cursor < len(lsda) and lsda[lsda_cursor][0] < following:
            lsda_cursor += 1
        table.extend(struct.pack("<IHH", 2, 8, len(page)))
        for entry in page:
            table.extend(struct.pack("<II", *entry))
        table.extend(bytes(4096 - 8 - 8 * len(page)))
    need(lsda_cursor == len(lsda), "Unwind LSDA extends beyond function sentinel")
    index.extend(struct.pack("<III", limit, 0, lsda_at + 8 * len(lsda)))
    header = struct.pack("<7I", 1, 28, 0, personality_at, len(personalities), index_at, len(pages) + 1)
    blob = header + struct.pack(f"<{len(personalities)}I", *personalities) + index
    blob += b"".join(struct.pack("<II", *entry) for entry in lsda)
    return blob.ljust(next_page, b"\0") + table


def relocated_segment(segment, name, delta, section=None):
    raw = bytearray(segment["raw"][:72])
    raw[8:24] = name.encode().ljust(16, b"\0")
    struct.pack_into("<I", raw, 4, 72 if section is None else 152)
    struct.pack_into("<Q", raw, 24, segment["vmaddr"] + delta)
    struct.pack_into("<Q", raw, 40, segment["fileoff"] + delta)
    struct.pack_into("<I", raw, 64, int(section is not None))
    if section:
        record = bytearray(section)
        record[16:32] = raw[8:24]
        address, _, offset = struct.unpack_from("<QQI", record, 32)
        struct.pack_into("<Q", record, 32, address + delta)
        struct.pack_into("<I", record, 48, offset + delta)
        raw.extend(record)
    return raw


def verify_input_mapping(data, image_segments, *, allow_data_zerofill=False):
    """Accept a zero-fill tail only in the export's last mapped data segment.

    Every copied byte still has equal file and VM coordinates. Only LINKEDIT,
    which is rebuilt separately, may start earlier in the file than in memory.
    This keeps all existing code, metadata and chained-pointer locations fixed.
    """
    mapped, link = image_segments[:-1], image_segments[-1]
    need(bool(mapped) and link["name"] == "__LINKEDIT" and
         all(item["vmaddr"] % PAGE == item["fileoff"] % PAGE == 0 and
             item["initprot"] & 6 != 6 and
             0 <= item["filesize"] <= item["vmsize"] and
             item["fileoff"] + item["filesize"] <= len(data)
             for item in image_segments) and
         all(item["vmaddr"] == item["fileoff"] for item in mapped) and
         all(item["filesize"] == item["vmsize"] for item in mapped[:-1]) and
         (mapped[-1]["filesize"] == mapped[-1]["vmsize"] or
          (allow_data_zerofill and mapped[-1]["name"] == "__DATA" and
           mapped[-1]["initprot"] == 3)) and
         all(item["fileoff"] + item["filesize"] == following["fileoff"] and
             item["vmaddr"] + item["vmsize"] == following["vmaddr"]
             for item, following in zip(image_segments, image_segments[1:])) and
         link["fileoff"] + link["filesize"] == len(data),
         "Unexpected image mapping")


def merge(core, export):
    core_items, outer_items = commands(core), commands(export)
    core_segs, outer_segs = segments(core), segments(export)
    release = integrated_release(core)
    install = f"@rpath/FanqieX-{release}.dylib"
    core_id = find(core_items, LC_ID_DYLIB)
    need(dylib_name(core_id) == dylib_name(find(outer_items, LC_ID_DYLIB)) == install,
         f"Both inputs must be built for FanqieX {release}")
    _, core_minimum, core_sdk = struct.unpack_from("<III", find(core_items, LC_BUILD_VERSION)["raw"], 8)
    _, export_minimum, export_sdk = struct.unpack_from("<III", find(outer_items, LC_BUILD_VERSION)["raw"], 8)
    minimum_os, sdk = max(core_minimum, export_minimum), max(core_sdk, export_sdk)
    need([item["name"] for item in core_segs] == ["__TEXT", "__DATA_CONST", "__FQPATCH", "__LINKEDIT"],
         "Unexpected FanqieX core segment layout")
    need([item["name"] for item in outer_segs] == ["__TEXT", "__DATA_CONST", "__DATA", "__LINKEDIT"],
         "Unexpected linked export segment layout")
    for data, image_segments in ((core, core_segs), (export, outer_segs)):
        info = inspect(data)
        need((info["cpu"], info["subtype"], info["kind"], info["platform"]) == (0x100000C, 0, 6, 2) and
             not info["encrypted"] and
             verify_signature(data, allow_linker_padding=(data is export))["page_hashes_valid"],
             "Expected valid signed ARM64 iOS dylib")
        verify_input_mapping(data, image_segments, allow_data_zerofill=(data is export))
    need(not linkedit(core, core_items, EXPORTS).strip(b"\0"), "Core exports would require a merged trie")
    need(linkedit(core, core_items, DATA_IN_CODE) == b"", "Core uses unmerged data-in-code")
    core_sections = source_sections(core)
    outer_sections = source_sections(export)
    need(set(item["name"] for item in sections(core) if item["name"].startswith("__objc_")) ==
         {"__objc_imageinfo"}, "Core has unexpected Objective-C registration metadata")
    need("__fq_unwind" in outer_sections, "Link the export image with the reserved unwind section")

    delta = outer_segs[-1]["vmaddr"]
    outer_file_limit = outer_segs[-1]["fileoff"]
    core_limit = core_segs[-1]["vmaddr"]
    new_linkedit = delta + core_limit
    # Leave the export's zero-fill VM tail clear before placing the core. Its
    # old LINKEDIT begins at a file offset, not necessarily at the VM boundary.
    output = bytearray(export[:outer_file_limit])
    output.extend(bytes(delta - outer_file_limit))
    output.extend(core[:core_limit])

    old_outer_starts, outer_imports = fixup_input(export, outer_items, outer_segs)
    old_core_starts, core_imports = fixup_input(core, core_items, core_segs)
    outer_libraries, core_libraries = library_commands(outer_items), library_commands(core_items)
    library_names = [dylib_name(item) for item in outer_libraries]
    new_libraries = []
    for item in core_libraries:
        name = dylib_name(item)
        if name not in library_names:
            library_names.append(name)
            new_libraries.append(item["raw"])
    shifted_imports = []
    for ordinal, weak, symbol in core_imports:
        if 0 < ordinal < 0xF1:
            ordinal = library_names.index(dylib_name(core_libraries[ordinal - 1])) + 1
        shifted_imports.append((ordinal, weak, symbol))
    all_imports = outer_imports + shifted_imports
    starts = []
    for start_rows, slide in ((old_outer_starts, 0), (old_core_starts, delta)):
        for row in start_rows[:-1]:
            updated = bytearray(row)
            if updated:
                struct.pack_into("<H", updated, 6, 6)
                struct.pack_into("<Q", updated, 8, struct.unpack_from("<Q", row, 8)[0] + slide)
            starts.append(bytes(updated))
    starts.append(b"")
    outer_slots = walk_fixups(export, outer_segs, old_outer_starts)
    core_slots = walk_fixups(core, core_segs, old_core_starts)
    for offset, (_, value) in core_slots.items():
        if value >> 63:
            ordinal = value & BIND_MASK
            need(ordinal < len(core_imports), "Core bind ordinal out of range")
            updated = (value & ~BIND_MASK) | (ordinal + len(outer_imports))
        else:
            address = value & TARGET_MASK
            need(address < core_limit and value & (((1 << 15) - 1) << 36) == 0,
                 "Core rebase target outside copied image")
            updated = (value & ~TARGET_MASK) | (address + delta)
        struct.pack_into("<Q", output, offset + delta, updated)
    for _, (pointer_format, value) in outer_slots.items():
        need(pointer_format == 6 or value >> 63 or value & (0xFF << 36) == 0,
             "Export rebase cannot translate VM addresses with a high byte to offsets")

    init = core_sections["__init_offsets"]
    need(init["flags"] & 255 == START_OFFSETS and init["size"] > 0 and init["size"] % 4 == 0,
         "Unexpected FanqieX initialization table")
    init_start, init_end = core_sections["__text"]["address"], core_sections["__stubs"]["address"]
    initializers = []
    for offset in range(init["offset"], init["offset"] + init["size"], 4):
        entry, = struct.unpack_from("<I", core, offset)
        need(init_start <= entry < init_end and entry % 4 == 0, "Core initializer outside executable text")
        initializers.append(entry + delta)
        struct.pack_into("<I", output, offset + delta, entry + delta)
    init_record = next(record for record in (
        core_segs[0]["raw"][at:at + 80] for at in range(72, len(core_segs[0]["raw"]), 80))
        if record[:16].rstrip(b"\0") == b"__init_offsets")

    export_rows, export_end, personalities, lsda = outer_unwind(content(export, outer_sections["__unwind_info"]))
    core_rows, core_end = decode_unwind(content(core, core_sections["__unwind_info"]))
    need(export_end < delta + core_rows[0][0], "Overlapping export/core unwind ranges")
    unwind_rows = export_rows + [(export_end, 0)] + [(start + delta, encoding) for start, encoding in core_rows]
    unwind = unwind_blob(unwind_rows, core_end + delta, personalities, lsda)
    reserve = outer_sections["__fq_unwind"]
    need(len(unwind) <= reserve["size"] and not any(content(export, reserve)),
         "Combined compact unwind exceeds its reserved section")
    output[reserve["offset"]:reserve["offset"] + len(unwind)] = unwind

    old_sign_at, old_sign_size = struct.unpack_from("<II", find(outer_items, SIGNATURE)["raw"], 8)
    function_starts = starts_decode(linkedit(export, outer_items, FUNCTIONS))
    function_starts += [value + delta for value in starts_decode(linkedit(core, core_items, FUNCTIONS))]
    table, link_fields = linkedit_tables(export, outer_items, outer_file_limit, old_sign_at, {
        FIXUPS: imports_blob(starts, all_imports), FUNCTIONS: starts_encode(function_starts),
    })
    output.extend(table)
    output.extend(bytes(align(len(output), 16) - len(output)))
    sign_at = len(output)
    need(old_sign_at + old_sign_size == len(export), "Signature does not terminate linker image")
    signature = _code_directory(install.rsplit("/", 1)[-1], sign_at, {
        "exec_segment_base": 0, "exec_segment_limit": outer_segs[0]["filesize"], "exec_segment_flags": 0,
    })
    output.extend(signature)

    load_commands = []
    for item in outer_items:
        kind, raw = item["cmd"], bytearray(item["raw"])
        if kind == 0x19:
            name = raw[8:24].rstrip(b"\0")
            if name == b"__TEXT":
                for at in range(72, len(raw), 80):
                    old = raw[at:at + 16].rstrip(b"\0")
                    if old == b"__unwind_info":
                        raw[at:at + 16] = b"__fq_old_unwind\0"
                    elif old == b"__fq_unwind":
                        raw[at:at + 16] = b"__unwind_info".ljust(16, b"\0")
            elif name == b"__LINKEDIT":
                load_commands.extend((
                    relocated_segment(core_segs[0], "__FQCORETEXT", delta, init_record),
                    relocated_segment(core_segs[1], "__FQCOREDATA", delta),
                    relocated_segment(core_segs[2], "__FQPATCH", delta),
                ))
                size = len(output) - new_linkedit
                struct.pack_into("<4Q", raw, 24, new_linkedit, align(size, PAGE), new_linkedit, size)
        elif kind == SIGNATURE:
            struct.pack_into("<II", raw, 8, sign_at, len(signature))
        elif kind == LC_ID_DYLIB:
            raw = bytearray(core_id["raw"])
        elif kind == LC_BUILD_VERSION:
            struct.pack_into("<II", raw, 12, minimum_os, sdk)
        elif kind == LC_UUID:
            # The final image UUID identifies both linked payloads and all
            # rebased metadata. Fill after the load commands are in place.
            raw[8:24] = bytes(16)
        elif kind in (FIXUPS, EXPORTS, FUNCTIONS, DATA_IN_CODE, 0x2, 0xB):
            for (command_at, word), (offset, size) in link_fields.items():
                if command_at != item["offset"]:
                    continue
                struct.pack_into("<I", raw, word, new_linkedit + offset)
                if kind in (FIXUPS, EXPORTS, FUNCTIONS, DATA_IN_CODE):
                    struct.pack_into("<I", raw, word + 4, size)
        else:
            need(kind in LOADS | {LC_SOURCE_VERSION, 0x2C}, "Unexpected export load command")
        load_commands.append(raw)
    load_commands.extend(new_libraries)
    header = b"".join(load_commands)
    old_end = 32 + struct.unpack_from("<I", export, 20)[0]
    new_end = 32 + len(header)
    need(old_end <= new_end <= outer_sections["__text"]["offset"] and not any(export[old_end:new_end]),
         "Insufficient reserved Mach-O header space")
    output[32:new_end] = header
    struct.pack_into("<II", output, 16, len(load_commands), len(header))

    uuid_at = find(commands(output), LC_UUID)["offset"] + 8
    image_uuid = UUID(bytes=hashlib.sha256(output[:sign_at]).digest()[:16], version=5)
    output[uuid_at:uuid_at + 16] = image_uuid.bytes
    cd = sign_at + 24
    hash_offset, = struct.unpack_from(">I", output, cd + 16)
    slots, = struct.unpack_from(">I", output, cd + 28)
    for slot in range(slots):
        start = slot * 4096
        at = cd + hash_offset + 32 * slot
        output[at:at + 32] = hashlib.sha256(output[start:min(start + 4096, sign_at)]).digest()
    result = bytes(output)
    final = inspect(result)
    need(final["install_name"] == install and final["chained_fixups"] and
         verify_signature(result)["page_hashes_valid"], "Combined image failed structural verification")
    final_items, final_segments = commands(result), segments(result)
    verify_dyld_layout(result, final_items, final_segments)
    need(starts_decode(linkedit(result, final_items, FUNCTIONS)) == function_starts,
         "Combined function starts differ from input ranges")
    final_starts, final_imports = fixup_input(result, final_items, final_segments)
    final_slots = walk_fixups(result, final_segments, final_starts)
    export_classes = nonlazy_classes(export, outer_slots)
    need("FQXBookExportPlugin" in export_classes and nonlazy_classes(result, final_slots) == export_classes,
         "Export plugin registration class was lost")
    need(final_imports == all_imports and len(final_slots) == len(outer_slots) + len(core_slots),
         "Combined chained fixup count mismatch")
    for offset, (_, value) in outer_slots.items():
        need(final_slots[offset] == (6, value), "Export chained pointer changed")
    for offset, (_, value) in core_slots.items():
        _, merged = final_slots[offset + delta]
        if value >> 63:
            original = core_imports[value & BIND_MASK]
            rewritten = final_imports[merged & BIND_MASK]
            old_ordinal, _, _ = original
            new_ordinal, _, _ = rewritten
            need(original[1:] == rewritten[1:] and (value & ~BIND_MASK) == (merged & ~BIND_MASK)
                 and (dylib_name(core_libraries[old_ordinal - 1]) == library_names[new_ordinal - 1]
                      if 0 < old_ordinal < 0xF1 else old_ordinal == new_ordinal),
                 "Core bind symbol, flags or dependency changed")
        else:
            need((merged & TARGET_MASK) == (value & TARGET_MASK) + delta and
                 (merged & ~TARGET_MASK) == (value & ~TARGET_MASK), "Core rebase target changed")
    for segment in (core_segs[0], core_segs[2]):
        begin, size = segment["fileoff"], segment["filesize"]
        taken = result[delta + begin:delta + begin + size]
        expected = bytearray(core[begin:begin + size])
        if begin == 0:
            struct.pack_into(f"<{len(initializers)}I", expected, init["offset"], *initializers)
        need(taken == expected, "Core executable bytes changed")
    final_unwind = content(result, source_sections(result)["__unwind_info"])
    need(outer_unwind(final_unwind) == (unwind_rows, core_end + delta, personalities, lsda),
         "Combined compact unwind loses existing frame or exception information")
    return result, {
        "passed": True, "device_tested": False, "sha256": hashlib.sha256(result).hexdigest(),
        "size_bytes": len(result), "install_name": install, "core_vm_delta": hex(delta),
        "export_zerofill_gap_bytes": delta - outer_file_limit,
        "uuid": str(image_uuid), "minimum_ios": version(minimum_os), "sdk": version(sdk),
        "core_sdk": version(core_sdk),
        "version": release, "core_input_sha256": hashlib.sha256(core).hexdigest(),
        "export_input_sha256": hashlib.sha256(export).hexdigest(),
        "core_initializers": [hex(value) for value in initializers],
        "export_fixup_slots": len(outer_slots), "core_fixup_slots": len(core_slots),
        "function_starts": len(function_starts),
        "unwind_entries": len(unwind_rows), "exception_lsda_entries": len(lsda),
        "export_nonlazy_objc_classes": export_classes,
        "core_executable_bytes_preserved": True, "signature_page_hashes_valid": True,
        "dyld_layout_preflight": True,
    }


def main():
    parser = argparse.ArgumentParser(description=__doc__)
    parser.add_argument("--core", type=Path, required=True)
    parser.add_argument("--export-image", type=Path, required=True)
    parser.add_argument("--output", type=Path, required=True)
    args = parser.parse_args()
    result, report = merge(args.core.read_bytes(), args.export_image.read_bytes())
    args.output.parent.mkdir(parents=True, exist_ok=True)
    args.output.write_bytes(result)
    args.output.with_suffix(".merge.json").write_text(json.dumps(report, indent=2) + "\n", encoding="utf-8")
    print(json.dumps(report, indent=2))


if __name__ == "__main__":
    main()
