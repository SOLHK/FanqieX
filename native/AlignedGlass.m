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
static void ShelfRoleKey(void) {}
static void GlyphOriginalKey(void) {}
static void GlyphAppliedKey(void) {}
static void GlyphViewKey(void) {}
static void RestoreGlyph(Obj owner) {
    Obj glyph=objc_getAssociatedObject(owner,GlyphViewKey);
    Obj original=objc_getAssociatedObject(glyph,GlyphOriginalKey);
    if (original) {
        Rect rect=((Rect(*)(Obj,Sel))Message)(original,sel_registerName("CGRectValue"));
        ((void(*)(Obj,Sel,Rect))Message)(glyph,sel_registerName("setFrame:"),rect);
    }
    objc_setAssociatedObject(glyph,GlyphOriginalKey,0,1);
    objc_setAssociatedObject(glyph,GlyphAppliedKey,0,1);
    objc_setAssociatedObject(owner,GlyphViewKey,0,1);
}
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
        Signature("SSBookStoreNewViewController","searchBgView","@16@0:8");
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
// The search owner is also the clipping viewport for cycling search words.
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
    if (!surface) { RestoreHeaderOwner(view); RestoreOwner(view); return; }
    if (objc_getAssociatedObject(view,ClipsKey) || objc_getAssociatedObject(view,HeaderClipsKey)) {
        Obj clear=O0(Lookup("UIColor"),"clearColor");
        Obj current=O0(view,"backgroundColor");
        if (current==clear || ((B(*)(Obj,Sel,Obj))Message)(current,sel_registerName("isEqual:"),clear))
            V1(view,"setBackgroundColor:",objc_getAssociatedObject(view,BackgroundKey));
    }
    V0(surface,"removeFromSuperview");
    objc_setAssociatedObject(view,SurfaceKey,0,1);
    objc_setAssociatedObject(view,BackgroundKey,0,1);
    RestoreHeaderOwner(view); RestoreOwner(view);
}
static void ClearBackground(Obj view,Obj clear) {
    Obj value=O0(view,"backgroundColor");
    if (value!=clear && !((B(*)(Obj,Sel,Obj))Message)(value,sel_registerName("isEqual:"),clear))
        V1(view,"setBackgroundColor:",clear);
}
static void ApplySurface(Obj view,Rect material,B preserveOwner) {
    if (objc_getAssociatedObject(view,BusyKey)) return;
    objc_setAssociatedObject(view,BusyKey,view,0);
    Obj surface=objc_getAssociatedObject(view,SurfaceKey);
    if (!Enabled() || !FQHGlassAvailable() ||
        !__builtin_isfinite(material.x) || !__builtin_isfinite(material.y) ||
        !__builtin_isfinite(material.width) || !__builtin_isfinite(material.height) ||
        !(material.width>0 && material.height>0)) {
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
        if (!preserveOwner) objc_setAssociatedObject(view,BackgroundKey,O0(view,"backgroundColor"),1);
    }
    Obj clear=O0(Lookup("UIColor"),"clearColor");
    Obj transaction=Lookup("CATransaction");
    V0(transaction,"begin"); VB(transaction,"setDisableActions:",1);
    if (!preserveOwner) {
        Obj current=O0(view,"backgroundColor");
        // A host theme update owns the latest restoration color.
        if (current!=clear && !((B(*)(Obj,Sel,Obj))Message)(current,sel_registerName("isEqual:"),clear))
            objc_setAssociatedObject(view,BackgroundKey,current,1);
        if (objc_getAssociatedObject(view,HeaderKey)) PrepareHeaderOwner(view,material);
        else PrepareOwner(view);
        ClearBackground(view,clear);
    }
    Rect placed=((Rect(*)(Obj,Sel))Message)(surface,sel_registerName("frame"));
    if (placed.x!=material.x || placed.y!=material.y || placed.width!=material.width || placed.height!=material.height)
        ((void(*)(Obj,Sel,Rect))Message)(surface,sel_registerName("setFrame:"),material);
    ClearBackground(surface,clear);
    ClearBackground(O0(surface,"contentView"),clear);
    if (O0(surface,"superview")!=view)
        ((void(*)(Obj,Sel,Obj,I))Message)(view,sel_registerName("insertSubview:atIndex:"),surface,0);
    V0(transaction,"commit");
    objc_setAssociatedObject(view,BusyKey,0,0);
}
void FQHApply(Obj view) {
    if (Kind(view,"UIView"))
        ApplySurface(view,((Rect(*)(Obj,Sel))Message)(view,sel_registerName("bounds")),0);
}
void FQHHeader(Obj view) {
    if (!Kind(view,"UIView")) return;
    objc_setAssociatedObject(view,HeaderKey,Text(Kind(view,"SSBookStoreCategorySignView") ? "categoryButton" : "search"),1);
    FQHApply(view);
    if (FQHSurface(view)) HeaderDiagnostics(view);
}
static Imp Original(const char *cls,const char *alias) {
    return method_getImplementation(class_getInstanceMethod(Lookup(cls),sel_registerName(alias)));
}
static void HomeLayout(Obj self,Sel cmd) {
    ((void(*)(Obj,Sel))Original("SSBookStoreNewViewController","fqx165_originalRelayout"))(self,cmd);
    FQHHeader(Get(self,"searchBgView"));
}
static void HomeAppear(Obj self,Sel cmd,B animated) {
    ((void(*)(Obj,Sel,B))Original("SSBookStoreNewViewController","fqx165_originalAppear:"))(self,cmd,animated);
    FQHHeader(Get(self,"searchBgView"));
}
static void CategoryLayout(Obj self,Sel cmd) {
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
static void HeaderDiagnostics(Obj view) {
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
    RestoreGlyph(view);
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
    B back=Equal(Text(role),"readerBack");
    B shelf=Equal(Text(role),"shelfSearch") || Equal(Text(role),"shelfMore");
    if ((back || shelf) && glyph) {
        if (objc_getAssociatedObject(view,GlyphViewKey)!=glyph) RestoreGlyph(view);
        Rect current=Frame(glyph);
        Obj old=objc_getAssociatedObject(glyph,GlyphOriginalKey);
        Obj applied=objc_getAssociatedObject(glyph,GlyphAppliedKey);
        if (!old || !applied || !SameRect(current,UnboxRect(applied))) {
            old=RectBox(current);objc_setAssociatedObject(glyph,GlyphOriginalKey,old,1);
        }
        Rect base=UnboxRect(old),adjusted=base;
        if (back) adjusted.x+=base.width*0.5;
        else {
            adjusted.width=base.width*0.75;adjusted.height=base.height*0.75;
            adjusted.x+=base.width*0.125;adjusted.y+=base.height*0.125;
            if (Equal(Text(role),"shelfSearch")) adjusted.x-=12;
            if (Equal(Text(role),"shelfMore")) adjusted.x-=base.width*0.25;
        }
        if (!SameRect(current,adjusted)) SetFrame(glyph,adjusted);
        objc_setAssociatedObject(glyph,GlyphAppliedKey,RectBox(adjusted),1);
        objc_setAssociatedObject(view,GlyphViewKey,glyph,1);
    }
    double diameter=shelf ? 28 : 36;
    double centerX=bounds.x+bounds.width*0.5+(back ? 6 : 0)-(Equal(Text(role),"shelfSearch") ? 12 : 0);
    Rect material={centerX-diameter*0.5,bounds.y+bounds.height*0.5-diameter*0.5,diameter,diameter};
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
    objc_setAssociatedObject(search,ShelfRoleKey,Text("search"),1);
    objc_setAssociatedObject(more,ShelfRoleKey,Text("more"),1);
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
static void ShelfButtonLayout(Obj self,Sel cmd) {
    ((void(*)(Obj,Sel))Original("FQReaderSaaSBaseButton","fqx170_originalLayout"))(self,cmd);
    Obj role=objc_getAssociatedObject(self,ShelfRoleKey);
    if (role) Icon(self,Equal(role,"search") ? "shelfSearch" : "shelfMore");
}
static void ListenLabelKey(void) {}
static void ListenColorKey(void) {}
static void ListenTintKey(void) {}
B FQHIsEdit(Obj view) {
    return Kind(view,"UIControl") && Kind(Get(view,"superview"),"SSBookshelfEditBottomView");
}
Rect FQHEditRect(Obj view) {
    Rect b=Bounds(view);
    // Preserve the host's complete icon/caption and its existing touch area.
    if (b.width>40 && b.height>24) { b.x+=6;b.width-=12;b.y+=4;b.height-=8; }
    return b;
}
static Obj ListenCaption(Obj view,int depth) {
    if (Kind(view,"UILabel") && Equal(Get(view,"text"),"听")) return view;
    if (!depth || Kind(view,"UIVisualEffectView")) return 0;
    Obj children=Get(view,"subviews");U n=((U(*)(Obj,Sel))Message)(children,sel_registerName("count"));
    if (n>12) n=12;
    for (U i=0;i<n;++i) { Obj found=ListenCaption(At(children,i),depth-1);if(found)return found; }
    return 0;
}
void FQHListen(Obj view) {
    if (!Kind(view,"SSReaderFloatingCommonButton")) return;
    Obj label=ListenCaption(view,2),saved=objc_getAssociatedObject(view,ListenLabelKey);
    if (!Enabled() || !label || !FQHGlassAvailable()) {
        if (saved) V1(saved,"setTextColor:",objc_getAssociatedObject(view,ListenColorKey));
        objc_setAssociatedObject(view,ListenLabelKey,0,1);objc_setAssociatedObject(view,ListenColorKey,0,1);
        objc_setAssociatedObject(view,ListenTintKey,0,1);
        Restore(view,FQHSurface(view));return;
    }
    FQHApply(view);
    Obj surface=FQHSurface(view);if (!surface) return;
    if (saved!=label) {
        if(saved)V1(saved,"setTextColor:",objc_getAssociatedObject(view,ListenColorKey));
        objc_setAssociatedObject(view,ListenLabelKey,label,1);
        objc_setAssociatedObject(view,ListenColorKey,Get(label,"textColor"),1);
    }
    Obj foreground=O0(Lookup("UIColor"),"labelColor");
    if (!((B(*)(Obj,Sel,Obj))Message)(Get(label,"textColor"),sel_registerName("isEqual:"),foreground))
        V1(label,"setTextColor:",foreground);
    if (!objc_getAssociatedObject(view,ListenTintKey)) {
        Obj tint=((Obj(*)(Obj,Sel,double))Message)(O0(Lookup("UIColor"),"secondarySystemBackgroundColor"),sel_registerName("colorWithAlphaComponent:"),0.5);
        Obj effect=O0(Get(surface,"effect"),"copy");
        V1(effect,"setTintColor:",tint);V1(surface,"setEffect:",effect);V0(effect,"release");
        objc_setAssociatedObject(view,ListenTintKey,surface,1);
    }
}
static void ListenLayout(Obj self,Sel cmd) {
    ((void(*)(Obj,Sel))Original("SSReaderFloatingCommonButton","fqx171_originalLayout"))(self,cmd);
    FQHListen(self);
}
static void SpeechImageKey(void) {}
static void SpeechGlyphKey(void) {}
static void SpeechTintKey(void) {}
static void SetSpeechImage(Obj button,Obj image) {
    ((void(*)(Obj,Sel,Obj,U))Message)(button,sel_registerName("setImage:forState:"),image,0);
}
static void SpeechGlass(Obj view) {
    Obj button=Get(view,"speechBtn");
    if (!Kind(button,"UIButton") || !Belongs(button,view)) return;
    Obj image=((Obj(*)(Obj,Sel,U))Message)(button,sel_registerName("imageForState:"),0);
    Obj glyph=objc_getAssociatedObject(button,SpeechGlyphKey);
    Obj foreground=O0(Lookup("UIColor"),"labelColor");
    Obj tint=Get(button,"tintColor");
    B hasTint=((B(*)(Obj,Sel,Obj))Message)(tint,sel_registerName("isEqual:"),foreground);
    if (!Enabled() || !FQHGlassAvailable() || !VisibleRect(Bounds(button))) {
        if (glyph) {
            if (image==glyph) SetSpeechImage(button,objc_getAssociatedObject(button,SpeechImageKey));
            Obj previousTint=objc_getAssociatedObject(button,SpeechTintKey);
            if (hasTint && previousTint) V1(button,"setTintColor:",previousTint);
            objc_setAssociatedObject(button,SpeechImageKey,0,1);
            objc_setAssociatedObject(button,SpeechGlyphKey,0,1);
            objc_setAssociatedObject(button,SpeechTintKey,0,1);
        }
        Restore(button,FQHSurface(button));
        return;
    }
    if (!glyph) {
        // The 56pt theme image includes the opaque disc. Use the host's
        // transparent version of the same glyph so the material shows through.
        Obj artwork=Get(Lookup("BDNovelNewAssetsGenerated"),"bdn_novelReaderListenButton");
        glyph=((Obj(*)(Obj,Sel,I))Message)(artwork,sel_registerName("imageWithRenderingMode:"),2);
        if (!glyph) return;
    }
    FQHApply(button);
    if (!FQHSurface(button)) return;
    if (!hasTint) {
        objc_setAssociatedObject(button,SpeechTintKey,tint,1);
        V1(button,"setTintColor:",foreground);
    }
    if (image!=glyph) {
        objc_setAssociatedObject(button,SpeechImageKey,image,1);
        objc_setAssociatedObject(button,SpeechGlyphKey,glyph,1);
        SetSpeechImage(button,glyph);
    }
}
static void SpeechLayout(Obj self,Sel cmd) {
    ((void(*)(Obj,Sel))Original("FQReaderSaaSReaderSpeechButton","fqx175_originalSpeechLayout"))(self,cmd);
    SpeechGlass(self);
}
static void SpeechTheme(Obj self,Sel cmd,Obj theme) {
    ((void(*)(Obj,Sel,Obj))Original("FQReaderSaaSReaderSpeechButton","fqx175_originalSpeechTheme:"))(self,cmd,theme);
    SpeechGlass(self);
}
// ---------------------------------------------------------------------------
// 1.7.4 page surfaces. These are exact-class hooks. No UIView layout method is
// replaced and every decoration is a plugin-owned, non-interactive view behind
// the host's existing content. The same surface is reused across layout/theme
// passes and is removed from the exact owner when the user disables glass.
static void PageRoleKey(void) {}
static void PageTintKey(void) {}
static void TabOriginalKey(void) {}
static void TabBusyKey(void) {}
static void OptionsMarkKey(void) {}
static void ToggleObserverKey(void) {}
static void ToggleShortKey(void) {}
static void ToggleMallKey(void) {}
static void PageRole(Obj view,const char *role) {
    objc_setAssociatedObject(view,PageRoleKey,Text(role),1);
}
static B BoolProp(Obj view,const char *selector) {
    return Responds(view,selector) ? Flag(view,selector) : 0;
}
static B HasAncestor(Obj view,const char *name) {
    Obj parent=Get(view,"superview");
    for (int depth=0;parent && depth<5;++depth,parent=Get(parent,"superview"))
        if (Kind(parent,name)) return 1;
    return 0;
}
static void PageRestore(Obj view) {
    if (view && Kind(view,"UIView")) Restore(view,FQHSurface(view));
}
static void PageStyle(Obj view,const char *role) {
    if (!view || !Kind(view,"UIView")) return;
    Rect bounds=Bounds(view);
    if (!VisibleRect(bounds)) { PageRestore(view); return; }
    PageRole(view,role);
    FQHApply(view);
}
static void ShelfTint(Obj surface,B selected,B filter) {
    if (!surface) return;
    Obj previous=objc_getAssociatedObject(surface,PageTintKey);
    if (previous && BoolProp(previous,"boolValue")==selected) return;
    Obj effect=O0(Get(surface,"effect"),"copy");
    if (!effect) return;
    Obj color=selected ? O0(Lookup("UIColor"),filter ? "systemOrangeColor" : "labelColor") : (Obj)0;
    Obj tint=((Obj(*)(Obj,Sel,double))Message)(color,sel_registerName("colorWithAlphaComponent:"),0.125);
    V1(effect,"setTintColor:",tint);
    V1(surface,"setEffect:",effect);
    V0(effect,"release");
    objc_setAssociatedObject(surface,PageTintKey,BoolBox(selected),1);
}
static Obj EntryTitle(Obj view) {
    Obj label=Get(view,"functionType");
    if (!label) label=Get(view,"label");
    Obj value=label ? Get(label,"text") : (Obj)0;
    if (!value) value=Get(view,"titleString");
    return Kind(value,"NSString") ? value : (Obj)0;
}
static B ProfileEntry(Obj view) {
    Obj title=EntryTitle(view);
    return Equal(title,"我的订单") || Equal(title,"浏览历史") || Equal(title,"我的消息") ||
           Equal(title,"创作中心") || Equal(title,"我的预约");
}
static B ReaderBottomItem(Obj view,Obj toolbar) {
    return view==Get(toolbar,"chapterView") || view==Get(toolbar,"darkModeView") ||
           view==Get(toolbar,"setttingView");
}
static void ReaderBottomGlass(Obj view) {
    Rect glass=Bounds(view);
    glass.x+=6; glass.width-=12;
    glass.y+=4; glass.height-=8;
    ApplySurface(view,glass,0);
}
// The legacy reader walker also visits the nested buttons. Only one material
// owns each target, including when the legacy callback runs before ours.
B FQHReaderOwnsControl(Obj view) {
    for (int depth=0;view && depth<4;++depth,view=Get(view,"superview")) {
        if (Kind(view,"FQReaderSaaSBottomToolItemView")) {
            Obj toolbar=Get(view,"superview");
            return Kind(toolbar,"FQReaderSaaSBottomToolView") && ReaderBottomItem(view,toolbar) && FQHGlassAvailable();
        }
        if (Kind(view,"FQReaderSaaSReaderSpeechButton")) return FQHGlassAvailable();
    }
    return 0;
}
static void PageBottomLayout(Obj self,Sel cmd) {
    ((void(*)(Obj,Sel))Original("FQReaderSaaSBottomToolView","fqx175_originalBottom"))(self,cmd);
    Obj items=Get(self,"itemViews");
    U count=((U(*)(Obj,Sel))Message)(items,sel_registerName("count"));
    for (U i=0;i<count;++i) {
        Obj view=At(items,i);
        if (!Kind(view,"FQReaderSaaSBottomToolItemView") || !Belongs(view,self)) continue;
        if (ReaderBottomItem(view,self)) ReaderBottomGlass(view);
        else PageRestore(view);
    }
}
static void PageProgressLayout(Obj self,Sel cmd) {
    ((void(*)(Obj,Sel))Original("FQReaderSaaSNewProgressView","fqx174_originalProgress"))(self,cmd);
    Obj slider=Get(self,"slider");
    if (!Kind(slider,"BDReaderNewSlider")) return;
    // Inset only the material. The track, thumb and gesture coordinates stay in host space.
    Rect glass=Bounds(slider);
    glass.x+=6; glass.width-=12;
    glass.y+=5; glass.height-=10;
    ApplySurface(slider,glass,1);
}
static void PageDivertLayout(Obj self,Sel cmd) {
    ((void(*)(Obj,Sel))Original("SSReaderBottomToolDivertView","fqx175_originalDivert"))(self,cmd);
    if (HasAncestor(self,"FQReaderSaaSBottomToolView") &&
        Equal(Get(Get(self,"titleLabel"),"text"),"改编剧场"))
        ReaderBottomGlass(self);
    else PageRestore(self);
}
static void PageGiftLayout(Obj self,Sel cmd) {
    ((void(*)(Obj,Sel))Original("SSReaderGiftView","fqx174_originalGift"))(self,cmd);
    Obj button=Get(self,"giftButton");
    if (button) PageStyle(button,"readerGift"); else PageRestore(self);
}
static void PageBookGiftLayout(Obj self,Sel cmd) {
    ((void(*)(Obj,Sel))Original("SSReaderBookEndUserGiftView","fqx174_originalBookGift"))(self,cmd);
    PageStyle(self,"readerGift");
}
static void PageDiscussLayout(Obj self,Sel cmd) {
    ((void(*)(Obj,Sel))Original("SSReaderChapterEndDiscussionEntranceView","fqx174_originalDiscuss"))(self,cmd);
    if (HasAncestor(self,"SSReaderChapterEndDiscussionEntranceButton")) { PageRestore(self); return; }
    PageStyle(self,"readerDiscuss");
}
static void PageDiscussButtonLayout(Obj self,Sel cmd) {
    ((void(*)(Obj,Sel))Original("SSReaderChapterEndDiscussionEntranceButton","fqx174_originalDiscussButton"))(self,cmd);
    if (HasAncestor(self,"SSReaderChapterEndDiscussionEntranceView")) { PageRestore(self); return; }
    PageStyle(self,"readerDiscuss");
}
static void ShelfTabStyle(Obj view,Obj model,B selected) {
    Rect bounds=Bounds(view), material=bounds;
    // The host widths follow the title's zoom. Spend only the available gap
    // on padding so a capsule cannot run into the next tab during a swipe.
    double spacing=Responds(model,"cellSpacing") ?
        ((double(*)(Obj,Sel))Message)(model,sel_registerName("cellSpacing")) : 0;
    double room=bounds.width+(spacing>6 ? spacing-6 : 0);
    material.width=room<42 ? room : 42;
    material.height=bounds.height-4<28 ? bounds.height-4 : 28;
    material.x+=(bounds.width-material.width)*0.5;
    material.y+=(bounds.height-material.height)*0.5;
    PageRole(view,"shelfTab");
    ApplySurface(view,material,0);
    ShelfTint(FQHSurface(view),selected,0);
}
static void PageShelfTabLayout(Obj self,Sel cmd) {
    ((void(*)(Obj,Sel))Original("SSBookShelfTabSelectViewTitleCell","fqx174_originalShelfCategory"))(self,cmd);
    Obj model=Get(self,"cellModel");
    ShelfTabStyle(self,model,BoolProp(model,"isSelected"));
}
static void PageShelfTabReload(Obj self,Sel cmd,Obj model) {
    ((void(*)(Obj,Sel,Obj))Original("SSBookShelfTabSelectViewTitleCell","fqx175_originalShelfTabReload:"))(self,cmd,model);
    ShelfTabStyle(self,model,BoolProp(model,"isSelected"));
}
static void ShelfFilterStyle(Obj view) {
    if (!HasAncestor(view,"SSBookShelfFilterMixRowCollectionView") ||
        !HasAncestor(view,"SSBookShelfFilterHeaderView")) {
        PageRestore(view);
        return;
    }
    Rect material=Bounds(view);
    material.x+=1; material.width-=2;
    material.y+=1; material.height-=2;
    PageRole(view,"shelfFilter");
    ApplySurface(view,material,0);
    ShelfTint(FQHSurface(view),BoolProp(view,"isSelect"),1);
}
static void PageShelfFilterLayout(Obj self,Sel cmd) {
    ((void(*)(Obj,Sel))Original("SSBookShelfFilter541Cell","fqx175_originalShelfFilterLayout"))(self,cmd);
    ShelfFilterStyle(self);
}
static void PageShelfFilterAppearance(Obj self,Sel cmd,B selected) {
    ((void(*)(Obj,Sel,B))Original("SSBookShelfFilter541Cell","fqx175_originalShelfFilterAppearance:"))(self,cmd,selected);
    ShelfFilterStyle(self);
}
static void PageShelfFilterBackground(Obj self,Sel cmd,Obj color) {
    ((void(*)(Obj,Sel,Obj))Original("SSBookShelfFilter541Cell","fqx175_originalShelfFilterBackground:"))(self,cmd,color);
    ShelfFilterStyle(self);
}
static void PageProfileBarLayout(Obj self,Sel cmd) {
    ((void(*)(Obj,Sel))Original("SSMyUserBar","fqx174_originalProfileBar"))(self,cmd);
    // Both native carousel variants place their outgoing and incoming labels
    // inside searchBgView. Keep the animated words clipped to that pill.
    FQHHeader(Get(self,"searchBgView"));
}
static void PageProfileEntryLayout(Obj self,Sel cmd) {
    ((void(*)(Obj,Sel))Original("SSMyUserCollectionViewFunCell","fqx174_originalProfileEntry"))(self,cmd);
    if (ProfileEntry(self)) PageStyle(self,"profileEntry"); else PageRestore(self);
}
static void PageProfileEntry621Layout(Obj self,Sel cmd) {
    ((void(*)(Obj,Sel))Original("SSMyUser621FunctionEntryItemCell","fqx174_originalProfileEntry621"))(self,cmd);
    if (ProfileEntry(self)) PageStyle(self,"profileEntry"); else PageRestore(self);
}

// The promoted game name is server-provided. Add the reviewed card without
// changing the previous match for the 羊了个羊 campaign.
B FQHPageTargetGame(Obj value) {
    if (Equal(value,"抓大鹅") || Equal(value,"羊了个羊：星球") ||
        Equal(value,"羊了个羊:星球") || Equal(value,"羊了个羊")) return 1;
    return Responds(value,"hasPrefix:") &&
           ((B(*)(Obj,Sel,Obj))Message)(value,sel_registerName("hasPrefix:"),Text("羊了个羊"));
}
static B TargetModel(Obj model) {
    if (!model) return 0;
    Obj info=Get(model,"info");
    if (info && (FQHPageTargetGame(Get(info,"title")) ||
                 FQHPageTargetGame(Get(info,"name")))) return 1;
    if (FQHPageTargetGame(Get(model,"gameName")) ||
        FQHPageTargetGame(Get(model,"name")) ||
        FQHPageTargetGame(Get(model,"title"))) return 1;
    Obj content=Get(model,"gameContent");
    return content && FQHPageTargetGame(Get(content,"mpName"));
}
B FQHPageFilterMiniGame(Obj owner) {
    if (!owner) return 0;
    Obj model=Get(owner,"miniGameEntranceCellModel");
    if (!TargetModel(model)) return 0;
    // The host's own card-model contract supports an invisible/disabled row.
    // Removing the object from the mutable plan is a data-level deletion, not
    // hiding a parent view or blanking a reusable cell.
    VB(model,"setIsInvisible:",1);
    VB(model,"setIsDisabled:",1);
    Obj models=Get(owner,"models");
    if (Kind(models,"NSMutableArray") && Responds(models,"removeObjectIdenticalTo:"))
        V1(models,"removeObjectIdenticalTo:",model);
    Obj record=O0(Lookup("NSMutableDictionary"),"dictionary");
    Put(record,"event",Text("pageAdRemoved174"));
    Put(record,"ownerClass",Text("SSMyUser621BaseViewController"));
    Put(record,"source",Text("serverGameModel"));
    Put(record,"action",Text("removeModelBeforeListAdapter"));
    FQDRecord("pageAdFilter174",record);
    return 1;
}
static void MiniGameSetup(Obj self,Sel cmd) {
    ((void(*)(Obj,Sel))Original("SSMyUser621BaseViewController","fqx174_originalMiniGameSetup"))(self,cmd);
    FQHPageFilterMiniGame(self);
}

// Two bottom entries are optional. Defaults stay enabled for existing users.
static const char *ShortKey="FanqieX.BottomShortSentences.1";
static const char *MallKey="FanqieX.BottomMall.1";
static B DefaultEnabled(const char *key) {
    Obj value=O1(O0(Lookup("NSUserDefaults"),"standardUserDefaults"),"objectForKey:",Text(key));
    return value ? BoolProp(value,"boolValue") : 1;
}
static void SetDefault(const char *key,B value) {
    ((void(*)(Obj,Sel,B,Obj))Message)(O0(Lookup("NSUserDefaults"),"standardUserDefaults"),
        sel_registerName("setBool:forKey:"),value,Text(key));
}
static B ShortEnabled(void) { return DefaultEnabled(ShortKey); }
static B MallEnabled(void) { return DefaultEnabled(MallKey); }
Obj FQHPageTabItems(Obj items) {
    if (!Kind(items,"NSArray")) return items;
    Obj result=O0(Lookup("NSMutableArray"),"array");
    U count=((U(*)(Obj,Sel))Message)(items,sel_registerName("count"));
    if (count>32) count=32;
    for (U i=0;i<count;++i) {
        Obj item=At(items,i);
        Obj title=Get(item,"title");
        if (Equal(title,"短句") && !ShortEnabled()) continue;
        if (Equal(title,"商城") && !MallEnabled()) continue;
        V1(result,"addObject:",item);
    }
    return ((U(*)(Obj,Sel))Message)(result,sel_registerName("count"))==count ? items : result;
}
static void ApplyTabBar(Obj bar) {
    if (!bar || objc_getAssociatedObject(bar,TabBusyKey)) return;
    Obj original=objc_getAssociatedObject(bar,TabOriginalKey);
    if (!original) {
        original=Get(bar,"items");
        if (original) objc_setAssociatedObject(bar,TabOriginalKey,original,1);
    }
    Obj filtered=FQHPageTabItems(original);
    if (filtered==Get(bar,"items")) return;
    objc_setAssociatedObject(bar,TabBusyKey,bar,0);
    V1(bar,"setItems:",filtered);
    objc_setAssociatedObject(bar,TabBusyKey,0,0);
}
static void WalkTabBars(Obj view,int depth) {
    if (!view || depth<0) return;
    if (Kind(view,"SSTabBar")) { ApplyTabBar(view); return; }
    Obj children=Get(view,"subviews");
    U count=((U(*)(Obj,Sel))Message)(children,sel_registerName("count"));
    if (count>64) count=64;
    for (U i=0;i<count;++i) WalkTabBars(At(children,i),depth-1);
}
static void RefreshTabBars(void) {
    Obj app=Lookup("UIApplication");
    if (!app) return;
    Obj shared=O0(app,"sharedApplication");
    Obj key=Get(shared,"keyWindow");
    if (key) WalkTabBars(key,12);
    Obj windows=Get(shared,"windows");
    U count=((U(*)(Obj,Sel))Message)(windows,sel_registerName("count"));
    if (count>8) count=8;
    for (U i=0;i<count;++i) WalkTabBars(At(windows,i),12);
}
static void TabSetItems(Obj self,Sel cmd,Obj items) {
    if (objc_getAssociatedObject(self,TabBusyKey)) {
        ((void(*)(Obj,Sel,Obj))Original("SSTabBar","fqx174_originalTabItems"))(self,cmd,items);
        return;
    }
    objc_setAssociatedObject(self,TabOriginalKey,items,1);
    objc_setAssociatedObject(self,TabBusyKey,self,0);
    ((void(*)(Obj,Sel,Obj))Original("SSTabBar","fqx174_originalTabItems"))(self,cmd,FQHPageTabItems(items));
    objc_setAssociatedObject(self,TabBusyKey,0,0);
}
static void TabSetItemsAnimated(Obj self,Sel cmd,Obj items,B animated) {
    if (objc_getAssociatedObject(self,TabBusyKey)) {
        ((void(*)(Obj,Sel,Obj,B))Original("SSTabBar","fqx174_originalTabItemsAnimated"))(self,cmd,items,animated);
        return;
    }
    objc_setAssociatedObject(self,TabOriginalKey,items,1);
    objc_setAssociatedObject(self,TabBusyKey,self,0);
    ((void(*)(Obj,Sel,Obj,B))Original("SSTabBar","fqx174_originalTabItemsAnimated"))(self,cmd,FQHPageTabItems(items),animated);
    objc_setAssociatedObject(self,TabBusyKey,0,0);
}
static void ToggleChanged(Obj self,Sel cmd,Obj sender) {
    (void)self; (void)cmd;
    I tag=((I(*)(Obj,Sel))Message)(sender,sel_registerName("tag"));
    B on=BoolProp(sender,"isOn");
    SetDefault(tag==1 ? ShortKey : MallKey,on);
    RefreshTabBars();
    Obj record=O0(Lookup("NSMutableDictionary"),"dictionary");
    Put(record,"event",Text("bottomEntryToggle174"));
    Put(record,"entry",Text(tag==1 ? "shortSentences" : "mall"));
    Put(record,"enabled",BoolBox(on));
    FQDRecord("bottomEntryToggle174",record);
}
static Obj ToggleObserver(void) {
    Obj cls=Lookup("FanqieXBottomToggles174");
    if (cls) return cls;
    cls=AllocateClass(Lookup("NSObject"),"FanqieXBottomToggles174",0);
    if (!cls) return 0;
    class_addMethod(cls,sel_registerName("fqx174_toggle:"),(Imp)ToggleChanged,"v24@0:8@16");
    RegisterClass(cls);
    return cls;
}
static Obj ToggleRow(Obj container,double y,const char *title,I tag,B on,Obj observer) {
    Rect bounds=Bounds(container);
    double width=bounds.width>0 ? bounds.width : 320;
    Obj label=O0(O0(Lookup("UILabel"),"alloc"),"init");
    if (!label) return 0;
    Rect labelFrame={16,y,width-96,30};
    ((void(*)(Obj,Sel,Rect))Message)(label,sel_registerName("setFrame:"),labelFrame);
    V1(label,"setText:",Text(title));
    V1(label,"setFont:",((Obj(*)(Obj,Sel,double))Message)(Lookup("UIFont"),sel_registerName("systemFontOfSize:"),15));
    V1(label,"setTextColor:",O0(Lookup("UIColor"),"labelColor"));
    Q1(label,"setAutoresizingMask:",2);
    V1(container,"addSubview:",label);
    V0(label,"release");
    Obj toggle=O0(O0(Lookup("UISwitch"),"alloc"),"init");
    if (!toggle) return 0;
    Rect switchFrame={width-80,y+2,64,31};
    ((void(*)(Obj,Sel,Rect))Message)(toggle,sel_registerName("setFrame:"),switchFrame);
    Q1(toggle,"setTag:",tag);
    Q1(toggle,"setAutoresizingMask:",1|16);
    ((void(*)(Obj,Sel,B,B))Message)(toggle,sel_registerName("setOn:animated:"),on,0);
    ((void(*)(Obj,Sel,Obj,Sel,U))Message)(toggle,sel_registerName("addTarget:action:forControlEvents:"),
        observer,sel_registerName("fqx174_toggle:"),4096);
    V1(container,"addSubview:",toggle);
    return toggle;
}
static Obj FindTable(Obj view,int depth) {
    if (!view) return 0;
    if (Kind(view,"UITableView")) return view;
    if (depth<=0) return 0;
    Obj children=Get(view,"subviews");
    U count=((U(*)(Obj,Sel))Message)(children,sel_registerName("count"));
    if (count>64) count=64;
    for (U i=0;i<count;++i) {
        Obj found=FindTable(At(children,i),depth-1);
        if (found) return found;
    }
    return 0;
}
static void InstallOptionsToggles(Obj controller) {
    Obj shortSwitch=objc_getAssociatedObject(controller,ToggleShortKey);
    Obj mallSwitch=objc_getAssociatedObject(controller,ToggleMallKey);
    if (shortSwitch) {
        ((void(*)(Obj,Sel,B,B))Message)(shortSwitch,sel_registerName("setOn:animated:"),ShortEnabled(),0);
        ((void(*)(Obj,Sel,B,B))Message)(mallSwitch,sel_registerName("setOn:animated:"),MallEnabled(),0);
        return;
    }
    Obj table=FindTable(Get(controller,"view"),5);
    if (!table || Get(table,"tableHeaderView")) return;
    Obj observerClass=ToggleObserver();
    if (!observerClass) return;
    Obj observer=O0(O0(observerClass,"alloc"),"init");
    if (!observer) return;
    Obj container=O0(O0(Lookup("UIView"),"alloc"),"init");
    if (!container) { V0(observer,"release"); return; }
    Rect frame={0,0,Bounds(table).width,96};
    ((void(*)(Obj,Sel,Rect))Message)(container,sel_registerName("setFrame:"),frame);
    V1(container,"setBackgroundColor:",O0(Lookup("UIColor"),"clearColor"));
    shortSwitch=ToggleRow(container,8,"底栏显示：短句",1,ShortEnabled(),observer);
    mallSwitch=ToggleRow(container,50,"底栏显示：商城",2,MallEnabled(),observer);
    if (!shortSwitch || !mallSwitch) {
        V0(container,"release"); V0(observer,"release"); return;
    }
    objc_setAssociatedObject(controller,ToggleObserverKey,observer,1);
    objc_setAssociatedObject(controller,ToggleShortKey,shortSwitch,1);
    objc_setAssociatedObject(controller,ToggleMallKey,mallSwitch,1);
    objc_setAssociatedObject(controller,OptionsMarkKey,container,1);
    V1(table,"setTableHeaderView:",container);
    V0(container,"release");
    V0(observer,"release");
}
static void OptionsAppear(Obj self,Sel cmd,B animated) {
    ((void(*)(Obj,Sel,B))Original("FanqieAdBlockOptionsController","fqx174_originalOptionsAppear:"))(self,cmd,animated);
    InstallOptionsToggles(self);
}
static void HookOrAdd(const char *name,const char *selector,const char *alias,const char *type,Imp imp) {
    Hook(name,selector,alias,type,imp);
    Obj cls=Lookup(name);
    if (!cls || class_getInstanceMethod(cls,sel_registerName(alias))) return;
    Method method=class_getInstanceMethod(cls,sel_registerName(selector));
    if (!method) return;
    if (class_addMethod(cls,sel_registerName(alias),method_getImplementation(method),type))
        class_addMethod(cls,sel_registerName(selector),imp,type);
}
void FQHPageStyle(Obj view) { PageStyle(view,"readerBottom"); }
void FQHPageTint(Obj view,B selected) { ShelfTabStyle(view,Get(view,"cellModel"),selected); }
void FQHPageInstall(void) {
    Hook("FQReaderSaaSBottomToolView","layoutSubviews","fqx175_originalBottom","v16@0:8",(Imp)PageBottomLayout);
    Hook("FQReaderSaaSNewProgressView","layoutSubviews","fqx174_originalProgress","v16@0:8",(Imp)PageProgressLayout);
    Hook("SSReaderBottomToolDivertView","layoutSubviews","fqx175_originalDivert","v16@0:8",(Imp)PageDivertLayout);
    Hook("SSReaderGiftView","layoutSubviews","fqx174_originalGift","v16@0:8",(Imp)PageGiftLayout);
    Hook("SSReaderBookEndUserGiftView","layoutSubviews","fqx174_originalBookGift","v16@0:8",(Imp)PageBookGiftLayout);
    Hook("SSReaderChapterEndDiscussionEntranceView","layoutSubviews","fqx174_originalDiscuss","v16@0:8",(Imp)PageDiscussLayout);
    Hook("SSReaderChapterEndDiscussionEntranceButton","layoutSubviews","fqx174_originalDiscussButton","v16@0:8",(Imp)PageDiscussButtonLayout);
    Hook("SSBookShelfTabSelectViewTitleCell","layoutSubviews","fqx174_originalShelfCategory","v16@0:8",(Imp)PageShelfTabLayout);
    Hook("SSBookShelfTabSelectViewTitleCell","reloadData:","fqx175_originalShelfTabReload:","v24@0:8@16",(Imp)PageShelfTabReload);
    Hook("SSBookShelfFilter541Cell","layoutSubviews","fqx175_originalShelfFilterLayout","v16@0:8",(Imp)PageShelfFilterLayout);
    Hook("SSBookShelfFilter541Cell","updateAppearance:","fqx175_originalShelfFilterAppearance:","v20@0:8B16",(Imp)PageShelfFilterAppearance);
    Hook("SSBookShelfFilter541Cell","updateCellBgColor:","fqx175_originalShelfFilterBackground:","v24@0:8@16",(Imp)PageShelfFilterBackground);
    Hook("SSMyUserBar","layoutSubviews","fqx174_originalProfileBar","v16@0:8",(Imp)PageProfileBarLayout);
    Hook("SSMyUserCollectionViewFunCell","layoutSubviews","fqx174_originalProfileEntry","v16@0:8",(Imp)PageProfileEntryLayout);
    Hook("SSMyUser621FunctionEntryItemCell","layoutSubviews","fqx174_originalProfileEntry621","v16@0:8",(Imp)PageProfileEntry621Layout);
    Hook("SSMyUser621BaseViewController","setupCellMiniGameEntranceData","fqx174_originalMiniGameSetup","v16@0:8",(Imp)MiniGameSetup);
    Hook("SSTabBar","setItems:","fqx174_originalTabItems","v24@0:8@16",(Imp)TabSetItems);
    Hook("SSTabBar","setItems:animated:","fqx174_originalTabItemsAnimated","v28@0:8@16B24",(Imp)TabSetItemsAnimated);
    HookOrAdd("FanqieAdBlockOptionsController","viewDidAppear:","fqx174_originalOptionsAppear:","v20@0:8B16",(Imp)OptionsAppear);
}

void FQHInstall(void) {
    if (!FQHGlassAvailable()) return;
    Hook("SSReaderFloatingCommonButton","layoutSubviews","fqx171_originalLayout","v16@0:8",(Imp)ListenLayout);
    Hook("FQReaderSaaSReaderSpeechButton","layoutSubviews","fqx175_originalSpeechLayout","v16@0:8",(Imp)SpeechLayout);
    Hook("FQReaderSaaSReaderSpeechButton","readerInsertedViewBackgroundConfigChange:","fqx175_originalSpeechTheme:","v24@0:8@16",(Imp)SpeechTheme);
    Hook("SSBookStoreNewViewController","relayout","fqx165_originalRelayout","v16@0:8",(Imp)HomeLayout);
    Hook("SSBookStoreNewViewController","viewDidAppear:","fqx165_originalAppear:","v20@0:8B16",(Imp)HomeAppear);
    // This is the right-hand category ENTRY, not the horizontal category tabs.
    Hook("SSBookStoreCategorySignView","layoutSubviews","fqx173_originalLayout","v16@0:8",(Imp)CategoryLayout);
    Hook("SSBookStoreCategorySignView","resetColorWithRatio:fromTab:toTab:fromTabTemplate:toTabTemplate:","fqx173_originalColor:from:to:fromTemplate:toTemplate:","v40@0:8d16i24i28i32i36",(Imp)CategoryColor);
    Hook("SSBookStoreSearchBarComponent","resetTopTabSearchViewWithRatio:fromTab:toTab:fromTabTemplate:toTabTemplate:","fqx173_originalSearchColor:from:to:fromTemplate:toTemplate:","v40@0:8d16i24i28i32i36",(Imp)SearchColor);
    Hook("FQReaderSaaSBaseButton","layoutSubviews","fqx170_originalLayout","v16@0:8",(Imp)ShelfButtonLayout);
    Hook("SSBookShelfSubViewController","viewDidLayoutSubviews","fqx167_originalShelfLayout","v16@0:8",(Imp)ShelfLayout);
    Hook("FQReaderSaasNavigationView","layoutSubviews","fqx167_originalLayout","v16@0:8",(Imp)ReaderLayout);
    Hook("FQReaderSaasNavigationView","readerInsertedViewThemeConfigChange:","fqx167_originalTheme:","v24@0:8@16",(Imp)ReaderTheme);
}
