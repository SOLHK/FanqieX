#!/usr/bin/env python3
"""Compile runtime-only diagnostics into the existing relocation-free segment.

This accepts function code and C strings. Class/selector metadata, writable
data, unknown imports, and unrecognized page-relative references fail the build.
"""
from __future__ import annotations

import argparse
import hashlib
import os
from pathlib import Path
import platform
import re
import shutil
import subprocess


IMPORTS = {
    '_FQDRecord': 'Lrecord_named',
    '_FQDVersion': 'LDiagnosticVersion',
    '_FQDResolveOwned': 'LHookOwned',
    '_FQDString': 'Lstr',
    '_objc_msgSend': 'Lpatch + (0xa5d4 - PATCH_BASE)',
    '_objc_getClass': 'Lpatch + (0xa5b0 - PATCH_BASE)',
    '_objc_lookUpClass': 'Lpatch + (0xa5b0 - PATCH_BASE)',
    '_sel_registerName': 'Lpatch + (0xa5a4 - PATCH_BASE)',
    '_object_getClass': 'Lpatch + (0xa664 - PATCH_BASE)',
    '_objc_getAssociatedObject': 'Lpatch + (0xa628 - PATCH_BASE)',
    '_objc_setAssociatedObject': 'Lpatch + (0xa634 - PATCH_BASE)',
    '_method_getImplementation': 'Lpatch + (0xa598 - PATCH_BASE)',
    '_method_getTypeEncoding': 'Lpatch + (0xa5ec - PATCH_BASE)',
    '_method_setImplementation': 'Lpatch + (0xa580 - PATCH_BASE)',
    '_class_getInstanceMethod': 'Lpatch + (0xa5f8 - PATCH_BASE)',
    '_class_getClassMethod': 'Lpatch + (0xa604 - PATCH_BASE)',
    '_class_addMethod': 'Lpatch + (0xa58c - PATCH_BASE)',
    '_objc_allocateClassPair': 'Lpatch + (0xa61c - PATCH_BASE)',
    '_objc_registerClassPair': 'Lpatch + (0xa610 - PATCH_BASE)',
    '_objc_autoreleasePoolPush': 'Lpatch + (0xa5bc - PATCH_BASE)',
    '_objc_autoreleasePoolPop': 'Lpatch + (0xa574 - PATCH_BASE)',
}
SYMBOL = r'[A-Za-z_.$][A-Za-z0-9_.$]*'


def without_comment(line: str) -> str:
    quoted = escaped = False
    for index, char in enumerate(line):
        if escaped:
            escaped = False
        elif char == '\\':
            escaped = True
        elif char == '"':
            quoted = not quoted
        elif char == ';' and not quoted:
            return line[:index].strip()
    return line.strip()


def normalize_assembly(assembly: str) -> str:
    lines = [without_comment(line) for line in assembly.splitlines()]
    labels = [match.group(1) for line in lines
              if (match := re.fullmatch(f'({SYMBOL}):', line))]
    if len(labels) != len(set(labels)) or any(label in IMPORTS for label in labels):
        raise ValueError('Duplicate or conflicting diagnostic symbol')
    names = {label: 'LFQD_' + label.removeprefix('_') for label in labels}

    for index, line in enumerate(lines):
        match = re.fullmatch(f'adrp\\s+(x[0-9]+),\\s*({SYMBOL})@PAGE', line)
        if not match:
            continue
        register, label = match.groups()
        if label not in names:
            raise ValueError('Page reference outside native component: ' + label)
        following = index + 1
        while following < len(lines) and (not lines[following] or
                                         re.fullmatch(f'{SYMBOL}:', lines[following])):
            following += 1
        expected = f'add\\s+{register},\\s*{register},\\s*{re.escape(label)}@PAGEOFF'
        if following >= len(lines) or not re.fullmatch(expected, lines[following]):
            raise ValueError('Unsupported native page address pair: ' + line)
        lines[index] = f'adr {register}, {label}'
        lines[following] = 'nop'

    code, data, image_info = [], [], []
    output = None
    for line in lines:
        if not line:
            continue
        if line.startswith('.section'):
            section = re.sub(r'\s+', '', line.removeprefix('.section'))
            if section == '__TEXT,__text,regular,pure_instructions':
                output = code
            elif section == '__TEXT,__cstring,cstring_literals':
                output = data
            elif section == '__DATA,__objc_imageinfo,regular,no_dead_strip':
                output = image_info
            else:
                raise ValueError('Unsupported native section: ' + section)
            continue
        if line.split(None, 1)[0] in ('.build_version', '.globl', '.private_extern', '.loh'):
            continue
        if line == '.subsections_via_symbols':
            continue
        if output is None:
            raise ValueError('Native assembly precedes its section: ' + line)
        if output is image_info:
            image_info.append(line)
            continue
        if '@' in line and not line.startswith('.asciz'):
            raise ValueError('Unresolved native relocation: ' + line)
        label = re.fullmatch(f'({SYMBOL}):', line)
        if label:
            output.append(names[label.group(1)] + ':')
            continue
        if line.startswith('.'):
            if re.fullmatch(r'\.p2align\s+[0-4](?:,\s*[0-9]+(?:,\s*[0-9]+)?)?', line):
                output.append(line)
            elif output is code and (
                    line in ('.cfi_startproc', '.cfi_endproc', '.cfi_remember_state', '.cfi_restore_state') or
                    re.fullmatch(r'\.cfi_def_cfa_offset\s+[0-9]+', line) or
                    re.fullmatch(r'\.cfi_def_cfa\s+(?:w29|wsp),\s*[0-9]+', line) or
                    re.fullmatch(r'\.cfi_offset\s+(?:w(?:19|2[0-9]|30)|b(?:[89]|1[0-5])),\s*-[0-9]+', line) or
                    re.fullmatch(r'\.cfi_restore\s+(?:w(?:19|2[0-9]|30)|b(?:[89]|1[0-5]))', line)):
                # Preserve compiler-generated frame rules. The assembler emits
                # compact-unwind records which the final Mach-O builder links.
                output.append(line)
            elif output is data and re.fullmatch(r'\.asciz\s+"(?:[^"\\]|\\.)*"', line):
                output.append(line)
            else:
                raise ValueError('Unsupported native directive: ' + line)
            continue
        if output is not code:
            raise ValueError('Instruction in native constants: ' + line)
        branch = re.fullmatch(f'(b|bl)\\s+({SYMBOL})', line)
        if branch and branch.group(2) in IMPORTS:
            output.append(branch.group(1) + ' ' + IMPORTS[branch.group(2)])
            continue
        for symbol in re.findall(SYMBOL, line):
            if symbol.startswith('_') and symbol not in names:
                raise ValueError('Unsupported diagnostic import: ' + symbol)
        output.append(re.sub(SYMBOL, lambda match: names.get(match.group(), match.group()), line))
    if not code:
        raise ValueError('Native diagnostics contains no code')
    # Clang emits this empty image declaration for every .m translation unit.
    # The payload registers its classes and selectors through runtime calls.
    normalized_info = [re.sub(r'\s+', ' ', line) for line in image_info]
    if normalized_info and normalized_info != ['L_OBJC_IMAGE_INFO:', '.long 0', '.long 64']:
        raise ValueError('Unexpected Objective-C image metadata')
    return '\n'.join(code) + '\n// @COMPONENT_DATA\n' + '\n'.join(data) + '\n'


def compile_component(source_path: Path, *, compiler: list[str] | None = None) -> str:
    source = source_path.read_text(encoding='utf-8')
    if compiler is None:
        configured = os.environ.get('FQ_NATIVE_CLANG')
        if configured:
            compiler = [configured]
        elif platform.system() == 'Darwin':
            compiler = ['xcrun', '--sdk', 'iphoneos', 'clang']
        else:
            found = shutil.which('clang-19') or shutil.which('clang')
            if not found:
                raise RuntimeError('AArch64 Clang is required for native diagnostics')
            compiler = [found]
    options = ['-target', 'arm64-apple-ios15.0.1', '-x', 'objective-c',
               '-fno-objc-arc', '-fno-objc-exceptions', '-ffreestanding', '-fno-builtin', '-fno-stack-protector',
               '-fno-exceptions', '-fno-asynchronous-unwind-tables', '-funwind-tables',
               '-fno-jump-tables', '-fno-vectorize', '-fno-slp-vectorize',
               '-Wall', '-Wextra', '-Werror', '-Os', '-S', '-o', '-', '-']
    process = subprocess.run([*compiler, *options], capture_output=True,
                             text=True, encoding='utf-8', input=source)
    if process.returncode:
        raise RuntimeError('Native diagnostic compilation failed\n' + process.stderr)
    digest = hashlib.sha256(source.encode('utf-8')).hexdigest()
    return '// Source SHA-256: ' + digest + '\n' + normalize_assembly(process.stdout)


def main() -> None:
    parser = argparse.ArgumentParser(description=__doc__)
    parser.add_argument('source', type=Path)
    parser.add_argument('output_path', type=Path, nargs='?')
    parser.add_argument('--output', type=Path)
    args = parser.parse_args()
    if bool(args.output) == bool(args.output_path):
        parser.error('Provide exactly one output path')
    (args.output or args.output_path).write_text(compile_component(args.source), encoding='utf-8')


if __name__ == '__main__':
    main()
