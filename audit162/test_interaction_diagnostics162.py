#!/usr/bin/env python3
"""Execute the candidate ARM64 selection-transition diagnostic helper.

The UIKit/Foundation calls are boundary fixtures. These tests check the emitted
record, bounded identity lookup, ABI, privacy, and absence of UI/navigation
mutations. They do not establish physical gesture recognition or GPU refraction.
"""
import argparse
import copy
import hashlib
import json
import math
from pathlib import Path
import struct
import traceback

from arm64 import CPU, release_version, require
from interaction_runtime import Runtime as InteractionRuntime, read_entries


RUNS = []
SENTINEL = 'PRIVATE_READER_CONTENT_MUST_NOT_BE_OBSERVED_162'
FIELD_NAMES = {'phase', 'glassSelectionLens', 'glassSelectionDragging',
               'glassSelectionFingerOffsetX', 'candidateIndex'}


def diagnostic_entries(data):
    marker = b'FQ162PAN'
    require(data.count(marker) == 1, 'One immutable interaction diagnostic directory')
    at = data.index(marker)
    version, count, entry, began, ended, cancelled = struct.unpack_from('<6I', data, at + 8)
    require(version == 0x10602 and count == 4, 'Versioned diagnostic directory')
    words = struct.unpack_from('<64I', data, 0x800)
    release_version(data)
    extension, end = 0x800 + words[60], 0x800 + words[63]
    extension_code_end = 0x800 + words[61]
    require(extension + 128 <= entry < extension_code_end and entry % 4 == 0,
            'Helper is an aligned entry in the executable extension')
    require(extension_code_end <= at < end, 'Directory is in the constant data region')
    result = {'record': entry, 'began': began, 'ended': ended, 'cancelled': cancelled}
    for phase in ('began', 'ended', 'cancelled'):
        pointer = result[phase]
        require(extension_code_end <= pointer < end, 'Phase CString is in mapped constant data')
        require(data[pointer:pointer + len(phase) + 1] == phase.encode() + b'\0',
                'Exact fixed phase string: ' + phase)
    return result


class Runtime(InteractionRuntime):
    """Observe imported calls without replacing the diagnostic implementation."""

    def __init__(self, *args, **kwargs):
        self.messages = []
        self.association_reads = []
        self.private_views = set()
        self.guard_reads = False
        super().__init__(*args, **kwargs)

    def handle(self, cpu, pc):
        local = pc - self.slide
        if self.guard_reads and local == 0xa628:
            receiver, key = cpu.x[:2]
            self.association_reads.append((receiver, key))
            require(key != self.slide + 0xeb87,
                    'Diagnostics must not read or follow the nonretaining bound-bar association')
        if self.guard_reads and local == 0xa5d4:
            receiver, selector = cpu.x[:2]
            name = self.selector_names.get(selector)
            self.messages.append((receiver, name))
            require(receiver not in self.private_views,
                    'No original button, label, or reader-content receiver is messaged')
            require(name != 'subviews', 'The bounded helper must never walk a view subtree')
            if receiver in self.objects and (
                    self.is_kind(receiver, self.UIView) or
                    self.is_kind(receiver, self.classes['CALayer']) or
                    self.is_kind(receiver, self.classes['UIGlassEffect'])):
                require(not name or not name.startswith('set'),
                        'Diagnostics must not invoke a UIKit/layer/material setter: ' + str(name))
                require(name not in ('addSubview:', 'removeFromSuperview',
                                     'bringSubviewToFront:', 'sendSubviewToBack:',
                                     'addGestureRecognizer:', 'removeGestureRecognizer:'),
                        'Diagnostics must not change view/gesture ownership')
        return super().handle(cpu, pc)


def make(data, slide=0):
    entries = read_entries(data)
    diag = diagnostic_entries(data)
    rt = Runtime(data, entries, slide=slide)
    cpu = CPU(data, rt, slide=slide,
              ranges=[(0x900, entries['main_code_end']),
                      (0x14080, entries['extension_code_end']),
                      (0x4878, 0x48d0), (0x7394, 0x746c)])
    cpu.pointers.update(rt.rebase_pointers)
    # An explicit owned-lens fixture avoids turning this focused helper test
    # into a second implementation of UIPanGestureRecognizer or LIupdate.
    overlay = rt.view('UIView', 'owned_overlay', (12, 0, 416, 56), rt.BAR)
    lens = rt.view('UIVisualEffectView', 'owned_selection_lens', (208, 4, 102, 48), overlay,
                   userInteractionEnabled=False)
    content = rt.view('UIView', 'owned_lens_content', (0, 0, 102, 48), lens)
    private_label = rt.view('UILabel', 'private_reader_text', (0, 0, 102, 48), content,
                           text=SENTINEL, accessibilityLabel=SENTINEL)
    effect = rt.obj('UIGlassEffect', 'stable_clear_lens_effect',
                    style=1, tintColor=0, interactive=True)
    rt.objects[lens].state.update(contentView=content, effect=effect)
    rt.layer(lens)  # The boundary fixture lazily allocates layers; UIKit owns one already.
    controller = rt.obj('NSObject', 'owned_interaction_controller')
    rt.associations[(rt.PROXY, rt.key('overlay'))] = overlay
    rt.associations[(rt.PROXY, rt.key('lens'))] = lens
    rt.associations[(rt.PROXY, rt.key('controller'))] = controller
    rt.associations[(controller, rt.key('drag'))] = controller
    rt.associations[(controller, rt.key('offset'))] = rt.box(17.25)
    for button in rt.buttons:
        rt.objects[button].state.update(text=SENTINEL, accessibilityLabel=SENTINEL)
    rt.objects[rt.LABEL].state['text'] = SENTINEL
    rt.private_views = set(rt.buttons + [rt.LABEL, private_label])
    rt.guard_reads = True
    RUNS.append((cpu, rt))
    return cpu, rt, diag, lens, controller


def records(rt):
    result = {}
    for pointer, obj in rt.objects.items():
        if not rt.is_kind(pointer, rt.classes['NSDictionary']):
            continue
        fields = obj.state.get('items', {})
        if 'sequence' not in fields or 'event' not in fields:
            continue
        if rt.string_value(fields['event']) == 'glassInteraction':
            value = rt.native(pointer)
            result[value['sequence']] = value
    return [result[key] for key in sorted(result)]


def call(cpu, rt, diag, phase, candidate=0, proxy=None):
    phase_pointer = rt.slide + diag[phase] if isinstance(phase, str) else phase
    return cpu.run(diag['record'], rt.PROXY if proxy is None else proxy,
                   phase_pointer, candidate, max_steps=1000000)


def frozen_ui(rt):
    return {pointer: copy.deepcopy(obj.state) for pointer, obj in rt.objects.items()
            if rt.is_kind(pointer, rt.UIView) or
            rt.is_kind(pointer, rt.classes['CALayer']) or
            rt.is_kind(pointer, rt.classes['UIGlassEffect'])}


def owned_associations(rt, controller):
    return {key: value for key, value in rt.associations.items()
            if key[0] in (rt.PROXY, controller)}


def inspect_record(record, data):
    require(record['event'] == 'glassInteraction' and record['pluginVersion'] == release_version(data),
            'The existing versioned diagnostic queue envelope is reused')
    require(set(record['data']) == FIELD_NAMES, 'Only the five bounded diagnostic fields are present')
    encoded = json.dumps(record, ensure_ascii=False, allow_nan=False)
    require(SENTINEL not in encoded, 'No reader text or accessibility labels enter the JSON record')
    require(len(encoded.encode('utf-8')) < 4096, 'One metadata-only record stays bounded')
    return record['data']


def transitions_and_nonmutation(data):
    result = []
    for slide in (0, 0x180000000):
        cpu, rt, diag, lens, controller = make(data, slide)
        baseline, associations = frozen_ui(rt), owned_associations(rt, controller)
        call(cpu, rt, diag, 'began')
        first = inspect_record(records(rt)[-1], data)
        require(first['phase'] == 'began' and first['glassSelectionDragging'] == 1,
                'Began records the actual owned drag state')
        require(first['glassSelectionFingerOffsetX'] == 17.25 and first['candidateIndex'] is None,
                'Began records the measured offset and does not invent a candidate')
        require(first['glassSelectionLens']['frame'] == [208, 4, 102, 48] and
                first['glassSelectionLens']['effectClass'] == 'UIGlassEffect' and
                first['glassSelectionLens']['effectInteractive'] == 1,
                'One current lens is described using the existing public metadata helper')
        call(cpu, rt, diag, 'ended', rt.buttons[3])
        ended = inspect_record(records(rt)[-1], data)
        require(ended['phase'] == 'ended' and ended['candidateIndex'] == 3,
                'Ended records the candidate identity as an array index')
        require(frozen_ui(rt) == baseline and owned_associations(rt, controller) == associations,
                'Recording begin/end changes no UI, material, or interaction association')
        # This models a caller that records cancellation after clearing state.
        rt.associations.pop((controller, rt.key('drag')))
        rt.associations.pop((controller, rt.key('offset')))
        cleared = owned_associations(rt, controller)
        call(cpu, rt, diag, 'cancelled')
        cancelled = inspect_record(records(rt)[-1], data)
        require(cancelled['phase'] == 'cancelled' and cancelled['glassSelectionDragging'] == 0 and
                cancelled['glassSelectionFingerOffsetX'] is None and cancelled['candidateIndex'] is None,
                'Cleared cancellation state is represented accurately as false/null')
        require(frozen_ui(rt) == baseline and owned_associations(rt, controller) == cleared,
                'Cancellation diagnostics are read-only')
        require([row['data']['phase'] for row in records(rt)] == ['began', 'ended', 'cancelled'],
                'Each accepted transition enqueues exactly one record')
        require(rt.route_calls == [], 'No diagnostic callback routes host navigation')
        result.append({'slide': hex(slide), 'records': 3, 'private_view_messages': 0})
    return result


def bounded_candidate_lookup(data):
    result = []
    for scenario in ('nil', 'first', 'last', 'unknown', 'reordered', 'empty',
                     'missing', 'eight', 'over_limit'):
        cpu, rt, diag, _, _ = make(data)
        buttons = rt.objects[rt.buttons_array].state['items']
        candidate, expected = 0, None
        if scenario in ('first', 'last', 'reordered'):
            candidate = rt.buttons[0 if scenario != 'last' else 3]
            expected = 0 if scenario == 'first' else 3
            if scenario == 'reordered':
                buttons.reverse()
        elif scenario == 'unknown':
            candidate = 0xDEADBEEF  # must be compared only, never messaged/dereferenced
        elif scenario == 'empty':
            buttons.clear()
            candidate = rt.buttons[0]
        elif scenario == 'missing':
            rt.associations.pop((rt.PROXY, rt.slide + 0xeb85))
            candidate = rt.buttons[0]
        elif scenario in ('eight', 'over_limit'):
            count = 8 if scenario == 'eight' else 9
            for i in range(4, count):
                button = rt.view('UIButton', 'private_extra_tab_' + str(i),
                                 (0, 0, 44, 44), rt.PROXY_CONTENT, text=SENTINEL)
                buttons.append(button)
                rt.private_views.add(button)
            candidate = buttons[-1]
            expected = 7 if scenario == 'eight' else None
        call(cpu, rt, diag, 'ended', candidate)
        row = inspect_record(records(rt)[-1], data)
        require(row['candidateIndex'] == expected, 'Bounded identity lookup: ' + scenario)
        count = sum(receiver == rt.buttons_array and name == 'objectAtIndex:'
                    for receiver, name in rt.messages)
        require(count <= 8, 'Candidate lookup performs at most eight element reads')
        if scenario in ('empty', 'missing', 'over_limit', 'nil'):
            require(count == 0, 'Unsupported/empty arrays are rejected before element access')
        require(rt.route_calls == [], 'Identity reporting has no navigation side effects')
        result.append({'scenario': scenario, 'candidate_index': expected, 'element_reads': count})
    return result


def missing_and_nonfinite_state(data):
    result = []
    for scenario in ('offset_missing', 'nan', 'positive_infinity', 'negative_infinity',
                     'controller_missing', 'lens_missing'):
        cpu, rt, diag, _, controller = make(data)
        if scenario == 'offset_missing':
            rt.associations.pop((controller, rt.key('offset')))
        elif scenario in ('nan', 'positive_infinity', 'negative_infinity'):
            value = {'nan': math.nan, 'positive_infinity': math.inf,
                     'negative_infinity': -math.inf}[scenario]
            rt.associations[(controller, rt.key('offset'))] = rt.box(value)
        elif scenario == 'controller_missing':
            rt.associations.pop((rt.PROXY, rt.key('controller')))
        else:
            rt.associations.pop((rt.PROXY, rt.key('lens')))
        call(cpu, rt, diag, 'cancelled')
        row = inspect_record(records(rt)[-1], data)
        if scenario != 'lens_missing':
            require(row['glassSelectionFingerOffsetX'] is None,
                    'Missing/nonfinite offset is JSON null: ' + scenario)
        if scenario == 'controller_missing':
            require(row['glassSelectionDragging'] == 0, 'Missing controller is not active dragging')
        if scenario == 'lens_missing':
            require(row['glassSelectionLens'] is None, 'Missing lens is JSON null without traversal')
        result.append(scenario)
    return result


def rejected_calls(data):
    result = []
    for scenario in ('nil_proxy', 'nil_phase', 'foreign_phase', 'off_main'):
        cpu, rt, diag, _, controller = make(data)
        baseline, associations = frozen_ui(rt), dict(rt.associations)
        if scenario == 'nil_proxy':
            call(cpu, rt, diag, 'began', proxy=0)
        elif scenario in ('nil_phase', 'foreign_phase'):
            call(cpu, rt, diag, 0 if scenario == 'nil_phase' else 0xDEADBEEF)
        else:
            rt.thread = 'worker'
            call(cpu, rt, diag, 'began')
        require(not records(rt) and rt.route_calls == [], 'Rejected call has no record/route: ' + scenario)
        require(frozen_ui(rt) == baseline and rt.associations == associations,
                'Rejected call changes no UI or ownership: ' + scenario)
        require(not rt.association_reads, 'Rejected call never reads a proxy/controller association')
        require(not any(receiver in rt.objects and rt.is_kind(receiver, rt.UIView)
                        for receiver, _ in rt.messages), 'Rejected call never inspects UIKit')
        result.append(scenario)
    return result


def main():
    parser = argparse.ArgumentParser(description=__doc__)
    parser.add_argument('--candidate', required=True, type=Path)
    parser.add_argument('--report', type=Path)
    args = parser.parse_args()
    data = args.candidate.read_bytes()
    report = {'passed': False, 'candidate_sha256': hashlib.sha256(data).hexdigest(),
              'scope': 'Actual ARM64 diagnostic helper with explicit UIKit/Foundation boundary fixtures',
              'device_tested': False, 'gpu_refraction_tested': False,
              'physical_hit_testing_tested': False, 'cases': []}
    try:
        diagnostic_entries(data)
        for name, test in (
                ('transition_schema_privacy_abi_and_nonmutation', transitions_and_nonmutation),
                ('bounded_candidate_identity_lookup', bounded_candidate_lookup),
                ('missing_and_nonfinite_state', missing_and_nonfinite_state),
                ('rejected_calls_without_UIKit_access', rejected_calls)):
            report['cases'].append({'name': name, 'passed': True, 'detail': test(data)})
        report['passed'] = True
    except Exception:
        report['error'] = traceback.format_exc()
    report['case_groups'] = len(report['cases'])
    report['instructions'] = sum(cpu.steps for cpu, _ in RUNS)
    report['abi_checks'] = ('Every invocation preserves x18/x19-x29, d8-d15 and balanced SP; '
                            'framework calls poison caller-saved registers.')
    text = json.dumps(report, ensure_ascii=False, indent=2) + '\n'
    if args.report:
        args.report.parent.mkdir(parents=True, exist_ok=True)
        args.report.write_text(text)
    print(text)
    return 0 if report['passed'] else 1


if __name__ == '__main__':
    raise SystemExit(main())
