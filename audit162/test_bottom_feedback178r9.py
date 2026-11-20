#!/usr/bin/env python3
"""Check the device-observed video delegate and compact dock touch geometry."""
import argparse
import hashlib
import json
from pathlib import Path

from arm64 import release_version, require
from test_bottom_appearance178 import (
    BUTTON_WIDTH, COMPACT, HEIGHT, ICONS, LENGTH, PAGE_HOOK, DRAG_METHODS,
    NATIVE_ANIMATION_END, NATIVE_FEED_LAYOUT, NATIVE_FEED_WINDOW, NATIVE_INNER_FEED_TYPE, NATIVE_SETTLE,
    bottom_labels, compact_button, host_geometry, page_drag, send_pan,
    settled_scroll_lifecycle, scroll_rejections, tap_expand,
)
from test_bottom_interaction178r5 import (
    FRAME_LABELS, changes_for, fixture, host_layout,
)
from test_feed_viewport import labels_for
from test_native_orchestration162 import repair


def observed_dock(data, labels):
    cases = []
    drag_selection = release_version(data) in ('1.78R14', '1.78R15', '1.78R16', '1.78R25', "1.78R26", "1.78R27", "1.78R28", "1.78R29", "1.78R30", "1.78R31", "1.78R32", "1.78R33", "1.78R34", "1.78R35", "1.78R36", "1.79R1", "1.79R2", "1.79R3", "1.79R4", "1.79R5", "1.8R1", "1.8R2", "1.8R3", "1.8R4", "1.8R5", "1.8R6", "1.8R7", "1.8R8", "1.8R9", "1.8R10", "1.8R11", "1.8R12", "1.8R13", "1.8R14", "1.8R15", "1.8R16", "1.8R17", "1.8R18", "1.8R19", "1.8R19", "1.9.1beta1", "1.9.1beta2", "1.9.1beta3", "1.9.1beta4", "1.9.1beta5", "1.9.1beta6")
    for fallback in (False, True):
        for icons, minimum in ((False, 64), (True, 56)):
            cpu, rt, entries = fixture(data, labels, fallback=fallback)
            rt.objects[rt.BAR].state.update(frame=(0., 800., 402., 74.), bounds=(0., 0., 402., 74.))
            stock = (20., 0., 362., 56.)
            for length, height, button_width in ((50, 80, 95), (68, 80, 100), (80, 95, 90)):
                rt.defaults(**{ICONS: icons, LENGTH: length, HEIGHT: height, BUTTON_WIDTH: button_width})
                host_layout(cpu, rt, entries, labels, stock)
                capsule = rt.objects[rt.PROXY].state['frame']
                require(capsule[2] >= minimum * 4 + 8,
                        'The four navigation entries retain readable horizontal space')
                require(0 <= capsule[1] and capsule[1] + capsule[3] <= 74,
                        'The complete tap surface stays inside the host tab bar')
                frames = [rt.objects[button].state['frame'] for button in rt.buttons]
                for frame in frames:
                    require(frame[2] >= minimum and frame[3] >= 44,
                            'Both size sliders preserve minimum target width and height')
                    require(frame[0] >= 0 and frame[0] + frame[2] <= capsule[2] and
                            frame[1] >= 0 and frame[1] + frame[3] <= capsule[3],
                            'Every visible target is inside the capsule and its hit-test ancestors')
                if drag_selection:
                    overlay = rt.associated(rt.PROXY, 'overlay')
                    require(overlay and not rt.control() and
                            rt.objects[overlay].state['frame'] == capsule and
                            rt.objects[overlay].state['userInteractionEnabled'] and
                            all(rt.objects[button].state['superview'] == overlay and
                                rt.objects[button].state['userInteractionEnabled']
                                for button in rt.buttons),
                            'Drag overlay and original buttons cover the same full hit area')
                elif not fallback:
                    control = rt.objects[rt.control()].state
                    require(control.get('userInteractionEnabled', True) and
                            rt.objects[rt.PROXY].state.get('userInteractionEnabled', True) and
                            rt.objects[rt.PROXY_CONTENT].state.get('userInteractionEnabled', True),
                            'The native selector and both ancestors receive touches')
                    target = control['frame']
                    require(abs(target[0] + 4 - frames[0][0]) < .001 and
                            abs(target[0] + target[2] - 4 - frames[-1][0] - frames[-1][2]) < .001,
                            'The native selector and visible labels use the same segment track')
                start = len(rt.frame_changes)
                for _ in range(3):
                    host_layout(cpu, rt, entries, labels, stock)
                require(not changes_for(rt, start, (rt.PROXY, rt.PROXY_CONTENT, *rt.buttons, rt.control())),
                        'Repeated native layout cannot shrink or move a target during tracking')
                renderer = 'explicit pan' if drag_selection else 'fallback' if fallback else 'native'
                cases.append({'renderer': renderer, 'icons': icons,
                              'length': length, 'height': height, 'button_width': button_width,
                              'capsule': capsule, 'minimum_target_width': min(f[2] for f in frames)})
    return cases


def observed_video_delegate(data, labels):
    cpu, rt, entries = fixture(data, labels, selected=1)
    # Explicit device boundary: the scrolling collection is owned by an NSObject
    # component, not the UIView used by bookstore and bookshelf feeds.
    rt.feed_class = 'FQVCollectionView'
    rt.feed_owner_class = 'FQVShortVideoListVCScrollComponent'
    feed, _, _ = rt.add_feed()
    rt.defaults(**{COMPACT: True})
    repair(cpu, rt, entries)
    page_drag(cpu, rt, feed, 4, 5, decelerates=True)
    repair(cpu, rt, entries)
    require(compact_button(rt), 'The actual FQV video paging delegate must compact after settling')
    for selector, _, original in DRAG_METHODS:
        method = rt.get_method(rt.classes['FQFeedListView'], rt.sel(selector))
        require(method and rt.methods[method]['imp'] == original,
                'Bookstore and bookshelf feed callbacks are not hooked for video compaction')
    return {'collection': 'FQVCollectionView', 'delegate': 'FQVShortVideoListVCScrollComponent',
            'page_transition': [4, 5], 'compacted': True}


def native_scroll_completion_and_dock_position(data, labels):
    cases = []
    begin, end, decelerated = (method[0] for method in DRAG_METHODS)
    animation_ended = NATIVE_ANIMATION_END[0]
    stock = (20., 0., 376., 56.)
    position_key = 'FanqieX.BottomDramaCompactPosition.1'
    for position, x, completion in ((0, 336., end), (1, 20., decelerated), (2, 190., animation_ended)):
        cpu, rt, entries = fixture(data, labels, selected=1, stock=stock)
        feed, _, _ = rt.add_feed()
        state = rt.objects[feed].state
        state.update(frame=(0., 0., 440., 956.), bounds=(0., 0., 440., 956.),
                     contentOffset=(0., 0.), pageIndex=None)
        rt.defaults(**{COMPACT: True, position_key: position})
        repair(cpu, rt, entries)
        selected = rt.objects[rt.BAR].state['selectedItem']
        owner = state['listOwner']

        cpu.run(0xa5d4, args=(owner, rt.sel(begin), feed), max_steps=3000000)
        state['contentOffset'] = (0., 200.)
        cpu.run(0xa5d4, args=(owner, rt.sel(end), feed, 0), max_steps=3000000)
        repair(cpu, rt, entries)
        require(not compact_button(rt), 'A partial drag preserves the expanded dock')

        state['contentOffset'] = (0., 956.)
        cpu.run(0xa5d4, args=(owner, rt.sel(begin), feed), max_steps=3000000)
        state.update(contentOffset=(0., 1912.), decelerating=completion == decelerated,
                     scrollAnimating=completion == animation_ended)
        geometry = host_geometry(rt, (feed,))
        cpu.run(0xa5d4, args=(owner, rt.sel(end), feed, int(state['decelerating'])), max_steps=3000000)
        if completion != end:
            cpu.run(0xa5d4, args=(owner, rt.sel(NATIVE_SETTLE[0])), max_steps=3000000)
            repair(cpu, rt, entries)
            require(not compact_button(rt), 'A premature native callback must preserve the pending drag')
            state['decelerating'] = False
            cpu.run(0xa5d4, args=(owner, rt.sel(completion), feed), max_steps=3000000)
        repair(cpu, rt, entries)
        button = compact_button(rt)
        expected = (x, 0., 60., 60.)
        require(button and rt.objects[button].state['frame'] == expected and
                rt.objects[rt.PROXY].state['frame'] == expected,
                'The actual settled gesture places the glass and its touch target at the saved position')
        require(host_geometry(rt, (feed,)) == geometry, 'Compaction preserves native feed geometry')

        tap_expand(cpu, rt)
        repair(cpu, rt, entries)
        require(not compact_button(rt) and rt.objects[rt.PROXY].state['frame'] == stock and
                rt.objects[rt.BAR].state['selectedItem'] == selected,
                'A tap restores the expanded geometry at the same selection from every position')
        state.update(contentOffset=(0., 2868.), scrollAnimating=False)
        cpu.run(0xa5d4, args=(owner, rt.sel(animation_ended), feed), max_steps=3000000)
        repair(cpu, rt, entries)
        require(not compact_button(rt), 'Programmatic paging cannot compact without a new gesture')
        cases.append({'native_completion': completion, 'nil_native_index': True,
                      'position': position, 'compacted_frame': expected, 'tap_expands': True})
    return cases


def native_pan_and_settled_offset(data, labels):
    cases = []
    stock = (20., 0., 376., 56.)
    position_key = 'FanqieX.BottomDramaCompactPosition.1'
    for position, x in ((0, 336.), (1, 20.), (2, 190.)):
        cpu, rt, entries = fixture(data, labels, selected=1, stock=stock)
        if release_version(data) in ('1.78R24', '1.78R25', "1.78R26", "1.78R27", "1.78R28", "1.78R29", "1.78R30", "1.78R31", "1.78R32", "1.78R33", "1.78R34", "1.78R35", "1.78R36", "1.79R1", "1.79R2", "1.79R3", "1.79R4", "1.79R5", "1.8R1", "1.8R2", "1.8R3", "1.8R4", "1.8R5", "1.8R6", "1.8R7", "1.8R8", "1.8R9", "1.8R10", "1.8R11", "1.8R12", "1.8R13", "1.8R14", "1.8R15", "1.8R16", "1.8R17", "1.8R18", "1.8R19", "1.8R19", "1.9.1beta1", "1.9.1beta2", "1.9.1beta3", "1.9.1beta4", "1.9.1beta5", "1.9.1beta6"):
            # The selected outer tab is Short Drama even when its container
            # provider reports a recommendation category with another type.
            rt._add(rt.classes['SSTabBarController'], 'currentSelectedVCTabType', NATIVE_INNER_FEED_TYPE, 'i16@0:8')
            rt.objects[rt.owner].state['innerFeedType'] = 0
        feed, pan, target = rt.add_feed()
        state = rt.objects[feed].state
        state.update(frame=(0., 0., 440., 956.), pageIndex=None)
        rt.defaults(**{COMPACT: True, position_key: position})

        def offset(y):
            state.update(contentOffset=(0., y), bounds=(0., y, 440., 956.))

        offset(0.)
        repair(cpu, rt, entries)
        for _ in range(2):
            cpu.run(0xa5d4, args=(feed, rt.sel(NATIVE_FEED_WINDOW[0])), max_steps=3000000)
        gesture = rt.objects[pan].state
        require(gesture['delegate'] == gesture['target'] == target and
                gesture['action'] == rt.sel('hostPan:') and len(gesture['extra_targets']) == 1,
                'One extra target observes the native recognizer without replacing its delegate or action')
        send_pan(cpu, rt, pan, 1)
        offset(418.3333333333333)
        send_pan(cpu, rt, pan, 3)
        for y in (418.3333333333333, 882.):
            offset(y)
            cpu.run(0xa5d4, args=(feed, rt.sel(NATIVE_FEED_LAYOUT[0])), max_steps=3000000)
            repair(cpu, rt, entries)
            require(not compact_button(rt), 'The released pan waits for an actual full-page position')

        offset(956.)
        state['decelerating'] = True
        geometry = host_geometry(rt, (feed,))
        cpu.run(0xa5d4, args=(feed, rt.sel(NATIVE_FEED_LAYOUT[0])), max_steps=3000000)
        repair(cpu, rt, entries)
        button = compact_button(rt)
        expected = (x, 0., 60., 60.)
        require(button and rt.objects[button].state['frame'] == expected and
                rt.objects[rt.PROXY].state['frame'] == expected,
                'Observed scrolling compacts at the saved position without private completion callbacks')
        require(host_geometry(rt, (feed,)) == geometry, 'Compaction preserves verified viewport bounds and offset')

        tap_expand(cpu, rt)
        repair(cpu, rt, entries)
        require(rt.objects[rt.PROXY].state['frame'] == stock, 'The compact control restores its stock frame on tap')
        state['decelerating'] = False
        send_pan(cpu, rt, pan, 1)
        offset(1200.)
        send_pan(cpu, rt, pan, 4)
        offset(1912.)
        cpu.run(0xa5d4, args=(feed, rt.sel(NATIVE_FEED_LAYOUT[0])), max_steps=3000000)
        repair(cpu, rt, entries)
        require(not compact_button(rt), 'A canceled gesture and unrelated programmatic paging cannot compact')
        cases.append({'position': position, 'native_offsets': [0., 418.3333333333333, 956.],
                      'compacted_frame': expected, 'tap_expands': True})
    return cases


def main():
    parser = argparse.ArgumentParser(description=__doc__)
    parser.add_argument('candidate', type=Path)
    parser.add_argument('--report', type=Path, required=True)
    args = parser.parse_args()
    data = args.candidate.read_bytes()
    labels = labels_for(data, args.candidate.with_suffix('.composed.s'),
                        [*bottom_labels(data), PAGE_HOOK, *FRAME_LABELS])
    report = {'passed': True, 'sha256': hashlib.sha256(data).hexdigest(),
              'observed_delegate': observed_video_delegate(data, labels),
              'observed_dock': observed_dock(data, labels),
              'settled_scroll': settled_scroll_lifecycle(data, labels),
              'excluded_contexts': scroll_rejections(data, labels),
              'device_tested': False, 'physical_touch_tested': False,
              'boundary': 'Actual candidate ARM64; explicit UIKit/Foundation boundary objects'}
    if release_version(data) == '1.78R22':
        report['native_scroll_completion'] = native_scroll_completion_and_dock_position(data, labels)
    if release_version(data) in ('1.78R23', '1.78R24', '1.78R25', "1.78R26", "1.78R27", "1.78R28", "1.78R29", "1.78R30", "1.78R31", "1.78R32", "1.78R33", "1.78R34", "1.78R35", "1.78R36", "1.79R1", "1.79R2", "1.79R3", "1.79R4", "1.79R5", "1.8R1", "1.8R2", "1.8R3", "1.8R4", "1.8R5", "1.8R6", "1.8R7", "1.8R8", "1.8R9", "1.8R10", "1.8R11", "1.8R12", "1.8R13", "1.8R14", "1.8R15", "1.8R16", "1.8R17", "1.8R18", "1.8R19", "1.8R19", "1.9.1beta1", "1.9.1beta2", "1.9.1beta3", "1.9.1beta4", "1.9.1beta5", "1.9.1beta6"):
        report['native_pan_and_settled_offset'] = native_pan_and_settled_offset(data, labels)
    args.report.parent.mkdir(parents=True, exist_ok=True)
    args.report.write_text(json.dumps(report, ensure_ascii=False, indent=2) + '\n', encoding='utf-8')
    print(json.dumps(report, ensure_ascii=False, indent=2))


if __name__ == '__main__':
    main()
