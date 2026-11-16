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
        for version, allowed in ((0x14c00, 0x34000), (0x14e00, 0x3c000), (0x14e02, 0x3c000), (0x14e03, 0x3c000), (0x14e04, 0x40000), (0x14e05, 0x40000), (0x14e06, 0x40000)):
            struct.pack_into('<I', header, 6 * 4, version)
            self.assertEqual(build_plugin.extension_limit(version), allowed)
            for capacity in (0x34000, 0x38000, 0x3c000, 0x40000, 0x44000, allowed + 4):
                struct.pack_into('<I', header, 63 * 4, extension + capacity)
                with self.subTest(version=hex(version), capacity=hex(capacity)):
                    if capacity <= allowed:
                        build_plugin.directory(header, version)
                    else:
                        with self.assertRaises(ValueError):
                            build_plugin.directory(header, version)

    def test_independent_layout_reserves_sixteen_pages_for_r4_through_r6(self):
        source = (ROOT / 'baseline/FanqieAdBlock-1.5.6.dylib').read_bytes()
        old = Image((ROOT / 'baseline/FanqieAdBlock-1.5.8.dylib').read_bytes())
        payload = bytes.fromhex('c0035fd6')
        for capacity in (0x34000, 0x38000, 0x3c000, 0x40000):
            image = Image(extend(source, payload, capacity=capacity))
            for version in ('1.78R4', '1.78R5', '1.78R6'):
                self.assertEqual(check_layout(old, image, version)['extension_capacity'], capacity)
            for version in ('1.78', '1.78R2', '1.78R3'):
                with self.subTest(version=version, capacity=hex(capacity)):
                    if capacity <= 0x3c000:
                        self.assertEqual(check_layout(old, image, version)['extension_capacity'], capacity)
                    else:
                        with self.assertRaises(ValueError):
                            check_layout(old, image, version)
            if capacity == 0x34000:
                check_layout(old, image, '1.76')
            else:
                with self.assertRaises(ValueError):
                    check_layout(old, image, '1.76')
    def test_real_sixteenth_page_payload_and_exact_end_are_fully_signed(self):
        source = (ROOT / 'baseline/FanqieAdBlock-1.5.6.dylib').read_bytes()
        for payload_size in (0x3c004, 0x40000):
            payload = bytes.fromhex('1f2003d5') * (payload_size // 4 - 1) + bytes.fromhex('c0035fd6')
            with self.subTest(bytes=hex(payload_size)):
                image = extend(source, payload, capacity=0x40000)
                self.assertEqual(verify_extension(source, image, payload)['capacity'], 0x40000)
                self.assertTrue(verify_signature(image)['page_hashes_valid'])
                self.assertEqual(audit_extension_layout(source, image, payload)['extension_capacity'], 0x40000)
                self.assertEqual(image[0x14000:0x14000 + payload_size], payload)
                # Auto capacity must select the same reviewed size, not silently
                # truncate the extension back to the older fifteen-page budget.
                self.assertEqual(extend(source, payload), image)
                with self.assertRaises(ValueError):
                    extend(source, payload, capacity=0x3c000)

    def test_overflow_and_unaligned_capacities_are_rejected(self):
        source = (ROOT / 'baseline/FanqieAdBlock-1.5.6.dylib').read_bytes()
        payload = bytes.fromhex('c0035fd6')
        for capacity in (0x44000, 0x40004, 0x3ffff, 0x41000):
            with self.subTest(capacity=hex(capacity)), self.assertRaises(ValueError):
                extend(source, payload, capacity=capacity)
        for invalid in (bytes(0x40004), b'123', b''):
            with self.subTest(payload_bytes=len(invalid)), self.assertRaises(ValueError):
                extend(source, invalid, capacity=0x40000)
        with self.assertRaises(ValueError):
            extend(source, bytes(0x40004))


if __name__ == '__main__':
    unittest.main()
