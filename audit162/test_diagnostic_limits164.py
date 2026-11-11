#!/usr/bin/env python3
"""Execute bounded logger and export behavior from the 1.6.4 ARM64 image."""
import argparse
import json
import os
from pathlib import Path
import struct
import tempfile
import uuid

from arm64 import CPU, require
from mock_foundation import Runtime as FoundationRuntime
from test_diagnostic_dedup import SemanticBoundary, entries, journal, queue_export, exported_payload


class LimitsRuntime(SemanticBoundary, FoundationRuntime):
    def __init__(self, *args, **kwargs):
        self.fail_next_operation = False
        self.reads = []
        super().__init__(*args, **kwargs)

    def handle(self, cpu, pc):
        if pc - self.slide == 0xa5d4:
            receiver, selector = cpu.x[:2]
            name = self.selector_names.get(selector)
            if name == 'initWithTarget:selector:object:' and self.fail_next_operation:
                self.fail_next_operation = False
                return self.finish(cpu)
        return super().handle(cpu, pc)

    def serialization(self, cpu, receiver, name, arguments):
        self.reads.append(name)
        return super().serialization(cpu, receiver, name, arguments)


def make(data, disk_root=None):
    directory = entries(data)
    runtime = LimitsRuntime(data, disk_root=disk_root)
    cpu = CPU(data, runtime, ranges=[
        (0x900, directory['code_end']),
        (directory['extension'] + 128, directory['extension_code_end']),
        (0x4338, 0x43fc), (0x4704, 0x47dc), (0x4878, 0x48d0), (0x711c, 0x746c),
    ])
    cpu.pointers.update(runtime.rebase_pointers)
    marker = data.index(b'FQ164LIM')
    names = ('retained', 'persist', 'record', 'dropped_key', 'entries_key',
             'pending_key', 'session_key', 'scheduled_key')
    directory.update(zip(names, struct.unpack_from('<8I', data, marker + 8)))
    logger = cpu.run(directory['diagnostic_init'])['result']
    runtime.flush_main(cpu)
    runtime.drain_operations(cpu)
    return cpu, runtime, directory, logger


def associated(runtime, logger, directory, key):
    return runtime.associations.get((logger, directory[key]), 0)


def export(cpu, runtime, directory):
    target = queue_export(cpu, runtime, directory)
    runtime.drain_operations(cpu)
    jobs = [job for job in runtime.main_jobs if job[0] == target]
    require(len(jobs) == 1, 'Export always reports exactly one asynchronous completion')
    result = runtime.native(jobs[0][2])
    if 'url' not in result:
        require('error' in result and result['error'], 'Failed export supplies an explicit error')
        return result, None, None
    path = Path(result['url'])
    return result, json.loads(path.read_bytes()), path


def named_event_payloads(data):
    cpu, runtime, directory, _ = make(data)
    # Run the constructor's actual settings boot entry. It records plugin_start
    # with nil data, which Lrecord_named stores as NSNull in the envelope.
    cpu.run(0x4704)
    events = (
        ('scalar_payload', runtime.box('payload')),
        ('explicit_correlation', runtime.box({'correlationId': 'explicit'})),
        ('invalid_correlation', runtime.box({'correlationId': 7})),
    )
    for name, payload in events:
        cpu.run(directory['record'], runtime.string_pointer(name), payload)
    runtime.drain_operations(cpu)
    rows = journal(runtime)
    require([row['event'] for row in rows] == ['plugin_start', *(name for name, _ in events)],
            'The startup event and subsequent named events all persist')
    require(rows[0]['data'] is None and rows[1]['data'] == 'payload',
            'Nil and scalar payloads retain their original JSON shape')
    require(rows[2]['data'] == {'correlationId': 'explicit'} and rows[2]['correlationId'] == 'explicit',
            'An explicit string correlation survives unchanged')
    require(rows[3]['data'] == {'correlationId': 7},
            'An invalid correlation value does not rewrite the original payload')
    generated = {uuid.UUID(rows[index]['correlationId']) for index in (0, 1, 3)}
    require(len(generated) == 3, 'Missing or invalid correlations receive unique UUIDs')
    return {'startup_null_preserved': True, 'scalar_preserved': True,
            'explicit_correlation_preserved': True, 'generated_correlations': len(generated)}


def bounded_pending(data):
    cpu, runtime, directory, logger = make(data)
    require(any(e['event']=='add_common_timer' for e in runtime.events),
            'Hourly maintenance continues in common run-loop modes')
    for index in range(2048):
        cpu.run(directory['diagnostic_enqueue'], runtime.record(runtime.now, 'burst', index=index))
    pending = associated(runtime, logger, directory, 'pending_key')
    require(len(runtime.objects[pending].state['items']) == 2048, 'Pending cap accepts 2048 events')
    require(len(runtime.queued_operations) == 1, 'A burst shares one scheduled worker operation')
    cpu.run(directory['diagnostic_enqueue'], runtime.record(runtime.now, 'dropped'))
    target = queue_export(cpu, runtime, directory)
    require(len(runtime.objects[pending].state['items']) == 2048, 'Overflow and control requests stay bounded')
    failure = [job for job in runtime.main_jobs if job[0] == target]
    require(len(failure) == 1 and 'error' in runtime.native(failure[0][2]),
            'An export during a full queue receives a failure callback')
    runtime.drain_operations(cpu)
    require(len(journal(runtime)) == 2048, 'All admitted burst records persist')
    _, payload, _ = export(cpu, runtime, directory)
    require(payload['droppedRecords'] == 1 and payload['truncated'] == 1,
            'Dropped events stay visible independently of retained records')
    return {'accepted': 2048, 'dropped': 1, 'coalesced_worker': True, 'export_failure_callback': True}


def schedule_recovery(data):
    cpu, runtime, directory, logger = make(data)
    runtime.fail_next_operation = True
    cpu.run(directory['diagnostic_enqueue'], runtime.record(runtime.now, 'allocation_failure'))
    require(not runtime.queued_operations and not associated(runtime, logger, directory, 'scheduled_key'),
            'An allocation failure clears the scheduling flag')
    cpu.run(directory['diagnostic_enqueue'], runtime.record(runtime.now, 'recovery'))
    runtime.drain_operations(cpu)
    require([record['event'] for record in journal(runtime)] == ['allocation_failure', 'recovery'],
            'The next event retries the retained pending work')
    seen = []
    def producer_at_empty_unlock(machine, event):
        if seen or runtime.thread != 'worker' or event['event'] != 'unlock':
            return
        if associated(runtime, logger, directory, 'scheduled_key'):
            return
        pending = associated(runtime, logger, directory, 'pending_key')
        if runtime.objects[pending].state['items']:
            return
        seen.append(True)
        old_x, old_v, old_pc = machine.x[:], machine.v[:], machine.pc
        machine.run(directory['diagnostic_enqueue'], runtime.record(runtime.now, 'raced_producer'))
        machine.x[:], machine.v[:], machine.pc = old_x, old_v, old_pc
    runtime.on_event = producer_at_empty_unlock
    cpu.run(directory['diagnostic_enqueue'], runtime.record(runtime.now, 'before_empty'))
    runtime.drain_operations(cpu)
    require(seen and journal(runtime)[-1]['event'] == 'raced_producer',
            'A producer racing final worker unlock schedules a new drain')
    return {'allocation_retry': True, 'empty_queue_race': True}


def retention_and_bytes(data):
    cpu, runtime, directory, logger = make(data)
    rows = [runtime.record(runtime.now, 'seed', index=index) for index in range(8193)]
    array = associated(runtime, logger, directory, 'entries_key')
    runtime.objects[array].state['items'] = rows
    runtime.thread = 'worker'
    cpu.run(directory['retained'], logger)
    require(len(runtime.objects[array].state['items']) == 8192 and
            runtime.native(runtime.objects[array].state['items'][0])['index'] == 1,
            'Retention keeps the newest 8192 records')
    large = runtime.record(runtime.now, 'oversized', payload='x' * (8 * 1024 * 1024))
    latest = runtime.record(runtime.now, 'latest')
    runtime.objects[array].state['items'] = [large, latest]
    cpu.run(directory['persist'], logger)
    require([row['event'] for row in journal(runtime)] == ['latest'],
            'An oversized graph is trimmed to a fitting recent suffix')
    runtime.objects[array].state['items'] = [large]
    cpu.run(directory['persist'], logger)
    require(journal(runtime) == [], 'A single oversized record terminates with an empty bounded store')
    runtime.thread = 'main'
    _, payload, _ = export(cpu, runtime, directory)
    require(payload['droppedRecords'] == 3 and payload['truncated'] == 1 and payload['storageError'] != 'none',
            'Count and byte evictions are latched in export metadata')
    return {'retained_cap': 8192, 'serialized_cap_bytes': 8 * 1024 * 1024,
            'single_oversized_record_rejected': True}


def size_guard_and_sessions(data):
    with tempfile.TemporaryDirectory(prefix='fanqiex-limits-') as folder:
        root = Path(folder)
        path = root / 'ApplicationSupport' / 'FanqieAdBlockDiagnostics' / 'recent.plist'
        path.parent.mkdir(parents=True)
        with path.open('wb') as stream:
            stream.truncate(8 * 1024 * 1024 + 1025)
        cpu, runtime, directory, logger = make(data, folder)
        require('dataWithContentsOfURL:options:error:' not in runtime.reads,
                'Oversized saved file is rejected by metadata before reading or parsing')
        cpu.run(directory['diagnostic_enqueue'],
                runtime.record(runtime.now, 'correlated', data={'correlationId': 'open-close-1'}))
        cpu.run(directory['diagnostic_enqueue'], runtime.record(runtime.now, 'independent'))
        runtime.drain_operations(cpu)
        records = journal(runtime)
        require(records[0]['correlationId'] == 'open-close-1' and
                records[1]['correlationId'] != 'open-close-1' and
                records[0]['sessionId'] == records[1]['sessionId'],
                'Explicit correlation survives while unrelated events get a fresh ID')
        first_session = records[0]['sessionId']
        cpu2, runtime2, directory2, _ = make(data, folder)
        cpu2.run(directory2['diagnostic_enqueue'], runtime2.record(runtime2.now, 'new_session'))
        runtime2.drain_operations(cpu2)
        restarted = journal(runtime2)
        require(restarted[0] == records[0] and restarted[-1]['sessionId'] != first_session,
                'Restart preserves old envelope provenance and creates a new session ID')
        return {'pre_read_size_guard': True, 'session_stable': True,
                'restart_session_changed': True, 'explicit_correlation_preserved': True}


def exports_and_disk_errors(data):
    cpu, runtime, directory, _ = make(data)
    cpu.run(directory['diagnostic_enqueue'], runtime.record(runtime.now, 'persisted'))
    runtime.drain_operations(cpu)
    outputs = [export(cpu, runtime, directory) for _ in range(8)]
    require(all(payload is not None for _, payload, _ in outputs), 'Eight immutable exports are admitted')
    old_path = outputs[0][2]
    old_bytes = old_path.read_bytes()
    failure, payload, _ = export(cpu, runtime, directory)
    require(payload is None and 'Eight' in failure['error'] and old_path.read_bytes() == old_bytes,
            'A full export directory preserves existing share files and reports capacity')
    os.utime(old_path, (runtime.now - 3601, runtime.now - 3601))
    cpu.run(directory['diagnostic_maintenance'])
    runtime.drain_operations(cpu)
    require(not old_path.exists(), 'Maintenance removes expired exports without a new export request')
    _, payload, new_path = export(cpu, runtime, directory)
    require(payload is not None and not old_path.exists() and new_path.exists(),
            'Expired export is cleaned before a new immutable file is written')
    require(len(list(new_path.parent.glob('*.json'))) == 8, 'Export file count stays bounded')
    # An independent logger fixture leaves export capacity available for I/O failures.
    cpu, runtime, directory, _ = make(data)
    runtime.fail_write = True
    cpu.run(directory['diagnostic_enqueue'], runtime.record(runtime.now, 'disk_full'))
    runtime.drain_operations(cpu)
    runtime.fail_write = False
    runtime.fail_write_prefix = runtime.disk_root / 'tmp'
    failure, payload, _ = export(cpu, runtime, directory)
    require(payload is None and failure['error'], 'Export write failure returns an actionable error')
    runtime.fail_write_prefix = None
    _, payload, _ = export(cpu, runtime, directory)
    require(payload['storageError'] != 'none' and payload['entries'][0]['event'] == 'disk_full',
            'A successful retry retains records and the earlier write incident')
    return {'immutable_exports': 8, 'expired_cleanup': True,
            'export_failure_reported': True, 'disk_failure_latched_after_retry': True}


def main():
    parser = argparse.ArgumentParser(description=__doc__)
    parser.add_argument('candidate', type=Path)
    parser.add_argument('--report', type=Path)
    args = parser.parse_args()
    data = args.candidate.read_bytes()
    require(struct.unpack_from('<I', data, 0x818)[0] in (0x10604,0x10605,0x10606,0x10607,0x10701,0x10702,0x10703,0x10704, 0x14a00, 0x14b00), 'Expected actual 1.6.4')
    cases = {}
    for action in (named_event_payloads, bounded_pending, schedule_recovery, retention_and_bytes,
                   size_guard_and_sessions, exports_and_disk_errors):
        print('RUN ' + action.__name__, flush=True)
        cases[action.__name__] = action(data)
    report = {'passed': True, 'device_tested': False, 'cases': cases,
              'scope': 'ARM64 logger with Foundation, scheduling, file and JSON boundary models'}
    if args.report:
        args.report.parent.mkdir(parents=True, exist_ok=True)
        args.report.write_text(json.dumps(report, indent=2) + '\n', encoding='utf-8')
    print(json.dumps(report, indent=2))


if __name__ == '__main__':
    main()
