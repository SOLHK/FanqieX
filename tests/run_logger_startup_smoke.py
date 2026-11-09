#!/usr/bin/env python3
"""Execute the composed logger startup against native ARM64 macOS Foundation."""
from __future__ import annotations

import argparse
import hashlib
import json
import platform
from pathlib import Path
import re
import subprocess
import sys
import tempfile


ROOT = Path(__file__).resolve().parents[1]

# Pinned plugin __TEXT,__stubs, checked against its indirect symbol table.
IMPORTS = {
    0xA574: '_objc_autoreleasePoolPop',
    0xA580: '_method_setImplementation',
    0xA58C: '_class_addMethod',
    0xA598: '_method_getImplementation',
    0xA5A4: '_sel_registerName',
    0xA5B0: '_FQClassLookup',
    0xA5BC: '_objc_autoreleasePoolPush',
    0xA5C8: '__dyld_get_image_header',
    0xA5D4: '_objc_msgSend',
    0xA5E0: '_strcmp',
    0xA5EC: '_method_getTypeEncoding',
    0xA5F8: '_class_getInstanceMethod',
    0xA604: '_class_getClassMethod',
    0xA610: '_objc_registerClassPair',
    0xA61C: '_objc_allocateClassPair',
    0xA628: '_objc_getAssociatedObject',
    0xA634: '_objc_setAssociatedObject',
    0xA640: '_object_getIvar',
    0xA64C: '_class_getInstanceVariable',
    0xA658: '___stack_chk_fail',
    0xA664: '_object_getClass',
}


def fixture_assembly(composed: str) -> str:
    # Only splice in the boundary of the original application-specific
    # settings installer. Its arm64 trampoline prologue must remain uncalled.
    old_call = '    bl Lsettings_original\n'
    if composed.count(old_call) != 1:
        raise ValueError('The original settings installer call site changed')
    composed = composed.replace(old_call, '    bl _FQOriginalSettings\n')

    def bind(match: re.Match) -> str:
        branch, address = match.groups()
        address = int(address, 16)
        symbol = IMPORTS.get(address)
        if address == 0x7394:
            symbol = '_FQIsKind'
        # Other pinned image continuations cannot execute in this fixture.
        # Fail explicitly if the tested graph begins to require another one.
        return branch + ' ' + (symbol or '_FQUnexpectedHostBranch')

    relocated = re.sub(r'\b(b|bl)\s+Lpatch\s*\+\s*\((0x[\da-fA-F]+)\s*-\s*PATCH_BASE\)',
                       bind, composed)
    return relocated + '''
.p2align 2
.globl _FQSettingsBoot
_FQSettingsBoot:
    b Lsettings_boot
.globl _FQLogger
_FQLogger:
    b LDdiag_init
.globl _FQTimerKey
_FQTimerKey:
    adr x0, LDtimer_key
    ret
'''


def main() -> None:
    parser = argparse.ArgumentParser(description=__doc__)
    parser.add_argument('--output', type=Path, default=ROOT / 'build' / 'logger-startup-smoke')
    parser.add_argument('--source-root', type=Path, default=ROOT,
                        help='Checkout providing the production assembly under test')
    parser.add_argument('--assembly-only', action='store_true',
                        help='Write the relocated assembly for cross-assembler inspection')
    args = parser.parse_args()
    if not args.assembly_only and (platform.system(), platform.machine()) != ('Darwin', 'arm64'):
        parser.error('Real logger smoke requires a native arm64 macOS runner')

    repair = args.source_root.resolve() / 'repair162'
    sys.path.insert(0, str(repair))
    from build_plugin import compose_assembly

    output = args.output.resolve()
    output.mkdir(parents=True, exist_ok=True)
    source = output / 'logger-startup-smoke.s'
    composed = compose_assembly(repair / 'floating_bar_162.s', '1.6.4')
    source.write_text(fixture_assembly(composed), encoding='utf-8')
    if args.assembly_only:
        return

    executable = output / 'logger-startup-smoke'
    subprocess.run(['xcrun', '--sdk', 'macosx', 'clang', '-arch', 'arm64', '-fobjc-arc',
                    '-Wall', '-Wextra', '-Werror', str(source),
                    str(ROOT / 'tests' / 'logger_startup_smoke.m'), '-framework', 'Foundation',
                    '-o', str(executable)], cwd=ROOT, check=True)
    cases = []
    for name in ('fresh-store', 'existing-store'):
        with tempfile.TemporaryDirectory(prefix='fanqiex-logger-startup-') as fixture:
            result = subprocess.run([str(executable), name, fixture], cwd=ROOT,
                                    capture_output=True, text=True, timeout=20)
        (output / f'{name}.stdout.log').write_text(result.stdout, encoding='utf-8')
        (output / f'{name}.stderr.log').write_text(result.stderr, encoding='utf-8')
        try:
            report = json.loads(result.stdout)
        except json.JSONDecodeError:
            report = {}
        report.update(case=name, returncode=result.returncode,
                      passed=result.returncode == 0 and report.get('passed') is True)
        cases.append(report)
    summary = {
        'passed': all(case['passed'] for case in cases),
        'platform': platform.platform(),
        'actual_composed_assembly': True,
        'native_foundation_tested': True,
        'ios_or_uikit_tested': False,
        'composed_sha256': hashlib.sha256(composed.encode()).hexdigest(),
        'cases': cases,
    }
    formatted = json.dumps(summary, indent=2) + '\n'
    (output / 'logger-startup-report.json').write_text(formatted, encoding='utf-8')
    print(formatted, end='')
    if not summary['passed']:
        raise SystemExit(1)


if __name__ == '__main__':
    main()
