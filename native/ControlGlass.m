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
static void OriginalConfigKey(void) {}
static void AppliedConfigKey(void) {}
static void IconFrameKey(void) {}
static void AppliedIconFrameKey(void) {}
static void OwnerBusyKey(void) {}
static void ReaderGlassKey(void) {}
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
B FQHButtonAvailable(void) {
    return Responds(Lookup("UIButtonConfiguration"),"glassButtonConfiguration") &&
           class_getInstanceMethod(Lookup("UIButton"),sel_registerName("setConfiguration:"));
}
void FQHButton(Obj button) {
    if (!Kind(button,"UIButton")) { FQHApply(button); return; }
    if (objc_getAssociatedObject(button,BusyKey)) return;
    objc_setAssociatedObject(button,BusyKey,button,0);
    Obj owned=objc_getAssociatedObject(button,AppliedConfigKey);
    Obj current=O0(button,"configuration");
    if (!Enabled() || !FQHButtonAvailable()) {
        if (owned) {
            Obj saved=objc_getAssociatedObject(button,OriginalConfigKey);
            if (Kind(saved,"NSNull")) saved=0;
            V1(button,"setConfiguration:",saved);
        }
        objc_setAssociatedObject(button,OriginalConfigKey,0,1);
        objc_setAssociatedObject(button,AppliedConfigKey,0,1);
        RestoreOwner(button);
    } else {
        if (!owned || !current) {
            Obj config=O0(Lookup("UIButtonConfiguration"),"glassButtonConfiguration");
            if (config) {
                if (!owned) objc_setAssociatedObject(button,OriginalConfigKey,current ? current : O0(Lookup("NSNull"),"null"),1);
                Obj image=((Obj(*)(Obj,Sel,U))Message)(button,sel_registerName("imageForState:"),0);
                Obj title=((Obj(*)(Obj,Sel,U))Message)(button,sel_registerName("attributedTitleForState:"),0);
                V1(config,"setImage:",image);
                if (title) V1(config,"setAttributedTitle:",title);
                else V1(config,"setTitle:",((Obj(*)(Obj,Sel,U))Message)(button,sel_registerName("titleForState:"),0));
                Rect insets={0,0,0,0};
                ((void(*)(Obj,Sel,Rect))Message)(config,sel_registerName("setContentInsets:"),insets);
                V1(button,"setConfiguration:",config);
                objc_setAssociatedObject(button,AppliedConfigKey,BoolBox(1),1);
            }
        }
        if (objc_getAssociatedObject(button,AppliedConfigKey)) PrepareOwner(button);
    }
    objc_setAssociatedObject(button,BusyKey,0,0);
}
static B Belongs(Obj view,Obj owner) {
    for (int depth=0;view && depth<8;++depth,view=Get(view,"superview"))
        if (view==owner) return 1;
    return 0;
}
static B IsReaderInsert(Obj obj) {
    return Kind(obj,"FQReaderNavigationBarMoreBtnInsertObject") ||
           Kind(obj,"FQReaderNavigationBarSearchBtnInsertObject") ||
           Kind(obj,"SSReaderNavigationBarDownloadBtnInsertObject") ||
           Kind(obj,"SSReaderNavigationBarCommunitySwitchBtnInsertObject");
}
static Rect Frame(Obj view) { return ((Rect(*)(Obj,Sel))Message)(view,sel_registerName("frame")); }
static void SetFrame(Obj view,Rect frame) { ((void(*)(Obj,Sel,Rect))Message)(view,sel_registerName("setFrame:"),frame); }
static Obj RectBox(Rect rect) { return ((Obj(*)(Obj,Sel,Rect))Message)(Lookup("NSValue"),sel_registerName("valueWithCGRect:"),rect); }
static Rect UnboxRect(Obj value) { return ((Rect(*)(Obj,Sel))Message)(value,sel_registerName("CGRectValue")); }
static B SameRect(Rect a,Rect b) { return a.x==b.x && a.y==b.y && a.width==b.width && a.height==b.height; }
static void SizedButton(Obj button) {
    if (!Kind(button,"UIButton")) return;
    Obj applied=objc_getAssociatedObject(button,AppliedIconFrameKey);
    Rect frame=Frame(button);
    if (Enabled() && FQHButtonAvailable()) {
        if (frame.width>0 && frame.height>0 && __builtin_isfinite(frame.x) && __builtin_isfinite(frame.y) && __builtin_isfinite(frame.width) && __builtin_isfinite(frame.height)) {
            if (!applied || !SameRect(frame,UnboxRect(applied)))
                objc_setAssociatedObject(button,IconFrameKey,RectBox(frame),1);
            Rect enlarged=frame;
            if (enlarged.width<36) { enlarged.x-=(36-enlarged.width)*0.5; enlarged.width=36; }
            if (enlarged.height<36) { enlarged.y-=(36-enlarged.height)*0.5; enlarged.height=36; }
            if (!SameRect(frame,enlarged)) SetFrame(button,enlarged);
            objc_setAssociatedObject(button,AppliedIconFrameKey,RectBox(enlarged),1);
        }
    } else {
        Obj original=objc_getAssociatedObject(button,IconFrameKey);
        if (applied && original && SameRect(frame,UnboxRect(applied))) SetFrame(button,UnboxRect(original));
        objc_setAssociatedObject(button,IconFrameKey,0,1);
        objc_setAssociatedObject(button,AppliedIconFrameKey,0,1);
    }
    FQHButton(button);
}
I FQHReaderCount(Obj owner) {
    return ((I(*)(Obj,Sel))Message)(objc_getAssociatedObject(owner,ReaderGlassKey),sel_registerName("integerValue"));
}
static void ReaderCount(Obj owner,I count) {
    if (count==FQHReaderCount(owner)) return;
    Obj value=count ? ((Obj(*)(Obj,Sel,I))Message)(Lookup("NSNumber"),sel_registerName("numberWithLongLong:"),count) : (Obj)0;
    objc_setAssociatedObject(owner,ReaderGlassKey,value,1);
}
void FQHReader(Obj owner) {
    if (objc_getAssociatedObject(owner,OwnerBusyKey)) return;
    objc_setAssociatedObject(owner,OwnerBusyKey,owner,0);
    Obj back=Get(owner,"backBtn");
    if (Belongs(back,owner)) SizedButton(back);
    I styled=objc_getAssociatedObject(back,AppliedConfigKey)!=0;
    Obj items=Get(owner,"insertObjs");
    if (!Kind(items,"NSArray")) { ReaderCount(owner,styled); objc_setAssociatedObject(owner,OwnerBusyKey,0,0); return; }
    U count=((U(*)(Obj,Sel))Message)(items,sel_registerName("count"));
    if (count>16) count=16;
    for (U i=0;i<count;++i) {
        Obj item=((Obj(*)(Obj,Sel,U))Message)(items,sel_registerName("objectAtIndex:"),i);
        if (!IsReaderInsert(item)) continue;
        Obj view=Get(item,"getInsertView");
        if (Belongs(view,owner)) {
            FQHButton(view);
            styled += objc_getAssociatedObject(view,AppliedConfigKey)!=0 || FQHSurface(view)!=0;
        }
    }
    ReaderCount(owner,styled);
    objc_setAssociatedObject(owner,OwnerBusyKey,0,0);
}
static void ReaderLayout(Obj self,Sel cmd) {
    ((void(*)(Obj,Sel))Original("FQReaderSaasNavigationView","fqx166_originalLayout"))(self,cmd);
    FQHReader(self);
}
static void ReaderTheme(Obj self,Sel cmd,Obj theme) {
    ((void(*)(Obj,Sel,Obj))Original("FQReaderSaasNavigationView","fqx166_originalTheme:"))(self,cmd,theme);
    FQHReader(self);
}
static void ShelfLayout(Obj self,Sel cmd) {
    ((void(*)(Obj,Sel))Original("SSBookShelfSubViewController","fqx166_originalShelfLayout"))(self,cmd);
    SizedButton(Get(self,"searchButton"));
    SizedButton(Get(self,"moreButton"));
}
static Size InsertSize(Obj self,Sel cmd,const char *cls) {
    Size size=((Size(*)(Obj,Sel))Original(cls,"fqx166_originalSize"))(self,cmd);
    if (Enabled() && FQHButtonAvailable() && size.width>0 && size.height>0 &&
        __builtin_isfinite(size.width) && __builtin_isfinite(size.height)) {
        if (size.width<36) size.width=36;
        if (size.height<36) size.height=36;
    }
    return size;
}
#define SIZE_WRAPPER(name,cls) static Size name(Obj self,Sel cmd) { return InsertSize(self,cmd,cls); }
SIZE_WRAPPER(MoreSize,"FQReaderNavigationBarMoreBtnInsertObject")
SIZE_WRAPPER(SearchSize,"FQReaderNavigationBarSearchBtnInsertObject")
SIZE_WRAPPER(DownloadSize,"SSReaderNavigationBarDownloadBtnInsertObject")
SIZE_WRAPPER(CommunitySize,"SSReaderNavigationBarCommunitySwitchBtnInsertObject")
void FQHInstall(void) {
    // Older iOS keeps its original controls, settings and ad switches.
    if (!FQHGlassAvailable()) return;
    Hook("SSBookStoreNewViewController","relayout","fqx165_originalRelayout","v16@0:8",(Imp)HomeLayout);
    Hook("SSBookStoreNewViewController","viewDidAppear:","fqx165_originalAppear:","v20@0:8B16",(Imp)HomeAppear);
    Hook("SSBookStoreCategorySignView","layoutSubviews","fqx165_originalLayout","v16@0:8",(Imp)CategoryLayout);
    Hook("SSBookStoreCategorySignView","resetColorWithRatio:fromTab:toTab:fromTabTemplate:toTabTemplate:","fqx165_originalColor:from:to:fromTemplate:toTemplate:","v40@0:8d16i24i28i32i36",(Imp)CategoryColor);
    Hook("SSBookStoreSearchBarComponent","resetTopTabSearchViewWithRatio:fromTab:toTab:fromTabTemplate:toTabTemplate:","fqx165_originalSearchColor:from:to:fromTemplate:toTemplate:","v40@0:8d16i24i28i32i36",(Imp)SearchColor);
    Hook("SSBookShelfSubViewController","viewDidLayoutSubviews","fqx166_originalShelfLayout","v16@0:8",(Imp)ShelfLayout);
    Hook("FQReaderSaasNavigationView","layoutSubviews","fqx166_originalLayout","v16@0:8",(Imp)ReaderLayout);
    Hook("FQReaderSaasNavigationView","readerInsertedViewThemeConfigChange:","fqx166_originalTheme:","v24@0:8@16",(Imp)ReaderTheme);
    Hook("FQReaderNavigationBarMoreBtnInsertObject","getInsertViewSize","fqx166_originalSize","{CGSize=dd}16@0:8",(Imp)MoreSize);
    Hook("FQReaderNavigationBarSearchBtnInsertObject","getInsertViewSize","fqx166_originalSize","{CGSize=dd}16@0:8",(Imp)SearchSize);
    Hook("SSReaderNavigationBarDownloadBtnInsertObject","getInsertViewSize","fqx166_originalSize","{CGSize=dd}16@0:8",(Imp)DownloadSize);
    Hook("SSReaderNavigationBarCommunitySwitchBtnInsertObject","getInsertViewSize","fqx166_originalSize","{CGSize=dd}16@0:8",(Imp)CommunitySize);

}
