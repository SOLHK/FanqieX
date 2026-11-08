#!/usr/bin/env python3
"""Candidate-specific instruction and state audit, filled with reviewed entries.

The entry offsets are supplied explicitly after reviewing the actual directory
and branch targets. None are taken from a main-script success flag.
"""
from pathlib import Path
import argparse
import hashlib
import json
import struct

from arm64 import CPU, bits, require
from legacy_runtime import Runtime
from new_scenarios import run_all as run_retained_scenarios
from regressions156 import records, run_all as run_156_regressions

ROOT = Path(__file__).resolve().parents[1]
RUNS = []
NAMES = ['ratio','layout','installer','repair','strings','end','version','reserved',
         'frame','background','restore','edge_update','edge_restore','find','round',
         'sync','eligible','visible','message','install_method','busy_key','scroll_key',
         'edge_key','hidden_key','parent_key','selected_key','sync_original','restore_original',
         'proxy_frame','material_update','material_reset','settings_boot',
         'ui_install','ui_export','ui_present','diagnostic_init','diagnostic_enqueue',
         'diagnostic_tick','diagnostic_maintenance','diagnostic_observe','diagnostic_snapshot',
         'diagnostic_snapshot_all','diagnostic_heartbeat','describe_view','describe_children',
         'string','number','dict_set','uint','now','settings_trampoline',
         'signature_key','bars_key','ui_busy_key','ui_sender_key','code_end','window',
         'reserved57','reserved58','reserved59','reserved60','reserved61','reserved62','reserved63']


def directory(data):
    words = struct.unpack_from('<64I',data,0x800)
    require(words[6] in (0x10505,0x10506,0x10508,0x10509) and words[7] == 0, 'Known 1.5.5/1.5.6 payload directory')
    require(all(not p or 0x100 <= p < words[55] or words[4] <= p < words[5] for p in words[57:60]), 'Additional entries stay inside code/data payload')
    require(0x100 <= words[0] < words[55] <= 0x3800 and words[4] == 0x11100 and words[4] < words[5] <= 0x13800, 'Split payload bounds')
    return {name:value+0x800 for name,value in zip(NAMES,words)}


def words_end(data):
    return int.from_bytes(data[0x800+61*4:0x800+62*4], 'little') + 0x800

def make(data, slide=0, **options):
    rt = Runtime(data,slide,**options)
    entries = directory(data)
    cpu = CPU(data,rt,slide,ranges=[(entries['ratio'],entries['code_end']),
                                   (0x4338,0x43fc),(0x4704,0x48d0),(0x4958,0x4d78),
                                   (0x5168,0x5204),(0x5688,0x56c0),(0x5b94,0x5c24),(0x60b8,0x62ac),
                                   (0x14080,words_end(data)),(0x6c14,0x6c4c),(0x6db4,0x702c),(0x711c,0x746c)])
    cpu.pointers.update(rt.rebase_pointers)
    RUNS.append((cpu,rt))
    return cpu, rt


def event_types(rt):
    return [e['event'] for e in rt.events]


def shadow_block(data):
    cpu, rt = make(data)
    layer = rt.layer(rt.LABEL)
    runs = []
    # Execute the actual setter sequence twice with the original harmful state
    # restored each time. s15 deliberately still contains the old literal 0.9f.
    for iteration in range(2):
        rt.objects[layer].state.update(shadowOpacity=0.9,shadowRadius=2.0)
        start = len(rt.events)
        cpu.x[21] = layer; cpu.v[15] = bits(0.9,32)
        cpu.pc = cpu.slide+0x6c14
        while cpu.pc != cpu.slide+0x6c4c:
            cpu.step()
        events = rt.events[start:]
        opacity = [e for e in events if e['event'] == 'shadowOpacity']
        radius = [e for e in events if e['event'] == 'shadowRadius']
        require(len(opacity) == len(radius) == 1, 'Actual shadow setters run once each')
        require(opacity[0]['bits'] == 0 and opacity[0]['value'] == 0.0, 's0 is exactly float +0.0')
        require(radius[0]['value'] == 0.0, 'd0 shadow radius is zero')
        runs.append(events)
    return {'passed':True,'runs':runs,'scope':'Actual modified title-layer setter block; not full UIKit font rendering'}


def geometry(data, entry):
    results = []
    for name, rect, initial, corrupt_same in [
        ('first_zero_frame', (4.0,4.0,82.0,48.0), (0,0,0,0), False),
        ('same_frame_repairs_missing_corner', (4.0,4.0,82.0,48.0), (4,4,82,48), True),
        ('new_dimensions', (2.0,2.0,20.0,44.0), (4,4,82,48), False),
    ]:
        cpu, rt = make(data)
        state = rt.objects[rt.BUTTON].state
        state['frame'] = initial; state['bounds'] = (0,0,*initial[2:])
        layer = rt.layer(rt.BUTTON)
        rt.objects[layer].state.update(cornerRadius=0.0,masksToBounds=False)
        run = cpu.run(entry,rt.BUTTON,fp_args=rect)
        layer_state = rt.objects[layer].state
        require(state['frame'] == rect, 'Final requested button frame')
        require(layer_state['cornerRadius'] == min(rect[2:])/2, 'Radius based on final bounds')
        require(layer_state['masksToBounds'] is True, 'Button clipping enabled')
        events = event_types(rt)
        require(events.index('bounds') < events.index('cornerRadius') < events.index('masksToBounds'),
                'Read final bounds before applying corner and mask')
        if initial != rect:
            require(events.index('setFrame') < events.index('bounds'), 'Set frame before reading bounds')
        else:
            require('setFrame' not in events, 'Original set_frame same-geometry fast path retained')
        radius_event = next(e for e in rt.events if e['event'] == 'cornerRadius')
        require(radius_event['owner_bounds'][2:] == list(rect[2:]), 'Corner applied to final nonzero bounds')
        results.append({'name':name,'passed':True,**run,'events':rt.events})
    return {'passed':True,'cases':results,
            'scope':'Actual frame/corner wrapper and original _set_frame with synchronous state model; no CA transaction or pixel test'}


def lifecycle(data, d):
    cpu, rt = make(data)
    old_colors = [rt.objects[p].state['backgroundColor'] for p in (rt.BAR,rt.CONTENT)]
    old_hidden = [rt.objects[p].state['hidden'] for p in rt.backdrops]
    cpu.run(d['installer'])
    cpu.run(d['repair'],rt.BAR)
    clear = rt.color('clearColor')
    def cleared():
        require(rt.objects[rt.BAR].state['backgroundColor'] == clear, 'Bar background clear')
        require(rt.objects[rt.CONTENT].state['hidden'], 'Native content hidden')
        require(all(rt.objects[p].state['hidden'] for p in rt.backdrops), 'All six controlled backgrounds hidden')
        require(not rt.objects[rt.PROXY].state['hidden'], 'Floating proxy stays visible')
        require(rt.objects[rt.EDGE].state['hidden'], 'Scoped edge hidden')
    cleared()
    # Model the unavailable host layout restoring native visuals and calling
    # setBackgroundColor synchronously. Both actual hook bodies execute.
    def host_layout(runtime, receiver):
        for p in runtime.backdrops:
            runtime.objects[p].state['hidden'] = False
        runtime.objects[runtime.CONTENT].state['hidden'] = False
        runtime.current_cpu.run(d['background'],receiver,runtime.sel('setBackgroundColor:'),runtime.color('layout_write'))
    rt.layout_mutator = host_layout
    begin = len(rt.events)
    cpu.run(d['layout'],rt.BAR,rt.sel('layoutSubviews'))
    events = rt.events[begin:]
    require(events[0]['event'] == 'original_layout', 'Original layout precedes repairs')
    cleared()
    begin = len(rt.events)
    late = rt.color('late_background')
    cpu.run(d['background'],rt.BAR,rt.sel('setBackgroundColor:'),late)
    writes = [e for e in rt.events[begin:] if e['event'] == 'original_background' and e['self'] == rt.BAR]
    require(len(writes) == 2 and writes[0]['value'] == late and writes[1]['value'] == clear,
            'Late background forwarded first, then cleared through reentrant bar hook')
    cleared()
    cpu.run(0x6db4,rt.BAR,rt.PROXY)
    require([rt.objects[p].state['backgroundColor'] for p in (rt.BAR,rt.CONTENT)] == old_colors,
            'Real restore preserves first saved native colors')
    require([rt.objects[p].state['hidden'] for p in rt.backdrops] == old_hidden,
            'Real restore preserves six original hidden flags')
    require(not rt.objects[rt.EDGE].state['hidden'], 'Edge restored to original false')
    no_cache(rt,d)
    return {'passed':True,'instructions':cpu.steps,'late_background_original_then_clear':True,
            'layout_called_background_hook_synchronously':True,'native_colors_and_hidden_restored':True}


def no_cache(rt, d):
    require(not records(rt,d),'Owned effect table has no live targets')
    require(all((rt.BAR,rt.slide+d[k]) not in rt.associations for k in
                ('scroll_key','hidden_key','busy_key')),
            'Deprecated single-object cache and busy flag cleared')
    if not rt.associations.get((rt.BAR,rt.slide+0xeb84)):
        require(all((rt.BAR,rt.slide+d[k]) not in rt.associations for k in
                    ('edge_key','parent_key','selected_key')),
                'Inactive teardown releases table and search statistics')
    else:
        for k in ('parent_key','selected_key'):
            value = rt.associations.get((rt.BAR,rt.slide+d[k]))
            require(not value or rt.is_kind(value,rt.classes['NSNumber']),
                    'Search diagnostics never retain a parent view or selected item')
    # 1.5.5 also owns a persistent diagnostic singleton, queue, and pending
    # records. Keep the old edge ownership assertion specifically on every
    # scroll/edge/parent/selection object instead of counting unrelated logger
    # lifetimes as leaks. Association clearing remains checked above.
    edge_objects = {rt.ROOT,rt.BAR,rt.SELECTED}
    edge_objects.update(p for p in rt.objects if rt.is_kind(p,rt.classes['UIScrollView']) or
                        rt.is_kind(p,rt.classes['UIScrollEdgeEffect']))
    require(all(rt.retain_balance.get(p,0) == 0 for p in edge_objects), 'Explicit edge retain/release balanced')


def cache_changes(data, d):
    cpu, rt = make(data)
    cpu.run(d['installer']); cpu.run(d['repair'],rt.BAR)
    second = rt.obj('UIScrollEdgeEffect','replacement_edge',hidden=False)
    rt.objects[rt.SCROLL].state['bottomEdgeEffect'] = second
    start = len(rt.events)
    cpu.run(d['repair'],rt.BAR)
    require(not rt.objects[rt.EDGE].state['hidden'] and rt.objects[second].state['hidden'],
            'Replacement restores previous edge and hides current edge')
    changes = [e for e in rt.events[start:] if e['event'] == 'setHidden' and e['self'] in (rt.EDGE,second)]
    require(len(changes) == 2 and {(e['self'],e['value']) for e in changes} == {(rt.EDGE,False),(second,True)},
            'Old edge restored and replacement hidden exactly once during guarded set reconciliation')
    new_selected = rt.obj('NSObject','next_tab')
    rt.objects[rt.BAR].state['selectedItem'] = new_selected
    rt.objects[rt.objects[rt.BAR].state['items']].state['items'].append(new_selected)
    rt.objects[rt.SCROLL].state['hidden'] = True
    page = rt.view('UIScrollView','next_page',(0,0,390,844),rt.ROOT)
    third = rt.obj('UIScrollEdgeEffect','next_page_edge',hidden=False)
    rt.objects[page].state.update(contentSize=(390,3000),bottomEdgeEffect=third)
    start = len(rt.events)
    cpu.run(0x60b8,rt.BAR,rt.PROXY)
    require(rt.objects[rt.BUTTON].state['selected'] is False, 'Original selection sync ran with original bar/proxy')
    require(not rt.objects[second].state['hidden'] and rt.objects[third].state['hidden'],
            'Selected-page change restores old edge and owns new page edge')
    require(any(row[0] == page and row[1] == third for row in records(rt,d)), 'Current page scroll owned')
    require(next(i for i,e in enumerate(rt.events[start:]) if e['event'] == 'selected') <
            next(i for i,e in enumerate(rt.events[start:]) if e['event'] == 'setHidden' and e['self'] == third),
            'Original selection sync completes before new page edge repair')
    # Same cached view becomes horizontally offscreen without a selected-item
    # change: geometry must still be revalidated on every cached use.
    rt.objects[page].state['frame'] = (400,0,390,844)
    cpu.run(d['repair'],rt.BAR)
    require(not rt.objects[third].state['hidden'], 'Offscreen cached page edge restored')
    no_cache(rt,d)
    return {'passed':True,'instructions':cpu.steps,'edge_identity_change':True,
            'selected_page_change_preserves_native_sync':True,'cached_geometry_rechecked':True}


def visibility_changes(data, d):
    results = []
    for name in ('bar_hidden','proxy_hidden','ancestor_hidden','no_window','proxy_detached','scroll_detached'):
        cpu, rt = make(data)
        cpu.run(d['installer']); cpu.run(d['repair'],rt.BAR)
        if name == 'bar_hidden': rt.objects[rt.BAR].state['hidden'] = True
        elif name == 'proxy_hidden': rt.objects[rt.PROXY].state['hidden'] = True
        elif name == 'ancestor_hidden': rt.objects[rt.ROOT].state['hidden'] = True
        elif name == 'no_window': rt.reparent(rt.ROOT,0)
        elif name == 'proxy_detached': rt.reparent(rt.PROXY,rt.ROOT)
        else: rt.reparent(rt.SCROLL,0)
        cpu.run(d['repair'],rt.BAR)
        require(not rt.objects[rt.EDGE].state['hidden'], name+': original edge restored')
        no_cache(rt,d)
        results.append({'name':name,'passed':True,'instructions':cpu.steps})
    return {'passed':True,'cases':results}


def original_true(data, d):
    cpu, rt = make(data,original_edge_hidden=True)
    cpu.run(d['installer']); cpu.run(d['repair'],rt.BAR)
    saved = next(row for row in records(rt,d) if row[1] == rt.EDGE)
    require(saved[2] is True, 'Original true stored as NSNumber')
    # The host unmasks it later. Repair may hide it again but must not replace
    # the original snapshot with the host's later false value.
    rt.objects[rt.EDGE].state['hidden'] = False
    cpu.run(d['repair'],rt.BAR)
    require(rt.objects[rt.EDGE].state['hidden'], 'Cached edge hidden again')
    require(next(row for row in records(rt,d) if row[1] == rt.EDGE) == saved, 'First snapshot not overwritten')
    cpu.run(0x6db4,rt.BAR,rt.PROXY)
    require(rt.objects[rt.EDGE].state['hidden'], 'Original true restored')
    no_cache(rt,d)
    return {'passed':True,'instructions':cpu.steps}


def reentrant_restore(data, d):
    results = []
    for mode in ('cache_invalidated_while_busy','disabled_after_original_restore'):
        cpu, rt = make(data)
        cpu.run(d['installer']); cpu.run(d['repair'],rt.BAR)
        seen = []
        def reenter(c, event):
            if seen or event['event'] != 'setHidden' or event['self'] != rt.EDGE or event['value']:
                return
            require(all(row[1] != rt.EDGE for row in records(rt,d)),
                    'Old target leaves published ownership before its reentrant restoration setter')
            if mode == 'cache_invalidated_while_busy':
                require(rt.associations.get((rt.BAR,d['busy_key'])) == rt.BAR, 'Busy guard active during cache replacement')
            else:
                require((rt.BAR,0xeb84) not in rt.associations, 'Original restore cleared active before reentry')
            published = records(rt,d)
            seen.append({'old_target_unpublished_before_callback':True})
            nested = c.run(d['repair'],rt.BAR)
            require(nested['result'] == (1 if mode == 'cache_invalidated_while_busy' else 0),
                    'Reentrant repair respects busy/inactive state')
            require(records(rt,d) == published, 'No edge reacquired or table changed inside callback')
        rt.on_event = reenter
        if mode == 'cache_invalidated_while_busy':
            replacement = rt.obj('UIScrollEdgeEffect','replacement_for_reentry',hidden=False)
            rt.objects[rt.SCROLL].state['bottomEdgeEffect'] = replacement
            cpu.run(d['repair'],rt.BAR)
            require(rt.objects[replacement].state['hidden'], 'Outer repair completes new edge ownership')
            rt.on_event = None
            cpu.run(0x6db4,rt.BAR,rt.PROXY)
        else:
            cpu.run(0x6db4,rt.BAR,rt.PROXY)
        require(len(seen) == 1 and not rt.objects[rt.EDGE].state['hidden'], 'Reentrant old edge restoration completed once')
        no_cache(rt,d)
        results.append({'name':mode,'passed':True,'instructions':cpu.steps,'callback':seen[0]})
    return {'passed':True,'cases':results,
            'scope':'Synchronous callback from mocked edge setter into actual repair code on reachable busy/inactive paths'}


def install_and_ratio(data, d):
    results = []
    for inherited in (False,True):
        cpu, rt = make(data,inherited=inherited)
        base = {s:dict(rt.methods[m]) for s,m in rt.own[rt.UIView].items()}
        cpu.run(d['installer'])
        for selector, entry, alias, original in (
            ('layoutSubviews','layout','fqab_158_originalTabLayout',rt.LAYOUT_IMP),
            ('setBackgroundColor:','background','fqab_158_originalBackground',rt.BACKGROUND_IMP),
            ('didMoveToWindow','window','fqab_158_originalWindowMove',rt.WINDOW_IMP)):
            method = rt.methods[rt.get_method(rt.TabBar,rt.sel(selector))]
            require(method['class'] == rt.TabBar and method['imp'] == d[entry], 'Own SSTabBar hook installed')
            saved = rt.methods[rt.get_method(rt.TabBar,rt.sel(alias))]
            require(saved['imp'] == original, 'Original IMP retained under alias')
        require({s:dict(rt.methods[m]) for s,m in rt.own[rt.UIView].items()} == base, 'UIView implementation unchanged')
        before = len(rt.events)
        cpu.run(d['installer'])
        require(len(rt.events) == before, 'Second installation makes no method changes')
        results.append({'name':'installer_inherited' if inherited else 'installer_own','passed':True,'instructions':cpu.steps})
    for name, options in [('ratio_active',{}),('ratio_inactive',{'active':False}),
                          ('ratio_detached',{'attached':False}),
                          ('ratio_inactive_ASLR',{'active':False,'slide':0x100000000})]:
        cpu, rt = make(data,**options)
        cpu.run(d['installer'])
        selector = rt.sel('setTabBarBackgroundRatio:animated:')
        value = 0x3fd5555555555555; boolean = 0x1122334455667788
        cpu.run(0x5b94,rt.BAR,selector,boolean,value)
        calls = [e for e in rt.events if e['event'] == 'original_ratio']
        if name == 'ratio_active':
            require(not calls, 'Mounted active ratio transition suppressed')
        else:
            require(len(calls) == 1 and calls[0]['self'] == rt.BAR and calls[0]['selector'] == selector
                    and calls[0]['d0'] == value and calls[0]['x2'] == boolean,
                    'Fallback forwards original self, selector, CGFloat bits and BOOL register')
        results.append({'name':name,'passed':True,'instructions':cpu.steps})
    return {'passed':True,'cases':results,
            'ABI':'All runs enforce 16-byte stack alignment, balanced SP, x18/x19-x29 and d8-d15 preservation; runtime calls clobber caller-saved arguments'}


def ancestor_exclusion(data, d):
    cpu, rt = make(data)
    rt.objects[rt.ROOT].cls = rt.classes['UIScrollView']
    rt.objects[rt.ROOT].state['contentSize'] = (390,2200)
    edge = rt.obj('UIScrollEdgeEffect','parent_scroll_edge',hidden=False)
    rt.objects[rt.ROOT].state['bottomEdgeEffect'] = edge
    cpu.run(d['repair'],rt.BAR)
    require(not rt.objects[edge].state['hidden'], 'Ancestor scroll edge never modified')
    require(any(row[0] == rt.SCROLL and row[1] == rt.EDGE for row in records(rt,d)),
            'Skip scroll parent itself and continue searching eligible sibling page')
    require(rt.objects[rt.EDGE].state['hidden'], 'Legitimate child page still handled')
    return {'passed':True,'instructions':cpu.steps,
            'regression':'Reproduced ancestor being retained and modified in prior a424e46f candidate; corrected candidate rejects parent itself'}


def main():
    parser = argparse.ArgumentParser()
    parser.add_argument('candidate',type=Path)
    parser.add_argument('--geometry-entry',type=lambda s:int(s,0))
    parser.add_argument('--baseline',type=Path)
    parser.add_argument('--report',type=Path)
    args = parser.parse_args()
    data = args.candidate.read_bytes()
    d = directory(data)
    require(struct.unpack_from('<I',data,0x800+6*4)[0] == 0x10509,'Final candidate is version 1.5.9')
    report = {'candidate':str(args.candidate.resolve()), 'sha256':hashlib.sha256(data).hexdigest(),
              'shadow':shadow_block(data), 'geometry':geometry(data,args.geometry_entry or d['frame']),
              'native_background_lifecycle':lifecycle(data,d), 'cache_changes':cache_changes(data,d),
              'visibility':visibility_changes(data,d), 'original_hidden_true':original_true(data,d),
              'synchronous_reentry':reentrant_restore(data,d), 'installation_and_ratio_ABI':install_and_ratio(data,d),
              'ancestor_scroll_exclusion':ancestor_exclusion(data,d),
              'retained_155_scenarios':run_retained_scenarios(data,d,make),
              'new_156_regressions':run_156_regressions(data,d,make,
                                    args.baseline.read_bytes() if args.baseline else None,directory),
              'device_tested':False,'UIKit_rendering_simulated':False,
              'input_data':'Synthetic modeled native objects and generated test log records; no device logs',
              'actual_patch_entries_stubbed':False}
    require(data == args.candidate.read_bytes(), 'Candidate unchanged throughout run')
    candidate_runs = [(c,r) for c,r in RUNS if c.data == data]
    baseline_runs = [(c,r) for c,r in RUNS if c.data != data]
    report['instruction_execution'] = {
        'candidate_total_steps':sum(c.steps for c,r in candidate_runs),
        'baseline_control_total_steps':sum(c.steps for c,r in baseline_runs),
        'candidate_payload_unique_instructions_observed':len(set().union(*(c.executed for c,r in candidate_runs)) & set(range(d['ratio'],d['code_end'],4))),
        'scope':'Candidate-only observed addresses are separated from uploaded-baseline controls; no claim that instruction coverage proves UIKit behavior'}
    report['limits'] = [
        'No iOS loading, dyld execution, UIKit pixels, Core Animation scheduling, gesture handling or glass sampling was tested.',
        'Host original layout/background/ratio IMPs are unavailable and modeled; callbacks test specified synchronous state changes only.',
        'View coordinates use translation with frame/bounds; transforms, clipping by ancestor rectangles, occlusion and animation interpolation are not modeled.',
        'Actual selection/frame/background-clear/background-restore helpers, whole original settings initializer/open-menu and the original proxy-frame call-site execute; the full original controller _update_home path is not executed.',
        'Edge ownership uses a bounded geometric heuristic; the test does not identify the user video backing layer as a UIScrollEdgeEffect.',
        'Explicit retain/release and association policies are observed, but UIKit object deallocation and autorelease timing are not simulated.',
        'Foundation runtime dispatch, +initialize, serial queues, locks, timer scheduling, filesystem APIs, JSON and plist calls use explicit native-boundary models. JSON/plist encodings and temporary disk files are real Python artifacts, not Apple Foundation results.',
        'Queue reversal and one controlled producer/worker interleaving are executed, not exhaustive concurrency or OS scheduling tests.',
        'Clock rollback can preserve future-dated records but cannot recover records already deleted by an earlier later cutoff.',
        'The 1025-record completeness check restores seeded synthetic history then executes actual prune/export plus fresh enqueues; it is not an enqueue throughput or real-device memory benchmark.',
        'Default-runloop timer delivery, suspension, crash durability between asynchronous flushes, UI activity completion and operating-system export file eviction remain untested on iOS.'
    ]
    path = args.report or Path(__file__).with_name('execution-audit.json')
    path.write_text(json.dumps(report,indent=2)+'\n')
    print(json.dumps(report,indent=2))


if __name__ == '__main__':
    main()
