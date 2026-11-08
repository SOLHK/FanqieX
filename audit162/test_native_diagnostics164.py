#!/usr/bin/env python3
"""Execute compiled diagnostic hooks against explicit native-call fixtures.

The actual candidate installs hooks, forwards arguments, builds records and
writes its journal. The host implementations and Foundation services are
modeled. No iOS renderer, transport socket or device lifecycle is executed.
"""
import argparse
import hashlib
import json
from pathlib import Path
import plistlib
import struct

from arm64 import CPU, require
from mock_foundation import Runtime as FoundationRuntime
from test_feed_viewport import labels_for


PRIVATE = 'PRIVATE_COMMENT_BODY_TOKEN_COOKIE_BOOK_CHAPTER_MUST_NOT_EXPORT'
HOOKS = (
    ('FQCReaderParagraphEndView', 'setModel:', 'v24@0:8@16'),
    ('FQCReaderParagraphEndView', 'updateIdeaLabelCount', 'v16@0:8'),
    ('FQCReaderParagraphEndView', 'ideaCountTap', 'v16@0:8'),
    ('FQCParagraphEntranceViewModel', 'setIdeaCount:', 'v24@0:8q16'),
    ('FQCParagraphEntranceViewModel', 'setIdeaOriginCount:', 'v24@0:8q16'),
    ('SSParagraphIdeaDataVal', 'setIdeaCount:', 'v24@0:8q16'),
    ('SSParagraphIdeaDataVal', 'set_ideaCount:', 'v24@0:8q16'),
    ('SSParagraphIdeaDataVal', 'setBubbleData:', 'v24@0:8@16'),
    ('SSReaderParagraphCommentAdapter', 'showParagraphCommentVCWithOpenParams:', 'v24@0:8@16'),
    ('SSReaderParagraphCommentAdapter', 'paragraphCommentPanelDidDismissForSessionToken:', 'v24@0:8@16'),
    ('FQCParagraphCommentListViewController', 'viewDidAppear:', 'v20@0:8B16'),
    ('FQCParagraphCommentListViewController', 'viewWillDisappear:', 'v20@0:8B16'),
    ('FQCParagraphCommentListViewController', 'viewDidDisappear:', 'v20@0:8B16'),
    ('SSReaderCommunityDataManager', 'paragraphIdeaUpdateCountWithChapterId:bookId:paraIndex:count:', 'v48@0:8@16@24q32q40'),
    ('FQCCommunityReaderDataDispatcher', 'saveParagraphIdeaListIntoCacheWithChapterId:paragraphListData:', 'v32@0:8@16@24'),
    ('BDRpcAsyncOperation', 'initWithRequest:completion:', '@32@0:8@16@?24'),
    ('BDRpcAsyncOperation', 'sendRequest', 'v16@0:8'),
    ('BDRpcAsyncOperation', 'cancel', 'v16@0:8'),
    ('BDRpcAsyncOperation', 'completeOperation', 'v16@0:8'),
    ('BDRpcAsyncOperation', '_postHandleResult:headerFields:', 'v32@0:8@16@24'),
    ('BDRpcResponse', 'initWithRequest:response:', '@32@0:8@16@24'),
    ('UIApplication', 'sendAction:to:from:forEvent:', 'B48@0:8:16@24@32@40'),
    ('UINavigationController', 'pushViewController:animated:', 'v28@0:8@16B24'),
    ('UINavigationController', 'popViewControllerAnimated:', '@20@0:8B16'),
    ('NSException', 'raise', 'v16@0:8'),
)


class Runtime(FoundationRuntime):
    def __init__(self, data, slide):
        super().__init__(data, slide)
        self.hosts = {}
        self.original_calls = []
        self.forbidden_messages = []
        self.thread_objects = {}
        self.delayed = []
        for name in ('FQCReaderParagraphEndView', 'SiblingParagraphView'):
            self._class(name, 'UIView')
        for name in ('FQCParagraphEntranceViewModel', 'SSParagraphIdeaDataVal',
                     'SSReaderParagraphCommentAdapter', 'SSReaderCommunityDataManager',
                     'FQCCommunityReaderDataDispatcher', 'BDRpcAsyncOperation',
                     'BDRpcResponse', 'BDRpcInternalRequest', 'BDRpcMethod',
                     'BDRpcInternalResponse', 'UIApplication', 'NSException', 'BDReaderViewController'):
            self._class(name, 'NSObject')
        self._class('FQCParagraphCommentListViewController', 'UIViewController')
        self._class('FQCParagraphCommentV1ListViewController', 'FQCParagraphCommentListViewController')
        self._class('UIControl', 'UIView')
        self.host_method('UIView', 'setHidden:', 'v20@0:8B16')
        self.host_method('UIView', 'removeFromSuperview', 'v16@0:8')
        for cls, selector, encoding in HOOKS:
            self.host_method(cls, selector, encoding)
        for selector in ('viewDidAppear:', 'viewWillDisappear:', 'viewDidDisappear:'):
            self.host_method('FQCParagraphCommentV1ListViewController', selector, 'v20@0:8B16')

    def host_method(self, cls, selector, encoding):
        imp = 0x33010000 + len(self.hosts) * 0x100
        self.hosts[imp] = (cls, selector)
        self._add(self.classes[cls], selector, imp, encoding)
        return imp

    def hosts_for(self, cls, selector):
        return next(imp for imp, pair in self.hosts.items() if pair == (cls, selector))

    def responds(self, receiver, name):
        state = self.objects[receiver].state
        if name in state:
            return True
        if name == 'count' and self.is_kind(receiver, self.classes['NSDictionary']):
            return True
        return super().responds(receiver, name)

    def handle(self, cpu, pc):
        self.current_cpu = cpu
        args = cpu.x[:8]
        receiver, selector = args[:2]
        if pc in self.hosts:
            cls, name = self.hosts[pc]
            require(selector == self.sel(name), 'Forwarded host selector remains exact')
            self.original_calls.append((cls, name, receiver, tuple(args[2:6])))
            if cls == 'FQCParagraphCommentV1ListViewController':
                # The modeled subclass calls its lexical parent once. The
                # candidate's installed parent implementation still executes.
                parent = self.classes['FQCParagraphCommentListViewController']
                method = self.get_method(parent, selector)
                cpu.pc = self.methods[method]['imp']
                return True
            state = self.objects[receiver].state
            result = 0
            if name == 'setModel:':
                state['model'] = args[2]
            elif name in ('setIdeaCount:', 'setIdeaOriginCount:', 'set_ideaCount:'):
                key = {'setIdeaCount:': 'ideaCount', 'setIdeaOriginCount:': 'ideaOriginCount',
                       'set_ideaCount:': '_ideaCount'}[name]
                value = args[2] if args[2] < (1 << 63) else args[2] - (1 << 64)
                state[key] = value
            elif name == 'setBubbleData:':
                state['bubbleData'] = args[2]
            elif name == 'setHidden:':
                state['hidden'] = bool(args[2])
            elif name == 'removeFromSuperview':
                self.reparent(receiver, 0)
            elif name == 'showParagraphCommentVCWithOpenParams:':
                state['paragraphCommentPanelSessionToken'] = self.obj('NSObject', 'panel_session')
            elif name == 'paragraphCommentPanelDidDismissForSessionToken:':
                require(args[2] == state['paragraphCommentPanelSessionToken'],
                        'Exact panel session token is forwarded')
                state['paragraphCommentPanelSessionToken'] = 0
            elif name == 'initWithRequest:completion:':
                state['rpcRequest'] = args[2]
                state['completion'] = args[3]
                result = receiver
            elif name == 'initWithRequest:response:':
                state.update(self.objects[args[3]].state)
                result = receiver
            elif name == 'sendAction:to:from:forEvent:':
                result = 1
            elif name == 'popViewControllerAnimated:':
                result = state.get('popped',0)
            return self.finish(cpu, result)
        if pc - self.slide == 0xa5d4 and receiver:
            name = self.selector_names[selector]
            if receiver in self.objects:
                state = self.objects[receiver].state
                method = self.get_method(self.objects[receiver].cls, selector)
                if method:
                    return super().handle(cpu, pc)
                if name in ('paraContent', 'text', 'headers', 'headerFields', 'url', 'description'):
                    self.forbidden_messages.append(name)
                    raise AssertionError('Diagnostic read a private field: ' + name)
                if name in state:
                    return self.finish(cpu, state[name])
                if name == 'isEqualToString:':
                    return self.finish(cpu, int(self.string_value(receiver) == self.string_value(args[2])))
                if name == 'isEnabled':
                    return self.finish(cpu, int(state.get('enabled', True)))
                if name == 'count' and self.is_kind(receiver, self.classes['NSDictionary']):
                    return self.finish(cpu, len(state['items']))
                if name == 'length' and self.is_kind(receiver, self.classes['NSData']):
                    return self.finish(cpu, len(state['value']))
                if name == 'longLongValue' and self.is_kind(receiver, self.classes['NSNumber']):
                    return self.finish(cpu, int(state['value']))
                if name == 'systemUptime':
                    return self.finish(cpu, fp=(self.now - 1699999000.0,))
                if name == 'boolForKey:':
                    return self.finish(cpu, int(bool(state['values'].get(self.string_value(args[2]), 0))))
                if name == 'performSelector:withObject:afterDelay:':
                    self.delayed.append((receiver, args[2], args[3], cpu.fp(0)))
                    return self.finish(cpu)
            elif receiver == self.classes['NSNumber'] and name == 'numberWithLongLong:':
                value = args[2] if args[2] < (1 << 63) else args[2] - (1 << 64)
                return self.finish(cpu, self.box(value))
            elif receiver == self.classes['NSThread'] and name == 'currentThread':
                if self.thread not in self.thread_objects:
                    self.thread_objects[self.thread] = self.obj('NSThread', 'thread_' + self.thread)
                return self.finish(cpu, self.thread_objects[self.thread])
        return super().handle(cpu, pc)


def make(data, labels, slide=0):
    rt = Runtime(data, slide)
    words = struct.unpack_from('<64I', data, 0x800)
    cpu = CPU(data, rt, slide, ranges=[(0x900, 0x800 + words[55]),
                                      (0x14080, 0x800 + words[61]),
                                      (0x4878, 0x48d0), (0x7394, 0x746c)])
    cpu.pointers.update(rt.rebase_pointers)
    cpu.run(labels['LFQD_FQDInstall'])
    return cpu, rt


def send(cpu, rt, receiver, selector, *args):
    return cpu.run(0xa5d4, args=(receiver, rt.sel(selector), *args))


def journal(cpu, rt, data):
    words = struct.unpack_from('<64I', data, 0x800)
    cpu.run(0x800 + words[38])
    rt.drain_operations(cpu)
    path = rt.disk_root / 'ApplicationSupport' / 'FanqieAdBlockDiagnostics' / 'recent.plist'
    rows = json.loads(plistlib.loads(path.read_bytes())[0])
    encoded = json.dumps(rows, ensure_ascii=False)
    require(PRIVATE not in encoded, 'Private content and credentials stay outside diagnostic records')
    require(not rt.forbidden_messages, 'Diagnostics read only allowed structural properties')
    return rows


def installation(data, labels, slide):
    cpu, rt = make(data, labels, slide)
    parent = rt.classes['UIView']
    parent_hidden = rt.methods[rt.get_method(parent, rt.sel('setHidden:'))]['imp']
    require(parent_hidden == rt.hosts_for('UIView', 'setHidden:'),
            'Parent UIView implementation survives installation')
    sibling = rt.classes['SiblingParagraphView']
    require(rt.methods[rt.get_method(sibling, rt.sel('setHidden:'))]['imp'] == parent_hidden,
            'Sibling paragraph classes retain their original hidden implementation')
    target = rt.classes['FQCReaderParagraphEndView']
    installed = rt.methods[rt.get_method(target, rt.sel('setHidden:'))]
    require(installed['class'] == target and installed['imp'] != parent_hidden,
            'Inherited observer is localized to the intended bubble class')
    before = len([event for event in rt.events if event['event'] == 'method_setImplementation'])
    cpu.run(labels['LFQD_FQDInstall'])
    after = len([event for event in rt.events if event['event'] == 'method_setImplementation'])
    require(before == after, 'Repeated installation preserves existing hooks and aliases')
    return {'slide': hex(slide), 'parent_and_sibling_preserved': True,
            'repeated_installation_stable': True, 'installed_methods': before}


def bubble_cycle(data, labels, count, slide):
    cpu, rt = make(data, labels, slide)
    chapter = rt.text_object(PRIVATE + '_chapter')
    paragraph = rt.text_object(PRIVATE + '_paragraph')
    model = rt.obj('FQCParagraphEntranceViewModel', 'entrance_model', ideaCount=count,
                   ideaOriginCount=count, chapterId=chapter, paragraphId=paragraph, isFromCache=0)
    bubble = rt.view('FQCReaderParagraphEndView', 'paragraph_bubble', parent=rt.ROOT)
    adapter = rt.obj('SSReaderParagraphCommentAdapter', 'reader_adapter',
                     paragraphCommentPanelSessionToken=0)
    panel = rt.obj('FQCParagraphCommentV1ListViewController', 'comment_panel')
    send(cpu, rt, bubble, 'setModel:', model)
    send(cpu, rt, bubble, 'ideaCountTap')
    send(cpu, rt, adapter, 'showParagraphCommentVCWithOpenParams:', rt.obj('NSObject', 'open_params'))
    send(cpu, rt, panel, 'viewDidAppear:', 1)
    send(cpu, rt, model, 'setIdeaCount:', 0)
    send(cpu, rt, bubble, 'updateIdeaLabelCount')
    send(cpu, rt, panel, 'viewWillDisappear:', 1)
    token = rt.objects[adapter].state['paragraphCommentPanelSessionToken']
    send(cpu, rt, adapter, 'paragraphCommentPanelDidDismissForSessionToken:', token)
    send(cpu, rt, panel, 'viewDidDisappear:', 1)
    send(cpu, rt, bubble, 'setHidden:', 1)
    rows = journal(cpu, rt, data)
    names = [row['event'] for row in rows]
    required = ['commentBubbleTap', 'commentPanelOpenBegin', 'commentPanelOpenReturned',
                'commentPanelDidAppear', 'commentCountChanged', 'commentBubbleCountUI',
                'commentPanelWillDisappear', 'commentPanelDismissBegin',
                'commentPanelDismissReturned', 'commentPanelDidDisappear', 'commentBubbleHidden']
    observed = [name for name in names if name in required]
    require(observed == required, 'Bubble-to-panel event order follows actual hook dispatch')
    chain = [row for row in rows if row['event'] in required]
    require(len({row['data']['correlationId'] for row in chain}) == 1,
            'Tap, open, model change and dismissal share one correlation identifier')
    change = next(row['data'] for row in rows if row['event'] == 'commentCountChanged')
    require(change['before']['count'] == count and change['after']['count'] == 0,
            'Count transition is observed without changing the host setter result')
    hidden = next(row['data'] for row in rows if row['event'] == 'commentBubbleHidden')
    require(hidden['beforeHidden'] == 0 and hidden['afterHidden'] == 1,
            'Host-directed hiding is observed and preserved')
    require(rt.objects[bubble].state['model'] == model and rt.objects[model].state['ideaCount'] == 0,
            'Original binding and model mutation complete')
    require(sum(name == 'setIdeaCount:' for _, name, _, _ in rt.original_calls) == 1,
            'Host count setter executes exactly once')
    return {'starting_count': count, 'slide': hex(slide), 'events': len(chain),
            'count_before': count, 'count_after': 0, 'privacy_sentinel_absent': True}


def network(data, labels, slide):
    cpu, rt = make(data, labels, slide)
    paths = ('$POST /novel/commentapi/idea/list/:item_id/v1/',
             '$POST /novel/commentapi/comment/list/:group_id/v1/',
             '$POST /unrelated/account/profile/v1/')
    completion = rt.obj('NSObject', 'opaque_completion_pointer')
    tracked = []
    for index, path in enumerate(paths):
        method = rt.obj('BDRpcMethod', 'request_method', operationType=rt.text_object(path))
        request = rt.obj('BDRpcInternalRequest', 'rpc_request', method=method)
        operation = rt.obj('BDRpcAsyncOperation', 'operation')
        result = send(cpu, rt, operation, 'initWithRequest:completion:', request, completion)
        require(result['result'] == operation, 'Request initializer preserves its original result')
        require(rt.objects[operation].state['completion'] == completion,
                'Diagnostic initializer forwards the original callback pointer')
        rt.now += 1.0
        send(cpu, rt, operation, 'sendRequest')
        headers = rt.box({'Authorization': PRIVATE, 'Cookie': PRIVATE})
        rt.now += 1.0
        send(cpu, rt, operation, '_postHandleResult:headerFields:', rt.box({'private': PRIVATE}), headers)
        response = rt.obj('BDRpcResponse', 'transport_response')
        internal = rt.obj('BDRpcInternalResponse', 'internal_response', statusCode=503,
                          rawData=rt.box(b'private response'), error=rt.obj('NSError', 'network_error', code=-1001))
        rt.now += 1.0
        result = send(cpu, rt, response, 'initWithRequest:response:', request, internal)
        require(result['result'] == response, 'Transport initializer preserves its original result')
        rt.now += 1.0
        send(cpu, rt, operation, 'cancel')
        tracked.append(operation)
    rows = journal(cpu, rt, data)
    created = [row for row in rows if row['event'] == 'commentRequestCreated']
    require(len(created) == 2, 'Only the exact two comment API paths are observed')
    for row in created:
        request_id = row['data']['requestId']
        group = [entry for entry in rows if entry.get('data', {}).get('requestId') == request_id]
        names = [entry['event'] for entry in group]
        require(names == ['commentRequestCreated', 'commentRequestSend', 'commentResponseParsed',
                          'commentResponseDelivered', 'commentNetworkResponse', 'commentRequestCancel'],
                'Request identifier survives send, response and cancellation')
        require(len({entry['data']['correlationId'] for entry in group}) == 1,
                'Network stages preserve their captured correlation')
        times = [entry['data']['uptime'] for entry in group]
        require(times == sorted(times) and times[0] < times[-1],
                'Later context updates cannot overwrite an earlier queued event timestamp')
        response = next(entry['data'] for entry in group if entry['event'] == 'commentNetworkResponse')
        require(response['statusCode'] == 503 and response['errorCode'] == -1001 and response['responseBytes'] == 16,
                'Transport fields preserve HTTP status, signed error code and byte length')
    require(sum(name == 'sendRequest' for _, name, _, _ in rt.original_calls) == 3 and
            sum(name == 'cancel' for _, name, _, _ in rt.original_calls) == 3,
            'Tracked and unrelated host request methods all execute exactly once')
    require('unrelated/account' not in json.dumps(rows), 'Unrelated API path is absent')
    return {'slide': hex(slide), 'tracked_comment_requests': 2, 'unrelated_requests_observed': 0,
            'original_callbacks_preserved': True, 'privacy_sentinel_absent': True}


def signed_instruction_controls():
    class NativeBoundary:
        def handle(self, cpu, pc):
            return False
    cases = ((0x93407c00, 0xffffffff, (1 << 64) - 1),
             (0x93407c00, 0x7fffffff, 0x7fffffff),
             (0x93401c00, 0x80, (1 << 64) - 128),
             (0x93403c00, 0x8000, (1 << 64) - 32768),
             (0x9344fc00, (1 << 64) - 32, (1 << 64) - 2))
    for opcode, value, expected in cases:
        cpu = CPU(struct.pack('<2I', opcode, 0xd65f03c0), NativeBoundary())
        require(cpu.run(0, args=(value,))['result'] == expected,
                'Signed compiler instruction preserves negative and positive values')
    return {'signed_extract_controls': len(cases)}


def ordered_requests(data, labels, slide):
    cpu,rt=make(data,labels,slide)
    operations=[]
    for _ in range(2):
        method=rt.obj('BDRpcMethod','comment_method',operationType=rt.text_object('$POST /novel/commentapi/comment/list/:group_id/v1/'))
        request=rt.obj('BDRpcInternalRequest','request',method=method)
        operation=rt.obj('BDRpcAsyncOperation','operation')
        send(cpu,rt,operation,'initWithRequest:completion:',request,0)
        send(cpu,rt,operation,'sendRequest')
        operations.append(operation)
    send(cpu,rt,operations[0],'sendRequest')
    send(cpu,rt,operations[1],'_postHandleResult:headerFields:',rt.box({'data':{'data_list':[], 'total':0,'has_more':False}}),0)
    send(cpu,rt,operations[0],'_postHandleResult:headerFields:',rt.box({'data':{'data_list':[{}], 'total':1,'has_more':False}}),0)
    rows=journal(cpu,rt,data)
    parsed=[r['data'] for r in rows if r['event']=='commentResponseParsed']
    require([r['responseOutOfOrder'] for r in parsed]==[0,1], 'Response order uses captured request ordinals')
    require([r['listCount'] for r in parsed]==[0,1], 'Empty and populated structures stay distinguishable')
    require(any(r['data'].get('retry')==1 for r in rows if r['event']=='commentRequestSend'), 'Repeated sends are explicitly recorded')
    return {'slide':hex(slide),'out_of_order_detected':True,'empty_data_observed':True,'retry_observed':True}


def enhanced_actions(data, labels, slide):
    cpu,rt=make(data,labels,slide)
    app=rt.obj('UIApplication','app')
    page=rt.obj('UIViewController','page')
    control=rt.view('UIControl','control',parent=rt.ROOT)
    rt.objects[control].state['nextResponder']=page
    send(cpu,rt,app,'sendAction:to:from:forEvent:',rt.sel('hostAction:'),page,control,0)
    require(not rt.delayed, 'Normal mode schedules no action watcher')
    rt.objects[rt.DEFAULTS].state['values']['FanqieX.EnhancedDiagnostics.1']=1
    send(cpu,rt,app,'sendAction:to:from:forEvent:',rt.sel('hostAction:'),page,control,0)
    require(len(rt.delayed)==1 and rt.delayed[0][3]==2.0, 'Enhanced mode schedules a two-second observation')
    observer,selector,token,_=rt.delayed[0]
    cpu.run(0xa5d4,args=(observer,selector,token))
    rows=journal(cpu,rt,data)
    selected=[r for r in rows if r['event'].startswith('uiAction')]
    require([r['event'] for r in selected]==['uiActionBegin','uiActionReturned','uiActionObservationTimeout'], 'Action and observation timeout are ordered')
    require(selected[-1]['data']['result']=='noObservedTransition' and
            selected[-1]['data']['coverage']=='monitoredHostEventsOnly', 'Timeout states its observable scope')
    return {'slide':hex(slide),'normal_mode_passive':True,'enhanced_timeout':True}


def exceptions_and_navigation(data,labels,slide):
    cpu,rt=make(data,labels,slide)
    exception=rt.obj('NSException','private_exception',reason=PRIVATE)
    send(cpu,rt,exception,'raise')
    require(sum(name=='raise' for _,name,_,_ in rt.original_calls)==1, 'Exception observation forwards the original raise exactly once')
    rt.objects[rt.DEFAULTS].state['values']['FanqieX.EnhancedDiagnostics.1']=1
    page=rt.obj('UIViewController','destination')
    nav=rt.obj('UINavigationController','nav',popped=page)
    send(cpu,rt,nav,'pushViewController:animated:',page,1)
    require(send(cpu,rt,nav,'popViewControllerAnimated:',1)['result']==page, 'Navigation pop preserves the original page result')
    rows=journal(cpu,rt,data)
    require([r['event'] for r in rows if r['event'].startswith('navigation')]==['navigationPushBegin','navigationPushReturned','navigationPopReturned'], 'Navigation events follow actual calls')
    require(sum(r['event']=='exceptionRaise' for r in rows)==1, 'The exception is represented without its private reason')
    return {'slide':hex(slide),'exception_original_forwarded':True,'navigation_result_preserved':True}


def main():
    parser = argparse.ArgumentParser(description=__doc__)
    parser.add_argument('--candidate', type=Path, required=True)
    parser.add_argument('--report', type=Path, required=True)
    args = parser.parse_args()
    data = args.candidate.read_bytes()
    labels = labels_for(data, args.candidate.with_suffix('.composed.s'), ['LFQD_FQDInstall'])
    cases = [signed_instruction_controls()]
    for slide in (0, 0x180000000):
        cases.append({'installation': installation(data, labels, slide)})
        for count in (0, 1, 7):
            cases.append({'bubble_cycle': bubble_cycle(data, labels, count, slide)})
        cases.append({'network': network(data, labels, slide)})
        cases.append({'ordered_requests':ordered_requests(data,labels,slide)})
        cases.append({'enhanced_actions':enhanced_actions(data,labels,slide)})
        cases.append({'exceptions_navigation':exceptions_and_navigation(data,labels,slide)})
    report = {'passed': True, 'candidate_sha256': hashlib.sha256(data).hexdigest(),
              'cases': cases, 'device_tested': False, 'native_transport_executed': False,
              'scope': 'Actual compiled ARM64 diagnostics with explicit host and Foundation boundaries'}
    args.report.parent.mkdir(parents=True, exist_ok=True)
    args.report.write_text(json.dumps(report, indent=2) + '\n')
    print(json.dumps({'passed': True, 'case_groups': len(cases),
                      'candidate_sha256': report['candidate_sha256']}, indent=2))


if __name__ == '__main__':
    main()
