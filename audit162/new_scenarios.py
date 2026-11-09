"""1.5.6 retained-regression scenarios executing candidate instructions across mocked native calls.

No logger, material, capture, or UI patch entry is replaced by a Python stub.
Only platform services and unavailable host implementations are modeled.
"""
from pathlib import Path
import json
import math
import plistlib
import tempfile

from arm64 import bits, require


def journal(rt):
    return rt.disk_root/'ApplicationSupport'/'FanqieAdBlockDiagnostics'/'recent.plist'


def saved(rt):
    envelope = plistlib.loads(journal(rt).read_bytes())
    require(isinstance(envelope,list) and len(envelope) == 1 and isinstance(envelope[0],bytes),
            'Actual durable envelope is a one-NSData binary plist')
    return json.loads(envelope[0])


def open_settings(cpu,rt,d,bootstrap=True):
    if bootstrap:
        cpu.run(0x4704)  # Actual modified original settings initializer.
        rt.flush_main(cpu)
    host = rt.obj('SSSettingViewController','settings_host',
                  view=rt.view('UIView','settings_host.view',(0,0,390,844),rt.ROOT),
                  navigationItem=rt.obj('UINavigationItem','settings_host.navigation'),
                  presentedViewController=0)
    before = set(rt.objects)
    cpu.run(0x4958,host)  # Whole original _open_menu, including patched 0x4cbc.
    options = next(p for p in set(rt.objects)-before
                   if rt.class_names[rt.objects[p].cls] == 'FanqieAdBlockOptionsController')
    # The retained execution fixture adds 0x800 to every directory word,
    # including the numeric version field.
    if d.get('version') in (0x10602 + 0x800, 0x10603 + 0x800, 0x10604 + 0x800, 0x10605 + 0x800, 0x10606 + 0x800, 0x10608 + 0x800):
        require(rt.string_value(rt.objects[options].state.get('title', 0)) == 'FanqieX',
                'The complete settings opener presents the product as FanqieX')
    nav = rt.objects[rt.objects[options].state['navigationItem']].state
    require(nav.get('left') and nav.get('right'),'New export and original close buttons coexist')
    button = nav['left']
    require(rt.objects[button].state['target'] == options,'Export button targets owned options controller')
    require(rt.selector_names[rt.objects[button].state['action']] == 'fqab_156_exportDiagnostics:',
            'Export button has actual installed action')
    require(0x4cbc in cpu.executed and d['ui_install'] in cpu.executed,'Original open menu reaches real hook')
    return options,button


def export_command(cpu,rt,d,target,timestamp):
    command = rt.dict_pointer({'exportTarget':target,'timestamp':rt.box(timestamp)})
    cpu.run(d['diagnostic_enqueue'],command)


def export_callback(rt,target):
    jobs = [job for job in rt.main_jobs if job[0] == target and
            rt.selector_names[job[1]] == 'fqab_156_presentDiagnostics:']
    require(jobs,'Worker schedules actual presenter selector on main')
    return rt.objects[jobs[-1][2]].state['items']


def exported(rt,target):
    result = export_callback(rt,target)
    require('url' in result and 'error' not in result,'Successful export returns URL without error')
    path = Path(rt.string_value(result['url']))
    require(path.exists(),'Export file actually exists at returned URL')
    content = json.loads(path.read_bytes())
    require(content['recordCount'] == len(content['entries']),'Metadata count equals complete exported array')
    return content,path


def material(data,d,make):
    cpu,rt = make(data)
    # Execute the actual original call-site fragment: former early attachment
    # is now NOP, then the original _set_frame runs inside the new adapter.
    rt.reparent(rt.PROXY,0)
    rt.objects[rt.PROXY].state.update(frame=(0,0,0,0),bounds=(0,0,0,0))
    cpu.ranges.append((0x6cc4,0x6d08))
    cpu.sp -= 16; cpu.write(cpu.sp,8,bits(12.0))
    cpu.x[19],cpu.x[20] = rt.PROXY,rt.BAR
    cpu.wf(8,3.0);cpu.wf(11,366.0);cpu.wf(9,56.0)
    cpu.pc = 0x6cc4
    while cpu.pc != 0x6d08:
        cpu.step()
    cpu.sp += 16
    actions = [e for e in rt.events if e['event'] in ('setFrame','addSubview','bring_front')]
    require([e['event'] for e in actions] == ['setFrame','addSubview','bring_front'],
            'Actual original caller sets nonzero geometry before attachment and front placement')
    require(actions[1]['frame'] == [12.0,3.0,366.0,56.0],'Attachment observes final nonzero frame')
    first = cpu.run(d['material_update'],rt.BAR,rt.PROXY)
    require(first['result'] == 1,'Visible valid proxy installs fresh Regular effect')
    effect = rt.objects[rt.PROXY].state['effect']
    require(rt.objects[effect].state == {'style':0,'tintColor':0,'interactive':True},'Regular style and public glass options')
    writes = [e for e in rt.events if e['event'] == 'setEffect']
    require(len(writes) == 1 and writes[0]['value'] == effect,
            'First display installs only its final native glass; no empty intermediate effect')
    before = len(writes)
    require(cpu.run(d['material_update'],rt.BAR,rt.PROXY)['result'] == 0,'Same window/effect reused')
    require(len([e for e in rt.events if e['event'] == 'setEffect']) == before,'No repeated swap on unchanged layout')
    # UIKit can temporarily hide/fade the parent during tab switching. Keep
    # the mounted material instead of invalidating and recreating its backdrop.
    for visibility in ({'hidden': True}, {'hidden': False, 'alpha': 0.5},
                       {'hidden': False, 'alpha': 1.0}):
        rt.objects[rt.ROOT].state.update(visibility)
        cpu.run(d['material_update'], rt.BAR, rt.PROXY)
    require(rt.objects[rt.PROXY].state['effect'] == effect and
            len([e for e in rt.events if e['event'] == 'setEffect']) == before,
            'Hide/fade/show of the same mounted surface does not reset glass')
    # Window lifecycle uses the real installed didMoveToWindow hook.
    cpu.run(d['installer']); rt.reparent(rt.ROOT,0)
    cpu.run(d['window'],rt.BAR,rt.sel('didMoveToWindow'))
    require(not any(o == rt.PROXY and k >= 0x11900 for o,k in rt.associations),
            'Window detach invalidates material metadata')
    new_window = rt.view('UIWindow','new_window',(0,0,390,844))
    rt.reparent(rt.ROOT,new_window)
    cpu.run(d['window'],rt.BAR,rt.sel('didMoveToWindow'))
    require(rt.objects[rt.PROXY].state['effect'] != effect,'New window gets fresh material')
    cases = []
    for name in ('zero_bounds','hidden_ancestor','cumulative_alpha','factory_missing','factory_nil'):
        c,r = make(data)
        old = r.objects[r.PROXY].state['effect']
        if name == 'zero_bounds': r.objects[r.PROXY].state['bounds'] = (0,0,0,56)
        elif name == 'hidden_ancestor': r.objects[r.ROOT].state['hidden'] = True
        elif name == 'cumulative_alpha':
            r.objects[r.ROOT].state['alpha'] = .9994
            r.objects[r.BAR].state['alpha'] = .9994
        elif name == 'factory_missing': r.glass_factory_available = False
        elif name == 'factory_nil': r.glass_factory_nil = True
        result = c.run(d['material_update'],r.BAR,r.PROXY)
        require(result['result'] == 0 and r.objects[r.PROXY].state['effect'] == old,
                name+': invalid/unavailable material leaves previous effect intact')
        require(not any(e['event'] == 'setEffect' for e in r.events),name+': no partial replacement')
        cases.append({'name':name,'passed':True,'instructions':c.steps})
    # Synchronous effect callbacks cannot start another rebuild inside repair.
    c,r = make(data);seen=[]
    def reenter(current,event):
        if event['event'] == 'setEffect':
            require(r.associations.get((r.BAR,d['busy_key'])) == r.BAR,'Material rebuild inside busy scope')
            seen.append(current.run(d['repair'],r.BAR)['result'])
    r.on_event = reenter
    c.run(d['repair'],r.BAR)
    require(seen == [1],'The single native effect callback short circuits via busy guard')
    return {'passed':True,'actual_original_call_site':True,'frame_attach_order':actions,
            'reuse_and_new_window':True,'failure_guards':cases,'synchronous_reentry':True,
            'scope':'Actual material control flow and public setter arguments; no glass rendering or CA timing'}


def observation(data,d,make):
    c,r = make(data)
    c.run(d['repair'],r.BAR); r.flush_main(c);r.drain_operations(c)
    first = saved(r)
    require(len(first) == 1 and first[0]['event'] == 'bottom_bar_state_changed','First observed state recorded')
    c.run(d['repair'],r.BAR); c.run(d['repair'],r.BAR)
    require(not r.queued_operations,'Unchanged repairs enqueue no repeated snapshots')
    r.objects[r.BAR].state['selectedItem'] = 0
    c.run(d['repair'],r.BAR);r.drain_operations(c)
    records = saved(r)
    require(len(records) == 2,'One changed state gives one additional event')
    snapshot = records[-1]['data']
    require(snapshot['selectedIndex'] is None,'Missing selection remains JSON null')
    require('glassContentChildren' in snapshot and 'managedScrolls' in snapshot,
            'Owned child and multi-edge context captured')
    require(len(snapshot['managedScrolls']) == 1 and
            snapshot['managedScrolls'][0]['viewId'] == r.SCROLL and
            snapshot['managedScrolls'][0]['originalBottomEdgeHidden'] == 0 and
            snapshot['managedScrolls'][0]['bottomEdgeHidden'] == 1,
            'Current managed view and both original/current edge states captured')
    title = snapshot['glassContentChildren']['views'][0]['buttonTitleLabel']
    require(title['layerShadowOpacity'] == float(__import__('struct').unpack('<f',__import__('struct').pack('<f',.9))[0]),
            'Actual FCVT converts layer float to diagnostic double')
    require(title['layerShadowRadius'] == 2.0 and 'layerShouldRasterize' in title,'Text layer diagnostics present')
    require('text' not in json.dumps(snapshot),'Snapshot does not read label text')
    before = len(r.events);r.thread='worker';c.run(d['diagnostic_observe'],r.BAR);r.thread='main'
    require(len(r.events) == before,'Off-main observer exits before view access')
    # The build now also owns a 0.25s visibility monitor. Exercise the actual
    # diagnostic maintenance timer, not whichever timer happened to allocate first.
    timers = [p for p,o in r.objects.items() if r.class_names[o.cls] == 'NSTimer'
              and o.state.get('interval') == 60.0]
    require(len(timers) == 1, 'Exactly one diagnostic heartbeat timer')
    timer = timers[0]
    r.now += 3601
    st = r.objects[timer].state
    r.invoke(c,st['target'],st['selector'],timer,'main');r.drain_operations(c)
    after = saved(r)
    require(len(after) == 1 and after[0]['timestamp'] == r.now,'Delayed timer prunes old state and retains fresh heartbeat')
    return {'passed':True,'unchanged_deduplicated':True,'nil_selection_and_shadow_fields':True,
            'off_main_guard':True,'timer_interval_seconds':st['interval'],'delayed_timer_prunes':True,
            'instructions':c.steps}


def window_restart(data,d,make):
    with tempfile.TemporaryDirectory(prefix='fqab-restart-audit156-') as folder:
        c,r = make(data,disk_root=folder);t=r.now
        target,_ = open_settings(c,r,d)
        r.drain_operations(c)
        # Start test records after the actual bootstrap record. Include exact
        # boundary, sub-second older value, future value, and repaired bad time.
        # Place future first, then emulate clock rollback. Advancing a later
        # command cutoff would legitimately delete a boundary record that
        # cannot be resurrected by a subsequent backward-clock export.
        for ts,event in [(t+1,'future'),(t-3600.001,'expired'),(t-3600,'boundary'),(t-1,'inside'),(t,'at_end')]:
            c.run(d['diagnostic_enqueue'],r.record(ts,event,unicode='玻璃✓\n完整',nullable=None))
        c.run(d['diagnostic_enqueue'],r.record(float('nan'),'invalid_time_repaired'))
        export_command(c,r,d,target,t)
        # A command AFTER the marker with the same timestamp must not appear
        # in this export; later queue-operation ordering must not alter FIFO.
        c.run(d['diagnostic_enqueue'],r.record(t,'after_marker_same_time'))
        r.now = t+7200
        r.drain_operations(c,reverse=True)
        doc,path = exported(r,target)
        events = [e['event'] for e in doc['entries']]
        require('boundary' in events and 'inside' in events and 'at_end' in events and
                'invalid_time_repaired' in events and 'expired' not in events and 'future' not in events and
                'after_marker_same_time' not in events,'Inclusive fixed request window and insertion watermark')
        require(doc['windowStart'] == t-3600 and doc['windowEnd'] == t and doc['clockSkew'] == 1,
                'Export uses request time despite 2-hour worker delay and marks rollback/future time')
        require(all(e['sequence'] < doc['requestSequence'] for e in doc['entries']), 'Marker sequence excludes later insertion')
        before = saved(r)
        require(any(e['event'] == 'future' for e in before),'Future record remains retained')
        require(any(e['event'] == 'after_marker_same_time' for e in before),'Post-marker record persisted after export')
        require(not any('exportTarget' in e for e in before),'No controller/marker in persistent records')
        # New runtime, object graph, dynamic class and queue; same real file.
        c2,r2 = make(data,disk_root=folder);r2.now=t+2
        target2,_=open_settings(c2,r2,d);export_command(c2,r2,d,target2,t+2)
        r2.drain_operations(c2)
        restarted,path2 = exported(r2,target2)
        names=[e['event'] for e in restarted['entries']]
        require('inside' in names and 'future' in names and 'after_marker_same_time' in names and 'boundary' not in names,
                'Fresh runtime restores durable history and applies new one-hour cutoff')
        require(path.exists() and path != path2,'Separate export paths do not overwrite previous share file')
        require(all(e.get('directory') == 14 for e in r.events+r2.events if e['event']=='storage_directory'),
                'Both launch paths actually request Application Support')
        return {'passed':True,'inclusive_boundary':True,'delayed_worker_seconds':7200,
                'operation_order_reversed':True,'marker_excludes_later_same_time':True,
                'invalid_time_repaired':True,'clock_rollback_future_preserved':True,
                'restart_read_from_real_plist':True,'unique_export_files':True,
                'instructions':c.steps+c2.steps}


def complete_export(data,d,make):
    # Seed durable history through the documented format, then execute the
    # actual loader/pruner/exporter. This is 1025 restored records, not a claim
    # that 1025 enqueue calls or any iPhone benchmark were performed.
    with tempfile.TemporaryDirectory(prefix='fqab-complete-audit156-') as folder:
        c,r=make(data,disk_root=folder);t=r.now
        records=[{'timestamp':t-3500+i/10,'event':'restored','sequence':i+1,
                  'index':i,'unicode':'完整记录✓中文\n'+str(i),'nested':{'null':None,'array':[i,True,'x']}}
                 for i in range(1025)]
        path=journal(r);path.parent.mkdir(parents=True)
        path.write_bytes(plistlib.dumps([json.dumps(records,ensure_ascii=False).encode()],fmt=plistlib.FMT_BINARY))
        target,_=open_settings(c,r,d)
        c.run(d['diagnostic_enqueue'],r.record(t,'fresh_after_restore',payload='尾部也必须保留'))
        export_command(c,r,d,target,t);r.drain_operations(c)
        doc,out=exported(r,target)
        restored=[e for e in doc['entries'] if e['event']=='restored']
        require(restored == records,'All 1025 complete nested Unicode records survive actual load/prune/JSON export')
        require(any(e['event']=='fresh_after_restore' for e in doc['entries']),'New actual enqueue retained with history')
        require(len(saved(r)) == len(doc['entries']),'Durable and exported complete record arrays agree')
        return {'passed':True,'restored_record_count':1025,'export_record_count':len(doc['entries']),
                'export_bytes':out.stat().st_size,'all_nested_fields_compared':True,'instructions':c.steps,
                'scope':'1025 restored synthetic records plus real new enqueue/bootstrap events, not 1025 enqueue benchmark'}


def io_and_ui(data,d,make):
    c,r=make(data);target,button=open_settings(c,r,d)
    r.drain_operations(c);old=journal(r).read_bytes()
    c.run(d['diagnostic_enqueue'],r.record(r.now,'retained_despite_disk_error',nullable=None))
    r.fail_write_prefix = r.disk_root/'ApplicationSupport'
    r.drain_operations(c)
    require(journal(r).read_bytes() == old,'Injected journal write failure preserves previous durable bytes')
    action=r.objects[button].state['action']
    r.invoke(c,target,action,button,'main')
    require(not r.objects[button].state['enabled'],'Export disables sender while pending')
    pending=len(r.queued_operations);r.invoke(c,target,action,button,'main')
    require(len(r.queued_operations)==pending,'Duplicate export click does not enqueue a second request')
    r.drain_operations(c)
    doc,path=exported(r,target)
    require(any(e['event']=='retained_despite_disk_error' for e in doc['entries']) and doc['storageError'],
            'Memory export succeeds despite journal failure and discloses error')
    require(not r.objects[target].state['presentedViewController'],'Worker never presents UIKit')
    r.flush_main(c)
    require(r.objects[button].state['enabled'] and (target,d['ui_busy_key']) not in r.associations,
            'Main callback restores sender and clears busy')
    share=r.objects[target].state['presentedViewController']
    require(r.class_names[r.objects[share].cls]=='UIActivityViewController','Actual UI presenter opens share controller')
    require(r.objects[r.objects[share].state['popover']].state['anchor']==button,'Popover anchored to export button')
    require(r.string_value(r.objects[r.objects[share].state['activityItems']].state['items'][0])==str(path),
            'Share item is exactly successful full export URL')
    # Retry persist, then fail export. The UI must show an error and reenable.
    r.fail_write_prefix=None;c.run(d['diagnostic_maintenance']);r.drain_operations(c)
    require(any(e['event']=='retained_despite_disk_error' for e in saved(r)),'Later maintenance retries the full in-memory history')
    r.objects[target].state['presentedViewController']=0;r.fail_write=True
    r.invoke(c,target,action,button,'main');r.drain_operations(c)
    result=export_callback(r,target)
    require('error' in result and 'url' not in result,'Failed export never returns false URL success')
    r.flush_main(c)
    alert=r.objects[target].state['presentedViewController']
    require(r.class_names[r.objects[alert].cls]=='UIAlertController' and r.objects[button].state['enabled'],
            'Actual error presenter shows alert and restores button')
    require((target,d['ui_sender_key']) not in r.associations,'Sender association released after completion')
    # A corrupt saved file is diagnosed while new valid records remain usable.
    c2,r2=make(data);p=journal(r2);p.parent.mkdir(parents=True);p.write_bytes(b'not a plist')
    t2,_=open_settings(c2,r2,d);export_command(c2,r2,d,t2,r2.now);r2.drain_operations(c2)
    corrupted,_=exported(r2,t2)
    require(corrupted['storageError'] and any(e['event']=='plugin_start' for e in corrupted['entries']),
            'Corrupt restart history is surfaced while current diagnostics export')
    return {'passed':True,'whole_original_settings_menu_executed':True,'high_argument_ABI':True,
            'journal_atomic_failure_keeps_old_bytes':True,'memory_export_after_storage_failure':True,
            'duplicate_click_guard':True,'worker_to_main_share_and_popover':True,
            'retry_full_persist':True,'failed_export_error_UI':True,'corrupt_restart_reported':True,
            'instructions':c.steps+c2.steps}


def concurrent_enqueue(data,d,make):
    c,r=make(data);c.run(d['diagnostic_init']);r.flush_main(c);r.drain_operations(c)
    c.run(d['diagnostic_enqueue'],r.record(r.now,'first_batch'))
    injected=[]
    def add_after_batch_taken(cpu,event):
        if injected or event['event']!='unlock' or r.thread!='worker':return
        injected.append(True)
        # Model another producer between worker lock release and processing.
        # Its CPU register context is independent; shared heap/queue is real
        # model state. Both executions use the candidate's enqueue routine.
        old_x,old_v,old_pc,old_sp=cpu.x[:],cpu.v[:],cpu.pc,cpu.sp
        flags=(cpu.n,cpu.z,cpu.c,cpu.overflow);old_thread=r.thread
        r.thread='producer';cpu.run(d['diagnostic_enqueue'],r.record(r.now,'arrived_during_drain'))
        cpu.x[:],cpu.v[:],cpu.pc,cpu.sp=old_x,old_v,old_pc,old_sp
        cpu.flags(*flags);r.thread=old_thread
    r.on_event=add_after_batch_taken;r.drain_operations(c,reverse=True);r.on_event=None
    rows=saved(r)
    require([e['event'] for e in rows]==['first_batch','arrived_during_drain'],'Drain takes a second FIFO batch without loss/duplicate')
    require(rows[0]['sequence']<rows[1]['sequence'] and not r.queued_operations,'Monotonic sequence and no stranded operation')
    return {'passed':True,'producer_during_worker_unlock':True,'FIFO_and_no_lost_wakeup':True,
            'instructions':c.steps,'scope':'One controlled scheduling interleaving; no exhaustive threaded Foundation test'}


def run_all(data,d,make):
    return {'material_lifecycle':material(data,d,make),
            'diagnostic_observation':observation(data,d,make),
            'time_window_restart':window_restart(data,d,make),
            'full_export':complete_export(data,d,make),
            'diagnostic_UI_and_IO':io_and_ui(data,d,make),
            'producer_interleaving':concurrent_enqueue(data,d,make)}
