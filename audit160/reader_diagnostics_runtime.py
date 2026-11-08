"""UIControl target/lifetime boundaries for reader diagnostic ARM64 tests.

The candidate supplies all scope, ownership, timing and record-building logic.
This model implements public target registration/dispatch and explicit weak
zeroing; it is not native UIKit, physical touch routing or an iPhone latency test.
"""
from arm64 import require
from reader_runtime import ReaderRuntime


class ReaderDiagnosticsRuntime(ReaderRuntime):
    OBSERVER = 'FQABReaderTouchObserver160'
    HOST_IMP = 0x33006000

    def __init__(self, *args, observer_alloc_nil=False, **kwargs):
        self.observer_counts = {}
        self.dead = set()
        self.association_policies = {}
        self.observer_alloc_nil = observer_alloc_nil
        self.host_callback = None
        self.observer_reenter = None
        super().__init__(*args, **kwargs)
        self._class('ReaderDiagnosticHostTarget', 'NSObject')
        self._add(self.classes['ReaderDiagnosticHostTarget'], 'hostAction:',
                  self.HOST_IMP, 'v24@0:8@16')
        self.host = self.obj('ReaderDiagnosticHostTarget', 'original_host_target')

    def assert_alive(self, value, context):
        require(value not in self.dead, context + ' must not message dead object')

    def hold(self, value):
        if value in self.observer_counts:
            self.assert_alive(value, 'retain')
            self.observer_counts[value] += 1

    def drop(self, value):
        if value not in self.observer_counts:
            return
        self.assert_alive(value, 'release')
        self.observer_counts[value] -= 1
        require(self.observer_counts[value] >= 0, 'Observer retain count stays nonnegative')
        if self.observer_counts[value] == 0:
            self.expire(value)

    def expire(self, value):
        """Explicit fixture deallocation, with zeroing weak NSHashTable slots."""
        self.assert_alive(value, 'deallocate')
        for obj in self.objects.values():
            if self.class_names[obj.cls] == 'NSHashTable':
                obj.state['items'] = [p for p in obj.state.get('items', []) if p != value]
        for key in [key for key in self.associations if key[0] == value]:
            old = self.associations.pop(key)
            policy = self.association_policies.pop(key, False)
            if policy:
                self.drop(old)
        self.dead.add(value)

    def targets(self, control):
        return self.objects[control].state.setdefault('control_targets', [])

    def add_host(self, control, events=64):
        row = (self.host, self.sel('hostAction:'), events)
        self.targets(control).append(row)
        return row

    def fire(self, cpu, control, event, *, observer_first=False):
        """Explicit target callback dispatch, never physical hit testing."""
        self.assert_alive(control, 'UIControl dispatch')
        rows = [row for row in self.targets(control) if row[2] & event]
        rows.sort(key=lambda row: (row[0] == self.host) == observer_first)
        for target, selector, mask in rows:
            # UIKit does not strongly own targets. Removed targets in this
            # dispatch fixture are skipped rather than messaged after removal.
            if (target, selector, mask) not in self.targets(control):
                continue
            self.assert_alive(target, 'target dispatch')
            cpu.run(0xa5d4, args=[target, selector, control])

    def handle(self, cpu, pc):
        self.current_cpu = cpu
        p = pc - self.slide
        a = cpu.x[:8]
        receiver = a[0]
        if p in (0xa628, 0xa634, 0xa664, 0xa5d4):
            self.assert_alive(receiver, 'Objective-C operation')
        if pc == self.HOST_IMP:
            require(a[1] == self.sel('hostAction:'), 'Host action receives its original selector')
            self.event('host_action', a[2], target=receiver)
            if self.host_callback:
                saved_lr = cpu.x[30]
                self.host_callback(cpu, a[2])
                cpu.x[30] = saved_lr
            return self.finish(cpu)
        if p == 0xa634:
            key = (receiver, a[1])
            old = self.associations.get(key, 0)
            old_policy = self.association_policies.get(key, False)
            retained = a[3] in (1, 3, 0x301, 0x303)
            if retained:
                self.hold(a[2])
            handled = super().handle(cpu, pc)
            if a[2]:
                self.association_policies[key] = retained
            else:
                self.association_policies.pop(key, None)
            if old_policy:
                self.drop(old)
            return handled
        if p != 0xa5d4 or not receiver:
            return super().handle(cpu, pc)
        name = self.selector_names.get(a[1])
        isclass = receiver in self.classes.values()
        if isclass and self.class_names[receiver] == self.OBSERVER and name == 'alloc':
            if self.observer_alloc_nil:
                return self.finish(cpu, 0)
            handled = super().handle(cpu, pc)
            if cpu.x[0]:
                self.observer_counts[cpu.x[0]] = 1
            return handled
        if not isclass and name in ('retain', 'release') and receiver in self.observer_counts:
            if name == 'retain':
                self.hold(receiver)
            handled = super().handle(cpu, pc)
            if name == 'release':
                self.drop(receiver)
            return handled
        if not isclass and name == 'addTarget:action:forControlEvents:':
            require(self.is_kind(receiver, self.classes['UIControl']), 'Only UIControl accepts targets')
            require(a[2] and a[3] and a[4], 'Observer registration is explicit')
            row = (a[2], a[3], a[4])
            if row not in self.targets(receiver):
                self.targets(receiver).append(row)
            self.event('add_target', receiver, target=a[2], selector=a[3], events=a[4])
            return self.finish(cpu)
        if not isclass and name == 'removeTarget:action:forControlEvents:':
            require(a[2] != 0, 'Detach cannot remove all targets')
            rows = []
            for target, selector, events in self.targets(receiver):
                if target == a[2] and (not a[3] or selector == a[3]):
                    events &= ~a[4]
                if events:
                    rows.append((target, selector, events))
            self.objects[receiver].state['control_targets'] = rows
            self.event('remove_target', receiver, target=a[2], selector=a[3], events=a[4])
            return self.finish(cpu)
        if not isclass and name == 'isEnabled':
            return self.finish(cpu, int(self.objects[receiver].state.get('enabled', True)))
        return super().handle(cpu, pc)
