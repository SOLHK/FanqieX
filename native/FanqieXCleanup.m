#import <UIKit/UIKit.h>
#import <QuartzCore/QuartzCore.h>
#import <objc/message.h>
#import <objc/runtime.h>
#import <pthread.h>
#include <stdatomic.h>
#import "FQXHookInstaller.h"
#import "FQXLayoutAndSheetPolicy.h"
#import "FanqieXDetachedDock.h"
#import "FanqieXDiagnosticsHub.h"
extern void FQXInstallContentCleanupHooks(void);
extern void FQXInstallMotionAndAudioHooks(void);
extern void FQXRefreshReaderAndAudioPendants(void);

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
    X(ReaderHotCommentBadge, "ReaderHotCommentBadge", "显示阅读顶部热评", "readerFeatures", YES) \
    X(ChapterEndDrama, "ReaderChapterEndDrama", "显示阅读底栏改编剧场", "reader", YES) \
    X(AudioRecommendations, "AudioRecommendations", "显示听书页推荐内容", "reader", YES) \
    X(AudioLiquidGlass, "AudioLiquidGlass", "听书界面液态玻璃", "audio", NO) \
    X(AudioControlIconsOnly, "AudioControlIconsOnly", "朗读按钮仅显示图标", "audio", NO) \
    X(MineScanButton, "MineScanButton", "显示我的顶部扫一扫", "mine", YES) \
    X(MineSearchBar, "MineSearchBar", "显示我的顶部搜索框", "mine", YES) \
    X(MineNightButton, "MineNightButton", "显示我的顶部夜间按钮", "mine", YES) \
    X(MineShortcutCard, "MineShortcutCard", "显示我的快捷功能卡片", "mine", YES) \
    X(MinePublish, "MinePublish", "显示我的页面发帖按钮", "mine", YES) \
    X(MineRecommendations, "MineRecommendations", "显示推荐内容", "mine", YES) \
    X(MineBenefits, "MineBenefitsCard", "显示金币与福利卡片", "mine", YES) \
    X(SidebarMessages, "SidebarMessages", "显示侧栏我的消息", "sidebar", YES) \
    X(SidebarVideoCreate, "SidebarVideoCreate", "显示侧栏视频创作", "sidebar", YES) \
    X(SidebarReadingPref, "SidebarReadingPref", "显示侧栏阅读偏好", "sidebar", YES) \
    X(SidebarMyNotes, "SidebarMyNotes", "显示侧栏我的笔记", "sidebar", YES) \
    X(SidebarActivityCenter, "SidebarActivityCenter", "显示侧栏活动中心", "sidebar", YES) \
    X(SidebarViewedUsers, "SidebarViewedUsers", "显示侧栏看过的人", "sidebar", YES) \
    X(SidebarFanqieGuide, "SidebarFanqieGuide", "显示侧栏番茄指南", "sidebar", YES) \
    X(SidebarMyCharity, "SidebarMyCharity", "显示侧栏我的公益", "sidebar", YES) \
    X(SidebarVipCenter, "SidebarVipCenter", "显示侧栏会员中心", "sidebar", YES) \
    X(SidebarMyContract, "SidebarMyContract", "显示侧栏我的签约", "sidebar", YES) \
    X(SidebarMyWallet, "SidebarMyWallet", "显示侧栏我的钱包", "sidebar", YES) \
    X(SidebarConversionRecord, "SidebarConversionRecord", "显示侧栏转化记录", "sidebar", YES) \
    X(SidebarPrivacyLinks, "SidebarPrivacyLinks", "显示侧栏底部清单", "sidebar", YES) \
    X(ShelfEditButton, "ShelfEditButton", "显示书架编辑按钮", "shelf", YES) \
    X(ShelfBanner, "ShelfRecommendationBanner", "显示书架推荐横幅", "shelf", YES) \
    X(ShelfActivityNotice, "ShelfActivityNotice", "显示书架活动公告", "shelf", YES) \
    X(ShelfImport, "ShelfLocalImport", "显示书架本地书导入入口", "shelf", YES) \
    X(ShelfHistoryCard, "ShelfHistoryCard", "显示书架浏览历史入口", "shelf", YES) \
    X(ShelfComic, "ShelfMotionComicRecommendation", "显示书架漫剧推荐", "shelf", YES) \
    X(ShelfAdaptationCard, "ShelfAdaptationCard", "显示小说改编剧推荐卡", "shelf", YES) \
    X(ShelfRecommendations, "ShelfRecommendations", "显示书架推荐内容", "shelf", YES) \
    X(ShelfTabBookshelf, "ShelfTabBookshelf", "显示书架「书架」标签", "shelf", YES) \
    X(ShelfTabHistory, "ShelfTabHistory", "显示书架「历史」标签", "shelf", YES) \
    X(ShelfTabCollect, "ShelfTabCollect", "显示书架「收藏」标签", "shelf", YES) \
    X(ShelfTabCircle, "ShelfTabCircle", "显示书架「圈子」标签", "shelf", YES) \
    X(ShelfSearchButton, "ShelfSearchButton", "显示书架搜索按钮", "shelf", YES) \
    X(ShelfMoreButton, "ShelfMoreButton", "显示书架更多按钮", "shelf", YES) \
    X(ShelfFilterAll, "ShelfFilterAll", "显示书架「全部」标签", "shelf", YES) \
    X(ShelfFilterRead, "ShelfFilterRead", "显示书架「阅读」标签", "shelf", YES) \
    X(ShelfFilterListen, "ShelfFilterListen", "显示书架「听书」标签", "shelf", YES) \
    X(ShelfFilterComic, "ShelfFilterComic", "显示书架「漫剧」标签", "shelf", YES) \
    X(ShelfFilterStar, "ShelfFilterStar", "显示书架「星标」标签", "shelf", YES) \
    X(ShelfHistoryFilterAll, "ShelfHistoryFilterAll", "显示历史「全部」标签", "shelf", YES) \
    X(ShelfHistoryFilterRead, "ShelfHistoryFilterRead", "显示历史「阅读」标签", "shelf", YES) \
    X(ShelfHistoryFilterListen, "ShelfHistoryFilterListen", "显示历史「听书」标签", "shelf", YES) \
    X(ShelfHistoryFilterDrama, "ShelfHistoryFilterDrama", "显示历史「短剧」标签", "shelf", YES) \
    X(ShelfHistoryFilterShortStory, "ShelfHistoryFilterShortStory", "显示历史「短篇」标签", "shelf", YES) \
    X(ShelfHistoryFilterComic, "ShelfHistoryFilterComic", "显示历史「漫画」标签", "shelf", YES) \
    X(ShelfHistoryFilterTopic, "ShelfHistoryFilterTopic", "显示历史「话题」标签", "shelf", YES) \
    X(ShelfHistoryFilterBtn, "ShelfHistoryFilterBtn", "显示历史「筛选」按钮", "shelf", YES) \
    X(ShelfHistoryEditBtn, "ShelfHistoryEditBtn", "显示历史「编辑」按钮", "shelf", YES) \
    X(ShelfFavoritesFilterAll, "ShelfFavoritesFilterAll", "显示「全部」标签", "shelf", YES) \
    X(ShelfFavoritesFilterDrama, "ShelfFavoritesFilterDrama", "显示「短剧」标签", "shelf", YES) \
    X(ShelfFavoritesFilterComic, "ShelfFavoritesFilterComic", "显示「漫剧」标签", "shelf", YES) \
    X(ShelfFavoritesFilterOther, "ShelfFavoritesFilterOther", "显示「其他视频」标签", "shelf", YES) \
    X(ShelfFavoritesEditButton, "ShelfFavoritesEditButton", "显示「编辑」按钮", "shelf", YES) \
    X(ShelfFavoritesHistoryCard, "ShelfFavoritesHistoryCard", "显示「查看短剧浏览历史」卡片", "shelf", YES) \
    X(Foreground, "NotificationsForeground", "显示前台通知提醒", "notifications", YES) \
    X(Badge, "NotificationsBadge", "显示 App 图标角标", "notifications", YES) \
    X(DoubleTap, "ReaderDoubleTapAutoread", "双击正文切换自动阅读", "gestures", NO) \
    X(DurationLimit, "ReaderAutoReadDurationLimit", "关闭自动阅读广告时长限制", "gestures", NO) \
    X(DramaPinchPureClean, "DramaPinchPureClean", "双指缩放切换纯净清屏", "drama", NO) \
    X(DramaPinchHaptic, "DramaPinchHaptic", "双指缩放清屏震动反馈", "drama", YES) \
    X(DramaDoubleTapComment, "DramaDoubleTapComment", "双击打开评论区（关闭双击点赞）", "drama", NO) \
    X(DramaCommentNoVideoShift, "DramaCommentNoVideoShift", "打开评论区短剧画面不上移", "drama", NO) \
    X(DramaExitCollectAlert, "DramaExitCollectAlert", "隐藏短剧退出收藏弹窗", "drama", NO) \
    X(DramaHideFullscreenButton, "DramaHideFullscreenButton", "隐藏「全屏观看」按钮", "drama", NO) \
    X(DramaHideTitleEntry, "DramaHideTitleEntry", "隐藏短剧标题入口", "drama", NO) \
    X(DramaHideSeriesTag, "DramaHideSeriesTag", "隐藏短剧系列剧追剧标签", "drama", NO) \
    X(DramaHideTitleBadge, "DramaHideTitleBadge", "隐藏短剧标题角标（上新/爆款）", "drama", NO) \
    X(DramaHideGenreTags, "DramaHideGenreTags", "隐藏短剧题材与季数标签", "drama", NO) \
    X(DramaHideEpisodeAdaptations, "DramaHideEpisodeAdaptations", "隐藏选集原著和更多改编", "drama", NO) \
    X(DramaHideEpisodeSameSeries, "DramaHideEpisodeSameSeries", "隐藏选集同系列剧", "drama", NO) \
    X(DramaHideEpisodeRecommend, "DramaHideEpisodeRecommend", "隐藏选集底部推荐视频", "drama", NO) \
    X(DramaOutlineActions, "DramaOutlineActions", "短剧右侧使用空心图标", "drama", NO) \
    X(DramaShowCollect, "DramaShowCollect", "显示收藏按钮", "dramaActions", YES) \
    X(DramaShowComment, "DramaShowComment", "显示评论按钮", "dramaActions", YES) \
    X(DramaShowLike, "DramaShowLike", "显示点赞按钮", "dramaActions", YES) \
    X(DramaShowShare, "DramaShowShare", "显示分享按钮", "dramaActions", YES) \
    X(DramaAutoplay, "DramaAutoplay", "关闭短剧进入自动播放", "drama", NO) \
    X(DramaUnlockDanmaku, "DramaUnlockDanmaku", "解锁短剧与漫剧弹幕功能", "drama", YES) \
    X(DramaShowDanmakuButton, "DramaShowDanmakuButton", "显示左下角弹幕按钮", "drama", YES) \
    X(ReaderRatingInvite, "ReaderRatingInvite", "关闭阅读评价邀请", "readerFeatures", NO) \
    X(ExcerptWidgetGuide, "ExcerptWidgetGuide", "隐藏书摘小组件提醒", "readerFeatures", NO) \
    X(ContentWidgetGuide, "ContentWidgetGuide", "隐藏内容小组件提醒", "readerFeatures", NO) \
    X(BookstorePublishButton, "BookstorePublishButton", "隐藏书城发帖按钮", "bookstore", NO) \
    X(ListenPendant, "ListenPendant", "净化听读赚钱悬浮挂件", "readerFeatures", NO) \
    X(StoryAds, "StoryAds", "短篇正文广告处理", "ads", NO) \
    X(HotLaunchAds, "HotLaunchAds", "热启动广告专项拦截", "ads", NO) \
    X(AudioAds, "AudioAds", "听书广告专项控制", "ads", NO) \
    X(ChapterTitle, "ChapterTitle", "返回标题固定为章节名称", "readerFeatures", NO) \
    X(GlassDarkTint, "GlassDarkTint", "液态玻璃叠加深色底色", "appearance", NO) \
    X(DockDetachedEnabled, "DockDetachedEnabled", "启用 Dock 独立圆形模块", "bottom", NO)

#define OPTION_KEY(name, suffix, title, category, defaultValue) \
    static NSString *const name##Key = @"FanqieX." suffix ".1";
CLEANUP_OPTIONS(OPTION_KEY)
#undef OPTION_KEY
static NSString *const CommentMaterialStyleKey = @"FanqieX.CommentMaterialStyle.1";
static NSString *const CommentAppearanceModeKey = @"FanqieX.CommentAppearanceMode.1";
static NSString *const CommentComposerStyleKey = @"FanqieX.CommentComposerStyle.1";
static NSString *const BottomDisplayModeKey = @"FanqieX.BottomDisplayMode.1";
static NSString *const DockCollapseModeKey = @"FanqieX.DockCollapseMode.1";
static NSString *const DockSiriaiHideLineKey = @"FanqieX.DockSiriaiHideLine.1";
static NSString *const DockMaterialKey = @"FanqieX.DockMaterial.1";
static NSString *const SelectionTintStyleKey = @"FanqieX.SelectionTintStyle.1";
static NSString *const DramaButtonSurfaceStyleKey = @"FanqieX.DramaButtonSurfaceStyle.1";
static NSString *const DockBlurKey = @"FanqieX.DockBlur.1";
static NSString *const CommentBlurKey = @"FanqieX.CommentBlur.1";
static NSString *const AudioButtonBlurKey = @"FanqieX.AudioButtonBlur.1";
static NSString *const AudioMoreBlurKey = @"FanqieX.AudioMoreBlur.1";
static NSString *const AudioSheetMaterialKey = @"FanqieX.AudioSheetMaterial.1";
static NSString *const AudioSheetBlurKey = @"FanqieX.AudioSheetBlur.1";
static NSString *const DramaHeaderBlurKey = @"FanqieX.DramaHeaderBlur.1";
static NSString *const DramaHeaderButtonScaleKey = @"FanqieX.DramaHeaderButtonScale.1";
static NSString *const ShareMaterialStyleKey = @"FanqieX.ShareMaterialStyle.1";
static NSString *const ShareBlurKey = @"FanqieX.ShareBlur.1";
static NSString *const DramaPlaybackOptionsMaterialKey = @"FanqieX.DramaPlaybackOptionsMaterial.1";
static NSString *const DramaPlaybackOptionsBlurKey = @"FanqieX.DramaPlaybackOptionsBlur.1";

static pthread_mutex_t FQXOptionCacheLock = PTHREAD_MUTEX_INITIALIZER;
static NSMutableDictionary<NSString *, id> *FQXOptionCache = nil;
static _Atomic uint64_t FQXOptionCacheGen = 1;
static uint64_t FQXOptionCacheSeenGen = 0;

static void FQXInvalidateOptionCache(void) {
    atomic_fetch_add_explicit(&FQXOptionCacheGen, 1, memory_order_release);
}

static BOOL Option(NSString *key, BOOL defaultValue) {
    if (!key.length) return defaultValue;
    uint64_t gen = atomic_load_explicit(&FQXOptionCacheGen, memory_order_acquire);
    pthread_mutex_lock(&FQXOptionCacheLock);
    if (FQXOptionCacheSeenGen != gen) {
        [FQXOptionCache removeAllObjects];
        FQXOptionCacheSeenGen = gen;
    }
    id cached = FQXOptionCache[key];
    pthread_mutex_unlock(&FQXOptionCacheLock);
    if (cached) {
        return cached == NSNull.null ? defaultValue : [cached boolValue];
    }
    id value = [NSUserDefaults.standardUserDefaults objectForKey:key];
    id stored = [value isKindOfClass:NSNumber.class] ? @(((NSNumber *)value).boolValue) : (id)NSNull.null;
    pthread_mutex_lock(&FQXOptionCacheLock);
    if (FQXOptionCacheSeenGen == gen) {
        if (!FQXOptionCache) FQXOptionCache = [NSMutableDictionary dictionaryWithCapacity:64];
        FQXOptionCache[key] = stored;
    }
    pthread_mutex_unlock(&FQXOptionCacheLock);
    return stored == NSNull.null ? defaultValue : [stored boolValue];
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
    const char *clsCStr = className.UTF8String;
    const char *selCStr = sel_getName(selector);
    const char *ruleCStr = key.UTF8String;
    BOOL (*original)(id, SEL) = (void *)method_getImplementation(method);
    IMP replacement = imp_implementationWithBlock(^BOOL(id owner) {
        CFTimeInterval t0 = CACurrentMediaTime();
        if (Option(key, defaultValue) != defaultValue) {
            FQXDiagRecordHook(clsCStr, selCStr, ruleCStr, "cleanup_toggle_active", "blocked", (CACurrentMediaTime() - t0) * 1000.0);
            return NO;
        }
        BOOL res = original(owner, selector);
        FQXDiagRecordHook(clsCStr, selCStr, ruleCStr, "cleanup_toggle_inactive", "allowed", (CACurrentMediaTime() - t0) * 1000.0);
        return res;
    });
    Install(cls, selector, method, replacement);
}

static void HideClassWhen(NSString *className, SEL selector, NSString *key, BOOL defaultValue) {
    Class cls = NSClassFromString(className);
    Method method = class_getClassMethod(cls, selector);
    if (!method || strcmp(method_getTypeEncoding(method), "B16@0:8") != 0) return;
    const char *clsCStr = className.UTF8String;
    const char *selCStr = sel_getName(selector);
    const char *ruleCStr = key.UTF8String;
    __block IMP original = NULL;
    IMP replacement = imp_implementationWithBlock(^BOOL(id owner) {
        CFTimeInterval t0 = CACurrentMediaTime();
        if (Option(key, defaultValue) != defaultValue) {
            FQXDiagRecordHook(clsCStr, selCStr, ruleCStr, "cleanup_toggle_active", "blocked", (CACurrentMediaTime() - t0) * 1000.0);
            return NO;
        }
        BOOL res = ((BOOL (*)(id, SEL))original)(owner, selector);
        FQXDiagRecordHook(clsCStr, selCStr, ruleCStr, "cleanup_toggle_inactive", "allowed", (CACurrentMediaTime() - t0) * 1000.0);
        return res;
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

static BOOL (*NativeImportCellBool)(id, SEL, BOOL);
static BOOL ImportCellBool(id owner, SEL cmd, BOOL card) {
    return Option(ShelfImportKey, YES) && NativeImportCellBool(owner, cmd, card);
}

static NSArray *(*NativeImportMenu)(id, SEL);
static NSArray *ImportMenu(id owner, SEL cmd) {
    return Option(ShelfImportKey, YES) ? NativeImportMenu(owner, cmd) : @[];
}

static BOOL IsMotionComicBanner(id banner) {
    id video = HostObject(banner, sel_registerName("chaseVideoData"));
    SEL contentType = sel_registerName("contentType");
    // This is the host's contentType value used for isMotionComic.
    return HostMethod(object_getClass(video), contentType, "i16@0:8") &&
        ((int (*)(id, SEL))objc_msgSend)(video, contentType) == 1004;
}

static BOOL ShelfHidesAdaptationBanner(id banner) {
    if (!banner || Option(ShelfAdaptationCardKey, YES)) return NO;
    if ([banner isKindOfClass:objc_lookUpClass("SeriesOriginalBanner")]) {
        id payload = HostObject(banner, @selector(payload));
        return [@"你看过的小说上架改编剧了" isEqual:HostObject(payload, @selector(bannerTitle))];
    }
    // The 7.4.5 shelf renders type 13 as a previously read novel's adaptation.
    SEL type = sel_registerName("chaseBookUpdateType");
    if (!HostMethod(object_getClass(banner), type, "i16@0:8") ||
        ((int (*)(id, SEL))objc_msgSend)(banner, type) != 13) return NO;
    id video = HostObject(banner, @selector(videoData));
    return ![@"interactive_game" isEqual:HostObject(video, @selector(videoCategoryType))];
}

static id (*NativeRelatedBanner)(id, SEL);
static id RelatedBanner(id owner, SEL cmd) {
    id banner = NativeRelatedBanner(owner, cmd);
    if (ShelfHidesAdaptationBanner(banner)) return nil;
    return !Option(ShelfComicKey, YES) && IsMotionComicBanner(banner) ? nil : banner;
}

static id (*NativeShelfVideoBanner)(id, SEL);
static id ShelfVideoBanner(id owner, SEL cmd) {
    id banner = NativeShelfVideoBanner(owner, cmd);
    return ShelfHidesAdaptationBanner(banner) ? nil : banner;
}

static id (*NativeShelfIPBanner)(id, SEL);
static id ShelfIPBanner(id owner, SEL cmd) {
    id banner = NativeShelfIPBanner(owner, cmd);
    return ShelfHidesAdaptationBanner(banner) ? nil : banner;
}

static BOOL (*NativeCanShowLegacyIPBanner)(id, SEL, id);
static BOOL ShelfCanShowLegacyIPBanner(id owner, SEL cmd, id banner) {
    return !ShelfHidesAdaptationBanner(banner) && NativeCanShowLegacyIPBanner(owner, cmd, banner);
}

static BOOL (*NativeHasUnconsumedBanner)(id, SEL);
static BOOL HasUnconsumedBanner(id owner, SEL cmd) {
    if (!NativeHasUnconsumedBanner(owner, cmd)) return NO;
    BOOL showComic = Option(ShelfComicKey, YES);
    if (showComic && Option(ShelfAdaptationCardKey, YES)) return YES;
    SEL getter = sel_registerName("unconsumedVideoBanner");
    id banner = NativeShelfVideoBanner ? NativeShelfVideoBanner(owner, getter) : HostObject(owner, getter);
    return !ShelfHidesAdaptationBanner(banner) && (showComic || !IsMotionComicBanner(banner));
}

static __weak UIViewController *LastShelf;
static CFTimeInterval FQXCleanupLaunchTime = 0.0;
static char ShelfColdStartDoneKey;
static char ShelfColdStartTimerKey;
static char ShelfColdStartAppearTimeKey;
static char ShelfColdStartSawRealBookKey;
static char ShelfColdStartMutedViewsKey;
static char ShelfColdStartViewMutedKey;

static BOOL ShelfModelIsRealBook(id model);
static NSInteger ShelfRecSectionType(id controller, NSInteger section);
static NSInteger (*NativeShelfNumberOfSections)(id, SEL, id);
static NSInteger (*NativeShelfNumberOfItems)(id, SEL, id, NSInteger);

static void ShelfRefreshVisibleHeaderLayout(UIView *cv) {
    if (![cv isKindOfClass:UICollectionView.class]) return;
    UICollectionView *collection = (UICollectionView *)cv;
    static Class funcCls = Nil;
    static dispatch_once_t once;
    dispatch_once(&once, ^{ funcCls = objc_lookUpClass("SSBookShelfFunctionCell"); });
    for (UIView *sub in collection.subviews) {
        if (![sub isKindOfClass:UICollectionViewCell.class]) continue;
        if (!funcCls || [sub isKindOfClass:funcCls]) {
            [sub setNeedsLayout];
            id header = HostObject(sub, @selector(headerView));
            if ([header isKindOfClass:UIView.class]) [(UIView *)header setNeedsLayout];
        }
    }
    [collection setNeedsLayout];
}

static BOOL ShelfViewIsEmptyBookPlaceholder(UIView *view, NSInteger depth) {
    if (![view isKindOfClass:UIView.class] || depth > 5) return NO;
    if (depth > 0 && [view isKindOfClass:UICollectionView.class]) return NO;
    static Class funcCls = Nil;
    static dispatch_once_t once;
    dispatch_once(&once, ^{ funcCls = objc_lookUpClass("SSBookShelfFunctionCell"); });
    if (funcCls && [view isKindOfClass:funcCls]) return NO;
    if (depth == 0) {
        id model = HostObject(view, @selector(cellModel)) ?: HostObject(view, @selector(model));
        if (ShelfModelIsRealBook(model)) return NO;
        NSString *lower = NSStringFromClass([view class]).lowercaseString ?: @"";
        if ([lower containsString:@"emptybook"] || [lower containsString:@"bookempty"] ||
            [lower containsString:@"emptycell"] || [lower containsString:@"emptyview"] ||
            [lower containsString:@"nobook"] || [lower containsString:@"emptystatus"]) {
            return YES;
        }
        if ([lower containsString:@"function"]) return NO;
    }
    if ([view isKindOfClass:UILabel.class]) {
        UILabel *label = (UILabel *)view;
        NSString *text = label.text.length ? label.text : label.attributedText.string;
        if (text.length && ([text containsString:@"书架暂无书籍"] || [text containsString:@"去书城找书"])) {
            return YES;
        }
    } else if ([view isKindOfClass:UIButton.class]) {
        NSString *title = [(UIButton *)view titleForState:UIControlStateNormal];
        if (title.length && ([title containsString:@"书架暂无书籍"] || [title containsString:@"去书城找书"])) {
            return YES;
        }
    }
    if (depth >= 5) return NO;
    for (UIView *sub in view.subviews) {
        if ([sub isKindOfClass:UIImageView.class] || [sub isKindOfClass:UIVisualEffectView.class]) continue;
        if (ShelfViewIsEmptyBookPlaceholder(sub, depth + 1)) return YES;
    }
    return NO;
}

static BOOL ShelfHasRealBooksNow(id controller, id collectionViewObj) {
    if (!controller) return NO;
    if ([objc_getAssociatedObject(controller, &ShelfColdStartSawRealBookKey) boolValue]) return YES;
    id vm = HostObject(controller, @selector(viewModel));
    id models = HostObject(vm, @selector(showCellModels));
    if ([models isKindOfClass:NSArray.class]) {
        for (id item in (NSArray *)models) {
            if (ShelfModelIsRealBook(item)) {
                objc_setAssociatedObject(controller, &ShelfColdStartSawRealBookKey, @YES, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
                return YES;
            }
        }
    }
    if ([collectionViewObj isKindOfClass:UIView.class]) {
        for (UIView *sub in [(UIView *)collectionViewObj subviews]) {
            if (![sub isKindOfClass:UICollectionViewCell.class]) continue;
            id m = HostObject(sub, @selector(cellModel)) ?: HostObject(sub, @selector(model));
            if (ShelfModelIsRealBook(m)) {
                objc_setAssociatedObject(controller, &ShelfColdStartSawRealBookKey, @YES, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
                return YES;
            }
        }
    }
    return NO;
}

static BOOL ShelfIsInColdStartEmptyGrace(id controller, id collectionViewObj) {
    if (!controller || [objc_getAssociatedObject(controller, &ShelfColdStartDoneKey) boolValue]) return NO;
    if (ShelfHasRealBooksNow(controller, collectionViewObj)) {
        objc_setAssociatedObject(controller, &ShelfColdStartDoneKey, @YES, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
        return NO;
    }
    CFTimeInterval now = CACurrentMediaTime();
    NSNumber *appearNum = objc_getAssociatedObject(controller, &ShelfColdStartAppearTimeKey);
    CFTimeInterval appearTime = appearNum ? appearNum.doubleValue : now;
    if (!appearNum) {
        objc_setAssociatedObject(controller, &ShelfColdStartAppearTimeKey, @(appearTime), OBJC_ASSOCIATION_RETAIN_NONATOMIC);
    }
    BOOL hostLoaded = YES;
    id vm = HostObject(controller, @selector(viewModel));
    if (vm) {
        SEL sel = @selector(hasLoadBookShelf);
        Class vmCls = object_getClass(vm);
        if (HostMethod(vmCls, sel, "B16@0:8") || HostMethod(vmCls, sel, "c16@0:8")) {
            hostLoaded = ((BOOL (*)(id, SEL))objc_msgSend)(vm, sel);
        } else {
            Ivar ivar = class_getInstanceVariable(vmCls, "_hasLoadBookShelf");
            if (ivar) {
                const char *enc = ivar_getTypeEncoding(ivar);
                if (enc && (enc[0] == 'B' || enc[0] == 'c')) {
                    hostLoaded = *((const uint8_t *)(__bridge void *)vm + ivar_getOffset(ivar)) != 0;
                }
            }
        }
    }
    CFTimeInterval sinceLaunch = FQXCleanupLaunchTime > 0.0 ? (now - FQXCleanupLaunchTime) : now;
    CFTimeInterval sinceAppear = now - appearTime;
    if (!hostLoaded && sinceAppear < 2.0) return YES;
    if (sinceLaunch < 3.0 && sinceAppear < 1.35) return YES;
    objc_setAssociatedObject(controller, &ShelfColdStartDoneKey, @YES, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
    return NO;
}

static void ShelfSetColdStartEmptyMuted(id controller, UIView *view, BOOL mute) {
    if (![view isKindOfClass:UIView.class]) return;
    if (mute) {
        if (view.alpha > 0.001) {
            objc_setAssociatedObject(view, &ShelfColdStartViewMutedKey, @YES, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
            view.alpha = 0.0;
        }
        if (controller) {
            NSHashTable *views = objc_getAssociatedObject(controller, &ShelfColdStartMutedViewsKey);
            if (!views) {
                views = [NSHashTable weakObjectsHashTable];
                objc_setAssociatedObject(controller, &ShelfColdStartMutedViewsKey, views, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
            }
            [views addObject:view];
        }
    } else if (objc_getAssociatedObject(view, &ShelfColdStartViewMutedKey)) {
        if (view.alpha < 0.999) view.alpha = 1.0;
        objc_setAssociatedObject(view, &ShelfColdStartViewMutedKey, nil, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
    }
}

static void ShelfRestoreColdStartMutedViews(id controller, BOOL allowHeaderRefresh) {
    if (!controller) return;
    NSHashTable *views = objc_getAssociatedObject(controller, &ShelfColdStartMutedViewsKey);
    if (!views) return;
    NSArray *snapshot = [views allObjects];
    objc_setAssociatedObject(controller, &ShelfColdStartMutedViewsKey, nil, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
    BOOL restoredAny = NO;
    for (UIView *view in snapshot) {
        if ([view isKindOfClass:UIView.class] && objc_getAssociatedObject(view, &ShelfColdStartViewMutedKey)) {
            if (view.alpha < 0.999) view.alpha = 1.0;
            objc_setAssociatedObject(view, &ShelfColdStartViewMutedKey, nil, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
            restoredAny = YES;
        }
    }
    if (restoredAny && allowHeaderRefresh) {
        __weak id weakController = controller;
        dispatch_async(dispatch_get_main_queue(), ^{
            id strongController = weakController;
            if (!strongController) return;
            UIView *cv = HostObject(strongController, @selector(collectionView));
            if ([cv isKindOfClass:UICollectionView.class]) ShelfRefreshVisibleHeaderLayout(cv);
        });
    }
}

static void ShelfEnsureColdStartRestoreTimer(id controller) {
    if (!controller || [objc_getAssociatedObject(controller, &ShelfColdStartTimerKey) boolValue]) return;
    objc_setAssociatedObject(controller, &ShelfColdStartTimerKey, @YES, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
    __weak id weakController = controller;
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1.35 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        id strongController = weakController;
        if (!strongController) return;
        objc_setAssociatedObject(strongController, &ShelfColdStartDoneKey, @YES, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
        ShelfRestoreColdStartMutedViews(strongController, YES);
    });
}

static BOOL ShelfColdStartSyncInFlight = NO;

static void ShelfSyncColdStartVisibility(id controller, id collectionViewObj) {
    if (!controller || ShelfColdStartSyncInFlight) return;
    ShelfColdStartSyncInFlight = YES;
    UIView *cv = [collectionViewObj isKindOfClass:UIView.class]
        ? (UIView *)collectionViewObj
        : HostObject(controller, @selector(collectionView));
    if (!ShelfIsInColdStartEmptyGrace(controller, cv)) {
        ShelfRestoreColdStartMutedViews(controller, YES);
        ShelfColdStartSyncInFlight = NO;
        return;
    }

    if ([cv isKindOfClass:UICollectionView.class]) {
        UICollectionView *collection = (UICollectionView *)cv;
        if (collection.backgroundView && ShelfViewIsEmptyBookPlaceholder(collection.backgroundView, 0)) {
            ShelfSetColdStartEmptyMuted(controller, collection.backgroundView, YES);
        }
        for (UIView *sub in collection.subviews) {
            if (ShelfViewIsEmptyBookPlaceholder(sub, 0)) {
                ShelfSetColdStartEmptyMuted(controller, sub, YES);
            }
        }
    }
    if ([controller isKindOfClass:UIViewController.class] && [(UIViewController *)controller isViewLoaded]) {
        UIView *rootView = [(UIViewController *)controller view];
        for (UIView *sub in rootView.subviews) {
            if (sub == cv || [sub isKindOfClass:UICollectionView.class]) continue;
            if (ShelfViewIsEmptyBookPlaceholder(sub, 0)) {
                ShelfSetColdStartEmptyMuted(controller, sub, YES);
            }
        }
    }

    ShelfEnsureColdStartRestoreTimer(controller);
    ShelfColdStartSyncInFlight = NO;
}

static void (*NativeShelfWillAppear)(id, SEL, BOOL);
static void ShelfWillAppear(id owner, SEL cmd, BOOL animated) {
    LastShelf = owner;
    if (NativeShelfWillAppear) NativeShelfWillAppear(owner, cmd, animated);
    ShelfSyncColdStartVisibility(owner, nil);
}

static void (*NativeShelfAppeared)(id, SEL, BOOL);
static void ShelfAppeared(id owner, SEL cmd, BOOL animated) {
    LastShelf = owner;
    if (NativeShelfAppeared) NativeShelfAppeared(owner, cmd, animated);
    ShelfSyncColdStartVisibility(owner, nil);
}

static char ShelfRecSectionsKey;
static char ShelfRecTypesKey;
static char ShelfRecBookSectionKey;
static char ShelfRecReloadPendingKey;
static char ShelfRecHiddenViewsKey;
static char ShelfRecHiddenFlagKey;
static char ShelfUtilityHiddenMapKey;
static char ShelfUtilityNativeCountsKey;
static char ShelfUtilityFilterStampKey;

typedef NS_ENUM(NSInteger, FQXShelfUtilityKind) {
    FQXShelfUtilityNone = 0,
    FQXShelfUtilityLocalImport = 1,
    FQXShelfUtilityHistoryCard = 2,
};

static BOOL ShelfStringHasNonEmptyBookId(id obj) {
    if ([obj isKindOfClass:NSString.class]) return [(NSString *)obj length] > 0;
    if ([obj isKindOfClass:NSNumber.class]) return [(NSNumber *)obj longLongValue] > 0;
    return NO;
}

static BOOL ShelfModelIsRealBook(id model) {
    if (!model) return NO;
    if (ShelfStringHasNonEmptyBookId(HostObject(model, @selector(bookId)))) return YES;
    id data = HostObject(model, @selector(data)) ?: HostObject(model, @selector(bookData));
    if (ShelfStringHasNonEmptyBookId(HostObject(data, @selector(bookId)))) return YES;
    id collects = HostObject(model, @selector(collectDatas));
    if ([collects isKindOfClass:NSArray.class] && [(NSArray *)collects count] > 0) {
        id first = [(NSArray *)collects firstObject];
        if (ShelfStringHasNonEmptyBookId(HostObject(first, @selector(bookId)))) return YES;
    }
    return NO;
}

static FQXShelfUtilityKind ShelfUtilityKindFromViewText(UIView *view, NSInteger depth) {
    if (![view isKindOfClass:UIView.class] || depth > 5) return FQXShelfUtilityNone;
    NSString *text = nil;
    if ([view isKindOfClass:UILabel.class]) {
        UILabel *label = (UILabel *)view;
        text = label.text.length ? label.text : label.attributedText.string;
    } else if ([view isKindOfClass:UIButton.class]) {
        text = [(UIButton *)view titleForState:UIControlStateNormal];
    }
    if (text.length) {
        if ([text containsString:@"导入本地书"] || [text containsString:@"畅享免费听书"] ||
            [text containsString:@"从本机导入"]) {
            return FQXShelfUtilityLocalImport;
        }
        if ([text containsString:@"去浏览历史"] || [text containsString:@"看更多书籍"]) {
            return FQXShelfUtilityHistoryCard;
        }
    }
    for (UIView *sub in view.subviews) {
        FQXShelfUtilityKind kind = ShelfUtilityKindFromViewText(sub, depth + 1);
        if (kind != FQXShelfUtilityNone) return kind;
    }
    return FQXShelfUtilityNone;
}

static FQXShelfUtilityKind ShelfUtilityKindForModel(id model) {
    if (!model || ShelfModelIsRealBook(model)) return FQXShelfUtilityNone;
    NSString *lower = NSStringFromClass([model class]).lowercaseString ?: @"";
    if ([lower containsString:@"localbook"] || [lower containsString:@"local_book"] ||
        [lower containsString:@"entryadd"] || [lower containsString:@"addbook"]) {
        return FQXShelfUtilityLocalImport;
    }
    if ([lower containsString:@"historycard"] || [lower containsString:@"browsehistory"] ||
        [lower containsString:@"historyentry"] || [lower containsString:@"morehistory"]) {
        return FQXShelfUtilityHistoryCard;
    }
    for (NSString *prop in @[@"title", @"text", @"name", @"subTitle", @"tips"]) {
        id val = HostObject(model, NSSelectorFromString(prop));
        if (![val isKindOfClass:NSString.class]) continue;
        NSString *s = (NSString *)val;
        if ([s containsString:@"导入本地书"] || [s containsString:@"畅享免费听书"] || [s containsString:@"从本机导入"]) {
            return FQXShelfUtilityLocalImport;
        }
        if ([s containsString:@"去浏览历史"] || [s containsString:@"看更多书籍"]) {
            return FQXShelfUtilityHistoryCard;
        }
    }
    return FQXShelfUtilityNone;
}

static FQXShelfUtilityKind ShelfUtilityKindForCell(id cell) {
    if (![cell isKindOfClass:UIView.class]) return FQXShelfUtilityNone;
    Class funcCls = objc_lookUpClass("SSBookShelfFunctionCell");
    if (funcCls && [cell isKindOfClass:funcCls]) return FQXShelfUtilityNone;
    id model = HostObject(cell, sel_registerName("cellModel")) ?: HostObject(cell, sel_registerName("model"));
    if (ShelfModelIsRealBook(model)) return FQXShelfUtilityNone;
    FQXShelfUtilityKind modelKind = ShelfUtilityKindForModel(model);
    if (modelKind != FQXShelfUtilityNone) return modelKind;
    NSString *cellLower = NSStringFromClass([cell class]).lowercaseString ?: @"";
    if ([cellLower containsString:@"localbook"] || [cellLower containsString:@"local_book"] ||
        [cellLower containsString:@"entryadd"] || [cellLower containsString:@"addbook"]) {
        return FQXShelfUtilityLocalImport;
    }
    if ([cellLower containsString:@"historycard"] || [cellLower containsString:@"browsehistory"] ||
        [cellLower containsString:@"historyentry"] || [cellLower containsString:@"morehistory"]) {
        return FQXShelfUtilityHistoryCard;
    }
    return ShelfUtilityKindFromViewText((UIView *)cell, 0);
}

static BOOL ShelfShouldHideUtilityKind(FQXShelfUtilityKind kind) {
    if (kind == FQXShelfUtilityLocalImport) return !Option(ShelfImportKey, YES);
    if (kind == FQXShelfUtilityHistoryCard) return !Option(ShelfHistoryCardKey, YES);
    return NO;
}

static void ShelfUtilityResetController(id controller) {
    if (!controller) return;
    objc_setAssociatedObject(controller, &ShelfUtilityHiddenMapKey, nil, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
    objc_setAssociatedObject(controller, &ShelfUtilityNativeCountsKey, nil, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
    objc_setAssociatedObject(controller, &ShelfUtilityFilterStampKey, nil, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

static NSMutableIndexSet *ShelfUtilityHiddenSetForSection(id controller, NSInteger section, NSInteger nativeCount, BOOL create) {
    if (!controller || section < 0) return nil;
    NSInteger stamp = (Option(ShelfImportKey, YES) ? 1 : 0) | (Option(ShelfHistoryCardKey, YES) ? 2 : 0);
    NSNumber *prevStamp = objc_getAssociatedObject(controller, &ShelfUtilityFilterStampKey);
    if (!prevStamp || prevStamp.integerValue != stamp) {
        ShelfUtilityResetController(controller);
        objc_setAssociatedObject(controller, &ShelfUtilityFilterStampKey, @(stamp), OBJC_ASSOCIATION_RETAIN_NONATOMIC);
    }
    NSMutableDictionary *counts = objc_getAssociatedObject(controller, &ShelfUtilityNativeCountsKey);
    NSMutableDictionary *map = objc_getAssociatedObject(controller, &ShelfUtilityHiddenMapKey);
    if (!counts) {
        if (!create) return nil;
        counts = [NSMutableDictionary dictionary];
        objc_setAssociatedObject(controller, &ShelfUtilityNativeCountsKey, counts, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
    }
    if (!map) {
        if (!create) return nil;
        map = [NSMutableDictionary dictionary];
        objc_setAssociatedObject(controller, &ShelfUtilityHiddenMapKey, map, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
    }
    NSNumber *key = @(section);
    NSNumber *prevCount = counts[key];
    if (nativeCount >= 0 && (!prevCount || prevCount.integerValue != nativeCount)) {
        counts[key] = @(nativeCount);
        [map removeObjectForKey:key];
    }
    NSMutableIndexSet *set = map[key];
    if (!set && create) {
        set = [NSMutableIndexSet indexSet];
        map[key] = set;
    }
    return set;
}

static void ShelfUtilityPrepopulateBookSection(id controller, NSInteger section, NSInteger nativeCount) {
    if (!controller || nativeCount <= 0) return;
    if (Option(ShelfImportKey, YES) && Option(ShelfHistoryCardKey, YES)) return;
    if (ShelfRecSectionType(controller, section) != 4) return;
    id vm = HostObject(controller, sel_registerName("viewModel"));
    id models = HostObject(vm, sel_registerName("showCellModels"));
    if (![models isKindOfClass:NSArray.class]) return;
    NSArray *arr = (NSArray *)models;
    if ((NSInteger)arr.count != nativeCount) return;
    NSMutableIndexSet *set = ShelfUtilityHiddenSetForSection(controller, section, nativeCount, YES);
    for (NSUInteger i = 0; i < arr.count; ++i) {
        FQXShelfUtilityKind kind = ShelfUtilityKindForModel(arr[i]);
        if (ShelfShouldHideUtilityKind(kind)) [set addIndex:i];
    }
}

static NSInteger ShelfUtilityNativeItemForVisibleItem(id controller, id collectionView, NSInteger section, NSInteger visibleItem) {
    if (visibleItem < 0) return visibleItem;
    if (Option(ShelfImportKey, YES) && Option(ShelfHistoryCardKey, YES)) return visibleItem;
    if (ShelfRecSectionType(controller, section) == 1) return visibleItem;
    NSInteger nativeCount = NativeShelfNumberOfItems ? NativeShelfNumberOfItems(controller, @selector(collectionView:numberOfItemsInSection:), collectionView, section) : -1;
    NSMutableIndexSet *set = ShelfUtilityHiddenSetForSection(controller, section, nativeCount, NO);
    if (!set.count || nativeCount <= 0) return visibleItem;
    NSInteger seenVisible = 0;
    for (NSInteger nativeIdx = 0; nativeIdx < nativeCount; ++nativeIdx) {
        if ([set containsIndex:(NSUInteger)nativeIdx]) continue;
        if (seenVisible == visibleItem) return nativeIdx;
        seenVisible++;
    }
    return visibleItem;
}

static void ShelfRecScheduleReload(id controller, id collectionView);

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
    id vm = HostObject(controller, @selector(viewModel));
    SEL sel = @selector(sectionTypeAtIndex:);
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
        if (strongCV && strongController &&
            (!Option(ShelfRecommendationsKey, YES) || !Option(ShelfImportKey, YES) || !Option(ShelfHistoryCardKey, YES))) {
            [strongCV reloadData];
        }
    });
}

static NSInteger ShelfRecNumberOfSections(id self, SEL cmd, id collectionView) {
    LastShelf = self;
    if (![objc_getAssociatedObject(self, &ShelfColdStartDoneKey) boolValue] &&
        !ShelfIsInColdStartEmptyGrace(self, collectionView)) {
        ShelfRestoreColdStartMutedViews(self, NO);
    }
    objc_setAssociatedObject(self, &ShelfRecReloadPendingKey, nil, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
    if (Option(ShelfImportKey, YES) && Option(ShelfHistoryCardKey, YES)) {
        ShelfUtilityResetController(self);
    }
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

static NSInteger ShelfRecNumberOfItems(id self, SEL cmd, id collectionView, NSInteger section) {
    LastShelf = self;
    if (ShelfRecIsSectionHidden(self, section)) return 0;
    NSInteger nativeCount = NativeShelfNumberOfItems(self, cmd, collectionView, section);
    if ((!Option(ShelfImportKey, YES) || !Option(ShelfHistoryCardKey, YES)) &&
        ShelfRecSectionType(self, section) != 1 && nativeCount > 0) {
        ShelfUtilityPrepopulateBookSection(self, section, nativeCount);
        NSMutableIndexSet *hiddenSet = ShelfUtilityHiddenSetForSection(self, section, nativeCount, YES);
        NSInteger hidden = (NSInteger)hiddenSet.count;
        if (hidden > 0 && hidden <= nativeCount) return nativeCount - hidden;
    }
    return nativeCount;
}

static id (*NativeShelfCellForItem)(id, SEL, id, NSIndexPath *);
static id ShelfRecCellForItem(id self, SEL cmd, id collectionView, NSIndexPath *indexPath) {
    LastShelf = self;
    NSIndexPath *queryIP = indexPath;
    if (indexPath && (!Option(ShelfImportKey, YES) || !Option(ShelfHistoryCardKey, YES))) {
        NSInteger mapped = ShelfUtilityNativeItemForVisibleItem(self, collectionView, indexPath.section, indexPath.item);
        if (mapped != indexPath.item) {
            queryIP = [NSIndexPath indexPathForItem:mapped inSection:indexPath.section];
        }
    }
    id cell = NativeShelfCellForItem(self, cmd, collectionView, queryIP);
    id model = HostObject(cell, @selector(cellModel)) ?: HostObject(cell, @selector(model));
    if (ShelfModelIsRealBook(model)) {
        if (![objc_getAssociatedObject(self, &ShelfColdStartDoneKey) boolValue]) {
            objc_setAssociatedObject(self, &ShelfColdStartSawRealBookKey, @YES, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
            objc_setAssociatedObject(self, &ShelfColdStartDoneKey, @YES, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
            ShelfRestoreColdStartMutedViews(self, NO);
        }
        if (objc_getAssociatedObject(cell, &ShelfColdStartViewMutedKey)) {
            ShelfSetColdStartEmptyMuted(self, cell, NO);
        }
    } else if (ShelfIsInColdStartEmptyGrace(self, collectionView) &&
               ShelfViewIsEmptyBookPlaceholder(cell, 0)) {
        ShelfSetColdStartEmptyMuted(self, cell, YES);
        ShelfEnsureColdStartRestoreTimer(self);
    } else if (objc_getAssociatedObject(cell, &ShelfColdStartViewMutedKey)) {
        ShelfSetColdStartEmptyMuted(self, cell, NO);
    }

    NSInteger section = queryIP.section;
    NSInteger stype = ShelfRecSectionType(self, section);
    if (stype != 1 && (!Option(ShelfImportKey, YES) || !Option(ShelfHistoryCardKey, YES))) {
        FQXShelfUtilityKind kind = ShelfUtilityKindForCell(cell);
        if (ShelfShouldHideUtilityKind(kind)) {
            NSInteger nativeCount = NativeShelfNumberOfItems ? NativeShelfNumberOfItems(self, @selector(collectionView:numberOfItemsInSection:), collectionView, section) : -1;
            NSMutableIndexSet *hiddenSet = ShelfUtilityHiddenSetForSection(self, section, nativeCount, YES);
            BOOL newlyAdded = (queryIP.item >= 0 && ![hiddenSet containsIndex:(NSUInteger)queryIP.item]);
            if (newlyAdded) [hiddenSet addIndex:(NSUInteger)queryIP.item];
            ShelfRecHideView(self, cell, YES);
            if (newlyAdded) ShelfRecScheduleReload(self, collectionView);
            return cell;
        }
    }
    if (Option(ShelfRecommendationsKey, YES)) {
        ShelfRecHideView(self, cell, NO);
        return cell;
    }
    NSString *clsName = NSStringFromClass([cell class]).lowercaseString ?: @"";
    NSString *modelName = model ? (NSStringFromClass([model class]).lowercaseString ?: @"") : @"";
    static Class baseBookCls = Nil;
    static Class funcCls = Nil;
    static dispatch_once_t cellOnce;
    dispatch_once(&cellOnce, ^{
        baseBookCls = objc_lookUpClass("SSBookShelfBaseCell");
        funcCls = objc_lookUpClass("SSBookShelfFunctionCell");
    });
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

static void (*NativeShelfDidSelectItem)(id, SEL, id, NSIndexPath *);
static void ShelfRecDidSelectItem(id self, SEL cmd, id collectionView, NSIndexPath *indexPath) {
    NSIndexPath *mappedIP = indexPath;
    if (indexPath && (!Option(ShelfImportKey, YES) || !Option(ShelfHistoryCardKey, YES))) {
        NSInteger mapped = ShelfUtilityNativeItemForVisibleItem(self, collectionView, indexPath.section, indexPath.item);
        if (mapped != indexPath.item) {
            mappedIP = [NSIndexPath indexPathForItem:mapped inSection:indexPath.section];
        }
    }
    if (NativeShelfDidSelectItem) NativeShelfDidSelectItem(self, cmd, collectionView, mappedIP);
}

static id (*NativeShelfSupplementaryView)(id, SEL, id, id, NSIndexPath *);
static id ShelfRecSupplementaryView(id self, SEL cmd, id collectionView, id kind, NSIndexPath *indexPath) {
    id view = NativeShelfSupplementaryView(self, cmd, collectionView, kind, indexPath);
    if (ShelfIsInColdStartEmptyGrace(self, collectionView) && ShelfViewIsEmptyBookPlaceholder(view, 0)) {
        ShelfSetColdStartEmptyMuted(self, view, YES);
        ShelfEnsureColdStartRestoreTimer(self);
    } else if (objc_getAssociatedObject(view, &ShelfColdStartViewMutedKey)) {
        ShelfSetColdStartEmptyMuted(self, view, NO);
    }
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
    NSIndexPath *queryIP = indexPath;
    if (indexPath && (!Option(ShelfImportKey, YES) || !Option(ShelfHistoryCardKey, YES))) {
        NSInteger mapped = ShelfUtilityNativeItemForVisibleItem(self, collectionView, indexPath.section, indexPath.item);
        if (mapped != indexPath.item) {
            queryIP = [NSIndexPath indexPathForItem:mapped inSection:indexPath.section];
        }
    }
    return NativeShelfSizeForItem(self, cmd, collectionView, layout, queryIP);
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
static void (*NativeMineUpdateLayout)(id, SEL);
static CGRect (*NativePublishPinFrame)(id, SEL);
static NSMapTable<UIView *, UIViewController *> *MinePublishOwners;

static CGRect MinePublishFrame(UIViewController *owner, UIView *parent, CGRect frame) {
    CGRect safe = [owner.view convertRect:owner.view.safeAreaLayoutGuide.layoutFrame toView:parent];
    if (CGRectGetWidth(safe) < CGRectGetWidth(frame) + 24.0 ||
        CGRectGetHeight(safe) < CGRectGetHeight(frame) + 90.0) return frame;

    BOOL reduced = !Option(MineRecommendationsKey, YES) || !Option(MineBenefitsKey, YES) ||
        !Option(@"FanqieX.MineContinueDrama.1", YES);
    if (!reduced && CGRectContainsRect(safe, frame)) return frame;
    CGFloat bottom = CGRectGetMaxY(safe) - 64.0;
    UITabBar *dock = owner.tabBarController.tabBar;
    if (dock.window && dock.window == parent.window && !dock.hidden) {
        CGRect dockFrame = [dock convertRect:dock.bounds toView:parent];
        if (CGRectGetMaxY(dockFrame) >= CGRectGetMaxY(safe) - 10.0)
            bottom = CGRectGetMinY(dockFrame);
    }
    frame.origin.x = CGRectGetMaxX(safe) - CGRectGetWidth(frame) - 12.0;
    frame.origin.y = bottom - CGRectGetHeight(frame) - 12.0;
    return frame;
}

static void PlaceMinePublishButton(UIViewController *owner) {
    if (!MinePublishButton || !owner.isViewLoaded) return;
    UIView *button = object_getIvar(owner, MinePublishButton);
    if (!button.superview || button.hidden || !button.window || button.window != owner.view.window) return;
    CGRect frame = MinePublishFrame(owner, button.superview, button.frame);
    if (!CGRectEqualToRect(button.frame, frame)) button.frame = frame;
}

static CGRect MinePublishPinFrame(UIView *button, SEL cmd) {
    CGRect frame = NativePublishPinFrame(button, cmd);
    UIViewController *owner = [MinePublishOwners objectForKey:button];
    UIWindow *window = button.window;
    if (!window || !owner.isViewLoaded || window != owner.view.window || CGRectIsEmpty(frame)) return frame;
    return MinePublishFrame(owner, window, frame);
}

static void MineUpdateLayout(id owner, SEL cmd) {
    NativeMineUpdateLayout(owner, cmd);
    PlaceMinePublishButton(owner);
}

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
    if (!MinePublishOwners) MinePublishOwners = [NSMapTable weakToWeakObjectsMapTable];
    [MinePublishOwners setObject:owner forKey:button];
    BOOL hide = !Option(MinePublishKey, YES);
    objc_setAssociatedObject(button, &MineOriginalHidden, hide ? @(button.hidden) : nil, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
    if (hide) button.hidden = YES;
    else PlaceMinePublishButton(owner);
}

static BOOL (*NativeShelfShouldShowNotify)(id, SEL);
static BOOL ShelfShouldShowNotify(id model, SEL cmd) {
    BOOL show = NativeShelfShouldShowNotify(model, cmd);
    if (!show || Option(ShelfActivityNoticeKey, YES)) return show;
    id notify = HostObject(model, sel_registerName("notifyModel"));
    SEL login = sel_registerName("shouldShowLoginTips");
    return HostMethod(object_getClass(notify), login, "B16@0:8") &&
        ((BOOL (*)(id, SEL))objc_msgSend)(notify, login);
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
    id ui = HostObject(manager, sel_registerName("UIMgr"));
    Class cls = object_getClass(ui);
    if (!HostMethod(cls, sel_registerName("isToolViewShow"), "B16@0:8") ||
        !HostMethod(cls, sel_registerName("enterAutoReadMode"), "v16@0:8") ||
        !HostMethod(cls, sel_registerName("exitAutoReadMode:"), "v20@0:8i16")) return nil;
    return ui;
}

static BOOL (*NativeShouldRecognize)(id, SEL);
static BOOL ShouldRecognize(id manager, SEL cmd) {
    if (NativeShouldRecognize(manager, cmd)) return YES;
    if (!Option(DoubleTapKey, NO)) return NO;
    id ui = AutoReadUI(manager);
    SEL isToolViewShow = sel_registerName("isToolViewShow");
    return ui && !((BOOL (*)(id, SEL))objc_msgSend)(ui, isToolViewShow);
}

static void (*NativeDoubleTap)(id, SEL, id, id);
static void ToggleAutoRead(id manager, SEL cmd, id view, id event) {
    id ui = Option(DoubleTapKey, NO) ? AutoReadUI(manager) : nil;
    id config = HostObject(ui, sel_registerName("config"));
    SEL active = sel_registerName("isAutoRead");
    if (!ui || !HostMethod(object_getClass(config), active, "B16@0:8")) {
        NativeDoubleTap(manager, cmd, view, event);
        return;
    }
    if (((BOOL (*)(id, SEL))objc_msgSend)(ui, sel_registerName("isToolViewShow"))) return;
    if (((BOOL (*)(id, SEL))objc_msgSend)(config, active)) {
        ((void (*)(id, SEL, int))objc_msgSend)(ui, sel_registerName("exitAutoReadMode:"), -102);
    } else {
        // The native entry reads both existing settings views. They may not
        // have been constructed when the gesture starts the first session.
        for (NSString *name in @[@"createSettingViewIfNeeded", @"createAutoReadRateViewIfNeeded"]) {
            SEL initialize = NSSelectorFromString(name);
            if (HostMethod(object_getClass(ui), initialize, "v16@0:8")) {
                ((void (*)(id, SEL))objc_msgSend)(ui, initialize);
            }
        }
        ((void (*)(id, SEL))objc_msgSend)(ui, sel_registerName("enterAutoReadMode"));
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
                            @"FanqieX.BottomDisplayMode.1",
                            @"FanqieX.BottomLengthScale.1", @"FanqieX.BottomHeightScale.1",
                            @"FanqieX.BottomButtonWidthScale.1", @"FanqieX.BottomIconPointSize.1",
                            @"FanqieX.MineQuickIconsOnly.1", MineScanButtonKey, MineSearchBarKey, MineNightButtonKey, MineShortcutCardKey,
                            MineRecommendationsKey, MineBenefitsKey, @"FanqieX.MineContinueDrama.1"]) {
        [values addObject:[defaults objectForKey:key] ?: NSNull.null];
    }
    return values;
}

static void ResetNestedScrollViewsInMine(UIView *view, NSInteger depth) {
    if (!view || depth > 6) return;
    for (UIView *sub in view.subviews) {
        if ([sub isKindOfClass:UIScrollView.class]) {
            UIScrollView *sv = (UIScrollView *)sub;
            if (!sv.dragging && !sv.decelerating) {
                CGFloat innerTop = -sv.adjustedContentInset.top;
                if (fabs(sv.contentOffset.y - innerTop) > 0.5) {
                    [sv setContentOffset:CGPointMake(sv.contentOffset.x, innerTop) animated:NO];
                }
            }
        }
        ResetNestedScrollViewsInMine(sub, depth + 1);
    }
}

static void RestoreMinePosition(UIViewController *controller) {
    if (!controller || controller.presentedViewController || FQXDiagHasActiveSecurityVerificationInWindows()) {
        return;
    }
    UIScrollView *list = HostObject(controller, sel_registerName("collectionView"));
    if (![list isKindOfClass:UIScrollView.class] || list.dragging || list.decelerating) return;
    if ([list isKindOfClass:UICollectionView.class]) {
        [((UICollectionView *)list).collectionViewLayout invalidateLayout];
    }
    [controller.view setNeedsLayout];
    [controller.view layoutIfNeeded];
    ResetNestedScrollViewsInMine(list, 0);
    CGPoint top = list.contentOffset;
    top.y = -list.adjustedContentInset.top;
    if (fabs(list.contentOffset.y - top.y) > 0.5) [list setContentOffset:top animated:NO];
    PlaceMinePublishButton(controller);
}

static void ScheduleMinePositionSettle(UIViewController *controller) {
    if (!controller) return;
    __weak UIViewController *weakVC = controller;
    dispatch_async(dispatch_get_main_queue(), ^{
        UIViewController *strongVC = weakVC;
        if (strongVC && strongVC.isViewLoaded && strongVC.view.window) RestoreMinePosition(strongVC);
    });
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.12 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        UIViewController *strongVC = weakVC;
        if (strongVC && strongVC.isViewLoaded && strongVC.view.window) RestoreMinePosition(strongVC);
    });
}

static void (*NativeMineWillAppear)(id, SEL, BOOL);
static void MineWillAppear(id owner, SEL cmd, BOOL animated) {
    if (NativeMineWillAppear) NativeMineWillAppear(owner, cmd, animated);
    LastMine = owner;
    UIView *bar = HostObject(owner, sel_registerName("myUserBar")) ?: CleanupIvarObject(owner, "_myUserBar");
    if ([bar isKindOfClass:UIView.class]) {
        [bar setNeedsLayout];
    }
    NSArray *current = MineGlassPreferences();
    NSArray *previous = objc_getAssociatedObject(owner, &MineGlassPreferencesKey);
    objc_setAssociatedObject(owner, &MineGlassPreferencesKey, current, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
    if (previous && ![previous isEqualToArray:current]) {
        objc_setAssociatedObject(owner, &MineGlassPositionPendingKey, @YES, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
        RestoreMinePosition(owner);
        ScheduleMinePositionSettle(owner);
    }
}

static void (*NativeMineDidAppear)(id, SEL, BOOL);
static void MineDidAppear(id owner, SEL cmd, BOOL animated) {
    NativeMineDidAppear(owner, cmd, animated);
    if (objc_getAssociatedObject(owner, &MineGlassPositionPendingKey)) {
        objc_setAssociatedObject(owner, &MineGlassPositionPendingKey, nil, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
        RestoreMinePosition(owner);
        ScheduleMinePositionSettle(owner);
    }
}

static char DramaActionRequestedHiddenKey;
static char DramaRailAppliedShiftKey;
static NSMutableDictionary<NSString *, NSHashTable<UIView *> *> *DramaActionOwners;
static NSMutableSet<NSString *> *DramaRailHookedContainers;

static BOOL IsDramaRightActionView(UIView *view) {
    if (![view isKindOfClass:UIView.class]) return NO;
    static const char *const kRightActionClasses[] = {
        "SSShortVideoRightInteractionCollectView",
        "SSShortVideoRightInteractionCommentView",
        "SSShortVideoHostRightInteractionCommentView",
        "SSShortVideoRightInteractionLikeView",
        "SSShortVideoRightInteractionShareView",
        NULL
    };
    for (int i = 0; kRightActionClasses[i]; ++i) {
        Class cls = objc_lookUpClass(kRightActionClasses[i]);
        if (cls && [view isKindOfClass:cls]) return YES;
    }
    return NO;
}

static void CollectDramaRightActions(UIView *root, NSInteger depth, NSMutableArray<UIView *> *outActions) {
    if (![root isKindOfClass:UIView.class] || depth > 3) return;
    if (IsDramaRightActionView(root)) {
        [outActions addObject:root];
        return;
    }
    for (UIView *sub in root.subviews) {
        CollectDramaRightActions(sub, depth + 1, outActions);
    }
}

static UIView *SingleDramaRightActionInSlot(UIView *slot) {
    if (![slot isKindOfClass:UIView.class]) return nil;
    if (IsDramaRightActionView(slot)) return slot;
    NSMutableArray<UIView *> *found = [NSMutableArray array];
    CollectDramaRightActions(slot, 1, found);
    return found.count == 1 ? found.firstObject : nil;
}

static UIView *FindDramaRailRootForAction(UIView *actionView) {
    if (![actionView isKindOfClass:UIView.class]) return nil;
    UIView *cur = actionView.superview;
    for (NSInteger up = 0; up < 4 && cur; ++up, cur = cur.superview) {
        if ([cur isKindOfClass:UIWindow.class]) break;
        NSMutableArray<UIView *> *actions = [NSMutableArray array];
        CollectDramaRightActions(cur, 0, actions);
        if (actions.count >= 2) return cur;
    }
    return actionView.superview;
}

static void ReflowDramaRightInteractionRail(UIView *container) {
    if (![container isKindOfClass:UIView.class]) return;
    NSMutableArray<UIView *> *allSlots = [NSMutableArray array];
    NSMutableArray<UIView *> *slotActions = [NSMutableArray array];
    for (UIView *sub in container.subviews) {
        UIView *act = SingleDramaRightActionInSlot(sub);
        if (!act) continue;
        if (![container isKindOfClass:UIStackView.class] &&
            (CGRectGetWidth(sub.bounds) < 16.0 || CGRectGetHeight(sub.bounds) < 16.0)) {
            continue;
        }
        [allSlots addObject:sub];
        [slotActions addObject:act];
    }
    if (allSlots.count < 2) return;

    if ([container isKindOfClass:UIStackView.class]) {
        BOOL stackChanged = NO;
        for (NSUInteger i = 0; i < allSlots.count; ++i) {
            UIView *slot = allSlots[i];
            UIView *act = slotActions[i];
            if (slot != act) {
                BOOL wantHide = act.hidden || act.alpha <= 0.01;
                if (slot.hidden != wantHide) {
                    slot.hidden = wantHide;
                    stackChanged = YES;
                }
            }
        }
        if (stackChanged) [container setNeedsLayout];
        return;
    }

    NSMutableArray<NSDictionary *> *pairs = [NSMutableArray arrayWithCapacity:allSlots.count];
    for (NSUInteger i = 0; i < allSlots.count; ++i) {
        [pairs addObject:@{@"slot": allSlots[i], @"action": slotActions[i]}];
    }
    [pairs sortUsingComparator:^NSComparisonResult(NSDictionary *pa, NSDictionary *pb) {
        UIView *a = pa[@"slot"];
        UIView *b = pb[@"slot"];
        CGFloat ay = a.center.y;
        CGFloat by = b.center.y;
        if (fabs(ay - by) > 0.5) return ay < by ? NSOrderedAscending : NSOrderedDescending;
        return NSOrderedSame;
    }];

    NSMutableArray<UIView *> *sortedSlots = [NSMutableArray arrayWithCapacity:pairs.count];
    NSMutableArray<UIView *> *visibleSlots = [NSMutableArray arrayWithCapacity:pairs.count];
    for (NSDictionary *pair in pairs) {
        UIView *slot = pair[@"slot"];
        UIView *act = pair[@"action"];
        [sortedSlots addObject:slot];
        if (!slot.hidden && slot.alpha > 0.01 && !act.hidden && act.alpha > 0.01) {
            [visibleSlots addObject:slot];
        }
    }

    if (visibleSlots.count == 0 || visibleSlots.count == sortedSlots.count) {
        for (UIView *slot in sortedSlots) {
            if (objc_getAssociatedObject(slot, &DramaRailAppliedShiftKey)) {
                if (!CGAffineTransformIsIdentity(slot.transform)) {
                    slot.transform = CGAffineTransformIdentity;
                }
                objc_setAssociatedObject(slot, &DramaRailAppliedShiftKey, nil, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
            }
        }
        return;
    }

    NSUInteger n = sortedSlots.count;
    NSUInteger k = visibleSlots.count;
    for (UIView *slot in sortedSlots) {
        if ([visibleSlots containsObject:slot]) continue;
        if (objc_getAssociatedObject(slot, &DramaRailAppliedShiftKey)) {
            if (!CGAffineTransformIsIdentity(slot.transform)) {
                slot.transform = CGAffineTransformIdentity;
            }
            objc_setAssociatedObject(slot, &DramaRailAppliedShiftKey, nil, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
        }
    }
    for (NSUInteger i = 0; i < k; ++i) {
        UIView *vis = visibleSlots[i];
        UIView *targetSlot = sortedSlots[(n - k) + i];
        CGFloat targetBottom = targetSlot.center.y + CGRectGetHeight(targetSlot.bounds) * 0.5;
        CGFloat ownBottom = vis.center.y + CGRectGetHeight(vis.bounds) * 0.5;
        CGFloat dy = targetBottom - ownBottom;
        CGAffineTransform desired = fabs(dy) > 0.5
            ? CGAffineTransformMakeTranslation(0.0, dy)
            : CGAffineTransformIdentity;
        if (!CGAffineTransformEqualToTransform(vis.transform, desired)) {
            vis.transform = desired;
        }
        objc_setAssociatedObject(vis, &DramaRailAppliedShiftKey, @(dy), OBJC_ASSOCIATION_RETAIN_NONATOMIC);
    }
}

static void EnsureDramaRailContainerHooked(UIView *container) {
    if (![container isKindOfClass:UIView.class]) return;
    Class cls = object_getClass(container);
    if (!cls || cls == [UIView class] || cls == [UIStackView class]) return;
    if (!DramaRailHookedContainers) DramaRailHookedContainers = [NSMutableSet set];
    NSString *clsName = NSStringFromClass(cls);
    if (!clsName.length || [DramaRailHookedContainers containsObject:clsName]) return;
    [DramaRailHookedContainers addObject:clsName];
    SEL layoutSel = @selector(layoutSubviews);
    __block void (*origLayout)(id, SEL) = NULL;
    IMP hookLayout = imp_implementationWithBlock(^(UIView *selfView) {
        if (origLayout) origLayout(selfView, layoutSel);
        ReflowDramaRightInteractionRail(selfView);
    });
    if (!FQXInstallOwnedHook(cls, layoutSel, NO, "v16@0:8", hookLayout, (IMP *)&origLayout)) {
        imp_removeBlock(hookLayout);
    }
}

static void ReflowDramaRightInteractionRailForAction(UIView *actionView) {
    UIView *railRoot = FindDramaRailRootForAction(actionView);
    if (!railRoot) return;
    EnsureDramaRailContainerHooked(railRoot);
    ReflowDramaRightInteractionRail(railRoot);
}

static void InstallDramaActionVisibility(NSString *className, NSString *key) {
    Class cls = NSClassFromString(className);
    SEL hidden = @selector(setHidden:);
    SEL refresh = sel_registerName("refreshSubviews");
    if (!HostMethod(cls, hidden, "v20@0:8B16") || !HostMethod(cls, refresh, "v16@0:8")) return;
    if (!DramaActionOwners) DramaActionOwners = [NSMutableDictionary dictionary];
    NSHashTable<UIView *> *owners = DramaActionOwners[key];
    if (!owners) DramaActionOwners[key] = owners = [NSHashTable weakObjectsHashTable];

    __block void (*originalHidden)(id, SEL, BOOL);
    IMP hide = imp_implementationWithBlock(^(UIView *view, BOOL requested) {
        [owners addObject:view];
        objc_setAssociatedObject(view, &DramaActionRequestedHiddenKey, @(requested), OBJC_ASSOCIATION_RETAIN_NONATOMIC);
        originalHidden(view, hidden, requested || !Option(key, YES));
        ReflowDramaRightInteractionRailForAction(view);
    });
    if (!FQXInstallOwnedHook(cls, hidden, NO, "v20@0:8B16", hide, (IMP *)&originalHidden)) {
        imp_removeBlock(hide);
        return;
    }
    __block void (*originalRefresh)(id, SEL);
    IMP refreshView = imp_implementationWithBlock(^(UIView *view) {
        [owners addObject:view];
        originalRefresh(view, refresh);
        NSNumber *requested = objc_getAssociatedObject(view, &DramaActionRequestedHiddenKey);
        [view setHidden:requested ? requested.boolValue : view.hidden];
        ReflowDramaRightInteractionRailForAction(view);
    });
    if (!FQXInstallOwnedHook(cls, refresh, NO, "v16@0:8", refreshView, (IMP *)&originalRefresh))
        imp_removeBlock(refreshView);

    SEL layoutSel = @selector(layoutSubviews);
    if (HostMethod(cls, layoutSel, "v16@0:8")) {
        __block void (*originalLayout)(id, SEL) = NULL;
        IMP layoutView = imp_implementationWithBlock(^(UIView *view) {
            [owners addObject:view];
            if (originalLayout) originalLayout(view, layoutSel);
            ReflowDramaRightInteractionRailForAction(view);
        });
        if (!FQXInstallOwnedHook(cls, layoutSel, NO, "v16@0:8", layoutView, (IMP *)&originalLayout)) {
            imp_removeBlock(layoutView);
        }
    }

    SEL moveWinSel = @selector(didMoveToWindow);
    if (HostMethod(cls, moveWinSel, "v16@0:8")) {
        __block void (*originalMoveWin)(id, SEL) = NULL;
        IMP moveWinView = imp_implementationWithBlock(^(UIView *view) {
            [owners addObject:view];
            if (originalMoveWin) originalMoveWin(view, moveWinSel);
            if (view.window) ReflowDramaRightInteractionRailForAction(view);
            Class style = objc_lookUpClass("FQXDramaActionStyle");
            SEL update = sel_registerName("refreshOwner:");
            if ([style respondsToSelector:update])
                ((void (*)(id, SEL, id))objc_msgSend)(style, update, view);
        });
        if (!FQXInstallOwnedHook(cls, moveWinSel, NO, "v16@0:8", moveWinView, (IMP *)&originalMoveWin)) {
            imp_removeBlock(moveWinView);
        }
    }
}

static BOOL gFQXDanmakuIsPhone = YES;

static NSInteger (*NativeDanmakuABStyle)(id, SEL);
static NSInteger HookDanmakuABStyle(id cls, SEL cmd) {
    NSInteger orig = NativeDanmakuABStyle ? NativeDanmakuABStyle(cls, cmd) : 0;
    if (FQXShouldUnlockShortVideoDanmaku(Option(DramaUnlockDanmakuKey, YES) ? 1 : 0, 0, 0) && orig <= 0) {
        return 1;
    }
    return orig;
}

static NSDictionary *(*NativeDanmakuConfig)(id, SEL);
static NSDictionary *HookDanmakuConfig(id cls, SEL cmd) {
    NSDictionary *cfg = NativeDanmakuConfig ? NativeDanmakuConfig(cls, cmd) : nil;
    if (!FQXShouldUnlockShortVideoDanmaku(Option(DramaUnlockDanmakuKey, YES) ? 1 : 0, 0, 0)) {
        return cfg;
    }
    if ([cfg isKindOfClass:NSDictionary.class]) {
        id disabled = cfg[@"disable_comic_video_danmaku"];
        if ([disabled respondsToSelector:@selector(boolValue)] && [disabled boolValue]) {
            NSMutableDictionary *patched = [cfg mutableCopy];
            patched[@"disable_comic_video_danmaku"] = @NO;
            return patched;
        }
        return cfg;
    }
    return [@{@"disable_comic_video_danmaku": @NO} mutableCopy];
}

static BOOL (*NativeEnableNewGenreDanmaku)(id, SEL);
static BOOL HookEnableNewGenreDanmaku(id self, SEL cmd) {
    BOOL orig = NativeEnableNewGenreDanmaku ? NativeEnableNewGenreDanmaku(self, cmd) : NO;
    if (FQXShouldUnlockShortVideoDanmaku(Option(DramaUnlockDanmakuKey, YES) ? 1 : 0, 0, 0) &&
        gFQXDanmakuIsPhone) {
        return YES;
    }
    return orig;
}

static NSNumber *(*NativeDanmakuSupportAll)(id, SEL);
static NSNumber *HookDanmakuSupportAll(id self, SEL cmd) {
    if (FQXShouldUnlockShortVideoDanmaku(Option(DramaUnlockDanmakuKey, YES) ? 1 : 0, 0, 0)) {
        return @YES;
    }
    return NativeDanmakuSupportAll ? NativeDanmakuSupportAll(self, cmd) : @NO;
}

static void InstallDramaDanmakuUnlockHooks(void) {
    gFQXDanmakuIsPhone = (UIDevice.currentDevice.userInterfaceIdiom == UIUserInterfaceIdiomPhone);
    Class cls = objc_lookUpClass("FQCShortVideoDanmakuABSetting");
    if (!cls) return;
    FQXInstallOwnedHook(cls, sel_registerName("shortVideoDanmakuABStyle"), YES, "q16@0:8",
                        (IMP)HookDanmakuABStyle, (IMP *)&NativeDanmakuABStyle);
    FQXInstallOwnedHook(cls, sel_registerName("danmakuConfig"), YES, "@16@0:8",
                        (IMP)HookDanmakuConfig, (IMP *)&NativeDanmakuConfig);
    FQXInstallOwnedHook(cls, sel_registerName("enableNewGenreDanmaku"), NO, "B16@0:8",
                        (IMP)HookEnableNewGenreDanmaku, (IMP *)&NativeEnableNewGenreDanmaku);
    FQXInstallOwnedHook(cls, sel_registerName("supportAll"), NO, "@16@0:8",
                        (IMP)HookDanmakuSupportAll, (IMP *)&NativeDanmakuSupportAll);
}

static void RefreshMineViewsInSubtree(UIView *view) {
    if (![view isKindOfClass:UIView.class]) return;
    Class barCls = objc_lookUpClass("SSMyUserBar");
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
    NSDictionary<NSString *, id> *dict = ud.dictionaryRepresentation;
    NSSet<NSString *> *retiredExact = [NSSet setWithObjects:
        @"FanqieX.CommentGlassFrosted.1",
        @"FanqieX.CommentMaterialMode.1",
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
            if (!aggressiveLogs && ([name isEqualToString:@"hub-active.jsonl"] || [name isEqualToString:@"hub-prev.jsonl"])) {
                return NO;
            }
            if ([name hasSuffix:@".tmp"] || [name hasSuffix:@".old"] || [name hasSuffix:@".bak"]) return YES;
            return sz > maxBytes;
        });
        if (aggressiveLogs) {
            FQXDiagnosticsHubPurgeFiles();
        }
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
        Class dockMotion = objc_lookUpClass("FQXDockMotion");
        SEL compactSel = sel_registerName("compactMemory");
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
    static dispatch_once_t migrateOnce;
    dispatch_once(&migrateOnce, ^{
        NSUserDefaults *defaults = NSUserDefaults.standardUserDefaults;
        id legacy = [defaults objectForKey:@"FanqieX.ShelfHistoryFilterBar.1"];
        if (legacy != nil) {
            if (![legacy boolValue]) {
                NSArray<NSString *> *splitKeys = @[
                    ShelfHistoryFilterAllKey, ShelfHistoryFilterReadKey, ShelfHistoryFilterListenKey,
                    ShelfHistoryFilterDramaKey, ShelfHistoryFilterBtnKey, ShelfHistoryEditBtnKey
                ];
                for (NSString *k in splitKeys) {
                    if ([defaults objectForKey:k] == nil) [defaults setBool:NO forKey:k];
                }
            }
            [defaults removeObjectForKey:@"FanqieX.ShelfHistoryFilterBar.1"];
        }
    });
#define OPTION_ROW(name, suffix, titleValue, categoryValue, defaultValue) \
    @{@"title": @titleValue, @"key": name##Key, @"category": @categoryValue, @"default": @(defaultValue)},
    return @[CLEANUP_OPTIONS(OPTION_ROW)];
#undef OPTION_ROW
}

+ (void)install {
    static dispatch_once_t once;
    dispatch_once(&once, ^{
        CFTimeInterval tStart = CACurrentMediaTime();
        FQXCleanupLaunchTime = tStart;
        FQXDiagnosticsHubInstall();
        CFTimeInterval tAfterHub = CACurrentMediaTime();
        [NSNotificationCenter.defaultCenter addObserverForName:NSUserDefaultsDidChangeNotification
                                                        object:nil
                                                         queue:nil
                                                    usingBlock:^(__unused NSNotification *note) {
            FQXInvalidateOptionCache();
        }];
#define SHOW_RULE(cls, selector, option) HideWhen(@cls, NSSelectorFromString(@selector), option##Key, YES)
#define REPLACE(fn, cls, selector, encoding, impl) \
    fn = (void *)Replace(@cls, NSSelectorFromString(@selector), encoding, (IMP)impl)

        // Phase 1 (sync in dyld init): Bookshelf + Notifications/Badges only, so cold launch stays minimal.
        SHOW_RULE("SSBookShelfViewModel", "isHotBannerSectionActive", ShelfBanner);
        SHOW_RULE("SSBookShelfViewModel", "shouldShowLocalBookEntryAddCell", ShelfImport);
        SHOW_RULE("SSBookShelfViewModel", "shouldShowHistoryCard", ShelfHistoryCard);
        SHOW_RULE("SSBookShelfViewModel", "shouldShowBrowseHistoryCard", ShelfHistoryCard);
        SHOW_RULE("SSBookShelfViewModel", "shouldShowBookHistoryCard", ShelfHistoryCard);
        SHOW_RULE("SSBookShelfViewModel", "shouldShowHistoryEntryCard", ShelfHistoryCard);
        SHOW_RULE("SSBookShelfViewModel", "canShowHistoryCard", ShelfHistoryCard);
        SHOW_RULE("SSBookShelfViewModel", "isHistoryCardActive", ShelfHistoryCard);
        SHOW_RULE("SSBookShelfViewModel", "isHotBookCellActive", ShelfRecommendations);
        SHOW_RULE("SSBookShelfDoubleColumn", "isFeatureEnabled", ShelfRecommendations);
        SHOW_RULE("SSBookShelfDoubleColumn", "recommendEnabled", ShelfRecommendations);
        SHOW_RULE("SSBookShelfDoubleColumn", "enable", ShelfRecommendations);
        SHOW_RULE("SSBookShelfDoubleColumn", "hasCollapseBooks", ShelfRecommendations);
        SHOW_RULE("SSBookShelfDoubleColumn", "isDoubleColumnAllInBookShelf", ShelfRecommendations);
        SHOW_RULE("SSBookShelfDoubleColumnConfig", "enable", ShelfRecommendations);
        SHOW_RULE("SSBookShelfDoubleColumnConfig", "recommend_feed_enabled", ShelfRecommendations);
        HideClassWhen(@"SSBookShelfDoubleColumn", sel_registerName("isFeatureEnabled"), ShelfRecommendationsKey, YES);

        REPLACE(NativeImportCell, "SSBookShelfViewModel", "shouldShowLocalBookEntryAddCellWithHistoryCard:", "B24@0:8q16", ImportCell);
        REPLACE(NativeImportCellBool, "SSBookShelfViewModel", "shouldShowLocalBookEntryAddCellWithHistoryCard:", "B20@0:8B16", ImportCellBool);
        if (!NativeImportCellBool) {
            REPLACE(NativeImportCellBool, "SSBookShelfViewModel", "shouldShowLocalBookEntryAddCellWithHistoryCard:", "B20@0:8c16", ImportCellBool);
        }
        REPLACE(NativeImportMenu, "SSBookShelfLocalBookHandler", "moreMenuItems", "@16@0:8", ImportMenu);
        REPLACE(NativeRelatedBanner, "SSBookShelfChaseBookModel", "bookEndRelateVideoBanner", "@16@0:8", RelatedBanner);
        Class chaseModel = objc_lookUpClass("SSBookShelfChaseBookModel");
        FQXInstallOwnedHook(chaseModel, sel_registerName("unconsumedVideoBanner"), NO, "@16@0:8",
                            (IMP)ShelfVideoBanner, (IMP *)&NativeShelfVideoBanner);
        FQXInstallOwnedHook(chaseModel, sel_registerName("unconsumedIpStableEntranceBanner"), NO, "@16@0:8",
                            (IMP)ShelfIPBanner, (IMP *)&NativeShelfIPBanner);
        FQXInstallOwnedHook(chaseModel, sel_registerName("canShowLegacyIpBanner:"), NO, "B24@0:8@16",
                            (IMP)ShelfCanShowLegacyIPBanner, (IMP *)&NativeCanShowLegacyIPBanner);
        REPLACE(NativeHasUnconsumedBanner, "SSBookShelfChaseBookModel", "hasUnconsumedVideoBanner", "B16@0:8", HasUnconsumedBanner);
        REPLACE(NativeShelfShouldShowNotify, "SSBookShelfViewModel", "shouldShowNotify", "B16@0:8", ShelfShouldShowNotify);
        REPLACE(NativeHideDoubleColumnRecommend, "SSBookShelfSubVCOpenParams", "hideDoubleColumnRecommend", "B16@0:8", HideDoubleColumnRecommend);
        REPLACE(NativeDoubleColumnRequestData, "SSBookShelfDoubleColumn", "requestDataIfEnabled", "v16@0:8", DoubleColumnRequestData);
        REPLACE(NativeShelfWillAppear, "SSBookShelfSubViewController", "viewWillAppear:", "v20@0:8B16", ShelfWillAppear);
        REPLACE(NativeShelfAppeared, "SSBookShelfSubViewController", "viewDidAppear:", "v20@0:8B16", ShelfAppeared);
        REPLACE(NativeShelfNumberOfSections, "SSBookShelfSubViewController", "numberOfSectionsInCollectionView:", "q24@0:8@16", ShelfRecNumberOfSections);
        REPLACE(NativeShelfNumberOfItems, "SSBookShelfSubViewController", "collectionView:numberOfItemsInSection:", "q32@0:8@16q24", ShelfRecNumberOfItems);
        REPLACE(NativeShelfCellForItem, "SSBookShelfSubViewController", "collectionView:cellForItemAtIndexPath:", "@32@0:8@16@24", ShelfRecCellForItem);
        REPLACE(NativeShelfDidSelectItem, "SSBookShelfSubViewController", "collectionView:didSelectItemAtIndexPath:", "v32@0:8@16@24", ShelfRecDidSelectItem);
        REPLACE(NativeShelfSupplementaryView, "SSBookShelfSubViewController", "collectionView:viewForSupplementaryElementOfKind:atIndexPath:", "@40@0:8@16@24@32", ShelfRecSupplementaryView);
        REPLACE(NativeShelfSizeForItem, "SSBookShelfSubViewController", "collectionView:layout:sizeForItemAtIndexPath:", "{CGSize=dd}40@0:8@16@24@32", ShelfRecSizeForItem);
        REPLACE(NativeShelfHeaderSize, "SSBookShelfSubViewController", "collectionView:layout:referenceSizeForHeaderInSection:", "{CGSize=dd}40@0:8@16@24q32", ShelfRecHeaderSize);
        REPLACE(NativeShelfFooterSize, "SSBookShelfSubViewController", "collectionView:layout:referenceSizeForFooterInSection:", "{CGSize=dd}40@0:8@16@24q32", ShelfRecFooterSize);
        REPLACE(NativeShelfInsetForSection, "SSBookShelfSubViewController", "collectionView:layout:insetForSectionAtIndex:", "{UIEdgeInsets=dddd}40@0:8@16@24q32", ShelfRecInsetForSection);
        REPLACE(NativePresentation, "BDUGUserNotificationCenter", "userNotificationCenter:willPresentNotification:withCompletionHandler:", "v40@0:8@16@24@?32", PresentNotification);
        REPLACE(NativeBadge, "UIApplication", "setApplicationIconBadgeNumber:", "v24@0:8q16", SetBadge);
        REPLACE(NativeNotificationBadge, "UNUserNotificationCenter", "setBadgeCount:withCompletionHandler:", "v32@0:8q16@?24", SetNotificationBadge);

        CFTimeInterval tAfterCleanupSync = CACurrentMediaTime();
        FQXInstallContentCleanupHooks();
        CFTimeInterval tAfterContentSync = CACurrentMediaTime();
        FQXInstallMotionAndAudioHooks();
        CFTimeInterval tEnd = CACurrentMediaTime();

        // Phase 2 (first main runloop tick): Drama right-rail visibility & Mine tab hooks.
        dispatch_async(dispatch_get_main_queue(), ^{
            SHOW_RULE("SSMyUser621BaseViewController", "showShortcut", MineShortcutCard);
            SHOW_RULE("SSMyUser621ViewController", "shouldInsertUnlimited", MineRecommendations);
            MinePublishButton = class_getInstanceVariable(objc_lookUpClass("SSMyUser621ViewController"), "_publishButton");
            if (MinePublishButton && strcmp(ivar_getTypeEncoding(MinePublishButton), "@\"SSCommunityPublishButton\"") == 0) {
                REPLACE(NativeUpdatePublish, "SSMyUser621ViewController", "updatePublishBtnIfNeed", "v16@0:8", UpdatePublish);
                REPLACE(NativeMineUpdateLayout, "SSMyUser621ViewController", "updateLayout", "v16@0:8", MineUpdateLayout);
                REPLACE(NativePublishPinFrame, "SSCommunityPublishButton", "preferredPinFrame",
                        "{CGRect={CGPoint=dd}{CGSize=dd}}16@0:8", MinePublishPinFrame);
            }
            REPLACE(NativeMineWillAppear, "SSMyUser621ViewController", "viewWillAppear:", "v20@0:8B16", MineWillAppear);
            REPLACE(NativeMineDidAppear, "SSMyUser621ViewController", "viewDidAppear:", "v20@0:8B16", MineDidAppear);
            InstallDramaActionVisibility(@"SSShortVideoRightInteractionCollectView", DramaShowCollectKey);
            InstallDramaActionVisibility(@"SSShortVideoRightInteractionCommentView", DramaShowCommentKey);
            InstallDramaActionVisibility(@"SSShortVideoHostRightInteractionCommentView", DramaShowCommentKey);
            InstallDramaActionVisibility(@"SSShortVideoRightInteractionLikeView", DramaShowLikeKey);
            InstallDramaActionVisibility(@"SSShortVideoRightInteractionShareView", DramaShowShareKey);
            InstallDramaDanmakuUnlockHooks();
        });

        // Phase 3 (post-first-frame): Reader chapter-end, AutoRead & Audiobook hooks.
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.25 * NSEC_PER_SEC)),
                       dispatch_get_main_queue(), ^{
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
            SHOW_RULE("SSNewAudioPlayViewController", "isUnlimitedRecommendNotEmpty", AudioRecommendations);
            SHOW_RULE("SSNewAudioPlayViewController", "shouldShowSlideGuide", AudioRecommendations);
            SHOW_RULE("SSNewAudioPlayViewController", "canReportRecommendItems", AudioRecommendations);
            REPLACE(NativeAudioLoadUnlimited, "SSNewAudioPlayViewController", "loadUnlimitedRecommend", "v16@0:8", AudioLoadUnlimited);
            REPLACE(NativeAudioPreloadUnlimited, "SSNewAudioPlayViewController", "preLoadAudioPlayUnlimitedRecData", "v16@0:8", AudioPreloadUnlimited);
            REPLACE(NativeAudioLoadRecommendBook, "SSNewAudioPlayViewController", "loadRecommendBook", "v16@0:8", AudioLoadRecommendBook);
            REPLACE(NativeAudioLoadComics, "SSNewAudioPlayViewController", "loadComicsBooks", "v16@0:8", AudioLoadComics);
            REPLACE(NativeAudioReloadRecommendForce, "SSNewAudioPlayViewController", "reloadRecommendUIRequestForce:", "v20@0:8B16", AudioReloadRecommendForce);
            REPLACE(NativeAudioReloadUnlimitedView, "SSNewAudioPlayViewController", "reloadUnlimitedView", "v16@0:8", AudioReloadUnlimitedView);
            REPLACE(NativeAudioLayoutContent, "SSNewAudioPlayViewController", "layoutContentView", "v16@0:8", AudioLayoutContent);
            REPLACE(NativeAudioWillAppear, "SSNewAudioPlayViewController", "viewWillAppear:", "v20@0:8B16", AudioWillAppear);
            REPLACE(NativeSpeechHidden, "FQReaderSaaSReaderSpeechButton", "setHidden:", "v20@0:8B16", SpeechHidden);
            REPLACE(NativeShouldRecognize, "FQReaderManager", "shouldBeginDoubleTapRecognize", "B16@0:8", ShouldRecognize);
            REPLACE(NativeDoubleTap, "FQReaderManager", "didDoubleTapView:tapEvent:", "v32@0:8@16@24", ToggleAutoRead);
            REPLACE(NativePreSave, "SSReaderAutoReadPreSaveManager", "canShowAutoReadPreSaveWithPanelData:", "B24@0:8@16", CanShowPreSave);
            REPLACE(NativePauseForTime, "SSReaderAutoReadPreSaveManager", "pauseAutoReadIfNeededForNoLeftTime", "v16@0:8", PauseForTime);
            // These switches control the reader's local ad-time interlock. The
            // original reward requests and network accounting are independent.
            HideWhen(@"SSReaderAutoReadInterrupter", sel_registerName("inspireAutoReadOpen"), DurationLimitKey, NO);
            HideWhen(@"SSReaderAutoReadInterrupter", sel_registerName("autoReadInspireOpen"), DurationLimitKey, NO);
            HideWhen(@"SSReaderAutoReadPreSaveManager", sel_registerName("inspireAutoReadOpen"), DurationLimitKey, NO);
            HideWhen(@"SSReaderAutoReadPreSaveManager", sel_registerName("shouldExitAutoReadWhenHidePreSaveCard"), DurationLimitKey, NO);
        });

#undef REPLACE
#undef SHOW_RULE

        double hubMs = (tAfterHub - tStart) * 1000.0;
        double cleanupSyncMs = (tAfterCleanupSync - tAfterHub) * 1000.0;
        double contentSyncMs = (tAfterContentSync - tAfterCleanupSync) * 1000.0;
        double motionSyncMs = (tEnd - tAfterContentSync) * 1000.0;
        double totalSyncMs = (tEnd - tStart) * 1000.0;
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1.2 * NSEC_PER_SEC)),
                       dispatch_get_main_queue(), ^{
            FQXDiagRecordEvent(FQXDiagCategoryUI, @"startup_perf_summary", @{
                @"hubSyncMs": @(round(hubMs * 100.0) / 100.0),
                @"cleanupSyncMs": @(round(cleanupSyncMs * 100.0) / 100.0),
                @"contentSyncMs": @(round(contentSyncMs * 100.0) / 100.0),
                @"motionSyncMs": @(round(motionSyncMs * 100.0) / 100.0),
                @"totalSyncMs": @(round(totalSyncMs * 100.0) / 100.0),
            }, NO);
        });

        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(3.0 * NSEC_PER_SEC)),
                       dispatch_get_global_queue(QOS_CLASS_UTILITY, 0), ^{
            FQXPurgeHistoricalResidueImpl(NO);
        });
    });
}

+ (void)refreshForKey:(NSString *)key {
    FQXInvalidateOptionCache();
    if ([key isEqualToString:MinePublishKey]) {
        SEL selector = sel_registerName("updatePublishBtnIfNeed");
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
        UIView *bar = HostObject(mine, sel_registerName("myUserBar")) ?: CleanupIvarObject(mine, "_myUserBar");
        if ([bar isKindOfClass:UIView.class]) {
            [bar setNeedsLayout];
            [bar layoutIfNeeded];
        }
        if ([key isEqualToString:MineShortcutCardKey] && mine) {
            SEL reload = sel_registerName("reloadData:");
            if (HostMethod(object_getClass(mine), reload, "v24@0:8@16")) {
                ((void (*)(id, SEL, id))objc_msgSend)(mine, reload, @"FanqieXCleanup");
            } else {
                id cv = HostObject(mine, sel_registerName("collectionView"));
                if ([cv isKindOfClass:UICollectionView.class]) [(UICollectionView *)cv reloadData];
            }
            ScheduleMinePositionSettle(mine);
        }
    } else if ([key isEqualToString:AudioControlIconsOnlyKey] || [key isEqualToString:AudioLiquidGlassKey] ||
               [key isEqualToString:AudioButtonBlurKey]) {
        Class motion = objc_lookUpClass("FQXDockMotion");
        SEL refresh = sel_registerName("refreshAudioGlass");
        if ([motion respondsToSelector:refresh]) ((void (*)(id, SEL))objc_msgSend)(motion, refresh);
    } else if ([key isEqualToString:AudioRecommendationsKey]) {
        BOOL show = Option(AudioRecommendationsKey, YES);
        for (UIViewController *vc in [AudioPlayControllers() allObjects]) {
            ApplyAudioRecommendVisibility(vc);
            if (show) {
                if (NativeAudioLoadUnlimited) NativeAudioLoadUnlimited(vc, sel_registerName("loadUnlimitedRecommend"));
                if (NativeAudioLoadRecommendBook) NativeAudioLoadRecommendBook(vc, sel_registerName("loadRecommendBook"));
                if (NativeAudioReloadRecommendForce) NativeAudioReloadRecommendForce(vc, sel_registerName("reloadRecommendUIRequestForce:"), YES);
            }
            SEL layoutSel = sel_registerName("layoutContentView");
            if (HostMethod(object_getClass(vc), layoutSel, "v16@0:8")) {
                ((void (*)(id, SEL))objc_msgSend)(vc, layoutSel);
            }
            [vc.view setNeedsLayout];
        }
        Class dockMotion = objc_lookUpClass("FQXDockMotion");
        SEL refreshAudioSel = sel_registerName("refreshAudioGlass");
        if ([dockMotion respondsToSelector:refreshAudioSel]) {
            ((void (*)(id, SEL))objc_msgSend)(dockMotion, refreshAudioSel);
        }
    } else if (DramaActionOwners[key]) {
        NSMutableSet<UIView *> *roots = [NSMutableSet set];
        for (UIView *view in DramaActionOwners[key].allObjects) {
            view.hidden = [objc_getAssociatedObject(view, &DramaActionRequestedHiddenKey) boolValue];
            UIView *railRoot = FindDramaRailRootForAction(view);
            if (railRoot) [roots addObject:railRoot];
        }
        for (UIView *railRoot in roots) {
            EnsureDramaRailContainerHooked(railRoot);
            ReflowDramaRightInteractionRail(railRoot);
        }
    } else if ([key isEqualToString:DramaOutlineActionsKey] || [key hasPrefix:@"FanqieX.DramaNaloia"]) {
        Class style = objc_lookUpClass("FQXDramaActionStyle");
        SEL refresh = sel_registerName("refresh");
        if ([style respondsToSelector:refresh]) ((void (*)(id, SEL))objc_msgSend)(style, refresh);
    } else if ([key isEqualToString:DramaPinchPureCleanKey]) {
        Class dockMotion = objc_lookUpClass("FQXDockMotion");
        SEL refreshPinchSel = sel_registerName("refreshDramaPinchClean");
        if ([dockMotion respondsToSelector:refreshPinchSel]) {
            ((void (*)(id, SEL))objc_msgSend)(dockMotion, refreshPinchSel);
        }
    } else if ([key isEqualToString:@"FanqieX.DramaAlbumTitleLines.1"] ||
               [key isEqualToString:DramaHideFullscreenButtonKey] ||
               [key isEqualToString:DramaHideTitleEntryKey] ||
               [key isEqualToString:DramaHideSeriesTagKey] ||
               [key isEqualToString:DramaHideTitleBadgeKey] ||
               [key isEqualToString:DramaHideGenreTagsKey] ||
               [key isEqualToString:DramaHideEpisodeAdaptationsKey] ||
               [key isEqualToString:DramaHideEpisodeSameSeriesKey] ||
               [key isEqualToString:DramaHideEpisodeRecommendKey] ||
               [key isEqualToString:DramaShowDanmakuButtonKey] ||
               [key isEqualToString:@"FanqieX.DramaAuthorDeclaration.1"] ||
               [key isEqualToString:@"FanqieX.DramaOriginalNovel.1"]) {
        Class motion = objc_lookUpClass("FQXDockMotion");
        SEL refresh = sel_registerName("refreshDramaControls");
        if ([motion respondsToSelector:refresh]) ((void (*)(id, SEL))objc_msgSend)(motion, refresh);
    } else if ([key isEqualToString:DramaHeaderBlurKey] ||
               [key isEqualToString:DramaHeaderButtonScaleKey]) {
        Class motion = objc_lookUpClass("FQXDockMotion");
        SEL refresh = sel_registerName("refreshDramaHeaderBlur");
        if ([motion respondsToSelector:refresh]) ((void (*)(id, SEL))objc_msgSend)(motion, refresh);
    } else if ([key isEqualToString:ShareMaterialStyleKey] ||
               [key isEqualToString:ShareBlurKey] ||
               [key isEqualToString:AudioMoreBlurKey] ||
               [key isEqualToString:AudioSheetMaterialKey] ||
               [key isEqualToString:AudioSheetBlurKey]) {
        Class dockMotion = objc_lookUpClass("FQXDockMotion");
        SEL refreshShareSel = sel_registerName("refreshShareGlass");
        if ([dockMotion respondsToSelector:refreshShareSel]) {
            ((void (*)(id, SEL))objc_msgSend)(dockMotion, refreshShareSel);
        }
        SEL refreshAudioSheetsSel = sel_registerName("refreshAudioSheets");
        if ([dockMotion respondsToSelector:refreshAudioSheetsSel]) {
            ((void (*)(id, SEL))objc_msgSend)(dockMotion, refreshAudioSheetsSel);
        }
        if ([key isEqualToString:AudioSheetMaterialKey] || [key isEqualToString:AudioSheetBlurKey]) {
            SEL refreshCommentSel = sel_registerName("refreshCommentGlass");
            if ([dockMotion respondsToSelector:refreshCommentSel]) {
                ((void (*)(id, SEL))objc_msgSend)(dockMotion, refreshCommentSel);
            }
        }
    } else if ([key isEqualToString:DramaPlaybackOptionsMaterialKey] ||
               [key isEqualToString:DramaPlaybackOptionsBlurKey]) {
        Class dockMotion = objc_lookUpClass("FQXDockMotion");
        SEL refreshOptsSel = sel_registerName("refreshDramaPlaybackOptions");
        if ([dockMotion respondsToSelector:refreshOptsSel]) {
            ((void (*)(id, SEL))objc_msgSend)(dockMotion, refreshOptsSel);
        }
    } else if ([key isEqualToString:CommentBlurKey]) {
        Class dockMotion = objc_lookUpClass("FQXDockMotion");
        SEL refreshBlurSel = sel_registerName("refreshCommentBlurStrength");
        if ([dockMotion respondsToSelector:refreshBlurSel]) {
            ((void (*)(id, SEL))objc_msgSend)(dockMotion, refreshBlurSel);
        }
    } else if ([key isEqualToString:CommentMaterialStyleKey] ||
               [key isEqualToString:CommentAppearanceModeKey] ||
               [key isEqualToString:CommentComposerStyleKey] ||
               [key isEqualToString:CommentActivityBannerKey] ||
               [key isEqualToString:CommentSearchEntranceKey]) {
        Class dockMotion = objc_lookUpClass("FQXDockMotion");
        SEL refreshCommentSel = sel_registerName("refreshCommentGlass");
        if ([dockMotion respondsToSelector:refreshCommentSel]) {
            ((void (*)(id, SEL))objc_msgSend)(dockMotion, refreshCommentSel);
        }
    } else if ([key isEqualToString:DockCollapseModeKey] ||
               [key isEqualToString:DockSiriaiHideLineKey]) {
        Class dockMotion = objc_lookUpClass("FQXDockMotion");
        SEL refreshModeSel = sel_registerName("refreshDockCollapseMode");
        if ([dockMotion respondsToSelector:refreshModeSel]) {
            ((void (*)(id, SEL))objc_msgSend)(dockMotion, refreshModeSel);
        }
    } else if ([key isEqualToString:BottomDisplayModeKey] ||
               [key isEqualToString:@"FanqieX.BottomDramaCompactPosition.1"] ||
               [key isEqualToString:DockDetachedEnabledKey] ||
               [key isEqualToString:FQXDockDetachedModulePrefKey] ||
               [key isEqualToString:@"FanqieX.BottomBookstore.1"] ||
               [key isEqualToString:@"FanqieX.BottomDrama.1"] ||
               [key isEqualToString:@"FanqieX.BottomBookshelf.1"] ||
               [key isEqualToString:@"FanqieX.BottomMine.1"] ||
               [key isEqualToString:@"FanqieX.BottomMall.1"]) {
        Class dockMotion = objc_lookUpClass("FQXDockMotion");
        SEL refreshDockSel = sel_registerName("refreshDockAppearance");
        if ([dockMotion respondsToSelector:refreshDockSel]) {
            ((void (*)(id, SEL))objc_msgSend)(dockMotion, refreshDockSel);
        }
    } else if ([key isEqualToString:DockMaterialKey] || [key isEqualToString:DockBlurKey]) {
        Class dockMotion = objc_lookUpClass("FQXDockMotion");
        SEL refresh = sel_registerName("refreshDockMaterial");
        if ([dockMotion respondsToSelector:refresh]) ((void (*)(id, SEL))objc_msgSend)(dockMotion, refresh);
    } else if ([key isEqualToString:SelectionTintStyleKey] || [key isEqualToString:DramaButtonSurfaceStyleKey]) {
        Class dockMotion = objc_lookUpClass("FQXDockMotion");
        SEL refreshDockSel = sel_registerName("refreshDockMaterial");
        SEL refreshTopSel = sel_registerName("refreshDramaHeaderBlur");
        SEL refreshDramaSel = sel_registerName("refreshDramaControls");
        if ([dockMotion respondsToSelector:refreshDockSel]) ((void (*)(id, SEL))objc_msgSend)(dockMotion, refreshDockSel);
        if ([dockMotion respondsToSelector:refreshTopSel]) ((void (*)(id, SEL))objc_msgSend)(dockMotion, refreshTopSel);
        if ([dockMotion respondsToSelector:refreshDramaSel]) ((void (*)(id, SEL))objc_msgSend)(dockMotion, refreshDramaSel);
        Class style = objc_lookUpClass("FQXDramaActionStyle");
        SEL refreshActions = sel_registerName("refresh");
        if ([style respondsToSelector:refreshActions]) ((void (*)(id, SEL))objc_msgSend)(style, refreshActions);
    } else if ([key isEqualToString:ReaderHotCommentBadgeKey]) {
        Class dockMotion = objc_lookUpClass("FQXDockMotion");
        SEL refresh = sel_registerName("refreshReaderHotCommentBadge");
        if ([dockMotion respondsToSelector:refresh]) ((void (*)(id, SEL))objc_msgSend)(dockMotion, refresh);
    } else if ([key isEqualToString:ShelfEditButtonKey]) {
        Class dockMotion = objc_lookUpClass("FQXDockMotion");
        SEL refreshEditSel = sel_registerName("refreshShelfEditButton");
        if ([dockMotion respondsToSelector:refreshEditSel]) {
            ((void (*)(id, SEL))objc_msgSend)(dockMotion, refreshEditSel);
        }
    } else if ([key isEqualToString:ShelfTabBookshelfKey] ||
               [key isEqualToString:ShelfTabHistoryKey] ||
               [key isEqualToString:ShelfTabCollectKey] ||
               [key isEqualToString:ShelfTabCircleKey] ||
               [key isEqualToString:ShelfSearchButtonKey] ||
               [key isEqualToString:ShelfMoreButtonKey] ||
               [key isEqualToString:ShelfFilterAllKey] ||
               [key isEqualToString:ShelfFilterReadKey] ||
               [key isEqualToString:ShelfFilterListenKey] ||
               [key isEqualToString:ShelfFilterComicKey] ||
               [key isEqualToString:ShelfFilterStarKey] ||
               [key isEqualToString:ShelfHistoryFilterAllKey] ||
               [key isEqualToString:ShelfHistoryFilterReadKey] ||
               [key isEqualToString:ShelfHistoryFilterListenKey] ||
               [key isEqualToString:ShelfHistoryFilterDramaKey] ||
               [key isEqualToString:ShelfHistoryFilterShortStoryKey] ||
               [key isEqualToString:ShelfHistoryFilterComicKey] ||
               [key isEqualToString:ShelfHistoryFilterTopicKey] ||
               [key isEqualToString:ShelfHistoryFilterBtnKey] ||
               [key isEqualToString:ShelfHistoryEditBtnKey] ||
               [key hasPrefix:@"FanqieX.ShelfFavorites"] ||
               [key isEqualToString:@"FanqieX.ShelfReadingDuration.1"] ||
               [key isEqualToString:@"FanqieX.ShelfFilterButton.1"]) {
        Class dockMotion = objc_lookUpClass("FQXDockMotion");
        if ([key hasPrefix:@"FanqieX.ShelfTab"]) {
            SEL refreshTabs = sel_registerName("refreshShelfRootTabs");
            if ([dockMotion respondsToSelector:refreshTabs]) {
                ((void (*)(id, SEL))objc_msgSend)(dockMotion, refreshTabs);
            }
        }
        SEL refreshHeaderSel = sel_registerName("refreshShelfHeaderControls");
        if ([dockMotion respondsToSelector:refreshHeaderSel]) {
            ((void (*)(id, SEL))objc_msgSend)(dockMotion, refreshHeaderSel);
        }
    } else if ([key hasPrefix:@"FanqieX.Sidebar"]) {
        Class dockMotion = objc_lookUpClass("FQXDockMotion");
        SEL refreshSidebarSel = sel_registerName("refreshMineSidebar");
        if ([dockMotion respondsToSelector:refreshSidebarSel]) {
            ((void (*)(id, SEL))objc_msgSend)(dockMotion, refreshSidebarSel);
        }
    } else if ([key isEqualToString:GlassDarkTintKey]) {
        Class dockMotion = objc_lookUpClass("FQXDockMotion");
        SEL refreshDockSel = sel_registerName("refreshDockMaterial");
        SEL refreshTopSel = sel_registerName("refreshDramaHeaderBlur");
        SEL refreshShareSel = sel_registerName("refreshShareGlass");
        SEL refreshOptsSel = sel_registerName("refreshDramaPlaybackOptions");
        if ([dockMotion respondsToSelector:refreshDockSel]) {
            ((void (*)(id, SEL))objc_msgSend)(dockMotion, refreshDockSel);
        }
        if ([dockMotion respondsToSelector:refreshTopSel]) {
            ((void (*)(id, SEL))objc_msgSend)(dockMotion, refreshTopSel);
        }
        if ([dockMotion respondsToSelector:refreshShareSel]) {
            ((void (*)(id, SEL))objc_msgSend)(dockMotion, refreshShareSel);
        }
        if ([dockMotion respondsToSelector:refreshOptsSel]) {
            ((void (*)(id, SEL))objc_msgSend)(dockMotion, refreshOptsSel);
        }
    } else if ([key isEqualToString:SpeechFloatKey]) {
        UIView *button = LastSpeechButton;
        NSNumber *wasHidden = objc_getAssociatedObject(button, &SpeechRequestedHidden);
        if (wasHidden) SpeechHidden(button, @selector(setHidden:), wasHidden.boolValue);
    } else if ([key isEqualToString:ListenPendantKey] || [key isEqualToString:AudioAdsKey]) {
        FQXRefreshReaderAndAudioPendants();
    } else if ([key isEqualToString:BadgeKey] && !Option(BadgeKey, YES) && NativeBadge) {
        NativeBadge(UIApplication.sharedApplication, sel_registerName("setApplicationIconBadgeNumber:"), 0);
    } else if ([key isEqualToString:ShelfBannerKey] || [key isEqualToString:ShelfActivityNoticeKey] ||
               [key isEqualToString:ShelfImportKey] || [key isEqualToString:ShelfHistoryCardKey] ||
               [key isEqualToString:ShelfComicKey] || [key isEqualToString:ShelfAdaptationCardKey] ||
               [key isEqualToString:ShelfRecommendationsKey]) {
        UIViewController *shelf = LastShelf;
        BOOL utilityChanged = [key isEqualToString:ShelfImportKey] || [key isEqualToString:ShelfHistoryCardKey];
        if (utilityChanged)
            ShelfUtilityResetController(shelf);
        if (utilityChanged || [key isEqualToString:ShelfAdaptationCardKey]) {
            id vm = HostObject(shelf, sel_registerName("viewModel"));
            SEL rebuild = sel_registerName("rebuildShelfPipeline:");
            if (HostMethod(object_getClass(vm), rebuild, "v24@0:8@16")) {
                ((void (*)(id, SEL, id))objc_msgSend)(vm, rebuild, @"FanqieXCleanup");
            }
        }
        if ([key isEqualToString:ShelfRecommendationsKey]) {
            BOOL show = Option(ShelfRecommendationsKey, YES);
            if (show) ShelfRecRestoreController(shelf);
            id vm = HostObject(shelf, sel_registerName("viewModel"));
            id dc = HostObject(vm, sel_registerName("doubleColumn"));
            if (!show) {
                SEL setCollapse = sel_registerName("setHasCollapseBooks:");
                if (HostMethod(object_getClass(dc), setCollapse, "v20@0:8B16")) {
                    ((void (*)(id, SEL, BOOL))objc_msgSend)(dc, setCollapse, NO);
                }
            } else {
                SEL updateDC = sel_registerName("updateDoubleColumnRecommend");
                if (HostMethod(object_getClass(vm), updateDC, "v16@0:8")) {
                    ((void (*)(id, SEL))objc_msgSend)(vm, updateDC);
                }
                SEL reqDC = sel_registerName("requestDataIfEnabled");
                if (HostMethod(object_getClass(dc), reqDC, "v16@0:8")) {
                    ((void (*)(id, SEL))objc_msgSend)(dc, reqDC);
                }
            }
            SEL rebuild = sel_registerName("rebuildShelfPipeline:");
            if (HostMethod(object_getClass(vm), rebuild, "v24@0:8@16")) {
                ((void (*)(id, SEL, id))objc_msgSend)(vm, rebuild, @"FanqieXCleanup");
            }
        }
        SEL reload = sel_registerName("reloadData:");
        if (HostMethod(object_getClass(shelf), reload, "v24@0:8@16")) {
            ((void (*)(id, SEL, id))objc_msgSend)(shelf, reload, @"FanqieXCleanup");
        } else {
            id cv = HostObject(shelf, sel_registerName("collectionView"));
            if ([cv isKindOfClass:UICollectionView.class]) [(UICollectionView *)cv reloadData];
        }
    }
}
@end
