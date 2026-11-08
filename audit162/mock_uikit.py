#!/usr/bin/env python3
"""Stateful Objective-C boundary model; deliberately not a UIKit renderer.

Tracks view geometry, layer values, object identity and edge hidden state. The
machine-code caller performs all control flow. Only imported runtime/platform
entry points and the unavailable host app implementations are mocked here.
"""
from dataclasses import dataclass, field

from arm64 import MASK64, bits, require


@dataclass
class Obj:
    cls: int
    name: str
    state: dict = field(default_factory=dict)


class Runtime:
    LAYOUT_IMP = 0x33000100
    RATIO_IMP = 0x33000200
    BACKGROUND_IMP = 0x33000300
    SUPERCLASS_IMP = 0x33000a00

    def __init__(self, data, slide=0, active=True, attached=True,
                 inherited=False, class_exists=True, ratio_alias=True,
                 original_edge_hidden=False, edge_supported=True):
        self.data, self.slide = data, slide
        self.events, self.calls = [], 0
        self.objects, self.classes, self.class_names, self.parents = {}, {}, {}, {}
        self.metaclasses = {}
        self.methods, self.own, self.associations, self.ivar_ids = {}, {}, {}, {}
        self.selectors, self.selector_names, self.strings = {}, {}, {}
        self.layout_mutator = None
        self.on_event = None
        self.current_cpu = None
        self.retain_balance = {}
        self.dispatch_methods = True
        self.edge_supported = edge_supported
        self.class_exists = class_exists
        self.rebase_pointers = {}
        root = self._class('NSObject')
        self._add(self.metaclasses[root], 'superclass', self.SUPERCLASS_IMP, '#16@0:8')
        for name, parent in [('UIView','NSObject'), ('UIWindow','UIView'),
                             ('UIScrollView','UIView'), ('SSTabBar','UIView'),
                             ('UIButton','UIView'), ('UILabel','UIView'),
                             ('UIVisualEffectView','UIView'), ('CALayer','NSObject'),
                             ('NSNumber','NSObject'), ('NSArray','NSObject'),
                             ('UIColor','NSObject'), ('UIScrollEdgeEffect','NSObject')]:
            self._class(name, parent)
        self.UIView = self.classes['UIView']; self.TabBar = self.classes['SSTabBar']
        self.WINDOW = self.view('UIWindow', 'window', (0,0,390,844))
        self.ROOT = self.view('UIView', 'root', (0,0,390,844), self.WINDOW)
        self.SCROLL = self.view('UIScrollView', 'main_scroll', (0,0,390,844), self.ROOT)
        self.objects[self.SCROLL].state['contentSize'] = (390,2200)
        self.EDGE = self.obj('UIScrollEdgeEffect', 'bottom_edge', hidden=original_edge_hidden)
        self.objects[self.SCROLL].state['bottomEdgeEffect'] = self.EDGE
        self.BAR = self.view('SSTabBar', 'bar', (0,754,390,90), self.ROOT)
        self.CONTENT = self.view('UIView', 'native_content', (0,0,390,90), self.BAR)
        self.PROXY = self.view('UIVisualEffectView', 'floating_proxy', (12,0,366,56),
                               self.BAR if attached else self.ROOT)
        self.BUTTON = self.view('UIButton', 'first_button', (0,0,0,0), self.PROXY)
        self.LABEL = self.view('UILabel', 'first_label', (0,0,0,0), self.BUTTON)
        self.objects[self.BUTTON].state['titleLabel'] = self.LABEL
        self.layer(self.LABEL)
        self.objects[self.layer(self.LABEL)].state.update(shadowOpacity=0.9, shadowRadius=2.0)
        self.SELECTED = self.obj('NSObject','selected_item')
        self.objects[self.BAR].state.update(contentView=self.CONTENT, selectedItem=self.SELECTED,
                                            appearanceStyle=0, backgroundColor=self.color('bar_original'))
        self.objects[self.BAR].state['items'] = self.obj('NSArray','tab_items',items=[self.SELECTED])
        self.associations[(self.PROXY,slide+0xeb85)] = self.obj('NSArray','floating_buttons',items=[self.BUTTON])
        self.objects[self.CONTENT].state['backgroundColor'] = self.color('content_original')
        self.ivar_names = ('_lightEffectView','_darkEffectView','_lightNormalView',
                           '_darkNormalView','_lineView','_backgroundImageView')
        self.backdrops = []
        for i, name in enumerate(self.ivar_names):
            obj = self.view('UIView', name, (0,0,390,90), self.BAR, hidden=bool(i % 2))
            self.objects[self.BAR].state[name] = obj
            self.backdrops.append(obj)
            # These exact table entries are dyld chained rebase pointers in this
            # Mach-O. Resolve only those actual, pre-audited table locations.
            pointer = int.from_bytes(data[0x10a20+8*i:0x10a28+8*i], 'little')
            self.rebase_pointers[slide+0x10a20+8*i] = slide+(pointer & ((1 << 36)-1))
        if active:
            self.associations[(self.BAR, slide+0xeb84)] = self.PROXY
        self._add(self.UIView, 'layoutSubviews', self.LAYOUT_IMP, 'v16@0:8')
        self._add(self.UIView, 'setBackgroundColor:', self.BACKGROUND_IMP, 'v24@0:8@16')
        if not inherited:
            self._add(self.TabBar, 'layoutSubviews', self.LAYOUT_IMP, 'v16@0:8')
            self._add(self.TabBar, 'setBackgroundColor:', self.BACKGROUND_IMP, 'v24@0:8@16')
        if ratio_alias:
            self._add(self.TabBar, 'fqab_barRatio', self.RATIO_IMP, 'v28@0:8d16B24')

    def _class(self, name, parent=None):
        pointer = 0x32000000+len(self.classes)*0x100
        self.classes[name] = pointer; self.class_names[pointer] = name
        self.parents[pointer] = self.classes.get(parent,0)
        self.own[pointer] = {}
        meta = 0x38000000+len(self.metaclasses)*0x100
        self.metaclasses[pointer] = meta
        self.class_names[meta] = name+'(meta)'
        self.own[meta] = {}
        self.parents[meta] = self.metaclasses.get(self.parents[pointer],0)
        return pointer

    def obj(self, cls, name, **state):
        pointer = 0x31000000+len(self.objects)*0x100
        self.objects[pointer] = Obj(self.classes[cls], name, state)
        return pointer

    def view(self, cls, name, frame=(0,0,0,0), parent=0, **state):
        pointer = self.obj(cls, name, frame=tuple(frame), bounds=(0,0,frame[2],frame[3]),
                           superview=0, subviews=[], hidden=False, alpha=1.0,
                           backgroundColor=0, **{k:v for k,v in state.items() if k not in ('hidden','alpha')})
        self.objects[pointer].state.update({k:v for k,v in state.items() if k in ('hidden','alpha')})
        self.reparent(pointer, parent)
        return pointer

    def reparent(self, child, parent):
        state = self.objects[child].state
        old = state['superview']
        if old:
            self.objects[old].state['subviews'].remove(child)
        state['superview'] = parent
        if parent:
            self.objects[parent].state['subviews'].append(child)

    def color(self, name):
        for pointer, obj in self.objects.items():
            if obj.name == 'color:' + name:
                return pointer
        return self.obj('UIColor', 'color:' + name)

    def layer(self, receiver):
        state = self.objects[receiver].state
        if 'layer' not in state:
            state['layer'] = self.obj('CALayer', self.objects[receiver].name+'.layer',
                                      owner=receiver, cornerRadius=0.0, masksToBounds=False,
                                      shadowOpacity=0.0, shadowRadius=0.0)
        return state['layer']

    def string(self, pointer):
        if pointer in self.strings:
            return self.strings[pointer]
        p = pointer-self.slide
        require(0 <= p < len(self.data), 'String address outside candidate: ' + hex(pointer))
        return self.data[p:self.data.index(b'\0', p)].decode()

    def string_pointer(self, value):
        for p, s in self.strings.items():
            if s == value:
                return p
        p = 0x34000000+len(self.strings)*0x100
        self.strings[p] = value
        return p

    def sel(self, name):
        if name not in self.selectors:
            p = 0x35000000+8*len(self.selectors)
            self.selectors[name] = p; self.selector_names[p] = name
        return self.selectors[name]

    def _add(self, cls, selector, imp, encoding):
        s = self.sel(selector)
        p = 0x36000000+16*len(self.methods)
        self.methods[p] = {'class':cls,'selector':s,'imp':imp,'encoding':encoding}
        self.own[cls][s] = p
        return p

    def get_method(self, cls, selector):
        while cls:
            if selector in self.own[cls]:
                return self.own[cls][selector]
            cls = self.parents[cls]
        return 0

    def is_kind(self, receiver, cls):
        here = self.objects[receiver].cls
        while here:
            if here == cls:
                return True
            here = self.parents[here]
        return False

    def window(self, receiver):
        while receiver:
            if self.is_kind(receiver, self.classes['UIWindow']):
                return receiver
            receiver = self.objects[receiver].state.get('superview',0)
        return 0

    def origin(self, receiver):
        x = y = 0.0
        while receiver:
            state = self.objects[receiver].state
            x += state['frame'][0]-state['bounds'][0]
            y += state['frame'][1]-state['bounds'][1]
            receiver = state.get('superview',0)
        return x, y

    def event(self, name, receiver=None, **detail):
        record = {'event':name, **detail}
        if receiver is not None:
            record.update(self=receiver, object=self.objects[receiver].name if receiver in self.objects else hex(receiver))
        self.events.append(record)
        if self.on_event:
            self.on_event(self.current_cpu,record)

    def clobber(self, cpu, result=0, fp_result=None, float_result=None):
        self.calls += 1
        for i in range(18):
            cpu.x[i] = 0xc000000000000000+self.calls*0x100+i
        for i in range(8):
            cpu.v[i] = 0xe000000000000000+self.calls*0x100+i
        cpu.flags(self.calls & 1, self.calls & 2, self.calls & 4, self.calls & 8)
        cpu.x[0] = result & MASK64
        if fp_result is not None:
            for i, value in enumerate(fp_result):
                cpu.v[i] = bits(value)
        if float_result is not None:
            cpu.v[0] = bits(float_result, 32)

    def responds(self, receiver, name):
        if name == 'bottomEdgeEffect':
            return self.edge_supported and self.is_kind(receiver, self.classes['UIScrollView'])
        state = self.objects[receiver].state
        return (name in state or name in ('respondsToSelector:','isKindOfClass:','window',
                'convertRect:toView:','convertRect:fromView:','layer','setHidden:',
                'setCornerRadius:','setMasksToBounds:','setShadowOpacity:','setShadowRadius:',
                'setBackgroundColor:','isHidden','alpha','superview','subviews',
                'frame','bounds','setFrame:','count','objectAtIndex:','lastObject',
                'bringSubviewToFront:','retain','release','autorelease','setNeedsLayout')
                or bool(self.get_method(self.objects[receiver].cls, self.sel(name))))

    def handle(self, cpu, pc):
        self.current_cpu = cpu
        p = pc-self.slide; a = cpu.x[:8]
        returned_to = cpu.x[30]
        result, fp_result, float_result = 0, None, None
        if pc in (self.LAYOUT_IMP, self.RATIO_IMP, self.BACKGROUND_IMP):
            if pc == self.LAYOUT_IMP:
                self.event('original_layout', a[0], selector=a[1])
                if self.layout_mutator:
                    self.layout_mutator(self, a[0])
            elif pc == self.RATIO_IMP:
                self.event('original_ratio', a[0], selector=a[1], x2=a[2], d0=cpu.v[0] & MASK64)
            else:
                self.event('original_background', a[0], selector=a[1], value=a[2])
                self.objects[a[0]].state['backgroundColor'] = a[2]
        elif p == 0xa5a4:
            result = self.sel(self.string(a[0]))
        elif p == 0xa5b0:
            name = self.string(a[0])
            result = self.classes.get(name,0)
            if name == 'SSTabBar' and not self.class_exists:
                result = 0
        elif pc == self.SUPERCLASS_IMP:
            require(a[1] == self.sel('superclass'), 'Original superclass selector')
            result = self.parents[a[0]]
        elif p == 0xa5f8:
            result = self.get_method(a[0],a[1]) if a[0] else 0
        elif p == 0xa604:
            result = self.get_method(self.metaclasses.get(a[0],0),a[1])
        elif p == 0xa598:
            result = self.methods[a[0]]['imp'] if a[0] else 0
        elif p == 0xa5ec:
            result = self.string_pointer(self.methods[a[0]]['encoding']) if a[0] else 0
        elif p == 0xa5e0:
            result = int(self.string(a[0]) != self.string(a[1]))
        elif p == 0xa58c:
            cls, selector, imp, encoding = a[:4]
            self.event('class_addMethod', cls, selector=self.selector_names[selector], imp=imp)
            if selector not in self.own[cls]:
                self._add(cls, self.selector_names[selector], imp, self.string(encoding)); result = 1
        elif p == 0xa580:
            method, imp = a[:2]
            record = self.methods[method]
            self.event('method_setImplementation', record['class'], selector=self.selector_names[record['selector']], imp=imp)
            result = record['imp']; record['imp'] = imp
        elif p == 0xa628:
            result = self.associations.get((a[0],a[1]),0)
        elif p == 0xa634:
            self.event('set_association', a[0], key=a[1], value=a[2], policy=a[3])
            require(a[3] in (0,1,3,0x301,0x303), 'Known association policy')
            if a[2]:
                self.associations[(a[0],a[1])] = a[2]
            else:
                self.associations.pop((a[0],a[1]),None)
        elif p == 0xa64c:
            key = (a[0],self.string(a[1]))
            if key not in self.ivar_ids:
                self.ivar_ids[key] = 0x37000000+len(self.ivar_ids)*8
            result = self.ivar_ids[key]
        elif p == 0xa640:
            name = next(name for (_,name),pointer in self.ivar_ids.items() if pointer == a[1])
            result = self.objects[a[0]].state.get(name,0)
        elif p == 0xa664:
            if a[0] in self.metaclasses:
                result = self.metaclasses[a[0]]
            elif a[0]:
                result = self.objects[a[0]].cls
        elif p == 0xa5d4:
            receiver, selector = a[:2]
            name = self.selector_names.get(selector)
            require(name is not None, 'Known selector for objc_msgSend')
            if not receiver:
                fp_result = (0.0,0.0,0.0,0.0)
            elif receiver in self.metaclasses:
                method = self.get_method(self.metaclasses[receiver], selector) if self.dispatch_methods else 0
                if method:
                    cpu.pc = self.methods[method]['imp']
                    return True
                cls = self.class_names[receiver]
                if cls == 'UIColor' and name in ('clearColor','secondarySystemFillColor','systemBackgroundColor','labelColor'):
                    result = self.color(name)
                elif cls == 'NSNumber' and name in ('numberWithUnsignedInteger:','numberWithBool:','numberWithInteger:'):
                    result = self.obj('NSNumber','number:'+str(a[2]), value=a[2])
                else:
                    raise AssertionError('Unmodeled class message '+repr((cls,name,a[2])))
            else:
                require(receiver in self.objects, 'Known objc receiver '+hex(receiver))
                obj = self.objects[receiver]; state = obj.state
                method = self.get_method(obj.cls, selector) if self.dispatch_methods else 0
                if method:
                    # The actual installed implementation receives untouched
                    # objc_msgSend argument registers and caller return address.
                    cpu.pc = self.methods[method]['imp']
                    return True
                if name in ('frame','bounds','contentSize'):
                    fp_result = state[name]
                    self.event(name, receiver, value=list(fp_result))
                elif name == 'setFrame:':
                    rect = tuple(cpu.fp(i) for i in range(4))
                    state['frame'] = rect
                    old_bounds = state['bounds']; state['bounds'] = (*old_bounds[:2], *rect[2:])
                    self.event('setFrame',receiver,value=list(rect))
                elif name in ('superview','contentView','selectedItem','titleLabel','items'):
                    result = state.get(name,0)
                elif name == 'window':
                    result = self.window(receiver)
                elif name == 'isHidden':
                    result = int(state.get('hidden',False))
                    self.event('isHidden',receiver,value=bool(result))
                elif name == 'setHidden:':
                    state['hidden'] = bool(a[2]); self.event('setHidden',receiver,value=bool(a[2]))
                elif name == 'alpha':
                    fp_result = (state['alpha'],)
                elif name == 'layer':
                    result = self.layer(receiver)
                elif name == 'setCornerRadius:':
                    state['cornerRadius'] = cpu.fp(0)
                    self.event('cornerRadius',receiver,value=cpu.fp(0),owner_bounds=list(self.objects[state['owner']].state['bounds']))
                elif name == 'setMasksToBounds:':
                    state['masksToBounds'] = bool(a[2]); self.event('masksToBounds',receiver,value=bool(a[2]))
                elif name == 'setShadowOpacity:':
                    state['shadowOpacity'] = cpu.fp(0,32)
                    self.event('shadowOpacity',receiver,value=cpu.fp(0,32),bits=cpu.v[0]&0xffffffff)
                elif name == 'setShadowRadius:':
                    state['shadowRadius'] = cpu.fp(0); self.event('shadowRadius',receiver,value=cpu.fp(0))
                elif name in ('setShadowColor:','setShadowOffset:'):
                    state[name] = a[2] if name == 'setShadowColor:' else (cpu.fp(0),cpu.fp(1))
                elif name == 'backgroundColor':
                    result = state['backgroundColor']
                elif name == 'setBackgroundColor:':
                    state['backgroundColor'] = a[2]; self.event('backgroundColor',receiver,value=a[2])
                elif name == 'subviews':
                    result = self.obj('NSArray',obj.name+'.subviews',items=list(state['subviews']))
                elif name == 'count':
                    result = len(state['items'])
                elif name == 'objectAtIndex:':
                    result = state['items'][a[2]]
                elif name == 'indexOfObjectIdenticalTo:':
                    result = state['items'].index(a[2]) if a[2] in state['items'] else 0x7fffffffffffffff
                elif name == 'setSelected:':
                    state['selected'] = bool(a[2]); self.event('selected',receiver,value=bool(a[2]))
                elif name == 'setAccessibilityTraits:':
                    state['accessibilityTraits'] = a[2]
                elif name == 'lastObject':
                    result = state['items'][-1] if state['items'] else 0
                elif name in ('bringSubviewToFront:', 'sendSubviewToBack:'):
                    state['subviews'].remove(a[2])
                    if name == 'bringSubviewToFront:':
                        state['subviews'].append(a[2])
                    else:
                        state['subviews'].insert(0, a[2])
                    self.event('bring_front' if name == 'bringSubviewToFront:' else 'send_back',receiver,child=a[2])
                elif name == 'bottomEdgeEffect':
                    require(self.edge_supported, 'Missing bottomEdgeEffect selector must be guarded')
                    result = state.get('bottomEdgeEffect',0)
                    self.event('bottomEdgeEffect',receiver,value=result)
                elif name == 'respondsToSelector:':
                    result = int(self.responds(receiver,self.selector_names[a[2]]))
                elif name == 'isKindOfClass:':
                    result = int(self.is_kind(receiver,a[2]))
                elif name in ('convertRect:toView:','convertRect:fromView:'):
                    rect = tuple(cpu.fp(i) for i in range(4))
                    source, target = (receiver,a[2]) if name == 'convertRect:toView:' else (a[2],receiver)
                    source_origin = self.origin(source); target_origin = self.origin(target)
                    fp_result = (rect[0]+source_origin[0]-target_origin[0],
                                 rect[1]+source_origin[1]-target_origin[1],rect[2],rect[3])
                    self.event(name,receiver,other=a[2],input=list(rect),output=list(fp_result))
                elif name in ('unsignedIntegerValue','integerValue','boolValue'):
                    result = state['value']
                elif name == 'appearanceStyle':
                    result = state.get('appearanceStyle',0)
                elif name == 'applyTabBarAppearanceStyle:refreshForeground:':
                    self.event('original_appearance',receiver,style=a[2],refresh=a[3])
                elif name == 'retain':
                    self.retain_balance[receiver] = self.retain_balance.get(receiver,0)+1
                    self.event('retain',receiver)
                    result = receiver
                elif name == 'release':
                    self.retain_balance[receiver] = self.retain_balance.get(receiver,0)-1
                    self.event('release',receiver)
                elif name == 'autorelease':
                    result = receiver
                elif name == 'setNeedsLayout':
                    pass
                else:
                    raise AssertionError('Unmodeled instance message '+repr((obj.name,name,a[2])))
        else:
            return False
        require(cpu.sp % 16 == 0, '16-byte aligned stack at external call')
        self.clobber(cpu,result,fp_result,float_result)
        cpu.pc = returned_to
        return True
