#!/usr/bin/env python3
"""Execute complete repair/monitor/selection/restore instructions with native UI boundaries.

No repair entry is redirected to a smaller component. UIKit and the unavailable
host IMPs are explicit fixtures; no native pixels or physical drag are claimed.
"""
import argparse
import hashlib
import json
from pathlib import Path
import struct

from arm64 import CPU, require
from interaction_runtime import read_entries
from legacy_runtime import Runtime as Legacy
from native_selection_runtime import Runtime as Native, native_entries
from new_scenarios import saved


RUNS = []


class Runtime(Native, Legacy):
    def handle(self, cpu, pc):
        if pc - self.slide == self.entries['main_repair']:
            # Both component runtimes otherwise redirect this entry. Execute
            # the real Lrepair instead, including LXupdate and material order.
            return False
        return super().handle(cpu, pc)


def make(data, *, slide=0, **options):
    entries = read_entries(data)
    native = native_entries(data)
    rt = Runtime(data, entries, native, slide=slide, **options)
    words = struct.unpack_from('<64I', data, 0x800)
    ext = struct.unpack_from('<28I', data, 0x800 + words[60] + 16)
    entries.update({name: 0x800 + ext[index] for name, index in
                    [('poll', 7), ('snapshot', 8), ('monitor_key', 19), ('timer_key', 21)]})
    cpu = CPU(data, rt, slide=slide, ranges=[
        (0x900, entries['main_code_end']), (0x14080, entries['extension_code_end']),
        (0x4338, 0x43fc), (0x4704, 0x48d0), (0x4958, 0x4d78),
        (0x5168, 0x5204), (0x5688, 0x5798), (0x5b94, 0x5c24),
        (0x60b8, 0x62ac), (0x6c14, 0x6c4c), (0x6db4, 0x702c),
        (0x711c, 0x746c),
    ])
    cpu.pointers.update(rt.rebase_pointers)
    RUNS.append((cpu, rt))
    return cpu, rt, entries


def repair(cpu, rt, entries):
    return cpu.run(entries['main_repair'], rt.BAR, max_steps=3000000)


def effect_writes(rt):
    return [event for event in rt.events
            if event['event'] == 'setEffect' and event['self'] == rt.PROXY]


def require_native(rt):
    control = rt.control()
    require(control and rt.objects[control].state['superview'] == rt.BAR,
            'Native control is mounted on the actual bar')
    require(rt.objects[rt.PROXY].state['effect'] == 0,
            'Native surface never has an additional proxy glass behind it')
    require(not rt.associated(rt.PROXY, 'overlay') and not rt.associated(rt.PROXY, 'pan'),
            'Native surface removes the old overlay and custom pan')
    require(all(rt.objects[button].state['hidden'] for button in rt.buttons),
            'Original buttons are hidden while their routing remains available')
    require(rt.objects[rt.BAR].state['subviews'][-1] == control,
            'Native surface is the interactive foreground of the bar')
    return control


def require_fallback(rt):
    require(not rt.control(), 'Fallback owns no native selection control')
    effect = rt.objects[rt.PROXY].state['effect']
    require(effect and rt.class_names[rt.objects[effect].cls] == 'UIGlassEffect' and
            rt.objects[effect].state['style'] == 0, 'Fallback owns one Regular glass base')
    overlay, lens = rt.associated(rt.PROXY, 'overlay'), rt.associated(rt.PROXY, 'lens')
    require(overlay and lens and rt.associated(rt.PROXY, 'pan'),
            'Fallback selection and existing host controls remain operable')
    require(rt.objects[lens].state['effect'] == 0,
            'Fallback selection uses ordinary adaptive fill without another material')
    require(all(not rt.objects[button].state['hidden'] for button in rt.buttons),
            'Native teardown restores host buttons before fallback takes over')
    return overlay


def first_mount_and_stability(data):
    rows = []
    for slide in (0, 0x180000000):
        cpu, rt, entries = make(data, slide=slide)
        repair(cpu, rt, entries)
        control = require_native(rt)
        writes = len(effect_writes(rt))
        require(writes == 1 and effect_writes(rt)[0]['value'] == 0,
                'First mount clears the old proxy material exactly once')
        for _ in range(6):
            repair(cpu, rt, entries)
        require(require_native(rt) == control and len(effect_writes(rt)) == writes,
                'Stable complete repairs do not recreate native selection or churn materials')
        rt.fire(cpu, index=0)
        require(rt.route_calls == [0] and rt.selected_index() == 0,
                'Value change traverses original click/sync and complete repair once')
        require(require_native(rt) == control and len(effect_writes(rt)) == writes,
                'Navigation preserves the single native control and clear proxy')
        rt.fire(cpu)
        require(rt.route_calls == [0], 'Duplicate UIKit callback does not route twice')
        rows.append({'slide': hex(slide), 'material_writes': writes, 'original_routes': 1})
    return rows


def fallback_to_native_during_fade(data):
    cpu, rt, entries = make(data, missing_segment_class=True)
    repair(cpu, rt, entries)
    old_overlay = require_fallback(rt)
    old_controller = rt.associated(rt.PROXY, 'controller')
    old_pan = rt.associated(rt.PROXY, 'pan')
    rt.objects[rt.ROOT].state['alpha'] = 0.5
    rt.missing_classes.remove('UISegmentedControl')
    repair(cpu, rt, entries)
    control = require_native(rt)
    require(rt.objects[old_overlay].state['superview'] == 0 and
            rt.objects[old_pan].state['view'] == 0 and
            not rt.associated(old_controller, 'drag'),
            'Switching to native removes the complete old fallback gesture surface')
    writes = len(effect_writes(rt))
    repair(cpu, rt, entries)
    require(require_native(rt) == control and len(effect_writes(rt)) == writes,
            'A fade does not reintroduce fallback glass beneath native selection')
    rt.objects[rt.ROOT].state['alpha'] = 1.0
    repair(cpu, rt, entries)
    require(require_native(rt) == control and len(effect_writes(rt)) == writes,
            'Completing the fade does not rebuild either material or native control')
    return {'alpha_during_native_mount': 0.5, 'proxy_effect_cleared_before_alpha_gate': True}


def native_failure_and_recovery(data):
    cpu, rt, entries = make(data)
    repair(cpu, rt, entries)
    old_control = require_native(rt)
    old_controller = rt.controller()
    rt.missing_classes.add('UISegmentedControl')
    repair(cpu, rt, entries)
    require_fallback(rt)
    require(rt.objects[old_control].state['superview'] == 0 and not rt.targets(old_control),
            'Native loss unmounts the control and unhooks its callback')
    require(old_controller in rt.dead, 'Unhooked native controller has no leaked strong owner')
    rt.missing_classes.remove('UISegmentedControl')
    repair(cpu, rt, entries)
    control = require_native(rt)
    require(control != old_control and len(rt.targets(control)) == 1,
            'Recovery installs one new valid native target')
    rt.fire(cpu, index=1)
    require(rt.route_calls == [1], 'Recovered native surface routes through the host exactly once')
    return {'native_to_regular_to_native': True, 'stale_targets': 0, 'original_routes': 1}


def live_monitor_and_host_sync(data):
    cpu, rt, entries = make(data)
    repair(cpu, rt, entries)
    control = require_native(rt)
    monitor = rt.associations[(rt.BAR, rt.slide + entries['monitor_key'])]
    timer = rt.associations[(monitor, rt.slide + entries['timer_key'])]
    require((timer, 'kCFRunLoopCommonModes') in rt.objects[rt.main_runloop].state['timers'],
            'Monitoring remains live during scroll tracking')
    rt.objects[control].state.update(tracking=True, selectedSegmentIndex=1)
    writes = len(effect_writes(rt))
    for _ in range(4):
        rt.now += 0.25
        cpu.run(entries['poll'], monitor, rt.sel('fqabPoll:'), timer, max_steps=3000000)
    require(rt.objects[control].state['selectedSegmentIndex'] == 1 and rt.route_calls == [],
            'Full maintenance leaves UIKit tracking preview alone before its action')
    require(require_native(rt) == control and len(effect_writes(rt)) == writes,
            'Native tracking does not add a second glass or custom gesture')
    rt.objects[rt.BAR].state['selectedItem'] = rt.items[3]
    cpu.run(0x60b8, rt.BAR, rt.PROXY, max_steps=3000000)
    require(rt.objects[control].state['selectedSegmentIndex'] == 3 and rt.route_calls == [],
            'Actual host sync hook updates native selection immediately during tracking')
    # A missing host callback is the pre-existing 1 Hz recovery path. The
    # other 0.25s ticks intentionally limit work to decorations and edges.
    rt.objects[rt.BAR].state['selectedItem'] = rt.items[2]
    for _ in range(4):
        rt.now += 0.25
        cpu.run(entries['poll'], monitor, rt.sel('fqabPoll:'), timer, max_steps=3000000)
    require(rt.objects[control].state['selectedSegmentIndex'] == 2 and rt.route_calls == [],
            'Full periodic rescan recovers a silent host selection change within four ticks')
    rt.objects[control].state['tracking'] = False
    rt.fire(cpu, index=0)
    require(rt.route_calls == [0] and require_native(rt) == control,
            'Only a real valueChanged boundary triggers navigation')
    return {'common_mode_monitor': True, 'uncommitted_preview_preserved': True,
            'external_selection_authoritative': True, 'sync_hook_immediate': True,
            'silent_host_change_recovery_ticks': 4}


def diagnostics_and_original_restore(data):
    cpu, rt, entries = make(data)
    rt.objects[rt.MAIN_BUNDLE].state['info'] = {
        'UIDesignRequiresCompatibility': True, 'DTSDKName': 'iphoneos27.2'}
    repair(cpu, rt, entries)
    control = require_native(rt)
    controller = rt.controller()
    monitor = rt.associations[(rt.BAR, entries['monitor_key'])]
    timer = rt.associations[(monitor, entries['timer_key'])]
    rt.flush_main(cpu)
    rt.drain_operations(cpu)
    rows = [row['data'] for row in saved(rt) if row['event'] == 'bottom_bar_state_changed']
    require(rows and rows[-1]['bottomBarRenderer'] == 'UISegmentedControl',
            'Durable snapshot identifies native selection rather than a fabricated custom lens')
    require(rows[-1]['nativeSelectionControl']['class'] == 'UISegmentedControl' and
            rows[-1]['hostDesignRequiresCompatibility'] is True and
            rows[-1]['hostSDKName'] == 'iphoneos27.2',
            'Diagnostics expose the native surface and public host design metadata')
    require(rows[-1]['glassSelectionLens'] is None,
            'Native path does not claim the fallback lens is mounted')
    cpu.run(0x6db4, rt.BAR, rt.PROXY, max_steps=3000000)
    require(not rt.control() and not rt.associated(rt.PROXY, 'overlay'),
            'Original restore clears both native and fallback ownership')
    require(not rt.targets(control) and rt.objects[control].state['superview'] == 0 and
            controller in rt.dead, 'Original restore removes target before final controller release')
    require(all(not rt.objects[button].state['hidden'] and
                rt.objects[button].state['superview'] == rt.PROXY_CONTENT for button in rt.buttons),
            'Original restore recovers host button visibility and parentage')
    require(not rt.objects[timer].state['valid'] and not rt.objects[rt.EDGE].state['hidden'],
            'Original restore tears down the monitor and restores the scroll edge')
    return {'persisted_native_renderer': True, 'public_host_metadata': True,
            'original_restore_all_extensions': True}


def run(data):
    cases = []
    for function in (first_mount_and_stability, fallback_to_native_during_fade,
                     native_failure_and_recovery, live_monitor_and_host_sync,
                     diagnostics_and_original_restore):
        details = function(data)
        cases.append({'name': function.__name__, 'passed': True, 'details': details})
    return {'passed': True, 'candidate_sha256': hashlib.sha256(data).hexdigest(),
            'cases': cases, 'instructions': sum(cpu.steps for cpu, _ in RUNS),
            'repair_entries_intercepted': False, 'device_ui_tested': False,
            'limitations': ['UIKit/Foundation and host IMPs are explicit boundary fixtures.',
                'Native thumb rendering, GPU refraction, physical touch and dyld loading are not executed.']}


if __name__ == '__main__':
    parser = argparse.ArgumentParser(description=__doc__)
    parser.add_argument('--candidate', type=Path, required=True)
    parser.add_argument('--report', type=Path, required=True)
    args = parser.parse_args()
    result = run(args.candidate.read_bytes())
    args.report.parent.mkdir(parents=True, exist_ok=True)
    args.report.write_text(json.dumps(result, ensure_ascii=False, indent=2) + '\n')
    print(json.dumps(result, ensure_ascii=False, indent=2))
