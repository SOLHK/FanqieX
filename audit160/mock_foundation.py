"""Stateful native-call boundary for actual 1.5.6 ARM64 execution.

Foundation objects, runtime dispatch and scheduling are modeled. JSON/plist and
file bytes are real Python encodings/files. This is not iOS/Foundation execution.
"""
from pathlib import Path
import copy
import json
import math
import plistlib
import tempfile
import uuid

from arm64 import bits, require
from mock_uikit import Runtime as ViewRuntime


class Runtime(ViewRuntime):
    WINDOW_IMP = 0x33000400
    VIEW_LOAD_IMP = 0x33000500

    def _class(self,name,parent=None):
        p = super()._class(name,parent)
        meta = 0x38000000+len(self.metaclasses)*0x100
        self.metaclasses[p] = meta
        self.class_names[meta] = name+'(meta)'
        self.own[meta] = {}
        self.parents[meta] = self.metaclasses.get(self.classes.get(parent,0),0)
        return p

    def __init__(self,data,slide=0,disk_root=None,**options):
        self.metaclasses = {}; self.dynamic_classes = set(); self.initialized = set()
        self.thread = 'main'; self.now = 1700000000.0
        self.main_jobs = []; self.queued_operations = []; self.callbacks = []
        self.fail_read = False; self.fail_write = False; self.fail_directory = False
        self.fail_write_prefix = None
        self.fail_json = False; self.fail_plist = False
        self.glass_factory_available = True; self.glass_factory_nil = False
        self.visual_effect_nil = False; self.missing_classes = set()
        self.pool_balance = 0
        self._temp = tempfile.TemporaryDirectory(prefix='fqab-audit156-') if disk_root is None else None
        self.disk_root = Path(self._temp.name if self._temp else disk_root)
        self.disk_root.mkdir(parents=True,exist_ok=True)
        super().__init__(data,slide,**options)
        classes = [('NSString','NSObject'),('NSDictionary','NSObject'),('NSMutableDictionary','NSDictionary'),
                   ('NSMutableArray','NSArray'),('NSData','NSObject'),('NSNull','NSObject'),
                   ('NSDate','NSObject'),('NSThread','NSObject'),('NSProcessInfo','NSObject'),
                   ('NSHashTable','NSObject'),('NSUserDefaults','NSObject'),('NSURL','NSObject'),
                   ('NSError','NSObject'),('NSLock','NSObject'),('NSOperationQueue','NSObject'),
                   ('NSInvocationOperation','NSObject'),('NSTimer','NSObject'),('NSFileManager','NSObject'),
                   ('NSPropertyListSerialization','NSObject'),('NSJSONSerialization','NSObject'),
                   ('NSUUID','NSObject'),('UIVisualEffect','NSObject'),('UIGlassEffect','UIVisualEffect'),
                   ('UICornerConfiguration','NSObject'),('UIViewController','NSObject'),
                   ('UITableViewController','UIViewController'),('UINavigationController','UIViewController'),
                   ('UIActivityViewController','UIViewController'),('UIAlertController','UIViewController'),
                   ('UIAlertAction','NSObject'),('UIBarButtonItem','NSObject'),('UINavigationItem','NSObject'),
                   ('UIPopoverPresentationController','NSObject'),('UITraitCollection','NSObject'),
                   ('SSSettingViewController','UIViewController')]
        for name,parent in classes:
            self._class(name,parent)
        self._add(self.UIView,'didMoveToWindow',self.WINDOW_IMP,'v16@0:8')
        self._add(self.classes['SSSettingViewController'],'viewDidLoad',self.VIEW_LOAD_IMP,'v16@0:8')
        self.associations[(self.PROXY,slide+0xeb87)] = self.BAR
        self.PROXY_CONTENT = self.view('UIView','glass_content',(0,0,366,56),self.PROXY)
        self.objects[self.PROXY].state.update(contentView=self.PROXY_CONTENT,
                                              effect=self.obj('UIGlassEffect','initial_clear_effect',style=1,tintColor=0,interactive=True))
        self.reparent(self.BUTTON,self.PROXY_CONTENT)
        for p,obj in list(self.objects.items()):
            if self.is_kind(p,self.UIView):
                obj.state['opaque'] = False
        self.NULL = self.obj('NSNull','null')
        self.PROCESS = self.obj('NSProcessInfo','process')
        self.DEFAULTS = self.obj('NSUserDefaults','defaults',values={'FanqieAdBlock.Options.1':0x3ffff,
                                                                   'FanqieAdBlock.GlassDisabled.1':1})
        self.FILEMANAGER = self.obj('NSFileManager','file_manager')

    def string_value(self,p):
        if not p:
            return None
        if p in self.objects:
            return self.objects[p].state.get('value',self.objects[p].name)
        local = p-self.slide
        if 0x112f8 <= local < 0x118d8 and (local-0x112f8) % 32 == 0:
            flags = int.from_bytes(self.data[local+8:local+16],'little')
            target = int.from_bytes(self.data[local+16:local+24],'little') & ((1<<36)-1)
            count = int.from_bytes(self.data[local+24:local+32],'little')
            return self.data[target:target+count*(2 if flags & 0x10 else 1)].decode('utf-16le' if flags & 0x10 else 'utf-8')
        return self.string(p)

    def responds(self,receiver,name):
        cls = self.class_names[self.objects[receiver].cls]
        if name in ('doubleValue','unsignedLongLongValue'):
            return cls == 'NSNumber'
        if name in ('effect','setEffect:','setCornerConfiguration:'):
            return self.is_kind(receiver,self.classes['UIVisualEffectView'])
        return super().responds(receiver,name)

    def text_object(self,value):
        return self.obj('NSString','string:'+str(value)[:48],value=str(value))

    def box(self,value,mutable=False):
        if value is None:
            return self.NULL
        if isinstance(value,(int,float,bool)):
            return self.obj('NSNumber','number:'+str(value),value=value)
        if isinstance(value,str):
            return self.text_object(value)
        if isinstance(value,bytes):
            return self.obj('NSData','data',value=value)
        if isinstance(value,(list,tuple)):
            return self.obj('NSMutableArray' if mutable else 'NSArray','array',items=[self.box(v,mutable) for v in value])
        if isinstance(value,dict):
            return self.obj('NSMutableDictionary' if mutable else 'NSDictionary','dictionary',items={str(k):self.box(v,mutable) for k,v in value.items()})
        raise AssertionError('Unmodeled boxed value '+repr(value))

    def native(self,p):
        if not p or p == self.NULL:
            return None
        obj = self.objects[p]
        if self.is_kind(p,self.classes['NSDictionary']):
            return {k:self.native(v) for k,v in obj.state['items'].items()}
        if self.is_kind(p,self.classes['NSArray']):
            return [self.native(v) for v in obj.state['items']]
        if 'value' in obj.state:
            return obj.state['value']
        raise ValueError('Not a Foundation serializable value: '+obj.name)

    def dict_pointer(self,entries):
        return self.obj('NSMutableDictionary','dictionary',items=dict(entries))

    def object_equal(self,left,right):
        """NSObject identity plus modeled Foundation value/container equality."""
        if left == right:
            return True
        if not left or not right:
            return False
        a,b = self.objects[left],self.objects[right]
        for value_class in ('NSString','NSNumber','NSData'):
            cls = self.classes[value_class]
            if self.is_kind(left,cls) and self.is_kind(right,cls):
                return a.state['value'] == b.state['value']
        if self.is_kind(left,self.classes['NSArray']) and self.is_kind(right,self.classes['NSArray']):
            x,y = a.state['items'],b.state['items']
            return len(x) == len(y) and all(self.object_equal(p,q) for p,q in zip(x,y))
        if self.is_kind(left,self.classes['NSDictionary']) and self.is_kind(right,self.classes['NSDictionary']):
            x,y = a.state['items'],b.state['items']
            return x.keys() == y.keys() and all(self.object_equal(x[k],y[k]) for k in x)
        return False

    def record(self,timestamp,text='event',**fields):
        return self.box({'timestamp':timestamp,'event':text,**fields},mutable=True)

    def url(self,path):
        return self.obj('NSURL','url:'+str(path),value=str(path))

    def error(self,cpu,address,reason):
        if address:
            cpu.write(address,8,self.obj('NSError','error',value=reason))

    def finish(self,cpu,result=0,fp=None,float_value=None):
        ret = cpu.x[30]
        require(cpu.sp % 16 == 0,'Aligned stack at native call')
        self.clobber(cpu,result,fp,float_value); cpu.pc = ret
        return True

    def event(self,name,receiver=None,**detail):
        # A modeled native implementation saves its own return address across
        # synchronous callbacks, just as a real non-leaf AAPCS routine does.
        cpu = self.current_cpu
        saved_lr = cpu.x[30] if cpu is not None else None
        super().event(name,receiver,**detail)
        if cpu is not None:
            cpu.x[30] = saved_lr

    def ensure_initialized(self,cpu,cls):
        if cls not in self.dynamic_classes or cls in self.initialized:
            return
        self.initialized.add(cls)
        sel = self.sel('initialize')
        method = self.get_method(self.metaclasses[cls],sel)
        if method:
            old_x,old_v,old_pc = cpu.x[:],cpu.v[:],cpu.pc
            cpu.run(self.methods[method]['imp']-self.slide,cls,sel)
            # objc_msgSend preserves the original message arguments around the
            # runtime's +initialize dispatch, then invokes the requested method.
            cpu.x[:],cpu.v[:],cpu.pc = old_x,old_v,old_pc

    def invoke(self,cpu,target,selector,arg=0,thread=None):
        old_thread = self.thread
        if thread:
            self.thread = thread
        method = self.get_method(self.objects[target].cls,selector)
        require(method,'Scheduled selector has an implementation')
        result = cpu.run(self.methods[method]['imp']-self.slide,target,selector,arg,max_steps=30000000)
        self.thread = old_thread
        return result

    def flush_main(self,cpu):
        while self.main_jobs:
            target,selector,arg = self.main_jobs.pop(0)
            self.invoke(cpu,target,selector,arg,'main')

    def drain_operations(self,cpu,reverse=False):
        while self.queued_operations:
            p = self.queued_operations.pop(-1 if reverse else 0)
            st = self.objects[p].state
            self.invoke(cpu,st['target'],st['selector'],st['argument'],'worker')
        require(self.pool_balance == 0,'Worker autorelease pools balanced')

    def handle(self,cpu,pc):
        self.current_cpu = cpu
        p = pc-self.slide; a = cpu.x[:8]
        if p == 0xa5bc:
            self.pool_balance += 1
            return self.finish(cpu,0x3d000000+self.pool_balance)
        if p == 0xa574:
            self.pool_balance -= 1
            require(self.pool_balance >= 0,'No pool underflow')
            return self.finish(cpu)
        if p == 0xa61c:
            name = self.string(a[1])
            require(a[2] == 0,'No new instance ivars')
            if name in self.classes:
                return self.finish(cpu)
            cls = self._class(name,self.class_names[a[0]])
            self.dynamic_classes.add(cls)
            return self.finish(cpu,cls)
        if p == 0xa610:
            return self.finish(cpu)
        if p == 0xa664 and a[0] in self.metaclasses:
            return self.finish(cpu,self.metaclasses[a[0]])
        if p == 0xa604:
            return self.finish(cpu,self.get_method(self.metaclasses[a[0]],a[1]))
        if p == 0xa5b0 and self.string(a[0]) in self.missing_classes:
            return self.finish(cpu)
        if pc in (self.WINDOW_IMP,self.VIEW_LOAD_IMP):
            self.event('original_window' if pc == self.WINDOW_IMP else 'original_view_load',a[0],selector=a[1])
            return self.finish(cpu)
        if p != 0xa5d4:
            return super().handle(cpu,pc)
        receiver,selector = a[:2]
        name = self.selector_names.get(selector)
        if not receiver:
            return super().handle(cpu,pc)
        isclass = receiver in self.classes.values()
        if isclass:
            self.ensure_initialized(cpu,receiver)
            method = self.get_method(self.metaclasses[receiver],selector)
        else:
            method = self.get_method(self.objects[receiver].cls,selector) if receiver in self.objects else 0
        if method:
            cpu.pc = self.methods[method]['imp']; return True
        result,fp,float_value = 0,None,None
        if name == 'class':
            result = receiver if isclass else self.objects[receiver].cls
        elif name == 'description':
            result = self.text_object(self.class_names[receiver] if isclass else str(self.objects[receiver].state.get('value',self.objects[receiver].name)))
        elif name == 'respondsToSelector:' and isclass:
            query = self.selector_names[a[2]]
            result = int(query == 'effectWithStyle:' and self.glass_factory_available or
                         query == 'capsuleConfiguration' or bool(self.get_method(self.metaclasses[receiver],a[2])))
        elif isclass:
            cls = self.class_names[receiver]
            if name in ('alloc','new'):
                if cls == 'UIVisualEffect' and self.visual_effect_nil:
                    result = 0
                elif cls in ('NSMutableDictionary','NSDictionary'):
                    result = self.obj(cls,'allocated_dictionary',items={})
                elif cls in ('NSMutableArray','NSArray'):
                    result = self.obj(cls,'allocated_array',items=[])
                elif self.parents[receiver] == self.classes['UIViewController'] or cls in ('UIViewController','UITableViewController','UINavigationController'):
                    view = self.view('UIView',cls+'.view',(0,0,390,844),self.ROOT)
                    nav = self.obj('UINavigationItem',cls+'.navigationItem')
                    result = self.obj(cls,cls,view=view,navigationItem=nav,presentedViewController=0)
                else:
                    result = self.obj(cls,'allocated_'+cls)
                if name in ('alloc','new') and result:
                    self.retain_balance[result] = self.retain_balance.get(result,0)+1
                    self.event(name,result)
            elif cls == 'NSString' and name == 'stringWithUTF8String:':
                result = self.text_object(self.string(a[2]))
            elif cls == 'NSMutableDictionary' and name == 'dictionary':
                result = self.obj(cls,'dictionary',items={})
            elif cls == 'NSMutableArray' and name == 'array':
                result = self.obj(cls,'array',items=[])
            elif cls == 'NSArray' and name == 'arrayWithObject:':
                require(a[2] != 0,'NSArray cannot contain nil'); result = self.obj(cls,'array',items=[a[2]])
            elif cls == 'NSNumber' and name == 'numberWithDouble:':
                result = self.box(cpu.fp(0))
            elif cls == 'NSNumber' and name == 'numberWithUnsignedLongLong:':
                result = self.box(a[2])
            elif cls == 'NSNull' and name == 'null':
                result = self.NULL
            elif cls == 'NSDate' and name == 'date':
                result = self.obj(cls,'date',value=self.now)
            elif cls == 'NSThread' and name == 'isMainThread':
                result = int(self.thread == 'main')
            elif cls == 'NSProcessInfo' and name == 'processInfo':
                result = self.PROCESS
            elif cls == 'NSUserDefaults' and name == 'standardUserDefaults':
                result = self.DEFAULTS
            elif cls == 'NSHashTable' and name == 'weakObjectsHashTable':
                result = self.obj(cls,'weak_tracked_bars',items=[])
            elif cls == 'NSData' and name == 'dataWithBytes:length:':
                result = self.box(cpu.read(a[2],a[3]).to_bytes(a[3],'little'))
            elif cls == 'UIGlassEffect' and name == 'effectWithStyle:':
                require(self.glass_factory_available,'Missing glass factory must be guarded')
                result = 0 if self.glass_factory_nil else self.obj(cls,'fresh_glass',style=a[2],tintColor=0,interactive=False)
                self.event('glass_factory',result or receiver,style=a[2])
            elif cls == 'UICornerConfiguration' and name == 'capsuleConfiguration':
                result = self.obj(cls,'capsule')
            elif cls == 'UIColor' and name == 'colorWithCGColor:':
                result = self.color('CGColor:'+str(a[2]))
            elif cls == 'NSFileManager' and name == 'defaultManager':
                result = self.FILEMANAGER
            elif cls == 'NSUUID' and name == 'UUID':
                result = self.obj(cls,'uuid',value=str(uuid.uuid4()))
            elif cls == 'NSTimer' and name == 'scheduledTimerWithTimeInterval:target:selector:userInfo:repeats:':
                require(a[2] in self.objects and a[3] in self.selector_names and a[4] == 0 and a[5] == 1,
                        'Timer target/selector/userInfo/repeats ABI')
                result = self.obj(cls,'timer',interval=cpu.fp(0),target=a[2],selector=a[3])
                self.event('scheduled_timer',result,interval=cpu.fp(0))
            elif cls in ('NSJSONSerialization','NSPropertyListSerialization','NSData'):
                return self.serialization(cpu,receiver,name,a)
            elif cls == 'UIAlertController' and name == 'alertControllerWithTitle:message:preferredStyle:':
                require(a[4] == 1,'Alert style survives selector registration')
                result = self.obj(cls,'alert',title=a[2],message=a[3],actions=[])
            elif cls == 'UIAlertAction' and name == 'actionWithTitle:style:handler:':
                require(a[3] == 0 and a[4] == 0,'Alert action uses default style and nil block')
                result = self.obj(cls,'alert_action',title=a[2])
            else:
                return super().handle(cpu,pc)
        else:
            require(receiver in self.objects,'Modeled Foundation receiver '+hex(receiver))
            obj = self.objects[receiver]; st = obj.state; cls = self.class_names[obj.cls]
            if self.is_kind(receiver,self.UIView) and self.thread != 'main' and name not in ('retain','release','autorelease','class','isKindOfClass:'):
                raise AssertionError('UIKit view touched on worker: '+name)
            if name == 'init':
                result = receiver
            elif name in ('copy','mutableCopy'):
                target = ('NSMutableDictionary' if 'Dictionary' in cls else 'NSMutableArray') if name == 'mutableCopy' else cls
                result = self.obj(target,obj.name+'.copy',**{k:copy.copy(v) for k,v in st.items()})
                self.retain_balance[result] = 1
            elif name == 'setObject:forKey:':
                require(a[2] != 0 and a[3] != 0,'Dictionary value and key nonnil')
                st['items'][self.string_value(a[3])] = a[2]
            elif name == 'objectForKey:':
                key = self.string_value(a[2])
                result = self.box(st['values'][key]) if cls == 'NSUserDefaults' and key in st['values'] else st.get('items',{}).get(key,0)
            elif name == 'integerForKey:':
                result = st['values'].get(self.string_value(a[2]),0)
            elif name == 'addObject:':
                require(a[2] != 0,'Array/hash cannot append nil')
                if cls != 'NSHashTable' or a[2] not in st['items']:
                    st['items'].append(a[2])
            elif name == 'addObjectsFromArray:':
                st['items'].extend(self.objects[a[2]].state['items'])
            elif name == 'containsObject:':
                result = int(any(self.object_equal(p,a[2]) for p in st['items']))
            elif name == 'removeAllObjects':
                st['items'].clear()
            elif name == 'removeObjectAtIndex:':
                st['items'].pop(a[2])
            elif name == 'firstObject':
                result = st['items'][0] if st['items'] else 0
            elif name == 'allObjects':
                result = self.obj('NSArray','weak_objects_snapshot',items=list(st['items']))
            elif name == 'isEqualToData:':
                result = int(bool(a[2]) and st['value'] == self.objects[a[2]].state['value'])
            elif name in ('doubleValue','timeIntervalSince1970'):
                fp = (float(st['value']),)
            elif name == 'unsignedLongLongValue':
                result = int(st['value'])
            elif name == 'operatingSystemVersionString':
                result = self.text_object('iOS 26.0 (mock platform boundary)')
            elif name == 'traitCollection':
                result = self.obj('UITraitCollection','traits',contrast=0)
            elif name == 'accessibilityContrast':
                result = st['contrast']
            elif name == 'isOpaque':
                result = int(st.get('opaque',False))
            elif name == 'setOpaque:':
                st['opaque'] = bool(a[2]); self.event('opaque',receiver,value=bool(a[2]))
            elif name in ('opacity','shadowOpacity'):
                float_value = st.get(name,1.0 if name == 'opacity' else 0.0)
            elif name in ('shadowRadius','rasterizationScale'):
                fp = (st.get(name,0.0 if name == 'shadowRadius' else 1.0),)
            elif name == 'shouldRasterize':
                result = int(st.get(name,False))
            elif name in ('mask','masksToBounds','effect','tintColor','isInteractive'):
                key = {'isInteractive':'interactive'}.get(name,name)
                result = st.get(key,0)
            elif name == 'setEffect:':
                st['effect'] = a[2]; self.event('setEffect',receiver,value=a[2])
            elif name == 'setInteractive:':
                st['interactive'] = bool(a[2])
            elif name == 'setTintColor:':
                st['tintColor'] = a[2]
            elif name == 'setCornerConfiguration:':
                st['cornerConfiguration'] = a[2]; self.event('cornerConfiguration',receiver,bounds=list(st['bounds']))
            elif name == 'addSubview:':
                self.reparent(a[2],receiver); self.event('addSubview',receiver,child=a[2],frame=list(self.objects[a[2]].state['frame']))
            elif name == 'backgroundColor' and cls == 'CALayer':
                result = st.get('backgroundColor',0)
            elif name == 'lock':
                require(not st.get('locked',False),'NSLock cannot be entered twice without unlock')
                st['locked'] = True; self.event('lock',receiver,thread=self.thread)
            elif name == 'unlock':
                require(st.get('locked',False),'NSLock held before unlock')
                st['locked'] = False; self.event('unlock',receiver,thread=self.thread)
            elif name == 'setMaxConcurrentOperationCount:':
                st['concurrency'] = a[2]
            elif name == 'initWithTarget:selector:object:':
                require(a[2] in self.objects and a[3] in self.selector_names,'Operation target/selector ABI')
                st.update(target=a[2],selector=a[3],argument=a[4]); result = receiver
            elif name == 'addOperation:':
                require(st.get('concurrency') == 1,'Single operation worker')
                self.queued_operations.append(a[2]); self.event('queue_operation',receiver,operation=a[2])
            elif name == 'performSelectorOnMainThread:withObject:waitUntilDone:':
                require(a[2] in self.selector_names and a[4] == 0,'Explicit asynchronous main-thread selector ABI')
                self.main_jobs.append((receiver,a[2],a[3])); self.event('schedule_main',receiver,selector=self.selector_names[a[2]])
            elif name == 'URLsForDirectory:inDomains:':
                require(self.thread == 'worker','Persistent storage path selected on worker')
                require(a[2] == 14 and a[3] == 1,'Application Support in user domain')
                folder = self.disk_root/('ApplicationSupport' if a[2] == 14 else 'Caches')
                result = self.obj('NSArray','directory_urls',items=[self.url(folder)])
                self.event('storage_directory',receiver,directory=a[2])
            elif name == 'temporaryDirectory':
                result = self.url(self.disk_root/'tmp')
            elif name == 'URLByAppendingPathComponent:':
                result = self.url(Path(st['value'])/self.string_value(a[2]))
            elif name == 'URLByDeletingLastPathComponent':
                result = self.url(Path(st['value']).parent)
            elif name == 'path':
                result = self.text_object(st['value'])
            elif name == 'fileExistsAtPath:':
                require(self.thread == 'worker','File existence on worker')
                result = int(Path(self.string_value(a[2])).exists())
            elif name == 'createDirectoryAtURL:withIntermediateDirectories:attributes:error:':
                require(self.thread == 'worker','Directory creation on worker')
                require(a[3] == 1 and a[4] == 0,'Directory creation x3/x4 ABI')
                if self.fail_directory:
                    self.error(cpu,a[5],'injected directory creation failure')
                else:
                    Path(self.string_value(a[2])).mkdir(parents=True,exist_ok=True); result = 1
            elif name == 'writeToURL:options:error:':
                require(self.thread == 'worker','File serialization/write on worker')
                path = Path(self.string_value(a[2])); require(a[3] & 1,'Atomic data writing requested')
                if self.fail_write or (self.fail_write_prefix and str(path).startswith(str(self.fail_write_prefix))):
                    self.error(cpu,a[4],'injected write failure')
                else:
                    temp = path.with_suffix(path.suffix+'.tmp')
                    temp.write_bytes(st['value']); temp.replace(path); result = 1
                    self.event('write_file',receiver,path=str(path),bytes=len(st['value']))
            elif name == 'localizedDescription':
                result = self.text_object(st['value'])
            elif name == 'UUIDString':
                result = self.text_object(st['value'])
            elif name == 'stringByAppendingString:':
                result = self.text_object(st['value']+self.string_value(a[2]))
            elif name == 'initWithTitle:style:target:action:':
                require(a[3] == 0 and a[4] in self.objects and a[5] in self.selector_names,'Export UIBarButtonItem high-argument ABI')
                st.update(title=a[2],target=a[4],action=a[5],enabled=True); result = receiver
            elif name in ('navigationItem','view','presentedViewController'):
                result = st.get(name,0)
            elif name in ('setLeftBarButtonItem:','setRightBarButtonItem:'):
                st['left' if name.startswith('setLeft') else 'right'] = a[2]
            elif name == 'setEnabled:':
                st['enabled'] = bool(a[2])
            elif name == 'initWithActivityItems:applicationActivities:':
                require(a[3] == 0,'Activity controller no custom activities')
                st['activityItems'] = a[2]; result = receiver
            elif name == 'popoverPresentationController':
                result = st.setdefault('popover',self.obj('UIPopoverPresentationController','popover'))
            elif name == 'setBarButtonItem:':
                st['anchor'] = a[2]
            elif name == 'presentViewController:animated:completion:':
                require(self.thread == 'main' and a[3] == 1 and a[4] == 0,'UIKit presentation on main with preserved x4 nil completion')
                st['presentedViewController'] = a[2]; self.event('present',receiver,controller=a[2])
            elif name == 'addAction:':
                st['actions'].append(a[2])
            elif name == 'initWithStyle:':
                if 'view' not in st:
                    st.update(view=self.view('UIView',obj.name+'.view',(0,0,390,844),self.ROOT),
                              navigationItem=self.obj('UINavigationItem','navigation_item'),presentedViewController=0)
                result = receiver
            elif name == 'setTitle:':
                st['title'] = a[2]
            elif name == 'initWithBarButtonSystemItem:target:action:':
                require(a[3] in self.objects and a[4] in self.selector_names,'Original close UIBarButtonItem ABI')
                st.update(systemItem=a[2],target=a[3],action=a[4]); result = receiver
                self.event('system_bar_item',receiver,system_item=a[2],target=a[3],action=self.selector_names[a[4]])
            elif name == 'dismissViewControllerAnimated:completion:':
                require(self.thread == 'main' and a[2] == 1 and a[3] == 0,
                        'Close dismisses on main with animated YES and nil completion')
                st['dismissed'] = True
                self.event('dismiss',receiver,animated=bool(a[2]),completion=a[3])
            elif name == 'initWithRootViewController:':
                st['rootViewController'] = a[2]; result = receiver
            else:
                return super().handle(cpu,pc)
        return self.finish(cpu,result,fp,float_value)

    def serialization(self,cpu,receiver,name,a):
        require(self.thread == 'worker','JSON/plist and file reading stay on worker')
        result = 0
        try:
            if name == 'isValidJSONObject:':
                value = self.native(a[2]); json.dumps(value,allow_nan=False)
                result = int(isinstance(value,(list,dict)))
            elif name == 'dataWithJSONObject:options:error:':
                if self.fail_json: raise ValueError('injected JSON failure')
                result = self.box(json.dumps(self.native(a[2]),ensure_ascii=False,allow_nan=False).encode())
            elif name == 'JSONObjectWithData:options:error:':
                result = self.box(json.loads(self.native(a[2])))
            elif name == 'dataWithPropertyList:format:options:error:':
                require(a[3] == 200 and a[4] == 0,'Binary plist format and options ABI')
                if self.fail_plist: raise ValueError('injected plist failure')
                result = self.box(plistlib.dumps(self.native(a[2]),fmt=plistlib.FMT_BINARY))
            elif name == 'propertyListWithData:options:format:error:':
                require(a[3] == 0 and a[4] == 0,'Plist read options and nil format pointer ABI')
                result = self.box(plistlib.loads(self.native(a[2])))
            elif name == 'dataWithContentsOfURL:options:error:':
                if self.fail_read: raise OSError('injected read failure')
                result = self.box(Path(self.string_value(a[2])).read_bytes())
            else:
                raise AssertionError('Unmodeled serialization selector '+name)
        except (ValueError,TypeError,OSError,plistlib.InvalidFileException) as exc:
            error_arg = a[5] if 'PropertyList:format:' in name or name.startswith('propertyListWithData:') else a[4]
            if name == 'isValidJSONObject:':
                error_arg = 0
            self.error(cpu,error_arg,str(exc))
        return self.finish(cpu,result)
