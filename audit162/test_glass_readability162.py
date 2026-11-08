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

from arm64 import require
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
        fire(cpu, runtime, entries, 1, 259 + offset)
        require(lens_center(runtime) == 259, 'Grabbing inside the selection does not jump')
        fire(cpu, runtime, entries, 2, 290 + offset)
        require(lens_center(runtime) == 290, 'Inside selection keeps the actual grab offset')
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
    require(initial_effect == 0, 'The compatibility selection must not add a second glass material')
    initial_effect_writes = [event for event in runtime.events if event['event'] == 'setEffect']
    for terminal in (3, 4, 5):
        fire(cpu, runtime, entries, 1, lens_center(runtime))
        require(runtime.objects[overlay].state['subviews'][0] == lens,
                'The compatibility indicator stays below readable labels')
        for x in (90, 130, 170, 210, 250, 290, 330):
            fire(cpu, runtime, entries, 2, x)
            cpu.run(entries['update'], runtime.BAR, runtime.PROXY)
            require(runtime.objects[lens].state['effect'] == initial_effect,
                    'Movement and maintenance do not reset the native backdrop')
            require(runtime.objects[overlay].state['subviews'][0] == lens,
                    'Maintenance never stacks glass above labels')
        fire(cpu, runtime, entries, terminal, 330)
        require(runtime.objects[overlay].state['subviews'][0] == lens,
                'Every terminal path restores sharp labels above the lens')
        require(runtime.objects[lens].state['effect'] == initial_effect,
                'Ending and cancelling retain the same system material')
        require(not runtime.associated(controller, 'drag'), 'Every terminal path clears dragging')
    require([event for event in runtime.events if event['event'] == 'setEffect'] == initial_effect_writes,
            'There is no effect nil/glass alternation across complete gestures')
    require(runtime.objects[lens].state['userInteractionEnabled'] is False and
            runtime.objects[lens].state['alpha'] == 1,
            'The optical surface neither intercepts touches nor fades labels')
    cases.append({'name': 'fallback_keeps_one_glass_and_readable_labels', 'passed': True})
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
