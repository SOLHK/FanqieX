"""Synthetic fixtures only: these tests do not inspect the user's uploaded ZIP."""
import io
from pathlib import Path
import plistlib
import stat
import struct
import sys
import tempfile
import unittest
import uuid
import warnings
import zipfile

sys.path.insert(0, str(Path(__file__).resolve().parents[1] / 'scripts'))
from inspect_reverse_archive import InspectionError, Limits, inspect_archive, macho_metadata

FIXTURE_UUID = uuid.UUID('00112233-4455-6677-8899-aabbccddeeff')


def thin(endian='<', subtype=0, extra=b'', extra_count=0):
    commands = struct.pack(endian + 'II', 0x1b, 24) + FIXTURE_UUID.bytes + extra
    return struct.pack(endian + '8I', 0xfeedfacf, 0x100000c, subtype, 2, 1 + extra_count, len(commands), 0, 0) + commands


def fat(binary, fat64=False, endian='>'):
    magic = 0xcafebabf if fat64 else 0xcafebabe
    row = struct.pack(endian + ('IIQQII' if fat64 else 'IIIII'),
                      *([0x100000c, 0, 4096, len(binary), 12, 0] if fat64 else
                        [0x100000c, 0, 4096, len(binary), 12]))
    header = struct.pack(endian + 'II', magic, 1) + row
    return header + bytes(4096 - len(header)) + binary


class MachOTests(unittest.TestCase):
    def parse(self, data):
        return macho_metadata(io.BytesIO(data), len(data))

    def test_thin_arm64_uuid_both_byte_orders(self):
        for endian in ('<', '>'):
            with self.subTest(endian=endian):
                result = self.parse(thin(endian))['slices'][0]
                self.assertEqual(result['uuid'], str(FIXTURE_UUID))
                self.assertEqual(result['architecture'], 'arm64')
                self.assertFalse(result['runtime_abi_verified'])

    def test_arm64e_subtype(self):
        self.assertEqual(self.parse(thin(subtype=2))['slices'][0]['architecture'], 'arm64e')

    def test_fat_formats_both_byte_orders(self):
        for wide in (False, True):
            for endian in ('<', '>'):
                with self.subTest(wide=wide, endian=endian):
                    result = self.parse(fat(thin(), wide, endian))
                    self.assertEqual(result['slices'][0]['uuid'], str(FIXTURE_UUID))

    def test_dylib_dependency(self):
        name = b'/System/Library/Frameworks/UIKit.framework/UIKit\0'
        size = (24 + len(name) + 7) & ~7
        command = struct.pack('<6I', 0xc, size, 24, 0, 0, 0) + name
        command += bytes(size - len(command))
        result = self.parse(thin(extra=command, extra_count=1))['slices'][0]
        self.assertEqual(result['dependencies'], [{'kind': 'load', 'name': name[:-1].decode()}])

    def test_invalid_dylib_name_is_rejected(self):
        command = struct.pack('<6I', 0xc, 24, 1000, 0, 0, 0)
        with self.assertRaises(InspectionError):
            self.parse(thin(extra=command, extra_count=1))

    def test_truncated_and_oversized_commands(self):
        for data in (thin()[:20], thin()[:-1], thin(extra=struct.pack('<II', 1, 0), extra_count=1)):
            with self.subTest(length=len(data)), self.assertRaises(InspectionError):
                self.parse(data)

    def test_fat_architecture_mismatch(self):
        data = bytearray(fat(thin()))
        struct.pack_into('>I', data, 8, 12)
        with self.assertRaises(InspectionError):
            self.parse(data)

    def test_fat_range_is_bounded(self):
        data = bytearray(fat(thin()))
        struct.pack_into('>I', data, 20, len(data) + 1)
        with self.assertRaises(InspectionError):
            self.parse(data)

    def test_duplicate_uuid_is_rejected(self):
        command = struct.pack('<II', 0x1b, 24) + FIXTURE_UUID.bytes
        with self.assertRaises(InspectionError):
            self.parse(thin(extra=command, extra_count=1))


class ArchiveTests(unittest.TestCase):
    def setUp(self):
        self.temp = tempfile.TemporaryDirectory()
        self.addCleanup(self.temp.cleanup)
        self.path = Path(self.temp.name) / 'fixture.zip'

    def archive(self, members, compression=zipfile.ZIP_STORED):
        with warnings.catch_warnings():
            warnings.simplefilter('ignore', UserWarning)
            with zipfile.ZipFile(self.path, 'w', compression=compression) as archive:
                for name, data in members:
                    archive.writestr(name, data)
        return self.path

    def test_actual_plist_values_not_legacy_assumptions(self):
        values = {'CFBundleIdentifier': 'example.fixture', 'CFBundleVersion': '123',
                  'CFBundleShortVersionString': '4.5.6', 'CFBundleExecutable': 'Fixture',
                  'CFBundlePackageType': 'APPL'}
        result = inspect_archive(self.archive([
            ('Payload/Fixture.app/Info.plist', plistlib.dumps(values, fmt=plistlib.FMT_BINARY)),
            ('Payload/Fixture.app/Fixture', thin()),
        ]))
        self.assertEqual(result['host_identity']['CFBundleIdentifier'], 'example.fixture')
        self.assertEqual(result['host_identity']['CFBundleVersion'], '123')
        self.assertTrue(result['whole_archive_crc_verified'])
        self.assertTrue(result['raw_macho_present'])
        self.assertEqual(len(result['inventory']), 2)

    def test_missing_material_is_not_inferred(self):
        result = inspect_archive(self.archive([('readme.txt', 'no binary or class dump')]))
        self.assertIsNone(result['host_identity'])
        self.assertFalse(result['raw_macho_present'])
        self.assertFalse(result['header_files_present'])
        self.assertFalse(result['runtime_abi_verified'])
        self.assertFalse(result['target_ad_insertion_chain_verified'])

    def test_header_or_ad_text_is_not_runtime_evidence(self):
        text = '@interface FixtureControl : NSObject\n@property int example;\n- (void)layoutSubviews;\n// 羊了个羊 advertisement\n@end\n'
        result = inspect_archive(self.archive([('FixtureControl.h', text)]))
        kinds = {match['kind'] for row in result['text_evidence'] for match in row['matches']}
        self.assertIn('class_inheritance_declaration', kinds)
        self.assertIn('ad_component_candidate', kinds)
        self.assertFalse(result['runtime_abi_verified'])
        self.assertFalse(result['target_ad_insertion_chain_verified'])

    def test_traversal_absolute_and_windows_paths(self):
        for name in ('../escape', '/absolute', 'C:/absolute', 'folder\\escape', 'a/../b', 'a//b'):
            with self.subTest(name=name), self.assertRaises(InspectionError):
                inspect_archive(self.archive([(name, b'x')]))
        self.assertEqual(list(Path(self.temp.name).iterdir()), [self.path])

    def test_duplicate_paths_rejected(self):
        for names in (('same', 'same'), ('Same', 'same'), ('cafe\u0301.h', 'caf\u00e9.h')):
            with self.subTest(names=names), self.assertRaises(InspectionError):
                inspect_archive(self.archive([(name, b'x') for name in names]))

    def test_symlink_rejected(self):
        info = zipfile.ZipInfo('link')
        info.create_system = 3
        info.external_attr = (stat.S_IFLNK | 0o777) << 16
        with self.assertRaises(InspectionError):
            inspect_archive(self.archive([(info, '../target')]))

    def test_budgets_enforced(self):
        self.archive([('one', b'1234'), ('two', b'5678')])
        for limits in (Limits(members=1), Limits(total_bytes=7), Limits(member_bytes=3)):
            with self.subTest(limits=limits), self.assertRaises(InspectionError):
                inspect_archive(self.path, limits)

    def test_compression_ratio_rejected(self):
        path = self.archive([('bomb.txt', b'0' * 65536)], zipfile.ZIP_DEFLATED)
        with self.assertRaises(InspectionError):
            inspect_archive(path, Limits(compression_ratio=10))

    def test_crc_damage_detected(self):
        self.archive([('ordinary.txt', b'unique-fixture-content')])
        damaged = self.path.read_bytes().replace(b'unique-fixture-content', b'broken-fixture-content')
        self.path.write_bytes(damaged)
        with self.assertRaises(zipfile.BadZipFile):
            inspect_archive(self.path)

    def test_crc_optout_is_explicit(self):
        result = inspect_archive(self.archive([('readme.txt', b'ok')]), verify_crc=False)
        self.assertFalse(result['whole_archive_crc_verified'])

    def test_truncated_text_is_reported(self):
        result = inspect_archive(self.archive([('large.h', 'x' * 100)]), Limits(text_bytes=10))
        self.assertTrue(result['text_scan_truncated'])
        self.assertFalse(result['runtime_abi_verified'])

    def test_multiple_app_plists_are_ambiguous(self):
        value = plistlib.dumps({'CFBundlePackageType': 'APPL', 'CFBundleIdentifier': 'example.fixture'})
        result = inspect_archive(self.archive([('A.app/Info.plist', value), ('B.app/Info.plist', value)]))
        self.assertIsNone(result['host_identity'])
        self.assertEqual(len(result['main_app_plist_candidates']), 2)

    def test_malformed_plist_is_not_silently_accepted(self):
        with self.assertRaises(InspectionError):
            inspect_archive(self.archive([('Info.plist', b'not a plist')]))


if __name__ == '__main__':
    unittest.main()
