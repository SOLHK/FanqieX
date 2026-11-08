"""Additional public Objective-C boundaries for retained legacy regressions.

Candidate control flow remains ARM64. This model does not render UIKit.
"""
from mock_foundation import Runtime as Base
from test_diagnostic_dedup import SemanticBoundary
from arm64 import require

class Runtime(SemanticBoundary, Base):
    def __init__(self,*args,**kwargs):
        super().__init__(*args,**kwargs)
        for n,p in [('NSRunLoop','NSObject'),('NSBundle','NSObject')]:
            if n not in self.classes: self._class(n,p)
        self.main_runloop=self.obj('NSRunLoop','main_runloop',timers=[])
        self.class_bundles={}

    def handle(self,cpu,pc):
        self.current_cpu=cpu
        if pc-self.slide!=0xa5d4: return super().handle(cpu,pc)
        a=cpu.x[:8]; receiver,selector=a[:2]
        name=self.selector_names.get(selector)
        if receiver==self.PROCESS and name=='systemUptime':
            return self.finish(cpu,fp=(self.now,))
        if not receiver: return super().handle(cpu,pc)
        if receiver in self.classes.values():
            cls=self.class_names[receiver]
            if cls=='NSRunLoop' and name=='mainRunLoop':
                return self.finish(cpu,self.main_runloop)
            if cls=='NSBundle' and name=='bundleForClass:':
                ident=self.class_bundles.get(a[2],'com.apple.UIKitCore')
                return self.finish(cpu,self.obj('NSBundle','class_bundle',identifier=ident))
        elif receiver in self.objects:
            st=self.objects[receiver].state
            if name=='bundleIdentifier': return self.finish(cpu,self.text_object(st['identifier']))
            if name=='isEqualToString:':
                return self.finish(cpu,int(self.string_value(receiver)==self.string_value(a[2])))
            if name=='hasPrefix:':
                return self.finish(cpu,int(self.string_value(receiver).startswith(self.string_value(a[2]))))
            if name=='nextResponder': return self.finish(cpu,st.get('nextResponder',st.get('superview',0)))
            if name=='anyObject': return self.finish(cpu,next(iter(st.get('items',[])),0))
            if name=='invalidate':
                st['valid']=False
                self.event('invalidate',receiver)
                return self.finish(cpu)
            if name=='addTimer:forMode:':
                require(self.string_value(a[3])=='kCFRunLoopCommonModes','Monitor uses common run-loop modes')
                st['timers'].append((a[2],self.string_value(a[3])))
                self.event('add_common_timer',receiver,timer=a[2])
                return self.finish(cpu)
        return super().handle(cpu,pc)
