#!/usr/bin/env python3
"""Inspect a local reverse-engineering ZIP without extracting or executing it.

Reports evidence, not inferred host compatibility. Header declarations and text
matches are NOT proof of a runtime method ABI or an advertisement insertion chain.
No network requests, source uploads, binary patching, or repository writes occur.
"""
from __future__ import annotations

import argparse
from collections import Counter
from dataclasses import dataclass
import hashlib
import json
from pathlib import Path, PurePosixPath
import plistlib
import re
import stat
import struct
import unicodedata
import uuid
import zipfile


class InspectionError(ValueError):
    pass


@dataclass(frozen=True)
class Limits:
    members: int = 100000
    total_bytes: int = 16 * 1024**3
    member_bytes: int = 4 * 1024**3
    compression_ratio: int = 2000
    text_bytes: int = 2 * 1024**2
    total_text_bytes: int = 128 * 1024**2
    load_commands_bytes: int = 16 * 1024**2


THIN = {
    b'\xcf\xfa\xed\xfe': ('<', True), b'\xfe\xed\xfa\xcf': ('>', True),
    b'\xce\xfa\xed\xfe': ('<', False), b'\xfe\xed\xfa\xce': ('>', False),
}
FAT = {
    b'\xca\xfe\xba\xbe': ('>', False), b'\xbe\xba\xfe\xca': ('<', False),
    b'\xca\xfe\xba\xbf': ('>', True), b'\xbf\xba\xfe\xca': ('<', True),
}
DYLIB = {0xc: 'load', 0xd: 'id', 0x80000018: 'weak',
         0x8000001f: 'reexport', 0x80000023: 'upward', 0x20: 'lazy'}
TEXT_SUFFIXES = {'.h', '.m', '.mm', '.c', '.cpp', '.txt', '.json', '.asm', '.s', '.dump'}


def read_at(stream, offset: int, size: int, bound: int) -> bytes:
    if offset < 0 or size < 0 or offset + size > bound:
        raise InspectionError('Read extends beyond the declared binary')
    stream.seek(offset)
    data = stream.read(size)
    if len(data) != size:
        raise InspectionError('Truncated binary')
    return data


def macho_metadata(stream, size: int, limits: Limits = Limits()) -> dict:
    def thin(base: int, length: int) -> dict:
        magic = read_at(stream, base, 4, size)
        if magic not in THIN:
            raise InspectionError('Fat slice does not contain a supported Mach-O header')
        endian, is64 = THIN[magic]
        header_size = 32 if is64 else 28
        if length < header_size:
            raise InspectionError('Truncated Mach-O header')
        header = read_at(stream, base, header_size, size)
        cpu, subtype, filetype, count, command_bytes, flags = struct.unpack_from(endian + '6I', header, 4)
        if count > 100000 or command_bytes > limits.load_commands_bytes:
            raise InspectionError('Mach-O load-command budget exceeded')
        if header_size + command_bytes > length:
            raise InspectionError('Mach-O load commands exceed their slice')
        commands = read_at(stream, base + header_size, command_bytes, size)
        result = {'cpu_type': cpu, 'cpu_subtype': subtype,
                  'architecture': ('arm64e' if subtype & 0xffffff == 2 else 'arm64') if cpu == 0x100000c else
                                  ('arm' if cpu == 12 else 'x86_64' if cpu == 0x1000007 else 'other'),
                  'bits': 64 if is64 else 32, 'file_type': filetype, 'flags': flags,
                  'uuid': None, 'dependencies': [], 'install_name': None,
                  'encryption': [], 'runtime_abi_verified': False}
        cursor = 0
        for _ in range(count):
            if cursor + 8 > len(commands):
                raise InspectionError('Truncated load-command header')
            command, command_size = struct.unpack_from(endian + 'II', commands, cursor)
            if command_size < 8 or command_size % 4 or cursor + command_size > len(commands):
                raise InspectionError('Invalid load-command size')
            value = commands[cursor:cursor + command_size]
            if command == 0x1b:
                if command_size != 24 or result['uuid'] is not None:
                    raise InspectionError('Invalid or duplicate LC_UUID')
                result['uuid'] = str(uuid.UUID(bytes=value[8:24]))
            elif command in DYLIB:
                if command_size < 24:
                    raise InspectionError('Truncated dylib command')
                name_offset = struct.unpack_from(endian + 'I', value, 8)[0]
                if name_offset < 24 or name_offset >= command_size or b'\0' not in value[name_offset:]:
                    raise InspectionError('Invalid dylib name offset or terminator')
                name = value[name_offset:].split(b'\0', 1)[0].decode('utf-8', errors='replace')
                if command == 0xd:
                    result['install_name'] = name
                else:
                    result['dependencies'].append({'kind': DYLIB[command], 'name': name})
            elif command in (0x21, 0x2c):
                if command_size < (24 if command == 0x2c else 20):
                    raise InspectionError('Truncated encryption command')
                offset, encrypted_size, cryptid = struct.unpack_from(endian + 'III', value, 8)
                if offset + encrypted_size > length:
                    raise InspectionError('Encryption range exceeds its Mach-O slice')
                result['encryption'].append({'offset': offset, 'size': encrypted_size, 'cryptid': cryptid})
            cursor += command_size
        if cursor != command_bytes:
            raise InspectionError('Load-command count and byte size disagree')
        return result

    magic = read_at(stream, 0, 4, size)
    if magic in THIN:
        return {'container': 'thin', 'slices': [thin(0, size)]}
    if magic not in FAT:
        raise InspectionError('Not a supported Mach-O file')
    endian, fat64 = FAT[magic]
    count = struct.unpack(endian + 'I', read_at(stream, 4, 4, size))[0]
    if not 1 <= count <= 32:
        raise InspectionError('Invalid fat architecture count')
    row_size = 32 if fat64 else 20
    table_end = 8 + count * row_size
    table = read_at(stream, 8, count * row_size, size)
    slices = []
    for index in range(count):
        row = struct.unpack_from(endian + ('IIQQII' if fat64 else 'IIIII'), table, index * row_size)
        cpu, subtype, offset, length, alignment = row[:5]
        if alignment > 31 or offset % (1 << alignment) or offset < table_end or length < 28 or offset + length > size:
            raise InspectionError('Invalid fat slice range or alignment')
        slices.append((offset, length, cpu, subtype))
    slices.sort()
    for previous, following in zip(slices, slices[1:]):
        if previous[0] + previous[1] > following[0]:
            raise InspectionError('Overlapping fat slices')
    result = []
    for offset, length, cpu, subtype in slices:
        value = thin(offset, length)
        if value['cpu_type'] != cpu or value['cpu_subtype'] != subtype:
            raise InspectionError('Fat architecture table and slice header disagree')
        result.append(value)
    return {'container': 'fat64' if fat64 else 'fat', 'slices': result}


def validate_members(infos, limits: Limits) -> None:
    if len(infos) > limits.members:
        raise InspectionError('ZIP entry-count limit exceeded')
    seen = set()
    total = 0
    for info in infos:
        name = info.orig_filename
        parts = name.rstrip('/').split('/')
        if not name or name.startswith('/') or '\\' in name or '\0' in name or re.match(r'^[A-Za-z]:', name) or any(p in ('', '.', '..') for p in parts):
            raise InspectionError('Unsafe ZIP member path')
        if len(name.encode('utf-8')) > 4096:
            raise InspectionError('ZIP member path is too long')
        canonical = unicodedata.normalize('NFC', name.rstrip('/')).casefold()
        if canonical in seen:
            raise InspectionError('Duplicate or ambiguous ZIP member path')
        seen.add(canonical)
        kind = stat.S_IFMT(info.external_attr >> 16)
        if kind not in (0, stat.S_IFREG, stat.S_IFDIR):
            raise InspectionError('ZIP links and special files are not allowed')
        if info.flag_bits & 1:
            raise InspectionError('Encrypted ZIP member requires separate handling')
        total += info.file_size
        if info.file_size > limits.member_bytes or total > limits.total_bytes:
            raise InspectionError('ZIP uncompressed-size limit exceeded')
        if info.file_size and info.file_size > max(1, info.compress_size) * limits.compression_ratio:
            raise InspectionError('ZIP compression-ratio limit exceeded')


def inspect_archive(path: Path, limits: Limits = Limits(), verify_crc: bool = True) -> dict:
    path = Path(path)
    checksum = hashlib.sha256()
    with path.open('rb') as source:
        for chunk in iter(lambda: source.read(1024**2), b''):
            checksum.update(chunk)
    result = {'schema': 1, 'archive_sha256': checksum.hexdigest(), 'archive_bytes': path.stat().st_size,
              'inventory': [], 'plists': [], 'mach_o': [], 'header_files': [],
              'text_evidence': [], 'text_scan_truncated': False, 'host_identity': None,
              'runtime_abi_verified': False, 'target_ad_insertion_chain_verified': False,
              'limitations': ['Text matches are candidate evidence, not verified runtime ABI or ad ownership.',
                              'No archive member is extracted, loaded, patched, or executed.']}
    remaining = limits.total_text_bytes
    with zipfile.ZipFile(path) as archive:
        infos = archive.infolist()
        validate_members(infos, limits)
        result['entry_count'] = len(infos)
        result['declared_uncompressed_bytes'] = sum(i.file_size for i in infos)
        result['extensions'] = dict(sorted(Counter(PurePosixPath(i.filename).suffix.lower() or '<none>' for i in infos if not i.is_dir()).items()))
        for info in infos:
            result['inventory'].append({'path': info.filename, 'size': info.file_size,
                                        'compressed_size': info.compress_size, 'crc32': f'{info.CRC:08x}'})
            if info.is_dir():
                continue
            if verify_crc:
                with archive.open(info) as source:
                    for _ in iter(lambda: source.read(1024**2), b''):
                        pass
            with archive.open(info) as source:
                magic = source.read(4)
            if magic in THIN or magic in FAT:
                with archive.open(info) as source:
                    metadata = macho_metadata(source, info.file_size, limits)
                result['mach_o'].append({'path': info.filename, **metadata})
                continue
            member_path = PurePosixPath(info.filename)
            if member_path.name == 'Info.plist':
                if info.file_size > limits.text_bytes:
                    raise InspectionError('Info.plist exceeds its inspection budget')
                try:
                    value = plistlib.loads(archive.read(info))
                except Exception as error:
                    raise InspectionError(f'Invalid Info.plist: {info.filename}') from error
                if not isinstance(value, dict):
                    raise InspectionError('Info.plist must be a dictionary')
                keys = ('CFBundleIdentifier', 'CFBundleVersion', 'CFBundleShortVersionString', 'CFBundleExecutable', 'CFBundlePackageType')
                metadata = {key: value.get(key) if isinstance(value.get(key), str) else None for key in keys}
                result['plists'].append({'path': info.filename, **metadata})
            suffix = member_path.suffix.lower()
            if suffix == '.h':
                result['header_files'].append(info.filename)
            if suffix not in TEXT_SUFFIXES:
                continue
            amount = min(info.file_size, limits.text_bytes, remaining)
            if amount < info.file_size:
                result['text_scan_truncated'] = True
            if amount <= 0:
                continue
            with archive.open(info) as source:
                raw = source.read(amount)
            remaining -= len(raw)
            text = raw.decode('utf-8', errors='replace')
            matches = []
            patterns = {
                'class_inheritance_declaration': r'@interface\s+\w+\s*:\s*\w+',
                'property_declaration': r'@property\b',
                'method_declaration': r'(?m)^\s*[-+]\s*\([^\n)]+\)',
                'class_dump_marker': r'(?i)class[- ]dump',
                'arm64_disassembly_candidate': r'(?im)^\s*(?:0x)?[0-9a-f]{8,16}[:\s]+(?:[0-9a-f]{2,8}\s+)*(?:adrp|stp|ldp|bl|ret)\b',
                'ad_component_candidate': r'(?i)SSBizAd|advertisement|羊了个羊|羊了個羊',
            }
            for label, pattern in patterns.items():
                match = re.search(pattern, text)
                if match:
                    matches.append({'kind': label, 'line': text.count('\n', 0, match.start()) + 1})
            if matches:
                result['text_evidence'].append({'path': info.filename, 'bytes_scanned': len(raw), 'complete_file': len(raw) == info.file_size, 'matches': matches})
        result['whole_archive_crc_verified'] = verify_crc
    candidates = [item for item in result['plists'] if item['CFBundlePackageType'] == 'APPL']
    result['main_app_plist_candidates'] = [item['path'] for item in candidates]
    if len(candidates) == 1:
        result['host_identity'] = candidates[0]
    elif len(candidates) > 1:
        result['limitations'].append('Multiple application plists; the host identity is ambiguous.')
    else:
        result['limitations'].append('No unambiguous APPL plist; host identity is not assumed from the filename.')
    result['raw_macho_present'] = bool(result['mach_o'])
    result['header_files_present'] = bool(result['header_files'])
    return result


def main() -> None:
    parser = argparse.ArgumentParser(description=__doc__)
    parser.add_argument('archive', type=Path)
    parser.add_argument('--output', type=Path, required=True)
    parser.add_argument('--skip-crc', action='store_true', help='Inventory only; explicitly mark full ZIP integrity as unverified')
    args = parser.parse_args()
    if args.archive.resolve() == args.output.resolve():
        parser.error('The report must not overwrite its input archive')
    try:
        result = inspect_archive(args.archive, verify_crc=not args.skip_crc)
    except (InspectionError, OSError, zipfile.BadZipFile, NotImplementedError, RuntimeError) as error:
        parser.exit(2, f'Inspection failed: {error}\n')
    args.output.parent.mkdir(parents=True, exist_ok=True)
    args.output.write_text(json.dumps(result, ensure_ascii=False, indent=2) + '\n', encoding='utf-8')
    print(json.dumps({key: result[key] for key in ('archive_sha256', 'entry_count', 'whole_archive_crc_verified', 'host_identity', 'raw_macho_present', 'text_scan_truncated', 'runtime_abi_verified', 'target_ad_insertion_chain_verified')}, ensure_ascii=False, indent=2))


if __name__ == '__main__':
    main()
