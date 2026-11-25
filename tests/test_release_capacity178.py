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
                                 (0x14e04, 0x40000), (0x14e05, 0x40000), (0x14e06, 0x40000), (0x14e07, 0x44000), (0x14e08, 0x44000), (0x14e09, 0x44000), (0x14e0a, 0x48000), (0x14e0b, 0x48000), (0x14e0c, 0x4c000), (0x14e0d, 0x50000), (0x14e0e, 0x50000), (0x14e0f, 0x54000), (0x14e10, 0x54000), (0x14e19, 0x58000), (0x14e1a, 0x58000), (0x14e1b, 0x58000), (0x14e1c, 0x58000), (0x14e1d, 0x5c000), (0x14e1e, 0x5c000), (0x14e1f, 0x5c000), (0x14e20, 0x5c000), (0x14e21, 0x5c000), (0x14e22, 0x5c000), (0x14e23, 0x5c000), (0x14e24, 0x5c000), (0x14f01, 0x5c000), (0x14f02, 0x5c000), (0x14f03, 0x60000), (0x14f04, 0x60000), (0x14f05, 0x60000), (0x15001, 0x60000), (0x15002, 0x60000), (0x15003, 0x60000), (0x15004, 0x60000), (0x15005, 0x60000), (0x15006, 0x60000), (0x15007, 0x60000), (0x15008, 0x60000), (0x15009, 0x60000), (0x1500A, 0x60000), (0x1500B, 0x60000), (0x1500C, 0x60000), (0x1500D, 0x60000), (0x1500E, 0x60000), (0x1500F, 0x60000), (0x15010, 0x60000), (0x15011, 0x60000), (0x15012, 0x60000), (0x15013, 0x60000), (0x15101, 0x60000), (0x15102, 0x60000), (0x15103, 0x60000), (0x15104, 0x60000), (0x15105, 0x60000), (0x15106, 0x60000), (0x15107, 0x60000), (0x15108, 0x60000), (0x15109, 0x60000), (0x1510A, 0x60000), (0x1510B, 0x60000), (0x1510C, 0x60000), (0x1510D, 0x60000), (0x1510E, 0x60000), (0x1510F, 0x60000), (0x15110, 0x64000), (0x15111, 0x64000), (0x15112, 0x64000), (0x15113, 0x64000), (0x15114, 0x64000), (0x15115, 0x64000), (0x15116, 0x64000), (0x15117, 0x64000), (0x15118, 0x64000), (0x15119, 0x64000), (0x1511A, 0x64000), (0x15501, 0x64000), (0x15502, 0x64000), (0x15503, 0x64000), (0x15504, 0x64000), (0x15505, 0x64000), (0x15506, 0x64000), (0x15507, 0x64000), (0x15508, 0x64000), (0x15509, 0x64000), (0x15601, 0x64000), (0x15602, 0x64000), (0x15603, 0x64000), (0x15604, 0x64000), (0x15605, 0x64000), (0x15606, 0x64000), (0x15607, 0x64000), (0x15608, 0x64000), (0x15609, 0x64000), (0x15701, 0x64000), (0x15702, 0x64000), (0x15703, 0x64000), (0x15704, 0x64000), (0x15705, 0x64000), (0x15706, 0x64000), (0x15707, 0x64000), (0x15708, 0x64000), (0x15709, 0x64000), (0x1570A, 0x64000)):
            struct.pack_into('<I', header, 6 * 4, version)
            self.assertEqual(build_plugin.extension_limit(version), allowed)
            for capacity in (0x34000, 0x38000, 0x3c000, 0x40000, 0x44000, 0x48000, 0x4c000, 0x50000, 0x54000, 0x58000, 0x5c000, 0x60000, 0x64000, allowed + 4):
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
        for capacity in (0x34000, 0x38000, 0x3c000, 0x40000, 0x44000, 0x48000, 0x4c000, 0x50000, 0x54000, 0x58000, 0x5c000, 0x60000, 0x64000):
            image = Image(extend(source, payload, capacity=capacity))
            for version, allowed in (('1.76', 0x34000), ('1.78', 0x3c000), ('1.78R2', 0x3c000), ('1.78R3', 0x3c000),
                                     ('1.78R4', 0x40000), ('1.78R5', 0x40000), ('1.78R6', 0x40000), ('1.78R7', 0x44000), ('1.78R8', 0x44000), ('1.78R9', 0x44000), ('1.78R10', 0x48000), ('1.78R11', 0x48000), ('1.78R12', 0x4c000), ('1.78R13', 0x50000), ('1.78R14', 0x50000), ('1.78R15', 0x54000), ('1.78R16', 0x54000), ("1.78R25", 0x58000), ("1.78R26", 0x58000), ("1.78R27", 0x58000), ("1.78R28", 0x58000), ("1.78R29", 0x5c000), ("1.78R30", 0x5c000), ("1.78R31", 0x5c000), ("1.78R32", 0x5c000), ("1.78R33", 0x5c000), ("1.78R34", 0x5c000), ("1.78R35", 0x5c000), ("1.78R36", 0x5c000), ("1.79R1", 0x5c000), ("1.79R2", 0x5c000), ("1.79R3", 0x60000), ("1.79R4", 0x60000), ("1.79R5", 0x60000), ("1.8R1", 0x60000), ("1.8R2", 0x60000), ("1.8R3", 0x60000), ("1.8R4", 0x60000), ("1.8R5", 0x60000), ("1.8R6", 0x60000), ("1.8R7", 0x60000), ("1.8R8", 0x60000), ("1.9.1beta15", 0x60000), ("1.9.1beta16", 0x64000), ("1.9.1beta17", 0x64000), ("1.9.1beta18", 0x64000), ("1.9.1beta19", 0x64000), ("1.9.1beta20", 0x64000), ("1.9.1beta21", 0x64000), ("1.9.1beta22", 0x64000), ("1.9.1beta23", 0x64000), ("1.9.1beta24", 0x64000), ("1.9.1beta25", 0x64000), ("1.9.1beta26", 0x64000), ("1.9.5beta1", 0x64000), ("1.9.5beta2", 0x64000), ("1.9.5beta3", 0x64000), ("1.9.5beta4", 0x64000), ("1.9.5beta5", 0x64000), ("1.9.5beta6", 0x64000), ("1.9.5beta7", 0x64000), ("1.9.5beta8", 0x64000), ("1.9.5beta9", 0x64000), ("1.9.6beta1", 0x64000), ("1.9.6beta2", 0x64000), ("1.9.6beta3", 0x64000), ("1.9.6beta4", 0x64000), ("1.9.6beta5", 0x64000), ("1.9.6beta6", 0x64000), ("1.9.6beta7", 0x64000), ("1.9.6beta8", 0x64000), ("1.9.6beta9", 0x64000), ("1.9.7beta1", 0x64000), ("1.9.7beta2", 0x64000), ("1.9.7beta3", 0x64000), ("1.9.7beta4", 0x64000), ("1.9.7beta5", 0x64000), ("1.9.7beta6", 0x64000), ("1.9.7beta7", 0x64000), ("1.9.7beta8", 0x64000), ("1.9.7beta9", 0x64000), ("1.9.7beta10", 0x64000)):
                with self.subTest(version=version, capacity=hex(capacity)):
                    if capacity <= allowed:
                        self.assertEqual(check_layout(old, image, version)['extension_capacity'], capacity)
                    else:
                        with self.assertRaises(ValueError):
                            check_layout(old, image, version)

    def test_added_pages_are_fully_signed(self):
        source = (ROOT / 'baseline/FanqieAdBlock-1.5.6.dylib').read_bytes()
        for payload_size, capacity in ((0x3c004, 0x40000), (0x40000, 0x40000), (0x40004, 0x44000), (0x44000, 0x44000), (0x44004, 0x48000), (0x48000, 0x48000), (0x48004, 0x4c000), (0x4c000, 0x4c000), (0x4c004, 0x50000), (0x50000, 0x50000), (0x50004, 0x54000), (0x54000, 0x54000), (0x54004, 0x58000), (0x58000, 0x58000), (0x58004, 0x5c000), (0x5c000, 0x5c000), (0x5c004, 0x60000), (0x60000, 0x60000), (0x60004, 0x64000), (0x64000, 0x64000)):
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
        for capacity in (0x68000, 0x64004, 0x60004, 0x5c004, 0x54004, 0x50004, 0x4c004, 0x48004, 0x47fff, 0x41000):
            with self.subTest(capacity=hex(capacity)), self.assertRaises(ValueError):
                extend(source, payload, capacity=capacity)
        for invalid in (bytes(0x44004), b'123', b''):
            with self.subTest(payload_bytes=len(invalid)), self.assertRaises(ValueError):
                extend(source, invalid, capacity=0x44000)
        with self.assertRaises(ValueError):
            extend(source, bytes(0x64004))


if __name__ == '__main__':
    unittest.main()
