#!/usr/bin/env python3
"""Execute the candidate's reader repair, including a 1.5.7 negative control.

This verifies actual ARM64 instructions against public-framework fixtures. It
cannot measure iPhone tap latency, native glass pixels, or real host topology.
"""
import argparse
import hashlib
import json
from pathlib import Path
import struct
import traceback

from arm64 import CPU, require
from reader_runtime import ReaderRuntime
import test_control_geometry as geometry


RUNS = []
SURFACE = 0xeb8b
MUTATIONS = {'setFrame', 'cornerConfiguration', 'setHidden',
             'setAutoresizingMask:', 'setUserInteractionEnabled:',
             'setAccessibilityElementsHidden:', 'setImage:', 'setContentMode:', 'setCenter:'}


def make(data, validation, slide=0, **options):
    rt = ReaderRuntime(data, slide=slide, **options)
    ext = validation['extension_directory']
    ranges = [(0x800, 0x4000), (0x4878, 0x48d0), (0x5d04, 0x5d54),
              (0x6274, 0x62ac), (0x702c, 0x75d4), (0x7804, 0x78b8),
              (0x7ac4, 0x7d00), (0x14000, ext['code_end'])]
    cpu = CPU(data, rt, slide=slide, ranges=ranges)
    cpu.pointers.update(rt.rebase_pointers)
    RUNS.append((cpu, rt))
    return cpu, rt


def entry(validation, name):
    return validation['reader_directory'][name]


def run(cpu, address, *args, **kwargs):
    return cpu.run(address, args=list(args), **kwargs)


def mutate_count(rt):
    return {key: sum(e['event'] == key for e in rt.events) for key in sorted(MUTATIONS)}


def log_records(rt):
    values = {}
    for pointer, obj in rt.objects.items():
        if not rt.is_kind(pointer, rt.classes['NSDictionary']):
            continue
        items = obj.state.get('items', {})
        if 'sequence' not in items or 'event' not in items:
            continue
        if rt.string_value(items['event']) == 'reader_layout':
            record = rt.native(pointer)
            values[record['sequence']] = record
    return list(values.values())


def stable_control(data, validation, baseline=False):
    cpu, rt = make(data, validation)
    owner, control, icon = geometry.reader(rt)
    before = geometry.frozen(rt, [owner, control, icon])
    run(cpu, 0x7848, control)
    material = rt.associations[(control, rt.slide + SURFACE)]
    rt.events.clear()
    for _ in range(10):
        run(cpu, 0x7848, control)
    counts = mutate_count(rt)
    if baseline:
        require(counts['cornerConfiguration'] == 10,
                '1.5.7 reproduces a new cornerConfiguration on every stable control layout')
    else:
        require(not any(counts.values()), 'Ten settled control layouts make no visual mutations')
        require(rt.associations[(control, rt.slide + SURFACE)] == material, 'Material is reused')
    geometry.unchanged(rt, before)
    return counts


def stable_glyph(data, validation, baseline=False):
    cpu, rt = make(data, validation)
    owner = rt.view('SSStorySmallNavigationBar', 'story_owner', (0, 64, 440, 44), rt.ROOT)
    icon = rt.image_view('left_back', owner, (16, 10, 24, 24), (10, 20), 7)
    rt.objects[owner].state['leftBackIconView'] = icon
    selector = rt.slide + 0xbf9b
    before = geometry.frozen(rt, [owner, icon])
    run(cpu, 0x7ac4, owner, selector)
    rt.events.clear()
    for _ in range(10):
        run(cpu, 0x7ac4, owner, selector)
    counts = mutate_count(rt)
    if baseline:
        require(counts['setFrame'] == 20 and counts['cornerConfiguration'] == 10,
                '1.5.7 reproduces two alternating frames and one corner setter per settled glyph layout')
    else:
        require(not any(counts.values()), 'Ten settled glyph layouts make no visual mutations')
    geometry.unchanged(rt, before)
    return counts


def resized_control(data, validation):
    cpu, rt = make(data, validation)
    owner, control, icon = geometry.reader(rt)
    run(cpu, 0x7848, control)
    image = rt.objects[icon].state['image']
    rt.objects[image].state['size'] = (30, 30)
    rt.objects[icon].state.update(frame=(7, 7, 30, 30), bounds=(0, 0, 30, 30))
    rt.events.clear()
    run(cpu, 0x7848, control)
    counts = mutate_count(rt)
    require(counts['setFrame'] == 1 and counts['cornerConfiguration'] == 1,
            'A genuine resize updates frame and corner exactly once')
    rt.events.clear()
    run(cpu, 0x7848, control)
    require(not any(mutate_count(rt).values()), 'The new size then settles without mutations')
    return counts


def reentrant(data, validation):
    cpu, rt = make(data, validation)
    owner, control, icon = geometry.reader(rt)
    run(cpu, 0x7848, control)
    key = entry(validation, 'control_busy_key')
    rt.associations[(control, key)] = control
    rt.events.clear()
    run(cpu, 0x7848, control)
    require(not any(mutate_count(rt).values()), 'Reentrant control layout does not mutate the view')
    require(rt.associations[(control, key)] == control, 'Inner call does not erase outer busy marker')
    owner_key = entry(validation, 'busy_key')
    rt.associations[(owner, owner_key)] = owner
    before = cpu.steps
    run(cpu, entry(validation, 'reader_panel'), owner)
    require(rt.associations[(owner, owner_key)] == owner, 'Panel reentrancy preserves outer ownership')
    require(cpu.steps-before < 80, 'Panel reentrancy exits without traversing its tree')
    return {'panel_nested_instructions': cpu.steps-before}


def reader_back(rt):
    owner = rt.view('FQReaderSaasNavigationView', 'reader', (0, 64, 440, 44), rt.ROOT)
    control = rt.view('UIButton', 'back_button', (8, 0, 44, 44), owner)
    rt.objects[control].state.update(target=0x1234, action=0x5678)
    icon = rt.image_view('original_back_image', control, (10, 10, 24, 24), (24, 24), 7)
    rt.objects[owner].state['leftBackIconView'] = icon
    return owner, control, icon


def pixel_lifecycle(data, validation, slide=0):
    cpu, rt = make(data, validation, slide=slide, symbol_available=True)
    owner, control, icon = reader_back(rt)
    original = rt.rgba_image('original_back_pixels', 72, 72, range(32), size=(24, 24))
    rt.objects[icon].state.update(image=original, contentMode=0)
    before = geometry.frozen(rt, [owner, control])
    icon_frame = rt.objects[icon].state['frame']
    run(cpu, 0x7ac4, owner, rt.slide+0xbf9b)
    require(rt.objects[icon].state['image'] == original and rt.symbol_requests == 0,
            'Known FQ back getter keeps its host image and uses measured alpha')
    require(rt.objects[icon].state['contentMode'] == 0, 'Original drawing mode is untouched')
    glass = rt.associations[(control, rt.slide+SURFACE)]
    bounds = rt.objects[glass].state['frame']
    require(abs(bounds[0]+bounds[2]/2-22) < 1e-8, 'Back glass retains its original center')
    require(abs(rt.objects[icon].state['frame'][0]-10-20/3) < 1e-8,
            'Original arrow pixels move right by their measured padding offset')
    geometry.unchanged(rt, before)
    rt.events.clear()
    run(cpu, 0x7ac4, owner, rt.slide+0xbf9b)
    require(rt.ci_render_calls == 1 and not any(mutate_count(rt).values()),
            'Repeated pixel alignment has no image, center, or material churn')
    rt.objects[rt.DEFAULTS].state['values']['FanqieAdBlock.GlassDisabled.1'] = 1
    run(cpu, entry(validation, 'reader_panel'), owner)
    require(rt.objects[icon].state['image'] == original, 'Disable keeps original image')
    geometry.near(rt.objects[icon].state['frame'], icon_frame, 'Disable restores image center')
    require(not rt.associations.get((control, rt.slide+SURFACE)), 'Disable removes plugin material')
    geometry.unchanged(rt, before)
    return {'slide': hex(slide), 'pixel_reads': rt.ci_render_calls, 'back_frame': bounds}


def host_change_and_scope(data, validation):
    cpu, rt = make(data, validation, symbol_available=True)
    owner, control, icon = reader_back(rt)
    run(cpu, 0x7848, control)
    latest = rt.obj('UIImage', 'host_new_back_state', size=(24, 24))
    rt.objects[icon].state['image'] = latest
    run(cpu, 0x7848, control)
    run(cpu, 0x7848, control)
    require(rt.objects[icon].state['image'] == latest, 'A live host image replacement is never overwritten')
    require(rt.symbol_requests == 0, 'Host replacement never triggers an SF Symbol substitution')
    story = rt.view('SSStorySmallNavigationBar', 'other_story', (0, 0, 440, 44), rt.ROOT)
    image = rt.image_view('story_back', story, (16, 10, 24, 24))
    old = rt.objects[image].state['image']
    run(cpu, 0x7ac4, story, rt.slide+0xbf9b)
    require(rt.objects[image].state['image'] == old and rt.symbol_requests == 0,
            'Story bars keep their artwork; the new pixel correction is FQ navigation only')
    return {'host_image_preserved': True, 'non_fq_owner_preserved': True}


def metadata_and_fallback(data, validation):
    cpu, rt = make(data, validation, symbol_available=True)
    owner, control, icon = reader_back(rt)
    old = rt.objects[icon].state['image']
    rt.objects[old].state['alignmentRectInsets'] = (2, 0, 2, 12)
    run(cpu, 0x7ac4, owner, 0xbf9b)
    require(rt.objects[icon].state['image'] == old and rt.symbol_requests == 0,
            'Useful public alignment metadata preserves the host asset')
    glass = rt.associations[(control, SURFACE)]
    frame = rt.objects[glass].state['frame']
    require(abs(frame[0]+frame[2]/2-16) < 1e-8, 'Circle follows the inset drawing envelope, not padded canvas')
    for available, nil in [(False, False), (True, True)]:
        c, r = make(data, validation, symbol_available=available, symbol_nil=nil)
        o, b, i = reader_back(r)
        original = r.objects[i].state['image']
        run(c, 0x7848, b)
        require(r.objects[i].state['image'] == original and r.objects[i].state['contentMode'] == 7,
                'Missing/nil symbol APIs leave all image properties untouched')
    return {'alignment_aware_frame': frame, 'missing_api_preserves_host': True}


def standalone_back_cleanup(data, validation):
    cpu, rt = make(data, validation, symbol_available=True)
    owner = rt.view('FQReaderSaasNavigationView', 'standalone_reader', (0, 64, 440, 44), rt.ROOT)
    icon = rt.image_view('standalone_back', owner, (16, 10, 24, 24), (24, 24), 7)
    original = rt.objects[icon].state['image']
    rt.objects[owner].state['leftBackIconView'] = icon
    run(cpu, entry(validation, 'reader_panel'), owner)
    glass = rt.associations.get((owner, 0xbf9b))
    require(glass, 'Standalone getter owns a sibling glass material')
    rt.objects[rt.DEFAULTS].state['values']['FanqieAdBlock.GlassDisabled.1'] = 1
    run(cpu, entry(validation, 'reader_panel'), owner)
    require(not rt.associations.get((owner, 0xbf9b)), 'Disable clears the owner/getter material association')
    require(rt.objects[glass].state['superview'] == 0, 'Standalone glass is detached on disable')
    require(rt.objects[icon].state['image'] == original, 'Standalone original image restores on disable')
    rt.objects[rt.DEFAULTS].state['values']['FanqieAdBlock.GlassDisabled.1'] = 0
    run(cpu, entry(validation, 'reader_panel'), owner)
    rt.objects[owner].state['leftBackIconView'] = 0
    run(cpu, entry(validation, 'reader_panel'), owner)
    require(rt.objects[icon].state['image'] == original, 'A nil replacement getter restores the prior owned image')
    require(not rt.objects[rt.associations.get((owner, 0xbf9b))].state['superview'],
            'The saved legacy glyph lifecycle removes the orphan sibling')
    return {'standalone_disabled_cleanup': True, 'nil_getter_cleanup': True}


def panel_budget_and_original(data, validation):
    cpu, rt = make(data, validation)
    owner, control, icon = geometry.reader(rt)
    # Include effects and scroll contents containing buttons: neither subtree
    # is a navigation control tree and must not be traversed by this repair.
    effect = rt.view('UIVisualEffectView', 'foreign_effect', (0, 0, 400, 44), owner)
    nested = rt.view('UIButton', 'inside_effect', (0, 0, 44, 44), effect)
    scroll = rt.view('UIScrollView', 'reader_scroll', (0, 0, 400, 44), owner)
    nested_scroll = rt.view('UIButton', 'inside_scroll', (0, 0, 44, 44), scroll)
    for i in range(80):
        rt.view('UIView', 'extra_'+str(i), (0, 0, 1, 1), owner)
    last = rt.view('UIButton', 'beyond_budget', (0, 0, 44, 44), owner)
    rt._add(rt.classes['FQReaderSaasNavigationView'], 'fqab_readerNav', rt.LAYOUT_IMP, 'v16@0:8')
    selector = rt.sel('layoutSubviews')
    run(cpu, 0x5d04, owner, selector)
    originals = [e for e in rt.events if e['event'] == 'original_layout']
    require(len(originals) == 1 and originals[0]['selector'] == selector,
            'Original reader layout executes exactly once with the original selector')
    require(rt.associations.get((control, SURFACE)), 'A normal reader control is styled')
    for child in (nested, nested_scroll, last):
        require(not rt.associations.get((child, SURFACE)), 'Excluded/budgeted descendants stay untouched')
    records = log_records(rt)
    require(len(records) == 1, 'One initial reader diagnostic is enqueued')
    record = records[0]
    require(record['pluginVersion'] == '1.6.0' and isinstance(record['timestamp'], float),
            'Reader diagnostic uses the versioned timestamped event envelope')
    require(record['data']['readerVisitedViews'] == 64 and record['data']['readerTraversalBudgetExhausted'] == 1,
            'The one total traversal budget is enforced and reported')
    rt.events.clear()
    run(cpu, 0x5d04, owner, selector)
    require(not any(mutate_count(rt).values()), 'Repeated settled panel scan does not change decoration properties')
    require(len(log_records(rt)) == 1, 'Stable layouts do not append duplicate reader logs')
    return {'visited': 64, 'original_layout_calls_per_pass': 1, 'record': record}


def detach_and_epoch(data, validation):
    cpu, rt = make(data, validation, symbol_available=True)
    owner, control, icon = reader_back(rt)
    original = rt.objects[icon].state['image']
    run(cpu, entry(validation, 'reader_panel'), owner)
    selector = rt.sel('didMoveToWindow')
    method = rt.get_method(rt.classes['FQReaderSaasNavigationView'], selector)
    require(method and rt.methods[method]['imp'] != rt.WINDOW_IMP, 'Only the FQ reader window lifecycle is hooked')
    require(rt.methods[rt.get_method(rt.UIView, selector)]['imp'] == rt.WINDOW_IMP,
            'UIView didMoveToWindow remains unmodified')
    rt.reparent(owner, 0)
    run(cpu, rt.methods[method]['imp']-rt.slide, owner, selector)
    require(rt.objects[icon].state['image'] == original, 'Reader detachment restores the original image')
    require(not rt.associations.get((control, SURFACE)), 'Reader detachment removes owned material')
    require(any(e['event'] == 'original_window' and e['selector'] == selector for e in rt.events),
            'Saved host window callback runs with its true selector')
    # Transfer the image to a different reader and ensure the old weak getter
    # cannot later revoke the new reader's ownership.
    rt.reparent(owner, rt.ROOT)
    run(cpu, 0x7848, control)
    newer = rt.view('FQReaderSaasNavigationView', 'new_reader', (0, 0, 440, 44), rt.ROOT)
    rt.reparent(control, newer)
    run(cpu, 0x7848, control)
    own = rt.objects[icon].state['image']
    rt.objects[owner].state['hidden'] = True
    run(cpu, entry(validation, 'reader_panel'), owner)
    require(rt.objects[icon].state['image'] == own, 'Old reader cleanup cannot erase a new reader epoch')
    return {'scoped_window_lifecycle': True, 'ownership_epoch_preserved': True}


def monotonic_log(data, validation):
    cpu, rt = make(data, validation)
    owner, control, icon = geometry.reader(rt)
    observe = entry(validation, 'layout_observe')
    run(cpu, observe, owner, 60, fp_args=[rt.uptime-0.02])
    require(len(log_records(rt)) == 1, 'Slow sample is recorded')
    rt.now -= 90000  # Wall clock correction cannot change elapsed duration.
    rt.uptime += 0.1
    run(cpu, observe, owner, 60, fp_args=[rt.uptime-0.02])
    require(len(log_records(rt)) == 1, 'Repeated slow samples within 1 second are coalesced')
    rt.uptime += 1.1
    run(cpu, observe, owner, 60, fp_args=[rt.uptime-0.02])
    records = log_records(rt)
    require(len(records) == 2, 'A later slow sample is recorded')
    for record in records:
        require(abs(record['data']['readerPluginLayoutMs']-20) < 1e-6,
                'Elapsed duration uses monotonic uptime even across wall-clock rollback')
    return {'sample_count': len(records), 'fixture_elapsed_ms': 20.0}


def main():
    parser = argparse.ArgumentParser(description=__doc__)
    parser.add_argument('--candidate', type=Path, required=True)
    parser.add_argument('--validation', type=Path, required=True)
    parser.add_argument('--baseline157', type=Path, required=True)
    parser.add_argument('--baseline-validation', type=Path, required=True)
    parser.add_argument('--report', type=Path, required=True)
    args = parser.parse_args()
    data = args.candidate.read_bytes()
    validation = json.loads(args.validation.read_text())
    digest = hashlib.sha256(data).hexdigest()
    require(validation['candidate_sha256'] == digest, 'Exact delivered candidate matches its validation')
    result = {'passed': False, 'candidate_sha256': digest, 'cases': [],
              'scope': 'Actual AArch64 execution with explicit public UIKit/Foundation fixtures',
              'device_tested': False,
              'limits': ['No device UIKit rendering, touch dispatch latency, Core Animation timing, or actual host class hierarchy is simulated.',
                         'Pixel correction is limited to a leading FQ single-icon control or a confirmed standalone getter; separate alignment tests cover unknown getters, actual RGBA padding, and child layout ordering.',
                         'The 20ms diagnostic case is an injected clock fixture, not a measured performance result.']}
    try:
        baseline = args.baseline157.read_bytes()
        old_validation = json.loads(args.baseline_validation.read_text())
        require(old_validation['candidate_sha256'] == hashlib.sha256(baseline).hexdigest(), 'Exact 1.5.7 negative control')
        result['baseline157'] = {'sha256': hashlib.sha256(baseline).hexdigest(),
                                 'ten_stable_control_layouts': stable_control(baseline, old_validation, True),
                                 'ten_stable_glyph_layouts': stable_glyph(baseline, old_validation, True)}
        checks = [('stable_control', stable_control), ('stable_glyph', stable_glyph),
                  ('real_resize', resized_control), ('reentrant_layout', reentrant),
                  ('known_back_pixels_and_disable', pixel_lifecycle),
                  ('known_back_ASLR', lambda d, v: pixel_lifecycle(d, v, 0x100000000)),
                  ('host_replacement_and_exact_scope', host_change_and_scope),
                  ('alignment_metadata_and_missing_api', metadata_and_fallback),
                  ('standalone_back_and_nil_getter_cleanup', standalone_back_cleanup),
                  ('bounded_panel_and_original_callback', panel_budget_and_original),
                  ('detached_reader_and_owner_epochs', detach_and_epoch),
                  ('monotonic_coalesced_diagnostic', monotonic_log)]
        for name, test in checks:
            details = test(data, validation)
            result['cases'].append({'name': name, 'passed': True, 'details': details})
            print('PASS', name)
        # Preserve the established geometry contract; only the boundary adds
        # documented NSValue, center, and pixel capabilities required by the new code.
        geometry.GeometryRuntime = ReaderRuntime
        prior = [('reader_circle', geometry.symmetric_icon),
                 ('reader_left_aligned_image', geometry.asymmetric_left_image),
                 ('edit_text_pill', geometry.edit_pill),
                 ('filter_icon_and_text', geometry.filter_pill),
                 ('reading_time_pill', geometry.reading_time_pill),
                 ('larger_font_metrics', geometry.larger_font),
                 ('own_clip_circle', geometry.clipped_icon),
                 ('own_clip_insufficient_title_padding', geometry.clipped_text),
                 ('hidden_control_and_glyph', geometry.hidden_and_visible),
                 ('nonfinite_geometry', geometry.nonfinite),
                 ('outside_scope_fallback', geometry.original_fallback),
                 ('standalone_glyph', geometry.standalone_glyph),
                 ('glyph_control_duplicate_prevention', geometry.duplicate_prevention),
                 ('unknown_selector_fallback', geometry.unknown_glyph_selector),
                 ('reader_ASLR', lambda d, e: geometry.symmetric_icon(d, e, 0x100000000)),
                 ('glyph_ASLR', lambda d, e: geometry.standalone_glyph(d, e, 0x100000000))]
        for name, test in prior:
            details = test(data, validation['extension_directory'])
            result['cases'].append({'name': 'prior_'+name, 'passed': True, 'details': details})
            print('PASS prior_'+name)
        result['passed'] = True
    except Exception as exc:
        result['error'] = str(exc)
        result['traceback'] = traceback.format_exc()
        if RUNS:
            result['last_trace'] = [hex(p) for p in list(RUNS[-1][0].trace)[-40:]]
        args.report.write_text(json.dumps(result, ensure_ascii=False, indent=2)+'\n')
        raise
    result['case_count'] = len(result['cases'])
    result['instructions'] = sum(cpu.steps for cpu, _ in RUNS + geometry.RUNS)
    result['abi_checks'] = 'Each execution preserves x18, x19-x29, d8-d15, aligned and balanced SP.'
    args.report.write_text(json.dumps(result, ensure_ascii=False, indent=2)+'\n')
    print(json.dumps({key: result[key] for key in ('passed', 'case_count', 'instructions', 'candidate_sha256')}, indent=2))


if __name__ == '__main__':
    main()
