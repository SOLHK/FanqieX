#!/usr/bin/env python3
"""Behavioral audit of candidate ARM64 interaction code, not UIKit pixels."""
import argparse
import hashlib
import json
import math
from pathlib import Path

from arm64 import require
from interaction_runtime import make


def run_all(data):
    cases = []

    def fixture(**options):
        c, r, e = make(data, **options)
        c.run(e['update'], r.BAR, r.PROXY)
        require(r.associated(r.PROXY, 'overlay') != 0, 'Overlay created')
        return c, r, e

    def objects(r):
        return (r.associated(r.PROXY, 'controller'), r.associated(r.PROXY, 'pan'),
                r.associated(r.PROXY, 'lens'), r.associated(r.PROXY, 'overlay'))

    def fire(c, r, e, state, x, y=28):
        ctrl, pan, _, _ = objects(r)
        r.objects[pan].state.update(state=state, location=(x, y))
        c.run(e['pan'], ctrl, r.sel('pan:'), pan)

    def begin(c, r, e, finger_offset=0):
        ctrl, pan, lens, _ = objects(r)
        f = r.objects[lens].state['frame']
        x = f[0]+f[2]/2+finger_offset
        require(c.run(e['should_begin'], ctrl, r.sel('gestureRecognizerShouldBegin:'), pan)['result'],
                'A horizontal one-finger gesture begins')
        fire(c, r, e, 1, x)
        require(r.associated(ctrl, 'drag') == ctrl, 'Begin records active drag without retaining itself')
        return x

    c, r, e = fixture()
    ctrl, pan, lens, overlay = objects(r)
    require(r.objects[overlay].state['superview'] == r.BAR and
            r.objects[r.PROXY].state['superview'] == r.BAR and
            r.objects[lens].state['superview'] == overlay,
            'Lens overlay and base proxy are siblings, not nested visual effects')
    require(all(r.objects[p].state['superview'] == overlay for p in r.buttons),
            'Original button identities are reparented intact')
    require(r.objects[overlay].state['subviews'] == [lens]+r.buttons,
            'All original button labels remain above the decorative lens')
    require(all(r.objects[p].state['originalTarget'] == r.BAR and
                r.objects[p].state['accessibilityLabel'] == 'tab-'+str(i)
                for i, p in enumerate(r.buttons)), 'Targets/accessibility preserved')
    for p in (r.PROXY, overlay, lens):
        require(r.objects[p].state['alpha'] == 1, 'No alpha-based glass compositing')
    effect = r.objects[lens].state['effect']
    content = r.objects[lens].state['contentView']
    require(effect == 0 and r.objects[content].state['backgroundColor'] == r.color('secondarySystemFillColor'),
            'Resting selection is an adaptive gray capsule, without a second glass material')
    require(r.objects[lens].state['userInteractionEnabled'] is False,
            'Resting selection cannot intercept the original button touches')
    require(r.objects[pan].state['delaysTouchesBegan'] == 0 and r.objects[pan].state['delaysTouchesEnded'] == 0,
            'Owned pan does not add began/ended delivery delays to ordinary taps')
    require(r.objects[pan].state['minimumTouches'] == r.objects[pan].state['maximumTouches'] == 1 and
            r.objects[pan].state['cancelsTouchesInView'] == 1, 'Gesture single-touch cancellation configuration')
    cases.append({'name': 'build_ownership_native_material', 'passed': True})

    for name, velocity, touches, expected in (
        ('horizontal', (80, 10), 1, True), ('vertical', (10, 80), 1, False),
        ('diagonal_tie', (20, 20), 1, False), ('two_fingers', (80, 0), 2, False),
        ('stationary', (0, 0), 1, False), ('nonfinite', (math.inf, 0), 1, False)):
        r.objects[pan].state.update(velocity=velocity, numberOfTouches=touches)
        got = bool(c.run(e['should_begin'], ctrl, 0, pan)['result'])
        require(got == expected, 'Direction/touch gate: '+name)
    r.objects[pan].state.update(velocity=(80, 0), numberOfTouches=1)
    cases.append({'name': 'direction_and_multitouch_gates', 'passed': True})

    finger = begin(c, r, e, 17)
    drag_effect = r.objects[lens].state['effect']
    require(drag_effect and r.class_names[r.objects[drag_effect].cls] == 'UIGlassEffect' and
            r.objects[drag_effect].state['style'] == 1 and r.objects[drag_effect].state['interactive'],
            'A drag lifts the selection into native clear interactive glass')
    require(r.objects[content].state['backgroundColor'] == r.color('clearColor'),
            'Drag removes the opaque fill while preserving alpha=1')
    initial = r.objects[lens].state['frame']
    fire(c, r, e, 2, finger+35)
    moved = r.objects[lens].state['frame']
    require(moved[0] == initial[0]+35 and r.route_calls == [], 'Changed moves continuously without selecting a page')
    for _ in range(3):
        c.run(e['update'], r.BAR, r.PROXY)
    require(r.objects[lens].state['frame'] == moved and r.associated(ctrl, 'drag') == ctrl and
            r.cancel_callbacks == 0, 'Repeated one-second maintenance preserves an active drag')
    fire(c, r, e, 3, 55+17)
    require(r.route_calls == [0] and r.selected_index() == 0, 'Ended calls original route exactly once')
    require(r.objects[lens].state['effect'] == 0 and
            r.objects[content].state['backgroundColor'] == r.color('secondarySystemFillColor'),
            'End restores gray selected fill after committing the true selection')
    require(r.objects[lens].state['frame'] == r.objects[r.buttons[0]].state['frame'], 'True selected item snaps after original sync')
    fire(c, r, e, 3, 361+17)
    require(r.route_calls == [0], 'Duplicate ended callback cannot commit twice')
    cases.append({'name': 'offset_continuity_maintenance_single_commit', 'passed': True})

    for rtl, end_x, expected in ((False, -1000, 0), (False, 10000, 3),
                                (True, -1000, 3), (True, 10000, 0)):
        c2, r2, e2 = fixture(rtl=rtl)
        begin(c2, r2, e2)
        fire(c2, r2, e2, 2, end_x)
        _, _, l2, _ = objects(r2)
        f = r2.objects[l2].state['frame']
        require(4 <= f[0] <= 310 and f[0]+f[2] <= 412, 'Lens clamps inside actual tab extents')
        fire(c2, r2, e2, 3, end_x)
        require(r2.route_calls == [expected], 'Actual centers choose correct RTL/LTR button')
    cases.append({'name': 'physical_centers_rtl_and_extreme_clamping', 'passed': True})

    for state in (4, 5):
        c2, r2, e2 = fixture()
        begin(c2, r2, e2)
        fire(c2, r2, e2, 2, 55)
        fire(c2, r2, e2, state, 55)
        _, _, l2, _ = objects(r2)
        require(r2.route_calls == [] and r2.selected_index() == 2 and
                r2.objects[l2].state['frame'] == r2.objects[r2.buttons[2]].state['frame'],
                'Cancelled/failed snaps without routing')
    cases.append({'name': 'cancelled_failed_no_selection', 'passed': True})

    c2, r2, e2 = fixture()
    begin(c2, r2, e2)
    r2.objects[r2.BAR].state['selectedItem'] = r2.items[1]
    c2.run(e2['update'], r2.BAR, r2.PROXY)
    ct2, p2, l2, _ = objects(r2)
    require(r2.cancel_callbacks == 1 and not r2.associated(ct2, 'drag') and
            r2.objects[p2].state['enabled'] and r2.route_calls == [],
            'External selection cancels synchronously without committing')
    require(r2.objects[l2].state['frame'] == r2.objects[r2.buttons[1]].state['frame'],
            'External true selection becomes visible')
    cases.append({'name': 'external_selection_wins_synchronous_cancel', 'passed': True})

    c2, r2, e2 = fixture()
    begin(c2, r2, e2)
    ct2, p2, _, ov2 = objects(r2)
    c2.run(e2['restore'], r2.BAR, r2.PROXY)
    require(r2.cancel_callbacks == 1 and r2.route_calls == [] and not r2.associated(ct2, 'drag'),
            'Teardown cancellation is reentrant-safe')
    require(r2.objects[ov2].state['superview'] == 0 and r2.objects[p2].state['view'] == 0,
            'Overlay/recognizer detach')
    require(all(r2.objects[b].state['superview'] == r2.PROXY_CONTENT for b in r2.buttons),
            'Restoration reparents all still-owned buttons')
    require(all(not r2.associated(r2.PROXY, k) for k in ('overlay','lens','controller','pan','owned_buttons')),
            'All owned associations cleared')
    c2.run(e2['restore'], r2.BAR, r2.PROXY)
    c2.run(e2['restore'], r2.BAR, 0)
    cases.append({'name': 'restore_idempotent_synchronous_cancel', 'passed': True})

    for mutation in ('nil', 'reorder', 'replace', 'over_limit'):
        c2, r2, e2 = fixture()
        begin(c2, r2, e2)
        old_buttons = r2.buttons.copy()
        _, old_pan, _, old_overlay = objects(r2)
        if mutation == 'nil':
            r2.associations.pop((r2.PROXY, r2.slide+0xeb85))
        elif mutation == 'over_limit':
            r2.objects[r2.buttons_array].state['items'] = r2.buttons*3
        elif mutation == 'reorder':
            r2.objects[r2.buttons_array].state['items'].reverse()
        else:
            b = r2.view('UIButton', 'replacement', (208,4,102,48), r2.PROXY_CONTENT)
            r2.objects[r2.buttons_array].state['items'][2] = b
        c2.run(e2['update'], r2.BAR, r2.PROXY)
        require(r2.cancel_callbacks == 1 and r2.route_calls == [], 'Array mutation cancels without navigation: '+mutation)
        require(r2.objects[old_overlay].state['superview'] == 0 and r2.objects[old_pan].state['view'] == 0,
                'Old interaction is removed after button mutation')
        if mutation == 'nil':
            require(not r2.associated(r2.PROXY,'overlay') and all(r2.objects[b].state['superview'] == 0 for b in old_buttons),
                    'Missing host array removes stale buttons, without ghosts')
        elif mutation == 'replace':
            require(r2.objects[old_buttons[2]].state['superview'] == 0,
                    'Replaced original button is not resurrected in content')
        elif mutation == 'over_limit':
            require(not r2.associated(r2.PROXY, 'overlay'), 'Unsupported button count falls back safely')
    cases.append({'name': 'nil_reordered_replaced_oversize_arrays', 'passed': True})

    for mode in ('hidden', 'detached', 'nan_frame'):
        c2, r2, e2 = fixture()
        begin(c2, r2, e2)
        if mode == 'hidden': r2.objects[r2.BAR].state['hidden'] = True
        elif mode == 'detached': r2.reparent(r2.BAR, 0)
        else: r2.objects[r2.PROXY].state['frame'] = (math.nan,0,416,56)
        c2.run(e2['update'], r2.BAR, r2.PROXY)
        require(not r2.associated(r2.PROXY, 'overlay') and r2.route_calls == [],
                'Hidden/detached/nonfinite layout tears down without route: '+mode)
    cases.append({'name': 'visibility_window_nonfinite_fail_closed', 'passed': True})

    for name in ('UIView', 'UIVisualEffectView', 'UIPanGestureRecognizer'):
        c2, r2, e2 = make(data)
        r2.fail_alloc.add(name)
        c2.run(e2['update'], r2.BAR, r2.PROXY)
        require(not r2.associated(r2.PROXY, 'overlay') and
                all(r2.objects[b].state['superview'] == r2.PROXY_CONTENT for b in r2.buttons),
                'Allocation failure leaves original controls in place: '+name)
    cases.append({'name': 'allocation_failure_non_destructive', 'passed': True})

    c2, r2, e2 = fixture(slide=0x100000000)
    begin(c2, r2, e2)
    fire(c2, r2, e2, 3, 361)
    require(r2.route_calls == [3], 'Image-relative runtime/class/association references survive ASLR')
    cases.append({'name': 'aslr_nonzero_slide', 'passed': True})
    return {'passed': True, 'candidate_sha256': hashlib.sha256(data).hexdigest(),
            'cases': cases, 'case_count': len(cases),
            'scope': 'Actual ARM64 interaction and original click/sync instructions with adversarial caller-saved clobbering, native-call object/gesture model, and outer repair scoped to LIupdate. No UIKit pixels, dyld loading, UIKit hit-testing physics, GPU refraction or device signing test.'}


if __name__ == '__main__':
    p = argparse.ArgumentParser(description=__doc__)
    p.add_argument('candidate')
    p.add_argument('--output')
    a = p.parse_args()
    result = run_all(Path(a.candidate).read_bytes())
    text = json.dumps(result, ensure_ascii=False, indent=2)+'\n'
    if a.output: Path(a.output).write_text(text)
    print(text)
