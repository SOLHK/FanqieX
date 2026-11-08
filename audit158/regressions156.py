"""Behavioral 1.5.6 regressions executed from candidate ARM64 instructions.

The reference model supplies Objective-C platform calls, not patch control flow.
Assertions concern visible state/ownership/restoration, including cases where
the uploaded 1.5.5 demonstrably takes the wrong path. None are pixel tests.
"""
import hashlib
import struct

from arm64 import require
from new_scenarios import open_settings, saved


BASELINE_SHA256 = '179a43dfa460653fca297e64d595b7605698702f621d82353460d435b8b9e158'


def records(rt, d):
    pointer = rt.associations.get((rt.BAR, rt.slide+d['edge_key']), 0)
    if not pointer:
        return []
    require(rt.is_kind(pointer, rt.classes['NSArray']), 'Owned edge table is an array')
    rows = []
    for row in rt.objects[pointer].state['items']:
        require(rt.is_kind(row, rt.classes['NSArray']), 'Each edge record is an array')
        values = rt.objects[row].state['items']
        require(len(values) == 3, 'Edge records have view/effect/original-hidden fields')
        scroll, edge, initial = values
        require(rt.is_kind(scroll, rt.classes['UIScrollView']), 'Record source is a scroll view')
        require(rt.is_kind(edge, rt.classes['UIScrollEdgeEffect']), 'Record target is a bottom edge effect')
        require(rt.is_kind(initial, rt.classes['NSNumber']), 'Original hidden state is boxed')
        require(rt.objects[initial].state['value'] in (0,1), 'Original hidden is Boolean')
        rows.append((scroll,edge,bool(rt.objects[initial].state['value']),row))
    require(len(rows) <= 16, 'At most sixteen effects are owned')
    require(len({row[1] for row in rows}) == len(rows), 'An effect has exactly one ownership record')
    return rows


def scroll(rt, name, parent=None, frame=(0,0,390,844), content=(390,2200),
           hidden=False, initial_hidden=False, effect=None):
    view = rt.view('UIScrollView',name,frame,rt.ROOT if parent is None else parent,hidden=hidden)
    edge = effect or rt.obj('UIScrollEdgeEffect',name+'.bottom',hidden=initial_hidden)
    top = rt.obj('UIScrollEdgeEffect',name+'.top',hidden=False)
    rt.objects[view].state.update(contentSize=tuple(content),bottomEdgeEffect=edge,
                                  topEdgeEffect=top,contentInset=(0,0,0,0),
                                  adjustedContentInset=(0,0,0,0),dragging=False,decelerating=False)
    return view, edge, top


def nested_fixture(rt, initially_hidden=False):
    return scroll(rt,'actual_inner_list',parent=rt.SCROLL,initial_hidden=initially_hidden)


def prefix_to_done_choice(cpu, rt, glass_disabled):
    rt.objects[rt.DEFAULTS].state['values']['FanqieAdBlock.GlassDisabled.1'] = glass_disabled
    cpu.run(0x4704)
    rt.flush_main(cpu)
    host = rt.obj('SSSettingViewController','done_choice_host',
                  view=rt.view('UIView','done_choice_host.view',(0,0,390,844),rt.ROOT),
                  navigationItem=rt.obj('UINavigationItem','done_choice.navigation'),
                  presentedViewController=0)
    cpu.x[0] = host
    cpu.x[30] = cpu.RETURN
    cpu.pc = cpu.slide+0x4958
    beginning = cpu.steps
    targets = {cpu.slide+0x4b38:'system_done',cpu.slide+0x4bac:'custom_glass_done'}
    while cpu.pc not in targets:
        require(cpu.steps-beginning < 100000, 'Bounded original menu prefix')
        require(cpu.pc != cpu.RETURN, 'Original menu reaches a Done construction branch')
        cpu.step()
    return {'choice':targets[cpu.pc], 'choice_address':hex(cpu.pc-cpu.slide),
            'executed_instructions':cpu.steps-beginning}


def baseline_failures(baseline, make, directory):
    require(hashlib.sha256(baseline).hexdigest() == BASELINE_SHA256, 'Exact uploaded 1.5.5 negative control')
    d = directory(baseline)
    done = []
    for disabled in (0,1):
        c,r = make(baseline)
        result = prefix_to_done_choice(c,r,disabled)
        require(result['choice'] == ('custom_glass_done' if disabled == 0 else 'system_done'),
                'Uploaded build reproduces custom glass only when glass enabled')
        done.append({'glass_disabled':disabled,**result})
    c,r = make(baseline)
    inner, edge, _ = nested_fixture(r)
    c.run(d['repair'],r.BAR)
    require(r.objects[r.EDGE].state['hidden'] and not r.objects[edge].state['hidden'],
            'Uploaded build hides outer edge while leaving eligible inner edge visible')
    # The result is reproduced without manufacturing a false return from a patch helper.
    require(r.associations.get((r.BAR,d['scroll_key'])) == r.SCROLL,
            'Uploaded build caches the outer scroll instead of visiting the inner list')
    c2,r2 = make(baseline)
    c2.run(d['repair'],r2.BAR)
    _, late, _ = nested_fixture(r2)
    c2.run(d['repair'],r2.BAR)
    require(not r2.objects[late].state['hidden'], 'Uploaded cache misses a later attached inner list')
    return {'passed':True,'baseline_sha256':BASELINE_SHA256,
            'original_done_branch':done,'nested_edge_failure_reproduced':True,
            'late_inner_failure_reproduced':True,
            'scope':'Actual instruction branches and mock edge states; not a captured UIKit rendering'}


def done_and_dismiss(data, d, make):
    cases = []
    for disabled,slide in ((0,0),(1,0),(0,0x100000000)):
        c,r = make(data,slide=slide)
        r.objects[r.DEFAULTS].state['values']['FanqieAdBlock.GlassDisabled.1'] = disabled
        target,export = open_settings(c,r,d)
        nav = r.objects[r.objects[target].state['navigationItem']].state
        right = nav['right']; item = r.objects[right].state
        require(item.get('systemItem') == 0, 'Done uses UIBarButtonSystemItemDone')
        require(item['target'] == target and r.selector_names[item['action']] == 'fqab_close',
                'System Done preserves original owned target and close action')
        require(0x4b38 in c.executed and 0x4bac not in c.executed and 0x4be4 not in c.executed,
                'Complete menu never creates a nested custom glass Done button')
        method = r.get_method(r.objects[target].cls,item['action'])
        require(method and r.methods[method]['imp'] == slide+0x5688, 'Close action retains original implementation')
        r.invoke(c,target,item['action'],right,'main')
        dismiss = [e for e in r.events if e['event'] == 'dismiss']
        require(len(dismiss) == 1 and dismiss[0]['self'] == target and dismiss[0]['animated'] and dismiss[0]['completion'] == 0,
                'Done sends one dismiss request with correct receiver/arguments')
        require(r.objects[export].state['enabled'], 'Export remains installed and enabled')
        cases.append({'glass_disabled':disabled,'ASLR_slide':hex(slide),'passed':True,
                      'instructions':c.steps,'done_and_export_coexist':True,'original_dismiss_executed':True})
    return {'passed':True,'cases':cases,'scope':'Whole actual menu and close path; gesture hit testing remains device-only'}


def nested_and_late(data, d, make):
    c,r = make(data)
    inner,edge,top = nested_fixture(r)
    c.run(d['repair'],r.BAR)
    require(r.objects[r.EDGE].state['hidden'] and r.objects[edge].state['hidden'],
            'Both outer and real inner scroll edges are suppressed')
    require({v[1] for v in records(r,d)} == {r.EDGE,edge}, 'Both eligible edges are independently owned')
    require(not r.objects[top].state['hidden'], 'Inner top edge remains unchanged')
    before = {v[1]:v[3] for v in records(r,d)}
    c.run(d['repair'],r.BAR)
    require({v[1]:v[3] for v in records(r,d)} == before,
            'Repeated repair retains the first original hidden-state records')
    c2,r2 = make(data)
    c2.run(d['repair'],r2.BAR)
    inner2,late,top2 = nested_fixture(r2)
    c2.run(d['repair'],r2.BAR)
    require(r2.objects[late].state['hidden'] and len(records(r2,d)) == 2,
            'An inner list attached after the first repair is discovered')
    # A loaded short/empty inner list becomes vertically scrollable after data arrives.
    r2.objects[inner2].state['contentSize'] = (390,844)
    c2.run(d['repair'],r2.BAR)
    require(not r2.objects[late].state['hidden'],'Non-scrolling list stops owning an edge')
    r2.objects[inner2].state['contentSize'] = (390,4000)
    c2.run(d['repair'],r2.BAR)
    require(r2.objects[late].state['hidden'],'Growing content is reevaluated without tab or parent changes')
    c2.run(d['edge_restore'],r2.BAR)
    require(not r2.objects[r2.EDGE].state['hidden'] and not r2.objects[late].state['hidden'] and not records(r2,d),
            'All newly discovered edges restore on explicit teardown')
    return {'passed':True,'outer_and_inner':True,'late_attachment':True,
            'late_content_growth':True,'no_top_edge_changes':True,'instructions':c.steps+c2.steps}


def paging_and_replacement(data, d, make):
    c,r = make(data)
    r.objects[r.SCROLL].state['contentSize'] = (780,844)
    page1,edge1,top1 = scroll(r,'page_one',r.SCROLL)
    page2,edge2,top2 = scroll(r,'page_two',r.SCROLL,frame=(390,0,390,844))
    c.run(d['repair'],r.BAR)
    require(r.objects[edge1].state['hidden'] and not r.objects[edge2].state['hidden'] and not r.objects[r.EDGE].state['hidden'],
            'Visible vertical page managed, horizontal pager and offscreen page unchanged')
    original_selected = r.objects[r.BAR].state['selectedItem']
    r.objects[r.SCROLL].state['bounds'] = (390,0,390,844)
    c.run(d['repair'],r.BAR)
    require(r.objects[r.BAR].state['selectedItem'] == original_selected,
            'Fixture changes paging without a tab-selection invalidation')
    require(not r.objects[edge1].state['hidden'] and r.objects[edge2].state['hidden'],
            'Horizontal page movement releases old and acquires actual visible child')
    replacement = r.obj('UIScrollEdgeEffect','new_effect_object',hidden=False)
    r.objects[page2].state['bottomEdgeEffect'] = replacement
    c.run(d['repair'],r.BAR)
    require(not r.objects[edge2].state['hidden'] and r.objects[replacement].state['hidden'],
            'Replacement edge restores the original target and manages the new object')
    require(not r.objects[top1].state['hidden'] and not r.objects[top2].state['hidden'],
            'Paging never changes top edges')
    return {'passed':True,'same_tab_inner_paging':True,'effect_object_replacement':True,'instructions':c.steps}


def mixed_originals_and_shared_effect(data, d, make):
    c,r = make(data)
    inner,edge,_ = nested_fixture(r,initially_hidden=True)
    c.run(d['repair'],r.BAR)
    rows = records(r,d)
    require({v[1]:v[2] for v in rows} == {r.EDGE:False,edge:True}, 'Capture each original Boolean separately')
    saved_rows = {v[1]:v[3] for v in rows}
    r.objects[edge].state['hidden'] = False
    c.run(d['repair'],r.BAR)
    require(r.objects[edge].state['hidden'] and {v[1]:v[3] for v in records(r,d)} == saved_rows,
            'Host later visibility write does not replace first ownership snapshot')
    r.reparent(inner,0)
    c.run(d['repair'],r.BAR)
    require(r.objects[edge].state['hidden'] and all(v[1] != edge for v in records(r,d)),
            'Detached originally-hidden inner edge returns to hidden')
    c.run(d['edge_restore'],r.BAR)
    require(not r.objects[r.EDGE].state['hidden'] and not records(r,d), 'Outer originally-visible edge restored')
    c2,r2 = make(data)
    inner2,_,_ = scroll(r2,'shared_edge_inner',r2.SCROLL,effect=r2.EDGE)
    c2.run(d['repair'],r2.BAR)
    require(len(records(r2,d)) == 1 and records(r2,d)[0][2] is False,'Shared effect has one original snapshot')
    r2.objects[r2.SCROLL].state['contentSize'] = (780,844)
    c2.run(d['repair'],r2.BAR)
    require(len(records(r2,d)) == 1 and r2.objects[r2.EDGE].state['hidden'],
            'Remaining inner owner keeps a shared effect managed')
    r2.reparent(inner2,0)
    c2.run(d['repair'],r2.BAR)
    require(not r2.objects[r2.EDGE].state['hidden'] and not records(r2,d),
            'Last shared owner leaving restores its first original state')
    return {'passed':True,'mixed_original_hidden_states':True,'stable_original_records':True,
            'shared_target_deduplication':True,'last_owner_restores':True,'instructions':c.steps+c2.steps}


def exclusions_and_depth(data, d, make):
    c,r = make(data)
    r.objects[r.SCROLL].state['hidden'] = True
    cases = [
        ('offscreen',(400,0,390,844),(390,2200),False,1.0),
        ('too_narrow',(0,0,100,844),(100,2200),False,1.0),
        ('short_carousel',(0,720,390,100),(390,2200),False,1.0),
        ('horizontal',(0,0,390,844),(780,844),False,1.0),
        ('above_bar',(0,0,390,700),(390,2200),False,1.0),
        ('hidden',(0,0,390,844),(390,2200),True,1.0),
        ('transparent',(0,0,390,844),(390,2200),False,0.0),
        ('nonfinite_content',(0,0,390,844),(390,float('nan')),False,1.0),
    ]
    edges = []
    for name,frame,content,hidden,alpha in cases:
        view,edge,_ = scroll(r,name,frame=frame,content=content,hidden=hidden)
        r.objects[view].state['alpha'] = alpha
        edges.append(edge)
    other_window = r.view('UIWindow','unrelated_window',(0,0,390,844))
    _,other,_ = scroll(r,'another_window',parent=other_window)
    c.run(d['repair'],r.BAR)
    require(not records(r,d),'Unrelated/invalid scrolls never enter owned set')
    require(all(not r.objects[p].state['hidden'] for p in edges+[other]),'All excluded edge states remain unchanged')
    c2,r2 = make(data)
    parent = r2.ROOT
    for i in range(10):
        parent = r2.view('UIView','container_'+str(i),(0,0,390,844),parent)
    r2.reparent(r2.SCROLL,parent)
    c2.run(d['repair'],r2.BAR)
    require(r2.objects[r2.EDGE].state['hidden'],'An eligible content list past the former depth-eight limit is found')
    return {'passed':True,'excluded_cases':[x[0] for x in cases]+['other_window'],
            'eleven_level_hierarchy':True,'instructions':c.steps+c2.steps}


def bounded_multi_ownership(data, d, make):
    c,r = make(data)
    extras = [scroll(r,'stress_list_'+str(i)) for i in range(24)]
    c.run(d['repair'],r.BAR,max_steps=3000000)
    first = records(r,d)
    require(len(first) == 16,'Enough eligible inputs reach but never exceed ownership cap')
    saved_originals = {row[1]:row[2] for row in first}
    c.run(d['repair'],r.BAR,max_steps=3000000)
    require({row[1]:row[2] for row in records(r,d)} == saved_originals,
            'At the cap, rescanning does not capture already-hidden states as originals')
    for row in first[:4]:
        r.reparent(row[0],0)
    c.run(d['repair'],r.BAR,max_steps=3000000)
    require(all(not r.objects[row[1]].state['hidden'] for row in first[:4]), 'Dropped capped-set members restore')
    c.run(d['edge_restore'],r.BAR,max_steps=3000000)
    require(not records(r,d) and not r.objects[r.EDGE].state['hidden'] and
            all(not r.objects[e].state['hidden'] for _,e,_ in extras), 'Every controlled effect restores after bounded turnover')
    return {'passed':True,'eligible_input_count':25,'maximum_owned_effects':16,
            'turnover_and_full_restoration':True,'instructions':c.steps}


def run_all(data, d, make, baseline=None, directory=None):
    output = {
        'native_done_and_close':done_and_dismiss(data,d,make),
        'nested_and_late_scrolls':nested_and_late(data,d,make),
        'inner_paging_and_replacement':paging_and_replacement(data,d,make),
        'mixed_originals_and_shared_effect':mixed_originals_and_shared_effect(data,d,make),
        'scope_exclusions_and_nested_depth':exclusions_and_depth(data,d,make),
        'bounded_multi_ownership':bounded_multi_ownership(data,d,make),
    }
    if baseline is not None:
        output['uploaded_155_negative_controls'] = baseline_failures(baseline,make,directory)
    return output
