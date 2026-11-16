"""Version-specific expansion must not relax earlier release capacity limits."""
from pathlib import Path
import struct
import sys
import unittest

ROOT = Path(__file__).resolve().parents[1]
sys.path.insert(0, str(ROOT / 'repair162'))
sys.path.insert(0, str(ROOT / 'audit162'))
import build_plugin
from extend_macho import extend
from independent159 import Image, check_layout


class ReleaseCapacityTests(unittest.TestCase):
    def test_production_directory_keeps_old_thirteen_page_limit(self):
        header = bytearray((ROOT / 'dist/1.75/FanqieX-1.75.dylib').read_bytes()[0x800:0x900])
        extension = struct.unpack_from('<I', header, 60 * 4)[0]
        for version, allowed in ((0x14c00, 0x34000), (0x14e00, 0x3c000), (0x14e02, 0x3c000)):
            struct.pack_into('<I', header, 6 * 4, version)
            for capacity in (0x34000, 0x38000, 0x3c000, 0x40000):
                struct.pack_into('<I', header, 63 * 4, extension + capacity)
                with self.subTest(version=hex(version), capacity=hex(capacity)):
                    if capacity <= allowed:
                        build_plugin.directory(header, version)
                    else:
                        with self.assertRaises(ValueError):
                            build_plugin.directory(header, version)

    def test_independent_layout_agrees_and_sixteen_pages_are_refused(self):
        source = (ROOT / 'baseline/FanqieAdBlock-1.5.6.dylib').read_bytes()
        old = Image((ROOT / 'baseline/FanqieAdBlock-1.5.8.dylib').read_bytes())
        payload = bytes.fromhex('c0035fd6')
        for capacity in (0x34000, 0x38000, 0x3c000):
            image = Image(extend(source, payload, capacity=capacity))
            for version in ('1.78', '1.78R2'):
                self.assertEqual(check_layout(old, image, version)['extension_capacity'], capacity)
            if capacity == 0x34000:
                check_layout(old, image, '1.76')
            else:
                with self.assertRaises(ValueError):
                    check_layout(old, image, '1.76')
        with self.assertRaises(ValueError):
            extend(source, payload, capacity=0x40000)


if __name__ == '__main__':
    unittest.main()
