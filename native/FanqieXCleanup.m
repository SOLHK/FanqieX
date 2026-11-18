#import <UIKit/UIKit.h>
#import <objc/message.h>
#import <objc/runtime.h>
#import "FQXHookInstaller.h"
extern void FQXInstallContentCleanupHooks(void);

#define CLEANUP_OPTIONS(X) \
    X(AuthorWords, "ReaderAuthorWords", "显示作者的话", "reader", YES) \
    X(ChapterDiscussion, "ReaderChapterDiscussion", "显示章末讨论入口", "reader", YES) \
    X(ChapterCircle, "ReaderChapterCircle", "显示章末圈子", "reader", YES) \
    X(ChapterForum, "ReaderChapterForum", "显示章末论坛入口", "reader", YES) \
    X(ChapterGift, "ReaderChapterGift", "显示章末送礼物", "reader", YES) \
    X(ChapterEndActions, "ReaderChapterEndActions", "显示最新章节底部三个按钮", "reader", YES) \
    X(ReaderComments, "ReaderComments", "显示章末开启评论", "reader", YES) \
    X(ReaderEarnMore, "ReaderEarnMore", "显示阅读页去赚更多", "reader", YES) \
    X(SpeechFloat, "ReaderSpeechFloat", "显示阅读页听书悬浮按钮", "reader", YES) \
    X(ChapterEndDrama, "ReaderChapterEndDrama", "显示阅读底栏改编剧场", "reader", YES) \
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
static void (*NativeShelfAppeared)(id, SEL, BOOL);
static void ShelfAppeared(id owner, SEL cmd, BOOL animated) {
    NativeShelfAppeared(owner, cmd, animated);
    LastShelf = owner;
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
        @"recommend", @"rcmd", @"guess", @"waterfall", @"bookstore", @"relatedbook", @"discover", @"bottomfeed"
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

@interface FQXCleanup : NSObject
+ (void)install;
+ (NSArray<NSDictionary *> *)optionRows;
+ (void)refreshForKey:(NSString *)key;
@end

@implementation FQXCleanup
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
#undef SHOW_RULE

#define REPLACE(fn, cls, selector, encoding, impl) \
    fn = (void *)Replace(@cls, NSSelectorFromString(@selector), encoding, (IMP)impl)
        REPLACE(NativeImportCell, "SSBookShelfViewModel", "shouldShowLocalBookEntryAddCellWithHistoryCard:", "B24@0:8q16", ImportCell);
        REPLACE(NativeImportMenu, "SSBookShelfLocalBookHandler", "moreMenuItems", "@16@0:8", ImportMenu);
        REPLACE(NativeRelatedBanner, "SSBookShelfChaseBookModel", "bookEndRelateVideoBanner", "@16@0:8", RelatedBanner);
        REPLACE(NativeHasUnconsumedBanner, "SSBookShelfChaseBookModel", "hasUnconsumedVideoBanner", "B16@0:8", HasUnconsumedBanner);
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
    });
}

+ (void)refreshForKey:(NSString *)key {
    if ([key isEqualToString:MinePublishKey]) {
        SEL selector = NSSelectorFromString(@"updatePublishBtnIfNeed");
        if (NativeUpdatePublish && LastMine) UpdatePublish(LastMine, selector);
    } else if ([key isEqualToString:SpeechFloatKey]) {
        UIView *button = LastSpeechButton;
        NSNumber *wasHidden = objc_getAssociatedObject(button, &SpeechRequestedHidden);
        if (wasHidden) SpeechHidden(button, @selector(setHidden:), wasHidden.boolValue);
    } else if ([key isEqualToString:BadgeKey] && !Option(BadgeKey, YES) && NativeBadge) {
        NativeBadge(UIApplication.sharedApplication, NSSelectorFromString(@"setApplicationIconBadgeNumber:"), 0);
    } else if ([key isEqualToString:ShelfBannerKey] || [key isEqualToString:ShelfImportKey] ||
               [key isEqualToString:ShelfComicKey] || [key isEqualToString:ShelfRecommendationsKey]) {
        UIViewController *shelf = LastShelf;
        if ([key isEqualToString:ShelfRecommendationsKey] && Option(ShelfRecommendationsKey, YES)) {
            ShelfRecRestoreController(shelf);
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
