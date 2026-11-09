"""Independent ARM64 unwind audit; imports no production builder or decoder.

The pinned image has no personality functions or LSDA. Native C functions
must use standard frame-pointer or leaf compact encodings, verified directly
against their emitted prologue instructions.
"""
from __future__ import annotations

import hashlib
import struct


def need(value, message):
    if not value:
        raise ValueError('Native unwind: ' + message)


def read(data, offset, fmt):
    length = struct.calcsize(fmt)
    need(0 <= offset <= len(data) - length, 'truncated field')
    return struct.unpack_from(fmt, data, offset)


def image_layout(data):
    magic, cpu, _, kind, count, size, _, _ = read(data, 0, '<8I')
    need((magic, cpu, kind) == (0xFEEDFACF, 0x100000C, 6), 'expected ARM64 dylib')
    need(count <= 64 and 32 + size <= len(data), 'load-command span')
    cursor, segments, sections = 32, {}, {}
    for _ in range(count):
        cmd, length = read(data, cursor, '<II')
        need(length >= 8 and length % 8 == 0 and cursor + length <= 32 + size,
             'invalid load command')
        if cmd == 0x19:
            name, vm, vm_size, off, file_size, maximum, initial, nsect, _ = read(
                data, cursor + 8, '<16s4Q4I')
            name = name.rstrip(b'\0').decode('ascii')
            need(length == 72 + 80 * nsect and name not in segments, 'segment section count')
            need(off + file_size <= len(data), 'segment file bounds')
            segments[name] = (vm, vm_size, off, file_size, maximum, initial)
            for index in range(nsect):
                position = cursor + 72 + index * 80
                section, owner, address, section_size, fileoff, _, _, _, _, _, _, _ = read(
                    data, position, '<16s16sQQIIIIIIII')
                key = (owner.rstrip(b'\0').decode('ascii'), section.rstrip(b'\0').decode('ascii'))
                need(key not in sections and key[0] == name, 'duplicate or foreign section')
                need(vm <= address <= address + section_size <= vm + vm_size and
                     off <= fileoff <= fileoff + section_size <= off + file_size,
                     'section bounds')
                sections[key] = (address, fileoff, section_size, data[position:position + 80])
        cursor += length
    need(cursor == 32 + size, 'load-command total')
    return segments, sections


def supported(encoding):
    return (encoding == 0 or
            encoding & 0xFF000000 == 0x04000000 and encoding & ~0x04000F1F == 0 or
            encoding & 0xFF000000 == 0x02000000 and encoding & ~0x02FFF000 == 0)


def decode(blob):
    version, common_offset, common_count, personality_offset, personality_count, index_offset, index_count = read(blob, 0, '<7I')
    need(version == 1 and personality_count == 0 and 2 <= index_count <= 129 and
         common_count <= 256, 'unsupported table header')
    need(personality_offset % 4 == 0 and personality_offset <= len(blob), 'personality pointer')
    used = bytearray(len(blob))

    def claim(offset, length):
        need(offset % 4 == 0 and 0 <= offset <= len(blob) - length, 'table region bounds')
        need(not any(used[offset:offset + length]), 'overlapping table regions')
        used[offset:offset + length] = bytes([1]) * length

    claim(0, 28)
    claim(common_offset, common_count * 4)
    common = list(read(blob, common_offset, '<' + 'I' * common_count))
    claim(index_offset, index_count * 12)
    index = [read(blob, index_offset + i * 12, '<III') for i in range(index_count)]
    need(all(a[0] < b[0] for a, b in zip(index, index[1:])) and index[-1][1] == 0,
         'first-level ordering or sentinel')
    need(len({entry[2] for entry in index}) == 1 and index[0][2] <= len(blob), 'unexpected LSDA')
    entries, page_kinds = [], []
    for row, following in zip(index, index[1:]):
        base, page, _ = row
        need(page >= 28 and page + 4096 <= len(blob), 'second-level page bounds')
        kind, = read(blob, page, '<I')
        page_kinds.append(kind)
        if kind == 2:
            _, offset, count = read(blob, page, '<IHH')
            need(offset >= 8 and 0 < count <= 511 and offset + count * 8 <= 4096,
                 'regular page bounds')
            claim(page, 8)
            claim(page + offset, count * 8)
            page_entries = [read(blob, page + offset + i * 8, '<II') for i in range(count)]
        elif kind == 3:
            _, offset, count, local_offset, local_count = read(blob, page, '<IHHHH')
            need(offset >= 12 and 0 < count <= 1021 and offset + count * 4 <= 4096 and
                 local_offset >= 12 and local_offset + local_count * 4 <= 4096,
                 'compressed page bounds')
            claim(page, 12)
            claim(page + offset, count * 4)
            claim(page + local_offset, local_count * 4)
            encodings = common + list(read(blob, page + local_offset, '<' + 'I' * local_count))
            page_entries = []
            for i in range(count):
                packed, = read(blob, page + offset + i * 4, '<I')
                selector, delta = packed >> 24, packed & 0xFFFFFF
                need(selector < len(encodings), 'compressed encoding index')
                page_entries.append((base + delta, encodings[selector]))
        else:
            raise ValueError('Native unwind: unsupported second-level page')
        need(page_entries[0][0] == base and
             all(base <= item[0] < following[0] and item[0] % 4 == 0 and supported(item[1])
                 for item in page_entries) and
             all(a[0] < b[0] for a, b in zip(page_entries, page_entries[1:])),
             'entry alignment, ordering or encoding')
        entries.extend(page_entries)
    need(not any(byte for byte, occupied in zip(blob, used) if not occupied), 'nonzero table padding')
    return entries, index[-1][0], page_kinds


def instructions(data, start, end):
    need(start % 4 == end % 4 == 0 and start < end <= len(data), 'instruction range')
    return list(read(data, start, '<' + 'I' * ((end - start) // 4)))


def terminal(word):
    return word == 0xD65F03C0 or word & 0xFFFFFC1F == 0xD61F0000 or word & 0xFC000000 == 0x14000000


def frame_encoding(words):
    """Interpret only standard initial stack setup, independently of CFI."""
    sp, saves, fp = 0, {}, None
    for index, word in enumerate(words[:32]):
        if word == 0xD503201F:  # Alignment NOP, never a frame save.
            continue
        # Clang can shrink-wrap a null-input guard before the stack frame.
        # Its bypass path must go directly to a terminal leaf instruction;
        # all potentially throwing calls still execute the verified prologue.
        if sp == 0 and not saves and word & 0x7E000000 == 0x34000000:
            delta = (word >> 5) & 0x7FFFF
            target = index + (delta - (1 << 19) if delta & (1 << 18) else delta)
            need(index < target < len(words) and words[target] == 0xD65F03C0,
                 'unsupported pre-frame conditional path')
            continue
        if word & 0xFF8003FF == 0xD10003FF:  # sub sp,sp,#imm
            sp -= ((word >> 10) & 0xFFF) << (12 if word & (1 << 22) else 0)
            continue
        form = word & 0xFFC00000
        if form in (0xA9000000, 0xA9800000, 0x6D000000, 0x6D800000) and (word >> 5) & 31 == 31:
            immediate = (word >> 15) & 127
            immediate = (immediate - 128 if immediate & 64 else immediate) * 8
            if form in (0xA9800000, 0x6D800000):
                sp += immediate
                address = sp
            else:
                address = sp + immediate
            group = 'd' if form in (0x6D000000, 0x6D800000) else 'x'
            saves[(group, word & 31)] = address
            saves[(group, (word >> 10) & 31)] = address + 8
            continue
        if word & 0xFF8003FF == 0x910003FD:  # add/mov fp,sp,#imm
            fp = sp + (((word >> 10) & 0xFFF) << (12 if word & (1 << 22) else 0))
        break
    if fp is None:
        return None, -sp
    need(fp == -16 and saves.get(('x', 29)) == fp and saves.get(('x', 30)) == fp + 8,
         'nonstandard saved FP/LR locations')
    encoding, address = 0x04000000, fp - 8
    for group, pairs, bit_base in (('x', range(19, 29, 2), 0), ('d', range(8, 16, 2), 8)):
        for bit, low in enumerate(pairs):
            present = (group, low) in saves or (group, low + 1) in saves
            if present:
                need(saves.get((group, low)) == address and
                     saves.get((group, low + 1)) == address - 8,
                     'nonstandard callee-saved register pair layout')
                encoding |= 1 << (bit_base + bit)
                address -= 16
    return encoding, -sp


def check_native_unwind(baseline: bytes, candidate: bytes) -> dict:
    _, old_sections = image_layout(baseline)
    segments, new_sections = image_layout(candidate)
    key = ('__TEXT', '__unwind_info')
    need(key in old_sections and key in new_sections, 'missing unwind section')
    old_slot, slot = old_sections[key], new_sections[key]
    need(slot == old_slot, 'unwind section descriptor changed')
    _, offset, size, _ = slot
    old, old_end, _ = decode(baseline[offset:offset + size])
    current, end, kinds = decode(candidate[offset:offset + size])
    need(len(old) == 63 and old_end == 0xA574, 'unexpected pinned baseline unwind')
    need(current[:len(old)] == old, 'original 63 entries changed')
    need(current[len(old)] == (old_end, 0), 'old sentinel must become a zero range')
    need(kinds == [2], 'expected one bounded regular page')
    need('__FQPATCH' in segments, 'missing executable extension')
    vm, vm_size, fileoff, filesize, maximum, initial = segments['__FQPATCH']
    need(vm == fileoff == 0x14000 and vm_size == filesize and maximum == initial == 5,
         'unexpected extension mapping')
    words = read(candidate, 0x800, '<64I')
    code_start, code_end = vm + 128, 0x800 + words[61]
    need(code_start < code_end <= vm + vm_size and end <= code_end, 'extension code bounds')
    native = [(start, following[0], encoding) for (start, encoding), following in
              zip(current[len(old) + 1:], current[len(old) + 2:] + [(end, 0)]) if encoding]
    need(len(native) >= 3, 'missing native function metadata')
    starts = {start for start, _, _ in native}
    native_begin = native[0][0]
    checked_frames = checked_leaves = branches = 0
    for start, finish, encoding in native:
        need(code_start <= start < finish <= code_end, 'native unwind outside code')
        machine = instructions(candidate, start, finish)
        need(terminal(machine[-1]), 'function metadata includes trailing padding or another body')
        computed, stack_size = frame_encoding(machine)
        if encoding & 0xFF000000 == 0x04000000:
            need(computed == encoding, f'frame register encoding differs from prologue at {start:#x}')
            checked_frames += 1
        else:
            need(computed is None and stack_size == ((encoding >> 12) & 0xFFF) * 16,
                 f'leaf stack size differs from prologue at {start:#x}')
            need(not any(word & 0xFC000000 == 0x94000000 or
                         word & 0xFFFFFC1F == 0xD63F0000 for word in machine),
                 'frameless function overwrites LR with a call')
            checked_leaves += 1
        for index, word in enumerate(machine):
            pc = start + index * 4
            target = None
            if word & 0xFC000000 in (0x14000000, 0x94000000):
                displacement = word & 0x3FFFFFF
                target = pc + ((displacement - (1 << 26) if displacement & (1 << 25) else displacement) << 2)
                if start <= target < finish:
                    target = None
            elif word & 0x9F000000 == 0x10000000:  # ADR function-pointer references.
                displacement = ((word >> 5) & 0x7FFFF) << 2 | ((word >> 29) & 3)
                target = pc + (displacement - (1 << 21) if displacement & (1 << 20) else displacement)
            if target is not None and native_begin <= target < end:
                need(target in starts, f'native call or function address lacks metadata at {target:#x}')
                branches += 1
    for index in range(len(old) + 1, len(current)):
        start, encoding = current[index]
        finish = current[index + 1][0] if index + 1 < len(current) else end
        if not encoding:
            need(all(word == 0xD503201F for word in instructions(candidate, start, finish)),
                 'unwind gap hides native instructions')
    if end < code_end:
        need(all(word == 0xD503201F for word in instructions(candidate, end, code_end)),
             'native instructions after final unwind sentinel')
    need(candidate.count(b'FQ164DIA') == 1, 'native API directory absent or duplicated')
    marker = candidate.index(b'FQ164DIA')
    for address in read(candidate, marker + 8, '<3I'):
        need(0x800 + address in starts, 'diagnostic API entry lacks exact function metadata')
    return {'passed': True, 'original_entries_preserved': len(old),
            'native_functions': len(native), 'frame_prologues_checked': checked_frames,
            'leaf_functions_checked': checked_leaves, 'native_code_references_checked': branches,
            'old_sentinel_zero': True, 'section_descriptor_unchanged': True,
            'all_unused_table_bytes_zero': True, 'function_gaps_bounded': True,
            'table_sha256': hashlib.sha256(candidate[offset:offset + size]).hexdigest(),
            'scope': 'Independent compact-unwind decoding and emitted ARM64 frame-layout audit'}
