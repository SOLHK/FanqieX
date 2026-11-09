"""Check the compiler boundary used to embed the runtime diagnostics module."""
import hashlib
import os
from pathlib import Path
import platform
import shutil
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


if __name__ == '__main__':
    unittest.main()
