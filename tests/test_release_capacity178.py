"""Version-specific expansion must not relax earlier release capacity limits."""
from pathlib import Path
import struct
import sys
import unittest

ROOT = Path(__file__).resolve().parents[1]
sys.path.insert(0, str(ROOT / 'repair162'))
sys.path.insert(0, str(ROOT / 'audit162'))
import build_plugin
from audit_extend import audit as audit_extension_layout
from extend_macho import extend, verify_extension, verify_signature
from independent159 import Image, check_layout


class ReleaseCapacityTests(unittest.TestCase):
    def test_production_directory_preserves_each_release_limit(self):
        header = bytearray((ROOT / 'dist/1.75/FanqieX-1.75.dylib').read_bytes()[0x800:0x900])
        extension = struct.unpack_from('<I', header, 60 * 4)[0]
        for version, allowed in ((0x14c00, 0x34000), (0x14e00, 0x3c000), (0x14e02, 0x3c000), (0x14e03, 0x3c000),
                                 (0x14e04, 0x40000), (0x14e05, 0x40000), (0x14e06, 0x40000), (0x14e07, 0x44000), (0x14e08, 0x44000), (0x14e09, 0x44000), (0x14e0a, 0x48000), (0x14e0b, 0x48000), (0x14e0c, 0x4c000), (0x14e0d, 0x50000), (0x14e0e, 0x50000), (0x14e0f, 0x54000), (0x14e10, 0x54000), (0x14e19, 0x58000), (0x14e1a, 0x58000), (0x14e1b, 0x58000), (0x14e1c, 0x58000), (0x14e1d, 0x5c000), (0x14e1e, 0x5c000), (0x14e1f, 0x5c000), (0x14e20, 0x5c000), (0x14e21, 0x5c000), (0x14e22, 0x5c000), (0x14e23, 0x5c000)):
            struct.pack_into('<I', header, 6 * 4, version)
            self.assertEqual(build_plugin.extension_limit(version), allowed)
            for capacity in (0x34000, 0x38000, 0x3c000, 0x40000, 0x44000, 0x48000, 0x4c000, 0x50000, 0x54000, 0x58000, 0x5c000, allowed + 4):
                struct.pack_into('<I', header, 63 * 4, extension + capacity)
                with self.subTest(version=hex(version), capacity=hex(capacity)):
                    if capacity <= allowed:
                        build_plugin.directory(header, version)
                    else:
                        with self.assertRaises(ValueError):
                            build_plugin.directory(header, version)

    def test_independent_layout_keeps_each_added_page_version_scoped(self):
        source = (ROOT / 'baseline/FanqieAdBlock-1.5.6.dylib').read_bytes()
        old = Image((ROOT / 'baseline/FanqieAdBlock-1.5.8.dylib').read_bytes())
        payload = bytes.fromhex('c0035fd6')
        for capacity in (0x34000, 0x38000, 0x3c000, 0x40000, 0x44000, 0x48000, 0x4c000, 0x50000, 0x54000, 0x58000, 0x5c000):
            image = Image(extend(source, payload, capacity=capacity))
            for version, allowed in (('1.76', 0x34000), ('1.78', 0x3c000), ('1.78R2', 0x3c000), ('1.78R3', 0x3c000),
                                     ('1.78R4', 0x40000), ('1.78R5', 0x40000), ('1.78R6', 0x40000), ('1.78R7', 0x44000), ('1.78R8', 0x44000), ('1.78R9', 0x44000), ('1.78R10', 0x48000), ('1.78R11', 0x48000), ('1.78R12', 0x4c000), ('1.78R13', 0x50000), ('1.78R14', 0x50000), ('1.78R15', 0x54000), ('1.78R16', 0x54000), ("1.78R25", 0x58000), ("1.78R26", 0x58000), ("1.78R27", 0x58000), ("1.78R28", 0x58000), ("1.78R29", 0x5c000), ("1.78R30", 0x5c000), ("1.78R31", 0x5c000), ("1.78R32", 0x5c000), ("1.78R33", 0x5c000), ("1.78R34", 0x5c000), ("1.78R35", 0x5c000)):
                with self.subTest(version=version, capacity=hex(capacity)):
                    if capacity <= allowed:
                        self.assertEqual(check_layout(old, image, version)['extension_capacity'], capacity)
                    else:
                        with self.assertRaises(ValueError):
                            check_layout(old, image, version)

    def test_added_pages_are_fully_signed(self):
        source = (ROOT / 'baseline/FanqieAdBlock-1.5.6.dylib').read_bytes()
        for payload_size, capacity in ((0x3c004, 0x40000), (0x40000, 0x40000), (0x40004, 0x44000), (0x44000, 0x44000), (0x44004, 0x48000), (0x48000, 0x48000), (0x48004, 0x4c000), (0x4c000, 0x4c000), (0x4c004, 0x50000), (0x50000, 0x50000), (0x50004, 0x54000), (0x54000, 0x54000), (0x54004, 0x58000), (0x58000, 0x58000), (0x58004, 0x5c000), (0x5c000, 0x5c000)):
            payload = bytes.fromhex('1f2003d5') * (payload_size // 4 - 1) + bytes.fromhex('c0035fd6')
            with self.subTest(bytes=hex(payload_size)):
                image = extend(source, payload, capacity=capacity)
                self.assertEqual(verify_extension(source, image, payload)['capacity'], capacity)
                self.assertTrue(verify_signature(image)['page_hashes_valid'])
                self.assertEqual(audit_extension_layout(source, image, payload)['extension_capacity'], capacity)
                self.assertEqual(image[0x14000:0x14000 + payload_size], payload)
                self.assertEqual(extend(source, payload), image)
                with self.assertRaises(ValueError):
                    extend(source, payload, capacity=capacity - 0x4000)

    def test_overflow_and_unaligned_capacities_are_rejected(self):
        source = (ROOT / 'baseline/FanqieAdBlock-1.5.6.dylib').read_bytes()
        payload = bytes.fromhex('c0035fd6')
        for capacity in (0x60000, 0x5c004, 0x54004, 0x50004, 0x4c004, 0x48004, 0x47fff, 0x41000):
            with self.subTest(capacity=hex(capacity)), self.assertRaises(ValueError):
                extend(source, payload, capacity=capacity)
        for invalid in (bytes(0x44004), b'123', b''):
            with self.subTest(payload_bytes=len(invalid)), self.assertRaises(ValueError):
                extend(source, invalid, capacity=0x44000)
        with self.assertRaises(ValueError):
            extend(source, bytes(0x5c004))


if __name__ == '__main__':
    unittest.main()
