"""Check the compiler boundary used to embed the runtime diagnostics module."""
import hashlib
import os
from pathlib import Path
import platform
import shutil
import struct
import subprocess
import sys
import unittest


ROOT = Path(__file__).resolve().parents[1]
sys.path.insert(0, str(ROOT / 'scripts'))
from compile_diagnostics import compile_component, normalize_assembly


class DiagnosticsCompilerTests(unittest.TestCase):
    def test_runtime_declarations_pass_strict_builtin_checks(self):
        configured=os.environ.get('FQ_NATIVE_CLANG')
        compiler=([configured] if configured else ['xcrun','--sdk','iphoneos','clang']
                  if platform.system()=='Darwin' else [shutil.which('clang-19') or 'clang'])
        result=subprocess.run([*compiler,'-target','arm64-apple-ios27.2','-fno-objc-arc',
                               '-fno-objc-exceptions','-Wall','-Wextra','-Werror','-fsyntax-only',
                               str(ROOT/'native'/'FanqieXDiagnostics.m')],capture_output=True,text=True)
        self.assertEqual(result.returncode,0,result.stderr)

    def test_source_and_generated_component_are_current(self):
        source = ROOT / 'native' / 'FanqieXDiagnostics.m'
        compiled = compile_component(source)
        committed = (ROOT / 'native' / 'FanqieXDiagnostics.s').read_text(encoding='utf-8')
        expected = '// Source SHA-256: ' + hashlib.sha256(
            source.read_text(encoding='utf-8').encode('utf-8')).hexdigest()
        self.assertEqual(committed.splitlines()[0], expected)
        self.assertEqual(compiled.splitlines()[0], expected)
        self.assertEqual(compiled.count('// @COMPONENT_DATA'), 1)
        self.assertNotIn('@PAGE', compiled)
        self.assertNotIn('.section', compiled)
        self.assertIn('.cfi_startproc', compiled)
        self.assertIn('.cfi_def_cfa w29, 16', compiled)
        self.assertIn('.cfi_endproc', compiled)
        for entry in ('FQDInstall', 'FQDSettings', 'FQDAdDecision'):
            self.assertIn('LFQD_' + entry + ':', compiled)

    def test_import_call_and_internal_address_are_resolved(self):
        source = '''.section __TEXT,__text,regular,pure_instructions
_FQDProbe:
Lloh0:
adrp x0, l_string@PAGE
Lloh1:
add x0, x0, l_string@PAGEOFF
b _objc_lookUpClass
.loh AdrpAdd Lloh0, Lloh1
.section __TEXT,__cstring,cstring_literals
l_string:
.asciz "NSObject;literal"
'''
        component = normalize_assembly(source)
        self.assertIn('adr x0, LFQD_l_string', component)
        self.assertIn('b Lpatch + (0xa5b0 - PATCH_BASE)', component)
        self.assertIn('.asciz "NSObject;literal"', component)

    def test_unsupported_machine_code_dependencies_fail_closed(self):
        prefix = '.section __TEXT,__text,regular,pure_instructions\n_FQDProbe:\n'
        violations = {
            'unknown import': prefix + 'bl _malloc\n',
            'writable data': '.section __DATA,__data\n_state:\n.long 0\n',
            'objc class metadata': '.section __DATA,__objc_classlist,regular,no_dead_strip\n',
            'external GOT': prefix + 'adrp x0, _malloc@GOTPAGE\n',
            'mismatched page pair': prefix + 'adrp x0, _FQDProbe@PAGE\nadd x0,x0,_other@PAGEOFF\n',
            'unexpected image flags': prefix + 'ret\n.section __DATA,__objc_imageinfo,regular,no_dead_strip\nL_OBJC_IMAGE_INFO:\n.long 0\n.long 65\n',
            'external unwind personality': prefix + '.cfi_personality 155, _bad\n',
            'unreviewed unwind escape': prefix + '.cfi_escape 0\n',
        }
        for name, assembly in violations.items():
            with self.subTest(name=name), self.assertRaises(ValueError):
                normalize_assembly(assembly)

    def test_literal_loads_preserve_bits_base_register_and_flags(self):
        sys.path.insert(0, str(ROOT / 'repair162'))
        sys.path.insert(0, str(ROOT / 'audit162'))
        from macho_tools import assemble_object, sections
        from arm64 import CPU

        class NoRuntime:
            def handle(self, cpu, address):
                return False

        for width, kind, register in ((16, 'q', 1), (16, 'q', 7), (8, 'd', 0), (4, 's', 0),
                                      (8, 'x', 9), (4, 'w', 9),
                                      (8, 'x', 8), (4, 'w', 8)):
            base = 7 if kind == 'q' and register == 7 else 8
            bits = 0x3f847ae147ae147b if width == 8 else 0x3c23d70a
            literal = ('.quad' if width == 8 else '.long') + f' {bits:#x}'
            if width == 16:
                low, high = 0x3fe9cac083126e98, 0x3feae147ae147ae1
                bits = (high << 64) | low
                literal = f'.quad {low:#x}\n.quad {high:#x}'
            source = f'''.section __TEXT,__literal{width},{width}byte_literals
.p2align {width.bit_length() - 1}, 0x0
lCPI0_0:
{literal}
.section __TEXT,__text,regular,pure_instructions
_FQDProbe:
adrp x{base}, lCPI0_0@PAGE
Lloh0:
ldr {kind}{register}, [x{base}, lCPI0_0@PAGEOFF]
mov x0, x{base}
ret
'''
            component = normalize_assembly(source)
            self.assertNotIn('@PAGE', component)
            self.assertNotIn('.section', component)
            assembly = '.text\nLprobeStart:\n' + component + '\n.p2align 2\n.long LFQD_lCPI0_0 - LprobeStart\n'
            obj = assemble_object(assembly)
            section = next(item for item in sections(obj) if item['name'] == '__text')
            self.assertEqual(section['reloc_count'], 0)
            payload = obj[section['offset']:section['offset'] + section['size']]
            constant_at = struct.unpack_from('<I', payload, len(payload) - 4)[0]
            self.assertEqual(constant_at % width, 0)
            self.assertEqual(int.from_bytes(payload[constant_at:constant_at + width], 'little'), bits)
            for slide in (0, 0x180000000, 0x180001000):
                with self.subTest(width=width, destination=f'{kind}{register}', slide=slide):
                    cpu = CPU(payload, NoRuntime(), slide=slide)
                    cpu.flags(True, False, True, True)
                    result = cpu.run(0)
                    overwritten = kind in 'xw' and register == base
                    self.assertEqual(result['result'], bits if overwritten else (slide + constant_at) & ~0xfff)
                    if kind in 'qds':
                        self.assertEqual(cpu.v[register], bits)
                    else:
                        self.assertEqual(cpu.x[register], bits)
                    self.assertEqual((cpu.n, cpu.z, cpu.c, cpu.overflow), (True, False, True, True))

    def test_empty_c_string_does_not_enable_general_space_directives(self):
        code = '.section __TEXT,__text,regular,pure_instructions\n_FQDProbe:\nret\n'
        constants = '.section __TEXT,__cstring,cstring_literals\nl_empty:\n.space 1\n'
        self.assertIn('LFQD_l_empty:\n.asciz ""', normalize_assembly(code + constants))
        for unsafe in ('.space 2', '.space 1, 1', '.space _external', '.zero 1'):
            with self.subTest(directive=unsafe), self.assertRaises(ValueError):
                normalize_assembly(code + constants.replace('.space 1', unsafe))
        with self.assertRaises(ValueError):
            normalize_assembly(code + '.space 1\n')

    def test_literal_pool_boundary_rejects_unsafe_or_ambiguous_inputs(self):
        pool = '.section __TEXT,__literal8,8byte_literals\n.p2align 3, 0x0\nlCPI0_0:\n.quad 0x3f847ae147ae147b\n'
        code = '.section __TEXT,__text,regular,pure_instructions\n_FQDProbe:\nadrp x8, lCPI0_0@PAGE\nldr d0, [x8, lCPI0_0@PAGEOFF]\nret\n'
        valid = pool + code
        invalid = {
            'writable pool': valid.replace('__TEXT,__literal8', '__DATA,__literal8'),
            'incomplete vector pool': valid.replace('__literal8,8byte_literals', '__literal16,16byte_literals'),
            'symbolic word': valid.replace('.quad 0x3f847ae147ae147b', '.quad _external'),
            'symbol arithmetic': valid.replace('.quad 0x3f847ae147ae147b', '.quad lCPI0_0 + 8'),
            'wrong data width': valid.replace('.quad 0x3f847ae147ae147b', '.long 1'),
            'overflow': valid.replace('.quad 0x3f847ae147ae147b', '.quad 0x10000000000000000'),
            'negative overflow': valid.replace('.quad 0x3f847ae147ae147b', '.quad -9223372036854775809'),
            'under-alignment': valid.replace('.p2align 3, 0x0', '.p2align 2'),
            'nonzero padding': valid.replace('.p2align 3, 0x0', '.p2align 3, 1'),
            'instruction in data': valid.replace('.quad 0x3f847ae147ae147b', 'ret'),
            'unlabelled word': valid.replace('lCPI0_0:\n.quad', '.quad'),
            'two words per label': valid.replace('.quad 0x3f847ae147ae147b', '.quad 1\n.quad 2'),
            'label without value': valid.replace('.quad 0x3f847ae147ae147b\n', ''),
            'alias': valid.replace('lCPI0_0:\n', 'lCPI0_0:\nalias:\n'),
            'wrong load width': valid.replace('ldr d0,', 'ldr s0,'),
            'vector load from narrow scalar': valid.replace('ldr d0,', 'ldr q0,'),
            'wrong base register': valid.replace('[x8,', '[x9,'),
            'different pageoff target': valid.replace('lCPI0_0@PAGEOFF', '_FQDProbe@PAGEOFF'),
            'unknown target': valid.replace('lCPI0_0@PAGE', 'missing@PAGE'),
            'write to constant': valid.replace('ldr d0,', 'str d0,'),
            'second unresolved page use': valid.replace('ret\n', 'ldr d1, [x8, lCPI0_0@PAGEOFF]\nret\n'),
        }
        wide = (valid.replace('__literal8,8byte_literals', '__literal16,16byte_literals')
                .replace('.p2align 3', '.p2align 4').replace('ldr d0,', 'ldr q0,')
                .replace('.quad 0x3f847ae147ae147b', '.quad 1\n.quad 2'))
        invalid.update({
            'half vector': wide.replace('.quad 2\n', ''),
            'oversized vector': wide.replace('.quad 2', '.quad 2\n.quad 3'),
            'symbolic vector lane': wide.replace('.quad 2', '.quad _external'),
            'overflowing vector lane': wide.replace('.quad 2', '.quad 0x10000000000000000'),
            'split vector': wide.replace('.quad 2', '.p2align 4\n.quad 2'),
            'out-of-range Q register': wide.replace('ldr q0,', 'ldr q32,'),
            'scalar load from vector': wide.replace('ldr q0,', 'ldr d0,'),
        })
        for name, assembly in invalid.items():
            with self.subTest(case=name), self.assertRaises(ValueError):
                normalize_assembly(assembly)


if __name__ == '__main__':
    unittest.main()
