#!/usr/bin/env python3
"""Execute real ARM64 for readable fallback material and finger-relative selection.

The shipped 1.6.0 is a required negative control. UIKit/GPU rendering remains
outside this boundary model: this verifies material choices, layer ownership,
continuous geometry, and the original navigation route, not optical pixels.
"""
import argparse
import hashlib
import json
from pathlib import Path

from arm64 import release_version, require
from execution_audit import directory, make as make_material
from interaction_runtime import make


def objects(runtime):
    return tuple(runtime.associated(runtime.PROXY, key)
                 for key in ('controller', 'pan', 'lens', 'overlay'))


def fixture(data, **options):
    cpu, runtime, entries = make(data, **options)
    cpu.run(entries['update'], runtime.BAR, runtime.PROXY)
    require(runtime.associated(runtime.PROXY, 'overlay'), 'A real interaction was constructed')
    return cpu, runtime, entries


def fire(cpu, runtime, entries, state, x):
    controller, pan, _, _ = objects(runtime)
    runtime.objects[pan].state.update(state=state, location=(x, 28))
    cpu.run(entries['pan'], controller, runtime.sel('pan:'), pan)


def lens_center(runtime):
    lens = runtime.associated(runtime.PROXY, 'lens')
    x, _, width, _ = runtime.objects[lens].state['frame']
    return x + width / 2


def outside_drag(data, *, start=55, end=180, rtl=False, selected=2):
    cpu, runtime, entries = fixture(data, rtl=rtl, selected=selected)
    fire(cpu, runtime, entries, 1, start)
    began_center = lens_center(runtime)
    fire(cpu, runtime, entries, 2, end)
    moved_center = lens_center(runtime)
    require(not runtime.route_calls, 'A move never navigates before release')
    fire(cpu, runtime, entries, 3, end)
    return {'began_center': began_center, 'moved_center': moved_center,
            'routes': runtime.route_calls}


def material_style(data):
    cpu, runtime = make_material(data)
    cpu.run(directory(data)['material_update'], runtime.BAR, runtime.PROXY)
    effect = runtime.objects[runtime.PROXY].state['effect']
    return runtime.objects[effect].state['style']


def run(candidate, previous):
    optical_drag = release_version(candidate) in ("1.78R15", "1.78R16", "1.78R25", "1.78R26", "1.78R27", "1.78R28", "1.78R29", "1.78R30", "1.78R31", "1.78R32", "1.78R33", "1.78R34", "1.78R35", "1.78R36", "1.79R1", "1.79R2", "1.79R3", "1.79R4", "1.79R5", "1.8R1", "1.8R2", "1.8R3", "1.8R4", "1.8R5", "1.8R6", "1.8R7", "1.8R8", "1.8R9", "1.8R10", "1.8R11", "1.8R12", "1.8R13", "1.8R14", "1.8R15", "1.8R16", "1.8R17", "1.8R18", "1.8R19", "1.8R19", "1.9.1beta1", "1.9.1beta2", "1.9.1beta3", "1.9.1beta4", "1.9.1beta5", "1.9.1beta6", "1.9.1beta7", "1.9.1beta8", "1.9.1beta9", "1.9.1beta10", "1.9.1beta11", "1.9.1beta12", "1.9.1beta13", "1.9.1beta14", "1.9.1beta15", "1.9.1beta16", "1.9.1beta17", "1.9.1beta18", "1.9.1beta19", "1.9.1beta20", "1.9.1beta21", "1.9.1beta22", "1.9.1beta23", "1.9.1beta24", "1.9.1beta25", "1.9.1beta26", "1.9.5beta1", "1.9.5beta2", "1.9.5beta3", "1.9.5beta4", "1.9.5beta5", "1.9.5beta6", "1.9.5beta7", "1.9.5beta8", "1.9.5beta9", "1.9.6beta1", "1.9.6beta2", "1.9.6beta3", "1.9.6beta4", "1.9.6beta5", "1.9.6beta6", "1.9.6beta7", "1.9.6beta8", "1.9.6beta9", "1.9.7beta1", "1.9.7beta2", "1.9.7beta3", "1.9.7beta4", "1.9.7beta5", "1.9.7beta6", "1.9.7beta7", "1.9.7beta8", "1.9.7beta9", "1.9.7beta10", "1.9.8beta", "1.9.8beta2", "2.0", "2.0.1beta1", "2.0.1beta2", "2.0.1beta3", "2.0.1beta4", "2.0.1beta5", "2.0.1beta6", "2.0.1beta7", "2.0.1beta8", "2.0.1beta9", "2.0.1beta10")
    require(hashlib.sha256(previous).hexdigest() ==
            '2da6826d63d5e05ec6c2f20d3375d58186474490c9c92dc09c2cc734529560b1',
            'The negative control is the exact shipped 1.6.0')
    cases = []
    old = outside_drag(previous)
    new = outside_drag(candidate)
    require(old == {'began_center': 259, 'moved_center': 361, 'routes': [3]},
            'The unchanged release reproduces the wrong distant selection')
    require(new == {'began_center': 55, 'moved_center': 180, 'routes': [1]},
            'Starting on another tab follows the finger and selects that physical item')
    cases.append({'name': 'nonselected_origin_negative_control', 'old': old, 'new': new})

    for rtl, selected, start, end, expected in (
        (False, 0, 361, 250, 2), (False, 3, 55, 160, 1),
        (True, 0, 55, 180, 2), (True, 3, 361, 250, 1),
    ):
        got = outside_drag(candidate, start=start, end=end, rtl=rtl, selected=selected)
        require(got == {'began_center': start, 'moved_center': end, 'routes': [expected]},
                'Any unselected physical tab supports left/right drag in either layout direction')
    cases.append({'name': 'all_directions_and_rtl', 'passed': True})

    for offset in (-45, -17, 0, 17, 45):
        cpu, runtime, entries = fixture(candidate)
        finger = 259 + offset
        fire(cpu, runtime, entries, 1, finger)
        began_center = lens_center(runtime)
        if optical_drag:
            require(abs(began_center - finger) <= 8 and
                    min(259, finger) <= began_center <= max(259, finger),
                    'An inside grab stays close to the finger without overshooting')
        else:
            require(began_center == 259, 'Grabbing inside the selection does not jump')
        fire(cpu, runtime, entries, 2, finger + 31)
        require(lens_center(runtime) == began_center + 31,
                'Inside selection retains a stable grab offset while moving')
        fire(cpu, runtime, entries, 4, 290 + offset)
        require(lens_center(runtime) == 259 and not runtime.route_calls,
                'Cancel restores the true selected item without a page change')
    cases.append({'name': 'inside_grab_offset_and_cancel', 'passed': True})

    require(material_style(previous) == 1, 'The shipped main bar uses clear glass')
    require(material_style(candidate) == 0, 'The candidate requests readable regular glass')
    cases.append({'name': 'regular_main_material_negative_control', 'passed': True})

    cpu, runtime, entries = fixture(candidate)
    controller, pan, lens, overlay = objects(runtime)
    initial_effect = runtime.objects[lens].state['effect']
    require(initial_effect == 0, 'The resting selection uses ordinary adaptive fill')
    initial_effect_writes = [event for event in runtime.events if event['event'] == 'setEffect']
    expected_effect_writes = []
    for terminal in (3, 4, 5):
        fire(cpu, runtime, entries, 1, lens_center(runtime))
        active_effect = runtime.objects[lens].state['effect']
        lens_position = -1 if optical_drag else 0
        if optical_drag:
            effect = runtime.objects[active_effect]
            require(runtime.class_names[effect.cls] == 'UIGlassEffect' and
                    effect.state['style'] == 1 and effect.state['interactive'],
                    'Dragging installs interactive Clear Liquid Glass')
            expected_effect_writes.extend([active_effect, initial_effect])
        else:
            require(active_effect == initial_effect, 'Legacy dragging uses ordinary adaptive fill')
        require(runtime.objects[overlay].state['subviews'][lens_position] == lens,
                'The active selection has the expected layer order relative to labels')
        for x in (90, 130, 170, 210, 250, 290, 330):
            fire(cpu, runtime, entries, 2, x)
            cpu.run(entries['update'], runtime.BAR, runtime.PROXY)
            require(runtime.objects[lens].state['effect'] == active_effect,
                    'Movement and maintenance preserve the active lens material')
            require(runtime.objects[overlay].state['subviews'][lens_position] == lens,
                    'Maintenance preserves the active lens layer order')
        fire(cpu, runtime, entries, terminal, 330)
        require(runtime.objects[overlay].state['subviews'][0] == lens,
                'Every terminal path restores sharp labels above the lens')
        require(runtime.objects[lens].state['effect'] == initial_effect,
                'Every terminal path restores the resting material')
        require(not runtime.associated(controller, 'drag'), 'Every terminal path clears dragging')
    effect_writes = [event for event in runtime.events if event['event'] == 'setEffect']
    new_writes = effect_writes[len(initial_effect_writes):]
    require(all(event['self'] == lens for event in new_writes) and
            [event['value'] for event in new_writes] == expected_effect_writes,
            'Material changes occur only when optical dragging starts and ends')
    require(runtime.objects[lens].state['userInteractionEnabled'] is False and
            runtime.objects[lens].state['alpha'] == 1,
            'The optical surface neither intercepts touches nor fades labels')
    cases.append({'name': 'fallback_tracks_material_and_restores_readable_labels', 'passed': True})
    return {'passed': True, 'candidate_sha256': hashlib.sha256(candidate).hexdigest(),
            'negative_control_sha256': hashlib.sha256(previous).hexdigest(), 'cases': cases,
            'case_count': len(cases), 'device_tested': False,
            'scope': 'Actual ARM64 compatibility fallback material/gesture instructions with UIKit boundary models. '
                     'No GPU refraction, Apple Store pixel identity or native press/stretch claim.'}


if __name__ == '__main__':
    parser = argparse.ArgumentParser(description=__doc__)
    parser.add_argument('candidate', type=Path)
    parser.add_argument('--baseline', type=Path, required=True)
    parser.add_argument('--report', type=Path, required=True)
    args = parser.parse_args()
    result = run(args.candidate.read_bytes(), args.baseline.read_bytes())
    args.report.write_text(json.dumps(result, indent=2) + '\n')
    print(json.dumps(result, indent=2))
