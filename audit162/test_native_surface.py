#!/usr/bin/env python3
"""Execute the actual 1.6.0 native-wrapper/visibility/monitor ARM64 paths.

The exact composed assembly is reassembled only to recover local label
addresses; every installed code/data byte must match the candidate first.
Repair decisions run in the fail-closed ARM64 interpreter. UIKit/Foundation
calls, weak tables and timer lifetime are explicit models, not device tests.
"""
import argparse
import hashlib
import json
from pathlib import Path
import struct
import sys

from arm64 import require
from native_runtime import make, Runtime

ROOT = Path(__file__).resolve().parents[1]
sys.path.insert(0, str(ROOT / 'repair162'))
from macho_tools import assemble_object, sections
from audit_extend import audit as audit_extension

LABELS = [
    'LXclaim_native', 'LXrelease_native', 'LXnative_hidden', 'LXnative_original',
    'LXguard_owner_key', 'LXvalid_proxy', 'LXupdate', 'LXrestore',
    'LXnative_update', 'LXnative_restore', 'LXsame_bottom_rect', 'LXsafe_tree',
    'LXmonitor_start', 'LXpoll', 'LXsnapshot', 'LXnative_key', 'LXproxy_key',
    'LXmonitor_key', 'LXowner_key', 'LXtimer_key', 'LXtick_key', 'LXrejected_key',
    'Lcode_end', 'LXcode_end', 'Lrepair', 'Ledge_update', 'Ledge_restore',
    'Lbusy_key', 'Ledge_key', 'Lfind_record', 'Lcapture_edge', 'Lrestore_removed',
]


def labels_for(data, composed):
    source = composed.read_text()
    appendix = '\n.p2align 2\n' + '\n'.join('.long ' + x + ' - Lpatch' for x in LABELS) + '\n'
    obj = assemble_object(source + appendix)
    text = [s for s in sections(obj) if s['name'] == '__text']
    require(len(text) == 1 and text[0]['reloc_count'] == 0,
            'Audit label recovery assembles without relocations')
    section = text[0]
    payload = obj[section['offset']:section['offset'] + section['size']]
    words = struct.unpack_from('<64I', data, 0x800)
    require(words[6] in (0x10602, 0x10603, 0x10604,0x10605,0x10606,0x10607,0x10701,0x10702,0x10703,0x10704, 0x14a00, 0x14b00), 'Known native surface payload directory')
    for start, stop in ((0x800, 0x800 + words[55]),
                        (0x800 + words[4], 0x800 + words[5]),
                        (0x800 + words[60], 0x800 + words[63])):
        require(data[start:stop] == payload[start - 0x800:stop - 0x800],
                'Candidate bytes equal the composed source at ' + hex(start))
    table = struct.unpack_from('<' + str(len(LABELS)) + 'I', payload,
                               len(payload) - 4 * len(LABELS))
    entries = {name: value + 0x800 for name, value in zip(LABELS, table)}
    require(entries['Lcode_end'] == words[55] + 0x800 and
            entries['LXcode_end'] == words[61] + 0x800,
            'Recovered code ends match the actual candidate directory')
    return entries


def association(rt, owner, entries, key):
    return rt.associations.get((owner, rt.slide + entries[key]), 0)


def rows(rt, bar, entries):
    value = association(rt, bar, entries, 'LXnative_key')
    return rt.objects[value].state['items'] if value else []


def row_hidden(rt, row):
    number = rt.objects[row].state['items'][2]
    return bool(rt.objects[number].state['value'])


def owner(rt, wrapper, entries):
    box = association(rt, wrapper, entries, 'LXguard_owner_key')
    return next(iter(rt.objects[box].state['items']), 0) if box else 0


def run(cpu, entries, name, *args):
    return cpu.run(entries[name], args=args, max_steps=3000000)


def put_frame(rt, view, frame):
    st = rt.objects[view].state
    st['frame'] = tuple(frame)
    st['bounds'] = (*st['bounds'][:2], *frame[2:])


def basic_and_abi(data, entries):
    cases = []
    for slide, legacy, own_override, original in [
        (0, False, False, False), (0, True, False, True),
        (0, False, True, False), (0x180000000, False, False, False),
    ]:
        cpu, rt = make(data, entries, slide=slide)
        wrapper = rt.wrapper(legacy=legacy, own_override=own_override, hidden=original)
        inherited = rt.methods[rt.get_method(rt.UIView, rt.sel('setHidden:'))]['imp']
        first = run(cpu, entries, 'LXnative_update', rt.BAR, rt.PROXY)
        require(rt.objects[wrapper].state['hidden'], 'Owned decoration hidden')
        require(owner(rt, wrapper, entries) == rt.BAR, 'Weak owner is the active bar')
        saved = rows(rt, rt.BAR, entries)
        require(len(saved) == 1 and row_hidden(rt, saved[0]) == original,
                'Capture the first hidden flag exactly')
        begin = len(rt.events)
        rt.hidden_send(cpu, wrapper, False)
        writes = [e for e in rt.events[begin:] if e['event'] == 'original_hidden']
        require(len(writes) == 1 and writes[0]['value'] is True,
                'Host NO is suppressed synchronously before any visible NO write')
        expected_imp = rt.WRAPPER_HIDDEN_IMP if own_override else rt.HIDDEN_IMP
        require(writes[0]['imp'] == expected_imp, 'Preserve the exact original implementation')
        rt.hidden_send(cpu, wrapper, True)
        require(rt.methods[rt.get_method(rt.UIView, rt.sel('setHidden:'))]['imp'] == inherited,
                'UIView.setHidden: is never changed')
        untouched = rt.wrapper('unowned', frame=(0, 0, 390, 90))
        rt.hidden_send(cpu, untouched, False)
        require(not rt.objects[untouched].state['hidden'], 'Unowned same-class instance passes through')
        run(cpu, entries, 'LXnative_restore', rt.BAR)
        require(rt.objects[wrapper].state['hidden'] == original,
                'Teardown restores the exact first hidden state')
        require(not owner(rt, wrapper, entries) and not rows(rt, rt.BAR, entries),
                'Teardown removes native ownership and weak owner')
        require(all(rt.retain_balance.get(p, 0) == 0 for p in
                    (rt.BAR, rt.PROXY, wrapper)), 'Validation temporary retains are balanced')
        cases.append({'slide': hex(slide), 'legacy_name': legacy,
                      'own_override': own_override, 'original_hidden': original,
                      'first_update_instructions': first['instructions'],
                      'total_instructions': cpu.steps, 'passed': True})
    return cases


def geometry_cases(data, entries):
    cases = []
    definitions = [
        ('coincident_bottom', True), ('negative_parent_origin', True),
        ('positive_parent_origin', True), ('maximum_120pt', True),
        ('different_parent', False), ('full_screen_wrapper', False),
        ('too_tall', False), ('x_mismatch', False), ('y_mismatch', False),
        ('width_mismatch', False), ('nan_wrapper', False), ('inf_bar', False),
        ('nan_parent_origin', False), ('inf_parent_origin', False),
        ('zero_parent_height', False), ('negative_parent_height', False),
        ('nan_parent_height', False), ('above_lower_half', False),
        ('not_at_parent_bottom', False),
    ]
    for name, expected in definitions:
        cpu, rt = make(data, entries)
        wrapper = rt.wrapper()
        if name in ('negative_parent_origin', 'positive_parent_origin'):
            origin = -1000 if name.startswith('negative') else 1000
            rt.objects[rt.ROOT].state['bounds'] = (0, origin, 390, 844)
            put_frame(rt, rt.BAR, (0, origin + 754, 390, 90))
            put_frame(rt, wrapper, (0, origin + 754, 390, 90))
        elif name in ('maximum_120pt', 'too_tall'):
            height = 120 if expected else 121
            put_frame(rt, rt.BAR, (0, 844 - height, 390, height))
            put_frame(rt, wrapper, (0, 844 - height, 390, height))
        elif name == 'different_parent':
            rt.reparent(wrapper, rt.WINDOW)
        elif name == 'full_screen_wrapper':
            put_frame(rt, wrapper, (0, 0, 390, 844))
            put_frame(rt, rt.BAR, (0, 0, 390, 844))
        elif name == 'x_mismatch': put_frame(rt, wrapper, (4, 754, 390, 90))
        elif name == 'y_mismatch': put_frame(rt, wrapper, (0, 750, 390, 90))
        elif name == 'width_mismatch': put_frame(rt, wrapper, (0, 754, 380, 90))
        elif name == 'nan_wrapper': put_frame(rt, wrapper, (float('nan'), 754, 390, 90))
        elif name == 'inf_bar': put_frame(rt, rt.BAR, (0, float('inf'), 390, 90))
        elif name in ('nan_parent_origin', 'inf_parent_origin'):
            value = float('nan') if name.startswith('nan') else float('inf')
            rt.objects[rt.ROOT].state['bounds'] = (0, value, 390, 844)
        elif name in ('zero_parent_height', 'negative_parent_height', 'nan_parent_height'):
            value = {'zero_parent_height': 0, 'negative_parent_height': -844,
                     'nan_parent_height': float('nan')}[name]
            rt.objects[rt.ROOT].state['bounds'] = (0, 0, 390, value)
        elif name == 'above_lower_half':
            rt.objects[rt.ROOT].state['bounds'] = (0, 0, 390, 100)
            put_frame(rt, wrapper, (0, 10, 390, 90)); put_frame(rt, rt.BAR, (0, 10, 390, 90))
        elif name == 'not_at_parent_bottom':
            put_frame(rt, wrapper, (0, 700, 390, 90)); put_frame(rt, rt.BAR, (0, 700, 390, 90))
        result = run(cpu, entries, 'LXsame_bottom_rect', wrapper, rt.BAR)
        require(bool(result['result']) == expected, 'Geometry decision: ' + name)
        cases.append({'name': name, 'accepted': expected,
                      'instructions': result['instructions'], 'passed': True})
    return cases


def safe_tree_cases(data, entries):
    cases = []
    for name in ('scroll', 'controller_responder', 'wrapper_controller_responder',
                 'host_bundle_uikit_name', 'unknown_class', 'transition',
                 'controller_wrapper', 'legacy_web', 'wk_web', 'too_many_children',
                 'too_deep', 'too_many_nodes', 'cycle', 'real_bar_descendant'):
        cpu, rt = make(data, entries)
        wrapper = rt.wrapper()
        cls = {'scroll': 'UIScrollView', 'host_bundle_uikit_name': 'UIHostContentView',
               'transition': 'UITransitionView',
               'controller_wrapper': 'UIViewControllerWrapperView',
               'legacy_web': 'UIWebView', 'wk_web': 'WKWebView'}.get(name, 'UIView')
        if name == 'unknown_class':
            rt._class('HostBookContent', 'UIView'); cls = 'HostBookContent'
        leaf = rt.view(cls, 'candidate_content', (0, 0, 390, 90), wrapper)
        if name in ('controller_responder', 'wrapper_controller_responder'):
            controller = rt.obj('UIViewController', 'host_controller')
            target = wrapper if name.startswith('wrapper') else leaf
            rt.objects[target].state['nextResponder'] = controller
        elif name == 'too_many_children':
            for i in range(49): rt.view('UIView', 'wide_' + str(i), (0, 0, 1, 1), leaf)
        elif name == 'too_deep':
            parent = leaf
            for i in range(13): parent = rt.view('UIView', 'deep_' + str(i), (0, 0, 1, 1), parent)
        elif name == 'too_many_nodes':
            for i in range(40):
                child = rt.view('UIView', 'branch_' + str(i), (0, 0, 1, 1), leaf)
                for j in range(5): rt.view('UIView', 'leaf_' + str(i) + '_' + str(j), (0, 0, 1, 1), child)
        elif name == 'cycle': rt.objects[leaf].state['subviews'].append(leaf)
        elif name == 'real_bar_descendant': rt.objects[leaf].state['subviews'].append(rt.BAR)
        budget = cpu.sp - 0x10000
        cpu.write(budget, 4, 192)
        direct = run(cpu, entries, 'LXsafe_tree', wrapper, rt.BAR, budget, 0)
        require(direct['result'] == 0, 'Unsafe native tree rejected: ' + name)
        update = run(cpu, entries, 'LXnative_update', rt.BAR, rt.PROXY)
        require(not rt.objects[wrapper].state['hidden'] and not owner(rt, wrapper, entries),
                'Unsafe host/controller/scroll wrapper is never hidden: ' + name)
        require(not rows(rt, rt.BAR, entries), 'Unsafe wrapper is not recorded')
        cases.append({'name': name, 'remaining_budget': cpu.read(budget, 4),
                      'guard_instructions': direct['instructions'],
                      'update_instructions': update['instructions'], 'passed': True})
    return cases


def guard_revocation(data, entries):
    cases = []
    for name in ('new_scroll_content', 'controller_content', 'host_bundle_content',
                 'moved_wrapper', 'removed_proxy', 'hidden_proxy',
                 'zero_proxy_bounds', 'removed_active_key', 'expired_weak_owner'):
        cpu, rt = make(data, entries)
        wrapper = rt.wrapper(hidden=True)
        run(cpu, entries, 'LXnative_update', rt.BAR, rt.PROXY)
        if name == 'new_scroll_content': rt.view('UIScrollView', name, (0, 0, 10, 10), wrapper)
        elif name == 'controller_content':
            controller = rt.obj('UIViewController', 'host_controller')
            rt.objects[wrapper].state['nextResponder'] = controller
        elif name == 'host_bundle_content': rt.view('UIHostContentView', name, (0, 0, 10, 10), wrapper)
        elif name == 'moved_wrapper': put_frame(rt, wrapper, (0, 0, 390, 90))
        elif name == 'removed_proxy': rt.reparent(rt.PROXY, rt.ROOT)
        elif name == 'hidden_proxy': rt.objects[rt.PROXY].state['hidden'] = True
        elif name == 'zero_proxy_bounds': rt.objects[rt.PROXY].state['bounds'] = (0, 0, 0, 0)
        elif name == 'removed_active_key': rt.associations.pop((rt.BAR, rt.slide + 0xeb84))
        elif name == 'expired_weak_owner': rt.zero_weak(rt.BAR)
        rt.hidden_send(cpu, wrapper, False)
        require(not rt.objects[wrapper].state['hidden'], 'Invalid guard permits host NO: ' + name)
        require(not owner(rt, wrapper, entries), 'Invalid guard immediately releases owner')
        run(cpu, entries, 'LXnative_restore', rt.BAR)
        require(not rt.objects[wrapper].state['hidden'],
                'Stale original YES never re-hides content after ownership revocation')
        cases.append({'name': name, 'passed': True, 'instructions': cpu.steps})
    return cases


def ownership_epochs(data, entries):
    cpu, rt = make(data, entries)
    wrapper = rt.wrapper(hidden=True)
    run(cpu, entries, 'LXnative_update', rt.BAR, rt.PROXY)
    old = rows(rt, rt.BAR, entries)[0]
    require(row_hidden(rt, old), 'First ownership starts hidden')
    leaf = rt.view('UIScrollView', 'temporarily_host_content', (0, 0, 10, 10), wrapper)
    rt.hidden_send(cpu, wrapper, False)
    require(not owner(rt, wrapper, entries), 'Host replacement revokes the first owner')
    rt.reparent(leaf, rt.ROOT)
    run(cpu, entries, 'LXnative_update', rt.BAR, rt.PROXY)
    new = rows(rt, rt.BAR, entries)[0]
    require(old != new and not row_hidden(rt, new),
            'A new epoch captures current NO instead of reusing stale original YES')
    require(owner(rt, wrapper, entries) == rt.BAR,
            'Old-row cleanup preserves a same-wrapper new-epoch guard')
    rt.hidden_send(cpu, wrapper, False)
    require(rt.objects[wrapper].state['hidden'], 'New epoch guard still intercepts NO')
    run(cpu, entries, 'LXnative_restore', rt.BAR)
    require(not rt.objects[wrapper].state['hidden'], 'New epoch restores its own original NO')

    cpu2, rt2 = make(data, entries)
    wrapper2 = rt2.wrapper()
    run(cpu2, entries, 'LXnative_update', rt2.BAR, rt2.PROXY)
    other = rt2.view('SSTabBar', 'second_bar', (0, 754, 390, 90), rt2.ROOT)
    proxy = rt2.view('UIVisualEffectView', 'second_proxy', (12, 0, 366, 56), other)
    rt2.associations[(other, rt2.slide + 0xeb84)] = proxy
    require(run(cpu2, entries, 'LXclaim_native', wrapper2, other)['result'] == 0,
            'A second live bar cannot steal existing ownership')
    unsafe = rt2.view('UIScrollView', 'transient_host', (0, 0, 10, 10), wrapper2)
    rt2.hidden_send(cpu2, wrapper2, False)
    rt2.reparent(unsafe, rt2.ROOT)
    run(cpu2, entries, 'LXnative_update', other, proxy)
    require(owner(rt2, wrapper2, entries) == other, 'New bar claims a released wrapper')
    run(cpu2, entries, 'LXnative_restore', rt2.BAR)
    require(owner(rt2, wrapper2, entries) == other and rt2.objects[wrapper2].state['hidden'],
            'Old bar cleanup cannot remove another bar\'s guard or restore its snapshot')
    run(cpu2, entries, 'LXnative_restore', other)
    require(not rt2.objects[wrapper2].state['hidden'], 'The new bar restores its own snapshot')
    return {'same_bar_new_epoch': True, 'cross_bar_stale_release': True,
            'total_instructions': cpu.steps + cpu2.steps, 'passed': True}


def repeated_claims_and_capacity(data, entries):
    cpu, rt = make(data, entries)
    wrapper = rt.wrapper()
    require(run(cpu, entries, 'LXclaim_native', wrapper, rt.BAR)['result'] == 2,
            'First claim reports a new ownership epoch')
    box = association(rt, wrapper, entries, 'LXguard_owner_key')
    hashes = rt.creation_counts['NSHashTable']
    for _ in range(128):
        require(run(cpu, entries, 'LXclaim_native', wrapper, rt.BAR)['result'] == 1,
                'Repeated same-bar claim reports existing ownership')
        require(association(rt, wrapper, entries, 'LXguard_owner_key') == box,
                'Repeated claim reuses the original weak box')
        rt.hidden_send(cpu, wrapper, False)
    require(rt.creation_counts['NSHashTable'] == hashes,
            'Repeated claim does not allocate accumulating weak owner boxes')
    require(rt.objects[box].state['items'] == [rt.BAR], 'Weak set contains one owner identity')
    require(all(rt.retain_balance.get(p, 0) == 0 for p in (wrapper, rt.BAR, rt.PROXY)),
            'Repeated validation has no outstanding explicit retain')

    cpu2, rt2 = make(data, entries)
    wrappers = [rt2.wrapper('wrapper_' + str(i)) for i in range(18)]
    run(cpu2, entries, 'LXnative_update', rt2.BAR, rt2.PROXY)
    saved = rows(rt2, rt2.BAR, entries)
    require(len(saved) == 16, 'Ownership capture respects 16-record cap')
    require(sum(bool(owner(rt2, p, entries)) for p in wrappers) == 16,
            'Capacity rejection never leaves an uncaptured guard owner')
    require(all(not rt2.objects[p].state['hidden'] for p in wrappers[16:]),
            'Excess wrappers remain untouched')
    run(cpu2, entries, 'LXnative_restore', rt2.BAR)
    require(all(not rt2.objects[p].state['hidden'] and not owner(rt2, p, entries)
                for p in wrappers), 'All captured original NO values are restored')
    return {'repeated_claims': 128, 'weak_boxes_added_after_first': 0,
            'record_cap': 16, 'excess_wrappers_untouched': 2,
            'instructions': cpu.steps + cpu2.steps, 'passed': True}


def conflicting_runtime(data, entries):
    cases = []
    for name in ('alias_present_with_own_override', 'inherited_alias_with_own_override',
                 'wrong_encoding', 'unknown_runtime_class', 'foreign_method_after_claim'):
        cpu, rt = make(data, entries)
        wrapper = rt.wrapper()
        cls = rt.objects[wrapper].cls
        if name in ('alias_present_with_own_override', 'inherited_alias_with_own_override'):
            alias_class = cls if name.startswith('alias_present') else rt.UIView
            rt._add(alias_class, 'fqab_native157_originalSetHidden:', rt.HIDDEN_IMP,
                    'v20@0:8B16')
            rt._add(cls, 'setHidden:', rt.WRAPPER_HIDDEN_IMP, 'v20@0:8B16')
        elif name == 'wrong_encoding':
            rt._add(cls, 'setHidden:', rt.WRAPPER_HIDDEN_IMP, 'v24@0:8@16')
        elif name == 'unknown_runtime_class':
            rt._class('CustomNativeWrapper', Runtime.WRAPPER)
            rt.objects[wrapper].cls = rt.classes['CustomNativeWrapper']
        elif name == 'foreign_method_after_claim':
            run(cpu, entries, 'LXnative_update', rt.BAR, rt.PROXY)
            method = rt.get_method(cls, rt.sel('setHidden:'))
            rt.methods[method]['imp'] = rt.FOREIGN_HIDDEN_IMP
        before = rt.methods[rt.get_method(cls, rt.sel('setHidden:'))]['imp']
        result = run(cpu, entries, 'LXclaim_native', wrapper, rt.BAR)
        require(result['result'] == 0, 'Unsafe/conflicting runtime claim is rejected: ' + name)
        require(rt.methods[rt.get_method(cls, rt.sel('setHidden:'))]['imp'] == before,
                'A rejected claim never overwrites a foreign or incompatible method')
        if name == 'foreign_method_after_claim':
            run(cpu, entries, 'LXnative_update', rt.BAR, rt.PROXY)
            require(not owner(rt, wrapper, entries) and not rt.objects[wrapper].state['hidden'],
                    'Lost hook ownership is removed and original NO restored')
        else:
            require(not owner(rt, wrapper, entries), 'Rejected fresh claim has no owner')
        cases.append({'name': name, 'instructions': cpu.steps, 'passed': True})
    return cases


def monitor_lifecycle(data, entries):
    cases = []
    for name in ('weak_owner_died', 'bar_detached', 'proxy_detached',
                 'active_proxy_removed', 'bar_hidden', 'busy_then_recheck'):
        cpu, rt = make(data, entries)
        wrapper = rt.wrapper()
        run(cpu, entries, 'LXnative_update', rt.BAR, rt.PROXY)
        run(cpu, entries, 'LXmonitor_start', rt.BAR)
        monitor = association(rt, rt.BAR, entries, 'LXmonitor_key')
        timer = association(rt, monitor, entries, 'LXtimer_key')
        require(monitor and timer, 'Monitor and timer created')
        require(rt.objects[timer].state['interval'] == 0.25, 'Monitor interval is 250ms')
        require((timer, 'kCFRunLoopCommonModes') in rt.objects[rt.main_runloop].state['timers'],
                'Monitor remains scheduled during tracking via common modes')
        run(cpu, entries, 'LXmonitor_start', rt.BAR)
        require(association(rt, rt.BAR, entries, 'LXmonitor_key') == monitor,
                'Repeated startup does not allocate another monitor')
        require(rt.creation_counts.get('FQABGlassMonitor158', 0) == 1 and
                rt.creation_counts['NSTimer'] == 1, 'Exactly one monitor/timer pair')
        rt.drain_timer_autoreleases()
        require(rt.alive_counts[monitor] == 2 and rt.alive_counts[timer] == 2,
                'Only documented bar/timer/run-loop association references remain')
        if name == 'weak_owner_died': rt.expire_bar(rt.BAR)
        elif name == 'bar_detached': rt.reparent(rt.BAR, 0)
        elif name == 'proxy_detached': rt.reparent(rt.PROXY, rt.ROOT)
        elif name == 'active_proxy_removed': rt.associations.pop((rt.BAR, rt.slide + 0xeb84))
        elif name == 'bar_hidden': rt.objects[rt.BAR].state['hidden'] = True
        elif name == 'busy_then_recheck':
            rt.associations[(rt.BAR, rt.slide + entries['Lbusy_key'])] = rt.BAR
            before = len(rt.events)
            rt.fire(cpu, timer)
            require(not any(e['event'] == 'original_hidden' for e in rt.events[before:]),
                    'Busy repair scope prevents monitor reentry')
            require(rt.objects[timer].state['valid'], 'Busy owner keeps its monitor alive')
            rt.associations.pop((rt.BAR, rt.slide + entries['Lbusy_key']))
            # A late visibility overwrite followed by a timer callback is repaired
            # through the actual native update, independently of setHidden hook.
            rt.objects[wrapper].state['hidden'] = False
            rt.fire(cpu, timer)
            require(rt.objects[wrapper].state['hidden'], 'Next eligible tick repairs native decoration')
            require(not association(rt, rt.BAR, entries, 'Lbusy_key'), 'Timer clears its busy marker')
            rt.reparent(rt.BAR, 0)
        rt.fire(cpu, timer)
        require(not rt.objects[timer].state['valid'], 'Lost/inactive owner invalidates timer')
        require(timer in rt.dead and monitor in rt.dead,
                'Timer and monitor release their retain cycle without post-dealloc messages')
        if name != 'weak_owner_died':
            require(not rt.objects[wrapper].state['hidden'] and not owner(rt, wrapper, entries),
                    'Detach/inactive cleanup restores original visibility and releases guard')
            require(not association(rt, rt.BAR, entries, 'LXmonitor_key'),
                    'Inactive bar releases monitor association')
        cases.append({'name': name, 'instructions': cpu.steps,
                      'modeled_monitor_deallocated': True, 'modeled_timer_deallocated': True,
                      'lifetime_events': len(rt.life_events), 'passed': True})
    return cases


def main():
    parser = argparse.ArgumentParser(description=__doc__)
    parser.add_argument('candidate', type=Path)
    parser.add_argument('--report', type=Path)
    args = parser.parse_args()
    candidate = args.candidate
    data = candidate.read_bytes()
    entries = labels_for(data, candidate.with_suffix('.composed.s'))
    structure = audit_extension(candidate.with_suffix('.preextend').read_bytes(), data,
                                candidate.with_suffix('.extension.bin').read_bytes())
    tests = {
        'basic_visibility_original_imp_and_abi': basic_and_abi(data, entries),
        'geometric_boundaries': geometry_cases(data, entries),
        'unsafe_trees_fail_closed': safe_tree_cases(data, entries),
        'ownership_revocation': guard_revocation(data, entries),
        'ownership_epochs': ownership_epochs(data, entries),
        'repeated_claims_and_record_capacity': repeated_claims_and_capacity(data, entries),
        'runtime_conflicts': conflicting_runtime(data, entries),
        'weak_monitor_lifecycle': monitor_lifecycle(data, entries),
    }
    report = {
        'passed': True, 'candidate_sha256': hashlib.sha256(data).hexdigest(),
        'candidate_bytes': len(data), 'extension_structure': structure,
        'candidate_code_matches_composed_source': True,
        'entries': {k: hex(v) for k, v in entries.items()}, 'tests': tests,
        'ABI_checks': ['Every run preserves x18/x19-x29 and d8-d15.',
                       'Every native boundary requires 16-byte stack alignment.',
                       'Every native call poisons all modeled caller-saved registers.',
                       'The saved visibility IMP receives the original setHidden: selector.'],
        'limits': [
            'No iOS/dyld execution, native UIKit pixels, animation timing or device injection acceptance.',
            'UIKit/Foundation and Objective-C dispatch are explicit boundary models.',
            'Monitor/timer retained references and weak-zeroing are modeled; a full Objective-C/autorelease heap is not.',
            'Repeated-claim checks count weak-box creation and balanced explicit retains; they do not prove whole-process leak freedom.',
            'The instruction decoder is fail-closed and covers instructions exercised here, not a formally verified ARM CPU.',
        ],
    }
    path = args.report or candidate.with_suffix('.native-audit.json')
    path.write_text(json.dumps(report, indent=2, ensure_ascii=False) + '\n')
    print(json.dumps({'passed': True, 'candidate_sha256': report['candidate_sha256'],
                      'report': str(path), 'test_groups': len(tests)}, ensure_ascii=False))


if __name__ == '__main__':
    main()
