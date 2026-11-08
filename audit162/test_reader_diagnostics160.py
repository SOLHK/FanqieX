#!/usr/bin/env python3
"""Execute actual candidate ARM64 for passive reader touch diagnostics.

UIKit target registration/dispatch and weak deallocation are explicit boundary
fixtures. The test does not simulate physical hit testing, native presentation,
an iPhone, or real touch/action latency. Clock values are injected, not measured.
"""
import argparse
import hashlib
import json
from pathlib import Path
import traceback

from arm64 import CPU, require
from reader_diagnostics_runtime import ReaderDiagnosticsRuntime
from test_feed_viewport import labels_for


NEW = ('LDreader_attach', 'LDreader_detach', 'LDreader_touch', 'LDrscope',
       'LDrgeometry', 'LDrobserver_key', 'LDrcontrol_key', 'LDrowner_key',
       'LDrdown_key', 'LDrcontext_key', 'LDrlast_down_key', 'LDrbusy_key',
       'LDrclass_owned_key')
RUNS = []


def make(data, entries, slide=0, **options):
    rt = ReaderDiagnosticsRuntime(data, slide=slide, **options)
    cpu = CPU(data, rt, slide=slide,
              ranges=[(0x900, entries['Lcode_end']), (0x14080, entries['LXcode_end']),
                      (0x4878, 0x48d0), (0x7394, 0x746c)])
    cpu.pointers.update(rt.rebase_pointers)
    RUNS.append((cpu, rt))
    return cpu, rt


def run(cpu, entries, name, *args):
    return cpu.run(entries[name], args=list(args))


def fixture(rt, *, owner_class='FQReaderSaasNavigationView', control_class='UIButton',
            frame=(384, 0, 44, 44), bounds=None, material=(4, 4, 36, 36)):
    owner = rt.view(owner_class, 'reader_owner', (0, 64, 440, 72), rt.ROOT)
    control = rt.view(control_class, 'reader_control', frame, owner,
                      userInteractionEnabled=True, enabled=True,
                      target=rt.host, action=rt.sel('hostAction:'))
    if bounds is not None:
        rt.objects[control].state['bounds'] = tuple(bounds)
    if material is not None:
        glass = rt.view('UIVisualEffectView', 'reader_glass', material, control,
                        userInteractionEnabled=False)
        rt.associations[(control, rt.slide + 0xeb8b)] = glass
    rt.add_host(control)
    return owner, control


def observer(rt, entries, control):
    return rt.associations.get((control, rt.slide + entries['LDrobserver_key']), 0)


def records(rt):
    result = {}
    for pointer, obj in rt.objects.items():
        if not rt.is_kind(pointer, rt.classes['NSDictionary']):
            continue
        fields = obj.state.get('items', {})
        if 'sequence' not in fields or 'event' not in fields:
            continue
        if rt.string_value(fields['event']) == 'reader_touch':
            value = rt.native(pointer)
            result[value['sequence']] = value
    return [result[key] for key in sorted(result)]


def host_state(rt, control):
    state = rt.objects[control].state
    return {key: state.get(key) for key in ('frame', 'bounds', 'target', 'action',
                                          'enabled', 'userInteractionEnabled',
                                          'backgroundColor', 'alpha', 'hidden')}


def normal_pairs(data, entries):
    cases = []
    for slide in (0, 0x180000000):
        cpu, rt = make(data, entries, slide)
        owner, control = fixture(rt)
        before = host_state(rt, control)
        original_targets = list(rt.targets(control))
        require(run(cpu, entries, 'LDreader_attach', control, owner)['result'] == 1,
                'A visible exact reader owner can attach')
        observed = observer(rt, entries, control)
        require(observed and rt.observer_counts[observed] == 1,
                'Control association is the only owning observer reference')
        require(len(rt.targets(control)) == 5, 'Four passive targets added beside the host target')
        require(host_state(rt, control) == before, 'Attach changes no host control property')
        rt.events.clear()
        for _ in range(12):
            run(cpu, entries, 'LDreader_attach', control, owner)
        require(not any(e['event'] in ('add_target', 'remove_target') for e in rt.events),
                'Stable layouts never re-register or remove targets')
        rt.uptime = 1000.0
        rt.fire(cpu, control, 1)
        rt.uptime = 1000.25
        rt.fire(cpu, control, 64)
        logged = records(rt)
        require([r['data']['readerTouchPhase'] for r in logged] == ['down', 'upInside'],
                'One down and one upInside record')
        require(abs(logged[-1]['data']['readerTouchCallbackIntervalMs'] - 250) < 1e-7,
                'Injected 250 ms callback interval is calculated by candidate instructions')
        require('readerTouchCallbackIntervalMs' not in logged[0]['data'],
                'Down does not invent a completed interval')
        geometry = logged[0]['data']['readerTouchDownGeometry']
        require(geometry['readerControlBounds'] == [0, 0, 44, 44] and
                geometry['readerControlFrameInOwner'] == [384, 0, 44, 44],
                'Control and owner-coordinate rectangles are recorded')
        require(geometry['readerMaterialFrame'] == [4, 4, 36, 36] and
                geometry['readerMaterialWithinControlBounds'] == 1,
                'Native material extent is recorded against the actual hit bounds')
        require(geometry['readerOwnerClass'] == 'FQReaderSaasNavigationView' and
                geometry['readerControlRuntimeClass'] == 'UIButton', 'Exact runtime classes recorded')
        require('not host action or presentation timing' in
                logged[-1]['data']['readerTouchObservationScope'], 'Scope is explicit in each record')
        require(all(r['pluginVersion'] == '1.6.2' for r in logged), 'Existing versioned queue envelope is used')
        require(sum(e['event'] == 'host_action' for e in rt.events) == 1,
                'Original host action executes once')
        rt.fire(cpu, control, 64)
        require(len(records(rt)) == 2, 'Duplicate completion does not create a record')
        require(sum(e['event'] == 'host_action' for e in rt.events) == 2,
                'Duplicate host sendActions is not swallowed by diagnostics')
        run(cpu, entries, 'LDreader_detach', control)
        require(rt.targets(control) == original_targets, 'Detach removes only the private observer')
        require(observed in rt.dead, 'Observer deallocates after its control association is cleared')
        require(host_state(rt, control) == before, 'Detach preserves all host values')
        require(not any(e['event'] == 'method_setImplementation' for e in rt.events),
                'No host method is swizzled')
        cases.append({'slide': hex(slide), 'callback_records': 2, 'host_actions_preserved': True})
    return cases


def terminal_and_rate_budget(data, entries):
    cpu, rt = make(data, entries)
    owner, control = fixture(rt)
    run(cpu, entries, 'LDreader_attach', control, owner)
    for phase, event in (('upOutside', 128), ('cancel', 256)):
        rt.uptime += 1.0
        rt.fire(cpu, control, 1)
        rt.uptime += 0.1
        rt.fire(cpu, control, event)
        rt.fire(cpu, control, event)
        require(records(rt)[-1]['data']['readerTouchPhase'] == phase, 'Correct terminal event recorded')
    require(len(records(rt)) == 4, 'Only the first terminal callback consumes each down')
    start = rt.uptime + 1
    before = len(records(rt))
    for n in range(100):
        rt.uptime = start + n / 1000
        rt.fire(cpu, control, 1)
        rt.fire(cpu, control, 64)
    require(len(records(rt)) - before == 2, '100 synthetic rapid pairs produce one accepted pair')
    rt.uptime = start + 0.5
    rt.fire(cpu, control, 1)
    rt.uptime += 0.2
    rt.fire(cpu, control, 64)
    require(len(records(rt)) - before == 4, 'The next ordinary click is not permanently silenced')
    require(sum(e['event'] == 'host_action' for e in rt.events) == 101,
            'Rate limiting never suppresses original host targets')
    return {'rapid_pairs': 100, 'rapid_records': 2, 'next_click_records': 2}


def scope_and_geometry(data, entries):
    accepted = []
    for owner_class in ('FQReaderSaasNavigationView', 'SSReaderMenuView',
                        'FQReaderSaaSBottomToolView', 'SSNewAudioPlayControlView'):
        cpu, rt = make(data, entries)
        owner, control = fixture(rt, owner_class=owner_class)
        require(run(cpu, entries, 'LDreader_attach', control, owner)['result'] == 1,
                'Known reader owner accepted: ' + owner_class)
        accepted.append(owner_class)
    rejected = []
    for scenario in ('foreign_owner', 'shelf_owner', 'wrong_owner', 'off_window',
                     'hidden_owner', 'switch', 'slider', 'text', 'segment', 'not_control'):
        cpu, rt = make(data, entries)
        owner_class = {'foreign_owner': 'UIView', 'shelf_owner': 'SSBookShelfHeaderView'}.get(
            scenario, 'FQReaderSaasNavigationView')
        control_class = {'switch': 'UISwitch', 'slider': 'UISlider', 'text': 'UITextField',
                         'segment': 'UISegmentedControl', 'not_control': 'UIView'}.get(scenario, 'UIButton')
        owner, control = fixture(rt, owner_class=owner_class, control_class=control_class)
        expected = owner
        if scenario == 'wrong_owner':
            expected = rt.view('FQReaderSaasNavigationView', 'other_owner', (0, 0, 440, 44), rt.ROOT)
        elif scenario == 'off_window':
            rt.reparent(owner, 0)
        elif scenario == 'hidden_owner':
            rt.objects[owner].state['hidden'] = True
        before = list(rt.targets(control))
        require(run(cpu, entries, 'LDreader_attach', control, expected)['result'] == 0,
                'Out-of-scope fixture rejected: ' + scenario)
        require(rt.targets(control) == before and not observer(rt, entries, control),
                'Rejected attachment does not change existing target registrations')
        rejected.append(scenario)
    results = []
    for frame, bounds, material, fits in (
            ((404, 0, 24, 44), (0, 0, 24, 44), (-6, 4, 36, 36), 0),
            ((384, 0, 44, 44), (10, 20, 44, 44), (14, 24, 36, 36), 1)):
        cpu, rt = make(data, entries)
        owner, control = fixture(rt, frame=frame, bounds=bounds, material=material)
        run(cpu, entries, 'LDreader_attach', control, owner)
        rt.fire(cpu, control, 1)
        geometry = records(rt)[0]['data']['readerTouchDownGeometry']
        require(geometry['readerMaterialWithinControlBounds'] == fits,
                'Overflow test respects the actual nonzero bounds origin')
        results.append({'bounds': bounds, 'glass': material, 'within_bounds': fits})
    return {'accepted_owner_classes': accepted, 'rejected': rejected, 'geometry': results}


def disable_and_lifetime(data, entries):
    cases = []
    for scenario in ('disable_on_layout', 'disable_before_event', 'owner_death_down',
                     'owner_death_terminal', 'control_death', 'reparent_foreign'):
        cpu, rt = make(data, entries)
        owner, control = fixture(rt)
        host_rows = list(rt.targets(control))
        run(cpu, entries, 'LDreader_attach', control, owner)
        observed = observer(rt, entries, control)
        if scenario == 'owner_death_terminal':
            rt.fire(cpu, control, 1)
            rt.expire(owner)
            rt.uptime += .25
            rt.fire(cpu, control, 64)
            require(len(records(rt)) == 2, 'Terminal callback safely uses the down snapshot after owner death')
            run(cpu, entries, 'LDreader_detach', control)
        elif scenario == 'control_death':
            rt.expire(control)
        elif scenario == 'owner_death_down':
            rt.expire(owner)
            rt.fire(cpu, control, 1)
            require(not records(rt), 'Expired weak owner cannot be messaged or logged as active')
        elif scenario == 'reparent_foreign':
            foreign = rt.view('UIView', 'foreign_owner', (0, 0, 440, 44), rt.ROOT)
            rt.reparent(control, foreign)
            rt.fire(cpu, control, 1)
            require(not records(rt), 'Reused foreign control loses passive targets on next event')
        else:
            rt.objects[rt.DEFAULTS].state['values']['FanqieAdBlock.GlassDisabled.1'] = 1
            if scenario == 'disable_on_layout':
                run(cpu, entries, 'LDreader_attach', control, owner)
            else:
                rt.fire(cpu, control, 1)
            require(not records(rt), 'Disable creates no reader touch record')
        require(observed in rt.dead and rt.observer_counts[observed] == 0,
                'Private observer is released in ' + scenario)
        if scenario != 'control_death':
            require(rt.targets(control) == host_rows, 'Lifetime cleanup preserves host registrations')
        require(not observer(rt, entries, control), 'No stale observer remains associated')
        cases.append(scenario)
    return cases


def host_ordering_and_reentry(data, entries):
    intervals = []
    for observer_first in (False, True):
        cpu, rt = make(data, entries)
        owner, control = fixture(rt)
        run(cpu, entries, 'LDreader_attach', control, owner)
        rt.uptime = 1000
        rt.fire(cpu, control, 1)
        def host_delay(_cpu, _control):
            rt.uptime += 1.5       # explicit fixture, not measured device time
            rt.reparent(owner, 0)
        rt.host_callback = host_delay
        rt.uptime = 1000.2
        rt.fire(cpu, control, 64, observer_first=observer_first)
        require(len(records(rt)) == 2, 'Detached reader completion still uses immutable down geometry')
        value = records(rt)[-1]['data']['readerTouchCallbackIntervalMs']
        expected = 200 if observer_first else 1700
        require(abs(value - expected) < 1e-6, 'Callback-order fixture is explicit in the recorded interval')
        require(sum(e['event'] == 'host_action' for e in rt.events) == 1,
                'Each host action executes exactly once in either target order')
        intervals.append({'observer_first': observer_first, 'injected_callback_interval_ms': value})
    cpu, rt = make(data, entries)
    owner, control = fixture(rt)
    run(cpu, entries, 'LDreader_attach', control, owner)
    observed = observer(rt, entries, control)
    nested = []
    def reenter(current_cpu, event):
        if not nested and event['event'] == 'set_association' and event.get('self') == observed and \
                event.get('key') == entries['LDrdown_key'] and event.get('value'):
            nested.append(True)
            run(current_cpu, entries, 'LDreader_touch', observed, rt.sel('fqab160_readerTouchUpInside:'),
                control, 1)
    rt.on_event = reenter
    rt.fire(cpu, control, 1)
    rt.on_event = None
    rt.uptime += .2
    rt.fire(cpu, control, 64)
    require(nested and len(records(rt)) == 2, 'Synchronous nested callback cannot consume the outer pair')
    require(not rt.associations.get((observed, entries['LDrbusy_key'])), 'Outer callback clears its busy marker')
    return {'target_ordering': intervals, 'reentrant_callback_guarded': True}


def allocation_and_class_collision(data, entries):
    cases = []
    for options in ({'observer_alloc_nil': True}, {'weak_fail_at': 1}, {'weak_fail_at': 2}, {'foreign_class': True}):
        options = dict(options)
        foreign = options.pop('foreign_class', False)
        cpu, rt = make(data, entries, **options)
        owner, control = fixture(rt)
        before = list(rt.targets(control))
        if foreign:
            rt._class(rt.OBSERVER, 'NSObject')
        require(run(cpu, entries, 'LDreader_attach', control, owner)['result'] == 0,
                'Allocation failure or foreign class collision fails closed')
        require(rt.targets(control) == before and not observer(rt, entries, control),
                'Failed initialization leaves host controls and target list intact')
        cases.append(options or {'foreign_class': True})
    return cases


def off_main_is_noop(data, entries):
    cpu, rt = make(data, entries)
    owner, control = fixture(rt)
    run(cpu, entries, 'LDreader_attach', control, owner)
    observed = observer(rt, entries, control)
    targets_before = list(rt.targets(control))
    associations_before = dict(rt.associations)
    counts_before = dict(rt.observer_counts)
    rt.events.clear()
    rt.thread = 'worker'
    require(run(cpu, entries, 'LDreader_attach', control, owner)['result'] == 0,
            'Background attach is rejected before looking at a view')
    run(cpu, entries, 'LDreader_detach', control)
    run(cpu, entries, 'LDreader_touch', observed, rt.sel('fqab160_readerTouchDown:'), control, 0)
    require(rt.targets(control) == targets_before and rt.associations == associations_before and
            rt.observer_counts == counts_before, 'All three public entries are nonmutating off main')
    require(not rt.events and not records(rt), 'Off-main calls do not read UIKit or enqueue events')
    rt.thread = 'main'
    run(cpu, entries, 'LDreader_detach', control)
    return {'public_entries_checked': 3, 'off_main_view_accesses': 0}


def main():
    parser = argparse.ArgumentParser(description=__doc__)
    parser.add_argument('--candidate', type=Path, required=True)
    parser.add_argument('--report', type=Path)
    args = parser.parse_args()
    data = args.candidate.read_bytes()
    report = {'passed': False, 'candidate_sha256': hashlib.sha256(data).hexdigest(),
              'scope': 'Actual ARM64 executed against UIControl/Foundation boundary fixtures',
              'device_tested': False, 'physical_hit_testing_tested': False,
              'host_action_or_presentation_latency_measured': False, 'cases': []}
    try:
        entries = labels_for(data, args.candidate.with_suffix('.composed.s'), NEW)
        for name, test in (
                ('normal_pairs', normal_pairs), ('terminal_and_rate_budget', terminal_and_rate_budget),
                ('scope_and_geometry', scope_and_geometry), ('disable_and_lifetime', disable_and_lifetime),
                ('host_ordering_and_reentry', host_ordering_and_reentry),
                ('allocation_and_class_collision', allocation_and_class_collision),
                ('off_main_is_noop', off_main_is_noop)):
            detail = test(data, entries)
            report['cases'].append({'name': name, 'passed': True, 'detail': detail})
        report['passed'] = True
    except Exception:
        report['error'] = traceback.format_exc()
        print(report['error'])
    report['case_groups'] = len(report['cases'])
    report['instructions'] = sum(cpu.steps for cpu, _ in RUNS)
    report['abi_checks'] = 'Every invocation preserves x18/x19-x29, d8-d15 and balanced SP; framework calls poison caller-saved registers.'
    path = args.report or args.candidate.with_suffix('.reader-touch-audit.json')
    path.parent.mkdir(parents=True, exist_ok=True)
    path.write_text(json.dumps(report, ensure_ascii=False, indent=2) + '\n')
    print(json.dumps({k: report[k] for k in ('passed', 'case_groups', 'instructions', 'candidate_sha256')}))
    return 0 if report['passed'] else 1


if __name__ == '__main__':
    raise SystemExit(main())
