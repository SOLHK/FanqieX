#!/usr/bin/env python3
"""Build the actual ARM64 repair with Xcode 27.2 and validate public UIKit APIs.

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
import struct
import subprocess
import sys
import tempfile

ROOT = Path(__file__).resolve().parents[1]


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
    parser.add_argument('--version', choices=('1.6.2', '1.6.3', '1.6.4', '1.6.5'),
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
              'sdk_typecheck_target': 'arm64-apple-ios27.2',
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
        if report['xcode'].splitlines()[0] != 'Xcode 27.2':
            raise RuntimeError('This release requires Xcode 27.2 exactly')
        if report['sdk_version'].split('.')[:2] != ['27', '2']:
            raise RuntimeError('This release requires the iOS 27.2 SDK')
        sdk = command('xcrun', '--sdk', 'iphoneos', '--show-sdk-path')
        subprocess.run(['xcrun', '--sdk', 'iphoneos', 'clang', '-target',
                        'arm64-apple-ios27.2', '-isysroot', sdk, '-fobjc-arc',
                        '-fmodules', '-Wall', '-Wextra', '-Werror', '-fsyntax-only',
                        str(ROOT / 'native' / 'PublicGlassAPI.m')], check=True)
        report['public_glass_api_typecheck'] = True
        if args.version in ('1.6.4', '1.6.5'):
            subprocess.run(['xcrun', '--sdk', 'iphoneos', 'clang', '-target',
                            'arm64-apple-ios27.2', '-isysroot', sdk, '-fno-objc-arc',
                            '-fno-objc-exceptions', '-Wall', '-Wextra', '-Werror', '-fsyntax-only',
                            str(ROOT / 'native' / 'FanqieXDiagnostics.m')], check=True)
            report['diagnostic_source_typecheck'] = True
        if args.version == '1.6.5':
            subprocess.run(['xcrun','--sdk','iphoneos','clang','-target','arm64-apple-ios18.0',
                            '-isysroot',sdk,'-fno-objc-arc','-Wall','-Wextra','-Werror','-fsyntax-only',
                            str(ROOT/'native/HomeGlass.m')],check=True)
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
