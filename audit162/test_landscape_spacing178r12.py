#!/usr/bin/env python3
"""Run R12 landscape geometry against explicit native Auto Layout boundaries."""
import argparse
import hashlib
import json
from pathlib import Path

from arm64 import require
from test_controls171 import call
from test_control_glass166 import send
from test_feed_viewport import labels_for
from test_page_glass174 import EXTRA, make
from test_landscape_controls178r10 import Runtime as BaseRuntime, glass_in
from test_landscape_feedback178r9 import INFO, RIGHT, SOCIAL, CONTROL, ADJUST


class Runtime(BaseRuntime):
    def __init__(self, data):
        super().__init__(data)
        self._class('NSLayoutConstraint', 'NSObject')

    def solve_leading(self, constraint):
        state = self.objects[constraint].state
        view = self.objects[state['firstItem']].state
        anchor = self.objects[state['secondItem']].state['frame']
        x = anchor[0] + anchor[2] + state['constant']
        frame = view['frame']
        view.update(frame=(x, frame[1], state['rightEdge'] - x, frame[3]),
                    bounds=(0., 0., state['rightEdge'] - x, frame[3]))

    def handle(self, cpu, pc):
        receiver, selector = cpu.x[:2]
        name = self.selector_names.get(selector)
        if pc - self.slide == 0xa5d4 and receiver in self.objects:
            state = self.objects[receiver].state
            if name in ('constraints', 'firstItem', 'secondItem', 'firstAttribute', 'secondAttribute'):
                return self.finish(cpu, state.get(name, 0))
            if name == 'constant':
                return self.finish(cpu, fp=(state['constant'],))
            if name == 'setConstant:':
                state['constant'] = cpu.fp(0)
                return self.finish(cpu)
            if name == 'layoutIfNeeded' and 'intrinsicButtons' in state:
                # Public UIStackView .fill boundary: its arranged buttons use
                # their native title sizes plus public contentEdgeInsets.
                gap = state['spacing']
                widths = []
                for button, title_width in state['intrinsicButtons']:
                    top, left, bottom, right = self.objects[button].state.get('contentEdgeInsets', (0.,) * 4)
                    widths.append((button, title_width + left + right, 20. + top + bottom))
                total = sum(width for _, width, _ in widths) + gap * (len(widths) - 1)
                right_edge = state['availableWidth']
                x = right_edge - total
                for button, width, height in widths:
                    self.objects[button].state.update(frame=(x, 0., width, height), bounds=(0., 0., width, height))
                    x += width + gap
                return self.finish(cpu)
        return super().handle(cpu, pc)


def leading_constraint(rt, parent, view, anchor, constant, right):
    constraint = rt.obj('NSLayoutConstraint', 'native leading equality', firstItem=view, secondItem=anchor,
                        firstAttribute=1, secondAttribute=2, constant=constant, rightEdge=right)
    rt.objects[parent].state['constraints'] = rt.obj('NSArray', 'native constraints', items=[constraint])
    return constraint


def exercise(data, labels):
    cpu, rt = make(data, Runtime)
    rt.labels = labels
    call(cpu, labels, 'LFQH_FQHPageInstall')
    prefs = rt.objects[rt.DEFAULTS].state['values']
    info = rt.view(INFO, 'landscape info', (0., 0., 844., 390.))
    top = rt.view('UIView', 'native top', (0., 0., 844., 44.), info)
    back = rt.view('UIImageView', 'native back', (6., 8., 14., 18.), top)
    title = rt.view('UILabel', 'native title', (31., 8., 400., 20.), top)
    play = rt.view('UIButton', 'primary play', (390., 170., 56., 56.), info)
    more = rt.view('UIButton', 'native more', (800., 8., 24., 24.), top, clipsToBounds=True)
    rt.objects[info].state.update(navBackImageView=back, titleL=title, playBtn=play, moreBtn=more)
    title_constraint = leading_constraint(rt, top, title, back, 11., 431.)
    send(cpu, rt, info, 'layoutSubviews')
    rt.solve_leading(title_constraint)
    require(rt.objects[title].state['frame'][0] == 43. and rt.objects[title_constraint].state['constant'] == 23.,
            'Later native constraint solving preserves the 12pt title/circle gap')
    for _ in range(3):
        send(cpu, rt, info, 'layoutSubviews')
        rt.solve_leading(title_constraint)
    require(rt.objects[title].state['frame'] == (43., 8., 388., 20.), 'Repeated host layout does not add spacing again')
    require(rt.objects[glass_in(rt, more)[0]].state['frame'][2:] == (36., 36.) and
            rt.objects[glass_in(rt, play)[0]].state['frame'][2:] == (56., 56.),
            'More uses the auxiliary diameter while primary playback keeps its hierarchy')
    require(rt.objects[more].state['frame'] == (800., 8., 24., 24.) and not rt.objects[more].state['clipsToBounds'],
            'Expanded artwork is not clipped and leaves the original more target in place')

    social = rt.view(SOCIAL, 'native social row', (0., 340., 460., 40.))
    danmaku = rt.view('UIImageView', 'danmaku glyph', (250., 0., 30., 32.), social)
    input_view = rt.view('UIView', 'input target', (282., 0., 140., 32.), social)
    rt.objects[social].state.update(danmakuBtnView=danmaku, danmakuInputView=input_view)
    input_constraint = leading_constraint(rt, social, input_view, danmaku, 2., 422.)
    send(cpu, rt, social, 'layoutSubviews')
    rt.solve_leading(input_constraint)
    require(rt.objects[input_view].state['frame'] == (291., 0., 131., 32.) and
            rt.objects[input_constraint].state['constant'] == 11.,
            'Danmaku circle and input capsule retain an 8pt gap and the input right edge')

    circles = []
    for cls, key, size in ((CONTROL, 'screenLockBtn', 30.), (CONTROL, 'landingMuteView', 32.), (ADJUST, None, 32.)):
        owner = rt.view(cls, cls, (0., 0., 80., 80.) if key else (0., 0., size, size))
        target = rt.view('UIView', key, (0., 0., size, size), owner) if key else owner
        if key:
            rt.objects[owner].state[key] = target
        send(cpu, rt, owner, 'layoutSubviews')
        circle = glass_in(rt, target)[0]
        require(rt.objects[circle].state['frame'][2:] == (36., 36.), 'Every auxiliary circular material is 36pt')
        circles.append((owner, target))

    right = rt.view(RIGHT, 'right group in narrow landscape', (328., 340., 220., 36.))
    stack = rt.view('UIStackView', 'native stack', (0., 0., 220., 36.), right, spacing=18., availableWidth=220.)
    rt.objects[right].state['stackView'] = stack
    buttons = []
    for key, width in (('playRateBtn', 34.), ('resolutionBtn', 44.), ('seriesBtn', 28.)):
        button = rt.view('UIButton', key, (0., 0., width, 20.), stack, originalAction=key)
        rt.objects[right].state[key] = button
        buttons.append((button, width))
    rt.objects[stack].state['intrinsicButtons'] = buttons
    send(cpu, rt, right, 'layoutSubviews')
    frames = [rt.objects[button].state['frame'] for button, _ in buttons]
    require(all(rt.objects[b].state['contentEdgeInsets'] == (7., 12., 7., 12.) for b, _ in buttons),
            'All three native text buttons have matching internal padding')
    require(all(frames[i+1][0] - frames[i][0] - frames[i][2] == 12. for i in range(2)),
            'Right-hand capsules have equal 12pt separation')
    require(frames[0][0] >= 0 and frames[-1][0] + frames[-1][2] == 220. and 328. + 220. <= 568. - 20.,
            'The expanded group fits its native right-anchored slot with a 20pt screen margin')

    prefs['FanqieAdBlock.GlassDisabled.1'] = True
    for owner in (info, social, right, *[row[0] for row in circles]):
        send(cpu, rt, owner, 'layoutSubviews')
    rt.solve_leading(title_constraint)
    rt.solve_leading(input_constraint)
    require(rt.objects[title_constraint].state['constant'] == 11. and rt.objects[title].state['frame'] == (31., 8., 400., 20.),
            'Disabling restores the native title constraint and geometry')
    require(rt.objects[input_constraint].state['constant'] == 2. and rt.objects[input_view].state['frame'] == (282., 0., 140., 32.),
            'Disabling restores the native input constraint and geometry')
    require(rt.objects[more].state['clipsToBounds'] and rt.objects[stack].state['spacing'] == 18. and
            all(rt.objects[b].state['contentEdgeInsets'] == (0., 0., 0., 0.) for b, _ in buttons),
            'Native clipping, stack spacing and content insets all restore')
    return {'title_gap_pt': 12, 'danmaku_gap_pt': 8, 'auxiliary_diameter_pt': 36,
            'primary_play_diameter_pt': 56, 'capsule_gap_pt': 12, 'native_constraint_relayout': True,
            'native_actions_preserved': True, 'narrow_landscape_right_margin_pt': 20, 'disable_restores': True}


def main():
    parser = argparse.ArgumentParser(description=__doc__)
    parser.add_argument('candidate', type=Path)
    parser.add_argument('--report', type=Path, required=True)
    args = parser.parse_args()
    data = args.candidate.read_bytes()
    labels = labels_for(data, args.candidate.with_suffix('.composed.s'), EXTRA)
    report = {'passed': True, 'candidate_sha256': hashlib.sha256(data).hexdigest(), **exercise(data, labels),
              'device_tested': False, 'pixel_rendering_tested': False}
    args.report.write_text(json.dumps(report, indent=2) + '\n', encoding='utf8')
    print(json.dumps(report, indent=2))


if __name__ == '__main__':
    main()
