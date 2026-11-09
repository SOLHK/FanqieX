import bisect
from pathlib import Path
import struct
import sys
import unittest

ROOT = Path(__file__).resolve().parents[1]
sys.path.insert(0, str(ROOT / 'repair162'))
from macho_tools import assemble_object, sections
from native_unwind import add_native_unwind, decode_unwind, object_entries, regular_unwind


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


if __name__ == '__main__':
    unittest.main()
