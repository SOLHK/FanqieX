"""Candidate ARM64 execution for native buttons and the two clipped long pills.
UIKit/Foundation services are explicit models, not a renderer or device test.
"""
import argparse, copy, json, struct
from pathlib import Path
from arm64 import CPU, require
from test_home_glass165 import Runtime as HomeRuntime, LABELS as HOME_LABELS
from test_feed_viewport import labels_for
NAV='FQReaderSaasNavigationView'
SHELF='SSBookShelfSubViewController'
INSERTS=['FQReaderNavigationBarMoreBtnInsertObject','FQReaderNavigationBarSearchBtnInsertObject',
         'SSReaderNavigationBarDownloadBtnInsertObject','SSReaderNavigationBarCommunitySwitchBtnInsertObject']
EXTRA=['LFQH_FQHButton','LFQH_FQHReader','LFQH_FQHIsDuration','LFQH_AppliedConfigKey','LFQH_ClipsKey','LFQH_OpaqueKey','LRreader_panel','LGstyle_control','LFQH_FQHReaderCount']
class Runtime(HomeRuntime):
    CONFIG_SET=0x33070000
    CONFIG_FACTORY=0x33070100
    REENTRY_RETURN=0x33070200
    def __init__(self,data,slide=0,available=True):
        super().__init__(data,slide,available)
        self._class('UIButtonConfiguration','NSObject')
        self._class('SSBookShelfProfileDurationTipButton','UIButton')
        for cls,parent in [(SHELF,'UIViewController'),*[(name,'NSObject') for name in INSERTS]]:
            self._class(cls,parent)
        for cls,selector,encoding in [(NAV,'layoutSubviews','v16@0:8'),(NAV,'readerInsertedViewThemeConfigChange:','v24@0:8@16'),(SHELF,'viewDidLayoutSubviews','v16@0:8'),*[(name,'getInsertViewSize','{CGSize=dd}16@0:8') for name in INSERTS]]:
            imp=0x33040000+len(self.hosts)*0x100
            self.hosts[imp]=(cls,selector)
            self._add(self.classes[cls],selector,imp,encoding)
        if available:
            self._add(self.metaclasses[self.classes['UIButtonConfiguration']],'glassButtonConfiguration',self.CONFIG_FACTORY,'@16@0:8')
            self._add(self.classes['UIButton'],'setConfiguration:',self.CONFIG_SET,'v24@0:8@16')
        self.configurations=[];self.nil_button_factory=False;self.reenter_owner=0;self.reentered=0
    def handle(self,cpu,pc):
        self.current_cpu=cpu
        r,sel=cpu.x[:2]; name=self.selector_names.get(sel)
        if pc==self.CONFIG_FACTORY:
            return self.finish(cpu,0 if self.nil_button_factory else self.obj('UIButtonConfiguration','native_glass_configuration',style='glass'))
        if pc==self.CONFIG_SET:
            config=cpu.x[2]
            value=self.obj('UIButtonConfiguration','UIKit_copy',**dict(self.objects[config].state)) if config else 0
            self.objects[r].state['configuration']=value
            self.configurations.append((r,value))
            if self.reenter_owner:
                owner=self.reenter_owner;self.reenter_owner=0;self.reentered+=1
                self.resume=(cpu.x[:],cpu.v[:],cpu.sp)
                cpu.x[0]=owner;cpu.x[30]=self.REENTRY_RETURN
                cpu.pc=self.slide+self.labels['LFQH_FQHReader']
                return True
            return self.finish(cpu)
        if pc==self.REENTRY_RETURN:
            cpu.x,cpu.v,cpu.sp=self.resume
            return self.finish(cpu)
        if pc in self.hosts and self.hosts[pc][1]=='getInsertViewSize':
            require(name=='getInsertViewSize','Size hook forwards original _cmd')
            self.original_calls.append((*self.hosts[pc],r,list(cpu.x[2:6]),cpu.fp(0)))
            return self.finish(cpu,fp=self.objects[r].state.get('originalSize',(24.,24.)))
        if pc-self.slide==0xa5d4 and r in self.objects:
            state=self.objects[r].state
            if name in ('configuration','backBtn','insertObjs','getInsertView','searchButton','moreButton','coinButton'):
                return self.finish(cpu,state.get(name,0))
            if name in ('imageForState:','titleForState:','attributedTitleForState:'):
                field={'imageForState:':'images','titleForState:':'titles','attributedTitleForState:':'attributedTitles'}[name]
                return self.finish(cpu,state.get(field,{}).get(cpu.x[2],0))
            if self.class_names[self.objects[r].cls]=='UIButtonConfiguration':
                if name=='setContentInsets:': state['contentInsets']=tuple(cpu.fp(i) for i in range(4));return self.finish(cpu)
                if name in ('setImage:','setTitle:','setAttributedTitle:'):
                    field=name[3].lower()+name[4:-1];state[field]=cpu.x[2];return self.finish(cpu)
        return super().handle(cpu,pc)

def make(data,labels,slide=0,available=True):
    r=Runtime(data,slide,available);r.labels=labels
    words=struct.unpack_from('<64I',data,0x800)
    c=CPU(data,r,slide,ranges=[(0x800,0x4000),(0x4878,0x48d0),(0x702c,0x7d00),(0x14080,0x800+words[61])])
    c.pointers.update(r.rebase_pointers)
    return c,r

def call(c,labels,name,*args): return c.run(labels[name],args=args,max_steps=1500000)
def send(c,r,view,name,*args,fp=None): return c.run(0xa5d4,args=(view,r.sel(name),*args),fp_args=fp,max_steps=1500000)
def button(r,parent,name,frame):
    view=r.view('UIButton',name,frame,parent,clipsToBounds=True,opaque=True)
    image=r.obj('UIImage',name+'_original_artwork',size=(24.,24.))
    r.objects[view].state.update(images={0:image,1:r.obj('UIImage','highlighted')},titles={},attributedTitles={},configuration=0,
                               target=0x123456,action=r.sel('hostAction:'),userInteractionEnabled=1,enabled=1)
    return view

def exercise(data,labels,baseline):
    cases=[]
    for slide in (0,0x100000000):
        c,r=make(data,labels,slide)
        parent_impl=r.methods[r.get_method(r.classes['UIView'],r.sel('layoutSubviews'))]['imp']
        call(c,labels,'LFQH_FQHInstall');count=len([x for x in r.events if x['event']=='method_setImplementation'])
        call(c,labels,'LFQH_FQHInstall')
        require(len([x for x in r.events if x['event']=='method_setImplementation'])==count==12,'Exactly the 12 inspected hooks, installed once')
        require(r.methods[r.get_method(r.classes['UIView'],r.sel('layoutSubviews'))]['imp']==parent_impl,'Never replace UIView implementation')
        nav=r.view(NAV,'reader_nav',(0,0,440,48),r.ROOT)
        back=button(r,nav,'back',(16,12,24,24))
        shelf_label=r.label('already_on_shelf',nav,(62,12,85,24),'已加书架')
        items=[];controls=[back]
        for i,cls in enumerate(INSERTS):
            control=button(r,nav,cls,(170+i*48,6,36,36));controls.append(control)
            item=r.obj(cls,'reader_insert',getInsertView=control,originalSize=(24.,24.));items.append(item)
            send(c,r,item,'getInsertViewSize')
            require(tuple(c.fp(i) for i in range(2))==(36.,36.),'Native reader layout receives a real 36pt button size')
        book_item=r.obj('NSObject','not_selected_text_insert',getInsertView=shelf_label)
        items.append(book_item)
        r.objects[nav].state.update(backBtn=back,insertObjs=r.obj('NSArray','insertObjs',items=items))
        saved={b:copy.deepcopy(r.objects[b].state) for b in controls+[shelf_label]}
        r.reenter_owner=nav
        send(c,r,nav,'layoutSubviews')
        require(r.reentered==1,'Native configuration layout reentry exercised')
        require(r.objects[back].state['frame']==(10.,6.,36.,36.),'Back button enlarges its real hit frame around the existing center')
        require(r.objects[shelf_label].state==saved[shelf_label],'Unmarked bookshelf label remains original')
        require(len(r.configurations)==5,'All five requested reader icons receive native glass')
        require(call(c,labels,'LFQH_FQHReaderCount',nav)['result']==5,'Diagnostic count reports five actually styled controls')
        for b in controls:
            st=r.objects[b].state;conf=r.objects[st['configuration']].state
            require(conf['style']=='glass' and conf['image']==saved[b]['images'][0],'Native glass factory preserves host artwork')
            require(st['images']==saved[b]['images'] and st['target']==saved[b]['target'] and st['action']==saved[b]['action'],'Original images and events survive')
            require(st['userInteractionEnabled']==1 and st['enabled']==1,'Original UIButton still owns touch and enabled state')
            require(not st['clipsToBounds'] and not st['opaque'],'No old owner clipping or opaque composition')
        # Existing legacy reader cleanup must not remove this new system style.
        call(c,labels,'LRreader_panel',nav)
        require(all(r.objects[b].state['configuration'] for b in controls),'Legacy reader cleanup leaves native configurations intact')
        # UIKit copies configurations during state transitions. Snapshot identity
        # must not cause the plugin to capture its own glass as the original.
        for b in controls:
            old=r.objects[b].state['configuration']
            r.objects[b].state['configuration']=r.obj('UIButtonConfiguration','UIKit_state_copy',**dict(r.objects[old].state))
        for _ in range(6): send(c,r,nav,'layoutSubviews')
        require(len(r.configurations)==5,'No configuration recreation during layout/highlight copies')
        r.objects[r.DEFAULTS].state['values']['FanqieAdBlock.GlassDisabled.1']=1
        send(c,r,nav,'layoutSubviews')
        require(all(r.objects[b].state['configuration']==0 and r.objects[b].state['clipsToBounds'] and r.objects[b].state['opaque'] for b in controls),'Disable restores configurations and owner flags')
        require(r.objects[back].state['frame']==saved[back]['frame'],'Disable restores the back hit frame')
        require(call(c,labels,'LFQH_FQHReaderCount',nav)['result']==0,'Disabled diagnostic count returns to zero')
        send(c,r,items[0],'getInsertViewSize');require((c.fp(0),c.fp(1))==(24.,24.),'Disable returns original reader layout size')
        r.objects[r.DEFAULTS].state['values']['FanqieAdBlock.GlassDisabled.1']=0
        top=r.view('UIView','shelf_top',(0,0,100,44),r.ROOT)
        search=button(r,top,'shelf_search',(10,10,24,24));more=button(r,top,'shelf_more',(58,10,24,24))
        vc=r.obj(SHELF,'shelf_vc',searchButton=search,moreButton=more)
        send(c,r,vc,'viewDidLayoutSubviews')
        require(all(r.objects[b].state['configuration'] for b in (search,more)),'Both requested shelf toolbar buttons use system configurations')
        require(r.objects[search].state['frame']==(4.,4.,36.,36.) and r.objects[more].state['frame']==(52.,4.,36.,36.),'Shelf buttons get 36pt glass and matching hit bounds at unchanged centers')
        cases.append('reader five, bookshelf two, native sizes, events, reentry, restoration at '+hex(slide))
    # The same positive fixture demonstrates the old clipping defect in 1.6.5.
    for payload,is_old in [(baseline,True),(data,False)]:
        names=HOME_LABELS if is_old else HOME_LABELS+EXTRA
        if is_old:
            from build_plugin import compose_assembly
            from test_feed_viewport import ROOT
            import tempfile
            with tempfile.TemporaryDirectory() as folder:
                p=Path(folder)/'165.s';p.write_text(compose_assembly(ROOT/'repair162/floating_bar_162.s','1.6.5'))
                own=labels_for(payload,p,HOME_LABELS)
        else: own=labels
        c,r=make(payload,own)
        parent=r.view('UIView','header',(0,0,440,80),r.ROOT,clipsToBounds=True)
        for cls,width,height in [('UIView',344,38),('SSBookShelfProfileDurationTipButton',148,26)]:
            v=r.view(cls,'long_pill',(12,10,width,height),parent,clipsToBounds=True,opaque=True,backgroundColor=r.color('original'))
            child=r.label('original_content',v,(8,0,width-16,height),'content')
            snapshot=copy.deepcopy(r.objects[child].state)
            call(c,own,'LFQH_FQHApply',v)
            require(r.objects[v].state['clipsToBounds']==is_old and r.objects[v].state['opaque']==is_old,'1.6.5 negative control / 1.6.6 owner clipping repair')
            require(r.objects[parent].state['clipsToBounds'] and r.objects[child].state==snapshot,'Ancestor and child clipping/layout are unchanged')
            glass=r.associations[(v,r.slide+own['LFQH_SurfaceKey'])]
            require(r.objects[glass].state['frame']==(0,0,width,height),'Full long capsule stays inside its own owner bounds')
            if not is_old:
                header=r.view('SS525BookShelfSubHeaderView','duration_header',(0,0,440,80),r.ROOT)
                r.reparent(v,header);r.objects[header].state['coinButton']=v
                call(c,own,'LGstyle_control',v)
                require(r.associations[(v,r.slide+own['LFQH_SurfaceKey'])]==glass and not r.associations.get((v,r.slide+0xeb8b)),'Legacy duration entry shares one full-bounds material')
                r.objects[r.DEFAULTS].state['values']['FanqieAdBlock.GlassDisabled.1']=1
                call(c,own,'LFQH_FQHApply',v)
                require(r.objects[v].state['clipsToBounds'] and r.objects[v].state['opaque'],'Long-pill disabled state restores old clipping/opacity')
                r.objects[r.DEFAULTS].state['values']['FanqieAdBlock.GlassDisabled.1']=0
        cases.append('clipping negative control' if is_old else 'clipping fix and actual duration entry')
    c,r=make(data,labels,available=False)
    call(c,labels,'LFQH_FQHInstall')
    b=button(r,r.ROOT,'old_system',(0,0,24,24));saved=copy.deepcopy(r.objects[b].state)
    call(c,labels,'LFQH_FQHButton',b)
    require(r.objects[b].state==saved and not r.configurations,'Missing APIs preserve old controls')
    cases.append('missing native APIs')
    return cases

if __name__=='__main__':
    p=argparse.ArgumentParser();p.add_argument('candidate',type=Path);p.add_argument('--baseline',type=Path,required=True);p.add_argument('--report',type=Path,required=True);a=p.parse_args()
    data=a.candidate.read_bytes();labels=labels_for(data,a.candidate.with_suffix('.composed.s'),HOME_LABELS+EXTRA)
    result={'passed':True,'device_tested':False,'cases':exercise(data,labels,a.baseline.read_bytes()),'limits':['Explicit UIKit/Foundation boundaries; no GPU rendering, device touch or optical gap measurement.']}
    a.report.write_text(json.dumps(result,indent=2)+'\n');print(json.dumps(result,indent=2))
