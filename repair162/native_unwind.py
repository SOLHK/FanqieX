#!/usr/bin/env python3
"""Merge assembler-produced ARM64 compact unwind into the existing image slot.

The native component supplies .cfi directives. LLVM's actual Mach-O assembler
encodes its frames in __LD,__compact_unwind; this module does not guess frames.
The pinned final image has an existing 4216-byte __TEXT,__unwind_info slot large
enough for one regular second-level page. No section, import or fixup is added.

Format authority:
https://github.com/llvm/llvm-project/blob/main/libunwind/include/mach-o/compact_unwind_encoding.h
"""
from __future__ import annotations

import hashlib
import struct

from macho_tools import sections


def need(condition: bool, message: str) -> None:
    if not condition:
        raise ValueError(message)


def span(data: bytes, offset: int, size: int) -> bytes:
    need(offset >= 0 and size >= 0 and offset + size <= len(data), 'Unwind data out of bounds')
    return data[offset:offset + size]


def encoding_supported(encoding: int) -> bool:
    # No personality, LSDA or DWARF FDE relocation exists in the runtime-only
    # module. Accept LLVM's direct arm64 frame and frameless encodings only.
    return ((encoding & 0x0F000000 == 0x04000000 and encoding & ~0x04000F1F == 0) or
            (encoding & 0x0F000000 == 0x02000000 and encoding & ~0x02FFF000 == 0))


def object_entries(data: bytes, *, image_base: int = 0x800) -> list[dict]:
    """Read local text relocations from LLVM's assembled composition object."""
    need(len(data) >= 32 and struct.unpack_from('<4I', data) ==
         (0xFEEDFACF, 0x100000C, 0, 1), 'Expected an arm64 MH_OBJECT')
    all_sections = list(sections(data))
    text = [(i + 1, item) for i, item in enumerate(all_sections) if item['name'] == '__text']
    compact = [item for item in all_sections if item['name'] == '__compact_unwind']
    need(len(text) == 1 and len(compact) == 1, 'Expected text and assembler compact unwind')
    text_index, code = text[0]
    unwind = compact[0]
    need(unwind['size'] > 0 and unwind['size'] % 32 == 0,
         'Invalid compact unwind object table length')
    count = unwind['size'] // 32
    need(unwind['reloc_count'] == count, 'Expected one function relocation per unwind entry')
    relocs = {}
    for index in range(count):
        offset = unwind['reloc_offset'] + index * 8
        address, info = struct.unpack('<iI', span(data, offset, 8))
        # ARM64_RELOC_UNSIGNED, 64-bit, non-PC-relative, local text section.
        need(address >= 0 and address % 32 == 0 and address < unwind['size'] and
             info == (3 << 25) | text_index and address not in relocs,
             'Unsupported compact unwind function relocation')
        relocs[address] = True
    result = []
    for index in range(count):
        start, length, encoding, personality, lsda = struct.unpack(
            '<QIIQQ', span(data, unwind['offset'] + index * 32, 32))
        need(index * 32 in relocs and personality == lsda == 0,
             'Native unwind personality or LSDA is unsupported')
        need(encoding_supported(encoding), f'Unsupported native compact encoding {encoding:#x}')
        need(code['address'] <= start and length > 0 and start + length <= code['address'] + code['size'] and
             start % 4 == 0 and length % 4 == 0, 'Native unwind function outside text')
        result.append({'start': image_base + start - code['address'],
                       'end': image_base + start - code['address'] + length,
                       'encoding': encoding})
    result.sort(key=lambda item: item['start'])
    need(all(left['end'] <= right['start'] for left, right in zip(result, result[1:])),
         'Overlapping native unwind functions')
    return result


def decode_unwind(blob: bytes) -> tuple[list[tuple[int, int]], int]:
    """Decode final regular/compressed pages without assuming a common table."""
    version, common_off, common_count, personality_off, personalities, index_off, index_count = \
        struct.unpack('<7I', span(blob, 0, 28))
    need(version == 1 and personalities == 0 and index_count >= 2,
         'Unsupported unwind header or personality table')
    span(blob, personality_off, 0)
    common = list(struct.unpack('<' + 'I' * common_count, span(blob, common_off, common_count * 4)))
    indices = [struct.unpack('<III', span(blob, index_off + i * 12, 12))
               for i in range(index_count)]
    need(indices[-1][1] == 0 and all(a[0] < b[0] for a, b in zip(indices, indices[1:])),
         'Invalid unwind first-level index')
    need(len({entry[2] for entry in indices}) == 1, 'Unwind LSDA is unsupported')
    result = []
    for current, following in zip(indices, indices[1:]):
        function, page, _ = current
        kind = struct.unpack('<I', span(blob, page, 4))[0]
        if kind == 2:
            _, entries_off, count = struct.unpack('<IHH', span(blob, page, 8))
            need(entries_off >= 8 and 0 < count <= 511 and entries_off + count * 8 <= 4096,
                 'Invalid regular unwind page')
            entries = [struct.unpack('<II', span(blob, page + entries_off + i * 8, 8))
                       for i in range(count)]
        elif kind == 3:
            _, entries_off, count, local_off, local_count = struct.unpack('<IHHHH', span(blob, page, 12))
            need(entries_off >= 12 and count > 0 and entries_off + count * 4 <= 4096 and
                 local_off + local_count * 4 <= 4096, 'Invalid compressed unwind page')
            local = list(struct.unpack('<' + 'I' * local_count,
                                      span(blob, page + local_off, local_count * 4)))
            encodings = common + local
            entries = []
            for i in range(count):
                packed = struct.unpack('<I', span(blob, page + entries_off + i * 4, 4))[0]
                selector = packed >> 24
                need(selector < len(encodings), 'Invalid compressed unwind encoding index')
                entries.append((function + (packed & 0xFFFFFF), encodings[selector]))
        else:
            raise ValueError('Unsupported unwind second-level page kind')
        need(entries[0][0] == function and all(function <= item[0] < following[0] for item in entries) and
             all(a[0] < b[0] for a, b in zip(entries, entries[1:])), 'Invalid unwind function range')
        need(all(encoding == 0 or encoding_supported(encoding) for _, encoding in entries),
             'Unsupported original unwind encoding')
        result.extend(entries)
    return result, indices[-1][0]


def regular_unwind(entries: list[tuple[int, int]], limit: int, capacity: int) -> bytes:
    need(0 < len(entries) <= 511 and all(0 <= start < limit <= 0xFFFFFFFF for start, _ in entries) and
         all(a[0] < b[0] for a, b in zip(entries, entries[1:])), 'Merged unwind exceeds one regular page')
    page_offset = 28 + 24
    need(page_offset + 4096 <= capacity, 'Existing unwind slot is too small')
    blob = bytearray(capacity)
    struct.pack_into('<7I', blob, 0, 1, 28, 0, 28, 0, 28, 2)
    struct.pack_into('<III', blob, 28, entries[0][0], page_offset, page_offset)
    struct.pack_into('<III', blob, 40, limit, 0, page_offset)
    struct.pack_into('<IHH', blob, page_offset, 2, 8, len(entries))
    for index, entry in enumerate(entries):
        struct.pack_into('<II', blob, page_offset + 8 + index * 8, *entry)
    need(decode_unwind(bytes(blob)) == (entries, limit), 'Merged unwind round trip failed')
    return bytes(blob)


def add_native_unwind(image: bytes, assembled_object: bytes, *, image_base: int = 0x800) -> tuple[bytes, dict]:
    """Rewrite the existing unwind bytes, leaving every section descriptor fixed.

    Call before final signing/extend. Returns (patched_image, audit_report).
    ``assembled_object`` is the same object used to extract composition text.
    """
    targets = [item for item in sections(image) if item['name'] == '__unwind_info']
    need(len(targets) == 1 and targets[0]['segment'] == '__TEXT', 'Expected pinned unwind slot')
    slot = targets[0]
    old = span(image, slot['offset'], slot['size'])
    original, old_limit = decode_unwind(old)
    native = object_entries(assembled_object, image_base=image_base)
    need(native and native[0]['start'] >= old_limit, 'Native unwind overlaps original image code')
    # Explicit zero records bound every gap. In particular the old sentinel
    # becomes a zero record so its final original encoding cannot leak into
    # the unannotated original stubs or hand-written patch assembly.
    merged = dict(original)
    merged[old_limit] = 0
    for entry in native:
        merged[entry['start']] = entry['encoding']
        merged[entry['end']] = 0
    limit = native[-1]['end']
    merged.pop(limit)
    entries = sorted(merged.items())
    payload = regular_unwind(entries, limit, slot['size'])
    result = bytearray(image)
    result[slot['offset']:slot['offset'] + slot['size']] = payload
    report = {'passed': True, 'scope': 'Assembler-derived native ARM64 compact unwind; existing slot rewritten',
              'section_offset': slot['offset'], 'section_size': slot['size'],
              'original_entry_count': len(original), 'native_entry_count': len(native),
              'merged_entry_count': len(entries), 'original_limit': old_limit, 'merged_limit': limit,
              'section_descriptors_unchanged': True, 'native_entries': native,
              'original_sha256': hashlib.sha256(old).hexdigest(),
              'merged_sha256': hashlib.sha256(payload).hexdigest()}
    return bytes(result), report
