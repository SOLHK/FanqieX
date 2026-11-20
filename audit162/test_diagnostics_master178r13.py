#!/usr/bin/env python3
"""Run the R13 diagnostics policy, storage, and export against linked ARM64."""
import argparse
import hashlib
import json
from pathlib import Path

from arm64 import release_version, require
from test_diagnostic_dedup import entries
from test_feed_viewport import labels_for
from test_load_diagnostics164 import machine, path, stage, write_seed
from test_native_diagnostics164 import Runtime, send


PREFERENCE = 'FanqieX.DiagnosticsEnabled'
ACTION = 'sendAction:to:from:forEvent:'
SYMBOLS = ('LUIexport', 'Lrecord_named', 'LFQD_FQDInitDiagnosticsPolicy',
           'LFQD_FQDLoadStage', 'LFQD_FQDInstall', 'LFQD_FQDDiagnosticsEnabled',
           'LFQD_FQDSetDiagnosticsEnabled')


class MasterRuntime(Runtime):
    def handle(self, cpu, pc):
        if pc - self.slide == 0xa5d4:
            receiver = cpu.x[0]
            name = self.selector_names.get(cpu.x[1])
            if receiver == self.classes['NSObject'] and name == 'cancelPreviousPerformRequestsWithTarget:':
                self.delayed[:] = [job for job in self.delayed if job[0] != cpu.x[2]]
                return self.finish(cpu)
            if name == 'bounds' and receiver in self.objects and self.is_kind(receiver, self.UIView):
                return self.finish(cpu, fp=self.objects[receiver].state['bounds'])
        return super().handle(cpu, pc)


def export_retained(runtime, cpu, symbols, directory, slide, settings, export_button):
    callback = runtime.sel('fqab_156_presentDiagnostics:')
    runtime._add(runtime.classes['UIViewController'], 'fqab_156_presentDiagnostics:',
                 slide + directory['ui_present'], 'v24@0:8@16')
    cpu.run(symbols['LUIexport'], settings, runtime.sel('fqab_156_exportDiagnostics:'), export_button)
    runtime.drain_operations(cpu)
    jobs = [job for job in runtime.main_jobs if job[:2] == (settings, callback)]
    require(len(jobs) == 1, 'Manual export completes once while diagnostics are disabled')
    contents = runtime.native(jobs[0][2])
    output = json.loads(Path(contents['url']).read_text(encoding='utf-8'))
    runtime.flush_main(cpu)
    activity = runtime.objects[settings].state['presentedViewController']
    anchor = runtime.objects[runtime.objects[activity].state['popover']].state
    require(anchor['source_view'] == export_button and anchor['source_rect'] == (0, 0, 110, 40),
            'Share popover anchors to the bottom export button bounds')
    return output


def exercise(data, symbols, slide):
    default_on = release_version(data) in ('1.78R14', '1.78R15', '1.78R16', '1.78R25', "1.78R26", "1.78R27", "1.78R28", "1.78R29", "1.78R30", "1.78R31", "1.78R32", "1.78R33", "1.78R34", "1.78R35", "1.78R36", "1.79R1", "1.79R2", "1.79R3", "1.79R4", "1.79R5", "1.8R1", "1.8R2", "1.8R3", "1.8R4", "1.8R5", "1.8R6", "1.8R7", "1.8R8", "1.8R9", "1.8R10", "1.8R11", "1.8R12", "1.8R13", "1.8R14", "1.8R15", "1.8R16", "1.8R17", "1.8R18", "1.8R19", "1.8R19", "1.9.1beta1")
    initial = MasterRuntime(data, slide, diagnostics_enabled=False)
    initial_cpu = machine(data, initial, slide)
    initial_prefs = initial.objects[initial.DEFAULTS].state['values']
    initial_prefs['FanqieX.EnhancedDiagnostics.1'] = True
    initial_cpu.run(symbols['LFQD_FQDInitDiagnosticsPolicy'])
    require(PREFERENCE not in initial_prefs and
            bool(initial_cpu.run(symbols['LFQD_FQDDiagnosticsEnabled'])['result']) == default_on,
            'Missing preference uses the release default without persisting a choice')
    initial_action = initial.hosts_for('UIApplication', ACTION)
    initial_cpu.run(symbols['LFQD_FQDInstall'])
    active_imp = initial.methods[initial.get_method(initial.classes['UIApplication'],
                                                    initial.sel(ACTION))]['imp']
    require((active_imp != initial_action) == default_on,
            'Default-on startup enables the enhanced action hook')

    runtime = MasterRuntime(data, slide, diagnostics_enabled=False)
    cpu = machine(data, runtime, slide)
    directory = entries(data)
    prefs = runtime.objects[runtime.DEFAULTS].state['values']
    prefs[PREFERENCE] = False
    app = runtime.obj('UIApplication', 'app')
    page = runtime.obj('UIViewController', 'page')
    control = runtime.view('UIControl', 'test control', (5, 10, 44, 52), runtime.ROOT)
    runtime.objects[control].state['nextResponder'] = page
    original_action = runtime.hosts_for('UIApplication', ACTION)
    action = runtime.sel('hostAction:')
    cpu.run(symbols['LFQD_FQDInitDiagnosticsPolicy'])
    require(prefs[PREFERENCE] is False and not cpu.run(symbols['LFQD_FQDDiagnosticsEnabled'])['result'],
            'The saved opt-out overrides the release default')
    cpu.run(symbols['LFQD_FQDInstall'])
    require(runtime.methods[runtime.get_method(runtime.classes['UIApplication'],
                            runtime.sel(ACTION))]['imp'] == original_action,
            'Opted-out startup installs no native action diagnostics hook')
    require(send(cpu, runtime, app, ACTION, action, page, control, 0)['result'] == 1,
            'Host action works while diagnostics are off')
    stage(cpu, runtime, symbols, data, 'entry')
    cpu.run(directory['diagnostic_observe'], runtime.BAR)
    cpu.run(directory['diagnostic_tick'])
    require(not runtime.main_jobs and not runtime.queued_operations and not path(runtime).exists(),
            'Opted-out startup, viewport observation and periodic callback capture nothing')

    cpu.run(symbols['LFQD_FQDSetDiagnosticsEnabled'], 1)
    runtime.flush_main(cpu)
    timers = [event for event in runtime.events if event['event'] == 'scheduled_timer']
    require(prefs[PREFERENCE] is True and len(timers) == 1,
            'User opt-in persists and starts exactly one scheduler')
    require(send(cpu, runtime, app, ACTION, action, page, control, 0)['result'] == 1
            and len(runtime.delayed) == 1,
            'A single opt-in enables enhanced action observation immediately')
    stage(cpu, runtime, symbols, data, 'entry')
    runtime.drain_operations(cpu)
    journal = runtime.disk_root / 'ApplicationSupport' / 'FanqieAdBlockDiagnostics' / 'recent.plist'
    retained = journal.read_bytes()
    stage_bytes = path(runtime).read_bytes()

    cpu.run(symbols['Lrecord_named'], slide + data.index(b'bottom_bar_state_changed\0'), 0)
    require(runtime.queued_operations, 'Fixture queues work before opt-out')
    cpu.run(symbols['LFQD_FQDSetDiagnosticsEnabled'], 0)
    require(prefs[PREFERENCE] is False and not runtime.delayed and
            sum(event['event'] == 'invalidated_timer' for event in runtime.events) == 1,
            'Opt-out persists and cancels both the periodic and action callbacks')
    require(send(cpu, runtime, app, ACTION, action, page, control, 0)['result'] == 1
            and not runtime.delayed,
            'Installed native action hook forwards without new observation after opt-out')
    stage(cpu, runtime, symbols, data, 'diagnosticsInstallBegin')
    cpu.run(directory['diagnostic_tick'])
    runtime.drain_operations(cpu)
    require(journal.read_bytes() == retained and path(runtime).read_bytes() == stage_bytes,
            'Opt-out drops pending capture and preserves both durable logs')
    require(sum(name == ACTION for _, name, _, _ in runtime.original_calls) == 3,
            'Host actions forwarded once during each policy state')

    write_seed(runtime, {'version': '1.78R12', 'stage': 'loadFinished', 'complete': 0,
                         'time': runtime.now, 'privateText': 'arbitrary input'})
    stage_bytes = path(runtime).read_bytes()
    fresh = MasterRuntime(data, slide, disk_root=runtime.disk_root, diagnostics_enabled=False)
    fresh.objects[fresh.DEFAULTS].state['values'][PREFERENCE] = prefs[PREFERENCE]
    fresh_cpu = machine(data, fresh, slide)
    settings = fresh.obj('UIViewController', 'settings', view=fresh.ROOT)
    export_button = fresh.view('UIButton', 'export button', (10, 20, 110, 40), fresh.ROOT)
    fresh_cpu.run(symbols['LFQD_FQDInitDiagnosticsPolicy'])
    output = export_retained(fresh, fresh_cpu, symbols, directory, slide, settings, export_button)
    require(not any(event['event'] == 'scheduled_timer' for event in fresh.events),
            'Export from a fresh opted-out process does not start its scheduler')
    names = [record['event'] for record in output['entries']]
    require(names == ['uiActionBegin', 'uiActionReturned'] and 'export_snapshot' not in names,
            'Off-mode export reads retained rows from disk without sampling new rows')
    require('arbitrary input' not in json.dumps(output) and journal.read_bytes() == retained and
            path(fresh).read_bytes() == stage_bytes,
            'Off-mode export leaves both retained files byte-identical and sanitizes startup history')

    cpu.run(symbols['LFQD_FQDSetDiagnosticsEnabled'], 1)
    runtime.flush_main(cpu)
    require(sum(event['event'] == 'scheduled_timer' for event in runtime.events) == 2,
            'Re-enabling starts one fresh timer without duplicating hooks')
    return {'slide': hex(slide), 'default_on': default_on, 'enhanced_on_opt_in': True,
            'stopped_and_retained': True, 'explicit_export_preserved': True, 'popover_anchor': True}


def main():
    parser = argparse.ArgumentParser(description=__doc__)
    parser.add_argument('--candidate', type=Path, required=True)
    parser.add_argument('--report', type=Path, required=True)
    args = parser.parse_args()
    data = args.candidate.read_bytes()
    require(release_version(data) in ('1.78R13', '1.78R14', '1.78R15', '1.78R16', '1.78R25', "1.78R26", "1.78R27", "1.78R28", "1.78R29", "1.78R30", "1.78R31", "1.78R32", "1.78R33", "1.78R34", "1.78R35", "1.78R36", "1.79R1", "1.79R2", "1.79R3", "1.79R4", "1.79R5", "1.8R1", "1.8R2", "1.8R3", "1.8R4", "1.8R5", "1.8R6", "1.8R7", "1.8R8", "1.8R9", "1.8R10", "1.8R11", "1.8R12", "1.8R13", "1.8R14", "1.8R15", "1.8R16", "1.8R17", "1.8R18", "1.8R19", "1.8R19", "1.9.1beta1"), 'Exercise the linked master diagnostics policy')
    symbols = labels_for(data, args.candidate.with_suffix('.composed.s'), SYMBOLS)
    cases = [exercise(data, symbols, slide) for slide in (0, 0x180000000)]
    report = {'passed': True, 'candidate_sha256': hashlib.sha256(data).hexdigest(),
              'cases': cases, 'native_foundation_executed': False, 'device_tested': False}
    args.report.parent.mkdir(parents=True, exist_ok=True)
    args.report.write_text(json.dumps(report, indent=2) + '\n', encoding='utf-8')
    print(json.dumps(report, indent=2))


if __name__ == '__main__':
    main()
