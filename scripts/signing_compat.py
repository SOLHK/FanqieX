#!/usr/bin/env python3
"""Read-only Mach-O/IPA preflight and reproducible, injection-only DEB packaging.
No certificates, network, DRM removal, executable execution or IPA modification.
A structural pass is NOT proof of a trusted signature or device compatibility.
"""
from __future__ import annotations
import argparse
import gzip
import hashlib
import io
import json
from pathlib import Path, PurePosixPath
import plistlib
import posixpath
import re
import stat
import struct
import sys
import tarfile
import zipfile

VERSION = '1.6.2'
REVISION = '1'
NAME = f'FanqieX-{VERSION}.dylib'
SHA256 = '8784d9d4a065d2bff4dc9f602e503a80bc41c877937d02ebb019e1dbfb0a9a01'
ROOT = Path(__file__).resolve().parents[1]
LOADS = {0xc, 0x80000018, 0x8000001f, 0x80000023, 0x20}
ARM64 = 0x100000c
SYSTEM_LIBRARIES = {'/usr/lib/libSystem.B.dylib', '/usr/lib/libobjc.A.dylib',
                    '/System/Library/Frameworks/Foundation.framework/Foundation',
                    '/System/Library/Frameworks/CoreFoundation.framework/CoreFoundation',
                    '/System/Library/Frameworks/UIKit.framework/UIKit'}
MAX_BINARY = 128 * 1024 * 1024
LIMITS = ['Structural validation only; no Apple certificate trust or device execution test.',
          'Signer version, certificate/profile, host version and iOS rendering require device acceptance.']


def need(ok: bool, message: str) -> None:
    if not ok:
        raise ValueError(message)


def sha(data: bytes) -> str:
    return hashlib.sha256(data).hexdigest()


def cstring(data: bytes, offset: int, end: int) -> str:
    need(0 <= offset < end <= len(data), 'String bounds')
    zero = data.find(b'\0', offset, end)
    need(zero >= 0, 'Unterminated Mach-O string')
    return data[offset:zero].decode('utf-8', errors='strict')


def commands(data: bytes) -> list[tuple[int, int, int]]:
    need(len(data) >= 32, 'Truncated Mach-O header')
    magic, cpu, sub, kind, count, size, flags, reserved = struct.unpack_from('<8I', data)
    need(magic == 0xfeedfacf, 'Expected a little-endian 64-bit Mach-O')
    need(0 < count <= 4096 and 8 * count <= size <= len(data) - 32, 'Load-command header bounds')
    out, offset = [], 32
    for _ in range(count):
        need(offset + 8 <= 32 + size, 'Truncated load command')
        cmd, length = struct.unpack_from('<II', data, offset)
        need(length >= 8 and length % 8 == 0 and offset + length <= 32 + size, 'Load-command bounds/alignment')
        out.append((cmd, offset, length))
        offset += length
    need(offset == 32 + size, 'Load-command size mismatch')
    return out


def images(data: bytes) -> list[bytes]:
    """Accept thin64 or big/little-endian FAT/FAT64; check every slice range."""
    need(len(data) >= 4, 'Empty/truncated binary')
    fat = {b'\xca\xfe\xba\xbe': ('>', False), b'\xbe\xba\xfe\xca': ('<', False),
           b'\xca\xfe\xba\xbf': ('>', True), b'\xbf\xba\xfe\xca': ('<', True)}
    tag = bytes(data[:4])
    if tag not in fat:
        commands(data)
        return [data]
    endian, wide = fat[tag]
    need(len(data) >= 8, 'Truncated FAT header')
    count = struct.unpack_from(endian + 'I', data, 4)[0]
    stride = 32 if wide else 20
    header_end = 8 + count * stride
    need(0 < count <= 32 and header_end <= len(data), 'FAT table bounds')
    out, ranges, identities = [], [], set()
    for i in range(count):
        fields = struct.unpack_from(endian + ('IIQQII' if wide else 'IIIII'), data, 8 + i * stride)
        cpu, subtype, offset, size, align = fields[:5]
        need(align <= 30 and offset % (1 << align) == 0, 'FAT slice alignment')
        need(header_end <= offset and size >= 32 and offset + size <= len(data), 'FAT slice bounds')
        need(all(offset + size <= a or offset >= b for a, b in ranges), 'Overlapping FAT slices')
        need((cpu, subtype) not in identities, 'Duplicate FAT architecture')
        piece = data[offset:offset + size]
        commands(piece)
        need(struct.unpack_from('<II', piece, 4) == (cpu, subtype), 'FAT/header CPU mismatch')
        ranges.append((offset, offset + size)); identities.add((cpu, subtype)); out.append(piece)
    return out


def version(number: int) -> str:
    return f'{number >> 16}.{(number >> 8) & 255}.{number & 255}'


def inspect(data: bytes) -> dict:
    cmds = commands(data)
    cpu, subtype, kind = struct.unpack_from('<III', data, 4)
    result = dict(cpu=cpu, subtype=subtype, kind=kind, dependencies=[], rpaths=[], install_name=None,
                  platform=None, minimum_os=None, sdk=None, encrypted=False, signatures=[],
                  initializers=[], chained_fixups=False, segments=[], uuid=None)
    names = set()
    for cmd, off, length in cmds:
        if cmd in LOADS | {0xd, 0x8000001c}:
            minimum = 12 if cmd == 0x8000001c else 24
            need(length >= minimum, 'Short dylib/rpath command')
            relative = struct.unpack_from('<I', data, off + 8)[0]
            need(minimum <= relative < length, 'Invalid dylib/rpath name offset')
            name = cstring(data, off + relative, off + length)
            if cmd == 0xd:
                need(result['install_name'] is None, 'Duplicate install name')
                result['install_name'] = name
            elif cmd == 0x8000001c:
                result['rpaths'].append(name)
            else:
                result['dependencies'].append({'path': name, 'weak': cmd == 0x80000018})
        elif cmd == 0x32:
            need(length >= 24, 'Short build-version command')
            platform, minimum, sdk, tools = struct.unpack_from('<4I', data, off + 8)
            need(24 + tools * 8 <= length, 'Build-tool bounds')
            need(result['platform'] is None, 'Multiple platform commands')
            result.update(platform=platform, minimum_os=version(minimum), sdk=version(sdk))
        elif cmd == 0x25:
            need(length == 16 and result['platform'] is None, 'Invalid legacy iOS version command')
            minimum, sdk = struct.unpack_from('<II', data, off + 8)
            result.update(platform=2, minimum_os=version(minimum), sdk=version(sdk))
        elif cmd in {0x21, 0x2c}:
            need(length >= (24 if cmd == 0x2c else 20), 'Short encryption command')
            cryptoff, cryptsize, cryptid = struct.unpack_from('<III', data, off + 8)
            need(cryptoff + cryptsize <= len(data), 'Encryption range bounds')
            result['encrypted'] |= cryptid != 0
        elif cmd in {0x1d, 0x26, 0x29, 0x80000033, 0x80000034}:
            need(length == 16, 'Invalid linkedit-data command')
            start, size = struct.unpack_from('<II', data, off + 8)
            need(start + size <= len(data), 'Linkedit range outside file')
            if cmd == 0x1d:
                need(size >= 12, 'Empty signature')
                result['signatures'].append((start, size))
            if cmd == 0x80000034:
                result['chained_fixups'] = size > 0
        elif cmd == 0x1b:
            need(length == 24 and result['uuid'] is None, 'Invalid/duplicate UUID')
            result['uuid'] = data[off + 8:off + 24].hex()
        elif cmd == 0x19:
            need(length >= 72, 'Short segment command')
            name, vmaddr, vmsize, fileoff, filesize, maximum, protection, count, flags = struct.unpack_from('<16s4Q4I', data, off + 8)
            name = name.rstrip(b'\0').decode('ascii')
            need(name not in names, 'Duplicate segment name')
            names.add(name)
            need(72 + count * 80 == length, 'Section table bounds')
            need(fileoff + filesize <= len(data) and filesize <= vmsize, 'Segment bounds')
            result['segments'].append(dict(name=name, offset=fileoff, size=filesize, address=vmaddr))
            for index in range(count):
                s = off + 72 + index * 80
                secname, segname, addr, size, start, align, reloc, nreloc, secflags, r1, r2, r3 = struct.unpack_from('<16s16sQQ8I', data, s)
                section_type = secflags & 255
                if section_type not in {1, 0xc, 0x12}:
                    need(fileoff <= start and start + size <= fileoff + filesize, 'Section file bounds')
                need(vmaddr <= addr and addr + size <= vmaddr + vmsize, 'Section VM bounds')
                if section_type in {9, 0x16} and size:
                    result['initializers'].append(secname.rstrip(b'\0').decode('ascii'))
    return result


def audit_plugin(data: bytes, *, pinned: bool = True) -> dict:
    need(not pinned or sha(data) == SHA256, 'Candidate differs from the frozen 1.6.2 release')
    parts = images(data)
    need(len(parts) == 1, 'Expected one standalone ARM64 release image')
    info = inspect(parts[0])
    need(info['cpu'] == ARM64 and (info['subtype'] & 0xffffff) == 0, 'Expected generic ARM64, not arm64e-only')
    need(info['kind'] == 6 and info['platform'] == 2, 'Expected an iOS dynamic library')
    need(not info['encrypted'], 'Encrypted plugin cannot be packaged')
    need(info['install_name'] == '@rpath/' + NAME, 'Unexpected plugin install name')
    need(len(info['signatures']) == 1, 'Expected one embedded signature')
    need(bool(info['initializers']), 'Missing initializer')
    need(all(d['path'] in SYSTEM_LIBRARIES for d in info['dependencies']),
         'Non-system dependency: supply and validate it instead of silently weakening the link')
    need(not info['rpaths'], 'Unexpected runtime search path in standalone release')
    return dict(product='FanqieX', runtime_version=VERSION, packaging_revision=REVISION,
                sha256=sha(data), size=len(data), structure=info, device_tested=False,
                signer_apps_tested=[], limits=LIMITS)


def payload_fingerprints(data: bytes) -> dict:
    """Include patch code outside ordinary sections; omit headers and __LINKEDIT.
    Codesign may change load-command/signature metadata, never these code bytes.
    """
    info = inspect(data)
    start = 32 + struct.unpack_from('<I', data, 20)[0]
    out = {}
    for segment in info['segments']:
        a, b = segment['offset'], segment['offset'] + segment['size']
        if not segment['size'] or segment['name'] == '__LINKEDIT':
            continue
        if a == 0:
            a = max(a, start)
        out[segment['name']] = sha(data[a:b])
    return out


def resolve_path(path: str, loader: str, app: str, rpaths: list[str]) -> list[str]:
    """Only resolve paths inside this app; no speculative filesystem searches."""
    def expand(text: str) -> str | None:
        for token, base in (('@executable_path/', app), ('@loader_path/', posixpath.dirname(loader))):
            if text.startswith(token):
                value = posixpath.normpath(posixpath.join(base, text[len(token):]))
                return value if value.startswith(app + '/') else None
        return None
    if path.startswith('@rpath/'):
        out = []
        for rp in rpaths:
            value = expand(rp.rstrip('/') + '/' + path[7:])
            if value is not None:
                out.append(value)
        return out
    value = expand(path)
    return [value] if value else []


def is_plugin(path: str) -> bool:
    name = PurePosixPath(path).name.casefold()
    return name.endswith('.dylib') and name.startswith(('fanqiex', 'fanqieadblock'))


def audit_ipa(path: Path) -> dict:
    """Preflight direct load-command injection; no IPA content is ever extracted."""
    with zipfile.ZipFile(path) as archive:
        entries = archive.infolist()
        names = [entry.filename for entry in entries]
        need(len(names) <= 100000, 'Too many ZIP members')
        need(len({n.casefold() for n in names}) == len(names), 'Duplicate/case-conflicting ZIP entries')
        for entry in entries:
            n = entry.filename
            need(not n.startswith('/') and '\\' not in n and '..' not in PurePosixPath(n).parts, 'Unsafe ZIP path')
            need(not stat.S_ISLNK(entry.external_attr >> 16), 'Symlinks are not supported by this preflight')
            need(not entry.flag_bits & 1, 'Encrypted ZIP is not supported')
        def read(name: str, maximum: int = MAX_BINARY) -> bytes:
            need(archive.getinfo(name).file_size <= maximum, 'ZIP member exceeds read limit')
            with archive.open(name) as stream:
                data = stream.read(maximum + 1)
            need(len(data) <= maximum, 'ZIP expansion limit')
            return data
        plists = [n for n in names if re.fullmatch(r'Payload/[^/]+\.app/Info\.plist', n)]
        need(len(plists) == 1, 'Expected exactly one main app')
        app = str(PurePosixPath(plists[0]).parent)
        plist = plistlib.loads(read(plists[0], 4 * 1024 * 1024))
        executable = plist.get('CFBundleExecutable')
        need(isinstance(executable, str) and bool(executable) and '/' not in executable and '\\' not in executable
             and executable not in {'.', '..'}, 'Invalid CFBundleExecutable')
        hostpath = app + '/' + executable
        host = [inspect(p) for p in images(read(hostpath))]
        hosts = [h for h in host if h['cpu'] == ARM64]
        need(bool(hosts), 'No ARM64 host image')
        need(all(h['kind'] == 2 and not h['encrypted'] and h['platform'] == 2 for h in hosts),
             'Host must be a legally obtained, unencrypted iOS executable')
        plugins = [n for n in names if n.startswith(app + '/') and is_plugin(n)]
        need(len(plugins) == 1, 'Require exactly one FanqieX dylib; remove old/duplicate FanqieAdBlock or FanqieX copies')
        plugin = plugins[0]
        pdata = read(plugin)
        pinfo = inspect(pdata)
        need(pinfo['cpu'] == ARM64 and pinfo['kind'] == 6 and pinfo['platform'] == 2, 'Invalid injected plugin')
        original = ROOT / 'dist' / VERSION / NAME
        need(original.is_file(), 'Frozen original is required to compare a re-signed plugin')
        original_bytes = original.read_bytes()
        audit_plugin(original_bytes)
        need(payload_fingerprints(pdata) == payload_fingerprints(original_bytes), 'Injected plugin code differs from the frozen release')
        warnings = []
        for h in hosts:
            matches = []
            for dep in h['dependencies']:
                targets = resolve_path(dep['path'], hostpath, app, h['rpaths'])
                if is_plugin(dep['path']):
                    need(plugin in targets, 'Stale/unresolved FanqieX load path: ' + dep['path'])
                if plugin in targets:
                    matches.append(dep)
                    if dep['weak']:
                        warnings.append('Plugin is weak-linked; a loading failure can silently disable it.')
            need(len(matches) == 1, 'Each ARM64 host slice needs exactly one direct load command resolving to FanqieX')
            need(bool(h['signatures']), 'Host has not been signed')
        need(bool(pinfo['signatures']), 'Injected plugin has not been signed')
        need(all(d['path'] in SYSTEM_LIBRARIES for d in pinfo['dependencies']),
             'Injected plugin has a new non-system dependency')
        return dict(structural_preflight='pass', device_tested=False, certificate_trust_verified=False,
                    plugin=PurePosixPath(plugin).name, warnings=warnings, limits=LIMITS)


def tgz(files: dict[str, bytes], executable: set[str] | None = None) -> bytes:
    tar = io.BytesIO()
    with tarfile.open(fileobj=tar, mode='w', format=tarfile.USTAR_FORMAT) as archive:
        for name, data in sorted(files.items()):
            item = tarfile.TarInfo(name); item.size = len(data); item.mtime = 0
            item.mode = 0o755 if name in (executable or set()) else 0o644
            item.uid = item.gid = 0; item.uname = item.gname = 'root'
            archive.addfile(item, io.BytesIO(data))
    compressed = io.BytesIO()
    with gzip.GzipFile(fileobj=compressed, mode='wb', filename='', mtime=0) as stream:
        stream.write(tar.getvalue())
    return compressed.getvalue()


def make_deb(data: bytes) -> bytes:
    control = (f'Package: com.solhk.fanqiex\nName: FanqieX\nVersion: {VERSION}-{REVISION}\n'
               'Architecture: iphoneos-arm\nMaintainer: FanqieX\nSection: Tweaks\nPriority: optional\n'
               'Description: Injection-only carrier of the unchanged FanqieX dylib.\n'
               ' Not a jailbreak installer. Re-sign the library together with the host app.\n').encode()
    member = './Library/MobileSubstrate/DynamicLibraries/' + NAME
    parts = [('debian-binary', b'2.0\n'), ('control.tar.gz', tgz({'./control': control})),
             ('data.tar.gz', tgz({member: data}, {member}))]
    out = bytearray(b'!<arch>\n')
    for name, body in parts:
        header = f'{name + "/":<16}{0:<12}{0:<6}{0:<6}{"100644":<8}{len(body):<10}`\n'.encode('ascii')
        need(len(header) == 60, 'AR header size')
        out.extend(header); out.extend(body)
        if len(body) % 2:
            out.extend(b'\n')
    return bytes(out)


def make_zip(files: dict[str, bytes]) -> bytes:
    out = io.BytesIO()
    with zipfile.ZipFile(out, 'w', compression=zipfile.ZIP_DEFLATED, compresslevel=9) as archive:
        for name, data in sorted(files.items()):
            info = zipfile.ZipInfo(name, (1980, 1, 1, 0, 0, 0))
            info.compress_type = zipfile.ZIP_DEFLATED; info.create_system = 3
            info.external_attr = 0o100644 << 16
            archive.writestr(info, data)
    return out.getvalue()


def package(source: Path, output: Path) -> dict:
    data = source.read_bytes()
    report = audit_plugin(data)
    # Validate all actual ad-hoc page hashes, not just the Mach-O signature flag.
    sys.path.insert(0, str(ROOT / 'repair162'))
    from macho_tools import verify_signature
    signature = verify_signature(data)
    need(signature['page_hashes_valid'], 'Original code signature page hashes fail')
    report['original_ad_hoc_page_hashes_valid'] = True
    docs = (ROOT / 'docs' / 'SIGNING_COMPATIBILITY.md').read_bytes()
    debname = f'FanqieX-{VERSION}-{REVISION}.deb'
    files = {NAME: data, debname: make_deb(data), 'SIGNING_COMPATIBILITY.md': docs,
             'compatibility.json': (json.dumps(report, ensure_ascii=False, indent=2) + '\n').encode()}
    files['SHA256SUMS.txt'] = ''.join(f'{sha(b)}  {n}\n' for n, b in sorted(files.items())).encode()
    bundle = f'FanqieX-{VERSION}-signing-r{REVISION}.zip'
    files[bundle] = make_zip(files)
    need(all((output / name).resolve() != source.resolve() for name in files), 'Refuse to overwrite source plugin')
    output.mkdir(parents=True, exist_ok=True)
    for name, body in files.items():
        target = output / name
        need(not target.is_symlink(), 'Refuse symlink output')
        target.write_bytes(body)
    # An external checksum also covers the ZIP (the inner checksum cannot cover itself).
    (output / 'BUNDLE_SHA256SUMS.txt').write_text(f'{sha(files[bundle])}  {bundle}\n', encoding='utf-8')
    return report


def main() -> int:
    parser = argparse.ArgumentParser(description=__doc__)
    sub = parser.add_subparsers(dest='command', required=True)
    audit = sub.add_parser('audit'); audit.add_argument('dylib', type=Path)
    ipa = sub.add_parser('ipa'); ipa.add_argument('ipa', type=Path)
    pack = sub.add_parser('package'); pack.add_argument('dylib', type=Path)
    pack.add_argument('--output', type=Path, required=True)
    compare = sub.add_parser('compare-resigned'); compare.add_argument('original', type=Path)
    compare.add_argument('resigned', type=Path)
    args = parser.parse_args()
    try:
        if args.command == 'audit':
            result = audit_plugin(args.dylib.read_bytes())
        elif args.command == 'ipa':
            result = audit_ipa(args.ipa)
        elif args.command == 'package':
            result = package(args.dylib, args.output)
        else:
            before, after = args.original.read_bytes(), args.resigned.read_bytes()
            audit_plugin(before)
            need(payload_fingerprints(before) == payload_fingerprints(after), 'Re-sign changed executable/data payload')
            a, b = inspect(before), inspect(after)
            for key in ('dependencies', 'install_name', 'initializers', 'chained_fixups', 'uuid', 'platform', 'minimum_os'):
                need(a[key] == b[key], 'Re-sign changed ' + key)
            need(len(b['signatures']) == 1, 'Re-signed image is unsigned')
            result = dict(resign_payload_comparison='pass', device_tested=False, limits=LIMITS)
        print(json.dumps(result, ensure_ascii=False, indent=2))
        return 0
    except (ValueError, OSError, KeyError, struct.error, zipfile.BadZipFile, plistlib.InvalidFileException) as exc:
        print(json.dumps({'status': 'fail', 'error': str(exc)}, ensure_ascii=False), file=sys.stderr)
        return 1


if __name__ == '__main__':
    raise SystemExit(main())
