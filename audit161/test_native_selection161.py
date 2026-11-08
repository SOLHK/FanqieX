#!/usr/bin/env python3
"""Execute native selection bridge ARM64 against explicit UIKit boundaries.

Checks native control construction, real host-item mapping, selection routing,
failure rollback, hidden-state ownership, and weak lifetimes. Native UIKit's
internal dragging/refraction is deliberately not simulated or claimed tested.
"""
import argparse
import copy
import hashlib
import json
from pathlib import Path
import traceback

from arm64 import require
from native_selection_runtime import make as runtime_make, native_entries


RUNS = []


def make(data, **options):
    cpu, rt, entries = runtime_make(data, **options)
    RUNS.append((cpu, rt))
    return cpu, rt, entries


def call(cpu, entries, name, *args):
    return cpu.run(entries[name], args=list(args), max_steps=3000000)


def update(cpu, rt, entries):
    return call(cpu, entries, 'update', rt.BAR, rt.PROXY)['result']


def fixture(data, **options):
    cpu, rt, entries = make(data, **options)
    require(update(cpu, rt, entries) == 1, 'A supported visible host builds the native control')
    require(rt.control() and rt.controller(), 'Native control and private controller are owned')
    return cpu, rt, entries


def captions(rt, control=None):
    return [rt.string_value(value) for value in
            rt.objects[rt.control() if control is None else control].state['segments']]


def selected(rt, control=None):
    return rt.objects[rt.control() if control is None else control].state['selectedSegmentIndex']


def button_state(rt, buttons=None):
    keys = ('frame', 'bounds', 'superview', 'enabled', 'originalTarget',
            'originalAction', 'accessibilityLabel', 'title', 'hidden')
    return {button: {key: copy.deepcopy(rt.objects[button].state.get(key)) for key in keys}
            for button in (rt.buttons if buttons is None else buttons)}


def record_events(rt):
    result = []
    for pointer, obj in rt.objects.items():
        if rt.is_kind(pointer, rt.classes['NSDictionary']):
            fields = obj.state.get('items', {})
            if 'sequence' in fields and 'event' in fields:
                result.append(rt.string_value(fields['event']))
    return result


def build_and_sync(data):
    cases = []
    for slide in (0, 0x180000000):
        cpu, rt, entries = make(data, slide=slide,
                                titles=('Store actual', '短剧 actual', 'Shelf actual', 'Profile actual'))
        before = button_state(rt)
        material = rt.objects[rt.PROXY].state['effect']
        require(update(cpu, rt, entries) == 1, 'Native control builds under each ASLR slide')
        control, controller = rt.control(), rt.controller()
        state = rt.objects[control].state
        require(rt.class_names[rt.objects[control].cls] == 'UISegmentedControl',
                'Bridge uses the actual public UIKit control class')
        require(captions(rt) == ['Store actual', '短剧 actual', 'Shelf actual', 'Profile actual'],
                'Native segments use actual UITabBarItem titles, not hardcoded labels')
        require(state['superview'] == rt.BAR and state['frame'] == rt.objects[rt.PROXY].state['frame'],
                'Whole native control is a coincident sibling of the transparent proxy')
        require(rt.objects[rt.PROXY].state['effect'] == material,
                'Native selection does not compete with the material-lifecycle owner')
        require(not state['momentary'] and not state['apportionsSegmentWidthsByContent'],
                'Native control retains selection with equal segment widths')
        require(selected(rt) == 2 and all(rt.objects[b].state['hidden'] for b in rt.buttons),
                'True host selection is mirrored and original buttons are hidden')
        require(rt.targets(control) == [(controller, rt.sel('nativeSelectionChanged:'), 4096)],
                'Exactly one nonretaining native valueChanged target is installed')
        require(call(cpu, entries, 'has_native', rt.PROXY)['result'] == 1,
                'Native presence is discoverable without creating another control')
        after = button_state(rt)
        for button in rt.buttons:
            require({k: v for k, v in after[button].items() if k != 'hidden'} ==
                    {k: v for k, v in before[button].items() if k != 'hidden'},
                    'Original button geometry, target, action and accessibility are retained')
        rt.events.clear()
        for _ in range(6):
            require(update(cpu, rt, entries) == 1, 'Stable repeat update remains native')
        require(rt.control() == control and rt.controller() == controller,
                'Stable updates reuse native control/controller identities')
        require(not any(event['event'] in ('native_alloc', 'add_target', 'native_selected')
                        for event in rt.events), 'Stable updates neither rebuild nor reselect')
        rt.objects[rt.BAR].state['selectedItem'] = rt.items[0]
        require(update(cpu, rt, entries) == 1 and selected(rt) == 0,
                'External host selection synchronizes without navigating')
        rt.objects[rt.items[1]].state['enabled'] = False
        rt.objects[rt.buttons[3]].state['enabled'] = False
        update(cpu, rt, entries)
        require(rt.objects[control].state['segment_enabled'] == [True, False, True, False],
                'Per-segment availability follows both host items and original buttons')
        require(rt.send_actions_calls == 0 and rt.route_calls == [],
                'Programmatic synchronization emits no actions or host route')
        require('glassInteraction' not in record_events(rt),
                'Native path does not claim observation of UIKit internal dragging')
        cases.append({'slide': hex(slide), 'native_class': 'UISegmentedControl',
                      'programmatic_action_sends': 0, 'material_lifecycle_separate': True})
    return cases


def title_fallback_and_rejection(data):
    cpu, rt, entries = make(data, titles=(None, '', '真实书架', '真实我的'))
    require(update(cpu, rt, entries) == 1, 'Missing/empty item titles can use original normal-state titles')
    require(captions(rt) == ['Host fallback 0', 'Host fallback 1', '真实书架', '真实我的'],
            'Fallback title is read from the actual original UIButton')
    cpu2, rt2, entries2 = make(data, titles=(None, '短剧', '书架', '我的'))
    rt2.objects[rt2.buttons[0]].state['title'] = 0
    before, effect = button_state(rt2), rt2.objects[rt2.PROXY].state['effect']
    require(update(cpu2, rt2, entries2) == 0, 'An unavailable title rejects the whole native bridge')
    require(not rt2.control() and button_state(rt2) == before and
            rt2.objects[rt2.PROXY].state['effect'] == effect,
            'Title rejection leaves the existing fallback surface and buttons intact')
    return {'actual_item_titles': True, 'normal_title_fallback': True, 'no_invented_titles': True}


def routing_and_reentry(data):
    cases = []
    for slide in (0, 0x180000000):
        cpu, rt, entries = fixture(data, slide=slide)
        control = rt.control()
        rt.fire(cpu, index=3)
        require(rt.route_calls == [3] and rt.selected_index() == 3 and selected(rt) == 3,
                'One valid valueChanged executes the original click route exactly once')
        rt.fire(cpu)
        require(rt.route_calls == [3], 'Duplicate callback for the true host selection is ignored')
        require(rt.send_actions_calls == 0, 'Callback synchronization never recursively sends actions')
        cases.append({'slide': hex(slide), 'valid_route_count': 1, 'duplicate_routes': 0})
    for mode in ('reject', 'redirect', 'synchronous_reentry'):
        cpu, rt, entries = fixture(data)
        control = rt.control()
        if mode == 'reject':
            rt.reject_selection = True
        elif mode == 'redirect':
            rt.redirect_selection = 0
        else:
            def nested(current_cpu, _requested):
                rt.objects[control].state['selectedSegmentIndex'] = 1
                call(current_cpu, entries, 'value_changed', rt.controller(),
                     rt.sel('nativeSelectionChanged:'), control)
            rt.host_on_select = nested
        rt.fire(cpu, index=3)
        expected = 2 if mode == 'reject' else 0 if mode == 'redirect' else 3
        require(rt.route_calls == [3], 'One original route under ' + mode)
        require(rt.selected_index() == expected and selected(rt) == expected,
                'Native selection ends at the host-accepted item under ' + mode)
        require(not rt.associated_native(rt.controller(), 'busy'), 'Callback busy guard is cleared')
        require(rt.send_actions_calls == 0, 'No synthetic action under ' + mode)
        cases.append({'host_behavior': mode, 'final_index': expected, 'route_count': 1})
    return cases


def tracking_preview_and_host_authority(data):
    cpu, rt, entries = fixture(data)
    control = rt.control()
    rt.objects[control].state.update(tracking=True, selectedSegmentIndex=3)
    rt.events.clear()
    for _ in range(8):
        require(update(cpu, rt, entries) == 1, 'Tracking maintenance keeps the native bridge active')
    require(selected(rt) == 3 and rt.selected_index() == 2,
            'An uncommitted native preview survives while the true host item is unchanged')
    require(not any(event['event'] == 'native_selected' for event in rt.events),
            'Repeated maintenance never writes over an in-progress native preview')
    require(rt.route_calls == [], 'A native tracking preview does not itself navigate')
    rt.objects[rt.BAR].state['selectedItem'] = rt.items[0]
    rt.events.clear()
    update(cpu, rt, entries)
    require(selected(rt) == 0 and rt.selected_index() == 0,
            'A genuine external host selection wins even while tracking')
    require(sum(event['event'] == 'native_selected' for event in rt.events) == 1,
            'External selection is synchronized once')
    rt.objects[control].state['selectedSegmentIndex'] = 1
    rt.events.clear()
    update(cpu, rt, entries)
    require(selected(rt) == 1 and not any(event['event'] == 'native_selected' for event in rt.events),
            'The new host-item epoch also preserves subsequent tracking previews')
    rt.objects[control].state['tracking'] = False
    update(cpu, rt, entries)
    require(selected(rt) == 0, 'Outside tracking the native index follows the actual host item')
    results = [{'unchanged_host_preserves_preview': True, 'external_host_change_wins': True}]
    for mode in ('reject', 'redirect'):
        cpu2, rt2, entries2 = fixture(data)
        rt2.objects[rt2.control()].state['tracking'] = True
        if mode == 'reject':
            rt2.reject_selection = True
        else:
            rt2.redirect_selection = 0
        rt2.fire(cpu2, index=3)
        expected = 2 if mode == 'reject' else 0
        require(rt2.route_calls == [3] and rt2.selected_index() == expected and selected(rt2) == expected,
                'Callback completion invalidates the preview cache after host ' + mode)
        results.append({'host_behavior_while_tracking': mode, 'final_index': expected})
    return results


def invalid_callbacks(data):
    cases = []
    for scenario in ('negative', 'past_end', 'control_disabled', 'button_disabled',
                     'item_disabled', 'items_reordered', 'buttons_reordered',
                     'items_replaced', 'buttons_missing', 'foreign_sender',
                     'proxy_rebound', 'window_changed'):
        cpu, rt, entries = fixture(data)
        control, controller = rt.control(), rt.controller()
        rt.objects[control].state['selectedSegmentIndex'] = 3
        sender = control
        if scenario == 'negative':
            rt.objects[control].state['selectedSegmentIndex'] = -1
        elif scenario == 'past_end':
            rt.objects[control].state['selectedSegmentIndex'] = 4
        elif scenario == 'control_disabled':
            rt.objects[control].state['enabled'] = False
        elif scenario == 'button_disabled':
            rt.objects[rt.buttons[3]].state['enabled'] = False
        elif scenario == 'item_disabled':
            rt.objects[rt.items[3]].state['enabled'] = False
        elif scenario == 'items_reordered':
            rt.objects[rt.items_array].state['items'].reverse()
        elif scenario == 'buttons_reordered':
            rt.objects[rt.buttons_array].state['items'].reverse()
        elif scenario == 'items_replaced':
            replacement = rt.obj('UITabBarItem', 'replacement_item',
                                 title=rt.text_object('New host item'), enabled=True)
            rt.objects[rt.items_array].state['items'][3] = replacement
        elif scenario == 'buttons_missing':
            rt.associations.pop((rt.PROXY, rt.slide + 0xeb85))
        elif scenario == 'foreign_sender':
            sender = rt.view('UISegmentedControl', 'foreign_control', (12, 0, 416, 56),
                             rt.BAR, segments=[], selectedSegmentIndex=3, enabled=True)
        elif scenario == 'proxy_rebound':
            rt.associations[(rt.BAR, rt.slide + 0xeb84)] = 0
        else:
            window = rt.view('UIWindow', 'new_window', (0, 0, 440, 956))
            rt.reparent(rt.ROOT, window)
        call(cpu, entries, 'value_changed', controller, rt.sel('nativeSelectionChanged:'), sender)
        require(rt.route_calls == [], 'Invalid callback cannot navigate: ' + scenario)
        require(rt.send_actions_calls == 0, 'Invalid callback cannot send actions: ' + scenario)
        cases.append(scenario)
    return cases


def reorder_replacement_and_teardown(data):
    cases = []
    for scenario in ('paired_reorder', 'button_replacement', 'item_replacement', 'window_change'):
        cpu, rt, entries = fixture(data)
        old_control, old_controller = rt.control(), rt.controller()
        if scenario == 'paired_reorder':
            rt.objects[rt.items_array].state['items'].reverse()
            rt.objects[rt.buttons_array].state['items'].reverse()
        elif scenario == 'button_replacement':
            replacement = rt.view('UIButton', 'new_host_button', (310, 4, 102, 48),
                                  rt.PROXY_CONTENT, enabled=True,
                                  title=rt.text_object('Replacement fallback'),
                                  originalTarget=rt.BAR, originalAction='fqab_homeTabPressed:')
            rt.objects[rt.buttons_array].state['items'][3] = replacement
        elif scenario == 'item_replacement':
            replacement = rt.obj('UITabBarItem', 'new_host_item',
                                 title=rt.text_object('Host Replacement'), enabled=True)
            rt.objects[rt.items_array].state['items'][3] = replacement
        else:
            window = rt.view('UIWindow', 'replacement_window', (0, 0, 440, 956))
            rt.reparent(rt.ROOT, window)
        require(update(cpu, rt, entries) == 1, 'Changed ownership can rebuild safely: ' + scenario)
        require(rt.control() != old_control and rt.controller() != old_controller,
                'Ownership epoch changes create a fresh bridge: ' + scenario)
        require(rt.objects[old_control].state['superview'] == 0 and not rt.targets(old_control),
                'The previous control and callback are detached: ' + scenario)
        require(old_controller in rt.dead, 'Old private controller is released: ' + scenario)
        current_items = rt.objects[rt.objects[rt.BAR].state['items']].state['items']
        current_buttons = rt.objects[rt.buttons_array].state['items']
        expected = [rt.string_value(rt.objects[item].state['title']) for item in current_items]
        require(captions(rt) == expected, 'Replacement captions reflect current host items')
        require(selected(rt) == current_items.index(rt.objects[rt.BAR].state['selectedItem']),
                'Selection follows true item identity through reorder/replacement')
        control, controller = rt.control(), rt.controller()
        call(cpu, entries, 'restore', rt.BAR, rt.PROXY)
        require(not rt.control() and not rt.controller(), 'Teardown releases published ownership')
        require(rt.objects[control].state['superview'] == 0 and not rt.targets(control),
                'Teardown detaches the private UIControl and target')
        require(controller in rt.dead, 'Teardown releases the final private controller')
        require(all(not rt.objects[b].state['hidden'] for b in current_buttons),
                'Teardown restores buttons still owned by this proxy')
        require(call(cpu, entries, 'has_native', rt.PROXY)['result'] == 0,
                'Teardown exposes that the fallback material is needed')
        call(cpu, entries, 'restore', rt.BAR, rt.PROXY)
        require(rt.route_calls == [], 'Ownership reconciliation and idempotent teardown do not navigate')
        cases.append(scenario)
    return cases


def hidden_state_ownership(data):
    cpu, rt, entries = make(data)
    rt.objects[rt.buttons[1]].state['hidden'] = True
    before = button_state(rt)
    require(update(cpu, rt, entries) == 1, 'Already hidden host buttons are recorded')
    rt.objects[rt.buttons[0]].state['hidden'] = False  # host changed the applied value
    foreign = rt.view('UIView', 'new_foreign_owner', (0, 0, 440, 100), rt.ROOT)
    rt.reparent(rt.buttons[2], foreign)
    rt.events.clear()
    call(cpu, entries, 'restore', rt.BAR, rt.PROXY)
    require(rt.objects[rt.buttons[0]].state['hidden'] is False,
            'A later host hidden-state change is preserved')
    require(not any(event['event'] == 'setHidden' and event.get('self') == rt.buttons[0]
                    for event in rt.events), 'Restoration does not rewrite a host-changed value')
    require(rt.objects[rt.buttons[1]].state['hidden'] is True,
            'Originally hidden button is not spuriously shown')
    require(rt.objects[rt.buttons[2]].state['superview'] == foreign and
            rt.objects[rt.buttons[2]].state['hidden'] is True,
            'A reparented control is no longer changed by this bridge')
    require(rt.objects[rt.buttons[3]].state['hidden'] == before[rt.buttons[3]]['hidden'],
            'Unchanged owned button returns to its saved hidden state')
    require(rt.route_calls == [], 'Restoration performs no host action')
    return {'host_value_preserved': True, 'foreign_reparent_preserved': True,
            'original_hidden_preserved': True}


def allocation_failure_is_fallback(data):
    cases = []
    failures = [({'missing_segment_class': True}, 'missing_class'),
                ({'missing_constructor': True}, 'missing_constructor'),
                ({'segment_alloc_nil': True}, 'segment_alloc'),
                ({'segment_init_nil': True}, 'segment_init'),
                ({'controller_alloc_nil': True}, 'controller_alloc')]
    failures.extend(({'weak_fail_at': i}, 'weak_box_' + str(i)) for i in (1, 2, 3))
    for options, label in failures:
        cpu, rt, entries = make(data, **options)
        before, effect = button_state(rt), rt.objects[rt.PROXY].state['effect']
        require(update(cpu, rt, entries) == 0, 'Failure selects the material fallback: ' + label)
        require(not rt.control() and not rt.controller(), 'Failure publishes no partial native ownership')
        require(button_state(rt) == before and rt.objects[rt.PROXY].state['effect'] == effect,
                'Failure does not clear glass or hide original buttons: ' + label)
        require(all(count == 0 for count in rt.controller_counts.values()),
                'Failed construction releases any allocated private controller: ' + label)
        require(not any(rt.class_names[obj.cls] == 'UISegmentedControl' and
                        obj.state.get('superview') for obj in rt.objects.values()),
                'Failed construction leaves no mounted native control')
        require(rt.route_calls == [], 'Construction failure does not navigate')
        cases.append(label)
    return cases


def weak_lifetime_and_stale_callbacks(data):
    cases = []
    for scenario in ('normal_teardown', 'bar_death', 'proxy_death',
                     'proxy_death_real_target_without_hold', 'held_stale_callback'):
        cpu, rt, entries = fixture(data)
        control, controller = rt.control(), rt.controller()
        require(rt.controller_counts[controller] == 2 and
                rt.associated_native(control, 'controller') == controller,
                'Both proxy and native UIControl own the target while callbacks remain registered')
        require(not rt.strong_reachable(controller, rt.BAR) and
                not rt.strong_reachable(controller, rt.PROXY) and
                not rt.strong_reachable(control, rt.BAR) and
                not rt.strong_reachable(control, rt.PROXY),
                'Neither private controller nor UIControl creates a strong owner cycle')
        require(rt.retain_balance.get(rt.BAR, 0) == 0 and
                rt.retain_balance.get(rt.PROXY, 0) == 0,
                'No unmatched explicit retain keeps bar/proxy alive')
        if scenario == 'normal_teardown':
            call(cpu, entries, 'restore', rt.BAR, rt.PROXY)
            require(controller in rt.dead and rt.controller_counts[controller] == 0,
                    'Normal teardown releases the private controller')
        elif scenario == 'held_stale_callback':
            rt.hold(controller)  # an explicit outside fixture reference
            call(cpu, entries, 'restore', rt.BAR, rt.PROXY)
            call(cpu, entries, 'value_changed', controller, rt.sel('nativeSelectionChanged:'), control)
            require(rt.route_calls == [], 'A still-live stale target cannot route after teardown')
            rt.drop(controller)
            require(controller in rt.dead, 'The last outside reference can release the stale target')
        elif scenario == 'proxy_death_real_target_without_hold':
            # No artificial controller hold: its surviving native UIControl
            # must keep the target alive for an actual registered event.
            rt.expire(rt.PROXY)
            require(controller not in rt.dead and rt.controller_counts[controller] == 1,
                    'A still-mounted native control retains its target after proxy death')
            rt.fire(cpu, control=control, index=1)
            require(rt.route_calls == [] and controller not in rt.dead,
                    'Registered target event safely observes a zeroed proxy without navigating')
            rt.expire(control)
            require(controller in rt.dead and rt.controller_counts[controller] == 0,
                    'The last native owner releases the target without a cycle')
        else:
            # Preserve an explicit test reference so the callback itself is a
            # valid object even after its ownership edge is removed.
            rt.hold(controller)
            rt.expire(rt.BAR if scenario == 'bar_death' else rt.PROXY)
            call(cpu, entries, 'value_changed', controller, rt.sel('nativeSelectionChanged:'), control)
            require(rt.route_calls == [], 'A zeroed weak owner prevents navigation: ' + scenario)
            rt.drop(controller)
        require(rt.send_actions_calls == 0, 'Lifetime checks never synthesize UIControl actions')
        cases.append(scenario)
    return cases


def explicit_callee_saved_canaries(data):
    results = []
    for slide in (0, 0x180000000):
        cpu, rt, entries = make(data, slide=slide)

        def checked(name, *args, label=None):
            # Distinct values make any epilogue offset alias immediately visible.
            for register in range(19, 29):
                cpu.x[register] = 0x7141000000000000 + register * 0x0102030405
            for register in range(8, 16):
                cpu.wf(register, -17.375 * (register + 1))
            saved_x = cpu.x[19:29].copy()
            saved_d = [value & ((1 << 64) - 1) for value in cpu.v[8:16]]
            saved_sp = cpu.sp
            answer = call(cpu, entries, name, *args)
            require(cpu.x[19:29] == saved_x, 'Explicit x19-x28 canary: ' + (label or name))
            require([value & ((1 << 64) - 1) for value in cpu.v[8:16]] == saved_d,
                    'Explicit d8-d15 canary: ' + (label or name))
            require(cpu.sp == saved_sp, 'Explicit balanced stack canary: ' + (label or name))
            results.append({'entry': label or name, 'slide': hex(slide), 'preserved': True})
            return answer

        require(checked('update', rt.BAR, rt.PROXY)['result'] == 1, 'Canary fixture builds native control')
        checked('has_native', rt.PROXY)
        control, controller = rt.control(), rt.controller()
        rt.objects[control].state['selectedSegmentIndex'] = 3
        checked('value_changed', controller, rt.sel('nativeSelectionChanged:'), control,
                label='value_changed_success')
        require(rt.route_calls == [3], 'Successful callback canary executes actual host route')
        foreign = rt.view('UISegmentedControl', 'abi_foreign_sender', (0, 0, 44, 44),
                          enabled=True, segments=[], selectedSegmentIndex=0)
        checked('value_changed', controller, rt.sel('nativeSelectionChanged:'), foreign,
                label='value_changed_early_return')
        require(rt.route_calls == [3], 'Early-return callback canary has no route')
        checked('restore', rt.BAR, rt.PROXY)
        require(checked('has_native', rt.PROXY, label='has_native_after_restore')['result'] == 0,
                'Restored proxy reports no native bridge')
    return results


def main():
    parser = argparse.ArgumentParser(description=__doc__)
    parser.add_argument('--candidate', type=Path, required=True)
    parser.add_argument('--report', type=Path)
    args = parser.parse_args()
    data = args.candidate.read_bytes()
    report = {'passed': False, 'candidate_sha256': hashlib.sha256(data).hexdigest(),
              'scope': 'Actual ARM64 native bridge plus original click/sync instructions; public UIKit/Foundation boundaries',
              'device_tested': False, 'native_internal_drag_observed': False,
              'gpu_refraction_tested': False, 'physical_hit_testing_tested': False, 'cases': []}
    try:
        native_entries(data)
        for name, test in (
                ('native_build_true_titles_and_programmatic_sync', build_and_sync),
                ('actual_title_fallback_or_failure', title_fallback_and_rejection),
                ('original_routing_duplicate_guard_and_reentry', routing_and_reentry),
                ('tracking_preview_respects_true_host_selection', tracking_preview_and_host_authority),
                ('invalid_callback_fail_closed', invalid_callbacks),
                ('reorder_replacement_window_and_teardown', reorder_replacement_and_teardown),
                ('hidden_state_ownership', hidden_state_ownership),
                ('allocation_failure_restores_fallback', allocation_failure_is_fallback),
                ('weak_lifetime_and_stale_callback', weak_lifetime_and_stale_callbacks),
                ('explicit_callee_saved_register_canaries', explicit_callee_saved_canaries)):
            detail = test(data)
            report['cases'].append({'name': name, 'passed': True, 'detail': detail})
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
