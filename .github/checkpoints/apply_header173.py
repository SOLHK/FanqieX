import hashlib
from pathlib import Path
root=Path(__file__).resolve().parents[2]
source=root/'native/AlignedGlass.m'
assert hashlib.sha256(source.read_bytes()).hexdigest()=='adc8d89a559f69fe7431f85da272a78456fc4b32a9d08e5715b5fd40baad41e5', 'Unexpected source base; refusing to patch'
p=root/'native/AlignedGlass.m'
s=p.read_text()
needle='// The host\'s setSsCornerRadius: enables masksToBounds.'
pos=s.index(needle)
block=r'''// The search owner is also the clipping viewport for cycling search words.
// Disabling its clipping lets the next word draw over the navigation row. Keep
// that viewport clipped, but give its layer the same capsule as the material.
// Only the two header owners use this path; reader/shelf icon optics are unchanged.
static void HeaderKey(void) {}
static void HeaderClipsKey(void) {}
static void HeaderOpaqueKey(void) {}
static void HeaderRadiusKey(void) {}
static void HeaderAppliedRadiusKey(void) {}
static void HeaderLogKey(void) {}
static void HeaderLogTimeKey(void) {}
static Obj Number(double value);
static void HeaderDiagnostics(Obj view);
static double Radius(Obj view) {
    return ((double(*)(Obj,Sel))Message)(O0(view,"layer"),sel_registerName("cornerRadius"));
}
static void SetRadius(Obj view,double value) {
    ((void(*)(Obj,Sel,double))Message)(O0(view,"layer"),sel_registerName("setCornerRadius:"),value);
}
static double Double(Obj value) {
    return ((double(*)(Obj,Sel))Message)(value,sel_registerName("doubleValue"));
}
static void PrepareHeaderOwner(Obj view,Rect bounds) {
    B clips=Flag(view,"clipsToBounds"), opaque=Flag(view,"isOpaque");
    double current=Radius(view),wanted=(bounds.width<bounds.height ? bounds.width : bounds.height)*0.5;
    Obj applied=objc_getAssociatedObject(view,HeaderAppliedRadiusKey);
    if (!objc_getAssociatedObject(view,HeaderClipsKey) || !clips)
        objc_setAssociatedObject(view,HeaderClipsKey,BoolBox(clips),1);
    if (!objc_getAssociatedObject(view,HeaderOpaqueKey) || opaque)
        objc_setAssociatedObject(view,HeaderOpaqueKey,BoolBox(opaque),1);
    if (!applied || current!=Double(applied))
        objc_setAssociatedObject(view,HeaderRadiusKey,Number(current),1);
    if (current!=wanted) SetRadius(view,wanted);
    if (!applied || Double(applied)!=wanted)
        objc_setAssociatedObject(view,HeaderAppliedRadiusKey,Number(wanted),1);
    if (!clips) VB(view,"setClipsToBounds:",1);
    if (opaque) VB(view,"setOpaque:",0);
}
static void RestoreHeaderOwner(Obj view) {
    Obj clips=objc_getAssociatedObject(view,HeaderClipsKey),opaque=objc_getAssociatedObject(view,HeaderOpaqueKey);
    Obj radius=objc_getAssociatedObject(view,HeaderRadiusKey),applied=objc_getAssociatedObject(view,HeaderAppliedRadiusKey);
    // Restore only properties still owned by this decoration. A later host write wins.
    if (clips && Flag(view,"clipsToBounds")) VB(view,"setClipsToBounds:",Flag(clips,"boolValue"));
    if (opaque && !Flag(view,"isOpaque")) VB(view,"setOpaque:",Flag(opaque,"boolValue"));
    if (radius && applied && Radius(view)==Double(applied)) SetRadius(view,Double(radius));
    objc_setAssociatedObject(view,HeaderClipsKey,0,1);
    objc_setAssociatedObject(view,HeaderOpaqueKey,0,1);
    objc_setAssociatedObject(view,HeaderRadiusKey,0,1);
    objc_setAssociatedObject(view,HeaderAppliedRadiusKey,0,1);
    objc_setAssociatedObject(view,HeaderLogKey,0,1);
    objc_setAssociatedObject(view,HeaderLogTimeKey,0,1);
}
'''
s=s[:pos]+block+s[pos:]
s=s.replace('if (!surface) { RestoreOwner(view); return; }', 'if (!surface) { RestoreHeaderOwner(view); RestoreOwner(view); return; }',1)
s=s.replace('    RestoreOwner(view);\n}\nstatic void ClearBackground', '    RestoreHeaderOwner(view); RestoreOwner(view);\n}\nstatic void ClearBackground',1)
s=s.replace('    PrepareOwner(view);\n    Rect placed=', '    if (objc_getAssociatedObject(view,HeaderKey)) PrepareHeaderOwner(view,bounds);\n    else PrepareOwner(view);\n    Rect placed=',1)
needle='static Imp Original(const char *cls,const char *alias) {'
idx=s.index(needle)
s=s[:idx]+r'''void FQHHeader(Obj view) {
    if (!Kind(view,"UIView")) return;
    objc_setAssociatedObject(view,HeaderKey,Text(Kind(view,"SSBookStoreCategorySignView") ? "categoryButton" : "search"),1);
    FQHApply(view);
    if (FQHSurface(view)) HeaderDiagnostics(view);
}
'''+s[idx:]
s=s.replace('    FQHApply(Get(self,"searchBgView"));','    FQHHeader(Get(self,"searchBgView"));')
needle='static void Hook(const char *name,const char *selector,const char *alias,const char *type,Imp imp) {'
idx=s.index(needle)
s=s[:idx]+r'''static void CategoryLayout(Obj self,Sel cmd) {
    ((void(*)(Obj,Sel))Original("SSBookStoreCategorySignView","fqx173_originalLayout"))(self,cmd);
    FQHHeader(self);
}
static void CategoryColor(Obj self,Sel cmd,double ratio,int from,int to,int fromTemplate,int toTemplate) {
    ((void(*)(Obj,Sel,double,int,int,int,int))Original("SSBookStoreCategorySignView","fqx173_originalColor:from:to:fromTemplate:toTemplate:"))(self,cmd,ratio,from,to,fromTemplate,toTemplate);
    FQHHeader(self);
}
static void SearchColor(Obj self,Sel cmd,double ratio,int from,int to,int fromTemplate,int toTemplate) {
    ((void(*)(Obj,Sel,double,int,int,int,int))Original("SSBookStoreSearchBarComponent","fqx173_originalSearchColor:from:to:fromTemplate:toTemplate:"))(self,cmd,ratio,from,to,fromTemplate,toTemplate);
    FQHHeader(Get(Get(self,"bookStoreVCContext"),"searchBgView"));
}
'''+s[idx:]
needle='static void RecordLayout(Obj view,Obj glass,Rect image,const char *role) {'
idx=s.index(needle)
s=s[:idx]+r'''static void HeaderDiagnostics(Obj view) {
    Rect bounds=Bounds(view);
    Obj previous=objc_getAssociatedObject(view,HeaderLogKey);
    if (previous && SameRect(bounds,UnboxRect(previous))) return;
    double now=((double(*)(Obj,Sel))Message)(O0(Lookup("NSProcessInfo"),"processInfo"),sel_registerName("systemUptime"));
    Obj last=objc_getAssociatedObject(view,HeaderLogTimeKey);
    if (last && now-Double(last)<1.0) return;
    objc_setAssociatedObject(view,HeaderLogKey,RectBox(bounds),1);
    objc_setAssociatedObject(view,HeaderLogTimeKey,Number(now),1);
    Obj record=O0(Lookup("NSMutableDictionary"),"dictionary");
    Put(record,"role",objc_getAssociatedObject(view,HeaderKey));
    Put(record,"hostFrame",RectArray(Frame(view))); Put(record,"hostBounds",RectArray(bounds));
    Put(record,"glassRect",RectArray(Frame(FQHSurface(view))));
    Put(record,"clipsToBounds",BoolBox(Flag(view,"clipsToBounds")));
    Put(record,"cornerRadius",Number(Radius(view)));
    Obj children=Get(view,"subviews"),frames=O0(Lookup("NSMutableArray"),"array");
    U count=((U(*)(Obj,Sel))Message)(children,sel_registerName("count"));
    Put(record,"childCount",Number((double)count));
    Put(record,"childrenTruncated",BoolBox(count>12));
    if (count>12) count=12;
    for (U i=0;i<count;++i) V1(frames,"addObject:",RectArray(Frame(At(children,i))));
    Put(record,"childFrames",frames); // Geometry only: never log book names or query text.
    FQDRecord("headerLayout173",record);
}
'''+s[idx:]
s=s.replace('    // Category navigation remains entirely host-owned to prevent label overlap.\n    // Do not mutate search glass during the host\'s interactive top-tab transition.',r'''    // This is the right-hand category ENTRY, not the horizontal category tabs.
    Hook("SSBookStoreCategorySignView","layoutSubviews","fqx173_originalLayout","v16@0:8",(Imp)CategoryLayout);
    Hook("SSBookStoreCategorySignView","resetColorWithRatio:fromTab:toTab:fromTabTemplate:toTabTemplate:","fqx173_originalColor:from:to:fromTemplate:toTemplate:","v40@0:8d16i24i28i32i36",(Imp)CategoryColor);
    Hook("SSBookStoreSearchBarComponent","resetTopTabSearchViewWithRatio:fromTab:toTab:fromTabTemplate:toTabTemplate:","fqx173_originalSearchColor:from:to:fromTemplate:toTemplate:","v40@0:8d16i24i28i32i36",(Imp)SearchColor);''')
p.write_text(s)
for folder in ('scripts','audit162','repair162'):
 for path in (root/folder).glob('*.py'):
  s=path.read_text();old=s
  s=s.replace("'1.7.2')", "'1.7.2', '1.7.3')").replace('"1.7.2")','"1.7.2", "1.7.3")')
  s=s.replace('0x10702)', '0x10702,0x10703)').replace('0x10702 + 0x800)', '0x10702 + 0x800, 0x10703 + 0x800)')
  if path.name=='build_plugin.py':s=s.replace("'1.7.2': 0x10702}","'1.7.2': 0x10702, '1.7.3': 0x10703}")
  if path.name=='native_selection_runtime.py':s=s.replace("0x10702: (b'FQ162SEG', 0x10602)}", "0x10702: (b'FQ162SEG', 0x10602), 0x10703: (b'FQ162SEG', 0x10602)}")
  if path.name=='interaction_runtime.py':s=s.replace("0x10702:b'FQ162EXT'}", "0x10702:b'FQ162EXT', 0x10703:b'FQ162EXT'}")
  if path.name=='test_independent_faults.py':s=s.replace('"1.7.2": 27}', '"1.7.2": 27, "1.7.3": 27}')
  if path.name=='independent159.py':s=s.replace('EXTENSION_PATCH_SITES["1.7.2"] = EXTENSION_PATCH_SITES["1.6.6"]', 'EXTENSION_PATCH_SITES["1.7.2"] = EXTENSION_PATCH_SITES["1.6.6"]\nEXTENSION_PATCH_SITES["1.7.3"] = EXTENSION_PATCH_SITES["1.6.6"]')
  if old!=s:path.write_text(s)
p=root/'repair162/diagnostic_ui.s';s=p.read_text();s=s.replace('    .elseif FQ_VERSION == 0x10702\n', '    .elseif FQ_VERSION == 0x10703\n    .asciz "1.7.3"\n    .elseif FQ_VERSION == 0x10702\n');p.write_text(s)
r=root;p=r/'audit162/test_home_glass165.py';s=p.read_text()
s=s.replace("'LFQH_SurfaceKey','LHomeHostGate']","'LFQH_SurfaceKey','LHomeHostGate','Lrecord_named']")
s=s.replace('        self.attachments=[]','        self.attachments=[]; self.labels={}; self.header_records=[]',1)
s=s.replace('        self.current_cpu=cpu\n        r,sel=cpu.x[:2]; name=self.selector_names.get(sel)', "        self.current_cpu=cpu\n        if self.labels.get('Lrecord_named') is not None and pc==self.slide+self.labels['Lrecord_named']:\n            self.header_records.append((self.string(cpu.x[0]),self.native(cpu.x[1])))\n            return self.finish(cpu)\n        r,sel=cpu.x[:2]; name=self.selector_names.get(sel)",1)
s=s.replace('    r=Runtime(data,slide,available)\n', '    r=Runtime(data,slide,available); r.labels=labels\n',1)
s=s.replace('    passed=[]\n', "    passed=[]\n    header=release_version(data)=='1.7.3'\n",1)
old="        require(len([e for e in r.events if e['event']=='method_setImplementation'])==before==(7 if release_version(data)=='1.7.1' else 6 if release_version(data) in ('1.6.6','1.7.2', '1.7.3') else 5),'Expected fixture hooks, idempotent installation')"
new="""        expected={(HOME,'relayout'),(HOME,'viewDidAppear:')}
        if header: expected.update({(CATEGORY,'layoutSubviews'),(CATEGORY,COLOR),(SEARCH,SEARCH_COLOR),('SSReaderFloatingCommonButton','layoutSubviews'),('FQReaderSaasNavigationView','layoutSubviews')})
        elif release_version(data)=='1.7.2': expected.update({('SSReaderFloatingCommonButton','layoutSubviews'),('FQReaderSaasNavigationView','layoutSubviews')})
        else: expected.update({(CATEGORY,'layoutSubviews'),(CATEGORY,COLOR),(SEARCH,SEARCH_COLOR)})
        actual={(r.class_names[e['self']],e['selector']) for e in r.events if e['event']=='method_setImplementation'}
        if header or release_version(data)=='1.7.2':
            require(actual==expected and before==len(actual),'Exact inspected hook identities installed once')
        require(len([e for e in r.events if e['event']=='method_setImplementation'])==before,'Repeated installation is idempotent')"""
assert old in s;s=s.replace(old,new)
s=s.replace("            surfaces=[r.associations[(v,key)]]\n            require((cat,key) not in r.associations,'Host category strip receives no plugin-owned glass overlay')\n            for o,s in zip((v,),surfaces):", "            owners=(v,cat) if header else (v,)\n            surfaces=[r.associations[(o,key)] for o in owners]\n            if not header: require((cat,key) not in r.associations,'Removed category overlay stays absent in 1.7.2')\n            for o,s in zip(owners,surfaces):")
s=s.replace("                require((cat,key) not in r.associations,'Repeated category layout remains host-owned')\n            require(surfaces==[r.associations[(v,key)]],'Repeated layout reuses the search surface only')", "                if not header: require((cat,key) not in r.associations,'Repeated category layout remains host-owned')\n            require(surfaces==[r.associations[(o,key)] for o in owners],'Repeated layout reuses each owned surface')")
s=s.replace("            for obj,sel in ((component,SEARCH_COLOR),):", "            theme_targets=((component,SEARCH_COLOR),(cat,COLOR)) if header else ((component,SEARCH_COLOR),)\n            for obj,sel in theme_targets:")
s=s.replace("                    require(r.objects[o].state.get(k)==snapshots[o].get(k),'Host layout, content, clipping and interaction remain unchanged')", "                    if header and o in owners and k=='clipsToBounds':\n                        require(r.objects[o].state.get(k) is True,'Header content stays clipped')\n                    else: require(r.objects[o].state.get(k)==snapshots[o].get(k),'Host layout, content and interaction remain unchanged')")
s=s.replace("            require((cat,key) not in r.associations,'Disabling glass does not alter the host category strip')", "            if header: call(c,'LFQH_FQHApply',cat)\n            require((cat,key) not in r.associations,'Disabling glass removes the owned category surface')")
s=s.replace("passed.append('search glass sizing/reuse/theme/restore; category strip remains host-owned at slide '+hex(slide))", "passed.append('header sizing/reuse/theme/restore; original text geometry and actions at slide '+hex(slide))")
p.write_text(s)
p=r/'audit162/test_alignment167.py';s=p.read_text().replace('from arm64 import CPU,require','from arm64 import CPU,require,release_version')
s=s.replace("        require(len([e for e in r.events if e['event']=='method_setImplementation'])==7,'Seven stable hooks; top-tab transition remains host-owned')", "        expected_hooks=10 if release_version(data)=='1.7.3' else 7\n        require(len([e for e in r.events if e['event']=='method_setImplementation'])==expected_hooks,'Exact stable hooks including scoped header owners')")
s=s.replace("        require('SSBookStoreCategorySignView' not in source and 'resetTopTabSearchViewWithRatio:' not in source and 'static void SearchColor(' not in source,'No category or interactive top-tab transition hook')", "        if release_version(data)=='1.7.3':\n            require('FQHHeader(Get(self,\"searchBgView\"))' in source and 'PrepareHeaderOwner' in source,'Header uses its clipped capsule path, not generic icon overflow')\n        else:\n            require('SSBookStoreCategorySignView' not in source and 'resetTopTabSearchViewWithRatio:' not in source and 'static void SearchColor(' not in source,'No category or interactive top-tab transition hook')")
p.write_text(s)
p=root/'scripts/verify162.py';s=p.read_text();needle='        # Fail if any step replaced the binary underneath the recorded reports.'
s=s.replace(needle,'        if args.version == "1.7.3":\n            run("header173", ["audit162/test_header173.py", candidate,\n                "--report", output / "header173.json"])\n'+needle);p.write_text(s)
assert hashlib.sha256(source.read_bytes()).hexdigest()=='3af0afc4a04b1e701bc2f35a920be3c5742c8da02d84be0d82beaaacb532df73', 'Unexpected generated source'
