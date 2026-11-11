"""Public UIKit boundaries for the top-bar blur and scroll geometry fixtures."""


class TopChromeRuntime:
    def __init__(self, *args, **kwargs):
        super().__init__(*args, **kwargs)
        if 'UIBlurEffect' not in self.classes:
            self._class('UIBlurEffect', 'NSObject')

    def handle(self, cpu, pc):
        if pc - self.slide == 0xa5d4:
            receiver, selector = cpu.x[:2]
            name = self.selector_names.get(selector)
            if receiver == self.classes['UIBlurEffect'] and name == 'effectWithStyle:':
                return self.finish(cpu, self.obj('UIBlurEffect', 'header blur', style=cpu.x[2]))
            if receiver in self.objects and self.is_kind(receiver, self.classes['UIScrollView']):
                state = self.objects[receiver].state
                if name in ('contentInset', 'adjustedContentInset'):
                    return self.finish(cpu, fp=state.get(name, state.get('contentInset', (0, 0, 0, 0))))
                if name == 'contentOffset':
                    return self.finish(cpu, fp=state.get('contentOffset', (0, 0)))
                if name == 'setContentInset:':
                    state['contentInset'] = tuple(cpu.fp(i) for i in range(4))
                    self.event(name, receiver)
                    return self.finish(cpu)
                if name == 'setContentOffset:':
                    state['contentOffset'] = tuple(cpu.fp(i) for i in range(2))
                    state['bounds'] = (*state['contentOffset'], *state['bounds'][2:])
                    self.event(name, receiver)
                    return self.finish(cpu)
        return super().handle(cpu, pc)
