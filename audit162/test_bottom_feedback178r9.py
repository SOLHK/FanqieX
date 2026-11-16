#!/usr/bin/env python3
"""Check the device-observed video delegate and compact dock touch geometry."""
import argparse
import hashlib
import json
from pathlib import Path

from arm64 import release_version, require
from test_bottom_appearance178 import (
    BUTTON_WIDTH, COMPACT, HEIGHT, ICONS, LENGTH, PAGE_HOOK, DRAG_METHODS,
    bottom_labels, compact_button, page_drag, settled_scroll_lifecycle,
    scroll_rejections,
)
from test_bottom_interaction178r5 import (
    FRAME_LABELS, changes_for, fixture, host_layout,
)
from test_feed_viewport import labels_for
from test_native_orchestration162 import repair


def observed_dock(data, labels):
    cases = []
    drag_selection = release_version(data) == '1.78R14'
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
    args.report.parent.mkdir(parents=True, exist_ok=True)
    args.report.write_text(json.dumps(report, ensure_ascii=False, indent=2) + '\n', encoding='utf-8')
    print(json.dumps(report, ensure_ascii=False, indent=2))


if __name__ == '__main__':
    main()
