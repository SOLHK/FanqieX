#!/usr/bin/env python3
"""Build the actual ARM64 repair with the release's Xcode and validate public UIKit APIs.

This assembles the shipped plugin repair, not just a sample application. The
original pinned host-dependent image is preserved by the existing Mach-O
builder. A successful build is not an iPhone injection or rendering test.
"""
from __future__ import annotations

import argparse
import hashlib
import importlib
import json
import os
from pathlib import Path
import platform
import re
import struct
import subprocess
import sys
import tempfile

ROOT = Path(__file__).resolve().parents[1]


def apple_toolchain_versions(release):
    if release in ('1.78R15', '1.78R16', '1.78R19', '1.78R20', '1.78R21', '1.78R22', '1.78R23', '1.78R24', '1.78R25', "1.78R26", "1.78R27", "1.78R28", "1.78R29", "1.78R30", "1.78R31", "1.78R32", "1.78R33", "1.78R34", "1.78R35", "1.78R36", "1.79R1", "1.79R2", "1.79R3", "1.79R4", "1.79R5", "1.8R1", "1.8R2", "1.8R3", "1.8R4", "1.8R5", "1.8R6", "1.8R7", "1.8R8", "1.8R9", "1.8R10", "1.8R11", "1.8R12", "1.8R13", "1.8R14", "1.8R15", "1.8R16", "1.8R17", "1.8R18", "1.8R19", "1.9.1beta1", "1.9.1beta2", "1.9.1beta3", "1.9.1beta4", "1.9.1beta5", "1.9.1beta6", "1.9.1beta7", "1.9.1beta8", "1.9.1beta9", "1.9.1beta10", "1.9.1beta11", "1.9.1beta12", "1.9.1beta13", "1.9.1beta14", "1.9.1beta15", "1.9.1beta16", "1.9.1beta17", "1.9.1beta18", "1.9.1beta19", "1.9.1beta20", "1.9.1beta21", "1.9.1beta22", "1.9.1beta23", "1.9.1beta24", "1.9.1beta25", "1.9.1beta26", "1.9.5beta1", "1.9.5beta2", "1.9.5beta3", "1.9.5beta4", "1.9.5beta5", "1.9.5beta6", "1.9.5beta7", "1.9.5beta8", "1.9.5beta9", "1.9.6beta1", "1.9.6beta2", "1.9.6beta3", "1.9.6beta4", "1.9.6beta5", "1.9.6beta6", "1.9.6beta7", "1.9.6beta8", "1.9.6beta9", "1.9.7beta1", "1.9.7beta2", "1.9.7beta3", "1.9.7beta4", "1.9.7beta5", "1.9.7beta6"):
        return ('27.3', '27.2')
    if release in ('1.78R11', '1.78R12', '1.78R13', '1.78R14'):
        return ('27.3',)
    return ('27.2',)


def matches_apple_toolchain(xcode, sdk, release):
    first_line = xcode.split('\n', 1)[0]
    patch = r'(?:\.\d+)?' if release in ('1.78R15', '1.78R16', '1.78R19', '1.78R20', '1.78R21', '1.78R22', '1.78R23', '1.78R24', '1.78R25', "1.78R26", "1.78R27", "1.78R28", "1.78R29", "1.78R30", "1.78R31", "1.78R32", "1.78R33", "1.78R34", "1.78R35", "1.78R36", "1.79R1", "1.79R2", "1.79R3", "1.79R4", "1.79R5", "1.8R1", "1.8R2", "1.8R3", "1.8R4", "1.8R5", "1.8R6", "1.8R7", "1.8R8", "1.8R9", "1.8R10", "1.8R11", "1.8R12", "1.8R13", "1.8R14", "1.8R15", "1.8R16", "1.8R17", "1.8R18", "1.8R19", "1.9.1beta1", "1.9.1beta2", "1.9.1beta3", "1.9.1beta4", "1.9.1beta5", "1.9.1beta6", "1.9.1beta7", "1.9.1beta8", "1.9.1beta9", "1.9.1beta10", "1.9.1beta11", "1.9.1beta12", "1.9.1beta13", "1.9.1beta14", "1.9.1beta15", "1.9.1beta16", "1.9.1beta17", "1.9.1beta18", "1.9.1beta19", "1.9.1beta20", "1.9.1beta21", "1.9.1beta22", "1.9.1beta23", "1.9.1beta24", "1.9.1beta25", "1.9.1beta26", "1.9.5beta1", "1.9.5beta2", "1.9.5beta3", "1.9.5beta4", "1.9.5beta5", "1.9.5beta6", "1.9.5beta7", "1.9.5beta8", "1.9.5beta9", "1.9.6beta1", "1.9.6beta2", "1.9.6beta3", "1.9.6beta4", "1.9.6beta5", "1.9.6beta6", "1.9.6beta7", "1.9.6beta8", "1.9.6beta9", "1.9.7beta1", "1.9.7beta2", "1.9.7beta3", "1.9.7beta4", "1.9.7beta5", "1.9.7beta6") else ''
    return any(
        re.fullmatch(rf'Xcode {re.escape(version)}{patch}(?: beta)?', first_line)
        and re.fullmatch(rf'{re.escape(version)}(?:\.\d+)?', sdk)
        for version in apple_toolchain_versions(release)
    )


def command(*arguments):
    return subprocess.run(arguments, check=True, capture_output=True,
                          text=True).stdout.strip()


def assemble(assembly, triple='arm64-apple-ios15.0.1'):
    with tempfile.TemporaryDirectory(prefix='fanqiex-xcode-') as folder:
        source = Path(folder) / 'patch.s'
        output = Path(folder) / 'patch.o'
        source.write_text(assembly)
        subprocess.run(['xcrun', '--sdk', 'iphoneos', 'clang', '-target', triple,
                        '-x', 'assembler', '-c', str(source), '-o', str(output)],
                       check=True)
        return output.read_bytes()


def disassemble(data, address=0):
    source = '.text\n.p2align 2\n' + '\n'.join(
        '.long 0x%08x' % struct.unpack_from('<I', data, offset)[0]
        for offset in range(0, len(data), 4)) + '\n'
    with tempfile.TemporaryDirectory(prefix='fanqiex-otool-') as folder:
        obj = Path(folder) / 'code.o'
        obj.write_bytes(assemble(source))
        return ['Apple otool listing; image base %#x' % address,
                *command('xcrun', 'otool', '-tv', str(obj)).splitlines()[1:]]


def main():
    parser = argparse.ArgumentParser(description=__doc__)
    parser.add_argument('--repair-dir', choices=('repair159', 'repair160', 'repair161', 'repair162'),
                        default='repair162')
    parser.add_argument('--version', choices=('1.6.2', '1.6.3', '1.6.4', '1.6.5', '1.6.6', '1.6.7', '1.7.1', '1.7.2', '1.7.3', '1.7.4', '1.74', '1.75', '1.76', '1.78', '1.78R2', '1.78R3', '1.78R4', '1.78R5', '1.78R6', '1.78R7', '1.78R8', '1.78R9', '1.78R10', '1.78R11', '1.78R12', '1.78R13', '1.78R14', '1.78R15', '1.78R16', '1.78R19', '1.78R20', '1.78R21', '1.78R22', '1.78R23', '1.78R24', '1.78R25', "1.78R26", "1.78R27", "1.78R28", "1.78R29", "1.78R30", "1.78R31", "1.78R32", "1.78R33", "1.78R34", "1.78R35", "1.78R36", "1.79R1", "1.79R2", "1.79R3", "1.79R4", "1.79R5", "1.8R1", "1.8R2", "1.8R3", "1.8R4", "1.8R5", "1.8R6", "1.8R7", "1.8R8", "1.8R9", "1.8R10", "1.8R11", "1.8R12", "1.8R18", "1.8R19", "1.9.1beta1", "1.9.1beta2", "1.9.1beta3", "1.9.1beta4", "1.9.1beta5", "1.9.1beta6", "1.9.1beta7", "1.9.1beta8", "1.9.1beta9", "1.9.1beta10", "1.9.1beta11", "1.9.1beta12", "1.9.1beta13", "1.9.1beta14", "1.9.1beta15", "1.9.1beta16", "1.9.1beta17", "1.9.1beta18", "1.9.1beta19", "1.9.1beta20", "1.9.1beta21", "1.9.1beta22", "1.9.1beta23", "1.9.1beta24", "1.9.1beta25", "1.9.1beta26", "1.9.5beta1", "1.9.5beta2", "1.9.5beta3", "1.9.5beta4", "1.9.5beta5", "1.9.5beta6", "1.9.5beta7", "1.9.5beta8", "1.9.5beta9", "1.9.6beta1", "1.9.6beta2", "1.9.6beta3", "1.9.6beta4", "1.9.6beta5", "1.9.6beta6", "1.9.6beta7", "1.9.6beta8", "1.9.6beta9", "1.9.7beta1", "1.9.7beta2", "1.9.7beta3", "1.9.7beta4", "1.9.7beta5", "1.9.7beta6"),
                        help='Choose a release profile for repair162')
    parser.add_argument('--output', type=Path, default=ROOT / 'build' / 'xcode27')
    parser.add_argument('--expect-candidate', type=Path)
    args = parser.parse_args()
    output = args.output.resolve()
    output.mkdir(parents=True, exist_ok=True)
    report = {'passed': False, 'device_tested': False,
              'native_host_app_tested': False, 'platform': platform.platform(),
              'repair_dir': args.repair_dir,
              'assembly_target': 'arm64-apple-ios15.0.1',
              'github_sha': os.environ.get('GITHUB_SHA'),
              'github_run_id': os.environ.get('GITHUB_RUN_ID'),
              'scope': 'Xcode assembly of the actual plugin and SDK type checking'}
    try:
        if platform.system() != 'Darwin':
            raise RuntimeError('Xcode build requires macOS; refusing a Linux substitution')
        report['xcode'] = command('xcodebuild', '-version')
        report['developer_dir'] = command('xcode-select', '-p')
        report['sdk_version'] = command('xcrun', '--sdk', 'iphoneos', '--show-sdk-version')
        report['sdk_build'] = command('xcrun', '--sdk', 'iphoneos', '--show-sdk-build-version')
        report['clang'] = command('xcrun', '--sdk', 'iphoneos', 'clang', '--version')
        if not matches_apple_toolchain(report['xcode'], report['sdk_version'], args.version):
            supported = ' or '.join(apple_toolchain_versions(args.version))
            raise RuntimeError(f'This release requires matching Xcode and iOS SDK {supported}')
        sdk_target = f"arm64-apple-ios{report['sdk_version']}"
        report['sdk_typecheck_target'] = sdk_target
        sdk = command('xcrun', '--sdk', 'iphoneos', '--show-sdk-path')
        subprocess.run(['xcrun', '--sdk', 'iphoneos', 'clang', '-target',
                        sdk_target, '-isysroot', sdk, '-fobjc-arc',
                        '-fmodules', '-Wall', '-Wextra', '-Werror', '-fsyntax-only',
                        str(ROOT / 'native' / 'PublicGlassAPI.m')], check=True)
        report['public_glass_api_typecheck'] = True
        if args.version in ('1.6.4', '1.6.5', '1.6.6', '1.6.7', '1.7.1', '1.7.2', '1.7.3', '1.7.4', '1.74', '1.75', '1.76', '1.78', '1.78R2', '1.78R3', '1.78R4', '1.78R5', '1.78R6', '1.78R7', '1.78R8', '1.78R9', '1.78R10', '1.78R11', '1.78R12', '1.78R13', '1.78R14', '1.78R15', '1.78R16', '1.78R19', '1.78R20', '1.78R21', '1.78R22', '1.78R23', '1.78R24', '1.78R25', "1.78R26", "1.78R27", "1.78R28", "1.78R29", "1.78R30", "1.78R31", "1.78R32", "1.78R33", "1.78R34", "1.78R35", "1.78R36", "1.79R1", "1.79R2", "1.79R3", "1.79R4", "1.79R5", "1.8R1", "1.8R2", "1.8R3", "1.8R4", "1.8R5", "1.8R6", "1.8R7", "1.8R8", "1.8R9", "1.8R10", "1.8R11", "1.8R12", "1.8R13", "1.8R14", "1.8R15", "1.8R16", "1.8R17", "1.8R18", "1.8R19", "1.9.1beta1", "1.9.1beta2", "1.9.1beta3", "1.9.1beta4", "1.9.1beta5", "1.9.1beta6", "1.9.1beta7", "1.9.1beta8", "1.9.1beta9", "1.9.1beta10", "1.9.1beta11", "1.9.1beta12", "1.9.1beta13", "1.9.1beta14", "1.9.1beta15", "1.9.1beta16", "1.9.1beta17", "1.9.1beta18", "1.9.1beta19", "1.9.1beta20", "1.9.1beta21", "1.9.1beta22", "1.9.1beta23", "1.9.1beta24", "1.9.1beta25", "1.9.1beta26", "1.9.5beta1", "1.9.5beta2", "1.9.5beta3", "1.9.5beta4", "1.9.5beta5", "1.9.5beta6", "1.9.5beta7", "1.9.5beta8", "1.9.5beta9", "1.9.6beta1", "1.9.6beta2", "1.9.6beta3", "1.9.6beta4", "1.9.6beta5", "1.9.6beta6", "1.9.6beta7", "1.9.6beta8", "1.9.6beta9", "1.9.7beta1", "1.9.7beta2", "1.9.7beta3", "1.9.7beta4", "1.9.7beta5", "1.9.7beta6"):
            subprocess.run(['xcrun', '--sdk', 'iphoneos', 'clang', '-target',
                            sdk_target, '-isysroot', sdk, '-fno-objc-arc',
                            '-fno-objc-exceptions', '-Wall', '-Wextra', '-Werror', '-fsyntax-only',
                            str(ROOT / 'native' / 'FanqieXDiagnostics.m')], check=True)
            report['diagnostic_source_typecheck'] = True
        if args.version in ('1.6.5', '1.6.6', '1.6.7', '1.7.1', '1.7.2', '1.7.3', '1.7.4', '1.74', '1.75', '1.76', '1.78', '1.78R2', '1.78R3', '1.78R4', '1.78R5', '1.78R6', '1.78R7', '1.78R8', '1.78R9', '1.78R10', '1.78R11', '1.78R12', '1.78R13', '1.78R14', '1.78R15', '1.78R16', '1.78R19', '1.78R20', '1.78R21', '1.78R22', '1.78R23', '1.78R24', '1.78R25', "1.78R26", "1.78R27", "1.78R28", "1.78R29", "1.78R30", "1.78R31", "1.78R32", "1.78R33", "1.78R34", "1.78R35", "1.78R36", "1.79R1", "1.79R2", "1.79R3", "1.79R4", "1.79R5", "1.8R1", "1.8R2", "1.8R3", "1.8R4", "1.8R5", "1.8R6", "1.8R7", "1.8R8", "1.8R9", "1.8R10", "1.8R11", "1.8R12", "1.8R13", "1.8R14", "1.8R15", "1.8R16", "1.8R17", "1.8R18", "1.8R19", "1.9.1beta1", "1.9.1beta2", "1.9.1beta3", "1.9.1beta4", "1.9.1beta5", "1.9.1beta6", "1.9.1beta7", "1.9.1beta8", "1.9.1beta9", "1.9.1beta10", "1.9.1beta11", "1.9.1beta12", "1.9.1beta13", "1.9.1beta14", "1.9.1beta15", "1.9.1beta16", "1.9.1beta17", "1.9.1beta18", "1.9.1beta19", "1.9.1beta20", "1.9.1beta21", "1.9.1beta22", "1.9.1beta23", "1.9.1beta24", "1.9.1beta25", "1.9.1beta26", "1.9.5beta1", "1.9.5beta2", "1.9.5beta3", "1.9.5beta4", "1.9.5beta5", "1.9.5beta6", "1.9.5beta7", "1.9.5beta8", "1.9.5beta9", "1.9.6beta1", "1.9.6beta2", "1.9.6beta3", "1.9.6beta4", "1.9.6beta5", "1.9.6beta6", "1.9.6beta7", "1.9.6beta8", "1.9.6beta9", "1.9.7beta1", "1.9.7beta2", "1.9.7beta3", "1.9.7beta4", "1.9.7beta5", "1.9.7beta6"):
            subprocess.run(['xcrun','--sdk','iphoneos','clang','-target','arm64-apple-ios18.0',
                            '-isysroot',sdk,'-fno-objc-arc','-Wall','-Wextra','-Werror','-fsyntax-only',
                            str(ROOT/'native'/('AlignedGlass.m' if args.version in ('1.7.1','1.7.2', '1.7.3', '1.7.4', '1.74', '1.75', '1.76', '1.78', '1.78R2', '1.78R3', '1.78R4', '1.78R5', '1.78R6', '1.78R7', '1.78R8', '1.78R9', '1.78R10', '1.78R11', '1.78R12', '1.78R13', '1.78R14', '1.78R15', '1.78R16', '1.78R19', '1.78R20', '1.78R21', '1.78R22', '1.78R23', '1.78R24', '1.78R25', "1.78R26", "1.78R27", "1.78R28", "1.78R29", "1.78R30", "1.78R31", "1.78R32", "1.78R33", "1.78R34", "1.78R35", "1.78R36", "1.79R1", "1.79R2", "1.79R3", "1.79R4", "1.79R5", "1.8R1", "1.8R2", "1.8R3", "1.8R4", "1.8R5", "1.8R6", "1.8R7", "1.8R8", "1.8R9", "1.8R10", "1.8R11", "1.8R13", "1.8R14", "1.8R15", "1.8R16", "1.8R17", "1.8R18", "1.8R19", "1.9.1beta1", "1.9.1beta2", "1.9.1beta3", "1.9.1beta4", "1.9.1beta5", "1.9.1beta6", "1.9.1beta7", "1.9.1beta8", "1.9.1beta9", "1.9.1beta10", "1.9.1beta11", "1.9.1beta12", "1.9.1beta13", "1.9.1beta14", "1.9.1beta15", "1.9.1beta16", "1.9.1beta17", "1.9.1beta18", "1.9.1beta19", "1.9.1beta20", "1.9.1beta21", "1.9.1beta22", "1.9.1beta23", "1.9.1beta24", "1.9.1beta25", "1.9.1beta26", "1.9.5beta1", "1.9.5beta2", "1.9.5beta3", "1.9.5beta4", "1.9.5beta5", "1.9.5beta6", "1.9.5beta7", "1.9.5beta8", "1.9.5beta9", "1.9.6beta1", "1.9.6beta2", "1.9.6beta3", "1.9.6beta4", "1.9.6beta5", "1.9.6beta6", "1.9.6beta7", "1.9.6beta8", "1.9.6beta9", "1.9.7beta1", "1.9.7beta2", "1.9.7beta3", "1.9.7beta4", "1.9.7beta5", "1.9.7beta6") else 'AlignedGlass167.m' if args.version=='1.6.7' else 'ControlGlass.m' if args.version=='1.6.6' else 'HomeGlass.m'))],check=True)
            report['home_glass_source_typecheck'] = True
        sys.path.insert(0, str(ROOT / args.repair_dir))
        builder = importlib.import_module('build_plugin')
        if args.version and args.repair_dir != 'repair162':
            raise ValueError('--version requires repair162')
        version = args.version or builder.VERSION
        build_options = {'version': args.version} if args.version else {}
        report['plugin_version'] = version
        report['fixed_original_image_preserved'] = True
        builder.assemble_object = assemble
        builder.disassemble = disassemble
        candidate = output / (getattr(builder, 'PRODUCT_NAME', 'FanqieAdBlock') + '-' + version + '.dylib')
        baseline = ROOT / 'baseline' / 'FanqieAdBlock-1.5.8.dylib'
        first = builder.build(baseline, candidate, **build_options)
        second_path = output / 'rebuild' / candidate.name
        builder.build(baseline, second_path, **build_options)
        if candidate.read_bytes() != second_path.read_bytes():
            raise RuntimeError('Two Xcode builds produced different bytes')
        report.update(candidate_sha256=first['candidate_sha256'],
                      candidate_size=first['size_bytes'], two_builds_identical=True)
        report['composed_assembly_sha256'] = hashlib.sha256(
            candidate.with_suffix('.composed.s').read_bytes()).hexdigest()
        report['audit_input_sha256'] = {
            suffix: hashlib.sha256(candidate.with_suffix(suffix).read_bytes()).hexdigest()
            for suffix in ('.preextend', '.extension.bin')
        }
        report['native_source_sha256'] = {
            str(path.relative_to(ROOT)): hashlib.sha256(path.read_bytes()).hexdigest()
            for path in (ROOT / 'native' / 'AlignedGlass.m',
                         ROOT / 'native' / 'FanqieXDiagnostics.m')
        }
        if args.expect_candidate:
            if candidate.read_bytes() != args.expect_candidate.resolve().read_bytes():
                raise RuntimeError('Xcode output differs from the audited delivery candidate')
            report['audited_candidate_identical'] = True
        if not first['signature']['page_hashes_valid']:
            raise RuntimeError('Built candidate has invalid Mach-O page hashes')
        (output / 'SHA256SUMS.txt').write_text(
            hashlib.sha256(candidate.read_bytes()).hexdigest() + '  ' + candidate.name + '\n')
        report['passed'] = True
        return 0
    except Exception as error:
        report['error'] = str(error)
        print(str(error), file=sys.stderr)
        return 1
    finally:
        (output / 'xcode-build-report.json').write_text(
            json.dumps(report, ensure_ascii=False, indent=2) + '\n')
        print(json.dumps(report, ensure_ascii=False, indent=2))


if __name__ == '__main__':
    raise SystemExit(main())
