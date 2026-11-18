#import <UIKit/UIKit.h>
#import <AVFoundation/AVFoundation.h>
#import <os/lock.h>
#import <objc/message.h>
#import <objc/runtime.h>
#import "FQXHookInstaller.h"

#define KEY(name) @"FanqieX." name ".1"
static BOOL On(NSString *key){id v=[NSUserDefaults.standardUserDefaults objectForKey:key];return [v respondsToSelector:@selector(boolValue)]&&[v boolValue];}
static SEL Sel(const char *s){return sel_registerName(s);}
static id Get(id o,const char *s){SEL x=Sel(s);return o&&[o respondsToSelector:x]?((id(*)(id,SEL))objc_msgSend)(o,x):nil;}

static BOOL Bool0(const char*c,const char*s,BOOL cm,NSString*k){
 Class cls=NSClassFromString([NSString stringWithUTF8String:c]);SEL x=Sel(s);__block IMP old=NULL;
 IMP hook=imp_implementationWithBlock(^BOOL(id o){return On(k)?NO:((BOOL(*)(id,SEL))old)(o,x);});
 if(!FQXInstallOwnedHook(cls,x,cm,"B16@0:8",hook,&old)){imp_removeBlock(hook);return NO;}return YES;
}
static BOOL Void0Hide(const char*c,const char*s,NSString*k,const char *g1,const char *g2){
 Class cls=NSClassFromString([NSString stringWithUTF8String:c]);SEL x=Sel(s);__block IMP old=NULL;
 IMP hook=imp_implementationWithBlock(^(id o){
  if(!On(k)){((void(*)(id,SEL))old)(o,x);return;}
  for(const char **g=(const char *[]){g1,g2,NULL};*g;++g){id v=Get(o,*g);if([v isKindOfClass:UIView.class])((void(*)(id,SEL,BOOL))objc_msgSend)(v,Sel("setHidden:"),YES);}
 });
 if(!FQXInstallOwnedHook(cls,x,NO,"v16@0:8",hook,&old)){imp_removeBlock(hook);return NO;}return YES;
}
static BOOL Void0(const char*c,const char*s,BOOL cm,NSString*k){
 Class cls=NSClassFromString([NSString stringWithUTF8String:c]);SEL x=Sel(s);__block IMP old=NULL;
 IMP hook=imp_implementationWithBlock(^(id o){if(!On(k))((void(*)(id,SEL))old)(o,x);});
 if(!FQXInstallOwnedHook(cls,x,cm,"v16@0:8",hook,&old)){imp_removeBlock(hook);return NO;}return YES;
}
static BOOL Bool1(const char*c,const char*s,NSString*k){
 Class cls=NSClassFromString([NSString stringWithUTF8String:c]);SEL x=Sel(s);__block IMP old=NULL;
 IMP hook=imp_implementationWithBlock(^BOOL(id o,id a){return On(k)?NO:((BOOL(*)(id,SEL,id))old)(o,x,a);});
 if(!FQXInstallOwnedHook(cls,x,NO,"B24@0:8@16",hook,&old)){imp_removeBlock(hook);return NO;}return YES;
}
static BOOL Bool3(const char*c,const char*s,NSString*k){
 Class cls=NSClassFromString([NSString stringWithUTF8String:c]);SEL x=Sel(s);__block IMP old=NULL;
 IMP hook=imp_implementationWithBlock(^BOOL(id o,id a,id b,id d){return On(k)?NO:((BOOL(*)(id,SEL,id,id,id))old)(o,x,a,b,d);});
 if(!FQXInstallOwnedHook(cls,x,NO,"B40@0:8@16@24@32",hook,&old)){imp_removeBlock(hook);return NO;}return YES;
}
static BOOL Object1(const char*c,const char*s,NSString*k){
 Class cls=NSClassFromString([NSString stringWithUTF8String:c]);SEL x=Sel(s);__block IMP old=NULL;
 IMP hook=imp_implementationWithBlock(^id(id o,id a){return On(k)?nil:((id(*)(id,SEL,id))old)(o,x,a);});
 if(!FQXInstallOwnedHook(cls,x,NO,"@24@0:8@16",hook,&old)){imp_removeBlock(hook);return NO;}return YES;
}
static BOOL BoolClass(const char*c,const char*s,NSString*k){
 Class cls=NSClassFromString([NSString stringWithUTF8String:c]);SEL x=Sel(s);__block IMP old=NULL;
 IMP hook=imp_implementationWithBlock(^BOOL(id o,Class a){return On(k)?NO:((BOOL(*)(id,SEL,Class))old)(o,x,a);});
 if(!FQXInstallOwnedHook(cls,x,YES,"B24@0:8#16",hook,&old)){imp_removeBlock(hook);return NO;}return YES;
}
static BOOL VoidClass(const char*c,const char*s,NSString*k){
 Class cls=NSClassFromString([NSString stringWithUTF8String:c]);SEL x=Sel(s);__block IMP old=NULL;
 IMP hook=imp_implementationWithBlock(^(id o,Class a){if(!On(k))((void(*)(id,SEL,Class))old)(o,x,a);});
 if(!FQXInstallOwnedHook(cls,x,YES,"v24@0:8#16",hook,&old)){imp_removeBlock(hook);return NO;}return YES;
}
static BOOL Void1(const char*c,const char*s,BOOL cm,NSString*k,const char*getter){
 Class cls=NSClassFromString([NSString stringWithUTF8String:c]);SEL x=Sel(s);__block IMP old=NULL;
 IMP hook=imp_implementationWithBlock(^(id o,id a){
   if(!On(k)){((void(*)(id,SEL,id))old)(o,x,a);return;}
   if(getter){id v=Get(o,getter);if([v isKindOfClass:UIView.class])((UIView *)v).hidden=YES;}
 });
 if(!FQXInstallOwnedHook(cls,x,cm,"v24@0:8@16",hook,&old)){imp_removeBlock(hook);return NO;}return YES;
}
static BOOL Void2(const char*c,const char*s,NSString*k,BOOL firstIsWidget){
 Class cls=NSClassFromString([NSString stringWithUTF8String:c]);SEL x=Sel(s);__block IMP old=NULL;
 IMP hook=imp_implementationWithBlock(^(id o,id a,id b){id w=firstIsWidget?a:b;if(On(k)&&[w isEqual:@"widget_history"])return;((void(*)(id,SEL,id,id))old)(o,x,a,b);});
 if(!FQXInstallOwnedHook(cls,x,NO,"v32@0:8@16@24",hook,&old)){imp_removeBlock(hook);return NO;}return YES;
}
static BOOL Void3(const char*c,const char*s,NSString*k,BOOL withBool){
 Class cls=NSClassFromString([NSString stringWithUTF8String:c]);SEL x=Sel(s);__block IMP old=NULL;
 if(withBool){IMP hook=imp_implementationWithBlock(^(id o,id a,id b,id d,BOOL flag){if(!On(k))((void(*)(id,SEL,id,id,id,BOOL))old)(o,x,a,b,d,flag);});
  if(!FQXInstallOwnedHook(cls,x,NO,"v44@0:8@16@24@32B40",hook,&old)){imp_removeBlock(hook);return NO;}return YES;}
 IMP hook=imp_implementationWithBlock(^(id o,id a,id b,id d){if(!On(k))((void(*)(id,SEL,id,id,id))old)(o,x,a,b,d);});
 if(!FQXInstallOwnedHook(cls,x,NO,"v40@0:8@16@24@32",hook,&old)){imp_removeBlock(hook);return NO;}return YES;
}

static BOOL SuppressWidgetDialog(id dialog) {
 id view=Get(dialog,"contentView");
 Class history=NSClassFromString(@"SSWelfareWidgetGuideView");
 if(On(KEY("ContentWidgetGuide"))&&history&&[view isKindOfClass:history]&&
    [Get(view,"widgetName") isEqual:@"widget_history"]){
  SEL close=Sel("closeButtonClicked:");
  if([view respondsToSelector:close])((void(*)(id,SEL,id))objc_msgSend)(view,close,nil);
  return YES;
 }
 Class excerpt=NSClassFromString(@"SSBookExcerptWidgetGuideView");
 if(On(KEY("ExcerptWidgetGuide"))&&excerpt&&[view isKindOfClass:excerpt]){
  SEL cancel=Sel("cancelButtonClicked");
  if([view respondsToSelector:cancel])((void(*)(id,SEL))objc_msgSend)(view,cancel);
  return YES;
 }
 return NO;
}
static void(*OriginalDialogShow)(id,SEL,id,BOOL);
static void DialogShow(id o,SEL cmd,id view,BOOL enqueue){if(!SuppressWidgetDialog(o))OriginalDialogShow(o,cmd,view,enqueue);}
static void(*OriginalDialogInnerShow)(id,SEL,id);
static void DialogInnerShow(id o,SEL cmd,id view){if(!SuppressWidgetDialog(o))OriginalDialogInnerShow(o,cmd,view);}
static void InstallWidgetDialogHooks(void){
 Class c=NSClassFromString(@"SSDialogView");SEL s=Sel("showInView:enqueue:");IMP old=NULL;
 if(FQXInstallOwnedHook(c,s,NO,"v32@0:8@16B24",(IMP)DialogShow,&old))OriginalDialogShow=(void*)old;
 s=Sel("innerShowInView:");old=NULL;
 if(FQXInstallOwnedHook(c,s,NO,"v24@0:8@16",(IMP)DialogInnerShow,&old))OriginalDialogInnerShow=(void*)old;
}

// Keep foreground-only splash suppression isolated to the calling thread.
static _Thread_local NSUInteger ForegroundSplashDepth;
static void(*OriginalForegroundEnter)(id,SEL);
static void ForegroundEnter(id o,SEL cmd){
 ++ForegroundSplashDepth;
 @try { OriginalForegroundEnter(o,cmd); }
 @finally { --ForegroundSplashDepth; }
}
static void(*OriginalSplashBanner)(id,SEL);
static void SplashBanner(id o,SEL cmd){
 if(!On(KEY("HotLaunchAds"))||!ForegroundSplashDepth)OriginalSplashBanner(o,cmd);
}
static void InstallHotLaunchHooks(void){
 NSString *key=KEY("HotLaunchAds");
 Bool0("SSReadingAdSplashService","shouldShowSplashAtHotLaunch",NO,key);
 Bool0("SSReadingAdSplashService","shouldShowSplashAdAtHotLaunchByThirdParty",NO,key);
 Class c=NSClassFromString(@"SSReadingAdSplashService");SEL s=Sel("appWillEnterForeground");IMP old=NULL;
 if(FQXInstallOwnedHook(c,s,NO,"v16@0:8",(IMP)ForegroundEnter,&old))OriginalForegroundEnter=(void*)old;
 s=Sel("showBannerTopViewInSplash");old=NULL;
 if(FQXInstallOwnedHook(c,s,NO,"v16@0:8",(IMP)SplashBanner,&old))OriginalSplashBanner=(void*)old;
}

static char ChapterTitleAssociation;
static void(*OriginalRefresh)(id,SEL,id,id,id);
static void RefreshChapterTitle(id o,SEL cmd,id top,id context,id book){
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
 Class c=NSClassFromString(@"SSReaderTopViewInsertManager");SEL s=Sel("refreshTopView:withPageContext:bookId:");__block IMP old=NULL;
 if(FQXInstallOwnedHook(c,s,NO,"v40@0:8@16@24@32",(IMP)RefreshChapterTitle,&old))OriginalRefresh=(void*)old;
 c=NSClassFromString(@"FQReaderTopView");s=Sel("setTitle:");old=NULL;
 if(FQXInstallOwnedHook(c,s,NO,"v24@0:8@16",(IMP)SetChapterTitle,&old))OriginalSetTitle=(void*)old;
}

static BOOL AdBlockActive(void){
 id v=[NSUserDefaults.standardUserDefaults objectForKey:@"FanqieAdBlock.Options.1"];
 return ![v respondsToSelector:@selector(integerValue)]||[v integerValue]!=0;
}
static void AdConstBool0(const char *c,const char *s,BOOL cm,BOOL blockedValue){
 Class cls=NSClassFromString([NSString stringWithUTF8String:c]);SEL x=Sel(s);__block IMP old=NULL;
 IMP hook=imp_implementationWithBlock(^BOOL(id o){return AdBlockActive()?blockedValue:((BOOL(*)(id,SEL))old)(o,x);});
 if(!FQXInstallOwnedHook(cls,x,cm,"B16@0:8",hook,&old))imp_removeBlock(hook);
}
static void InstallReaderInlineDramaAdHooks(void){
 AdConstBool0("SSReaderGenreContentManager","contentEnable",NO,NO);
 AdConstBool0("SSReaderGenreContentManager","enable",NO,NO);
 AdConstBool0("SSReaderGenreContentManager","enableParagraphInsert",NO,NO);
 AdConstBool0("SSReaderGenreContentManager","noAdForAllScene",NO,YES);
 {
  Class cls=NSClassFromString(@"SSReaderGenreContentManager");
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
  Class cls=NSClassFromString(@"SSReaderParaShortVideoManager");
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
  Class cls=NSClassFromString(@"SSReaderParaShortVideoDataManager");
  SEL sd=Sel("attachmentsWithBookId:chapterId:containerWidth:textFontSize:");__block IMP od=NULL;
  IMP hd=imp_implementationWithBlock(^id(id o,id bid,id cid,double w,double fs){
   return AdBlockActive()?nil:((id(*)(id,SEL,id,id,double,double))od)(o,sd,bid,cid,w,fs);
  });
  if(!FQXInstallOwnedHook(cls,sd,NO,"@48@0:8@16@24d32d40",hd,&od))imp_removeBlock(hd);
 }
 {
  Class cls=NSClassFromString(@"SSReaderGenreContentRerankManager");
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
  Class cls=NSClassFromString(@"SSReaderLayoutProcessData");
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
static void TrackWeakObject(NSHashTable **slot,id obj){
 if(!obj)return;
 os_unfair_lock_lock(&sAudioTrackLock);
 if(!*slot)*slot=[NSHashTable weakObjectsHashTable];
 [*slot addObject:obj];
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
 Class centerCls=NSClassFromString(@"HTSServiceCenter");
 Class sdkCls=NSClassFromString(@"SSAudioPlaySDKManager");
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
 return BoolMsg0(sdk,"playing")||BoolMsg0(sdk,"paused")||BoolMsg0(sdk,"loading");
}
static BOOL FQXVideoNowPlayingActive(void){
 Class fqvCls=NSClassFromString(@"FQVNowPlayingInfoCenter");
 id fqv=Get((id)fqvCls,"defaultCenter");
 return fqv&&Get(fqv,"playingPlayer")!=nil;
}
static void FQXClearSystemNowPlayingIfIdle(void){
 if(FQXVideoNowPlayingActive()||FQXAudioBookAlive())return;
 Class mpCls=NSClassFromString(@"MPNowPlayingInfoCenter");
 id center=Get((id)mpCls,"defaultCenter");
 VoidMsgObj(center,"setNowPlayingInfo:",nil);
}
static void FQXHideParaEntranceSubviews(UIView *root,Class targetCls,NSInteger depth){
 if(!targetCls||![root isKindOfClass:UIView.class]||depth>8)return;
 if([root isKindOfClass:targetCls]){root.hidden=YES;return;}
 for(UIView *sub in root.subviews)FQXHideParaEntranceSubviews(sub,targetCls,depth+1);
}
static void FQXCleanStaleReaderAudioUIOnMain(void){
 id sdk=FQXAudioSDKManager();
 id activeBook=(!sdk||BoolMsg0(sdk,"audioStopped"))?nil:Get(sdk,"currentBookId");
 if(![activeBook isKindOfClass:NSString.class]||![(NSString *)activeBook length])activeBook=nil;
 for(id ttsMgr in SnapshotTracked(sTrackedTTSManagers)){
  if(!BoolMsg0(ttsMgr,"isSyncing")&&!BoolMsg0(ttsMgr,"isActiveForCurrentBook")){
   VoidMsg0(ttsMgr,"stopAutoScroll");
   VoidMsg0(ttsMgr,"private_cleanCurrentLineInfo");
   VoidMsgBool(ttsMgr,"setHasShowSyncBtn:",NO);
   VoidMsg0(ttsMgr,"refreshSyncTTSBtn");
   VoidMsgBool(Get(ttsMgr,"readerMgr"),"setSyncTTSBtnHidden:",YES);
  }
 }
 Class entranceViewCls=NSClassFromString(@"SSReaderTTSParagraphEntranceView");
 for(id paraMgr in SnapshotTracked(sTrackedParaManagers)){
  id bookId=Get(paraMgr,"bookId");
  BOOL sameActive=activeBook&&[bookId isKindOfClass:NSString.class]&&[bookId isEqual:activeBook];
  if(!sameActive){
   VoidMsg0(paraMgr,"cancelDelayHidePlayAnchor");
   VoidMsg0(paraMgr,"applyToHidePlayAnchorViews");
   VoidMsg0(paraMgr,"removeReaderInsertViewIfNeeded");
   id rvc=Get(paraMgr,"readerVC");
   id rview=BoolMsg0(rvc,"isViewLoaded")?Get(rvc,"view"):nil;
   if([rview isKindOfClass:UIView.class])FQXHideParaEntranceSubviews((UIView *)rview,entranceViewCls,0);
   if(BoolMsg0(rvc,"isVCAppear")){
    id actionDelegate=Get(Get(Get(paraMgr,"readerManager"),"readerModel"),"actionDelegate");
    VoidMsg0(actionDelegate,"readerActionRefreshCurrentPage");
   }
  }
 }
}
static void FQXScheduleStaleReaderAudioUIClean(void){
 if([NSThread isMainThread])FQXCleanStaleReaderAudioUIOnMain();
 dispatch_async(dispatch_get_main_queue(),^{FQXCleanStaleReaderAudioUIOnMain();});
}
static void FQXEnsureRemoteCommandsReady(id playMgr){
 if(!playMgr||BoolMsg0(playMgr,"playIsStopped")||!Get(playMgr,"playInfo"))return;
 for(const char **k=(const char *[]){"playCommand","pauseCommand","togglePlayPauseCommand",NULL};*k;++k){
  VoidMsgBool(Get(playMgr,*k),"setEnabled:",YES);
 }
 Class ccCls=NSClassFromString(@"MPRemoteCommandCenter");
 id cc=Get((id)ccCls,"sharedCommandCenter");
 for(const char **k=(const char *[]){"playCommand","pauseCommand","togglePlayPauseCommand",NULL};*k;++k){
  VoidMsgBool(Get(cc,*k),"setEnabled:",YES);
 }
 if([NSThread isMainThread]){
  [UIApplication.sharedApplication beginReceivingRemoteControlEvents];
 }else{
  dispatch_async(dispatch_get_main_queue(),^{[UIApplication.sharedApplication beginReceivingRemoteControlEvents];});
 }
}
static void FQXEnsurePlaybackSessionActive(void){
 AVAudioSession *session=[AVAudioSession sharedInstance];
 [session setCategory:AVAudioSessionCategoryPlayback error:nil];
 [session setActive:YES error:nil];
}
static void InstallAudioBookSyncAndRemoteHooks(void){
 {
  Class cls=NSClassFromString(@"FQReaderSaaSTTSManager");
  SEL si=Sel("initWithReaderManager:");__block IMP oi=NULL;
  IMP hi=imp_implementationWithBlock(^id(id o,id rm){
   id res=((id(*)(id,SEL,id))oi)(o,si,rm);
   TrackWeakObject(&sTrackedTTSManagers,res);
   return res;
  });
  if(!FQXInstallOwnedHook(cls,si,NO,"@24@0:8@16",hi,&oi))imp_removeBlock(hi);
  SEL sa=Sel("onReaderDidAppear:");__block IMP oa=NULL;
  IMP ha=imp_implementationWithBlock(^(id o,id rm){
   TrackWeakObject(&sTrackedTTSManagers,o);
   ((void(*)(id,SEL,id))oa)(o,sa,rm);
   if(!BoolMsg0(o,"isSyncing")&&!BoolMsg0(o,"isActiveForCurrentBook")){
    FQXScheduleStaleReaderAudioUIClean();
   }
  });
  if(!FQXInstallOwnedHook(cls,sa,NO,"v24@0:8@16",ha,&oa))imp_removeBlock(ha);
 }
 {
  Class cls=NSClassFromString(@"SSReaderTTSParaEntranceManager");
  SEL si=Sel("initWithReaderManager:");__block IMP oi=NULL;
  IMP hi=imp_implementationWithBlock(^id(id o,id rm){
   id res=((id(*)(id,SEL,id))oi)(o,si,rm);
   TrackWeakObject(&sTrackedParaManagers,res);
   return res;
  });
  if(!FQXInstallOwnedHook(cls,si,NO,"@24@0:8@16",hi,&oi))imp_removeBlock(hi);
 }
 {
  Class cls=NSClassFromString(@"SSAudioPlaySDKManager");
  for(NSString *sn in @[@"audioResetWithEntry:",@"audioStopWithEntry:"]){
   SEL s=NSSelectorFromString(sn);__block IMP old=NULL;
   IMP h=imp_implementationWithBlock(^(id o,id entry){
    TrackAudioSDK(o);
    ((void(*)(id,SEL,id))old)(o,s,entry);
    VoidMsgObj(o,"remoteRemoveCommandWithSource:",@"fqx_stop");
    VoidMsg0(o,"remoteClearPlayInfo");
    FQXClearSystemNowPlayingIfIdle();
    FQXScheduleStaleReaderAudioUIClean();
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
  Class cls=NSClassFromString(@"SSAudioServiceABTestHelper");
  SEL sr=Sel("audioPlaybackCategoryRecoverEnable");__block IMP orv=NULL;
  IMP hr=imp_implementationWithBlock(^BOOL(id o){
   (void)o;(void)orv;return YES;
  });
  if(!FQXInstallOwnedHook(cls,sr,YES,"B16@0:8",hr,&orv))imp_removeBlock(hr);
 }
 {
  Class cls=NSClassFromString(@"FQVNowPlayingInfoCenter");
  SEL s1=Sel("resignPlayingPlayer:");__block IMP o1=NULL;
  IMP h1=imp_implementationWithBlock(^(id o,id player){
   BOOL hadTarget=BoolMsg0(o,"remoteCommandTargetSelf");
   id curPlayer=Get(o,"playingPlayer");
   if(!hadTarget&&!curPlayer&&FQXAudioBookAlive())return;
   ((void(*)(id,SEL,id))o1)(o,s1,player);
   if(!Get(o,"playingPlayer")&&FQXAudioBookAlive()){
    id sdk=FQXAudioSDKManager();
    VoidMsg0(sdk,"remoteAddCommand");
    VoidMsg0(sdk,"remoteUpdatePlayInfo");
    FQXEnsureRemoteCommandsReady(Get(sdk,"bdfqPlayManager"));
   }
  });
  if(!FQXInstallOwnedHook(cls,s1,NO,"v24@0:8@16",h1,&o1))imp_removeBlock(h1);
  SEL s2=Sel("refreshRemoteCommandEnable");__block IMP o2=NULL;
  IMP h2=imp_implementationWithBlock(^(id o){
   if(!BoolMsg0(o,"remoteCommandTargetSelf")&&!Get(o,"playingPlayer")&&FQXAudioBookAlive())return;
   ((void(*)(id,SEL))o2)(o,s2);
  });
  if(!FQXInstallOwnedHook(cls,s2,NO,"v16@0:8",h2,&o2))imp_removeBlock(h2);
 }
 {
  Class cls=NSClassFromString(@"BDFQPlayManager");
  SEL sp=Sel("pauseWithSource:");__block IMP op=NULL;
  IMP hp=imp_implementationWithBlock(^(id o,id src){
   ((void(*)(id,SEL,id))op)(o,sp,src);
   if(FQXAudioBookAlive()&&!BoolMsg0(o,"playIsStopped")&&Get(o,"playInfo")){
    FQXEnsurePlaybackSessionActive();
    FQXEnsureRemoteCommandsReady(o);
   }
  });
  if(!FQXInstallOwnedHook(cls,sp,NO,"v24@0:8@16",hp,&op))imp_removeBlock(hp);
  SEL sw=Sel("appWillResignActive:");__block IMP ow=NULL;
  IMP hw=imp_implementationWithBlock(^(id o,id note){
   ((void(*)(id,SEL,id))ow)(o,sw,note);
   if(FQXAudioBookAlive()&&!BoolMsg0(o,"playIsStopped")&&Get(o,"playInfo")){
    FQXEnsurePlaybackSessionActive();
    FQXEnsureRemoteCommandsReady(o);
   }
  });
  if(!FQXInstallOwnedHook(cls,sw,NO,"v24@0:8@16",hw,&ow))imp_removeBlock(hw);
  SEL sd=Sel("disableAllRemoteCommands");__block IMP od=NULL;
  IMP hd=imp_implementationWithBlock(^(id o){
   if(!FQXVideoNowPlayingActive()&&FQXAudioBookAlive()&&!BoolMsg0(o,"playIsStopped")&&Get(o,"playInfo")){
    FQXEnsureRemoteCommandsReady(o);
    return;
   }
   ((void(*)(id,SEL))od)(o,sd);
  });
  if(!FQXInstallOwnedHook(cls,sd,NO,"v16@0:8",hd,&od))imp_removeBlock(hd);
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
    FQXEnsureRemoteCommandsReady(o);
   });
   if(!FQXInstallOwnedHook(cls,su,NO,"v16@0:8",hu,&ou))imp_removeBlock(hu);
  }
  SEL st=Sel("tryToPlayAtTime:position:disableIntercept:source:");__block IMP ot=NULL;
  IMP ht=imp_implementationWithBlock(^(id o,double t,id pos,BOOL disInt,id src){
   if([src isKindOfClass:NSString.class]){
    NSString *s=(NSString *)src;
    if([s rangeOfString:@"remote" options:NSCaseInsensitiveSearch].location!=NSNotFound||
       [s rangeOfString:@"toggle" options:NSCaseInsensitiveSearch].location!=NSNotFound){
     FQXEnsurePlaybackSessionActive();
     VoidMsgObj(FQXAudioSDKManager(),"ensurePlaybackAudioSessionCategoryForScene:",@"remote_resume");
     disInt=YES;
    }
   }
   ((void(*)(id,SEL,double,id,BOOL,id))ot)(o,st,t,pos,disInt,src);
  });
  if(!FQXInstallOwnedHook(cls,st,NO,"v44@0:8d16@24B32@36",ht,&ot))imp_removeBlock(ht);
 }
}

void FQXInstallContentCleanupHooks(void){
 static dispatch_once_t once;dispatch_once(&once,^{
  NSString *drama=KEY("DramaAutoplay"),*rating=KEY("ReaderRatingInvite"),*excerpt=KEY("ExcerptWidgetGuide"),*widget=KEY("ContentWidgetGuide"),*publish=KEY("BookstorePublishButton"),*pendant=KEY("ListenPendant"),*story=KEY("StoryAds"),*audio=KEY("AudioAds");
  Bool0("SSShortVideoFeedColdPlayManager","canShowVideoFeedColdPlayVC",NO,drama);
  Void0("SSShortVideoFeedColdPlayManager","prepareVideoFeedColdPlayerIfNeeded",NO,drama);
  Void0("SSVideoFeedContainerViewController","tryExitInterruptInitialModelPlayIfNeed",NO,drama);
  Void0("SSVideoSeriesFeedViewController","resumeVideoPlayIfNeeded",NO,drama);
  Void1("SSShortVideoFeedColdPlayManager","showVideoFeedColdPlayVCWithContainerVC:",NO,drama,NULL);

  Bool3("SSReaderBookCommentDialogTask","shouldShowBookCommentGuideWithReaderManager:userId:fromCtx:",rating);
  Bool0("SSReaderBookCommentDialogTask","readerPublishCommentGuideReadTime",NO,rating);
  Bool0("SSReaderExitInterruptManager","checkBookCommentGuideByExit",NO,rating);
  Bool0("SSReaderExitInterruptManager","showBookCommentGuideByExit",NO,rating);
  Void0("SSReaderBookEndCommentSectionInsertHelper","tryShowBookEndCommentGuide",NO,rating);
  Void0("SSReaderBookEndCommentSectionInsertHelper","tryShowV723BookEndCommentGuide",NO,rating);
  Void0("SSReaderBookEndCommentSectionInsertHelper","tryShowAppendCommentGuide",NO,rating);

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


  BoolClass("SSWelfareListenPendantManager","canShowPendantInVC:",pendant);
  VoidClass("SSWelfareListenPendantManager","tryShowPendant:",pendant);
  Void1("SSWelfareListenPendantManager","triggerKmpPendantIfNeededWithAttachView:",NO,pendant,NULL);
  Void0("SSWelfareListenPendantManager","addHoverView",NO,pendant);
  Void0("SSWelfareListenPendantManager","refreshHoverView",NO,pendant);
  Void0("SSWelfareListenPendantManager","tryShowAssetAwarenessBubble",NO,pendant);
  Void0("SSWelfareListenPendantManager","tryShowLimitTimeDoubleBubble",NO,pendant);
  Void0("SSWelfareListenPendantManager","tryShowTodayMaxRewardBubble",NO,pendant);
  Void0("SSWelfareListenPendantManager","tryShowRewardNoticeBubble",NO,pendant);
  Void0("SSWelfareListenPendantManager","tryShowDaily1MinTipsBubble",NO,pendant);
  Void0("SSWelfareGlobalPendantManager","tryShowPendant",NO,pendant);
  Void0("SSWelfareGlobalPendantManager","showAfterHidingTemp",NO,pendant);
  Void0("SSWelfareGlobalPendantManager","addHoverView",NO,pendant);
  Void0("SSWelfareGlobalPendantManager","refreshHoverView",NO,pendant);
  Void1("SSWelfareGlobalPendantManager","triggerKmpPendantIfNeededWithAttachView:",NO,pendant,NULL);
  Bool0("SSWelfareGlobalPendantManager","isCommonCouldShowBubble",NO,pendant);
  Void0("SSWelfareGlobalPendantManager","tryShowDaily1MinBubble",NO,pendant);
  Void0("SSWelfareGlobalPendantManager","tryShowAssetAwarenessBubble",NO,pendant);

  Bool0("SSBizAdImpl","isStoryAdEnable",NO,story);
  Bool0("BDADStoryAdManager","canRequestStoryAd",NO,story);
  Bool0("SSShortStoryAdConfig","enable_short_story_ad",NO,story);
  Object1("SSBizStoryAdInsertManager","getAdModelWithPageInfo:",story);
  Bool0("SSStoryPostFeedViewController","isInterceptAdShowAndStopScroll",NO,story);
  Bool0("SSAdFeedAudioClient","hasAd",NO,audio);
  Void1("SSAdFeedAudioATModel","setMaterielData:",NO,audio,NULL);
  Void1("SSAdFeedAudioATModel","updateWithMaterielData:",NO,audio,NULL);
  Bool0("SSStoryPostNavigationBarConfig","showGoldCoinProgress",NO,pendant);

  InstallHotLaunchHooks();
  InstallWidgetDialogHooks();

  Bool0("SSAdCommonConfigAdapter","audioPatchAdSwitch",NO,audio);
  Bool0("SSAdCommonConfigAdapter","audioInfoFlowAdSwitch",NO,audio);
  Void0("SSAdFeedAudioClient","initLoader",NO,audio);
  Void0("SSAdFeedAudioClient","initMetaverseLoader",NO,audio);
  Void0("SSAdFeedAudioClient","metaverReload",NO,audio);
  Void0("SSAdFeedAudioClient","addFeedAudioAd",NO,audio);
  Void1("SSAdFeedAudioClient","showMetaverseDataIfNeed:",NO,audio,NULL);
  Void1("SSAdFeedAudioClient","showMannorDataIfNeed:",NO,audio,NULL);
  InstallChapterTitle();
  InstallReaderInlineDramaAdHooks();
  InstallAudioBookSyncAndRemoteHooks();
 });
}
