#!/usr/bin/env python3
"""Execute the 1.6.2 reader-original contract against the actual ARM64 bytes.

1.6.0 intentionally styled these controls. Its fixed release binary is a
negative control for the new requirement, not a reference to redefine as a
passing result. UIKit is a public boundary model; no rendering or real-device
touch latency is measured here.
"""
from __future__ import annotations

import argparse
from copy import deepcopy
import hashlib
import json
from pathlib import Path
import traceback

from arm64 import CPU, require
from reader_runtime import ReaderRuntime
from test_reader_fastpath import reader_back, log_records
from test_reader_native160 import (
    bottom_buttons, listen_background, menu_attachment, exclusions,
    listen_reuse, listen_orphan_owner,
)
import test_reader_native160 as retained_reader
import test_control_geometry as geometry


ROOT = Path(__file__).resolve().parents[1]
SURFACE = 0xeb8b
TOP_GETTERS = (0xbf9b, 0xbfac, 0xbfb8)
BASELINE160_SHA = '2da6826d63d5e05ec6c2f20d3375d58186474490c9c92dc09c2cc734529560b1'
RUNS = []
VISUAL_FIELDS = (
    'frame', 'bounds', 'hidden', 'alpha', 'backgroundColor', 'tintColor',
    'image', 'contentMode', 'stateImages', 'contentHorizontalAlignment',
    'contentVerticalAlignment', 'imageEdgeInsets', 'contentEdgeInsets',
    'text', 'font', 'textColor', 'target', 'action', 'control_targets',
    'accessibilityLabel', 'accessibilityIdentifier', 'userInteractionEnabled',
)


def make(data, validation, **options):
    rt = ReaderRuntime(data, **options)
    cpu = CPU(data, rt, slide=rt.slide, ranges=[
        (0x800, 0x4000), (0x4878, 0x48d0), (0x5d04, 0x5e3c),
        (0x6274, 0x62ac), (0x702c, 0x7d00), (0x80e0, 0x8258),
        (0x14000, validation['extension_directory']['code_end']),
    ])
    cpu.pointers.update(rt.rebase_pointers)
    RUNS.append((cpu, rt))
    return cpu, rt


def call(cpu, entry, *args):
    return cpu.run(entry, args=list(args), max_steps=3000000)


def surface(rt, control):
    return rt.associations.get((control, rt.slide + SURFACE), 0)


def snapshot(rt, views):
    return {v: {k: deepcopy(rt.objects[v].state.get(k)) for k in VISUAL_FIELDS}
            for v in views}


def unchanged(rt, expected):
    for view, properties in expected.items():
        actual = snapshot(rt, [view])[view]
        require(actual == properties,
                'Original host properties preserved: ' + rt.objects[view].name +
                ' changed=' + repr([k for k in properties if properties[k] != actual[k]]))


def effect_count(rt):
    return sum(rt.is_kind(p, rt.classes['UIVisualEffectView']) for p in rt.objects)


def top_buttons(data, validation, *, getter='image', slide=0, nested=False,
                owner_class='FQReaderSaasNavigationView', disabled=False):
    cpu, rt = make(data, validation, slide=slide, symbol_available=True)
    if owner_class == 'FQNavigationRuntimeSubclass':
        rt._class(owner_class, 'FQReaderSaasNavigationView')
    owner = rt.view(owner_class, 'reading_top', (0, 64, 440, 44), rt.ROOT)
    parent = owner
    if nested:
        # A recognized bottom-button wrapper does not override its location
        # inside the top bar. Wrappers exceed the old nearest-scope depth.
        for i in range(7):
            parent = rt.view('UIView', 'wrapper' + str(i), (0, 0, 440, 44), parent)
        parent = rt.view('SSReaderBottomToolButton', 'reused_control', (0, 0, 440, 44), parent)
    controls, icons = [], []
    for index, title in enumerate(('back', 'download', 'comment', 'search', 'more')):
        cls = 'SSReaderNavigationBarDownloadButton' if title == 'download' else 'UIButton'
        control = rt.view(cls, title, (8 + index*98, 10, 24, 24), parent)
        icon = rt.image_view(title + '_host_image', control, (0, 0, 24, 24), (24, 24), 0)
        original = rt.objects[icon].state['image']
        highlighted = rt.obj('UIImage', title + '_host_highlight', size=(24, 24))
        rt.objects[control].state.update(
            imageView=icon, stateImages={0: original, 1: highlighted},
            contentHorizontalAlignment=1, contentVerticalAlignment=1,
            imageEdgeInsets=(0., -6., 0., 6.), contentEdgeInsets=(0., 3., 0., 0.),
            target=0x2200+index, action=0x3300+index,
            control_targets=[(0x2200+index, rt.sel('hostTap'), 64)],
            accessibilityLabel=title, backgroundColor=rt.color('host_' + title),
        )
        controls.append(control); icons.append(icon)
    if getter != 'absent':
        rt.objects[owner].state['leftBackIconView'] = (
            icons[0] if getter == 'image' else controls[0] if getter == 'button' else 0)
    rt.objects[owner].state.update(shareButton=controls[2], moreButton=controls[4])
    bg = rt.view('UIView', 'host_navigation_background', (0, 0, 440, 44), owner)
    rt.objects[bg].state['backgroundColor'] = rt.color('host_navigation_color')
    rt.objects[owner].state['bgView'] = bg
    if disabled:
        rt.objects[rt.DEFAULTS].state['values']['FanqieAdBlock.GlassDisabled.1'] = 1
    before = snapshot(rt, [owner, parent, bg] + controls + icons)
    effects_before = effect_count(rt)
    call(cpu, validation['reader_directory']['reader_panel'], owner)
    for control in controls:
        call(cpu, 0x7848, control)
    for key in TOP_GETTERS:
        call(cpu, 0x7ac4, owner, rt.slide+key)
    # Legacy shared dispatcher mode 6 is the real story-navigation tail:
    # back/share/more plus recursive generic traversal must remain opted out.
    call(cpu, 0x78b8, owner, 6, 0)
    # Unknown glyph selectors must also be blocked without invoking a getter.
    call(cpu, 0x7ac4, owner, rt.slide+0xbf87)  # searchIcon; no getter in fixture
    for _ in range(5):
        call(cpu, validation['reader_directory']['reader_panel'], owner)
    unchanged(rt, before)
    require(not any(surface(rt, c) for c in [owner, parent, bg] + controls + icons),
            'Every top control and its background remain without plugin glass')
    require(all(not rt.associations.get((owner, rt.slide+k)) for k in TOP_GETTERS),
            'No legacy selector-keyed top glass remains')
    require(effect_count(rt) == effects_before,
            'No transient material is allocated and immediately removed on a fresh top bar')
    require(rt.symbol_requests == rt.ci_context_requests == rt.ci_render_calls == 0,
            'Original top path neither requests SF Symbols nor renders pixels')
    require(not any(e['event'] in ('layoutIfNeeded', 'add_target') for e in rt.events),
            'Top controls get no forced descendant layout or additional touch observer')
    require(any(r['data'].get('readerTopOriginalControls') == 1 for r in log_records(rt)),
            'Diagnostic reports the active original-top policy')
    return {'owner': owner_class, 'getter': getter, 'slide': hex(slide),
            'nested_wrappers': nested, 'glass_disabled': disabled,
            'controls_preserved': len(controls), 'material_allocations': 0,
            'system_symbol_requests': 0}


def actual_top_hooks(data, validation):
    cases = []
    for cls, alias, entry in (
        ('FQReaderSaasNavigationView', 'fqab_readerNav', 0x5d04),
        ('SSReaderNavigationBarDownloadButton', 'fqab_v4_reader_download_button', 0x8170),
        ('SSStoryBigNavigationBar', 'fqab_v4_story_big_nav', 0x81b8),
        ('SSStorySmallNavigationBar', 'fqab_v4_story_small_nav', 0x8208),
    ):
        cpu, rt = make(data, validation, symbol_available=True)
        owner = rt.view(cls, 'real_hook_owner', (0, 0, 440, 44), rt.ROOT)
        rt._add(rt.classes[cls], alias, rt.LAYOUT_IMP, 'v16@0:8')
        control = owner if cls == 'SSReaderNavigationBarDownloadButton' else rt.view(
            'UIButton', 'host_button', (16, 0, 44, 44), owner)
        icon = rt.image_view('host_icon', control, (10, 10, 24, 24))
        rt.objects[owner].state.update(leftBackIconView=icon, shareButton=control, moreButton=control)
        before = snapshot(rt, [owner, control, icon])
        call(cpu, entry, owner, rt.sel('layoutSubviews'))
        require(sum(e['event'] == 'original_layout' and e.get('self') == owner
                    for e in rt.events) == 1,
                'Actual hook invokes the original host layout exactly once')
        unchanged(rt, before)
        require(not surface(rt, control) and rt.symbol_requests == 0,
                'Actual hooked top layout neither decorates nor substitutes artwork')
        cases.append({'class': cls, 'entry': hex(entry), 'host_layout_calls': 1})
    return cases


def legacy_owned_cleanup(data, validation, *, host_changes=False, standalone=False):
    cpu, rt = make(data, validation, symbol_available=True)
    owner, control, icon = reader_back(rt)
    if standalone:
        rt.reparent(icon, owner)
        rt.objects[icon].state['frame'] = (16, 10, 24, 24)
        rt.objects[owner].state['leftBackIconView'] = icon
        control = icon
    else:
        original = rt.objects[icon].state['image']
        rt.objects[control].state.update(imageView=icon, stateImages={0: original},
            contentHorizontalAlignment=1, contentVerticalAlignment=1,
            imageEdgeInsets=(0., -6., 0., 6.), contentEdgeInsets=(0., 3., 0., 0.))
    rt.objects[icon].state['contentMode'] = 0
    original_state = snapshot(rt, [control, icon])
    # The retained historical state-creation helper constructs an actual old
    # ownership snapshot using the candidate's own data-key addresses. No
    # production top entry reaches this helper in 1.6.2. Its controlled use
    # here verifies cleanup of managed images/insets rather than fabricating
    # the restore implementation's expected answers in the runtime model.
    record = 0x6ff80000
    for offset in range(0, 128, 8):
        cpu.write(record+offset, 8, 0)
    cpu.write(record+56, 8, 1)
    cpu.write(record+80, 8, icon)
    call(cpu, validation['reader_directory']['back_prepare'], control, record)
    require(rt.objects[icon].state['image'] != original_state[icon]['image'],
            'Precondition: executed legacy helper created owned native artwork')
    if host_changes:
        newer = rt.obj('UIImage', 'new_host_artwork', size=(24, 24))
        rt.objects[icon].state.update(image=newer, contentMode=7, frame=(12, 9, 24, 24))
        original_state[icon].update(image=newer, contentMode=7, frame=(12, 9, 24, 24))
        if not standalone:
            rt.objects[control].state['stateImages'][4] = newer
            original_state[control]['stateImages'][4] = newer
    owned = []
    for view, key in [(control, SURFACE)] + [(owner, k) for k in TOP_GETTERS]:
        decoration = rt.view('UIVisualEffectView', 'old_owned_glass', (0, 0, 24, 24), view)
        rt.associations[(view, rt.slide+key)] = decoration
        owned.append(decoration)
    call(cpu, validation['reader_directory']['reader_panel'], owner)
    unchanged(rt, original_state)
    require(all(rt.objects[p].state['superview'] == 0 for p in owned),
            'Control and all three legacy sibling decorations are detached')
    require(not surface(rt, control), 'Control surface association is cleared')
    require(not rt.associations.get((owner, rt.slide+validation['reader_directory']['owner_back_key'])),
            'Owner no longer holds its old native-image role')
    rt.events.clear()
    call(cpu, validation['reader_directory']['reader_panel'], owner)
    require(not any(e['event'] in ('setImage:', 'setContentMode:', 'setCenter:',
            'setImage:forState:', 'setImageEdgeInsets:', 'setContentEdgeInsets:') for e in rt.events),
            'A second cleanup never rewrites the restored host state')
    return {'host_changes_preserved': host_changes, 'standalone_image': standalone,
            'decorations_removed': len(owned), 'owned_image_restored': True}


def bounded_and_reentrant(data, validation):
    cpu, rt = make(data, validation)
    owner = rt.view('FQReaderSaasNavigationView', 'large_top_tree', (0, 64, 440, 44), rt.ROOT)
    for index in range(120):
        rt.view('UIView', 'decoration' + str(index), (0, 0, 8, 8), owner)
    call(cpu, validation['reader_directory']['reader_panel'], owner)
    records = log_records(rt)
    require(records[-1]['data']['readerVisitedViews'] == 64 and
            records[-1]['data']['readerTraversalBudgetExhausted'] == 1,
            'Top cleanup uses one bounded 64-view budget')
    busy = rt.slide + validation['reader_directory']['busy_key']
    rt.associations[(owner, busy)] = owner
    steps = cpu.steps
    call(cpu, validation['reader_directory']['reader_panel'], owner)
    require(rt.associations[(owner, busy)] == owner and cpu.steps-steps < 80,
            'Reentry neither clears outer ownership nor traverses the tree')
    return {'cleanup_visit_limit': 64, 'nested_instruction_count': cpu.steps-steps}


def negative160(data, validation):
    cpu, rt = make(data, validation, symbol_available=True)
    owner, control, icon = reader_back(rt)
    original = rt.objects[icon].state['image']
    call(cpu, validation['reader_directory']['reader_panel'], owner)
    require(surface(rt, control) and rt.objects[icon].state['image'] != original,
            'Pinned 1.6.0 fails the new original-top contract by creating glass and replacing artwork')
    return {'version': '1.6.0', 'new_contract_rejected': True,
            'glass_created': True, 'host_artwork_replaced': True}


def main():
    p = argparse.ArgumentParser(description=__doc__)
    p.add_argument('--candidate', required=True, type=Path)
    p.add_argument('--validation', required=True, type=Path)
    p.add_argument('--baseline160', type=Path,
                   default=ROOT/'dist/1.6.0/FanqieAdBlock-1.6.0.dylib')
    p.add_argument('--baseline-validation', type=Path,
                   default=ROOT/'verification/1.6.0/FanqieAdBlock-1.6.0.validation.json')
    p.add_argument('--report', required=True, type=Path)
    a = p.parse_args()
    data = a.candidate.read_bytes(); validation = json.loads(a.validation.read_text())
    previous = a.baseline160.read_bytes(); previous_v = json.loads(a.baseline_validation.read_text())
    digest = hashlib.sha256(data).hexdigest()
    require(validation['candidate_sha256'] == digest, 'Exact candidate bytes match the build report')
    require(hashlib.sha256(previous).hexdigest() == BASELINE160_SHA and
            previous_v['candidate_sha256'] == BASELINE160_SHA, 'Pinned delivered 1.6.0 negative control')
    report = {'passed': False, 'candidate_sha256': digest, 'device_tested': False,
              'scope': 'Actual ARM64 execution; modeled public UIKit boundaries; no device pixels or tap-latency claim',
              'cases': []}
    tests = [(f'top_original_{getter}', lambda getter=getter: top_buttons(data, validation, getter=getter))
             for getter in ('image', 'button', 'absent', 'nil')]
    tests += [(name, lambda options=options: top_buttons(data, validation, **options)) for name, options in (
        ('top_original_aslr', {'slide': 0x100000000}),
        ('top_deep_nested_scope', {'nested': True}),
        ('top_dynamic_subclass', {'owner_class': 'FQNavigationRuntimeSubclass'}),
        ('story_big_original', {'owner_class': 'SSStoryBigNavigationBar'}),
        ('story_small_original', {'owner_class': 'SSStorySmallNavigationBar'}),
        ('top_when_glass_disabled', {'disabled': True}),
    )]
    tests += [
        ('four_actual_top_hooks', lambda: actual_top_hooks(data, validation)),
        ('legacy_owned_state_cleanup', lambda: legacy_owned_cleanup(data, validation)),
        ('legacy_state_with_host_changes', lambda: legacy_owned_cleanup(data, validation, host_changes=True)),
        ('legacy_standalone_cleanup', lambda: legacy_owned_cleanup(data, validation, standalone=True)),
        ('bounded_top_cleanup_and_reentry', lambda: bounded_and_reentrant(data, validation)),
        ('bottom_complete_captions_preserved', lambda: bottom_buttons(data, validation)),
        ('bottom_nested_icons_preserved', lambda: bottom_buttons(data, validation, nested=True)),
        ('listen_style_and_restore_preserved', lambda: listen_background(data, validation)),
        ('menu_attachment_preserved', lambda: menu_attachment(data, validation)),
        ('reader_scope_exclusions_preserved', lambda: exclusions(data, validation)),
        ('listen_reuse_preserved', lambda: listen_reuse(data, validation)),
        ('listen_orphan_owner_preserved', lambda: listen_orphan_owner(data, validation)),
        ('negative160_original_top_contract', lambda: negative160(previous, previous_v)),
    ]
    geometry.GeometryRuntime = ReaderRuntime
    for name, function in (
        ('shelf_edit', geometry.edit_pill), ('shelf_filter', geometry.filter_pill),
        ('shelf_reading_time', geometry.reading_time_pill), ('shelf_larger_font', geometry.larger_font),
        ('shelf_clipped_text', geometry.clipped_text), ('out_of_scope_original', geometry.original_fallback),
    ):
        tests.append((name, lambda function=function: function(data, validation['extension_directory'])))
    try:
        for name, test in tests:
            detail = test()
            report['cases'].append({'name': name, 'passed': True, 'details': detail})
            print('PASS', name)
        report['passed'] = True
    except Exception as error:
        report['error'] = str(error); report['traceback'] = traceback.format_exc()
        raise
    finally:
        report['executed_instructions'] = sum(cpu.steps for cpu, rt in
            RUNS + retained_reader.RUNS + geometry.RUNS)
        a.report.parent.mkdir(parents=True, exist_ok=True)
        a.report.write_text(json.dumps(report, ensure_ascii=False, indent=2) + '\n')


if __name__ == '__main__':
    main()
