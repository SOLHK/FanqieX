#!/usr/bin/env python3
"""Run the released 1.6.1 and candidate ARM64 against identical UI boundaries.

The old release must reproduce its missing base material/default selection
shade/hidden contents. The candidate must establish the explicit public state
needed for a readable capsule, including real ancestor input ownership.
The small hit-test model is a UIView boundary model, not UIKit or GPU rendering.
Injected image fixtures test non-destruction only: the pinned legacy builder
creates title-only buttons, and this suite does not claim to restore app icons.
"""
import argparse
import copy
import hashlib
import json
from pathlib import Path

from arm64 import require
from native_selection_runtime import make as make_component
from test_native_orchestration162 import make as make_full, repair, effect_writes


RELEASED_161_SHA = '8c8aedc3643c52efa1180119a983c8cd22006123ea095db617ea901be0fbcf8e'


def update(cpu, rt, entries):
    return cpu.run(entries['update'], rt.BAR, rt.PROXY, max_steps=3000000)['result']


def restore(cpu, rt, entries):
    cpu.run(entries['restore'], rt.BAR, rt.PROXY, max_steps=3000000)


def hit_test(rt, receiver, point, depth=0):
    """Only public UIView rules; system control internals are not modeled."""
    require(depth < 32, 'Fixture view ancestry is finite')
    state = rt.objects[receiver].state
    if (state.get('hidden', False) or state.get('alpha', 1) <= 0.01 or
            not state.get('userInteractionEnabled', True)):
        return 0
    bx, by, bw, bh = state['bounds']
    if not (bx <= point[0] <= bx + bw and by <= point[1] <= by + bh):
        return 0
    for child in reversed(state['subviews']):
        child_state = rt.objects[child].state
        fx, fy, _, _ = child_state['frame']
        cx, cy, _, _ = child_state['bounds']
        hit = hit_test(rt, child, (point[0] - fx + cx, point[1] - fy + cy), depth + 1)
        if hit:
            return hit
    return receiver


def assert_public_readable_state(rt):
    control = rt.control()
    require(control, 'Candidate installs native input')
    effect = rt.objects[rt.PROXY].state['effect']
    require(effect and rt.class_names[rt.objects[effect].cls] == 'UIGlassEffect' and
            rt.objects[effect].state['style'] == 0,
            'The visible capsule retains a real Regular UIGlassEffect')
    native = rt.objects[control].state
    require(native['superview'] == rt.PROXY_CONTENT,
            'System selection is contained by the actual effect contentView')
    require(native['selectedSegmentTintColor'] == rt.color('secondarySystemFillColor'),
            'Selected tint is an explicit adaptive gray, never the legacy default white')
    require(native['tintColor'] == rt.color('labelColor') and
            native['backgroundColor'] == rt.color('clearColor'),
            'Owned native view uses semantic foreground and no opaque background fill')
    require(set(native['titleTextAttributes']) == set(range(8)) and
            all(attrs == {'NSColor': rt.color('clearColor')}
                for attrs in native['titleTextAttributes'].values()),
            'Native text cannot double-render over original content in any control state')
    require(not rt.associated(rt.PROXY, 'overlay') and not rt.associated(rt.PROXY, 'lens'),
            'Native mode adds no second custom selection glass/lens')
    require(rt.objects[rt.PROXY_CONTENT].state['subviews'][0] == control,
            'Original contents draw above the single public native selector')
    for button in rt.buttons:
        state = rt.objects[button].state
        require(not state['hidden'] and not state['userInteractionEnabled'] and
                state['accessibilityElementsHidden'] and not state['isAccessibilityElement'],
                'Existing contents remain visible with input/accessibility owned only by native selection')
        require(state['backgroundColor'] == rt.color('clearColor'),
                'An old selected button cannot paint a second opaque selection behind its text')


def released_negative_control(candidate, previous):
    require(hashlib.sha256(previous).hexdigest() == RELEASED_161_SHA,
            'The negative control is the exact released 1.6.1')
    old_cpu, old, old_entries = make_full(previous)
    repair(old_cpu, old, old_entries)
    require(old.control() and old.objects[old.PROXY].state['effect'] == 0,
            'Released 1.6.1 actually removes its Regular track after native creation')
    require('selectedSegmentTintColor' not in old.objects[old.control()].state,
            'Released 1.6.1 leaves the legacy selected shade entirely unconfigured')
    require(all(old.objects[b].state['hidden'] for b in old.buttons),
            'Released 1.6.1 hides every original visual button')
    new_cpu, new, new_entries = make_full(candidate)
    repair(new_cpu, new, new_entries)
    assert_public_readable_state(new)
    return {'released_missing_track_reproduced': True,
            'released_default_selection_shade_reproduced': True,
            'released_hidden_contents_reproduced': True,
            'candidate_regular_track_and_semantic_gray': True}


def coordinate_system_and_reparenting(candidate):
    cases = []
    for slide in (0, 0x180000000):
        cpu, rt, entries = make_component(candidate, slide=slide)
        require(update(cpu, rt, entries) == 1, 'Coordinate fixture builds')
        control = rt.control()
        for bounds in ((0, 0, 416, 56), (7, 9, 396, 60), (-13, -3, 508, 68), (0, 0, 320, 50)):
            rt.objects[rt.PROXY_CONTENT].state['bounds'] = bounds
            require(update(cpu, rt, entries) == 1, 'Finite actual content bounds remain supported')
            require(rt.control() == control and rt.objects[control].state['frame'] == bounds,
                    'Native frame follows content coordinates instead of bar-relative insets')
            require(not rt.route_calls, 'Coordinate maintenance never triggers navigation')
        old_content = rt.PROXY_CONTENT
        replacement = rt.view('UIView', 'replacement_effect_content', (0, 0, 416, 56),
                              rt.PROXY, userInteractionEnabled=False)
        rt.objects[rt.PROXY].state['contentView'] = replacement
        for button in rt.buttons:
            rt.reparent(button, replacement)
        rt.PROXY_CONTENT = replacement
        require(update(cpu, rt, entries) == 1, 'A new contentView creates a new ownership epoch')
        require(rt.control() != control and rt.objects[control].state['superview'] == 0,
                'Old control is removed when its effect contentView is replaced')
        require(rt.objects[rt.control()].state['superview'] == replacement and
                rt.objects[replacement].state['userInteractionEnabled'],
                'New control is mounted on and receives input through the actual contentView')
        restore(cpu, rt, entries)
        require(rt.objects[replacement].state['userInteractionEnabled'] is False and
                rt.objects[old_content].state.get('userInteractionEnabled', True) is True,
                'Teardown restores new content state without messaging detached old content')
        cases.append({'slide': hex(slide), 'bound_variants': 4,
                      'replacement_content_restored': True})
    for bounds in ((0, 0, 0, 56), (0, 0, 416, -1), (float('nan'), 0, 416, 56)):
        cpu, rt, entries = make_component(candidate)
        rt.objects[rt.PROXY_CONTENT].state['bounds'] = bounds
        require(update(cpu, rt, entries) == 0 and not rt.control(),
                'Unrenderable content rejects native creation before any partial publication')
        require(all(rt.objects[b].state['userInteractionEnabled'] for b in rt.buttons),
                'Unrenderable content does not disable the original buttons')
    return cases


def ancestor_input_and_restoration(candidate):
    cases = []
    for proxy_enabled, content_enabled in ((False, False), (False, True), (True, False), (True, True)):
        cpu, rt, entries = make_component(candidate)
        rt.objects[rt.PROXY].state['userInteractionEnabled'] = proxy_enabled
        rt.objects[rt.PROXY_CONTENT].state['userInteractionEnabled'] = content_enabled
        require(update(cpu, rt, entries) == 1, 'Every owned input state can mount native selection')
        require(rt.objects[rt.PROXY].state['userInteractionEnabled'] and
                rt.objects[rt.PROXY_CONTENT].state['userInteractionEnabled'],
                'Both owned ancestors must allow native hit testing')
        # This starts at the actual glass root, not directly at the control;
        # presentation-only buttons are considered before the native child.
        require(hit_test(rt, rt.PROXY, (157, 28)) == rt.control(),
                'Public hit-test rules reach native input through the full owned subtree')
        rt.fire(cpu, index=1)
        require(rt.route_calls == [1], 'One delivered native selection routes once after input reachability')
        rt.objects[rt.PROXY].state['userInteractionEnabled'] = False
        rt.objects[rt.PROXY_CONTENT].state['userInteractionEnabled'] = False
        require(update(cpu, rt, entries) == 1 and
                hit_test(rt, rt.PROXY, (259, 28)) == rt.control(),
                'Maintenance repairs a late disable of owned input ancestors')
        restore(cpu, rt, entries)
        require(rt.objects[rt.PROXY].state['userInteractionEnabled'] == proxy_enabled and
                rt.objects[rt.PROXY_CONTENT].state['userInteractionEnabled'] == content_enabled,
                'Teardown restores the initial two input flags, not the maintenance writes')
        require(all(rt.objects[b].state['userInteractionEnabled'] and
                    not rt.objects[b].state['accessibilityElementsHidden'] and
                    rt.objects[b].state['isAccessibilityElement'] for b in rt.buttons),
                'Teardown returns input and accessibility to the original buttons')
        cases.append({'original_proxy_input': proxy_enabled,
                      'original_content_input': content_enabled, 'modeled_native_hit': True})
    cpu, rt, entries = make_component(candidate)
    update(cpu, rt, entries)
    rt.objects[rt.PROXY].state['userInteractionEnabled'] = False
    rt.objects[rt.PROXY_CONTENT].state['userInteractionEnabled'] = False
    restore(cpu, rt, entries)
    require(not rt.objects[rt.PROXY].state['userInteractionEnabled'] and
            not rt.objects[rt.PROXY_CONTENT].state['userInteractionEnabled'],
            'A late host input value survives compare-and-restore if maintenance did not reapply')
    return cases


def existing_visual_content_and_stable_material(candidate):
    cpu, rt, entries = make_full(candidate)
    # Synthetic content checks preservation only; it does not fabricate the
    # absent image extraction/layout in the pinned title-only legacy builder.
    rt._class('UIImage', 'NSObject')
    before = {}
    for index, button in enumerate(rt.buttons):
        image = rt.obj('UIImage', 'existing_fixture_image_' + str(index))
        selected_image = rt.obj('UIImage', 'existing_fixture_selected_' + str(index))
        rt.objects[button].state.update(image=image, stateImages={0: image, 4: selected_image})
        before[button] = {name: copy.deepcopy(rt.objects[button].state[name])
                          for name in ('frame', 'bounds', 'title', 'image', 'stateImages',
                                       'originalTarget', 'originalAction', 'accessibilityLabel')}
    repair(cpu, rt, entries)
    assert_public_readable_state(rt)
    initial_effect = rt.objects[rt.PROXY].state['effect']
    initial_writes = len(effect_writes(rt))
    for alpha in (1.0, 0.75, 0.5, 1.0, 1.0):
        rt.objects[rt.ROOT].state['alpha'] = alpha
        rt.objects[rt.control()].state.update(tracking=True, selectedSegmentIndex=1)
        repair(cpu, rt, entries)
        require(rt.objects[rt.control()].state['selectedSegmentIndex'] == 1,
                'Presentation/material maintenance preserves native tracking preview')
        require(rt.objects[rt.PROXY].state['effect'] == initial_effect and
                len(effect_writes(rt)) == initial_writes,
                'Visibility/fade/maintenance never clears or replaces a usable Regular material')
        for button, saved in before.items():
            require({key: rt.objects[button].state[key] for key in saved} == saved,
                    'Existing text, optional image content, layout and host route stay intact')
    rt.objects[rt.ROOT].state['alpha'] = 1.0
    rt.objects[rt.control()].state['tracking'] = False
    rt.fire(cpu, index=3)
    require(rt.route_calls == [3] and rt.selected_index() == 3,
            'Original content presentation does not intercept or duplicate navigation')
    assert_public_readable_state(rt)
    require(all(event['value'] for event in effect_writes(rt)),
            'No native material setter dematerializes the track at any point')
    return {'material_writes': initial_writes, 'fade_and_tracking_variants': 5,
            'existing_content_preserved': True, 'actual_host_icons_restored': False}


def run(candidate, previous):
    cases = []
    for name, function in (
        ('released_161_negative_control', lambda: released_negative_control(candidate, previous)),
        ('content_coordinates_and_replacement', lambda: coordinate_system_and_reparenting(candidate)),
        ('ancestor_input_and_restore', lambda: ancestor_input_and_restoration(candidate)),
        ('existing_content_and_stable_material', lambda: existing_visual_content_and_stable_material(candidate)),
    ):
        cases.append({'name': name, 'passed': True, 'detail': function()})
    return {'passed': True, 'candidate_sha256': hashlib.sha256(candidate).hexdigest(),
            'negative_control_sha256': hashlib.sha256(previous).hexdigest(),
            'case_groups': len(cases), 'cases': cases,
            'scope': 'Actual ARM64 including complete repair, with public UIKit/Foundation and hit-test boundaries.',
            'device_tested': False, 'gpu_refraction_tested': False,
            'physical_hit_testing_tested': False,
            'limits': ['No native UIKit/GPU pixel rendering or physical drag executed.',
                       'The fixture images demonstrate non-destruction only; the pinned legacy builder is title-only.',
                       'Semantic colors are requested through public API; actual device colors/contrast remain unmeasured.']}


if __name__ == '__main__':
    parser = argparse.ArgumentParser(description=__doc__)
    parser.add_argument('--candidate', type=Path, required=True)
    parser.add_argument('--baseline', type=Path, required=True)
    parser.add_argument('--report', type=Path, required=True)
    args = parser.parse_args()
    result = run(args.candidate.read_bytes(), args.baseline.read_bytes())
    args.report.write_text(json.dumps(result, ensure_ascii=False, indent=2) + '\n')
    print(json.dumps(result, ensure_ascii=False, indent=2))
