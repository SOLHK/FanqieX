#!/usr/bin/env python3
"""Exercise fullscreen first layout and one shared right-column visual size."""
import argparse
import hashlib
import json
from pathlib import Path

from arm64 import release_version, require
from test_control_glass166 import send
from test_controls171 import call
from test_drama_controls178r8 import Runtime as BaseRuntime, PLAYER, DISABLED_KEY
from test_feed_viewport import labels_for
from test_page_glass174 import EXTRA, make, selector_address

SIZE_KEY = 'FanqieX.DramaActionDiameter.1'
ROLES = (('SSShortVideoRightInteractionCollectView', 'starIcon'),
         ('SSShortVideoHostRightInteractionCommentView', 'commentIcon'),
         ('SSShortVideoRightInteractionLikeView', 'likeIcon'),
         ('SSShortVideoRightInteractionShareView', 'shareIcon'))


class Runtime(BaseRuntime):
    def __init__(self, data):
        super().__init__(data)
        self._add(self.classes['UIView'], 'layoutSubviews', self.LAYOUT_IMP, 'v16@0:8')
        self._add(self.classes[PLAYER], 'controlViewDidDisplay', self.LAYOUT_IMP, 'v16@0:8')

def materials(rt, parent):
    return [v for v in rt.objects[parent].state['subviews'] if rt.objects[v].state.get('configuration')]


def fullscreen(data, labels):
    cpu, rt = make(data, Runtime)
    rt.labels = labels
    call(cpu, labels, 'LFQH_FQHPageInstall')
    player = rt.view(PLAYER, 'portrait player', (0., 0., 440., 956.))
    paint = rt.color('stock fullscreen pill')
    button = rt.view('UIButton', 'fullscreen target', (0., 0., 0., 0.), player,
                     backgroundColor=paint, originalAction='nativeFullscreen')
    rt.objects[player].state['fullscreenBtn'] = button
    send(cpu, rt, player, 'updateFullscreenBtnLayout')
    require(not materials(rt, button), 'Constraint-only callback does not fabricate unresolved geometry')
    # Native updateFullscreenBtnLayout only changes Masonry constraints. The
    # actual frame appears in the following ordinary UIKit layout pass.
    frame = (176., 610., 88., 28.)
    rt.objects[button].state.update(frame=frame, bounds=(0., 0., 88., 28.))
    glyph = rt.view('UIImageView', 'fullscreen glyph', (12., 6., 12., 16.), button)
    label = rt.view('UILabel', 'fullscreen label', (30., 4., 50., 20.), button)
    send(cpu, rt, player, 'layoutSubviews')
    backing = materials(rt, button)
    require(len(backing) == 1, 'Fullscreen watching gets glass after the first actual layout')
    glass = backing[0]
    require(rt.objects[button].state['subviews'] == [glass, glyph, label] and
            rt.objects[button].state['backgroundColor'] == rt.color('clearColor') and
            not rt.objects[glass].state['userInteractionEnabled'],
            'Only the old fill is removed; foreground and native fullscreen route remain above glass')
    send(cpu, rt, player, 'controlViewDidDisplay')
    send(cpu, rt, player, 'layoutSubviews')
    require(materials(rt, button) == [glass] and rt.objects[button].state['frame'] == frame,
            'Playback reuse keeps one material and the exact native tap frame')
    rt.objects[rt.DEFAULTS].state['values'][DISABLED_KEY] = True
    send(cpu, rt, player, 'layoutSubviews')
    require(not materials(rt, button) and rt.objects[button].state['backgroundColor'] == paint,
            'Disabling glass restores the native fullscreen pill')
    return {'first_native_layout': True, 'foreground_preserved': True, 'reuse_and_restore': True}


def right_column(data, labels):
    cpu, rt = make(data, Runtime)
    rt.labels = labels
    call(cpu, labels, 'LFQH_FQHPageInstall')
    prefs = rt.objects[rt.DEFAULTS].state['values']
    rows = []
    for index, (cls, selector) in enumerate(ROLES):
        owner = rt.view(cls, selector, (372., 500. + 76 * index, 60., 66.), rt.ROOT,
                        originalAction=selector)
        original = (8., 2., 44., 44.)
        image = rt.obj('UIImage', 'native action artwork')
        glyph = rt.view('UIImageView', 'native glyph', original, owner, contentMode=4, image=image,
                        userInteractionEnabled=True, originalAction=selector)
        count = rt.view('UILabel', 'native count', (0., 48., 60., 18.), owner)
        rt.objects[owner].state[selector] = glyph
        call(cpu, labels, 'LFQH_FQHDramaGlyph', owner, selector_address(data, selector))
        rows.append((owner, glyph, count, original, image))

    def check(diameter):
        for owner, glyph, count, original, image in rows:
            glass, = materials(rt, owner)
            frame = rt.objects[glass].state['frame']
            icon = rt.objects[glyph].state['frame']
            cx, cy = original[0] + original[2] / 2, original[1] + original[3] / 2
            require(frame[2:] == (diameter, diameter) and
                    (frame[0] + diameter / 2, frame[1] + diameter / 2) == (cx, cy),
                    'All four circles share the absolute diameter at the original icon center')
            require(icon == original and rt.objects[glyph].state['bounds'] == (0., 0., 44., 44.) and
                    rt.objects[glyph].state['image'] == image and rt.objects[glyph].state['contentMode'] == 4 and
                    rt.objects[glyph].state['userInteractionEnabled'] and not rt.objects[glyph].state['subviews'],
                    'Native glyph image, geometry, content mode and interaction remain untouched')
            require(not rt.objects[glass].state['userInteractionEnabled'], 'The resized backing cannot intercept taps')
            require(rt.objects[count].state['frame'] == (0., 48., 60., 18.) and
                    rt.objects[owner].state['bounds'] == (0., 0., 60., 66.),
                    'Numeric captions and native action bounds never resize')

    check(50.)
    owned = [materials(rt, row[0])[0] for row in rows]
    for value, expected in ((36., 36.), (54., 54.), (42., 42.), (12., 36.), (80., 54.), (float('nan'), 50.)):
        prefs[SIZE_KEY] = value
        for _ in range(2):
            call(cpu, labels, 'LFQH_FQHRefreshDramaActions178R11')
            check(expected)
        require([materials(rt, row[0])[0] for row in rows] == owned,
                'Live slider changes reuse the four materials without repeated scaling')
    # The host can reposition the icon on a later native layout. That new
    # frame becomes the restoration baseline, not the previous custom frame.
    owner, glyph, count, _, _ = rows[0]
    fresh = (10., 4., 40., 40.)
    rt.objects[glyph].state.update(frame=fresh, bounds=(0., 0., 40., 40.))
    call(cpu, labels, 'LFQH_FQHDramaGlyph', owner, selector_address(data, 'starIcon'))
    prefs[DISABLED_KEY] = True
    call(cpu, labels, 'LFQH_FQHRefreshDramaActions178R11')
    for index, (owner, glyph, _, original, image) in enumerate(rows):
        require(not materials(rt, owner) and rt.objects[glyph].state['frame'] == (fresh if index == 0 else original) and
                rt.objects[glyph].state['contentMode'] == 4 and rt.objects[glyph].state['image'] == image,
                'Disabling removes only the material and preserves current host glyph state')
    return {'shared_roles': [selector for _, selector in ROLES], 'default_pt': 50,
            'range_pt': [36, 54], 'live_refresh': True, 'native_targets_and_counts_preserved': True,
            'host_relayout_and_disable_restore': True}


def main():
    parser = argparse.ArgumentParser(description=__doc__)
    parser.add_argument('candidate', type=Path)
    parser.add_argument('--report', type=Path, required=True)
    args = parser.parse_args()
    data = args.candidate.read_bytes()
    entries = EXTRA + ['LFQH_FQHDramaGlyph']
    if release_version(data) in ('1.78R11', '1.78R12'):
        entries.append('LFQH_FQHRefreshDramaActions178R11')
    labels = labels_for(data, args.candidate.with_suffix('.composed.s'), entries)
    report = {'passed': True, 'candidate_sha256': hashlib.sha256(data).hexdigest(),
              'fullscreen': fullscreen(data, labels), 'right_column': right_column(data, labels),
              'device_tested': False, 'pixel_rendering_tested': False}
    args.report.write_text(json.dumps(report, ensure_ascii=False, indent=2) + '\n', encoding='utf8')
    print(json.dumps(report, indent=2))


if __name__ == '__main__':
    main()
