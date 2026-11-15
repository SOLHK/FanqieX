import bisect
from pathlib import Path
import struct
import sys
import unittest

ROOT = Path(__file__).resolve().parents[1]
sys.path.insert(0, str(ROOT / 'repair162'))
from macho_tools import assemble_object, sections
from native_unwind import (add_native_unwind, compressed_unwind, decode_unwind,
                           object_entries, regular_unwind)


ASSEMBLY = '''.text
.space 0x14000
Lfirst:
.cfi_startproc
stp x20,x19,[sp,#-32]!
stp x29,x30,[sp,#16]
add x29,sp,#16
.cfi_def_cfa w29,16
.cfi_offset w30,-8
.cfi_offset w29,-16
.cfi_offset w19,-24
.cfi_offset w20,-32
bl Lleaf
ldp x29,x30,[sp,#16]
ldp x20,x19,[sp],#32
ret
.cfi_endproc
.space 16
Lleaf:
.cfi_startproc
ret
.cfi_endproc
'''


class NativeUnwindTests(unittest.TestCase):
    @classmethod
    def setUpClass(cls):
        cls.obj = assemble_object(ASSEMBLY)
        cls.image = (ROOT / 'dist/1.6.3/FanqieX-1.6.3.dylib').read_bytes()

    def test_real_assembler_register_encoding_and_gap_boundaries(self):
        native = object_entries(self.obj)
        self.assertEqual(native[0]['encoding'], 0x04000001)
        self.assertEqual(native[1]['encoding'], 0x02000000)
        updated, report = add_native_unwind(self.image, self.obj)
        self.assertEqual(len(updated), len(self.image))
        a, n = report['section_offset'], report['section_size']
        self.assertEqual(updated[:a], self.image[:a])
        self.assertEqual(updated[a+n:], self.image[a+n:])
        old, old_limit = decode_unwind(self.image[a:a+n])
        merged, limit = decode_unwind(updated[a:a+n])
        self.assertEqual(merged[:len(old)], old)
        self.assertEqual(dict(merged)[old_limit], 0)
        self.assertEqual(dict(merged)[native[0]['end']], 0)
        starts = [item[0] for item in merged]
        for entry in native:
            for pc in range(entry['start'], entry['end'], 4):
                self.assertEqual(merged[bisect.bisect_right(starts, pc)-1][1], entry['encoding'])
        self.assertEqual(limit, native[-1]['end'])
        self.assertEqual(list(sections(updated)), list(sections(self.image)))

    def test_compiler_contract_rejects_external_or_dwarf_unwind(self):
        slot = next(item for item in sections(self.obj) if item['name'] == '__compact_unwind')
        for offset, value in [(slot['offset'] + 12, 0x03000000),
                              (slot['reloc_offset'] + 4, 0x0E000001)]:
            corrupt = bytearray(self.obj)
            struct.pack_into('<I', corrupt, offset, value)
            with self.assertRaises(ValueError):
                object_entries(bytes(corrupt))
        corrupt = bytearray(self.obj)
        struct.pack_into('<Q', corrupt, slot['offset'] + 16, 1)
        with self.assertRaises(ValueError):
            object_entries(bytes(corrupt))

    def test_regular_page_capacity_and_corrupt_index_fail(self):
        with self.assertRaises(ValueError):
            regular_unwind([(4 * i, 0x02000000) for i in range(512)], 4096, 4216)
        with self.assertRaises(ValueError):
            regular_unwind([(4, 0x02000000)], 8, 4096)
        valid = bytearray(regular_unwind([(4, 0x02000000)], 8, 4216))
        struct.pack_into('<I', valid, 28 + 4, 0xFFFFFFFC)
        with self.assertRaises(ValueError):
            decode_unwind(bytes(valid))

    def test_regular_and_compressed_pages_preserve_identical_records(self):
        sys.path.insert(0, str(ROOT / 'audit162'))
        from unwind_audit import decode
        encodings = (0, 0x02000000, 0x04000001)
        entries = [(0x100 + 4 * i, encodings[i % len(encodings)]) for i in range(450)]
        limit = entries[-1][0] + 4
        regular = regular_unwind(entries, limit, 4216)
        compressed = compressed_unwind(entries, limit, 4216)
        self.assertEqual(decode_unwind(regular), decode_unwind(compressed))
        self.assertEqual(decode(regular), (entries, limit, [2]))
        self.assertEqual(decode(compressed), (entries, limit, [3]))
        self.assertEqual(compressed, compressed_unwind(entries, limit, 4216))

    def test_more_than_511_assembler_records_require_explicit_compression(self):
        source = '.text\n.space 0x14000\n' + '\n'.join(
            f'Lleaf{i}:\n.cfi_startproc\nret\n.cfi_endproc\n.space 4\n'
            for i in range(520))
        obj = assemble_object(source)
        with self.assertRaises(ValueError):
            add_native_unwind(self.image, obj)
        # 520 functions plus 519 explicit gaps and original records exceeds a
        # compressed page too: compression must not silently discard boundaries.
        with self.assertRaises(ValueError):
            add_native_unwind(self.image, obj, allow_compressed=True)
        source = source.replace('.cfi_endproc\n.space 4', '.cfi_endproc')
        obj = assemble_object(source)
        native = object_entries(obj)
        updated, report = add_native_unwind(self.image, obj, allow_compressed=True)
        self.assertEqual(report['page_format'], 'compressed')
        self.assertEqual(report['native_entry_count'], 520)
        start, size = report['section_offset'], report['section_size']
        old, old_limit = decode_unwind(self.image[start:start + size])
        merged, limit = decode_unwind(updated[start:start + size])
        self.assertEqual(merged[:len(old)], old)
        self.assertEqual(dict(merged)[old_limit], 0)
        self.assertEqual([(row['start'], row['encoding']) for row in native], merged[len(old) + 1:])
        self.assertEqual(limit, native[-1]['end'])
        self.assertEqual(updated[:start], self.image[:start])
        self.assertEqual(updated[start + size:], self.image[start + size:])
        self.assertEqual(list(sections(updated)), list(sections(self.image)))

    def test_compressed_boundaries_and_corrupt_tables_fail_closed(self):
        good = [(0, 0x02000000), (4, 0)]
        invalid = [
            ([], 8, 4216),
            ([(4 * i, 0x02000000) for i in range(1022)], 4096, 4216),
            ([(4 * i, 0x02000000 if i % 2 else 0) for i in range(1020)], 4096, 4216),
            ([(0, 0x02000000), (0x1000000, 0x02000000)], 0x1000004, 4216),
            ([(4 * i, 0x02000000 | i << 12) for i in range(257)], 4096, 4216),
            (good, 8, 4096),
            (list(reversed(good)), 8, 4216),
            ([(0, 0x03000000)], 4, 4216),
        ]
        for entries, limit, capacity in invalid:
            with self.subTest(count=len(entries), limit=limit, capacity=capacity), self.assertRaises(ValueError):
                compressed_unwind(entries, limit, capacity)
        edge = [(4 * i, 0x02000000 | i << 12) for i in range(256)]
        self.assertEqual(decode_unwind(compressed_unwind(edge, 1024, 4216)), (edge, 1024))
        far = [(0, 0x02000000), (0xfffffc, 0x02000000)]
        self.assertEqual(decode_unwind(compressed_unwind(far, 0x1000000, 4216)), (far, 0x1000000))
        valid = compressed_unwind(good, 8, 4216)
        page = 52
        for offset, fmt, value in ((page + 12, '<I', 0xff000000),
                                   (page + 8, '<H', 12),
                                   (page + 10, '<H', 257),
                                   (page + 6, '<H', 1022)):
            corrupt = bytearray(valid)
            struct.pack_into(fmt, corrupt, offset, value)
            with self.subTest(offset=offset, value=value), self.assertRaises(ValueError):
                decode_unwind(bytes(corrupt))


if __name__ == '__main__':
    unittest.main()
