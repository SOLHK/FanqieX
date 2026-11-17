#!/usr/bin/env python3
"""Execute reader back centering, then model UIButton's later image-inset layout."""
import argparse
import copy
import hashlib
import json
from pathlib import Path

from arm64 import require, release_version
from test_alignment167 import icon, machine, call, material, EXTRA
from test_feed_viewport import labels_for
from test_home_glass165 import LABELS


def exercise(data, labels, optical=None):
    if optical is None:
        optical = release_version(data) in ('1.78R12', '1.78R13', '1.78R14', '1.78R15', '1.78R16', '1.78R25', "1.78R26", "1.78R27", "1.78R28", "1.78R29", "1.78R30", "1.78R31")
    cpu, rt = machine(data, labels)
    rt.labels = labels
    call(cpu, labels, 'LFQH_FQHInstall')
    nav = rt.view('FQReaderSaasNavigationView', 'reader navigation', (0., 62., 440., 44.), rt.ROOT)
    back = icon(rt, nav, 'back', (16., 10., 24., 24.), image_size=(24.,24.))
    other = icon(rt, nav, 'ordinary', (370., 10., 24., 24.))
    rt.objects[nav].state.update(backBtn=back, insertObjs=rt.obj('NSArray', 'empty inserts', items=[]))
    button = rt.objects[back].state
    glyph = rt.objects[button['imageView']].state
    original = copy.deepcopy(button)
    original_glyph = glyph['frame']

    def centered():
        glass = rt.objects[material(cpu, rt, labels, back)].state['frame']
        image = glyph['frame']
        if optical:
            # Exact host SSBizReader.bundle reading_navigation_button_back_opt
            # alpha bounds (exclusive right/bottom), extracted independently
            # from the supplied 7.4.3 Assets.car. A centered transparent canvas
            # previously left the visible chevron 4.875pt left of the glass.
            for pixels, box in ((48., (1.,6.,21.,41.)), (72., (2.,9.,31.,61.))):
                x = image[0]+(box[0]+box[2])*.5/pixels*image[2]
                y = image[1]+(box[1]+box[3])*.5/pixels*image[3]
                require(abs(x-glass[0]-glass[2]*.5) < 0.001 and
                        abs(y-glass[1]-glass[3]*.5) <= 1./3.,
                        'The actual back-arrow alpha bounds are visually centered in glass')
        else:
            require(image[0]+image[2]*.5 == glass[0]+glass[2]*.5 and
                    image[1]+image[3]*.5 == glass[1]+glass[3]*.5,
                    'Historical R10/R11 centered only the transparent image canvas')

    def native_button_layout():
        # Apple's plain UIButton imageEdgeInsets controls the effective drawing
        # rectangle during its own layout; the host has no configuration.
        top, left, bottom, right = button['imageEdgeInsets']
        x, y, width, height = original_glyph
        glyph['frame'] = (x+left, y+top, width-left-right, height-top-bottom)

    call(cpu, labels, 'LFQH_FQHReader', nav)
    centered()
    expected = (3.,13.875,3.,-7.875) if optical else (3.,9.,3.,-3.)
    require(button['imageEdgeInsets'] == expected, 'Persistent inset geometry matches the visible glass')
    native_button_layout()
    centered()
    for _ in range(10):
        call(cpu, labels, 'LFQH_FQHReader', nav)
        native_button_layout()
        centered()
    require(button['frame'] == original['frame'] and all(row in button['control_targets'] for row in original['control_targets']) and
            button['images'] == original['images'], 'Original back action, image asset and tap host remain intact')
    require(rt.objects[other].state['imageEdgeInsets'] == (0.,0.,0.,0.), 'Unrelated UIButton is unchanged')
    rt.objects[rt.DEFAULTS].state['values']['FanqieAdBlock.GlassDisabled.1'] = True
    call(cpu, labels, 'LFQH_FQHReader', nav)
    require(button['imageEdgeInsets'] == original['imageEdgeInsets'] and glyph['frame'] == original_glyph,
            'Disabling restores native insets and image geometry')
    rt.objects[rt.DEFAULTS].state['values']['FanqieAdBlock.GlassDisabled.1'] = False
    call(cpu, labels, 'LFQH_FQHReader', nav)
    button['imageEdgeInsets'] = (1.,2.,3.,4.)
    glyph['frame'] = (2.,1.,18.,20.)
    rt.objects[rt.DEFAULTS].state['values']['FanqieAdBlock.GlassDisabled.1'] = True
    call(cpu, labels, 'LFQH_FQHReader', nav)
    require(button['imageEdgeInsets'] == (1.,2.,3.,4.) and glyph['frame'] == (2.,1.,18.,20.),
            'Restoration preserves a newer host-owned image layout')
    return {'centered_before_and_after_native_layout': True, 'visible_artwork_centered': optical, 'stable_layouts': 10,
            'native_action_preserved': True, 'restore_and_host_ownership': True}


if __name__ == '__main__':
    parser = argparse.ArgumentParser(description=__doc__)
    parser.add_argument('candidate', type=Path)
    parser.add_argument('--report', type=Path, required=True)
    args = parser.parse_args()
    data = args.candidate.read_bytes()
    labels = labels_for(data, args.candidate.with_suffix('.composed.s'), list(dict.fromkeys(LABELS+EXTRA)))
    report = {'passed': True, 'candidate_sha256': hashlib.sha256(data).hexdigest(),
              **exercise(data, labels), 'device_tested': False}
    args.report.write_text(json.dumps(report, indent=2)+'\n', encoding='utf8')
    print(json.dumps(report, indent=2))
