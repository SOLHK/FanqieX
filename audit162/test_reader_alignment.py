#!/usr/bin/env python3
"""Execute reader-centering ARM64 bytes against explicit native API fixtures.

The framework render boundary supplies RGBA pixels, not a precomputed envelope.
The candidate scans alpha, selects ownership, computes geometry, mutates center,
and restores state itself. This is not iOS UIKit/GPU or real-device acceptance.
"""
import argparse
import hashlib
import json
import math
import struct
from pathlib import Path
import traceback

from arm64 import require, sx
import test_reader_fastpath as prior
from test_control_geometry import frozen, unchanged, near

SURFACE = 0xeb8b
MUTATIONS = prior.MUTATIONS | {'setCenter:'}


def make(data, validation, *, slide=0, getter='none', **options):
    cpu, rt = prior.make(data, validation, slide=slide, symbol_available=True, **options)
    owner = rt.view('FQReaderSaasNavigationView', 'reader', (0, 64, 440, 44), rt.ROOT)
    control = rt.view('UIButton', 'back_button', (8, 0, 44, 44), owner)
    rt.objects[control].state.update(target=0x1234, action=0x5678)
    icon = rt.image_view('back_image', control, (10, 10, 24, 24), (24, 24), 0)
    image = rt.rgba_image('original_padded_arrow', 72, 72, range(0, 32), size=(24, 24))
    rt.objects[icon].state['image'] = image
    if getter != 'none':
        rt.objects[owner].state['leftBackIconView'] = icon if getter == 'image' else control
    return cpu, rt, owner, control, icon, image


def layout(cpu, validation, owner):
    # A 256x256 image requires at most 65,536 iterations of the ARM64 pixel
    # loop. Keep the execution budget finite while allowing that explicit cap.
    return prior.run(cpu, prior.entry(validation, 'reader_panel'), owner, max_steps=2000000)


def center(rt, view):
    f = rt.objects[view].state['frame']
    return f[0]+f[2]/2, f[1]+f[3]/2


def painted_center(rt, icon, root):
    """Independent two-axis raster measurement of UIImage's displayed pixels.

    This reference transforms actual opaque pixel centres directly from the
    original UIImage enum. It does not read the candidate's bbox/cache or the
    Core Image boundary's transformed bitmap/EXIF table.
    """
    view = rt.objects[icon].state
    image = rt.objects[view['image']].state
    cg = rt.objects[image['CGImage']].state
    pixels = [((i//4 % cg['width']+.5)/cg['width'], (i//4//cg['width']+.5)/cg['height'])
              for i in range(3, len(cg['rgba']), 4) if cg['rgba'][i] >= 16]
    require(pixels, 'Fixture contains visible pixels')
    orientation = image.get('imageOrientation', 0)
    oriented = []
    for x, y in pixels:
        if orientation == 1:
            x, y = 1-x, 1-y
        elif orientation == 2:
            x, y = y, 1-x
        elif orientation == 3:
            x, y = 1-y, x
        elif orientation == 4:
            x, y = 1-x, y
        elif orientation == 5:
            x, y = x, 1-y
        elif orientation == 6:
            x, y = y, x
        elif orientation == 7:
            x, y = 1-y, 1-x
        if image.get('flipsForRightToLeftLayoutDirection') and view.get('effectiveUserInterfaceLayoutDirection') == 1:
            x = 1-x
        oriented.append((x, y))
    fraction_x = (min(p[0] for p in oriented)+max(p[0] for p in oriented))/2
    fraction_y = (min(p[1] for p in oriented)+max(p[1] for p in oriented))/2
    b = view['bounds']
    mode = view.get('contentMode', 0)
    if mode in (0, 3):
        x, y, width, height = b
    elif mode in (1, 2):
        scale = (min if mode == 1 else max)(b[2]/image['size'][0], b[3]/image['size'][1])
        width, height = image['size'][0]*scale, image['size'][1]*scale
        x = b[0]+(b[2]-width)/2
        y = b[1]+(b[3]-height)/2
    else:
        require(4 <= mode <= 12, 'Known UIViewContentMode')
        width, height = image['size']
        hx = 0 if mode in (7, 9, 11) else 1 if mode in (8, 10, 12) else .5
        hy = 0 if mode in (5, 9, 10) else 1 if mode in (6, 11, 12) else .5
        x, y = b[0]+(b[2]-width)*hx, b[1]+(b[3]-height)*hy
    return (rt.origin(icon)[0]-rt.origin(root)[0]+x+width*fraction_x,
            rt.origin(icon)[1]-rt.origin(root)[1]+y+height*fraction_y)


def painted_center_x(rt, icon, root):
    return painted_center(rt, icon, root)[0]


def glass(rt, control):
    pointer = rt.associations.get((control, rt.slide+SURFACE))
    require(pointer in rt.objects, 'Existing control material is present')
    return pointer


def aligned(rt, control, icon, expected_glass=(4, 4, 36, 36)):
    g = glass(rt, control)
    if expected_glass is not None:
        near(rt.objects[g].state['frame'], expected_glass, 'Glass frame stays at the baseline position')
    delta = tuple(a-b for a, b in zip(painted_center(rt, icon, control), center(rt, g)))
    require(all(abs(d) < 1e-8 for d in delta), 'Actual alpha centre equals glass centre on both axes; delta='+repr(delta))
    require(rt.objects[g].state['userInteractionEnabled'] == 0, 'Glass cannot receive host taps')
    return delta


def events(rt, name):
    return [e for e in rt.events if e['event'] == name]


def records(rt):
    found = {}
    for p, obj in rt.objects.items():
        if not rt.is_kind(p, rt.classes['NSDictionary']):
            continue
        items = obj.state.get('items', {})
        if 'sequence' in items and 'event' in items and rt.string_value(items['event']) == 'reader_back_alignment':
            value = rt.native(p)
            found[value['sequence']] = value
    return list(found.values())


def negative(data, validation, getter):
    cpu, rt, owner, control, icon, image = make(data, validation, getter=getter)
    layout(cpu, validation, owner)
    delta = painted_center_x(rt, icon, control)-center(rt, glass(rt, control))[0]
    require(abs(delta+20/3) < 1e-8, '1.5.8 reproduces the 20 px / 3 left offset')
    require(rt.symbol_requests == 0, 'Old no-getter/UIButton paths never reach symbol normalization')
    require(rt.ci_render_calls == 0, 'Old code never measures actual alpha pixels')
    return {'getter': getter, 'offset_pt': delta, 'symbol_requests': rt.symbol_requests}


def negative_vertical(data, validation):
    cpu, rt, owner, control, icon, _ = make(data, validation)
    rt.objects[icon].state['image'] = rt.rgba_image('top_only_old_control', 72, 72,
                                                   range(72), opaque_rows=range(24), size=(24, 24))
    layout(cpu, validation, owner)
    offset = tuple(a-b for a, b in zip(painted_center(rt, icon, control), center(rt, glass(rt, control))))
    near(offset, (0, -8), 'Real 1.5.8 also fails a vertical-only transparent-padding case')
    return {'getter': 'none', 'case': 'vertical_alpha_padding', 'offset_pt': offset}


def entry_paths(data, validation):
    values = []
    for getter, slide in [('none', 0), ('image', 0), ('button', 0), ('none', 0x100000000)]:
        cpu, rt, owner, control, icon, image = make(data, validation, getter=getter, slide=slide)
        before = frozen(rt, [owner, control])
        layout(cpu, validation, owner)
        aligned(rt, control, icon)
        unchanged(rt, before)
        require(rt.objects[icon].state['image'] == image, 'Original UIImage identity is preserved')
        require(rt.objects[icon].state['contentMode'] == 0, 'Original draw mode is preserved')
        require(rt.symbol_requests == 0, 'No SF Symbol replacement is requested')
        require(rt.ci_render_calls == rt.ci_context_requests == 1, 'One image read and one shared context')
        log = records(rt)
        require(log and log[-1]['data']['readerBackReason'] == 0, 'Applied pixel alignment is diagnosed')
        require(abs(log[-1]['data']['readerBackShiftX']-20/3) < 1e-8, 'Diagnostic reports the actual shift')
        values.append({'getter': getter, 'slide': hex(slide), 'center': center(rt, icon), 'pixel_reads': 1})
    return values


def settled_and_host_layout(data, validation):
    cpu, rt, owner, control, icon, image = make(data, validation)
    layout(cpu, validation, owner)
    baseline_frame = (10, 10, 24, 24)
    rt.events.clear()
    for _ in range(10):
        layout(cpu, validation, owner)
        aligned(rt, control, icon)
    require(not [e for e in rt.events if e['event'] in MUTATIONS], 'Ten settled frames have no visual setters')
    require(rt.ci_render_calls == 1 and len(records(rt)) == 1, 'Pixel cache and diagnostics are stable')
    for _ in range(10):
        rt.objects[icon].state['frame'] = baseline_frame  # actual host layout reset boundary
        layout(cpu, validation, owner)
        aligned(rt, control, icon)
    require(len(events(rt, 'setCenter:')) == 10, 'One correction per genuine host reset, with no drift')
    require(rt.ci_render_calls == 1, 'Host relayout reuses the immutable image pixel cache')
    return {'stable_frames': 10, 'host_reset_frames': 10, 'pixel_reads_total': rt.ci_render_calls}


def image_replacement(data, validation):
    cpu, rt, owner, control, icon, image = make(data, validation)
    layout(cpu, validation, owner)
    replacement = rt.rgba_image('right_padded_arrow', 72, 72, range(40, 72), size=(24, 24))
    rt.objects[icon].state['image'] = replacement
    layout(cpu, validation, owner)
    aligned(rt, control, icon)
    require(center(rt, icon)[0] < 22, 'New image padding reverses the absolute correction')
    require(rt.objects[icon].state['image'] == replacement, 'Host replacement is never overwritten')
    require(rt.ci_render_calls == 2 and rt.ci_context_requests == 1, 'One read for each image, one reusable context')
    rt.objects[icon].state['frame'] = (12, 10, 24, 24)
    layout(cpu, validation, owner)
    aligned(rt, control, icon, (6, 4, 36, 36))
    return {'distinct_image_reads': 2, 'context_count': 1, 'new_glass_frame': rt.objects[glass(rt, control)].state['frame']}


def restore_disable_and_host_wins(data, validation):
    for host_changed in (False, True):
        cpu, rt, owner, control, icon, image = make(data, validation)
        layout(cpu, validation, owner)
        expected = (33, 22) if host_changed else (22, 22)
        if host_changed:
            rt.objects[icon].state['frame'] = (21, 10, 24, 24)
        rt.objects[rt.DEFAULTS].state['values']['FanqieAdBlock.GlassDisabled.1'] = 1
        layout(cpu, validation, owner)
        near(center(rt, icon), expected, 'Disable conditionally restores only an owned center')
        require(rt.objects[icon].state['image'] == image, 'Disable leaves original image untouched')
        require(not rt.associations.get((control, rt.slide+SURFACE)), 'Disable removes decorative material')
    return {'owned_center_restored': True, 'host_changed_center_preserved': True}


def detach_and_epoch(data, validation):
    cpu, rt, owner, control, icon, image = make(data, validation)
    layout(cpu, validation, owner)
    rt.reparent(owner, 0)
    selector = rt.sel('didMoveToWindow')
    method = rt.get_method(rt.classes['FQReaderSaasNavigationView'], selector)
    prior.run(cpu, rt.methods[method]['imp']-rt.slide, owner, selector)
    near(center(rt, icon), (22, 22), 'Reader detachment restores center through its actual scoped hook')
    rt.reparent(owner, rt.ROOT)
    layout(cpu, validation, owner)
    newer = rt.view('FQReaderSaasNavigationView', 'new_reader', (0, 64, 440, 44), rt.ROOT)
    rt.reparent(control, newer)
    layout(cpu, validation, newer)
    aligned(rt, control, icon)
    layout(cpu, validation, owner)
    aligned(rt, control, icon)
    rt.objects[owner].state['hidden'] = True
    layout(cpu, validation, owner)
    aligned(rt, control, icon)
    return {'detachment_restored': True, 'old_reader_cannot_revoke_new_epoch': True}


def reject_topologies(data, validation):
    cases = []
    for variant in ('right', 'text', 'two_images', 'interactive', 'scale', 'rotation', 'other_scope', 'foreign_getter'):
        cpu, rt, owner, control, icon, image = make(data, validation)
        if variant == 'right':
            rt.objects[control].state['frame'] = (300, 0, 44, 44)
        elif variant == 'text':
            rt.label('button_title', control, (0, 8, 44, 20), '返回')
        elif variant == 'two_images':
            rt.image_view('overlay_icon', control, (15, 8, 12, 12), (12, 12))
        elif variant == 'interactive':
            rt.objects[icon].state['userInteractionEnabled'] = True
        elif variant == 'scale':
            rt.objects[icon].state['transform'] = (1.2, 0., 0., 1.2, 0., 0.)
        elif variant == 'rotation':
            rt.objects[control].state['transform'] = (0., 1., -1., 0., 0., 0.)
        elif variant == 'other_scope':
            rt.objects[owner].cls = rt.classes['SSStorySmallNavigationBar']
        elif variant == 'foreign_getter':
            other = rt.view('UIButton', 'actual_back_elsewhere', (300, 0, 44, 44), owner)
            rt.objects[owner].state['leftBackIconView'] = other
        before = frozen(rt, [control, icon])
        prior.run(cpu, 0x7848, control)
        unchanged(rt, before)
        require(not events(rt, 'setCenter:') and rt.ci_render_calls == 0,
                'Unsafe/out-of-scope topology is rejected before raster work: '+variant)
        cases.append(variant)
    return cases


def unsupported_images(data, validation):
    outcomes = []
    for variant, options, expected_reason in [
        ('no_cg', {}, 1), ('invalid_orientation', {}, 2), ('large', {}, 3),
        ('missing_coreimage', {'ci_available': False}, 4),
        ('nil_context', {'ci_context_nil': True}, 5), ('transparent', {}, 7),
        ('below_threshold', {}, 7), ('cap_insets', {}, 13),
        ('animation', {}, 14), ('highlighted', {}, 15), ('cropped', {}, 16),
        ('calibration_missing', {'ci_missing_selector': 'blackImage'}, 18),
        ('calibration_corrupt', {'ci_calibration_corrupt': True}, 18),
        ('orientation_unavailable', {'ci_missing_selector': 'imageByApplyingOrientation:'}, 2)]:
        cpu, rt, owner, control, icon, image = make(data, validation, **options)
        if variant == 'cap_insets':
            rt.objects[image].state['capInsets'] = (0., 2., 0., 2.)
        elif variant == 'animation':
            rt.objects[icon].state['isAnimating'] = True
        elif variant == 'highlighted':
            rt.objects[icon].state.update(isHighlighted=True, highlightedImage=image)
        elif variant == 'cropped':
            rt.objects[image].state['size'] = (48, 24)
            rt.objects[icon].state['contentMode'] = 2
        elif variant == 'no_cg':
            rt.objects[image].state['CGImage'] = 0
        elif variant in ('invalid_orientation', 'orientation_unavailable'):
            rt.objects[image].state['imageOrientation'] = 8 if variant == 'invalid_orientation' else 1
        elif variant == 'large':
            image = rt.rgba_image('too_large', 257, 72, range(32), size=(24, 24))
            rt.objects[icon].state['image'] = image
        elif variant in ('transparent', 'below_threshold'):
            image = rt.rgba_image(variant, 72, 72, range(32), alpha=0 if variant == 'transparent' else 15, size=(24, 24))
            rt.objects[icon].state['image'] = image
        before = frozen(rt, [control, icon])
        layout(cpu, validation, owner)
        layout(cpu, validation, owner)
        unchanged(rt, before)
        require(not events(rt, 'setCenter:'), 'Unsupported image leaves host geometry unchanged')
        log = records(rt)
        require(len(log) == 1 and log[0]['data']['readerBackReason'] == expected_reason,
                'Unsupported image reason is observable and cached: '+variant)
        require(rt.ci_render_calls <= 1 and rt.ci_bundle_loads <= 1, 'Failure does not retry costly work per layout')
        outcomes.append({'case': variant, 'reason': expected_reason, 'pixel_reads': rt.ci_render_calls})
    return outcomes


def bounded_pixels_and_framework_load(data, validation):
    cpu, rt, owner, control, icon, image = make(data, validation, ci_available=False, ci_load=True)
    image = rt.rgba_image('largest_supported', 256, 256, range(0, 128), alpha=16, size=(24, 24))
    rt.objects[icon].state['image'] = image
    layout(cpu, validation, owner)
    aligned(rt, control, icon)
    require(rt.ci_render_calls == 1 and rt.ci_bundle_loads == 1, 'Public framework loads once and maximum pixel buffer is scanned')
    require(rt.ci_calibration_calls == 1, 'Exactly one two-pixel calibration')
    return {'raster_size': [256, 256], 'buffer_bytes': 256*256*4, 'threshold': 16,
            'framework_loads': 1, 'pixel_reads': 1, 'calibration_reads': 1}


def standalone(data, validation):
    cpu, rt, owner, control, icon, image = make(data, validation)
    rt.reparent(icon, owner)
    rt.objects[icon].state['frame'] = (16, 10, 24, 24)
    rt.objects[icon].state['userInteractionEnabled'] = True
    rt.objects[owner].state['leftBackIconView'] = icon
    rt.reparent(control, 0)
    before = frozen(rt, [icon])
    layout(cpu, validation, owner)
    pointer = rt.associations[(owner, rt.slide+0xbf9b)]
    delta = tuple(a-b for a, b in zip(painted_center(rt, icon, owner), center(rt, pointer)))
    require(all(abs(d) < 1e-8 for d in delta), 'Standalone glass follows both alpha axes without moving the gesture target')
    unchanged(rt, before)
    rt.events.clear()
    layout(cpu, validation, owner)
    require(not [e for e in rt.events if e['event'] in MUTATIONS], 'Standalone material is also mutation-free at rest')
    require(records(rt)[-1]['data']['readerBackReason'] == 11, 'Standalone policy is diagnosed')
    return {'host_frame_preserved': True, 'glass_center_x': center(rt, pointer)[0]}


def allocation_failure(data, validation):
    outcomes = []
    for kind in ('snapshot', 'weak'):
        for index in ((1, 2) if kind == 'snapshot' else (1, 2, 3)):
            options = {kind+'_fail_at': index}
            cpu, rt, owner, control, icon, image = make(data, validation, **options)
            before = frozen(rt, [control, icon])
            prior.run(cpu, 0x7848, control)
            unchanged(rt, before)
            require(not events(rt, 'setCenter:'), 'Nil snapshot/weak box cannot permit an unrestorable center mutation')
            outcomes.append({'allocation': kind, 'failure_at': index})
    return outcomes


def geometry_change_diagnostic(data, validation):
    cpu, rt, owner, control, icon, image = make(data, validation)
    layout(cpu, validation, owner)
    rt.objects[icon].state.update(frame=(10, 10, 18, 24), bounds=(0, 0, 18, 24))
    layout(cpu, validation, owner)
    aligned(rt, control, icon, (1, 4, 36, 36))
    log = records(rt)
    require(len(log) == 2, 'Same image with a new required shift generates an updated diagnosis')
    require(abs(log[-1]['data']['readerBackShiftX']-5) < 1e-8, 'New geometry shift is reported')
    return {'records': len(log), 'new_shift': log[-1]['data']['readerBackShiftX']}


def fractional_rounding(data, validation):
    cpu, rt, owner, control, icon, image = make(data, validation)
    layout(cpu, validation, owner)
    installed = rt.objects[icon].state['frame']
    rt.events.clear()
    for _ in range(20):
        f = rt.objects[icon].state['frame']
        rt.objects[icon].state['frame'] = (math.nextafter(f[0], math.inf), *f[1:])
        layout(cpu, validation, owner)
        near(rt.objects[icon].state['frame'], installed, 'One-ULP host rounding must not accumulate an offset', tolerance=1e-6)
        aligned(rt, control, icon)
    require(not events(rt, 'setCenter:'), 'Subpixel rounding causes no repeated writes')
    rt.objects[rt.DEFAULTS].state['values']['FanqieAdBlock.GlassDisabled.1'] = 1
    layout(cpu, validation, owner)
    near(center(rt, icon), (22, 22), 'Rounded installed center still restores correctly')
    return {'rounded_layouts': 20, 'tolerance_pt': 1e-6, 'no_accumulation': True}


def hidden_and_control_transfer(data, validation):
    for hidden_ancestor in (False, True):
        cpu, rt, owner, control, icon, image = make(data, validation)
        target = control
        if hidden_ancestor:
            target = rt.view('UIView', 'button_container', (0, 0, 440, 44), owner)
            rt.reparent(control, target)
        layout(cpu, validation, owner)
        aligned(rt, control, icon)
        rt.objects[target].state['hidden'] = True
        layout(cpu, validation, owner)
        near(center(rt, icon), (22, 22), 'Hiding a control or ancestor relinquishes the owned center')
        rt.objects[target].state['hidden'] = False
        layout(cpu, validation, owner)
        aligned(rt, control, icon)
    cpu, rt, owner, control, icon, image = make(data, validation)
    layout(cpu, validation, owner)
    newer = rt.view('FQReaderSaasNavigationView', 'newer', (0, 64, 440, 44), rt.ROOT)
    replacement_control = rt.view('UIButton', 'replacement_control', (8, 0, 44, 44), newer)
    rt.reparent(icon, replacement_control)
    layout(cpu, validation, newer)
    aligned(rt, replacement_control, icon)
    prior.run(cpu, 0x7848, control)
    aligned(rt, replacement_control, icon)
    rt.objects[rt.DEFAULTS].state['values']['FanqieAdBlock.GlassDisabled.1'] = 1
    layout(cpu, validation, newer)
    near(center(rt, icon), (22, 22), 'Current control still retains a valid restore snapshot')
    return {'hidden_control_and_ancestor_restore': True, 'stale_control_cannot_revoke_new_owner': True}


def pending_child_layout(data, validation):
    target = validation['reader_directory']['settle_control']
    callsites = []
    for pc in range(0x14000, validation['extension_directory']['code_end'], 4):
        instruction = struct.unpack_from('<I', data, pc)[0]
        if instruction & 0xfc000000 == 0x94000000 and pc+(sx(instruction & 0x3ffffff, 26) << 2) == target:
            callsites.append(pc)
    require(len(callsites) == 1, 'Exactly one scoped pre-measurement settle call exists')
    # Targeted machine-code negative control: remove only the settle call.
    # The native boundary still queues and executes the original child layout.
    broken = bytearray(data)
    struct.pack_into('<I', broken, callsites[0], 0xd503201f)
    cpu, rt, owner, control, icon, image = make(bytes(broken), validation)
    rt.queue_layout(control, icon, (10, 10, 24, 24))
    layout(cpu, validation, owner)
    aligned(rt, control, icon)
    require(len(rt.pending_layouts) == 1, 'Without settle, child host layout remains pending after parent repair')
    rt.flush_pending()
    offset = painted_center_x(rt, icon, control)-center(rt, glass(rt, control))[0]
    require(abs(offset+20/3) < 1e-8, 'A later native child layout undoes the otherwise correct parent-tail alignment')
    for reenter in (False, True):
        cpu, rt, owner, control, icon, image = make(data, validation)
        rt.queue_layout(control, icon, (10, 10, 24, 24))
        rt.objects[control].state['layout_reenter'] = reenter
        layout(cpu, validation, owner)
        require(not rt.pending_layouts, 'Candidate consumes pending child layout before measuring')
        aligned(rt, control, icon)
        require(len(events(rt, 'pending_host_layout')) == 1, 'Pending original child layout executes once')
        require(len(events(rt, 'layoutIfNeeded_reentry')) == int(reenter), 'Reentry case actually executes')
        require(not rt.associations.get((control, validation['reader_directory']['control_busy_key'])),
                'Outer call clears the busy marker after safe synchronous reentry')
        rt.flush_pending()
        aligned(rt, control, icon)
    return {'nop_negative_callsite': hex(callsites[0]), 'negative_post_child_offset_pt': offset,
            'pending_consumed_before_measurement': True, 'synchronous_reentry_preserves_outer_guard': True}


def two_axis_pixels(data, validation):
    outcomes = []
    for row_order in ('top_down', 'bottom_up'):
        for rows in (range(0, 24), range(45, 72)):
            cpu, rt, owner, control, icon, _ = make(data, validation, ci_row_order=row_order)
            image = rt.rgba_image('off_centre_both_axes', 72, 72, range(4, 32),
                                 opaque_rows=rows, size=(24, 24))
            rt.objects[icon].state['image'] = image
            before = painted_center(rt, icon, control)
            layout(cpu, validation, owner)
            aligned(rt, control, icon)
            expected = (22-before[0], 22-before[1])
            log = records(rt)[-1]['data']
            near((log['readerBackShiftX'], log['readerBackShiftY']), expected,
                 'The diagnostic measures both actual displacement components')
            require(log['readerBackIconClass'] == 'UIImageView' and
                    log['readerBackIconParentClass'] == 'UIButton', 'Actual icon topology is diagnosed')
            require(len(log['readerBackAlphaRect']) == 4, 'Two-axis alpha envelope is available in exported logs')
            rt.events.clear()
            for _ in range(5):
                layout(cpu, validation, owner)
                aligned(rt, control, icon)
            require(not [e for e in rt.events if e['event'] in MUTATIONS],
                    'Both axes remain mutation-free at rest')
            require(rt.ci_calibration_calls == 1 and rt.ci_render_calls == 1,
                    'Bitmap row calibration and image read are both cached')
            rt.objects[rt.DEFAULTS].state['values']['FanqieAdBlock.GlassDisabled.1'] = 1
            layout(cpu, validation, owner)
            near(center(rt, icon), (22, 22), 'Both centre components restore together')
            outcomes.append({'row_order': row_order, 'opaque_y': [rows.start, rows.stop],
                             'shift_pt': expected, 'calibration_reads': 1, 'image_reads': 1})
    return outcomes


def orientation_scale_rtl(data, validation):
    outcomes = []
    for orientation in range(8):
        for rtl in (False, True):
            cpu, rt, owner, control, icon, _ = make(data, validation, ci_row_order='bottom_up')
            # An asymmetric, nonsquare native bitmap verifies 90-degree width/
            # height swaps rather than concealing orientation errors in a square.
            image = rt.rgba_image('oriented_pixels', 90, 60, range(5, 35),
                                 opaque_rows=range(8, 29), orientation=orientation, scale=3.0)
            rt.objects[image].state['flipsForRightToLeftLayoutDirection'] = rtl
            rt.objects[icon].state.update(image=image, contentMode=1,
                                         effectiveUserInterfaceLayoutDirection=int(rtl))
            layout(cpu, validation, owner)
            aligned(rt, control, icon)
            rt.events.clear()
            layout(cpu, validation, owner)
            aligned(rt, control, icon)
            require(not [e for e in rt.events if e['event'] in MUTATIONS], 'Orientation/RTL centres do not drift')
            require(rt.objects[icon].state['image'] == image, 'The original directional image stays installed')
            require(rt.ci_render_calls == 1 and rt.ci_calibration_calls == 1,
                    'Rotated and mirrored images reuse their pixels')
            outcomes.append({'ui_orientation': orientation, 'rtl': rtl,
                             'uiimage_size': rt.objects[image].state['size'], 'scale': 3.0,
                             'exif_calls': rt.ci_orientations})
    # A common iPhone@3x asset exceeds the draft's arbitrary 128-pixel bound.
    cpu, rt, owner, control, icon, _ = make(data, validation)
    image = rt.rgba_image('44pt_at_3x', 132, 132, range(4, 70),
                         opaque_rows=range(18, 117), scale=3.0)
    rt.objects[icon].state.update(image=image, contentMode=1)
    layout(cpu, validation, owner)
    aligned(rt, control, icon)
    require(rt.ci_render_calls == 1, '132px@3x icon is measured instead of silently rejected')
    outcomes.append({'raster_size': [132, 132], 'uiimage_size': [44, 44], 'scale': 3.0, 'accepted': True})
    cpu, rt, owner, control, icon, image = make(data, validation)
    rt.objects[owner].state['effectiveUserInterfaceLayoutDirection'] = 1
    rt.objects[control].state['frame'] = (388, 0, 44, 44)
    rt.objects[icon].state['effectiveUserInterfaceLayoutDirection'] = 1
    rt.objects[image].state['flipsForRightToLeftLayoutDirection'] = True
    layout(cpu, validation, owner)
    aligned(rt, control, icon)
    require(rt.ci_render_calls == 1, 'RTL leading edge is the right edge of the reader owner')
    outcomes.append({'owner_direction': 'RTL', 'leading_control_x': 388, 'mirrored_pixels_centred': True})
    return outcomes


def nested_and_content_modes(data, validation):
    outcomes = []
    for depth in (0, 1, 2):
        for mode in (0, 1, 4, 7, 8):
            cpu, rt, owner, control, icon, _ = make(data, validation, getter='image')
            parent = control
            for index in range(depth):
                parent = rt.view('UIView', 'icon_container_'+str(index), (0, 0, 44, 44), parent)
            rt.reparent(icon, parent)
            if depth == 2:
                rt._class('RuntimeBackImageSubclass', 'UIImageView')
                rt.objects[icon].cls = rt.classes['RuntimeBackImageSubclass']
            image = rt.rgba_image('nested_padding', 36, 60, range(3, 20),
                                 opaque_rows=range(4, 43), scale=3.0)
            rt.objects[icon].state.update(image=image, contentMode=mode, bounds=(2, 3, 24, 24))
            # UIView bounds origin affects local coordinates, not hit-frame.
            baseline_control = frozen(rt, [control])
            layout(cpu, validation, owner)
            aligned(rt, control, icon, None)
            unchanged(rt, baseline_control)
            layout(cpu, validation, owner)
            aligned(rt, control, icon, None)
            require(rt.ci_render_calls == 1, 'Nested content-mode case reuses original pixels')
            require(not rt.associations.get((owner, rt.slide+0xbf9b)),
                    'A nested getter shares the ancestor control material without duplicate glass')
            outcomes.append({'depth': depth, 'content_mode': mode, 'bounds_origin': [2, 3]})
    return outcomes


def clipping_and_restore_transition(data, validation):
    outcomes = []
    for variant in ('clipped_wrapper', 'masked_wrapper', 'masked_image', 'rounded_image'):
        cpu, rt, owner, control, icon, image = make(data, validation)
        if variant in ('clipped_wrapper', 'masked_wrapper'):
            wrapper = rt.view('UIView', 'clipping_wrapper', (10, 10, 8, 24), control,
                              clipsToBounds=variant == 'clipped_wrapper')
            rt.reparent(icon, wrapper)
            rt.objects[icon].state['frame'] = (0, 0, 24, 24)
            target = wrapper
        else:
            target = icon
        if 'masked' in variant:
            layer = rt.layer(target)
            rt.objects[layer].state['mask'] = rt.obj('CALayer', 'asymmetric_mask')
        elif variant == 'rounded_image':
            rt.objects[icon].state['clipsToBounds'] = True
            rt.objects[rt.layer(icon)].state['cornerRadius'] = 12.
        before = frozen(rt, [control, icon])
        layout(cpu, validation, owner)
        unchanged(rt, before)
        require(not events(rt, 'setCenter:'), 'No correction can hide painted pixels: '+variant)
        require(records(rt)[-1]['data']['readerBackReason'] == 19, 'Masked/clipped pixels are diagnosed')
        outcomes.append({'rejected': variant, 'reason': 19})
    cpu, rt, owner, control, icon, image = make(data, validation)
    layout(cpu, validation, owner)
    aligned(rt, control, icon)
    new_image = rt.obj('UIImage', 'non_cg_replacement', size=(24, 24))
    rt.objects[icon].state['image'] = new_image
    layout(cpu, validation, owner)
    near(center(rt, icon), (22, 22), 'Changing to an unsupported image restores the old centre')
    near(rt.objects[glass(rt, control)].state['frame'], (4, 4, 36, 36),
         'The same pass uses the post-restore union; glass does not drift for one frame')
    rt.events.clear()
    layout(cpu, validation, owner)
    require(not [e for e in rt.events if e['event'] in MUTATIONS], 'Restore transition settles immediately')
    outcomes.append({'unsupported_image_transition_restores_same_frame': True})
    return outcomes


def role_transfer(data, validation):
    cpu, rt, owner, control, icon, image = make(data, validation)
    layout(cpu, validation, owner)
    rt.reparent(icon, owner)
    rt.reparent(control, 0)
    rt.objects[owner].state['leftBackIconView'] = icon
    # Preserve the currently installed frame when changing roles, as UIKit
    # reparenting itself does. The plugin must release its previous offset.
    for _ in range(3):
        layout(cpu, validation, owner)
        material = rt.associations[(owner, rt.slide+0xbf9b)]
        near(painted_center(rt, icon, owner), center(rt, material),
             'A former button icon is centred correctly as a standalone glyph')
    near(center(rt, icon), (22, 22), 'Previous temporary offset is relinquished at role transfer')
    new_control = rt.view('UIButton', 'new_control', (8, 0, 44, 44), owner)
    rt.reparent(icon, new_control)
    layout(cpu, validation, owner)
    aligned(rt, new_control, icon)
    require(not rt.associations.get((owner, rt.slide+0xbf9b)),
            'Returning to a control removes the obsolete standalone material')
    # A new owner must release old offsets even if its replacement image cannot
    # be scanned; otherwise failure would strand a mutation from the old owner.
    rt.reparent(icon, control)
    rt.reparent(control, owner)
    rt.reparent(new_control, 0)
    rt.objects[icon].state['image'] = rt.obj('UIImage', 'unsupported_reused_icon', size=(24, 24))
    layout(cpu, validation, owner)
    near(center(rt, icon), (22, 22), 'Unsupported new role restores the old owner offset')
    near(rt.objects[glass(rt, control)].state['frame'], (4, 4, 36, 36),
         'New owner uses a fresh baseline even when alpha measurement is unavailable')
    return {'button_to_standalone_to_button': True, 'unsupported_replacement_releases_prior_owner': True}


def main():
    p = argparse.ArgumentParser(description=__doc__)
    p.add_argument('candidate', type=Path)
    p.add_argument('--validation', type=Path, required=True)
    p.add_argument('--baseline', type=Path, required=True)
    p.add_argument('--baseline-validation', type=Path, required=True)
    p.add_argument('--output', type=Path, required=True)
    args = p.parse_args()
    data, baseline = args.candidate.read_bytes(), args.baseline.read_bytes()
    validation = json.loads(args.validation.read_text())
    old = json.loads(args.baseline_validation.read_text())
    digest = hashlib.sha256(data).hexdigest()
    require(validation['candidate_sha256'] == digest, 'Candidate hash matches its build validation')
    require(old['candidate_sha256'] == hashlib.sha256(baseline).hexdigest(), 'Pinned 1.5.8 negative control hash')
    result = {'passed': False, 'candidate_sha256': digest, 'device_ui_tested': False,
              'boundary': 'Public Objective-C fixtures supply RGBA bytes; production ARM64 scans alpha and computes/restores center.',
              'limitations': ['No actual iPhone, UIKit renderer, GPU, host class tree, or touch delivery is emulated.',
                              'Only CGImage-backed, nonanimated, nonresizable images at most 256 pixels on either axis are measured.',
                              'The bounding envelope measures nontransparent pixels, not colour contrast inside an opaque rectangular bitmap.',
                              'First CoreImage initialization and real-device visual acceptance remain unmeasured.',
                              'layoutIfNeeded settles pending UIKit descendants; arbitrary later explicit host relayout can still overwrite a correction.'],
              'negative_controls': [], 'cases': []}
    checks = [('all_entry_paths', entry_paths), ('stable_and_host_resets', settled_and_host_layout),
              ('host_image_replacement', image_replacement), ('disable_and_host_wins', restore_disable_and_host_wins),
              ('detach_and_owner_epoch', detach_and_epoch), ('excluded_topologies', reject_topologies),
              ('unsupported_images', unsupported_images), ('bounded_scan_and_framework_load', bounded_pixels_and_framework_load),
              ('standalone_gesture_image', standalone), ('allocation_failures', allocation_failure),
              ('changed_shift_diagnostic', geometry_change_diagnostic),
              ('fractional_rounding_no_drift', fractional_rounding),
              ('hidden_and_control_transfer', hidden_and_control_transfer),
              ('pending_child_layout_order', pending_child_layout),
              ('two_axis_pixels_and_row_order', two_axis_pixels),
              ('orientation_scale_and_rtl', orientation_scale_rtl),
              ('nested_containers_and_drawing_modes', nested_and_content_modes),
              ('clipping_and_restore_transition', clipping_and_restore_transition),
              ('control_standalone_role_transfer', role_transfer)]
    try:
        for getter in ('none', 'button'):
            result['negative_controls'].append(negative(baseline, old, getter))
            print('PASS old_158_negative_'+getter)
        result['negative_controls'].append(negative_vertical(baseline, old))
        print('PASS old_158_negative_vertical')
        for name, function in checks:
            detail = function(data, validation)
            result['cases'].append({'name': name, 'passed': True, 'detail': detail})
            print('PASS', name)
        result['passed'] = True
    except Exception as exc:
        result['error'] = str(exc)
        result['traceback'] = traceback.format_exc()
        if prior.RUNS:
            result['last_trace'] = [hex(pc) for pc in list(prior.RUNS[-1][0].trace)[-50:]]
        args.output.parent.mkdir(parents=True, exist_ok=True)
        args.output.write_text(json.dumps(result, ensure_ascii=False, indent=2)+'\n')
        raise
    result['group_count'] = len(result['cases'])
    result['instructions'] = sum(cpu.steps for cpu, _ in prior.RUNS)
    result['abi_checks'] = 'Every execution preserves x18/x19-x29, d8-d15 and aligned/balanced SP; native calls poison caller-saved registers.'
    args.output.parent.mkdir(parents=True, exist_ok=True)
    args.output.write_text(json.dumps(result, ensure_ascii=False, indent=2)+'\n')
    print(json.dumps({k: result[k] for k in ('passed', 'group_count', 'instructions', 'candidate_sha256')}, indent=2))


if __name__ == '__main__':
    main()
