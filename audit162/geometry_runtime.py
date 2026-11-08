"""Public UIKit boundary fixtures for executing control_geometry ARM64 bytes.

This extends, but does not alter, the previous audit runtime. It supplies view,
image and font measurements as fixtures. All scope selection, rectangle unions,
padding, clipping decisions, material reuse and fallback branches execute from
the candidate. It does not emulate UIKit pixels or Core Animation timing.
"""
from arm64 import require, bits
from mock_foundation import Runtime as FoundationRuntime
from control_targets_runtime import ControlTargetsBoundary


class GeometryRuntime(ControlTargetsBoundary, FoundationRuntime):
    def __init__(self, data, slide=0, **options):
        super().__init__(data, slide, **options)
        self._class('UIControl', 'UIView')
        self._class('CATransaction', 'NSObject')
        # Public Core Animation transaction state only. This records action
        # suppression/nesting, not a UIKit compositor or pixel simulation.
        self.transaction_stack = []
        if 'NSValue' not in self.classes:
            self._class('NSValue', 'NSObject')
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
            ('SSReaderMenuView', 'UIView'),
            ('FQReaderSaaSBottomToolView', 'UIView'),
            ('FQReaderBottomButtonContainerView', 'UIView'),
            ('SSReaderBottomToolButton', 'UIButton'),
            ('SSReaderFloatingCommonButton', 'UIButton'),
            ('SSNewAudioPlayControlView', 'UIView'),
        ):
            self._class(name, parent)
        self.dispatch_methods = False
        self.uptime = 1000.0
        # Geometry cases explicitly exercise the enabled glass preference.
        self.objects[self.DEFAULTS].state['values']['FanqieAdBlock.GlassDisabled.1'] = 0

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
            if cls == 'CATransaction' and name == 'begin':
                self.transaction_stack.append({'disableActions': False})
                self.event('transaction_begin', receiver,
                           depth=len(self.transaction_stack))
                return self.finish(cpu)
            if cls == 'CATransaction' and name == 'setDisableActions:':
                require(self.transaction_stack, 'Actions belong to an explicit transaction')
                self.transaction_stack[-1]['disableActions'] = bool(cpu.x[2])
                self.event('transaction_disable_actions', receiver,
                           value=bool(cpu.x[2]), depth=len(self.transaction_stack))
                return self.finish(cpu)
            if cls == 'CATransaction' and name == 'commit':
                require(self.transaction_stack, 'Every commit has a matching begin')
                self.transaction_stack.pop()
                self.event('transaction_commit', receiver,
                           depth=len(self.transaction_stack))
                return self.finish(cpu)
            if cls == 'NSValue' and name in ('valueWithCGPoint:', 'valueWithCGSize:', 'valueWithCGRect:'):
                key = {'valueWithCGPoint:': 'point', 'valueWithCGSize:': 'size', 'valueWithCGRect:': 'rect'}[name]
                count = 4 if key == 'rect' else 2
                return self.finish(cpu, self.obj(cls, key + '_snapshot', **{key: tuple(cpu.fp(i) for i in range(count))}))
            if name in ('alloc', 'new') and cls == 'UIVisualEffectView':
                result = self.view(cls, 'allocated_effect_view')
                self.retain_balance[result] = 1
                self.event(name, result)
                return self.finish(cpu, result)
            return super().handle(cpu, pc)
        require(receiver in self.objects, 'Known geometry-boundary receiver')
        state = self.objects[receiver].state
        if name in ('CGPointValue', 'CGSizeValue', 'CGRectValue'):
            return self.finish(cpu, fp=state[{'CGPointValue': 'point', 'CGSizeValue': 'size', 'CGRectValue': 'rect'}[name]])
        if name == 'scale' and self.is_kind(receiver, self.classes['UIImage']):
            return self.finish(cpu, fp=(state.get('scale', 1.0),))
        if name == 'cornerRadius' and self.is_kind(receiver, self.classes['CALayer']):
            return self.finish(cpu, fp=(state.get('cornerRadius', 0.0),))
        if name == 'cornerConfiguration':
            return self.finish(cpu, state.get('cornerConfiguration', 0))
        if name == 'systemUptime':
            return self.finish(cpu, fp=(self.uptime,))
        if name == 'layoutIfNeeded':
            saved_lr = cpu.x[30]
            self.event('layoutIfNeeded', receiver)
            if hasattr(self, 'flush_pending'):
                self.flush_pending(receiver)
            if state.pop('layout_reenter', False):
                self.event('layoutIfNeeded_reentry', receiver)
                cpu.run(0x7848, args=[receiver])
            cpu.x[30] = saved_lr
            return self.finish(cpu)
        if name == 'capInsets':
            return self.finish(cpu, fp=state.get('capInsets', (0., 0., 0., 0.)))
        if name in ('isAnimating', 'isHighlighted', 'highlightedImage', 'flipsForRightToLeftLayoutDirection'):
            return self.finish(cpu, state.get(name, 0))
        if name == 'center':
            frame = state['frame']
            return self.finish(cpu, fp=(frame[0]+frame[2]/2, frame[1]+frame[3]/2))
        if name == 'setCenter:':
            frame = state['frame']
            center = (cpu.fp(0), cpu.fp(1))
            state['frame'] = (center[0]-frame[2]/2, center[1]-frame[3]/2, frame[2], frame[3])
            self.event(name, receiver, center=center)
            return self.finish(cpu)
        if name == 'transform':
            transform = state.get('transform', (1., 0., 0., 1., 0., 0.))
            require(len(transform) == 6, 'CGAffineTransform has six doubles')
            result_pointer = cpu.x[8]
            for i, value in enumerate(transform):
                cpu.write(result_pointer + i*8, 8, bits(value))
            self.event('transform', receiver, result_pointer=result_pointer)
            return self.finish(cpu)
        if name == 'isUserInteractionEnabled':
            default = not self.is_kind(receiver, self.classes['UIImageView'])
            return self.finish(cpu, int(state.get('userInteractionEnabled', default)))
        if name in ('imageOrientation', 'CGImage', 'images'):
            return self.finish(cpu, state.get(name, 0))
        if name == 'anyObject':
            return self.finish(cpu, next(iter(state.get('items', [])), 0))
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
