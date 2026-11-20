#import <UIKit/UIKit.h>
#import <objc/message.h>
#import <objc/runtime.h>
#import "FQXHookInstaller.h"
extern void FQXInstallContentCleanupHooks(void);
extern void FQXInstallMotionAndAudioHooks(void);

#define CLEANUP_OPTIONS(X) \
    X(AuthorWords, "ReaderAuthorWords", "显示作者的话", "reader", YES) \
    X(ChapterDiscussion, "ReaderChapterDiscussion", "显示章末讨论入口", "reader", YES) \
    X(ChapterCircle, "ReaderChapterCircle", "显示章末圈子", "reader", YES) \
    X(ChapterForum, "ReaderChapterForum", "显示章末论坛入口", "reader", YES) \
    X(ChapterGift, "ReaderChapterGift", "显示章末送礼物", "reader", YES) \
    X(ChapterEndActions, "ReaderChapterEndActions", "显示最新章节底部三个按钮", "reader", YES) \
    X(ReaderComments, "ReaderComments", "显示章末开启评论", "reader", YES) \
    X(CommentActivityBanner, "CommentActivityBanner", "显示评论区公告与活动", "comment", YES) \
    X(CommentSearchEntrance, "CommentSearchEntrance", "显示评论区大家都在搜", "comment", YES) \
    X(ReaderEarnMore, "ReaderEarnMore", "显示阅读页去赚更多", "reader", YES) \
    X(SpeechFloat, "ReaderSpeechFloat", "显示阅读页听书悬浮按钮", "reader", YES) \
    X(ChapterEndDrama, "ReaderChapterEndDrama", "显示阅读底栏改编剧场", "reader", YES) \
    X(AudioRecommendations, "AudioRecommendations", "显示听书页推荐内容", "reader", YES) \
    X(AudioControlIconsOnly, "AudioControlIconsOnly", "朗读按钮仅显示图标", "audio", NO) \
    X(MineScanButton, "MineScanButton", "显示我的顶部扫一扫", "mine", YES) \
    X(MineSearchBar, "MineSearchBar", "显示我的顶部搜索框", "mine", YES) \
    X(MineNightButton, "MineNightButton", "显示我的顶部夜间按钮", "mine", YES) \
    X(MineShortcutCard, "MineShortcutCard", "显示我的快捷功能卡片", "mine", YES) \
    X(MinePublish, "MinePublish", "显示我的页面发帖按钮", "mine", YES) \
    X(MineRecommendations, "MineRecommendations", "显示推荐内容", "mine", YES) \
    X(MineBenefits, "MineBenefitsCard", "显示金币与福利卡片", "mine", YES) \
    X(ShelfBanner, "ShelfRecommendationBanner", "显示书架推荐横幅", "shelf", YES) \
    X(ShelfImport, "ShelfLocalImport", "显示书架本地书导入入口", "shelf", YES) \
    X(ShelfComic, "ShelfMotionComicRecommendation", "显示书架漫剧推荐", "shelf", YES) \
    X(ShelfRecommendations, "ShelfRecommendations", "显示书架推荐内容", "shelf", YES) \
    X(Foreground, "NotificationsForeground", "显示前台通知提醒", "notifications", YES) \
    X(Badge, "NotificationsBadge", "显示 App 图标角标", "notifications", YES) \
    X(DoubleTap, "ReaderDoubleTapAutoread", "双击正文切换自动阅读", "gestures", NO) \
    X(DurationLimit, "ReaderAutoReadDurationLimit", "关闭自动阅读广告时长限制", "gestures", NO) \
    X(DramaPinchPureClean, "DramaPinchPureClean", "双指缩放切换纯净清屏", "drama", NO) \
    X(DramaPinchHaptic, "DramaPinchHaptic", "双指缩放清屏震动反馈", "drama", YES) \
    X(DramaDoubleTapComment, "DramaDoubleTapComment", "双击打开评论区（关闭双击点赞）", "drama", NO) \
    X(DramaCommentNoVideoShift, "DramaCommentNoVideoShift", "打开评论区短剧画面不上移", "drama", NO) \
    X(DramaExitCollectAlert, "DramaExitCollectAlert", "隐藏短剧退出收藏弹窗", "drama", NO) \
    X(DramaOutlineActions, "DramaOutlineActions", "短剧右侧使用空心图标", "drama", NO) \
    X(DramaShowCollect, "DramaShowCollect", "显示收藏按钮", "dramaActions", YES) \
    X(DramaShowComment, "DramaShowComment", "显示评论按钮", "dramaActions", YES) \
    X(DramaShowLike, "DramaShowLike", "显示点赞按钮", "dramaActions", YES) \
    X(DramaShowShare, "DramaShowShare", "显示分享按钮", "dramaActions", YES) \
    X(DramaAutoplay, "DramaAutoplay", "关闭短剧进入自动播放", "drama", NO) \
    X(ReaderRatingInvite, "ReaderRatingInvite", "关闭阅读评价邀请", "readerFeatures", NO) \
    X(ExcerptWidgetGuide, "ExcerptWidgetGuide", "隐藏书摘小组件提醒", "readerFeatures", NO) \
    X(ContentWidgetGuide, "ContentWidgetGuide", "隐藏内容小组件提醒", "readerFeatures", NO) \
    X(BookstorePublishButton, "BookstorePublishButton", "隐藏书城发帖按钮", "bookstore", NO) \
    X(ListenPendant, "ListenPendant", "净化听读赚钱悬浮挂件", "readerFeatures", NO) \
    X(StoryAds, "StoryAds", "短篇正文广告处理", "ads", NO) \
    X(HotLaunchAds, "HotLaunchAds", "热启动广告专项拦截", "ads", NO) \
    X(AudioAds, "AudioAds", "听书广告专项控制", "ads", NO) \
    X(ChapterTitle, "ChapterTitle", "返回标题固定为章节名称", "readerFeatures", NO)

#define OPTION_KEY(name, suffix, title, category, defaultValue) \
    static NSString *const name##Key = @"FanqieX." suffix ".1";
CLEANUP_OPTIONS(OPTION_KEY)
#undef OPTION_KEY
static NSString *const CommentMaterialModeKey = @"FanqieX.CommentMaterialMode.1";

static BOOL Option(NSString *key, BOOL defaultValue) {
    NSNumber *value = [NSUserDefaults.standardUserDefaults objectForKey:key];
    return [value isKindOfClass:NSNumber.class] ? value.boolValue : defaultValue;
}

static Method HostMethod(Class cls, SEL selector, const char *encoding) {
    Method method = class_getInstanceMethod(cls, selector);
    return method && strcmp(method_getTypeEncoding(method), encoding) == 0 ? method : NULL;
}

static void Install(Class cls, SEL selector, Method method, IMP replacement) {
    if (!method) return;
    FQXInstallOwnedHook(cls, selector, NO, method_getTypeEncoding(method), replacement, NULL);
}

static IMP Replace(NSString *className, SEL selector, const char *encoding, IMP replacement) {
    Class cls = NSClassFromString(className);
    Method method = HostMethod(cls, selector, encoding);
    if (!method) return NULL;
    IMP original = NULL;
    return FQXInstallOwnedHook(cls, selector, NO, encoding, replacement, &original) ? original : NULL;
}

static id HostObject(id owner, SEL selector) {
    if (!HostMethod(object_getClass(owner), selector, "@16@0:8")) return nil;
    return ((id (*)(id, SEL))objc_msgSend)(owner, selector);
}

static void HideWhen(NSString *className, SEL selector, NSString *key, BOOL defaultValue) {
    Class cls = NSClassFromString(className);
    Method method = HostMethod(cls, selector, "B16@0:8");
    if (!method) return;
    BOOL (*original)(id, SEL) = (void *)method_getImplementation(method);
    IMP replacement = imp_implementationWithBlock(^BOOL(id owner) {
        return Option(key, defaultValue) == defaultValue && original(owner, selector);
    });
    Install(cls, selector, method, replacement);
}

static void HideClassWhen(NSString *className, SEL selector, NSString *key, BOOL defaultValue) {
    Class cls = NSClassFromString(className);
    Method method = class_getClassMethod(cls, selector);
    if (!method || strcmp(method_getTypeEncoding(method), "B16@0:8") != 0) return;
    __block IMP original = NULL;
    IMP replacement = imp_implementationWithBlock(^BOOL(id owner) {
        return Option(key, defaultValue) == defaultValue && ((BOOL (*)(id, SEL))original)(owner, selector);
    });
    if (!FQXInstallOwnedHook(cls, selector, YES, "B16@0:8", replacement, &original)) {
        imp_removeBlock(replacement);
    }
}

static BOOL (*NativeHideDoubleColumnRecommend)(id, SEL);
static BOOL HideDoubleColumnRecommend(id owner, SEL cmd) {
    return !Option(ShelfRecommendationsKey, YES) || NativeHideDoubleColumnRecommend(owner, cmd);
}

static void (*NativeDoubleColumnRequestData)(id, SEL);
static void DoubleColumnRequestData(id owner, SEL cmd) {
    if (Option(ShelfRecommendationsKey, YES)) NativeDoubleColumnRequestData(owner, cmd);
}

static BOOL (*NativeImportCell)(id, SEL, NSInteger);
static BOOL ImportCell(id owner, SEL cmd, NSInteger card) {
    return Option(ShelfImportKey, YES) && NativeImportCell(owner, cmd, card);
}

static NSArray *(*NativeImportMenu)(id, SEL);
static NSArray *ImportMenu(id owner, SEL cmd) {
    return Option(ShelfImportKey, YES) ? NativeImportMenu(owner, cmd) : @[];
}

static BOOL IsMotionComicBanner(id banner) {
    id video = HostObject(banner, NSSelectorFromString(@"chaseVideoData"));
    SEL contentType = NSSelectorFromString(@"contentType");
    // This is the host's contentType value used for isMotionComic.
    return HostMethod(object_getClass(video), contentType, "i16@0:8") &&
        ((int (*)(id, SEL))objc_msgSend)(video, contentType) == 1004;
}

static id (*NativeRelatedBanner)(id, SEL);
static id RelatedBanner(id owner, SEL cmd) {
    id banner = NativeRelatedBanner(owner, cmd);
    return !Option(ShelfComicKey, YES) && IsMotionComicBanner(banner) ? nil : banner;
}

static BOOL (*NativeHasUnconsumedBanner)(id, SEL);
static BOOL HasUnconsumedBanner(id owner, SEL cmd) {
    if (!NativeHasUnconsumedBanner(owner, cmd)) return NO;
    if (Option(ShelfComicKey, YES)) return YES;
    return !IsMotionComicBanner(HostObject(owner, NSSelectorFromString(@"unconsumedVideoBanner")));
}

static __weak UIViewController *LastShelf;
static char ShelfColdStartDoneKey;
static char ShelfColdStartTimerKey;
static char ShelfColdStartHiddenKey;

static BOOL ShelfHasLoadedBooks(id controller) {
    id vm = HostObject(controller, NSSelectorFromString(@"viewModel"));
    if (!vm) return YES;
    SEL sel = NSSelectorFromString(@"hasLoadBookShelf");
    if (HostMethod(object_getClass(vm), sel, "B16@0:8")) {
        return ((BOOL (*)(id, SEL))objc_msgSend)(vm, sel);
    }
    Ivar ivar = class_getInstanceVariable(object_getClass(vm), "_hasLoadBookShelf");
    if (ivar) {
        const char *enc = ivar_getTypeEncoding(ivar);
        if (enc && (enc[0] == 'B' || enc[0] == 'c')) {
            return *((const uint8_t *)(__bridge void *)vm + ivar_getOffset(ivar)) != 0;
        }
    }
    return YES;
}

static void ShelfSyncColdStartVisibility(id controller, id collectionViewObj) {
    if (!controller) return;
    UIView *cv = [collectionViewObj isKindOfClass:UIView.class]
        ? (UIView *)collectionViewObj
        : HostObject(controller, NSSelectorFromString(@"collectionView"));
    if (![cv isKindOfClass:UIView.class]) return;

    BOOL done = [objc_getAssociatedObject(controller, &ShelfColdStartDoneKey) boolValue];
    BOOL loaded = done || ShelfHasLoadedBooks(controller);
    if (!loaded) {
        if (cv.alpha > 0.001) {
            objc_setAssociatedObject(cv, &ShelfColdStartHiddenKey, @YES, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
            cv.alpha = 0.0;
        }
        if (![objc_getAssociatedObject(controller, &ShelfColdStartTimerKey) boolValue]) {
            objc_setAssociatedObject(controller, &ShelfColdStartTimerKey, @YES, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
            __weak id weakController = controller;
            __weak UIView *weakCV = cv;
            dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.75 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                id strongController = weakController;
                UIView *strongCV = weakCV;
                if (strongController) {
                    objc_setAssociatedObject(strongController, &ShelfColdStartDoneKey, @YES, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
                }
                if (strongCV && [objc_getAssociatedObject(strongCV, &ShelfColdStartHiddenKey) boolValue]) {
                    objc_setAssociatedObject(strongCV, &ShelfColdStartHiddenKey, nil, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
                    strongCV.alpha = 1.0;
                }
            });
        }
        return;
    }

    if (!done) {
        objc_setAssociatedObject(controller, &ShelfColdStartDoneKey, @YES, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
    }
    if ([objc_getAssociatedObject(cv, &ShelfColdStartHiddenKey) boolValue]) {
        objc_setAssociatedObject(cv, &ShelfColdStartHiddenKey, nil, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
        cv.alpha = 1.0;
    }
}

static void (*NativeShelfAppeared)(id, SEL, BOOL);
static void ShelfAppeared(id owner, SEL cmd, BOOL animated) {
    NativeShelfAppeared(owner, cmd, animated);
    LastShelf = owner;
    ShelfSyncColdStartVisibility(owner, nil);
}

static char ShelfRecSectionsKey;
static char ShelfRecTypesKey;
static char ShelfRecBookSectionKey;
static char ShelfRecReloadPendingKey;
static char ShelfRecHiddenViewsKey;
static char ShelfRecHiddenFlagKey;

static BOOL ShelfRecStringContainsAny(NSString *haystack, NSArray<NSString *> *needles) {
    if (!haystack.length) return NO;
    for (NSString *needle in needles) {
        if ([haystack rangeOfString:needle].location != NSNotFound) return YES;
    }
    return NO;
}

static BOOL ShelfRecIsProtectedName(NSString *lowerName) {
    return ShelfRecStringContainsAny(lowerName, @[
        @"function", @"filter", @"group", @"localbook", @"empty", @"history", @"search", @"edit"
    ]);
}

static BOOL ShelfRecIsRecommendName(NSString *lowerName) {
    if (!lowerName.length) return NO;
    BOOL rec = ShelfRecStringContainsAny(lowerName, @[
        @"recommend", @"rcmd", @"guess", @"waterfall", @"bookstore", @"relatedbook", @"discover", @"bottomfeed", @"doublecolumn"
    ]);
    return rec && !ShelfRecIsProtectedName(lowerName);
}

static BOOL ShelfRecViewHasRecommendText(UIView *view, NSInteger depth) {
    if (![view isKindOfClass:UIView.class] || depth > 3) return NO;
    if ([view isKindOfClass:UILabel.class]) {
        NSString *text = ((UILabel *)view).text ?: @"";
        if (ShelfRecStringContainsAny(text, @[@"为你推荐", @"猜你喜欢", @"书架推荐", @"更多推荐", @"好书推荐"]))
            return YES;
    }
    for (UIView *child in view.subviews) {
        if (ShelfRecViewHasRecommendText(child, depth + 1)) return YES;
    }
    return NO;
}

static NSInteger ShelfRecSectionType(id controller, NSInteger section) {
    id vm = HostObject(controller, NSSelectorFromString(@"viewModel"));
    SEL sel = NSSelectorFromString(@"sectionTypeAtIndex:");
    if (!vm || !HostMethod(object_getClass(vm), sel, "q24@0:8q16")) return -1;
    return ((NSInteger (*)(id, SEL, NSInteger))objc_msgSend)(vm, sel, section);
}

static BOOL ShelfRecIsSectionHidden(id controller, NSInteger section) {
    if (!controller || Option(ShelfRecommendationsKey, YES)) return NO;
    NSInteger stype = ShelfRecSectionType(controller, section);
    if (stype == 1 || stype == 4) return NO;
    NSMutableSet *sections = objc_getAssociatedObject(controller, &ShelfRecSectionsKey);
    if ([sections containsObject:@(section)]) return YES;
    NSMutableSet *types = objc_getAssociatedObject(controller, &ShelfRecTypesKey);
    return stype >= 0 && [types containsObject:@(stype)];
}

static void ShelfRecMarkSection(id controller, NSInteger section, NSInteger stype) {
    if (!controller || stype == 1 || stype == 4) return;
    NSMutableSet *sections = objc_getAssociatedObject(controller, &ShelfRecSectionsKey);
    if (!sections) {
        sections = [NSMutableSet set];
        objc_setAssociatedObject(controller, &ShelfRecSectionsKey, sections, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
    }
    [sections addObject:@(section)];
    if (stype >= 0) {
        NSMutableSet *types = objc_getAssociatedObject(controller, &ShelfRecTypesKey);
        if (!types) {
            types = [NSMutableSet set];
            objc_setAssociatedObject(controller, &ShelfRecTypesKey, types, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
        }
        [types addObject:@(stype)];
    }
}

static void ShelfRecHideView(id controller, id viewObj, BOOL hide) {
    if (![viewObj isKindOfClass:UIView.class]) return;
    UIView *view = (UIView *)viewObj;
    if (hide) {
        if (!view.hidden) {
            objc_setAssociatedObject(view, &ShelfRecHiddenFlagKey, @YES, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
            view.hidden = YES;
        }
        if (controller) {
            NSHashTable *views = objc_getAssociatedObject(controller, &ShelfRecHiddenViewsKey);
            if (!views) {
                views = [NSHashTable weakObjectsHashTable];
                objc_setAssociatedObject(controller, &ShelfRecHiddenViewsKey, views, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
            }
            [views addObject:view];
        }
    } else if (objc_getAssociatedObject(view, &ShelfRecHiddenFlagKey)) {
        if (view.hidden) view.hidden = NO;
        objc_setAssociatedObject(view, &ShelfRecHiddenFlagKey, nil, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
    }
}

static void ShelfRecRestoreController(id controller) {
    if (!controller) return;
    objc_setAssociatedObject(controller, &ShelfRecSectionsKey, nil, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
    objc_setAssociatedObject(controller, &ShelfRecTypesKey, nil, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
    objc_setAssociatedObject(controller, &ShelfRecReloadPendingKey, nil, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
    NSHashTable *views = objc_getAssociatedObject(controller, &ShelfRecHiddenViewsKey);
    for (UIView *view in [views allObjects]) ShelfRecHideView(controller, view, NO);
    objc_setAssociatedObject(controller, &ShelfRecHiddenViewsKey, nil, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

static void ShelfRecScheduleReload(id controller, id collectionView) {
    if (![collectionView isKindOfClass:UICollectionView.class]) return;
    if ([objc_getAssociatedObject(controller, &ShelfRecReloadPendingKey) boolValue]) return;
    objc_setAssociatedObject(controller, &ShelfRecReloadPendingKey, @YES, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
    __weak id weakController = controller;
    __weak UICollectionView *weakCV = (UICollectionView *)collectionView;
    dispatch_async(dispatch_get_main_queue(), ^{
        id strongController = weakController;
        UICollectionView *strongCV = weakCV;
        if (strongController) {
            objc_setAssociatedObject(strongController, &ShelfRecReloadPendingKey, nil, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
        }
        if (strongCV && strongController && !Option(ShelfRecommendationsKey, YES)) {
            [strongCV reloadData];
        }
    });
}

static NSInteger (*NativeShelfNumberOfSections)(id, SEL, id);
static NSInteger ShelfRecNumberOfSections(id self, SEL cmd, id collectionView) {
    LastShelf = self;
    ShelfSyncColdStartVisibility(self, collectionView);
    objc_setAssociatedObject(self, &ShelfRecReloadPendingKey, nil, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
    NSInteger count = NativeShelfNumberOfSections(self, cmd, collectionView);
    NSInteger bookSection = -1;
    for (NSInteger s = 0; s < count; ++s) {
        if (ShelfRecSectionType(self, s) == 4) bookSection = s;
    }
    objc_setAssociatedObject(self, &ShelfRecBookSectionKey,
                             bookSection >= 0 ? @(bookSection) : nil,
                             OBJC_ASSOCIATION_RETAIN_NONATOMIC);
    if (Option(ShelfRecommendationsKey, YES)) ShelfRecRestoreController(self);
    return count;
}

static NSInteger (*NativeShelfNumberOfItems)(id, SEL, id, NSInteger);
static NSInteger ShelfRecNumberOfItems(id self, SEL cmd, id collectionView, NSInteger section) {
    LastShelf = self;
    if (ShelfRecIsSectionHidden(self, section)) return 0;
    return NativeShelfNumberOfItems(self, cmd, collectionView, section);
}

static id (*NativeShelfCellForItem)(id, SEL, id, NSIndexPath *);
static id ShelfRecCellForItem(id self, SEL cmd, id collectionView, NSIndexPath *indexPath) {
    LastShelf = self;
    ShelfSyncColdStartVisibility(self, collectionView);
    id cell = NativeShelfCellForItem(self, cmd, collectionView, indexPath);
    if (Option(ShelfRecommendationsKey, YES)) {
        ShelfRecHideView(self, cell, NO);
        return cell;
    }
    NSInteger section = indexPath.section;
    NSInteger stype = ShelfRecSectionType(self, section);
    NSString *clsName = NSStringFromClass([cell class]).lowercaseString ?: @"";
    id model = HostObject(cell, NSSelectorFromString(@"cellModel")) ?: HostObject(cell, NSSelectorFromString(@"model"));
    NSString *modelName = model ? (NSStringFromClass([model class]).lowercaseString ?: @"") : @"";
    Class baseBookCls = NSClassFromString(@"SSBookShelfBaseCell");
    Class funcCls = NSClassFromString(@"SSBookShelfFunctionCell");
    BOOL isBookCell = (baseBookCls && [cell isKindOfClass:baseBookCls]) || stype == 4;
    BOOL isFuncCell = (funcCls && [cell isKindOfClass:funcCls]) || stype == 1;
    if (isBookCell) {
        NSNumber *prev = objc_getAssociatedObject(self, &ShelfRecBookSectionKey);
        if (!prev || section > prev.integerValue) {
            objc_setAssociatedObject(self, &ShelfRecBookSectionKey, @(section), OBJC_ASSOCIATION_RETAIN_NONATOMIC);
        }
    }
    BOOL recommend = ShelfRecIsRecommendName(clsName) || ShelfRecIsRecommendName(modelName);
    if (!recommend && stype != 1 && stype != 4) {
        NSNumber *bookSec = objc_getAssociatedObject(self, &ShelfRecBookSectionKey);
        if (bookSec && section > bookSec.integerValue && !isBookCell && !isFuncCell &&
            !ShelfRecIsProtectedName(clsName) && !ShelfRecIsProtectedName(modelName)) {
            recommend = YES;
        }
    }
    if (recommend) {
        BOOL alreadyHidden = ShelfRecIsSectionHidden(self, section);
        ShelfRecMarkSection(self, section, stype);
        ShelfRecHideView(self, cell, YES);
        if (!alreadyHidden) ShelfRecScheduleReload(self, collectionView);
    } else {
        ShelfRecHideView(self, cell, NO);
    }
    return cell;
}

static id (*NativeShelfSupplementaryView)(id, SEL, id, id, NSIndexPath *);
static id ShelfRecSupplementaryView(id self, SEL cmd, id collectionView, id kind, NSIndexPath *indexPath) {
    id view = NativeShelfSupplementaryView(self, cmd, collectionView, kind, indexPath);
    if (Option(ShelfRecommendationsKey, YES)) {
        ShelfRecHideView(self, view, NO);
        return view;
    }
    NSInteger section = indexPath.section;
    NSInteger stype = ShelfRecSectionType(self, section);
    NSString *clsName = NSStringFromClass([view class]).lowercaseString ?: @"";
    BOOL alreadyHidden = ShelfRecIsSectionHidden(self, section);
    BOOL recommend = alreadyHidden || ShelfRecIsRecommendName(clsName) ||
        ShelfRecViewHasRecommendText(view, 0);
    if (!recommend && stype != 1 && stype != 4) {
        NSNumber *bookSec = objc_getAssociatedObject(self, &ShelfRecBookSectionKey);
        if (bookSec && section > bookSec.integerValue && !ShelfRecIsProtectedName(clsName)) {
            recommend = YES;
        }
    }
    if (recommend) {
        if (stype != 1 && stype != 4) ShelfRecMarkSection(self, section, stype);
        ShelfRecHideView(self, view, YES);
        if (!alreadyHidden) ShelfRecScheduleReload(self, collectionView);
    } else {
        ShelfRecHideView(self, view, NO);
    }
    return view;
}

static CGSize (*NativeShelfSizeForItem)(id, SEL, id, id, NSIndexPath *);
static CGSize ShelfRecSizeForItem(id self, SEL cmd, id collectionView, id layout, NSIndexPath *indexPath) {
    if (indexPath && ShelfRecIsSectionHidden(self, indexPath.section)) return CGSizeZero;
    return NativeShelfSizeForItem(self, cmd, collectionView, layout, indexPath);
}

static CGSize (*NativeShelfHeaderSize)(id, SEL, id, id, NSInteger);
static CGSize ShelfRecHeaderSize(id self, SEL cmd, id collectionView, id layout, NSInteger section) {
    if (ShelfRecIsSectionHidden(self, section)) return CGSizeZero;
    return NativeShelfHeaderSize(self, cmd, collectionView, layout, section);
}

static CGSize (*NativeShelfFooterSize)(id, SEL, id, id, NSInteger);
static CGSize ShelfRecFooterSize(id self, SEL cmd, id collectionView, id layout, NSInteger section) {
    if (ShelfRecIsSectionHidden(self, section)) return CGSizeZero;
    return NativeShelfFooterSize(self, cmd, collectionView, layout, section);
}

static UIEdgeInsets (*NativeShelfInsetForSection)(id, SEL, id, id, NSInteger);
static UIEdgeInsets ShelfRecInsetForSection(id self, SEL cmd, id collectionView, id layout, NSInteger section) {
    if (ShelfRecIsSectionHidden(self, section)) return UIEdgeInsetsZero;
    return NativeShelfInsetForSection(self, cmd, collectionView, layout, section);
}

static char MineOriginalHidden;
static Ivar MinePublishButton;
static __weak UIViewController *LastMine;
static void (*NativeUpdatePublish)(id, SEL);
static void UpdatePublish(id owner, SEL cmd) {
    // The public getter lazily creates this button. Observe only the native
    // instance that updatePublishBtnIfNeed decided to create.
    UIView *button = object_getIvar(owner, MinePublishButton);
    NSNumber *wasHidden = objc_getAssociatedObject(button, &MineOriginalHidden);
    if (wasHidden) button.hidden = wasHidden.boolValue;
    NativeUpdatePublish(owner, cmd);
    LastMine = owner;
    button = object_getIvar(owner, MinePublishButton);
    if (!button) return;
    BOOL hide = !Option(MinePublishKey, YES);
    objc_setAssociatedObject(button, &MineOriginalHidden, hide ? @(button.hidden) : nil, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
    if (hide) button.hidden = YES;
}

static char SpeechRequestedHidden;
static __weak UIView *LastSpeechButton;
static void (*NativeSpeechHidden)(id, SEL, BOOL);
static void SpeechHidden(id owner, SEL cmd, BOOL hidden) {
    objc_setAssociatedObject(owner, &SpeechRequestedHidden, @(hidden), OBJC_ASSOCIATION_RETAIN_NONATOMIC);
    LastSpeechButton = owner;
    NativeSpeechHidden(owner, cmd, hidden || !Option(SpeechFloatKey, YES));
}

typedef void (^PresentationCompletion)(NSUInteger);
static void (*NativePresentation)(id, SEL, id, id, PresentationCompletion);
static void PresentNotification(id owner, SEL cmd, id center, id notification, PresentationCompletion finish) {
    BOOL foreground = Option(ForegroundKey, YES);
    BOOL badge = Option(BadgeKey, YES);
    if ((foreground && badge) || !finish) {
        NativePresentation(owner, cmd, center, notification, finish);
        return;
    }
    // UNNotificationPresentationOptionBadge is the least significant bit.
    NativePresentation(owner, cmd, center, notification, ^(NSUInteger show) {
        NSUInteger badgeBit = 1;
        NSUInteger options = foreground ? show : show & badgeBit;
        finish(badge ? options : options & ~badgeBit);
    });
}

static void (*NativeBadge)(id, SEL, NSInteger);
static void SetBadge(id owner, SEL cmd, NSInteger count) {
    NativeBadge(owner, cmd, Option(BadgeKey, YES) ? count : 0);
}

static void (*NativeNotificationBadge)(id, SEL, NSInteger, void (^)(NSError *));
static void SetNotificationBadge(id owner, SEL cmd, NSInteger count, void (^completion)(NSError *)) {
    NativeNotificationBadge(owner, cmd, Option(BadgeKey, YES) ? count : 0, completion);
}

static id AutoReadUI(id manager) {
    id ui = HostObject(manager, NSSelectorFromString(@"UIMgr"));
    Class cls = object_getClass(ui);
    if (!HostMethod(cls, NSSelectorFromString(@"isToolViewShow"), "B16@0:8") ||
        !HostMethod(cls, NSSelectorFromString(@"enterAutoReadMode"), "v16@0:8") ||
        !HostMethod(cls, NSSelectorFromString(@"exitAutoReadMode:"), "v20@0:8i16")) return nil;
    return ui;
}

static BOOL (*NativeShouldRecognize)(id, SEL);
static BOOL ShouldRecognize(id manager, SEL cmd) {
    if (NativeShouldRecognize(manager, cmd)) return YES;
    if (!Option(DoubleTapKey, NO)) return NO;
    id ui = AutoReadUI(manager);
    SEL isToolViewShow = NSSelectorFromString(@"isToolViewShow");
    return ui && !((BOOL (*)(id, SEL))objc_msgSend)(ui, isToolViewShow);
}

static void (*NativeDoubleTap)(id, SEL, id, id);
static void ToggleAutoRead(id manager, SEL cmd, id view, id event) {
    id ui = Option(DoubleTapKey, NO) ? AutoReadUI(manager) : nil;
    id config = HostObject(ui, NSSelectorFromString(@"config"));
    SEL active = NSSelectorFromString(@"isAutoRead");
    if (!ui || !HostMethod(object_getClass(config), active, "B16@0:8")) {
        NativeDoubleTap(manager, cmd, view, event);
        return;
    }
    if (((BOOL (*)(id, SEL))objc_msgSend)(ui, NSSelectorFromString(@"isToolViewShow"))) return;
    if (((BOOL (*)(id, SEL))objc_msgSend)(config, active)) {
        ((void (*)(id, SEL, int))objc_msgSend)(ui, NSSelectorFromString(@"exitAutoReadMode:"), -102);
    } else {
        // The native entry reads both existing settings views. They may not
        // have been constructed when the gesture starts the first session.
        for (NSString *name in @[@"createSettingViewIfNeeded", @"createAutoReadRateViewIfNeeded"]) {
            SEL initialize = NSSelectorFromString(name);
            if (HostMethod(object_getClass(ui), initialize, "v16@0:8")) {
                ((void (*)(id, SEL))objc_msgSend)(ui, initialize);
            }
        }
        ((void (*)(id, SEL))objc_msgSend)(ui, NSSelectorFromString(@"enterAutoReadMode"));
    }
}

static BOOL (*NativePreSave)(id, SEL, id);
static BOOL CanShowPreSave(id owner, SEL cmd, id panel) {
    return !Option(DurationLimitKey, NO) && NativePreSave(owner, cmd, panel);
}

static void (*NativePauseForTime)(id, SEL);
static void PauseForTime(id owner, SEL cmd) {
    if (!Option(DurationLimitKey, NO)) NativePauseForTime(owner, cmd);
}

static id CleanupIvarObject(id target, const char *ivarName) {
    if (!target || !ivarName) return nil;
    Ivar ivar = class_getInstanceVariable(object_getClass(target), ivarName);
    if (!ivar) return nil;
    const char *enc = ivar_getTypeEncoding(ivar);
    return (enc && enc[0] == '@') ? object_getIvar(target, ivar) : nil;
}

static char MineGlassPreferencesKey;
static char MineGlassPositionPendingKey;
static NSArray *MineGlassPreferences(void) {
    NSUserDefaults *defaults = NSUserDefaults.standardUserDefaults;
    NSMutableArray *values = [NSMutableArray array];
    for (NSString *key in @[@"FanqieAdBlock.GlassDisabled.1", @"FanqieX.BottomIconsOnly.1",
                            @"FanqieX.BottomLengthScale.1", @"FanqieX.BottomHeightScale.1",
                            @"FanqieX.BottomButtonWidthScale.1", @"FanqieX.BottomIconPointSize.1",
                            @"FanqieX.MineQuickIconsOnly.1", MineScanButtonKey, MineSearchBarKey, MineNightButtonKey]) {
        [values addObject:[defaults objectForKey:key] ?: NSNull.null];
    }
    return values;
}

static void RestoreMinePosition(UIViewController *controller) {
    UIScrollView *list = HostObject(controller, NSSelectorFromString(@"collectionView"));
    if (![list isKindOfClass:UIScrollView.class] || list.dragging || list.decelerating) return;
    [controller.view layoutIfNeeded];
    CGPoint top = list.contentOffset;
    top.y = -list.adjustedContentInset.top;
    if (!CGPointEqualToPoint(list.contentOffset, top)) [list setContentOffset:top animated:NO];
}

static void (*NativeMineWillAppear)(id, SEL, BOOL);
static void MineWillAppear(id owner, SEL cmd, BOOL animated) {
    if (NativeMineWillAppear) NativeMineWillAppear(owner, cmd, animated);
    LastMine = owner;
    UIView *bar = HostObject(owner, NSSelectorFromString(@"myUserBar")) ?: CleanupIvarObject(owner, "_myUserBar");
    if ([bar isKindOfClass:UIView.class]) {
        [bar setNeedsLayout];
    }
    NSArray *current = MineGlassPreferences();
    NSArray *previous = objc_getAssociatedObject(owner, &MineGlassPreferencesKey);
    objc_setAssociatedObject(owner, &MineGlassPreferencesKey, current, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
    if (previous && ![previous isEqualToArray:current]) {
        objc_setAssociatedObject(owner, &MineGlassPositionPendingKey, @YES, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
        RestoreMinePosition(owner);
    }
}

static void (*NativeMineDidAppear)(id, SEL, BOOL);
static void MineDidAppear(id owner, SEL cmd, BOOL animated) {
    NativeMineDidAppear(owner, cmd, animated);
    if (objc_getAssociatedObject(owner, &MineGlassPositionPendingKey)) {
        objc_setAssociatedObject(owner, &MineGlassPositionPendingKey, nil, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
        RestoreMinePosition(owner);
    }
}

static char DramaActionRequestedHiddenKey;
static NSMutableDictionary<NSString *, NSHashTable<UIView *> *> *DramaActionOwners;

static void InstallDramaActionVisibility(NSString *className, NSString *key) {
    Class cls = NSClassFromString(className);
    SEL hidden = @selector(setHidden:);
    SEL refresh = NSSelectorFromString(@"refreshSubviews");
    if (!HostMethod(cls, hidden, "v20@0:8B16") || !HostMethod(cls, refresh, "v16@0:8")) return;
    if (!DramaActionOwners) DramaActionOwners = [NSMutableDictionary dictionary];
    NSHashTable<UIView *> *owners = DramaActionOwners[key];
    if (!owners) DramaActionOwners[key] = owners = [NSHashTable weakObjectsHashTable];

    __block void (*originalHidden)(id, SEL, BOOL);
    IMP hide = imp_implementationWithBlock(^(UIView *view, BOOL requested) {
        [owners addObject:view];
        objc_setAssociatedObject(view, &DramaActionRequestedHiddenKey, @(requested), OBJC_ASSOCIATION_RETAIN_NONATOMIC);
        originalHidden(view, hidden, requested || !Option(key, YES));
    });
    if (!FQXInstallOwnedHook(cls, hidden, NO, "v20@0:8B16", hide, (IMP *)&originalHidden)) {
        imp_removeBlock(hide);
        return;
    }
    __block void (*originalRefresh)(id, SEL);
    IMP refreshView = imp_implementationWithBlock(^(UIView *view) {
        originalRefresh(view, refresh);
        NSNumber *requested = objc_getAssociatedObject(view, &DramaActionRequestedHiddenKey);
        [view setHidden:requested ? requested.boolValue : view.hidden];
    });
    if (!FQXInstallOwnedHook(cls, refresh, NO, "v16@0:8", refreshView, (IMP *)&originalRefresh))
        imp_removeBlock(refreshView);
}

static void RefreshMineViewsInSubtree(UIView *view) {
    if (![view isKindOfClass:UIView.class]) return;
    Class barCls = NSClassFromString(@"SSMyUserBar");
    if (barCls && [view isKindOfClass:barCls]) {
        [view setNeedsLayout];
        [view layoutIfNeeded];
    }
    for (UIView *sub in view.subviews) {
        RefreshMineViewsInSubtree(sub);
    }
}

static NSHashTable<UIViewController *> *AudioPlayControllers(void) {
    static NSHashTable<UIViewController *> *table;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        table = [NSHashTable weakObjectsHashTable];
    });
    return table;
}

static void ApplyAudioRecommendVisibility(UIViewController *vc) {
    if (![vc isKindOfClass:UIViewController.class]) return;
    [AudioPlayControllers() addObject:vc];
    BOOL show = Option(AudioRecommendationsKey, YES);
    const char *recIvars[] = {
        "_unlimitedView", "_recommendView", "_unlimitedClickTopView", "_refreshFooter", "_comicsBooksCell"
    };
    if (show) {
        if (objc_getAssociatedObject(vc, &ShelfRecHiddenViewsKey)) {
            ShelfRecRestoreController(vc);
        }
        return;
    }
    for (size_t i = 0; i < sizeof(recIvars) / sizeof(recIvars[0]); ++i) {
        UIView *v = CleanupIvarObject(vc, recIvars[i]);
        if (v) ShelfRecHideView(vc, v, YES);
    }
    const char *scrollIvars[] = {"_contentScrollView", "_nestedContainerScrollView"};
    const char *anchorIvars[] = {
        "_toneView611", "_listenReadButtonBelowView", "_listenReadButtonWithPreUnlockView", "_controlView"
    };
    for (size_t s = 0; s < sizeof(scrollIvars) / sizeof(scrollIvars[0]); ++s) {
        UIScrollView *sv = CleanupIvarObject(vc, scrollIvars[s]);
        if (![sv isKindOfClass:UIScrollView.class] || CGRectGetHeight(sv.bounds) <= 1.0) continue;
        CGFloat maxBottom = 0.0;
        for (size_t a = 0; a < sizeof(anchorIvars) / sizeof(anchorIvars[0]); ++a) {
            UIView *anchor = CleanupIvarObject(vc, anchorIvars[a]);
            if (![anchor isKindOfClass:UIView.class] || anchor.hidden || !anchor.superview) continue;
            if (![anchor isDescendantOfView:sv]) continue;
            CGRect r = [anchor convertRect:anchor.bounds toView:sv];
            if (CGRectGetMaxY(r) > maxBottom) maxBottom = CGRectGetMaxY(r);
        }
        if (maxBottom > 40.0) {
            CGFloat clampedH = MAX(CGRectGetHeight(sv.bounds), ceil(maxBottom + 20.0));
            if (sv.contentSize.height > clampedH + 1.0) {
                sv.contentSize = CGSizeMake(sv.contentSize.width, clampedH);
                CGFloat maxOffsetY = MAX(-sv.adjustedContentInset.top, clampedH - CGRectGetHeight(sv.bounds));
                if (sv.contentOffset.y > maxOffsetY) {
                    [sv setContentOffset:CGPointMake(sv.contentOffset.x, maxOffsetY) animated:NO];
                }
            }
        }
    }
}

static void (*NativeAudioLoadUnlimited)(id, SEL);
static void AudioLoadUnlimited(id self, SEL cmd) {
    [AudioPlayControllers() addObject:self];
    if (Option(AudioRecommendationsKey, YES)) NativeAudioLoadUnlimited(self, cmd);
    else ApplyAudioRecommendVisibility(self);
}

static void (*NativeAudioPreloadUnlimited)(id, SEL);
static void AudioPreloadUnlimited(id self, SEL cmd) {
    [AudioPlayControllers() addObject:self];
    if (Option(AudioRecommendationsKey, YES)) NativeAudioPreloadUnlimited(self, cmd);
}

static void (*NativeAudioLoadRecommendBook)(id, SEL);
static void AudioLoadRecommendBook(id self, SEL cmd) {
    [AudioPlayControllers() addObject:self];
    if (Option(AudioRecommendationsKey, YES)) NativeAudioLoadRecommendBook(self, cmd);
    else ApplyAudioRecommendVisibility(self);
}

static void (*NativeAudioLoadComics)(id, SEL);
static void AudioLoadComics(id self, SEL cmd) {
    [AudioPlayControllers() addObject:self];
    if (Option(AudioRecommendationsKey, YES)) NativeAudioLoadComics(self, cmd);
    else ApplyAudioRecommendVisibility(self);
}

static void (*NativeAudioReloadRecommendForce)(id, SEL, BOOL);
static void AudioReloadRecommendForce(id self, SEL cmd, BOOL force) {
    [AudioPlayControllers() addObject:self];
    if (Option(AudioRecommendationsKey, YES)) NativeAudioReloadRecommendForce(self, cmd, force);
    ApplyAudioRecommendVisibility(self);
}

static void (*NativeAudioReloadUnlimitedView)(id, SEL);
static void AudioReloadUnlimitedView(id self, SEL cmd) {
    [AudioPlayControllers() addObject:self];
    if (Option(AudioRecommendationsKey, YES)) NativeAudioReloadUnlimitedView(self, cmd);
    ApplyAudioRecommendVisibility(self);
}

static void (*NativeAudioLayoutContent)(id, SEL);
static void AudioLayoutContent(id self, SEL cmd) {
    NativeAudioLayoutContent(self, cmd);
    ApplyAudioRecommendVisibility(self);
}

static void (*NativeAudioWillAppear)(id, SEL, BOOL);
static void AudioWillAppear(id self, SEL cmd, BOOL animated) {
    NativeAudioWillAppear(self, cmd, animated);
    ApplyAudioRecommendVisibility(self);
}

static NSDictionary *FQXPurgeHistoricalResidueImpl(BOOL aggressiveLogs) {
    NSUInteger removedKeys = 0;
    __block NSUInteger removedFiles = 0;
    __block unsigned long long freedBytes = 0;

    NSUserDefaults *ud = NSUserDefaults.standardUserDefaults;
    NSString *legacyFrostedKey = @"FanqieX.CommentGlassFrosted.1";
    if (![ud objectForKey:CommentMaterialModeKey] && [ud objectForKey:legacyFrostedKey]) {
        BOOL wasFrosted = [ud boolForKey:legacyFrostedKey];
        [ud setInteger:(wasFrosted ? 2 : 0) forKey:CommentMaterialModeKey];
    }
    NSDictionary<NSString *, id> *dict = ud.dictionaryRepresentation;
    NSSet<NSString *> *retiredExact = [NSSet setWithObjects:
        legacyFrostedKey,
        @"FanqieX.LocalRewardTest.1",
        @"FanqieAdBlock.PopupShown",
        @"FanqieAdBlock.Version",
        nil];
    for (NSString *key in dict.allKeys) {
        BOOL obsolete = [retiredExact containsObject:key];
        if (!obsolete && [key hasPrefix:@"FanqieAdBlock."] &&
            ![key isEqualToString:@"FanqieAdBlock.Options.1"] &&
            ![key isEqualToString:@"FanqieAdBlock.GlassDisabled.1"]) {
            obsolete = YES;
        }
        if (obsolete) {
            [ud removeObjectForKey:key];
            removedKeys += 1;
        }
    }

    NSFileManager *fm = NSFileManager.defaultManager;
    void (^sweepFolder)(NSURL *, BOOL (^)(NSURL *, unsigned long long)) =
        ^(NSURL *folder, BOOL (^predicate)(NSURL *, unsigned long long)) {
        if (!folder) return;
        NSArray<NSURL *> *items = [fm contentsOfDirectoryAtURL:folder
                                    includingPropertiesForKeys:@[NSURLFileSizeKey, NSURLIsDirectoryKey]
                                                       options:0
                                                         error:NULL];
        for (NSURL *item in items) {
            NSNumber *sizeNum = nil;
            [item getResourceValue:&sizeNum forKey:NSURLFileSizeKey error:NULL];
            unsigned long long sz = sizeNum ? sizeNum.unsignedLongLongValue : 0;
            if (predicate(item, sz)) {
                if ([fm removeItemAtURL:item error:NULL]) {
                    removedFiles += 1;
                    freedBytes += sz;
                }
            }
        }
    };

    NSURL *appSupport = [fm URLsForDirectory:NSApplicationSupportDirectory inDomains:NSUserDomainMask].firstObject;
    if (appSupport) {
        NSURL *exportsDir = [appSupport URLByAppendingPathComponent:@"FanqieXDiagnosticsExports" isDirectory:YES];
        sweepFolder(exportsDir, ^BOOL(NSURL *u, unsigned long long sz) {
            (void)u; (void)sz;
            return YES;
        });
        NSURL *diagDir = [appSupport URLByAppendingPathComponent:@"FanqieAdBlockDiagnostics" isDirectory:YES];
        unsigned long long maxBytes = aggressiveLogs ? (256ULL * 1024ULL) : (768ULL * 1024ULL);
        sweepFolder(diagDir, ^BOOL(NSURL *u, unsigned long long sz) {
            NSString *name = u.lastPathComponent ?: @"";
            if ([name hasSuffix:@".tmp"] || [name hasSuffix:@".old"] || [name hasSuffix:@".bak"]) return YES;
            return sz > maxBytes;
        });
    }

    NSURL *cachesDir = [fm URLsForDirectory:NSCachesDirectory inDomains:NSUserDomainMask].firstObject;
    sweepFolder(cachesDir, ^BOOL(NSURL *u, unsigned long long sz) {
        (void)sz;
        NSString *name = u.lastPathComponent ?: @"";
        return [name hasPrefix:@"FanqieAdBlock"] || [name hasPrefix:@"FanqieX"];
    });

    NSURL *tmpDir = [NSURL fileURLWithPath:NSTemporaryDirectory() isDirectory:YES];
    sweepFolder(tmpDir, ^BOOL(NSURL *u, unsigned long long sz) {
        (void)sz;
        NSString *name = u.lastPathComponent ?: @"";
        return [name hasPrefix:@"FanqieX"] || [name hasPrefix:@"FQX"] ||
               [name hasPrefix:@"FanqieAdBlock"] || [name hasPrefix:@"BookExport"] ||
               [name hasSuffix:@".fqcfg"];
    });

    dispatch_async(dispatch_get_main_queue(), ^{
        Class dockMotion = NSClassFromString(@"FQXDockMotion");
        SEL compactSel = NSSelectorFromString(@"compactMemory");
        if ([dockMotion respondsToSelector:compactSel]) {
            ((void (*)(id, SEL))objc_msgSend)(dockMotion, compactSel);
        }
    });

    return @{
        @"removedKeys": @(removedKeys),
        @"removedFiles": @(removedFiles),
        @"freedBytes": @(freedBytes),
    };
}

@interface FQXCleanup : NSObject
+ (void)install;
+ (NSArray<NSDictionary *> *)optionRows;
+ (void)refreshForKey:(NSString *)key;
+ (NSDictionary *)purgeHistoricalResidue;
+ (void)presentFromController:(UIViewController *)owner;
@end

@implementation FQXCleanup
+ (NSDictionary *)purgeHistoricalResidue {
    return FQXPurgeHistoricalResidueImpl(YES);
}

+ (void)presentFromController:(UIViewController *)owner {
    if (!owner) return;
    NSDictionary *res = [self purgeHistoricalResidue];
    NSUInteger keys = [res[@"removedKeys"] unsignedIntegerValue];
    NSUInteger files = [res[@"removedFiles"] unsignedIntegerValue];
    double kb = [res[@"freedBytes"] doubleValue] / 1024.0;
    NSString *sizeText = kb >= 1024.0
        ? [NSString stringWithFormat:@"%.2f MB", kb / 1024.0]
        : [NSString stringWithFormat:@"%.1f KB", kb];
    NSString *msg = [NSString stringWithFormat:
        @"已清理旧版残留配置 %lu 项、历史缓存与诊断残留文件 %lu 个（释放 %@），并已回收后台离屏玻璃图层内存。",
        (unsigned long)keys, (unsigned long)files, sizeText];
    UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"历史残留清理完成"
                                                                   message:msg
                                                            preferredStyle:UIAlertControllerStyleAlert];
    [alert addAction:[UIAlertAction actionWithTitle:@"好" style:UIAlertActionStyleDefault handler:nil]];
    [owner presentViewController:alert animated:YES completion:nil];
}
+ (NSArray<NSDictionary *> *)optionRows {
#define OPTION_ROW(name, suffix, titleValue, categoryValue, defaultValue) \
    @{@"title": @titleValue, @"key": name##Key, @"category": @categoryValue, @"default": @(defaultValue)},
    return @[CLEANUP_OPTIONS(OPTION_ROW)];
#undef OPTION_ROW
}

+ (void)install {
    static dispatch_once_t once;
    dispatch_once(&once, ^{
#define SHOW_RULE(cls, selector, option) HideWhen(@cls, NSSelectorFromString(@selector), option##Key, YES)
        SHOW_RULE("SSReaderChapterEndAuthorSpeakInsertObject", "shouldInsert", AuthorWords);
        SHOW_RULE("SSReaderChapterEndContentModel", "showAuthorTalk", AuthorWords);
        SHOW_RULE("SSReaderChapterEndCombineViewModel", "showDiscussion", ChapterDiscussion);
        SHOW_RULE("SSReaderChapterEndCombineViewModel", "layoutShowDiscussion", ChapterDiscussion);
        SHOW_RULE("SSReaderChapterEndForumInsertObject", "shouldInsert", ChapterCircle);
        SHOW_RULE("SSReaderBookEndHeaderForumInsertHelper", "shouldInsert", ChapterCircle);
        SHOW_RULE("SSReaderBookEndDoubleRowSectionInsertHelper", "shouldInsert", ChapterCircle);
        SHOW_RULE("SSReaderChapterEndCombineViewModel", "showForumEntrance", ChapterForum);
        SHOW_RULE("SSReaderChapterEndCombineViewModel", "showReward", ChapterGift);
        SHOW_RULE("SSReaderChapterEndContentModel", "showReward", ChapterGift);
        SHOW_RULE("SSReaderChapterEndContentModel", "showGiftView", ChapterGift);
        SHOW_RULE("SSReaderChapterEndGiftRankInsertObject", "shouldInsert", ChapterGift);
        SHOW_RULE("SSReaderChapterEndCommunityCardViewModel", "standaloneGiftEligible", ChapterGift);
        SHOW_RULE("SSReaderBookEndHeaderUserGiftInsertHelper", "shouldInsert", ChapterGift);
        SHOW_RULE("SSReaderBookEndMixedEntrancesInsertHelper", "canShowReward", ChapterGift);
        SHOW_RULE("SSReaderBookEndMixedEntrancesInsertHelper", "shouldInsert", ChapterEndActions);
        SHOW_RULE("SSReaderChapterEndCombineViewModel", "showCommentSwitch", ReaderComments);
        SHOW_RULE("FQReaderManager", "shouldShowSpeechBtn", SpeechFloat);
        SHOW_RULE("SSReaderBottomToolDivertBookDispatcher", "showDivertEntranceInToolBar", ChapterEndDrama);
        SHOW_RULE("SSReaderBottomToolDivertBookDispatcher", "hasMoreAdaptionBottomEntrance", ChapterEndDrama);
        SHOW_RULE("SSBookShelfViewModel", "isHotBannerSectionActive", ShelfBanner);
        SHOW_RULE("SSBookShelfViewModel", "isHotBookCellActive", ShelfRecommendations);
        SHOW_RULE("SSBookShelfDoubleColumn", "isFeatureEnabled", ShelfRecommendations);
        SHOW_RULE("SSBookShelfDoubleColumn", "recommendEnabled", ShelfRecommendations);
        SHOW_RULE("SSBookShelfDoubleColumn", "enable", ShelfRecommendations);
        SHOW_RULE("SSBookShelfDoubleColumn", "hasCollapseBooks", ShelfRecommendations);
        SHOW_RULE("SSBookShelfDoubleColumn", "isDoubleColumnAllInBookShelf", ShelfRecommendations);
        SHOW_RULE("SSBookShelfDoubleColumnConfig", "enable", ShelfRecommendations);
        SHOW_RULE("SSBookShelfDoubleColumnConfig", "recommend_feed_enabled", ShelfRecommendations);
        SHOW_RULE("SSMyUser621BaseViewController", "showShortcut", MineShortcutCard);
        SHOW_RULE("SSMyUser621ViewController", "shouldInsertUnlimited", MineRecommendations);
        SHOW_RULE("SSNewAudioPlayViewController", "isUnlimitedRecommendNotEmpty", AudioRecommendations);
        SHOW_RULE("SSNewAudioPlayViewController", "shouldShowSlideGuide", AudioRecommendations);
        SHOW_RULE("SSNewAudioPlayViewController", "canReportRecommendItems", AudioRecommendations);
        HideClassWhen(@"SSBookShelfDoubleColumn", NSSelectorFromString(@"isFeatureEnabled"), ShelfRecommendationsKey, YES);
#undef SHOW_RULE

#define REPLACE(fn, cls, selector, encoding, impl) \
    fn = (void *)Replace(@cls, NSSelectorFromString(@selector), encoding, (IMP)impl)
        REPLACE(NativeImportCell, "SSBookShelfViewModel", "shouldShowLocalBookEntryAddCellWithHistoryCard:", "B24@0:8q16", ImportCell);
        REPLACE(NativeImportMenu, "SSBookShelfLocalBookHandler", "moreMenuItems", "@16@0:8", ImportMenu);
        REPLACE(NativeRelatedBanner, "SSBookShelfChaseBookModel", "bookEndRelateVideoBanner", "@16@0:8", RelatedBanner);
        REPLACE(NativeHasUnconsumedBanner, "SSBookShelfChaseBookModel", "hasUnconsumedVideoBanner", "B16@0:8", HasUnconsumedBanner);
        REPLACE(NativeHideDoubleColumnRecommend, "SSBookShelfSubVCOpenParams", "hideDoubleColumnRecommend", "B16@0:8", HideDoubleColumnRecommend);
        REPLACE(NativeDoubleColumnRequestData, "SSBookShelfDoubleColumn", "requestDataIfEnabled", "v16@0:8", DoubleColumnRequestData);
        REPLACE(NativeShelfAppeared, "SSBookShelfSubViewController", "viewDidAppear:", "v20@0:8B16", ShelfAppeared);
        REPLACE(NativeShelfNumberOfSections, "SSBookShelfSubViewController", "numberOfSectionsInCollectionView:", "q24@0:8@16", ShelfRecNumberOfSections);
        REPLACE(NativeShelfNumberOfItems, "SSBookShelfSubViewController", "collectionView:numberOfItemsInSection:", "q32@0:8@16q24", ShelfRecNumberOfItems);
        REPLACE(NativeShelfCellForItem, "SSBookShelfSubViewController", "collectionView:cellForItemAtIndexPath:", "@32@0:8@16@24", ShelfRecCellForItem);
        REPLACE(NativeShelfSupplementaryView, "SSBookShelfSubViewController", "collectionView:viewForSupplementaryElementOfKind:atIndexPath:", "@40@0:8@16@24@32", ShelfRecSupplementaryView);
        REPLACE(NativeShelfSizeForItem, "SSBookShelfSubViewController", "collectionView:layout:sizeForItemAtIndexPath:", "{CGSize=dd}40@0:8@16@24@32", ShelfRecSizeForItem);
        REPLACE(NativeShelfHeaderSize, "SSBookShelfSubViewController", "collectionView:layout:referenceSizeForHeaderInSection:", "{CGSize=dd}40@0:8@16@24q32", ShelfRecHeaderSize);
        REPLACE(NativeShelfFooterSize, "SSBookShelfSubViewController", "collectionView:layout:referenceSizeForFooterInSection:", "{CGSize=dd}40@0:8@16@24q32", ShelfRecFooterSize);
        REPLACE(NativeShelfInsetForSection, "SSBookShelfSubViewController", "collectionView:layout:insetForSectionAtIndex:", "{UIEdgeInsets=dddd}40@0:8@16@24q32", ShelfRecInsetForSection);
        MinePublishButton = class_getInstanceVariable(NSClassFromString(@"SSMyUser621ViewController"), "_publishButton");
        if (MinePublishButton && strcmp(ivar_getTypeEncoding(MinePublishButton), "@\"SSCommunityPublishButton\"") == 0) {
            REPLACE(NativeUpdatePublish, "SSMyUser621ViewController", "updatePublishBtnIfNeed", "v16@0:8", UpdatePublish);
        }
        REPLACE(NativeMineWillAppear, "SSMyUser621ViewController", "viewWillAppear:", "v20@0:8B16", MineWillAppear);
        REPLACE(NativeMineDidAppear, "SSMyUser621ViewController", "viewDidAppear:", "v20@0:8B16", MineDidAppear);
        REPLACE(NativeAudioLoadUnlimited, "SSNewAudioPlayViewController", "loadUnlimitedRecommend", "v16@0:8", AudioLoadUnlimited);
        REPLACE(NativeAudioPreloadUnlimited, "SSNewAudioPlayViewController", "preLoadAudioPlayUnlimitedRecData", "v16@0:8", AudioPreloadUnlimited);
        REPLACE(NativeAudioLoadRecommendBook, "SSNewAudioPlayViewController", "loadRecommendBook", "v16@0:8", AudioLoadRecommendBook);
        REPLACE(NativeAudioLoadComics, "SSNewAudioPlayViewController", "loadComicsBooks", "v16@0:8", AudioLoadComics);
        REPLACE(NativeAudioReloadRecommendForce, "SSNewAudioPlayViewController", "reloadRecommendUIRequestForce:", "v20@0:8B16", AudioReloadRecommendForce);
        REPLACE(NativeAudioReloadUnlimitedView, "SSNewAudioPlayViewController", "reloadUnlimitedView", "v16@0:8", AudioReloadUnlimitedView);
        REPLACE(NativeAudioLayoutContent, "SSNewAudioPlayViewController", "layoutContentView", "v16@0:8", AudioLayoutContent);
        REPLACE(NativeAudioWillAppear, "SSNewAudioPlayViewController", "viewWillAppear:", "v20@0:8B16", AudioWillAppear);
        REPLACE(NativeSpeechHidden, "FQReaderSaaSReaderSpeechButton", "setHidden:", "v20@0:8B16", SpeechHidden);
        REPLACE(NativePresentation, "BDUGUserNotificationCenter", "userNotificationCenter:willPresentNotification:withCompletionHandler:", "v40@0:8@16@24@?32", PresentNotification);
        REPLACE(NativeBadge, "UIApplication", "setApplicationIconBadgeNumber:", "v24@0:8q16", SetBadge);
        REPLACE(NativeNotificationBadge, "UNUserNotificationCenter", "setBadgeCount:withCompletionHandler:", "v32@0:8q16@?24", SetNotificationBadge);
        REPLACE(NativeShouldRecognize, "FQReaderManager", "shouldBeginDoubleTapRecognize", "B16@0:8", ShouldRecognize);
        REPLACE(NativeDoubleTap, "FQReaderManager", "didDoubleTapView:tapEvent:", "v32@0:8@16@24", ToggleAutoRead);
        REPLACE(NativePreSave, "SSReaderAutoReadPreSaveManager", "canShowAutoReadPreSaveWithPanelData:", "B24@0:8@16", CanShowPreSave);
        REPLACE(NativePauseForTime, "SSReaderAutoReadPreSaveManager", "pauseAutoReadIfNeededForNoLeftTime", "v16@0:8", PauseForTime);
#undef REPLACE
        // These switches control the reader's local ad-time interlock. The
        // original reward requests and network accounting are independent.
        HideWhen(@"SSReaderAutoReadInterrupter", NSSelectorFromString(@"inspireAutoReadOpen"), DurationLimitKey, NO);
        HideWhen(@"SSReaderAutoReadInterrupter", NSSelectorFromString(@"autoReadInspireOpen"), DurationLimitKey, NO);
        HideWhen(@"SSReaderAutoReadPreSaveManager", NSSelectorFromString(@"inspireAutoReadOpen"), DurationLimitKey, NO);
        HideWhen(@"SSReaderAutoReadPreSaveManager", NSSelectorFromString(@"shouldExitAutoReadWhenHidePreSaveCard"), DurationLimitKey, NO);
        FQXInstallContentCleanupHooks();
        InstallDramaActionVisibility(@"SSShortVideoRightInteractionCollectView", DramaShowCollectKey);
        InstallDramaActionVisibility(@"SSShortVideoRightInteractionCommentView", DramaShowCommentKey);
        InstallDramaActionVisibility(@"SSShortVideoHostRightInteractionCommentView", DramaShowCommentKey);
        InstallDramaActionVisibility(@"SSShortVideoRightInteractionLikeView", DramaShowLikeKey);
        InstallDramaActionVisibility(@"SSShortVideoRightInteractionShareView", DramaShowShareKey);
        FQXInstallMotionAndAudioHooks();
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(3.0 * NSEC_PER_SEC)),
                       dispatch_get_global_queue(QOS_CLASS_UTILITY, 0), ^{
            FQXPurgeHistoricalResidueImpl(NO);
        });
    });
}

+ (void)refreshForKey:(NSString *)key {
    if ([key isEqualToString:MinePublishKey]) {
        SEL selector = NSSelectorFromString(@"updatePublishBtnIfNeed");
        if (NativeUpdatePublish && LastMine) UpdatePublish(LastMine, selector);
    } else if ([key isEqualToString:MineScanButtonKey] || [key isEqualToString:MineSearchBarKey] ||
               [key isEqualToString:MineNightButtonKey] || [key isEqualToString:MineShortcutCardKey]) {
        for (UIScene *scene in UIApplication.sharedApplication.connectedScenes) {
            if (![scene isKindOfClass:UIWindowScene.class]) continue;
            for (UIWindow *window in ((UIWindowScene *)scene).windows) {
                RefreshMineViewsInSubtree(window);
            }
        }
        UIViewController *mine = LastMine;
        UIView *bar = HostObject(mine, NSSelectorFromString(@"myUserBar")) ?: CleanupIvarObject(mine, "_myUserBar");
        if ([bar isKindOfClass:UIView.class]) {
            [bar setNeedsLayout];
            [bar layoutIfNeeded];
        }
        if ([key isEqualToString:MineShortcutCardKey] && mine) {
            SEL reload = NSSelectorFromString(@"reloadData:");
            if (HostMethod(object_getClass(mine), reload, "v24@0:8@16")) {
                ((void (*)(id, SEL, id))objc_msgSend)(mine, reload, @"FanqieXCleanup");
            } else {
                id cv = HostObject(mine, NSSelectorFromString(@"collectionView"));
                if ([cv isKindOfClass:UICollectionView.class]) [(UICollectionView *)cv reloadData];
            }
        }
    } else if ([key isEqualToString:AudioControlIconsOnlyKey]) {
        Class motion = NSClassFromString(@"FQXDockMotion");
        SEL refresh = NSSelectorFromString(@"refreshAudioGlass");
        if ([motion respondsToSelector:refresh]) ((void (*)(id, SEL))objc_msgSend)(motion, refresh);
    } else if ([key isEqualToString:AudioRecommendationsKey]) {
        BOOL show = Option(AudioRecommendationsKey, YES);
        for (UIViewController *vc in [AudioPlayControllers() allObjects]) {
            ApplyAudioRecommendVisibility(vc);
            if (show) {
                if (NativeAudioLoadUnlimited) NativeAudioLoadUnlimited(vc, NSSelectorFromString(@"loadUnlimitedRecommend"));
                if (NativeAudioLoadRecommendBook) NativeAudioLoadRecommendBook(vc, NSSelectorFromString(@"loadRecommendBook"));
                if (NativeAudioReloadRecommendForce) NativeAudioReloadRecommendForce(vc, NSSelectorFromString(@"reloadRecommendUIRequestForce:"), YES);
            }
            SEL layoutSel = NSSelectorFromString(@"layoutContentView");
            if (HostMethod(object_getClass(vc), layoutSel, "v16@0:8")) {
                ((void (*)(id, SEL))objc_msgSend)(vc, layoutSel);
            }
            [vc.view setNeedsLayout];
        }
        Class dockMotion = NSClassFromString(@"FQXDockMotion");
        SEL refreshAudioSel = NSSelectorFromString(@"refreshAudioGlass");
        if ([dockMotion respondsToSelector:refreshAudioSel]) {
            ((void (*)(id, SEL))objc_msgSend)(dockMotion, refreshAudioSel);
        }
    } else if (DramaActionOwners[key]) {
        for (UIView *view in DramaActionOwners[key].allObjects)
            view.hidden = [objc_getAssociatedObject(view, &DramaActionRequestedHiddenKey) boolValue];
    } else if ([key isEqualToString:DramaOutlineActionsKey]) {
        Class style = NSClassFromString(@"FQXDramaActionStyle");
        SEL refresh = NSSelectorFromString(@"refresh");
        if ([style respondsToSelector:refresh]) ((void (*)(id, SEL))objc_msgSend)(style, refresh);
    } else if ([key isEqualToString:DramaPinchPureCleanKey]) {
        Class dockMotion = NSClassFromString(@"FQXDockMotion");
        SEL refreshPinchSel = NSSelectorFromString(@"refreshDramaPinchClean");
        if ([dockMotion respondsToSelector:refreshPinchSel]) {
            ((void (*)(id, SEL))objc_msgSend)(dockMotion, refreshPinchSel);
        }
    } else if ([key isEqualToString:CommentMaterialModeKey] ||
               [key isEqualToString:CommentActivityBannerKey] ||
               [key isEqualToString:CommentSearchEntranceKey]) {
        Class dockMotion = NSClassFromString(@"FQXDockMotion");
        SEL refreshCommentSel = NSSelectorFromString(@"refreshCommentGlass");
        if ([dockMotion respondsToSelector:refreshCommentSel]) {
            ((void (*)(id, SEL))objc_msgSend)(dockMotion, refreshCommentSel);
        }
    } else if ([key isEqualToString:SpeechFloatKey]) {
        UIView *button = LastSpeechButton;
        NSNumber *wasHidden = objc_getAssociatedObject(button, &SpeechRequestedHidden);
        if (wasHidden) SpeechHidden(button, @selector(setHidden:), wasHidden.boolValue);
    } else if ([key isEqualToString:BadgeKey] && !Option(BadgeKey, YES) && NativeBadge) {
        NativeBadge(UIApplication.sharedApplication, NSSelectorFromString(@"setApplicationIconBadgeNumber:"), 0);
    } else if ([key isEqualToString:ShelfBannerKey] || [key isEqualToString:ShelfImportKey] ||
               [key isEqualToString:ShelfComicKey] || [key isEqualToString:ShelfRecommendationsKey]) {
        UIViewController *shelf = LastShelf;
        if ([key isEqualToString:ShelfRecommendationsKey]) {
            BOOL show = Option(ShelfRecommendationsKey, YES);
            if (show) ShelfRecRestoreController(shelf);
            id vm = HostObject(shelf, NSSelectorFromString(@"viewModel"));
            id dc = HostObject(vm, NSSelectorFromString(@"doubleColumn"));
            if (!show) {
                SEL setCollapse = NSSelectorFromString(@"setHasCollapseBooks:");
                if (HostMethod(object_getClass(dc), setCollapse, "v20@0:8B16")) {
                    ((void (*)(id, SEL, BOOL))objc_msgSend)(dc, setCollapse, NO);
                }
            } else {
                SEL updateDC = NSSelectorFromString(@"updateDoubleColumnRecommend");
                if (HostMethod(object_getClass(vm), updateDC, "v16@0:8")) {
                    ((void (*)(id, SEL))objc_msgSend)(vm, updateDC);
                }
                SEL reqDC = NSSelectorFromString(@"requestDataIfEnabled");
                if (HostMethod(object_getClass(dc), reqDC, "v16@0:8")) {
                    ((void (*)(id, SEL))objc_msgSend)(dc, reqDC);
                }
            }
            SEL rebuild = NSSelectorFromString(@"rebuildShelfPipeline:");
            if (HostMethod(object_getClass(vm), rebuild, "v24@0:8@16")) {
                ((void (*)(id, SEL, id))objc_msgSend)(vm, rebuild, @"FanqieXCleanup");
            }
        }
        SEL reload = NSSelectorFromString(@"reloadData:");
        if (HostMethod(object_getClass(shelf), reload, "v24@0:8@16")) {
            ((void (*)(id, SEL, id))objc_msgSend)(shelf, reload, @"FanqieXCleanup");
        } else {
            id cv = HostObject(shelf, NSSelectorFromString(@"collectionView"));
            if ([cv isKindOfClass:UICollectionView.class]) [(UICollectionView *)cv reloadData];
        }
    }
}
@end
