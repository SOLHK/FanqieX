"""Public UIKit boundary fixtures for executing control_geometry ARM64 bytes.

This extends, but does not alter, the previous audit runtime. It supplies view,
image and font measurements as fixtures. All scope selection, rectangle unions,
padding, clipping decisions, material reuse and fallback branches execute from
the candidate. It does not emulate UIKit pixels or Core Animation timing.
"""
from arm64 import require
from mock_foundation import Runtime as FoundationRuntime


class GeometryRuntime(FoundationRuntime):
    def __init__(self, data, slide=0, **options):
        super().__init__(data, slide, **options)
        self._class('UIControl', 'UIView')
        self.parents[self.classes['UIButton']] = self.classes['UIControl']
        for name, parent in (
            ('UIImageView', 'UIView'), ('UIImage', 'NSObject'), ('UIFont', 'NSObject'),
            ('FQReaderSaasNavigationView', 'UIView'),
            ('SSStoryBigNavigationBar', 'UIView'),
            ('SSStorySmallNavigationBar', 'UIView'),
            ('SSReaderNavigationBarDownloadButton', 'UIButton'),
            ('SSBookShelfHeaderView', 'UIView'),
            ('SS525BookShelfSubHeaderView', 'UIView'),
            ('SSBookShelfEditHeaderView', 'UIView'),
            ('SSBookShelfFilterHeaderView', 'UIView'),
        ):
            self._class(name, parent)
        self.dispatch_methods = False

    def label(self, name, parent, frame, text, intrinsic=None, line_height=20.0,
              alignment=1, direction=0, **state):
        font = self.obj('UIFont', name + '.font', lineHeight=line_height)
        pointer = self.view('UILabel', name, frame, parent, **state)
        self.objects[pointer].state.update(
            text=self.text_object(text), font=font,
            intrinsicContentSize=intrinsic or frame[2:], textAlignment=alignment,
            effectiveUserInterfaceLayoutDirection=direction,
        )
        return pointer

    def image_view(self, name, parent, frame, size=(24.0, 24.0), content_mode=1,
                   **state):
        image = self.obj('UIImage', name + '.image', size=size)
        pointer = self.view('UIImageView', name, frame, parent, **state)
        self.objects[pointer].state.update(image=image, contentMode=content_mode)
        return pointer

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
            if name in ('alloc', 'new') and cls == 'UIVisualEffectView':
                result = self.view(cls, 'allocated_effect_view')
                self.retain_balance[result] = 1
                self.event(name, result)
                return self.finish(cpu, result)
            return super().handle(cpu, pc)
        require(receiver in self.objects, 'Known geometry-boundary receiver')
        state = self.objects[receiver].state
        if name == 'initWithEffect:':
            state['effect'] = cpu.x[2]
            state['contentView'] = self.view('UIView', 'new_effect_content',
                                             parent=receiver)
            return self.finish(cpu, receiver)
        if name in ('setUserInteractionEnabled:', 'setAccessibilityElementsHidden:',
                    'setAutoresizingMask:'):
            key = name[3:-1]
            key = key[:1].lower() + key[1:]
            state[key] = cpu.x[2]
            self.event(name, receiver, value=cpu.x[2])
            return self.finish(cpu)
        if name in ('text', 'font', 'image'):
            return self.finish(cpu, state.get(name, 0))
        if name == 'length':
            return self.finish(cpu, len(state['value']))
        if name in ('size', 'intrinsicContentSize'):
            return self.finish(cpu, fp=tuple(state[name]))
        if name == 'lineHeight':
            return self.finish(cpu, fp=(state[name],))
        if name in ('contentMode', 'textAlignment',
                    'effectiveUserInterfaceLayoutDirection'):
            return self.finish(cpu, state.get(name, 0))
        if name == 'clipsToBounds':
            return self.finish(cpu, int(state.get(name, False)))
        if name in ('insertSubview:atIndex:', 'insertSubview:belowSubview:'):
            child, argument = cpu.x[2:4]
            self.reparent(child, receiver)
            state['subviews'].remove(child)
            index = argument if name == 'insertSubview:atIndex:' else state['subviews'].index(argument)
            state['subviews'].insert(index, child)
            self.event(name, receiver, child=child, index=index)
            return self.finish(cpu)
        if name == 'removeFromSuperview':
            self.reparent(receiver, 0)
            self.event(name, receiver)
            return self.finish(cpu)
        if name in ('leftBackIconView', 'shareButton', 'moreButton', 'likeIcon'):
            return self.finish(cpu, state.get(name, 0))
        return super().handle(cpu, pc)
