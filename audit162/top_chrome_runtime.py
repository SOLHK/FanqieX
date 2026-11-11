"""Public UIKit boundaries for the top-bar blur and scroll geometry fixtures."""


class TopChromeRuntime:
    def __init__(self, *args, **kwargs):
        super().__init__(*args, **kwargs)
        if 'UIBlurEffect' not in self.classes:
            self._class('UIBlurEffect', 'NSObject')

    def enable_native_top_edge(self, scroll, hidden=True):
        style_class = self._class('UIScrollEdgeEffectStyle', 'NSObject')
        self._class('UIScrollEdgeElementContainerInteraction', 'NSObject')
        self.top_edge_soft = self.obj('UIScrollEdgeEffectStyle', 'soft edge style')
        self.top_edge_stock = self.obj('UIScrollEdgeEffectStyle', 'stock edge style')
        effect = self.obj('UIScrollEdgeEffect', 'top edge', style=self.top_edge_stock, hidden=hidden)
        self.objects[scroll].state['topEdgeEffect'] = effect
        self._add(self.metaclasses[style_class], 'softStyle', self.LAYOUT_IMP, '@16@0:8')
        self._add(self.classes['UIView'], 'addInteraction:', self.LAYOUT_IMP, 'v24@0:8@16')
        self._add(self.classes['UIScrollEdgeEffect'], 'setStyle:', self.LAYOUT_IMP, 'v24@0:8@16')
        return effect

    def handle(self, cpu, pc):
        if pc - self.slide == 0xa5d4:
            receiver, selector = cpu.x[:2]
            name = self.selector_names.get(selector)
            if receiver == self.classes['UIBlurEffect'] and name == 'effectWithStyle:':
                return self.finish(cpu, self.obj('UIBlurEffect', 'header blur', style=cpu.x[2]))
            if receiver == self.classes.get('UIScrollEdgeEffectStyle') and name == 'softStyle':
                return self.finish(cpu, self.top_edge_soft)
            interaction_class = self.classes.get('UIScrollEdgeElementContainerInteraction')
            if receiver == interaction_class and name == 'alloc':
                return self.finish(cpu, self.obj('UIScrollEdgeElementContainerInteraction', 'top interaction',
                                                 scrollView=0))
            if receiver in self.objects:
                view = self.objects[receiver]
                state = view.state
                if view.cls == interaction_class:
                    if name == 'init':
                        return self.finish(cpu, receiver)
                    if name == 'setScrollView:':
                        state['scrollView'] = cpu.x[2]
                        return self.finish(cpu)
                    if name == 'setEdge:':
                        state['edge'] = cpu.x[2]
                        return self.finish(cpu)
                    if name == 'scrollView':
                        return self.finish(cpu, state['scrollView'])
                if name in ('addInteraction:', 'removeInteraction:'):
                    interactions = state.setdefault('interactions', [])
                    if name == 'addInteraction:':
                        interactions.append(cpu.x[2])
                    else:
                        interactions.remove(cpu.x[2])
                    return self.finish(cpu)
                if view.cls == self.classes['UIScrollEdgeEffect']:
                    if name == 'style':
                        return self.finish(cpu, state.get('style', 0))
                    if name == 'setStyle:':
                        state['style'] = cpu.x[2]
                        return self.finish(cpu)
            if receiver in self.objects and self.is_kind(receiver, self.classes['UIScrollView']):
                state = self.objects[receiver].state
                if name == 'topEdgeEffect':
                    return self.finish(cpu, state.get('topEdgeEffect', 0))
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
