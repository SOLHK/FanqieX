#!/usr/bin/env python3
"""Run the portrait clean/pause hooks against host playback and UI boundaries."""
import argparse
import hashlib
import json
from pathlib import Path

from arm64 import release_version, require
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
PURE = 'FanqieX.DramaPureClean.1'
MODE = 'enterCleanMode:changeType:'
ENDED = 'controlViewDidEndDisplay'
EXIT_ICON = 'cancelCleanScreenView'
RIGHT_CONTROLS = 'cleanScreenModeRightInteractionView'


class Runtime(Base):
    HOST_PLAY = 0x33272000
    HOST_CLEAN = 0x33272004
    HOST_CLEAN_VIEW = 0x33272008
    HOST_CLEAN_MODE = 0x3327200c
    HOST_END_DISPLAY = 0x33272010

    def __init__(self, data):
        super().__init__(data)
        if VIEW not in self.classes:
            self._class(VIEW, 'UIView')
        if CONTROL not in self.classes:
            self._class(CONTROL, 'NSObject')
        for cls, selector, imp, encoding in (
            (VIEW, STATE, self.HOST_PLAY, 'v24@0:8q16'),
            (VIEW, 'controlViewDidPlay', self.HOST_PLAY, 'v16@0:8'),
            (VIEW, EXIT_ICON, self.HOST_CLEAN_VIEW, '@16@0:8'),
            (VIEW, RIGHT_CONTROLS, self.HOST_CLEAN_VIEW, '@16@0:8'),
            (VIEW, 'listVCConfig', self.HOST_CLEAN_VIEW, '@16@0:8'),
            (VIEW, 'enableShowPlayRateInCleanMode', self.HOST_CLEAN_VIEW, 'B16@0:8'),
            (VIEW, 'isCleanMode', self.HOST_CLEAN_VIEW, 'B16@0:8'),
            (VIEW, MODE, self.HOST_CLEAN_MODE, 'B28@0:8B16Q20'),
            (VIEW, ENDED, self.HOST_END_DISPLAY, 'v16@0:8'),
            ('FQVPlayer', 'playbackState', self.HOST_CLEAN_VIEW, 'q16@0:8'),
            (CONTROL, 'enterCleanMode', self.HOST_CLEAN, 'v16@0:8'),
            (CONTROL, 'exitCleanMode', self.HOST_CLEAN, 'v16@0:8'),
        ):
            self._add(self.classes[cls], selector, imp, encoding)
        self.clean_calls = []

    def responds(self, receiver, name):
        if name == 'anyObject' and self.is_kind(receiver, self.classes['NSHashTable']):
            return True
        return super().responds(receiver, name)

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
        if pc == self.HOST_CLEAN_VIEW:
            return self.finish(cpu, self.objects[obj].state[name])
        if pc == self.HOST_CLEAN_MODE:
            self.objects[obj].state['isCleanMode'] = bool(cpu.x[2])
            return self.finish(cpu, 1)
        if pc == self.HOST_END_DISPLAY:
            self.objects[obj].state['endedDisplay'] = True
            return self.finish(cpu)
        if pc - self.slide == 0xa5d4 and obj in self.objects:
            state = self.objects[obj].state
            if name in ('currentPlayModel', 'videoDataModel', 'listVCContext', 'controlContext',
                        'stateContext', 'vPlayer', 'isFullScreen', 'isCleanMode', 'progressContainer',
                        'insertAboveProgressView', 'baseInfoView', 'nextResponder', 'rootTabBarController',
                        'customTabBar', 'selectedViewController', 'viewIfLoaded', 'navBarComponent', 'navBar') and name in state:
                return self.finish(cpu, state[name])
            if name == 'containsObject:' and self.is_kind(obj, self.classes['NSHashTable']):
                return self.finish(cpu, cpu.x[2] in state.get('items', []))
        return super().handle(cpu, pc)


def exercise(data, labels):
    cpu, rt = make(data, Runtime)
    rt.labels = labels
    call(cpu, labels, 'LFQH_FQHPageInstall')
    prefs = rt.objects[rt.DEFAULTS].state['values']
    screen = rt.view('UIWindow', 'visible window', (0., 0., 440., 956.))
    model = rt.obj('NSObject', 'episode one')
    second = rt.obj('NSObject', 'episode two')
    config = rt.obj(CONFIG, 'main feed config', feedType=4)
    status = rt.obj('NSObject', 'status', isCleanMode=False)
    controller = rt.obj(CONTROL, 'native feed controller', status=status)
    context = rt.obj(CONTEXT, 'active context', config=config, currentPlayModel=model,
                     controlContext=controller, stateContext=status)
    player = rt.obj('FQVPlayer', 'portrait player', isFullScreen=False, playbackState=1)
    view = rt.view(VIEW, 'main portrait player view', (0., 0., 440., 900.), screen,
                   window=screen, listVCContext=context, vPlayer=player,
                   videoDataModel=model, hostPlaybackCallbacks=0, isCleanMode=False)
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
    results = {'real_play_pause_callbacks': True, 'defaults_and_manual_exit': True, 'scoped_to_active_portrait_feed': True}
    if release_version(data) in ('1.78R12', '1.78R13', '1.78R14', '1.78R15', '1.78R16', '1.78R25', "1.78R26", "1.78R27", "1.78R28", "1.78R29", "1.78R30", "1.78R31", "1.78R32", "1.78R33", "1.78R34", "1.78R35", "1.78R36", "1.79R1", "1.79R2", "1.79R3", "1.79R4", "1.79R5", "1.8R1", "1.8R2", "1.8R3", "1.8R4", "1.8R5", "1.8R6", "1.8R7", "1.8R8", "1.8R9", "1.8R10", "1.8R11", "1.8R12", "1.8R13", "1.8R14", "1.8R15", "1.8R16", "1.8R17", "1.8R18", "1.8R19", "1.8R19", "1.9.1beta1", "1.9.1beta2", "1.9.1beta3", "1.9.1beta4", "1.9.1beta5", "1.9.1beta6", "1.9.1beta7", "1.9.1beta8", "1.9.1beta9", "1.9.1beta10", "1.9.1beta11", "1.9.1beta12", "1.9.1beta13", "1.9.1beta14", "1.9.1beta15", "1.9.1beta16", "1.9.1beta17", "1.9.1beta18", "1.9.1beta19", "1.9.1beta20", "1.9.1beta21", "1.9.1beta22", "1.9.1beta23", "1.9.1beta24", "1.9.1beta25", "1.9.1beta26", "1.9.5beta1"):
        container = rt.view('UIView', 'native exit circle', (370., 765., 36., 36.), view, hidden=False)
        icon = rt.view('UIImageView', 'native exit gesture target', (6., 6., 24., 24.), container, hidden=False)
        view_state.update({EXIT_ICON: icon, RIGHT_CONTROLS: container, 'listVCConfig': config,
                           'enableShowPlayRateInCleanMode': False})
        for selector, native in ((EXIT_ICON, icon), (RIGHT_CONTROLS, container)):
            require(send(cpu, rt, view, selector)['result'] == native and rt.objects[native].state['hidden'],
                    'The exact host exit view is still laid out but cannot draw or receive taps')
        view_state['enableShowPlayRateInCleanMode'] = True
        send(cpu, rt, view, RIGHT_CONTROLS)
        require(not rt.objects[container].state['hidden'] and rt.objects[icon].state['hidden'],
                'A separately enabled play-rate control keeps its container')
        rt.objects[config].state['feedType'] = 5
        send(cpu, rt, view, EXIT_ICON)
        require(not rt.objects[icon].state['hidden'], 'An unrelated feed keeps its native exit')
        results['portrait_clean_exit_hidden'] = True
    if release_version(data) in ('1.78R13', '1.78R14', '1.78R15', '1.78R16', '1.78R25', "1.78R26", "1.78R27", "1.78R28", "1.78R29", "1.78R30", "1.78R31", "1.78R32", "1.78R33", "1.78R34", "1.78R35", "1.78R36", "1.79R1", "1.79R2", "1.79R3", "1.79R4", "1.79R5", "1.8R1", "1.8R2", "1.8R3", "1.8R4", "1.8R5", "1.8R6", "1.8R7", "1.8R8", "1.8R9", "1.8R10", "1.8R11", "1.8R12", "1.8R13", "1.8R14", "1.8R15", "1.8R16", "1.8R17", "1.8R18", "1.8R19", "1.8R19", "1.9.1beta1", "1.9.1beta2", "1.9.1beta3", "1.9.1beta4", "1.9.1beta5", "1.9.1beta6", "1.9.1beta7", "1.9.1beta8", "1.9.1beta9", "1.9.1beta10", "1.9.1beta11", "1.9.1beta12", "1.9.1beta13", "1.9.1beta14", "1.9.1beta15", "1.9.1beta16", "1.9.1beta17", "1.9.1beta18", "1.9.1beta19", "1.9.1beta20", "1.9.1beta21", "1.9.1beta22", "1.9.1beta23", "1.9.1beta24", "1.9.1beta25", "1.9.1beta26", "1.9.5beta1"):
        rt.objects[config].state['feedType'] = 4
        view_state.update(userInteractionEnabled=True)
        rail = rt.view('UIView', 'native seek rail', (0., 835., 440., 26.), view, window=screen)
        entry = rt.view('UIView', 'native episode link', (0., 790., 440., 36.), view, window=screen)
        buttons = rt.view('UIView', 'native interaction buttons', (380., 500., 60., 200.), view, window=screen)
        header = rt.view('UIView', 'native feed header', (0., 60., 440., 54.), screen, window=screen)
        dock = rt.view('SSTabBar', 'native short-drama dock', (0., 880., 440., 76.), screen, window=screen)
        mini = rt.view('UIView', 'compact dock button', (376., 10., 54., 54.), dock, window=screen)
        selected = rt.obj('UIViewController', 'selected short-drama page', viewIfLoaded=screen)
        tab = rt.obj('SSTabBarController', 'exact short-drama tab owner', customTabBar=dock, selectedViewController=selected)
        owner = rt.obj('SSVideoSeriesFeedViewController', 'exact feed controller', headerView=header, rootTabBarController=tab)
        view_state.update(progressContainer=rail, insertAboveProgressView=entry, baseInfoView=buttons, nextResponder=owner)
        chrome = (rail, entry, buttons, header, dock)
        require(send(cpu, rt, view, MODE, 1, 1)['result'] == 1 and
                all(not rt.objects[child].state['hidden'] for child in chrome),
                'The independent pure-clean switch defaults off and the native callback result is preserved')
        switch = rt.view('UISwitch', 'pure-clean switch', tag=33, isOn=True)
        call(cpu, labels, 'LFQH_FQHBottomOptionChanged178', 0, rt.sel('fqx178_bottomOptionChanged:'), switch)
        require(prefs.get(PURE) is True and all(rt.objects[child].state['hidden'] for child in chrome) and
                rt.objects[mini].state['superview'] == dock and view_state['userInteractionEnabled'] and not view_state['hidden'],
                'Enabling pure clean during native clean hides the exact chrome while preserving its hierarchy and canvas input')
        if release_version(data) in ('1.78R14', '1.78R15', '1.78R16', '1.78R25', "1.78R26", "1.78R27", "1.78R28", "1.78R29", "1.78R30", "1.78R31", "1.78R32", "1.78R33", "1.78R34", "1.78R35", "1.78R36", "1.79R1", "1.79R2", "1.79R3", "1.79R4", "1.79R5", "1.8R1", "1.8R2", "1.8R3", "1.8R4", "1.8R5", "1.8R6", "1.8R7", "1.8R8", "1.8R9", "1.8R10", "1.8R11", "1.8R12", "1.8R13", "1.8R14", "1.8R15", "1.8R16", "1.8R17", "1.8R18", "1.8R19", "1.8R19", "1.9.1beta1", "1.9.1beta2", "1.9.1beta3", "1.9.1beta4", "1.9.1beta5", "1.9.1beta6", "1.9.1beta7", "1.9.1beta8", "1.9.1beta9", "1.9.1beta10", "1.9.1beta11", "1.9.1beta12", "1.9.1beta13", "1.9.1beta14", "1.9.1beta15", "1.9.1beta16", "1.9.1beta17", "1.9.1beta18", "1.9.1beta19", "1.9.1beta20", "1.9.1beta21", "1.9.1beta22", "1.9.1beta23", "1.9.1beta24", "1.9.1beta25", "1.9.1beta26", "1.9.5beta1"):
            prefs[REVEAL] = True
            rt.objects[status].state['isCleanMode'] = False
            rt.objects[player].state['playbackState'] = 2
            pause_actions = len(rt.clean_calls)
            callback(2)
            require(rt.clean_calls[pause_actions:] == ['exitCleanMode'] and view_state['isCleanMode'] and
                    all(not rt.objects[child].state['hidden'] for child in chrome),
                    'Actual pause reveals dock and rail before the asynchronous local clean callback settles')
            send(cpu, rt, view, MODE, 1, 1)
            require(all(not rt.objects[child].state['hidden'] for child in chrome),
                    'A host clean callback while paused cannot hide the revealed controls again')
            rt.objects[player].state['playbackState'] = 1
            callback(1)
            require(all(rt.objects[child].state['hidden'] for child in chrome),
                    'Resuming with clean still active restores the pure presentation')
            prefs[REVEAL] = False
            rt.objects[player].state['playbackState'] = 2
            callback(2)
            require(all(rt.objects[child].state['hidden'] for child in chrome),
                    'Paused controls remain hidden when reveal on pause is disabled')
            results['pure_clean_pause_restore'] = True
        send(cpu, rt, view, MODE, 0, 1)
        require(all(not rt.objects[child].state['hidden'] for child in chrome), 'The native exit restores owned controls')
        rt.objects[buttons].state['hidden'] = True
        send(cpu, rt, view, MODE, 1, 1)
        send(cpu, rt, view, ENDED)
        require(view_state['endedDisplay'] and rt.objects[buttons].state['hidden'] and
                all(not rt.objects[child].state['hidden'] for child in chrome if child != buttons),
                'Recycling keeps the native hidden baseline and clears the plugin ownership')
        results['pure_clean_visual_ownership_and_native_exit'] = True
    return results


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
