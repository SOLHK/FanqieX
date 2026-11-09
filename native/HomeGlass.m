// Original implementation for the two bookstore header controls. Runtime-only
// bridge: no UIKit class imports, global UIView hooks, or host gesture replacement.
typedef void *Obj;
typedef void *Sel;
typedef void *Method;
typedef void (*Imp)(void);
typedef unsigned long U;
typedef long I;
typedef signed char B;
typedef struct { double x, y, width, height; } Rect;
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
static void Restore(Obj view,Obj surface) {
    if (!surface) return;
    Obj clear=O0(Lookup("UIColor"),"clearColor");
    Obj current=O0(view,"backgroundColor");
    if (current==clear || ((B(*)(Obj,Sel,Obj))Message)(current,sel_registerName("isEqual:"),clear))
        V1(view,"setBackgroundColor:",objc_getAssociatedObject(view,BackgroundKey));
    V0(surface,"removeFromSuperview");
    objc_setAssociatedObject(view,SurfaceKey,0,1);
    objc_setAssociatedObject(view,BackgroundKey,0,1);
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
void FQHInstall(void) {
    // Older iOS keeps its original controls, settings and ad switches.
    if (!FQHGlassAvailable()) return;
    Hook("SSBookStoreNewViewController","relayout","fqx165_originalRelayout","v16@0:8",(Imp)HomeLayout);
    Hook("SSBookStoreNewViewController","viewDidAppear:","fqx165_originalAppear:","v20@0:8B16",(Imp)HomeAppear);
    Hook("SSBookStoreCategorySignView","layoutSubviews","fqx165_originalLayout","v16@0:8",(Imp)CategoryLayout);
    Hook("SSBookStoreCategorySignView","resetColorWithRatio:fromTab:toTab:fromTabTemplate:toTabTemplate:","fqx165_originalColor:from:to:fromTemplate:toTemplate:","v40@0:8d16i24i28i32i36",(Imp)CategoryColor);
    Hook("SSBookStoreSearchBarComponent","resetTopTabSearchViewWithRatio:fromTab:toTab:fromTabTemplate:toTabTemplate:","fqx165_originalSearchColor:from:to:fromTemplate:toTemplate:","v40@0:8d16i24i28i32i36",(Imp)SearchColor);
}
