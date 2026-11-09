#!/usr/bin/env python3
"""Execute the startup journal's real ARM64 with explicit Foundation boundaries.

Filesystem bytes are real temporary files. The Objective-C runtime and Foundation
remain modeled; this does not establish dyld loading or iPhone crash recovery.
"""
import argparse
import hashlib
import json
from pathlib import Path
import plistlib
import struct
import tempfile
import uuid

from arm64 import CPU, require, release_version
from mock_foundation import Runtime as FoundationRuntime
from test_feed_viewport import labels_for
from test_native_diagnostics164 import Runtime as NativeRuntime


PRIVATE = 'PRIVATE_COOKIE_TOKEN_COMMENT_ACCOUNT_PATH_MUST_NOT_SURVIVE'
STARTUP = ('entry', 'diagnosticsInstallBegin', 'diagnosticsInstallComplete',
           'startupPopupInstalled', 'legacyHooksInstalled', 'loadFinished')


class Runtime(FoundationRuntime):
    def __init__(self, *args, **kwargs):
        self.serializations = []
        super().__init__(*args, **kwargs)

    def serialization(self, cpu, receiver, name, arguments):
        self.serializations.append((self.thread, name))
        return super().serialization(cpu, receiver, name, arguments)


def machine(data, runtime, slide=0):
    words = struct.unpack_from('<64I', data, 0x800)
    cpu = CPU(data, runtime, slide, ranges=[(0x900, 0x800 + words[55]),
                                         (0x14080, 0x800 + words[61]),
                                         (0x4878, 0x48d0), (0x7394, 0x746c)])
    cpu.pointers.update(runtime.rebase_pointers)
    return cpu


def make(data, disk_root=None, slide=0):
    runtime = Runtime(data, slide, disk_root=disk_root)
    runtime.objects[runtime.MAIN_BUNDLE].state['info'] = {
        'CFBundleShortVersionString': '7.4.3', 'CFBundleVersion': '74301'}
    return machine(data, runtime, slide), runtime


def stage(cpu, runtime, labels, data, name):
    address = data.index(name.encode() + b'\0')
    cpu.run(labels['LFQD_FQDLoadStage'], args=(runtime.slide + address,))


def summary(cpu, runtime, labels):
    pointer = cpu.run(labels['LFQD_FQDLoadSummary'])['result']
    return runtime.native(pointer)


def path(runtime):
    return runtime.disk_root / 'Documents' / 'FanqieX' / 'load-diagnostics.json'


def saved(runtime):
    raw = path(runtime).read_bytes()
    require(len(raw) <= 32768, 'Startup journal stays within its fixed 32 KiB file cap')
    return json.loads(raw)


def write_seed(runtime, value, *, exact_size=None):
    target = path(runtime)
    target.parent.mkdir(parents=True, exist_ok=True)
    raw = json.dumps(value).encode()
    if exact_size is not None:
        require(len(raw) <= exact_size, 'Seed fits requested exact file size')
        raw += b' ' * (exact_size - len(raw))
    target.write_bytes(raw)


def load_order(data, labels, slide):
    cpu, runtime = make(data, slide=slide)
    for index, name in enumerate(STARTUP):
        stage(cpu, runtime, labels, data, name)
        current = saved(runtime)
        require([row['stage'] for row in current['stages']] == list(STARTUP[:index + 1]),
                'Each synchronous checkpoint records the stages that actually completed')
        require(current['stage'] == name and current['complete'] == 0,
                'Returning from the constructor does not imply a usable first page')
        runtime.now += 0.1
    require(current['version'] == release_version(data) and current['hostVersion'] == '7.4.3' and
            current['hostBuild'] == '74301', 'Journal identifies plugin and host build')
    uuid.UUID(current['sessionId'])
    require(current['previousRead'] == 'absent', 'A clean first launch has no previous attempt')
    stage(cpu, runtime, labels, data, 'firstPageDidAppear')
    current = saved(runtime)
    require(current['complete'] == 1 and current['stage'] == 'firstPageDidAppear',
            'Only a first-page appearance establishes startup completion')
    require([row['time'] for row in current['stages']] ==
            sorted(row['time'] for row in current['stages']), 'Checkpoint times retain call order')
    writes = sum(event['event'] == 'write_file' for event in runtime.events)
    stage(cpu, runtime, labels, data, 'firstPageDidAppear')
    stage(cpu, runtime, labels, data, 'loadFinished')
    require(sum(event['event'] == 'write_file' for event in runtime.events) == writes,
            'Completed startup stops synchronously writing during later page transitions')
    runtime.drain_operations(cpu)
    journal = runtime.disk_root / 'ApplicationSupport' / 'FanqieAdBlockDiagnostics' / 'recent.plist'
    rows = json.loads(plistlib.loads(journal.read_bytes())[0])
    require(sum(row['event'] == 'pluginLoad' for row in rows) == 1,
            'The regular asynchronous journal receives one completion summary')
    require(all(thread == 'worker' or operation in
                ('dataWithJSONObject:options:error:', 'JSONObjectWithData:options:error:',
                 'dataWithContentsOfURL:options:error:')
                for thread, operation in runtime.serializations),
            'Startup exception does not permit main-thread plist operations')
    return {'slide': hex(slide), 'stages': len(current['stages']), 'completion_event_once': True}


def restart(data, labels):
    with tempfile.TemporaryDirectory(prefix='fanqiex-load-restart-') as folder:
        cpu, runtime = make(data, folder)
        for name in STARTUP[:2]:
            stage(cpu, runtime, labels, data, name)
        first = saved(runtime)
        cpu2, second_runtime = make(data, folder)
        second_runtime.now += 60
        stage(cpu2, second_runtime, labels, data, 'entry')
        second = saved(second_runtime)
        require(second['sessionId'] != first['sessionId'], 'A new process gets a new load session')
        require(second['previous'] == {'stage': 'diagnosticsInstallBegin', 'complete': 0,
                                      'time': first['time'], 'version': release_version(data)},
                'A restart preserves the last completed checkpoint of an incomplete attempt')
        cpu3, third_runtime = make(data, folder)
        stage(cpu3, third_runtime, labels, data, 'entry')
        third = saved(third_runtime)
        require(set(third['previous']) == {'stage', 'complete', 'time', 'version'} and
                'previous' not in third['previous'], 'Repeated starts never nest attempt histories')
    return {'incomplete_attempt_preserved': True, 'sessions_distinct': True, 'no_nested_history': True}


def page_completion(data, labels, slide):
    runtime = NativeRuntime(data, slide)
    runtime.host_method('BDReaderViewController', 'viewDidAppear:', 'v20@0:8B16')
    cpu = machine(data, runtime, slide)
    stage(cpu, runtime, labels, data, 'entry')
    cpu.run(labels['LFQD_FQDInstall'])
    require(summary(cpu, runtime, labels)['complete'] == 0,
            'Installing hooks alone does not mark page readiness')
    page = runtime.obj('BDReaderViewController', 'first_reader_page')
    cpu.run(0xa5d4, args=(page, runtime.sel('viewDidAppear:'), 1))
    require(saved(runtime)['complete'] == 1, 'The actual page hook marks first-page completion')
    require(sum(name == 'viewDidAppear:' for _, name, _, _ in runtime.original_calls) == 1,
            'Load observation forwards the original page lifecycle call once')
    return {'slide': hex(slide), 'actual_page_hook': True, 'host_original_preserved': True}


def bounds(data, labels):
    cpu, runtime = make(data)
    for _ in range(4):
        for name in STARTUP:
            stage(cpu, runtime, labels, data, name)
    require(len(saved(runtime)['stages']) == 24, 'Exactly 24 stage records can be retained')
    stage(cpu, runtime, labels, data, 'entry')
    current = saved(runtime)
    require(len(current['stages']) == 24 and current['stagesTruncated'] == 1,
            'Further checkpoints report truncation without growing the journal')
    for _ in range(3):
        stage(cpu, runtime, labels, data, 'entry')
    require(len(saved(runtime)['stages']) == 24, 'Repeated overflow stays bounded')
    cpu2, large = make(data)
    target = path(large)
    target.parent.mkdir(parents=True)
    target.write_bytes(b'x' * 32769)
    stage(cpu2, large, labels, data, 'entry')
    require(saved(large)['previousRead'] == 'oversized', 'An oversized previous file is rejected')
    require(not any(name == 'dataWithContentsOfURL:options:error:'
                    for _, name in large.serializations),
            'The size check rejects oversized history before allocating its data')
    return {'stage_cap': 24, 'file_cap': 32768, 'oversize_rejected_before_read': True}


def privacy_and_validation(data, labels):
    seed = {'version': release_version(data), 'stage': 'loadFinished', 'complete': 0, 'time': 1234,
            'previous': {'previous': {'Cookie': PRIVATE}}, 'Authorization': PRIVATE,
            'sessionId': PRIVATE, 'osVersion': PRIVATE, 'path': PRIVATE}
    cpu, runtime = make(data)
    write_seed(runtime, seed, exact_size=32768)
    stage(cpu, runtime, labels, data, 'entry')
    current = saved(runtime)
    require(current['previousRead'] == 'loaded' and
            set(current['previous']) == {'stage', 'complete', 'time', 'version'},
            'Only four allowlisted fields survive a valid maximum-size prior file')
    encoded = json.dumps(summary(cpu, runtime, labels))
    require(PRIVATE not in encoded and str(runtime.disk_root) not in encoded,
            'Neither private prior fields nor a container path enter the exported summary')
    invalid = [dict(seed, version=42), dict(seed, stage=PRIVATE),
               dict(seed, complete=PRIVATE), dict(seed, time=PRIVATE), [seed]]
    for value in invalid:
        trial_cpu, trial_runtime = make(data)
        write_seed(trial_runtime, value)
        stage(trial_cpu, trial_runtime, labels, data, 'entry')
        trial = saved(trial_runtime)
        require(trial['previousRead'] == 'invalid' and 'previous' not in trial,
                'Edited fields are type-checked and rejected without forwarding arbitrary text')
    return {'exact_32k_read': True, 'invalid_forms': len(invalid), 'private_fields_omitted': True}


def failures(data, labels):
    results = []
    for flag, failure in (('fail_write', 'writeFailed'), ('fail_directory', 'directoryFailed'),
                          ('fail_json', 'serializationFailed')):
        cpu, runtime = make(data)
        setattr(runtime, flag, True)
        stage(cpu, runtime, labels, data, 'entry')
        current = summary(cpu, runtime, labels)
        require(current['writeFailed'] == 1 and current['writeFailure'] == failure,
                'A failed load-journal write remains available from in-memory export state')
        require(not path(runtime).exists(), 'A failed first write is not reported as a durable file')
        setattr(runtime, flag, False)
        stage(cpu, runtime, labels, data, 'diagnosticsInstallBegin')
        recovered = saved(runtime)
        require(recovered['writeFailed'] == 1 and recovered['stage'] == 'diagnosticsInstallBegin',
                'Later progress retries persistence while preserving the earlier failure')
        results.append(failure)
    return {'write_failures_observed_and_recovered': results}


def worker_scope(data, labels):
    cpu, runtime = make(data)
    stage(cpu, runtime, labels, data, 'entry')
    require(any(event['event'] == 'load_storage_directory' and event['directory'] == 9
                for event in runtime.events), 'The independent boot journal actually selects Documents')
    bad = runtime.box({'version': release_version(data), 'event': 'ordinary_diagnostic'}, mutable=True)
    arguments = [runtime.classes['NSJSONSerialization'],
                 runtime.sel('dataWithJSONObject:options:error:'), bad, 0, 0, 0, 0, 0]
    try:
        runtime.serialization(cpu, arguments[0], 'dataWithJSONObject:options:error:', arguments)
    except AssertionError:
        pass
    else:
        raise AssertionError('An ordinary event must not serialize on the main thread')
    other = runtime.url(runtime.disk_root / 'ApplicationSupport' / 'recent.plist')
    arguments[2] = other
    try:
        runtime.serialization(cpu, arguments[0], 'dataWithContentsOfURL:options:error:', arguments)
    except AssertionError:
        pass
    else:
        raise AssertionError('The startup exception must not permit other main-thread file reads')
    return {'ordinary_json_requires_worker': True, 'other_paths_require_worker': True}


def main():
    parser = argparse.ArgumentParser(description=__doc__)
    parser.add_argument('--candidate', type=Path, required=True)
    parser.add_argument('--report', type=Path, required=True)
    args = parser.parse_args()
    data = args.candidate.read_bytes()
    labels = labels_for(data, args.candidate.with_suffix('.composed.s'),
                        ['LFQD_FQDLoadStage', 'LFQD_FQDLoadSummary', 'LFQD_FQDInstall'])
    cases = []
    for slide in (0, 0x180000000):
        cases.append({'order': load_order(data, labels, slide)})
        cases.append({'page_completion': page_completion(data, labels, slide)})
    cases.extend([{'restart': restart(data, labels)}, {'bounds': bounds(data, labels)},
                  {'privacy': privacy_and_validation(data, labels)},
                  {'failures': failures(data, labels)}, {'worker_scope': worker_scope(data, labels)}])
    report = {'passed': True, 'candidate_sha256': hashlib.sha256(data).hexdigest(),
              'cases': cases, 'device_tested': False, 'native_foundation_executed': False,
              'scope': 'Real ARM64 startup checkpoints with explicit Foundation boundaries'}
    args.report.parent.mkdir(parents=True, exist_ok=True)
    args.report.write_text(json.dumps(report, indent=2) + '\n')
    print(json.dumps({'passed': True, 'case_groups': len(cases),
                      'candidate_sha256': report['candidate_sha256']}, indent=2))


if __name__ == '__main__':
    main()
