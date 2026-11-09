import sys,unittest
from pathlib import Path
ROOT=Path(__file__).resolve().parents[1]
sys.path[:0]=[str(ROOT/'repair162'),str(ROOT/'audit162')]
from macho_tools import assemble_object,sections
from arm64 import CPU
class Boundary:
    def handle(self,cpu,pc): return False
class ConditionalCompare(unittest.TestCase):
    def test_register_immediate_width_overflow_and_false_conditions(self):
        cases=[
            ('ccmp w0, #0, #15, eq',0,0,4,(False,True,True,False)),
            ('ccmp w0, #1, #0, eq',0,0,4,(True,False,False,False)),
            ('ccmp w0, #1, #0, eq',0x80000000,0,4,(False,False,True,True)),
            ('ccmp w0, #0, #0, eq',0x100000000,0,4,(False,True,True,False)),
            ('ccmp x0, #0, #0, eq',0x100000000,0,4,(False,False,True,False)),
            ('ccmp x0, x1, #0, ne',0x8000000000000000,1,0,(False,False,True,True)),
            ('ccmp w0, w1, #15, eq',42,41,0,(True,True,True,True)),
            ('ccmn w0, #1, #0, eq',0xffffffff,0,4,(False,True,True,False)),
            ('ccmn x0, x1, #0, eq',0x7fffffffffffffff,1,4,(True,False,False,True)),
            ('ccmp w0, #0, #0, le',1,0,8,(False,False,True,False)),
        ]
        for instruction,lhs,rhs,flags,expected in cases:
            with self.subTest(instruction=instruction,lhs=lhs):
                obj=assemble_object('.text\n'+instruction+'\nret\n')
                sec=next(s for s in sections(obj) if s['name']=='__text')
                code=obj[sec['offset']:sec['offset']+sec['size']]
                cpu=CPU(code,Boundary(),ranges=[(0,len(code))]);cpu.flags_imm(flags)
                cpu.run(0,args=[lhs,rhs])
                self.assertEqual((cpu.n,cpu.z,cpu.c,cpu.overflow),expected)
if __name__=='__main__':unittest.main()
