#pragma clang fp contract(off)
// Native glass for the inspected bookstore, bookshelf and reader controls. Runtime-only
// bridge: no UIKit class imports, global UIView hooks, or host gesture replacement.
typedef void *Obj;
typedef void *Sel;
typedef void *Method;
typedef void (*Imp)(void);
typedef unsigned long U;
typedef long I;
typedef signed char B;
typedef struct { double x, y, width, height; } Rect;
typedef struct { double width, height; } Size;
extern void Message(void) __asm__("_objc_msgSend");
extern Obj Lookup(const char *) __asm__("_objc_getClass");
extern Sel sel_registerName(const char *);
extern Method class_getInstanceMethod(Obj, Sel);
extern Imp method_getImplementation(Method);
extern Imp method_setImplementation(Method, Imp);
extern const char *method_getTypeEncoding(Method);
extern B class_addMethod(Obj, Sel, Imp, const char *);
extern Obj objc_getAssociatedObject(Obj, const void *);
extern void objc_setAssociatedObject(Obj, const void *, Obj, U);
extern Method FQDResolveOwned(Obj, Sel, int, const char *);
extern Obj objc_autoreleasePoolPush(void);
extern void objc_autoreleasePoolPop(Obj);
#define O0(o,s) ((Obj(*)(Obj,Sel))Message)(o,sel_registerName(s))
#define O1(o,s,a) ((Obj(*)(Obj,Sel,Obj))Message)(o,sel_registerName(s),a)
#define V0(o,s) ((void(*)(Obj,Sel))Message)(o,sel_registerName(s))
#define V1(o,s,a) ((void(*)(Obj,Sel,Obj))Message)(o,sel_registerName(s),a)
#define VB(o,s,a) ((void(*)(Obj,Sel,B))Message)(o,sel_registerName(s),a)
#define Q1(o,s,a) ((void(*)(Obj,Sel,I))Message)(o,sel_registerName(s),a)
static void SurfaceKey(void) {}
static void BackgroundKey(void) {}
static void BusyKey(void) {}
static void ClipsKey(void) {}
static void OpaqueKey(void) {}
static void OwnerBusyKey(void) {}
static void ReaderGlassKey(void) {}
static void IconGlassKey(void) {}
static void IconRectKey(void) {}
static void HitInsetsKey(void) {}
static void AppliedHitInsetsKey(void) {}
static void LayoutKey(void) {}
static void LayoutTimeKey(void) {}
static B Responds(Obj o,const char *s) {
    return o && ((B(*)(Obj,Sel,Sel))Message)(o,sel_registerName("respondsToSelector:"),sel_registerName(s));
}
static Obj Get(Obj o,const char *s) { return Responds(o,s) ? O0(o,s) : (Obj)0; }
static Obj Text(const char *s) {
    return ((Obj(*)(Obj,Sel,const char *))Message)(Lookup("NSString"),sel_registerName("stringWithUTF8String:"),s);
}
static B Equal(Obj o, const char *s) {
    return o && ((B(*)(Obj,Sel,Obj))Message)(o,sel_registerName("isEqual:"),Text(s));
}
static B Kind(Obj o,const char *name) {
    return o && ((B(*)(Obj,Sel,Obj))Message)(o,sel_registerName("isKindOfClass:"),Lookup(name));
}
static B Signature(const char *cls,const char *sel,const char *expected) {
    Method m=class_getInstanceMethod(Lookup(cls),sel_registerName(sel));
    if (!m) return 0;
    const char *type=method_getTypeEncoding(m);
    if (!type) return 0;
    while (*expected && *type==*expected) { ++type; ++expected; }
    return *type==0 && *expected==0;
}
// Alternative executables of the inspected app build can have another UUID.
// Require its identity AND its critical ABI instead of guessing by device name.
B FQHCompatibleHost(void) {
    Obj pool=objc_autoreleasePoolPush();
    Obj bundle=O0(Lookup("NSBundle"),"mainBundle");
    B compatible=Equal(O0(bundle,"bundleIdentifier"),"com.dragon.read") &&
        Equal(O1(bundle,"objectForInfoDictionaryKey:",Text("CFBundleVersion")),"7.4.3.33") &&
        Signature("SSBookStoreNewViewController","relayout","v16@0:8") &&
        Signature("SSBookStoreNewViewController","searchBgView","@16@0:8") &&
        Signature("SSBookStoreCategorySignView","layoutSubviews","v16@0:8") &&
        Signature("SSBookStoreCategorySignView","resetColorWithRatio:fromTab:toTab:fromTabTemplate:toTabTemplate:","v40@0:8d16i24i28i32i36");
    objc_autoreleasePoolPop(pool);
    return compatible;
}
B FQHGlassAvailable(void) {
    return Responds(Lookup("UIGlassEffect"),"effectWithStyle:") &&
           Responds(Lookup("UICornerConfiguration"),"capsuleConfiguration") &&
           class_getInstanceMethod(Lookup("UIVisualEffectView"),sel_registerName("setCornerConfiguration:")) &&
           class_getInstanceMethod(Lookup("UIGlassEffect"),sel_registerName("setInteractive:"));
}
static B Enabled(void) {
    Obj defaults=O0(Lookup("NSUserDefaults"),"standardUserDefaults");
    return !((I(*)(Obj,Sel,Obj))Message)(defaults,sel_registerName("integerForKey:"),Text("FanqieAdBlock.GlassDisabled.1"));
}
static B Flag(Obj view,const char *selector) {
    return ((B(*)(Obj,Sel))Message)(view,sel_registerName(selector));
}
static Obj BoolBox(B value) {
    return ((Obj(*)(Obj,Sel,B))Message)(Lookup("NSNumber"),sel_registerName("numberWithBool:"),value);
}
// The host's setSsCornerRadius: enables masksToBounds. Native optical edges
// must not inherit that old rectangular/rounded clipping surface. This changes
// only the exact decorated owner, never an ancestor, child or layer mask.
static void PrepareOwner(Obj view) {
    B clips=Flag(view,"clipsToBounds"), opaque=Flag(view,"isOpaque");
    if (!objc_getAssociatedObject(view,ClipsKey) || clips)
        objc_setAssociatedObject(view,ClipsKey,BoolBox(clips),1);
    if (!objc_getAssociatedObject(view,OpaqueKey) || opaque)
        objc_setAssociatedObject(view,OpaqueKey,BoolBox(opaque),1);
    if (clips) VB(view,"setClipsToBounds:",0);
    if (opaque) VB(view,"setOpaque:",0);
}
static void RestoreOwner(Obj view) {
    Obj clips=objc_getAssociatedObject(view,ClipsKey), opaque=objc_getAssociatedObject(view,OpaqueKey);
    if (clips && !Flag(view,"clipsToBounds")) VB(view,"setClipsToBounds:",Flag(clips,"boolValue"));
    if (opaque && !Flag(view,"isOpaque")) VB(view,"setOpaque:",Flag(opaque,"boolValue"));
    objc_setAssociatedObject(view,ClipsKey,0,1);
    objc_setAssociatedObject(view,OpaqueKey,0,1);
}
B FQHIsDuration(Obj view) {
    if (Kind(view,"SSBookShelfProfileDurationTipButton")) return 1;
    Obj parent=Get(view,"superview");
    for (int depth=0;parent && depth<4;++depth,parent=Get(parent,"superview"))
        if (Kind(parent,"SS525BookShelfSubHeaderView") && Get(parent,"coinButton")==view) return 1;
    return 0;
}
Obj FQHSurface(Obj view) { return objc_getAssociatedObject(view,SurfaceKey); }
static void Restore(Obj view,Obj surface) {
    if (!surface) { RestoreOwner(view); return; }
    Obj clear=O0(Lookup("UIColor"),"clearColor");
    Obj current=O0(view,"backgroundColor");
    if (current==clear || ((B(*)(Obj,Sel,Obj))Message)(current,sel_registerName("isEqual:"),clear))
        V1(view,"setBackgroundColor:",objc_getAssociatedObject(view,BackgroundKey));
    V0(surface,"removeFromSuperview");
    objc_setAssociatedObject(view,SurfaceKey,0,1);
    objc_setAssociatedObject(view,BackgroundKey,0,1);
    RestoreOwner(view);
}
void FQHApply(Obj view) {
    if (!Kind(view,"UIView") || objc_getAssociatedObject(view,BusyKey)) return;
    objc_setAssociatedObject(view,BusyKey,view,0);
    Obj surface=objc_getAssociatedObject(view,SurfaceKey);
    Rect bounds=((Rect(*)(Obj,Sel))Message)(view,sel_registerName("bounds"));
    if (!Enabled() || !FQHGlassAvailable() ||
        !__builtin_isfinite(bounds.x) || !__builtin_isfinite(bounds.y) ||
        !__builtin_isfinite(bounds.width) || !__builtin_isfinite(bounds.height) ||
        !(bounds.width>0 && bounds.height>0)) {
        Restore(view,surface);
        objc_setAssociatedObject(view,BusyKey,0,0);
        return;
    }
    if (!surface) {
        Obj effect=((Obj(*)(Obj,Sel,I))Message)(Lookup("UIGlassEffect"),sel_registerName("effectWithStyle:"),0);
        if (!effect) { objc_setAssociatedObject(view,BusyKey,0,0); return; }
        VB(effect,"setInteractive:",1);
        surface=O1(O0(Lookup("UIVisualEffectView"),"alloc"),"initWithEffect:",effect);
        if (!surface) { objc_setAssociatedObject(view,BusyKey,0,0); return; }
        V1(surface,"setCornerConfiguration:",O0(Lookup("UICornerConfiguration"),"capsuleConfiguration"));
        VB(surface,"setUserInteractionEnabled:",0);
        VB(surface,"setAccessibilityElementsHidden:",1);
        VB(surface,"setIsAccessibilityElement:",0);
        VB(surface,"setOpaque:",0);
        Q1(surface,"setAutoresizingMask:",18); // flexible width + height
        objc_setAssociatedObject(view,SurfaceKey,surface,1);
        V0(surface,"release");
        objc_setAssociatedObject(view,BackgroundKey,O0(view,"backgroundColor"),1);
    }
    Obj clear=O0(Lookup("UIColor"),"clearColor");
    Obj current=O0(view,"backgroundColor");
    // A host theme update owns the latest restoration color.
    if (current!=clear && !((B(*)(Obj,Sel,Obj))Message)(current,sel_registerName("isEqual:"),clear))
        objc_setAssociatedObject(view,BackgroundKey,current,1);
    Obj transaction=Lookup("CATransaction");
    V0(transaction,"begin"); VB(transaction,"setDisableActions:",1);
    PrepareOwner(view);
    ((void(*)(Obj,Sel,Rect))Message)(surface,sel_registerName("setFrame:"),bounds);
    V1(surface,"setBackgroundColor:",clear);
    V1(O0(surface,"contentView"),"setBackgroundColor:",clear);
    V1(view,"setBackgroundColor:",clear);
    if (O0(surface,"superview")!=view)
        ((void(*)(Obj,Sel,Obj,I))Message)(view,sel_registerName("insertSubview:atIndex:"),surface,0);
    V0(transaction,"commit");
    objc_setAssociatedObject(view,BusyKey,0,0);
}
static Imp Original(const char *cls,const char *alias) {
    return method_getImplementation(class_getInstanceMethod(Lookup(cls),sel_registerName(alias)));
}
static void HomeLayout(Obj self,Sel cmd) {
    ((void(*)(Obj,Sel))Original("SSBookStoreNewViewController","fqx165_originalRelayout"))(self,cmd);
    FQHApply(Get(self,"searchBgView"));
}
static void HomeAppear(Obj self,Sel cmd,B animated) {
    ((void(*)(Obj,Sel,B))Original("SSBookStoreNewViewController","fqx165_originalAppear:"))(self,cmd,animated);
    FQHApply(Get(self,"searchBgView"));
}
static void CategoryLayout(Obj self,Sel cmd) {
    ((void(*)(Obj,Sel))Original("SSBookStoreCategorySignView","fqx165_originalLayout"))(self,cmd);
    FQHApply(self);
}
static void CategoryColor(Obj self,Sel cmd,double ratio,int from,int to,int fromTemplate,int toTemplate) {
    ((void(*)(Obj,Sel,double,int,int,int,int))Original("SSBookStoreCategorySignView","fqx165_originalColor:from:to:fromTemplate:toTemplate:"))(self,cmd,ratio,from,to,fromTemplate,toTemplate);
    FQHApply(self);
}
static void SearchColor(Obj self,Sel cmd,double ratio,int from,int to,int fromTemplate,int toTemplate) {
    ((void(*)(Obj,Sel,double,int,int,int,int))Original("SSBookStoreSearchBarComponent","fqx165_originalSearchColor:from:to:fromTemplate:toTemplate:"))(self,cmd,ratio,from,to,fromTemplate,toTemplate);
    FQHApply(Get(Get(self,"bookStoreVCContext"),"searchBgView"));
}
static void Hook(const char *name,const char *selector,const char *alias,const char *type,Imp imp) {
    Obj cls=Lookup(name);
    if (!cls || class_getInstanceMethod(cls,sel_registerName(alias))) return;
    Method method=FQDResolveOwned(cls,sel_registerName(selector),0,type);
    if (method && class_addMethod(cls,sel_registerName(alias),method_getImplementation(method),type))
        method_setImplementation(method,imp);
}

// Glass is a plugin-owned, empty UIButton behind the host's existing content.
// No host configuration, image, frame, bounds, center or size provider is set.
extern Obj AllocateClass(Obj,const char *,U) __asm__("_objc_allocateClassPair");
extern void RegisterClass(Obj) __asm__("_objc_registerClassPair");
extern void FQDRecord(const char *,Obj);
B FQHButtonAvailable(void) {
    return Responds(Lookup("UIButtonConfiguration"),"glassButtonConfiguration");
}
static Rect Frame(Obj view) { return ((Rect(*)(Obj,Sel))Message)(view,sel_registerName("frame")); }
static Rect Bounds(Obj view) { return ((Rect(*)(Obj,Sel))Message)(view,sel_registerName("bounds")); }
static void SetFrame(Obj view,Rect frame) { ((void(*)(Obj,Sel,Rect))Message)(view,sel_registerName("setFrame:"),frame); }
static Obj RectBox(Rect rect) { return ((Obj(*)(Obj,Sel,Rect))Message)(Lookup("NSValue"),sel_registerName("valueWithCGRect:"),rect); }
static Rect UnboxRect(Obj value) { return ((Rect(*)(Obj,Sel))Message)(value,sel_registerName("CGRectValue")); }
static B SameRect(Rect a,Rect b) { return a.x==b.x && a.y==b.y && a.width==b.width && a.height==b.height; }
static B FiniteRect(Rect a) { return __builtin_isfinite(a.x) && __builtin_isfinite(a.y) && __builtin_isfinite(a.width) && __builtin_isfinite(a.height); }
static B VisibleRect(Rect a) { return FiniteRect(a) && a.width>0 && a.height>0; }
static Rect Convert(Obj view,Rect rect,Obj destination) {
    return ((Rect(*)(Obj,Sel,Rect,Obj))Message)(view,sel_registerName("convertRect:toView:"),rect,destination);
}
static B Belongs(Obj view,Obj owner) {
    for (int depth=0;view && depth<8;++depth,view=Get(view,"superview"))
        if (view==owner) return 1;
    return 0;
}
static Obj At(Obj array,U index) { return ((Obj(*)(Obj,Sel,U))Message)(array,sel_registerName("objectAtIndex:"),index); }
static void Press(Obj self,Sel cmd,Obj sender) { (void)cmd; (void)sender; VB(self,"setHighlighted:",1); }
static void ReleasePress(Obj self,Sel cmd,Obj sender) { (void)cmd; (void)sender; VB(self,"setHighlighted:",0); }
static Obj GlassClass(void) {
    Obj cls=Lookup("FQXGlassBackground167");
    if (cls) return cls;
    cls=AllocateClass(Lookup("UIButton"),"FQXGlassBackground167",0);
    if (!cls) return 0;
    class_addMethod(cls,sel_registerName("fqx167_down:"),(Imp)Press,"v24@0:8@16");
    class_addMethod(cls,sel_registerName("fqx167_up:"),(Imp)ReleasePress,"v24@0:8@16");
    RegisterClass(cls);
    return cls;
}
static void ObservePress(Obj view,Obj glass,B add) {
    if (!Kind(view,"UIControl")) return;
    Sel selector=sel_registerName(add ? "addTarget:action:forControlEvents:" : "removeTarget:action:forControlEvents:");
    ((void(*)(Obj,Sel,Obj,Sel,U))Message)(view,selector,glass,sel_registerName("fqx167_down:"),17);
    ((void(*)(Obj,Sel,Obj,Sel,U))Message)(view,selector,glass,sel_registerName("fqx167_up:"),480);
}
static Rect HitInsets(Obj view) { return ((Rect(*)(Obj,Sel))Message)(view,sel_registerName("btd_hitTestEdgeInsets")); }
static void SetHitInsets(Obj view,Rect insets) { ((void(*)(Obj,Sel,Rect))Message)(view,sel_registerName("setBtd_hitTestEdgeInsets:"),insets); }
static void RestoreHit(Obj view) {
    Obj original=objc_getAssociatedObject(view,HitInsetsKey),applied=objc_getAssociatedObject(view,AppliedHitInsetsKey);
    if (original && applied && SameRect(HitInsets(view),UnboxRect(applied))) SetHitInsets(view,UnboxRect(original));
    objc_setAssociatedObject(view,HitInsetsKey,0,1);
    objc_setAssociatedObject(view,AppliedHitInsetsKey,0,1);
}
static B CanExpandHit(Obj view) {
    return Responds(view,"btd_hitTestEdgeInsets") && Responds(view,"setBtd_hitTestEdgeInsets:");
}
// The inspected UIView BTDAdditions uses negative insets to extend hit testing.
// Rect fields here carry UIEdgeInsets (top,left,bottom,right), the same 4-double ABI.
static void EnsureHit(Obj view,Rect visual) {
    if (!CanExpandHit(view)) return;
    Rect bounds=Bounds(view),current=HitInsets(view);
    if (!VisibleRect(bounds) || !FiniteRect(current)) return;
    Obj original=objc_getAssociatedObject(view,HitInsetsKey),applied=objc_getAssociatedObject(view,AppliedHitInsetsKey);
    if (!original || !applied || !SameRect(current,UnboxRect(applied))) {
        original=RectBox(current);
        objc_setAssociatedObject(view,HitInsetsKey,original,1);
    }
    Rect wanted=UnboxRect(original);
    double top=visual.y-bounds.y,left=visual.x-bounds.x;
    double bottom=bounds.y+bounds.height-visual.y-visual.height;
    double right=bounds.x+bounds.width-visual.x-visual.width;
    if (top<wanted.x) wanted.x=top;
    if (left<wanted.y) wanted.y=left;
    if (bottom<wanted.width) wanted.width=bottom;
    if (right<wanted.height) wanted.height=right;
    if (!SameRect(current,wanted)) SetHitInsets(view,wanted);
    if (!applied || !SameRect(wanted,UnboxRect(applied)))
        objc_setAssociatedObject(view,AppliedHitInsetsKey,RectBox(wanted),1);
}
static void Put(Obj dict,const char *key,Obj value) {
    ((void(*)(Obj,Sel,Obj,Obj))Message)(dict,sel_registerName("setObject:forKey:"),value,Text(key));
}
static Obj Number(double value) { return ((Obj(*)(Obj,Sel,double))Message)(Lookup("NSNumber"),sel_registerName("numberWithDouble:"),value); }
static Obj RectArray(Rect rect) {
    Obj result=O0(Lookup("NSMutableArray"),"array");
    V1(result,"addObject:",Number(rect.x)); V1(result,"addObject:",Number(rect.y));
    V1(result,"addObject:",Number(rect.width)); V1(result,"addObject:",Number(rect.height));
    return result;
}
static void RecordLayout(Obj view,Obj glass,Rect image,const char *role) {
    Rect frame=Frame(view),bounds=Bounds(view),material=Frame(glass);
    Obj window=Get(view,"window");
    Rect screen=window ? Convert(view,bounds,window) : frame;
    Obj previous=objc_getAssociatedObject(view,LayoutKey);
    if (previous && SameRect(frame,UnboxRect(At(previous,0))) && SameRect(bounds,UnboxRect(At(previous,1))) &&
        SameRect(image,UnboxRect(At(previous,2))) && SameRect(material,UnboxRect(At(previous,3))) &&
        SameRect(screen,UnboxRect(At(previous,4)))) return;
    double now=((double(*)(Obj,Sel))Message)(O0(Lookup("NSProcessInfo"),"processInfo"),sel_registerName("systemUptime"));
    Obj last=objc_getAssociatedObject(view,LayoutTimeKey);
    if (last && now-((double(*)(Obj,Sel))Message)(last,sel_registerName("doubleValue"))<1.0) return;
    Obj values[5]={RectBox(frame),RectBox(bounds),RectBox(image),RectBox(material),RectBox(screen)};
    Obj signature=((Obj(*)(Obj,Sel,Obj *,U))Message)(Lookup("NSArray"),sel_registerName("arrayWithObjects:count:"),values,5);
    objc_setAssociatedObject(view,LayoutKey,signature,1);
    objc_setAssociatedObject(view,LayoutTimeKey,Number(now),1);
    Obj record=O0(Lookup("NSMutableDictionary"),"dictionary");
    Put(record,"role",Text(role)); Put(record,"hostFrame",RectArray(frame)); Put(record,"hostBounds",RectArray(bounds));
    Put(record,"imageRect",RectArray(image)); Put(record,"glassRect",RectArray(material)); Put(record,"windowRect",RectArray(screen));
    FQDRecord("controlLayout167",record);
}
Obj FQHIconGlass(Obj view) { return objc_getAssociatedObject(view,IconGlassKey); }
static void RestoreIcon(Obj view,Obj glass) {
    if (glass) { ObservePress(view,glass,0); V0(glass,"removeFromSuperview"); }
    objc_setAssociatedObject(view,IconGlassKey,0,1);
    objc_setAssociatedObject(view,IconRectKey,0,1);
    objc_setAssociatedObject(view,LayoutKey,0,1);
    objc_setAssociatedObject(view,LayoutTimeKey,0,1);
    RestoreHit(view); RestoreOwner(view);
}
static void Icon(Obj view,const char *role) {
    if (!Kind(view,"UIView") || objc_getAssociatedObject(view,BusyKey)) return;
    objc_setAssociatedObject(view,BusyKey,view,0);
    Obj glass=FQHIconGlass(view);
    Rect bounds=Bounds(view);
    if (!Enabled() || !FQHButtonAvailable() || !VisibleRect(bounds)) {
        RestoreIcon(view,glass); objc_setAssociatedObject(view,BusyKey,0,0); return;
    }
    Rect image=bounds;
    Obj glyph=Kind(view,"UIButton") ? Get(view,"imageView") : (Obj)0;
    if (glyph && Belongs(glyph,view) && !Flag(glyph,"isHidden") && VisibleRect(Bounds(glyph))) {
        Rect measured=Convert(glyph,Bounds(glyph),view);
        if (VisibleRect(measured)) image=measured;
    }
    // The inspected back asset draws its chevron in the left half of a 24pt canvas.
    // Align the lens to that visible center, without changing the host image.
    B back=Equal(Text(role),"readerBack");
    B shelf=Equal(Text(role),"shelfSearch") || Equal(Text(role),"shelfMore");
    double diameter=shelf ? 28 : 36;
    double centerX=image.x+image.width*(back ? 0.25 : 0.5);
    Rect material={centerX-diameter*0.5,image.y+image.height*0.5-diameter*0.5,diameter,diameter};
    if (!CanExpandHit(view)) {
        RestoreIcon(view,glass); objc_setAssociatedObject(view,BusyKey,0,0); return;
    }
    if (!VisibleRect(material)) { RestoreIcon(view,glass); objc_setAssociatedObject(view,BusyKey,0,0); return; }
    if (!glass) {
        Obj config=O0(Lookup("UIButtonConfiguration"),"glassButtonConfiguration");
        if (config) glass=O0(GlassClass(),"new");
        if (!glass) { objc_setAssociatedObject(view,BusyKey,0,0); return; }
        V1(glass,"setConfiguration:",config);
        VB(glass,"setUserInteractionEnabled:",0); VB(glass,"setAccessibilityElementsHidden:",1);
        VB(glass,"setIsAccessibilityElement:",0); VB(glass,"setOpaque:",0);
        Q1(glass,"setAutoresizingMask:",0);
        objc_setAssociatedObject(view,IconGlassKey,glass,1);
        V0(glass,"release");
        ObservePress(view,glass,1);
    }
    Obj transaction=Lookup("CATransaction");
    V0(transaction,"begin");VB(transaction,"setDisableActions:",1);
    PrepareOwner(view);
    Obj lastRect=objc_getAssociatedObject(view,IconRectKey);
    // Compare the requested layout, not UIKit's transient pressed geometry.
    if (!lastRect || !SameRect(UnboxRect(lastRect),material)) {
        SetFrame(glass,material);
        objc_setAssociatedObject(view,IconRectKey,RectBox(material),1);
    }
    if (O0(glass,"superview")!=view)
        ((void(*)(Obj,Sel,Obj,I))Message)(view,sel_registerName("insertSubview:atIndex:"),glass,0);
    if (Kind(view,"UIControl")) {
        VB(glass,"setEnabled:",Flag(view,"isEnabled"));
        VB(glass,"setSelected:",Flag(view,"isSelected"));
        VB(glass,"setHighlighted:",Flag(view,"isHighlighted"));
    }
    EnsureHit(view,material);
    V0(transaction,"commit");
    RecordLayout(view,glass,image,role);
    objc_setAssociatedObject(view,BusyKey,0,0);
}
void FQHButton(Obj view) { Icon(view,"icon"); }
static void IncludeGlass(Obj host,Obj parent,Rect *area) {
    Obj glass=FQHIconGlass(host);
    if (!glass || !Belongs(host,parent)) return;
    Rect r=Convert(host,Frame(glass),parent);
    if (!VisibleRect(r)) return;
    double right=area->x+area->width,bottom=area->y+area->height;
    if (r.x<area->x) area->x=r.x;
    if (r.y<area->y) area->y=r.y;
    if (r.x+r.width>right) right=r.x+r.width;
    if (r.y+r.height>bottom) bottom=r.y+r.height;
    area->width=right-area->x;area->height=bottom-area->y;
}
I FQHReaderCount(Obj owner) { return ((I(*)(Obj,Sel))Message)(objc_getAssociatedObject(owner,ReaderGlassKey),sel_registerName("integerValue")); }
static void ReaderCount(Obj owner,I count) {
    if (count==FQHReaderCount(owner)) return;
    Obj value=count ? ((Obj(*)(Obj,Sel,I))Message)(Lookup("NSNumber"),sel_registerName("numberWithLongLong:"),count) : (Obj)0;
    objc_setAssociatedObject(owner,ReaderGlassKey,value,1);
}
static const char *InsertRole(Obj obj) {
    if (Kind(obj,"FQReaderNavigationBarMoreBtnInsertObject")) return "readerMore";
    if (Kind(obj,"FQReaderNavigationBarSearchBtnInsertObject")) return "readerSearch";
    if (Kind(obj,"SSReaderNavigationBarDownloadBtnInsertObject")) return "readerDownload";
    if (Kind(obj,"SSReaderNavigationBarCommunitySwitchBtnInsertObject")) return "readerCommunity";
    return 0;
}
void FQHReader(Obj owner) {
    if (objc_getAssociatedObject(owner,OwnerBusyKey)) return;
    objc_setAssociatedObject(owner,OwnerBusyKey,owner,0);
    Rect area=Bounds(owner);
    Obj back=Get(owner,"backBtn");
    I styled=0;
    if (Belongs(back,owner)) { Icon(back,"readerBack"); IncludeGlass(back,owner,&area); styled=FQHIconGlass(back)!=0; }
    Obj items=Get(owner,"insertObjs");
    if (Kind(items,"NSArray")) {
        U count=((U(*)(Obj,Sel))Message)(items,sel_registerName("count"));
        if (count>16) count=16;
        for (U i=0;i<count;++i) {
            Obj item=At(items,i); const char *role=InsertRole(item);
            if (!role) continue;
            Obj view=Get(item,"getInsertView");
            if (Belongs(view,owner)) { Icon(view,role); IncludeGlass(view,owner,&area); styled+=FQHIconGlass(view)!=0; }
        }
    }
    if (styled) EnsureHit(owner,area); else RestoreHit(owner);
    ReaderCount(owner,styled);
    objc_setAssociatedObject(owner,OwnerBusyKey,0,0);
}
static void ReaderLayout(Obj self,Sel cmd) {
    ((void(*)(Obj,Sel))Original("FQReaderSaasNavigationView","fqx167_originalLayout"))(self,cmd);
    FQHReader(self);
}
static void ReaderTheme(Obj self,Sel cmd,Obj theme) {
    ((void(*)(Obj,Sel,Obj))Original("FQReaderSaasNavigationView","fqx167_originalTheme:"))(self,cmd,theme);
    FQHReader(self);
}
void FQHShelf(Obj self) {
    if (objc_getAssociatedObject(self,OwnerBusyKey)) return;
    objc_setAssociatedObject(self,OwnerBusyKey,self,0);
    Obj search=Get(self,"searchButton"),more=Get(self,"moreButton"),parent=Get(self,"searchAndMoreView");
    Icon(search,"shelfSearch");Icon(more,"shelfMore");
    if (Kind(parent,"UIView")) {
        Rect area=Bounds(parent);IncludeGlass(search,parent,&area);IncludeGlass(more,parent,&area);
        if (FQHIconGlass(search) || FQHIconGlass(more)) EnsureHit(parent,area); else RestoreHit(parent);
    }
    objc_setAssociatedObject(self,OwnerBusyKey,0,0);
}
static void ShelfLayout(Obj self,Sel cmd) {
    ((void(*)(Obj,Sel))Original("SSBookShelfSubViewController","fqx167_originalShelfLayout"))(self,cmd);
    FQHShelf(self);
}
void FQHInstall(void) {
    if (!FQHGlassAvailable()) return;
    Hook("SSBookStoreNewViewController","relayout","fqx165_originalRelayout","v16@0:8",(Imp)HomeLayout);
    Hook("SSBookStoreNewViewController","viewDidAppear:","fqx165_originalAppear:","v20@0:8B16",(Imp)HomeAppear);
    Hook("SSBookStoreCategorySignView","layoutSubviews","fqx165_originalLayout","v16@0:8",(Imp)CategoryLayout);
    Hook("SSBookStoreCategorySignView","resetColorWithRatio:fromTab:toTab:fromTabTemplate:toTabTemplate:","fqx165_originalColor:from:to:fromTemplate:toTemplate:","v40@0:8d16i24i28i32i36",(Imp)CategoryColor);
    Hook("SSBookStoreSearchBarComponent","resetTopTabSearchViewWithRatio:fromTab:toTab:fromTabTemplate:toTabTemplate:","fqx165_originalSearchColor:from:to:fromTemplate:toTemplate:","v40@0:8d16i24i28i32i36",(Imp)SearchColor);
    Hook("SSBookShelfSubViewController","viewDidLayoutSubviews","fqx167_originalShelfLayout","v16@0:8",(Imp)ShelfLayout);
    Hook("FQReaderSaasNavigationView","layoutSubviews","fqx167_originalLayout","v16@0:8",(Imp)ReaderLayout);
    Hook("FQReaderSaasNavigationView","readerInsertedViewThemeConfigChange:","fqx167_originalTheme:","v24@0:8@16",(Imp)ReaderTheme);
}
