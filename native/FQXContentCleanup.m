#import <UIKit/UIKit.h>
#import <AVFoundation/AVFoundation.h>
#import <os/lock.h>
#import <objc/message.h>
#import <objc/runtime.h>
#include <stdatomic.h>
#import "FQXHookInstaller.h"
#import "FQXLayoutAndSheetPolicy.h"
#import "FanqieXDiagnosticsHub.h"

extern void FQXRefreshReaderAndAudioPendants(void);

#define KEY(name) @"FanqieX." name ".1"
typedef BOOL (*FQXGateFn)(void);

static BOOL On(NSString *key){id v=[NSUserDefaults.standardUserDefaults objectForKey:key];return [v respondsToSelector:@selector(boolValue)]&&[v boolValue];}
static SEL Sel(const char *s){return sel_registerName(s);}
static id Get(id o,const char *s){SEL x=Sel(s);return o&&[o respondsToSelector:x]?((id(*)(id,SEL))objc_msgSend)(o,x):nil;}

static unsigned int FQXReadLegacyAdOptionsMask(int *outHasStored) {
    id v = [NSUserDefaults.standardUserDefaults objectForKey:@"FanqieAdBlock.Options.1"];
    if ([v respondsToSelector:@selector(unsignedIntValue)]) {
        if (outHasStored) *outHasStored = 1;
        return [v unsignedIntValue];
    }
    if ([v respondsToSelector:@selector(integerValue)]) {
        if (outHasStored) *outHasStored = 1;
        return (unsigned int)[v integerValue];
    }
    if (outHasStored) *outHasStored = 0;
    return 0u;
}

static BOOL FQXAudioAdGateBlocked(void) {
    int hasMask = 0;
    unsigned int mask = FQXReadLegacyAdOptionsMask(&hasMask);
    return FQXShouldBlockAudioAdsAndDurationGate(hasMask, mask, On(KEY("AudioAds")) ? 1 : 0) != 0;
}

static BOOL FQXWelfarePendantBlocked(void) {
    int hasMask = 0;
    unsigned int mask = FQXReadLegacyAdOptionsMask(&hasMask);
    return FQXShouldSuppressWelfareListenPendant(hasMask, mask, On(KEY("ListenPendant")) ? 1 : 0) != 0;
}

static BOOL FQXReaderAudioPendantBlocked(void) {
    int hasMask = 0;
    unsigned int mask = FQXReadLegacyAdOptionsMask(&hasMask);
    return FQXShouldSuppressReaderAudioDurationPendant(
        hasMask, mask, On(KEY("ListenPendant")) ? 1 : 0, On(KEY("AudioAds")) ? 1 : 0) != 0;
}

static BOOL FQXShortVideoFeedAdBlocked(void) {
    int hasMask = 0;
    unsigned int mask = FQXReadLegacyAdOptionsMask(&hasMask);
    return FQXShouldBlockShortVideoFeedAd(hasMask, mask) != 0;
}

static BOOL FQXShortVideoPatchAdBlocked(void) {
    int hasMask = 0;
    unsigned int mask = FQXReadLegacyAdOptionsMask(&hasMask);
    return FQXShouldBlockShortVideoPatchAd(hasMask, mask) != 0;
}

static BOOL FQXBookstoreAndPopupAdBlocked(void) {
    int hasMask = 0;
    unsigned int mask = FQXReadLegacyAdOptionsMask(&hasMask);
    return FQXShouldBlockBookstoreAndPopupAd(hasMask, mask) != 0;
}

static Class FQXLookupMatchingClass(const char *c, SEL x, BOOL cm, const char *enc) {
    Class cls = c ? objc_lookUpClass(c) : Nil;
    if (!cls) return Nil;
    Class owner = cm ? object_getClass(cls) : cls;
    Method m = owner ? class_getInstanceMethod(owner, x) : NULL;
    if (!m) return Nil;
    const char *actual = method_getTypeEncoding(m);
    if (!actual || strcmp(actual, enc) != 0) return Nil;
    return cls;
}

static BOOL Bool0(const char*c,const char*s,BOOL cm,NSString*k){
 SEL x=Sel(s); Class cls=FQXLookupMatchingClass(c,x,cm,"B16@0:8"); if(!cls)return NO;
 __block IMP old=NULL;
 const char *rule=k.UTF8String;
 IMP hook=imp_implementationWithBlock(^BOOL(id o){
  CFTimeInterval t0=CACurrentMediaTime();
  if(On(k)){FQXDiagRecordHook(c,s,rule,"option_enabled","blocked",(CACurrentMediaTime()-t0)*1000.0);return NO;}
  BOOL r=((BOOL(*)(id,SEL))old)(o,x);
  FQXDiagRecordHook(c,s,rule,"option_off","allowed",(CACurrentMediaTime()-t0)*1000.0);
  return r;
 });
 if(!FQXDiagInstallOwnedHook(cls,c,x,cm,"B16@0:8",rule,hook,&old)){imp_removeBlock(hook);return NO;}return YES;
}
static BOOL Void0Hide(const char*c,const char*s,NSString*k,const char *g1,const char *g2){
 SEL x=Sel(s); Class cls=FQXLookupMatchingClass(c,x,NO,"v16@0:8"); if(!cls)return NO;
 __block IMP old=NULL;
 const char *rule=k.UTF8String;
 IMP hook=imp_implementationWithBlock(^(id o){
  CFTimeInterval t0=CACurrentMediaTime();
  if(!On(k)){((void(*)(id,SEL))old)(o,x);FQXDiagRecordHook(c,s,rule,"option_off","allowed",(CACurrentMediaTime()-t0)*1000.0);return;}
  FQXDiagPushPluginViewReason(rule,s);
  for(const char **g=(const char *[]){g1,g2,NULL};*g;++g){id v=Get(o,*g);if([v isKindOfClass:UIView.class])((void(*)(id,SEL,BOOL))objc_msgSend)(v,Sel("setHidden:"),YES);}
  FQXDiagPopPluginViewReason();
  FQXDiagRecordHook(c,s,rule,"hide_target_subview","blocked",(CACurrentMediaTime()-t0)*1000.0);
 });
 if(!FQXDiagInstallOwnedHook(cls,c,x,NO,"v16@0:8",rule,hook,&old)){imp_removeBlock(hook);return NO;}return YES;
}
static BOOL Void0(const char*c,const char*s,BOOL cm,NSString*k){
 SEL x=Sel(s); Class cls=FQXLookupMatchingClass(c,x,cm,"v16@0:8"); if(!cls)return NO;
 __block IMP old=NULL;
 const char *rule=k.UTF8String;
 IMP hook=imp_implementationWithBlock(^(id o){
  CFTimeInterval t0=CACurrentMediaTime();
  if(On(k)){FQXDiagRecordHook(c,s,rule,"option_enabled","blocked",(CACurrentMediaTime()-t0)*1000.0);return;}
  ((void(*)(id,SEL))old)(o,x);
  FQXDiagRecordHook(c,s,rule,"option_off","allowed",(CACurrentMediaTime()-t0)*1000.0);
 });
 if(!FQXDiagInstallOwnedHook(cls,c,x,cm,"v16@0:8",rule,hook,&old)){imp_removeBlock(hook);return NO;}return YES;
}
static BOOL Bool1(const char*c,const char*s,NSString*k){
 SEL x=Sel(s); Class cls=FQXLookupMatchingClass(c,x,NO,"B24@0:8@16"); if(!cls)return NO;
 __block IMP old=NULL;
 const char *rule=k.UTF8String;
 IMP hook=imp_implementationWithBlock(^BOOL(id o,id a){
  CFTimeInterval t0=CACurrentMediaTime();
  if(On(k)){FQXDiagRecordHook(c,s,rule,"option_enabled","blocked",(CACurrentMediaTime()-t0)*1000.0);return NO;}
  BOOL r=((BOOL(*)(id,SEL,id))old)(o,x,a);
  FQXDiagRecordHook(c,s,rule,"option_off","allowed",(CACurrentMediaTime()-t0)*1000.0);
  return r;
 });
 if(!FQXDiagInstallOwnedHook(cls,c,x,NO,"B24@0:8@16",rule,hook,&old)){imp_removeBlock(hook);return NO;}return YES;
}
static BOOL Bool3(const char*c,const char*s,NSString*k){
 SEL x=Sel(s); Class cls=FQXLookupMatchingClass(c,x,NO,"B40@0:8@16@24@32"); if(!cls)return NO;
 __block IMP old=NULL;
 const char *rule=k.UTF8String;
 IMP hook=imp_implementationWithBlock(^BOOL(id o,id a,id b,id d){
  CFTimeInterval t0=CACurrentMediaTime();
  if(On(k)){FQXDiagRecordHook(c,s,rule,"option_enabled","blocked",(CACurrentMediaTime()-t0)*1000.0);return NO;}
  BOOL r=((BOOL(*)(id,SEL,id,id,id))old)(o,x,a,b,d);
  FQXDiagRecordHook(c,s,rule,"option_off","allowed",(CACurrentMediaTime()-t0)*1000.0);
  return r;
 });
 if(!FQXDiagInstallOwnedHook(cls,c,x,NO,"B40@0:8@16@24@32",rule,hook,&old)){imp_removeBlock(hook);return NO;}return YES;
}
static BOOL Object1(const char*c,const char*s,NSString*k){
 SEL x=Sel(s); Class cls=FQXLookupMatchingClass(c,x,NO,"@24@0:8@16"); if(!cls)return NO;
 __block IMP old=NULL;
 const char *rule=k.UTF8String;
 IMP hook=imp_implementationWithBlock(^id(id o,id a){
  CFTimeInterval t0=CACurrentMediaTime();
  if(On(k)){FQXDiagRecordHook(c,s,rule,"option_enabled","blocked",(CACurrentMediaTime()-t0)*1000.0);return nil;}
  id r=((id(*)(id,SEL,id))old)(o,x,a);
  FQXDiagRecordHook(c,s,rule,"option_off","allowed",(CACurrentMediaTime()-t0)*1000.0);
  return r;
 });
 if(!FQXDiagInstallOwnedHook(cls,c,x,NO,"@24@0:8@16",rule,hook,&old)){imp_removeBlock(hook);return NO;}return YES;
}
static BOOL GateConstBool0(const char *c, const char *s, BOOL cm, BOOL blockedVal, const char *rule, FQXGateFn gate) {
    SEL x = Sel(s);
    Class cls = FQXLookupMatchingClass(c, x, cm, "B16@0:8");
    if (!cls) return NO;
    __block IMP old = NULL;
    IMP hook = imp_implementationWithBlock(^BOOL(id o) {
        CFTimeInterval t0 = CACurrentMediaTime();
        if (gate()) {
            FQXDiagRecordHook(c, s, rule, "gate_active", "blocked", (CACurrentMediaTime() - t0) * 1000.0);
            return blockedVal;
        }
        BOOL r = ((BOOL (*)(id, SEL))old)(o, x);
        FQXDiagRecordHook(c, s, rule, "gate_off", "allowed", (CACurrentMediaTime() - t0) * 1000.0);
        return r;
    });
    if (!FQXDiagInstallOwnedHook(cls, c, x, cm, "B16@0:8", rule, hook, &old)) {
        imp_removeBlock(hook);
        return NO;
    }
    return YES;
}
static BOOL GateVoid0(const char *c, const char *s, BOOL cm, const char *rule, FQXGateFn gate) {
    SEL x = Sel(s);
    Class cls = FQXLookupMatchingClass(c, x, cm, "v16@0:8");
    if (!cls) return NO;
    __block IMP old = NULL;
    IMP hook = imp_implementationWithBlock(^(id o) {
        CFTimeInterval t0 = CACurrentMediaTime();
        if (gate()) {
            FQXDiagRecordHook(c, s, rule, "gate_active", "blocked", (CACurrentMediaTime() - t0) * 1000.0);
            return;
        }
        ((void (*)(id, SEL))old)(o, x);
        FQXDiagRecordHook(c, s, rule, "gate_off", "allowed", (CACurrentMediaTime() - t0) * 1000.0);
    });
    if (!FQXDiagInstallOwnedHook(cls, c, x, cm, "v16@0:8", rule, hook, &old)) {
        imp_removeBlock(hook);
        return NO;
    }
    return YES;
}
static BOOL GateVoid1Obj(const char *c, const char *s, BOOL cm, const char *rule, FQXGateFn gate) {
    SEL x = Sel(s);
    Class cls = FQXLookupMatchingClass(c, x, cm, "v24@0:8@16");
    if (!cls) return NO;
    __block IMP old = NULL;
    IMP hook = imp_implementationWithBlock(^(id o, id a) {
        CFTimeInterval t0 = CACurrentMediaTime();
        if (gate()) {
            FQXDiagRecordHook(c, s, rule, "gate_active", "blocked", (CACurrentMediaTime() - t0) * 1000.0);
            return;
        }
        ((void (*)(id, SEL, id))old)(o, x, a);
        FQXDiagRecordHook(c, s, rule, "gate_off", "allowed", (CACurrentMediaTime() - t0) * 1000.0);
    });
    if (!FQXDiagInstallOwnedHook(cls, c, x, cm, "v24@0:8@16", rule, hook, &old)) {
        imp_removeBlock(hook);
        return NO;
    }
    return YES;
}
static BOOL GateVoid2Obj(const char *c, const char *s, BOOL cm, const char *rule, FQXGateFn gate) {
    SEL x = Sel(s);
    Class cls = FQXLookupMatchingClass(c, x, cm, "v32@0:8@16@24");
    if (!cls) return NO;
    __block IMP old = NULL;
    IMP hook = imp_implementationWithBlock(^(id o, id a, id b) {
        CFTimeInterval t0 = CACurrentMediaTime();
        if (gate()) {
            FQXDiagRecordHook(c, s, rule, "gate_active", "blocked", (CACurrentMediaTime() - t0) * 1000.0);
            return;
        }
        ((void (*)(id, SEL, id, id))old)(o, x, a, b);
        FQXDiagRecordHook(c, s, rule, "gate_off", "allowed", (CACurrentMediaTime() - t0) * 1000.0);
    });
    if (!FQXDiagInstallOwnedHook(cls, c, x, cm, "v32@0:8@16@24", rule, hook, &old)) {
        imp_removeBlock(hook);
        return NO;
    }
    return YES;
}
static BOOL GateVoid1ObjBlock(const char *c, const char *s, BOOL cm, const char *rule, FQXGateFn gate) {
    SEL x = Sel(s);
    Class cls = FQXLookupMatchingClass(c, x, cm, "v32@0:8@16@?24");
    if (!cls) return NO;
    __block IMP old = NULL;
    IMP hook = imp_implementationWithBlock(^(id o, id a, id blk) {
        CFTimeInterval t0 = CACurrentMediaTime();
        if (gate()) {
            (void)blk;
            FQXDiagRecordHook(c, s, rule, "gate_active", "blocked", (CACurrentMediaTime() - t0) * 1000.0);
            return;
        }
        ((void (*)(id, SEL, id, id))old)(o, x, a, blk);
        FQXDiagRecordHook(c, s, rule, "gate_off", "allowed", (CACurrentMediaTime() - t0) * 1000.0);
    });
    if (!FQXDiagInstallOwnedHook(cls, c, x, cm, "v32@0:8@16@?24", rule, hook, &old)) {
        imp_removeBlock(hook);
        return NO;
    }
    return YES;
}
static BOOL GateBool1Obj(const char *c, const char *s, BOOL cm, const char *rule, FQXGateFn gate) {
    SEL x = Sel(s);
    Class cls = FQXLookupMatchingClass(c, x, cm, "B24@0:8@16");
    if (!cls) return NO;
    __block IMP old = NULL;
    IMP hook = imp_implementationWithBlock(^BOOL(id o, id a) {
        CFTimeInterval t0 = CACurrentMediaTime();
        if (gate()) {
            FQXDiagRecordHook(c, s, rule, "gate_active", "blocked", (CACurrentMediaTime() - t0) * 1000.0);
            return NO;
        }
        BOOL r = ((BOOL (*)(id, SEL, id))old)(o, x, a);
        FQXDiagRecordHook(c, s, rule, "gate_off", "allowed", (CACurrentMediaTime() - t0) * 1000.0);
        return r;
    });
    if (!FQXDiagInstallOwnedHook(cls, c, x, cm, "B24@0:8@16", rule, hook, &old)) {
        imp_removeBlock(hook);
        return NO;
    }
    return YES;
}
static BOOL GateBool1Class(const char *c, const char *s, BOOL cm, const char *rule, FQXGateFn gate) {
    SEL x = Sel(s);
    Class cls = FQXLookupMatchingClass(c, x, cm, "B24@0:8#16");
    if (!cls) return NO;
    __block IMP old = NULL;
    IMP hook = imp_implementationWithBlock(^BOOL(id o, Class a) {
        CFTimeInterval t0 = CACurrentMediaTime();
        if (gate()) {
            FQXDiagRecordHook(c, s, rule, "gate_active", "blocked", (CACurrentMediaTime() - t0) * 1000.0);
            return NO;
        }
        BOOL r = ((BOOL (*)(id, SEL, Class))old)(o, x, a);
        FQXDiagRecordHook(c, s, rule, "gate_off", "allowed", (CACurrentMediaTime() - t0) * 1000.0);
        return r;
    });
    if (!FQXDiagInstallOwnedHook(cls, c, x, cm, "B24@0:8#16", rule, hook, &old)) {
        imp_removeBlock(hook);
        return NO;
    }
    return YES;
}
static BOOL GateVoid1Class(const char *c, const char *s, BOOL cm, const char *rule, FQXGateFn gate) {
    SEL x = Sel(s);
    Class cls = FQXLookupMatchingClass(c, x, cm, "v24@0:8#16");
    if (!cls) return NO;
    __block IMP old = NULL;
    IMP hook = imp_implementationWithBlock(^(id o, Class a) {
        CFTimeInterval t0 = CACurrentMediaTime();
        if (gate()) {
            FQXDiagRecordHook(c, s, rule, "gate_active", "blocked", (CACurrentMediaTime() - t0) * 1000.0);
            return;
        }
        ((void (*)(id, SEL, Class))old)(o, x, a);
        FQXDiagRecordHook(c, s, rule, "gate_off", "allowed", (CACurrentMediaTime() - t0) * 1000.0);
    });
    if (!FQXDiagInstallOwnedHook(cls, c, x, cm, "v24@0:8#16", rule, hook, &old)) {
        imp_removeBlock(hook);
        return NO;
    }
    return YES;
}
static BOOL GateBool1UInt(const char *c, const char *s, BOOL cm, const char *rule, FQXGateFn gate) {
    SEL x = Sel(s);
    Class cls = FQXLookupMatchingClass(c, x, cm, "B24@0:8Q16");
    if (!cls) return NO;
    __block IMP old = NULL;
    IMP hook = imp_implementationWithBlock(^BOOL(id o, NSUInteger a) {
        CFTimeInterval t0 = CACurrentMediaTime();
        if (gate()) {
            FQXDiagRecordHook(c, s, rule, "gate_active", "blocked", (CACurrentMediaTime() - t0) * 1000.0);
            return NO;
        }
        BOOL r = ((BOOL (*)(id, SEL, NSUInteger))old)(o, x, a);
        FQXDiagRecordHook(c, s, rule, "gate_off", "allowed", (CACurrentMediaTime() - t0) * 1000.0);
        return r;
    });
    if (!FQXDiagInstallOwnedHook(cls, c, x, cm, "B24@0:8Q16", rule, hook, &old)) {
        imp_removeBlock(hook);
        return NO;
    }
    return YES;
}
static BOOL GateBool1Int(const char *c, const char *s, BOOL cm, const char *rule, FQXGateFn gate) {
    SEL x = Sel(s);
    Class cls = FQXLookupMatchingClass(c, x, cm, "B24@0:8q16");
    if (!cls) return NO;
    __block IMP old = NULL;
    IMP hook = imp_implementationWithBlock(^BOOL(id o, NSInteger a) {
        CFTimeInterval t0 = CACurrentMediaTime();
        if (gate()) {
            FQXDiagRecordHook(c, s, rule, "gate_active", "blocked", (CACurrentMediaTime() - t0) * 1000.0);
            return NO;
        }
        BOOL r = ((BOOL (*)(id, SEL, NSInteger))old)(o, x, a);
        FQXDiagRecordHook(c, s, rule, "gate_off", "allowed", (CACurrentMediaTime() - t0) * 1000.0);
        return r;
    });
    if (!FQXDiagInstallOwnedHook(cls, c, x, cm, "B24@0:8q16", rule, hook, &old)) {
        imp_removeBlock(hook);
        return NO;
    }
    return YES;
}
static BOOL GateNil0(const char *c, const char *s, BOOL cm, const char *rule, FQXGateFn gate) {
    SEL x = Sel(s);
    Class cls = FQXLookupMatchingClass(c, x, cm, "@16@0:8");
    if (!cls) return NO;
    __block IMP old = NULL;
    IMP hook = imp_implementationWithBlock(^id(id o) {
        CFTimeInterval t0 = CACurrentMediaTime();
        if (gate()) {
            FQXDiagRecordHook(c, s, rule, "gate_active", "blocked", (CACurrentMediaTime() - t0) * 1000.0);
            return nil;
        }
        id r = ((id (*)(id, SEL))old)(o, x);
        FQXDiagRecordHook(c, s, rule, "gate_off", "allowed", (CACurrentMediaTime() - t0) * 1000.0);
        return r;
    });
    if (!FQXDiagInstallOwnedHook(cls, c, x, cm, "@16@0:8", rule, hook, &old)) {
        imp_removeBlock(hook);
        return NO;
    }
    return YES;
}
static BOOL Void1(const char*c,const char*s,BOOL cm,NSString*k,const char*getter){
 SEL x=Sel(s); Class cls=FQXLookupMatchingClass(c,x,cm,"v24@0:8@16"); if(!cls)return NO;
 __block IMP old=NULL;
 const char *rule=k.UTF8String;
 IMP hook=imp_implementationWithBlock(^(id o,id a){
   CFTimeInterval t0=CACurrentMediaTime();
   if(!On(k)){((void(*)(id,SEL,id))old)(o,x,a);FQXDiagRecordHook(c,s,rule,"option_off","allowed",(CACurrentMediaTime()-t0)*1000.0);return;}
   if(getter){FQXDiagPushPluginViewReason(rule,s);id v=Get(o,getter);if([v isKindOfClass:UIView.class])((UIView *)v).hidden=YES;FQXDiagPopPluginViewReason();}
   FQXDiagRecordHook(c,s,rule,"option_enabled","blocked",(CACurrentMediaTime()-t0)*1000.0);
 });
 if(!FQXDiagInstallOwnedHook(cls,c,x,cm,"v24@0:8@16",rule,hook,&old)){imp_removeBlock(hook);return NO;}return YES;
}
static BOOL Void2(const char*c,const char*s,NSString*k,BOOL firstIsWidget){
 SEL x=Sel(s); Class cls=FQXLookupMatchingClass(c,x,NO,"v32@0:8@16@24"); if(!cls)return NO;
 __block IMP old=NULL;
 const char *rule=k.UTF8String;
 IMP hook=imp_implementationWithBlock(^(id o,id a,id b){
  CFTimeInterval t0=CACurrentMediaTime();
  id w=firstIsWidget?a:b;
  if(On(k)&&[w isEqual:@"widget_history"]){FQXDiagRecordHook(c,s,rule,"widget_history","blocked",(CACurrentMediaTime()-t0)*1000.0);return;}
  ((void(*)(id,SEL,id,id))old)(o,x,a,b);
  FQXDiagRecordHook(c,s,rule,"passthrough","allowed",(CACurrentMediaTime()-t0)*1000.0);
 });
 if(!FQXDiagInstallOwnedHook(cls,c,x,NO,"v32@0:8@16@24",rule,hook,&old)){imp_removeBlock(hook);return NO;}return YES;
}
static BOOL Void3(const char*c,const char*s,NSString*k,BOOL withBool){
 SEL x=Sel(s); const char *enc=withBool?"v44@0:8@16@24@32B40":"v40@0:8@16@24@32";
 Class cls=FQXLookupMatchingClass(c,x,NO,enc); if(!cls)return NO;
 __block IMP old=NULL;
 const char *rule=k.UTF8String;
 if(withBool){IMP hook=imp_implementationWithBlock(^(id o,id a,id b,id d,BOOL flag){
   CFTimeInterval t0=CACurrentMediaTime();
   if(On(k)){FQXDiagRecordHook(c,s,rule,"option_enabled","blocked",(CACurrentMediaTime()-t0)*1000.0);return;}
   ((void(*)(id,SEL,id,id,id,BOOL))old)(o,x,a,b,d,flag);
   FQXDiagRecordHook(c,s,rule,"option_off","allowed",(CACurrentMediaTime()-t0)*1000.0);
  });
  if(!FQXDiagInstallOwnedHook(cls,c,x,NO,enc,rule,hook,&old)){imp_removeBlock(hook);return NO;}return YES;}
 IMP hook=imp_implementationWithBlock(^(id o,id a,id b,id d){
  CFTimeInterval t0=CACurrentMediaTime();
  if(On(k)){FQXDiagRecordHook(c,s,rule,"option_enabled","blocked",(CACurrentMediaTime()-t0)*1000.0);return;}
  ((void(*)(id,SEL,id,id,id))old)(o,x,a,b,d);
  FQXDiagRecordHook(c,s,rule,"option_off","allowed",(CACurrentMediaTime()-t0)*1000.0);
 });
 if(!FQXDiagInstallOwnedHook(cls,c,x,NO,enc,rule,hook,&old)){imp_removeBlock(hook);return NO;}return YES;
}

static BOOL SuppressWidgetDialog(id dialog) {
 id view=Get(dialog,"contentView");
 // Never suppress or interfere with any security verification / BDTuring / Passport dialog.
 if(FQXDiagIsSecurityVerificationObject(dialog)||FQXDiagIsSecurityVerificationObject(view)||
    ([view isKindOfClass:UIView.class]&&FQXDiagIsSecurityVerificationHierarchy((UIView *)view))){
  FQXDiagRecordSecurityDialogCheck(dialog,view,"SSDialogView",NO);
  return NO;
 }
 Class history=objc_lookUpClass("SSWelfareWidgetGuideView");
 if(On(KEY("ContentWidgetGuide"))&&history&&[view isKindOfClass:history]&&
    [Get(view,"widgetName") isEqual:@"widget_history"]){
  SEL close=Sel("closeButtonClicked:");
  if([view respondsToSelector:close])((void(*)(id,SEL,id))objc_msgSend)(view,close,nil);
  FQXDiagRecordHook("SSDialogView","showInView:enqueue:","FanqieX.ContentWidgetGuide.1","widget_history_guide","blocked",0.0);
  return YES;
 }
 Class excerpt=objc_lookUpClass("SSBookExcerptWidgetGuideView");
 if(On(KEY("ExcerptWidgetGuide"))&&excerpt&&[view isKindOfClass:excerpt]){
  SEL cancel=Sel("cancelButtonClicked");
  if([view respondsToSelector:cancel])((void(*)(id,SEL))objc_msgSend)(view,cancel);
  FQXDiagRecordHook("SSDialogView","showInView:enqueue:","FanqieX.ExcerptWidgetGuide.1","book_excerpt_guide","blocked",0.0);
  return YES;
 }
 return NO;
}
static void(*OriginalDialogShow)(id,SEL,id,BOOL);
static void DialogShow(id o,SEL cmd,id view,BOOL enqueue){if(!SuppressWidgetDialog(o))OriginalDialogShow(o,cmd,view,enqueue);}
static void(*OriginalDialogInnerShow)(id,SEL,id);
static void DialogInnerShow(id o,SEL cmd,id view){if(!SuppressWidgetDialog(o))OriginalDialogInnerShow(o,cmd,view);}
static void InstallWidgetDialogHooks(void){
 Class c=objc_lookUpClass("SSDialogView");SEL s=Sel("showInView:enqueue:");IMP old=NULL;
 if(FQXInstallOwnedHook(c,s,NO,"v32@0:8@16B24",(IMP)DialogShow,&old))OriginalDialogShow=(void*)old;
 s=Sel("innerShowInView:");old=NULL;
 if(FQXInstallOwnedHook(c,s,NO,"v24@0:8@16",(IMP)DialogInnerShow,&old))OriginalDialogInnerShow=(void*)old;
}

// Keep foreground-only splash suppression isolated to the calling thread.
static _Thread_local NSUInteger ForegroundSplashDepth;
static void(*OriginalForegroundEnter)(id,SEL);
static void ForegroundEnter(id o,SEL cmd){
 ++ForegroundSplashDepth;
 if(OriginalForegroundEnter)OriginalForegroundEnter(o,cmd);
 if(ForegroundSplashDepth>0)--ForegroundSplashDepth;
}
static void(*OriginalSplashBanner)(id,SEL);
static void SplashBanner(id o,SEL cmd){
 if(!On(KEY("HotLaunchAds"))||!ForegroundSplashDepth)OriginalSplashBanner(o,cmd);
}
static void InstallHotLaunchHooks(void){
 NSString *key=KEY("HotLaunchAds");
 Bool0("SSReadingAdSplashService","shouldShowSplashAtHotLaunch",NO,key);
 Bool0("SSReadingAdSplashService","shouldShowSplashAdAtHotLaunchByThirdParty",NO,key);
 Class c=objc_lookUpClass("SSReadingAdSplashService");SEL s=Sel("appWillEnterForeground");IMP old=NULL;
 if(FQXInstallOwnedHook(c,s,NO,"v16@0:8",(IMP)ForegroundEnter,&old))OriginalForegroundEnter=(void*)old;
 s=Sel("showBannerTopViewInSplash");old=NULL;
 if(FQXInstallOwnedHook(c,s,NO,"v16@0:8",(IMP)SplashBanner,&old))OriginalSplashBanner=(void*)old;
}

static char ChapterTitleAssociation;
static void(*OriginalRefresh)(id,SEL,id,id,id);
static void RefreshChapterTitle(id o,SEL cmd,id top,id context,id book){
 // The reader can refresh before the original-novel route has created its top view.
 if(!top){
  OriginalRefresh(o,cmd,top,context,book);
  return;
 }
 id chapter=Get(context,"chapterInfo")?:Get(context,"currentChapterInfo");
 if(!chapter&&!context)chapter=Get(Get(o,"readerManager"),"currentChapterInfo");
 id title=Get(chapter,"chapterTitle");
 if(![title isKindOfClass:NSString.class]||![title length])title=nil;
 objc_setAssociatedObject(top,&ChapterTitleAssociation,On(KEY("ChapterTitle"))?title:nil,OBJC_ASSOCIATION_COPY_NONATOMIC);
 OriginalRefresh(o,cmd,top,context,book);
 if(title&&On(KEY("ChapterTitle"))){SEL set=Sel("setTitle:");if([top respondsToSelector:set])((void(*)(id,SEL,id))objc_msgSend)(top,set,title);}
}
static void(*OriginalSetTitle)(id,SEL,id);
static void SetChapterTitle(id o,SEL cmd,id title){id fixed=On(KEY("ChapterTitle"))?objc_getAssociatedObject(o,&ChapterTitleAssociation):nil;OriginalSetTitle(o,cmd,fixed?:title);}
static void InstallChapterTitle(void){
 Class c=objc_lookUpClass("SSReaderTopViewInsertManager");SEL s=Sel("refreshTopView:withPageContext:bookId:");__block IMP old=NULL;
 if(FQXInstallOwnedHook(c,s,NO,"v40@0:8@16@24@32",(IMP)RefreshChapterTitle,&old))OriginalRefresh=(void*)old;
 c=objc_lookUpClass("FQReaderTopView");s=Sel("setTitle:");old=NULL;
 if(FQXInstallOwnedHook(c,s,NO,"v24@0:8@16",(IMP)SetChapterTitle,&old))OriginalSetTitle=(void*)old;
}

static BOOL AdBlockActive(void){
 id v=[NSUserDefaults.standardUserDefaults objectForKey:@"FanqieAdBlock.Options.1"];
 return ![v respondsToSelector:@selector(integerValue)]||[v integerValue]!=0;
}
static void AdConstBool0(const char *c,const char *s,BOOL cm,BOOL blockedValue){
 Class cls=NSClassFromString([NSString stringWithUTF8String:c]);SEL x=Sel(s);__block IMP old=NULL;
 IMP hook=imp_implementationWithBlock(^BOOL(id o){
  CFTimeInterval t0=CACurrentMediaTime();
  if(AdBlockActive()){
   FQXDiagRecordHook(c,s,"FanqieAdBlock.ReaderInlineAd","adblock_active","blocked",(CACurrentMediaTime()-t0)*1000.0);
   return blockedValue;
  }
  BOOL r=((BOOL(*)(id,SEL))old)(o,x);
  FQXDiagRecordHook(c,s,"FanqieAdBlock.ReaderInlineAd","adblock_off","allowed",(CACurrentMediaTime()-t0)*1000.0);
  return r;
 });
 if(!FQXDiagInstallOwnedHook(cls,c,x,cm,"B16@0:8","FanqieAdBlock.ReaderInlineAd",hook,&old))imp_removeBlock(hook);
}
static void InstallReaderInlineDramaAdHooks(void){
 AdConstBool0("SSReaderGenreContentManager","contentEnable",NO,NO);
 AdConstBool0("SSReaderGenreContentManager","enable",NO,NO);
 AdConstBool0("SSReaderGenreContentManager","enableParagraphInsert",NO,NO);
 AdConstBool0("SSReaderGenreContentManager","noAdForAllScene",NO,YES);
 {
  Class cls=objc_lookUpClass("SSReaderGenreContentManager");
  SEL s1=Sel("requestContentForBookId:triggerStrategy:");__block IMP o1=NULL;
  IMP h1=imp_implementationWithBlock(^BOOL(id o,id b,NSInteger st){
   return AdBlockActive()?NO:((BOOL(*)(id,SEL,id,NSInteger))o1)(o,s1,b,st);
  });
  if(!FQXInstallOwnedHook(cls,s1,NO,"B32@0:8@16q24",h1,&o1))imp_removeBlock(h1);
  SEL s2=Sel("requestContentForBookId:triggerStrategy:fromIPStrategy:");__block IMP o2=NULL;
  IMP h2=imp_implementationWithBlock(^BOOL(id o,id b,NSInteger st,BOOL ip){
   return AdBlockActive()?NO:((BOOL(*)(id,SEL,id,NSInteger,BOOL))o2)(o,s2,b,st,ip);
  });
  if(!FQXInstallOwnedHook(cls,s2,NO,"B36@0:8@16q24B32",h2,&o2))imp_removeBlock(h2);
 }
 for(NSString *cn in @[@"SSReaderParaShortVideoManager",@"SSReaderParaShortVideoDataManager"]){
  Class cls=NSClassFromString(cn);
  SEL sc=Sel("isParaShortVideoClosedForBookId:");__block IMP oc=NULL;
  IMP hc=imp_implementationWithBlock(^BOOL(id o,id b){
   return AdBlockActive()?YES:((BOOL(*)(id,SEL,id))oc)(o,sc,b);
  });
  if(!FQXInstallOwnedHook(cls,sc,NO,"B24@0:8@16",hc,&oc))imp_removeBlock(hc);
  SEL ss=Sel("saveModel:bookId:");__block IMP os=NULL;
  IMP hs=imp_implementationWithBlock(^BOOL(id o,id m,id b){
   return AdBlockActive()?NO:((BOOL(*)(id,SEL,id,id))os)(o,ss,m,b);
  });
  if(!FQXInstallOwnedHook(cls,ss,NO,"B32@0:8@16@24",hs,&os))imp_removeBlock(hs);
 }
 {
  Class cls=objc_lookUpClass("SSReaderParaShortVideoManager");
  SEL sa=Sel("getVideoAttachmentsWithReaderModel:chapterId:containerWidth:");__block IMP oa=NULL;
  IMP ha=imp_implementationWithBlock(^id(id o,id rm,id cid,double w){
   return AdBlockActive()?nil:((id(*)(id,SEL,id,id,double))oa)(o,sa,rm,cid,w);
  });
  if(!FQXInstallOwnedHook(cls,sa,NO,"@40@0:8@16@24d32",ha,&oa))imp_removeBlock(ha);
  SEL si=Sel("insertViewWithAttachment:readerModel:");__block IMP oi=NULL;
  IMP hi=imp_implementationWithBlock(^id(id o,id att,id rm){
   return AdBlockActive()?nil:((id(*)(id,SEL,id,id))oi)(o,si,att,rm);
  });
  if(!FQXInstallOwnedHook(cls,si,NO,"@32@0:8@16@24",hi,&oi))imp_removeBlock(hi);
 }
 {
  Class cls=objc_lookUpClass("SSReaderParaShortVideoDataManager");
  SEL sd=Sel("attachmentsWithBookId:chapterId:containerWidth:textFontSize:");__block IMP od=NULL;
  IMP hd=imp_implementationWithBlock(^id(id o,id bid,id cid,double w,double fs){
   return AdBlockActive()?nil:((id(*)(id,SEL,id,id,double,double))od)(o,sd,bid,cid,w,fs);
  });
  if(!FQXInstallOwnedHook(cls,sd,NO,"@48@0:8@16@24d32d40",hd,&od))imp_removeBlock(hd);
 }
 {
  Class cls=objc_lookUpClass("SSReaderGenreContentRerankManager");
  SEL sr1=Sel("hasRecommendedContent:chapterIndex:pageIndex:pageCount:gap:");__block IMP or1=NULL;
  IMP hr1=imp_implementationWithBlock(^BOOL(id o,id bid,NSInteger ci,NSInteger pi,NSInteger pc,NSInteger g){
   return AdBlockActive()?NO:((BOOL(*)(id,SEL,id,NSInteger,NSInteger,NSInteger,NSInteger))or1)(o,sr1,bid,ci,pi,pc,g);
  });
  if(!FQXInstallOwnedHook(cls,sr1,NO,"B56@0:8@16q24q32q40q48",hr1,&or1))imp_removeBlock(hr1);
  SEL sr2=Sel("getNaturalConentRerankInsertedVCWithReadModel:curPageContext:targetPageContext:pageChangeInfo:");__block IMP or2=NULL;
  IMP hr2=imp_implementationWithBlock(^id(id o,id rm,id cur,id tgt,id info){
   return AdBlockActive()?nil:((id(*)(id,SEL,id,id,id,id))or2)(o,sr2,rm,cur,tgt,info);
  });
  if(!FQXInstallOwnedHook(cls,sr2,NO,"@48@0:8@16@24@32@40",hr2,&or2))imp_removeBlock(hr2);
  SEL sr3=Sel("shouldShowFeedRerankContentVCWithReaderModel:curPageContext:targetPageContext:pageChangeInfo:");__block IMP or3=NULL;
  IMP hr3=imp_implementationWithBlock(^BOOL(id o,id rm,id cur,id tgt,id info){
   return AdBlockActive()?NO:((BOOL(*)(id,SEL,id,id,id,id))or3)(o,sr3,rm,cur,tgt,info);
  });
  if(!FQXInstallOwnedHook(cls,sr3,NO,"B48@0:8@16@24@32@40",hr3,&or3))imp_removeBlock(hr3);
 }
 {
  Class cls=objc_lookUpClass("SSReaderLayoutProcessData");
  SEL sp=Sel("paraShortVideoAttachmentDict");__block IMP op=NULL;
  IMP hp=imp_implementationWithBlock(^id(id o){
   return AdBlockActive()?nil:((id(*)(id,SEL))op)(o,sp);
  });
  if(!FQXInstallOwnedHook(cls,sp,NO,"@16@0:8",hp,&op))imp_removeBlock(hp);
 }
}

static os_unfair_lock sAudioTrackLock = OS_UNFAIR_LOCK_INIT;
static __weak id sLastAudioSDKManager;
static NSHashTable *sTrackedTTSManagers;
static NSHashTable *sTrackedParaManagers;
static NSHashTable *sTrackedReaderPendantManagers;
static NSHashTable *sTrackedReaderPendantInsertObjs;
static NSHashTable *sTrackedWelfarePendantManagers;
static NSHashTable *sTrackedPreUnlockViewManagers;

static void TrackInWeakTable(NSHashTable * __strong *tableSlot, id obj) {
    if (!obj || !tableSlot) return;
    os_unfair_lock_lock(&sAudioTrackLock);
    if (!*tableSlot) *tableSlot = [NSHashTable weakObjectsHashTable];
    [*tableSlot addObject:obj];
    os_unfair_lock_unlock(&sAudioTrackLock);
}

static BOOL BoolMsg0(id o,const char *s){
 SEL x=Sel(s);return o&&[o respondsToSelector:x]?((BOOL(*)(id,SEL))objc_msgSend)(o,x):NO;
}
static void VoidMsg0(id o,const char *s){
 SEL x=Sel(s);if(o&&[o respondsToSelector:x])((void(*)(id,SEL))objc_msgSend)(o,x);
}
static void VoidMsgBool(id o,const char *s,BOOL v){
 SEL x=Sel(s);if(o&&[o respondsToSelector:x])((void(*)(id,SEL,BOOL))objc_msgSend)(o,x,v);
}
static void VoidMsgObj(id o,const char *s,id a){
 SEL x=Sel(s);if(o&&[o respondsToSelector:x])((void(*)(id,SEL,id))objc_msgSend)(o,x,a);
}
static void TrackAudioSDK(id sdk){
 if(!sdk)return;
 os_unfair_lock_lock(&sAudioTrackLock);
 sLastAudioSDKManager=sdk;
 os_unfair_lock_unlock(&sAudioTrackLock);
}
static void TrackTTSManager(id obj){
 if(!obj)return;
 os_unfair_lock_lock(&sAudioTrackLock);
 if(!sTrackedTTSManagers)sTrackedTTSManagers=[NSHashTable weakObjectsHashTable];
 [sTrackedTTSManagers addObject:obj];
 os_unfair_lock_unlock(&sAudioTrackLock);
}
static void TrackParaManager(id obj){
 if(!obj)return;
 os_unfair_lock_lock(&sAudioTrackLock);
 if(!sTrackedParaManagers)sTrackedParaManagers=[NSHashTable weakObjectsHashTable];
 [sTrackedParaManagers addObject:obj];
 os_unfair_lock_unlock(&sAudioTrackLock);
}
static NSArray *SnapshotTracked(NSHashTable *table){
 os_unfair_lock_lock(&sAudioTrackLock);
 NSArray *items=table?[table allObjects]:@[];
 os_unfair_lock_unlock(&sAudioTrackLock);
 return items;
}
static id FQXAudioSDKManager(void){
 os_unfair_lock_lock(&sAudioTrackLock);
 id cached=sLastAudioSDKManager;
 os_unfair_lock_unlock(&sAudioTrackLock);
 if(cached)return cached;
 Class centerCls=objc_lookUpClass("HTSServiceCenter");
 Class sdkCls=objc_lookUpClass("SSAudioPlaySDKManager");
 id center=Get((id)centerCls,"defaultCenter");
 SEL gs=Sel("getService:");
 if(center&&sdkCls&&[center respondsToSelector:gs]){
  id svc=((id(*)(id,SEL,Class))objc_msgSend)(center,gs,sdkCls);
  if(svc){TrackAudioSDK(svc);return svc;}
 }
 return nil;
}
static BOOL FQXAudioBookAlive(void){
 id sdk=FQXAudioSDKManager();
 if(!sdk||BoolMsg0(sdk,"audioStopped"))return NO;
 id bookId=Get(sdk,"currentBookId");
 if(![bookId isKindOfClass:NSString.class]||![(NSString *)bookId length])return NO;
 if(BoolMsg0(sdk,"playing")||BoolMsg0(sdk,"paused")||BoolMsg0(sdk,"loading"))return YES;
 id playMgr=Get(sdk,"bdfqPlayManager");
 return playMgr&&!BoolMsg0(playMgr,"playIsStopped")&&Get(playMgr,"playInfo")!=nil;
}
static BOOL FQXVideoNowPlayingActive(void){
 Class fqvCls=objc_lookUpClass("FQVNowPlayingInfoCenter");
 id fqv=Get((id)fqvCls,"defaultCenter");
 return fqv&&Get(fqv,"playingPlayer")!=nil;
}
static void FQXClearSystemNowPlayingIfIdle(void){
 if(FQXVideoNowPlayingActive()||FQXAudioBookAlive())return;
 Class mpCls=objc_lookUpClass("MPNowPlayingInfoCenter");
 id center=Get((id)mpCls,"defaultCenter");
 VoidMsgObj(center,"setNowPlayingInfo:",nil);
}
static id FQXFindParaManagerForReader(id readerMgr){
 NSArray *all=SnapshotTracked(sTrackedParaManagers);
 if(!all.count)return nil;
 if(readerMgr){
  for(id pm in all){
   if(Get(pm,"readerManager")==readerMgr)return pm;
  }
 }
 return all.lastObject;
}
static void FQXCleanStaleReaderAudioUIOnMain(void){
 // IMPORTANT: Never hide SSReaderTTSParagraphEntranceView or reset SSReaderTTSParaEntranceManager here!
 // SSReaderTTSParagraphEntranceView is the idle per-paragraph play-from-here arrow; hiding it on
 // reader entry wiped out paragraph play arrows whenever late snssdk config refreshes did not re-run.
 // Only clear FQReaderSaaSTTSManager's leftover "sync to active audio" button/line highlight when stopped.
 for(id ttsMgr in SnapshotTracked(sTrackedTTSManagers)){
  if(!BoolMsg0(ttsMgr,"isSyncing")&&!BoolMsg0(ttsMgr,"isActiveForCurrentBook")&&BoolMsg0(ttsMgr,"hasShowSyncBtn")){
   FQXDiagPushPluginViewReason("clean_stale_tts_sync_btn_only","FQXCleanStaleReaderAudioUIOnMain");
   VoidMsg0(ttsMgr,"stopAutoScroll");
   VoidMsg0(ttsMgr,"private_cleanCurrentLineInfo");
   VoidMsgBool(ttsMgr,"setHasShowSyncBtn:",NO);
   VoidMsg0(ttsMgr,"refreshSyncTTSBtn");
   VoidMsgBool(Get(ttsMgr,"readerMgr"),"setSyncTTSBtnHidden:",YES);
   FQXDiagPopPluginViewReason();
   FQXDiagRecordEvent(FQXDiagCategoryView,@"reader_stale_sync_cleaned",@{
    @"managerClass":@"FQReaderSaaSTTSManager",
    @"touchedParagraphEntrance":@NO,
   },NO);
  }
 }
}
static void FQXScheduleStaleReaderAudioUIClean(void){
 if([NSThread isMainThread])FQXCleanStaleReaderAudioUIOnMain();
 dispatch_async(dispatch_get_main_queue(),^{FQXCleanStaleReaderAudioUIOnMain();});
}
static void FQXEnsurePlaybackSessionActive(void){
 AVAudioSession *session=[AVAudioSession sharedInstance];
 if(![session.category isEqualToString:AVAudioSessionCategoryPlayback]||
    (session.categoryOptions&AVAudioSessionCategoryOptionMixWithOthers)!=0){
  [session setCategory:AVAudioSessionCategoryPlayback withOptions:0 error:nil];
 }
 [session setActive:YES error:nil];
}
static _Thread_local BOOL sInEnsureRemoteCommands;
static void FQXEnsureRemoteCommandsReadyOnMain(id playMgr,BOOL allowUpdateInfo){
 if(sInEnsureRemoteCommands||!playMgr||BoolMsg0(playMgr,"playIsStopped")||!Get(playMgr,"playInfo"))return;
 sInEnsureRemoteCommands=YES;
 Class fqvCls=objc_lookUpClass("FQVNowPlayingInfoCenter");
 id fqv=Get((id)fqvCls,"defaultCenter");
 if(fqv&&!Get(fqv,"playingPlayer")&&BoolMsg0(fqv,"remoteCommandTargetSelf")){
  VoidMsg0(fqv,"removeRemoteCommandTarget");
 }
 if(!Get(playMgr,"playCommand")||!Get(playMgr,"pauseCommand")||!Get(playMgr,"togglePlayPauseCommand")){
  VoidMsg0(playMgr,"remoteAddCommand");
 }
 Class ccCls=objc_lookUpClass("MPRemoteCommandCenter");
 id cc=Get((id)ccCls,"sharedCommandCenter");
 for(const char **k=(const char *[]){"playCommand","pauseCommand","togglePlayPauseCommand","previousTrackCommand","nextTrackCommand",NULL};*k;++k){
  VoidMsgBool(Get(cc,*k),"setEnabled:",YES);
 }
 [UIApplication.sharedApplication beginReceivingRemoteControlEvents];
 if(allowUpdateInfo&&!Get(playMgr,"remotePlayInfo")){
  Class mpCls=objc_lookUpClass("MPNowPlayingInfoCenter");
  id mpCenter=Get((id)mpCls,"defaultCenter");
  NSDictionary *info=Get(mpCenter,"nowPlayingInfo");
  if(![info isKindOfClass:NSDictionary.class]||!info.count){
   VoidMsg0(playMgr,"remoteUpdatePlayInfo");
  }
 }
 sInEnsureRemoteCommands=NO;
}
static void FQXEnsureRemoteCommandsReadyEx(id playMgr,BOOL allowUpdateInfo){
 if(!playMgr)return;
 if([NSThread isMainThread]){
  FQXEnsureRemoteCommandsReadyOnMain(playMgr,allowUpdateInfo);
 }else{
  dispatch_async(dispatch_get_main_queue(),^{FQXEnsureRemoteCommandsReadyOnMain(playMgr,allowUpdateInfo);});
 }
}
static void FQXEnsureRemoteCommandsReady(id playMgr){
 FQXEnsureRemoteCommandsReadyEx(playMgr,YES);
}
static void InstallAudioBookSyncAndRemoteHooks(void){
 {
  Class cls=objc_lookUpClass("FQReaderSaaSTTSManager");
  SEL si=Sel("initWithReaderManager:");__block IMP oi=NULL;
  IMP hi=imp_implementationWithBlock(^id(id o,id rm){
   id res=((id(*)(id,SEL,id))oi)(o,si,rm);
   TrackTTSManager(res);
   return res;
  });
  if(!FQXInstallOwnedHook(cls,si,NO,"@24@0:8@16",hi,&oi))imp_removeBlock(hi);
  SEL sa=Sel("onReaderDidAppear:");__block IMP oa=NULL;
  IMP ha=imp_implementationWithBlock(^(id o,id rm){
   TrackTTSManager(o);
   ((void(*)(id,SEL,id))oa)(o,sa,rm);
   if(!BoolMsg0(o,"isSyncing")&&!BoolMsg0(o,"isActiveForCurrentBook")&&BoolMsg0(o,"hasShowSyncBtn")){
    FQXScheduleStaleReaderAudioUIClean();
   }
   __weak id weakTTS=o;
   __weak id weakRM=rm;
   dispatch_after(dispatch_time(DISPATCH_TIME_NOW,(int64_t)(350*NSEC_PER_MSEC)),dispatch_get_main_queue(),^{
    id strongTTS=weakTTS;
    id strongRM=weakRM;
    if(!strongTTS&&!strongRM)return;
    FQXDiagRecordReaderTTSCheck(strongTTS,FQXFindParaManagerForReader(strongRM),strongRM,"onReaderDidAppear_350ms");
   });
  });
  if(!FQXInstallOwnedHook(cls,sa,NO,"v24@0:8@16",ha,&oa))imp_removeBlock(ha);
 }
 {
  Class cls=objc_lookUpClass("SSReaderTTSParaEntranceManager");
  SEL si=Sel("initWithReaderManager:");__block IMP oi=NULL;
  IMP hi=imp_implementationWithBlock(^id(id o,id rm){
   id res=((id(*)(id,SEL,id))oi)(o,si,rm);
   TrackParaManager(res);
   FQXDiagRecordReaderTTSCheck(nil,res,rm,"paraEntranceManager_init");
   return res;
  });
  if(!FQXInstallOwnedHook(cls,si,NO,"@24@0:8@16",hi,&oi))imp_removeBlock(hi);
 }
 {
  Class cls=objc_lookUpClass("BDFQAVSpecialLogicConfig");
  SEL sShow=Sel("showCommandCenter");__block IMP oShow=NULL;
  IMP hShow=imp_implementationWithBlock(^BOOL(id o){
   if(FQXAudioBookAlive()&&!FQXVideoNowPlayingActive())return YES;
   return ((BOOL(*)(id,SEL))oShow)(o,sShow);
  });
  if(!FQXInstallOwnedHook(cls,sShow,NO,"B16@0:8",hShow,&oShow))imp_removeBlock(hShow);
  SEL sMix=Sel("allowMixPlayWithOthers");__block IMP oMix=NULL;
  IMP hMix=imp_implementationWithBlock(^BOOL(id o){
   if(FQXAudioBookAlive()&&!FQXVideoNowPlayingActive())return NO;
   return ((BOOL(*)(id,SEL))oMix)(o,sMix);
  });
  if(!FQXInstallOwnedHook(cls,sMix,NO,"B16@0:8",hMix,&oMix))imp_removeBlock(hMix);
  SEL sOpt=Sel("optionsForAudioSessionActive");__block IMP oOpt=NULL;
  IMP hOpt=imp_implementationWithBlock(^NSUInteger(id o){
   NSUInteger opts=((NSUInteger(*)(id,SEL))oOpt)(o,sOpt);
   if(FQXAudioBookAlive()&&!FQXVideoNowPlayingActive()){
    opts&=~(NSUInteger)AVAudioSessionCategoryOptionMixWithOthers;
   }
   return opts;
  });
  if(!FQXInstallOwnedHook(cls,sOpt,NO,"Q16@0:8",hOpt,&oOpt))imp_removeBlock(hOpt);
 }
 {
  Class cls=objc_lookUpClass("SSAudioMutualExclutionManager");
  SEL sr=Sel("removeAudioRemoteCommandIfNeeded");__block IMP orv=NULL;
  IMP hr=imp_implementationWithBlock(^(id o){
   if(FQXAudioBookAlive()&&!FQXVideoNowPlayingActive()){
    id sdk=FQXAudioSDKManager();
    FQXEnsureRemoteCommandsReady(Get(sdk,"bdfqPlayManager"));
    return;
   }
   ((void(*)(id,SEL))orv)(o,sr);
  });
  if(!FQXInstallOwnedHook(cls,sr,NO,"v16@0:8",hr,&orv))imp_removeBlock(hr);
 }
 {
  Class cls=objc_lookUpClass("SSAudioPlaySDKManager");
  SEL sEar=Sel("enableEarphoneControl");__block IMP oEar=NULL;
  IMP hEar=imp_implementationWithBlock(^BOOL(id o){
   TrackAudioSDK(o);(void)oEar;return YES;
  });
  if(!FQXInstallOwnedHook(cls,sEar,NO,"B16@0:8",hEar,&oEar))imp_removeBlock(hEar);
  SEL sOther=Sel("enablePlayWithOtherAPP");__block IMP oOther=NULL;
  IMP hOther=imp_implementationWithBlock(^BOOL(id o){
   TrackAudioSDK(o);
   if(FQXAudioBookAlive()&&!FQXVideoNowPlayingActive())return NO;
   return ((BOOL(*)(id,SEL))oOther)(o,sOther);
  });
  if(!FQXInstallOwnedHook(cls,sOther,NO,"B16@0:8",hOther,&oOther))imp_removeBlock(hOther);
  SEL sTry=Sel("audioTryToPlayWithType:time:readerPoint:entry:");__block IMP oTry=NULL;
  IMP hTry=imp_implementationWithBlock(^(id o,NSUInteger tp,double tm,id rp,id entry){
   TrackAudioSDK(o);
   NSString *entryStr=[entry isKindOfClass:NSString.class]?(NSString *)entry:@"";
   FQXDiagRecordTTSPlaybackEvent(o,Get(o,"bdfqPlayManager"),rp,entryStr,"audioTryToPlay_begin",NO);
   FQXEnsurePlaybackSessionActive();
   ((void(*)(id,SEL,NSUInteger,double,id,id))oTry)(o,sTry,tp,tm,rp,entry);
   FQXEnsureRemoteCommandsReady(Get(o,"bdfqPlayManager"));
   FQXDiagRecordTTSPlaybackEvent(o,Get(o,"bdfqPlayManager"),rp,entryStr,"audioTryToPlay_invoked",YES);
  });
  if(!FQXInstallOwnedHook(cls,sTry,NO,"v48@0:8Q16d24@32@40",hTry,&oTry))imp_removeBlock(hTry);
  SEL sPau=Sel("audioPauseWithType:entry:");__block IMP oPau=NULL;
  IMP hPau=imp_implementationWithBlock(^(id o,NSUInteger tp,id entry){
   TrackAudioSDK(o);
   ((void(*)(id,SEL,NSUInteger,id))oPau)(o,sPau,tp,entry);
   if(!BoolMsg0(o,"audioStopped")&&!FQXVideoNowPlayingActive()){
    FQXEnsurePlaybackSessionActive();
    FQXEnsureRemoteCommandsReady(Get(o,"bdfqPlayManager"));
   }
   FQXDiagRecordTTSPlaybackEvent(o,Get(o,"bdfqPlayManager"),nil,
                                 [entry isKindOfClass:NSString.class]?(NSString *)entry:@"",
                                 "audioPause",NO);
  });
  if(!FQXInstallOwnedHook(cls,sPau,NO,"v32@0:8Q16@24",hPau,&oPau))imp_removeBlock(hPau);
  SEL sSt=Sel("player:playbackStateDidChange:");__block IMP oSt=NULL;
  IMP hSt=imp_implementationWithBlock(^(id o,id pl,NSUInteger st){
   TrackAudioSDK(o);
   ((void(*)(id,SEL,id,NSUInteger))oSt)(o,sSt,pl,st);
   if(FQXAudioBookAlive()&&!FQXVideoNowPlayingActive()){
    FQXEnsurePlaybackSessionActive();
    FQXEnsureRemoteCommandsReady(Get(o,"bdfqPlayManager"));
   }
   FQXDiagRecordTTSPlaybackEvent(o,Get(o,"bdfqPlayManager"),nil,
                                 [NSString stringWithFormat:@"state=%lu",(unsigned long)st],
                                 "playbackStateDidChange",NO);
  });
  if(!FQXInstallOwnedHook(cls,sSt,NO,"v32@0:8@16Q24",hSt,&oSt))imp_removeBlock(hSt);
  SEL sRem=Sel("remoteRemoveCommandWithSource:");__block IMP oRem=NULL;
  IMP hRem=imp_implementationWithBlock(^(id o,id src){
   TrackAudioSDK(o);
   if(![src isEqual:@"fqx_stop"]&&FQXAudioBookAlive()&&!FQXVideoNowPlayingActive()){
    FQXEnsureRemoteCommandsReady(Get(o,"bdfqPlayManager"));
    return;
   }
   ((void(*)(id,SEL,id))oRem)(o,sRem,src);
  });
  if(!FQXInstallOwnedHook(cls,sRem,NO,"v24@0:8@16",hRem,&oRem))imp_removeBlock(hRem);
  for(NSString *sn in @[@"audioResetWithEntry:",@"audioStopWithEntry:"]){
   SEL s=NSSelectorFromString(sn);__block IMP old=NULL;
   IMP h=imp_implementationWithBlock(^(id o,id entry){
    TrackAudioSDK(o);
    ((void(*)(id,SEL,id))old)(o,s,entry);
    VoidMsgObj(o,"remoteRemoveCommandWithSource:",@"fqx_stop");
    VoidMsg0(o,"remoteClearPlayInfo");
    FQXClearSystemNowPlayingIfIdle();
    FQXScheduleStaleReaderAudioUIClean();
    FQXDiagRecordTTSPlaybackEvent(o,Get(o,"bdfqPlayManager"),nil,
                                  [entry isKindOfClass:NSString.class]?(NSString *)entry:sn,
                                  "audioStoppedOrReset",NO);
   });
   if(!FQXInstallOwnedHook(cls,s,NO,"v24@0:8@16",h,&old))imp_removeBlock(h);
  }
  SEL sb=Sel("shouldBlockAVAudioSessionCategoryChange:");__block IMP ob=NULL;
  IMP hb=imp_implementationWithBlock(^BOOL(id o,id cat){
   TrackAudioSDK(o);
   if(((BOOL(*)(id,SEL,id))ob)(o,sb,cat))return YES;
   if(FQXAudioBookAlive()&&[cat isKindOfClass:NSString.class]&&
      ![(NSString *)cat isEqualToString:AVAudioSessionCategoryPlayback]){
    return YES;
   }
   return NO;
  });
  if(!FQXInstallOwnedHook(cls,sb,NO,"B24@0:8@16",hb,&ob))imp_removeBlock(hb);
 }
 {
  Class cls=objc_lookUpClass("SSAudioServiceABTestHelper");
  SEL sr=Sel("audioPlaybackCategoryRecoverEnable");__block IMP orv=NULL;
  IMP hr=imp_implementationWithBlock(^BOOL(id o){
   (void)o;(void)orv;return YES;
  });
  if(!FQXInstallOwnedHook(cls,sr,YES,"B16@0:8",hr,&orv))imp_removeBlock(hr);
 }
 {
  Class cls=objc_lookUpClass("FQVNowPlayingInfoCenter");
  SEL s1=Sel("resignPlayingPlayer:");__block IMP o1=NULL;
  IMP h1=imp_implementationWithBlock(^(id o,id player){
   BOOL hadTarget=BoolMsg0(o,"remoteCommandTargetSelf");
   id curPlayer=Get(o,"playingPlayer");
   if(!hadTarget&&!curPlayer&&FQXAudioBookAlive())return;
   ((void(*)(id,SEL,id))o1)(o,s1,player);
   if(!Get(o,"playingPlayer")&&FQXAudioBookAlive()){
    id sdk=FQXAudioSDKManager();
    FQXEnsurePlaybackSessionActive();
    VoidMsg0(sdk,"remoteAddCommand");
    VoidMsg0(sdk,"remoteUpdatePlayInfo");
    FQXEnsureRemoteCommandsReady(Get(sdk,"bdfqPlayManager"));
   }
  });
  if(!FQXInstallOwnedHook(cls,s1,NO,"v24@0:8@16",h1,&o1))imp_removeBlock(h1);
  SEL s2=Sel("refreshRemoteCommandEnable");__block IMP o2=NULL;
  IMP h2=imp_implementationWithBlock(^(id o){
   if(!Get(o,"playingPlayer")&&FQXAudioBookAlive()){
    if(BoolMsg0(o,"remoteCommandTargetSelf"))VoidMsg0(o,"removeRemoteCommandTarget");
    id sdk=FQXAudioSDKManager();
    FQXEnsureRemoteCommandsReadyEx(Get(sdk,"bdfqPlayManager"),NO);
    return;
   }
   ((void(*)(id,SEL))o2)(o,s2);
  });
  if(!FQXInstallOwnedHook(cls,s2,NO,"v16@0:8",h2,&o2))imp_removeBlock(h2);
 }
 {
  Class cls=objc_lookUpClass("BDFQPlayManager");
  SEL sp=Sel("pauseWithSource:");__block IMP op=NULL;
  IMP hp=imp_implementationWithBlock(^(id o,id src){
   ((void(*)(id,SEL,id))op)(o,sp,src);
   if(!FQXVideoNowPlayingActive()&&!BoolMsg0(o,"playIsStopped")&&Get(o,"playInfo")){
    FQXEnsurePlaybackSessionActive();
    FQXEnsureRemoteCommandsReady(o);
   }
  });
  if(!FQXInstallOwnedHook(cls,sp,NO,"v24@0:8@16",hp,&op))imp_removeBlock(hp);
  SEL sw=Sel("appWillResignActive:");__block IMP ow=NULL;
  IMP hw=imp_implementationWithBlock(^(id o,id note){
   ((void(*)(id,SEL,id))ow)(o,sw,note);
   if(!FQXVideoNowPlayingActive()&&!BoolMsg0(o,"playIsStopped")&&Get(o,"playInfo")){
    FQXEnsurePlaybackSessionActive();
    FQXEnsureRemoteCommandsReady(o);
   }
  });
  if(!FQXInstallOwnedHook(cls,sw,NO,"v24@0:8@16",hw,&ow))imp_removeBlock(hw);
  SEL sd=Sel("disableAllRemoteCommands");__block IMP od=NULL;
  IMP hd=imp_implementationWithBlock(^(id o){
   if(!FQXVideoNowPlayingActive()&&FQXAudioBookAlive()&&!BoolMsg0(o,"playIsStopped")&&Get(o,"playInfo")){
    FQXEnsureRemoteCommandsReadyEx(o,NO);
    return;
   }
   ((void(*)(id,SEL))od)(o,sd);
  });
  if(!FQXInstallOwnedHook(cls,sd,NO,"v16@0:8",hd,&od))imp_removeBlock(hd);
  SEL srd=Sel("remoteRemoveCommandAndInfoWithDelayEnable:reason:");__block IMP ord=NULL;
  IMP hrd=imp_implementationWithBlock(^(id o,BOOL delay,id reason){
   if(!FQXVideoNowPlayingActive()&&FQXAudioBookAlive()&&!BoolMsg0(o,"playIsStopped")&&Get(o,"playInfo")){
    FQXEnsureRemoteCommandsReady(o);
    return;
   }
   ((void(*)(id,SEL,BOOL,id))ord)(o,srd,delay,reason);
  });
  if(!FQXInstallOwnedHook(cls,srd,NO,"v28@0:8B16@20",hrd,&ord))imp_removeBlock(hrd);
  SEL ss=Sel("stopWithNeedResetPlayList:delayClosePlayer:");__block IMP os=NULL;
  IMP hs=imp_implementationWithBlock(^(id o,BOOL resetList,BOOL delayClose){
   ((void(*)(id,SEL,BOOL,BOOL))os)(o,ss,resetList,delayClose);
   VoidMsg0(o,"remoteClearPlayInfo");
   if(resetList){
    VoidMsg0(o,"remoteRemoveCommandAndClearInfo");
    FQXClearSystemNowPlayingIfIdle();
   }
  });
  if(!FQXInstallOwnedHook(cls,ss,NO,"v24@0:8B16B20",hs,&os))imp_removeBlock(hs);
  for(NSString *sn in @[@"remoteUpdatePlayInfo",@"remoteUpdateProgressInfo"]){
   SEL su=NSSelectorFromString(sn);__block IMP ou=NULL;
   IMP hu=imp_implementationWithBlock(^(id o){
    if(BoolMsg0(o,"playIsStopped")||!Get(o,"playInfo")){
     VoidMsg0(o,"remoteClearPlayInfo");
     FQXClearSystemNowPlayingIfIdle();
     return;
    }
    ((void(*)(id,SEL))ou)(o,su);
    FQXEnsureRemoteCommandsReadyEx(o,NO);
   });
   if(!FQXInstallOwnedHook(cls,su,NO,"v16@0:8",hu,&ou))imp_removeBlock(hu);
  }
  SEL st=Sel("tryToPlayAtTime:position:disableIntercept:source:");__block IMP ot=NULL;
  IMP ht=imp_implementationWithBlock(^(id o,double t,id pos,BOOL disInt,id src){
   NSString *srcStr=[src isKindOfClass:NSString.class]?(NSString *)src:@"";
   BOOL isResumeSrc=NO;
   if(srcStr.length){
    if([srcStr isEqualToString:@"play"]||[srcStr isEqualToString:@"toggle"]||
       [srcStr rangeOfString:@"remote" options:NSCaseInsensitiveSearch].location!=NSNotFound||
       [srcStr rangeOfString:@"toggle" options:NSCaseInsensitiveSearch].location!=NSNotFound){
     isResumeSrc=YES;
     FQXEnsurePlaybackSessionActive();
    }
   }
   int hasMask=0;
   unsigned int mask=FQXReadLegacyAdOptionsMask(&hasMask);
   if(FQXShouldForceDisableAudioPlayIntercept(hasMask,mask,On(KEY("AudioAds"))?1:0,isResumeSrc?1:0)){
    disInt=YES;
   }
   ((void(*)(id,SEL,double,id,BOOL,id))ot)(o,st,t,pos,disInt,src);
   FQXDiagRecordTTSPlaybackEvent(FQXAudioSDKManager(),o,pos,srcStr,"bdfqTryToPlayAtTime",YES);
  });
  if(!FQXInstallOwnedHook(cls,st,NO,"v44@0:8d16@24B32@36",ht,&ot))imp_removeBlock(ht);
 }
}

static char kFQXControlledHostHiddenKey;
static char kFQXControlledForcedHiddenKey;
static _Thread_local BOOL sFQXInternalSetHidden = NO;

static void FQXSyncControlledViewHidden(UIView *view, BOOL forceHide) {
    if (![view isKindOfClass:UIView.class]) return;
    if (forceHide) {
        if (!objc_getAssociatedObject(view, &kFQXControlledHostHiddenKey)) {
            objc_setAssociatedObject(view, &kFQXControlledHostHiddenKey, @(view.hidden), OBJC_ASSOCIATION_RETAIN_NONATOMIC);
        }
        objc_setAssociatedObject(view, &kFQXControlledForcedHiddenKey, @YES, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
        if (!view.hidden) {
            sFQXInternalSetHidden = YES;
            view.hidden = YES;
            sFQXInternalSetHidden = NO;
        }
    } else if (objc_getAssociatedObject(view, &kFQXControlledForcedHiddenKey)) {
        NSNumber *hostHidden = objc_getAssociatedObject(view, &kFQXControlledHostHiddenKey);
        objc_setAssociatedObject(view, &kFQXControlledForcedHiddenKey, nil, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
        BOOL targetHidden = hostHidden ? hostHidden.boolValue : NO;
        if (view.hidden != targetHidden) {
            sFQXInternalSetHidden = YES;
            view.hidden = targetHidden;
            sFQXInternalSetHidden = NO;
        }
    }
}

static void InstallControlledViewVisibilityHooks(const char *className, const char *rule, FQXGateFn gate) {
    Class cls = objc_lookUpClass(className);
    if (!cls) return;
    SEL setHiddenSel = Sel("setHidden:");
    __block IMP origSetHidden = NULL;
    IMP setHiddenHook = imp_implementationWithBlock(^(UIView *v, BOOL hidden) {
        if (!sFQXInternalSetHidden) {
            objc_setAssociatedObject(v, &kFQXControlledHostHiddenKey, @(hidden), OBJC_ASSOCIATION_RETAIN_NONATOMIC);
        }
        if (gate()) {
            objc_setAssociatedObject(v, &kFQXControlledForcedHiddenKey, @YES, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
            FQXDiagPushPluginViewReason(rule, "setHidden:");
            ((void (*)(id, SEL, BOOL))origSetHidden)(v, setHiddenSel, YES);
            FQXDiagPopPluginViewReason();
            return;
        }
        objc_setAssociatedObject(v, &kFQXControlledForcedHiddenKey, nil, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
        ((void (*)(id, SEL, BOOL))origSetHidden)(v, setHiddenSel, hidden);
    });
    if (!FQXInstallOwnedHook(cls, setHiddenSel, NO, "v20@0:8B16", setHiddenHook, &origSetHidden)) {
        imp_removeBlock(setHiddenHook);
    }

    for (NSString *selName in @[@"didMoveToWindow", @"layoutSubviews"]) {
        SEL s = NSSelectorFromString(selName);
        __block IMP orig = NULL;
        IMP h = imp_implementationWithBlock(^(UIView *v) {
            ((void (*)(id, SEL))orig)(v, s);
            if (gate()) {
                FQXDiagPushPluginViewReason(rule, selName.UTF8String);
                FQXSyncControlledViewHidden(v, YES);
                FQXDiagPopPluginViewReason();
            }
        });
        if (!FQXInstallOwnedHook(cls, s, NO, "v16@0:8", h, &orig)) {
            imp_removeBlock(h);
        }
    }
}

static void FQXWalkWindowViewsForPendantRefresh(UIView *root,
                                                NSInteger depth,
                                                BOOL hideReaderAudioPendant,
                                                BOOL hideWelfarePendant,
                                                BOOL hideAudioGate) {
    if (![root isKindOfClass:UIView.class] || depth > 20) return;
    static Class sReaderPendantViewCls, sReaderPendantTipCls, sPreUnlockBarCls;
    static Class sWelfarePendantCls, sWelfareCircleCls, sWelfareCouponCls;
    static dispatch_once_t once;
    dispatch_once(&once, ^{
        sReaderPendantViewCls = objc_lookUpClass("SSBizAudioAdNewReaderPendantView");
        sReaderPendantTipCls  = objc_lookUpClass("SSBizAudioAdNewReaderPendantTipView");
        sPreUnlockBarCls      = objc_lookUpClass("SSBizAudioAdPreUnlockBarView");
        sWelfarePendantCls    = objc_lookUpClass("SSWelfarePendant");
        sWelfareCircleCls     = objc_lookUpClass("SSWelfarePendantCircleView");
        sWelfareCouponCls     = objc_lookUpClass("SSWelfarePendantBookCouponView");
    });

    if ((sReaderPendantViewCls && [root isKindOfClass:sReaderPendantViewCls]) ||
        (sReaderPendantTipCls && [root isKindOfClass:sReaderPendantTipCls])) {
        FQXSyncControlledViewHidden(root, hideReaderAudioPendant);
        return;
    }
    if (sPreUnlockBarCls && [root isKindOfClass:sPreUnlockBarCls]) {
        if (hideAudioGate) VoidMsg0(root, "stopCountDown");
        FQXSyncControlledViewHidden(root, hideAudioGate);
        return;
    }
    if ((sWelfarePendantCls && [root isKindOfClass:sWelfarePendantCls]) ||
        (sWelfareCircleCls && [root isKindOfClass:sWelfareCircleCls]) ||
        (sWelfareCouponCls && [root isKindOfClass:sWelfareCouponCls])) {
        FQXSyncControlledViewHidden(root, hideWelfarePendant);
        return;
    }

    for (UIView *sub in root.subviews) {
        FQXWalkWindowViewsForPendantRefresh(sub, depth + 1, hideReaderAudioPendant, hideWelfarePendant, hideAudioGate);
    }
}

static int FQXCurrentPendantAndAudioGateStateMask(void) {
    int m = 0;
    if (FQXReaderAudioPendantBlocked()) m |= 1;
    if (FQXWelfarePendantBlocked()) m |= 2;
    if (FQXAudioAdGateBlocked()) m |= 4;
    return m;
}

static _Atomic int sLastObservedGateStateMask = -1;

void FQXRefreshReaderAndAudioPendants(void) {
    if (![NSThread isMainThread]) {
        dispatch_async(dispatch_get_main_queue(), ^{ FQXRefreshReaderAndAudioPendants(); });
        return;
    }
    static BOOL sRefreshing = NO;
    if (sRefreshing) return;
    sRefreshing = YES;

    BOOL hideReaderAudioPendant = FQXReaderAudioPendantBlocked();
    BOOL hideWelfarePendant = FQXWelfarePendantBlocked();
    BOOL hideAudioGate = FQXAudioAdGateBlocked();
    atomic_store_explicit(&sLastObservedGateStateMask, FQXCurrentPendantAndAudioGateStateMask(), memory_order_relaxed);

    FQXDiagPushPluginViewReason("FanqieX.PendantAndAudioGateRefresh", "FQXRefreshReaderAndAudioPendants");

    for (id mgr in SnapshotTracked(sTrackedReaderPendantManagers)) {
        id v = Get(mgr, "view");
        if (hideReaderAudioPendant) {
            VoidMsg0(mgr, "hideTip");
            VoidMsg0(mgr, "hidePendantView");
            if ([v isKindOfClass:UIView.class]) FQXSyncControlledViewHidden((UIView *)v, YES);
        } else {
            if ([v isKindOfClass:UIView.class]) FQXSyncControlledViewHidden((UIView *)v, NO);
            VoidMsg0(mgr, "updateViewTaskPanelState");
        }
    }

    for (id ins in SnapshotTracked(sTrackedReaderPendantInsertObjs)) {
        id pv = Get(ins, "ttsPreunlockPendant");
        if (hideReaderAudioPendant) {
            VoidMsg0(ins, "hideFloatingBtnFromPendant");
            if ([pv isKindOfClass:UIView.class]) FQXSyncControlledViewHidden((UIView *)pv, YES);
        } else {
            if ([pv isKindOfClass:UIView.class]) FQXSyncControlledViewHidden((UIView *)pv, NO);
        }
    }

    for (id wm in SnapshotTracked(sTrackedWelfarePendantManagers)) {
        if (hideWelfarePendant) {
            VoidMsg0(wm, "dismissPendant");
            VoidMsg0(wm, "tryDismissPendant");
            VoidMsg0(wm, "removeHoverView");
            id cpv = Get(wm, "currentPendantView");
            if ([cpv isKindOfClass:UIView.class]) FQXSyncControlledViewHidden((UIView *)cpv, YES);
            id khv = Get(wm, "currentKmpHoverBridgeView");
            if ([khv isKindOfClass:UIView.class]) FQXSyncControlledViewHidden((UIView *)khv, YES);
        } else {
            id cpv = Get(wm, "currentPendantView");
            if ([cpv isKindOfClass:UIView.class]) FQXSyncControlledViewHidden((UIView *)cpv, NO);
            id khv = Get(wm, "currentKmpHoverBridgeView");
            if ([khv isKindOfClass:UIView.class]) FQXSyncControlledViewHidden((UIView *)khv, NO);
            VoidMsg0(wm, "refreshIfNeeded");
            VoidMsg0(wm, "refreshHoverView");
        }
    }

    for (id pm in SnapshotTracked(sTrackedPreUnlockViewManagers)) {
        id bar = Get(pm, "preUnlockView") ?: Get(pm, "unlockView");
        if ([bar isKindOfClass:UIView.class]) {
            if (hideAudioGate) VoidMsg0(bar, "stopCountDown");
            FQXSyncControlledViewHidden((UIView *)bar, hideAudioGate);
        }
        VoidMsg0(pm, "updateAheadInspireUnlockViewHidden");
    }

    for (UIScene *scene in UIApplication.sharedApplication.connectedScenes) {
        if (![scene isKindOfClass:UIWindowScene.class]) continue;
        for (UIWindow *window in ((UIWindowScene *)scene).windows) {
            FQXWalkWindowViewsForPendantRefresh(window, 0, hideReaderAudioPendant, hideWelfarePendant, hideAudioGate);
        }
    }

    FQXDiagPopPluginViewReason();
    sRefreshing = NO;
}

static void InstallAudioPlayInterceptHook(const char *className) {
    SEL x = Sel("audioShouldInterceptWhenPlayCurrent:interceptSource:interceptInfo:");
    Class cls = FQXLookupMatchingClass(className, x, NO, "v40@0:8^B16^@24^@32");
    if (!cls) return;
    __block IMP old = NULL;
    const char *rule = "FanqieX.AudioAdDurationGate";
    IMP hook = imp_implementationWithBlock(^(id o, BOOL *shouldIntercept, void *interceptSource, void *interceptInfo) {
        CFTimeInterval t0 = CACurrentMediaTime();
        if (FQXAudioAdGateBlocked()) {
            if (shouldIntercept) *shouldIntercept = NO;
            FQXDiagRecordHook(className, "audioShouldInterceptWhenPlayCurrent:interceptSource:interceptInfo:",
                              rule, "gate_active", "blocked", (CACurrentMediaTime() - t0) * 1000.0);
            return;
        }
        ((void (*)(id, SEL, BOOL *, void *, void *))old)(o, x, shouldIntercept, interceptSource, interceptInfo);
        FQXDiagRecordHook(className, "audioShouldInterceptWhenPlayCurrent:interceptSource:interceptInfo:",
                          rule, "gate_off", "allowed", (CACurrentMediaTime() - t0) * 1000.0);
    });
    if (!FQXDiagInstallOwnedHook(cls, className, x, NO, "v40@0:8^B16^@24^@32", rule, hook, &old)) {
        imp_removeBlock(hook);
    }
}

static void InstallReaderAndListenPendantHooks(void) {
    const char *readerPendantRule = "FanqieX.ReaderAudioPendant";
    const char *welfarePendantRule = "FanqieX.ListenPendant.1";

    /* 1. Bottom-right reader "01:52:42 听书时长" hourglass pendant (SSBizAudioAdNewReaderPendant* & SSAudioTTSPreUnlockPendantInsertObj) */
    GateConstBool0("SSBizAudioAdABTestService", "ttsSyncPendantEnable", YES, NO, readerPendantRule, FQXReaderAudioPendantBlocked);
    GateConstBool0("SSBizAudioAdABTestService", "ttsSyncPendantForceShow", YES, NO, readerPendantRule, FQXReaderAudioPendantBlocked);
    GateConstBool0("SSBizAudioAdNewReaderPendantManager", "canShowReaderPendant", NO, NO, readerPendantRule, FQXReaderAudioPendantBlocked);
    GateConstBool0("SSBizAudioAdNewReaderPendantManager", "isPendantActive", NO, NO, readerPendantRule, FQXReaderAudioPendantBlocked);
    GateConstBool0("SSBizAudioAdNewReaderPendantManager", "canShowPreunlock", NO, NO, readerPendantRule, FQXReaderAudioPendantBlocked);
    GateConstBool0("SSBizAudioAdNewReaderPendantManager", "canShowDailyTip", NO, NO, readerPendantRule, FQXReaderAudioPendantBlocked);
    GateConstBool0("SSBizAudioAdNewReaderPendantManager", "handlePreunlockTipShow", NO, NO, readerPendantRule, FQXReaderAudioPendantBlocked);
    GateVoid0("SSBizAudioAdNewReaderPendantManager", "tryShowTips", NO, readerPendantRule, FQXReaderAudioPendantBlocked);

    {
        Class cls = objc_lookUpClass("SSBizAudioAdNewReaderPendantManager");
        SEL sSetRM = Sel("setReaderManager:");
        __block IMP oSetRM = NULL;
        IMP hSetRM = imp_implementationWithBlock(^(id o, id rm) {
            TrackInWeakTable(&sTrackedReaderPendantManagers, o);
            ((void (*)(id, SEL, id))oSetRM)(o, sSetRM, rm);
            if (FQXReaderAudioPendantBlocked()) {
                VoidMsg0(o, "hidePendantView");
                id v = Get(o, "view");
                if ([v isKindOfClass:UIView.class]) FQXSyncControlledViewHidden((UIView *)v, YES);
            }
        });
        if (!FQXInstallOwnedHook(cls, sSetRM, NO, "v24@0:8@16", hSetRM, &oSetRM)) imp_removeBlock(hSetRM);

        SEL sGet = Sel("getReaderPendant");
        __block IMP oGet = NULL;
        IMP hGet = imp_implementationWithBlock(^id(id o) {
            TrackInWeakTable(&sTrackedReaderPendantManagers, o);
            if (FQXReaderAudioPendantBlocked()) {
                id v = Get(o, "view");
                if ([v isKindOfClass:UIView.class]) FQXSyncControlledViewHidden((UIView *)v, YES);
                FQXDiagRecordHook("SSBizAudioAdNewReaderPendantManager", "getReaderPendant", readerPendantRule, "gate_active", "blocked", 0.0);
                return nil;
            }
            return ((id (*)(id, SEL))oGet)(o, sGet);
        });
        if (!FQXInstallOwnedHook(cls, sGet, NO, "@16@0:8", hGet, &oGet)) imp_removeBlock(hGet);

        SEL sShow = Sel("showPendantView");
        __block IMP oShow = NULL;
        IMP hShow = imp_implementationWithBlock(^(id o) {
            TrackInWeakTable(&sTrackedReaderPendantManagers, o);
            if (FQXReaderAudioPendantBlocked()) {
                VoidMsg0(o, "hidePendantView");
                id v = Get(o, "view");
                if ([v isKindOfClass:UIView.class]) FQXSyncControlledViewHidden((UIView *)v, YES);
                FQXDiagRecordHook("SSBizAudioAdNewReaderPendantManager", "showPendantView", readerPendantRule, "gate_active", "blocked", 0.0);
                return;
            }
            ((void (*)(id, SEL))oShow)(o, sShow);
        });
        if (!FQXInstallOwnedHook(cls, sShow, NO, "v16@0:8", hShow, &oShow)) imp_removeBlock(hShow);

        SEL sTip = Sel("showTipText:forceShow:");
        __block IMP oTip = NULL;
        IMP hTip = imp_implementationWithBlock(^(id o, id text, BOOL force) {
            TrackInWeakTable(&sTrackedReaderPendantManagers, o);
            if (FQXReaderAudioPendantBlocked()) return;
            ((void (*)(id, SEL, id, BOOL))oTip)(o, sTip, text, force);
        });
        if (!FQXInstallOwnedHook(cls, sTip, NO, "v28@0:8@16B24", hTip, &oTip)) imp_removeBlock(hTip);
    }

    InstallControlledViewVisibilityHooks("SSBizAudioAdNewReaderPendantView", readerPendantRule, FQXReaderAudioPendantBlocked);
    InstallControlledViewVisibilityHooks("SSBizAudioAdNewReaderPendantTipView", readerPendantRule, FQXReaderAudioPendantBlocked);

    GateConstBool0("SSAudioTTSPreUnlockPendantInsertObj", "shouldInsert", NO, NO, readerPendantRule, FQXReaderAudioPendantBlocked);
    GateConstBool0("SSAudioTTSPreUnlockPendantInsertObj", "shouldShow", NO, NO, readerPendantRule, FQXReaderAudioPendantBlocked);
    GateNil0("SSAudioTTSPreUnlockPendantInsertObj", "insertView", NO, readerPendantRule, FQXReaderAudioPendantBlocked);
    {
        Class cls = objc_lookUpClass("SSAudioTTSPreUnlockPendantInsertObj");
        SEL sInit = Sel("initWithReaderManager:");
        __block IMP oInit = NULL;
        IMP hInit = imp_implementationWithBlock(^id(id o, id rm) {
            id res = ((id (*)(id, SEL, id))oInit)(o, sInit, rm);
            TrackInWeakTable(&sTrackedReaderPendantInsertObjs, res);
            return res;
        });
        if (!FQXInstallOwnedHook(cls, sInit, NO, "@24@0:8@16", hInit, &oInit)) imp_removeBlock(hInit);

        SEL sShowBtn = Sel("showFloatingBtnFromPendant");
        __block IMP oShowBtn = NULL;
        IMP hShowBtn = imp_implementationWithBlock(^(id o) {
            TrackInWeakTable(&sTrackedReaderPendantInsertObjs, o);
            if (FQXReaderAudioPendantBlocked()) {
                VoidMsg0(o, "hideFloatingBtnFromPendant");
                return;
            }
            ((void (*)(id, SEL))oShowBtn)(o, sShowBtn);
        });
        if (!FQXInstallOwnedHook(cls, sShowBtn, NO, "v16@0:8", hShowBtn, &oShowBtn)) imp_removeBlock(hShowBtn);
    }

    /* 2. Welfare / Listen-and-Earn / KMP / Reader Floating Pendants (instance methods cm=NO!) */
    GateBool1Class("SSWelfareListenPendantManager", "canShowPendantInVC:", NO, welfarePendantRule, FQXWelfarePendantBlocked);
    GateVoid1Class("SSWelfareListenPendantManager", "ssBaseViewControllerViewDidAppear:", NO, welfarePendantRule, FQXWelfarePendantBlocked);
    GateVoid2Obj("SSWelfareListenPendantManager", "listenerDidAppear:audioModel:", NO, welfarePendantRule, FQXWelfarePendantBlocked);
    GateConstBool0("SSWelfareListenPendantManager", "shouldUseKmpListenPendant", NO, NO, welfarePendantRule, FQXWelfarePendantBlocked);
    GateConstBool0("SSWelfareListenPendantManager", "isCommonCouldShowBubble", NO, NO, welfarePendantRule, FQXWelfarePendantBlocked);
    GateVoid1Obj("SSWelfareListenPendantManager", "triggerKmpPendantIfNeededWithAttachView:", NO, welfarePendantRule, FQXWelfarePendantBlocked);
    GateVoid0("SSWelfareListenPendantManager", "addHoverView", NO, welfarePendantRule, FQXWelfarePendantBlocked);
    GateVoid0("SSWelfareListenPendantManager", "refreshHoverView", NO, welfarePendantRule, FQXWelfarePendantBlocked);
    GateVoid0("SSWelfareListenPendantManager", "tryShowAssetAwarenessBubble", NO, welfarePendantRule, FQXWelfarePendantBlocked);
    GateVoid0("SSWelfareListenPendantManager", "tryShowLimitTimeDoubleBubble", NO, welfarePendantRule, FQXWelfarePendantBlocked);
    GateVoid0("SSWelfareListenPendantManager", "tryShowTodayMaxRewardBubble", NO, welfarePendantRule, FQXWelfarePendantBlocked);
    GateVoid0("SSWelfareListenPendantManager", "tryShowRewardNoticeBubble", NO, welfarePendantRule, FQXWelfarePendantBlocked);
    GateVoid0("SSWelfareListenPendantManager", "tryShowDaily1MinTipsBubble", NO, welfarePendantRule, FQXWelfarePendantBlocked);
    {
        Class cls = objc_lookUpClass("SSWelfareListenPendantManager");
        SEL sTry = Sel("tryShowPendant:");
        __block IMP oTry = NULL;
        IMP hTry = imp_implementationWithBlock(^(id o, Class vcCls) {
            TrackInWeakTable(&sTrackedWelfarePendantManagers, o);
            if (FQXWelfarePendantBlocked()) {
                VoidMsg0(o, "dismissPendant");
                VoidMsg0(o, "removeHoverView");
                FQXDiagRecordHook("SSWelfareListenPendantManager", "tryShowPendant:", welfarePendantRule, "gate_active", "blocked", 0.0);
                return;
            }
            ((void (*)(id, SEL, Class))oTry)(o, sTry, vcCls);
        });
        if (!FQXDiagInstallOwnedHook(cls, "SSWelfareListenPendantManager", sTry, NO, "v24@0:8#16", welfarePendantRule, hTry, &oTry)) {
            imp_removeBlock(hTry);
        }
    }

    GateVoid0("SSWelfareGlobalPendantManager", "showAfterHidingTemp", NO, welfarePendantRule, FQXWelfarePendantBlocked);
    GateVoid0("SSWelfareGlobalPendantManager", "addHoverView", NO, welfarePendantRule, FQXWelfarePendantBlocked);
    GateVoid0("SSWelfareGlobalPendantManager", "refreshHoverView", NO, welfarePendantRule, FQXWelfarePendantBlocked);
    GateVoid1Obj("SSWelfareGlobalPendantManager", "triggerKmpPendantIfNeededWithAttachView:", NO, welfarePendantRule, FQXWelfarePendantBlocked);
    GateConstBool0("SSWelfareGlobalPendantManager", "isCommonCouldShowBubble", NO, NO, welfarePendantRule, FQXWelfarePendantBlocked);
    GateVoid0("SSWelfareGlobalPendantManager", "tryShowDaily1MinBubble", NO, welfarePendantRule, FQXWelfarePendantBlocked);
    GateVoid0("SSWelfareGlobalPendantManager", "tryShowAssetAwarenessBubble", NO, welfarePendantRule, FQXWelfarePendantBlocked);
    {
        Class cls = objc_lookUpClass("SSWelfareGlobalPendantManager");
        SEL sTry = Sel("tryShowPendant");
        __block IMP oTry = NULL;
        IMP hTry = imp_implementationWithBlock(^(id o) {
            TrackInWeakTable(&sTrackedWelfarePendantManagers, o);
            if (FQXWelfarePendantBlocked()) {
                VoidMsg0(o, "tryDismissPendant");
                VoidMsg0(o, "removeHoverView");
                FQXDiagRecordHook("SSWelfareGlobalPendantManager", "tryShowPendant", welfarePendantRule, "gate_active", "blocked", 0.0);
                return;
            }
            ((void (*)(id, SEL))oTry)(o, sTry);
        });
        if (!FQXDiagInstallOwnedHook(cls, "SSWelfareGlobalPendantManager", sTry, NO, "v16@0:8", welfarePendantRule, hTry, &oTry)) {
            imp_removeBlock(hTry);
        }
    }

    GateVoid1Obj("SSWelfareReadingToolPendantManager", "injectCyberPendant:", NO, welfarePendantRule, FQXWelfarePendantBlocked);
    GateVoid2Obj("SSWelfareReadingToolPendantManager", "willAttached:pendant:", NO, welfarePendantRule, FQXWelfarePendantBlocked);

    GateConstBool0("SSReaderFloatingBtnBookActivityPendantInsertObj", "shouldInsert", NO, NO, welfarePendantRule, FQXWelfarePendantBlocked);
    GateConstBool0("SSReaderFloatingBtnBookActivityPendantInsertObj", "shouldShow", NO, NO, welfarePendantRule, FQXWelfarePendantBlocked);
    GateNil0("SSReaderFloatingBtnBookActivityPendantInsertObj", "insertView", NO, welfarePendantRule, FQXWelfarePendantBlocked);

    GateConstBool0("SSReaderAIGCTaskPendantInsertObj", "shouldInsert", NO, NO, welfarePendantRule, FQXWelfarePendantBlocked);
    GateConstBool0("SSReaderAIGCTaskPendantInsertObj", "shouldShow", NO, NO, welfarePendantRule, FQXWelfarePendantBlocked);
    GateNil0("SSReaderAIGCTaskPendantInsertObj", "insertView", NO, welfarePendantRule, FQXWelfarePendantBlocked);

    GateConstBool0("SSStoryPostNavigationBarConfig", "showGoldCoinProgress", NO, NO, welfarePendantRule, FQXWelfarePendantBlocked);
}

static void InstallAudioAdAndDurationGateHooks(void) {
    const char *rule = "FanqieX.AudioAdDurationGate";

    /* 1. Out-pointer playback interception gates */
    InstallAudioPlayInterceptHook("SSBizAudioAdInspireManager");
    InstallAudioPlayInterceptHook("SSBizAudioAdNewReaderPendantManager");
    InstallAudioPlayInterceptHook("SSAdAudioManager");
    InstallAudioPlayInterceptHook("SSAdAudioPatchClient");
    InstallAudioPlayInterceptHook("SSAdBackgroundAudioClient");

    {
        Class cls = objc_lookUpClass("SSAdAudioManager");
        SEL sPlaying = Sel("adPlayingAuidoShouldIntercept:");
        __block IMP oPlaying = NULL;
        IMP hPlaying = imp_implementationWithBlock(^(id o, BOOL *shouldIntercept) {
            if (FQXAudioAdGateBlocked()) {
                if (shouldIntercept) *shouldIntercept = NO;
                FQXDiagRecordHook("SSAdAudioManager", "adPlayingAuidoShouldIntercept:", rule, "gate_active", "blocked", 0.0);
                return;
            }
            ((void (*)(id, SEL, BOOL *))oPlaying)(o, sPlaying, shouldIntercept);
        });
        if (!FQXDiagInstallOwnedHook(cls, "SSAdAudioManager", sPlaying, NO, "v24@0:8^B16", rule, hPlaying, &oPlaying)) {
            imp_removeBlock(hPlaying);
        }
    }
    {
        Class cls = objc_lookUpClass("SSBizAudioAdFunnelPopupManager");
        SEL sInd = Sel("audioIndicatorWillShowWithPlayPosition:showContext:shouldIntercept:");
        __block IMP oInd = NULL;
        IMP hInd = imp_implementationWithBlock(^(id o, id pos, id ctx, BOOL *shouldIntercept) {
            if (FQXAudioAdGateBlocked()) {
                if (shouldIntercept) *shouldIntercept = NO;
                FQXDiagRecordHook("SSBizAudioAdFunnelPopupManager", "audioIndicatorWillShowWithPlayPosition:showContext:shouldIntercept:", rule, "gate_active", "blocked", 0.0);
                return;
            }
            ((void (*)(id, SEL, id, id, BOOL *))oInd)(o, sInd, pos, ctx, shouldIntercept);
        });
        if (!FQXDiagInstallOwnedHook(cls, "SSBizAudioAdFunnelPopupManager", sInd, NO, "v40@0:8@16@24^B32", rule, hInd, &oInd)) {
            imp_removeBlock(hInd);
        }
    }

    /* 2. Master Inspire / PreUnlock / AB / Ad-Free Privilege Gates */
    GateBool1UInt("SSBizAudioAdABTestService", "isAudioInspireAdOpenWithType:", YES, rule, FQXAudioAdGateBlocked);
    GateConstBool0("SSBizAudioAdABTestService", "enableBelowReadFlowAd", YES, NO, rule, FQXAudioAdGateBlocked);
    GateConstBool0("SSBizAudioAdABTestService", "ttsTipExitEnable", YES, NO, rule, FQXAudioAdGateBlocked);
    GateConstBool0("SSBizAudioAdABTestService", "dialogExitEnable", YES, NO, rule, FQXAudioAdGateBlocked);
    GateConstBool0("SSBizAudioAdABTestHelper", "canAddTimeAd", YES, NO, rule, FQXAudioAdGateBlocked);
    GateConstBool0("SSBizAudioAdABTestHelper", "ttsAutoAdEnablePopScene", YES, NO, rule, FQXAudioAdGateBlocked);
    GateConstBool0("SSBizAudioAdABTestHelper", "enablePlayletRetentionDialog", YES, NO, rule, FQXAudioAdGateBlocked);
    GateConstBool0("SSBizAudioAdABTestHelper", "enablePlayletRewardPanel", YES, NO, rule, FQXAudioAdGateBlocked);

    GateConstBool0("SSAdAudioInspireStrategyDataManager", "isOpen", NO, NO, rule, FQXAudioAdGateBlocked);
    GateConstBool0("SSAdAudioInspireStrategyDataManager", "entryDirectAd", NO, NO, rule, FQXAudioAdGateBlocked);

    GateConstBool0("SSAdSettingsAudioInspireConfig", "enable", NO, NO, rule, FQXAudioAdGateBlocked);
    GateConstBool0("SSAdSettingsAudioInspireConfig", "audio_pre_lock_show_directly", NO, NO, rule, FQXAudioAdGateBlocked);
    GateConstBool0("SSAdSettingsAudioInspireConfig", "old_profit_time_out_show_dialog_immediately", NO, NO, rule, FQXAudioAdGateBlocked);

    GateConstBool0("SSAdSettingsAudioPatchMetaData", "enable", NO, NO, rule, FQXAudioAdGateBlocked);
    GateConstBool0("SSAdSettingsAudioPatchMetaData", "shouldPauseAudioPlayer", NO, NO, rule, FQXAudioAdGateBlocked);

    GateConstBool0("SSAdSettingsBackgroundAudioConfig", "enable", NO, NO, rule, FQXAudioAdGateBlocked);
    GateConstBool0("SSAdSettingsBackgroundAudioConfig", "shouldPauseAudioPlayer", NO, NO, rule, FQXAudioAdGateBlocked);

    GateConstBool0("SSAdAudioSettingManager", "hasFreeAdProfit", NO, YES, rule, FQXAudioAdGateBlocked);
    GateBool1UInt("SSAdAudioSettingManager", "audioAdSceneEnableWithType:", NO, rule, FQXAudioAdGateBlocked);
    {
        Class cls = objc_lookUpClass("SSAdAudioSettingManager");
        SEL sOpen = Sel("audioAdOpenWithType:sceneType:hotStory:");
        __block IMP oOpen = NULL;
        IMP hOpen = imp_implementationWithBlock(^BOOL(id o, NSUInteger tp, NSUInteger sc, BOOL hs) {
            return FQXAudioAdGateBlocked() ? NO : ((BOOL (*)(id, SEL, NSUInteger, NSUInteger, BOOL))oOpen)(o, sOpen, tp, sc, hs);
        });
        if (!FQXInstallOwnedHook(cls, sOpen, NO, "B36@0:8Q16Q24B32", hOpen, &oOpen)) imp_removeBlock(hOpen);

        SEL sAvail = Sel("availableWithType:adSource:hotStory:");
        __block IMP oAvail = NULL;
        IMP hAvail = imp_implementationWithBlock(^BOOL(id o, NSUInteger tp, id src, BOOL hs) {
            return FQXAudioAdGateBlocked() ? NO : ((BOOL (*)(id, SEL, NSUInteger, id, BOOL))oAvail)(o, sAvail, tp, src, hs);
        });
        if (!FQXInstallOwnedHook(cls, sAvail, NO, "B36@0:8Q16@24B32", hAvail, &oAvail)) imp_removeBlock(hAvail);

        SEL sShow = Sel("shouldShowWithType:bookId:index:hotStory:");
        __block IMP oShow = NULL;
        IMP hShow = imp_implementationWithBlock(^BOOL(id o, NSUInteger tp, id bid, NSUInteger idx, BOOL hs) {
            return FQXAudioAdGateBlocked() ? NO : ((BOOL (*)(id, SEL, NSUInteger, id, NSUInteger, BOOL))oShow)(o, sShow, tp, bid, idx, hs);
        });
        if (!FQXInstallOwnedHook(cls, sShow, NO, "B44@0:8Q16@24Q32B40", hShow, &oShow)) imp_removeBlock(hShow);
    }

    GateConstBool0("SSSpeechToneAudioAdFreeManager", "shouldSkipShowAudioPatchAd", NO, YES, rule, FQXAudioAdGateBlocked);
    GateConstBool0("SSSpeechToneAudioAdFreeManager", "shouldHideAheadUnlock", NO, YES, rule, FQXAudioAdGateBlocked);
    GateConstBool0("SSSpeechToneAudioAdFreeManager", "shouldSkipReportAudioConsumeTime", NO, YES, rule, FQXAudioAdGateBlocked);

    /* 3. Countdown Expiry, PreUnlock Bar, Funnel/Default Popups & AutoPlay Ad */
    GateVoid1Obj("SSBizAudioAdInspireManager", "countDownHadFinishedInCountDownView:", NO, rule, FQXAudioAdGateBlocked);
    GateVoid1Obj("SSBizAudioAdInspireManager", "setNeedAutoShowPreUnlockWithScene:", NO, rule, FQXAudioAdGateBlocked);
    GateVoid0("SSBizAudioAdInspireManager", "tryAutoShowSignInAlert", NO, rule, FQXAudioAdGateBlocked);

    GateVoid0("SSBizAudioAdStartPlayPreUnlockManager", "showStartPlayInterceptInspire", YES, rule, FQXAudioAdGateBlocked);
    {
        Class cls = objc_lookUpClass("SSBizAudioAdStartPlayPreUnlockManager");
        SEL sStart = Sel("showStartPlayPreUnlockWithCanShowView:canPlayTip:");
        __block IMP oStart = NULL;
        IMP hStart = imp_implementationWithBlock(^(id o, BOOL canShow, BOOL canTip) {
            if (FQXAudioAdGateBlocked()) {
                FQXDiagRecordHook("SSBizAudioAdStartPlayPreUnlockManager", "showStartPlayPreUnlockWithCanShowView:canPlayTip:", rule, "gate_active", "blocked", 0.0);
                return;
            }
            ((void (*)(id, SEL, BOOL, BOOL))oStart)(o, sStart, canShow, canTip);
        });
        if (!FQXDiagInstallOwnedHook(cls, "SSBizAudioAdStartPlayPreUnlockManager", sStart, YES, "v24@0:8B16B20", rule, hStart, &oStart)) {
            imp_removeBlock(hStart);
        }
    }

    GateVoid1Obj("SSBizAudioAdInspirePopupService", "showInspirePopupWithPopScene:", NO, rule, FQXAudioAdGateBlocked);
    GateVoid1ObjBlock("SSBizAudioAdInspirePopupService", "showInspirePopupWithPopScene:dismissBlock:", NO, rule, FQXAudioAdGateBlocked);
    GateVoid1Obj("SSBizAudioAdInspirePopupService", "showInspirePopupWithProcessParam:", NO, rule, FQXAudioAdGateBlocked);
    GateVoid1Obj("SSBizAudioAdFunnelPopupManager", "showInspireFunnelPopupViewWithProcessParam:", NO, rule, FQXAudioAdGateBlocked);
    GateVoid1Obj("SSBizAudioAdDefaultPopupManager", "showInspireFunnelPopupViewWithPopScene:", NO, rule, FQXAudioAdGateBlocked);

    GateVoid1Obj("SSAdAudioInspireAutoPlayManager", "startAutoPlay:", NO, rule, FQXAudioAdGateBlocked);
    {
        Class cls = objc_lookUpClass("SSAdAudioInspireAutoPlayManager");
        for (NSString *selStr in @[@"checkCanAutoPlayAdWithPopScene:data:consumeLeftTime:isFromAudioStart:",
                                   @"checkAndStartAutoPlayWithPopScene:data:consumeLeftTime:isFromAudioStart:"]) {
            SEL s = NSSelectorFromString(selStr);
            __block IMP orig = NULL;
            IMP h = imp_implementationWithBlock(^BOOL(id o, id sc, id dt, NSInteger left, BOOL fromStart) {
                return FQXAudioAdGateBlocked() ? NO : ((BOOL (*)(id, SEL, id, id, NSInteger, BOOL))orig)(o, s, sc, dt, left, fromStart);
            });
            if (!FQXInstallOwnedHook(cls, s, NO, "B44@0:8@16@24q32B40", h, &orig)) imp_removeBlock(h);
        }
        SEL s3 = Sel("checkAndStartAutoPlayWithPopScene:data:consumeLeftTime:");
        __block IMP o3 = NULL;
        IMP h3 = imp_implementationWithBlock(^BOOL(id o, id sc, id dt, NSInteger left) {
            return FQXAudioAdGateBlocked() ? NO : ((BOOL (*)(id, SEL, id, id, NSInteger))o3)(o, s3, sc, dt, left);
        });
        if (!FQXInstallOwnedHook(cls, s3, NO, "B40@0:8@16@24q32", h3, &o3)) imp_removeBlock(h3);
    }

    GateConstBool0("SSBizAudioAdPreUnlockViewManager", "canShowAheadUnlock", NO, NO, rule, FQXAudioAdGateBlocked);
    GateConstBool0("SSBizAudioAdPreUnlockViewManager", "forceShowPannel", NO, NO, rule, FQXAudioAdGateBlocked);
    GateConstBool0("SSBizAudioAdPreUnlockViewManager", "isShouldShowKeepUnlock", NO, NO, rule, FQXAudioAdGateBlocked);
    GateVoid0("SSBizAudioAdPreUnlockViewManager", "showAheadInspireUnlockViewAppearAnimate", NO, rule, FQXAudioAdGateBlocked);
    GateVoid1Obj("SSBizAudioAdPreUnlockViewManager", "unlockBarViewConsumeProfitHasFinishedCount:", NO, rule, FQXAudioAdGateBlocked);
    {
        Class cls = objc_lookUpClass("SSBizAudioAdPreUnlockViewManager");
        SEL sInit = Sel("initWithPlayViewController:");
        __block IMP oInit = NULL;
        IMP hInit = imp_implementationWithBlock(^id(id o, id vc) {
            id res = ((id (*)(id, SEL, id))oInit)(o, sInit, vc);
            TrackInWeakTable(&sTrackedPreUnlockViewManagers, res);
            return res;
        });
        if (!FQXInstallOwnedHook(cls, sInit, NO, "@24@0:8@16", hInit, &oInit)) imp_removeBlock(hInit);
    }
    InstallControlledViewVisibilityHooks("SSBizAudioAdPreUnlockBarView", rule, FQXAudioAdGateBlocked);

    GateConstBool0("SSBizAudioAdPlayIndicatorUnlockTipService", "canShowTip", NO, NO, rule, FQXAudioAdGateBlocked);
    GateVoid1Obj("SSBizAudioAdPlayIndicatorUnlockTipService", "tryShowTipWithPlayIndicator:", NO, rule, FQXAudioAdGateBlocked);

    GateBool1Obj("SSBizAudioAdMyUserAudioPreUnlockService", "canShowPreUnlockTextWithBookId:", NO, rule, FQXAudioAdGateBlocked);
    GateVoid1ObjBlock("SSBizAudioAdMyUserAudioPreUnlockService", "tryShowPreUnlockTipWithAnchorView:tappedHandler:", NO, rule, FQXAudioAdGateBlocked);

    GateConstBool0("SSBizAudioAdReaderPreUnlockController", "needShowAheadUnlockEntrance", NO, NO, rule, FQXAudioAdGateBlocked);
    GateConstBool0("SSBizAudioAdReaderTTSGiftController", "needShowAudioInspire", NO, NO, rule, FQXAudioAdGateBlocked);
    GateConstBool0("SSBizAudioAdReaderTTSGiftController", "p_needShowAudioInspire", NO, NO, rule, FQXAudioAdGateBlocked);
    GateVoid1ObjBlock("SSBizAudioAdReaderTTSGiftController", "showReaderAudioInspireWithPosition:success:", NO, rule, FQXAudioAdGateBlocked);

    /* 4. Audio Patch / Background / Feed Clients & Adapter */
    GateConstBool0("SSAdCommonConfigAdapter", "audioPatchAdSwitch", NO, NO, rule, FQXAudioAdGateBlocked);
    GateConstBool0("SSAdCommonConfigAdapter", "audioInfoFlowAdSwitch", NO, NO, rule, FQXAudioAdGateBlocked);

    GateVoid2Obj("SSAdAudioManager", "initClientsIfNeededWithTypes:bookId:", NO, rule, FQXAudioAdGateBlocked);
    {
        Class cls = objc_lookUpClass("SSAdAudioManager");
        SEL sHas = Sel("hasAdType:bookId:");
        __block IMP oHas = NULL;
        IMP hHas = imp_implementationWithBlock(^BOOL(id o, NSUInteger tp, id bid) {
            return FQXAudioAdGateBlocked() ? NO : ((BOOL (*)(id, SEL, NSUInteger, id))oHas)(o, sHas, tp, bid);
        });
        if (!FQXInstallOwnedHook(cls, sHas, NO, "B32@0:8Q16@24", hHas, &oHas)) imp_removeBlock(hHas);

        SEL sCreate = Sel("createClientWithBookId:type:");
        __block IMP oCreate = NULL;
        IMP hCreate = imp_implementationWithBlock(^id(id o, id bid, NSUInteger tp) {
            return FQXAudioAdGateBlocked() ? nil : ((id (*)(id, SEL, id, NSUInteger))oCreate)(o, sCreate, bid, tp);
        });
        if (!FQXInstallOwnedHook(cls, sCreate, NO, "@32@0:8@16Q24", hCreate, &oCreate)) imp_removeBlock(hCreate);
    }

    GateConstBool0("SSAdAudioPatchClient", "hasAd", NO, NO, rule, FQXAudioAdGateBlocked);
    GateConstBool0("SSAdAudioPatchClient", "shouldInterceptAudio", NO, NO, rule, FQXAudioAdGateBlocked);
    GateConstBool0("SSAdAudioPatchClient", "checkShouldReload", NO, NO, rule, FQXAudioAdGateBlocked);
    GateVoid0("SSAdAudioPatchClient", "initLoader", NO, rule, FQXAudioAdGateBlocked);
    GateVoid0("SSAdAudioPatchClient", "initMetaverseLoader", NO, rule, FQXAudioAdGateBlocked);
    GateVoid0("SSAdAudioPatchClient", "metaverReload", NO, rule, FQXAudioAdGateBlocked);
    GateVoid0("SSAdAudioPatchClient", "reload", NO, rule, FQXAudioAdGateBlocked);
    GateVoid0("SSAdAudioPatchClient", "addAdIfNeeded", NO, rule, FQXAudioAdGateBlocked);
    GateVoid0("SSAdAudioPatchClient", "addPatchAd", NO, rule, FQXAudioAdGateBlocked);
    GateVoid1Obj("SSAdAudioPatchClient", "showMetaverseDataIfNeed:", NO, rule, FQXAudioAdGateBlocked);
    GateVoid1Obj("SSAdAudioPatchClient", "showMannorDataIfNeed:", NO, rule, FQXAudioAdGateBlocked);

    GateConstBool0("SSAdAudioPatchAdapterClient", "hasAd", NO, NO, rule, FQXAudioAdGateBlocked);
    GateConstBool0("SSAdAudioPatchAdapterClient", "checkShouldReload", NO, NO, rule, FQXAudioAdGateBlocked);
    GateConstBool0("SSAdAudioPatchAdapterClient", "shouldDropCurrentPatchAd", NO, YES, rule, FQXAudioAdGateBlocked);
    GateBool1Int("SSAdAudioPatchAdapterClient", "isAvailableInBasicRulesWithScene:", NO, rule, FQXAudioAdGateBlocked);
    GateVoid0("SSAdAudioPatchAdapterClient", "reload", NO, rule, FQXAudioAdGateBlocked);
    {
        Class cls = objc_lookUpClass("SSAdAudioPatchAdapterClient");
        SEL sBiz = Sel("isAvailableInBizRulesWithScene:patchScene:");
        __block IMP oBiz = NULL;
        IMP hBiz = imp_implementationWithBlock(^BOOL(id o, NSInteger sc, NSInteger psc) {
            return FQXAudioAdGateBlocked() ? NO : ((BOOL (*)(id, SEL, NSInteger, NSInteger))oBiz)(o, sBiz, sc, psc);
        });
        if (!FQXInstallOwnedHook(cls, sBiz, NO, "B32@0:8q16q24", hBiz, &oBiz)) imp_removeBlock(hBiz);
    }

    GateConstBool0("SSAdBackgroundAudioClient", "hasAd", NO, NO, rule, FQXAudioAdGateBlocked);
    GateConstBool0("SSAdBackgroundAudioClient", "checkShouldReload", NO, NO, rule, FQXAudioAdGateBlocked);
    GateVoid0("SSAdBackgroundAudioClient", "initLoader", NO, rule, FQXAudioAdGateBlocked);
    GateVoid0("SSAdBackgroundAudioClient", "reload", NO, rule, FQXAudioAdGateBlocked);
    GateVoid0("SSAdBackgroundAudioClient", "addPatchAd", NO, rule, FQXAudioAdGateBlocked);
    GateVoid0("SSAdBackgroundAudioClient", "preloadAdDataIfNeeded", NO, rule, FQXAudioAdGateBlocked);

    GateConstBool0("SSAdFeedAudioClient", "hasAd", NO, NO, rule, FQXAudioAdGateBlocked);
    GateConstBool0("SSAdFeedAudioClient", "checkShouldReload", NO, NO, rule, FQXAudioAdGateBlocked);
    GateVoid0("SSAdFeedAudioClient", "initLoader", NO, rule, FQXAudioAdGateBlocked);
    GateVoid0("SSAdFeedAudioClient", "initMetaverseLoader", NO, rule, FQXAudioAdGateBlocked);
    GateVoid0("SSAdFeedAudioClient", "metaverReload", NO, rule, FQXAudioAdGateBlocked);
    GateVoid0("SSAdFeedAudioClient", "reload", NO, rule, FQXAudioAdGateBlocked);
    GateVoid0("SSAdFeedAudioClient", "addFeedAudioAd", NO, rule, FQXAudioAdGateBlocked);
    GateVoid1Obj("SSAdFeedAudioClient", "showMetaverseDataIfNeed:", NO, rule, FQXAudioAdGateBlocked);
    GateVoid1Obj("SSAdFeedAudioClient", "showMannorDataIfNeed:", NO, rule, FQXAudioAdGateBlocked);
    GateVoid1Obj("SSAdFeedAudioATModel", "setMaterielData:", NO, rule, FQXAudioAdGateBlocked);
    GateVoid1Obj("SSAdFeedAudioATModel", "updateWithMaterielData:", NO, rule, FQXAudioAdGateBlocked);
}

static BOOL GateNil1Obj(const char *c, const char *s, BOOL cm, const char *rule, FQXGateFn gate) {
    SEL x = Sel(s);
    Class cls = FQXLookupMatchingClass(c, x, cm, "@24@0:8@16");
    if (!cls) return NO;
    __block IMP old = NULL;
    IMP hook = imp_implementationWithBlock(^id(id o, id a) {
        CFTimeInterval t0 = CACurrentMediaTime();
        if (gate()) {
            FQXDiagRecordHook(c, s, rule, "gate_active", "blocked", (CACurrentMediaTime() - t0) * 1000.0);
            return nil;
        }
        id r = ((id (*)(id, SEL, id))old)(o, x, a);
        FQXDiagRecordHook(c, s, rule, "gate_off", "allowed", (CACurrentMediaTime() - t0) * 1000.0);
        return r;
    });
    if (!FQXDiagInstallOwnedHook(cls, c, x, cm, "@24@0:8@16", rule, hook, &old)) {
        imp_removeBlock(hook);
        return NO;
    }
    return YES;
}

static void Install745ShortVideoAndPopupAdGates(void) {
    const char *feedRule = "FanqieAdBlock.ShortVideoFeedAd";
    const char *patchRule = "FanqieAdBlock.ShortVideoPatchAd";
    const char *popupRule = "FanqieAdBlock.BookstoreAndPopupAd";

    /* 1. 7.4.3/7.4.5 Short-Video Feed E-commerce / Live / Mini-Game / Survey Insertions */
    GateConstBool0("SSBizVideoAdABTestHelper", "enableEcomForceCard", YES, NO, feedRule, FQXShortVideoFeedAdBlocked);
    GateNil1Obj("SSShortVideoLiveService", "createFeedLiveInsertModelWithRoomModel:", NO, feedRule, FQXShortVideoFeedAdBlocked);
    GateNil1Obj("SSShortVideoRecommendOutterListDataSource", "liveFeedDataModelWithCellViewData:", NO, feedRule, FQXShortVideoFeedAdBlocked);
    GateConstBool0("SSBizVideoABTestHelper", "enableSeriesEndDirectGame", YES, NO, feedRule, FQXShortVideoFeedAdBlocked);
    GateBool1Int("BDADShortVideoCommonAdManager", "checkHomePageAdBasicReqRulesWithEpisodeIndex:", NO, feedRule, FQXShortVideoFeedAdBlocked);
    {
        Class cls = objc_lookUpClass("SSVideoMiniGameService");
        SEL sPage = Sel("createFeedPageDataModelWithCellViewData:listVCContext:");
        __block IMP oPage = NULL;
        IMP hPage = imp_implementationWithBlock(^id(id o, id data, id ctx) {
            if (FQXShortVideoFeedAdBlocked()) {
                FQXDiagRecordHook("SSVideoMiniGameService", "createFeedPageDataModelWithCellViewData:listVCContext:", feedRule, "gate_active", "blocked", 0.0);
                return nil;
            }
            return ((id (*)(id, SEL, id, id))oPage)(o, sPage, data, ctx);
        });
        if (!FQXDiagInstallOwnedHook(cls, "SSVideoMiniGameService", sPage, NO, "@32@0:8@16@24", feedRule, hPage, &oPage)) {
            imp_removeBlock(hPage);
        }

        SEL sDirect = Sel("createDirectGameContentModelWithCellViewData:source:host:");
        __block IMP oDirect = NULL;
        IMP hDirect = imp_implementationWithBlock(^id(id o, id data, NSInteger source, id host) {
            if (FQXShortVideoFeedAdBlocked()) {
                FQXDiagRecordHook("SSVideoMiniGameService", "createDirectGameContentModelWithCellViewData:source:host:", feedRule, "gate_active", "blocked", 0.0);
                return nil;
            }
            return ((id (*)(id, SEL, id, NSInteger, id))oDirect)(o, sDirect, data, source, host);
        });
        if (!FQXDiagInstallOwnedHook(cls, "SSVideoMiniGameService", sDirect, NO, "@40@0:8@16q24@32", feedRule, hDirect, &oDirect)) {
            imp_removeBlock(hDirect);
        }
    }
    {
        Class surveyCls = objc_lookUpClass("SSShortVideoSatisfactionSurveyManager");
        SEL sShow = Sel("showSurveyWithStyle:videoId:");
        __block IMP oShow = NULL;
        IMP hShow = imp_implementationWithBlock(^(id o, NSInteger style, id vid) {
            if (FQXShortVideoFeedAdBlocked()) return;
            ((void (*)(id, SEL, NSInteger, id))oShow)(o, sShow, style, vid);
        });
        if (!FQXInstallOwnedHook(surveyCls, sShow, NO, "v32@0:8q16@24", hShow, &oShow)) imp_removeBlock(hShow);

        const char *surveySels[] = {
            "tryShowSingleVideoSurveyIfNeededWithVideoId:",
            "tryShowInnerFlowQuickSlideSurveyIfNeededWithVideoId:",
            "tryShowInnerFlowDetailReturnSurveyIfNeededWithVideoId:",
            "tryShowPeriodSkipSurveyIfNeededWithVideoId:",
            "tryShowContinueSkipSurveyIfNeededWithVideoId:",
            "tryRestoreReadingItemSurveyIfNeededWithVideoId:"
        };
        for (size_t i = 0; i < sizeof(surveySels) / sizeof(surveySels[0]); ++i) {
            GateBool1Obj("SSShortVideoSatisfactionSurveyManager", surveySels[i], NO, feedRule, FQXShortVideoFeedAdBlocked);
        }
    }

    /* 2. 7.4.3/7.4.5 Short-Video Back-Patch / Plot-Touch / Sidebar-Patch Ad Gates */
    GateBool1Obj("BDADBackPatchAdService", "shouldShowAdWithContext:", NO, patchRule, FQXShortVideoPatchAdBlocked);
    GateBool1Obj("BDADPlotTouchAdService", "canShowPlotAdWithContext:", NO, patchRule, FQXShortVideoPatchAdBlocked);
    GateBool1Obj("BDADShortVideoSideBarPatchSwitchComponent", "isAvailableWithCtx:", NO, patchRule, FQXShortVideoPatchAdBlocked);
    {
        Class backCls = objc_lookUpClass("BDADBackPatchAdService");
        SEL sReq = Sel("shouldRequestAdWithPlaybackTime:duration:context:");
        __block IMP oReq = NULL;
        IMP hReq = imp_implementationWithBlock(^BOOL(id o, double t, double dur, id ctx) {
            if (FQXShortVideoPatchAdBlocked()) {
                FQXDiagRecordHook("BDADBackPatchAdService", "shouldRequestAdWithPlaybackTime:duration:context:", patchRule, "gate_active", "blocked", 0.0);
                return NO;
            }
            return ((BOOL (*)(id, SEL, double, double, id))oReq)(o, sReq, t, dur, ctx);
        });
        if (!FQXDiagInstallOwnedHook(backCls, "BDADBackPatchAdService", sReq, NO, "B40@0:8d16d24@32", patchRule, hReq, &oReq)) {
            imp_removeBlock(hReq);
        }

        Class plotCls = objc_lookUpClass("BDADPlotTouchAdService");
        SEL sPlot = Sel("canRequestAdWithPlaybackTime:context:");
        __block IMP oPlot = NULL;
        IMP hPlot = imp_implementationWithBlock(^BOOL(id o, double t, id ctx) {
            if (FQXShortVideoPatchAdBlocked()) {
                FQXDiagRecordHook("BDADPlotTouchAdService", "canRequestAdWithPlaybackTime:context:", patchRule, "gate_active", "blocked", 0.0);
                return NO;
            }
            return ((BOOL (*)(id, SEL, double, id))oPlot)(o, sPlot, t, ctx);
        });
        if (!FQXDiagInstallOwnedHook(plotCls, "BDADPlotTouchAdService", sPlot, NO, "B32@0:8d16@24", patchRule, hPlot, &oPlot)) {
            imp_removeBlock(hPlot);
        }
    }

    /* 3. 7.4.3/7.4.5 Live Benefit & E-commerce Coupon Popups */
    GateConstBool0("IESLiveUGBenefitCouponFragment", "shouldShowBalanceCouponPopup", NO, NO, popupRule, FQXBookstoreAndPopupAdBlocked);
    GateConstBool0("IESLiveUGBenefitCouponFragment", "shouldShowExpansionCouponPopup", NO, NO, popupRule, FQXBookstoreAndPopupAdBlocked);
    GateBool1Obj("SSCouponPopupFrequencyHelper", "canShowPopup:", YES, popupRule, FQXBookstoreAndPopupAdBlocked);
}

static BOOL FQXRankTemplateURLIsUsable(NSString *value) {
    NSURLComponents *url = [NSURLComponents componentsWithString:value ?: @""];
    return [url.scheme.lowercaseString isEqualToString:@"https"] && url.host.length > 0 &&
        [url.path.pathExtension.lowercaseString isEqualToString:@"js"];
}

static NSString *FQXBookstoreRankRoute(NSString *route) {
    if (![route isKindOfClass:NSString.class]) return route;
    NSURLComponents *url = [NSURLComponents componentsWithString:route];
    if (![url.scheme.lowercaseString isEqualToString:@"sslocal"] ||
        ![url.host.lowercaseString isEqualToString:@"lynxview"]) return route;

    // The native presenter rewrites both aliases after reading the saved rank
    // category. Preserve valid URLs and copy the encoded template for a missing alias.
    NSArray<NSURLQueryItem *> *items = url.queryItems;
    NSArray<NSURLQueryItem *> *encoded = url.percentEncodedQueryItems;
    NSUInteger urlIndex = NSNotFound, surlIndex = NSNotFound;
    for (NSUInteger i = 0; i < items.count; i++) {
        NSURLQueryItem *item = items[i];
        if (!FQXRankTemplateURLIsUsable(item.value)) continue;
        if ([item.name isEqualToString:@"url"] && urlIndex == NSNotFound) urlIndex = i;
        if ([item.name isEqualToString:@"surl"] && surlIndex == NSNotFound) surlIndex = i;
    }
    if (urlIndex == NSNotFound && surlIndex == NSNotFound) return route;

    NSMutableArray<NSURLQueryItem *> *updated = [encoded mutableCopy];
    for (NSString *name in @[@"url", @"surl"]) {
        NSUInteger own = [name isEqualToString:@"url"] ? urlIndex : surlIndex;
        NSUInteger source = own != NSNotFound ? own : (urlIndex != NSNotFound ? urlIndex : surlIndex);
        NSURLQueryItem *replacement = [NSURLQueryItem queryItemWithName:name value:encoded[source].value];
        BOOL found = NO;
        for (NSUInteger i = 0; i < items.count; i++) {
            if (![items[i].name isEqualToString:name]) continue;
            found = YES;
            if (!FQXRankTemplateURLIsUsable(items[i].value)) updated[i] = replacement;
        }
        if (!found) [updated addObject:replacement];
    }
    if ([updated isEqualToArray:encoded]) return route;
    url.percentEncodedQueryItems = updated;
    return url.string ?: route;
}

static void FQXInstallRankRouteHook(const char *className, const char *getter) {
    SEL selector = Sel(getter);
    Class cls = FQXLookupMatchingClass(className, selector, NO, "@16@0:8");
    if (!cls) return;
    __block IMP original = NULL;
    IMP hook = imp_implementationWithBlock(^id(id model) {
        return FQXBookstoreRankRoute(((id (*)(id, SEL))original)(model, selector));
    });
    if (!FQXInstallOwnedHook(cls, selector, NO, "@16@0:8", hook, &original))
        imp_removeBlock(hook);
}

static BOOL FQXIsBookstoreRankInfo(id info) {
    if (![info isKindOfClass:NSDictionary.class]) return NO;
    id report = info[@"temp_report_info"];
    return [report isKindOfClass:NSDictionary.class] && [report[@"forum_position"] isEqual:@"store_feed_rank"];
}

static void FQXRecordRankStage(NSDictionary *record) {
    Class bridge = objc_lookUpClass("SSCommunitySaaSRouterServiceManager");
    SEL diagnostic = Sel("fqxRecordBookstoreRank:");
    if ([bridge respondsToSelector:diagnostic])
        ((void (*)(id, SEL, id))objc_msgSend)(bridge, diagnostic, record);
}

static void FQXInstallRankRouter(void) {
    Class cls = objc_lookUpClass("SSCommunitySaaSRouterServiceManager");
    SEL open = Sel("handleInnerOpenUrl:extraInfo:");
    __block IMP original = NULL;
    IMP hook = imp_implementationWithBlock(^BOOL(id manager, id route, id info) {
        BOOL rank = FQXIsBookstoreRankInfo(info);
        id routed = rank ? FQXBookstoreRankRoute(route) : route;
        BOOL accepted = ((BOOL (*)(id, SEL, id, id))original)(manager, open, routed, info);
        if (rank)
            FQXRecordRankStage(@{@"stage": @"route", @"normalized": @(routed != route), @"accepted": @(accepted)});
        return accepted;
    });
    if (!FQXInstallOwnedHook(cls, open, YES, "B32@0:8@16@24", hook, &original))
        imp_removeBlock(hook);
}

static void FQXInstallRankLoadRetry(void) {
    Class cls = objc_lookUpClass("SSReadingLynxViewController");
    SEL completion = Sel("readingLynxContainerView:didFinishLoadWithError:");
    SEL reload = Sel("reload");
    Method reloadMethod = cls ? class_getInstanceMethod(cls, reload) : NULL;
    if (!reloadMethod || strcmp(method_getTypeEncoding(reloadMethod), "v16@0:8") != 0) return;

    static char retriedKey;
    __block IMP original = NULL;
    IMP hook = imp_implementationWithBlock(^(UIViewController *page, id container, NSError *error) {
        ((void (*)(id, SEL, id, id))original)(page, completion, container, error);
        if (!FQXIsBookstoreRankInfo(Get(page, "extraInfoDict"))) return;
        FQXRecordRankStage(@{@"stage": @"template", @"completed": @(!error), @"code": @(error.code)});
        if (!error) return;
        __weak UIViewController *weakPage = page;
        // The original callback may still be unwinding the failed load.
        dispatch_async(dispatch_get_main_queue(), ^{
            UIViewController *visible = weakPage;
            if (!visible.isViewLoaded || visible.navigationController.topViewController != visible ||
                objc_getAssociatedObject(visible, &retriedKey)) return;
            objc_setAssociatedObject(visible, &retriedKey, @YES, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
            ((void (*)(id, SEL))objc_msgSend)(visible, reload);
        });
    });
    if (!FQXInstallOwnedHook(cls, completion, NO, "v32@0:8@16@24", hook, &original))
        imp_removeBlock(hook);

    SEL firstScreen = Sel("readingLynxContainerDidFirstScreen:");
    __block IMP nativeFirstScreen = NULL;
    IMP screenHook = imp_implementationWithBlock(^(UIViewController *page, UIView *container) {
        ((void (*)(id, SEL, id))nativeFirstScreen)(page, firstScreen, container);
        if (FQXIsBookstoreRankInfo(Get(page, "extraInfoDict")))
            FQXRecordRankStage(@{@"stage": @"firstScreen"});
    });
    if (!FQXInstallOwnedHook(cls, firstScreen, NO, "v24@0:8@16", screenHook, &nativeFirstScreen))
        imp_removeBlock(screenHook);
}

void FQXInstallContentCleanupHooks(void){
 static dispatch_once_t once;dispatch_once(&once,^{
  FQXInstallRankRouteHook("SSBookStoreRecommendRankListModel", "headerUrlScheme");
  FQXInstallRankRouteHook("SSBookStoreNewType69Model", "headerUrlScheme");
  FQXInstallRankRouteHook("SSBookStoreRank", "linkUrl");
  FQXInstallRankRouter();
  FQXInstallRankLoadRetry();
  NSString *drama=KEY("DramaAutoplay"),*rating=KEY("ReaderRatingInvite"),*excerpt=KEY("ExcerptWidgetGuide"),*widget=KEY("ContentWidgetGuide"),*publish=KEY("BookstorePublishButton"),*story=KEY("StoryAds");
  Bool0("SSShortVideoFeedColdPlayManager","canShowVideoFeedColdPlayVC",NO,drama);
  Void0("SSShortVideoFeedColdPlayManager","prepareVideoFeedColdPlayerIfNeeded",NO,drama);
  Void0("SSVideoFeedContainerViewController","tryExitInterruptInitialModelPlayIfNeed",NO,drama);
  Void0("SSVideoSeriesFeedViewController","resumeVideoPlayIfNeeded",NO,drama);
  Void1("SSShortVideoFeedColdPlayManager","showVideoFeedColdPlayVCWithContainerVC:",NO,drama,NULL);

  Bool1("SSWelfareWidgetManager","canShowBookExcerptWidgetGuideWithBookId:",excerpt);
  Void3("SSWelfareWidgetManager","tryShowBookExcerptWidgetGuideWithBookId:bookName:excerptText:",excerpt,NO);
  Void3("SSWelfareWidgetManager","enqueueBookExcerptWidgetGuideWithBookId:bookName:excerptText:webNovel:",excerpt,YES);
  Void3("SSWelfareWidgetManager","tryShowHistoryWidgetGuideWithConsumeType:BookId:vid:",widget,NO);
  Void2("SSWelfareWidgetManager","tryShowWidgetGuideByCepRule:widgetName:",widget,NO);
  Void2("SSWelfareWidgetManager","_showContentRecommendGuideWithWidgetName:ruleName:",widget,YES);

  Void0Hide("SSBookStoreNestedTabView","showPublishButtonViewIfNeeded",publish,"publishButtonView",NULL);
  Void0Hide("SSBookStoreNestedTabView","showCommunityPublishView",publish,"publishButtonView",NULL);
  Void0Hide("SSBookStoreNestedTabView","showProduceEntranceIfNeeded",publish,"publishButtonView","produceEntranceView");
  Void0Hide("SSBookStoreNestedTabView","showUgcProduceEntranceView",publish,"produceEntranceView",NULL);
  Void0Hide("SSBookStoreCommunityPublishEntranceComponent","injectViewsIntoContainer",publish,"publishButton",NULL);
  Void0Hide("SSBookStoreCommunityPublishEntranceComponent","refreshPublishButtonPositionIfNeed",publish,"publishButton",NULL);

  InstallReaderAndListenPendantHooks();
  InstallAudioAdAndDurationGateHooks();
  Install745ShortVideoAndPopupAdGates();
  InstallAudioBookSyncAndRemoteHooks();

  atomic_store_explicit(&sLastObservedGateStateMask, FQXCurrentPendantAndAudioGateStateMask(), memory_order_relaxed);
  [NSNotificationCenter.defaultCenter addObserverForName:NSUserDefaultsDidChangeNotification
                                                  object:nil
                                                   queue:NSOperationQueue.mainQueue
                                              usingBlock:^(__unused NSNotification *note) {
      int cur = FQXCurrentPendantAndAudioGateStateMask();
      int prev = atomic_exchange_explicit(&sLastObservedGateStateMask, cur, memory_order_relaxed);
      if (prev != cur) {
          FQXRefreshReaderAndAudioPendants();
      }
  }];

  Bool0("SSBizAdImpl","isStoryAdEnable",NO,story);
  Bool0("BDADStoryAdManager","canRequestStoryAd",NO,story);
  Bool0("SSShortStoryAdConfig","enable_short_story_ad",NO,story);
  Object1("SSBizStoryAdInsertManager","getAdModelWithPageInfo:",story);
  Bool0("SSStoryPostFeedViewController","isInterceptAdShowAndStopScroll",NO,story);

  InstallHotLaunchHooks();
  InstallWidgetDialogHooks();

  // Defer Reader-only comment/inline hooks off the dyld cold-start path, and sweep any early-mounted pendants.
  dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.25 * NSEC_PER_SEC)),
                 dispatch_get_main_queue(), ^{
   Bool3("SSReaderBookCommentDialogTask","shouldShowBookCommentGuideWithReaderManager:userId:fromCtx:",rating);
   Bool0("SSReaderBookCommentDialogTask","readerPublishCommentGuideReadTime",NO,rating);
   Bool0("SSReaderExitInterruptManager","checkBookCommentGuideByExit",NO,rating);
   Bool0("SSReaderExitInterruptManager","showBookCommentGuideByExit",NO,rating);
   Void0("SSReaderBookEndCommentSectionInsertHelper","tryShowBookEndCommentGuide",NO,rating);
   Void0("SSReaderBookEndCommentSectionInsertHelper","tryShowV723BookEndCommentGuide",NO,rating);
   Void0("SSReaderBookEndCommentSectionInsertHelper","tryShowAppendCommentGuide",NO,rating);

   InstallChapterTitle();
   InstallReaderInlineDramaAdHooks();
   FQXRefreshReaderAndAudioPendants();
  });
 });
}
