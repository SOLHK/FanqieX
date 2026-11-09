import argparse,json,struct
from pathlib import Path
from arm64 import CPU,require
from test_alignment167 import Runtime as Base,call
from test_home_glass165 import LABELS
from test_feed_viewport import labels_for
class Runtime(Base):
 def __init__(self,data,slide=0):
  super().__init__(data,slide)
  self._class('SSBookshelfEditBottomView','UIView')
  self._class('SSReaderFloatingCommonButton','UIView')
  self.frames=[]
  self.colors={n:self.color(n) for n in ('labelColor','secondarySystemBackgroundColor')}
 def handle(self,c,pc):
  if pc-self.slide==0xa5d4:
   r,s=c.x[:2];n=self.selector_names.get(s)
   if r==self.classes.get('UIColor') and n in self.colors:return self.finish(c,self.colors[n])
   if r in self.objects:
    st=self.objects[r].state
    if n=='colorWithAlphaComponent:':return self.finish(c,self.color('tint50'))
    if n=='textColor':return self.finish(c,st.get('textColor',0))
    if n=='setTextColor:':st['textColor']=c.x[2];return self.finish(c)
    if n=='setFrame:':self.frames.append(r)
  return super().handle(c,pc)
def run(data,labels):
 r=Runtime(data);r.labels=labels
 words=struct.unpack_from('<64I',data,0x800)
 c=CPU(data,r,0,ranges=[(0x800,0x4000),(0x4878,0x48d0),(0x702c,0x7d00),(0x14080,0x800+words[61])]);c.pointers.update(r.rebase_pointers)
 bar=r.view('SSBookshelfEditBottomView','edit',(0,0,440,64),r.ROOT)
 for width in (80.,97.5,110.,192.):
  buttons=[r.view('UIButton','action',(i*width,0,width,64),bar) for i in range(4)]
  for b in buttons:
   require(call(c,labels,'LFQH_FQHIsEdit',b)['result']==1,'Only edit toolbar children')
   call(c,labels,'LFQH_FQHEditRect',b)
   require(tuple(c.fp(i) for i in range(4))==(6.,4.,width-12,56.),'12pt gaps and 6pt outer insets across screen widths')
   surface=call(c,labels,'LGstyle_control',b,0)['result']
   require(surface and r.objects[surface].state['frame']==(6.,4.,width-12,56.),'Actual legacy entry publishes the inset native material')
 floating=r.view('SSReaderFloatingCommonButton','listen',(0,0,56,56),r.ROOT,backgroundColor=r.color('hostGray'))
 label=r.label('listenCaption',floating,(10,10,36,36),'听');white=r.color('hostWhite');r.objects[label].state['textColor']=white
 call(c,labels,'LFQH_FQHListen',floating)
 surface=call(c,labels,'LFQH_FQHSurface',floating)['result'];require(surface,'Listen gets a real native effect surface')
 require(r.objects[label].state['textColor']==r.colors['labelColor'],'Semantic foreground remains readable in light/dark mode')
 effect=r.objects[surface].state['effect'];require(r.objects[effect].state['style']==0 and r.objects[effect].state['tintColor'],'Regular material with readability tint')
 writes=r.frames.count(surface)
 for _ in range(100):call(c,labels,'LFQH_FQHListen',floating)
 require(call(c,labels,'LFQH_FQHSurface',floating)['result']==surface and r.frames.count(surface)==writes,'100 settled layouts reuse one material without frame writes')
 r.objects[r.DEFAULTS].state['values']['FanqieAdBlock.GlassDisabled.1']=1
 call(c,labels,'LFQH_FQHListen',floating)
 require(not call(c,labels,'LFQH_FQHSurface',floating)['result'] and r.objects[label].state['textColor']==white,'Disable restores original caption and removes glass')
 other=r.view('SSReaderFloatingCommonButton','other',(0,0,56,56),r.ROOT);r.label('otherCaption',other,(0,0,56,56),'活动')
 r.objects[r.DEFAULTS].state['values']['FanqieAdBlock.GlassDisabled.1']=0
 call(c,labels,'LFQH_FQHListen',other);require(not call(c,labels,'LFQH_FQHSurface',other)['result'],'Unrelated floating button unchanged')
 return {'passed':True,'device_tested':False,'edit_widths':[320,390,440,768],'listen_regular_material':True,'foreground_restored':True,'settled_layouts':100,'settled_material_frame_writes':0}
if __name__=='__main__':
 p=argparse.ArgumentParser();p.add_argument('candidate',type=Path);p.add_argument('--report',type=Path,required=True);a=p.parse_args();data=a.candidate.read_bytes()
 labels=labels_for(data,a.candidate.with_suffix('.composed.s'),LABELS+['LFQH_FQHIsEdit','LFQH_FQHEditRect','LFQH_FQHListen','LFQH_FQHSurface','LGstyle_control','Lrecord_named'])
 result=run(data,labels);a.report.write_text(json.dumps(result,indent=2)+'\n');print(json.dumps(result,indent=2))
