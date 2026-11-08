#!/usr/bin/env python3
"""Execute the complete repair with four real modeled tab buttons.

No repair entry is intercepted. Platform/Foundation/host IMPs are modeled;
candidate instructions implement the full control flow. This is not UIKit.
"""
import argparse
import hashlib
import json
from pathlib import Path
import struct
from arm64 import CPU, require
from interaction_runtime import Runtime as Interaction, read_entries
from legacy_runtime import Runtime as Legacy

class Integrated(Interaction, Legacy):
    def handle(self,cpu,pc):
        if pc-self.slide==self.entries['main_repair']:
            # Remove the dedicated interaction audit's component isolation.
            return Legacy.handle(self,cpu,pc)
        return super().handle(cpu,pc)

def run(data):
    entries=read_entries(data)
    words=struct.unpack_from('<64I',data,0x800)
    ext=struct.unpack_from('<28I',data,0x800+words[60]+16)
    e={k:0x800+ext[i] for i,k in [(0,'update'),(1,'restore'),(7,'poll'),
       (19,'monitor_key'),(21,'timer_key')]}
    r=Integrated(data,entries)
    # Match the uploaded 440x956 screen: the list reaches beneath y=882 bar.
    r.objects[r.SCROLL].state.update(frame=(0,106,440,850), bounds=(0,0,440,850),
                                     contentSize=(440,2200))
    c=CPU(data,r,ranges=[(0x900,entries['main_code_end']),
                         (0x14080,entries['extension_code_end']), (0x4000,0xa574)])
    c.pointers.update(r.rebase_pointers)
    cases=[]
    c.run(entries['main_repair'],r.BAR)
    overlay=r.associated(r.PROXY,'overlay'); lens=r.associated(r.PROXY,'lens')
    ctrl=r.associated(r.PROXY,'controller'); pan=r.associated(r.PROXY,'pan')
    require(overlay and lens and ctrl and pan,'Full repair constructs interaction')
    require(r.objects[r.BAR].state['subviews'][-1]==overlay,'Foreground overlay is topmost')
    require(r.objects[r.EDGE].state['hidden'],'Full repair manages scroll edge alongside interaction')
    monitor=r.associations[(r.BAR,e['monitor_key'])]
    timer=r.associations[(monitor,e['timer_key'])]
    require(r.objects[timer].state['interval']==.25,'Scoped monitor interval')
    require((timer,'kCFRunLoopCommonModes') in r.objects[r.main_runloop].state['timers'],
            'Scrolling does not exclude the monitor run-loop mode')
    cases.append({'name':'full_repair_material_interaction_edge_monitor','passed':True})

    start=len(r.events)
    for _ in range(3): c.run(entries['main_repair'],r.BAR)
    reorders=[x for x in r.events[start:] if x['event']=='bring_front']
    require(not reorders,'Stable maintenance never swaps base/lens foreground order')
    cases.append({'name':'stable_foreground_no_glass_z_order_churn','passed':True})

    r.objects[pan].state.update(state=1,location=(259,28))
    c.run(entries['pan'],ctrl,r.sel('pan:'),pan)
    r.objects[pan].state.update(state=2,location=(154,28))
    c.run(entries['pan'],ctrl,r.sel('pan:'),pan)
    dragging=r.objects[lens].state['frame']
    require(r.route_calls==[],'Dragging has not loaded another page')
    r.objects[r.SCROLL].state['bounds']=(0,512,440,850)
    for _ in range(4):
        r.now+=.25
        c.run(e['poll'],monitor,r.sel('fqabPoll:'),timer,max_steps=3000000)
    require(r.objects[lens].state['frame']==dragging and r.associated(ctrl,'drag'),
            'Actual complete monitor/rescan keeps a live drag')
    r.objects[pan].state.update(state=3,location=(55,28))
    c.run(entries['pan'],ctrl,r.sel('pan:'),pan,max_steps=3000000)
    require(r.route_calls==[0] and r.selected_index()==0,'Click/sync/complete repair route commits once')
    require(r.objects[lens].state['frame']==r.objects[r.buttons[0]].state['frame'],
            'Full sync displays actual selected tab')
    cases.append({'name':'pan_poll_original_route_full_repair_closed_loop','passed':True})

    r.flush_main(c); r.drain_operations(c)
    from new_scenarios import saved
    records=saved(r)
    selection_records = [item.get('data', {}) for item in records
                         if item.get('data', {}).get('glassSelectionLens')]
    require(selection_records, 'Actual snapshots include the fallback selection fill')
    require(all(row['glassSelectionLens'].get('effectClass') in (None, 'nil', 'NSNull')
                for row in selection_records),
            'Fallback selection fill never adds a second glass material')
    effect = r.objects[r.PROXY].state['effect']
    require(effect and r.class_names[r.objects[effect].cls] == 'UIGlassEffect' and
            r.objects[effect].state['style'] == 0,
            'Complete fallback repair uses one Regular glass surface')
    require(any(any(v.get('bounds',[0,0])[1]==512 for v in item.get('data',{}).get('managedScrolls',[]))
                for item in records),'Actual scrolling offset is captured without bar layout')
    cases.append({'name':'scroll_offset_and_lens_diagnostic_observation','passed':True})

    c.run(0x6db4,r.BAR,r.PROXY,max_steps=3000000)
    require(not r.objects[r.EDGE].state['hidden'],'Original edge restored')
    require(not r.associated(r.PROXY,'overlay'),'Interaction ownership cleared')
    require(all(r.objects[b].state['superview']==r.PROXY_CONTENT for b in r.buttons),
            'Original button ownership restored')
    require(not r.objects[timer].state['valid'] and (r.BAR,e['monitor_key']) not in r.associations,
            'Original restore invalidates monitor and releases its owner association')
    cases.append({'name':'original_restore_tears_down_all_extensions','passed':True})
    return {'sha256':hashlib.sha256(data).hexdigest(),'passed':True,'cases':cases,
            'instructions':c.steps,'repair_entries_intercepted':False,
            'device_ui_tested':False,'limitations':['Objective-C/UIKit and host methods are modeled.',
                'No GPU glass sampling, physical touches, iOS load or installation is tested.']}

if __name__=='__main__':
    p=argparse.ArgumentParser();p.add_argument('candidate',type=Path);p.add_argument('--output',type=Path)
    a=p.parse_args();r=run(a.candidate.read_bytes());s=json.dumps(r,indent=2)+'\n'
    if a.output:a.output.write_text(s)
    print(s)
