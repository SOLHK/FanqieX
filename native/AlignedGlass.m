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
typedef struct { double x, y; } Point;
extern void Message(void) __asm__("_objc_msgSend");
extern Obj Lookup(const char *) __asm__("_objc_getClass");
extern Sel sel_registerName(const char *);
extern Method class_getInstanceMethod(Obj, Sel);
extern Obj object_getClass(Obj);
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
static void ReaderDownloadLabelKey(void) {}
static void ReaderShelfLabelKey(void) {}
static void ReaderShelfStockFrameKey(void) {}
static void ReaderShelfStyledFrameKey(void) {}
static void IconGlassKey(void) {}
static void IconRectKey(void) {}
static void ShelfRoleKey(void) {}
static void GlyphOriginalKey(void) {}
static void GlyphAppliedKey(void) {}
static void GlyphViewKey(void) {}
static void GlassPreferenceKey(void) {}
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
static B ClassABI(Obj cls,const char *sel,const char *expected) {
    Method m=class_getInstanceMethod(cls,sel_registerName(sel));
    if (!m) return 0;
    const char *type=method_getTypeEncoding(m);
    if (!type) return 0;
    while (*expected && *type==*expected) { ++type; ++expected; }
    return *type==0 && *expected==0;
}
static B Signature(const char *cls,const char *sel,const char *expected) {
    return ClassABI(Lookup(cls),sel,expected);
}
static B InstanceABI(Obj object,const char *sel,const char *expected) {
    return ClassABI(object_getClass(object),sel,expected);
}

B FQHHostBundle(void) {
    Obj pool=objc_autoreleasePoolPush();
    Obj bundle=O0(Lookup("NSBundle"),"mainBundle");
    B matches=Equal(O0(bundle,"bundleIdentifier"),"com.dragon.read");
    objc_autoreleasePoolPop(pool);
    return matches;
}

// Kept for historical build profiles. Current installers validate each feature.
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
    Obj key=objc_getAssociatedObject(defaults,GlassPreferenceKey);
    if (!key) {
        key=Text("FanqieAdBlock.GlassDisabled.1");
        objc_setAssociatedObject(defaults,GlassPreferenceKey,key,1);
    }
    return !((I(*)(Obj,Sel,Obj))Message)(defaults,sel_registerName("integerForKey:"),key);
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
static void PrepareHeaderOwner(Obj view,B clips,B opaque,double current,double wanted) {
    Obj applied=objc_getAssociatedObject(view,HeaderAppliedRadiusKey);
    double previous=applied ? Double(applied) : 0;
    if (!objc_getAssociatedObject(view,HeaderClipsKey) || !clips)
        objc_setAssociatedObject(view,HeaderClipsKey,BoolBox(clips),1);
    if (!objc_getAssociatedObject(view,HeaderOpaqueKey) || opaque)
        objc_setAssociatedObject(view,HeaderOpaqueKey,BoolBox(opaque),1);
    if (!applied || current!=previous)
        objc_setAssociatedObject(view,HeaderRadiusKey,Number(current),1);
    if (current!=wanted) SetRadius(view,wanted);
    if (!applied || previous!=wanted)
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
static void PrepareOwner(Obj view,B clips,B opaque) {
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
static B SameColor(Obj first,Obj second) {
    return first==second || ((B(*)(Obj,Sel,Obj))Message)(first,sel_registerName("isEqual:"),second);
}
static void Restore(Obj view,Obj surface) {
    if (!surface) { RestoreHeaderOwner(view); RestoreOwner(view); return; }
    if (objc_getAssociatedObject(view,ClipsKey) || objc_getAssociatedObject(view,HeaderClipsKey)) {
        Obj clear=O0(Lookup("UIColor"),"clearColor");
        Obj current=O0(view,"backgroundColor");
        if (SameColor(current,clear))
            V1(view,"setBackgroundColor:",objc_getAssociatedObject(view,BackgroundKey));
    }
    V0(surface,"removeFromSuperview");
    objc_setAssociatedObject(view,SurfaceKey,0,1);
    objc_setAssociatedObject(view,BackgroundKey,0,1);
    RestoreHeaderOwner(view); RestoreOwner(view);
}
static Obj NewGlassSurface(void) {
    Obj effect=((Obj(*)(Obj,Sel,I))Message)(Lookup("UIGlassEffect"),sel_registerName("effectWithStyle:"),0);
    if (!effect) return 0;
    VB(effect,"setInteractive:",1);
    Obj surface=O1(O0(Lookup("UIVisualEffectView"),"alloc"),"initWithEffect:",effect);
    if (!surface) return 0;
    V1(surface,"setCornerConfiguration:",O0(Lookup("UICornerConfiguration"),"capsuleConfiguration"));
    VB(surface,"setUserInteractionEnabled:",0);
    VB(surface,"setAccessibilityElementsHidden:",1);
    VB(surface,"setIsAccessibilityElement:",0);
    VB(surface,"setOpaque:",0);
    return surface;
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
    B fresh=surface==0;
    if (fresh) {
        surface=NewGlassSurface();
        if (!surface) { objc_setAssociatedObject(view,BusyKey,0,0); return; }
        Q1(surface,"setAutoresizingMask:",18); // flexible width + height
        objc_setAssociatedObject(view,SurfaceKey,surface,1);
        V0(surface,"release");
    }
    Obj clear=O0(Lookup("UIColor"),"clearColor");
    Obj content=O0(surface,"contentView");
    B attach=O0(surface,"superview")!=view;
    Rect placed=((Rect(*)(Obj,Sel))Message)(surface,sel_registerName("frame"));
    B move=placed.x!=material.x || placed.y!=material.y || placed.width!=material.width || placed.height!=material.height;
    B clearSurface=!SameColor(O0(surface,"backgroundColor"),clear);
    B clearContent=!SameColor(O0(content,"backgroundColor"),clear);
    Obj current=0;
    B header=0,clips=0,opaque=0,clearOwner=0;
    double radius=0,wanted=0;
    if (!preserveOwner) {
        current=O0(view,"backgroundColor");
        clearOwner=!SameColor(current,clear);
        clips=Flag(view,"clipsToBounds"); opaque=Flag(view,"isOpaque");
        header=objc_getAssociatedObject(view,HeaderKey)!=0;
        if (header) {
            radius=Radius(view);
            wanted=(material.width<material.height ? material.width : material.height)*0.5;
        }
    }
    Obj transaction=0;
    if (attach || move || clearSurface || clearContent || clearOwner || opaque || clips!=header || radius!=wanted) {
        transaction=Lookup("CATransaction");
        V0(transaction,"begin"); VB(transaction,"setDisableActions:",1);
    }
    if (!preserveOwner) {
        // A host theme update owns the latest restoration color.
        if (fresh || clearOwner) objc_setAssociatedObject(view,BackgroundKey,current,1);
        if (header) PrepareHeaderOwner(view,clips,opaque,radius,wanted);
        else PrepareOwner(view,clips,opaque);
        if (clearOwner) V1(view,"setBackgroundColor:",clear);
    }
    if (move) ((void(*)(Obj,Sel,Rect))Message)(surface,sel_registerName("setFrame:"),material);
    if (clearSurface) V1(surface,"setBackgroundColor:",clear);
    if (clearContent) V1(content,"setBackgroundColor:",clear);
    if (attach)
        ((void(*)(Obj,Sel,Obj,I))Message)(view,sel_registerName("insertSubview:atIndex:"),surface,0);
    if (transaction) V0(transaction,"commit");
    objc_setAssociatedObject(view,BusyKey,0,0);
}
void FQHApply(Obj view) {
    if (Kind(view,"UIView"))
        ApplySurface(view,((Rect(*)(Obj,Sel))Message)(view,sel_registerName("bounds")),0);
}
void FQHHeader(Obj view) {
    if (!Kind(view,"UIView")) return;
    if (!objc_getAssociatedObject(view,HeaderKey))
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
static inline __attribute__((always_inline)) B Belongs(Obj view,Obj owner) {
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
    Obj holder=O0(glass,"superview");
    if (holder!=view) material=Convert(holder,material,view);
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
static void RestoreReaderShelfFrame(Obj label) {
    Obj styled=objc_getAssociatedObject(label,ReaderShelfStyledFrameKey);
    if (!styled) return;
    if (SameRect(Frame(label),UnboxRect(styled)))
        SetFrame(label,UnboxRect(objc_getAssociatedObject(label,ReaderShelfStockFrameKey)));
    objc_setAssociatedObject(label,ReaderShelfStockFrameKey,0,1);
    objc_setAssociatedObject(label,ReaderShelfStyledFrameKey,0,1);
}
static void RestoreIcon(Obj view,Obj glass) {
    RestoreReaderShelfFrame(view);
    RestoreGlyph(view);
    if (glass) { ObservePress(view,glass,0); V0(glass,"removeFromSuperview"); }
    objc_setAssociatedObject(view,IconGlassKey,0,1);
    objc_setAssociatedObject(view,IconRectKey,0,1);
    objc_setAssociatedObject(view,LayoutKey,0,1);
    objc_setAssociatedObject(view,LayoutTimeKey,0,1);
    RestoreHit(view); RestoreOwner(view);
}
static Rect ReaderShelfMaterial(Obj label,Obj holder,Rect bounds) {
    Rect current=Frame(label);
    Obj stockValue=objc_getAssociatedObject(label,ReaderShelfStockFrameKey);
    Obj styledValue=objc_getAssociatedObject(label,ReaderShelfStyledFrameKey);
    B unchanged=styledValue && SameRect(current,UnboxRect(styledValue));
    Rect stock=unchanged ? UnboxRect(stockValue) : current;
    Obj nav=Kind(holder,"FQReaderSaasNavigationView") ? holder : O0(holder,"superview");
    double shift=0;
    if (Kind(nav,"FQReaderSaasNavigationView")) {
        Rect row=Convert(holder,stock,nav);
        double left=Bounds(nav).x+8,centerY=row.y+row.height*0.5;
        Obj children=O0(nav,"subviews"),bg=Get(nav,"bgView"),glass=FQHIconGlass(label);
        U count=((U(*)(Obj,Sel))Message)(children,sel_registerName("count"));
        for (U i=0;i<count;++i) {
            Obj child=At(children,i);
            if (child==holder || child==label || child==glass || child==bg || Flag(child,"isHidden")) continue;
            Rect r=Frame(child);
            if (r.x>=row.x || r.y>=centerY+18 || r.y+r.height<=centerY-18) continue;
            Obj otherGlass=FQHIconGlass(child);
            double right=r.x+r.width;
            if (O0(otherGlass,"superview")==child) {
                Rect material=Convert(child,Frame(otherGlass),nav);
                if (material.x+material.width>right) right=material.x+material.width;
            }
            if (right+8>left) left=right+8;
        }
        double extra=row.x-6-left;
        if (extra>0) shift=extra<12 ? extra*0.5 : 6;
    }
    // Expand only to the left of the stock pill. Move the label by half the
    // added width so it stays centered and the existing download gap survives.
    Rect wanted=stock;
    wanted.x-=shift;
    if (!SameRect(current,wanted)) SetFrame(label,wanted);
    if (shift>0) {
        if (!unchanged) objc_setAssociatedObject(label,ReaderShelfStockFrameKey,RectBox(stock),1);
        if (!unchanged || !SameRect(current,wanted))
            objc_setAssociatedObject(label,ReaderShelfStyledFrameKey,RectBox(wanted),1);
    } else if (styledValue) {
        objc_setAssociatedObject(label,ReaderShelfStockFrameKey,0,1);
        objc_setAssociatedObject(label,ReaderShelfStyledFrameKey,0,1);
    }
    return (Rect){bounds.x-6-shift,bounds.y+(bounds.height-36)*0.5,bounds.width+12+2*shift,36};
}
typedef enum { IconNone, IconGeneric, IconReaderBack, IconReaderMore, IconReaderSearch,
    IconReaderDownload, IconReaderCommunity, IconReaderChapter, IconReaderShelf, IconShelfSearch, IconShelfMore } IconRole;
static const char *IconRoleName(IconRole role) {
    switch (role) {
        case IconReaderBack: return "readerBack";
        case IconReaderMore: return "readerMore";
        case IconReaderSearch: return "readerSearch";
        case IconReaderDownload: return "readerDownload";
        case IconReaderCommunity: return "readerCommunity";
        case IconReaderChapter: return "readerChapter";
        case IconReaderShelf: return "readerShelf";
        case IconShelfSearch: return "shelfSearch";
        case IconShelfMore: return "shelfMore";
        default: return "icon";
    }
}
static void Icon(Obj view,IconRole role) {
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
    B back=role==IconReaderBack;
    B shelf=role==IconShelfSearch || role==IconShelfMore;
    if ((back || shelf) && glyph) {
        B newGlyph=objc_getAssociatedObject(view,GlyphViewKey)!=glyph;
        if (newGlyph) RestoreGlyph(view);
        Rect current=Frame(glyph);
        Obj old=objc_getAssociatedObject(glyph,GlyphOriginalKey);
        Obj applied=objc_getAssociatedObject(glyph,GlyphAppliedKey);
        Rect previous=applied ? UnboxRect(applied) : (Rect){0,0,0,0};
        if (!old || !applied || !SameRect(current,previous)) {
            old=RectBox(current);objc_setAssociatedObject(glyph,GlyphOriginalKey,old,1);
        }
        Rect base=UnboxRect(old),adjusted=base;
        if (back) adjusted.x+=base.width*0.5;
        else {
            adjusted.width=base.width*0.75;adjusted.height=base.height*0.75;
            adjusted.x+=base.width*0.125;adjusted.y+=base.height*0.125;
            if (role==IconShelfSearch) adjusted.x-=12;
            if (role==IconShelfMore) adjusted.x-=base.width*0.25;
        }
        if (!SameRect(current,adjusted)) SetFrame(glyph,adjusted);
        if (!applied || !SameRect(previous,adjusted)) objc_setAssociatedObject(glyph,GlyphAppliedKey,RectBox(adjusted),1);
        if (newGlyph) objc_setAssociatedObject(view,GlyphViewKey,glyph,1);
    }
    double diameter=shelf ? 28 : 36;
    double centerX=bounds.x+bounds.width*0.5+(back ? 6 : 0)-(role==IconShelfSearch ? 12 : 0);
    Rect material={centerX-diameter*0.5,bounds.y+bounds.height*0.5-diameter*0.5,diameter,diameter};
    B readerText=(role==IconReaderDownload || role==IconReaderShelf) && Kind(view,"UILabel");
    Obj holder=readerText ? O0(view,"superview") : view;
    if (!holder || !CanExpandHit(view) || (readerText && Flag(view,"isHidden"))) {
        RestoreIcon(view,glass); objc_setAssociatedObject(view,BusyKey,0,0); return;
    }
    if (readerText) {
        // The label draws its text in its own layer. A child glass would cover it.
        material=(Rect){bounds.x-6,bounds.y-5,bounds.width+12,bounds.height+10};
    } else if (role==IconReaderChapter) {
        double height=bounds.height+6>30 ? bounds.height+6 : 30;
        material=(Rect){bounds.x-6,bounds.y+(bounds.height-height)*0.5,bounds.width+12,height};
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
    if (readerText && role==IconReaderShelf) material=ReaderShelfMaterial(view,holder,bounds);
    Rect placed=readerText ? Convert(view,material,holder) : material;
    Obj lastRect=objc_getAssociatedObject(view,IconRectKey);
    // Compare the requested layout, not UIKit's transient pressed geometry.
    B move=!lastRect || !SameRect(UnboxRect(lastRect),placed);
    B attach=O0(glass,"superview")!=holder;
    B clips=!readerText && Flag(view,"clipsToBounds"),opaque=!readerText && Flag(view,"isOpaque");
    B changeEnabled=0,changeSelected=0,changeHighlighted=0;
    B enabled=0,selected=0,highlighted=0;
    if (Kind(view,"UIControl")) {
        enabled=Flag(view,"isEnabled"); selected=Flag(view,"isSelected"); highlighted=Flag(view,"isHighlighted");
        changeEnabled=Flag(glass,"isEnabled")!=enabled;
        changeSelected=Flag(glass,"isSelected")!=selected;
        changeHighlighted=Flag(glass,"isHighlighted")!=highlighted;
    }
    Obj transaction=0;
    if (move || attach || clips || opaque || changeEnabled || changeSelected || changeHighlighted) {
        transaction=Lookup("CATransaction");
        V0(transaction,"begin");VB(transaction,"setDisableActions:",1);
    }
    if (!readerText) PrepareOwner(view,clips,opaque);
    if (move) {
        SetFrame(glass,placed);
        objc_setAssociatedObject(view,IconRectKey,RectBox(placed),1);
    }
    if (attach) {
        if (readerText)
            ((void(*)(Obj,Sel,Obj,Obj))Message)(holder,sel_registerName("insertSubview:belowSubview:"),glass,view);
        else
            ((void(*)(Obj,Sel,Obj,I))Message)(holder,sel_registerName("insertSubview:atIndex:"),glass,0);
    }
    if (changeEnabled) VB(glass,"setEnabled:",enabled);
    if (changeSelected) VB(glass,"setSelected:",selected);
    if (changeHighlighted) VB(glass,"setHighlighted:",highlighted);
    EnsureHit(view,material);
    if (transaction) V0(transaction,"commit");
    RecordLayout(view,glass,image,IconRoleName(role));
    objc_setAssociatedObject(view,BusyKey,0,0);
}
void FQHButton(Obj view) { Icon(view,IconGeneric); }
static void IncludeMaterial(Obj glass,Obj parent,Rect *area) {
    Obj holder=O0(glass,"superview");
    if (!Belongs(holder,parent)) return;
    Rect r=Convert(holder,Frame(glass),parent);
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
static IconRole InsertRole(Obj obj) {
    if (Kind(obj,"FQReaderNavigationBarMoreBtnInsertObject")) return IconReaderMore;
    if (Kind(obj,"FQReaderNavigationBarSearchBtnInsertObject")) return IconReaderSearch;
    if (Kind(obj,"SSReaderNavigationBarDownloadBtnInsertObject")) return IconReaderDownload;
    if (Kind(obj,"SSReaderNavigationBarBookShelfBtnInsertObject")) return IconReaderShelf;
    if (Kind(obj,"SSReaderNavigationBarCommunitySwitchBtnInsertObject")) return IconReaderCommunity;
    return IconNone;
}
static void TrackReaderLabel(Obj owner,const void *key,Obj label) {
    Obj previous=objc_getAssociatedObject(owner,key);
    if (previous==label) return;
    if (previous) RestoreIcon(previous,FQHIconGlass(previous));
    objc_setAssociatedObject(owner,key,label,1);
}
void FQHReader(Obj owner) {
    if (objc_getAssociatedObject(owner,OwnerBusyKey)) return;
    objc_setAssociatedObject(owner,OwnerBusyKey,owner,0);
    Rect area=Bounds(owner);
    Obj back=Get(owner,"backBtn");
    I styled=0;
    if (Belongs(back,owner)) { Icon(back,IconReaderBack); IncludeMaterial(FQHIconGlass(back),owner,&area); styled=FQHIconGlass(back)!=0; }
    Obj items=Get(owner,"insertObjs");
    Obj downloadLabel=0,shelfLabel=0;
    if (Kind(items,"NSArray")) {
        U count=((U(*)(Obj,Sel))Message)(items,sel_registerName("count"));
        if (count>16) count=16;
        for (U i=0;i<count;++i) {
            Obj item=At(items,i); IconRole role=InsertRole(item);
            if (role==IconNone) continue;
            Obj view=Get(item,"getInsertView");
            if (Belongs(view,owner)) {
                Icon(view,role);
                Obj glass=FQHIconGlass(view);
                IncludeMaterial(glass,owner,&area);
                styled+=glass!=0;
                if (glass && (role==IconReaderDownload || role==IconReaderShelf) && Kind(view,"UILabel")) {
                    if (role==IconReaderDownload) downloadLabel=view;
                    else shelfLabel=view;
                }
            }
        }
    }
    TrackReaderLabel(owner,ReaderDownloadLabelKey,downloadLabel);
    TrackReaderLabel(owner,ReaderShelfLabelKey,shelfLabel);
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
static void ReaderShelfWrapperLayout(Obj self,Sel cmd) {
    ((void(*)(Obj,Sel))Original("SSReaderFanClubEntryContainerView","fqx184_originalShelfWrapper"))(self,cmd);
    Obj label=Get(self,"contentView");
    // The same wrapper can display the fan-club entry instead of the shelf label.
    if (!Kind(O0(self,"superview"),"FQReaderSaasNavigationView") || !Kind(label,"UILabel") || O0(label,"superview")!=self)
        label=0;
    if (label) Icon(label,IconReaderShelf);
    Obj glass=FQHIconGlass(label);
    TrackReaderLabel(self,ReaderShelfLabelKey,glass ? label : (Obj)0);
    if (glass) {
        PrepareOwner(self,Flag(self,"clipsToBounds"),Flag(self,"isOpaque"));
        EnsureHit(self,Frame(glass));
    } else { RestoreOwner(self); RestoreHit(self); }
}
static Obj ShelfEditPlacement(Obj controller,Obj holder);
static void ShelfTopHit(Obj holder,Obj search,Obj more,Obj edit) {
    Rect area=Bounds(holder);
    Obj searchGlass=FQHIconGlass(search),moreGlass=FQHIconGlass(more);
    IncludeMaterial(searchGlass,holder,&area);
    IncludeMaterial(moreGlass,holder,&area);
    IncludeMaterial(edit,holder,&area);
    if (searchGlass || moreGlass || edit) EnsureHit(holder,area); else RestoreHit(holder);
}
void FQHShelf(Obj self) {
    if (objc_getAssociatedObject(self,OwnerBusyKey)) return;
    objc_setAssociatedObject(self,OwnerBusyKey,self,0);
    Obj search=Get(self,"searchButton"),more=Get(self,"moreButton"),parent=Get(self,"searchAndMoreView");
    Obj searchRole=objc_getAssociatedObject(search,ShelfRoleKey),moreRole=objc_getAssociatedObject(more,ShelfRoleKey);
    if (search && (!searchRole || !Flag(searchRole,"boolValue"))) objc_setAssociatedObject(search,ShelfRoleKey,BoolBox(1),1);
    if (more && (!moreRole || Flag(moreRole,"boolValue"))) objc_setAssociatedObject(more,ShelfRoleKey,BoolBox(0),1);
    Icon(search,IconShelfSearch);Icon(more,IconShelfMore);
    if (Kind(parent,"UIView")) ShelfTopHit(parent,search,more,ShelfEditPlacement(self,parent));
    objc_setAssociatedObject(self,OwnerBusyKey,0,0);
}
static void ShelfLayout(Obj self,Sel cmd) {
    ((void(*)(Obj,Sel))Original("SSBookShelfSubViewController","fqx167_originalShelfLayout"))(self,cmd);
    FQHShelf(self);
}
static void ShelfButtonLayout(Obj self,Sel cmd) {
    ((void(*)(Obj,Sel))Original("FQReaderSaaSBaseButton","fqx170_originalLayout"))(self,cmd);
    Obj role=objc_getAssociatedObject(self,ShelfRoleKey);
    if (role) Icon(self,Flag(role,"boolValue") ? IconShelfSearch : IconShelfMore);
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
static void PageTintKey(void) {}
static void ToggleObserverKey(void) {}
static void TabRecoveryKey(void) {}
static void RecoveryBarKey(void) {}
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
static int ReaderBottomType(Obj view) {
    Obj item=Get(view,"item");
    if (!Kind(item,"FQReaderSaaSBottomToolItem") || !InstanceABI(item,"type","i16@0:8")) return 0;
    // FQReaderUIManager.tabbarItems uses 1 for catalog, 2 for day/night and 3 for settings.
    return ((int(*)(Obj,Sel))Message)(item,sel_registerName("type"));
}
static B ReaderBottomItem(Obj view) {
    int type=ReaderBottomType(view);
    return type>=1 && type<=3;
}
static B ReaderBottomBackgroundEnabled(void);
static void ReaderBackdropAppliedKey(void) {}
static void ReaderBackdropColorKey(void) {}
static void ReaderBackdropAlphaKey(void) {}
static B ReaderBackdropFill(Obj view,B visible) {
    Obj original=objc_getAssociatedObject(view,ReaderBackdropColorKey);
    if (visible && !original) return 0;
    Obj current=O0(view,"backgroundColor");
    if (visible) {
        if (!current) V1(view,"setBackgroundColor:",original);
        objc_setAssociatedObject(view,ReaderBackdropColorKey,0,1);
    } else if (current) {
        objc_setAssociatedObject(view,ReaderBackdropColorKey,current,1);
        V1(view,"setBackgroundColor:",0);
    } else return 0;
    return 1;
}
static void ReaderBackdrop(Obj view,B visible) {
    if (!view) return;
    B applied=objc_getAssociatedObject(view,ReaderBackdropAppliedKey)!=0;
    if (visible && !applied) return;
    B progress=Kind(view,"FQReaderSaaSNewProgressView");
    if (!progress && !Kind(view,"FQReaderSaaSBottomToolView")) return;
    Obj parent=O0(view,"superview");
    // Both stock panels own their paint and may be backed by their dedicated
    // full-width containers. Leave the reader page and every other insert alone.
    ReaderBackdropFill(view,visible);
    if (Kind(parent,"BDReaderViewContainer") && Get(parent,"contentView")==view)
        ReaderBackdropFill(parent,visible);
    if (visible==applied) objc_setAssociatedObject(view,ReaderBackdropAppliedKey,visible ? (Obj)0 : view,0);
    Obj line=Get(view,progress ? "horizonLineView" : "lineView");
    if (O0(line,"superview")!=view) return;
    Obj original=objc_getAssociatedObject(line,ReaderBackdropAlphaKey);
    if (visible && !original) return;
    double alpha=((double(*)(Obj,Sel))Message)(line,sel_registerName("alpha"));
    if (visible) {
        if (alpha==0) ((void(*)(Obj,Sel,double))Message)(line,sel_registerName("setAlpha:"),Double(original));
        objc_setAssociatedObject(line,ReaderBackdropAlphaKey,0,1);
    } else if (alpha>0) {
        objc_setAssociatedObject(line,ReaderBackdropAlphaKey,Number(alpha),1);
        ((void(*)(Obj,Sel,double))Message)(line,sel_registerName("setAlpha:"),0);
    }
}
static B ReaderCommunityGlass(Obj item) {
    Obj title=Get(Get(item,"titleLabel"),"text");
    B matched=Equal(title,"发讨论") || Equal(title,"圈子");
    if (matched) FQHApply(item);
    else if (FQHSurface(item)) PageRestore(item);
    return matched;
}
static void ReaderCommunityBackdrop(Obj manager,B visible) {
    Obj owner=Get(manager,"bottomToolbarInsertContainer");
    if (!Kind(owner,"BDReaderViewContainer")) return;
    Obj holder=Get(owner,"contentView");
    Obj row=Get(Get(manager,"currentBottomToolbarInsertObject"),"containerView");
    Obj parent=O0(row,"superview");
    B inside=O0(holder,"superview")==owner;
    B matched=0;
    if (Kind(row,"SSReaderBottomToolbarItemContainerView") &&
        (parent==owner || (inside && parent==holder))) {
        Obj items=Get(row,"itemViews");
        U count=((U(*)(Obj,Sel))Message)(items,sel_registerName("count"));
        for (U i=0;i<count;++i) {
            Obj item=At(items,i);
            if (Kind(item,"SSReaderCommunityBottomToolbarItemView") && O0(item,"superview")==row)
                matched|=ReaderCommunityGlass(item);
        }
    }
    visible=visible || !matched || !Enabled() || !FQHGlassAvailable();
    ReaderBackdropFill(owner,visible);
    if (inside) ReaderBackdropFill(holder,visible);
    Obj line=Get(manager,"bottomToolbarInsertTopLineView");
    if (O0(line,"superview")==owner) ReaderBackdropFill(line,visible);
}
static void PageReaderCommunityLayout(Obj self,Sel cmd) {
    ((void(*)(Obj,Sel))Original("SSReaderCommunityBottomToolbarItemView","fqx181_originalReaderCommunity"))(self,cmd);
    if (Kind(O0(self,"superview"),"SSReaderBottomToolbarItemContainerView")) ReaderCommunityGlass(self);
    else if (FQHSurface(self)) PageRestore(self);
}
static void PageReaderCommunityRefresh(Obj self,Sel cmd) {
    ((void(*)(Obj,Sel))Original("FQReaderUIManager","fqx181_originalReaderCommunityRefresh"))(self,cmd);
    ReaderCommunityBackdrop(self,ReaderBottomBackgroundEnabled());
}
static void ReaderMenuBackdrop(Obj manager) {
    B visible=ReaderBottomBackgroundEnabled();
    Obj top=Get(manager,"navigationContainer");
    if (Kind(top,"BDReaderTopViewContainer") && Kind(Get(top,"contentView"),"FQReaderSaasNavigationView") &&
        InstanceABI(top,"updateGradientLayer","v16@0:8") &&
        ReaderBackdropFill(top,visible)) V0(top,"updateGradientLayer");
    ReaderBackdrop(Get(manager,"nProgressView"),visible);
    ReaderBackdrop(Get(manager,"tabBar"),visible);
    ReaderCommunityBackdrop(manager,visible);
}
static void ReaderMenuShow(Obj self,Sel cmd,B animated) {
    ((void(*)(Obj,Sel,B))Original("FQReaderUIManager","fqx180_originalReaderMenu:"))(self,cmd,animated);
    ReaderMenuBackdrop(self);
}
static void ReaderBackdropTheme(Obj self,Sel cmd,Obj config,Obj context) {
    ((void(*)(Obj,Sel,Obj,Obj))Original("FQReaderUIManager","fqx180_originalReaderTheme:context:"))(self,cmd,config,context);
    ReaderMenuBackdrop(self);
}
static void CatalogTapKey(void) {}
static B CatalogTouch(Obj self,Sel cmd,Obj recognizer,Obj touch) {
    (void)self; (void)cmd;
    Obj view=O0(recognizer,"view"),surface=FQHSurface(view);
    // Taps on the native icon or caption already have their own handlers.
    if (!surface || O0(touch,"view")!=view) return 0;
    Point p=((Point(*)(Obj,Sel,Obj))Message)(touch,sel_registerName("locationInView:"),view);
    Rect r=Frame(surface);
    double radius=r.height*0.5;
    double dx=__builtin_fabs(p.x-(r.x+r.width*0.5))-(r.width*0.5-radius);
    double dy=p.y-(r.y+radius);
    if (dx<0) dx=0;
    return dx*dx+dy*dy<=radius*radius;
}
static void CatalogTapped(Obj self,Sel cmd,Obj recognizer) {
    (void)self; (void)cmd;
    if (((I(*)(Obj,Sel))Message)(recognizer,sel_registerName("state"))!=3) return;
    Obj view=O0(recognizer,"view");
    if (FQHSurface(view) && ReaderBottomType(view)==1) V1(view,"onBtnClick:",recognizer);
}
static void UpdateCatalogTap(Obj view,B needed) {
    Obj gesture=objc_getAssociatedObject(view,CatalogTapKey);
    if (gesture && !needed) {
        V1(view,"removeGestureRecognizer:",gesture);
        objc_setAssociatedObject(view,CatalogTapKey,0,1);
    }
    if (gesture || !needed || !InstanceABI(view,"onBtnClick:","v24@0:8@16")) return;
    Obj cls=Lookup("FQXReaderCatalogTap");
    if (!cls) {
        cls=AllocateClass(Lookup("NSObject"),"FQXReaderCatalogTap",0);
        if (!cls) return;
        class_addMethod(cls,sel_registerName("fqx_catalogTapped:"),(Imp)CatalogTapped,"v24@0:8@16");
        class_addMethod(cls,sel_registerName("gestureRecognizer:shouldReceiveTouch:"),(Imp)CatalogTouch,"B32@0:8@16@24");
        RegisterClass(cls);
    }
    Obj observer=O0(cls,"new");
    gesture=((Obj(*)(Obj,Sel,Obj,Sel))Message)(O0(Lookup("UITapGestureRecognizer"),"alloc"),
        sel_registerName("initWithTarget:action:"),observer,sel_registerName("fqx_catalogTapped:"));
    V1(gesture,"setDelegate:",observer);
    VB(gesture,"setCancelsTouchesInView:",0);
    objc_setAssociatedObject(gesture,CatalogTapKey,observer,1);
    objc_setAssociatedObject(view,CatalogTapKey,gesture,1);
    V1(view,"addGestureRecognizer:",gesture);
    V0(gesture,"release");
    V0(observer,"release");
}
static double ReaderDivertWidth(Obj view,Obj toolbar,Rect bounds) {
    if (!InstanceABI(view,"titleLabel","@16@0:8")) return 64;
    Obj label=O0(view,"titleLabel");
    if (!Kind(label,"UILabel") || O0(label,"superview")!=view) return 64;
    Rect caption=Frame(label);
    if (!VisibleRect(caption)) return 64;
    double center=bounds.x+bounds.width*0.5;
    double left=center-caption.x,right=caption.x+caption.width-center;
    // The capsule narrows at the caption baseline. Leave room for both
    // the rounded ends and the visible padding beyond the native label.
    double half=(left>right ? left : right)+18;
    if (half<=32) return 64;

    Rect slot=Frame(view),row=Bounds(toolbar);
    center=slot.x+slot.width*0.5;
    left=center-row.x-8;
    right=row.x+row.width-center-8;
    if (left<half) half=left;
    if (right<half) half=right;
    Obj items=Get(toolbar,"itemViews");
    U count=((U(*)(Obj,Sel))Message)(items,sel_registerName("count"));
    for (U i=0;i<count && half>32;++i) {
        Obj item=At(items,i);
        if (item==view || O0(item,"superview")!=toolbar || Flag(item,"isHidden")) continue;
        Rect neighbor=Frame(item);
        double occupied=neighbor.width>64 ? neighbor.width*0.5 : 32;
        double room=__builtin_fabs(center-(neighbor.x+neighbor.width*0.5))-occupied-8;
        if (room<half) half=room;
    }
    return half>32 ? half*2 : 64;
}
static void ReaderBottomGlass(Obj view,Obj toolbar) {
    Rect bounds=Bounds(view);
    if (!VisibleRect(bounds)) { PageRestore(view); RestoreHit(view); return; }
    double width=toolbar ? ReaderDivertWidth(view,toolbar,bounds) : 64;
    Rect glass={bounds.x+(bounds.width-width)*0.5,bounds.y+(bounds.height-48)*0.5,width,48};
    ApplySurface(view,glass,0);
    Obj surface=FQHSurface(view);
    if (!surface) { RestoreHit(view); return; }
    EnsureHit(view,glass);
    RecordLayout(view,surface,bounds,"readerBottomTool");
}
// The legacy reader walker also visits the nested buttons. Only one material
// owns each target, including when the legacy callback runs before ours.
B FQHReaderOwnsControl(Obj view) {
    for (int depth=0;view && depth<4;++depth,view=Get(view,"superview")) {
        if (Kind(view,"FQReaderSaaSBottomToolItemView")) {
            Obj toolbar=Get(view,"superview");
            return Kind(toolbar,"FQReaderSaaSBottomToolView") && ReaderBottomItem(view) && FQHGlassAvailable();
        }
        if (Kind(view,"FQReaderSaaSReaderSpeechButton")) return FQHGlassAvailable();
    }
    return 0;
}
static void PageBottomLayout(Obj self,Sel cmd) {
    ((void(*)(Obj,Sel))Original("FQReaderSaaSBottomToolView","fqx175_originalBottom"))(self,cmd);
    ReaderBackdrop(self,ReaderBottomBackgroundEnabled());
    Obj items=Get(self,"itemViews");
    U count=((U(*)(Obj,Sel))Message)(items,sel_registerName("count"));
    Rect area=Bounds(self);
    Obj catalog=0;
    for (U i=0;i<count;++i) {
        Obj view=At(items,i);
        if (!Kind(view,"FQReaderSaaSBottomToolItemView") || !Belongs(view,self)) continue;
        int type=ReaderBottomType(view);
        if (type>=1 && type<=3) ReaderBottomGlass(view,0);
        else { PageRestore(view); RestoreHit(view); }
        Obj surface=type==1 ? FQHSurface(view) : (Obj)0;
        UpdateCatalogTap(view,surface!=0);
        if (surface) { IncludeMaterial(surface,self,&area); catalog=view; }
    }
    if (catalog) EnsureHit(self,area); else RestoreHit(self);
}
static void ReaderProgressStockKey(void) {}
static void ReaderProgressColorKey(void) {}
static void ReaderProgressFill(Obj slider,B glass) {
    Obj fill=Get(slider,"progressView");
    if (!Kind(fill,"UIImageView") || O0(fill,"superview")!=slider) return;
    Obj applied=objc_getAssociatedObject(fill,ReaderProgressColorKey);
    if (!glass && !applied) return;
    Obj current=O0(fill,"backgroundColor"),stock=objc_getAssociatedObject(fill,ReaderProgressStockKey);
    if (glass && SameColor(current,applied)) return;
    if (glass && current && !SameColor(current,O0(Lookup("UIColor"),"clearColor"))) {
        if (!applied || !SameColor(current,stock)) {
            // The native theme uses the text pigment at 10% opacity. Keep its
            // hue and raise the fill opacity slightly in both reading modes.
            applied=((Obj(*)(Obj,Sel,double))Message)(current,sel_registerName("colorWithAlphaComponent:"),0.15625);
            if (!applied) return;
            objc_setAssociatedObject(fill,ReaderProgressStockKey,current,1);
            objc_setAssociatedObject(fill,ReaderProgressColorKey,applied,1);
        }
        V1(fill,"setBackgroundColor:",applied);
    } else if (applied) {
        if (!glass && SameColor(current,applied)) V1(fill,"setBackgroundColor:",stock);
        objc_setAssociatedObject(fill,ReaderProgressStockKey,0,1);
        objc_setAssociatedObject(fill,ReaderProgressColorKey,0,1);
    }
}
static void ReaderProgressGlass(Obj owner) {
    Obj left=Get(owner,"leftBtn"),right=Get(owner,"rightBtn");
    if (Kind(left,"UIButton") && O0(left,"superview")==owner) Icon(left,IconReaderChapter);
    if (Kind(right,"UIButton") && O0(right,"superview")==owner) Icon(right,IconReaderChapter);
    Obj slider=Get(owner,"slider");
    if (!Kind(slider,"BDReaderNewSlider")) return;
    Obj track=Get(slider,"trackView");
    if (!Kind(track,"UIImageView") || O0(track,"superview")!=slider) { ReaderProgressFill(slider,0); return; }
    // Replace the full track's stock paint. The progress fill and thumb are
    // separate sibling views, and the host still owns all slider coordinates.
    FQHApply(track);
    Obj surface=FQHSurface(track);
    ReaderProgressFill(slider,surface!=0);
    if (surface) RecordLayout(track,surface,Bounds(track),"readerProgressTrack");
}
static void PageProgressLayout(Obj self,Sel cmd) {
    ((void(*)(Obj,Sel))Original("FQReaderSaaSNewProgressView","fqx174_originalProgress"))(self,cmd);
    ReaderBackdrop(self,ReaderBottomBackgroundEnabled());
    ReaderProgressGlass(self);
}
static void PageProgressTheme(Obj self,Sel cmd,Obj config) {
    ((void(*)(Obj,Sel,Obj))Original("FQReaderSaaSNewProgressView","fqx176_originalProgressTheme:"))(self,cmd,config);
    ReaderBackdrop(self,ReaderBottomBackgroundEnabled());
    ReaderProgressGlass(self);
}
static void PageDivertLayout(Obj self,Sel cmd) {
    ((void(*)(Obj,Sel))Original("SSReaderBottomToolDivertView","fqx175_originalDivert"))(self,cmd);
    Obj toolbar=O0(self,"superview");
    if (!Kind(toolbar,"FQReaderSaaSBottomToolView")) toolbar=0;
    if (toolbar || HasAncestor(self,"FQReaderSaaSBottomToolView"))
        ReaderBottomGlass(self,toolbar);
    else { PageRestore(self); RestoreHit(self); }
}
static void PageGiftLayout(Obj self,Sel cmd) {
    ((void(*)(Obj,Sel))Original("SSReaderGiftView","fqx174_originalGift"))(self,cmd);
    Obj button=Get(self,"giftButton");
    if (button) FQHApply(button); else PageRestore(self);
}
static void PageBookGiftLayout(Obj self,Sel cmd) {
    ((void(*)(Obj,Sel))Original("SSReaderBookEndUserGiftView","fqx174_originalBookGift"))(self,cmd);
    FQHApply(self);
}
static void ChapterDiscussionKey(void) {}
static B ChapterEntranceOnly(Obj card) {
    Obj model=Get(card,"model");
    return InstanceABI(model,"displayMode","q16@0:8") &&
        ((I(*)(Obj,Sel))Message)(model,sel_registerName("displayMode"))==1;
}
static void ChapterDiscussionGlass(Obj card) {
    Obj previous=objc_getAssociatedObject(card,ChapterDiscussionKey);
    Obj entry=Get(card,"activeEntranceView");
    B discussion=Kind(entry,"SSReaderChapterEndDiscussionEntranceView") &&
        ChapterEntranceOnly(card) && !Flag(entry,"isHidden");
    if (!discussion && !previous) return;
    Obj background=Get(card,"contentBackgroundView");
    if (discussion && Get(entry,"superview")==background && Get(background,"superview")==card) {
        if (FQHSurface(entry)) PageRestore(entry);
        FQHApply(background);
        // Keep the native discussion gesture and the title/count insets.
        if (FQHSurface(background)) EnsureHit(entry,Convert(background,Bounds(background),entry));
        else entry=0;
    } else {
        PageRestore(background);
        entry=0;
    }
    if (previous!=entry) {
        RestoreHit(previous);
        objc_setAssociatedObject(card,ChapterDiscussionKey,entry,1);
    }
}
static void PageChapterCardLayout(Obj self,Sel cmd) {
    ((void(*)(Obj,Sel))Original("SSReaderChapterEndCommunityCardView","fqx177_originalChapterCard"))(self,cmd);
    ChapterDiscussionGlass(self);
}
static void PageChapterCardTheme(Obj self,Sel cmd,Obj config) {
    ((void(*)(Obj,Sel,Obj))Original("SSReaderChapterEndCommunityCardView","fqx177_originalChapterCardTheme:"))(self,cmd,config);
    ChapterDiscussionGlass(self);
}
static void ChapterRewardGlass(Obj reward) {
    Obj card=Get(reward,"superview");
    Obj background=Get(reward,"customBackgroundView");
    if ((Kind(card,"SSReaderChapterEndCommunityCardView") || Kind(card,"SSReaderChapterEndCombineContainerView")) &&
        Get(background,"superview")==reward && !Flag(reward,"isHidden")) FQHApply(background);
    else if (FQHSurface(background)) PageRestore(background);
}
static void PageChapterButtonLayout(Obj self,Sel cmd) {
    ((void(*)(Obj,Sel))Original("SSReaderChapterEndBaseButton","fqx177_originalChapterButton"))(self,cmd);
    if (Kind(self,"SSReaderChapterEndRewardButton")) ChapterRewardGlass(self);
}
static void PageChapterRewardTheme(Obj self,Sel cmd,Obj config) {
    ((void(*)(Obj,Sel,Obj))Original("SSReaderChapterEndRewardButton","fqx177_originalChapterRewardTheme:"))(self,cmd,config);
    ChapterRewardGlass(self);
}
static void PageDiscussLayout(Obj self,Sel cmd) {
    ((void(*)(Obj,Sel))Original("SSReaderChapterEndDiscussionEntranceView","fqx174_originalDiscuss"))(self,cmd);
    Obj card=Get(Get(self,"superview"),"superview");
    if ((Kind(card,"SSReaderChapterEndCommunityCardView") && ChapterEntranceOnly(card)) ||
        HasAncestor(self,"SSReaderChapterEndDiscussionEntranceButton")) {
        if (FQHSurface(self)) PageRestore(self);
        return;
    }
    FQHApply(self);
}
static void PageDiscussButtonLayout(Obj self,Sel cmd) {
    ((void(*)(Obj,Sel))Original("SSReaderChapterEndDiscussionEntranceButton","fqx174_originalDiscussButton"))(self,cmd);
    if (HasAncestor(self,"SSReaderChapterEndDiscussionEntranceView")) { PageRestore(self); return; }
    FQHApply(self);
}
static void ShelfTitleHostFontKey(void) {}
static void ShelfTitleGlassFontKey(void) {}
static void ShelfTitleFont(Obj label,B styled) {
    if (!label) return;
    Obj font=O0(label,"font"),applied=objc_getAssociatedObject(label,ShelfTitleGlassFontKey);
    B hasGlassFont=applied && (font==applied ||
        ((B(*)(Obj,Sel,Obj))Message)(font,sel_registerName("isEqual:"),applied));
    if (!styled) {
        if (!applied) return;
        if (hasGlassFont) V1(label,"setFont:",objc_getAssociatedObject(label,ShelfTitleHostFontKey));
        objc_setAssociatedObject(label,ShelfTitleHostFontKey,0,1);
        objc_setAssociatedObject(label,ShelfTitleGlassFontKey,0,1);
        return;
    }
    if (!font || hasGlassFont) return;
    double size=((double(*)(Obj,Sel))Message)(font,sel_registerName("pointSize"));
    Obj smaller=((Obj(*)(Obj,Sel,double))Message)(font,sel_registerName("fontWithSize:"),size*0.875);
    if (!smaller) return;
    objc_setAssociatedObject(label,ShelfTitleHostFontKey,font,1);
    objc_setAssociatedObject(label,ShelfTitleGlassFontKey,smaller,1);
    V1(label,"setFont:",smaller);
}
static void ShelfTabStyle(Obj view,Obj model,B selected) {
    Rect bounds=Bounds(view), material=bounds;
    // The host widths follow the title's zoom. Spend only the available gap
    // on padding so a capsule cannot run into the next tab during a swipe.
    double spacing=InstanceABI(model,"cellSpacing","d16@0:8") ?
        ((double(*)(Obj,Sel))Message)(model,sel_registerName("cellSpacing")) : 0;
    double room=bounds.width+(spacing>6 ? spacing-6 : 0);
    material.width=room<42 ? room : 42;
    material.height=bounds.height-4<28 ? bounds.height-4 : 28;
    material.x+=(bounds.width-material.width)*0.5;
    material.y+=(bounds.height-material.height)*0.5;
    ApplySurface(view,material,0);
    Obj surface=FQHSurface(view);
    ShelfTint(surface,selected,0);
    // The paired mask label must match during swipes. Keep the host zoom transforms.
    ShelfTitleFont(Get(view,"titleLabel"),surface!=0);
    ShelfTitleFont(Get(view,"maskTitleLabel"),surface!=0);
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
static void ShelfActionGlass(Obj button) {
    if (!Kind(button,"UIButton")) return;
    if (Flag(button,"isHidden")) { PageRestore(button); return; }
    Rect material=Bounds(button);
    material.y+=1;
    material.height-=2;
    ApplySurface(button,material,0);
}
B FQHShelfOwnsAction(Obj button,Obj header) {
    // The inherited recursive material pass reaches these same controls first.
    // The page hook alone owns their glass, including before Edit moves upward.
    if (Kind(header,"SS525BookShelfSubHeaderView"))
        return Responds(header,"fqx177_originalDurationLayout") &&
            (Get(header,"editButton")==button || Get(header,"filterButton")==button ||
             Get(header,"fullGenreFilterButton")==button);
    return Kind(header,"SSBookShelfFilterHeaderView") && Responds(header,"fqx179_originalShelfFilterHeader") &&
        Get(header,"filterButton")==button;
}
static void ShelfFilterHeaderLayout(Obj self,Sel cmd) {
    ((void(*)(Obj,Sel))Original("SSBookShelfFilterHeaderView","fqx179_originalShelfFilterHeader"))(self,cmd);
    Obj button=Get(self,"filterButton");
    if (Belongs(button,self)) ShelfActionGlass(button);
}
static Rect ShelfInlineFilterInsets(Obj self,Sel cmd,Obj collection,Obj layout,I section) {
    Rect insets=((Rect(*)(Obj,Sel,Obj,Obj,I))Original("SSBookShelfFilterMixRowCollectionView",
        "fqx185_originalInlineFilterInsets:layout:section:"))(self,cmd,collection,layout,section);
    Obj header=Get(self,"superview");
    // The native inline row starts at 20pt. Align its cells with the upper title row.
    if (Enabled() && Kind(header,"SSBookShelfFilterHeaderView") && Get(header,"optionsView")==self)
        insets.y-=4;
    return insets;
}
static void ProfileScanKey(void) {}
static void ProfileNightKey(void) {}
static void ProfileMenuKey(void) {}
static void ProfileAnchorKey(void) {}
static void ProfileIconGlass(Obj bar,Obj icon,const void *key) {
    Obj surface=objc_getAssociatedObject(bar,key);
    Obj foreground=Kind(icon,"UIImageView") ? icon : (Obj)0;
    // An icon may be in the left stack. Insert below that stack, leaving the
    // UIImageView's own image layer and gesture target intact.
    for (int depth=0;foreground && depth<4;++depth) {
        if (Flag(foreground,"isHidden")) { foreground=0; break; }
        Obj parent=Get(foreground,"superview");
        if (parent==bar) break;
        foreground=parent;
    }
    Rect image={0};
    if (foreground && Get(foreground,"superview")==bar)
        image=Convert(icon,Bounds(icon),bar);
    if (!VisibleRect(image)) {
        V0(surface,"removeFromSuperview");
        objc_setAssociatedObject(bar,key,0,1);
        return;
    }
    Rect material={image.x+(image.width-36)*0.5,image.y+(image.height-36)*0.5,36,36};
    if (!surface) {
        surface=NewGlassSurface();
        if (!surface) return;
        objc_setAssociatedObject(bar,key,surface,1);
        V0(surface,"release");
    }
    if (!SameRect(Frame(surface),material)) SetFrame(surface,material);
    if (Get(surface,"superview")!=bar || objc_getAssociatedObject(surface,ProfileAnchorKey)!=foreground) {
        ((void(*)(Obj,Sel,Obj,Obj))Message)(bar,sel_registerName("insertSubview:belowSubview:"),surface,foreground);
        objc_setAssociatedObject(surface,ProfileAnchorKey,foreground,1);
    }
}
static void PageProfileBarLayout(Obj self,Sel cmd) {
    ((void(*)(Obj,Sel))Original("SSMyUserBar","fqx174_originalProfileBar"))(self,cmd);
    // Both native carousel variants place their outgoing and incoming labels
    // inside searchBgView. Keep the animated words clipped to that pill.
    FQHHeader(Get(self,"searchBgView"));
    B enabled=Enabled() && FQHGlassAvailable();
    ProfileIconGlass(self,enabled ? Get(self,"scanQRCodeView") : (Obj)0,ProfileScanKey);
    ProfileIconGlass(self,enabled ? Get(self,"darkModeImageView") : (Obj)0,ProfileNightKey);
    ProfileIconGlass(self,enabled ? Get(self,"sideBarButtonView") : (Obj)0,ProfileMenuKey);
}
static void ProfileCaptionKey(void) {}
static Rect ProfileStockFrame(Obj view,Rect current) {
    Obj applied=objc_getAssociatedObject(view,GlyphAppliedKey);
    return applied && SameRect(current,UnboxRect(applied)) ?
        UnboxRect(objc_getAssociatedObject(view,GlyphOriginalKey)) : current;
}
static void ProfileSetFrame(Obj view,Rect current,Rect stock,Rect target) {
    if (SameRect(current,target)) return;
    Obj original=objc_getAssociatedObject(view,GlyphOriginalKey);
    Obj applied=objc_getAssociatedObject(view,GlyphAppliedKey);
    if (!original || !SameRect(stock,UnboxRect(original)))
        objc_setAssociatedObject(view,GlyphOriginalKey,RectBox(stock),1);
    if (!applied || !SameRect(target,UnboxRect(applied)))
        objc_setAssociatedObject(view,GlyphAppliedKey,RectBox(target),1);
    SetFrame(view,target);
}
static void RestoreProfileEntryFrame(Obj content,const void *key) {
    Obj view=objc_getAssociatedObject(content,key);
    if (!view) return;
    Rect current=Frame(view),stock=ProfileStockFrame(view,current);
    if (!SameRect(current,stock)) SetFrame(view,stock);
    objc_setAssociatedObject(view,GlyphOriginalKey,0,1);
    objc_setAssociatedObject(view,GlyphAppliedKey,0,1);
    objc_setAssociatedObject(content,key,0,1);
}
static void RestoreProfileEntry(Obj content) {
    RestoreProfileEntryFrame(content,GlyphViewKey);
    RestoreProfileEntryFrame(content,ProfileCaptionKey);
    PageRestore(content);
}
static void ProfileEntryGlass(Obj self,B order) {
    Obj content=Get(self,"contentView");
    if (!content) return;
    B shortcut=HasAncestor(self,"SSMyUserShortcutCell") || HasAncestor(self,"SSMyUserCollectionView1Cell");
    Obj glyph=shortcut && Enabled() && FQHGlassAvailable() ? Get(self,order ? "productImage" : "image") : (Obj)0;
    Obj caption=glyph ? Get(self,order ? "functionType" : "label") : (Obj)0;
    if (!Kind(glyph,"UIImageView") || Get(glyph,"superview")!=content || Flag(glyph,"isHidden") ||
        !Kind(caption,"UILabel") || Get(caption,"superview")!=content) {
        RestoreProfileEntry(content);
        return;
    }
    Obj oldGlyph=objc_getAssociatedObject(content,GlyphViewKey);
    Obj oldCaption=objc_getAssociatedObject(content,ProfileCaptionKey);
    if (oldGlyph!=glyph) RestoreProfileEntryFrame(content,GlyphViewKey);
    if (oldCaption!=caption) RestoreProfileEntryFrame(content,ProfileCaptionKey);
    Rect b=Bounds(content),labelFrame=Frame(caption),iconFrame=Frame(glyph);
    Rect label=ProfileStockFrame(caption,labelFrame),icon=ProfileStockFrame(glyph,iconFrame);
    double height=__builtin_fmin(b.height,__builtin_fmax(44,label.y+label.height-b.y+5));
    double textY=__builtin_fmin(label.y,b.y+height-label.height-10);
    double glyphHeight=__builtin_fmin(__builtin_fmin(24,label.y-b.y-10),textY-b.y-6);
    if (!VisibleRect(b) || glyphHeight<12 || b.width<40 || !VisibleRect(icon) || !VisibleRect(label)) {
        RestoreProfileEntry(content);
        return;
    }
    // Move the whole caption inward, retaining its native width, height and font.
    // Leave room for the full title at the curved end of the compact 47pt cell.
    ApplySurface(content,(Rect){b.x,b.y,b.width,height},1);
    if (!FQHSurface(content)) {
        RestoreProfileEntry(content);
        return;
    }
    double scale=glyphHeight/__builtin_fmax(icon.width,icon.height);
    double top=__builtin_fmin(b.y+5,textY-glyphHeight-3);
    Rect adjusted={b.x+(b.width-icon.width*scale)*0.5,top+(glyphHeight-icon.height*scale)*0.5,
                   icon.width*scale,icon.height*scale};
    if (oldGlyph!=glyph) objc_setAssociatedObject(content,GlyphViewKey,glyph,1);
    if (oldCaption!=caption) objc_setAssociatedObject(content,ProfileCaptionKey,caption,1);
    ProfileSetFrame(glyph,iconFrame,icon,adjusted);
    ProfileSetFrame(caption,labelFrame,label,(Rect){label.x,textY,label.width,label.height});
}
static void PageProfileEntryLayout(Obj self,Sel cmd) {
    ((void(*)(Obj,Sel))Original("SSMyUserCollectionViewFunCell","fqx174_originalProfileEntry"))(self,cmd);
    // The native order subclass copies this glyph frame to its product overlay.
    if (!Kind(self,"SSMyUser621FunctionEntryItemCell")) ProfileEntryGlass(self,0);
}
static void PageProfileOrderLayout(Obj self,Sel cmd) {
    ((void(*)(Obj,Sel))Original("SSMyUserCollectionViewOrderFunCell","fqx178_originalProfileOrder"))(self,cmd);
    if (Kind(self,"SSMyUser621FunctionEntryItemCell")) ProfileEntryGlass(self,1);
}

static B MineStandaloneGameRow(Obj model) {
    return Kind(model,"SSMyUserMiniGameEntranceCellModel") &&
           !Kind(model,"SSMyUserShopAndMiniGameEntranceCellModel");
}
static void RecordMineGameRemoval(const char *ownerClass,const char *action) {
    Obj record=O0(Lookup("NSMutableDictionary"),"dictionary");
    Put(record,"event",Text("pageAdRemoved174"));
    Put(record,"ownerClass",Text(ownerClass));
    Put(record,"source",Text("serverGameModel"));
    Put(record,"action",Text(action));
    FQDRecord("pageAdFilter174",record);
}
B FQHPageFilterMiniGame(Obj owner) {
    if (!owner) return 0;
    Obj model=Get(owner,"miniGameEntranceCellModel");
    if (!MineStandaloneGameRow(model) || !InstanceABI(model,"setIsInvisible:","v20@0:8B16") ||
        !InstanceABI(model,"setIsDisabled:","v20@0:8B16")) return 0;
    // The host's own card-model contract supports an invisible/disabled row.
    // Removing the object from the mutable plan is a data-level deletion, not
    // hiding a parent view or blanking a reusable cell.
    VB(model,"setIsInvisible:",1);
    VB(model,"setIsDisabled:",1);
    Obj models=Get(owner,"models");
    if (Kind(models,"NSMutableArray") && Responds(models,"removeObjectIdenticalTo:"))
        V1(models,"removeObjectIdenticalTo:",model);
    RecordMineGameRemoval("SSMyUser621BaseViewController","removeModelBeforeListAdapter");
    return 1;
}
static void MiniGameSetup(Obj self,Sel cmd) {
    ((void(*)(Obj,Sel))Original("SSMyUser621BaseViewController","fqx174_originalMiniGameSetup"))(self,cmd);
    FQHPageFilterMiniGame(self);
}

static void MineConfiguredEntrances(Obj self,Sel cmd,Obj entries,I style) {
    Obj filtered=0;
    if (Kind(entries,"NSArray") && Signature("SSMineEcomEntranceData","entranceType","i16@0:8")) {
        U count=((U(*)(Obj,Sel))Message)(entries,sel_registerName("count"));
        for (U i=count;i>0;--i) {
            Obj entry=At(entries,i-1);
            // Type 9 is the rotating game promotion slot. Its title and
            // gameItems can change independently of the rest of Mine.
            if (!Kind(entry,"SSMineEcomEntranceData") ||
                ((int(*)(Obj,Sel))Message)(entry,sel_registerName("entranceType"))!=9) continue;
            if (!filtered) filtered=O0(O0(entries,"mutableCopy"),"autorelease");
            Q1(filtered,"removeObjectAtIndex:",i-1);
        }
    }
    ((void(*)(Obj,Sel,Obj,I))Original("SSMyUserCell2Model","fqx176_originalMineEntrances:style:"))(self,cmd,filtered ? filtered : entries,style);
    if (filtered) RecordMineGameRemoval("SSMyUserCell2Model","filterConfiguredGameEntrances");
}

static B MineBenefitsEnabled(void);
static void MineControllersKey(void) {}
static void RefreshMineBenefits(void) {
    if (!Signature("SSMyUser621ViewController","reloadData:","v24@0:8@16")) return;
    Obj controllers=O0(objc_getAssociatedObject(Lookup("SSMyUser621ViewController"),MineControllersKey),"allObjects");
    U count=((U(*)(Obj,Sel))Message)(controllers,sel_registerName("count"));
    for (U i=0;i<count;++i) V1(At(controllers,i),"reloadData:",Text("FanqieXMineBenefits"));
}
static B MineBenefitsRow(Obj model) {
    if (!Kind(model,"SSMyUserCell2Model") || !InstanceABI(model,"businessStyle","q16@0:8")) return 0;
    I style=((I(*)(Obj,Sel))Message)(model,sel_registerName("businessStyle"));
    // The personalized bar is the legacy benefits strip and takes precedence
    // over the separate friend entry when both flags are set.
    return style==4 || style==5 || (style==0 &&
           (BoolProp(model,"isShowPersonalizedBar") || !BoolProp(model,"isShowFriendView")));
}
static Obj MineListObjects(Obj self,Sel cmd,Obj adapter) {
    Obj rows=((Obj(*)(Obj,Sel,Obj))Original("SSMyUser621ViewController","fqx176_originalMineListObjects:"))(self,cmd,adapter);
    if (!Kind(rows,"NSArray")) return rows;
    Obj cls=Lookup("SSMyUser621ViewController");
    Obj controllers=objc_getAssociatedObject(cls,MineControllersKey);
    if (!controllers) {
        controllers=O0(Lookup("NSHashTable"),"weakObjectsHashTable");
        objc_setAssociatedObject(cls,MineControllersKey,controllers,1);
    }
    V1(controllers,"addObject:",self);
    Obj filtered=0;
    B hideBenefits=!MineBenefitsEnabled(),removedGame=0;
    U count=((U(*)(Obj,Sel))Message)(rows,sel_registerName("count"));
    for (U i=count;i>0;--i) {
        Obj row=At(rows,i-1);
        B game=MineStandaloneGameRow(row);
        if (!game && !(hideBenefits && MineBenefitsRow(row))) continue;
        removedGame|=game;
        if (!filtered) filtered=O0(O0(rows,"mutableCopy"),"autorelease");
        Q1(filtered,"removeObjectAtIndex:",i-1);
    }
    if (removedGame) RecordMineGameRemoval("SSMyUser621ViewController","filterStandaloneGameRows");
    return filtered ? filtered : rows;
}

enum { StoreOption=1, DramaOption, ShelfOption, MineOption, MallOption, ShelfDurationOption,
       MineBenefitsOption, ReaderBottomBackgroundOption };
static Obj PagePreference(I option) {
    const char *key;
    switch (option) {
        case StoreOption: key="FanqieX.BottomBookstore.1"; break;
        case DramaOption: key="FanqieX.BottomDrama.1"; break;
        case ShelfOption: key="FanqieX.BottomBookshelf.1"; break;
        case MineOption: key="FanqieX.BottomMine.1"; break;
        case MallOption: key="FanqieX.BottomMall.1"; break;
        case ShelfDurationOption: key="FanqieX.ShelfReadingDuration.1"; break;
        case MineBenefitsOption: key="FanqieX.MineBenefitsCard.1"; break;
        case ReaderBottomBackgroundOption: key="FanqieX.ReaderBottomBackground.1"; break;
        default: return 0;
    }
    return Text(key);
}
static Obj PageOptionLabel(I option) {
    const char *label;
    switch (option) {
        case StoreOption: label="底栏显示：书城"; break;
        case DramaOption: label="底栏显示：短剧"; break;
        case ShelfOption: label="底栏显示：书架"; break;
        case MineOption: label="底栏显示：我的"; break;
        case MallOption: label="底栏显示：商城"; break;
        case ShelfDurationOption: label="书架显示今日看听读时长"; break;
        case MineBenefitsOption: label="我的显示金币与福利卡片"; break;
        default: label="阅读菜单显示上下栏背景"; break;
    }
    return Text(label);
}
static B DefaultEnabled(Obj key) {
    Obj value=O1(O0(Lookup("NSUserDefaults"),"standardUserDefaults"),"objectForKey:",key);
    return value ? BoolProp(value,"boolValue") : 1;
}
static B MineBenefitsEnabled(void) { return DefaultEnabled(PagePreference(MineBenefitsOption)); }
static B ReaderBottomBackgroundEnabled(void) { return DefaultEnabled(PagePreference(ReaderBottomBackgroundOption)); }
static void SetDefault(Obj key,B value) {
    ((void(*)(Obj,Sel,B,Obj))Message)(O0(Lookup("NSUserDefaults"),"standardUserDefaults"),
        sel_registerName("setBool:forKey:"),value,key);
}
static U TabCount(Obj items) {
    return ((U(*)(Obj,Sel))Message)(items,sel_registerName("count"));
}
static I TabOption(Obj owner,Obj number) {
    int type=((int(*)(Obj,Sel))Message)(number,sel_registerName("intValue"));
    if (type==0) return StoreOption;
    if (type==3) return ShelfOption;
    if (type==4) return MineOption;
    if (type==7) return DramaOption;
    if (!InstanceABI(owner,"titleStrWithType:","@20@0:8i16")) return 0;
    Obj title=((Obj(*)(Obj,Sel,int))Message)(owner,sel_registerName("titleStrWithType:"),type);
    if (Equal(title,"短剧")) return DramaOption;
    if (Equal(title,"商城")) return MallOption;
    return 0;
}
static Obj TabPlan(Obj self,Sel cmd) {
    Obj plan=((Obj(*)(Obj,Sel))Original("SSTabBarController","fqx176_originalTabPlan"))(self,cmd);
    Obj types=Get(self,"typeArray");
    if (!Kind(plan,"NSArray") || !Kind(types,"NSArray") ||
        !InstanceABI(self,"setTypeArray:","v24@0:8@16") ||
        !InstanceABI(self,"setTypeIndexMap:","v24@0:8@16")) return plan;
    U count=TabCount(types);
    if (!count || TabCount(plan)!=count) return plan;
    Obj keptTypes=O0(Lookup("NSMutableArray"),"array");
    Obj keptPlan=O0(Lookup("NSMutableArray"),"array");
    Obj indexes=O0(Lookup("NSMutableDictionary"),"dictionary");
    U kept=0;
    for (U i=0;i<count;++i) {
        Obj number=At(types,i);
        Obj key=PagePreference(TabOption(self,number));
        if (key && !DefaultEnabled(key)) continue;
        Obj index=((Obj(*)(Obj,Sel,U))Message)(Lookup("NSNumber"),sel_registerName("numberWithUnsignedInteger:"),kept++);
        ((void(*)(Obj,Sel,Obj,Obj))Message)(indexes,sel_registerName("setObject:forKey:"),index,number);
        V1(keptTypes,"addObject:",number);
        V1(keptPlan,"addObject:",At(plan,i));
    }
    if (kept==count) return plan;
    if (!kept) {
        // The host requires a controller at index zero. This also recovers
        // preferences carried to a device whose server tab list is different.
        Obj first=At(types,0);
        Obj index=((Obj(*)(Obj,Sel,U))Message)(Lookup("NSNumber"),sel_registerName("numberWithUnsignedInteger:"),0);
        ((void(*)(Obj,Sel,Obj,Obj))Message)(indexes,sel_registerName("setObject:forKey:"),index,first);
        V1(keptTypes,"addObject:",first);
        V1(keptPlan,"addObject:",At(plan,0));
        SetDefault(PagePreference(TabOption(self,first)),1);
    }
    // Rebuild the three parallel collections before the host constructs
    // buttons and child controllers, so visible and navigation indexes agree.
    V1(self,"setTypeArray:",keptTypes);
    V1(self,"setTypeIndexMap:",indexes);
    return keptPlan;
}
static Obj FindTabOwner(Obj controller,int depth) {
    if (Kind(controller,"SSTabBarController")) return controller;
    if (!controller || !depth) return 0;
    Obj children=Get(controller,"children");
    U count=TabCount(children);
    for (U i=0;i<count;++i) {
        Obj owner=FindTabOwner(At(children,i),depth-1);
        if (owner) return owner;
    }
    return 0;
}
static Obj ActiveTabOwner(void) {
    Obj app=O0(Lookup("UIApplication"),"sharedApplication");
    Obj owner=FindTabOwner(Get(Get(app,"keyWindow"),"rootViewController"),5);
    if (owner) return owner;
    Obj windows=Get(app,"windows");
    U count=TabCount(windows);
    for (U i=0;i<count;++i) {
        owner=FindTabOwner(Get(At(windows,i),"rootViewController"),5);
        if (owner) return owner;
    }
    return 0;
}
static void InstallTabRecovery(Obj owner);
static void ShelfEditHeaderKey(void) {}
static void ShelfCompactKey(void) {}
static const double ShelfFilterOffset=12;
static const double ShelfCompactFilterTop=2;
static const double ShelfCompactEmptyHeight=1;
static void ShelfStockEditLayout(Obj self,Sel cmd) {
    Obj parent=Get(Get(self,"editButton"),"superview");
    if (parent && objc_getAssociatedObject(parent,ShelfEditHeaderKey)==self) return;
    ((void(*)(Obj,Sel))Original("SS525BookShelfSubHeaderView","fqx185_originalStockEditLayout"))(self,cmd);
}
static Rect ShelfEditFrame(Obj controller,Obj holder,Obj button) {
    Rect frame={0};
    Obj owner=Get(controller,"delegate");
    Obj header=Get(owner,"headerView");
    if (!Kind(owner,"SSBookShelf525ViewController") || Get(owner,"currentTabVC")!=controller ||
        !header || Get(owner,"headerRightView")!=holder || Get(holder,"superview")!=header ||
        Flag(holder,"clipsToBounds") || !CanExpandHit(holder)) return frame;
    Obj search=Get(controller,"searchButton"),more=Get(controller,"moreButton");
    Obj anchor=Flag(search,"isHidden") ? more : search;
    Obj tabs=Get(owner,"tabSelectView"),window=Get(holder,"window");
    if (!window || Get(tabs,"window")!=window || Flag(tabs,"isHidden") ||
        !Belongs(anchor,holder) || Flag(anchor,"isHidden")) return frame;
    Rect right=Convert(anchor,Bounds(anchor),holder);
    Obj glass=FQHIconGlass(anchor);
    if (glass) {
        Rect material=Convert(anchor,Frame(glass),holder);
        if (material.x<right.x) right.x=material.x;
    }
    Obj cells=Get(Get(tabs,"collectionView"),"visibleCells");
    U count=TabCount(cells);
    B found=0;
    double left=0;
    for (U i=0;i<count;++i) {
        Obj cell=At(cells,i);
        if (!Kind(cell,"SSBookShelfTabSelectViewTitleCell") || Flag(cell,"isHidden")) continue;
        Rect title=Convert(cell,Bounds(cell),holder);
        double edge=title.x+title.width+4; // ShelfTabStyle can extend past the title cell.
        if (!found || edge>left) left=edge;
        found=1;
    }
    double width=Bounds(button).width;
    if (width<44) width=44;
    if (!found || !VisibleRect(right) || right.x-left<width+20) return frame;
    Rect target={left+10,right.y+right.height*0.5-15,width,30};
    Rect inHeader=Convert(holder,target,header),bounds=Bounds(header);
    if (inHeader.x<bounds.x || inHeader.y<bounds.y ||
        inHeader.x+inHeader.width>bounds.x+bounds.width ||
        inHeader.y+inHeader.height>bounds.y+bounds.height) return frame;
    return target;
}
static Obj ShelfEditPlacement(Obj controller,Obj holder) {
    Obj cell=Get(controller,"functionCell");
    Obj header=Get(cell,"headerView");
    Obj old=objc_getAssociatedObject(holder,ShelfEditHeaderKey);
    Obj button=0,secondary=0;
    Rect frame={0};
    if (Kind(header,"SS525BookShelfSubHeaderView") &&
        InstanceABI(header,"isFiltering","B16@0:8") && !Flag(header,"isFiltering") &&
        InstanceABI(header,"layoutEditButton","v16@0:8") && !Flag(header,"isHidden")) {
        button=Get(header,"editButton");
        secondary=Get(header,"secondaryView");
        Obj parent=Get(button,"superview");
        if (secondary && (parent==secondary || parent==holder) && !Flag(button,"isHidden"))
            frame=ShelfEditFrame(controller,holder,button);
    }
    B moved=VisibleRect(frame);
    if (old && (!moved || old!=header)) {
        Obj previous=Get(old,"editButton");
        if (Get(previous,"superview")==holder) {
            V1(Get(old,"secondaryView"),"addSubview:",previous);
            V0(old,"layoutEditButton");
        }
        objc_setAssociatedObject(holder,ShelfEditHeaderKey,0,1);
    }
    Obj compact=0;
    if (moved) {
        if (Get(button,"superview")!=holder) V1(holder,"addSubview:",button);
        if (!SameRect(Frame(button),frame)) SetFrame(button,frame);
        ShelfActionGlass(button);
        if (old!=header) objc_setAssociatedObject(holder,ShelfEditHeaderKey,header,1);
        if (class_getInstanceMethod(object_getClass(cell),sel_registerName("fqx178_originalShelfFunctionLayout")) &&
            InstanceABI(header,"showReadTimeView","B16@0:8") && !Flag(header,"showReadTimeView")) {
            compact=cell;
            if (!Flag(secondary,"isHidden")) {
                Obj line=Get(header,"lineView"),line2=Get(header,"lineView2");
                Obj children=Get(secondary,"subviews");
                U count=TabCount(children);
                for (U i=0;i<count;++i) {
                    Obj child=At(children,i);
                    if (child==line || child==line2 || Flag(child,"isHidden")) continue;
                    double alpha=((double(*)(Obj,Sel))Message)(child,sel_registerName("alpha"));
                    if (alpha>0 && VisibleRect(Frame(child))) { compact=0; break; }
                }
            }
        }
    }
    if (objc_getAssociatedObject(controller,ShelfCompactKey)!=compact) {
        objc_setAssociatedObject(controller,ShelfCompactKey,compact,1);
        V0(cell,"setNeedsLayout");
        V0(Get(Get(controller,"collectionView"),"collectionViewLayout"),"invalidateLayout");
    }
    return moved ? button : (Obj)0;
}
static void ShelfSaveOpeningData(Obj self,Sel cmd,Obj data,Obj index) {
    if (objc_getAssociatedObject(self,ShelfCompactKey)) V0(Get(self,"collectionView"),"layoutIfNeeded");
    ((void(*)(Obj,Sel,Obj,Obj))Original("SSBookShelfSubViewController","fqx185_originalSaveOpeningData:index:"))(
        self,cmd,data,index);
}
static Obj ShelfCoverTransitionInfo(Obj self,Sel cmd,U phase) {
    B compact=(phase==2 || phase==3) && objc_getAssociatedObject(self,ShelfCompactKey);
    Obj list=compact ? Get(self,"collectionView") : (Obj)0;
    if (compact) V0(list,"layoutIfNeeded");
    Obj info=((Obj(*)(Obj,Sel,U))Original("SSBookShelfSubViewController","fqx185_originalCoverTransition:"))(self,cmd,phase);
    if (!compact || !objc_getAssociatedObject(self,ShelfCompactKey) ||
        !Kind(info,"SSCoverTransitionInfo") ||
        !InstanceABI(info,"setCoverFrame:","v48@0:8{CGRect={CGPoint=dd}{CGSize=dd}}16")) return info;
    // Re-anchor the host's detached cover image to the current compact cell on both directions.
    Obj model=Get(self,"openingModel"),book=Get(Get(model,"data"),"bookId");
    Obj cells=Get(list,"visibleCells");
    U count=TabCount(cells);
    for (U i=0;book && i<count;++i) {
        Obj cell=At(cells,i),data=O0(Get(Get(cell,"cellModel"),"collectDatas"),"firstObject");
        Obj candidate=Get(data,"bookId");
        if (!((B(*)(Obj,Sel,Obj))Message)(book,sel_registerName("isEqual:"),candidate)) continue;
        Obj cover=Get(cell,"fetchCoverView"),window=Get(cover,"window");
        if (!window) continue;
        if (!InstanceABI(cell,"fetchCoverSize","{CGSize=dd}16@0:8")) return info;
        Rect frame=Convert(cover,Bounds(cover),window);
        Size size=((Size(*)(Obj,Sel))Message)(cell,sel_registerName("fetchCoverSize"));
        frame.width=size.width; frame.height=size.height;
        if (VisibleRect(frame)) {
            ((void(*)(Obj,Sel,Rect))Message)(info,sel_registerName("setCoverFrame:"),frame);
            return info;
        }
    }
    // With no visible matching cover, the native animator uses its standard page transition.
    return 0;
}
static B ShelfFunctionSection(Obj controller,I section) {
    Obj model=Get(controller,"viewModel");
    return InstanceABI(model,"sectionTypeAtIndex:","q24@0:8q16") &&
        ((I(*)(Obj,Sel,I))Message)(model,sel_registerName("sectionTypeAtIndex:"),section)==1;
}
static Size ShelfFunctionSize(Obj self,Sel cmd,Obj collection,Obj layout,Obj index) {
    Size size=((Size(*)(Obj,Sel,Obj,Obj,Obj))Original("SSBookShelfSubViewController","fqx178_originalShelfFunctionSize:layout:index:"))(
        self,cmd,collection,layout,index);
    if (objc_getAssociatedObject(self,ShelfCompactKey) && size.height>ShelfCompactEmptyHeight) {
        I section=((I(*)(Obj,Sel))Message)(index,sel_registerName("section"));
        // The host's size switch uses type 1 for the function row.
        if (ShelfFunctionSection(self,section)) {
            Obj cls=Lookup("SSBookShelfFunctionCell");
            if (!InstanceABI(cls,"cellHeightWithFilterExposure:","d20@0:8B16")) return size;
            double base=((double(*)(Obj,Sel,B))Message)(cls,
                sel_registerName("cellHeightWithFilterExposure:"),0);
            // The host clip begins at base + 12 and fills the remaining row.
            size.height=size.height>base ? size.height-base-ShelfFilterOffset+ShelfCompactFilterTop :
                ShelfCompactEmptyHeight;
        }
    }
    return size;
}
static Rect ShelfFunctionInsets(Obj self,Sel cmd,Obj collection,Obj layout,I section) {
    Rect insets=((Rect(*)(Obj,Sel,Obj,Obj,I))Original("SSBookShelfSubViewController",
        "fqx181_originalShelfInsets:layout:section:"))(self,cmd,collection,layout,section);
    Obj cell=objc_getAssociatedObject(self,ShelfCompactKey);
    if (cell && InstanceABI(cell,"showsFilterExposure","B16@0:8") &&
        !Flag(cell,"showsFilterExposure") && ShelfFunctionSection(self,section)) {
        // UIEdgeInsets shares the four-double ABI. With no in-cell filter
        // this spacer precedes the separate, pinnable filter header.
        insets.x=0;
        insets.width=0;
    }
    return insets;
}
static void ShelfFunctionLayout(Obj self,Sel cmd) {
    ((void(*)(Obj,Sel))Original("SSBookShelfFunctionCell","fqx178_originalShelfFunctionLayout"))(self,cmd);
    Obj controller=Get(self,"delegate");
    if (objc_getAssociatedObject(controller,ShelfCompactKey)!=self ||
        !InstanceABI(self,"showsFilterExposure","B16@0:8")) return;
    Obj clip=Get(self,"filterClipView");
    Rect frame=Frame(clip);
    double top=Flag(self,"showsFilterExposure") ? ShelfCompactFilterTop : ShelfFilterOffset+ShelfCompactEmptyHeight;
    if (frame.y>top) {
        frame.y=top;
        SetFrame(clip,frame);
    }
}
static void ShelfDurationHeadersKey(void) {}
static void ShelfDurationRequestedKey(void) {}
static Obj ShelfDurationHeaders(void) {
    Obj cls=Lookup("SS525BookShelfSubHeaderView");
    Obj headers=objc_getAssociatedObject(cls,ShelfDurationHeadersKey);
    if (!headers) {
        headers=O0(Lookup("NSHashTable"),"weakObjectsHashTable");
        objc_setAssociatedObject(cls,ShelfDurationHeadersKey,headers,1);
    }
    return headers;
}
static void ApplyShelfDuration(Obj header,B visible) {
    Imp original=Original("SS525BookShelfSubHeaderView","fqx177_originalDurationVisible:");
    if (original) ((void(*)(Obj,Sel,B))original)(header,sel_registerName("setShowReadTimeView:"),visible);
}
static void ShelfDurationVisible(Obj self,Sel cmd,B requested) {
    (void)cmd;
    if (!objc_getAssociatedObject(self,ShelfDurationRequestedKey))
        V1(ShelfDurationHeaders(),"addObject:",self);
    objc_setAssociatedObject(self,ShelfDurationRequestedKey,BoolBox(requested),1);
    ApplyShelfDuration(self,requested && DefaultEnabled(PagePreference(ShelfDurationOption)));
}
static void ShelfDurationLayout(Obj self,Sel cmd) {
    // Some headers receive their initial state through the superclass before
    // the duration button is mounted. Register them on their first layout.
    if (!objc_getAssociatedObject(self,ShelfDurationRequestedKey) && InstanceABI(self,"showReadTimeView","B16@0:8"))
        ShelfDurationVisible(self,cmd,Flag(self,"showReadTimeView"));
    ((void(*)(Obj,Sel))Original("SS525BookShelfSubHeaderView","fqx177_originalDurationLayout"))(self,cmd);
    Obj controller=Get(self,"delegate"),holder=Get(controller,"searchAndMoreView");
    Obj edit=0;
    if (Kind(holder,"UIView")) {
        edit=ShelfEditPlacement(controller,holder);
        ShelfTopHit(holder,Get(controller,"searchButton"),Get(controller,"moreButton"),edit);
    }
    if (!edit) ShelfActionGlass(Get(self,"editButton"));
    ShelfActionGlass(Get(self,"filterButton"));
    ShelfActionGlass(Get(self,"fullGenreFilterButton"));
}
static void RefreshShelfDuration(B enabled) {
    Obj cls=Lookup("SS525BookShelfSubHeaderView");
    Obj headers=O0(objc_getAssociatedObject(cls,ShelfDurationHeadersKey),"allObjects");
    U count=TabCount(headers);
    for (U i=0;i<count;++i) {
        Obj header=At(headers,i);
        Obj requested=objc_getAssociatedObject(header,ShelfDurationRequestedKey);
        ApplyShelfDuration(header,enabled && BoolProp(requested,"boolValue"));
        V0(header,"setNeedsLayout");
    }
}
static void ToggleChanged(Obj self,Sel cmd,Obj sender) {
    (void)self; (void)cmd;
    I tag=((I(*)(Obj,Sel))Message)(sender,sel_registerName("tag"));
    Obj key=PagePreference(tag);
    if (!key) return;
    B on=BoolProp(sender,"isOn");
    if (tag>=ShelfDurationOption) {
        SetDefault(key,on);
        if (tag==ShelfDurationOption) RefreshShelfDuration(on);
        else if (tag==MineBenefitsOption) RefreshMineBenefits();
        return;
    }
    Obj owner=ActiveTabOwner();
    Obj types=Get(owner,"typeArray");
    if (!on && TabCount(types)==1 && TabOption(owner,At(types,0))==tag) {
        ((void(*)(Obj,Sel,B,B))Message)(sender,sel_registerName("setOn:animated:"),1,1);
        return;
    }
    SetDefault(key,on);
    if (owner) {
        V0(owner,"refreshTabBar");
        InstallTabRecovery(owner);
    }
    Obj record=O0(Lookup("NSMutableDictionary"),"dictionary");
    Put(record,"event",Text("bottomEntryToggle176"));
    Put(record,"entry",key);
    Put(record,"enabled",BoolBox(on));
    FQDRecord("bottomEntryToggle176",record);
}
static Obj RecoveryBar(Obj observer) {
    return O0(objc_getAssociatedObject(observer,RecoveryBarKey),"anyObject");
}
static B RecoveryTouch(Obj self,Sel cmd,Obj recognizer,Obj touch) {
    (void)cmd; (void)recognizer;
    Obj bar=RecoveryBar(self);
    if (!bar || Flag(bar,"isHidden") || DefaultEnabled(PagePreference(MineOption))) return 0;
    Point p=((Point(*)(Obj,Sel,Obj))Message)(touch,sel_registerName("locationInView:"),bar);
    Rect b=Bounds(bar);
    return p.x>=b.x && p.x<b.x+b.width && p.y>=b.y && p.y<b.y+b.height;
}
static void RecoverOptions(Obj self,Sel cmd,Obj recognizer) {
    (void)cmd;
    if (((I(*)(Obj,Sel))Message)(recognizer,sel_registerName("state"))!=1) return;
    Obj owner=Get(RecoveryBar(self),"delegate");
    if (!Kind(owner,"SSTabBarController") || Get(owner,"presentedViewController")) return;
    Sel open=sel_registerName("fqab_openMenu");
    Method method=class_getInstanceMethod(Lookup("SSSettingViewController"),open);
    // The existing plugin action uses self solely as the modal presenter.
    if (method) ((void(*)(Obj,Sel))method_getImplementation(method))(owner,open);
}
static Obj ToggleObserver(void) {
    Obj cls=Lookup("FanqieXBottomToggles176");
    if (cls) return cls;
    cls=AllocateClass(Lookup("NSObject"),"FanqieXBottomToggles176",0);
    if (!cls) return 0;
    class_addMethod(cls,sel_registerName("fqx176_toggle:"),(Imp)ToggleChanged,"v24@0:8@16");
    class_addMethod(cls,sel_registerName("fqx176_recoverOptions:"),(Imp)RecoverOptions,"v24@0:8@16");
    class_addMethod(cls,sel_registerName("gestureRecognizer:shouldReceiveTouch:"),(Imp)RecoveryTouch,"B32@0:8@16@24");
    RegisterClass(cls);
    return cls;
}
static void InstallTabRecovery(Obj owner) {
    Obj bar=Get(owner,"customTabBar"), parent=Get(bar,"superview");
    Obj gesture=objc_getAssociatedObject(owner,TabRecoveryKey);
    Obj attached=Get(gesture,"view");
    B needed=parent && !DefaultEnabled(PagePreference(MineOption));
    if (gesture && (attached!=parent || !needed)) {
        V1(attached,"removeGestureRecognizer:",gesture);
        objc_setAssociatedObject(owner,TabRecoveryKey,0,1);
        gesture=0;
    }
    if (!needed || gesture) return;
    Obj observer=O0(O0(ToggleObserver(),"alloc"),"init");
    if (!observer) return;
    Obj weak=O0(Lookup("NSHashTable"),"weakObjectsHashTable");
    V1(weak,"addObject:",bar);
    objc_setAssociatedObject(observer,RecoveryBarKey,weak,1);
    gesture=((Obj(*)(Obj,Sel,Obj,Sel))Message)(O0(Lookup("UILongPressGestureRecognizer"),"alloc"),
        sel_registerName("initWithTarget:action:"),observer,sel_registerName("fqx176_recoverOptions:"));
    if (!gesture) { V0(observer,"release"); return; }
    ((void(*)(Obj,Sel,double))Message)(gesture,sel_registerName("setMinimumPressDuration:"),0.75);
    V1(gesture,"setDelegate:",observer);
    objc_setAssociatedObject(gesture,ToggleObserverKey,observer,1);
    objc_setAssociatedObject(owner,TabRecoveryKey,gesture,1);
    V1(parent,"addGestureRecognizer:",gesture);
    V0(gesture,"release");
    V0(observer,"release");
}
static void TabOwnerAppear(Obj self,Sel cmd,B animated) {
    ((void(*)(Obj,Sel,B))Original("SSTabBarController","fqx176_originalTabAppear:"))(self,cmd,animated);
    InstallTabRecovery(self);
}
static Obj ToggleRow(Obj container,double y,Obj title,I tag,B on,Obj observer) {
    double width=Bounds(container).width;
    Obj label=O0(O0(Lookup("UILabel"),"alloc"),"init");
    if (!label) return 0;
    Rect labelFrame={16,y,width-96,30};
    ((void(*)(Obj,Sel,Rect))Message)(label,sel_registerName("setFrame:"),labelFrame);
    V1(label,"setText:",title);
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
        observer,sel_registerName("fqx176_toggle:"),4096);
    V1(toggle,"setAccessibilityLabel:",title);
    V1(container,"addSubview:",toggle);
    V0(toggle,"release");
    return toggle;
}
// This runs when the existing action has allocated its dynamic settings
// controller, before UIKit presents the navigation stack.
void FQHInstallOptionsToggles(Obj controller) {
    Obj table=Get(controller,"tableView");
    if (!table || Get(table,"tableHeaderView")) return;
    Obj observerClass=ToggleObserver();
    if (!observerClass) return;
    Obj observer=O0(O0(observerClass,"alloc"),"init");
    if (!observer) return;
    Obj container=O0(O0(Lookup("UIView"),"alloc"),"init");
    if (!container) { V0(observer,"release"); return; }
    double width=Bounds(table).width;
    // UITableView can still be unsized before its navigation controller presents it.
    Rect frame={0,0,width>0 ? width : 320,400};
    ((void(*)(Obj,Sel,Rect))Message)(container,sel_registerName("setFrame:"),frame);
    V1(container,"setBackgroundColor:",O0(Lookup("UIColor"),"clearColor"));
    for (I tag=StoreOption;tag<=ReaderBottomBackgroundOption;++tag) {
        ToggleRow(container,8+42*(tag-StoreOption),PageOptionLabel(tag),tag,
            DefaultEnabled(PagePreference(tag)),observer);
    }
    Obj note=O0(O0(Lookup("UILabel"),"alloc"),"init");
    SetFrame(note,(Rect){16,352,frame.width-32,40});
    V1(note,"setText:",Text("底栏至少保留一项。\n关闭“我的”后，长按底栏打开 FanqieX 设置。"));
    Q1(note,"setNumberOfLines:",2);
    V1(note,"setFont:",((Obj(*)(Obj,Sel,double))Message)(Lookup("UIFont"),sel_registerName("systemFontOfSize:"),12));
    V1(note,"setTextColor:",O0(Lookup("UIColor"),"secondaryLabelColor"));
    Q1(note,"setAutoresizingMask:",2);
    V1(container,"addSubview:",note);
    V0(note,"release");
    objc_setAssociatedObject(container,ToggleObserverKey,observer,1);
    V1(table,"setTableHeaderView:",container);
    V0(container,"release");
    V0(observer,"release");
}
void FQHPageStyle(Obj view) { FQHApply(view); }
void FQHPageTint(Obj view,B selected) { ShelfTabStyle(view,Get(view,"cellModel"),selected); }

static B DenyBookstorePopup(Obj self,Sel cmd) {
    (void)self;
    (void)cmd;
    return 0;
}

static Obj BookstorePopupHandler(Obj self,Sel cmd,Obj group) {
    Obj handler=((Obj(*)(Obj,Sel,Obj))Original("SSImcMessageService","fqx185_originalIMCPopup:"))(self,cmd,group);
    if (!Kind(handler,"SSImcAdOperationMessage")) return handler;
    Obj record=O0(Lookup("NSMutableDictionary"),"dictionary");
    Put(record,"ruleId",Text("bookstore_imc_popup"));
    Put(record,"ruleType",Text("exactHostSelector"));
    Put(record,"class",Text("SSImcMessageService"));
    Put(record,"selector",Text("getPopupWithDataGroup:"));
    Put(record,"result",Text("blocked"));
    Put(record,"pageDisplay",Text("unobserved"));
    FQDRecord("adRuleDecision",record);
    return 0;
}

B FQHBookstoreAdInstall(void) {
    // A legacy-only host can use its native skip path without a Cyber gate.
    B legacy=Signature("SSInsertScreenRecommendService","showInsertScreenOfNonstandardAdMessage:showBlock:","v32@0:8@16@?24");
    Obj adOwner=Lookup("SSImcAdOperationMessage");
    if (!adOwner) return legacy;
    Method gate=FQDResolveOwned(adOwner,sel_registerName("enablePopup"),0,"B16@0:8");
    if (!gate) return 0;
    // The request path checks enablePopup. Cached and async resources can use
    // the unfiltered type-7 registry. Deny its ad handler before view creation.
    Hook("SSImcMessageService","getPopupWithDataGroup:","fqx185_originalIMCPopup:","@24@0:8@16",(Imp)BookstorePopupHandler);
    if (!Signature("SSImcMessageService","fqx185_originalIMCPopup:","@24@0:8@16")) return 0;
    method_setImplementation(gate,(Imp)DenyBookstorePopup);
    return legacy;
}

static void ShelfCompactInstall(void) {
    Obj cell=Lookup("SSBookShelfFunctionCell");
    Obj owner=Lookup("SSBookShelfSubViewController");
    if (!Signature("SSBookShelfViewModel","sectionTypeAtIndex:","q24@0:8q16") ||
        !Signature("SS525BookShelfSubHeaderView","showReadTimeView","B16@0:8") ||
        !ClassABI(cell,"showsFilterExposure","B16@0:8") ||
        !InstanceABI(cell,"cellHeightWithFilterExposure:","d20@0:8B16")) return;
    Hook("SSBookShelfSubViewController","collectionView:layout:sizeForItemAtIndexPath:","fqx178_originalShelfFunctionSize:layout:index:","{CGSize=dd}40@0:8@16@24@32",(Imp)ShelfFunctionSize);
    Hook("SSBookShelfSubViewController","collectionView:layout:insetForSectionAtIndex:","fqx181_originalShelfInsets:layout:section:","{UIEdgeInsets=dddd}40@0:8@16@24q32",(Imp)ShelfFunctionInsets);
    // The clip hook's alias also authorizes entering compact layout.
    if (class_getInstanceMethod(owner,sel_registerName("fqx178_originalShelfFunctionSize:layout:index:")) &&
        class_getInstanceMethod(owner,sel_registerName("fqx181_originalShelfInsets:layout:section:")))
        Hook("SSBookShelfFunctionCell","layoutContainerSubviews","fqx178_originalShelfFunctionLayout","v16@0:8",(Imp)ShelfFunctionLayout);
}

void FQHPageInstall(void) {
    Hook("SSReaderFanClubEntryContainerView","layoutSubviews","fqx184_originalShelfWrapper","v16@0:8",(Imp)ReaderShelfWrapperLayout);
    Hook("FQReaderUIManager","showBottomBarContainer:","fqx180_originalReaderMenu:","v20@0:8B16",(Imp)ReaderMenuShow);
    Hook("FQReaderUIManager","onConfigThemeChange:context:","fqx180_originalReaderTheme:context:","v32@0:8@16@24",(Imp)ReaderBackdropTheme);
    Hook("FQReaderUIManager","refreshBottomToolbarInsertView","fqx181_originalReaderCommunityRefresh","v16@0:8",(Imp)PageReaderCommunityRefresh);
    Hook("SSReaderCommunityBottomToolbarItemView","layoutSubviews","fqx181_originalReaderCommunity","v16@0:8",(Imp)PageReaderCommunityLayout);
    Hook("FQReaderSaaSBottomToolView","layoutSubviews","fqx175_originalBottom","v16@0:8",(Imp)PageBottomLayout);
    Hook("FQReaderSaaSNewProgressView","layoutSubviews","fqx174_originalProgress","v16@0:8",(Imp)PageProgressLayout);
    Hook("FQReaderSaaSNewProgressView","updateWithConfigData:","fqx176_originalProgressTheme:","v24@0:8@16",(Imp)PageProgressTheme);
    Hook("SSReaderBottomToolDivertView","layoutSubviews","fqx175_originalDivert","v16@0:8",(Imp)PageDivertLayout);
    Hook("SSReaderGiftView","layoutSubviews","fqx174_originalGift","v16@0:8",(Imp)PageGiftLayout);
    Hook("SSReaderBookEndUserGiftView","layoutSubviews","fqx174_originalBookGift","v16@0:8",(Imp)PageBookGiftLayout);
    Hook("SSReaderChapterEndDiscussionEntranceView","layoutSubviews","fqx174_originalDiscuss","v16@0:8",(Imp)PageDiscussLayout);
    Hook("SSReaderChapterEndDiscussionEntranceButton","layoutSubviews","fqx174_originalDiscussButton","v16@0:8",(Imp)PageDiscussButtonLayout);
    Hook("SSReaderChapterEndCommunityCardView","layoutSubviews","fqx177_originalChapterCard","v16@0:8",(Imp)PageChapterCardLayout);
    Hook("SSReaderChapterEndCommunityCardView","updateWithReaderConfig:","fqx177_originalChapterCardTheme:","v24@0:8@16",(Imp)PageChapterCardTheme);
    Hook("SSReaderChapterEndBaseButton","layoutSubviews","fqx177_originalChapterButton","v16@0:8",(Imp)PageChapterButtonLayout);
    Hook("SSReaderChapterEndRewardButton","updateWithThemeConfigChange:","fqx177_originalChapterRewardTheme:","v24@0:8@16",(Imp)PageChapterRewardTheme);
    Hook("SSBookShelfTabSelectViewTitleCell","layoutSubviews","fqx174_originalShelfCategory","v16@0:8",(Imp)PageShelfTabLayout);
    Hook("SSBookShelfTabSelectViewTitleCell","reloadData:","fqx175_originalShelfTabReload:","v24@0:8@16",(Imp)PageShelfTabReload);
    Hook("SSBookShelfFilter541Cell","layoutSubviews","fqx175_originalShelfFilterLayout","v16@0:8",(Imp)PageShelfFilterLayout);
    Hook("SSBookShelfFilter541Cell","updateAppearance:","fqx175_originalShelfFilterAppearance:","v20@0:8B16",(Imp)PageShelfFilterAppearance);
    Hook("SSBookShelfFilter541Cell","updateCellBgColor:","fqx175_originalShelfFilterBackground:","v24@0:8@16",(Imp)PageShelfFilterBackground);
    Hook("SSBookShelfFilterHeaderView","layoutSubviews","fqx179_originalShelfFilterHeader","v16@0:8",(Imp)ShelfFilterHeaderLayout);
    Hook("SSBookShelfFilterMixRowCollectionView","collectionView:layout:insetForSectionAtIndex:","fqx185_originalInlineFilterInsets:layout:section:","{UIEdgeInsets=dddd}40@0:8@16@24q32",(Imp)ShelfInlineFilterInsets);
    Hook("SSMyUserBar","layoutSubviews","fqx174_originalProfileBar","v16@0:8",(Imp)PageProfileBarLayout);
    Hook("SSMyUserCollectionViewFunCell","layoutSubviews","fqx174_originalProfileEntry","v16@0:8",(Imp)PageProfileEntryLayout);
    Hook("SSMyUserCollectionViewOrderFunCell","layoutSubviews","fqx178_originalProfileOrder","v16@0:8",(Imp)PageProfileOrderLayout);
    Hook("SSMyUser621BaseViewController","setupCellMiniGameEntranceData","fqx174_originalMiniGameSetup","v16@0:8",(Imp)MiniGameSetup);
    Hook("SSMyUserCell2Model","applyConfiguredMineEcomEntranceData:mineMonetizationStyle:","fqx176_originalMineEntrances:style:","v32@0:8@16q24",(Imp)MineConfiguredEntrances);
    Hook("SSMyUser621ViewController","objectsForListAdapter:","fqx176_originalMineListObjects:","@24@0:8@16",(Imp)MineListObjects);
    Hook("SS525BookShelfSubHeaderView","setShowReadTimeView:","fqx177_originalDurationVisible:","v20@0:8B16",(Imp)ShelfDurationVisible);
    Hook("SS525BookShelfSubHeaderView","layoutSubviews","fqx177_originalDurationLayout","v16@0:8",(Imp)ShelfDurationLayout);
    Hook("SS525BookShelfSubHeaderView","layoutEditButton","fqx185_originalStockEditLayout","v16@0:8",(Imp)ShelfStockEditLayout);
    Hook("SSBookShelfSubViewController","saveOpeningData:indexPath:","fqx185_originalSaveOpeningData:index:","v32@0:8@16@24",(Imp)ShelfSaveOpeningData);
    Hook("SSBookShelfSubViewController","fetchBookCoverTransitionInfo:","fqx185_originalCoverTransition:","@24@0:8Q16",(Imp)ShelfCoverTransitionInfo);
    ShelfCompactInstall();
    Hook("SSTabBarController","tabbarVCAndAttributeInit","fqx176_originalTabPlan","@16@0:8",(Imp)TabPlan);
    Hook("SSTabBarController","viewDidAppear:","fqx176_originalTabAppear:","v20@0:8B16",(Imp)TabOwnerAppear);
}

void FQHInstall(void) {
    if (!FQHGlassAvailable()) return;
    Hook("SSReaderFloatingCommonButton","layoutSubviews","fqx171_originalLayout","v16@0:8",(Imp)ListenLayout);
    Hook("FQReaderSaaSReaderSpeechButton","layoutSubviews","fqx175_originalSpeechLayout","v16@0:8",(Imp)SpeechLayout);
    Hook("FQReaderSaaSReaderSpeechButton","readerInsertedViewBackgroundConfigChange:","fqx175_originalSpeechTheme:","v24@0:8@16",(Imp)SpeechTheme);
    if (Signature("SSBookStoreNewViewController","searchBgView","@16@0:8")) {
        Hook("SSBookStoreNewViewController","relayout","fqx165_originalRelayout","v16@0:8",(Imp)HomeLayout);
        Hook("SSBookStoreNewViewController","viewDidAppear:","fqx165_originalAppear:","v20@0:8B16",(Imp)HomeAppear);
        if (Signature("SSBookStoreSearchBarComponent","bookStoreVCContext","@16@0:8"))
            Hook("SSBookStoreSearchBarComponent","resetTopTabSearchViewWithRatio:fromTab:toTab:fromTabTemplate:toTabTemplate:","fqx173_originalSearchColor:from:to:fromTemplate:toTemplate:","v40@0:8d16i24i28i32i36",(Imp)SearchColor);
    }
    // This is the right-hand category ENTRY, not the horizontal category tabs.
    Hook("SSBookStoreCategorySignView","layoutSubviews","fqx173_originalLayout","v16@0:8",(Imp)CategoryLayout);
    Hook("SSBookStoreCategorySignView","resetColorWithRatio:fromTab:toTab:fromTabTemplate:toTabTemplate:","fqx173_originalColor:from:to:fromTemplate:toTemplate:","v40@0:8d16i24i28i32i36",(Imp)CategoryColor);
    Hook("FQReaderSaaSBaseButton","layoutSubviews","fqx170_originalLayout","v16@0:8",(Imp)ShelfButtonLayout);
    Hook("SSBookShelfSubViewController","viewDidLayoutSubviews","fqx167_originalShelfLayout","v16@0:8",(Imp)ShelfLayout);
    Hook("FQReaderSaasNavigationView","layoutSubviews","fqx167_originalLayout","v16@0:8",(Imp)ReaderLayout);
    Hook("FQReaderSaasNavigationView","readerInsertedViewThemeConfigChange:","fqx167_originalTheme:","v24@0:8@16",(Imp)ReaderTheme);
}
