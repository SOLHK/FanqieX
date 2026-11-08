#!/usr/bin/env python3
"""1.6.0 native reader regression suite, executing the candidate's ARM64.

The D3F device evidence supplied a 1.5.9 reason=18 failure, not a benchmark.
This suite rejects that dependency, exercises real patched menu/bottom tails,
and enforces complete-caption glass within existing hit bounds. Objective-C /
UIKit remain modeled boundaries; no phone rendering or tap latency is claimed.
"""
import argparse
import hashlib
import json
from pathlib import Path
import traceback

from arm64 import CPU, require
from reader_runtime import ReaderRuntime
from test_reader_fastpath import reader_back, mutate_count, log_records
import test_reader_fastpath as prior
from test_control_geometry import frozen, unchanged, near
import test_control_geometry as geometry

SURFACE = 0xeb8b
RUNS = []


def make(data, validation, **options):
    rt = ReaderRuntime(data, **options)
    ranges = [(0x800, 0x4000), (0x4878, 0x48d0), (0x5d04, 0x5e3c),
              (0x6274, 0x62ac), (0x702c, 0x78b8), (0x7ac4, 0x7d00),
              (0x80e0, 0x81b8), (0x14000, validation['extension_directory']['code_end'])]
    cpu = CPU(data, rt, slide=rt.slide, ranges=ranges)
    cpu.pointers.update(rt.rebase_pointers)
    RUNS.append((cpu, rt))
    return cpu, rt


def call(cpu, entry, *args, **options):
    return cpu.run(entry, args=list(args), max_steps=3000000, **options)


def surface(rt, control):
    return rt.associations.get((control, rt.slide+SURFACE), 0)


def within(rt, control, glass):
    require(glass, 'Native material exists')
    f, b = rt.objects[glass].state['frame'], rt.objects[control].state['bounds']
    require(f[0] >= b[0]-1e-8 and f[1] >= b[1]-1e-8 and
            f[0]+f[2] <= b[0]+b[2]+1e-8 and f[1]+f[3] <= b[1]+b[3]+1e-8,
            'Visible reader glass remains inside existing hit bounds: '+repr((f, b)))
    require(not rt.objects[glass].state['userInteractionEnabled'],
            'Decorative material cannot take over UIKit touch tracking')
    return f


def native_failure18(data, validation, *, slide=0, getter='image'):
    cpu, rt = make(data, validation, slide=slide, symbol_available=True,
                   ci_calibration_corrupt=True)
    owner, control, icon = reader_back(rt)
    # Device log reports image frame/bounds [0,0,24,24], UIButton parent,
    # scale=3, orientation=0, reason=18, shift=0. Control frame below remains
    # an explicit test fixture because the log did not report its bounds.
    rt.objects[icon].state.update(frame=(0, 0, 24, 24), contentMode=0)
    original = rt.rgba_image('device_like_arrow', 72, 72, range(32), scale=3)
    rt.objects[icon].state['image'] = original
    if getter == 'button':
        rt.objects[owner].state['leftBackIconView'] = control
    elif getter == 'none':
        rt.objects[owner].state.pop('leftBackIconView', None)
    before = frozen(rt, [owner, control])
    call(cpu, validation['reader_directory']['reader_panel'], owner)
    installed = rt.objects[icon].state['image']
    require(installed != original and rt.objects[installed].name == 'native_chevron_backward',
            'The confirmed leading reader role uses the public system symbol')
    require(rt.objects[icon].state['contentMode'] == 4, 'Native image uses Center drawing')
    near(rt.objects[icon].state['frame'], (10, 10, 24, 24), 'Image view centred in actual 44pt hit area')
    near(within(rt, control, surface(rt, control)), (0, 0, 44, 44), '44pt native back material')
    require(rt.ci_context_requests == rt.ci_render_calls == rt.ci_calibration_calls == rt.ci_bundle_loads == 0,
            'Reader path does not initialize CoreImage, calibrate rows, or read a bitmap')
    rt.events.clear()
    for _ in range(10):
        call(cpu, validation['reader_directory']['reader_panel'], owner)
    require(not any(mutate_count(rt).values()), 'Ten settled layouts have zero visual mutations')
    require(rt.symbol_requests == 1, 'Native symbol is reused, not rebuilt per layout or tap')
    unchanged(rt, before)
    rt.objects[rt.DEFAULTS].state['values']['FanqieAdBlock.GlassDisabled.1'] = 1
    call(cpu, validation['reader_directory']['reader_panel'], owner)
    require(rt.objects[icon].state['image'] == original and rt.objects[icon].state['contentMode'] == 0,
            'Disable restores original artwork and content mode')
    near(rt.objects[icon].state['frame'], (0, 0, 24, 24), 'Disable restores original icon centre')
    require(not surface(rt, control), 'Disable removes native decoration')
    return {'getter': getter, 'slide': hex(slide), 'native_symbol_requests': 1,
            'core_image_calls': 0, 'hit_bounds': [0, 0, 44, 44]}


def legacy_failure18(data, validation):
    cpu, rt = make(data, validation, symbol_available=True, ci_calibration_corrupt=True)
    owner, control, icon = reader_back(rt)
    original = rt.rgba_image('legacy_arrow', 72, 72, range(32))
    rt.objects[icon].state.update(image=original, contentMode=0, frame=(10, 10, 24, 24))
    call(cpu, validation['reader_directory']['reader_panel'], owner)
    require(rt.ci_calibration_calls > 0, 'Real 1.5.9 instructions enter the bitmap calibration dependency')
    require(rt.objects[icon].state['image'] == original and rt.objects[icon].state['frame'] == (10, 10, 24, 24),
            'Real 1.5.9 leaves the rejected back glyph uncorrected')
    reasons = []
    for p, o in rt.objects.items():
        if not rt.is_kind(p, rt.classes['NSDictionary']):
            continue
        items = o.state.get('items', {})
        if 'sequence' in items and 'event' in items and rt.string_value(items['event']) == 'reader_back_alignment':
            reasons.append(rt.native(p)['data']['readerBackReason'])
    require(18 in reasons, 'Negative control reproduces the actual logged reason 18')
    return {'reasons': reasons, 'core_image_context_requests': rt.ci_context_requests}


def property_ownership(data, validation):
    cases=[]
    for replace_image, replace_mode in [(True, False), (False, True), (True, True)]:
        cpu, rt = make(data, validation, symbol_available=True)
        owner, control, icon = reader_back(rt)
        old = rt.objects[icon].state['image']; rt.objects[icon].state['contentMode'] = 0
        call(cpu, 0x7848, control)
        latest = rt.obj('UIImage', 'host_new_artwork', size=(24, 24))
        if replace_image: rt.objects[icon].state['image'] = latest
        if replace_mode: rt.objects[icon].state['contentMode'] = 7
        call(cpu, validation['reader_directory']['back_restore'], icon)
        require(rt.objects[icon].state['image'] == (latest if replace_image else old),
                'Image restoration does not overwrite an independent host change')
        require(rt.objects[icon].state['contentMode'] == (7 if replace_mode else 0),
                'Mode ownership restores independently of image ownership')
        cases.append({'host_image_changed': replace_image, 'host_mode_changed': replace_mode})
    return cases


def unavailable_and_allocations(data, validation):
    cases=[]
    for options in [dict(symbol_available=False), dict(symbol_available=True, symbol_nil=True),
                    dict(symbol_available=True, snapshot_fail_at=1), dict(symbol_available=True, snapshot_fail_at=2),
                    dict(symbol_available=True, weak_fail_at=1), dict(symbol_available=True, weak_fail_at=2),
                    dict(symbol_available=True, weak_fail_at=3)]:
        cpu, rt = make(data, validation, **options)
        owner, control, icon = reader_back(rt)
        before = (rt.objects[icon].state['image'], rt.objects[icon].state['contentMode'],rt.objects[icon].state['frame'])
        call(cpu, 0x7848, control)
        after = (rt.objects[icon].state['image'], rt.objects[icon].state['contentMode'],rt.objects[icon].state['frame'])
        require(after == before, 'Unavailable APIs or state allocation cannot leave partial image mutations')
        require(rt.ci_render_calls == 0, 'Unavailable native symbol never falls back to a blocking pixel renderer')
        cases.append(options)
    return cases


def narrow_more(data, validation, *, legacy=False):
    cpu, rt = make(data, validation)
    owner = rt.view('FQReaderSaasNavigationView', 'nav', (0,64,440,44), rt.ROOT)
    control = rt.view('UIButton', 'more', (404,0,24,44), owner)
    rt.objects[control].state.update(target=0x1234, action=0x5678)
    icon = rt.image_view('more_icon', control, (0,10,24,24))
    before = frozen(rt,[owner,control,icon])
    call(cpu, 0x7848, control)
    f = rt.objects[surface(rt,control)].state['frame']
    if legacy:
        require(f[0] < 0 and f[0]+f[2] > 24,
                'Real 1.5.9 creates a visible untappable rim around a narrow More button')
    else:
        within(rt,control,surface(rt,control))
        near(f,(0,10,24,24),'Restricted More surface fits the real narrow host hit region')
    unchanged(rt,before)
    return {'material':f, 'host_hit_bounds':[0,0,24,44]}


def bottom_buttons(data, validation, nested=False):
    cpu, rt = make(data, validation)
    owner=rt.view('FQReaderBottomButtonContainerView','bottom',(0,800,440,96),rt.ROOT)
    buttons=[]
    for index,title in enumerate(('目录','夜间','设置','改编剧场')):
        button=rt.view('SSReaderBottomToolButton',title,(index*110,12,100,72),owner)
        rt.objects[button].state.update(target=0x2200+index,action=0x3300+index)
        image_parent=rt.view('UIButton','nested_icon',(30,2,40,40),button) if nested else button
        icon=rt.image_view('icon',image_parent,(8,8,24,24) if nested else (38,10,24,24))
        label=rt.label('caption',button,(10,40,80,20),title,intrinsic=(len(title)*14,20),line_height=18)
        buttons.append((button,icon,label))
    before=frozen(rt,[owner]+[p for triple in buttons for p in triple])
    call(cpu,validation['reader_directory']['reader_panel'],owner)
    frames=[]
    for button,icon,label in buttons:
        f=within(rt,button,surface(rt,button))
        require(f[2] >= 68 and f[3] >= 64,'Bottom material has room for the complete icon-caption stack')
        require(f[1] <= 2 and f[1]+f[3] >= 66,'Shape includes caption with real vertical spacing')
        frames.append(f)
        require(not surface(rt,icon),'No second image-only glass inside a complete bottom control')
    unchanged(rt,before)
    rt.events.clear();call(cpu,validation['reader_directory']['reader_panel'],owner)
    require(not any(mutate_count(rt).values()),'Repeated bottom layout has no visual setter churn')
    return {'frames':frames,'nested_icon_button':nested,'host_frames_and_actions_unchanged':True}


def listen_background(data,validation):
    cpu,rt=make(data,validation)
    button=rt.view('SSReaderFloatingCommonButton','listen',(370,680,56,56),rt.ROOT)
    rt.objects[button].state.update(target=0x1234,action=0x5678)
    label=rt.label('listen_caption',button,(8,8,40,40),'听',intrinsic=(28,34),line_height=34)
    original=rt.color('original_gray');rt.objects[button].state['backgroundColor']=original
    white=rt.color('original_white');rt.objects[label].state['textColor']=white
    before=frozen(rt,[button,label]);call(cpu,0x7848,button)
    f=within(rt,button,surface(rt,button));near(f,(1,1,54,54),'Listen uses a padded circular glass')
    require(rt.objects[button].state['backgroundColor']==rt.color('clearColor'),'Opaque listen fill is cleared underneath glass')
    require(rt.objects[label].state['textColor']==rt.color('labelColor'),'Listen caption uses semantic contrast over transparent glass')
    rt.objects[rt.DEFAULTS].state['values']['FanqieAdBlock.GlassDisabled.1']=1
    call(cpu,0x7848,button)
    require(rt.objects[button].state['backgroundColor']==original,'Disable restores exact host background')
    require(rt.objects[label].state['textColor']==white,'Disable restores the original white caption')
    require(not surface(rt,button),'Disable removes listen decoration');unchanged(rt,before)
    return {'frame':f,'background_restored':True}


def panel_tails(data,validation,old=False):
    cases=[]
    for cls,alias,entry in [('FQReaderSaasNavigationView','fqab_readerNav',0x5d04),
                           ('SSReaderMenuView','fqab_readerMenu',0x5d54),
                           ('FQReaderSaaSBottomToolView','fqab_readerTools',0x5da4),
                           ('FQReaderBottomButtonContainerView','fqab_readerButtons',0x5df0)]:
        cpu,rt=make(data,validation)
        owner=rt.view(cls,'panel',(0,0,440,96),rt.ROOT)
        rt._add(rt.classes[cls],alias,rt.LAYOUT_IMP,'v16@0:8')
        for i in range(100):rt.view('UIView','decor'+str(i),(0,0,10,10),owner)
        before=cpu.steps
        call(cpu,entry,owner,rt.sel('setupLayout' if cls=='SSReaderMenuView' else 'layoutSubviews'))
        originals=sum(e['event']=='original_layout' and e.get('self')==owner for e in rt.events)
        require(originals==1,'Each patched tail preserves the original callback exactly once')
        logs=log_records(rt)
        if old and cls!='FQReaderSaasNavigationView':
            require(not logs,'Legacy menu/bottom traversal was invisible to reader layout diagnostics')
        else:
            require(len(logs)==1,'Every supported panel tail emits its scoped first-layout diagnostic')
            require(logs[0]['data']['readerVisitedViews']==64 and logs[0]['data']['readerTraversalBudgetExhausted']==1,
                    'One shared visit budget bounds the complete panel tree to 64')
            if not old:require(logs[0]['data']['readerOwnerClass']==cls,'Log identifies the exact owner path')
        cases.append({'owner':cls,'original_calls':originals,'instruction_count':cpu.steps-before,
                      'reader_log_count':len(logs)})
    return cases


def menu_attachment(data,validation):
    cpu,rt=make(data,validation)
    owner=rt.view('SSReaderMenuView','premount_menu',(0,0,440,300),0)
    button=rt.view('UIButton','menu_action',(20,20,80,44),owner)
    rt.label('caption',button,(10,12,60,20),'选项',intrinsic=(28,20))
    call(cpu,validation['reader_directory']['reader_panel'],owner)
    require(not surface(rt,button),'Off-window setup waits for real attachment')
    selector=rt.sel('didMoveToWindow'); method=rt.get_method(rt.classes['SSReaderMenuView'],selector)
    require(method and rt.methods[method]['imp']!=rt.WINDOW_IMP,'Menu attachment gets an exact-class hook')
    require(rt.methods[rt.get_method(rt.UIView,selector)]['imp']==rt.WINDOW_IMP,'UIView lifecycle is not globally changed')
    rt.reparent(owner,rt.ROOT);call(cpu,rt.methods[method]['imp']-rt.slide,owner,selector)
    within(rt,button,surface(rt,button))
    rt.reparent(owner,0);call(cpu,rt.methods[method]['imp']-rt.slide,owner,selector)
    require(not surface(rt,button),'Detaching menu removes only its owned decoration')
    return {'premount_then_attach_styles':True,'detach_restores':True}


def exclusions(data,validation):
    cpu,rt=make(data,validation)
    owner=rt.view('FQReaderSaaSBottomToolView','tools',(0,0,440,160),rt.ROOT)
    controls=[rt.view(cls,cls,(10,i*30,100,24),owner) for i,cls in enumerate(('UISlider','UISwitch','UITextField','UISegmentedControl'))]
    scroll=rt.view('UIScrollView','reader_content',(0,0,440,600),owner)
    content_button=rt.view('UIButton','unrelated_content',(0,0,44,44),scroll)
    rt.image_view('content_image',content_button,(10,10,24,24))
    call(cpu,validation['reader_directory']['reader_panel'],owner)
    require(all(not surface(rt,v) for v in controls+[content_button]),'Slider/switch/editing/scroll content are not decorated')
    return {'excluded_control_types':4,'scroll_content_untouched':True}


def managed_button_states(data, validation):
    cpu,rt=make(data,validation,symbol_available=True)
    owner,button,icon=reader_back(rt)
    original=rt.objects[icon].state['image'];rt.objects[icon].state['contentMode']=0
    highlighted=rt.obj('UIImage','old_highlighted_arrow',size=(24,24))
    images={0:original,1:highlighted}
    rt.objects[button].state.update(imageView=icon,stateImages=dict(images),
        contentHorizontalAlignment=1,contentVerticalAlignment=1,
        imageEdgeInsets=(0.,-6.,0.,6.),contentEdgeInsets=(0.,3.,0.,0.))
    before=frozen(rt,[owner,button])
    call(cpu,0x7848,button)
    native=rt.objects[icon].state['image']
    require(native!=original,'Managed button receives native system artwork')
    require(rt.objects[button].state['stateImages']==dict.fromkeys(range(8),native),
            'All ordinary highlighted/disabled/selected combinations use the native symbol')
    require(rt.objects[button].state['imageEdgeInsets']==(0.,0.,0.,0.) and
            rt.objects[button].state['contentEdgeInsets']==(0.,0.,0.,0.),
            'Managed state layout cannot reapply asymmetric back insets')
    # Simulate UIKit's documented state-driven imageView refresh AFTER the
    # parent hook, from the real state images set by executed ARM64 code.
    for state in (1,0,4,5,2,6,7,0):
        current=rt.objects[button].state['stateImages'].get(state,rt.objects[button].state['stateImages'][0])
        rt.objects[icon].state['image']=current
        w,h=rt.objects[current].state['size']
        rt.objects[icon].state.update(frame=((44-w)/2,(44-h)/2,w,h),bounds=(0,0,w,h))
        require(rt.objects[icon].state['image']==native,'Highlight cannot reload legacy arrow artwork')
        f=rt.objects[icon].state['frame'];near((f[0]+f[2]/2,f[1]+f[3]/2),(22,22),'Managed layout remains centred')
    rt.events.clear();call(cpu,0x7848,button)
    require(not any(e['event']=='setImage:forState:' for e in rt.events),'Settled state layout does not rewrite state images')
    # Host changing one state while owned must survive restoration of other
    # states. This is separate from UIImageView and contentMode ownership.
    newest=rt.obj('UIImage','host_changed_selected',size=(24,24))
    rt.objects[button].state['stateImages'][4]=newest
    call(cpu,validation['reader_directory']['back_restore'],icon)
    require(rt.objects[button].state['stateImages']=={0:original,1:highlighted,4:newest},
            'Restore retains host-changed state and removes only our state images')
    require(rt.objects[button].state['contentHorizontalAlignment']==1 and
            rt.objects[button].state['contentVerticalAlignment']==1 and
            rt.objects[button].state['imageEdgeInsets']==(0.,-6.,0.,6.) and
            rt.objects[button].state['contentEdgeInsets']==(0.,3.,0.,0.),
            'Exact host alignment and edge insets are restored')
    unchanged(rt,before)
    return {'managed_identity_checked':True,'ordinary_states':8,'host_state_change_preserved':True}


def standalone_cleanup(data,validation):
    cpu,rt=make(data,validation,symbol_available=True)
    owner=rt.view('FQReaderSaasNavigationView','standalone',(0,64,440,44),rt.ROOT)
    icon=rt.image_view('back_gesture',owner,(16,10,24,24),(24,24),0)
    original=rt.objects[icon].state['image'];rt.objects[owner].state['leftBackIconView']=icon
    call(cpu,validation['reader_directory']['reader_panel'],owner)
    require(rt.objects[icon].state['image']!=original,'Known standalone back getter uses native artwork')
    glass=rt.associations[(owner,rt.slide+0xbf9b)]
    rt.objects[owner].state['leftBackIconView']=0
    call(cpu,validation['reader_directory']['reader_panel'],owner)
    require(rt.objects[icon].state['image']==original,'Nil getter restores former native artwork ownership')
    require(rt.objects[glass].state['superview']==0 and not rt.associations.get((owner,rt.slide+0xbf9b)),
            'Nil getter detaches and clears its entire material association')
    near(rt.objects[icon].state['frame'],(16,10,24,24),'Standalone hit geometry never changes')
    return {'nil_getter_restores':True,'standalone_hit_frame_preserved':True}


def visibility_and_resize(data,validation):
    cpu,rt=make(data,validation)
    owner,control,icon=reader_back(rt)
    call(cpu,0x7848,control);first=surface(rt,control)
    near(within(rt,control,first),(0,0,44,44),'Expanded back surface starts inside its hit bounds')
    rt.objects[control].state['hidden']=True
    call(cpu,0x7848,control)
    require(not surface(rt,control) and rt.objects[first].state['superview']==0,'Hidden control drops its decoration')
    rt.objects[control].state['hidden']=False;call(cpu,0x7848,control)
    require(surface(rt,control) and surface(rt,control)!=first,'Visible control creates a fresh unhidden surface')
    rt.objects[control].state.update(frame=(8,0,40,40),bounds=(0,0,40,40))
    rt.events.clear();call(cpu,0x7848,control)
    within(rt,control,surface(rt,control))
    counts=mutate_count(rt)
    require(counts['setFrame']==1 and counts['cornerConfiguration']==1,'Actual hit-region resize updates material and corner once')
    rt.events.clear();call(cpu,0x7848,control)
    require(not any(mutate_count(rt).values()),'Resized layout settles without subsequent setters')
    return {'hidden_surface_removed':True,'resize_updates':counts}


def listen_reuse(data,validation):
    cpu,rt=make(data,validation)
    a=rt.view('SSReaderFloatingCommonButton','listen_A',(300,600,56,56),rt.ROOT)
    b=rt.view('SSReaderFloatingCommonButton','listen_B',(370,680,56,56),rt.ROOT)
    old=rt.label('old_caption',a,(8,8,40,40),'听',intrinsic=(28,34),line_height=34)
    white=rt.color('original_white');rt.objects[old].state['textColor']=white
    call(cpu,0x7848,a)
    rt.reparent(old,rt.ROOT)
    new=rt.label('new_caption',a,(8,8,40,40),'听',intrinsic=(28,34),line_height=34)
    rt.objects[new].state['textColor']=white;call(cpu,0x7848,a)
    require(rt.objects[old].state['textColor']==white,'Replacing a caption restores the prior detached label')
    require(rt.objects[new].state['textColor']==rt.color('labelColor'),'New caption gets semantic contrast')
    rt.reparent(new,b);call(cpu,0x7848,b)
    rt.objects[a].state['hidden']=True;call(cpu,0x7848,a)
    require(rt.objects[new].state['textColor']==rt.color('labelColor'),'Old button cleanup cannot erase new button ownership')
    rt.objects[b].state['hidden']=True;call(cpu,0x7848,b)
    require(rt.objects[new].state['textColor']==white,'New owner eventually restores the original caption color')
    return {'replaced_caption_restored':True,'moved_caption_epoch_preserved':True}


def listen_orphan_owner(data,validation):
    cpu,rt=make(data,validation)
    a=rt.view('SSReaderFloatingCommonButton','old_listen',(300,600,56,56),rt.ROOT)
    b=rt.view('SSReaderFloatingCommonButton','new_listen',(370,680,56,56),rt.ROOT)
    label=rt.label('reused_caption',a,(8,8,40,40),'听',intrinsic=(28,34),line_height=34)
    white=rt.color('original_white');rt.objects[label].state['textColor']=white
    call(cpu,0x7848,a);rt.reparent(label,b)
    # Public NSHashTable weak semantics after the old owner deallocates.
    for obj in rt.objects.values():
        if rt.class_names[obj.cls]=='NSHashTable' and a in obj.state.get('items',[]):
            obj.state['items']=[x for x in obj.state['items'] if x!=a]
    call(cpu,0x7848,b)
    require(rt.objects[label].state['textColor']==rt.color('labelColor'),'New live owner adopts an orphaned caption')
    rt.objects[b].state['hidden']=True;call(cpu,0x7848,b)
    require(rt.objects[label].state['textColor']==white,'Orphaned original foreground remains recoverable')
    return {'zeroing_weak_owner_recovery':True}


def main():
    p=argparse.ArgumentParser(description=__doc__)
    p.add_argument('--candidate',required=True,type=Path);p.add_argument('--validation',required=True,type=Path)
    p.add_argument('--baseline159',required=True,type=Path);p.add_argument('--baseline-validation',required=True,type=Path)
    p.add_argument('--report',required=True,type=Path);a=p.parse_args()
    data=a.candidate.read_bytes();v=json.loads(a.validation.read_text());old=a.baseline159.read_bytes();ov=json.loads(a.baseline_validation.read_text())
    require(v['candidate_sha256']==hashlib.sha256(data).hexdigest(),'Exact candidate bytes match build report')
    require(hashlib.sha256(old).hexdigest()=='e4435d143a22e21991ae753bca5af3f2d945dd6cd6ac3ab514c71d2a5e4d0810','Pinned actual user 1.5.9 negative control')
    require(ov['candidate_sha256']==hashlib.sha256(old).hexdigest(),'Baseline entry directory belongs to the pinned old binary')
    result={'passed':False,'candidate_sha256':hashlib.sha256(data).hexdigest(),'device_tested':False,
            'scope':'Executed ARM64; modeled public UIKit/Foundation boundary; not rendering or tap latency', 'cases':[]}
    tests=[('managed_button_state_refresh',lambda:managed_button_states(data,v)),
           ('native_back_reason18',lambda:native_failure18(data,v)),
           ('native_back_button_getter',lambda:native_failure18(data,v,getter='button')),
           ('native_back_no_getter',lambda:native_failure18(data,v,getter='none')),
           ('native_back_aslr',lambda:native_failure18(data,v,slide=0x100000000)),
           ('independent_property_restore',lambda:property_ownership(data,v)),
           ('native_unavailable_and_allocation_failures',lambda:unavailable_and_allocations(data,v)),
           ('more_hit_bounds',lambda:narrow_more(data,v)),
           ('complete_bottom_captions',lambda:bottom_buttons(data,v)),
           ('nested_bottom_icon_controls',lambda:bottom_buttons(data,v,nested=True)),
           ('listen_style_and_restore',lambda:listen_background(data,v)),
           ('four_real_tail_branches',lambda:panel_tails(data,v)),
           ('premount_menu_attachment',lambda:menu_attachment(data,v)),
           ('scope_exclusions',lambda:exclusions(data,v)),
           ('standalone_nil_getter_cleanup',lambda:standalone_cleanup(data,v)),
           ('visibility_and_real_resize',lambda:visibility_and_resize(data,v)),
           ('listen_caption_reuse_epochs',lambda:listen_reuse(data,v)),
           ('listen_orphan_owner',lambda:listen_orphan_owner(data,v)),
           ('negative159_reason18',lambda:legacy_failure18(old,ov)),
           ('negative159_more_outside_hit_area',lambda:narrow_more(old,ov,legacy=True)),
           ('negative159_unobserved_menu_tails',lambda:panel_tails(old,ov,old=True))]
    for name in ('stable_control','stable_glyph','reentrant','panel_budget_and_original',
                 'detach_and_epoch','monotonic_log'):
        tests.append(('retained_'+name,lambda name=name:getattr(prior,name)(data,v)))
    # Keep shelf behavior independently covered while the reader intentionally
    # changes from 36pt image skins to complete hit-area-contained controls.
    geometry.GeometryRuntime=ReaderRuntime
    for name,fn in [('shelf_edit',geometry.edit_pill),('shelf_filter',geometry.filter_pill),
                    ('shelf_reading_time',geometry.reading_time_pill),('shelf_larger_font',geometry.larger_font),
                    ('shelf_clipped_text',geometry.clipped_text),
                    ('nonfinite_geometry',geometry.nonfinite),
                    ('out_of_scope_original',geometry.original_fallback),
                    ('one_material_per_control',geometry.duplicate_prevention),
                    ('unknown_glyph_selector',geometry.unknown_glyph_selector),
                    ('story_standalone_artwork',geometry.standalone_glyph),
                    ('own_clipping_boundary',geometry.clipped_icon)]:
        tests.append((name,lambda fn=fn:fn(data,v['extension_directory'])))
    try:
        for name,test in tests:
            detail=test();result['cases'].append({'name':name,'passed':True,'details':detail});print('PASS',name)
        result['passed']=True
    except Exception as e:
        result['error']=str(e);result['traceback']=traceback.format_exc();raise
    finally:
        result['executed_instructions']=sum(c.steps for c,r in RUNS)
        a.report.parent.mkdir(parents=True,exist_ok=True);a.report.write_text(json.dumps(result,ensure_ascii=False,indent=2)+'\n')

if __name__=='__main__':main()
