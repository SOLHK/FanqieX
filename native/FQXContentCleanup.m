#import <UIKit/UIKit.h>
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
 });
}
