#!/usr/bin/env python3
"""Execute playback and profile chrome against the existing ARM64 UIKit model."""
import argparse
import hashlib
import json
from math import isclose
from pathlib import Path

from arm64 import release_version, require
from test_control_glass166 import send
from test_controls171 import call
from test_drama_controls178r8 import Runtime as BaseRuntime, PLAYER, DISABLED_KEY
from test_feed_viewport import labels_for
from test_page_glass174 import EXTRA, make, selector_address

SIZE_KEY = 'FanqieX.DramaActionDiameter.1'
OUTLINE_SIZE_KEY = 'FanqieX.DramaOutlinePointSize.1'
ICONS_KEY = 'FanqieX.MineQuickIconsOnly.1'
OUTLINE_KEY = 'FanqieX.DramaOutlineActions.1'
AUDIO = 'SSAudioPlayIndicatorView'
ROLES = (('SSShortVideoRightInteractionCollectView', 'starIcon'),
         ('SSShortVideoHostRightInteractionCommentView', 'commentIcon'),
         ('SSShortVideoRightInteractionLikeView', 'likeIcon'),
         ('SSShortVideoRightInteractionShareView', 'shareIcon'))


class Runtime(BaseRuntime):
    def __init__(self, data):
        super().__init__(data)
        self._add(self.classes['UIView'], 'layoutSubviews', self.LAYOUT_IMP, 'v16@0:8')
        self._add(self.classes[PLAYER], 'controlViewDidDisplay', self.LAYOUT_IMP, 'v16@0:8')
        self._add(self.classes['UIImageView'], 'setImage:', self.LAYOUT_IMP, 'v24@0:8@16')
        self._class(AUDIO, 'UIView')
        if 'UIImageSymbolConfiguration' not in self.classes:
            self._class('UIImageSymbolConfiguration', 'NSObject')
        if release_version(data) in ('1.8R5', '1.8R6', '1.8R7', '1.8R8', '1.8R9', '1.8R10', '1.8R11', '1.8R12', '1.8R13', '1.8R14'):
            self._class('FQXDockMotion', 'NSObject')
            self._add(self.metaclasses[self.classes['FQXDockMotion']], 'roundedDramaIconNamed:size:',
                      self.LAYOUT_IMP, '@32@0:8@16d24')
        if release_version(data) in ('1.8R6', '1.8R7', '1.8R8', '1.8R9', '1.8R10', '1.8R11', '1.8R12', '1.8R13', '1.8R14'):
            self._class('SSShortVideoRightInteractionCollectModel', 'NSObject')
            self._add(self.classes['SSShortVideoRightInteractionCollectModel'], 'setIsCollected:',
                      self.LAYOUT_IMP, 'v20@0:8B16')
        self._add(self.classes[AUDIO], 'layoutSubviews', self.LAYOUT_IMP, 'v16@0:8')
        self._add(self.classes[AUDIO], 'willMoveToSuperview:', self.LAYOUT_IMP, 'v24@0:8@16')
        for getter in ('contentView', 'backgroundView', 'backgroundEffectView'):
            self._add(self.classes[AUDIO], getter, self.LAYOUT_IMP, '@16@0:8')

    def artwork(self, name, size=(36., 32.), rendering=0):
        pixels = self.obj('NSObject', 'unchanged bitmap', size=tuple(3 * point for point in size))
        return self.obj('UIImage', name, CGImage=pixels, size=size, scale=3., imageOrientation=0,
                        renderingMode=rendering)

    def handle(self, cpu, pc):
        if pc == self.LAYOUT_IMP and self.selector_names.get(cpu.x[1]) == 'setImage:':
            self.objects[cpu.x[0]].state['image'] = cpu.x[2]
            return self.finish(cpu)
        if pc == self.LAYOUT_IMP and self.selector_names.get(cpu.x[1]) == 'setIsCollected:':
            self.objects[cpu.x[0]].state['isCollected'] = bool(cpu.x[2])
            return self.finish(cpu)
        if pc - self.slide == 0xa5d4:
            receiver, selector, argument = cpu.x[:3]
            name = self.selector_names.get(selector)
            if receiver == self.classes['UIImageSymbolConfiguration'] and name == 'configurationWithPointSize:weight:scale:':
                return self.finish(cpu, self.obj('UIImageSymbolConfiguration', 'outline style', size=cpu.fp(0)))
            if receiver == self.classes['UIImage'] and name == 'systemImageNamed:withConfiguration:':
                return self.finish(cpu, self.obj('UIImage', self.string_value(argument)))
            if receiver and receiver == self.classes.get('FQXDockMotion') and name == 'roundedDramaIconNamed:size:':
                return self.finish(cpu, self.obj('UIImage', self.string_value(argument), roundedSize=cpu.fp(0)))
            if receiver == self.classes['UIImageView'] and name == 'new':
                return self.finish(cpu, self.view('UIImageView', 'passive outline', image=0))
            if receiver == self.classes['CALayer'] and name == 'layer':
                return self.finish(cpu, self.obj('CALayer', 'transparent mask'))
            if receiver == self.classes['UIColor'] and name in ('whiteColor', 'systemPinkColor', 'systemYellowColor'):
                return self.finish(cpu, self.color(name))
            if receiver == self.classes['UIImage'] and name == 'imageWithCGImage:scale:orientation:':
                scale = cpu.fp(0)
                size = tuple(pixel / scale for pixel in self.objects[argument].state['size'])
                return self.finish(cpu, self.obj('UIImage', 'point-sized native artwork', CGImage=argument,
                                                 size=size, scale=scale, imageOrientation=cpu.x[3]))
            if receiver in self.objects:
                state = self.objects[receiver].state
                if name == 'respondsToSelector:' and self.selector_names.get(argument) in (
                        'mask', 'isCollected', 'isLiked', 'model'):
                    return self.finish(cpu, int(self.selector_names[argument] in state))
                if name in ('contentView', 'backgroundView', 'backgroundEffectView', 'isCleanMode',
                            'mask', 'isCollected', 'isLiked', 'model') and name in state:
                    return self.finish(cpu, state[name])
                if name == 'setImage:':
                    method = self.get_method(self.objects[receiver].cls, selector)
                    cpu.pc = self.methods[method]['imp']
                    return True
                if name in ('setMask:', 'setContentMode:'):
                    state[name[3].lower() + name[4:-1]] = argument
                    return self.finish(cpu)
                if name == 'insertSubview:aboveSubview:':
                    self.reparent(argument, receiver)
                    state['subviews'].remove(argument)
                    state['subviews'].insert(state['subviews'].index(cpu.x[3]) + 1, argument)
                    return self.finish(cpu)
                if name == 'setNeedsLayout' and 'layout_requests' in state:
                    state['layout_requests'] += 1
                    return self.finish(cpu)
                if name == 'respondsToSelector:' and self.selector_names.get(argument) == 'CGImage':
                    return self.finish(cpu, int('CGImage' in state))
                if name in ('CGImage', 'imageOrientation', 'renderingMode', 'isAnimating') and name in state:
                    return self.finish(cpu, state[name])
                if name in ('scale', 'size') and 'CGImage' in state:
                    value = state[name]
                    return self.finish(cpu, fp=value if name == 'size' else (value,))
                if name == 'imageWithRenderingMode:':
                    state['renderingMode'] = argument
                    return self.finish(cpu, receiver)
        return super().handle(cpu, pc)

def materials(rt, parent):
    return [v for v in rt.objects[parent].state['subviews'] if rt.objects[v].state.get('configuration')]


def fullscreen(data, labels):
    cpu, rt = make(data, Runtime)
    rt.labels = labels
    call(cpu, labels, 'LFQH_FQHPageInstall')
    player = rt.view(PLAYER, 'portrait player', (0., 0., 440., 956.), isCleanMode=False)
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
    scales_ink = release_version(data) in ('1.78R13', '1.78R14', '1.78R15', '1.78R16', '1.78R25', "1.78R26", "1.78R27", "1.78R28", "1.78R29", "1.78R30", "1.78R31", "1.78R32", "1.78R33", "1.78R34", "1.78R35", "1.78R36", "1.79R1", "1.79R2", "1.79R3", "1.79R4", "1.79R5", "1.8R1", "1.8R2", "1.8R3", "1.8R4", "1.8R5", "1.8R6", "1.8R7", "1.8R8", "1.8R9", "1.8R10", "1.8R11", "1.8R12", "1.8R13", "1.8R14")
    rows = []
    for index, (cls, selector) in enumerate(ROLES):
        owner = rt.view(cls, selector, (372., 500. + 76 * index, 60., 66.), rt.ROOT,
                        originalAction=selector)
        original = (8., 2., 44., 44.)
        image = rt.artwork('native action artwork', rendering=index % 3)
        mode = 1 if index == 1 else 4
        glyph = rt.view('UIImageView', 'native glyph', original, owner, contentMode=mode, image=image,
                        userInteractionEnabled=True, originalAction=selector, isAnimating=False)
        count = rt.view('UILabel', 'native count', (0., 48., 60., 18.), owner)
        rt.objects[owner].state[selector] = glyph
        call(cpu, labels, 'LFQH_FQHDramaGlyph', owner, selector_address(data, selector))
        rows.append((owner, glyph, count, original, image, mode))

    def check(diameter):
        for owner, glyph, count, original, image, mode in rows:
            glass, = materials(rt, owner)
            frame = rt.objects[glass].state['frame']
            icon = rt.objects[glyph].state['frame']
            cx, cy = original[0] + original[2] / 2, original[1] + original[3] / 2
            require(frame[2:] == (diameter, diameter) and
                    (frame[0] + diameter / 2, frame[1] + diameter / 2) == (cx, cy),
                    'All four circles share the absolute diameter at the original icon center')
            native = rt.objects[glyph].state
            require(icon == original and native['bounds'] == (0., 0., 44., 44.) and
                    native['userInteractionEnabled'] and not native['subviews'],
                    'Native glyph hit geometry and interaction remain untouched')
            if scales_ink and diameter != 50.:
                ink = rt.objects[native['image']].state
                stock = rt.objects[image].state
                factor = diameter / 50. * (44. / 36. if mode == 1 else 1.)
                require(native['contentMode'] == 4 and ink['CGImage'] == stock['CGImage'] and
                        ink['renderingMode'] == stock['renderingMode'] and
                        all(isclose(after, before * factor) for after, before in zip(ink['size'], stock['size'])),
                        'The visible point size scales proportionally using the original native artwork')
            else:
                require(native['image'] == image and native['contentMode'] == mode,
                        'The default size or legacy release keeps the native image and content mode')
            require(not rt.objects[glass].state['userInteractionEnabled'], 'The resized backing cannot intercept taps')
            require(rt.objects[count].state['frame'] == (0., 48., 60., 18.) and
                    rt.objects[owner].state['bounds'] == (0., 0., 60., 66.),
                    'Numeric captions and native action bounds never resize')

    check(50.)
    outline_tested = release_version(data) in ('1.8R4', '1.8R5', '1.8R6', '1.8R7', '1.8R8', '1.8R9', '1.8R10', '1.8R11', '1.8R12', '1.8R13', '1.8R14')
    stable_image_tested = release_version(data) in ('1.8R5', '1.8R6', '1.8R7', '1.8R8', '1.8R9', '1.8R10', '1.8R11', '1.8R12', '1.8R13', '1.8R14')
    if outline_tested:
        star = rows[0][0]
        heart = rows[2][0]
        rt.objects[star].state['isCollected'] = True
        rt.objects[heart].state['model'] = rt.obj('NSObject', 'selected like model', isLiked=True)
        stock_mask = rt.obj('CALayer', 'native mask')
        first_layer = rt.layer(rows[0][1])
        rt.objects[first_layer].state['mask'] = stock_mask
        prefs[OUTLINE_KEY] = True
        call(cpu, labels, 'LFQH_FQHRefreshDramaActions178R11')
        for index, (owner, glyph, count, frame, image, _) in enumerate(rows):
            outline, = [child for child in rt.objects[owner].state['subviews'] if child not in (glyph, count)]
            visual = rt.objects[outline].state
            require(not materials(rt, owner) and visual['frame'] == frame and
                    not visual['userInteractionEnabled'] and rt.objects[glyph].state['userInteractionEnabled'] and
                    rt.objects[glyph].state['image'] == image and rt.objects[glyph].state['alpha'] == 1.,
                    'Outline art preserves the native target, artwork, count and hit geometry')
            require(rt.objects[visual['image']].name == ('star', 'ellipsis.bubble', 'heart', 'paperplane')[index] and
                    rt.objects[rt.layer(glyph)].state['mask'],
                    'Each original right-column role receives the matching hollow symbol')
        prefs[OUTLINE_KEY] = False
        call(cpu, labels, 'LFQH_FQHRefreshDramaActions178R11')
        require(rt.objects[first_layer].state['mask'] == stock_mask and
                all(not rt.objects[rt.layer(row[1])].state.get('mask') for row in rows[1:]),
                'Switching back restores the original per-icon masks')
        check(50.)
    if stable_image_tested:
        # Cold launch has its preference before the first layout. The stock
        # UIImageViews start in ScaleToFill, then the image loader can deliver
        # a replacement without running the interaction view's layout again.
        prefs[SIZE_KEY] = 40.
        for index in (0, 2):
            cls, role = ROLES[index]
            owner = rt.view(cls, 'cold launch action', (372., 460., 60., 66.), rt.ROOT,
                            isCollected=False, model=0)
            source = rt.artwork('cold launch artwork')
            glyph = rt.view('UIImageView', role, (8., 2., 44., 44.), owner, contentMode=0, image=source)
            rt.objects[owner].state[role] = glyph
            role_address = selector_address(data, role)
            call(cpu, labels, 'LFQH_FQHDramaGlyph', owner, role_address)
            require(all(isclose(x, y * .8) for x, y in zip(
                rt.objects[rt.objects[glyph].state['image']].state['size'], (36., 32.))),
                'The persisted size scales the original asset before the first visible frame')
            late = rt.artwork('late host artwork', (32., 28.), rendering=2)
            send(cpu, rt, glyph, 'setImage:', late)
            resized = rt.objects[rt.objects[glyph].state['image']].state
            require(resized['CGImage'] == rt.objects[late].state['CGImage'] and
                    all(isclose(x, y * .8) for x, y in zip(resized['size'], (32., 28.))),
                    'Host image replacement keeps the current size without waiting for layout')
            prefs[OUTLINE_KEY] = True
            call(cpu, labels, 'LFQH_FQHDramaGlyph', owner, role_address)
            outline = rt.objects[owner].state['subviews'][-1]
            visual = rt.objects[outline].state
            rounded_points = 36. if release_version(data) in ('1.8R6', '1.8R7', '1.8R8', '1.8R9', '1.8R10', '1.8R11', '1.8R12', '1.8R13', '1.8R14') else 24.
            require(visual['contentMode'] == 4 and rt.objects[visual['image']].state['roundedSize'] == rounded_points,
                    'The rounded outline uses its release default at a 40-point glass preference')
            if release_version(data) in ('1.8R6', '1.8R7', '1.8R8', '1.8R9', '1.8R10', '1.8R11', '1.8R12', '1.8R13', '1.8R14') and index == 0:
                model = rt.obj('SSShortVideoRightInteractionCollectModel', 'bound collect model', isCollected=False)
                rt.objects[owner].state['model'] = model
                call(cpu, labels, 'LFQH_FQHDramaGlyph', owner, role_address)
                for collected, tint in ((True, 'systemYellowColor'), (False, 'whiteColor')):
                    send(cpu, rt, model, 'setIsCollected:', collected)
                    require(visual['tintColor'] == rt.color(tint),
                            'The bound model recolors the outline through collect and uncollect without requiring a layout')
                prefs[OUTLINE_SIZE_KEY] = 41.
                call(cpu, labels, 'LFQH_FQHRefreshDramaActions178R11')
                require(rt.objects[visual['image']].state['roundedSize'] == 41. and prefs[SIZE_KEY] == 40.,
                        'Changing outline size leaves the glass-size preference alone')
                prefs.pop(OUTLINE_SIZE_KEY)
            prefs[OUTLINE_KEY] = False
            prefs[SIZE_KEY] = 50.
            call(cpu, labels, 'LFQH_FQHDramaGlyph', owner, role_address)
            require(rt.objects[glyph].state['image'] == late and rt.objects[glyph].state['contentMode'] == 0,
                    'Default size restores the current host artwork and content mode')
            prefs[SIZE_KEY] = 40.
        prefs[SIZE_KEY] = 50.
        call(cpu, labels, 'LFQH_FQHRefreshDramaActions178R11')
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
    owner, glyph, _, _, _, _ = rows[0]
    fresh = (10., 4., 40., 40.)
    rt.objects[glyph].state.update(frame=fresh, bounds=(0., 0., 40., 40.))
    call(cpu, labels, 'LFQH_FQHDramaGlyph', owner, selector_address(data, 'starIcon'))
    like, heart, _, _, heart_source, _ = rows[2]
    selected = rt.artwork('selected heart', rendering=2)
    if scales_ink:
        prefs[SIZE_KEY] = 36.
        rt.objects[heart].state['image'] = selected
        selector = selector_address(data, 'likeIcon')
        call(cpu, labels, 'LFQH_FQHDramaGlyph', like, selector)
        selected_ink = rt.objects[heart].state['image']
        require(selected_ink != selected and
                rt.objects[selected_ink].state['CGImage'] == rt.objects[selected].state['CGImage'],
                'A selected icon supplied by the native host uses its own artwork at the active size')
        call(cpu, labels, 'LFQH_FQHDramaGlyph', like, selector)
        require(rt.objects[heart].state['image'] == selected_ink, 'Stable layout reuses the resized artwork')
        rt.objects[heart].state['isAnimating'] = True
        call(cpu, labels, 'LFQH_FQHDramaGlyph', like, selector)
        require(rt.objects[heart].state['image'] == selected, 'Native animation uses its original asset')
        rt.objects[heart].state['isAnimating'] = False
        call(cpu, labels, 'LFQH_FQHDramaGlyph', like, selector)
        heart_source = selected
    prefs[DISABLED_KEY] = True
    call(cpu, labels, 'LFQH_FQHRefreshDramaActions178R11')
    for index, (owner, glyph, _, original, image, mode) in enumerate(rows):
        require(not materials(rt, owner) and rt.objects[glyph].state['frame'] == (fresh if index == 0 else original) and
                rt.objects[glyph].state['contentMode'] == mode and
                rt.objects[glyph].state['image'] == (heart_source if index == 2 else image),
                'Disabling removes only the material and preserves current host glyph state')
    compact_share_tested = release_version(data) in ('1.8R7', '1.8R8', '1.8R9', '1.8R10', '1.8R11', '1.8R12', '1.8R13', '1.8R14')
    if compact_share_tested:
        prefs[DISABLED_KEY] = False
        prefs[SIZE_KEY] = 40.
        share = rt.view(ROLES[3][0], 'compact share', (320., 540., 64., 66.), rt.WINDOW)
        artwork = rt.artwork('wide native share', (52., 36.))
        glyph = rt.view('UIImageView', 'share', (10., 1., 44., 44.), share, contentMode=1, image=artwork)
        rt.objects[share].state['shareIcon'] = glyph
        selector = selector_address(data, 'shareIcon')
        window = rt.objects[rt.WINDOW].state
        original_bounds = window['bounds']
        window['bounds'] = (0., 0., 402., 874.)
        call(cpu, labels, 'LFQH_FQHDramaGlyph', share, selector)
        require(isclose(max(rt.objects[rt.objects[glyph].state['image']].state['size']), 28.8),
                'The compact share art leaves a fixed proportion of padding within the glass circle')
        replacement = rt.artwork('new wide native share', (56., 34.))
        send(cpu, rt, glyph, 'setImage:', replacement)
        require(isclose(max(rt.objects[rt.objects[glyph].state['image']].state['size']), 28.8),
                'Asynchronous share artwork replacement still fits the same glass circle')
        prefs[OUTLINE_KEY] = True
        call(cpu, labels, 'LFQH_FQHDramaGlyph', share, selector)
        outline = rt.objects[share].state['subviews'][-1]
        require(isclose(rt.objects[rt.objects[outline].state['image']].state['roundedSize'], 30.8),
                'Compact outline share leaves room on all four sides')
        prefs[OUTLINE_KEY] = False
        prefs[SIZE_KEY] = 50.
        window['bounds'] = (0., 0., 440., 956.)
        call(cpu, labels, 'LFQH_FQHDramaGlyph', share, selector)
        require(rt.objects[glyph].state['image'] == replacement and rt.objects[glyph].state['contentMode'] == 1,
                'Max width restores the current host artwork and its original content mode')
        window['bounds'] = original_bounds
    return {'shared_roles': [selector for _, selector in ROLES], 'default_pt': 50,
            'range_pt': [36, 54], 'live_refresh': True, 'native_targets_and_counts_preserved': True,
            'host_relayout_and_disable_restore': True, 'proportional_ink_and_selected_asset': scales_ink,
            'outline_style_roundtrip': outline_tested, 'cold_launch_and_late_artwork': stable_image_tested,
            'compact_share_padding_and_max_restore': compact_share_tested}


def audio_indicator(data, labels, nested_blur):
    cpu, rt = make(data, Runtime)
    rt.labels = labels
    call(cpu, labels, 'LFQH_FQHPageInstall')
    owner = rt.view(AUDIO, 'reader audio float', (16., 720., 138., 50.), rt.WINDOW)
    content = rt.view('UIView', 'clipped audio content', (0., 0., 138., 50.), owner, clipsToBounds=True)
    background = rt.view('UIView', 'cover-colored fill', (0., 0., 138., 50.), content,
                         backgroundColor=rt.color('blue gray'))
    blur = rt.view('UIVisualEffectView', 'stock blur', (0., 0., 138., 50.),
                   background if nested_blur else content)
    cover = rt.view('UIImageView', 'animated book cover', (4., 4., 42., 42.), content)
    play = rt.view('UIButton', 'native play/pause', (56., 4., 38., 42.), content,
                   originalAction='playBtnClick', userInteractionEnabled=True)
    close = rt.view('UIButton', 'native dismiss', (94., 4., 40., 42.), content,
                    originalAction='closeBtnClick', userInteractionEnabled=True)
    rt.objects[owner].state.update(contentView=content, backgroundView=background, backgroundEffectView=blur)

    send(cpu, rt, owner, 'layoutSubviews')
    glass = call(cpu, labels, 'LFQH_FQHSurface', content)['result']
    require(glass != 0, 'The mounted host audio hierarchy must receive a material')
    state = rt.objects[glass].state
    require(rt.objects[state['cornerConfiguration']].name == 'capsule' and
            state['frame'] == (0., 0., 138., 50.) and state['overrideUserInterfaceStyle'] == 2 and
            not state['userInteractionEnabled'] and rt.objects[content].state['clipsToBounds'],
            'The audio capsule uses one dark native material and keeps the owner clipping and hit path')
    native_layers = [glass, background] + ([] if nested_blur else [blur]) + [cover, play, close]
    require(rt.objects[content].state['subviews'] == native_layers and
            rt.objects[background].state['hidden'] and rt.objects[blur].state['hidden'] == (not nested_blur) and
            (not nested_blur or rt.objects[background].state['subviews'] == [blur]) and
            [rt.objects[button].state['originalAction'] for button in (play, close)] ==
            ['playBtnClick', 'closeBtnClick'],
            'The native colored backing and its blur cease drawing while the original controls stay in place')
    repaint = rt.color('new cover color')
    rt.objects[background].state['backgroundColor'] = repaint
    send(cpu, rt, owner, 'layoutSubviews')
    require(call(cpu, labels, 'LFQH_FQHSurface', content)['result'] == glass and
            rt.objects[background].state['hidden'], 'New cover color stays behind a single liquid surface')
    send(cpu, rt, owner, 'willMoveToSuperview:', 0)
    require(not call(cpu, labels, 'LFQH_FQHSurface', content)['result'] and
            all(not rt.objects[paint].state['hidden'] for paint in (background, blur)) and
            rt.objects[background].state['backgroundColor'] == repaint,
            'Detaching restores both paints using the latest native cover color')
    return {'native_capsule': True, 'original_controls_and_cover': True, 'detach_restores_repaint': True,
            'native_blur_is_nested_inside_background': nested_blur}


def mine_shortcuts(data, labels):
    cpu, rt = make(data, Runtime)
    rt.labels = labels
    call(cpu, labels, 'LFQH_FQHPageInstall')
    row = rt.view('SSMyUserShortcutCell', 'Mine shortcuts', (0., 0., 390., 64.), rt.WINDOW)
    cell = rt.view('SSMyUser621FunctionEntryItemCell', 'shortcut target', (8., 0., 60., 47.), row,
                   originalAction='onTap:', userInteractionEnabled=True, layout_requests=0)
    content = rt.view('UIView', 'shortcut content', (0., 0., 60., 47.), cell)
    image = rt.view('UIImageView', 'shortcut graphic', (20., 8., 20., 20.), content)
    label = rt.label('native accessible title', content, (4., 29., 52., 14.), '我的订单')
    color = rt.color('stock shortcut title')
    rt.objects[label].state.update(textColor=color, isAccessibilityElement=True)
    rt.objects[cell].state.update(contentView=content, productImage=image, functionType=label)

    unified_card = release_version(data) in ('1.79R1', '1.79R2', '1.79R3', '1.79R4', '1.79R5', '1.8R1', '1.8R2', '1.8R3', '1.8R4', '1.8R5', '1.8R6', '1.8R7', '1.8R8', '1.8R9', '1.8R10', '1.8R11', '1.8R12', '1.8R13', '1.8R14')

    def layout():
        send(cpu, rt, cell, 'layoutSubviews')
        if unified_card:
            item = call(cpu, labels, 'LFQH_FQHSurface', content)['result']
            if release_version(data) in ('1.79R3', '1.79R4', '1.79R5', '1.8R1', '1.8R2', '1.8R3', '1.8R4', '1.8R5', '1.8R6', '1.8R7', '1.8R8', '1.8R9', '1.8R10', '1.8R11', '1.8R12', '1.8R13', '1.8R14'):
                require(item, '1.79R3+ keeps an inner liquid glass button per shortcut')
            else:
                require(not item, 'Unified card removes per-item glass capsules')
            return call(cpu, labels, 'LFQH_FQHSurface', row)['result']
        return call(cpu, labels, 'LFQH_FQHSurface', content)['result']

    glass = layout()
    capsule = rt.objects[rt.objects[glass].state['cornerConfiguration']]
    with_title = rt.objects[image].state['frame']
    expected_radius = 22 if release_version(data) in ('1.79R5', '1.8R1', '1.8R2', '1.8R3', '1.8R4', '1.8R5', '1.8R6', '1.8R7', '1.8R8', '1.8R9', '1.8R10', '1.8R11', '1.8R12', '1.8R13', '1.8R14') else 18
    shape_ok = capsule.state.get('max_radius') == expected_radius if unified_card else capsule.name == 'capsule'
    require(shape_ok and rt.objects[label].state['textColor'] == color,
            'Default shortcuts use the configured glass card and retain their visible title')
    setting = rt.view('UISwitch', 'show icons only', tag=34, isOn=True)
    callback = rt.sel('fqx178_bottomOptionChanged:')
    prefs = rt.objects[rt.DEFAULTS].state['values']
    call(cpu, labels, 'LFQH_FQHBottomOptionChanged178', rt.ROOT, callback, setting)
    require(prefs[ICONS_KEY] is True and rt.objects[cell].state['layout_requests'] == 1,
            'The real setting persists its independent preference and invalidates visible shortcut layout')
    require(layout() == glass, 'Switching captions off reuses the glass card')
    icon = rt.objects[image].state['frame']
    caption = rt.objects[label].state
    require(icon[0] + icon[2]/2 == 30. and icon[1] + icon[3]/2 == 23.5 and icon[1] > with_title[1] and
            caption['textColor'] == rt.color('clearColor') and not caption['hidden'] and
            caption['isAccessibilityElement'] and rt.string_value(caption['text']) == '我的订单' and
            rt.objects[cell].state['originalAction'] == 'onTap:',
            'Icon-only mode centers the glyph and keeps the original accessible title and native tap')
    rt.objects[setting].state['isOn'] = False
    call(cpu, labels, 'LFQH_FQHBottomOptionChanged178', rt.ROOT, callback, setting)
    require(layout() == glass and caption['textColor'] == color and rt.objects[image].state['frame'] == with_title,
            'Switching captions back on restores their native paint and balanced icon position')
    return {'full_capsule': True, 'real_setting_and_restore': True, 'accessibility_and_taps_preserved': True}


def main():
    parser = argparse.ArgumentParser(description=__doc__)
    parser.add_argument('candidate', type=Path)
    parser.add_argument('--report', type=Path, required=True)
    args = parser.parse_args()
    data = args.candidate.read_bytes()
    entries = EXTRA + ['LFQH_FQHDramaGlyph']
    version = release_version(data)
    if version in ('1.78R11', '1.78R12', '1.78R13', '1.78R14', '1.78R15', '1.78R16', '1.78R25', "1.78R26", "1.78R27", "1.78R28", "1.78R29", "1.78R30", "1.78R31", "1.78R32", "1.78R33", "1.78R34", "1.78R35", "1.78R36", "1.79R1", "1.79R2", "1.79R3", "1.79R4", "1.79R5", "1.8R1", "1.8R2", "1.8R3", "1.8R4", "1.8R5", "1.8R6", "1.8R7", "1.8R8", "1.8R9", "1.8R10", "1.8R11", "1.8R12", "1.8R13", "1.8R14"):
        entries.append('LFQH_FQHRefreshDramaActions178R11')
    if version in ('1.78R13', '1.78R14', '1.78R15', '1.78R16', '1.78R25', "1.78R26", "1.78R27", "1.78R28", "1.78R29", "1.78R30", "1.78R31", "1.78R32", "1.78R33", "1.78R34", "1.78R35", "1.78R36", "1.79R1", "1.79R2", "1.79R3", "1.79R4", "1.79R5", "1.8R1", "1.8R2", "1.8R3", "1.8R4", "1.8R5", "1.8R6", "1.8R7", "1.8R8", "1.8R9", "1.8R10", "1.8R11", "1.8R12", "1.8R13", "1.8R14"):
        entries.append('LFQH_FQHBottomOptionChanged178')
    labels = labels_for(data, args.candidate.with_suffix('.composed.s'), entries)
    report = {'passed': True, 'candidate_sha256': hashlib.sha256(data).hexdigest(),
              'fullscreen': fullscreen(data, labels), 'right_column': right_column(data, labels),
              'device_tested': False, 'pixel_rendering_tested': False}
    if version in ('1.78R13', '1.78R14', '1.78R15', '1.78R16', '1.78R25', "1.78R26", "1.78R27", "1.78R28", "1.78R29", "1.78R30", "1.78R31", "1.78R32", "1.78R33", "1.78R34", "1.78R35", "1.78R36", "1.79R1", "1.79R2", "1.79R3", "1.79R4", "1.79R5", "1.8R1", "1.8R2", "1.8R3", "1.8R4", "1.8R5", "1.8R6", "1.8R7", "1.8R8", "1.8R9", "1.8R10", "1.8R11", "1.8R12", "1.8R13", "1.8R14"):
        report.update(audio_indicator=audio_indicator(data, labels, nested_blur=version in ('1.78R14', '1.78R15', '1.78R16', '1.78R25', "1.78R26", "1.78R27", "1.78R28", "1.78R29", "1.78R30", "1.78R31", "1.78R32", "1.78R33", "1.78R34", "1.78R35", "1.78R36", "1.79R1", "1.79R2", "1.79R3", "1.79R4", "1.79R5", "1.8R1", "1.8R2", "1.8R3", "1.8R4", "1.8R5", "1.8R6", "1.8R7", "1.8R8", "1.8R9", "1.8R10", "1.8R11", "1.8R12", "1.8R13", "1.8R14")),
                      mine_shortcuts=mine_shortcuts(data, labels))
    args.report.write_text(json.dumps(report, ensure_ascii=False, indent=2) + '\n', encoding='utf8')
    print(json.dumps(report, indent=2))


if __name__ == '__main__':
    main()
