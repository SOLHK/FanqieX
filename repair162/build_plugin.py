#!/usr/bin/env python3
"""Rebuild FanqieX over the unchanged pinned 1.5.6 original image.
The reconstruction input 1.5.8, user-tested predecessor 1.6.1 and original base
are hash checked. The 1.6.2 repair sources continue 1.6.1 and replace the whole
extension in a clean rebuild; no second extension is stacked on an old patch.
"""
import argparse
import hashlib
import json
from pathlib import Path
import struct
import uuid
from macho_tools import assemble_object, sections, macho_commands, disassemble
from extend_macho import extend, verify_extension, verify_signature
from native_unwind import add_native_unwind

UPLOADED_SHA = '55a2c02e5962ad740816aaf2f8f2f6d9269eb9ecce37c69402897ff3776a4354'
SOURCE_SHA = '918313ffab725b9b4c53d030fac463f836032b164b9b30b9815720418e8d36d4'
PREVIOUS_SHA = '8c8aedc3643c52efa1180119a983c8cd22006123ea095db617ea901be0fbcf8e'
VERSION, ENCODED = '1.6.2', 0x10602
RELEASES = {VERSION: ENCODED, '1.6.3': 0x10603, '1.6.4': 0x10604, '1.6.5': 0x10605, '1.6.6': 0x10606, '1.6.7': 0x10607, '1.6.9': 0x10609}
PRODUCT_NAME = 'FanqieX'
BASE, CODE_LIMIT, DATA_BASE, DATA_LIMIT, EXT_BASE = 0x800, 0x4000, 0x11900, 0x14000, 0x14000
NAMES = ['ratio','layout','installer','repair','strings','end','version','reserved',
 'frame','background','restore','edge_update','edge_restore','find','round','sync',
 'eligible','visible','message','install_method','busy_key','scroll_key','edge_key',
 'hidden_key','parent_key','selected_key','sync_original','restore_original',
 'proxy_frame','material_update','material_reset','settings_boot','ui_install',
 'ui_export','ui_present','diagnostic_init','diagnostic_enqueue','diagnostic_tick',
 'diagnostic_maintenance','diagnostic_observe','diagnostic_snapshot',
 'diagnostic_snapshot_all','diagnostic_heartbeat','describe_view','describe_children',
 'string','number','dict_set','uint','now','settings_trampoline','signature_key',
 'bars_key','ui_busy_key','ui_sender_key','code_end','window','find_record',
 'capture_edge','restore_removed','extension','extension_code_end','extension_strings','extension_end']
EXT_NAMES = ['update','restore','native_update','native_restore','same_bottom_rect',
 'safe_tree','monitor_start','poll','snapshot','interaction_update','interaction_restore',
 'pan','should_begin','style_control','style_glyph','code_end','strings','end',
 'native_key','monitor_key','owner_key','timer_key','tick_key','rejected_key',
 'reserved24','reserved25','reserved26','reserved27']
SITES = [(0x41d8,'installer',True),(0x4704,'settings_boot',False),
 (0x4cbc,'ui_install',True),(0x5b94,'ratio',False),(0x60b8,'sync',False),
 (0x6c84,'frame',True),(0x6ce8,'proxy_frame',True),(0x6db4,'restore',False)]

def need(cond, why):
 if not cond: raise ValueError(why)

def branch(pc, target, link=False):
 n = target-pc
 need(n % 4 == 0 and -(1<<27) <= n < (1<<27), 'ARM64 branch range')
 return struct.pack('<I',(0x94000000 if link else 0x14000000)|((n//4)&0x3ffffff))

def compose_assembly(path, version=VERSION):
 path=Path(path); text=f'.set FQ_VERSION, {RELEASES[version]:#x}\n'+path.read_text()
 extension=['native_surface.s','native_guard.s','glass_interaction.s','native_selection.s','interaction_diagnostics.s','control_geometry.s','feed_viewport.s','reader_fastpath.s','reader_diagnostics.s','diagnostic_performance.s']
 if version != VERSION:
  extension.append('hook_ownership.s')
 if version in ('1.6.4', '1.6.5', '1.6.6', '1.6.7', '1.6.9'):
  extension.extend(('startup_popup.s', 'tabbar_spacing.s', 'diagnostic_limits.s', 'ad_decisions.s'))
 if version in ('1.6.5', '1.6.6', '1.6.7', '1.6.9'):
  extension.append('home_glass.s')
 for group, files in [('COMPONENT',['material_lifecycle.s','diagnostic_ui.s','diagnostic_store.s']),
                       ('EXTENSION',extension)]:
  code=[]; data=[]
  for filename in files:
   parts=path.with_name(filename).read_text().split('// @COMPONENT_DATA')
   need(len(parts)==2, 'Component boundary: '+filename)
   code.append(parts[0]); data.append(parts[1])
  if group == 'EXTENSION' and version in ('1.6.4', '1.6.5', '1.6.6', '1.6.7', '1.6.9'):
   parts=(path.parents[1]/'native'/('FanqieXDiagnostics.s' if version == '1.6.9' else 'LegacyDiagnostics168.s')).read_text().split('// @COMPONENT_DATA')
   need(len(parts)==2,'Native diagnostic component boundary')
   code.append(parts[0]); data.append(parts[1])
  if group == 'EXTENSION' and version in ('1.6.5', '1.6.6', '1.6.7', '1.6.9'):
   parts=(path.parents[1]/'native'/('AlignedGlass.s' if version == '1.6.9' else 'AlignedGlass167.s' if version == '1.6.7' else 'ControlGlass.s' if version == '1.6.6' else 'HomeGlass.s')).read_text().split('// @COMPONENT_DATA')
   need(len(parts)==2,'Home glass component boundary')
   code.append(parts[0]); data.append(parts[1])
  for kind, values in [('CODE',code),('DATA',data)]:
   marker='// @'+group+'_'+kind
   need(text.count(marker)==1,'Composition marker: '+marker)
   text=text.replace(marker,'\n'.join(values))
 return text

def directory(data, version):
 d=dict(zip(NAMES,struct.unpack_from('<64I',data)))
 need(d['version']==version and d['reserved']==0,'Repair version')
 need(256 <= d['ratio'] < d['code_end'] <= CODE_LIMIT-BASE,'Main code bounds')
 need(d['strings']==DATA_BASE-BASE and d['strings']<d['end']<=DATA_LIMIT-BASE,'Main data bounds')
 for name in NAMES[:4]+NAMES[8:20]+NAMES[26:51]+NAMES[56:60]:
  need(256<=d[name]<d['code_end'] and d[name]%4==0,'Code entry '+name)
 for name in NAMES[20:26]+NAMES[51:55]:
  need(d['strings']<=d[name]<d['end'],'Data entry '+name)
 if version==0x10506:
  need(all(d[n]==0 for n in NAMES[60:]),'Unexpected existing extension')
 else:
  capacity_limit=0x20000 if version>=0x10604 else 0x10000
  need(d['extension']==EXT_BASE-BASE and d['extension']+128<d['extension_code_end']<=d['extension_strings']<d['extension_end']<=d['extension']+capacity_limit,'Extension bounds')
 return d

def build(source_path, output_path, *, version=VERSION):
 source_path=Path(source_path); output_path=Path(output_path)
 encoded=RELEASES[version]
 isolated=version != VERSION
 profile164=version in ('1.6.4', '1.6.5', '1.6.6', '1.6.7', '1.6.9')
 need(source_path.resolve()!=output_path.resolve(),'No in-place edit')
 uploaded=source_path.read_bytes()
 need(len(uploaded)==123280 and hashlib.sha256(uploaded).hexdigest()==UPLOADED_SHA,'Exact uploaded 1.5.8 required')
 need(verify_signature(uploaded)['page_hashes_valid'],'Uploaded 1.5.8 page hashes')
 previous_path=Path(__file__).resolve().parents[1]/'dist'/'1.6.1'/'FanqieAdBlock-1.6.1.dylib'
 previous=previous_path.read_bytes()
 need(hashlib.sha256(previous).hexdigest()==PREVIOUS_SHA,'Exact user-tested 1.6.1 required')
 need(verify_signature(previous)['page_hashes_valid'],'User-tested 1.6.1 page hashes')
 base_path=Path(__file__).resolve().parents[1]/'baseline'/'FanqieAdBlock-1.5.6.dylib'
 source=base_path.read_bytes()
 need(len(source)==90256 and hashlib.sha256(source).hexdigest()==SOURCE_SHA,'Exact uploaded 1.5.6 required')
 original_signature=verify_signature(source)
 need(original_signature['page_hashes_valid'],'Original signature page hashes')
 old=directory(source[BASE:BASE+256],0x10506)
 for a,b in [(BASE+old['code_end'],CODE_LIMIT),(BASE+old['end'],DATA_LIMIT)]:
  need(not any(source[a:b]),'Occupied original padding')
 for a,b in [(BASE,CODE_LIMIT),(DATA_BASE,DATA_LIMIT)]:
  for s in sections(source): need(max(a,s['offset'])>=min(b,s['offset']+s['size']),'Padding overlaps original section')
 for a,v in {0x4b34:'1f2003d5',0x6798:'02008052',0x681c:'1f2003d5',0x6c28:'e003271e',0x6c40:'e003679e',0x6cd0:'1f2003d5'}.items():
  need(source[a:a+4]==bytes.fromhex(v),'Missing earlier fix '+hex(a))
 assembly=compose_assembly(Path(__file__).with_name('floating_bar_162.s'), version)
 obj=assemble_object(assembly); ss=[s for s in sections(obj) if s['name']=='__text']
 need(len(ss)==1 and ss[0]['reloc_count']==0,'Unresolved assembler relocation')
 s=ss[0]; payload=obj[s['offset']:s['offset']+s['size']]
 d=directory(payload,encoded); off=d['extension']
 need(payload[off:off+8]==b'FQ162EXT' and struct.unpack_from('<II',payload,off+8)==(encoded,32),'Extension header')
 e=dict(zip(EXT_NAMES,struct.unpack_from('<28I',payload,off+16)))
 need((e['code_end'],e['strings'],e['end'])==(d['extension_code_end'],d['extension_strings'],d['extension_end']),'Extension directory agreement')
 need(len(payload)==e['end'],'Assembled span')
 for n in EXT_NAMES[:15]: need(off+128<=e[n]<e['code_end'] and e[n]%4==0,'Extension code '+n)
 for n in EXT_NAMES[18:24]: need(e['strings']<=e[n]<e['end'],'Extension data '+n)
 if isolated:
  hook=e['reserved24']
  need(off+128<=hook<e['code_end'] and hook%4==0,'Hook ownership entry bounds')
 if version in ('1.6.5', '1.6.6', '1.6.7', '1.6.9'):
  marker=payload.index(b'FQ165HOM')
  home_gate,home_check=struct.unpack_from('<II',payload,marker+8)
  need(all(off+128<=entry<e['code_end'] and entry%4==0 for entry in (home_gate,home_check)),'Host compatibility entries in code')
 if profile164:
  popup=e['reserved25']
  need(off+128<=popup<e['code_end'] and popup%4==0,'Startup popup installer entry bounds')
  tabbar=e['reserved26']
  need(off+128<=tabbar<e['code_end'] and tabbar%4==0,'Tab bar spacing entry bounds')
  ad_install=e['reserved27']
  need(off+128<=ad_install<e['code_end'] and ad_install%4==0,'Ad diagnostic installer entry bounds')
 need(all(e[n]==0 for n in EXT_NAMES[28 if profile164 else 24+isolated:]),'Extension reserved fields')
 for a,b in [(d['code_end'],d['strings']),(d['end'],d['extension'])]: need(not any(payload[a:b]),'Nonzero gap')
 data=bytearray(source); changes=[]
 def replace(a,expected,value,reason):
  need(len(expected)==len(value) and data[a:a+len(value)]==expected,'Patch precondition '+hex(a))
  data[a:a+len(value)]=value
  changes.append({'offset':hex(a),'size':len(value),'reason':reason,
    'old_sha256':hashlib.sha256(expected).hexdigest(),'new_sha256':hashlib.sha256(value).hexdigest()})
 stop=BASE+max(old['code_end'],d['code_end'])
 replace(BASE,source[BASE:stop],payload[:d['code_end']].ljust(stop-BASE,b'\0'),'Rebuild main repair with extension calls')
 stop=BASE+max(old['end'],d['end'])
 replace(DATA_BASE,source[DATA_BASE:stop],payload[d['strings']:d['end']].ljust(stop-DATA_BASE,b'\0'),'Rebuild constants')
 for a,n,link in SITES: replace(a,branch(a,BASE+old[n],link),branch(a,BASE+d[n],link),'Redirect '+n)
 if isolated:
  replace(0x4878,bytes.fromhex('a00200b4'),branch(0x4878,BASE+hook),'Localize legacy hook methods')
 if version in ('1.6.5', '1.6.6', '1.6.7', '1.6.9'):
  replace(0x4018,bytes.fromhex('00008052'),branch(0x4018,BASE+home_check,True),'Validate same-build host under the original constructor unwind frame')
  replace(0x401c,branch(0x401c,0xa5c8,True),branch(0x401c,BASE+home_gate),'Accept compatible build or replay the original UUID gate')
 if profile164:
  replace(0x4650,bytes.fromhex('fa67bba9'),branch(0x4650,BASE+popup),'Install startup popup rule')
  replace(0x6568,bytes.fromhex('0010651e'),branch(0x6568,BASE+tabbar),'Set symmetric tab bar safe area margins')
  replace(0x46d8,branch(0x46d8,0xa580,True),branch(0x46d8,BASE+ad_install,True),'Record executed ad decisions')
  unwound, unwind_report = add_native_unwind(bytes(data), obj, image_base=BASE)
  at, size = unwind_report['section_offset'], unwind_report['section_size']
  replace(at,bytes(data[at:at+size]),unwound[at:at+size],
   'Link compiler-generated native exception unwind frames into the existing metadata slot')
 marker=b'FQ162RDR'
 need(payload.count(marker)==1,'One reader fix entry table')
 reader_at=payload.index(marker)
 reader_names=['reader_panel','walk','back_prepare','back_restore','image_alignment','layout_observe','finish',
  'control_busy_key','busy_key','owner_back_key','back_owned_key','back_original_key','back_mode_key','last_log_key',
  'settle_control']
 reader_offsets=struct.unpack_from('<15I',payload,reader_at+8)
 reader_entries=dict(zip(reader_names,reader_offsets))
 for name in reader_names[:7]+reader_names[14:]:
  need(off+128<=reader_entries[name]<e['code_end'] and reader_entries[name]%4==0,'Reader code '+name)
 for name in reader_names[7:14]:
  need(e['strings']<=reader_entries[name]<e['end'],'Reader data '+name)
 reader_tail_sites=[(0x5d50,0x746c),(0x5da0,0x746c),(0x5dec,0x75d4),(0x5e38,0x75d4)]
 for site,original_target in reader_tail_sites:
  replace(site,branch(site,original_target),branch(site,BASE+reader_entries['reader_panel']),
   'Replace reader navigation/menu/bottom recursive tail with bounded reader panel')
 for a,n,v in [(0x7848,'style_control','f44fbea9'),(0x7ac4,'style_glyph','eb2bba6d')]:
  replace(a,bytes.fromhex(v),branch(a,BASE+e[n]),'Scoped '+n+' with original trampoline')
 # The original proxy constructor can run before the visibility-stable repair.
 # Its first material must also be Regular if native selection is unavailable.
 replace(0x649c,bytes.fromhex('22008052'),bytes.fromhex('02008052'),
  'Initial proxy factory uses Regular glass rather than Clear')
 replace(0x568,struct.pack('<I',0x10506),struct.pack('<I',encoded),'Dylib version')
 # The shorter product name fits the existing LC_ID_DYLIB command. Preserve
 # command size/order and zero all spare bytes; no load-command movement.
 old_install=source[0x570:0x598]
 need(old_install.split(b'\0',1)[0]==b'@rpath/FanqieAdBlock-1.5.6.dylib',
      'Exact original install name')
 new_install=('@rpath/'+PRODUCT_NAME+'-'+version+'.dylib').encode()+b'\0'
 need(len(new_install)<=len(old_install),'Install name fits existing command')
 replace(0x570,old_install,new_install.ljust(len(old_install),b'\0'),'FanqieX install name')
 replace(0xec84,'1.5.6'.encode('utf-16le'),version.encode('utf-16le'),'Settings version')
 uu=[o for c,o,n in macho_commands(source) if c==0x1b]; need(len(uu)==1,'One UUID')
 extension=payload[off:e['end']]
 ident=bytearray(hashlib.sha256(bytes(data[:original_signature['signature_offset']])+extension).digest()[:16])
 ident[6]=(ident[6]&15)|0x50; ident[8]=(ident[8]&63)|0x80
 replace(uu[0]+8,source[uu[0]+8:uu[0]+24],bytes(ident),'Deterministic UUID')
 allowed=set()
 for change in changes:
  a=int(change['offset'],16); allowed.update(range(a,a+change['size']))
 need(not any(a!=b and i not in allowed for i,(a,b) in enumerate(zip(source,data))),'Unexpected edit before extension')
 capacity=((len(extension)+0x3fff)//0x4000)*0x4000
 if profile164 and capacity>0x10000:
  capacity=0x20000
 need(capacity<=(0x20000 if profile164 else 0x10000),'Extension exceeds reviewed release capacity')
 out=extend(bytes(data),extension,capacity=capacity,identifier=PRODUCT_NAME+'-'+version+'.dylib')
 layout=verify_extension(bytes(data),out,extension); sig=verify_signature(out)
 # Compare actual original sections against the user's 1.5.8, independent
 # of the 1.5.6 reconstruction. Only explicitly reviewed entry branches, the
 # initial material style immediate and displayed version string may differ;
 # ad handling and host UUID gate
 # cannot be silently reverted during the clean rebuild.
 original_allowed=set(range(0xec84,0xec84+10))
 for a,n,link in SITES:
  original_allowed.update(range(a,a+4))
 for a in (0x7848,0x7ac4,0x5d50,0x5da0,0x5dec,0x5e38,0x649c):
  original_allowed.update(range(a,a+4))
 if version in ('1.6.5', '1.6.6', '1.6.7', '1.6.9'):
  original_allowed.update(range(0x4018,0x4020))
 if isolated:
  original_allowed.update(range(0x4878,0x487c))
 if profile164:
  original_allowed.update(range(0x4650,0x4654))
  original_allowed.update(range(0x6568,0x656c))
  original_allowed.update(range(0x46d8,0x46dc))
  original_allowed.update(range(unwind_report['section_offset'],
   unwind_report['section_offset']+unwind_report['section_size']))
 original_checked=0
 for sec in sections(uploaded):
  a=sec['offset']; b=a+sec['size']
  need(b<=0x14000,'Unexpected original section outside fixed image')
  need(not any(uploaded[i]!=out[i] and i not in original_allowed for i in range(a,b)),
       'Unexpected change relative to uploaded 1.5.8 in original section '+sec['name'])
  need(not any(previous[i]!=out[i] and i not in original_allowed for i in range(a,b)),
       'Unexpected change relative to user-tested 1.6.1 in original section '+sec['name'])
  original_checked += b-a
 need(sig['page_hashes_valid'],'Candidate page hashes')
 need(hashlib.sha256(source_path.read_bytes()).hexdigest()==UPLOADED_SHA,'Input changed')
 report={'product_name':PRODUCT_NAME,'version':version,'source_version':'1.6.1','source_sha256':PREVIOUS_SHA,
  'reconstruction_input_version':'1.5.8','reconstruction_input_sha256':UPLOADED_SHA,
  'rebuild_base_sha256':SOURCE_SHA,
  'candidate_sha256':hashlib.sha256(out).hexdigest(),'size_bytes':len(out),
  'changes':changes,'signature':sig,'extension_layout':layout,'uuid':str(uuid.UUID(bytes=bytes(ident))),
  'main_directory':{k:(v+BASE if k not in ('version','reserved') else v) for k,v in d.items()},
  'extension_directory':{k:(v+BASE if v else 0) for k,v in e.items()},
  'reader_directory':{k:v+BASE for k,v in reader_entries.items()},
  'original_unchanged':True,'original_sections_compared_to_uploaded_bytes':original_checked,'device_ui_tested':False,
  'limits':['Original plugin/host sources unavailable; repair sources are provided.',
   'No iPhone, native UIKit renderer, simulator or dyld load executed.',
   'Ad-hoc page hashes do not establish device signing/injection acceptance.',
   'Normal IPA re-signing is still required.',
   'Unknown/controller/scroll content in native wrapper prevents suppression.',
   'Regular base/native gray selection, shelf first-frame composition and original reader controls have not been visually checked on a device.',
   'Removed repeat-layout mutations are instruction-tested; real touch-to-action latency remains unmeasured.',
   'Diagnostics observe bounded plugin state; pending writes are not crash durable.']}
 if profile164:
  report['native_unwind'] = unwind_report
 output_path.parent.mkdir(parents=True,exist_ok=True)
 output_path.write_bytes(out)
 output_path.with_suffix('.validation.json').write_text(json.dumps(report,indent=2)+'\n')
 output_path.with_suffix('.preextend').write_bytes(data)
 output_path.with_suffix('.extension.bin').write_bytes(extension)
 output_path.with_suffix('.composed.s').write_text(assembly)
 output_path.with_suffix('.patch-disassembly.txt').write_text('\n'.join(disassemble(payload[d['ratio']:d['code_end']],BASE+d['ratio']))+'\nEXTENSION:\n'+'\n'.join(disassemble(payload[off+128:e['code_end']],EXT_BASE+128))+'\n')
 return report

if __name__=='__main__':
 p=argparse.ArgumentParser(description=__doc__); p.add_argument('source'); p.add_argument('output')
 p.add_argument('--version',choices=RELEASES,default=VERSION); a=p.parse_args()
 r=build(a.source,a.output,version=a.version)
 print(json.dumps({k:r[k] for k in ('version','candidate_sha256','size_bytes','device_ui_tested')},indent=2))
