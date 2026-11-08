#!/usr/bin/env python3
"""First-presentation contract for the three bookshelf pills in user screenshots.

Execute the actual four header layout hooks and their emitted ARM64 material
path. Imported UIKit/Core Animation calls are stateful boundary fixtures. The
fixed 1.6.1 release is a required negative control for attach-before-frame.
These checks establish ordering, scope and ownership, not GPU pixels or the
duration of a real navigation transition.
"""
from __future__ import annotations

import argparse
from copy import deepcopy
import hashlib
import json
from pathlib import Path
import traceback

from arm64 import CPU, require
from reader_runtime import ReaderRuntime


ROOT = Path(__file__).resolve().parents[1]
SURFACE_KEY = 0xeb8b
PREVIOUS_SHA = '8c8aedc3643c52efa1180119a983c8cd22006123ea095db617ea901be0fbcf8e'
HOOKS = (
    ('SSBookShelfHeaderView', 'fqab_v4_shelf_header', 0x7f64, 'edit'),
    ('SS525BookShelfSubHeaderView', 'fqab_v4_shelf_subheader', 0x7fb0, 'status'),
    ('SSBookShelfEditHeaderView', 'fqab_v4_shelf_edit_header', 0x7ffc, 'edit'),
    ('SSBookShelfFilterHeaderView', 'fqab_v4_shelf_filter', 0x8048, 'filter'),
)
RUNS = []


class ShelfRuntime(ReaderRuntime):
    """Inject nil public factory results after a successful first presentation."""
    fail_corner_factory = False
    fail_size_snapshot = False

    def handle(self, cpu, pc):
        self.current_cpu = cpu
        if pc - self.slide == 0xa5d4 and cpu.x[0] in self.classes.values():
            cls = self.class_names[cpu.x[0]]
            method = self.selector_names.get(cpu.x[1])
            if (self.fail_corner_factory and cls == 'UICornerConfiguration' and
                    method == 'capsuleConfiguration'):
                return self.finish(cpu, 0)
            if (self.fail_size_snapshot and cls == 'NSValue' and
                    method == 'valueWithCGSize:'):
                return self.finish(cpu, 0)
        return super().handle(cpu, pc)


def make(data, validation, slide=0):
    runtime = ShelfRuntime(data, slide=slide)
    cpu = CPU(data, runtime, slide=slide, ranges=[
        (0x800, 0x4000), (0x4878, 0x48d0), (0x6274, 0x62ac),
        (0x702c, 0x7d00), (0x7f64, 0x8094),
        (0x14000, validation['extension_directory']['code_end']),
    ])
    cpu.pointers.update(runtime.rebase_pointers)
    RUNS.append((cpu, runtime))
    return cpu, runtime


def call(cpu, entry, *args):
    return cpu.run(entry, args=list(args), max_steps=1000000)


def surface(runtime, control):
    return runtime.associations.get((control, runtime.slide + SURFACE_KEY), 0)


def fixture(runtime, cls='SSBookShelfHeaderView', kind='edit'):
    owner = runtime.view(cls, 'bookshelf_header', (0, 106, 440, 44), runtime.ROOT)
    if kind == 'status':
        control = runtime.view('UIButton', 'reading_duration', (20, 8, 188, 28), owner)
        icon = runtime.image_view('coin', control, (8, 6, 16, 16), size=(16, 16))
        label = runtime.label('duration_title', control, (28, 4, 150, 20),
                              '今日已看听读176分钟', intrinsic=(150, 20), line_height=18)
        children = [icon, label]
    elif kind == 'filter':
        control = runtime.view('UIButton', 'filter', (364, 6, 66, 32), owner)
        icon = runtime.image_view('filter_icon', control, (8, 8, 16, 16), size=(16, 16))
        label = runtime.label('filter_title', control, (28, 6, 30, 20),
                              '筛选', intrinsic=(28, 20))
        children = [icon, label]
    else:
        control = runtime.view('UIButton', 'edit', (388, 6, 32, 32), owner)
        label = runtime.label('edit_title', control, (0, 6, 32, 20),
                              '编辑', intrinsic=(28, 20))
        children = [label]
    runtime.objects[control].state.update(
        target=0x123400, action=0x234500, accessibilityLabel=kind,
        control_targets=[(0x123400, runtime.sel('hostTap:'), 64)],
        backgroundColor=runtime.color('host_control_background'),
    )
    return owner, control, children


def host_snapshot(runtime, views):
    fields = ('frame', 'bounds', 'hidden', 'alpha', 'text', 'font', 'image',
              'target', 'action', 'control_targets', 'accessibilityLabel',
              'userInteractionEnabled', 'clipsToBounds', 'transform')
    return {v: {k: deepcopy(runtime.objects[v].state.get(k)) for k in fields}
            for v in views}


class PublicationProbe:
    """Observe public setter/insertion boundaries; never guess at rendered pixels."""
    def __init__(self, runtime, control, *, reenter=False):
        self.runtime = runtime
        self.control = control
        self.corners = {}
        self.attachments = []
        self.unsafe_mounted_geometry = []
        self.unscoped_background_changes = []
        self.commits = []
        self.reenter = reenter
        self.reentry_count = 0
        runtime.on_event = self.observe

    def state(self, view):
        runtime = self.runtime
        state = runtime.objects[view].state
        bounds = tuple(state['bounds'])
        content = runtime.objects[state['contentView']].state
        return {
            'view': view, 'frame': list(state['frame']), 'bounds': list(bounds),
            'capsule_configured_for_current_size': self.corners.get(view) == bounds[2:],
            'native_corner_present': bool(state.get('cornerConfiguration')),
            'positive_size': bounds[2] > 0 and bounds[3] > 0,
            'interaction_disabled': state.get('userInteractionEnabled') == 0,
            'accessibility_hidden': state.get('accessibilityElementsHidden') == 1,
            'autoresizing_disabled': state.get('autoresizingMask') == 0,
            'transparent_backing': state.get('opaque') is False and content.get('opaque') is False,
            'host_background_cleared': runtime.objects[self.control].state['backgroundColor'] ==
                                       runtime.color('clearColor'),
            'associated_before_attachment': surface(runtime, self.control) == view,
        }

    def ready(self, view):
        state = self.state(view)
        return all(value for key, value in state.items()
                   if key not in ('view', 'frame', 'bounds'))

    def observe(self, cpu, event):
        runtime = self.runtime
        view = event.get('self', 0)
        if event['event'] == 'cornerConfiguration':
            self.corners[view] = tuple(event['bounds'][2:])
        if event['event'] == 'backgroundColor' and view == self.control:
            if (event.get('value') == runtime.color('clearColor') and
                    not any(t['disableActions'] for t in runtime.transaction_stack)):
                self.unscoped_background_changes.append(deepcopy(event))
        if event['event'] == 'setFrame' and view in runtime.objects:
            state = runtime.objects[view].state
            if (state.get('superview') == self.control and
                    runtime.is_kind(view, runtime.classes['UIVisualEffectView'])):
                if not any(t['disableActions'] for t in runtime.transaction_stack):
                    if self.corners.get(view) != tuple(state['bounds'][2:]):
                        self.unsafe_mounted_geometry.append(self.state(view))
        if event['event'] == 'insertSubview:atIndex:' and view == self.control:
            child = event['child']
            if not runtime.is_kind(child, runtime.classes['UIVisualEffectView']):
                return
            self.attachments.append(self.state(child))
            if self.reenter and not self.reentry_count:
                self.reentry_count += 1
                saved_lr = cpu.x[30]
                result = call(cpu, 0x7848, self.control)
                cpu.x[30] = saved_lr
                require(result['result'] == child,
                        'Synchronous mount reentry sees the complete published surface')
        if event['event'] == 'transaction_commit':
            effect = surface(runtime, self.control)
            if effect and runtime.objects[effect].state['superview'] == self.control:
                self.commits.append(self.state(effect))

    def assert_ready(self):
        require(self.attachments, 'The material actually entered the live shelf subtree')
        for state in self.attachments + self.commits:
            require(all(value for key, value in state.items()
                        if key not in ('view', 'frame', 'bounds')),
                    'No partial geometry/style at publication or transaction completion: ' + repr(state))
        require(not self.unsafe_mounted_geometry,
                'A live capsule never receives ungrouped unfinished geometry')
        require(not self.unscoped_background_changes,
                'Host background clearing cannot inherit an ambient fade outside our disabled-actions transaction')


def hook_case(data, validation, hook, *, slide=0, return_from_reader=False, reenter=False):
    cls, alias, entry, kind = hook
    cpu, runtime = make(data, validation, slide)
    owner, control, children = fixture(runtime, cls, kind)
    runtime._add(runtime.classes[cls], alias, runtime.LAYOUT_IMP, 'v16@0:8')
    before = host_snapshot(runtime, [owner, control] + children)
    if return_from_reader:
        # The app has an unrelated ambient transition. The plugin must leave
        # that parent transaction and its enabled-action state intact.
        runtime.transaction_stack.append({'disableActions': False})
    probe = PublicationProbe(runtime, control, reenter=reenter)
    call(cpu, entry, owner, runtime.sel('layoutSubviews'))
    probe.assert_ready()
    require(sum(e['event'] == 'original_layout' and e.get('self') == owner
                for e in runtime.events) == 1, 'Actual original host layout executes once')
    require(host_snapshot(runtime, [owner, control] + children) == before,
            'Host geometry, input, contents and accessibility remain unchanged')
    require(runtime.transaction_stack == ([{'disableActions': False}] if return_from_reader else []),
            'Our transaction is balanced and preserves the ambient transition')
    require(not any(e['event'] in ('cornerRadius', 'masksToBounds', 'setNeedsLayout', 'setEffect')
                    for e in runtime.events),
            'No clipping patch, delayed repaint or effect reset is used')
    glass = surface(runtime, control)
    geometry_events = ('setFrame', 'cornerConfiguration', 'insertSubview:atIndex:',
                       'setHidden', 'opaque')
    start = len(runtime.events)
    for _ in range(4):
        call(cpu, entry, owner, runtime.sel('layoutSubviews'))
    require(surface(runtime, control) == glass, 'Settled layouts reuse exactly one capsule')
    require(not any(e['event'] in geometry_events for e in runtime.events[start:]),
            'Settled shelf layouts issue no frame/corner/visibility/opacity mutations')
    return {'class': cls, 'entry': hex(entry), 'slide': hex(slide),
            'first_attachment': probe.attachments[0], 'reentry_count': probe.reentry_count,
            'ambient_transition_preserved': return_from_reader}


def lifecycle_cases(data, validation):
    results = []
    for case in ('zero_then_ready', 'hidden_then_visible', 'reuse_after_reader', 'zero_during_return',
                 'font_resize', 'custom_drawing', 'reparented_decoration', 'zero_adopted_decoration'):
        cpu, runtime = make(data, validation)
        owner, control, children = fixture(runtime)
        probe = PublicationProbe(runtime, control)
        if case == 'zero_then_ready':
            runtime.objects[control].state.update(frame=(388, 6, 0, 0), bounds=(0, 0, 0, 0))
            call(cpu, 0x7848, control)
            require(not surface(runtime, control), 'An empty initial control emits no effect')
            runtime.objects[control].state.update(frame=(388, 6, 32, 32), bounds=(0, 0, 32, 32))
        elif case == 'hidden_then_visible':
            runtime.objects[control].state['hidden'] = True
            call(cpu, 0x7848, control)
            require(not surface(runtime, control), 'A hidden control emits no effect')
            runtime.objects[control].state['hidden'] = False
        elif case == 'custom_drawing':
            for child in children:
                runtime.reparent(child, 0)
        call(cpu, 0x7848, control)
        glass = surface(runtime, control)
        require(glass, 'Ready known bookshelf controls acquire a capsule')
        if case == 'reuse_after_reader':
            runtime.reparent(owner, 0)
            runtime.reparent(owner, runtime.ROOT)
            runtime.transaction_stack.append({'disableActions': False})
            call(cpu, 0x7848, control)
            require(surface(runtime, control) == glass and len(probe.attachments) == 1,
                    'Returning to a reused shelf keeps the already configured material')
            require(runtime.transaction_stack == [{'disableActions': False}],
                    'Return transition stays enabled for the app')
        elif case == 'zero_during_return':
            runtime.objects[control].state.update(frame=(388, 6, 0, 0), bounds=(0, 0, 0, 0))
            call(cpu, 0x7848, control)
            require(not surface(runtime, control) and runtime.objects[glass].state['superview'] == 0,
                    'A reused control temporarily losing geometry cannot display stale glass outside zero bounds')
            runtime.objects[control].state.update(frame=(388, 6, 32, 32), bounds=(0, 0, 32, 32))
            call(cpu, 0x7848, control)
            require(surface(runtime, control) != glass and len(probe.attachments) == 2,
                    'A later valid return mounts a fresh fully configured capsule')
        elif case == 'font_resize':
            runtime.objects[control].state.update(frame=(380, 0, 48, 44), bounds=(0, 0, 48, 44))
            label = runtime.objects[children[0]].state
            label.update(frame=(4, 10, 40, 24), bounds=(0, 0, 40, 24), intrinsicContentSize=(32, 24))
            runtime.objects[label['font']].state['lineHeight'] = 24
            call(cpu, 0x7848, control)
            require(surface(runtime, control) == glass and probe.commits,
                    'A real size change keeps the material and commits its new native shape atomically')
            require(tuple(runtime.objects[glass].state['frame']) == (-2, 5, 52, 34),
                    'Font increase has the expected content geometry')
        elif case in ('reparented_decoration', 'zero_adopted_decoration'):
            other = runtime.view('UIView', 'unrelated_parent', (0, 0, 100, 100), runtime.ROOT)
            runtime.reparent(glass, other)
            before = deepcopy(runtime.objects[glass].state)
            if case == 'zero_adopted_decoration':
                runtime.objects[control].state.update(frame=(388, 6, 0, 0), bounds=(0, 0, 0, 0))
            call(cpu, 0x7848, control)
            require(surface(runtime, control) != glass and runtime.objects[glass].state == before,
                    'A foreign reparented surface is neither moved nor mutated')
        probe.assert_ready()
        results.append({'name': case, 'attachments': len(probe.attachments),
                        'atomic_resize_commits': len(probe.commits)})
    return results


def failed_resize_rollback(data, validation):
    results = []
    for failure in ('fail_corner_factory', 'fail_size_snapshot'):
        cpu, runtime = make(data, validation)
        owner, control, children = fixture(runtime)
        probe = PublicationProbe(runtime, control)
        call(cpu, 0x7848, control)
        glass = surface(runtime, control)
        old_frame = runtime.objects[glass].state['frame']
        old_corner = runtime.objects[glass].state['cornerConfiguration']
        runtime.objects[control].state.update(frame=(380, 0, 48, 44), bounds=(0, 0, 48, 44))
        label = runtime.objects[children[0]].state
        label.update(frame=(4, 10, 40, 24), bounds=(0, 0, 40, 24), intrinsicContentSize=(32, 24))
        runtime.objects[label['font']].state['lineHeight'] = 24
        setattr(runtime, failure, True)
        call(cpu, 0x7848, control)
        require(surface(runtime, control) == glass and
                runtime.objects[glass].state['frame'] == old_frame and
                runtime.objects[glass].state['cornerConfiguration'] == old_corner,
                'Failed reconfiguration restores the previous complete frame and retained native corner object')
        require(not runtime.transaction_stack, 'Rollback balances its own transaction')
        probe.assert_ready()
        setattr(runtime, failure, False)
        call(cpu, 0x7848, control)
        require(surface(runtime, control) == glass and
                runtime.objects[glass].state['frame'] == (-2, 5, 52, 34),
                'Next successful layout retries the resize without reallocating the capsule')
        probe.assert_ready()
        require(runtime.retain_balance.get(old_corner, 0) == 0,
                'Rollback snapshot never leaks the old native corner configuration')
        results.append({'failure': failure, 'old_shape_restored': True, 'retry_succeeded': True})
    return results


def unavailable_cases(data, validation):
    results = []
    for missing in ('UIGlassEffect', 'UICornerConfiguration'):
        cpu, runtime = make(data, validation)
        owner, control, children = fixture(runtime)
        original_background = runtime.objects[control].state['backgroundColor']
        runtime.missing_classes.add(missing)
        probe = PublicationProbe(runtime, control)
        call(cpu, 0x7848, control)
        require(not surface(runtime, control) and not probe.attachments,
                'Unavailable material/shape never publishes an unconfigured rectangle')
        require(runtime.objects[control].state['backgroundColor'] == original_background,
                'A failed effect leaves the original host background intact')
        require(not runtime.transaction_stack, 'Failure leaves no open Core Animation transaction')
        results.append({'missing': missing, 'no_partial_surface': True})
    return results


def negative_previous(data, validation):
    cpu, runtime = make(data, validation)
    owner, control, children = fixture(runtime)
    probe = PublicationProbe(runtime, control)
    call(cpu, 0x7848, control)
    require(len(probe.attachments) == 1, 'Pinned 1.6.1 really creates and attaches the old material')
    first = probe.attachments[0]
    require(first['frame'] == [0, 0, 0, 0] and not first['positive_size'] and
            not first['autoresizing_disabled'] and not first['associated_before_attachment'],
            'Pinned 1.6.1 inserts an unpublished zero-frame autoresizing material')
    require(probe.unsafe_mounted_geometry,
            'The old material receives its first finite frame while already mounted, before final capsule configuration')
    return {'sha256': PREVIOUS_SHA, 'first_attachment': first,
            'unfinished_mounted_geometry_count': len(probe.unsafe_mounted_geometry),
            'new_contract_rejected': True}


def main():
    parser = argparse.ArgumentParser(description=__doc__)
    parser.add_argument('--candidate', type=Path, required=True)
    parser.add_argument('--validation', type=Path, required=True)
    parser.add_argument('--previous', type=Path,
                        default=ROOT/'dist/1.6.1/FanqieAdBlock-1.6.1.dylib')
    parser.add_argument('--previous-validation', type=Path,
                        default=ROOT/'verification/1.6.1/FanqieAdBlock-1.6.1.validation.json')
    parser.add_argument('--report', type=Path, required=True)
    args = parser.parse_args()
    data = args.candidate.read_bytes()
    validation = json.loads(args.validation.read_text())
    previous = args.previous.read_bytes()
    previous_validation = json.loads(args.previous_validation.read_text())
    digest = hashlib.sha256(data).hexdigest()
    require(validation['candidate_sha256'] == digest, 'Validation identifies exact candidate bytes')
    require(hashlib.sha256(previous).hexdigest() == PREVIOUS_SHA and
            previous_validation['candidate_sha256'] == PREVIOUS_SHA,
            'The old negative control is the frozen delivered 1.6.1')
    report = {'passed': False, 'candidate_sha256': digest, 'device_tested': False,
              'scope': 'Actual ARM64 hook/material ordering at modeled public UIKit/CA boundaries; no pixels or frame-duration claim',
              'cases': []}
    tests = [(hook[0], lambda hook=hook: hook_case(data, validation, hook)) for hook in HOOKS]
    tests += [
        ('read_return_ambient_animation', lambda: hook_case(data, validation, HOOKS[1], return_from_reader=True)),
        ('mount_synchronous_layout_reentry', lambda: hook_case(data, validation, HOOKS[3], reenter=True)),
        ('first_frame_aslr', lambda: hook_case(data, validation, HOOKS[0], slide=0x180000000)),
        ('initial_loading_and_reuse', lambda: lifecycle_cases(data, validation)),
        ('failed_resize_restores_previous_shape', lambda: failed_resize_rollback(data, validation)),
        ('missing_public_material_or_shape', lambda: unavailable_cases(data, validation)),
        ('negative_shipped_161_ordering', lambda: negative_previous(previous, previous_validation)),
    ]
    try:
        for name, test in tests:
            details = test()
            report['cases'].append({'name': name, 'passed': True, 'details': details})
            print('PASS', name)
        report['passed'] = True
    except Exception as error:
        report['error'] = str(error)
        report['traceback'] = traceback.format_exc()
        raise
    finally:
        report['executed_instructions'] = sum(cpu.steps for cpu, _ in RUNS)
        report['case_count'] = len(report['cases'])
        args.report.parent.mkdir(parents=True, exist_ok=True)
        args.report.write_text(json.dumps(report, ensure_ascii=False, indent=2) + '\n')


if __name__ == '__main__':
    main()
