#!/usr/bin/env python3
"""Exercise both homepage ad dispatch routes in the candidate ARM64 image."""
import argparse
import json
import struct
from pathlib import Path

from arm64 import require, release_version
from mock_foundation import Runtime as FoundationRuntime
from test_hook_ownership163 import make_cpu


CLASS = 'SSCommonABTestHelper'
SELECTOR = 'insert_screen_ad_pop_cfg'
ENCODING = 'B16@0:8'
PRIVATE_TEXT = 'PRIVATE_STARTUP_MESSAGE_164'
AD_OWNER = 'SSImcAdOperationMessage'
OPERATION = 'SSImcOperationMessage'
SERVICE = 'SSImcMessageService'
LOOKUP = 'getPopupWithDataGroup:'
LOOKUP_ENCODING = '@24@0:8@16'


class Runtime(FoundationRuntime):
    ORIGINAL_GATE_IMP = 0x33000b00
    ORIGINAL_SPLASH_IMP = 0x33000b08
    UNEXPECTED_CALLBACK = 0x33000b10
    ORIGINAL_LOOKUP_IMP = 0x33000b18

    def __init__(self, data, slide):
        super().__init__(data, slide)
        self.private_object = self.text_object(PRIVATE_TEXT)
        self.lookup_result = 0
        self.lookup_calls = []

    def imc_host(self, build='7.4.3.33', gate_encoding=ENCODING, lookup_encoding=LOOKUP_ENCODING,
                 legacy_renderer=True):
        self.objects[self.MAIN_BUNDLE].state['info']['CFBundleVersion'] = build
        parent = self._class(OPERATION, 'NSObject')
        ad_owner = self._class(AD_OWNER, OPERATION)
        service = self._class(SERVICE, 'NSObject')
        if legacy_renderer:
            renderer = self._class('SSInsertScreenRecommendService', 'NSObject')
            self._add(renderer, 'showInsertScreenOfNonstandardAdMessage:showBlock:',
                      self.UNEXPECTED_CALLBACK, 'v32@0:8@16@?24')
        normal_gate = self._add(parent, 'enablePopup', self.ORIGINAL_SPLASH_IMP, ENCODING)
        ad_gate = self._add(ad_owner, 'enablePopup', self.ORIGINAL_SPLASH_IMP, gate_encoding)
        lookup = self._add(service, LOOKUP, self.ORIGINAL_LOOKUP_IMP, lookup_encoding)
        return ad_gate, lookup, normal_gate

    def handle(self, cpu, pc):
        require(pc != self.UNEXPECTED_CALLBACK, 'The flag never invokes a presentation callback')
        if pc == self.ORIGINAL_GATE_IMP:
            return self.finish(cpu, 0)
        if pc == self.ORIGINAL_SPLASH_IMP:
            return self.finish(cpu, 1)
        if pc == self.ORIGINAL_LOOKUP_IMP:
            self.lookup_calls.append(tuple(cpu.x[:3]))
            return self.finish(cpu, self.lookup_result)
        entry = pc - self.slide
        if entry == 0xa5ec:
            super().handle(cpu, pc)
            for offset, byte in enumerate(self.string(cpu.x[0]).encode() + b'\0'):
                cpu.memory[cpu.x[0] + offset] = byte
            return True
        if entry == 0xa5d4:
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
    if release_version(data) in ('1.7.4', '1.74', '1.75'):
        rt.imc_host()
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
                and record['pluginVersion'] == release_version(data), 'The versioned diagnostic envelope is populated')
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


def check_imc(data, slide, mode, options):
    rt = Runtime(data, slide)
    gate, lookup, normal = rt.imc_host(
        build='7.4.3.34' if mode == 'alternate_build' else '7.4.3.33',
        gate_encoding='v16@0:8' if mode == 'wrong_gate_abi' else ENCODING,
        lookup_encoding='v24@0:8@16' if mode == 'wrong_lookup_abi' else LOOKUP_ENCODING,
        legacy_renderer=mode not in ('modern_only', 'missing_imc_class'),
    )
    if mode in ('missing_imc_class', 'legacy_only'):
        rt.missing_classes.add(AD_OWNER)
    ab_class = rt._class(CLASS, 'NSObject')
    legacy = rt._add(rt.metaclasses[ab_class], SELECTOR, rt.ORIGINAL_GATE_IMP, ENCODING)
    cpu = make_cpu(rt)
    cpu.ranges.append((0x7394, 0x746c))
    cpu.run(0x4650, args=(options,))
    require(not read_decisions(rt), 'Ad hook installation makes no display decision')
    active = mode in ('launch_only', 'bookstore_only', 'both', 'alternate_build', 'modern_only')
    legacy_active = (active and mode != 'modern_only') or mode == 'legacy_only'
    legacy_imp, gate_imp, lookup_imp = (rt.methods[method]['imp'] for method in (legacy, gate, lookup))
    require(rt.methods[normal]['imp'] == rt.ORIGINAL_SPLASH_IMP,
            'Ordinary IMC dialogs preserve the original enable gate')
    require((legacy_imp != rt.ORIGINAL_GATE_IMP) == legacy_active,
            'The exact legacy renderer remains supported with IMC absent or independently blocked')
    require((gate_imp != rt.ORIGINAL_SPLASH_IMP) == active,
            'The ad-specific gate follows the two cleanup options and exact ABI')
    require((lookup_imp != rt.ORIGINAL_LOOKUP_IMP) == active,
            'The cached lookup follows the two cleanup options and exact ABI')
    if not active:
        if legacy_active:
            require(cpu.run(legacy_imp - slide, args=(ab_class, rt.sel(SELECTOR)))['result'] == 1
                    and len(read_decisions(rt)) == 1, 'The legacy-only host uses its native skip path')
        return {'slide': hex(slide), 'case': mode, 'instructions': cpu.steps}

    legacy_result = cpu.run(legacy_imp - slide, args=(ab_class, rt.sel(SELECTOR)))['result']
    require(legacy_result == int(legacy_active), 'When available, legacy type 7 keeps the native skip-and-mark-read path')
    ad = rt.obj(AD_OWNER, 'type_7_ad')
    require(cpu.run(gate_imp - slide, args=(ad, rt.sel('enablePopup')))['result'] == 0,
            'Cyber IMC now independently denies the same ad instead of reusing the true legacy flag')
    normal_handler = rt.obj(OPERATION, 'ordinary_recommendation')
    service = rt.obj(SERVICE, 'message_service')
    arguments = (service, rt.sel(LOOKUP), rt.private_object)
    for host_result, wanted in ((0, 0), (normal_handler, normal_handler), (ad, 0)):
        rt.lookup_result = host_result
        require(cpu.run(lookup_imp - slide, args=arguments)['result'] == wanted,
                'Lookup preserves native absence and ordinary dialogs, but declines the cached type-7 handler')
    require(rt.lookup_calls == [arguments] * 3, 'Each lookup forwards the receiver, selector and group once')
    decisions = read_decisions(rt)
    require(len(decisions) == 1 + int(legacy_active) and decisions[-1]['data'] == {
        'ruleId': 'bookstore_imc_popup',
        'ruleType': 'exactHostSelector',
        'class': SERVICE,
        'selector': LOOKUP,
        'result': 'blocked',
        'pageDisplay': 'unobserved',
    }, 'A real cached ad decision emits only fixed rule metadata')
    require(PRIVATE_TEXT not in json.dumps(decisions), 'No resource data enters the diagnostics')
    return {'slide': hex(slide), 'case': mode, 'instructions': cpu.steps}


def main():
    parser = argparse.ArgumentParser(description=__doc__)
    parser.add_argument('candidate', type=Path)
    parser.add_argument('--report', type=Path)
    args = parser.parse_args()
    data = args.candidate.read_bytes()
    cases = [check_case(data, slide, mode) for slide in (0, 0x180000000)
             for mode in ('owned', 'inherited', 'disabled', 'missing_class', 'missing_method', 'wrong_encoding')]
    if release_version(data) in ('1.7.4', '1.74', '1.75'):
        cases.extend(check_imc(data, slide, mode, options) for slide in (0, 0x180000000)
                     for mode, options in (('launch_only', 1), ('bookstore_only', 1 << 6), ('both', 0x41),
                                           ('disabled', 0), ('other_option', 1 << 5),
                                           ('alternate_build', 0x41), ('modern_only', 0x41), ('legacy_only', 0x41),
                                           ('missing_imc_class', 0x41), ('wrong_gate_abi', 0x41), ('wrong_lookup_abi', 0x41)))
    report = json.dumps({'passed': True, 'device_tested': False, 'cases': cases}, indent=2)
    if args.report:
        args.report.write_text(report + '\n', encoding='utf-8')
    print(report)


if __name__ == '__main__':
    main()
