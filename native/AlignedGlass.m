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
typedef struct { double top, left, bottom, right; } Insets;
void FQHBottomPrepare(Obj bar,Obj proxy,Obj buttons);
void FQHBottomFinish(Obj bar,Obj proxy,Obj buttons,Obj native);
Rect FQHBottomNativeRect178(Obj proxy,Rect bounds);
Rect FQHBottomProxyFrame178R5(Obj proxy,Rect stock);
Rect FQHBottomButtonFrame178R5(Obj button,Rect stock);
void FQHBottomReset178(Obj bar,Obj proxy);
static void SettingsInstall178R13(Obj controller);
static Obj SettingsVisibleController(Obj owner);
void FQHUpdateTabAppearance(Obj bar,Obj proxy,Obj buttons);
void FQHRefreshMineQuickAppearance178R13(void);
static void RefreshFullscreenFill(void);
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
    Obj applied=objc_getAssociatedObject(glyph,GlyphAppliedKey);
    if (original && applied) {
        Rect rect=((Rect(*)(Obj,Sel))Message)(original,sel_registerName("CGRectValue"));
        Rect last=((Rect(*)(Obj,Sel))Message)(applied,sel_registerName("CGRectValue"));
        Rect current=((Rect(*)(Obj,Sel))Message)(glyph,sel_registerName("frame"));
        // A host relayout after our last decoration owns the newer frame.
        if (current.x==last.x && current.y==last.y && current.width==last.width && current.height==last.height)
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
    if (!Kind(view,"UIView")) return;
    Rect material=((Rect(*)(Obj,Sel))Message)(view,sel_registerName("bounds"));
    if (FQHIsDuration(view)) {
        double height=__builtin_fmin(material.height,32);
        material.y+=(material.height-height)*0.5;
        material.height=height;
    }
    ApplySurface(view,material,0);
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
static void BookstoreTopChrome(Obj controller);
static void TopChromeRefreshVisibility(Obj scroll);
static void HomeLayout(Obj self,Sel cmd) {
    ((void(*)(Obj,Sel))Original("SSBookStoreNewViewController","fqx165_originalRelayout"))(self,cmd);
    FQHHeader(Get(self,"searchBgView"));
    BookstoreTopChrome(self);
}
static void HomeAppear(Obj self,Sel cmd,B animated) {
    ((void(*)(Obj,Sel,B))Original("SSBookStoreNewViewController","fqx165_originalAppear:"))(self,cmd,animated);
    FQHHeader(Get(self,"searchBgView"));
    BookstoreTopChrome(self);
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
// The host control's configuration, image states, frame and size provider stay
// intact. Reviewed foreground image-view geometry can be refined and restored.
extern Obj AllocateClass(Obj,const char *,U) __asm__("_objc_allocateClassPair");
extern void RegisterClass(Obj) __asm__("_objc_registerClassPair");
extern void FQDRecord(const char *,Obj);
extern B FQDDiagnosticsEnabled(void) __asm__("_FQDGetDiagnosticSwitch");
extern void FQDSetDiagnosticsEnabled(B) __asm__("_FQDWriteDiagnosticSwitch");
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
static void TopChromeSurfaceKey(void) {}
static void TopChromeAnchorKey(void) {}
static void TopChromeTintKey(void) {}
static void TopChromeColorKey(void) {}
static void TopChromeOpaqueKey(void) {}
static void TopChromeArtworkAlphaKey(void) {}
static void TopChromeArtworkAppliedKey(void) {}
static void TopChromeGeometryKey(void) {}
static void BookstoreViewportKey(void) {}
static void BookstoreUnexpandedFrameKey(void) {}
static void BookstoreUnexpandedScrollKey(void) {}
static void TopChromeStockFrameKey(void) {}
static void TopChromeFrameKey(void) {}
static void TopChromeScrollKey(void) {}
static void TopChromeStockInsetKey(void) {}
static void TopChromeInsetKey(void) {}
static void TopChromeOwnerKey(void) {}
static void TopChromeEdgeHiddenKey(void) {}
static void TopChromeFill(Obj view,B enabled);
static void MountTopChrome(Obj root,Obj surface,Obj anchor,Rect material) {
    Obj parent=Get(anchor,"superview");
    if (parent!=root) material=Convert(root,material,parent);
    if (!SameRect(Frame(surface),material)) SetFrame(surface,material);
    if (Get(surface,"superview")!=parent || objc_getAssociatedObject(surface,TopChromeAnchorKey)!=anchor) {
        ((void(*)(Obj,Sel,Obj,Obj))Message)(parent,sel_registerName("insertSubview:belowSubview:"),surface,anchor);
        objc_setAssociatedObject(surface,TopChromeAnchorKey,anchor,1);
    }
}
static B TopChrome(Obj root,Obj foreground,Obj anchor,Rect material,B enabled) {
    Obj surface=objc_getAssociatedObject(root,TopChromeSurfaceKey);
    if (!enabled || !root || Get(foreground,"superview")!=root || !VisibleRect(material)) {
        V0(surface,"removeFromSuperview");
        objc_setAssociatedObject(surface,TopChromeAnchorKey,0,1);
        objc_setAssociatedObject(root,TopChromeSurfaceKey,0,1);
        return 0;
    }
    if (!surface) {
        // Preserve the live blur and soften the backdrop with a small adaptive fill.
        Obj effect=((Obj(*)(Obj,Sel,I))Message)(Lookup("UIBlurEffect"),sel_registerName("effectWithStyle:"),6);
        if (!effect) return 0;
        surface=O1(O0(Lookup("UIVisualEffectView"),"alloc"),"initWithEffect:",effect);
        if (!surface) return 0;
        VB(surface,"setUserInteractionEnabled:",0);
        VB(surface,"setAccessibilityElementsHidden:",1);
        VB(surface,"setOpaque:",0);
        Obj background=O0(Lookup("UIColor"),"systemBackgroundColor");
        Obj tint=((Obj(*)(Obj,Sel,double))Message)(background,sel_registerName("colorWithAlphaComponent:"),0.0625);
        V1(Get(surface,"contentView"),"setBackgroundColor:",tint);
        objc_setAssociatedObject(surface,TopChromeTintKey,tint,1);
        objc_setAssociatedObject(root,TopChromeSurfaceKey,surface,1);
        V0(surface,"release");
    }
    MountTopChrome(root,surface,anchor,material);
    return 1;
}
static B TopChromePage(Obj root,Obj foreground,Obj anchor,Obj scroll,Rect material,B enabled) {
    Obj old=objc_getAssociatedObject(root,TopChromeOwnerKey);
    B installed=TopChrome(root,foreground,anchor,material,enabled && Kind(scroll,"UIScrollView"));
    Obj owner=installed ? foreground : (Obj)0;
    if (old!=owner) {
        TopChromeFill(old,0);
        objc_setAssociatedObject(root,TopChromeOwnerKey,owner,1);
    }
    Obj edge=installed ? Get(scroll,"topEdgeEffect") : (Obj)0;
    Obj hiddenEdge=objc_getAssociatedObject(root,TopChromeEdgeHiddenKey);
    if (hiddenEdge && hiddenEdge!=edge) {
        VB(hiddenEdge,"setHidden:",0);
        objc_setAssociatedObject(root,TopChromeEdgeHiddenKey,0,1);
    }
    if (Responds(edge,"setHidden:") && !Flag(edge,"isHidden")) {
        objc_setAssociatedObject(root,TopChromeEdgeHiddenKey,edge,1);
        VB(edge,"setHidden:",1);
    }
    return installed;
}
static void TopChromeFill(Obj view,B enabled) {
    if (!Kind(view,"UIView")) return;
    Obj clear=O0(Lookup("UIColor"),"clearColor"),color=O0(view,"backgroundColor");
    Obj stock=objc_getAssociatedObject(view,TopChromeColorKey);
    Obj opaque=objc_getAssociatedObject(view,TopChromeOpaqueKey);
    if (enabled && Flag(view,"isOpaque")) {
        objc_setAssociatedObject(view,TopChromeOpaqueKey,BoolBox(1),1);
        VB(view,"setOpaque:",0);
    } else if (!enabled && opaque) {
        VB(view,"setOpaque:",1);
        objc_setAssociatedObject(view,TopChromeOpaqueKey,0,1);
    }
    if (enabled && color && !SameColor(color,clear)) {
        objc_setAssociatedObject(view,TopChromeColorKey,color,1);
        V1(view,"setBackgroundColor:",clear);
    } else if (!enabled && stock) {
        if (SameColor(color,clear)) V1(view,"setBackgroundColor:",stock);
        objc_setAssociatedObject(view,TopChromeColorKey,0,1);
    }
}
static B TopChromeContains(Obj viewport,Obj scroll) {
    if (!viewport || !Kind(scroll,"UIScrollView")) return 0;
    for (Obj view=scroll;view;view=Get(view,"superview"))
        if (view==viewport) return 1;
    return 0;
}
static void TopChromeArtwork(Obj artwork,Obj viewport,B enabled,double limit) {
    if (!Kind(artwork,"UIView")) return;
    Obj parent=Get(artwork,"superview");
    if (enabled && parent && Get(viewport,"superview")==parent) {
        Obj siblings=Get(parent,"subviews");
        Sel index=sel_registerName("indexOfObjectIdenticalTo:");
        U artworkIndex=((U(*)(Obj,Sel,Obj))Message)(siblings,index,artwork);
        U viewportIndex=((U(*)(Obj,Sel,Obj))Message)(siblings,index,viewport);
        enabled=artworkIndex>viewportIndex;
    } else enabled=0;
    double alpha=((double(*)(Obj,Sel))Message)(artwork,sel_registerName("alpha"));
    Obj stock=objc_getAssociatedObject(artwork,TopChromeArtworkAlphaKey);
    Obj applied=objc_getAssociatedObject(artwork,TopChromeArtworkAppliedKey);
    B owned=applied && alpha==Double(applied);
    double original=owned ? Double(stock) : alpha;
    double wanted=enabled ? __builtin_fmin(original,limit) : original;
    if (wanted!=original) {
        if (!owned) objc_setAssociatedObject(artwork,TopChromeArtworkAlphaKey,Number(original),1);
        if (!applied || wanted!=Double(applied))
            objc_setAssociatedObject(artwork,TopChromeArtworkAppliedKey,Number(wanted),1);
    } else if (applied) {
        objc_setAssociatedObject(artwork,TopChromeArtworkAlphaKey,0,1);
        objc_setAssociatedObject(artwork,TopChromeArtworkAppliedKey,0,1);
    }
    if (alpha!=wanted) ((void(*)(Obj,Sel,double))Message)(artwork,sel_registerName("setAlpha:"),wanted);
}
static void TopChromeInsets(Obj scroll,double overlap) {
    if (!scroll) return;
    Rect inset=((Rect(*)(Obj,Sel))Message)(scroll,sel_registerName("contentInset"));
    Obj applied=objc_getAssociatedObject(scroll,TopChromeInsetKey);
    double oldStock=Double(objc_getAssociatedObject(scroll,TopChromeStockInsetKey));
    double oldApplied=Double(applied);
    B hostWroteTop=applied && inset.x!=oldApplied;
    if (hostWroteTop && inset.x!=oldStock) {
        // MJRefresh changes the nested bookstore's already padded inset and
        // removes its own delta on rebound. Only an unpadded reset needs rebasing.
        Obj owner=Get(scroll,"delegate");
        if (Kind(owner,"SSBookStoreNestedTabView") && Get(owner,"containerScrollView")==scroll)
            hostWroteTop=0;
    }
    double stock=applied && !hostWroteTop ? oldStock : inset.x;
    double target=stock+overlap;
    double liveTop=applied && !hostWroteTop ? inset.x+(target-oldApplied) : target;
    if (overlap>0 && (!applied || hostWroteTop))
        objc_setAssociatedObject(scroll,TopChromeStockInsetKey,Number(stock),1);
    if (overlap>0 && (!applied || target!=oldApplied))
        objc_setAssociatedObject(scroll,TopChromeInsetKey,Number(target),1);
    if (overlap==0 && applied) {
        objc_setAssociatedObject(scroll,TopChromeStockInsetKey,0,1);
        objc_setAssociatedObject(scroll,TopChromeInsetKey,0,1);
    }
    if (liveTop!=inset.x || (hostWroteTop && overlap==0)) {
        Point offset=((Point(*)(Obj,Sel))Message)(scroll,sel_registerName("contentOffset"));
        Rect adjusted=((Rect(*)(Obj,Sel))Message)(scroll,sel_registerName("adjustedContentInset"));
        // A host relayout may have rewritten its stock inset while a book is
        // mid-scroll. Reapply the padding without shifting that visible book.
        if (!hostWroteTop || offset.y<=-adjusted.x+0.5) offset.y-=liveTop-inset.x;
        else offset.y-=overlap-(oldApplied-oldStock);
        if (liveTop!=inset.x) {
            inset.x=liveTop;
            ((void(*)(Obj,Sel,Rect))Message)(scroll,sel_registerName("setContentInset:"),inset);
        }
        Point actual=((Point(*)(Obj,Sel))Message)(scroll,sel_registerName("contentOffset"));
        if (actual.x!=offset.x || actual.y!=offset.y)
            ((void(*)(Obj,Sel,Point))Message)(scroll,sel_registerName("setContentOffset:"),offset);
    }
}
static Rect TopChromeStockFrame(Obj viewport,Rect current) {
    Obj applied=objc_getAssociatedObject(viewport,TopChromeFrameKey);
    Rect stock=current;
    if (applied && current.y==UnboxRect(applied).y) {
        stock.y=UnboxRect(objc_getAssociatedObject(viewport,TopChromeStockFrameKey)).y;
        stock.height+=current.y-stock.y;
    }
    return stock;
}
static void TopChromeUnderlap(Obj viewport,Obj scroll,double top,B enabled) {
    if (!Kind(viewport,"UIView")) return;
    Rect current=Frame(viewport),stock=TopChromeStockFrame(viewport,current);
    Obj applied=objc_getAssociatedObject(viewport,TopChromeFrameKey);
    double overlap=0;
    if (enabled && TopChromeContains(viewport,scroll) && VisibleRect(stock))
        overlap=__builtin_fmax(0,stock.y-top);
    Rect target={stock.x,stock.y-overlap,stock.width,stock.height+overlap};
    Obj previous=objc_getAssociatedObject(viewport,TopChromeScrollKey);
    if (applied && !previous) previous=viewport;
    if (previous && (previous!=scroll || overlap==0)) {
        TopChromeInsets(previous,0);
        TopChromeRefreshVisibility(previous);
    }
    if (overlap>0) {
        if (previous!=scroll) objc_setAssociatedObject(viewport,TopChromeScrollKey,scroll==viewport ? (Obj)0 : scroll,1);
        if (!applied || !SameRect(UnboxRect(applied),target)) {
            objc_setAssociatedObject(viewport,TopChromeStockFrameKey,RectBox(stock),1);
            objc_setAssociatedObject(viewport,TopChromeFrameKey,RectBox(target),1);
        }
    } else if (applied) {
        objc_setAssociatedObject(viewport,TopChromeStockFrameKey,0,1);
        objc_setAssociatedObject(viewport,TopChromeFrameKey,0,1);
        objc_setAssociatedObject(viewport,TopChromeScrollKey,0,1);
    }
    if (!SameRect(current,target)) SetFrame(viewport,target);
    if (overlap>0) TopChromeInsets(scroll,overlap);
}
static void Put(Obj dict,const char *key,Obj value);
static Obj RectArray(Rect rect);
static void TopChromeDiagnostics(Obj owner,const char *role,Obj root,Obj viewport,Obj scroll,B installed) {
    if (!FQDDiagnosticsEnabled()) return;
    if (!root || !viewport || !Get(root,"window")) return;
    Rect stock=TopChromeStockFrame(viewport,Frame(viewport));
    Rect pager=Convert(viewport,Bounds(viewport),root),visible={0};
    if (scroll) {
        visible=Convert(scroll,Bounds(scroll),root);
        for (Obj view=Get(scroll,"superview");view && view!=root;view=Get(view,"superview")) {
            if (!Flag(view,"clipsToBounds")) continue;
            Rect clip=Convert(view,Bounds(view),root);
            double x=__builtin_fmax(clip.x,visible.x),y=__builtin_fmax(clip.y,visible.y);
            double right=__builtin_fmin(clip.x+clip.width,visible.x+visible.width);
            double bottom=__builtin_fmin(clip.y+clip.height,visible.y+visible.height);
            visible=(Rect){x,y,__builtin_fmax(0,right-x),__builtin_fmax(0,bottom-y)};
        }
    }
    Rect fingerprint={pager.y,visible.y,pager.height,installed};
    Obj prior=objc_getAssociatedObject(owner,TopChromeGeometryKey);
    if (prior && SameRect(fingerprint,UnboxRect(prior))) return;
    objc_setAssociatedObject(owner,TopChromeGeometryKey,RectBox(fingerprint),1);
    Obj record=O0(Lookup("NSMutableDictionary"),"dictionary");
    Put(record,"role",Text(role));
    Put(record,"material",Text(installed ? "systemUltraThin" : "stock"));
    Put(record,"stockViewportFrame",RectArray(stock));
    Put(record,"viewportRect",RectArray(pager));
    Put(record,"scrollClipRect",RectArray(visible));
    FQDRecord("topChromeGeometry",record);
}
static Obj BookstoreScroll(Obj tab,Obj viewport) {
    Obj scroll=Get(tab,"doubleRowNestContainerScrollView");
    if (TopChromeContains(viewport,scroll)) return scroll;
    scroll=Get(tab,"collectionView");
    if (TopChromeContains(viewport,scroll)) return scroll;
    scroll=Get(tab,"doubleRowUnlimitedCollectionView");
    if (TopChromeContains(viewport,scroll)) return scroll;
    scroll=Get(tab,"listView");
    return TopChromeContains(viewport,scroll) ? scroll : (Obj)0;
}
static Obj BookstoreCurrentTab(Obj controller,Obj pager) {
    Obj tab=Get(pager,"currentSelectedListViewController");
    return tab ? tab : Get(controller,"currentTabVC");
}
static Obj BookstoreContentViewport(Obj tab,Obj pager,Obj scroll,Obj root) {
    Obj nested=Get(tab,"nestedView");
    if (Kind(nested,"SSBookStoreNestedTabView") && TopChromeContains(nested,scroll))
        return nested;
    // The flat list also reserves the search header in its own frame when the
    // pager itself already fills the page.
    if (Kind(tab,"SSBookStoreTabViewController") && scroll &&
        Get(scroll,"superview")==Get(tab,"viewIfLoaded") &&
        Convert(pager,Bounds(pager),root).y==Bounds(root).y) return scroll;
    return pager;
}
static void BookstoreTopChrome(Obj controller) {
    Obj header=Get(controller,"simpleHeader"),root=Get(header,"superview");
    Obj pager=Get(controller,"containerView"),tab=BookstoreCurrentTab(controller,pager);
    Obj tabs=Get(controller,"simpleTabView");
    Obj scroll=BookstoreScroll(tab,pager);
    Obj viewport=BookstoreContentViewport(tab,pager,scroll,root),parent=Get(viewport,"superview");
    Rect frame=Frame(header),bounds=Bounds(root);
    Rect tabFrame=Convert(tabs,Bounds(tabs),root);
    Rect stock=TopChromeStockFrame(pager,Frame(pager));
    double bottom=__builtin_fmax(frame.y+frame.height,tabFrame.y+tabFrame.height);
    if (Get(pager,"superview")==root) bottom=__builtin_fmax(bottom,stock.y);
    B enabled=root && Enabled() && Belongs(pager,root) && scroll && !Flag(header,"isHidden");
    B installed=TopChromePage(root,header,header,scroll,(Rect){bounds.x,bounds.y,bounds.width,bottom-bounds.y},enabled);
    TopChromeFill(header,installed);
    TopChromeFill(Get(controller,"tabContainer"),installed);
    TopChromeFill(Get(controller,"signBgView"),installed);
    TopChromeFill(tabs,installed);
    TopChromeFill(Get(tabs,"collectionView"),installed);
    TopChromeArtwork(Get(controller,"backgroundView"),pager,installed,0.25);
    Obj previous=objc_getAssociatedObject(controller,BookstoreViewportKey);
    Obj owned=installed ? viewport : (Obj)0;
    if (previous!=owned) {
        V0(previous,"retain");
        objc_setAssociatedObject(controller,BookstoreViewportKey,owned,1);
        if (previous) TopChromeUnderlap(previous,0,0,0);
        V0(previous,"release");
    }
    TopChromeUnderlap(viewport,scroll,Convert(root,bounds,parent).y,installed);
    Obj unexpandedScroll=objc_getAssociatedObject(controller,BookstoreUnexpandedScrollKey);
    if (installed && !objc_getAssociatedObject(viewport,TopChromeFrameKey)) {
        Rect frame=Frame(viewport);
        Obj remembered=objc_getAssociatedObject(controller,BookstoreUnexpandedFrameKey);
        if (!remembered || !SameRect(frame,UnboxRect(remembered)))
            objc_setAssociatedObject(controller,BookstoreUnexpandedFrameKey,RectBox(frame),1);
        if (unexpandedScroll!=scroll)
            objc_setAssociatedObject(controller,BookstoreUnexpandedScrollKey,scroll,1);
    } else if (unexpandedScroll) {
        objc_setAssociatedObject(controller,BookstoreUnexpandedFrameKey,0,1);
        objc_setAssociatedObject(controller,BookstoreUnexpandedScrollKey,0,1);
    }
    TopChromeRefreshVisibility(scroll);
    TopChromeDiagnostics(controller,"bookstore",root,viewport,scroll,installed);
}
static void BookstoreTabSelected(Obj self,Sel cmd,Obj category,I index) {
    ((void(*)(Obj,Sel,Obj,I))Original("SSBookStoreNewViewController","fqx186_originalStoreSelected:index:"))(self,cmd,category,index);
    BookstoreTopChrome(self);
}
static void BookstoreCollectionLayout(Obj self,Sel cmd) {
    ((void(*)(Obj,Sel))Original("SSBookStoreTabViewController","fqx186_originalStoreCollectionLayout"))(self,cmd);
    Obj controller=Get(self,"delegate");
    if (Kind(controller,"SSBookStoreNewViewController") &&
        BookstoreCurrentTab(controller,Get(controller,"containerView"))==self)
        BookstoreTopChrome(controller);
}
static void BookstoreCollectionScroll(Obj self,Sel cmd,Obj scroll) {
    ((void(*)(Obj,Sel,Obj))Original("SSBookStoreTabViewController","fqx188_originalStoreCollectionScroll:"))(self,cmd,scroll);
    if (Get(self,"collectionView")==scroll) TopChromeRefreshVisibility(scroll);
}
static void BookstoreDoubleRowLayout(Obj self,Sel cmd) {
    ((void(*)(Obj,Sel))Original("SSBookStoreDoubleRowViewController","fqx187_originalStoreDoubleRowLayout"))(self,cmd);
    Obj controller=Get(self,"delegate");
    Obj pager=Get(controller,"containerView");
    if (Kind(controller,"SSBookStoreNewViewController") &&
        BookstoreCurrentTab(controller,pager)==self)
        BookstoreTopChrome(controller);
}
static void BookstoreDoubleRowScroll(Obj self,Sel cmd,Obj scroll) {
    ((void(*)(Obj,Sel,Obj))Original("SSBookStoreDoubleRowViewController","fqx187_originalStoreDoubleRowScroll:"))(self,cmd,scroll);
    Obj controller=Get(self,"delegate");
    if (!Kind(controller,"SSBookStoreNewViewController")) return;
    Obj nested=Get(self,"doubleRowNestContainerScrollView");
    Obj viewport=objc_getAssociatedObject(controller,BookstoreViewportKey);
    Obj applied=objc_getAssociatedObject(viewport,TopChromeFrameKey);
    B repair;
    if (applied) {
        repair=!SameRect(Frame(viewport),UnboxRect(applied));
    } else if (viewport) {
        // A viewport that already fills the page has no applied frame. Reuse
        // its last geometry only while the same nested scroll stays mounted.
        Obj remembered=objc_getAssociatedObject(controller,BookstoreUnexpandedFrameKey);
        repair=!remembered || !nested || nested!=objc_getAssociatedObject(controller,BookstoreUnexpandedScrollKey) ||
            !SameRect(Frame(viewport),UnboxRect(remembered)) || !Enabled();
    } else {
        repair=Enabled();
    }
    if (repair && BookstoreCurrentTab(controller,Get(controller,"containerView"))==self) {
        BookstoreTopChrome(controller);
        nested=Get(self,"doubleRowNestContainerScrollView");
    }
    if (nested==scroll) TopChromeRefreshVisibility(scroll);
}
static double TopChromeOverlap(Obj scroll) {
    return Double(objc_getAssociatedObject(scroll,TopChromeInsetKey))-
        Double(objc_getAssociatedObject(scroll,TopChromeStockInsetKey));
}
static void ShelfChromeCanvasRowKey(void) {}
static Obj BookshelfCanvas(Obj tab) {
    Obj colors=Lookup("UIColor"),canvas=Get(Get(Get(tab,"viewModel"),"uiConfigParams"),"backgroundColor");
    if (!canvas && Responds(colors,"fq_reader_saas_ColorWithName:"))
        canvas=O1(colors,"fq_reader_saas_ColorWithName:",Text("SS_COLOR_BG_FF"));
    return canvas ? canvas : O0(colors,"systemBackgroundColor");
}
static void BookshelfRestingTint(Obj tab,Obj scroll) {
    Obj owner=Get(tab,"delegate");
    if (!Kind(owner,"SSBookShelf525ViewController") || Get(owner,"currentTabVC")!=tab || !scroll) return;
    Obj root=Get(owner,"view"),surface=objc_getAssociatedObject(root,TopChromeSurfaceKey);
    Obj content=Get(surface,"contentView");
    if (!content) return;
    Point offset=((Point(*)(Obj,Sel))Message)(scroll,sel_registerName("contentOffset"));
    Rect inset=((Rect(*)(Obj,Sel))Message)(scroll,sel_registerName("adjustedContentInset"));
    // At rest the empty strip behind the blur samples the header artwork, while
    // the first row uses the shelf canvas. Blend back to live glass as books enter.
    double distance=__builtin_fabs(offset.y+inset.x);
    double blend=distance<16 && !Flag(Get(scroll,"mj_header"),"isRefreshing") ? 1-distance/16 : 0;
    Obj tint=objc_getAssociatedObject(surface,TopChromeTintKey);
    Obj canvasRow=objc_getAssociatedObject(root,ShelfChromeCanvasRowKey);
    if (canvasRow) {
        Obj canvas=Get(canvasRow,"backgroundColor");
        tint=canvas && !SameColor(canvas,O0(Lookup("UIColor"),"clearColor")) ? canvas : BookshelfCanvas(tab);
    } else if (blend>0) {
        Obj canvas=BookshelfCanvas(tab);
        tint=blend==1 ? canvas : ((Obj(*)(Obj,Sel,double))Message)(canvas,
            sel_registerName("colorWithAlphaComponent:"),0.0625+0.9375*blend);
    }
    if (!SameColor(Get(content,"backgroundColor"),tint)) V1(content,"setBackgroundColor:",tint);
}
static void ShelfChromeHolderKey(void) {}
static void ShelfChromeFilterKey(void) {}
static void ShelfChromeClipKey(void) {}
static void ShelfChromeLayoutKey(void) {}
static void BookshelfHeaderActions(Obj controller);
static Rect BookshelfChromeFrame(Obj root,Obj header,Obj viewport) {
    Rect frame=Frame(header),bounds=Bounds(root);
    Rect stock=TopChromeStockFrame(viewport,Frame(viewport));
    return (Rect){bounds.x,bounds.y,bounds.width,__builtin_fmax(frame.y+frame.height,stock.y)-bounds.y};
}
static Obj At(Obj array,U index);
static B BookshelfFilterAtEdge(Obj row,Obj root,Rect title) {
    if (Flag(row,"isHidden")) return 0;
    Rect bounds=Convert(row,Bounds(row),root);
    double edge=title.y+title.height;
    return VisibleRect(bounds) && bounds.x<=title.x+1 &&
        bounds.x+bounds.width>=title.x+title.width-1 &&
        bounds.y<=edge+1 && bounds.y+bounds.height>edge+1;
}
static Obj BookshelfChromeRow(Obj root,Obj tab,Obj scroll,Rect title) {
    Obj holder=Get(tab,"fullGenreFloatingContainerView"),parent=Get(holder,"superview");
    if (parent && parent==Get(tab,"viewIfLoaded") && Belongs(parent,root) &&
        BookshelfFilterAtEdge(holder,root,title) &&
        Belongs(Get(Get(tab,"functionCell"),"layoutContainerView"),holder)) return holder;
    // UIKit section-header pinning also shows the filter directly in the collection.
    if (!Responds(scroll,"visibleSupplementaryViewsOfKind:")) return 0;
    Obj headers=O1(scroll,"visibleSupplementaryViewsOfKind:",Text("UICollectionElementKindSectionHeader"));
    U count=((U(*)(Obj,Sel))Message)(headers,sel_registerName("count"));
    for (U i=0;i<count;++i) {
        Obj row=At(headers,i);
        if (Kind(row,"SSBookShelfFilterHeaderView") && Belongs(row,scroll) &&
            BookshelfFilterAtEdge(row,root,title)) return row;
    }
    return 0;
}
static Obj BookshelfChromeAnchor(Obj root,Obj header,Obj row,Rect *material) {
    if (!row) return header;
    Obj parent=Get(row,"superview");
    Rect bounds=Convert(row,Bounds(row),root);
    double bottom=bounds.y+bounds.height;
    // Keep the shared effect above the collection and below the native filter.
    // If any page container still clips the title region, retain the root mount.
    for (Obj view=parent;view && view!=root;view=Get(view,"superview")) {
        if (!Flag(view,"clipsToBounds")) continue;
        Rect clip=Convert(view,Bounds(view),root);
        if (clip.y>material->y || clip.y+clip.height<bottom ||
            clip.x>material->x || clip.x+clip.width<material->x+material->width) return header;
    }
    material->height=bottom-material->y;
    return row;
}
static void BookshelfChromeFills(Obj root,Obj tab,Obj holder) {
    Obj filter=holder && !Kind(holder,"SSBookShelfFilterHeaderView") ? Get(Get(tab,"functionCell"),"headerView") : (Obj)0;
    if (filter && !Belongs(filter,holder)) filter=0;
    Obj oldHolder=objc_getAssociatedObject(root,ShelfChromeHolderKey);
    Obj oldFilter=objc_getAssociatedObject(root,ShelfChromeFilterKey);
    Obj cell=Get(tab,"functionCell");
    Obj layout=Get(cell,"layoutContainerView"),clip=Get(cell,"filterClipView");
    if (!holder || !Belongs(layout,holder)) layout=0;
    if (!holder || !Belongs(clip,holder)) clip=0;
    if (oldHolder!=holder) {
        TopChromeFill(oldHolder,0);
        objc_setAssociatedObject(root,ShelfChromeHolderKey,holder,1);
    }
    if (oldFilter!=filter) {
        TopChromeFill(oldFilter,0);
        objc_setAssociatedObject(root,ShelfChromeFilterKey,filter,1);
    }
    Obj oldClip=objc_getAssociatedObject(root,ShelfChromeClipKey);
    if (oldClip!=clip) {
        TopChromeFill(oldClip,0);
        objc_setAssociatedObject(root,ShelfChromeClipKey,clip,1);
    }
    Obj oldLayout=objc_getAssociatedObject(root,ShelfChromeLayoutKey);
    if (oldLayout!=layout) {
        TopChromeFill(oldLayout,0);
        objc_setAssociatedObject(root,ShelfChromeLayoutKey,layout,1);
    }
    TopChromeFill(holder,1);
    TopChromeFill(filter,1);
    TopChromeFill(clip,1);
    TopChromeFill(layout,1);
}
static void BookshelfUpdateChrome(Obj controller,Obj root,Obj header,Obj viewport,Obj tab,Obj scroll,Rect material,B installed) {
    Obj row=installed ? BookshelfChromeRow(root,tab,scroll,material) : (Obj)0;
    Obj anchor=BookshelfChromeAnchor(root,header,row,&material);
    if (installed)
        MountTopChrome(root,objc_getAssociatedObject(root,TopChromeSurfaceKey),anchor,material);
    BookshelfChromeFills(root,tab,anchor!=header ? anchor : (Obj)0);
    Obj canvasRow=row && anchor==header ? row : (Obj)0;
    if (objc_getAssociatedObject(root,ShelfChromeCanvasRowKey)!=canvasRow)
        objc_setAssociatedObject(root,ShelfChromeCanvasRowKey,canvasRow,1);
    TopChromeArtwork(Get(controller,"headerBgImgView"),viewport,installed,row ? 0 : 0.25);
    if (installed) BookshelfRestingTint(tab,scroll);
}
static void BookshelfTopChrome(Obj controller) {
    Obj root=Get(controller,"view"),header=Get(controller,"headerView");
    Obj viewport=Get(controller,"containerView"),tab=Get(controller,"currentTabVC");
    Obj scroll=Get(tab,"collectionView");
    Rect base=BookshelfChromeFrame(root,header,viewport),material=base;
    B enabled=Enabled() && Kind(tab,"SSBookShelfSubViewController") &&
        Get(viewport,"superview")==root && TopChromeContains(viewport,scroll);
    Obj row=enabled ? BookshelfChromeRow(root,tab,scroll,material) : (Obj)0;
    Obj anchor=BookshelfChromeAnchor(root,header,row,&material);
    B installed=TopChromePage(root,header,anchor,scroll,material,enabled);
    Obj tabs=Get(controller,"tabSelectView");
    TopChromeFill(header,installed);
    TopChromeFill(tabs,installed);
    TopChromeFill(Get(tabs,"collectionView"),installed);
    TopChromeFill(Get(controller,"headerBackgroundView"),installed);
    B owned=objc_getAssociatedObject(scroll,TopChromeInsetKey)!=0;
    TopChromeUnderlap(viewport,scroll,base.y,installed);
    if (owned!=(objc_getAssociatedObject(scroll,TopChromeInsetKey)!=0) &&
        Responds(tab,"fqx186_originalShelfFloating:"))
        V1(tab,"updateFullGenreFloatingViewWithScrollView:",scroll);
    BookshelfUpdateChrome(controller,root,header,viewport,tab,scroll,base,installed);
    BookshelfHeaderActions(controller);
    TopChromeDiagnostics(controller,"bookshelf",root,viewport,scroll,installed);
}
void FQHShelf(Obj self);
static void BookshelfTopLayout(Obj self,Sel cmd) {
    ((void(*)(Obj,Sel))Original("SSBookShelf525ViewController","fqx186_originalShelfTopLayout"))(self,cmd);
    BookshelfTopChrome(self);
}
static void BookshelfTabSelected(Obj self,Sel cmd,Obj category,I index) {
    ((void(*)(Obj,Sel,Obj,I))Original("SSBookShelf525ViewController","fqx186_originalShelfSelected:index:"))(self,cmd,category,index);
    BookshelfTopChrome(self);
}
static void BookshelfSyncHistoryPager(Obj viewport,B animationEnded);
static void ShelfApplyPendingMotionComic(Obj controller);
static Obj BookshelfHistoryAtIndex(Obj owner,I index) {
    if (index<0) return 0;
    Obj controllers=Get(owner,"tabVCs");
    U count=((U(*)(Obj,Sel))Message)(controllers,sel_registerName("count"));
    Obj tab=(U)index<count ? At(controllers,(U)index) : (Obj)0;
    return Kind(tab,"SSBookHistorySubViewController") ? tab : (Obj)0;
}
static B BookshelfSelectTitle(Obj self,Sel cmd,I index,U selectionType,B animated) {
    // The host moves its pager before committing the title. A direct History
    // tap settles in that same turn so a previous cached page cannot flash.
    if (animated && selectionType==1 && Enabled()) {
        Obj owner=Get(self,"delegate");
        if (Kind(owner,"SSBookShelf525ViewController") && BookshelfHistoryAtIndex(owner,index))
            animated=0;
    }
    return ((B(*)(Obj,Sel,I,U,B))Original("SSBookShelfTabSelectView",
        "fqx_originalShelfSelectTitle:type:animation:"))(self,cmd,index,selectionType,animated);
}
static void BookshelfInstallTitleSelection(void) {
    Obj cls=Lookup("SSBookShelfTabSelectView");
    const char *selector="executeSelectCellAtIndex:selectedType:needAnimation:",*type="B36@0:8q16Q24B32";
    Sel entry=sel_registerName(selector),alias=sel_registerName("fqx_originalShelfSelectTitle:type:animation:");
    if (!ClassABI(cls,selector,type) || class_getInstanceMethod(cls,alias)) return;
    Method original=class_getInstanceMethod(cls,entry);
    if (class_addMethod(cls,alias,method_getImplementation(original),type))
        class_addMethod(cls,entry,(Imp)BookshelfSelectTitle,type);
}
static void BookshelfTabCommitted(Obj self,Sel cmd,Obj category,I index) {
    ((void(*)(Obj,Sel,Obj,I))Original("SSBookShelf525ViewController",
        "fqx_originalShelfCommitted:index:"))(self,cmd,category,index);
    // The shared pager still carries the previous tab's geometry until the
    // host updates currentTabVC in this common selection callback.
    BookshelfTopChrome(self);
    Obj viewport=Get(self,"containerView");
    if (Responds(viewport,"fqx_originalHistoryPagerLayout")) BookshelfSyncHistoryPager(viewport,0);
    ShelfApplyPendingMotionComic(Get(self,"currentTabVC"));
}
static void BookshelfHistoryAppear(Obj self,Sel cmd,B animated) {
    ((void(*)(Obj,Sel,B))Original("SSBookShelf525ViewController","fqx_originalHistoryShelfAppear:"))(self,cmd,animated);
    BookshelfSyncHistoryPager(Get(self,"containerView"),0);
    ShelfApplyPendingMotionComic(Get(self,"currentTabVC"));
}
static void BookshelfHistorySyncKey(void) {}
static void BookshelfSyncHistoryPager(Obj viewport,B animationEnded) {
    Obj owner=Get(viewport,"delegate");
    if (!Kind(owner,"SSBookShelf525ViewController") || Get(owner,"containerView")!=viewport ||
        !Get(viewport,"window") || objc_getAssociatedObject(viewport,BookshelfHistorySyncKey) || !Enabled()) return;
    Obj tabs=Get(owner,"tabSelectView"),scroll=Get(viewport,"scrollView");
    if (!tabs || !scroll || Flag(scroll,"isTracking") || Flag(scroll,"isDragging") ||
        Flag(scroll,"isDecelerating") || (!animationEnded && Flag(scroll,"isScrollAnimating"))) return;
    I index=((I(*)(Obj,Sel))Message)(tabs,sel_registerName("selectedIndex"));
    Obj history=BookshelfHistoryAtIndex(owner,index);
    if (!history) return;

    double width=Bounds(scroll).width;
    if (width<=0) return;
    I ownerIndex=((I(*)(Obj,Sel))Message)(owner,sel_registerName("currentTabIndex"));
    I current=((I(*)(Obj,Sel))Message)(viewport,sel_registerName("currentIndex"));
    Obj active=Get(viewport,"currentSelectedListViewController");
    B ownerMismatch=ownerIndex!=index || Get(owner,"currentTabVC")!=history;
    Point offset=((Point(*)(Obj,Sel))Message)(scroll,sel_registerName("contentOffset"));
    if (!ownerMismatch && current==index && active==history && __builtin_fabs(offset.x-index*width)<=0.5) return;

    // Native selection or offset changes can synchronously reenter the pager.
    objc_setAssociatedObject(viewport,BookshelfHistorySyncKey,BoolBox(1),1);
    if (ownerMismatch) {
        ((void(*)(Obj,Sel,Obj,I))Message)(owner,sel_registerName("categoryView:didSelectedItemAtIndex:"),tabs,index);
        current=((I(*)(Obj,Sel))Message)(viewport,sel_registerName("currentIndex"));
        active=Get(viewport,"currentSelectedListViewController");
    }
    if (current!=index) {
        Q1(viewport,"didClickSelectedItemAtIndex:",index);
        active=Get(viewport,"currentSelectedListViewController");
    }
    if (active!=history) {
        // A tab rebuild can leave this slot empty or holding a previous controller.
        if (active) Q1(viewport,"cleanValidListWithIndex:",index);
        Q1(viewport,"listWillAppear:",index);
        Q1(viewport,"listDidAppear:",index);
    }
    V0(viewport,"clampScrollViewToCurrentIndexIfNeeded");
    objc_setAssociatedObject(viewport,BookshelfHistorySyncKey,0,1);
}
static void BookshelfHistoryPagerLayout(Obj self,Sel cmd) {
    ((void(*)(Obj,Sel))Original("FQRJXCategoryListContainerView","fqx_originalHistoryPagerLayout"))(self,cmd);
    BookshelfSyncHistoryPager(self,0);
}
static void BookshelfHistoryPagerStopped(Obj self,Sel cmd) {
    ((void(*)(Obj,Sel))Original("FQRJXCategoryListContainerView","fqx_originalHistoryPagerStopped"))(self,cmd);
    BookshelfSyncHistoryPager(self,0);
}
static void BookshelfHistoryPagerAnimationEnded(Obj self,Sel cmd,Obj scroll) {
    (void)cmd;
    if (Get(self,"scrollView")==scroll) BookshelfSyncHistoryPager(self,1);
}
static void RestoreBookshelfTopInset(Obj self) {
    Obj scroll=Get(self,"collectionView");
    double overlap=TopChromeOverlap(scroll);
    if (overlap>0) TopChromeInsets(scroll,overlap);
}
static void BookshelfUpdateInsets(Obj self,Sel cmd) {
    ((void(*)(Obj,Sel))Original("SSBookShelfSubViewController","fqx186_originalShelfUpdateInsets"))(self,cmd);
    RestoreBookshelfTopInset(self);
}
static void BookshelfFloatingLayout(Obj self,Sel cmd,Obj scroll) {
    ((void(*)(Obj,Sel,Obj))Original("SSBookShelfSubViewController","fqx186_originalShelfFloating:"))(self,cmd,scroll);
    if (!scroll || scroll!=Get(self,"collectionView") || !Enabled() ||
        !objc_getAssociatedObject(scroll,TopChromeInsetKey)) return;
    Obj owner=Get(self,"delegate"),root=Get(owner,"view");
    Obj surface=objc_getAssociatedObject(root,TopChromeSurfaceKey);
    if (!surface || Get(owner,"currentTabVC")!=self) return;
    Obj header=Get(owner,"headerView"),viewport=Get(owner,"containerView");
    Rect material=BookshelfChromeFrame(root,header,viewport);
    Obj holder=Get(self,"fullGenreFloatingContainerView"),parent=Get(holder,"superview");
    if (parent && !Flag(holder,"isHidden") && Belongs(parent,root)) {
        // Use the title row's fixed edge, even when the shared effect extends
        // under the pinned filter. Do not feed the extended height into pinning.
        Rect chrome=Convert(root,material,parent),frame=Frame(holder);
        double top=chrome.y+chrome.height;
        if (frame.y!=top) { frame.y=top; SetFrame(holder,frame); }
    }
    BookshelfUpdateChrome(owner,root,header,viewport,self,scroll,material,1);
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
    if (!FQDDiagnosticsEnabled()) return;
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
    if (!FQDDiagnosticsEnabled()) return;
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
// 1.78 changes the foreground of these inspected controls, never the reader
// body. Keep the native font family/weight and restore only values we still own.
static void AppearanceFontStockKey(void) {}
static void AppearanceFontAppliedKey(void) {}
static void AppearanceLabelKey(void) {}
static void ReaderShareViewKey(void) {}
static void ReaderShareResolutionKey(void) {}
static void ReaderShareHitParentsKey(void) {}
static void RestoreAppearanceFont(Obj label) {
    Obj applied=objc_getAssociatedObject(label,AppearanceFontAppliedKey);
    if (!applied) return;
    Obj current=Get(label,"font"),original=objc_getAssociatedObject(label,AppearanceFontStockKey);
    if (SameColor(current,applied) && original) V1(label,"setFont:",original);
    objc_setAssociatedObject(label,AppearanceFontStockKey,0,1);
    objc_setAssociatedObject(label,AppearanceFontAppliedKey,0,1);
}
static B HasCaptionAttributes(Obj text) {
    U length=((U(*)(Obj,Sel))Message)(text,sel_registerName("length"));
    if (!length) return 0;
    U range[2]={0};
    Obj attributes=((Obj(*)(Obj,Sel,U,U *))Message)(text,sel_registerName("attributesAtIndex:effectiveRange:"),0,range);
    return range[1]!=length || ((U(*)(Obj,Sel))Message)(attributes,sel_registerName("count"))!=0;
}
static void AppearanceFont(Obj label,double maximum) {
    if (!Kind(label,"UILabel") || !Responds(label,"setFont:")) return;
    Obj current=Get(label,"font");
    if (!current || !Responds(current,"pointSize") || !Responds(current,"fontWithSize:")) return;
    Obj applied=objc_getAssociatedObject(label,AppearanceFontAppliedKey);
    B ours=applied && SameColor(current,applied);
    Obj original=ours ? objc_getAssociatedObject(label,AppearanceFontStockKey) : current;
    double size=((double(*)(Obj,Sel))Message)(original,sel_registerName("pointSize"));
    if (!__builtin_isfinite(size) || size<=0) return;
    // UIKit also exposes plain label text as an unstyled attributed string.
    // Leave captions with explicit runs under the host's styling.
    if (size<=maximum || HasCaptionAttributes(Get(label,"attributedText"))) { RestoreAppearanceFont(label); return; }
    if (ours && ((double(*)(Obj,Sel))Message)(current,sel_registerName("pointSize"))==maximum) return;
    Obj font=((Obj(*)(Obj,Sel,double))Message)(original,sel_registerName("fontWithSize:"),maximum);
    if (!font) return;
    if (!ours) objc_setAssociatedObject(label,AppearanceFontStockKey,current,1);
    objc_setAssociatedObject(label,AppearanceFontAppliedKey,font,1);
    V1(label,"setFont:",font);
}
static void TrackAppearanceLabel(Obj owner,Obj label,double maximum) {
    Obj previous=objc_getAssociatedObject(owner,AppearanceLabelKey);
    if (previous!=label) {
        RestoreAppearanceFont(previous);
        // Standalone download/shelf labels are their own owner; do not retain
        // the label through an associated self-reference when the page closes.
        objc_setAssociatedObject(owner,AppearanceLabelKey,label,label==owner ? 0 : 1);
    }
    if (label) AppearanceFont(label,maximum);
}
static Rect MinimumHitRect(Rect rect,double minimum) {
    if (rect.width<minimum) { rect.x-=(minimum-rect.width)*0.5; rect.width=minimum; }
    if (rect.height<minimum) { rect.y-=(minimum-rect.height)*0.5; rect.height=minimum; }
    return rect;
}
static void RestoreReaderShelfFrame(Obj label) {
    Obj styled=objc_getAssociatedObject(label,ReaderShelfStyledFrameKey);
    if (!styled) return;
    if (SameRect(Frame(label),UnboxRect(styled)))
        SetFrame(label,UnboxRect(objc_getAssociatedObject(label,ReaderShelfStockFrameKey)));
    objc_setAssociatedObject(label,ReaderShelfStockFrameKey,0,1);
    objc_setAssociatedObject(label,ReaderShelfStyledFrameKey,0,1);
}
static void ReaderBackInsetsKey(void) {}
static void ReaderBackAppliedInsetsKey(void) {}
static void RestoreReaderBackInsets(Obj button) {
    Obj applied=objc_getAssociatedObject(button,ReaderBackAppliedInsetsKey);
    if (!applied) return;
    Rect current=((Rect(*)(Obj,Sel))Message)(button,sel_registerName("imageEdgeInsets"));
    if (SameRect(current,UnboxRect(applied)))
        ((void(*)(Obj,Sel,Rect))Message)(button,sel_registerName("setImageEdgeInsets:"),
            UnboxRect(objc_getAssociatedObject(button,ReaderBackInsetsKey)));
    objc_setAssociatedObject(button,ReaderBackInsetsKey,0,1);
    objc_setAssociatedObject(button,ReaderBackAppliedInsetsKey,0,1);
}
static void ReaderBackImageInsets(Obj button,Rect base,Rect target) {
    Rect current=((Rect(*)(Obj,Sel))Message)(button,sel_registerName("imageEdgeInsets"));
    Obj applied=objc_getAssociatedObject(button,ReaderBackAppliedInsetsKey);
    Obj original=objc_getAssociatedObject(button,ReaderBackInsetsKey);
    if (!original || !applied || !SameRect(current,UnboxRect(applied))) {
        original=RectBox(current);
        objc_setAssociatedObject(button,ReaderBackInsetsKey,original,1);
    }
    Rect stock=UnboxRect(original);
    // UIEdgeInsets are top, left, bottom, right. The actual plain UIButton
    // reuses these in its own late layout, after the navigation parent lays out.
    Rect wanted={stock.x+target.y-base.y,stock.y+target.x-base.x,
        stock.width+base.y+base.height-target.y-target.height,
        stock.height+base.x+base.width-target.x-target.width};
    if (!SameRect(current,wanted))
        ((void(*)(Obj,Sel,Rect))Message)(button,sel_registerName("setImageEdgeInsets:"),wanted);
    if (!applied || !SameRect(UnboxRect(applied),wanted))
        objc_setAssociatedObject(button,ReaderBackAppliedInsetsKey,RectBox(wanted),1);
}
static void RestoreIcon(Obj view,Obj glass) {
    TrackAppearanceLabel(view,0,0);
    RestoreReaderShelfFrame(view);
    RestoreReaderBackInsets(view);
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
    return (Rect){bounds.x-6-shift,bounds.y+(bounds.height-34)*0.5,bounds.width+12+2*shift,34};
}
typedef enum { IconNone, IconGeneric, IconReaderBack, IconReaderMore, IconReaderSearch,
    IconReaderDownload, IconReaderCommunity, IconReaderChapter, IconReaderShelf, IconShelfSearch, IconShelfMore,
    IconReaderShare, IconShelfStandaloneSearch } IconRole;
static const char *IconRoleName(IconRole role) {
    switch (role) {
        case IconReaderBack: return "readerBack";
        case IconReaderMore: return "readerMore";
        case IconReaderSearch: return "readerSearch";
        case IconReaderDownload: return "readerDownload";
        case IconReaderCommunity: return "readerCommunity";
        case IconReaderShare: return "readerShare";
        case IconReaderChapter: return "readerChapter";
        case IconReaderShelf: return "readerShelf";
        case IconShelfSearch: return "shelfSearch";
        case IconShelfStandaloneSearch: return "shelfSearch";
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
    if (!glyph && role==IconReaderShare) {
        // A gesture-backed share view can expose one image instead of a
        // UIButton imageView. Keep layered artwork unchanged when ambiguous.
        Obj children=Get(view,"subviews");
        U count=((U(*)(Obj,Sel))Message)(children,sel_registerName("count"));
        if (count<=8) for (U i=0;i<count;++i) {
            Obj child=At(children,i);
            if (!Kind(child,"UIImageView") || Flag(child,"isHidden") || !VisibleRect(Bounds(child))) continue;
            if (glyph) { glyph=0; break; }
            glyph=child;
        }
    }
    if (glyph && Belongs(glyph,view) && !Flag(glyph,"isHidden") && VisibleRect(Bounds(glyph))) {
        Rect measured=Convert(glyph,Bounds(glyph),view);
        if (VisibleRect(measured)) image=measured;
    }
    B back=role==IconReaderBack;
    B shelf=role==IconShelfSearch || role==IconShelfStandaloneSearch || role==IconShelfMore;
    B readerIcon=back || role==IconReaderMore || role==IconReaderSearch || role==IconReaderDownload ||
                 role==IconReaderCommunity || role==IconReaderShare;
    if ((readerIcon || shelf) && glyph && Belongs(glyph,view)) {
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
        if (readerIcon) {
            double longest=__builtin_fmax(base.width,base.height);
            double scale=longest>18 ? 18/longest : 1;
            adjusted.width=base.width*scale; adjusted.height=base.height*scale;
            adjusted.x+=(base.width-adjusted.width)*0.5;
            adjusted.y+=(base.height-adjusted.height)*0.5;
            if (back) {
                // The host's reading_navigation_button_back_opt is a 24pt
                // canvas with left-aligned artwork. Its alpha bounds at both
                // @2x and @3x have their horizontal center at 5.5pt. Center
                // that artwork, not the transparent image-view canvas.
                adjusted.x=bounds.x+bounds.width*0.5+6-adjusted.width*(5.5/24.0);
                adjusted.y=bounds.y+bounds.height*0.5-adjusted.height*0.5;
                ReaderBackImageInsets(view,base,adjusted);
            }
        } else {
            double scale=__builtin_fmin(1,20/__builtin_fmax(base.width,base.height));
            adjusted.width=base.width*scale; adjusted.height=base.height*scale;
            adjusted.x=bounds.x+(bounds.width-adjusted.width)*0.5-(role==IconShelfSearch ? 12 : 0);
            adjusted.y=bounds.y+(bounds.height-adjusted.height)*0.5;
            // bookshelf_more's alpha center is 39.5/48 at @2x and 59.5/72
            // at @3x: the three dots occupy the right of a transparent canvas.
            if (role==IconShelfMore) adjusted.x-=adjusted.width*0.325;
        }
        if (!SameRect(current,adjusted)) SetFrame(glyph,adjusted);
        if (!applied || !SameRect(previous,adjusted)) objc_setAssociatedObject(glyph,GlyphAppliedKey,RectBox(adjusted),1);
        if (newGlyph) objc_setAssociatedObject(view,GlyphViewKey,glyph,1);
    }
    double diameter=shelf ? 32 : (readerIcon ? 34 : 36);
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
        double height=__builtin_fmax(30,bounds.height+2);
        material=(Rect){bounds.x-4,bounds.y+(bounds.height-height)*0.5,bounds.width+8,height};
    }
    if (!VisibleRect(material)) { RestoreIcon(view,glass); objc_setAssociatedObject(view,BusyKey,0,0); return; }
    if (!glass) {
        Obj config=O0(Lookup("UIButtonConfiguration"),"glassButtonConfiguration");
        if (config) glass=O0(GlassClass(),"new");
        if (!glass) { RestoreIcon(view,0); objc_setAssociatedObject(view,BusyKey,0,0); return; }
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
    if (readerIcon || role==IconReaderShelf || role==IconReaderChapter) {
        Obj caption=Kind(view,"UILabel") ? view : Get(view,"titleLabel");
        TrackAppearanceLabel(view,Kind(caption,"UILabel") ? caption : (Obj)0,role==IconReaderChapter ? 12 : 13);
    }
    EnsureHit(view,(readerIcon || role==IconReaderShelf || role==IconReaderChapter) ? MinimumHitRect(material,44) : material);
    if (transaction) V0(transaction,"commit");
    if (glyph && Belongs(glyph,view) && VisibleRect(Bounds(glyph))) image=Convert(glyph,Bounds(glyph),view);
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
// No share insert class was present in the inspected host metadata. Resolve
// only an existing small navigation control from its public accessibility
// semantics, registered UIControl action, or the actual insert/view class name.
// Class evidence stays inside this exact navigation row; no selector is guessed.
static B ReaderShareText(Obj text,B identifier) {
    if (!Kind(text,"NSString")) return 0;
    Obj value=O0(text,"lowercaseString");
    if (identifier)
        return ((B(*)(Obj,Sel,Obj))Message)(value,sel_registerName("containsString:"),Text("share")) ||
               ((B(*)(Obj,Sel,Obj))Message)(value,sel_registerName("containsString:"),Text("分享"));
    return Equal(value,"分享") || Equal(value,"分享本书") || Equal(value,"分享书籍") ||
           Equal(value,"share") || Equal(value,"share book");
}
static B ReaderShareCandidate(Obj view,Obj owner) {
    if (!Kind(view,"UIView") || !Belongs(view,owner) || Flag(view,"isHidden")) return 0;
    for (Obj ancestor=view;ancestor;ancestor=Get(ancestor,"superview")) {
        if (Flag(ancestor,"isHidden") || ((double(*)(Obj,Sel))Message)(ancestor,sel_registerName("alpha"))<=0.01) return 0;
        if (ancestor==owner) break;
    }
    Rect bounds=Bounds(view);
    if (!VisibleRect(bounds) || bounds.width<16 || bounds.height<16 || bounds.width>64 || bounds.height>64) return 0;
    Rect row=Bounds(owner),position=Convert(view,bounds,owner);
    return VisibleRect(row) && VisibleRect(position) && position.x<row.x+row.width && position.y<row.y+row.height &&
           position.x+position.width>row.x && position.y+position.height>row.y;
}
static B ReaderShareControl(Obj view,Obj owner,I *strategy) {
    if (!ReaderShareCandidate(view,owner)) return 0;
    if (ReaderShareText(Get(view,"accessibilityLabel"),0)) { *strategy=1; return 1; }
    if (ReaderShareText(Get(view,"accessibilityIdentifier"),1)) { *strategy=2; return 1; }
    if (Kind(view,"UIControl") && Responds(view,"actionsForTarget:forControlEvent:")) {
        Obj targets=Get(Get(view,"allTargets"),"allObjects");
        U count=Kind(targets,"NSArray") ? ((U(*)(Obj,Sel))Message)(targets,sel_registerName("count")) : 0;
        if (count>8) count=8;
        for (U i=0;i<count;++i) {
            Obj target=At(targets,i);
            if (Kind(target,"NSNull")) target=0; // public responder-chain target
            Obj actions=((Obj(*)(Obj,Sel,Obj,U))Message)(view,sel_registerName("actionsForTarget:forControlEvent:"),target,64);
            if (!Kind(actions,"NSArray")) continue;
            U actionCount=((U(*)(Obj,Sel))Message)(actions,sel_registerName("count"));
            if (actionCount>8) actionCount=8;
            for (U a=0;a<actionCount;++a) if (ReaderShareText(At(actions,a),1)) { *strategy=3; return 1; }
        }
    }
    if (ReaderShareText(Get(object_getClass(view),"description"),1)) { *strategy=5; return 1; }
    return 0;
}
static Obj ReaderFindShare(Obj owner,Obj items,U *inspected,I *strategy) {
    if (Kind(items,"NSArray")) {
        U count=((U(*)(Obj,Sel))Message)(items,sel_registerName("count"));
        if (count>16) count=16;
        for (U i=0;i<count;++i) {
            Obj item=At(items,i);
            if (InsertRole(item)!=IconNone) continue;
            Obj view=Get(item,"getInsertView");
            ++*inspected;
            if (ReaderShareControl(view,owner,strategy)) return view;
            if (ReaderShareCandidate(view,owner) && ReaderShareText(Get(object_getClass(item),"description"),1)) {
                *strategy=4;
                return view;
            }
        }
    }
    // Some host packages attach sharing directly instead of publishing an
    // insert object. A two-level, 32-view search stays inside this exact nav.
    Obj first=Get(owner,"subviews");
    U count=((U(*)(Obj,Sel))Message)(first,sel_registerName("count"));
    for (U i=0;i<count && *inspected<32;++i) {
        Obj view=At(first,i);
        ++*inspected;
        if (ReaderShareControl(view,owner,strategy)) return view;
        if (Kind(view,"UIVisualEffectView") || Kind(view,"UIControl") || Flag(view,"isHidden")) continue;
        Obj children=Get(view,"subviews");
        U inner=((U(*)(Obj,Sel))Message)(children,sel_registerName("count"));
        for (U j=0;j<inner && *inspected<32;++j) {
            Obj child=At(children,j);
            ++*inspected;
            if (ReaderShareControl(child,owner,strategy)) return child;
        }
    }
    return 0;
}
static void ReaderShareDiagnostics(Obj owner,Obj share,U inspected,I strategy) {
    if (!FQDDiagnosticsEnabled()) return;
    B styled=FQHIconGlass(share)!=0;
    I value=(share ? 1 : 0)+(styled ? 2 : 0)+(strategy<<2)+((I)inspected<<6);
    Obj previous=objc_getAssociatedObject(owner,ReaderShareResolutionKey);
    if (previous && ((I(*)(Obj,Sel))Message)(previous,sel_registerName("integerValue"))==value) return;
    objc_setAssociatedObject(owner,ReaderShareResolutionKey,Number((double)value),1);
    Obj record=O0(Lookup("NSMutableDictionary"),"dictionary");
    Put(record,"matched",BoolBox(share!=0));
    Put(record,"styled",BoolBox(styled));
    Put(record,"inspectedViews",Number((double)inspected));
    Put(record,"scope",Text("FQReaderSaasNavigationView"));
    const char *source="unresolved";
    if (strategy==1) source="accessibility-label";
    else if (strategy==2) source="accessibility-identifier";
    else if (strategy==3) source="registered-control-action";
    else if (strategy==4) source="runtime-insert-class";
    else if (strategy==5) source="runtime-view-class";
    Put(record,"strategy",Text(source));
    // Do not log titles, accessibility strings, target descriptions or actions.
    FQDRecord("readerShareResolution178",record);
}
static void TrackReaderLabel(Obj owner,const void *key,Obj label) {
    Obj previous=objc_getAssociatedObject(owner,key);
    if (previous==label) return;
    if (previous) RestoreIcon(previous,FQHIconGlass(previous));
    objc_setAssociatedObject(owner,key,label,1);
}
static void ReaderShareHitParents(Obj owner,Obj share) {
    Obj previous=objc_getAssociatedObject(owner,ReaderShareHitParentsKey),current=0;
    if (share) {
        current=O0(Lookup("NSMutableArray"),"array");
        Rect touch=MinimumHitRect(Bounds(share),44);
        Obj parent=Get(share,"superview");
        for (int depth=0;parent && parent!=owner && depth<6;++depth,parent=Get(parent,"superview")) {
            if (!CanExpandHit(parent)) continue;
            EnsureHit(parent,Convert(share,touch,parent));
            V1(current,"addObject:",parent);
        }
    }
    U oldCount=((U(*)(Obj,Sel))Message)(previous,sel_registerName("count"));
    U newCount=((U(*)(Obj,Sel))Message)(current,sel_registerName("count"));
    B same=oldCount==newCount;
    for (U i=0;i<oldCount;++i) {
        Obj parent=At(previous,i); B retained=0;
        for (U j=0;j<newCount;++j) if (At(current,j)==parent) retained=1;
        if (!retained) RestoreHit(parent);
        if (same && At(current,i)!=parent) same=0;
    }
    if (!same || (!share && previous)) objc_setAssociatedObject(owner,ReaderShareHitParentsKey,current,1);
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
    U inspected=0;
    I shareStrategy=0;
    Obj share=Kind(owner,"FQReaderSaasNavigationView") && Enabled() && FQHButtonAvailable() ?
        ReaderFindShare(owner,items,&inspected,&shareStrategy) : (Obj)0;
    TrackReaderLabel(owner,ReaderShareViewKey,share);
    if (share) {
        Icon(share,IconReaderShare);
        Obj glass=FQHIconGlass(share);
        IncludeMaterial(glass,owner,&area);
        styled+=glass!=0;
    }
    ReaderShareHitParents(owner,FQHIconGlass(share) ? share : (Obj)0);
    if (Enabled()) ReaderShareDiagnostics(owner,share,inspected,shareStrategy);
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

static void ReaderStyleOriginalKey(void) {}
static void ReaderStyleAppliedKey(void) {}

static void ApplyReaderGlassStyle(Obj controller,Obj theme) {
    Obj applied=objc_getAssociatedObject(controller,ReaderStyleAppliedKey);
    B decorate=Enabled() && Kind(theme,"BDReaderThemeConfig");
    if (!applied && !decorate) return;
    I current=((I(*)(Obj,Sel))Message)(controller,sel_registerName("overrideUserInterfaceStyle"));
    I previous=((I(*)(Obj,Sel))Message)(applied,sel_registerName("integerValue"));
    if (!decorate) {
        Obj original=objc_getAssociatedObject(controller,ReaderStyleOriginalKey);
        I originalStyle=((I(*)(Obj,Sel))Message)(original,sel_registerName("integerValue"));
        objc_setAssociatedObject(controller,ReaderStyleAppliedKey,0,1);
        objc_setAssociatedObject(controller,ReaderStyleOriginalKey,0,1);
        if (current==previous) Q1(controller,"setOverrideUserInterfaceStyle:",originalStyle);
        return;
    }
    // UIKit resolves materials and semantic foregrounds within this reader
    // controller's traits. The app window keeps following the system.
    enum { LightStyle=1, DarkStyle=2, ReaderDarkTheme=1 };
    U readerTheme=((U(*)(Obj,Sel))Message)(theme,sel_registerName("themeStyle"));
    I wanted=readerTheme==ReaderDarkTheme ? DarkStyle : LightStyle;
    if (current==wanted) return;
    Obj numbers=Lookup("NSNumber");
    Sel integer=sel_registerName("numberWithInteger:");
    if (!applied || current!=previous)
        objc_setAssociatedObject(controller,ReaderStyleOriginalKey,((Obj(*)(Obj,Sel,I))Message)(numbers,integer,current),1);
    objc_setAssociatedObject(controller,ReaderStyleAppliedKey,((Obj(*)(Obj,Sel,I))Message)(numbers,integer,wanted),1);
    Q1(controller,"setOverrideUserInterfaceStyle:",wanted);
}

static void ReaderGlassWillAppear(Obj self,Sel cmd,B animated) {
    ApplyReaderGlassStyle(self,Get(Get(Get(self,"readerModel"),"config"),"themeConfig"));
    ((void(*)(Obj,Sel,B))Original("BDReaderViewController","fqx192_originalReaderWillAppear:"))(self,cmd,animated);
}

static void ReaderGlassThemeChanged(Obj self,Sel cmd,Obj theme) {
    ApplyReaderGlassStyle(self,theme);
    ((void(*)(Obj,Sel,Obj))Original("BDReaderViewController","fqx192_originalReaderTheme:"))(self,cmd,theme);
}

static void ReaderGlassStyleInstall(void) {
    const char *reader="BDReaderViewController";
    if (!FQHGlassAvailable() || !Signature("BDReaderThemeConfig","themeStyle","Q16@0:8") ||
        !Signature(reader,"overrideUserInterfaceStyle","q16@0:8") ||
        !Signature(reader,"setOverrideUserInterfaceStyle:","v24@0:8q16")) return;
    Hook("BDReaderViewController","viewWillAppear:","fqx192_originalReaderWillAppear:","v20@0:8B16",(Imp)ReaderGlassWillAppear);
    Hook("BDReaderViewController","onConfigThemeChange:","fqx192_originalReaderTheme:","v24@0:8@16",(Imp)ReaderGlassThemeChanged);
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
static Rect ProfileStockFrame(Obj view,Rect current);
static void ProfileSetFrame(Obj view,Rect current,Rect stock,Rect target);
static void ShelfRightEdge(Obj view,Obj material,B styled) {
    if (!view) return;
    Rect current=Frame(view),stock=ProfileStockFrame(view,current),target=stock;
    Obj window=Get(view,"window");
    if (styled && material && window) {
        // Match the books and the default dock's 20pt margin. This grid is
        // independent of the user's adjustable dock length and button width.
        Rect edge=Convert(material,Bounds(material),window),bounds=Bounds(window);
        target=current;
        target.x+=bounds.x+bounds.width-20-edge.x-edge.width;
        ProfileSetFrame(view,current,stock,target);
    } else {
        if (!SameRect(current,stock)) SetFrame(view,stock);
        objc_setAssociatedObject(view,GlyphOriginalKey,0,1);
        objc_setAssociatedObject(view,GlyphAppliedKey,0,1);
    }
}
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
    Obj trailing=!more || Flag(more,"isHidden") ? search : more;
    ShelfRightEdge(parent,FQHIconGlass(trailing),Enabled());
    if (Kind(parent,"UIView")) ShelfTopHit(parent,search,more,ShelfEditPlacement(self,parent));
    objc_setAssociatedObject(self,OwnerBusyKey,0,0);
}
static void BookshelfHeaderActions(Obj controller) {
    Obj tab=Get(controller,"currentTabVC");
    if (Kind(tab,"SSBookShelfSubViewController")) {
        FQHShelf(tab);
        return;
    }
    Obj holder=Get(controller,"headerRightView"), header=Get(controller,"headerView");
    Obj button=Get(tab,"searchButton");
    if (!Kind(button,"UIButton") || !Belongs(holder,header) || (button!=holder && !Belongs(button,holder))) return;
    Obj prior=objc_getAssociatedObject(button,ShelfRoleKey);
    if (Double(prior)!=2) objc_setAssociatedObject(button,ShelfRoleKey,Number(2),1);
    Icon(button,IconShelfStandaloneSearch);
    ShelfRightEdge(holder,FQHIconGlass(button),Enabled());
    if (holder!=button) ShelfTopHit(holder,button,0,0);
}
static void BookshelfHeaderRightMounted(Obj self,Sel cmd) {
    ((void(*)(Obj,Sel))Original("SSBookShelf525ViewController","fqx_originalShelfHeaderRight"))(self,cmd);
    BookshelfHeaderActions(self);
}
static void TopChromeRefreshHiddenKey(void) {}
static void TopChromeRefreshVisibility(Obj scroll) {
    Obj header=Get(scroll,"mj_header");
    if (!Responds(header,"fqx188_originalRefreshHidden:") ||
        Get(header,"superview")!=scroll) return;
    Obj animation=Get(header,"animationView");
    if (!Kind(animation,"UIView") || Get(animation,"superview")!=header) return;
    Obj stockHidden=objc_getAssociatedObject(animation,TopChromeRefreshHiddenKey);
    B suppress=objc_getAssociatedObject(scroll,TopChromeInsetKey) && !Flag(header,"isRefreshing");
    if (suppress && Flag(scroll,"isDragging")) {
        Point offset=((Point(*)(Obj,Sel))Message)(scroll,sel_registerName("contentOffset"));
        Rect inset=((Rect(*)(Obj,Sel))Message)(scroll,sel_registerName("adjustedContentInset"));
        suppress=offset.y>=-inset.x;
    }
    // The extended viewport exposes the idle artwork formerly clipped above
    // the list. Leave the refresh header, pull threshold and animation state to MJRefresh.
    if (suppress) {
        B hidden=Flag(animation,"isHidden");
        if (!stockHidden) objc_setAssociatedObject(animation,TopChromeRefreshHiddenKey,BoolBox(hidden),1);
        if (!hidden) VB(animation,"setHidden:",1);
    } else if (stockHidden) {
        B hidden=Flag(stockHidden,"boolValue");
        objc_setAssociatedObject(animation,TopChromeRefreshHiddenKey,0,1);
        if (Flag(animation,"isHidden")!=hidden) VB(animation,"setHidden:",hidden);
    }
}
static void TopChromeRefreshHeaderVisibility(Obj header) {
    Obj scroll=Get(header,"superview"),owner=Get(scroll,"delegate");
    if (Get(scroll,"mj_header")!=header) return;
    if ((Kind(owner,"SSBookShelfSubViewController") || Kind(owner,"SSBookStoreTabViewController")) &&
        Get(owner,"collectionView")==scroll) {
        TopChromeRefreshVisibility(scroll);
        if (Kind(owner,"SSBookShelfSubViewController")) BookshelfRestingTint(owner,scroll);
    } else if (Kind(owner,"SSBookStoreNestedTabView") && Get(owner,"containerScrollView")==scroll &&
             Get(owner,"refreshHeader")==header)
        TopChromeRefreshVisibility(scroll);
}
static void TopChromeRefreshState(Obj self,Sel cmd,I state) {
    ((void(*)(Obj,Sel,I))Original("SSNewRefreshHeader","fqx188_originalRefreshState:"))(self,cmd,state);
    TopChromeRefreshHeaderVisibility(self);
}
static void TopChromeRefreshAnimationLayout(Obj self,Sel cmd) {
    ((void(*)(Obj,Sel))Original("SSNewRefreshHeader","fqx188_originalRefreshAnimationLayout"))(self,cmd);
    TopChromeRefreshHeaderVisibility(self);
}
static void TopChromeRefreshHostHidden(Obj self,Sel cmd,B hidden) {
    Obj animation=Get(self,"animationView");
    if (objc_getAssociatedObject(animation,TopChromeRefreshHiddenKey)) {
        objc_setAssociatedObject(animation,TopChromeRefreshHiddenKey,BoolBox(hidden),1);
        hidden=1;
    }
    ((void(*)(Obj,Sel,B))Original("SSNewRefreshHeader","fqx188_originalRefreshHidden:"))(self,cmd,hidden);
}
static void ShelfScroll(Obj self,Sel cmd,Obj scroll) {
    ((void(*)(Obj,Sel,Obj))Original("SSBookShelfSubViewController","fqx187_originalShelfScroll:"))(self,cmd,scroll);
    if (Get(self,"collectionView")==scroll) {
        TopChromeRefreshVisibility(scroll);
        BookshelfRestingTint(self,scroll);
    }
}
static void ShelfLayout(Obj self,Sel cmd) {
    ((void(*)(Obj,Sel))Original("SSBookShelfSubViewController","fqx167_originalShelfLayout"))(self,cmd);
    FQHShelf(self);
    RestoreBookshelfTopInset(self);
    Obj scroll=Get(self,"collectionView");
    TopChromeRefreshVisibility(scroll);
    BookshelfRestingTint(self,scroll);
}
static void ShelfButtonLayout(Obj self,Sel cmd) {
    ((void(*)(Obj,Sel))Original("FQReaderSaaSBaseButton","fqx170_originalLayout"))(self,cmd);
    Obj role=objc_getAssociatedObject(self,ShelfRoleKey);
    if (role) Icon(self,Double(role)==2 ? IconShelfStandaloneSearch :
        Flag(role,"boolValue") ? IconShelfSearch : IconShelfMore);
}
static void ListenLabelKey(void) {}
static void ListenColorKey(void) {}
static void OpticalGlyph(Obj glyph,double maximum);
static void RestoreOpticalFrame(Obj view);
static void ApplyReaderListenSurface(Obj view) {
    Rect bounds=Bounds(view);
    double diameter=__builtin_fmin(48,__builtin_fmin(bounds.width,bounds.height));
    ApplySurface(view,(Rect){bounds.x+(bounds.width-diameter)*0.5,bounds.y+(bounds.height-diameter)*0.5,
        diameter,diameter},0);
}
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
        TrackAppearanceLabel(view,0,0);
        if (saved) V1(saved,"setTextColor:",objc_getAssociatedObject(view,ListenColorKey));
        objc_setAssociatedObject(view,ListenLabelKey,0,1);objc_setAssociatedObject(view,ListenColorKey,0,1);
        Restore(view,FQHSurface(view));return;
    }
    ApplyReaderListenSurface(view);
    Obj surface=FQHSurface(view);if (!surface) return;
    TrackAppearanceLabel(view,label,22);
    if (saved!=label) {
        if(saved)V1(saved,"setTextColor:",objc_getAssociatedObject(view,ListenColorKey));
        objc_setAssociatedObject(view,ListenLabelKey,label,1);
        objc_setAssociatedObject(view,ListenColorKey,Get(label,"textColor"),1);
    }
    Obj foreground=O0(Lookup("UIColor"),"labelColor");
    if (!((B(*)(Obj,Sel,Obj))Message)(Get(label,"textColor"),sel_registerName("isEqual:"),foreground))
        V1(label,"setTextColor:",foreground);
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
    Obj imageView=Get(button,"imageView");
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
        RestoreOpticalFrame(imageView);
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
    ApplyReaderListenSurface(button);
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
    OpticalGlyph(imageView,46);
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
static B ReaderThemeIsolationEnabled(void);
void FQHApplyReaderThemeIsolation(void);
static void SaveReaderThemePreset(Obj manager,Obj config,Obj context);
static B ShelfFilterVisible(void);
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
    SaveReaderThemePreset(self,config,context);
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
enum { ReaderToolWidth=76, ReaderToolHeight=44, ReaderToolGap=8 };

static B ReaderToolbarTool(Obj view) {
    return Kind(view,"SSReaderBottomToolDivertView") ||
        (Kind(view,"FQReaderSaaSBottomToolItemView") && ReaderBottomItem(view));
}

static double ReaderToolbarWidth(Obj toolbar,Obj children,U count) {
    Rect bounds=Bounds(toolbar);
    double width=ReaderToolWidth;
    for (U i=0;i<count;++i) {
        Obj view=At(children,i);
        if (!ReaderToolbarTool(view) || Flag(view,"isHidden")) continue;
        Rect slot=Frame(view);
        if (!VisibleRect(slot)) continue;
        double center=slot.x+slot.width*0.5;
        double edge=__builtin_fmin(center-bounds.x,bounds.x+bounds.width-center);
        width=__builtin_fmin(width,2*(edge-ReaderToolGap));
        for (U j=i+1;j<count;++j) {
            Obj neighbor=At(children,j);
            if (!ReaderToolbarTool(neighbor) || Flag(neighbor,"isHidden")) continue;
            Rect other=Frame(neighbor);
            if (!VisibleRect(other)) continue;
            double spacing=__builtin_fabs(center-(other.x+other.width*0.5));
            width=__builtin_fmin(width,spacing-ReaderToolGap);
        }
    }
    return width;
}
static void ReaderOpticalChildrenKey(void) {}
static void OpticalFrameStockKey(void) {}
static void OpticalFrameAppliedKey(void) {}
static void RestoreOpticalFrame(Obj view) {
    Obj applied=objc_getAssociatedObject(view,OpticalFrameAppliedKey);
    Obj original=objc_getAssociatedObject(view,OpticalFrameStockKey);
    if (applied && original && SameRect(Frame(view),UnboxRect(applied))) SetFrame(view,UnboxRect(original));
    objc_setAssociatedObject(view,OpticalFrameStockKey,0,1);
    objc_setAssociatedObject(view,OpticalFrameAppliedKey,0,1);
}
static void OpticalGlyph(Obj glyph,double maximum) {
    if (!Kind(glyph,"UIImageView")) return;
    Rect current=Frame(glyph);
    Obj applied=objc_getAssociatedObject(glyph,OpticalFrameAppliedKey);
    Obj original=objc_getAssociatedObject(glyph,OpticalFrameStockKey);
    B ours=applied && original && SameRect(current,UnboxRect(applied));
    Rect stock=ours ? UnboxRect(original) : current;
    if (!VisibleRect(stock)) return;
    double longest=__builtin_fmax(stock.width,stock.height);
    if (longest<=maximum) { RestoreOpticalFrame(glyph); return; }
    double scale=maximum/longest;
    Rect target={stock.x+(stock.width-stock.width*scale)*0.5,stock.y+(stock.height-stock.height*scale)*0.5,
                 stock.width*scale,stock.height*scale};
    if (!ours) objc_setAssociatedObject(glyph,OpticalFrameStockKey,RectBox(stock),1);
    if (!applied || !SameRect(target,UnboxRect(applied)))
        objc_setAssociatedObject(glyph,OpticalFrameAppliedKey,RectBox(target),1);
    if (!SameRect(current,target)) SetFrame(glyph,target);
}
static B ArrayContainsView(Obj array,Obj view) {
    U count=((U(*)(Obj,Sel))Message)(array,sel_registerName("count"));
    for (U i=0;i<count;++i) if (At(array,i)==view) return 1;
    return 0;
}
static void ReaderBottomOptics(Obj owner,B enabled) {
    Obj previous=objc_getAssociatedObject(owner,ReaderOpticalChildrenKey),current=0;
    if (enabled) {
        current=O0(Lookup("NSMutableArray"),"array");
        Obj children=O0(owner,"subviews");
        U count=((U(*)(Obj,Sel))Message)(children,sel_registerName("count"));
        if (count>16) count=16;
        for (U i=0;i<count;++i) {
            Obj view=At(children,i);
            if (Flag(view,"isHidden") || view==FQHSurface(owner)) continue;
            if (Kind(view,"UILabel")) {
                AppearanceFont(view,11);
                V1(current,"addObject:",view);
            } else {
                Obj glyph=Kind(view,"UIImageView") ? view : (Kind(view,"UIButton") ? Get(view,"imageView") : (Obj)0);
                if (Kind(glyph,"UIImageView") && Belongs(glyph,owner) && !Flag(glyph,"isHidden")) {
                    OpticalGlyph(glyph,18);
                    V1(current,"addObject:",glyph);
                }
            }
        }
    }
    U previousCount=((U(*)(Obj,Sel))Message)(previous,sel_registerName("count"));
    for (U i=0;i<previousCount;++i) {
        Obj child=At(previous,i);
        if (!ArrayContainsView(current,child)) { RestoreOpticalFrame(child); RestoreAppearanceFont(child); }
    }
    U currentCount=((U(*)(Obj,Sel))Message)(current,sel_registerName("count"));
    B same=previousCount==currentCount;
    for (U i=0;i<currentCount && same;++i) if (At(previous,i)!=At(current,i)) same=0;
    if (!same || (!enabled && previous)) objc_setAssociatedObject(owner,ReaderOpticalChildrenKey,current,1);
}
static void ReaderBottomGlass(Obj view,double width) {
    Rect bounds=Bounds(view);
    if (width<44 || !VisibleRect(bounds) || Flag(view,"isHidden")) {
        ReaderBottomOptics(view,0); PageRestore(view); RestoreHit(view); return;
    }
    Rect glass={bounds.x+(bounds.width-width)*0.5,bounds.y+(bounds.height-ReaderToolHeight)*0.5,width,ReaderToolHeight};
    ApplySurface(view,glass,0);
    Obj surface=FQHSurface(view);
    if (!surface) { ReaderBottomOptics(view,0); RestoreHit(view); return; }
    ReaderBottomOptics(view,1);
    EnsureHit(view,MinimumHitRect(glass,44));
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
static void ReaderToolbarGlass(Obj toolbar) {
    Obj children=O0(toolbar,"subviews");
    U count=((U(*)(Obj,Sel))Message)(children,sel_registerName("count"));
    Rect area=Bounds(toolbar);
    double width=ReaderToolbarWidth(toolbar,children,count);
    B styled=0;
    for (U i=0;i<count;++i) {
        Obj view=At(children,i);
        if (ReaderToolbarTool(view)) ReaderBottomGlass(view,width);
        else if (Kind(view,"FQReaderSaaSBottomToolItemView")) ReaderBottomGlass(view,0);
        else continue;
        Obj surface=FQHSurface(view);
        if (Kind(view,"FQReaderSaaSBottomToolItemView"))
            UpdateCatalogTap(view,surface && ReaderBottomType(view)==1);
        if (surface) { IncludeMaterial(surface,toolbar,&area); styled=1; }
    }
    if (styled) EnsureHit(toolbar,area); else RestoreHit(toolbar);
}
static void PageBottomLayout(Obj self,Sel cmd) {
    ((void(*)(Obj,Sel))Original("FQReaderSaaSBottomToolView","fqx175_originalBottom"))(self,cmd);
    ReaderBackdrop(self,ReaderBottomBackgroundEnabled());
    ReaderToolbarGlass(self);
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
    if (Kind(toolbar,"FQReaderSaaSBottomToolView")) ReaderToolbarGlass(toolbar);
    else ReaderBottomGlass(self,HasAncestor(self,"FQReaderSaaSBottomToolView") ? ReaderToolWidth : 0);
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
static void PageCoverListenLayout(Obj self,Sel cmd) {
    ((void(*)(Obj,Sel))Original("SSReaderCoverTopRightView","fqx186_originalCoverListen"))(self,cmd);
    Obj button=Get(self,"listenBtn"),background=Get(self,"bgView"),label=Get(self,"listenLabel");
    B legacy=Kind(button,"UIButton") && Get(button,"superview")==self && !Flag(button,"isHidden");
    B shared=!legacy && Kind(label,"UILabel") && Get(label,"superview")==self && !Flag(label,"isHidden") &&
        Get(background,"superview")==self && !Flag(background,"isHidden");
    if (legacy) FQHApply(button);
    else if (FQHSurface(button)) PageRestore(button);
    if (shared) FQHApply(background);
    else if (FQHSurface(background)) PageRestore(background);
}
static void CoverGuideBorderKey(void) {}
static void CoverGuideGlass(Obj guide) {
    // The host may supply a different guide. Only style the standard reading prompt.
    if (object_getClass(guide)!=Lookup("UIView")) return;
    Obj children=O0(guide,"subviews");
    U count=((U(*)(Obj,Sel))Message)(children,sel_registerName("count"));
    B standard=0;
    for (U i=0;i<count && !standard;++i) {
        Obj label=At(children,i);
        if (Kind(label,"UILabel")) {
            Obj text=O0(label,"text");
            standard=Equal(text,"左滑开始阅读") || Equal(text,"上滑开始阅读");
        }
    }
    if (standard && !Flag(guide,"isHidden")) FQHApply(guide);
    else if (FQHSurface(guide)) PageRestore(guide);

    Obj saved=objc_getAssociatedObject(guide,CoverGuideBorderKey);
    B styled=FQHSurface(guide)!=0;
    if (!styled && !saved) return;
    Obj layer=O0(guide,"layer");
    double width=((double(*)(Obj,Sel))Message)(layer,sel_registerName("borderWidth"));
    if (styled) {
        if (width==0) return;
        objc_setAssociatedObject(guide,CoverGuideBorderKey,Number(width),1);
        ((void(*)(Obj,Sel,double))Message)(layer,sel_registerName("setBorderWidth:"),0);
    } else {
        if (width==0) ((void(*)(Obj,Sel,double))Message)(layer,sel_registerName("setBorderWidth:"),Double(saved));
        objc_setAssociatedObject(guide,CoverGuideBorderKey,0,1);
    }
}
static void PageCoverGuideSetup(Obj self,Sel cmd) {
    ((void(*)(Obj,Sel))Original("FQReaderCoverMainContentViewController","fqx186_originalCoverGuideSetup"))(self,cmd);
    CoverGuideGlass(Get(self,"guideView"));
}
static void PageCoverGuideLayout(Obj self,Sel cmd) {
    ((void(*)(Obj,Sel))Original("FQReaderCoverMainContentViewController","fqx186_originalCoverGuideLayout"))(self,cmd);
    CoverGuideGlass(Get(self,"guideView"));
}
static void ChapterDiscussionKey(void) {}
static void ChapterCardBackingKey(void) {}
static void ChapterCardRoundedKey(void) {}
static I ChapterDiscussionMode(Obj card,Obj entry,Obj background) {
    if ((!Kind(entry,"SSReaderChapterEndDiscussionEntranceView") &&
         !Kind(entry,"SSReaderChapterEndForumEntranceView")) || Flag(entry,"isHidden") ||
        Get(background,"superview")!=card || Get(card,"contentBackgroundView")!=background) return 0;
    Obj model=Get(card,"model");
    if (!InstanceABI(model,"displayMode","q16@0:8")) return 0;
    I mode=((I(*)(Obj,Sel))Message)(model,sel_registerName("displayMode"));
    if (mode==1) return mode;
    if (mode!=2 || !Responds(Lookup("UICornerConfiguration"),"capsuleConfigurationWithMaximumRadius:")) return 0;
    Obj author=Get(card,"authorInfoView");
    return Kind(author,"SSReaderChapterEndAuthorInfoView") &&
        Get(author,"superview")==background && !Flag(author,"isHidden") ? mode : 0;
}
static void ChapterCardCorners(Obj surface,B rounded) {
    if (rounded==(objc_getAssociatedObject(surface,ChapterCardRoundedKey)!=0)) return;
    Obj cls=Lookup("UICornerConfiguration");
    // Cap the native radius on the tall author card. The short discussion-only
    // card can use the normal capsule when this backing is reused.
    Obj corners=rounded ? ((Obj(*)(Obj,Sel,double))Message)(cls,
        sel_registerName("capsuleConfigurationWithMaximumRadius:"),18) : O0(cls,"capsuleConfiguration");
    V1(surface,"setCornerConfiguration:",corners);
    objc_setAssociatedObject(surface,ChapterCardRoundedKey,rounded ? surface : (Obj)0,0);
}
static void ChapterDiscussionGlass(Obj card) {
    Obj previousEntry=objc_getAssociatedObject(card,ChapterDiscussionKey);
    Obj previousBacking=objc_getAssociatedObject(card,ChapterCardBackingKey);
    Obj entry=Get(card,"activeEntranceView");
    Obj background=Get(entry,"superview");
    I mode=ChapterDiscussionMode(card,entry,background);
    Obj styled=0;
    if (mode) {
        if (FQHSurface(entry)) PageRestore(entry);
        FQHApply(background);
        Obj surface=FQHSurface(background);
        if (surface) {
            ChapterCardCorners(surface,mode==2);
            styled=background;
        }
    }
    if (previousBacking!=styled) {
        PageRestore(previousBacking);
        objc_setAssociatedObject(card,ChapterCardBackingKey,styled,1);
    }
    // Only a discussion-only card is itself the whole tap target. The author
    // card has separate native controls above the discussion row.
    Obj hit=styled && mode==1 ? entry : (Obj)0;
    if (previousEntry!=hit) {
        RestoreHit(previousEntry);
        objc_setAssociatedObject(card,ChapterDiscussionKey,hit,1);
    }
    if (hit) EnsureHit(hit,Convert(background,Bounds(background),hit));
}
static void PageChapterCardLayout(Obj self,Sel cmd) {
    ((void(*)(Obj,Sel))Original("SSReaderChapterEndCommunityCardView","fqx177_originalChapterCard"))(self,cmd);
    ChapterDiscussionGlass(self);
}
static void ChapterRewardGlass(Obj reward) {
    Obj card=Get(reward,"superview");
    Obj background=Get(reward,"customBackgroundView");
    if ((Kind(card,"SSReaderChapterEndCommunityCardView") || Kind(card,"SSReaderChapterEndCombineContainerView")) &&
        Get(background,"superview")==reward && !Flag(reward,"isHidden")) FQHApply(background);
    else if (FQHSurface(background)) PageRestore(background);
    // Keep native press feedback on the backing, and let its glass rim extend
    // beyond the stock button mask.
    if (FQHSurface(background)) PrepareOwner(reward,Flag(reward,"clipsToBounds"),Flag(reward,"isOpaque"));
    else RestoreOwner(reward);
}
static void PageChapterCardTheme(Obj self,Sel cmd,Obj config) {
    ((void(*)(Obj,Sel,Obj))Original("SSReaderChapterEndCommunityCardView","fqx177_originalChapterCardTheme:"))(self,cmd,config);
    ChapterDiscussionGlass(self);
    // The card repaints the gift backing after the reward's theme callback.
    // Use the attached child so this does not invoke the lazy gift getter.
    Obj children=O0(self,"subviews");
    U count=((U(*)(Obj,Sel))Message)(children,sel_registerName("count"));
    for (U i=0;i<count;++i) {
        Obj child=At(children,i);
        if (Kind(child,"SSReaderChapterEndRewardButton")) ChapterRewardGlass(child);
    }
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
    Obj background=Get(self,"superview"),card=Get(background,"superview");
    if ((Kind(card,"SSReaderChapterEndCommunityCardView") && Get(card,"activeEntranceView")==self &&
         ChapterDiscussionMode(card,self,background)) ||
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
static void PageForumEntranceLayout(Obj self,Sel cmd) {
    ((void(*)(Obj,Sel))Original("SSReaderChapterEndForumEntranceView","fqx179r5_originalForumEntrance"))(self,cmd);
    Obj background=Get(self,"superview"),card=Get(background,"superview");
    if (Kind(card,"SSReaderChapterEndCommunityCardView") && Get(card,"activeEntranceView")==self &&
        ChapterDiscussionMode(card,self,background)) {
        if (FQHSurface(self)) PageRestore(self);
        return;
    }
    FQHApply(self);
}
static void DramaGlassKey(void) {}
static void DramaBackgroundKey(void) {}
static void DramaShadeKey(void) {}
static void DramaWatchContentKey(void) {}
static void DramaWatchArrowKey(void) {}
static void DramaDetailRelatedContentKey(void) {}
static void DramaDetailRelatedShadeKey(void) {}
static void DramaVisibilitySet(Obj view,B visible);
static U TabCount(Obj items);
static void DramaSpacingForView(Obj view);
static Obj BottomDramaCapsuleForView(Obj view);
static Rect BottomDramaEpisodeDockFrame(Obj view);
B BottomSameFrame178(Rect a,Rect b);
static void BottomRestoreFrame178(Obj view,const void *stockKey,const void *appliedKey);
static void BottomApplyFrame178(Obj view,Rect target,const void *stockKey,const void *appliedKey);

static void DramaDockAlignedStockKey(void) {}
static void DramaDockAlignedFrameKey(void) {}

static B DramaAlignWithDockFrame(Obj view,Rect alignment,double inset) {
    Obj parent=Get(view,"superview");
    Rect before=Frame(view);
    if (parent && VisibleRect(alignment)) {
        Rect bounds=Bounds(parent);
        Rect target={alignment.x-inset,before.y,alignment.width+2*inset,before.height};
        if (VisibleRect(target) && alignment.width>=bounds.width*0.5 &&
            target.x>=bounds.x && target.x+target.width<=bounds.x+bounds.width) {
            BottomApplyFrame178(view,target,DramaDockAlignedStockKey,DramaDockAlignedFrameKey);
            return !BottomSameFrame178(before,target);
        }
    }
    BottomRestoreFrame178(view,DramaDockAlignedStockKey,DramaDockAlignedFrameKey);
    return !BottomSameFrame178(before,Frame(view));
}
static B DramaAlignWithDock(Obj view,Obj dock,double inset) {
    Obj parent=Get(view,"superview");
    Rect alignment=parent && dock ? Convert(dock,Bounds(dock),parent) : (Rect){0};
    return DramaAlignWithDockFrame(view,alignment,inset);
}

static void RemoveDramaGlass(Obj owner) {
    Obj glass=objc_getAssociatedObject(owner,DramaGlassKey);
    if (!glass) return;
    V0(glass,"removeFromSuperview");
    objc_setAssociatedObject(owner,DramaGlassKey,0,1);
}

// The transparent button only draws the material. The host still owns the
// foreground, its accessibility element and the original click handling.
static Obj PlaceDramaGlass(Obj owner,Obj parent,Obj foreground,Rect frame) {
    Obj glass=objc_getAssociatedObject(owner,DramaGlassKey);
    if (!glass) {
        Obj config=Get(Lookup("UIButtonConfiguration"),"glassButtonConfiguration");
        if (!config) return 0;
        glass=((Obj(*)(Obj,Sel,Rect))Message)(O0(Lookup("UIButton"),"alloc"),sel_registerName("initWithFrame:"),frame);
        if (!glass) return 0;
        V1(glass,"setConfiguration:",config);
        V1(glass,"setCornerConfiguration:",O0(Lookup("UICornerConfiguration"),"capsuleConfiguration"));
        // The player's native icons and captions use white ink. Match the
        // dark player palette used by the bottom bar, including in light apps.
        Q1(glass,"setOverrideUserInterfaceStyle:",2);
        VB(glass,"setUserInteractionEnabled:",0);
        VB(glass,"setAccessibilityElementsHidden:",1);
        VB(glass,"setIsAccessibilityElement:",0);
        objc_setAssociatedObject(owner,DramaGlassKey,glass,1);
        V0(glass,"release");
    }
    B move=!SameRect(Frame(glass),frame), attach=O0(glass,"superview")!=parent;
    if (!move && !attach) return glass;
    Obj transaction=Lookup("CATransaction");
    V0(transaction,"begin"); VB(transaction,"setDisableActions:",1);
    if (move) SetFrame(glass,frame);
    if (attach) {
        if (foreground)
            ((void(*)(Obj,Sel,Obj,Obj))Message)(parent,sel_registerName("insertSubview:belowSubview:"),glass,foreground);
        else
            ((void(*)(Obj,Sel,Obj,I))Message)(parent,sel_registerName("insertSubview:atIndex:"),glass,0);
    }
    V0(transaction,"commit");
    return glass;
}

static void DramaActionOwners178R11Key(void) {}
static Obj DramaActionOwners178R11(void) {
    Obj defaults=O0(Lookup("NSUserDefaults"),"standardUserDefaults");
    Obj owners=objc_getAssociatedObject(defaults,DramaActionOwners178R11Key);
    if (!owners) {
        owners=O0(Lookup("NSHashTable"),"weakObjectsHashTable");
        objc_setAssociatedObject(defaults,DramaActionOwners178R11Key,owners,1);
    }
    return owners;
}
static double DramaActionDiameter178R11(void) {
    Obj defaults=O0(Lookup("NSUserDefaults"),"standardUserDefaults");
    Obj stored=O1(defaults,"objectForKey:",Text("FanqieX.DramaActionDiameter.1"));
    double value=Responds(stored,"doubleValue") ? Double(stored) : 50;
    return !__builtin_isfinite(value) ? 50 : __builtin_fmax(36,__builtin_fmin(54,value));
}
static void DramaActionGlyphKey(void) {}
static void DramaActionInkKey(void) {}

static void RestoreDramaActionInk(Obj glyph) {
    Obj ink=objc_getAssociatedObject(glyph,DramaActionInkKey);
    if (!ink) return;
    if (O0(glyph,"image")==At(ink,1)) V1(glyph,"setImage:",At(ink,0));
    I originalMode=(I)Double(At(ink,2));
    if (originalMode!=4 && ((I(*)(Obj,Sel))Message)(glyph,sel_registerName("contentMode"))==4)
        Q1(glyph,"setContentMode:",originalMode);
    objc_setAssociatedObject(glyph,DramaActionInkKey,0,1);
}

static void DramaActionInk(Obj owner,Obj glyph,double factor) {
    Obj previous=objc_getAssociatedObject(owner,DramaActionGlyphKey);
    if (previous!=glyph) {
        RestoreDramaActionInk(previous);
        objc_setAssociatedObject(owner,DramaActionGlyphKey,glyph,1);
    }
    if (!glyph) return;
    // Rescale the raster's point size so the native image view still supplies
    // the same clickableBoundsInWindow, center, selection and animation owner.
    if (factor==1 || Flag(glyph,"isAnimating")) { RestoreDramaActionInk(glyph); return; }
    Obj ink=objc_getAssociatedObject(glyph,DramaActionInkKey);
    Obj current=O0(glyph,"image"), applied=ink ? At(ink,1) : 0;
    Obj source=ink && current==applied ? At(ink,0) : current;
    I mode=((I(*)(Obj,Sel))Message)(glyph,sel_registerName("contentMode"));
    I originalMode=ink && mode==4 ? (I)Double(At(ink,2)) : mode;
    Obj pixels=Get(source,"CGImage");
    if (!pixels) { RestoreDramaActionInk(glyph); return; }
    if (originalMode<=2) {
        Size original=((Size(*)(Obj,Sel))Message)(source,sel_registerName("size"));
        Rect bounds=Bounds(glyph);
        double x=bounds.width/original.width,y=bounds.height/original.height;
        factor*=originalMode==2 ? __builtin_fmax(x,y) : __builtin_fmin(x,y);
    }
    double pointScale=((double(*)(Obj,Sel))Message)(source,sel_registerName("scale"))/factor;
    if (!__builtin_isfinite(pointScale) || pointScale<=0) { RestoreDramaActionInk(glyph); return; }
    if (ink && current==applied && mode==4 && pointScale==Double(At(ink,3))) return;
    I orientation=((I(*)(Obj,Sel))Message)(source,sel_registerName("imageOrientation"));
    Obj scaled=((Obj(*)(Obj,Sel,Obj,double,I))Message)(Lookup("UIImage"),
        sel_registerName("imageWithCGImage:scale:orientation:"),pixels,pointScale,orientation);
    if (!scaled) { RestoreDramaActionInk(glyph); return; }
    I renderingMode=((I(*)(Obj,Sel))Message)(source,sel_registerName("renderingMode"));
    scaled=((Obj(*)(Obj,Sel,I))Message)(scaled,sel_registerName("imageWithRenderingMode:"),renderingMode);
    Obj items[]={source,scaled,Number(originalMode),Number(pointScale)};
    Obj state=((Obj(*)(Obj,Sel,Obj *,U))Message)(Lookup("NSArray"),
        sel_registerName("arrayWithObjects:count:"),items,4);
    objc_setAssociatedObject(glyph,DramaActionInkKey,state,1);
    if (mode!=4) Q1(glyph,"setContentMode:",4); // UIViewContentModeCenter uses the image's point size.
    V1(glyph,"setImage:",scaled);
}

B FQHDramaGlyph(Obj owner,const char *selector) {
    Sel glyphSelector=sel_registerName(selector);
    if (!((glyphSelector==sel_registerName("starIcon") && Kind(owner,"SSShortVideoRightInteractionCollectView")) ||
          (glyphSelector==sel_registerName("commentIcon") &&
           (Kind(owner,"SSShortVideoRightInteractionCommentView") || Kind(owner,"SSShortVideoHostRightInteractionCommentView"))) ||
          (glyphSelector==sel_registerName("likeIcon") && Kind(owner,"SSShortVideoRightInteractionLikeView")) ||
          (glyphSelector==sel_registerName("shareIcon") && Kind(owner,"SSShortVideoRightInteractionShareView")))) return 0;
    if (!FQHGlassAvailable() || !FQHButtonAvailable()) return 0;
    Obj glyph=Get(owner,selector);
    Obj parent=Enabled() && Kind(glyph,"UIImageView") ? O0(glyph,"superview") : (Obj)0;
    Rect frame=parent ? Frame(glyph) : (Rect){0};
    if (!VisibleRect(frame)) { DramaActionInk(owner,0,1); RemoveDramaGlass(owner); return 1; }
    double diameter=DramaActionDiameter178R11();
    Rect material={frame.x+(frame.width-diameter)*0.5,frame.y+(frame.height-diameter)*0.5,diameter,diameter};
    Obj glass=PlaceDramaGlass(owner,parent,glyph,material);
    if (!glass) { DramaActionInk(owner,0,1); return 0; }
    DramaActionInk(owner,glyph,diameter/50);
    V1(DramaActionOwners178R11(),"addObject:",owner);
    B hidden=Flag(glyph,"isHidden");
    if (hidden!=Flag(glass,"isHidden")) VB(glass,"setHidden:",hidden);
    return 1;
}
void FQHRefreshDramaActions178R11(void) {
    Obj owners=Get(DramaActionOwners178R11(),"allObjects");
    U count=((U(*)(Obj,Sel))Message)(owners,sel_registerName("count"));
    for (U i=0;i<count;++i) {
        Obj owner=At(owners,i);
        const char *selector=Kind(owner,"SSShortVideoRightInteractionCollectView") ? "starIcon" :
            Kind(owner,"SSShortVideoRightInteractionLikeView") ? "likeIcon" :
            Kind(owner,"SSShortVideoRightInteractionShareView") ? "shareIcon" : "commentIcon";
        FQHDramaGlyph(owner,selector);
    }
}

static void DramaCommentLayout(Obj self,Sel cmd) {
    ((void(*)(Obj,Sel))Original("SSShortVideoHostRightInteractionCommentView","fqx190_originalDramaCommentLayout"))(self,cmd);
    FQHDramaGlyph(self,"commentIcon");
}

static void DramaLikeVisibility(Obj self,Sel cmd,B hidden) {
    ((void(*)(Obj,Sel,B))Original("SSShortVideoRightInteractionLikeView","fqx190_originalDramaLikeVisibility:"))(self,cmd,hidden);
    Obj glass=objc_getAssociatedObject(self,DramaGlassKey);
    if (glass) VB(glass,"setHidden:",hidden);
}

static void DramaClearBackground(Obj view,B clear) {
    Obj color=O0(view,"backgroundColor");
    Obj stock=objc_getAssociatedObject(view,DramaBackgroundKey);
    Obj transparent=O0(Lookup("UIColor"),"clearColor");
    if (clear && color && !SameColor(color,transparent)) {
        objc_setAssociatedObject(view,DramaBackgroundKey,color,1);
        V1(view,"setBackgroundColor:",transparent);
    } else if (!clear && stock) {
        if (SameColor(color,transparent)) V1(view,"setBackgroundColor:",stock);
        objc_setAssociatedObject(view,DramaBackgroundKey,0,1);
    }
}

static void DramaEpisodeArrow(Obj content,Obj arrow) {
    if (!Kind(arrow,"UIImageView") || !Belongs(arrow,content)) arrow=0;
    Obj previous=objc_getAssociatedObject(content,DramaWatchArrowKey);
    if (previous!=arrow) DramaVisibilitySet(previous,1);
    if (previous!=arrow) objc_setAssociatedObject(content,DramaWatchArrowKey,arrow,1);
    if (arrow) DramaVisibilitySet(arrow,0);
}

static void RestoreDramaWatch(Obj owner,Obj content) {
    if (!content) return;
    DramaEpisodeArrow(content,0);
    Obj shade=objc_getAssociatedObject(content,DramaShadeKey);
    RemoveDramaGlass(content);
    DramaClearBackground(content,0);
    BottomRestoreFrame178(content,DramaDockAlignedStockKey,DramaDockAlignedFrameKey);
    if (shade) DramaClearBackground(shade,0);
    objc_setAssociatedObject(content,DramaShadeKey,0,1);
    objc_setAssociatedObject(owner,DramaWatchContentKey,0,1);
}

static B DramaWatchIsEpisode(Obj model) {
    Obj type=Get(Get(model,"bottomBar"),"bottomBarType");
    return Equal(type,"short_play") || Equal(type,"unreal_short_play") || Equal(type,"album");
}

static void DramaWatchGlass(Obj owner,Obj model) {
    Obj previous=objc_getAssociatedObject(owner,DramaWatchContentKey);
    if (!DramaWatchIsEpisode(model) || !Enabled() || !FQHGlassAvailable()) {
        RestoreDramaWatch(owner,previous);
        return;
    }
    Obj content=Get(owner,"defaultContentView");
    if (content!=previous) RestoreDramaWatch(owner,previous);
    if (!Kind(content,"SSShortVideoDistributionContentView") || O0(content,"superview")!=owner) {
        if (content==previous) RestoreDramaWatch(owner,content);
        return;
    }
    DramaAlignWithDockFrame(content,BottomDramaEpisodeDockFrame(content),8);
    Rect bounds=Bounds(content);
    Rect material={bounds.x+8,bounds.y+3,bounds.width-16,bounds.height-6};
    if (!VisibleRect(material)) {
        if (content==previous) RestoreDramaWatch(owner,content);
        return;
    }
    Obj shade=objc_getAssociatedObject(content,DramaShadeKey);
    if (content!=previous) {
        // The inspected host installs a 15%-white UIView at index zero.
        Obj first=O0(O0(content,"subviews"),"firstObject");
        if (first && object_getClass(first)==Lookup("UIView")) {
            double white=0,alpha=0;
            Obj color=O0(first,"backgroundColor");
            if (((B(*)(Obj,Sel,double *,double *))Message)(color,sel_registerName("getWhite:alpha:"),&white,&alpha) &&
                white==1 && alpha>0.125 && alpha<=0.15625) shade=first;
        }
    }
    if (!PlaceDramaGlass(content,content,0,material)) return;
    if (content!=previous) {
        objc_setAssociatedObject(owner,DramaWatchContentKey,content,1);
        if (shade) objc_setAssociatedObject(content,DramaShadeKey,shade,1);
    }
    DramaClearBackground(content,1);
    if (shade) DramaClearBackground(shade,1);
    // This chevron belongs only to the decorated "watch all episodes" row.
    // The original-novel and other distribution rows keep their native arrows.
    DramaEpisodeArrow(content,Get(content,"arrowImageView"));
}

static void DramaDetailRelatedGlass(Obj owner,B reset) {
    Obj content=objc_getAssociatedObject(owner,DramaDetailRelatedContentKey);
    if (!content) return;
    Obj shade=objc_getAssociatedObject(content,DramaDetailRelatedShadeKey);
    if (reset || !Enabled() || !FQHGlassAvailable() || !Belongs(content,owner)) {
        RemoveDramaGlass(content);
        DramaClearBackground(content,0);
        if (shade) DramaClearBackground(shade,0);
        objc_setAssociatedObject(content,DramaDetailRelatedShadeKey,0,1);
        if (reset) objc_setAssociatedObject(owner,DramaDetailRelatedContentKey,0,1);
        return;
    }
    Rect bounds=Bounds(content),material={bounds.x+8,bounds.y+3,bounds.width-16,bounds.height-6};
    if (!VisibleRect(material)) return;
    if (!shade) {
        Obj first=O0(Get(content,"subviews"),"firstObject");
        if (first && object_getClass(first)==Lookup("UIView")) {
            double white=0,alpha=0;
            Obj color=Get(first,"backgroundColor");
            if (((B(*)(Obj,Sel,double *,double *))Message)(color,sel_registerName("getWhite:alpha:"),&white,&alpha) &&
                white==1 && alpha>0.125 && alpha<=0.15625) shade=first;
        }
    }
    if (!PlaceDramaGlass(content,content,0,material)) return;
    DramaClearBackground(content,1);
    if (shade) {
        objc_setAssociatedObject(content,DramaDetailRelatedShadeKey,shade,1);
        DramaClearBackground(shade,1);
    }
}

static void DramaDetailRelatedContent(Obj self,Sel cmd,Obj content,Obj text,Obj tag,Obj recommendation,Obj book,B readTip) {
    ((void(*)(Obj,Sel,Obj,Obj,Obj,Obj,Obj,B))Original("SSShortVideoBottomDistributionView",
        "fqx178r30_originalRelatedContent:text:tag:recommendation:book:readTip:"))
        (self,cmd,content,text,tag,recommendation,book,readTip);
    // This exact host path constructs "原著 · 第N章" and the chapter title.
    // Capture its content after native painting; the outer render/layout hook
    // adds glass after episode decoration has completed, keeping its arrow.
    if (Kind(content,"SSShortVideoDistributionContentBaseView") && Belongs(content,self)) {
        objc_setAssociatedObject(self,DramaDetailRelatedContentKey,content,1);
        DramaDetailRelatedGlass(self,0);
        DramaSpacingForView(self);
    }
}

static void DramaWatchLayout(Obj self,Sel cmd) {
    ((void(*)(Obj,Sel))Original("SSShortVideoBottomDistributionView","fqx190_originalDramaWatchLayout"))(self,cmd);
    DramaWatchGlass(self,Get(self,"lastRenderModel"));
    DramaDetailRelatedGlass(self,0);
    DramaSpacingForView(self);
}

static void DramaWatchRender(Obj self,Sel cmd,Obj model) {
    DramaDetailRelatedGlass(self,1);
    ((void(*)(Obj,Sel,Obj))Original("SSShortVideoBottomDistributionView","fqx190_originalDramaWatchRender:"))(self,cmd,model);
    DramaWatchGlass(self,model);
    DramaDetailRelatedGlass(self,0);
    DramaSpacingForView(self);
}

static void DramaWatchAlbumLayout(Obj self,Sel cmd) {
    ((void(*)(Obj,Sel))Original("SSShortVideoAlbumSeriesBottomInsertView","fqx192_originalDramaWatchAlbumLayout"))(self,cmd);
    Obj content=Get(self,"containerView");
    if (O0(content,"superview")!=self) return;
    B glassEnabled=Enabled() && FQHGlassAvailable() && Get(self,"albumDetailInfo");
    if (glassEnabled) DramaAlignWithDockFrame(content,BottomDramaEpisodeDockFrame(content),8);
    else BottomRestoreFrame178(content,DramaDockAlignedStockKey,DramaDockAlignedFrameKey);
    Rect bounds=Bounds(content);
    Rect material={bounds.x+8,bounds.y+3,bounds.width-16,bounds.height-6};
    if (glassEnabled && VisibleRect(material)) {
        if (PlaceDramaGlass(content,content,0,material)) {
            DramaClearBackground(content,1);
            DramaEpisodeArrow(content,Get(self,"arrowImageView"));
        }
    } else {
        DramaEpisodeArrow(content,0);
        RemoveDramaGlass(content);
        DramaClearBackground(content,0);
    }
    DramaSpacingForView(self);
}

static B DramaSmallGlass(Obj view,B active) {
    if (!Kind(view,"UIView")) return 0;
    Rect bounds=Bounds(view);
    if (active && Enabled() && FQHGlassAvailable() && VisibleRect(bounds) &&
        PlaceDramaGlass(view,view,0,bounds)) {
        DramaClearBackground(view,1);
        return 1;
    }
    RemoveDramaGlass(view);
    DramaClearBackground(view,0);
    return 0;
}

static void DramaDanmakuStockImageKey(void) {}
static void DramaDanmakuAppliedImageKey(void) {}
static void DramaDanmakuStockModeKey(void) {}
static void DramaDanmakuStockFrameKey(void) {}
static void DramaDanmakuAppliedFrameKey(void) {}

static void DramaDanmakuGlyph(Obj entrance,B glass) {
    Obj icon=Get(entrance,"iconView");
    if (!Kind(icon,"UIImageView")) return;
    Obj asset=0;
    if (glass && !Flag(entrance,"usesOverseaDanmaku")) {
        const char *name=Flag(entrance,"danmakuEnabled") ?
            "fq_danmaku_entrance_v741_on" : "fq_danmaku_entrance_v741_off";
        Obj factory=Lookup("FQCShortVideoDanmakuAsset");
        if (Responds(factory,"imageNamed:")) asset=O1(factory,"imageNamed:",Text(name));
    }
    Obj image=Get(icon,"image");
    Obj applied=objc_getAssociatedObject(icon,DramaDanmakuAppliedImageKey);
    Obj stockMode=objc_getAssociatedObject(icon,DramaDanmakuStockModeKey);
    I mode=((I(*)(Obj,Sel))Message)(icon,sel_registerName("contentMode"));
    if (asset) {
        // Reuse the host's unbacked on/off glyph at its original size.
        if (image!=applied) objc_setAssociatedObject(icon,DramaDanmakuStockImageKey,image,1);
        if (!stockMode || mode!=4) objc_setAssociatedObject(icon,DramaDanmakuStockModeKey,Number(mode),1);
        if (image!=asset) V1(icon,"setImage:",asset);
        if (mode!=4) Q1(icon,"setContentMode:",4);
        objc_setAssociatedObject(icon,DramaDanmakuAppliedImageKey,asset,1);
        Obj material=objc_getAssociatedObject(Get(entrance,"toggleButton"),DramaGlassKey);
        Obj parent=Get(icon,"superview");
        if (material && parent && Belongs(icon,entrance)) {
            Rect bounds=Convert(material,Bounds(material),parent),frame=Frame(icon);
            if (VisibleRect(bounds) && VisibleRect(frame)) {
                frame.x=bounds.x+(bounds.width-frame.width)*0.5;
                frame.y=bounds.y+(bounds.height-frame.height)*0.5;
                BottomApplyFrame178(icon,frame,DramaDanmakuStockFrameKey,DramaDanmakuAppliedFrameKey);
            }
        }
    } else if (applied) {
        if (image==applied) V1(icon,"setImage:",objc_getAssociatedObject(icon,DramaDanmakuStockImageKey));
        if (mode==4) Q1(icon,"setContentMode:",(I)Double(stockMode));
        BottomRestoreFrame178(icon,DramaDanmakuStockFrameKey,DramaDanmakuAppliedFrameKey);
        objc_setAssociatedObject(icon,DramaDanmakuStockImageKey,0,1);
        objc_setAssociatedObject(icon,DramaDanmakuStockModeKey,0,1);
        objc_setAssociatedObject(icon,DramaDanmakuAppliedImageKey,0,1);
    }
}

static void DramaDanmakuLayout(Obj self,Sel cmd) {
    ((void(*)(Obj,Sel))Original("FQCShortVideoDanmakuEntranceView","fqx178r8_originalDanmakuLayout"))(self,cmd);
    Obj parent=Get(self,"superview");
    B active=Kind(parent,"SSShortVideoDanmakuLeftAboveView") && Get(parent,"danmakuEntranceView")==self;
    B combined=Flag(self,"combinedStyle");
    Obj capsule=Get(self,"capsuleView"), toggle=Get(self,"toggleButton");
    DramaSmallGlass(capsule,active && combined && Get(capsule,"superview")==self);
    B standalone=DramaSmallGlass(toggle,active && !combined && Get(toggle,"superview")==self);
    DramaDanmakuGlyph(self,standalone);
}

static void DramaDanmakuRefreshIcon(Obj self,Sel cmd) {
    ((void(*)(Obj,Sel))Original("FQCShortVideoDanmakuEntranceView","fqx178r8_originalDanmakuRefreshIcon"))(self,cmd);
    Obj toggle=Get(self,"toggleButton");
    if (objc_getAssociatedObject(toggle,DramaGlassKey)) DramaDanmakuGlyph(self,Enabled() && !Flag(self,"combinedStyle"));
}

static void DramaFullscreenButtonApply178R11(Obj self) {
    Obj button=Get(self,"fullscreenBtn");
    DramaSmallGlass(button,Kind(button,"UIButton") && Belongs(button,self));
}
static void DramaFullscreenButtonLayout(Obj self,Sel cmd) {
    ((void(*)(Obj,Sel))Original("FQVShortVideoVPlayerControlView","fqx178r8_originalFullscreenButtonLayout"))(self,cmd);
    DramaFullscreenButtonApply178R11(self);
}

// Decorate the inspected landscape controls in their existing tap containers.
// The material never handles gestures, playback or accessibility actions.
static void LandscapeClip178R12Key(void) {}
static void LandscapeControlGlass178R9(Obj view,Obj owner,double maximum) {
    if (!Kind(view,"UIView") || !Belongs(view,owner)) return;
    Rect bounds=Bounds(view);
    if (!Enabled() || !FQHGlassAvailable() || !VisibleRect(bounds)) {
        Obj clip=objc_getAssociatedObject(view,LandscapeClip178R12Key);
        if (clip && !Flag(view,"clipsToBounds")) VB(view,"setClipsToBounds:",1);
        objc_setAssociatedObject(view,LandscapeClip178R12Key,0,1);
        RemoveDramaGlass(view); DramaClearBackground(view,0); return;
    }
    B image=Kind(view,"UIImageView");
    Obj parent=image ? Get(view,"superview") : view;
    Rect material=image ? Frame(view) : bounds;
    double height=maximum ? (maximum>44 ? 56 : 36) : material.height;
    double width=maximum ? height : material.width;
    material=(Rect){material.x+(material.width-width)*0.5,material.y+(material.height-height)*0.5,width,height};
    Obj glass=PlaceDramaGlass(view,parent,image ? view : (Obj)0,material);
    if (!glass) return;
    if (!image && (width>bounds.width || height>bounds.height) && Flag(view,"clipsToBounds")) {
        objc_setAssociatedObject(view,LandscapeClip178R12Key,BoolBox(1),1);
        VB(view,"setClipsToBounds:",0);
    }
    DramaClearBackground(view,1);
    if (image) {
        VB(glass,"setHidden:",Flag(view,"isHidden"));
        ((void(*)(Obj,Sel,double))Message)(glass,sel_registerName("setAlpha:"),
            ((double(*)(Obj,Sel))Message)(view,sel_registerName("alpha")));
    }
}
static void LandscapeTitleStock178R10Key(void) {}
static void LandscapeTitleApplied178R10Key(void) {}
static void LandscapeConstraintStock178R12Key(void) {}
static void LandscapeConstraintApplied178R12Key(void) {}
static void LandscapeLeadingSpacing178R12(Obj title,Obj back,Obj owner,double gap) {
    if (!Kind(title,"UIView") || !Belongs(title,owner)) return;
    Obj applied=objc_getAssociatedObject(title,LandscapeTitleApplied178R10Key);
    Obj saved=objc_getAssociatedObject(title,LandscapeTitleStock178R10Key);
    Rect current=Frame(title),base=current;
    if (saved && applied && current.x==UnboxRect(applied).x) {
        base.x=UnboxRect(saved).x;
        base.width=current.x+current.width-base.x;
    }
    Obj glass=objc_getAssociatedObject(back,DramaGlassKey);
    B active=Enabled() && glass && Belongs(glass,owner) && !Flag(glass,"isHidden");
    Obj parent=Get(title,"superview");
    Rect capsule=active ? Convert(glass,Bounds(glass),parent) : (Rect){0};
    Rect anchor=active ? Convert(back,Bounds(back),parent) : (Rect){0};
    // Both inspected Masonry rows pin the label/input's left to the icon's
    // right. Keep that native constraint in sync so later Auto Layout does
    // not overwrite the visible gap applied during this layout pass.
    Obj constraints=Get(parent,"constraints");
    U count=((U(*)(Obj,Sel))Message)(constraints,sel_registerName("count"));
    for (U i=0;i<count;++i) {
        Obj constraint=At(constraints,i);
        if (Get(constraint,"firstItem")!=title || Get(constraint,"secondItem")!=back) continue;
        I first=((I(*)(Obj,Sel))Message)(constraint,sel_registerName("firstAttribute"));
        I second=((I(*)(Obj,Sel))Message)(constraint,sel_registerName("secondAttribute"));
        if (!((first==1 && second==2) || (first==5 && second==6))) continue;
        double value=((double(*)(Obj,Sel))Message)(constraint,sel_registerName("constant"));
        Obj original=objc_getAssociatedObject(constraint,LandscapeConstraintStock178R12Key);
        Obj previous=objc_getAssociatedObject(constraint,LandscapeConstraintApplied178R12Key);
        double stock=original && previous && value==Double(previous) ? Double(original) : value;
        double wanted=active ? __builtin_fmax(stock,capsule.x+capsule.width-anchor.x-anchor.width+gap) : stock;
        objc_setAssociatedObject(constraint,LandscapeConstraintStock178R12Key,active && wanted!=stock ? Number(stock) : (Obj)0,1);
        objc_setAssociatedObject(constraint,LandscapeConstraintApplied178R12Key,active && wanted!=stock ? Number(wanted) : (Obj)0,1);
        if (value!=wanted) ((void(*)(Obj,Sel,double))Message)(constraint,sel_registerName("setConstant:"),wanted);
    }
    if (!active) {
        if (saved && applied && !SameRect(current,base)) SetFrame(title,base);
        objc_setAssociatedObject(title,LandscapeTitleStock178R10Key,0,1);
        objc_setAssociatedObject(title,LandscapeTitleApplied178R10Key,0,1);
        return;
    }
    double inset=__builtin_fmax(0,capsule.x+capsule.width+gap-base.x);
    if (inset>=base.width) return;
    Rect target={base.x+inset,base.y,base.width-inset,base.height};
    objc_setAssociatedObject(title,LandscapeTitleStock178R10Key,RectBox(base),1);
    objc_setAssociatedObject(title,LandscapeTitleApplied178R10Key,RectBox(target),1);
    if (!SameRect(current,target)) SetFrame(title,target);
}
static void LandscapeInfoGlass178R9(Obj self,Sel cmd) {
    ((void(*)(Obj,Sel))Original("FQVShortVideoPlayerLandscapeBaseInfoView","fqx178r9_originalLandscapeInfoLayout"))(self,cmd);
    LandscapeControlGlass178R9(Get(self,"navBackImageView"),self,44);
    LandscapeLeadingSpacing178R12(Get(self,"titleL"),Get(self,"navBackImageView"),self,12);
    LandscapeControlGlass178R9(Get(self,"playBtn"),self,56);
    LandscapeControlGlass178R9(Get(self,"nextBtn"),self,44);
    LandscapeControlGlass178R9(Get(self,"moreBtn"),self,44);
    LandscapeControlGlass178R9(Get(self,"muteView"),self,44);
}
static void LandscapePlayerGlass178R9(Obj self,Sel cmd) {
    ((void(*)(Obj,Sel))Original("FQVShortVideoPlayerLandscapeBaseControlView","fqx178r9_originalLandscapePlayerLayout"))(self,cmd);
    LandscapeControlGlass178R9(Get(self,"screenLockBtn"),self,44);
    LandscapeControlGlass178R9(Get(self,"landingMuteView"),self,44);
}
static void LandscapeNavApply178R9(Obj self) {
    Obj items=Get(self,"itemList");
    U count=((U(*)(Obj,Sel))Message)(items,sel_registerName("count"));
    for (U i=0;i<count;++i) {
        Obj item=At(items,i),view=Get(item,"view");
        if (Kind(item,"FQVShortVideoLandscapeNavBarItem") && Bounds(view).width<=90)
            LandscapeControlGlass178R9(view,self,44);
    }
}
static void LandscapeNavGlass178R9(Obj self,Sel cmd) {
    ((void(*)(Obj,Sel))Original("FQVShortVideoLandscapeNavBar","fqx178r9_originalLandscapeNavLayout"))(self,cmd);
    LandscapeNavApply178R9(self);
}
static void LandscapeNavLaidOut178R9(Obj self,Sel cmd) {
    ((void(*)(Obj,Sel))Original("FQVShortVideoLandscapeNavBar","fqx178r9_originalLandscapeNavSubviews"))(self,cmd);
    LandscapeNavApply178R9(self);
}
static void ShelfEditPadding(Obj button);
static void LandscapeStackSpacing178R12Key(void) {}
static void LandscapeBottomGlass178R9(Obj self,Sel cmd) {
    // Reuse the existing reversible 12pt horizontal / 7pt vertical content
    // padding before UIStackView resolves each native button's intrinsic size.
    ShelfEditPadding(Get(self,"seriesBtn"));
    ShelfEditPadding(Get(self,"playRateBtn"));
    ShelfEditPadding(Get(self,"resolutionBtn"));
    Obj stack=Get(self,"stackView");
    if (Kind(stack,"UIStackView") && Belongs(stack,self)) {
        Obj saved=objc_getAssociatedObject(stack,LandscapeStackSpacing178R12Key);
        double current=((double(*)(Obj,Sel))Message)(stack,sel_registerName("spacing"));
        B active=Enabled() && FQHGlassAvailable();
        if (active && (!saved || current!=12)) objc_setAssociatedObject(stack,LandscapeStackSpacing178R12Key,Number(current),1);
        double wanted=active ? 12 : (saved && current==12 ? Double(saved) : current);
        if (!active) objc_setAssociatedObject(stack,LandscapeStackSpacing178R12Key,0,1);
        if (current!=wanted) ((void(*)(Obj,Sel,double))Message)(stack,sel_registerName("setSpacing:"),wanted);
    }
    ((void(*)(Obj,Sel))Original("FQVShortVideoLandscapeBottomRightView","fqx178r9_originalLandscapeBottomLayout"))(self,cmd);
    // These intrinsic-size buttons are arranged by a nested UIStackView. Its
    // layout follows the outer view's layout, so settle that child subtree
    // before reading button bounds for the material on the first frame.
    if (Kind(stack,"UIStackView") && Belongs(stack,self)) V0(stack,"layoutIfNeeded");
    LandscapeControlGlass178R9(Get(self,"seriesBtn"),self,0);
    LandscapeControlGlass178R9(Get(self,"playRateBtn"),self,0);
    LandscapeControlGlass178R9(Get(self,"resolutionBtn"),self,0);
}
static void LandscapeInputBackground178R10Key(void) {}
static void LandscapeInputBackground178R10(Obj input,Obj background) {
    if (!Kind(background,"UIView") || !Belongs(background,input)) return;
    Obj saved=objc_getAssociatedObject(background,LandscapeInputBackground178R10Key);
    B active=objc_getAssociatedObject(input,DramaGlassKey)!=0;
    if (active) {
        // The host can supply UIVisualEffectView here. Clearing its color
        // leaves the blur opaque over our glass, so hide that exact layer.
        if (!saved) objc_setAssociatedObject(background,LandscapeInputBackground178R10Key,BoolBox(Flag(background,"isHidden")),1);
        if (!Flag(background,"isHidden")) VB(background,"setHidden:",1);
    } else if (saved) {
        if (Flag(background,"isHidden")) VB(background,"setHidden:",Flag(saved,"boolValue"));
        objc_setAssociatedObject(background,LandscapeInputBackground178R10Key,0,1);
    }
}
static void LandscapeCountStockFrameKey(void) {}
static void LandscapeCountFrameKey(void) {}
static void LandscapeCountAlignmentKey(void) {}
static void LandscapeCountFitsKey(void) {}

static void LandscapeCountGlass(Obj owner,Obj button,Obj icon,Obj count) {
    LandscapeControlGlass178R9(button,owner,36);
    Obj glass=objc_getAssociatedObject(button,DramaGlassKey);
    if (!Kind(icon,"UIView") || !Kind(count,"UILabel")) return;
    I alignment=((I(*)(Obj,Sel))Message)(count,sel_registerName("textAlignment"));
    B fits=Flag(count,"adjustsFontSizeToFitWidth");
    if (glass && Belongs(icon,button) && Belongs(count,button)) {
        // Let the native container settle its child constraints before styling.
        V0(button,"layoutIfNeeded");
        Rect bounds=Bounds(glass);
        Rect iconRect={bounds.x+(bounds.width-15)*0.5,bounds.y+4,15,15};
        Rect countRect={bounds.x+(bounds.width-25)*0.5,bounds.y+20,25,10.5};
        BottomApplyFrame178(icon,Convert(glass,iconRect,Get(icon,"superview")),
            LandscapeCountStockFrameKey,LandscapeCountFrameKey);
        BottomApplyFrame178(count,Convert(glass,countRect,Get(count,"superview")),
            LandscapeCountStockFrameKey,LandscapeCountFrameKey);
        AppearanceFont(count,9.5);
        if (alignment!=1) {
            objc_setAssociatedObject(count,LandscapeCountAlignmentKey,Number(alignment),1);
            Q1(count,"setTextAlignment:",1);
        }
        if (!fits) {
            objc_setAssociatedObject(count,LandscapeCountFitsKey,BoolBox(1),1);
            VB(count,"setAdjustsFontSizeToFitWidth:",1);
        }
    } else {
        BottomRestoreFrame178(icon,LandscapeCountStockFrameKey,LandscapeCountFrameKey);
        BottomRestoreFrame178(count,LandscapeCountStockFrameKey,LandscapeCountFrameKey);
        RestoreAppearanceFont(count);
        Obj stock=objc_getAssociatedObject(count,LandscapeCountAlignmentKey);
        if (stock && alignment==1) Q1(count,"setTextAlignment:",(I)Double(stock));
        if (fits && objc_getAssociatedObject(count,LandscapeCountFitsKey)) VB(count,"setAdjustsFontSizeToFitWidth:",0);
        objc_setAssociatedObject(count,LandscapeCountAlignmentKey,0,1);
        objc_setAssociatedObject(count,LandscapeCountFitsKey,0,1);
    }
}

static void LandscapeSocialApply178R9(Obj self) {
    LandscapeCountGlass(self,Get(self,"likeBtnView"),Get(self,"likeIcon"),Get(self,"likeCountLabel"));
    LandscapeCountGlass(self,Get(self,"commentBtnView"),Get(self,"commentIcon"),Get(self,"commentCountLabel"));
    LandscapeCountGlass(self,Get(self,"starBtnView"),Get(self,"starIcon"),Get(self,"starCountLabel"));
    LandscapeControlGlass178R9(Get(self,"danmakuBtnView"),self,36);
    Obj input=Get(self,"danmakuInputView"),background=Get(self,"danmakuInputBGView");
    LandscapeLeadingSpacing178R12(input,Get(self,"danmakuBtnView"),self,8);
    LandscapeControlGlass178R9(input,self,0);
    LandscapeInputBackground178R10(input,background);
    LandscapeControlGlass178R9(Get(self,"danmakuPublishBtn"),self,0);
}
static void LandscapeSocialGlass178R9(Obj self,Sel cmd) {
    ((void(*)(Obj,Sel))Original("SSShortVideoLandscapeBizInteractionView","fqx178r9_originalLandscapeSocialLayout"))(self,cmd);
    LandscapeSocialApply178R9(self);
}
static void LandscapeSocialRefresh178R9(Obj self,Sel cmd) {
    ((void(*)(Obj,Sel))Original("SSShortVideoLandscapeBizInteractionView","fqx178r9_originalLandscapeSocialRefresh"))(self,cmd);
    LandscapeSocialApply178R9(self);
}
static void LandscapeDanmakuChanged178R9(Obj self,Sel cmd,B enabled) {
    ((void(*)(Obj,Sel,B))Original("SSShortVideoLandscapeBizInteractionView","fqx178r9_originalLandscapeDanmakuChanged:"))(self,cmd,enabled);
    LandscapeSocialApply178R9(self);
}
static void LandscapeEntryGlass178R9(Obj self,Sel cmd) {
    ((void(*)(Obj,Sel))Original("SSShortVideoLandscapeAutoInflowTipView","fqx178r9_originalLandscapeEntryLayout"))(self,cmd);
    DramaSmallGlass(self,1);
}
static void LandscapeAdjustGlass178R9(Obj self,Sel cmd) {
    ((void(*)(Obj,Sel))Original("FQVLandscapeAdjustButtonBase","fqx178r9_originalLandscapeAdjustLayout"))(self,cmd);
    LandscapeControlGlass178R9(self,self,36);
}
static void LandscapeLayoutHook178R9(const char *name,const char *alias,Imp imp) {
    Obj cls=Lookup(name);
    Sel layout=sel_registerName("layoutSubviews"),saved=sel_registerName(alias);
    if (!ClassABI(cls,"layoutSubviews","v16@0:8") || class_getInstanceMethod(cls,saved)) return;
    Method method=class_getInstanceMethod(cls,layout);
    if (FQDResolveOwned(cls,layout,0,"v16@0:8")) Hook(name,"layoutSubviews",alias,"v16@0:8",imp);
    else if (class_addMethod(cls,saved,method_getImplementation(method),"v16@0:8"))
        class_addMethod(cls,layout,imp,"v16@0:8");
}
static void LandscapeGlassInstall178R9(void) {
    LandscapeLayoutHook178R9("FQVShortVideoPlayerLandscapeBaseInfoView","fqx178r9_originalLandscapeInfoLayout",(Imp)LandscapeInfoGlass178R9);
    LandscapeLayoutHook178R9("FQVShortVideoPlayerLandscapeBaseControlView","fqx178r9_originalLandscapePlayerLayout",(Imp)LandscapePlayerGlass178R9);
    LandscapeLayoutHook178R9("FQVShortVideoLandscapeBottomRightView","fqx178r9_originalLandscapeBottomLayout",(Imp)LandscapeBottomGlass178R9);
    LandscapeLayoutHook178R9("SSShortVideoLandscapeBizInteractionView","fqx178r9_originalLandscapeSocialLayout",(Imp)LandscapeSocialGlass178R9);
    LandscapeLayoutHook178R9("SSShortVideoLandscapeAutoInflowTipView","fqx178r9_originalLandscapeEntryLayout",(Imp)LandscapeEntryGlass178R9);
    LandscapeLayoutHook178R9("FQVShortVideoLandscapeNavBar","fqx178r9_originalLandscapeNavSubviews",(Imp)LandscapeNavLaidOut178R9);
    Hook("FQVLandscapeAdjustButtonBase","layoutSubviews","fqx178r9_originalLandscapeAdjustLayout","v16@0:8",(Imp)LandscapeAdjustGlass178R9);
    Hook("FQVShortVideoLandscapeNavBar","refreshLayout","fqx178r9_originalLandscapeNavLayout","v16@0:8",(Imp)LandscapeNavGlass178R9);
    Hook("SSShortVideoLandscapeBizInteractionView","refreshUI","fqx178r9_originalLandscapeSocialRefresh","v16@0:8",(Imp)LandscapeSocialRefresh178R9);
    Hook("SSShortVideoLandscapeBizInteractionView","danmakuSwitchDidChange:","fqx178r9_originalLandscapeDanmakuChanged:","v20@0:8B16",(Imp)LandscapeDanmakuChanged178R9);
}

// Portrait episode details use different native owners from the main feed.
// Keep their buttons, tap recognizers and callback blocks as the input surface.
static void DramaDetailNavConstraintsKey(void) {}
static void DramaDetailEpisodeStockKey(void) {}
static void DramaDetailEpisodeAppliedKey(void) {}
static void DramaDetailNovelStockKey(void) {}
static void DramaDetailNovelAppliedKey(void) {}
static void DramaDetailNavigationButton(Obj button,Obj nav,B stockBackGlyph) {
    if (!Kind(button,"UIButton") || !Belongs(button,nav)) return;
    if (!Enabled() || !FQHGlassAvailable()) { LandscapeControlGlass178R9(button,nav,44); return; }
    Obj parent=Get(button,"superview"),glyph=Get(button,"imageView");
    if (!parent || !Kind(glyph,"UIImageView") || !Belongs(glyph,button)) return;
    Obj glass=objc_getAssociatedObject(button,DramaGlassKey);
    if (glass && Get(glass,"superview")!=parent) {
        Obj previous=objc_getAssociatedObject(glass,DramaDetailNavConstraintsKey);
        if (previous) V1(Lookup("NSLayoutConstraint"),"deactivateConstraints:",previous);
        objc_setAssociatedObject(glass,DramaDetailNavConstraintsKey,0,1);
    }
    if (!glass || Get(glass,"superview")!=parent)
        glass=PlaceDramaGlass(button,parent,button,(Rect){0,0,36,36});
    if (!glass) return;
    Obj anchors=objc_getAssociatedObject(glass,DramaDetailNavConstraintsKey);
    if (!anchors) {
        VB(glass,"setTranslatesAutoresizingMaskIntoConstraints:",0);
        // A sibling backing stays behind the native button and its glyph.
        Obj constraints[]={
            O1(Get(glass,"centerXAnchor"),"constraintEqualToAnchor:",Get(glyph,"centerXAnchor")),
            O1(Get(glass,"centerYAnchor"),"constraintEqualToAnchor:",Get(glyph,"centerYAnchor")),
            ((Obj(*)(Obj,Sel,double))Message)(Get(glass,"widthAnchor"),sel_registerName("constraintEqualToConstant:"),36.),
            ((Obj(*)(Obj,Sel,double))Message)(Get(glass,"heightAnchor"),sel_registerName("constraintEqualToConstant:"),36.)};
        anchors=((Obj(*)(Obj,Sel,Obj *,U))Message)(Lookup("NSArray"),sel_registerName("arrayWithObjects:count:"),constraints,4);
        V1(Lookup("NSLayoutConstraint"),"activateConstraints:",anchors);
        objc_setAssociatedObject(glass,DramaDetailNavConstraintsKey,anchors,1);
    }
    // short_video_nav_back puts its visible ink at 11/48 and 16.5/72 on
    // the @2x/@3x canvases. Align the backing with that ink, preserving the
    // original image, button frame and tap target.
    Obj image=stockBackGlyph ? Get(glyph,"image") : 0;
    double width=image ? ((Size(*)(Obj,Sel))Message)(image,sel_registerName("size")).width : 0;
    double offset=width*((5.5/24.0)-0.5);
    Obj centerX=At(anchors,0);
    if (((double(*)(Obj,Sel))Message)(centerX,sel_registerName("constant"))!=offset)
        ((void(*)(Obj,Sel,double))Message)(centerX,sel_registerName("setConstant:"),offset);
    VB(glass,"setHidden:",Flag(button,"isHidden") || Flag(glyph,"isHidden"));
    ((void(*)(Obj,Sel,double))Message)(glass,sel_registerName("setAlpha:"),
        ((double(*)(Obj,Sel))Message)(button,sel_registerName("alpha")));
    DramaClearBackground(button,1);
}
static void DramaDetailNavigationTitle(Obj title,Obj back,Obj nav) {
    if (!Kind(title,"UILabel") || !Belongs(title,nav) || !Belongs(back,nav)) return;
    Obj glass=objc_getAssociatedObject(back,DramaGlassKey);
    B active=Enabled() && glass && Belongs(glass,nav) && !Flag(glass,"isHidden");
    Obj constraints=Get(Get(title,"superview"),"constraints");
    for (U i=0,count=TabCount(constraints);i<count;++i) {
        Obj constraint=At(constraints,i);
        if (Get(constraint,"firstItem")!=title || Get(constraint,"secondItem")!=back) continue;
        I first=((I(*)(Obj,Sel))Message)(constraint,sel_registerName("firstAttribute"));
        I second=((I(*)(Obj,Sel))Message)(constraint,sel_registerName("secondAttribute"));
        if (!((first==1 && second==2) || (first==5 && second==6)) ||
            ((I(*)(Obj,Sel))Message)(constraint,sel_registerName("relation"))!=0 ||
            ((double(*)(Obj,Sel))Message)(constraint,sel_registerName("multiplier"))!=1) continue;
        double value=((double(*)(Obj,Sel))Message)(constraint,sel_registerName("constant"));
        Obj original=objc_getAssociatedObject(constraint,LandscapeConstraintStock178R12Key);
        Obj previous=objc_getAssociatedObject(constraint,LandscapeConstraintApplied178R12Key);
        double stock=original && previous && value==Double(previous) ? Double(original) : value;
        // The host pins navLeftLabel directly to backBtn.right. Reserve space
        // in that constraint before Auto Layout resolves the new glass frame.
        double wanted=active ? __builtin_fmax(stock,12) : stock;
        objc_setAssociatedObject(constraint,LandscapeConstraintStock178R12Key,active && wanted!=stock ? Number(stock) : (Obj)0,1);
        objc_setAssociatedObject(constraint,LandscapeConstraintApplied178R12Key,active && wanted!=stock ? Number(wanted) : (Obj)0,1);
        if (value!=wanted) ((void(*)(Obj,Sel,double))Message)(constraint,sel_registerName("setConstant:"),wanted);
    }
}
static void DramaDetailNavigationApply(Obj component) {
    Obj nav=Get(component,"navBar");
    Obj name=Get(Get(Get(component,"listVCContext"),"config"),"navBackImageName");
    DramaDetailNavigationButton(Get(component,"backBtn"),nav,!name || Equal(name,"short_video_nav_back"));
    DramaDetailNavigationTitle(Get(component,"navLeftLabel"),Get(component,"backBtn"),nav);
    DramaDetailNavigationButton(Get(component,"moreBtn"),nav,0);
    Obj items=Get(component,"navigationBarRightItems");
    for (U i=0,count=TabCount(items);i<count;++i) {
        Obj item=At(items,i);
        if (Kind(item,"FQVShortVideoMoreBtnNavBarItem"))
            DramaDetailNavigationButton(Get(item,"moreBtn"),nav,0);
    }
}
static void DramaDetailNavigationLayout(Obj self,Sel cmd,Obj container) {
    ((void(*)(Obj,Sel,Obj))Original("FQVShortVideoListVCNavBarComponent","fqx178r29_originalNavLayout:"))(self,cmd,container);
    DramaDetailNavigationApply(self);
}
static void DramaDetailNavigationLeft(Obj self,Sel cmd) {
    ((void(*)(Obj,Sel))Original("FQVShortVideoListVCNavBarComponent","fqx178r29_originalNavLeft"))(self,cmd);
    DramaDetailNavigationApply(self);
}
static void DramaDetailNavigationRight(Obj self,Sel cmd,Obj items) {
    ((void(*)(Obj,Sel,Obj))Original("FQVShortVideoListVCNavBarComponent","fqx178r29_originalNavRight:"))(self,cmd,items);
    DramaDetailNavigationApply(self);
}
static void DramaDetailNavigationLegacyRight(Obj self,Sel cmd,Obj context,U value) {
    ((void(*)(Obj,Sel,Obj,U))Original("FQVShortVideoListVCNavBarComponent",
        "fqx178r32_originalLegacyNavRight:showItemValue:"))(self,cmd,context,value);
    DramaDetailNavigationApply(self);
}
static void DramaDetailMoreItemSetup(Obj self,Sel cmd) {
    ((void(*)(Obj,Sel))Original("FQVShortVideoMoreBtnNavBarItem","fqx178r29_originalMoreSetup"))(self,cmd);
    Obj button=Get(self,"moreBtn");
    DramaDetailNavigationButton(button,Get(self,"view"),0);
}
static void DramaDetailOriginalLayout(Obj self,Sel cmd) {
    ((void(*)(Obj,Sel))Original("SSShortVideoOriginalNovelEntranceView","fqx178r29_originalDetailNovelLayout"))(self,cmd);
    Rect bounds=Bounds(self),frame={bounds.x+8,bounds.y+3,bounds.width-16,bounds.height-6};
    if (Enabled() && FQHGlassAvailable() && VisibleRect(frame) && PlaceDramaGlass(self,self,0,frame))
        DramaClearBackground(self,1);
    else { RemoveDramaGlass(self); DramaClearBackground(self,0); }
    DramaSpacingForView(self);
}
static void DramaDetailBottomSpacing(Obj view,Obj episode,Obj novel) {
    // R36: keep the native detail stack clear of the home-indicator and floating-dock edge.
    Obj window=Get(view,"window");
    if (!window || !Kind(view,"UIView") || !Kind(episode,"UIView") || !Belongs(episode,view)) {
        BottomRestoreFrame178(episode,DramaDetailEpisodeStockKey,DramaDetailEpisodeAppliedKey);
        BottomRestoreFrame178(novel,DramaDetailNovelStockKey,DramaDetailNovelAppliedKey);
        return;
    }
    Rect windowBounds=Bounds(window),viewWindow=Convert(view,Bounds(view),window);
    Insets safe=((Insets(*)(Obj,Sel))Message)(window,sel_registerName("safeAreaInsets"));
    double safeBottom=windowBounds.y+windowBounds.height-safe.bottom;
    B hasNovel=Kind(novel,"UIView") && Belongs(novel,view) && !Belongs(novel,episode);
    Rect episodeWindow=Convert(episode,Bounds(episode),window);
    double contentBottom=episodeWindow.y+episodeWindow.height;
    Rect novelWindow={0};
    if (hasNovel) {
        novelWindow=Convert(novel,Bounds(novel),window);
        contentBottom=__builtin_fmax(contentBottom,novelWindow.y+novelWindow.height);
    }
    Obj dock=BottomDramaCapsuleForView(view);
    if (dock) {
        Rect dockWindow=Convert(dock,Bounds(dock),window);
        if (VisibleRect(dockWindow)) safeBottom=__builtin_fmin(safeBottom,dockWindow.y);
    }
    B eligible=windowBounds.height>windowBounds.width && viewWindow.width>=windowBounds.width*0.5 &&
        viewWindow.y+viewWindow.height>=safeBottom-180 && viewWindow.y<safeBottom;
    double shift=eligible ? contentBottom-(safeBottom-8) : 0;
    if (!eligible || !__builtin_isfinite(shift) || shift<=0.5 || shift>24) {
        BottomRestoreFrame178(episode,DramaDetailEpisodeStockKey,DramaDetailEpisodeAppliedKey);
        BottomRestoreFrame178(novel,DramaDetailNovelStockKey,DramaDetailNovelAppliedKey);
        return;
    }
    Rect episodeFrame=Frame(episode);
    episodeFrame.y-=shift;
    BottomApplyFrame178(episode,episodeFrame,DramaDetailEpisodeStockKey,DramaDetailEpisodeAppliedKey);
    if (hasNovel) {
        Rect novelFrame=Frame(novel);
        novelFrame.y-=shift;
        BottomApplyFrame178(novel,novelFrame,DramaDetailNovelStockKey,DramaDetailNovelAppliedKey);
    } else {
        BottomRestoreFrame178(novel,DramaDetailNovelStockKey,DramaDetailNovelAppliedKey);
    }
}
static void DramaDetailBottomApply(Obj view) {
    Obj episode=Get(view,"episodeInfoView");
    DramaSmallGlass(episode,Belongs(episode,view));
    Obj novel=Get(view,"relateBookEntranceView");
    DramaDetailBottomSpacing(view,episode,novel);
    if (novel && !Belongs(novel,episode)) DramaSmallGlass(novel,Belongs(novel,view));
    LandscapeControlGlass178R9(Get(view,"cleanScreenView"),view,44);
}
static void DramaDetailSingleLayout(Obj self,Sel cmd) {
    ((void(*)(Obj,Sel))Original("SSShortVideoSingleBottomInsertView","fqx178r29_originalSingleBottomLayout"))(self,cmd);
    DramaDetailBottomApply(self);
}
static void DramaDetailTagLayout(Obj self,Sel cmd) {
    ((void(*)(Obj,Sel))Original("SSShortVideoTagListBottomInsertView","fqx178r29_originalTagBottomLayout"))(self,cmd);
    DramaDetailBottomApply(self);
}
static void DramaDetailPlayerBottomLayout(Obj self,Sel cmd) {
    ((void(*)(Obj,Sel))Original("FQVShortVideoPlayerBottomView","fqx178r30_originalPlayerBottomLayout"))(self,cmd);
    if (Flag(self,"isNewSingleSeriesControlViewStyle")) {
        Obj current=Get(self,"episodeNewInfoView");
        if (Belongs(current,self)) LandscapeControlGlass178R9(Get(current,"cleanScreenEntrance"),current,44);
    } else {
        Obj episode=Get(self,"episodeInfoView");
        DramaSmallGlass(episode,Belongs(episode,self));
        LandscapeControlGlass178R9(Get(self,"cleanSwitchView"),self,44);
    }
}
static void DramaDetailGlassInstall(void) {
    const char *nav="FQVShortVideoListVCNavBarComponent";
    if (Signature(nav,"navBar","@16@0:8") && Signature(nav,"backBtn","@16@0:8") && Signature(nav,"moreBtn","@16@0:8")) {
        Hook(nav,"setupLayout:","fqx178r29_originalNavLayout:","v24@0:8@16",(Imp)DramaDetailNavigationLayout);
        Hook(nav,"updateNavgationBarLeftView","fqx178r29_originalNavLeft","v16@0:8",(Imp)DramaDetailNavigationLeft);
        Hook(nav,"updateNavgationBarRightViewWithRightItems:","fqx178r29_originalNavRight:","v24@0:8@16",(Imp)DramaDetailNavigationRight);
        Hook(nav,"updateNavgationBarRightView:showItemValue:","fqx178r32_originalLegacyNavRight:showItemValue:",
             "v32@0:8@16Q24",(Imp)DramaDetailNavigationLegacyRight);
    }
    if (Signature("FQVShortVideoMoreBtnNavBarItem","moreBtn","@16@0:8"))
        Hook("FQVShortVideoMoreBtnNavBarItem","setUp","fqx178r29_originalMoreSetup","v16@0:8",(Imp)DramaDetailMoreItemSetup);
    Hook("SSShortVideoOriginalNovelEntranceView","layoutSubviews","fqx178r29_originalDetailNovelLayout","v16@0:8",(Imp)DramaDetailOriginalLayout);
    if (Signature("SSShortVideoSingleBottomInsertView","episodeInfoView","@16@0:8"))
        LandscapeLayoutHook178R9("SSShortVideoSingleBottomInsertView","fqx178r29_originalSingleBottomLayout",(Imp)DramaDetailSingleLayout);
    if (Signature("SSShortVideoTagListBottomInsertView","episodeInfoView","@16@0:8"))
        LandscapeLayoutHook178R9("SSShortVideoTagListBottomInsertView","fqx178r29_originalTagBottomLayout",(Imp)DramaDetailTagLayout);
    const char *bottom="FQVShortVideoPlayerBottomView";
    if (Signature(bottom,"episodeInfoView","@16@0:8") && Signature(bottom,"cleanSwitchView","@16@0:8") &&
        Signature(bottom,"isNewSingleSeriesControlViewStyle","B16@0:8"))
        LandscapeLayoutHook178R9(bottom,"fqx178r30_originalPlayerBottomLayout",(Imp)DramaDetailPlayerBottomLayout);
    Hook("SSShortVideoBottomDistributionView",
         "applyRelatedInfoUIToContentView:textArray:showTag:recommendTagText:bookInfo:canShowReadTip:",
         "fqx178r30_originalRelatedContent:text:tag:recommendation:book:readTip:","v60@0:8@16@24@32@40@48B56",
         (Imp)DramaDetailRelatedContent);
}

static B DefaultEnabled(Obj key);
static void DramaVisibilityOwnersKey(void) {}
static void DramaVisibilityHiddenKey(void) {}

static Obj DramaVisibilityOwners(void) {
    Obj owner=Lookup("SSVideoSeriesFeedHeaderView");
    Obj owners=objc_getAssociatedObject(owner,DramaVisibilityOwnersKey);
    if (!owners) {
        owners=O0(Lookup("NSHashTable"),"weakObjectsHashTable");
        objc_setAssociatedObject(owner,DramaVisibilityOwnersKey,owners,1);
    }
    return owners;
}

static void DramaVisibilityTrack(Obj owner) {
    if (objc_getAssociatedObject(owner,DramaVisibilityOwnersKey)) return;
    Obj owners=DramaVisibilityOwners();
    if (!owners) return;
    V1(owners,"addObject:",owner);
    objc_setAssociatedObject(owner,DramaVisibilityOwnersKey,BoolBox(1),1);
}

static void DramaVisibilitySet(Obj view,B visible) {
    if (!Kind(view,"UIView")) return;
    Obj owned=objc_getAssociatedObject(view,DramaVisibilityHiddenKey);
    B hidden=Flag(view,"isHidden");
    if (!visible && !hidden) {
        objc_setAssociatedObject(view,DramaVisibilityHiddenKey,BoolBox(1),1);
        VB(view,"setHidden:",1);
    } else if (visible && owned) {
        if (hidden) VB(view,"setHidden:",0);
        objc_setAssociatedObject(view,DramaVisibilityHiddenKey,0,1);
    }
}

static B DramaVisibilityOwnsHeader(Obj header) {
    Obj delegate=Get(header,"delegate");
    return Kind(delegate,"SSVideoSeriesFeedViewController") && Get(delegate,"headerView")==header;
}

static void DramaSearchBackgroundSetHidden(Obj self,Sel cmd,B hidden) {
    (void)hidden;
    Method setter=class_getInstanceMethod(Lookup("UIView"),cmd);
    ((void(*)(Obj,Sel,B))method_getImplementation(setter))(self,cmd,1);
}

static Obj DramaSearchBackgroundClass(void) {
    Obj cls=Lookup("FQXDramaSearchBackground");
    if (cls) return cls;
    Obj parent=Lookup("UIView");
    if (!ClassABI(parent,"setHidden:","v20@0:8B16")) return 0;
    cls=AllocateClass(parent,"FQXDramaSearchBackground",0);
    if (!cls) return 0;
    class_addMethod(cls,sel_registerName("setHidden:"),(Imp)DramaSearchBackgroundSetHidden,"v20@0:8B16");
    RegisterClass(cls);
    return cls;
}

static void DramaSearchSetBackground(Obj self,Sel cmd,Obj background) {
    // setupNewSearchBar assigns [UIView new] before configuring, attaching or moving it.
    // Only the known search backing needs to resist later native setHidden:NO writes.
    Obj replacement=0;
    if (background && object_getClass(background)==Lookup("UIView") && !Get(background,"superview"))
        replacement=O0(DramaSearchBackgroundClass(),"new");
    if (replacement) VB(replacement,"setHidden:",1);
    ((void(*)(Obj,Sel,Obj))Original("SSVideoSeriesFeedHeaderSearchView","fqx_originalDramaSetSearchBackground:"))
        (self,cmd,replacement ? replacement : background);
    if (replacement) V0(replacement,"release");
}

enum { DramaHeaderButtonHeight=42 };
static void DramaSearchButtonKey(void) {}
static void DramaSearchHeaderReadyKey(void) {}
static void DramaSearchFeedAppearedKey(void) {}
static B DramaCategoryButtonsVisible(Obj models);

static B DramaSearchUsesGlass(Obj owner) {
    return Enabled() && FQHGlassAvailable() && InstanceABI(owner,"simpleSearchViewDidClicked","v16@0:8");
}

static B DramaSearchHeaderReady(Obj header,Obj owner) {
    if (!Get(header,"window")) return 0;
    if (objc_getAssociatedObject(header,DramaSearchHeaderReadyKey)) return 1;
    Obj categories=Get(header,"tabContainer"),pill=objc_getAssociatedObject(categories,SurfaceKey);
    B categoryReady=pill && Get(pill,"superview")==categories && Belongs(categories,header) && !Flag(categories,"isHidden");
    B searchOnly=!DramaCategoryButtonsVisible(Get(owner,"tabModels")) &&
        objc_getAssociatedObject(owner,DramaSearchFeedAppearedKey);
    if (!categoryReady && !searchOnly) return 0;
    objc_setAssociatedObject(header,DramaSearchHeaderReadyKey,header,0);
    return 1;
}

static double DramaHeaderSafeTop(Obj header) {
    Obj window=Get(header,"window");
    if (!window) return Bounds(header).y;
    Rect screen=Bounds(window);
    if (screen.height<=screen.width) return Bounds(header).y;
    Insets safe=((Insets(*)(Obj,Sel))Message)(window,sel_registerName("safeAreaInsets"));
    Rect top=Convert(window,(Rect){screen.x,screen.y+safe.top,1,1},header);
    return __builtin_fmax(Bounds(header).y,top.y);
}

static B DramaHeaderSearchButton(Obj header,Obj owner,B visible) {
    Obj button=objc_getAssociatedObject(header,DramaSearchButtonKey);
    Rect bounds=Bounds(header);
    if (!visible || bounds.width<54 || !VisibleRect(bounds)) {
        if (button) {
            V0(button,"removeFromSuperview");
            objc_setAssociatedObject(header,DramaSearchButtonKey,0,1);
        }
        return 0;
    }
    Obj categories=Get(header,"tabContainer");
    Obj pill=objc_getAssociatedObject(categories,SurfaceKey),row=pill ? pill : categories;
    Rect aligned=Belongs(row,header) ? Convert(row,Bounds(row),header) : bounds;
    double side=__builtin_fmin(DramaHeaderButtonHeight,pill ? aligned.height : bounds.height);
    double y=__builtin_fmax(bounds.y,__builtin_fmin(bounds.y+bounds.height-side,
        pill ? aligned.y+(aligned.height-side)/2 : DramaHeaderSafeTop(header)+4));
    Rect frame={bounds.x+bounds.width-12-side,y,side,side};
    if (!VisibleRect(frame)) return 0;
    if (!button) {
        Obj configuration=Get(Lookup("UIButtonConfiguration"),"glassButtonConfiguration");
        Obj symbolConfiguration=((Obj(*)(Obj,Sel,double,I,I))Message)(Lookup("UIImageSymbolConfiguration"),
            sel_registerName("configurationWithPointSize:weight:scale:"),23.,4,2);
        Obj symbol=((Obj(*)(Obj,Sel,Obj,Obj))Message)(Lookup("UIImage"),
            sel_registerName("systemImageNamed:withConfiguration:"),Text("magnifyingglass"),symbolConfiguration);
        symbol=((Obj(*)(Obj,Sel,Obj,I))Message)(symbol,sel_registerName("imageWithTintColor:renderingMode:"),
            Get(Lookup("UIColor"),"whiteColor"),1);
        if (!configuration || !symbol) return 0;
        V1(configuration,"setImage:",symbol);
        typedef struct { double top,leading,bottom,trailing; } DirectionalInsets;
        ((void(*)(Obj,Sel,DirectionalInsets))Message)(configuration,sel_registerName("setContentInsets:"),
            (DirectionalInsets){0,0,0,0});
        button=((Obj(*)(Obj,Sel,Rect))Message)(O0(Lookup("UIButton"),"alloc"),sel_registerName("initWithFrame:"),frame);
        if (!button) return 0;
        Q1(button,"setOverrideUserInterfaceStyle:",2);
        V1(button,"setConfiguration:",configuration);
        V1(button,"setCornerConfiguration:",O0(Lookup("UICornerConfiguration"),"capsuleConfiguration"));
        V1(button,"setAccessibilityLabel:",Text("搜索"));
        ((void(*)(Obj,Sel,Obj,Sel,U))Message)(button,sel_registerName("addTarget:action:forControlEvents:"),
            owner,sel_registerName("simpleSearchViewDidClicked"),64);
        objc_setAssociatedObject(header,DramaSearchButtonKey,button,1);
        V0(button,"release");
    }
    if (!SameRect(Frame(button),frame)) SetFrame(button,frame);
    if (Get(button,"superview")!=header) V1(header,"addSubview:",button);
    else if (Get(Get(header,"subviews"),"lastObject")!=button) V1(header,"bringSubviewToFront:",button);
    return 1;
}

static void DramaVisibilityApplySearch(Obj header,B visible) {
    Obj owner=Get(header,"delegate");
    B supported=DramaSearchUsesGlass(owner);
    // Keep both search surfaces off until the mounted header presents its category row.
    B waiting=supported && !DramaSearchHeaderReady(header,owner);
    B glass=DramaHeaderSearchButton(header,owner,visible && supported && !waiting);
    B stock=visible && !glass && !waiting;
    Obj search=Get(header,"searchViewContainer");
    if (!Kind(search,"SSVideoSeriesFeedHeaderSearchView")) return;
    Obj slot=Get(search,"searchButtonSlotView"),icon=Get(search,"searchButtonView");
    DramaVisibilitySet(icon,stock);
    if (slot) {
        DramaVisibilitySet(slot,stock);
        if (stock && Belongs(icon,slot)) {
            if (Flag(slot,"isHidden")) VB(slot,"setHidden:",0);
            if (((double(*)(Obj,Sel))Message)(slot,sel_registerName("alpha"))!=1)
                ((void(*)(Obj,Sel,double))Message)(slot,sel_registerName("setAlpha:"),1);
        }
    }
    // The full search field may move from its container to the feed's search row.
    DramaVisibilitySet(Get(search,"searchBgView"),0);
}

enum { DramaCategoryTagBase=1000 };

static Obj DramaCategoryDefaults(void) {
    return O0(Lookup("NSUserDefaults"),"standardUserDefaults");
}
static Obj DramaCategoryListKey(void) { return Text("FanqieX.DramaCategoryTitles.1"); }
static Obj DramaCategoryPreference(I type) {
    Obj stem=O1(Text("FanqieX.DramaCategory."),"stringByAppendingString:",Get(Number(type),"stringValue"));
    return O1(stem,"stringByAppendingString:",Text(".1"));
}
static I DramaCategoryType(Obj model) {
    if (!Kind(model,"SSBookStoreTabModel") || !InstanceABI(model,"tabType","i16@0:8")) return -1;
    return ((int(*)(Obj,Sel))Message)(model,sel_registerName("tabType"));
}
static U DramaCategoryCount(Obj list) {
    return Kind(list,"NSArray") ? ((U(*)(Obj,Sel))Message)(list,sel_registerName("count")) : 0;
}
static B DramaCategoryVisible(Obj model) {
    I type=DramaCategoryType(model);
    return type<0 || DefaultEnabled(DramaCategoryPreference(type));
}
static B DramaCategoryMaster(void) {
    return DefaultEnabled(Text("FanqieX.DramaCategories.1"));
}
static B DramaCategoryButtonsVisible(Obj models) {
    if (!DramaCategoryMaster()) return 0;
    U count=DramaCategoryCount(models);
    for (U i=0;i<count;++i) if (DramaCategoryVisible(At(models,i))) return 1;
    return count==0;
}
static B DramaCategoryButtonVisible(Obj models,I index) {
    return index<0 || (U)index>=DramaCategoryCount(models) || DramaCategoryVisible(At(models,(U)index));
}
static void DramaCategoryRemember(Obj models) {
    U count=DramaCategoryCount(models);
    if (!count || count>24) return;
    Obj rows=O0(Lookup("NSMutableArray"),"array");
    Obj seen=O0(Lookup("NSMutableSet"),"set");
    for (U i=0;i<count;++i) {
        Obj model=At(models,i),title=Get(model,"title");
        I type=DramaCategoryType(model);
        if (type<0 || !Kind(title,"NSString") || !((U(*)(Obj,Sel))Message)(title,sel_registerName("length"))) continue;
        Obj value=Number(type);
        if (((B(*)(Obj,Sel,Obj))Message)(seen,sel_registerName("containsObject:"),value)) continue;
        V1(seen,"addObject:",value);
        Obj entry=O0(Lookup("NSMutableDictionary"),"dictionary");
        Put(entry,"type",value); Put(entry,"title",title);
        V1(rows,"addObject:",entry);
    }
    Obj defaults=DramaCategoryDefaults(),key=DramaCategoryListKey(),previous=O1(defaults,"objectForKey:",key);
    U rowCount=DramaCategoryCount(rows);
    if (rowCount && (rowCount>1 || !DramaCategoryCount(previous)) &&
        !((B(*)(Obj,Sel,Obj))Message)(rows,sel_registerName("isEqual:"),previous))
        ((void(*)(Obj,Sel,Obj,Obj))Message)(defaults,sel_registerName("setObject:forKey:"),rows,key);
}

static Obj DramaCategoryModelsForTabs(Obj owner,Obj tabs) {
    Obj models=Get(owner,"tabModels");
    return DramaCategoryCount(models)==DramaCategoryCount(Get(tabs,"dataSource")) ? models : (Obj)0;
}

static B DramaCategoryCellVisible(Obj models,Obj path) {
    return !path || DramaCategoryButtonVisible(models,((I(*)(Obj,Sel))Message)(path,sel_registerName("item")));
}

static Obj DramaCategoryHeader(Obj tabs) {
    for (Obj node=Get(tabs,"superview");node;node=Get(node,"superview")) {
        if (!Kind(node,"SSVideoSeriesFeedHeaderView")) continue;
        Obj owner=Get(node,"delegate");
        if (DramaVisibilityOwnsHeader(node) && Get(owner,"simpleTabView")==tabs)
            return node;
        break;
    }
    return 0;
}

static Obj DramaCategoryCellModels(Obj tabs) {
    return DramaCategoryModelsForTabs(Get(DramaCategoryHeader(tabs),"delegate"),tabs);
}

static Obj DramaCategoryCell(Obj self,Sel cmd,Obj collection,Obj path) {
    Obj cell=((Obj(*)(Obj,Sel,Obj,Obj))Original("SSHGBookStoreCategoryTitleView",
        "fqx_originalDramaTitleCell:path:"))(self,cmd,collection,path);
    DramaVisibilitySet(cell,DramaCategoryCellVisible(DramaCategoryCellModels(self),path));
    return cell;
}

static void DramaCategoryCellSelected(Obj self,Sel cmd,Obj collection,Obj path) {
    if (!DramaCategoryCellVisible(DramaCategoryCellModels(self),path)) return;
    ((void(*)(Obj,Sel,Obj,Obj))Original("SSHGBookStoreCategoryTitleView",
        "fqx_originalDramaTitleCellSelected:path:"))(self,cmd,collection,path);
}

static Obj DramaCategoryPath(U index) {
    return ((Obj(*)(Obj,Sel,U,U))Message)(Lookup("NSIndexPath"),
        sel_registerName("indexPathForItem:inSection:"),index,0);
}

static Size DramaCategoryCellSize(Obj self,Sel cmd,Obj collection,Obj layout,Obj path) {
    Size stock=((Size(*)(Obj,Sel,Obj,Obj,Obj))Original("SSHGBookStoreCategoryTitleView",
        "fqx_originalDramaTitleSize:layout:path:"))(self,cmd,collection,layout,path);
    Obj models=Enabled() && FQHGlassAvailable() ? DramaCategoryCellModels(self) : (Obj)0;
    if (models && stock.width>0)
        stock.width=DramaCategoryCellVisible(models,path) ? stock.width : 0.5;
    return stock;
}

static double DramaCategoryCellSpacing(Obj self,Sel cmd) {
    return ((double(*)(Obj,Sel))Original("SSHGBookStoreCategoryTitleView","fqx_originalDramaInnerCellSpacing"))(self,cmd);
}

static void DramaCategoryLayoutMaskKey(void) {}

static void DramaCategoryUpdateLayout(Obj tabs,Obj collection,Obj models) {
    U count=DramaCategoryCount(models),mask=0;
    if (count && count<=24 && Enabled() && FQHGlassAvailable()) {
        mask=1U<<count;
        for (U i=0;i<count;++i) if (DramaCategoryButtonVisible(models,(I)i)) mask|=1U<<i;
    }
    Obj previous=objc_getAssociatedObject(tabs,DramaCategoryLayoutMaskKey);
    if (mask==(previous ? (U)Double(previous) : 0)) return;
    objc_setAssociatedObject(tabs,DramaCategoryLayoutMaskKey,Number((double)mask),1);
    V0(Get(collection,"collectionViewLayout"),"invalidateLayout");
    V0(collection,"layoutIfNeeded");
}

static Rect DramaCategoryLayoutFrame(Obj tabs,Obj collection,I index) {
    Obj attributes=O1(collection,"layoutAttributesForItemAtIndexPath:",DramaCategoryPath((U)index));
    if (attributes) {
        Rect frame=Frame(attributes);
        if (VisibleRect(frame)) return frame;
    }
    return ((Rect(*)(Obj,Sel,I))Message)(tabs,sel_registerName("getTargetCellFrame:"),index);
}

static void DramaHeaderStockXKey(void) {}
static void DramaHeaderCenteredXKey(void) {}
static void DramaHeaderSelectionKey(void) {}
static void DramaHeaderStockYKey(void) {}
static void DramaHeaderAppliedYKey(void) {}

static void DramaHeaderPositionCategories(Obj header,Obj categories,Rect capsule,B active) {
    Rect frame=Frame(categories);
    Obj applied=objc_getAssociatedObject(categories,DramaHeaderAppliedYKey);
    double stock=applied && __builtin_fabs(frame.y-Double(applied))<0.25
        ? Double(objc_getAssociatedObject(categories,DramaHeaderStockYKey)) : frame.y;
    double y=stock;
    Obj parent=Get(categories,"superview");
    if (active && parent && Get(header,"window")) {
        Rect placed=Convert(categories,capsule,header);
        double desired=DramaHeaderSafeTop(header)+4;
        if (desired+capsule.height<=Bounds(header).y+Bounds(header).height) {
            Rect origin=Convert(header,(Rect){placed.x,placed.y,1,1},parent);
            Rect aligned=Convert(header,(Rect){placed.x,desired,1,1},parent);
            y=frame.y+aligned.y-origin.y;
        }
    }
    if (__builtin_fabs(frame.y-y)>=0.25) {
        frame.y=y;
        SetFrame(categories,frame);
    }
    B moved=active && __builtin_fabs(y-stock)>=0.25;
    objc_setAssociatedObject(categories,DramaHeaderStockYKey,moved ? Number(stock) : (Obj)0,1);
    objc_setAssociatedObject(categories,DramaHeaderAppliedYKey,moved ? Number(y) : (Obj)0,1);
}

static void DramaHeaderCenterCategories(Obj header,Obj categories,Rect capsule,B center) {
    Rect frame=Frame(categories);
    Obj centered=objc_getAssociatedObject(categories,DramaHeaderCenteredXKey);
    B applied=centered && frame.x==Double(centered);
    if (center) {
        Rect headerBounds=Convert(header,Bounds(header),Get(categories,"superview")),bounds=Bounds(categories);
        double x=headerBounds.x+(headerBounds.width-capsule.width)/2-(capsule.x-bounds.x);
        if (!applied) objc_setAssociatedObject(categories,DramaHeaderStockXKey,Number(frame.x),1);
        objc_setAssociatedObject(categories,DramaHeaderCenteredXKey,Number(x),1);
        if (frame.x==x) return;
        frame.x=x;
    } else {
        if (!centered) return;
        Obj stock=objc_getAssociatedObject(categories,DramaHeaderStockXKey);
        if (applied) frame.x=Double(stock);
        objc_setAssociatedObject(categories,DramaHeaderStockXKey,0,1);
        objc_setAssociatedObject(categories,DramaHeaderCenteredXKey,0,1);
        if (!applied) return;
    }
    SetFrame(categories,frame);
}

static void DramaHeaderSelection(Obj glass,Rect frame) {
    Obj lens=objc_getAssociatedObject(glass,DramaHeaderSelectionKey);
    if (!VisibleRect(frame)) {
        if (lens) VB(lens,"setHidden:",1);
        return;
    }
    if (!lens) {
        lens=O0(Lookup("UIView"),"new");
        VB(lens,"setUserInteractionEnabled:",0);
        VB(lens,"setAccessibilityElementsHidden:",1);
        VB(lens,"setClipsToBounds:",1);
        V1(Get(glass,"contentView"),"addSubview:",lens);
        objc_setAssociatedObject(glass,DramaHeaderSelectionKey,lens,1);
        V0(lens,"release");
    }
    if (!SameRect(Frame(lens),frame)) {
        SetFrame(lens,frame);
        SetRadius(lens,__builtin_fmin(frame.width,frame.height)/2);
    }
    Obj fill=O0(Lookup("UIColor"),"secondarySystemFillColor");
    if (!SameColor(Get(lens,"backgroundColor"),fill)) V1(lens,"setBackgroundColor:",fill);
    if (Flag(lens,"isHidden")) VB(lens,"setHidden:",0);
}

static I DramaHeaderSelectedCategory(Obj tabs) {
    Obj cells=Get(tabs,"dataSource");
    U count=DramaCategoryCount(cells);
    I selected=-1;
    for (U i=0;i<count && i<24;++i) {
        Obj model=At(cells,i);
        if (!InstanceABI(model,"isSelected","B16@0:8")) return -1;
        if (!Flag(model,"isSelected")) continue;
        if (selected>=0) return -1;
        selected=(I)i;
    }
    return selected;
}

static void DramaHeaderCategoryAppearance(Obj header,Obj glass) {
    Obj feed=Get(header,"delegate"),content=Get(feed,"contentView");
    Obj color=Get(content,"backgroundColor");
    // Video models can leave contentView at SS_COLOR_BG_F6 while the bottom
    // resolver deliberately selects #222222 for the video page. Use that same
    // resolver, with the rendered title's model rather than a lagging cache.
    Obj owner=Get(feed,"rootTabBarController"),models=Get(feed,"tabModels");
    I selected=DramaHeaderSelectedCategory(Get(feed,"simpleTabView"));
    if (selected>=0 && (U)selected<DramaCategoryCount(models) && Kind(owner,"SSTabBarController") &&
        InstanceABI(owner,"bottomTabBackgroundColorWithTabModel:","@24@0:8@16"))
        color=O1(owner,"bottomTabBackgroundColorWithTabModel:",At(models,(U)selected));
    if (Responds(color,"resolvedColorWithTraitCollection:"))
        color=O1(color,"resolvedColorWithTraitCollection:",Get(content,"traitCollection"));
    I style=0;
    double red=0,green=0,blue=0,alpha=0,white=0;
    if (Kind(color,"UIColor")) {
        if (((B(*)(Obj,Sel,double *,double *,double *,double *))Message)(color,
            sel_registerName("getRed:green:blue:alpha:"),&red,&green,&blue,&alpha))
            white=(red+green*2+blue)*0.25;
        else ((B(*)(Obj,Sel,double *,double *))Message)(color,
            sel_registerName("getWhite:alpha:"),&white,&alpha);
        if (alpha>=0.5) style=white<0.5 ? 2 : 1;
    }
    if (((I(*)(Obj,Sel))Message)(glass,sel_registerName("overrideUserInterfaceStyle"))!=style)
        Q1(glass,"setOverrideUserInterfaceStyle:",style);
}

static void DramaHeaderCategoryGlass(Obj header,Obj categories,Obj tabs,Obj models,B show) {
    Obj collection=Get(tabs,"collectionView");
    U count=DramaCategoryCount(Get(tabs,"dataSource"));
    Rect capsule={0},selection={0};
    if (show && Enabled() && FQHGlassAvailable() && count && count<=24 &&
        Belongs(collection,categories) &&
        InstanceABI(tabs,"getTargetCellFrame:","{CGRect={CGPoint=dd}{CGSize=dd}}24@0:8q16")) {
        I firstIndex=0,lastIndex=(I)count-1;
        while (!DramaCategoryButtonVisible(models,firstIndex)) ++firstIndex;
        while (!DramaCategoryButtonVisible(models,lastIndex)) --lastIndex;
        Rect bounds=Bounds(categories),first=Convert(collection,DramaCategoryLayoutFrame(tabs,collection,firstIndex),categories);
        Rect last=Convert(collection,DramaCategoryLayoutFrame(tabs,collection,lastIndex),categories);
        if (VisibleRect(first) && VisibleRect(last) && VisibleRect(bounds)) {
            // Keep the host's title widths and hit regions. The capsule covers
            // the realized cells, including the final title during relayout.
            double left=first.x-10;
            double right=last.x+last.width+10;
            double height=__builtin_fmin(DramaHeaderButtonHeight,bounds.height);
            capsule=(Rect){left,first.y+(first.height-height)/2,right-left,height};
            // Read the same cell-model state used by the host's selected title.
            I index=DramaHeaderSelectedCategory(tabs);
            if (index>=0 && (U)index<count && DramaCategoryButtonVisible(models,index)) {
                Rect selected=Convert(collection,DramaCategoryLayoutFrame(tabs,collection,index),categories);
                double center=selected.x+selected.width/2,start=left+4,end=right-4;
                for (I previous=index-1;previous>=firstIndex;--previous) {
                    if (!DramaCategoryButtonVisible(models,previous)) continue;
                    Rect neighbor=Convert(collection,DramaCategoryLayoutFrame(tabs,collection,previous),categories);
                    start=__builtin_fmax(start,(neighbor.x+neighbor.width/2+center)/2);
                    break;
                }
                for (I next=index+1;next<=lastIndex;++next) {
                    if (!DramaCategoryButtonVisible(models,next)) continue;
                    Rect neighbor=Convert(collection,DramaCategoryLayoutFrame(tabs,collection,next),categories);
                    end=__builtin_fmin(end,(neighbor.x+neighbor.width/2+center)/2);
                    break;
                }
                selection=(Rect){start-left,4,end-start,height-8};
            }
        }
    }
    // Match the bottom dock's Regular UIGlassEffect and transparent content,
    // rather than using a glass button as a multi-title material container.
    ApplySurface(categories,capsule,1);
    Obj glass=objc_getAssociatedObject(categories,SurfaceKey);
    DramaHeaderCenterCategories(header,categories,capsule,glass!=0);
    DramaHeaderPositionCategories(header,categories,capsule,glass!=0);
    if (glass) {
        DramaHeaderCategoryAppearance(header,glass);
        DramaHeaderSelection(glass,selection);
    }
}

static void DramaVisibilityApplyHeader(Obj header) {
    if (!Kind(header,"SSVideoSeriesFeedHeaderView") || !DramaVisibilityOwnsHeader(header)) return;
    DramaVisibilityTrack(header);
    B searchVisible=DefaultEnabled(Text("FanqieX.DramaSearch.1"));
    Obj categories=Get(header,"tabContainer");
    if (Belongs(categories,header)) {
        Obj owner=Get(header,"delegate"),tabs=Get(owner,"simpleTabView"),collection=Get(tabs,"collectionView");
        Obj models=DramaCategoryModelsForTabs(owner,tabs);
        B show=DramaCategoryButtonsVisible(Get(owner,"tabModels"));
        DramaVisibilitySet(categories,show);
        if (Belongs(collection,categories)) {
            DramaCategoryUpdateLayout(tabs,collection,models);
            U count=DramaCategoryCount(Get(tabs,"dataSource"));
            for (U i=0;i<count;++i) {
                Obj path=((Obj(*)(Obj,Sel,I,I))Message)(Lookup("NSIndexPath"),
                    sel_registerName("indexPathForItem:inSection:"),(I)i,0);
                // Resolve by index to include already hidden, realized cells.
                DramaVisibilitySet(O1(collection,"cellForItemAtIndexPath:",path),DramaCategoryButtonVisible(models,(I)i));
            }
        }
        DramaHeaderCategoryGlass(header,categories,tabs,models,show);
    }
    DramaVisibilityApplySearch(header,searchVisible);
}

static void DramaCategorySetup(Obj self,Sel cmd,Obj models,I index,B report,I reason) {
    DramaCategoryRemember(models);
    // Native models and indices own playback and paging as well as the titles.
    ((void(*)(Obj,Sel,Obj,I,B,I))Original("SSVideoSeriesFeedViewController",
        "fqx_originalDramaCategorySetup:index:report:reason:"))(self,cmd,models,index,report,reason);
    DramaVisibilityApplyHeader(Get(self,"headerView"));
}
static void DramaCategoryRefreshModels(Obj self,Sel cmd,Obj models,I index,I reason) {
    DramaCategoryRemember(models);
    ((void(*)(Obj,Sel,Obj,I,I))Original("SSVideoSeriesFeedViewController",
        "fqx_originalDramaCategoryRefresh:index:reason:"))(self,cmd,models,index,reason);
    DramaVisibilityApplyHeader(Get(self,"headerView"));
}
static void DramaCategoryRefreshSelected(Obj self,Sel cmd,Obj models,I index) {
    DramaCategoryRemember(models);
    ((void(*)(Obj,Sel,Obj,I))Original("SSVideoSeriesFeedViewController",
        "fqx_originalDramaCategoryRefreshSelected:index:"))(self,cmd,models,index);
    DramaVisibilityApplyHeader(Get(self,"headerView"));
}

static void DramaVisibilityKeepSearchHidden(Obj header) {
    if (DramaVisibilityOwnsHeader(header))
        DramaVisibilityApplySearch(header,DefaultEnabled(Text("FanqieX.DramaSearch.1")));
}

static double DramaVisibilitySearchBarLayout(Obj self,Sel cmd) {
    double alpha=((double(*)(Obj,Sel))Original("SSVideoSeriesFeedHeaderView","fqx_originalDramaSearchBarLayout"))(self,cmd);
    DramaVisibilityKeepSearchHidden(self);
    return alpha;
}

static void DramaVisibilitySearchBarAlpha(Obj self,Sel cmd,double alpha) {
    ((void(*)(Obj,Sel,double))Original("SSVideoSeriesFeedHeaderView","fqx_originalDramaSearchBarAlpha:"))(self,cmd,alpha);
    DramaVisibilityKeepSearchHidden(self);
}

static void DramaVisibilitySearchIcon(Obj self,Sel cmd,B visible,double top) {
    ((void(*)(Obj,Sel,B,double))Original("SSVideoSeriesFeedHeaderView","fqx_originalDramaSearchIcon:top:"))(
        self,cmd,visible,top);
    DramaVisibilityKeepSearchHidden(self);
}

static void DramaVisibilityHeaderSetup178R15(Obj self,Sel cmd) {
    ((void(*)(Obj,Sel))Original("SSVideoSeriesFeedHeaderView","fqx178r15_originalHeaderSetup"))(self,cmd);
    // The feed sets the delegate before setup and mounts the header afterward.
    DramaVisibilityApplyHeader(self);
}

static void DramaVisibilityColdStartSearch178R15(Obj self,Sel cmd) {
    Obj owner=Get(self,"host");
    // The optional stock fly-in reparents the magnifier outside this header.
    if (Kind(owner,"SSVideoSeriesFeedViewController") &&
        (!DefaultEnabled(Text("FanqieX.DramaSearch.1")) || DramaSearchUsesGlass(owner))) return;
    ((void(*)(Obj,Sel))Original("SSVideoSeriesFeedSearchIconCoordinator","fqx178r15_originalPrepareColdStartSearch"))(self,cmd);
}

static void DramaVisibilityColdStartSearchFinished(Obj self,Sel cmd) {
    ((void(*)(Obj,Sel))Original("SSVideoSeriesFeedSearchIconCoordinator","fqx_originalDramaFinishColdStartSearch"))(self,cmd);
    DramaVisibilityKeepSearchHidden(Get(Get(self,"host"),"headerView"));
}

static void DramaVisibilityHeaderAttached(Obj self,Sel cmd) {
    ((void(*)(Obj,Sel))Original("SSVideoSeriesFeedHeaderView","fqx178r7_originalHeaderAttached"))(self,cmd);
    DramaVisibilityApplyHeader(self);
}

static void DramaVisibilityHeaderBounds(Obj self,Sel cmd) {
    ((void(*)(Obj,Sel))Original("SSVideoSeriesFeedHeaderView","fqx_originalDramaSearchHeaderBounds"))(self,cmd);
    DramaVisibilityApplyHeader(self);
}

static void DramaVisibilitySearchTransitionFinished(Obj self,Sel cmd,B visible) {
    ((void(*)(Obj,Sel,B))Original("SSVideoSeriesFeedHeaderView","fqx_originalDramaSearchTransitionFinished:"))(
        self,cmd,visible);
    DramaVisibilityKeepSearchHidden(self);
}

static void DramaVisibilityHeaderTabs(Obj self,Sel cmd,Size size) {
    ((void(*)(Obj,Sel,Size))Original("SSVideoSeriesFeedHeaderView","fqx178r7_originalHeaderTabs:"))(self,cmd,size);
    DramaVisibilityApplyHeader(self);
}

static void DramaHeaderTabGeometry(Obj self,Sel cmd,double desired,double base,B reserve) {
    ((void(*)(Obj,Sel,double,double,B))Original("SSVideoSeriesFeedHeaderView",
        "fqx_originalDramaHeaderTabGeometry:base:reserve:"))(self,cmd,desired,base,reserve);
    DramaVisibilityApplyHeader(self);
}

static void DramaHeaderSelectionChanged(Obj self,Sel cmd,Obj model) {
    ((void(*)(Obj,Sel,Obj))Original("SSVideoSeriesFeedViewController",
        "fqx_originalDramaHeaderSelected:"))(self,cmd,model);
    DramaVisibilityApplyHeader(Get(self,"headerView"));
}

static void DramaHeaderTitleSelectionChanged(Obj self,Sel cmd,Obj selected,Obj unselected) {
    ((void(*)(Obj,Sel,Obj,Obj))Original("SSHGBookStoreCategoryTitleView",
        "fqx_originalDramaTitleSelection:unselected:"))(self,cmd,selected,unselected);
    DramaVisibilityApplyHeader(DramaCategoryHeader(self));
}

static void DramaHeaderContentBackgroundChanged(Obj self,Sel cmd,Obj model) {
    ((void(*)(Obj,Sel,Obj))Original("SSVideoSeriesFeedViewController",
        "fqx_originalDramaContentBackground:"))(self,cmd,model);
    DramaVisibilityApplyHeader(Get(self,"headerView"));
}

static void DramaVisibilityHeaderLayout(Obj self,Sel cmd) {
    ((void(*)(Obj,Sel))Original("SSVideoSeriesFeedViewController","fqx178r7_originalDramaHeaderLayout"))(self,cmd);
    DramaVisibilityApplyHeader(Get(self,"headerView"));
}

static void DramaVisibilityFeedAppeared(Obj self,Sel cmd,B animated) {
    ((void(*)(Obj,Sel,B))Original("SSVideoSeriesFeedViewController","fqx_originalDramaSearchFeedAppeared:"))(self,cmd,animated);
    objc_setAssociatedObject(self,DramaSearchFeedAppearedKey,self,0);
    DramaVisibilityKeepSearchHidden(Get(self,"headerView"));
}

static B DramaIsMainFeedConfig(Obj config) {
    return Kind(config,"FQVShortVideoListConfig") && InstanceABI(config,"feedType","q16@0:8") &&
        ((I(*)(Obj,Sel))Message)(config,sel_registerName("feedType"))==4;
}
static B DramaVisibilityIsMainFeed(Obj manager) {
    return DramaIsMainFeedConfig(Get(Get(manager,"vcContext"),"config"));
}

static B DramaPlaybackPreference178R11(const char *key) {
    return Flag(O1(O0(Lookup("NSUserDefaults"),"standardUserDefaults"),"objectForKey:",Text(key)),"boolValue");
}
static Obj BottomWeak178(Obj object);
static B BottomFlag178(I tag);
static Obj DramaPureCleanDock178R13(Obj view);
static B BottomDramaOwnsView178R13(Obj page,Obj view);
static void DramaPureCleanViews178R13Key(void) {}
static void DramaPureCleanOwner178R13Key(void) {}
static void DramaPureCleanEnded178R13Key(void) {}
static void DramaPureCleanRoots178R13Key(void) {}
static void DramaCleanPaused178R11Key(void) {}

static Obj DramaPureCleanRoots178R13(B create) {
    Obj defaults=O0(Lookup("NSUserDefaults"),"standardUserDefaults");
    Obj roots=objc_getAssociatedObject(defaults,DramaPureCleanRoots178R13Key);
    if (!roots && create) {
        roots=BottomWeak178(0);
        objc_setAssociatedObject(defaults,DramaPureCleanRoots178R13Key,roots,1);
    }
    return roots;
}

static void DramaPureCleanTrackView178R13(Obj views,Obj root,Obj target) {
    if (!Kind(target,"UIView") || target==root || Get(target,"window")!=Get(root,"window")) return;
    Obj prior=objc_getAssociatedObject(target,DramaPureCleanOwner178R13Key);
    B hidden=Flag(target,"isHidden");
    if (hidden && !prior) return;
    if (Get(prior,"anyObject")!=root)
        objc_setAssociatedObject(target,DramaPureCleanOwner178R13Key,BottomWeak178(root),1);
    V1(views,"addObject:",target);
    if (!hidden) VB(target,"setHidden:",1);
}
static void DramaPureCleanTrackChild178R13(Obj views,Obj root,const char *getter) {
    Obj target=Get(root,getter);
    if (Belongs(target,root)) DramaPureCleanTrackView178R13(views,root,target);
}
static void DramaPureCleanUpdate178R13(Obj root,B displayed) {
    Obj old=objc_getAssociatedObject(root,DramaPureCleanViews178R13Key),next=0;
    if (!old && (!displayed || !Flag(root,"isCleanMode"))) return;
    Obj window=Get(root,"window"),context=Get(root,"listVCContext"),model=Get(root,"videoDataModel"),player=Get(root,"vPlayer");
    Rect bounds=window ? Bounds(window) : (Rect){0};
    B active=displayed && !objc_getAssociatedObject(root,DramaPureCleanEnded178R13Key) &&
        window && bounds.height>bounds.width && Flag(root,"isCleanMode") &&
        model && model==Get(context,"currentPlayModel") && player && !Flag(player,"isFullScreen") &&
        DramaIsMainFeedConfig(Get(context,"config"));
    if (active) V1(DramaPureCleanRoots178R13(1),"addObject:",root);
    B paused=active && DramaPlaybackPreference178R11("FanqieX.DramaRevealOnPause.1") &&
        (objc_getAssociatedObject(root,DramaCleanPaused178R11Key)==model ||
         (InstanceABI(player,"playbackState","q16@0:8") &&
          ((I(*)(Obj,Sel))Message)(player,sel_registerName("playbackState"))==2));
    if (active && !paused && DramaPlaybackPreference178R11("FanqieX.DramaDefaultClean.1") &&
        DramaPlaybackPreference178R11("FanqieX.DramaPureClean.1")) {
        next=BottomWeak178(0);
        // These getters own native paint and controls. The enclosing player
        // view still receives its original clean, play and paging gestures.
        DramaPureCleanTrackChild178R13(next,root,"baseInfoView");
        DramaPureCleanTrackChild178R13(next,root,"topGradientView");
        DramaPureCleanTrackChild178R13(next,root,"bottomGradientView");
        DramaPureCleanTrackChild178R13(next,root,"playBtn");
        DramaPureCleanTrackChild178R13(next,root,"muteBtnView");
        DramaPureCleanTrackChild178R13(next,root,"fullscreenBtn");
        DramaPureCleanTrackChild178R13(next,root,"progressContainer");
        DramaPureCleanTrackChild178R13(next,root,"progressFloatView");
        DramaPureCleanTrackChild178R13(next,root,"bottomView");
        DramaPureCleanTrackChild178R13(next,root,"insertAboveProgressView");
        DramaPureCleanTrackChild178R13(next,root,"insertBelowVideoInfoContainerView");
        DramaPureCleanTrackChild178R13(next,root,"insertAboveTopControlView");
        DramaPureCleanTrackChild178R13(next,root,"fastPlayTipView");
        DramaPureCleanTrackChild178R13(next,root,"bottomFastPlayTipView");
        DramaPureCleanTrackChild178R13(next,root,"resolutionTipsView");
        DramaPureCleanTrackChild178R13(next,root,"playRateTipsView");
        DramaPureCleanTrackChild178R13(next,root,"cleanScreenModeRightInteractionView");
        DramaPureCleanTrackChild178R13(next,root,"singleSeriesBottomView");
        DramaPureCleanTrackView178R13(next,root,Get(Get(context,"navBarComponent"),"navBar"));
        Obj dock=0;
        for (Obj node=Get(root,"nextResponder");node;node=Get(node,"nextResponder")) {
            if (!Kind(node,"SSVideoSeriesFeedViewController")) continue;
            DramaPureCleanTrackView178R13(next,root,Get(node,"headerView"));
            Obj tab=Get(node,"rootTabBarController"),bar=Get(tab,"customTabBar");
            if (Kind(tab,"SSTabBarController") && Kind(bar,"SSTabBar") &&
                BottomDramaOwnsView178R13(Get(tab,"selectedViewController"),root)) dock=bar;
            break;
        }
        DramaPureCleanTrackView178R13(next,root,dock ? dock : DramaPureCleanDock178R13(root));
    }
    Obj obsolete=Get(old,"allObjects");
    for (U i=0,n=TabCount(obsolete);i<n;i++) {
        Obj view=At(obsolete,i),owner=Get(objc_getAssociatedObject(view,DramaPureCleanOwner178R13Key),"anyObject");
        if (owner!=root || (next && ((B(*)(Obj,Sel,Obj))Message)(next,sel_registerName("containsObject:"),view))) continue;
        objc_setAssociatedObject(view,DramaPureCleanOwner178R13Key,0,1);
        if (Flag(view,"isHidden")) VB(view,"setHidden:",0);
    }
    objc_setAssociatedObject(root,DramaPureCleanViews178R13Key,next,1);
}
static void DramaPureCleanRefresh178R13(void) {
    Obj roots=Get(DramaPureCleanRoots178R13(0),"allObjects");
    for (U i=0,n=TabCount(roots);i<n;i++) DramaPureCleanUpdate178R13(At(roots,i),1);
}
static B DramaPureCleanChanged178R13(Obj self,Sel cmd,B clean,U type) {
    B result=((B(*)(Obj,Sel,B,U))Original("FQVShortVideoVPlayerControlView",
        "fqx178r13_originalEnterCleanMode:changeType:"))(self,cmd,clean,type);
    DramaPureCleanUpdate178R13(self,1);
    return result;
}
static void DramaPureCleanEnded178R13(Obj self,Sel cmd) {
    ((void(*)(Obj,Sel))Original("FQVShortVideoVPlayerControlView","fqx178r13_originalCleanDidEndDisplay"))(self,cmd);
    objc_setAssociatedObject(self,DramaPureCleanEnded178R13Key,BoolBox(1),1);
    DramaPureCleanUpdate178R13(self,0);
}
static void DramaCleanModel178R11Key(void) {}
static void DramaCleanPlayback178R11(Obj view,I state) {
    // FQV calls this for preloaded cells too. Only the active portrait
    // player on the short-drama tab may change the shared feed chrome.
    if ((state!=1 && state!=2) || !Get(view,"window")) return;
    Obj context=Get(view,"listVCContext"),config=Get(context,"config");
    Obj model=Get(view,"videoDataModel"),player=Get(view,"vPlayer");
    if (!model || !player || model!=Get(context,"currentPlayModel") || Flag(player,"isFullScreen") ||
        !DramaIsMainFeedConfig(config)) return;
    Obj control=Get(context,"controlContext"),status=Get(context,"stateContext");
    B controlled=Kind(control,"FQVShortVideoListVCControlComponent") && Responds(status,"isCleanMode");
    Obj prior=objc_getAssociatedObject(view,DramaCleanModel178R11Key);
    B clean=Flag(status,"isCleanMode") || Flag(view,"isCleanMode");
    B restoring=objc_getAssociatedObject(view,DramaCleanPaused178R11Key)==model;
    if (state==2) {
        if (DramaPlaybackPreference178R11("FanqieX.DramaRevealOnPause.1")) {
            if (clean && !restoring) {
                objc_setAssociatedObject(view,DramaCleanPaused178R11Key,model,1);
                if (controlled && InstanceABI(control,"exitCleanMode","v16@0:8")) V0(control,"exitCleanMode");
            }
            DramaPureCleanUpdate178R13(view,0);
        }
        return;
    }
    objc_setAssociatedObject(view,DramaCleanPaused178R11Key,0,1);
    B enabled=DramaPlaybackPreference178R11("FanqieX.DramaDefaultClean.1");
    if (controlled && prior!=model)
        objc_setAssociatedObject(view,DramaCleanModel178R11Key,enabled ? model : (Obj)0,1);
    if (controlled && !clean && ((enabled && prior!=model) ||
        (restoring && (prior!=model || enabled) && DramaPlaybackPreference178R11("FanqieX.DramaRevealOnPause.1"))) &&
        InstanceABI(control,"enterCleanMode","v16@0:8"))
        V0(control,"enterCleanMode");
    DramaPureCleanUpdate178R13(view,1);
}
static void DramaCleanState178R11(Obj self,Sel cmd,I state) {
    ((void(*)(Obj,Sel,I))Original("FQVShortVideoVPlayerControlView","fqx178r11_originalPlaybackState:"))(self,cmd,state);
    DramaCleanPlayback178R11(self,state);
}
static void DramaCleanDidPlay178R11(Obj self,Sel cmd) {
    ((void(*)(Obj,Sel))Original("FQVShortVideoVPlayerControlView","fqx178r11_originalControlDidPlay"))(self,cmd);
    Obj player=Get(self,"vPlayer");
    if (InstanceABI(player,"playbackState","q16@0:8") &&
        ((I(*)(Obj,Sel))Message)(player,sel_registerName("playbackState"))==1)
        DramaCleanPlayback178R11(self,1);
}
static Obj DramaCleanExitIcon(Obj self,Sel cmd) {
    Obj icon=((Obj(*)(Obj,Sel))Original("FQVShortVideoVPlayerControlView","fqx_originalCleanExitIcon"))(self,cmd);
    DramaVisibilitySet(icon,!DramaIsMainFeedConfig(Get(self,"listVCConfig")));
    return icon;
}
static Obj DramaCleanRightControls(Obj self,Sel cmd) {
    Obj controls=((Obj(*)(Obj,Sel))Original("FQVShortVideoVPlayerControlView","fqx_originalCleanRightControls"))(self,cmd);
    // On the standard feed this container draws the exit button's circle. In
    // the layout with a playback-rate control, keep the container for that label.
    DramaVisibilitySet(controls,!DramaIsMainFeedConfig(Get(self,"listVCConfig")) ||
        Flag(self,"enableShowPlayRateInCleanMode"));
    return controls;
}
static void DramaCleanInstall178R11(void) {
    const char *cls="FQVShortVideoVPlayerControlView";
    Hook(cls,"playerPlaybackStateDidChanged:","fqx178r11_originalPlaybackState:","v24@0:8q16",(Imp)DramaCleanState178R11);
    Hook(cls,"controlViewDidPlay","fqx178r11_originalControlDidPlay","v16@0:8",(Imp)DramaCleanDidPlay178R11);
    if (Signature(cls,"isCleanMode","B16@0:8")) {
        Hook(cls,"enterCleanMode:changeType:","fqx178r13_originalEnterCleanMode:changeType:","B28@0:8B16Q20",(Imp)DramaPureCleanChanged178R13);
        Hook(cls,"controlViewDidEndDisplay","fqx178r13_originalCleanDidEndDisplay","v16@0:8",(Imp)DramaPureCleanEnded178R13);
    }
    if (Signature(cls,"listVCConfig","@16@0:8") && Signature(cls,"enableShowPlayRateInCleanMode","B16@0:8")) {
        Hook(cls,"cancelCleanScreenView","fqx_originalCleanExitIcon","@16@0:8",(Imp)DramaCleanExitIcon);
        Hook(cls,"cleanScreenModeRightInteractionView","fqx_originalCleanRightControls","@16@0:8",(Imp)DramaCleanRightControls);
    }
}

static B DramaVisibilityAuthor(Obj self,Sel cmd) {
    B visible=((B(*)(Obj,Sel))Original("SSShortVideoBelowLeftContainerViewManager",
        "fqx178r7_originalShouldAddAiUsageView"))(self,cmd);
    if (!DramaVisibilityIsMainFeed(self)) return visible;
    DramaVisibilityTrack(self);
    return visible && DefaultEnabled(Text("FanqieX.DramaAuthorDeclaration.1"));
}

static void DramaOriginalNovelGlass(Obj view) {
    Obj model=Get(view,"dataModel");
    // Fanqie’s isRelateNovelReason compares the model’s recType to 25.
    B original=Kind(model,"SSShortVideoRcmdReasonModel") && InstanceABI(model,"recType","i16@0:8") &&
        ((int(*)(Obj,Sel))Message)(model,sel_registerName("recType"))==25;
    B hasGlass=DramaSmallGlass(view,original);
    DramaVisibilitySet(Get(view,"gradientBackgroundView"),!hasGlass);
}

static void DramaOriginalNovelLayout(Obj self,Sel cmd) {
    ((void(*)(Obj,Sel))Original("SSShortVideoRcmdReasonView","fqx_originalNovelLayout"))(self,cmd);
    DramaOriginalNovelGlass(self);
}

static void DramaOriginalNovelModel(Obj self,Sel cmd) {
    // Adaptive UI changes can repaint the native backing without replacing the model.
    DramaClearBackground(self,0);
    DramaVisibilitySet(Get(self,"gradientBackgroundView"),1);
    ((void(*)(Obj,Sel))Original("SSShortVideoRcmdReasonView","fqx_originalNovelModelUpdate"))(self,cmd);
    DramaOriginalNovelGlass(self);
}

static Obj DramaVisibilityNovel(Obj self,Sel cmd) {
    Obj views=((Obj(*)(Obj,Sel))Original("SSShortVideoAboveLeftContainerViewManager",
        "fqx178r8_originalOrderedAboveLeftViews"))(self,cmd);
    if (!DramaVisibilityIsMainFeed(self)) return views;
    Obj reason=Get(self,"rcmdReasonViewManager");
    if (!Kind(reason,"SSShortVideoRcmdReasonViewManager")) return views;
    B originalNovel=BoolProp(reason,"isRelateNovelReason");
    Obj reasonModel=Get(reason,"rcmdReasonModel");
    B interest=Equal(Get(reasonModel,"content"),"根据小说兴趣推荐") ||
        Equal(Get(reasonModel,"recommendReason"),"根据小说兴趣推荐") ||
        Equal(Get(reasonModel,"reasonText"),"根据小说兴趣推荐");
    if (!originalNovel && !interest) return views;
    Obj novel=Get(reason,"decorationView");
    if (!Kind(novel,"SSShortVideoRcmdReasonView")) return views;
    DramaVisibilityTrack(self);
    B visible=(!originalNovel || DefaultEnabled(Text("FanqieX.DramaOriginalNovel.1"))) &&
        (!interest || DefaultEnabled(Text("FanqieX.DramaRecommendationReason.1")));
    if (visible) return views;
    U index=((U(*)(Obj,Sel,Obj))Message)(views,sel_registerName("indexOfObjectIdenticalTo:"),novel);
    if (index>=((U(*)(Obj,Sel))Message)(views,sel_registerName("count"))) return views;
    Obj filtered=O0(O0(views,"mutableCopy"),"autorelease");
    Q1(filtered,"removeObjectAtIndex:",index);
    return filtered;
}

static void DramaVisibilityRefresh(void) {
    Obj owners=Get(DramaVisibilityOwners(),"allObjects");
    U count=((U(*)(Obj,Sel))Message)(owners,sel_registerName("count"));
    for (U i=0;i<count;++i) {
        Obj owner=At(owners,i);
        if (Kind(owner,"SSVideoSeriesFeedHeaderView")) DramaVisibilityApplyHeader(owner);
        else if (DramaVisibilityIsMainFeed(owner)) {
            if (Kind(owner,"SSShortVideoAboveLeftContainerViewManager")) V0(owner,"updateLayoutForContainerView");
            else V0(owner,"updateSubViews");
        }
    }
}

static void DramaVisibilityInstall(void) {
    const char *header="SSVideoSeriesFeedHeaderView";
    const char *feed="SSVideoSeriesFeedViewController";
    if (Signature(feed,"setupDataWithTabModels:serverSelectedIndex:reportFirstScreenDataFinish:reason:","v44@0:8@16q24B32q36") &&
        Signature(feed,"refreshSingleTabViewWithTabModels:serverSelectedIndex:reason:","v40@0:8@16q24q32") &&
        Signature(feed,"refreshSelectedTabModelWithTabModels:serverSelectedIndex:","v32@0:8@16q24")) {
        Hook(feed,"setupDataWithTabModels:serverSelectedIndex:reportFirstScreenDataFinish:reason:",
             "fqx_originalDramaCategorySetup:index:report:reason:","v44@0:8@16q24B32q36",(Imp)DramaCategorySetup);
        Hook(feed,"refreshSingleTabViewWithTabModels:serverSelectedIndex:reason:",
             "fqx_originalDramaCategoryRefresh:index:reason:","v40@0:8@16q24q32",(Imp)DramaCategoryRefreshModels);
        Hook(feed,"refreshSelectedTabModelWithTabModels:serverSelectedIndex:",
             "fqx_originalDramaCategoryRefreshSelected:index:","v32@0:8@16q24",(Imp)DramaCategoryRefreshSelected);
    }
    const char *tabs="SSHGBookStoreCategoryTitleView";
    Hook(tabs,"collectionView:cellForItemAtIndexPath:","fqx_originalDramaTitleCell:path:",
         "@32@0:8@16@24",(Imp)DramaCategoryCell);
    Hook(tabs,"collectionView:didSelectItemAtIndexPath:","fqx_originalDramaTitleCellSelected:path:",
         "v32@0:8@16@24",(Imp)DramaCategoryCellSelected);
    Hook(tabs,"collectionView:layout:sizeForItemAtIndexPath:","fqx_originalDramaTitleSize:layout:path:",
         "{CGSize=dd}40@0:8@16@24@32",(Imp)DramaCategoryCellSize);
    Hook(tabs,"innerCellSpacing","fqx_originalDramaInnerCellSpacing","d16@0:8",(Imp)DramaCategoryCellSpacing);
    Hook(tabs,"refreshSelectedCellModel:unselectedCellModel:","fqx_originalDramaTitleSelection:unselected:",
         "v32@0:8@16@24",(Imp)DramaHeaderTitleSelectionChanged);
    if (Signature("SSVideoSeriesFeedHeaderSearchView","setupNewSearchBar","v16@0:8") &&
        Signature("SSVideoSeriesFeedHeaderSearchView","searchBgView","@16@0:8"))
        Hook("SSVideoSeriesFeedHeaderSearchView","setSearchBgView:","fqx_originalDramaSetSearchBackground:",
             "v24@0:8@16",(Imp)DramaSearchSetBackground);
    Hook(header,"setupSubViews","fqx178r15_originalHeaderSetup","v16@0:8",(Imp)DramaVisibilityHeaderSetup178R15);
    Hook("SSVideoSeriesFeedSearchIconCoordinator","prepareColdStartSearchButtonIfNeeded","fqx178r15_originalPrepareColdStartSearch",
         "v16@0:8",(Imp)DramaVisibilityColdStartSearch178R15);
    Hook("SSVideoSeriesFeedSearchIconCoordinator","finishColdStartSearchPresentation","fqx_originalDramaFinishColdStartSearch",
         "v16@0:8",(Imp)DramaVisibilityColdStartSearchFinished);
    Hook(header,"didMoveToWindow","fqx178r7_originalHeaderAttached","v16@0:8",(Imp)DramaVisibilityHeaderAttached);
    Hook(header,"layoutSubviews","fqx_originalDramaSearchHeaderBounds","v16@0:8",(Imp)DramaVisibilityHeaderBounds);
    Hook(header,"finishSearchIconVisibilityTransition:","fqx_originalDramaSearchTransitionFinished:",
         "v20@0:8B16",(Imp)DramaVisibilitySearchTransitionFinished);
    Hook(header,"updateTabViewWithContentSize:","fqx178r7_originalHeaderTabs:",
         "v32@0:8{CGSize=dd}16",(Imp)DramaVisibilityHeaderTabs);
    Hook(header,"layoutTabContainerWithDesiredWidth:baseWidth:reserveSearchButton:",
         "fqx_originalDramaHeaderTabGeometry:base:reserve:","v36@0:8d16d24B32",(Imp)DramaHeaderTabGeometry);
    Hook(feed,"finalizeTabSelectionUIStateWithTabModel:","fqx_originalDramaHeaderSelected:",
         "v24@0:8@16",(Imp)DramaHeaderSelectionChanged);
    Hook(feed,"updateContentBackgroundColorWithTabModel:","fqx_originalDramaContentBackground:",
         "v24@0:8@16",(Imp)DramaHeaderContentBackgroundChanged);
    Hook(header,"applySearchBarVisibilityForCurrentLayout","fqx_originalDramaSearchBarLayout",
         "d16@0:8",(Imp)DramaVisibilitySearchBarLayout);
    Hook(header,"updateFindDramaSearchAlphaV731:","fqx_originalDramaSearchBarAlpha:",
         "v24@0:8d16",(Imp)DramaVisibilitySearchBarAlpha);
    Hook(header,"applySearchIconVisible:tabContainerTop:","fqx_originalDramaSearchIcon:top:",
         "v28@0:8B16d20",(Imp)DramaVisibilitySearchIcon);
    Hook("SSVideoSeriesFeedViewController","relayoutHeaderView","fqx178r7_originalDramaHeaderLayout",
         "v16@0:8",(Imp)DramaVisibilityHeaderLayout);
    Hook(feed,"viewDidAppear:","fqx_originalDramaSearchFeedAppeared:","v20@0:8B16",(Imp)DramaVisibilityFeedAppeared);
    const char *manager="SSShortVideoBelowLeftContainerViewManager";
    if (Signature(manager,"updateSubViews","v16@0:8"))
        Hook(manager,"shouldAddAiUsageView","fqx178r7_originalShouldAddAiUsageView","B16@0:8",(Imp)DramaVisibilityAuthor);
    const char *above="SSShortVideoAboveLeftContainerViewManager";
    if (Signature(above,"updateLayoutForContainerView","v16@0:8"))
        Hook(above,"orderedAboveLeftViewsForCurrentState","fqx178r8_originalOrderedAboveLeftViews",
             "@16@0:8",(Imp)DramaVisibilityNovel);
    const char *novel="SSShortVideoRcmdReasonView";
    if (Signature(novel,"dataModel","@16@0:8") && Signature(novel,"gradientBackgroundView","@16@0:8")) {
        Hook(novel,"layoutSubviews","fqx_originalNovelLayout","v16@0:8",(Imp)DramaOriginalNovelLayout);
        Hook(novel,"modelDidUpdate","fqx_originalNovelModelUpdate","v16@0:8",(Imp)DramaOriginalNovelModel);
    }
    const char *danmaku="FQCShortVideoDanmakuEntranceView";
    Hook(danmaku,"layoutSubviews","fqx178r8_originalDanmakuLayout","v16@0:8",(Imp)DramaDanmakuLayout);
    Hook(danmaku,"refreshIcon","fqx178r8_originalDanmakuRefreshIcon","v16@0:8",(Imp)DramaDanmakuRefreshIcon);
    Hook("FQVShortVideoVPlayerControlView","updateFullscreenBtnLayout","fqx178r8_originalFullscreenButtonLayout",
         "v16@0:8",(Imp)DramaFullscreenButtonLayout);
}

// Measure the glass and the playback track in the same coordinate space.
// The clear seek padding is not part of the visual gap.
static void DramaSpacingBusy178R2Key(void) {}
static void DramaSpacingTarget178R2Key(void) {}
static void DramaSpacingStock178R2Key(void) {}
static void DramaSpacingApplied178R2Key(void) {}
static void DramaSpacingLog178R2Key(void) {}
static void DramaSpacingAnchor178R6Key(void) {}
static void DramaDockProgressKey(void) {}
static void DramaNovelStockFrameKey(void) {}
static void DramaNovelAppliedFrameKey(void) {}
static void DramaDockFeatherBottomGradient178R6(Obj root);

static B DramaSpacingVisible178R2(Obj view) {
    return Kind(view,"UIView") && !Flag(view,"isHidden") &&
        ((double(*)(Obj,Sel))Message)(view,sel_registerName("alpha"))>0.01 && VisibleRect(Bounds(view));
}
static B DramaSpacingCrossfadeVisible(Obj view) {
    return Kind(view,"UIView") && !Flag(view,"isHidden") && VisibleRect(Bounds(view));
}
static B DramaProgressName178R2(Obj view) {
    if (Kind(view,"UISlider")) return 1;
    Obj name=Get(object_getClass(view),"description");
    if (!Kind(name,"NSString")) return 0;
    name=O0(name,"lowercaseString");
    return ((B(*)(Obj,Sel,Obj))Message)(name,sel_registerName("containsString:"),Text("progress")) ||
           ((B(*)(Obj,Sel,Obj))Message)(name,sel_registerName("containsString:"),Text("slider"));
}
static Obj DramaEpisodePrimaryContent(Obj entry) {
    if (Kind(entry,"SSShortVideoAlbumSeriesBottomInsertView"))
        return Get(entry,"albumDetailInfo") ? Get(entry,"containerView") : (Obj)0;
    if (!Kind(entry,"SSShortVideoBottomDistributionView")) return 0;
    Obj owned=objc_getAssociatedObject(entry,DramaWatchContentKey);
    if (owned) return owned;
    return DramaWatchIsEpisode(Get(entry,"lastRenderModel")) ? Get(entry,"defaultContentView") : (Obj)0;
}
static Obj DramaEpisodeNovelContent(Obj entry) {
    if (Kind(entry,"SSShortVideoOriginalNovelEntranceView"))
        return DramaSpacingVisible178R2(entry) ? entry : (Obj)0;
    if (!Kind(entry,"SSShortVideoBottomDistributionView") || DramaEpisodePrimaryContent(entry)) return 0;
    Obj related=objc_getAssociatedObject(entry,DramaDetailRelatedContentKey);
    return Belongs(related,entry) && objc_getAssociatedObject(related,DramaGlassKey) ? related : (Obj)0;
}
static Obj DramaEpisodeContent(Obj entry) {
    Obj primary=DramaEpisodePrimaryContent(entry);
    return primary ? primary : DramaEpisodeNovelContent(entry);
}
static Obj DramaEpisodeMaterial(Obj entry) {
    if (Kind(entry,"SSShortVideoOutterMultiGenreFeedAboveProgressView")) {
        Obj background=Get(entry,"backgroundView");
        return Get(background,"superview")==entry && DramaSpacingVisible178R2(background) ? background : (Obj)0;
    }
    if (Kind(entry,"SSShortVideoOriginalNovelEntranceView")) {
        if (!DramaSpacingVisible178R2(entry)) return 0;
        Obj glass=objc_getAssociatedObject(entry,DramaGlassKey);
        if (Get(glass,"superview")==entry) return DramaSpacingVisible178R2(glass) ? glass : (Obj)0;
        return entry;
    }
    B allowCrossfade=Kind(entry,"SSShortVideoBottomDistributionView");
    Obj content=DramaEpisodeContent(entry);
    if (!Belongs(content,entry) || !(allowCrossfade ? DramaSpacingCrossfadeVisible(content) : DramaSpacingVisible178R2(content))) return 0;
    Obj glass=objc_getAssociatedObject(content,DramaGlassKey);
    if (Get(glass,"superview")==content) return (allowCrossfade ? DramaSpacingCrossfadeVisible(glass) : DramaSpacingVisible178R2(glass)) ? glass : (Obj)0;
    // After a native insert swap the visible pill can precede glass installation.
    return content;
}
static Rect DramaSpacingMeasure178R2(Obj view,Obj root) {
    Rect result=Convert(view,Bounds(view),root);
    Obj target=Get(objc_getAssociatedObject(root,DramaSpacingTarget178R2Key),"anyObject");
    Obj stock=objc_getAssociatedObject(target,DramaSpacingStock178R2Key);
    Obj applied=objc_getAssociatedObject(target,DramaSpacingApplied178R2Key);
    // Discovery uses the host baseline, never the previous repaired position.
    // Otherwise a shifted row crossing a scan threshold can alternate forever.
    if (stock && applied && Belongs(view,target) && SameRect(Frame(target),UnboxRect(applied)))
        result.y+=UnboxRect(stock).y-UnboxRect(applied).y;
    return result;
}
static void DramaSpacingScan178R2(Obj view,Obj root,Obj insert,int depth,int *budget,B progressBranch,
                                 Obj *primaryEntry,U *primaryCount,Obj *novelEntry,U *novelCount,
                                 Obj *progress,Rect *track) {
    B allowCrossfade=Kind(view,"SSShortVideoBottomDistributionView");
    if (!depth || *budget<=0 || !(allowCrossfade ? DramaSpacingCrossfadeVisible(view) : DramaSpacingVisible178R2(view))) return;
    --*budget;
    Rect bounds=Bounds(root),r=DramaSpacingMeasure178R2(view,root);
    if (!VisibleRect(r) || r.y>=bounds.y+bounds.height || r.y+r.height<=bounds.y) return;
    B primaryMatch=DramaEpisodePrimaryContent(view) ||
        (Kind(view,"SSShortVideoAlbumSeriesBottomInsertView") && Get(view,"albumDetailInfo"));
    if (primaryMatch || DramaEpisodeNovelContent(view)) {
        if ((!insert || Belongs(view,insert)) && r.width>=bounds.width*0.5 && r.height>=24 &&
            r.height<=100 && r.y>bounds.y+bounds.height*0.5) {
            if (primaryMatch) { *primaryEntry=view; ++*primaryCount; }
            else { *novelEntry=view; ++*novelCount; }
        }
        return;
    }
    if (Kind(view,"FQVShortVideoProgressView")) {
        // The host mounts the custom background alongside the standard one.
        // Fills, dots and other thin subviews are not the track boundary.
        for (U i=0;i<2;++i) {
            Obj candidate=Get(view,i ? "progressBarBackgroundView" : "customizedProgressBarBackgroundView");
            if (Get(candidate,"superview")!=view || !DramaSpacingVisible178R2(candidate)) continue;
            Rect frame=Convert(candidate,Bounds(candidate),root);
            if (VisibleRect(frame) && frame.width>=bounds.width*0.5 && frame.height<=8 &&
                frame.y>bounds.y+bounds.height*0.6 && frame.y<bounds.y+bounds.height) {
                *progress=candidate;
                *track=frame;
                break;
            }
        }
        return;
    }
    progressBranch=progressBranch || DramaProgressName178R2(view);
    // A public slider or a thin full-width child of the host's progress view.
    // Exclude labels, counters, vertical rails and unrelated one-pixel dividers.
    if (progressBranch && !Kind(view,"UILabel") && r.width>=bounds.width*0.5 &&
        r.height<=64 && r.y>bounds.y+bounds.height*0.6 &&
        (!*progress || r.height<track->height || (r.height==track->height && r.y>track->y))) {
        *progress=view; *track=r;
    }
    if (!progressBranch && (Kind(view,"UILabel") || Kind(view,"UIImageView") || Kind(view,"UIVisualEffectView")))
        return;
    Obj children=Get(view,"subviews");
    U count=((U(*)(Obj,Sel))Message)(children,sel_registerName("count"));
    for (U i=0;i<count && *budget>0;++i)
        DramaSpacingScan178R2(At(children,i),root,insert,depth-1,budget,progressBranch,
                              primaryEntry,primaryCount,novelEntry,novelCount,progress,track);
}
static void DramaSpacingRestore178R2(Obj root) {
    Obj target=Get(objc_getAssociatedObject(root,DramaSpacingTarget178R2Key),"anyObject");
    Obj stock=objc_getAssociatedObject(target,DramaSpacingStock178R2Key);
    Obj applied=objc_getAssociatedObject(target,DramaSpacingApplied178R2Key);
    if (stock && applied && SameRect(Frame(target),UnboxRect(applied))) SetFrame(target,UnboxRect(stock));
    objc_setAssociatedObject(target,DramaSpacingStock178R2Key,0,1);
    objc_setAssociatedObject(target,DramaSpacingApplied178R2Key,0,1);
    objc_setAssociatedObject(root,DramaSpacingTarget178R2Key,0,1);
}
static B DramaSpacingContained178R2(Obj target,Rect wanted,Obj root) {
    Obj parent=Get(target,"superview");
    for (Obj ancestor=parent;ancestor;ancestor=Get(ancestor,"superview")) {
        Rect r=Convert(parent,wanted,ancestor),b=Bounds(ancestor);
        // Even unclipped UIView parents reject outside hits. Keep the full
        // original tap target inside every parent instead of widening hitTest.
        if (!VisibleRect(r) || !VisibleRect(b) || r.x<b.x-0.5 || r.y<b.y-0.5 ||
            r.x+r.width>b.x+b.width+0.5 || r.y+r.height>b.y+b.height+0.5) return 0;
        if (ancestor==root) return 1;
    }
    return 0;
}

static Obj DramaSpacingAnchor(Obj insert,Obj seek,Obj root,B outer) {
    if (!Belongs(insert,root) || !Belongs(seek,root)) return 0;
    // The outer feed anchors the insert to the control bottom. Series players
    // can replace the base constraint with one anchored to the seek edges or center.
    Obj match=0;
    for (Obj parent=Get(insert,"superview");parent;parent=Get(parent,"superview")) {
        Obj constraints=Get(parent,"constraints");
        U count=((U(*)(Obj,Sel))Message)(constraints,sel_registerName("count"));
        for (U i=0;i<count;++i) {
            Obj constraint=At(constraints,i);
            if (Get(constraint,"firstItem")!=insert || !Flag(constraint,"isActive")) continue;
            Obj reference=Get(constraint,"secondItem");
            I attribute=((I(*)(Obj,Sel))Message)(constraint,sel_registerName("secondAttribute"));
            if (outer ? (reference!=seek || attribute!=4) :
                !((reference==root && attribute==4) ||
                  (reference==seek && (attribute==3 || attribute==4 || attribute==10)))) continue;
            if (((I(*)(Obj,Sel))Message)(constraint,sel_registerName("firstAttribute"))!=4 ||
                ((I(*)(Obj,Sel))Message)(constraint,sel_registerName("relation"))!=0 ||
                ((double(*)(Obj,Sel))Message)(constraint,sel_registerName("multiplier"))!=1) continue;
            if (match) return 0;
            match=constraint;
        }
        if (parent==root) break;
    }
    return match;
}

static double DramaAnchorConstant(Obj anchor) {
    return ((double(*)(Obj,Sel))Message)(anchor,sel_registerName("constant"));
}

static void DramaSetAnchorConstant(Obj anchor,double value) {
    // The host updates and reinstalls its Masonry constraint. Keep the offset
    // on the wrapper and UIKit constraint in sync so a later pass uses it.
    Obj installed=Get(Get(Get(anchor,"firstItem"),"mas_installedConstraints"),"allObjects");
    for (U i=0,count=TabCount(installed);i<count;++i) {
        Obj wrapper=At(installed,i);
        if (!Kind(wrapper,"MASViewConstraint") || Get(wrapper,"layoutConstraint")!=anchor ||
            !InstanceABI(wrapper,"setLayoutConstant:","v24@0:8d16")) continue;
        ((void(*)(Obj,Sel,double))Message)(wrapper,sel_registerName("setLayoutConstant:"),value);
        return;
    }
    ((void(*)(Obj,Sel,double))Message)(anchor,sel_registerName("setConstant:"),value);
}

static void DramaSpacingRestoreAnchor(Obj root,Obj keep) {
    Obj previous=objc_getAssociatedObject(root,DramaSpacingAnchor178R6Key);
    if (!previous || previous==keep) return;
    Obj stock=objc_getAssociatedObject(previous,DramaSpacingStock178R2Key);
    Obj applied=objc_getAssociatedObject(previous,DramaSpacingApplied178R2Key);
    if (DramaAnchorConstant(previous)==Double(applied))
        DramaSetAnchorConstant(previous,Double(stock));
    objc_setAssociatedObject(previous,DramaSpacingStock178R2Key,0,1);
    objc_setAssociatedObject(previous,DramaSpacingApplied178R2Key,0,1);
    objc_setAssociatedObject(root,DramaSpacingAnchor178R6Key,0,1);
}
static void DramaNovelAvoidDock(Obj root,Obj dock) {
    Obj entry=Get(root,"aboveProgressView");
    Obj views[]={entry,Get(root,"baseInfoView"),Get(root,"bookCardView"),Get(root,"rightInteractionView")};
    double shift=0;
    if (dock && Get(entry,"superview")==root && DramaSpacingVisible178R2(entry)) {
        Rect current=Frame(entry);
        Obj previous=objc_getAssociatedObject(entry,DramaNovelAppliedFrameKey);
        Rect stock=previous && SameRect(current,UnboxRect(previous))
            ? UnboxRect(objc_getAssociatedObject(entry,DramaNovelStockFrameKey)) : current;
        Rect dockRect=Convert(dock,Bounds(dock),root);
        if (VisibleRect(dockRect))
            shift=__builtin_fmax(0,stock.y+stock.height-dockRect.y+8);
    }
    for (U i=0;i<sizeof(views)/sizeof(views[0]);++i) {
        Obj view=views[i];
        if (Get(view,"superview")!=root) continue;
        Rect current=Frame(view);
        Obj previous=objc_getAssociatedObject(view,DramaNovelAppliedFrameKey);
        Rect stock=previous && SameRect(current,UnboxRect(previous))
            ? UnboxRect(objc_getAssociatedObject(view,DramaNovelStockFrameKey)) : current;
        if (shift>0.5 && VisibleRect(stock) && !Flag(view,"isHidden")) {
            Rect target=stock;
            target.y-=shift;
            BottomApplyFrame178(view,target,DramaNovelStockFrameKey,DramaNovelAppliedFrameKey);
        } else {
            BottomRestoreFrame178(view,DramaNovelStockFrameKey,DramaNovelAppliedFrameKey);
        }
    }
}
void FQHDramaSpacing178R2(Obj root) {
    B outer=Kind(root,"SSShortVideoOutterMultiGenreFeedControlView");
    if ((!outer && !Kind(root,"FQVShortVideoVPlayerControlView")) ||
        objc_getAssociatedObject(root,DramaSpacingBusy178R2Key)) return;
    objc_setAssociatedObject(root,DramaSpacingBusy178R2Key,root,0);
    if (!outer) {
        DramaPureCleanUpdate178R13(root,1);
        DramaDockFeatherBottomGradient178R6(root);
    }
    Obj window=Get(root,"window"),entry=0,progress=0,target=0,seekOwner=0,glass=0,anchor=0,insert=0;
    Rect b=Bounds(root),screen=window ? Bounds(window) : (Rect){0},track={0},row={0};
    double shift=0;
    const char *status="inactive";
    B eligible=Enabled() && window && DramaSpacingVisible178R2(root) &&
        screen.height>screen.width && b.height>b.width && b.width>=screen.width-4;
    if (eligible) {
        Rect placed=Convert(root,b,window);
        // Attached feed cells can move vertically onscreen without laying out
        // their children again. Keep their installed constraint while paging
        // and across UINavigationController push/pop parallax (-0.3 * width).
        eligible=VisibleRect(placed) &&
            placed.x>screen.x-screen.width*0.5 && placed.x<screen.x+2 &&
            __builtin_fabs(placed.width-b.width)<0.5 &&
            __builtin_fabs(placed.height-b.height)<0.5;
    }
    B novel=outer && Get(Get(root,"leftModuleCoordinator"),"pushTextContentData") &&
        !Flag(root,"shouldShowProgressView");
    Obj dock=(eligible && !novel && BottomFlag178(37)) ? BottomDramaCapsuleForView(root) : (Obj)0;
    Obj previousRail=objc_getAssociatedObject(root,DramaDockProgressKey),rail=0;
    if (dock) {
        rail=Get(root,outer ? "progressView" : "progressContainer");
        if (!Kind(rail,outer ? "SSShortVideoOutterMultiGenreProgressView" : "FQVShortVideoProgressView") ||
            !Belongs(rail,root)) rail=0;
    }
    if (rail!=previousRail) {
        if (previousRail) DramaAlignWithDock(previousRail,0,16);
        objc_setAssociatedObject(root,DramaDockProgressKey,rail,1);
    }
    // Both native rail types draw and update their fill in a 16-point inset.
    if (rail && DramaAlignWithDock(rail,dock,16)) {
        V0(rail,"setNeedsLayout");
        V0(rail,"layoutIfNeeded");
    }
    if (eligible && novel) {
        status="novelDockClearance";
    } else if (eligible && outer) {
        entry=Get(root,"aboveProgressView");
        progress=Get(root,"progressView");
        status="outerControlsUnresolved";
        const char *progressClass="SSShortVideoOutterMultiGenreProgressView";
        if (Get(entry,"superview")==root && DramaSpacingVisible178R2(entry) &&
            Get(progress,"superview")==root && Kind(progress,progressClass) &&
            DramaSpacingVisible178R2(progress) &&
            Signature(progressClass,"progressBgWidth","d16@0:8") &&
            Signature(progressClass,"progressBarHeight","d16@0:8") &&
            Signature(progressClass,"progressBarYWithHeight:","d24@0:8d16")) {
            double width=((double(*)(Obj,Sel))Message)(progress,sel_registerName("progressBgWidth"));
            double height=((double(*)(Obj,Sel))Message)(progress,sel_registerName("progressBarHeight"));
            double y=((double(*)(Obj,Sel,double))Message)(progress,sel_registerName("progressBarYWithHeight:"),height);
            track=Convert(progress,(Rect){16,y,width,height},root);
            if (VisibleRect(track) && width>=b.width*0.5 && height<=8) {
                glass=DramaEpisodeMaterial(entry);
                seekOwner=progress;
                anchor=DramaSpacingAnchor(entry,seekOwner,root,1);
                if (glass && anchor) target=entry;
            }
        }
    } else if (eligible) {
        Obj primaryEntry=0,novelEntry=0;
        U entries=0,primaryCount=0,novelCount=0; int budget=128;
        insert=Get(root,"insertAboveProgressView");
        if (!Belongs(insert,root)) insert=0;
        Obj progressContainer=Get(root,"progressContainer");
        if (!Kind(progressContainer,"FQVShortVideoProgressView") ||
            !DramaSpacingVisible178R2(progressContainer) || !Belongs(progressContainer,root))
            progressContainer=0;
        if (insert && progressContainer) {
            int insertBudget=256,trackBudget=16;
            DramaSpacingScan178R2(insert,root,insert,8,&insertBudget,0,
                                  &primaryEntry,&primaryCount,&novelEntry,&novelCount,&progress,&track);
            DramaSpacingScan178R2(progressContainer,root,0,4,&trackBudget,0,
                                  &primaryEntry,&primaryCount,&novelEntry,&novelCount,&progress,&track);
            if (insertBudget<=0 || trackBudget<=0) budget=0;
        } else {
            DramaSpacingScan178R2(root,root,insert,8,&budget,0,
                                  &primaryEntry,&primaryCount,&novelEntry,&novelCount,&progress,&track);
        }
        if (primaryCount==1) { entry=primaryEntry; entries=1; }
        else if (primaryCount>1) entries=primaryCount;
        else if (novelCount==1) { entry=novelEntry; entries=1; }
        else entries=novelCount;
        // A broad progress container is not evidence of the visible track's
        // position. If the thin track is hidden or absent, keep the host layout.
        B visibleTrack=progress && track.height<=8;
        status=budget<=0 ? "scanLimit" : entries!=1 ? "noUniqueEpisodeEntry" : !progress ? "progressNotResolved" :
            !visibleTrack ? "progressTrackUnresolved" : "measured";
        if (entries==1 && visibleTrack && budget>0) {
            glass=DramaEpisodeMaterial(entry);
            if (!glass) status="episodeGlassUnresolved";
        }
        if (glass) {
            row=DramaSpacingMeasure178R2(entry,root);
            target=entry;
            // Move the compact information block as a unit when it owns the
            // episode row. This retains spacing to its title/caption above.
            for (Obj parent=Get(target,"superview");parent && parent!=root;parent=Get(parent,"superview")) {
                Rect p=DramaSpacingMeasure178R2(parent,root);
                if (!Belongs(parent,root) || Belongs(progress,parent) || !VisibleRect(p) ||
                    p.height*5>b.height*3 || p.width<row.width*0.75 ||
                    (p.y-b.y)*10<b.height*3 || p.y+p.height>row.y+row.height+16) break;
                target=parent;
            }
            for (Obj seek=Get(progress,"superview");seek && seek!=root;seek=Get(seek,"superview")) {
                Rect r=Convert(seek,Bounds(seek),root);
                if (DramaProgressName178R2(seek) && VisibleRect(r) && r.height<=64 &&
                    r.width>=b.width*0.5 && (r.y-b.y)*5>b.height*3) seekOwner=seek;
            }
            if (!seekOwner && progressContainer) seekOwner=progressContainer;
            if (insert && Belongs(entry,insert)) {
                anchor=DramaSpacingAnchor(insert,seekOwner,root,0);
                if (anchor) target=insert;
            }
        }
    }
    Obj previousAnchor=objc_getAssociatedObject(root,DramaSpacingAnchor178R6Key);
    if (eligible && !outer && !target && insert && previousAnchor &&
        Get(previousAnchor,"firstItem")==insert && Flag(previousAnchor,"isActive") &&
        DramaAnchorConstant(previousAnchor)==Double(objc_getAssociatedObject(previousAnchor,DramaSpacingApplied178R2Key))) {
        // A pause or foreground crossfade can briefly hide the painted child.
        // Keep the correction on the current native insert until it is replaced.
        anchor=previousAnchor;
        status="retainedEpisodeConstraint";
    }
    DramaSpacingRestoreAnchor(root,anchor);
    Obj previous=Get(objc_getAssociatedObject(root,DramaSpacingTarget178R2Key),"anyObject");
    if (previous && (previous!=target || anchor)) DramaSpacingRestore178R2(root);
    if (target) {
        Rect current=Frame(target),targetBounds=Bounds(target);
        Obj applied=objc_getAssociatedObject(target,DramaSpacingApplied178R2Key);
        Obj saved=objc_getAssociatedObject(target,DramaSpacingStock178R2Key);
        Rect stock=applied && saved && SameRect(current,UnboxRect(applied)) ? UnboxRect(saved) : current;
        Rect targetInRoot=Convert(target,targetBounds,root);
        double constant=0,stockConstant=0;
        if (anchor) {
            constant=DramaAnchorConstant(anchor);
            Obj anchorStock=objc_getAssociatedObject(anchor,DramaSpacingStock178R2Key);
            Obj anchorApplied=objc_getAssociatedObject(anchor,DramaSpacingApplied178R2Key);
            stockConstant=anchorApplied && constant==Double(anchorApplied) ? Double(anchorStock) : constant;
            double referenceY=b.y+b.height;
            if (Get(anchor,"secondItem")==seekOwner) {
                Rect seek=Convert(seekOwner,Bounds(seekOwner),root);
                I attr=outer ? 4 : ((I(*)(Obj,Sel))Message)(anchor,sel_registerName("secondAttribute"));
                referenceY=seek.y+(attr==3 ? 0 : attr==4 ? seek.height : seek.height*0.5);
            }
            // Calculate the host baseline even before UIKit applies a new
            // constraint constant to the frames in this pass.
            stock.y+=referenceY+stockConstant-(targetInRoot.y+targetInRoot.height);
        }
        Rect material=Convert(glass,Bounds(glass),root);
        shift=__builtin_fmax(0,material.y+material.height+(stock.y-current.y)+12-track.y);
        B safe=VisibleRect(stock) && __builtin_fabs(targetInRoot.width-targetBounds.width)<0.5 &&
            __builtin_fabs(targetInRoot.height-targetBounds.height)<0.5 && shift<=80 &&
            targetInRoot.y+(stock.y-current.y)-shift>=b.y+8;
        Rect wanted=stock; wanted.y-=shift;
        safe=safe && DramaSpacingContained178R2(target,wanted,root);
        if (safe && shift>0 && anchor) {
            double wantedConstant=stockConstant-shift;
            if (constant!=wantedConstant) {
                objc_setAssociatedObject(anchor,DramaSpacingStock178R2Key,Number(stockConstant),1);
                objc_setAssociatedObject(anchor,DramaSpacingApplied178R2Key,Number(wantedConstant),1);
                objc_setAssociatedObject(root,DramaSpacingAnchor178R6Key,anchor,1);
                DramaSetAnchorConstant(anchor,wantedConstant);
                V0(root,"setNeedsLayout");
                Obj targetParent=Get(target,"superview");
                if (targetParent && targetParent!=root) V0(targetParent,"setNeedsLayout");
            }
            // The rail can change during a child callback, after the parent
            // has solved constraints. Commit the same resolved frame now.
            if (!SameRect(current,wanted)) SetFrame(target,wanted);
            status="separated";
        } else if (safe && shift>0) {
            if (!saved || !SameRect(stock,UnboxRect(saved)))
                objc_setAssociatedObject(target,DramaSpacingStock178R2Key,RectBox(stock),1);
            if (!applied || !SameRect(wanted,UnboxRect(applied)))
                objc_setAssociatedObject(target,DramaSpacingApplied178R2Key,RectBox(wanted),1);
            if (previous!=target) {
                Obj weak=O0(Lookup("NSHashTable"),"weakObjectsHashTable");
                V1(weak,"addObject:",target);
                objc_setAssociatedObject(root,DramaSpacingTarget178R2Key,weak,1);
            }
            if (!SameRect(current,wanted)) SetFrame(target,wanted);
            status="separated";
        } else {
            DramaSpacingRestoreAnchor(root,0);
            DramaSpacingRestore178R2(root);
            status=safe ? "alreadySeparated" : "unsupportedGeometry";
            shift=0;
        }
    }
    if (outer) DramaNovelAvoidDock(root,eligible && novel ? BottomDramaCapsuleForView(root) : (Obj)0);
    if (FQDDiagnosticsEnabled() && (eligible || previous || previousAnchor)) {
        Obj record=O0(Lookup("NSMutableDictionary"),"dictionary");
        Put(record,"status",Text(status)); Put(record,"shiftY",Number(shift));
        Put(record,"revision",Text(outer ? "outer-episode-glass" : "episode-glass-178R8"));
        Put(record,"spacingReference",Text("episodeGlassToTrack")); Put(record,"gap",Number(12));
        if (glass) {
            Rect actualGlass=Convert(glass,Bounds(glass),root);
            Put(record,"trackGap",Number(track.y-actualGlass.y-actualGlass.height));
            Put(record,"episodeGlassWindowRect",RectArray(Convert(glass,Bounds(glass),window)));
        }
        if (anchor) Put(record,"usesEpisodeConstraint",BoolBox(1));
        if (entry) Put(record,"episodeWindowRect",RectArray(Convert(entry,Bounds(entry),window)));
        if (progress) {
            Put(record,"progressWindowRect",RectArray(outer ? Convert(root,track,window) :
                Convert(progress,Bounds(progress),window)));
            Put(record,"progressClass",Get(object_getClass(progress),"description"));
        }
        if (seekOwner) {
            Put(record,"seekOwnerClass",Get(object_getClass(seekOwner),"description"));
            Put(record,"seekOwnerWindowRect",RectArray(Convert(seekOwner,Bounds(seekOwner),window)));
        }
        Obj last=objc_getAssociatedObject(root,DramaSpacingLog178R2Key);
        if (!last || !((B(*)(Obj,Sel,Obj))Message)(last,sel_registerName("isEqual:"),record)) {
            FQDRecord("dramaControlSpacing178R2",record);
            objc_setAssociatedObject(root,DramaSpacingLog178R2Key,record,1);
        }
    }
    objc_setAssociatedObject(root,DramaSpacingBusy178R2Key,0,0);
}
static void DramaSpacingForView(Obj view) {
    Obj parent=Get(view,"superview");
    for (int depth=0;parent && depth<16;++depth,parent=Get(parent,"superview")) {
        if (Kind(parent,"FQVShortVideoVPlayerControlView")) { FQHDramaSpacing178R2(parent); return; }
    }
}
static void DramaControlsLayout178R2(Obj self,Sel cmd) {
    ((void(*)(Obj,Sel))Original("FQVShortVideoVPlayerControlView","fqx178R2_originalControlsLayout"))(self,cmd);
    FQHDramaSpacing178R2(self);
    DramaFullscreenButtonApply178R11(self);
}
static void DramaSeriesControlsLayout178R2(Obj self,Sel cmd) {
    ((void(*)(Obj,Sel))Original("FQVShortVideoVPlayerSeriesControlView","fqx178R2_originalSeriesControlsLayout"))(self,cmd);
    FQHDramaSpacing178R2(self);
    DramaFullscreenButtonApply178R11(self);
}
static void DramaControlsDidDisplay(Obj self,Sel cmd) {
    ((void(*)(Obj,Sel))Original("FQVShortVideoVPlayerControlView","fqx178r8_originalControlsDidDisplay"))(self,cmd);
    objc_setAssociatedObject(self,DramaPureCleanEnded178R13Key,0,1);
    FQHDramaSpacing178R2(self);
    DramaFullscreenButtonApply178R11(self);
}
static void DramaProgressLayout(Obj self,Sel cmd) {
    ((void(*)(Obj,Sel))Original("FQVShortVideoProgressView","fqx178r8_originalProgressLayout"))(self,cmd);
    DramaSpacingForView(self);
}
static void DramaProgressPlaying(Obj self,Sel cmd,B playing,B animate) {
    ((void(*)(Obj,Sel,B,B))Original("FQVShortVideoProgressView","fqx178r8_originalProgressPlaying:animate:"))(self,cmd,playing,animate);
    DramaSpacingForView(self);
}
static void DramaProgressActivated(Obj self,Sel cmd,U state) {
    ((void(*)(Obj,Sel,U))Original("FQVShortVideoProgressView","fqx_originalDramaProgressActivated:"))(self,cmd,state);
    DramaSpacingForView(self);
}
static void DramaProgressState(Obj self,Sel cmd,U state,B showDot) {
    ((void(*)(Obj,Sel,U,B))Original("FQVShortVideoProgressView","fqx_originalDramaProgressState:showDot:"))(
        self,cmd,state,showDot);
    DramaSpacingForView(self);
}
static void DramaProgressConfigure(Obj self,Sel cmd,U type,Obj configMaker) {
    ((void(*)(Obj,Sel,U,Obj))Original("FQVShortVideoProgressView","fqx_originalDramaProgressConfigure:configMaker:"))(
        self,cmd,type,configMaker);
    // Setup can replace the visible track without another layout or playback callback.
    DramaSpacingForView(self);
}
static void DramaEpisodeInsert(Obj self,Sel cmd,Obj insert) {
    ((void(*)(Obj,Sel,Obj))Original("FQVShortVideoVPlayerControlView","fqx_originalDramaEpisodeInsert:"))(self,cmd,insert);
    FQHDramaSpacing178R2(self);
}
static void DramaOuterEpisodeInsert(Obj self,Sel cmd,Obj insert) {
    ((void(*)(Obj,Sel,Obj))Original("FQVShortVideoVPlayerOutterMultiSeriesControlView","fqx_originalOuterDramaEpisodeInsert:"))(self,cmd,insert);
    FQHDramaSpacing178R2(self);
}
static void DramaSeriesEpisodeInsert(Obj self,Sel cmd,Obj insert) {
    ((void(*)(Obj,Sel,Obj))Original("FQVShortVideoVPlayerSeriesControlView","fqx_originalSeriesDramaEpisodeInsert:"))(self,cmd,insert);
    FQHDramaSpacing178R2(self);
}
static void DramaOuterControlsLayout(Obj self,Sel cmd) {
    ((void(*)(Obj,Sel))Original("SSShortVideoOutterMultiGenreFeedControlView","fqx_originalOuterControlsLayout"))(self,cmd);
    FQHDramaSpacing178R2(self);
}
static void DramaOuterAboveProgressLayout(Obj self,Sel cmd) {
    ((void(*)(Obj,Sel))Original("SSShortVideoOutterMultiGenreFeedControlView","fqx_originalOuterAboveProgressLayout"))(self,cmd);
    FQHDramaSpacing178R2(self);
}
static void DramaOuterProgressLayout(Obj self,Sel cmd) {
    ((void(*)(Obj,Sel))Original("SSShortVideoOutterMultiGenreProgressView","fqx_originalOuterProgressLayout"))(self,cmd);
    Obj root=Get(self,"superview");
    if (Kind(root,"SSShortVideoOutterMultiGenreFeedControlView") && Get(root,"progressView")==self)
        FQHDramaSpacing178R2(root);
}
static void DramaSpacingInstall178R2(void) {
    const char *outer="SSShortVideoOutterMultiGenreFeedControlView";
    Hook(outer,"layoutSubviews","fqx_originalOuterControlsLayout","v16@0:8",(Imp)DramaOuterControlsLayout);
    Hook(outer,"updateAboveProgressLayout","fqx_originalOuterAboveProgressLayout","v16@0:8",
         (Imp)DramaOuterAboveProgressLayout);
    Hook("SSShortVideoOutterMultiGenreProgressView","layoutSubviews","fqx_originalOuterProgressLayout","v16@0:8",
         (Imp)DramaOuterProgressLayout);
    Obj owner=Lookup("FQVShortVideoVPlayerControlView");
    Sel layout=sel_registerName("layoutSubviews"),alias=sel_registerName("fqx178R2_originalControlsLayout");
    Method base=class_getInstanceMethod(owner,layout);
    Method series=class_getInstanceMethod(Lookup("FQVShortVideoVPlayerSeriesControlView"),sel_registerName("layoutSubviews"));
    B ownsSeries=series && series!=base;
    if (ClassABI(owner,"layoutSubviews","v16@0:8") && !class_getInstanceMethod(owner,alias)) {
        if (FQDResolveOwned(owner,layout,0,"v16@0:8"))
            Hook("FQVShortVideoVPlayerControlView","layoutSubviews","fqx178R2_originalControlsLayout","v16@0:8",(Imp)DramaControlsLayout178R2);
        // On 7.4.3.33 the control inherits UIView's layout implementation.
        // Install an override on this class, keeping UIView's method intact.
        else if (class_addMethod(owner,alias,method_getImplementation(base),"v16@0:8"))
            class_addMethod(owner,layout,(Imp)DramaControlsLayout178R2,"v16@0:8");
    }
    if (ownsSeries)
        Hook("FQVShortVideoVPlayerSeriesControlView","layoutSubviews","fqx178R2_originalSeriesControlsLayout","v16@0:8",(Imp)DramaSeriesControlsLayout178R2);
    Hook("FQVShortVideoVPlayerControlView","controlViewDidDisplay","fqx178r8_originalControlsDidDisplay",
         "v16@0:8",(Imp)DramaControlsDidDisplay);
    Hook("FQVShortVideoProgressView","layoutProgressView","fqx178r8_originalProgressLayout",
         "v16@0:8",(Imp)DramaProgressLayout);
    Hook("FQVShortVideoProgressView","updateProgressViewWithPlaying:animate:","fqx178r8_originalProgressPlaying:animate:",
         "v24@0:8B16B20",(Imp)DramaProgressPlaying);
    Hook("FQVShortVideoProgressView","updateProgressViewWithActivatedState:",
         "fqx_originalDramaProgressActivated:","v24@0:8Q16",(Imp)DramaProgressActivated);
    Hook("FQVShortVideoProgressView","updateProgressBarWithProgressBarType:configMaker:",
         "fqx_originalDramaProgressConfigure:configMaker:","v32@0:8Q16@?24",(Imp)DramaProgressConfigure);
    Hook("FQVShortVideoProgressView","updateProgressViewWithStateChange:showDot:",
         "fqx_originalDramaProgressState:showDot:","v28@0:8Q16B24",(Imp)DramaProgressState);
    Hook("FQVShortVideoVPlayerControlView","setInsertAboveProgressView:","fqx_originalDramaEpisodeInsert:",
         "v24@0:8@16",(Imp)DramaEpisodeInsert);
    Hook("FQVShortVideoVPlayerOutterMultiSeriesControlView","setInsertAboveProgressView:","fqx_originalOuterDramaEpisodeInsert:",
         "v24@0:8@16",(Imp)DramaOuterEpisodeInsert);
    Hook("FQVShortVideoVPlayerSeriesControlView","setInsertAboveProgressView:","fqx_originalSeriesDramaEpisodeInsert:",
         "v24@0:8@16",(Imp)DramaSeriesEpisodeInsert);
}

static void CaptionGeometryStockKey(void) {}
static void CaptionGeometryAppliedKey(void) {}
static void CaptionAlignmentStockKey(void) {}
static void ShelfMinimumFont(Obj label,B styled) {
    if (!styled) { RestoreAppearanceFont(label); return; }
    Obj current=Get(label,"font");
    if (!Kind(label,"UILabel") || !Responds(current,"pointSize") || !Responds(current,"fontWithSize:")) return;
    Obj applied=objc_getAssociatedObject(label,AppearanceFontAppliedKey);
    B ours=applied && SameColor(current,applied);
    Obj original=ours ? objc_getAssociatedObject(label,AppearanceFontStockKey) : current;
    double size=((double(*)(Obj,Sel))Message)(original,sel_registerName("pointSize"));
    if (size>=16 || HasCaptionAttributes(Get(label,"attributedText"))) { RestoreAppearanceFont(label); return; }
    if (ours) return;
    Obj font=((Obj(*)(Obj,Sel,double))Message)(original,sel_registerName("fontWithSize:"),16);
    if (!font) return;
    objc_setAssociatedObject(label,AppearanceFontStockKey,current,1);
    objc_setAssociatedObject(label,AppearanceFontAppliedKey,font,1);
    V1(label,"setFont:",font);
}
static void CenterCaption(Obj label,Obj owner,Rect content,B styled,B fit) {
    if (!Kind(label,"UILabel")) return;
    Rect bounds=Bounds(label);
    Point center=((Point(*)(Obj,Sel))Message)(label,sel_registerName("center"));
    Rect current={center.x,center.y,bounds.width,bounds.height},wanted=current;
    Obj applied=objc_getAssociatedObject(label,CaptionGeometryAppliedKey);
    Obj original=objc_getAssociatedObject(label,CaptionGeometryStockKey);
    Obj alignment=objc_getAssociatedObject(label,CaptionAlignmentStockKey);
    I currentAlignment=((I(*)(Obj,Sel))Message)(label,sel_registerName("textAlignment"));
    styled=styled && Belongs(label,owner);
    if (styled) {
        Rect rect=Convert(owner,content,Get(label,"superview"));
        wanted=(Rect){rect.x+rect.width*0.5,rect.y+rect.height*0.5,
                      fit ? rect.width : bounds.width,fit ? rect.height : bounds.height};
        if ((!applied || !SameRect(current,UnboxRect(applied))) &&
            (!original || !SameRect(current,UnboxRect(original))))
            objc_setAssociatedObject(label,CaptionGeometryStockKey,RectBox(current),1);
        if (!applied || !SameRect(wanted,UnboxRect(applied)))
            objc_setAssociatedObject(label,CaptionGeometryAppliedKey,RectBox(wanted),1);
        if (currentAlignment!=1) {
            if (!alignment || Double(alignment)!=currentAlignment)
                objc_setAssociatedObject(label,CaptionAlignmentStockKey,Number(currentAlignment),1);
            Q1(label,"setTextAlignment:",1);
        }
    } else {
        if (applied && SameRect(current,UnboxRect(applied)))
            wanted=UnboxRect(objc_getAssociatedObject(label,CaptionGeometryStockKey));
        if (alignment && currentAlignment==1) Q1(label,"setTextAlignment:",(I)Double(alignment));
        objc_setAssociatedObject(label,CaptionGeometryStockKey,0,1);
        objc_setAssociatedObject(label,CaptionGeometryAppliedKey,0,1);
        objc_setAssociatedObject(label,CaptionAlignmentStockKey,0,1);
    }
    // Bounds and center preserve the host's title zoom transform; setting frame
    // while a title is transformed would give an ambiguous layout rectangle.
    if (bounds.width!=wanted.width || bounds.height!=wanted.height) {
        bounds.width=wanted.width; bounds.height=wanted.height;
        ((void(*)(Obj,Sel,Rect))Message)(label,sel_registerName("setBounds:"),bounds);
    }
    if (center.x!=wanted.x || center.y!=wanted.y)
        ((void(*)(Obj,Sel,Point))Message)(label,sel_registerName("setCenter:"),(Point){wanted.x,wanted.y});
}
static void ShelfTabModelStockKey(void) {}
static double ShelfModelDouble(Obj model,const char *selector) {
    return ((double(*)(Obj,Sel))Message)(model,sel_registerName(selector));
}
static void ShelfSetModelDouble(Obj model,const char *getter,const char *setter,double value) {
    if (ShelfModelDouble(model,getter)!=value)
        ((void(*)(Obj,Sel,double))Message)(model,sel_registerName(setter),value);
}
static void ShelfRestoreTabModel(Obj model) {
    Obj stock=objc_getAssociatedObject(model,ShelfTabModelStockKey);
    if (!stock) return;
    VB(model,"setTitleLabelZoomEnabled:",Flag(O1(stock,"objectForKey:",Text("zoom")),"boolValue"));
    VB(model,"setSelectedAnimationEnabled:",Flag(O1(stock,"objectForKey:",Text("animation")),"boolValue"));
    VB(model,"setTitleLabelStrokeWidthEnabled:",Flag(O1(stock,"objectForKey:",Text("stroke")),"boolValue"));
    ShelfSetModelDouble(model,"titleLabelNormalZoomScale","setTitleLabelNormalZoomScale:",Double(O1(stock,"objectForKey:",Text("normal"))));
    ShelfSetModelDouble(model,"titleLabelSelectedZoomScale","setTitleLabelSelectedZoomScale:",Double(O1(stock,"objectForKey:",Text("selected"))));
    ShelfSetModelDouble(model,"titleLabelCurrentZoomScale","setTitleLabelCurrentZoomScale:",
        Double(O1(stock,"objectForKey:",Text(Flag(model,"isSelected") ? "selected" : "normal"))));
    ShelfSetModelDouble(model,"titleLabelVerticalOffset","setTitleLabelVerticalOffset:",Double(O1(stock,"objectForKey:",Text("vertical"))));
    ShelfSetModelDouble(model,"titleLabelZoomSelectedVerticalOffset","setTitleLabelZoomSelectedVerticalOffset:",Double(O1(stock,"objectForKey:",Text("selectedVertical"))));
    Q1(model,"setTitleLabelAnchorPointStyle:",(I)Double(O1(stock,"objectForKey:",Text("anchor"))));
    V1(model,"setTitleSelectedFont:",O1(stock,"objectForKey:",Text("font")));
    objc_setAssociatedObject(model,ShelfTabModelStockKey,0,1);
}
static void ShelfPrepareTabModel(Obj model) {
    if (!Kind(model,"SSBookShelfTabSelectViewTitleCellModel") ||
        !InstanceABI(model,"setTitleLabelAnchorPointStyle:","v24@0:8Q16")) return;
    if (!Enabled() || !FQHGlassAvailable()) { ShelfRestoreTabModel(model); return; }
    Obj stock=objc_getAssociatedObject(model,ShelfTabModelStockKey);
    if (!stock) {
        stock=O0(Lookup("NSMutableDictionary"),"dictionary");
        Put(stock,"zoom",BoolBox(Flag(model,"isTitleLabelZoomEnabled")));
        Put(stock,"animation",BoolBox(Flag(model,"isSelectedAnimationEnabled")));
        Put(stock,"stroke",BoolBox(Flag(model,"isTitleLabelStrokeWidthEnabled")));
        Put(stock,"normal",Number(ShelfModelDouble(model,"titleLabelNormalZoomScale")));
        Put(stock,"selected",Number(ShelfModelDouble(model,"titleLabelSelectedZoomScale")));
        Put(stock,"vertical",Number(ShelfModelDouble(model,"titleLabelVerticalOffset")));
        Put(stock,"selectedVertical",Number(ShelfModelDouble(model,"titleLabelZoomSelectedVerticalOffset")));
        Put(stock,"anchor",Number(((U(*)(Obj,Sel))Message)(model,sel_registerName("titleLabelAnchorPointStyle"))));
        Obj font=Get(model,"titleSelectedFont");
        if (font) Put(stock,"font",font);
        objc_setAssociatedObject(model,ShelfTabModelStockKey,stock,1);
    }
    // Verified in the host's updateLabelWithModel:/updateLayoutWithModel:.
    // Disable at the model boundary before it builds zoom blocks or constraints.
    VB(model,"setTitleLabelZoomEnabled:",0);
    VB(model,"setSelectedAnimationEnabled:",0);
    VB(model,"setTitleLabelStrokeWidthEnabled:",0);
    ShelfSetModelDouble(model,"titleLabelNormalZoomScale","setTitleLabelNormalZoomScale:",1);
    ShelfSetModelDouble(model,"titleLabelCurrentZoomScale","setTitleLabelCurrentZoomScale:",1);
    ShelfSetModelDouble(model,"titleLabelSelectedZoomScale","setTitleLabelSelectedZoomScale:",1);
    ShelfSetModelDouble(model,"titleLabelVerticalOffset","setTitleLabelVerticalOffset:",0);
    ShelfSetModelDouble(model,"titleLabelZoomSelectedVerticalOffset","setTitleLabelZoomSelectedVerticalOffset:",0);
    // Anchor styles 1/2 divide by selectedScale-normalScale. Center mode avoids
    // that zero denominator and gives both labels the same native constraints.
    Q1(model,"setTitleLabelAnchorPointStyle:",0);
    Obj font=Get(model,"titleFont");
    if (font && Get(model,"titleSelectedFont")!=font) V1(model,"setTitleSelectedFont:",font);
}
static void ShelfResetLabelZoom(Obj label) {
    if (!Kind(label,"UILabel")) return;
    typedef struct { double a,b,c,d,tx,ty; } Transform;
    volatile Transform transform=((Transform(*)(Obj,Sel))Message)(label,sel_registerName("transform"));
    if (transform.a!=1 || transform.b!=0 || transform.c!=0 || transform.d!=1 || transform.tx!=0 || transform.ty!=0) {
        transform.a=1; transform.b=0; transform.c=0;
        transform.d=1; transform.tx=0; transform.ty=0;
        ((void(*)(Obj,Sel,Transform))Message)(label,sel_registerName("setTransform:"),transform);
    }
}
static void ShelfTabStyle(Obj view,Obj model,B selected) {
    (void)selected;
    Rect bounds=Bounds(view), material=bounds;
    // The host widths follow the title's zoom. Spend only the available gap
    // on padding so a capsule cannot run into the next tab during a swipe.
    double spacing=InstanceABI(model,"cellSpacing","d16@0:8") ?
        ((double(*)(Obj,Sel))Message)(model,sel_registerName("cellSpacing")) : 0;
    double room=bounds.width+(spacing>6 ? spacing-6 : 0);
    material.width=__builtin_fmin(room,46);
    material.height=__builtin_fmin(bounds.height-2,30);
    material.x+=(bounds.width-material.width)*0.5;
    material.y+=(bounds.height-material.height)*0.5;
    ApplySurface(view,material,0);
    Obj surface=FQHSurface(view);
    if (surface && objc_getAssociatedObject(model,ShelfTabModelStockKey)) {
        // UIKit commits the constraints rebuilt by the host on the inner title
        // container. Resolve them before positioning both visible label layers.
        Obj container=Get(view,"titleContainerView");
        if (Get(container,"superview")==view) V0(container,"layoutIfNeeded");
        // The host's non-zoom font branch leaves a previous transform intact.
        ShelfResetLabelZoom(Get(view,"titleLabel"));
        ShelfResetLabelZoom(Get(view,"maskTitleLabel"));
    }
    Rect caption={material.x+4,material.y,material.width-8,material.height};
    // Their native mask layers track the original label bounds during swipes.
    CenterCaption(Get(view,"titleLabel"),view,caption,surface!=0,0);
    CenterCaption(Get(view,"maskTitleLabel"),view,caption,surface!=0,0);
}
static void PageShelfTabLayout(Obj self,Sel cmd) {
    ShelfPrepareTabModel(Get(self,"cellModel"));
    ((void(*)(Obj,Sel))Original("SSBookShelfTabSelectViewTitleCell","fqx174_originalShelfCategory"))(self,cmd);
    Obj model=Get(self,"cellModel");
    ShelfTabStyle(self,model,BoolProp(model,"isSelected"));
}
static void PageShelfTabWillDisplay(Obj self,Sel cmd,Obj collection,Obj cell,Obj index) {
    const char *name="SSBookShelfTabSelectView";
    ((void(*)(Obj,Sel,Obj,Obj,Obj))Original(name,"fqx_originalShelfWillDisplay:cell:index:"))(self,cmd,collection,cell,index);
    if (!Enabled() || !FQHGlassAvailable() || Get(self,"collectionView")!=collection ||
        !Kind(cell,"SSBookShelfTabSelectViewTitleCell")) return;
    V0(cell,"layoutIfNeeded");
    Obj model=Get(cell,"cellModel");
    ShelfTabStyle(cell,model,BoolProp(model,"isSelected"));
}
static void InstallShelfTabWillDisplay(void) {
    Obj cls=Lookup("SSBookShelfTabSelectView");
    const char *selector="collectionView:willDisplayCell:forItemAtIndexPath:",*type="v40@0:8@16@24@32";
    Sel entry=sel_registerName(selector),alias=sel_registerName("fqx_originalShelfWillDisplay:cell:index:");
    if (!ClassABI(cls,selector,type) || class_getInstanceMethod(cls,alias)) return;
    Method original=class_getInstanceMethod(cls,entry);
    if (class_addMethod(cls,alias,method_getImplementation(original),type))
        class_addMethod(cls,entry,(Imp)PageShelfTabWillDisplay,type);
}
static void PageShelfTabReload(Obj self,Sel cmd,Obj model) {
    ShelfPrepareTabModel(model);
    ((void(*)(Obj,Sel,Obj))Original("SSBookShelfTabSelectViewTitleCell","fqx175_originalShelfTabReload:"))(self,cmd,model);
    ShelfTabStyle(self,model,BoolProp(model,"isSelected"));
}
static void PageShelfTabUpdate(Obj self,Sel cmd,Obj model) {
    const char *alias=cmd==sel_registerName("updateLabelWithModel:") ?
        "fqx178r11_originalShelfLabel:" : "fqx178r11_originalShelfModelLayout:";
    ShelfPrepareTabModel(model);
    ((void(*)(Obj,Sel,Obj))Original("SSBookShelfTabSelectViewTitleCell",alias))(self,cmd,model);
    ShelfTabStyle(self,model,BoolProp(model,"isSelected"));
}
static void PageShelfRefreshModel(Obj self,Sel cmd,Obj model,I index) {
    ShelfRestoreTabModel(model);
    ((void(*)(Obj,Sel,Obj,I))Original("SSBookShelfTabSelectView","fqx178r11_originalShelfModel:index:"))(self,cmd,model,index);
    ShelfPrepareTabModel(model);
}
static double ShelfTabWidth(Obj self,Sel cmd,I index) {
    double width=((double(*)(Obj,Sel,I))Original("SSBookShelfTabSelectView",
        "fqx178r12_originalShelfWidth:"))(self,cmd,index);
    // Let the real collection layout reserve the capsule padding. Otherwise
    // the first 34pt title's 46pt material protrudes 6pt beyond the 20pt grid.
    return Enabled() && FQHGlassAvailable() ? __builtin_fmax(width,46) : width;
}
static void PageShelfSelectedModels(Obj self,Sel cmd,Obj selected,Obj unselected) {
    ((void(*)(Obj,Sel,Obj,Obj))Original("SSBookShelfTabSelectView","fqx178r11_originalShelfSelected:unselected:"))(self,cmd,selected,unselected);
    ShelfPrepareTabModel(selected); ShelfPrepareTabModel(unselected);
}
static void PageShelfScrollingModels(Obj self,Sel cmd,Obj left,Obj right,double ratio) {
    ((void(*)(Obj,Sel,Obj,Obj,double))Original("SSBookShelfTabSelectView","fqx178r11_originalShelfLeft:right:ratio:"))(self,cmd,left,right,ratio);
    ShelfPrepareTabModel(left); ShelfPrepareTabModel(right);
}
static void ShelfFilterStyle(Obj view) {
    if (!HasAncestor(view,"SSBookShelfFilterMixRowCollectionView") ||
        !HasAncestor(view,"SSBookShelfFilterHeaderView")) {
        ShelfMinimumFont(Get(view,"textLabel"),0);
        CenterCaption(Get(view,"textLabel"),0,(Rect){0},0,0);
        PageRestore(view);
        return;
    }
    Rect material=Bounds(view);
    double width=material.width-2,height=__builtin_fmin(material.height-2,30);
    material.x+=(material.width-width)*0.5; material.width=width;
    material.y+=(material.height-height)*0.5; material.height=height;
    ApplySurface(view,material,0);
    Obj arrow=Get(view,"arrowView");
    B plain=!arrow || Flag(arrow,"isHidden");
    Obj caption=Get(view,"textLabel"),text=Get(caption,"text");
    B shortCaption=Equal(text,"全部") || Equal(text,"阅读") || Equal(text,"听书") || Equal(text,"星标");
    ShelfMinimumFont(caption,FQHSurface(view)!=0 && shortCaption);
    CenterCaption(caption,view,
        (Rect){material.x+8,material.y,material.width-16,material.height},FQHSurface(view)!=0 && plain,1);
}
static void PageShelfFilterLayout(Obj self,Sel cmd) {
    ((void(*)(Obj,Sel))Original("SSBookShelfFilter541Cell","fqx175_originalShelfFilterLayout"))(self,cmd);
    ShelfFilterStyle(self);
}
static Obj PageShelfFilterFont(Obj self,Sel cmd,B selected) {
    if (Enabled() && FQHGlassAvailable() && HasAncestor(self,"SSBookShelfFilterMixRowCollectionView") &&
        HasAncestor(self,"SSBookShelfFilterHeaderView")) selected=0;
    return ((Obj(*)(Obj,Sel,B))Original("SSBookShelfFilter541Cell","fqx178r11_originalFilterFont:"))(self,cmd,selected);
}
static void PageShelfFilterAppearance(Obj self,Sel cmd,B selected) {
    ((void(*)(Obj,Sel,B))Original("SSBookShelfFilter541Cell","fqx175_originalShelfFilterAppearance:"))(self,cmd,selected);
    ShelfFilterStyle(self);
}
static void PageShelfFilterBackground(Obj self,Sel cmd,Obj color) {
    ((void(*)(Obj,Sel,Obj))Original("SSBookShelfFilter541Cell","fqx175_originalShelfFilterBackground:"))(self,cmd,color);
    ShelfFilterStyle(self);
}
static void ShelfActionGlass(Obj button,B filter) {
    if (!Kind(button,"UIButton")) return;
    if (Flag(button,"isHidden")) {
        if (filter) ShelfRightEdge(button,0,0);
        ShelfMinimumFont(Get(button,"titleLabel"),0);
        CenterCaption(Get(button,"titleLabel"),0,(Rect){0},0,0);
        PageRestore(button); return;
    }
    Rect material=Bounds(button);
    double height=__builtin_fmin(material.height-2,32);
    double width=material.width-2;
    material.x+=(material.width-width)*0.5; material.width=width;
    material.y+=(material.height-height)*0.5; material.height=height;
    ApplySurface(button,material,0);
    if (filter) ShelfRightEdge(button,FQHSurface(button),Enabled());
    if (!filter) {
        Obj caption=Get(button,"titleLabel");
        ShelfMinimumFont(caption,FQHSurface(button)!=0 && Equal(Get(caption,"text"),"编辑"));
        CenterCaption(caption,button,
            (Rect){material.x+8,material.y,material.width-16,material.height},FQHSurface(button)!=0,1);
    }
}
static void ShelfFilterHiddenKey(void) {}
static void ShelfFilterFadeHiddenKey(void) {}
static void ShelfFilterHeadersKey(void) {}
static Obj ShelfFilterHeaders(void) {
    Obj cls=Lookup("NSHashTable");
    Obj headers=objc_getAssociatedObject(cls,ShelfFilterHeadersKey);
    if (!headers) {
        headers=O0(cls,"weakObjectsHashTable");
        objc_setAssociatedObject(cls,ShelfFilterHeadersKey,headers,1);
    }
    return headers;
}
static void ShelfRememberFilterHeader(Obj header) {
    if (objc_getAssociatedObject(header,ShelfFilterHeadersKey)) return;
    V1(ShelfFilterHeaders(),"addObject:",header);
    objc_setAssociatedObject(header,ShelfFilterHeadersKey,header,0);
}
static void RestoreShelfFilterButton(Obj button) {
    if (!objc_getAssociatedObject(button,ShelfFilterHiddenKey)) return;
    objc_setAssociatedObject(button,ShelfFilterHiddenKey,0,0);
    if (Flag(button,"isHidden")) VB(button,"setHidden:",0);
}
static void ApplyShelfFilterButton(Obj button,B visible) {
    if (!Kind(button,"UIButton")) return;
    if (visible) RestoreShelfFilterButton(button);
    else if (!Flag(button,"isHidden")) {
        objc_setAssociatedObject(button,ShelfFilterHiddenKey,button,0);
        VB(button,"setHidden:",1);
    }
    ShelfActionGlass(button,1);
}
static void ShelfFilterFade(Obj view,B hide) {
    if (!Kind(view,"UIView")) return;
    Obj old=objc_getAssociatedObject(view,ShelfFilterFadeHiddenKey);
    if (hide && !Flag(view,"isHidden")) {
        objc_setAssociatedObject(view,ShelfFilterFadeHiddenKey,view,0);
        VB(view,"setHidden:",1);
    } else if (!hide && old) {
        objc_setAssociatedObject(view,ShelfFilterFadeHiddenKey,0,0);
        VB(view,"setHidden:",0);
    }
}
static B ShelfQuickFilterGrid(Obj row,Obj collection,double *width,double *gap,double *left) {
    if (!Enabled() || !FQHGlassAvailable() || Get(row,"collectionView")!=collection) return 0;
    Obj tab=0;
    for (Obj node=Get(row,"nextResponder");node && !Kind(node,"UIWindow");node=Get(node,"nextResponder")) {
        if (Kind(node,"SSBookShelfSubViewController")) { tab=node; break; }
    }
    Obj owner=Get(tab,"delegate");
    if (!Kind(owner,"SSBookShelf525ViewController") || Get(owner,"currentTabVC")!=tab) return 0;
    Obj upper=Get(Get(owner,"tabSelectView"),"collectionView"),layout=Get(upper,"collectionViewLayout");
    if (!upper || !layout || !Get(collection,"window") || Get(upper,"window")!=Get(collection,"window")) return 0;
    I (*count)(Obj,Sel,I)=(I(*)(Obj,Sel,I))Message;
    Sel sections=sel_registerName("numberOfItemsInSection:");
    if (count(upper,sections,0)!=4 || count(collection,sections,0)!=4) return 0;
    Obj pathClass=Lookup("NSIndexPath");
    Obj (*path)(Obj,Sel,I,I)=(Obj(*)(Obj,Sel,I,I))Message;
    Sel at=sel_registerName("indexPathForItem:inSection:");
    Rect first=Frame(O1(layout,"layoutAttributesForItemAtIndexPath:",path(pathClass,at,0,0)));
    Rect last=Frame(O1(layout,"layoutAttributesForItemAtIndexPath:",path(pathClass,at,3,0)));
    if (!VisibleRect(first) || !VisibleRect(last)) return 0;
    first=Convert(upper,first,collection);
    last=Convert(upper,last,collection);
    double pitch=(last.x+last.width*0.5-first.x-first.width*0.5)/3;
    Rect bounds=Bounds(collection);
    Insets inset=((Insets(*)(Obj,Sel))Message)(collection,sel_registerName("contentInset"));
    *width=first.width+2;
    *gap=pitch-*width;
    *left=first.x-1-bounds.x-inset.left;
    return *left>=0 && *gap>=3 && *left+3*pitch+*width<=bounds.width+1;
}
static Size ShelfQuickFilterSize(Obj self,Sel cmd,Obj collection,Obj layout,Obj index) {
    Size size=((Size(*)(Obj,Sel,Obj,Obj,Obj))Original("SSBookShelfFilterMixRowCollectionView",
        "fqx_originalQuickFilterSize:layout:index:"))(self,cmd,collection,layout,index);
    double width,gap,left;
    if (ShelfQuickFilterGrid(self,collection,&width,&gap,&left)) size.width=width;
    return size;
}
static double ShelfQuickFilterGap(Obj self,Sel cmd,Obj collection,Obj layout,I section) {
    double width,gap,left;
    if (section==0 && ShelfQuickFilterGrid(self,collection,&width,&gap,&left)) return gap;
    if (cmd==sel_registerName("collectionView:layout:minimumLineSpacingForSectionAtIndex:"))
        return ((double(*)(Obj,Sel))Message)(layout,sel_registerName("minimumLineSpacing"));
    return ((double(*)(Obj,Sel,Obj,Obj,I))Original("SSBookShelfFilterMixRowCollectionView",
        "fqx_originalQuickFilterGap:layout:section:"))(self,cmd,collection,layout,section);
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
    if (!Belongs(button,self)) return;
    ShelfRememberFilterHeader(self);
    ApplyShelfFilterButton(button,ShelfFilterVisible());
    B glass=Enabled() && FQHGlassAvailable();
    Obj options=Get(self,"optionsView");
    ShelfFilterFade(Get(self,"gradienttLeftView"),glass);
    ShelfFilterFade(Get(self,"filterGradientView"),glass);
    if (Kind(options,"SSBookShelf541FilterView")) {
        TopChromeFill(options,glass);
        ShelfFilterFade(Get(options,"leftGradientView"),glass);
        ShelfFilterFade(Get(options,"rightGradientView"),glass);
    }
}
static void ShelfFilterHeaderConfigure(Obj self,Sel cmd,Obj model,Obj option) {
    // Genre selection hides the action; option-model refresh shows it again.
    // Preserve whichever native visibility the current configuration requests.
    const char *original=cmd==sel_registerName("configOptionModel:filterOption:") ?
        "fqx192_originalShelfFilterOption:filter:" : "fqx191_originalShelfFilterConfig:order:";
    RestoreShelfFilterButton(Get(self,"filterButton"));
    ((void(*)(Obj,Sel,Obj,Obj))Original("SSBookShelfFilterHeaderView",original))(self,cmd,model,option);
    Obj button=Get(self,"filterButton");
    if (Belongs(button,self)) {
        ShelfRememberFilterHeader(self);
        ApplyShelfFilterButton(button,ShelfFilterVisible());
    }
}
static Insets ShelfInlineFilterInsets(Obj self,Sel cmd,Obj collection,Obj layout,I section) {
    Insets insets=((Insets(*)(Obj,Sel,Obj,Obj,I))Original("SSBookShelfFilterMixRowCollectionView",
        "fqx185_originalInlineFilterInsets:layout:section:"))(self,cmd,collection,layout,section);
    double width,gap,left;
    if (section==0 && ShelfQuickFilterGrid(self,collection,&width,&gap,&left)) {
        insets.left=left;
    } else {
        Obj header=Get(self,"superview");
        if (Enabled() && Kind(header,"SSBookShelfFilterHeaderView") && Get(header,"optionsView")==self)
            insets.left-=1;
    }
    return insets;
}
static void ProfileScanKey(void) {}
static void ProfileNightKey(void) {}
static void ProfileMenuKey(void) {}
static void ProfileAnchorKey(void) {}
static void PublishOwnerKey(void) {}
static void PublishBackingKey(void) {}
static void PublishColorKey(void) {}
static void PublishGradient(Obj layer,B styled) {
    if (!Kind(layer,"CAGradientLayer")) return;
    Obj colors=Get(layer,"colors"),stock=objc_getAssociatedObject(layer,PublishBackingKey);
    if (styled && colors) {
        objc_setAssociatedObject(layer,PublishBackingKey,colors,1);
        V1(layer,"setColors:",0);
    } else if (!styled && stock) {
        if (!colors) V1(layer,"setColors:",stock);
        objc_setAssociatedObject(layer,PublishBackingKey,0,1);
    }
}
static void PublishBacking(Obj view,B styled) {
    if (!view) return;
    Obj owned=objc_getAssociatedObject(view,PublishBackingKey);
    B hidden=Flag(view,"isHidden");
    if (styled && !hidden) {
        if (!owned) objc_setAssociatedObject(view,PublishBackingKey,BoolBox(1),1);
        VB(view,"setHidden:",1);
    } else if (!styled && owned) {
        if (hidden) VB(view,"setHidden:",0);
        objc_setAssociatedObject(view,PublishBackingKey,0,1);
    }
}
static void PublishForeground(Obj view,Obj owner,B styled) {
    if (!view || !Belongs(view,owner)) return;
    B label=Kind(view,"UILabel");
    const char *setter=label ? "setTextColor:" : "setTintColor:";
    Obj current=Get(view,label ? "textColor" : "tintColor");
    Obj foreground=O0(Lookup("UIColor"),"labelColor");
    Obj stock=objc_getAssociatedObject(view,PublishColorKey);
    if (styled && current && !SameColor(current,foreground)) {
        objc_setAssociatedObject(view,PublishColorKey,current,1);
        V1(view,setter,foreground);
    } else if (!styled && stock) {
        if (SameColor(current,foreground)) V1(view,setter,stock);
        objc_setAssociatedObject(view,PublishColorKey,0,1);
    }
}
static const char *PublishClass(Obj view) {
    return Kind(view,"SSDoubleRowUgcProduceEntranceView")
        ? "SSDoubleRowUgcProduceEntranceView" : "SSCommunityPublishButton";
}
static void PublishGlass(Obj view) {
    if (!objc_getAssociatedObject(view,PublishOwnerKey)) return;
    B alternate=Kind(view,"SSDoubleRowUgcProduceEntranceView");
    Obj owner=alternate ? Get(view,"entranceView") : view;
    if (!Kind(owner,"UIView") || !Belongs(owner,view)) return;
    FQHApply(owner);
    B styled=FQHSurface(owner)!=0;
    if (alternate) {
        PublishGradient(Get(view,"entranceBgLayer"),styled);
        PublishForeground(Get(view,"publishIcon"),owner,styled);
        PublishForeground(Get(view,"closeIcon"),owner,styled);
    } else {
        // This gradient is the button's own backing layer. Its sublayers
        // include the quill and glass, so only remove the gradient paint.
        PublishGradient(Get(view,"gradientLayer"),styled);
        if (BoolProp(Get(view,"model"),"backgroundStyleOptV697")) {
            Obj background=Get(view,"publishImageBackgroundView");
            if (Get(background,"superview")==owner) PublishBacking(background,styled);
        }
        Obj mask=Get(view,"darkModeMaskView");
        if (Get(mask,"superview")==owner) PublishBacking(mask,styled);
        PublishForeground(Get(view,"publishImageView"),owner,styled);
        PublishForeground(Get(view,"publishTintLabel"),owner,styled);
    }
}
static void PublishLayout(Obj self,Sel cmd) {
    ((void(*)(Obj,Sel))Original(PublishClass(self),"fqx188_originalPublishLayout"))(self,cmd);
    PublishGlass(self);
}
static void PublishTheme(Obj self,Sel cmd,Obj previous) {
    ((void(*)(Obj,Sel,Obj))Original(PublishClass(self),"fqx188_originalPublishTheme:"))(self,cmd,previous);
    PublishGlass(self);
}
static void PublishMark(Obj view) {
    if (!Kind(view,"SSCommunityPublishButton") && !Kind(view,"SSDoubleRowUgcProduceEntranceView")) return;
    if (!objc_getAssociatedObject(view,PublishOwnerKey))
        objc_setAssociatedObject(view,PublishOwnerKey,BoolBox(1),1);
    PublishGlass(view);
}
static void BookstorePublishButton(Obj self,Sel cmd,Obj button) {
    ((void(*)(Obj,Sel,Obj))Original("SSBookStoreNestedTabView","fqx188_originalStorePublishButton:"))(self,cmd,button);
    PublishMark(button);
}
static void BookstoreProduceEntrance(Obj self,Sel cmd,Obj view) {
    ((void(*)(Obj,Sel,Obj))Original("SSBookStoreNestedTabView","fqx189_originalStoreProduceEntrance:"))(self,cmd,view);
    PublishMark(view);
}
static void BookstoreComponentPublishButton(Obj self,Sel cmd,Obj button) {
    ((void(*)(Obj,Sel,Obj))Original("SSBookStoreCommunityPublishEntranceComponent","fqx188_originalStoreComponentPublish:"))(self,cmd,button);
    PublishMark(button);
}
static Obj ProfilePublishButton(Obj self,Sel cmd) {
    Obj button=((Obj(*)(Obj,Sel))Original("SSMyUser621ViewController","fqx188_originalMinePublishButton"))(self,cmd);
    PublishMark(button);
    return button;
}
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
    Obj scan=Get(self,"scanQRCodeView"),night=Get(self,"darkModeImageView"),search=Get(self,"searchBgView");
    B showScan=DefaultEnabled(Text("FanqieX.MineScanButton.1"));
    B showSearch=DefaultEnabled(Text("FanqieX.MineSearchBar.1"));
    B showNight=DefaultEnabled(Text("FanqieX.MineNightButton.1"));
    DramaVisibilitySet(scan,showScan);
    DramaVisibilitySet(night,showNight);
    DramaVisibilitySet(search,showSearch);
    if (Responds(self,"searchButtonView")) DramaVisibilitySet(Get(self,"searchButtonView"),showSearch);
    if (Responds(self,"searchView")) DramaVisibilitySet(Get(self,"searchView"),showSearch);
    if (Responds(self,"carouseView")) DramaVisibilitySet(Get(self,"carouseView"),showSearch);
    // Both native carousel variants place their outgoing and incoming labels
    // inside searchBgView. Keep the animated words clipped to that pill.
    if (!showSearch || Flag(search,"isHidden")) PageRestore(search);
    else FQHHeader(search);
    B enabled=Enabled() && FQHGlassAvailable();
    ProfileIconGlass(self,enabled && showScan ? scan : (Obj)0,ProfileScanKey);
    ProfileIconGlass(self,enabled && showNight ? night : (Obj)0,ProfileNightKey);
    ProfileIconGlass(self,enabled ? Get(self,"sideBarButtonView") : (Obj)0,ProfileMenuKey);
}
static void ProfileRestingTint(Obj controller,Obj scroll) {
    Obj root=Get(controller,"view"),surface=objc_getAssociatedObject(root,TopChromeSurfaceKey);
    Obj content=Get(surface,"contentView");
    if (!content || !scroll) return;
    Point offset=((Point(*)(Obj,Sel))Message)(scroll,sel_registerName("contentOffset"));
    Rect inset=((Rect(*)(Obj,Sel))Message)(scroll,sel_registerName("adjustedContentInset"));
    double distance=__builtin_fabs(offset.y+inset.x);
    double blend=distance<24 ? 1-distance/24 : 0;
    Obj tint=objc_getAssociatedObject(surface,TopChromeTintKey);
    if (blend>0) {
        Obj canvas=Get(root,"backgroundColor"),colors=Lookup("UIColor");
        if (!canvas || SameColor(canvas,O0(colors,"clearColor"))) canvas=O0(colors,"systemBackgroundColor");
        tint=blend==1 ? canvas : ((Obj(*)(Obj,Sel,double))Message)(canvas,
            sel_registerName("colorWithAlphaComponent:"),0.0625+0.9375*blend);
    }
    if (!SameColor(Get(content,"backgroundColor"),tint)) V1(content,"setBackgroundColor:",tint);
}
static void ProfileScroll(Obj self,Sel cmd,Obj scroll) {
    ((void(*)(Obj,Sel,Obj))Original("SSMyUser621ViewController","fqx178r9_originalProfileScroll:"))(self,cmd,scroll);
    if (scroll==Get(self,"collectionView")) ProfileRestingTint(self,scroll);
}
static void ProfileCollectionLayout(Obj self,Sel cmd) {
    ((void(*)(Obj,Sel))Original("SSMyUser621BaseViewController","fqx186_originalProfileCollectionLayout"))(self,cmd);
    if (!Kind(self,"SSMyUser621ViewController")) return;
    Obj sidebar=Get(self,"sidebarAdapter");
    if (BoolProp(sidebar,"isSidebarOpen") || BoolProp(sidebar,"isSidebarTransitioning")) return;
    Obj root=Get(self,"view"), bar=Get(self,"myUserBar"), list=Get(self,"collectionView");
    if (!Kind(root,"UIView") || !Kind(bar,"SSMyUserBar") || !Kind(list,"FQFeedListCollectionView")) return;
    Rect material=Bounds(root), barFrame=Frame(bar);
    material.height=barFrame.y+barFrame.height-material.y;
    B enabled=Enabled() && Get(list,"superview")==root && !Flag(bar,"isHidden");
    B installed=TopChromePage(root,bar,bar,list,material,enabled);
    TopChromeFill(bar,installed);
    TopChromeUnderlap(list,list,material.y,installed);
    if (installed) ProfileRestingTint(self,list);
    TopChromeDiagnostics(self,"profile",root,list,list,installed);
}
static void ProfileCaptionKey(void) {}
static void ProfileCaptionColorKey(void) {}
static void ProfileShortcutOwnersKey(void) {}
static Obj ProfileShortcutOwners(void) {
    Obj defaults=O0(Lookup("NSUserDefaults"),"standardUserDefaults");
    Obj owners=objc_getAssociatedObject(defaults,ProfileShortcutOwnersKey);
    if (!owners) {
        owners=O0(Lookup("NSHashTable"),"weakObjectsHashTable");
        objc_setAssociatedObject(defaults,ProfileShortcutOwnersKey,owners,1);
    }
    return owners;
}
void FQHRefreshMineQuickAppearance178R13(void) {
    Obj owners=O0(ProfileShortcutOwners(),"allObjects");
    U count=((U(*)(Obj,Sel))Message)(owners,sel_registerName("count"));
    for (U i=0;i<count;++i) V0(At(owners,i),"setNeedsLayout");
}
static void ProfileCaptionInk(Obj label,B iconsOnly) {
    // Transparent ink leaves the title available to the native accessibility tree.
    Obj original=objc_getAssociatedObject(label,ProfileCaptionColorKey);
    Obj current=O0(label,"textColor"),clear=O0(Lookup("UIColor"),"clearColor");
    if (iconsOnly) {
        if (SameColor(current,clear)) return;
        objc_setAssociatedObject(label,ProfileCaptionColorKey,current,1);
        V1(label,"setTextColor:",clear);
    } else if (original) {
        if (SameColor(current,clear)) V1(label,"setTextColor:",original);
        objc_setAssociatedObject(label,ProfileCaptionColorKey,0,1);
    }
}
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
    if (key==ProfileCaptionKey) {
        ProfileCaptionInk(view,0);
        CenterCaption(view,0,(Rect){0},0,0);
    }
    Rect current=Frame(view),stock=ProfileStockFrame(view,current);
    if (!SameRect(current,stock)) SetFrame(view,stock);
    objc_setAssociatedObject(view,GlyphOriginalKey,0,1);
    objc_setAssociatedObject(view,GlyphAppliedKey,0,1);
    objc_setAssociatedObject(content,key,0,1);
}
static void ProfileCardClearKey(void) {}
static void ProfileCardSavedBgKey(void) {}
static void ProfileCardTrackedKey(void) {}
static void ProfileCardClipsKey(void) {}
static void ProfileCardSetUnclipped(Obj view,B unclip) {
    if (!view) return;
    Obj saved=objc_getAssociatedObject(view,ProfileCardClipsKey);
    if (unclip) {
        if (Flag(view,"clipsToBounds")) {
            objc_setAssociatedObject(view,ProfileCardClipsKey,BoolBox(1),1);
            VB(view,"setClipsToBounds:",0);
        }
    } else if (saved) {
        if (!Flag(view,"clipsToBounds")) VB(view,"setClipsToBounds:",Flag(saved,"boolValue"));
        objc_setAssociatedObject(view,ProfileCardClipsKey,0,1);
    }
}
static Obj ProfileRowAncestor(Obj view) {
    Obj parent=Get(view,"superview");
    for (int depth=0;parent && depth<8;++depth,parent=Get(parent,"superview"))
        if (Kind(parent,"SSMyUserShortcutCell") ||
            (Kind(parent,"SSMyUserCollectionView1Cell") && !Responds(parent,"lynxVipView")))
            return parent;
    return 0;
}
static void ProfileCardSetPaint(Obj view,B clear) {
    if (!view) return;
    Obj current=Get(view,"backgroundColor");
    Obj transparent=O0(Lookup("UIColor"),"clearColor");
    Obj saved=objc_getAssociatedObject(view,ProfileCardSavedBgKey);
    if (clear) {
        if (current && !SameColor(current,transparent)) {
            objc_setAssociatedObject(view,ProfileCardSavedBgKey,current,1);
            objc_setAssociatedObject(view,ProfileCardClearKey,transparent,1);
            V1(view,"setBackgroundColor:",transparent);
        }
    } else if (objc_getAssociatedObject(view,ProfileCardClearKey)) {
        Obj applied=objc_getAssociatedObject(view,ProfileCardClearKey);
        if (saved && SameColor(current,applied)) V1(view,"setBackgroundColor:",saved);
        objc_setAssociatedObject(view,ProfileCardSavedBgKey,0,1);
        objc_setAssociatedObject(view,ProfileCardClearKey,0,1);
    }
}
static void ProfileCardTrackClear(Obj host,Obj view) {
    if (!view) return;
    ProfileCardSetPaint(view,1);
    if (!objc_getAssociatedObject(view,ProfileCardClearKey)) return;
    Obj tracked=objc_getAssociatedObject(host,ProfileCardTrackedKey);
    if (!tracked) {
        tracked=O0(Lookup("NSHashTable"),"weakObjectsHashTable");
        objc_setAssociatedObject(host,ProfileCardTrackedKey,tracked,1);
    }
    V1(tracked,"addObject:",view);
}
static void ProfileCardRestorePaints(Obj host) {
    Obj sub=Get(host,"subviews");
    for (U i=0,n=TabCount(sub);i<n;++i) ProfileCardSetUnclipped(At(sub,i),0);
    Obj tracked=objc_getAssociatedObject(host,ProfileCardTrackedKey);
    if (!tracked) return;
    Obj all=O0(tracked,"allObjects");
    for (U i=0,n=TabCount(all);i<n;++i) ProfileCardSetPaint(At(all,i),0);
    objc_setAssociatedObject(host,ProfileCardTrackedKey,0,1);
}
static void ApplyMaxCapsuleStyle(Obj surface,Obj existing,double radius) {
    if (!surface || surface==existing) return;
    Obj cfgCls=Lookup("UICornerConfiguration");
    if (Responds(cfgCls,"capsuleConfigurationWithMaximumRadius:")) {
        Obj cfg=((Obj(*)(Obj,Sel,double))Message)(cfgCls,sel_registerName("capsuleConfigurationWithMaximumRadius:"),radius);
        if (cfg) V1(surface,"setCornerConfiguration:",cfg);
    }
    Q1(surface,"setOverrideUserInterfaceStyle:",0);
}
static void ProfileShortcutExtendForIndicator(Rect *bestCard,Rect b,Obj view,Obj owner,Obj host) {
    if ((!Kind(view,"UIPageControl") && !Kind(view,"FQReaderSaaSBookStoreSelectView")) ||
        Flag(view,"isHidden")) return;
    Rect r=owner==host ? Frame(view) : Convert(owner,Frame(view),host);
    if (VisibleRect(r) && r.x>=bestCard->x-2 && r.x+r.width<=bestCard->x+bestCard->width+2 &&
        r.y>=bestCard->y && r.y+r.height<=b.height+2) {
        double bottom=__builtin_fmax(bestCard->y+bestCard->height,r.y+r.height);
        bestCard->height=__builtin_fmin(b.height-bestCard->y,bottom-bestCard->y);
    }
}
static B ProfileCardPlainBox(Obj v) {
    return Kind(v,"UIView") && !Flag(v,"isHidden") && !Kind(v,"UILabel") &&
           !Kind(v,"UIImageView") && !Kind(v,"UIControl") && !Kind(v,"SSMyUserCollectionViewFunCell");
}
static void ProfileShortcutCardGlass(Obj row,B mounted) {
    if (!row || !Kind(row,"UIView")) return;
    Obj cv=Get(row,"contentView");
    Obj host=(Kind(cv,"UIView") && Get(cv,"superview")==row) ? cv : row;
    Rect b=Bounds(host);
    if ((Kind(row,"SSMyUserCollectionView1Cell") && Responds(row,"lynxVipView")) ||
        !mounted || !Enabled() || !FQHGlassAvailable() || !VisibleRect(b)) {
        PageRestore(host);
        ProfileCardRestorePaints(host);
        ProfileCardSetUnclipped(row,0);
        if (host!=row) ProfileCardSetUnclipped(host,0);
        return;
    }
    Rect cardFrame=b;
    Obj children=Get(host,"subviews");
    U childCount=TabCount(children);
    Obj existingSurface=FQHSurface(host);
    Rect bestCard={0};
    B foundCard=0;
    for (U i=0;i<childCount;++i) {
        Obj child=At(children,i);
        if (child==existingSurface || !ProfileCardPlainBox(child)) continue;
        Rect r=Frame(child);
        if (VisibleRect(r) && r.width>=b.width*0.5 && r.height*5>=b.height*2 &&
            r.width<b.width-4 && r.x>=4 && r.x+r.width<=b.width-4) {
            if (!foundCard || r.width*r.height>bestCard.width*bestCard.height) {
                bestCard=r; foundCard=1;
            }
        }
    }
    ProfileCardSetUnclipped(row,1);
    if (host!=row) ProfileCardSetUnclipped(host,1);
    if (foundCard) {
        for (U i=0;i<childCount;++i) {
            Obj child=At(children,i);
            if (!Kind(child,"UIView") || Flag(child,"isHidden")) continue;
            ProfileShortcutExtendForIndicator(&bestCard,b,child,host,host);
            Obj grand=Get(child,"subviews");
            for (U j=0,gn=TabCount(grand);j<gn;++j)
                ProfileShortcutExtendForIndicator(&bestCard,b,At(grand,j),child,host);
        }
        cardFrame=bestCard;
    }
    ProfileCardTrackClear(host,row);
    if (host!=row) ProfileCardTrackClear(host,host);
    for (U i=0;i<childCount;++i) {
        Obj child=At(children,i);
        if (child==existingSurface || !ProfileCardPlainBox(child)) continue;
        Rect r=Frame(child);
        if (r.width*5<cardFrame.width*4) continue;
        ProfileCardTrackClear(host,child);
        if (!Kind(child,"UIScrollView") && !Kind(child,"SSScrollFoldFuncView"))
            ProfileCardSetUnclipped(child,1);
        Obj grand=Get(child,"subviews");
        for (U j=0,gn=TabCount(grand);j<gn;++j) {
            Obj gc=At(grand,j);
            if (!ProfileCardPlainBox(gc)) continue;
            Rect gr=Frame(gc);
            if (gr.width*5>=cardFrame.width*4)
                ProfileCardTrackClear(host,gc);
        }
    }
    ApplySurface(host,cardFrame,1);
    ApplyMaxCapsuleStyle(FQHSurface(host),existingSurface,22);
    V1(ProfileShortcutOwners(),"addObject:",row);
}
static void RestoreProfileEntry(Obj content) {
    TrackAppearanceLabel(content,0,0);
    RestoreProfileEntryFrame(content,GlyphViewKey);
    RestoreProfileEntryFrame(content,ProfileCaptionKey);
    RestoreHit(Get(content,"superview"));
    ProfileCardSetPaint(content,0);
    ProfileCardSetPaint(Get(content,"superview"),0);
    ProfileCardSetUnclipped(content,0);
    ProfileCardSetUnclipped(Get(content,"superview"),0);
    PageRestore(content);
}

static void ReaderAudioIndicatorGlass(Obj owner,B mounted) {
    // The host installs its blur inside the cover-colored background view.
    // Both paint layers disappear when that subtree is hidden.
    Obj content=Get(owner,"contentView"),background=Get(owner,"backgroundView");
    Obj blur=Get(owner,"backgroundEffectView");
    if (!Kind(content,"UIView") || Get(content,"superview")!=owner) return;
    B laidOut=mounted && Get(owner,"window") && Kind(background,"UIView") &&
        Get(background,"superview")==content && Kind(blur,"UIVisualEffectView") && Get(blur,"superview")==background;
    Obj previous=FQHSurface(content);
    if (laidOut) ApplySurface(content,Bounds(content),1);
    else PageRestore(content);
    Obj glass=FQHSurface(content);
    if (glass && glass!=previous) {
        V1(glass,"setCornerConfiguration:",O0(Lookup("UICornerConfiguration"),"capsuleConfiguration"));
        // The native playback and dismissal art is white in both reader themes.
        Q1(glass,"setOverrideUserInterfaceStyle:",2);
    }
    if (Get(background,"superview")==content) DramaVisibilitySet(background,!glass);
}

static void ReaderAudioIndicatorLayout(Obj self,Sel cmd) {
    ((void(*)(Obj,Sel))Original("SSAudioPlayIndicatorView","fqx178r13_originalAudioIndicatorLayout"))(self,cmd);
    ReaderAudioIndicatorGlass(self,1);
}

static void ReaderAudioIndicatorMove(Obj self,Sel cmd,Obj parent) {
    if (!parent) ReaderAudioIndicatorGlass(self,0);
    ((void(*)(Obj,Sel,Obj))Original("SSAudioPlayIndicatorView","fqx178r13_originalAudioIndicatorMove:"))(self,cmd,parent);
}

static void ProfileEntryGlass(Obj self,B order) {
    Obj content=Get(self,"contentView");
    if (!content) return;
    RestoreHit(self);
    Obj row=ProfileRowAncestor(self);
    Obj glyph=row && Enabled() && FQHGlassAvailable() ? Get(self,order ? "productImage" : "image") : (Obj)0;
    Obj caption=glyph ? Get(self,order ? "functionType" : "label") : (Obj)0;
    if (!Kind(glyph,"UIImageView") || Get(glyph,"superview")!=content || Flag(glyph,"isHidden") ||
        !Kind(caption,"UILabel") || Get(caption,"superview")!=content) {
        RestoreProfileEntry(content);
        if (row && (!Enabled() || !FQHGlassAvailable())) ProfileShortcutCardGlass(row,0);
        return;
    }
    Obj oldGlyph=objc_getAssociatedObject(content,GlyphViewKey);
    Obj oldCaption=objc_getAssociatedObject(content,ProfileCaptionKey);
    if (oldGlyph!=glyph) RestoreProfileEntryFrame(content,GlyphViewKey);
    if (oldCaption!=caption) RestoreProfileEntryFrame(content,ProfileCaptionKey);
    Rect b=Bounds(content),labelFrame=Frame(caption),iconFrame=Frame(glyph);
    Rect label=ProfileStockFrame(caption,labelFrame),icon=ProfileStockFrame(glyph,iconFrame);
    Obj defaults=O0(Lookup("NSUserDefaults"),"standardUserDefaults");
    B iconsOnly=BoolProp(O1(defaults,"objectForKey:",Text("FanqieX.MineQuickIconsOnly.1")),"boolValue");
    double pillSide=__builtin_fmin(50,__builtin_fmin(b.width-8,b.height-8));
    double centerY=b.y+b.height*0.5;
    for (Obj parent=Get(self,"superview");parent && parent!=row;parent=Get(parent,"superview")) {
        if (!Kind(parent,"UIScrollView") && !Kind(parent,"SSScrollFoldFuncView")) continue;
        Rect clip=Convert(parent,Bounds(parent),content);
        double top=__builtin_fmax(b.y,clip.y)+3;
        double bottom=__builtin_fmin(b.y+b.height,clip.y+clip.height)-3;
        if (!VisibleRect(clip) || bottom-top<36) continue;
        pillSide=__builtin_fmin(pillSide,bottom-top);
        centerY=__builtin_fmax(top+pillSide*0.5,__builtin_fmin(bottom-pillSide*0.5,centerY));
    }
    double captionHeight=18,gap=3;
    double glyphHeight=iconsOnly ? __builtin_fmin(24,pillSide-14) : __builtin_fmin(21,pillSide-23);
    if (!VisibleRect(b) || glyphHeight<12 || pillSide<36 ||
        !VisibleRect(icon) || !VisibleRect(label)) {
        RestoreProfileEntry(content);
        return;
    }
    ProfileCardSetPaint(self,1);
    ProfileCardSetPaint(content,1);
    ProfileCardSetUnclipped(self,1);
    ProfileCardSetUnclipped(content,1);
    ProfileShortcutCardGlass(row,1);
    Rect pillRect={b.x+(b.width-pillSide)*0.5,centerY-pillSide*0.5,pillSide,pillSide};
    Obj existingItem=FQHSurface(content);
    ApplySurface(content,pillRect,1);
    ApplyMaxCapsuleStyle(FQHSurface(content),existingItem,25);
    V1(ProfileShortcutOwners(),"addObject:",self);
    TrackAppearanceLabel(content,caption,13);
    ProfileCaptionInk(caption,iconsOnly);
    double scale=__builtin_fmin(1.3,glyphHeight/__builtin_fmax(icon.width,icon.height));
    double w=icon.width*scale,h=icon.height*scale;
    double top=pillRect.y+(pillRect.height-h-(iconsOnly ? 0 : gap+captionHeight))*0.5;
    Rect adjusted={b.x+(b.width-w)*0.5,top,w,h};
    if (oldGlyph!=glyph) objc_setAssociatedObject(content,GlyphViewKey,glyph,1);
    if (oldCaption!=caption) objc_setAssociatedObject(content,ProfileCaptionKey,caption,1);
    ProfileSetFrame(glyph,iconFrame,icon,adjusted);
    double textWidth=__builtin_fmin(58,pillRect.width-4);
    CenterCaption(caption,content,(Rect){b.x+(b.width-textWidth)*0.5,top+h+gap,textWidth,captionHeight},!iconsOnly,1);
}
static void ProfileShortcutCardLayout(Obj self,Sel cmd) {
    ((void(*)(Obj,Sel))Original("SSMyUserShortcutCell","fqx179r1_originalShortcutCardLayout"))(self,cmd);
    ProfileShortcutCardGlass(self,1);
}
static void ProfileShortcutCardMove(Obj self,Sel cmd,Obj parent) {
    if (!parent) ProfileShortcutCardGlass(self,0);
    ((void(*)(Obj,Sel,Obj))Original("SSMyUserShortcutCell","fqx179r1_originalShortcutCardMove:"))(self,cmd,parent);
}
static void ProfileCard1Layout(Obj self,Sel cmd) {
    ((void(*)(Obj,Sel))Original("SSMyUserCollectionView1Cell","fqx179r1_originalCard1Layout"))(self,cmd);
    ProfileShortcutCardGlass(self,1);
}
static void ProfileCard1Move(Obj self,Sel cmd,Obj parent) {
    if (!parent) ProfileShortcutCardGlass(self,0);
    ((void(*)(Obj,Sel,Obj))Original("SSMyUserCollectionView1Cell","fqx179r1_originalCard1Move:"))(self,cmd,parent);
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
    if (!FQDDiagnosticsEnabled()) return;
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
static B MineRecommendationsEnabled(void);
static void MineControllersKey(void) {}
static void RefreshMineList(const char *reason) {
    if (!Signature("SSMyUser621ViewController","reloadData:","v24@0:8@16")) return;
    Obj controllers=O0(objc_getAssociatedObject(Lookup("SSMyUser621ViewController"),MineControllersKey),"allObjects");
    U count=((U(*)(Obj,Sel))Message)(controllers,sel_registerName("count"));
    Obj context=Text(reason);
    for (U i=0;i<count;++i) V1(At(controllers,i),"reloadData:",context);
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
    B hideBenefits=!MineBenefitsEnabled(),hideRecommendations=!MineRecommendationsEnabled();
    B hideShortcut=!DefaultEnabled(Text("FanqieX.MineShortcutCard.1")),removedGame=0;
    U count=((U(*)(Obj,Sel))Message)(rows,sel_registerName("count"));
    for (U i=count;i>0;--i) {
        Obj row=At(rows,i-1);
        B game=MineStandaloneGameRow(row);
        // The entire recommendation waterfall is one native list section.
        B recommendation=hideRecommendations && Kind(row,"SSMyUserUnlimitedCellModel");
        B shortcut=hideShortcut && Kind(row,"SSMyUserShortcutCellModel");
        if (!game && !recommendation && !shortcut && !(hideBenefits && MineBenefitsRow(row))) continue;
        removedGame|=game;
        if (!filtered) filtered=O0(O0(rows,"mutableCopy"),"autorelease");
        Q1(filtered,"removeObjectAtIndex:",i-1);
    }
    if (removedGame) RecordMineGameRemoval("SSMyUser621ViewController","filterStandaloneGameRows");
    return filtered ? filtered : rows;
}

// 1.78R9 presentation-only switches. Keep native data/model arrays untouched.
static void FeatureVisibilityOwners178R9Key(void) {}
static void ReaderEarnInsertObjects178R9Key(void) {}
static void ShelfMotionComicSource178R9Key(void) {}
static void ShelfMotionComicPendingKey(void) {}
static Obj FeatureVisibilityOwners178R9(void) {
    Obj cls=Lookup("NSUserDefaults");
    Obj owners=objc_getAssociatedObject(cls,FeatureVisibilityOwners178R9Key);
    if (!owners) {
        owners=O0(Lookup("NSHashTable"),"weakObjectsHashTable");
        objc_setAssociatedObject(cls,FeatureVisibilityOwners178R9Key,owners,1);
    }
    return owners;
}
static void FeatureVisibilityTrack178R9(Obj owner) {
    V1(FeatureVisibilityOwners178R9(),"addObject:",owner);
}
static B MineContinueVisible178R9(Obj self,Sel cmd) {
    B visible=((B(*)(Obj,Sel))Original("SSMyUserExposedHistoryCellModel",
        "fqx178R9_originalShouldShowHistory"))(self,cmd);
    return visible && DefaultEnabled(Text("FanqieX.MineContinueDrama.1"));
}
static void MineContinueLayout178R9(Obj self,Sel cmd) {
    ((void(*)(Obj,Sel))Original("SSMyUser627HistoryExposeView","fqx178R9_originalHistoryLayout"))(self,cmd);
    FeatureVisibilityTrack178R9(self);
    DramaVisibilitySet(self,DefaultEnabled(Text("FanqieX.MineContinueDrama.1")));
}
static Obj ReaderEarnFiltered178R9(Obj objects) {
    if (DefaultEnabled(Text("FanqieX.ReaderEarnMore.1")) || !Kind(objects,"NSArray")) return objects;
    Obj filtered=0;
    U count=((U(*)(Obj,Sel))Message)(objects,sel_registerName("count"));
    for (U i=count;i>0;--i) {
        if (!Kind(At(objects,i-1),"SSReaderTopViewCoinBtnInsertObject")) continue;
        if (!filtered) filtered=O0(O0(objects,"mutableCopy"),"autorelease");
        Q1(filtered,"removeObjectAtIndex:",i-1);
    }
    return filtered ? filtered : objects;
}
static void ReaderEarnConfigure178R9(Obj self,Sel cmd,Obj objects) {
    // Capture the unfiltered host input so turning the switch back on can
    // restore this page without deleting or rebuilding the reading reward.
    objc_setAssociatedObject(self,ReaderEarnInsertObjects178R9Key,objects,1);
    FeatureVisibilityTrack178R9(self);
    ((void(*)(Obj,Sel,Obj))Original("FQReaderTopView","fqx178R9_originalInsertObjects:"))
        (self,cmd,ReaderEarnFiltered178R9(objects));
}
static void SidebarGamesLayout178R9(Obj self,Sel cmd) {
    ((void(*)(Obj,Sel))Original("SSMyUser621SideBarGameContainerCell","fqx178R9_originalGamesLayout"))(self,cmd);
    FeatureVisibilityTrack178R9(self);
    DramaVisibilitySet(self,DefaultEnabled(Text("FanqieX.SidebarGames.1")));
}
static double SidebarGamesHeight178R9(Obj self,Sel cmd,Obj models,double width) {
    (void)cmd;
    if (!DefaultEnabled(Text("FanqieX.SidebarGames.1"))) return 0;
    return ((double(*)(Obj,Sel,Obj,double))Message)(self,
        sel_registerName("fqx178R9_originalGamesHeight:containerWidth:"),models,width);
}
static void SidebarGamesReload178R9(Obj self,Sel cmd) {
    FeatureVisibilityTrack178R9(self);
    ((void(*)(Obj,Sel))Original("SSMyUser621SideBarViewController","fqx178R9_originalSidebarReload"))(self,cmd);
}
static Obj ShelfMotionComicFiltered178R9(Obj items) {
    if (DefaultEnabled(Text("FanqieX.ShelfMotionComic.1")) || !Kind(items,"NSArray")) return items;
    Obj filtered=0;
    U count=((U(*)(Obj,Sel))Message)(items,sel_registerName("count"));
    for (U i=count;i>0;--i) {
        Obj item=At(items,i-1),group=Get(item,"groupModel");
        if (!Kind(item,"SSBookShelfCellModel") || !Kind(group,"SSBookGroupModel") ||
            !BoolProp(group,"isFakeMotionComicGroup")) continue;
        if (!filtered) filtered=O0(O0(items,"mutableCopy"),"autorelease");
        Q1(filtered,"removeObjectAtIndex:",i-1);
    }
    return filtered ? filtered : items;
}
static void ShelfMotionComicModels178R9(Obj self,Sel cmd,Obj models) {
    // The host builds section items and tap targets from this display array,
    // while its grid/double-column sizing also reads the same backing ivar.
    // Filter at the setter so all four paths retain identical row indexes.
    // cacheCellModels, group contents and persisted collections stay native.
    objc_setAssociatedObject(self,ShelfMotionComicSource178R9Key,models,1);
    objc_setAssociatedObject(self,ShelfMotionComicPendingKey,0,0);
    FeatureVisibilityTrack178R9(self);
    ((void(*)(Obj,Sel,Obj))Original("SSBookShelfViewModel","fqx178R9_originalShowCellModels:"))
        (self,cmd,ShelfMotionComicFiltered178R9(models));
}
static void ShelfRefreshMotionComicModel(Obj model,Obj controller) {
    objc_setAssociatedObject(model,ShelfMotionComicPendingKey,0,0);
    Obj original=objc_getAssociatedObject(model,ShelfMotionComicSource178R9Key);
    Obj items=ShelfMotionComicFiltered178R9(original),shown=Get(model,"showCellModels");
    if (items==shown || ((B(*)(Obj,Sel,Obj))Message)(items,sel_registerName("isEqual:"),shown)) return;
    ((void(*)(Obj,Sel,Obj))Original("SSBookShelfViewModel","fqx178R9_originalShowCellModels:"))
        (model,sel_registerName("setShowCellModels:"),items);
    if (Kind(controller,"SSBookShelfSubViewController") && InstanceABI(controller,"reloadData:","v24@0:8@16"))
        V1(controller,"reloadData:",Text("FanqieXMotionComicVisibility"));
}
static void ShelfApplyPendingMotionComic(Obj controller) {
    if (!Kind(controller,"SSBookShelfSubViewController")) return;
    Obj model=Get(controller,"viewModel");
    if (objc_getAssociatedObject(model,ShelfMotionComicPendingKey))
        ShelfRefreshMotionComicModel(model,controller);
}
static void FeatureVisibilityRefresh178R9(I tag) {
    Obj owners=O0(FeatureVisibilityOwners178R9(),"allObjects");
    U count=((U(*)(Obj,Sel))Message)(owners,sel_registerName("count"));
    for (U i=0;i<count;++i) {
        Obj owner=At(owners,i);
        if (tag==26 && Kind(owner,"SSMyUser627HistoryExposeView")) {
            DramaVisibilitySet(owner,DefaultEnabled(Text("FanqieX.MineContinueDrama.1")));
            V0(Get(owner,"superview"),"setNeedsLayout");
        } else if (tag==27 && Kind(owner,"FQReaderTopView")) {
            Obj objects=objc_getAssociatedObject(owner,ReaderEarnInsertObjects178R9Key);
            ((void(*)(Obj,Sel,Obj))Original("FQReaderTopView","fqx178R9_originalInsertObjects:"))
                (owner,sel_registerName("configInsertObjs:"),ReaderEarnFiltered178R9(objects));
            V0(owner,"setNeedsLayout");
        } else if (tag==28 && Kind(owner,"SSMyUser621SideBarGameContainerCell")) {
            DramaVisibilitySet(owner,DefaultEnabled(Text("FanqieX.SidebarGames.1")));
        } else if (tag==28 && Kind(owner,"SSMyUser621SideBarViewController")) {
            V0(Get(Get(owner,"collectionView"),"collectionViewLayout"),"invalidateLayout");
            V0(Get(owner,"collectionView"),"reloadData");
        } else if (tag==29 && Kind(owner,"SSBookShelfViewModel")) {
            Obj controller=Get(owner,"delegate");
            Obj shelf=Get(controller,"delegate");
            if (Kind(shelf,"SSBookShelf525ViewController") && Get(shelf,"currentTabVC")!=controller)
                objc_setAssociatedObject(owner,ShelfMotionComicPendingKey,owner,0);
            else ShelfRefreshMotionComicModel(owner,controller);
        }
    }
    if (tag!=29) RefreshMineList("FanqieXMineBenefits");
}
static void FeatureVisibilityInstall178R9(void) {
    Hook("SSMyUserExposedHistoryCellModel","shouldShowHistory","fqx178R9_originalShouldShowHistory",
        "B16@0:8",(Imp)MineContinueVisible178R9);
    Hook("SSMyUser627HistoryExposeView","layoutSubviews","fqx178R9_originalHistoryLayout",
        "v16@0:8",(Imp)MineContinueLayout178R9);
    Hook("FQReaderTopView","configInsertObjs:","fqx178R9_originalInsertObjects:",
        "v24@0:8@16",(Imp)ReaderEarnConfigure178R9);
    Hook("SSMyUser621SideBarGameContainerCell","layoutSubviews","fqx178R9_originalGamesLayout",
        "v16@0:8",(Imp)SidebarGamesLayout178R9);
    Hook("SSMyUser621SideBarViewController","reloadData","fqx178R9_originalSidebarReload",
        "v16@0:8",(Imp)SidebarGamesReload178R9);
    Hook("SSBookShelfViewModel","setShowCellModels:","fqx178R9_originalShowCellModels:",
        "v24@0:8@16",(Imp)ShelfMotionComicModels178R9);
    Obj cls=Lookup("SSMyUser621SideBarGameContainerCell"),meta=object_getClass(cls);
    Sel alias=sel_registerName("fqx178R9_originalGamesHeight:containerWidth:");
    if (meta && !class_getInstanceMethod(meta,alias)) {
        const char *type="d32@0:8@16d24";
        Method method=FQDResolveOwned(cls,sel_registerName("heightForModels:containerWidth:"),1,type);
        if (method && class_addMethod(meta,alias,method_getImplementation(method),type))
            method_setImplementation(method,(Imp)SidebarGamesHeight178R9);
    }
}

enum { StoreOption=1, DramaOption, ShelfOption, MineOption, MallOption, ShelfDurationOption,
       MineBenefitsOption, ReaderBottomBackgroundOption, FullscreenFillOption,
       ShelfFilterOption, ReaderThemeIsolationOption, DramaCategoriesOption,
       DramaSearchOption, DramaAuthorDeclarationOption, DramaOriginalNovelOption, MineRecommendationsOption };
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
        case MineRecommendationsOption: key="FanqieX.MineRecommendations.1"; break;
        case ReaderBottomBackgroundOption: key="FanqieX.ReaderBottomBackground.1"; break;
        case FullscreenFillOption: key="FanqieX.FullscreenFill.1"; break;
        case ShelfFilterOption: key="FanqieX.ShelfFilterButton.1"; break;
        case ReaderThemeIsolationOption: key="FanqieX.ReaderThemeIsolation.1"; break;
        case DramaCategoriesOption: key="FanqieX.DramaCategories.1"; break;
        case DramaSearchOption: key="FanqieX.DramaSearch.1"; break;
        case DramaAuthorDeclarationOption: key="FanqieX.DramaAuthorDeclaration.1"; break;
        case DramaOriginalNovelOption: key="FanqieX.DramaOriginalNovel.1"; break;
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
        case MineRecommendationsOption: label="我的显示推荐内容"; break;
        case FullscreenFillOption: label="横屏画面铺满（等比裁切）"; break;
        case ShelfFilterOption: label="书架显示筛选按钮"; break;
        case ReaderThemeIsolationOption: label="书外主题跟随系统"; break;
        default: label="阅读菜单显示上下栏背景"; break;
    }
    return Text(label);
}
static B DefaultEnabled(Obj key) {
    Obj value=O1(O0(Lookup("NSUserDefaults"),"standardUserDefaults"),"objectForKey:",key);
    return value ? BoolProp(value,"boolValue") : 1;
}
static B PageOptionEnabled(I option) {
    Obj value=O1(O0(Lookup("NSUserDefaults"),"standardUserDefaults"),"objectForKey:",PagePreference(option));
    return value ? BoolProp(value,"boolValue") : option!=FullscreenFillOption && option!=ReaderThemeIsolationOption;
}
static B FullscreenFillEnabled(void) { return PageOptionEnabled(FullscreenFillOption); }
static B ShelfFilterVisible(void) { return PageOptionEnabled(ShelfFilterOption); }
static B ReaderThemeIsolationEnabled(void) { return PageOptionEnabled(ReaderThemeIsolationOption); }
static B MineBenefitsEnabled(void) { return DefaultEnabled(PagePreference(MineBenefitsOption)); }
static B MineRecommendationsEnabled(void) { return PageOptionEnabled(MineRecommendationsOption); }
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

// The app's bottom-background resolver knows which selected page is a video
// feed, including registered tabs and bookstore subtabs. System traits alone
// cannot describe those black pages when the rest of the app is in light mode.
void FQHUpdateTabAppearance(Obj bar,Obj proxy,Obj buttons) {
    Obj owner=Get(bar,"delegate");
    if (!Kind(owner,"SSTabBarController") ||
        !InstanceABI(owner,"bottomTabBackgroundColorWithTabModel:","@24@0:8@16")) return;
    Obj page=Get(owner,"selectedViewController");
    Obj model=Get(page,"currentTabModel");
    if (!model) model=Get(Get(Get(page,"bookStoreTabContext"),"containerProvider"),"currentCategoryTabModel");
    Obj color=O1(owner,"bottomTabBackgroundColorWithTabModel:",model);
    Obj traits=Get(bar,"traitCollection");
    if (Responds(color,"resolvedColorWithTraitCollection:"))
        color=O1(color,"resolvedColorWithTraitCollection:",traits);

    I style=0;
    double red=0,green=0,blue=0,alpha=0,white=0;
    if (Kind(color,"UIColor")) {
        if (((B(*)(Obj,Sel,double *,double *,double *,double *))Message)(color,
            sel_registerName("getRed:green:blue:alpha:"),&red,&green,&blue,&alpha))
            white=(red+green*2+blue)*0.25;
        else ((B(*)(Obj,Sel,double *,double *))Message)(color,
            sel_registerName("getWhite:alpha:"),&white,&alpha);
        if (alpha>=0.5) style=white<0.5 ? 2 : 1;
    }
    // Only the owned capsule and its descendants adopt the page appearance.
    // Keep the regular glass effect, transparent backing and established frame.
    if (((I(*)(Obj,Sel))Message)(proxy,sel_registerName("overrideUserInterfaceStyle"))!=style) {
        Q1(proxy,"setOverrideUserInterfaceStyle:",style);
        if (FQDDiagnosticsEnabled()) {
            Obj record=O0(Lookup("NSMutableDictionary"),"dictionary");
            Put(record,"style",Number(style));
            Put(record,"background",Get(color,"description"));
            FQDRecord("tabGlassAppearance",record);
        }
    }
    Obj foreground=O0(Lookup("UIColor"),"labelColor");
    U count=TabCount(buttons);
    for (U i=0;i<count;++i) {
        Obj button=At(buttons,i);
        if (!Kind(button,"UIButton")) continue;
        // These are our visible title buttons, above the native selector whose
        // titles are intentionally clear. Late host syncs may reset their ink.
        for (U state=0;state<8;++state) {
            Obj current=((Obj(*)(Obj,Sel,U))Message)(button,sel_registerName("titleColorForState:"),state);
            if (!SameColor(current,foreground))
                ((void(*)(Obj,Sel,Obj,U))Message)(button,sel_registerName("setTitleColor:forState:"),foreground,state);
        }
        if (!SameColor(Get(button,"tintColor"),foreground)) V1(button,"setTintColor:",foreground);
    }
}
static void InstallTabRecovery(Obj owner);
static void ShelfEditHeaderKey(void) {}
static void ShelfEditInsetsKey(void) {}
static void ShelfCompactKey(void) {}
static const double ShelfFilterOffset=12;
static const double ShelfCompactFilterTop=2;
static const double ShelfCompactEmptyHeight=1;
static Rect ShelfEditPaddedInsets(Rect insets) {
    // UIEdgeInsets shares the four-double ABI with Rect.
    double horizontal=__builtin_fmax(12,__builtin_fmax(insets.y,insets.height));
    double vertical=__builtin_fmax(7,__builtin_fmax(insets.x,insets.width));
    insets.x=vertical;
    insets.y=horizontal;
    insets.width=vertical;
    insets.height=horizontal;
    return insets;
}
static void ShelfEditPadding(Obj button) {
    if (!Kind(button,"UIButton")) return;
    Obj saved=objc_getAssociatedObject(button,ShelfEditInsetsKey);
    B styled=Enabled() && FQHGlassAvailable();
    if (!saved && !styled) return;
    Rect current=((Rect(*)(Obj,Sel))Message)(button,sel_registerName("contentEdgeInsets"));
    Rect stock=current;
    if (saved) {
        Rect previous=UnboxRect(saved);
        if (SameRect(current,ShelfEditPaddedInsets(previous))) stock=previous;
    }
    Rect wanted=styled ? ShelfEditPaddedInsets(stock) : stock;
    if (styled && !SameRect(stock,wanted)) {
        if (!saved || !SameRect(stock,UnboxRect(saved)))
            objc_setAssociatedObject(button,ShelfEditInsetsKey,RectBox(stock),1);
    } else if (saved) {
        objc_setAssociatedObject(button,ShelfEditInsetsKey,0,1);
    }
    if (!SameRect(current,wanted))
        ((void(*)(Obj,Sel,Rect))Message)(button,sel_registerName("setContentEdgeInsets:"),wanted);
}
static void ShelfStockEditLayout(Obj self,Sel cmd) {
    Obj button=Get(self,"editButton"),parent=Get(button,"superview");
    if (parent && objc_getAssociatedObject(parent,ShelfEditHeaderKey)==self) return;
    // The host fits the native title and anchors the button's right edge.
    ShelfEditPadding(button);
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
    Size fit=((Size(*)(Obj,Sel,Size))Message)(button,sel_registerName("sizeThatFits:"),(Size){__DBL_MAX__,__DBL_MAX__});
    double width=__builtin_fmax(44,fit.width),height=__builtin_fmax(30,fit.height);
    if (!found || !VisibleRect(right) || right.x-left<width+20) return frame;
    Rect target={left+10,right.y+(right.height-height)*0.5,width,height};
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
    if (!DefaultEnabled(PagePreference(ShelfDurationOption)) &&
        Kind(header,"SS525BookShelfSubHeaderView") &&
        InstanceABI(header,"showReadTimeView","B16@0:8") && !Flag(header,"showReadTimeView") &&
        InstanceABI(header,"isFiltering","B16@0:8") && !Flag(header,"isFiltering") &&
        InstanceABI(header,"layoutEditButton","v16@0:8") && !Flag(header,"isHidden")) {
        button=Get(header,"editButton");
        secondary=Get(header,"secondaryView");
        Obj parent=Get(button,"superview");
        if (secondary && (parent==secondary || parent==holder) && Kind(button,"UIButton") && !Flag(button,"isHidden")) {
            ShelfEditPadding(button);
            frame=ShelfEditFrame(controller,holder,button);
        }
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
        ShelfActionGlass(button,0);
        if (old!=header) objc_setAssociatedObject(holder,ShelfEditHeaderKey,header,1);
        if (class_getInstanceMethod(object_getClass(cell),sel_registerName("fqx178_originalShelfFunctionLayout"))) {
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
    if (!edit) {
        Obj button=Get(self,"editButton");
        ShelfActionGlass(button,0);
        ShelfRightEdge(button,FQHSurface(button),Enabled());
    }
    ShelfRememberFilterHeader(self);
    B visible=ShelfFilterVisible();
    ApplyShelfFilterButton(Get(self,"filterButton"),visible);
    ApplyShelfFilterButton(Get(self,"fullGenreFilterButton"),visible);
}
static void ShelfLegacyFilterShow(Obj self,Sel cmd,B show) {
    RestoreShelfFilterButton(Get(self,"filterButton"));
    ((void(*)(Obj,Sel,B))Original("SS525BookShelfSubHeaderView","fqx191_originalShelfFilterShow:"))(self,cmd,show);
    ApplyShelfFilterButton(Get(self,"filterButton"),ShelfFilterVisible());
}
static void RefreshShelfFilter(void) {
    Obj headers=O0(ShelfFilterHeaders(),"allObjects");
    U count=TabCount(headers);
    B visible=ShelfFilterVisible();
    for (U i=0;i<count;++i) {
        Obj header=At(headers,i);
        ApplyShelfFilterButton(Get(header,"filterButton"),visible);
        ApplyShelfFilterButton(Get(header,"fullGenreFilterButton"),visible);
        V0(header,"setNeedsLayout");
    }
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
        else if (tag==MineBenefitsOption) RefreshMineList("FanqieXMineBenefits");
        else if (tag==MineRecommendationsOption) RefreshMineList("FanqieXMineRecommendations");
        else if (tag==ShelfFilterOption) RefreshShelfFilter();
        else if (tag==ReaderThemeIsolationOption && on) FQHApplyReaderThemeIsolation();
        else if (tag==FullscreenFillOption) RefreshFullscreenFill();
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
    if (!FQDDiagnosticsEnabled()) return;
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
static void DramaDockLogKey(void) {}
static void DramaDockViewport178R4Key(void) {}
static void DramaDockControlApplied178R4Key(void) {}
static void DramaDockGradient178R6Key(void) {}

// The root drama feed reserves a dock-height strip in portraitVideoSize. A
// transparent tab bar cannot reveal a video which stops above that strip.
// Supply one consistent canvas to the host's own paging/layout code instead of
// stretching a render subview beyond clipped/recycled collection cells.
static B DramaDockCanvas178R4(Obj config,Size stock,Size *canvas) {
    *canvas=stock;
    if (!Enabled() || !Kind(config,"FQVShortVideoListConfig") ||
        !InstanceABI(config,"feedType","q16@0:8") ||
        ((I(*)(Obj,Sel))Message)(config,sel_registerName("feedType"))!=4 ||
        !__builtin_isfinite(stock.width) || !__builtin_isfinite(stock.height)) return 0;
    Rect screen=Bounds(O0(Lookup("UIScreen"),"mainScreen"));
    if (!__builtin_isfinite(screen.width) || !__builtin_isfinite(screen.height)) return 0;
    double width=__builtin_fmin(screen.width,screen.height);
    double height=__builtin_fmax(screen.width,screen.height);
    double inset=height-stock.height;
    if (!__builtin_isfinite(width) || !__builtin_isfinite(height) || width<=0 ||
        stock.height<=width || (stock.width!=0 && __builtin_fabs(stock.width-width)>1) ||
        inset<40 || inset>120) return 0;
    // A zero width is the host's automatic-container-width sentinel.
    canvas->height=height;
    return 1;
}

static Obj DramaDockControlConfig(Obj root) {
    Obj context=InstanceABI(root,"listVCContext","@16@0:8") ? O0(root,"listVCContext") : (Obj)0;
    Obj config=InstanceABI(context,"config","@16@0:8") ? O0(context,"config") : (Obj)0;
    return config ? config : Get(root,"listVCConfig");
}

static void DramaDockSetGradientStops(Obj layer,Obj colors,Obj locations) {
    Obj transaction=Lookup("CATransaction");
    V0(transaction,"begin"); VB(transaction,"setDisableActions:",1);
    if (colors) V1(layer,"setColors:",colors);
    if (locations) V1(layer,"setLocations:",locations);
    V0(transaction,"commit");
}

static B DramaDockStopsMatch(Obj current,Obj applied) {
    return current==applied || ((B(*)(Obj,Sel,Obj))Message)(current,sel_registerName("isEqual:"),applied);
}

static void DramaDockFeatherBottomGradient178R6(Obj root) {
    Obj config=DramaDockControlConfig(root), view=0, layer=0;
    if (Kind(config,"FQVShortVideoListConfig") &&
        InstanceABI(config,"fqx178r4_originalPortraitSize","{CGSize=dd}16@0:8")) {
        Size stock=((Size(*)(Obj,Sel))Original("FQVShortVideoListConfig","fqx178r4_originalPortraitSize"))(
            config,sel_registerName("portraitVideoSize"));
        Size canvas;
        Rect bounds=Bounds(root), screen=Bounds(O0(Lookup("UIScreen"),"mainScreen"));
        if (screen.height>screen.width && DramaDockCanvas178R4(config,stock,&canvas) &&
            __builtin_fabs(bounds.height-stock.height)<1 && __builtin_fabs(bounds.width-screen.width)<1) {
            view=Get(root,"bottomGradientView");
            if (Kind(view,"FQVShortVideoGradientLayerView") && Get(view,"superview")==root)
                layer=Get(view,"gradientLayer");
            if (!Kind(layer,"CAGradientLayer")) layer=0;
        }
    }
    Obj previous=objc_getAssociatedObject(root,DramaDockGradient178R6Key);
    if (previous) {
        Obj previousLayer=At(previous,0);
        B ownedColors=DramaDockStopsMatch(O0(previousLayer,"colors"),At(previous,3));
        B ownedLocations=DramaDockStopsMatch(O0(previousLayer,"locations"),At(previous,4));
        if (layer==previousLayer && ownedColors && ownedLocations) return;
        if (ownedColors || ownedLocations)
            DramaDockSetGradientStops(previousLayer,ownedColors ? At(previous,1) : (Obj)0,
                                     ownedLocations ? At(previous,2) : (Obj)0);
        objc_setAssociatedObject(root,DramaDockGradient178R6Key,0,1);
    }
    if (!layer) return;

    Obj colors=O0(layer,"colors"), locations=O0(layer,"locations");
    Rect bounds=Bounds(view);
    const double fade=10;
    // Host 7.4.3.33 ends a 280pt black gradient at the controls' bottom edge.
    // Blend its last 10pt back into the underlying full-height video canvas.
    if (TabCount(colors)!=2 || TabCount(locations)!=2 || Double(At(locations,0))!=0 ||
        Double(At(locations,1))!=1 || bounds.height<=fade) return;
    Obj array=Lookup("NSArray");
    Obj (*makeArray)(Obj,Sel,Obj *,U)=(Obj(*)(Obj,Sel,Obj *,U))Message;
    Sel make=sel_registerName("arrayWithObjects:count:");
    Obj fadedColors=makeArray(array,make,(Obj[]){At(colors,0),At(colors,1),At(colors,0)},3);
    Obj fadedLocations=makeArray(array,make,(Obj[]){At(locations,0),Number(1-fade/bounds.height),At(locations,1)},3);
    Obj state=makeArray(array,make,(Obj[]){layer,colors,locations,fadedColors,fadedLocations},5);
    objc_setAssociatedObject(root,DramaDockGradient178R6Key,state,1);
    DramaDockSetGradientStops(layer,fadedColors,fadedLocations);
}

static Size DramaDockPortraitSize178R4(Obj self,Sel cmd) {
    Size stock=((Size(*)(Obj,Sel))Original("FQVShortVideoListConfig","fqx178r4_originalPortraitSize"))(self,cmd);
    Size canvas=stock;
    B applied=DramaDockCanvas178R4(self,stock,&canvas);
    if (!FQDDiagnosticsEnabled()) return canvas;
    Rect state={stock.width,stock.height,canvas.width,canvas.height};
    Obj previous=objc_getAssociatedObject(self,DramaDockViewport178R4Key);
    if ((applied || previous) && (!previous || !SameRect(state,UnboxRect(previous)))) {
        objc_setAssociatedObject(self,DramaDockViewport178R4Key,RectBox(state),1);
        Obj record=O0(Lookup("NSMutableDictionary"),"dictionary");
        Put(record,"revision",Text("floating-canvas-178R4"));
        Put(record,"applied",BoolBox(applied));
        Put(record,"requestedWidth",Number(stock.width));
        Put(record,"stockHeight",Number(stock.height));
        Put(record,"viewportHeight",Number(canvas.height));
        Put(record,"controlsBottomInset",Number(canvas.height-stock.height));
        FQDRecord("dramaDockViewport",record);
    }
    return canvas;
}

static void DramaDockControlFrame178R4(Obj self,Sel cmd,Rect requested) {
    Obj previous=objc_getAssociatedObject(self,DramaDockControlApplied178R4Key);
    // Absolute native height is idempotent. Never reinterpret an incoming
    // native-height frame as an old full-height request: after disabling or
    // reuse the host can legitimately request exactly our previous result.
    Rect target=requested;
    Obj config=DramaDockControlConfig(self);
    if (Kind(config,"FQVShortVideoListConfig") &&
        InstanceABI(config,"fqx178r4_originalPortraitSize","{CGSize=dd}16@0:8") &&
        __builtin_isfinite(requested.width) && __builtin_isfinite(requested.height) &&
        requested.height>requested.width && requested.width>0) {
        Size stock=((Size(*)(Obj,Sel))Original("FQVShortVideoListConfig","fqx178r4_originalPortraitSize"))(
            config,sel_registerName("portraitVideoSize"));
        Size canvas=stock;
        Rect screen=Bounds(O0(Lookup("UIScreen"),"mainScreen"));
        double width=__builtin_fmin(screen.width,screen.height);
        if (DramaDockCanvas178R4(config,stock,&canvas) &&
            __builtin_fabs(requested.width-width)<1 &&
            __builtin_fabs(requested.height-canvas.height)<1)
            // Keep the native info/episode/seek anchors above the dock. Never
            // subtract from a frame which already has the original height.
            target.height=stock.height;
    }
    B adjusted=!SameRect(requested,target);
    B changed=(adjusted && (!previous || !SameRect(target,UnboxRect(previous)))) || (previous && !adjusted);
    if (adjusted) {
        if (changed) objc_setAssociatedObject(self,DramaDockControlApplied178R4Key,RectBox(target),1);
    } else if (previous) {
        objc_setAssociatedObject(self,DramaDockControlApplied178R4Key,0,1);
    }
    ((void(*)(Obj,Sel,Rect))Original("FQVShortVideoVPlayerControlView","fqx178r4_originalDockControlFrame:"))(self,cmd,target);
    if (FQDDiagnosticsEnabled() && changed) {
        Obj record=O0(Lookup("NSMutableDictionary"),"dictionary");
        Put(record,"revision",Text("floating-canvas-178R4"));
        Put(record,"requestedFrame",RectArray(requested));
        Put(record,"controlsFrame",RectArray(target));
        Put(record,"reservedBottom",Number(requested.height-target.height));
        FQDRecord("dramaDockControls",record);
    }
}

static B DramaDockStockChannel(double value) {
    return value>=0 && value<=1 && (int)(value*256+0.5)==29;
}

static B DramaDockStockColor(Obj color) {
    double red=0,green=0,blue=0,alpha=0;
    if (((B(*)(Obj,Sel,double *,double *,double *,double *))Message)(color,
        sel_registerName("getRed:green:blue:alpha:"),&red,&green,&blue,&alpha))
        return alpha==1 && DramaDockStockChannel(red) && DramaDockStockChannel(green) && DramaDockStockChannel(blue);
    double white=0;
    return ((B(*)(Obj,Sel,double *,double *))Message)(color,sel_registerName("getWhite:alpha:"),&white,&alpha) &&
        alpha==1 && DramaDockStockChannel(white);
}

static Obj DramaDockBackground(Obj self,Sel cmd) {
    Obj stock=((Obj(*)(Obj,Sel))Original("FQVShortVideoListConfig","fqx193_originalDramaDockColor"))(self,cmd);
    if (!stock || ((I(*)(Obj,Sel))Message)(self,sel_registerName("feedType"))!=4 ||
        !DramaDockStockColor(stock) || !Enabled()) return stock;
    if (!InstanceABI(self,"fqx178r4_originalPortraitSize","{CGSize=dd}16@0:8")) return stock;
    Size native=((Size(*)(Obj,Sel))Original("FQVShortVideoListConfig","fqx178r4_originalPortraitSize"))(
        self,sel_registerName("portraitVideoSize"));
    Size canvas=native;
    if (!DramaDockCanvas178R4(self,native,&canvas)) {
        // The host also gives its corner views a resolved full-height copy of
        // the config. It is safe to clear that paint, but not an unrelated or
        // malformed canvas which this repair cannot extend.
        Rect screen=Bounds(O0(Lookup("UIScreen"),"mainScreen"));
        double width=__builtin_fmin(screen.width,screen.height);
        double height=__builtin_fmax(screen.width,screen.height);
        if (!__builtin_isfinite(screen.width) || !__builtin_isfinite(screen.height) ||
            !__builtin_isfinite(native.width) || !__builtin_isfinite(native.height) ||
            width<=0 || height<=width ||
            (native.width!=0 && __builtin_fabs(native.width-width)>1) ||
            __builtin_fabs(native.height-height)>1) return stock;
    }

    // The feed root and both sets of rounded corner images all read this color.
    // Clear their paint; black merely recolors the opaque strip outside glass.
    if (FQDDiagnosticsEnabled() && !objc_getAssociatedObject(self,DramaDockLogKey)) {
        objc_setAssociatedObject(self,DramaDockLogKey,BoolBox(1),1);
        Obj record=O0(Lookup("NSMutableDictionary"),"dictionary");
        Put(record,"feedType",Number(4));
        Put(record,"stock",Text("#1D1D1D"));
        Put(record,"applied",Text("clear"));
        FQDRecord("dramaDockBackdrop",record);
    }
    return O0(Lookup("UIColor"),"clearColor");
}

static void DramaBackdropInstall(void) {
    const char *config="FQVShortVideoListConfig", *alias="fqx193_originalDramaDockColor";
    Obj owner=Lookup(config);
    if (!owner) return;
    const char *control="FQVShortVideoVPlayerControlView";
    B compatible=FQHGlassAvailable() && Signature(config,"feedType","q16@0:8") &&
        Signature(config,"listVCBackgroundColor","@16@0:8") &&
        Signature(config,"portraitVideoSize","{CGSize=dd}16@0:8") &&
        Signature(control,"listVCConfig","@16@0:8") &&
        Signature(control,"setFrame:","v48@0:8{CGRect={CGPoint=dd}{CGSize=dd}}16");
    if (compatible) {
        Hook(control,"setFrame:","fqx178r4_originalDockControlFrame:",
             "v48@0:8{CGRect={CGPoint=dd}{CGSize=dd}}16",(Imp)DramaDockControlFrame178R4);
        if (Signature(control,"fqx178r4_originalDockControlFrame:","v48@0:8{CGRect={CGPoint=dd}{CGSize=dd}}16"))
            Hook(config,"portraitVideoSize","fqx178r4_originalPortraitSize",
                 "{CGSize=dd}16@0:8",(Imp)DramaDockPortraitSize178R4);
        if (Signature(config,"fqx178r4_originalPortraitSize","{CGSize=dd}16@0:8"))
            Hook(config,"listVCBackgroundColor",alias,"@16@0:8",(Imp)DramaDockBackground);
    }
    if (!FQDDiagnosticsEnabled()) return;
    Obj record=O0(Lookup("NSMutableDictionary"),"dictionary");
    Put(record,"installed",BoolBox(class_getInstanceMethod(owner,sel_registerName(alias))!=0));
    Put(record,"revision",Text("floating-canvas-178R4"));
    Put(record,"videoSizeOverridden",BoolBox(Signature(config,"fqx178r4_originalPortraitSize","{CGSize=dd}16@0:8")));
    FQDRecord("dramaDockBackdropInstall",record);
}

static void ReaderThemeLaunchKey(void) {}
static void ReaderThemePendingKey(void) {}

static Obj ReaderThemePresetKey(void) { return Text("FanqieX.ReaderThemePreset.1"); }
static B ReaderThemeKeysMatch(Obj left,Obj right) {
    return left && (left==right || ((B(*)(Obj,Sel,Obj))Message)(left,sel_registerName("isEqual:"),right));
}

static void TrackReaderThemePreset(Obj manager,Obj config) {
    Obj key=Get(config,"themeKey");
    if (!Kind(key,"NSString") || !((U(*)(Obj,Sel))Message)(key,sel_registerName("length"))) key=0;
    objc_setAssociatedObject(manager,ReaderThemePendingKey,key,1);
}

static void SaveReaderThemePreset(Obj manager,Obj config,Obj context) {
    Obj pending=objc_getAssociatedObject(manager,ReaderThemePendingKey);
    if (!pending || !ReaderThemeIsolationEnabled() || !Kind(context,"FQReaderThemeConfigChangeContext") ||
        !Flag(context,"needSaveConfig") || !ReaderThemeKeysMatch(pending,Get(config,"themeKey"))) return;
    Obj defaults=O0(Lookup("NSUserDefaults"),"standardUserDefaults");
    ((void(*)(Obj,Sel,Obj,Obj))Message)(defaults,sel_registerName("setObject:forKey:"),pending,ReaderThemePresetKey());
    objc_setAssociatedObject(manager,ReaderThemePendingKey,0,1);
}

static void ReaderThemePaletteChoice(Obj self,Sel cmd,Obj view,Obj config) {
    if (ReaderThemeIsolationEnabled()) TrackReaderThemePreset(self,config);
    ((void(*)(Obj,Sel,Obj,Obj))Original("FQReaderUIManager","fqx191_originalReaderPalette:theme:"))(self,cmd,view,config);
}

static void ReaderThemeWillAppear(Obj self,Sel cmd,Obj model) {
    ((void(*)(Obj,Sel,Obj))Original("FQReaderManager","fqx191_originalReaderWillAppear:"))(self,cmd,model);
    if (!ReaderThemeIsolationEnabled()) return;
    Obj key=O1(O0(Lookup("NSUserDefaults"),"standardUserDefaults"),"objectForKey:",ReaderThemePresetKey());
    if (!Kind(key,"NSString")) return;
    Obj current=Get(Get(model,"config"),"themeConfig");
    if (ReaderThemeKeysMatch(key,Get(current,"themeKey"))) return;
    Obj uiConfig=Get(self,"UIConfig"),ui=Get(self,"UIMgr");
    if (!Kind(uiConfig,"FQReaderSaaSUIConfig") || !Kind(ui,"FQReaderUIManager")) return;
    Obj preset=O1(uiConfig,"themeConfigForKey:",key);
    if (ReaderThemeKeysMatch(key,Get(preset,"themeKey"))) V1(ui,"onConfigThemeChange:",preset);
}

void FQHApplyReaderThemeIsolation(void) {
    const char *adapterName="SSUIColorAdaptedManager";
    Obj adapterClass=Lookup(adapterName);
    Obj serviceCenter=Lookup("HTSServiceCenter");
    if (!ReaderThemeIsolationEnabled() ||
        !class_getInstanceMethod(Lookup("FQReaderThemeManager"),sel_registerName("fqx191_originalReaderTheme:success:failure:")) ||
        !Signature("HTSServiceCenter","getService:","@24@0:8#16") ||
        !Signature(adapterName,"isCurrentDarkModeFollowSystem","B16@0:8") ||
        !Signature(adapterName,"setCurrentDarkModeFollowSystemWithEnable:","v20@0:8B16")) return;
    Obj adapter=O1(Get(serviceCenter,"defaultCenter"),"getService:",adapterClass);
    if (Kind(adapter,adapterName) && !Flag(adapter,"isCurrentDarkModeFollowSystem"))
        VB(adapter,"setCurrentDarkModeFollowSystemWithEnable:",1);
}

static void ReaderLocalTheme(Obj self,Sel cmd,Obj config,Obj success,Obj failure) {
    const char *legacy="tryChangethemeConfig:successCallback:failedCallback:";
    if (ReaderThemeIsolationEnabled()) {
        // Use the reader's own commit path, including custom-background confirmation,
        // saving and callbacks. The cross-theme path asks the app to disable follow-system.
        U style=((U(*)(Obj,Sel))Message)(config,sel_registerName("themeStyle"));
        VB(self,"setTargetIsDark:",style==1);
        Obj ui=Get(Get(self,"readerMgr"),"UIMgr");
        if (ui) TrackReaderThemePreset(ui,config);
        ((void(*)(Obj,Sel,Obj,Obj,Obj))Message)(self,sel_registerName("tryChangeSameThemeConfig:successCallback:failedCallback:"),config,success,failure);
        return;
    }
    const char *alias=cmd==sel_registerName(legacy) ? "fqx191_originalReaderTheme:success:failure:" : "fqx191_originalReaderDiffTheme:success:failure:";
    ((void(*)(Obj,Sel,Obj,Obj,Obj))Original("FQReaderThemeManager",alias))(self,cmd,config,success,failure);
}

static void ReaderThemeToApp(Obj self,Sel cmd,Obj setting,Obj book) {
    // This host bridge only synchronizes the app's dark mode to the reader's background.
    if (!ReaderThemeIsolationEnabled())
        ((void(*)(Obj,Sel,Obj,Obj))Original("SSUIColorAdaptedManager","fqx191_originalReaderSetting:book:"))(self,cmd,setting,book);
}

static void ReaderThemeFromApp(Obj self,Sel cmd,B dark) {
    if (ReaderThemeIsolationEnabled()) return;
    const char *alias=cmd==sel_registerName("onDarkModeChange:") ? "fqx191_originalReaderDarkMode:" : "fqx191_originalReaderDarkModeSwitch:";
    ((void(*)(Obj,Sel,B))Original("FQReaderThemeManager",alias))(self,cmd,dark);
}

static void ReaderThemeIsolationInstall(void) {
    const char *manager="FQReaderThemeManager";
    const char *local="tryChangeSameThemeConfig:successCallback:failedCallback:";
    const char *legacy="tryChangethemeConfig:successCallback:failedCallback:";
    const char *diff="tryChangeDiffThemeConfig:successCallback:failedCallback:";
    const char *encoding="v40@0:8@16@?24@?32";
    const char *adapter="SSUIColorAdaptedManager";
    if (!Signature(manager,local,encoding) || !Signature(manager,legacy,encoding) || !Signature(manager,diff,encoding) ||
        !Signature(manager,"setTargetIsDark:","v20@0:8B16") ||
        !Signature("BDReaderThemeConfig","themeStyle","Q16@0:8") ||
        !Signature(adapter,"readerClientDidChangeSetting:bookId:","v32@0:8@16@24")) return;
    Hook("FQReaderThemeManager","tryChangethemeConfig:successCallback:failedCallback:","fqx191_originalReaderTheme:success:failure:",encoding,(Imp)ReaderLocalTheme);
    Hook("FQReaderThemeManager","tryChangeDiffThemeConfig:successCallback:failedCallback:","fqx191_originalReaderDiffTheme:success:failure:",encoding,(Imp)ReaderLocalTheme);
    Hook("SSUIColorAdaptedManager","readerClientDidChangeSetting:bookId:","fqx191_originalReaderSetting:book:","v32@0:8@16@24",(Imp)ReaderThemeToApp);
    Hook("FQReaderThemeManager","onDarkModeChange:","fqx191_originalReaderDarkMode:","v20@0:8B16",(Imp)ReaderThemeFromApp);
    Hook("FQReaderThemeManager","onDarkModeSwitchChange:","fqx191_originalReaderDarkModeSwitch:","v20@0:8B16",(Imp)ReaderThemeFromApp);
    if (!Signature("FQReaderThemeConfigChangeContext","needSaveConfig","B16@0:8") ||
        !Signature("FQReaderSaaSUIConfig","themeConfigForKey:","@24@0:8@16") ||
        !Signature("FQReaderUIManager","onConfigThemeChange:","v24@0:8@16")) return;
    Hook("FQReaderUIManager","onSelectSettingView:themeConfig:","fqx191_originalReaderPalette:theme:","v32@0:8@16@24",(Imp)ReaderThemePaletteChoice);
    Hook("FQReaderManager","onBDReaderVCWillAppearWithReadModel:","fqx191_originalReaderWillAppear:","v24@0:8@16",(Imp)ReaderThemeWillAppear);
}

static void TabOwnerAppear(Obj self,Sel cmd,B animated) {
    ((void(*)(Obj,Sel,B))Original("SSTabBarController","fqx176_originalTabAppear:"))(self,cmd,animated);
    InstallTabRecovery(self);
    if (!objc_getAssociatedObject(self,ReaderThemeLaunchKey)) {
        objc_setAssociatedObject(self,ReaderThemeLaunchKey,self,0);
        FQHApplyReaderThemeIsolation();
    }
}
static void SettingsPlaceSwitch178R14(Obj toggle,double width,double centerY) {
    Size size=((Size(*)(Obj,Sel,Size))Message)(toggle,sel_registerName("sizeThatFits:"),(Size){width,44});
    if (size.width<=0 || size.height<=0) size=(Size){64,31};
    Rect frame={width-20-size.width,centerY-size.height*0.5,size.width,size.height};
    if (!SameRect(Frame(toggle),frame)) SetFrame(toggle,frame);
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
    SettingsPlaceSwitch178R14(toggle,width,y+16);
    Q1(toggle,"setTag:",tag);
    Q1(toggle,"setAutoresizingMask:",1);
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
Obj FQHInstallOptionsToggles(Obj controller) {
    SettingsInstall178R13(controller);
    Obj menu=Lookup("FQXSettingsMenu");
    Obj root=Responds(menu,"controllerForController:") ? O1(menu,"controllerForController:",controller) : (Obj)0;
    if (!root || root==controller) return controller;
    // _open_menu owns its freshly allocated root and releases it after the
    // navigation controller retains it. Transfer that ownership to the menu.
    V0(root,"retain");
    V0(controller,"release");
    return root;
}

static void FullscreenScaleBaselineKey(void) {}
// Pick the highest available source only at the native short-video preparation
// boundary. Requests, authorization, playback and explicit user choices remain
// owned by the host; the preference is intentionally off when unset.
static void DramaQualityManualVideo178R11Key(void) {}
static B DramaQualityMainFeed178R11(Obj component) {
    Obj config=Get(Get(component,"listVCContext"),"config");
    return Kind(config,"FQVShortVideoListConfig") && InstanceABI(config,"feedType","q16@0:8") &&
        ((I(*)(Obj,Sel))Message)(config,sel_registerName("feedType"))==4;
}
static Obj DramaQualityVideoID178R11(Obj model) {
    Obj identifier=Get(Get(Get(model,"shortVideoModel"),"videoData"),"vid");
    return Kind(identifier,"NSString") && ((U(*)(Obj,Sel))Message)(identifier,sel_registerName("length")) ? identifier : (Obj)0;
}
static Obj DramaHighestAvailable178R11(Obj videoModel) {
    Obj resolutions=Get(videoModel,"supportedResolutionTypes");
    if (!Kind(resolutions,"NSArray")) return 0;
    U count=((U(*)(Obj,Sel))Message)(resolutions,sel_registerName("count"));
    Obj best=0;
    double bestPixels=0;
    I bestBitrate=0;
    for (U i=0;i<count;++i) {
        Obj resolution=At(resolutions,i);
        if (!Kind(resolution,"NSNumber")) continue;
        U type=((U(*)(Obj,Sel))Message)(resolution,sel_registerName("unsignedIntegerValue"));
        Obj variant=((Obj(*)(Obj,Sel,U))Message)(videoModel,sel_registerName("videoInfoForType:"),type);
        if (!Kind(variant,"TTVideoEngineURLInfo")) continue;
        Obj width=Get(variant,"vWidth"),height=Get(variant,"vHeight");
        if (!Kind(width,"NSNumber") || !Kind(height,"NSNumber")) continue;
        double w=Double(width),h=Double(height),pixels=w*h;
        if (!__builtin_isfinite(pixels) || w<=0 || h<=0) continue;
        I bitrate=((I(*)(Obj,Sel))Message)(variant,sel_registerName("bitrate"));
        if (!best || pixels>bestPixels || (pixels==bestPixels && bitrate>bestBitrate)) {
            best=resolution; bestPixels=pixels; bestBitrate=bitrate;
        }
    }
    return best;
}
static Obj DramaQualityResolutionItem178R11(Obj self,Sel cmd,Obj model) {
    Obj item=((Obj(*)(Obj,Sel,Obj))Original("FQVShortVideoListVCPlayerComponent",
        "fqx178r11_originalResolutionItem:"))(self,cmd,model);
    Obj enabled=O1(O0(Lookup("NSUserDefaults"),"standardUserDefaults"),"objectForKey:",
        Text("FanqieX.DramaHighestQuality.1"));
    if (!BoolProp(enabled,"boolValue") || !DramaQualityMainFeed178R11(self) || !Kind(model,"FQVShortVideoDataModel") ||
        !Kind(item,"FQVPlayerEngineDataResolutionItem")) return item;
    Obj shortVideo=Get(model,"shortVideoModel"),identifier=DramaQualityVideoID178R11(model);
    if (!identifier || BoolProp(shortVideo,"isVideoLocked") || BoolProp(shortVideo,"videoModelDisabled") ||
        BoolProp(model,"useDownloadedEngineData")) return item;
    Obj manual=objc_getAssociatedObject(model,DramaQualityManualVideo178R11Key);
    if ((manual && ((B(*)(Obj,Sel,Obj))Message)(manual,sel_registerName("isEqual:"),identifier)) ||
        O1(self,"historyResolutionWithModel:",model) || O1(self,"feedResolutionWithVideoId:",identifier)) return item;
    Obj current=Get(Get(model,"videoInfo"),"videoModel");
    // Do not choose from a previous/preloaded model while the current response
    // is still unavailable. The engine's own response is the available set.
    if (!Kind(current,"TTVideoEngineModel") || Get(item,"videoModel")!=current) return item;
    Obj best=DramaHighestAvailable178R11(current);
    if (best) V1(item,"setForceResolutionTypeNumber:",best);
    return item;
}
static void DramaQualityManualSelection178R11(Obj self,Sel cmd,Obj player,Obj resolution,Obj model,Obj finish) {
    if (DramaQualityMainFeed178R11(self) && Kind(model,"FQVShortVideoDataModel")) {
        Obj identifier=DramaQualityVideoID178R11(model);
        if (identifier) objc_setAssociatedObject(model,DramaQualityManualVideo178R11Key,identifier,1);
    }
    ((void(*)(Obj,Sel,Obj,Obj,Obj,Obj))Original("FQVShortVideoListVCPlayerComponent",
        "fqx178r11_originalUpdateResolution:resolution:model:finish:"))(self,cmd,player,resolution,model,finish);
}
static void DramaQualityInstall178R11(void) {
    const char *owner="FQVShortVideoListVCPlayerComponent";
    if (!Signature(owner,"historyResolutionWithModel:","@24@0:8@16") ||
        !Signature(owner,"feedResolutionWithVideoId:","@24@0:8@16") ||
        !Signature("TTVideoEngineModel","videoInfoForType:","@24@0:8Q16") ||
        !Signature("TTVideoEngineURLInfo","bitrate","q16@0:8") ||
        !Signature("FQVPlayerEngineDataResolutionItem","setForceResolutionTypeNumber:","v24@0:8@16")) return;
    Hook(owner,"resolutionItemWithModel:","fqx178r11_originalResolutionItem:",
        "@24@0:8@16",(Imp)DramaQualityResolutionItem178R11);
    Hook(owner,"updatePlayer:resolution:model:finish:","fqx178r11_originalUpdateResolution:resolution:model:finish:",
        "v48@0:8@16@24@32@?40",(Imp)DramaQualityManualSelection178R11);
}

static void FullscreenPlayersKey(void) {}
static void FullscreenLogStateKey(void) {}
static void FullscreenLogBoundsKey(void) {}
static void FullscreenAlignBaselineKey(void) {}
// TTVideoEngineScalingModeAspectFill=2 is the native, proportional crop mode.
// Only its video surface fills the canvas; the player's controls keep their size.
// https://docs.volcengine.com/docs/video-on-demand/ios-player-types?lang=zh
// TTPlayerView alignment 5 sets the scaled surface's center to the viewport's
// horizontal midpoint and its bottom edge to the viewport's bottom edge.
enum { FullscreenAspectFillMode=2, FullscreenBottomCenterMode=5 };

static Obj FullscreenPlayers(void) {
    Obj cls=Lookup("FQVPlayer");
    Obj players=objc_getAssociatedObject(cls,FullscreenPlayersKey);
    if (!players) {
        players=O0(Lookup("NSHashTable"),"weakObjectsHashTable");
        objc_setAssociatedObject(cls,FullscreenPlayersKey,players,1);
    }
    return players;
}

static B FullscreenFillViewport(Obj player,Rect *viewport) {
    if (!Flag(player,"isFullScreen") || !FullscreenFillEnabled()) return 0;
    Obj holder=Get(player,"superview"), cell=Get(holder,"superview");
    B landscapeCell=Kind(cell,"FQVShortVideoLandscapePlayerCellView");
    if (landscapeCell && Flag(cell,"isInPlayerScaleMode")) return 0;
    Obj window=Get(player,"window");
    if (!window) return 0;
    Rect bounds=Bounds(player), screen=Bounds(window);
    if (bounds.width<=bounds.height || bounds.height<=0) return 0;
    // Compare the dimensions in window coordinates to handle either rotation direction.
    Rect placement=Convert(player,bounds,window);
    if (__builtin_fabs(placement.width-screen.width)>1 || __builtin_fabs(placement.height-screen.height)>1) return 0;
    // A paged cell moves in the window without necessarily relaying out its player.
    if (landscapeCell) {
        if (Get(cell,"playerSuperView")!=holder) return 0;
        placement=Convert(player,bounds,cell);
        screen=Bounds(cell);
        if (__builtin_fabs(placement.width-screen.width)>1 || __builtin_fabs(placement.height-screen.height)>1) return 0;
    }
    if (__builtin_fabs(placement.x-screen.x)>1 || __builtin_fabs(placement.y-screen.y)>1) return 0;
    *viewport=bounds;
    return 1;
}

static void FullscreenOverrideMode(Obj engine,B fill,const void *key,const char *getter,const char *setter,I target) {
    Obj baseline=objc_getAssociatedObject(engine,key);
    if (!fill && !baseline) return;
    I mode=((I(*)(Obj,Sel))Message)(engine,sel_registerName(getter));
    if (fill && mode!=target) {
        Obj box=((Obj(*)(Obj,Sel,I))Message)(Lookup("NSNumber"),sel_registerName("numberWithInteger:"),mode);
        objc_setAssociatedObject(engine,key,box,1);
        Q1(engine,setter,target);
    } else if (!fill) {
        I previous=((I(*)(Obj,Sel))Message)(baseline,sel_registerName("integerValue"));
        objc_setAssociatedObject(engine,key,0,1);
        if (mode==target) Q1(engine,setter,previous);
    }
}

static void FullscreenScale(Obj engine,B fill) {
    if (!engine) return;
    FullscreenOverrideMode(engine,fill,FullscreenAlignBaselineKey,"alignMode","setAlignMode:",FullscreenBottomCenterMode);
    FullscreenOverrideMode(engine,fill,FullscreenScaleBaselineKey,"scaleMode","setScaleMode:",FullscreenAspectFillMode);
}

static void FullscreenDiagnostics(Obj player,B fill) {
    if (!FQDDiagnosticsEnabled()) return;
    Obj last=objc_getAssociatedObject(player,FullscreenLogStateKey);
    B full=Flag(player,"isFullScreen");
    // Inactive portrait feeds need no new per-layout diagnostic work.
    if (!last && !full) return;
    B enabled=FullscreenFillEnabled();
    if (!last && !enabled) return;
    Obj engine=O0(player,"videoEngine"),window=Get(player,"window");
    I mode=engine ? ((I(*)(Obj,Sel))Message)(engine,sel_registerName("scaleMode")) : -1;
    I state=(mode+1)*16+(fill ? 8 : 0)+(full ? 4 : 0)+(enabled ? 2 : 0)+(window ? 1 : 0);
    Rect bounds=Bounds(player);
    Obj oldBounds=objc_getAssociatedObject(player,FullscreenLogBoundsKey);
    if (last && ((I(*)(Obj,Sel))Message)(last,sel_registerName("integerValue"))==state &&
        oldBounds && SameRect(UnboxRect(oldBounds),bounds)) return;
    objc_setAssociatedObject(player,FullscreenLogStateKey,Number(state),1);
    objc_setAssociatedObject(player,FullscreenLogBoundsKey,RectBox(bounds),1);
    Obj record=O0(Lookup("NSMutableDictionary"),"dictionary");
    Put(record,"revision",Text("bottom-aligned-aspect-fill"));
    B applied=fill && engine && mode==FullscreenAspectFillMode;
    Put(record,"mode",Text(applied ? "aspectFill" : "native"));
    Put(record,"enabled",BoolBox(enabled)); Put(record,"isFullscreen",BoolBox(full));
    Put(record,"eligibleViewport",BoolBox(fill));
    Put(record,"applied",BoolBox(applied)); Put(record,"scaleMode",Number(mode));
    Put(record,"playerBounds",RectArray(bounds));
    if (window) {
        Put(record,"windowBounds",RectArray(Bounds(window)));
        Put(record,"playerInWindow",RectArray(Convert(player,bounds,window)));
    }
    FQDRecord("dramaFullscreenMode",record);
}

static B FullscreenApplyPlayer(Obj player) {
    Rect viewport;
    B fill=FullscreenFillViewport(player,&viewport);
    FullscreenScale(O0(player,"videoEngine"),fill);
    FullscreenDiagnostics(player,fill);
    return fill;
}

static void RefreshFullscreenFill(void) {
    Obj players=O0(FullscreenPlayers(),"allObjects");
    U count=TabCount(players);
    for (U i=0;i<count;++i) {
        Obj player=At(players,i);
        FullscreenApplyPlayer(player);
        // Returning to stock also needs the host to recompute its video frame.
        if (Get(player,"window")) V0(player,"updatePlayerLayout");
    }
}

static Rect FullscreenPlayerFrame(Obj self,Sel cmd) {
    Rect viewport;
    if (FullscreenFillViewport(self,&viewport)) return viewport;
    return ((Rect(*)(Obj,Sel))Original("FQVPlayer","fqx190_originalLandscapeFrame"))(self,cmd);
}

static void FullscreenPlayerLayout(Obj self,Sel cmd) {
    ((void(*)(Obj,Sel))Original("FQVPlayer","fqx190_originalPlayerLayout"))(self,cmd);
    if (Flag(self,"isFullScreen")) V1(FullscreenPlayers(),"addObject:",self);
    FullscreenApplyPlayer(self);
}

static void FullscreenPlayerState(Obj self,Sel cmd,B full) {
    if (!full) FullscreenScale(O0(self,"videoEngine"),0);
    ((void(*)(Obj,Sel,B))Original("FQVPlayer","fqx190_originalPlayerFullscreen:"))(self,cmd,full);
    if (full && FullscreenFillEnabled()) V0(self,"setNeedsLayout");
}

static void FullscreenPlayerEngine(Obj self,Sel cmd,Obj engine) {
    Obj old=O0(self,"videoEngine");
    if (old!=engine) FullscreenScale(old,0);
    ((void(*)(Obj,Sel,Obj))Original("FQVPlayer","fqx190_originalPlayerEngine:"))(self,cmd,engine);
    FullscreenApplyPlayer(self);
}

static void FullscreenRefresh(Obj player) {
    if (Flag(player,"isFullScreen")) V1(FullscreenPlayers(),"addObject:",player);
    B fill=FullscreenApplyPlayer(player);
    if (fill) V0(player,"updatePlayerLayout");
}

static void FullscreenPlayerPrepare(Obj self,Sel cmd,Obj info,B async) {
    // Configure the renderer before preparation creates its native video surface.
    Rect viewport;
    FullscreenScale(O0(self,"videoEngine"),FullscreenFillViewport(self,&viewport));
    ((void(*)(Obj,Sel,Obj,B))Original("FQVPlayer","fqx190_originalPlayerPrepare:async:"))(self,cmd,info,async);
    FullscreenRefresh(self);
}

static void FullscreenPlayerReady(Obj self,Sel cmd,Obj engine) {
    if (engine && engine==O0(self,"videoEngine")) FullscreenRefresh(self);
    ((void(*)(Obj,Sel,Obj))Original("FQVPlayer","fqx190_originalPlayerReady:"))(self,cmd,engine);
    // The host may set its default scale while exposing a prepared frame.
    if (engine && engine==O0(self,"videoEngine")) FullscreenApplyPlayer(self);
}

static void FullscreenCellDisplay(Obj self,Sel cmd) {
    ((void(*)(Obj,Sel))Original("FQVShortVideoLandscapePlayerCellView","fqx190_originalLandscapeDisplay"))(self,cmd);
    Obj player=O0(self,"vPlayer");
    if (player) FullscreenRefresh(player);
}

static void FullscreenFillInstall(void) {
    const char *player="FQVPlayer", *cell="FQVShortVideoLandscapePlayerCellView";
    if (!Signature(player,"isFullScreen","B16@0:8") ||
        !Signature(player,"videoEngine","@16@0:8") ||
        !Signature(player,"landscapePlayerViewFrame","{CGRect={CGPoint=dd}{CGSize=dd}}16@0:8") ||
        !Signature(player,"layoutSubviews","v16@0:8") ||
        !Signature(player,"setIsFullScreen:","v20@0:8B16") ||
        !Signature(player,"setVideoEngine:","v24@0:8@16") ||
        !Signature(player,"updatePlayerLayout","v16@0:8") ||
        !Signature(player,"prepareWithVideoInfo:async:","v28@0:8@16B24") ||
        !Signature(player,"videoEngineReadyToDisPlay:","v24@0:8@16") ||
        !Signature(cell,"vPlayer","@16@0:8") ||
        !Signature(cell,"playerSuperView","@16@0:8") ||
        !Signature(cell,"isInPlayerScaleMode","B16@0:8") ||
        !Signature(cell,"modelDidDisplay","v16@0:8") ||
        !Signature("TTVideoEngine","scaleMode","q16@0:8") ||
        !Signature("TTVideoEngine","setScaleMode:","v24@0:8q16") ||
        !Signature("TTVideoEngine","alignMode","q16@0:8") ||
        !Signature("TTVideoEngine","setAlignMode:","v24@0:8q16")) return;
    Hook("FQVPlayer","landscapePlayerViewFrame","fqx190_originalLandscapeFrame",
         "{CGRect={CGPoint=dd}{CGSize=dd}}16@0:8",(Imp)FullscreenPlayerFrame);
    Hook("FQVPlayer","layoutSubviews","fqx190_originalPlayerLayout","v16@0:8",(Imp)FullscreenPlayerLayout);
    Hook("FQVPlayer","setIsFullScreen:","fqx190_originalPlayerFullscreen:","v20@0:8B16",(Imp)FullscreenPlayerState);
    Hook("FQVPlayer","setVideoEngine:","fqx190_originalPlayerEngine:","v24@0:8@16",(Imp)FullscreenPlayerEngine);
    Hook("FQVPlayer","prepareWithVideoInfo:async:","fqx190_originalPlayerPrepare:async:",
         "v28@0:8@16B24",(Imp)FullscreenPlayerPrepare);
    Hook("FQVPlayer","videoEngineReadyToDisPlay:","fqx190_originalPlayerReady:","v24@0:8@16",(Imp)FullscreenPlayerReady);
    Hook("FQVShortVideoLandscapePlayerCellView","modelDidDisplay","fqx190_originalLandscapeDisplay",
         "v16@0:8",(Imp)FullscreenCellDisplay);
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
    if (!FQDDiagnosticsEnabled()) return 0;
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

static void BottomCompactInstall178R7(void);
static B BottomFlag178(I tag);
static void ReaderScreenshotShare178R14(Obj self,Sel cmd,Obj action) {
    if (BottomFlag178(36)) {
        ((void(*)(Obj,Sel,Obj))Original("SSReadingShareScreenshotPendantView","fqx178r14_originalScreenshotShare:"))(self,cmd,action);
    }
}
void FQHPageInstall(void) {
    Obj cleanup=Lookup("FQXCleanup");
    if (Responds(cleanup,"install")) V0(cleanup,"install");
    Obj videoExport=Lookup("FQXVideoExport");
    if (Responds(videoExport,"install")) V0(videoExport,"install");
    Obj navigationPreferences=Lookup("FQXNavigationPreferences");
    if (Responds(navigationPreferences,"install")) V0(navigationPreferences,"install");
    Hook("SSReadingShareScreenshotPendantView","showWithShareAction:","fqx178r14_originalScreenshotShare:","v24@0:8@?16",(Imp)ReaderScreenshotShare178R14);
    DramaCleanInstall178R11();
    DramaQualityInstall178R11();
    ReaderGlassStyleInstall();
    ReaderThemeIsolationInstall();
    DramaSpacingInstall178R2();
    DramaVisibilityInstall();
    LandscapeGlassInstall178R9();
    DramaDetailGlassInstall();
    FeatureVisibilityInstall178R9();
    Hook("SSShortVideoHostRightInteractionCommentView","layoutSubviews","fqx190_originalDramaCommentLayout","v16@0:8",(Imp)DramaCommentLayout);
    Hook("SSShortVideoRightInteractionLikeView","updateLikeIconHidden:","fqx190_originalDramaLikeVisibility:","v20@0:8B16",(Imp)DramaLikeVisibility);
    Hook("SSShortVideoBottomDistributionView","layoutSubviews","fqx190_originalDramaWatchLayout","v16@0:8",(Imp)DramaWatchLayout);
    Hook("SSShortVideoBottomDistributionView","renderWithModel:","fqx190_originalDramaWatchRender:","v24@0:8@16",(Imp)DramaWatchRender);
    Hook("SSShortVideoAlbumSeriesBottomInsertView","layoutSubviews","fqx192_originalDramaWatchAlbumLayout","v16@0:8",(Imp)DramaWatchAlbumLayout);
    FullscreenFillInstall();
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
    Hook("SSReaderCoverTopRightView","layoutSubviews","fqx186_originalCoverListen","v16@0:8",(Imp)PageCoverListenLayout);
    Hook("FQReaderCoverMainContentViewController","setupGuideView","fqx186_originalCoverGuideSetup","v16@0:8",(Imp)PageCoverGuideSetup);
    Hook("FQReaderCoverMainContentViewController","viewDidLayoutSubviews","fqx186_originalCoverGuideLayout","v16@0:8",(Imp)PageCoverGuideLayout);
    Hook("SSReaderChapterEndDiscussionEntranceView","layoutSubviews","fqx174_originalDiscuss","v16@0:8",(Imp)PageDiscussLayout);
    Hook("SSReaderChapterEndDiscussionEntranceButton","layoutSubviews","fqx174_originalDiscussButton","v16@0:8",(Imp)PageDiscussButtonLayout);
    Hook("SSReaderChapterEndForumEntranceView","layoutSubviews","fqx179r5_originalForumEntrance","v16@0:8",(Imp)PageForumEntranceLayout);
    Hook("SSReaderChapterEndCommunityCardView","layoutSubviews","fqx177_originalChapterCard","v16@0:8",(Imp)PageChapterCardLayout);
    Hook("SSReaderChapterEndCommunityCardView","updateWithReaderConfig:","fqx177_originalChapterCardTheme:","v24@0:8@16",(Imp)PageChapterCardTheme);
    Hook("SSReaderChapterEndBaseButton","layoutSubviews","fqx177_originalChapterButton","v16@0:8",(Imp)PageChapterButtonLayout);
    Hook("SSReaderChapterEndRewardButton","updateWithThemeConfigChange:","fqx177_originalChapterRewardTheme:","v24@0:8@16",(Imp)PageChapterRewardTheme);
    Hook("SSBookShelfTabSelectViewTitleCell","layoutSubviews","fqx174_originalShelfCategory","v16@0:8",(Imp)PageShelfTabLayout);
    InstallShelfTabWillDisplay();
    Hook("SSBookShelfTabSelectViewTitleCell","reloadData:","fqx175_originalShelfTabReload:","v24@0:8@16",(Imp)PageShelfTabReload);
    Hook("SSBookShelfTabSelectViewTitleCell","updateLabelWithModel:","fqx178r11_originalShelfLabel:","v24@0:8@16",(Imp)PageShelfTabUpdate);
    Hook("SSBookShelfTabSelectViewTitleCell","updateLayoutWithModel:","fqx178r11_originalShelfModelLayout:","v24@0:8@16",(Imp)PageShelfTabUpdate);
    Hook("SSBookShelfTabSelectView","refreshCellModel:index:","fqx178r11_originalShelfModel:index:","v32@0:8@16q24",(Imp)PageShelfRefreshModel);
    Hook("SSBookShelfTabSelectView","preferredCellWidthAtIndex:","fqx178r12_originalShelfWidth:","d24@0:8q16",(Imp)ShelfTabWidth);
    Hook("SSBookShelfTabSelectView","refreshSelectedCellModel:unselectedCellModel:","fqx178r11_originalShelfSelected:unselected:","v32@0:8@16@24",(Imp)PageShelfSelectedModels);
    Hook("SSBookShelfTabSelectView","refreshLeftCellModel:rightCellModel:ratio:","fqx178r11_originalShelfLeft:right:ratio:","v40@0:8@16@24d32",(Imp)PageShelfScrollingModels);
    Hook("SSBookShelfFilter541Cell","fontForSelectState:","fqx178r11_originalFilterFont:","@20@0:8B16",(Imp)PageShelfFilterFont);
    Hook("SSBookShelfFilter541Cell","layoutSubviews","fqx175_originalShelfFilterLayout","v16@0:8",(Imp)PageShelfFilterLayout);
    Hook("SSBookShelfFilter541Cell","updateAppearance:","fqx175_originalShelfFilterAppearance:","v20@0:8B16",(Imp)PageShelfFilterAppearance);
    Hook("SSBookShelfFilter541Cell","updateCellBgColor:","fqx175_originalShelfFilterBackground:","v24@0:8@16",(Imp)PageShelfFilterBackground);
    Hook("SSBookShelfFilterHeaderView","layoutSubviews","fqx179_originalShelfFilterHeader","v16@0:8",(Imp)ShelfFilterHeaderLayout);
    Hook("SSBookShelfFilterHeaderView","configFullGenreSelectedModel:categoryOrder:","fqx191_originalShelfFilterConfig:order:","v32@0:8@16@24",(Imp)ShelfFilterHeaderConfigure);
    Hook("SSBookShelfFilterHeaderView","configOptionModel:filterOption:","fqx192_originalShelfFilterOption:filter:","v32@0:8@16@24",(Imp)ShelfFilterHeaderConfigure);
    Hook("SSBookShelfFilterMixRowCollectionView","collectionView:layout:insetForSectionAtIndex:","fqx185_originalInlineFilterInsets:layout:section:","{UIEdgeInsets=dddd}40@0:8@16@24q32",(Imp)ShelfInlineFilterInsets);
    Hook("SSMyUserBar","layoutSubviews","fqx174_originalProfileBar","v16@0:8",(Imp)PageProfileBarLayout);
    Hook("SSCommunityPublishButton","layoutSubviews","fqx188_originalPublishLayout","v16@0:8",(Imp)PublishLayout);
    Hook("SSCommunityPublishButton","traitCollectionDidChange:","fqx188_originalPublishTheme:","v24@0:8@16",(Imp)PublishTheme);
    Hook("SSDoubleRowUgcProduceEntranceView","layoutSubviews","fqx188_originalPublishLayout","v16@0:8",(Imp)PublishLayout);
    Hook("SSDoubleRowUgcProduceEntranceView","traitCollectionDidChange:","fqx188_originalPublishTheme:","v24@0:8@16",(Imp)PublishTheme);
    Hook("SSBookStoreNestedTabView","setPublishButtonView:","fqx188_originalStorePublishButton:","v24@0:8@16",(Imp)BookstorePublishButton);
    Hook("SSBookStoreNestedTabView","setProduceEntranceView:","fqx189_originalStoreProduceEntrance:","v24@0:8@16",(Imp)BookstoreProduceEntrance);
    Hook("SSBookStoreCommunityPublishEntranceComponent","setPublishButton:","fqx188_originalStoreComponentPublish:","v24@0:8@16",(Imp)BookstoreComponentPublishButton);
    Hook("SSMyUser621ViewController","publishButton","fqx188_originalMinePublishButton","@16@0:8",(Imp)ProfilePublishButton);
    Hook("SSMyUser621BaseViewController","updateCollectionLayout","fqx186_originalProfileCollectionLayout","v16@0:8",(Imp)ProfileCollectionLayout);
    Hook("SSMyUser621ViewController","scrollViewDidScroll:","fqx178r9_originalProfileScroll:","v24@0:8@16",(Imp)ProfileScroll);
    Hook("SSMyUserCollectionViewFunCell","layoutSubviews","fqx174_originalProfileEntry","v16@0:8",(Imp)PageProfileEntryLayout);
    Hook("SSMyUserCollectionViewOrderFunCell","layoutSubviews","fqx178_originalProfileOrder","v16@0:8",(Imp)PageProfileOrderLayout);
    Hook("SSMyUserShortcutCell","layoutSubviews","fqx179r1_originalShortcutCardLayout","v16@0:8",(Imp)ProfileShortcutCardLayout);
    Hook("SSMyUserShortcutCell","willMoveToSuperview:","fqx179r1_originalShortcutCardMove:","v24@0:8@16",(Imp)ProfileShortcutCardMove);
    Hook("SSMyUserCollectionView1Cell","layoutSubviews","fqx179r1_originalCard1Layout","v16@0:8",(Imp)ProfileCard1Layout);
    Hook("SSMyUserCollectionView1Cell","willMoveToSuperview:","fqx179r1_originalCard1Move:","v24@0:8@16",(Imp)ProfileCard1Move);
    if (Signature("SSAudioPlayIndicatorView","contentView","@16@0:8") &&
        Signature("SSAudioPlayIndicatorView","backgroundView","@16@0:8") &&
        Signature("SSAudioPlayIndicatorView","backgroundEffectView","@16@0:8")) {
        Hook("SSAudioPlayIndicatorView","layoutSubviews","fqx178r13_originalAudioIndicatorLayout",
            "v16@0:8",(Imp)ReaderAudioIndicatorLayout);
        Hook("SSAudioPlayIndicatorView","willMoveToSuperview:","fqx178r13_originalAudioIndicatorMove:",
            "v24@0:8@16",(Imp)ReaderAudioIndicatorMove);
    }
    Hook("SSMyUser621BaseViewController","setupCellMiniGameEntranceData","fqx174_originalMiniGameSetup","v16@0:8",(Imp)MiniGameSetup);
    Hook("SSMyUserCell2Model","applyConfiguredMineEcomEntranceData:mineMonetizationStyle:","fqx176_originalMineEntrances:style:","v32@0:8@16q24",(Imp)MineConfiguredEntrances);
    Hook("SSMyUser621ViewController","objectsForListAdapter:","fqx176_originalMineListObjects:","@24@0:8@16",(Imp)MineListObjects);
    Hook("SS525BookShelfSubHeaderView","setShowReadTimeView:","fqx177_originalDurationVisible:","v20@0:8B16",(Imp)ShelfDurationVisible);
    Hook("SS525BookShelfSubHeaderView","layoutSubviews","fqx177_originalDurationLayout","v16@0:8",(Imp)ShelfDurationLayout);
    Hook("SS525BookShelfSubHeaderView","updateFilterShow:","fqx191_originalShelfFilterShow:","v20@0:8B16",(Imp)ShelfLegacyFilterShow);
    Hook("SS525BookShelfSubHeaderView","layoutEditButton","fqx185_originalStockEditLayout","v16@0:8",(Imp)ShelfStockEditLayout);
    Hook("SSBookShelfSubViewController","saveOpeningData:indexPath:","fqx185_originalSaveOpeningData:index:","v32@0:8@16@24",(Imp)ShelfSaveOpeningData);
    Hook("SSBookShelfSubViewController","fetchBookCoverTransitionInfo:","fqx185_originalCoverTransition:","@24@0:8Q16",(Imp)ShelfCoverTransitionInfo);
    ShelfCompactInstall();
    BottomCompactInstall178R7();
    DramaBackdropInstall();
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
        Hook("SSBookStoreNewViewController","categoryView:didScrollSelectedItemAtIndex:","fqx186_originalStoreSelected:index:","v32@0:8@16q24",(Imp)BookstoreTabSelected);
        Hook("SSBookStoreTabViewController","setupLayout","fqx186_originalStoreCollectionLayout","v16@0:8",(Imp)BookstoreCollectionLayout);
        Hook("SSBookStoreDoubleRowViewController","viewWillLayoutSubviews","fqx187_originalStoreDoubleRowLayout","v16@0:8",(Imp)BookstoreDoubleRowLayout);
        Hook("SSBookStoreDoubleRowViewController","storeTabScrollViewDidScroll:","fqx187_originalStoreDoubleRowScroll:","v24@0:8@16",(Imp)BookstoreDoubleRowScroll);
        if (Signature("SSBookStoreSearchBarComponent","bookStoreVCContext","@16@0:8"))
            Hook("SSBookStoreSearchBarComponent","resetTopTabSearchViewWithRatio:fromTab:toTab:fromTabTemplate:toTabTemplate:","fqx173_originalSearchColor:from:to:fromTemplate:toTemplate:","v40@0:8d16i24i28i32i36",(Imp)SearchColor);
    }
    // This is the right-hand category ENTRY, not the horizontal category tabs.
    Hook("SSBookStoreCategorySignView","layoutSubviews","fqx173_originalLayout","v16@0:8",(Imp)CategoryLayout);
    Hook("SSBookStoreCategorySignView","resetColorWithRatio:fromTab:toTab:fromTabTemplate:toTabTemplate:","fqx173_originalColor:from:to:fromTemplate:toTemplate:","v40@0:8d16i24i28i32i36",(Imp)CategoryColor);
    Hook("FQReaderSaaSBaseButton","layoutSubviews","fqx170_originalLayout","v16@0:8",(Imp)ShelfButtonLayout);
    Hook("SSBookShelf525ViewController","viewLayout","fqx186_originalShelfTopLayout","v16@0:8",(Imp)BookshelfTopLayout);
    Hook("SSBookShelf525ViewController","tryAddSelectRightView","fqx_originalShelfHeaderRight","v16@0:8",(Imp)BookshelfHeaderRightMounted);
    const char *quick="SSBookShelfFilterMixRowCollectionView";
    Hook(quick,"collectionView:layout:sizeForItemAtIndexPath:","fqx_originalQuickFilterSize:layout:index:",
         "{CGSize=dd}40@0:8@16@24@32",(Imp)ShelfQuickFilterSize);
    Hook(quick,"collectionView:layout:minimumInteritemSpacingForSectionAtIndex:","fqx_originalQuickFilterGap:layout:section:",
         "d40@0:8@16@24q32",(Imp)ShelfQuickFilterGap);
    Obj quickClass=Lookup(quick);
    if (quickClass && !class_getInstanceMethod(quickClass,sel_registerName("collectionView:layout:minimumLineSpacingForSectionAtIndex:")))
        class_addMethod(quickClass,sel_registerName("collectionView:layout:minimumLineSpacingForSectionAtIndex:"),
                        (Imp)ShelfQuickFilterGap,"d40@0:8@16@24q32");
    Hook("SSBookShelf525ViewController","categoryView:didSelectedItemAtIndex:",
         "fqx_originalShelfCommitted:index:","v32@0:8@16q24",(Imp)BookshelfTabCommitted);
    if (Signature("FQRJXCategoryListContainerView","didClickSelectedItemAtIndex:","v24@0:8q16") &&
        Signature("FQRJXCategoryListContainerView","cleanValidListWithIndex:","v24@0:8q16") &&
        Signature("FQRJXCategoryListContainerView","listWillAppear:","v24@0:8q16") &&
        Signature("FQRJXCategoryListContainerView","listDidAppear:","v24@0:8q16") &&
        Signature("FQRJXCategoryListContainerView","clampScrollViewToCurrentIndexIfNeeded","v16@0:8")) {
        BookshelfInstallTitleSelection();
        Hook("FQRJXCategoryListContainerView","layoutSubviews","fqx_originalHistoryPagerLayout",
             "v16@0:8",(Imp)BookshelfHistoryPagerLayout);
        Hook("FQRJXCategoryListContainerView","scrollDidStop","fqx_originalHistoryPagerStopped",
             "v16@0:8",(Imp)BookshelfHistoryPagerStopped);
        class_addMethod(Lookup("FQRJXCategoryListContainerView"),
            sel_registerName("scrollViewDidEndScrollingAnimation:"),
            (Imp)BookshelfHistoryPagerAnimationEnded,"v24@0:8@16");
        Hook("SSBookShelf525ViewController","viewDidAppear:","fqx_originalHistoryShelfAppear:",
             "v20@0:8B16",(Imp)BookshelfHistoryAppear);
    }
    Hook("SSBookShelf525ViewController","categoryView:didScrollSelectedItemAtIndex:","fqx186_originalShelfSelected:index:","v32@0:8@16q24",(Imp)BookshelfTabSelected);
    Hook("SSBookShelfSubViewController","updateCollectionViewInsets","fqx186_originalShelfUpdateInsets","v16@0:8",(Imp)BookshelfUpdateInsets);
    Hook("SSBookShelfSubViewController","updateFullGenreFloatingViewWithScrollView:","fqx186_originalShelfFloating:","v24@0:8@16",(Imp)BookshelfFloatingLayout);
    Hook("SSBookShelfSubViewController","viewDidLayoutSubviews","fqx167_originalShelfLayout","v16@0:8",(Imp)ShelfLayout);
    Hook("SSBookShelfSubViewController","scrollViewDidScroll:","fqx187_originalShelfScroll:","v24@0:8@16",(Imp)ShelfScroll);
    if (Signature("SSNewRefreshHeader","animationView","@16@0:8") &&
        Signature("SSNewRefreshHeader","isRefreshing","B16@0:8")) {
        Hook("SSNewRefreshHeader","setAnimationHidden:","fqx188_originalRefreshHidden:","v20@0:8B16",(Imp)TopChromeRefreshHostHidden);
        Hook("SSNewRefreshHeader","setState:","fqx188_originalRefreshState:","v24@0:8q16",(Imp)TopChromeRefreshState);
        Hook("SSNewRefreshHeader","placeSubviews","fqx188_originalRefreshAnimationLayout","v16@0:8",(Imp)TopChromeRefreshAnimationLayout);
        Hook("SSBookStoreTabViewController","scrollViewDidScroll:","fqx188_originalStoreCollectionScroll:","v24@0:8@16",(Imp)BookstoreCollectionScroll);
    }
    Hook("FQReaderSaasNavigationView","layoutSubviews","fqx167_originalLayout","v16@0:8",(Imp)ReaderLayout);
    Hook("FQReaderSaasNavigationView","readerInsertedViewThemeConfigChange:","fqx167_originalTheme:","v24@0:8@16",(Imp)ReaderTheme);
}

// 1.78 bottom appearance. All geometry belongs to the existing plugin proxy,
// presentation buttons and public segmented control. No player/scroll bounds,
// content insets, host tab models, or native gesture delegates are rewritten.
static void BottomBaseFrame178Key(void) {}
static void BottomAppliedFrame178Key(void) {}
static void BottomButtonStock178Key(void) {}
static void BottomButtonApplied178Key(void) {}
static void BottomButtonProxy178R5Key(void) {}
static void BottomBarBox178Key(void) {}
static void BottomProxyBox178Key(void) {}
static void BottomButtons178Key(void) {}
static void BottomBars178Key(void) {}
static void BottomWindowBarKey(void) {}
static void BottomCompact178Key(void) {}
static void BottomSelectedBox178Key(void) {}
static void BottomDragStart178R7Key(void) {}
static void BottomDragReleasedKey(void) {}
static void BottomDragAttachedKey(void) {}
static void BottomCompactButton178R7Key(void) {}
static void BottomCompactOverlay178R7Key(void) {}
static void BottomSymbol178Key(void) {}
static void BottomSymbolName178Key(void) {}
static void BottomSymbolSize178Key(void) {}
static void BottomHidden178Key(void) {}
static void BottomLabel178Key(void) {}
static void BottomStockImage178Key(void) {}
static void BottomOptionsOwner178Key(void) {}
static void BottomOptionValue178Key(void) {}
static void BottomSettingViews178Key(void) {}
static void SettingsCompactSwitchKey(void) {}
static void BottomSettingsScroll178Key(void) {}
static void BottomLayoutLog178Key(void) {}
static void BottomTitles178R2Key(void) {}
static void BottomTitleFallback178R2Key(void) {}

static Obj BottomDefaults178(void) {
    return O0(Lookup("NSUserDefaults"),"standardUserDefaults");
}
enum { BottomCompactRight, BottomCompactLeft, BottomCompactCenter };
static const char *BottomCompactPositionKey="FanqieX.BottomDramaCompactPosition.1";
static I BottomCompactPosition(void) {
    return ((I(*)(Obj,Sel,Obj))Message)(BottomDefaults178(),sel_registerName("integerForKey:"),
        Text(BottomCompactPositionKey));
}
static Obj BottomPreference178(I tag) {
    if (tag>=DramaCategoryTagBase && tag-DramaCategoryTagBase<=2147483647)
        return DramaCategoryPreference(tag-DramaCategoryTagBase);
    switch (tag) {
        case 1: return Text("FanqieX.BottomIconsOnly.1");
        case 2: return Text("FanqieX.BottomDramaCompact.1");
        case 11: return Text("FanqieX.BottomLengthScale.1");
        case 12: return Text("FanqieX.BottomHeightScale.1");
        case 13: return Text("FanqieX.BottomButtonWidthScale.1");
        case 14: return Text("FanqieX.BottomIconPointSize.1");
        case 21: return PagePreference(DramaCategoriesOption);
        case 22: return PagePreference(DramaSearchOption);
        case 23: return PagePreference(DramaAuthorDeclarationOption);
        case 24: return PagePreference(DramaOriginalNovelOption);
        case 25: return Text("FanqieX.DramaRecommendationReason.1");
        case 26: return Text("FanqieX.MineContinueDrama.1");
        case 27: return Text("FanqieX.ReaderEarnMore.1");
        case 28: return Text("FanqieX.SidebarGames.1");
        case 29: return Text("FanqieX.ShelfMotionComic.1");
        case 15: return Text("FanqieX.DramaActionDiameter.1");
        case 30: return Text("FanqieX.DramaDefaultClean.1");
        case 31: return Text("FanqieX.DramaRevealOnPause.1");
        case 32: return Text("FanqieX.DramaHighestQuality.1");
        case 33: return Text("FanqieX.DramaPureClean.1");
        case 34: return Text("FanqieX.MineQuickIconsOnly.1");
        case 35: return Text("FanqieX.LocalRewardTest.1");
        case 36: return Text("FanqieX.ReaderScreenshotQuickShare.1");
        case 37: return Text("FanqieX.DramaFollowBottomWidth.1");
    }
    return 0;
}
static B BottomFlag178(I tag) {
    Obj value=O1(BottomDefaults178(),"objectForKey:",BottomPreference178(tag));
    return value ? Responds(value,"boolValue") && Flag(value,"boolValue") :
        (tag>=21 && tag<=29) || tag==36 || tag==37 || tag>=DramaCategoryTagBase;
}
static double BottomClamp178(double value,double low,double high) {
    return value<low ? low : value>high ? high : value;
}
static double BottomValue178(I tag) {
    double fallback=tag==15 ? 50 : tag==14 ? 28 : 100;
    Obj value=O1(BottomDefaults178(),"objectForKey:",BottomPreference178(tag));
    if (!Responds(value,"doubleValue")) return fallback;
    double number=Double(value);
    if (!__builtin_isfinite(number)) return fallback;
    double low=tag==15 ? 36 : tag==11 ? 50 : tag==12 ? 80 : tag==13 ? 70 : 16;
    double high=tag==15 ? 54 : tag==12 ? 125 : tag==14 ? 32 : 100;
    return BottomClamp178(number,low,high);
}
static Obj BottomWeak178(Obj object) {
    Obj box=O0(Lookup("NSHashTable"),"weakObjectsHashTable");
    if (object) V1(box,"addObject:",object);
    return box;
}
static Obj BottomWeakValue178(Obj owner,const void *key) {
    return Get(objc_getAssociatedObject(owner,key),"anyObject");
}
static void BottomSetWeak178(Obj owner,const void *key,Obj object) {
    if (BottomWeakValue178(owner,key)==object) return;
    objc_setAssociatedObject(owner,key,object ? BottomWeak178(object) : (Obj)0,1);
}
static Obj BottomBars178(void) {
    Obj defaults=BottomDefaults178(),bars=objc_getAssociatedObject(defaults,BottomBars178Key);
    if (!bars) {
        bars=BottomWeak178(0);
        objc_setAssociatedObject(defaults,BottomBars178Key,bars,1);
    }
    return bars;
}
static B BottomRect178(Rect r) {
    return __builtin_isfinite(r.x) && __builtin_isfinite(r.y) &&
        __builtin_isfinite(r.width) && __builtin_isfinite(r.height) &&
        r.width>0 && r.height>0;
}
static double BottomPixel178(double value,double scale) {
    if (!__builtin_isfinite(scale) || scale<1 || scale>4) scale=1;
    double scaled=value*scale;
    return (double)(I)(scaled+(scaled<0 ? -0.5 : 0.5))/scale;
}
static B BottomVisible178(Obj view,Obj window) {
    if (!view || !window || Get(view,"window")!=window) return 0;
    Obj current=view;
    for (int depth=0;current && depth<24;++depth,current=Get(current,"superview")) {
        if (Flag(current,"isHidden")) return 0;
        double alpha=((double(*)(Obj,Sel))Message)(current,sel_registerName("alpha"));
        if (!__builtin_isfinite(alpha) || alpha<0.99) return 0;
        if (current==window) return 1;
    }
    return 0;
}
static B BottomIsDrama178(Obj owner) {
    if (!Kind(owner,"SSTabBarController")) return 0;
    Obj types=Get(owner,"typeArray"),page=Get(owner,"selectedViewController");
    // currentSelectedVCTabType returns the feed container's selected category.
    // Use the root tab controller's own selection and its parallel type array.
    U count=TabCount(types);
    if (!count || count>8 || !page)
        return Kind(page,"SSShortVideoRcmdMainViewController") ||
            Kind(Get(page,"topViewController"),"SSShortVideoRcmdMainViewController");
    if (Responds(owner,"selectedIndex")) {
        U index=((U(*)(Obj,Sel))Message)(owner,sel_registerName("selectedIndex"));
        if (index<count) return TabOption(owner,At(types,index))==DramaOption;
    }
    Obj controllers=Get(owner,"viewControllers");
    if (TabCount(controllers)!=count) return 0;
    for (U i=0;i<count;++i)
        if (At(controllers,i)==page) return TabOption(owner,At(types,i))==DramaOption;
    return 0;
}
static B BottomDramaOwnsView178R13(Obj page,Obj view) {
    Obj content=Get(page,"viewIfLoaded");
    if (!content) return 0;
    for (Obj node=view;node;node=Get(node,"superview"))
        if (node==content) return 1;
    return 0;
}
static Obj DramaPureCleanDock178R13(Obj view) {
    Obj window=Get(view,"window"),bars=Get(BottomBars178(),"allObjects");
    for (U i=0,n=TabCount(bars);i<n;i++) {
        Obj bar=At(bars,i),owner=Get(bar,"delegate"),page=Get(owner,"selectedViewController");
        if (Get(bar,"window")==window && BottomIsDrama178(owner) && BottomDramaOwnsView178R13(page,view)) return bar;
    }
    return 0;
}
static Obj BottomDramaCapsuleForView(Obj view) {
    Obj window=Get(view,"window"),bar=BottomWeakValue178(window,BottomWindowBarKey);
    if (!bar || !Enabled() || Get(bar,"window")!=window) return 0;
    Obj owner=Get(bar,"delegate");
    if (!BottomIsDrama178(owner) || Get(owner,"presentedViewController") ||
        !BottomDramaOwnsView178R13(Get(owner,"selectedViewController"),view)) return 0;
    Obj proxy=BottomWeakValue178(bar,BottomProxyBox178Key);
    if (Get(proxy,"superview")!=bar) return 0;
    for (Obj node=proxy;node!=window;node=Get(node,"superview")) {
        if (!node || Flag(node,"isHidden") ||
            ((double(*)(Obj,Sel))Message)(node,sel_registerName("alpha"))<0.01) return 0;
    }
    return proxy;
}
static B BottomContainsCapsulePoint(Obj capsule,Point point) {
    Rect bounds=Bounds(capsule);
    return point.x>=bounds.x && point.x<bounds.x+bounds.width &&
        point.y>=bounds.y && point.y<bounds.y+bounds.height;
}
static B BottomDramaSeekShouldBegin(Obj self,Sel cmd,Obj gesture) {
    const char *owner="FQVShortVideoVPlayerControlView";
    if (gesture && Get(self,"progressPanGesture")==gesture) {
        Obj proxy=BottomDramaCapsuleForView(self);
        if (proxy) {
            // Fall back to the initial pan position if the touch filter was bypassed.
            Point point=((Point(*)(Obj,Sel,Obj))Message)(gesture,sel_registerName("locationInView:"),proxy);
            Point movement=((Point(*)(Obj,Sel,Obj))Message)(gesture,sel_registerName("translationInView:"),proxy);
            if (BottomContainsCapsulePoint(proxy,(Point){point.x-movement.x,point.y-movement.y})) return 0;
        }
    }
    return ((B(*)(Obj,Sel,Obj))Original(owner,"fqx178r15_originalDramaSeekShouldBegin:"))(self,cmd,gesture);
}
static B BottomDramaProgressTouch(Obj view,Obj gesture,Obj touch) {
    if (!gesture || Get(view,"progressPanGesture")!=gesture) return 1;
    Obj proxy=BottomDramaCapsuleForView(view);
    return !proxy || !BottomContainsCapsulePoint(proxy,
        ((Point(*)(Obj,Sel,Obj))Message)(touch,sel_registerName("locationInView:"),proxy));
}
static B BottomInnerDramaSeekTouch(Obj self,Sel cmd,Obj gesture,Obj touch) {
    (void)cmd;
    return BottomDramaProgressTouch(self,gesture,touch);
}
static B BottomOuterDramaSeekTouch(Obj self,Sel cmd,Obj gesture,Obj touch) {
    return BottomDramaProgressTouch(self,gesture,touch) &&
        ((B(*)(Obj,Sel,Obj,Obj))Original("SSShortVideoOutterMultiGenreFeedControlView",
            "fqx_originalOuterDramaSeekTouch::"))(self,cmd,gesture,touch);
}
static Obj BottomOuterDramaHit(Obj self,Sel cmd,Point point,Obj event) {
    const char *owner="SSShortVideoOutterMultiGenreFeedControlView";
    Obj proxy=BottomDramaCapsuleForView(self);
    if (proxy) {
        Rect position=Convert(self,(Rect){point.x,point.y,0,0},proxy);
        if (BottomContainsCapsulePoint(proxy,(Point){position.x,position.y})) return 0;
    }
    return ((Obj(*)(Obj,Sel,Point,Obj))Original(owner,"fqx_originalOuterDramaHit::"))(self,cmd,point,event);
}
static Obj BottomDramaWindowHit(Obj self,Sel cmd,Point point,Obj event) {
    Obj hit=((Obj(*)(Obj,Sel,Point,Obj))Original("UIWindow","fqx_originalDramaWindowHit::"))(self,cmd,point,event);
    Obj proxy=BottomDramaCapsuleForView(hit);
    if (!proxy || Get(hit,"window")!=self) return hit;
    Rect local=Convert(self,(Rect){point.x,point.y,0,0},proxy);
    if (!BottomContainsCapsulePoint(proxy,(Point){local.x,local.y})) return hit;
    // Resolve the initial touch before UIKit attaches recognizers to the hit
    // view. Rejecting the seek pan alone cannot retarget it to a sibling dock.
    Obj bar=Get(proxy,"superview");
    for (Obj node=hit; node; node=Get(node,"superview")) {
        if (Kind(node,"FQVShortVideoVPlayerControlView") ||
            Kind(node,"SSShortVideoOutterMultiGenreFeedControlView") ||
            Kind(node,"FQVCollectionView")) {
            Rect inBar=Convert(self,(Rect){point.x,point.y,0,0},bar);
            Obj dockHit=((Obj(*)(Obj,Sel,Point,Obj))Message)(bar,cmd,(Point){inBar.x,inBar.y},event);
            return dockHit && dockHit!=bar && Belongs(dockHit,bar) ? dockHit : hit;
        }
    }
    return hit;
}
static B BottomCompactActive178R7(Obj bar) {
    return BoolProp(objc_getAssociatedObject(bar,BottomCompact178Key),"boolValue");
}
static void BottomSetCompact178(Obj bar,B compact) {
    if (BottomCompactActive178R7(bar)==compact) return;
    Obj proxy=BottomWeakValue178(bar,BottomProxyBox178Key);
    ((void(*)(Obj,Sel,Obj,Obj))Message)(Lookup("FQXDockMotion"),
        sel_registerName("prepareDock:inBar:"),proxy,bar);
    objc_setAssociatedObject(bar,BottomCompact178Key,compact ? BoolBox(1) : (Obj)0,1);
    if (FQDDiagnosticsEnabled()) {
        Obj record=O0(Lookup("NSMutableDictionary"),"dictionary");
        Put(record,"compact",BoolBox(compact));
        Put(record,"videoGeometryChanged",BoolBox(0));
        FQDRecord("bottomCompact178",record);
    }
    V0(bar,"setNeedsLayout");
}
static Obj BottomDramaPage178R7(Obj bar) {
    Obj owner=Get(bar,"delegate"), page=Get(owner,"selectedViewController");
    B pureClean=Get(objc_getAssociatedObject(bar,DramaPureCleanOwner178R13Key),"anyObject")!=0;
    if (!Enabled() || !BottomFlag178(2) || !BottomIsDrama178(owner) ||
        Get(owner,"presentedViewController") || (!pureClean && !BottomVisible178(bar,Get(bar,"window")))) return 0;
    return page;
}
static Obj BottomDramaScrollBar(Obj scroll,const char **reason) {
    Obj window=Get(scroll,"window");
    *reason="feed-not-visible";
    if (!BottomVisible178(scroll,window)) return 0;
    *reason="feed-not-full-width-portrait";
    Rect placed=Convert(scroll,Bounds(scroll),window),screen=Bounds(window);
    if (!BottomRect178(placed) || placed.height<=placed.width ||
        __builtin_fabs(placed.x-screen.x)>=2 || placed.width<screen.width-4 ||
        placed.y>=screen.y+screen.height || placed.y+placed.height<=screen.y) return 0;
    *reason="dock-not-registered";
    Obj bar=BottomWeakValue178(window,BottomWindowBarKey);
    if (!bar || Get(bar,"window")!=window) return 0;
    *reason="dock-not-on-visible-drama-page";
    Obj page=BottomDramaPage178R7(bar);
    if (!page) return 0;
    *reason="feed-outside-selected-page";
    return BottomDramaOwnsView178R13(page,scroll) ? bar : 0;
}
static void BottomDramaDragLog(const char *phase,const char *result,double offset) {
    if (!FQDDiagnosticsEnabled()) return;
    Obj record=O0(Lookup("NSMutableDictionary"),"dictionary");
    Put(record,"phase",Text(phase));
    Put(record,"result",Text(result));
    if (__builtin_isfinite(offset)) Put(record,"offsetY",Number(offset));
    FQDRecord("bottomCompactGesture",record);
}
static double BottomDramaOffsetY(Obj scroll) {
    return ((Point(*)(Obj,Sel))Message)(scroll,sel_registerName("contentOffset")).y;
}
static I BottomDramaPageAtOffset(double offset,double height) {
    return (I)(__builtin_fmax(0,offset)/height+0.5);
}
static void BottomDramaResetDrag(Obj scroll) {
    objc_setAssociatedObject(scroll,BottomDragStart178R7Key,0,1);
    objc_setAssociatedObject(scroll,BottomDragReleasedKey,0,1);
}
static void BottomDramaResolveDrag(Obj scroll) {
    Obj start=objc_getAssociatedObject(scroll,BottomDragReleasedKey);
    if (!start) return;
    Rect bounds=Bounds(scroll);
    double offset=BottomDramaOffsetY(scroll);
    if (!BottomRect178(bounds) || !__builtin_isfinite(offset)) {
        BottomDramaResetDrag(scroll);
        return;
    }
    I origin=(I)Double(start),page=BottomDramaPageAtOffset(offset,bounds.height);
    // The portrait drama feed snaps at multiples of its viewport height.
    // A final bounds change can precede the delegate's idle-state update.
    if (__builtin_fabs(offset-page*bounds.height)>1 ||
        (page==origin && (Flag(scroll,"isDragging") || Flag(scroll,"isDecelerating") ||
            Flag(scroll,"isScrollAnimating")))) return;
    BottomDramaResetDrag(scroll);
    const char *result;
    Obj bar=BottomDramaScrollBar(scroll,&result);
    if (bar) {
        result=page>origin ? "next-page" : page<origin ? "previous-page" : "same-page";
        if (page>origin) BottomSetCompact178(bar,1);
    }
    BottomDramaDragLog("resolve",result,offset);
}
static void BottomDramaDrag(Obj self,Sel cmd,Obj pan) {
    (void)cmd;
    I state=((I(*)(Obj,Sel))Message)(pan,sel_registerName("state"));
    if (state==1) {
        BottomDramaResetDrag(self);
        if (!Enabled() || !BottomFlag178(2)) return;
        double offset=BottomDramaOffsetY(self);
        const char *result;
        Obj bar=BottomDramaScrollBar(self,&result);
        if (bar) {
            if (!__builtin_isfinite(offset)) result="invalid-offset";
            else if (BottomCompactActive178R7(bar)) result="already-compact";
            else {
                result="tracking";
                I page=BottomDramaPageAtOffset(offset,Bounds(self).height);
                objc_setAssociatedObject(self,BottomDragStart178R7Key,Number(page),1);
            }
        }
        BottomDramaDragLog("begin",result,offset);
    } else if (state==3) {
        Obj start=objc_getAssociatedObject(self,BottomDragStart178R7Key);
        if (!start) return;
        objc_setAssociatedObject(self,BottomDragReleasedKey,start,1);
        objc_setAssociatedObject(self,BottomDragStart178R7Key,0,1);
        BottomDramaDragLog("end","waiting-for-page",BottomDramaOffsetY(self));
        BottomDramaResolveDrag(self);
    } else if (state==4 || state==5) {
        BottomDramaResetDrag(self);
    }
}
static void BottomDramaScrollWindow(Obj self,Sel cmd) {
    ((void(*)(Obj,Sel))Original("FQVCollectionView","fqx_originalDramaScrollWindow"))(self,cmd);
    if (!Get(self,"window")) {
        BottomDramaResetDrag(self);
        return;
    }
    if (objc_getAssociatedObject(self,BottomDragAttachedKey)) return;
    Obj pan=Get(self,"panGestureRecognizer");
    if (!pan) return;
    ((void(*)(Obj,Sel,Obj,Sel))Message)(pan,sel_registerName("addTarget:action:"),self,
        sel_registerName("fqx_dramaScrollPan:"));
    objc_setAssociatedObject(self,BottomDragAttachedKey,BoolBox(1),1);
    if (BottomFlag178(2)) BottomDramaDragLog("attach","native-pan",BottomDramaOffsetY(self));
}
static void BottomDramaScrollLayout(Obj self,Sel cmd) {
    ((void(*)(Obj,Sel))Original("FQVCollectionView","fqx_originalDramaScrollLayout"))(self,cmd);
    BottomDramaResolveDrag(self);
}
static void BottomCompactInstall178R7(void) {
    const char *player="FQVShortVideoVPlayerControlView";
    if (Signature(player,"progressPanGesture","@16@0:8")) {
        Hook(player,"gestureRecognizerShouldBegin:","fqx178r15_originalDramaSeekShouldBegin:",
             "B24@0:8@16",(Imp)BottomDramaSeekShouldBegin);
        Obj cls=Lookup(player);
        Sel touch=sel_registerName("gestureRecognizer:shouldReceiveTouch:");
        if (!class_getInstanceMethod(cls,touch))
            class_addMethod(cls,touch,(Imp)BottomInnerDramaSeekTouch,"B32@0:8@16@24");
    }
    const char *outer="SSShortVideoOutterMultiGenreFeedControlView";
    if (Signature(outer,"progressPanGesture","@16@0:8")) {
        Hook(outer,"gestureRecognizer:shouldReceiveTouch:","fqx_originalOuterDramaSeekTouch::",
             "B32@0:8@16@24",(Imp)BottomOuterDramaSeekTouch);
        Hook(outer,"hitTest:withEvent:","fqx_originalOuterDramaHit::",
             "@40@0:8{CGPoint=dd}16@32",(Imp)BottomOuterDramaHit);
    }
    Hook("UIWindow","hitTest:withEvent:","fqx_originalDramaWindowHit::",
         "@40@0:8{CGPoint=dd}16@32",(Imp)BottomDramaWindowHit);
    const char *collection="FQVCollectionView";
    Obj cls=Lookup(collection);
    if (!Signature(collection,"didMoveToWindow","v16@0:8") ||
        !Signature(collection,"layoutSubviews","v16@0:8") ||
        !class_addMethod(cls,sel_registerName("fqx_dramaScrollPan:"),(Imp)BottomDramaDrag,"v24@0:8@16")) return;
    Hook(collection,"layoutSubviews","fqx_originalDramaScrollLayout","v16@0:8",(Imp)BottomDramaScrollLayout);
    if (Signature(collection,"fqx_originalDramaScrollLayout","v16@0:8"))
        Hook(collection,"didMoveToWindow","fqx_originalDramaScrollWindow","v16@0:8",(Imp)BottomDramaScrollWindow);
}
// UIKit derives frame from center and bounds; a fractional pixel can come
// back one representable CGFloat away from the value written by the layout.
B BottomSameFrame178(Rect a,Rect b) {
    const double tolerance=0.125;
    return __builtin_fabs(a.x-b.x)<tolerance && __builtin_fabs(a.y-b.y)<tolerance &&
        __builtin_fabs(a.width-b.width)<tolerance && __builtin_fabs(a.height-b.height)<tolerance;
}
static void BottomRestoreFrame178(Obj view,const void *stockKey,const void *appliedKey) {
    Obj stock=objc_getAssociatedObject(view,stockKey),applied=objc_getAssociatedObject(view,appliedKey);
    if (stock && applied && BottomSameFrame178(Frame(view),UnboxRect(applied))) SetFrame(view,UnboxRect(stock));
    objc_setAssociatedObject(view,stockKey,0,1);
    objc_setAssociatedObject(view,appliedKey,0,1);
}
static void BottomApplyFrame178(Obj view,Rect target,const void *stockKey,const void *appliedKey) {
    Rect current=Frame(view);
    Obj applied=objc_getAssociatedObject(view,appliedKey);
    if (!applied || !BottomSameFrame178(current,UnboxRect(applied)))
        objc_setAssociatedObject(view,stockKey,RectBox(current),1);
    if (!BottomSameFrame178(current,target)) SetFrame(view,target);
    if (!applied || !BottomSameFrame178(target,UnboxRect(applied)))
        objc_setAssociatedObject(view,appliedKey,RectBox(target),1);
}
static Rect BottomTrack178(Rect bounds,U count,B icons) {
    double minimum=icons ? 56 : 64;
    double available=__builtin_fmax(0,bounds.width-8);
    double width=__builtin_fmin(available,__builtin_fmax(count*minimum,
        available*BottomValue178(13)*0.01));
    double height=__builtin_fmin(bounds.height,__builtin_fmax(44,bounds.height-8));
    return (Rect){bounds.x+(bounds.width-width)*0.5,bounds.y+(bounds.height-height)*0.5,width,height};
}
Rect FQHBottomNativeRect178(Obj proxy,Rect bounds) {
    if (!Enabled() || BottomValue178(13)==100 || !BottomRect178(bounds)) return bounds;
    U count=TabCount(objc_getAssociatedObject(proxy,BottomButtons178Key));
    if (!count || count>8) return bounds;
    Rect track=BottomTrack178(bounds,count,BottomFlag178(1));
    return (Rect){track.x-4,bounds.y,track.width+8,bounds.height};
}
void FQHBottomSetNativeFrame178R14(Obj control,Rect target) {
    if (!BottomSameFrame178(Frame(control),target)) SetFrame(control,target);
}
B FQHBottomDragCanRoute178(Obj bar,Obj buttons,Obj button) {
    U index=((U(*)(Obj,Sel,Obj))Message)(buttons,sel_registerName("indexOfObjectIdenticalTo:"),button);
    Obj items=Get(bar,"items");
    if (index>=TabCount(items) || !Flag(button,"isEnabled")) return 0;
    Obj item=At(items,index);
    return item!=Get(bar,"selectedItem") && (!Responds(item,"isEnabled") || Flag(item,"isEnabled"));
}
B FQHBottomUsesNativeTracking178R15(void) {
    Obj bundle=O0(Lookup("NSBundle"),"mainBundle");
    Obj compatibility=O1(bundle,"objectForInfoDictionaryKey:",Text("UIDesignRequiresCompatibility"));
    if (Flag(compatibility,"boolValue")) return 0;
    Obj sdk=O1(bundle,"objectForInfoDictionaryKey:",Text("DTSDKName"));
    if (!Kind(sdk,"NSString") ||
        !((B(*)(Obj,Sel,Obj))Message)(sdk,sel_registerName("hasPrefix:"),Text("iphoneos"))) return 0;
    Obj version=((Obj(*)(Obj,Sel,U))Message)(sdk,sel_registerName("substringFromIndex:"),8);
    return Double(version)>=26;
}
double FQHBottomDragOffset178R15(Obj pan,Obj overlay,Rect selected) {
    Point finger=((Point(*)(Obj,Sel,Obj))Message)(pan,sel_registerName("locationInView:"),overlay);
    Point translation=((Point(*)(Obj,Sel,Obj))Message)(pan,sel_registerName("translationInView:"),overlay);
    double start=finger.x-translation.x;
    return start>=selected.x && start<=selected.x+selected.width ?
        BottomClamp178(start-(selected.x+selected.width*0.5),-8,8) : 0;
}
static void BottomDragPreview178R15Key(void) {}
static void BottomDragSpring178R15(Obj layer,const char *path,Obj from,double duration) {
    Obj key=Text(path),spring=O1(Lookup("CASpringAnimation"),"animationWithKeyPath:",key);
    V1(spring,"setFromValue:",from);
    ((void(*)(Obj,Sel,double))Message)(spring,sel_registerName("setStiffness:"),380.);
    ((void(*)(Obj,Sel,double))Message)(spring,sel_registerName("setDamping:"),31.);
    ((void(*)(Obj,Sel,double))Message)(spring,sel_registerName("setDuration:"),duration);
    ((void(*)(Obj,Sel,Obj,Obj))Message)(layer,sel_registerName("addAnimation:forKey:"),spring,key);
}
void FQHBottomLiftLens178R15(Obj lens,Obj overlay) {
    Obj layer=Get(lens,"layer");
    V1(layer,"removeAnimationForKey:",Text("position"));
    Rect frame=Frame(lens),limit=Bounds(overlay),start=Bounds(lens);
    Rect lifted={frame.x-4,frame.y-3,frame.width+8,frame.height+6};
    lifted.width=BottomClamp178(lifted.width,frame.width,limit.width);
    lifted.height=BottomClamp178(lifted.height,frame.height,limit.height);
    lifted.x=BottomClamp178(lifted.x,limit.x,limit.x+limit.width-lifted.width);
    lifted.y=BottomClamp178(lifted.y,limit.y,limit.y+limit.height-lifted.height);
    SetFrame(lens,lifted);
    BottomDragSpring178R15(layer,"bounds",RectBox(start),0.24);
}
void FQHBottomRememberDrag178R15(Obj lens) {
    Obj presentation=Get(Get(lens,"layer"),"presentationLayer");
    Rect frame=Frame(presentation ? presentation : lens);
    objc_setAssociatedObject(lens,BottomDragPreview178R15Key,RectBox(frame),1);
}
void FQHBottomSnapDrag178R15(Obj lens,Rect target) {
    Obj preview=objc_getAssociatedObject(lens,BottomDragPreview178R15Key);
    if (!BottomSameFrame178(Frame(lens),target)) SetFrame(lens,target);
    if (!preview) return;
    Rect from=UnboxRect(preview);
    objc_setAssociatedObject(lens,BottomDragPreview178R15Key,0,1);
    Obj layer=Get(lens,"layer");
    Point center={from.x+from.width*0.5,from.y+from.height*0.5};
    Rect bounds=Bounds(lens);
    Rect start={bounds.x,bounds.y,from.width,from.height};
    Obj value=((Obj(*)(Obj,Sel,Point))Message)(Lookup("NSValue"),sel_registerName("valueWithCGPoint:"),center);
    BottomDragSpring178R15(layer,"position",value,0.32);
    BottomDragSpring178R15(layer,"bounds",RectBox(start),0.32);
}
void FQHBottomDragAppearance178(Obj lens,B dragging) {
    Obj effect=Get(lens,"effect"),overlay=Get(lens,"superview");
    if (dragging && !effect) {
        // Clear glass samples the live dock and page underneath the moving lens.
        effect=((Obj(*)(Obj,Sel,I))Message)(Lookup("UIGlassEffect"),sel_registerName("effectWithStyle:"),1);
        if (effect) {
            VB(effect,"setInteractive:",1);
            Obj content=Get(lens,"contentView");
            V1(content,"setBackgroundColor:",O0(Lookup("UIColor"),"clearColor"));
            VB(content,"setClipsToBounds:",0);
            V1(lens,"setEffect:",effect);
        }
    }
    if (dragging && effect) {
        if (Get(Get(overlay,"subviews"),"lastObject")!=lens) V1(overlay,"bringSubviewToFront:",lens);
        return;
    }
    if (effect) {
        V1(lens,"setEffect:",0);
        V1(overlay,"sendSubviewToBack:",lens);
    }
    Obj content=Get(lens,"contentView");
    Obj fill=O0(Lookup("UIColor"),"secondarySystemFillColor");
    if (!SameColor(Get(content,"backgroundColor"),fill)) V1(content,"setBackgroundColor:",fill);
    Rect bounds=Bounds(lens);
    double radius=(bounds.width<bounds.height ? bounds.width : bounds.height)*0.5;
    if (Radius(content)!=radius) SetRadius(content,radius);
    if (!Flag(content,"clipsToBounds")) VB(content,"setClipsToBounds:",1);
}
static B BottomOwnsButton178(Obj button,Obj proxy,Obj bar) {
    if (!Kind(button,"UIButton")) return 0;
    Obj parent=Get(button,"superview");
    return parent==proxy || parent==Get(proxy,"contentView") ||
        (parent && Get(parent,"superview")==bar);
}
static B BottomCustom178R5(B compact) {
    return compact || BottomValue178(11)!=100 || BottomValue178(12)!=100 || BottomValue178(13)!=100;
}
// The legacy layout calculates stock button frames before the capsule frame.
// Convert at those existing write boundaries, so UIKit never observes a stock
// size followed by a custom size during a single layout/tracking transaction.
static Rect BottomTarget178R5(Obj bar,Rect base,U count,B compact) {
    Rect available=Bounds(bar);
    if (!BottomRect178(base) || !BottomRect178(available) || !count || count>8 ||
        !BottomCustom178R5(compact)) return base;
    B icons=BottomFlag178(1);
    double maximum=__builtin_fmin(base.width,available.width-8);
    // Once the dock reaches the top of its host bar, retain at least 12 pt
    // of the original bottom clearance, or all of it on a tighter host.
    double stockGap=(available.y+available.height)-(base.y+base.height);
    double bottomGap=BottomClamp178(stockGap,0,12);
    double bottom=available.y+available.height-bottomGap;
    double high=__builtin_fmin(70,available.height-bottomGap);
    if (maximum<=0 || high<44) return base;
    double minimum=count*(icons ? 56 : 64)+8;
    double width=compact ? __builtin_fmin(60,__builtin_fmin(maximum,high)) :
        BottomClamp178(base.width*BottomValue178(11)*0.01,__builtin_fmin(minimum,maximum),maximum);
    double height=compact ? width : BottomClamp178(base.height*BottomValue178(12)*0.01,
        __builtin_fmin(48,high),high);
    double x=available.x+(available.width-width)*0.5;
    if (compact) {
        I position=BottomCompactPosition();
        if (position==BottomCompactLeft) x=__builtin_fmax(base.x,available.x+8);
        else if (position!=BottomCompactCenter)
            x=__builtin_fmin(base.x+base.width,available.x+available.width-8)-width;
    }
    double scale=((double(*)(Obj,Sel))Message)(Get(Get(bar,"window"),"screen"),sel_registerName("scale"));
    if (scale<1) scale=((double(*)(Obj,Sel))Message)(Get(bar,"traitCollection"),sel_registerName("displayScale"));
    return (Rect){BottomPixel178(x,scale),
        BottomPixel178(BottomClamp178(base.y+base.height-height,available.y,
            bottom-height),scale),BottomPixel178(width,scale),BottomPixel178(height,scale)};
}
static Rect BottomDramaEpisodeDockFrame(Obj view) {
    if (!BottomFlag178(37)) return (Rect){0};
    Obj dock=BottomDramaCapsuleForView(view), parent=Get(view,"superview");
    if (!dock || !parent) return (Rect){0};
    Obj bar=Get(dock,"superview");
    if (!BottomCompactActive178R7(bar)) return Convert(dock,Bounds(dock),parent);
    Obj base=objc_getAssociatedObject(dock,BottomBaseFrame178Key);
    if (!base) return (Rect){0};
    U count=TabCount(objc_getAssociatedObject(dock,BottomButtons178Key));
    return Convert(bar,BottomTarget178R5(bar,UnboxRect(base),count,0),parent);
}
static void BottomRememberRect178R5(Obj view,const void *key,Rect rect) {
    Obj saved=objc_getAssociatedObject(view,key);
    if (!saved || !BottomSameFrame178(UnboxRect(saved),rect))
        objc_setAssociatedObject(view,key,RectBox(rect),1);
}
static B BottomReverse178R5(Obj buttons,U count) {
    Obj first=At(buttons,0),last=At(buttons,count-1);
    Obj savedFirst=objc_getAssociatedObject(first,BottomButtonStock178Key);
    Obj savedLast=objc_getAssociatedObject(last,BottomButtonStock178Key);
    Rect a=savedFirst ? UnboxRect(savedFirst) : Frame(first);
    Rect b=savedLast ? UnboxRect(savedLast) : Frame(last);
    return count>1 && a.x+a.width*0.5>b.x+b.width*0.5;
}
Rect FQHBottomProxyFrame178R5(Obj proxy,Rect stock) {
    Obj bar=BottomWeakValue178(proxy,BottomBarBox178Key);
    U count=TabCount(objc_getAssociatedObject(proxy,BottomButtons178Key));
    if (!Enabled() || !Kind(bar,"SSTabBar") || Get(proxy,"superview")!=bar ||
        !BottomRect178(stock) || !count || count>8) return stock;
    Rect target=BottomTarget178R5(bar,stock,count,BottomCompactActive178R7(bar));
    // Incoming host geometry is authoritative, including a rotated/new dock.
    // Never recover this baseline from the already customized current frame.
    BottomRememberRect178R5(proxy,BottomBaseFrame178Key,stock);
    BottomRememberRect178R5(proxy,BottomAppliedFrame178Key,target);
    return target;
}
Rect FQHBottomButtonFrame178R5(Obj button,Rect stock) {
    Obj proxy=BottomWeakValue178(button,BottomButtonProxy178R5Key);
    Obj bar=BottomWeakValue178(proxy,BottomBarBox178Key);
    Obj buttons=objc_getAssociatedObject(proxy,BottomButtons178Key);
    U count=TabCount(buttons),index=count;
    if (!Enabled() || !Kind(bar,"SSTabBar") || Get(proxy,"superview")!=bar ||
        !BottomOwnsButton178(button,proxy,bar) || !BottomRect178(stock) || !count || count>8)
        return stock;
    for (U i=0;i<count;++i) if (At(buttons,i)==button) { index=i; break; }
    if (index==count) return stock;
    BottomRememberRect178R5(button,BottomButtonStock178Key,stock);
    Rect target=stock;
    Obj saved=objc_getAssociatedObject(proxy,BottomBaseFrame178Key);
    B compact=BottomCompactActive178R7(bar);
    if (saved && BottomCustom178R5(compact)) {
        Rect capsule=BottomTarget178R5(bar,UnboxRect(saved),count,compact),bounds=Bounds(proxy);
        if (BottomRect178(capsule)) {
            bounds.width=capsule.width; bounds.height=capsule.height;
            Rect track=BottomTrack178(bounds,count,BottomFlag178(1));
            double slot=track.width/count;
            U visualIndex=BottomReverse178R5(buttons,count) ? count-1-index : index;
            target=(Rect){track.x+slot*visualIndex,track.y,slot,track.height};
        }
    }
    BottomRememberRect178R5(button,BottomButtonApplied178Key,target);
    return target;
}
static void BottomRestoreHidden178(Obj view) {
    Obj saved=objc_getAssociatedObject(view,BottomHidden178Key);
    if (saved && Flag(view,"isHidden")) VB(view,"setHidden:",Flag(saved,"boolValue"));
    objc_setAssociatedObject(view,BottomHidden178Key,0,1);
}
static void BottomHide178(Obj view) {
    if (!view) return;
    if (!objc_getAssociatedObject(view,BottomHidden178Key))
        objc_setAssociatedObject(view,BottomHidden178Key,BoolBox(Flag(view,"isHidden")),1);
    if (!Flag(view,"isHidden")) VB(view,"setHidden:",1);
}
static void BottomRestoreTitles178R2(Obj button) {
    Obj saved=objc_getAssociatedObject(button,BottomTitles178R2Key);
    if (TabCount(saved)!=32) return;
    Obj currentNormalAttribute=((Obj(*)(Obj,Sel,U))Message)(button,sel_registerName("attributedTitleForState:"),0);
    // Restore normal last: the public getters fall back to normal for an
    // unset state, so restoring it first would disguise an owned nil value.
    for (U index=16;index>0;--index) {
        U state=index-1;
        Obj title=((Obj(*)(Obj,Sel,U))Message)(button,sel_registerName("titleForState:"),state);
        Obj attributed=((Obj(*)(Obj,Sel,U))Message)(button,sel_registerName("attributedTitleForState:"),state);
        // The empty string and nil attributed title are the exact values we
        // own. A newer nonempty title written by a host sync takes precedence.
        B owned=Equal(title,"");
        if (owned) {
            Obj original=At(saved,state*2);
            ((void(*)(Obj,Sel,Obj,U))Message)(button,sel_registerName("setTitle:forState:"),
                Kind(original,"NSNull") ? (Obj)0 : original,state);
        }
        if (owned && (!attributed || (state && attributed==currentNormalAttribute))) {
            Obj original=At(saved,state*2+1);
            if (!Kind(original,"NSNull"))
                ((void(*)(Obj,Sel,Obj,U))Message)(button,sel_registerName("setAttributedTitle:forState:"),original,state);
        }
    }
    objc_setAssociatedObject(button,BottomTitles178R2Key,0,1);
}
static void BottomSuppressTitles178R2(Obj button,Obj title) {
    // UIButton owns titleLabel.hidden and can reset it in a later layout or
    // highlight update. Suppress its public content states instead of relying
    // on the timing of a parent layout. Keep the original routing and a11y.
    Obj previous=objc_getAssociatedObject(button,BottomTitles178R2Key);
    if (TabCount(previous)==32) {
        B changed=0;
        for (U state=0;state<16;++state) {
            Obj current=((Obj(*)(Obj,Sel,U))Message)(button,sel_registerName("titleForState:"),state);
            Obj attributed=((Obj(*)(Obj,Sel,U))Message)(button,sel_registerName("attributedTitleForState:"),state);
            if (!Equal(current,"") || attributed) changed=1;
        }
        // Settled layouts do not toggle titles or invalidate intrinsic sizes.
        if (!changed) return;
        BottomRestoreTitles178R2(button);
    }
    Obj saved=O0(Lookup("NSMutableArray"),"array"),null=O0(Lookup("NSNull"),"null");
    Obj empty=Text("");
    if (!saved || !null || !empty) return;
    for (U state=0;state<16;++state) {
        Obj original=((Obj(*)(Obj,Sel,U))Message)(button,sel_registerName("titleForState:"),state);
        Obj attributed=((Obj(*)(Obj,Sel,U))Message)(button,sel_registerName("attributedTitleForState:"),state);
        V1(saved,"addObject:",original ? original : null);
        V1(saved,"addObject:",attributed ? attributed : null);
        // The UIKit getters return normal when a state has no override. Clear
        // normal after saving it so those inherited values remain nil in our
        // snapshot, rather than becoming stale explicit overrides on restore.
        if (!state) {
            ((void(*)(Obj,Sel,Obj,U))Message)(button,sel_registerName("setTitle:forState:"),(Obj)0,0);
            if (attributed)
                ((void(*)(Obj,Sel,Obj,U))Message)(button,sel_registerName("setAttributedTitle:forState:"),(Obj)0,0);
        }
    }
    objc_setAssociatedObject(button,BottomTitles178R2Key,saved,1);
    if (title) objc_setAssociatedObject(button,BottomTitleFallback178R2Key,title,1);
    for (U state=0;state<16;++state) {
        ((void(*)(Obj,Sel,Obj,U))Message)(button,sel_registerName("setTitle:forState:"),empty,state);
        if (!Kind(At(saved,state*2+1),"NSNull"))
            ((void(*)(Obj,Sel,Obj,U))Message)(button,sel_registerName("setAttributedTitle:forState:"),(Obj)0,state);
    }
}
static void BottomNativeTitles178R2(Obj native) {
    if (!Kind(native,"UISegmentedControl") || !Responds(native,"titleTextAttributesForState:")) return;
    Obj clear=O0(Lookup("UIColor"),"clearColor"),key=Text("NSColor");
    for (U state=0;state<16;++state) {
        Obj current=((Obj(*)(Obj,Sel,U))Message)(native,sel_registerName("titleTextAttributesForState:"),state);
        if (SameColor(O1(current,"objectForKey:",key),clear)) continue;
        Obj attributes=current ? O0(current,"mutableCopy") : O0(Lookup("NSMutableDictionary"),"new");
        if (!attributes) continue;
        ((void(*)(Obj,Sel,Obj,Obj))Message)(attributes,sel_registerName("setObject:forKey:"),clear,key);
        ((void(*)(Obj,Sel,Obj,U))Message)(native,sel_registerName("setTitleTextAttributes:forState:"),attributes,state);
        V0(attributes,"release");
    }
}
static void BottomRestoreSymbol178(Obj button) {
    BottomRestoreTitles178R2(button);
    Obj symbol=objc_getAssociatedObject(button,BottomSymbol178Key);
    if (Get(symbol,"superview")==button) V0(symbol,"removeFromSuperview");
    BottomRestoreHidden178(objc_getAssociatedObject(button,BottomLabel178Key));
    BottomRestoreHidden178(objc_getAssociatedObject(button,BottomStockImage178Key));
    objc_setAssociatedObject(button,BottomSymbol178Key,0,1);
    objc_setAssociatedObject(button,BottomSymbolName178Key,0,1);
    objc_setAssociatedObject(button,BottomSymbolSize178Key,0,1);
    objc_setAssociatedObject(button,BottomLabel178Key,0,1);
    objc_setAssociatedObject(button,BottomStockImage178Key,0,1);
    objc_setAssociatedObject(button,BottomTitleFallback178R2Key,0,1);
}
static Obj BottomTitle178(Obj item,Obj button) {
    Obj title=Get(item,"title");
    if (!Kind(title,"NSString") || !((U(*)(Obj,Sel))Message)(title,sel_registerName("length")))
        title=Get(button,"currentTitle");
    if (!Kind(title,"NSString") || !((U(*)(Obj,Sel))Message)(title,sel_registerName("length")))
        title=objc_getAssociatedObject(button,BottomTitleFallback178R2Key);
    if (!title) title=Get(Get(button,"titleLabel"),"text");
    return title;
}
static const char *BottomSymbolName178(Obj title,B selected) {
    if (Equal(title,"书城") || Equal(title,"首页")) return selected ? "house.fill" : "house";
    if (Equal(title,"短剧") || Equal(title,"视频")) return selected ? "play.rectangle.fill" : "play.rectangle";
    if (Equal(title,"书架")) return selected ? "books.vertical.fill" : "books.vertical";
    if (Equal(title,"我的")) return selected ? "person.fill" : "person";
    if (Equal(title,"商城")) return selected ? "bag.fill" : "bag";
    if (Equal(title,"短句")) return selected ? "text.bubble.fill" : "text.bubble";
    return 0;
}
static void BottomSymbol178(Obj button,Obj item,B icons,double size) {
    if (!icons) { BottomRestoreSymbol178(button); return; }
    Obj title=BottomTitle178(item,button);
    const char *name=BottomSymbolName178(title,BoolProp(button,"isSelected"));
    Obj symbol=objc_getAssociatedObject(button,BottomSymbol178Key);
    Obj signature=name ? Text(name) : Get(button,"currentImage");
    if (!signature) { BottomRestoreSymbol178(button); return; }
    B changed=!symbol || !((B(*)(Obj,Sel,Obj))Message)(signature,sel_registerName("isEqual:"),
        objc_getAssociatedObject(button,BottomSymbolName178Key)) ||
        Double(objc_getAssociatedObject(button,BottomSymbolSize178Key))!=size;
    Obj image=0;
    if (changed) {
        if (name) {
            Obj config=((Obj(*)(Obj,Sel,double,I,I))Message)(Lookup("UIImageSymbolConfiguration"),
                sel_registerName("configurationWithPointSize:weight:scale:"),size,4,2);
            if (Responds(Lookup("UIImage"),"systemImageNamed:withConfiguration:"))
                image=((Obj(*)(Obj,Sel,Obj,Obj))Message)(Lookup("UIImage"),
                    sel_registerName("systemImageNamed:withConfiguration:"),signature,config);
        } else image=signature;
        if (!image) { BottomRestoreSymbol178(button); return; }
        image=((Obj(*)(Obj,Sel,I))Message)(image,sel_registerName("imageWithRenderingMode:"),2);
    }
    if (!symbol) {
        symbol=O0(Lookup("UIImageView"),"new");
        if (!symbol) return;
        VB(symbol,"setUserInteractionEnabled:",0);
        VB(symbol,"setIsAccessibilityElement:",0);
        VB(symbol,"setAccessibilityElementsHidden:",1);
        Q1(symbol,"setContentMode:",1);
        V1(button,"addSubview:",symbol);
        objc_setAssociatedObject(button,BottomSymbol178Key,symbol,1);
        V0(symbol,"release");
    }
    if (changed) {
        V1(symbol,"setImage:",image);
        objc_setAssociatedObject(button,BottomSymbolName178Key,signature,1);
        objc_setAssociatedObject(button,BottomSymbolSize178Key,Number(size),1);
    }
    Obj label=Get(button,"titleLabel"),stockImage=Get(button,"imageView");
    Obj old=objc_getAssociatedObject(button,BottomLabel178Key);
    if (old!=label) {
        BottomRestoreHidden178(old);
        objc_setAssociatedObject(button,BottomLabel178Key,label,1);
    }
    old=objc_getAssociatedObject(button,BottomStockImage178Key);
    if (old!=stockImage) {
        BottomRestoreHidden178(old);
        objc_setAssociatedObject(button,BottomStockImage178Key,stockImage,1);
    }
    BottomHide178(label);
    BottomHide178(stockImage);
    Rect b=Bounds(button);
    Rect frame={b.x+(b.width-size)*0.5,b.y+(b.height-size)*0.5,size,size};
    if (!SameRect(Frame(symbol),frame)) SetFrame(symbol,frame);
    Obj foreground=O0(Lookup("UIColor"),"labelColor");
    if (!SameColor(Get(symbol,"tintColor"),foreground)) V1(symbol,"setTintColor:",foreground);
    if (title && !((B(*)(Obj,Sel,Obj))Message)(title,sel_registerName("isEqual:"),Get(button,"accessibilityLabel")))
        V1(button,"setAccessibilityLabel:",title);
    BottomSuppressTitles178R2(button,title);
    // The native selector owns accessibility when active; its original,
    // transparent segment titles remain intact. Fallback buttons keep theirs.
}
static void BottomVisualFrame178R7Key(void) {}
static void BottomVisualCompact178R7Key(void) {}
static void BottomSyncMotion178(Obj bar,Obj proxy,Obj buttons,Obj native,Obj lens) {
    Obj motion=Lookup("FQXDockMotion");
    if (motion)
        ((void(*)(Obj,Sel,Obj,Obj,Obj,Obj,Obj))Message)(motion,
            sel_registerName("syncTabBar:proxy:buttons:native:lens:"),bar,proxy,buttons,native,lens);
}

void FQHBottomPolish178R7(Obj proxy,Obj native,Obj lens) {
    if (lens) BottomSyncMotion178(0,proxy,0,native,lens);
    Rect frame=Frame(proxy);
    Obj lastFrame=objc_getAssociatedObject(proxy,BottomVisualFrame178R7Key);
    Obj lastCompact=objc_getAssociatedObject(proxy,BottomVisualCompact178R7Key);
    B compact=BottomCompactActive178R7(BottomWeakValue178(proxy,BottomBarBox178Key));
    if (lastFrame && lastCompact && BoolProp(lastCompact,"boolValue")!=compact) {
        Obj bar=BottomWeakValue178(proxy,BottomBarBox178Key);
        Obj button=objc_getAssociatedObject(bar,BottomCompactButton178R7Key);
        ((void(*)(Obj,Sel,Obj,Rect,B,Obj))Message)(Lookup("FQXDockMotion"),
            sel_registerName("animateDock:fromFrame:compact:button:"),proxy,UnboxRect(lastFrame),compact,button);
    }
    if (!lastFrame || !SameRect(UnboxRect(lastFrame),frame))
        objc_setAssociatedObject(proxy,BottomVisualFrame178R7Key,RectBox(frame),1);
    if (!lastCompact || BoolProp(lastCompact,"boolValue")!=compact)
        objc_setAssociatedObject(proxy,BottomVisualCompact178R7Key,BoolBox(compact),1);
    // The lifecycle installs the same adaptive Regular material for both
    // renderers. UIKit resolves the system palette against each page's traits.
    if (!Enabled() || !BottomFlag178(1)) return;
    Obj color=O0(Lookup("UIColor"),"secondarySystemFillColor");
    if (native && !SameColor(Get(native,"selectedSegmentTintColor"),color))
        V1(native,"setSelectedSegmentTintColor:",color);
    Obj content=Get(lens,"contentView");
    if (content && !Get(lens,"effect") && !SameColor(Get(content,"backgroundColor"),color))
        V1(content,"setBackgroundColor:",color);
}
void FQHBottomPrepare(Obj bar,Obj proxy,Obj buttons) {
    if (!Kind(bar,"SSTabBar") || Get(proxy,"superview")!=bar) return;
    if (!Enabled()) { FQHBottomReset178(bar,proxy); return; }
    U count=TabCount(buttons);
    if (!count || count>8 || !BottomRect178(Frame(proxy)) || !BottomRect178(Bounds(bar))) return;
    Obj previousButtons=objc_getAssociatedObject(proxy,BottomButtons178Key);
    U previousCount=TabCount(previousButtons);
    for (U i=0;i<previousCount && i<8;++i) {
        Obj previous=At(previousButtons,i);
        B retained=0;
        for (U j=0;j<count;++j) if (At(buttons,j)==previous) retained=1;
        if (!retained) {
            BottomRestoreSymbol178(previous);
            objc_setAssociatedObject(previous,BottomButtonProxy178R5Key,0,1);
        }
    }
    // LNtitle needs genuine button strings only if UITabBarItem.title is
    // unavailable. Restore for that synchronous sync, then Finish suppresses
    // them before UIKit commits a frame. Normal repeated layouts do not churn
    // button content or intrinsic size invalidations.
    Obj items=Get(bar,"items");
    U itemCount=TabCount(items);
    for (U i=0;i<count;++i) {
        Obj button=At(buttons,i);
        if (BottomOwnsButton178(button,proxy,bar))
            BottomSetWeak178(button,BottomButtonProxy178R5Key,proxy);
        Obj title=itemCount==count ? Get(At(items,i),"title") : (Obj)0;
        if ((!Kind(title,"NSString") || !((U(*)(Obj,Sel))Message)(title,sel_registerName("length"))) &&
            BottomOwnsButton178(button,proxy,bar)) BottomRestoreTitles178R2(button);
    }
    BottomSetWeak178(proxy,BottomBarBox178Key,bar);
    BottomSetWeak178(bar,BottomProxyBox178Key,proxy);
    Obj window=Get(bar,"window");
    if (window) BottomSetWeak178(window,BottomWindowBarKey,bar);
    objc_setAssociatedObject(proxy,BottomButtons178Key,buttons,1);
    V1(BottomBars178(),"addObject:",bar);
    Obj page=BottomDramaPage178R7(bar);
    if (!page || BottomWeakValue178(bar,BottomSelectedBox178Key)!=page) {
        BottomSetCompact178(bar,0);
        BottomSetWeak178(bar,BottomSelectedBox178Key,page);
    }
    B icons=BottomFlag178(1);
    Obj saved=objc_getAssociatedObject(proxy,BottomBaseFrame178Key);
    Obj applied=objc_getAssociatedObject(proxy,BottomAppliedFrame178Key);
    Rect current=Frame(proxy),base=saved ? UnboxRect(saved) : current;
    if (!applied || !BottomSameFrame178(current,UnboxRect(applied))) {
        base=current;
        objc_setAssociatedObject(proxy,BottomBaseFrame178Key,RectBox(base),1);
    }
    B compact=BottomCompactActive178R7(bar);
    if (!BottomCustom178R5(compact)) {
        BottomRestoreFrame178(proxy,BottomBaseFrame178Key,BottomAppliedFrame178Key);
        Obj content=Get(proxy,"contentView");
        if (content && !BottomSameFrame178(Frame(content),Bounds(proxy))) SetFrame(content,Bounds(proxy));
        for (U i=0;i<count;++i) BottomRestoreFrame178(At(buttons,i),BottomButtonStock178Key,BottomButtonApplied178Key);
        return;
    }
    Rect target=BottomTarget178R5(bar,base,count,compact);
    if (!BottomSameFrame178(current,target)) SetFrame(proxy,target);
    BottomRememberRect178R5(proxy,BottomAppliedFrame178Key,target);
    Obj content=Get(proxy,"contentView");
    Rect bounds=Bounds(proxy);
    // Public contentView, never a UIKit internal backdrop subview. Update it
    // before selector layout so both renderers observe the same coordinates.
    if (content && !BottomSameFrame178(Frame(content),bounds)) SetFrame(content,bounds);
    Rect track=BottomTrack178(bounds,count,icons);
    double slot=track.width/count;
    // Capture all unadapted host writes before choosing direction. Adapters
    // run button-by-button, so partially updated presentation frames cannot
    // reliably indicate a new RTL order until the full host pass completes.
    for (U i=0;i<count;++i) {
        Obj button=At(buttons,i),previous=objc_getAssociatedObject(button,BottomButtonApplied178Key);
        if (BottomOwnsButton178(button,proxy,bar) && (!previous || !BottomSameFrame178(Frame(button),UnboxRect(previous))))
            BottomRememberRect178R5(button,BottomButtonStock178Key,Frame(button));
    }
    B reversed=BottomReverse178R5(buttons,count);
    for (U i=0;i<count;++i) {
        Obj button=At(buttons,i);
        if (!BottomOwnsButton178(button,proxy,bar)) continue;
        U visualIndex=reversed ? count-1-i : i;
        Rect frame={track.x+slot*visualIndex,track.y,slot,track.height};
        BottomApplyFrame178(button,frame,BottomButtonStock178Key,BottomButtonApplied178Key);
    }
}
static void BottomExpand178R7(Obj button,Sel cmd,Obj sender) {
    (void)cmd; (void)sender;
    Obj bar=BottomWeakValue178(button,BottomBarBox178Key);
    if (bar && Get(button,"superview")==bar && objc_getAssociatedObject(bar,BottomCompactButton178R7Key)==button)
        BottomSetCompact178(bar,0);
}
static Obj BottomCompactButton178R7(Obj bar) {
    Obj button=objc_getAssociatedObject(bar,BottomCompactButton178R7Key);
    if (button) return button;
    Obj cls=Lookup("FanqieXCompactBottomButton178R7");
    if (!cls) {
        cls=AllocateClass(Lookup("UIButton"),"FanqieXCompactBottomButton178R7",0);
        if (!cls) return 0;
        class_addMethod(cls,sel_registerName("fqx178R7_expandBottom:"),(Imp)BottomExpand178R7,"v24@0:8@16");
        RegisterClass(cls);
    }
    Obj config=((Obj(*)(Obj,Sel,double,I,I))Message)(Lookup("UIImageSymbolConfiguration"),
        sel_registerName("configurationWithPointSize:weight:scale:"),24.,5,2);
    Obj image=((Obj(*)(Obj,Sel,Obj,Obj))Message)(Lookup("UIImage"),
        sel_registerName("systemImageNamed:withConfiguration:"),Text("play.rectangle.fill"),config);
    if (!image) return 0;
    button=O0(cls,"new");
    if (!button) return 0;
    SetSpeechImage(button,image);
    V1(button,"setTintColor:",O0(Lookup("UIColor"),"whiteColor"));
    V1(button,"setAccessibilityLabel:",Text("展开底栏"));
    BottomSetWeak178(button,BottomBarBox178Key,bar);
    ((void(*)(Obj,Sel,Obj,Sel,U))Message)(button,sel_registerName("addTarget:action:forControlEvents:"),
        button,sel_registerName("fqx178R7_expandBottom:"),64);
    objc_setAssociatedObject(bar,BottomCompactButton178R7Key,button,1);
    V0(button,"release");
    return button;
}
static void BottomCompactPresentation178R7(Obj bar,Obj proxy,Obj buttons,Obj native) {
    B compact=BottomCompactActive178R7(bar);
    Obj content=Get(proxy,"contentView"), overlay=0, button=0;
    if (compact) {
        button=BottomCompactButton178R7(bar);
        if (!button) BottomSetCompact178(bar,0);
        else if (!native) {
            Obj parent=Get(At(buttons,0),"superview");
            if (parent && parent!=proxy && Get(parent,"superview")==bar) overlay=parent;
        }
    }
    Obj previous=BottomWeakValue178(bar,BottomCompactOverlay178R7Key);
    if (previous!=overlay) {
        BottomRestoreHidden178(previous);
        BottomSetWeak178(bar,BottomCompactOverlay178R7Key,overlay);
    }
    if (!button) {
        BottomRestoreHidden178(content);
        Obj oldButton=objc_getAssociatedObject(bar,BottomCompactButton178R7Key);
        if (Get(oldButton,"superview")==bar) V0(oldButton,"removeFromSuperview");
        return;
    }
    // Keep the glass itself and the native selection objects mounted. The
    // compact button alone receives touches until the original tabs expand.
    BottomHide178(content);
    BottomHide178(overlay);
    Rect frame=Frame(proxy);
    if (!SameRect(Frame(button),frame)) SetFrame(button,frame);
    if (Get(button,"superview")!=bar) V1(bar,"addSubview:",button);
    else if (Get(Get(bar,"subviews"),"lastObject")!=button) V1(bar,"bringSubviewToFront:",button);
}
void FQHBottomFinish(Obj bar,Obj proxy,Obj buttons,Obj native) {
    if (!Enabled()) { FQHBottomReset178(bar,proxy); return; }
    U count=TabCount(buttons);
    if (!count || count>8 || Get(proxy,"superview")!=bar) return;
    B icons=Enabled() && BottomFlag178(1);
    if (icons) BottomNativeTitles178R2(native);
    Obj items=Get(bar,"items");
    double size=BottomValue178(14);
    I style=((I(*)(Obj,Sel))Message)(proxy,sel_registerName("overrideUserInterfaceStyle"));
    for (U i=0;i<count;++i) {
        Obj button=At(buttons,i);
        if (BottomOwnsButton178(button,proxy,bar)) {
            // Fallback buttons are in a sibling overlay, outside the proxy's
            // trait subtree. Give them the same page-local appearance.
            Obj parent=Get(button,"superview");
            I buttonStyle=parent==proxy || parent==Get(proxy,"contentView") ? 0 : style;
            if (((I(*)(Obj,Sel))Message)(button,sel_registerName("overrideUserInterfaceStyle"))!=buttonStyle)
                Q1(button,"setOverrideUserInterfaceStyle:",buttonStyle);
            BottomSymbol178(button,TabCount(items)==count ? At(items,i) : (Obj)0,icons,size);
        }
    }
    BottomCompactPresentation178R7(bar,proxy,buttons,native);
    BottomSyncMotion178(bar,proxy,buttons,native,0);
    if (FQDDiagnosticsEnabled() && (icons || BottomValue178(11)!=100 || BottomValue178(12)!=100 ||
        BottomFlag178(2))) {
        Obj record=O0(Lookup("NSMutableDictionary"),"dictionary");
        Put(record,"iconsOnly",BoolBox(icons)); Put(record,"autoCompact",BoolBox(BottomFlag178(2)));
        if (icons) Put(record,"titleSuppression",Text("controlStates178R2"));
        Put(record,"compact",BoolBox(BoolProp(objc_getAssociatedObject(bar,BottomCompact178Key),"boolValue")));
        Put(record,"frame",RectArray(Frame(proxy))); Put(record,"iconPointSize",Number(size));
        Put(record,"buttonWidthPercent",Number(BottomValue178(13)));
        Put(record,"renderer",Text(native ? "native" : "buttons"));
        Put(record,"compactTrigger",Text("nativePanAndSettledOffset"));
        Obj previous=objc_getAssociatedObject(proxy,BottomLayoutLog178Key);
        if (!previous || !((B(*)(Obj,Sel,Obj))Message)(previous,sel_registerName("isEqual:"),record)) {
            FQDRecord("bottomAppearance178",record);
            objc_setAssociatedObject(proxy,BottomLayoutLog178Key,record,1);
        }
    }
}
void FQHBottomReset178(Obj bar,Obj proxy) {
    BottomSyncMotion178(bar,proxy,0,0,0);
    BottomSetCompact178(bar,0);
    BottomSetWeak178(bar,BottomSelectedBox178Key,0);
    BottomCompactPresentation178R7(bar,proxy,0,0);
    objc_setAssociatedObject(bar,BottomCompactButton178R7Key,0,1);
    Obj buttons=objc_getAssociatedObject(proxy,BottomButtons178Key);
    U count=TabCount(buttons);
    for (U i=0;i<count && i<8;++i) {
        Obj button=At(buttons,i);
        BottomRestoreSymbol178(button);
        BottomRestoreFrame178(button,BottomButtonStock178Key,BottomButtonApplied178Key);
        objc_setAssociatedObject(button,BottomButtonProxy178R5Key,0,1);
    }
    BottomRestoreFrame178(proxy,BottomBaseFrame178Key,BottomAppliedFrame178Key);
    Obj content=Get(proxy,"contentView");
    if (content && BottomRect178(Bounds(proxy)) && !BottomSameFrame178(Frame(content),Bounds(proxy)))
        SetFrame(content,Bounds(proxy));
    objc_setAssociatedObject(proxy,BottomButtons178Key,0,1);
    objc_setAssociatedObject(proxy,BottomLayoutLog178Key,0,1);
}

static void BottomRefresh178(void) {
    Obj bars=Get(BottomBars178(),"allObjects");
    U count=TabCount(bars);
    for (U i=0;i<count;++i) {
        Obj bar=At(bars,i);
        if (!BottomFlag178(2)) BottomSetCompact178(bar,0);
        V0(bar,"setNeedsLayout");
    }
}
static void DramaFollowWidthRefresh178(void) {
    BottomRefresh178();
    Obj roots=Get(DramaPureCleanRoots178R13(0),"allObjects");
    for (U i=0,n=TabCount(roots);i<n;++i) V0(At(roots,i),"setNeedsLayout");
    Obj motion=Lookup("FQXDockMotion");
    if (Responds(motion,"refreshDramaControls")) V0(motion,"refreshDramaControls");
}
static Obj BottomValueText178(I tag) {
    Obj value=Get(Number(BottomValue178(tag)),"stringValue");
    return O1(value,"stringByAppendingString:",Text(tag==14 || tag==15 ? " pt" : "%"));
}
static void SettingsUpdateCompactPosition(Obj owner);
void FQHBottomOptionChanged178(Obj self,Sel cmd,Obj sender) {
    (void)cmd;
    I tag=((I(*)(Obj,Sel))Message)(sender,sel_registerName("tag"));
    Obj key=BottomPreference178(tag);
    if (!key) return;
    B changed;
    if (tag==1 || tag==2 || tag>=21) {
        B value=BoolProp(sender,"isOn");
        changed=BottomFlag178(tag)!=value;
        if (changed || !O1(BottomDefaults178(),"objectForKey:",key)) SetDefault(key,value);
        if (tag==2 && changed) SettingsUpdateCompactPosition(self);
        if (tag>=21) {
            if (changed) {
                if (tag<=25 || tag>=DramaCategoryTagBase) DramaVisibilityRefresh();
                else if (tag<=29) FeatureVisibilityRefresh178R9(tag);
                else if (tag==30 || tag==33) DramaPureCleanRefresh178R13();
                else if (tag==34) FQHRefreshMineQuickAppearance178R13();
                else if (tag==37) DramaFollowWidthRefresh178();
            }
            return;
        }
    }
    else {
        float raw=((float(*)(Obj,Sel))Message)(sender,sel_registerName("value"));
        if (!__builtin_isfinite(raw)) return;
        double value=(double)(I)(raw+0.5);
        // Persist the clamped canonical value even if an external defaults
        // editor or a future UIKit slider sends a value outside its range.
        value=BottomClamp178(value,tag==15 ? 36 : tag==11 ? 50 : tag==12 ? 80 : tag==13 ? 70 : 16,
            tag==15 ? 54 : tag==12 ? 125 : tag==14 ? 32 : 100);
        changed=BottomValue178(tag)!=value;
        Obj stored=O1(BottomDefaults178(),"objectForKey:",key);
        // Preserve an explicit choice even if it equals today's fallback, and
        // replace noncanonical defaults without scheduling redundant layouts.
        if (!Responds(stored,"doubleValue") || !__builtin_isfinite(Double(stored)) || Double(stored)!=value)
            ((void(*)(Obj,Sel,double,Obj))Message)(BottomDefaults178(),
            sel_registerName("setDouble:forKey:"),value,key);
        Obj label=objc_getAssociatedObject(sender,BottomOptionValue178Key);
        V1(label,"setText:",BottomValueText178(tag));
        if (tag==15) {
            if (changed) FQHRefreshDramaActions178R11();
            return;
        }
        if (tag==11 && changed && BottomFlag178(37)) {
            DramaFollowWidthRefresh178();
            return;
        }
    }
    // Coalesce on the run loop; never force layout from an active slider or
    // scroll recognizer callback, and ignore duplicate rounded slider values.
    if (changed) BottomRefresh178();
}
void FQHBottomOptionsReset178(Obj self,Sel cmd,Obj sender) {
    (void)cmd; (void)sender;
    Obj defaults=BottomDefaults178();
    for (I tag=1;tag<=14;++tag) {
        Obj key=BottomPreference178(tag);
        if (key) V1(defaults,"removeObjectForKey:",key);
    }
    V1(defaults,"removeObjectForKey:",BottomPreference178(37));
    V1(defaults,"removeObjectForKey:",Text(BottomCompactPositionKey));
    Obj controls=objc_getAssociatedObject(self,BottomSettingViews178Key);
    U count=TabCount(controls);
    for (U i=0;i<count;++i) {
        Obj control=At(controls,i);
        I tag=((I(*)(Obj,Sel))Message)(control,sel_registerName("tag"));
        if (tag==37) {
            ((void(*)(Obj,Sel,B,B))Message)(control,sel_registerName("setOn:animated:"),1,1);
            continue;
        }
        if (tag>=21 || tag==15) continue;
        if (tag<10) ((void(*)(Obj,Sel,B,B))Message)(control,sel_registerName("setOn:animated:"),0,1);
        else {
            ((void(*)(Obj,Sel,float,B))Message)(control,sel_registerName("setValue:animated:"),(float)BottomValue178(tag),1);
            V1(objc_getAssociatedObject(control,BottomOptionValue178Key),"setText:",BottomValueText178(tag));
        }
    }
    SettingsUpdateCompactPosition(BottomWeakValue178(self,BottomOptionsOwner178Key));
    DramaFollowWidthRefresh178();
}
static Obj BottomSettingsLabel178(Obj parent,Rect frame,const char *text,double point,B secondary) {
    Obj label=O0(Lookup("UILabel"),"new");
    SetFrame(label,frame);
    V1(label,"setText:",Text(text));
    V1(label,"setFont:",((Obj(*)(Obj,Sel,double))Message)(Lookup("UIFont"),sel_registerName("systemFontOfSize:"),point));
    V1(label,"setTextColor:",O0(Lookup("UIColor"),secondary ? "secondaryLabelColor" : "labelColor"));
    Q1(label,"setNumberOfLines:",0);
    Q1(label,"setAutoresizingMask:",2);
    V1(parent,"addSubview:",label);
    V0(label,"release");
    return label;
}
static void BottomSettingsSwitch178(Obj controller,Obj parent,double y,I tag,const char *title,const char *detail) {
    double width=Bounds(parent).width;
    BottomSettingsLabel178(parent,(Rect){20,y,width-106,28},title,16,0);
    if (detail) BottomSettingsLabel178(parent,(Rect){20,y+33,width-40,38},detail,12,1);
    Obj toggle=O0(Lookup("UISwitch"),"new");
    SettingsPlaceSwitch178R14(toggle,width,y+14.5);
    Q1(toggle,"setAutoresizingMask:",1);
    Q1(toggle,"setTag:",tag);
    ((void(*)(Obj,Sel,B,B))Message)(toggle,sel_registerName("setOn:animated:"),BottomFlag178(tag),0);
    V1(toggle,"setAccessibilityLabel:",Text(title));
    ((void(*)(Obj,Sel,Obj,Sel,U))Message)(toggle,sel_registerName("addTarget:action:forControlEvents:"),
        controller,sel_registerName("fqx178_bottomOptionChanged:"),4096);
    V1(parent,"addSubview:",toggle);
    V1(objc_getAssociatedObject(controller,BottomSettingViews178Key),"addObject:",toggle);
    if (tag==2) objc_setAssociatedObject(controller,SettingsCompactSwitchKey,toggle,1);
    V0(toggle,"release");
}
static void BottomSettingsSlider178(Obj controller,Obj parent,double y,I tag,const char *title,float low,float high) {
    double width=Bounds(parent).width;
    BottomSettingsLabel178(parent,(Rect){20,y,width-126,24},title,15,0);
    Obj value=BottomSettingsLabel178(parent,(Rect){width-106,y,86,24},"",14,1);
    Q1(value,"setTextAlignment:",2);
    Q1(value,"setAutoresizingMask:",1);
    V1(value,"setText:",BottomValueText178(tag));
    Obj slider=O0(Lookup("UISlider"),"new");
    SetFrame(slider,(Rect){20,y+29,width-40,44});
    Q1(slider,"setAutoresizingMask:",2);
    Q1(slider,"setTag:",tag);
    ((void(*)(Obj,Sel,float))Message)(slider,sel_registerName("setMinimumValue:"),low);
    ((void(*)(Obj,Sel,float))Message)(slider,sel_registerName("setMaximumValue:"),high);
    ((void(*)(Obj,Sel,float,B))Message)(slider,sel_registerName("setValue:animated:"),(float)BottomValue178(tag),0);
    V1(slider,"setAccessibilityLabel:",Text(title));
    objc_setAssociatedObject(slider,BottomOptionValue178Key,value,1);
    ((void(*)(Obj,Sel,Obj,Sel,U))Message)(slider,sel_registerName("addTarget:action:forControlEvents:"),
        controller,sel_registerName("fqx178_bottomOptionChanged:"),4096);
    V1(parent,"addSubview:",slider);
    V1(objc_getAssociatedObject(controller,BottomSettingViews178Key),"addObject:",slider);
    V0(slider,"release");
}
static const double BottomSettingsHeight178R7=1070;
static void BottomSettingsLoad178(Obj self,Sel cmd) {
    Method base=class_getInstanceMethod(Lookup("UIViewController"),sel_registerName("viewDidLoad"));
    if (base) ((void(*)(Obj,Sel))method_getImplementation(base))(self,cmd);
    Obj root=Get(self,"view");
    Rect frame=Bounds(root);
    if (frame.width<240) frame=Bounds(O0(Lookup("UIScreen"),"mainScreen"));
    if (frame.width<240) frame=(Rect){0,0,390,844};
    V1(root,"setBackgroundColor:",O0(Lookup("UIColor"),"systemGroupedBackgroundColor"));
    V1(self,"setTitle:",Text("外观"));
    Obj controls=O0(Lookup("NSMutableArray"),"array");
    objc_setAssociatedObject(self,BottomSettingViews178Key,controls,1);
    Obj scroll=O0(Lookup("UIScrollView"),"new");
    objc_setAssociatedObject(self,BottomSettingsScroll178Key,scroll,1);
    SetFrame(scroll,frame);
    Q1(scroll,"setAutoresizingMask:",2|16);
    VB(scroll,"setAlwaysBounceVertical:",1);
    V1(root,"addSubview:",scroll);
    Obj content=O0(Lookup("UIView"),"new");
    SetFrame(content,(Rect){0,0,frame.width,BottomSettingsHeight178R7});
    Q1(content,"setAutoresizingMask:",2);
    V1(scroll,"addSubview:",content);
    ((void(*)(Obj,Sel,Size))Message)(scroll,sel_registerName("setContentSize:"),(Size){frame.width,BottomSettingsHeight178R7});
    BottomSettingsLabel178(content,(Rect){20,18,frame.width-40,28},"显示方式",19,0);
    BottomSettingsSwitch178(self,content,66,1,"底栏仅显示图标","开启后隐藏文字，保留原入口和朗读名称。");
    BottomSettingsSwitch178(self,content,152,34,"我的快捷入口仅显示图标","订单、历史、消息等入口使用居中的图标。");
    BottomSettingsLabel178(content,(Rect){20,252,frame.width-40,28},"悬浮底栏尺寸",19,0);
    BottomSettingsSwitch178(self,content,294,37,"查看全集与进度条跟随底栏长度","开启后查看全集与进度条宽度自动对齐底栏长度。");
    BottomSettingsSlider178(self,content,382,11,"胶囊长度",50,100);
    BottomSettingsSlider178(self,content,468,12,"胶囊高度",80,125);
    BottomSettingsSlider178(self,content,554,13,"按钮宽度",70,100);
    BottomSettingsSlider178(self,content,640,14,"图标大小",16,32);
    BottomSettingsLabel178(content,(Rect){20,724,frame.width-40,60},
        "按钮宽度调整胶囊内的按钮区域。过小的尺寸会自动保留点击空间；尺寸即时生效。",12,1);
    Obj reset=((Obj(*)(Obj,Sel,I))Message)(Lookup("UIButton"),sel_registerName("buttonWithType:"),1);
    SetFrame(reset,(Rect){20,800,frame.width-40,48});
    Q1(reset,"setAutoresizingMask:",2);
    ((void(*)(Obj,Sel,Obj,U))Message)(reset,sel_registerName("setTitle:forState:"),Text("恢复底栏默认设置"),0);
    ((void(*)(Obj,Sel,Obj,Sel,U))Message)(reset,sel_registerName("addTarget:action:forControlEvents:"),
        self,sel_registerName("fqx178_resetBottom:"),64);
    V1(content,"addSubview:",reset);
    BottomSettingsLabel178(content,(Rect){20,878,frame.width-40,28},"短剧右侧互动区",19,0);
    BottomSettingsSlider178(self,content,920,15,"短剧右侧互动按钮大小",36,54);
    BottomSettingsLabel178(content,(Rect){20,999,frame.width-40,50},
        "同步调整收藏、评论、点赞、分享的玻璃底板和图标。",12,1);
    V0(content,"release");
    V0(scroll,"release");
}
static void BottomSettingsLayout178(Obj self,Sel cmd) {
    Method base=class_getInstanceMethod(Lookup("UIViewController"),sel_registerName("viewDidLayoutSubviews"));
    if (base) ((void(*)(Obj,Sel))method_getImplementation(base))(self,cmd);
    Obj scroll=objc_getAssociatedObject(self,BottomSettingsScroll178Key);
    Rect bounds=Bounds(Get(self,"view"));
    if (!scroll || !BottomRect178(bounds)) return;
    if (!SameRect(Frame(scroll),bounds)) SetFrame(scroll,bounds);
    ((void(*)(Obj,Sel,Size))Message)(scroll,sel_registerName("setContentSize:"),(Size){bounds.width,BottomSettingsHeight178R7});
}
static Obj BottomSettingsClass178(void) {
    Obj cls=Lookup("FanqieXBottomAppearance178Controller");
    if (cls) return cls;
    cls=AllocateClass(Lookup("UIViewController"),"FanqieXBottomAppearance178Controller",0);
    if (!cls) return 0;
    class_addMethod(cls,sel_registerName("viewDidLoad"),(Imp)BottomSettingsLoad178,"v16@0:8");
    class_addMethod(cls,sel_registerName("viewDidLayoutSubviews"),(Imp)BottomSettingsLayout178,"v16@0:8");
    class_addMethod(cls,sel_registerName("fqx178_bottomOptionChanged:"),(Imp)FQHBottomOptionChanged178,"v24@0:8@16");
    class_addMethod(cls,sel_registerName("fqx178_resetBottom:"),(Imp)FQHBottomOptionsReset178,"v24@0:8@16");
    RegisterClass(cls);
    return cls;
}
static void BottomOpenSettings178(Obj self,Sel cmd,Obj sender) {
    (void)cmd; (void)sender;
    Obj owner=BottomWeakValue178(self,BottomOptionsOwner178Key),nav=Get(owner,"navigationController");
    if (!nav || Get(owner,"presentedViewController")) return;
    Obj controller=O0(BottomSettingsClass178(),"new");
    if (!controller) return;
    BottomSetWeak178(controller,BottomOptionsOwner178Key,owner);
    V1(controller,"setTitle:",Text("外观"));
    ((void(*)(Obj,Sel,Obj,B))Message)(nav,sel_registerName("pushViewController:animated:"),controller,1);
    V0(controller,"release");
}
static void OpenTelegramChannel178(Obj self,Sel cmd,Obj sender) {
    (void)self; (void)cmd; (void)sender;
    Obj url=O1(Lookup("NSURL"),"URLWithString:",Text("https://t.me/Naloiafeed"));
    Obj app=O0(Lookup("UIApplication"),"sharedApplication");
    Obj options=O0(Lookup("NSDictionary"),"dictionary");
    ((void(*)(Obj,Sel,Obj,Obj,Obj))Message)(app,
        sel_registerName("openURL:options:completionHandler:"),url,options,0);
}
static Obj OptionsEntry178(Obj container,Obj observer,Rect frame,const char *title,const char *label,const char *action) {
    Obj button=((Obj(*)(Obj,Sel,I))Message)(Lookup("UIButton"),sel_registerName("buttonWithType:"),1);
    SetFrame(button,frame);
    Q1(button,"setAutoresizingMask:",2);
    ((void(*)(Obj,Sel,Obj,U))Message)(button,sel_registerName("setTitle:forState:"),Text(title),0);
    V1(button,"setAccessibilityLabel:",Text(label));
    ((void(*)(Obj,Sel,Obj,Sel,U))Message)(button,sel_registerName("addTarget:action:forControlEvents:"),
        observer,sel_registerName(action),64);
    objc_setAssociatedObject(button,BottomOptionsOwner178Key,observer,1);
    V1(container,"addSubview:",button);
    return button;
}
static void SettingsHeader178R13Key(void) {}
static void SettingsSearch178R13Key(void) {}
static void SettingsGroups178R13Key(void) {}
static void SettingsAdPageKey(void) {}
static void SettingsCompactPositionRowKey(void) {}

static I SettingsNativeSection(Obj owner,I section) {
    return objc_getAssociatedObject(owner,SettingsAdPageKey) ? section : 3;
}
static I SettingsSectionCount(Obj self,Sel cmd,Obj table) {
    (void)cmd; (void)table;
    return objc_getAssociatedObject(self,SettingsAdPageKey) ? 3 : 1;
}
static I SettingsRowCount(Obj self,Sel cmd,Obj table,I section) {
    return ((I(*)(Obj,Sel,Obj,I))Original("FanqieAdBlockOptionsController",
        "fqx_originalSettingsRows:section:"))(self,cmd,table,SettingsNativeSection(self,section));
}
static Obj SettingsSectionTitle(Obj self,Sel cmd,Obj table,I section) {
    return ((Obj(*)(Obj,Sel,Obj,I))Original("FanqieAdBlockOptionsController",
        "fqx_originalSettingsHeader:section:"))(self,cmd,table,SettingsNativeSection(self,section));
}
static Obj SettingsSectionFooter(Obj self,Sel cmd,Obj table,I section) {
    return ((Obj(*)(Obj,Sel,Obj,I))Original("FanqieAdBlockOptionsController",
        "fqx_originalSettingsFooter:section:"))(self,cmd,table,SettingsNativeSection(self,section));
}
static Obj SettingsNativeCell(Obj self,Sel cmd,Obj table,Obj path) {
    if (!objc_getAssociatedObject(self,SettingsAdPageKey)) {
        I row=((I(*)(Obj,Sel))Message)(path,sel_registerName("row"));
        path=((Obj(*)(Obj,Sel,I,I))Message)(Lookup("NSIndexPath"),sel_registerName("indexPathForRow:inSection:"),row,3);
    }
    return ((Obj(*)(Obj,Sel,Obj,Obj))Original("FanqieAdBlockOptionsController",
        "fqx_originalSettingsCell:path:"))(self,cmd,table,path);
}
static void SettingsInstallSections(void) {
    const char *cls="FanqieAdBlockOptionsController";
    Hook(cls,"numberOfSectionsInTableView:","fqx_originalSettingsSections:","q24@0:8@16",(Imp)SettingsSectionCount);
    Hook(cls,"tableView:numberOfRowsInSection:","fqx_originalSettingsRows:section:","q32@0:8@16q24",(Imp)SettingsRowCount);
    Hook(cls,"tableView:titleForHeaderInSection:","fqx_originalSettingsHeader:section:","@32@0:8@16q24",(Imp)SettingsSectionTitle);
    Hook(cls,"tableView:titleForFooterInSection:","fqx_originalSettingsFooter:section:","@32@0:8@16q24",(Imp)SettingsSectionFooter);
    Hook(cls,"tableView:cellForRowAtIndexPath:","fqx_originalSettingsCell:path:","@32@0:8@16@24",(Imp)SettingsNativeCell);
}

static void SettingsOpenAds(Obj router,Sel cmd,Obj sender) {
    (void)cmd; (void)sender;
    Obj owner=BottomWeakValue178(router,BottomOptionsOwner178Key);
    Obj navigation=Get(owner,"navigationController");
    if (!navigation) return;
    Obj page=((Obj(*)(Obj,Sel,I))Message)(O0(Lookup("FanqieAdBlockOptionsController"),"alloc"),sel_registerName("initWithStyle:"),2);
    objc_setAssociatedObject(page,SettingsAdPageKey,BoolBox(1),1);
    V1(page,"setTitle:",Text("广告与福利"));
    ((void(*)(Obj,Sel,Obj,B))Message)(navigation,sel_registerName("pushViewController:animated:"),page,1);
    V0(page,"release");
}

static void SettingsContentWidth178R14(Obj controller) {
    Obj menu=Lookup("FQXSettingsMenu");
    if (Responds(menu,"isInstalledOnController:") &&
        ((B(*)(Obj,Sel,Obj))Message)(menu,sel_registerName("isInstalledOnController:"),controller)) return;
    Obj table=Get(controller,"tableView"),header=objc_getAssociatedObject(controller,SettingsHeader178R13Key);
    Obj footer=Get(table,"tableFooterView");
    double width=Bounds(table).width;
    Obj navigationView=Get(Get(controller,"navigationController"),"viewIfLoaded");
    double viewportWidth=navigationView ? Bounds(navigationView).width : width;
    if (viewportWidth>0 && viewportWidth<width) width=viewportWidth;
    if (!header || !footer || width<240 || !__builtin_isfinite(width)) return;
    // UITableView owns the header and footer frames. Size the plugin's content
    // directly so a change to either wrapper cannot expand the cards twice.
    Obj search=objc_getAssociatedObject(controller,SettingsSearch178R13Key);
    Rect frame=Frame(search);
    if (frame.width!=width-32) {
        frame.width=width-32;
        SetFrame(search,frame);
    }
    Obj groups=objc_getAssociatedObject(header,SettingsGroups178R13Key);
    for (U i=0,count=TabCount(groups);i<count;++i) {
        Obj group=At(groups,i);
        frame=Frame(group);
        if (frame.width!=width-40) {
            frame.width=width-40;
            SetFrame(group,frame);
        }
    }
    Obj card=At(Get(footer,"subviews"),0);
    frame=Frame(card);
    if (frame.width!=width-40) {
        frame.width=width-40;
        SetFrame(card,frame);
    }
}

static void SettingsDidLayout178R14(Obj self,Sel cmd) {
    Method saved=class_getInstanceMethod(object_getClass(self),sel_registerName("fqx178r14_originalSettingsLayout"));
    ((void(*)(Obj,Sel))method_getImplementation(saved))(self,cmd);
    SettingsContentWidth178R14(self);
}

static void SettingsInstallLayout178R14(Obj controller) {
    Obj cls=object_getClass(controller);
    const char *type="v16@0:8";
    Sel layout=sel_registerName("viewDidLayoutSubviews");
    Sel saved=sel_registerName("fqx178r14_originalSettingsLayout");
    if (!ClassABI(cls,"viewDidLayoutSubviews",type) || class_getInstanceMethod(cls,saved)) return;
    Method method=class_getInstanceMethod(cls,layout);
    if (!class_addMethod(cls,saved,method_getImplementation(method),type)) return;
    if (!class_addMethod(cls,layout,(Imp)SettingsDidLayout178R14,type)) {
        Method own=FQDResolveOwned(cls,layout,0,type);
        if (own) method_setImplementation(own,(Imp)SettingsDidLayout178R14);
    }
}

static Obj SettingsPanel178R13(Obj parent,Rect frame,B card) {
    Obj panel=O0(Lookup("UIView"),"new");
    SetFrame(panel,frame);
    Q1(panel,"setAutoresizingMask:",2);
    if (card) {
        V1(panel,"setBackgroundColor:",O0(Lookup("UIColor"),"secondarySystemGroupedBackgroundColor"));
        ((void(*)(Obj,Sel,double))Message)(Get(panel,"layer"),sel_registerName("setCornerRadius:"),18);
    }
    V1(parent,"addSubview:",panel);
    V0(panel,"release");
    return panel;
}

static void SettingsSetCompactPosition(Obj router,Sel cmd,Obj sender) {
    (void)cmd;
    I position=((I(*)(Obj,Sel))Message)(sender,sel_registerName("tag"));
    ((void(*)(Obj,Sel,I,Obj))Message)(BottomDefaults178(),sel_registerName("setInteger:forKey:"),
        position,Text(BottomCompactPositionKey));
    BottomRefresh178();
    Obj navigation=Get(BottomWeakValue178(router,BottomOptionsOwner178Key),"navigationController");
    ((Obj(*)(Obj,Sel,B))Message)(navigation,sel_registerName("popViewControllerAnimated:"),1);
}

static void SettingsCompactPositionChoice(Obj card,Obj router,double y,I position,I selected,
    const char *label,const char *checked) {
    Obj choice=OptionsEntry178(card,router,(Rect){0,y,Bounds(card).width,48},
        position==selected ? checked : label,label,"fqx_setCompactPosition:");
    Q1(choice,"setTag:",position);
}

static void SettingsOpenCompactPosition(Obj router,Sel cmd,Obj sender) {
    (void)cmd; (void)sender;
    Obj owner=BottomWeakValue178(router,BottomOptionsOwner178Key);
    Obj navigation=Get(owner,"navigationController");
    if (!navigation || !BottomFlag178(2)) return;
    Obj page=O0(Lookup("UIViewController"),"new");
    V1(page,"setTitle:",Text("收缩位置"));
    Q1(page,"setEdgesForExtendedLayout:",0);
    Obj root=Get(page,"view");
    V1(root,"setBackgroundColor:",O0(Lookup("UIColor"),"systemGroupedBackgroundColor"));
    Obj viewport=Get(navigation,"viewIfLoaded");
    Rect bounds=Bounds(viewport ? viewport : Get(owner,"tableView"));
    SetFrame(root,bounds);
    Obj card=SettingsPanel178R13(root,(Rect){20,16,bounds.width-40,144},1);
    I selected=BottomCompactPosition();
    if (selected<BottomCompactRight || selected>BottomCompactCenter) selected=BottomCompactRight;
    SettingsCompactPositionChoice(card,router,0,BottomCompactLeft,selected,"左侧","左侧  ✓");
    SettingsCompactPositionChoice(card,router,48,BottomCompactCenter,selected,"居中","居中  ✓");
    SettingsCompactPositionChoice(card,router,96,BottomCompactRight,selected,"右侧","右侧  ✓");
    ((void(*)(Obj,Sel,Obj,B))Message)(navigation,sel_registerName("pushViewController:animated:"),page,1);
    V0(page,"release");
}

static Obj SettingsGroup178R13(Obj header,const char *title) {
    Obj group=SettingsPanel178R13(header,(Rect){20,0,Bounds(header).width-40,1},1);
    BottomSettingsLabel178(group,(Rect){16,8,Bounds(group).width-32,25},title,14,1);
    V1(objc_getAssociatedObject(header,SettingsGroups178R13Key),"addObject:",group);
    return group;
}

static void SettingsToggle178R13(Obj group,Obj controller,Obj router,I tag,B page,const char *title,const char *detail) {
    Obj row=SettingsPanel178R13(group,(Rect){0,0,Bounds(group).width,detail ? 79 : 48},0);
    if (page) ToggleRow(row,8,PageOptionLabel(tag),tag,PageOptionEnabled(tag),router);
    else BottomSettingsSwitch178(controller,row,8,tag,title,detail);
    V1(row,"setAccessibilityIdentifier:",page ? PageOptionLabel(tag) : Text(title));
}

static B SettingsMatches178R13(Obj haystack,Obj query) {
    if (!haystack) return 0;
    Obj space=O0(Lookup("NSCharacterSet"),"whitespaceAndNewlineCharacterSet");
    Obj tokens=O1(query,"componentsSeparatedByCharactersInSet:",space);
    U count=TabCount(tokens);
    Obj folded=Get(haystack,"lowercaseString");
    U length=((U(*)(Obj,Sel))Message)(folded,sel_registerName("length"));
    for (U i=0;i<count;++i) {
        Obj term=Get(At(tokens,i),"lowercaseString");
        U termLength=((U(*)(Obj,Sel))Message)(term,sel_registerName("length"));
        if (!termLength || ((B(*)(Obj,Sel,Obj))Message)(folded,sel_registerName("containsString:"),term)) continue;
        // Ordered characters allow "右按钮", "诊导" and other partial names.
        U matched=0;
        for (U j=0;j<length && matched<termLength;++j) {
            unsigned short actual=((unsigned short(*)(Obj,Sel,U))Message)(folded,sel_registerName("characterAtIndex:"),j);
            unsigned short wanted=((unsigned short(*)(Obj,Sel,U))Message)(term,sel_registerName("characterAtIndex:"),matched);
            if (actual==wanted) ++matched;
        }
        if (matched!=termLength) return 0;
    }
    return 1;
}

static void SettingsSearchChanged178R13(Obj router,Sel cmd,Obj search,Obj query) {
    (void)cmd; (void)search;
    Obj owner=BottomWeakValue178(router,BottomOptionsOwner178Key),table=Get(owner,"tableView");
    Obj header=objc_getAssociatedObject(owner,SettingsHeader178R13Key);
    Obj groups=objc_getAssociatedObject(header,SettingsGroups178R13Key);
    Obj compactPosition=objc_getAssociatedObject(owner,SettingsCompactPositionRowKey);
    B autoCompact=BottomFlag178(2);
    B filtering=((U(*)(Obj,Sel))Message)(query,sel_registerName("length"))!=0;
    double y=60;
    for (U i=0;i<TabCount(groups);++i) {
        Obj group=At(groups,i),rows=Get(group,"subviews");
        double rowY=38;
        for (U j=1;j<TabCount(rows);++j) {
            Obj row=At(rows,j);
            B show=!filtering || SettingsMatches178R13(Get(row,"accessibilityIdentifier"),query);
            if (row==compactPosition && !autoCompact) show=0;
            VB(row,"setHidden:",!show);
            if (!show) continue;
            Rect frame=Frame(row);
            frame.y=rowY;
            SetFrame(row,frame);
            rowY+=frame.height;
        }
        B empty=rowY==38;
        VB(group,"setHidden:",empty);
        if (empty) continue;
        Rect frame=Frame(group);
        frame.y=y;
        frame.height=rowY+6;
        SetFrame(group,frame);
        y+=frame.height+12;
    }
    Rect frame=Frame(header);
    frame.height=y+4;
    if (!SameRect(frame,Frame(header))) {
        SetFrame(header,frame);
        V1(table,"setTableHeaderView:",header);
    }
}

static void SettingsUpdateCompactPosition(Obj owner) {
    Obj menu=Lookup("FQXSettingsMenu");
    if (Responds(menu,"refreshOnController:") &&
        ((B(*)(Obj,Sel,Obj))Message)(menu,sel_registerName("refreshOnController:"),owner)) return;
    Obj search=objc_getAssociatedObject(owner,SettingsSearch178R13Key);
    if (!search) return;
    Obj toggle=objc_getAssociatedObject(owner,SettingsCompactSwitchKey);
    B enabled=BottomFlag178(2);
    if (BoolProp(toggle,"isOn")!=enabled)
        ((void(*)(Obj,Sel,B,B))Message)(toggle,sel_registerName("setOn:animated:"),enabled,0);
    SettingsSearchChanged178R13(objc_getAssociatedObject(owner,ToggleObserverKey),0,search,Get(search,"text"));
}

static void SettingsFocus178R13(Obj router,Sel cmd,Obj sender) {
    (void)cmd; (void)sender;
    Obj owner=BottomWeakValue178(router,BottomOptionsOwner178Key);
    Obj search=objc_getAssociatedObject(owner,SettingsSearch178R13Key);
    Obj table=Get(owner,"tableView");
    typedef struct { double top,left,bottom,right; } Insets;
    Insets insets=((Insets(*)(Obj,Sel))Message)(table,sel_registerName("adjustedContentInset"));
    ((void(*)(Obj,Sel,Point,B))Message)(table,sel_registerName("setContentOffset:animated:"),(Point){0,-insets.top},0);
    V0(Get(search,"searchTextField"),"becomeFirstResponder");
}

static void SettingsDiagnosticToggle178R13(Obj router,Sel cmd,Obj sender) {
    (void)router; (void)cmd;
    FQDSetDiagnosticsEnabled(Flag(sender,"isOn"));
}

static Obj SettingsVisibleController(Obj owner) {
    Obj menu=Lookup("FQXSettingsMenu");
    Obj visible=Responds(menu,"visibleControllerForController:") ? O1(menu,"visibleControllerForController:",owner) : (Obj)0;
    if (visible) return visible;
    visible=Get(Get(owner,"navigationController"),"topViewController");
    return visible ? visible : owner;
}

static void SettingsExport178R13(Obj router,Sel cmd,Obj sender) {
    (void)cmd;
    Obj owner=BottomWeakValue178(router,BottomOptionsOwner178Key);
    Obj visible=SettingsVisibleController(owner);
    const char *export="fqab_156_exportDiagnostics:",*present="fqab_156_presentDiagnostics:";
    if (visible!=owner && Kind(visible,"FQXSettingsMenu") && !Responds(visible,export)) {
        Sel start=sel_registerName(export),done=sel_registerName(present);
        Obj source=object_getClass(owner),target=object_getClass(visible);
        Method begin=class_getInstanceMethod(source,start),finish=class_getInstanceMethod(source,done);
        if (begin && finish) {
            // These actions store state on their receiver and use UIViewController APIs.
            class_addMethod(target,done,method_getImplementation(finish),"v24@0:8@16");
            class_addMethod(target,start,method_getImplementation(begin),"v24@0:8@16");
        }
    }
    if (Responds(visible,export)) V1(visible,export,sender);
}

static void SettingsOpenBookExport(Obj router,Sel cmd,Obj sender) {
    (void)cmd; (void)sender;
    Obj owner=BottomWeakValue178(router,BottomOptionsOwner178Key);
    V1(Lookup("FQXBookExportPlugin"),"openFromSettingsController:",SettingsVisibleController(owner));
}
static void SettingsOpenStartup(Obj router,Sel cmd,Obj sender) {
    (void)cmd; (void)sender;
    V1(Lookup("FQXNavigationPreferences"),"openStartupFromController:",
        SettingsVisibleController(BottomWeakValue178(router,BottomOptionsOwner178Key)));
}
static void SettingsOpenBookstoreCategories(Obj router,Sel cmd,Obj sender) {
    (void)cmd; (void)sender;
    V1(Lookup("FQXNavigationPreferences"),"openBookstoreFromController:",
        SettingsVisibleController(BottomWeakValue178(router,BottomOptionsOwner178Key)));
}
static void SettingsOpenBackup(Obj router,Sel cmd,Obj sender) {
    (void)cmd; (void)sender;
    // Backup owns the root settings controller; grouped submenu controllers
    // are transient presenters and must not become the backup navigation root.
    Obj owner=BottomWeakValue178(router,BottomOptionsOwner178Key);
    V1(Lookup("FQXSettingsBackup"),"presentFromController:",owner);
}

static void SettingsLocalReward178R13(Obj router,Sel cmd,Obj sender) {
    (void)cmd; (void)sender;
    Obj owner=SettingsVisibleController(BottomWeakValue178(router,BottomOptionsOwner178Key));
    if (!owner || Get(owner,"presentedViewController")) return;
    B enabled=BottomFlag178(35);
    Obj alert=((Obj(*)(Obj,Sel,Obj,Obj,I))Message)(Lookup("UIAlertController"),
        sel_registerName("alertControllerWithTitle:message:preferredStyle:"),Text("听书奖励本地测试"),
        Text(enabled ? "模拟领取成功。等待 0 秒，未发送请求，账号余额不变。" :
                       "请先打开「听书奖励本地测试」。"),1);
    Obj okay=((Obj(*)(Obj,Sel,Obj,I,Obj))Message)(Lookup("UIAlertAction"),
        sel_registerName("actionWithTitle:style:handler:"),Text("完成"),0,0);
    V1(alert,"addAction:",okay);
    ((void(*)(Obj,Sel,Obj,B,Obj))Message)(owner,sel_registerName("presentViewController:animated:completion:"),alert,1,0);
}

static void SettingsJump178R13(Obj router,Sel cmd,Obj sender) {
    (void)cmd;
    Obj owner=BottomWeakValue178(router,BottomOptionsOwner178Key),table=Get(owner,"tableView");
    Obj search=objc_getAssociatedObject(owner,SettingsSearch178R13Key);
    V0(Get(search,"searchTextField"),"resignFirstResponder");
    if (((I(*)(Obj,Sel))Message)(sender,sel_registerName("tag"))==1) {
        Obj footer=Get(table,"tableFooterView");
        ((void(*)(Obj,Sel,Rect,B))Message)(table,sel_registerName("scrollRectToVisible:animated:"),Frame(footer),1);
    } else {
        I sections=((I(*)(Obj,Sel))Message)(table,sel_registerName("numberOfSections"));
        for (I section=0;section<sections;++section) {
            if (((I(*)(Obj,Sel,I))Message)(table,sel_registerName("numberOfRowsInSection:"),section)<=0) continue;
            Obj path=((Obj(*)(Obj,Sel,I,I))Message)(Lookup("NSIndexPath"),
                sel_registerName("indexPathForRow:inSection:"),0,section);
            ((void(*)(Obj,Sel,Obj,I,B))Message)(table,sel_registerName("scrollToRowAtIndexPath:atScrollPosition:animated:"),path,1,1);
            break;
        }
    }
}

static Obj SettingsBarItem178R13(Obj router,const char *title,const char *symbol,const char *action) {
    Obj item=O0(Lookup("UIBarButtonItem"),"alloc");
    if (symbol) {
        Obj image=O1(Lookup("UIImage"),"systemImageNamed:",Text(symbol));
        item=((Obj(*)(Obj,Sel,Obj,I,Obj,Sel))Message)(item,
            sel_registerName("initWithImage:style:target:action:"),image,0,router,sel_registerName(action));
        V1(item,"setAccessibilityLabel:",Text(title));
    } else {
        item=((Obj(*)(Obj,Sel,Obj,I,Obj,Sel))Message)(item,
            sel_registerName("initWithTitle:style:target:action:"),Text(title),0,router,sel_registerName(action));
    }
    return item;
}

static void SettingsInstallMenu(Obj controller) {
    Obj menu=Lookup("FQXSettingsMenu");
    if (!Responds(menu,"installOnController:router:ads:")) return;
    Obj ads=((Obj(*)(Obj,Sel,I))Message)(O0(Lookup("FanqieAdBlockOptionsController"),"alloc"),
        sel_registerName("initWithStyle:"),2);
    objc_setAssociatedObject(ads,SettingsAdPageKey,BoolBox(1),1);
    ((void(*)(Obj,Sel,Obj,Obj,Obj))Message)(menu,sel_registerName("installOnController:router:ads:"),
        controller,objc_getAssociatedObject(controller,ToggleObserverKey),ads);
    V0(ads,"release");
}

static void SettingsInstall178R13(Obj controller) {
    Obj table=Get(controller,"tableView");
    if (!table || objc_getAssociatedObject(controller,SettingsAdPageKey)) return;
    if (objc_getAssociatedObject(controller,SettingsHeader178R13Key)) {
        SettingsInstallMenu(controller);
        return;
    }
    SettingsInstallSections();
    Obj cls=Lookup("FanqieXBottomOptionsRouter178");
    if (!cls) {
        cls=AllocateClass(Lookup("NSObject"),"FanqieXBottomOptionsRouter178",0);
        if (!cls) return;
        class_addMethod(cls,sel_registerName("fqx178_openBottom:"),(Imp)BottomOpenSettings178,"v24@0:8@16");
        class_addMethod(cls,sel_registerName("fqx178_openTelegram:"),(Imp)OpenTelegramChannel178,"v24@0:8@16");
        class_addMethod(cls,sel_registerName("fqx178_search:"),(Imp)SettingsFocus178R13,"v24@0:8@16");
        class_addMethod(cls,sel_registerName("searchBar:textDidChange:"),(Imp)SettingsSearchChanged178R13,"v32@0:8@16@24");
        class_addMethod(cls,sel_registerName("fqx178_diagnostics:"),(Imp)SettingsDiagnosticToggle178R13,"v24@0:8@16");
        class_addMethod(cls,sel_registerName("fqx178_export:"),(Imp)SettingsExport178R13,"v24@0:8@16");
        class_addMethod(cls,sel_registerName("fqx_openBookExport:"),(Imp)SettingsOpenBookExport,"v24@0:8@16");
        class_addMethod(cls,sel_registerName("fqx_openStartup:"),(Imp)SettingsOpenStartup,"v24@0:8@16");
        class_addMethod(cls,sel_registerName("fqx_openBookstoreCategories:"),(Imp)SettingsOpenBookstoreCategories,"v24@0:8@16");
        class_addMethod(cls,sel_registerName("fqx_openBackup:"),(Imp)SettingsOpenBackup,"v24@0:8@16");
        class_addMethod(cls,sel_registerName("fqx178_testListenReward:"),(Imp)SettingsLocalReward178R13,"v24@0:8@16");
        class_addMethod(cls,sel_registerName("fqx178_jump:"),(Imp)SettingsJump178R13,"v24@0:8@16");
        class_addMethod(cls,sel_registerName("fqx_openAds:"),(Imp)SettingsOpenAds,"v24@0:8@16");
        class_addMethod(cls,sel_registerName("fqx_openCompactPosition:"),(Imp)SettingsOpenCompactPosition,"v24@0:8@16");
        class_addMethod(cls,sel_registerName("fqx_setCompactPosition:"),(Imp)SettingsSetCompactPosition,"v24@0:8@16");
        class_addMethod(cls,sel_registerName("fqx176_toggle:"),(Imp)ToggleChanged,"v24@0:8@16");
        RegisterClass(cls);
    }
    class_addMethod(object_getClass(controller),sel_registerName("fqx178_bottomOptionChanged:"),
        (Imp)FQHBottomOptionChanged178,"v24@0:8@16");
    Obj router=O0(cls,"new");
    BottomSetWeak178(router,BottomOptionsOwner178Key,controller);
    objc_setAssociatedObject(controller,ToggleObserverKey,router,1);
    Obj navigation=Get(controller,"navigationItem");
    Obj appearance=SettingsBarItem178R13(router,"外观",0,"fqx178_openBottom:");
    V1(navigation,"setLeftBarButtonItem:",appearance);
    V0(appearance,"release");
    Obj searchItem=SettingsBarItem178R13(router,"搜索设置","magnifyingglass","fqx178_search:");
    Obj navItems=O0(Lookup("NSMutableArray"),"array"),done=Get(navigation,"rightBarButtonItem");
    if (done) V1(navItems,"addObject:",done);
    if (searchItem) V1(navItems,"addObject:",searchItem);
    V1(navigation,"setRightBarButtonItems:",navItems);
    V0(searchItem,"release");

    double width=Bounds(table).width;
    if (width<240) width=Bounds(O0(Lookup("UIScreen"),"mainScreen")).width;
    if (width<240) width=390;
    Obj header=O0(Lookup("UIView"),"new");
    SetFrame(header,(Rect){0,0,width,64});
    VB(header,"setAutoresizesSubviews:",0);
    objc_setAssociatedObject(controller,SettingsHeader178R13Key,header,1);
    objc_setAssociatedObject(header,SettingsGroups178R13Key,O0(Lookup("NSMutableArray"),"array"),1);
    Obj search=O0(Lookup("UISearchBar"),"new");
    Q1(search,"setSearchBarStyle:",2);
    Q1(search,"setAutoresizingMask:",2);
    V1(search,"setPlaceholder:",Text("搜索设置"));
    V1(search,"setDelegate:",router);
    SetFrame(search,(Rect){16,0,width-32,56});
    V1(header,"addSubview:",search);
    objc_setAssociatedObject(controller,SettingsSearch178R13Key,search,1);
    V0(search,"release");

    Obj group=SettingsGroup178R13(header,"底栏入口");
    for (I option=StoreOption;option<=MallOption;++option)
        SettingsToggle178R13(group,controller,router,option,1,0,0);
    group=SettingsGroup178R13(header,"短剧播放");
    SettingsToggle178R13(group,controller,router,2,0,"短剧滚动自动收缩",0);
    Obj position=OptionsEntry178(group,router,(Rect){0,0,Bounds(group).width,48},
        "收缩位置  ›","收缩位置","fqx_openCompactPosition:");
    V1(position,"setAccessibilityIdentifier:",Text("短剧滚动自动收缩位置 左侧 居中 右侧"));
    objc_setAssociatedObject(controller,SettingsCompactPositionRowKey,position,1);
    SettingsToggle178R13(group,controller,router,37,0,"查看全集与进度条跟随底栏长度","开启后查看全集与进度条宽度自动对齐底栏长度。");
    SettingsToggle178R13(group,controller,router,30,0,"默认清屏播放",0);
    SettingsToggle178R13(group,controller,router,33,0,"纯净清屏","默认清屏时隐藏进度、合集、互动和底栏。");
    SettingsToggle178R13(group,controller,router,31,0,"暂停时显示界面",0);
    SettingsToggle178R13(group,controller,router,32,0,"默认最高画质",0);
    SettingsToggle178R13(group,controller,router,FullscreenFillOption,1,0,0);
    Obj categoryRows=O1(DramaCategoryDefaults(),"objectForKey:",DramaCategoryListKey());
    U categoryCount=DramaCategoryCount(categoryRows);
    SettingsToggle178R13(group,controller,router,21,0,"显示短剧顶部分类",
        categoryCount ? 0 : "进入短剧加载分类后，可单独设置每个分类。");
    for (U i=0;i<categoryCount && i<24;++i) {
        Obj row=At(categoryRows,i);
        if (!Kind(row,"NSDictionary")) continue;
        Obj type=O1(row,"objectForKey:",Text("type")),title=O1(row,"objectForKey:",Text("title"));
        if (!Kind(type,"NSNumber") || !Kind(title,"NSString")) continue;
        I code=((I(*)(Obj,Sel))Message)(type,sel_registerName("integerValue"));
        if (code<0 || code>2147483647) continue;
        Obj label=O1(Text("短剧分类："),"stringByAppendingString:",title);
        const char *name=((const char *(*)(Obj,Sel))Message)(label,sel_registerName("UTF8String"));
        if (name) SettingsToggle178R13(group,controller,router,DramaCategoryTagBase+code,0,name,0);
    }
    SettingsToggle178R13(group,controller,router,22,0,"显示短剧搜索按钮",0);
    SettingsToggle178R13(group,controller,router,23,0,"显示作者声明",0);
    SettingsToggle178R13(group,controller,router,24,0,"显示阅读原著",0);
    SettingsToggle178R13(group,controller,router,25,0,"显示小说兴趣推荐",0);
    group=SettingsGroup178R13(header,"阅读与书架");
    if (Lookup("FQXBookExportPlugin")) {
        Obj export=OptionsEntry178(group,router,(Rect){0,0,Bounds(group).width,48},
            "导出书籍  ›","导出书籍","fqx_openBookExport:");
        V1(export,"setAccessibilityIdentifier:",Text("导出书籍 小说导出 下载 本地章节 TXT Markdown HTML EPUB JSON"));
    }
    SettingsToggle178R13(group,controller,router,ReaderBottomBackgroundOption,1,0,0);
    SettingsToggle178R13(group,controller,router,ReaderThemeIsolationOption,1,0,0);
    SettingsToggle178R13(group,controller,router,ShelfDurationOption,1,0,0);
    SettingsToggle178R13(group,controller,router,ShelfFilterOption,1,0,0);
    SettingsToggle178R13(group,controller,router,27,0,"阅读页显示去赚更多",0);
    SettingsToggle178R13(group,controller,router,29,0,"书架显示漫剧分组",0);
    SettingsToggle178R13(group,controller,router,36,0,"截图后一键分享",0);
    group=SettingsGroup178R13(header,"个人页与侧栏");
    SettingsToggle178R13(group,controller,router,MineBenefitsOption,1,0,0);
    SettingsToggle178R13(group,controller,router,MineRecommendationsOption,1,0,0);
    SettingsToggle178R13(group,controller,router,26,0,"我的显示继续追剧／追漫",0);
    SettingsToggle178R13(group,controller,router,28,0,"侧栏显示常玩游戏",0);
    group=SettingsGroup178R13(header,"页面与配置");
    Obj startup=OptionsEntry178(group,router,(Rect){0,0,Bounds(group).width,48},
        "默认启动页  ›","默认启动页","fqx_openStartup:");
    V1(startup,"setAccessibilityIdentifier:",Text("默认启动页 跟随应用 书城 短剧 书架 我的"));
    Obj categories=OptionsEntry178(group,router,(Rect){0,0,Bounds(group).width,48},
        "书城顶部分类  ›","书城顶部分类","fqx_openBookstoreCategories:");
    V1(categories,"setAccessibilityIdentifier:",Text("书城顶部分类 推荐 小说 听书 看剧 显示 隐藏"));
    Obj backup=OptionsEntry178(group,router,(Rect){0,0,Bounds(group).width,48},
        "设置备份与恢复  ›","设置备份与恢复","fqx_openBackup:");
    V1(backup,"setAccessibilityIdentifier:",Text("设置备份与恢复 配置 导入 导出 合并 覆盖 默认"));
    group=SettingsGroup178R13(header,"更多设置");
    double rowWidth=Bounds(group).width;
    Obj look=OptionsEntry178(group,router,(Rect){0,0,rowWidth,48},"外观与尺寸  ›","外观","fqx178_openBottom:");
    V1(look,"setAccessibilityIdentifier:",Text("外观 底栏 尺寸 图标 短剧右侧互动按钮 收藏 评论 点赞 分享 大小 我的快捷入口仅显示图标"));
    Obj ads=OptionsEntry178(group,router,(Rect){0,0,rowWidth,48},"广告与福利  ›","广告与福利","fqx_openAds:");
    V1(ads,"setAccessibilityIdentifier:",Text("广告 福利 拦截 开屏 阅读底栏 插屏 弹窗 自动签到 金币 福利标签"));
    Obj diagnostic=OptionsEntry178(group,router,(Rect){0,0,rowWidth,48},"诊断与日志  ›","诊断与日志","fqx178_jump:");
    Q1(diagnostic,"setTag:",1);
    V1(diagnostic,"setAccessibilityIdentifier:",Text("开启诊断 增强诊断 导出日志 听书奖励本地测试 模拟立即领取"));
    Obj telegram=OptionsEntry178(group,router,(Rect){0,0,rowWidth,48},"Telegram 频道  ›","Telegram 频道","fqx178_openTelegram:");
    V1(telegram,"setAccessibilityIdentifier:",Text("Telegram 更新频道"));
    SettingsSearchChanged178R13(router,0,0,Text(""));
    V0(header,"release");

    Obj footer=O0(Lookup("UIView"),"new");
    SetFrame(footer,(Rect){0,0,width,280});
    VB(footer,"setAutoresizesSubviews:",0);
    Obj card=SettingsPanel178R13(footer,(Rect){20,8,width-40,256},1);
    double cardWidth=Bounds(card).width;
    BottomSettingsLabel178(card,(Rect){16,10,cardWidth-32,26},"诊断与测试",14,1);
    BottomSettingsLabel178(card,(Rect){20,48,cardWidth-100,32},"开启诊断",16,0);
    Obj toggle=O0(Lookup("UISwitch"),"new");
    SettingsPlaceSwitch178R14(toggle,cardWidth,64);
    Q1(toggle,"setAutoresizingMask:",1);
    VB(toggle,"setOn:",FQDDiagnosticsEnabled());
    V1(toggle,"setAccessibilityLabel:",Text("开启诊断"));
    ((void(*)(Obj,Sel,Obj,Sel,U))Message)(toggle,sel_registerName("addTarget:action:forControlEvents:"),
        router,sel_registerName("fqx178_diagnostics:"),4096);
    V1(card,"addSubview:",toggle);
    V0(toggle,"release");
    BottomSettingsLabel178(card,(Rect){20,81,cardWidth-40,34},"开启后记录完整诊断，关闭后停止记录。",12,1);
    OptionsEntry178(card,router,(Rect){0,112,cardWidth,41},"导出日志","导出日志","fqx178_export:");
    BottomSettingsSwitch178(controller,card,158,35,"听书奖励本地测试",0);
    OptionsEntry178(card,router,(Rect){0,193,cardWidth,48},"模拟立即领取","模拟立即领取","fqx178_testListenReward:");
    V1(table,"setTableFooterView:",footer);
    SettingsInstallLayout178R14(controller);
    SettingsContentWidth178R14(controller);
    V0(footer,"release");
    V0(router,"release");
    V0(table,"reloadData");
    SettingsInstallMenu(controller);
}
