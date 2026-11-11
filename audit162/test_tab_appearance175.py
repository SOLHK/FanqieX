"""Execute the complete floating-bar repair against explicit page/color APIs.

The host background resolver and UIKit traits are modeled boundaries. Actual
candidate ARM64 decides appearance, foreground, material ownership and updates.
This does not render UIKit pixels or claim iPhone visual acceptance.
"""
import argparse
import hashlib
import json
from pathlib import Path

from arm64 import require
from test_feed_viewport import labels_for
from test_native_orchestration162 import Runtime as Base, make, repair, effect_writes


class Runtime(Base):
    BACKGROUND = 0x330d0000

    def __init__(self, *args, **options):
        super().__init__(*args, **options)
        if 'SSTabBarController' not in self.classes:
            self._class('SSTabBarController', 'UIViewController')
        self._add(self.classes['SSTabBarController'], 'bottomTabBackgroundColorWithTabModel:',
                  self.BACKGROUND, '@24@0:8@16')
        self.page = self.obj('UIViewController', 'selected page', currentTabModel=0)
        self.owner = self.obj('SSTabBarController', 'tab owner', selectedViewController=self.page)
        self.objects[self.BAR].state['delegate'] = self.owner
        self.background = self.fresh_color((0, 0, 0, 1))
        self.style_writes = []
        self.ink_writes = []
        self.model_reads = []
        self.appearance_records = []
        self.labels = {}
        for button in self.buttons:
            self.objects[button].state.update(titleColors={}, tintColor=self.color('stockInk'))

    def responds(self, receiver, name):
        if receiver in self.objects:
            if self.is_kind(receiver, self.UIView) and name == 'traitCollection':
                return True
            if self.is_kind(receiver, self.classes['UIColor']) and name in (
                    'resolvedColorWithTraitCollection:', 'description'):
                return True
        return super().responds(receiver, name)

    def handle(self, cpu, pc):
        local = pc - self.slide
        if local == 0xa5ec:
            super().handle(cpu, pc)
            for offset, byte in enumerate(self.string(cpu.x[0]).encode() + b'\0'):
                cpu.memory[cpu.x[0] + offset] = byte
            return True
        if local == self.labels.get('Lrecord_named'):
            self.appearance_records.append((self.string(cpu.x[0]), self.native(cpu.x[1])))
            return self.finish(cpu)
        if pc == self.BACKGROUND:
            self.model_reads.append(cpu.x[2])
            return self.finish(cpu, self.background)
        if local == 0xa5d4 and cpu.x[0] in self.objects:
            receiver = cpu.x[0]
            name = self.selector_names.get(cpu.x[1])
            state = self.objects[receiver].state
            if name in ('delegate', 'selectedViewController', 'currentTabModel', 'bookStoreTabContext',
                        'containerProvider', 'currentCategoryTabModel', 'tintColor', 'overrideUserInterfaceStyle'):
                return self.finish(cpu, state.get(name, 0))
            if name == 'setOverrideUserInterfaceStyle:':
                state['overrideUserInterfaceStyle'] = cpu.x[2]
                self.style_writes.append((receiver, cpu.x[2]))
                return self.finish(cpu)
            if name == 'titleColorForState:':
                return self.finish(cpu, state.get('titleColors', {}).get(cpu.x[2], 0))
            if name == 'setTitleColor:forState:':
                state.setdefault('titleColors', {})[cpu.x[3]] = cpu.x[2]
                self.ink_writes.append((receiver, cpu.x[3], cpu.x[2]))
                return self.finish(cpu)
            if name == 'description' and self.is_kind(receiver, self.classes['UIColor']):
                return self.finish(cpu, self.text_object(str(self.semantic_rgba(receiver))))
            if name == 'isEqual:' and self.is_kind(receiver, self.classes['UIColor']):
                return self.finish(cpu, int(receiver == cpu.x[2]))
        return super().handle(cpu, pc)


def fixture(data, labels, slide=0):
    cpu, runtime, entries = make(data, slide=slide, runtime_class=Runtime)
    runtime.labels = labels
    return cpu, runtime, entries


def exercise(data, labels, slide):
    cpu, runtime, entries = fixture(data, labels, slide)
    frames = {view: runtime.objects[view].state['frame'] for view in
              (runtime.WINDOW, runtime.ROOT, runtime.SCROLL, runtime.BAR, runtime.PROXY)}
    repair(cpu, runtime, entries)
    require(runtime.objects[runtime.PROXY].state['overrideUserInterfaceStyle'] == 2,
            'A black drama page makes the real mounted glass dark in a light system')
    effect = runtime.objects[runtime.PROXY].state['effect']
    control = runtime.control()
    require(effect and control and runtime.objects[effect].state['style'] == 0,
            'Dark appearance retains the same Regular native glass and selection control')
    require(runtime.objects[runtime.PROXY].state['backgroundColor'] == runtime.color('clearColor'),
            'Appearance does not add an opaque mask behind the glass')
    for button in runtime.buttons:
        state = runtime.objects[button].state
        require(state['tintColor'] == runtime.color('labelColor') and
                state['titleColors'] == {i: runtime.color('labelColor') for i in range(8)},
                'Visible buttons use semantic foreground in every selected/highlighted/disabled state')
    writes = (len(runtime.style_writes), len(runtime.ink_writes), len(effect_writes(runtime)))
    for _ in range(8):
        repair(cpu, runtime, entries)
    require(writes == (len(runtime.style_writes), len(runtime.ink_writes), len(effect_writes(runtime))),
            'Settled repairs do not churn style, ink or glass')

    # The host resolver is authoritative for the selected tab/subtab, so an
    # unchanged system style can coexist with either a light or a dark page.
    model = runtime.obj('NSObject', 'selected bookstore subtab')
    runtime.objects[runtime.page].state['currentTabModel'] = model
    for rgba, expected in [((1, 1, 1, 1), 1), ((0.1, 0.14, 0.2, 1), 2), ((0.97, 0.97, 0.97, 1), 1)]:
        runtime.background = runtime.fresh_color(rgba)
        repair(cpu, runtime, entries)
        require(runtime.objects[runtime.PROXY].state['overrideUserInterfaceStyle'] == expected,
                'Page switches refresh the local material appearance')
        require(runtime.model_reads[-1] == model, 'Current subtab model reaches the host resolver')
    runtime.objects[runtime.BAR].state['userInterfaceStyle'] = 2
    runtime.background = runtime.fresh_color(dynamic={1: (1, 1, 1, 1), 2: (0, 0, 0, 1)})
    repair(cpu, runtime, entries)
    require(runtime.objects[runtime.PROXY].state['overrideUserInterfaceStyle'] == 2,
            'Dynamic page colors resolve in host traits, not the previously forced capsule traits')
    runtime.objects[runtime.BAR].state['userInterfaceStyle'] = 1
    repair(cpu, runtime, entries)
    require(runtime.objects[runtime.PROXY].state['overrideUserInterfaceStyle'] == 1,
            'System returning to light updates a dynamic light page')
    runtime.background = runtime.fresh_color((0.05, 0.05, 0.05, 1), conversion='gray')
    repair(cpu, runtime, entries)
    require(runtime.objects[runtime.PROXY].state['overrideUserInterfaceStyle'] == 2,
            'Grayscale black backgrounds also select dark glass')
    runtime.background = runtime.fresh_color((0, 0, 0, 0))
    repair(cpu, runtime, entries)
    require(runtime.objects[runtime.PROXY].state['overrideUserInterfaceStyle'] == 0,
            'A transparent background leaves the capsule inheriting the host appearance')

    # A subsequent host sync may write explicit ink; the next repair fixes the
    # visible buttons, even though the selected scene has not changed.
    runtime.objects[runtime.buttons[0]].state['titleColors'][4] = runtime.color('lateBlackInk')
    repair(cpu, runtime, entries)
    require(runtime.objects[runtime.buttons[0]].state['titleColors'][4] == runtime.color('labelColor'),
            'Late selected-state ink is repaired')
    require(all(view == runtime.PROXY for view, _ in runtime.style_writes),
            'Window, page, reader and global app appearance are never overridden')
    require(all(runtime.objects[view].state['frame'] == frame for view, frame in frames.items()),
            'Appearance changes preserve the accepted video, control and dock geometry')
    require(runtime.objects[runtime.PROXY].state['effect'] == effect and runtime.control() == control,
            'Light/dark switches reuse the existing effect and input surface')
    runtime.fire(cpu, index=0)
    require(runtime.route_calls == [0], 'Native selection still navigates once')
    return {'slide': hex(slide), 'local_style_sequence': [value for _, value in runtime.style_writes],
            'material_writes': len(effect_writes(runtime)), 'geometry_unchanged': True,
            'global_appearance_untouched': True, 'late_ink_repaired': True}


def main():
    parser = argparse.ArgumentParser(description=__doc__)
    parser.add_argument('candidate', type=Path)
    parser.add_argument('--previous', type=Path)
    parser.add_argument('--report', type=Path, required=True)
    args = parser.parse_args()
    data = args.candidate.read_bytes()
    labels = labels_for(data, args.candidate.with_suffix('.composed.s'), ['Lrecord_named'])
    rows = [exercise(data, labels, slide) for slide in (0, 0x180000000)]
    previous = None
    if args.previous:
        old = args.previous.read_bytes()
        old_labels = labels_for(old, args.previous.with_suffix('.composed.s'), ['Lrecord_named'])
        cpu, runtime, entries = fixture(old, old_labels)
        repair(cpu, runtime, entries)
        require(runtime.objects[runtime.PROXY].state.get('overrideUserInterfaceStyle', 0) == 0,
                'Previous R7 reproduces system-light glass on the same black page')
        previous = {'sha256': hashlib.sha256(old).hexdigest(), 'light_system_on_dark_page_reproduced': True}
    report = {'passed': True, 'sha256': hashlib.sha256(data).hexdigest(), 'cases': rows,
              'previous': previous, 'device_tested': False, 'pixel_rendering_tested': False}
    args.report.write_text(json.dumps(report, indent=2) + '\n')
    print(json.dumps(report, indent=2))


if __name__ == '__main__':
    main()
