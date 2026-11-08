"""Reusable public UIControl target boundaries; no repair logic is modeled."""
from arm64 import require


class ControlTargetsBoundary:
    def targets(self, control):
        return self.objects[control].state.setdefault('control_targets', [])

    def handle(self, cpu, pc):
        if pc - self.slide != 0xa5d4 or not cpu.x[0]:
            return super().handle(cpu, pc)
        receiver, selector, target, action, events = cpu.x[:5]
        name = self.selector_names.get(selector)
        if receiver in self.classes.values():
            return super().handle(cpu, pc)
        if name == 'isEnabled':
            return self.finish(cpu, int(self.objects[receiver].state.get('enabled', True)))
        if name == 'addTarget:action:forControlEvents:':
            require(self.is_kind(receiver, self.classes['UIControl']), 'UIControl target receiver')
            require(target and action and events, 'Explicit diagnostic target registration')
            row = (target, action, events)
            if row not in self.targets(receiver):
                self.targets(receiver).append(row)
            self.event('add_target', receiver, target=target, selector=action, events=events)
            return self.finish(cpu)
        if name == 'removeTarget:action:forControlEvents:':
            require(target != 0, 'Diagnostic removal always names its own target')
            rows = []
            for previous_target, previous_action, previous_events in self.targets(receiver):
                if previous_target == target and (not action or previous_action == action):
                    previous_events &= ~events
                if previous_events:
                    rows.append((previous_target, previous_action, previous_events))
            self.objects[receiver].state['control_targets'] = rows
            self.event('remove_target', receiver, target=target, selector=action, events=events)
            return self.finish(cpu)
        return super().handle(cpu, pc)
