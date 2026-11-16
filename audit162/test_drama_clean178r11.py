#!/usr/bin/env python3
"""Run the portrait clean/pause hooks against host playback and UI boundaries."""
import argparse
import hashlib
import json
from pathlib import Path

from arm64 import require
from test_control_glass166 import send
from test_controls171 import call
from test_drama_visibility178r7 import CONFIG, CONTEXT, Runtime as Base
from test_feed_viewport import labels_for
from test_page_glass174 import EXTRA, make

VIEW = 'FQVShortVideoVPlayerControlView'
CONTROL = 'FQVShortVideoListVCControlComponent'
STATE = 'playerPlaybackStateDidChanged:'
CLEAN = 'FanqieX.DramaDefaultClean.1'
REVEAL = 'FanqieX.DramaRevealOnPause.1'


class Runtime(Base):
    HOST_PLAY = 0x33272000
    HOST_CLEAN = 0x33272004

    def __init__(self, data):
        super().__init__(data)
        if VIEW not in self.classes:
            self._class(VIEW, 'UIView')
        if CONTROL not in self.classes:
            self._class(CONTROL, 'NSObject')
        for cls, selector, imp, encoding in (
            (VIEW, STATE, self.HOST_PLAY, 'v24@0:8q16'),
            (VIEW, 'controlViewDidPlay', self.HOST_PLAY, 'v16@0:8'),
            (CONTROL, 'enterCleanMode', self.HOST_CLEAN, 'v16@0:8'),
            (CONTROL, 'exitCleanMode', self.HOST_CLEAN, 'v16@0:8'),
        ):
            self._add(self.classes[cls], selector, imp, encoding)
        self.clean_calls = []

    def handle(self, cpu, pc):
        obj, sel = cpu.x[:2]
        name = self.selector_names.get(sel)
        if pc == self.HOST_PLAY:
            self.objects[obj].state['hostPlaybackCallbacks'] += 1
            return self.finish(cpu)
        if pc == self.HOST_CLEAN:
            self.clean_calls.append(name)
            self.objects[self.objects[obj].state['status']].state['isCleanMode'] = name == 'enterCleanMode'
            return self.finish(cpu)
        if pc - self.slide == 0xa5d4 and obj in self.objects:
            state = self.objects[obj].state
            if name in ('currentPlayModel', 'videoDataModel', 'listVCContext', 'controlContext',
                        'stateContext', 'vPlayer', 'isFullScreen', 'isCleanMode') and name in state:
                return self.finish(cpu, state[name])
        return super().handle(cpu, pc)


def exercise(data, labels):
    cpu, rt = make(data, Runtime)
    rt.labels = labels
    call(cpu, labels, 'LFQH_FQHPageInstall')
    prefs = rt.objects[rt.DEFAULTS].state['values']
    screen = rt.view('UIWindow', 'visible window')
    model = rt.obj('NSObject', 'episode one')
    second = rt.obj('NSObject', 'episode two')
    config = rt.obj(CONFIG, 'main feed config', feedType=4)
    status = rt.obj('NSObject', 'status', isCleanMode=False)
    controller = rt.obj(CONTROL, 'native feed controller', status=status)
    context = rt.obj(CONTEXT, 'active context', config=config, currentPlayModel=model,
                     controlContext=controller, stateContext=status)
    player = rt.obj('NSObject', 'portrait player', isFullScreen=False)
    view = rt.view(VIEW, 'main portrait player view', (0., 0., 440., 900.), screen,
                   window=screen, listVCContext=context, vPlayer=player,
                   videoDataModel=model, hostPlaybackCallbacks=0)
    view_state = rt.objects[view].state

    def callback(state):
        send(cpu, rt, view, STATE, state)

    callback(1)
    require(not rt.clean_calls, 'Default switches leave stock playback alone')
    for tag, key in ((30, CLEAN), (31, REVEAL), (32, 'FanqieX.DramaHighestQuality.1')):
        switch = rt.view('UISwitch', 'plugin switch', tag=tag, isOn=True)
        call(cpu, labels, 'LFQH_FQHBottomOptionChanged178', 0, rt.sel('fqx178_bottomOptionChanged:'), switch)
        require(prefs.get(key) is True, 'The real settings callback persists each playback switch')
    callback(1)
    callback(1)
    require(rt.clean_calls == ['enterCleanMode'], 'The active episode enters once')
    callback(3)
    callback(2)
    callback(2)
    callback(1)
    require(rt.clean_calls == ['enterCleanMode', 'exitCleanMode', 'enterCleanMode'],
            'Only a real pause reveals the page, and playback restores it once')
    rt.objects[status].state['isCleanMode'] = False
    callback(1)
    require(len(rt.clean_calls) == 3, 'Manual exit on the same playing video is preserved')
    view_state['videoDataModel'] = second
    callback(1)
    require(len(rt.clean_calls) == 3, 'Offscreen or preloaded cell is ineligible')
    rt.objects[context].state['currentPlayModel'] = second
    rt.objects[player].state['isFullScreen'] = True
    callback(1)
    rt.objects[player].state['isFullScreen'] = False
    rt.objects[config].state['feedType'] = 5
    callback(1)
    require(len(rt.clean_calls) == 3, 'Fullscreen and other feeds retain stock')
    rt.objects[config].state['feedType'] = 4
    callback(1)
    require(rt.clean_calls[-1] == 'enterCleanMode' and len(rt.clean_calls) == 4,
            'Next active episode takes the default')
    prefs[REVEAL] = False
    callback(2)
    require(len(rt.clean_calls) == 4 and view_state['hostPlaybackCallbacks'] == 13,
            'Pause switch off leaves the clean state and all original callbacks intact')
    return {'real_play_pause_callbacks': True, 'defaults_and_manual_exit': True, 'scoped_to_active_portrait_feed': True}


def main():
    parser = argparse.ArgumentParser(description=__doc__)
    parser.add_argument('candidate', type=Path)
    parser.add_argument('--report', type=Path, required=True)
    args = parser.parse_args()
    data = args.candidate.read_bytes()
    labels = labels_for(data, args.candidate.with_suffix('.composed.s'),
                        EXTRA + ['LFQH_FQHBottomOptionChanged178'])
    report = {'passed': True, 'candidate_sha256': hashlib.sha256(data).hexdigest(),
              **exercise(data, labels), 'device_tested': False}
    args.report.write_text(json.dumps(report, indent=2)+'\n', encoding='utf8')
    print(json.dumps(report, indent=2))


if __name__ == '__main__':
    main()
