#!/usr/bin/env python3
"""Execute every existing ad replacement and its emitted diagnostic thunk."""
import argparse
import json
from pathlib import Path
import struct

from arm64 import CPU, require
from test_native_diagnostics164 import Runtime, journal
from test_feed_viewport import labels_for


class AdRuntime(Runtime):
    def __init__(self, data, slide):
        super().__init__(data, slide)
        self.completed = []

    def handle(self, cpu, pc):
        if pc-self.slide == 0xa5d4 and self.selector_names.get(cpu.x[1]) == 'finishExecution:success:reason:':
            self.completed.append(tuple(cpu.x[:5]))
            return self.finish(cpu)
        return super().handle(cpu, pc)


def cases(data, labels, slide):
    rt=AdRuntime(data,slide)
    words=struct.unpack_from('<64I',data,0x800)
    cpu=CPU(data,rt,slide,ranges=[(0x900,words[55]+0x800),
        (0x14080,words[61]+0x800),(0x4650,0x4958),(0x7394,0x746c)])
    cpu.pointers.update(rt.rebase_pointers)
    cpu.run(labels['LFQD_FQDInstall'])
    rules=[]
    for index in range(45):
        row=0x10170+index*24
        kind=data[row+1]
        shape=0x100b0+kind*16
        for offset in (row+8,row+16,shape,shape+8):
            pointer=struct.unpack_from('<Q',data,offset)[0]&((1<<36)-1)
            cpu.pointers[slide+offset]=slide+pointer
        def text(offset):
            pointer=cpu.pointers[slide+offset]-slide
            return data[pointer:data.index(b'\0',pointer)].decode()
        cls_name,selector,encoding=text(row+8),text(row+16),text(shape)
        if cls_name not in rt.classes:
            rt._class(cls_name,'NSObject')
        cls=rt.classes[cls_name]
        owner=rt.metaclasses[cls] if kind==1 else cls
        method=rt._add(owner,selector,rt.LAYOUT_IMP,encoding)
        receiver=cls if kind==1 else rt.obj(cls_name,'ad_target')
        rules.append((index,cls_name,selector,kind,method,receiver))
    cpu.run(0x4650,args=(0x7ffff,))
    # Installation emits no adRuleDecision. The first actual call must do so.
    require(not [r for r in journal(cpu,rt,data) if r['event']=='adRuleDecision'],
            'Installation status never masquerades as a rule decision')
    for index,cls_name,selector,kind,method,receiver in rules:
        replacement=rt.methods[method]['imp']
        require(replacement>=slide+0x14080,'Every rule uses its indexed thunk')
        for attempt in range(2):
            args=(receiver,rt.sel(selector),0x12345678,0x87654321,0,0,1,0)
            result=cpu.run(replacement-slide,args=args)
            if kind<8:
                require(result['result']==0,'The original BOOL/nil deny result survives logging')
    records=[r for r in journal(cpu,rt,data) if r['event']=='adRuleDecision']
    require(len(records)==90,'Every invocation emits one rule decision')
    for index,cls_name,selector,kind,_,receiver in rules:
        pair=[r for r in records if r['data']['ruleId']==index]
        require(len(pair)==2,'Rule IDs keep calls distinct')
        require(all(r['data']['class']==cls_name and r['data']['selector']==selector
                    and r['data']['matched']==1 and r['data']['result']==('blocked' if kind<8 else 'skipped')
                    and r['data']['pageDisplay']=='unobserved' for r in pair),
                'Decisions contain exact rule metadata and honest display coverage')
        require([r['data']['callCount'] for r in pair]==[1,2], 'Each rule tracks its actual invocation count')
    require(len(rt.completed)==2 and all(c[2]==0x87654321 and c[3]==0 for c in rt.completed),
            'The original sign-in completion receives its unchanged execution argument')
    require(all('sessionId' in r and 'correlationId' in r for r in records),
            'All rules enter the unified session envelope')
    return {'slide':hex(slide),'rules':45,'calls':90,'custom_completion_preserved':True}


def main():
    p=argparse.ArgumentParser(description=__doc__)
    p.add_argument('candidate',type=Path)
    p.add_argument('--report',type=Path,required=True)
    a=p.parse_args(); data=a.candidate.read_bytes()
    labels=labels_for(data,a.candidate.with_suffix('.composed.s'),['LFQD_FQDInstall'])
    result={'passed':True,'device_tested':False,'cases':[cases(data,labels,s) for s in (0,0x180000000)]}
    a.report.write_text(json.dumps(result,indent=2)+'\n')
    print(json.dumps(result,indent=2))


if __name__=='__main__':
    main()
