"""Explicit native boundaries for the 1.5.8 wrapper/monitor instruction audit.

No repair helper is replaced by Python: Objective-C runtime, UIKit setters and
Foundation objects are modeled; the candidate's ARM64 performs the decisions.
The extra lifetime model tracks the monitor and timer's retained references,
zeroes weak tables on simulated owner death, and rejects messages to deallocated
tracked objects. It is deliberately not a complete Objective-C memory model.
"""
from arm64 import CPU, require
from legacy_runtime import Runtime as Base


class Runtime(Base):
    HIDDEN_IMP = 0x33000600
    WRAPPER_HIDDEN_IMP = 0x33000700
    FOREIGN_HIDDEN_IMP = 0x33000800
    WRAPPER = 'UIKit._UITabBarContainerWrapperView'
    LEGACY_WRAPPER = '_UITabBarContainerWrapperView'

    def __init__(self, *args, **kwargs):
        self.alive_counts = {}
        self.dead = set()
        self.association_policies = {}
        self.pending_timer_autoreleases = []
        self.expired_weak_owners = set()
        self.creation_counts = {}
        self.life_events = []
        super().__init__(*args, **kwargs)
        for name, parent in ((self.WRAPPER, 'UIView'),
                             (self.LEGACY_WRAPPER, 'UIView'),
                             ('UITabBar', 'UIView'),
                             ('UITransitionView', 'UIView'),
                             ('UIViewControllerWrapperView', 'UIView'),
                             ('UIWebView', 'UIView'),
                             ('WKWebView', 'UIView'),
                             ('UIHostContentView', 'UIView')):
            if name not in self.classes:
                self._class(name, parent)
        self.class_bundles[self.classes['SSTabBar']] = 'com.example.host'
        self.class_bundles[self.classes['UIHostContentView']] = 'com.example.host'
        self._add(self.UIView, 'setHidden:', self.HIDDEN_IMP, 'v20@0:8B16')

    def obj(self, cls, name, **state):
        self.creation_counts[cls] = self.creation_counts.get(cls, 0) + 1
        return super().obj(cls, name, **state)

    def assert_alive(self, pointer, why):
        require(pointer not in self.dead, why + ': deallocated ' + hex(pointer))

    def hold(self, pointer, why):
        if pointer not in self.alive_counts:
            return
        self.assert_alive(pointer, why)
        self.alive_counts[pointer] += 1
        self.life_events.append(('retain', pointer, why, self.alive_counts[pointer]))

    def drop(self, pointer, why):
        if pointer not in self.alive_counts:
            return
        self.assert_alive(pointer, why)
        self.alive_counts[pointer] -= 1
        count = self.alive_counts[pointer]
        require(count >= 0, 'Tracked reference count does not underflow')
        self.life_events.append(('release', pointer, why, count))
        if count == 0:
            self.dead.add(pointer)
            self.life_events.append(('dealloc', pointer, why, 0))
            self.zero_weak(pointer)
            for owner_key in [key for key in self.associations if key[0] == pointer]:
                value = self.associations.pop(owner_key)
                policy = self.association_policies.pop(owner_key, 0)
                if policy:
                    self.drop(value, 'owner association deallocated')

    def zero_weak(self, pointer):
        self.expired_weak_owners.add(pointer)
        for obj in self.objects.values():
            if self.class_names[obj.cls] == 'NSHashTable':
                obj.state['items'] = [p for p in obj.state.get('items', [])
                                      if p != pointer]

    def expire_bar(self, bar):
        """Remove the external owner without inventing a strong weak-table edge."""
        require(self.retain_balance.get(bar, 0) == 0,
                'No explicit repair retain keeps the owner alive')
        self.reparent(bar, 0)
        self.zero_weak(bar)
        for owner_key in [key for key in self.associations if key[0] == bar]:
            value = self.associations.pop(owner_key)
            policy = self.association_policies.pop(owner_key, 0)
            if policy:
                self.drop(value, 'bar deallocated')
        self.dead.add(bar)

    def drain_timer_autoreleases(self):
        for timer in self.pending_timer_autoreleases:
            self.drop(timer, 'modeled creation autorelease pool')
        self.pending_timer_autoreleases.clear()

    def wrapper(self, name='native_wrapper', *, hidden=False, frame=None,
                parent=None, legacy=False, own_override=False):
        cls = self.LEGACY_WRAPPER if legacy else self.WRAPPER
        if own_override:
            self._add(self.classes[cls], 'setHidden:', self.WRAPPER_HIDDEN_IMP,
                      'v20@0:8B16')
        frame = self.objects[self.BAR].state['frame'] if frame is None else frame
        parent = self.ROOT if parent is None else parent
        wrapper = self.view(cls, name, frame, parent, hidden=hidden)
        native_bar = self.view('UITabBar', name + '.tabbar',
                               (0, 0, frame[2], frame[3]), wrapper)
        self.view('UIView', name + '.decoration',
                  (0, 0, frame[2], frame[3]), native_bar)
        return wrapper

    def hidden_send(self, cpu, receiver, hidden):
        """Host call through real candidate-installed runtime dispatch."""
        return cpu.run(0xa5d4, receiver, self.sel('setHidden:'), int(hidden))

    def fire(self, cpu, timer):
        self.assert_alive(timer, 'timer fire')
        st = self.objects[timer].state
        require(st.get('valid', False), 'Only a valid scheduled timer fires')
        self.assert_alive(st['target'], 'timer target')
        return self.invoke(cpu, st['target'], st['selector'], timer)

    def handle(self, cpu, pc):
        self.current_cpu = cpu
        p = pc - self.slide
        args = cpu.x[:8]
        receiver = args[0]
        if p in (0xa628, 0xa634, 0xa664, 0xa5d4):
            self.assert_alive(receiver, 'Objective-C operation')
        if pc in (self.HIDDEN_IMP, self.WRAPPER_HIDDEN_IMP,
                  self.FOREIGN_HIDDEN_IMP):
            self.assert_alive(receiver, 'original setHidden:')
            require(args[1] == self.sel('setHidden:'),
                    'The saved IMP receives the original setHidden: selector')
            self.objects[receiver].state['hidden'] = bool(args[2])
            self.event('original_hidden', receiver, value=bool(args[2]),
                       selector=args[1], imp=pc)
            return self.finish(cpu)
        if p == 0xa634:
            key = (receiver, args[1])
            previous = self.associations.get(key, 0)
            previous_policy = self.association_policies.get(key, 0)
            # Retain the replacement first, including same-object assignment.
            retained = args[3] in (1, 3, 0x301, 0x303)
            if retained:
                self.hold(args[2], 'associated-object retain')
            handled = super().handle(cpu, pc)
            if args[2]:
                self.association_policies[key] = int(retained)
            else:
                self.association_policies.pop(key, None)
            if previous_policy:
                self.drop(previous, 'associated-object replacement')
            return handled
        if p != 0xa5d4 or not receiver:
            return super().handle(cpu, pc)
        name = self.selector_names.get(args[1])
        isclass = receiver in self.classes.values()
        if not isclass and name in ('retain', 'release') and receiver in self.alive_counts:
            if name == 'retain':
                self.hold(receiver, 'explicit retain')
            handled = super().handle(cpu, pc)
            if name == 'release':
                self.drop(receiver, 'explicit release')
            return handled
        if not isclass and name == 'invalidate' and receiver in self.alive_counts:
            st = self.objects[receiver].state
            if st.get('valid', False):
                st['valid'] = False
                self.event('invalidate', receiver)
                self.drop(st['target'], 'NSTimer invalidation releases target')
                self.drop(receiver, 'invalidated timer leaves run loop')
            return self.finish(cpu)
        if isclass and name == 'new' and self.class_names[receiver] == 'FQABGlassMonitor158':
            handled = super().handle(cpu, pc)
            if cpu.x[0]:
                self.alive_counts[cpu.x[0]] = 1
            return handled
        if (isclass and self.class_names[receiver] == 'NSTimer' and
                name == 'scheduledTimerWithTimeInterval:target:selector:userInfo:repeats:'):
            handled = super().handle(cpu, pc)
            timer = cpu.x[0]
            if timer:
                self.alive_counts[timer] = 2  # autoreleased return + run-loop ownership
                self.pending_timer_autoreleases.append(timer)
                self.objects[timer].state['valid'] = True
                self.hold(args[2], 'NSTimer retains target')
            return handled
        return super().handle(cpu, pc)


def make(data, entries, *, slide=0):
    runtime = Runtime(data, slide)
    cpu = CPU(data, runtime, slide, ranges=[
        (0x900, entries['Lcode_end']), (0x14080, entries['LXcode_end']),
        (0x4338, 0x43fc), (0x4704, 0x48d0), (0x4958, 0x4d78),
        (0x5168, 0x5204), (0x5688, 0x56c0), (0x5b94, 0x5c24),
        (0x60b8, 0x62ac), (0x6c14, 0x6c4c), (0x6db4, 0x702c),
        (0x711c, 0x746c),
    ])
    cpu.pointers.update(runtime.rebase_pointers)
    return cpu, runtime
