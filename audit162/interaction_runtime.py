"""UIKit boundary model for the emitted 1.5.8 interaction instructions.

This supplies native object/gesture calls, not the gesture state machine.
The original _home_tab_pressed and _sync_home_selection instructions execute;
their outer Lrepair call is scoped to the actual LIupdate entry so this module
audit does not silently claim coverage of the other repair components.
"""
import struct

from arm64 import CPU, require
from mock_foundation import Runtime as FoundationRuntime


KEY_NAMES = ('overlay', 'lens', 'controller', 'pan', 'drag', 'start_item',
             'offset', 'owned_buttons')


def read_entries(data):
    words = struct.unpack_from('<64I', data, 0x800)
    versions = {0x10508:b'FQ158EXT', 0x10600:b'FQ160EXT', 0x10601:b'FQ161EXT',
                0x10602:b'FQ162EXT', 0x10603:b'FQ162EXT', 0x10604:b'FQ162EXT', 0x10605:b'FQ162EXT', 0x10606:b'FQ162EXT', 0x10609:b'FQ162EXT'}
    require(words[6] in versions, 'Interaction audit requires a known version')
    extension = 0x800 + words[60]
    require(data[extension:extension+8] == versions[words[6]], 'Known extension directory')
    pointers = struct.unpack_from('<28I', data, extension+16)
    entries = dict(zip(('update', 'restore', 'pan', 'should_begin'),
                       [0x800+pointers[i] for i in (9, 10, 11, 12)]))
    entries['main_repair'] = 0x800 + words[3]
    entries['main_code_end'] = 0x800 + words[55]
    entries['extension_code_end'] = 0x800 + pointers[15]
    marker = b'FQ158INT'
    require(data.count(marker) == 1, 'Exactly one immutable interaction key directory')
    at = data.index(marker)
    entries['keys'] = dict(zip(KEY_NAMES, struct.unpack_from('<8I', data, at+8)))
    require(all(extension <= p < len(data) for p in entries['keys'].values()),
            'Interaction keys are in the mapped extension')
    return entries


class Runtime(FoundationRuntime):
    def __init__(self, data, entries, slide=0, rtl=False, selected=2, **options):
        self.entries = entries
        self.route_calls = []
        self.cancel_callbacks = 0
        self.fail_alloc = set()
        self.synchronous_cancel = True
        super().__init__(data, slide=slide, **options)
        self._class('UIGestureRecognizer', 'NSObject')
        self._class('UIPanGestureRecognizer', 'UIGestureRecognizer')
        for p, frame in ((self.WINDOW, (0, 0, 440, 956)),
                         (self.ROOT, (0, 0, 440, 956)),
                         (self.BAR, (0, 882, 440, 74)),
                         (self.PROXY, (12, 0, 416, 56)),
                         (self.PROXY_CONTENT, (0, 0, 416, 56))):
            self.objects[p].state.update(frame=frame, bounds=(0, 0, *frame[2:]))
        self.buttons = [self.BUTTON] + [self.view('UIButton', 'tab_'+str(i),
                                                parent=self.PROXY_CONTENT)
                                        for i in range(1, 4)]
        self.items = [self.SELECTED] + [self.obj('NSObject', 'item_'+str(i))
                                       for i in range(1, 4)]
        for i, button in enumerate(self.buttons):
            frame = (4 + 102*(3-i if rtl else i), 4, 102, 48)
            self.objects[button].state.update(frame=frame, bounds=(0, 0, 102, 48),
                selected=(i == selected), accessibilityLabel='tab-'+str(i),
                originalTarget=self.BAR, originalAction='fqab_homeTabPressed:')
        self.buttons_array = self.obj('NSMutableArray', 'original_buttons', items=self.buttons.copy())
        self.associations[(self.PROXY, slide+0xeb85)] = self.buttons_array
        self.objects[self.BAR].state.update(
            items=self.obj('NSArray', 'items', items=self.items.copy()),
            selectedItem=self.items[selected])

    def key(self, name):
        return self.slide + self.entries['keys'][name]

    def associated(self, receiver, name):
        return self.associations.get((receiver, self.key(name)), 0)

    def selected_index(self):
        return self.items.index(self.objects[self.BAR].state['selectedItem'])

    def callback(self, cpu, pan):
        state = self.objects[pan].state
        target, action = state.get('target', 0), state.get('action', 0)
        if not target or not action:
            return
        old_x, old_v, old_pc = cpu.x.copy(), cpu.v.copy(), cpu.pc
        self.invoke(cpu, target, action, pan)
        cpu.x[:], cpu.v[:], cpu.pc = old_x, old_v, old_pc

    def handle(self, cpu, pc):
        self.current_cpu = cpu
        p = pc-self.slide
        a = cpu.x[:8]
        if p == self.entries['main_repair']:
            # The caller still executes the real original selection/sync path.
            # Other repair features are outside this dedicated gesture audit.
            cpu.x[1] = self.associations.get((a[0], self.slide+0xeb84), 0)
            cpu.pc = self.slide+self.entries['update']
            return True
        if p != 0xa5d4:
            return super().handle(cpu, pc)
        receiver, selector = a[:2]
        name = self.selector_names.get(selector)
        if not receiver:
            return super().handle(cpu, pc)
        if receiver in self.classes.values():
            cls = self.class_names[receiver]
            if name in ('alloc', 'new') and cls in self.fail_alloc:
                return self.finish(cpu)
            if name in ('alloc', 'new') and cls in ('UIView', 'UIVisualEffectView'):
                obj = self.view(cls, 'owned_'+cls)
                self.retain_balance[obj] = 1
                if cls == 'UIVisualEffectView':
                    child = self.view('UIView', 'owned_effect_content', parent=obj)
                    self.objects[obj].state.update(contentView=child, effect=0)
                self.event(name, obj)
                return self.finish(cpu, obj)
            return super().handle(cpu, pc)
        if receiver not in self.objects:
            return super().handle(cpu, pc)
        st = self.objects[receiver].state
        if name == 'initWithEffect:':
            st['effect'] = a[2]
            return self.finish(cpu, receiver)
        if name in ('setUserInteractionEnabled:', 'setAccessibilityElementsHidden:'):
            st[{'setUserInteractionEnabled:': 'userInteractionEnabled',
                'setAccessibilityElementsHidden:': 'accessibilityElementsHidden'}[name]] = bool(a[2])
            return self.finish(cpu)
        if name == 'setBounds:':
            st['bounds'] = tuple(cpu.fp(i) for i in range(4))
            self.event('setBounds', receiver, value=st['bounds'])
            return self.finish(cpu)
        if name == 'removeFromSuperview':
            self.reparent(receiver, 0)
            self.event('removeFromSuperview', receiver)
            return self.finish(cpu)
        if name == 'initWithTarget:action:':
            require(a[2] in self.objects and a[3] in self.selector_names,
                    'Gesture target/action have correct Objective-C ABI')
            st.update(target=a[2], action=a[3], view=0, state=0, delegate=0,
                      enabled=True, numberOfTouches=1, velocity=(100, 0), location=(259, 28))
            return self.finish(cpu, receiver)
        setters = {'setDelegate:': 'delegate', 'setMinimumNumberOfTouches:': 'minimumTouches',
                   'setMaximumNumberOfTouches:': 'maximumTouches',
                   'setCancelsTouchesInView:': 'cancelsTouchesInView',
                   'setDelaysTouchesBegan:': 'delaysTouchesBegan',
                   'setDelaysTouchesEnded:': 'delaysTouchesEnded'}
        if name in setters:
            st[setters[name]] = a[2]
            return self.finish(cpu)
        if name == 'setEnabled:':
            st['enabled'] = bool(a[2])
            self.event('setEnabled', receiver, value=bool(a[2]))
            if not a[2] and st.get('state') in (1, 2):
                st['state'] = 4
                if self.synchronous_cancel:
                    self.cancel_callbacks += 1
                    self.callback(cpu, receiver)
            return self.finish(cpu)
        if name == 'addGestureRecognizer:':
            st.setdefault('gestures', []).append(a[2])
            self.objects[a[2]].state['view'] = receiver
            return self.finish(cpu)
        if name == 'removeGestureRecognizer:':
            if a[2] in st.setdefault('gestures', []):
                st['gestures'].remove(a[2])
            self.objects[a[2]].state['view'] = 0
            return self.finish(cpu)
        if name in ('view', 'state', 'numberOfTouches'):
            return self.finish(cpu, st.get(name, 0))
        if name in ('velocityInView:', 'locationInView:'):
            return self.finish(cpu, fp=st['velocity' if name == 'velocityInView:' else 'location'])
        if name == 'setSelectIndex:':
            items = self.objects[st['items']].state['items']
            require(a[2] < len(items), 'Original selection route uses a valid actual index')
            st['selectedItem'] = items[a[2]]
            self.route_calls.append(int(a[2]))
            self.event('original_selection_route', receiver, index=int(a[2]))
            return self.finish(cpu)
        return super().handle(cpu, pc)


def make(data, slide=0, **options):
    entries = read_entries(data)
    rt = Runtime(data, entries, slide=slide, **options)
    cpu = CPU(data, rt, slide=slide, ranges=[
        (0x900, entries['main_code_end']),
        (0x14080, entries['extension_code_end']),
        (0x56c0, 0x5798), (0x60b8, 0x6274), (0x711c, 0x746c)])
    cpu.pointers.update(rt.rebase_pointers)
    return cpu, rt, entries
