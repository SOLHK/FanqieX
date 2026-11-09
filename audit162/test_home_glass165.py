"""Execute the 1.6.5 header and host compatibility code against UIKit boundaries.
No device rendering, dyld, signing or real iOS lifecycle is simulated.
"""
import argparse, json, math, struct
from pathlib import Path
from arm64 import CPU, require, release_version
from geometry_runtime import GeometryRuntime
from test_feed_viewport import labels_for

HOME='SSBookStoreNewViewController'
CATEGORY='SSBookStoreCategorySignView'
SEARCH='SSBookStoreSearchBarComponent'
COLOR='resetColorWithRatio:fromTab:toTab:fromTabTemplate:toTabTemplate:'
SEARCH_COLOR='resetTopTabSearchViewWithRatio:fromTab:toTab:fromTabTemplate:toTabTemplate:'
HOOKS=[(HOME,'relayout','v16@0:8'),(HOME,'viewDidAppear:','v20@0:8B16'),
       (CATEGORY,'layoutSubviews','v16@0:8'),(CATEGORY,COLOR,'v40@0:8d16i24i28i32i36'),
       (SEARCH,SEARCH_COLOR,'v40@0:8d16i24i28i32i36')]
LABELS=['LFQH_FQHApply','LFQH_FQHInstall','LFQH_FQHCompatibleHost','LFQH_FQHGlassAvailable',
        'LFQH_SurfaceKey','LHomeHostGate']
class Runtime(GeometryRuntime):
    def __init__(self,data,slide=0,available=True):
        super().__init__(data,slide)
        self.hosts={}; self.original_calls=[]; self.available=available
        self.identity='com.dragon.read'
        self.objects[self.MAIN_BUNDLE].state['info']['CFBundleVersion']='7.4.3.33'
        for cls,parent in [(HOME,'UIViewController'),(CATEGORY,'UIView'),(SEARCH,'NSObject')]: self._class(cls,parent)
        for cls,sel,ty in HOOKS+[(HOME,'searchBgView','@16@0:8')]:
            imp=0x33040000+len(self.hosts)*0x100
            self.hosts[imp]=(cls,sel)
            self._add(self.classes[cls],sel,imp,ty)
        if available:
            self._add(self.classes['UIVisualEffectView'],'setCornerConfiguration:',0x33060000,'v24@0:8@16')
            self._add(self.classes['UIGlassEffect'],'setInteractive:',0x33060100,'v20@0:8B16')
        else:
            self.glass_factory_available=False
        self.attachments=[]
    def view(self,cls,name,frame=(0,0,0,0),parent=0,**state):
        color=state.pop("backgroundColor",0)
        value=super().view(cls,name,frame,parent,**state)
        self.objects[value].state["backgroundColor"]=color
        return value
    def responds(self,receiver,name):
        return name in self.objects[receiver].state or super().responds(receiver,name)
    def handle(self,cpu,pc):
        self.current_cpu=cpu
        r,sel=cpu.x[:2]; name=self.selector_names.get(sel)
        if pc-self.slide in (0x40b8,0x4020):
            self.gate_result='accepted' if pc-self.slide==0x40b8 else 'original_uuid'
            cpu.pc=CPU.RETURN
            return True
        if pc-self.slide==0xa5c8: return self.finish(cpu,0x12340000)
        if pc-self.slide==0xa5ec:
            super().handle(cpu,pc)
            value=self.string(cpu.x[0]).encode()+b'\0'
            for offset,byte in enumerate(value): cpu.memory[cpu.x[0]+offset]=byte
            return True
        if pc in (0x33060000,0x33060100):
            key='cornerConfiguration' if pc==0x33060000 else 'interactive'
            self.objects[r].state[key]=cpu.x[2]
            return self.finish(cpu)
        if pc in self.hosts:
            cls,name=self.hosts[pc]
            self.original_calls.append((cls,name,r,list(cpu.x[2:6]),cpu.fp(0)))
            require(sel==self.sel(name),'Original _cmd and typed arguments preserved')
            if name=='searchBgView': return self.finish(cpu,self.objects[r].state['searchBgView'])
            return self.finish(cpu)
        if pc-self.slide==0xa5d4 and r:
            if r==self.MAIN_BUNDLE and name=='bundleIdentifier': return self.finish(cpu,self.text_object(self.identity))
            if r in self.objects:
                if name=='isOpaque': return self.finish(cpu,int(self.objects[r].state.get('opaque',False)))
                if name=='setClipsToBounds:':
                    self.objects[r].state['clipsToBounds']=bool(cpu.x[2])
                    self.objects[self.layer(r)].state['masksToBounds']=bool(cpu.x[2])
                    return self.finish(cpu)
                if name=='setIsAccessibilityElement:':
                    self.objects[r].state['isAccessibilityElement']=cpu.x[2]
                    return self.finish(cpu)
                if name=='isEqual:':
                    other=cpu.x[2]
                    eq=r==other or (other in self.objects and self.objects[r].state.get('value',object())==self.objects[other].state.get('value',object()))
                    return self.finish(cpu,int(eq))
                if name=='insertSubview:atIndex:':
                    child=cpu.x[2]; state=self.objects[child].state
                    require(state['frame'][2]>0 and state['frame'][3]>0,'Final size before attachment')
                    require(state.get('cornerConfiguration'),'Native capsule before attachment')
                    require(self.transaction_stack[-1]['disableActions'],'First attachment in nonanimated transaction')
                    self.attachments.append(child)
                if self.class_names[self.objects[r].cls] in (HOME,CATEGORY,SEARCH):
                    if name in ('searchBgView','bookStoreVCContext'): return self.finish(cpu,self.objects[r].state.get(name,0))
                    method=self.get_method(self.objects[r].cls,sel)
                    if method:
                        cpu.pc=self.methods[method]['imp']; return True
        return super().handle(cpu,pc)

def fixture(data,labels,slide=0,available=True):
    r=Runtime(data,slide,available)
    words=struct.unpack_from('<64I',data,0x800)
    c=CPU(data,r,slide,ranges=[(0x4018,0x4020),(0x800,0x4000),(0x4878,0x48d0),(0x14080,0x800+words[61])])
    c.pointers.update(r.rebase_pointers)
    return c,r

def run(data,labels):
    passed=[]
    def call(c,label,*args,fp=None): return c.run(labels[label],args=list(args),fp_args=fp,max_steps=1500000)
    for slide in (0,0x100000000):
        c,r=fixture(data,labels,slide)
        call(c,'LFQH_FQHInstall')
        before=len([e for e in r.events if e['event']=='method_setImplementation'])
        call(c,'LFQH_FQHInstall')
        require(len([e for e in r.events if e['event']=='method_setImplementation'])==before==(7 if release_version(data)=='1.7.1' else 6 if release_version(data)=='1.6.6' else 5),'Expected fixture hooks, idempotent installation')
        for width in (320,375,390,430,440,768,1024):
            v=r.view('UIView','search',(0,0,width-90,40),r.ROOT,backgroundColor=r.color('original'),userInteractionEnabled=1)
            cat=r.view(CATEGORY,'category',(width-80,0,64,40),r.ROOT,backgroundColor=r.color('category'),userInteractionEnabled=1)
            label=r.label('category_title',cat,(24,0,40,40),'分类')
            controller=r.obj(HOME,'bookstore',searchBgView=v)
            component=r.obj(SEARCH,'searchComponent',bookStoreVCContext=controller)
            snapshots={o:dict(r.objects[o].state) for o in (v,cat,label)}
            c.run(0xa5d4,args=[controller,r.sel('relayout')])
            c.run(0xa5d4,args=[cat,r.sel('layoutSubviews')])
            key=slide+labels['LFQH_SurfaceKey']
            surfaces=[r.associations[(v,key)]]
            require((cat,key) not in r.associations,'Host category strip receives no plugin-owned glass overlay')
            for o,s in zip((v,),surfaces):
                state=r.objects[s].state
                require(state['frame']==r.objects[o].state['bounds'],'Glass fills exact original hit bounds')
                require(not state['userInteractionEnabled'] and state['accessibilityElementsHidden'],'Decoration cannot steal taps or duplicate accessibility')
                require(r.objects[state['effect']].state['style']==0 and r.objects[state['effect']].state['interactive'],'System Regular interactive material')
            for _ in range(8):
                c.run(0xa5d4,args=[controller,r.sel('relayout')])
                c.run(0xa5d4,args=[cat,r.sel('layoutSubviews')])
                require((cat,key) not in r.associations,'Repeated category layout remains host-owned')
            require(surfaces==[r.associations[(v,key)]],'Repeated layout reuses the search surface only')
            theme=r.color('new_theme');r.objects[v].state['backgroundColor']=theme;r.objects[cat].state['backgroundColor']=theme
            for obj,sel in ((component,SEARCH_COLOR),):
                c.run(0xa5d4,args=[obj,r.sel(sel),1,2,3,4],fp_args=[0.375])
                require(r.original_calls[-1][3]==[1,2,3,4] and r.original_calls[-1][4]==0.375,'All integer and floating theme arguments forwarded once')
            for o in (v,cat,label):
                for k in ('frame','userInteractionEnabled','text','font','target','action','clipsToBounds'):
                    require(r.objects[o].state.get(k)==snapshots[o].get(k),'Host layout, content, clipping and interaction remain unchanged')
            r.objects[v].state['bounds']=(0,0,width+120,44)
            call(c,'LFQH_FQHApply',v)
            require(r.objects[surfaces[0]].state['frame']==(0,0,width+120,44),'Resize updates existing material without moving the host')
            r.objects[r.DEFAULTS].state['values']['FanqieAdBlock.GlassDisabled.1']=1
            call(c,'LFQH_FQHApply',v)
            require((cat,key) not in r.associations,'Disabling glass does not alter the host category strip')
            require((v,key) not in r.associations and r.objects[v].state['backgroundColor']==theme,'Disable restores latest search theme')
            r.objects[r.DEFAULTS].state['values']['FanqieAdBlock.GlassDisabled.1']=0
        passed.append('search glass sizing/reuse/theme/restore; category strip remains host-owned at slide '+hex(slide))
    for available in (False,True):
        c,r=fixture(data,labels,available=available)
        require(call(c,'LFQH_FQHCompatibleHost')['result']==1,'Matching app build accepted independently of UUID and glass API')
        c.run(0x4018,check_abi=False)
        require(r.gate_result=='accepted' and r.pool_balance==0,'Actual initializer bypasses UUID only after valid identity and ABI')
        for key,value in [('identity','com.other.app'),('version','7.4.4.1')]:
            if key=='identity': r.identity=value
            else: r.objects[r.MAIN_BUNDLE].state['info']['CFBundleVersion']=value
            require(call(c,'LFQH_FQHCompatibleHost')['result']==0,'Other app or uninspected release rejected')
            c.run(0x4018,check_abi=False)
            require(r.gate_result=='original_uuid' and r.pool_balance==0,'Rejected alternate host returns to original UUID check')
            r.identity='com.dragon.read';r.objects[r.MAIN_BUNDLE].state['info']['CFBundleVersion']='7.4.3.33'
        method=r.get_method(r.classes[HOME],r.sel('relayout'));r.methods[method]['encoding']='v20@0:8B16'
        require(call(c,'LFQH_FQHCompatibleHost')['result']==0,'ABI drift rejected')
        r.methods[method]['encoding']='v16@0:8'
        if not available:
            v=r.view('UIView','ios18_search',(0,0,280,40),r.ROOT,backgroundColor=r.color('ios18_original'))
            before=dict(r.objects[v].state)
            call(c,'LFQH_FQHInstall');call(c,'LFQH_FQHApply',v)
            require(r.objects[v].state==before and not r.attachments,'iOS 18 missing API leaves original controls intact')
            require(not any(e['event']=='method_setImplementation' for e in r.events),'No glass hooks on old system')
        passed.append('identity/ABI gates with glass '+str(available))
    c,r=fixture(data,labels)
    for bounds in [(0,0,0,40),(0,0,200,0),(0,0,float('nan'),40),(0,float('inf'),200,40)]:
        v=r.view('UIView','invalid',bounds,r.ROOT)
        r.objects[v].state['bounds']=bounds
        call(c,'LFQH_FQHApply',v)
        require(not r.attachments,'No invalid-size glass attached')
    r.glass_factory_nil=True
    v=r.view('UIView','factory_nil',(0,0,200,40),r.ROOT,backgroundColor=r.color('keep'))
    before=dict(r.objects[v].state);call(c,'LFQH_FQHApply',v)
    require(r.objects[v].state==before,'Nil glass leaves host unchanged')
    passed.append('invalid layout and nil factory')
    # Read the final image, not source settings: generic ARM64 and old minimum
    # OS avoid device-model/CPU-subtype or iOS 27-only load restrictions.
    import sys
    sys.path.insert(0,str(Path(__file__).resolve().parents[1]/'scripts'))
    from signing_compat import inspect, SYSTEM_LIBRARIES
    info=inspect(data)
    require(info['cpu']==0x100000c and info['subtype']==0 and info['platform']==2,'Generic ARM64 iOS image')
    require(tuple(map(int,info['minimum_os'].split('.'))) <= (18,0,0),'Deployment target permits iOS 18/26/27')
    require(all(d['path'] in SYSTEM_LIBRARIES for d in info['dependencies']),'Only public system library dependencies')
    require(info['install_name']=='@rpath/FanqieX-'+release_version(data)+'.dylib' and info['initializers'],'Correct load identifier and initializer')
    from unwind_audit import decode
    from macho_tools import sections
    slot=next(s for s in sections(data) if s['name']=='__unwind_info')
    entries,_,_=decode(data[slot['offset']:slot['offset']+slot['size']])
    import bisect
    index=bisect.bisect_right([pc for pc,_ in entries],0x401c)-1
    require(entries[index][0]==0x4000 and entries[index][1]!=0,'Foundation return address stays in the original initializer unwind frame')
    passed.append('actual initializer routing, unwind return address and generic ARM64 deployment metadata')
    return passed

if __name__=='__main__':
    p=argparse.ArgumentParser();p.add_argument('candidate',type=Path);p.add_argument('--report',type=Path,required=True);a=p.parse_args()
    data=a.candidate.read_bytes();labels=labels_for(data,a.candidate.with_suffix('.composed.s'),LABELS)
    results=run(data,labels)
    report={'passed':True,'device_tested':False,'cases':results,'viewport_widths':[320,375,390,430,440,768,1024]}
    a.report.write_text(json.dumps(report,indent=2)+'\n');print(json.dumps(report,indent=2))


