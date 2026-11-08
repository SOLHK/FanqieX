"""Public UIKit/CoreImage fixtures for the 1.5.9 reader ARM64 execution audit.

This is an Objective-C boundary model, not UIKit or a device latency test.
The production instructions still compute all geometry, ownership, budgets,
branching, reentrancy guards, and mutation decisions.
"""
from arm64 import require
from geometry_runtime import GeometryRuntime


class ReaderRuntime(GeometryRuntime):
    def __init__(self, *args, symbol_available=False, symbol_nil=False, ci_available=True, ci_context_nil=False, ci_load=False, snapshot_fail_at=0, weak_fail_at=0, ci_row_order='top_down', ci_missing_selector=None, ci_calibration_corrupt=False, **kwargs):
        super().__init__(*args, **kwargs)
        if 'NSValue' not in self.classes:
            self._class('NSValue', 'NSObject')
        self._class('UIImageSymbolConfiguration', 'NSObject')
        for name, parent in [('UISwitch', 'UIControl'), ('UISlider', 'UIControl'),
                             ('UITextField', 'UIControl'),
                             ('UISegmentedControl', 'UIControl')]:
            if name not in self.classes:
                self._class(name, parent)
        self._class('CGImageFixture', 'NSObject')
        self._class('NSBundle', 'NSObject')
        self._class('NSMutableData', 'NSData')
        if ci_available:
            self._class('CIImage', 'NSObject')
            self._class('CIContext', 'NSObject')
        self.ci_context_nil = ci_context_nil
        self.ci_load = ci_load
        self.ci_context_requests = 0
        self.ci_render_calls = 0
        self.ci_calibration_calls = 0
        require(ci_row_order in ('top_down', 'bottom_up'), 'Explicit native bitmap row-order fixture')
        self.ci_row_order = ci_row_order
        self.ci_missing_selector = ci_missing_selector
        self.ci_calibration_corrupt = ci_calibration_corrupt
        self.ci_orientations = []
        self.ci_bundle_loads = 0
        self.pending_layouts = {}
        self.next_buffer = 0x6ff00000
        self.snapshot_fail_at = snapshot_fail_at
        self.weak_fail_at = weak_fail_at
        self.point_snapshots = 0
        self.weak_box_calls = 0
        self.symbol_available = symbol_available
        self.symbol_nil = symbol_nil
        self.symbol_requests = 0
        self.objects[self.DEFAULTS].state['values']['FanqieAdBlock.GlassDisabled.1'] = 0
        self.uptime = 1000.0

    def queue_layout(self, control, icon, frame):
        self.pending_layouts[control] = (icon, tuple(frame))

    def flush_pending(self, root=None):
        for control, (icon, frame) in list(self.pending_layouts.items()):
            node = control
            while node and node != root:
                node = self.objects[node].state.get('superview', 0)
            if root is not None and node != root:
                continue
            del self.pending_layouts[control]
            self.objects[icon].state['frame'] = frame
            self.event('pending_host_layout', control, icon=icon, frame=frame)

    def rgba_image(self, name, width, height, opaque_columns, *, alpha=255,
                   size=None, orientation=0, opaque_rows=None, scale=3.0):
        """Provide native-rendered bytes, never a precomputed bbox or shift."""
        pixels = bytearray(width*height*4)
        for y in (range(height) if opaque_rows is None else opaque_rows):
            for x in opaque_columns:
                pixels[(y*width+x)*4+3] = alpha
        cg = self.obj('CGImageFixture', name + '.CGImage',
                      width=width, height=height, rgba=bytes(pixels))
        logical = (height/scale, width/scale) if orientation in (2, 3, 6, 7) else (width/scale, height/scale)
        return self.obj('UIImage', name, size=size or logical, scale=scale,
                        CGImage=cg, imageOrientation=orientation,
                        alignmentRectInsets=(0., 0., 0., 0.))

    def responds(self, receiver, name):
        if receiver in self.objects:
            state = self.objects[receiver].state
            cls = self.class_names[self.objects[receiver].cls]
            if cls == 'CIImage' and name in ('imageByCroppingToRect:', 'imageByCompositingOverImage:', 'imageByApplyingOrientation:'):
                return name != self.ci_missing_selector
            if cls == 'CIContext' and name == 'render:toBitmap:rowBytes:bounds:format:colorSpace:':
                return name != self.ci_missing_selector
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
            if cls == 'CIImage' and name == 'respondsToSelector:':
                query = self.selector_names[cpu.x[2]]
                return self.finish(cpu, int(query in ('blackImage', 'clearImage') and query != self.ci_missing_selector))
            if cls == 'CIImage' and name in ('blackImage', 'clearImage'):
                require(name != self.ci_missing_selector, 'Unavailable CoreImage class method must not execute')
                return self.finish(cpu, self.obj(cls, 'ci_solid', solid=(0, 0, 0, 255 if name == 'blackImage' else 0), calibration=True))
            if cls == 'NSValue' and name == 'valueWithCGPoint:':
                self.point_snapshots += 1
                if self.point_snapshots == self.snapshot_fail_at:
                    return self.finish(cpu, 0)
            if cls == 'NSHashTable' and name == 'weakObjectsHashTable':
                self.weak_box_calls += 1
                if self.weak_box_calls == self.weak_fail_at:
                    return self.finish(cpu, 0)
            if cls == 'CIImage' and name == 'imageWithCGImage:':
                require(cpu.x[2] in self.objects, 'CGImage is supplied to CIImage factory')
                cg = self.objects[cpu.x[2]].state
                value = self.obj(cls, 'ci_image', cg=cpu.x[2], rgba=cg['rgba'],
                                 width=cg['width'], height=cg['height'], calibration=False,
                                 extent=(0., 0., float(cg['width']), float(cg['height'])))
                return self.finish(cpu, value)
            if cls == 'CIContext' and name == 'contextWithOptions:':
                require(cpu.x[2] == 0, 'Default CoreImage context has nil options')
                self.ci_context_requests += 1
                return self.finish(cpu, 0 if self.ci_context_nil else self.obj(cls, 'ci_context'))
            if cls == 'NSMutableData' and name == 'dataWithLength:':
                length = cpu.x[2]
                require(0 < length <= 256*256*4, 'RGBA buffer allocation is bounded to 256 KiB')
                pointer = self.next_buffer
                self.next_buffer += length + 16
                require(self.next_buffer < 0x6ff80000, 'Modeled native buffers do not overlap call stack')
                for i in range(length):
                    cpu.write(pointer+i, 1, 0)
                return self.finish(cpu, self.obj(cls, 'rgba_buffer', length=length, pointer=pointer))
            if cls == 'NSBundle' and name == 'bundleWithPath:':
                require(self.string_value(cpu.x[2]) == '/System/Library/Frameworks/CoreImage.framework',
                        'Only the system CoreImage framework is loaded')
                return self.finish(cpu, self.obj(cls, 'ci_bundle'))
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
        if cls == 'NSBundle' and name == 'load':
            self.ci_bundle_loads += 1
            if self.ci_load:
                for label in ('CIImage', 'CIContext'):
                    if label not in self.classes:
                        self._class(label, 'NSObject')
            return self.finish(cpu, int(self.ci_load))
        if cls == 'NSMutableData' and name == 'mutableBytes':
            return self.finish(cpu, state['pointer'])
        if cls == 'CIImage' and name == 'extent':
            return self.finish(cpu, fp=state['extent'])
        if cls == 'CIImage' and name == 'imageByApplyingOrientation:':
            require(name != self.ci_missing_selector, 'Unavailable orientation method must not execute')
            orientation = cpu.x[2]
            require(1 <= orientation <= 8, 'CIImage receives EXIF orientation, not UIImage enum')
            width, height = state['width'], state['height']
            out_width, out_height = (height, width) if orientation >= 5 else (width, height)
            pixels = bytearray(out_width*out_height*4)
            for y in range(height):
                for x in range(width):
                    nx, ny = {
                        1: (x, y), 2: (width-1-x, y), 3: (width-1-x, height-1-y),
                        4: (x, height-1-y), 5: (y, x), 6: (height-1-y, x),
                        7: (height-1-y, width-1-x), 8: (y, width-1-x),
                    }[orientation]
                    index, destination = (y*width+x)*4, (ny*out_width+nx)*4
                    pixels[destination:destination+4] = state['rgba'][index:index+4]
            self.ci_orientations.append(orientation)
            return self.finish(cpu, self.obj(cls, 'ci_oriented', rgba=bytes(pixels), width=out_width,
                                            height=out_height, calibration=False,
                                            extent=(0., 0., float(out_width), float(out_height))))
        if cls == 'CIImage' and name == 'imageByCroppingToRect:':
            require(name != self.ci_missing_selector, 'Unavailable cropping method must not execute')
            rect = tuple(cpu.fp(i) for i in range(4))
            require('solid' in state and rect in ((0., 0., 1., 1.), (0., 0., 1., 2.)),
                    'Only the bounded coordinate calibration crops solid images')
            width, height = int(rect[2]), int(rect[3])
            return self.finish(cpu, self.obj(cls, 'ci_crop', rgba=bytes(state['solid'])*width*height,
                                            extent=rect, width=width, height=height, calibration=True))
        if cls == 'CIImage' and name == 'imageByCompositingOverImage:':
            require(name != self.ci_missing_selector, 'Unavailable compositing method must not execute')
            other = self.objects[cpu.x[2]].state
            require(state['extent'] == (0., 0., 1., 1.) and other['extent'] == (0., 0., 1., 2.),
                    'Calibration composes known bounded Cartesian extents')
            # Stored fixture rows are top-down; Core Image's y=0 opaque row is
            # the lower row. This models the image operation, not a bbox or shift.
            pixels = bytearray(other['rgba'])
            pixels[4:8] = state['rgba']
            return self.finish(cpu, self.obj(cls, 'ci_composite', rgba=bytes(pixels),
                                            extent=other['extent'], width=1, height=2, calibration=True))
        if cls == 'CIContext' and name == 'render:toBitmap:rowBytes:bounds:format:colorSpace:':
            require(cpu.x[2] in self.objects, 'Render receives a CIImage')
            ci = self.objects[cpu.x[2]].state
            rect = tuple(cpu.fp(i) for i in range(4))
            require(rect == ci['extent'], 'Render bounds are exactly the bounded CGImage extent')
            require(cpu.x[4] == ci['width']*4, 'RGBA render rowBytes use four bytes per pixel')
            require(cpu.x[5] == 24 and cpu.x[6] == 0, 'CIFormat RGBA8 and nullable color space ABI')
            pointer = cpu.x[3]
            buffers = [o.state for o in self.objects.values()
                       if o.state.get('pointer') == pointer and 'length' in o.state]
            require(len(buffers) == 1 and buffers[0]['length'] == len(ci['rgba']),
                    'Render destination buffer exactly fits native RGBA fixture')
            pixels = ci['rgba']
            if self.ci_row_order == 'bottom_up':
                row_bytes = ci['width']*4
                pixels = b''.join(pixels[y*row_bytes:(y+1)*row_bytes] for y in reversed(range(ci['height'])))
            if ci['calibration'] and self.ci_calibration_corrupt:
                pixels = bytes(len(pixels))
            for i, value in enumerate(pixels):
                cpu.write(pointer+i, 1, value)
            if ci['calibration']:
                self.ci_calibration_calls += 1
            else:
                self.ci_render_calls += 1
            self.event('ci_calibration' if ci['calibration'] else 'ci_render', receiver,
                       image=cpu.x[2], byte_count=len(pixels), row_order=self.ci_row_order)
            return self.finish(cpu)
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
