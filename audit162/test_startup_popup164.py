#!/usr/bin/env python3
"""Exercise the homepage ad dispatch flag in the candidate ARM64 image."""
import argparse
import json
import struct
from pathlib import Path

from arm64 import require
from mock_foundation import Runtime as FoundationRuntime
from test_hook_ownership163 import make_cpu


CLASS = 'SSCommonABTestHelper'
SELECTOR = 'insert_screen_ad_pop_cfg'
ENCODING = 'B16@0:8'
PRIVATE_TEXT = 'PRIVATE_STARTUP_MESSAGE_164'


class Runtime(FoundationRuntime):
    ORIGINAL_GATE_IMP = 0x33000b00
    ORIGINAL_SPLASH_IMP = 0x33000b08
    UNEXPECTED_CALLBACK = 0x33000b10

    def __init__(self, data, slide):
        super().__init__(data, slide)
        self.private_object = self.text_object(PRIVATE_TEXT)

    def handle(self, cpu, pc):
        require(pc != self.UNEXPECTED_CALLBACK, 'The flag never invokes a presentation callback')
        if pc == self.ORIGINAL_GATE_IMP:
            return self.finish(cpu, 0)
        if pc == self.ORIGINAL_SPLASH_IMP:
            return self.finish(cpu, 1)
        if pc - self.slide == 0xa5d4:
            require(cpu.x[0] != self.private_object,
                    'The decision never messages unrelated host data')
        return super().handle(cpu, pc)


def read_decisions(rt):
    decisions = []
    for pointer, obj in rt.objects.items():
        if not rt.is_kind(pointer, rt.classes['NSDictionary']):
            continue
        values = obj.state.get('items', {})
        if 'sequence' in values and rt.string_value(values.get('event')) == 'adRuleDecision':
            decisions.append(rt.native(pointer))
    return decisions


def check_case(data, slide, mode):
    rt = Runtime(data, slide)
    cpu = make_cpu(rt)
    cpu.ranges.append((0x7394, 0x746c))
    parent = rt._class('ABTestBase', 'NSObject')
    sibling = rt._class('OtherABTestHelper', 'ABTestBase')
    target = None if mode == 'missing_class' else rt._class(CLASS, 'ABTestBase')
    ancestor, sibling_meta = (rt.metaclasses[cls] for cls in (parent, sibling))
    target_meta = rt.metaclasses[target] if target else None
    selector = rt.sel(SELECTOR)
    inherited = 0
    if mode != 'missing_method':
        encoding = 'v16@0:8' if mode == 'wrong_encoding' else ENCODING
        inherited = rt._add(ancestor, SELECTOR, rt.ORIGINAL_GATE_IMP, encoding)
    original_target = inherited if target else 0
    if mode == 'owned':
        original_target = rt._add(target_meta, SELECTOR, rt.ORIGINAL_GATE_IMP, ENCODING)
    if target:
        other_gate = rt._add(target_meta, 'imcShouldInUg', rt.ORIGINAL_GATE_IMP, ENCODING)

    splash = rt._class('SSReadingAdSplashService', 'NSObject')
    splash_method = rt._add(splash, 'shouldShowSplashAd', rt.ORIGINAL_SPLASH_IMP, ENCODING)
    enabled = mode != 'disabled'
    cpu.run(0x4650, args=(int(enabled),))
    installer=struct.unpack_from('<I',data,0x14010+27*4)[0]+0x800
    require(rt.methods[splash_method]['imp'] == (slide + installer + 12 + 8 if enabled else rt.ORIGINAL_SPLASH_IMP),
            'The extension preserves the legacy splash option and installer')
    require(rt.get_method(sibling_meta, selector) == inherited,
            'A sibling metaclass still resolves the same inherited Method')
    if inherited:
        require(rt.methods[inherited]['imp'] == rt.ORIGINAL_GATE_IMP,
                'The shared superclass gate remains untouched')
    if target:
        require(rt.methods[other_gate]['imp'] == rt.ORIGINAL_GATE_IMP,
                'Normal insert-screen recommendation gate is left alone')
        method = rt.get_method(target_meta, selector)
    else:
        method = 0

    require(not read_decisions(rt), 'Installing the rule emits no decision event')
    if mode in ('owned', 'inherited'):
        require(method and rt.methods[method]['class'] == target_meta,
                'The target metaclass owns the replacement')
        if mode == 'owned':
            require(method == original_target, 'The already-owned Method is reused')
        imp = rt.methods[method]['imp']
        require(imp != rt.ORIGINAL_GATE_IMP, 'The target receives a distinct implementation')
        result = cpu.run(imp - slide, args=(target, selector, rt.private_object, rt.UNEXPECTED_CALLBACK))
        require(result['result'] == 1, 'True selects the host skip-and-mark-read branch')
        decisions = read_decisions(rt)
        require(len(decisions) == 1, 'Executing the gate emits one decision event')
        record = decisions[0]
        require(record['timestamp'] == rt.now and record['sequence'] >= 1
                and record['pluginVersion'] == '1.6.4', 'The versioned diagnostic envelope is populated')
        require(record['data'] == {
            'ruleId': 'homepage_nonstandard_popup',
            'ruleType': 'exactHostSelector',
            'class': CLASS,
            'selector': SELECTOR,
            'result': 'blocked',
            'pageDisplay': 'unobserved',
        }, 'Only fixed rule metadata enters the decision log')
        require(PRIVATE_TEXT not in json.dumps(record), 'Decision log excludes unrelated host content')
    else:
        require(method == original_target, 'Disabled or unavailable rule leaves the target lookup unchanged')
        if method:
            require(rt.methods[method]['imp'] == rt.ORIGINAL_GATE_IMP,
                    'Disabled or incompatible gate retains its original implementation')
            require(cpu.run(rt.ORIGINAL_GATE_IMP - slide, args=(target, selector))['result'] == 0,
                    'The original host flag stays false')
        require(not read_decisions(rt), 'The inactive rule emits no decision event')
    return {'slide': hex(slide), 'case': mode, 'instructions': cpu.steps}


def main():
    parser = argparse.ArgumentParser(description=__doc__)
    parser.add_argument('candidate', type=Path)
    parser.add_argument('--report', type=Path)
    args = parser.parse_args()
    data = args.candidate.read_bytes()
    cases = [check_case(data, slide, mode) for slide in (0, 0x180000000)
             for mode in ('owned', 'inherited', 'disabled', 'missing_class', 'missing_method', 'wrong_encoding')]
    report = json.dumps({'passed': True, 'device_tested': False, 'cases': cases}, indent=2)
    if args.report:
        args.report.write_text(report + '\n', encoding='utf-8')
    print(report)


if __name__ == '__main__':
    main()
