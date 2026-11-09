#!/usr/bin/env python3
"""Run the production Objective-C diagnostic module against macOS Foundation.

This complements the ARM64 instruction models; it is not an iOS/UIKit test.
"""
from __future__ import annotations

import argparse
import json
from pathlib import Path
import platform
import subprocess


def main() -> None:
    parser = argparse.ArgumentParser(description=__doc__)
    parser.add_argument('--output', type=Path, default=Path('build/native-smoke'))
    parser.add_argument('--failure-case', choices=[
        'operation-type-number', 'operation-type-null', 'callback-throws', 'load-diagnostics-normal'])
    args = parser.parse_args()
    if platform.system() != 'Darwin' or platform.machine() != 'arm64':
        parser.error('Real Foundation smoke checks require a native arm64 macOS runner')
    root = Path(__file__).resolve().parents[1]
    output = args.output.resolve()
    output.mkdir(parents=True, exist_ok=True)
    native = output / 'diagnostics.o'
    executable = output / 'native-diagnostics-smoke'
    # Keep production code-generation options, including the current unwind
    # policy. The harness itself enables Objective-C exceptions to verify that
    # the installed NSException observer forwards rather than swallows raise.
    native_flags = ['-x', 'objective-c', '-fno-objc-arc', '-fno-objc-exceptions',
                    '-ffreestanding', '-fno-builtin', '-fno-stack-protector',
                    '-fno-exceptions', '-fno-asynchronous-unwind-tables', '-funwind-tables',
                    '-fno-jump-tables', '-fno-vectorize', '-fno-slp-vectorize',
                    '-Wall', '-Wextra', '-Werror', '-Os']
    subprocess.run(['xcrun', '--sdk', 'macosx', 'clang', '-arch', 'arm64', *native_flags,
                    '-c', str(root / 'native/FanqieXDiagnostics.m'), '-o', str(native)],
                   check=True, cwd=root)
    subprocess.run(['xcrun', '--sdk', 'macosx', 'clang', '-arch', 'arm64',
                    '-fno-objc-arc', '-fobjc-exceptions', '-fblocks',
                    '-Wall', '-Wextra', '-Werror', '-O1',
                    str(root / 'tests/native_diagnostics_smoke.m'), str(native),
                    '-framework', 'Foundation', '-o', str(executable)], check=True, cwd=root)
    cases = [args.failure_case] if args.failure_case else [
        'normal', 'operation-type-number', 'operation-type-null', 'callback-throws', 'load-diagnostics-normal']
    results = []
    for case in cases:
        command = [str(executable)]
        if case != 'normal':
            command += ['--failure-case', case]
        run = subprocess.run(command, capture_output=True, text=True, cwd=root)
        (output / f'{case}.stdout.log').write_text(run.stdout, encoding='utf-8')
        (output / f'{case}.stderr.log').write_text(run.stderr, encoding='utf-8')
        try:
            report = json.loads(run.stdout)
        except json.JSONDecodeError:
            report = {'passed': False, 'case': case, 'report_missing': True}
        report['returncode'] = run.returncode
        report['passed'] = bool(report.get('passed')) and run.returncode == 0
        results.append(report)
    final = {'passed': all(row['passed'] for row in results),
             'platform': platform.platform(), 'machine': platform.machine(),
             'native_foundation_tested': True, 'ios_or_uikit_tested': False,
             'cases': results, 'native_compile_flags': native_flags}
    encoded = json.dumps(final, ensure_ascii=False, indent=2) + '\n'
    (output / 'native-smoke-report.json').write_text(encoded, encoding='utf-8')
    print(encoded, end='')
    if not final['passed']:
        raise SystemExit(1)


if __name__ == '__main__':
    main()
