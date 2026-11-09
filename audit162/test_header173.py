"""Execute shipped ARM64 header code against explicit UIKit geometry boundaries.
This checks clipping decisions, not compositor pixels or an injected host app.
"""
import argparse
import copy
import json
from pathlib import Path
from arm64 import require, release_version
from test_home_glass165 import fixture, LABELS, HOME, CATEGORY, SEARCH, COLOR, SEARCH_COLOR
from test_feed_viewport import labels_for


def call(c, r, obj, selector, *args, fp=None):
    return c.run(0xa5d4, args=[obj, r.sel(selector), *args], fp_args=fp, max_steps=1500000)


def intersection(a, b):
    x=max(a[0],b[0]); y=max(a[1],b[1])
    return (x,y,max(0,min(a[0]+a[2],b[0]+b[2])-x),max(0,min(a[1]+a[3],b[1]+b[3])-y))


def drawn_rect(r, view):
    # All fixture transforms are identity. Each clipping ancestor limits drawing.
    state=r.objects[view].state; rect=state['frame']; parent=state.get('superview',0)
    while parent:
        st=r.objects[parent].state
        if st.get('clipsToBounds'): rect=intersection(rect,st['bounds'])
        x,y,w,h=rect; px,py,_,_=st['frame']; bx,by,_,_=st['bounds']
        rect=(x+px-bx,y+py-by,w,h); parent=st.get('superview',0)
    return rect


def build_fixture(data, labels, width=440, height=40, slide=0):
    c,r=fixture(data,labels,slide)
    c.run(labels['LFQH_FQHInstall'],args=[],max_steps=1500000)
    search=r.view('UIView','search',(12,62,width-94,height),r.ROOT,
                  clipsToBounds=True,opaque=True,backgroundColor=r.color('searchTheme'),userInteractionEnabled=1)
    r.objects[r.layer(search)].state['cornerRadius']=6.0
    current=r.label('currentWord',search,(36,0,200,height),'PRIVATE_CURRENT_BOOK',alignment=0)
    next_word=r.label('nextWord',search,(36,height+10,240,height),'PRIVATE_NEXT_BOOK',alignment=0)
    category=r.view(CATEGORY,'categoryEntry',(width-74,62,64,height),r.ROOT,
                    clipsToBounds=True,opaque=True,backgroundColor=r.color('categoryTheme'),userInteractionEnabled=1)
    r.objects[r.layer(category)].state['cornerRadius']=6.0
    caption=r.label('categoryCaption',category,(24,0,40,height),'分类')
    nav=r.view('UIView','nativeNavigation',(0,62+height+10,width,40),r.ROOT)
    navlabels=[r.label('nativeTab',nav,(i*48,0,48,40),title) for i,title in enumerate(('推荐','小说','经典','知识','听书'))]
    vc=r.obj(HOME,'bookStore',searchBgView=search)
    component=r.obj(SEARCH,'searchComponent',bookStoreVCContext=vc)
    return c,r,search,category,current,next_word,caption,nav,navlabels,vc,component


def exercise(data, labels):
    require(release_version(data)=='1.7.3','Header regression is bound to 1.7.3')
    cases=[]
    for slide in (0,0x100000000):
        for width in (320,375,390,430,440,768,1024):
            for height in (36,40,44):
                c,r,s,cat,word,nxt,caption,nav,tabs,vc,component=build_fixture(data,labels,width,height,slide)
                unchanged=[s,cat,word,nxt,caption,nav,*tabs]
                before={o:copy.deepcopy(r.objects[o].state) for o in unchanged}
                call(c,r,vc,'relayout'); call(c,r,cat,'layoutSubviews')
                key=slide+labels['LFQH_SurfaceKey']
                glass=[r.associations[(v,key)] for v in (s,cat)]
                require(all(r.objects[v].state['clipsToBounds'] for v in (s,cat)),'Both header content viewports stay clipped')
                require(all(r.objects[r.layer(v)].state['cornerRadius']==height/2 for v in (s,cat)),'Owner crop matches the native capsule, no rectangular corners')
                require(drawn_rect(r,nxt)[2]*drawn_rect(r,nxt)[3]==0,'Offscreen cycling word does not draw on navigation')
                require(drawn_rect(r,word)[2]>0 and drawn_rect(r,word)[3]==height,'Current search word remains visible')
                for obj in unchanged:
                    for field in ('frame','bounds','text','font','userInteractionEnabled','target','action'):
                        require(r.objects[obj].state.get(field)==before[obj].get(field),'Do not move/hide/rewrite host content: '+field)
                require(r.objects[nav].state==before[nav],'Horizontal navigation is untouched')
                for v,g in zip((s,cat),glass):
                    st=r.objects[g].state
                    require(st['frame']==r.objects[v].state['bounds'] and st.get('cornerConfiguration'),'Native glass fills the original capsule bounds')
                    require(not st['userInteractionEnabled'] and st['accessibilityElementsHidden'],'Glass cannot intercept category/search taps')
                    require(r.objects[v].state['subviews'][0]==g,'Glass is behind original text/icon')
                for _ in range(12):
                    call(c,r,vc,'relayout');call(c,r,cat,'layoutSubviews')
                require(glass==[r.associations[(v,key)] for v in (s,cat)] and len(r.attachments)==2,'Repeated layout reuses exactly two surfaces')
                # The host rewrites its theme and old 6pt crop during an interactive transition.
                theme=r.color('updatedTheme')
                for v in (s,cat):
                    r.objects[v].state['backgroundColor']=theme
                    r.objects[v].state['clipsToBounds']=False
                    r.objects[r.layer(v)].state['cornerRadius']=7.0
                for obj,sel in ((component,SEARCH_COLOR),(cat,COLOR)):
                    n=len(r.original_calls);call(c,r,obj,sel,1,2,3,4,fp=[0.375])
                    require(len(r.original_calls)==n+1 and r.original_calls[-1][3]==[1,2,3,4] and r.original_calls[-1][4]==0.375,'Theme ABI forwarded exactly once')
                require(all(r.objects[v].state['clipsToBounds'] for v in (s,cat)),'Transition cannot reintroduce text overflow')
                require(all(r.objects[r.layer(v)].state['cornerRadius']==height/2 for v in (s,cat)),'Transition repairs only the owner crop')
                require(len(r.attachments)==2,'Theme transition does not allocate duplicate surfaces')
                r.objects[r.DEFAULTS].state['values']['FanqieAdBlock.GlassDisabled.1']=1
                call(c,r,vc,'relayout');call(c,r,cat,'layoutSubviews')
                for v in (s,cat):
                    require((v,key) not in r.associations,'Disable removes only owned glass')
                    require(r.objects[v].state['backgroundColor']==theme,'Disable restores latest host theme')
                    require(not r.objects[v].state['clipsToBounds'] and r.objects[r.layer(v)].state['cornerRadius']==7.0,'Disable restores latest pre-decoration clipping and radius')
                encoded=json.dumps(r.header_records)
                require('PRIVATE_CURRENT_BOOK' not in encoded and 'PRIVATE_NEXT_BOOK' not in encoded,'Header diagnostics contain no search/book text')
                require(any(e=='headerLayout173' and d['role']=='categoryButton' and d['clipsToBounds'] for e,d in r.header_records),'Diagnostics distinguish category entry from navigation')
        cases.append('7 widths x 3 heights: overflow/capsule/reuse/theme/disable at slide '+hex(slide))
    # Later host writes must not be overwritten when decoration is removed.
    c,r,s,cat,word,nxt,caption,nav,tabs,vc,component=build_fixture(data,labels)
    call(c,r,vc,'relayout')
    r.objects[r.layer(s)].state['cornerRadius']=9.0;r.objects[s].state['clipsToBounds']=False
    r.objects[r.DEFAULTS].state['values']['FanqieAdBlock.GlassDisabled.1']=1
    call(c,r,vc,'relayout')
    require(r.objects[r.layer(s)].state['cornerRadius']==9.0 and not r.objects[s].state['clipsToBounds'],'A later host property write wins during cleanup')
    cases.append('ownership-aware cleanup preserves later host writes')
    return cases


def reproduce_baseline(path):
    data=path.read_bytes();labels=labels_for(data,path.with_suffix('.composed.s'),LABELS)
    c,r,s,cat,word,nxt,caption,nav,tabs,vc,component=build_fixture(data,labels)
    call(c,r,vc,'relayout');call(c,r,cat,'layoutSubviews')
    spill=drawn_rect(r,nxt)
    result={'version':release_version(data),'searchClippingDisabled':not r.objects[s].state['clipsToBounds'],
            'offscreenWordHasVisibleArea':spill[2]*spill[3]>0,'categoryGlassMissing':(cat,labels['LFQH_SurfaceKey']) not in r.associations,
            'ownerCornerRadius':r.objects[r.layer(s)].state['cornerRadius']}
    require(result['searchClippingDisabled'] and result['offscreenWordHasVisibleArea'] and result['categoryGlassMissing'],'The old shipped code reproduces the reported geometry defects')
    return result


if __name__=='__main__':
    p=argparse.ArgumentParser();p.add_argument('candidate',type=Path);p.add_argument('--report',type=Path,required=True);p.add_argument('--baseline',type=Path);a=p.parse_args()
    data=a.candidate.read_bytes();labels=labels_for(data,a.candidate.with_suffix('.composed.s'),LABELS)
    report={'passed':True,'device_tested':False,'pixel_rendering_tested':False,'cases':exercise(data,labels)}
    if a.baseline: report['baseline_reproduction']=reproduce_baseline(a.baseline)
    a.report.write_text(json.dumps(report,indent=2)+'\n');print(json.dumps(report,indent=2))
