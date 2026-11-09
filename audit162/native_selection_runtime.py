"""Public UIKit/Foundation boundaries for the native selection ARM64 audit.

The candidate implements all ownership, title choice, index mapping, rollback,
and callback decisions. This module supplies UISegmentedControl and target
dispatch, and a deliberately explicit weak-reference/lifetime fixture. It is
not UIKit rendering, physical touch recognition, or an iOS simulator.
"""
import struct

from arm64 import CPU, require
from interaction_runtime import Runtime as InteractionRuntime, read_entries


NAMES = ('update', 'restore', 'has_native', 'value_changed', 'control_key',
         'controller_key', 'buttons_key', 'items_key', 'hidden_rows_key',
         'bar_box_key', 'proxy_box_key', 'busy_key', 'window_box_key')


def native_entries(data):
    binary_version = struct.unpack_from('<I', data, 0x800 + 6 * 4)[0]
    layouts = {0x10601: (b'FQ161SEG', 0x10601), 0x10602: (b'FQ162SEG', 0x10602),
               0x10603: (b'FQ162SEG', 0x10602), 0x10604: (b'FQ162SEG', 0x10602), 0x10605: (b'FQ162SEG', 0x10602), 0x10606: (b'FQ162SEG', 0x10602), 0x10701: (b'FQ162SEG', 0x10602), 0x10702: (b'FQ162SEG', 0x10602)}
    require(binary_version in layouts, 'Known native selection binary')
    marker, layout_version = layouts[binary_version]
    require(data.count(marker) == 1, 'One immutable native selection directory')
    at = data.index(marker)
    version, count = struct.unpack_from('<2I', data, at + 8)
    require(version == layout_version and count == len(NAMES), 'Versioned native selection directory')
    values = struct.unpack_from('<' + str(count) + 'I', data, at + 16)
    result = dict(zip(NAMES, values))
    words = struct.unpack_from('<64I', data, 0x800)
    require(words[6] == binary_version, 'Native selection suite requires the pinned version')
    start, code_end, strings, end = [0x800 + words[i] for i in (60, 61, 62, 63)]
    for name in NAMES[:4]:
        require(start + 128 <= result[name] < code_end and result[name] % 4 == 0,
                'Aligned native selection code entry: ' + name)
    for name in NAMES[4:]:
        require(strings <= result[name] < end, 'Mapped native selection association key: ' + name)
    require(strings <= at < end, 'Native selection directory is constant data')
    return result


class Runtime(InteractionRuntime):
    CONTROLLER = 'FQABNativeSelection162'
    VALUE_CHANGED = 4096

    def __init__(self, data, entries, native, slide=0, *,
                 segment_alloc_nil=False, segment_init_nil=False,
                 controller_alloc_nil=False, weak_fail_at=0,
                 missing_segment_class=False, missing_constructor=False,
                 titles=None, **options):
        self.native_directory = native
        if struct.unpack_from('<I', data, 0x800 + 6 * 4)[0] == 0x10601:
            self.CONTROLLER = 'FQABNativeSelection161'
        self.segment_alloc_nil = segment_alloc_nil
        self.segment_init_nil = segment_init_nil
        self.controller_alloc_nil = controller_alloc_nil
        self.weak_fail_at = weak_fail_at
        self.weak_calls = 0
        self.messages = []
        self.send_actions_calls = 0
        self.controller_counts = {}
        self.dead = set()
        self.association_policies = {}
        self.reject_selection = False
        self.redirect_selection = None
        self.host_on_select = None
        super().__init__(data, entries, slide=slide, **options)
        if 'UIControl' not in self.classes:
            self._class('UIControl', 'UIView')
        self.parents[self.classes['UIButton']] = self.classes['UIControl']
        self._class('UISegmentedControl', 'UIControl')
        if not missing_constructor:
            self._add(self.classes['UISegmentedControl'], 'initWithItems:',
                      0x33007100, '@24@0:8@16')
        self._class('UITabBarItem', 'NSObject')
        if missing_segment_class:
            self.missing_classes.add('UISegmentedControl')
        values = titles if titles is not None else ('书城', '短剧', '书架', '我的')
        require(len(values) == len(self.buttons), 'Explicit host fixture has one title per button')
        selected = self.selected_index()
        self.items = [self.obj('UITabBarItem', 'host_item_' + str(i),
                               title=self.text_object(value) if value is not None else 0,
                               enabled=True) for i, value in enumerate(values)]
        self.items_array = self.obj('NSMutableArray', 'host_items', items=self.items.copy())
        self.objects[self.BAR].state.update(items=self.items_array,
                                            selectedItem=self.items[selected])
        for i, button in enumerate(self.buttons):
            self.objects[button].state.update(enabled=True, userInteractionEnabled=True,
                                              accessibilityElementsHidden=False,
                                              isAccessibilityElement=True,
                                              title=self.text_object('Host fallback ' + str(i)))
        self.objects[self.DEFAULTS].state['values']['FanqieAdBlock.GlassDisabled.1'] = 0

    def nkey(self, name):
        return self.slide + self.native_directory[name + '_key']

    def associated_native(self, owner, name):
        return self.associations.get((owner, self.nkey(name)), 0)

    def control(self):
        return self.associated_native(self.PROXY, 'control')

    def controller(self):
        return self.associated_native(self.PROXY, 'controller')

    def assert_alive(self, value, context):
        require(value not in self.dead, context + ' must not message a deallocated object')

    def hold(self, value):
        if value in self.controller_counts:
            self.assert_alive(value, 'retain')
            self.controller_counts[value] += 1

    def drop(self, value):
        if value not in self.controller_counts:
            return
        self.assert_alive(value, 'release')
        self.controller_counts[value] -= 1
        require(self.controller_counts[value] >= 0, 'Private controller retain count stays nonnegative')
        if self.controller_counts[value] == 0:
            self.expire(value)

    def expire(self, value):
        """Explicit owner death with zeroing NSHashTable weak entries."""
        self.assert_alive(value, 'deallocate')
        for obj in self.objects.values():
            if self.class_names[obj.cls] == 'NSHashTable':
                obj.state['items'] = [p for p in obj.state.get('items', []) if p != value]
        for key in [key for key in self.associations if key[0] == value]:
            previous = self.associations.pop(key)
            policy = self.association_policies.pop(key, False)
            if policy:
                self.drop(previous)
        self.dead.add(value)

    def strong_reachable(self, start, target):
        """Follow modeled strong edges; superview and UIControl targets are weak."""
        pending, visited = [start], set()
        while pending:
            pointer = pending.pop()
            if pointer == target:
                return True
            if pointer in visited or pointer not in self.objects:
                continue
            visited.add(pointer)
            for key, value in self.associations.items():
                if key[0] == pointer and self.association_policies.get(key, False):
                    pending.append(value)
            obj = self.objects[pointer]
            if self.is_kind(pointer, self.UIView):
                pending.extend(obj.state.get('subviews', []))
            if self.is_kind(pointer, self.classes['NSArray']):
                pending.extend(obj.state.get('items', []))
            # NSHashTable items deliberately do not create owning edges.
        return False

    def targets(self, control):
        return self.objects[control].state.setdefault('control_targets', [])

    def fire(self, cpu, control=None, index=None):
        """Deliver the explicit UIKit valueChanged boundary, not a physical drag."""
        control = self.control() if control is None else control
        self.assert_alive(control, 'native selection dispatch')
        require(control in self.objects, 'Native selection sender exists')
        if index is not None:
            self.objects[control].state['selectedSegmentIndex'] = index
        rows = [row for row in self.targets(control) if row[2] & self.VALUE_CHANGED]
        for target, selector, events in rows:
            if (target, selector, events) not in self.targets(control):
                continue
            self.assert_alive(target, 'native selection target')
            cpu.run(0xa5d4, args=[target, selector, control], max_steps=3000000)

    def responds(self, receiver, name):
        if receiver in self.objects:
            cls = self.class_names[self.objects[receiver].cls]
            if cls == 'UITabBarItem' and name in ('title', 'isEnabled'):
                return True
            if self.is_kind(receiver, self.classes['UIButton']) and name == 'titleForState:':
                return True
            if self.is_kind(receiver, self.classes.get('UIControl', self.UIView)) and name == 'isEnabled':
                return True
            if cls == 'UISegmentedControl' and name in (
                    'selectedSegmentIndex', 'setSelectedSegmentIndex:', 'numberOfSegments',
                    'setEnabled:forSegmentAtIndex:', 'isEnabledForSegmentAtIndex:'):
                return True
        return super().responds(receiver, name)

    def handle(self, cpu, pc):
        self.current_cpu = cpu
        local = pc - self.slide
        args = cpu.x[:8]
        receiver = args[0]
        if local == self.entries['main_repair']:
            # Real original click/sync instructions still execute. Only their
            # unrelated outer repair orchestration is scoped to this component.
            cpu.x[1] = self.associations.get((receiver, self.slide + 0xeb84), 0)
            cpu.pc = self.slide + self.native_directory['update']
            return True
        if local in (0xa628, 0xa634, 0xa664, 0xa5d4):
            self.assert_alive(receiver, 'Objective-C operation')
        if local == 0xa634:
            key = (receiver, args[1])
            previous = self.associations.get(key, 0)
            previous_policy = self.association_policies.get(key, False)
            retained = args[3] in (1, 3, 0x301, 0x303)
            if retained:
                self.hold(args[2])
            handled = super().handle(cpu, pc)
            if args[2]:
                self.association_policies[key] = retained
            else:
                self.association_policies.pop(key, None)
            if previous_policy:
                self.drop(previous)
            return handled
        if local != 0xa5d4 or not receiver:
            return super().handle(cpu, pc)
        name = self.selector_names.get(args[1])
        self.messages.append((receiver, name, tuple(args[2:5])))
        isclass = receiver in self.classes.values()
        if isclass:
            cls = self.class_names[receiver]
            if cls == 'NSHashTable' and name == 'weakObjectsHashTable':
                self.weak_calls += 1
                if self.weak_calls == self.weak_fail_at:
                    return self.finish(cpu, 0)
            if cls == self.CONTROLLER and name in ('alloc', 'new'):
                if self.controller_alloc_nil:
                    return self.finish(cpu, 0)
                handled = super().handle(cpu, pc)
                if cpu.x[0]:
                    self.controller_counts[cpu.x[0]] = 1
                return handled
            if cls == 'UISegmentedControl' and name in ('alloc', 'new'):
                if self.segment_alloc_nil:
                    return self.finish(cpu, 0)
                value = self.view('UISegmentedControl', 'native_segmented_control',
                                  enabled=True, userInteractionEnabled=True,
                                  segments=[], segment_enabled=[], selectedSegmentIndex=-1,
                                  momentary=False, control_targets=[])
                self.retain_balance[value] = 1
                self.event('native_alloc', value)
                return self.finish(cpu, value)
            return super().handle(cpu, pc)
        if name in ('retain', 'release') and receiver in self.controller_counts:
            if name == 'retain':
                self.hold(receiver)
            handled = super().handle(cpu, pc)
            if name == 'release':
                self.drop(receiver)
            return handled
        require(receiver in self.objects, 'Known public native selection receiver')
        state = self.objects[receiver].state
        cls = self.class_names[self.objects[receiver].cls]
        if name == 'anyObject':
            return self.finish(cpu, next(iter(state.get('items', [])), 0))
        if name == 'length':
            return self.finish(cpu, len(state['value']))
        if name == 'title':
            return self.finish(cpu, state.get('title', 0))
        if name == 'titleForState:':
            require(args[2] == 0, 'Fallback title uses the normal control state')
            return self.finish(cpu, state.get('title', 0))
        if name == 'isEnabled':
            return self.finish(cpu, int(state.get('enabled', True)))
        if name == 'isTracking':
            return self.finish(cpu, int(state.get('tracking', False)))
        if name == 'isUserInteractionEnabled':
            return self.finish(cpu, int(state.get('userInteractionEnabled', True)))
        if name in ('accessibilityElementsHidden', 'isAccessibilityElement'):
            return self.finish(cpu, int(state.get(name, name == 'isAccessibilityElement' and
                                                 self.is_kind(receiver, self.classes['UIButton']))))
        if name in ('setUserInteractionEnabled:', 'setAccessibilityElementsHidden:',
                    'setIsAccessibilityElement:'):
            key = {'setUserInteractionEnabled:': 'userInteractionEnabled',
                   'setAccessibilityElementsHidden:': 'accessibilityElementsHidden',
                   'setIsAccessibilityElement:': 'isAccessibilityElement'}[name]
            state[key] = bool(args[2])
            self.event('native_presentation_property', receiver, property=key,
                       value=bool(args[2]))
            return self.finish(cpu)
        if name == 'setEnabled:':
            state['enabled'] = bool(args[2])
            self.event('native_enabled', receiver, value=bool(args[2]))
            return self.finish(cpu)
        if name == 'addTarget:action:forControlEvents:':
            require(self.is_kind(receiver, self.classes['UIControl']), 'Only UIControl registers a target')
            require(args[2] and args[3] and args[4], 'Native selection target registration is explicit')
            row = (args[2], args[3], args[4])
            if row not in self.targets(receiver):
                self.targets(receiver).append(row)
            self.event('add_target', receiver, target=args[2], selector=args[3], events=args[4])
            return self.finish(cpu)
        if name == 'removeTarget:action:forControlEvents:':
            require(args[2] != 0, 'Native selection removal names its private target')
            rows = []
            for target, selector, events in self.targets(receiver):
                if target == args[2] and (not args[3] or selector == args[3]):
                    events &= ~args[4]
                if events:
                    rows.append((target, selector, events))
            state['control_targets'] = rows
            self.event('remove_target', receiver, target=args[2], selector=args[3], events=args[4])
            return self.finish(cpu)
        if name == 'sendActionsForControlEvents:':
            self.send_actions_calls += 1
            raise AssertionError('Programmatic native synchronization must not send UIControl actions')
        if name == 'setSelectIndex:':
            items = self.objects[state['items']].state['items']
            require(args[2] < len(items), 'Original route uses a valid current host index')
            self.route_calls.append(int(args[2]))
            if not self.reject_selection:
                actual = args[2] if self.redirect_selection is None else self.redirect_selection
                state['selectedItem'] = items[actual]
            self.event('original_selection_route', receiver, index=int(args[2]))
            if self.host_on_select:
                saved = (cpu.x.copy(), cpu.v.copy(), cpu.pc,
                         cpu.n, cpu.z, cpu.c, cpu.overflow)
                self.host_on_select(cpu, int(args[2]))
                cpu.x[:], cpu.v[:], cpu.pc, cpu.n, cpu.z, cpu.c, cpu.overflow = saved
            return self.finish(cpu)
        if cls == 'UISegmentedControl':
            if name == 'setSelectedSegmentTintColor:':
                require(args[2] and self.is_kind(args[2], self.classes['UIColor']),
                        'An explicit UIColor configures the native selected shade')
                state['selectedSegmentTintColor'] = args[2]
                self.event('native_selected_tint', receiver, value=args[2])
                return self.finish(cpu)
            if name == 'setTitleTextAttributes:forState:':
                require(args[2] and self.is_kind(args[2], self.classes['NSDictionary']),
                        'Native title attributes are a public dictionary')
                state.setdefault('titleTextAttributes', {})[args[3]] = dict(
                    self.objects[args[2]].state['items'])
                self.event('native_title_attributes', receiver, state=args[3],
                           values=dict(state['titleTextAttributes'][args[3]]))
                return self.finish(cpu)
            if name == 'initWithItems:':
                if self.segment_init_nil:
                    self.retain_balance[receiver] -= 1
                    return self.finish(cpu, 0)
                state['segments'] = list(self.objects[args[2]].state['items'])
                state['segment_enabled'] = [True] * len(state['segments'])
                return self.finish(cpu, receiver)
            if name == 'selectedSegmentIndex':
                return self.finish(cpu, state['selectedSegmentIndex'])
            if name == 'setSelectedSegmentIndex:':
                value = args[2] if args[2] < (1 << 63) else args[2] - (1 << 64)
                state['selectedSegmentIndex'] = value
                self.event('native_selected', receiver, value=value)
                # UIKit's programmatic setter does not emit valueChanged.
                return self.finish(cpu)
            if name == 'numberOfSegments':
                return self.finish(cpu, len(state['segments']))
            if name == 'titleForSegmentAtIndex:':
                return self.finish(cpu, state['segments'][args[2]])
            if name == 'setEnabled:forSegmentAtIndex:':
                require(args[3] < len(state['segments']), 'Native enabled segment index is in range')
                state['segment_enabled'][args[3]] = bool(args[2])
                self.event('native_segment_enabled', receiver, index=args[3], enabled=bool(args[2]))
                return self.finish(cpu)
            if name == 'isEnabledForSegmentAtIndex:':
                return self.finish(cpu, int(state['segment_enabled'][args[2]]))
            if name in ('setMomentary:', 'setApportionsSegmentWidthsByContent:'):
                key = 'momentary' if name == 'setMomentary:' else 'apportionsSegmentWidthsByContent'
                state[key] = bool(args[2])
                self.event('native_configuration', receiver, property=key, value=bool(args[2]))
                return self.finish(cpu)
        return super().handle(cpu, pc)


def make(data, *, slide=0, **options):
    entries = read_entries(data)
    native = native_entries(data)
    runtime = Runtime(data, entries, native, slide=slide, **options)
    cpu = CPU(data, runtime, slide=slide, ranges=[
        (0x900, entries['main_code_end']), (0x14080, entries['extension_code_end']),
        (0x4878, 0x48d0), (0x56c0, 0x5798), (0x60b8, 0x6274),
        (0x711c, 0x746c),
    ])
    cpu.pointers.update(runtime.rebase_pointers)
    return cpu, runtime, native
