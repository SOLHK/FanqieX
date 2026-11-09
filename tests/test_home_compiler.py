"""Verify the source which is embedded into the shipping ARM64 component."""
import sys, unittest
from pathlib import Path
ROOT=Path(__file__).resolve().parents[1]
sys.path.insert(0,str(ROOT/'scripts'))
from compile_diagnostics import compile_component
class HomeCompilerTests(unittest.TestCase):
    def test_compiled_component_matches_source(self):
        for name in ('HomeGlass','ControlGlass','AlignedGlass'):
            with self.subTest(component=name):
                source=ROOT/'native'/(name+'.m')
                compiled=compile_component(source).replace('LFQD_','LFQH_')
                committed=(ROOT/'native'/(name+'.s')).read_text()
                # Toolchain scheduling can differ; pin the exact source digest.
                self.assertEqual(compiled.splitlines()[0],committed.splitlines()[0])
                self.assertIn('LFQH_FQHApply:',compiled)
                self.assertIn('.cfi_startproc',compiled)
                self.assertNotIn('@PAGE',compiled)
                self.assertEqual(compiled.count('// @COMPONENT_DATA'),1)
if __name__=='__main__': unittest.main()
