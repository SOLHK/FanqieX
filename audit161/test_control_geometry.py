#!/usr/bin/env python3
"""Execute scoped-control regressions from the delivered candidate ARM64 bytes.

Only imported Objective-C/UIKit boundaries are simulated. The patched entry
instructions, new geometry logic, fallback trampolines, and original material
factory all execute in arm64.CPU with clobbered caller-saved registers and ABI
checks. This is not a device screenshot or UIKit rendering test.
"""
from pathlib import Path
import argparse
import hashlib
import json
import math
import struct
import traceback

from arm64 import CPU, require, sx
from geometry_runtime import GeometryRuntime


RUNS = []
SURFACE_KEY = 0xeb8b


def entry_target(data, site):
    op = struct.unpack_from('<I', data, site)[0]
    require(op & 0xfc000000 == 0x14000000, 'Entry is an actual B instruction')
    return site + (sx(op & 0x3ffffff, 26) << 2)


def make(data, entries, slide=0):
    rt = GeometryRuntime(data, slide=slide)
    ranges = [(0x800, 0x4000), (0x702c, 0x75d4), (0x7804, 0x78b8),
              (0x7ac4, 0x7d00)]
    if entries:
        ranges.append((0x14000, entries['code_end']))
    cpu = CPU(data, rt, slide=slide, ranges=ranges)
    cpu.pointers.update(rt.rebase_pointers)
    RUNS.append((cpu, rt))
    return cpu, rt


def near(actual, expected, why, tolerance=1e-8):
    require(len(actual) == len(expected), why + ': dimensions')
    require(all(a == b or (math.isnan(a) and math.isnan(b)) or abs(a-b) <= tolerance
                for a, b in zip(actual, expected)),
            why + ': got ' + repr(actual) + ', expected ' + repr(expected))


def frozen(rt, pointers):
    return {p: (rt.objects[p].state['frame'], rt.objects[p].state['bounds'],
                rt.objects[p].state.get('hidden', False),
                rt.objects[p].state.get('target'), rt.objects[p].state.get('action'),
                rt.objects[p].state.get('font'), rt.objects[p].state.get('text'))
            for p in pointers}


def unchanged(rt, before):
    for p, state in before.items():
        current = frozen(rt, [p])[p]
        near(current[0], state[0], 'Host frame unchanged')
        near(current[1], state[1], 'Host bounds unchanged')
        require(current[2:] == state[2:], 'Host visibility/action/font/text unchanged')


def material(rt, control):
    return rt.associations.get((control, rt.slide + SURFACE_KEY), 0)


def frame(rt, view):
    require(view in rt.objects, 'Material exists')
    return rt.objects[view].state['frame']


def capsule_after_frame(rt, view):
    frames = [i for i, e in enumerate(rt.events)
              if e['event'] == 'setFrame' and e.get('self') == view]
    corners = [(i, e) for i, e in enumerate(rt.events)
               if e['event'] == 'cornerConfiguration' and e.get('self') == view]
    require(frames and corners and corners[-1][0] > frames[-1],
            'Native capsule reset follows the final setFrame')
    require(corners[-1][1]['bounds'][2] > 0 and corners[-1][1]['bounds'][3] > 0,
            'Native capsule is configured with positive dimensions')
    require(rt.objects[view].state['userInteractionEnabled'] == 0,
            'Decorative material cannot steal touch routing')
    require(rt.objects[view].state['accessibilityElementsHidden'] == 1,
            'Decorative material is absent from accessibility elements')


def reader(rt, control_frame=(16, 0, 44, 44), image_frame=(10, 10, 24, 24),
           image_size=(24, 24), mode=1, scope='FQReaderSaasNavigationView', **state):
    owner = rt.view(scope, 'reader_navigation', (0, 64, 440, 44), rt.ROOT)
    control = rt.view('UIButton', 'reader_control', control_frame, owner, **state)
    rt.objects[control].state.update(target=0x1234, action=0x5678)
    icon = rt.image_view('reader_icon', control, image_frame,
                         size=image_size, content_mode=mode)
    return owner, control, icon


def shelf(rt, control_frame=(388, 6, 32, 32), label_frame=(0, 6, 32, 20),
          intrinsic=(28, 20), line_height=20, alignment=1, **state):
    owner = rt.view('SSBookShelfHeaderView', 'shelf_header', (0, 106, 440, 44), rt.ROOT)
    control = rt.view('UIButton', 'edit_control', control_frame, owner, **state)
    rt.objects[control].state.update(target=0x2345, action=0x6789)
    label = rt.label('edit_label', control, label_frame, '编辑', intrinsic=intrinsic,
                     line_height=line_height, alignment=alignment)
    return owner, control, label


def symmetric_icon(data, entries, slide=0):
    cpu, rt = make(data, entries, slide)
    owner, control, icon = reader(rt)
    before = frozen(rt, [owner, control, icon])
    cpu.run(0x7848, control)
    glass = material(rt, control)
    near(frame(rt, glass), (4, 4, 36, 36), '36pt icon circle with equal inset')
    capsule_after_frame(rt, glass)
    unchanged(rt, before)
    cpu.run(0x7848, control)
    require(material(rt, control) == glass, 'Repeated layout reuses one material')
    near(frame(rt, glass), (4, 4, 36, 36), 'Repeated layout is geometrically stable')
    require(sum(rt.is_kind(p, rt.classes['UIVisualEffectView'])
                for p in rt.objects[control].state['subviews']) == 1,
            'Control contains a single glass material')
    return {'frame': frame(rt, glass), 'slide': hex(slide), 'instructions': cpu.steps}


def asymmetric_left_image(data, entries):
    cpu, rt = make(data, entries)
    owner, control, icon = reader(rt, control_frame=(16, 0, 24, 44),
                                  image_frame=(0, 10, 24, 24),
                                  image_size=(10, 20), mode=7)
    before = frozen(rt, [owner, control, icon])
    cpu.run(0x7848, control)
    glass = material(rt, control)
    near(frame(rt, glass), (-13, 4, 36, 36), 'Circle follows actual left-aligned image center')
    near((frame(rt, glass)[0] + 18, frame(rt, glass)[1] + 18),
         (5, 22), 'Image drawing center and glass center coincide')
    unchanged(rt, before)
    return {'frame': frame(rt, glass), 'host_image_frame_preserved': True,
            'instructions': cpu.steps}


def edit_pill(data, entries):
    cpu, rt = make(data, entries)
    owner, control, label = shelf(rt)
    before = frozen(rt, [owner, control, label])
    cpu.run(0x7848, control)
    glass = material(rt, control)
    near(frame(rt, glass), (-8, 0, 48, 32), 'Two characters receive a pill, not a circle')
    require(frame(rt, glass)[2] / frame(rt, glass)[3] >= 1.5, 'Pill aspect is at least 1.5')
    capsule_after_frame(rt, glass)
    unchanged(rt, before)
    return {'frame': frame(rt, glass), 'horizontal_text_padding': 10,
            'vertical_text_padding': 6, 'instructions': cpu.steps}


def filter_pill(data, entries):
    cpu, rt = make(data, entries)
    owner = rt.view('SSBookShelfFilterHeaderView', 'filter_header', (0, 150, 440, 44), rt.ROOT)
    control = rt.view('UIButton', 'filter_control', (364, 6, 66, 32), owner)
    icon = rt.image_view('filter_icon', control, (8, 8, 16, 16), size=(16, 16))
    label = rt.label('filter_label', control, (28, 6, 30, 20), '筛选', intrinsic=(28, 20))
    before = frozen(rt, [owner, control, icon, label])
    cpu.run(0x7848, control)
    glass = material(rt, control)
    near(frame(rt, glass), (-2, 0, 69, 32), 'One pill encloses icon and title with balanced padding')
    unchanged(rt, before)
    return {'frame': frame(rt, glass), 'instructions': cpu.steps}


def reading_time_pill(data, entries):
    cpu, rt = make(data, entries)
    owner = rt.view('SS525BookShelfSubHeaderView', 'reading_header', (0, 106, 440, 44), rt.ROOT)
    control = rt.view('UIButton', 'reading_time', (20, 8, 152, 28), owner)
    icon = rt.image_view('coin', control, (8, 6, 16, 16), size=(16, 16))
    label = rt.label('time_label', control, (28, 4, 116, 20), '今日已看听49分钟',
                     intrinsic=(116, 20), line_height=18)
    before = frozen(rt, [owner, control, icon, label])
    cpu.run(0x7848, control)
    glass = material(rt, control)
    near(frame(rt, glass), (-2, -2, 156, 32), 'Reading status uses content-sized pill')
    unchanged(rt, before)
    return {'frame': frame(rt, glass), 'instructions': cpu.steps}


def larger_font(data, entries):
    cpu, rt = make(data, entries)
    owner, control, label = shelf(rt, control_frame=(380, 0, 48, 44),
                                  label_frame=(4, 10, 40, 24), intrinsic=(32, 24),
                                  line_height=24)
    before = frozen(rt, [owner, control, label])
    cpu.run(0x7848, control)
    glass = material(rt, control)
    near(frame(rt, glass), (-2, 5, 52, 34), 'Font metrics expand the material without relaying out text')
    unchanged(rt, before)
    return {'frame': frame(rt, glass), 'instructions': cpu.steps}


def clipped_icon(data, entries):
    cpu, rt = make(data, entries)
    owner, control, icon = reader(rt, control_frame=(16, 10, 24, 24),
                                  image_frame=(2, 2, 20, 20), image_size=(20, 20),
                                  clipsToBounds=True)
    before = frozen(rt, [owner, control, icon])
    cpu.run(0x7848, control)
    glass = material(rt, control)
    near(frame(rt, glass), (0, 0, 24, 24), 'Own clipping bounds limit circle without asymmetry')
    unchanged(rt, before)
    return {'frame': frame(rt, glass), 'instructions': cpu.steps}


def clipped_text(data, entries):
    cpu, rt = make(data, entries)
    owner, control, label = shelf(rt, clipsToBounds=True)
    before = frozen(rt, [owner, control, label])
    cpu.run(0x7848, control)
    require(material(rt, control) == 0, 'Insufficient title padding does not create a cramped circle')
    unchanged(rt, before)
    return {'no_material_when_padding_impossible': True, 'instructions': cpu.steps}


def hidden_and_visible(data, entries):
    cpu, rt = make(data, entries)
    owner, control, icon = reader(rt, hidden=True)
    cpu.run(0x7848, control)
    require(material(rt, control) == 0, 'Hidden control does not allocate visible decoration')
    rt.objects[control].state['hidden'] = False
    cpu.run(0x7848, control)
    first = material(rt, control)
    near(frame(rt, first), (4, 4, 36, 36), 'Visible control is styled')
    rt.objects[icon].state['hidden'] = True
    cpu.run(0x7848, control)
    require(material(rt, control) == 0 and rt.objects[first].state['superview'] == 0,
            'Hidden glyph removes only the stale owned material')
    require(rt.objects[icon].state['superview'] == control,
            'Host glyph stays attached')
    rt.objects[icon].state['hidden'] = False
    cpu.run(0x7848, control)
    new = material(rt, control)
    near(frame(rt, new), (4, 4, 36, 36), 'Reappearing glyph rebuilds a valid capsule')
    require(not rt.objects[new].state['hidden'], 'No stale hidden state persists')
    return {'hidden_control_and_glyph_recovery': True, 'instructions': cpu.steps}


def nonfinite(data, entries):
    outcomes = []
    for where, bad in (('control', math.nan), ('control', math.inf),
                       ('image', math.nan), ('image', -math.inf)):
        cpu, rt = make(data, entries)
        owner, control, icon = reader(rt)
        target = control if where == 'control' else icon
        old = rt.objects[target].state['bounds']
        rt.objects[target].state['bounds'] = (old[0], old[1], bad, old[3])
        before = frozen(rt, [owner, control, icon])
        cpu.run(0x7848, control)
        require(material(rt, control) == 0, 'Nonfinite geometry cannot create a material')
        require(not any(e['event'] == 'setFrame' for e in rt.events),
                'No nonfinite CGRect reaches a frame setter')
        unchanged(rt, before)
        outcomes.append({'where': where, 'value': repr(bad), 'instructions': cpu.steps})
    return {'cases': outcomes}


def original_fallback(data, entries):
    cpu, rt = make(data, entries)
    owner, control, icon = reader(rt, scope='UIView')
    before = frozen(rt, [owner, control, icon])
    cpu.run(0x7848, control)
    glass = material(rt, control)
    near(frame(rt, glass), (0, 0, 44, 44), 'Unmatched scope retains original full-bounds material')
    require(0x784c in cpu.executed and 0x78a8 in cpu.executed,
            'Unmatched scope executes actual original instructions through trampoline')
    unchanged(rt, before)
    return {'original_trampoline_executed': True, 'frame': frame(rt, glass),
            'instructions': cpu.steps}


def selector_address(data, name, slide=0):
    return slide + data.index(name.encode() + b'\0')


def standalone_glyph(data, entries, slide=0):
    cpu, rt = make(data, entries, slide)
    owner = rt.view('SSStorySmallNavigationBar', 'story_nav', (0, 64, 440, 44), rt.ROOT)
    icon = rt.image_view('back_image', owner, (16, 10, 24, 24), size=(10, 20), content_mode=7)
    rt.objects[owner].state['leftBackIconView'] = icon
    selector = selector_address(data, 'leftBackIconView', slide)
    before = frozen(rt, [owner, icon])
    cpu.run(0x7ac4, owner, selector)
    glass = rt.associations.get((owner, selector), 0)
    near(frame(rt, glass), (3, 4, 36, 36), 'Standalone glyph sibling is centered on drawn image')
    require(rt.objects[glass].state['superview'] == owner, 'Image material remains a sibling')
    require(rt.objects[owner].state['subviews'].index(glass) < rt.objects[owner].state['subviews'].index(icon),
            'Glass remains below the host image')
    capsule_after_frame(rt, glass)
    unchanged(rt, before)
    return {'frame': frame(rt, glass), 'slide': hex(slide), 'instructions': cpu.steps}


def duplicate_prevention(data, entries):
    cpu, rt = make(data, entries)
    owner, control, icon = reader(rt, scope='SSStorySmallNavigationBar')
    rt.objects[owner].state['leftBackIconView'] = icon
    selector = selector_address(data, 'leftBackIconView')
    cpu.run(0x7ac4, owner, selector)
    glass = material(rt, control)
    near(frame(rt, glass), (4, 4, 36, 36), 'Nested glyph shares the control material')
    require(not rt.associations.get((owner, selector), 0), 'No second owner/selector material')
    cpu.run(0x7848, control)
    require(material(rt, control) == glass, 'Subsequent control styling reuses same material')
    require(sum(rt.is_kind(p, rt.classes['UIVisualEffectView'])
                for p in rt.objects[control].state['subviews']) == 1,
            'No nested duplicate material')
    return {'one_shared_material': True, 'instructions': cpu.steps}


def unknown_glyph_selector(data, entries):
    cpu, rt = make(data, entries)
    owner = rt.view('SSStorySmallNavigationBar', 'selector_owner', (0, 64, 440, 44), rt.ROOT)
    icon = rt.image_view('like_icon', owner, (16, 10, 24, 24))
    rt.objects[owner].state['likeIcon'] = icon
    selector = selector_address(data, 'likeIcon')
    cpu.run(0x7ac4, owner, selector)
    glass = rt.associations.get((owner, selector), 0)
    near(frame(rt, glass), (12, 6, 32, 32), 'Unknown selector keeps original 4pt expansion')
    require(0x7ac8 in cpu.executed, 'Actual glyph fallback trampoline executes')
    return {'frame': frame(rt, glass), 'instructions': cpu.steps}


def baseline_differences(data):
    require(hashlib.sha256(data).hexdigest() == '918313ffab725b9b4c53d030fac463f836032b164b9b30b9815720418e8d36d4',
            'Geometry negative control must be pinned 1.5.6; 1.5.7 already contains scoped geometry')
    require(data[0x7848:0x784c] == bytes.fromhex('f44fbea9'),
            'Geometry negative control executes the real unpatched original control entry')
    cpu, rt = make(data, {})
    owner, control, icon = reader(rt, control_frame=(16, 0, 24, 44),
                                  image_frame=(0, 10, 24, 24), image_size=(10, 20), mode=7)
    cpu.run(0x7848, control)
    old_icon = frame(rt, material(rt, control))
    near(old_icon, (0, 0, 24, 44), 'Uploaded version reproduces full-control asymmetry')
    cpu2, rt2 = make(data, {})
    owner2, control2, label2 = shelf(rt2)
    cpu2.run(0x7848, control2)
    old_text = frame(rt2, material(rt2, control2))
    near(old_text, (0, 0, 32, 32), 'Uploaded version reproduces two-character circle')
    return {'old_icon_frame': old_icon, 'old_text_frame': old_text,
            'instructions': cpu.steps + cpu2.steps}


def main():
    parser = argparse.ArgumentParser()
    parser.add_argument('--candidate', type=Path, required=True)
    parser.add_argument('--validation', type=Path, required=True)
    parser.add_argument('--baseline', type=Path)
    parser.add_argument('--report', type=Path, required=True)
    args = parser.parse_args()
    data = args.candidate.read_bytes()
    validation = json.loads(args.validation.read_text())
    digest = hashlib.sha256(data).hexdigest()
    require(validation['candidate_sha256'] == digest, 'Validation identifies the exact candidate bytes')
    entries = validation['extension_directory']
    require(entry_target(data, 0x7848) == entries['style_control'], 'Control entry targets extension directory')
    require(entry_target(data, 0x7ac4) == entries['style_glyph'], 'Glyph entry targets extension directory')
    checks = [
        ('reader_circle', symmetric_icon), ('reader_left_aligned_image', asymmetric_left_image),
        ('edit_text_pill', edit_pill), ('filter_icon_and_text', filter_pill),
        ('reading_time_pill', reading_time_pill), ('larger_font_metrics', larger_font),
        ('own_clip_circle', clipped_icon), ('own_clip_insufficient_title_padding', clipped_text),
        ('hidden_control_and_glyph', hidden_and_visible), ('nonfinite_geometry', nonfinite),
        ('outside_scope_fallback', original_fallback), ('standalone_glyph', standalone_glyph),
        ('glyph_control_duplicate_prevention', duplicate_prevention),
        ('unknown_selector_fallback', unknown_glyph_selector),
        ('reader_ASLR', lambda d, e: symmetric_icon(d, e, 0x100000000)),
        ('glyph_ASLR', lambda d, e: standalone_glyph(d, e, 0x100000000)),
    ]
    result = {
        'candidate_sha256': digest, 'passed': True, 'cases': [],
        'verification_scope': 'Actual candidate ARM64 instructions with stateful UIKit/Objective-C boundaries; no device pixels or animation timing',
        'patch_entries': {key: hex(entries[key]) for key in ('style_control', 'style_glyph')},
        'limitations': [
            'UILabel intrinsic sizes and UIImage sizes/content modes are supplied as platform fixtures.',
            'This suite supplies geometry-only fixtures; actual alpha centring is independently covered by test_reader_alignment.py.',
            'Real host classes/subview topology and all screenshot effects still require device verification.',
        ],
    }
    try:
        if args.baseline:
            baseline = args.baseline.read_bytes()
            result['baseline_sha256'] = hashlib.sha256(baseline).hexdigest()
            result['baseline_negative_controls'] = baseline_differences(baseline)
        for name, test in checks:
            details = test(data, entries)
            result['cases'].append({'name': name, 'passed': True, **details})
            print('PASS', name)
    except Exception as exc:
        result['passed'] = False
        result['failure'] = str(exc)
        result['traceback'] = traceback.format_exc()
        if RUNS:
            result['last_trace'] = [hex(x) for x in list(RUNS[-1][0].trace)[-40:]]
        args.report.write_text(json.dumps(result, ensure_ascii=False, indent=2) + '\n')
        raise
    result['case_count'] = len(result['cases'])
    result['total_executed_instructions'] = sum(cpu.steps for cpu, _ in RUNS)
    result['abi_checks'] = 'Every top-level run preserved x18, x19-x29, d8-d15 and balanced/aligned SP'
    args.report.write_text(json.dumps(result, ensure_ascii=False, indent=2) + '\n')
    print(json.dumps({'passed': True, 'cases': result['case_count'],
                      'instructions': result['total_executed_instructions'],
                      'sha256': digest}, indent=2))


if __name__ == '__main__':
    main()
