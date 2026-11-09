"""Execute the aligned background implementation with realistic host rectangles.
The host layout, UIKit services and rendering remain explicit boundaries.
"""
import argparse,copy,json,struct,tempfile
from pathlib import Path
from arm64 import CPU,require
from test_control_glass166 import Runtime as PreviousRuntime,NAV,SHELF,INSERTS,send
from test_home_glass165 import LABELS as HOME_LABELS
from test_feed_viewport import labels_for,ROOT
from build_plugin import compose_assembly
EXTRA=['LFQH_FQHButton','LFQH_FQHReader','LFQH_FQHShelf','LFQH_FQHIconGlass','LFQH_FQHReaderCount','Lrecord_named','LRreader_panel']
class Runtime(PreviousRuntime):
    def __init__(self,data,slide=0,available=True):
        super().__init__(data,slide,available)
        self._class('SSReaderNavigationBarDownloadButton','UIView')
        self.records=[];self.host_mutations=[];self.host_views=set();self.no_hit_api=False
    def responds(self,receiver,name):
        if name in ('btd_hitTestEdgeInsets','setBtd_hitTestEdgeInsets:'):
            return not self.no_hit_api and self.is_kind(receiver,self.classes['UIView'])
        return super().responds(receiver,name)
    def handle(self,cpu,pc):
        self.current_cpu=cpu
        if pc==self.slide+self.labels['Lrecord_named']:
            event=self.string(cpu.x[0])
            self.records.append((event,self.native(cpu.x[1])))
            return self.finish(cpu)
        r,sel=cpu.x[:2];name=self.selector_names.get(sel)
        if pc==self.CONFIG_SET and r in self.host_views and not self.is_kind(r,self.classes['UIImageView']): self.host_mutations.append(('configuration',r))
        if pc-self.slide==0xa5d4:
            if r in self.classes.values() and self.class_names[r]=='FQXGlassBackground167' and name in ('new','alloc'):
                value=self.view('FQXGlassBackground167','empty_native_glass')
                self.retain_balance[value]=1
                return self.finish(cpu,value)
            if r in self.objects:
                state=self.objects[r].state
                if name in ('setFrame:','setBounds:','setCenter:','setConfiguration:') and r in self.host_views and not self.is_kind(r,self.classes['UIImageView']):
                    self.host_mutations.append((name,r))
                if name in ('imageView','searchAndMoreView'): return self.finish(cpu,state.get(name,0))
                if name=='btd_hitTestEdgeInsets': return self.finish(cpu,fp=state.get('hitInsets',(0.,0.,0.,0.)))
                if name=='setBtd_hitTestEdgeInsets:':
                    state['hitInsets']=tuple(cpu.fp(i) for i in range(4));return self.finish(cpu)
                if name in ('isSelected','isHighlighted'):
                    return self.finish(cpu,int(state.get(name[2:].lower(),False)))
                if name in ('setHighlighted:','setSelected:','setEnabled:'):
                    state[name[3].lower()+name[4:-1]]=bool(cpu.x[2]);return self.finish(cpu)
                if name=='insertSubview:atIndex:' and self.class_names[self.objects[cpu.x[2]].cls]=='FQXGlassBackground167':
                    child=cpu.x[2];cs=self.objects[child].state
                    require(cs['frame'][2:] in ((36.,36.),(28.,28.)),'Final native background bounds before insertion')
                    conf=self.objects[cs['configuration']].state
                    require(conf['style']=='glass' and not conf.get('image') and not conf.get('title'),'Glass configuration contains no copied host image/title')
                    require(self.transaction_stack[-1]['disableActions'],'Background publication is nonanimated')
                    self.reparent(child,r);state['subviews'].remove(child);state['subviews'].insert(cpu.x[3],child)
                    self.attachments.append(child)
                    return self.finish(cpu)
        return super().handle(cpu,pc)

def machine(data,labels,slide=0,available=True):
    r=Runtime(data,slide,available);r.labels=labels
    words=struct.unpack_from('<64I',data,0x800)
    c=CPU(data,r,slide,ranges=[(0x800,0x4000),(0x4878,0x48d0),(0x702c,0x7d00),(0x14080,0x800+words[61])])
    c.pointers.update(r.rebase_pointers);return c,r

def call(c,labels,name,*args): return c.run(labels[name],args=args,max_steps=1500000)
def icon(r,parent,name,frame,*,download=False,canvas=(0,0,24,24),image_size=(64,64)):
    cls='SSReaderNavigationBarDownloadButton' if download else 'UIButton'
    b=r.view(cls,name,frame,parent,clipsToBounds=False,opaque=True)
    image=r.obj('UIImage','PRIVATE_ORIGINAL_ASSET',size=image_size)
    iv=r.view('UIImageView',name+'_original_image',canvas,b)
    r.objects[iv].state.update(image=image,contentMode=1)
    r.objects[b].state.update(imageView=iv,images={0:image},titles={},attributedTitles={},configuration=0,
                              hitInsets=(0.,0.,0.,0.),enabled=True,selected=False,highlighted=False,
                              userInteractionEnabled=True,control_targets=[(0x123456,r.sel('hostTap:'),64)])
    if download:
        r.objects[b].state['defaultIconView']=iv
        for child in ('completedIconView','progressArrowView','badgeLabel'):
            r.view('UIView',child,canvas,b)
    return b

def material(c,r,labels,b): return call(c,labels,'LFQH_FQHIconGlass',b)['result']
def hit_contains(r,v,rect):
    st=r.objects[v].state;x,y,w,h=st['bounds'];top,left,bottom,right=st.get('hitInsets',(0,0,0,0))
    a,b,c,d=rect
    return x+left<=a and y+top<=b and x+w-right>=a+c and y+h-bottom>=b+d

def exercise(data,labels,baseline):
    results=[]
    for slide in (0,0x100000000):
        c,r=machine(data,labels,slide)
        size_methods={cl:r.methods[r.get_method(r.classes[cl],r.sel('getInsertViewSize'))]['imp'] for cl in INSERTS}
        call(c,labels,'LFQH_FQHInstall')
        require(len([e for e in r.events if e['event']=='method_setImplementation'])==8,'Only eight targeted hooks; no size-provider replacement')
        for cl,imp in size_methods.items():require(r.methods[r.get_method(r.classes[cl],r.sel('getInsertViewSize'))]['imp']==imp,'Original insert dimensions remain authoritative')
        nav=r.view(NAV,'reader',(12,64,416,44),r.ROOT)
        back=icon(r,nav,'back',(12,10,24,24),canvas=(0,0,24,24))
        controls=[back];items=[]
        for i,cl in enumerate(INSERTS):
            b=icon(r,nav,cl,(180+i*48,10,24,24),download='Download' in cl,image_size=(96,96))
            controls.append(b);items.append(r.obj(cl,'insert',getInsertView=b,originalSize=(24.,24.)))
        text=r.label('shelf_text',nav,(60,10,90,24),'已加书架')
        r.objects[nav].state.update(backBtn=back,insertObjs=r.obj('NSArray','items',items=items+[r.obj('NSObject','unrelated',getInsertView=text)]))
        r.host_views.update([nav,text,*controls,*[v for b in controls for v in r.objects[b].state['subviews']]])
        before={v:copy.deepcopy(r.objects[v].state) for v in r.host_views}
        r.reenter_owner=nav
        send(c,r,nav,'layoutSubviews')
        require(r.reentered==1,'Configuration publication reenters the guarded reader callback')
        for b in controls:
            glass=material(c,r,labels,b);st=r.objects[glass].state
            require(st['frame']==((0.,-6.,36.,36.) if b==back else (-6.,-6.,36.,36.)),'Every background centered on original 24pt artwork, including custom download')
            require(hit_contains(r,b,st['frame']),'Native visible background is within the expanded original hit area')
            require(st['userInteractionEnabled']==0 and st['accessibilityElementsHidden'],'Background cannot steal events/accessibility')
        require(r.objects[r.objects[back].state['imageView']].state['frame']==(12.,0.,24.,24.),'Back glyph moves with its lens; visible center 18 and left lens edge 16 in host parent')
        require(not r.host_mutations,'Production never sets host frame/bounds/center/configuration')
        for v in before:
            for field in ('frame','bounds','image','imageView','images','configuration','contentMode','text','font'):
                require((field=='frame' and v==r.objects[back].state['imageView']) or r.objects[v].state.get(field)==before[v].get(field),'Host content and geometry unchanged: '+field)
        original_targets={b:before[b]['control_targets'] for b in controls}
        for b in controls:
            if r.is_kind(b,r.classes['UIControl']):
                rows=r.objects[b].state['control_targets'];require(all(row in rows for row in original_targets[b]) and len(rows)==3,'Passive observers preserve original touch actions')
                glass=material(c,r,labels,b)
                send(c,r,glass,'fqx167_down:',b);require(r.objects[glass].state['highlighted'],'Native press highlight')
                send(c,r,glass,'fqx167_up:',b);require(not r.objects[glass].state['highlighted'],'Native cancel/up highlight reset')
        # Safe-area/header movement belongs entirely to the host. Repeated
        # callbacks and nonzero parent origins cannot accumulate a plugin offset.
        for i in range(100):
            r.objects[nav].state['frame']=(12.,64.+(i%3)*12,416.,44.)
            r.uptime+=1.01
            send(c,r,nav,'layoutSubviews')
        require(not r.host_mutations and len(r.configurations)==5,'100 layouts reuse backgrounds without host/config mutations')
        glass=material(c,r,labels,back)
        # UIKit may animate its own pressed geometry. An unchanged host layout
        # must not overwrite that animation by treating the presentation as drift.
        r.objects[glass].state['frame']=(-5.,-5.,34.,34.)
        send(c,r,nav,'layoutSubviews')
        require(r.objects[glass].state['frame']==(-5.,-5.,34.,34.),'Unchanged layout does not reset UIKit press geometry')
        r.objects[glass].state['frame']=(-6.,-6.,36.,36.)
        call(c,labels,'LRreader_panel',nav)
        require(call(c,labels,'LFQH_FQHReaderCount',nav)['result']==5,'Legacy cleanup preserves the five owned backgrounds')
        require(len([e for e,_ in r.records if e=='controlLayout167'])>0,'Actual geometry recorded')
        encoded=json.dumps(r.records)
        require('PRIVATE_ORIGINAL_ASSET' not in encoded and '已加书架' not in encoded,'Geometry diagnostics omit content and images')
        for event,row in r.records:
            if event=='controlLayout167': require(set(row)=={'role','hostFrame','hostBounds','imageRect','glassRect','windowRect'},'Geometry-only event schema')
        r.objects[r.DEFAULTS].state['values']['FanqieAdBlock.GlassDisabled.1']=1
        send(c,r,nav,'layoutSubviews')
        for b in controls:
            require(not material(c,r,labels,b) and r.objects[b].state['hitInsets']==(0.,0.,0.,0.),'Disable removes owned glass and restores hit insets')
            require(r.objects[b].state['control_targets']==original_targets[b],'Disable removes only plugin observers')
        r.objects[r.DEFAULTS].state['values']['FanqieAdBlock.GlassDisabled.1']=0
        parent=r.view('UIView','shelf_header',(348,72,56,24),r.ROOT)
        search=icon(r,parent,'shelf_search',(0,0,24,24));more=icon(r,parent,'shelf_more',(32,0,24,24))
        vc=r.obj(SHELF,'shelf',searchButton=search,moreButton=more,searchAndMoreView=parent)
        r.host_views.update((parent,search,more))
        for y in (72.,92.,64.,104.,72.):
            r.objects[parent].state['frame']=(348.,y,56.,24.)
            send(c,r,vc,'viewDidLayoutSubviews')
            require(r.objects[parent].state['frame']==(348.,y,56.,24.),'Toolbar stays at host-selected safe-area/header origin')
            require(r.objects[search].state['frame']==(0,0,24,24) and r.objects[more].state['frame']==(32,0,24,24),'Shelf buttons retain host-local frames')
            require(hit_contains(r,parent,(-2.,-2.,60.,28.)),'Container also admits touches on both visible outer rims')
        a=r.objects[material(c,r,labels,search)].state['frame'];z=r.objects[material(c,r,labels,more)].state['frame']
        require(32+z[0]-(a[0]+a[2])==4,'Device-reported 32pt centers retain a 4pt glass gap')
        require(not r.host_mutations,'No host geometry mutation anywhere in shelf/reader paths')
        require(r.objects[r.objects[search].state['imageView']].state['frame']==(3.,3.,18.,18.),'Search artwork has balanced 5pt padding in 28pt lens')
        require(r.objects[r.objects[more].state['imageView']].state['frame']==(-1.5,3.,18.,18.),'More asset transparent padding is compensated at the image, not by shifting the lens')
        # A deliberately off-center original image still determines the lens
        # center without altering its host or its image view.
        r.objects[search].state['bounds']=(5.,7.,24.,24.)
        iv=r.objects[search].state['imageView'];r.objects[iv].state['frame']=(7.,10.,18.,16.);r.objects[iv].state['bounds']=(0.,0.,18.,16.)
        send(c,r,vc,'viewDidLayoutSubviews')
        glass=material(c,r,labels,search)
        require(r.objects[glass].state['frame']==(3.,5.,28.,28.),'Nonzero bounds and asymmetric image rectangles stay centered')
        replacement=r.view('UIImageView','host_recreated_image',(9.,9.,16.,20.),search)
        r.objects[search].state['imageView']=replacement
        send(c,r,vc,'viewDidLayoutSubviews')
        require(r.objects[glass].state['frame']==(3.,5.,28.,28.),'Host-recreated image drives the new center without a stale image reference')
        r.objects[r.DEFAULTS].state['values']['FanqieAdBlock.GlassDisabled.1']=1
        send(c,r,vc,'viewDidLayoutSubviews')
        require(r.objects[parent].state['hitInsets']==(0.,0.,0.,0.),'Shelf container hit expansion is restored on disable')
        require(not material(c,r,labels,search) and not material(c,r,labels,more),'Shelf backgrounds removed on disable')
        require(r.objects[search].state['imageView']==replacement and r.objects[replacement].state['frame']==(9.,9.,16.,20.),'Disable preserves the latest host-created artwork and layout')
        results.append('host frame/intrinsic content preservation; seven buttons; custom download; nonzero origins; 100 layouts; hit areas; events; restoration; slide '+hex(slide))
    # Execute the actual 1.6.6 predecessor as a negative control: its 36pt
    # wrapper leaves a host's 24pt child drawing at the old top-left origin.
    with tempfile.TemporaryDirectory() as folder:
        p=Path(folder)/'old.s';p.write_text(compose_assembly(ROOT/'repair162/floating_bar_162.s','1.6.6'))
        old_labels=labels_for(baseline,p,HOME_LABELS+['LFQH_FQHReader'])
    c,r=machine(baseline,{**old_labels,'Lrecord_named':-1})
    call(c,old_labels,'LFQH_FQHInstall')
    nav=r.view(NAV,'old_nav',(0,64,440,44),r.ROOT)
    back=icon(r,nav,'old_back',(16,10,24,24))
    r.objects[nav].state.update(backBtn=back,insertObjs=r.obj('NSArray','empty',items=[]))
    r.host_views.add(back)
    send(c,r,nav,'layoutSubviews')
    require(r.host_mutations and r.objects[back].state['frame'][2:]==(36.,36.),'1.6.6 changes original button geometry/configuration')
    iv=r.objects[back].state['imageView'];require(r.objects[iv].state['frame']==(0,0,24,24),'Original host drawing still uses 24pt canvas')
    require(r.objects[back].state['bounds'][2]/2 != r.objects[iv].state['frame'][2]/2,'Negative control reproduces the icon/background center mismatch')
    results.append('actual 1.6.6 negative control: native configuration/geometry mutate host while custom 24pt drawing stays anchored')
    for available in (False,True):
        c,r=machine(data,labels,available=available)
        if available:r.nil_button_factory=True
        b=icon(r,r.ROOT,'unavailable',(0,0,24,24));before=copy.deepcopy(r.objects[b].state);r.host_views.add(b)
        call(c,labels,'LFQH_FQHButton',b)
        require(r.objects[b].state==before and not r.host_mutations,'Unavailable or nil factory leaves original controls untouched')
    results.append('missing API and nil factory')
    return results
if __name__=='__main__':
    p=argparse.ArgumentParser();p.add_argument('candidate',type=Path);p.add_argument('--baseline',type=Path,required=True);p.add_argument('--report',type=Path,required=True);a=p.parse_args()
    data=a.candidate.read_bytes();labels=labels_for(data,a.candidate.with_suffix('.composed.s'),HOME_LABELS+EXTRA)
    report={'passed':True,'device_tested':False,'cases':exercise(data,labels,a.baseline.read_bytes()),'limits':['UIKit layout/graphics boundaries are explicit models. No screenshot pixel acceptance or actual iOS touch routing.']}
    a.report.write_text(json.dumps(report,indent=2)+'\n');print(json.dumps(report,indent=2))
