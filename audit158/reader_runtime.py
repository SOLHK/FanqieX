"""Extra public UIKit fixtures for the 1.5.8 reader ARM64 execution audit.

This is an Objective-C boundary model, not UIKit or a device latency test.
The production instructions still compute all geometry, ownership, budgets,
branching, reentrancy guards, and mutation decisions.
"""
from arm64 import require
from geometry_runtime import GeometryRuntime


class ReaderRuntime(GeometryRuntime):
    def __init__(self, *args, symbol_available=False, symbol_nil=False, **kwargs):
        super().__init__(*args, **kwargs)
        self._class('NSValue', 'NSObject')
        self._class('UIImageSymbolConfiguration', 'NSObject')
        for name, parent in [('UISwitch', 'UIControl'), ('UISlider', 'UIControl'),
                             ('UITextField', 'UIControl'),
                             ('UISegmentedControl', 'UIControl')]:
            if name not in self.classes:
                self._class(name, parent)
        self.symbol_available = symbol_available
        self.symbol_nil = symbol_nil
        self.symbol_requests = 0
        self.objects[self.DEFAULTS].state['values']['FanqieAdBlock.GlassDisabled.1'] = 0
        self.uptime = 1000.0

    def responds(self, receiver, name):
        if receiver in self.objects:
            state = self.objects[receiver].state
            if name == 'alignmentRectInsets':
                return 'alignmentRectInsets' in state
        return super().responds(receiver, name)

    def handle(self, cpu, pc):
        self.current_cpu = cpu
        if pc - self.slide != 0xa5d4:
            return super().handle(cpu, pc)
        receiver, selector = cpu.x[:2]
        name = self.selector_names.get(selector)
        if not receiver:
            return super().handle(cpu, pc)
        if receiver in self.classes.values():
            cls = self.class_names[receiver]
            if cls == 'NSValue' and name == 'valueWithCGSize:':
                value = self.obj(cls, 'size_snapshot', size=(cpu.fp(0), cpu.fp(1)))
                return self.finish(cpu, value)
            if cls in ('UIImage', 'UIImageSymbolConfiguration') and name == 'respondsToSelector:':
                query = self.selector_names[cpu.x[2]]
                if query in ('systemImageNamed:withConfiguration:', 'configurationWithPointSize:'):
                    return self.finish(cpu, int(self.symbol_available))
            if cls == 'UIImageSymbolConfiguration' and name == 'configurationWithPointSize:':
                require(20 <= cpu.fp(0) <= 24, 'Public symbol point size is bounded to 20..24')
                return self.finish(cpu, self.obj(cls, 'symbol_configuration', pointSize=cpu.fp(0)))
            if cls == 'UIImage' and name == 'systemImageNamed:withConfiguration:':
                require(self.symbol_available, 'Missing symbol factory must be guarded')
                require(self.string_value(cpu.x[2]) == 'chevron.backward',
                        'Only a known directional back symbol is requested')
                self.symbol_requests += 1
                require(cpu.x[3] in self.objects, 'Explicit native symbol configuration is supplied')
                height = self.objects[cpu.x[3]].state['pointSize']
                value = 0 if self.symbol_nil else self.obj(
                    cls, 'native_chevron_backward', size=(height*0.6, height),
                    alignmentRectInsets=(0.0, 0.0, 0.0, 0.0))
                return self.finish(cpu, value)
            return super().handle(cpu, pc)
        require(receiver in self.objects, 'Known reader boundary receiver')
        obj = self.objects[receiver]
        state = obj.state
        cls = self.class_names[obj.cls]
        if cls == 'NSProcessInfo' and name == 'systemUptime':
            return self.finish(cpu, fp=(self.uptime,))
        if name == 'CGSizeValue':
            require(cls == 'NSValue', 'CGSizeValue receiver is NSValue')
            return self.finish(cpu, fp=state['size'])
        if name == 'alignmentRectInsets':
            return self.finish(cpu, fp=state['alignmentRectInsets'])
        if name == 'anyObject':
            require(cls == 'NSHashTable', 'Weak ownership lookup is NSHashTable')
            return self.finish(cpu, next(iter(state['items']), 0))
        if name == 'unsignedIntegerValue':
            require(cls == 'NSNumber', 'Integer snapshot is NSNumber')
            return self.finish(cpu, int(state['value']))
        if name == 'setImage:':
            state['image'] = cpu.x[2]
            self.event(name, receiver, image=cpu.x[2])
            return self.finish(cpu)
        if name == 'setContentMode:':
            state['contentMode'] = cpu.x[2]
            self.event(name, receiver, mode=cpu.x[2])
            return self.finish(cpu)
        if name == 'bgView':
            return self.finish(cpu, state.get(name, 0))
        return super().handle(cpu, pc)
