#!/usr/bin/env python3
"""Run the candidate's real ARM64 nested-feed functions against UIKit boundaries.

These checks establish machine-code decisions and ABI behavior, not iPhone
rendering, gesture latency, UIKit animation, signing, or injection acceptance.
"""
import argparse
import hashlib
import json
import math
from pathlib import Path
import struct
import sys

from arm64 import CPU, require
from feed_runtime import Runtime, fixture, put_frame

ROOT = Path(__file__).resolve().parents[1]
sys.path.insert(0, str(ROOT / 'repair162'))
from macho_tools import assemble_object, sections

LABELS = ['LFbegin', 'LFconsider', 'LFend', 'LFrestore', 'LFapply_row',
          'LFrestore_row', 'LFrecords_key', 'LFnext_key', 'LFwatch', 'LFfeed_layout',
          'LFbusy_key', 'LFowner_key', 'LFwatched_key', 'Lbusy_key',
          'LForphan_key', 'LFrestore_orphan', 'Lfind_scroll', 'Lcode_end', 'LXcode_end']


def labels_for(data, composed, extra_labels=()):
    source = composed.read_text()
    requested = LABELS + list(extra_labels)
    appendix = '\n.p2align 2\n' + '\n'.join('.long ' + x + ' - Lpatch' for x in requested) + '\n'
    obj = assemble_object(source + appendix)
    text = [s for s in sections(obj) if s['name'] == '__text']
    require(len(text) == 1 and text[0]['reloc_count'] == 0,
            'Audit label recovery has no unresolved relocations')
    s = text[0]
    payload = obj[s['offset']:s['offset'] + s['size']]
    words = struct.unpack_from('<64I', data, 0x800)
    require(words[6] in (0x10508, 0x10509, 0x10602, 0x10603, 0x10604,0x10605,0x10606,0x10607,0x10701,0x10702,0x10703,0x10704), 'Known feed payload directory')
    for start, stop in ((0x800, 0x800 + words[55]),
                        (0x800 + words[4], 0x800 + words[5]),
                        (0x800 + words[60], 0x800 + words[63])):
        require(data[start:stop] == payload[start - 0x800:stop - 0x800],
                'Candidate bytes match composed source at ' + hex(start))
    table = struct.unpack_from('<' + str(len(requested)) + 'I', payload,
                               len(payload) - 4 * len(requested))
    return {name: value + 0x800 for name, value in zip(requested, table)}


def make(data, entries, slide=0):
    rt = Runtime(data, slide)
    cpu = CPU(data, rt, slide, ranges=[(0x900, entries['Lcode_end']),
                                      (0x14080, entries['LXcode_end']),
                                      (0x4878, 0x48d0),
                                      (0x7394, 0x746c)])
    cpu.pointers.update(rt.rebase_pointers)
    return cpu, rt


def run(cpu, entries, label, *args):
    return cpu.run(entries[label], args=args, max_steps=1000000)


def records(rt, entries):
    value = rt.associations.get((rt.BAR, rt.slide + entries['LFrecords_key']), 0)
    return rt.objects[value].state['items'] if value else []


def update(cpu, rt, entries, feed):
    run(cpu, entries, 'LFbegin', rt.BAR)
    result = run(cpu, entries, 'LFconsider', feed, rt.BAR)['result']
    run(cpu, entries, 'LFend', rt.BAR)
    return result


def baseline(rt, f):
    return {name: {key: rt.objects[f[name]].state.get(key)
                   for key in ('frame', 'bounds', 'contentInset', 'clipsToBounds')}
            for name in ('feed', 'outer', 'cell', 'container')}


def require_state(rt, f, before, why):
    require(baseline(rt, f) == before, why)


def real_log_cases(data, entries):
    cases = []
    for name, tab, inner, outer, outer_offset, inner_offset in (
        ('profile_seq381', 3, 776, 850, 313, 6527),
        ('shelf_seq306', 2, 784, 858, 597.6666666666666, 4125),
    ):
        for slide in (0, 0x180000000):
            cpu, rt = make(data, entries, slide)
            f = fixture(rt, tab=tab, inner_height=inner, outer_height=outer,
                        outer_offset=outer_offset, inner_offset=inner_offset)
            before = baseline(rt, f)
            require(update(cpu, rt, entries, f['feed']) == 1, 'Known logged nested feed claimed')
            st = rt.objects[f['feed']].state
            require(st['frame'] == (0, 0, 440, 850), 'Viewport reaches actual window bottom')
            require(st['bounds'][:2] == (0, inner_offset), 'Reading/scroll position preserved')
            require(st['contentInset'] == (3, 4, 5 + 850 - inner, 6),
                    'Only bottom inset grows by the viewport extension')
            require(st['clipsToBounds'], 'Feed still clips its top and sides')
            require(rt.objects[f['outer']].state['clipsToBounds'], 'Outer viewport clipping retained')
            require(not rt.objects[f['cell']].state['clipsToBounds'] and
                    not rt.objects[f['container']].state['clipsToBounds'],
                    'Intermediate clipping cannot cut the extension off')
            old_max = 9621 - inner + 5
            new_max = 9621 - st['frame'][3] + st['contentInset'][2]
            require(old_max == new_max, 'Last-item scroll range is preserved exactly')
            for _ in range(15):
                start = len(rt.events)
                require(update(cpu, rt, entries, f['feed']) == 1, 'Repeat remains owned')
                require(not any(e['event'] in ('setFrame', 'contentInset', 'contentOffset',
                                               'clipsToBounds') for e in rt.events[start:]),
                        'Stable repeated update issues no geometry/offset/clip setters')
            require(len(records(rt, entries)) == 1, 'One bounded ownership record')
            run(cpu, entries, 'LFrestore', rt.BAR)
            require_state(rt, f, before, 'Disable restores original height/insets/clipping')
            require(not records(rt, entries), 'Disable clears owned records')
            cases.append({'name': name, 'slide': hex(slide), 'extension': 850-inner,
                          'instructions': cpu.steps, 'passed': True})
    return cases


def rejected_cases(data, entries):
    cases = []
    names = ('bookstore_tab', 'drama_tab', 'other_class', 'unrelated_subclass', 'hidden_feed',
             'hidden_ancestor', 'zero_alpha_ancestor', 'different_window', 'proxy_hidden',
             'proxy_detached', 'bar_not_bottom', 'root_feed', 'horizontal_page',
             'tiny_feed', 'non_scroll_content', 'outer_too_short', 'large_height_gap',
             'already_full_viewport', 'feed_scaled', 'ancestor_rotated', 'ancestor_mask',
             'rounded_parent', 'control_parent', 'effect_parent', 'web_parent',
             'small_parent', 'too_deep', 'nan_height', 'infinite_inset')
    names += ('partially_visible_feed',)
    for name in names:
        cpu, rt = make(data, entries)
        f = fixture(rt)
        feed, cell, container, outer = (f[k] for k in ('feed', 'cell', 'container', 'outer'))
        if name == 'bookstore_tab': rt.objects[rt.BAR].state['selectedItem'] = f['items'][0]
        elif name == 'drama_tab': rt.objects[rt.BAR].state['selectedItem'] = f['items'][1]
        elif name == 'other_class': rt.objects[feed].cls = rt.classes['UICollectionView']
        elif name == 'unrelated_subclass': rt.objects[feed].cls = rt._class('UnrelatedFeed', 'UICollectionView')
        elif name == 'hidden_feed': rt.objects[feed].state['hidden'] = True
        elif name == 'hidden_ancestor': rt.objects[container].state['hidden'] = True
        elif name == 'zero_alpha_ancestor': rt.objects[container].state['alpha'] = 0
        elif name == 'different_window':
            window = rt.view('UIWindow', 'other_window', (0, 0, 440, 956))
            rt.reparent(outer, window)
        elif name == 'proxy_hidden': rt.objects[rt.PROXY].state['hidden'] = True
        elif name == 'proxy_detached': rt.reparent(rt.PROXY, rt.ROOT)
        elif name == 'bar_not_bottom': put_frame(rt, rt.BAR, (0, 800, 440, 74))
        elif name == 'root_feed': rt.reparent(feed, rt.ROOT)
        elif name == 'horizontal_page': put_frame(rt, container, (440, 0, 440, 776))
        elif name == 'tiny_feed': put_frame(rt, feed, (0, 0, 440, 100))
        elif name == 'non_scroll_content': rt.objects[feed].state['contentSize'] = (440, 776)
        elif name == 'outer_too_short': put_frame(rt, outer, (0, 106, 440, 776))
        elif name == 'large_height_gap':
            for p in (feed, cell, container):
                s = rt.objects[p].state
                put_frame(rt, p, (*s['frame'][:3], 600))
        elif name == 'already_full_viewport': put_frame(rt, feed, (0, 0, 440, 850))
        elif name == 'feed_scaled': rt.objects[feed].state['transform'] = (2, 0, 0, 2, 0, 0)
        elif name == 'ancestor_rotated': rt.objects[cell].state['transform'] = (-1, 0, 0, -1, 0, 0)
        elif name == 'ancestor_mask': rt.objects[rt.layer(container)].state['mask'] = 0x1234
        elif name == 'rounded_parent': rt.objects[rt.layer(container)].state['cornerRadius'] = 12
        elif name == 'control_parent': rt.objects[container].cls = rt.classes['UIControl']
        elif name == 'effect_parent': rt.objects[container].cls = rt.classes['UIVisualEffectView']
        elif name == 'web_parent': rt.objects[container].cls = rt.classes['WKWebView']
        elif name == 'small_parent': put_frame(rt, container, (0, 0, 440, 200))
        elif name == 'too_deep':
            parent = container
            for i in range(10): parent = rt.view('UIView', 'deep'+str(i), (0, 0, 440, 776), parent)
            rt.reparent(feed, parent)
        elif name == 'nan_height': put_frame(rt, feed, (0, 0, 440, math.nan))
        elif name == 'infinite_inset': rt.objects[feed].state['contentInset'] = (0, 0, math.inf, 0)
        elif name == 'partially_visible_feed':
            rt.objects[outer].state['bounds'] = (0, 0, 440, 850)
        before = baseline(rt, f)
        require(update(cpu, rt, entries, feed) == 0, 'Unsafe/unrelated feed rejected: ' + name)
        # NaN compares unequal to itself; compare the actual absence of writes.
        require(not any(e['event'] in ('setFrame', 'contentInset', 'contentOffset',
                                      'clipsToBounds') for e in rt.events),
                'Rejected case performs no host mutation: ' + name)
        require(not records(rt, entries), 'Rejected case never claims ownership')
        cases.append({'name': name, 'instructions': cpu.steps, 'passed': True})
    return cases


def host_changes(data, entries):
    cases = []
    for name in ('host_relayout', 'host_new_height', 'host_new_inset', 'host_origin_move',
                 'hidden_after_claim', 'switch_to_bookstore', 'empty_discovery',
                 'two_matching_feeds', 'offset_adjustment', 'original_unclipped',
                 'scroll_back_to_header'):
        cpu, rt = make(data, entries)
        f = fixture(rt, clip=name != 'original_unclipped')
        feed = f['feed']
        before = baseline(rt, f)
        rt.adjust_offsets = name == 'offset_adjustment'
        require(update(cpu, rt, entries, feed) == 1, 'Initial ownership')
        if name == 'host_relayout':
            put_frame(rt, feed, (0, 0, 440, 776))
            require(update(cpu, rt, entries, feed) == 1, 'Host base-height relayout reapplied')
            require(rt.objects[feed].state['contentInset'][2] == 79, 'No repeated inset addition')
        elif name == 'host_new_height':
            put_frame(rt, feed, (0, 0, 440, 780))
            for name_key in ('cell', 'container'):
                state = rt.objects[f[name_key]].state
                put_frame(rt, f[name_key], (*state['frame'][:3], 780))
                before[name_key]['frame'] = state['frame']
                before[name_key]['bounds'] = state['bounds']
            require(update(cpu, rt, entries, feed) == 1, 'New valid host base height respected')
            require(rt.objects[feed].state['contentInset'][2] == 75, 'Inset uses new 70pt deficit')
            before['feed']['frame'] = (0, 0, 440, 780)
            before['feed']['bounds'] = (*before['feed']['bounds'][:2], 440, 780)
        elif name == 'host_new_inset':
            rt.objects[feed].state['contentInset'] = (13, 14, 29, 16)
            require(update(cpu, rt, entries, feed) == 1, 'New host bottom inset becomes baseline')
            require(rt.objects[feed].state['contentInset'] == (13, 14, 103, 16),
                    'Top/side host inset changes are retained')
            before['feed']['contentInset'] = (13, 14, 29, 16)
        elif name == 'host_origin_move':
            put_frame(rt, feed, (0, 5, 440, 850))
            before['feed']['frame'] = (0, 5, 440, 776)
        elif name == 'hidden_after_claim':
            rt.objects[feed].state['hidden'] = True
            require(update(cpu, rt, entries, feed) == 0, 'No repair through hidden page')
        elif name == 'switch_to_bookstore':
            rt.objects[rt.BAR].state['selectedItem'] = f['items'][0]
            require(update(cpu, rt, entries, feed) == 0, 'Changing tab retires ownership')
        elif name == 'empty_discovery':
            run(cpu, entries, 'LFbegin', rt.BAR)
            run(cpu, entries, 'LFend', rt.BAR)
        elif name == 'scroll_back_to_header':
            rt.objects[f['outer']].state['bounds'] = (0, 0, 440, 850)
            before['outer']['bounds'] = (0, 0, 440, 850)
            require(update(cpu, rt, entries, feed) == 0,
                    'Unpinned feed restores original geometry while outer position is retained')
        elif name == 'two_matching_feeds':
            other = rt.view('FQFeedListCollectionView', 'second_feed', (0, 0, 440, 776),
                            f['container'], contentSize=(440, 9999))
            run(cpu, entries, 'LFbegin', rt.BAR)
            run(cpu, entries, 'LFconsider', feed, rt.BAR)
            require(run(cpu, entries, 'LFconsider', other, rt.BAR)['result'] == 0,
                    'Second candidate cannot share the same clip ownership')
            run(cpu, entries, 'LFend', rt.BAR)
            require(rt.objects[other].state['frame'][3] == 776, 'Second candidate untouched')
        run(cpu, entries, 'LFrestore', rt.BAR)
        require_state(rt, f, before, 'Conditional restoration: ' + name)
        cases.append({'name': name, 'instructions': cpu.steps, 'passed': True})
    # Host modifications that cease to match patch writes must survive disable.
    cpu, rt = make(data, entries)
    f = fixture(rt)
    update(cpu, rt, entries, f['feed'])
    put_frame(rt, f['feed'], (2, 7, 430, 801))
    rt.objects[f['feed']].state['contentInset'] = (10, 11, 12, 13)
    expected = baseline(rt, f)['feed']
    run(cpu, entries, 'LFrestore', rt.BAR)
    require(baseline(rt, f)['feed'] == expected, 'Later unrelated host geometry is not overwritten')
    cases.append({'name': 'later_host_writes_survive_disable', 'instructions': cpu.steps, 'passed': True})
    return cases


def layout_hook_cases(data, entries):
    cases = []
    for name in ('host_relayout_immediate', 'pinned_header_repinned',
                 'nested_host_reentry', 'independent_feed_busy', 'existing_bar_busy',
                 'proxy_hidden', 'weak_owner_expired', 'unwatched_instance',
                 'old_hidden_page_cannot_evict_new_feed'):
        cpu, rt = make(data, entries)
        f = fixture(rt)
        feed = f['feed']
        original_view_imp = rt.methods[rt.get_method(rt.UIView, rt.sel('layoutSubviews'))]['imp']
        update(cpu, rt, entries, feed)
        require(rt.methods[rt.get_method(rt.UIView, rt.sel('layoutSubviews'))]['imp'] == original_view_imp,
                'Superclass UIView layout implementation is never replaced')
        method = rt.get_method(rt.objects[feed].cls, rt.sel('layoutSubviews'))
        require(rt.methods[method]['imp'] == entries['LFfeed_layout'],
                'Only the exact FQ feed class has the repair post-hook')
        busy_feed = (feed, entries['LFbusy_key'])
        busy_bar = (rt.BAR, entries['Lbusy_key'])
        owner_key = (feed, entries['LFowner_key'])
        owner_box = rt.associations[owner_key]
        require(rt.objects[owner_box].state['items'] == [rt.BAR], 'Feed owner is a weak table')
        watched = rt.associations[(rt.BAR, entries['LFwatched_key'])]
        require(rt.objects[watched].state['items'] == [feed], 'Bar observes feed through a weak table')
        callbacks = {'count': 0, 'nested': False}

        def mutate(runtime, receiver):
            if receiver != feed:
                return
            callbacks['count'] += 1
            put_frame(runtime, receiver, (0, 0, 440, 776))
            if name == 'nested_host_reentry' and not callbacks['nested']:
                callbacks['nested'] = True
                runtime.invoke(cpu, receiver, runtime.sel('layoutSubviews'))

        rt.layout_mutator = mutate
        if name == 'independent_feed_busy': rt.associations[busy_feed] = feed
        elif name == 'existing_bar_busy': rt.associations[busy_bar] = rt.BAR
        elif name == 'proxy_hidden': rt.objects[rt.PROXY].state['hidden'] = True
        elif name == 'weak_owner_expired': rt.objects[owner_box].state['items'] = []
        elif name == 'unwatched_instance':
            other = rt.view('FQFeedListCollectionView', 'unwatched', (0, 0, 440, 776), f['container'])
            before_other = dict(rt.objects[other].state)
            start = len(rt.events)
            rt.invoke(cpu, other, rt.sel('layoutSubviews'))
            require(rt.objects[other].state == before_other, 'Unwatched instance keeps host geometry')
            require(sum(e['event'] == 'original_layout' for e in rt.events[start:]) == 1,
                    'Unwatched inherited hook only forwards to original')
        elif name == 'old_hidden_page_cannot_evict_new_feed':
            rt.objects[f['outer']].state['hidden'] = True
            new_fixture = fixture(rt, tab=2, inner_height=784, outer_height=858,
                                  outer_offset=597.6666666666666, inner_offset=4125)
            require(update(cpu, rt, entries, new_fixture['feed']) == 1, 'Next page owns its own feed')
            current = records(rt, entries)[:]
            rt.invoke(cpu, feed, rt.sel('layoutSubviews'))
            require(records(rt, entries) == current and
                    rt.objects[new_fixture['feed']].state['frame'][3] == 850,
                    'Callback from hidden old page cannot restore/replace current page record')
        start = len(rt.events)
        start_steps = cpu.steps
        rt.invoke(cpu, feed, rt.sel('layoutSubviews'))
        original_events = [e for e in rt.events[start:] if e['event'] == 'original_layout']
        expected_calls = 2 if name == 'nested_host_reentry' else 1
        require(len(original_events) == expected_calls, 'Original IMP invoked once per actual host callback')
        require(all(e['selector'] == rt.sel('layoutSubviews') for e in original_events),
                'Saved IMP receives original layoutSubviews _cmd, never the alias')
        require(entries['Lfind_scroll'] not in cpu.executed, 'Post-hook performs no full-tree traversal')
        if name in ('independent_feed_busy', 'existing_bar_busy', 'proxy_hidden',
                    'weak_owner_expired', 'old_hidden_page_cannot_evict_new_feed'):
            require(rt.objects[feed].state['frame'][3] == 776, 'Ineligible/busy callback remains host-owned')
        else:
            require(rt.objects[feed].state['frame'][3] == 850, 'Original layout is repaired synchronously')
        if name == 'independent_feed_busy':
            require(rt.associations[busy_feed] == feed, 'An existing feed busy scope is preserved')
            rt.associations.pop(busy_feed)
        else:
            require(busy_feed not in rt.associations, 'Own hook busy scope is always cleared')
        if name == 'existing_bar_busy':
            require(rt.associations[busy_bar] == rt.BAR, 'An existing bar busy scope is preserved')
            rt.associations.pop(busy_bar)
        else:
            require(busy_bar not in rt.associations, 'Own bar busy scope is always cleared')
        if name == 'pinned_header_repinned':
            rt.objects[f['outer']].state['bounds'] = (0, 0, 440, 850)
            rt.invoke(cpu, feed, rt.sel('layoutSubviews'))
            require(not records(rt, entries) and rt.objects[feed].state['frame'][3] == 776,
                    'Unpinned feed restores immediately')
            require(rt.objects[feed].state['contentInset'][2] == 5,
                    'Header return removes temporary scroll padding')
            require(owner_key in rt.associations, 'Weak observation remains for a future pin')
            rt.objects[f['outer']].state['bounds'] = (0, 313, 440, 850)
            rt.invoke(cpu, feed, rt.sel('layoutSubviews'))
            require(rt.objects[feed].state['frame'][3] == 850 and records(rt, entries),
                    'Repinning repairs on the same layout callback without polling')
        if name == 'weak_owner_expired':
            require(rt.objects[feed].state['contentInset'] == (3, 4, 5, 6),
                    'Owner loss restores plugin-owned bottom padding')
            require(rt.objects[f['cell']].state['clipsToBounds'] and
                    rt.objects[f['container']].state['clipsToBounds'],
                    'Owner loss restores surviving intermediate clips')
            require(owner_key not in rt.associations and
                    (feed, entries['LForphan_key']) not in rt.associations,
                    'Owner loss consumes scalar/weak recovery metadata')
        run(cpu, entries, 'LFrestore', rt.BAR)
        if name != 'weak_owner_expired':
            require(owner_key not in rt.associations, 'Disable removes weak owner observation')
        require((rt.BAR, entries['LFwatched_key']) not in rt.associations,
                'Disable releases weak feed set')
        require(rt.retain_balance.get(rt.BAR, 0) == 0, 'Temporary weak-owner retain is balanced')
        cases.append({'name': name, 'callback_instructions': cpu.steps-start_steps,
                      'passed': True})
    return cases


def owner_loss_cases(data, entries):
    cases = []
    for name in ('surviving_feed', 'host_new_values', 'missing_weak_ancestor',
                 'live_owner_noop', 'no_strong_parent_cycle', 'snapshot_reused'):
        cpu, rt = make(data, entries)
        f = fixture(rt)
        feed = f['feed']
        before = baseline(rt, f)
        update(cpu, rt, entries, feed)
        recovery_key = (feed, entries['LForphan_key'])
        recovery = rt.associations[recovery_key]
        recovery_parts = rt.objects[recovery].state['items']
        require(len(recovery_parts) == 2, 'Recovery stores only scalar data and weak rows')
        require(rt.objects[recovery_parts[0]].state.get('value') and
                len(rt.objects[recovery_parts[0]].state['value']) == 48,
                'Recovery scalars contain no native object pointers')
        weak_rows = rt.objects[recovery_parts[1]].state['items']
        for row in weak_rows:
            box, original = rt.objects[row].state['items']
            require(rt.class_names[rt.objects[box].cls] == 'NSHashTable' and
                    rt.class_names[rt.objects[original].cls] == 'NSNumber',
                    'Recovery retains neither feed nor ancestor views directly')
        if name == 'snapshot_reused':
            update(cpu, rt, entries, feed)
            require(rt.associations[recovery_key] == recovery,
                    'Unchanged layout reuses its existing weak recovery snapshot')
        if name == 'live_owner_noop':
            expected = baseline(rt, f)
            run(cpu, entries, 'LFrestore_orphan', feed)
            require_state(rt, f, expected, 'Live owner prevents orphan restoration')
            require(rt.associations[recovery_key] == recovery, 'Live owner keeps recovery metadata')
        else:
            box = rt.associations[(feed, entries['LFowner_key'])]
            rt.objects[box].state['items'] = []
            if name == 'host_new_values':
                put_frame(rt, feed, (8, 3, 431, 801))
                rt.objects[feed].state['contentInset'] = (13, 14, 18, 16)
                before['feed'] = baseline(rt, f)['feed']
            elif name == 'missing_weak_ancestor':
                first_box = rt.objects[weak_rows[0]].state['items'][0]
                gone = rt.objects[first_box].state['items'][0]
                rt.objects[first_box].state['items'] = []
                # A nil weak target must be skipped, not messaged or fabricated.
                for label in ('cell', 'container'):
                    if f[label] == gone:
                        before[label]['clipsToBounds'] = False
            run(cpu, entries, 'LFrestore_orphan', feed)
            require_state(rt, f, before, 'Orphan restoration: ' + name)
            require(recovery_key not in rt.associations, 'Orphan restoration consumes recovery state')
            require((feed, entries['LFowner_key']) not in rt.associations, 'Empty owner box is released')
        run(cpu, entries, 'LFrestore', rt.BAR)
        cases.append({'name': name, 'instructions': cpu.steps, 'passed': True})
    return cases


def main():
    p = argparse.ArgumentParser(description=__doc__)
    p.add_argument('candidate', type=Path)
    p.add_argument('--report', type=Path)
    a = p.parse_args()
    data = a.candidate.read_bytes()
    entries = labels_for(data, a.candidate.with_suffix('.composed.s'))
    tests = {'supplied_log_geometry': real_log_cases(data, entries),
             'unsafe_or_unrelated_rejection': rejected_cases(data, entries),
             'idempotence_host_changes_and_restoration': host_changes(data, entries),
             'scoped_layout_hook_weak_ownership_and_reentry': layout_hook_cases(data, entries),
             'conditional_recovery_after_weak_owner_loss': owner_loss_cases(data, entries)}
    report = {'passed': True, 'candidate_sha256': hashlib.sha256(data).hexdigest(),
              'candidate_source_byte_equality': True, 'test_count': sum(map(len, tests.values())),
              'tests': tests,
              'limits': ['UIKit/Foundation are explicit boundary models, not a device run.',
                         'The intermediate parent classes are not present in the exported log;'
                         ' full-width standard and custom container fixtures are exercised.',
                         'No pixels, animation speed, dyld load, or injection acceptance were tested.']}
    out = a.report or a.candidate.with_suffix('.feed-audit.json')
    out.write_text(json.dumps(report, ensure_ascii=False, indent=2) + '\n')
    print(json.dumps({'passed': True, 'tests': report['test_count'],
                      'candidate_sha256': report['candidate_sha256'], 'report': str(out)}))


if __name__ == '__main__':
    main()
