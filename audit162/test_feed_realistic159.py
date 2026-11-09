#!/usr/bin/env python3
"""Execute old and new emitted ARM64 at more realistic framework boundaries.

This audit first reproduces four 1.5.8 refusals.  It then exercises 1.6.0's
actual instructions, not a Python rewrite of the repair.  Dynamic Objective-C
isa, framework coordinate roundoff, host layout methods, and Foundation/UIKit
messages are modeled boundaries.  This does not establish physical iPhone UI,
rendering, dylib injection, animation latency, or UIKit scheduling behavior.
"""
import argparse
import hashlib
import json
import math
from pathlib import Path
import struct

from arm64 import CPU, require
from feed_runtime import Runtime, fixture, put_frame
from test_feed_viewport import labels_for, make, run, update, records

ROOT = Path(__file__).resolve().parents[1]
EXTRA = ('LFsnapshot', 'LFstage_key', 'LFcandidates_key', 'LFdetail', 'LFfeed_original',
         'LFdynamic_classes_key', 'LFdynamic_layout0', 'LFdynamic_layout7')
SETTERS = ('setFrame', 'contentInset', 'contentOffset', 'clipsToBounds')


def writes(rt, start=0):
    return [e for e in rt.events[start:] if e['event'] in SETTERS]


def dynamic_isa(rt, f):
    cls = rt._class('NSKVONotifying_FQFeedListCollectionView', 'FQFeedListCollectionView')
    rt.objects[f['feed']].cls = cls
    rt.objects[f['feed']].state['reportedClass'] = rt.classes['FQFeedListCollectionView']
    return cls


def short_pager(rt, f, name='short_pager'):
    container = f['container']
    parent = rt.objects[container].state['superview']
    height = rt.objects[container].state['frame'][3]
    pager = rt.view('UIScrollView', name, (0, 0, 440, height), parent,
                    clipsToBounds=True, contentSize=(880, height))
    rt.reparent(container, pager)
    return pager


def compact_encoding(rt):
    rt._add(rt.classes['FQFeedListCollectionView'], 'layoutSubviews', rt.LAYOUT_IMP, 'v@:')


def snapshot(cpu, rt, entries):
    result = rt.box({}, mutable=True)
    run(cpu, entries, 'LFsnapshot', rt.BAR, result)
    value = rt.native(result)['feedViewportDiagnostics']
    # A real JSON encoder, including rejection of NaN/Infinity, checks that
    # diagnostic output consists solely of safely serializable values.
    json.dumps(value, allow_nan=False)
    return value


def one_snapshot(cpu, rt, entries):
    value = snapshot(cpu, rt, entries)
    require(len(value) == 1, 'One bounded candidate diagnostic')
    return value[0]


def old_negative_controls(data, composed):
    entries = labels_for(data, composed)
    require(struct.unpack_from('<I', data, 0x818)[0] == 0x10508, 'Negative controls use actual 1.5.8')
    cases = []
    for name in ('dynamic_isa', 'short_intermediate_pager', 'real_seq43_convert_roundoff',
                 'compact_void_encoding'):
        cpu, rt = make(data, entries)
        f = fixture(rt, tab=2, inner_height=784, outer_height=858,
                    outer_offset=597.6666666666666)
        if name == 'dynamic_isa': dynamic_isa(rt, f)
        elif name == 'short_intermediate_pager': short_pager(rt, f)
        elif name == 'real_seq43_convert_roundoff':
            rt.objects[f['feed']].state['convertHeightRoundoff'] = 784.0000000000005 - 784
        else: compact_encoding(rt)
        require(update(cpu, rt, entries, f['feed']) == 0,
                'Old emitted 1.5.8 must reproduce the refusal: ' + name)
        require(not writes(rt) and not records(rt, entries),
                'Negative control is a no-mutation refusal: ' + name)
        cases.append({'name': name, 'old_158_result': 'refused',
                      'instructions': cpu.steps, 'passed': True})
    return cases


def successful_cases(data, entries):
    cases = []
    names = ('ordinary_subclass', 'dynamic_isa', 'short_pager', 'two_short_pagers',
             'seq43_roundoff', 'seq39_roundoff', 'compact_void_encoding',
             'combined_realistic_boundaries', 'half_point_tolerance', 'feed_top_one_point',
             'same_feed_class_outer', 'shelf_seq22_roundoff')
    for name in names:
        slide = 0x180000000 if name in ('dynamic_isa', 'combined_realistic_boundaries') else 0
        cpu, rt = make(data, entries, slide)
        shelf = name in ('seq43_roundoff', 'shelf_seq22_roundoff')
        inner = 784 if shelf else 776
        f = fixture(rt, tab=2 if shelf else 3, inner_height=inner,
                    outer_height=858 if shelf else 850,
                    outer_offset=597.6666666666666 if shelf else 313)
        feed = f['feed']
        st = rt.objects[feed].state
        extra_clips = []
        if name == 'same_feed_class_outer':
            rt.objects[f['outer']].cls = rt.classes['FQFeedListCollectionView']
        if name == 'ordinary_subclass': rt.objects[feed].cls = rt.classes['OtherFeedView']
        if name in ('dynamic_isa', 'combined_realistic_boundaries'): dynamic_isa(rt, f)
        if name in ('short_pager', 'two_short_pagers', 'combined_realistic_boundaries'):
            extra_clips.append(short_pager(rt, f))
        if name == 'two_short_pagers': extra_clips.append(short_pager(rt, f, 'second_pager'))
        if name in ('compact_void_encoding', 'combined_realistic_boundaries'): compact_encoding(rt)
        if name in ('seq43_roundoff', 'combined_realistic_boundaries'):
            st['convertHeightRoundoff'] = 784.0000000000005 - 784
        if name == 'shelf_seq22_roundoff':
            st['convertHeightRoundoff'] = 783.9999999999998 - 784
            rt.objects[f['outer']].state['convertHeightRoundoff'] = 857.9999999999999 - 858
        if name == 'seq39_roundoff': st['convertHeightRoundoff'] = 775.9999999999998 - 776
        if name == 'half_point_tolerance': st['convertHeightRoundoff'] = 0.5
        if name == 'feed_top_one_point': put_frame(rt, f['container'], (0, 1, 440, inner))
        original = (st['frame'], st['contentInset'], st['bounds'][:2])
        require(update(cpu, rt, entries, feed) == 1, 'New actual instructions claim: ' + name)
        desired = 849 if name == 'feed_top_one_point' else 850
        require(st['frame'][3] == desired, 'Actual feed lower edge reaches 956pt')
        require(st['contentInset'][2] == 5 + desired - inner, 'Bottom range compensation')
        require(st['bounds'][:2] == original[2], 'Host scroll position survives repair')
        require(all(not rt.objects[v].state['clipsToBounds'] for v in extra_clips),
                'Only validated short pager clips are temporarily released')
        require(rt.objects[f['outer']].state['clipsToBounds'], 'Final outer clip stays enabled')
        require(entries['LFdetail'] not in cpu.executed,
                'Detailed diagnostics are not built in the layout hot path')
        d = one_snapshot(cpu, rt, entries)
        require(d['decision'] == 'applied' and d['rejectionStage'] == 1 and
                d['currentlyOwned'] == 1 and d['originalHeight'] == inner and
                d['appliedHeight'] == desired and d['currentHeight'] == desired,
                'Snapshot identifies actual applied ownership and original/current/applied heights')
        require(d['baseLayoutObserverInstalled'] == 1 and d['inheritsLayoutObserver'] == 1,
                'Base observer and inherited dispatch are recorded')
        if name in ('dynamic_isa', 'combined_realistic_boundaries'):
            require(d['reportedClass'] == 'FQFeedListCollectionView' and
                    d['runtimeClass'] == 'NSKVONotifying_FQFeedListCollectionView',
                    'Diagnostic class does not conceal actual dynamic isa')
            alias = rt.sel('fqab_feed159_originalLayout')
            require(alias not in rt.own[rt.objects[feed].cls],
                    'Dynamic subclass receives no alias or duplicate hook')
        if name in ('compact_void_encoding', 'combined_realistic_boundaries'):
            require(d['layoutMethodEncoding'] == 'v@:', 'Actual encoding retained and reported')
        begin = len(rt.events)
        for _ in range(4): require(update(cpu, rt, entries, feed) == 1, 'Stable ownership')
        require(not writes(rt, begin), 'Stable layouts issue no geometry writes')
        run(cpu, entries, 'LFrestore', rt.BAR)
        require((st['frame'], st['contentInset'], st['bounds'][:2]) == original,
                'Original dimensions, inset and offset restore exactly')
        require(all(rt.objects[v].state['clipsToBounds'] for v in extra_clips),
                'Disable restores every short intermediate clip')
        cases.append({'name': name, 'slide': hex(slide), 'passed': True,
                      'instructions': cpu.steps})
    return cases


def rejected_realistic(data, entries):
    cases = []
    names = ('short_pager_mask', 'short_pager_corner', 'short_pager_horizontal_page',
             'short_pager_transform', 'outer_unclipped', 'outer_mask', 'feed_mask',
             'above_half_point_tolerance', 'incompatible_layout_encoding',
             'unfolded_header_seq36', 'unfolded_header_seq48')
    for name in names:
        cpu, rt = make(data, entries)
        f = fixture(rt)
        feed = f['feed']
        pager = short_pager(rt, f)
        if name == 'short_pager_mask': rt.objects[rt.layer(pager)].state['mask'] = 0x1234
        elif name == 'short_pager_corner': rt.objects[rt.layer(pager)].state['cornerRadius'] = 8
        elif name == 'short_pager_horizontal_page': put_frame(rt, pager, (440, 0, 440, 776))
        elif name == 'short_pager_transform': rt.objects[pager].state['transform'] = (1, 0, 0, 1, 1, 0)
        elif name == 'outer_unclipped': rt.objects[f['outer']].state['clipsToBounds'] = False
        elif name == 'outer_mask': rt.objects[rt.layer(f['outer'])].state['mask'] = 0x1234
        elif name == 'feed_mask': rt.objects[rt.layer(feed)].state['mask'] = 0x1234
        elif name == 'above_half_point_tolerance': rt.objects[feed].state['convertHeightRoundoff'] = 0.5001
        elif name == 'incompatible_layout_encoding':
            rt._add(rt.classes['FQFeedListCollectionView'], 'layoutSubviews', rt.LAYOUT_IMP, 'B@:')
        elif name == 'unfolded_header_seq36':
            rt.objects[f['outer']].state['bounds'] = (0, 0, 440, 850)
        elif name == 'unfolded_header_seq48':
            put_frame(rt, f['cell'], (0, 597, 440, 776))
            rt.objects[f['outer']].state['bounds'] = (0, 0, 440, 850)
        require(update(cpu, rt, entries, feed) == 0, 'Unsafe realistic case refuses: ' + name)
        require(not writes(rt), 'Rejection never changes host geometry or clips: ' + name)
        d = one_snapshot(cpu, rt, entries)
        require(d['decision'] != 'applied' and d['currentlyOwned'] == 0 and
                d['originalHeight'] is None and d['appliedHeight'] is None,
                'Rejection explicitly reports no active geometry ownership')
        require(d['ancestors'] and all('runtimeClass' in a and 'windowRect' in a and
                                      'clipsToBounds' in a and 'identityTransform' in a
                                      for a in d['ancestors']),
                'Rejected path includes actual ancestors and geometry safety evidence')
        if name == 'incompatible_layout_encoding':
            require(d['rejectionStage'] == 11 and d['baseLayoutObserverInstalled'] == 0,
                    'Incompatible ABI explains observer rejection')
        cases.append({'name': name, 'decision': d['decision'], 'passed': True})
    return cases


def numeric_lifecycle(data, entries):
    cases = []
    for name in ('stable_ulp_and_restore', 'host_changes_above_epsilon'):
        cpu, rt = make(data, entries)
        f = fixture(rt)
        feed = f['feed']; st = rt.objects[feed].state
        require(update(cpu, rt, entries, feed) == 1, 'Initial numeric ownership')
        key = (feed, entries['LFstage_key'])
        stage = rt.associations[key]
        if name == 'stable_ulp_and_restore':
            begin = len(rt.events)
            for i in range(15):
                put_frame(rt, feed, (0, 0, 440, math.nextafter(850.0, math.inf)))
                st['contentInset'] = (3, 4, math.nextafter(79.0, math.inf), 6)
                require(update(cpu, rt, entries, feed) == 1, 'ULP changes do not recapture baseline')
            require(not writes(rt, begin), 'ULP-equivalent frames and insets avoid redundant setters')
            require(rt.associations[key] == stage, 'Stable decision reuses NSNumber')
            d = one_snapshot(cpu, rt, entries)
            require(d['originalHeight'] == 776 and d['originalInsetBottom'] == 5 and
                    d['appliedInsetBottom'] == 79, 'No accumulating padding or baseline drift')
            run(cpu, entries, 'LFrestore', rt.BAR)
            require(st['frame'][3] == 776 and st['contentInset'] == (3, 4, 5, 6),
                    'Conditional restore accepts only harmless ULP drift')
        else:
            put_frame(rt, feed, (0, 0, 440, 850.001))
            st['contentInset'] = (3, 4, 79.001, 6)
            run(cpu, entries, 'LFrestore', rt.BAR)
            require(st['frame'][3] == 850.001 and st['contentInset'][2] == 79.001,
                    'Host changes above epsilon are not overwritten during restore')
        cases.append({'name': name, 'passed': True})
    return cases


def above_outer_cases(data, entries):
    """A covering outer CGRect must remain drawable through its ancestors."""
    cases = []
    for name in ('short_clipping_wrapper', 'full_height_clipping_wrapper',
                 'short_unclipped_wrapper', 'masked_wrapper', 'transformed_wrapper',
                 'rounded_clipping_wrapper', 'narrow_clipping_wrapper',
                 'too_many_ancestors_above_outer'):
        cpu, rt = make(data, entries)
        f = fixture(rt)
        height = 882 if name in ('short_clipping_wrapper', 'short_unclipped_wrapper') else 956
        width = 420 if name == 'narrow_clipping_wrapper' else 440
        wrapper = rt.view('UIView', 'outer_wrapper', (0, 0, width, height), rt.ROOT,
                          clipsToBounds=name != 'short_unclipped_wrapper')
        rt.reparent(f['outer'], wrapper)
        if name == 'masked_wrapper': rt.objects[rt.layer(wrapper)].state['mask'] = 0x1234
        if name == 'transformed_wrapper': rt.objects[wrapper].state['transform'] = (1, 0, 0, 1, 0, 1)
        if name == 'rounded_clipping_wrapper': rt.objects[rt.layer(wrapper)].state['cornerRadius'] = 8
        wrappers = [wrapper]
        if name == 'too_many_ancestors_above_outer':
            for i in range(8):
                child = rt.view('UIView', 'outer_ancestor'+str(i), (0, 0, 440, 956),
                                wrapper, clipsToBounds=False)
                wrappers.append(child)
                wrapper = child
            rt.reparent(f['outer'], wrapper)
        before = {v: (rt.objects[v].state['frame'], rt.objects[v].state['clipsToBounds'])
                  for v in wrappers}
        accepted = name in ('full_height_clipping_wrapper', 'short_unclipped_wrapper')
        require(update(cpu, rt, entries, f['feed']) == int(accepted),
                'Coverage above the outer viewport is validated: '+name)
        require(all((rt.objects[v].state['frame'], rt.objects[v].state['clipsToBounds']) == state
                    for v, state in before.items()),
                'No ancestor above the outer viewport is resized or unclipped')
        d = one_snapshot(cpu, rt, entries)
        if accepted:
            require(d['currentlyOwned'] == 1 and d['currentHeight'] == 850,
                    'Actually drawable bottom extension remains supported')
            run(cpu, entries, 'LFrestore', rt.BAR)
            require(rt.objects[f['feed']].state['frame'][3] == 776,
                    'Accepted outer path still restores its inner viewport')
        else:
            require(not writes(rt) and d['currentlyOwned'] == 0 and d['rejectionStage'] == 12 and
                    d['decision'] == 'ancestor-above-outer-clip-mask-or-transform',
                    'Clipped or unverifiable outer path cannot falsely report an applied repair')
        cases.append({'name': name, 'accepted': accepted, 'passed': True})
    return cases


def diagnostic_limits(data, entries):
    cases = []
    cpu, rt = make(data, entries)
    f = fixture(rt)
    for i in range(20):
        feed = f['feed'] if not i else rt.view('FQFeedListCollectionView', 'candidate'+str(i),
                                             (0, 0, 440, 776), f['container'],
                                             contentSize=(440, 9000), hidden=True)
        update(cpu, rt, entries, feed)
    result = snapshot(cpu, rt, entries)
    require(len(result) == 12, 'Weak candidate cache and diagnostic output are capped at 12')
    box = rt.associations[(rt.BAR, entries['LFcandidates_key'])]
    require(rt.class_names[rt.objects[box].cls] == 'NSHashTable', 'Candidates live in weak table')
    rt.objects[box].state['items'] = [] # Model deallocation clearing weak slots.
    require(snapshot(cpu, rt, entries) == [], 'Expired weak candidates are not resurrected')
    cases.append({'name': 'weak_candidate_bound_and_expiry', 'passed': True})
    cpu, rt = make(data, entries); f = fixture(rt)
    parent = f['container']
    for i in range(12): parent = rt.view('UIView', 'ancestor'+str(i), (0, 0, 440, 776), parent)
    rt.reparent(f['feed'], parent)
    require(update(cpu, rt, entries, f['feed']) == 0, 'Deep unsafe path refuses')
    d = one_snapshot(cpu, rt, entries)
    require(len(d['ancestors']) == 8 and d['ancestorsTruncated'] == 1,
            'Deep diagnostic parent path is explicitly bounded, not silently incomplete')
    cases.append({'name': 'ancestor_diagnostic_bound', 'passed': True})
    return cases


class HostSubclassRuntime(Runtime):
    """Only host bodies are modeled; every repair trampoline executes ARM64.

    A native subclass may set geometry after super, omit super, or call layout
    reentrantly. Each fake host IMP has a fixed lexical superclass, matching
    objc_msgSendSuper dispatch instead of choosing the receiver's dynamic class.
    """
    def __init__(self, data, slide=0, **options):
        super().__init__(data, slide, **options)
        self.host_overrides = {}

    def override(self, name, parent='FQFeedListCollectionView', height=776,
                 call_super=True, reentrant=False, encoding='v16@0:8'):
        cls = self._class(name, parent)
        imp = 0x33009000 + 0x100 * len(self.host_overrides)
        self.host_overrides[imp] = dict(owner=cls, height=height,
                                       call_super=call_super, reentrant=reentrant)
        self._add(cls, 'layoutSubviews', imp, encoding)
        return cls, imp

    def handle(self, cpu, pc):
        spec = self.host_overrides.get(pc)
        if spec is None:
            return super().handle(cpu, pc)
        feed, selector = cpu.x[:2]
        saved_lr = cpu.x[30]
        self.event('host_subclass_layout', feed, selector=selector,
                   owner=self.class_names[spec['owner']])
        if spec['call_super']:
            parent = self.parents[spec['owner']]
            method = self.get_method(parent, selector)
            cpu.run(self.methods[method]['imp'] - self.slide, feed, selector,
                    max_steps=1000000)
        if spec['reentrant']:
            spec['reentrant'] = False
            self.invoke(cpu, feed, selector)
        if spec['height'] is not None:
            old = self.objects[feed].state['frame']
            put_frame(self, feed, (*old[:3], spec['height']))
            self.event('host_after_super_height', feed, height=spec['height'])
        cpu.x[30] = saved_lr
        return self.finish(cpu)


def host_machine(data, entries, slide=0):
    rt = HostSubclassRuntime(data, slide)
    cpu = CPU(data, rt, slide, ranges=[(0x900, entries['Lcode_end']),
                                      (0x14080, entries['LXcode_end']),
                                      (0x4878, 0x48d0), (0x7394, 0x746c)])
    cpu.pointers.update(rt.rebase_pointers)
    return cpu, rt


def hook_dispatch_cases(data, entries):
    cases = []
    cpu, rt = make(data, entries)
    f = fixture(rt); feed = f['feed']; cls = dynamic_isa(rt, f)
    require(update(cpu, rt, entries, feed) == 1, 'Dynamic instance initially repaired')
    # An inherited base hook must not resolve aliases on the receiver's subclass.
    rt._add(cls, 'fqab_feed159_originalLayout', 0x33009900, 'v16@0:8')
    start = len(rt.events)
    rt.invoke(cpu, feed, rt.sel('layoutSubviews'))
    require(sum(e['event'] == 'original_layout' for e in rt.events[start:]) == 1,
            'Base alias calls original once without subclass alias recursion')
    require(not any(e['event'] in ('class_addMethod', 'method_setImplementation') and
                    e.get('self') == cls for e in rt.events[start:]),
            'An inherited base observer does not allocate another runtime hook')
    cases.append({'name': 'fixed_base_original_ignores_subclass_alias', 'passed': True})

    for name in ('after_super_reset', 'no_super_reset', 'two_runtime_overrides',
                 'inherited_host_override', 'nested_host_reentry', 'stable_host_layout',
                 'disable_then_host_layout', 'weak_owner_expired', 'unsupported_tab'):
        slide = 0x180000000 if name in ('after_super_reset', 'two_runtime_overrides') else 0
        cpu, rt = host_machine(data, entries, slide)
        f = fixture(rt); feed = f['feed']; st = rt.objects[feed].state
        cls, imp = rt.override('RuntimeFeedA', call_super=name != 'no_super_reset',
                               reentrant=name == 'nested_host_reentry',
                               height=None if name == 'stable_host_layout' else 776)
        rt.objects[feed].cls = cls
        rt.objects[feed].state['reportedClass'] = rt.classes['FQFeedListCollectionView']
        expected_host_calls = 1
        expected_base_calls = 0 if name == 'no_super_reset' else 1
        if name == 'two_runtime_overrides':
            require(update(cpu, rt, entries, feed) == 1, 'First runtime class is observed')
            cls, imp = rt.override('RuntimeFeedB', 'RuntimeFeedA')
            rt.objects[feed].cls = cls
            expected_host_calls = 2
        elif name == 'inherited_host_override':
            child = rt._class('RuntimeFeedB', 'RuntimeFeedA')
            rt.objects[feed].cls = child
        elif name == 'nested_host_reentry':
            expected_host_calls = 2
            expected_base_calls = 2
        require(update(cpu, rt, entries, feed) == 1, 'Runtime family initially repaired: '+name)
        # A conflicting alias on the runtime class must have no effect: the
        # trampoline dispatches its immutable, class-bound original pointer.
        rt._add(cls, 'fqab_feed159_originalLayout', 0x33009900, 'v16@0:8')
        original_offset = st['bounds'][:2]
        if name == 'disable_then_host_layout':
            run(cpu, entries, 'LFrestore', rt.BAR)
        elif name == 'weak_owner_expired':
            owner = rt.associations[(feed, slide+entries['LFowner_key'])]
            rt.objects[owner].state['items'] = []
        elif name == 'unsupported_tab':
            rt.objects[rt.BAR].state['selectedItem'] = f['items'][0]
        start = len(rt.events)
        rt.invoke(cpu, feed, rt.sel('layoutSubviews'))
        events = rt.events[start:]
        disabled = name in ('disable_then_host_layout', 'weak_owner_expired', 'unsupported_tab')
        require(st['frame'][3] == (776 if disabled else 850),
                'Outermost layout returns with the correct viewport immediately: '+name)
        require(st['contentInset'] == (3, 4, 5 if disabled else 79, 6) and
                st['bounds'][:2] == original_offset,
                'Runtime observer preserves insets and position and restores when disabled')
        require(sum(e['event'] == 'host_subclass_layout' for e in events) == expected_host_calls and
                sum(e['event'] == 'original_layout' for e in events) == expected_base_calls,
                'Each lexical host original executes exactly once per invocation: '+name)
        require(all(e.get('selector') == rt.sel('layoutSubviews') for e in events
                    if e['event'] in ('host_subclass_layout', 'original_layout')),
                'Every original receives the original _cmd')
        require((feed, slide+entries['LFbusy_key']) not in rt.associations,
                'Nested runtime observers always retire the outer busy guard')
        if not disabled:
            d = one_snapshot(cpu, rt, entries)
            require(d['baseLayoutObserverInstalled'] == 1 and d['inheritsLayoutObserver'] == 1 and
                    d['runtimeLayoutObserverInstalled'] == 1 and d['currentHeight'] == 850 and
                    d['appliedHeight'] == 850,
                    'Diagnostics identify the active runtime observer without a stale height')
        if name == 'stable_host_layout':
            require(not writes(rt, start), 'A stable runtime layout does not issue geometry setters')
        elif not disabled:
            require(sum(e['event'] == 'setFrame' for e in events) == 1,
                    'Only the outermost callback repairs after the complete superclass chain')
        if name == 'after_super_reset':
            for _ in range(20):
                rt.invoke(cpu, feed, rt.sel('layoutSubviews'))
                require(st['frame'][3] == 850 and st['contentInset'][2] == 79,
                        'Repeated after-super resets cannot accumulate or expose a short final viewport')
        if not disabled:
            run(cpu, entries, 'LFrestore', rt.BAR)
            require(st['frame'][3] == 776 and st['contentInset'] == (3, 4, 5, 6),
                    'Runtime observer ownership restores on disable')
        cases.append({'name': name, 'slide': hex(slide), 'passed': True})

    for name in ('incompatible_runtime_encoding', 'replaced_runtime_method'):
        cpu, rt = host_machine(data, entries)
        f = fixture(rt); feed = f['feed']
        cls, imp = rt.override('RuntimeFeedA', encoding=(
            'v24@0:8i16' if name == 'incompatible_runtime_encoding' else 'v16@0:8'))
        rt.objects[feed].cls = cls
        if name == 'replaced_runtime_method':
            require(update(cpu, rt, entries, feed) == 1, 'Initial class binding installed')
            imp = 0x3300ef00
            rt._add(cls, 'layoutSubviews', imp, 'v16@0:8')
        require(update(cpu, rt, entries, feed) == 0, 'Unsafe runtime rewrapping is refused')
        require(rt.methods[rt.get_method(cls, rt.sel('layoutSubviews'))]['imp'] == imp,
                'An incompatible or foreign replacement is never overwritten')
        require(not records(rt, entries) and rt.objects[feed].state['frame'][3] == 776,
                'Refused runtime observer retains no applied geometry')
        require(one_snapshot(cpu, rt, entries)['rejectionStage'] == 11,
                'Observer refusal is visible in exported diagnostics')
        cases.append({'name': name, 'passed': True})

    cpu, rt = host_machine(data, entries)
    for index in range(9):
        f = fixture(rt); feed = f['feed']
        cls, imp = rt.override('RuntimeFeed'+str(index))
        rt.objects[feed].cls = cls
        require(update(cpu, rt, entries, feed) == int(index < 8),
                'Runtime hook slots are bounded and excess classes decline')
        method = rt.methods[rt.get_method(cls, rt.sel('layoutSubviews'))]['imp']
        if index < 8:
            require(method == entries['LFdynamic_layout0'] + index * 8,
                    'Each class receives its own immutable original-dispatch trampoline')
            rt.invoke(cpu, feed, rt.sel('layoutSubviews'))
            require(rt.objects[feed].state['frame'][3] == 850, 'Every bound slot repairs')
            run(cpu, entries, 'LFrestore', rt.BAR)
        else:
            require(method == imp and rt.objects[feed].state['frame'][3] == 776,
                    'Exhaustion leaves the new host class and geometry unchanged')
    table = rt.associations[(rt.classes['FQFeedListCollectionView'], entries['LFdynamic_classes_key'])]
    require(len(rt.objects[table].state['items']) == 8, 'Runtime observer table never exceeds eight slots')
    cases.append({'name': 'bounded_eight_runtime_original_slots', 'passed': True})
    return cases


def main():
    p = argparse.ArgumentParser(description=__doc__)
    p.add_argument('candidate', type=Path)
    p.add_argument('--baseline', type=Path, default=ROOT/'baseline/FanqieAdBlock-1.5.8.dylib')
    p.add_argument('--baseline-composed', type=Path,
                   default=ROOT/'baseline/FanqieAdBlock-1.5.8.composed.s')
    p.add_argument('--report', type=Path)
    a = p.parse_args()
    baseline = a.baseline.read_bytes()
    require(hashlib.sha256(baseline).hexdigest() ==
            '55a2c02e5962ad740816aaf2f8f2f6d9269eb9ecce37c69402897ff3776a4354',
            'Old negative controls use exact user-supplied 1.5.8 bytes')
    negative = old_negative_controls(baseline, a.baseline_composed)
    data = a.candidate.read_bytes()
    require(struct.unpack_from('<I', data, 0x818)[0] in (0x10602, 0x10603, 0x10604,0x10605,0x10606,0x10607,0x10701),
            'Known feed candidate version')
    entries = labels_for(data, a.candidate.with_suffix('.composed.s'), EXTRA)
    groups = {'old_158_negative_controls': negative,
              'realistic_accepted_boundaries': successful_cases(data, entries),
              'realistic_rejected_boundaries': rejected_realistic(data, entries),
              'numeric_ownership_and_restoration': numeric_lifecycle(data, entries),
              'coverage_above_outer_viewport': above_outer_cases(data, entries),
              'bounded_weak_diagnostics': diagnostic_limits(data, entries),
              'runtime_hook_original_dispatch_and_restoration': hook_dispatch_cases(data, entries)}
    report = {'passed': True, 'candidate_sha256': hashlib.sha256(data).hexdigest(),
              'old_158_sha256': hashlib.sha256(baseline).hexdigest(),
              'candidate_source_byte_equality': True, 'old_source_byte_equality': True,
              'test_count': sum(map(len, groups.values())), 'tests': groups,
              'device_ui_tested': False,
              'limits': ['Only actual ARM64 repair instructions execute; UIKit/Foundation/host methods are modeled boundaries.',
                         'No iPhone visual result, native UIKit animation, signing acceptance or injection was tested.',
                         'Runtime subclass post-layout behavior is checked with modeled host bodies; actual device scheduling, opaque layer mutations and the real app hierarchy remain unverified.']}
    out = a.report or a.candidate.with_suffix('.feed-realistic159.json')
    out.write_text(json.dumps(report, ensure_ascii=False, indent=2)+'\n')
    print(json.dumps({'passed': True, 'tests': report['test_count'],
                      'candidate_sha256': report['candidate_sha256'], 'report': str(out)}))


if __name__ == '__main__':
    main()
