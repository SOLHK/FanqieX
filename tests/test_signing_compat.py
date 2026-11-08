"""Synthetic parser/archive tests. Actual release/signing checks run separately in CI."""
import gzip
import importlib.util
import io
from pathlib import Path
import plistlib
import struct
import subprocess
import tempfile
import unittest
from unittest import mock
import zipfile

ROOT = Path(__file__).resolve().parents[1]
spec = importlib.util.spec_from_file_location('compat', ROOT / 'scripts/signing_compat.py')
c = importlib.util.module_from_spec(spec); spec.loader.exec_module(c)


def textcmd(cmd, text):
    base = 12 if cmd == 0x8000001c else 24
    raw = text.encode() + b'\0'
    size = (base + len(raw) + 7) & ~7
    return struct.pack('<III', cmd, size, base) + b'\0' * (base - 12) + raw.ljust(size - base, b'\0')


def fixture(*, host=False, load='@executable_path/Frameworks/' + c.NAME, rpath=None,
            encrypted=False, dependency=None, subtype=0, weak=False):
    cmds = [struct.pack('<6I', 0x32, 24, 2, 0x0f0001, 0x1a0000, 0)]
    if host:
        cmds.append(textcmd(0x80000018 if weak else 0xc, load))
    else:
        cmds.append(textcmd(0xd, '@rpath/' + c.NAME))
    if rpath:
        cmds.append(textcmd(0x8000001c, rpath))
    if dependency:
        cmds.append(textcmd(0xc, dependency))
    if encrypted:
        cmds.append(struct.pack('<6I', 0x2c, 24, 1024, 32, 1, 0))
    segment = struct.pack('<II16s4Q4I', 0x19, 152, b'__TEXT', 0, 4096, 0, 2048, 5, 5, 1, 0)
    section = struct.pack('<16s16sQQ8I', b'__init_offsets', b'__TEXT', 1024, 4, 1024, 2, 0, 0, 0x16, 0, 0, 0)
    cmds += [segment + section, struct.pack('<4I', 0x1d, 16, 2048, 12)]
    # The placeholder signature is deliberately NOT a cryptographic signing test.
    data = struct.pack('<8I', 0xfeedfacf, c.ARM64, subtype, 2 if host else 6, len(cmds), sum(map(len, cmds)), 0, 0)
    return (data + b''.join(cmds)).ljust(2060, b'\0')


def ipa(folder, host=None, plugin=None, extra=None):
    out = Path(folder) / 'fixture.ipa'
    members = {'Payload/Test.app/Info.plist': plistlib.dumps({'CFBundleExecutable': 'Test'}),
               'Payload/Test.app/Test': host or fixture(host=True),
               'Payload/Test.app/Frameworks/' + c.NAME: plugin or fixture()}
    members.update(extra or {})
    with zipfile.ZipFile(out, 'w') as z:
        for n, b in members.items(): z.writestr(n, b)
    dist = Path(folder) / 'dist' / c.VERSION; dist.mkdir(parents=True, exist_ok=True)
    (dist / c.NAME).write_bytes(fixture())
    return out


class Parsing(unittest.TestCase):
    def test_valid_generic_arm64(self):
        self.assertEqual(c.audit_plugin(fixture(), pinned=False)['structure']['minimum_os'], '15.0.1')
    def test_pin_is_mandatory_by_default(self):
        with self.assertRaisesRegex(ValueError, 'frozen'): c.audit_plugin(fixture())
    def test_truncated_header(self):
        for n in (0, 3, 31):
            with self.subTest(n=n), self.assertRaises(ValueError): c.commands(fixture()[:n])
    def test_bad_load_size(self):
        d = bytearray(fixture()); struct.pack_into('<I', d, 36, 7)
        with self.assertRaises(ValueError): c.inspect(d)
    def test_bad_command_count(self):
        d = bytearray(fixture()); struct.pack_into('<I', d, 16, 0xffffffff)
        with self.assertRaises(ValueError): c.inspect(d)
    def test_bad_string_offset(self):
        d = bytearray(fixture()); struct.pack_into('<I', d, 64, 1)
        with self.assertRaisesRegex(ValueError, 'name offset'): c.inspect(d)
    def test_external_dependency(self):
        with self.assertRaisesRegex(ValueError, 'Non-system'): c.audit_plugin(fixture(dependency='/usr/lib/libsubstrate.dylib'), pinned=False)
    def test_arm64e_only_rejected(self):
        with self.assertRaisesRegex(ValueError, 'generic ARM64'): c.audit_plugin(fixture(subtype=2), pinned=False)
    def test_bad_signature_bounds(self):
        d = bytearray(fixture()); off = next(o for cmd, o, n in c.commands(d) if cmd == 0x1d)
        struct.pack_into('<I', d, off + 8, 999999)
        with self.assertRaisesRegex(ValueError, 'outside file'): c.inspect(d)
    def test_fat(self):
        thin = fixture(); fat = struct.pack('>7I', 0xcafebabe, 1, c.ARM64, 0, 4096, len(thin), 12).ljust(4096, b'\0') + thin
        self.assertEqual(c.images(fat), [thin])
        damaged = bytearray(fat); struct.pack_into('>I', damaged, 16, 999999)
        with self.assertRaises(ValueError): c.images(damaged)
    def test_fat_cpu_mismatch(self):
        thin = fixture(); fat = struct.pack('>7I', 0xcafebabe, 1, c.ARM64, 2, 4096, len(thin), 12).ljust(4096, b'\0') + thin
        with self.assertRaisesRegex(ValueError, 'CPU mismatch'): c.images(fat)
    def test_loader_paths(self):
        app = 'Payload/Test.app'; loader = app + '/Test'
        for p, rp in [('@executable_path/Frameworks/X', []), ('@loader_path/Frameworks/X', []), ('@rpath/X', ['@executable_path/Frameworks'])]:
            self.assertEqual(c.resolve_path(p, loader, app, rp), [app + '/Frameworks/X'])
        self.assertEqual(c.resolve_path('@loader_path/../../outside', loader, app, []), [])
    def test_code_fingerprint_changes(self):
        d = bytearray(fixture()); d[1024] = 5
        self.assertNotEqual(c.payload_fingerprints(d), c.payload_fingerprints(fixture()))


class IPAs(unittest.TestCase):
    def check(self, host=None, plugin=None, extra=None):
        with tempfile.TemporaryDirectory() as folder:
            path = ipa(folder, host, plugin, extra)
            with mock.patch.object(c, 'ROOT', Path(folder)), mock.patch.object(c, 'SHA256', c.sha(fixture())):
                return c.audit_ipa(path)
    def test_direct_path(self): self.assertEqual(self.check()['structural_preflight'], 'pass')
    def test_rpath(self): self.assertEqual(self.check(host=fixture(host=True, load='@rpath/' + c.NAME, rpath='@executable_path/Frameworks'))['structural_preflight'], 'pass')
    def test_changed_bundle_id_is_not_a_loader_gate(self):
        pl = plistlib.dumps({'CFBundleExecutable': 'Test', 'CFBundleIdentifier': 'example.clone'})
        self.assertEqual(self.check(extra={'Payload/Test.app/Info.plist': pl})['structural_preflight'], 'pass')
    def test_missing_rpath(self):
        with self.assertRaisesRegex(ValueError, 'unresolved'): self.check(host=fixture(host=True, load='@rpath/' + c.NAME))
    def test_missing_load_command(self):
        with self.assertRaisesRegex(ValueError, 'exactly one direct'): self.check(host=fixture(host=True, load='/usr/lib/libSystem.B.dylib'))
    def test_stale_load_path(self):
        with self.assertRaisesRegex(ValueError, 'unresolved'): self.check(host=fixture(host=True, load='@executable_path/FanqieAdBlock-1.5.8.dylib'))
    def test_duplicate_old_plugin(self):
        with self.assertRaisesRegex(ValueError, 'exactly one FanqieX'): self.check(extra={'Payload/Test.app/FanqieAdBlock-1.5.8.dylib': fixture()})
    def test_encrypted_host(self):
        with self.assertRaisesRegex(ValueError, 'unencrypted'): self.check(host=fixture(host=True, encrypted=True))
    def test_changed_plugin_payload(self):
        data = bytearray(fixture()); data[1024] = 7
        with self.assertRaisesRegex(ValueError, 'differs'): self.check(plugin=data)
    def test_weak_load_warns(self): self.assertTrue(self.check(host=fixture(host=True, weak=True))['warnings'])
    def test_zip_traversal(self):
        with self.assertRaisesRegex(ValueError, 'Unsafe ZIP'): self.check(extra={'../evil': b'no'})
    def test_case_collision(self):
        with self.assertRaisesRegex(ValueError, 'case-conflicting'): self.check(extra={'payload/test.app/info.plist': b'no'})


class Packages(unittest.TestCase):
    def test_reproducible_gzip(self):
        self.assertEqual(c.tgz({'x': b'a'}), c.tgz({'x': b'a'}))
        self.assertEqual(c.tgz({'x': b'a'})[4:8], b'\0' * 4)
    def test_reproducible_zip(self):
        value = c.make_zip({'x': b'ab'})
        self.assertEqual(value, c.make_zip({'x': b'ab'}))
        with zipfile.ZipFile(io.BytesIO(value)) as z: self.assertEqual(z.read('x'), b'ab')
    def test_debian_extractor_preserves_binary(self):
        data = fixture()
        self.assertEqual(c.make_deb(data), c.make_deb(data))
        with tempfile.TemporaryDirectory() as folder:
            deb = Path(folder) / 'x.deb'; deb.write_bytes(c.make_deb(data))
            result = subprocess.run(['dpkg-deb', '--fsys-tarfile', str(deb)], check=True, capture_output=True)
            import tarfile
            with tarfile.open(fileobj=io.BytesIO(result.stdout)) as archive:
                members = archive.getmembers(); self.assertEqual(len(members), 1)
                self.assertEqual(archive.extractfile(members[0]).read(), data)
    def test_debian_control_no_install_scripts_or_dependencies(self):
        with tempfile.TemporaryDirectory() as folder:
            deb = Path(folder) / 'x.deb'; deb.write_bytes(c.make_deb(fixture()))
            result = subprocess.run(['dpkg-deb', '--ctrl-tarfile', str(deb)], check=True, capture_output=True)
            import tarfile
            with tarfile.open(fileobj=io.BytesIO(result.stdout)) as archive:
                self.assertEqual(archive.getnames(), ['./control'])
                control = archive.extractfile('./control').read().decode()
                self.assertIn('Version: 1.6.2-1', control); self.assertNotIn('Depends:', control)


if __name__ == '__main__': unittest.main(verbosity=2)
