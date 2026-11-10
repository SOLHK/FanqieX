"""Platform boundaries for executing the actual nested-feed ARM64 repair.

UIKit layout and pixels are not emulated. The candidate makes every ownership,
geometry, restoration and clipping decision; this model provides documented
property/message behavior, including an optional setter-induced offset change.
"""
from arm64 import require
from mock_foundation import Runtime as FoundationRuntime


class Runtime(FoundationRuntime):
    def __init__(self, data, slide=0, **options):
        super().__init__(data, slide, **options)
        for name, parent in (
            ('UIControl', 'UIView'), ('WKWebView', 'UIView'),
            ('UICollectionView', 'UIScrollView'),
            ('FQFeedListCollectionView', 'UICollectionView'),
            ('OtherFeedView', 'FQFeedListCollectionView'),
            ('FQFeedPageContainer', 'UIView'), ('UICollectionViewCell', 'UIView'),
            ('SSTabBarButtonItem', 'NSObject'),
        ):
            if name not in self.classes:
                self._class(name, parent)
        self.parents[self.classes['UIButton']] = self.classes['UIControl']
        self.adjust_offsets = False

    def handle(self, cpu, pc):
        self.current_cpu = cpu
        if pc - self.slide != 0xa5d4 or not cpu.x[0]:
            return super().handle(cpu, pc)
        receiver, selector = cpu.x[:2]
        if receiver in self.classes.values():
            return super().handle(cpu, pc)
        name = self.selector_names.get(selector)
        state = self.objects[receiver].state
        if name == 'class' and state.get('reportedClass'):
            # KVO-style dynamic isa remains visible to object_getClass while
            # an overridden -class reports the declared host class.
            return self.finish(cpu, state['reportedClass'])
        if name == 'convertRect:toView:' and state.get('convertHeightRoundoff'):
            handled = super().handle(cpu, pc)
            cpu.wf(3, cpu.fp(3) + state['convertHeightRoundoff'])
            return handled
        if name == 'getBytes:length:':
            value = state['value']
            require(cpu.x[3] <= len(value), 'NSData read remains within stored state')
            cpu.write(cpu.x[2], cpu.x[3], int.from_bytes(value[:cpu.x[3]], 'little'))
            return self.finish(cpu)
        if name == 'transform':
            transform = state.get('transform', (1, 0, 0, 1, 0, 0))
            import struct
            value = struct.pack('<6d', *transform)
            cpu.write(cpu.x[8], 48, int.from_bytes(value, 'little'))
            self.event('transform', receiver, value=list(transform))
            return self.finish(cpu)
        if name == 'contentOffset':
            return self.finish(cpu, fp=state.get('bounds', (0, 0))[:2])
        if name == 'type' and self.is_kind(receiver, self.classes['SSTabBarButtonItem']):
            return self.finish(cpu, state['type'])
        if name == 'contentInset':
            return self.finish(cpu, fp=state.get('contentInset', (0, 0, 0, 0)))
        if name == 'setContentInset:':
            state['contentInset'] = tuple(cpu.fp(i) for i in range(4))
            self.event('contentInset', receiver, value=list(state['contentInset']))
            if self.adjust_offsets:
                state['bounds'] = (0.0, 7.0, *state['bounds'][2:])
            return self.finish(cpu)
        if name == 'setContentOffset:':
            state['bounds'] = (cpu.fp(0), cpu.fp(1), *state['bounds'][2:])
            self.event('contentOffset', receiver, value=list(state['bounds'][:2]))
            return self.finish(cpu)
        if name == 'clipsToBounds':
            return self.finish(cpu, int(state.get('clipsToBounds', False)))
        if name == 'setClipsToBounds:':
            state['clipsToBounds'] = bool(cpu.x[2])
            self.objects[self.layer(receiver)].state['masksToBounds'] = bool(cpu.x[2])
            self.event('clipsToBounds', receiver, value=bool(cpu.x[2]))
            return self.finish(cpu)
        if name == 'mask':
            return self.finish(cpu, state.get('mask', 0))
        if name == 'cornerRadius':
            return self.finish(cpu, fp=(state.get('cornerRadius', 0),))
        if name == 'anyObject':
            return self.finish(cpu, next(iter(state.get('items', [])), 0))
        return super().handle(cpu, pc)


def put_frame(rt, view, frame):
    state = rt.objects[view].state
    state['frame'] = tuple(frame)
    state['bounds'] = (*state['bounds'][:2], *frame[2:])


def fixture(rt, *, tab=3, tab_types=(0, 7, 3, 4), inner_height=776, outer_height=850,
            outer_offset=313, inner_offset=6527, clip=True):
    """Use window/feed dimensions present in the current 1.5.8 log session.

    The supplied export mixes 1.5.7/1.5.8. Its observed dimensions are reused;
    the ancestor chain is synthetic because that export does not record it.
    """
    for view in (rt.WINDOW, rt.ROOT):
        put_frame(rt, view, (0, 0, 440, 956))
    put_frame(rt, rt.BAR, (0, 882, 440, 74))
    put_frame(rt, rt.PROXY, (12, 0, 416, 56))
    items = [rt.obj('SSTabBarButtonItem', 'tab_' + str(tab_type), type=tab_type)
             for tab_type in tab_types]
    rt.objects[rt.BAR].state['items'] = rt.obj('NSArray', 'items', items=items)
    rt.objects[rt.BAR].state['selectedItem'] = items[tab]
    rt.objects[rt.SCROLL].state['hidden'] = True
    outer = rt.view('UICollectionView', 'outer', (0, 106, 440, outer_height),
                    rt.ROOT, clipsToBounds=True, contentSize=(440, 1089))
    rt.objects[outer].state['bounds'] = (0, outer_offset, 440, outer_height)
    cell = rt.view('UICollectionViewCell', 'cell',
                   (0, outer_offset, 440, inner_height), outer,
                   clipsToBounds=clip)
    container = rt.view('FQFeedPageContainer', 'container',
                        (0, 0, 440, inner_height), cell, clipsToBounds=clip)
    feed = rt.view('FQFeedListCollectionView', 'feed',
                   (0, 0, 440, inner_height), container,
                   clipsToBounds=True, contentSize=(440, 9621),
                   contentInset=(3.0, 4.0, 5.0, 6.0))
    rt.objects[feed].state['bounds'] = (0, inner_offset, 440, inner_height)
    return {'feed': feed, 'outer': outer, 'cell': cell, 'container': container,
            'items': items}
