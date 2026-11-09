#!/usr/bin/env python3
"""First-layout regressions executing emitted ARM64, including real 1.5.9 negatives.

The host invokes ordinary didMoveToWindow/layoutSubviews and may create its
scroll content after a tab's initial scan. There is deliberately no timer fire,
main repair call, or view-tree rescan between creation/data load and assertions.
UIKit/Objective-C are boundary models, so this is not a device pixel/latency test.
"""
import argparse
import hashlib
import importlib.util
import json
from pathlib import Path
import struct

from arm64 import CPU, require
from feed_runtime import fixture, put_frame
from test_feed_realistic159 import HostSubclassRuntime
from test_feed_viewport import labels_for, run, update, records

ROOT = Path(__file__).resolve().parents[1]
COMMON = ('Linstall', 'Ledge_update', 'Ledge_restore', 'Ledge_key', 'Lrepair')
NEW = ('LFlifecycle_install', 'LFlifecycle_register', 'LFlifecycle_unregister',
       'LFlifecycle_bar', 'LFlifecycle_edge', 'LFlifecycle_active_key',
       'LFlifecycle_bars_key', 'LFstage_key', 'LFdetail')
OLD_SHA = 'e4435d143a22e21991ae753bca5af3f2d945dd6cd6ac3ab514c71d2a5e4d0810'
HOST_CLASSES = ('SSNestedContainerScrollView', 'SSBookStoreUnlimitedContainerView')


def machine(data, entries, slide=0, inherited_bookstore=False):
    rt = HostSubclassRuntime(data, slide)
    rt._class(HOST_CLASSES[0], 'UIScrollView')
    rt._class(HOST_CLASSES[1], HOST_CLASSES[0] if inherited_bookstore else 'UIScrollView')
    cpu = CPU(data, rt, slide, ranges=[(0x900, entries['Lcode_end']),
                                    (0x14080, entries['LXcode_end']),
                                    (0x4878, 0x48d0), (0x7394, 0x746c)])
    cpu.pointers.update(rt.rebase_pointers)
    return cpu, rt


def invoke(rt, cpu, view, selector='layoutSubviews'):
    cpu.executed.clear()
    return rt.invoke(cpu, view, rt.sel(selector))


def no_rescan(cpu, entries):
    require(entries['Lrepair'] not in cpu.executed and
            entries['Lfind_scroll'] not in cpu.executed,
            'First-layout repair does not invoke the whole-tree repair/discovery')


def edge_rows(rt, entries):
    pointer = rt.associations.get((rt.BAR, rt.slide + entries['Ledge_key']), 0)
    return rt.objects[pointer].state['items'] if pointer else []


def late_scroll(rt, cls, *, hidden=False, content=2200, original_hidden=False):
    root = rt.objects[rt.ROOT].state['bounds']
    v = rt.view(cls, 'late.' + cls, (0, 0, root[2], root[3]), rt.ROOT,
                contentSize=(root[2], content), hidden=hidden)
    edge = rt.obj('UIScrollEdgeEffect', 'late.edge.' + cls, hidden=original_hidden)
    rt.objects[v].state['bottomEdgeEffect'] = edge
    return v, edge


def old_negatives(data, entries):
    out = []
    cpu, rt = machine(data, entries)
    f = fixture(rt)
    feed = f['feed']
    rt.objects[feed].state['contentSize'] = (440, 0)
    require(update(cpu, rt, entries, feed) == 0, '1.5.9 empty content is declined')
    method = rt.get_method(rt.objects[feed].cls, rt.sel('layoutSubviews'))
    require(rt.methods[method]['imp'] == rt.LAYOUT_IMP,
            '1.5.9 never installs the feed observer while content is empty')
    rt.objects[feed].state['contentSize'] = (440, 9621)
    invoke(rt, cpu, feed)
    require(rt.objects[feed].state['frame'][3] == 776 and not records(rt, entries),
            'Actual 1.5.9 leaves the newly loaded feed short until another discovery')
    out.append({'name': '159_empty_feed_then_loaded_layout', 'old_result': 'still_short',
                'passed': True})
    for cls in HOST_CLASSES:
        cpu, rt = machine(data, entries)
        run(cpu, entries, 'Linstall')
        run(cpu, entries, 'Ledge_update', rt.BAR, rt.PROXY)
        scroll, edge = late_scroll(rt, cls)
        invoke(rt, cpu, scroll, 'didMoveToWindow')
        invoke(rt, cpu, scroll)
        require(not rt.objects[edge].state['hidden'],
                '1.5.9 late bookstore edge remains visible after first real callbacks')
        out.append({'name': '159_late_' + cls, 'old_result': 'edge_unmanaged',
                    'passed': True})
    return out


def initial_feed_cases(data, entries):
    out = []
    for name in ('empty_then_loaded', 'first_attach_no_scan', 'early_bar_frame',
                 'runtime_after_super', 'runtime_no_super', 'nonzero_slide'):
        slide = 0x180000000 if name == 'nonzero_slide' else 0
        cpu, rt = machine(data, entries, slide)
        run(cpu, entries, 'Linstall')
        run(cpu, entries, 'LFlifecycle_register', rt.BAR)
        f = fixture(rt, tab=2, inner_height=784, outer_height=858)
        feed = f['feed']; st = rt.objects[feed].state
        if name in ('runtime_after_super', 'runtime_no_super'):
            cls, _ = rt.override('LateRuntimeFeed', height=784,
                                 call_super=name != 'runtime_no_super')
            rt.objects[feed].cls = cls
        if name in ('empty_then_loaded', 'early_bar_frame'):
            st['contentSize'] = (440, 0)
        if name == 'early_bar_frame':
            put_frame(rt, rt.BAR, (-220, -37, 440, 74))
        if name == 'empty_then_loaded':
            require(update(cpu, rt, entries, feed) == 0,
                    'Empty content still performs no geometry mutation')
        else:
            invoke(rt, cpu, feed, 'didMoveToWindow')
            no_rescan(cpu, entries)
        if name in ('empty_then_loaded', 'early_bar_frame'):
            require(st['frame'][3] == 784 and not records(rt, entries),
                    'Unready content/frame does not bypass geometry validation')
            st['contentSize'] = (440, 9621)
            put_frame(rt, rt.BAR, (0, 882, 440, 74))
        invoke(rt, cpu, feed)
        no_rescan(cpu, entries)
        require(st['frame'][3] == 850 and st['contentInset'][2] == 71,
                'First eligible callback ends with full-height viewport and exact inset compensation')
        require(len(records(rt, entries)) == 1, 'Exactly one feed geometry record')
        require((feed, slide + entries['LFbusy_key']) not in rt.associations and
                (rt.BAR, slide + entries['Lbusy_key']) not in rt.associations,
                'Callback clears both instance and bar reentry guards')
        run(cpu, entries, 'LFrestore', rt.BAR)
        require(st['frame'][3] == 784 and st['contentInset'][2] == 5,
                'First-frame ownership is fully reversible')
        diagnostic = run(cpu, entries, 'LFdetail', feed, rt.BAR)['result']
        detail = rt.native(diagnostic)
        require(detail['currentlyOwned'] == 0 and
                detail['decision'] == 'previously-applied-now-unowned',
                'A historical applied decision cannot masquerade as current ownership')
        out.append({'name': name, 'passed': True, 'slide': hex(slide)})
    return out


def bookstore_cases(data, entries):
    out = []
    for cls in HOST_CLASSES:
        for name in ('late_first_layout', 'empty_then_loaded', 'host_reopens_edge',
                     'edge_replaced', 'hidden_then_visible', 'host_original_hidden',
                     'disable_then_layout', 'runtime_after_super', 'lexical_inheritance'):
            inherited = name == 'lexical_inheritance'
            cpu, rt = machine(data, entries, inherited_bookstore=inherited)
            run(cpu, entries, 'Linstall')
            run(cpu, entries, 'LFlifecycle_register', rt.BAR)
            scroll, edge = late_scroll(rt, cls,
                                      hidden=name == 'hidden_then_visible',
                                      content=0 if name == 'empty_then_loaded' else 2200,
                                      original_hidden=name == 'host_original_hidden')
            if name == 'runtime_after_super':
                runtime_cls, _ = rt.override('LateBookstoreRuntime', parent=cls, height=None)
                rt.objects[scroll].cls = runtime_cls
            before = len(rt.events)
            invoke(rt, cpu, scroll, 'didMoveToWindow')
            no_rescan(cpu, entries)
            require(sum(e['event'] == 'original_window' for e in rt.events[before:]) == 1,
                    'Each lexical original window callback executes exactly once')
            if name in ('empty_then_loaded', 'hidden_then_visible'):
                require(not rt.objects[edge].state['hidden'],
                        'Unready or hidden content is not suppressed by startup observation')
                rt.objects[scroll].state.update(hidden=False, contentSize=(390, 2200))
            invoke(rt, cpu, scroll)
            no_rescan(cpu, entries)
            require(rt.objects[edge].state['hidden'], 'Late bookstore edge hidden within first eligible callback')
            require(len(edge_rows(rt, entries)) == 1, 'No duplicate edge records')
            if name == 'host_reopens_edge':
                rt.objects[edge].state['hidden'] = False
                invoke(rt, cpu, scroll)
                require(rt.objects[edge].state['hidden'], 'Host edge reset repaired synchronously')
            elif name == 'edge_replaced':
                replacement = rt.obj('UIScrollEdgeEffect', 'replacement', hidden=False)
                rt.objects[scroll].state['bottomEdgeEffect'] = replacement
                invoke(rt, cpu, scroll)
                require(not rt.objects[edge].state['hidden'] and
                        rt.objects[replacement].state['hidden'],
                        'Old edge original visibility restored before new ownership is retained')
                require(len(edge_rows(rt, entries)) == 1, 'Edge identity changes do not leak rows')
                edge = replacement
            elif name == 'disable_then_layout':
                run(cpu, entries, 'LFlifecycle_unregister', rt.BAR)
                run(cpu, entries, 'Ledge_restore', rt.BAR)
                invoke(rt, cpu, scroll)
                require(not rt.objects[edge].state['hidden'] and not edge_rows(rt, entries),
                        'Disabled bar cannot be rediscovered by eager class observers')
            if name != 'disable_then_layout':
                start = len(rt.events)
                for _ in range(3):
                    invoke(rt, cpu, scroll)
                    no_rescan(cpu, entries)
                require(not any(e['event'] in ('setFrame', 'contentInset', 'contentOffset',
                                               'clipsToBounds', 'setHidden')
                                for e in rt.events[start:]),
                        'Stable callbacks issue no geometry or visibility writes')
                run(cpu, entries, 'LFlifecycle_unregister', rt.BAR)
                run(cpu, entries, 'Ledge_restore', rt.BAR)
                require(rt.objects[edge].state['hidden'] == (name == 'host_original_hidden'),
                        'Disable returns each edge to its own original hidden state')
            out.append({'class': cls, 'name': name, 'passed': True})
    return out


def scope_and_safety_cases(data, entries):
    out = []
    for name in ('other_window', 'proxy_hidden', 'bar_hidden', 'horizontal_offscreen',
                 'small_carousel', 'ambiguous_bars', 'unrelated_scroll_class',
                 'original_abi_unchanged', 'foreign_layout_encoding', 'bar_reentry',
                 'no_parent_retention', 'two_scrolls_independent'):
        cpu, rt = machine(data, entries)
        if name == 'foreign_layout_encoding':
            rt._add(rt.classes[HOST_CLASSES[0]], 'layoutSubviews', rt.LAYOUT_IMP, 'B@:')
        run(cpu, entries, 'Linstall')
        run(cpu, entries, 'LFlifecycle_register', rt.BAR)
        cls = 'UIScrollView' if name == 'unrelated_scroll_class' else HOST_CLASSES[0]
        scroll, edge = late_scroll(rt, cls)
        if name == 'other_window':
            other = rt.view('UIWindow', 'another_window', (0, 0, 390, 844))
            rt.reparent(scroll, other)
        elif name == 'proxy_hidden': rt.objects[rt.PROXY].state['hidden'] = True
        elif name == 'bar_hidden': rt.objects[rt.BAR].state['hidden'] = True
        elif name == 'horizontal_offscreen': put_frame(rt, scroll, (390, 0, 390, 844))
        elif name == 'small_carousel': put_frame(rt, scroll, (0, 650, 120, 100))
        elif name == 'ambiguous_bars':
            bar2 = rt.view('SSTabBar', 'second_bar', (0, 754, 390, 90), rt.ROOT)
            proxy2 = rt.view('UIVisualEffectView', 'second_proxy', (12, 0, 366, 56), bar2)
            rt.associations[(bar2, 0xeb84)] = proxy2
            run(cpu, entries, 'LFlifecycle_register', bar2)
        elif name == 'bar_reentry':
            rt.associations[(rt.BAR, entries['Lbusy_key'])] = rt.BAR
        if name == 'original_abi_unchanged':
            for base in ('UIView', 'UIScrollView'):
                for selector, imp in (('layoutSubviews', rt.LAYOUT_IMP),
                                      ('didMoveToWindow', rt.WINDOW_IMP)):
                    m = rt.get_method(rt.classes[base], rt.sel(selector))
                    require(rt.methods[m]['imp'] == imp, 'No UIKit base class method is replaced')
        before = len(rt.events)
        invoke(rt, cpu, scroll)
        no_rescan(cpu, entries)
        accepted = name in ('original_abi_unchanged', 'no_parent_retention',
                            'two_scrolls_independent')
        require(rt.objects[edge].state['hidden'] == accepted,
                'Scope/visibility/ABI guards preserved: ' + name)
        require(sum(e['event'] == 'original_layout' for e in rt.events[before:]) == 1,
                'Guard rejection still invokes original host layout exactly once')
        if name == 'no_parent_retention':
            weak = rt.associations[(rt.classes['SSTabBar'], entries['LFlifecycle_bars_key'])]
            require(rt.class_names[rt.objects[weak].cls] == 'NSHashTable', 'Registry is a weak table')
            require(rt.ROOT not in rt.objects[weak].state['items'] and
                    rt.retain_balance.get(rt.BAR, 0) == 0,
                    'No strong parent/controller/bar reference is added by lifecycle callbacks')
        if name == 'two_scrolls_independent':
            second, edge2 = late_scroll(rt, HOST_CLASSES[1])
            invoke(rt, cpu, second)
            require(len(edge_rows(rt, entries)) == 2 and rt.objects[edge2].state['hidden'],
                    'Nested bookstore scrolls retain independent restoration records')
            rt.objects[scroll].state['hidden'] = True
            invoke(rt, cpu, scroll)
            require(not rt.objects[edge].state['hidden'] and
                    rt.objects[edge2].state['hidden'] and len(edge_rows(rt, entries)) == 1,
                    'Retiring one scroll does not restore another visible scroll')
        out.append({'name': name, 'passed': True})
    return out


def main():
    p = argparse.ArgumentParser(description=__doc__)
    p.add_argument('candidate', type=Path)
    p.add_argument('--baseline', type=Path, default=ROOT/'dist/1.5.9/FanqieAdBlock-1.5.9.dylib')
    p.add_argument('--report', type=Path)
    a = p.parse_args()
    data, old = a.candidate.read_bytes(), a.baseline.read_bytes()
    require(hashlib.sha256(old).hexdigest() == OLD_SHA, 'Negative baseline is uploaded 1.5.9')
    require(struct.unpack_from('<I', data, 0x818)[0] in (0x10602, 0x10603, 0x10604,0x10605,0x10606,0x10607,0x10700),
            'Known first-frame candidate version')
    # Baseline composition belongs to the baseline builder. Import it by its
    # explicit path under a unique module name: the candidate builder may
    # already occupy sys.modules['build_plugin'] and add components absent in
    # repair159. The recovered labels are still checked against actual bytes.
    baseline_spec = importlib.util.spec_from_file_location(
        '_first_frame_repair159_build_plugin', ROOT/'repair159/build_plugin.py')
    require(baseline_spec is not None and baseline_spec.loader is not None,
            'Pinned 1.5.9 baseline builder is loadable')
    baseline_builder = importlib.util.module_from_spec(baseline_spec)
    baseline_spec.loader.exec_module(baseline_builder)
    old_composed = a.candidate.parent/'negative159-first-frame.composed.s'
    old_composed.write_text(baseline_builder.compose_assembly(ROOT/'repair159/floating_bar_159.s'))
    old_entries = labels_for(old, old_composed, COMMON)
    entries = labels_for(data, a.candidate.with_suffix('.composed.s'), COMMON + NEW)
    groups = {'actual_159_negative_controls': old_negatives(old, old_entries),
              'feed_first_callbacks': initial_feed_cases(data, entries),
              'bookstore_late_content': bookstore_cases(data, entries),
              'scope_restore_and_reentry': scope_and_safety_cases(data, entries)}
    report = {'passed': True, 'candidate_sha256': hashlib.sha256(data).hexdigest(),
              'baseline_sha256': OLD_SHA, 'test_count': sum(map(len, groups.values())),
              'tests': groups, 'candidate_source_byte_equality': True,
              'baseline_source_byte_equality': True, 'device_ui_tested': False,
              'limits': ['Executes actual ARM64 against modeled UIKit/Foundation/host boundaries.',
                         'No native UIKit frame scheduling, CoreAnimation composition, physical iPhone, or injection acceptance was tested.',
                         'Old negative controls prove missing synchronous coverage, not exact wall-clock visible flash duration.']}
    target = a.report or a.candidate.with_suffix('.first-frame160.json')
    target.write_text(json.dumps(report, ensure_ascii=False, indent=2)+'\n')
    print(json.dumps({'passed': True, 'tests': report['test_count'],
                      'candidate_sha256': report['candidate_sha256'], 'report': str(target)}))


if __name__ == '__main__':
    main()
