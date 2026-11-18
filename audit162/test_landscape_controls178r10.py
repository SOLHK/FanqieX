#!/usr/bin/env python3
"""Replay the R9 device feedback at native layout and material boundaries."""
import argparse
import hashlib
import json
from pathlib import Path

from arm64 import require, release_version
from test_controls171 import call
from test_control_glass166 import send
from test_feed_viewport import labels_for
from test_page_glass174 import EXTRA, make
from test_landscape_feedback178r9 import Runtime as BaseRuntime, INFO, RIGHT, SOCIAL


class Runtime(BaseRuntime):
    def __init__(self, data):
        super().__init__(data)
        if 'UIStackView' not in self.classes:
            self._class('UIStackView', 'UIView')

    def handle(self, cpu, pc):
        receiver, selector = cpu.x[:2]
        name = self.selector_names.get(selector)
        if pc - self.slide == 0xa5d4 and receiver in self.objects:
            state = self.objects[receiver].state
            if name in ('stackView', 'titleL'):
                return self.finish(cpu, state.get(name, 0))
            if name == 'layoutIfNeeded' and self.is_kind(receiver, self.classes['UIStackView']):
                # UIKit's nested stack resolves these intrinsic-size children
                # after the outer layout callback; the plugin must request it.
                for button, frame in state.get('pendingFrames', {}).items():
                    self.objects[button].state.update(frame=frame, bounds=(0., 0., *frame[2:]))
                state['stackLayouts'] = state.get('stackLayouts', 0) + 1
                return self.finish(cpu)
        return super().handle(cpu, pc)


def glass_in(rt, view):
    return [v for v in rt.objects[view].state['subviews'] if rt.objects[v].state.get('configuration')]


def exercise(data, labels):
    cpu, rt = make(data, Runtime)
    rt.labels = labels
    call(cpu, labels, 'LFQH_FQHPageInstall')
    prefs = rt.objects[rt.DEFAULTS].state['values']
    title_gap = 12 if release_version(data) in ('1.78R12', '1.78R13', '1.78R14', '1.78R15', '1.78R16', '1.78R25', "1.78R26", "1.78R27", "1.78R28", "1.78R29", "1.78R30", "1.78R31", "1.78R32", "1.78R33", "1.78R34", "1.78R35", "1.78R36", "1.79R1", "1.79R2", "1.79R3", "1.79R4", "1.79R5", "1.8R1", "1.8R2", "1.8R3", "1.8R4", "1.8R5") else 8

    info = rt.view(INFO, 'landscape info', (0., 0., 844., 390.))
    top = rt.view('UIView', 'top controls', (16., 4., 760., 44.), info)
    back = rt.view('UIImageView', 'back glyph', (6., 8., 14., 18.), top)
    title = rt.view('UILabel', 'video title', (31., 8., 400., 20.), top)
    rt.objects[info].state.update(navBackImageView=back, titleL=title)
    send(cpu, rt, info, 'layoutSubviews')
    backing = glass_in(rt, top)
    require(len(backing) == 1, 'The back glyph keeps one noninteractive sibling glass')
    capsule = rt.objects[backing[0]].state['frame']
    target = rt.objects[title].state['frame']
    require(target[0] - capsule[0] - capsule[2] == title_gap and target[0] + target[2] == 431,
            'The title keeps its release gap from the capsule and preserves its native right edge')
    for _ in range(3):
        send(cpu, rt, info, 'layoutSubviews')
    require(rt.objects[title].state['frame'] == target, 'Repeated title layout does not accumulate offsets')
    fresh = (32., 8., 300., 20.)
    rt.objects[title].state.update(frame=fresh, bounds=(0., 0., 300., 20.))
    send(cpu, rt, info, 'layoutSubviews')
    changed = rt.objects[title].state['frame']
    require(changed[0] == 31 + title_gap and changed[0] + changed[2] == 332,
            'A new host title frame replaces the stored baseline')

    right = rt.view(RIGHT, 'bottom controls', (600., 340., 220., 32.))
    stack = rt.view('UIStackView', 'native arranged buttons', (0., 0., 220., 32.), right)
    rt.objects[right].state['stackView'] = stack
    buttons = []
    pending = {}
    for key, frame in zip(('playRateBtn', 'resolutionBtn', 'seriesBtn'),
                          ((0., 0., 62., 32.), (78., 0., 62., 32.), (156., 0., 64., 32.))):
        button = rt.view('UIButton', key, (0., 0., 0., 0.), stack, originalAction=key)
        buttons.append(button)
        pending[button] = frame
        rt.objects[right].state[key] = button
    rt.objects[stack].state['pendingFrames'] = pending
    send(cpu, rt, right, 'layoutSubviews')
    require(rt.objects[stack].state.get('stackLayouts') == 1,
            'The exact owned stack finishes native layout before decoration')
    for button in buttons:
        material = glass_in(rt, button)
        require(len(material) == 1 and rt.objects[material[0]].state['frame'] == rt.objects[button].state['bounds'],
                'All three text buttons get glass on the first resolved stack layout')
        require(rt.objects[button].state['frame'] == pending[button], 'Button hit rectangles remain native')

    social = rt.view(SOCIAL, 'bottom social row', (20., 340., 420., 32.))
    input_view = rt.view('UIView', 'danmaku input', (200., 0., 160., 32.), social)
    old_blur = rt.obj('NSObject', 'original blur effect')
    background = rt.view('UIVisualEffectView', 'native opaque blur', (0., 0., 160., 32.), input_view,
                         effect=old_blur, hidden=False)
    label = rt.view('UILabel', 'input placeholder', (10., 0., 140., 32.), input_view)
    rt.objects[social].state.update(danmakuInputView=input_view, danmakuInputBGView=background)
    send(cpu, rt, social, 'layoutSubviews')
    materials = glass_in(rt, input_view)
    require(len(materials) == 1 and rt.objects[background].state['hidden'],
            'The host blur is suppressed only after the input glass actually exists')
    require(not rt.objects[label].state['hidden'] and rt.objects[background].state['effect'] == old_blur,
            'The foreground stays visible and the native effect is retained for restoration')

    prefs['FanqieAdBlock.GlassDisabled.1'] = True
    for owner in (info, right, social):
        send(cpu, rt, owner, 'layoutSubviews')
    require(rt.objects[title].state['frame'] == fresh and rt.objects[back].state['frame'] == (6., 8., 14., 18.),
            'Disabling restores the latest title baseline without moving the back target')
    require(not rt.objects[background].state['hidden'] and rt.objects[background].state['effect'] == old_blur,
            'Disabling restores the original visible blur')
    require(not glass_in(rt, input_view) and all(not glass_in(rt, b) for b in buttons),
            'Disabling removes only plugin materials')
    # Host-hidden paint remains hidden when the plugin did not create that state.
    rt.objects[background].state['hidden'] = True
    prefs['FanqieAdBlock.GlassDisabled.1'] = False
    send(cpu, rt, social, 'layoutSubviews')
    prefs['FanqieAdBlock.GlassDisabled.1'] = True
    send(cpu, rt, social, 'layoutSubviews')
    require(rt.objects[background].state['hidden'], 'A preexisting hidden background stays hidden')
    return {'title_gap_pt': title_gap, 'title_right_edge_and_restore': True,
            'nested_stack_first_layout': True, 'input_blur_replaced_and_restored': True,
            'native_touch_rects_preserved': True}


def main():
    parser = argparse.ArgumentParser(description=__doc__)
    parser.add_argument('candidate', type=Path)
    parser.add_argument('--report', type=Path, required=True)
    args = parser.parse_args()
    data = args.candidate.read_bytes()
    labels = labels_for(data, args.candidate.with_suffix('.composed.s'), EXTRA)
    report = {'passed': True, 'candidate_sha256': hashlib.sha256(data).hexdigest(),
              **exercise(data, labels), 'device_tested': False}
    args.report.write_text(json.dumps(report, ensure_ascii=False, indent=2) + '\n', encoding='utf8')
    print(json.dumps(report, indent=2))


if __name__ == '__main__':
    main()
