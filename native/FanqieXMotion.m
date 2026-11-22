#import <UIKit/UIKit.h>
#import <AVFoundation/AVFoundation.h>
#import <QuartzCore/QuartzCore.h>
#include <dlfcn.h>
#import <pthread.h>
#include <stdatomic.h>
#import <objc/message.h>
#import <objc/runtime.h>
#import "FQXHookInstaller.h"
#import "FQXBlurControl.h"
#import "FQXMineShortcutGeometry.h"
#import "FanqieXDetachedDock.h"
#import "FanqieXDiagnosticsHub.h"

extern id FQXSharedAudioSDKManager(void);
extern BOOL FQXIsAudioBookSessionAlive(void);
extern void FQXActivateAudioPlaybackSessionAndRemote(void);
BOOL FQXIsDramaDynamicIslandSessionActive(void);
void FQXNotifyAudioIslandStateChanged(void);
void FQXNotifyDramaPlayerStateChanged(UIView *player, id engine, NSInteger state);

static const void *DockSnapshotKey = &DockSnapshotKey;
static const void *DockAnimatorKey = &DockAnimatorKey;
static const void *TabInteractionKey = &TabInteractionKey;
static const void *AudioGlassSurfaceKey = &AudioGlassSurfaceKey;
static const void *AudioSavedBgKey = &AudioSavedBgKey;
static const void *AudioClearingBgKey = &AudioClearingBgKey;
static const void *AudioSavedClipsKey = &AudioSavedClipsKey;
static const void *AudioPressWiredKey = &AudioPressWiredKey;
static const void *AudioSavedHiddenKey = &AudioSavedHiddenKey;
static const void *DramaSpacingPendingKey = &DramaSpacingPendingKey;
static const void *FQXManualResItemKey = &FQXManualResItemKey;
static const void *FQXQualityModelKey = &FQXQualityModelKey;
static const void *FQXQualityAttemptKey = &FQXQualityAttemptKey;
static const void *FQXLandscapeQualityChoiceKey = &FQXLandscapeQualityChoiceKey;
static const void *FQXPinchRecognizerKey = &FQXPinchRecognizerKey;
static const void *FQXPinchPureCleanActiveKey = &FQXPinchPureCleanActiveKey;
static const void *FQXPinchHiddenViewsKey = &FQXPinchHiddenViewsKey;
static const void *FQXDramaFeatheredGradKey = &FQXDramaFeatheredGradKey;
static const void *AudioStockPositionKey = &AudioStockPositionKey;
static const void *AudioAppliedPositionKey = &AudioAppliedPositionKey;
static const void *AudioMenuStockFrameKey = &AudioMenuStockFrameKey;
static const void *AudioMenuAppliedFrameKey = &AudioMenuAppliedFrameKey;
static const void *AudioBackGlyphKey = &AudioBackGlyphKey;
static const void *AudioGradientHiddenKey = &AudioGradientHiddenKey;
static const void *AudioEdgeHiddenKey = &AudioEdgeHiddenKey;
static const void *AudioShadowOpacityKey = &AudioShadowOpacityKey;
static const void *AudioLabelColorKey = &AudioLabelColorKey;
static const void *AudioBackdropPinnedKey = &AudioBackdropPinnedKey;
static const void *AudioBackdropStockConstraintsKey = &AudioBackdropStockConstraintsKey;
static const void *AudioBackdropStockLayoutKey = &AudioBackdropStockLayoutKey;
static const void *DramaCanvasStockKey = &DramaCanvasStockKey;
static const void *DramaCanvasAppliedKey = &DramaCanvasAppliedKey;
static const void *CommentSearchGlassKey = &CommentSearchGlassKey;
static const void *ExpandedInputBaseTransformKey = &ExpandedInputBaseTransformKey;
static const void *ExpandedInputAppliedTransformKey = &ExpandedInputAppliedTransformKey;
static const void *ExpandedInputSavedClipsKey = &ExpandedInputSavedClipsKey;
static const void *FQXDoubleTapCommentGestureKey = &FQXDoubleTapCommentGestureKey;
static const void *AudioToneStockInsetKey = &AudioToneStockInsetKey;

static NSString *const DockContentAnimation = @"FanqieX.dock.content";
static NSString *const GlassDisabledPrefKey = @"FanqieAdBlock.GlassDisabled.1";
static NSString *const HighestQualityPrefKey = @"FanqieX.DramaHighestQuality.1";
static NSString *const PinchPureCleanPrefKey = @"FanqieX.DramaPinchPureClean.1";
static NSString *const PinchHapticPrefKey = @"FanqieX.DramaPinchHaptic.1";
static NSString *const DoubleTapCommentPrefKey = @"FanqieX.DramaDoubleTapComment.1";
static NSString *const DramaCommentNoVideoShiftPrefKey = @"FanqieX.DramaCommentNoVideoShift.1";
static NSString *const DramaExitCollectAlertPrefKey = @"FanqieX.DramaExitCollectAlert.1";
static NSString *const CommentMaterialStylePrefKey = @"FanqieX.CommentMaterialStyle.1";
static NSString *const CommentAppearanceModePrefKey = @"FanqieX.CommentAppearanceMode.1";
static NSString *const CommentComposerStylePrefKey = @"FanqieX.CommentComposerStyle.1";
static NSString *const BottomDisplayModePrefKey = @"FanqieX.BottomDisplayMode.1";
static NSString *const DockMaterialPrefKey = @"FanqieX.DockMaterial.1";
static NSString *const GlassDarkTintPrefKey = @"FanqieX.GlassDarkTint.1";
static NSString *const DockBlurPrefKey = @"FanqieX.DockBlur.1";
static NSString *const CommentBlurPrefKey = @"FanqieX.CommentBlur.1";
static NSString *const AudioButtonBlurPrefKey = @"FanqieX.AudioButtonBlur.1";
static NSString *const DramaHeaderBlurPrefKey = @"FanqieX.DramaHeaderBlur.1";
static NSString *const ReaderHotCommentBadgePrefKey = @"FanqieX.ReaderHotCommentBadge.1";
static NSString *const ShelfEditButtonPrefKey = @"FanqieX.ShelfEditButton.1";
static NSString *const CommentActivityBannerPrefKey = @"FanqieX.CommentActivityBanner.1";
static NSString *const CommentSearchEntrancePrefKey = @"FanqieX.CommentSearchEntrance.1";
static NSString *const AudioRecsPrefKey = @"FanqieX.AudioRecommendations.1";
static NSString *const AudioIconsOnlyPrefKey = @"FanqieX.AudioControlIconsOnly.1";
static NSString *const AudioLiquidGlassPrefKey = @"FanqieX.AudioLiquidGlass.1";
static NSString *const AudioDynamicIslandPrefKey = @"FanqieX.AudioDynamicIsland.1";
static NSString *const DramaDynamicIslandPrefKey = @"FanqieX.DramaDynamicIsland.1";
static NSString *const BottomHapticsPrefKey = @"FanqieX.BottomHaptics.1";
static NSString *const FQXCTForegroundColorAttr = @"CTForegroundColor";
static const CGFloat AudioNavigationButtonDiameter = 42.0;
static const CGFloat AudioBookArrowDiameter = 28.0;

typedef NS_ENUM(NSInteger, FQXCommentMaterialStyle) {
    FQXCommentMaterialNative = 0,         // Original Fanqie comment background
    FQXCommentMaterialClearGlass = 1,     // iOS 26+ UIGlassEffectStyleClear (Clear)
    FQXCommentMaterialGaussianBlur = 2,   // Independent continuous 1..100 Gaussian Blur
    FQXCommentMaterialBookBackground = 3, // Novel original reading paper background
    FQXCommentMaterialRegularGlass = 4,   // iOS 26+ UIGlassEffectStyleRegular (Regular)
    FQXCommentMaterialLiquidGlass = FQXCommentMaterialClearGlass,
};

typedef NS_ENUM(NSInteger, FQXCommentAppearanceMode) {
    FQXCommentAppearanceFollowApp = 0, // Follow Fanqie Novel's in-app Night/Light mode
    FQXCommentAppearanceLight = 1,     // Force Light
    FQXCommentAppearanceDark = 2,      // Force Dark
};

typedef NS_ENUM(NSInteger, FQXCommentComposerStyle) {
    FQXCommentComposerNative = 0,           // Original Fanqie expanded comment composer
    FQXCommentComposerDockedGlass = 1,      // Full-width bottom-docked Liquid Glass / Blur sheet
    FQXCommentComposerFloatingDetached = 2, // CoolApk-style floating detached rounded glass card
};

static BOOL FQXIsNativeGlassCommentStyle(FQXCommentMaterialStyle style) {
    return style == FQXCommentMaterialClearGlass || style == FQXCommentMaterialRegularGlass;
}

typedef struct {
    FQXCommentMaterialStyle commentMaterialStyle;
    FQXCommentAppearanceMode commentAppearanceMode;
    FQXCommentComposerStyle commentComposerStyle;
    NSInteger dockMaterialMode;
    BOOL hasStoredComposerStyle;
    BOOL glassDisabled;
    BOOL glassDarkTint;
    BOOL shelfEditButton;
    BOOL dramaCommentNoVideoShift;
    BOOL dramaExitCollectAlert;
    BOOL audioLiquidGlass;
    BOOL commentActivityBanner;
    BOOL commentSearchEntrance;
    BOOL readerHotCommentBadge;
} FQXHotPrefsCache;

static pthread_mutex_t gFQXHotPrefsLock = PTHREAD_MUTEX_INITIALIZER;
static FQXHotPrefsCache gFQXHotPrefs;
static _Atomic uint64_t gFQXHotPrefsGen = 1;
static uint64_t gFQXHotPrefsLoadedGen = 0;

static void FQXInvalidateHotPrefsCache(void) {
    atomic_fetch_add_explicit(&gFQXHotPrefsGen, 1, memory_order_release);
}

static FQXHotPrefsCache FQXHotPrefsSnapshot(void) {
    uint64_t gen = atomic_load_explicit(&gFQXHotPrefsGen, memory_order_acquire);
    pthread_mutex_lock(&gFQXHotPrefsLock);
    if (gFQXHotPrefsLoadedGen == gen) {
        FQXHotPrefsCache snap = gFQXHotPrefs;
        pthread_mutex_unlock(&gFQXHotPrefsLock);
        return snap;
    }
    pthread_mutex_unlock(&gFQXHotPrefsLock);

    FQXHotPrefsCache fresh = {0};
    NSUserDefaults *ud = NSUserDefaults.standardUserDefaults;
    id matObj = [ud objectForKey:CommentMaterialStylePrefKey];
    NSInteger mat = (matObj && [matObj respondsToSelector:@selector(integerValue)]) ? [matObj integerValue] : 0;
    if (mat < FQXCommentMaterialNative || mat > FQXCommentMaterialRegularGlass) mat = FQXCommentMaterialNative;
    fresh.commentMaterialStyle = (FQXCommentMaterialStyle)mat;

    id appObj = [ud objectForKey:CommentAppearanceModePrefKey];
    NSInteger app = (appObj && [appObj respondsToSelector:@selector(integerValue)]) ? [appObj integerValue] : 0;
    if (app < FQXCommentAppearanceFollowApp || app > FQXCommentAppearanceDark) app = FQXCommentAppearanceFollowApp;
    fresh.commentAppearanceMode = (FQXCommentAppearanceMode)app;

    id compObj = [ud objectForKey:CommentComposerStylePrefKey];
    if (compObj && [compObj respondsToSelector:@selector(integerValue)]) {
        NSInteger comp = [compObj integerValue];
        if (comp >= FQXCommentComposerNative && comp <= FQXCommentComposerFloatingDetached) {
            fresh.commentComposerStyle = (FQXCommentComposerStyle)comp;
            fresh.hasStoredComposerStyle = YES;
        }
    }

    NSInteger dockMat = [ud integerForKey:DockMaterialPrefKey];
    fresh.dockMaterialMode = (dockMat >= 0 && dockMat <= 3) ? dockMat : 0;
    fresh.glassDisabled = ([ud integerForKey:GlassDisabledPrefKey] != 0);
    fresh.glassDarkTint = [ud boolForKey:GlassDarkTintPrefKey];

    id editObj = [ud objectForKey:ShelfEditButtonPrefKey];
    fresh.shelfEditButton = editObj ? [editObj boolValue] : YES;
    fresh.dramaCommentNoVideoShift = [ud boolForKey:DramaCommentNoVideoShiftPrefKey];
    fresh.dramaExitCollectAlert = [ud boolForKey:DramaExitCollectAlertPrefKey];
    fresh.audioLiquidGlass = [ud boolForKey:AudioLiquidGlassPrefKey];

    id bannerObj = [ud objectForKey:CommentActivityBannerPrefKey];
    fresh.commentActivityBanner = bannerObj ? [bannerObj boolValue] : YES;
    id searchObj = [ud objectForKey:CommentSearchEntrancePrefKey];
    fresh.commentSearchEntrance = searchObj ? [searchObj boolValue] : YES;
    id hotObj = [ud objectForKey:ReaderHotCommentBadgePrefKey];
    fresh.readerHotCommentBadge = hotObj ? [hotObj boolValue] : YES;

    pthread_mutex_lock(&gFQXHotPrefsLock);
    if (atomic_load_explicit(&gFQXHotPrefsGen, memory_order_acquire) == gen) {
        gFQXHotPrefs = fresh;
        gFQXHotPrefsLoadedGen = gen;
    }
    pthread_mutex_unlock(&gFQXHotPrefsLock);
    return fresh;
}

static BOOL FQXShelfEditButtonEnabled(void) {
    return FQXHotPrefsSnapshot().shelfEditButton;
}

static BOOL FQXGlassDarkTintEnabled(void) {
    return FQXHotPrefsSnapshot().glassDarkTint;
}

static FQXCommentMaterialStyle FQXCurrentCommentMaterialStyle(void) {
    return FQXHotPrefsSnapshot().commentMaterialStyle;
}

static FQXCommentComposerStyle FQXCurrentCommentComposerStyle(void) {
    FQXHotPrefsCache p = FQXHotPrefsSnapshot();
    if (p.hasStoredComposerStyle) return p.commentComposerStyle;
    FQXCommentMaterialStyle material = p.commentMaterialStyle;
    return (FQXIsNativeGlassCommentStyle(material) || material == FQXCommentMaterialGaussianBlur)
        ? FQXCommentComposerDockedGlass
        : FQXCommentComposerNative;
}

static BOOL FQXDramaCommentNoVideoShiftEnabled(void) {
    return FQXHotPrefsSnapshot().dramaCommentNoVideoShift;
}

static BOOL FQXDramaExitCollectAlertHidden(void) {
    return FQXHotPrefsSnapshot().dramaExitCollectAlert;
}

static FQXCommentAppearanceMode FQXCurrentCommentAppearanceMode(void) {
    return FQXHotPrefsSnapshot().commentAppearanceMode;
}

static BOOL FQXCommentAppearanceOverrideActive(void) {
    return FQXHotPrefsSnapshot().commentAppearanceMode != FQXCommentAppearanceFollowApp;
}

static BOOL FQXAppIsInNightMode(void) {
    static Class adapterCls = Nil;
    static Class serviceCls = Nil;
    static SEL defaultSel = NULL;
    static SEL getSel = NULL;
    static SEL curDarkSel = NULL;
    static SEL darkSel = NULL;
    static dispatch_once_t once;
    dispatch_once(&once, ^{
        defaultSel = NSSelectorFromString(@"defaultCenter");
        getSel = NSSelectorFromString(@"getService:");
        curDarkSel = NSSelectorFromString(@"isCurrentDarkMode");
        darkSel = NSSelectorFromString(@"isDarkMode");
    });
    if (!adapterCls) adapterCls = NSClassFromString(@"SSUIColorAdaptedManager");
    if (!serviceCls) serviceCls = NSClassFromString(@"HTSServiceCenter");
    if (adapterCls && serviceCls && [serviceCls respondsToSelector:defaultSel]) {
        id center = ((id (*)(id, SEL))objc_msgSend)(serviceCls, defaultSel);
        if (center && [center respondsToSelector:getSel]) {
            id adapter = ((id (*)(id, SEL, Class))objc_msgSend)(center, getSel, adapterCls);
            if (adapter) {
                Method m = class_getInstanceMethod(object_getClass(adapter), curDarkSel);
                if (m && method_getNumberOfArguments(m) == 2) {
                    return ((BOOL (*)(id, SEL))objc_msgSend)(adapter, curDarkSel);
                }
                Method m2 = class_getInstanceMethod(object_getClass(adapter), darkSel);
                if (m2 && method_getNumberOfArguments(m2) == 2) {
                    return ((BOOL (*)(id, SEL))objc_msgSend)(adapter, darkSel);
                }
            }
        }
    }
    for (UIScene *scene in UIApplication.sharedApplication.connectedScenes) {
        if (![scene isKindOfClass:UIWindowScene.class]) continue;
        UIWindowScene *ws = (UIWindowScene *)scene;
        UIUserInterfaceStyle sceneStyle = ws.traitCollection.userInterfaceStyle;
        if (sceneStyle != UIUserInterfaceStyleUnspecified) {
            return sceneStyle == UIUserInterfaceStyleDark;
        }
        for (UIWindow *win in ws.windows) {
            if (!win.isKeyWindow) continue;
            if (win.overrideUserInterfaceStyle == UIUserInterfaceStyleDark) return YES;
            if (win.overrideUserInterfaceStyle == UIUserInterfaceStyleLight) return NO;
            return win.traitCollection.userInterfaceStyle == UIUserInterfaceStyleDark;
        }
    }
    return UIScreen.mainScreen.traitCollection.userInterfaceStyle == UIUserInterfaceStyleDark;
}

static BOOL FQXCommentsUseDarkTheme(void) {
    if (FQXCurrentCommentMaterialStyle() == FQXCommentMaterialBookBackground) return FQXAppIsInNightMode();
    FQXCommentAppearanceMode appMode = FQXCurrentCommentAppearanceMode();
    if (appMode == FQXCommentAppearanceLight) return NO;
    if (appMode == FQXCommentAppearanceDark) return YES;
    return FQXAppIsInNightMode();
}

static BOOL FQXGlassEnabled(void) {
    if (FQXHotPrefsSnapshot().glassDisabled) return NO;
    static BOOL sRuntimeGlassAvailable = NO;
    static dispatch_once_t once;
    dispatch_once(&once, ^{
        Class glassCls = NSClassFromString(@"UIGlassEffect");
        Class cornerCls = NSClassFromString(@"UICornerConfiguration");
        sRuntimeGlassAvailable = glassCls != Nil && cornerCls != Nil &&
            [glassCls respondsToSelector:NSSelectorFromString(@"effectWithStyle:")] &&
            [cornerCls respondsToSelector:NSSelectorFromString(@"capsuleConfiguration")] &&
            [UIVisualEffectView instancesRespondToSelector:NSSelectorFromString(@"setCornerConfiguration:")];
    });
    return sRuntimeGlassAvailable;
}

static BOOL FQXAudioGlassEnabled(void) {
    return FQXGlassEnabled() && FQXHotPrefsSnapshot().audioLiquidGlass;
}

static BOOL FQXCommentStylingEnabled(void) {
    if (FQXHotPrefsSnapshot().glassDisabled) return NO;
    FQXCommentMaterialStyle style = FQXCurrentCommentMaterialStyle();
    if (style == FQXCommentMaterialNative || style == FQXCommentMaterialBookBackground) return NO;
    if (style == FQXCommentMaterialGaussianBlur) return YES;
    return FQXGlassEnabled();
}

static FQXCommentMaterialStyle FQXComposerEffectiveMaterialStyle(void) {
    FQXCommentMaterialStyle style = FQXCurrentCommentMaterialStyle();
    if (style == FQXCommentMaterialGaussianBlur) return FQXCommentMaterialGaussianBlur;
    if (FQXIsNativeGlassCommentStyle(style) && FQXGlassEnabled()) return style;
    return FQXGlassEnabled() ? FQXCommentMaterialClearGlass : FQXCommentMaterialGaussianBlur;
}

static BOOL FQXShouldOverrideCommentTheme(void) {
    if (FQXCurrentCommentMaterialStyle() == FQXCommentMaterialBookBackground) return NO;
    return FQXCommentStylingEnabled() || FQXCommentAppearanceOverrideActive();
}

static UIUserInterfaceStyle FQXDesiredCommentInterfaceStyle(void) {
    if (!FQXShouldOverrideCommentTheme()) return UIUserInterfaceStyleUnspecified;
    return FQXCommentsUseDarkTheme() ? UIUserInterfaceStyleDark : UIUserInterfaceStyleLight;
}

static UIUserInterfaceStyle FQXDesiredCommentHostOverrideStyle(void) {
    if (!FQXCommentAppearanceOverrideActive()) return UIUserInterfaceStyleUnspecified;
    return FQXDesiredCommentInterfaceStyle();
}

static BOOL FQXCommentActivityBannerEnabled(void) {
    return FQXHotPrefsSnapshot().commentActivityBanner;
}

static BOOL FQXCommentSearchEntranceEnabled(void) {
    return FQXHotPrefsSnapshot().commentSearchEntrance;
}

// Unified Liquid Glass rendering layer shared across Dock, Short-Drama Comments, and Novel Comments.
// Dock dynamic background resampling adapts the iOS 26/27 pattern from ChenYilong/CYLTabBarController (MIT).
static const void *FQXUnifiedClearDockKey = &FQXUnifiedClearDockKey;
static const void *FQXOwnedGlassElementKey = &FQXOwnedGlassElementKey;
static const void *FQXNoVideoShiftSuppressedKey = &FQXNoVideoShiftSuppressedKey;
static const void *FQXAudioIndicatorDedupHiddenKey = &FQXAudioIndicatorDedupHiddenKey;
static const void *FQXCommentGlassStyleAppliedKey = &FQXCommentGlassStyleAppliedKey;
static const void *FQXDockHiddenByCommentKey = &FQXDockHiddenByCommentKey;
static const void *FQXSheetTopRimLayerKey = &FQXSheetTopRimLayerKey;
static const void *FQXSheetSavedCornerRadiusKey = &FQXSheetSavedCornerRadiusKey;
static const void *FQXSheetSavedMaskedCornersKey = &FQXSheetSavedMaskedCornersKey;
static const void *FQXSheetSavedCornerCurveKey = &FQXSheetSavedCornerCurveKey;
static const void *FQXCommentBannerSavedHeightKey = &FQXCommentBannerSavedHeightKey;
static const void *FQXReaderDisappearingKey = &FQXReaderDisappearingKey;
static const void *FQXReaderSwipeHiddenIndicatorKey = &FQXReaderSwipeHiddenIndicatorKey;
static const void *FQXShelfHeaderFixPendingKey = &FQXShelfHeaderFixPendingKey;
static const void *FQXCommentTypographyStampKey = &FQXCommentTypographyStampKey;

static UIVisualEffect *FQXMakeGlassEffect(NSInteger style, BOOL interactive, UIColor *tintColor) {
    static Class glassCls = Nil;
    static SEL makeSel = NULL;
    static SEL interactiveSel = NULL;
    static SEL tintSel = NULL;
    static dispatch_once_t once;
    dispatch_once(&once, ^{
        glassCls = NSClassFromString(@"UIGlassEffect");
        makeSel = NSSelectorFromString(@"effectWithStyle:");
        interactiveSel = NSSelectorFromString(@"setInteractive:");
        tintSel = NSSelectorFromString(@"setTintColor:");
    });
    if (glassCls && [glassCls respondsToSelector:makeSel]) {
        UIVisualEffect *effect = ((id (*)(id, SEL, NSInteger))objc_msgSend)(glassCls, makeSel, style);
        if (effect) {
            if ([effect respondsToSelector:interactiveSel]) {
                ((void (*)(id, SEL, BOOL))objc_msgSend)(effect, interactiveSel, interactive);
            }
            if (tintColor && [effect respondsToSelector:tintSel]) {
                ((void (*)(id, SEL, id))objc_msgSend)(effect, tintSel, tintColor);
            }
            return effect;
        }
    }
    // Pre-iOS 26 / fallback material degradation
    UIBlurEffectStyle fallbackStyle = (style == 1)
        ? UIBlurEffectStyleSystemThinMaterial
        : UIBlurEffectStyleSystemMaterialDark;
    return [UIBlurEffect effectWithStyle:fallbackStyle];
}

static const void *FQXAppliedCornerStampKey = &FQXAppliedCornerStampKey;

static void FQXApplyCornerConfiguration(UIView *view, CGFloat radius, BOOL continuousCard) {
    if (!view) return;
    NSInteger stamp = ((NSInteger)llround(radius * 10.0) << 2) | (continuousCard ? 2 : 1);
    NSNumber *applied = objc_getAssociatedObject(view, FQXAppliedCornerStampKey);
    if (applied && applied.integerValue == stamp) return;
    static Class cornerCls = Nil;
    static Class radiusCls = Nil;
    static SEL setCornerSel = NULL;
    static SEL fixedSel = NULL;
    static SEL uniformSel = NULL;
    static SEL maxSel = NULL;
    static SEL capSel = NULL;
    static dispatch_once_t once;
    dispatch_once(&once, ^{
        cornerCls = NSClassFromString(@"UICornerConfiguration");
        radiusCls = NSClassFromString(@"UICornerRadius");
        setCornerSel = NSSelectorFromString(@"setCornerConfiguration:");
        fixedSel = NSSelectorFromString(@"fixedRadius:");
        uniformSel = NSSelectorFromString(@"configurationWithUniformRadius:");
        maxSel = NSSelectorFromString(@"capsuleConfigurationWithMaximumRadius:");
        capSel = NSSelectorFromString(@"capsuleConfiguration");
    });
    if (!cornerCls || ![view respondsToSelector:setCornerSel]) return;
    id config = nil;
    if (radius < 0.0 || (radius > 0.0 && continuousCard)) {
        if (radiusCls && [radiusCls respondsToSelector:fixedSel] && [cornerCls respondsToSelector:uniformSel]) {
            CGFloat fixedR = radius < 0.0 ? 0.0 : radius;
            id radObj = ((id (*)(id, SEL, CGFloat))objc_msgSend)(radiusCls, fixedSel, fixedR);
            if (radObj) {
                config = ((id (*)(id, SEL, id))objc_msgSend)(cornerCls, uniformSel, radObj);
            }
        }
    }
    if (!config && radius > 0.0 && [cornerCls respondsToSelector:maxSel]) {
        config = ((id (*)(id, SEL, CGFloat))objc_msgSend)(cornerCls, maxSel, radius);
    }
    if (!config && radius >= 0.0 && [cornerCls respondsToSelector:capSel]) {
        config = ((id (*)(id, SEL))objc_msgSend)(cornerCls, capSel);
    }
    if (config) {
        ((void (*)(id, SEL, id))objc_msgSend)(view, setCornerSel, config);
        objc_setAssociatedObject(view, FQXAppliedCornerStampKey, @(stamp), OBJC_ASSOCIATION_RETAIN_NONATOMIC);
    }
}

static UIVisualEffectView *FQXNewGlassViewFull(NSInteger style,
                                               BOOL interactive,
                                               CGFloat radius,
                                               BOOL continuousCard,
                                               UIColor *tintColor) {
    UIVisualEffect *effect = FQXMakeGlassEffect(style, interactive, tintColor);
    if (!effect) return nil;
    UIVisualEffectView *surface = [[UIVisualEffectView alloc] initWithEffect:effect];
    if (!surface) return nil;
    FQXApplyCornerConfiguration(surface, radius, continuousCard);
    surface.userInteractionEnabled = NO;
    surface.accessibilityElementsHidden = YES;
    surface.isAccessibilityElement = NO;
    surface.opaque = NO;
    surface.backgroundColor = UIColor.clearColor;
    surface.contentView.backgroundColor = UIColor.clearColor;
    return surface;
}

@interface FQXBackdropHostView : UIView
@end

@implementation FQXBackdropHostView
+ (Class)layerClass {
    static Class cls = Nil;
    static dispatch_once_t once;
    dispatch_once(&once, ^{
        cls = NSClassFromString(@"CABackdropLayer") ?: [CALayer class];
    });
    return cls;
}
@end

@interface FQXBackdropBlurView : UIVisualEffectView
@property(nonatomic, strong) UIViewPropertyAnimator *blurAnimator;
@property(nonatomic, weak) UIWindow *animatorWindow;
@property(nonatomic) UIBlurEffectStyle blurStyle;
@property(nonatomic) NSInteger percent;
@property(nonatomic) BOOL applyPending;
@property(nonatomic, strong) FQXBackdropHostView *backdropHost;
@property(nonatomic, strong) UIView *tintOverlay;
@property(nonatomic) BOOL usingHardwareFilter;
@property(nonatomic) BOOL isDarkStyle;
@property(nonatomic) CGFloat baseTintAlpha;
@property(nonatomic) CGFloat maxTintAlpha;
@property(nonatomic) BOOL matteChromeBorder;
@property(nonatomic) BOOL commentPureMode;
- (void)configurePercent:(NSInteger)percent style:(UIBlurEffectStyle)style;
- (void)configurePercent:(NSInteger)percent
                    dark:(BOOL)dark
                baseTint:(CGFloat)baseTint
                 maxTint:(CGFloat)maxTint
            chromeBorder:(BOOL)chromeBorder;
- (void)applyHardwareBlur;
- (void)invalidateBlurAnimator;
- (void)scheduleBlurUpdate;
@end

typedef NS_ENUM(NSInteger, FQXCommentCornerKind) {
    FQXCommentCornerFlushFlat = 0,
    FQXCommentCornerTopSheet = 1,
    FQXCommentCornerFloatingCard = 2,
    FQXCommentCornerCapsule = 3,
};

static void FQXApplyCommentCornerConfig(UIVisualEffectView *surface,
                                        FQXCommentCornerKind kind,
                                        CGFloat radius);
static void FQXResyncVisibleCommentSheetYields(UIWindow *window);

@interface FQXCommentGlassSurfaceView : UIVisualEffectView
@property(nonatomic, weak) UIView *flexSourceView;
@property(nonatomic, strong) FQXBackdropBlurView *supplementalBlur;
@property(nonatomic) FQXCommentCornerKind cornerKind;
@property(nonatomic) CGFloat cornerRadius;
@property(nonatomic) BOOL disablesSupplementalBlur;
@property(nonatomic) BOOL isBarGlass;
@property(nonatomic) BOOL isMaterializing;
@property(nonatomic) CGSize lastBoundsSize;
@end

@implementation FQXCommentGlassSurfaceView
- (UIView *)_flexInteractionGestureView {
    UIView *source = self.flexSourceView;
    if (source && source.window) return source;
    SEL flexSel = NSSelectorFromString(@"_flexInteractionGestureView");
    if ([UIVisualEffectView instancesRespondToSelector:flexSel]) {
        IMP imp = class_getMethodImplementation([UIVisualEffectView class], flexSel);
        if (imp) return ((UIView *(*)(id, SEL))imp)(self, flexSel);
    }
    return nil;
}

- (void)layoutSubviews {
    [super layoutSubviews];
    CGRect b = self.contentView.bounds;
    FQXBackdropBlurView *sub = self.supplementalBlur;
    if (sub && sub.superview == self.contentView) {
        if (!CGRectEqualToRect(sub.frame, b)) {
            sub.frame = b;
            FQXApplyCommentCornerConfig(sub, self.cornerKind, self.cornerRadius);
        }
    }
    if (!CGSizeEqualToSize(self.lastBoundsSize, b.size)) {
        self.lastBoundsSize = b.size;
        if (self.isBarGlass && self.window) {
            FQXResyncVisibleCommentSheetYields(self.window);
        }
    }
}
@end

static const void *FQXSceneTraitObservedKey = &FQXSceneTraitObservedKey;

static void FQXReapplyAllTrackedCommentGlass(void);

static NSHashTable<FQXCommentGlassSurfaceView *> *FQXTrackedCommentGlassSurfaces(void) {
    static NSHashTable<FQXCommentGlassSurfaceView *> *table;
    static dispatch_once_t once;
    dispatch_once(&once, ^{ table = [NSHashTable weakObjectsHashTable]; });
    return table;
}

static NSHashTable<FQXBackdropBlurView *> *FQXTrackedCommentBlurViews(void) {
    static NSHashTable<FQXBackdropBlurView *> *table;
    static dispatch_once_t once;
    dispatch_once(&once, ^{ table = [NSHashTable weakObjectsHashTable]; });
    return table;
}

static NSHashTable<UIView *> *FQXTrackedCommentSheetHosts(void) {
    static NSHashTable<UIView *> *table;
    static dispatch_once_t once;
    dispatch_once(&once, ^{ table = [NSHashTable weakObjectsHashTable]; });
    return table;
}

static NSHashTable<UIView *> *FQXTrackedCommentComposerHosts(void) {
    static NSHashTable<UIView *> *table;
    static dispatch_once_t once;
    dispatch_once(&once, ^{ table = [NSHashTable weakObjectsHashTable]; });
    return table;
}

static void FQXObserveWindowSceneTraitsIfNeeded(UIWindowScene *scene) {
    if (![scene isKindOfClass:UIWindowScene.class]) return;
    if (objc_getAssociatedObject(scene, FQXSceneTraitObservedKey)) return;
    Class styleTraitCls = NSClassFromString(@"UITraitUserInterfaceStyle");
    SEL regSel = NSSelectorFromString(@"registerForTraitChanges:withHandler:");
    if (!styleTraitCls || ![scene respondsToSelector:regSel]) return;
    objc_setAssociatedObject(scene, FQXSceneTraitObservedKey, @YES, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
    void (^handler)(id<UITraitEnvironment>, UITraitCollection *) =
        ^(__unused id<UITraitEnvironment> env, __unused UITraitCollection *previous) {
            if (FQXCurrentCommentAppearanceMode() != FQXCommentAppearanceFollowApp) return;
            dispatch_async(dispatch_get_main_queue(), ^{
                FQXReapplyAllTrackedCommentGlass();
            });
        };
    (void)((id (*)(id, SEL, id, id))objc_msgSend)(scene, regSel, @[styleTraitCls], handler);
}

static void FQXApplyCommentCornerConfig(UIVisualEffectView *surface,
                                        FQXCommentCornerKind kind,
                                        CGFloat radius) {
    if (!surface) return;
    if ([surface isKindOfClass:FQXBackdropBlurView.class]) {
        if (objc_getAssociatedObject(surface, FQXAppliedCornerStampKey)) {
            objc_setAssociatedObject(surface, FQXAppliedCornerStampKey, nil, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
        }
        CGFloat half = MIN(CGRectGetWidth(surface.bounds), CGRectGetHeight(surface.bounds)) * 0.5;
        CGFloat r = 0.0;
        CACornerMask masks = kCALayerMinXMinYCorner | kCALayerMaxXMinYCorner |
                             kCALayerMinXMaxYCorner | kCALayerMaxXMaxYCorner;
        BOOL wantClip = NO;
        switch (kind) {
            case FQXCommentCornerFlushFlat:
                r = 0.0;
                wantClip = NO;
                break;
            case FQXCommentCornerTopSheet:
                r = MAX(0.0, radius);
                masks = kCALayerMinXMinYCorner | kCALayerMaxXMinYCorner;
                wantClip = (r > 0.0);
                break;
            case FQXCommentCornerFloatingCard:
                r = MAX(0.0, radius > 0.0 ? radius : 26.0);
                wantClip = (r > 0.0);
                break;
            case FQXCommentCornerCapsule:
                r = MAX(0.0, half);
                wantClip = (r > 0.0);
                break;
        }
        surface.layer.cornerCurve = kCACornerCurveContinuous;
        if (surface.layer.maskedCorners != masks) surface.layer.maskedCorners = masks;
        if (fabs(surface.layer.cornerRadius - r) > 0.25) surface.layer.cornerRadius = r;
        if (surface.clipsToBounds != wantClip) surface.clipsToBounds = wantClip;
        return;
    }

    if (surface.layer.cornerRadius > 0.0) surface.layer.cornerRadius = 0.0;
    if (surface.clipsToBounds) surface.clipsToBounds = NO;

    UIView *host = surface.superview;
    BOOL hostHasClippedCorner = (host && host.clipsToBounds &&
                                 host.layer.cornerRadius >= 8.0 && host.layer.cornerRadius <= 22.0);
    BOOL useConcentric = (kind == FQXCommentCornerTopSheet) && hostHasClippedCorner;
    NSInteger stamp = ((NSInteger)kind << 17) | ((useConcentric ? 1 : 0) << 16) |
                      (NSInteger)llround(MAX(0.0, radius) * 10.0);
    NSNumber *applied = objc_getAssociatedObject(surface, FQXAppliedCornerStampKey);
    if (applied && applied.integerValue == stamp) return;

    static Class cornerCls = Nil;
    static Class radiusCls = Nil;
    static SEL setCornerSel = NULL;
    static SEL fixedSel = NULL;
    static SEL capSel = NULL;
    static SEL uniformSel = NULL;
    static SEL minConcSel = NULL;
    static SEL topBotSel = NULL;
    static dispatch_once_t once;
    dispatch_once(&once, ^{
        cornerCls = NSClassFromString(@"UICornerConfiguration");
        radiusCls = NSClassFromString(@"UICornerRadius");
        setCornerSel = NSSelectorFromString(@"setCornerConfiguration:");
        fixedSel = NSSelectorFromString(@"fixedRadius:");
        capSel = NSSelectorFromString(@"capsuleConfiguration");
        uniformSel = NSSelectorFromString(@"configurationWithUniformRadius:");
        minConcSel = NSSelectorFromString(@"containerConcentricRadiusWithMinimum:");
        topBotSel = NSSelectorFromString(@"configurationWithUniformTopRadius:bottomLeftRadius:bottomRightRadius:");
    });
    if (!cornerCls || !radiusCls || ![surface respondsToSelector:setCornerSel]) return;

    id config = nil;
    if (kind == FQXCommentCornerCapsule) {
        if ([cornerCls respondsToSelector:capSel]) {
            config = ((id (*)(id, SEL))objc_msgSend)(cornerCls, capSel);
        }
    } else if (kind == FQXCommentCornerFlushFlat) {
        if ([radiusCls respondsToSelector:fixedSel] && [cornerCls respondsToSelector:uniformSel]) {
            id zeroRad = ((id (*)(id, SEL, CGFloat))objc_msgSend)(radiusCls, fixedSel, 0.0);
            if (zeroRad) config = ((id (*)(id, SEL, id))objc_msgSend)(cornerCls, uniformSel, zeroRad);
        }
    } else if (kind == FQXCommentCornerFloatingCard) {
        CGFloat cardR = radius > 0.0 ? radius : 24.0;
        if ([radiusCls respondsToSelector:fixedSel] && [cornerCls respondsToSelector:uniformSel]) {
            id rad = ((id (*)(id, SEL, CGFloat))objc_msgSend)(radiusCls, fixedSel, cardR);
            if (rad) config = ((id (*)(id, SEL, id))objc_msgSend)(cornerCls, uniformSel, rad);
        }
    } else if (kind == FQXCommentCornerTopSheet) {
        CGFloat topR = (radius >= 8.0 && radius <= 22.0) ? radius : 14.0;
        id topRad = nil;
        if (useConcentric && [radiusCls respondsToSelector:minConcSel]) {
            topRad = ((id (*)(id, SEL, CGFloat))objc_msgSend)(radiusCls, minConcSel, topR);
        } else if ([radiusCls respondsToSelector:fixedSel]) {
            topRad = ((id (*)(id, SEL, CGFloat))objc_msgSend)(radiusCls, fixedSel, topR);
        }
        if (topRad && [cornerCls respondsToSelector:topBotSel]) {
            config = ((id (*)(id, SEL, id, id, id))objc_msgSend)(cornerCls, topBotSel, topRad, nil, nil);
        } else if (topRad && [cornerCls respondsToSelector:uniformSel]) {
            config = ((id (*)(id, SEL, id))objc_msgSend)(cornerCls, uniformSel, topRad);
        }
    }
    if (config) {
        ((void (*)(id, SEL, id))objc_msgSend)(surface, setCornerSel, config);
        objc_setAssociatedObject(surface, FQXAppliedCornerStampKey, @(stamp), OBJC_ASSOCIATION_RETAIN_NONATOMIC);
    }
}

static NSInteger FQXCommentGlassEffectStamp(FQXCommentMaterialStyle matStyle, BOOL dark, BOOL reduceTrans) {
    if (reduceTrans) return 90;
    if (matStyle == FQXCommentMaterialRegularGlass) return 40;
    return dark ? 11 : 10;
}

static UIVisualEffect *FQXBuildCommentGlassEffect(FQXCommentMaterialStyle matStyle, BOOL dark, BOOL reduceTrans) {
    if (reduceTrans || matStyle == FQXCommentMaterialRegularGlass) {
        return FQXMakeGlassEffect(0, YES, nil);
    }
    UIColor *tint = dark ? [UIColor colorWithWhite:0.0 alpha:0.30] : nil;
    return FQXMakeGlassEffect(1, YES, tint);
}

static void FQXConfigureGaussianCommentBlur(FQXBackdropBlurView *surface) {
    if (![surface isKindOfClass:FQXBackdropBlurView.class]) return;
    surface.commentPureMode = YES;
    [FQXTrackedCommentBlurViews() addObject:surface];
    BOOL dark = FQXCommentsUseDarkTheme();
    NSInteger strength = UIAccessibilityIsReduceTransparencyEnabled() ? 100
        : FQXBlurPercent([NSUserDefaults.standardUserDefaults doubleForKey:CommentBlurPrefKey]);
    [surface configurePercent:strength dark:dark baseTint:0.0 maxTint:0.0 chromeBorder:NO];
}

static void FQXReleaseCommentSurface(UIVisualEffectView *surface) {
    if (!surface) return;
    if ([surface isKindOfClass:FQXBackdropBlurView.class]) {
        [(FQXBackdropBlurView *)surface invalidateBlurAnimator];
    } else if ([surface isKindOfClass:FQXCommentGlassSurfaceView.class]) {
        FQXCommentGlassSurfaceView *gs = (FQXCommentGlassSurfaceView *)surface;
        gs.isMaterializing = NO;
        if (gs.supplementalBlur) {
            [gs.supplementalBlur invalidateBlurAnimator];
            [gs.supplementalBlur removeFromSuperview];
            gs.supplementalBlur = nil;
        }
    }
    [surface removeFromSuperview];
}

static void FQXSyncCommentSupplementalBlur(FQXCommentGlassSurfaceView *glass,
                                           FQXCommentCornerKind cornerKind,
                                           CGFloat cornerRadius,
                                           BOOL dark) {
    if (![glass isKindOfClass:FQXCommentGlassSurfaceView.class]) return;
    glass.cornerKind = cornerKind;
    glass.cornerRadius = cornerRadius;
    BOOL reduceTrans = UIAccessibilityIsReduceTransparencyEnabled();
    NSInteger strength = reduceTrans ? 0
        : FQXBlurPercent([NSUserDefaults.standardUserDefaults doubleForKey:CommentBlurPrefKey]);
    if (glass.disablesSupplementalBlur || reduceTrans || strength <= 0) {
        if (glass.supplementalBlur) {
            [glass.supplementalBlur invalidateBlurAnimator];
            [FQXTrackedCommentBlurViews() removeObject:glass.supplementalBlur];
            [glass.supplementalBlur removeFromSuperview];
            glass.supplementalBlur = nil;
        }
        for (UIView *child in [glass.contentView.subviews copy]) {
            if ([child isKindOfClass:FQXBackdropBlurView.class]) {
                [(FQXBackdropBlurView *)child invalidateBlurAnimator];
                [FQXTrackedCommentBlurViews() removeObject:(FQXBackdropBlurView *)child];
                [child removeFromSuperview];
            }
        }
        return;
    }
    FQXBackdropBlurView *sub = glass.supplementalBlur;
    if (!sub) {
        sub = [[FQXBackdropBlurView alloc] initWithEffect:nil];
        sub.commentPureMode = YES;
        sub.userInteractionEnabled = NO;
        sub.accessibilityElementsHidden = YES;
        sub.isAccessibilityElement = NO;
        sub.opaque = NO;
        sub.backgroundColor = UIColor.clearColor;
        sub.contentView.backgroundColor = UIColor.clearColor;
        sub.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
        glass.supplementalBlur = sub;
        [FQXTrackedCommentBlurViews() addObject:sub];
    }
    if (sub.superview != glass.contentView) {
        [glass.contentView insertSubview:sub atIndex:0];
    }
    sub.frame = glass.contentView.bounds;
    FQXApplyCommentCornerConfig(sub, cornerKind, cornerRadius);
    [sub configurePercent:strength dark:dark baseTint:0.0 maxTint:0.0 chromeBorder:NO];
}

static UIVisualEffectView *FQXEnsureCommentSurface(UIView *host,
                                                   const void *assocKey,
                                                   FQXCommentMaterialStyle matStyle) {
    if (!host || !assocKey) return nil;
    BOOL wantsBlur = (matStyle == FQXCommentMaterialGaussianBlur);
    UIVisualEffectView *surface = objc_getAssociatedObject(host, assocKey);
    BOOL isBlur = [surface isKindOfClass:FQXBackdropBlurView.class];
    BOOL isGlassSurface = [surface isKindOfClass:FQXCommentGlassSurfaceView.class];
    if (surface && ((wantsBlur && !isBlur) || (!wantsBlur && !isGlassSurface))) {
        FQXReleaseCommentSurface(surface);
        objc_setAssociatedObject(host, assocKey, nil, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
        surface = nil;
    }
    if (!surface) {
        if (wantsBlur) {
            surface = [[FQXBackdropBlurView alloc] initWithEffect:nil];
            ((FQXBackdropBlurView *)surface).commentPureMode = YES;
            [FQXTrackedCommentBlurViews() addObject:(FQXBackdropBlurView *)surface];
        } else {
            surface = [[FQXCommentGlassSurfaceView alloc] initWithEffect:nil];
            [FQXTrackedCommentGlassSurfaces() addObject:(FQXCommentGlassSurfaceView *)surface];
        }
        if (surface) {
            surface.userInteractionEnabled = NO;
            surface.accessibilityElementsHidden = YES;
            surface.isAccessibilityElement = NO;
            surface.alpha = 1.0;
            surface.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
            if (wantsBlur) {
                surface.opaque = NO;
                surface.backgroundColor = UIColor.clearColor;
                surface.contentView.backgroundColor = UIColor.clearColor;
            }
            objc_setAssociatedObject(host, assocKey, surface, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
        }
    }
    return surface;
}

static void FQXSyncCommentSurface(UIVisualEffectView *surface,
                                  UIViewController *ownerVC,
                                  FQXCommentMaterialStyle matStyle,
                                  FQXCommentCornerKind cornerKind,
                                  CGFloat cornerRadius,
                                  BOOL allowMaterializeAnimation) {
    if (!surface) return;
    if (surface.window.windowScene) {
        FQXObserveWindowSceneTraitsIfNeeded(surface.window.windowScene);
    }
    BOOL dark = FQXCommentsUseDarkTheme();
    UIUserInterfaceStyle desiredUIStyle =
        (matStyle == FQXCommentMaterialClearGlass)
            ? UIUserInterfaceStyleUnspecified
            : (dark ? UIUserInterfaceStyleDark : UIUserInterfaceStyleLight);
    if (surface.overrideUserInterfaceStyle != desiredUIStyle) {
        surface.overrideUserInterfaceStyle = desiredUIStyle;
    }
    if (surface.alpha < 1.0) surface.alpha = 1.0;

    if ([surface isKindOfClass:FQXBackdropBlurView.class]) {
        if (surface.backgroundColor && ![surface.backgroundColor isEqual:UIColor.clearColor]) {
            surface.backgroundColor = UIColor.clearColor;
        }
        if (surface.contentView.backgroundColor && ![surface.contentView.backgroundColor isEqual:UIColor.clearColor]) {
            surface.contentView.backgroundColor = UIColor.clearColor;
        }
        surface.layer.shadowOpacity = 0.0f;
        surface.layer.shadowRadius = 0.0;
        surface.layer.borderWidth = 0.0;
        surface.layer.borderColor = NULL;
        surface.contentView.layer.borderWidth = 0.0;
        surface.contentView.layer.borderColor = NULL;
        [CATransaction begin];
        [CATransaction setDisableActions:YES];
        FQXApplyCommentCornerConfig(surface, cornerKind, cornerRadius);
        [CATransaction commit];
        FQXConfigureGaussianCommentBlur((FQXBackdropBlurView *)surface);
        return;
    }

    [CATransaction begin];
    [CATransaction setDisableActions:YES];
    FQXApplyCommentCornerConfig(surface, cornerKind, cornerRadius);
    [CATransaction commit];

    if ([surface isKindOfClass:FQXCommentGlassSurfaceView.class]) {
        FQXSyncCommentSupplementalBlur((FQXCommentGlassSurfaceView *)surface, cornerKind, cornerRadius, dark);
    }

    if (CGRectGetWidth(surface.bounds) < 1.0 || CGRectGetHeight(surface.bounds) < 1.0) return;

    BOOL reduceTrans = UIAccessibilityIsReduceTransparencyEnabled();
    NSInteger desiredStamp = FQXCommentGlassEffectStamp(matStyle, dark, reduceTrans);
    NSNumber *appliedStamp = objc_getAssociatedObject(surface, FQXCommentGlassStyleAppliedKey);
    BOOL hadEffect = (surface.effect != nil);
    if (hadEffect && appliedStamp && appliedStamp.integerValue == desiredStamp) return;

    FQXCommentGlassSurfaceView *gs = [surface isKindOfClass:FQXCommentGlassSurfaceView.class]
        ? (FQXCommentGlassSurfaceView *)surface : nil;
    if (!hadEffect && gs && gs.isMaterializing) return;

    UIVisualEffect *effect = FQXBuildCommentGlassEffect(matStyle, dark, reduceTrans);
    if (!effect) return;

    __weak UIVisualEffectView *weakSurface = surface;
    void (^applyBlock)(void) = ^{
        UIVisualEffectView *s = weakSurface;
        if (!s) return;
        if ([s isKindOfClass:FQXCommentGlassSurfaceView.class]) {
            ((FQXCommentGlassSurfaceView *)s).isMaterializing = NO;
        }
        if (!s.superview || !FQXCommentStylingEnabled()) return;
        UIUserInterfaceStyle liveStyle =
            (matStyle == FQXCommentMaterialClearGlass)
                ? UIUserInterfaceStyleUnspecified
                : (FQXCommentsUseDarkTheme() ? UIUserInterfaceStyleDark : UIUserInterfaceStyleLight);
        if (s.overrideUserInterfaceStyle != liveStyle) {
            s.overrideUserInterfaceStyle = liveStyle;
        }
        s.effect = effect;
        objc_setAssociatedObject(s, FQXCommentGlassStyleAppliedKey, @(desiredStamp), OBJC_ASSOCIATION_RETAIN_NONATOMIC);
        FQXResyncVisibleCommentSheetYields(s.window);
    };

    if (!allowMaterializeAnimation || !surface.window || UIAccessibilityIsReduceMotionEnabled()) {
        [UIView performWithoutAnimation:applyBlock];
        return;
    }

    if (!hadEffect) {
        if (gs) gs.isMaterializing = YES;
        id<UIViewControllerTransitionCoordinator> tc = ownerVC.transitionCoordinator;
        if (tc && tc.isAnimated) {
            BOOL accepted = [tc animateAlongsideTransition:^(__unused id<UIViewControllerTransitionCoordinatorContext> ctx) {
                applyBlock();
            } completion:^(id<UIViewControllerTransitionCoordinatorContext> ctx) {
                UIVisualEffectView *s = weakSurface;
                if (s && [s isKindOfClass:FQXCommentGlassSurfaceView.class]) {
                    ((FQXCommentGlassSurfaceView *)s).isMaterializing = NO;
                }
                if (s && ![ctx isCancelled] && !s.effect) applyBlock();
            }];
            if (accepted) return;
        }
        [UIView animateWithDuration:0.25
                              delay:0.0
                            options:(UIViewAnimationOptionBeginFromCurrentState |
                                     UIViewAnimationOptionAllowUserInteraction |
                                     UIViewAnimationOptionCurveEaseInOut)
                         animations:applyBlock
                         completion:nil];
    } else {
        [UIView animateWithDuration:0.25
                              delay:0.0
                            options:(UIViewAnimationOptionBeginFromCurrentState |
                                     UIViewAnimationOptionAllowUserInteraction |
                                     UIViewAnimationOptionCurveEaseInOut)
                         animations:applyBlock
                         completion:nil];
    }
}

static void FQXRefreshCommentBlurStrengthOnly(void) {
    if (!NSThread.isMainThread) {
        dispatch_async(dispatch_get_main_queue(), ^{ FQXRefreshCommentBlurStrengthOnly(); });
        return;
    }
    FQXCommentMaterialStyle matStyle = FQXCurrentCommentMaterialStyle();
    BOOL dark = FQXCommentsUseDarkTheme();
    if (FQXIsNativeGlassCommentStyle(matStyle) && FQXGlassEnabled()) {
        for (FQXCommentGlassSurfaceView *glass in FQXTrackedCommentGlassSurfaces().allObjects) {
            if (!glass.superview) continue;
            FQXSyncCommentSupplementalBlur(glass, glass.cornerKind, glass.cornerRadius, dark);
        }
        return;
    }
    BOOL active = (matStyle == FQXCommentMaterialGaussianBlur) ||
                  (FQXCurrentCommentComposerStyle() != FQXCommentComposerNative && !FQXGlassEnabled());
    if (!active) return;
    NSInteger strength = UIAccessibilityIsReduceTransparencyEnabled() ? 100
        : FQXBlurPercent([NSUserDefaults.standardUserDefaults doubleForKey:CommentBlurPrefKey]);
    for (FQXBackdropBlurView *blur in FQXTrackedCommentBlurViews().allObjects) {
        if (!blur.commentPureMode || !blur.superview) continue;
        [blur configurePercent:strength dark:dark baseTint:0.0 maxTint:0.0 chromeBorder:NO];
    }
}

// Lightweight next-runloop Liquid Glass scroll-edge hint for SSTabBarController, adapted from
// ChenYilong/CYLTabBarController's -cyl_setNeedsLiquidGlassTabBarResample (MIT License).
// Never forces synchronous bar layout mid-animation so Dock spring motion stays 120Hz-smooth.
static void FQXScheduleCYLGlassResample(UIView *bar, UIVisualEffectView *proxy) {
    if (!bar || !proxy || !FQXGlassEnabled()) return;
    __weak UIView *weakBar = bar;
    __weak UIVisualEffectView *weakProxy = proxy;
    dispatch_async(dispatch_get_main_queue(), ^{
        UIView *strongBar = weakBar;
        UIVisualEffectView *strongProxy = weakProxy;
        if (!strongBar || !strongProxy || !strongBar.window) return;
        UIResponder *resp = strongBar.nextResponder;
        UIViewController *tabVC = nil;
        while (resp) {
            if ([resp isKindOfClass:UIViewController.class]) {
                tabVC = (UIViewController *)resp;
                break;
            }
            resp = resp.nextResponder;
        }
        UIViewController *selectedVC = nil;
        if ([tabVC respondsToSelector:@selector(selectedViewController)]) {
            selectedVC = ((id (*)(id, SEL))objc_msgSend)(tabVC, @selector(selectedViewController));
        }
        if ([selectedVC isKindOfClass:UINavigationController.class]) {
            selectedVC = ((UINavigationController *)selectedVC).topViewController ?: selectedVC;
        }
        if (selectedVC && [selectedVC respondsToSelector:@selector(contentScrollViewForEdge:)]) {
            UIScrollView *sv = [selectedVC contentScrollViewForEdge:NSDirectionalRectEdgeBottom];
            if (sv && [selectedVC respondsToSelector:@selector(setContentScrollView:forEdge:)]) {
                [selectedVC setContentScrollView:sv forEdge:NSDirectionalRectEdgeBottom];
            }
        }
    });
}

typedef NS_ENUM(NSInteger, FQXDockMaterialMode) {
    FQXDockMaterialNewGlass = 0,      // 新液态玻璃（最新）
    FQXDockMaterialLegacyGlass = 1,   // 老液态玻璃（beta5 以前）
    FQXDockMaterialFrostedGlass = 2,  // 模糊玻璃（比 beta5 更模糊）
    FQXDockMaterialIOS18Gaussian = 3, // 高斯模糊（iOS 18 高斯模糊）
};

static FQXDockMaterialMode FQXCurrentDockMaterialMode(void) {
    return (FQXDockMaterialMode)FQXHotPrefsSnapshot().dockMaterialMode;
}

static UIColor *FQXDockRestingSelectionColor(BOOL dark) {
    // Subtle neutral recessed pill fill — never adds a white disc on Clear glass.
    return dark ? [UIColor colorWithWhite:0.0 alpha:0.20]
                : [UIColor colorWithWhite:0.0 alpha:0.065];
}

static UIColor *FQXDockSelectionColorForMode(FQXDockMaterialMode mode, BOOL dark) {
    if (mode == FQXDockMaterialFrostedGlass) {
        return dark ? [UIColor colorWithWhite:1.0 alpha:0.18]
                    : [UIColor colorWithWhite:0.0 alpha:0.085];
    }
    if (mode == FQXDockMaterialLegacyGlass) {
        return dark ? [UIColor colorWithWhite:1.0 alpha:0.14]
                    : [UIColor colorWithWhite:0.0 alpha:0.065];
    }
    return FQXDockRestingSelectionColor(dark);
}

static BOOL FQXBackdropFilterAvailable(void) {
    static BOOL available = NO;
    static dispatch_once_t once;
    dispatch_once(&once, ^{
        Class bdCls = NSClassFromString(@"CABackdropLayer");
        Class filterCls = NSClassFromString(@"CAFilter");
        SEL filterSel = NSSelectorFromString(@"filterWithType:");
        available = bdCls != Nil && filterCls != Nil && [filterCls respondsToSelector:filterSel];
    });
    return available;
}


@implementation FQXBackdropBlurView
- (instancetype)initWithEffect:(UIVisualEffect *)effect {
    self = [super initWithEffect:effect];
    if (self) {
        _usingHardwareFilter = FQXBackdropFilterAvailable();
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(blurDidBecomeActive:)
            name:UIApplicationDidBecomeActiveNotification object:nil];
    }
    return self;
}
- (void)dealloc {
    [[NSNotificationCenter defaultCenter] removeObserver:self];
    if (_blurAnimator.state == UIViewAnimatingStateActive) [_blurAnimator stopAnimation:YES];
}
- (void)layoutSubviews {
    [super layoutSubviews];
    CGRect bounds = self.contentView.bounds;
    if (self.backdropHost && !CGRectEqualToRect(self.backdropHost.frame, bounds)) {
        self.backdropHost.frame = bounds;
    }
    if (self.tintOverlay && !CGRectEqualToRect(self.tintOverlay.frame, bounds)) {
        self.tintOverlay.frame = bounds;
    }
}
- (void)invalidateBlurAnimator {
    if (self.blurAnimator.state == UIViewAnimatingStateActive) [self.blurAnimator stopAnimation:YES];
    self.blurAnimator = nil;
    self.animatorWindow = nil;
    self.effect = nil;
    if (self.backdropHost) {
        @try {
            [self.backdropHost.layer setValue:nil forKey:@"filters"];
        } @catch (__unused NSException *e) {}
        [self.backdropHost removeFromSuperview];
        self.backdropHost = nil;
    }
    if (self.tintOverlay) {
        self.tintOverlay.backgroundColor = UIColor.clearColor;
        [self.tintOverlay removeFromSuperview];
        self.tintOverlay = nil;
    }
    self.layer.borderWidth = 0.0;
    self.layer.borderColor = NULL;
}
- (void)didMoveToWindow {
    [super didMoveToWindow];
    if (self.usingHardwareFilter) {
        if (self.window) [self applyHardwareBlur];
        return;
    }
    // UIKit can discard backdrop interpolation while a sheet is offscreen.
    [self invalidateBlurAnimator];
    if (self.window) [self scheduleBlurUpdate];
}
- (void)blurDidBecomeActive:(NSNotification *)notification {
    (void)notification;
    if (self.usingHardwareFilter) {
        if (self.window) [self applyHardwareBlur];
        return;
    }
    [self invalidateBlurAnimator];
    if (self.window) [self scheduleBlurUpdate];
}
- (void)configurePercent:(NSInteger)percent
                    dark:(BOOL)dark
                baseTint:(CGFloat)baseTint
                 maxTint:(CGFloat)maxTint
            chromeBorder:(BOOL)chromeBorder {
    self.isDarkStyle = dark;
    self.baseTintAlpha = baseTint;
    self.maxTintAlpha = maxTint;
    self.matteChromeBorder = chromeBorder;
    self.percent = FQXBlurPercent(percent);
    if (self.usingHardwareFilter) {
        [self applyHardwareBlur];
    } else {
        UIBlurEffectStyle targetStyle = dark
            ? (chromeBorder ? UIBlurEffectStyleSystemChromeMaterialDark : UIBlurEffectStyleSystemUltraThinMaterialDark)
            : (chromeBorder ? UIBlurEffectStyleSystemChromeMaterialLight : UIBlurEffectStyleSystemUltraThinMaterialLight);
        if (self.blurStyle != targetStyle) {
            [self invalidateBlurAnimator];
            self.blurStyle = targetStyle;
        }
        [self scheduleBlurUpdate];
    }
}
- (void)configurePercent:(NSInteger)percent style:(UIBlurEffectStyle)style {
    BOOL dark = (style == UIBlurEffectStyleDark ||
                 style == UIBlurEffectStyleSystemMaterialDark ||
                 style == UIBlurEffectStyleSystemThinMaterialDark ||
                 style == UIBlurEffectStyleSystemChromeMaterialDark ||
                 style == UIBlurEffectStyleSystemUltraThinMaterialDark ||
                 style == UIBlurEffectStyleSystemThickMaterialDark);
    BOOL chrome = (style == UIBlurEffectStyleSystemChromeMaterialDark ||
                   style == UIBlurEffectStyleSystemChromeMaterialLight);
    if (self.blurStyle != style && !self.usingHardwareFilter) {
        [self invalidateBlurAnimator];
    }
    self.blurStyle = style;
    [self configurePercent:percent dark:dark baseTint:0.0 maxTint:(chrome ? 0.48 : 0.36) chromeBorder:NO];
}
- (void)applyHardwareBlur {
    if (!self.usingHardwareFilter) return;
    if (!self.window && self.percent <= 0 && !self.matteChromeBorder && self.baseTintAlpha <= 0.0005) {
        return;
    }
    if (self.effect) self.effect = nil;

    int p = (int)self.percent;
    CGFloat radius = FQXBlurGaussianRadius(p);
    CGFloat sat = self.commentPureMode
        ? (1.0 + 0.35 * FQXBlurFraction(p))
        : FQXBlurSaturation(p);
    CGFloat tintAlpha = FQXBlurTintAlpha(p, self.baseTintAlpha, self.maxTintAlpha);
    BOOL needsBackdrop = (radius > 0.0);
    BOOL needsTintOverlay = (tintAlpha > 0.0005) &&
                            !(self.commentPureMode && self.maxTintAlpha <= 0.0005 && self.baseTintAlpha <= 0.0005);

    if (needsBackdrop && !self.backdropHost) {
        FQXBackdropHostView *host = [[FQXBackdropHostView alloc] initWithFrame:self.contentView.bounds];
        host.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
        host.userInteractionEnabled = NO;
        host.clipsToBounds = YES;
        [self.contentView insertSubview:host atIndex:0];
        self.backdropHost = host;
    }
    if (needsTintOverlay && !self.tintOverlay) {
        UIView *tint = [[UIView alloc] initWithFrame:self.contentView.bounds];
        tint.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
        tint.userInteractionEnabled = NO;
        [self.contentView addSubview:tint];
        self.tintOverlay = tint;
    } else if (!needsTintOverlay && self.tintOverlay) {
        self.tintOverlay.backgroundColor = UIColor.clearColor;
        [self.tintOverlay removeFromSuperview];
        self.tintOverlay = nil;
    }

    [CATransaction begin];
    [CATransaction setDisableActions:YES];
    if (self.backdropHost) self.backdropHost.frame = self.contentView.bounds;
    if (self.tintOverlay) self.tintOverlay.frame = self.contentView.bounds;
    BOOL filterApplied = YES;
    @try {
        if (needsBackdrop && self.backdropHost) {
            CALayer *layer = self.backdropHost.layer;
            CGFloat scale = self.commentPureMode ? 0.5 : ((radius < 4.0) ? 1.0 : 0.5);
            @try {
                [layer setValue:@(scale) forKey:@"scale"];
            } @catch (__unused NSException *ignored) {}
            NSArray *existing = [layer valueForKey:@"filters"];
            if ([existing isKindOfClass:NSArray.class] && existing.count == 2) {
                [layer setValue:@(radius) forKeyPath:@"filters.gaussianBlur.inputRadius"];
                [layer setValue:@(sat) forKeyPath:@"filters.colorSaturate.inputAmount"];
            } else {
                Class filterCls = NSClassFromString(@"CAFilter");
                SEL filterSel = NSSelectorFromString(@"filterWithType:");
                id blurFilter = ((id (*)(id, SEL, id))objc_msgSend)(filterCls, filterSel, @"gaussianBlur");
                id satFilter = ((id (*)(id, SEL, id))objc_msgSend)(filterCls, filterSel, @"colorSaturate");
                if (blurFilter && satFilter) {
                    [blurFilter setValue:@"gaussianBlur" forKey:@"name"];
                    [blurFilter setValue:@YES forKey:@"inputNormalizeEdges"];
                    [blurFilter setValue:@(radius) forKey:@"inputRadius"];
                    [satFilter setValue:@"colorSaturate" forKey:@"name"];
                    [satFilter setValue:@(sat) forKey:@"inputAmount"];
                    [layer setValue:@[blurFilter, satFilter] forKey:@"filters"];
                } else {
                    filterApplied = NO;
                }
            }
            self.backdropHost.hidden = !filterApplied;
        } else if (self.backdropHost) {
            @try {
                [self.backdropHost.layer setValue:nil forKey:@"filters"];
            } @catch (__unused NSException *ignored) {}
            [self.backdropHost removeFromSuperview];
            self.backdropHost = nil;
        }
    } @catch (__unused NSException *e) {
        filterApplied = NO;
    }

    if (self.tintOverlay) {
        UIColor *tintColor = UIColor.clearColor;
        if (tintAlpha > 0.0005) {
            tintColor = self.isDarkStyle
                ? [UIColor colorWithWhite:0.10 alpha:tintAlpha]
                : [UIColor colorWithWhite:0.97 alpha:tintAlpha];
        }
        self.tintOverlay.backgroundColor = tintColor;
    }

    if (self.matteChromeBorder) {
        self.layer.borderWidth = 0.5;
        self.layer.borderColor = (self.isDarkStyle
            ? [UIColor colorWithWhite:1.0 alpha:0.14]
            : [UIColor colorWithWhite:0.0 alpha:0.08]).CGColor;
    } else {
        self.layer.borderWidth = 0.0;
        self.layer.borderColor = NULL;
    }
    [CATransaction commit];

    if (!filterApplied) {
        self.usingHardwareFilter = NO;
        [self invalidateBlurAnimator];
        if (self.percent > 0) [self scheduleBlurUpdate];
    }
}
- (void)scheduleBlurUpdate {
    if (self.usingHardwareFilter) {
        [self applyHardwareBlur];
        return;
    }
    if (self.applyPending) return;
    self.applyPending = YES;
    __weak FQXBackdropBlurView *weakSelf = self;
    // Comment layout calls us inside performWithoutAnimation. Creating the effect
    // animator there applies a full material even when fractionComplete is 0.01.
    dispatch_async(dispatch_get_main_queue(), ^{
        FQXBackdropBlurView *view = weakSelf;
        if (!view || view.usingHardwareFilter) return;
        view.applyPending = NO;
        if (!view.window || view.percent <= 0) {
            [view invalidateBlurAnimator];
            return;
        }
        if (!view.blurAnimator || view.blurAnimator.state != UIViewAnimatingStateActive ||
            view.animatorWindow != view.window) {
            [view invalidateBlurAnimator];
            BOOL animationsEnabled = UIView.areAnimationsEnabled;
            if (!animationsEnabled) [UIView setAnimationsEnabled:YES];
            @try {
                UIBlurEffectStyle style = view.blurStyle ?: (view.isDarkStyle
                    ? UIBlurEffectStyleSystemUltraThinMaterialDark
                    : UIBlurEffectStyleSystemUltraThinMaterialLight);
                __weak FQXBackdropBlurView *weakBlur = view;
                UIViewPropertyAnimator *animator = [[UIViewPropertyAnimator alloc]
                    initWithDuration:1.0 curve:UIViewAnimationCurveLinear animations:^{
                        weakBlur.effect = [UIBlurEffect effectWithStyle:style];
                    }];
                animator.pausesOnCompletion = YES;
                animator.scrubsLinearly = YES;
                [animator startAnimation];
                [animator pauseAnimation];
                view.blurAnimator = animator;
                view.animatorWindow = view.window;
            } @finally {
                if (!animationsEnabled) [UIView setAnimationsEnabled:NO];
            }
        }
        CGFloat linear = FQXBlurFraction((int)view.percent);
        CGFloat fraction = view.commentPureMode ? linear : (CGFloat)pow(linear, 1.8);
        if (view.blurAnimator.fractionComplete != fraction) view.blurAnimator.fractionComplete = fraction;
    });
}
@end

static const void *FQXDockBackdropBlurViewKey = &FQXDockBackdropBlurViewKey;

static void FQXClearDockBackdropBlur(UIView *owner) {
    if (!owner) return;
    FQXBackdropBlurView *blur = objc_getAssociatedObject(owner, FQXDockBackdropBlurViewKey);
    if (blur) {
        [blur invalidateBlurAnimator];
        [blur removeFromSuperview];
        objc_setAssociatedObject(owner, FQXDockBackdropBlurViewKey, nil, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
    }
}

static void FQXApplyDockBackdropBlur(UIView *owner, UIView *container, UIView *anchor, CGRect frame,
                                     CGFloat radius, BOOL dark, FQXDockMaterialMode mode, NSString *preference) {
    FQXBackdropBlurView *blur = objc_getAssociatedObject(owner, FQXDockBackdropBlurViewKey);
    NSInteger strength = FQXBlurPercent([NSUserDefaults.standardUserDefaults doubleForKey:preference]);
    BOOL needsView = (strength > 0) || (mode == FQXDockMaterialIOS18Gaussian);
    if (!container || !needsView || UIAccessibilityIsReduceTransparencyEnabled()) {
        if (blur) {
            [blur invalidateBlurAnimator];
            [blur removeFromSuperview];
            objc_setAssociatedObject(owner, FQXDockBackdropBlurViewKey, nil, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
        }
        return;
    }

    if (!blur) {
        blur = [[FQXBackdropBlurView alloc] initWithEffect:nil];
        blur.userInteractionEnabled = NO;
        blur.accessibilityElementsHidden = YES;
        blur.layer.cornerCurve = kCACornerCurveContinuous;
        blur.clipsToBounds = YES;
        objc_setAssociatedObject(owner, FQXDockBackdropBlurViewKey, blur, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
        objc_setAssociatedObject(blur, FQXOwnedGlassElementKey, @YES, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
    }
    if (blur.superview != container) {
        if (anchor) [container insertSubview:blur belowSubview:anchor];
        else [container insertSubview:blur atIndex:0];
    }
    if (!CGRectEqualToRect(blur.frame, frame)) blur.frame = frame;
    CGFloat half = MIN(CGRectGetWidth(frame), CGRectGetHeight(frame)) * 0.5;
    CGFloat corner = (radius < 0.0) ? half : MIN(radius, half);
    if (blur.layer.cornerRadius != corner) blur.layer.cornerRadius = corner;

    CGFloat baseTint = 0.0;
    CGFloat maxTint = dark ? 0.26 : 0.24;
    BOOL chromeBorder = NO;
    switch (mode) {
        case FQXDockMaterialLegacyGlass:
            baseTint = 0.0;
            maxTint = dark ? 0.30 : 0.28;
            break;
        case FQXDockMaterialFrostedGlass:
            baseTint = 0.0;
            maxTint = dark ? 0.38 : 0.36;
            break;
        case FQXDockMaterialIOS18Gaussian:
            baseTint = dark ? 0.24 : 0.28;
            maxTint = dark ? 0.64 : 0.70;
            chromeBorder = YES;
            break;
        case FQXDockMaterialNewGlass:
        default:
            break;
    }
    [blur configurePercent:strength dark:dark baseTint:baseTint maxTint:maxTint chromeBorder:chromeBorder];
}

static void FQXApplyBackdropBlur(UIView *owner, UIView *container, UIView *anchor, CGRect frame,
                                 CGFloat radius, BOOL dark, NSString *preference) {
    FQXApplyDockBackdropBlur(owner, container, anchor, frame, radius, dark, FQXDockMaterialNewGlass, preference);
}

static UIVisualEffect *FQXMakeDockEffectForMode(FQXDockMaterialMode mode, BOOL isDark, BOOL interactive, BOOL reduceTrans) {
    if (reduceTrans) return FQXMakeGlassEffect(0, interactive, nil);
    switch (mode) {
        case FQXDockMaterialLegacyGlass: {
            UIColor *tint = isDark
                ? [UIColor colorWithWhite:0.08 alpha:0.16]
                : [UIColor colorWithWhite:1.0 alpha:0.16];
            return FQXMakeGlassEffect(1, interactive, tint);
        }
        case FQXDockMaterialFrostedGlass: {
            UIColor *tint = isDark
                ? [UIColor colorWithWhite:0.08 alpha:0.30]
                : [UIColor colorWithWhite:0.96 alpha:0.30];
            return FQXMakeGlassEffect(0, interactive, tint);
        }
        case FQXDockMaterialIOS18Gaussian:
            // Preserve native interactive liquid lens/drag/spring while Gaussian backdrop sits beneath.
            return FQXMakeGlassEffect(1, interactive, nil);
        case FQXDockMaterialNewGlass:
        default: {
            UIColor *tint = (isDark && FQXGlassDarkTintEnabled()) ? [UIColor colorWithWhite:0.0 alpha:0.30] : nil;
            return FQXMakeGlassEffect(1, interactive, tint);
        }
    }
}

typedef NS_ENUM(NSInteger, FQXDockMaterialOwner) {
    FQXDockMaterialOwnerNone = 0,
    FQXDockMaterialOwnerNative = 1, // Expanded: UITabBar platter (+ optional detached circle) owns all visible glass; proxy.effect MUST stay nil
    FQXDockMaterialOwnerProxy = 2,  // Compact or legacy segmented fallback: proxy owns the single visible glass
};

static const void *FQXDockMaterialOwnerKey = &FQXDockMaterialOwnerKey;
static NSUInteger gFQXProxyBlockedWriteCount = 0;
static BOOL gFQXAllowOwnedProxyEffectWrite = NO;
static void (*OrigVisualEffectSetEffectForOwner)(id, SEL, id);

static FQXDockMaterialOwner FQXGetDockMaterialOwner(UIVisualEffectView *proxy) {
    if (!proxy) return FQXDockMaterialOwnerNone;
    NSNumber *num = objc_getAssociatedObject(proxy, FQXDockMaterialOwnerKey);
    return num ? (FQXDockMaterialOwner)num.integerValue : FQXDockMaterialOwnerNone;
}

static NSString *FQXDockMaterialOwnerName(FQXDockMaterialOwner owner) {
    switch (owner) {
        case FQXDockMaterialOwnerNative: return @"native_tabbar";
        case FQXDockMaterialOwnerProxy: return @"proxy_compact_or_fallback";
        case FQXDockMaterialOwnerNone:
        default: return @"none";
    }
}

static void FQXWriteProxyEffectDirectly(UIVisualEffectView *proxy, UIVisualEffect *effect) {
    if (![proxy isKindOfClass:UIVisualEffectView.class]) return;
    if (proxy.effect == effect) return;
    BOOL prev = gFQXAllowOwnedProxyEffectWrite;
    gFQXAllowOwnedProxyEffectWrite = YES;
    if (OrigVisualEffectSetEffectForOwner) {
        OrigVisualEffectSetEffectForOwner(proxy, @selector(setEffect:), effect);
    } else {
        proxy.effect = effect;
    }
    gFQXAllowOwnedProxyEffectWrite = prev;
}

static void HookVisualEffectSetEffectForOwner(UIVisualEffectView *view, SEL cmd, UIVisualEffect *effect) {
    if (!gFQXAllowOwnedProxyEffectWrite) {
        NSNumber *ownerNum = objc_getAssociatedObject(view, FQXDockMaterialOwnerKey);
        if (ownerNum) {
            FQXDockMaterialOwner owner = (FQXDockMaterialOwner)ownerNum.integerValue;
            if (owner == FQXDockMaterialOwnerNative && FQXGlassEnabled()) {
                // Expanded Dock is owned by nativeDockBar (+ detached circle). Block
                // repair162/material_lifecycle.s (Lmaterial_update) from re-attaching
                // Regular (0) milky glass onto proxy on every layout pass.
                if (effect != nil) gFQXProxyBlockedWriteCount++;
                if (view.effect != nil && OrigVisualEffectSetEffectForOwner) {
                    OrigVisualEffectSetEffectForOwner(view, cmd, nil);
                }
                return;
            }
            if (owner == FQXDockMaterialOwnerProxy && effect != nil && FQXGlassEnabled()) {
                // In compact/fallback mode, keep the user's configured Clear/Legacy/Frosted/Gaussian
                // effect rather than letting Lmaterial_update overwrite it with Regular (0).
                BOOL reduceTrans = UIAccessibilityIsReduceTransparencyEnabled();
                FQXDockMaterialMode mode = FQXCurrentDockMaterialMode();
                UIUserInterfaceStyle dockStyle = view.overrideUserInterfaceStyle;
                BOOL darkDock = (dockStyle == UIUserInterfaceStyleDark) ||
                    (dockStyle == UIUserInterfaceStyleUnspecified &&
                     view.traitCollection.userInterfaceStyle == UIUserInterfaceStyleDark);
                UIVisualEffect *ownedEffect = FQXMakeDockEffectForMode(mode, darkDock, YES, reduceTrans);
                if (ownedEffect) effect = ownedEffect;
            }
        }
    }
    if (OrigVisualEffectSetEffectForOwner) {
        OrigVisualEffectSetEffectForOwner(view, cmd, effect);
    }
}

static void FQXApplyDockProxyMaterial(UIView *bar, UIVisualEffectView *proxy, UIVisualEffectView *lens) {
    if (!proxy || !FQXGlassEnabled()) return;
    // Never materialize glass on proxy while native UITabBar owns the expanded Dock.
    if (FQXGetDockMaterialOwner(proxy) == FQXDockMaterialOwnerNative) {
        FQXWriteProxyEffectDirectly(proxy, nil);
        FQXClearDockBackdropBlur(proxy);
        return;
    }
    BOOL reduceTrans = UIAccessibilityIsReduceTransparencyEnabled();
    FQXDockMaterialMode mode = FQXCurrentDockMaterialMode();
    BOOL darkTint = FQXGlassDarkTintEnabled();
    UIUserInterfaceStyle dockStyle = proxy.overrideUserInterfaceStyle;
    BOOL darkDock = dockStyle == UIUserInterfaceStyleDark ||
        (dockStyle == UIUserInterfaceStyleUnspecified && proxy.traitCollection.userInterfaceStyle == UIUserInterfaceStyleDark);
    NSNumber *appliedMode = objc_getAssociatedObject(proxy, FQXUnifiedClearDockKey);
    NSInteger desiredMode = reduceTrans ? 99 : ((darkTint ? 100 : 0) + (darkDock ? 20 : 10) + (NSInteger)mode);
    BOOL effectLost = (!proxy.effect || [proxy.effect isKindOfClass:UIBlurEffect.class]);
    if (!appliedMode || appliedMode.integerValue != desiredMode || effectLost) {
        UIVisualEffect *effect = FQXMakeDockEffectForMode(mode, darkDock, YES, reduceTrans);
        if (effect) {
            FQXWriteProxyEffectDirectly(proxy, effect);
            FQXApplyCornerConfiguration(proxy, 0.0, NO);
            objc_setAssociatedObject(proxy, FQXUnifiedClearDockKey, @(desiredMode), OBJC_ASSOCIATION_RETAIN_NONATOMIC);
            FQXDiagRecordEvent(FQXDiagCategoryUI, @"dock_proxy_material", @{
                @"mode": @((NSInteger)mode),
                @"darkTint": @(darkTint),
                @"darkDock": @(darkDock),
                @"overrideStyle": @((NSInteger)proxy.overrideUserInterfaceStyle),
                @"hasTint": @((mode == FQXDockMaterialNewGlass && darkDock && darkTint && !reduceTrans) ? YES : NO),
                @"reduceTransparency": @(reduceTrans),
                @"owner": FQXDockMaterialOwnerName(FQXGetDockMaterialOwner(proxy)),
            }, NO);
        }
    }
    if (proxy.backgroundColor && ![proxy.backgroundColor isEqual:UIColor.clearColor]) {
        proxy.backgroundColor = UIColor.clearColor;
    }
    if (proxy.contentView.backgroundColor && ![proxy.contentView.backgroundColor isEqual:UIColor.clearColor]) {
        proxy.contentView.backgroundColor = UIColor.clearColor;
    }
    if (bar && bar.backgroundColor && ![bar.backgroundColor isEqual:UIColor.clearColor]) {
        bar.backgroundColor = UIColor.clearColor;
    }
    // Eliminate duplicate/milky sibling blur layers inside the tab bar so only one clean glass exists,
    // and ensure the compact expand button never carries an opaque/white backing.
    if (bar) {
        Class compactBtnCls = NSClassFromString(@"FanqieXCompactBottomButton178R7");
        for (UIView *sub in [bar.subviews copy]) {
            if (compactBtnCls && [sub isKindOfClass:compactBtnCls]) {
                if (sub.backgroundColor && ![sub.backgroundColor isEqual:UIColor.clearColor]) {
                    sub.backgroundColor = UIColor.clearColor;
                }
                continue;
            }
            if (sub == proxy || sub == lens || ![sub isKindOfClass:UIVisualEffectView.class]) continue;
            if ([objc_getAssociatedObject(sub, FQXOwnedGlassElementKey) boolValue]) continue;
            if (!sub.hidden) sub.hidden = YES;
        }
    }
    // Keep resting selection indicator subtle, unclipped, and matched to the dock appearance.
    if (lens) {
        if (lens.overrideUserInterfaceStyle != dockStyle) {
            lens.overrideUserInterfaceStyle = dockStyle;
        }
        if (lens.clipsToBounds) lens.clipsToBounds = NO;
        if (!lens.effect) {
            UIColor *airyFill = FQXDockSelectionColorForMode(mode, darkDock);
            if (![lens.contentView.backgroundColor isEqual:airyFill]) {
                lens.contentView.backgroundColor = airyFill;
            }
        }
    }
    FQXApplyDockBackdropBlur(proxy, proxy.contentView, nil, proxy.contentView.bounds, -1, darkDock, mode, DockBlurPrefKey);
}

static id FQXRawIvarObj(id target, const char *ivarName) {
    if (!target || !ivarName) return nil;
    Ivar ivar = class_getInstanceVariable(object_getClass(target), ivarName);
    if (!ivar) return nil;
    const char *enc = ivar_getTypeEncoding(ivar);
    return (enc && enc[0] == '@') ? object_getIvar(target, ivar) : nil;
}

static id FQXObjGet(id target, const char *name) {
    if (!target || !name) return nil;
    SEL sel = sel_registerName(name);
    if ([target respondsToSelector:sel]) {
        Method m = class_getInstanceMethod(object_getClass(target), sel);
        if (m && strcmp(method_getTypeEncoding(m), "@16@0:8") == 0) {
            return ((id (*)(id, SEL))objc_msgSend)(target, sel);
        }
    }
    char ivarName[96];
    snprintf(ivarName, sizeof(ivarName), "_%s", name);
    Ivar ivar = class_getInstanceVariable(object_getClass(target), ivarName);
    if (ivar) {
        const char *enc = ivar_getTypeEncoding(ivar);
        if (enc && enc[0] == '@') return object_getIvar(target, ivar);
    }
    return nil;
}

static BOOL FQXBoolGet(id target, const char *name, BOOL fallback) {
    if (!target || !name) return fallback;
    SEL sel = sel_registerName(name);
    if ([target respondsToSelector:sel]) {
        Method m = class_getInstanceMethod(object_getClass(target), sel);
        if (m && strcmp(method_getTypeEncoding(m), "B16@0:8") == 0) {
            return ((BOOL (*)(id, SEL))objc_msgSend)(target, sel);
        }
    }
    char ivarName[96];
    snprintf(ivarName, sizeof(ivarName), "_%s", name);
    Ivar ivar = class_getInstanceVariable(object_getClass(target), ivarName);
    if (ivar) {
        const char *enc = ivar_getTypeEncoding(ivar);
        if (enc && (enc[0] == 'B' || enc[0] == 'c')) {
            return *((const uint8_t *)(__bridge void *)target + ivar_getOffset(ivar)) != 0;
        }
    }
    return fallback;
}

static NSInteger FQXIntGet(id target, const char *name, NSInteger fallback) {
    if (!target || !name) return fallback;
    SEL sel = sel_registerName(name);
    if ([target respondsToSelector:sel]) {
        Method m = class_getInstanceMethod(object_getClass(target), sel);
        if (m) {
            const char *enc = method_getTypeEncoding(m);
            if (enc && (strcmp(enc, "q16@0:8") == 0 || strcmp(enc, "Q16@0:8") == 0)) {
                return ((NSInteger (*)(id, SEL))objc_msgSend)(target, sel);
            }
            if (enc && (strcmp(enc, "i16@0:8") == 0 || strcmp(enc, "I16@0:8") == 0)) {
                return (NSInteger)((int (*)(id, SEL))objc_msgSend)(target, sel);
            }
        }
    }
    return fallback;
}

#pragma mark - Official iOS 26/27 Native UITabBar Liquid Glass Dock (adapted from DYKiller)

static const void *FQXPlatterOriginalGlassKey = &FQXPlatterOriginalGlassKey;
static const void *FQXPlatterAppliedStyleKey = &FQXPlatterAppliedStyleKey;
static BOOL gFQXPlatterGlassProbed = NO;
static BOOL gFQXPlatterGlassSupported = NO;

static UIView *FQXFindViewOfClassRecursive(UIView *root, Class cls) {
    if (!root || !cls) return nil;
    for (UIView *sub in root.subviews) {
        if ([sub isKindOfClass:cls]) return sub;
        UIView *found = FQXFindViewOfClassRecursive(sub, cls);
        if (found) return found;
    }
    return nil;
}

static UIVisualEffectView *FQXFindDockBackgroundEffect(UITabBar *tabBar) {
    UIVisualEffectView *best = nil;
    // The iOS 27 compatibility layout uses a direct background effect next to
    // _UITabBarItemPlatterView, with no _UITabBarPlatterView at all. Inspect only
    // this bar's background siblings, never selection/portal descendants.
    for (UIView *child in tabBar.subviews) {
        if (![child isKindOfClass:UIVisualEffectView.class] ||
            [child isKindOfClass:FQXBackdropBlurView.class]) continue;
        UIVisualEffectView *effectView = (UIVisualEffectView *)child;
        BOOL background = effectView.effect != nil ||
            objc_getAssociatedObject(effectView, FQXPlatterOriginalGlassKey) != nil;
        if (!background || child.hidden || CGRectGetHeight(child.bounds) <= 10.0 ||
            CGRectGetWidth(child.bounds) <= 2.0 * CGRectGetHeight(child.bounds)) continue;
        if (!best || CGRectGetWidth(child.bounds) > CGRectGetWidth(best.bounds)) best = effectView;
    }
    return best;
}

static UIView *FQXFindDockPlatter(UITabBar *tabBar) {
    static Class platterCls = Nil;
    static dispatch_once_t once;
    dispatch_once(&once, ^{ platterCls = NSClassFromString(@"UIKit._UITabBarPlatterView"); });
    if (!tabBar) return nil;
    UIView *first = FQXFindViewOfClassRecursive(tabBar, platterCls);
    if (!first) return FQXFindDockBackgroundEffect(tabBar);
    UIView *best = nil;
    CGFloat bestW = 0.0;
    for (UIView *sib in first.superview.subviews) {
        if (![sib isKindOfClass:platterCls] || sib.hidden) continue;
        CGFloat w = CGRectGetWidth(sib.bounds);
        CGFloat h = CGRectGetHeight(sib.bounds);
        if (h > 10.0 && w > h + 1.0 && w > bestW) {
            best = sib;
            bestW = w;
        }
    }
    return best ?: first;
}

// Swap only the platter material. UIKit still drives selection and the interactive lens.
static BOOL FQXGlassEffectNeedsStyleReapply(id effectObj, FQXDockMaterialMode mode) {
    if (!effectObj) return (mode != FQXDockMaterialIOS18Gaussian);
    if ([effectObj isKindOfClass:UIBlurEffect.class]) return YES;
    if (mode == FQXDockMaterialNewGlass || mode == FQXDockMaterialLegacyGlass) {
        NSInteger curStyle = FQXIntGet(effectObj, "style", -1);
        if (curStyle == 0) return YES; // UIKit reverted Clear (1) back to milky Regular (0)
    }
    return NO;
}

static void FQXApplyDockPlatterGlass(UIView *platter, BOOL isDark, FQXDockMaterialMode mode) {
    if (!platter) return;
    NSNumber *applied = objc_getAssociatedObject(platter, FQXPlatterAppliedStyleKey);
    BOOL reduce = UIAccessibilityIsReduceTransparencyEnabled();
    if ([platter isKindOfClass:UIVisualEffectView.class]) {
        UIVisualEffectView *surface = (UIVisualEffectView *)platter;
        UIVisualEffect *current = surface.effect;
        id original = objc_getAssociatedObject(surface, FQXPlatterOriginalGlassKey);
        if (reduce) {
            if (original) surface.effect = original == NSNull.null ? nil : original;
            objc_setAssociatedObject(surface, FQXPlatterAppliedStyleKey, nil, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
            objc_setAssociatedObject(surface, FQXPlatterOriginalGlassKey, nil, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
            return;
        }
        BOOL wantsClear = (mode == FQXDockMaterialIOS18Gaussian);
        // UIKit may rebuild its background when appearance/items change.
        BOOL hostReset = wantsClear
            ? (current != nil)
            : FQXGlassEffectNeedsStyleReapply(current, mode);
        if (!original || (!wantsClear && hostReset && current)) {
            objc_setAssociatedObject(surface, FQXPlatterOriginalGlassKey, current ?: NSNull.null,
                                     OBJC_ASSOCIATION_RETAIN_NONATOMIC);
        }
        NSInteger desired = (FQXGlassDarkTintEnabled() ? 100 : 0) + (isDark ? 10 : 0) + (NSInteger)mode + 1;
        if (!applied || applied.integerValue != desired || hostReset) {
            surface.effect = wantsClear ? nil : FQXMakeDockEffectForMode(mode, isDark, YES, NO);
            surface.backgroundColor = UIColor.clearColor;
            surface.contentView.backgroundColor = UIColor.clearColor;
            FQXApplyCornerConfiguration(surface, 0.0, NO);
            objc_setAssociatedObject(surface, FQXPlatterAppliedStyleKey, @(desired), OBJC_ASSOCIATION_RETAIN_NONATOMIC);
            FQXDiagRecordEvent(FQXDiagCategoryUI, @"dock_glass_material", @{
                @"mode": @((NSInteger)mode),
                @"isDark": @(isDark),
                @"darkTint": @(FQXGlassDarkTintEnabled()),
                @"platterClass": NSStringFromClass(surface.class) ?: @"",
                @"hasTint": @((mode == FQXDockMaterialNewGlass && isDark && FQXGlassDarkTintEnabled()) ? YES : NO),
                @"interactive": @YES,
                @"hostReset": @(hostReset),
            }, NO);
        }
        return;
    }
    if (reduce) {
        if (!applied) return;
        id orig = objc_getAssociatedObject(platter, FQXPlatterOriginalGlassKey);
        @try {
            [platter setValue:(orig == NSNull.null ? nil : orig) forKey:@"glassEffect"];
        } @catch (__unused NSException *e) {}
        objc_setAssociatedObject(platter, FQXPlatterAppliedStyleKey, nil, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
        objc_setAssociatedObject(platter, FQXPlatterOriginalGlassKey, nil, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
        [platter setNeedsLayout];
        return;
    }
    if (gFQXPlatterGlassProbed && !gFQXPlatterGlassSupported) return;

    id current = nil;
    @try {
        current = [platter valueForKey:@"glassEffect"];
    } @catch (__unused NSException *e) {
        gFQXPlatterGlassProbed = YES;
        gFQXPlatterGlassSupported = NO;
        return;
    }
    gFQXPlatterGlassProbed = YES;
    gFQXPlatterGlassSupported = YES;

    NSInteger desiredStamp = (FQXGlassDarkTintEnabled() ? 100 : 0) + (isDark ? 10 : 0) + (NSInteger)mode + 1;
    BOOL hostReset = FQXGlassEffectNeedsStyleReapply(current, mode);
    if (applied && applied.integerValue == desiredStamp && !hostReset) return;

    if (!objc_getAssociatedObject(platter, FQXPlatterOriginalGlassKey)) {
        objc_setAssociatedObject(platter, FQXPlatterOriginalGlassKey, current ?: NSNull.null,
                                 OBJC_ASSOCIATION_RETAIN_NONATOMIC);
    }

    BOOL interactive = YES;
    SEL isInterSel = NSSelectorFromString(@"isInteractive");
    if (current && [current respondsToSelector:isInterSel]) {
        Method m = class_getInstanceMethod(object_getClass(current), isInterSel);
        if (m && method_getNumberOfArguments(m) == 2) {
            interactive = ((BOOL (*)(id, SEL))objc_msgSend)(current, isInterSel);
        }
    }
    UIVisualEffect *effect = FQXMakeDockEffectForMode(mode, isDark, interactive, NO);
    if (!effect) return;
    @try {
        [platter setValue:effect forKey:@"glassEffect"];
    } @catch (__unused NSException *e) {
        gFQXPlatterGlassSupported = NO;
        return;
    }
    objc_setAssociatedObject(platter, FQXPlatterAppliedStyleKey, @(desiredStamp), OBJC_ASSOCIATION_RETAIN_NONATOMIC);
    [platter setNeedsLayout];
    FQXDiagRecordEvent(FQXDiagCategoryUI, @"dock_glass_material", @{
        @"mode": @((NSInteger)mode),
        @"isDark": @(isDark),
        @"darkTint": @(FQXGlassDarkTintEnabled()),
        @"platterClass": NSStringFromClass(platter.class) ?: @"",
        @"hasTint": @((mode == FQXDockMaterialNewGlass && isDark && FQXGlassDarkTintEnabled()) ? YES : NO),
        @"interactive": @(interactive),
        @"hostReset": @(hostReset),
    }, NO);
}

static void FQXApplyNativeDockMaterial(UITabBar *tabBar, UIView *platter, BOOL dark) {
    if (!tabBar) return;
    if (tabBar.backgroundColor && ![tabBar.backgroundColor isEqual:UIColor.clearColor]) {
        tabBar.backgroundColor = UIColor.clearColor;
    }
    if (tabBar.barTintColor != nil) {
        tabBar.barTintColor = nil;
    }
    FQXDockMaterialMode mode = FQXCurrentDockMaterialMode();
    BOOL reduce = UIAccessibilityIsReduceTransparencyEnabled();
    static char originalAppearanceKey, selectionStyleKey;
    NSInteger desiredSelectionStamp = (mode == FQXDockMaterialNewGlass || reduce) ? 0 : (NSInteger)mode;
    NSNumber *appliedSelection = objc_getAssociatedObject(tabBar, &selectionStyleKey);
    if (!appliedSelection && desiredSelectionStamp == 0) {
        // Leave factory floating UITabBar standardAppearance untouched in NewGlass mode
        // so _UITabBarVisualProvider keeps its pure native Liquid Glass selection lens.
        objc_setAssociatedObject(tabBar, &selectionStyleKey, @0, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
    } else if (!appliedSelection || appliedSelection.integerValue != desiredSelectionStamp) {
        UITabBarAppearance *original = objc_getAssociatedObject(tabBar, &originalAppearanceKey);
        if (!original) {
            original = tabBar.standardAppearance;
            objc_setAssociatedObject(tabBar, &originalAppearanceKey, original, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
        }
        UITabBarAppearance *appearance = (desiredSelectionStamp == 0) ? original : [original copy];
        if (desiredSelectionStamp != 0) {
            appearance.selectionIndicatorTintColor = [UIColor colorWithDynamicProvider:^UIColor *(UITraitCollection *traits) {
                return FQXDockSelectionColorForMode(mode, traits.userInterfaceStyle == UIUserInterfaceStyleDark);
            }];
        }
        tabBar.standardAppearance = appearance;
        objc_setAssociatedObject(tabBar, &selectionStyleKey, @(desiredSelectionStamp), OBJC_ASSOCIATION_RETAIN_NONATOMIC);
        // Appearance can replace the native background view. Finish that layout
        // before choosing the surface that owns the material and blur animator.
        [tabBar layoutIfNeeded];
        platter = FQXFindDockPlatter(tabBar);
        if (platter) {
            objc_setAssociatedObject(platter, FQXPlatterAppliedStyleKey, nil, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
        }
    }
    if (platter && platter.backgroundColor && ![platter.backgroundColor isEqual:UIColor.clearColor]) {
        platter.backgroundColor = UIColor.clearColor;
    }
    FQXApplyDockPlatterGlass(platter, dark, mode);
    static Class platterCls = Nil;
    static dispatch_once_t pOnce;
    dispatch_once(&pOnce, ^{ platterCls = NSClassFromString(@"UIKit._UITabBarPlatterView"); });
    if (platterCls && platter && platter.superview) {
        for (UIView *sib in platter.superview.subviews) {
            if (sib != platter && [sib isKindOfClass:platterCls]) {
                if (sib.backgroundColor && ![sib.backgroundColor isEqual:UIColor.clearColor]) {
                    sib.backgroundColor = UIColor.clearColor;
                }
                FQXApplyDockPlatterGlass(sib, dark, mode);
            }
        }
    }
    if ([platter isKindOfClass:UIVisualEffectView.class]) {
        UIVisualEffectView *surface = (UIVisualEffectView *)platter;
        FQXApplyDockBackdropBlur(tabBar, surface.contentView, nil, surface.contentView.bounds, -1, dark, mode, DockBlurPrefKey);
    } else if (platter && platter.superview) {
        FQXApplyDockBackdropBlur(tabBar, platter.superview, platter, platter.frame, -1, dark, mode, DockBlurPrefKey);
    }
}

static NSString *FQXDockSymbolNameForTitle(NSString *title, BOOL selected) {
    if ([title isEqualToString:@"书城"] || [title isEqualToString:@"首页"]) return selected ? @"house.fill" : @"house";
    if ([title isEqualToString:@"短剧"] || [title isEqualToString:@"视频"]) return selected ? @"play.rectangle.fill" : @"play.rectangle";
    if ([title isEqualToString:@"书架"]) return selected ? @"books.vertical.fill" : @"books.vertical";
    if ([title isEqualToString:@"我的"]) return selected ? @"person.fill" : @"person";
    if ([title isEqualToString:@"商城"]) return selected ? @"bag.fill" : @"bag";
    if ([title isEqualToString:@"短句"]) return selected ? @"text.bubble.fill" : @"text.bubble";
    return nil;
}

static UIImage *FQXDockTitleImage(NSString *title, UIColor *color, BOOL selected) {
    if (!title.length) return nil;
    UIFontWeight weight = selected ? UIFontWeightSemibold : UIFontWeightMedium;
    UIFont *font = [UIFont systemFontOfSize:15.5 weight:weight];
    CGFloat maxW = 64.0;
    CGFloat w = [title sizeWithAttributes:@{NSFontAttributeName: font}].width;
    if (w > maxW) {
        font = [UIFont systemFontOfSize:MAX(11.0, floor(15.5 * maxW / w)) weight:weight];
    }
    NSDictionary *attrs = @{NSFontAttributeName: font, NSForegroundColorAttributeName: color};
    CGSize sz = [title sizeWithAttributes:attrs];
    sz.width = MAX(1.0, ceil(sz.width));
    sz.height = MAX(1.0, ceil(sz.height));
    UIGraphicsImageRendererFormat *fmt = UIGraphicsImageRendererFormat.preferredFormat;
    fmt.opaque = NO;
    UIImage *img = [[[UIGraphicsImageRenderer alloc] initWithSize:sz format:fmt]
        imageWithActions:^(__unused UIGraphicsImageRendererContext *ctx) {
            [title drawAtPoint:CGPointZero withAttributes:attrs];
        }];
    return [img imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
}

static UIImage *FQXDockIconCaptionImage(UIImage *icon, NSString *title, UIColor *color, BOOL selected) {
    if (!icon) return FQXDockTitleImage(title, color, selected);
    if (!title.length) return [icon imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
    NSMutableParagraphStyle *para = [[NSMutableParagraphStyle alloc] init];
    para.alignment = NSTextAlignmentCenter;
    para.lineBreakMode = NSLineBreakByTruncatingTail;
    NSDictionary *attrs = @{
        NSFontAttributeName: [UIFont systemFontOfSize:10.5 weight:(selected ? UIFontWeightSemibold : UIFontWeightMedium)],
        NSForegroundColorAttributeName: color,
        NSParagraphStyleAttributeName: para,
    };
    CGSize textSz = [title sizeWithAttributes:attrs];
    CGFloat iconW = icon.size.width > 1.0 ? MIN(25.0, icon.size.width) : 21.0;
    CGFloat iconH = icon.size.height > 1.0 ? MIN(23.0, icon.size.height) : 21.0;
    CGFloat gap = 2.0;
    CGFloat width = ceil(MAX(iconW, MIN(textSz.width, 64.0)));
    CGFloat textH = ceil(textSz.height);
    CGSize total = CGSizeMake(MAX(1.0, width), MAX(1.0, iconH + gap + textH));
    UIGraphicsImageRendererFormat *fmt = UIGraphicsImageRendererFormat.preferredFormat;
    fmt.opaque = NO;
    UIImage *img = [[[UIGraphicsImageRenderer alloc] initWithSize:total format:fmt]
        imageWithActions:^(__unused UIGraphicsImageRendererContext *ctx) {
            [icon drawInRect:CGRectMake((total.width - iconW) * 0.5, 0.0, iconW, iconH)];
            [title drawWithRect:CGRectMake(0.0, iconH + gap, total.width, textH)
                        options:NSStringDrawingUsesLineFragmentOrigin
                     attributes:attrs
                        context:nil];
        }];
    return [img imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
}

static UIImage *FQXDockItemImage(NSString *title,
                                 UIButton *sourceButton,
                                 NSInteger displayMode,
                                 CGFloat iconPointSize,
                                 BOOL selected,
                                 UIColor *color) {
    // displayMode: 0 = icon + text, 1 = icons only, 2 = text only
    if (displayMode == 2) {
        return FQXDockTitleImage(title, color, selected);
    }
    BOOL iconsOnly = (displayMode == 1);
    CGFloat symPt = iconsOnly ? MAX(16.0, MIN(26.0, iconPointSize * 0.72)) : 19.0;
    NSString *symName = FQXDockSymbolNameForTitle(title, selected);
    UIImage *icon = nil;
    if (symName) {
        UIImageSymbolConfiguration *cfg = [UIImageSymbolConfiguration configurationWithPointSize:symPt
                                                                                          weight:UIImageSymbolWeightRegular
                                                                                           scale:UIImageSymbolScaleMedium];
        icon = [UIImage systemImageNamed:symName withConfiguration:cfg];
        if (icon) {
            icon = [icon imageWithTintColor:color renderingMode:UIImageRenderingModeAlwaysOriginal];
        }
    }
    if (!icon && sourceButton) {
        UIImage *src = selected
            ? ([sourceButton imageForState:UIControlStateSelected] ?: [sourceButton imageForState:UIControlStateNormal])
            : [sourceButton imageForState:UIControlStateNormal];
        if (!src) src = sourceButton.currentImage;
        if (src) {
            icon = [[src imageWithRenderingMode:UIImageRenderingModeAlwaysTemplate]
                imageWithTintColor:color renderingMode:UIImageRenderingModeAlwaysOriginal];
        }
    }
    if (iconsOnly) {
        return icon ?: FQXDockTitleImage(title, color, selected);
    }
    return FQXDockIconCaptionImage(icon, title, color, selected);
}

static NSString *FQXDockButtonTitle(UIButton *button, UIView *bar, NSUInteger index) {
    if (bar && [bar respondsToSelector:@selector(items)]) {
        NSArray *barItems = ((id (*)(id, SEL))objc_msgSend)(bar, @selector(items));
        if ([barItems isKindOfClass:NSArray.class] && index < barItems.count) {
            id item = barItems[index];
            if ([item respondsToSelector:@selector(title)]) {
                NSString *t = ((id (*)(id, SEL))objc_msgSend)(item, @selector(title));
                if ([t isKindOfClass:NSString.class] && t.length > 0) return t;
            }
        }
    }
    if (button.accessibilityLabel.length > 0) return button.accessibilityLabel;
    NSString *cur = [button titleForState:UIControlStateNormal];
    if (cur.length > 0) return cur;
    if (button.titleLabel.text.length > 0) return button.titleLabel.text;
    return @"";
}

static const void *FQXZeroMaskLayerKey = &FQXZeroMaskLayerKey;
static const void *FQXProxySuppressDiagLoggedKey = &FQXProxySuppressDiagLoggedKey;
static const void *FQXDockVisibleLayersSigKey = &FQXDockVisibleLayersSigKey;
static const void *FQXDockDetachedLayoutSigKey = &FQXDockDetachedLayoutSigKey;

static NSArray<NSNumber *> *FQXDockRectArray(CGRect r) {
    return @[
        @(round(r.origin.x * 10.0) / 10.0),
        @(round(r.origin.y * 10.0) / 10.0),
        @(round(r.size.width * 10.0) / 10.0),
        @(round(r.size.height * 10.0) / 10.0),
    ];
}

// Visually hide a view without modifying hidden/alpha/layer.opacity, so Lvisible_to() in
// native_surface.s still sees alpha == 1.0 and NEVER enters a reset/layout death spiral.
static void FQXSetZeroMaskHidden(UIView *view, BOOL hidden) {
    if (!view) return;
    CALayer *ownedMask = objc_getAssociatedObject(view, FQXZeroMaskLayerKey);
    if (hidden) {
        if (!ownedMask) {
            ownedMask = [CALayer layer];
            ownedMask.frame = CGRectZero;
            objc_setAssociatedObject(view, FQXZeroMaskLayerKey, ownedMask, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
        }
        if (view.layer.mask != ownedMask) {
            view.layer.mask = ownedMask;
        }
        if (view.layer.opacity != 1.0f) {
            view.layer.opacity = 1.0f;
        }
    } else if (ownedMask) {
        if (view.layer.mask == ownedMask) {
            view.layer.mask = nil;
        }
        objc_setAssociatedObject(view, FQXZeroMaskLayerKey, nil, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
    }
}

// Keep proxy completely effect-free and non-interactive while nativeDockBar owns the expanded Dock.
// Proxy stays hidden == NO, alpha == 1.0, bounds intact, contentView.hidden untouched so
// repair162's Lvisible_to() and compact-Dock detection continue functioning without reset loops.
static void FQXEnforceNativeProxyNeutralized(UIVisualEffectView *proxy) {
    if (![proxy isKindOfClass:UIVisualEffectView.class]) return;
    if (FQXGetDockMaterialOwner(proxy) != FQXDockMaterialOwnerNative || !FQXGlassEnabled()) return;
    if (proxy.effect != nil) {
        FQXWriteProxyEffectDirectly(proxy, nil);
    }
    FQXClearDockBackdropBlur(proxy);
    if (proxy.backgroundColor && ![proxy.backgroundColor isEqual:UIColor.clearColor]) {
        proxy.backgroundColor = UIColor.clearColor;
    }
    if (proxy.contentView.backgroundColor && ![proxy.contentView.backgroundColor isEqual:UIColor.clearColor]) {
        proxy.contentView.backgroundColor = UIColor.clearColor;
    }
    if (proxy.userInteractionEnabled) {
        proxy.userInteractionEnabled = NO;
    }
    FQXSetZeroMaskHidden(proxy, NO);
    if (proxy.contentView) {
        FQXSetZeroMaskHidden(proxy.contentView, YES);
    }
}

static void FQXSetDockMaterialOwner(UIView *bar,
                                    UIVisualEffectView *proxy,
                                    FQXDockMaterialOwner owner,
                                    BOOL detachedActive) {
    (void)bar;
    if (![proxy isKindOfClass:UIVisualEffectView.class]) return;
    FQXDockMaterialOwner prevOwner = FQXGetDockMaterialOwner(proxy);
    NSString *effectBefore = proxy.effect ? (NSStringFromClass(proxy.effect.class) ?: @"UIVisualEffect") : @"nil";
    objc_setAssociatedObject(proxy, FQXDockMaterialOwnerKey, @(owner), OBJC_ASSOCIATION_RETAIN_NONATOMIC);

    if (owner == FQXDockMaterialOwnerNative) {
        FQXEnforceNativeProxyNeutralized(proxy);
        BOOL shouldLogSuppress = (prevOwner != FQXDockMaterialOwnerNative) ||
            !objc_getAssociatedObject(proxy, FQXProxySuppressDiagLoggedKey);
        if (shouldLogSuppress) {
            objc_setAssociatedObject(proxy, FQXProxySuppressDiagLoggedKey, @YES, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
            FQXDiagRecordEvent(FQXDiagCategoryUI, @"dock_proxy_suppressed", @{
                @"reason": @"native_tabbar_owns_expanded_dock",
                @"clearedEffectClass": effectBefore,
                @"proxyEffectAfter": proxy.effect ? (NSStringFromClass(proxy.effect.class) ?: @"") : @"nil",
                @"proxyUserInteractionEnabled": @(proxy.userInteractionEnabled),
                @"detachedActive": @(detachedActive),
                @"blockedExternalWrites": @(gFQXProxyBlockedWriteCount),
                @"proxyFrame": FQXDockRectArray(proxy.frame),
            }, NO);
        }
    } else if (owner == FQXDockMaterialOwnerProxy) {
        if (!proxy.userInteractionEnabled) {
            proxy.userInteractionEnabled = YES;
        }
        FQXSetZeroMaskHidden(proxy, NO);
        if (proxy.contentView) {
            FQXSetZeroMaskHidden(proxy.contentView, NO);
        }
        objc_setAssociatedObject(proxy, FQXProxySuppressDiagLoggedKey, nil, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
        if (prevOwner != FQXDockMaterialOwnerProxy) {
            objc_setAssociatedObject(proxy, FQXUnifiedClearDockKey, nil, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
            [proxy setNeedsLayout];
        }
    } else {
        if (!proxy.userInteractionEnabled) proxy.userInteractionEnabled = YES;
        FQXSetZeroMaskHidden(proxy, NO);
        if (proxy.contentView) FQXSetZeroMaskHidden(proxy.contentView, NO);
        objc_setAssociatedObject(proxy, FQXProxySuppressDiagLoggedKey, nil, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
    }

    if (prevOwner != owner) {
        FQXDiagRecordEvent(FQXDiagCategoryUI, @"dock_material_owner", @{
            @"prevOwner": FQXDockMaterialOwnerName(prevOwner),
            @"owner": FQXDockMaterialOwnerName(owner),
            @"detachedActive": @(detachedActive),
            @"proxyEffectBefore": effectBefore,
            @"proxyEffectAfter": proxy.effect ? (NSStringFromClass(proxy.effect.class) ?: @"") : @"nil",
            @"proxyUserInteractionEnabled": @(proxy.userInteractionEnabled),
            @"dockMode": @((NSInteger)FQXCurrentDockMaterialMode()),
        }, NO);
    }
}

static void FQXAuditVisibleDockGlassLayers(UIView *bar,
                                           UIVisualEffectView *proxy,
                                           UITabBar *tabBar,
                                           FQXDetachedDockButtonView *detached) {
    if (!bar) return;
    NSMutableArray<NSDictionary *> *layers = [NSMutableArray array];
    NSMutableString *sig = [NSMutableString string];
    BOOL proxyHasEffect = NO;
    NSUInteger nativePlatterCount = 0;
    NSUInteger detachedGlassCount = 0;

    if ([proxy isKindOfClass:UIVisualEffectView.class]) {
        BOOL hasEff = (proxy.effect != nil && !proxy.hidden && proxy.alpha > 0.01);
        proxyHasEffect = hasEff;
        NSString *effCls = proxy.effect ? (NSStringFromClass(proxy.effect.class) ?: @"") : @"nil";
        [sig appendFormat:@"p:%d:%@:%d|", hasEff ? 1 : 0, effCls, (int)FQXGetDockMaterialOwner(proxy)];
        if (hasEff) {
            [layers addObject:@{
                @"role": @"proxy",
                @"class": NSStringFromClass(proxy.class) ?: @"UIVisualEffectView",
                @"effectClass": effCls,
                @"owner": FQXDockMaterialOwnerName(FQXGetDockMaterialOwner(proxy)),
                @"frame": FQXDockRectArray(proxy.frame),
            }];
        }
    }

    if (tabBar && !tabBar.hidden && tabBar.alpha > 0.01) {
        UIView *platter = FQXFindDockPlatter(tabBar);
        if (platter && !platter.hidden && platter.alpha > 0.01) {
            NSString *effCls = @"none";
            if ([platter isKindOfClass:UIVisualEffectView.class]) {
                UIVisualEffect *eff = ((UIVisualEffectView *)platter).effect;
                effCls = eff ? (NSStringFromClass(eff.class) ?: @"UIVisualEffect") : @"nil";
            } else {
                @try {
                    id ge = [platter valueForKey:@"glassEffect"];
                    effCls = ge ? (NSStringFromClass([ge class]) ?: @"UIGlassEffect") : @"nil";
                } @catch (__unused NSException *e) {
                    effCls = @"platter";
                }
            }
            if (![effCls isEqualToString:@"nil"]) {
                nativePlatterCount++;
                CGRect pfInBar = [platter convertRect:platter.bounds toView:bar];
                [layers addObject:@{
                    @"role": @"native_tabbar_platter",
                    @"class": NSStringFromClass(platter.class) ?: @"UIView",
                    @"effectClass": effCls,
                    @"frame": FQXDockRectArray(pfInBar),
                }];
            }
            [sig appendFormat:@"n:%@:%.0fx%.0f|", effCls, CGRectGetWidth(platter.bounds), CGRectGetHeight(platter.bounds)];
        }
    }

    if (detached && !detached.hidden && detached.alpha > 0.01 && detached.superview == bar) {
        UIVisualEffectView *dg = detached.glassView;
        NSString *effCls = dg.effect ? (NSStringFromClass(dg.effect.class) ?: @"UIVisualEffect") : @"nil";
        if (dg && dg.effect != nil && !dg.hidden && dg.alpha > 0.01) {
            detachedGlassCount++;
            [layers addObject:@{
                @"role": @"detached_circle",
                @"class": NSStringFromClass(dg.class) ?: @"UIVisualEffectView",
                @"effectClass": effCls,
                @"frame": FQXDockRectArray(detached.frame),
            }];
        }
        [sig appendFormat:@"d:%@:%.0f|", effCls, CGRectGetMinX(detached.frame)];
    }

    // Check any unexpected sibling UIVisualEffectView directly inside bar with a live effect.
    NSUInteger extraGlass = 0;
    for (UIView *sub in bar.subviews) {
        if (sub == proxy || sub == tabBar || sub == detached || sub.hidden || sub.alpha <= 0.01) continue;
        if (![sub isKindOfClass:UIVisualEffectView.class]) continue;
        UIVisualEffectView *ve = (UIVisualEffectView *)sub;
        if (ve.effect != nil) {
            extraGlass++;
            [layers addObject:@{
                @"role": @"extra_bar_effect",
                @"class": NSStringFromClass(ve.class) ?: @"UIVisualEffectView",
                @"effectClass": NSStringFromClass(ve.effect.class) ?: @"",
                @"frame": FQXDockRectArray(ve.frame),
            }];
        }
    }
    [sig appendFormat:@"x:%lu", (unsigned long)extraGlass];

    NSString *prevSig = objc_getAssociatedObject(bar, FQXDockVisibleLayersSigKey);
    if (prevSig && [prevSig isEqualToString:sig]) return;
    objc_setAssociatedObject(bar, FQXDockVisibleLayersSigKey, [sig copy], OBJC_ASSOCIATION_COPY_NONATOMIC);
    FQXDiagRecordEvent(FQXDiagCategoryUI, @"dock_visible_glass_layers", @{
        @"visibleGlassCount": @(layers.count),
        @"proxyHasEffect": @(proxyHasEffect),
        @"nativePlatterCount": @(nativePlatterCount),
        @"detachedGlassCount": @(detachedGlassCount),
        @"extraBarEffectCount": @(extraGlass),
        @"owner": FQXDockMaterialOwnerName(FQXGetDockMaterialOwner(proxy)),
        @"layers": layers,
    }, NO);
}

static void (*OrigVisualEffectLayoutForProxyGuard)(id, SEL);
static void HookVisualEffectLayoutForProxyGuard(UIVisualEffectView *view, SEL cmd) {
    if (OrigVisualEffectLayoutForProxyGuard) OrigVisualEffectLayoutForProxyGuard(view, cmd);
    if (FQXGetDockMaterialOwner(view) == FQXDockMaterialOwnerNative) {
        FQXEnforceNativeProxyNeutralized(view);
    }
}

static void (*OrigVisualEffectWindowForProxyGuard)(id, SEL);
static void HookVisualEffectWindowForProxyGuard(UIVisualEffectView *view, SEL cmd) {
    if (OrigVisualEffectWindowForProxyGuard) OrigVisualEffectWindowForProxyGuard(view, cmd);
    if (FQXGetDockMaterialOwner(view) == FQXDockMaterialOwnerNative) {
        FQXEnforceNativeProxyNeutralized(view);
    }
}

@interface FQXTabBarInteraction : NSObject <UITabBarDelegate>
@property(nonatomic, weak) UIView *bar;
@property(nonatomic, weak) UIVisualEffectView *proxy;
@property(nonatomic, weak) UIView *overlay;
@property(nonatomic, weak) UIView *nativeControl;
@property(nonatomic, weak) UIVisualEffectView *restingLens;
@property(nonatomic, copy) NSArray<UIButton *> *buttons;
@property(nonatomic, strong) NSHashTable<UIControl *> *wiredControls;
@property(nonatomic, strong) UITabBar *nativeDockBar;
@property(nonatomic, strong) FQXDetachedDockButtonView *detachedButton;
@property(nonatomic, copy) NSArray<NSNumber *> *capsuleHostIndices;
@property(nonatomic) NSInteger detachedHostIndex;
@property(nonatomic) BOOL dockLastDetachedActive;
@property(nonatomic, copy) NSString *dockSignature;
@property(nonatomic, copy) NSArray<NSString *> *dockTitles;
@property(nonatomic) UIUserInterfaceStyle dockAppliedStyle;
@property(nonatomic) NSInteger dockAppliedInkState;
@property(nonatomic) BOOL dockPlatterMeasured;
@property(nonatomic) CGFloat dockPlatterHeight;
@property(nonatomic) CGFloat dockPlatterInset;
@property(nonatomic) CGFloat dockPlatterMidOffsetX;
@property(nonatomic) CGFloat dockPlatterMidOffsetY;
@property(nonatomic) CGFloat dockLastBarWidth;
@property(nonatomic) CGRect dockLastProxyFrame;
@property(nonatomic) NSUInteger dockLastItemCount;
@property(nonatomic) BOOL nativeDockActive;
- (void)syncWithBar:(UIView *)bar
              proxy:(UIVisualEffectView *)proxy
            buttons:(NSArray<UIButton *> *)buttons
             native:(UIView *)native
               lens:(UIVisualEffectView *)lens;
- (void)updateLens:(UIVisualEffectView *)lens native:(UIView *)native;
- (void)ensureDockZOrderInBar:(UIView *)bar;
- (void)triggerHostNavigationForHostIndex:(NSUInteger)hostIdx
                           fallbackButton:(UIButton *)fallbackBtn
                                   source:(NSString *)source;
- (BOOL)syncDockItems;
- (void)applyDockItemImages;
- (void)syncDetachedDockMaterial:(BOOL)glassDark;
- (void)syncSelectionExclusivityAnimated:(BOOL)animated;
- (void)layoutNativeDockInBar:(UIView *)bar proxy:(UIVisualEffectView *)proxy forceMeasure:(BOOL)forceMeasure;
- (void)setNativeDockVisible:(BOOL)visible restoreProxy:(BOOL)restoreProxy;
- (void)teardown;
@end

static NSHashTable<FQXTabBarInteraction *> *FQXTrackedDockInteractions(void);

static FQXTabBarInteraction *FQXActiveDockInteractionForBar(UIView *bar) {
    if (!bar) return nil;
    for (FQXTabBarInteraction *inter in FQXTrackedDockInteractions().allObjects) {
        if (inter.bar == bar && inter.nativeDockActive) {
            return inter;
        }
    }
    return nil;
}

static BOOL (*OrigSSTabBarPointInside)(id, SEL, CGPoint, id);
static BOOL HookSSTabBarPointInside(UIView *bar, SEL cmd, CGPoint point, UIEvent *event) {
    FQXTabBarInteraction *inter = FQXActiveDockInteractionForBar(bar);
    if (inter && inter.detachedHostIndex != NSNotFound) {
        FQXDetachedDockButtonView *det = inter.detachedButton;
        if (det && det.superview == bar && !det.hidden && det.alpha > 0.01 && det.userInteractionEnabled) {
            CGPoint ptInDet = [det convertPoint:point fromView:bar];
            if ([det pointInside:ptInDet withEvent:event]) {
                return YES;
            }
        }
    }
    return OrigSSTabBarPointInside ? OrigSSTabBarPointInside(bar, cmd, point, event) : NO;
}

static UIView *(*OrigSSTabBarHitTest)(id, SEL, CGPoint, id);
static UIView *HookSSTabBarHitTest(UIView *bar, SEL cmd, CGPoint point, UIEvent *event) {
    FQXTabBarInteraction *inter = FQXActiveDockInteractionForBar(bar);
    if (inter && inter.detachedHostIndex != NSNotFound) {
        FQXDetachedDockButtonView *det = inter.detachedButton;
        if (det && det.superview == bar && !det.hidden && det.alpha > 0.01 && det.userInteractionEnabled) {
            CGPoint ptInDet = [det convertPoint:point fromView:bar];
            if ([det pointInside:ptInDet withEvent:event]) {
                UIView *resolved = [det hitTest:ptInDet withEvent:event] ?: (det.hitButton ?: det);
                static CFTimeInterval lastHitDiagTs = 0;
                CFTimeInterval now = CACurrentMediaTime();
                if (now - lastHitDiagTs >= 0.15) {
                    lastHitDiagTs = now;
                    FQXDiagRecordEvent(FQXDiagCategoryUI, @"dock_detached_hit_test", @{
                        @"moduleTitle": det.moduleTitle ?: @"",
                        @"hostIndex": @(inter.detachedHostIndex),
                        @"pointInBar": @[@(round(point.x * 10.0) / 10.0), @(round(point.y * 10.0) / 10.0)],
                        @"pointInDetached": @[@(round(ptInDet.x * 10.0) / 10.0), @(round(ptInDet.y * 10.0) / 10.0)],
                        @"detachedFrame": FQXDockRectArray(det.frame),
                        @"barBounds": FQXDockRectArray(bar.bounds),
                        @"resolvedClass": NSStringFromClass(resolved.class) ?: @"",
                    }, NO);
                }
                return resolved;
            }
        }
    }
    return OrigSSTabBarHitTest ? OrigSSTabBarHitTest(bar, cmd, point, event) : nil;
}

static void FQXSetNativeTabSelectionLensVisible(UIView *root, BOOL visible, NSInteger depth) {
    if (!root || depth > 5) return;
    NSString *clsName = NSStringFromClass(root.class);
    if ([clsName containsString:@"TabSelectionView"] || [clsName containsString:@"SelectionPlatter"]) {
        CGFloat desired = visible ? 1.0 : 0.0;
        if (fabs(root.alpha - desired) > 0.01) {
            root.alpha = desired;
        }
        return;
    }
    for (UIView *sub in root.subviews) {
        FQXSetNativeTabSelectionLensVisible(sub, visible, depth + 1);
    }
}

@implementation FQXTabBarInteraction

- (instancetype)init {
    self = [super init];
    if (self) {
        _wiredControls = [NSHashTable weakObjectsHashTable];
        _detachedHostIndex = NSNotFound;
        _dockAppliedStyle = UIUserInterfaceStyleUnspecified;
        _dockAppliedInkState = -1;
        _dockPlatterHeight = 62.0;
        _dockPlatterInset = 21.0;
    }
    return self;
}

- (BOOL)usesNativeSegmentedSelector {
    return [self.nativeControl isKindOfClass:UISegmentedControl.class] &&
           self.nativeControl.superview != nil &&
           !self.nativeControl.hidden;
}

- (BOOL)isDarkDock {
    UIUserInterfaceStyle dockStyle = self.proxy ? self.proxy.overrideUserInterfaceStyle : UIUserInterfaceStyleUnspecified;
    if (dockStyle == UIUserInterfaceStyleDark) return YES;
    if (dockStyle == UIUserInterfaceStyleLight) return NO;
    return self.proxy.traitCollection.userInterfaceStyle == UIUserInterfaceStyleDark;
}

- (UIUserInterfaceStyle)desiredDockGlassStyle {
    // Match the page's optical backdrop polarity (Dark on full-screen video/night, Light on
    // bright pages). On iOS 26/27, forcing Light override on a dark video page makes
    // UIGlassEffectStyleClear render Light-mode's milky-white luminosity veil, whereas Dark
    // override with tintColor == nil renders pure colorless refractive glass with zero tint.
    return [self isDarkDock] ? UIUserInterfaceStyleDark : UIUserInterfaceStyleLight;
}

- (NSUInteger)currentSelectedIndex {
    if ([self usesNativeSegmentedSelector]) {
        NSInteger idx = ((UISegmentedControl *)self.nativeControl).selectedSegmentIndex;
        if (idx >= 0 && (NSUInteger)idx < self.buttons.count) return (NSUInteger)idx;
    }
    if (self.bar) {
        SEL selItemSel = @selector(selectedItem);
        SEL itemsSel = @selector(items);
        if ([self.bar respondsToSelector:selItemSel] && [self.bar respondsToSelector:itemsSel]) {
            id selItem = ((id (*)(id, SEL))objc_msgSend)(self.bar, selItemSel);
            NSArray *barItems = ((id (*)(id, SEL))objc_msgSend)(self.bar, itemsSel);
            if (selItem && [barItems isKindOfClass:NSArray.class]) {
                NSUInteger idx = [barItems indexOfObjectIdenticalTo:selItem];
                if (idx != NSNotFound && idx < self.buttons.count) return idx;
            }
        }
        id barDelegate = FQXObjGet(self.bar, "delegate");
        if (barDelegate) {
            NSInteger delIdx = FQXIntGet(barDelegate, "selectedIndex", -1);
            if (delIdx >= 0 && (NSUInteger)delIdx < self.buttons.count) return (NSUInteger)delIdx;
        }
    }
    for (NSUInteger i = 0; i < self.buttons.count; ++i) {
        UIButton *btn = self.buttons[i];
        if ([btn isKindOfClass:UIButton.class] && btn.isSelected) return i;
    }
    if (self.restingLens && self.restingLens.superview && self.buttons.count) {
        CGFloat midX = CGRectGetMidX(self.restingLens.frame);
        NSUInteger bestIdx = 0;
        CGFloat bestDist = CGFLOAT_MAX;
        for (NSUInteger i = 0; i < self.buttons.count; ++i) {
            UIButton *btn = self.buttons[i];
            if (![btn isKindOfClass:UIButton.class] || !btn.superview) continue;
            CGRect bf = [btn.superview convertRect:btn.frame toView:self.restingLens.superview];
            CGFloat dist = fabs(CGRectGetMidX(bf) - midX);
            if (dist < bestDist) {
                bestDist = dist;
                bestIdx = i;
            }
        }
        return bestIdx;
    }
    return 0;
}

- (void)ensureDockZOrderInBar:(UIView *)bar {
    if (!bar) return;
    UITabBar *tabBar = self.nativeDockBar;
    FQXDetachedDockButtonView *det = self.detachedButton;
    BOOL showDetached = (self.detachedHostIndex != NSNotFound && det != nil && !det.hidden);

    if (tabBar && tabBar.superview == bar) {
        UIView *anchor = nil;
        NSUInteger proxyIdx = (self.proxy && self.proxy.superview == bar)
            ? [bar.subviews indexOfObjectIdenticalTo:self.proxy] : NSNotFound;
        NSUInteger overlayIdx = (self.overlay && self.overlay.superview == bar)
            ? [bar.subviews indexOfObjectIdenticalTo:self.overlay] : NSNotFound;
        if (proxyIdx != NSNotFound && overlayIdx != NSNotFound) {
            anchor = (overlayIdx > proxyIdx) ? self.overlay : self.proxy;
        } else if (overlayIdx != NSNotFound) {
            anchor = self.overlay;
        } else if (proxyIdx != NSNotFound) {
            anchor = self.proxy;
        }
        if (anchor) {
            NSUInteger tabIdx = [bar.subviews indexOfObjectIdenticalTo:tabBar];
            NSUInteger anchorIdx = [bar.subviews indexOfObjectIdenticalTo:anchor];
            if (tabIdx != NSNotFound && anchorIdx != NSNotFound && tabIdx < anchorIdx) {
                [bar insertSubview:tabBar aboveSubview:anchor];
            }
        }
    }

    if (showDetached) {
        if (det.superview != bar) {
            if (tabBar && tabBar.superview == bar) {
                [bar insertSubview:det aboveSubview:tabBar];
            } else {
                [bar addSubview:det];
            }
        } else if (bar.subviews.lastObject != det) {
            [bar bringSubviewToFront:det];
        }
    }
}

- (void)triggerHostNavigationForHostIndex:(NSUInteger)hostIdx
                           fallbackButton:(UIButton *)fallbackBtn
                                   source:(NSString *)source {
    NSUInteger beforeSel = [self currentSelectedIndex];
    UIButton *hostBtn = (hostIdx < self.buttons.count && [self.buttons[hostIdx] isKindOfClass:UIButton.class])
        ? self.buttons[hostIdx]
        : ([fallbackBtn isKindOfClass:UIButton.class] ? fallbackBtn : nil);
    NSString *methodUsed = @"none";
    BOOL triggered = NO;

    if (hostBtn && [hostBtn allTargets].count > 0) {
        [hostBtn sendActionsForControlEvents:UIControlEventTouchUpInside];
        methodUsed = @"host_button_touch_up_inside";
        triggered = YES;
    }

    NSUInteger afterBtnSel = [self currentSelectedIndex];
    // Fallback 1: invoke SSTabBar's real host delegate tabBar:didSelectItem: using the host item.
    if ((!triggered || afterBtnSel != hostIdx) && self.bar) {
        id barDelegate = FQXObjGet(self.bar, "delegate");
        NSArray *barItems = FQXObjGet(self.bar, "items");
        SEL didSel = @selector(tabBar:didSelectItem:);
        if (barDelegate && [barDelegate respondsToSelector:didSel] &&
            [barItems isKindOfClass:NSArray.class] && hostIdx < barItems.count) {
            Method m = class_getInstanceMethod(object_getClass(barDelegate), didSel);
            if (m && strcmp(method_getTypeEncoding(m), "v32@0:8@16@24") == 0) {
                id item = barItems[hostIdx];
                if ([self.bar respondsToSelector:@selector(setSelectedItem:)]) {
                    Method sm = class_getInstanceMethod(object_getClass(self.bar), @selector(setSelectedItem:));
                    if (sm && strcmp(method_getTypeEncoding(sm), "v24@0:8@16") == 0) {
                        ((void (*)(id, SEL, id))objc_msgSend)(self.bar, @selector(setSelectedItem:), item);
                    }
                }
                ((void (*)(id, SEL, id, id))objc_msgSend)(barDelegate, didSel, self.bar, item);
                methodUsed = triggered ? @"host_button_plus_bar_delegate" : @"bar_delegate_did_select_item";
                triggered = YES;
            }
        }
    }

    // Fallback 2: directly set selectedIndex on SSTabBarController / UITabBarController.
    NSUInteger afterDelegateSel = [self currentSelectedIndex];
    if ((!triggered || afterDelegateSel != hostIdx) && self.bar) {
        id owner = FQXObjGet(self.bar, "delegate");
        UITabBarController *tbc = [owner isKindOfClass:UITabBarController.class] ? (UITabBarController *)owner : nil;
        if (!tbc) {
            UIResponder *resp = self.bar.nextResponder;
            NSInteger hops = 0;
            while (resp && hops < 12) {
                if ([resp isKindOfClass:UITabBarController.class]) {
                    tbc = (UITabBarController *)resp;
                    break;
                }
                resp = resp.nextResponder;
                hops++;
            }
        }
        if (tbc && hostIdx < tbc.viewControllers.count) {
            tbc.selectedIndex = hostIdx;
            methodUsed = triggered ? @"fallback_tabbar_controller" : @"tabbar_controller_selected_index";
            triggered = YES;
        }
    }

    NSUInteger finalSel = [self currentSelectedIndex];
    [self syncSelectionExclusivityAnimated:YES];
    [self ensureDockZOrderInBar:self.bar];
    FQXScheduleCYLGlassResample(self.bar, self.proxy);

    FQXDiagRecordEvent(FQXDiagCategoryUI, @"dock_detached_navigation", @{
        @"source": source ?: @"detached_tap",
        @"targetHostIndex": @(hostIdx),
        @"moduleTitle": self.detachedButton.moduleTitle ?: @"",
        @"beforeIndex": @(beforeSel),
        @"afterIndex": @(finalSel),
        @"hadHostButton": @(hostBtn != nil),
        @"methodUsed": methodUsed,
        @"triggered": @(triggered),
    }, NO);

    __weak FQXTabBarInteraction *weakSelf = self;
    dispatch_async(dispatch_get_main_queue(), ^{
        FQXTabBarInteraction *laterSelf = weakSelf;
        if (laterSelf && laterSelf.nativeDockActive) {
            [laterSelf syncSelectionExclusivityAnimated:YES];
            [laterSelf ensureDockZOrderInBar:laterSelf.bar];
        }
    });
}

- (NSInteger)dockDisplayMode {
    NSUserDefaults *ud = NSUserDefaults.standardUserDefaults;
    id stored = [ud objectForKey:BottomDisplayModePrefKey];
    if (stored && [stored respondsToSelector:@selector(integerValue)]) {
        NSInteger v = [stored integerValue];
        if (v >= 0 && v <= 2) return v;
    }
    return [ud boolForKey:@"FanqieX.BottomIconsOnly.1"] ? 1 : 0;
}

- (CGFloat)dockIconPointSize {
    id stored = [NSUserDefaults.standardUserDefaults objectForKey:@"FanqieX.BottomIconPointSize.1"];
    if ([stored respondsToSelector:@selector(doubleValue)]) {
        CGFloat v = (CGFloat)[stored doubleValue];
        if (v >= 16.0 && v <= 34.0) return v;
    }
    return 27.0;
}

- (void)applyDockItemImages {
    UITabBar *tabBar = self.nativeDockBar;
    if (!tabBar || tabBar.items.count == 0) return;
    BOOL isDark = [self isDarkDock];
    self.dockAppliedInkState = isDark ? 1 : 0;
    CGFloat white = isDark ? 1.0 : 0.0;
    UIColor *selectedInk = [UIColor colorWithWhite:white alpha:1.0];
    UIColor *normalInk = [UIColor colorWithWhite:white alpha:(isDark ? 0.68 : 0.86)];
    NSInteger displayMode = [self dockDisplayMode];
    CGFloat ptSize = [self dockIconPointSize];
    NSArray<UITabBarItem *> *items = tabBar.items;
    NSArray<NSString *> *titles = self.dockTitles;
    NSArray<UIButton *> *buttons = self.buttons;
    NSArray<NSNumber *> *hostIndices = self.capsuleHostIndices;
    for (NSUInteger i = 0; i < items.count; ++i) {
        UITabBarItem *item = items[i];
        NSString *title = (i < titles.count) ? titles[i] : (item.accessibilityLabel ?: @"");
        NSUInteger hostIdx = (i < hostIndices.count) ? hostIndices[i].unsignedIntegerValue : i;
        UIButton *btn = (hostIdx < buttons.count && [buttons[hostIdx] isKindOfClass:UIButton.class]) ? buttons[hostIdx] : nil;
        item.image = FQXDockItemImage(title, btn, displayMode, ptSize, NO, normalInk);
        item.selectedImage = FQXDockItemImage(title, btn, displayMode, ptSize, YES, selectedInk);
    }
    if (self.detachedHostIndex != NSNotFound &&
        (NSUInteger)self.detachedHostIndex < buttons.count &&
        self.detachedButton) {
        NSUInteger detIdx = (NSUInteger)self.detachedHostIndex;
        UIButton *detBtn = [buttons[detIdx] isKindOfClass:UIButton.class] ? buttons[detIdx] : nil;
        NSString *detTitle = self.detachedButton.moduleTitle ?: FQXDockButtonTitle(detBtn, self.bar, detIdx);
        // Right circular button uses module icon (with automatic fallback if custom title-only module).
        UIImage *normImg = FQXDockItemImage(detTitle, detBtn, 1, ptSize, NO, normalInk);
        UIImage *selImg = FQXDockItemImage(detTitle, detBtn, 1, ptSize, YES, selectedInk);
        [self.detachedButton updateImagesNormal:normImg selected:selImg];
        [self.detachedButton syncUnreadBadgeFromHostButton:detBtn];
    }
}

- (void)syncDetachedDockMaterial:(BOOL)glassDark {
    if (!self.detachedButton || self.detachedHostIndex == NSNotFound) return;
    FQXDockMaterialMode mode = FQXCurrentDockMaterialMode();
    BOOL reduce = UIAccessibilityIsReduceTransparencyEnabled();
    BOOL wantsClear = (mode == FQXDockMaterialIOS18Gaussian) && !reduce;
    UIVisualEffect *effect = wantsClear ? nil : FQXMakeDockEffectForMode(mode, glassDark, YES, reduce);
    NSInteger stamp = reduce ? 999 : ((FQXGlassDarkTintEnabled() ? 1000 : 0) + (glassDark ? 100 : 0) + (NSInteger)mode + 1);
    UIColor *selColor = FQXDockSelectionColorForMode(mode, [self isDarkDock]);
    [self.detachedButton applyGlassEffect:effect
                           interfaceStyle:self.dockAppliedStyle
                           selectionColor:selColor
                       reduceTransparency:reduce
                               styleStamp:stamp];
    FQXApplyDockBackdropBlur(self.detachedButton.glassView,
                             self.detachedButton.glassView.contentView,
                             self.detachedButton.selectionLens,
                             self.detachedButton.glassView.contentView.bounds,
                             -1,
                             glassDark,
                             mode,
                             DockBlurPrefKey);
}

- (void)syncSelectionExclusivityAnimated:(BOOL)animated {
    UITabBar *tabBar = self.nativeDockBar;
    if (!tabBar || !tabBar.items.count) return;
    NSUInteger hostSel = [self currentSelectedIndex];
    if (self.detachedHostIndex != NSNotFound &&
        self.detachedButton &&
        hostSel == (NSUInteger)self.detachedHostIndex) {
        if (tabBar.selectedItem != nil) {
            tabBar.selectedItem = nil;
        }
        FQXSetNativeTabSelectionLensVisible(tabBar, NO, 0);
        [self.detachedButton setModuleSelected:YES animated:animated];
        return;
    }

    FQXSetNativeTabSelectionLensVisible(tabBar, YES, 0);
    if (self.detachedButton) {
        [self.detachedButton setModuleSelected:NO animated:animated];
    }
    NSUInteger capPos = self.capsuleHostIndices.count
        ? [self.capsuleHostIndices indexOfObject:@(hostSel)]
        : hostSel;
    if (capPos != NSNotFound && capPos < tabBar.items.count) {
        UITabBarItem *desiredItem = tabBar.items[capPos];
        if (tabBar.selectedItem != desiredItem) {
            tabBar.selectedItem = desiredItem;
        }
    }
}

- (BOOL)syncDockItems {
    UITabBar *tabBar = self.nativeDockBar;
    if (!tabBar || !self.buttons.count) return NO;
    NSInteger displayMode = [self dockDisplayMode];
    CGFloat ptSize = [self dockIconPointSize];
    NSMutableArray<NSString *> *allTitles = [NSMutableArray arrayWithCapacity:self.buttons.count];
    for (NSUInteger i = 0; i < self.buttons.count; ++i) {
        UIButton *btn = self.buttons[i];
        NSString *title = [btn isKindOfClass:UIButton.class] ? FQXDockButtonTitle(btn, self.bar, i) : @"";
        [allTitles addObject:title];
    }
    FQXDockDetachedUpdateHostModules(allTitles);
    NSInteger detIdx = FQXDockDetachedResolveIndex(allTitles);
    self.detachedHostIndex = detIdx;

    NSMutableString *sig = [NSMutableString stringWithFormat:@"dm=%ld|pt=%.1f|det=%ld|",
                            (long)displayMode, ptSize, (long)(detIdx == NSNotFound ? -1 : detIdx)];
    NSMutableArray<NSString *> *capsuleTitles = [NSMutableArray arrayWithCapacity:allTitles.count];
    NSMutableArray<NSNumber *> *capsuleIndices = [NSMutableArray arrayWithCapacity:allTitles.count];
    for (NSUInteger i = 0; i < allTitles.count; ++i) {
        [sig appendFormat:@"%@|", allTitles[i]];
        if (detIdx != NSNotFound && i == (NSUInteger)detIdx) continue;
        [capsuleTitles addObject:allTitles[i]];
        [capsuleIndices addObject:@(i)];
    }

    BOOL rebuilt = ![sig isEqualToString:self.dockSignature];
    if (rebuilt) {
        NSMutableArray<UITabBarItem *> *items = [NSMutableArray arrayWithCapacity:capsuleTitles.count];
        for (NSUInteger i = 0; i < capsuleTitles.count; ++i) {
            UITabBarItem *item = [[UITabBarItem alloc] initWithTitle:nil image:nil tag:(NSInteger)i];
            item.accessibilityLabel = capsuleTitles[i];
            [items addObject:item];
        }
        self.capsuleHostIndices = capsuleIndices;
        self.dockTitles = capsuleTitles;
        self.dockSignature = sig;
        tabBar.items = items;

        if (detIdx != NSNotFound && (NSUInteger)detIdx < self.buttons.count) {
            if (!self.detachedButton) {
                FQXDetachedDockButtonView *circle = [[FQXDetachedDockButtonView alloc] initWithFrame:CGRectMake(0.0, 0.0, 56.0, 56.0)];
                objc_setAssociatedObject(circle, FQXOwnedGlassElementKey, @YES, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
                objc_setAssociatedObject(circle.glassView, FQXOwnedGlassElementKey, @YES, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
                __weak FQXTabBarInteraction *weakSelf = self;
                circle.onTouchDiagnostic = ^(NSString *stage, NSDictionary<NSString *, id> *info) {
                    FQXTabBarInteraction *strongSelf = weakSelf;
                    NSMutableDictionary<NSString *, id> *payload = [NSMutableDictionary dictionaryWithDictionary:(info ?: @{})];
                    payload[@"stage"] = stage ?: @"";
                    payload[@"hostIndex"] = @(strongSelf ? strongSelf.detachedHostIndex : NSNotFound);
                    FQXDiagRecordEvent(FQXDiagCategoryUI, @"dock_detached_touch", payload, NO);
                };
                circle.onTapModule = ^(UIButton *hostButton) {
                    FQXTabBarInteraction *strongSelf = weakSelf;
                    if (!strongSelf) return;
                    NSInteger targetIdx = strongSelf.detachedHostIndex;
                    if (targetIdx == NSNotFound) return;
                    [strongSelf triggerHostNavigationForHostIndex:(NSUInteger)targetIdx
                                                   fallbackButton:hostButton
                                                           source:@"detached_circle_tap"];
                };
                self.detachedButton = circle;
            }
            self.detachedButton.moduleTitle = allTitles[(NSUInteger)detIdx];
            self.detachedButton.targetHostButton = self.buttons[(NSUInteger)detIdx];
        } else if (self.detachedButton) {
            self.detachedButton.hidden = YES;
            [self.detachedButton removeFromSuperview];
            self.detachedButton = nil;
        }
        [self applyDockItemImages];
        FQXDiagRecordEvent(FQXDiagCategoryUI, @"dock_detached_state", @{
            @"detachedEnabled": @(detIdx != NSNotFound),
            @"detachedModule": (detIdx != NSNotFound && (NSUInteger)detIdx < allTitles.count) ? allTitles[(NSUInteger)detIdx] : @"",
            @"capsuleCount": @(capsuleTitles.count),
            @"totalVisibleModules": @(allTitles.count),
        }, NO);
    } else if (detIdx != NSNotFound && (NSUInteger)detIdx < self.buttons.count && self.detachedButton) {
        UIButton *detBtn = self.buttons[(NSUInteger)detIdx];
        self.detachedButton.targetHostButton = detBtn;
        [self.detachedButton syncUnreadBadgeFromHostButton:detBtn];
    }

    [self syncSelectionExclusivityAnimated:(tabBar.window != nil && !rebuilt)];
    return rebuilt;
}

- (void)layoutNativeDockInBar:(UIView *)bar proxy:(UIVisualEffectView *)proxy forceMeasure:(BOOL)forceMeasure {
    UITabBar *tabBar = self.nativeDockBar;
    if (!tabBar || !bar || !proxy) return;
    CGRect proxyFrame = proxy.frame;
    if (CGRectGetWidth(proxyFrame) < 60.0 || CGRectGetHeight(proxyFrame) < 30.0) return;

    BOOL hasDetached = (self.detachedHostIndex != NSNotFound && self.detachedButton != nil);
    NSUInteger itemCount = tabBar.items.count;
    CGFloat barW = CGRectGetWidth(bar.bounds);
    BOOL barWidthChanged = fabs(barW - self.dockLastBarWidth) > 0.5;
    if (forceMeasure || barWidthChanged || hasDetached != self.dockLastDetachedActive || itemCount != self.dockLastItemCount) {
        self.dockPlatterMeasured = NO;
        self.dockPlatterInset = 21.0;
        self.dockLastBarWidth = barW;
    }

    BOOL geometryChanged = forceMeasure || !self.dockPlatterMeasured || barWidthChanged ||
                           hasDetached != self.dockLastDetachedActive ||
                           itemCount != self.dockLastItemCount ||
                           fabs(CGRectGetMinX(proxyFrame) - CGRectGetMinX(self.dockLastProxyFrame)) > 0.5 ||
                           fabs(CGRectGetMinY(proxyFrame) - CGRectGetMinY(self.dockLastProxyFrame)) > 0.5 ||
                           fabs(CGRectGetWidth(proxyFrame) - CGRectGetWidth(self.dockLastProxyFrame)) > 0.5 ||
                           fabs(CGRectGetHeight(proxyFrame) - CGRectGetHeight(self.dockLastProxyFrame)) > 0.5;

    BOOL isDark = (self.dockAppliedStyle == UIUserInterfaceStyleDark);
    if (!geometryChanged) {
        UIView *platter = FQXFindDockPlatter(tabBar);
        FQXApplyNativeDockMaterial(tabBar, platter, isDark);
        if (hasDetached) {
            [self syncDetachedDockMaterial:isDark];
        }
        [self syncSelectionExclusivityAnimated:NO];
        [self ensureDockZOrderInBar:bar];
        return;
    }

    CGFloat barH = MAX(CGRectGetHeight(bar.bounds), CGRectGetHeight(proxyFrame) + 12.0);
    CGFloat sideMargin = (barW >= 390.0) ? 16.0 : 12.0;
    CGFloat maxGroupW = MAX(180.0, barW - sideMargin * 2.0);
    CGFloat targetW = hasDetached ? MIN(CGRectGetWidth(proxyFrame), maxGroupW) : CGRectGetWidth(proxyFrame);
    CGFloat targetH = CGRectGetHeight(proxyFrame);
    CGFloat gap = (barW >= 410.0) ? 12.0 : ((barW >= 375.0) ? 10.0 : 8.0);
    CGFloat circleD = targetH;
    CGFloat availCapsuleW = hasDetached ? MAX(96.0, targetW - gap - circleD) : targetW;
    CGFloat maxAllowedBarW = MAX(220.0, barW + 48.0);
    UIView *platter = nil;

    for (NSUInteger pass = 0; pass < 2; ++pass) {
        CGFloat platterH = self.dockPlatterHeight > 20.0 ? self.dockPlatterHeight : 62.0;
        CGFloat scale = MAX(0.70, MIN(1.30, targetH / platterH));
        CGFloat desiredBarW = (availCapsuleW / scale) + 2.0 * self.dockPlatterInset;
        desiredBarW = MAX(120.0, MIN(maxAllowedBarW, desiredBarW));
        CGRect curBounds = tabBar.bounds;
        if (fabs(CGRectGetWidth(curBounds) - desiredBarW) > 0.5 || fabs(CGRectGetHeight(curBounds) - barH) > 0.5) {
            tabBar.bounds = CGRectMake(0.0, 0.0, desiredBarW, barH);
        }
        [tabBar layoutIfNeeded];
        platter = FQXFindDockPlatter(tabBar);
        if (!platter || CGRectGetHeight(platter.bounds) <= 10.0) break;

        CGRect pf = [platter convertRect:platter.bounds toView:tabBar];
        CGFloat measuredH = CGRectGetHeight(pf);
        // Only adopt measured horizontal inset when the platter is actually constrained by
        // UIKit's side inset (8..32pt). For 2-3 tab Docks at natural width, UIKit stops
        // growing the platter and leaves extra margin; absorbing that margin would explode
        // desiredBarW on subsequent passes.
        CGFloat rawInset = (CGRectGetWidth(tabBar.bounds) - CGRectGetWidth(pf)) * 0.5;
        CGFloat measuredInset = (rawInset >= 8.0 && rawInset <= 32.0) ? rawInset : 21.0;
        CGFloat offX = CGRectGetMidX(pf) - CGRectGetMidX(tabBar.bounds);
        CGFloat offY = CGRectGetMidY(pf) - CGRectGetMidY(tabBar.bounds);
        BOOL metricChanged = !self.dockPlatterMeasured ||
                             fabs(measuredH - self.dockPlatterHeight) > 0.5 ||
                             fabs(measuredInset - self.dockPlatterInset) > 0.5 ||
                             fabs(offX - self.dockPlatterMidOffsetX) > 0.5 ||
                             fabs(offY - self.dockPlatterMidOffsetY) > 0.5;
        self.dockPlatterHeight = measuredH;
        self.dockPlatterInset = measuredInset;
        self.dockPlatterMidOffsetX = offX;
        self.dockPlatterMidOffsetY = offY;
        self.dockPlatterMeasured = YES;
        if (!metricChanged) break;
    }

    FQXApplyNativeDockMaterial(tabBar, platter, isDark);

    CGFloat finalScale = MAX(0.70, MIN(1.30, targetH / MAX(20.0, self.dockPlatterHeight)));
    if (hasDetached) {
        CGRect pf = (platter && CGRectGetHeight(platter.bounds) > 10.0)
            ? [platter convertRect:platter.bounds toView:tabBar]
            : CGRectZero;
        // CRITICAL: Never clamp rendered platter width smaller than UIKit's real platter
        // width (doing so caused the left capsule to physically collide with the right circle).
        CGFloat pfW = (CGRectGetWidth(pf) > 20.0) ? CGRectGetWidth(pf) : (availCapsuleW / finalScale);
        CGFloat pfH = (CGRectGetHeight(pf) > 10.0) ? CGRectGetHeight(pf) : MAX(20.0, self.dockPlatterHeight);
        CGFloat realCapsuleW = pfW * finalScale;
        CGFloat realCapsuleH = pfH * finalScale;
        circleD = round(realCapsuleH);

        CGFloat totalGroupW = realCapsuleW + gap + circleD;
        if (totalGroupW > maxGroupW) {
            if (gap > 8.0) {
                gap = MAX(8.0, gap - (totalGroupW - maxGroupW));
                totalGroupW = realCapsuleW + gap + circleD;
            }
            if (totalGroupW > maxGroupW && (pfW + pfH) > 1.0) {
                CGFloat shrinkScale = (maxGroupW - gap) / (pfW + pfH);
                finalScale = MAX(0.64, MIN(finalScale, shrinkScale));
                realCapsuleW = pfW * finalScale;
                realCapsuleH = pfH * finalScale;
                circleD = round(realCapsuleH);
            }
        }

        CGFloat groupW = realCapsuleW + gap + circleD;
        CGFloat groupMinX = CGRectGetMidX(proxyFrame) - groupW * 0.5;
        if (barW >= groupW + sideMargin * 2.0) {
            groupMinX = MAX(sideMargin, MIN(barW - groupW - sideMargin, groupMinX));
        } else {
            groupMinX = MAX(6.0, (barW - groupW) * 0.5);
        }
        CGFloat capsuleRealMaxX = groupMinX + realCapsuleW;
        CGFloat circleMinX = round(capsuleRealMaxX + gap);
        if (circleMinX - capsuleRealMaxX < 8.0) {
            circleMinX = ceil(capsuleRealMaxX + 8.0);
        }
        if (circleMinX + circleD > barW - 6.0) {
            CGFloat excess = (circleMinX + circleD) - (barW - 6.0);
            groupMinX = MAX(6.0, groupMinX - excess);
            capsuleRealMaxX = groupMinX + realCapsuleW;
            circleMinX = ceil(capsuleRealMaxX + MAX(8.0, gap));
        }
        CGFloat capsuleMidX = groupMinX + realCapsuleW * 0.5;
        CGPoint center = CGPointMake(capsuleMidX - self.dockPlatterMidOffsetX * finalScale,
                                     CGRectGetMidY(proxyFrame) - self.dockPlatterMidOffsetY * finalScale);
        if (fabs(tabBar.center.x - center.x) > 0.25 || fabs(tabBar.center.y - center.y) > 0.25) {
            tabBar.center = center;
        }
        CGAffineTransform xform = CGAffineTransformMakeScale(finalScale, finalScale);
        if (!CGAffineTransformEqualToTransform(tabBar.transform, xform)) {
            tabBar.transform = xform;
        }

        CGRect circleFrame = CGRectMake(circleMinX,
                                        round(CGRectGetMidY(proxyFrame) - circleD * 0.5),
                                        circleD,
                                        circleD);
        if (self.detachedButton.superview != bar) {
            [bar insertSubview:self.detachedButton aboveSubview:tabBar];
        }
        if (!CGRectEqualToRect(self.detachedButton.frame, circleFrame)) {
            self.detachedButton.frame = circleFrame;
            [self.detachedButton layoutIfNeeded];
        }
        [self syncDetachedDockMaterial:isDark];
        [self ensureDockZOrderInBar:bar];

        CGRect platterInBar = platter ? [platter convertRect:platter.bounds toView:bar]
                                      : CGRectMake(groupMinX, CGRectGetMidY(proxyFrame) - realCapsuleH * 0.5, realCapsuleW, realCapsuleH);
        CGFloat actualGap = CGRectGetMinX(circleFrame) - CGRectGetMaxX(platterInBar);
        CGFloat overlapPt = MAX(0.0, CGRectGetMaxX(platterInBar) - CGRectGetMinX(circleFrame));
        NSString *layoutSig = [NSString stringWithFormat:@"%ld|%.0f|%.0f|%.0f|%.0f|%.1f",
                               (long)self.detachedHostIndex,
                               CGRectGetMinX(platterInBar), CGRectGetMaxX(platterInBar),
                               CGRectGetMinX(circleFrame), CGRectGetWidth(circleFrame), actualGap];
        NSString *prevLayoutSig = objc_getAssociatedObject(bar, FQXDockDetachedLayoutSigKey);
        if (!prevLayoutSig || ![prevLayoutSig isEqualToString:layoutSig]) {
            objc_setAssociatedObject(bar, FQXDockDetachedLayoutSigKey, layoutSig, OBJC_ASSOCIATION_COPY_NONATOMIC);
            FQXDiagRecordEvent(FQXDiagCategoryUI, @"dock_detached_layout", @{
                @"detachedModule": self.detachedButton.moduleTitle ?: @"",
                @"detachedHostIndex": @(self.detachedHostIndex),
                @"capsuleCount": @(itemCount),
                @"capsulePlatterFrameInBar": FQXDockRectArray(platterInBar),
                @"detachedFrameInBar": FQXDockRectArray(circleFrame),
                @"actualGapPt": @(round(actualGap * 10.0) / 10.0),
                @"overlapPt": @(round(overlapPt * 10.0) / 10.0),
                @"finalScale": @(round(finalScale * 1000.0) / 1000.0),
                @"proxyFrameInBar": FQXDockRectArray(proxyFrame),
                @"barBounds": FQXDockRectArray(bar.bounds),
            }, NO);
        }
    } else {
        if (self.detachedButton && !self.detachedButton.hidden) {
            self.detachedButton.hidden = YES;
        }
        CGPoint center = CGPointMake(CGRectGetMidX(proxyFrame) - self.dockPlatterMidOffsetX * finalScale,
                                     CGRectGetMidY(proxyFrame) - self.dockPlatterMidOffsetY * finalScale);
        if (fabs(tabBar.center.x - center.x) > 0.25 || fabs(tabBar.center.y - center.y) > 0.25) {
            tabBar.center = center;
        }
        CGAffineTransform xform = CGAffineTransformMakeScale(finalScale, finalScale);
        if (!CGAffineTransformEqualToTransform(tabBar.transform, xform)) {
            tabBar.transform = xform;
        }
        [self ensureDockZOrderInBar:bar];
    }

    [self syncSelectionExclusivityAnimated:NO];
    self.dockLastProxyFrame = proxyFrame;
    self.dockLastItemCount = itemCount;
    self.dockLastDetachedActive = hasDetached;
}

- (void)setNativeDockVisible:(BOOL)visible restoreProxy:(BOOL)restoreProxy {
    if (self.nativeDockBar && self.nativeDockBar.hidden == visible) {
        self.nativeDockBar.hidden = !visible;
    }
    BOOL showDetached = visible && (self.detachedHostIndex != NSNotFound) && (self.detachedButton != nil);
    if (self.detachedButton && self.detachedButton.hidden == showDetached) {
        self.detachedButton.hidden = !showDetached;
    }
    if (visible) {
        self.nativeDockActive = YES;
        FQXSetDockMaterialOwner(self.bar, self.proxy, FQXDockMaterialOwnerNative, showDetached);
        if (self.overlay) {
            FQXSetZeroMaskHidden(self.overlay, YES);
            if (self.overlay.userInteractionEnabled) self.overlay.userInteractionEnabled = NO;
        }
        [self ensureDockZOrderInBar:self.bar];
        FQXAuditVisibleDockGlassLayers(self.bar, self.proxy, self.nativeDockBar, showDetached ? self.detachedButton : nil);
    } else {
        self.nativeDockActive = NO;
        if (restoreProxy) {
            FQXSetDockMaterialOwner(self.bar, self.proxy, FQXDockMaterialOwnerProxy, NO);
            if (self.overlay) {
                FQXSetZeroMaskHidden(self.overlay, NO);
                if (!self.overlay.userInteractionEnabled) self.overlay.userInteractionEnabled = YES;
            }
            FQXAuditVisibleDockGlassLayers(self.bar, self.proxy, nil, nil);
        }
    }
}

#pragma mark - UITabBarDelegate

- (void)tabBar:(UITabBar *)tabBar didSelectItem:(UITabBarItem *)item {
    NSUInteger idx = [tabBar.items indexOfObjectIdenticalTo:item];
    if (idx == NSNotFound) return;
    NSUInteger hostIdx = (idx < self.capsuleHostIndices.count)
        ? self.capsuleHostIndices[idx].unsignedIntegerValue : idx;
    if (hostIdx >= self.buttons.count) return;
    UIButton *btn = self.buttons[hostIdx];
    if (![btn isKindOfClass:UIButton.class]) return;
    FQXSetNativeTabSelectionLensVisible(tabBar, YES, 0);
    if (self.detachedButton) {
        [self.detachedButton setModuleSelected:NO animated:YES];
    }
    [btn sendActionsForControlEvents:UIControlEventTouchUpInside];
    [self ensureDockZOrderInBar:self.bar];
    FQXScheduleCYLGlassResample(self.bar, self.proxy);
}

- (void)onNativeValueChanged:(UIControl *)sender {
    if (![sender isKindOfClass:UISegmentedControl.class]) return;
    FQXScheduleCYLGlassResample(self.bar, self.proxy);
}

- (void)updateLens:(UIVisualEffectView *)lens native:(UIView *)native {
    if (native) self.nativeControl = native;
    if (lens) {
        self.restingLens = lens;
        if (lens.superview && lens.superview != self.proxy && lens.superview.superview == self.bar) {
            self.overlay = lens.superview;
        }
    }
    // Runs inside FQHBottomPolish178R7 AFTER Lrepair_front and Lmaterial_update.
    // Re-enforce single-owner proxy neutralization and topmost z-order for detachedButton.
    if (self.nativeDockActive) {
        BOOL showDetached = (self.detachedHostIndex != NSNotFound && self.detachedButton != nil);
        FQXSetDockMaterialOwner(self.bar, self.proxy, FQXDockMaterialOwnerNative, showDetached);
        if (self.overlay) {
            FQXSetZeroMaskHidden(self.overlay, YES);
            if (self.overlay.userInteractionEnabled) self.overlay.userInteractionEnabled = NO;
        }
        [self ensureDockZOrderInBar:self.bar];
        FQXAuditVisibleDockGlassLayers(self.bar, self.proxy, self.nativeDockBar, showDetached ? self.detachedButton : nil);
    }
}

- (void)syncWithBar:(UIView *)bar
              proxy:(UIVisualEffectView *)proxy
            buttons:(NSArray<UIButton *> *)buttons
             native:(UIView *)native
               lens:(UIVisualEffectView *)lens {
    if (self.bar != bar) {
        [self setNativeDockVisible:NO restoreProxy:YES];
        [self.nativeDockBar removeFromSuperview];
        self.nativeDockBar.delegate = nil;
        self.nativeDockBar = nil;
        [self.detachedButton removeFromSuperview];
        self.detachedButton = nil;
        self.capsuleHostIndices = nil;
        self.detachedHostIndex = NSNotFound;
        self.dockLastDetachedActive = NO;
        self.dockSignature = nil;
        self.dockPlatterMeasured = NO;
        self.dockAppliedStyle = UIUserInterfaceStyleUnspecified;
        self.dockAppliedInkState = -1;
    }
    self.bar = bar;
    self.proxy = proxy;
    self.nativeControl = native;
    if (lens) self.restingLens = lens;
    self.buttons = buttons;

    UIView *overlay = self.restingLens.superview;
    if (!overlay && !native && buttons.count) {
        UIView *parent = buttons.firstObject.superview;
        if (parent && parent != proxy && parent != proxy.contentView && parent.superview == bar) {
            overlay = parent;
        }
    }
    self.overlay = overlay;

    BOOL compact = (overlay && overlay.hidden) || (proxy.contentView && proxy.contentView.hidden);
    BOOL hiddenProxy = proxy.hidden || CGRectGetWidth(proxy.frame) < 60.0 || CGRectGetHeight(proxy.frame) < 30.0;
    if (compact || hiddenProxy || buttons.count < 2 || !FQXGlassEnabled() || [self usesNativeSegmentedSelector]) {
        [self setNativeDockVisible:NO restoreProxy:YES];
        FQXApplyDockProxyMaterial(bar, proxy, lens);
        if ([native isKindOfClass:UISegmentedControl.class]) {
            UIControl *seg = (UIControl *)native;
            if (![self.wiredControls containsObject:seg]) {
                [seg addTarget:self action:@selector(onNativeValueChanged:) forControlEvents:UIControlEventValueChanged];
                [self.wiredControls addObject:seg];
            }
        }
        return;
    }

    if (!self.nativeDockBar) {
        UITabBar *tabBar = [[UITabBar alloc] initWithFrame:bar.bounds];
        tabBar.delegate = self;
        tabBar.clipsToBounds = NO;
        objc_setAssociatedObject(tabBar, FQXOwnedGlassElementKey, @YES, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
        self.nativeDockBar = tabBar;
        self.dockPlatterMeasured = NO;
        self.dockLastProxyFrame = CGRectZero;
    }

    if (self.nativeDockBar.superview != bar) {
        [bar addSubview:self.nativeDockBar];
    }
    [self ensureDockZOrderInBar:bar];

    UIUserInterfaceStyle desiredStyle = [self desiredDockGlassStyle];
    BOOL styleChanged = (self.dockAppliedStyle != desiredStyle) ||
                        (self.nativeDockBar.overrideUserInterfaceStyle != desiredStyle);
    if (styleChanged) {
        self.dockAppliedStyle = desiredStyle;
        if (self.nativeDockBar.overrideUserInterfaceStyle != desiredStyle) {
            self.nativeDockBar.overrideUserInterfaceStyle = desiredStyle;
        }
    }

    NSInteger desiredInk = [self isDarkDock] ? 1 : 0;
    BOOL inkChanged = (self.dockAppliedInkState != desiredInk);
    BOOL itemsRebuilt = [self syncDockItems];
    if (inkChanged && !itemsRebuilt) {
        [self applyDockItemImages];
    }
    if (styleChanged || itemsRebuilt) {
        UIView *curPlatter = FQXFindDockPlatter(self.nativeDockBar);
        if (curPlatter) {
            objc_setAssociatedObject(curPlatter, FQXPlatterAppliedStyleKey, nil, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
            static Class platterCls = Nil;
            static dispatch_once_t spOnce;
            dispatch_once(&spOnce, ^{ platterCls = NSClassFromString(@"UIKit._UITabBarPlatterView"); });
            if (platterCls && curPlatter.superview) {
                for (UIView *sib in curPlatter.superview.subviews) {
                    if ([sib isKindOfClass:platterCls]) {
                        objc_setAssociatedObject(sib, FQXPlatterAppliedStyleKey, nil, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
                    }
                }
            }
        }
    }

    // Do NOT apply glass to proxy while expanded: nativeDockBar (+ detached circle) is the sole
    // material owner. Proxy switches to FQXDockMaterialOwnerProxy cleanly on collapse/fallback.
    [self layoutNativeDockInBar:bar proxy:proxy forceMeasure:itemsRebuilt];
    [self setNativeDockVisible:YES restoreProxy:NO];
}

- (void)teardown {
    [self setNativeDockVisible:NO restoreProxy:YES];
    self.nativeDockBar.delegate = nil;
    [self.nativeDockBar removeFromSuperview];
    self.nativeDockBar = nil;
    [self.detachedButton removeFromSuperview];
    self.detachedButton = nil;
    self.capsuleHostIndices = nil;
    self.detachedHostIndex = NSNotFound;
    self.dockLastDetachedActive = NO;
    self.dockSignature = nil;
    self.dockTitles = nil;
    self.dockPlatterMeasured = NO;
    self.dockAppliedStyle = UIUserInterfaceStyleUnspecified;
    self.dockAppliedInkState = -1;
}

@end

#pragma mark - DYKiller-Style Top Drama Channel Capsule (Long-Press Floating Glass & Drag)

@interface FQXFlexGlassView : UIVisualEffectView
@property(nonatomic, weak) UIView *flexSourceView;
@end

@implementation FQXFlexGlassView
- (UIView *)_flexInteractionGestureView {
    UIView *source = self.flexSourceView;
    if (source && source.window) return source;
    SEL sel = NSSelectorFromString(@"_flexInteractionGestureView");
    if ([UIVisualEffectView instancesRespondToSelector:sel]) {
        struct objc_super sup = { self, UIVisualEffectView.class };
        return ((id (*)(struct objc_super *, SEL))objc_msgSendSuper)(&sup, sel);
    }
    return nil;
}
@end

typedef NS_ENUM(NSInteger, FQXTopCapsuleTouchMode) {
    FQXTopCapsuleTouchIdle = 0,
    FQXTopCapsuleTouchPressing = 1,
    FQXTopCapsuleTouchDragging = 2,
};

static const void *FQXDramaTopCapsuleKey = &FQXDramaTopCapsuleKey;
static const void *FQXDramaTopGlassStampKey = &FQXDramaTopGlassStampKey;

// AlignedGlass publishes only the header surface and its legacy selection.
// The effect view can also contain an independently adjustable blur at index 0.
static const void *FQXDramaHeaderSurfaceKey(void) {
    return (const void *)sel_registerName("fqx_dramaHeaderSurface191");
}

static const void *FQXDramaHeaderFallbackSelectionKey(void) {
    return (const void *)sel_registerName("fqx_dramaHeaderFallbackSelection191");
}

static const void *FQXDramaHeaderSelectionOwnerKey(void) {
    return (const void *)sel_registerName("fqx_dramaHeaderSelectionOwner191");
}

static BOOL FQXDramaHeaderHostIsDark(UIView *header, UIView *tabs, NSString *__autoreleasing *outSource);

@interface FQXDramaTopCapsuleInteraction : NSObject <UIGestureRecognizerDelegate>
@property(nonatomic, weak) UIView *tabsView;
@property(nonatomic, weak) UICollectionView *collectionView;
@property(nonatomic, weak) UIVisualEffectView *outerGlass;
@property(nonatomic, weak) UIView *flatLens;
@property(nonatomic, strong) FQXFlexGlassView *pillGlass;
@property(nonatomic, strong) UILongPressGestureRecognizer *pressGesture;
@property(nonatomic, strong) UILongPressGestureRecognizer *dragGesture;
@property(nonatomic) FQXTopCapsuleTouchMode mode;
@property(nonatomic) NSInteger lastSelectedIndex;
@property(nonatomic) BOOL paging;
@property(nonatomic) NSInteger hoverIndex;
@property(nonatomic) CGFloat anchorX;
@property(nonatomic, copy) NSString *lastDarkSource;
- (void)placePillAtRestingAnimated:(BOOL)animated;
@end

@implementation FQXDramaTopCapsuleInteraction

- (instancetype)init {
    self = [super init];
    if (self) {
        _lastSelectedIndex = NSNotFound;
        _hoverIndex = NSNotFound;
    }
    return self;
}

- (BOOL)currentResolvedDarkState {
    UIView *categories = self.tabsView.superview;
    UIView *header = categories.superview;
    if (header) {
        NSString *src = nil;
        BOOL dark = FQXDramaHeaderHostIsDark(header, self.tabsView, &src);
        self.lastDarkSource = src;
        return dark;
    }
    UIVisualEffectView *outer = self.outerGlass;
    self.lastDarkSource = @"outer_trait";
    return (outer.overrideUserInterfaceStyle == UIUserInterfaceStyleDark) ||
           (outer.overrideUserInterfaceStyle == UIUserInterfaceStyleUnspecified &&
            outer.traitCollection.userInterfaceStyle == UIUserInterfaceStyleDark);
}

- (void)syncRestingPillCorners {
    if (!self.pillGlass) return;
    CGRect pb = self.pillGlass.contentView.bounds;
    CGFloat radius = MIN(CGRectGetWidth(pb), CGRectGetHeight(pb)) * 0.5;
    if (radius > 0.5) {
        self.pillGlass.contentView.layer.cornerCurve = kCACornerCurveContinuous;
        if (fabs(self.pillGlass.contentView.layer.cornerRadius - radius) > 0.25) {
            self.pillGlass.contentView.layer.cornerRadius = radius;
        }
        if (!self.pillGlass.contentView.clipsToBounds) {
            self.pillGlass.contentView.clipsToBounds = YES;
        }
    }
}

- (void)applyMaterialToOuter:(UIVisualEffectView *)outer isDark:(BOOL)isDark {
    if (!outer || !self.pillGlass) return;
    BOOL darkTint = FQXGlassDarkTintEnabled();
    BOOL blurDark = darkTint ? isDark : FQXAppIsInNightMode();
    FQXApplyBackdropBlur(outer, outer.contentView, nil, outer.bounds, -1, blurDark, DramaHeaderBlurPrefKey);
    BOOL reduce = UIAccessibilityIsReduceTransparencyEnabled();
    // Follow the page's optical backdrop polarity (Dark on video feed, Light on bright subtabs).
    // Forcing Light override over dark video causes iOS 26/27 Clear glass to paint a white haze,
    // while Dark override + tintColor == nil keeps the capsule crystal-clear and colorless.
    UIUserInterfaceStyle uiStyle = isDark ? UIUserInterfaceStyleDark : UIUserInterfaceStyleLight;
    if (outer.overrideUserInterfaceStyle != uiStyle) {
        outer.overrideUserInterfaceStyle = uiStyle;
    }
    if (self.pillGlass.overrideUserInterfaceStyle != uiStyle) {
        self.pillGlass.overrideUserInterfaceStyle = uiStyle;
    }
    if (outer.backgroundColor && ![outer.backgroundColor isEqual:UIColor.clearColor]) {
        outer.backgroundColor = UIColor.clearColor;
    }
    if (outer.contentView.backgroundColor && ![outer.contentView.backgroundColor isEqual:UIColor.clearColor]) {
        outer.contentView.backgroundColor = UIColor.clearColor;
    }

    // Avoid double-stacking two untinted UIGlassEffectStyleClear surfaces at rest (which compounds
    // into a milky-white solid oval on the selected tab). At rest when darkTint is OFF, keep outer
    // as the sole Clear Liquid Glass and render a clean recessed non-white capsule indicator; during
    // active press/drag, materialize live interactive Clear glass on pillGlass for fluid refraction.
    BOOL pillInteractiveLens = darkTint || reduce || (self.mode != FQXTopCapsuleTouchIdle);
    NSInteger stamp = (isDark ? 2 : 1) | (reduce ? 4 : 0) | (darkTint ? 8 : 0) | (pillInteractiveLens ? 16 : 0);
    NSNumber *applied = objc_getAssociatedObject(outer, FQXDramaTopGlassStampKey);
    BOOL outerLost = (!outer.effect || [outer.effect isKindOfClass:UIBlurEffect.class]);
    if (applied && applied.integerValue == stamp && !outerLost) {
        if (!pillInteractiveLens) [self syncRestingPillCorners];
        return;
    }
    objc_setAssociatedObject(outer, FQXDramaTopGlassStampKey, @(stamp), OBJC_ASSOCIATION_RETAIN_NONATOMIC);

    NSInteger glassStyle = reduce ? 0 : 1;
    UIColor *outerTint = (!reduce && darkTint && isDark) ? [UIColor colorWithWhite:0.0 alpha:0.30] : nil;
    UIVisualEffect *outerEffect = FQXMakeGlassEffect(glassStyle, NO, outerTint);
    UIVisualEffect *pillEffect = nil;
    UIColor *pillContentFill = UIColor.clearColor;
    if (pillInteractiveLens) {
        UIColor *pillTint = nil;
        if (darkTint) {
            pillTint = [UIColor colorWithWhite:0.0 alpha:(isDark ? 0.45 : 0.10)];
        } else if (reduce) {
            pillTint = [UIColor colorWithWhite:(isDark ? 1.0 : 0.0) alpha:0.12];
        }
        pillEffect = FQXMakeGlassEffect(glassStyle, YES, pillTint);
    } else {
        pillContentFill = isDark
            ? [UIColor colorWithWhite:0.0 alpha:0.18]
            : [UIColor colorWithWhite:0.0 alpha:0.08];
    }

    void (^changes)(void) = ^{
        outer.overrideUserInterfaceStyle = uiStyle;
        outer.effect = outerEffect;
        self.pillGlass.overrideUserInterfaceStyle = uiStyle;
        self.pillGlass.effect = pillEffect;
        self.pillGlass.backgroundColor = UIColor.clearColor;
        self.pillGlass.contentView.backgroundColor = pillContentFill;
        if (!pillInteractiveLens) {
            [self syncRestingPillCorners];
        }
    };
    if (applied) {
        [UIView animateWithDuration:0.20 animations:changes];
    } else {
        changes();
    }
    NSInteger blurStrength = FQXBlurPercent([NSUserDefaults.standardUserDefaults doubleForKey:DramaHeaderBlurPrefKey]);
    FQXDiagRecordEvent(FQXDiagCategoryUI, @"drama_top_glass_material", @{
        @"isDark": @(isDark),
        @"darkSource": self.lastDarkSource ?: @"unknown",
        @"darkTint": @(darkTint),
        @"overrideStyle": @((NSInteger)uiStyle),
        @"outerHasTint": @(outerTint != nil),
        @"outerEffectClass": outerEffect ? (NSStringFromClass(outerEffect.class) ?: @"") : @"nil",
        @"pillEffectClass": pillEffect ? (NSStringFromClass(pillEffect.class) ?: @"") : @"nil",
        @"pillInteractiveLens": @(pillInteractiveLens),
        @"visibleGlassLayers": @(pillEffect ? 2 : 1),
        @"blurStrength": @(blurStrength),
        @"reduceTransparency": @(reduce),
    }, NO);
}

- (NSArray<NSValue *> *)visibleItemRectsInCollection:(NSMutableArray<NSNumber *> *)outIndices {
    UICollectionView *cv = self.collectionView;
    if (!cv) return @[];
    NSInteger count = [cv numberOfItemsInSection:0];
    if (count <= 0 || count > 24) return @[];
    NSMutableArray<NSValue *> *rects = [NSMutableArray arrayWithCapacity:(NSUInteger)count];
    for (NSInteger i = 0; i < count; ++i) {
        NSIndexPath *ip = [NSIndexPath indexPathForItem:i inSection:0];
        UICollectionViewLayoutAttributes *attr = [cv layoutAttributesForItemAtIndexPath:ip];
        CGRect f = attr ? attr.frame : CGRectZero;
        if (CGRectGetWidth(f) < 6.0 || CGRectGetHeight(f) < 6.0) continue;
        [rects addObject:[NSValue valueWithCGRect:f]];
        if (outIndices) [outIndices addObject:@(i)];
    }
    return rects;
}

- (NSInteger)currentHostSelectedIndex {
    UIView *tabs = self.tabsView;
    if (!tabs) return NSNotFound;
    id owner = FQXObjGet(tabs, "delegate");
    SEL indexSelector = sel_registerName("curTabIndex");
    Method indexMethod = class_getInstanceMethod(object_getClass(owner), indexSelector);
    if (indexMethod && strcmp(method_getTypeEncoding(indexMethod), "q16@0:8") == 0) {
        NSInteger index = ((NSInteger (*)(id, SEL))objc_msgSend)(owner, indexSelector);
        if (index >= 0 && index < [self.collectionView numberOfItemsInSection:0]) return index;
    }
    NSArray *ds = FQXObjGet(tabs, "dataSource");
    if (![ds isKindOfClass:NSArray.class]) return NSNotFound;
    for (NSUInteger i = 0; i < ds.count && i < 24; ++i) {
        if (FQXBoolGet(ds[i], "isSelected", NO)) return (NSInteger)i;
    }
    return NSNotFound;
}

- (NSInteger)itemIndexAtCollectionX:(CGFloat)x {
    NSMutableArray<NSNumber *> *indices = [NSMutableArray array];
    NSArray<NSValue *> *rects = [self visibleItemRectsInCollection:indices];
    NSInteger nearest = NSNotFound;
    CGFloat best = CGFLOAT_MAX;
    for (NSUInteger i = 0; i < rects.count; ++i) {
        CGRect f = rects[i].CGRectValue;
        if (x >= CGRectGetMinX(f) && x <= CGRectGetMaxX(f)) return indices[i].integerValue;
        CGFloat d = fabs(x - CGRectGetMidX(f));
        if (d < best) {
            best = d;
            nearest = indices[i].integerValue;
        }
    }
    return nearest;
}

- (CGRect)pillRectForAnchorX:(CGFloat)anchorX {
    UICollectionView *cv = self.collectionView;
    UIVisualEffectView *outer = self.outerGlass;
    if (!cv || !outer) return CGRectZero;
    NSArray<NSValue *> *rects = [self visibleItemRectsInCollection:nil];
    if (!rects.count) return CGRectZero;
    CGFloat pillW = CGRectGetWidth(rects.firstObject.CGRectValue);
    CGRect prevRect = CGRectZero;
    BOOL hasPrev = NO;
    for (NSValue *val in rects) {
        CGRect r = val.CGRectValue;
        CGFloat mid = CGRectGetMidX(r);
        if (anchorX <= mid) {
            if (!hasPrev) {
                pillW = CGRectGetWidth(r);
            } else {
                CGFloat from = CGRectGetMidX(prevRect);
                CGFloat progress = mid > from ? (anchorX - from) / (mid - from) : 1.0;
                pillW = CGRectGetWidth(prevRect) + (CGRectGetWidth(r) - CGRectGetWidth(prevRect)) * progress;
            }
            hasPrev = NO;
            break;
        }
        prevRect = r;
        hasPrev = YES;
    }
    if (hasPrev) pillW = CGRectGetWidth(prevRect);
    pillW += 12.0;

    CGPoint inOuter = [cv convertPoint:CGPointMake(anchorX, CGRectGetMidY(cv.bounds)) toView:outer.contentView];
    CGRect ob = outer.contentView.bounds;
    CGFloat insetY = 3.0;
    CGFloat pillH = MAX(22.0, CGRectGetHeight(ob) - insetY * 2.0);
    CGFloat minX = 3.0;
    CGFloat maxX = MAX(minX, CGRectGetWidth(ob) - pillW - 3.0);
    CGFloat x = MIN(maxX, MAX(minX, inOuter.x - pillW * 0.5));
    return CGRectMake(x, (CGRectGetHeight(ob) - pillH) * 0.5, MIN(pillW, CGRectGetWidth(ob) - 6.0), pillH);
}

- (void)placePill:(CGRect)target animated:(BOOL)animated {
    if (!self.pillGlass) return;
    if (CGRectGetWidth(target) < 12.0 || CGRectGetHeight(target) < 12.0) {
        if (!self.pillGlass.hidden) self.pillGlass.hidden = YES;
        return;
    }
    if (self.pillGlass.hidden) self.pillGlass.hidden = NO;
    if (fabs(CGRectGetMinX(self.pillGlass.frame) - CGRectGetMinX(target)) < 0.25 &&
        fabs(CGRectGetMinY(self.pillGlass.frame) - CGRectGetMinY(target)) < 0.25 &&
        fabs(CGRectGetWidth(self.pillGlass.frame) - CGRectGetWidth(target)) < 0.25 &&
        fabs(CGRectGetHeight(self.pillGlass.frame) - CGRectGetHeight(target)) < 0.25) {
        return;
    }
    if (animated && !UIAccessibilityIsReduceMotionEnabled()) {
        [UIView animateWithDuration:0.42
                              delay:0.0
             usingSpringWithDamping:0.78
              initialSpringVelocity:0.0
                            options:UIViewAnimationOptionBeginFromCurrentState |
                                    UIViewAnimationOptionAllowUserInteraction
                         animations:^{
            self.pillGlass.frame = target;
            if (!self.pillGlass.effect) [self syncRestingPillCorners];
        } completion:nil];
    } else {
        [UIView performWithoutAnimation:^{
            self.pillGlass.frame = target;
            if (!self.pillGlass.effect) [self syncRestingPillCorners];
        }];
    }
}

- (void)placePillAtRestingAnimated:(BOOL)animated {
    if (self.paging) {
        [self placePill:CGRectZero animated:NO];
        return;
    }
    NSInteger sel = [self currentHostSelectedIndex];
    UICollectionView *cv = self.collectionView;
    if (sel != NSNotFound && cv) {
        UICollectionViewLayoutAttributes *attr = [cv layoutAttributesForItemAtIndexPath:[NSIndexPath indexPathForItem:sel inSection:0]];
        if (attr && CGRectGetWidth(attr.frame) >= 6.0) {
            self.anchorX = CGRectGetMidX(attr.frame);
            [self placePill:[self pillRectForAnchorX:self.anchorX] animated:animated];
            return;
        }
    }
    [self placePill:CGRectZero animated:NO];
}

- (BOOL)gestureRecognizer:(UIGestureRecognizer *)gr shouldRecognizeSimultaneouslyWithGestureRecognizer:(UIGestureRecognizer *)other {
    (void)gr; (void)other;
    return YES;
}

- (BOOL)gestureRecognizerShouldBegin:(UIGestureRecognizer *)gr {
    if (gr != self.dragGesture) return YES;
    UICollectionView *cv = self.collectionView;
    if (!cv || cv.isDragging) return NO;
    CGFloat x = [gr locationInView:cv].x;
    NSInteger idx = [self itemIndexAtCollectionX:x];
    NSInteger sel = [self currentHostSelectedIndex];
    return idx != NSNotFound && idx == sel;
}

- (void)handlePress:(UILongPressGestureRecognizer *)gr {
    UICollectionView *cv = self.collectionView;
    if (!cv) return;
    if (gr.state == UIGestureRecognizerStateBegan) {
        CGFloat x = [gr locationInView:cv].x;
        NSInteger idx = [self itemIndexAtCollectionX:x];
        if (idx == NSNotFound) return;
        UICollectionViewLayoutAttributes *attr = [cv layoutAttributesForItemAtIndexPath:[NSIndexPath indexPathForItem:idx inSection:0]];
        if (!attr) return;
        self.mode = FQXTopCapsuleTouchPressing;
        [self applyMaterialToOuter:self.outerGlass isDark:[self currentResolvedDarkState]];
        self.anchorX = CGRectGetMidX(attr.frame);
        [self placePill:[self pillRectForAnchorX:self.anchorX] animated:YES];
    } else if (gr.state == UIGestureRecognizerStateEnded ||
               gr.state == UIGestureRecognizerStateCancelled ||
               gr.state == UIGestureRecognizerStateFailed) {
        if (self.mode != FQXTopCapsuleTouchPressing) return;
        self.mode = FQXTopCapsuleTouchIdle;
        [self applyMaterialToOuter:self.outerGlass isDark:[self currentResolvedDarkState]];
        __weak typeof(self) weakSelf = self;
        dispatch_async(dispatch_get_main_queue(), ^{
            typeof(self) s = weakSelf;
            if (!s || s.mode != FQXTopCapsuleTouchIdle) return;
            [s placePillAtRestingAnimated:YES];
        });
    }
}

- (void)updateDragAtGesture:(UILongPressGestureRecognizer *)gr animated:(BOOL)animated {
    UICollectionView *cv = self.collectionView;
    if (!cv) return;
    NSArray<NSValue *> *rects = [self visibleItemRectsInCollection:nil];
    if (!rects.count) return;
    CGFloat minAnchor = CGRectGetMidX(rects.firstObject.CGRectValue);
    CGFloat maxAnchor = CGRectGetMidX(rects.lastObject.CGRectValue);
    CGFloat x = [gr locationInView:cv].x;
    self.anchorX = MIN(maxAnchor, MAX(minAnchor, x));
    NSInteger idx = [self itemIndexAtCollectionX:self.anchorX];
    if (idx != NSNotFound && idx != self.hoverIndex) {
        self.hoverIndex = idx;
        UISelectionFeedbackGenerator *gen = [[UISelectionFeedbackGenerator alloc] init];
        [gen selectionChanged];
    }
    [self placePill:[self pillRectForAnchorX:self.anchorX] animated:animated];
}

- (void)handleDrag:(UILongPressGestureRecognizer *)gr {
    UICollectionView *cv = self.collectionView;
    UIView *tabs = self.tabsView;
    if (!cv || !tabs) return;
    if (gr.state == UIGestureRecognizerStateBegan) {
        self.mode = FQXTopCapsuleTouchDragging;
        [self applyMaterialToOuter:self.outerGlass isDark:[self currentResolvedDarkState]];
        self.hoverIndex = [self currentHostSelectedIndex];
        cv.panGestureRecognizer.enabled = NO;
        UIImpactFeedbackGenerator *impact = [[UIImpactFeedbackGenerator alloc] initWithStyle:UIImpactFeedbackStyleLight];
        [impact impactOccurred];
        [self updateDragAtGesture:gr animated:YES];
    } else if (gr.state == UIGestureRecognizerStateChanged) {
        [self updateDragAtGesture:gr animated:NO];
    } else if (self.mode == FQXTopCapsuleTouchDragging) {
        self.mode = FQXTopCapsuleTouchIdle;
        [self applyMaterialToOuter:self.outerGlass isDark:[self currentResolvedDarkState]];
        cv.panGestureRecognizer.enabled = YES;
        NSInteger target = self.hoverIndex;
        self.hoverIndex = NSNotFound;
        NSInteger cur = [self currentHostSelectedIndex];
        if (gr.state == UIGestureRecognizerStateEnded && target != NSNotFound && target != cur) {
            NSIndexPath *ip = [NSIndexPath indexPathForItem:target inSection:0];
            SEL sel = @selector(collectionView:didSelectItemAtIndexPath:);
            if ([tabs respondsToSelector:sel]) {
                ((void (*)(id, SEL, id, id))objc_msgSend)(tabs, sel, cv, ip);
            }
            self.lastSelectedIndex = target;
            [self placePillAtRestingAnimated:YES];
        } else {
            [self placePillAtRestingAnimated:YES];
        }
    }
}

- (void)releaseSelectionOwnership {
    UIVisualEffectView *outer = self.outerGlass;
    if (outer && self.pillGlass &&
        objc_getAssociatedObject(outer, FQXDramaHeaderSelectionOwnerKey()) == self.pillGlass) {
        objc_setAssociatedObject(outer, FQXDramaHeaderSelectionOwnerKey(), nil, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
        // hidden still describes whether the host has one valid selected item.
        // Restore only the alpha owned by this replacement, not its geometry.
        if (self.flatLens.superview == outer.contentView && self.flatLens.alpha == 0.0) {
            [UIView performWithoutAnimation:^{ self.flatLens.alpha = 1.0; }];
        }
    }
    if (outer) {
        objc_setAssociatedObject(outer, FQXDramaTopGlassStampKey, nil, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
    }
    self.flatLens = nil;
    self.outerGlass = nil;
}

- (void)invalidate {
    if (self.pressGesture.view) [self.pressGesture.view removeGestureRecognizer:self.pressGesture];
    if (self.dragGesture.view) [self.dragGesture.view removeGestureRecognizer:self.dragGesture];
    [self releaseSelectionOwnership];
    [self.pillGlass removeFromSuperview];
    self.pillGlass = nil;
    if (self.mode == FQXTopCapsuleTouchDragging && self.collectionView) {
        self.collectionView.panGestureRecognizer.enabled = YES;
    }
    self.mode = FQXTopCapsuleTouchIdle;
    self.paging = NO;
    self.lastSelectedIndex = NSNotFound;
    self.hoverIndex = NSNotFound;
}

- (void)syncWithTabs:(UIView *)tabs {
    if (!tabs || !FQXGlassEnabled()) {
        [self invalidate];
        return;
    }
    UIView *categories = tabs.superview;
    UICollectionView *cv = FQXObjGet(tabs, "collectionView");
    if (!categories || ![cv isKindOfClass:UICollectionView.class]) {
        [self invalidate];
        return;
    }
    UIVisualEffectView *outer = objc_getAssociatedObject(categories, FQXDramaHeaderSurfaceKey());
    if (![outer isKindOfClass:UIVisualEffectView.class] || outer.superview != categories ||
        outer.hidden || CGRectGetWidth(outer.bounds) < 60.0 || CGRectGetHeight(outer.bounds) > 48.0) {
        [self invalidate];
        return;
    }

    UIView *flat = objc_getAssociatedObject(outer, FQXDramaHeaderFallbackSelectionKey());
    if (![flat isKindOfClass:UIView.class] || flat.superview != outer.contentView) flat = nil;
    if (self.outerGlass != outer || (self.collectionView && self.collectionView != cv)) {
        [self invalidate];
    }

    self.tabsView = tabs;
    self.collectionView = cv;
    self.outerGlass = outer;
    self.flatLens = flat;

    if (!self.pillGlass) {
        FQXFlexGlassView *pill = [[FQXFlexGlassView alloc] initWithEffect:nil];
        pill.flexSourceView = cv;
        pill.userInteractionEnabled = NO;
        pill.accessibilityElementsHidden = YES;
        FQXApplyCornerConfiguration(pill, 0.0, NO);
        objc_setAssociatedObject(pill, FQXOwnedGlassElementKey, @YES, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
        self.pillGlass = pill;
    }
    if (self.pillGlass.flexSourceView != cv) self.pillGlass.flexSourceView = cv;
    if (self.pillGlass.superview != outer.contentView) {
        [outer.contentView addSubview:self.pillGlass];
    }
    if (objc_getAssociatedObject(outer, FQXDramaHeaderSelectionOwnerKey()) != self.pillGlass) {
        objc_setAssociatedObject(outer, FQXDramaHeaderSelectionOwnerKey(), self.pillGlass, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
    }
    if (flat && flat.alpha != 0.0) {
        [UIView performWithoutAnimation:^{ flat.alpha = 0.0; }];
    }

    if (!self.pressGesture) {
        self.pressGesture = [[UILongPressGestureRecognizer alloc] initWithTarget:self action:@selector(handlePress:)];
        self.pressGesture.minimumPressDuration = 0.0;
        self.pressGesture.cancelsTouchesInView = NO;
        self.pressGesture.delegate = self;
    }
    if (self.pressGesture.view != cv) {
        [self.pressGesture.view removeGestureRecognizer:self.pressGesture];
        [cv addGestureRecognizer:self.pressGesture];
    }
    if (!self.dragGesture) {
        self.dragGesture = [[UILongPressGestureRecognizer alloc] initWithTarget:self action:@selector(handleDrag:)];
        self.dragGesture.minimumPressDuration = 0.22;
        self.dragGesture.cancelsTouchesInView = NO;
        self.dragGesture.delegate = self;
    }
    if (self.dragGesture.view != cv) {
        [self.dragGesture.view removeGestureRecognizer:self.dragGesture];
        [cv addGestureRecognizer:self.dragGesture];
    }

    UIView *header = categories.superview;
    NSString *darkSource = nil;
    BOOL isDark = header ? FQXDramaHeaderHostIsDark(header, tabs, &darkSource)
                         : ((outer.overrideUserInterfaceStyle == UIUserInterfaceStyleDark) ||
                            (outer.overrideUserInterfaceStyle == UIUserInterfaceStyleUnspecified &&
                             outer.traitCollection.userInterfaceStyle == UIUserInterfaceStyleDark));
    self.lastDarkSource = darkSource ?: @"outer_trait";
    [self applyMaterialToOuter:outer isDark:isDark];

    if (self.mode == FQXTopCapsuleTouchIdle) {
        NSInteger sel = [self currentHostSelectedIndex];
        BOOL selChanged = (self.lastSelectedIndex != NSNotFound && sel != NSNotFound && sel != self.lastSelectedIndex);
        self.lastSelectedIndex = sel;
        [self placePillAtRestingAnimated:selChanged];
    }
}

@end

static UILabel *FQXFindFirstVisibleLabel(UIView *root, NSInteger depth) {
    if (!root || root.hidden || root.alpha <= 0.01 || depth > 4) return nil;
    if ([root isKindOfClass:UILabel.class]) {
        UILabel *lbl = (UILabel *)root;
        if (lbl.text.length > 0 && lbl.textColor) return lbl;
    }
    for (UIView *sub in root.subviews) {
        UILabel *found = FQXFindFirstVisibleLabel(sub, depth + 1);
        if (found) return found;
    }
    return nil;
}

static BOOL FQXColorLuminance(UIColor *color, UITraitCollection *traits, CGFloat *outLuma) {
    if (![color isKindOfClass:UIColor.class]) return NO;
    UIColor *resolved = traits ? [color resolvedColorWithTraitCollection:traits] : color;
    CGFloat r = 0, g = 0, b = 0, a = 0, w = 0;
    if ([resolved getRed:&r green:&g blue:&b alpha:&a]) {
        if (a >= 0.45) {
            if (outLuma) *outLuma = (r + g * 2.0 + b) * 0.25;
            return YES;
        }
    } else if ([resolved getWhite:&w alpha:&a]) {
        if (a >= 0.45) {
            if (outLuma) *outLuma = w;
            return YES;
        }
    }
    return NO;
}

static BOOL FQXDramaHeaderHostIsDark(UIView *header, UIView *tabs, NSString *__autoreleasing *outSource) {
    id feed = FQXObjGet(header, "delegate");
    UIView *content = FQXObjGet(feed, "contentView");
    id owner = FQXObjGet(feed, "rootTabBarController");
    NSArray *models = FQXObjGet(feed, "tabModels");
    NSArray *cells = FQXObjGet(tabs, "dataSource");
    NSInteger selected = -1;
    if ([cells isKindOfClass:NSArray.class]) {
        for (NSUInteger i = 0; i < cells.count && i < 24; ++i) {
            if (FQXBoolGet(cells[i], "isSelected", NO)) {
                selected = (NSInteger)i;
                break;
            }
        }
    }

    // 1. Authoritative host tab-model background polarity when available.
    SEL bgSel = sel_registerName("bottomTabBackgroundColorWithTabModel:");
    if (selected >= 0 && [models isKindOfClass:NSArray.class] && (NSUInteger)selected < models.count &&
        owner && [owner respondsToSelector:bgSel]) {
        Method m = class_getInstanceMethod(object_getClass(owner), bgSel);
        if (m && strcmp(method_getTypeEncoding(m), "@24@0:8@16") == 0) {
            UIColor *tabColor = ((id (*)(id, SEL, id))objc_msgSend)(owner, bgSel, models[(NSUInteger)selected]);
            CGFloat luma = 0.0;
            if (FQXColorLuminance(tabColor, content ? content.traitCollection : header.traitCollection, &luma)) {
                if (outSource) *outSource = @"tab_model_bg";
                return luma < 0.5;
            }
        }
    }

    // 2. Inspect active category label ink luminance (white ink => dark video backdrop;
    // dark ink => light content page), matching real visual polarity immediately on tab switch.
    UICollectionView *cv = FQXObjGet(tabs, "collectionView");
    if ([cv isKindOfClass:UICollectionView.class] && selected >= 0) {
        NSIndexPath *ip = [NSIndexPath indexPathForItem:selected inSection:0];
        UICollectionViewCell *cell = [cv cellForItemAtIndexPath:ip];
        UILabel *lbl = cell ? FQXFindFirstVisibleLabel(cell, 0) : nil;
        CGFloat inkLuma = 0.0;
        if (lbl && FQXColorLuminance(lbl.textColor, lbl.traitCollection, &inkLuma)) {
            if (inkLuma >= 0.68) {
                if (outSource) *outSource = @"active_label_ink";
                return YES;
            }
            if (inkLuma <= 0.38) {
                if (outSource) *outSource = @"active_label_ink";
                return NO;
            }
        }
    }

    // 3. Fallback to feed contentView background color.
    UIColor *contentBg = FQXObjGet(content, "backgroundColor");
    CGFloat bgLuma = 0.0;
    if (FQXColorLuminance(contentBg, content ? content.traitCollection : header.traitCollection, &bgLuma)) {
        if (outSource) *outSource = @"content_bg";
        return bgLuma < 0.5;
    }

    if (outSource) *outSource = @"default_dark";
    return YES;
}

static const void *FQXSearchBtnGlassStampKey = &FQXSearchBtnGlassStampKey;
static const void *FQXSearchBtnCircleGlassKey = &FQXSearchBtnCircleGlassKey;

static FQXFlexGlassView *FQXEnsureDramaSearchCircleGlass(UIButton *searchBtn) {
    if (!searchBtn) return nil;
    FQXFlexGlassView *circle = objc_getAssociatedObject(searchBtn, FQXSearchBtnCircleGlassKey);
    if (![circle isKindOfClass:FQXFlexGlassView.class]) {
        circle = [[FQXFlexGlassView alloc] initWithEffect:nil];
        circle.flexSourceView = searchBtn;
        circle.userInteractionEnabled = NO;
        circle.accessibilityElementsHidden = YES;
        circle.isAccessibilityElement = NO;
        circle.opaque = NO;
        circle.clipsToBounds = NO;
        circle.backgroundColor = UIColor.clearColor;
        circle.contentView.backgroundColor = UIColor.clearColor;
        FQXApplyCornerConfiguration(circle, 0.0, NO);
        objc_setAssociatedObject(circle, FQXOwnedGlassElementKey, @YES, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
        objc_setAssociatedObject(searchBtn, FQXSearchBtnCircleGlassKey, circle, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
    }
    if (circle.flexSourceView != searchBtn) circle.flexSourceView = searchBtn;
    if (circle.superview != searchBtn) {
        [searchBtn insertSubview:circle atIndex:0];
    } else if (searchBtn.subviews.firstObject != circle) {
        [searchBtn sendSubviewToBack:circle];
    }
    if (!CGRectEqualToRect(circle.frame, searchBtn.bounds)) {
        circle.frame = searchBtn.bounds;
    }
    return circle;
}

static void FQXSyncDramaSearchButtonGlass(UIButton *searchBtn,
                                          BOOL isDark,
                                          NSString *darkSource,
                                          CGRect outerFrameInHeader) {
    if (!searchBtn) return;
    BOOL reduce = UIAccessibilityIsReduceTransparencyEnabled();
    BOOL darkTint = FQXGlassDarkTintEnabled();
    UIUserInterfaceStyle uiStyle = isDark ? UIUserInterfaceStyleDark : UIUserInterfaceStyleLight;
    if (searchBtn.overrideUserInterfaceStyle != uiStyle) {
        searchBtn.overrideUserInterfaceStyle = uiStyle;
    }
    if (searchBtn.backgroundColor && ![searchBtn.backgroundColor isEqual:UIColor.clearColor]) {
        searchBtn.backgroundColor = UIColor.clearColor;
    }
    if (searchBtn.clipsToBounds) {
        searchBtn.clipsToBounds = NO;
    }

    // Replace UIButtonConfiguration's built-in glass background (which double-stacked when
    // customized and inflated internal padding beyond headerBounds) with a single plain icon
    // configuration + one FQXFlexGlassView matching the top capsule's exact Clear Liquid Glass.
    UIButtonConfiguration *cur = searchBtn.configuration;
    FQXFlexGlassView *circle = FQXEnsureDramaSearchCircleGlass(searchBtn);
    if (!circle) return;
    if (circle.overrideUserInterfaceStyle != uiStyle) {
        circle.overrideUserInterfaceStyle = uiStyle;
    }

    NSInteger stamp = (isDark ? 2 : 1) | (reduce ? 4 : 0) | (darkTint ? 8 : 0);
    NSNumber *applied = objc_getAssociatedObject(searchBtn, FQXSearchBtnGlassStampKey);
    BOOL effectMissing = (!circle.effect || [circle.effect isKindOfClass:UIBlurEffect.class]);
    BOOL configHasBgGlass = (cur && cur.background.visualEffect != nil);
    if (applied && applied.integerValue == stamp && !effectMissing && !configHasBgGlass) return;

    if (cur) {
        UIButtonConfiguration *cfg = [UIButtonConfiguration plainButtonConfiguration];
        cfg.image = cur.image;
        cfg.contentInsets = NSDirectionalEdgeInsetsZero;
        cfg.background.visualEffect = nil;
        cfg.background.backgroundColor = UIColor.clearColor;
        cfg.baseBackgroundColor = UIColor.clearColor;
        searchBtn.configuration = cfg;
    }
    UIColor *tint = (!reduce && darkTint && isDark) ? [UIColor colorWithWhite:0.0 alpha:0.30] : nil;
    UIVisualEffect *glassEffect = FQXMakeGlassEffect(reduce ? 0 : 1, YES, tint);
    circle.effect = glassEffect;
    circle.backgroundColor = UIColor.clearColor;
    circle.contentView.backgroundColor = UIColor.clearColor;
    FQXApplyCornerConfiguration(circle, 0.0, NO);
    if (circle.superview != searchBtn) {
        [searchBtn insertSubview:circle atIndex:0];
    } else if (searchBtn.subviews.firstObject != circle) {
        [searchBtn sendSubviewToBack:circle];
    }
    objc_setAssociatedObject(searchBtn, FQXSearchBtnGlassStampKey, @(stamp), OBJC_ASSOCIATION_RETAIN_NONATOMIC);
    NSInteger blurStrength = FQXBlurPercent([NSUserDefaults.standardUserDefaults doubleForKey:DramaHeaderBlurPrefKey]);
    CGFloat centerDelta = CGRectIsEmpty(outerFrameInHeader)
        ? 0.0
        : (CGRectGetMidY(searchBtn.frame) - CGRectGetMidY(outerFrameInHeader));
    FQXDiagRecordEvent(FQXDiagCategoryUI, @"drama_search_glass_material", @{
        @"isDark": @(isDark),
        @"darkSource": darkSource ?: @"unknown",
        @"darkTint": @(darkTint),
        @"overrideStyle": @((NSInteger)uiStyle),
        @"hasTint": @(tint != nil),
        @"effectClass": glassEffect ? (NSStringFromClass(glassEffect.class) ?: @"") : @"nil",
        @"blurStrength": @(blurStrength),
        @"reduceTransparency": @(reduce),
        @"singleLayer": @YES,
        @"circleFrame": FQXDockRectArray(searchBtn.frame),
        @"outerHeight": @(round(CGRectGetHeight(outerFrameInHeader) * 10.0) / 10.0),
        @"alignedCenterYDelta": @(round(centerDelta * 10.0) / 10.0),
    }, NO);
}

static NSHashTable<UIView *> *FQXTrackedDramaHeaders(void) {
    static NSHashTable<UIView *> *headers;
    static dispatch_once_t once;
    dispatch_once(&once, ^{ headers = [NSHashTable weakObjectsHashTable]; });
    return headers;
}

static BOOL FQXDramaHeaderAlignInFlight = NO;

static void FQXAlignDramaHeaderCapsuleAndSearch(UIView *header) {
    if (FQXDramaHeaderAlignInFlight || !header || !header.window) return;
    CGRect headerBounds = header.bounds;
    if (CGRectGetWidth(headerBounds) < 120.0 || CGRectGetHeight(headerBounds) < 34.0) return;

    FQXDramaHeaderAlignInFlight = YES;

    UIButton *searchBtn = nil;
    for (UIView *subview in header.subviews) {
        if ([subview isKindOfClass:UIButton.class] && [subview.accessibilityLabel isEqualToString:@"搜索"]) {
            searchBtn = (UIButton *)subview;
            break;
        }
    }

    id headerOwner = FQXObjGet(header, "delegate");
    UIView *headerTabs = FQXObjGet(headerOwner, "simpleTabView");
    NSString *darkSource = nil;
    BOOL isDark = FQXDramaHeaderHostIsDark(header, headerTabs, &darkSource);
    BOOL blurDark = FQXGlassDarkTintEnabled() ? isDark : FQXAppIsInNightMode();

    UIView *categories = FQXObjGet(header, "tabContainer");
    UIVisualEffectView *outer = categories ? objc_getAssociatedObject(categories, FQXDramaHeaderSurfaceKey()) : nil;
    if (![outer isKindOfClass:UIVisualEffectView.class] || outer.superview != categories ||
        outer.hidden || CGRectGetWidth(outer.bounds) < 60.0 || CGRectGetHeight(outer.bounds) > 48.0) {
        if (searchBtn && !searchBtn.hidden) {
            FQXSyncDramaSearchButtonGlass(searchBtn, isDark, darkSource, CGRectZero);
            FQXFlexGlassView *circle = objc_getAssociatedObject(searchBtn, FQXSearchBtnCircleGlassKey);
            UIView *blurHost = circle ? circle.contentView : searchBtn;
            FQXApplyBackdropBlur(searchBtn, blurHost, nil, blurHost.bounds, -1, blurDark, DramaHeaderBlurPrefKey);
        }
        FQXDramaHeaderAlignInFlight = NO;
        return;
    }

    // Never inflate targetH beyond headerBounds height (doing so clipped the bottom 3-4pt of
    // both the top capsule and search circle into flat white corners). Keep a clean 38pt max
    // height (leaving >= 1pt breathing room top/bottom) and disable container clipping on the
    // glass surfaces so continuous capsule curves render completely unobstructed.
    CGFloat availH = MAX(32.0, CGRectGetHeight(headerBounds) - 2.0);
    CGFloat targetH = MIN(38.0, availH);

    [CATransaction begin];
    [CATransaction setDisableActions:YES];

    if (header.clipsToBounds) header.clipsToBounds = NO;
    if (categories.clipsToBounds) categories.clipsToBounds = NO;
    if (outer.clipsToBounds) outer.clipsToBounds = NO;
    FQXApplyCornerConfiguration(outer, 0.0, NO);

    CGRect of = outer.frame;
    if (fabs(CGRectGetHeight(of) - targetH) > 0.5) {
        CGFloat midY = CGRectGetMidY(of);
        of.origin.y = round(midY - targetH * 0.5);
        of.size.height = targetH;
        outer.frame = of;
    }

    CGRect outerInHeader = [categories convertRect:outer.frame toView:header];
    CGFloat maxAllowedY = CGRectGetMaxY(headerBounds) - 1.0;
    CGFloat minAllowedY = CGRectGetMinY(headerBounds) + 1.0;
    if (CGRectGetMaxY(outerInHeader) > maxAllowedY + 0.5) {
        CGFloat shift = maxAllowedY - CGRectGetMaxY(outerInHeader);
        of.origin.y = round(of.origin.y + shift);
        outer.frame = of;
        outerInHeader = [categories convertRect:outer.frame toView:header];
    }
    if (CGRectGetMinY(outerInHeader) < minAllowedY - 0.5) {
        CGFloat shift = minAllowedY - CGRectGetMinY(outerInHeader);
        of.origin.y = round(of.origin.y + shift);
        outer.frame = of;
        outerInHeader = [categories convertRect:outer.frame toView:header];
    }

    if (searchBtn && !searchBtn.hidden) {
        CGRect curSearch = searchBtn.frame;
        CGFloat targetY = round(CGRectGetMidY(outerInHeader) - targetH * 0.5);
        CGRect targetSearch = CGRectMake(round(CGRectGetMaxX(headerBounds) - 12.0 - targetH),
                                         targetY,
                                         targetH,
                                         targetH);
        if (fabs(CGRectGetMinX(curSearch) - targetSearch.origin.x) > 0.5 ||
            fabs(CGRectGetMinY(curSearch) - targetSearch.origin.y) > 0.5 ||
            fabs(CGRectGetWidth(curSearch) - targetSearch.size.width) > 0.5 ||
            fabs(CGRectGetHeight(curSearch) - targetSearch.size.height) > 0.5) {
            searchBtn.frame = targetSearch;
        }
        FQXSyncDramaSearchButtonGlass(searchBtn, isDark, darkSource, outerInHeader);
        FQXFlexGlassView *circle = FQXEnsureDramaSearchCircleGlass(searchBtn);
        if (circle) {
            FQXApplyCornerConfiguration(circle, 0.0, NO);
            FQXApplyBackdropBlur(searchBtn, circle.contentView, nil, circle.contentView.bounds, -1, blurDark, DramaHeaderBlurPrefKey);
        }
    }

    [CATransaction commit];
    FQXDramaHeaderAlignInFlight = NO;
}

static void FQXSyncDramaTopCapsuleForHeader(UIView *header) {
    if (!header) return;
    if (!FQXGlassEnabled()) {
        UIView *tabs = FQXObjGet(FQXObjGet(header, "delegate"), "simpleTabView");
        FQXDramaTopCapsuleInteraction *interaction = objc_getAssociatedObject(tabs, FQXDramaTopCapsuleKey);
        [interaction invalidate];
        return;
    }
    [FQXTrackedDramaHeaders() addObject:header];
    FQXAlignDramaHeaderCapsuleAndSearch(header);
    id owner = FQXObjGet(header, "delegate");
    UIView *tabs = FQXObjGet(owner, "simpleTabView");
    if (![tabs isKindOfClass:UIView.class]) return;
    FQXDramaTopCapsuleInteraction *interaction = objc_getAssociatedObject(tabs, FQXDramaTopCapsuleKey);
    if (!interaction) {
        interaction = [[FQXDramaTopCapsuleInteraction alloc] init];
        objc_setAssociatedObject(tabs, FQXDramaTopCapsuleKey, interaction, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
    }
    [interaction syncWithTabs:tabs];
}

static void (*OrigDramaHeaderLayoutForCapsule)(id, SEL);
static void HookDramaHeaderLayoutForCapsule(UIView *header, SEL cmd) {
    if (OrigDramaHeaderLayoutForCapsule) OrigDramaHeaderLayoutForCapsule(header, cmd);
    FQXSyncDramaTopCapsuleForHeader(header);
}

static void (*OrigDramaHeaderDidMoveWindow)(id, SEL);
static void HookDramaHeaderDidMoveWindow(UIView *header, SEL cmd) {
    if (OrigDramaHeaderDidMoveWindow) OrigDramaHeaderDidMoveWindow(header, cmd);
    FQXSyncDramaTopCapsuleForHeader(header);
}

static void (*OrigDramaHeaderSearchTransition)(id, SEL, BOOL);
static void HookDramaHeaderSearchTransition(UIView *header, SEL cmd, BOOL finished) {
    if (OrigDramaHeaderSearchTransition) OrigDramaHeaderSearchTransition(header, cmd, finished);
    FQXSyncDramaTopCapsuleForHeader(header);
}

static void (*OrigDramaHeaderUpdateTabs)(id, SEL, CGSize);
static void HookDramaHeaderUpdateTabs(UIView *header, SEL cmd, CGSize size) {
    if (OrigDramaHeaderUpdateTabs) OrigDramaHeaderUpdateTabs(header, cmd, size);
    FQXSyncDramaTopCapsuleForHeader(header);
}

static void (*OrigDramaHeaderTabGeometry)(id, SEL, double, double, BOOL);
static void HookDramaHeaderTabGeometry(UIView *header, SEL cmd, double desired, double base, BOOL reserve) {
    if (OrigDramaHeaderTabGeometry) OrigDramaHeaderTabGeometry(header, cmd, desired, base, reserve);
    FQXSyncDramaTopCapsuleForHeader(header);
}

static void (*OrigDramaTabsLayoutForCapsule)(id, SEL);
static void HookDramaTabsLayoutForCapsule(UIView *tabs, SEL cmd) {
    if (OrigDramaTabsLayoutForCapsule) OrigDramaTabsLayoutForCapsule(tabs, cmd);
    if (FQXDramaHeaderAlignInFlight) return;
    static Class headerCls = Nil;
    static dispatch_once_t once;
    dispatch_once(&once, ^{ headerCls = NSClassFromString(@"SSVideoSeriesFeedHeaderView"); });
    UIView *header = nil;
    if (headerCls) {
        for (UIView *cur = tabs.superview; cur; cur = cur.superview) {
            if ([cur isKindOfClass:headerCls]) {
                header = cur;
                break;
            }
        }
    }
    if (header) {
        FQXSyncDramaTopCapsuleForHeader(header);
        return;
    }
    FQXDramaTopCapsuleInteraction *interaction = objc_getAssociatedObject(tabs, FQXDramaTopCapsuleKey);
    if (interaction) [interaction syncWithTabs:tabs];
}

static void (*OrigDramaCommitTabIndex)(id, SEL, NSInteger, int);
static void HookDramaCommitTabIndex(id owner, SEL cmd, NSInteger index, int type) {
    OrigDramaCommitTabIndex(owner, cmd, index, type);
    UIView *tabs = FQXObjGet(owner, "simpleTabView");
    FQXDramaTopCapsuleInteraction *interaction = objc_getAssociatedObject(tabs, FQXDramaTopCapsuleKey);
    if (interaction.mode == FQXTopCapsuleTouchIdle) {
        [interaction.pillGlass.layer removeAllAnimations];
        interaction.paging = NO;
        interaction.lastSelectedIndex = index;
        [interaction placePillAtRestingAnimated:NO];
    }
}

static void (*OrigDramaScrollBetweenTabs)(id, SEL, id, id, NSInteger, id, NSInteger, CGFloat);
static void HookDramaScrollBetweenTabs(id owner, SEL cmd, id tabs, id leftItem, NSInteger leftIndex,
                                      id rightItem, NSInteger rightIndex, CGFloat ratio) {
    OrigDramaScrollBetweenTabs(owner, cmd, tabs, leftItem, leftIndex, rightItem, rightIndex, ratio);
    FQXDramaTopCapsuleInteraction *interaction = objc_getAssociatedObject(tabs, FQXDramaTopCapsuleKey);
    if (interaction.mode != FQXTopCapsuleTouchIdle) return;
    BOOL paging = ratio > 0.0 && ratio < 1.0;
    if (interaction.paging == paging) return;
    interaction.paging = paging;
    [interaction.pillGlass.layer removeAllAnimations];
    [interaction placePillAtRestingAnimated:NO];
}

static NSHashTable<FQXTabBarInteraction *> *FQXTrackedDockInteractions(void) {
    static NSHashTable<FQXTabBarInteraction *> *table;
    static dispatch_once_t once;
    dispatch_once(&once, ^{ table = [NSHashTable weakObjectsHashTable]; });
    return table;
}

static void FQXRefreshAllDockAppearances(void) {
    if (!NSThread.isMainThread) {
        dispatch_async(dispatch_get_main_queue(), ^{ FQXRefreshAllDockAppearances(); });
        return;
    }
    for (FQXTabBarInteraction *inter in FQXTrackedDockInteractions().allObjects) {
        inter.dockSignature = nil;
        if (inter.nativeDockBar && inter.buttons.count) {
            [inter syncDockItems];
            [inter applyDockItemImages];
            if (inter.bar && inter.proxy) {
                [inter layoutNativeDockInBar:inter.bar proxy:inter.proxy forceMeasure:YES];
                if (inter.nativeDockActive) {
                    [inter setNativeDockVisible:YES restoreProxy:NO];
                }
            }
        }
        [inter.bar setNeedsLayout];
    }
}

static void FQXRefreshAllAudioGlass(void);
static void FQXRefreshAllDramaControlsInWindows(void);
static void FQXRefreshAllPinchCleanStates(void);
static void FQXReapplyAllTrackedCommentGlass(void);
static void FQXRefreshCommentBlurStrengthOnly(void);
static void FQXCompactRuntimeMemory(void);
static void FQXRefreshAllShelfEditButtons(void);
static void FQXRefreshAllShelfHeaderControls(void);
static void FQXRefreshAllMineSidebars(void);
static void FQXRefreshReaderHotCommentBadges(void);
static void FQXRefreshDynamicIslandState(void);

#pragma mark - FQXDockMotion

@interface FQXDockMotion : NSObject
+ (void)prepareDock:(UIView *)dock inBar:(UIView *)bar;
+ (void)animateDock:(UIView *)dock fromFrame:(CGRect)frame compact:(BOOL)compact button:(UIView *)button;
+ (void)syncTabBar:(UIView *)bar
             proxy:(UIVisualEffectView *)proxy
           buttons:(NSArray<UIButton *> *)buttons
            native:(UIView *)native
              lens:(UIVisualEffectView *)lens;
+ (void)refreshAudioGlass;
+ (void)refreshDramaControls;
+ (void)refreshDramaHeaderBlur;
+ (void)refreshDramaPinchClean;
+ (void)refreshCommentGlass;
+ (void)refreshCommentBlurStrength;
+ (void)refreshDockAppearance;
+ (void)refreshDockMaterial;
+ (void)refreshReaderHotCommentBadge;
+ (void)refreshShelfEditButton;
+ (void)refreshShelfHeaderControls;
+ (void)refreshMineSidebar;
+ (void)refreshDynamicIsland;
+ (void)compactMemory;
+ (UIImage *)roundedDramaIconNamed:(NSString *)name size:(CGFloat)size;
@end

@implementation FQXDockMotion
+ (UIImage *)roundedDramaIconNamed:(NSString *)name size:(CGFloat)size {
    UIBezierPath *outline = [UIBezierPath bezierPath];
    BOOL comment = [name isEqualToString:@"ellipsis.bubble"];
    if ([name isEqualToString:@"star"]) {
        CGPoint vertices[10];
        for (NSUInteger i = 0; i < 10; i++) {
            CGFloat angle = -M_PI_2 + i * M_PI / 5;
            CGFloat radius = i % 2 ? 6.5 : 13.0;
            vertices[i] = CGPointMake(16 + radius * cos(angle), 16.5 + radius * sin(angle));
        }
        for (NSUInteger i = 0; i < 10; i++) {
            CGPoint point = vertices[i];
            CGPoint previous = vertices[(i + 9) % 10];
            CGPoint next = vertices[(i + 1) % 10];
            CGFloat roundness = i % 2 ? 0.16 : 0.27;
            CGPoint entry = CGPointMake(point.x + (previous.x - point.x) * roundness,
                                        point.y + (previous.y - point.y) * roundness);
            CGPoint exit = CGPointMake(point.x + (next.x - point.x) * roundness,
                                       point.y + (next.y - point.y) * roundness);
            if (i == 0) [outline moveToPoint:entry];
            else [outline addLineToPoint:entry];
            [outline addQuadCurveToPoint:exit controlPoint:point];
        }
    } else if (comment) {
        [outline moveToPoint:CGPointMake(7.8, 23)];
        [outline addCurveToPoint:CGPointMake(3.3, 15) controlPoint1:CGPointMake(4.8, 21.2) controlPoint2:CGPointMake(3.3, 18.5)];
        [outline addCurveToPoint:CGPointMake(16, 4.8) controlPoint1:CGPointMake(3.3, 9.1) controlPoint2:CGPointMake(8.8, 4.8)];
        [outline addCurveToPoint:CGPointMake(28.7, 15) controlPoint1:CGPointMake(23.2, 4.8) controlPoint2:CGPointMake(28.7, 9.1)];
        [outline addCurveToPoint:CGPointMake(16, 25.1) controlPoint1:CGPointMake(28.7, 20.9) controlPoint2:CGPointMake(23.2, 25.1)];
        [outline addQuadCurveToPoint:CGPointMake(12.8, 24.7) controlPoint:CGPointMake(14.3, 25.1)];
        [outline addQuadCurveToPoint:CGPointMake(7.7, 28) controlPoint:CGPointMake(10.6, 27.2)];
        [outline addQuadCurveToPoint:CGPointMake(6.6, 26.9) controlPoint:CGPointMake(6.1, 28.5)];
        [outline addQuadCurveToPoint:CGPointMake(7.8, 23) controlPoint:CGPointMake(7.7, 24.7)];
    } else if ([name isEqualToString:@"heart"]) {
        [outline moveToPoint:CGPointMake(16, 9.1)];
        [outline addCurveToPoint:CGPointMake(3.4, 13.2) controlPoint1:CGPointMake(11.7, 2.5) controlPoint2:CGPointMake(3.4, 5.1)];
        [outline addCurveToPoint:CGPointMake(15.1, 26.5) controlPoint1:CGPointMake(3.4, 19) controlPoint2:CGPointMake(9.6, 23.5)];
        [outline addQuadCurveToPoint:CGPointMake(16.9, 26.5) controlPoint:CGPointMake(16, 27.1)];
        [outline addCurveToPoint:CGPointMake(28.6, 13.2) controlPoint1:CGPointMake(22.4, 23.5) controlPoint2:CGPointMake(28.6, 19)];
        [outline addCurveToPoint:CGPointMake(16, 9.1) controlPoint1:CGPointMake(28.6, 5.1) controlPoint2:CGPointMake(20.3, 2.5)];
    } else if ([name isEqualToString:@"paperplane"]) {
        [outline moveToPoint:CGPointMake(4.8, 12.9)];
        [outline addLineToPoint:CGPointMake(25.6, 4.7)];
        [outline addQuadCurveToPoint:CGPointMake(28, 7.1) controlPoint:CGPointMake(29.3, 3.2)];
        [outline addLineToPoint:CGPointMake(20.2, 27.1)];
        [outline addQuadCurveToPoint:CGPointMake(17.4, 27.2) controlPoint:CGPointMake(18.7, 30.7)];
        [outline addLineToPoint:CGPointMake(14, 18.4)];
        [outline addLineToPoint:CGPointMake(4.9, 15.7)];
        [outline addQuadCurveToPoint:CGPointMake(4.8, 12.9) controlPoint:CGPointMake(1.3, 14.6)];
    } else {
        return nil;
    }
    [outline closePath];
    if ([name isEqualToString:@"paperplane"]) {
        [outline moveToPoint:CGPointMake(14, 18.4)];
        [outline addLineToPoint:CGPointMake(26.9, 5.8)];
    }
    outline.lineWidth = 2.3;
    outline.lineCapStyle = kCGLineCapRound;
    outline.lineJoinStyle = kCGLineJoinRound;
    UIGraphicsImageRenderer *renderer = [[UIGraphicsImageRenderer alloc] initWithSize:CGSizeMake(size, size)];
    UIImage *image = [renderer imageWithActions:^(UIGraphicsImageRendererContext *context) {
        CGContextScaleCTM(context.CGContext, size / 32, size / 32);
        [UIColor.whiteColor setStroke];
        [outline stroke];
        if (comment) {
            [UIColor.whiteColor setFill];
            for (CGFloat x = 10; x <= 20; x += 5)
                [[UIBezierPath bezierPathWithOvalInRect:CGRectMake(x, 13.7, 2.2, 2.2)] fill];
        }
    }];
    return [image imageWithRenderingMode:UIImageRenderingModeAlwaysTemplate];
}

+ (void)prepareDock:(UIView *)dock inBar:(UIView *)bar {
    (void)bar;
    UIViewPropertyAnimator *previous = objc_getAssociatedObject(dock, DockAnimatorKey);
    if (previous) {
        if (previous.state == UIViewAnimatingStateActive) [previous stopAnimation:YES];
        objc_setAssociatedObject(dock, DockAnimatorKey, nil, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
    }
    if (!dock.window || UIAccessibilityIsReduceMotionEnabled()) {
        objc_setAssociatedObject(dock, DockSnapshotKey, nil, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
        return;
    }
    // Capture live presentation geometry instead of a static raster screenshot so the real
    // UIGlassEffect continues refracting live background content throughout collapse & expand.
    CGRect liveFrame = dock.layer.presentationLayer ? dock.layer.presentationLayer.frame : dock.frame;
    objc_setAssociatedObject(dock, DockSnapshotKey, [NSValue valueWithCGRect:liveFrame], OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

+ (void)animateDock:(UIView *)dock fromFrame:(CGRect)frame compact:(BOOL)compact button:(UIView *)button {
    if ([dock isKindOfClass:UIVisualEffectView.class]) {
        UIVisualEffectView *proxy = (UIVisualEffectView *)dock;
        if (compact) {
            // Transfer material ownership cleanly to proxy before frame 0 of the collapse morph.
            FQXSetDockMaterialOwner(dock.superview, proxy, FQXDockMaterialOwnerProxy, NO);
            FQXApplyDockProxyMaterial(dock.superview, proxy, nil);
        } else if (FQXGetDockMaterialOwner(proxy) != FQXDockMaterialOwnerNative) {
            // Only style proxy when native UITabBar does NOT own the expanded Dock (e.g. fallback).
            FQXApplyDockProxyMaterial(dock.superview, proxy, nil);
        } else {
            // Expanded Dock is owned by nativeDockBar; keep proxy neutralized so zero milky flash occurs.
            FQXEnforceNativeProxyNeutralized(proxy);
        }
    }
    NSValue *captured = objc_getAssociatedObject(dock, DockSnapshotKey);
    objc_setAssociatedObject(dock, DockSnapshotKey, nil, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
    UIViewPropertyAnimator *previous = objc_getAssociatedObject(dock, DockAnimatorKey);
    if (previous) {
        if (previous.state == UIViewAnimatingStateActive) [previous stopAnimation:YES];
        objc_setAssociatedObject(dock, DockAnimatorKey, nil, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
    }
    BOOL reduceMotion = UIAccessibilityIsReduceMotionEnabled();
    CALayer *layer = dock.layer;
    CALayer *presentation = layer.presentationLayer;
    CGRect start = captured ? captured.CGRectValue : (presentation ? presentation.frame : frame);
    CGRect target = dock.frame;
    if (!compact) {
        [button.layer removeAnimationForKey:@"FanqieX.dock.position"];
        [button.layer removeAnimationForKey:DockContentAnimation];
    }
    if (reduceMotion || CGRectIsEmpty(start) || CGRectIsEmpty(target) || CGRectEqualToRect(start, target)) {
        for (NSString *key in @[@"bounds", @"position", @"cornerRadius"]) {
            NSString *animationKey = [@"FanqieX.dock." stringByAppendingString:key];
            [layer removeAnimationForKey:animationKey];
            [button.layer removeAnimationForKey:animationKey];
        }
        return;
    }

    // Interruptible live UIKit Q-elastic spring morph directly on the UIGlassEffect surface:
    // continuous optical edge refraction, zero opacity-0 blink, zero static snapshot ghost.
    [UIView performWithoutAnimation:^{
        dock.frame = start;
        dock.layer.cornerRadius = MIN(CGRectGetWidth(start), CGRectGetHeight(start)) * 0.5;
        if (compact && button) {
            button.alpha = 0.0;
            button.transform = CGAffineTransformMakeScale(0.76, 0.76);
        }
    }];
    UISpringTimingParameters *timing = [[UISpringTimingParameters alloc]
        initWithDampingRatio:compact ? 0.66 : 0.62];
    UIViewPropertyAnimator *animator = [[UIViewPropertyAnimator alloc] initWithDuration:0.48 timingParameters:timing];
    __weak UIView *weakDock = dock;
    __weak UIView *weakButton = button;
    [animator addAnimations:^{
        UIView *strongDock = weakDock;
        UIView *strongBtn = weakButton;
        if (strongDock) {
            strongDock.frame = target;
            strongDock.layer.cornerRadius = MIN(CGRectGetWidth(target), CGRectGetHeight(target)) * 0.5;
        }
        if (compact && strongBtn) {
            strongBtn.alpha = 1.0;
            strongBtn.transform = CGAffineTransformIdentity;
        }
    }];
    [animator addCompletion:^(UIViewAnimatingPosition position) {
        (void)position;
        UIView *strongDock = weakDock;
        if (strongDock && objc_getAssociatedObject(strongDock, DockAnimatorKey) == animator) {
            objc_setAssociatedObject(strongDock, DockAnimatorKey, nil, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
        }
    }];
    objc_setAssociatedObject(dock, DockAnimatorKey, animator, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
    [animator startAnimation];
}

+ (void)syncTabBar:(UIView *)bar
             proxy:(UIVisualEffectView *)proxy
           buttons:(NSArray<UIButton *> *)buttons
            native:(UIView *)native
              lens:(UIVisualEffectView *)lens {
    if (!proxy) return;
    FQXTabBarInteraction *interaction = objc_getAssociatedObject(proxy, TabInteractionKey);
    if (!bar && lens) {
        [interaction updateLens:lens native:native];
        return;
    }
    if (!buttons.count) {
        [interaction teardown];
        return;
    }
    if (!interaction) {
        interaction = [FQXTabBarInteraction new];
        objc_setAssociatedObject(proxy, TabInteractionKey, interaction, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
    }
    [FQXTrackedDockInteractions() addObject:interaction];
    [interaction syncWithBar:bar proxy:proxy buttons:buttons native:native lens:lens];
}

+ (void)refreshAudioGlass {
    FQXInvalidateHotPrefsCache();
    FQXRefreshAllAudioGlass();
}

+ (void)refreshDramaControls {
    FQXInvalidateHotPrefsCache();
    FQXRefreshAllDramaControlsInWindows();
}

+ (void)refreshDramaHeaderBlur {
    FQXInvalidateHotPrefsCache();
    for (UIView *header in FQXTrackedDramaHeaders().allObjects) {
        if (header.window) FQXSyncDramaTopCapsuleForHeader(header);
    }
}

+ (void)refreshDramaPinchClean {
    FQXInvalidateHotPrefsCache();
    FQXRefreshAllPinchCleanStates();
}

+ (void)refreshCommentGlass {
    FQXInvalidateHotPrefsCache();
    FQXReapplyAllTrackedCommentGlass();
}

+ (void)refreshCommentBlurStrength {
    FQXInvalidateHotPrefsCache();
    FQXRefreshCommentBlurStrengthOnly();
}

+ (void)refreshDockAppearance {
    FQXInvalidateHotPrefsCache();
    FQXRefreshAllDockAppearances();
}

+ (void)refreshDockMaterial {
    FQXInvalidateHotPrefsCache();
    for (FQXTabBarInteraction *inter in FQXTrackedDockInteractions().allObjects) {
        if (inter.nativeDockActive) {
            BOOL showDetached = (inter.detachedHostIndex != NSNotFound && inter.detachedButton != nil);
            if (inter.proxy) {
                FQXSetDockMaterialOwner(inter.bar, inter.proxy, FQXDockMaterialOwnerNative, showDetached);
            }
            UITabBar *tabBar = inter.nativeDockBar;
            if (!tabBar) continue;
            UIUserInterfaceStyle desiredStyle = [inter desiredDockGlassStyle];
            if (inter.dockAppliedStyle != desiredStyle || tabBar.overrideUserInterfaceStyle != desiredStyle) {
                inter.dockAppliedStyle = desiredStyle;
                tabBar.overrideUserInterfaceStyle = desiredStyle;
                [tabBar layoutIfNeeded];
            }
            UIView *curPlatter = FQXFindDockPlatter(tabBar);
            if (curPlatter) {
                objc_setAssociatedObject(curPlatter, FQXPlatterAppliedStyleKey, nil, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
                static Class platterCls = Nil;
                static dispatch_once_t rmOnce;
                dispatch_once(&rmOnce, ^{ platterCls = NSClassFromString(@"UIKit._UITabBarPlatterView"); });
                if (platterCls && curPlatter.superview) {
                    for (UIView *sib in curPlatter.superview.subviews) {
                        if ([sib isKindOfClass:platterCls]) {
                            objc_setAssociatedObject(sib, FQXPlatterAppliedStyleKey, nil, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
                        }
                    }
                }
            }
            BOOL glassDark = (desiredStyle == UIUserInterfaceStyleDark);
            FQXApplyNativeDockMaterial(tabBar, curPlatter, glassDark);
            [inter syncDetachedDockMaterial:glassDark];
            [inter applyDockItemImages];
            [inter ensureDockZOrderInBar:inter.bar];
            FQXAuditVisibleDockGlassLayers(inter.bar, inter.proxy, tabBar, showDetached ? inter.detachedButton : nil);
        } else if (inter.proxy) {
            FQXSetDockMaterialOwner(inter.bar, inter.proxy, FQXDockMaterialOwnerProxy, NO);
            objc_setAssociatedObject(inter.proxy, FQXUnifiedClearDockKey, nil, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
            FQXApplyDockProxyMaterial(inter.bar, inter.proxy, inter.restingLens);
            FQXAuditVisibleDockGlassLayers(inter.bar, inter.proxy, nil, nil);
        }
    }
}

+ (void)refreshReaderHotCommentBadge {
    FQXInvalidateHotPrefsCache();
    FQXRefreshReaderHotCommentBadges();
}

+ (void)refreshShelfEditButton {
    FQXInvalidateHotPrefsCache();
    FQXRefreshAllShelfEditButtons();
    FQXRefreshAllShelfHeaderControls();
}

+ (void)refreshShelfHeaderControls {
    FQXInvalidateHotPrefsCache();
    FQXRefreshAllShelfHeaderControls();
}

+ (void)refreshMineSidebar {
    FQXInvalidateHotPrefsCache();
    FQXRefreshAllMineSidebars();
}

+ (void)refreshDynamicIsland {
    FQXInvalidateHotPrefsCache();
    FQXRefreshDynamicIslandState();
}

+ (void)compactMemory {
    FQXCompactRuntimeMemory();
}
@end

#pragma mark - Drama Spacing Immediate Sync on Navigation Transition & Crossfade

static void FQXTriggerDramaSpacingForControl(UIView *control, BOOL immediate) {
    if (![control isKindOfClass:UIView.class] || !control.window) return;
    [control setNeedsLayout];
    if (immediate) {
        [control layoutIfNeeded];
    }
    if ([objc_getAssociatedObject(control, DramaSpacingPendingKey) boolValue]) return;
    objc_setAssociatedObject(control, DramaSpacingPendingKey, @YES, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
    __weak UIView *weakControl = control;
    dispatch_async(dispatch_get_main_queue(), ^{
        UIView *strongControl = weakControl;
        if (!strongControl) return;
        objc_setAssociatedObject(strongControl, DramaSpacingPendingKey, nil, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
        if (strongControl.window) {
            [strongControl setNeedsLayout];
            [strongControl layoutIfNeeded];
        }
    });
}

static void FQXWalkDramaControlsInSubtree(UIView *root, Class c1, Class c2, Class c3, Class c4, BOOL immediate, NSInteger depth) {
    if (![root isKindOfClass:UIView.class] || depth > 12) return;
    if ((c1 && [root isKindOfClass:c1]) || (c2 && [root isKindOfClass:c2])) {
        FQXTriggerDramaSpacingForControl(root, immediate);
    } else if ((c3 && [root isKindOfClass:c3]) || (c4 && [root isKindOfClass:c4])) {
        [root setNeedsLayout];
        if (immediate) [root layoutIfNeeded];
    }
    for (UIView *sub in root.subviews) {
        FQXWalkDramaControlsInSubtree(sub, c1, c2, c3, c4, immediate, depth + 1);
    }
}

static void FQXRefreshDramaControllerControls(UIViewController *vc, BOOL immediate) {
    if (![vc isKindOfClass:UIViewController.class] || !vc.isViewLoaded) return;
    Class vPlayerCls = NSClassFromString(@"FQVShortVideoVPlayerControlView");
    Class outerCls = NSClassFromString(@"SSShortVideoOutterMultiGenreFeedControlView");
    Class distCls = NSClassFromString(@"SSShortVideoBottomDistributionView");
    Class albumCls = NSClassFromString(@"SSShortVideoAlbumSeriesBottomInsertView");
    FQXWalkDramaControlsInSubtree(vc.view, vPlayerCls, outerCls, distCls, albumCls, immediate, 0);
    id<UIViewControllerTransitionCoordinator> coord = vc.transitionCoordinator;
    if (coord) {
        __weak UIViewController *weakVC = vc;
        [coord animateAlongsideTransition:^(id<UIViewControllerTransitionCoordinatorContext> context) {
            (void)context;
            UIViewController *strongVC = weakVC;
            if (strongVC && strongVC.isViewLoaded) {
                FQXWalkDramaControlsInSubtree(strongVC.view, vPlayerCls, outerCls, distCls, albumCls, YES, 0);
            }
        } completion:^(id<UIViewControllerTransitionCoordinatorContext> context) {
            (void)context;
            UIViewController *strongVC = weakVC;
            if (strongVC && strongVC.isViewLoaded) {
                FQXWalkDramaControlsInSubtree(strongVC.view, vPlayerCls, outerCls, distCls, albumCls, YES, 0);
            }
        }];
    }
}

static void FQXRefreshAllDramaControlsInWindows(void) {
    Class vPlayerCls = NSClassFromString(@"FQVShortVideoVPlayerControlView");
    Class outerCls = NSClassFromString(@"SSShortVideoOutterMultiGenreFeedControlView");
    Class distCls = NSClassFromString(@"SSShortVideoBottomDistributionView");
    Class albumCls = NSClassFromString(@"SSShortVideoAlbumSeriesBottomInsertView");
    for (UIScene *scene in UIApplication.sharedApplication.connectedScenes) {
        if (![scene isKindOfClass:UIWindowScene.class]) continue;
        for (UIWindow *window in ((UIWindowScene *)scene).windows) {
            FQXWalkDramaControlsInSubtree(window, vPlayerCls, outerCls, distCls, albumCls, NO, 0);
        }
    }
}

static UIView *FQXEnclosingDramaControl(UIView *view) {
    Class vPlayerCls = NSClassFromString(@"FQVShortVideoVPlayerControlView");
    Class outerCls = NSClassFromString(@"SSShortVideoOutterMultiGenreFeedControlView");
    for (UIView *cur = view; cur; cur = cur.superview) {
        if ((vPlayerCls && [cur isKindOfClass:vPlayerCls]) ||
            (outerCls && [cur isKindOfClass:outerCls])) {
            return cur;
        }
    }
    return nil;
}

static void FQXNoteDramaControllerAppeared(UIViewController *vc);
static void FQXNoteDramaControllerWillDisappear(UIViewController *vc);
static void FQXNoteDramaPlayerReady(UIView *player, id engine);
static void FQXNoteDramaControlDisplayed(UIView *control);

static void (*OrigShortVideoListWillAppear)(id, SEL, BOOL);
static void HookShortVideoListWillAppear(UIViewController *self, SEL _cmd, BOOL animated) {
    if (OrigShortVideoListWillAppear) OrigShortVideoListWillAppear(self, _cmd, animated);
    FQXRefreshDramaControllerControls(self, YES);
    FQXNoteDramaControllerAppeared(self);
}

static void (*OrigShortVideoListDidAppear)(id, SEL, BOOL);
static void HookShortVideoListDidAppear(UIViewController *self, SEL _cmd, BOOL animated) {
    if (OrigShortVideoListDidAppear) OrigShortVideoListDidAppear(self, _cmd, animated);
    FQXRefreshDramaControllerControls(self, NO);
    FQXNoteDramaControllerAppeared(self);
}

static void (*OrigSeriesFeedWillAppear)(id, SEL, BOOL);
static void HookSeriesFeedWillAppear(UIViewController *self, SEL _cmd, BOOL animated) {
    if (OrigSeriesFeedWillAppear) OrigSeriesFeedWillAppear(self, _cmd, animated);
    FQXRefreshDramaControllerControls(self, YES);
    FQXNoteDramaControllerAppeared(self);
}

static void (*OrigSeriesFeedDidAppear)(id, SEL, BOOL);
static void HookSeriesFeedDidAppear(UIViewController *self, SEL _cmd, BOOL animated) {
    if (OrigSeriesFeedDidAppear) OrigSeriesFeedDidAppear(self, _cmd, animated);
    FQXRefreshDramaControllerControls(self, NO);
    FQXNoteDramaControllerAppeared(self);
}

static void (*OrigFeedContainerWillAppear)(id, SEL, BOOL);
static void HookFeedContainerWillAppear(UIViewController *self, SEL _cmd, BOOL animated) {
    if (OrigFeedContainerWillAppear) OrigFeedContainerWillAppear(self, _cmd, animated);
    FQXRefreshDramaControllerControls(self, YES);
}

static void (*OrigFeedContainerDidAppear)(id, SEL, BOOL);
static void HookFeedContainerDidAppear(UIViewController *self, SEL _cmd, BOOL animated) {
    if (OrigFeedContainerDidAppear) OrigFeedContainerDidAppear(self, _cmd, animated);
    FQXRefreshDramaControllerControls(self, NO);
}

static void (*OrigDistCrossfade)(id, SEL, dispatch_block_t);
static void HookDistCrossfade(UIView *self, SEL _cmd, dispatch_block_t renderBlock) {
    if (OrigDistCrossfade) OrigDistCrossfade(self, _cmd, renderBlock);
    UIView *control = FQXEnclosingDramaControl(self);
    if (control) FQXTriggerDramaSpacingForControl(control, NO);
}

#pragma mark - Highest available drama resolution

static BOOL FQXHighestQualityEnabled(void) {
    return [NSUserDefaults.standardUserDefaults boolForKey:HighestQualityPrefKey];
}

static NSString *FQXVideoID(id model) {
    id value = FQXObjGet(model, "videoId");
    return [value isKindOfClass:NSString.class] && [value length] ? value : nil;
}

static BOOL FQXUsesAutomaticHighest(id model) {
    if (!FQXHighestQualityEnabled() || ![model isKindOfClass:NSClassFromString(@"FQVShortVideoDataModel")]) return NO;
    NSString *videoID = FQXVideoID(model);
    return videoID && ![videoID isEqual:objc_getAssociatedObject(model, FQXManualResItemKey)] &&
           !FQXBoolGet(model, "isVideoLocked", NO) &&
           !FQXBoolGet(model, "useDownloadedEngineData", NO);
}

static NSNumber *FQXBestResolutionNumber(id videoModel, NSArray *playable) {
    id variants = FQXObjGet(videoModel, "supportedResolutionTypes");
    SEL selector = sel_registerName("videoInfoForType:");
    Method method = videoModel ? class_getInstanceMethod(object_getClass(videoModel), selector) : NULL;
    if (![variants isKindOfClass:NSArray.class] || !method ||
        strcmp(method_getTypeEncoding(method), "@24@0:8Q16") != 0) return nil;
    BOOL hasPlayableList = [playable isKindOfClass:NSArray.class] && playable.count > 0;
    NSNumber *best = nil;
    double bestPixels = 0;
    NSInteger bestBitrate = 0;
    for (id value in variants) {
        if (![value isKindOfClass:NSNumber.class] || (hasPlayableList && ![playable containsObject:value])) continue;
        id info = ((id (*)(id, SEL, NSUInteger))objc_msgSend)(videoModel, selector, [value unsignedIntegerValue]);
        if (![info isKindOfClass:NSClassFromString(@"TTVideoEngineURLInfo")]) continue;
        id width = FQXObjGet(info, "vWidth");
        id height = FQXObjGet(info, "vHeight");
        if (![width respondsToSelector:@selector(doubleValue)] || ![height respondsToSelector:@selector(doubleValue)]) continue;
        double w = [width doubleValue], h = [height doubleValue];
        double pixels = w * h;
        if (w <= 0 || h <= 0 || !isfinite(pixels)) continue;
        NSInteger bitrate = FQXIntGet(info, "bitrate", 0);
        if (pixels > bestPixels || (pixels == bestPixels && bitrate > bestBitrate)) {
            best = value;
            bestPixels = pixels;
            bestBitrate = bitrate;
        }
    }
    return best;
}

static id (*OrigResolutionWithModel)(id, SEL, id);
static id HookResolutionWithModel(id self, SEL cmd, id model) {
    if (FQXUsesAutomaticHighest(model)) {
        NSNumber *best = FQXBestResolutionNumber(FQXObjGet(FQXObjGet(model, "videoInfo"), "videoModel"), nil);
        if (best) return best;
    }
    return OrigResolutionWithModel(self, cmd, model);
}

static id (*OrigResolutionItemWithModel)(id, SEL, id);
static id HookResolutionItemWithModel(id self, SEL cmd, id model) {
    id item = OrigResolutionItemWithModel(self, cmd, model);
    if (item) {
        NSHashTable *reference = [NSHashTable weakObjectsHashTable];
        if (model) [reference addObject:model];
        objc_setAssociatedObject(item, FQXQualityModelKey, reference, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
    }
    return item;
}

static NSUInteger (*OrigFinalResolutionType)(id, SEL, id, id);
static NSUInteger HookFinalResolutionType(id self, SEL cmd, NSArray *supported, id videoModel) {
    id model = [objc_getAssociatedObject(self, FQXQualityModelKey) anyObject];
    id currentVideoModel = FQXObjGet(FQXObjGet(model, "videoInfo"), "videoModel");
    if (FQXUsesAutomaticHighest(model) && currentVideoModel && (!videoModel || currentVideoModel == videoModel)) {
        NSNumber *best = FQXBestResolutionNumber(currentVideoModel, supported);
        if (best) return best.unsignedIntegerValue;
    }
    return OrigFinalResolutionType(self, cmd, supported, videoModel);
}

static void (*OrigControlUpdateResolution)(id, SEL, id, id, id);
static void HookControlUpdateResolution(id self, SEL cmd, id model, id resolution, id finishBlock) {
    if (model && resolution)
        objc_setAssociatedObject(model, FQXManualResItemKey, FQXVideoID(model), OBJC_ASSOCIATION_COPY_NONATOMIC);
    OrigControlUpdateResolution(self, cmd, model, resolution, finishBlock);
}

static void (*OrigUpdatePlayerResolution)(id, SEL, id, id, id, id);
static void HookUpdatePlayerResolution(id self, SEL cmd, id player, id resolution, id model, id finish) {
    if (model && resolution && [objc_getAssociatedObject(self, FQXLandscapeQualityChoiceKey) boolValue])
        objc_setAssociatedObject(model, FQXManualResItemKey, FQXVideoID(model), OBJC_ASSOCIATION_COPY_NONATOMIC);
    OrigUpdatePlayerResolution(self, cmd, player, resolution, model, finish);
}

static void (*OrigLandscapeSelectResolution)(id, SEL, id);
static void HookLandscapeSelectResolution(id self, SEL cmd, id resolution) {
    id playerComponent = FQXObjGet(FQXObjGet(self, "listVCContext"), "playerComponent");
    if (!playerComponent) {
        OrigLandscapeSelectResolution(self, cmd, resolution);
        return;
    }
    id previous = objc_getAssociatedObject(playerComponent, FQXLandscapeQualityChoiceKey);
    objc_setAssociatedObject(playerComponent, FQXLandscapeQualityChoiceKey, @YES, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
    OrigLandscapeSelectResolution(self, cmd, resolution);
    objc_setAssociatedObject(playerComponent, FQXLandscapeQualityChoiceKey, previous, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

static void (*OrigPreparePlayerAsync)(id, SEL, id, id, BOOL);
static void HookPreparePlayerAsync(id self, SEL cmd, id player, id model, BOOL asyncFlag) {
    if (player) {
        NSHashTable *reference = [NSHashTable weakObjectsHashTable];
        if (model) [reference addObject:model];
        objc_setAssociatedObject(player, FQXQualityModelKey, reference, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
        objc_setAssociatedObject(player, FQXQualityAttemptKey, nil, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
    }
    OrigPreparePlayerAsync(self, cmd, player, model, asyncFlag);
}

static void (*OrigPlayerReadyToPlay)(id, SEL, id);
static void HookPlayerReadyToPlay(id player, SEL cmd, id engine) {
    OrigPlayerReadyToPlay(player, cmd, engine);
    if ([player isKindOfClass:UIView.class]) {
        FQXNoteDramaPlayerReady((UIView *)player, engine);
    }
    dispatch_block_t upgrade = ^{
        id model = [objc_getAssociatedObject(player, FQXQualityModelKey) anyObject];
        if (!FQXUsesAutomaticHighest(model) || engine != FQXObjGet(player, "videoEngine") ||
            ![FQXVideoID(model) isEqual:FQXObjGet(engine, "getVideoID")]) return;
        NSArray *supported = FQXObjGet(engine, "supportedResolutionTypes");
        if (![supported isKindOfClass:NSArray.class] || !supported.count) return;
        id videoModel = FQXObjGet(FQXObjGet(model, "videoInfo"), "videoModel");
        NSNumber *best = FQXBestResolutionNumber(videoModel, supported);
        if (!best || FQXIntGet(engine, "currentResolution", -1) == best.integerValue ||
            [best isEqual:objc_getAssociatedObject(player, FQXQualityAttemptKey)]) return;
        SEL selector = sel_registerName("configResolution:");
        Method method = class_getInstanceMethod(object_getClass(engine), selector);
        if (!method || strcmp(method_getTypeEncoding(method), "B24@0:8Q16") != 0) return;
        objc_setAssociatedObject(player, FQXQualityAttemptKey, best, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
        ((BOOL (*)(id, SEL, NSUInteger))objc_msgSend)(engine, selector, best.unsignedIntegerValue);
    };
    if (NSThread.isMainThread) upgrade();
    else dispatch_async(dispatch_get_main_queue(), upgrade);
}

#pragma mark - Inner Drama Episode 2 Bottom Black Mask Removal & Portrait Full-Canvas

static void FQXAudioClearBackground(UIView *view, BOOL clear);
static void FQXAudioSetUnclipped(UIView *view, BOOL unclip);

static void FQXFeatherDramaBottomGradientView(UIView *controlView) {
    if (![controlView isKindOfClass:UIView.class] || !FQXGlassEnabled()) return;
    UIView *gradView = FQXObjGet(controlView, "bottomGradientView");
    if (![gradView isKindOfClass:UIView.class]) return;
    CALayer *rawLayer = FQXObjGet(gradView, "gradientLayer") ?: gradView.layer;
    if (![rawLayer isKindOfClass:CAGradientLayer.class]) return;
    CAGradientLayer *grad = (CAGradientLayer *)rawLayer;
    NSArray *colors = grad.colors;
    if (colors.count < 2) return;
    if ([objc_getAssociatedObject(grad, FQXDramaFeatheredGradKey) isEqual:colors]) return;
    id clearCG = (id)UIColor.clearColor.CGColor;
    id midCG = colors.count == 2 ? colors[1] : colors[colors.count - 2];
    // Soften mid stop alpha so Episode 2's bottom area stays bright and feather to 0 at bottom edge.
    UIColor *midColor = [UIColor colorWithCGColor:(__bridge CGColorRef)midCG];
    CGFloat r = 0, g = 0, b = 0, a = 0;
    if ([midColor getRed:&r green:&g blue:&b alpha:&a] && a > 0.32) {
        midCG = (id)[UIColor colorWithRed:r green:g blue:b alpha:0.28].CGColor;
    }
    NSArray *feathered = @[clearCG, midCG, clearCG];
    [CATransaction begin];
    [CATransaction setDisableActions:YES];
    grad.colors = feathered;
    grad.locations = @[@0.0, @0.84, @1.0];
    [CATransaction commit];
    objc_setAssociatedObject(grad, FQXDramaFeatheredGradKey, feathered, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

static BOOL FQXIsSeriesDetailControl(UIView *control) {
    if (![control isKindOfClass:UIView.class]) return NO;
    Class seriesCls = NSClassFromString(@"FQVShortVideoVPlayerSeriesControlView");
    Class singleCls = NSClassFromString(@"FQVShortVideoVPlayerSingleSeriesControlView");
    return (seriesCls && [control isKindOfClass:seriesCls]) ||
           (singleCls && [control isKindOfClass:singleCls]);
}

static UIView *FQXSeriesDetailBottomDock(UIView *control) {
    if (![control isKindOfClass:UIView.class]) return nil;
    UIView *single = FQXObjGet(control, "singleSeriesBottomView");
    if ([single isKindOfClass:UIView.class] && !single.hidden && single.window) return single;
    UIView *newInfo = FQXObjGet(control, "episodeNewInfoView");
    if ([newInfo isKindOfClass:UIView.class] && !newInfo.hidden && newInfo.window) return newInfo;
    UIView *bottom = FQXObjGet(control, "bottomView");
    if ([bottom isKindOfClass:UIView.class] && !bottom.hidden && bottom.window) return bottom;
    return single ?: newInfo ?: bottom;
}

static void FQXClearDramaBottomInsertMask(UIView *view) {
    if (![view isKindOfClass:UIView.class]) return;
    BOOL enabled = FQXGlassEnabled();
    FQXAudioClearBackground(view, enabled);
    UIView *container = FQXObjGet(view, "bottomContainerView");
    if ([container isKindOfClass:UIView.class]) {
        FQXAudioClearBackground(container, enabled);
    }
    UIView *parent = view.superview;
    if ([parent isKindOfClass:UIView.class]) {
        NSString *parentCls = NSStringFromClass(parent.class);
        if ([parentCls containsString:@"Bottom"] || [parentCls containsString:@"Insert"]) {
            FQXAudioClearBackground(parent, enabled);
        }
    }
    UIView *control = FQXEnclosingDramaControl(view);
    if (control) {
        UIView *bottomView = FQXObjGet(control, "bottomView");
        if ([bottomView isKindOfClass:UIView.class]) FQXAudioClearBackground(bottomView, enabled);
        UIView *singleBottom = FQXObjGet(control, "singleSeriesBottomView");
        if ([singleBottom isKindOfClass:UIView.class]) FQXAudioClearBackground(singleBottom, enabled);
        UIView *newInfo = FQXObjGet(control, "episodeNewInfoView");
        if ([newInfo isKindOfClass:UIView.class]) FQXAudioClearBackground(newInfo, enabled);
        if (FQXIsSeriesDetailControl(control)) {
            FQXAudioClearBackground(FQXObjGet(control, "playerContainerMaskView"), enabled);
            FQXAudioClearBackground(FQXObjGet(control, "bottomGradientView"), enabled);
        }
        FQXFeatherDramaBottomGradientView(control);
    }
}

static CGSize FQXExpandPortraitCanvasSize(CGSize stock) {
    if (!FQXGlassEnabled() || stock.width <= 0.0 || stock.height <= stock.width) return stock;
    CGRect screen = UIScreen.mainScreen.bounds;
    CGFloat screenW = MIN(screen.size.width, screen.size.height);
    CGFloat screenH = MAX(screen.size.width, screen.size.height);
    if (screenH <= screenW) return stock;
    CGFloat diff = screenH - stock.height;
    if (fabs(stock.width - screenW) <= 2.0 && stock.height >= screenH * 0.68 &&
        diff >= 24.0 && diff <= 180.0) {
        stock.height = screenH;
    }
    return stock;
}

static CGRect FQXExpandPortraitCanvasRect(CGRect stock) {
    if (!FQXGlassEnabled() || stock.size.width <= 0.0 || stock.size.height <= stock.size.width) return stock;
    CGRect screen = UIScreen.mainScreen.bounds;
    CGFloat screenW = MIN(screen.size.width, screen.size.height);
    CGFloat screenH = MAX(screen.size.width, screen.size.height);
    if (screenH <= screenW) return stock;
    CGFloat maxY = CGRectGetMaxY(stock);
    CGFloat diff = screenH - maxY;
    if (stock.origin.y <= 4.0 && stock.size.width >= screenW - 2.0 &&
        stock.size.height >= screenH * 0.68 && diff >= 24.0 && diff <= 180.0) {
        CGFloat targetH = screenH - stock.origin.y;
        CGFloat targetW = stock.size.width * (targetH / stock.size.height);
        return CGRectMake((screenW - targetW) * 0.5, stock.origin.y, targetW, targetH);
    }
    return stock;
}

static CGSize (*OrigPlayerViewSizeWithModel)(id, SEL, id);
static CGSize HookPlayerViewSizeWithModel(id self, SEL _cmd, id model) {
    CGSize stock = OrigPlayerViewSizeWithModel ? OrigPlayerViewSizeWithModel(self, _cmd, model) : CGSizeZero;
    return FQXExpandPortraitCanvasSize(stock);
}

static CGSize (*OrigScaleAspectFitPlayerViewSizeWithModel)(id, SEL, id);
static CGSize HookScaleAspectFitPlayerViewSizeWithModel(id self, SEL _cmd, id model) {
    CGSize stock = OrigScaleAspectFitPlayerViewSizeWithModel
        ? OrigScaleAspectFitPlayerViewSizeWithModel(self, _cmd, model) : CGSizeZero;
    return FQXExpandPortraitCanvasSize(stock);
}

static CGRect (*OrigPortraitPlayerViewFrameWithModel)(id, SEL, id);
static CGRect HookPortraitPlayerViewFrameWithModel(id self, SEL _cmd, id model) {
    CGRect stock = OrigPortraitPlayerViewFrameWithModel
        ? OrigPortraitPlayerViewFrameWithModel(self, _cmd, model) : CGRectZero;
    return FQXExpandPortraitCanvasRect(stock);
}

static CGRect (*OrigScaleAspectFitContainerViewFrameWithModel)(id, SEL, id);
static CGRect HookScaleAspectFitContainerViewFrameWithModel(id self, SEL _cmd, id model) {
    CGRect stock = OrigScaleAspectFitContainerViewFrameWithModel
        ? OrigScaleAspectFitContainerViewFrameWithModel(self, _cmd, model) : CGRectZero;
    return FQXExpandPortraitCanvasRect(stock);
}

static CGFloat (*OrigMaxPlayerViewHeightWithModel)(id, SEL, id);
static CGFloat HookMaxPlayerViewHeightWithModel(id self, SEL _cmd, id model) {
    CGFloat stock = OrigMaxPlayerViewHeightWithModel ? OrigMaxPlayerViewHeightWithModel(self, _cmd, model) : 0.0;
    if (!FQXGlassEnabled() || stock <= 0.0) return stock;
    CGRect screen = UIScreen.mainScreen.bounds;
    CGFloat screenW = MIN(screen.size.width, screen.size.height);
    CGFloat screenH = MAX(screen.size.width, screen.size.height);
    CGFloat diff = screenH - stock;
    if (stock > screenW && diff >= 24.0 && diff <= 180.0) {
        return screenH;
    }
    return stock;
}

static void (*OrigBottomInsertSetup)(id, SEL);
static void HookBottomInsertSetup(UIView *self, SEL _cmd) {
    if (OrigBottomInsertSetup) OrigBottomInsertSetup(self, _cmd);
    FQXClearDramaBottomInsertMask(self);
}

static void (*OrigBottomInsertResize)(id, SEL);
static void HookBottomInsertResize(UIView *self, SEL _cmd) {
    if (OrigBottomInsertResize) OrigBottomInsertResize(self, _cmd);
    FQXClearDramaBottomInsertMask(self);
}

static void (*OrigSingleBottomInsertSetup)(id, SEL);
static void HookSingleBottomInsertSetup(UIView *self, SEL _cmd) {
    if (OrigSingleBottomInsertSetup) OrigSingleBottomInsertSetup(self, _cmd);
    FQXClearDramaBottomInsertMask(self);
}

static void (*OrigPlayerBottomViewSetup)(id, SEL);
static void HookPlayerBottomViewSetup(UIView *self, SEL _cmd) {
    if (OrigPlayerBottomViewSetup) OrigPlayerBottomViewSetup(self, _cmd);
    FQXClearDramaBottomInsertMask(self);
}

static void FQXCleanSeriesControlBottom(UIView *control) {
    BOOL enabled = FQXGlassEnabled();
    if (![control isKindOfClass:UIView.class]) return;
    FQXAudioClearBackground(control, enabled);
    FQXAudioClearBackground(FQXObjGet(control, "playerContainerMaskView"), enabled);
    FQXAudioClearBackground(FQXObjGet(control, "recoverMaskView"), enabled);
    UIView *singleBottom = FQXObjGet(control, "singleSeriesBottomView");
    if ([singleBottom isKindOfClass:UIView.class]) FQXClearDramaBottomInsertMask(singleBottom);
    UIView *newInfo = FQXObjGet(control, "episodeNewInfoView");
    if ([newInfo isKindOfClass:UIView.class]) FQXClearDramaBottomInsertMask(newInfo);
    UIView *bottomView = FQXObjGet(control, "bottomView");
    if ([bottomView isKindOfClass:UIView.class]) FQXClearDramaBottomInsertMask(bottomView);
    FQXFeatherDramaBottomGradientView(control);
}

static void (*OrigSeriesSetupSingleBottom)(id, SEL);
static void HookSeriesSetupSingleBottom(UIView *self, SEL _cmd) {
    if (OrigSeriesSetupSingleBottom) OrigSeriesSetupSingleBottom(self, _cmd);
    FQXCleanSeriesControlBottom(self);
}

static void (*OrigSingleSeriesSetupSingleBottom)(id, SEL);
static void HookSingleSeriesSetupSingleBottom(UIView *self, SEL _cmd) {
    if (OrigSingleSeriesSetupSingleBottom) OrigSingleSeriesSetupSingleBottom(self, _cmd);
    FQXCleanSeriesControlBottom(self);
}

static CGRect FQXDramaCanvasStock(UIView *view) {
    NSValue *old = objc_getAssociatedObject(view, DramaCanvasStockKey);
    NSValue *applied = objc_getAssociatedObject(view, DramaCanvasAppliedKey);
    return old && applied && CGRectEqualToRect(view.frame, applied.CGRectValue)
        ? old.CGRectValue : view.frame;
}

static void FQXSetDramaCanvasFrame(UIView *view, CGRect stock, CGRect target) {
    if (!view) return;
    if (!CGRectEqualToRect(view.frame, target)) view.frame = target;
    if (CGRectEqualToRect(stock, target)) {
        objc_setAssociatedObject(view, DramaCanvasStockKey, nil, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
        objc_setAssociatedObject(view, DramaCanvasAppliedKey, nil, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
    } else {
        objc_setAssociatedObject(view, DramaCanvasStockKey, [NSValue valueWithCGRect:stock], OBJC_ASSOCIATION_RETAIN_NONATOMIC);
        objc_setAssociatedObject(view, DramaCanvasAppliedKey, [NSValue valueWithCGRect:target], OBJC_ASSOCIATION_RETAIN_NONATOMIC);
    }
}

static void FQXAudioSetHiddenTracked(UIView *view, BOOL hide);

static void FQXUpdateSeriesRenderCanvas(UIView *player) {
    if (![player isKindOfClass:UIView.class]) return;
    UIView *control = FQXObjGet(player, "portraitControlView");
    BOOL detail = FQXIsSeriesDetailControl(control);
    if (!detail && !objc_getAssociatedObject(FQXObjGet(player, "playerView"), DramaCanvasStockKey)) return;
    UIView *render = FQXObjGet(player, "playerView");
    UIView *container = FQXObjGet(player, "playerViewContainerView");
    UIView *parent = container.superview;
    UIWindow *window = player.window;
    UIView *cellView = nil;
    Class cellCls = NSClassFromString(@"FQVShortVideoPlayerCellView");
    for (UIView *cur = player.superview; cur; cur = cur.superview) {
        if (cellCls && [cur isKindOfClass:cellCls]) {
            cellView = cur;
            break;
        }
    }
    UIView *playerSuper = FQXObjGet(cellView, "playerSuperView");
    CGRect stockRender = FQXDramaCanvasStock(render), stockContainer = FQXDramaCanvasStock(container);
    CGRect stockPlayer = FQXDramaCanvasStock(player);
    CGRect stockPlayerSuper = playerSuper ? FQXDramaCanvasStock(playerSuper) : CGRectZero;
    CGRect targetRender = stockRender, targetContainer = stockContainer;
    CGRect targetPlayer = stockPlayer, targetPlayerSuper = stockPlayerSuper;
    BOOL expanded = NO;
    UIView *bottom = FQXSeriesDetailBottomDock(control);
    if (detail && FQXGlassEnabled() && window && bottom && bottom.window == window && !bottom.hidden &&
        render && render.superview == container && parent) {
        CGRect screen = window.bounds;
        CGRect viewport = [player convertRect:player.bounds toView:window];
        CGRect picture = [container convertRect:stockRender toView:window];
        CGRect dock = [bottom convertRect:bottom.bounds toView:window];
        CGFloat end = CGRectGetMaxY(screen);
        CGFloat gap = end - CGRectGetMaxY(picture);
        if (CGRectGetHeight(screen) > CGRectGetWidth(screen) &&
            CGRectGetWidth(viewport) >= CGRectGetWidth(screen) - 2.0 &&
            CGRectGetWidth(picture) >= CGRectGetWidth(viewport) - 2.0 &&
            CGRectGetHeight(picture) >= CGRectGetHeight(screen) * 0.68 &&
            CGRectGetHeight(picture) > CGRectGetWidth(picture) && gap > 1.0 && gap < 180.0 &&
            CGRectGetMaxY(dock) >= CGRectGetMaxY(picture) - 2.0 &&
            CGRectGetMinY(dock) >= CGRectGetMaxY(picture) - 52.0) {
            CGFloat localBottom = [window convertPoint:CGPointMake(0.0, end) toView:container].y;
            CGFloat height = localBottom - CGRectGetMinY(stockRender);
            CGFloat width = CGRectGetWidth(stockRender) * height / CGRectGetHeight(stockRender);
            targetRender = CGRectMake(CGRectGetMidX(stockRender) - width * 0.5,
                                      CGRectGetMinY(stockRender), width, height);
            CGFloat parentBottom = [window convertPoint:CGPointMake(0.0, end) toView:parent].y;
            targetContainer.size.height = MAX(CGRectGetHeight(stockContainer), parentBottom - CGRectGetMinY(stockContainer));
            if (player.superview) {
                CGFloat playerBottom = [window convertPoint:CGPointMake(0.0, end) toView:player.superview].y;
                targetPlayer.size.height = MAX(CGRectGetHeight(stockPlayer), playerBottom - CGRectGetMinY(stockPlayer));
            }
            if (playerSuper && playerSuper.superview) {
                CGFloat superBottom = [window convertPoint:CGPointMake(0.0, end) toView:playerSuper.superview].y;
                targetPlayerSuper.size.height = MAX(CGRectGetHeight(stockPlayerSuper), superBottom - CGRectGetMinY(stockPlayerSuper));
            }
            expanded = YES;
        }
    }
    FQXAudioSetUnclipped(player, expanded);
    FQXAudioSetUnclipped(player.superview, expanded);
    FQXAudioSetUnclipped(container, expanded);
    FQXAudioSetUnclipped(parent, expanded);
    FQXAudioSetUnclipped(playerSuper, expanded);
    FQXAudioClearBackground(FQXObjGet(player, "playerViewMaskView"), detail && FQXGlassEnabled());
    if (detail) {
        FQXCleanSeriesControlBottom(control);
        if (cellView) {
            FQXAudioClearBackground(FQXObjGet(cellView, "playerScaleBackgroundView"), FQXGlassEnabled());
            FQXAudioSetHiddenTracked(FQXObjGet(cellView, "leftBottomCorRadiusImageView"), expanded);
            FQXAudioSetHiddenTracked(FQXObjGet(cellView, "rightBottomCorRadiusImageView"), expanded);
        }
    }
    if (playerSuper) FQXSetDramaCanvasFrame(playerSuper, stockPlayerSuper, targetPlayerSuper);
    FQXSetDramaCanvasFrame(player, stockPlayer, targetPlayer);
    FQXSetDramaCanvasFrame(container, stockContainer, targetContainer);
    FQXSetDramaCanvasFrame(render, stockRender, targetRender);
}

static void (*OrigPlayerCanvasLayout)(id, SEL);
static void HookPlayerCanvasLayout(UIView *self, SEL cmd) {
    OrigPlayerCanvasLayout(self, cmd);
    FQXUpdateSeriesRenderCanvas(self);
}

static void (*OrigSeriesBottomAlpha)(id, SEL, CGFloat);
static void HookSeriesBottomAlpha(UIView *control, SEL cmd, CGFloat alpha) {
    OrigSeriesBottomAlpha(control, cmd, alpha);
    FQXCleanSeriesControlBottom(control);
}

static void (*OrigSingleSeriesBottomAlpha)(id, SEL, CGFloat);
static void HookSingleSeriesBottomAlpha(UIView *control, SEL cmd, CGFloat alpha) {
    OrigSingleSeriesBottomAlpha(control, cmd, alpha);
    FQXCleanSeriesControlBottom(control);
}

static void (*OrigPlayerCanvasRefresh)(id, SEL);
static void HookPlayerCanvasRefresh(UIView *self, SEL cmd) {
    OrigPlayerCanvasRefresh(self, cmd);
    FQXUpdateSeriesRenderCanvas(self);
}

static void (*OrigCellLayoutVideoView)(id, SEL);
static void HookCellLayoutVideoView(UIView *cell, SEL cmd) {
    OrigCellLayoutVideoView(cell, cmd);
    FQXUpdateSeriesRenderCanvas(FQXObjGet(cell, "vPlayer"));
}

static void (*OrigCellRefreshPlayFrame)(id, SEL, CGRect);
static void HookCellRefreshPlayFrame(UIView *cell, SEL cmd, CGRect frame) {
    OrigCellRefreshPlayFrame(cell, cmd, frame);
    FQXUpdateSeriesRenderCanvas(FQXObjGet(cell, "vPlayer"));
}

static void (*OrigCellUpdatePlayerSuperLayout)(id, SEL);
static void HookCellUpdatePlayerSuperLayout(UIView *cell, SEL cmd) {
    OrigCellUpdatePlayerSuperLayout(cell, cmd);
    FQXUpdateSeriesRenderCanvas(FQXObjGet(cell, "vPlayer"));
}

static void (*OrigCellRefreshPlayerSuperSize)(id, SEL, CGSize);
static void HookCellRefreshPlayerSuperSize(UIView *cell, SEL cmd, CGSize size) {
    OrigCellRefreshPlayerSuperSize(cell, cmd, size);
    FQXUpdateSeriesRenderCanvas(FQXObjGet(cell, "vPlayer"));
}

#pragma mark - TikTok-Style Two-Finger Spread/Pinch Pure Clean Screen

static BOOL FQXPinchPureCleanEnabled(void) {
    return [NSUserDefaults.standardUserDefaults boolForKey:PinchPureCleanPrefKey];
}

static BOOL FQXPinchHapticEnabled(void) {
    id stored = [NSUserDefaults.standardUserDefaults objectForKey:PinchHapticPrefKey];
    return stored ? [stored boolValue] : YES;
}

static NSHashTable<UIView *> *FQXPinchCleanControls(void) {
    static NSHashTable<UIView *> *table;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        table = [NSHashTable weakObjectsHashTable];
    });
    return table;
}

@interface FQXPinchCleanViewState : NSObject
@property(nonatomic, strong) CALayer *mask;
@property(nonatomic, strong) CALayer *originalMask;
@property(nonatomic) BOOL interactive;
@end

@implementation FQXPinchCleanViewState
@end

static void FQXHideViewForPinchClean(UIView *view, NSMapTable<UIView *, FQXPinchCleanViewState *> *views) {
    if (![view isKindOfClass:UIView.class] || !view.window || view.hidden ||
        view.alpha == 0.0 || [views objectForKey:view]) return;
    FQXPinchCleanViewState *state = [FQXPinchCleanViewState new];
    state.originalMask = view.layer.mask;
    state.mask = [CALayer layer];
    state.mask.frame = CGRectZero;
    state.interactive = view.userInteractionEnabled;
    [views setObject:state forKey:view];
    // The Dock layout uses hidden and alpha to decide whether to tear down the renderer.
    view.layer.mask = state.mask;
    view.userInteractionEnabled = NO;
}

static UIView *FQXFindDramaDockForControl(UIView *control) {
    Class tabBarControllerCls = NSClassFromString(@"SSTabBarController");
    Class tabBarCls = NSClassFromString(@"SSTabBar");
    for (UIResponder *resp = control.nextResponder; resp; resp = resp.nextResponder) {
        if (tabBarControllerCls && [resp isKindOfClass:tabBarControllerCls]) {
            UIViewController *tbc = (UIViewController *)resp;
            UIViewController *selVC = FQXObjGet(tbc, "selectedViewController");
            UIView *selView = selVC.viewIfLoaded;
            BOOL owns = NO;
            for (UIView *cur = control; cur; cur = cur.superview) {
                if (cur == selView) { owns = YES; break; }
            }
            if (owns) {
                UIView *bar = FQXObjGet(tbc, "customTabBar");
                if (tabBarCls && [bar isKindOfClass:tabBarCls]) return bar;
            }
            break;
        }
    }
    return nil;
}

static void FQXApplyPinchPureCleanState(UIView *control, BOOL enterClean) {
    if (![control isKindOfClass:UIView.class]) return;

    if (enterClean) {
        objc_setAssociatedObject(control, FQXPinchPureCleanActiveKey, @YES, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
        NSMapTable<UIView *, FQXPinchCleanViewState *> *hiddenSet = objc_getAssociatedObject(control, FQXPinchHiddenViewsKey);
        if (!hiddenSet) {
            hiddenSet = [NSMapTable weakToStrongObjectsMapTable];
            objc_setAssociatedObject(control, FQXPinchHiddenViewsKey, hiddenSet, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
        }

        Class outerCls = NSClassFromString(@"SSShortVideoOutterMultiGenreFeedControlView");
        if (outerCls && [control isKindOfClass:outerCls]) {
            // Use mounted ivars so clean-screen entry does not create controls through lazy getters.
            const char *outerIvars[] = {
                "_aboveProgressView", "_progressView", "_baseInfoView", "_bookCardView",
                "_progressFloatView", "_playBtn", "_topGradientView", "_bottomGradientView"
            };
            for (size_t i = 0; i < sizeof(outerIvars) / sizeof(*outerIvars); ++i) {
                FQXHideViewForPinchClean(FQXRawIvarObj(control, outerIvars[i]), hiddenSet);
            }
        } else {
            const char *vPlayerKeys[] = {
                "baseInfoView", "topGradientView", "bottomGradientView",
                "playBtn", "muteBtnView", "fullscreenBtn",
                "progressContainer", "progressFloatView", "bottomView",
                "singleSeriesBottomView", "insertAboveProgressView",
                "insertBelowVideoInfoContainerView", "insertAboveTopControlView",
                "fastPlayTipView", "bottomFastPlayTipView",
                "resolutionTipsView", "playRateTipsView",
                "cleanScreenModeRightInteractionView", "cleanScreenModeRightInteractionSubView",
                "cancelCleanScreenView"
            };
            for (size_t i = 0; i < sizeof(vPlayerKeys) / sizeof(vPlayerKeys[0]); ++i) {
                FQXHideViewForPinchClean(FQXObjGet(control, vPlayerKeys[i]), hiddenSet);
            }
        }

        id hostContext = FQXObjGet(control, "hostContext");
        id context = FQXObjGet(control, "listVCContext") ?: FQXObjGet(hostContext, "listVCContext");
        id navBarComp = context ? FQXObjGet(context, "navBarComponent") : nil;
        FQXHideViewForPinchClean(navBarComp ? FQXObjGet(navBarComp, "navBar") : nil, hiddenSet);
        FQXHideViewForPinchClean(FQXObjGet(hostContext, "currentTabHeaderView"), hiddenSet);

        Class seriesFeedCls = NSClassFromString(@"SSVideoSeriesFeedViewController");
        for (UIResponder *resp = control.nextResponder; resp; resp = resp.nextResponder) {
            if (seriesFeedCls && [resp isKindOfClass:seriesFeedCls]) {
                FQXHideViewForPinchClean(FQXObjGet(resp, "headerView"), hiddenSet);
                break;
            }
        }
        FQXHideViewForPinchClean(FQXFindDramaDockForControl(control), hiddenSet);
    } else {
        objc_setAssociatedObject(control, FQXPinchPureCleanActiveKey, nil, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
        NSMapTable<UIView *, FQXPinchCleanViewState *> *hiddenSet = objc_getAssociatedObject(control, FQXPinchHiddenViewsKey);
        objc_setAssociatedObject(control, FQXPinchHiddenViewsKey, nil, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
        for (UIView *view in hiddenSet.keyEnumerator.allObjects) {
            FQXPinchCleanViewState *state = [hiddenSet objectForKey:view];
            if (view.layer.mask == state.mask) view.layer.mask = state.originalMask;
            if (![objc_getAssociatedObject(view, FQXDockHiddenByCommentKey) boolValue]) {
                view.userInteractionEnabled = state.interactive;
            }
        }
    }
}

static void FQXResetPinchCleanStates(void) {
    for (UIView *control in FQXPinchCleanControls().allObjects) {
        if ([objc_getAssociatedObject(control, FQXPinchPureCleanActiveKey) boolValue]) {
            FQXApplyPinchPureCleanState(control, NO);
        }
    }
}

static void FQXRefreshAllPinchCleanStates(void) {
    if (!FQXPinchPureCleanEnabled()) FQXResetPinchCleanStates();
}

@interface FQXDramaPinchGestureRecognizer : UIPinchGestureRecognizer
@end
@implementation FQXDramaPinchGestureRecognizer
- (BOOL)canBePreventedByGestureRecognizer:(UIGestureRecognizer *)other {
    if ([other isKindOfClass:UIPanGestureRecognizer.class] ||
        [other isKindOfClass:UILongPressGestureRecognizer.class]) return NO;
    return [super canBePreventedByGestureRecognizer:other];
}
@end

static BOOL FQXDramaPinchConflicts(UIGestureRecognizer *gesture) {
    if (!FQXPinchPureCleanEnabled()) return NO;
    UIWindow *window = gesture.view.window;
    if (!window || CGRectGetHeight(window.bounds) <= CGRectGetWidth(window.bounds)) return NO;
    for (UIView *control in FQXPinchCleanControls()) {
        if (control.window != window ||
            (![control isDescendantOfView:gesture.view] && ![gesture.view isDescendantOfView:control])) continue;
        UIGestureRecognizer *pinch = objc_getAssociatedObject(control, FQXPinchRecognizerKey);
        if (pinch.numberOfTouches >= 2 || pinch.state == UIGestureRecognizerStateBegan ||
            pinch.state == UIGestureRecognizerStateChanged) return YES;
    }
    return NO;
}

@interface FQXDramaPinchHandler : NSObject <UIGestureRecognizerDelegate>
+ (instancetype)shared;
@property(nonatomic, strong) UIImpactFeedbackGenerator *haptic;
- (void)prepareHaptic;
- (void)handlePinch:(FQXDramaPinchGestureRecognizer *)pinch;
@end

@implementation FQXDramaPinchHandler
+ (instancetype)shared {
    static FQXDramaPinchHandler *instance;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        instance = [FQXDramaPinchHandler new];
    });
    return instance;
}

- (BOOL)gestureRecognizerShouldBegin:(UIGestureRecognizer *)gestureRecognizer {
    if (!FQXPinchPureCleanEnabled()) return NO;
    UIView *view = gestureRecognizer.view;
    if (!view || !view.window || gestureRecognizer.numberOfTouches < 2) return NO;
    CGRect winBounds = view.window.bounds;
    if (winBounds.size.height <= winBounds.size.width) return NO;
    id player = FQXObjGet(view, "vPlayer");
    if (player && FQXBoolGet(player, "isFullScreen", NO)) return NO;
    return YES;
}

- (BOOL)gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer
shouldRecognizeSimultaneouslyWithGestureRecognizer:(UIGestureRecognizer *)otherGestureRecognizer {
    (void)gestureRecognizer;
    (void)otherGestureRecognizer;
    return NO;
}

- (void)prepareHaptic {
    if (!self.haptic) self.haptic = [[UIImpactFeedbackGenerator alloc] initWithStyle:UIImpactFeedbackStyleLight];
    [self.haptic prepare];
}

- (void)triggerHaptic {
    if (!FQXPinchHapticEnabled()) return;
    [self.haptic impactOccurred];
}

- (void)handlePinch:(FQXDramaPinchGestureRecognizer *)pinch {
    UIView *control = pinch.view;
    if (pinch.state == UIGestureRecognizerStateBegan && FQXPinchHapticEnabled()) {
        [self prepareHaptic];
    }
    if (pinch.state != UIGestureRecognizerStateEnded || !control.window || !FQXPinchPureCleanEnabled()) return;
    BOOL clean = [objc_getAssociatedObject(control, FQXPinchPureCleanActiveKey) boolValue];
    BOOL spread = pinch.scale >= 1.10 || (pinch.scale > 1.03 && pinch.velocity > 0.35);
    BOOL shrink = pinch.scale <= 0.90 || (pinch.scale < 0.97 && pinch.velocity < -0.35);
    if ((!clean && spread) || (clean && shrink)) {
        __weak UIView *weakControl = control;
        UIWindow *window = control.window;
        id model = FQXObjGet(control, "contentModel");
        dispatch_async(dispatch_get_main_queue(), ^{
            UIView *current = weakControl;
            if (current.window != window || !FQXPinchPureCleanEnabled() ||
                FQXObjGet(current, "contentModel") != model ||
                [objc_getAssociatedObject(current, FQXPinchPureCleanActiveKey) boolValue] != clean) return;
            [CATransaction begin];
            [CATransaction setDisableActions:YES];
            FQXApplyPinchPureCleanState(current, !clean);
            [CATransaction commit];
            [self triggerHaptic];
        });
    }
}
@end

static void FQXAttachDramaPinchIfNeeded(UIView *control) {
    if (![control isKindOfClass:UIView.class]) return;
    FQXDramaPinchGestureRecognizer *existing = objc_getAssociatedObject(control, FQXPinchRecognizerKey);
    if (existing && existing.view == control) return;
    FQXDramaPinchGestureRecognizer *pinch = [[FQXDramaPinchGestureRecognizer alloc]
        initWithTarget:[FQXDramaPinchHandler shared]
                action:@selector(handlePinch:)];
    pinch.cancelsTouchesInView = YES;
    pinch.delaysTouchesBegan = NO;
    pinch.delaysTouchesEnded = NO;
    pinch.delegate = [FQXDramaPinchHandler shared];
    [control addGestureRecognizer:pinch];
    FQXDramaPinchHandler *handler = [FQXDramaPinchHandler shared];
    if (control.window && !handler.haptic && FQXPinchPureCleanEnabled() && FQXPinchHapticEnabled()) {
        [handler prepareHaptic];
    }
    [FQXPinchCleanControls() addObject:control];
    objc_setAssociatedObject(control, FQXPinchRecognizerKey, pinch, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

static void (*OrigVPlayerSetupGestures)(id, SEL);
static void HookVPlayerSetupGestures(UIView *self, SEL _cmd) {
    if (OrigVPlayerSetupGestures) OrigVPlayerSetupGestures(self, _cmd);
    FQXAttachDramaPinchIfNeeded(self);
}

static void (*OrigVPlayerWillDisplay)(id, SEL);
static void HookVPlayerWillDisplay(UIView *self, SEL _cmd) {
    if (OrigVPlayerWillDisplay) OrigVPlayerWillDisplay(self, _cmd);
    FQXAttachDramaPinchIfNeeded(self);
    FQXFeatherDramaBottomGradientView(self);
    FQXNoteDramaControlDisplayed(self);
}

static void (*OrigVPlayerWillEndDisplay)(id, SEL);
static void HookVPlayerWillEndDisplay(UIView *self, SEL _cmd) {
    if ([objc_getAssociatedObject(self, FQXPinchPureCleanActiveKey) boolValue]) {
        FQXApplyPinchPureCleanState(self, NO);
    }
    if (OrigVPlayerWillEndDisplay) OrigVPlayerWillEndDisplay(self, _cmd);
}

static void (*OrigVPlayerUpdateControlState)(id, SEL);
static void HookVPlayerUpdateControlState(UIView *self, SEL _cmd) {
    if (OrigVPlayerUpdateControlState) OrigVPlayerUpdateControlState(self, _cmd);
    if ([objc_getAssociatedObject(self, FQXPinchPureCleanActiveKey) boolValue]) {
        FQXApplyPinchPureCleanState(self, YES);
    }
}

static BOOL FQXDoubleTapCommentEnabled(void) {
    return [NSUserDefaults.standardUserDefaults boolForKey:DoubleTapCommentPrefKey];
}

static UIView *FQXFindDramaCommentView(UIView *root, NSInteger depth) {
    if (![root isKindOfClass:UIView.class] || depth > 8) return nil;
    Class c1 = NSClassFromString(@"SSShortVideoRightInteractionCommentView");
    Class c2 = NSClassFromString(@"SSShortVideoHostRightInteractionCommentView");
    if ((c1 && [root isKindOfClass:c1]) || (c2 && [root isKindOfClass:c2])) return root;
    for (UIView *sub in root.subviews) {
        UIView *found = FQXFindDramaCommentView(sub, depth + 1);
        if (found) return found;
    }
    return nil;
}

static BOOL FQXTriggerDramaCommentFromControl(UIView *control) {
    if (![control isKindOfClass:UIView.class]) return NO;
    UIView *commentView = FQXFindDramaCommentView(control, 0);
    if (!commentView) {
        Class cellCls = NSClassFromString(@"FQVShortVideoPlayerCellView");
        for (UIView *cur = control.superview; cur; cur = cur.superview) {
            if ((cellCls && [cur isKindOfClass:cellCls]) || [cur isKindOfClass:UICollectionViewCell.class]) {
                commentView = FQXFindDramaCommentView(cur, 0);
                break;
            }
        }
    }
    if (!commentView) return NO;
    SEL sel = NSSelectorFromString(@"commentViewDidClicked");
    Method m = class_getInstanceMethod(object_getClass(commentView), sel);
    if (!m || strcmp(method_getTypeEncoding(m), "v16@0:8") != 0) return NO;
    ((void (*)(id, SEL))objc_msgSend)(commentView, sel);
    return YES;
}

@interface FQXDramaDoubleTapHandler : NSObject <UIGestureRecognizerDelegate>
+ (instancetype)shared;
- (void)handleOuterDoubleTap:(UITapGestureRecognizer *)gesture;
@end

@implementation FQXDramaDoubleTapHandler
+ (instancetype)shared {
    static FQXDramaDoubleTapHandler *inst;
    static dispatch_once_t once;
    dispatch_once(&once, ^{ inst = [[FQXDramaDoubleTapHandler alloc] init]; });
    return inst;
}
- (BOOL)gestureRecognizerShouldBegin:(UIGestureRecognizer *)gestureRecognizer {
    return FQXDoubleTapCommentEnabled() && gestureRecognizer.view.window != nil;
}
- (void)handleOuterDoubleTap:(UITapGestureRecognizer *)gesture {
    if (gesture.state != UIGestureRecognizerStateEnded || !FQXDoubleTapCommentEnabled()) return;
    FQXTriggerDramaCommentFromControl(gesture.view);
}
@end

static void FQXSyncOuterDoubleTapComment(UIView *outer) {
    if (![outer isKindOfClass:UIView.class]) return;
    UITapGestureRecognizer *dt = objc_getAssociatedObject(outer, FQXDoubleTapCommentGestureKey);
    BOOL enabled = FQXDoubleTapCommentEnabled();
    if (!enabled) {
        if (dt) dt.enabled = NO;
        return;
    }
    if (!dt || dt.view != outer) {
        dt = [[UITapGestureRecognizer alloc] initWithTarget:[FQXDramaDoubleTapHandler shared]
                                                     action:@selector(handleOuterDoubleTap:)];
        dt.numberOfTapsRequired = 2;
        dt.cancelsTouchesInView = YES;
        dt.delegate = [FQXDramaDoubleTapHandler shared];
        [outer addGestureRecognizer:dt];
        objc_setAssociatedObject(outer, FQXDoubleTapCommentGestureKey, dt, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
    }
    dt.enabled = YES;
    UIGestureRecognizer *single = FQXRawIvarObj(outer, "_playPauseTapGesture");
    if ([single isKindOfClass:UIGestureRecognizer.class] && single != dt) {
        [single requireGestureRecognizerToFail:dt];
    }
}

static void (*OrigVPlayerDoubleTap)(id, SEL, id);
static void HookVPlayerDoubleTap(UIView *self, SEL cmd, id gesture) {
    if (FQXDoubleTapCommentEnabled()) {
        FQXTriggerDramaCommentFromControl(self);
        return;
    }
    if (OrigVPlayerDoubleTap) OrigVPlayerDoubleTap(self, cmd, gesture);
}

static void (*OrigOuterControlLayout)(id, SEL);
static void HookOuterControlLayout(UIView *self, SEL _cmd) {
    if (OrigOuterControlLayout) OrigOuterControlLayout(self, _cmd);
    FQXAttachDramaPinchIfNeeded(self);
    FQXSyncOuterDoubleTapComment(self);
}

static void (*OrigOuterDidMoveToWindow)(id, SEL);
static void HookOuterDidMoveToWindow(UIView *control, SEL cmd) {
    OrigOuterDidMoveToWindow(control, cmd);
    if (!control.window && [objc_getAssociatedObject(control, FQXPinchPureCleanActiveKey) boolValue]) {
        FQXApplyPinchPureCleanState(control, NO);
    }
}

static void (*OrigOuterBindContent)(id, SEL, id);
static void HookOuterBindContent(UIView *self, SEL cmd, id model) {
    if (FQXObjGet(self, "contentModel") != model &&
        [objc_getAssociatedObject(self, FQXPinchPureCleanActiveKey) boolValue]) {
        FQXApplyPinchPureCleanState(self, NO);
    }
    OrigOuterBindContent(self, cmd, model);
}

static BOOL FQXPinchOverOuterDramaControl(id component, UIGestureRecognizer *gesture) {
    UIWindow *window = gesture.view.window;
    if (!window || !FQXPinchPureCleanEnabled() ||
        CGRectGetWidth(window.bounds) >= CGRectGetHeight(window.bounds)) return NO;
    id context = FQXObjGet(component, "listVCContext");
    if (!context) return NO;
    Class outerClass = objc_lookUpClass("SSShortVideoOutterMultiGenreFeedControlView");
    for (UIView *control in FQXPinchCleanControls().allObjects) {
        if (control.window != window || control.hidden || ![control isKindOfClass:outerClass] ||
            !CGRectContainsPoint(control.bounds, [gesture locationInView:control])) continue;
        if (FQXObjGet(FQXObjGet(control, "hostContext"), "listVCContext") == context) return YES;
    }
    return NO;
}

static BOOL (*OrigGestureCompShouldBegin)(id, SEL, id);
static BOOL HookGestureCompShouldBegin(id self, SEL _cmd, UIGestureRecognizer *gesture) {
    if ([gesture isKindOfClass:UIPinchGestureRecognizer.class] &&
        (FQXPinchOverOuterDramaControl(self, gesture) || FQXDramaPinchConflicts(gesture))) return NO;
    if ([gesture isKindOfClass:UILongPressGestureRecognizer.class] && FQXDramaPinchConflicts(gesture)) return NO;
    return OrigGestureCompShouldBegin ? OrigGestureCompShouldBegin(self, _cmd, gesture) : YES;
}

static BOOL (*OrigInnerPinchSeekShouldBegin)(id, SEL, id);
static BOOL HookInnerPinchSeekShouldBegin(id self, SEL cmd, UIGestureRecognizer *gesture) {
    if ([gesture isKindOfClass:UIPanGestureRecognizer.class] && FQXDramaPinchConflicts(gesture)) return NO;
    return OrigInnerPinchSeekShouldBegin(self, cmd, gesture);
}

static BOOL (*OrigOuterPinchSeekShouldBegin)(id, SEL, id);
static BOOL HookOuterPinchSeekShouldBegin(id self, SEL cmd, UIGestureRecognizer *gesture) {
    if ([gesture isKindOfClass:UIPanGestureRecognizer.class] && FQXDramaPinchConflicts(gesture)) return NO;
    return OrigOuterPinchSeekShouldBegin(self, cmd, gesture);
}

static BOOL (*OrigDramaShouldPauseInBackground)(id, SEL);
static BOOL HookDramaShouldPauseInBackground(id component, SEL cmd) {
    if ([NSUserDefaults.standardUserDefaults boolForKey:DramaDynamicIslandPrefKey]) {
        return NO;
    }
    if (OrigDramaShouldPauseInBackground(component, cmd)) return YES;
    if (!FQXPinchPureCleanEnabled() || FQXBoolGet(component, "userInitiatedBackgroundPlayback", NO)) return NO;
    id context = FQXObjGet(component, "listVCContext");
    if (!context) return NO;
    Class outerClass = objc_lookUpClass("SSShortVideoOutterMultiGenreFeedControlView");
    for (UIView *control in FQXPinchCleanControls().allObjects) {
        if (!control.window || ![control isKindOfClass:outerClass] ||
            ![objc_getAssociatedObject(control, FQXPinchPureCleanActiveKey) boolValue]) continue;
        if (FQXObjGet(FQXObjGet(control, "hostContext"), "listVCContext") == context) return YES;
    }
    return NO;
}

static void FQXExitPinchCleanInViewController(UIViewController *vc) {
    if (!vc.isViewLoaded) return;
    for (UIView *control in [FQXPinchCleanControls() allObjects]) {
        if (![objc_getAssociatedObject(control, FQXPinchPureCleanActiveKey) boolValue]) continue;
        for (UIView *cur = control; cur; cur = cur.superview) {
            if (cur == vc.view) {
                FQXApplyPinchPureCleanState(control, NO);
                break;
            }
        }
    }
}

static void (*OrigShortVideoListWillDisappear)(id, SEL, BOOL);
static void HookShortVideoListWillDisappear(UIViewController *self, SEL _cmd, BOOL animated) {
    FQXNoteDramaControllerWillDisappear(self);
    FQXExitPinchCleanInViewController(self);
    if (OrigShortVideoListWillDisappear) OrigShortVideoListWillDisappear(self, _cmd, animated);
}

static void (*OrigSeriesFeedWillDisappear)(id, SEL, BOOL);
static void HookSeriesFeedWillDisappear(UIViewController *self, SEL _cmd, BOOL animated) {
    FQXNoteDramaControllerWillDisappear(self);
    FQXExitPinchCleanInViewController(self);
    if (OrigSeriesFeedWillDisappear) OrigSeriesFeedWillDisappear(self, _cmd, animated);
}

#pragma mark - Reader Top-Left Back Button Optical Centering & Inline Paragraph Comment Bubbles

static void FQXCenterReaderBackButton(UIButton *self) {
    if (!FQXGlassEnabled()) return;
    UIImageView *img = self.imageView;
    if (![img isKindOfClass:UIImageView.class] || img.hidden || img.superview != self) return;

    // Locate the circular Liquid Glass backing mounted inside backBtn.
    UIView *glass = nil;
    for (UIView *sub in self.subviews) {
        if (sub == img || sub == self.titleLabel || sub.hidden) continue;
        if ([sub isKindOfClass:UIButton.class] || [sub isKindOfClass:UIVisualEffectView.class]) {
            glass = sub;
            break;
        }
    }
    if (!glass) return;

    CGRect gf = glass.frame;
    if (CGRectGetWidth(gf) < 20.0 || CGRectGetHeight(gf) < 20.0) return;
    CGFloat centerX = CGRectGetMidX(gf);
    CGFloat centerY = CGRectGetMidY(gf);
    CGFloat side = 18.0;
    // reading_navigation_button_back_opt draws its `<` chevron centered at 5.5 / 24.0
    // on a left-aligned 24pt canvas. Override UIKit's bounds-clamped imageView frame
    // after [super layoutSubviews] so `<` sits optically dead-center inside the circle.
    CGRect target = CGRectMake(centerX - side * (5.5 / 24.0),
                               centerY - side * 0.5,
                               side,
                               side);
    if (!CGRectEqualToRect(img.frame, target)) {
        img.frame = target;
    }
}

static NSHashTable<UILabel *> *FQXReaderHotCommentBadges(void) {
    static NSHashTable<UILabel *> *badges;
    static dispatch_once_t once;
    dispatch_once(&once, ^{ badges = [NSHashTable weakObjectsHashTable]; });
    return badges;
}

static void FQXApplyReaderHotCommentBadge(UILabel *badge, BOOL visible) {
    if (![badge isKindOfClass:UILabel.class]) return;
    static char originalOpacityKey;
    NSNumber *original = objc_getAssociatedObject(badge, &originalOpacityKey);
    if (!visible) {
        if (!original) {
            objc_setAssociatedObject(badge, &originalOpacityKey, @(badge.layer.opacity), OBJC_ASSOCIATION_RETAIN_NONATOMIC);
        }
        if (badge.layer.opacity != 0.0f) badge.layer.opacity = 0.0f;
    } else if (original) {
        badge.layer.opacity = original.floatValue;
        objc_setAssociatedObject(badge, &originalOpacityKey, nil, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
    }
}

static BOOL FQXReaderHotCommentBadgeEnabled(void) {
    return FQXHotPrefsSnapshot().readerHotCommentBadge;
}

static void FQXSyncReaderHotCommentBadge(id owner) {
    UILabel *badge = FQXRawIvarObj(owner, "_hotCommentBubble");
    if (!badge) return;
    [FQXReaderHotCommentBadges() addObject:badge];
    FQXApplyReaderHotCommentBadge(badge, FQXReaderHotCommentBadgeEnabled());
}

static void FQXRefreshReaderHotCommentBadges(void) {
    BOOL visible = FQXReaderHotCommentBadgeEnabled();
    for (UILabel *badge in FQXReaderHotCommentBadges().allObjects) {
        FQXApplyReaderHotCommentBadge(badge, visible);
    }
}

static void (*OrigUpdateReaderHotCommentBubble)(id, SEL, BOOL);
static void HookUpdateReaderHotCommentBubble(id self, SEL cmd, BOOL show) {
    OrigUpdateReaderHotCommentBubble(self, cmd, show);
    FQXSyncReaderHotCommentBadge(self);
}

static void (*OrigReaderNavLayoutMotion)(id, SEL);
static void HookReaderNavLayoutMotion(UIView *self, SEL cmd) {
    OrigReaderNavLayoutMotion(self, cmd);
    FQXSyncReaderHotCommentBadge(self);
    UIButton *button = FQXObjGet(self, "backBtn");
    if ([button isKindOfClass:UIButton.class]) FQXCenterReaderBackButton(button);
}

#pragma mark - Mine shortcut viewport and native flow layout

static const void *FQXMineViewportMaskKey = &FQXMineViewportMaskKey;
static const void *FQXMineViewportSavedMaskKey = &FQXMineViewportSavedMaskKey;
static const void *FQXMineViewportSavedClipsKey = &FQXMineViewportSavedClipsKey;
static const void *FQXMineFlowStateKey = &FQXMineFlowStateKey;
static const void *FQXMineScrollTrackedKey = &FQXMineScrollTrackedKey;
static const void *FQXMinePlainScrollTrackedKey = &FQXMinePlainScrollTrackedKey;
static const void *FQXMineDeferredSyncKey = &FQXMineDeferredSyncKey;
static BOOL FQXMineCellRelayoutInFlight = NO;

static Class FQXRealHookClass(id obj) {
    if (!obj) return Nil;
    Class cls = [obj class];
    if (!cls) cls = object_getClass(obj);
    while (cls && strncmp(class_getName(cls), "NSKVONotifying_", 15) == 0) {
        cls = class_getSuperclass(cls);
    }
    return cls;
}

static Class FQXConcreteHookClass(id obj) {
    if (!obj) return Nil;
    Class cls = object_getClass(obj);
    while (cls && strncmp(class_getName(cls), "NSKVONotifying_", 15) == 0) {
        cls = class_getSuperclass(cls);
    }
    return cls;
}

static BOOL FQXIsInsideMineSidebar(UIView *view) {
    static Class sidebarVCCls = Nil;
    static Class sidebarCellCls = Nil;
    static dispatch_once_t once;
    dispatch_once(&once, ^{
        sidebarVCCls = NSClassFromString(@"SSMyUser621SideBarViewController");
        sidebarCellCls = NSClassFromString(@"SSMyUser621SideBarFunctionEntryListCell");
    });
    for (UIView *cur = view; cur; cur = cur.superview) {
        if (sidebarCellCls && [cur isKindOfClass:sidebarCellCls]) return YES;
        for (UIResponder *resp = cur.nextResponder; resp && ![resp isKindOfClass:UIView.class]; resp = resp.nextResponder) {
            if (sidebarVCCls && [resp isKindOfClass:sidebarVCCls]) return YES;
        }
    }
    return NO;
}

static BOOL FQXIsMineShortcutItemCell(UIView *view) {
    if (![view isKindOfClass:UIView.class]) return NO;
    static Class funCls = Nil;
    static Class orderCls = Nil;
    static Class entryCls = Nil;
    static dispatch_once_t once;
    dispatch_once(&once, ^{
        funCls = NSClassFromString(@"SSMyUserCollectionViewFunCell");
        orderCls = NSClassFromString(@"SSMyUserCollectionViewOrderFunCell");
        entryCls = NSClassFromString(@"SSMyUser621FunctionEntryItemCell");
    });
    return (funCls && [view isKindOfClass:funCls]) ||
           (orderCls && [view isKindOfClass:orderCls]) ||
           (entryCls && [view isKindOfClass:entryCls]);
}

static UIView *FQXMineOuterRowForView(UIView *view) {
    if (![view isKindOfClass:UIView.class] || FQXIsInsideMineSidebar(view)) return nil;
    static Class shortcutCls = Nil;
    static Class cell1Cls = Nil;
    static dispatch_once_t once;
    dispatch_once(&once, ^{
        shortcutCls = NSClassFromString(@"SSMyUserShortcutCell");
        cell1Cls = NSClassFromString(@"SSMyUserCollectionView1Cell");
    });
    SEL vipSel = @selector(lynxVipView);
    for (UIView *parent = view; parent; parent = parent.superview) {
        if ((shortcutCls && [parent isKindOfClass:shortcutCls]) ||
            (cell1Cls && [parent isKindOfClass:cell1Cls] && ![parent respondsToSelector:vipSel])) {
            return parent;
        }
    }
    return nil;
}

static UIView *FQXMineShortcutCardForView(UIView *view) {
    if (![view isKindOfClass:UIView.class] || FQXIsInsideMineSidebar(view)) return nil;
    static Class shortcutCls = Nil;
    static Class cell1Cls = Nil;
    static Class foldCls = Nil;
    static dispatch_once_t once;
    dispatch_once(&once, ^{
        shortcutCls = NSClassFromString(@"SSMyUserShortcutCell");
        cell1Cls = NSClassFromString(@"SSMyUserCollectionView1Cell");
        foldCls = NSClassFromString(@"SSScrollFoldFuncView");
    });
    SEL vipSel = @selector(lynxVipView);
    for (UIView *parent = view; parent; parent = parent.superview) {
        if ((shortcutCls && [parent isKindOfClass:shortcutCls]) ||
            (cell1Cls && [parent isKindOfClass:cell1Cls] && ![parent respondsToSelector:vipSel]) ||
            (foldCls && [parent isKindOfClass:foldCls] && !FQXIsInsideMineSidebar(parent))) {
            return parent;
        }
    }
    if ([view isKindOfClass:UICollectionView.class]) {
        CGFloat h = CGRectGetHeight(view.bounds);
        if (h >= 32.0 && h <= 220.0) {
            for (UIView *cell in [(UICollectionView *)view visibleCells]) {
                if (FQXIsMineShortcutItemCell(cell)) {
                    return view.superview ?: view;
                }
            }
        }
    }
    return nil;
}

static UIView *FQXMineShortcutFold(UIView *view) {
    if (![view isKindOfClass:UIView.class] || FQXIsInsideMineSidebar(view)) return nil;
    static Class foldCls = Nil;
    static Class shortcutCls = Nil;
    static Class cell1Cls = Nil;
    static dispatch_once_t once;
    dispatch_once(&once, ^{
        foldCls = NSClassFromString(@"SSScrollFoldFuncView");
        shortcutCls = NSClassFromString(@"SSMyUserShortcutCell");
        cell1Cls = NSClassFromString(@"SSMyUserCollectionView1Cell");
    });
    UIView *fold = nil;
    SEL vipSel = @selector(lynxVipView);
    for (UIView *parent = view; parent; parent = parent.superview) {
        if (foldCls && [parent isKindOfClass:foldCls]) fold = parent;
        if ((shortcutCls && [parent isKindOfClass:shortcutCls]) ||
            (cell1Cls && [parent isKindOfClass:cell1Cls] && ![parent respondsToSelector:vipSel])) return fold;
    }
    return nil;
}

static BOOL FQXMineViewportSyncInFlight = NO;
static void FQXSyncMineContainerUniversal(UIView *container);

// AlignedGlass calls this owner too; two independent clipping policies must not
// alternate on successive parent/child layout passes. The outer glass remains
// unclipped, while only the content viewport clips its own native children.
@interface FQXMineShortcutViewport : NSObject
+ (BOOL)applyToView:(UIView *)view enabled:(BOOL)enabled;
@end
@implementation FQXMineShortcutViewport
+ (BOOL)applyToView:(UIView *)view enabled:(BOOL)enabled {
    NSNumber *saved = objc_getAssociatedObject(view, FQXMineViewportSavedClipsKey);
    UIView *fold = FQXMineShortcutFold(view);
    UIView *host = fold ?: FQXMineShortcutCardForView(view);
    BOOL viewport = (fold && view == fold) ||
                    ([view isKindOfClass:UIScrollView.class] && ![view isKindOfClass:UITableView.class] && host != nil);
    if (!viewport && !saved) return NO;
    CALayer *mask = objc_getAssociatedObject(view, FQXMineViewportMaskKey);
    if (!enabled || !viewport || !view.superview) {
        if (saved) {
            if (view.layer.mask == mask)
                view.layer.mask = objc_getAssociatedObject(view, FQXMineViewportSavedMaskKey);
            if (!view.clipsToBounds) view.clipsToBounds = saved.boolValue;
            objc_setAssociatedObject(view, FQXMineViewportSavedClipsKey, nil, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
            objc_setAssociatedObject(view, FQXMineViewportSavedMaskKey, nil, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
            objc_setAssociatedObject(view, FQXMineViewportMaskKey, nil, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
        }
        return YES;
    }
    CGRect bounds = view.bounds;
    if (CGRectGetWidth(bounds) < 40.0 || CGRectGetHeight(bounds) < 20.0) return YES;
    if (!FQXMineViewportSyncInFlight) {
        FQXMineViewportSyncInFlight = YES;
        FQXSyncMineContainerUniversal(view);
        if (host && host != view) FQXSyncMineContainerUniversal(host);
        FQXMineViewportSyncInFlight = NO;
    }
    if (!saved) {
        // Preserve a host-owned mask instead of replacing its shape.
        if (view.layer.mask) return YES;
        objc_setAssociatedObject(view, FQXMineViewportSavedClipsKey, @(view.clipsToBounds), OBJC_ASSOCIATION_RETAIN_NONATOMIC);
        objc_setAssociatedObject(view, FQXMineViewportSavedMaskKey, view.layer.mask, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
        mask = [CALayer layer];
        mask.backgroundColor = UIColor.blackColor.CGColor;
        objc_setAssociatedObject(view, FQXMineViewportMaskKey, mask, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
    } else if (view.layer.mask && view.layer.mask != mask) {
        return YES;
    }
    CGRect target = bounds;
    if (view != host) {
        // Reserve badge headroom only where the actual card has room. Never
        // expose an extra row below the collection as the former +/-28 mask did.
        CGRect card = [host convertRect:host.bounds toView:view];
        CGFloat top = MAX(CGRectGetMinY(card), CGRectGetMinY(bounds) - 12.0);
        target = CGRectIntersection(card, CGRectMake(CGRectGetMinX(bounds), top,
                     CGRectGetWidth(bounds), CGRectGetMaxY(bounds) - top));
    }
    if (CGRectIsNull(target)) target = CGRectZero;
    [CATransaction begin];
    [CATransaction setDisableActions:YES];
    view.clipsToBounds = NO;
    mask.frame = target;
    view.layer.mask = mask;
    [CATransaction commit];
    return YES;
}
@end

@interface FQXMineShortcutFlowState : NSObject
@property(nonatomic, weak) UICollectionViewLayout *layout;
@property(nonatomic, weak) UIView *pageControl;
@property(nonatomic) CGSize savedItemSize;
@property(nonatomic) CGSize savedEstimatedItemSize;
@property(nonatomic) UIEdgeInsets savedSectionInset;
@property(nonatomic) CGFloat savedLineSpacing;
@property(nonatomic) CGFloat savedInteritemSpacing;
@property(nonatomic) BOOL hasSavedFlowProps;
@property(nonatomic) UIEdgeInsets savedContentInset;
@property(nonatomic) BOOL hasSavedContentInset;
@property(nonatomic) CGSize nativeItemSize;
@property(nonatomic) CGSize appliedItemSize;
@property(nonatomic) CGSize viewportSize;
@property(nonatomic) CGFloat viewportHeight;
@property(nonatomic) CGFloat slotWidth;
@property(nonatomic) CGFloat itemHeight;
@property(nonatomic) CGFloat topInset;
@property(nonatomic) BOOL savedPaging;
@property(nonatomic) NSInteger savedPageCount;
@property(nonatomic) NSUInteger columns;
@property(nonatomic) NSUInteger pages;
@property(nonatomic) NSUInteger totalCount;
@property(nonatomic) BOOL active;
@end
@implementation FQXMineShortcutFlowState
@end

static int FQXMethodMatchesIntSetter(Class cls, SEL sel) {
    Method m = cls ? class_getInstanceMethod(cls, sel) : NULL;
    if (!m) return 0;
    const char *e = method_getTypeEncoding(m);
    if (!e) return 0;
    if (strcmp(e, "v24@0:8q16") == 0 || strcmp(e, "v24@0:8Q16") == 0) return 1;
    if (strcmp(e, "v20@0:8i16") == 0 || strcmp(e, "v20@0:8I16") == 0) return 2;
    return 0;
}

static int FQXMethodMatchesIntGetter(Class cls, SEL sel) {
    Method m = cls ? class_getInstanceMethod(cls, sel) : NULL;
    if (!m) return 0;
    const char *e = method_getTypeEncoding(m);
    if (!e) return 0;
    if (strcmp(e, "q16@0:8") == 0 || strcmp(e, "Q16@0:8") == 0) return 1;
    if (strcmp(e, "i16@0:8") == 0 || strcmp(e, "I16@0:8") == 0) return 2;
    return 0;
}

static BOOL FQXViewIsPageControlLike(UIView *view) {
    if ([view isKindOfClass:UIPageControl.class]) return YES;
    if (view.hidden || ![view isKindOfClass:UIView.class]) return NO;
    Class cls = FQXRealHookClass(view);
    if (!cls) return NO;
    static Class selectCls = Nil;
    static dispatch_once_t once;
    dispatch_once(&once, ^{ selectCls = NSClassFromString(@"FQReaderSaaSBookStoreSelectView"); });
    SEL countSetters[] = { @selector(setNumberOfPages:), @selector(setTotalCount:), @selector(setPageCount:) };
    SEL countGetters[] = { @selector(numberOfPages), @selector(totalCount), @selector(pageCount) };
    SEL curSetters[] = { @selector(setCurrentPage:), @selector(setCurrentIndex:), @selector(setSelectIndex:), @selector(setSelectedIndex:) };
    BOOL hasSetCount = NO;
    BOOL hasCountPair = NO;
    for (int i = 0; i < 3; ++i) {
        if (FQXMethodMatchesIntSetter(cls, countSetters[i])) {
            hasSetCount = YES;
            if (FQXMethodMatchesIntGetter(cls, countGetters[i])) hasCountPair = YES;
        }
    }
    BOOL hasSetCur = NO;
    for (int i = 0; i < 4; ++i) {
        if (FQXMethodMatchesIntSetter(cls, curSetters[i])) {
            hasSetCur = YES;
            break;
        }
    }
    if (selectCls && [view isKindOfClass:selectCls]) {
        return hasSetCur || hasSetCount;
    }
    return hasCountPair && hasSetCur;
}

static UIView *FQXFindMinePageControlInTree(UIView *root, NSInteger depth) {
    if (FQXViewIsPageControlLike(root)) return root;
    if (depth <= 0 || [root isKindOfClass:UICollectionView.class]) return nil;
    for (UIView *child in root.subviews) {
        UIView *found = FQXFindMinePageControlInTree(child, depth - 1);
        if (found) return found;
    }
    return nil;
}

static UIView *FQXMinePageControl(UIView *fold, UIView *card) {
    UIView *found = fold ? FQXFindMinePageControlInTree(fold, 4) : nil;
    if (!found && card && card != fold) {
        found = FQXFindMinePageControlInTree(card, 4);
    }
    return found;
}

static NSInteger FQXReadMinePageControlCount(UIView *pc) {
    if (!pc) return 0;
    if ([pc isKindOfClass:UIPageControl.class]) return [(UIPageControl *)pc numberOfPages];
    Class cls = FQXRealHookClass(pc);
    SEL countGetters[] = { @selector(numberOfPages), @selector(totalCount), @selector(pageCount) };
    for (int i = 0; i < 3; ++i) {
        int kind = FQXMethodMatchesIntGetter(cls, countGetters[i]);
        if (kind == 1) return ((NSInteger (*)(id, SEL))objc_msgSend)(pc, countGetters[i]);
        if (kind == 2) return (NSInteger)((int (*)(id, SEL))objc_msgSend)(pc, countGetters[i]);
    }
    return 0;
}

static void FQXInvokePageControlSetter(UIView *pc, SEL sel, int kind, NSInteger value) {
    if (kind == 1) {
        ((void (*)(id, SEL, NSInteger))objc_msgSend)(pc, sel, value);
    } else if (kind == 2) {
        ((void (*)(id, SEL, int))objc_msgSend)(pc, sel, (int)value);
    }
}

static void FQXUpdateMinePageControl(UIView *pc, NSInteger pages, NSInteger current) {
    if (!pc || pages <= 0) return;
    if ([pc isKindOfClass:UIPageControl.class]) {
        UIPageControl *uipc = (UIPageControl *)pc;
        if (uipc.numberOfPages != pages) uipc.numberOfPages = pages;
        if (uipc.currentPage != current) uipc.currentPage = current;
        return;
    }
    Class cls = FQXRealHookClass(pc);
    SEL countSetters[] = { @selector(setNumberOfPages:), @selector(setTotalCount:), @selector(setPageCount:) };
    for (int i = 0; i < 3; ++i) {
        int kind = FQXMethodMatchesIntSetter(cls, countSetters[i]);
        if (kind) {
            FQXInvokePageControlSetter(pc, countSetters[i], kind, pages);
            break;
        }
    }
    SEL curSetters[] = { @selector(setCurrentPage:), @selector(setCurrentIndex:), @selector(setSelectIndex:), @selector(setSelectedIndex:) };
    for (int i = 0; i < 4; ++i) {
        int kind = FQXMethodMatchesIntSetter(cls, curSetters[i]);
        if (kind) {
            FQXInvokePageControlSetter(pc, curSetters[i], kind, current);
            break;
        }
    }
}

static UICollectionView *FQXFindMineCollectionView(UIView *root, NSInteger depth) {
    if ([root isKindOfClass:UICollectionView.class]) {
        UICollectionView *cv = (UICollectionView *)root;
        CGFloat w = CGRectGetWidth(cv.bounds);
        CGFloat h = CGRectGetHeight(cv.bounds);
        if (w >= 160.0 && h >= 32.0 && h <= 220.0) {
            for (UIView *sub in cv.subviews) {
                if (FQXIsMineShortcutItemCell(sub)) return cv;
            }
        }
        return nil;
    }
    if (depth <= 0) return nil;
    UICollectionView *fallback = nil;
    for (UIView *child in root.subviews) {
        if ([child isKindOfClass:UICollectionView.class]) {
            UICollectionView *cv = (UICollectionView *)child;
            CGFloat w = CGRectGetWidth(cv.bounds);
            CGFloat h = CGRectGetHeight(cv.bounds);
            if (w >= 160.0 && h >= 32.0 && h <= 220.0) {
                for (UIView *sub in cv.subviews) {
                    if (FQXIsMineShortcutItemCell(sub)) return cv;
                }
                if (!fallback) fallback = cv;
            }
            continue;
        }
        UICollectionView *found = FQXFindMineCollectionView(child, depth - 1);
        if (found) return found;
    }
    return fallback;
}

static UIScrollView *FQXFindMinePlainScrollView(UIView *root, NSInteger depth) {
    if ([root isKindOfClass:UIScrollView.class] && ![root isKindOfClass:UICollectionView.class] &&
        ![root isKindOfClass:UITableView.class]) {
        CGFloat w = CGRectGetWidth(root.bounds);
        CGFloat h = CGRectGetHeight(root.bounds);
        if (w >= 160.0 && h >= 32.0 && h <= 240.0) return (UIScrollView *)root;
    }
    if (depth <= 0) return nil;
    for (UIView *child in root.subviews) {
        UIScrollView *found = FQXFindMinePlainScrollView(child, depth - 1);
        if (found) return found;
    }
    return nil;
}

static const void *FQXMineTileAsyncLayoutKey = &FQXMineTileAsyncLayoutKey;

static void FQXRelayoutMineTileAfterFrameChange(UIView *tile) {
    if (!tile || FQXMineCellRelayoutInFlight) return;
    FQXMineCellRelayoutInFlight = YES;
    if ([tile isKindOfClass:UICollectionViewCell.class]) {
        UICollectionViewCell *cell = (UICollectionViewCell *)tile;
        if (!CGRectEqualToRect(cell.contentView.frame, cell.bounds)) {
            cell.contentView.frame = cell.bounds;
        }
    }
    [tile setNeedsLayout];
    [tile layoutIfNeeded];
    FQXMineCellRelayoutInFlight = NO;
    if (![objc_getAssociatedObject(tile, FQXMineTileAsyncLayoutKey) boolValue]) {
        objc_setAssociatedObject(tile, FQXMineTileAsyncLayoutKey, @YES, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
        __weak UIView *weakTile = tile;
        dispatch_async(dispatch_get_main_queue(), ^{
            UIView *strongTile = weakTile;
            if (!strongTile) return;
            objc_setAssociatedObject(strongTile, FQXMineTileAsyncLayoutKey, nil, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
            if (!strongTile.window) return;
            if ([strongTile isKindOfClass:UICollectionViewCell.class]) {
                UICollectionViewCell *cell = (UICollectionViewCell *)strongTile;
                if (!CGRectEqualToRect(cell.contentView.frame, cell.bounds)) {
                    cell.contentView.frame = cell.bounds;
                }
            }
            [strongTile setNeedsLayout];
            [strongTile layoutIfNeeded];
        });
    }
}

static void FQXCollectScrollTilesAcrossPages(UIView *root, NSInteger depth, NSMutableArray<UIView *> *outTiles) {
    if (!root || depth < 0 || !outTiles) return;
    for (UIView *sub in root.subviews) {
        if (sub.hidden || sub.alpha <= 0.01) continue;
        if ([sub isKindOfClass:UIVisualEffectView.class] || [sub isKindOfClass:UICollectionView.class] ||
            [sub isKindOfClass:UITableView.class] || FQXViewIsPageControlLike(sub)) continue;
        NSString *clsName = NSStringFromClass(sub.class);
        if ([clsName containsString:@"ScrollIndicator"] || [clsName containsString:@"BookStoreSelectView"]) continue;
        CGFloat w = CGRectGetWidth(sub.bounds);
        CGFloat h = CGRectGetHeight(sub.bounds);
        if (FQXIsMineShortcutItemCell(sub) || (w >= 32.0 && w <= 130.0 && h >= 32.0 && h <= 220.0)) {
            [outTiles addObject:sub];
        } else if (depth > 0) {
            FQXCollectScrollTilesAcrossPages(sub, depth - 1, outTiles);
        }
    }
}

static NSArray<UIView *> *FQXCollectMineShortcutTilesInHost(UIView *root, NSInteger depth, UIView **outHost) {
    if (!root || depth < 0) return nil;
    NSMutableArray<UIView *> *tiles = [NSMutableArray array];
    NSUInteger knownCells = 0;
    for (UIView *sub in root.subviews) {
        if (sub.hidden || sub.alpha <= 0.01) continue;
        if ([sub isKindOfClass:UIVisualEffectView.class] || FQXViewIsPageControlLike(sub)) continue;
        NSString *clsName = NSStringFromClass(sub.class);
        if ([clsName containsString:@"ScrollIndicator"] || [clsName containsString:@"BookStoreSelectView"]) continue;
        if (FQXIsMineShortcutItemCell(sub)) {
            [tiles addObject:sub];
            knownCells++;
        } else if (CGRectGetWidth(sub.bounds) >= 32.0 && CGRectGetWidth(sub.bounds) <= 130.0 &&
                   CGRectGetHeight(sub.bounds) >= 32.0) {
            [tiles addObject:sub];
        }
    }
    if ((knownCells >= 1 && tiles.count >= 4) || tiles.count >= 5) {
        if (outHost) *outHost = root;
        return tiles;
    }
    if (depth == 0) return nil;
    for (UIView *sub in root.subviews) {
        if (sub.hidden || sub.alpha <= 0.01) continue;
        if ([sub isKindOfClass:UIVisualEffectView.class] ||
            [sub isKindOfClass:UICollectionView.class] || FQXViewIsPageControlLike(sub)) continue;
        if ([sub isKindOfClass:UIControl.class] && CGRectGetWidth(sub.bounds) <= 130.0) continue;
        NSString *clsName = NSStringFromClass(sub.class);
        if ([clsName containsString:@"ScrollIndicator"] || [clsName containsString:@"BookStoreSelectView"]) continue;
        NSArray<UIView *> *nested = FQXCollectMineShortcutTilesInHost(sub, depth - 1, outHost);
        if (nested.count) return nested;
    }
    return nil;
}

static BOOL FQXSyncMinePlainScrollView(UIView *card, UIScrollView *sv);

static void FQXInstallMinePlainScrollHook(UIScrollView *sv) {
    if (![sv isKindOfClass:UIScrollView.class] || [sv isKindOfClass:UICollectionView.class] ||
        [sv isKindOfClass:UITableView.class]) return;
    objc_setAssociatedObject(sv, FQXMinePlainScrollTrackedKey, @YES, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
    static NSMutableSet<NSString *> *installed;
    static NSMutableSet<NSString *> *installedDel;
    static dispatch_once_t once;
    dispatch_once(&once, ^{
        installed = [NSMutableSet set];
        installedDel = [NSMutableSet set];
    });
    id delegate = sv.delegate;
    Class delCls = FQXRealHookClass(delegate);
    if (delCls && delCls != UIView.class && delCls != UIScrollView.class && delCls != NSObject.class) {
        NSString *delName = NSStringFromClass(delCls);
        if (delName.length && ![delName hasPrefix:@"UI"] && ![installedDel containsObject:delName] &&
            ![delName isEqualToString:@"SSMyUser621ViewController"]) {
            SEL scrollSel = @selector(scrollViewDidScroll:);
            if ([delegate respondsToSelector:scrollSel]) {
                __block IMP origScroll = NULL;
                IMP scrollHook = imp_implementationWithBlock(^(id owner, UIScrollView *scrollView) {
                    ((void (*)(id, SEL, id))origScroll)(owner, scrollSel, scrollView);
                    if (![objc_getAssociatedObject(scrollView, FQXMinePlainScrollTrackedKey) boolValue]) return;
                    UIView *ownerCard = FQXMineShortcutCardForView(scrollView);
                    if (ownerCard) FQXSyncMinePlainScrollView(ownerCard, scrollView);
                });
                if (FQXInstallOwnedHook(delCls, scrollSel, NO, "v24@0:8@16", scrollHook, &origScroll)) {
                    [installedDel addObject:delName];
                } else {
                    imp_removeBlock(scrollHook);
                }
            }
        }
    }
    Class cls = FQXRealHookClass(sv);
    if (!cls || cls == UIView.class || cls == UIScrollView.class || cls == NSObject.class) return;
    NSString *name = NSStringFromClass(cls);
    if (!name.length || [name hasPrefix:@"UI"] || [installed containsObject:name]) return;
    __block IMP original = NULL;
    IMP hook = imp_implementationWithBlock(^(UIScrollView *view) {
        ((void (*)(id, SEL))original)(view, @selector(layoutSubviews));
        if (![objc_getAssociatedObject(view, FQXMinePlainScrollTrackedKey) boolValue]) return;
        UIView *ownerCard = FQXMineShortcutCardForView(view);
        if (ownerCard) {
            FQXSyncMinePlainScrollView(ownerCard, view);
            [FQXMineShortcutViewport applyToView:view enabled:FQXGlassEnabled()];
        }
    });
    if (FQXInstallOwnedHook(cls, @selector(layoutSubviews), NO, "v16@0:8", hook, &original)) {
        [installed addObject:name];
    } else {
        imp_removeBlock(hook);
    }
}

static BOOL FQXSyncMinePlainScrollView(UIView *card, UIScrollView *sv) {
    if (![sv isKindOfClass:UIScrollView.class]) return NO;
    FQXInstallMinePlainScrollHook(sv);
    CGFloat width = CGRectGetWidth(sv.bounds);
    CGFloat height = CGRectGetHeight(sv.bounds);
    if (width < 160.0 || height < 32.0 || height > 240.0) return NO;
    NSMutableArray<UIView *> *tiles = [NSMutableArray array];
    FQXCollectScrollTilesAcrossPages(sv, 4, tiles);
    if (tiles.count < 4) return NO;
    [tiles sortUsingComparator:^NSComparisonResult(UIView *a, UIView *b) {
        CGFloat ax = CGRectGetMinX([a convertRect:a.bounds toView:sv]);
        CGFloat bx = CGRectGetMinX([b convertRect:b.bounds toView:sv]);
        return fabs(ax - bx) > 0.5 ? (ax < bx ? NSOrderedAscending : NSOrderedDescending) : NSOrderedSame;
    }];
    CGFloat slotW = width / 4.0;
    NSUInteger pages = (tiles.count + 3) / 4;
    if (!sv.pagingEnabled) sv.pagingEnabled = YES;
    CGSize targetCS = CGSizeMake(width * (CGFloat)pages, height);
    UIView *commonParent = tiles.firstObject.superview;
    BOOL singleHost = (commonParent != nil);
    for (UIView *t in tiles) {
        if (t.superview != commonParent) {
            singleHost = NO;
            break;
        }
    }
    if (singleHost && commonParent != sv && commonParent.superview == sv) {
        CGRect hf = CGRectMake(0.0, 0.0, targetCS.width, height);
        if (!CGRectEqualToRect(commonParent.frame, hf)) commonParent.frame = hf;
    }
    for (NSUInteger i = 0; i < tiles.count; ++i) {
        UIView *tile = tiles[i];
        UIView *parent = tile.superview ?: sv;
        if (parent != sv && parent.clipsToBounds && CGRectGetWidth(parent.bounds) < targetCS.width - 2.0) {
            parent.clipsToBounds = NO;
        }
        NSUInteger page = i / 4;
        NSUInteger col = i % 4;
        CGRect curInSV = [parent convertRect:tile.frame toView:sv];
        CGRect targetInSV = CGRectMake((CGFloat)page * width + (CGFloat)col * slotW,
                                       curInSV.origin.y,
                                       slotW,
                                       CGRectGetHeight(tile.frame));
        CGRect f = (parent == sv) ? targetInSV : [sv convertRect:targetInSV toView:parent];
        if (fabs(CGRectGetMinX(tile.frame) - f.origin.x) > 0.5 ||
            fabs(CGRectGetWidth(tile.frame) - f.size.width) > 0.5) {
            tile.frame = f;
            FQXRelayoutMineTileAfterFrameChange(tile);
        }
    }
    if (!CGSizeEqualToSize(sv.contentSize, targetCS)) sv.contentSize = targetCS;
    UIView *pc = FQXMinePageControl(FQXMineShortcutFold(card), card);
    if (pc) {
        NSInteger cur = MAX(0, MIN((NSInteger)pages - 1, (NSInteger)llround(sv.contentOffset.x / MAX(1.0, width))));
        FQXUpdateMinePageControl(pc, (NSInteger)pages, cur);
    }
    return YES;
}

static BOOL FQXSyncMineDirectTileHost(UIView *card) {
    if (![card isKindOfClass:UIView.class]) return NO;
    UIView *host = nil;
    NSArray<UIView *> *rawTiles = FQXCollectMineShortcutTilesInHost(card, 4, &host);
    if (!host || rawTiles.count < 5) return NO;
    CGFloat width = CGRectGetWidth(host.bounds);
    if (width < 160.0) return NO;
    NSMutableArray<UIView *> *tiles = [rawTiles mutableCopy];
    [tiles sortUsingComparator:^NSComparisonResult(UIView *a, UIView *b) {
        CGFloat ax = CGRectGetMinX(a.frame), bx = CGRectGetMinX(b.frame);
        return fabs(ax - bx) > 0.5 ? (ax < bx ? NSOrderedAscending : NSOrderedDescending) : NSOrderedSame;
    }];
    CGFloat slotW = width / 4.0;
    for (NSUInteger i = 0; i < tiles.count; ++i) {
        UIView *tile = tiles[i];
        NSUInteger page = i / 4;
        NSUInteger col = i % 4;
        CGRect f = CGRectMake((CGFloat)page * width + (CGFloat)col * slotW,
                              tile.frame.origin.y,
                              slotW,
                              CGRectGetHeight(tile.frame));
        if (fabs(CGRectGetMinX(tile.frame) - f.origin.x) > 0.5 ||
            fabs(CGRectGetWidth(tile.frame) - f.size.width) > 0.5) {
            tile.frame = f;
            FQXRelayoutMineTileAfterFrameChange(tile);
        }
    }
    host.clipsToBounds = YES;
    return YES;
}

static NSUInteger FQXMineTotalItemCount(UICollectionView *collection) {
    if (!collection) return 0;
    NSInteger sections = [collection numberOfSections];
    NSUInteger total = 0;
    for (NSInteger s = 0; s < sections; ++s) {
        NSInteger n = [collection numberOfItemsInSection:s];
        if (n > 0) total += (NSUInteger)n;
    }
    return total;
}

static NSUInteger FQXMineFlatIndexForIndexPath(UICollectionView *collection, NSIndexPath *indexPath) {
    if (!collection || !indexPath || indexPath.section < 0 || indexPath.item < 0) return NSNotFound;
    NSInteger sections = [collection numberOfSections];
    if (indexPath.section >= sections) return NSNotFound;
    NSUInteger flat = 0;
    for (NSInteger s = 0; s < indexPath.section; ++s) {
        NSInteger n = [collection numberOfItemsInSection:s];
        if (n > 0) flat += (NSUInteger)n;
    }
    NSInteger inSec = [collection numberOfItemsInSection:indexPath.section];
    if (indexPath.item >= inSec) return NSNotFound;
    return flat + (NSUInteger)indexPath.item;
}

static CGRect FQXMineFrameForFlatIndex(FQXMineShortcutFlowState *state, NSUInteger flatIndex) {
    NSUInteger cols = MAX(1u, state.columns);
    NSUInteger page = flatIndex / cols;
    NSUInteger col = flatIndex % cols;
    CGFloat x = (CGFloat)page * state.viewportSize.width + (CGFloat)col * state.slotWidth;
    return CGRectMake(x, state.topInset, state.slotWidth, state.itemHeight);
}

static BOOL FQXInstallMineValidatedHook(Class cls, SEL sel, unsigned int expectedArgs,
                                        const char *retPrefix, const char *altRetPrefix,
                                        IMP hook, IMP *origOut) {
    if (!cls || !sel || !retPrefix || !hook) return NO;
    Method m = class_getInstanceMethod(cls, sel);
    if (!m || method_getNumberOfArguments(m) != expectedArgs) return NO;
    const char *enc = method_getTypeEncoding(m);
    if (!enc) return NO;
    BOOL retOK = (strncmp(enc, retPrefix, strlen(retPrefix)) == 0) ||
                 (altRetPrefix && strncmp(enc, altRetPrefix, strlen(altRetPrefix)) == 0);
    if (!retOK) return NO;
    return FQXInstallOwnedHook(cls, sel, NO, enc, hook, origOut);
}

static NSArray *FQXCollectMineDelegateTargets(id delegate) {
    if (!delegate) return @[];
    NSMutableArray *targets = [NSMutableArray arrayWithCapacity:3];
    Class proxyBase = [NSProxy class];
    SEL getterSels[5] = {
        @selector(collectionViewTarget),
        @selector(interceptor),
        @selector(target),
        @selector(scrollViewTarget),
        @selector(delegate)
    };
    NSMutableArray *queue = [NSMutableArray arrayWithObject:delegate];
    for (NSUInteger qi = 0; qi < queue.count; ++qi) {
        id cur = queue[qi];
        if ([targets indexOfObjectIdenticalTo:cur] != NSNotFound) continue;
        Class cls = object_getClass(cur);
        const char *cname = cls ? class_getName(cls) : "";
        BOOL isProxy = NO;
        for (Class c = cls; c; c = class_getSuperclass(c)) {
            if (c == proxyBase) { isProxy = YES; break; }
        }
        if (!isProxy && cname && strstr(cname, "Proxy") != NULL) isProxy = YES;
        if (!isProxy) {
            [targets addObject:cur];
        } else {
            SEL fwdSel = @selector(forwardingTargetForSelector:);
            Method fwdMethod = cls ? class_getInstanceMethod(cls, fwdSel) : NULL;
            const char *fwdEnc = fwdMethod ? method_getTypeEncoding(fwdMethod) : NULL;
            if (fwdEnc && strncmp(fwdEnc, "@24@0:8:16", 10) == 0) {
                SEL probeSels[2] = {
                    @selector(collectionView:layout:sizeForItemAtIndexPath:),
                    @selector(collectionView:layout:insetForSectionAtIndex:)
                };
                for (int si = 0; si < 2 && queue.count < 4; ++si) {
                    id fwd = ((id (*)(id, SEL, SEL))objc_msgSend)(cur, fwdSel, probeSels[si]);
                    if (fwd && fwd != cur && [queue indexOfObjectIdenticalTo:fwd] == NSNotFound) {
                        [queue addObject:fwd];
                    }
                }
            }
            for (int i = 0; i < 5 && queue.count < 4; ++i) {
                Method m = cls ? class_getInstanceMethod(cls, getterSels[i]) : NULL;
                const char *enc = m ? method_getTypeEncoding(m) : NULL;
                if (!enc || strcmp(enc, "@16@0:8") != 0) continue;
                id next = ((id (*)(id, SEL))objc_msgSend)(cur, getterSels[i]);
                if (!next || next == cur) continue;
                if ([queue indexOfObjectIdenticalTo:next] == NSNotFound) {
                    [queue addObject:next];
                }
            }
        }
    }
    return targets;
}

static BOOL FQXInstallMineItemSizeHook(id delegate) {
    if (!delegate) return YES;
    static NSMutableSet<NSString *> *installedSize;
    static NSMutableSet<NSString *> *installedLine;
    static NSMutableSet<NSString *> *installedInter;
    static dispatch_once_t once;
    dispatch_once(&once, ^{
        installedSize = [NSMutableSet set];
        installedLine = [NSMutableSet set];
        installedInter = [NSMutableSet set];
    });
    SEL sizeSel = @selector(collectionView:layout:sizeForItemAtIndexPath:);
    SEL lineSel = @selector(collectionView:layout:minimumLineSpacingForSectionAtIndex:);
    SEL interSel = @selector(collectionView:layout:minimumInteritemSpacingForSectionAtIndex:);
    for (id target in FQXCollectMineDelegateTargets(delegate)) {
        Class cls = FQXConcreteHookClass(target);
        if (!cls || cls == UIView.class || cls == NSObject.class) continue;
        NSString *name = NSStringFromClass(cls);
        if (!name.length) continue;

        if (![installedSize containsObject:name] && class_getInstanceMethod(cls, sizeSel)) {
            __block IMP origSize = NULL;
            IMP hookSize = imp_implementationWithBlock(^CGSize(id owner, UICollectionView *collection,
                                                              UICollectionViewLayout *layout, NSIndexPath *index) {
                CGSize native = ((CGSize (*)(id, SEL, id, id, id))origSize)(owner, sizeSel, collection, layout, index);
                FQXMineShortcutFlowState *state = objc_getAssociatedObject(collection, FQXMineFlowStateKey);
                if (state.active && state.layout == layout) {
                    if (index.section == 0 && index.item == 0) state.nativeItemSize = native;
                    return state.appliedItemSize;
                }
                return native;
            });
            if (FQXInstallMineValidatedHook(cls, sizeSel, 5, "{CGSize", NULL, hookSize, &origSize)) {
                [installedSize addObject:name];
            } else {
                imp_removeBlock(hookSize);
            }
        }

        if (![installedLine containsObject:name] && class_getInstanceMethod(cls, lineSel)) {
            __block IMP origLine = NULL;
            IMP hookLine = imp_implementationWithBlock(^CGFloat(id owner, UICollectionView *collection,
                                                                 UICollectionViewLayout *layout, NSInteger section) {
                FQXMineShortcutFlowState *state = objc_getAssociatedObject(collection, FQXMineFlowStateKey);
                if (state.active && state.layout == layout) return 0.0;
                return ((CGFloat (*)(id, SEL, id, id, NSInteger))origLine)(owner, lineSel, collection, layout, section);
            });
            if (FQXInstallMineValidatedHook(cls, lineSel, 5, "d", "f", hookLine, &origLine)) {
                [installedLine addObject:name];
            } else {
                imp_removeBlock(hookLine);
            }
        }

        if (![installedInter containsObject:name] && class_getInstanceMethod(cls, interSel)) {
            __block IMP origInter = NULL;
            IMP hookInter = imp_implementationWithBlock(^CGFloat(id owner, UICollectionView *collection,
                                                                  UICollectionViewLayout *layout, NSInteger section) {
                FQXMineShortcutFlowState *state = objc_getAssociatedObject(collection, FQXMineFlowStateKey);
                if (state.active && state.layout == layout) return 0.0;
                return ((CGFloat (*)(id, SEL, id, id, NSInteger))origInter)(owner, interSel, collection, layout, section);
            });
            if (FQXInstallMineValidatedHook(cls, interSel, 5, "d", "f", hookInter, &origInter)) {
                [installedInter addObject:name];
            } else {
                imp_removeBlock(hookInter);
            }
        }
    }
    return YES;
}

static BOOL FQXInstallMineSectionInsetHook(id delegate) {
    if (!delegate) return YES;
    SEL selector = @selector(collectionView:layout:insetForSectionAtIndex:);
    static NSMutableSet<NSString *> *installed;
    static dispatch_once_t once;
    dispatch_once(&once, ^{ installed = [NSMutableSet set]; });
    for (id target in FQXCollectMineDelegateTargets(delegate)) {
        Class cls = FQXConcreteHookClass(target);
        if (!cls || cls == UIView.class || cls == NSObject.class) continue;
        NSString *name = NSStringFromClass(cls);
        if (!name.length || [installed containsObject:name] || !class_getInstanceMethod(cls, selector)) continue;
        __block IMP original = NULL;
        IMP hook = imp_implementationWithBlock(^UIEdgeInsets(id owner, UICollectionView *collection,
                                                            UICollectionViewLayout *layout, NSInteger section) {
            UIEdgeInsets native = ((UIEdgeInsets (*)(id, SEL, id, id, NSInteger))original)(
                owner, selector, collection, layout, section);
            FQXMineShortcutFlowState *state = objc_getAssociatedObject(collection, FQXMineFlowStateKey);
            if (state.active && state.layout == layout) {
                return UIEdgeInsetsMake(state.topInset, 0.0, native.bottom, 0.0);
            }
            return native;
        });
        if (FQXInstallMineValidatedHook(cls, selector, 5, "{UIEdgeInsets", NULL, hook, &original)) {
            [installed addObject:name];
        } else {
            imp_removeBlock(hook);
        }
    }
    return YES;
}

static void FQXInstallMineLayoutHooks(UICollectionViewLayout *layout) {
    if (!layout) return;
    static NSMutableSet<NSString *> *installedSize;
    static NSMutableSet<NSString *> *installedItem;
    static NSMutableSet<NSString *> *installedRect;
    static NSMutableSet<NSString *> *installedBounds;
    static NSMutableSet<NSString *> *installedTargetOffset;
    static dispatch_once_t once;
    dispatch_once(&once, ^{
        installedSize = [NSMutableSet set];
        installedItem = [NSMutableSet set];
        installedRect = [NSMutableSet set];
        installedBounds = [NSMutableSet set];
        installedTargetOffset = [NSMutableSet set];
    });
    Class cls = FQXRealHookClass(layout);
    if (!cls || cls == UIView.class || cls == NSObject.class) return;
    NSString *name = NSStringFromClass(cls);
    if (!name.length) return;

    if (![installedSize containsObject:name]) {
        SEL sel = @selector(collectionViewContentSize);
        __block IMP origSize = NULL;
        IMP sizeHook = imp_implementationWithBlock(^CGSize(UICollectionViewLayout *owner) {
            UICollectionView *cv = owner.collectionView;
            FQXMineShortcutFlowState *state = cv ? objc_getAssociatedObject(cv, FQXMineFlowStateKey) : nil;
            if (state.active && state.layout == owner &&
                state.pages > 0 && state.viewportSize.width > 0.0 && state.viewportHeight > 0.0) {
                return CGSizeMake(state.viewportSize.width * (CGFloat)state.pages, state.viewportHeight);
            }
            return ((CGSize (*)(id, SEL))origSize)(owner, sel);
        });
        if (FQXInstallMineValidatedHook(cls, sel, 2, "{CGSize", NULL, sizeHook, &origSize)) {
            [installedSize addObject:name];
        } else {
            imp_removeBlock(sizeHook);
        }
    }

    if (![installedItem containsObject:name]) {
        SEL sel = @selector(layoutAttributesForItemAtIndexPath:);
        __block IMP origItem = NULL;
        IMP itemHook = imp_implementationWithBlock(^UICollectionViewLayoutAttributes *(
            UICollectionViewLayout *owner, NSIndexPath *indexPath) {
            UICollectionViewLayoutAttributes *native =
                ((UICollectionViewLayoutAttributes *(*)(id, SEL, id))origItem)(owner, sel, indexPath);
            UICollectionView *cv = owner.collectionView;
            FQXMineShortcutFlowState *state = cv ? objc_getAssociatedObject(cv, FQXMineFlowStateKey) : nil;
            if (!state.active || state.layout != owner ||
                !state.columns || state.slotWidth < 44.0) {
                return native;
            }
            NSUInteger flatIdx = FQXMineFlatIndexForIndexPath(cv, indexPath);
            if (flatIdx == NSNotFound) return native;
            UICollectionViewLayoutAttributes *attrs = native
                ? [native copy]
                : [UICollectionViewLayoutAttributes layoutAttributesForCellWithIndexPath:indexPath];
            attrs.frame = FQXMineFrameForFlatIndex(state, flatIdx);
            attrs.hidden = NO;
            attrs.alpha = 1.0;
            return attrs;
        });
        if (FQXInstallMineValidatedHook(cls, sel, 3, "@", NULL, itemHook, &origItem)) {
            [installedItem addObject:name];
        } else {
            imp_removeBlock(itemHook);
        }
    }

    if (![installedRect containsObject:name]) {
        SEL sel = @selector(layoutAttributesForElementsInRect:);
        __block IMP origRect = NULL;
        IMP rectHook = imp_implementationWithBlock(^NSArray<UICollectionViewLayoutAttributes *> *(
            UICollectionViewLayout *owner, CGRect rect) {
            NSArray<UICollectionViewLayoutAttributes *> *native =
                ((NSArray *(*)(id, SEL, CGRect))origRect)(owner, sel, rect);
            UICollectionView *cv = owner.collectionView;
            FQXMineShortcutFlowState *state = cv ? objc_getAssociatedObject(cv, FQXMineFlowStateKey) : nil;
            if (!state.active || state.layout != owner ||
                !state.columns || state.slotWidth < 44.0) {
                return native;
            }
            NSMutableArray<UICollectionViewLayoutAttributes *> *result = [NSMutableArray array];
            for (UICollectionViewLayoutAttributes *attr in native) {
                if (attr.representedElementCategory != UICollectionElementCategoryCell) {
                    [result addObject:[attr copy]];
                }
            }
            NSInteger sections = [cv numberOfSections];
            NSUInteger flatIdx = 0;
            for (NSInteger s = 0; s < sections; ++s) {
                NSInteger countInSec = [cv numberOfItemsInSection:s];
                for (NSInteger item = 0; item < countInSec; ++item) {
                    CGRect frame = FQXMineFrameForFlatIndex(state, flatIdx);
                    if (CGRectIntersectsRect(frame, rect)) {
                        NSIndexPath *ip = [NSIndexPath indexPathForItem:item inSection:s];
                        UICollectionViewLayoutAttributes *cellAttr = [owner layoutAttributesForItemAtIndexPath:ip];
                        if (cellAttr) [result addObject:cellAttr];
                    }
                    flatIdx++;
                }
            }
            return result;
        });
        if (FQXInstallMineValidatedHook(cls, sel, 3, "@", NULL, rectHook, &origRect)) {
            [installedRect addObject:name];
        } else {
            imp_removeBlock(rectHook);
        }
    }

    if (![installedBounds containsObject:name]) {
        SEL sel = @selector(shouldInvalidateLayoutForBoundsChange:);
        __block IMP origBounds = NULL;
        IMP boundsHook = imp_implementationWithBlock(^BOOL(UICollectionViewLayout *owner, CGRect newBounds) {
            UICollectionView *cv = owner.collectionView;
            FQXMineShortcutFlowState *state = cv ? objc_getAssociatedObject(cv, FQXMineFlowStateKey) : nil;
            if (state.active && state.layout == owner) return YES;
            return ((BOOL (*)(id, SEL, CGRect))origBounds)(owner, sel, newBounds);
        });
        if (FQXInstallMineValidatedHook(cls, sel, 3, "B", "c", boundsHook, &origBounds)) {
            [installedBounds addObject:name];
        } else {
            imp_removeBlock(boundsHook);
        }
    }

    if (![installedTargetOffset containsObject:name]) {
        SEL sel = @selector(targetContentOffsetForProposedContentOffset:withScrollingVelocity:);
        __block IMP origOffset = NULL;
        IMP offsetHook = imp_implementationWithBlock(^CGPoint(UICollectionViewLayout *owner,
                                                              CGPoint proposed, CGPoint velocity) {
            CGPoint native = ((CGPoint (*)(id, SEL, CGPoint, CGPoint))origOffset)(owner, sel, proposed, velocity);
            UICollectionView *cv = owner.collectionView;
            FQXMineShortcutFlowState *state = cv ? objc_getAssociatedObject(cv, FQXMineFlowStateKey) : nil;
            if (state.active && state.layout == owner && state.pages > 0 && state.viewportSize.width > 1.0) {
                CGFloat vw = state.viewportSize.width;
                NSInteger page = (NSInteger)llround(proposed.x / vw);
                if (page < 0) page = 0;
                if (page >= (NSInteger)state.pages) page = (NSInteger)state.pages - 1;
                return CGPointMake((CGFloat)page * vw, native.y);
            }
            return native;
        });
        if (FQXInstallMineValidatedHook(cls, sel, 4, "{CGPoint", NULL, offsetHook, &origOffset)) {
            [installedTargetOffset addObject:name];
        } else {
            imp_removeBlock(offsetHook);
        }
    }
}

static void FQXEnforceMineVisibleCellFrames(UICollectionView *collection) {
    FQXMineShortcutFlowState *state = objc_getAssociatedObject(collection, FQXMineFlowStateKey);
    if (!state.active || state.layout != collection.collectionViewLayout ||
        state.columns != 4 || state.slotWidth < 44.0) return;
    NSMutableSet<UICollectionViewCell *> *visited = [NSMutableSet set];
    for (NSIndexPath *ip in [collection indexPathsForVisibleItems]) {
        UICollectionViewCell *cell = [collection cellForItemAtIndexPath:ip];
        if (!cell) continue;
        [visited addObject:cell];
        NSUInteger flatIdx = FQXMineFlatIndexForIndexPath(collection, ip);
        if (flatIdx == NSNotFound) continue;
        CGRect expected = FQXMineFrameForFlatIndex(state, flatIdx);
        CGRect cur = cell.frame;
        if (fabs(cur.origin.x - expected.origin.x) > 0.5 ||
            fabs(cur.origin.y - expected.origin.y) > 0.5 ||
            fabs(CGRectGetWidth(cur) - CGRectGetWidth(expected)) > 0.5 ||
            fabs(CGRectGetHeight(cur) - CGRectGetHeight(expected)) > 0.5) {
            BOOL prevInFlight = FQXMineCellRelayoutInFlight;
            FQXMineCellRelayoutInFlight = YES;
            cell.frame = expected;
            FQXMineCellRelayoutInFlight = prevInFlight;
            FQXRelayoutMineTileAfterFrameChange(cell);
        }
    }
    for (UICollectionViewCell *cell in [collection visibleCells]) {
        if ([visited containsObject:cell]) continue;
        NSIndexPath *ip = [collection indexPathForCell:cell];
        NSUInteger flatIdx = FQXMineFlatIndexForIndexPath(collection, ip);
        if (flatIdx == NSNotFound) continue;
        CGRect expected = FQXMineFrameForFlatIndex(state, flatIdx);
        CGRect cur = cell.frame;
        if (fabs(cur.origin.x - expected.origin.x) > 0.5 ||
            fabs(cur.origin.y - expected.origin.y) > 0.5 ||
            fabs(CGRectGetWidth(cur) - CGRectGetWidth(expected)) > 0.5 ||
            fabs(CGRectGetHeight(cur) - CGRectGetHeight(expected)) > 0.5) {
            BOOL prevInFlight = FQXMineCellRelayoutInFlight;
            FQXMineCellRelayoutInFlight = YES;
            cell.frame = expected;
            FQXMineCellRelayoutInFlight = prevInFlight;
            FQXRelayoutMineTileAfterFrameChange(cell);
        }
    }
}

static void FQXRestoreMineFlow(UICollectionView *collection) {
    FQXMineShortcutFlowState *state = objc_getAssociatedObject(collection, FQXMineFlowStateKey);
    if (!state) return;
    state.active = NO;
    objc_setAssociatedObject(collection, FQXMineDeferredSyncKey, nil, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
    if (state.layout == collection.collectionViewLayout) {
        if (state.hasSavedFlowProps && [state.layout isKindOfClass:UICollectionViewFlowLayout.class]) {
            UICollectionViewFlowLayout *flow = (UICollectionViewFlowLayout *)state.layout;
            if (CGSizeEqualToSize(flow.itemSize, state.appliedItemSize)) {
                flow.itemSize = state.savedItemSize;
            }
            flow.estimatedItemSize = state.savedEstimatedItemSize;
            flow.sectionInset = state.savedSectionInset;
            flow.minimumLineSpacing = state.savedLineSpacing;
            flow.minimumInteritemSpacing = state.savedInteritemSpacing;
        }
        [state.layout invalidateLayout];
    }
    if (state.hasSavedContentInset) {
        UIEdgeInsets ins = collection.contentInset;
        ins.left = state.savedContentInset.left;
        ins.right = state.savedContentInset.right;
        collection.contentInset = ins;
    }
    collection.pagingEnabled = state.savedPaging;
    FQXUpdateMinePageControl(state.pageControl, state.savedPageCount, 0);
    objc_setAssociatedObject(collection, FQXMineFlowStateKey, nil, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

static void FQXCompleteMineFlowPage(UICollectionView *collection) {
    FQXMineShortcutFlowState *state = objc_getAssociatedObject(collection, FQXMineFlowStateKey);
    if (!state.active || state.layout != collection.collectionViewLayout) return;
    NSUInteger count = FQXMineTotalItemCount(collection);
    if (!count || !state.columns) return;
    NSUInteger pages = (count + state.columns - 1) / state.columns;
    state.totalCount = count;
    state.pages = pages;
    CGFloat width = state.viewportSize.width > 0.0 ? state.viewportSize.width : CGRectGetWidth(collection.bounds);
    CGFloat vh = state.viewportHeight > 0.0 ? state.viewportHeight : CGRectGetHeight(collection.bounds);
    CGSize contentSize = CGSizeMake(width * pages, vh);
    if (!CGSizeEqualToSize(collection.contentSize, contentSize)) collection.contentSize = contentSize;
    if (state.pageControl) {
        NSInteger cur = MAX(0, MIN((NSInteger)pages - 1,
            (NSInteger)llround(collection.contentOffset.x / MAX(1.0, width))));
        FQXUpdateMinePageControl(state.pageControl, (NSInteger)pages, cur);
    }
}

static void FQXInstallMineScrollHook(UICollectionView *collection);
static void FQXSyncMineFlow(UICollectionView *collection);

static void FQXScheduleDeferredMineCollectionPass(UICollectionView *collection) {
    if (!collection || [objc_getAssociatedObject(collection, FQXMineDeferredSyncKey) boolValue]) return;
    objc_setAssociatedObject(collection, FQXMineDeferredSyncKey, @YES, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
    __weak UICollectionView *weakCV = collection;
    dispatch_async(dispatch_get_main_queue(), ^{
        UICollectionView *strongCV = weakCV;
        if (!strongCV) return;
        objc_setAssociatedObject(strongCV, FQXMineDeferredSyncKey, nil, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
        if (!strongCV.window || !FQXMineShortcutCardForView(strongCV)) return;
        FQXMineShortcutFlowState *st = objc_getAssociatedObject(strongCV, FQXMineFlowStateKey);
        if ((!st || !st.active || st.layout != strongCV.collectionViewLayout) &&
            !FQXMineViewportSyncInFlight && CGRectGetWidth(strongCV.bounds) >= 176.0) {
            FQXMineViewportSyncInFlight = YES;
            FQXInstallMineScrollHook(strongCV);
            FQXSyncMineFlow(strongCV);
            FQXMineViewportSyncInFlight = NO;
            st = objc_getAssociatedObject(strongCV, FQXMineFlowStateKey);
        }
        if (!st || !st.active || st.layout != strongCV.collectionViewLayout) return;
        [st.layout invalidateLayout];
        [strongCV setNeedsLayout];
        [strongCV layoutIfNeeded];
        FQXEnforceMineVisibleCellFrames(strongCV);
        FQXCompleteMineFlowPage(strongCV);
    });
}

static void FQXSyncMineFlow(UICollectionView *collection) {
    FQXMineShortcutFlowState *state = objc_getAssociatedObject(collection, FQXMineFlowStateKey);
    UICollectionViewLayout *layout = collection.collectionViewLayout;
    UIView *fold = FQXMineShortcutFold(collection);
    UIView *card = FQXMineShortcutCardForView(collection);
    NSUInteger count = FQXMineTotalItemCount(collection);
    CGFloat width = CGRectGetWidth(collection.bounds);
    UIView *outerRow = FQXMineOuterRowForView(collection);
    if (outerRow) {
        CGFloat cardW = CGRectGetWidth(outerRow.bounds);
        for (UIView *sub in outerRow.subviews) {
            if ([sub isKindOfClass:UIVisualEffectView.class] && CGRectGetWidth(sub.bounds) >= 176.0 &&
                CGRectGetWidth(sub.bounds) < cardW) {
                cardW = CGRectGetWidth(sub.bounds);
                break;
            }
        }
        UIView *content = FQXObjGet(outerRow, "contentView");
        if ([content isKindOfClass:UIView.class]) {
            for (UIView *sub in content.subviews) {
                if ([sub isKindOfClass:UIVisualEffectView.class] && CGRectGetWidth(sub.bounds) >= 176.0 &&
                    CGRectGetWidth(sub.bounds) < cardW) {
                    cardW = CGRectGetWidth(sub.bounds);
                    break;
                }
            }
        }
        if (cardW >= 176.0 && width > cardW + 4.0) {
            width = cardW;
        }
    }
    CGFloat boundsHeight = CGRectGetHeight(collection.bounds);
    BOOL supported = card != nil && layout != nil &&
        count > 0 && count <= 40 && width >= 176.0 && boundsHeight >= 32.0 && boundsHeight <= 220.0;
    if (!supported || (state && state.layout != layout)) {
        FQXRestoreMineFlow(collection);
        if (!supported) return;
        state = nil;
    }

    UICollectionViewFlowLayout *flow = [layout isKindOfClass:UICollectionViewFlowLayout.class]
        ? (UICollectionViewFlowLayout *)layout : nil;
    id<UICollectionViewDelegateFlowLayout> delegate = (id)collection.delegate;
    UIEdgeInsets inset = flow ? flow.sectionInset : UIEdgeInsetsZero;
    if (flow && [delegate respondsToSelector:@selector(collectionView:layout:insetForSectionAtIndex:)]) {
        inset = [delegate collectionView:collection layout:flow insetForSectionAtIndex:0];
    }
    CGFloat topInset = MAX(0.0, inset.top);
    CGFloat bottomInset = MAX(0.0, inset.bottom);
    CGFloat contentHeight = boundsHeight - collection.adjustedContentInset.top - collection.adjustedContentInset.bottom;
    if (contentHeight < 32.0) contentHeight = boundsHeight;
    if (contentHeight - topInset - bottomInset < 32.0) {
        topInset = 0.0;
        bottomInset = 0.0;
    }
    CGFloat planHeight = MAX(44.0, contentHeight);
    CGFloat planTop = (planHeight - topInset - bottomInset >= 44.0) ? topInset : 0.0;
    CGFloat planBottom = (planHeight - planTop - bottomInset >= 44.0) ? bottomInset : 0.0;
    FQXMineShortcutPlan plan = FQXPlanMineShortcuts(width, planHeight, width / 5.0,
                                                    0.0, planTop, planBottom, count);
    if (!plan.valid || plan.columns != 4) {
        FQXRestoreMineFlow(collection);
        return;
    }
    CGFloat actualItemHeight = MAX(32.0, contentHeight - topInset - bottomInset);

    FQXInstallMineLayoutHooks(layout);
    if (flow) {
        FQXInstallMineItemSizeHook(delegate);
        FQXInstallMineSectionInsetHook(delegate);
    }

    if (!state) {
        state = [FQXMineShortcutFlowState new];
        state.layout = layout;
        if (flow) {
            state.savedItemSize = flow.itemSize;
            state.savedEstimatedItemSize = flow.estimatedItemSize;
            state.savedSectionInset = flow.sectionInset;
            state.savedLineSpacing = flow.minimumLineSpacing;
            state.savedInteritemSpacing = flow.minimumInteritemSpacing;
            state.hasSavedFlowProps = YES;
        }
        state.savedContentInset = collection.contentInset;
        state.hasSavedContentInset = YES;
        state.nativeItemSize = flow ? flow.itemSize : CGSizeZero;
        state.savedPaging = collection.pagingEnabled;
        state.pageControl = FQXMinePageControl(fold, card);
        state.savedPageCount = FQXReadMinePageControlCount(state.pageControl);
        objc_setAssociatedObject(collection, FQXMineFlowStateKey, state, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
    } else if (!state.pageControl) {
        state.pageControl = FQXMinePageControl(fold, card);
        if (state.pageControl) state.savedPageCount = FQXReadMinePageControlCount(state.pageControl);
    }

    CGSize itemSize = CGSizeMake(plan.itemWidth, actualItemHeight);
    UIEdgeInsets activeInset = UIEdgeInsetsMake(topInset, 0.0, bottomInset, 0.0);
    CGSize targetViewportSize = CGSizeMake(width, boundsHeight);
    BOOL flowChanged = flow && (
        !UIEdgeInsetsEqualToEdgeInsets(flow.sectionInset, activeInset) ||
        !CGSizeEqualToSize(flow.itemSize, itemSize) ||
        !CGSizeEqualToSize(flow.estimatedItemSize, CGSizeZero) ||
        fabs(flow.minimumLineSpacing) > 0.25 ||
        fabs(flow.minimumInteritemSpacing) > 0.25);
    BOOL changed = !state.active || flowChanged ||
                   state.columns != plan.columns ||
                   state.pages != plan.pages ||
                   state.totalCount != count ||
                   fabs(state.slotWidth - plan.itemWidth) > 0.25 ||
                   fabs(state.itemHeight - actualItemHeight) > 0.25 ||
                   fabs(state.topInset - topInset) > 0.25 ||
                   !CGSizeEqualToSize(state.viewportSize, targetViewportSize);
    CGFloat oldWidth = state.viewportSize.width;
    state.columns = plan.columns;
    state.pages = plan.pages;
    state.totalCount = count;
    state.slotWidth = plan.itemWidth;
    state.itemHeight = actualItemHeight;
    state.topInset = topInset;
    state.appliedItemSize = itemSize;
    state.viewportSize = targetViewportSize;
    state.viewportHeight = contentHeight;
    state.active = YES;
    if (!collection.pagingEnabled) collection.pagingEnabled = YES;
    UIEdgeInsets cInset = collection.contentInset;
    if (fabs(cInset.left) > 0.5 || fabs(cInset.right) > 0.5) {
        cInset.left = 0.0;
        cInset.right = 0.0;
        collection.contentInset = cInset;
    }
    if (flow) {
        if (!CGSizeEqualToSize(flow.estimatedItemSize, CGSizeZero)) flow.estimatedItemSize = CGSizeZero;
        if (!CGSizeEqualToSize(flow.itemSize, itemSize)) flow.itemSize = itemSize;
        if (!UIEdgeInsetsEqualToEdgeInsets(flow.sectionInset, activeInset)) flow.sectionInset = activeInset;
        if (fabs(flow.minimumLineSpacing) > 0.25) flow.minimumLineSpacing = 0.0;
        if (fabs(flow.minimumInteritemSpacing) > 0.25) flow.minimumInteritemSpacing = 0.0;
    }
    if (changed) {
        // Preserve the page on rotation, not its obsolete absolute point offset.
        if (oldWidth > 0.0 && oldWidth != state.viewportSize.width &&
            !collection.dragging && !collection.decelerating) {
            NSInteger page = llround(collection.contentOffset.x / oldWidth);
            collection.contentOffset = CGPointMake(MAX(0, MIN((NSInteger)plan.pages - 1, page)) *
                                                     state.viewportSize.width, collection.contentOffset.y);
        }
        [layout invalidateLayout];
        [collection setNeedsLayout];
        FQXScheduleDeferredMineCollectionPass(collection);
    }
    FQXCompleteMineFlowPage(collection);
}

static void FQXInstallMineScrollHook(UICollectionView *collection) {
    objc_setAssociatedObject(collection, FQXMineScrollTrackedKey, @YES, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
    static NSMutableSet<NSString *> *installed;
    static NSMutableSet<NSString *> *installedCS;
    static dispatch_once_t once;
    dispatch_once(&once, ^{
        installed = [NSMutableSet set];
        installedCS = [NSMutableSet set];
    });
    Class cls = FQXRealHookClass(collection);
    if (!cls || cls == UIView.class || cls == NSObject.class) return;
    NSString *name = NSStringFromClass(cls);
    if (!name.length) return;
    if (![installed containsObject:name]) {
        __block IMP original = NULL;
        IMP hook = imp_implementationWithBlock(^(UICollectionView *view) {
            BOOL tracked = [objc_getAssociatedObject(view, FQXMineScrollTrackedKey) boolValue];
            UIView *card = tracked ? FQXMineShortcutCardForView(view) : nil;
            if (tracked && card && CGRectGetWidth(view.bounds) >= 176.0) {
                FQXSyncMineFlow(view);
            }
            ((void (*)(id, SEL))original)(view, @selector(layoutSubviews));
            if (!tracked) return;
            UIView *curCard = FQXMineShortcutCardForView(view);
            BOOL prevInFlight = FQXMineViewportSyncInFlight;
            FQXMineViewportSyncInFlight = YES;
            [FQXMineShortcutViewport applyToView:view enabled:(FQXGlassEnabled() && curCard != nil)];
            FQXMineViewportSyncInFlight = prevInFlight;
            if (curCard) {
                FQXEnforceMineVisibleCellFrames(view);
                FQXCompleteMineFlowPage(view);
            } else {
                FQXRestoreMineFlow(view);
            }
        });
        if (FQXInstallOwnedHook(cls, @selector(layoutSubviews), NO, "v16@0:8", hook, &original))
            [installed addObject:name];
        else imp_removeBlock(hook);
    }
    if (![name hasPrefix:@"UI"] && ![installedCS containsObject:name]) {
        SEL csSel = @selector(setContentSize:);
        __block IMP origCS = NULL;
        IMP csHook = imp_implementationWithBlock(^(UICollectionView *view, CGSize cs) {
            FQXMineShortcutFlowState *state = objc_getAssociatedObject(view, FQXMineFlowStateKey);
            if (state.active && state.layout == view.collectionViewLayout &&
                state.pages > 0 && state.viewportSize.width > 0.0 && state.viewportHeight > 0.0) {
                CGSize targetCS = CGSizeMake(state.viewportSize.width * (CGFloat)state.pages, state.viewportHeight);
                if (fabs(cs.width - targetCS.width) > 1.0 || fabs(cs.height - targetCS.height) > 1.0) {
                    cs = targetCS;
                }
            }
            ((void (*)(id, SEL, CGSize))origCS)(view, csSel, cs);
        });
        if (FQXInstallMineValidatedHook(cls, csSel, 3, "v", NULL, csHook, &origCS))
            [installedCS addObject:name];
        else imp_removeBlock(csHook);
    }
}

static void FQXSyncMineContainerUniversal(UIView *container) {
    if (![container isKindOfClass:UIView.class] || FQXIsInsideMineSidebar(container)) return;
    UIView *outerRow = FQXMineOuterRowForView(container);
    if (outerRow && [outerRow respondsToSelector:@selector(lynxVipView)]) return;
    UICollectionView *collection = nil;
    if ([container isKindOfClass:UICollectionView.class]) {
        CGFloat h = CGRectGetHeight(container.bounds);
        if (h >= 32.0 && h <= 220.0) collection = (UICollectionView *)container;
    } else {
        id propCV = FQXObjGet(container, "collectionView");
        if ([propCV isKindOfClass:UICollectionView.class] && [(UIView *)propCV isDescendantOfView:container]) {
            CGFloat h = CGRectGetHeight([(UIView *)propCV bounds]);
            if (h >= 32.0 && h <= 220.0) collection = (UICollectionView *)propCV;
        }
        if (!collection) {
            collection = FQXFindMineCollectionView(container, 8);
        }
    }
    if (collection) {
        if (CGRectGetWidth(collection.bounds) < 176.0 || CGRectGetHeight(collection.bounds) > 220.0) return;
        FQXInstallMineScrollHook(collection);
        FQXSyncMineFlow(collection);
        FQXEnforceMineVisibleCellFrames(collection);
        [FQXMineShortcutViewport applyToView:collection enabled:(FQXGlassEnabled() && FQXMineShortcutCardForView(collection) != nil)];
        return;
    }
    UIView *card = outerRow ?: FQXMineShortcutCardForView(container) ?: container;
    UIScrollView *plainSV = ([container isKindOfClass:UIScrollView.class] &&
                             ![container isKindOfClass:UITableView.class] &&
                             ![container isKindOfClass:UICollectionView.class] &&
                             CGRectGetWidth(container.bounds) >= 160.0 &&
                             CGRectGetHeight(container.bounds) >= 32.0 &&
                             CGRectGetHeight(container.bounds) <= 240.0)
        ? (UIScrollView *)container
        : FQXFindMinePlainScrollView(container, 8);
    if (plainSV && FQXSyncMinePlainScrollView(card, plainSV)) return;
    FQXSyncMineDirectTileHost(card);
}

static void (*OrigScrollFoldLayout)(id, SEL);
static void HookScrollFoldLayout(UIView *self, SEL _cmd) {
    if (OrigScrollFoldLayout) OrigScrollFoldLayout(self, _cmd);
    if (FQXIsInsideMineSidebar(self)) return;
    BOOL clipEnabled = FQXGlassEnabled() && FQXMineShortcutFold(self) == self;
    if (!FQXMineViewportSyncInFlight) {
        FQXMineViewportSyncInFlight = YES;
        FQXSyncMineContainerUniversal(self);
        [FQXMineShortcutViewport applyToView:self enabled:clipEnabled];
        FQXMineViewportSyncInFlight = NO;
    }
}

static void (*OrigMineShortcutCardLayout)(id, SEL);
static void HookMineShortcutCardLayout(UIView *self, SEL _cmd) {
    if (OrigMineShortcutCardLayout) OrigMineShortcutCardLayout(self, _cmd);
    if (!FQXMineShortcutCardForView(self)) return;
    if (!FQXMineViewportSyncInFlight) {
        FQXMineViewportSyncInFlight = YES;
        FQXSyncMineContainerUniversal(self);
        FQXMineViewportSyncInFlight = NO;
    }
}

static void (*OrigMineCard1Layout)(id, SEL);
static void HookMineCard1Layout(UIView *self, SEL _cmd) {
    if (OrigMineCard1Layout) OrigMineCard1Layout(self, _cmd);
    if ([self respondsToSelector:@selector(lynxVipView)] || FQXIsInsideMineSidebar(self)) return;
    if (!FQXMineViewportSyncInFlight) {
        FQXMineViewportSyncInFlight = YES;
        FQXSyncMineContainerUniversal(self);
        FQXMineViewportSyncInFlight = NO;
    }
}

static void FQXSyncOwnerCollectionFromShortcutCell(UICollectionViewCell *self) {
    if (FQXMineCellRelayoutInFlight || FQXIsInsideMineSidebar(self)) return;
    UIView *outerRow = FQXMineOuterRowForView(self);
    UIView *card = outerRow ?: FQXMineShortcutCardForView(self);
    if (!card) return;
    UICollectionView *ownerCV = nil;
    UIScrollView *ownerSV = nil;
    for (UIView *cur = self.superview; cur; cur = cur.superview) {
        if ([cur isKindOfClass:UICollectionView.class] &&
            CGRectGetWidth(cur.bounds) >= 160.0 && CGRectGetHeight(cur.bounds) <= 220.0) {
            ownerCV = (UICollectionView *)cur;
            break;
        }
        if (!ownerSV && [cur isKindOfClass:UIScrollView.class] && ![cur isKindOfClass:UITableView.class] &&
            CGRectGetWidth(cur.bounds) >= 160.0 && CGRectGetHeight(cur.bounds) <= 240.0) {
            ownerSV = (UIScrollView *)cur;
        }
        if (cur == outerRow) break;
    }
    if (ownerCV) {
        FQXInstallMineScrollHook(ownerCV);
        FQXMineShortcutFlowState *state = objc_getAssociatedObject(ownerCV, FQXMineFlowStateKey);
        if (!state || !state.active ||
            state.totalCount != FQXMineTotalItemCount(ownerCV) ||
            CGRectGetWidth(ownerCV.bounds) < 176.0) {
            BOOL prevInFlight = FQXMineViewportSyncInFlight;
            FQXMineViewportSyncInFlight = YES;
            FQXSyncMineFlow(ownerCV);
            [FQXMineShortcutViewport applyToView:ownerCV enabled:FQXGlassEnabled()];
            FQXMineViewportSyncInFlight = prevInFlight;
        }
        FQXEnforceMineVisibleCellFrames(ownerCV);
    } else if (ownerSV) {
        BOOL prevInFlight = FQXMineViewportSyncInFlight;
        FQXMineViewportSyncInFlight = YES;
        FQXSyncMinePlainScrollView(card, ownerSV);
        [FQXMineShortcutViewport applyToView:ownerSV enabled:FQXGlassEnabled()];
        FQXMineViewportSyncInFlight = prevInFlight;
    } else {
        FQXSyncMineDirectTileHost(card);
    }
}

static UICollectionViewLayoutAttributes *FQXApplyMineCellLayoutAttributes(UICollectionViewCell *self,
                                                                          UICollectionViewLayoutAttributes *attrs) {
    if (!attrs || !attrs.indexPath || FQXIsInsideMineSidebar(self)) return attrs;
    UIView *outerRow = FQXMineOuterRowForView(self);
    UICollectionView *ownerCV = nil;
    for (UIView *cur = self.superview; cur; cur = cur.superview) {
        if ([cur isKindOfClass:UICollectionView.class] &&
            CGRectGetWidth(cur.bounds) >= 160.0 && CGRectGetHeight(cur.bounds) <= 220.0) {
            ownerCV = (UICollectionView *)cur;
            break;
        }
        if (cur == outerRow) break;
    }
    if (ownerCV && (outerRow || FQXMineShortcutCardForView(ownerCV))) {
        FQXMineShortcutFlowState *state = objc_getAssociatedObject(ownerCV, FQXMineFlowStateKey);
        if ((!state || !state.active) && CGRectGetWidth(ownerCV.bounds) >= 176.0) {
            FQXScheduleDeferredMineCollectionPass(ownerCV);
        }
        if (state.active && state.columns == 4 && state.slotWidth >= 44.0) {
            NSUInteger flatIdx = FQXMineFlatIndexForIndexPath(ownerCV, attrs.indexPath);
            if (flatIdx != NSNotFound) {
                CGRect target = FQXMineFrameForFlatIndex(state, flatIdx);
                if (!CGRectEqualToRect(attrs.frame, target)) {
                    UICollectionViewLayoutAttributes *effective = [attrs copy];
                    effective.frame = target;
                    return effective;
                }
            }
        }
    }
    return attrs;
}

static CGRect FQXRewriteMineCellFrame(UICollectionViewCell *cell, CGRect incoming) {
    if (FQXMineCellRelayoutInFlight || FQXIsInsideMineSidebar(cell)) return incoming;
    UIView *outerRow = FQXMineOuterRowForView(cell);
    UICollectionView *ownerCV = nil;
    for (UIView *cur = cell.superview; cur; cur = cur.superview) {
        if ([cur isKindOfClass:UICollectionView.class] &&
            CGRectGetWidth(cur.bounds) >= 160.0 && CGRectGetHeight(cur.bounds) <= 220.0) {
            ownerCV = (UICollectionView *)cur;
            break;
        }
        if (cur == outerRow) break;
    }
    if (!ownerCV) return incoming;
    FQXMineShortcutFlowState *state = objc_getAssociatedObject(ownerCV, FQXMineFlowStateKey);
    if ((!state || !state.active) && CGRectGetWidth(ownerCV.bounds) >= 176.0) {
        FQXScheduleDeferredMineCollectionPass(ownerCV);
    }
    if (state.active && state.columns == 4 && state.slotWidth >= 44.0) {
        NSIndexPath *ip = [ownerCV indexPathForCell:cell];
        if (ip) {
            NSUInteger flatIdx = FQXMineFlatIndexForIndexPath(ownerCV, ip);
            if (flatIdx != NSNotFound) {
                return FQXMineFrameForFlatIndex(state, flatIdx);
            }
        } else {
            FQXScheduleDeferredMineCollectionPass(ownerCV);
        }
    }
    return incoming;
}

static void (*OrigMineFunCellSetFrame)(id, SEL, CGRect);
static void HookMineFunCellSetFrame(UICollectionViewCell *self, SEL _cmd, CGRect frame) {
    if (OrigMineFunCellSetFrame) OrigMineFunCellSetFrame(self, _cmd, FQXRewriteMineCellFrame(self, frame));
}

static void (*OrigMineOrderCellSetFrame)(id, SEL, CGRect);
static void HookMineOrderCellSetFrame(UICollectionViewCell *self, SEL _cmd, CGRect frame) {
    if (OrigMineOrderCellSetFrame) OrigMineOrderCellSetFrame(self, _cmd, FQXRewriteMineCellFrame(self, frame));
}

static void (*OrigMineEntryItemSetFrame)(id, SEL, CGRect);
static void HookMineEntryItemSetFrame(UICollectionViewCell *self, SEL _cmd, CGRect frame) {
    if (OrigMineEntryItemSetFrame) OrigMineEntryItemSetFrame(self, _cmd, FQXRewriteMineCellFrame(self, frame));
}

static void (*OrigMineFunCellApplyAttrs)(id, SEL, id);
static void HookMineFunCellApplyAttrs(UICollectionViewCell *self, SEL _cmd, UICollectionViewLayoutAttributes *attrs) {
    UICollectionViewLayoutAttributes *effective = FQXApplyMineCellLayoutAttributes(self, attrs);
    if (OrigMineFunCellApplyAttrs) OrigMineFunCellApplyAttrs(self, _cmd, effective);
}

static void (*OrigMineOrderCellApplyAttrs)(id, SEL, id);
static void HookMineOrderCellApplyAttrs(UICollectionViewCell *self, SEL _cmd, UICollectionViewLayoutAttributes *attrs) {
    UICollectionViewLayoutAttributes *effective = FQXApplyMineCellLayoutAttributes(self, attrs);
    if (OrigMineOrderCellApplyAttrs) OrigMineOrderCellApplyAttrs(self, _cmd, effective);
}

static void (*OrigMineEntryItemApplyAttrs)(id, SEL, id);
static void HookMineEntryItemApplyAttrs(UICollectionViewCell *self, SEL _cmd, UICollectionViewLayoutAttributes *attrs) {
    UICollectionViewLayoutAttributes *effective = FQXApplyMineCellLayoutAttributes(self, attrs);
    if (OrigMineEntryItemApplyAttrs) OrigMineEntryItemApplyAttrs(self, _cmd, effective);
}

static void (*OrigMineFunCellLayoutForBadge)(id, SEL);
static void HookMineFunCellLayoutForBadge(UICollectionViewCell *self, SEL _cmd) {
    FQXSyncOwnerCollectionFromShortcutCell(self);
    if (!CGRectEqualToRect(self.contentView.frame, self.bounds)) {
        self.contentView.frame = self.bounds;
    }
    if (OrigMineFunCellLayoutForBadge) OrigMineFunCellLayoutForBadge(self, _cmd);
    FQXSyncOwnerCollectionFromShortcutCell(self);
    if (!FQXGlassEnabled()) return;
    UIView *content = self.contentView;
    if (!content) return;
    UIView *glyph = FQXObjGet(self, "image") ?: FQXObjGet(self, "productImage");
    UIView *caption = FQXObjGet(self, "label") ?: FQXObjGet(self, "functionType");
    NSUInteger glassIdx = NSNotFound;
    for (NSUInteger i = 0; i < content.subviews.count; ++i) {
        if ([content.subviews[i] isKindOfClass:UIVisualEffectView.class]) {
            glassIdx = i;
            break;
        }
    }
    if (glassIdx == NSNotFound) return;
    for (UIView *sub in [content.subviews copy]) {
        if (sub == glyph || sub == caption || [sub isKindOfClass:UIVisualEffectView.class] || sub.hidden) continue;
        NSUInteger idx = [content.subviews indexOfObjectIdenticalTo:sub];
        if (idx != NSNotFound && idx < glassIdx) {
            [content bringSubviewToFront:sub];
        }
    }
}

static void (*OrigMineOrderCellLayout)(id, SEL);
static void HookMineOrderCellLayout(UICollectionViewCell *self, SEL _cmd) {
    FQXSyncOwnerCollectionFromShortcutCell(self);
    if (!CGRectEqualToRect(self.contentView.frame, self.bounds)) {
        self.contentView.frame = self.bounds;
    }
    if (OrigMineOrderCellLayout) OrigMineOrderCellLayout(self, _cmd);
    FQXSyncOwnerCollectionFromShortcutCell(self);
}

static void (*OrigMineEntryItemLayout)(id, SEL);
static void HookMineEntryItemLayout(UICollectionViewCell *self, SEL _cmd) {
    FQXSyncOwnerCollectionFromShortcutCell(self);
    if (!CGRectEqualToRect(self.contentView.frame, self.bounds)) {
        self.contentView.frame = self.bounds;
    }
    if (OrigMineEntryItemLayout) OrigMineEntryItemLayout(self, _cmd);
    FQXSyncOwnerCollectionFromShortcutCell(self);
}

#pragma mark - Short Drama Progress Bar Right-Overflow Clamp & Cold-Start Spacing Sync

static void FQXClampDramaProgressTrackToBounds(UIView *rail) {
    if (![rail isKindOfClass:UIView.class] || !rail.window || rail.hidden) return;
    CGFloat railW = CGRectGetWidth(rail.bounds);
    CGFloat winW = CGRectGetWidth(rail.window.bounds);
    if (railW < 120.0 || winW < 240.0 || railW >= winW - 8.0) return;

    CGFloat inset = 16.0;
    CGFloat targetTrackW = MAX(40.0, railW - inset * 2.0);
    CGFloat scale = 1.0;

    UIView *bgViews[2] = {
        FQXObjGet(rail, "progressBarBackgroundView"),
        FQXObjGet(rail, "customizedProgressBarBackgroundView")
    };
    for (int i = 0; i < 2; ++i) {
        UIView *bg = bgViews[i];
        if (![bg isKindOfClass:UIView.class] || bg.superview != rail) continue;
        CGRect f = bg.frame;
        if (CGRectGetWidth(f) > targetTrackW + 0.5) {
            if (scale == 1.0 && CGRectGetWidth(f) > 1.0) scale = targetTrackW / CGRectGetWidth(f);
            f.origin.x = inset;
            f.size.width = targetTrackW;
            bg.frame = f;
        } else if (f.origin.x < inset - 0.5 || CGRectGetMaxX(f) > railW - inset + 0.5) {
            f.origin.x = inset;
            f.size.width = MIN(CGRectGetWidth(f), targetTrackW);
            bg.frame = f;
        }
    }

    for (UIView *sub in rail.subviews) {
        if (sub == bgViews[0] || sub == bgViews[1] || sub.hidden) continue;
        CGRect f = sub.frame;
        CGFloat w = CGRectGetWidth(f);
        CGFloat h = CGRectGetHeight(f);
        if (w <= 0.1 || h <= 0.1) continue;
        if (h <= 10.0 && w > 18.0) {
            if (w > targetTrackW + 0.5 || CGRectGetMaxX(f) > railW - inset + 0.5) {
                if (scale == 1.0 && w > targetTrackW + 0.5) scale = targetTrackW / w;
                CGFloat scaledW = (w > targetTrackW + 0.5) ? MIN(targetTrackW, w * scale) : MIN(w, targetTrackW);
                f.origin.x = MAX(inset, MIN(f.origin.x, railW - inset - scaledW));
                f.size.width = scaledW;
                sub.frame = f;
            }
        } else if (w <= 20.0 && h <= 20.0) {
            CGFloat cx = CGRectGetMidX(f);
            if (cx > railW - inset + 0.5) {
                CGFloat offset = (cx - inset) * (scale < 0.999 ? scale : (targetTrackW / MAX(1.0, winW - inset * 2.0)));
                CGFloat newCX = MAX(inset, MIN(railW - inset, inset + offset));
                f.origin.x = newCX - w * 0.5;
                sub.frame = f;
            }
        }
    }
}

static void FQXTriggerEnclosingDramaControlLayout(UIView *view) {
    Class ctrlCls = NSClassFromString(@"FQVShortVideoVPlayerControlView");
    Class outerCls = NSClassFromString(@"SSShortVideoOutterMultiGenreFeedControlView");
    for (UIView *p = view; p; p = p.superview) {
        if ((ctrlCls && [p isKindOfClass:ctrlCls]) || (outerCls && [p isKindOfClass:outerCls])) {
            [p setNeedsLayout];
            return;
        }
    }
}

static void (*OrigDramaProgLayoutSubviews)(id, SEL);
static void HookDramaProgLayoutSubviews(UIView *self, SEL _cmd) {
    if (OrigDramaProgLayoutSubviews) OrigDramaProgLayoutSubviews(self, _cmd);
    FQXClampDramaProgressTrackToBounds(self);
}

static void (*OrigDramaProgLayoutProgress)(id, SEL);
static void HookDramaProgLayoutProgress(UIView *self, SEL _cmd) {
    if (OrigDramaProgLayoutProgress) OrigDramaProgLayoutProgress(self, _cmd);
    FQXClampDramaProgressTrackToBounds(self);
}

static void (*OrigDramaProgPlaying)(id, SEL, BOOL, BOOL);
static void HookDramaProgPlaying(UIView *self, SEL _cmd, BOOL playing, BOOL animate) {
    if (OrigDramaProgPlaying) OrigDramaProgPlaying(self, _cmd, playing, animate);
    FQXClampDramaProgressTrackToBounds(self);
}

static void (*OrigDramaProgActivated)(id, SEL, NSUInteger);
static void HookDramaProgActivated(UIView *self, SEL _cmd, NSUInteger state) {
    if (OrigDramaProgActivated) OrigDramaProgActivated(self, _cmd, state);
    FQXClampDramaProgressTrackToBounds(self);
}

static void (*OrigDramaProgState)(id, SEL, NSUInteger, BOOL);
static void HookDramaProgState(UIView *self, SEL _cmd, NSUInteger state, BOOL showDot) {
    if (OrigDramaProgState) OrigDramaProgState(self, _cmd, state, showDot);
    FQXClampDramaProgressTrackToBounds(self);
}

static void (*OrigDramaProgConfigure)(id, SEL, NSUInteger, id);
static void HookDramaProgConfigure(UIView *self, SEL _cmd, NSUInteger type, id maker) {
    if (OrigDramaProgConfigure) OrigDramaProgConfigure(self, _cmd, type, maker);
    FQXClampDramaProgressTrackToBounds(self);
}

static void (*OrigDramaProgDidMoveWindow)(id, SEL);
static void HookDramaProgDidMoveWindow(UIView *self, SEL _cmd) {
    if (OrigDramaProgDidMoveWindow) OrigDramaProgDidMoveWindow(self, _cmd);
    if (self.window) {
        FQXClampDramaProgressTrackToBounds(self);
        __weak UIView *weakSelf = self;
        dispatch_async(dispatch_get_main_queue(), ^{
            UIView *s = weakSelf;
            if (!s || !s.window) return;
            FQXTriggerEnclosingDramaControlLayout(s);
            FQXClampDramaProgressTrackToBounds(s);
        });
    }
}

static void (*OrigDramaControlDidMoveWindow)(id, SEL);
static void HookDramaControlDidMoveWindow(UIView *self, SEL _cmd) {
    if (OrigDramaControlDidMoveWindow) OrigDramaControlDidMoveWindow(self, _cmd);
    if (self.window) {
        [self setNeedsLayout];
        __weak UIView *weakSelf = self;
        dispatch_async(dispatch_get_main_queue(), ^{
            UIView *s = weakSelf;
            if (!s || !s.window) return;
            [s setNeedsLayout];
            [s layoutIfNeeded];
            UIView *prog = FQXObjGet(s, "progressContainer");
            if ([prog isKindOfClass:UIView.class]) FQXClampDramaProgressTrackToBounds(prog);
        });
    }
}

#pragma mark - Bookshelf Header 14-Toggle Visibility & Reflow ("书架顶部与筛选栏")

static const void *FQXShelfEditHiddenByUsKey = &FQXShelfEditHiddenByUsKey;
static const void *FQXShelfHiddenByUsKey = &FQXShelfHiddenByUsKey;
static const void *FQXShelfReflowAppliedKey = &FQXShelfReflowAppliedKey;
static const void *FQXShelfBaseMinXKey = &FQXShelfBaseMinXKey;
static const void *FQXShelfFilterSectionKey = &FQXShelfFilterSectionKey;

static BOOL FQXShelfOptionEnabled(NSString *key) {
    id stored = [NSUserDefaults.standardUserDefaults objectForKey:key];
    return stored ? [stored boolValue] : YES;
}

static BOOL FQXShelfReadingDurationEnabled(void) {
    return FQXShelfOptionEnabled(@"FanqieX.ShelfReadingDuration.1");
}

static BOOL FQXShelfFilterButtonEnabled(void) {
    return FQXShelfOptionEnabled(@"FanqieX.ShelfFilterButton.1");
}

static BOOL FQXShelfAnyFilterPillEnabled(void) {
    return FQXShelfOptionEnabled(@"FanqieX.ShelfFilterAll.1") ||
           FQXShelfOptionEnabled(@"FanqieX.ShelfFilterRead.1") ||
           FQXShelfOptionEnabled(@"FanqieX.ShelfFilterListen.1") ||
           FQXShelfOptionEnabled(@"FanqieX.ShelfFilterComic.1") ||
           FQXShelfOptionEnabled(@"FanqieX.ShelfFilterStar.1");
}

static BOOL FQXShelfRow3AllHidden(void) {
    return !FQXShelfAnyFilterPillEnabled() && !FQXShelfFilterButtonEnabled();
}

static NSHashTable<UIView *> *FQXTrackedShelfHeadersForEdit(void) {
    static NSHashTable<UIView *> *table;
    static dispatch_once_t once;
    dispatch_once(&once, ^{ table = [NSHashTable weakObjectsHashTable]; });
    return table;
}

static NSHashTable<UIView *> *FQXTrackedShelfTabViews(void) {
    static NSHashTable<UIView *> *table;
    static dispatch_once_t once;
    dispatch_once(&once, ^{ table = [NSHashTable weakObjectsHashTable]; });
    return table;
}

static NSHashTable<UIViewController *> *FQXTrackedShelf525VCs(void) {
    static NSHashTable<UIViewController *> *table;
    static dispatch_once_t once;
    dispatch_once(&once, ^{ table = [NSHashTable weakObjectsHashTable]; });
    return table;
}

static NSHashTable<UIViewController *> *FQXTrackedShelfSubVCs(void) {
    static NSHashTable<UIViewController *> *table;
    static dispatch_once_t once;
    dispatch_once(&once, ^{ table = [NSHashTable weakObjectsHashTable]; });
    return table;
}

static NSHashTable<UIView *> *FQXTrackedShelfFunctionCells(void) {
    static NSHashTable<UIView *> *table;
    static dispatch_once_t once;
    dispatch_once(&once, ^{ table = [NSHashTable weakObjectsHashTable]; });
    return table;
}

static NSHashTable<UIView *> *FQXTrackedShelfFilterHeaders(void) {
    static NSHashTable<UIView *> *table;
    static dispatch_once_t once;
    dispatch_once(&once, ^{ table = [NSHashTable weakObjectsHashTable]; });
    return table;
}

static NSHashTable<UICollectionView *> *FQXTrackedShelfFilterCollections(void) {
    static NSHashTable<UICollectionView *> *table;
    static dispatch_once_t once;
    dispatch_once(&once, ^{ table = [NSHashTable weakObjectsHashTable]; });
    return table;
}

static void FQXShelfApplyControlHidden(UIView *view, const void *key, BOOL hide) {
    if (![view isKindOfClass:UIView.class]) return;
    if (hide) {
        if (!view.hidden || view.alpha > 0.001 || view.userInteractionEnabled) {
            objc_setAssociatedObject(view, key, @YES, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
            view.hidden = YES;
            view.alpha = 0.0;
            view.userInteractionEnabled = NO;
        }
    } else if ([objc_getAssociatedObject(view, key) boolValue]) {
        objc_setAssociatedObject(view, key, nil, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
        view.hidden = NO;
        view.alpha = 1.0;
        view.userInteractionEnabled = YES;
    }
}

static NSString *FQXShelfFirstLabelText(UIView *view, NSInteger depth) {
    if (![view isKindOfClass:UIView.class] || depth > 3) return nil;
    if ([view isKindOfClass:UILabel.class]) {
        UILabel *lbl = (UILabel *)view;
        NSString *t = lbl.text.length ? lbl.text : lbl.attributedText.string;
        if (t.length) return t;
    }
    for (UIView *sub in view.subviews) {
        NSString *found = FQXShelfFirstLabelText(sub, depth + 1);
        if (found.length) return found;
    }
    return nil;
}

static NSString *FQXShelfTabKeyForCell(UIView *cell) {
    id model = FQXObjGet(cell, "cellModel") ?: FQXObjGet(cell, "model");
    NSString *title = nil;
    id titleObj = FQXObjGet(model, "title") ?: FQXObjGet(model, "name");
    if ([titleObj isKindOfClass:NSString.class]) title = titleObj;
    if (!title.length) {
        UILabel *lbl = FQXObjGet(cell, "titleLabel") ?: FQXObjGet(cell, "label");
        if ([lbl isKindOfClass:UILabel.class]) title = lbl.text;
    }
    if (!title.length) title = FQXShelfFirstLabelText(cell, 0);
    if (!title.length) return nil;
    if ([title containsString:@"书架"]) return @"FanqieX.ShelfTabBookshelf.1";
    if ([title containsString:@"历史"]) return @"FanqieX.ShelfTabHistory.1";
    if ([title containsString:@"收藏"]) return @"FanqieX.ShelfTabCollect.1";
    if ([title containsString:@"圈子"]) return @"FanqieX.ShelfTabCircle.1";
    return nil;
}

static NSString *FQXShelfFilterKeyForCell(UIView *cell) {
    NSString *title = nil;
    UILabel *lbl = FQXObjGet(cell, "textLabel") ?: FQXObjGet(cell, "titleLabel") ?: FQXObjGet(cell, "label");
    if ([lbl isKindOfClass:UILabel.class]) title = lbl.text;
    if (!title.length) {
        id model = FQXObjGet(cell, "model") ?: FQXObjGet(cell, "cellModel");
        id mTitle = FQXObjGet(model, "title") ?: FQXObjGet(model, "name");
        if ([mTitle isKindOfClass:NSString.class]) title = mTitle;
    }
    if (!title.length) title = FQXShelfFirstLabelText(cell, 0);
    if (!title.length) return nil;
    if ([title containsString:@"全部"]) return @"FanqieX.ShelfFilterAll.1";
    if ([title containsString:@"阅读"]) return @"FanqieX.ShelfFilterRead.1";
    if ([title containsString:@"听书"]) return @"FanqieX.ShelfFilterListen.1";
    if ([title containsString:@"漫剧"]) return @"FanqieX.ShelfFilterComic.1";
    if ([title containsString:@"星标"]) return @"FanqieX.ShelfFilterStar.1";
    return nil;
}

static void FQXReflowShelfCollectionCells(UICollectionView *cv,
                                          NSString *(*keyForCell)(UIView *),
                                          CGFloat gap,
                                          CGFloat fallbackStartX) {
    if (![cv isKindOfClass:UICollectionView.class] || CGRectGetWidth(cv.bounds) < 44.0) return;
    NSArray<NSIndexPath *> *ips = [[cv indexPathsForVisibleItems]
        sortedArrayUsingComparator:^NSComparisonResult(NSIndexPath *a, NSIndexPath *b) {
            if (a.section != b.section) return a.section < b.section ? NSOrderedAscending : NSOrderedDescending;
            if (a.item != b.item) return a.item < b.item ? NSOrderedAscending : NSOrderedDescending;
            return NSOrderedSame;
        }];
    if (!ips.count) return;

    NSMutableArray<UIView *> *visibleCells = [NSMutableArray arrayWithCapacity:ips.count];
    BOOL anyHidden = NO;
    CGFloat minStockX = CGFLOAT_MAX;
    BOOL hasFlowStock = ![objc_getAssociatedObject(cv, FQXShelfReflowAppliedKey) boolValue];
    for (NSIndexPath *ip in ips) {
        UICollectionViewCell *cell = [cv cellForItemAtIndexPath:ip];
        if (!cell) continue;
        if (hasFlowStock && CGRectGetMinX(cell.frame) < minStockX) {
            minStockX = CGRectGetMinX(cell.frame);
        }
        NSString *prefKey = keyForCell(cell);
        BOOL show = prefKey ? FQXShelfOptionEnabled(prefKey) : YES;
        FQXShelfApplyControlHidden(cell, FQXShelfHiddenByUsKey, !show);
        if (show) {
            [visibleCells addObject:cell];
        } else {
            anyHidden = YES;
        }
    }

    if (hasFlowStock && minStockX < CGFLOAT_MAX) {
        objc_setAssociatedObject(cv, FQXShelfBaseMinXKey, @(minStockX), OBJC_ASSOCIATION_RETAIN_NONATOMIC);
    }

    BOOL wasReflowed = [objc_getAssociatedObject(cv, FQXShelfReflowAppliedKey) boolValue];
    if (!anyHidden) {
        if (wasReflowed) {
            objc_setAssociatedObject(cv, FQXShelfReflowAppliedKey, nil, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
            [cv.collectionViewLayout invalidateLayout];
            [cv setNeedsLayout];
        }
        return;
    }

    NSNumber *savedStart = objc_getAssociatedObject(cv, FQXShelfBaseMinXKey);
    CGFloat x = savedStart ? MAX(0.0, savedStart.doubleValue) : fallbackStartX;
    objc_setAssociatedObject(cv, FQXShelfReflowAppliedKey, @YES, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
    for (UIView *cell in visibleCells) {
        CGRect f = cell.frame;
        if (fabs(f.origin.x - x) > 0.5) {
            f.origin.x = x;
            cell.frame = f;
        }
        x += CGRectGetWidth(f) + gap;
    }
}

static void FQXReflowShelfTabSelectView(UIView *tabSelectView) {
    if (![tabSelectView isKindOfClass:UIView.class]) return;
    [FQXTrackedShelfTabViews() addObject:tabSelectView];
    UICollectionView *cv = FQXObjGet(tabSelectView, "collectionView") ?: FQXFindMineCollectionView(tabSelectView, 3);
    FQXReflowShelfCollectionCells(cv, FQXShelfTabKeyForCell, 10.0, 0.0);
}

static void FQXSyncShelfHeaderRightButtons(UIViewController *controller) {
    if (!controller) return;
    Class shelf525Cls = NSClassFromString(@"SSBookShelf525ViewController");
    Class shelfSubCls = NSClassFromString(@"SSBookShelfSubViewController");
    if (shelf525Cls && [controller isKindOfClass:shelf525Cls]) {
        [FQXTrackedShelf525VCs() addObject:controller];
        UIViewController *curTab = FQXObjGet(controller, "currentTabVC");
        if (curTab && curTab != controller) {
            FQXSyncShelfHeaderRightButtons(curTab);
            return;
        }
    }
    if (shelfSubCls && [controller isKindOfClass:shelfSubCls]) {
        [FQXTrackedShelfSubVCs() addObject:controller];
    }

    UIView *holder = FQXObjGet(controller, "searchAndMoreView");
    UIView *searchBtn = FQXObjGet(controller, "searchButton");
    UIView *moreBtn = FQXObjGet(controller, "moreButton");
    BOOL showSearch = FQXShelfOptionEnabled(@"FanqieX.ShelfSearchButton.1");
    BOOL showMore = FQXShelfOptionEnabled(@"FanqieX.ShelfMoreButton.1");
    BOOL showEdit = FQXShelfEditButtonEnabled();

    if ([searchBtn isKindOfClass:UIView.class]) {
        FQXShelfApplyControlHidden(searchBtn, FQXShelfHiddenByUsKey, !showSearch);
    }
    if ([moreBtn isKindOfClass:UIView.class]) {
        FQXShelfApplyControlHidden(moreBtn, FQXShelfHiddenByUsKey, !showMore);
    }
    if (![holder isKindOfClass:UIView.class]) return;

    UIView *relocatedEdit = nil;
    for (UIView *sub in holder.subviews) {
        if (sub == searchBtn || sub == moreBtn || [sub isKindOfClass:UIVisualEffectView.class]) continue;
        if ([sub isKindOfClass:UIControl.class] || CGRectGetWidth(sub.bounds) >= 24.0) {
            NSString *txt = FQXShelfFirstLabelText(sub, 0);
            if ([sub isKindOfClass:UIButton.class] || [txt containsString:@"编辑"]) {
                relocatedEdit = sub;
                break;
            }
        }
    }
    if (relocatedEdit) {
        FQXShelfApplyControlHidden(relocatedEdit, FQXShelfEditHiddenByUsKey, !showEdit);
    }

    NSMutableArray<UIView *> *rightToLeft = [NSMutableArray arrayWithCapacity:3];
    for (UIView *candidate in @[moreBtn ?: NSNull.null, searchBtn ?: NSNull.null, relocatedEdit ?: NSNull.null]) {
        if (![candidate isKindOfClass:UIView.class]) continue;
        UIView *btn = candidate;
        if (![btn isDescendantOfView:holder] || btn.hidden || btn.alpha <= 0.01 ||
            CGRectGetWidth(btn.bounds) < 12.0) {
            continue;
        }
        [rightToLeft addObject:btn];
    }

    FQXShelfApplyControlHidden(holder, FQXShelfHiddenByUsKey, rightToLeft.count == 0);
    if (!rightToLeft.count) return;

    CGFloat rightEdge = CGRectGetWidth(holder.bounds);
    for (UIView *btn in rightToLeft) {
        CGFloat w = CGRectGetWidth(btn.bounds);
        CGFloat targetX = rightEdge - w;
        CGRect f = btn.frame;
        if (fabs(f.origin.x - targetX) > 0.5) {
            f.origin.x = targetX;
            btn.frame = f;
        }
        rightEdge = targetX - 8.0;
    }
}

static void FQXReflowShelfFilterCollectionView(UICollectionView *cv, UIView *headerOrNil) {
    (void)headerOrNil;
    if (![cv isKindOfClass:UICollectionView.class]) return;
    [FQXTrackedShelfFilterCollections() addObject:cv];
    FQXReflowShelfCollectionCells(cv, FQXShelfFilterKeyForCell, 8.0, 0.0);
}

static void FQXSyncShelfFilterHeaderView(UIView *header) {
    if (![header isKindOfClass:UIView.class]) return;
    [FQXTrackedShelfFilterHeaders() addObject:header];
    BOOL showAnyPill = FQXShelfAnyFilterPillEnabled();
    BOOL showFilter = FQXShelfFilterButtonEnabled();
    BOOL hideWholeRow3 = !showAnyPill && !showFilter;

    UIView *filterBtn = FQXObjGet(header, "filterButton");
    UIView *genreBtn = FQXObjGet(header, "fullGenreFilterButton");
    if ([filterBtn isKindOfClass:UIView.class]) {
        FQXShelfApplyControlHidden(filterBtn, FQXShelfHiddenByUsKey, !showFilter);
    }
    if ([genreBtn isKindOfClass:UIView.class]) {
        FQXShelfApplyControlHidden(genreBtn, FQXShelfHiddenByUsKey, !showFilter);
    }
    UIView *optionsView = FQXObjGet(header, "optionsView");
    if ([optionsView isKindOfClass:UIView.class]) {
        FQXShelfApplyControlHidden(optionsView, FQXShelfHiddenByUsKey, !showAnyPill);
        if (showAnyPill) {
            UICollectionView *cv = [optionsView isKindOfClass:UICollectionView.class]
                ? (UICollectionView *)optionsView
                : FQXFindMineCollectionView(optionsView, 3);
            if (cv) FQXReflowShelfFilterCollectionView(cv, header);
        }
    }
    FQXShelfApplyControlHidden(header, FQXShelfHiddenByUsKey, hideWholeRow3);
}

static BOOL FQXShelfHeaderHasVisibleControls(UIView *header) {
    if (![header isKindOfClass:UIView.class] || header.hidden || header.alpha < 0.05) return NO;
    for (UIView *sub in header.subviews) {
        if (sub.hidden || sub.alpha < 0.05 || CGRectGetWidth(sub.bounds) < 10.0 ||
            CGRectGetHeight(sub.bounds) < 10.0) {
            continue;
        }
        return YES;
    }
    return NO;
}

static void FQXApplyShelfEditVisibilityForHeader(UIView *header) {
    if (![header isKindOfClass:UIView.class]) return;
    [FQXTrackedShelfHeadersForEdit() addObject:header];
    UIView *editBtn = FQXObjGet(header, "editButton");
    if ([editBtn isKindOfClass:UIView.class]) {
        FQXShelfApplyControlHidden(editBtn, FQXShelfEditHiddenByUsKey, !FQXShelfEditButtonEnabled());
    }
    BOOL showDuration = FQXShelfReadingDurationEnabled();
    if (!showDuration) {
        UIView *durTip = FQXObjGet(header, "durationButton") ?: FQXObjGet(header, "readTimeButton");
        if ([durTip isKindOfClass:UIView.class]) {
            FQXShelfApplyControlHidden(durTip, FQXShelfHiddenByUsKey, YES);
        }
    } else {
        UIView *durTip = FQXObjGet(header, "durationButton") ?: FQXObjGet(header, "readTimeButton");
        if ([durTip isKindOfClass:UIView.class]) {
            FQXShelfApplyControlHidden(durTip, FQXShelfHiddenByUsKey, NO);
        }
    }
    BOOL row2Empty = !showDuration && !FQXShelfHeaderHasVisibleControls(header);
    FQXShelfApplyControlHidden(header, FQXShelfHiddenByUsKey, row2Empty);
}

static void FQXFixShelfHeaderEditFilterOverlap(UIView *header);

static void FQXApplyShelfFunctionCellLayout(UIView *cell) {
    if (![cell isKindOfClass:UIView.class]) return;
    [FQXTrackedShelfFunctionCells() addObject:cell];
    UIView *header = FQXObjGet(cell, "headerView");
    if ([header isKindOfClass:UIView.class]) {
        FQXApplyShelfEditVisibilityForHeader(header);
        FQXFixShelfHeaderEditFilterOverlap(header);
    }
    UIView *clip = FQXObjGet(cell, "filterClipView");
    if ([clip isKindOfClass:UIView.class]) {
        BOOL hideRow3 = FQXShelfRow3AllHidden();
        FQXShelfApplyControlHidden(clip, FQXShelfHiddenByUsKey, hideRow3);
        if (!hideRow3) {
            for (UIView *sub in clip.subviews) {
                Class filterHeaderCls = NSClassFromString(@"SSBookShelfFilterHeaderView");
                if (filterHeaderCls && [sub isKindOfClass:filterHeaderCls]) {
                    FQXSyncShelfFilterHeaderView(sub);
                } else if ([sub isKindOfClass:UICollectionView.class]) {
                    FQXReflowShelfFilterCollectionView((UICollectionView *)sub, clip);
                }
            }
            if ([header isKindOfClass:UIView.class] && (header.hidden || header.alpha < 0.05) &&
                CGRectGetMinY(clip.frame) > 12.0) {
                CGRect cf = clip.frame;
                cf.origin.y = 2.0;
                clip.frame = cf;
            }
        }
    }
}

static void FQXRefreshAllShelfEditButtons(void) {
    if (!NSThread.isMainThread) {
        dispatch_async(dispatch_get_main_queue(), ^{ FQXRefreshAllShelfEditButtons(); });
        return;
    }
    for (UIView *header in FQXTrackedShelfHeadersForEdit().allObjects) {
        FQXApplyShelfEditVisibilityForHeader(header);
        [header setNeedsLayout];
        [header layoutIfNeeded];
    }
}

static void FQXRefreshAllShelfHeaderControls(void) {
    if (!NSThread.isMainThread) {
        dispatch_async(dispatch_get_main_queue(), ^{ FQXRefreshAllShelfHeaderControls(); });
        return;
    }
    for (UIView *tabView in FQXTrackedShelfTabViews().allObjects) {
        FQXReflowShelfTabSelectView(tabView);
        [tabView setNeedsLayout];
    }
    for (UIViewController *vc in FQXTrackedShelf525VCs().allObjects) {
        FQXSyncShelfHeaderRightButtons(vc);
        if (vc.isViewLoaded) [vc.view setNeedsLayout];
    }
    for (UIViewController *vc in FQXTrackedShelfSubVCs().allObjects) {
        FQXSyncShelfHeaderRightButtons(vc);
        UICollectionView *cv = FQXObjGet(vc, "collectionView");
        if ([cv isKindOfClass:UICollectionView.class]) {
            [cv.collectionViewLayout invalidateLayout];
            [cv setNeedsLayout];
        }
    }
    for (UIView *cell in FQXTrackedShelfFunctionCells().allObjects) {
        FQXApplyShelfFunctionCellLayout(cell);
        [cell setNeedsLayout];
        for (UIView *p = cell.superview; p; p = p.superview) {
            if ([p isKindOfClass:UICollectionView.class]) {
                [((UICollectionView *)p).collectionViewLayout invalidateLayout];
                break;
            }
        }
    }
    for (UIView *header in FQXTrackedShelfFilterHeaders().allObjects) {
        FQXSyncShelfFilterHeaderView(header);
        [header setNeedsLayout];
    }
    for (UICollectionView *cv in FQXTrackedShelfFilterCollections().allObjects) {
        FQXReflowShelfFilterCollectionView(cv, nil);
        [cv setNeedsLayout];
    }
    FQXRefreshAllShelfEditButtons();
}

static void (*OrigShelfSubHeaderLayoutForEdit)(id, SEL);
static void HookShelfSubHeaderLayoutForEdit(UIView *self, SEL _cmd) {
    if (OrigShelfSubHeaderLayoutForEdit) OrigShelfSubHeaderLayoutForEdit(self, _cmd);
    FQXApplyShelfEditVisibilityForHeader(self);
}

static void (*OrigShelfSubHeaderLayoutEditBtn)(id, SEL);
static void HookShelfSubHeaderLayoutEditBtn(UIView *self, SEL _cmd) {
    if (OrigShelfSubHeaderLayoutEditBtn) OrigShelfSubHeaderLayoutEditBtn(self, _cmd);
    FQXApplyShelfEditVisibilityForHeader(self);
}

static void (*OrigShelfTabSelectLayout)(id, SEL);
static void HookShelfTabSelectLayout(UIView *self, SEL _cmd) {
    if (OrigShelfTabSelectLayout) OrigShelfTabSelectLayout(self, _cmd);
    FQXReflowShelfTabSelectView(self);
}

static void (*OrigShelfTabTitleCellLayout)(id, SEL);
static void HookShelfTabTitleCellLayout(UIView *self, SEL _cmd) {
    if (OrigShelfTabTitleCellLayout) OrigShelfTabTitleCellLayout(self, _cmd);
    Class tabSelectCls = NSClassFromString(@"SSBookShelfTabSelectView");
    for (UIView *p = self.superview; p; p = p.superview) {
        if (tabSelectCls && [p isKindOfClass:tabSelectCls]) {
            FQXReflowShelfTabSelectView(p);
            break;
        }
    }
}

static void (*OrigShelf525ViewLayout)(id, SEL);
static void HookShelf525ViewLayout(UIViewController *self, SEL _cmd) {
    if (OrigShelf525ViewLayout) OrigShelf525ViewLayout(self, _cmd);
    FQXSyncShelfHeaderRightButtons(self);
}

static void (*OrigShelf525TryAddRightView)(id, SEL);
static void HookShelf525TryAddRightView(UIViewController *self, SEL _cmd) {
    if (OrigShelf525TryAddRightView) OrigShelf525TryAddRightView(self, _cmd);
    FQXSyncShelfHeaderRightButtons(self);
}

static void (*OrigShelf525DidLayoutSubviews)(id, SEL);
static void HookShelf525DidLayoutSubviews(UIViewController *self, SEL _cmd) {
    if (OrigShelf525DidLayoutSubviews) OrigShelf525DidLayoutSubviews(self, _cmd);
    FQXSyncShelfHeaderRightButtons(self);
    UIView *tabSelect = FQXObjGet(self, "categoryTitleView") ?: FQXObjGet(self, "tabSelectView");
    if ([tabSelect isKindOfClass:UIView.class]) FQXReflowShelfTabSelectView(tabSelect);
}

static void (*OrigShelf525DidSelectTab)(id, SEL, id, NSInteger);
static void HookShelf525DidSelectTab(UIViewController *self, SEL _cmd, id category, NSInteger idx) {
    if (OrigShelf525DidSelectTab) OrigShelf525DidSelectTab(self, _cmd, category, idx);
    FQXSyncShelfHeaderRightButtons(self);
}

static void (*OrigShelfSubVCDidLayout)(id, SEL);
static void HookShelfSubVCDidLayout(UIViewController *self, SEL _cmd) {
    if (OrigShelfSubVCDidLayout) OrigShelfSubVCDidLayout(self, _cmd);
    FQXSyncShelfHeaderRightButtons(self);
}

static void (*OrigShelfFilterHeaderLayout)(id, SEL);
static void HookShelfFilterHeaderLayout(UIView *self, SEL _cmd) {
    if (OrigShelfFilterHeaderLayout) OrigShelfFilterHeaderLayout(self, _cmd);
    FQXSyncShelfFilterHeaderView(self);
}

static void (*OrigShelfFilterMixRowLayout)(id, SEL);
static void HookShelfFilterMixRowLayout(UICollectionView *self, SEL _cmd) {
    if (OrigShelfFilterMixRowLayout) OrigShelfFilterMixRowLayout(self, _cmd);
    FQXReflowShelfFilterCollectionView(self, nil);
}

static void (*OrigShelfFilter541CellLayout)(id, SEL);
static void HookShelfFilter541CellLayout(UIView *self, SEL _cmd) {
    if (OrigShelfFilter541CellLayout) OrigShelfFilter541CellLayout(self, _cmd);
    Class mixCls = NSClassFromString(@"SSBookShelfFilterMixRowCollectionView");
    for (UIView *p = self.superview; p; p = p.superview) {
        if (mixCls && [p isKindOfClass:mixCls] && [p isKindOfClass:UICollectionView.class]) {
            FQXReflowShelfFilterCollectionView((UICollectionView *)p, nil);
            break;
        }
    }
}

static IMP OrigShelfSubSupView = NULL;
static IMP OrigShelfSubSizeForItem = NULL;
static IMP OrigShelfSubHeaderSize = NULL;

static id HookShelfSubSupView(UIViewController *self, SEL _cmd, UICollectionView *cv, id kind, NSIndexPath *indexPath) {
    id view = ((id (*)(id, SEL, id, id, id))OrigShelfSubSupView)(self, _cmd, cv, kind, indexPath);
    Class filterHeaderCls = NSClassFromString(@"SSBookShelfFilterHeaderView");
    if (filterHeaderCls && [view isKindOfClass:filterHeaderCls] && indexPath) {
        objc_setAssociatedObject(self, FQXShelfFilterSectionKey, @(indexPath.section), OBJC_ASSOCIATION_RETAIN_NONATOMIC);
        FQXSyncShelfFilterHeaderView((UIView *)view);
    }
    return view;
}

static CGSize HookShelfSubSizeForItem(UIViewController *self, SEL _cmd, UICollectionView *cv, id layout, NSIndexPath *indexPath) {
    CGSize size = ((CGSize (*)(id, SEL, id, id, id))OrigShelfSubSizeForItem)(self, _cmd, cv, layout, indexPath);
    if (!indexPath || size.height <= 4.0) return size;
    id vm = FQXObjGet(self, "viewModel");
    SEL stSel = NSSelectorFromString(@"sectionTypeAtIndex:");
    Method stMethod = vm ? class_getInstanceMethod(object_getClass(vm), stSel) : NULL;
    if (!stMethod || method_getNumberOfArguments(stMethod) != 3) return size;
    NSInteger sectionType = ((NSInteger (*)(id, SEL, NSInteger))objc_msgSend)(vm, stSel, indexPath.section);
    if (sectionType != 1) return size;

    Class funcCls = NSClassFromString(@"SSBookShelfFunctionCell");
    SEL chSel = NSSelectorFromString(@"cellHeightWithFilterExposure:");
    CGFloat baseHeight = 52.0;
    if (funcCls && [funcCls respondsToSelector:chSel]) {
        baseHeight = ((CGFloat (*)(id, SEL, BOOL))objc_msgSend)(funcCls, chSel, NO);
    }
    BOOL row2IncludedInSize = (size.height >= baseHeight + 24.0);
    BOOL durEnabled = FQXShelfReadingDurationEnabled();
    BOOL hideRow3 = FQXShelfRow3AllHidden();

    if (hideRow3) {
        if (!row2IncludedInSize) {
            // AlignedGlass already removed Row 2; removing Row 3 collapses the function row completely.
            size.height = 1.0;
        } else if (!durEnabled && !FQXShelfEditButtonEnabled()) {
            size.height = 1.0;
        } else {
            size.height = MAX(36.0, baseHeight);
        }
    } else if (!durEnabled && !FQXShelfEditButtonEnabled() && row2IncludedInSize) {
        size.height = MAX(36.0, size.height - baseHeight);
    }
    return size;
}

static CGSize HookShelfSubHeaderSize(UIViewController *self, SEL _cmd, UICollectionView *cv, id layout, NSInteger section) {
    CGSize size = ((CGSize (*)(id, SEL, id, id, NSInteger))OrigShelfSubHeaderSize)(self, _cmd, cv, layout, section);
    NSNumber *filterSec = objc_getAssociatedObject(self, FQXShelfFilterSectionKey);
    if (filterSec && filterSec.integerValue == section && FQXShelfRow3AllHidden()) {
        return CGSizeZero;
    }
    return size;
}

static BOOL FQXBookstoreColdLaunchAnchor(__unused id cls, __unused SEL cmd, __unused NSUInteger scene) {
    return NO;
}

static BOOL FQXBookstoreColdLaunchAnchorInt(__unused id cls, __unused SEL cmd, __unused int scene) {
    return NO;
}

static BOOL FQXBookstoreColdLaunchAnchorBool(__unused id cls, __unused SEL cmd, __unused BOOL flag) {
    return NO;
}

static BOOL FQXBookstoreBoolNo0(__unused id selfOrCls, __unused SEL cmd) {
    return NO;
}

static NSInteger FQXBookstoreAutomaticAnchorCount(__unused id cls, __unused SEL cmd) {
    return 0;
}

static int FQXBookstoreAutomaticAnchorCountInt(__unused id cls, __unused SEL cmd) {
    return 0;
}

static void (*OrigBookstoreSetLocateToInfinite)(id, SEL, BOOL);
static void HookBookstoreSetLocateToInfinite(id model, SEL cmd, __unused BOOL locate) {
    if (OrigBookstoreSetLocateToInfinite) {
        OrigBookstoreSetLocateToInfinite(model, cmd, NO);
    }
}

static void (*OrigBookstoreAfterFirstLoad)(id, SEL);
static void FQXBookstoreAfterFirstLoad(id controller, SEL cmd) {
    id model = FQXObjGet(controller, "pageModel");
    SEL locate = sel_registerName("setLocateToInfinite:");
    if (model && [model respondsToSelector:locate]) {
        Method m = class_getInstanceMethod(object_getClass(model), locate);
        if (m && strcmp(method_getTypeEncoding(m), "v20@0:8B16") == 0) {
            ((void (*)(id, SEL, BOOL))objc_msgSend)(model, locate, NO);
        }
    }
    if (OrigBookstoreAfterFirstLoad) OrigBookstoreAfterFirstLoad(controller, cmd);
}

static const void *FQXNestedScrollAttachMonoKey = &FQXNestedScrollAttachMonoKey;
static const void *FQXNestedScrollUserTouchedKey = &FQXNestedScrollUserTouchedKey;
static const void *FQXNestedScrollBlockLoggedKey = &FQXNestedScrollBlockLoggedKey;

static BOOL FQXNestedScrollShouldGuardAutoJump(UIScrollView *sv, CGPoint targetOffset, BOOL animated, CGPoint *outClamped) {
    if (!sv || !sv.window) return NO;
    // As soon as the user touches, drags, or flicks the scroll view, permanently lift the cold-start guard.
    UIGestureRecognizerState panState = sv.panGestureRecognizer ? sv.panGestureRecognizer.state : UIGestureRecognizerStatePossible;
    if (sv.isTracking || sv.isDragging || sv.isDecelerating ||
        panState == UIGestureRecognizerStateBegan ||
        panState == UIGestureRecognizerStateChanged ||
        panState == UIGestureRecognizerStateEnded) {
        objc_setAssociatedObject(sv, FQXNestedScrollUserTouchedKey, @YES, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
        return NO;
    }
    if ([objc_getAssociatedObject(sv, FQXNestedScrollUserTouchedKey) boolValue]) {
        return NO;
    }
    NSNumber *attachMono = objc_getAssociatedObject(sv, FQXNestedScrollAttachMonoKey);
    CFTimeInterval now = CACurrentMediaTime();
    if (!attachMono) {
        objc_setAssociatedObject(sv, FQXNestedScrollAttachMonoKey, @(now), OBJC_ASSOCIATION_RETAIN_NONATOMIC);
        attachMono = @(now);
    }
    if (now - attachMono.doubleValue > 5.0) {
        return NO;
    }
    CGFloat topY = -sv.adjustedContentInset.top;
    // Allow top-alignment resets (e.g. TopChromeInsets setting -adjustedContentInset.top)
    // and pull-to-refresh offsets (targetOffset.y < topY). Block only programmatic downward jumps
    // that scroll past the top ranking section into the infinite double-column feed.
    if (targetOffset.y <= topY + 20.0) {
        return NO;
    }
    CGFloat curY = sv.contentOffset.y;
    if (curY > topY + 28.0 && !animated) {
        return NO;
    }
    if (outClamped) {
        *outClamped = CGPointMake(targetOffset.x, topY);
    }
    if (!objc_getAssociatedObject(sv, FQXNestedScrollBlockLoggedKey)) {
        objc_setAssociatedObject(sv, FQXNestedScrollBlockLoggedKey, @YES, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
        FQXDiagRecordEvent(FQXDiagCategoryUI, @"bookstore_autoscroll_blocked", @{
            @"scrollClass": NSStringFromClass(sv.class) ?: @"SSNestedContainerScrollView",
            @"fromY": @(round(curY * 10.0) / 10.0),
            @"requestedY": @(round(targetOffset.y * 10.0) / 10.0),
            @"clampedY": @(round(topY * 10.0) / 10.0),
            @"animated": @(animated),
            @"elapsedSec": @(round((now - attachMono.doubleValue) * 100.0) / 100.0),
        }, NO);
    }
    return YES;
}

static void (*OrigNestedScrollDidMoveWindow)(id, SEL);
static void HookNestedScrollDidMoveWindow(UIScrollView *sv, SEL cmd) {
    if (OrigNestedScrollDidMoveWindow) OrigNestedScrollDidMoveWindow(sv, cmd);
    if (sv.window && !objc_getAssociatedObject(sv, FQXNestedScrollAttachMonoKey)) {
        objc_setAssociatedObject(sv, FQXNestedScrollAttachMonoKey, @(CACurrentMediaTime()), OBJC_ASSOCIATION_RETAIN_NONATOMIC);
    }
}

static void (*OrigNestedScrollSetOffsetAnimated)(id, SEL, CGPoint, BOOL);
static void HookNestedScrollSetOffsetAnimated(UIScrollView *sv, SEL cmd, CGPoint offset, BOOL animated) {
    CGPoint clamped = offset;
    if (FQXNestedScrollShouldGuardAutoJump(sv, offset, animated, &clamped)) {
        if (OrigNestedScrollSetOffsetAnimated) OrigNestedScrollSetOffsetAnimated(sv, cmd, clamped, NO);
        return;
    }
    if (OrigNestedScrollSetOffsetAnimated) OrigNestedScrollSetOffsetAnimated(sv, cmd, offset, animated);
}

static void (*OrigNestedScrollSetOffset)(id, SEL, CGPoint);
static void HookNestedScrollSetOffset(UIScrollView *sv, SEL cmd, CGPoint offset) {
    CGPoint clamped = offset;
    if (FQXNestedScrollShouldGuardAutoJump(sv, offset, NO, &clamped)) {
        if (OrigNestedScrollSetOffset) OrigNestedScrollSetOffset(sv, cmd, clamped);
        return;
    }
    if (OrigNestedScrollSetOffset) OrigNestedScrollSetOffset(sv, cmd, offset);
}

static void FQXInstallBookstoreAntiAutoScrollHooks(void) {
    Class abCls = objc_lookUpClass("SSBookStoreABTestHelper");
    if (abCls) {
        Class metaCls = object_getClass(abCls);
        unsigned int mc = 0;
        Method *mlist = class_copyMethodList(metaCls, &mc);
        for (unsigned int i = 0; i < mc; ++i) {
            SEL sel = method_getName(mlist[i]);
            const char *name = sel_getName(sel);
            const char *enc = method_getTypeEncoding(mlist[i]);
            if (!name || !enc) continue;
            BOOL isAnchorBool = (strstr(name, "AnchorToDoubleCol") != NULL ||
                                 strstr(name, "LocateToInfinite") != NULL ||
                                 strstr(name, "AutoScrollToInfinite") != NULL);
            if (!isAnchorBool) continue;
            if (strcmp(enc, "B24@0:8Q16") == 0 || strcmp(enc, "B24@0:8q16") == 0) {
                FQXInstallOwnedHook(abCls, sel, YES, enc, (IMP)FQXBookstoreColdLaunchAnchor, NULL);
            } else if (strcmp(enc, "B20@0:8i16") == 0 || strcmp(enc, "B20@0:8I16") == 0) {
                FQXInstallOwnedHook(abCls, sel, YES, enc, (IMP)FQXBookstoreColdLaunchAnchorInt, NULL);
            } else if (strcmp(enc, "B20@0:8B16") == 0) {
                FQXInstallOwnedHook(abCls, sel, YES, enc, (IMP)FQXBookstoreColdLaunchAnchorBool, NULL);
            } else if (strcmp(enc, "B16@0:8") == 0) {
                FQXInstallOwnedHook(abCls, sel, YES, enc, (IMP)FQXBookstoreBoolNo0, NULL);
            } else if (strcmp(enc, "q16@0:8") == 0 || strcmp(enc, "Q16@0:8") == 0) {
                FQXInstallOwnedHook(abCls, sel, YES, enc, (IMP)FQXBookstoreAutomaticAnchorCount, NULL);
            } else if (strcmp(enc, "i16@0:8") == 0 || strcmp(enc, "I16@0:8") == 0) {
                FQXInstallOwnedHook(abCls, sel, YES, enc, (IMP)FQXBookstoreAutomaticAnchorCountInt, NULL);
            }
        }
        free(mlist);
    }

    Class tabModelCls = objc_lookUpClass("SSBookStoreDoubleRowTabModel");
    if (tabModelCls) {
        FQXInstallOwnedHook(tabModelCls, sel_registerName("locateToInfinite"), NO, "B16@0:8",
                            (IMP)FQXBookstoreBoolNo0, NULL);
        FQXInstallOwnedHook(tabModelCls, sel_registerName("setLocateToInfinite:"), NO, "v20@0:8B16",
                            (IMP)HookBookstoreSetLocateToInfinite, (IMP *)&OrigBookstoreSetLocateToInfinite);
    }

    Class drVC = objc_lookUpClass("SSBookStoreDoubleRowViewController");
    if (drVC) {
        FQXInstallOwnedHook(drVC, sel_registerName("afterFirstLoad"), NO, "v16@0:8",
                            (IMP)FQXBookstoreAfterFirstLoad, (IMP *)&OrigBookstoreAfterFirstLoad);
    }

    Class nestedSV = objc_lookUpClass("SSNestedContainerScrollView");
    if (nestedSV) {
        FQXInstallOwnedHook(nestedSV, @selector(didMoveToWindow), NO, "v16@0:8",
                            (IMP)HookNestedScrollDidMoveWindow, (IMP *)&OrigNestedScrollDidMoveWindow);
        FQXInstallOwnedHook(nestedSV, @selector(setContentOffset:animated:), NO,
                            "v36@0:8{CGPoint=dd}16B32",
                            (IMP)HookNestedScrollSetOffsetAnimated, (IMP *)&OrigNestedScrollSetOffsetAnimated);
        FQXInstallOwnedHook(nestedSV, @selector(setContentOffset:), NO,
                            "v32@0:8{CGPoint=dd}16",
                            (IMP)HookNestedScrollSetOffset, (IMP *)&OrigNestedScrollSetOffset);
    }
}

#pragma mark - Mine Side Drawer Individual Item Visibility ("我的侧栏各项独立开关")

static NSHashTable<UIViewController *> *FQXTrackedMineSidebars(void) {
    static NSHashTable<UIViewController *> *table;
    static dispatch_once_t once;
    dispatch_once(&once, ^{ table = [NSHashTable weakObjectsHashTable]; });
    return table;
}

static BOOL FQXSidebarPrefEnabled(NSString *key) {
    if (!key.length) return YES;
    id stored = [NSUserDefaults.standardUserDefaults objectForKey:key];
    return stored ? [stored boolValue] : YES;
}

static NSArray<NSString *> *FQXSidebarMatchedKeysInText(NSString *text) {
    if (!text.length) return @[];
    NSMutableArray<NSString *> *found = [NSMutableArray array];
    NSArray<NSArray<NSString *> *> *pairs = @[
        @[@"我的消息", @"FanqieX.SidebarMessages.1"],
        @[@"系统通知", @"FanqieX.SidebarMessages.1"],
        @[@"创作通知", @"FanqieX.SidebarMessages.1"],
        @[@"视频创作", @"FanqieX.SidebarVideoCreate.1"],
        @[@"阅读偏好", @"FanqieX.SidebarReadingPref.1"],
        @[@"我的笔记", @"FanqieX.SidebarMyNotes.1"],
        @[@"活动中心", @"FanqieX.SidebarActivityCenter.1"],
        @[@"看过的人", @"FanqieX.SidebarViewedUsers.1"],
        @[@"番茄指南", @"FanqieX.SidebarFanqieGuide.1"],
        @[@"我的公益", @"FanqieX.SidebarMyCharity.1"],
        @[@"会员中心", @"FanqieX.SidebarVipCenter.1"],
        @[@"我的签约", @"FanqieX.SidebarMyContract.1"],
        @[@"我的钱包", @"FanqieX.SidebarMyWallet.1"],
        @[@"转化记录", @"FanqieX.SidebarConversionRecord.1"],
        @[@"个人信息清单", @"FanqieX.SidebarPrivacyLinks.1"],
        @[@"三方信息共享清单", @"FanqieX.SidebarPrivacyLinks.1"],
    ];
    for (NSArray<NSString *> *pair in pairs) {
        if ([text containsString:pair[0]] && ![found containsObject:pair[1]]) {
            [found addObject:pair[1]];
        }
    }
    return found;
}

static NSIndexSet *FQXSidebarVisibleModelIndices(NSArray *models, NSArray *titles) {
    return [models indexesOfObjectsPassingTest:^BOOL(id model, NSUInteger index, __unused BOOL *stop) {
        id title = index < titles.count ? titles[index] : FQXObjGet(model, "titleString");
        if (![title isKindOfClass:NSString.class] || ![title length]) title = FQXObjGet(model, "titleString");
        for (NSString *key in FQXSidebarMatchedKeysInText([title isKindOfClass:NSString.class] ? title : nil)) {
            if (!FQXSidebarPrefEnabled(key)) return NO;
        }
        return YES;
    }];
}

static void (*OrigSidebarConfigureFunctionList)(id, SEL, NSArray *, NSArray *, NSArray *, NSArray *);
static void HookSidebarConfigureFunctionList(id cell, SEL cmd, NSArray *models, NSArray *titles, NSArray *icons, NSArray *darkIcons) {
    NSIndexSet *visible = FQXSidebarVisibleModelIndices(models, titles);
    if (visible.count != models.count &&
        (!titles || titles.count == models.count) && (!icons || icons.count == models.count) &&
        (!darkIcons || darkIcons.count == models.count)) {
        OrigSidebarConfigureFunctionList(cell, cmd, [models objectsAtIndexes:visible],
            [titles objectsAtIndexes:visible], [icons objectsAtIndexes:visible], [darkIcons objectsAtIndexes:visible]);
        return;
    }
    OrigSidebarConfigureFunctionList(cell, cmd, models, titles, icons, darkIcons);
}

static __weak UIViewController *FQXSidebarSizingController;

static CGFloat (*OrigSidebarFunctionListHeight)(id, SEL, NSArray *);
static CGFloat HookSidebarFunctionListHeight(id cls, SEL cmd, NSArray *models) {
    NSArray *titles = FQXObjGet(FQXSidebarSizingController, "functionEntryTitles");
    NSIndexSet *visible = FQXSidebarVisibleModelIndices(models, titles.count == models.count ? titles : nil);
    return OrigSidebarFunctionListHeight(cls, cmd, visible.count == models.count ? models : [models objectsAtIndexes:visible]);
}

static BOOL FQXSidebarHidesMessages(id controller, NSIndexPath *path) {
    if (FQXSidebarPrefEnabled(@"FanqieX.SidebarMessages.1")) return NO;
    SEL selector = sel_registerName("btd_indexPathForComponent:");
    Method method = class_getInstanceMethod(object_getClass(controller), selector);
    if (!method || strcmp(method_getTypeEncoding(method), "@24@0:8@16") != 0) return NO;
    NSIndexPath *message = ((id (*)(id, SEL, id))objc_msgSend)(controller, selector,
        @"SSMyUser621SideBarMessageContainerCell");
    return [message isEqual:path];
}

static CGSize (*OrigSidebarItemSize)(id, SEL, UICollectionView *, UICollectionViewLayout *, NSIndexPath *);
static CGSize HookSidebarItemSize(UIViewController *controller, SEL cmd, UICollectionView *list,
                                  UICollectionViewLayout *layout, NSIndexPath *path) {
    if (FQXSidebarHidesMessages(controller, path)) return CGSizeZero;
    UIViewController *previous = FQXSidebarSizingController;
    FQXSidebarSizingController = controller;
    CGSize size = OrigSidebarItemSize(controller, cmd, list, layout, path);
    FQXSidebarSizingController = previous;
    return size;
}

static CGSize (*OrigSidebarFooterSize)(id, SEL, UICollectionView *, UICollectionViewLayout *, NSInteger);
static CGSize HookSidebarFooterSize(id controller, SEL cmd, UICollectionView *list,
                                    UICollectionViewLayout *layout, NSInteger section) {
    if (!FQXSidebarPrefEnabled(@"FanqieX.SidebarPrivacyLinks.1")) return CGSizeZero;
    return OrigSidebarFooterSize(controller, cmd, list, layout, section);
}

static void FQXRefreshAllMineSidebars(void) {
    if (!NSThread.isMainThread) {
        dispatch_async(dispatch_get_main_queue(), ^{ FQXRefreshAllMineSidebars(); });
        return;
    }
    for (UIViewController *controller in FQXTrackedMineSidebars().allObjects) {
        UICollectionView *list = FQXObjGet(controller, "collectionView");
        [list.collectionViewLayout invalidateLayout];
        [list reloadData];
    }
}

static void (*OrigSidebarViewDidLoad)(id, SEL);
static void HookSidebarViewDidLoad(UIViewController *controller, SEL cmd) {
    OrigSidebarViewDidLoad(controller, cmd);
    [FQXTrackedMineSidebars() addObject:controller];
}

#pragma mark - Audio Play Page ("智能朗读") iOS 26/27 Liquid Glass, Refraction & Seamless Background

static NSHashTable<UIView *> *FQXAudioGlassOwners(void) {
    static NSHashTable<UIView *> *table;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        table = [NSHashTable weakObjectsHashTable];
    });
    return table;
}

static NSHashTable<UIViewController *> *FQXAudioPlayVCs(void) {
    static NSHashTable<UIViewController *> *table;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        table = [NSHashTable weakObjectsHashTable];
    });
    return table;
}

static void FQXTrackAudioView(UIView *view) {
    if (view) [FQXAudioGlassOwners() addObject:view];
}

static void FQXAudioSetUnclipped(UIView *view, BOOL unclip) {
    if (![view isKindOfClass:UIView.class]) return;
    NSNumber *saved = objc_getAssociatedObject(view, AudioSavedClipsKey);
    if (unclip) {
        if (!saved) {
            objc_setAssociatedObject(view, AudioSavedClipsKey, @(view.clipsToBounds), OBJC_ASSOCIATION_RETAIN_NONATOMIC);
        }
        if (view.clipsToBounds) view.clipsToBounds = NO;
    } else if (saved) {
        if (view.clipsToBounds != saved.boolValue) view.clipsToBounds = saved.boolValue;
        objc_setAssociatedObject(view, AudioSavedClipsKey, nil, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
    }
}

static void FQXAudioClearBackground(UIView *view, BOOL clear) {
    if (![view isKindOfClass:UIView.class]) return;
    if (clear) {
        UIColor *cur = view.backgroundColor;
        if (cur && ![cur isEqual:UIColor.clearColor]) {
            objc_setAssociatedObject(view, AudioSavedBgKey, cur, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
        }
        if (!cur || ![cur isEqual:UIColor.clearColor]) {
            objc_setAssociatedObject(view, AudioClearingBgKey, @YES, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
            view.backgroundColor = UIColor.clearColor;
            objc_setAssociatedObject(view, AudioClearingBgKey, nil, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
        }
    } else {
        UIColor *saved = objc_getAssociatedObject(view, AudioSavedBgKey);
        if (saved && (!view.backgroundColor || [view.backgroundColor isEqual:UIColor.clearColor])) {
            objc_setAssociatedObject(view, AudioClearingBgKey, @YES, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
            view.backgroundColor = saved;
            objc_setAssociatedObject(view, AudioClearingBgKey, nil, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
        }
        objc_setAssociatedObject(view, AudioSavedBgKey, nil, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
    }
}

static void FQXAudioSetHiddenTracked(UIView *view, BOOL hide) {
    if (![view isKindOfClass:UIView.class]) return;
    NSNumber *saved = objc_getAssociatedObject(view, AudioSavedHiddenKey);
    if (hide) {
        if (!saved) {
            objc_setAssociatedObject(view, AudioSavedHiddenKey, @(view.hidden), OBJC_ASSOCIATION_RETAIN_NONATOMIC);
        }
        if (!view.hidden) view.hidden = YES;
    } else if (saved) {
        view.hidden = saved.boolValue;
        objc_setAssociatedObject(view, AudioSavedHiddenKey, nil, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
    }
}

static void (*OrigBottomImpactFeedback)(id, SEL);
static void HookBottomImpactFeedback(id self, SEL cmd) {
    NSNumber *enabled = [NSUserDefaults.standardUserDefaults objectForKey:BottomHapticsPrefKey];
    if (!enabled || enabled.boolValue) OrigBottomImpactFeedback(self, cmd);
}

static const void *DramaCommentCaptionMaskKey = &DramaCommentCaptionMaskKey;
static void FQXSetDramaCommentCaption(UIView *view, BOOL hasCount) {
    UILabel *label = FQXObjGet(view, "commentCountLabel");
    if (![label isKindOfClass:UILabel.class]) return;
    CALayer *layer = label.layer;
    NSArray<CALayer *> *saved = objc_getAssociatedObject(label, DramaCommentCaptionMaskKey);
    if (hasCount && !saved) return;
    if (!hasCount && saved && layer.mask == saved[0]) return;
    [CATransaction begin];
    [CATransaction setDisableActions:YES];
    if (hasCount) {
        if (layer.mask == saved[0]) layer.mask = saved.count > 1 ? saved[1] : nil;
        objc_setAssociatedObject(label, DramaCommentCaptionMaskKey, nil, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
    } else {
        // Keep the icon, tap, accessibility and label layout. The host paints
        // "评论" for the empty count before the asynchronous reply.
        CALayer *mask = [CALayer layer];
        saved = layer.mask ? @[mask, layer.mask] : @[mask];
        objc_setAssociatedObject(label, DramaCommentCaptionMaskKey, saved, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
        layer.mask = mask;
    }
    [CATransaction commit];
}

static void FQXRenderDramaCommentCount(UIView *view, SEL cmd, NSInteger count,
                                      void (*original)(id, SEL, NSInteger)) {
    [UIView performWithoutAnimation:^{
        [CATransaction begin];
        [CATransaction setDisableActions:YES];
        original(view, cmd, count);
        FQXSetDramaCommentCaption(view, count > 0);
        [CATransaction commit];
    }];
}

static void (*OrigDramaCommentCount)(id, SEL, NSInteger);
static void HookDramaCommentCount(UIView *view, SEL cmd, NSInteger count) {
    FQXRenderDramaCommentCount(view, cmd, count, OrigDramaCommentCount);
}

static void (*OrigHostDramaCommentCount)(id, SEL, NSInteger);
static void HookHostDramaCommentCount(UIView *view, SEL cmd, NSInteger count) {
    FQXRenderDramaCommentCount(view, cmd, count, OrigHostDramaCommentCount);
}

static void FQXRefreshDramaCommentCaption(UIView *view) {
    SEL getter = NSSelectorFromString(@"commentCount");
    Method method = class_getInstanceMethod(view.class, getter);
    if (method && strcmp(method_getTypeEncoding(method), "d16@0:8") == 0)
        FQXSetDramaCommentCaption(view, ((double (*)(id, SEL))objc_msgSend)(view, getter) > 0);
}
static void (*OrigDramaCommentLayout)(id, SEL);
static void HookDramaCommentLayout(UIView *view, SEL cmd) {
    OrigDramaCommentLayout(view, cmd);
    FQXRefreshDramaCommentCaption(view);
}
static void (*OrigHostDramaCommentLayout)(id, SEL);
static void HookHostDramaCommentLayout(UIView *view, SEL cmd) {
    OrigHostDramaCommentLayout(view, cmd);
    FQXRefreshDramaCommentCaption(view);
}

// Note: Do not override SSBookShelfViewModel.shouldShowEmptyBookCell during cold start;
// forcing NO while the host still builds the empty/history section desynchronizes
// sizeForItemAtIndexPath: (1-column width) from cellForItemAtIndexPath: (full-width buttons).

static void FQXFixShelfHeaderEditFilterOverlap(UIView *header) {
    if (![header isKindOfClass:UIView.class] || header.hidden || !header.window) return;
    UIView *editBtn = FQXObjGet(header, "editButton");
    if (![editBtn isKindOfClass:UIView.class] || editBtn.hidden || editBtn.alpha < 0.01) return;
    if (![editBtn isDescendantOfView:header]) return;
    UIView *editParent = editBtn.superview;
    if (!editParent) return;
    CGRect editInHeader = [editBtn convertRect:editBtn.bounds toView:header];
    if (CGRectGetWidth(editInHeader) < 12.0 || CGRectGetHeight(editInHeader) < 12.0) return;

    UIView *candidates[2] = {
        FQXObjGet(header, "filterButton"),
        FQXObjGet(header, "fullGenreFilterButton")
    };
    CGFloat minFilterLeftInHeader = CGFLOAT_MAX;
    for (int i = 0; i < 2; ++i) {
        UIView *f = candidates[i];
        if (![f isKindOfClass:UIView.class] || f.hidden || f.alpha < 0.01) continue;
        if (![f isDescendantOfView:header]) continue;
        CGRect fInHeader = [f convertRect:f.bounds toView:header];
        if (CGRectGetWidth(fInHeader) < 12.0 || CGRectGetHeight(fInHeader) < 12.0) continue;
        if (fabs(CGRectGetMidY(fInHeader) - CGRectGetMidY(editInHeader)) < 18.0) {
            if (CGRectGetMinX(fInHeader) < minFilterLeftInHeader) {
                minFilterLeftInHeader = CGRectGetMinX(fInHeader);
            }
        }
    }
    if (minFilterLeftInHeader < CGFLOAT_MAX && CGRectGetMaxX(editInHeader) > minFilterLeftInHeader - 8.0) {
        CGFloat targetMaxXInHeader = minFilterLeftInHeader - 8.0;
        CGFloat targetXInHeader = MAX(8.0, targetMaxXInHeader - CGRectGetWidth(editInHeader));
        CGRect desiredInHeader = editInHeader;
        desiredInHeader.origin.x = targetXInHeader;
        CGRect desiredInParent = [header convertRect:desiredInHeader toView:editParent];
        if (fabs(desiredInParent.origin.x - editBtn.frame.origin.x) > 0.5) {
            CGRect f = editBtn.frame;
            f.origin.x = desiredInParent.origin.x;
            editBtn.frame = f;
        }
    }
}

static void (*OrigShelfFunctionCellLayout)(id, SEL);
static void HookShelfFunctionCellLayout(UIView *cell, SEL cmd) {
    if (OrigShelfFunctionCellLayout) OrigShelfFunctionCellLayout(cell, cmd);
    FQXApplyShelfFunctionCellLayout(cell);
    UIView *header = FQXObjGet(cell, "headerView");
    if (![header isKindOfClass:UIView.class]) return;
    if (![objc_getAssociatedObject(header, FQXShelfHeaderFixPendingKey) boolValue]) {
        objc_setAssociatedObject(header, FQXShelfHeaderFixPendingKey, @YES, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
        __weak UIView *weakHeader = header;
        dispatch_async(dispatch_get_main_queue(), ^{
            UIView *strongHeader = weakHeader;
            if (!strongHeader) return;
            objc_setAssociatedObject(strongHeader, FQXShelfHeaderFixPendingKey, nil, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
            FQXFixShelfHeaderEditFilterOverlap(strongHeader);
        });
    }
}

static void (*OrigShelfFunctionContainerLayout)(id, SEL);
static void HookShelfFunctionContainerLayout(UIView *cell, SEL cmd) {
    if (OrigShelfFunctionContainerLayout) OrigShelfFunctionContainerLayout(cell, cmd);
    FQXApplyShelfFunctionCellLayout(cell);
}

static void FQXResetNestedScrollViewsToTop(UIView *view, NSInteger depth) {
    if (!view || depth > 6) return;
    for (UIView *sub in view.subviews) {
        if ([sub isKindOfClass:UIScrollView.class]) {
            UIScrollView *sv = (UIScrollView *)sub;
            CGFloat innerTop = -sv.adjustedContentInset.top;
            if (fabs(sv.contentOffset.y - innerTop) > 0.5) {
                [sv setContentOffset:CGPointMake(sv.contentOffset.x, innerTop) animated:NO];
            }
        }
        FQXResetNestedScrollViewsToTop(sub, depth + 1);
    }
}

static void FQXResetMineScrollToTop(UIViewController *controller) {
    if (!controller) return;
    UIScrollView *list = FQXObjGet(controller, "collectionView");
    if (![list isKindOfClass:UIScrollView.class]) return;
    FQXResetNestedScrollViewsToTop(list, 0);
    CGFloat topY = -list.adjustedContentInset.top;
    if (fabs(list.contentOffset.y - topY) > 0.5) {
        [list setContentOffset:CGPointMake(list.contentOffset.x, topY) animated:YES];
    }
}

static void (*OrigMineTabBarCurrentTap)(id, SEL, int);
static void HookMineTabBarCurrentTap(UIViewController *controller, SEL cmd, int index) {
    (void)cmd; (void)index;
    // Always restore Mine to its true resting top (-adjustedContentInset.top, e.g. -106 under
    // TopChromeUnderlap) instead of letting host hardcode y=0 + unlimitedBeginRefreshing:,
    // which shoves the profile header 106pt upward and traps pull-down inside the nested feed.
    FQXResetMineScrollToTop(controller);
}

static void (*OrigMineTabBarCurrentTap64)(id, SEL, NSInteger);
static void HookMineTabBarCurrentTap64(UIViewController *controller, SEL cmd, NSInteger index) {
    (void)cmd; (void)index;
    FQXResetMineScrollToTop(controller);
}

static void (*OrigMineUnlimitedRefresh)(id, SEL, BOOL, BOOL);
static void HookMineUnlimitedRefresh(UIViewController *controller, SEL cmd, BOOL trigger, BOOL animated) {
    UIScrollView *list = FQXObjGet(controller, "collectionView");
    if ([list isKindOfClass:UIScrollView.class] && list.adjustedContentInset.top > 20.0) {
        FQXResetMineScrollToTop(controller);
        return;
    }
    if (OrigMineUnlimitedRefresh) OrigMineUnlimitedRefresh(controller, cmd, trigger, animated);
}

static const void *DramaComposerGlassKey = &DramaComposerGlassKey;
static const void *CommentStockEffectKey = &CommentStockEffectKey;
static const void *CommentCollectionStockInsetKey = &CommentCollectionStockInsetKey;
static const void *SheetSavedClipsKey = &SheetSavedClipsKey;
static const void *WriteReviewGlassKey = &WriteReviewGlassKey;
static const void *WriteReviewInkKey = &WriteReviewInkKey;
static const void *WriteReviewIconKey = &WriteReviewIconKey;
static const void *WriteReviewGradColorsKey = &WriteReviewGradColorsKey;
static CGPoint FQXAudioStockCenter(UIView *view);
static void FQXAudioPlaceView(UIView *view, CGPoint target, BOOL active);
static void FQXAudioHideGradient(CALayer *layer, BOOL hide);

static BOOL FQXCommentViewIsDark(UIView *view) {
    if (!view) return NO;
    if ([view respondsToSelector:NSSelectorFromString(@"isDarkMode")] && FQXBoolGet(view, "isDarkMode", NO)) return YES;
    return view.traitCollection.userInterfaceStyle == UIUserInterfaceStyleDark;
}

static BOOL FQXColorGetRGBA(UIColor *color, CGFloat *r, CGFloat *g, CGFloat *b, CGFloat *a) {
    if (![color isKindOfClass:UIColor.class]) return NO;
    if ([color getRed:r green:g blue:b alpha:a]) return YES;
    CGFloat w = 0.0;
    if ([color getWhite:&w alpha:a]) {
        *r = w; *g = w; *b = w;
        return YES;
    }
    return NO;
}

static UIColor *FQXRichCommentBlueColor(void) {
    if (!FQXCommentsUseDarkTheme()) {
        // High-contrast deep royal blue for Light Liquid Glass.
        return [UIColor colorWithRed:0.04 green:0.38 blue:0.88 alpha:1.0];
    }
    // Rich, saturated, deeper vivid blue for links & "大家都在搜" over dark glass / iOS 18 blur.
    return [UIColor colorWithRed:0.18 green:0.56 blue:1.0 alpha:1.0];
}

static UIColor *FQXPrimaryCommentTextColor(void) {
    return FQXCommentsUseDarkTheme()
        ? [UIColor colorWithWhite:1.0 alpha:1.0]
        : [UIColor colorWithWhite:0.07 alpha:1.0];
}

static BOOL FQXCommentUsesTextShadow(void) {
    return FQXCurrentCommentMaterialStyle() == FQXCommentMaterialClearGlass && FQXCommentsUseDarkTheme();
}

static void FQXSyncLabelShadowForCommentMode(UILabel *label) {
    if (!label) return;
    if (FQXCommentUsesTextShadow()) {
        CGSize targetOffset = CGSizeMake(0.0, 0.5);
        if (!label.shadowColor || !CGSizeEqualToSize(label.shadowOffset, targetOffset)) {
            label.shadowColor = [UIColor colorWithWhite:0.0 alpha:0.36];
            label.shadowOffset = targetOffset;
        }
    } else if (label.shadowColor) {
        label.shadowColor = nil;
        label.shadowOffset = CGSizeZero;
    }
}

static UIColor *FQXBoostColorForClearGlass(UIColor *color, UITraitCollection *traits, BOOL *changed) {
    if (changed) *changed = NO;
    if (![color isKindOfClass:UIColor.class]) return color;
    UIColor *resolved = traits ? [color resolvedColorWithTraitCollection:traits] : color;
    CGFloat r = 0, g = 0, b = 0, a = 0;
    if (!FQXColorGetRGBA(resolved, &r, &g, &b, &a) || a < 0.05) return color;
    CGFloat lum = 0.299 * r + 0.587 * g + 0.114 * b;
    CGFloat sat = MAX(MAX(r, g), b) - MIN(MIN(r, g), b);
    CGFloat effective = lum * a;
    BOOL darkTheme = FQXCommentsUseDarkTheme();
    if (!darkTheme) {
        // Light Liquid Glass mode: crisp dark ink for primary text, slate gray for secondary metadata.
        if (sat < 0.16) {
            if (lum < 0.26 || (lum > 0.88 && a > 0.94)) {
                if (fabs(lum - 0.07) > 0.03 || a < 0.98) {
                    if (changed) *changed = YES;
                    return [UIColor colorWithWhite:0.07 alpha:1.0];
                }
                return color;
            }
            if (fabs(lum - 0.28) > 0.04 || fabs(a - 0.92) > 0.04) {
                if (changed) *changed = YES;
                return [UIColor colorWithWhite:0.28 alpha:0.92];
            }
            return color;
        }
        if (b > r + 0.12 && b > g + 0.03) {
            if (fabs(r - 0.04) > 0.05 || fabs(g - 0.38) > 0.05 || fabs(b - 0.88) > 0.05 || a < 0.98) {
                if (changed) *changed = YES;
                return FQXRichCommentBlueColor();
            }
        }
        return color;
    }

    if (sat < 0.16) {
        if (lum < 0.38) {
            // Dark/black primary text -> crisp pure white.
            if (changed) *changed = YES;
            return [UIColor colorWithWhite:1.0 alpha:1.0];
        }
        if (effective >= 0.82) {
            // Already primary white/off-white -> brighten to pure 100% white for clarity.
            if (lum < 0.99 || a < 0.99) {
                if (changed) *changed = YES;
                return [UIColor colorWithWhite:1.0 alpha:1.0];
            }
            return color;
        }
        // Secondary / muted grays and translucent whites (usernames, timestamps, placeholders,
        // unselected tabs) -> lift to crisp high-clarity bright white (0.88 alpha).
        if (lum < 0.98 || a < 0.86) {
            if (changed) *changed = YES;
            return [UIColor colorWithWhite:1.0 alpha:0.88];
        }
        return color;
    }
    if (b > r + 0.12 && b > g + 0.03) {
        // Blue links & search query text -> rich, deeper, saturated luminous blue.
        if (fabs(r - 0.18) > 0.04 || fabs(g - 0.56) > 0.04 || b < 0.95 || a < 0.98) {
            if (changed) *changed = YES;
            return FQXRichCommentBlueColor();
        }
    }
    return color;
}

static BOOL FQXHasOpaqueLightBadgeBackground(UIView *view) {
    UIColor *bg = view.backgroundColor;
    if (!bg) return NO;
    CGFloat r = 0, g = 0, b = 0, a = 0;
    if (!FQXColorGetRGBA([bg resolvedColorWithTraitCollection:view.traitCollection], &r, &g, &b, &a)) return NO;
    CGFloat lum = 0.299 * r + 0.587 * g + 0.114 * b;
    CGFloat sat = MAX(MAX(r, g), b) - MIN(MIN(r, g), b);
    // Preserve saturated colored pill buttons (e.g., orange "发表" submit button).
    if (a >= 0.70 && sat >= 0.35 && CGRectGetHeight(view.bounds) <= 46.0 && CGRectGetWidth(view.bounds) <= 120.0) return YES;
    if (FQXCommentsUseDarkTheme()) {
        if (a >= 0.45 && lum >= 0.55) return YES;
    } else {
        if (a >= 0.65 && lum <= 0.25) return YES;
    }
    return NO;
}

static void FQXStyleActiveCommentTextInput(UIView *view) {
    if (!view || (!FQXCommentStylingEnabled() && FQXCurrentCommentComposerStyle() == FQXCommentComposerNative)) return;
    UIColor *targetInk = FQXPrimaryCommentTextColor();
    UIUserInterfaceStyle desiredUIStyle = FQXDesiredCommentInterfaceStyle();
    if ([view isKindOfClass:UITextView.class]) {
        UITextView *tv = (UITextView *)view;
        if (tv.overrideUserInterfaceStyle != desiredUIStyle) {
            tv.overrideUserInterfaceStyle = desiredUIStyle;
        }
        BOOL colorChanged = NO;
        if (!tv.textColor || FQXBoostColorForClearGlass(tv.textColor, tv.traitCollection, &colorChanged) != tv.textColor || colorChanged) {
            tv.textColor = targetInk;
        }
        NSDictionary<NSAttributedStringKey, id> *typing = tv.typingAttributes;
        UIColor *typingColor = typing[NSForegroundColorAttributeName];
        BOOL typingChanged = NO;
        if (!typingColor || FQXBoostColorForClearGlass(typingColor, tv.traitCollection, &typingChanged) != typingColor || typingChanged) {
            NSMutableDictionary<NSAttributedStringKey, id> *mut = typing ? [typing mutableCopy] : [NSMutableDictionary dictionary];
            mut[NSForegroundColorAttributeName] = targetInk;
            tv.typingAttributes = mut;
        }
        // Safely adapt existing typed text in-place when no IME composition (markedTextRange) is active.
        if (tv.textStorage.length > 0 && !tv.markedTextRange) {
            NSRange fullRange = NSMakeRange(0, tv.textStorage.length);
            __block BOOL needsFix = NO;
            [tv.textStorage enumerateAttribute:NSForegroundColorAttributeName inRange:fullRange options:0
                                    usingBlock:^(id val, NSRange range, BOOL *stop) {
                (void)range;
                if (!val) { needsFix = YES; *stop = YES; return; }
                BOOL ch = NO;
                if ([val isKindOfClass:UIColor.class]) {
                    FQXBoostColorForClearGlass((UIColor *)val, tv.traitCollection, &ch);
                    if (ch) { needsFix = YES; *stop = YES; }
                }
            }];
            if (needsFix) {
                [tv.textStorage beginEditing];
                [tv.textStorage addAttribute:NSForegroundColorAttributeName value:targetInk range:fullRange];
                [tv.textStorage endEditing];
            }
        }
        return;
    }
    if ([view isKindOfClass:UITextField.class]) {
        UITextField *tf = (UITextField *)view;
        if (tf.overrideUserInterfaceStyle != desiredUIStyle) {
            tf.overrideUserInterfaceStyle = desiredUIStyle;
        }
        tf.textColor = targetInk;
        NSMutableDictionary<NSAttributedStringKey, id> *defAttrs = tf.defaultTextAttributes
            ? [tf.defaultTextAttributes mutableCopy] : [NSMutableDictionary dictionary];
        defAttrs[NSForegroundColorAttributeName] = targetInk;
        tf.defaultTextAttributes = defAttrs;
        return;
    }
    // Custom text editors (e.g. YYTextView)
    SEL setColorSel = @selector(setTextColor:);
    if ([view respondsToSelector:setColorSel]) {
        ((void (*)(id, SEL, id))objc_msgSend)(view, setColorSel, targetInk);
    }
    SEL getTyping = NSSelectorFromString(@"typingAttributes");
    SEL setTyping = NSSelectorFromString(@"setTypingAttributes:");
    if ([view respondsToSelector:getTyping] && [view respondsToSelector:setTyping]) {
        id cur = ((id (*)(id, SEL))objc_msgSend)(view, getTyping);
        NSMutableDictionary *mut = [cur isKindOfClass:NSDictionary.class] ? [cur mutableCopy] : [NSMutableDictionary dictionary];
        mut[NSForegroundColorAttributeName] = targetInk;
        ((void (*)(id, SEL, id))objc_msgSend)(view, setTyping, mut);
    }
}

static NSAttributedString *FQXBoostAttributedString(NSAttributedString *src, UITraitCollection *traits, BOOL *didModify) {
    if (didModify) *didModify = NO;
    if (![src isKindOfClass:NSAttributedString.class] || src.length == 0) return src;
    __block NSMutableAttributedString *mut = nil;
    NSRange fullRange = NSMakeRange(0, src.length);
    [src enumerateAttribute:NSForegroundColorAttributeName
                    inRange:fullRange
                    options:0
                 usingBlock:^(id val, NSRange range, BOOL *stop) {
        (void)stop;
        if (![val isKindOfClass:UIColor.class]) return;
        BOOL changed = NO;
        UIColor *boosted = FQXBoostColorForClearGlass((UIColor *)val, traits, &changed);
        if (changed && boosted) {
            if (!mut) mut = [src mutableCopy];
            [mut addAttribute:NSForegroundColorAttributeName value:boosted range:range];
            [mut addAttribute:FQXCTForegroundColorAttr value:(id)boosted.CGColor range:range];
        }
    }];
    // YYLabel / FQCCommentContentLabel also writes CoreText CTForegroundColor (CGColorRef).
    NSAttributedString *pass2Src = mut ?: src;
    [pass2Src enumerateAttribute:FQXCTForegroundColorAttr
                         inRange:fullRange
                         options:0
                      usingBlock:^(id val, NSRange range, BOOL *stop) {
        (void)stop;
        if (!val) return;
        UIColor *uiCol = [val isKindOfClass:UIColor.class]
            ? (UIColor *)val
            : [UIColor colorWithCGColor:(__bridge CGColorRef)val];
        BOOL changed = NO;
        UIColor *boosted = FQXBoostColorForClearGlass(uiCol, traits, &changed);
        if (changed && boosted) {
            if (!mut) mut = [src mutableCopy];
            [mut addAttribute:NSForegroundColorAttributeName value:boosted range:range];
            [mut addAttribute:FQXCTForegroundColorAttr value:(id)boosted.CGColor range:range];
        }
    }];
    // If no foreground color attribute was present on a run, apply mode's primary text color.
    if (!mut) {
        __block BOOL hasAnyColor = NO;
        [src enumerateAttributesInRange:fullRange options:0 usingBlock:^(NSDictionary<NSAttributedStringKey,id> *attrs, NSRange range, BOOL *stop) {
            (void)range;
            if (attrs[NSForegroundColorAttributeName] || attrs[FQXCTForegroundColorAttr]) {
                hasAnyColor = YES;
                *stop = YES;
            }
        }];
        if (!hasAnyColor) {
            mut = [src mutableCopy];
            UIColor *primary = FQXPrimaryCommentTextColor();
            [mut addAttribute:NSForegroundColorAttributeName value:primary range:fullRange];
            [mut addAttribute:FQXCTForegroundColorAttr value:(id)primary.CGColor range:fullRange];
        }
    }
    if (mut) {
        if (didModify) *didModify = YES;
        return mut;
    }
    return src;
}

static void FQXBoostCommentTypography(UIView *view, NSInteger depth) {
    if (!FQXCommentStylingEnabled() || ![view isKindOfClass:UIView.class] || depth > 14) return;
    if (FQXCurrentCommentMaterialStyle() == FQXCommentMaterialRegularGlass &&
        !FQXCommentAppearanceOverrideActive()) return;
    if ([view isKindOfClass:UIVisualEffectView.class]) return;
    if (depth > 0 && FQXHasOpaqueLightBadgeBackground(view)) return;

    NSUInteger mode = ((NSUInteger)FQXCurrentCommentMaterialStyle() << 1) | (FQXCommentsUseDarkTheme() ? 1u : 0u);
    UITraitCollection *traits = view.traitCollection;
    if ([view isKindOfClass:UILabel.class]) {
        UILabel *label = (UILabel *)view;
        FQXSyncLabelShadowForCommentMode(label);
        BOOL changed = NO;
        UIColor *boosted = FQXBoostColorForClearGlass(label.textColor, traits, &changed);
        if (changed && boosted) {
            label.textColor = boosted;
        }
        if (label.attributedText.length > 0) {
            NSUInteger stamp = ((NSUInteger)mode << 28) ^ (label.attributedText.string.hash & 0x0FFFFFFF);
            NSNumber *prevStamp = objc_getAssociatedObject(label, FQXCommentTypographyStampKey);
            if (!prevStamp || prevStamp.unsignedIntegerValue != stamp) {
                BOOL attrChanged = NO;
                NSAttributedString *boostedAttr = FQXBoostAttributedString(label.attributedText, traits, &attrChanged);
                if (attrChanged && boostedAttr) {
                    label.attributedText = boostedAttr;
                }
                objc_setAssociatedObject(label, FQXCommentTypographyStampKey, @(stamp), OBJC_ASSOCIATION_RETAIN_NONATOMIC);
            }
        }
        return;
    }
    if ([view isKindOfClass:UIButton.class]) {
        UIButton *btn = (UIButton *)view;
        BOOL titleChanged = NO;
        UIColor *titleColor = [btn titleColorForState:UIControlStateNormal];
        UIColor *boostedTitle = FQXBoostColorForClearGlass(titleColor, traits, &titleChanged);
        if (titleChanged && boostedTitle) [btn setTitleColor:boostedTitle forState:UIControlStateNormal];
        BOOL tintChanged = NO;
        UIColor *boostedTint = FQXBoostColorForClearGlass(btn.tintColor, traits, &tintChanged);
        if (tintChanged && boostedTint) btn.tintColor = boostedTint;
    } else if ([view isKindOfClass:UIImageView.class]) {
        UIImageView *iv = (UIImageView *)view;
        if (iv.image && iv.image.renderingMode == UIImageRenderingModeAlwaysTemplate) {
            BOOL tintChanged = NO;
            UIColor *boostedTint = FQXBoostColorForClearGlass(iv.tintColor, traits, &tintChanged);
            if (tintChanged && boostedTint) iv.tintColor = boostedTint;
        }
        return;
    } else if ([view isKindOfClass:UITextView.class] || [view isKindOfClass:UITextField.class]) {
        FQXStyleActiveCommentTextInput(view);
        return;
    } else {
        // Custom rich-text comment labels (YYLabel / FQCCommentContentLabel / FQCShortVideoCommentLabel)
        SEL setIsDarkSel = NSSelectorFromString(@"setIsDark:");
        if ([view respondsToSelector:setIsDarkSel]) {
            BOOL desiredDark = FQXCommentsUseDarkTheme();
            SEL getIsDarkSel = NSSelectorFromString(@"isDark");
            BOOL needsSet = YES;
            if ([view respondsToSelector:getIsDarkSel]) {
                Method gm = class_getInstanceMethod(object_getClass(view), getIsDarkSel);
                const char *enc = gm ? method_getTypeEncoding(gm) : NULL;
                if (enc && (enc[0] == 'B' || enc[0] == 'c')) {
                    needsSet = (((BOOL (*)(id, SEL))objc_msgSend)(view, getIsDarkSel) != desiredDark);
                }
            }
            if (needsSet) {
                Method sm = class_getInstanceMethod(object_getClass(view), setIsDarkSel);
                if (sm && method_getNumberOfArguments(sm) == 3) {
                    ((void (*)(id, SEL, BOOL))objc_msgSend)(view, setIsDarkSel, desiredDark);
                }
            }
        }
        SEL getColor = @selector(textColor);
        SEL setColor = @selector(setTextColor:);
        if ([view respondsToSelector:getColor] && [view respondsToSelector:setColor]) {
            id curColor = ((id (*)(id, SEL))objc_msgSend)(view, getColor);
            if ([curColor isKindOfClass:UIColor.class]) {
                BOOL cChanged = NO;
                UIColor *boosted = FQXBoostColorForClearGlass((UIColor *)curColor, traits, &cChanged);
                if (cChanged && boosted) {
                    ((void (*)(id, SEL, id))objc_msgSend)(view, setColor, boosted);
                }
            }
        }
        // YYLabel often renders directly from cached textLayout instead of attributedText!
        // Stamp (mode, string.hash) so 120Hz scrolling skips cloning & YYTextLayout rebuilds when unchanged.
        SEL getLayout = NSSelectorFromString(@"textLayout");
        SEL setLayout = NSSelectorFromString(@"setTextLayout:");
        BOOL handledLayout = NO;
        if ([view respondsToSelector:getLayout] && [view respondsToSelector:setLayout]) {
            id layout = ((id (*)(id, SEL))objc_msgSend)(view, getLayout);
            SEL textSel = NSSelectorFromString(@"text");
            SEL containerSel = NSSelectorFromString(@"container");
            if (layout && [layout respondsToSelector:textSel] && [layout respondsToSelector:containerSel]) {
                id lText = ((id (*)(id, SEL))objc_msgSend)(layout, textSel);
                id container = ((id (*)(id, SEL))objc_msgSend)(layout, containerSel);
                if ([lText isKindOfClass:NSAttributedString.class] && container) {
                    NSAttributedString *as = (NSAttributedString *)lText;
                    NSUInteger containerHash = [container respondsToSelector:@selector(hash)] ? ([container hash] & 0xFFFF) : 0;
                    NSUInteger stamp = ((NSUInteger)mode << 28) ^ (as.string.hash & 0x0FFFFFFF) ^ containerHash;
                    NSNumber *prevStamp = objc_getAssociatedObject(view, FQXCommentTypographyStampKey);
                    if (prevStamp && prevStamp.unsignedIntegerValue == stamp) {
                        handledLayout = YES;
                    } else {
                        BOOL lChanged = NO;
                        NSAttributedString *boostedL = FQXBoostAttributedString(as, traits, &lChanged);
                        if (lChanged && boostedL) {
                            Class layoutCls = [layout class];
                            SEL makeLayout = NSSelectorFromString(@"layoutWithContainer:text:");
                            if ([layoutCls respondsToSelector:makeLayout]) {
                                id newLayout = ((id (*)(id, SEL, id, id))objc_msgSend)(layoutCls, makeLayout, container, boostedL);
                                if (newLayout) {
                                    ((void (*)(id, SEL, id))objc_msgSend)(view, setLayout, newLayout);
                                    handledLayout = YES;
                                }
                            }
                        } else {
                            handledLayout = YES;
                        }
                        objc_setAssociatedObject(view, FQXCommentTypographyStampKey, @(stamp), OBJC_ASSOCIATION_RETAIN_NONATOMIC);
                    }
                }
            }
        }
        SEL getAttr = @selector(attributedText);
        SEL setAttr = @selector(setAttributedText:);
        if (!handledLayout && [view respondsToSelector:getAttr] && [view respondsToSelector:setAttr]) {
            id curAttr = ((id (*)(id, SEL))objc_msgSend)(view, getAttr);
            if ([curAttr isKindOfClass:NSAttributedString.class]) {
                NSAttributedString *as = (NSAttributedString *)curAttr;
                NSUInteger stamp = ((NSUInteger)mode << 28) ^ (as.string.hash & 0x0FFFFFFF);
                NSNumber *prevStamp = objc_getAssociatedObject(view, FQXCommentTypographyStampKey);
                if (!prevStamp || prevStamp.unsignedIntegerValue != stamp) {
                    BOOL attrChanged = NO;
                    NSAttributedString *boostedAttr = FQXBoostAttributedString(as, traits, &attrChanged);
                    if (attrChanged && boostedAttr) {
                        ((void (*)(id, SEL, id))objc_msgSend)(view, setAttr, boostedAttr);
                    }
                    objc_setAssociatedObject(view, FQXCommentTypographyStampKey, @(stamp), OBJC_ASSOCIATION_RETAIN_NONATOMIC);
                }
            }
        }
    }

    for (UIView *sub in view.subviews) {
        FQXBoostCommentTypography(sub, depth + 1);
    }
}

static void FQXHideLayerGradients(CALayer *layer, BOOL hide) {
    if (!layer) return;
    for (CALayer *sub in layer.sublayers) {
        if ([sub isKindOfClass:CAGradientLayer.class]) {
            FQXAudioHideGradient(sub, hide);
        }
    }
}

static void FQXExtendCommentCollectionForFloatingBar(UIScrollView *scrollView, UIView *bar, BOOL active) {
    if (![scrollView isKindOfClass:UIScrollView.class] || !scrollView.superview) return;
    UIView *parent = scrollView.superview;
    CGFloat parentH = CGRectGetHeight(parent.bounds);
    if (parentH < 120.0) return;

    NSNumber *savedBottom = objc_getAssociatedObject(scrollView, CommentCollectionStockInsetKey);
    if (!active) {
        if (savedBottom) {
            UIEdgeInsets ins = scrollView.contentInset;
            CGFloat orig = savedBottom.doubleValue;
            if (fabs(ins.bottom - orig) > 0.5) {
                ins.bottom = orig;
                scrollView.contentInset = ins;
            }
            if ([scrollView isKindOfClass:UICollectionView.class]) {
                UIEdgeInsets ind = scrollView.verticalScrollIndicatorInsets;
                if (fabs(ind.bottom - orig) > 0.5) {
                    ind.bottom = orig;
                    scrollView.verticalScrollIndicatorInsets = ind;
                }
            }
            objc_setAssociatedObject(scrollView, CommentCollectionStockInsetKey, nil, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
        }
        return;
    }

    CGRect frame = scrollView.frame;
    CGFloat gapToBottom = parentH - CGRectGetMaxY(frame);
    if (gapToBottom > 2.0 && gapToBottom < 180.0) {
        frame.size.height = parentH - frame.origin.y;
        scrollView.frame = frame;
    }

    if (!savedBottom) {
        savedBottom = @(scrollView.contentInset.bottom);
        objc_setAssociatedObject(scrollView, CommentCollectionStockInsetKey, savedBottom, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
    }
    CGFloat barHeight = (bar && CGRectGetHeight(bar.bounds) > 20.0) ? CGRectGetHeight(bar.bounds) : 80.0;
    CGFloat targetBottom = MAX(savedBottom.doubleValue, MIN(136.0, barHeight + 16.0));
    UIEdgeInsets ins = scrollView.contentInset;
    if (fabs(ins.bottom - targetBottom) > 0.5) {
        ins.bottom = targetBottom;
        scrollView.contentInset = ins;
    }
    if ([scrollView isKindOfClass:UICollectionView.class]) {
        UIEdgeInsets ind = scrollView.verticalScrollIndicatorInsets;
        if (fabs(ind.bottom - targetBottom) > 0.5) {
            ind.bottom = targetBottom;
            scrollView.verticalScrollIndicatorInsets = ind;
        }
    }
    if (bar && bar.superview == parent && parent.subviews.lastObject != bar) {
        [parent bringSubviewToFront:bar];
    }
}

static void FQXExtendSiblingScrollForCommentBar(UIView *toolbar, BOOL active) {
    UIView *parent = toolbar.superview;
    if (!parent) return;
    CGFloat parentW = CGRectGetWidth(parent.bounds);
    for (UIView *sub in [parent.subviews copy]) {
        if (sub == toolbar || ![sub isKindOfClass:UIScrollView.class]) continue;
        if (CGRectGetWidth(sub.bounds) < parentW * 0.85 || CGRectGetHeight(sub.bounds) < 120.0) continue;
        UIScrollView *sv = (UIScrollView *)sub;
        FQXExtendCommentCollectionForFloatingBar(sv, toolbar, active);
        for (UIView *inner in [sv.subviews copy]) {
            if ([inner isKindOfClass:UICollectionView.class] &&
                CGRectGetWidth(inner.bounds) >= parentW * 0.85 &&
                CGRectGetHeight(inner.bounds) >= 120.0) {
                FQXExtendCommentCollectionForFloatingBar((UIScrollView *)inner, toolbar, active);
            }
        }
    }
}

static const void *FQXCommentSavedLayerBgKey = &FQXCommentSavedLayerBgKey;
static const void *FQXCommentSavedEdgeHiddenKey = &FQXCommentSavedEdgeHiddenKey;
static void FQXClearCommentSurface(UIView *view, BOOL clear);

static NSHashTable<UIView *> *FQXTrackedCommentCleanedViews(void) {
    static NSHashTable<UIView *> *table;
    static dispatch_once_t once;
    dispatch_once(&once, ^{ table = [NSHashTable weakObjectsHashTable]; });
    return table;
}

static NSHashTable<UIVisualEffectView *> *FQXTrackedNeutralizedEffectViews(void) {
    static NSHashTable<UIVisualEffectView *> *table;
    static dispatch_once_t once;
    dispatch_once(&once, ^{ table = [NSHashTable weakObjectsHashTable]; });
    return table;
}

static NSHashTable<UIView *> *FQXTrackedSuppressedScrollEdges(void) {
    static NSHashTable<UIView *> *table;
    static dispatch_once_t once;
    dispatch_once(&once, ^{ table = [NSHashTable weakObjectsHashTable]; });
    return table;
}

static void FQXNeutralizeHostEffectView(UIVisualEffectView *effectView, BOOL active) {
    if (![effectView isKindOfClass:UIVisualEffectView.class]) return;
    if ([effectView isKindOfClass:FQXCommentGlassSurfaceView.class] ||
        [effectView isKindOfClass:FQXBackdropBlurView.class]) return;
    if (active) [FQXTrackedNeutralizedEffectViews() addObject:effectView];
    UIVisualEffect *saved = objc_getAssociatedObject(effectView, CommentStockEffectKey);
    if (active) {
        if (!saved && effectView.effect) {
            objc_setAssociatedObject(effectView, CommentStockEffectKey, effectView.effect, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
        }
        if (effectView.effect) effectView.effect = nil;
    } else if (saved) {
        if (!effectView.effect) effectView.effect = saved;
        objc_setAssociatedObject(effectView, CommentStockEffectKey, nil, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
    }
    FQXClearCommentSurface(effectView, active);
    FQXClearCommentSurface(effectView.contentView, active);
    FQXAudioSetHiddenTracked(effectView, active);
}

static void FQXNeutralizeStrayBarGlass(UIView *view, UIVisualEffectView *keepGlass, BOOL active, NSInteger depth) {
    if (![view isKindOfClass:UIView.class] || depth > 4) return;
    static Class glassBtnCls = Nil;
    static dispatch_once_t once;
    dispatch_once(&once, ^{ glassBtnCls = NSClassFromString(@"FQXGlassBackground167"); });
    for (UIView *child in view.subviews) {
        if (child == keepGlass ||
            [child isKindOfClass:FQXCommentGlassSurfaceView.class] ||
            [child isKindOfClass:FQXBackdropBlurView.class]) continue;
        if ([child isKindOfClass:UIVisualEffectView.class]) {
            FQXNeutralizeHostEffectView((UIVisualEffectView *)child, active);
            continue;
        }
        if (glassBtnCls && [child isKindOfClass:glassBtnCls]) {
            FQXAudioSetHiddenTracked(child, active);
            continue;
        }
        FQXNeutralizeStrayBarGlass(child, keepGlass, active, depth + 1);
    }
}

static const void *SheetGlassKey = &SheetGlassKey;
static const void *FQXBarIsFloatingPillKey = &FQXBarIsFloatingPillKey;
static const void *FQXComposerFloatingKey = &FQXComposerFloatingKey;

static UIViewController *FQXFindOwningViewController(UIView *view) {
    for (UIResponder *resp = view.nextResponder; resp; resp = resp.nextResponder) {
        if ([resp isKindOfClass:UIViewController.class]) return (UIViewController *)resp;
    }
    return nil;
}

static BOOL FQXViewIsVisibleInWindow(UIView *view, UIWindow *window) {
    if (![view isKindOfClass:UIView.class] || !window || view.window != window) return NO;
    for (UIView *cur = view; cur && cur != window; cur = cur.superview) {
        if (cur.hidden || cur.alpha < 0.05) return NO;
    }
    return CGRectGetWidth(view.bounds) >= 44.0 && CGRectGetHeight(view.bounds) >= 24.0;
}

static void FQXRemoveSheetTopRimLayer(UIView *sheet) {
    if (!sheet) return;
    CAShapeLayer *rim = objc_getAssociatedObject(sheet, FQXSheetTopRimLayerKey);
    if (rim) {
        [rim removeFromSuperlayer];
        objc_setAssociatedObject(sheet, FQXSheetTopRimLayerKey, nil, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
    }
}

static void FQXRestoreSheetTopCornerMask(UIView *sheet) {
    if (!sheet) return;
    FQXRemoveSheetTopRimLayer(sheet);
    NSNumber *savedClips = objc_getAssociatedObject(sheet, SheetSavedClipsKey);
    if (savedClips) {
        sheet.clipsToBounds = savedClips.boolValue;
        objc_setAssociatedObject(sheet, SheetSavedClipsKey, nil, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
    }
    NSNumber *savedRad = objc_getAssociatedObject(sheet, FQXSheetSavedCornerRadiusKey);
    if (savedRad) {
        sheet.layer.cornerRadius = savedRad.doubleValue;
        objc_setAssociatedObject(sheet, FQXSheetSavedCornerRadiusKey, nil, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
    }
    NSNumber *savedMask = objc_getAssociatedObject(sheet, FQXSheetSavedMaskedCornersKey);
    if (savedMask) {
        sheet.layer.maskedCorners = (CACornerMask)savedMask.unsignedIntegerValue;
        objc_setAssociatedObject(sheet, FQXSheetSavedMaskedCornersKey, nil, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
    }
    NSString *savedCurve = objc_getAssociatedObject(sheet, FQXSheetSavedCornerCurveKey);
    if (savedCurve) {
        sheet.layer.cornerCurve = savedCurve;
        objc_setAssociatedObject(sheet, FQXSheetSavedCornerCurveKey, nil, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
    }
}

static NSHashTable<UIView *> *FQXTrackedExpandedComposers(void) {
    static NSHashTable<UIView *> *table;
    static dispatch_once_t once;
    dispatch_once(&once, ^{ table = [NSHashTable weakObjectsHashTable]; });
    return table;
}

static NSHashTable<UIView *> *FQXTrackedCommentBars(void) {
    static NSHashTable<UIView *> *table;
    static dispatch_once_t once;
    dispatch_once(&once, ^{ table = [NSHashTable weakObjectsHashTable]; });
    return table;
}

static UIView *FQXEnclosingStyledCommentSheetForBar(UIView *toolbar) {
    if (![toolbar isKindOfClass:UIView.class] || !toolbar.window) return nil;
    UIWindow *win = toolbar.window;
    for (UIView *cur = toolbar.superview; cur && cur != win; cur = cur.superview) {
        UIVisualEffectView *sheetGlass = objc_getAssociatedObject(cur, SheetGlassKey);
        if (sheetGlass && sheetGlass.superview == cur && !sheetGlass.hidden) {
            return cur;
        }
    }
    return nil;
}

static CGFloat FQXComputeSheetYieldBottomY(UIView *sheet) {
    CGFloat sheetH = CGRectGetHeight(sheet.bounds);
    CGFloat sheetW = CGRectGetWidth(sheet.bounds);
    UIWindow *win = sheet.window;
    if (!win || sheetH < 44.0 || sheetW < 60.0) return sheetH;
    CGFloat yieldY = sheetH;
    NSMutableArray<UIView *> *candidates = nil;
    for (UIView *bar in FQXTrackedCommentBars().allObjects) {
        if ([bar isDescendantOfView:sheet]) continue;
        if ([objc_getAssociatedObject(bar, FQXBarIsFloatingPillKey) boolValue]) continue;
        UIVisualEffectView *barGlass = objc_getAssociatedObject(bar, DramaComposerGlassKey);
        if (barGlass && barGlass.superview == bar && !barGlass.hidden &&
            (barGlass.effect != nil || [barGlass isKindOfClass:FQXBackdropBlurView.class])) {
            if (!candidates) candidates = [NSMutableArray array];
            [candidates addObject:bar];
        }
    }
    for (UIView *host in FQXTrackedCommentComposerHosts().allObjects) {
        if ([objc_getAssociatedObject(host, FQXComposerFloatingKey) boolValue]) continue;
        UIVisualEffectView *hostGlass = objc_getAssociatedObject(host, DramaComposerGlassKey);
        if (hostGlass && hostGlass.superview == host && !hostGlass.hidden &&
            (hostGlass.effect != nil || [hostGlass isKindOfClass:FQXBackdropBlurView.class])) {
            if (!candidates) candidates = [NSMutableArray array];
            [candidates addObject:host];
        }
    }
    for (UIView *docked in candidates) {
        if (docked == sheet || !FQXViewIsVisibleInWindow(docked, win)) continue;
        CGRect inSheet = [docked convertRect:docked.bounds toView:sheet];
        if (CGRectGetWidth(inSheet) < sheetW * 0.60) continue;
        if (CGRectGetMaxY(inSheet) < sheetH - 24.0) continue;
        CGFloat topInSheet = CGRectGetMinY(inSheet);
        if (topInSheet < yieldY - 0.5) {
            yieldY = MAX(0.0, topInSheet);
        }
    }
    return yieldY;
}

static void FQXApplySheetYieldGeometry(UIView *sheet, UIVisualEffectView *glass) {
    if (!sheet || !glass) return;
    CGFloat sheetW = CGRectGetWidth(sheet.bounds);
    CGFloat yieldY = FQXComputeSheetYieldBottomY(sheet);
    if (yieldY < 24.0 || sheetW < 44.0) {
        if (!glass.hidden) glass.hidden = YES;
        return;
    }
    if (glass.hidden) glass.hidden = NO;
    CGRect target = CGRectMake(0.0, 0.0, sheetW, yieldY);
    if (!CGRectEqualToRect(glass.frame, target)) glass.frame = target;
}

static void FQXResyncVisibleCommentSheetYields(UIWindow *window) {
    if (!window) return;
    for (UIView *sheet in FQXTrackedCommentSheetHosts().allObjects) {
        if (!sheet.window || sheet.window != window) continue;
        UIVisualEffectView *glass = objc_getAssociatedObject(sheet, SheetGlassKey);
        if (!glass || glass.superview != sheet) continue;
        FQXApplySheetYieldGeometry(sheet, glass);
    }
}

static BOOL FQXPlaceCommentComposerGlass(UIView *host, CGRect frame, CGFloat radius, BOOL dark, BOOL nestedPill) {
    (void)dark;
    (void)nestedPill;
    if (![host isKindOfClass:UIView.class]) return NO;
    [FQXTrackedCommentComposerHosts() addObject:host];
    UIVisualEffectView *glass = objc_getAssociatedObject(host, DramaComposerGlassKey);
    FQXCommentComposerStyle compStyle = FQXCurrentCommentComposerStyle();
    BOOL active = host.window && compStyle != FQXCommentComposerNative && !CGRectIsNull(frame) &&
                  CGRectGetWidth(frame) >= 44.0 && CGRectGetHeight(frame) >= 30.0;
    if (!active) {
        if (glass) {
            FQXReleaseCommentSurface(glass);
            objc_setAssociatedObject(host, DramaComposerGlassKey, nil, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
        }
        objc_setAssociatedObject(host, FQXComposerFloatingKey, nil, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
        FQXRestoreSheetTopCornerMask(host);
        FQXResyncVisibleCommentSheetYields(host.window);
        return NO;
    }

    BOOL floatingDetached = (compStyle == FQXCommentComposerFloatingDetached);
    objc_setAssociatedObject(host, FQXComposerFloatingKey, @(floatingDetached), OBJC_ASSOCIATION_RETAIN_NONATOMIC);
    FQXCommentMaterialStyle matStyle = FQXComposerEffectiveMaterialStyle();
    BOOL darkTheme = FQXCommentsUseDarkTheme();
    FQXCommentCornerKind cornerKind = floatingDetached ? FQXCommentCornerFloatingCard : FQXCommentCornerTopSheet;
    CGFloat cornerRadius = floatingDetached ? 24.0 : (radius > 0.0 ? MIN(radius, 16.0) : 12.0);

    glass = FQXEnsureCommentSurface(host, DramaComposerGlassKey, matStyle);
    if (!glass) return NO;

    [CATransaction begin];
    [CATransaction setDisableActions:YES];
    if (!CGRectEqualToRect(glass.frame, frame)) glass.frame = frame;
    FQXRestoreSheetTopCornerMask(host);
    if ([glass isKindOfClass:FQXCommentGlassSurfaceView.class]) {
        FQXCommentGlassSurfaceView *gs = (FQXCommentGlassSurfaceView *)glass;
        gs.flexSourceView = host;
        gs.isBarGlass = !floatingDetached;
    }
    if (floatingDetached && matStyle == FQXCommentMaterialGaussianBlur) {
        glass.layer.shadowColor = UIColor.blackColor.CGColor;
        glass.layer.shadowOpacity = darkTheme ? 0.30f : 0.12f;
        glass.layer.shadowRadius = 14.0;
        glass.layer.shadowOffset = CGSizeMake(0.0, 4.0);
    } else if ([glass isKindOfClass:FQXBackdropBlurView.class]) {
        glass.layer.shadowOpacity = 0.0f;
        glass.layer.shadowRadius = 0.0;
    }
    if (host.subviews.firstObject != glass) [host insertSubview:glass atIndex:0];
    FQXApplyCommentCornerConfig(glass, cornerKind, cornerRadius);
    [CATransaction commit];

    FQXSyncCommentSurface(glass, FQXFindOwningViewController(host), matStyle, cornerKind, cornerRadius, YES);
    FQXResyncVisibleCommentSheetYields(host.window);
    return YES;
}

static NSHashTable<UIViewController *> *FQXTrackedCommentPanels(void) {
    static NSHashTable<UIViewController *> *table;
    static dispatch_once_t once;
    dispatch_once(&once, ^{ table = [NSHashTable weakObjectsHashTable]; });
    return table;
}
static NSHashTable<UIViewController *> *FQXTrackedCommentLists(void) {
    static NSHashTable<UIViewController *> *table;
    static dispatch_once_t once;
    dispatch_once(&once, ^{ table = [NSHashTable weakObjectsHashTable]; });
    return table;
}
static NSHashTable<UIViewController *> *FQXTrackedSeriesCommentLists(void) {
    static NSHashTable<UIViewController *> *table;
    static dispatch_once_t once;
    dispatch_once(&once, ^{ table = [NSHashTable weakObjectsHashTable]; });
    return table;
}
static NSHashTable<UIViewController *> *FQXTrackedReaderCommentLists(void) {
    static NSHashTable<UIViewController *> *table;
    static dispatch_once_t once;
    dispatch_once(&once, ^{ table = [NSHashTable weakObjectsHashTable]; });
    return table;
}
static NSHashTable<UIView *> *FQXTrackedSearchEntrances(void) {
    static NSHashTable<UIView *> *table;
    static dispatch_once_t once;
    dispatch_once(&once, ^{ table = [NSHashTable weakObjectsHashTable]; });
    return table;
}
static void FQXStyleCommentBar(UIView *toolbar) {
    static Class toolbarBaseCls = Nil;
    static dispatch_once_t once;
    dispatch_once(&once, ^{ toolbarBaseCls = NSClassFromString(@"FQCCommentBottomToolBar"); });
    if (!toolbarBaseCls || ![toolbar isKindOfClass:toolbarBaseCls]) return;
    [FQXTrackedCommentBars() addObject:toolbar];
    UIView *text = FQXObjGet(toolbar, "textView");
    UIView *placeholder = FQXObjGet(toolbar, "placeholderLabel");
    UIView *contentLabel = FQXRawIvarObj(toolbar, "_contentLabel");
    UIView *image = FQXObjGet(toolbar, "addImageBtn") ?: FQXObjGet(toolbar, "textViewAddImageBtn");
    UIView *emoji = FQXObjGet(toolbar, "textViewEmojiBtn") ?: FQXObjGet(toolbar, "emojiBtn");
    UIView *aigc = FQXObjGet(toolbar, "textViewAIGCImageBtn");
    UIView *bg = FQXObjGet(toolbar, "bgView");
    FQXCommentMaterialStyle matStyle = FQXCurrentCommentMaterialStyle();
    CGFloat tbW = CGRectGetWidth(toolbar.bounds);
    CGFloat tbH = CGRectGetHeight(toolbar.bounds);
    BOOL styled = toolbar.window && FQXCommentStylingEnabled() && tbW >= 44.0 && tbH >= 24.0;
    UIView *enclosingSheet = styled ? FQXEnclosingStyledCommentSheetForBar(toolbar) : nil;
    UIVisualEffectView *barGlass = objc_getAssociatedObject(toolbar, DramaComposerGlassKey);
    if (!styled) {
        if (barGlass) {
            FQXReleaseCommentSurface(barGlass);
            objc_setAssociatedObject(toolbar, DramaComposerGlassKey, nil, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
            barGlass = nil;
        }
        objc_setAssociatedObject(toolbar, FQXBarIsFloatingPillKey, nil, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
    } else {
        CGRect row = CGRectNull;
        UIView *rowCandidates[7] = {placeholder, contentLabel, text, image, emoji, aigc, bg};
        for (int i = 0; i < 7; ++i) {
            UIView *v = rowCandidates[i];
            if (!v || v == toolbar || ![v isDescendantOfView:toolbar] || v.hidden || v.alpha < 0.01) continue;
            CGFloat vh = CGRectGetHeight(v.bounds);
            if (vh <= 1.0 || (v == bg && (vh < 24.0 || vh > 56.0))) continue;
            row = CGRectUnion(row, [v convertRect:v.bounds toView:toolbar]);
        }
        for (UIView *child in toolbar.subviews) {
            if (child == barGlass || child.hidden || child.alpha < 0.01) continue;
            if ([child isKindOfClass:UIControl.class] || [child isKindOfClass:UILabel.class]) {
                CGFloat ch = CGRectGetHeight(child.bounds);
                if (ch >= 14.0 && ch <= 52.0 && CGRectGetWidth(child.bounds) >= 14.0) {
                    row = CGRectUnion(row, child.frame);
                }
            }
        }
        CGFloat insetX = 12.0;
        CGFloat pillW = MAX(44.0, tbW - insetX * 2.0);
        CGFloat pillH = 0.0;
        CGFloat pillY = 0.0;
        if (!CGRectIsNull(row)) {
            pillH = MIN(50.0, MAX(44.0, CGRectGetHeight(row) + 10.0));
            if (pillH > tbH) pillH = MAX(32.0, tbH);
            pillY = MAX(0.0, MIN(tbH - pillH, CGRectGetMidY(row) - pillH * 0.5));
        } else {
            pillH = MIN(46.0, MAX(32.0, tbH - 4.0));
            pillY = (tbH > 58.0) ? 6.0 : MAX(0.0, (tbH - pillH) * 0.5);
        }
        CGRect pillFrame = CGRectMake(insetX, pillY, pillW, pillH);

        barGlass = FQXEnsureCommentSurface(toolbar, DramaComposerGlassKey, matStyle);
        if (barGlass) {
            [CATransaction begin];
            [CATransaction setDisableActions:YES];
            if (!CGRectEqualToRect(barGlass.frame, pillFrame)) barGlass.frame = pillFrame;
            if ([barGlass isKindOfClass:FQXCommentGlassSurfaceView.class]) {
                FQXCommentGlassSurfaceView *gs = (FQXCommentGlassSurfaceView *)barGlass;
                gs.flexSourceView = toolbar;
                gs.isBarGlass = NO;
                gs.disablesSupplementalBlur = (enclosingSheet != nil);
            }
            if (toolbar.subviews.firstObject != barGlass) [toolbar insertSubview:barGlass atIndex:0];
            FQXApplyCommentCornerConfig(barGlass, FQXCommentCornerCapsule, 0.0);
            [CATransaction commit];
            FQXSyncCommentSurface(barGlass, FQXFindOwningViewController(toolbar), matStyle,
                                  FQXCommentCornerCapsule, 0.0, YES);
            if ([barGlass isKindOfClass:FQXBackdropBlurView.class]) {
                if (enclosingSheet != nil) {
                    BOOL dark = FQXCommentsUseDarkTheme();
                    barGlass.layer.borderWidth = 0.5;
                    barGlass.layer.borderColor = (dark
                        ? [UIColor colorWithWhite:1.0 alpha:0.22]
                        : [UIColor colorWithWhite:0.0 alpha:0.12]).CGColor;
                } else if (barGlass.layer.borderWidth > 0.0) {
                    barGlass.layer.borderWidth = 0.0;
                    barGlass.layer.borderColor = NULL;
                }
            }
            objc_setAssociatedObject(toolbar, FQXBarIsFloatingPillKey, @YES, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
        } else {
            styled = NO;
            objc_setAssociatedObject(toolbar, FQXBarIsFloatingPillKey, nil, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
        }
    }
    CGPoint position = FQXAudioStockCenter(toolbar);
    BOOL liftBar = styled && tbH >= 56.0;
    if (liftBar) position.y -= 6.0;
    FQXAudioPlaceView(toolbar, position, liftBar);
    FQXClearCommentSurface(toolbar, styled);

    if (bg) {
        FQXClearCommentSurface(bg, styled);
        if (styled && bg.layer.borderWidth > 0.0) bg.layer.borderWidth = 0.0;
    }

    FQXClearCommentSurface(text, styled);
    if (styled && text && text.layer.borderWidth > 0.0) text.layer.borderWidth = 0.0;
    if (styled) {
        UIVisualEffectView *keepGlass = objc_getAssociatedObject(toolbar, DramaComposerGlassKey);
        for (UIView *child in toolbar.subviews) {
            if (child == keepGlass || child == bg ||
                [child isKindOfClass:FQXCommentGlassSurfaceView.class] ||
                [child isKindOfClass:FQXBackdropBlurView.class] ||
                [child isKindOfClass:UIControl.class] ||
                [child isKindOfClass:UILabel.class] || [child isKindOfClass:UIImageView.class]) continue;
            if (CGRectGetWidth(child.bounds) >= 80.0) {
                FQXClearCommentSurface(child, YES);
                if (child.layer.borderWidth > 0.0) child.layer.borderWidth = 0.0;
                for (UIView *grand in child.subviews) {
                    if ([grand isKindOfClass:FQXCommentGlassSurfaceView.class] ||
                        [grand isKindOfClass:FQXBackdropBlurView.class] ||
                        [grand isKindOfClass:UIControl.class] || [grand isKindOfClass:UILabel.class] ||
                        [grand isKindOfClass:UIImageView.class]) continue;
                    if (CGRectGetWidth(grand.bounds) >= 80.0) {
                        FQXClearCommentSurface(grand, YES);
                        if (grand.layer.borderWidth > 0.0) grand.layer.borderWidth = 0.0;
                    }
                }
            }
        }
    }
    FQXClearCommentSurface(FQXRawIvarObj(toolbar, "_sendButtonBackgroundImageview"), styled);
    FQXClearCommentSurface(FQXRawIvarObj(toolbar, "_addImageBtnCoverView"), styled);
    FQXClearCommentSurface(FQXRawIvarObj(toolbar, "_addAIGCImageBtnCoverView"), styled);
    FQXClearCommentSurface(FQXRawIvarObj(toolbar, "_sendBtnCoverView"), styled);
    FQXClearCommentSurface(image, styled);
    FQXClearCommentSurface(emoji, styled);
    FQXClearCommentSurface(aigc, styled);

    UIVisualEffectView *keepGlass = objc_getAssociatedObject(toolbar, DramaComposerGlassKey);
    UIVisualEffectView *official = FQXObjGet(toolbar, "effectView");
    if ([official isKindOfClass:UIVisualEffectView.class] && official != keepGlass) {
        FQXNeutralizeHostEffectView(official, styled);
    }
    FQXNeutralizeStrayBarGlass(toolbar, keepGlass, styled, 0);
    FQXAudioSetHiddenTracked(FQXObjGet(toolbar, "topLineView"), styled);
    UIUserInterfaceStyle desiredUIStyle = FQXDesiredCommentHostOverrideStyle();
    if (toolbar.overrideUserInterfaceStyle != desiredUIStyle)
        toolbar.overrideUserInterfaceStyle = desiredUIStyle;
    if (styled) {
        FQXBoostCommentTypography(toolbar, 0);
    }
    FQXExtendSiblingScrollForCommentBar(toolbar, styled);
    FQXResyncVisibleCommentSheetYields(toolbar.window);
}

static void (*OrigBaseCommentBarLayout)(id, SEL);
static void HookBaseCommentBarLayout(UIView *toolbar, SEL cmd) {
    OrigBaseCommentBarLayout(toolbar, cmd);
    if ([toolbar isMemberOfClass:NSClassFromString(@"FQCCommentBottomToolBar")]) {
        FQXStyleCommentBar(toolbar);
    }
}

static void (*OrigDramaCommentBarLayout)(id, SEL);
static void HookDramaCommentBarLayout(UIView *toolbar, SEL cmd) {
    OrigDramaCommentBarLayout(toolbar, cmd);
    FQXStyleCommentBar(toolbar);
}

static void (*OrigBottomBarPluginDidLayoutEnd)(id, SEL);
static void HookBottomBarPluginDidLayoutEnd(id plugin, SEL cmd) {
    OrigBottomBarPluginDidLayoutEnd(plugin, cmd);
    UIView *bar = FQXRawIvarObj(plugin, "_bottomToolBar");
    if (bar) FQXStyleCommentBar(bar);
}

static void (*OrigDramaCommentBarTheme)(id, SEL, BOOL);
static void HookDramaCommentBarTheme(UIView *toolbar, SEL cmd, BOOL darkMode) {
    OrigDramaCommentBarTheme(toolbar, cmd, FQXShouldOverrideCommentTheme() ? FQXCommentsUseDarkTheme() : darkMode);
    if (toolbar.window) FQXStyleCommentBar(toolbar);
}

static void (*OrigReaderCommentBarTheme)(id, SEL, BOOL);
static void HookReaderCommentBarTheme(UIView *toolbar, SEL cmd, BOOL darkMode) {
    OrigReaderCommentBarTheme(toolbar, cmd, FQXShouldOverrideCommentTheme() ? FQXCommentsUseDarkTheme() : darkMode);
    if (toolbar.window) FQXStyleCommentBar(toolbar);
}

static void FQXRemoveGlassSheet(UIView *sheet) {
    UIVisualEffectView *glass = objc_getAssociatedObject(sheet, SheetGlassKey);
    if (glass) {
        FQXReleaseCommentSurface(glass);
        objc_setAssociatedObject(sheet, SheetGlassKey, nil, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
    }
    FQXRestoreSheetTopCornerMask(sheet);
    FQXAudioClearBackground(sheet, NO);
}

static void FQXFindTabBarsInView(UIView *view, Class tabBarCls, NSMutableArray<UIView *> *out, NSInteger depth) {
    if (!view || depth > 8) return;
    if (tabBarCls && [view isKindOfClass:tabBarCls]) {
        [out addObject:view];
        return;
    }
    for (UIView *sub in view.subviews) {
        FQXFindTabBarsInView(sub, tabBarCls, out, depth + 1);
    }
}

static BOOL FQXHasVisibleCommentSheetInWindow(UIWindow *window, UIViewController *excludingVC) {
    if (!window) return NO;
    NSArray<NSHashTable<UIViewController *> *> *tables = @[
        FQXTrackedCommentPanels(),
        FQXTrackedCommentLists(),
        FQXTrackedSeriesCommentLists(),
        FQXTrackedReaderCommentLists(),
    ];
    for (NSHashTable<UIViewController *> *tbl in tables) {
        for (UIViewController *vc in [tbl allObjects]) {
            if (vc == excludingVC || !vc.isViewLoaded) continue;
            UIView *v = vc.viewIfLoaded;
            if (!v || v.window != window || v.hidden || v.alpha < 0.05) continue;
            if (CGRectGetWidth(v.bounds) < 100.0 || CGRectGetHeight(v.bounds) < 100.0) continue;
            BOOL ancestorHidden = NO;
            for (UIView *p = v.superview; p && p != window; p = p.superview) {
                if (p.hidden || p.alpha < 0.05) { ancestorHidden = YES; break; }
            }
            if (!ancestorHidden) return YES;
        }
    }
    return NO;
}

static NSHashTable<UIView *> *FQXTrackedCommentDimmers(void);
static void FQXSetCommentDimmerZeroMask(UIView *view, BOOL masked);
static void FQXClearCommentSurface(UIView *view, BOOL clear);

static void FQXSyncDockHiddenForCommentSheets(UIWindow *window, UIViewController *excludingVC) {
    if (!window) return;
    BOOL hasVisibleSheet = FQXHasVisibleCommentSheetInWindow(window, excludingVC);
    BOOL shouldHideDock = FQXCommentStylingEnabled() && hasVisibleSheet;
    if (!shouldHideDock) {
        for (UIView *dimmer in FQXTrackedCommentDimmers().allObjects) {
            if (!dimmer.window || dimmer.window == window) {
                FQXSetCommentDimmerZeroMask(dimmer, NO);
                FQXClearCommentSurface(dimmer, NO);
            }
        }
    }
    Class tabBarCls = NSClassFromString(@"SSTabBar");
    if (!tabBarCls) return;
    NSMutableArray<UIView *> *bars = [NSMutableArray array];
    FQXFindTabBarsInView(window, tabBarCls, bars, 0);
    for (UIView *bar in bars) {
        BOOL hiddenByUs = [objc_getAssociatedObject(bar, FQXDockHiddenByCommentKey) boolValue];
        if (shouldHideDock && !hiddenByUs) {
            objc_setAssociatedObject(bar, FQXDockHiddenByCommentKey, @YES, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
            bar.userInteractionEnabled = NO;
            // Keep alpha strictly > 0.0 (0.002 rounds to 0/255 visually) so Lvisible_to() in
            // native_surface.s / feed_viewport.s NEVER triggers LXrestore/FQHBottomReset178.
            [UIView animateWithDuration:0.16 delay:0.0
                                options:UIViewAnimationOptionBeginFromCurrentState | UIViewAnimationOptionAllowUserInteraction
                             animations:^{ bar.alpha = 0.002; } completion:nil];
        } else if (!shouldHideDock && hiddenByUs) {
            objc_setAssociatedObject(bar, FQXDockHiddenByCommentKey, nil, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
            bar.userInteractionEnabled = YES;
            [UIView animateWithDuration:0.20 delay:0.0
                                options:UIViewAnimationOptionBeginFromCurrentState | UIViewAnimationOptionAllowUserInteraction
                             animations:^{ bar.alpha = 1.0; } completion:nil];
        }
    }
}

static CGFloat FQXReadHostSheetCornerRadius(UIView *sheet, UIView *root) {
    if (![sheet isKindOfClass:UIView.class]) return 14.0;
    CGFloat hostR = sheet.layer.cornerRadius;
    if (hostR <= 0.5 && root && root != sheet) {
        hostR = root.layer.cornerRadius;
    }
    if (hostR >= 8.0 && hostR <= 20.0) return hostR;
    if (hostR > 20.0) return 16.0;
    return 14.0;
}

static BOOL FQXStyleGlassSheetWithRoot(UIView *sheet, UIView *root, BOOL commentSheet, BOOL readerSheet) {
    (void)readerSheet;
    if (!sheet) return NO;
    CGFloat commentRadius = commentSheet ? FQXReadHostSheetCornerRadius(sheet, root) : 22.0;
    BOOL enabled = (commentSheet ? FQXCommentStylingEnabled() : FQXGlassEnabled()) &&
                   CGRectGetWidth(sheet.bounds) > 100.0 &&
                   CGRectGetHeight(sheet.bounds) > 72.0;
    if (commentSheet) {
        [FQXTrackedCommentSheetHosts() addObject:sheet];
    }
    UIVisualEffectView *glass = nil;
    FQXCommentMaterialStyle matStyle = FQXCurrentCommentMaterialStyle();
    if (enabled) {
        if (commentSheet) {
            glass = FQXEnsureCommentSurface(sheet, SheetGlassKey, matStyle);
        } else {
            glass = objc_getAssociatedObject(sheet, SheetGlassKey);
            if (!glass) {
                UIColor *theme = sheet.backgroundColor;
                if (!theme || CGColorGetAlpha(theme.CGColor) < 0.01) theme = UIColor.systemBackgroundColor;
                glass = FQXNewGlassViewFull(0, NO, 22.0, YES, [theme colorWithAlphaComponent:0.76]);
                objc_setAssociatedObject(sheet, SheetGlassKey, glass, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
            }
        }
    }
    if (!enabled || !glass) {
        FQXRemoveGlassSheet(sheet);
        if (commentSheet) {
            UIUserInterfaceStyle desiredUIStyle = FQXDesiredCommentHostOverrideStyle();
            if (sheet.overrideUserInterfaceStyle != desiredUIStyle) {
                sheet.overrideUserInterfaceStyle = desiredUIStyle;
            }
        }
        return NO;
    }
    if (!commentSheet) {
        [UIView performWithoutAnimation:^{
            if (!CGRectEqualToRect(glass.frame, sheet.bounds)) glass.frame = sheet.bounds;
            if (sheet.subviews.firstObject != glass) [sheet insertSubview:glass atIndex:0];
            FQXAudioClearBackground(sheet, YES);
        }];
        return YES;
    }

    [CATransaction begin];
    [CATransaction setDisableActions:YES];
    FQXApplySheetYieldGeometry(sheet, glass);
    FQXRestoreSheetTopCornerMask(sheet);
    UIUserInterfaceStyle desiredUIStyle = FQXDesiredCommentHostOverrideStyle();
    if (sheet.overrideUserInterfaceStyle != desiredUIStyle) {
        sheet.overrideUserInterfaceStyle = desiredUIStyle;
    }
    if ([glass isKindOfClass:FQXCommentGlassSurfaceView.class]) {
        FQXCommentGlassSurfaceView *gs = (FQXCommentGlassSurfaceView *)glass;
        gs.flexSourceView = sheet;
        gs.isBarGlass = NO;
    }
    if (sheet.subviews.firstObject != glass) [sheet insertSubview:glass atIndex:0];
    FQXApplyCommentCornerConfig(glass, FQXCommentCornerTopSheet, commentRadius);
    FQXClearCommentSurface(sheet, YES);
    [CATransaction commit];

    FQXSyncCommentSurface(glass, FQXFindOwningViewController(sheet), matStyle,
                          FQXCommentCornerTopSheet, commentRadius, YES);
    return YES;
}

static BOOL FQXStyleGlassSheet(UIView *sheet, BOOL commentSheet, BOOL readerSheet) {
    return FQXStyleGlassSheetWithRoot(sheet, nil, commentSheet, readerSheet);
}

static const void *CommentSavedOpaqueKey = &CommentSavedOpaqueKey;

static void FQXClearCommentSurface(UIView *view, BOOL clear) {
    if (![view isKindOfClass:UIView.class]) return;
    if ([view isKindOfClass:FQXCommentGlassSurfaceView.class] ||
        [view isKindOfClass:FQXBackdropBlurView.class]) return;
    if (clear) [FQXTrackedCommentCleanedViews() addObject:view];
    FQXAudioClearBackground(view, clear);
    if (clear) {
        if (view.layer.backgroundColor &&
            CGColorGetAlpha(view.layer.backgroundColor) > 0.001) {
            if (!objc_getAssociatedObject(view, FQXCommentSavedLayerBgKey)) {
                UIColor *savedColor = [UIColor colorWithCGColor:view.layer.backgroundColor];
                if (savedColor) {
                    objc_setAssociatedObject(view, FQXCommentSavedLayerBgKey, savedColor, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
                }
            }
            view.layer.backgroundColor = NULL;
        }
        FQXHideLayerGradients(view.layer, YES);
        if (view.opaque) {
            objc_setAssociatedObject(view, CommentSavedOpaqueKey, @YES, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
            view.opaque = NO;
        }
    } else {
        UIColor *savedLayerBg = objc_getAssociatedObject(view, FQXCommentSavedLayerBgKey);
        if ([savedLayerBg isKindOfClass:UIColor.class]) {
            view.layer.backgroundColor = savedLayerBg.CGColor;
            objc_setAssociatedObject(view, FQXCommentSavedLayerBgKey, nil, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
        }
        FQXHideLayerGradients(view.layer, NO);
        if (objc_getAssociatedObject(view, CommentSavedOpaqueKey)) {
            view.opaque = YES;
            objc_setAssociatedObject(view, CommentSavedOpaqueKey, nil, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
        }
    }
}

static void FQXSetScrollEdgeEffectHidden(UIScrollView *sv, SEL getterSel, BOOL suppress) {
    if (!sv || ![sv respondsToSelector:getterSel]) return;
    id edge = ((id (*)(id, SEL))objc_msgSend)(sv, getterSel);
    if (!edge) return;
    SEL hiddenSel = @selector(isHidden);
    SEL setHiddenSel = @selector(setHidden:);
    if (![edge respondsToSelector:hiddenSel] || ![edge respondsToSelector:setHiddenSel]) return;
    NSNumber *saved = objc_getAssociatedObject(edge, FQXCommentSavedEdgeHiddenKey);
    if (suppress) {
        if (!saved) {
            BOOL orig = ((BOOL (*)(id, SEL))objc_msgSend)(edge, hiddenSel);
            objc_setAssociatedObject(edge, FQXCommentSavedEdgeHiddenKey, @(orig), OBJC_ASSOCIATION_RETAIN_NONATOMIC);
        }
        if (!((BOOL (*)(id, SEL))objc_msgSend)(edge, hiddenSel)) {
            ((void (*)(id, SEL, BOOL))objc_msgSend)(edge, setHiddenSel, YES);
        }
    } else if (saved) {
        ((void (*)(id, SEL, BOOL))objc_msgSend)(edge, setHiddenSel, saved.boolValue);
        objc_setAssociatedObject(edge, FQXCommentSavedEdgeHiddenKey, nil, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
    }
}

static void FQXSuppressCommentScrollEdgeEffects(UIScrollView *scrollView, BOOL suppress) {
    if (![scrollView isKindOfClass:UIScrollView.class]) return;
    if (suppress) [FQXTrackedSuppressedScrollEdges() addObject:scrollView];
    FQXSetScrollEdgeEffectHidden(scrollView, NSSelectorFromString(@"topEdgeEffect"), suppress);
    FQXSetScrollEdgeEffectHidden(scrollView, NSSelectorFromString(@"bottomEdgeEffect"), suppress);
    for (UIView *sub in scrollView.subviews) {
        NSString *clsName = NSStringFromClass(sub.class);
        if (clsName && [clsName containsString:@"ScrollEdgeEffect"]) {
            if (suppress) [FQXTrackedSuppressedScrollEdges() addObject:sub];
            FQXAudioSetHiddenTracked(sub, suppress);
        }
    }
}

static void FQXClearCommentCell(UIView *cell, BOOL clear) {
    if (![cell isKindOfClass:UIView.class]) return;
    FQXClearCommentSurface(cell, clear);
    if ([cell isKindOfClass:UICollectionViewCell.class]) {
        UICollectionViewCell *cvCell = (UICollectionViewCell *)cell;
        FQXClearCommentSurface(cvCell.contentView, clear);
        FQXClearCommentSurface(cvCell.backgroundView, clear);
        FQXClearCommentSurface(cvCell.selectedBackgroundView, clear);
        CGFloat cellW = CGRectGetWidth(cvCell.bounds);
        if (cellW > 60.0) {
            for (UIView *sub in cvCell.contentView.subviews) {
                if ([sub isMemberOfClass:UIView.class] &&
                    CGRectGetWidth(sub.bounds) >= cellW * 0.85 &&
                    CGRectGetHeight(sub.bounds) >= 16.0) {
                    FQXClearCommentSurface(sub, clear);
                }
            }
        }
    }
    UIView *cellBg = FQXRawIvarObj(cell, "_bgView");
    if (cellBg) FQXClearCommentSurface(cellBg, clear);
    UIView *tipLabel = FQXRawIvarObj(cell, "_tipLabel");
    if (tipLabel) FQXClearCommentSurface(tipLabel, clear);
    if (clear) {
        UIUserInterfaceStyle desiredUIStyle = FQXDesiredCommentHostOverrideStyle();
        if (cell.overrideUserInterfaceStyle != desiredUIStyle)
            cell.overrideUserInterfaceStyle = desiredUIStyle;
        FQXBoostCommentTypography(cell, 0);
    }
}

static void FQXClearReplyFooter(UIView *footer, BOOL clear) {
    FQXClearCommentSurface(footer, clear);
    FQXClearCommentSurface(FQXObjGet(footer, "expandView"), clear);
    if ([footer isKindOfClass:UICollectionReusableView.class]) {
        for (UIView *view in footer.subviews) {
            if ([view isMemberOfClass:UIView.class] && CGRectGetWidth(view.bounds) >= CGRectGetWidth(footer.bounds) * 0.9)
                FQXClearCommentSurface(view, clear);
        }
    }
    if (clear) {
        UIUserInterfaceStyle desiredUIStyle = FQXDesiredCommentHostOverrideStyle();
        if (footer.overrideUserInterfaceStyle != desiredUIStyle)
            footer.overrideUserInterfaceStyle = desiredUIStyle;
        FQXBoostCommentTypography(footer, 0);
    }
}

static void FQXClearCommentCollection(UIView *view, BOOL clear) {
    FQXClearCommentSurface(view, clear);
    if (![view isKindOfClass:UIScrollView.class]) return;
    FQXSuppressCommentScrollEdgeEffects((UIScrollView *)view, clear);
    if (![view isKindOfClass:UICollectionView.class]) return;
    UICollectionView *collection = (UICollectionView *)view;
    FQXClearCommentSurface(collection.backgroundView, clear);
    Class playFooter = NSClassFromString(@"FQCShortPlayReplySectionFooterView");
    Class videoFooter = NSClassFromString(@"FQCShortVideoCommentSectionFooterView");
    Class paraFooter = NSClassFromString(@"FQCParagraphCommentV1SectionFooterView");
    for (UIView *sub in collection.subviews) {
        if ((playFooter && [sub isKindOfClass:playFooter]) ||
            (videoFooter && [sub isKindOfClass:videoFooter]) ||
            (paraFooter && [sub isKindOfClass:paraFooter])) {
            FQXClearReplyFooter(sub, clear);
        }
    }
    for (UICollectionViewCell *cell in collection.visibleCells) {
        FQXClearCommentCell(cell, clear);
    }
}

static void FQXClearCommentCoversDepth(UIView *view, CGFloat width, BOOL clear, NSInteger depth) {
    if (![view isKindOfClass:UIView.class] || depth > 12) return;
    if ([view isKindOfClass:FQXCommentGlassSurfaceView.class] ||
        [view isKindOfClass:FQXBackdropBlurView.class]) return;
    Class toolbarClass = NSClassFromString(@"FQCCommentBottomToolBar");
    Class gradBtnClass = NSClassFromString(@"FQCommunityGradientButton");
    for (UIView *child in view.subviews) {
        if ([child isKindOfClass:FQXCommentGlassSurfaceView.class] ||
            [child isKindOfClass:FQXBackdropBlurView.class]) continue;
        NSString *clsName = NSStringFromClass(child.class);
        if (clsName && [clsName containsString:@"ScrollEdgeEffect"]) {
            if (clear) [FQXTrackedSuppressedScrollEdges() addObject:child];
            FQXAudioSetHiddenTracked(child, clear);
            continue;
        }
        if ([child isKindOfClass:UIVisualEffectView.class]) {
            FQXNeutralizeHostEffectView((UIVisualEffectView *)child, clear);
            continue;
        }
        if ((toolbarClass && [child isKindOfClass:toolbarClass]) ||
            (gradBtnClass && [child isKindOfClass:gradBtnClass]) ||
            [child isKindOfClass:UICollectionReusableView.class] || [child isKindOfClass:UIControl.class] ||
            [child isKindOfClass:UIImageView.class] || [child isKindOfClass:UILabel.class] ||
            [child isKindOfClass:UITextView.class]) continue;
        if ([child isKindOfClass:UICollectionView.class] || [child isKindOfClass:UITableView.class]) {
            FQXClearCommentCollection(child, clear);
            continue;
        }
        if ([child isKindOfClass:UIScrollView.class]) {
            FQXClearCommentSurface(child, clear);
            FQXSuppressCommentScrollEdgeEffects((UIScrollView *)child, clear);
            FQXClearCommentCoversDepth(child, width, clear, depth + 1);
            continue;
        }
        CGFloat cw = CGRectGetWidth(child.bounds);
        CGFloat ch = CGRectGetHeight(child.bounds);
        if (cw < width * 0.82) continue;
        if (ch >= 8.0) {
            FQXClearCommentSurface(child, clear);
        }
        if (ch >= 8.0 || !child.clipsToBounds) {
            FQXClearCommentCoversDepth(child, width, clear, depth + 1);
        }
    }
}

static void FQXClearCommentCovers(UIView *view, CGFloat width, BOOL clear) {
    FQXClearCommentCoversDepth(view, width, clear, 0);
}

static const void *FQXCommentTransitionSheetKey = &FQXCommentTransitionSheetKey;
static const void *FQXCommentDimmerMaskKey = &FQXCommentDimmerMaskKey;
static const void *FQXCommentDimmerSavedMaskKey = &FQXCommentDimmerSavedMaskKey;
static const void *FQXCommentBackdropDiagStampKey = &FQXCommentBackdropDiagStampKey;

static NSHashTable<UIView *> *FQXTrackedCommentDimmers(void) {
    static NSHashTable<UIView *> *table;
    static dispatch_once_t once;
    dispatch_once(&once, ^{ table = [NSHashTable weakObjectsHashTable]; });
    return table;
}

// Visually mask a modal dimming scrim without changing hidden/alpha/userInteractionEnabled,
// so tap-to-dismiss gestures stay intact while host alpha/color animations cannot re-darken
// the reading page behind Light-mode Clear Liquid Glass.
static void FQXSetCommentDimmerZeroMask(UIView *view, BOOL masked) {
    if (![view isKindOfClass:UIView.class]) return;
    CALayer *ownedMask = objc_getAssociatedObject(view, FQXCommentDimmerMaskKey);
    if (masked) {
        [FQXTrackedCommentDimmers() addObject:view];
        if (!ownedMask) {
            if (view.layer.mask) {
                objc_setAssociatedObject(view, FQXCommentDimmerSavedMaskKey, view.layer.mask, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
            }
            ownedMask = [CALayer layer];
            ownedMask.frame = CGRectZero;
            objc_setAssociatedObject(view, FQXCommentDimmerMaskKey, ownedMask, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
        }
        if (view.layer.mask != ownedMask) {
            view.layer.mask = ownedMask;
        }
    } else if (ownedMask) {
        if (view.layer.mask == ownedMask) {
            CALayer *saved = objc_getAssociatedObject(view, FQXCommentDimmerSavedMaskKey);
            view.layer.mask = saved;
        }
        objc_setAssociatedObject(view, FQXCommentDimmerMaskKey, nil, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
        objc_setAssociatedObject(view, FQXCommentDimmerSavedMaskKey, nil, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
    }
}

static BOOL FQXColorIsDarkDimmingScrim(UIColor *color, UITraitCollection *traits, CGFloat viewAlpha) {
    if (!color) return NO;
    UIColor *resolved = traits ? [color resolvedColorWithTraitCollection:traits] : color;
    CGFloat r = 0.0, g = 0.0, b = 0.0, a = 0.0;
    if (!FQXColorGetRGBA(resolved, &r, &g, &b, &a)) return NO;
    CGFloat effAlpha = a * MAX(0.0, MIN(1.0, viewAlpha));
    CGFloat lum = 0.299 * r + 0.587 * g + 0.114 * b;
    return (effAlpha >= 0.04 && effAlpha <= 0.92 && lum <= 0.28);
}

static BOOL FQXViewHasDarkDimmingFill(UIView *view) {
    if (!view) return NO;
    UITraitCollection *traits = view.traitCollection;
    CGFloat vAlpha = view.alpha;
    if (FQXColorIsDarkDimmingScrim(view.backgroundColor, traits, vAlpha)) return YES;
    if (view.layer.backgroundColor) {
        UIColor *lCol = [UIColor colorWithCGColor:view.layer.backgroundColor];
        if (FQXColorIsDarkDimmingScrim(lCol, traits, vAlpha)) return YES;
    }
    CGFloat vw = CGRectGetWidth(view.bounds);
    CGFloat vh = CGRectGetHeight(view.bounds);
    for (CALayer *sub in view.layer.sublayers) {
        if (sub.hidden || sub.opacity < 0.04f) continue;
        if (CGRectGetWidth(sub.bounds) < vw * 0.70 || CGRectGetHeight(sub.bounds) < vh * 0.40) continue;
        if (sub.backgroundColor) {
            UIColor *sCol = [UIColor colorWithCGColor:sub.backgroundColor];
            if (FQXColorIsDarkDimmingScrim(sCol, traits, vAlpha * sub.opacity)) return YES;
        }
        if ([sub isKindOfClass:CAGradientLayer.class]) {
            CAGradientLayer *gl = (CAGradientLayer *)sub;
            for (id cgObj in gl.colors) {
                UIColor *gCol = [UIColor colorWithCGColor:(__bridge CGColorRef)cgObj];
                if (FQXColorIsDarkDimmingScrim(gCol, traits, vAlpha * sub.opacity)) return YES;
            }
        }
    }
    return NO;
}

static BOOL FQXSubtreeHasVisibleContent(UIView *view, NSInteger depth) {
    if (!view || depth > 4 || view.hidden || view.alpha < 0.01) return NO;
    if ([view isKindOfClass:UIScrollView.class] ||
        [view isKindOfClass:UITextView.class] ||
        [view isKindOfClass:UICollectionView.class] ||
        [view isKindOfClass:UITableView.class]) {
        return YES;
    }
    NSString *clsName = NSStringFromClass(view.class);
    if (clsName && [clsName containsString:@"WebView"]) return YES;
    if ([view isKindOfClass:UILabel.class]) {
        UILabel *lbl = (UILabel *)view;
        if (lbl.text.length > 0 || lbl.attributedText.length > 0) return YES;
    } else if ([view isKindOfClass:UIImageView.class]) {
        if (((UIImageView *)view).image != nil) return YES;
    } else if ([view isKindOfClass:UIButton.class]) {
        UIButton *btn = (UIButton *)view;
        if (btn.currentTitle.length > 0 || btn.currentImage != nil || btn.currentAttributedTitle.length > 0) return YES;
    }
    for (UIView *sub in view.subviews) {
        if (FQXSubtreeHasVisibleContent(sub, depth + 1)) return YES;
    }
    return NO;
}

static BOOL FQXClassNameLooksLikeDimmer(NSString *clsName) {
    if (!clsName.length) return NO;
    NSArray<NSString *> *tokens = @[@"Dim", @"Mask", @"Overlay", @"Backdrop", @"Scrim", @"Shadow", @"Cover"];
    for (NSString *tok in tokens) {
        if ([clsName rangeOfString:tok options:NSCaseInsensitiveSearch].location != NSNotFound) return YES;
    }
    return NO;
}

static BOOL FQXViewLooksLikePureDimmingScrim(UIView *view, CGSize winSize) {
    if (![view isKindOfClass:UIView.class]) return NO;
    if ([view isKindOfClass:FQXCommentGlassSurfaceView.class] ||
        [view isKindOfClass:FQXBackdropBlurView.class]) return NO;
    // Never suppress any view controller's own root view (e.g., BDReaderViewController or SSTabBarController).
    if ([view.nextResponder isKindOfClass:UIViewController.class]) return NO;
    if (objc_getAssociatedObject(view, FQXCommentDimmerMaskKey) != nil) return YES;
    if (winSize.width < 100.0 || winSize.height < 100.0) return NO;
    if (CGRectGetWidth(view.bounds) < winSize.width * 0.72 ||
        CGRectGetHeight(view.bounds) < winSize.height * 0.40) return NO;
    if (FQXSubtreeHasVisibleContent(view, 0)) return NO;
    if ([view isKindOfClass:UIVisualEffectView.class]) return YES;
    if (FQXViewHasDarkDimmingFill(view)) return YES;
    NSString *clsName = NSStringFromClass(view.class);
    if (FQXClassNameLooksLikeDimmer(clsName) && (view.backgroundColor != nil || view.layer.backgroundColor != NULL || view.alpha < 0.98)) {
        return YES;
    }
    return NO;
}

static void FQXPurgeNestedSheetGlassDepth(UIView *view, UIView *activeSheet, NSInteger depth) {
    if (![view isKindOfClass:UIView.class] || depth > 8) return;
    if (view != activeSheet && objc_getAssociatedObject(view, SheetGlassKey)) {
        FQXRemoveGlassSheet(view);
    }
    for (UIView *sub in [view.subviews copy]) {
        FQXPurgeNestedSheetGlassDepth(sub, activeSheet, depth + 1);
    }
}

static void FQXCleanTransitionBackdrop(UIView *transition, UIView *sheet, BOOL glass, NSMutableArray<NSString *> *clearedOut) {
    if (![transition isKindOfClass:UIView.class]) return;
    FQXClearCommentSurface(transition, glass);
    NSArray<NSString *> *keys = @[
        @"bgView", @"backgroundView", @"dimView", @"dimmingView",
        @"coverView", @"overlayView", @"backdropView", @"maskBgView",
        @"maskView", @"blackMaskView", @"bgMaskView", @"tapView",
        @"shadowView", @"alphaView", @"contentBgView"
    ];
    for (NSString *key in keys) {
        UIView *v = FQXObjGet(transition, key.UTF8String);
        if ([v isKindOfClass:UIView.class] && v != sheet && ![sheet isDescendantOfView:v] &&
            ![v.nextResponder isKindOfClass:UIViewController.class]) {
            FQXClearCommentSurface(v, glass);
            FQXSetCommentDimmerZeroMask(v, glass);
            if (glass && clearedOut) [clearedOut addObject:[NSString stringWithFormat:@"ivar:%@(%@)", key, NSStringFromClass(v.class) ?: @""]];
        }
    }
    UIView *tEffect = FQXObjGet(transition, "effectView");
    if ([tEffect isKindOfClass:UIVisualEffectView.class]) {
        FQXNeutralizeHostEffectView((UIVisualEffectView *)tEffect, glass);
    }
    UIView *carrier = FQXObjGet(transition, "contentScrollView");
    if (carrier && [sheet isDescendantOfView:carrier]) FQXClearCommentSurface(carrier, glass);
    UIView *scrollCarrier = FQXObjGet(transition, "scrollView");
    if (scrollCarrier && [sheet isDescendantOfView:scrollCarrier]) FQXClearCommentSurface(scrollCarrier, glass);

    CGSize winSize = transition.window ? transition.window.bounds.size : transition.bounds.size;
    CGFloat transW = CGRectGetWidth(transition.bounds);
    for (UIView *sub in transition.subviews) {
        if (sub == sheet || [sheet isDescendantOfView:sub] || [sub isDescendantOfView:sheet]) continue;
        if ([sub isKindOfClass:UIVisualEffectView.class]) {
            FQXNeutralizeHostEffectView((UIVisualEffectView *)sub, glass);
            if (glass && clearedOut) [clearedOut addObject:[NSString stringWithFormat:@"transEffect:%@", NSStringFromClass(sub.class) ?: @""]];
            continue;
        }
        BOOL isDimmerButton = [sub isKindOfClass:UIButton.class] &&
                              ![(UIButton *)sub currentTitle].length &&
                              ![(UIButton *)sub currentImage];
        BOOL legacyMatch = ([sub isMemberOfClass:UIView.class] || [sub isMemberOfClass:UIControl.class] || isDimmerButton) &&
                           transW > 40.0 &&
                           CGRectGetWidth(sub.bounds) >= transW * 0.80 &&
                           CGRectIntersectsRect(sub.frame, sheet.frame);
        if (legacyMatch || FQXViewLooksLikePureDimmingScrim(sub, winSize)) {
            FQXClearCommentSurface(sub, glass);
            FQXSetCommentDimmerZeroMask(sub, glass);
            if (glass && clearedOut) [clearedOut addObject:[NSString stringWithFormat:@"transSub:%@", NSStringFromClass(sub.class) ?: @""]];
        }
    }
}

static void FQXCleanCommentPresentationBackdrops(UIView *sheet, UIView *transition, BOOL glass) {
    if (![sheet isKindOfClass:UIView.class]) return;
    NSMutableArray<NSString *> *cleared = glass ? [NSMutableArray array] : nil;
    if (transition) {
        FQXCleanTransitionBackdrop(transition, sheet, glass, cleared);
    }

    UIWindow *win = sheet.window;
    CGSize winSize = win ? win.bounds.size : CGSizeZero;
    UIView *branchChild = sheet;
    UIView *anc = sheet.superview;
    for (NSInteger level = 0; anc && level < 7; ++level) {
        if (anc != win && anc != transition) {
            // Clear a modal wrapper's own dark dimming backgroundColor without masking the
            // wrapper itself (since sheet is inside it).
            if (![anc.nextResponder isKindOfClass:UIViewController.class] &&
                (FQXViewHasDarkDimmingFill(anc) || objc_getAssociatedObject(anc, AudioSavedBgKey) != nil)) {
                FQXClearCommentSurface(anc, glass);
                if (glass && cleared) [cleared addObject:[NSString stringWithFormat:@"ancBg:%@", NSStringFromClass(anc.class) ?: @""]];
            }
        }
        NSArray<UIView *> *siblings = anc.subviews;
        NSUInteger branchIdx = [siblings indexOfObjectIdenticalTo:branchChild];
        if (branchIdx != NSNotFound) {
            // Only inspect siblings stacked BEHIND the comment sheet branch so nothing presented
            // above the sheet (keyboards, toasts, alerts) is ever touched.
            for (NSUInteger i = 0; i < branchIdx; ++i) {
                UIView *sib = siblings[i];
                if (sib == sheet || [sheet isDescendantOfView:sib] || [sib isDescendantOfView:sheet]) continue;
                if ([sib.nextResponder isKindOfClass:UIViewController.class]) continue;
                if (FQXViewLooksLikePureDimmingScrim(sib, winSize)) {
                    if ([sib isKindOfClass:UIVisualEffectView.class]) {
                        FQXNeutralizeHostEffectView((UIVisualEffectView *)sib, glass);
                    } else {
                        FQXClearCommentSurface(sib, glass);
                        FQXSetCommentDimmerZeroMask(sib, glass);
                    }
                    if (glass && cleared) [cleared addObject:[NSString stringWithFormat:@"sibL%ld:%@", (long)level, NSStringFromClass(sib.class) ?: @""]];
                    continue;
                }
                // Check 1 level inside non-VC overlay container wrappers (e.g., UITransitionView / custom backdrop host).
                if (CGRectGetWidth(sib.bounds) >= winSize.width * 0.72 &&
                    CGRectGetHeight(sib.bounds) >= winSize.height * 0.40 &&
                    !FQXSubtreeHasVisibleContent(sib, 0)) {
                    for (UIView *inner in sib.subviews) {
                        if (FQXViewLooksLikePureDimmingScrim(inner, winSize)) {
                            if ([inner isKindOfClass:UIVisualEffectView.class]) {
                                FQXNeutralizeHostEffectView((UIVisualEffectView *)inner, glass);
                            } else {
                                FQXClearCommentSurface(inner, glass);
                                FQXSetCommentDimmerZeroMask(inner, glass);
                            }
                            if (glass && cleared) [cleared addObject:[NSString stringWithFormat:@"sibInnerL%ld:%@", (long)level, NSStringFromClass(inner.class) ?: @""]];
                        }
                    }
                }
            }
        }
        if (anc == win) break;
        branchChild = anc;
        anc = anc.superview;
    }

    if (glass && cleared.count > 0) {
        NSString *sig = [NSString stringWithFormat:@"%lu|%@", (unsigned long)cleared.count, [cleared componentsJoinedByString:@","]];
        NSString *prev = objc_getAssociatedObject(sheet, FQXCommentBackdropDiagStampKey);
        if (![prev isEqualToString:sig]) {
            objc_setAssociatedObject(sheet, FQXCommentBackdropDiagStampKey, sig, OBJC_ASSOCIATION_COPY_NONATOMIC);
            FQXDiagRecordEvent(FQXDiagCategoryUI, @"comment_backdrop_clean", @{
                @"sheetClass": NSStringFromClass(sheet.class) ?: @"",
                @"transitionClass": transition ? (NSStringFromClass(transition.class) ?: @"") : @"",
                @"darkTheme": @(FQXCommentsUseDarkTheme()),
                @"materialStyle": @((NSInteger)FQXCurrentCommentMaterialStyle()),
                @"clearedCount": @(cleared.count),
                @"cleared": cleared,
            }, NO);
        }
    }
}

static UIView *FQXFindSheetGlassOwnerDepth(UIView *view, NSInteger depth) {
    if (![view isKindOfClass:UIView.class] || depth > 5) return nil;
    if (objc_getAssociatedObject(view, SheetGlassKey)) return view;
    for (UIView *sub in view.subviews) {
        UIView *found = FQXFindSheetGlassOwnerDepth(sub, depth + 1);
        if (found) return found;
    }
    return nil;
}

static UIView *FQXTrackedSheetInTransition(UIView *transition) {
    NSHashTable<UIView *> *tracked = objc_getAssociatedObject(transition, FQXCommentTransitionSheetKey);
    UIView *sheet = tracked.anyObject;
    if (sheet && [sheet isDescendantOfView:transition]) return sheet;
    return FQXFindSheetGlassOwnerDepth(transition, 0);
}

static BOOL FQXStyleCommentSheet(UIView *root, BOOL reader) {
    if (!root.window) return NO;
    UIView *sheet = root;
    UIView *transition = nil;
    CGFloat rootW = CGRectGetWidth(root.bounds);
    CGFloat rootH = CGRectGetHeight(root.bounds);
    CGFloat winH = CGRectGetHeight(root.window.bounds);
    static Class transCls = Nil;
    static dispatch_once_t once;
    dispatch_once(&once, ^{ transCls = NSClassFromString(@"FQVTransitionView"); });
    for (UIView *view = root.superview; view && ![view isKindOfClass:UIWindow.class]; view = view.superview) {
        if (transCls && [view isKindOfClass:transCls]) {
            transition = view;
            UIView *content = FQXObjGet(view, "contentView");
            if (content && content != root && [root isDescendantOfView:content] &&
                (reader || fabs(CGRectGetHeight(content.bounds) - rootH) <= 12.0)) {
                sheet = content;
            }
            break;
        }
        CGFloat vh = CGRectGetHeight(view.bounds);
        CGFloat vw = CGRectGetWidth(view.bounds);
        if (vh < winH - 20.0 && vw >= rootW - 4.0 && vh >= rootH - 4.0 && vh <= rootH + 24.0) {
            sheet = view;
        }
    }
    if (sheet != root && objc_getAssociatedObject(root, SheetGlassKey)) FQXRemoveGlassSheet(root);
    for (UIView *anc = sheet.superview; anc && ![anc isKindOfClass:UIWindow.class]; anc = anc.superview) {
        if (objc_getAssociatedObject(anc, SheetGlassKey)) FQXRemoveGlassSheet(anc);
    }
    FQXPurgeNestedSheetGlassDepth(sheet, sheet, 0);
    BOOL glass = FQXStyleGlassSheetWithRoot(sheet, root, YES, reader);
    for (UIView *w = root; w && w != sheet.superview; w = w.superview) {
        FQXClearCommentSurface(w, glass);
    }
    if (transition) {
        NSHashTable<UIView *> *trackedSheets = objc_getAssociatedObject(transition, FQXCommentTransitionSheetKey);
        if (!trackedSheets) {
            trackedSheets = [NSHashTable weakObjectsHashTable];
            objc_setAssociatedObject(transition, FQXCommentTransitionSheetKey, trackedSheets, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
        }
        if (trackedSheets.anyObject != sheet) {
            [trackedSheets removeAllObjects];
            [trackedSheets addObject:sheet];
        }
    }
    FQXCleanCommentPresentationBackdrops(sheet, transition, glass);
    FQXClearCommentCovers(sheet, rootW, glass);
    if (glass) FQXBoostCommentTypography(sheet, 0);
    FQXSyncDockHiddenForCommentSheets(root.window, nil);
    return glass;
}

static void FQXStyleSeriesCommentList(UIViewController *controller);
static void FQXStyleCommentSearchEntrance(UIView *entrance);
static BOOL FQXStyleDramaCommentList(UIViewController *controller);
static void FQXStyleReaderCommentList(UIViewController *controller);
static void FQXScanAndStyleCommentTopBanners(UIView *root);
static void FQXScheduleDelayedBannerScan(UIViewController *controller);

static void FQXStyleDramaPanel(UIViewController *controller) {
    if (!controller) return;
    [FQXTrackedCommentPanels() addObject:controller];
    BOOL glass = FQXStyleCommentSheet(controller.viewIfLoaded, NO);
    FQXClearCommentSurface(FQXObjGet(controller, "fqc_headerView"), glass);
    UIView *titles = FQXObjGet(controller, "categoryTitleView");
    UIView *lists = FQXObjGet(controller, "categeoryContainerView");
    FQXClearCommentSurface(titles, glass);
    FQXClearCommentCollection(FQXObjGet(titles, "collectionView"), glass);
    FQXClearCommentSurface(lists, glass);
    FQXClearCommentCollection(FQXObjGet(lists, "contentScrollView"), glass);
    UIViewController *videoVC = FQXRawIvarObj(controller, "_videoCommentVC");
    if ([videoVC isKindOfClass:UIViewController.class] && videoVC.isViewLoaded) {
        FQXStyleDramaCommentList(videoVC);
    }
    UIViewController *kmpVideoVC = FQXRawIvarObj(controller, "_kmpVideoCommentVC");
    if ([kmpVideoVC isKindOfClass:UIViewController.class] && kmpVideoVC.isViewLoaded) {
        FQXStyleDramaCommentList(kmpVideoVC);
    }
    UIViewController *seriesVC = FQXRawIvarObj(controller, "_seriesCommentVC");
    if ([seriesVC isKindOfClass:UIViewController.class] && seriesVC.isViewLoaded) {
        FQXStyleSeriesCommentList(seriesVC);
    }
    if (controller.isViewLoaded && controller.view.window) {
        FQXScanAndStyleCommentTopBanners(controller.view);
    }
}

static void (*OrigDramaPanelLayout)(id, SEL);
static void HookDramaPanelLayout(UIViewController *controller, SEL cmd) {
    OrigDramaPanelLayout(controller, cmd);
    FQXStyleDramaPanel(controller);
}

static void (*OrigDramaPanelAppeared)(id, SEL, BOOL);
static void HookDramaPanelAppeared(UIViewController *controller, SEL cmd, BOOL animated) {
    OrigDramaPanelAppeared(controller, cmd, animated);
    FQXStyleDramaPanel(controller);
    FQXScheduleDelayedBannerScan(controller);
}

static void (*OrigDramaPanelSetupTheme)(id, SEL);
static void HookDramaPanelSetupTheme(UIViewController *controller, SEL cmd) {
    OrigDramaPanelSetupTheme(controller, cmd);
    FQXStyleDramaPanel(controller);
}

static void (*OrigDramaPanelAdaptDark)(id, SEL);
static void HookDramaPanelAdaptDark(UIViewController *controller, SEL cmd) {
    OrigDramaPanelAdaptDark(controller, cmd);
    FQXStyleDramaPanel(controller);
}

static void (*OrigDramaPanelTraitChange)(id, SEL, id);
static void HookDramaPanelTraitChange(UIViewController *controller, SEL cmd, id previous) {
    OrigDramaPanelTraitChange(controller, cmd, previous);
    FQXStyleDramaPanel(controller);
}

static void (*OrigDramaPanelDarkChange)(id, SEL, BOOL);
static void HookDramaPanelDarkChange(UIViewController *controller, SEL cmd, BOOL dark) {
    OrigDramaPanelDarkChange(controller, cmd, FQXShouldOverrideCommentTheme() ? FQXCommentsUseDarkTheme() : dark);
    FQXStyleDramaPanel(controller);
}

static BOOL FQXCommentControllerIsEmbedded(UIViewController *controller, UIView *root) {
    static Class panelClass = Nil;
    static dispatch_once_t once;
    dispatch_once(&once, ^{ panelClass = NSClassFromString(@"FQCShortVideoCommentPanelViewController"); });
    for (UIViewController *parent = controller.parentViewController; parent; parent = parent.parentViewController) {
        if (panelClass && [parent isKindOfClass:panelClass]) return YES;
    }
    for (UIView *view = root.superview; view && ![view isKindOfClass:UIWindow.class]; view = view.superview) {
        if (objc_getAssociatedObject(view, SheetGlassKey)) return YES;
    }
    return NO;
}

static BOOL FQXStyleDramaCommentList(UIViewController *controller) {
    if (!controller) return NO;
    [FQXTrackedCommentLists() addObject:controller];
    UIView *root = controller.viewIfLoaded;
    if (!root.window) return NO;
    BOOL embedded = FQXCommentControllerIsEmbedded(controller, root);
    if (embedded && objc_getAssociatedObject(root, SheetGlassKey)) FQXRemoveGlassSheet(root);
    BOOL glass = embedded ? FQXCommentStylingEnabled() : FQXStyleCommentSheet(root, NO);
    FQXClearCommentSurface(root, glass);
    FQXClearCommentSurface(FQXObjGet(controller, "fqc_headerView"), glass);
    UICollectionView *collection = FQXObjGet(controller, "collectionView");
    FQXClearCommentCollection(collection, glass);
    FQXClearCommentCovers(root, CGRectGetWidth(root.bounds), glass);
    if (glass) FQXBoostCommentTypography(root, 0);
    FQXScanAndStyleCommentTopBanners(root);
    static Class toolbarClass = Nil;
    static dispatch_once_t tbOnce;
    dispatch_once(&tbOnce, ^{ toolbarClass = NSClassFromString(@"FQCCommentBottomToolBar"); });
    UIView *bar = nil;
    for (UIView *sub in root.subviews) {
        if (toolbarClass && [sub isKindOfClass:toolbarClass]) {
            bar = sub;
            break;
        }
    }
    if (bar) {
        if ([collection isKindOfClass:UIScrollView.class]) {
            FQXExtendCommentCollectionForFloatingBar(collection, bar, glass);
        }
        FQXStyleCommentBar(bar);
    }
    return glass;
}

static void (*OrigDramaCommentListAppeared)(id, SEL, BOOL);
static void HookDramaCommentListAppeared(UIViewController *controller, SEL cmd, BOOL animated) {
    OrigDramaCommentListAppeared(controller, cmd, animated);
    FQXStyleDramaCommentList(controller);
    FQXScheduleDelayedBannerScan(controller);
}

static void (*OrigDramaCommentListSetupTheme)(id, SEL);
static void HookDramaCommentListSetupTheme(UIViewController *controller, SEL cmd) {
    OrigDramaCommentListSetupTheme(controller, cmd);
    FQXStyleDramaCommentList(controller);
}

static void (*OrigDramaCommentListAdaptDark)(id, SEL);
static void HookDramaCommentListAdaptDark(UIViewController *controller, SEL cmd) {
    OrigDramaCommentListAdaptDark(controller, cmd);
    FQXStyleDramaCommentList(controller);
}

static void (*OrigDramaCommentListTraitChange)(id, SEL, id);
static void HookDramaCommentListTraitChange(UIViewController *controller, SEL cmd, id previous) {
    OrigDramaCommentListTraitChange(controller, cmd, previous);
    FQXStyleDramaCommentList(controller);
}

static void (*OrigDramaCommentListDarkChange)(id, SEL, BOOL);
static void HookDramaCommentListDarkChange(UIViewController *controller, SEL cmd, BOOL dark) {
    OrigDramaCommentListDarkChange(controller, cmd, FQXShouldOverrideCommentTheme() ? FQXCommentsUseDarkTheme() : dark);
    FQXStyleDramaCommentList(controller);
}

static void FQXSetLabelColorForce(UIView *view, UIColor *color, BOOL addShadow) {
    if (!view || !color) return;
    NSUInteger mode = ((NSUInteger)FQXCurrentCommentMaterialStyle() << 1) | (FQXCommentsUseDarkTheme() ? 1u : 0u);
    if ([view isKindOfClass:UILabel.class]) {
        UILabel *label = (UILabel *)view;
        if (![label.textColor isEqual:color]) label.textColor = color;
        if (addShadow && FQXCommentUsesTextShadow()) {
            CGSize targetOffset = CGSizeMake(0.0, 0.5);
            if (!label.shadowColor || !CGSizeEqualToSize(label.shadowOffset, targetOffset)) {
                label.shadowColor = [UIColor colorWithWhite:0.0 alpha:0.38];
                label.shadowOffset = targetOffset;
            }
        } else if (label.shadowColor) {
            label.shadowColor = nil;
            label.shadowOffset = CGSizeZero;
        }
        if (label.attributedText.length > 0) {
            NSUInteger stamp = (1u << 31) ^ ((NSUInteger)mode << 28) ^ (label.attributedText.string.hash & 0x0FFFFFFF);
            NSNumber *prevStamp = objc_getAssociatedObject(label, FQXCommentTypographyStampKey);
            if (!prevStamp || prevStamp.unsignedIntegerValue != stamp) {
                NSMutableAttributedString *mut = [label.attributedText mutableCopy];
                NSRange full = NSMakeRange(0, mut.length);
                [mut addAttribute:NSForegroundColorAttributeName value:color range:full];
                [mut addAttribute:FQXCTForegroundColorAttr value:(id)color.CGColor range:full];
                label.attributedText = mut;
                objc_setAssociatedObject(label, FQXCommentTypographyStampKey, @(stamp), OBJC_ASSOCIATION_RETAIN_NONATOMIC);
            }
        }
        return;
    }
    if ([view isKindOfClass:UIButton.class]) {
        UIButton *btn = (UIButton *)view;
        if (![[btn titleColorForState:UIControlStateNormal] isEqual:color]) {
            [btn setTitleColor:color forState:UIControlStateNormal];
        }
        if (![btn.tintColor isEqual:color]) btn.tintColor = color;
        if (btn.titleLabel) FQXSetLabelColorForce(btn.titleLabel, color, addShadow);
        return;
    }
    if ([view isKindOfClass:UIImageView.class]) {
        UIImageView *iv = (UIImageView *)view;
        if (iv.image) {
            if (iv.image.renderingMode != UIImageRenderingModeAlwaysTemplate) {
                iv.image = [iv.image imageWithRenderingMode:UIImageRenderingModeAlwaysTemplate];
            }
            if (![iv.tintColor isEqual:color]) iv.tintColor = color;
        }
        return;
    }
    SEL setColor = @selector(setTextColor:);
    if ([view respondsToSelector:setColor]) {
        ((void (*)(id, SEL, id))objc_msgSend)(view, setColor, color);
    }
    SEL getLayout = NSSelectorFromString(@"textLayout");
    SEL setLayout = NSSelectorFromString(@"setTextLayout:");
    if ([view respondsToSelector:getLayout] && [view respondsToSelector:setLayout]) {
        id layout = ((id (*)(id, SEL))objc_msgSend)(view, getLayout);
        SEL textSel = NSSelectorFromString(@"text");
        SEL containerSel = NSSelectorFromString(@"container");
        if (layout && [layout respondsToSelector:textSel] && [layout respondsToSelector:containerSel]) {
            id lText = ((id (*)(id, SEL))objc_msgSend)(layout, textSel);
            id container = ((id (*)(id, SEL))objc_msgSend)(layout, containerSel);
            if ([lText isKindOfClass:NSAttributedString.class] && container) {
                NSAttributedString *as = (NSAttributedString *)lText;
                NSUInteger stamp = (1u << 31) ^ ((NSUInteger)mode << 28) ^ (as.string.hash & 0x0FFFFFFF);
                NSNumber *prevStamp = objc_getAssociatedObject(view, FQXCommentTypographyStampKey);
                if (!prevStamp || prevStamp.unsignedIntegerValue != stamp) {
                    NSMutableAttributedString *mut = [as mutableCopy];
                    NSRange full = NSMakeRange(0, mut.length);
                    [mut addAttribute:NSForegroundColorAttributeName value:color range:full];
                    [mut addAttribute:FQXCTForegroundColorAttr value:(id)color.CGColor range:full];
                    Class layoutCls = [layout class];
                    SEL makeLayout = NSSelectorFromString(@"layoutWithContainer:text:");
                    if ([layoutCls respondsToSelector:makeLayout]) {
                        id newLayout = ((id (*)(id, SEL, id, id))objc_msgSend)(layoutCls, makeLayout, container, mut);
                        if (newLayout) ((void (*)(id, SEL, id))objc_msgSend)(view, setLayout, newLayout);
                    }
                    objc_setAssociatedObject(view, FQXCommentTypographyStampKey, @(stamp), OBJC_ASSOCIATION_RETAIN_NONATOMIC);
                }
            }
        }
    } else if ([view respondsToSelector:@selector(attributedText)] && [view respondsToSelector:@selector(setAttributedText:)]) {
        id cur = ((id (*)(id, SEL))objc_msgSend)(view, @selector(attributedText));
        if ([cur isKindOfClass:NSAttributedString.class] && [(NSAttributedString *)cur length] > 0) {
            NSAttributedString *as = (NSAttributedString *)cur;
            NSUInteger stamp = (1u << 31) ^ ((NSUInteger)mode << 28) ^ (as.string.hash & 0x0FFFFFFF);
            NSNumber *prevStamp = objc_getAssociatedObject(view, FQXCommentTypographyStampKey);
            if (!prevStamp || prevStamp.unsignedIntegerValue != stamp) {
                NSMutableAttributedString *mut = [as mutableCopy];
                NSRange full = NSMakeRange(0, mut.length);
                [mut addAttribute:NSForegroundColorAttributeName value:color range:full];
                [mut addAttribute:FQXCTForegroundColorAttr value:(id)color.CGColor range:full];
                ((void (*)(id, SEL, id))objc_msgSend)(view, @selector(setAttributedText:), mut);
                objc_setAssociatedObject(view, FQXCommentTypographyStampKey, @(stamp), OBJC_ASSOCIATION_RETAIN_NONATOMIC);
            }
        }
    }
}

static NSHashTable<UIView *> *FQXTrackedDynamicSearchBanners(void) {
    static NSHashTable<UIView *> *table;
    static dispatch_once_t once;
    dispatch_once(&once, ^{ table = [NSHashTable weakObjectsHashTable]; });
    return table;
}

static NSHashTable<UIView *> *FQXTrackedDynamicNoticeBanners(void) {
    static NSHashTable<UIView *> *table;
    static dispatch_once_t once;
    dispatch_once(&once, ^{ table = [NSHashTable weakObjectsHashTable]; });
    return table;
}

static NSAttributedString *FQXSplitStyleSearchAttributed(NSAttributedString *source, NSString *plainText, UIFont *fallbackFont) {
    UIColor *prefixInk = FQXPrimaryCommentTextColor();
    UIColor *richBlue = FQXRichCommentBlueColor();
    NSMutableAttributedString *mut = nil;
    if (source.length > 0) {
        mut = [source mutableCopy];
    } else if (plainText.length > 0) {
        NSDictionary *attrs = fallbackFont ? @{NSFontAttributeName: fallbackFont} : @{};
        mut = [[NSMutableAttributedString alloc] initWithString:plainText attributes:attrs];
    }
    if (!mut || mut.length == 0) return nil;
    NSString *txt = mut.string ?: @"";
    NSRange colonRange = [txt rangeOfString:@"："];
    if (colonRange.location == NSNotFound) colonRange = [txt rangeOfString:@":"];
    NSUInteger split = (colonRange.location != NSNotFound)
        ? NSMaxRange(colonRange)
        : MIN((NSUInteger)5, mut.length);
    NSRange prefixRange = NSMakeRange(0, MIN(split, mut.length));
    [mut addAttribute:NSForegroundColorAttributeName value:prefixInk range:prefixRange];
    [mut addAttribute:FQXCTForegroundColorAttr value:(id)prefixInk.CGColor range:prefixRange];
    if (split < mut.length) {
        NSRange queryRange = NSMakeRange(split, mut.length - split);
        [mut addAttribute:NSForegroundColorAttributeName value:richBlue range:queryRange];
        [mut addAttribute:FQXCTForegroundColorAttr value:(id)richBlue.CGColor range:queryRange];
    }
    return mut;
}

static void FQXStyleSearchBannerSubtree(UIView *view, NSInteger depth) {
    if (!view || depth > 6 || [view isKindOfClass:UIVisualEffectView.class]) return;
    UIColor *prefixInk = FQXPrimaryCommentTextColor();
    UIColor *richBlue = FQXRichCommentBlueColor();
    NSUInteger mode = ((NSUInteger)FQXCurrentCommentMaterialStyle() << 1) | (FQXCommentsUseDarkTheme() ? 1u : 0u);
    if ([view isKindOfClass:UILabel.class]) {
        UILabel *label = (UILabel *)view;
        NSString *txt = label.text ?: label.attributedText.string ?: @"";
        if ([txt containsString:@"大家都在搜"] || [txt containsString:@"大家在搜"]) {
            if (txt.length > 6) {
                NSUInteger stamp = (1u << 30) ^ ((NSUInteger)mode << 28) ^ (txt.hash & 0x0FFFFFFF);
                NSNumber *prevStamp = objc_getAssociatedObject(label, FQXCommentTypographyStampKey);
                if (!prevStamp || prevStamp.unsignedIntegerValue != stamp) {
                    NSAttributedString *styled = FQXSplitStyleSearchAttributed(label.attributedText, txt, label.font);
                    if (styled) {
                        label.attributedText = styled;
                        FQXSyncLabelShadowForCommentMode(label);
                    }
                    objc_setAssociatedObject(label, FQXCommentTypographyStampKey, @(stamp), OBJC_ASSOCIATION_RETAIN_NONATOMIC);
                }
            } else {
                FQXSetLabelColorForce(label, prefixInk, YES);
            }
        } else if (txt.length > 0) {
            FQXSetLabelColorForce(label, richBlue, YES);
        }
        return;
    }
    if ([view isKindOfClass:UIImageView.class]) {
        FQXSetLabelColorForce(view, richBlue, NO);
        return;
    }
    if ([view isKindOfClass:UIButton.class]) {
        UIButton *btn = (UIButton *)view;
        NSString *t = [btn titleForState:UIControlStateNormal] ?: @"";
        if (([t containsString:@"大家都在搜"] || [t containsString:@"大家在搜"]) && t.length > 6) {
            NSUInteger stamp = (1u << 30) ^ ((NSUInteger)mode << 28) ^ (t.hash & 0x0FFFFFFF);
            NSNumber *prevStamp = objc_getAssociatedObject(btn, FQXCommentTypographyStampKey);
            if (!prevStamp || prevStamp.unsignedIntegerValue != stamp) {
                NSAttributedString *curAttr = [btn attributedTitleForState:UIControlStateNormal];
                NSAttributedString *styled = FQXSplitStyleSearchAttributed(curAttr, t, btn.titleLabel.font);
                if (styled) [btn setAttributedTitle:styled forState:UIControlStateNormal];
                objc_setAssociatedObject(btn, FQXCommentTypographyStampKey, @(stamp), OBJC_ASSOCIATION_RETAIN_NONATOMIC);
            }
        } else {
            FQXSetLabelColorForce(btn, ([t containsString:@"大家都在搜"] || [t containsString:@"大家在搜"]) ? prefixInk : richBlue, YES);
        }
        return;
    }
    // Custom rich-text labels (e.g. YYLabel textLayout + attributedText)
    SEL getLayout = NSSelectorFromString(@"textLayout");
    SEL setLayout = NSSelectorFromString(@"setTextLayout:");
    if ([view respondsToSelector:getLayout] && [view respondsToSelector:setLayout]) {
        id layout = ((id (*)(id, SEL))objc_msgSend)(view, getLayout);
        SEL textSel = NSSelectorFromString(@"text");
        SEL containerSel = NSSelectorFromString(@"container");
        if (layout && [layout respondsToSelector:textSel] && [layout respondsToSelector:containerSel]) {
            id lText = ((id (*)(id, SEL))objc_msgSend)(layout, textSel);
            id container = ((id (*)(id, SEL))objc_msgSend)(layout, containerSel);
            if ([lText isKindOfClass:NSAttributedString.class] && container) {
                NSAttributedString *as = (NSAttributedString *)lText;
                NSString *txt = as.string ?: @"";
                NSUInteger stamp = (1u << 30) ^ ((NSUInteger)mode << 28) ^ (txt.hash & 0x0FFFFFFF);
                NSNumber *prevStamp = objc_getAssociatedObject(view, FQXCommentTypographyStampKey);
                if (prevStamp && prevStamp.unsignedIntegerValue == stamp) return;
                if ([txt containsString:@"大家都在搜"] || [txt containsString:@"大家在搜"]) {
                    NSAttributedString *styled = FQXSplitStyleSearchAttributed(as, txt, nil);
                    Class layoutCls = [layout class];
                    SEL makeLayout = NSSelectorFromString(@"layoutWithContainer:text:");
                    if (styled && [layoutCls respondsToSelector:makeLayout]) {
                        id newLayout = ((id (*)(id, SEL, id, id))objc_msgSend)(layoutCls, makeLayout, container, styled);
                        if (newLayout) {
                            ((void (*)(id, SEL, id))objc_msgSend)(view, setLayout, newLayout);
                            objc_setAssociatedObject(view, FQXCommentTypographyStampKey, @(stamp), OBJC_ASSOCIATION_RETAIN_NONATOMIC);
                            return;
                        }
                    }
                } else if (txt.length > 0) {
                    NSMutableAttributedString *mut = [as mutableCopy];
                    NSRange full = NSMakeRange(0, mut.length);
                    [mut addAttribute:NSForegroundColorAttributeName value:richBlue range:full];
                    [mut addAttribute:FQXCTForegroundColorAttr value:(id)richBlue.CGColor range:full];
                    Class layoutCls = [layout class];
                    SEL makeLayout = NSSelectorFromString(@"layoutWithContainer:text:");
                    if ([layoutCls respondsToSelector:makeLayout]) {
                        id newLayout = ((id (*)(id, SEL, id, id))objc_msgSend)(layoutCls, makeLayout, container, mut);
                        if (newLayout) {
                            ((void (*)(id, SEL, id))objc_msgSend)(view, setLayout, newLayout);
                            objc_setAssociatedObject(view, FQXCommentTypographyStampKey, @(stamp), OBJC_ASSOCIATION_RETAIN_NONATOMIC);
                            return;
                        }
                    }
                }
            }
        }
    }
    if ([view respondsToSelector:@selector(attributedText)] && [view respondsToSelector:@selector(setAttributedText:)]) {
        id curAttr = ((id (*)(id, SEL))objc_msgSend)(view, @selector(attributedText));
        if ([curAttr isKindOfClass:NSAttributedString.class] && [(NSAttributedString *)curAttr length] > 0) {
            NSAttributedString *as = (NSAttributedString *)curAttr;
            NSString *txt = as.string ?: @"";
            if ([txt containsString:@"大家都在搜"] || [txt containsString:@"大家在搜"]) {
                NSUInteger stamp = (1u << 30) ^ ((NSUInteger)mode << 28) ^ (txt.hash & 0x0FFFFFFF);
                NSNumber *prevStamp = objc_getAssociatedObject(view, FQXCommentTypographyStampKey);
                if (!prevStamp || prevStamp.unsignedIntegerValue != stamp) {
                    NSAttributedString *styled = FQXSplitStyleSearchAttributed(as, txt, nil);
                    if (styled) ((void (*)(id, SEL, id))objc_msgSend)(view, @selector(setAttributedText:), styled);
                    objc_setAssociatedObject(view, FQXCommentTypographyStampKey, @(stamp), OBJC_ASSOCIATION_RETAIN_NONATOMIC);
                }
                return;
            } else if (txt.length > 0) {
                FQXSetLabelColorForce(view, richBlue, YES);
                return;
            }
        }
    }
    for (UIView *sub in view.subviews) {
        FQXStyleSearchBannerSubtree(sub, depth + 1);
    }
}

static void FQXSetCommentBannerCollapsed(UIView *banner, BOOL hide) {
    if (!banner) return;
    FQXAudioSetHiddenTracked(banner, hide);
    if (hide) {
        if (banner.alpha > 0.001) banner.alpha = 0.0;
    } else if (banner.alpha < 0.01) {
        banner.alpha = 1.0;
    }
    NSNumber *savedH = objc_getAssociatedObject(banner, FQXCommentBannerSavedHeightKey);
    if (hide) {
        if (CGRectGetHeight(banner.frame) > 0.5) {
            if (!savedH) {
                objc_setAssociatedObject(banner, FQXCommentBannerSavedHeightKey, @(CGRectGetHeight(banner.frame)), OBJC_ASSOCIATION_RETAIN_NONATOMIC);
            }
            CGRect bf = banner.frame;
            CGFloat reclaimed = bf.size.height;
            bf.size.height = 0.0;
            banner.frame = bf;
            UIView *parent = banner.superview;
            if (parent) {
                for (UIView *sib in [parent.subviews copy]) {
                    if (sib == banner || sib.hidden) continue;
                    if ([sib isKindOfClass:UIScrollView.class] &&
                        CGRectGetMinY(sib.frame) >= CGRectGetMinY(bf) + reclaimed - 4.0 &&
                        CGRectGetMinY(sib.frame) <= CGRectGetMinY(bf) + reclaimed + 24.0) {
                        CGRect sf = sib.frame;
                        sf.origin.y -= reclaimed;
                        sf.size.height += reclaimed;
                        sib.frame = sf;
                    }
                }
            }
        }
    } else if (savedH) {
        CGFloat origH = savedH.doubleValue;
        objc_setAssociatedObject(banner, FQXCommentBannerSavedHeightKey, nil, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
        if (origH > 1.0 && CGRectGetHeight(banner.frame) < 1.0) {
            CGRect bf = banner.frame;
            bf.size.height = origH;
            banner.frame = bf;
            [banner.superview setNeedsLayout];
        }
    }
}

static void FQXStyleCommentSearchEntrance(UIView *entrance) {
    if (![entrance isKindOfClass:NSClassFromString(@"FQCShortVideoCommentSearchEntranceView")]) return;
    [FQXTrackedSearchEntrances() addObject:entrance];
    BOOL hideSearch = !FQXCommentSearchEntranceEnabled();
    UIVisualEffectView *pill = objc_getAssociatedObject(entrance, CommentSearchGlassKey);
    if (hideSearch) {
        if (pill) {
            [pill removeFromSuperview];
            objc_setAssociatedObject(entrance, CommentSearchGlassKey, nil, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
        }
        FQXSetCommentBannerCollapsed(entrance, YES);
        return;
    }
    FQXSetCommentBannerCollapsed(entrance, NO);
    CGFloat width = CGRectGetWidth(entrance.bounds);
    CGFloat height = CGRectGetHeight(entrance.bounds);
    BOOL active = entrance.window && !entrance.hidden && entrance.alpha > 0.01 &&
                  FQXCommentStylingEnabled() && width > 80.0 && height > 16.0;
    if (!active) {
        if (pill) {
            [pill removeFromSuperview];
            objc_setAssociatedObject(entrance, CommentSearchGlassKey, nil, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
        }
        FQXClearCommentSurface(entrance, NO);
        FQXClearCommentSurface(FQXObjGet(entrance, "linkContainerView"), NO);
        return;
    }
    UIView *prefix = FQXObjGet(entrance, "prefixLabel");
    UIView *linkBox = FQXObjGet(entrance, "linkContainerView");
    UIView *curLink = FQXObjGet(entrance, "currentLinkLabel");
    UIView *nextLink = FQXObjGet(entrance, "nextLinkLabel");
    if (pill) {
        [pill removeFromSuperview];
        objc_setAssociatedObject(entrance, CommentSearchGlassKey, nil, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
    }
    FQXClearCommentSurface(entrance, YES);
    FQXClearCommentSurface(linkBox, YES);
    UIUserInterfaceStyle desiredUIStyle = FQXDesiredCommentInterfaceStyle();
    if (entrance.overrideUserInterfaceStyle != desiredUIStyle)
        entrance.overrideUserInterfaceStyle = desiredUIStyle;
    if (prefix) FQXSetLabelColorForce(prefix, FQXPrimaryCommentTextColor(), YES);
    if (curLink) FQXSetLabelColorForce(curLink, FQXRichCommentBlueColor(), YES);
    if (nextLink) FQXSetLabelColorForce(nextLink, FQXRichCommentBlueColor(), YES);
    FQXStyleSearchBannerSubtree(entrance, 0);
}

static NSString *FQXDirectTextOfView(UIView *view) {
    if (!view || [view isKindOfClass:UIVisualEffectView.class]) return nil;
    if ([view isKindOfClass:UILabel.class]) {
        UILabel *l = (UILabel *)view;
        return l.text.length ? l.text : l.attributedText.string;
    }
    if ([view isKindOfClass:UIButton.class]) {
        UIButton *b = (UIButton *)view;
        NSString *t = [b titleForState:UIControlStateNormal];
        return t.length ? t : [b attributedTitleForState:UIControlStateNormal].string;
    }
    SEL getLayout = NSSelectorFromString(@"textLayout");
    if ([view respondsToSelector:getLayout]) {
        id layout = ((id (*)(id, SEL))objc_msgSend)(view, getLayout);
        SEL textSel = NSSelectorFromString(@"text");
        if (layout && [layout respondsToSelector:textSel]) {
            id lt = ((id (*)(id, SEL))objc_msgSend)(layout, textSel);
            if ([lt isKindOfClass:NSAttributedString.class] && [(NSAttributedString *)lt length] > 0) {
                return [(NSAttributedString *)lt string];
            }
        }
    }
    if ([view respondsToSelector:@selector(attributedText)]) {
        id attr = ((id (*)(id, SEL))objc_msgSend)(view, @selector(attributedText));
        if ([attr isKindOfClass:NSAttributedString.class] && [(NSAttributedString *)attr length] > 0) {
            return [(NSAttributedString *)attr string];
        }
    }
    return nil;
}

static void FQXCollectShortText(UIView *view, NSMutableString *out, NSInteger depth) {
    if (!view || depth > 4 || out.length > 96 || [view isKindOfClass:UIVisualEffectView.class]) return;
    NSString *direct = FQXDirectTextOfView(view);
    if (direct.length) {
        [out appendFormat:@" %@", direct];
        return;
    }
    for (UIView *sub in view.subviews) {
        FQXCollectShortText(sub, out, depth + 1);
    }
}

static BOOL FQXIsInsideUserCommentCell(UIView *view, UIView *root) {
    for (UIView *cur = view; cur && cur != root; cur = cur.superview) {
        if ([cur isKindOfClass:UICollectionViewCell.class] || [cur isKindOfClass:UITableViewCell.class]) {
            NSString *cn = NSStringFromClass(cur.class);
            if ([cn containsString:@"CommonCell"] || [cn containsString:@"Reply"] ||
                [cn containsString:@"ParagraphV1"] || [cn containsString:@"SeriesCommentCell"]) {
                return YES;
            }
        }
    }
    return NO;
}

static UIView *FQXFindTightestBannerContainer(UIView *leaf, UIView *root) {
    UIView *best = nil;
    for (UIView *cur = leaf.superview; cur && cur != root; cur = cur.superview) {
        if ([cur isKindOfClass:UIScrollView.class] || [cur isKindOfClass:UIVisualEffectView.class]) break;
        CGFloat h = CGRectGetHeight(cur.bounds);
        if (h > 68.0) break;
        NSMutableString *txt = [NSMutableString string];
        FQXCollectShortText(cur, txt, 0);
        // Never collapse the main sheet title/tab header that contains "评论" / "剧评" / "条评论".
        if ([txt containsString:@"条评论"] || [txt containsString:@"剧评"]) break;
        best = cur;
    }
    return best;
}

static void FQXApplyBannerRowState(UIView *leaf, UIView *root, BOOL isSearch) {
    BOOL hide = isSearch ? !FQXCommentSearchEntranceEnabled() : !FQXCommentActivityBannerEnabled();
    NSHashTable<UIView *> *tracker = isSearch ? FQXTrackedDynamicSearchBanners() : FQXTrackedDynamicNoticeBanners();
    UIView *container = FQXFindTightestBannerContainer(leaf, root);
    if (container) {
        [tracker addObject:container];
        FQXSetCommentBannerCollapsed(container, hide);
        if (!hide && FQXCommentStylingEnabled()) {
            FQXClearCommentSurface(container, YES);
            if (isSearch) {
                UIUserInterfaceStyle desiredUIStyle = FQXDesiredCommentInterfaceStyle();
                if (container.overrideUserInterfaceStyle != desiredUIStyle)
                    container.overrideUserInterfaceStyle = desiredUIStyle;
                FQXStyleSearchBannerSubtree(container, 0);
            } else {
                FQXBoostCommentTypography(container, 0);
            }
        }
        return;
    }
    // Leaf sits directly inside a taller header (e.g., alongside 评论/剧评 tabs):
    // act on the leaf and sibling subviews sharing the same horizontal band.
    UIView *parent = leaf.superview;
    CGFloat leafMidY = CGRectGetMidY(leaf.frame);
    if (parent && parent != root) {
        for (UIView *sib in [parent.subviews copy]) {
            if ([sib isKindOfClass:UIScrollView.class] || [sib isKindOfClass:UIVisualEffectView.class]) continue;
            if (CGRectGetHeight(sib.bounds) > 48.0) continue;
            if (fabs(CGRectGetMidY(sib.frame) - leafMidY) > 18.0) continue;
            NSString *sibTxt = FQXDirectTextOfView(sib);
            if (sibTxt && ([sibTxt containsString:@"条评论"] || [sibTxt containsString:@"剧评"] ||
                           [sibTxt isEqualToString:@"评论"])) continue;
            [tracker addObject:sib];
            FQXAudioSetHiddenTracked(sib, hide);
            sib.alpha = hide ? 0.0 : 1.0;
            if (!hide && FQXCommentStylingEnabled()) {
                if (isSearch) FQXStyleSearchBannerSubtree(sib, 0);
                else FQXBoostCommentTypography(sib, 0);
            }
        }
    } else {
        [tracker addObject:leaf];
        FQXAudioSetHiddenTracked(leaf, hide);
        leaf.alpha = hide ? 0.0 : 1.0;
        if (!hide && FQXCommentStylingEnabled()) {
            if (isSearch) FQXStyleSearchBannerSubtree(leaf, 0);
            else FQXBoostCommentTypography(leaf, 0);
        }
    }
}

static void FQXScanBannerNode(UIView *view, UIView *root, NSInteger depth) {
    if (!view || depth > 16 || [view isKindOfClass:UIVisualEffectView.class]) return;
    Class searchCls = NSClassFromString(@"FQCShortVideoCommentSearchEntranceView");
    Class titleCls = NSClassFromString(@"FQCShortVideoCommentTitleView");
    if (searchCls && [view isKindOfClass:searchCls]) {
        FQXStyleCommentSearchEntrance(view);
        return;
    }
    if (titleCls && [view isKindOfClass:titleCls]) {
        BOOL hideBanner = !FQXCommentActivityBannerEnabled();
        [FQXTrackedDynamicNoticeBanners() addObject:view];
        FQXSetCommentBannerCollapsed(view, hideBanner);
        if (!hideBanner && FQXCommentStylingEnabled()) {
            FQXClearCommentSurface(view, YES);
            FQXBoostCommentTypography(view, 0);
        }
        return;
    }
    NSString *direct = FQXDirectTextOfView(view);
    if (direct.length > 0 && view != root && !FQXIsInsideUserCommentCell(view, root)) {
        CGRect inRoot = [view convertRect:view.bounds toView:root];
        CGFloat rootH = CGRectGetHeight(root.bounds);
        if (rootH > 80.0 && CGRectGetMinY(inRoot) < rootH * 0.50) {
            if ([direct containsString:@"大家都在搜"] || [direct containsString:@"大家在搜"]) {
                FQXApplyBannerRowState(view, root, YES);
                return;
            }
            if ([direct containsString:@"社区公约"] || [direct containsString:@"文明发言"] ||
                [direct containsString:@"创作者激励"] || [direct containsString:@"创作激励"] ||
                [direct containsString:@"活动规则"] || [direct containsString:@"活动通知"] ||
                [direct isEqualToString:@"公告"]) {
                FQXApplyBannerRowState(view, root, NO);
                return;
            }
        }
    }
    for (UIView *sub in [view.subviews copy]) {
        FQXScanBannerNode(sub, root, depth + 1);
    }
}

static void FQXScanAndStyleCommentTopBanners(UIView *root) {
    if (!root || !root.window) return;
    if (CGRectGetWidth(root.bounds) < 100.0) return;
    FQXScanBannerNode(root, root, 0);
}

static void FQXScheduleDelayedBannerScan(UIViewController *controller) {
    if (!controller) return;
    __weak UIViewController *weakVC = controller;
    void (^scan)(void) = ^{
        UIViewController *strongVC = weakVC;
        UIView *root = strongVC.viewIfLoaded;
        if (root && root.window) {
            FQXScanAndStyleCommentTopBanners(root);
        }
    };
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.18 * NSEC_PER_SEC)), dispatch_get_main_queue(), scan);
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.60 * NSEC_PER_SEC)), dispatch_get_main_queue(), scan);
}

static void (*OrigCommentSearchLayout)(id, SEL);
static void HookCommentSearchLayout(UIView *entrance, SEL cmd) {
    OrigCommentSearchLayout(entrance, cmd);
    FQXStyleCommentSearchEntrance(entrance);
}

static void (*OrigCommentSearchTheme)(id, SEL, BOOL);
static void HookCommentSearchTheme(UIView *entrance, SEL cmd, BOOL dark) {
    OrigCommentSearchTheme(entrance, cmd, FQXShouldOverrideCommentTheme() ? FQXCommentsUseDarkTheme() : dark);
    FQXStyleCommentSearchEntrance(entrance);
}

static void (*OrigCommentSearchDidMoveWindow)(id, SEL);
static void HookCommentSearchDidMoveWindow(UIView *entrance, SEL cmd) {
    OrigCommentSearchDidMoveWindow(entrance, cmd);
    if (entrance.window) FQXStyleCommentSearchEntrance(entrance);
}

static void (*OrigCommentSearchSetHidden)(id, SEL, BOOL);
static void HookCommentSearchSetHidden(UIView *entrance, SEL cmd, BOOL hidden) {
    BOOL forced = !FQXCommentSearchEntranceEnabled() ? YES : hidden;
    if (OrigCommentSearchSetHidden) OrigCommentSearchSetHidden(entrance, cmd, forced);
    [FQXTrackedSearchEntrances() addObject:entrance];
}

static void (*OrigCommentSearchSetAlpha)(id, SEL, CGFloat);
static void HookCommentSearchSetAlpha(UIView *entrance, SEL cmd, CGFloat alpha) {
    CGFloat forced = !FQXCommentSearchEntranceEnabled() ? 0.0 : alpha;
    if (OrigCommentSearchSetAlpha) OrigCommentSearchSetAlpha(entrance, cmd, forced);
}

static void (*OrigCommentSearchSetFrame)(id, SEL, CGRect);
static void HookCommentSearchSetFrame(UIView *entrance, SEL cmd, CGRect frame) {
    if (!FQXCommentSearchEntranceEnabled()) {
        if (frame.size.height > 0.5 && !objc_getAssociatedObject(entrance, FQXCommentBannerSavedHeightKey)) {
            objc_setAssociatedObject(entrance, FQXCommentBannerSavedHeightKey, @(frame.size.height), OBJC_ASSOCIATION_RETAIN_NONATOMIC);
        }
        frame.size.height = 0.0;
    }
    if (OrigCommentSearchSetFrame) OrigCommentSearchSetFrame(entrance, cmd, frame);
}

static void (*OrigTopSectionPluginDidLayoutEnd)(id, SEL);
static void HookTopSectionPluginDidLayoutEnd(id plugin, SEL cmd) {
    OrigTopSectionPluginDidLayoutEnd(plugin, cmd);
    UIView *entrance = FQXRawIvarObj(plugin, "_searchEntranceView");
    if (entrance) FQXStyleCommentSearchEntrance(entrance);
    UIView *titleView = FQXRawIvarObj(plugin, "_titleView") ?: FQXObjGet(plugin, "titleView");
    if ([titleView isKindOfClass:UIView.class]) {
        BOOL hideBanner = !FQXCommentActivityBannerEnabled();
        [FQXTrackedDynamicNoticeBanners() addObject:titleView];
        FQXSetCommentBannerCollapsed(titleView, hideBanner);
        if (!hideBanner && FQXCommentStylingEnabled()) {
            FQXClearCommentSurface(titleView, YES);
            FQXBoostCommentTypography(titleView, 0);
        }
    }
}

static void FQXInvalidateTypographyStamps(UIView *view, NSInteger depth) {
    if (!view || depth > 14) return;
    if (objc_getAssociatedObject(view, FQXCommentTypographyStampKey)) {
        objc_setAssociatedObject(view, FQXCommentTypographyStampKey, nil, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
    }
    for (UIView *sub in view.subviews) {
        FQXInvalidateTypographyStamps(sub, depth + 1);
    }
}

static void FQXSafeSendVoidMethod(id target, SEL sel) {
    if (!target || !sel) return;
    Method m = class_getInstanceMethod(object_getClass(target), sel);
    if (m && method_getNumberOfArguments(m) == 2) {
        ((void (*)(id, SEL))objc_msgSend)(target, sel);
    }
}

static void FQXSafeSendBoolMethod(id target, SEL sel, BOOL flag) {
    if (!target || !sel) return;
    Method m = class_getInstanceMethod(object_getClass(target), sel);
    if (m && method_getNumberOfArguments(m) == 3) {
        ((void (*)(id, SEL, BOOL))objc_msgSend)(target, sel, flag);
    }
}

static void FQXReapplyAllTrackedCommentGlass(void) {
    if (!NSThread.isMainThread) {
        dispatch_async(dispatch_get_main_queue(), ^{ FQXReapplyAllTrackedCommentGlass(); });
        return;
    }
    BOOL darkTheme = FQXCommentsUseDarkTheme();
    BOOL hideSearch = !FQXCommentSearchEntranceEnabled();
    for (UIView *banner in FQXTrackedDynamicSearchBanners().allObjects) {
        if (!banner.superview) continue;
        FQXSetCommentBannerCollapsed(banner, hideSearch);
        if (!hideSearch && FQXCommentStylingEnabled()) {
            FQXClearCommentSurface(banner, YES);
            FQXStyleSearchBannerSubtree(banner, 0);
        }
    }
    BOOL hideNotice = !FQXCommentActivityBannerEnabled();
    for (UIView *banner in FQXTrackedDynamicNoticeBanners().allObjects) {
        if (!banner.superview) continue;
        FQXSetCommentBannerCollapsed(banner, hideNotice);
        if (!hideNotice && FQXCommentStylingEnabled()) {
            FQXClearCommentSurface(banner, YES);
            FQXInvalidateTypographyStamps(banner, 0);
            FQXBoostCommentTypography(banner, 0);
        }
    }
    SEL darkChangeSel = NSSelectorFromString(@"onDarkModeChange:");
    SEL setupThemeSel = NSSelectorFromString(@"setupTheme");
    for (UIViewController *vc in FQXTrackedCommentPanels().allObjects) {
        if (vc.isViewLoaded && vc.view.window) {
            FQXInvalidateTypographyStamps(vc.view, 0);
            FQXSafeSendBoolMethod(vc, darkChangeSel, darkTheme);
            FQXStyleDramaPanel(vc);
        }
    }
    for (UIViewController *vc in FQXTrackedCommentLists().allObjects) {
        if (vc.isViewLoaded && vc.view.window) {
            FQXInvalidateTypographyStamps(vc.view, 0);
            FQXSafeSendBoolMethod(vc, darkChangeSel, darkTheme);
            FQXStyleDramaCommentList(vc);
        }
    }
    for (UIViewController *vc in FQXTrackedSeriesCommentLists().allObjects) {
        if (vc.isViewLoaded && vc.view.window) {
            FQXInvalidateTypographyStamps(vc.view, 0);
            FQXStyleSeriesCommentList(vc);
        }
    }
    for (UIViewController *vc in FQXTrackedReaderCommentLists().allObjects) {
        if (vc.isViewLoaded && vc.view.window) {
            FQXInvalidateTypographyStamps(vc.view, 0);
            FQXSafeSendVoidMethod(vc, setupThemeSel);
            FQXStyleReaderCommentList(vc);
        }
    }
    SEL barThemeSel = NSSelectorFromString(@"configThemeWithDarkMode:");
    for (UIView *bar in FQXTrackedCommentBars().allObjects) {
        if (bar.window) {
            FQXInvalidateTypographyStamps(bar, 0);
            FQXSafeSendBoolMethod(bar, barThemeSel, darkTheme);
            FQXStyleCommentBar(bar);
        }
    }
    for (UIView *entrance in FQXTrackedSearchEntrances().allObjects) {
        if (entrance.window) FQXStyleCommentSearchEntrance(entrance);
    }
    for (UIView *composer in FQXTrackedExpandedComposers().allObjects) {
        if (composer.window) [composer setNeedsLayout];
    }
    if (!FQXCommentStylingEnabled()) {
        for (UIVisualEffectView *ev in FQXTrackedNeutralizedEffectViews().allObjects) {
            FQXNeutralizeHostEffectView(ev, NO);
        }
        for (UIView *edge in FQXTrackedSuppressedScrollEdges().allObjects) {
            if ([edge isKindOfClass:UIScrollView.class]) {
                FQXSuppressCommentScrollEdgeEffects((UIScrollView *)edge, NO);
            } else {
                FQXAudioSetHiddenTracked(edge, NO);
            }
        }
        for (UIView *dimmer in FQXTrackedCommentDimmers().allObjects) {
            FQXSetCommentDimmerZeroMask(dimmer, NO);
            FQXClearCommentSurface(dimmer, NO);
        }
        for (UIView *cleaned in FQXTrackedCommentCleanedViews().allObjects) {
            FQXClearCommentSurface(cleaned, NO);
        }
    }
    for (UIScene *scene in UIApplication.sharedApplication.connectedScenes) {
        if (![scene isKindOfClass:UIWindowScene.class]) continue;
        for (UIWindow *win in ((UIWindowScene *)scene).windows) {
            FQXSyncDockHiddenForCommentSheets(win, nil);
            FQXResyncVisibleCommentSheetYields(win);
        }
    }
}

static void FQXScheduleCommentForegroundRefresh(void) {
    FQXReapplyAllTrackedCommentGlass();
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.08 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        FQXReapplyAllTrackedCommentGlass();
    });
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.25 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        FQXReapplyAllTrackedCommentGlass();
    });
}

static void FQXStyleWriteReviewButton(UIView *btn, BOOL active) {
    if (![btn isKindOfClass:UIView.class]) return;
    UIVisualEffectView *glass = objc_getAssociatedObject(btn, WriteReviewGlassKey);
    BOOL canStyle = active && btn.window && FQXCommentStylingEnabled() &&
                    CGRectGetWidth(btn.bounds) >= 44.0 && CGRectGetHeight(btn.bounds) >= 24.0;
    // FQCommunityGradientButton's +layerClass is CAGradientLayer, so btn.gradientLayer == btn.layer!
    // Never set hidden = YES on btn.layer (that would hide the entire writeReviewButton).
    // Instead clear/restore CAGradientLayer.colors so only the orange gradient fill disappears.
    CALayer *grad = FQXObjGet(btn, "gradientLayer");
    if (grad == btn.layer && [grad isKindOfClass:CAGradientLayer.class]) {
        CAGradientLayer *gl = (CAGradientLayer *)grad;
        if (gl.hidden) gl.hidden = NO;
        NSArray *savedColors = objc_getAssociatedObject(btn, WriteReviewGradColorsKey);
        if (canStyle) {
            if (!savedColors && gl.colors) {
                objc_setAssociatedObject(btn, WriteReviewGradColorsKey, gl.colors, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
            }
            if (gl.colors) gl.colors = nil;
        } else if (savedColors) {
            gl.colors = savedColors;
            objc_setAssociatedObject(btn, WriteReviewGradColorsKey, nil, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
        }
    } else if (grad && grad != btn.layer) {
        FQXAudioHideGradient(grad, canStyle);
    }
    FQXClearCommentSurface(btn, canStyle);
    FQXClearCommentSurface(FQXObjGet(btn, "contentView"), canStyle);

    UILabel *label = FQXObjGet(btn, "btnTextLabel");
    UIImageView *icon = FQXObjGet(btn, "iconView");
    if (!canStyle) {
        if (glass) {
            FQXReleaseCommentSurface(glass);
            objc_setAssociatedObject(btn, WriteReviewGlassKey, nil, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
        }
        UIColor *savedInk = objc_getAssociatedObject(label, WriteReviewInkKey);
        if (savedInk && [label isKindOfClass:UILabel.class]) {
            label.textColor = savedInk;
            objc_setAssociatedObject(label, WriteReviewInkKey, nil, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
        }
        UIImage *savedIcon = objc_getAssociatedObject(icon, WriteReviewIconKey);
        if (savedIcon && [icon isKindOfClass:UIImageView.class]) {
            icon.image = savedIcon;
            objc_setAssociatedObject(icon, WriteReviewIconKey, nil, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
        }
        return;
    }
    FQXCommentMaterialStyle matStyle = FQXCurrentCommentMaterialStyle();
    glass = FQXEnsureCommentSurface(btn, WriteReviewGlassKey, matStyle);
    if (!glass) return;
    [UIView performWithoutAnimation:^{
        CGRect frame = btn.bounds;
        if (!CGRectEqualToRect(glass.frame, frame)) glass.frame = frame;
        glass.layer.shadowOpacity = 0.0f;
        if ([glass isKindOfClass:FQXCommentGlassSurfaceView.class]) {
            ((FQXCommentGlassSurfaceView *)glass).flexSourceView = btn;
        }
        if (btn.subviews.firstObject != glass) [btn insertSubview:glass atIndex:0];
        if (btn.clipsToBounds) btn.clipsToBounds = NO;
        UIUserInterfaceStyle desiredUIStyle = FQXDesiredCommentInterfaceStyle();
        if (btn.overrideUserInterfaceStyle != desiredUIStyle)
            btn.overrideUserInterfaceStyle = desiredUIStyle;
    }];
    FQXSyncCommentSurface(glass, FQXFindOwningViewController(btn), matStyle,
                          FQXCommentCornerCapsule, 0.0, YES);
    UIColor *ink = FQXPrimaryCommentTextColor();
    if ([label isKindOfClass:UILabel.class]) {
        if (!objc_getAssociatedObject(label, WriteReviewInkKey) && label.textColor) {
            objc_setAssociatedObject(label, WriteReviewInkKey, label.textColor, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
        }
        if (![label.textColor isEqual:ink]) label.textColor = ink;
        FQXSyncLabelShadowForCommentMode(label);
    }
    if ([icon isKindOfClass:UIImageView.class] && icon.image) {
        if (!objc_getAssociatedObject(icon, WriteReviewIconKey)) {
            objc_setAssociatedObject(icon, WriteReviewIconKey, icon.image, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
        }
        if (icon.image.renderingMode != UIImageRenderingModeAlwaysTemplate) {
            icon.image = [icon.image imageWithRenderingMode:UIImageRenderingModeAlwaysTemplate];
        }
        if (![icon.tintColor isEqual:ink]) icon.tintColor = ink;
    }
}

static void FQXStyleSeriesCommentList(UIViewController *controller) {
    if (![controller isKindOfClass:NSClassFromString(@"FQCShortPlaySeriesCommentListViewController")]) return;
    [FQXTrackedSeriesCommentLists() addObject:controller];
    UIView *root = controller.viewIfLoaded;
    if (!root.window) return;
    BOOL glass = FQXStyleDramaCommentList(controller);
    FQXClearCommentSurface(root, glass);
    FQXClearCommentSurface(FQXObjGet(controller, "listView"), glass);
    FQXClearCommentCollection(FQXObjGet(controller, "collectionView"), glass);
    UIView *scoreCard = FQXObjGet(controller, "scoreCardView");
    FQXClearCommentSurface(scoreCard, glass);
    FQXClearCommentSurface(FQXObjGet(scoreCard, "contentView"), glass);
    FQXClearCommentSurface(FQXObjGet(controller, "loadingView"), glass);
    FQXClearCommentSurface(FQXObjGet(controller, "errorContainerView"), glass);
    FQXClearCommentCovers(root, CGRectGetWidth(root.bounds), glass);
    UIView *writeBtn = FQXRawIvarObj(controller, "_writeReviewButton");
    if (writeBtn) FQXStyleWriteReviewButton(writeBtn, glass);
}

static void (*OrigSeriesCommentLayout)(id, SEL);
static void HookSeriesCommentLayout(UIViewController *controller, SEL cmd) {
    OrigSeriesCommentLayout(controller, cmd);
    FQXStyleSeriesCommentList(controller);
}

static void (*OrigSeriesCommentAppeared)(id, SEL, BOOL);
static void HookSeriesCommentAppeared(UIViewController *controller, SEL cmd, BOOL animated) {
    OrigSeriesCommentAppeared(controller, cmd, animated);
    FQXStyleSeriesCommentList(controller);
}

static void (*OrigSeriesCommentTraitChange)(id, SEL, id);
static void HookSeriesCommentTraitChange(UIViewController *controller, SEL cmd, id previous) {
    OrigSeriesCommentTraitChange(controller, cmd, previous);
    FQXStyleSeriesCommentList(controller);
}

static void (*OrigSeriesWriteReviewUpdate)(id, SEL, BOOL);
static void HookSeriesWriteReviewUpdate(UIViewController *controller, SEL cmd, BOOL animated) {
    OrigSeriesWriteReviewUpdate(controller, cmd, animated);
    UIView *writeBtn = FQXRawIvarObj(controller, "_writeReviewButton");
    if (writeBtn) FQXStyleWriteReviewButton(writeBtn, FQXCommentStylingEnabled());
}

static void (*OrigSeriesWriteReviewHidden)(id, SEL, BOOL, BOOL);
static void HookSeriesWriteReviewHidden(UIViewController *controller, SEL cmd, BOOL hidden, BOOL animated) {
    OrigSeriesWriteReviewHidden(controller, cmd, hidden, animated);
    UIView *writeBtn = FQXRawIvarObj(controller, "_writeReviewButton");
    if (writeBtn) FQXStyleWriteReviewButton(writeBtn, FQXCommentStylingEnabled());
}

static void (*OrigSeriesCommentCellLayout)(id, SEL);
static void HookSeriesCommentCellLayout(UICollectionViewCell *cell, SEL cmd) {
    OrigSeriesCommentCellLayout(cell, cmd);
    BOOL glass = FQXCommentStylingEnabled();
    FQXClearCommentSurface(cell, glass);
    FQXClearCommentSurface(cell.contentView, glass);
    FQXClearCommentSurface(cell.backgroundView, glass);
}

static void (*OrigSeriesScoreUpdateViews)(id, SEL);
static void HookSeriesScoreUpdateViews(UIView *scoreView, SEL cmd) {
    OrigSeriesScoreUpdateViews(scoreView, cmd);
    BOOL glass = FQXCommentStylingEnabled();
    FQXClearCommentSurface(scoreView, glass);
    FQXClearCommentSurface(FQXObjGet(scoreView, "contentView"), glass);
}

static void (*OrigDramaCommentHeaderUpdate)(id, SEL, id);
static void HookDramaCommentHeaderUpdate(UIView *header, SEL cmd, id model) {
    OrigDramaCommentHeaderUpdate(header, cmd, model);
    FQXClearCommentSurface(FQXObjGet(header, "v727BackgroundView"), FQXCommentStylingEnabled());
    if (header.window) FQXScanAndStyleCommentTopBanners(header);
}

static void (*OrigDramaCommentHeaderResume)(id, SEL);
static void HookDramaCommentHeaderResume(UIView *header, SEL cmd) {
    OrigDramaCommentHeaderResume(header, cmd);
    FQXClearCommentSurface(FQXObjGet(header, "v727BackgroundView"), FQXCommentStylingEnabled());
}

static void (*OrigDramaCommentListLayout)(id, SEL);
static void HookDramaCommentListLayout(UIViewController *controller, SEL cmd) {
    OrigDramaCommentListLayout(controller, cmd);
    FQXStyleDramaCommentList(controller);
}

static void (*OrigDramaCommentAdapterLayout)(id, SEL);
static void HookDramaCommentAdapterLayout(UIViewController *controller, SEL cmd) {
    OrigDramaCommentAdapterLayout(controller, cmd);
    BOOL glass = FQXStyleDramaCommentList(controller);
    FQXClearCommentSurface(FQXObjGet(controller, "listView"), glass);
    UIViewController *content = FQXObjGet(controller, "contentVC");
    FQXClearCommentSurface(content.viewIfLoaded, glass);
}

static void (*OrigKMPCommentLayout)(id, SEL);
static void HookKMPCommentLayout(UIViewController *controller, SEL cmd) {
    OrigKMPCommentLayout(controller, cmd);
    BOOL glass = FQXStyleDramaCommentList(controller);
    UIViewController *content = FQXObjGet(controller, "kmpVC");
    UIView *body = content.viewIfLoaded;
    FQXClearCommentSurface(body, glass);
    FQXClearCommentCovers(body, CGRectGetWidth(body.bounds), glass);
    if (body && body.window) FQXScanAndStyleCommentTopBanners(body);
}

static void (*OrigKMPCommentTabLayout)(id, SEL);
static void HookKMPCommentTabLayout(UIViewController *controller, SEL cmd) {
    OrigKMPCommentTabLayout(controller, cmd);
    BOOL glass = FQXStyleDramaCommentList(controller);
    UIViewController *content = FQXObjGet(controller, "contentViewController");
    FQXClearCommentSurface(content.viewIfLoaded, glass);
}

static const void *ReaderCommentTransitionKey = &ReaderCommentTransitionKey;

static void FQXStyleGenericCommentList(UIViewController *controller) {
    static Class videoListCls = Nil;
    static Class seriesListCls = Nil;
    static dispatch_once_t once;
    dispatch_once(&once, ^{
        videoListCls = NSClassFromString(@"FQCShortVideoCommentListViewController");
        seriesListCls = NSClassFromString(@"FQCShortPlaySeriesCommentListViewController");
    });
    if (!controller || (videoListCls && [controller isKindOfClass:videoListCls]) ||
        (seriesListCls && [controller isKindOfClass:seriesListCls])) {
        return;
    }
    [FQXTrackedReaderCommentLists() addObject:controller];
    UIView *root = controller.viewIfLoaded;
    if (!root.window || CGRectGetWidth(root.bounds) < 100.0 || CGRectGetHeight(root.bounds) < 72.0) return;
    BOOL embedded = FQXCommentControllerIsEmbedded(controller, root);
    if (embedded && objc_getAssociatedObject(root, SheetGlassKey)) FQXRemoveGlassSheet(root);
    BOOL glass = embedded ? FQXCommentStylingEnabled() : FQXStyleCommentSheet(root, YES);
    FQXClearCommentSurface(root, glass);
    UIView *nav = FQXObjGet(controller, "customNavigationBar");
    FQXClearCommentSurface(nav, glass);
    FQXClearCommentSurface(FQXObjGet(nav, "backgroundView"), glass);
    FQXClearCommentSurface(FQXObjGet(nav, "contentView"), glass);
    UIView *header = FQXObjGet(controller, "headerView") ?: FQXObjGet(controller, "fqc_headerView");
    FQXClearCommentSurface(header, glass);
    FQXClearCommentSurface(FQXObjGet(header, "backgroundView"), glass);
    UICollectionView *collection = FQXObjGet(controller, "collectionView");
    if (collection) FQXClearCommentCollection(collection, glass);
    UIView *bar = FQXObjGet(controller, "bottomToolBar");
    if ([collection isKindOfClass:UIScrollView.class]) {
        FQXExtendCommentCollectionForFloatingBar(collection, bar, glass);
    }
    if (bar) FQXStyleCommentBar(bar);
    FQXClearCommentCovers(root, CGRectGetWidth(root.bounds), glass);
    if (glass) FQXBoostCommentTypography(root, 0);
    FQXScanAndStyleCommentTopBanners(root);
}

static void FQXStyleReaderCommentList(UIViewController *controller) {
    static Class paraCls = Nil;
    static Class baseCls = Nil;
    static Class transitionClass = Nil;
    static dispatch_once_t once;
    dispatch_once(&once, ^{
        paraCls = NSClassFromString(@"FQCParagraphCommentListViewController");
        baseCls = NSClassFromString(@"FQCBaseCommentListViewController");
        transitionClass = NSClassFromString(@"FQVTransitionView");
    });
    if (!controller || !paraCls || ![controller isKindOfClass:paraCls]) {
        if (controller && baseCls && [controller isKindOfClass:baseCls]) {
            FQXStyleGenericCommentList(controller);
        }
        return;
    }
    [FQXTrackedReaderCommentLists() addObject:controller];
    UIView *root = controller.viewIfLoaded;
    if (!root.window) return;
    BOOL glass = FQXStyleCommentSheet(root, YES);
    UIView *nav = FQXObjGet(controller, "customNavigationBar");
    FQXClearCommentSurface(nav, glass);
    FQXClearCommentSurface(FQXObjGet(nav, "backgroundView"), glass);
    FQXClearCommentSurface(FQXObjGet(nav, "contentView"), glass);
    UIView *header = FQXObjGet(controller, "headerView");
    FQXClearCommentSurface(header, glass);
    FQXClearCommentSurface(FQXObjGet(header, "backgroundView"), glass);
    UIView *titleView = FQXRawIvarObj(controller, "_titleView");
    FQXClearCommentSurface(titleView, glass);
    if (titleView) {
        BOOL hideBanner = !FQXCommentActivityBannerEnabled();
        FQXAudioSetHiddenTracked(titleView, hideBanner);
        if (hideBanner && CGRectGetHeight(titleView.frame) > 0.5) {
            CGRect tf = titleView.frame;
            CGFloat reclaimed = tf.size.height;
            tf.size.height = 0.0;
            titleView.frame = tf;
            UICollectionView *cv = FQXObjGet(controller, "collectionView");
            if ([cv isKindOfClass:UIView.class] && cv.superview == titleView.superview &&
                CGRectGetMinY(cv.frame) >= CGRectGetMinY(tf) + reclaimed - 2.0) {
                CGRect cf = cv.frame;
                cf.origin.y -= reclaimed;
                cf.size.height += reclaimed;
                cv.frame = cf;
            }
        }
    }
    FQXClearCommentSurface(FQXObjGet(controller, "forumEntranceView"), glass);
    FQXClearCommentSurface(FQXObjGet(controller, "underlineContainerView"), glass);
    UIView *scroll = FQXObjGet(controller, "containerScrollView");
    FQXClearCommentSurface(scroll, glass);
    FQXClearCommentSurface(FQXObjGet(scroll, "contentView"), glass);
    UICollectionView *collection = FQXObjGet(controller, "collectionView");
    FQXClearCommentCollection(collection, glass);
    UIView *bar = FQXObjGet(controller, "bottomToolBar");
    if ([scroll isKindOfClass:UIScrollView.class]) {
        FQXExtendCommentCollectionForFloatingBar((UIScrollView *)scroll, bar, glass);
    }
    if ([collection isKindOfClass:UIScrollView.class]) {
        FQXExtendCommentCollectionForFloatingBar(collection, bar, glass);
    }
    FQXStyleCommentBar(bar);
    if (glass) FQXBoostCommentTypography(root, 0);
    FQXScanAndStyleCommentTopBanners(root);
    FQXAudioHideGradient(FQXObjGet(controller, "textColorMaskLayer"), glass);

    for (UIView *view = root.superview; view; view = view.superview) {
        if (!transitionClass || ![view isKindOfClass:transitionClass]) continue;
        UIView *content = FQXObjGet(view, "contentView");
        if (content && [root isDescendantOfView:content]) {
            NSHashTable<UIViewController *> *owner = objc_getAssociatedObject(view, ReaderCommentTransitionKey);
            if (!owner) {
                owner = NSHashTable.weakObjectsHashTable;
                objc_setAssociatedObject(view, ReaderCommentTransitionKey, owner, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
            }
            if (owner.anyObject != controller) {
                [owner removeAllObjects];
                [owner addObject:controller];
            }
            for (UIView *wrapper = root.superview; wrapper && wrapper != content.superview; wrapper = wrapper.superview)
                FQXClearCommentSurface(wrapper, glass);
            UIView *carrier = FQXObjGet(view, "contentScrollView");
            if (carrier && [content isDescendantOfView:carrier]) FQXClearCommentSurface(carrier, glass);
            UIView *scrollCarrier = FQXObjGet(view, "scrollView");
            if (scrollCarrier && [content isDescendantOfView:scrollCarrier]) FQXClearCommentSurface(scrollCarrier, glass);
        }
        break;
    }
}

static void (*OrigBaseCommentTheme)(id, SEL);
static void HookBaseCommentTheme(UIViewController *controller, SEL cmd) {
    OrigBaseCommentTheme(controller, cmd);
    FQXStyleReaderCommentList(controller);
}

static void (*OrigReaderCommentTheme)(id, SEL);
static void HookReaderCommentTheme(UIViewController *controller, SEL cmd) {
    OrigReaderCommentTheme(controller, cmd);
    FQXStyleReaderCommentList(controller);
}

static void (*OrigReaderCommentV1Theme)(id, SEL);
static void HookReaderCommentV1Theme(UIViewController *controller, SEL cmd) {
    OrigReaderCommentV1Theme(controller, cmd);
    FQXStyleReaderCommentList(controller);
}

static void FQXScheduleDelayedReaderCommentRestyle(UIViewController *controller) {
    if (!controller) return;
    __weak UIViewController *weakVC = controller;
    void (^restyle)(void) = ^{
        UIViewController *strongVC = weakVC;
        if (strongVC && strongVC.isViewLoaded && strongVC.viewIfLoaded.window && FQXCommentStylingEnabled()) {
            FQXStyleReaderCommentList(strongVC);
        }
    };
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.05 * NSEC_PER_SEC)), dispatch_get_main_queue(), restyle);
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.32 * NSEC_PER_SEC)), dispatch_get_main_queue(), restyle);
}

static void (*OrigReaderCommentV1Appeared)(id, SEL, BOOL);
static void HookReaderCommentV1Appeared(UIViewController *controller, SEL cmd, BOOL animated) {
    OrigReaderCommentV1Appeared(controller, cmd, animated);
    FQXStyleReaderCommentList(controller);
    FQXScheduleDelayedReaderCommentRestyle(controller);
}

static void (*OrigReaderCommentV1Layout)(id, SEL);
static void HookReaderCommentV1Layout(UIViewController *controller, SEL cmd) {
    OrigReaderCommentV1Layout(controller, cmd);
    FQXStyleReaderCommentList(controller);
}

static void (*OrigReaderCommentTransitionLayout)(id, SEL);
static void HookReaderCommentTransitionLayout(UIView *transition, SEL cmd) {
    OrigReaderCommentTransitionLayout(transition, cmd);
    NSHashTable<UIViewController *> *owner = objc_getAssociatedObject(transition, ReaderCommentTransitionKey);
    UIViewController *controller = owner.anyObject;
    if (controller && [controller.viewIfLoaded isDescendantOfView:transition]) {
        FQXStyleReaderCommentList(controller);
        return;
    }
    if (FQXCommentStylingEnabled() && transition.window) {
        UIView *sheet = FQXTrackedSheetInTransition(transition);
        if (sheet) FQXCleanCommentPresentationBackdrops(sheet, transition, YES);
    }
}

static void (*OrigReplyFooterLayout)(id, SEL);
static void HookReplyFooterLayout(UIView *footer, SEL cmd) {
    OrigReplyFooterLayout(footer, cmd);
    FQXClearReplyFooter(footer, FQXCommentStylingEnabled());
}

static void (*OrigReplyFooterTheme)(id, SEL);
static void HookReplyFooterTheme(UIView *footer, SEL cmd) {
    OrigReplyFooterTheme(footer, cmd);
    FQXClearReplyFooter(footer, FQXCommentStylingEnabled());
}

static void (*OrigVideoReplyFooterTheme)(id, SEL);
static void HookVideoReplyFooterTheme(UIView *footer, SEL cmd) {
    OrigVideoReplyFooterTheme(footer, cmd);
    FQXClearReplyFooter(footer, FQXCommentStylingEnabled());
}

static void (*OrigVideoReplyFooterLayout)(id, SEL);
static void HookVideoReplyFooterLayout(UIView *footer, SEL cmd) {
    OrigVideoReplyFooterLayout(footer, cmd);
    FQXClearReplyFooter(footer, FQXCommentStylingEnabled());
}

static void (*OrigParaFooterLayout)(id, SEL);
static void HookParaFooterLayout(UIView *footer, SEL cmd) {
    OrigParaFooterLayout(footer, cmd);
    FQXClearReplyFooter(footer, FQXCommentStylingEnabled());
}

static void (*OrigParaFooterTheme)(id, SEL);
static void HookParaFooterTheme(UIView *footer, SEL cmd) {
    OrigParaFooterTheme(footer, cmd);
    FQXClearReplyFooter(footer, FQXCommentStylingEnabled());
}

static void FQXStyleVideoCommentReplyCell(UICollectionViewCell *cell) {
    if (![cell isKindOfClass:UICollectionViewCell.class]) return;
    FQXClearCommentCell(cell, FQXCommentStylingEnabled());
}

static void (*OrigVideoReplyCellTheme)(id, SEL, BOOL);
static void HookVideoReplyCellTheme(UICollectionViewCell *cell, SEL cmd, BOOL dark) {
    OrigVideoReplyCellTheme(cell, cmd, FQXShouldOverrideCommentTheme() ? FQXCommentsUseDarkTheme() : dark);
    FQXStyleVideoCommentReplyCell(cell);
}

static void (*OrigVideoReplyCellLayout)(id, SEL);
static void HookVideoReplyCellLayout(UICollectionViewCell *cell, SEL cmd) {
    OrigVideoReplyCellLayout(cell, cmd);
    FQXStyleVideoCommentReplyCell(cell);
}

static void (*OrigInvisibleTipCellLayout)(id, SEL);
static void HookInvisibleTipCellLayout(UICollectionViewCell *cell, SEL cmd) {
    OrigInvisibleTipCellLayout(cell, cmd);
    FQXClearCommentCell(cell, FQXCommentStylingEnabled());
}

static void (*OrigInvisibleTipCellBind)(id, SEL, id);
static void HookInvisibleTipCellBind(UICollectionViewCell *cell, SEL cmd, id vm) {
    OrigInvisibleTipCellBind(cell, cmd, vm);
    FQXClearCommentCell(cell, FQXCommentStylingEnabled());
}

static void (*OrigCommentFoldCellLayout)(id, SEL);
static void HookCommentFoldCellLayout(UICollectionViewCell *cell, SEL cmd) {
    OrigCommentFoldCellLayout(cell, cmd);
    FQXClearCommentCell(cell, FQXCommentStylingEnabled());
}

static void (*OrigCommentEmptyCellLayout)(id, SEL);
static void HookCommentEmptyCellLayout(UICollectionViewCell *cell, SEL cmd) {
    OrigCommentEmptyCellLayout(cell, cmd);
    FQXClearCommentCell(cell, FQXCommentStylingEnabled());
}

static void (*OrigSeriesIntroCellLayout)(id, SEL);
static void HookSeriesIntroCellLayout(UICollectionViewCell *cell, SEL cmd) {
    OrigSeriesIntroCellLayout(cell, cmd);
    FQXClearCommentCell(cell, FQXCommentStylingEnabled());
}

// 1a. Comment activity ticker banner toggle (FQCShortVideoCommentTitleView)
static double (*OrigCommentTitleHeight)(id, SEL);
static double HookCommentTitleHeight(id cls, SEL cmd) {
    if (!FQXCommentActivityBannerEnabled()) return 0.0;
    return OrigCommentTitleHeight ? OrigCommentTitleHeight(cls, cmd) : 36.0;
}

static void (*OrigCommentTitleLayout)(id, SEL);
static void HookCommentTitleLayout(UIView *view, SEL cmd) {
    OrigCommentTitleLayout(view, cmd);
    BOOL hide = !FQXCommentActivityBannerEnabled();
    FQXAudioSetHiddenTracked(view, hide);
    if (!hide && FQXCommentStylingEnabled()) {
        FQXClearCommentSurface(view, YES);
        FQXBoostCommentTypography(view, 0);
    }
}

static void (*OrigCommentTitleUpdateModels)(id, SEL, id);
static void HookCommentTitleUpdateModels(UIView *view, SEL cmd, id models) {
    OrigCommentTitleUpdateModels(view, cmd, models);
    BOOL hide = !FQXCommentActivityBannerEnabled();
    [FQXTrackedDynamicNoticeBanners() addObject:view];
    FQXSetCommentBannerCollapsed(view, hide);
    if (!hide && FQXCommentStylingEnabled()) {
        FQXClearCommentSurface(view, YES);
        FQXBoostCommentTypography(view, 0);
    }
}

static void (*OrigCommentTitleSetHidden)(id, SEL, BOOL);
static void HookCommentTitleSetHidden(UIView *view, SEL cmd, BOOL hidden) {
    BOOL forced = !FQXCommentActivityBannerEnabled() ? YES : hidden;
    if (OrigCommentTitleSetHidden) OrigCommentTitleSetHidden(view, cmd, forced);
    [FQXTrackedDynamicNoticeBanners() addObject:view];
}

static void (*OrigCommentTitleSetAlpha)(id, SEL, CGFloat);
static void HookCommentTitleSetAlpha(UIView *view, SEL cmd, CGFloat alpha) {
    CGFloat forced = !FQXCommentActivityBannerEnabled() ? 0.0 : alpha;
    if (OrigCommentTitleSetAlpha) OrigCommentTitleSetAlpha(view, cmd, forced);
}

// 1b. Reader paragraph comment cells (FQCParagraphV1ListCell / FQCParagraphReplyV1ListCell)
static void (*OrigParaV1CellBind)(id, SEL, id);
static void HookParaV1CellBind(UICollectionViewCell *cell, SEL cmd, id vm) {
    OrigParaV1CellBind(cell, cmd, vm);
    FQXClearCommentCell(cell, FQXCommentStylingEnabled());
}

static void (*OrigParaV1CellTheme)(id, SEL);
static void HookParaV1CellTheme(UICollectionViewCell *cell, SEL cmd) {
    OrigParaV1CellTheme(cell, cmd);
    FQXClearCommentCell(cell, FQXCommentStylingEnabled());
}

static void (*OrigParaV1CellLayout)(id, SEL);
static void HookParaV1CellLayout(UICollectionViewCell *cell, SEL cmd) {
    OrigParaV1CellLayout(cell, cmd);
    FQXClearCommentCell(cell, FQXCommentStylingEnabled());
}

static void (*OrigParaReplyV1CellTheme)(id, SEL);
static void HookParaReplyV1CellTheme(UICollectionViewCell *cell, SEL cmd) {
    OrigParaReplyV1CellTheme(cell, cmd);
    FQXClearCommentCell(cell, FQXCommentStylingEnabled());
}

static void (*OrigParaReplyV1CellLayout)(id, SEL);
static void HookParaReplyV1CellLayout(UICollectionViewCell *cell, SEL cmd) {
    OrigParaReplyV1CellLayout(cell, cmd);
    FQXClearCommentCell(cell, FQXCommentStylingEnabled());
}

// 5. Drama comment panel: keep video full-screen without shifting upward
static BOOL FQXIsPlayerTopContentView(id view) {
    if (!view) return NO;
    Class cls1 = NSClassFromString(@"FQVTransitionPlayerTopContentView");
    Class cls2 = NSClassFromString(@"FQVTransitionPlayerLimitScaleTopContentView");
    return (cls1 && [view isKindOfClass:cls1]) || (cls2 && [view isKindOfClass:cls2]);
}

static void (*OrigTransitionSetTopContent)(id, SEL, id);
static void HookTransitionSetTopContent(UIView *transition, SEL cmd, UIView *topView) {
    if (FQXDramaCommentNoVideoShiftEnabled() && FQXIsPlayerTopContentView(topView)) {
        objc_setAssociatedObject(topView, FQXNoVideoShiftSuppressedKey, @YES, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
        OrigTransitionSetTopContent(transition, cmd, nil);
        return;
    }
    OrigTransitionSetTopContent(transition, cmd, topView);
}

static void (*OrigTopContentBindPlayer)(id, SEL, id, CGRect);
static void HookTopContentBindPlayer(UIView *self, SEL cmd, UIView *playerView, CGRect originFrame) {
    if (FQXDramaCommentNoVideoShiftEnabled()) {
        objc_setAssociatedObject(self, FQXNoVideoShiftSuppressedKey, @YES, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
        return;
    }
    objc_setAssociatedObject(self, FQXNoVideoShiftSuppressedKey, nil, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
    OrigTopContentBindPlayer(self, cmd, playerView, originFrame);
}

static void (*OrigTopContentUnbindPlayer)(id, SEL, id);
static void HookTopContentUnbindPlayer(UIView *self, SEL cmd, UIView *playerView) {
    if ([objc_getAssociatedObject(self, FQXNoVideoShiftSuppressedKey) boolValue]) {
        objc_setAssociatedObject(self, FQXNoVideoShiftSuppressedKey, nil, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
        return;
    }
    OrigTopContentUnbindPlayer(self, cmd, playerView);
}

static void (*OrigLimitScaleBindPlayer)(id, SEL, id, CGRect);
static void HookLimitScaleBindPlayer(UIView *self, SEL cmd, UIView *playerView, CGRect originFrame) {
    if (FQXDramaCommentNoVideoShiftEnabled()) {
        objc_setAssociatedObject(self, FQXNoVideoShiftSuppressedKey, @YES, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
        return;
    }
    objc_setAssociatedObject(self, FQXNoVideoShiftSuppressedKey, nil, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
    OrigLimitScaleBindPlayer(self, cmd, playerView, originFrame);
}

static void (*OrigLimitScaleUnbindPlayer)(id, SEL, id);
static void HookLimitScaleUnbindPlayer(UIView *self, SEL cmd, UIView *playerView) {
    if ([objc_getAssociatedObject(self, FQXNoVideoShiftSuppressedKey) boolValue]) {
        objc_setAssociatedObject(self, FQXNoVideoShiftSuppressedKey, nil, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
        return;
    }
    OrigLimitScaleUnbindPlayer(self, cmd, playerView);
}

// 1. Comment sheet visibility -> hide/restore floating Dock & release offscreen Metal IOSurfaces
static void FQXPurgeOffscreenCommentGlassForController(UIViewController *controller) {
    if (!controller || !controller.isViewLoaded) return;
    UIView *root = controller.viewIfLoaded;
    if (!root || root.window) return;
    FQXRemoveGlassSheet(root);
    for (UIView *cur = root.superview; cur; cur = cur.superview) {
        if (objc_getAssociatedObject(cur, SheetGlassKey)) FQXRemoveGlassSheet(cur);
    }
    UIView *bar = FQXObjGet(controller, "bottomToolBar");
    if (bar && !bar.window) {
        UIVisualEffectView *barGlass = objc_getAssociatedObject(bar, DramaComposerGlassKey);
        if (barGlass) {
            FQXReleaseCommentSurface(barGlass);
            objc_setAssociatedObject(bar, DramaComposerGlassKey, nil, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
        }
        objc_setAssociatedObject(bar, FQXBarIsFloatingPillKey, nil, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
    }
    UIView *writeBtn = FQXRawIvarObj(controller, "_writeReviewButton");
    if (writeBtn && !writeBtn.window) {
        UIVisualEffectView *wGlass = objc_getAssociatedObject(writeBtn, WriteReviewGlassKey);
        if (wGlass) {
            FQXReleaseCommentSurface(wGlass);
            objc_setAssociatedObject(writeBtn, WriteReviewGlassKey, nil, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
        }
    }
}

static void FQXScheduleOffscreenCommentGlassRelease(UIViewController *controller) {
    if (!controller) return;
    __weak UIViewController *weakVC = controller;
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.34 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        FQXPurgeOffscreenCommentGlassForController(weakVC);
    });
}

static void FQXCompactWeakTable(NSHashTable *table) {
    if (!table) return;
    NSArray *alive = table.allObjects;
    [table removeAllObjects];
    for (id obj in alive) [table addObject:obj];
}

static void FQXCompactRuntimeMemory(void) {
    if (!NSThread.isMainThread) {
        dispatch_async(dispatch_get_main_queue(), ^{ FQXCompactRuntimeMemory(); });
        return;
    }
    NSArray<NSHashTable<UIViewController *> *> *vcTables = @[
        FQXTrackedCommentPanels(),
        FQXTrackedCommentLists(),
        FQXTrackedSeriesCommentLists(),
        FQXTrackedReaderCommentLists(),
    ];
    for (NSHashTable<UIViewController *> *tbl in vcTables) {
        for (UIViewController *vc in tbl.allObjects) {
            FQXPurgeOffscreenCommentGlassForController(vc);
        }
        FQXCompactWeakTable(tbl);
    }
    for (UIView *bar in FQXTrackedCommentBars().allObjects) {
        if (!bar.window) {
            UIVisualEffectView *g = objc_getAssociatedObject(bar, DramaComposerGlassKey);
            if (g) {
                FQXReleaseCommentSurface(g);
                objc_setAssociatedObject(bar, DramaComposerGlassKey, nil, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
            }
            objc_setAssociatedObject(bar, FQXBarIsFloatingPillKey, nil, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
        }
    }
    FQXCompactWeakTable(FQXTrackedCommentBars());
    FQXCompactWeakTable(FQXTrackedSearchEntrances());
    FQXCompactWeakTable(FQXTrackedDynamicSearchBanners());
    FQXCompactWeakTable(FQXTrackedDynamicNoticeBanners());
    FQXCompactWeakTable(FQXTrackedCommentGlassSurfaces());
    FQXCompactWeakTable(FQXTrackedCommentBlurViews());
    FQXCompactWeakTable(FQXTrackedCommentSheetHosts());
    FQXCompactWeakTable(FQXTrackedCommentComposerHosts());
    FQXCompactWeakTable(FQXTrackedCommentCleanedViews());
    FQXCompactWeakTable(FQXTrackedCommentDimmers());
    FQXCompactWeakTable(FQXTrackedNeutralizedEffectViews());
    FQXCompactWeakTable(FQXTrackedSuppressedScrollEdges());
}

static void (*OrigDramaPanelWillShow)(id, SEL);
static void HookDramaPanelWillShow(UIViewController *controller, SEL cmd) {
    OrigDramaPanelWillShow(controller, cmd);
    if (controller.isViewLoaded && controller.view.window) {
        FQXStyleDramaPanel(controller);
        FQXSyncDockHiddenForCommentSheets(controller.view.window, nil);
    }
}

static void FQXSyncDockHiddenAcrossWindows(UIWindow *preferredWindow, UIViewController *excludingVC) {
    if (preferredWindow) {
        FQXSyncDockHiddenForCommentSheets(preferredWindow, excludingVC);
        return;
    }
    for (UIScene *scene in UIApplication.sharedApplication.connectedScenes) {
        if (![scene isKindOfClass:UIWindowScene.class]) continue;
        for (UIWindow *w in ((UIWindowScene *)scene).windows) {
            FQXSyncDockHiddenForCommentSheets(w, excludingVC);
        }
    }
}

static void (*OrigDramaPanelDismiss)(id, SEL);
static void HookDramaPanelDismiss(UIViewController *controller, SEL cmd) {
    UIWindow *win = controller.viewIfLoaded.window;
    OrigDramaPanelDismiss(controller, cmd);
    FQXSyncDockHiddenAcrossWindows(win, controller);
    FQXScheduleOffscreenCommentGlassRelease(controller);
}

static void (*OrigDramaCommentListDisappeared)(id, SEL, BOOL);
static void HookDramaCommentListDisappeared(UIViewController *controller, SEL cmd, BOOL animated) {
    UIWindow *win = controller.viewIfLoaded.window;
    OrigDramaCommentListDisappeared(controller, cmd, animated);
    FQXSyncDockHiddenAcrossWindows(win, controller);
    FQXScheduleOffscreenCommentGlassRelease(controller);
}

static void (*OrigReaderCommentListDisappeared)(id, SEL, BOOL);
static void HookReaderCommentListDisappeared(UIViewController *controller, SEL cmd, BOOL animated) {
    UIWindow *win = controller.viewIfLoaded.window;
    OrigReaderCommentListDisappeared(controller, cmd, animated);
    FQXSyncDockHiddenAcrossWindows(win, controller);
    FQXScheduleOffscreenCommentGlassRelease(controller);
}

static void (*OrigSeriesCommentListDisappeared)(id, SEL, BOOL);
static void HookSeriesCommentListDisappeared(UIViewController *controller, SEL cmd, BOOL animated) {
    UIWindow *win = controller.viewIfLoaded.window;
    OrigSeriesCommentListDisappeared(controller, cmd, animated);
    FQXSyncDockHiddenAcrossWindows(win, controller);
    FQXScheduleOffscreenCommentGlassRelease(controller);
}

static void (*OrigTransitionShowInView)(id, SEL, id, BOOL, id);
static void HookTransitionShowInView(UIView *self, SEL cmd, UIView *parent, BOOL animated, id completion) {
    OrigTransitionShowInView(self, cmd, parent, animated, completion);
    UIWindow *win = parent.window ?: self.window;
    __weak UIView *weakTrans = self;
    void (^cleanBackdrop)(void) = ^{
        UIView *strongTrans = weakTrans;
        if (!strongTrans || !strongTrans.window || !FQXCommentStylingEnabled()) return;
        UIView *sheet = FQXTrackedSheetInTransition(strongTrans);
        if (sheet) FQXCleanCommentPresentationBackdrops(sheet, strongTrans, YES);
    };
    if (win) {
        dispatch_async(dispatch_get_main_queue(), ^{
            FQXSyncDockHiddenForCommentSheets(win, nil);
            cleanBackdrop();
        });
    }
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.06 * NSEC_PER_SEC)), dispatch_get_main_queue(), cleanBackdrop);
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.36 * NSEC_PER_SEC)), dispatch_get_main_queue(), cleanBackdrop);
}

static void (*OrigTransitionDismissAnimated)(id, SEL, BOOL, id);
static void HookTransitionDismissAnimated(UIView *self, SEL cmd, BOOL animated, id completion) {
    UIWindow *win = self.window;
    NSHashTable<UIViewController *> *owner = objc_getAssociatedObject(self, ReaderCommentTransitionKey);
    UIViewController *excluding = owner.anyObject;
    OrigTransitionDismissAnimated(self, cmd, animated, completion);
    if (excluding) FQXScheduleOffscreenCommentGlassRelease(excluding);
    if (win) {
        FQXSyncDockHiddenForCommentSheets(win, excluding);
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.26 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            FQXSyncDockHiddenForCommentSheets(win, nil);
        });
    }
}

// 2. Short-drama exit "是否放入书架-收藏?" alert suppression toggle
static BOOL (*OrigExitInterruptShouldInterrupt)(id, SEL, id, NSUInteger);
static BOOL HookExitInterruptShouldInterrupt(id self, SEL cmd, id ctx, NSUInteger scene) {
    if (FQXDramaExitCollectAlertHidden()) return NO;
    return OrigExitInterruptShouldInterrupt(self, cmd, ctx, scene);
}

static BOOL (*OrigExitInterruptShouldShowCollectOpt)(id, SEL, id, id);
static BOOL HookExitInterruptShouldShowCollectOpt(id self, SEL cmd, id ctx, id seriesId) {
    if (FQXDramaExitCollectAlertHidden()) return NO;
    return OrigExitInterruptShouldShowCollectOpt(self, cmd, ctx, seriesId);
}

static void (*OrigExitInterruptShowAddShelf)(id, SEL, id);
static void HookExitInterruptShowAddShelf(id self, SEL cmd, id ctx) {
    if (FQXDramaExitCollectAlertHidden()) return;
    OrigExitInterruptShowAddShelf(self, cmd, ctx);
}

static BOOL (*OrigExitInterruptComponentShould)(id, SEL, id);
static BOOL HookExitInterruptComponentShould(id self, SEL cmd, id ctx) {
    if (FQXDramaExitCollectAlertHidden()) return NO;
    return OrigExitInterruptComponentShould(self, cmd, ctx);
}

// 3 & 4. SSAudioPlayIndicatorView & SSShortVideoPlayIndicatorView:
// Cross-class + cross-window deduplication on swipe-back & reader-safe viewport clamping
static NSHashTable<UIView *> *FQXTrackedAudioIndicators(void) {
    static NSHashTable<UIView *> *table;
    static dispatch_once_t once;
    dispatch_once(&once, ^{ table = [NSHashTable weakObjectsHashTable]; });
    return table;
}

static BOOL FQXIsReaderContextActiveForView(UIView *view) {
    Class readerVCCls = NSClassFromString(@"BDReaderViewController");
    Class readerToolCls = NSClassFromString(@"FQReaderSaaSBottomToolView");
    for (UIResponder *r = view; r; r = r.nextResponder) {
        if (readerVCCls && [r isKindOfClass:readerVCCls]) return YES;
    }
    UIWindow *win = view.window;
    if (!win || !readerToolCls) return NO;
    UIViewController *vc = win.rootViewController;
    while (vc) {
        if (readerVCCls && [vc isKindOfClass:readerVCCls]) return YES;
        if ([vc isKindOfClass:UINavigationController.class]) {
            vc = ((UINavigationController *)vc).topViewController;
        } else if ([vc isKindOfClass:UITabBarController.class]) {
            vc = ((UITabBarController *)vc).selectedViewController;
        } else if (vc.presentedViewController) {
            vc = vc.presentedViewController;
        } else {
            break;
        }
    }
    return NO;
}

static CGFloat FQXAudioBottomClearanceForParent(UIView *indicator, UIView *parent) {
    return FQXIsReaderContextActiveForView(indicator ?: parent) ? 152.0 : 96.0;
}

static CGRect FQXClampAudioIndicatorFrame(UIView *indicator, UIView *parent, CGRect frame) {
    CGFloat pw = parent ? CGRectGetWidth(parent.bounds) : CGRectGetWidth(UIScreen.mainScreen.bounds);
    CGFloat ph = parent ? CGRectGetHeight(parent.bounds) : CGRectGetHeight(UIScreen.mainScreen.bounds);
    CGFloat fw = CGRectGetWidth(frame);
    CGFloat fh = CGRectGetHeight(frame);
    if (pw < 200.0 || ph < 300.0 || fw < 24.0 || fh < 20.0) return frame;
    UIEdgeInsets safe = parent ? parent.safeAreaInsets : UIEdgeInsetsZero;
    if (safe.top < 1.0 && parent.window) safe = parent.window.safeAreaInsets;
    if (safe.top < 1.0) {
        for (UIScene *scene in UIApplication.sharedApplication.connectedScenes) {
            if ([scene isKindOfClass:UIWindowScene.class]) {
                UIWindow *kw = ((UIWindowScene *)scene).windows.firstObject;
                if (kw) { safe = kw.safeAreaInsets; break; }
            }
        }
    }
    CGFloat minY = safe.top + 16.0;
    CGFloat clearance = FQXAudioBottomClearanceForParent(indicator, parent);
    CGFloat maxY = MAX(minY, ph - safe.bottom - fh - clearance);
    if (frame.origin.y < minY) frame.origin.y = minY;
    if (frame.origin.y > maxY) frame.origin.y = maxY;
    BOOL pickup = indicator ? FQXBoolGet(indicator, "isPickupState", NO) : NO;
    if (!pickup) {
        if (frame.origin.x < 0.0) frame.origin.x = 0.0;
        CGFloat maxX = MAX(0.0, pw - fw);
        if (frame.origin.x > maxX) frame.origin.x = maxX;
    }
    return frame;
}

static BOOL FQXAudioDedupInFlight = NO;
static BOOL FQXAudioFrameClampInFlight = NO;

static BOOL FQXIsPlayIndicatorView(UIView *view, Class audioCls, Class videoCls) {
    if (!view) return NO;
    if ((audioCls && [view isKindOfClass:audioCls]) || (videoCls && [view isKindOfClass:videoCls])) return YES;
    NSString *clsName = NSStringFromClass(view.class);
    return [clsName containsString:@"PlayIndicatorView"];
}

static UIViewController *FQXEnclosingReaderController(UIView *view) {
    Class readerVCCls = NSClassFromString(@"BDReaderViewController");
    if (!readerVCCls) return nil;
    for (UIResponder *r = view; r; r = r.nextResponder) {
        if ([r isKindOfClass:readerVCCls]) {
            return (UIViewController *)r;
        }
    }
    return nil;
}

static BOOL FQXIsViewInDisappearingReader(UIView *view) {
    UIViewController *rvc = FQXEnclosingReaderController(view);
    return rvc && [objc_getAssociatedObject(rvc, FQXReaderDisappearingKey) boolValue];
}

static void FQXCollectLiveIndicatorsInView(UIView *view, Class audioCls, Class videoCls, NSMutableArray<UIView *> *out, NSInteger depth) {
    if (!view || depth > 20) return;
    if (FQXIsPlayIndicatorView(view, audioCls, videoCls)) {
        if (![out containsObject:view]) [out addObject:view];
        return;
    }
    for (UIView *sub in [view.subviews copy]) {
        FQXCollectLiveIndicatorsInView(sub, audioCls, videoCls, out, depth + 1);
    }
}

static void FQXSetIndicatorHiddenQuietly(UIView *indicator, BOOL hidden) {
    if (!indicator || indicator.hidden == hidden) return;
    BOOL prev = FQXAudioDedupInFlight;
    FQXAudioDedupInFlight = YES;
    indicator.hidden = hidden;
    FQXAudioDedupInFlight = prev;
}

static void FQXApplyIndicatorIslandMuteIfNeeded(UIView *indicator);

static void FQXDeduplicateAudioIndicators(UIView *preferred) {
    if (FQXAudioDedupInFlight) return;
    FQXAudioDedupInFlight = YES;
    if (preferred) [FQXTrackedAudioIndicators() addObject:preferred];
    Class audioCls = NSClassFromString(@"SSAudioPlayIndicatorView");
    Class videoCls = NSClassFromString(@"SSShortVideoPlayIndicatorView");
    NSMutableArray<UIView *> *found = [NSMutableArray array];
    for (UIView *tracked in [FQXTrackedAudioIndicators() allObjects]) {
        if (tracked.window && ![found containsObject:tracked]) [found addObject:tracked];
    }
    for (UIScene *scene in UIApplication.sharedApplication.connectedScenes) {
        if (![scene isKindOfClass:UIWindowScene.class]) continue;
        for (UIWindow *win in ((UIWindowScene *)scene).windows) {
            if (win.hidden || win.alpha < 0.01) continue;
            FQXCollectLiveIndicatorsInView(win, audioCls, videoCls, found, 0);
        }
    }
    if (!found.count) {
        FQXAudioDedupInFlight = NO;
        return;
    }

    // Check if an active (non-disappearing) BDReaderViewController owns any live indicator.
    UIView *activeReaderIndicator = nil;
    UIView *outsideReaderIndicator = nil;
    for (UIView *cand in found) {
        if (!cand.window || !cand.superview) continue;
        UIViewController *rvc = FQXEnclosingReaderController(cand);
        if (rvc) {
            if (![objc_getAssociatedObject(rvc, FQXReaderDisappearingKey) boolValue] && !activeReaderIndicator) {
                activeReaderIndicator = cand;
            }
        } else if (!outsideReaderIndicator) {
            if (!cand.hidden || [objc_getAssociatedObject(cand, FQXAudioIndicatorDedupHiddenKey) boolValue]) {
                outsideReaderIndicator = cand;
            }
        }
    }

    UIView *winner = nil;
    if (activeReaderIndicator) {
        // Inside active reader: keep reader's indicator as sole winner.
        winner = (preferred && FQXEnclosingReaderController(preferred) && !FQXIsViewInDisappearingReader(preferred))
            ? preferred : activeReaderIndicator;
    } else if (outsideReaderIndicator) {
        // Outside reader or swiping back from reader: keep non-reader indicator as sole winner.
        winner = (preferred && preferred.window && !FQXEnclosingReaderController(preferred))
            ? preferred : outsideReaderIndicator;
    } else if (preferred && preferred.window && !FQXIsViewInDisappearingReader(preferred)) {
        winner = preferred;
    }

    if (winner && ([objc_getAssociatedObject(winner, FQXAudioIndicatorDedupHiddenKey) boolValue] ||
                   [objc_getAssociatedObject(winner, FQXReaderSwipeHiddenIndicatorKey) boolValue])) {
        objc_setAssociatedObject(winner, FQXAudioIndicatorDedupHiddenKey, nil, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
        objc_setAssociatedObject(winner, FQXReaderSwipeHiddenIndicatorKey, nil, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
        if (winner.hidden) winner.hidden = NO;
    }

    for (UIView *other in found) {
        if (other == winner || !other.window) continue;
        [FQXTrackedAudioIndicators() addObject:other];
        // Unconditionally suppress any duplicate indicator (including mid-animation fade-ins/outs).
        if (!other.hidden) {
            [other.layer removeAllAnimations];
            objc_setAssociatedObject(other, FQXAudioIndicatorDedupHiddenKey, @YES, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
            other.hidden = YES;
        }
    }
    for (UIView *cand in found) {
        FQXApplyIndicatorIslandMuteIfNeeded(cand);
    }
    FQXAudioDedupInFlight = NO;
    FQXRefreshDynamicIslandState();
}

static void FQXRestoreSuppressedAudioIndicatorIfNeeded(UIView *departing) {
    if (FQXAudioDedupInFlight) return;
    FQXAudioDedupInFlight = YES;
    objc_setAssociatedObject(departing, FQXAudioIndicatorDedupHiddenKey, nil, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
    // Only restore a suppressed indicator if no other live indicator is currently visible.
    BOOL anyVisible = NO;
    for (UIView *other in [FQXTrackedAudioIndicators() allObjects]) {
        if (other != departing && other.superview && other.window && !other.hidden && other.alpha > 0.01) {
            anyVisible = YES;
            break;
        }
    }
    if (!anyVisible) {
        for (UIView *other in [FQXTrackedAudioIndicators() allObjects]) {
            if (other != departing && other.superview && other.window &&
                [objc_getAssociatedObject(other, FQXAudioIndicatorDedupHiddenKey) boolValue]) {
                objc_setAssociatedObject(other, FQXAudioIndicatorDedupHiddenKey, nil, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
                other.hidden = NO;
                break;
            }
        }
    }
    for (UIView *cand in [FQXTrackedAudioIndicators() allObjects]) {
        FQXApplyIndicatorIslandMuteIfNeeded(cand);
    }
    FQXAudioDedupInFlight = NO;
    FQXRefreshDynamicIslandState();
}

static const void *FQXIslandMutedIndicatorKey = &FQXIslandMutedIndicatorKey;
static void (*OrigAudioIndicatorSetAlpha)(id, SEL, CGFloat);

static BOOL FQXIndicatorMutedByDynamicIsland(UIView *indicator) {
    if (!indicator) return NO;
    Class audioCls = NSClassFromString(@"SSAudioPlayIndicatorView");
    Class videoCls = NSClassFromString(@"SSShortVideoPlayIndicatorView");
    if (audioCls && [indicator isKindOfClass:audioCls]) {
        return [NSUserDefaults.standardUserDefaults boolForKey:AudioDynamicIslandPrefKey];
    }
    if (videoCls && [indicator isKindOfClass:videoCls]) {
        return [NSUserDefaults.standardUserDefaults boolForKey:DramaDynamicIslandPrefKey];
    }
    return NO;
}

static void FQXApplyIndicatorIslandMuteIfNeeded(UIView *indicator) {
    if (!indicator) return;
    BOOL mute = FQXIndicatorMutedByDynamicIsland(indicator);
    if (mute) {
        objc_setAssociatedObject(indicator, FQXIslandMutedIndicatorKey, @YES, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
        indicator.userInteractionEnabled = NO;
        if (OrigAudioIndicatorSetAlpha && [indicator isKindOfClass:NSClassFromString(@"SSAudioPlayIndicatorView")]) {
            OrigAudioIndicatorSetAlpha(indicator, @selector(setAlpha:), 0.001);
        } else {
            indicator.alpha = 0.001;
        }
    } else if ([objc_getAssociatedObject(indicator, FQXIslandMutedIndicatorKey) boolValue]) {
        objc_setAssociatedObject(indicator, FQXIslandMutedIndicatorKey, nil, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
        indicator.userInteractionEnabled = YES;
        if (OrigAudioIndicatorSetAlpha && [indicator isKindOfClass:NSClassFromString(@"SSAudioPlayIndicatorView")]) {
            OrigAudioIndicatorSetAlpha(indicator, @selector(setAlpha:), 1.0);
        } else {
            indicator.alpha = 1.0;
        }
    }
}
static void (*OrigAudioIndicatorShowInView)(id, SEL, id, CGRect);
static void HookAudioIndicatorShowInView(UIView *self, SEL cmd, UIView *parent, CGRect pos) {
    CGRect clamped = FQXClampAudioIndicatorFrame(self, parent, pos);
    OrigAudioIndicatorShowInView(self, cmd, parent, clamped);
    FQXApplyIndicatorIslandMuteIfNeeded(self);
    FQXDeduplicateAudioIndicators(self);
}

static void (*OrigAudioIndicatorShowInViewPoint)(id, SEL, id, CGPoint);
static void HookAudioIndicatorShowInViewPoint(UIView *self, SEL cmd, UIView *parent, CGPoint pos) {
    CGRect probe = CGRectMake(pos.x, pos.y, MAX(48.0, CGRectGetWidth(self.bounds)), MAX(40.0, CGRectGetHeight(self.bounds)));
    CGRect clamped = FQXClampAudioIndicatorFrame(self, parent, probe);
    OrigAudioIndicatorShowInViewPoint(self, cmd, parent, clamped.origin);
    FQXApplyIndicatorIslandMuteIfNeeded(self);
    FQXDeduplicateAudioIndicators(self);
}

static void (*OrigAudioIndicatorSetHidden)(id, SEL, BOOL);
static void HookAudioIndicatorSetHidden(UIView *self, SEL cmd, BOOL hidden) {
    OrigAudioIndicatorSetHidden(self, cmd, hidden);
    FQXApplyIndicatorIslandMuteIfNeeded(self);
    if (FQXAudioDedupInFlight) return;
    if (!hidden && self.window) {
        FQXDeduplicateAudioIndicators(self);
    } else if (hidden) {
        FQXRestoreSuppressedAudioIndicatorIfNeeded(self);
        FQXRefreshDynamicIslandState();
    }
}

static void HookAudioIndicatorSetAlpha(UIView *self, SEL cmd, CGFloat alpha) {
    BOOL muted = FQXIndicatorMutedByDynamicIsland(self);
    CGFloat effective = (muted && alpha > 0.01) ? 0.001 : alpha;
    OrigAudioIndicatorSetAlpha(self, cmd, effective);
    if (muted) {
        objc_setAssociatedObject(self, FQXIslandMutedIndicatorKey, @YES, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
        self.userInteractionEnabled = NO;
    }
    if (FQXAudioDedupInFlight) return;
    if (alpha > 0.01 && self.window && !self.hidden) {
        FQXDeduplicateAudioIndicators(self);
    } else if (alpha <= 0.01) {
        FQXRestoreSuppressedAudioIndicatorIfNeeded(self);
        FQXRefreshDynamicIslandState();
    }
}

static void (*OrigAudioIndicatorDidMoveWindow)(id, SEL);
static void HookAudioIndicatorDidMoveWindow(UIView *self, SEL cmd) {
    OrigAudioIndicatorDidMoveWindow(self, cmd);
    if (FQXAudioDedupInFlight) return;
    if (self.window && !self.hidden && self.alpha > 0.01) {
        FQXDeduplicateAudioIndicators(self);
    } else if (!self.window) {
        FQXRestoreSuppressedAudioIndicatorIfNeeded(self);
    }
}

static void (*OrigAudioIndicatorDidMoveSuperview)(id, SEL);
static void HookAudioIndicatorDidMoveSuperview(UIView *self, SEL cmd) {
    OrigAudioIndicatorDidMoveSuperview(self, cmd);
    if (FQXAudioDedupInFlight) return;
    if (self.superview && self.window && !self.hidden && self.alpha > 0.01) {
        FQXDeduplicateAudioIndicators(self);
    }
}

static void (*OrigVideoIndicatorSetHidden)(id, SEL, BOOL);
static void HookVideoIndicatorSetHidden(UIView *self, SEL cmd, BOOL hidden) {
    OrigVideoIndicatorSetHidden(self, cmd, hidden);
    if (FQXAudioDedupInFlight) return;
    if (!hidden && self.window && self.alpha > 0.01) {
        FQXDeduplicateAudioIndicators(self);
    } else if (hidden) {
        FQXRestoreSuppressedAudioIndicatorIfNeeded(self);
    }
}

static void (*OrigVideoIndicatorDidMoveWindow)(id, SEL);
static void HookVideoIndicatorDidMoveWindow(UIView *self, SEL cmd) {
    OrigVideoIndicatorDidMoveWindow(self, cmd);
    if (FQXAudioDedupInFlight) return;
    if (self.window && !self.hidden && self.alpha > 0.01) {
        FQXDeduplicateAudioIndicators(self);
    } else if (!self.window) {
        FQXRestoreSuppressedAudioIndicatorIfNeeded(self);
    }
}

static void (*OrigReaderViewWillDisappear)(id, SEL, BOOL);
static void HookReaderViewWillDisappear(UIViewController *self, SEL cmd, BOOL animated) {
    objc_setAssociatedObject(self, FQXReaderDisappearingKey, @YES, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
    if (OrigReaderViewWillDisappear) OrigReaderViewWillDisappear(self, cmd, animated);

    // Immediately hide ALL reader-owned audio/video floating indicators at frame 0 of swipe-back
    // BEFORE the destination Bookshelf VC even mounts its own indicator into UIWindow, so two
    // capsules can never coexist during interactive pop.
    Class audioCls = NSClassFromString(@"SSAudioPlayIndicatorView");
    Class videoCls = NSClassFromString(@"SSShortVideoPlayIndicatorView");
    UIView *readerView = self.viewIfLoaded;
    if (readerView) {
        NSMutableArray<UIView *> *readerInds = [NSMutableArray array];
        FQXCollectLiveIndicatorsInView(readerView, audioCls, videoCls, readerInds, 0);
        for (UIView *ind in readerInds) {
            [FQXTrackedAudioIndicators() addObject:ind];
            if (!ind.hidden) {
                [ind.layer removeAllAnimations];
                objc_setAssociatedObject(ind, FQXReaderSwipeHiddenIndicatorKey, @YES, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
                FQXSetIndicatorHiddenQuietly(ind, YES);
            }
        }
    }
    FQXDeduplicateAudioIndicators(nil);

    __weak UIViewController *weakSelf = self;
    id<UIViewControllerTransitionCoordinator> coord = self.transitionCoordinator;
    if (coord) {
        [coord notifyWhenInteractionChangesUsingBlock:^(id<UIViewControllerTransitionCoordinatorContext> ctx) {
            UIViewController *strongSelf = weakSelf;
            if (!strongSelf) return;
            if (ctx.isCancelled) {
                objc_setAssociatedObject(strongSelf, FQXReaderDisappearingKey, nil, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
                UIView *rv = strongSelf.viewIfLoaded;
                if (rv) {
                    NSMutableArray<UIView *> *readerInds = [NSMutableArray array];
                    FQXCollectLiveIndicatorsInView(rv, audioCls, videoCls, readerInds, 0);
                    for (UIView *ind in readerInds) {
                        if ([objc_getAssociatedObject(ind, FQXReaderSwipeHiddenIndicatorKey) boolValue] ||
                            [objc_getAssociatedObject(ind, FQXAudioIndicatorDedupHiddenKey) boolValue]) {
                            objc_setAssociatedObject(ind, FQXReaderSwipeHiddenIndicatorKey, nil, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
                            objc_setAssociatedObject(ind, FQXAudioIndicatorDedupHiddenKey, nil, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
                            FQXSetIndicatorHiddenQuietly(ind, NO);
                        }
                    }
                    UIView *first = readerInds.firstObject;
                    if (first) FQXDeduplicateAudioIndicators(first);
                }
            }
        }];
    }
}

static void (*OrigReaderViewDidAppearForDedup)(id, SEL, BOOL);
static void HookReaderViewDidAppearForDedup(UIViewController *self, SEL cmd, BOOL animated) {
    objc_setAssociatedObject(self, FQXReaderDisappearingKey, nil, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
    if (OrigReaderViewDidAppearForDedup) OrigReaderViewDidAppearForDedup(self, cmd, animated);
    Class audioCls = NSClassFromString(@"SSAudioPlayIndicatorView");
    Class videoCls = NSClassFromString(@"SSShortVideoPlayIndicatorView");
    UIView *rv = self.viewIfLoaded;
    if (rv) {
        NSMutableArray<UIView *> *readerInds = [NSMutableArray array];
        FQXCollectLiveIndicatorsInView(rv, audioCls, videoCls, readerInds, 0);
        for (UIView *ind in readerInds) {
            if ([objc_getAssociatedObject(ind, FQXReaderSwipeHiddenIndicatorKey) boolValue]) {
                objc_setAssociatedObject(ind, FQXReaderSwipeHiddenIndicatorKey, nil, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
                FQXSetIndicatorHiddenQuietly(ind, NO);
            }
        }
        if (readerInds.firstObject) FQXDeduplicateAudioIndicators(readerInds.firstObject);
    }
}

static void (*OrigShelfWillAppearAudioDedup)(id, SEL, BOOL);
static void HookShelfWillAppearAudioDedup(UIViewController *self, SEL cmd, BOOL animated) {
    if (OrigShelfWillAppearAudioDedup) OrigShelfWillAppearAudioDedup(self, cmd, animated);
    FQXDeduplicateAudioIndicators(nil);
}

static void (*OrigAudioIndicatorSetFrame)(id, SEL, CGRect);
static void HookAudioIndicatorSetFrame(UIView *self, SEL cmd, CGRect frame) {
    if (FQXAudioFrameClampInFlight) {
        if (OrigAudioIndicatorSetFrame) OrigAudioIndicatorSetFrame(self, cmd, frame);
        return;
    }
    FQXAudioFrameClampInFlight = YES;
    CGRect clamped = self.superview ? FQXClampAudioIndicatorFrame(self, self.superview, frame) : frame;
    if (OrigAudioIndicatorSetFrame) OrigAudioIndicatorSetFrame(self, cmd, clamped);
    FQXAudioFrameClampInFlight = NO;
}

static void (*OrigAudioIndicatorLayout)(id, SEL);
static void HookAudioIndicatorLayout(UIView *self, SEL cmd) {
    if (OrigAudioIndicatorLayout) OrigAudioIndicatorLayout(self, cmd);
    if (!FQXAudioFrameClampInFlight && self.superview && !self.hidden && self.alpha > 0.01) {
        CGRect cur = self.frame;
        CGRect clamped = FQXClampAudioIndicatorFrame(self, self.superview, cur);
        if (fabs(clamped.origin.y - cur.origin.y) > 0.5 || fabs(clamped.origin.x - cur.origin.x) > 0.5) {
            FQXAudioFrameClampInFlight = YES;
            if (OrigAudioIndicatorSetFrame) {
                OrigAudioIndicatorSetFrame(self, @selector(setFrame:), clamped);
            } else {
                self.frame = clamped;
            }
            FQXAudioFrameClampInFlight = NO;
        }
        FQXDeduplicateAudioIndicators(self);
    }
}

static void (*OrigAudioIndicatorWillMove)(id, SEL, id);
static void HookAudioIndicatorWillMove(UIView *self, SEL cmd, UIView *newSuperview) {
    OrigAudioIndicatorWillMove(self, cmd, newSuperview);
    if (!newSuperview) FQXRestoreSuppressedAudioIndicatorIfNeeded(self);
}

static void (*OrigAudioIndicatorLockPos)(id, SEL, CGPoint);
static void HookAudioIndicatorLockPos(UIView *self, SEL cmd, CGPoint pos) {
    UIView *parent = self.superview;
    if (parent) {
        CGRect probe = CGRectMake(pos.x, pos.y, MAX(48.0, CGRectGetWidth(self.bounds)), MAX(40.0, CGRectGetHeight(self.bounds)));
        CGRect clamped = FQXClampAudioIndicatorFrame(self, parent, probe);
        pos = clamped.origin;
    }
    OrigAudioIndicatorLockPos(self, cmd, pos);
}

static CGRect (*OrigAudioIndicatorHoverableArea)(id, SEL);
static CGRect HookAudioIndicatorHoverableArea(UIView *self, SEL cmd) {
    CGRect area = OrigAudioIndicatorHoverableArea(self, cmd);
    UIView *parent = self.superview;
    CGFloat ph = parent ? CGRectGetHeight(parent.bounds) : CGRectGetHeight(UIScreen.mainScreen.bounds);
    UIEdgeInsets safe = parent ? parent.safeAreaInsets : UIEdgeInsetsZero;
    if (safe.top < 1.0 && parent.window) safe = parent.window.safeAreaInsets;
    CGFloat maxBottom = ph - safe.bottom - FQXAudioBottomClearanceForParent(self, parent);
    if (CGRectGetMaxY(area) > maxBottom && maxBottom > area.origin.y + 60.0) {
        area.size.height = maxBottom - area.origin.y;
    }
    return area;
}

static void (*OrigAudioIndicatorSetIsVisible)(id, SEL, BOOL);
static void HookAudioIndicatorSetIsVisible(UIView *self, SEL cmd, BOOL visible) {
    OrigAudioIndicatorSetIsVisible(self, cmd, visible);
    if (visible && self.window && !self.hidden) {
        FQXDeduplicateAudioIndicators(self);
    } else if (!visible) {
        FQXRestoreSuppressedAudioIndicatorIfNeeded(self);
    }
}

static void (*OrigVideoIndicatorSetIsVisible)(id, SEL, BOOL);
static void HookVideoIndicatorSetIsVisible(UIView *self, SEL cmd, BOOL visible) {
    OrigVideoIndicatorSetIsVisible(self, cmd, visible);
    if (visible && self.window && !self.hidden) {
        if (self.superview) {
            CGRect cur = self.frame;
            CGRect clamped = FQXClampAudioIndicatorFrame(self, self.superview, cur);
            if (fabs(clamped.origin.y - cur.origin.y) > 0.5) self.frame = clamped;
        }
        FQXDeduplicateAudioIndicators(self);
    } else if (!visible) {
        FQXRestoreSuppressedAudioIndicatorIfNeeded(self);
    }
}

static void (*OrigVideoIndicatorHoverMove)(id, SEL);
static void HookVideoIndicatorHoverMove(UIView *self, SEL cmd) {
    OrigVideoIndicatorHoverMove(self, cmd);
    if (self.superview && !self.hidden && self.alpha > 0.01) {
        CGRect cur = self.frame;
        CGRect clamped = FQXClampAudioIndicatorFrame(self, self.superview, cur);
        if (fabs(clamped.origin.y - cur.origin.y) > 0.5) self.frame = clamped;
        FQXDeduplicateAudioIndicators(self);
    }
}

static void (*OrigVideoIndicatorMoveToArea)(id, SEL, CGRect);
static void HookVideoIndicatorMoveToArea(UIView *self, SEL cmd, CGRect area) {
    CGRect clamped = self.superview ? FQXClampAudioIndicatorFrame(self, self.superview, area) : area;
    OrigVideoIndicatorMoveToArea(self, cmd, clamped);
}

static CGRect (*OrigVideoIndicatorHoverableArea)(id, SEL);
static CGRect HookVideoIndicatorHoverableArea(UIView *self, SEL cmd) {
    CGRect area = OrigVideoIndicatorHoverableArea(self, cmd);
    UIView *parent = self.superview;
    CGFloat ph = parent ? CGRectGetHeight(parent.bounds) : CGRectGetHeight(UIScreen.mainScreen.bounds);
    UIEdgeInsets safe = parent ? parent.safeAreaInsets : UIEdgeInsetsZero;
    if (safe.top < 1.0 && parent.window) safe = parent.window.safeAreaInsets;
    CGFloat maxBottom = ph - safe.bottom - FQXAudioBottomClearanceForParent(self, parent);
    if (CGRectGetMaxY(area) > maxBottom && maxBottom > area.origin.y + 60.0) {
        area.size.height = maxBottom - area.origin.y;
    }
    return area;
}

static double (*OrigReaderLockedIndicatorTop)(id, SEL, id);
static double HookReaderLockedIndicatorTop(id self, SEL cmd, id readerMgr) {
    double top = OrigReaderLockedIndicatorTop(self, cmd, readerMgr);
    CGFloat sh = CGRectGetHeight(UIScreen.mainScreen.bounds);
    CGFloat safeBottom = 34.0;
    CGFloat safeTop = 44.0;
    for (UIScene *scene in UIApplication.sharedApplication.connectedScenes) {
        if ([scene isKindOfClass:UIWindowScene.class]) {
            UIWindow *kw = ((UIWindowScene *)scene).windows.firstObject;
            if (kw) {
                safeBottom = kw.safeAreaInsets.bottom;
                safeTop = kw.safeAreaInsets.top;
                sh = CGRectGetHeight(kw.bounds);
                break;
            }
        }
    }
    CGFloat maxTop = MAX(safeTop + 16.0, sh - safeBottom - 196.0);
    if (top > maxTop) top = maxTop;
    if (top < safeTop + 16.0) top = safeTop + 16.0;
    return top;
}

static void (*OrigReaderLockIndicator)(id, SEL, CGPoint);
static void HookReaderLockIndicator(id self, SEL cmd, CGPoint pos) {
    CGRect probe = CGRectMake(pos.x, pos.y, 120.0, 44.0);
    CGRect clamped = FQXClampAudioIndicatorFrame(nil, nil, probe);
    CGFloat sh = CGRectGetHeight(UIScreen.mainScreen.bounds);
    CGFloat maxReaderY = MAX(60.0, sh - 210.0);
    if (clamped.origin.y > maxReaderY) clamped.origin.y = maxReaderY;
    OrigReaderLockIndicator(self, cmd, clamped.origin);
}

static CGRect (*OrigAudioSettingFloatingFrame)(id, SEL);
static CGRect HookAudioSettingFloatingFrame(id self, SEL cmd) {
    CGRect saved = OrigAudioSettingFloatingFrame(self, cmd);
    if (CGRectIsEmpty(saved)) return saved;
    return FQXClampAudioIndicatorFrame(nil, nil, saved);
}

static void (*OrigAudioSettingSaveFloatingFrame)(id, SEL, CGRect);
static void HookAudioSettingSaveFloatingFrame(id self, SEL cmd, CGRect frame) {
    CGRect clamped = CGRectIsEmpty(frame) ? frame : FQXClampAudioIndicatorFrame(nil, nil, frame);
    OrigAudioSettingSaveFloatingFrame(self, cmd, clamped);
}

static CGRect FQXComposerKeyboardFrame;

static CGRect FQXCompactComposerFrame(UIView *host, UIView *text, UIView *emoji, UIView *quote,
                                      id input, id editor) {
    if (!host.window || ![text isDescendantOfView:host] || CGRectIsEmpty(text.bounds)) return CGRectNull;
    CGRect content = CGRectNull;
    UIView *editorImages = FQXBoolGet(editor, "isCurrentShowSelectImageView", NO) ? FQXObjGet(editor, "selectImageViews") : nil;
    UIView *controls[] = {text, emoji, quote, FQXObjGet(input, "imagesView"),
        FQXObjGet(input, "addImageButton"), FQXObjGet(input, "emojiButton"),
        FQXObjGet(input, "mentionUserButton"), FQXObjGet(input, "sendButton"),
        FQXObjGet(editor, "funcView"), FQXObjGet(editor, "sendButton"), editorImages};
    for (NSUInteger i = 0; i < sizeof(controls) / sizeof(*controls); ++i) {
        UIView *view = controls[i];
        if (![view isKindOfClass:UIView.class] || ![view isDescendantOfView:host] || CGRectIsEmpty(view.bounds)) continue;
        BOOL visible = YES;
        for (UIView *ancestor = view; ancestor && ancestor != host; ancestor = ancestor.superview) {
            if (ancestor.hidden || ancestor.alpha < 0.01) { visible = NO; break; }
        }
        if (visible) content = CGRectUnion(content, [view convertRect:view.bounds toView:host]);
    }
    if (CGRectIsNull(content)) return CGRectNull;
    CGRect bounds = host.bounds;
    CGRect windowBounds = [host convertRect:host.window.bounds fromView:host.window];
    CGFloat left = MAX(CGRectGetMinX(bounds), CGRectGetMinX(windowBounds)) + 11.0;
    CGFloat right = MIN(CGRectGetMaxX(bounds), CGRectGetMaxX(windowBounds)) - 11.0;
    return CGRectMake(left, CGRectGetMinY(content) - 12.0, MAX(0.0, right - left),
                      CGRectGetHeight(content) + 24.0);
}

static void FQXPlaceExpandedComposer(UIView *host, CGRect cardFrame, BOOL floating) {
    if (!host) return;
    NSValue *last = objc_getAssociatedObject(host, ExpandedInputAppliedTransformKey);
    NSValue *saved = objc_getAssociatedObject(host, ExpandedInputBaseTransformKey);
    CGAffineTransform current = host.transform;
    CGAffineTransform base = last && CGAffineTransformEqualToTransform(current, last.CGAffineTransformValue)
        ? saved.CGAffineTransformValue : current;
    CGAffineTransform desired = base;
    if (floating && !CGRectIsNull(cardFrame)) {
        UIWindow *window = host.window;
        CGRect inWindow = [host convertRect:cardFrame toView:window];
        CGFloat shift = current.ty - base.ty;
        CGFloat stockBottom = CGRectGetMaxY(inWindow) - shift;
        CGRect keyboard = [window convertRect:FQXComposerKeyboardFrame fromCoordinateSpace:window.screen.coordinateSpace];
        BOOL docked = !CGRectIsEmpty(keyboard) && CGRectIntersectsRect(keyboard, window.bounds) &&
            CGRectGetWidth(keyboard) >= CGRectGetWidth(window.bounds) * 0.75 &&
            CGRectGetMaxY(keyboard) >= CGRectGetMaxY(window.bounds) - window.safeAreaInsets.bottom;
        CGFloat gap = 11.0;
        CGFloat lift = docked ? stockBottom - CGRectGetMinY(keyboard) + gap : gap;
        CGFloat stockTop = CGRectGetMinY(inWindow) - shift;
        desired.ty -= MIN(lift, stockTop - window.safeAreaInsets.top - 4.0);
        if (!saved || !CGAffineTransformEqualToTransform(saved.CGAffineTransformValue, base)) {
            objc_setAssociatedObject(host, ExpandedInputBaseTransformKey, [NSValue valueWithCGAffineTransform:base], OBJC_ASSOCIATION_RETAIN_NONATOMIC);
        }
        if (!last || !CGAffineTransformEqualToTransform(last.CGAffineTransformValue, desired)) {
            objc_setAssociatedObject(host, ExpandedInputAppliedTransformKey, [NSValue valueWithCGAffineTransform:desired], OBJC_ASSOCIATION_RETAIN_NONATOMIC);
        }
    } else if (last) {
        objc_setAssociatedObject(host, ExpandedInputAppliedTransformKey, nil, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
        objc_setAssociatedObject(host, ExpandedInputBaseTransformKey, nil, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
    }
    if (!CGAffineTransformEqualToTransform(current, desired)) host.transform = desired;
}

static void FQXStyleExpandedCommentInput(UIView *editor, UIView *sheet, UIView *text, UIView *emoji) {
    if (!sheet) return;
    FQXCommentComposerStyle compStyle = FQXCurrentCommentComposerStyle();
    BOOL floatingDetached = (compStyle == FQXCommentComposerFloatingDetached);
    CGRect frame = floatingDetached ? FQXCompactComposerFrame(sheet, text, emoji, nil, nil, editor)
        : sheet.bounds;
    BOOL glass = FQXPlaceCommentComposerGlass(sheet, frame, 22.0, FQXCommentViewIsDark(sheet), NO);
    FQXPlaceExpandedComposer(sheet, frame, glass && floatingDetached);
    if (glass) {
        if (!objc_getAssociatedObject(sheet, ExpandedInputSavedClipsKey)) {
            objc_setAssociatedObject(sheet, ExpandedInputSavedClipsKey, @(sheet.clipsToBounds), OBJC_ASSOCIATION_RETAIN_NONATOMIC);
        }
        BOOL wantClips = !floatingDetached && (FQXComposerEffectiveMaterialStyle() == FQXCommentMaterialGaussianBlur);
        if (sheet.clipsToBounds != wantClips) sheet.clipsToBounds = wantClips;
    } else {
        NSNumber *savedClips = objc_getAssociatedObject(sheet, ExpandedInputSavedClipsKey);
        if (savedClips) {
            sheet.clipsToBounds = savedClips.boolValue;
            objc_setAssociatedObject(sheet, ExpandedInputSavedClipsKey, nil, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
        }
    }
    FQXClearCommentSurface(sheet, glass || (floatingDetached && sheet.window));
    FQXClearCommentSurface(emoji, glass);
    FQXClearCommentSurface(text, glass);
    FQXClearCommentCovers(sheet, CGRectGetWidth(sheet.bounds), glass);
    UIVisualEffectView *keep = objc_getAssociatedObject(sheet, DramaComposerGlassKey);
    FQXNeutralizeStrayBarGlass(sheet, keep, glass, 0);
    if (glass) {
        UIUserInterfaceStyle desiredUIStyle = FQXDesiredCommentInterfaceStyle();
        if (sheet.overrideUserInterfaceStyle != desiredUIStyle)
            sheet.overrideUserInterfaceStyle = desiredUIStyle;
        FQXStyleActiveCommentTextInput(text);
        FQXBoostCommentTypography(sheet, 0);
    }
}

static BOOL FQXViewHasVisibleTextContent(UIView *view, NSInteger depth) {
    if (![view isKindOfClass:UIView.class] || view.hidden || view.alpha < 0.05 || depth > 5) return NO;
    if (CGRectGetWidth(view.bounds) < 4.0 || CGRectGetHeight(view.bounds) < 4.0) return NO;
    NSString *direct = FQXDirectTextOfView(view);
    if (direct.length > 0) return YES;
    for (UIView *sub in view.subviews) {
        if (FQXViewHasVisibleTextContent(sub, depth + 1)) return YES;
    }
    return NO;
}

static void FQXClearStaleComposerHost(UIView *host) {
    if (!host) return;
    UIVisualEffectView *stale = objc_getAssociatedObject(host, DramaComposerGlassKey);
    if (stale) {
        FQXReleaseCommentSurface(stale);
        objc_setAssociatedObject(host, DramaComposerGlassKey, nil, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
    }
    objc_setAssociatedObject(host, FQXComposerFloatingKey, nil, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
    FQXRestoreSheetTopCornerMask(host);
    FQXPlaceExpandedComposer(host, CGRectZero, NO);
    NSNumber *savedClips = objc_getAssociatedObject(host, ExpandedInputSavedClipsKey);
    if (savedClips) {
        host.clipsToBounds = savedClips.boolValue;
        objc_setAssociatedObject(host, ExpandedInputSavedClipsKey, nil, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
    }
    FQXResyncVisibleCommentSheetYields(host.window);
}

static void FQXStyleCommunityInput(UIView *editor) {
    if (![editor isKindOfClass:UIView.class]) return;
    [FQXTrackedExpandedComposers() addObject:editor];
    UIView *sheet = FQXObjGet(editor, "containerView");
    UIView *input = FQXObjGet(editor, "commentInputView");
    UIView *paraBg = FQXObjGet(input, "paraBgView");
    UIView *emoji = FQXObjGet(editor, "subEmojiPanelView");
    UIView *text = FQXObjGet(input, "textView");

    FQXCommentComposerStyle compStyle = FQXCurrentCommentComposerStyle();
    BOOL floatingDetached = (compStyle == FQXCommentComposerFloatingDetached);

    UIView *glassHost = sheet;
    CGRect glassFrame = sheet ? sheet.bounds : CGRectZero;
    BOOL useEditorHost = NO;
    BOOL paraHasQuote = FQXViewHasVisibleTextContent(paraBg, 0);
    if (sheet && paraHasQuote &&
        [paraBg isDescendantOfView:editor] && [sheet isDescendantOfView:editor]) {
        CGRect paraInSheet = [paraBg convertRect:paraBg.bounds toView:sheet];
        if (CGRectGetMinY(paraInSheet) < -1.0) {
            CGRect sheetInEditor = [sheet convertRect:sheet.bounds toView:editor];
            CGRect paraInEditor = [paraBg convertRect:paraBg.bounds toView:editor];
            CGFloat topY = MAX(0.0, MIN(CGRectGetMinY(sheetInEditor), CGRectGetMinY(paraInEditor)));
            CGFloat botY = MAX(CGRectGetMaxY(sheetInEditor), CGRectGetMaxY(paraInEditor));
            glassHost = editor;
            glassFrame = CGRectMake(0.0, topY, CGRectGetWidth(editor.bounds), botY - topY);
            useEditorHost = YES;
        }
    }
    if (useEditorHost) {
        FQXClearStaleComposerHost(sheet);
    } else if (editor != sheet) {
        FQXClearStaleComposerHost(editor);
    }

    if (floatingDetached) {
        glassFrame = FQXCompactComposerFrame(glassHost, text, emoji, paraHasQuote ? paraBg : nil, input, editor);
    }
    BOOL glass = NO;
    if (glassHost) {
        glass = FQXPlaceCommentComposerGlass(glassHost, glassFrame, 22.0, FQXCommentViewIsDark(glassHost), NO);
        FQXPlaceExpandedComposer(glassHost, glassFrame, glass && floatingDetached);
        if (glass) {
            if (!objc_getAssociatedObject(glassHost, ExpandedInputSavedClipsKey)) {
                objc_setAssociatedObject(glassHost, ExpandedInputSavedClipsKey, @(glassHost.clipsToBounds), OBJC_ASSOCIATION_RETAIN_NONATOMIC);
            }
            BOOL wantClips = !floatingDetached && (FQXComposerEffectiveMaterialStyle() == FQXCommentMaterialGaussianBlur);
            if (glassHost.clipsToBounds != wantClips) glassHost.clipsToBounds = wantClips;
        } else {
            NSNumber *savedClips = objc_getAssociatedObject(glassHost, ExpandedInputSavedClipsKey);
            if (savedClips) {
                glassHost.clipsToBounds = savedClips.boolValue;
                objc_setAssociatedObject(glassHost, ExpandedInputSavedClipsKey, nil, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
            }
        }
    }
    UIVisualEffectView *keep = glassHost ? objc_getAssociatedObject(glassHost, DramaComposerGlassKey) : nil;
    BOOL clearHost = glass || (floatingDetached && editor.window);
    FQXClearCommentSurface(editor, clearHost);
    FQXClearCommentSurface(sheet, clearHost);
    FQXClearCommentSurface(input, clearHost);
    FQXClearCommentSurface(text, glass);
    FQXClearCommentSurface(emoji, glass);
    FQXClearCommentSurface(FQXObjGet(input, "bgView"), clearHost);
    FQXClearCommentSurface(FQXObjGet(input, "contentView"), clearHost);
    FQXClearCommentSurface(FQXObjGet(editor, "bgView"), clearHost);
    FQXClearCommentSurface(FQXObjGet(editor, "backView"), clearHost);
    FQXClearCommentSurface(FQXObjGet(editor, "coverView"), clearHost);
    FQXClearCommentSurface(FQXObjGet(editor, "topMaskView"), clearHost);
    FQXClearCommentSurface(paraBg, glass);
    FQXHideLayerGradients(paraBg.layer, glass);
    FQXHideLayerGradients(editor.layer, glass);
    FQXHideLayerGradients(sheet.layer, glass);
    FQXHideLayerGradients(input.layer, glass);
    if (paraBg && !paraHasQuote) {
        FQXAudioSetHiddenTracked(paraBg, glass);
    }
    FQXClearCommentSurface(FQXObjGet(editor, "emoticonContainerView"), glass);
    FQXAudioSetHiddenTracked(FQXObjGet(input, "topLine"), glass);
    FQXAudioSetHiddenTracked(FQXObjGet(input, "topMaskView"), glass);
    FQXAudioSetHiddenTracked(FQXObjGet(editor, "topMaskView"), glass);
    FQXClearCommentCovers(sheet, CGRectGetWidth(sheet.bounds), glass);
    if (!useEditorHost && sheet && sheet.superview == editor) {
        for (UIView *sub in [editor.subviews copy]) {
            if (sub == sheet || sub == keep || [sub isKindOfClass:UIControl.class] ||
                [sub isKindOfClass:UIScrollView.class]) continue;
            if (!FQXViewHasVisibleTextContent(sub, 0)) {
                FQXClearCommentSurface(sub, glass);
                FQXHideLayerGradients(sub.layer, glass);
            }
        }
    }
    FQXNeutralizeStrayBarGlass(editor, keep, glass, 0);
    if (glass) {
        UIUserInterfaceStyle desiredUIStyle = FQXDesiredCommentInterfaceStyle();
        if (editor.overrideUserInterfaceStyle != desiredUIStyle)
            editor.overrideUserInterfaceStyle = desiredUIStyle;
        FQXStyleActiveCommentTextInput(text);
        FQXBoostCommentTypography(editor, 0);
    }
}

static void FQXRestyleEnclosingCommunityInput(UIView *input) {
    Class cls = NSClassFromString(@"FQCCommunityInputView");
    for (UIView *cur = input.superview; cur; cur = cur.superview) {
        if (cls && [cur isKindOfClass:cls]) {
            FQXStyleCommunityInput(cur);
            return;
        }
    }
}

static void (*Orig503CommentInputLayout)(id, SEL);
static void Hook503CommentInputLayout(UIView *input, SEL cmd) {
    Orig503CommentInputLayout(input, cmd);
    FQXRestyleEnclosingCommunityInput(input);
}

static void (*Orig503CommentInputTheme)(id, SEL, BOOL);
static void Hook503CommentInputTheme(UIView *input, SEL cmd, BOOL dark) {
    Orig503CommentInputTheme(input, cmd, FQXShouldOverrideCommentTheme() ? FQXCommentsUseDarkTheme() : dark);
    FQXRestyleEnclosingCommunityInput(input);
}

static void (*OrigCommunityInputLayout)(id, SEL);
static void HookCommunityInputLayout(UIView *editor, SEL cmd) {
    OrigCommunityInputLayout(editor, cmd);
    if (![editor isKindOfClass:NSClassFromString(@"FQCShortVideoInputView")]) {
        FQXStyleCommunityInput(editor);
    }
}

static void (*OrigShortVideoInputLayout)(id, SEL);
static void HookShortVideoInputLayout(UIView *editor, SEL cmd) {
    OrigShortVideoInputLayout(editor, cmd);
    FQXStyleCommunityInput(editor);
}

static void (*OrigShortVideoNewEditorLayout)(id, SEL);
static void HookShortVideoNewEditorLayout(UIView *editor, SEL cmd) {
    OrigShortVideoNewEditorLayout(editor, cmd);
    UIView *content = FQXObjGet(editor, "contentView");
    UIView *inputContainer = FQXObjGet(editor, "inputContainerView");
    UIView *sheet = (content && (!inputContainer || [inputContainer isDescendantOfView:content])) ? content : inputContainer;
    [FQXTrackedExpandedComposers() addObject:editor];
    if (sheet != inputContainer && inputContainer) {
        FQXClearStaleComposerHost(inputContainer);
    }
    FQXStyleExpandedCommentInput(editor, sheet, FQXObjGet(editor, "textView"), FQXObjGet(editor, "emojiListView"));
    BOOL glass = objc_getAssociatedObject(sheet, DramaComposerGlassKey) != nil;
    BOOL clearHost = glass || (sheet && editor.window &&
        FQXCurrentCommentComposerStyle() == FQXCommentComposerFloatingDetached);
    FQXClearCommentSurface(editor, clearHost);
    FQXClearCommentSurface(content, clearHost);
    FQXClearCommentSurface(inputContainer, clearHost);
    FQXClearCommentSurface(FQXObjGet(editor, "emoticonContainerView"), glass);
    FQXClearCommentSurface(FQXObjGet(editor, "funcView"), clearHost);
    FQXClearCommentSurface(FQXObjGet(editor, "bgView"), clearHost);
    FQXClearCommentSurface(FQXObjGet(editor, "topMaskView"), clearHost);
    FQXAudioSetHiddenTracked(FQXObjGet(editor, "topMaskView"), glass);
    FQXHideLayerGradients(editor.layer, glass);
    FQXHideLayerGradients(content.layer, glass);
}

static void (*OrigReaderCommentBarLayout)(id, SEL);
static void HookReaderCommentBarLayout(UIView *toolbar, SEL cmd) {
    OrigReaderCommentBarLayout(toolbar, cmd);
    FQXStyleCommentBar(toolbar);
}

static void (*OrigReaderCommentListLayout)(id, SEL);
static void HookReaderCommentListLayout(UIViewController *controller, SEL cmd) {
    OrigReaderCommentListLayout(controller, cmd);
    FQXStyleReaderCommentList(controller);
}

static void (*OrigReaderCommentListAppeared)(id, SEL, BOOL);
static void HookReaderCommentListAppeared(UIViewController *controller, SEL cmd, BOOL animated) {
    OrigReaderCommentListAppeared(controller, cmd, animated);
    FQXStyleReaderCommentList(controller);
    FQXScheduleDelayedReaderCommentRestyle(controller);
}

static void (*OrigSharePanelLayout)(id, SEL);
static void HookSharePanelLayout(UIView *panel, SEL cmd) {
    OrigSharePanelLayout(panel, cmd);
    BOOL glass = FQXStyleGlassSheet(panel, NO, NO);
    FQXAudioClearBackground(FQXObjGet(panel, "collectionView"), glass);
    UIView *controls = FQXObjGet(panel, "controlView");
    FQXAudioClearBackground(controls, glass);
    FQXAudioClearBackground(FQXObjGet(controls, "collectionView"), glass);
}

static void (*OrigKMPShareLayout)(id, SEL);
static void HookKMPShareLayout(UIViewController *controller, SEL cmd) {
    OrigKMPShareLayout(controller, cmd);
    UIViewController *content = FQXObjGet(controller, "contentViewController");
    UIView *sheet = content.viewIfLoaded;
    UIView *root = controller.viewIfLoaded;
    if (!sheet || ![sheet isDescendantOfView:root]) return;
    // The wrapper can include a full-screen dismissal area. Use its actual
    // content frame in that arrangement, so the glass starts at the sheet.
    BOOL fillsWrapper = fabs(CGRectGetHeight(root.bounds) - CGRectGetHeight(sheet.bounds)) < 2.0;
    UIView *previous = fillsWrapper ? sheet : root;
    if (objc_getAssociatedObject(previous, SheetGlassKey)) FQXRemoveGlassSheet(previous);
    BOOL glass = FQXStyleGlassSheet(fillsWrapper ? root : sheet, NO, NO);
    if (fillsWrapper) FQXAudioClearBackground(sheet, glass);
}

static CGPoint FQXAudioStockCenter(UIView *view) {
    CGPoint current = view.center;
    NSValue *applied = objc_getAssociatedObject(view, AudioAppliedPositionKey);
    NSValue *saved = objc_getAssociatedObject(view, AudioStockPositionKey);
    return applied && saved && CGPointEqualToPoint(current, applied.CGPointValue)
        ? saved.CGPointValue : current;
}

static void FQXAudioPlaceView(UIView *view, CGPoint target, BOOL active) {
    if (!view.superview) return;
    CGPoint current = view.center;
    CGPoint stock = FQXAudioStockCenter(view);
    NSValue *applied = objc_getAssociatedObject(view, AudioAppliedPositionKey);
    NSValue *saved = objc_getAssociatedObject(view, AudioStockPositionKey);
    CGPoint desired = active ? target : stock;
    if (!CGPointEqualToPoint(current, desired)) view.center = desired;
    if (active && !CGPointEqualToPoint(desired, stock)) {
        if (!saved || !CGPointEqualToPoint(stock, saved.CGPointValue))
            objc_setAssociatedObject(view, AudioStockPositionKey, [NSValue valueWithCGPoint:stock], OBJC_ASSOCIATION_RETAIN_NONATOMIC);
        if (!applied || !CGPointEqualToPoint(desired, applied.CGPointValue))
            objc_setAssociatedObject(view, AudioAppliedPositionKey, [NSValue valueWithCGPoint:desired], OBJC_ASSOCIATION_RETAIN_NONATOMIC);
    } else if (applied) {
        objc_setAssociatedObject(view, AudioStockPositionKey, nil, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
        objc_setAssociatedObject(view, AudioAppliedPositionKey, nil, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
    }
}

static void FQXAudioCenterButtonArt(UIButton *button, BOOL active) {
    if (!button) return;
    UIImageView *art = button.imageView;
    UILabel *title = button.titleLabel;
    CGFloat center = CGRectGetMidX(button.bounds);
    FQXAudioPlaceView(art, CGPointMake(center, FQXAudioStockCenter(art).y), active && art.superview == button);
    FQXAudioPlaceView(title, CGPointMake(center, title.center.y), active && title.superview == button);
}

static void FQXAudioCenterBackGlyph(UIButton *button) {
    if (!button) return;
    UIVisualEffectView *surface = objc_getAssociatedObject(button, AudioGlassSurfaceKey);
    CAShapeLayer *glyph = objc_getAssociatedObject(button, AudioBackGlyphKey);
    if (surface && !glyph) {
        glyph = [CAShapeLayer layer];
        glyph.fillColor = nil;
        glyph.lineWidth = 1.5;
        glyph.lineCap = kCALineCapRound;
        glyph.lineJoin = kCALineJoinRound;
        UIBezierPath *chevron = [UIBezierPath bezierPath];
        [chevron moveToPoint:CGPointMake(1.5, 5.0)];
        [chevron addLineToPoint:CGPointMake(9.0, 12.5)];
        [chevron addLineToPoint:CGPointMake(16.5, 5.0)];
        glyph.path = chevron.CGPath;
        [button.layer addSublayer:glyph];
        objc_setAssociatedObject(button, AudioBackGlyphKey, glyph, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
    }
    FQXAudioSetHiddenTracked(button.imageView, surface != nil);
    if (!glyph) return;
    [CATransaction begin];
    [CATransaction setDisableActions:YES];
    glyph.hidden = surface == nil;
    if (surface) {
        CGPoint center = [surface convertPoint:CGPointMake(CGRectGetMidX(surface.bounds),
                                                          CGRectGetMidY(surface.bounds)) toView:button];
        glyph.frame = CGRectMake(center.x - 9.0, center.y - 8.75, 18.0, 18.0);
        UIView *nav = button.superview;
        if ([nav isKindOfClass:NSClassFromString(@"SSAudioPageBackView")]) nav = nav.superview;
        UIColor *ink = FQXObjGet(nav, "themeTintColor");
        glyph.strokeColor = (ink ?: UIColor.whiteColor).CGColor;
    }
    [CATransaction commit];
}

static void FQXAudioSetControlInk(UILabel *label, BOOL active) {
    if (![label isKindOfClass:UILabel.class]) return;
    UIColor *stock = objc_getAssociatedObject(label, AudioLabelColorKey);
    UIColor *ink = [UIColor colorWithWhite:0.97 alpha:1.0];
    if (active && ![label.textColor isEqual:ink]) {
        objc_setAssociatedObject(label, AudioLabelColorKey, label.textColor, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
        label.textColor = ink;
    } else if (!active && stock) {
        if ([label.textColor isEqual:ink]) label.textColor = stock;
        objc_setAssociatedObject(label, AudioLabelColorKey, nil, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
    }
}

static void FQXAudioClearCardShadow(UIView *view, BOOL active) {
    if (![view isKindOfClass:UIView.class]) return;
    CALayer *layer = view.layer;
    NSNumber *stock = objc_getAssociatedObject(layer, AudioShadowOpacityKey);
    if (active && layer.shadowOpacity > 0) {
        objc_setAssociatedObject(layer, AudioShadowOpacityKey, @(layer.shadowOpacity), OBJC_ASSOCIATION_RETAIN_NONATOMIC);
        layer.shadowOpacity = 0;
    } else if (!active && stock) {
        if (layer.shadowOpacity == 0) layer.shadowOpacity = stock.floatValue;
        objc_setAssociatedObject(layer, AudioShadowOpacityKey, nil, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
    }
}

static void FQXAudioMenuCellIcons(UICollectionViewCell *cell) {
    if (![cell isKindOfClass:NSClassFromString(@"SSNewAudioPlayMenuViewCell")]) return;
    BOOL iconsOnly = [NSUserDefaults.standardUserDefaults boolForKey:AudioIconsOnlyPrefKey];
    UILabel *label = FQXObjGet(cell, "nameLabel");
    UIView *icon = FQXObjGet(cell, "iconView");
    FQXAudioSetControlInk(label, FQXAudioGlassEnabled());
    FQXAudioSetHiddenTracked(label, iconsOnly);
    UIView *parent = icon.superview;
    if (parent) {
        CGPoint center = CGPointMake(CGRectGetMidX(cell.contentView.bounds), CGRectGetMidY(cell.contentView.bounds));
        FQXAudioPlaceView(icon, [cell.contentView convertPoint:center toView:parent], iconsOnly);
    }
}

static UIVisualEffectView *FQXInstallAudioSurfaceFull(UIView *host,
                                                      UIView *mountParent,
                                                      UIView *belowSibling,
                                                      CGRect frame,
                                                      NSInteger glassStyle,
                                                      CGFloat radius,
                                                      BOOL continuousCard,
                                                      BOOL interactive,
                                                      UIColor *tintColor,
                                                      BOOL active) {
    if (!host) return nil;
    UIVisualEffectView *surface = objc_getAssociatedObject(host, AudioGlassSurfaceKey);
    if (!active || !FQXAudioGlassEnabled() || !mountParent ||
        CGRectGetWidth(frame) <= 2.0 || CGRectGetHeight(frame) <= 2.0) {
        if (surface) {
            [surface removeFromSuperview];
            objc_setAssociatedObject(host, AudioGlassSurfaceKey, nil, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
        }
        return nil;
    }
    if (!surface) {
        UIColor *glassTint = tintColor ?: [UIColor colorWithWhite:0.10 alpha:interactive ? 0.16 : 0.22];
        surface = FQXNewGlassViewFull(glassStyle, interactive, radius, continuousCard, glassTint);
        if (!surface) return nil;
        objc_setAssociatedObject(host, AudioGlassSurfaceKey, surface, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
    }

    [CATransaction begin];
    [CATransaction setDisableActions:YES];
    if (!CGRectEqualToRect(surface.frame, frame)) {
        surface.frame = frame;
    }
    // The host's controls use white artwork, including in the light app mode.
    // Keep the backing local to each glass shape and limit cover highlights.
    surface.overrideUserInterfaceStyle = UIUserInterfaceStyleDark;
    BOOL isCircle = (radius <= 0.0 && !continuousCard);
    CGFloat backingOpacity = isCircle
        ? (UIAccessibilityDarkerSystemColorsEnabled() ? 0.24 : 0.08)
        : (interactive
            ? (UIAccessibilityDarkerSystemColorsEnabled() ? 0.34 : 0.10)
            : (UIAccessibilityDarkerSystemColorsEnabled() ? 0.42 : 0.24));
    UIColor *backing = [UIColor colorWithWhite:0.025 alpha:backingOpacity];
    if (![surface.contentView.backgroundColor isEqual:backing])
        surface.contentView.backgroundColor = backing;
    CGFloat halfSide = MIN(CGRectGetWidth(frame), CGRectGetHeight(frame)) * 0.5;
    surface.contentView.layer.cornerCurve = isCircle ? kCACornerCurveCircular : kCACornerCurveContinuous;
    surface.contentView.layer.cornerRadius = radius > 0 ? MIN(radius, halfSide) : halfSide;
    surface.contentView.clipsToBounds = YES;
    if (isCircle) {
        if (surface.maskView) surface.maskView = nil;
        if (surface.clipsToBounds) surface.clipsToBounds = NO;
    }
    if (belowSibling && belowSibling.superview == mountParent) {
        if (surface.superview != mountParent) {
            [mountParent insertSubview:surface belowSubview:belowSibling];
        }
    } else if (surface.superview != mountParent || mountParent.subviews.firstObject != surface) {
        [mountParent insertSubview:surface atIndex:0];
    }
    [CATransaction commit];
    FQXApplyBackdropBlur(surface, surface.contentView, nil, surface.bounds,
                         surface.contentView.layer.cornerRadius, YES, AudioButtonBlurPrefKey);
    return surface;
}

@interface FQXAudioButtonFeedback : NSObject
+ (void)wireControl:(UIControl *)control;
@end

@implementation FQXAudioButtonFeedback
+ (void)onDown:(UIControl *)sender {
    if (UIAccessibilityIsReduceMotionEnabled() || !FQXAudioGlassEnabled()) return;
    [UIView animateWithDuration:0.18
                          delay:0.0
         usingSpringWithDamping:0.72
          initialSpringVelocity:0.0
                        options:UIViewAnimationOptionBeginFromCurrentState | UIViewAnimationOptionAllowUserInteraction
                     animations:^{
        sender.transform = CGAffineTransformMakeScale(0.92, 0.92);
    } completion:nil];
}
+ (void)onUp:(UIControl *)sender {
    [UIView animateWithDuration:0.26
                          delay:0.0
         usingSpringWithDamping:0.68
          initialSpringVelocity:0.0
                        options:UIViewAnimationOptionBeginFromCurrentState | UIViewAnimationOptionAllowUserInteraction
                     animations:^{
        sender.transform = CGAffineTransformIdentity;
    } completion:nil];
}
+ (void)wireControl:(UIControl *)control {
    if (![control isKindOfClass:UIControl.class]) return;
    if (objc_getAssociatedObject(control, AudioPressWiredKey)) return;
    [control addTarget:self action:@selector(onDown:) forControlEvents:UIControlEventTouchDown];
    [control addTarget:self action:@selector(onUp:)
      forControlEvents:UIControlEventTouchUpInside | UIControlEventTouchUpOutside | UIControlEventTouchCancel | UIControlEventTouchDragExit];
    objc_setAssociatedObject(control, AudioPressWiredKey, @YES, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}
@end

static void FQXStyleAudioNavCircle(UIView *nav, UIView *mountAbove, UIButton *button, BOOL enabled) {
    if (![button isKindOfClass:UIButton.class]) return;
    BOOL visible = enabled && !button.hidden && button.alpha > 0.01 && [button isDescendantOfView:nav];
    CGPoint center = [button.superview convertPoint:button.center toView:nav];
    CGFloat diameter = AudioNavigationButtonDiameter;
    CGRect square = CGRectMake(round(center.x - diameter * 0.5), round(center.y - diameter * 0.5), diameter, diameter);
    FQXAudioClearBackground(button, visible);
    FQXInstallAudioSurfaceFull(button, nav, mountAbove, square, 0, 0.0, NO, YES, nil, visible);
    if (visible) [FQXAudioButtonFeedback wireControl:button];
}

static void FQXStyleAudioCircleButton(UIButton *btn,
                                      CGFloat diameter,
                                      BOOL enabled) {
    if (![btn isKindOfClass:UIButton.class]) return;
    BOOL visible = enabled && !btn.hidden && btn.alpha > 0.01 && btn.superview != nil &&
                   CGRectGetWidth(btn.bounds) > 1.0 && CGRectGetHeight(btn.bounds) > 1.0;
    FQXAudioSetUnclipped(btn, visible);
    FQXAudioClearBackground(btn, visible);
    CGRect b = btn.bounds;
    CGFloat side = round(diameter);
    CGRect frame = CGRectMake(round(CGRectGetMidX(b) - side * 0.5), round(CGRectGetMidY(b) - side * 0.5),
                              side, side);
    FQXInstallAudioSurfaceFull(btn, btn, nil, frame, 0, 0.0, NO, YES, nil, visible);
    if (visible) [FQXAudioButtonFeedback wireControl:btn];
}

static UIViewController *FQXAudioPageOwner(UIView *view) {
    for (UIResponder *owner = view.nextResponder; owner; owner = owner.nextResponder) {
        if ([owner isKindOfClass:NSClassFromString(@"SSNewAudioPlayViewController")]) return (UIViewController *)owner;
    }
    return nil;
}

static CGRect FQXAudioCardColumnBounds(UIView *view) {
    UIViewController *owner = FQXAudioPageOwner(view);
    if (owner) {
        UIView *container = FQXObjGet(owner, "toneView611");
        UIView *left = FQXObjGet(container, "toneListView");
        UIView *right = FQXObjGet(container, "readingView");
        if (left.window && left.window == view.window && right.window == view.window &&
            !left.hidden && !right.hidden) {
            CGRect columns = CGRectUnion([left convertRect:left.bounds toView:view],
                                        [right convertRect:right.bounds toView:view]);
            if (CGRectGetWidth(columns) > CGRectGetWidth(view.bounds) * 0.75) return columns;
        }
    }
    return CGRectInset(view.bounds, 12.0, 0.0);
}

static void FQXApplyAudioNavigationGlass(UIView *nav) {
    if (![nav isKindOfClass:UIView.class]) return;
    FQXTrackAudioView(nav);
    BOOL enabled = FQXAudioGlassEnabled();
    FQXAudioSetUnclipped(nav, enabled);

    UIButton *backBtn = FQXObjGet(nav, "backBtn");
    UIView *backView = FQXObjGet(nav, "backView");
    UIButton *moreBtn = FQXObjGet(nav, "moreBtn");
    UIButton *gameBtn = FQXObjGet(nav, "gameEntranceBtn");
    UIButton *shopBtn = FQXObjGet(nav, "shopEntranceBtn");

    CGFloat radius = AudioNavigationButtonDiameter * 0.5;
    CGFloat drop = 0;
    UIView *book = FQXObjGet(FQXAudioPageOwner(nav), "bookView");
    UIView *arrow = FQXObjGet(book, "bookNameArrowView");
    if (enabled && nav.window && arrow.window == nav.window && !arrow.hidden && !book.hidden &&
        moreBtn.superview == nav && !moreBtn.hidden) {
        CGFloat arrowY = [arrow convertPoint:CGPointMake(CGRectGetMidX(arrow.bounds), CGRectGetMidY(arrow.bounds)) toView:nav].y;
        CGFloat stockY = FQXAudioStockCenter(moreBtn).y;
        CGFloat top = CGRectGetMinY(nav.bounds) + radius;
        CGFloat target = MAX(top, arrowY - AudioBookArrowDiameter * 0.5 - radius - 10.0);
        drop = MIN(0, target - stockY);
    }
    BOOL backViewVisible = [backView isKindOfClass:UIView.class] && backView.superview == nav && !backView.hidden;
    CGRect columns = FQXAudioCardColumnBounds(nav);
    CGFloat left = CGRectGetMinX(columns), right = CGRectGetMaxX(columns);
    UIButton *close = FQXObjGet(backView, "closeButton");
    UIButton *backLast = FQXObjGet(backView, "backLastButton");
    BOOL dual = backLast.superview == backView && !backLast.hidden && CGRectGetWidth(backLast.bounds) > 8.0;
    if (backViewVisible && close.superview == backView) {
        CGFloat currentEdge = dual ? CGRectGetMinX(backView.frame)
            : [backView convertPoint:close.center toView:nav].x - AudioNavigationButtonDiameter * 0.5;
        FQXAudioPlaceView(backView, CGPointMake(backView.center.x + left - currentEdge,
                                               FQXAudioStockCenter(backView).y + drop), enabled);
    } else {
        FQXAudioPlaceView(backView, CGPointZero, NO);
    }
    FQXAudioPlaceView(backBtn, CGPointMake(left + radius, FQXAudioStockCenter(backBtn).y + drop),
                      enabled && !backViewVisible && backBtn.superview == nav);
    BOOL alignMore = enabled && moreBtn.superview == nav && !moreBtn.hidden;
    CGFloat trailingShift = alignMore ? right - radius - FQXAudioStockCenter(moreBtn).x : 0.0;
    UIButton *trailingButtons[] = {gameBtn, shopBtn};
    for (size_t i = 0; i < sizeof(trailingButtons) / sizeof(trailingButtons[0]); ++i) {
        UIButton *button = trailingButtons[i];
        if (!button) continue;
        CGPoint center = FQXAudioStockCenter(button);
        center.x += trailingShift;
        FQXAudioPlaceView(button, center, alignMore && button.superview == nav && !button.hidden);
    }
    FQXAudioPlaceView(moreBtn, CGPointMake(right - radius, FQXAudioStockCenter(moreBtn).y + drop), alignMore);
    FQXAudioCenterButtonArt(moreBtn, enabled);
    FQXStyleAudioNavCircle(nav, backBtn, backBtn, enabled && !backViewVisible);
    if (backViewVisible) FQXStyleAudioNavCircle(nav, backView, close, enabled && !dual);
    FQXAudioCenterBackGlyph(backBtn);
    FQXStyleAudioNavCircle(nav, moreBtn, moreBtn, enabled);
    FQXStyleAudioCircleButton(gameBtn, 36.0, enabled);
    FQXStyleAudioCircleButton(shopBtn, 36.0, enabled);
}

static void FQXApplyAudioBackViewGlass(UIView *backView) {
    if (![backView isKindOfClass:UIView.class]) return;
    FQXTrackAudioView(backView);
    BOOL enabled = FQXAudioGlassEnabled() && !backView.hidden;
    UIButton *closeBtn = FQXObjGet(backView, "closeButton");
    UIButton *backLastBtn = FQXObjGet(backView, "backLastButton");
    UIView *splitLine = FQXObjGet(backView, "splitLineView");

    BOOL dualButtons = [backLastBtn isKindOfClass:UIButton.class] && !backLastBtn.hidden &&
                       backLastBtn.superview == backView && CGRectGetWidth(backLastBtn.bounds) > 8.0;
    FQXAudioSetUnclipped(backView, enabled);
    FQXAudioClearBackground(backView, enabled);
    if ([splitLine isKindOfClass:UIView.class]) {
        splitLine.alpha = (enabled && dualButtons) ? 0.25 : (enabled ? 0.0 : 1.0);
    }
    if (dualButtons) {
        FQXStyleAudioCircleButton(closeBtn, AudioNavigationButtonDiameter, NO);
        CGRect pill = CGRectInset(backView.bounds, 0.0, MAX(0.0, (CGRectGetHeight(backView.bounds) - AudioNavigationButtonDiameter) * 0.5));
        FQXInstallAudioSurfaceFull(backView, backView, nil, pill, 0, 0.0, NO, YES, nil, enabled);
        if (enabled) {
            [FQXAudioButtonFeedback wireControl:closeBtn];
            [FQXAudioButtonFeedback wireControl:backLastBtn];
        }
    } else {
        FQXInstallAudioSurfaceFull(backView, backView, nil, CGRectZero, 0, 0.0, NO, YES, nil, NO);
        if ([backView.superview isKindOfClass:NSClassFromString(@"SSNewAudioPlayNavigationView")]) {
            FQXStyleAudioNavCircle(backView.superview, backView, closeBtn, enabled);
        } else {
            FQXStyleAudioCircleButton(closeBtn, AudioNavigationButtonDiameter, enabled);
        }
    }
    FQXAudioCenterBackGlyph(closeBtn);
}

static void FQXApplyAudioBookGlass(UIView *bookView) {
    FQXTrackAudioView(bookView);
    UIImageView *arrow = FQXObjGet(bookView, "bookNameArrowView");
    UIView *host = arrow.superview;
    if (!host) return;
    CGFloat diameter = AudioBookArrowDiameter;
    CGRect stock = arrow.frame;
    BOOL active = FQXAudioGlassEnabled() && !arrow.hidden && arrow.alpha > 0.01 &&
                  !CGRectIsEmpty(stock) && [arrow isDescendantOfView:bookView];
    FQXAudioSetUnclipped(host, active);
    FQXAudioSetUnclipped(bookView, active);
    CGRect circle = CGRectMake(round(CGRectGetMidX(stock) - diameter * 0.5),
                              round(CGRectGetMidY(stock) - diameter * 0.5), diameter, diameter);
    FQXInstallAudioSurfaceFull(arrow, host, arrow, circle, 0, 0.0, NO,
                               YES, [UIColor colorWithWhite:0.10 alpha:0.20], active);
}

// 图七 1号 / 图六 4号: SSNewAudioPlayMenuView — Clear refractive glass card (style = 1) with Apple-bezel 22pt continuous corners
static void FQXApplyAudioMenuGlass(UIView *menuView) {
    if (![menuView isKindOfClass:UIView.class]) return;
    FQXTrackAudioView(menuView);
    BOOL enabled = FQXAudioGlassEnabled() && !menuView.hidden && CGRectGetWidth(menuView.bounds) > 40.0;
    FQXAudioSetUnclipped(menuView, enabled);
    FQXAudioClearBackground(menuView, enabled);

    UICollectionView *cv = nil;
    for (UIView *sub in menuView.subviews) {
        if ([sub isKindOfClass:UICollectionView.class]) {
            cv = (UICollectionView *)sub;
            break;
        }
    }
    if (cv) {
        FQXAudioSetUnclipped(cv, enabled);
        FQXAudioClearBackground(cv, enabled);
        for (UICollectionViewCell *cell in cv.visibleCells) FQXAudioMenuCellIcons(cell);
    }
    CGRect b = menuView.bounds;
    CGFloat insetX = (menuView.frame.origin.x <= 2.0 && menuView.superview &&
                      CGRectGetWidth(b) >= CGRectGetWidth(menuView.superview.bounds) - 4.0) ? 12.0 : 0.0;
    CGRect barRect = CGRectMake(b.origin.x + insetX,
                                b.origin.y - 4.0,
                                MAX(0.0, b.size.width - insetX * 2.0),
                                b.size.height + 8.0);
    if (cv.superview == menuView) {
        CGRect frame = cv.frame;
        NSValue *applied = objc_getAssociatedObject(cv, AudioMenuAppliedFrameKey);
        NSValue *saved = objc_getAssociatedObject(cv, AudioMenuStockFrameKey);
        CGRect stock = applied && saved && CGRectEqualToRect(frame, applied.CGRectValue)
            ? saved.CGRectValue : frame;
        CGRect desired = stock;
        if (enabled && CGRectGetWidth(barRect) > 100.0) {
            desired.origin.x = CGRectGetMinX(barRect) + 10.0;
            desired.size.width = CGRectGetWidth(barRect) - 20.0;
        }
        if (!CGRectEqualToRect(frame, desired)) {
            cv.frame = desired;
            [cv.collectionViewLayout invalidateLayout];
        }
        if (!CGRectEqualToRect(desired, stock)) {
            if (!saved || !CGRectEqualToRect(stock, saved.CGRectValue))
                objc_setAssociatedObject(cv, AudioMenuStockFrameKey, [NSValue valueWithCGRect:stock], OBJC_ASSOCIATION_RETAIN_NONATOMIC);
            if (!applied || !CGRectEqualToRect(desired, applied.CGRectValue))
                objc_setAssociatedObject(cv, AudioMenuAppliedFrameKey, [NSValue valueWithCGRect:desired], OBJC_ASSOCIATION_RETAIN_NONATOMIC);
        } else if (applied) {
            objc_setAssociatedObject(cv, AudioMenuStockFrameKey, nil, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
            objc_setAssociatedObject(cv, AudioMenuAppliedFrameKey, nil, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
        }
    }
    FQXInstallAudioSurfaceFull(menuView, menuView, cv, barRect, 0, 22.0, YES, YES, nil, enabled);
}

static void FQXApplyAudioMenuCellPress(UICollectionViewCell *cell, BOOL pressed) {
    if (![cell isKindOfClass:UICollectionViewCell.class]) return;
    FQXTrackAudioView(cell);
    BOOL enabled = FQXAudioGlassEnabled();
    FQXAudioSetUnclipped(cell, enabled);
    FQXAudioSetUnclipped(cell.contentView, enabled);
    CGRect pill = CGRectInset(cell.contentView.bounds, 4.0, 0.0);
    UIColor *pressTint = [UIColor colorWithWhite:1.0 alpha:0.14];
    UIVisualEffectView *surface = FQXInstallAudioSurfaceFull(cell, cell.contentView, nil, pill, 1, 16.0, YES, YES, pressTint, enabled && pressed);
    if (surface) surface.alpha = pressed ? 1.0 : 0.0;
    if (!UIAccessibilityIsReduceMotionEnabled() && enabled) {
        [UIView animateWithDuration:pressed ? 0.16 : 0.24
                              delay:0.0
             usingSpringWithDamping:0.72
              initialSpringVelocity:0.0
                            options:UIViewAnimationOptionBeginFromCurrentState | UIViewAnimationOptionAllowUserInteraction
                         animations:^{
            cell.contentView.transform = pressed ? CGAffineTransformMakeScale(0.93, 0.93) : CGAffineTransformIdentity;
        } completion:nil];
    } else {
        cell.contentView.transform = CGAffineTransformIdentity;
    }
}

// 图六 5号 & 6号: SSNewAudioPlayControlView — Circular 54x54 目录 & 定时 matching circular transport buttons!
static void FQXApplyAudioControlGlass(UIView *control) {
    if (![control isKindOfClass:UIView.class]) return;
    FQXTrackAudioView(control);
    BOOL enabled = FQXAudioGlassEnabled() && !control.hidden;
    FQXAudioSetUnclipped(control, enabled);
    FQXAudioClearBackground(control, enabled);

    UIButton *menuBtn = FQXObjGet(control, "menuBtn");
    UIButton *timingBtn = FQXObjGet(control, "timingBtnBtn");
    UIView *pauseBg = FQXObjGet(control, "pauseBtnBgView");
    CGRect columns = FQXAudioCardColumnBounds(control);
    CGFloat centerY = pauseBg.superview == control ? pauseBg.center.y : CGRectGetMidY(control.bounds);
    FQXAudioPlaceView(menuBtn, CGPointMake(CGRectGetMinX(columns) + 27.0, centerY),
                      enabled && menuBtn.superview == control && !menuBtn.hidden);
    FQXAudioPlaceView(timingBtn, CGPointMake(CGRectGetMaxX(columns) - 27.0, centerY),
                      enabled && timingBtn.superview == control && !timingBtn.hidden);
    FQXAudioCenterButtonArt(menuBtn, enabled);
    FQXAudioCenterButtonArt(timingBtn, enabled);
    BOOL iconsOnly = [NSUserDefaults.standardUserDefaults boolForKey:AudioIconsOnlyPrefKey];
    UIButton *sideButtons[] = {menuBtn, timingBtn};
    for (size_t i = 0; i < sizeof(sideButtons) / sizeof(sideButtons[0]); ++i) {
        UIButton *button = sideButtons[i];
        if (!button) continue;
        FQXAudioSetControlInk(button.titleLabel, enabled);
        FQXAudioSetHiddenTracked(button.titleLabel, iconsOnly);
        if (iconsOnly)
            FQXAudioPlaceView(button.imageView, CGPointMake(CGRectGetMidX(button.bounds), CGRectGetMidY(button.bounds)), YES);
    }
    FQXStyleAudioCircleButton(menuBtn, 54.0, enabled);
    FQXStyleAudioCircleButton(timingBtn, 54.0, enabled);

    const char *bgKeys[] = {"preBtnBgView", "pauseBtnBgView", "nextBtnBgView"};
    const char *btnKeys[] = {"preBtn", "pauseBtn", "nextBtn"};
    for (size_t i = 0; i < sizeof(bgKeys) / sizeof(bgKeys[0]); ++i) {
        UIButton *button = FQXObjGet(control, btnKeys[i]);
        UIView *bgView = FQXObjGet(control, bgKeys[i]);
        if (![button isKindOfClass:UIButton.class]) continue;
        BOOL active = enabled && !button.hidden && button.alpha > 0.01 && CGRectGetWidth(button.bounds) > 10.0;
        CGSize size = bgView.superview ? bgView.bounds.size : button.bounds.size;
        CGFloat diameter = MIN(size.width, size.height);
        if (diameter < 10) diameter = MIN(CGRectGetWidth(button.bounds), CGRectGetHeight(button.bounds));
        FQXStyleAudioCircleButton(button, diameter, active);
        BOOL installed = objc_getAssociatedObject(button, AudioGlassSurfaceKey) != nil;
        // The native backplate is separate paint. Keep the host button and its artwork.
        if (bgView && bgView != button && ![button isDescendantOfView:bgView])
            FQXAudioSetHiddenTracked(bgView, installed);
    }
}

// 图六 7号: Borderless Apple-bezel continuous large-corner cards (24pt outer, 18pt inner) + circular > arrows
static void FQXApplyAudioToneCellGlass(UICollectionViewCell *cell) {
    if (![cell isKindOfClass:UICollectionViewCell.class]) return;
    FQXTrackAudioView(cell);
    BOOL enabled = FQXAudioGlassEnabled() && CGRectGetWidth(cell.contentView.bounds) > 16.0 &&
                   CGRectGetHeight(cell.contentView.bounds) > 16.0;
    FQXAudioSetUnclipped(cell, enabled);
    FQXAudioSetUnclipped(cell.contentView, enabled);
    FQXAudioClearBackground(cell, enabled);
    FQXAudioClearBackground(cell.contentView, enabled);
    FQXAudioSetHiddenTracked(cell.backgroundView, enabled);
    FQXAudioSetHiddenTracked(cell.selectedBackgroundView, enabled);
    UIView *edgeShadow = FQXObjGet(cell, "edgeShadowView");
    FQXAudioSetHiddenTracked(edgeShadow, enabled);
    FQXAudioClearCardShadow(cell, enabled);
    FQXAudioSetControlInk(FQXObjGet(cell, "titleLabel"), enabled);
    FQXAudioSetControlInk(FQXObjGet(cell, "detailLabel"), enabled);
    FQXAudioSetControlInk(FQXObjGet(cell, "tagLabel"), enabled);

    CGRect pill = CGRectInset(cell.contentView.bounds, 1.0, 1.0);
    FQXInstallAudioSurfaceFull(cell, cell.contentView, nil, pill, 0, 14.0, YES, YES, nil, enabled);
}

static void FQXApplyAudioOuterCardGlass(UIView *card) {
    if (![card isKindOfClass:UIView.class]) return;
    FQXTrackAudioView(card);
    BOOL enabled = FQXAudioGlassEnabled() && !card.hidden &&
                   CGRectGetWidth(card.bounds) > 24.0 && CGRectGetHeight(card.bounds) > 24.0;
    FQXAudioSetUnclipped(card, enabled);
    FQXAudioClearBackground(card, enabled);
    FQXAudioClearCardShadow(card, enabled);
    FQXAudioSetControlInk(FQXObjGet(card, "titleLabel"), enabled);
    UIVisualEffectView *surface = FQXInstallAudioSurfaceFull(card, card, nil, card.bounds, 0, 24.0, YES, YES, nil, enabled);
    surface.clipsToBounds = YES;
    surface.layer.cornerCurve = kCACornerCurveContinuous;
    surface.layer.cornerRadius = 24.0;
}

static void FQXApplyAudioToneListGlass(UIView *toneList) {
    if (![toneList isKindOfClass:UIView.class]) return;
    FQXApplyAudioOuterCardGlass(toneList);
    BOOL enabled = FQXAudioGlassEnabled() && !toneList.hidden;
    CGFloat cardW = CGRectGetWidth(toneList.bounds);

    // Circular Liquid Glass button on `音色设置 >` arrow (`moreButton`), pulled inward
    // so the 26pt lens keeps a clean 12pt margin from the right edge of the outer card.
    UIButton *moreBtn = FQXObjGet(toneList, "moreButton");
    if ([moreBtn isKindOfClass:UIButton.class]) {
        CGFloat d = 26.0;
        if (moreBtn.superview == toneList && cardW > 80.0) {
            CGPoint stock = FQXAudioStockCenter(moreBtn);
            CGFloat maxCenterX = cardW - 12.0 - d * 0.5;
            CGPoint desired = CGPointMake(MIN(stock.x, maxCenterX), stock.y);
            FQXAudioPlaceView(moreBtn, desired, enabled);
        }
        FQXStyleAudioCircleButton(moreBtn, d, enabled);
    }

    UICollectionView *cv = FQXObjGet(toneList, "toneListView");
    if ([cv isKindOfClass:UICollectionView.class]) {
        FQXAudioClearBackground(cv, enabled);
        // Preserve the host flow layout's exact contentInset: adding extra left contentInset
        // shifted both tone cells 8pt right and clipped the second card ("配乐版") and its
        // top-right "多角色" badge against toneListView's right boundary.
        NSValue *saved = objc_getAssociatedObject(cv, AudioToneStockInsetKey);
        if (saved) {
            UIEdgeInsets stockInset = saved.UIEdgeInsetsValue;
            if (!UIEdgeInsetsEqualToEdgeInsets(cv.contentInset, stockInset)) {
                cv.contentInset = stockInset;
            }
            objc_setAssociatedObject(cv, AudioToneStockInsetKey, nil, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
        }
        for (UICollectionViewCell *cell in cv.visibleCells) {
            FQXApplyAudioToneCellGlass(cell);
        }
    }
}

static void FQXApplyAudioReadingGuideGlass(UIView *guide) {
    if (![guide isKindOfClass:UIView.class]) return;
    FQXApplyAudioOuterCardGlass(guide);
    BOOL enabled = FQXAudioGlassEnabled() && !guide.hidden;
    FQXAudioSetControlInk(FQXObjGet(guide, "chapterTitleLabel"), enabled);

    // Circular Liquid Glass pill behind `边听边读 >` arrow (`indicatorImageView`), pulled inward
    // so the 26pt lens keeps a clean 12pt margin from the right edge of the outer card.
    UIView *arrow = FQXObjGet(guide, "indicatorImageView");
    if ([arrow isKindOfClass:UIView.class] && arrow.superview != nil) {
        CGFloat d = 26.0;
        CGFloat cardW = CGRectGetWidth(guide.bounds);
        if (arrow.superview == guide && cardW > 60.0) {
            CGPoint stock = FQXAudioStockCenter(arrow);
            CGFloat maxCenterX = cardW - 12.0 - d * 0.5;
            CGPoint desired = CGPointMake(MIN(stock.x, maxCenterX), stock.y);
            FQXAudioPlaceView(arrow, desired, enabled);
        }
        BOOL active = enabled && !arrow.hidden && arrow.alpha > 0.01 && CGRectGetWidth(arrow.bounds) > 1.0;
        CGRect af = arrow.frame;
        CGRect circle = CGRectMake(round(CGRectGetMidX(af) - d * 0.5), round(CGRectGetMidY(af) - d * 0.5), d, d);
        FQXInstallAudioSurfaceFull(arrow, arrow.superview, arrow, circle, 0, 0.0, NO, YES, nil, active);
    }
}

static void FQXApplyAudioToneView611Glass(UIView *container) {
    if (![container isKindOfClass:UIView.class]) return;
    FQXTrackAudioView(container);
    BOOL enabled = FQXAudioGlassEnabled();
    FQXAudioSetUnclipped(container, enabled);
    FQXAudioClearBackground(container, enabled);
    FQXAudioClearCardShadow(container, enabled);
    UIView *toneList = FQXObjGet(container, "toneListView");
    UIView *readingView = FQXObjGet(container, "readingView");
    if (toneList) FQXApplyAudioToneListGlass(toneList);
    if (readingView) FQXApplyAudioReadingGuideGlass(readingView);
}

static void FQXAudioHideGradient(CALayer *layer, BOOL hide) {
    if (![layer isKindOfClass:CAGradientLayer.class]) return;
    NSNumber *stock = objc_getAssociatedObject(layer, AudioGradientHiddenKey);
    if (!hide && !stock) return;
    [CATransaction begin];
    [CATransaction setDisableActions:YES];
    if (hide) {
        if (!stock) objc_setAssociatedObject(layer, AudioGradientHiddenKey, @(layer.hidden), OBJC_ASSOCIATION_RETAIN_NONATOMIC);
        layer.hidden = YES;
    } else {
        layer.hidden = stock.boolValue;
        objc_setAssociatedObject(layer, AudioGradientHiddenKey, nil, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
    }
    [CATransaction commit];
}

// 图七 2号 & 3号: Seamless Audio Background (remove bottom dark shadow bands)
static void FQXAudioPinBackdrop(UIView *background, UIImageView *art, BOOL fill) {
    if (art.superview != background) return;
    NSArray *pinned = objc_getAssociatedObject(art, AudioBackdropPinnedKey);
    if (fill && !pinned) {
        NSMutableArray *stock = [NSMutableArray array];
        for (NSLayoutConstraint *constraint in background.constraints) {
            if ((constraint.firstItem == art && constraint.secondItem == background) ||
                (constraint.firstItem == background && constraint.secondItem == art))
                [stock addObject:constraint];
        }
        for (NSLayoutConstraint *constraint in art.constraints) {
            if (constraint.firstItem == art && !constraint.secondItem) [stock addObject:constraint];
        }
        objc_setAssociatedObject(art, AudioBackdropStockLayoutKey, @(art.translatesAutoresizingMaskIntoConstraints),
                                 OBJC_ASSOCIATION_RETAIN_NONATOMIC);
        art.translatesAutoresizingMaskIntoConstraints = NO;
        [NSLayoutConstraint deactivateConstraints:stock];
        pinned = @[[art.leadingAnchor constraintEqualToAnchor:background.leadingAnchor],
                   [art.trailingAnchor constraintEqualToAnchor:background.trailingAnchor],
                   [art.topAnchor constraintEqualToAnchor:background.topAnchor],
                   [art.bottomAnchor constraintEqualToAnchor:background.bottomAnchor]];
        [NSLayoutConstraint activateConstraints:pinned];
        objc_setAssociatedObject(art, AudioBackdropStockConstraintsKey, stock, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
        objc_setAssociatedObject(art, AudioBackdropPinnedKey, pinned, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
    } else if (!fill && pinned) {
        [NSLayoutConstraint deactivateConstraints:pinned];
        [NSLayoutConstraint activateConstraints:objc_getAssociatedObject(art, AudioBackdropStockConstraintsKey)];
        NSNumber *layout = objc_getAssociatedObject(art, AudioBackdropStockLayoutKey);
        art.translatesAutoresizingMaskIntoConstraints = layout.boolValue;
        objc_setAssociatedObject(art, AudioBackdropStockConstraintsKey, nil, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
        objc_setAssociatedObject(art, AudioBackdropStockLayoutKey, nil, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
        objc_setAssociatedObject(art, AudioBackdropPinnedKey, nil, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
    }
}

static void FQXApplyAudioBackgroundSeamless(UIView *bgView) {
    if (![bgView isKindOfClass:UIView.class]) return;
    FQXTrackAudioView(bgView);
    NSNumber *recsVal = [NSUserDefaults.standardUserDefaults objectForKey:AudioRecsPrefKey];
    BOOL recsHidden = [recsVal isKindOfClass:NSNumber.class] && !recsVal.boolValue;
    BOOL seamless = FQXAudioGlassEnabled() || recsHidden;

    FQXAudioHideGradient(FQXObjGet(bgView, "bottomBgMaskGradientLayer"), seamless);
    UIView *bottomBgView = FQXObjGet(bgView, "bottomBgView");
    FQXAudioSetHiddenTracked(bottomBgView, seamless);

    UIView *bottomView = FQXObjGet(bgView, "bottomView");
    UIImageView *pixelBlur = FQXObjGet(bgView, "pixelBlurBgImageView");
    BOOL hasBlurArt = [pixelBlur isKindOfClass:UIImageView.class] && !pixelBlur.hidden && pixelBlur.alpha > 0.05;
    FQXAudioPinBackdrop(bgView, pixelBlur, seamless && hasBlurArt);
    if ([bottomView isKindOfClass:UIView.class]) {
        if (seamless && hasBlurArt) {
            FQXAudioSetHiddenTracked(bottomView, YES);
        } else {
            FQXAudioSetHiddenTracked(bottomView, NO);
            FQXAudioClearBackground(bottomView, seamless);
        }
    }
}

// 图七 1号: Extend Novel Lyrics Underneath 1号 Clear Glass Bar & Keep Mask Opaque Behind 1号
static void FQXAdjustCaptionScrollInsetsInTree(UIView *root, CGFloat bottomInset, NSInteger depth) {
    if (![root isKindOfClass:UIView.class] || depth > 5) return;
    if ([root isKindOfClass:UIScrollView.class] && ![root isKindOfClass:UICollectionView.class]) {
        UIScrollView *sv = (UIScrollView *)root;
        if (CGRectGetHeight(sv.bounds) > 120.0) {
            UIEdgeInsets ins = sv.contentInset;
            if (fabs(ins.bottom - bottomInset) > 1.0) {
                ins.bottom = bottomInset;
                sv.contentInset = ins;
            }
        }
    } else if ([root isKindOfClass:UITableView.class] || [root isKindOfClass:UICollectionView.class]) {
        UIScrollView *sv = (UIScrollView *)root;
        if (CGRectGetHeight(sv.bounds) > 120.0 && sv.alwaysBounceVertical) {
            UIEdgeInsets ins = sv.contentInset;
            if (ins.bottom < bottomInset) {
                ins.bottom = bottomInset;
                sv.contentInset = ins;
            }
        }
    }
    for (UIView *sub in root.subviews) {
        FQXAdjustCaptionScrollInsetsInTree(sub, bottomInset, depth + 1);
    }
}

static void FQXUpdateTTSReaderCaptionMask(id ttsReaderVC) {
    if (!ttsReaderVC) return;
    UIView *readerContainer = FQXObjGet(ttsReaderVC, "readerContainerView");
    CALayer *rawMask = FQXObjGet(ttsReaderVC, "captionMaskLayer");
    if (![readerContainer isKindOfClass:UIView.class] || ![rawMask isKindOfClass:CAGradientLayer.class]) return;
    if (!FQXAudioGlassEnabled()) return;
    CAGradientLayer *maskLayer = (CAGradientLayer *)rawMask;
    CGRect bounds = readerContainer.bounds;
    if (CGRectGetHeight(bounds) <= 40.0) return;
    id clearCG = (id)[UIColor colorWithWhite:0.0 alpha:0.0].CGColor;
    id opaqueCG = (id)[UIColor colorWithWhite:0.0 alpha:1.0].CGColor;
    [CATransaction begin];
    [CATransaction setDisableActions:YES];
    maskLayer.frame = bounds;
    maskLayer.colors = @[clearCG, opaqueCG, opaqueCG, clearCG];
    // Keep text 100% opaque all the way behind 1号 (up to 93% of extended height) for crisp refraction!
    maskLayer.locations = @[@0.0, @0.06, @0.93, @1.0];
    [CATransaction commit];
}

static void FQXAudioSetBottomEdgeHidden(UIScrollView *scroll, BOOL hide) {
    if (![scroll isKindOfClass:UIScrollView.class]) return;
    id edge = FQXObjGet(scroll, "bottomEdgeEffect");
    SEL setHidden = @selector(setHidden:);
    if (![edge respondsToSelector:setHidden]) return;
    NSNumber *stock = objc_getAssociatedObject(edge, AudioEdgeHiddenKey);
    if (hide && !FQXBoolGet(edge, "isHidden", YES)) {
        if (!stock) objc_setAssociatedObject(edge, AudioEdgeHiddenKey, @NO, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
        ((void (*)(id, SEL, BOOL))objc_msgSend)(edge, setHidden, YES);
    } else if (!hide && stock) {
        ((void (*)(id, SEL, BOOL))objc_msgSend)(edge, setHidden, stock.boolValue);
        objc_setAssociatedObject(edge, AudioEdgeHiddenKey, nil, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
    }
}

static void FQXApplyAudioPlayControllerRefractionAndSeamless(UIViewController *vc) {
    if (![vc isKindOfClass:UIViewController.class] || !vc.isViewLoaded) return;
    [FQXAudioPlayVCs() addObject:vc];

    BOOL glassOn = FQXAudioGlassEnabled();
    BOOL expanded = FQXBoolGet(vc, "isReaderVCExpanded", NO);
    BOOL active = glassOn && !expanded;

    // 1. Hide opaque brown bottom masks that blocked novel text behind 1号 and created seams at 2号/3号.
    UIView *bottomMask = FQXObjGet(vc, "bottomMaskView");
    UIView *bottomHalfMask = FQXObjGet(vc, "bottomMaskViewHalfBgView");
    FQXAudioSetHiddenTracked(bottomMask, active);
    FQXAudioSetHiddenTracked(bottomHalfMask, active);
    FQXAudioHideGradient(FQXObjGet(vc, "bottomMaskGradientLayer"), active);

    UIView *slideContainer = FQXObjGet(vc, "bottomSlideContainerView");
    UIView *pinnedContainer = FQXObjGet(vc, "pinnedControlContainerView");
    FQXAudioClearBackground(slideContainer, glassOn);
    FQXAudioClearBackground(pinnedContainer, glassOn);
    FQXAudioHideGradient(FQXObjGet(pinnedContainer, "maskGradientLayer"), active);
    FQXAudioClearCardShadow(slideContainer, active);
    FQXAudioClearCardShadow(pinnedContainer, active);
    UIScrollView *contentScroll = FQXObjGet(vc, "contentScrollView");
    UIScrollView *nestedScroll = FQXObjGet(vc, "nestedContainerScrollView");
    FQXAudioSetBottomEdgeHidden(contentScroll, active);
    FQXAudioSetBottomEdgeHidden(nestedScroll, active);
    FQXAudioClearBackground(contentScroll, active);
    FQXAudioClearBackground(nestedScroll, active);
    FQXAudioClearBackground(FQXObjGet(nestedScroll, "contentView"), active);

    UIView *bgView = FQXObjGet(vc, "bgView");
    if ([bgView isKindOfClass:UIView.class]) {
        FQXApplyAudioBackgroundSeamless(bgView);
    }

    // 2. Extend _pageContainerView downward behind 1号 (_menuView) so lyrics scroll directly under 1号's Clear glass!
    UIView *pageContainer = FQXObjGet(vc, "pageContainerView");
    UIView *menuView = FQXObjGet(vc, "menuView");
    if (active && [pageContainer isKindOfClass:UIView.class] && [menuView isKindOfClass:UIView.class] &&
        pageContainer.superview != nil && menuView.superview != nil && !menuView.hidden) {
        CGRect menuInParent = [menuView.superview convertRect:menuView.frame toView:pageContainer.superview];
        CGRect pf = pageContainer.frame;
        CGFloat desiredBottom = CGRectGetMaxY(menuInParent) + 4.0;
        CGFloat extra = desiredBottom - CGRectGetMaxY(pf);
        if (extra > 2.0 && extra < 140.0) {
            pf.size.height += extra;
            pageContainer.frame = pf;
        }
        FQXAudioSetUnclipped(pageContainer, NO);
        CGFloat insetBottom = MAX(56.0, CGRectGetHeight(menuInParent) + 14.0);

        UIViewController *ttsReaderVC = FQXObjGet(vc, "ttsReaderPageViewController");
        if ([ttsReaderVC isKindOfClass:UIViewController.class] && ttsReaderVC.isViewLoaded) {
            UIView *rv = ttsReaderVC.view;
            if (rv.superview == pageContainer && !CGRectEqualToRect(rv.frame, pageContainer.bounds)) {
                rv.frame = pageContainer.bounds;
            }
            UIView *rc = FQXObjGet(ttsReaderVC, "readerContainerView");
            if ([rc isKindOfClass:UIView.class] && rc.superview == rv) {
                CGRect rcf = rc.frame;
                CGFloat targetH = CGRectGetHeight(rv.bounds) - rcf.origin.y;
                if (targetH > CGRectGetHeight(rcf) + 1.0) {
                    rcf.size.height = targetH;
                    rc.frame = rcf;
                }
                FQXAdjustCaptionScrollInsetsInTree(rc, insetBottom, 0);
            }
            FQXUpdateTTSReaderCaptionMask(ttsReaderVC);
        }

        UIViewController *ttsPageVC = FQXObjGet(vc, "ttsPageViewController");
        if ([ttsPageVC isKindOfClass:UIViewController.class] && ttsPageVC.isViewLoaded) {
            UIView *tv = ttsPageVC.view;
            if (tv.superview == pageContainer && !CGRectEqualToRect(tv.frame, pageContainer.bounds)) {
                tv.frame = pageContainer.bounds;
            }
            FQXAdjustCaptionScrollInsetsInTree(tv, insetBottom, 0);
        }

        UIView *captionView = FQXObjGet(vc, "ttsCaptionView");
        if ([captionView isKindOfClass:UIView.class] && captionView.superview == pageContainer) {
            captionView.frame = pageContainer.bounds;
            FQXAdjustCaptionScrollInsetsInTree(captionView, insetBottom, 0);
        }

        // Ensure menuView (1号) stays ordered above pageContainerView so touches & Clear glass refraction work cleanly.
        if (menuView.superview == pageContainer.superview) {
            [pageContainer.superview bringSubviewToFront:menuView];
            if (pinnedContainer.superview == pageContainer.superview) {
                [pageContainer.superview bringSubviewToFront:pinnedContainer];
            }
            if (slideContainer.superview == pageContainer.superview) {
                [pageContainer.superview bringSubviewToFront:slideContainer];
            }
        }
    }
}

static void FQXRefreshAllAudioGlass(void) {
    for (UIView *view in [FQXAudioGlassOwners() allObjects]) {
        NSString *clsName = NSStringFromClass(view.class);
        if ([clsName isEqualToString:@"SSNewAudioPlayNavigationView"]) FQXApplyAudioNavigationGlass(view);
        else if ([clsName isEqualToString:@"SSAudioPageBackView"]) FQXApplyAudioBackViewGlass(view);
        else if ([clsName isEqualToString:@"SSNewAudioPlayBookView"]) FQXApplyAudioBookGlass(view);
        else if ([clsName isEqualToString:@"SSNewAudioPlayMenuView"]) FQXApplyAudioMenuGlass(view);
        else if ([clsName isEqualToString:@"SSNewAudioPlayMenuViewCell"]) FQXApplyAudioMenuCellPress((UICollectionViewCell *)view, NO);
        else if ([clsName isEqualToString:@"SSNewAudioPlayControlView"]) FQXApplyAudioControlGlass(view);
        else if ([clsName isEqualToString:@"SSAudioPlayToneView611"]) FQXApplyAudioToneView611Glass(view);
        else if ([clsName isEqualToString:@"SSAudioPlayToneListView"]) FQXApplyAudioToneListGlass(view);
        else if ([clsName isEqualToString:@"SSAudioReadingGuideView"] ||
                 [clsName isEqualToString:@"SSAudioV4ReadingGuideView"]) FQXApplyAudioReadingGuideGlass(view);
        else if ([clsName isEqualToString:@"SSAudioPlayToneCell"]) FQXApplyAudioToneCellGlass((UICollectionViewCell *)view);
        else if ([clsName isEqualToString:@"SSNewAudioPlayBackgroundView"]) FQXApplyAudioBackgroundSeamless(view);
        [view setNeedsLayout];
    }
    for (UIViewController *vc in [FQXAudioPlayVCs() allObjects]) {
        SEL layoutSel = NSSelectorFromString(@"layoutContentView");
        if ([vc respondsToSelector:layoutSel]) {
            Method m = class_getInstanceMethod(object_getClass(vc), layoutSel);
            if (m && strcmp(method_getTypeEncoding(m), "v16@0:8") == 0) {
                ((void (*)(id, SEL))objc_msgSend)(vc, layoutSel);
                continue;
            }
        }
        FQXApplyAudioPlayControllerRefractionAndSeamless(vc);
    }
}

// Audio Hook Functions
static void (*OrigAudioNavLayout)(id, SEL);
static void HookAudioNavLayout(UIView *self, SEL _cmd) {
    if (OrigAudioNavLayout) OrigAudioNavLayout(self, _cmd);
    FQXApplyAudioNavigationGlass(self);
}
static void (*OrigAudioNavSetTint)(id, SEL, id);
static void HookAudioNavSetTint(UIView *self, SEL _cmd, id color) {
    if (OrigAudioNavSetTint) OrigAudioNavSetTint(self, _cmd, color);
    FQXApplyAudioNavigationGlass(self);
}

static void (*OrigAudioBackLayout)(id, SEL);
static void HookAudioBackLayout(UIView *self, SEL _cmd) {
    if (OrigAudioBackLayout) OrigAudioBackLayout(self, _cmd);
    FQXApplyAudioBackViewGlass(self);
}
static void (*OrigAudioBackAdjust)(id, SEL);
static void HookAudioBackAdjust(UIView *self, SEL _cmd) {
    if (OrigAudioBackAdjust) OrigAudioBackAdjust(self, _cmd);
    FQXApplyAudioBackViewGlass(self);
}

static void (*OrigAudioBookLayout)(id, SEL);
static void HookAudioBookLayout(UIView *self, SEL _cmd) {
    if (OrigAudioBookLayout) OrigAudioBookLayout(self, _cmd);
    FQXApplyAudioBookGlass(self);
}
static void (*OrigAudioBookDetailEntrance)(id, SEL, BOOL);
static void HookAudioBookDetailEntrance(UIView *self, SEL cmd, BOOL show) {
    OrigAudioBookDetailEntrance(self, cmd, show);
    FQXApplyAudioBookGlass(self);
}
static void (*OrigAudioBookClick)(id, SEL, BOOL);
static void HookAudioBookClick(UIView *self, SEL cmd, BOOL enabled) {
    OrigAudioBookClick(self, cmd, enabled);
    FQXApplyAudioBookGlass(self);
}
static void (*OrigAudioBookTheme)(id, SEL, id);
static void HookAudioBookTheme(UIView *self, SEL _cmd, id colors) {
    if (OrigAudioBookTheme) OrigAudioBookTheme(self, _cmd, colors);
    FQXApplyAudioBookGlass(self);
}

static void (*OrigAudioMenuLayout)(id, SEL);
static void HookAudioMenuLayout(UIView *self, SEL _cmd) {
    if (OrigAudioMenuLayout) OrigAudioMenuLayout(self, _cmd);
    FQXApplyAudioMenuGlass(self);
}

static void (*OrigAudioMenuCellLayout)(id, SEL);
static void HookAudioMenuCellLayout(UICollectionViewCell *self, SEL _cmd) {
    if (OrigAudioMenuCellLayout) OrigAudioMenuCellLayout(self, _cmd);
    FQXTrackAudioView(self);
    FQXAudioMenuCellIcons(self);
}
static void (*OrigAudioMenuCellBegan)(id, SEL, id, id);
static void HookAudioMenuCellBegan(UICollectionViewCell *self, SEL _cmd, id touches, id event) {
    if (OrigAudioMenuCellBegan) OrigAudioMenuCellBegan(self, _cmd, touches, event);
    FQXApplyAudioMenuCellPress(self, YES);
}
static void (*OrigAudioMenuCellEnded)(id, SEL, id, id);
static void HookAudioMenuCellEnded(UICollectionViewCell *self, SEL _cmd, id touches, id event) {
    if (OrigAudioMenuCellEnded) OrigAudioMenuCellEnded(self, _cmd, touches, event);
    FQXApplyAudioMenuCellPress(self, NO);
}
static void (*OrigAudioMenuCellCancelled)(id, SEL, id, id);
static void HookAudioMenuCellCancelled(UICollectionViewCell *self, SEL _cmd, id touches, id event) {
    if (OrigAudioMenuCellCancelled) OrigAudioMenuCellCancelled(self, _cmd, touches, event);
    FQXApplyAudioMenuCellPress(self, NO);
}

static void (*OrigAudioControlLayout)(id, SEL);
static void HookAudioControlLayout(UIView *self, SEL _cmd) {
    if (OrigAudioControlLayout) OrigAudioControlLayout(self, _cmd);
    FQXApplyAudioControlGlass(self);
}
static void (*OrigAudioControlSetTint)(id, SEL, id);
static void HookAudioControlSetTint(UIView *self, SEL _cmd, id color) {
    if (OrigAudioControlSetTint) OrigAudioControlSetTint(self, _cmd, color);
    FQXApplyAudioControlGlass(self);
}

static void (*OrigToneView611Layout)(id, SEL);
static void HookToneView611Layout(UIView *self, SEL _cmd) {
    if (OrigToneView611Layout) OrigToneView611Layout(self, _cmd);
    FQXApplyAudioToneView611Glass(self);
}
static void (*OrigToneView611Adjust)(id, SEL);
static void HookToneView611Adjust(UIView *self, SEL _cmd) {
    if (OrigToneView611Adjust) OrigToneView611Adjust(self, _cmd);
    FQXApplyAudioToneView611Glass(self);
}

static void (*OrigToneListLayout)(id, SEL);
static void HookToneListLayout(UIView *self, SEL _cmd) {
    if (OrigToneListLayout) OrigToneListLayout(self, _cmd);
    FQXApplyAudioToneListGlass(self);
}
static void (*OrigToneListAdjust)(id, SEL);
static void HookToneListAdjust(UIView *self, SEL _cmd) {
    if (OrigToneListAdjust) OrigToneListAdjust(self, _cmd);
    FQXApplyAudioToneListGlass(self);
}
static void (*OrigToneListSetBg)(id, SEL, id);
static void HookToneListSetBg(UIView *self, SEL _cmd, UIColor *color) {
    if (FQXAudioGlassEnabled() && ![objc_getAssociatedObject(self, AudioClearingBgKey) boolValue]) {
        if (color && ![color isEqual:UIColor.clearColor]) {
            objc_setAssociatedObject(self, AudioSavedBgKey, color, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
        }
        if (OrigToneListSetBg) OrigToneListSetBg(self, _cmd, UIColor.clearColor);
        return;
    }
    if (OrigToneListSetBg) OrigToneListSetBg(self, _cmd, color);
}

static void (*OrigReadingGuideLayout)(id, SEL);
static void HookReadingGuideLayout(UIView *self, SEL _cmd) {
    if (OrigReadingGuideLayout) OrigReadingGuideLayout(self, _cmd);
    FQXApplyAudioReadingGuideGlass(self);
}
static void (*OrigReadingGuideAdjust)(id, SEL);
static void HookReadingGuideAdjust(UIView *self, SEL _cmd) {
    if (OrigReadingGuideAdjust) OrigReadingGuideAdjust(self, _cmd);
    FQXApplyAudioReadingGuideGlass(self);
}

static void (*OrigReadingGuideV4Layout)(id, SEL);
static void HookReadingGuideV4Layout(UIView *self, SEL _cmd) {
    if (OrigReadingGuideV4Layout) OrigReadingGuideV4Layout(self, _cmd);
    FQXApplyAudioReadingGuideGlass(self);
}
static void (*OrigReadingGuideV4Tint)(id, SEL, id);
static void HookReadingGuideV4Tint(UIView *self, SEL _cmd, id color) {
    if (OrigReadingGuideV4Tint) OrigReadingGuideV4Tint(self, _cmd, color);
    FQXApplyAudioReadingGuideGlass(self);
}

static void (*OrigToneCellLayout)(id, SEL);
static void HookToneCellLayout(UICollectionViewCell *self, SEL _cmd) {
    if (OrigToneCellLayout) OrigToneCellLayout(self, _cmd);
    FQXApplyAudioToneCellGlass(self);
}
static void (*OrigToneCellSetupBg)(id, SEL);
static void HookToneCellSetupBg(UICollectionViewCell *self, SEL _cmd) {
    if (OrigToneCellSetupBg) OrigToneCellSetupBg(self, _cmd);
    FQXApplyAudioToneCellGlass(self);
}
static void (*OrigToneCellAdjust)(id, SEL);
static void HookToneCellAdjust(UICollectionViewCell *self, SEL _cmd) {
    if (OrigToneCellAdjust) OrigToneCellAdjust(self, _cmd);
    FQXApplyAudioToneCellGlass(self);
}
static void (*OrigToneCellSetSelected)(id, SEL, BOOL);
static void HookToneCellSetSelected(UICollectionViewCell *self, SEL _cmd, BOOL selected) {
    if (OrigToneCellSetSelected) OrigToneCellSetSelected(self, _cmd, selected);
    FQXApplyAudioToneCellGlass(self);
}
static void (*OrigToneCellSetBlurSelected)(id, SEL, BOOL);
static void HookToneCellSetBlurSelected(UICollectionViewCell *self, SEL _cmd, BOOL selected) {
    if (OrigToneCellSetBlurSelected) OrigToneCellSetBlurSelected(self, _cmd, selected);
    FQXApplyAudioToneCellGlass(self);
}

static void (*OrigAudioBgSetupLayout)(id, SEL);
static void HookAudioBgSetupLayout(UIView *self, SEL _cmd) {
    if (OrigAudioBgSetupLayout) OrigAudioBgSetupLayout(self, _cmd);
    FQXApplyAudioBackgroundSeamless(self);
}
static void (*OrigAudioBgUpdateTheme)(id, SEL, id);
static void HookAudioBgUpdateTheme(UIView *self, SEL _cmd, id color) {
    if (OrigAudioBgUpdateTheme) OrigAudioBgUpdateTheme(self, _cmd, color);
    FQXApplyAudioBackgroundSeamless(self);
}
static void (*OrigAudioBgBlurHidden)(id, SEL, BOOL);
static void HookAudioBgBlurHidden(UIView *self, SEL cmd, BOOL hidden) {
    OrigAudioBgBlurHidden(self, cmd, hidden);
    FQXApplyAudioBackgroundSeamless(self);
}

static void (*OrigAudioVCLayoutContent)(id, SEL);
static void HookAudioVCLayoutContent(UIViewController *self, SEL _cmd) {
    if (OrigAudioVCLayoutContent) OrigAudioVCLayoutContent(self, _cmd);
    FQXApplyAudioPlayControllerRefractionAndSeamless(self);
    FQXApplyAudioBookGlass(FQXObjGet(self, "bookView"));
    UIView *nav = FQXObjGet(self, "navigationView");
    if ([nav isKindOfClass:NSClassFromString(@"SSNewAudioPlayNavigationView")]) {
        FQXApplyAudioNavigationGlass(nav);
    }
}
static void (*OrigAudioVCLayoutMasks)(id, SEL);
static void HookAudioVCLayoutMasks(UIViewController *self, SEL _cmd) {
    if (OrigAudioVCLayoutMasks) OrigAudioVCLayoutMasks(self, _cmd);
    FQXApplyAudioPlayControllerRefractionAndSeamless(self);
}
static void (*OrigAudioVCSliderMasks)(id, SEL);
static void HookAudioVCSliderMasks(UIViewController *self, SEL _cmd) {
    if (OrigAudioVCSliderMasks) OrigAudioVCSliderMasks(self, _cmd);
    FQXApplyAudioPlayControllerRefractionAndSeamless(self);
}
static void (*OrigAudioVCBottomMaskTheme)(id, SEL, id);
static void HookAudioVCBottomMaskTheme(UIViewController *self, SEL _cmd, id color) {
    if (OrigAudioVCBottomMaskTheme) OrigAudioVCBottomMaskTheme(self, _cmd, color);
    FQXApplyAudioPlayControllerRefractionAndSeamless(self);
}
static void (*OrigAudioVCSlideMaskTheme)(id, SEL, id);
static void HookAudioVCSlideMaskTheme(UIViewController *self, SEL _cmd, id color) {
    if (OrigAudioVCSlideMaskTheme) OrigAudioVCSlideMaskTheme(self, _cmd, color);
    FQXApplyAudioPlayControllerRefractionAndSeamless(self);
}

static void (*OrigTTSReaderLayout)(id, SEL);
static void HookTTSReaderLayout(id self, SEL _cmd) {
    if (OrigTTSReaderLayout) OrigTTSReaderLayout(self, _cmd);
    FQXUpdateTTSReaderCaptionMask(self);
}
static void (*OrigTTSReaderUpdateMask)(id, SEL);
static void HookTTSReaderUpdateMask(id self, SEL _cmd) {
    if (OrigTTSReaderUpdateMask) OrigTTSReaderUpdateMask(self, _cmd);
    FQXUpdateTTSReaderCaptionMask(self);
}

#pragma mark - Short Drama & Audiobook Dynamic Island ("像音频一样")

typedef NS_ENUM(NSInteger, FQXIslandActiveKind) {
    FQXIslandActiveNone = 0,
    FQXIslandActiveAudiobook = 1,
    FQXIslandActiveDrama = 2,
};

static __weak UIView *sLastDramaPlayer = nil;
static __weak id sLastDramaEngine = nil;
static __weak UIView *sLastDramaControlView = nil;
static __weak UIViewController *sLastDramaListVC = nil;
static __weak UIViewController *sLastDramaFeedVC = nil;
static BOOL sDramaIslandActive = NO;
static BOOL sDramaIslandUserPaused = NO;
static BOOL sDramaManuallyPausedInFeed = NO;
static BOOL sDramaRemoteRegistered = NO;
static BOOL sInstallingDramaRemoteCommands = NO;
static BOOL sDynamicIslandRefreshPending = NO;
static CFTimeInterval sLastDramaPlayingTimestamp = 0.0;
static CFTimeInterval sLastDramaLeavingTimestamp = 0.0;

static const void *FQXMPRemoteHostTargetKey = &FQXMPRemoteHostTargetKey;
static const void *FQXMPRemoteHostActionKey = &FQXMPRemoteHostActionKey;
static const void *FQXMPRemoteHostHandlerKey = &FQXMPRemoteHostHandlerKey;

static void FQXEnsureMediaPlayerLoaded(void) {
    static dispatch_once_t once;
    dispatch_once(&once, ^{
        dlopen("/System/Library/Frameworks/MediaPlayer.framework/MediaPlayer", RTLD_LAZY);
    });
}

static NSString *FQXMPKey(const char *symbolName, NSString *fallback) {
    FQXEnsureMediaPlayerLoaded();
    void *ptr = dlsym(RTLD_DEFAULT, symbolName);
    if (ptr) {
        NSString *val = (__bridge NSString *)(*(void *const *)ptr);
        if ([val isKindOfClass:NSString.class] && val.length > 0) return val;
    }
    return fallback;
}

static double FQXDoubleMsg0(id obj, const char *selName, double fallback) {
    if (!obj || !selName) return fallback;
    SEL sel = sel_registerName(selName);
    Method m = class_getInstanceMethod(object_getClass(obj), sel);
    if (!m || method_getNumberOfArguments(m) != 2) return fallback;
    char ret[8] = {0};
    method_getReturnType(m, ret, sizeof(ret));
    if (ret[0] == 'd') return ((double (*)(id, SEL))objc_msgSend)(obj, sel);
    if (ret[0] == 'f') return (double)((float (*)(id, SEL))objc_msgSend)(obj, sel);
    if (ret[0] == 'q' || ret[0] == 'Q') return (double)((NSInteger (*)(id, SEL))objc_msgSend)(obj, sel);
    return fallback;
}

static NSInteger FQXIntMsg0(id obj, const char *selName, NSInteger fallback) {
    if (!obj || !selName) return fallback;
    SEL sel = sel_registerName(selName);
    Method m = class_getInstanceMethod(object_getClass(obj), sel);
    if (!m || method_getNumberOfArguments(m) != 2) return fallback;
    char ret[8] = {0};
    method_getReturnType(m, ret, sizeof(ret));
    if (ret[0] == 'q' || ret[0] == 'Q') return ((NSInteger (*)(id, SEL))objc_msgSend)(obj, sel);
    if (ret[0] == 'i' || ret[0] == 'I') return (NSInteger)((int (*)(id, SEL))objc_msgSend)(obj, sel);
    return fallback;
}

static void FQXVoidMsg0Safe(id obj, const char *selName) {
    if (!obj || !selName) return;
    SEL sel = sel_registerName(selName);
    Method m = class_getInstanceMethod(object_getClass(obj), sel);
    if (!m || method_getNumberOfArguments(m) != 2) return;
    char ret[8] = {0};
    method_getReturnType(m, ret, sizeof(ret));
    if (ret[0] == 'v') ((void (*)(id, SEL))objc_msgSend)(obj, sel);
}

static NSString *FQXFirstNonEmptyString(id obj, NSArray<NSString *> *keys) {
    if (!obj) return nil;
    for (NSString *k in keys) {
        id val = FQXObjGet(obj, k.UTF8String);
        if ([val isKindOfClass:NSString.class]) {
            NSString *trimmed = [(NSString *)val stringByTrimmingCharactersInSet:NSCharacterSet.whitespaceAndNewlineCharacterSet];
            if (trimmed.length > 0) return trimmed;
        }
    }
    return nil;
}

@interface FQXRemoteCommandEventStub : NSObject
@property(nonatomic, strong) id command;
@property(nonatomic) NSTimeInterval timestamp;
- (instancetype)initWithCommand:(id)cmd;
@end

@implementation FQXRemoteCommandEventStub
- (instancetype)initWithCommand:(id)cmd {
    self = [super init];
    if (self) {
        _command = cmd;
        _timestamp = NSProcessInfo.processInfo.systemUptime;
    }
    return self;
}
- (NSMethodSignature *)methodSignatureForSelector:(SEL)aSelector {
    NSMethodSignature *sig = [super methodSignatureForSelector:aSelector];
    return sig ?: [NSMethodSignature signatureWithObjCTypes:"@16@0:8"];
}
- (void)forwardInvocation:(NSInvocation *)anInvocation {
    NSUInteger len = anInvocation.methodSignature.methodReturnLength;
    if (len > 0) {
        void *zeroBuf = calloc(1, len);
        if (zeroBuf) {
            [anInvocation setReturnValue:zeroBuf];
            free(zeroBuf);
        }
    }
}
@end

@interface FQXWeakBox : NSObject
@property(nonatomic, weak) id target;
@end
@implementation FQXWeakBox
@end

static void FQXDramaTogglePlayPauseAction(void);
static void FQXDramaPlayAction(BOOL play);
static void FQXDramaStepEpisode(NSInteger delta);
static void FQXScheduleDynamicIslandRefresh(void);

@interface FQXDramaRemoteTarget : NSObject
+ (instancetype)shared;
- (NSInteger)onPlay:(id)event;
- (NSInteger)onPause:(id)event;
- (NSInteger)onToggle:(id)event;
- (NSInteger)onPrev:(id)event;
- (NSInteger)onNext:(id)event;
@end

@implementation FQXDramaRemoteTarget
+ (instancetype)shared {
    static FQXDramaRemoteTarget *inst = nil;
    static dispatch_once_t once;
    dispatch_once(&once, ^{ inst = [FQXDramaRemoteTarget new]; });
    return inst;
}
- (NSInteger)onPlay:(id)event {
    (void)event;
    FQXDramaPlayAction(YES);
    return 0;
}
- (NSInteger)onPause:(id)event {
    (void)event;
    FQXDramaPlayAction(NO);
    return 0;
}
- (NSInteger)onToggle:(id)event {
    (void)event;
    FQXDramaTogglePlayPauseAction();
    return 0;
}
- (NSInteger)onPrev:(id)event {
    (void)event;
    FQXDramaStepEpisode(-1);
    return 0;
}
- (NSInteger)onNext:(id)event {
    (void)event;
    FQXDramaStepEpisode(1);
    return 0;
}
@end

static void (*OrigMPRemoteAddTargetAction)(id, SEL, id, SEL);
static void HookMPRemoteAddTargetAction(id self, SEL _cmd, id target, SEL action) {
    if (OrigMPRemoteAddTargetAction) OrigMPRemoteAddTargetAction(self, _cmd, target, action);
    if (!sInstallingDramaRemoteCommands && target && action && target != [FQXDramaRemoteTarget shared]) {
        FQXWeakBox *box = [FQXWeakBox new];
        box.target = target;
        objc_setAssociatedObject(self, FQXMPRemoteHostTargetKey, box, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
        objc_setAssociatedObject(self, FQXMPRemoteHostActionKey, NSStringFromSelector(action), OBJC_ASSOCIATION_COPY_NONATOMIC);
    }
}

static id (*OrigMPRemoteAddTargetHandler)(id, SEL, id);
static id HookMPRemoteAddTargetHandler(id self, SEL _cmd, id handlerBlock) {
    id token = OrigMPRemoteAddTargetHandler ? OrigMPRemoteAddTargetHandler(self, _cmd, handlerBlock) : nil;
    if (!sInstallingDramaRemoteCommands && handlerBlock) {
        objc_setAssociatedObject(self, FQXMPRemoteHostHandlerKey, [handlerBlock copy], OBJC_ASSOCIATION_COPY_NONATOMIC);
    }
    return token;
}

static BOOL FQXInvokeHostAudioRemoteCommand(NSString *commandGetter) {
    FQXEnsureMediaPlayerLoaded();
    Class ccCls = NSClassFromString(@"MPRemoteCommandCenter");
    SEL sharedSel = NSSelectorFromString(@"sharedCommandCenter");
    if (!ccCls || ![ccCls respondsToSelector:sharedSel]) return NO;
    id center = ((id (*)(id, SEL))objc_msgSend)(ccCls, sharedSel);
    id cmdObj = FQXObjGet(center, commandGetter.UTF8String);
    if (!cmdObj) return NO;

    FQXRemoteCommandEventStub *stub = [[FQXRemoteCommandEventStub alloc] initWithCommand:cmdObj];
    NSInteger (^handler)(id) = objc_getAssociatedObject(cmdObj, FQXMPRemoteHostHandlerKey);
    if (handler) {
        handler(stub);
        return YES;
    }
    FQXWeakBox *box = objc_getAssociatedObject(cmdObj, FQXMPRemoteHostTargetKey);
    NSString *selStr = objc_getAssociatedObject(cmdObj, FQXMPRemoteHostActionKey);
    id target = box.target;
    if (target && selStr.length) {
        SEL act = NSSelectorFromString(selStr);
        Method m = class_getInstanceMethod(object_getClass(target), act);
        if (m) {
            unsigned int argc = method_getNumberOfArguments(m);
            char ret[8] = {0};
            method_getReturnType(m, ret, sizeof(ret));
            if (argc >= 3) {
                if (ret[0] == 'q' || ret[0] == 'Q' || ret[0] == 'i') {
                    (void)((NSInteger (*)(id, SEL, id))objc_msgSend)(target, act, stub);
                } else {
                    ((void (*)(id, SEL, id))objc_msgSend)(target, act, stub);
                }
                return YES;
            } else if (argc == 2) {
                if (ret[0] == 'q' || ret[0] == 'Q' || ret[0] == 'i') {
                    (void)((NSInteger (*)(id, SEL))objc_msgSend)(target, act);
                } else {
                    ((void (*)(id, SEL))objc_msgSend)(target, act);
                }
                return YES;
            }
        }
    }
    return NO;
}

static UIWindow *FQXActiveForegroundWindow(void) {
    UIWindow *fallback = nil;
    for (UIScene *scene in UIApplication.sharedApplication.connectedScenes) {
        if (![scene isKindOfClass:UIWindowScene.class]) continue;
        UIWindowScene *ws = (UIWindowScene *)scene;
        for (UIWindow *win in ws.windows) {
            if (win.hidden || win.alpha < 0.01 || win.windowLevel > UIWindowLevelNormal + 1.0) continue;
            if (![NSStringFromClass(win.class) isEqualToString:@"UIWindow"] &&
                [NSStringFromClass(win.class) containsString:@"Keyboard"]) continue;
            if (win.isKeyWindow) return win;
            if (!fallback) fallback = win;
        }
    }
    return fallback;
}

static UIViewController *FQXTopVisibleControllerFrom(UIViewController *vc) {
    if (!vc) return nil;
    if (vc.presentedViewController && !vc.presentedViewController.isBeingDismissed) {
        return FQXTopVisibleControllerFrom(vc.presentedViewController);
    }
    if ([vc isKindOfClass:UITabBarController.class]) {
        UITabBarController *tc = (UITabBarController *)vc;
        if (tc.selectedViewController) return FQXTopVisibleControllerFrom(tc.selectedViewController);
    }
    if ([vc isKindOfClass:UINavigationController.class]) {
        UINavigationController *nc = (UINavigationController *)vc;
        if (nc.visibleViewController) return FQXTopVisibleControllerFrom(nc.visibleViewController);
    }
    for (UIViewController *child in vc.childViewControllers.reverseObjectEnumerator) {
        if (!child.isViewLoaded) continue;
        UIView *v = child.view;
        if (v.window && !v.hidden && v.alpha > 0.05 &&
            CGRectGetWidth(v.bounds) > 200.0 && CGRectGetHeight(v.bounds) > 300.0) {
            return FQXTopVisibleControllerFrom(child);
        }
    }
    return vc;
}

static BOOL FQXSubtreeContainsVisibleControllerOfClasses(UIViewController *root, NSArray<Class> *classes) {
    if (!root || !classes.count) return NO;
    for (Class c in classes) {
        if ([root isKindOfClass:c]) {
            if (!root.isViewLoaded) return NO;
            UIView *v = root.view;
            return v.window != nil && !v.hidden && v.alpha > 0.05;
        }
    }
    for (UIViewController *child in root.childViewControllers) {
        if (FQXSubtreeContainsVisibleControllerOfClasses(child, classes)) return YES;
    }
    return NO;
}

static BOOL FQXIsControllerClassCurrentlyVisible(NSArray<NSString *> *classNames) {
    if (UIApplication.sharedApplication.applicationState == UIApplicationStateBackground) return NO;
    NSMutableArray<Class> *classes = [NSMutableArray array];
    for (NSString *n in classNames) {
        Class c = NSClassFromString(n);
        if (c) [classes addObject:c];
    }
    if (!classes.count) return NO;
    UIWindow *win = FQXActiveForegroundWindow();
    if (!win.rootViewController) return NO;
    UIViewController *top = FQXTopVisibleControllerFrom(win.rootViewController);
    if (!top) return NO;
    for (Class c in classes) {
        if ([top isKindOfClass:c]) return YES;
    }
    UIViewController *branch = win.rootViewController;
    while (branch.presentedViewController && !branch.presentedViewController.isBeingDismissed) {
        branch = branch.presentedViewController;
    }
    if ([branch isKindOfClass:UITabBarController.class]) {
        branch = ((UITabBarController *)branch).selectedViewController ?: branch;
    }
    if ([branch isKindOfClass:UINavigationController.class]) {
        branch = ((UINavigationController *)branch).topViewController ?: branch;
    }
    return FQXSubtreeContainsVisibleControllerOfClasses(branch, classes);
}

static BOOL FQXIsAudioFullPlayerCurrentlyVisible(void) {
    return FQXIsControllerClassCurrentlyVisible(@[
        @"SSNewAudioPlayViewController",
        @"SSAudioPlayTTSReaderPageViewController",
    ]);
}

static BOOL FQXIsDramaScreenCurrentlyVisible(void) {
    return FQXIsControllerClassCurrentlyVisible(@[
        @"FQVShortVideoListViewController",
        @"SSVideoSeriesFeedViewController",
        @"SSVideoFeedContainerViewController",
    ]);
}

static void FQXCacheDramaAncestorsFromView(UIView *view) {
    Class listCls = NSClassFromString(@"FQVShortVideoListViewController");
    Class feedCls = NSClassFromString(@"SSVideoSeriesFeedViewController");
    Class ctrlCls = NSClassFromString(@"FQVShortVideoVPlayerControlView");
    for (UIResponder *r = view; r; r = r.nextResponder) {
        if (ctrlCls && [r isKindOfClass:ctrlCls]) {
            sLastDramaControlView = (UIView *)r;
        } else if (listCls && [r isKindOfClass:listCls]) {
            sLastDramaListVC = (UIViewController *)r;
        } else if (feedCls && [r isKindOfClass:feedCls]) {
            sLastDramaFeedVC = (UIViewController *)r;
        }
    }
}

static UIView *FQXFindViewOfClassInSubtree(UIView *root, Class targetCls, NSInteger maxDepth) {
    if (!root || !targetCls || maxDepth < 0) return nil;
    if ([root isKindOfClass:targetCls]) return root;
    if (maxDepth == 0) return nil;
    for (UIView *sub in root.subviews) {
        UIView *hit = FQXFindViewOfClassInSubtree(sub, targetCls, maxDepth - 1);
        if (hit) return hit;
    }
    return nil;
}

static BOOL FQXDramaIsCurrentlyPlaying(void) {
    UIView *player = sLastDramaPlayer;
    if (!player) return NO;
    NSInteger st = FQXIntMsg0(player, "playbackState", -1);
    if (st == 1) return YES;
    if (st == 0 || st == 2 || st == 3) return NO;
    if (FQXBoolGet(player, "isPlaying", NO)) return YES;
    id eng = FQXObjGet(player, "videoEngine") ?: sLastDramaEngine;
    if (eng) {
        NSInteger est = FQXIntMsg0(eng, "playbackState", -1);
        if (est == 1) return YES;
    }
    return NO;
}

static void FQXActivateDramaAudioSession(void) {
    AVAudioSession *session = AVAudioSession.sharedInstance;
    NSError *err = nil;
    [session setCategory:AVAudioSessionCategoryPlayback
                    mode:AVAudioSessionModeDefault
                 options:0
                   error:&err];
    [session setActive:YES error:&err];
}

static void FQXSetDramaRemoteCommandsRegistered(BOOL registered) {
    if (sDramaRemoteRegistered == registered) return;
    FQXEnsureMediaPlayerLoaded();
    Class ccCls = NSClassFromString(@"MPRemoteCommandCenter");
    SEL sharedSel = NSSelectorFromString(@"sharedCommandCenter");
    if (!ccCls || ![ccCls respondsToSelector:sharedSel]) return;
    id center = ((id (*)(id, SEL))objc_msgSend)(ccCls, sharedSel);
    if (!center) return;

    FQXDramaRemoteTarget *target = [FQXDramaRemoteTarget shared];
    NSArray<NSArray<NSString *> *> *pairs = @[
        @[@"playCommand", @"onPlay:"],
        @[@"pauseCommand", @"onPause:"],
        @[@"togglePlayPauseCommand", @"onToggle:"],
        @[@"previousTrackCommand", @"onPrev:"],
        @[@"nextTrackCommand", @"onNext:"],
    ];
    sInstallingDramaRemoteCommands = YES;
    SEL addSel = NSSelectorFromString(@"addTarget:action:");
    SEL remSel = NSSelectorFromString(@"removeTarget:");
    SEL enSel = NSSelectorFromString(@"setEnabled:");
    for (NSArray<NSString *> *pair in pairs) {
        id cmdObj = FQXObjGet(center, pair[0].UTF8String);
        if (!cmdObj) continue;
        if ([cmdObj respondsToSelector:remSel]) {
            ((void (*)(id, SEL, id))objc_msgSend)(cmdObj, remSel, target);
        }
        if (registered) {
            if ([cmdObj respondsToSelector:enSel]) {
                ((void (*)(id, SEL, BOOL))objc_msgSend)(cmdObj, enSel, YES);
            }
            if ([cmdObj respondsToSelector:addSel]) {
                ((void (*)(id, SEL, id, SEL))objc_msgSend)(cmdObj, addSel, target, NSSelectorFromString(pair[1]));
            }
        }
    }
    sInstallingDramaRemoteCommands = NO;
    sDramaRemoteRegistered = registered;
}

static void FQXExtractDramaMetadata(NSString **outTitle,
                                    NSString **outSubtitle,
                                    UIImage **outCover,
                                    double *outDuration,
                                    double *outElapsed) {
    NSString *title = nil;
    NSString *episode = nil;
    UIImage *cover = nil;

    UIView *ctrl = sLastDramaControlView;
    if (!ctrl && sLastDramaListVC.isViewLoaded) {
        ctrl = FQXFindViewOfClassInSubtree(sLastDramaListVC.view,
                                           NSClassFromString(@"FQVShortVideoVPlayerControlView"), 8);
        if (ctrl) sLastDramaControlView = ctrl;
    }

    id model = FQXObjGet(ctrl, "videoDataModel") ?: FQXObjGet(ctrl, "contentModel");
    if (!model && sLastDramaPlayer) {
        model = [objc_getAssociatedObject(sLastDramaPlayer, FQXQualityModelKey) anyObject];
    }
    if (model) {
        title = FQXFirstNonEmptyString(model, @[@"seriesTitle", @"seriesName", @"albumTitle", @"bookName", @"dramaTitle", @"title"]);
        episode = FQXFirstNonEmptyString(model, @[@"episodeTitle", @"subTitle", @"seqTitle", @"currentEpisodeTitle"]);
        if (!episode.length) {
            NSInteger epIdx = FQXIntMsg0(model, "episodeIndex", -1);
            if (epIdx < 0) epIdx = FQXIntMsg0(model, "seq", -1);
            if (epIdx > 0) episode = [NSString stringWithFormat:@"第%ld集", (long)epIdx];
        }
    }

    if (ctrl) {
        NSMutableArray<UILabel *> *labels = [NSMutableArray array];
        NSMutableArray<UIView *> *stack = [NSMutableArray arrayWithObject:ctrl];
        while (stack.count > 0 && labels.count < 24) {
            UIView *cur = stack.lastObject;
            [stack removeLastObject];
            if (cur.hidden || cur.alpha < 0.05) continue;
            if ([cur isKindOfClass:UILabel.class]) {
                NSString *t = ((UILabel *)cur).text;
                if (t.length > 0) [labels addObject:(UILabel *)cur];
            } else if ([cur isKindOfClass:UIImageView.class] && !cover) {
                UIImage *img = ((UIImageView *)cur).image;
                if (img && img.size.width >= 36.0 && img.size.height >= 36.0) cover = img;
            }
            for (UIView *sub in cur.subviews) [stack addObject:sub];
        }
        for (UILabel *lbl in labels) {
            NSString *txt = [lbl.text stringByTrimmingCharactersInSet:NSCharacterSet.whitespaceAndNewlineCharacterSet];
            if (!txt.length) continue;
            if (!episode.length && ([txt hasPrefix:@"第"] && [txt containsString:@"集"])) {
                NSRange barRange = [txt rangeOfString:@"|"];
                episode = (barRange.location != NSNotFound)
                    ? [[txt substringToIndex:barRange.location] stringByTrimmingCharactersInSet:NSCharacterSet.whitespaceCharacterSet]
                    : txt;
            } else if (!title.length && lbl.font.pointSize >= 15.0 &&
                       ![txt containsString:@"全屏观看"] && ![txt containsString:@"完整"] &&
                       ![txt hasPrefix:@"原著"]) {
                title = [txt stringByReplacingOccurrencesOfString:@" >" withString:@""];
            }
        }
    }

    UIView *player = sLastDramaPlayer;
    id engine = FQXObjGet(player, "videoEngine") ?: sLastDramaEngine;
    if (!cover && player) {
        UIView *iv = FQXFindViewOfClassInSubtree(player, UIImageView.class, 4);
        if ([iv isKindOfClass:UIImageView.class] && ((UIImageView *)iv).image) {
            cover = ((UIImageView *)iv).image;
        }
    }

    double dur = FQXDoubleMsg0(player, "duration", 0.0);
    if (dur <= 0.1 && engine) dur = FQXDoubleMsg0(engine, "duration", 0.0);
    double cur = FQXDoubleMsg0(player, "currentPlaybackTime", 0.0);
    if (cur <= 0.0 && engine) cur = FQXDoubleMsg0(engine, "currentPlaybackTime", 0.0);

    if (outTitle) *outTitle = title.length ? title : @"短剧播放中";
    if (outSubtitle) *outSubtitle = episode.length ? episode : @"后台音频播放";
    if (outCover) *outCover = cover;
    if (outDuration) *outDuration = MAX(0.0, dur);
    if (outElapsed) *outElapsed = MAX(0.0, cur);
}

static void FQXUpdateDramaSystemNowPlaying(void) {
    if (!sDramaIslandActive || FQXIsAudioBookSessionAlive()) return;
    FQXEnsureMediaPlayerLoaded();
    Class infoCls = NSClassFromString(@"MPNowPlayingInfoCenter");
    SEL defSel = NSSelectorFromString(@"defaultCenter");
    SEL setSel = NSSelectorFromString(@"setNowPlayingInfo:");
    if (!infoCls || ![infoCls respondsToSelector:defSel]) return;
    id center = ((id (*)(id, SEL))objc_msgSend)(infoCls, defSel);
    if (!center || ![center respondsToSelector:setSel]) return;

    NSString *title = nil;
    NSString *subtitle = nil;
    UIImage *cover = nil;
    double dur = 0.0;
    double elapsed = 0.0;
    FQXExtractDramaMetadata(&title, &subtitle, &cover, &dur, &elapsed);
    BOOL playing = FQXDramaIsCurrentlyPlaying();

    NSMutableDictionary *info = [NSMutableDictionary dictionary];
    info[FQXMPKey("MPMediaItemPropertyTitle", @"title")] = title ?: @"短剧播放中";
    info[FQXMPKey("MPMediaItemPropertyArtist", @"artist")] = subtitle ?: @"番茄短剧";
    info[FQXMPKey("MPMediaItemPropertyAlbumTitle", @"albumTitle")] = @"番茄短剧";
    if (dur > 0.5) {
        info[FQXMPKey("MPMediaItemPropertyPlaybackDuration", @"playbackDuration")] = @(dur);
        info[FQXMPKey("MPNowPlayingInfoPropertyElapsedPlaybackTime", @"MPNowPlayingInfoPropertyElapsedPlaybackTime")] = @(MIN(dur, elapsed));
    }
    info[FQXMPKey("MPNowPlayingInfoPropertyPlaybackRate", @"MPNowPlayingInfoPropertyPlaybackRate")] = @(playing ? 1.0 : 0.0);
    info[FQXMPKey("MPNowPlayingInfoPropertyDefaultPlaybackRate", @"MPNowPlayingInfoPropertyDefaultPlaybackRate")] = @1.0;

    if (cover) {
        Class artCls = NSClassFromString(@"MPMediaItemArtwork");
        SEL initArtSel = NSSelectorFromString(@"initWithBoundsSize:requestHandler:");
        if (artCls && [artCls instancesRespondToSelector:initArtSel]) {
            CGSize sz = cover.size.width > 1.0 ? cover.size : CGSizeMake(240.0, 240.0);
            UIImage *captured = cover;
            id art = ((id (*)(id, SEL, CGSize, UIImage *(^)(CGSize)))objc_msgSend)(
                [artCls alloc], initArtSel, sz, ^UIImage *(__unused CGSize reqSize) {
                    return captured;
                });
            if (art) {
                info[FQXMPKey("MPMediaItemPropertyArtwork", @"artwork")] = art;
            }
        }
    }
    ((void (*)(id, SEL, id))objc_msgSend)(center, setSel, info);
}

static void FQXClearDramaSystemNowPlayingIfOwned(void) {
    FQXSetDramaRemoteCommandsRegistered(NO);
    if (FQXIsAudioBookSessionAlive()) {
        FQXActivateAudioPlaybackSessionAndRemote();
        return;
    }
    FQXEnsureMediaPlayerLoaded();
    Class infoCls = NSClassFromString(@"MPNowPlayingInfoCenter");
    SEL defSel = NSSelectorFromString(@"defaultCenter");
    SEL setSel = NSSelectorFromString(@"setNowPlayingInfo:");
    if (infoCls && [infoCls respondsToSelector:defSel]) {
        id center = ((id (*)(id, SEL))objc_msgSend)(infoCls, defSel);
        if (center && [center respondsToSelector:setSel]) {
            ((void (*)(id, SEL, id))objc_msgSend)(center, setSel, nil);
        }
    }
}

static void FQXStopDramaIslandSession(BOOL pausePlayer) {
    if (pausePlayer && sLastDramaPlayer) {
        FQXVoidMsg0Safe(sLastDramaPlayer, "pause");
        id eng = FQXObjGet(sLastDramaPlayer, "videoEngine") ?: sLastDramaEngine;
        if (eng) FQXVoidMsg0Safe(eng, "pause");
    }
    sDramaIslandActive = NO;
    sDramaIslandUserPaused = NO;
    FQXClearDramaSystemNowPlayingIfOwned();
}

static void FQXDramaPlayAction(BOOL play) {
    UIView *player = sLastDramaPlayer;
    if (!player) return;
    id eng = FQXObjGet(player, "videoEngine") ?: sLastDramaEngine;
    if (play) {
        if (FQXIsAudioBookSessionAlive()) {
            id sdk = FQXSharedAudioSDKManager();
            SEL stopSel = NSSelectorFromString(@"audioStopWithEntry:");
            if (sdk && [sdk respondsToSelector:stopSel]) {
                ((void (*)(id, SEL, id))objc_msgSend)(sdk, stopSel, @"drama_island");
            }
        }
        sDramaIslandUserPaused = NO;
        sDramaManuallyPausedInFeed = NO;
        FQXActivateDramaAudioSession();
        FQXVoidMsg0Safe(player, "play");
        if (!FQXDramaIsCurrentlyPlaying() && eng) {
            FQXVoidMsg0Safe(eng, "play");
        }
    } else {
        sDramaIslandUserPaused = YES;
        FQXVoidMsg0Safe(player, "pause");
        if (eng) FQXVoidMsg0Safe(eng, "pause");
    }
    FQXUpdateDramaSystemNowPlaying();
    FQXScheduleDynamicIslandRefresh();
}

static void FQXDramaTogglePlayPauseAction(void) {
    FQXDramaPlayAction(!FQXDramaIsCurrentlyPlaying());
}

static UICollectionView *FQXFindDramaFeedCollectionView(UIView *root, NSInteger depth) {
    if (!root || depth < 0) return nil;
    Class fqvCVCls = NSClassFromString(@"FQVCollectionView");
    if ([root isKindOfClass:UICollectionView.class]) {
        UICollectionView *cv = (UICollectionView *)root;
        if ((fqvCVCls && [cv isKindOfClass:fqvCVCls]) ||
            (CGRectGetHeight(cv.bounds) > 320.0 && cv.pagingEnabled)) {
            return cv;
        }
    }
    if (depth == 0) return nil;
    for (UIView *sub in root.subviews) {
        UICollectionView *hit = FQXFindDramaFeedCollectionView(sub, depth - 1);
        if (hit) return hit;
    }
    return nil;
}

static void FQXDramaStepEpisode(NSInteger delta) {
    if (delta == 0) return;
    UIViewController *listVC = sLastDramaListVC;
    UIView *searchRoot = listVC.isViewLoaded ? listVC.view : (sLastDramaFeedVC.isViewLoaded ? sLastDramaFeedVC.view : nil);
    if (!searchRoot) return;
    UICollectionView *cv = FQXObjGet(listVC, "collectionView");
    if (![cv isKindOfClass:UICollectionView.class]) {
        cv = FQXFindDramaFeedCollectionView(searchRoot, 6);
    }
    if (![cv isKindOfClass:UICollectionView.class] || [cv numberOfSections] <= 0) return;
    NSInteger count = [cv numberOfItemsInSection:0];
    if (count <= 1) return;
    CGFloat pageH = CGRectGetHeight(cv.bounds);
    if (pageH < 100.0) return;

    NSInteger curIdx = (NSInteger)llround(cv.contentOffset.y / pageH);
    curIdx = MAX(0, MIN(count - 1, curIdx));
    NSInteger nextIdx = curIdx + delta;
    if (nextIdx < 0 || nextIdx >= count) return;

    sDramaIslandUserPaused = NO;
    FQXActivateDramaAudioSession();
    NSIndexPath *targetIP = [NSIndexPath indexPathForItem:nextIdx inSection:0];
    [cv scrollToItemAtIndexPath:targetIP atScrollPosition:UICollectionViewScrollPositionTop animated:NO];
    [cv setContentOffset:CGPointMake(0.0, (CGFloat)nextIdx * pageH) animated:NO];
    [cv setNeedsLayout];
    [cv layoutIfNeeded];

    id del = cv.delegate;
    if ([del respondsToSelector:@selector(scrollViewDidScroll:)]) {
        [del scrollViewDidScroll:cv];
    }
    if ([del respondsToSelector:@selector(scrollViewDidEndDecelerating:)]) {
        [del scrollViewDidEndDecelerating:cv];
    }
    if ([del respondsToSelector:@selector(scrollViewDidEndScrollingAnimation:)]) {
        [del scrollViewDidEndScrollingAnimation:cv];
    }

    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.18 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        UIView *ctrl = FQXFindViewOfClassInSubtree(cv, NSClassFromString(@"FQVShortVideoVPlayerControlView"), 7);
        if (ctrl) {
            sLastDramaControlView = ctrl;
            UIView *pl = FQXObjGet(ctrl, "vPlayer");
            if ([pl isKindOfClass:UIView.class]) sLastDramaPlayer = pl;
        }
        if (sDramaIslandActive && !sDramaIslandUserPaused && sLastDramaPlayer) {
            FQXActivateDramaAudioSession();
            FQXVoidMsg0Safe(sLastDramaPlayer, "play");
        }
        FQXUpdateDramaSystemNowPlaying();
        FQXScheduleDynamicIslandRefresh();
    });
}

static BOOL FQXAudioIsCurrentlyPlaying(void) {
    id sdk = FQXSharedAudioSDKManager();
    if (!sdk || !FQXIsAudioBookSessionAlive()) return NO;
    if (FQXBoolGet(sdk, "playing", NO)) return YES;
    if (FQXBoolGet(sdk, "loading", NO) && !FQXBoolGet(sdk, "paused", NO)) return YES;
    return NO;
}

static void FQXExtractAudioMetadata(NSString **outTitle, NSString **outSubtitle, UIImage **outCover) {
    NSString *title = nil;
    NSString *subtitle = nil;
    UIImage *cover = nil;

    id sdk = FQXSharedAudioSDKManager();
    id playMgr = FQXObjGet(sdk, "bdfqPlayManager");
    id playInfo = FQXObjGet(playMgr, "playInfo");
    if (playInfo) {
        title = FQXFirstNonEmptyString(playInfo, @[@"bookName", @"albumTitle", @"novelName", @"seriesName", @"title"]);
        subtitle = FQXFirstNonEmptyString(playInfo, @[@"chapterTitle", @"chapterName", @"itemTitle", @"subTitle", @"title"]);
        id imgObj = FQXObjGet(playInfo, "coverImage") ?: FQXObjGet(playInfo, "bookCoverImage");
        if ([imgObj isKindOfClass:UIImage.class]) cover = (UIImage *)imgObj;
    }

    FQXEnsureMediaPlayerLoaded();
    Class infoCls = NSClassFromString(@"MPNowPlayingInfoCenter");
    SEL defSel = NSSelectorFromString(@"defaultCenter");
    if (infoCls && [infoCls respondsToSelector:defSel]) {
        id center = ((id (*)(id, SEL))objc_msgSend)(infoCls, defSel);
        NSDictionary *np = FQXObjGet(center, "nowPlayingInfo");
        if ([np isKindOfClass:NSDictionary.class]) {
            NSString *npTitle = np[FQXMPKey("MPMediaItemPropertyTitle", @"title")];
            NSString *npAlbum = np[FQXMPKey("MPMediaItemPropertyAlbumTitle", @"albumTitle")];
            NSString *npArtist = np[FQXMPKey("MPMediaItemPropertyArtist", @"artist")];
            if (!title.length && [npAlbum isKindOfClass:NSString.class] && npAlbum.length) title = npAlbum;
            if (!title.length && [npTitle isKindOfClass:NSString.class] && npTitle.length) title = npTitle;
            if (!subtitle.length && [npTitle isKindOfClass:NSString.class] && npTitle.length && ![npTitle isEqualToString:title]) {
                subtitle = npTitle;
            }
            if (!subtitle.length && [npArtist isKindOfClass:NSString.class] && npArtist.length) subtitle = npArtist;
            if (!cover) {
                id art = np[FQXMPKey("MPMediaItemPropertyArtwork", @"artwork")];
                SEL imgSel = NSSelectorFromString(@"imageWithSize:");
                if (art && [art respondsToSelector:imgSel]) {
                    UIImage *artImg = ((UIImage *(*)(id, SEL, CGSize))objc_msgSend)(art, imgSel, CGSizeMake(120.0, 120.0));
                    if ([artImg isKindOfClass:UIImage.class]) cover = artImg;
                }
            }
        }
    }

    if (!cover) {
        Class audioIndCls = NSClassFromString(@"SSAudioPlayIndicatorView");
        for (UIView *ind in [FQXTrackedAudioIndicators() allObjects]) {
            if (audioIndCls && ![ind isKindOfClass:audioIndCls]) continue;
            UIView *iv = FQXFindViewOfClassInSubtree(ind, UIImageView.class, 4);
            if ([iv isKindOfClass:UIImageView.class] && ((UIImageView *)iv).image) {
                cover = ((UIImageView *)iv).image;
                break;
            }
        }
    }

    if ([title isEqualToString:subtitle]) subtitle = @"正在朗读";
    if (outTitle) *outTitle = title.length ? title : @"听书朗读";
    if (outSubtitle) *outSubtitle = subtitle.length ? subtitle : @"后台朗读中";
    if (outCover) *outCover = cover;
}

static void FQXAudioTogglePlayPauseAction(void) {
    id sdk = FQXSharedAudioSDKManager();
    if (!sdk) return;
    FQXActivateAudioPlaybackSessionAndRemote();
    if (FQXAudioIsCurrentlyPlaying()) {
        if (!FQXInvokeHostAudioRemoteCommand(@"pauseCommand")) {
            SEL pauseSel = NSSelectorFromString(@"audioPauseWithType:entry:");
            if ([sdk respondsToSelector:pauseSel]) {
                ((void (*)(id, SEL, NSUInteger, id))objc_msgSend)(sdk, pauseSel, 0, @"dynamic_island");
            }
        }
    } else {
        if (!FQXInvokeHostAudioRemoteCommand(@"playCommand") &&
            !FQXInvokeHostAudioRemoteCommand(@"togglePlayPauseCommand")) {
            FQXVoidMsg0Safe(sdk, "audioResume");
            id playMgr = FQXObjGet(sdk, "bdfqPlayManager");
            if (playMgr) FQXVoidMsg0Safe(playMgr, "play");
        }
    }
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.08 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        FQXScheduleDynamicIslandRefresh();
    });
}

static void FQXAudioStepChapter(NSInteger delta) {
    if (delta == 0) return;
    FQXActivateAudioPlaybackSessionAndRemote();
    NSString *cmdKey = (delta < 0) ? @"previousTrackCommand" : @"nextTrackCommand";
    if (!FQXInvokeHostAudioRemoteCommand(cmdKey)) {
        id sdk = FQXSharedAudioSDKManager();
        if (delta < 0) {
            FQXVoidMsg0Safe(sdk, "audioPlayPrev");
            FQXVoidMsg0Safe(sdk, "playPrev");
        } else {
            FQXVoidMsg0Safe(sdk, "audioPlayNext");
            FQXVoidMsg0Safe(sdk, "playNext");
        }
    }
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.16 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        FQXScheduleDynamicIslandRefresh();
    });
}

static void FQXAudioStopSessionAction(void) {
    id sdk = FQXSharedAudioSDKManager();
    SEL stopSel = NSSelectorFromString(@"audioStopWithEntry:");
    if (sdk && [sdk respondsToSelector:stopSel]) {
        ((void (*)(id, SEL, id))objc_msgSend)(sdk, stopSel, @"dynamic_island");
    }
    FQXScheduleDynamicIslandRefresh();
}

static void FQXOpenAudiobookPlayerPage(void) {
    Class audioIndCls = NSClassFromString(@"SSAudioPlayIndicatorView");
    for (UIView *ind in [FQXTrackedAudioIndicators() allObjects]) {
        if (!ind.window || (audioIndCls && ![ind isKindOfClass:audioIndCls])) continue;
        for (UIGestureRecognizer *gr in ind.gestureRecognizers) {
            if ([gr isKindOfClass:UITapGestureRecognizer.class]) {
                NSArray *targets = nil;
                @try { targets = [gr valueForKey:@"_targets"]; } @catch (__unused NSException *e) {}
                for (id pair in targets) {
                    id tgt = nil;
                    @try { tgt = [pair valueForKey:@"_target"]; } @catch (__unused NSException *e) {}
                    if (!tgt) continue;
                    for (NSString *cand in @[@"onClickIndicator:", @"onClickIndicator", @"didTapIndicator:", @"didTapIndicator", @"tapAction:", @"onTap:"]) {
                        SEL s = NSSelectorFromString(cand);
                        if ([tgt respondsToSelector:s]) {
                            Method m = class_getInstanceMethod(object_getClass(tgt), s);
                            if (m && method_getNumberOfArguments(m) == 3) {
                                ((void (*)(id, SEL, id))objc_msgSend)(tgt, s, gr);
                                return;
                            } else if (m && method_getNumberOfArguments(m) == 2) {
                                ((void (*)(id, SEL))objc_msgSend)(tgt, s);
                                return;
                            }
                        }
                    }
                }
            }
        }
        UIView *btn = FQXFindViewOfClassInSubtree(ind, UIButton.class, 4);
        if ([btn isKindOfClass:UIButton.class]) {
            [(UIButton *)btn sendActionsForControlEvents:UIControlEventTouchUpInside];
            return;
        }
    }
}

static void FQXOpenDramaPlayerPage(void) {
    UIWindow *win = FQXActiveForegroundWindow();
    UIViewController *root = win.rootViewController;
    if ([root isKindOfClass:UITabBarController.class]) {
        UITabBarController *tc = (UITabBarController *)root;
        Class feedCls = NSClassFromString(@"SSVideoSeriesFeedViewController");
        Class listCls = NSClassFromString(@"FQVShortVideoListViewController");
        Class contCls = NSClassFromString(@"SSVideoFeedContainerViewController");
        NSArray<UIViewController *> *vcs = tc.viewControllers;
        for (NSUInteger i = 0; i < vcs.count; ++i) {
            UIViewController *cand = vcs[i];
            UIViewController *inner = [cand isKindOfClass:UINavigationController.class]
                ? ((UINavigationController *)cand).viewControllers.firstObject : cand;
            NSString *clsStr = NSStringFromClass(inner.class);
            if ((feedCls && [inner isKindOfClass:feedCls]) ||
                (listCls && [inner isKindOfClass:listCls]) ||
                (contCls && [inner isKindOfClass:contCls]) ||
                [clsStr containsString:@"ShortVideo"] || [clsStr containsString:@"VideoSeries"]) {
                if ([tc.selectedViewController isKindOfClass:UINavigationController.class]) {
                    UINavigationController *curNav = (UINavigationController *)tc.selectedViewController;
                    if (curNav.presentedViewController) [curNav dismissViewControllerAnimated:YES completion:nil];
                }
                tc.selectedIndex = i;
                if ([cand isKindOfClass:UINavigationController.class]) {
                    UINavigationController *dramaNav = (UINavigationController *)cand;
                    if (sLastDramaListVC && [dramaNav.viewControllers containsObject:sLastDramaListVC]) {
                        [dramaNav popToViewController:sLastDramaListVC animated:YES];
                    }
                }
                return;
            }
        }
    }
}

@interface FQXIslandWaveformView : UIView
@property(nonatomic, copy) NSArray<CALayer *> *barLayers;
@property(nonatomic) BOOL animatingWave;
- (void)setPlaying:(BOOL)playing accentColor:(UIColor *)color;
@end

@implementation FQXIslandWaveformView
- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        self.userInteractionEnabled = NO;
        NSMutableArray<CALayer *> *bars = [NSMutableArray arrayWithCapacity:4];
        for (NSUInteger i = 0; i < 4; ++i) {
            CALayer *bar = [CALayer layer];
            bar.cornerRadius = 1.3;
            bar.backgroundColor = UIColor.whiteColor.CGColor;
            [self.layer addSublayer:bar];
            [bars addObject:bar];
        }
        _barLayers = bars;
    }
    return self;
}

- (void)layoutSubviews {
    [super layoutSubviews];
    CGFloat w = CGRectGetWidth(self.bounds);
    CGFloat h = CGRectGetHeight(self.bounds);
    CGFloat barW = 2.6;
    CGFloat gap = 2.4;
    CGFloat totalW = 4.0 * barW + 3.0 * gap;
    CGFloat startX = (w - totalW) * 0.5;
    static const CGFloat restHeights[4] = { 5.0, 9.0, 7.0, 4.5 };
    [CATransaction begin];
    [CATransaction setDisableActions:YES];
    for (NSUInteger i = 0; i < self.barLayers.count; ++i) {
        CALayer *bar = self.barLayers[i];
        CGFloat bh = restHeights[i];
        bar.position = CGPointMake(startX + (CGFloat)i * (barW + gap) + barW * 0.5, h * 0.5);
        if (!self.animatingWave) {
            bar.bounds = CGRectMake(0.0, 0.0, barW, bh);
        }
    }
    [CATransaction commit];
}

- (void)setPlaying:(BOOL)playing accentColor:(UIColor *)color {
    UIColor *effective = color ?: UIColor.whiteColor;
    for (CALayer *bar in self.barLayers) {
        bar.backgroundColor = effective.CGColor;
    }
    if (self.animatingWave == playing) return;
    self.animatingWave = playing;
    static const CGFloat minH[4] = { 4.0, 5.0, 4.5, 4.0 };
    static const CGFloat maxH[4] = { 13.5, 17.5, 15.0, 11.5 };
    static const CFTimeInterval durs[4] = { 0.39, 0.52, 0.44, 0.58 };
    for (NSUInteger i = 0; i < self.barLayers.count; ++i) {
        CALayer *bar = self.barLayers[i];
        [bar removeAnimationForKey:@"fqx.wave"];
        if (playing) {
            bar.bounds = CGRectMake(0.0, 0.0, 2.6, minH[i]);
            CABasicAnimation *anim = [CABasicAnimation animationWithKeyPath:@"bounds.size.height"];
            anim.fromValue = @(minH[i]);
            anim.toValue = @(maxH[i]);
            anim.duration = durs[i];
            anim.autoreverses = YES;
            anim.repeatCount = HUGE_VALF;
            anim.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseInEaseOut];
            [bar addAnimation:anim forKey:@"fqx.wave"];
        } else {
            bar.bounds = CGRectMake(0.0, 0.0, 2.6, minH[i] + (i == 1 ? 3.5 : 1.5));
        }
    }
}
@end

@interface FQXDynamicIslandOverlayView : UIView
@property(nonatomic, strong) UIView *islandCard;
@property(nonatomic, strong) UIImageView *miniCoverView;
@property(nonatomic, strong) UILabel *miniCenterLabel;
@property(nonatomic, strong) FQXIslandWaveformView *miniWaveView;
@property(nonatomic, strong) UIView *expandedContent;
@property(nonatomic, strong) UIImageView *largeCoverView;
@property(nonatomic, strong) UILabel *titleLabel;
@property(nonatomic, strong) UILabel *subtitleLabel;
@property(nonatomic, strong) UIButton *infoTapButton;
@property(nonatomic, strong) UIButton *openButton;
@property(nonatomic, strong) UIButton *closeButton;
@property(nonatomic, strong) UIButton *prevButton;
@property(nonatomic, strong) UIButton *playPauseButton;
@property(nonatomic, strong) UIButton *nextButton;
@property(nonatomic, strong) FQXIslandWaveformView *expandedWaveView;
@property(nonatomic, strong) UILabel *badgeLabel;
@property(nonatomic) BOOL expanded;
@property(nonatomic) FQXIslandActiveKind activeKind;
@property(nonatomic) BOOL currentlyPlaying;
- (void)updateWithKind:(FQXIslandActiveKind)kind
                 title:(NSString *)title
              subtitle:(NSString *)subtitle
                 cover:(UIImage *)cover
               playing:(BOOL)playing;
- (void)setExpanded:(BOOL)expanded animated:(BOOL)animated;
@end

@implementation FQXDynamicIslandOverlayView

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        self.backgroundColor = UIColor.clearColor;
        self.opaque = NO;
        self.overrideUserInterfaceStyle = UIUserInterfaceStyleDark;
        self.layer.zPosition = 9999.0;

        UITapGestureRecognizer *bgTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(onOutsideTap)];
        [self addGestureRecognizer:bgTap];

        _islandCard = [[UIView alloc] initWithFrame:CGRectZero];
        _islandCard.backgroundColor = UIColor.blackColor;
        _islandCard.clipsToBounds = YES;
        _islandCard.layer.cornerCurve = kCACornerCurveContinuous;
        _islandCard.layer.borderWidth = 0.65;
        _islandCard.layer.borderColor = [UIColor colorWithWhite:1.0 alpha:0.15].CGColor;
        _islandCard.layer.shadowColor = UIColor.blackColor.CGColor;
        _islandCard.layer.shadowOpacity = 0.28;
        _islandCard.layer.shadowRadius = 12.0;
        _islandCard.layer.shadowOffset = CGSizeMake(0.0, 5.0);
        [self addSubview:_islandCard];

        UITapGestureRecognizer *cardTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(onCardTap)];
        [_islandCard addGestureRecognizer:cardTap];

        UISwipeGestureRecognizer *swipeUp = [[UISwipeGestureRecognizer alloc] initWithTarget:self action:@selector(onSwipeUp)];
        swipeUp.direction = UISwipeGestureRecognizerDirectionUp;
        [_islandCard addGestureRecognizer:swipeUp];

        _miniCoverView = [[UIImageView alloc] initWithFrame:CGRectZero];
        _miniCoverView.contentMode = UIViewContentModeScaleAspectFill;
        _miniCoverView.clipsToBounds = YES;
        _miniCoverView.layer.cornerRadius = 6.5;
        _miniCoverView.layer.cornerCurve = kCACornerCurveContinuous;
        _miniCoverView.backgroundColor = [UIColor colorWithWhite:1.0 alpha:0.12];
        [_islandCard addSubview:_miniCoverView];

        _miniCenterLabel = [[UILabel alloc] initWithFrame:CGRectZero];
        _miniCenterLabel.font = [UIFont systemFontOfSize:12.0 weight:UIFontWeightSemibold];
        _miniCenterLabel.textColor = [UIColor colorWithWhite:1.0 alpha:0.92];
        _miniCenterLabel.textAlignment = NSTextAlignmentCenter;
        _miniCenterLabel.lineBreakMode = NSLineBreakByTruncatingTail;
        [_islandCard addSubview:_miniCenterLabel];

        _miniWaveView = [[FQXIslandWaveformView alloc] initWithFrame:CGRectZero];
        [_islandCard addSubview:_miniWaveView];

        _expandedContent = [[UIView alloc] initWithFrame:CGRectZero];
        _expandedContent.alpha = 0.0;
        _expandedContent.hidden = YES;
        [_islandCard addSubview:_expandedContent];

        _largeCoverView = [[UIImageView alloc] initWithFrame:CGRectZero];
        _largeCoverView.contentMode = UIViewContentModeScaleAspectFill;
        _largeCoverView.clipsToBounds = YES;
        _largeCoverView.layer.cornerRadius = 10.0;
        _largeCoverView.layer.cornerCurve = kCACornerCurveContinuous;
        _largeCoverView.backgroundColor = [UIColor colorWithWhite:1.0 alpha:0.12];
        [_expandedContent addSubview:_largeCoverView];

        _titleLabel = [[UILabel alloc] initWithFrame:CGRectZero];
        _titleLabel.font = [UIFont systemFontOfSize:15.0 weight:UIFontWeightSemibold];
        _titleLabel.textColor = UIColor.whiteColor;
        _titleLabel.lineBreakMode = NSLineBreakByTruncatingTail;
        [_expandedContent addSubview:_titleLabel];

        _subtitleLabel = [[UILabel alloc] initWithFrame:CGRectZero];
        _subtitleLabel.font = [UIFont systemFontOfSize:12.5 weight:UIFontWeightRegular];
        _subtitleLabel.textColor = [UIColor colorWithWhite:1.0 alpha:0.68];
        _subtitleLabel.lineBreakMode = NSLineBreakByTruncatingTail;
        [_expandedContent addSubview:_subtitleLabel];

        _infoTapButton = [UIButton buttonWithType:UIButtonTypeCustom];
        [_infoTapButton addTarget:self action:@selector(onOpenTapped) forControlEvents:UIControlEventTouchUpInside];
        [_expandedContent addSubview:_infoTapButton];

        UIImageSymbolConfiguration *hdrSym = [UIImageSymbolConfiguration configurationWithPointSize:19.0 weight:UIImageSymbolWeightMedium];
        _openButton = [UIButton buttonWithType:UIButtonTypeSystem];
        [_openButton setImage:[UIImage systemImageNamed:@"arrow.up.forward.circle.fill" withConfiguration:hdrSym] forState:UIControlStateNormal];
        _openButton.tintColor = [UIColor colorWithWhite:1.0 alpha:0.78];
        [_openButton addTarget:self action:@selector(onOpenTapped) forControlEvents:UIControlEventTouchUpInside];
        [_expandedContent addSubview:_openButton];

        _closeButton = [UIButton buttonWithType:UIButtonTypeSystem];
        [_closeButton setImage:[UIImage systemImageNamed:@"xmark.circle.fill" withConfiguration:hdrSym] forState:UIControlStateNormal];
        _closeButton.tintColor = [UIColor colorWithWhite:1.0 alpha:0.56];
        [_closeButton addTarget:self action:@selector(onCloseTapped) forControlEvents:UIControlEventTouchUpInside];
        [_expandedContent addSubview:_closeButton];

        UIImageSymbolConfiguration *stepSym = [UIImageSymbolConfiguration configurationWithPointSize:20.0 weight:UIImageSymbolWeightSemibold];
        _prevButton = [UIButton buttonWithType:UIButtonTypeSystem];
        [_prevButton setImage:[UIImage systemImageNamed:@"backward.end.fill" withConfiguration:stepSym] forState:UIControlStateNormal];
        _prevButton.tintColor = UIColor.whiteColor;
        [_prevButton addTarget:self action:@selector(onPrevTapped) forControlEvents:UIControlEventTouchUpInside];
        [_expandedContent addSubview:_prevButton];

        _playPauseButton = [UIButton buttonWithType:UIButtonTypeSystem];
        _playPauseButton.tintColor = UIColor.whiteColor;
        [_playPauseButton addTarget:self action:@selector(onPlayPauseTapped) forControlEvents:UIControlEventTouchUpInside];
        [_expandedContent addSubview:_playPauseButton];

        _nextButton = [UIButton buttonWithType:UIButtonTypeSystem];
        [_nextButton setImage:[UIImage systemImageNamed:@"forward.end.fill" withConfiguration:stepSym] forState:UIControlStateNormal];
        _nextButton.tintColor = UIColor.whiteColor;
        [_nextButton addTarget:self action:@selector(onNextTapped) forControlEvents:UIControlEventTouchUpInside];
        [_expandedContent addSubview:_nextButton];

        _expandedWaveView = [[FQXIslandWaveformView alloc] initWithFrame:CGRectZero];
        [_expandedContent addSubview:_expandedWaveView];

        _badgeLabel = [[UILabel alloc] initWithFrame:CGRectZero];
        _badgeLabel.font = [UIFont systemFontOfSize:11.0 weight:UIFontWeightSemibold];
        _badgeLabel.textAlignment = NSTextAlignmentCenter;
        _badgeLabel.textColor = [UIColor colorWithWhite:1.0 alpha:0.75];
        _badgeLabel.backgroundColor = [UIColor colorWithWhite:1.0 alpha:0.12];
        _badgeLabel.layer.cornerRadius = 9.0;
        _badgeLabel.layer.masksToBounds = YES;
        [_expandedContent addSubview:_badgeLabel];
    }
    return self;
}

- (UIView *)hitTest:(CGPoint)point withEvent:(UIEvent *)event {
    if (self.hidden || self.alpha < 0.02 || self.activeKind == FQXIslandActiveNone) return nil;
    CGPoint pInCard = [self convertPoint:point toView:self.islandCard];
    if ([self.islandCard pointInside:pInCard withEvent:event]) {
        return [super hitTest:point withEvent:event];
    }
    if (self.expanded) {
        return self;
    }
    return nil;
}

- (BOOL)hasHardwareCutout {
    CGFloat safeTop = self.window ? self.window.safeAreaInsets.top : self.safeAreaInsets.top;
    return safeTop >= 51.0;
}

- (void)layoutIslandGeometry {
    CGFloat winW = CGRectGetWidth(self.bounds);
    if (winW < 100.0) return;
    CGFloat safeTop = self.window ? self.window.safeAreaInsets.top : self.safeAreaInsets.top;
    BOOL cutout = [self hasHardwareCutout];

    if (!self.expanded) {
        CGFloat pillW = cutout ? 216.0 : 212.0;
        CGFloat pillH = cutout ? 37.0 : 36.0;
        CGFloat pillY = cutout ? 11.0 : MAX(8.0, safeTop + 2.0);
        self.islandCard.frame = CGRectMake((winW - pillW) * 0.5, pillY, pillW, pillH);
        self.islandCard.layer.cornerRadius = pillH * 0.5;

        self.miniCoverView.frame = CGRectMake(7.5, (pillH - 25.0) * 0.5, 25.0, 25.0);
        self.miniWaveView.frame = CGRectMake(pillW - 7.5 - 22.0, (pillH - 20.0) * 0.5, 22.0, 20.0);
        self.miniCenterLabel.hidden = cutout;
        if (!cutout) {
            self.miniCenterLabel.frame = CGRectMake(38.0, 0.0, pillW - 74.0, pillH);
        }
        self.expandedContent.frame = self.islandCard.bounds;
    } else {
        CGFloat cardW = MIN(winW - 24.0, 392.0);
        CGFloat cardY = cutout ? 11.0 : MAX(8.0, safeTop + 4.0);
        CGFloat topPad = cutout ? 48.0 : 14.0;
        CGFloat cardH = topPad + 98.0;
        self.islandCard.frame = CGRectMake((winW - cardW) * 0.5, cardY, cardW, cardH);
        self.islandCard.layer.cornerRadius = 38.0;

        self.expandedContent.frame = self.islandCard.bounds;
        self.largeCoverView.frame = CGRectMake(18.0, topPad, 44.0, 44.0);
        CGFloat textX = 72.0;
        CGFloat rightBtnsX = cardW - 86.0;
        CGFloat textW = MAX(60.0, rightBtnsX - textX - 6.0);
        self.titleLabel.frame = CGRectMake(textX, topPad + 2.0, textW, 21.0);
        self.subtitleLabel.frame = CGRectMake(textX, topPad + 24.0, textW, 18.0);
        self.infoTapButton.frame = CGRectMake(14.0, topPad - 2.0, rightBtnsX - 16.0, 48.0);

        self.openButton.frame = CGRectMake(cardW - 84.0, topPad + 5.0, 34.0, 34.0);
        self.closeButton.frame = CGRectMake(cardW - 46.0, topPad + 5.0, 34.0, 34.0);

        CGFloat ctrlY = topPad + 52.0;
        self.expandedWaveView.frame = CGRectMake(22.0, ctrlY + 9.0, 24.0, 20.0);
        self.prevButton.frame = CGRectMake(cardW * 0.5 - 104.0, ctrlY - 1.0, 56.0, 40.0);
        self.playPauseButton.frame = CGRectMake(cardW * 0.5 - 32.0, ctrlY - 3.0, 64.0, 44.0);
        self.nextButton.frame = CGRectMake(cardW * 0.5 + 48.0, ctrlY - 1.0, 56.0, 40.0);
        self.badgeLabel.frame = CGRectMake(cardW - 60.0, ctrlY + 10.0, 42.0, 18.0);
    }
}

- (void)layoutSubviews {
    [super layoutSubviews];
    [self layoutIslandGeometry];
}

- (void)setExpanded:(BOOL)expanded animated:(BOOL)animated {
    if (_expanded == expanded) return;
    _expanded = expanded;
    if (expanded) {
        self.expandedContent.hidden = NO;
    }
    void (^apply)(void) = ^{
        [self layoutIslandGeometry];
        self.miniCoverView.alpha = expanded ? 0.0 : 1.0;
        self.miniWaveView.alpha = expanded ? 0.0 : 1.0;
        self.miniCenterLabel.alpha = expanded ? 0.0 : 1.0;
        self.expandedContent.alpha = expanded ? 1.0 : 0.0;
    };
    void (^done)(BOOL) = ^(__unused BOOL finished) {
        if (!self.expanded) {
            self.expandedContent.hidden = YES;
        }
    };
    if (animated) {
        UIImpactFeedbackGenerator *gen = [[UIImpactFeedbackGenerator alloc] initWithStyle:UIImpactFeedbackStyleLight];
        [gen impactOccurred];
        [UIView animateWithDuration:0.42
                              delay:0.0
             usingSpringWithDamping:0.80
              initialSpringVelocity:0.25
                            options:UIViewAnimationOptionBeginFromCurrentState | UIViewAnimationOptionAllowUserInteraction
                         animations:apply
                         completion:done];
    } else {
        apply();
        done(YES);
    }
}

- (void)updateWithKind:(FQXIslandActiveKind)kind
                 title:(NSString *)title
              subtitle:(NSString *)subtitle
                 cover:(UIImage *)cover
               playing:(BOOL)playing {
    self.activeKind = kind;
    self.currentlyPlaying = playing;
    BOOL isAudio = (kind == FQXIslandActiveAudiobook);

    UIColor *accent = isAudio
        ? [UIColor colorWithRed:1.00 green:0.56 blue:0.32 alpha:1.0]
        : [UIColor colorWithRed:0.38 green:0.78 blue:1.00 alpha:1.0];

    UIImage *fallbackImg = nil;
    if (!cover) {
        UIImageSymbolConfiguration *fbCfg = [UIImageSymbolConfiguration configurationWithPointSize:14.0 weight:UIImageSymbolWeightSemibold];
        fallbackImg = [[UIImage systemImageNamed:(isAudio ? @"headphones" : @"play.tv.fill") withConfiguration:fbCfg]
            imageWithTintColor:accent renderingMode:UIImageRenderingModeAlwaysOriginal];
    }
    self.miniCoverView.contentMode = cover ? UIViewContentModeScaleAspectFill : UIViewContentModeCenter;
    self.largeCoverView.contentMode = cover ? UIViewContentModeScaleAspectFill : UIViewContentModeCenter;
    self.miniCoverView.image = cover ?: fallbackImg;
    self.largeCoverView.image = cover ?: fallbackImg;

    self.miniCenterLabel.text = title;
    self.titleLabel.text = title;
    self.subtitleLabel.text = subtitle;
    self.badgeLabel.text = isAudio ? @"听书" : @"短剧";

    UIImageSymbolConfiguration *ppCfg = [UIImageSymbolConfiguration configurationWithPointSize:25.0 weight:UIImageSymbolWeightBold];
    NSString *ppSym = playing ? @"pause.fill" : @"play.fill";
    [self.playPauseButton setImage:[UIImage systemImageNamed:ppSym withConfiguration:ppCfg] forState:UIControlStateNormal];
    self.playPauseButton.accessibilityLabel = playing ? @"暂停" : @"播放";
    self.prevButton.accessibilityLabel = isAudio ? @"上一章" : @"上一集";
    self.nextButton.accessibilityLabel = isAudio ? @"下一章" : @"下一集";

    [self.miniWaveView setPlaying:playing accentColor:accent];
    [self.expandedWaveView setPlaying:playing accentColor:accent];
    [self layoutIslandGeometry];
}

- (void)onCardTap {
    if (!self.expanded) {
        [self setExpanded:YES animated:YES];
    }
}

- (void)onOutsideTap {
    if (self.expanded) {
        [self setExpanded:NO animated:YES];
    }
}

- (void)onSwipeUp {
    if (self.expanded) {
        [self setExpanded:NO animated:YES];
    }
}

- (void)onPrevTapped {
    UIImpactFeedbackGenerator *gen = [[UIImpactFeedbackGenerator alloc] initWithStyle:UIImpactFeedbackStyleLight];
    [gen impactOccurred];
    if (self.activeKind == FQXIslandActiveAudiobook) {
        FQXAudioStepChapter(-1);
    } else if (self.activeKind == FQXIslandActiveDrama) {
        FQXDramaStepEpisode(-1);
    }
}

- (void)onPlayPauseTapped {
    UIImpactFeedbackGenerator *gen = [[UIImpactFeedbackGenerator alloc] initWithStyle:UIImpactFeedbackStyleLight];
    [gen impactOccurred];
    if (self.activeKind == FQXIslandActiveAudiobook) {
        FQXAudioTogglePlayPauseAction();
    } else if (self.activeKind == FQXIslandActiveDrama) {
        FQXDramaTogglePlayPauseAction();
    }
}

- (void)onNextTapped {
    UIImpactFeedbackGenerator *gen = [[UIImpactFeedbackGenerator alloc] initWithStyle:UIImpactFeedbackStyleLight];
    [gen impactOccurred];
    if (self.activeKind == FQXIslandActiveAudiobook) {
        FQXAudioStepChapter(1);
    } else if (self.activeKind == FQXIslandActiveDrama) {
        FQXDramaStepEpisode(1);
    }
}

- (void)onOpenTapped {
    FQXIslandActiveKind kind = self.activeKind;
    [self setExpanded:NO animated:NO];
    if (kind == FQXIslandActiveAudiobook) {
        FQXOpenAudiobookPlayerPage();
    } else if (kind == FQXIslandActiveDrama) {
        FQXOpenDramaPlayerPage();
    }
}

- (void)onCloseTapped {
    FQXIslandActiveKind kind = self.activeKind;
    [self setExpanded:NO animated:NO];
    if (kind == FQXIslandActiveAudiobook) {
        FQXAudioStopSessionAction();
    } else if (kind == FQXIslandActiveDrama) {
        FQXStopDramaIslandSession(YES);
    }
    FQXRefreshDynamicIslandState();
}

@end

static FQXDynamicIslandOverlayView *sIslandOverlay = nil;

static void FQXRefreshDynamicIslandState(void) {
    NSUserDefaults *ud = NSUserDefaults.standardUserDefaults;
    BOOL audioIslandOn = [ud boolForKey:AudioDynamicIslandPrefKey];
    BOOL dramaIslandOn = [ud boolForKey:DramaDynamicIslandPrefKey];

    for (UIView *ind in [FQXTrackedAudioIndicators() allObjects]) {
        FQXApplyIndicatorIslandMuteIfNeeded(ind);
    }

    BOOL audioAlive = FQXIsAudioBookSessionAlive();
    if (audioAlive && sDramaIslandActive) {
        FQXStopDramaIslandSession(YES);
    }
    if (!dramaIslandOn && sDramaIslandActive) {
        FQXStopDramaIslandSession(YES);
    }

    BOOL inBackground = (UIApplication.sharedApplication.applicationState != UIApplicationStateActive);
    BOOL dramaVisible = !inBackground && FQXIsDramaScreenCurrentlyVisible();
    if (dramaVisible && sDramaIslandActive) {
        sDramaIslandActive = NO;
        sDramaIslandUserPaused = NO;
        FQXSetDramaRemoteCommandsRegistered(NO);
    }

    if (sDramaIslandActive) {
        if (!sLastDramaPlayer) {
            FQXStopDramaIslandSession(NO);
        } else {
            FQXSetDramaRemoteCommandsRegistered(YES);
            FQXUpdateDramaSystemNowPlaying();
        }
    }

    FQXIslandActiveKind targetKind = FQXIslandActiveNone;
    if (!inBackground) {
        if (audioIslandOn && audioAlive && !FQXIsAudioFullPlayerCurrentlyVisible()) {
            targetKind = FQXIslandActiveAudiobook;
        } else if (dramaIslandOn && sDramaIslandActive && !dramaVisible) {
            targetKind = FQXIslandActiveDrama;
        }
    }

    if (targetKind == FQXIslandActiveNone) {
        if (sIslandOverlay && !sIslandOverlay.hidden) {
            [sIslandOverlay setExpanded:NO animated:NO];
            sIslandOverlay.activeKind = FQXIslandActiveNone;
            sIslandOverlay.hidden = YES;
        }
        return;
    }

    UIWindow *win = FQXActiveForegroundWindow();
    if (!win) return;
    if (!sIslandOverlay) {
        sIslandOverlay = [[FQXDynamicIslandOverlayView alloc] initWithFrame:win.bounds];
        sIslandOverlay.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
    }
    if (sIslandOverlay.superview != win) {
        sIslandOverlay.frame = win.bounds;
        [win addSubview:sIslandOverlay];
    } else {
        [win bringSubviewToFront:sIslandOverlay];
    }

    NSString *title = nil;
    NSString *subtitle = nil;
    UIImage *cover = nil;
    BOOL playing = NO;
    if (targetKind == FQXIslandActiveAudiobook) {
        FQXExtractAudioMetadata(&title, &subtitle, &cover);
        playing = FQXAudioIsCurrentlyPlaying();
    } else {
        double dur = 0.0, cur = 0.0;
        FQXExtractDramaMetadata(&title, &subtitle, &cover, &dur, &cur);
        playing = FQXDramaIsCurrentlyPlaying();
    }

    [sIslandOverlay updateWithKind:targetKind title:title subtitle:subtitle cover:cover playing:playing];
    if (sIslandOverlay.hidden) {
        sIslandOverlay.alpha = 0.0;
        sIslandOverlay.hidden = NO;
        [UIView animateWithDuration:0.22 animations:^{
            sIslandOverlay.alpha = 1.0;
        }];
    }
}

static void FQXScheduleDynamicIslandRefresh(void) {
    if (sDynamicIslandRefreshPending) return;
    sDynamicIslandRefreshPending = YES;
    dispatch_async(dispatch_get_main_queue(), ^{
        sDynamicIslandRefreshPending = NO;
        FQXRefreshDynamicIslandState();
    });
}

static void FQXEnterDramaIslandOnLeaveIfEligible(void) {
    if (![NSUserDefaults.standardUserDefaults boolForKey:DramaDynamicIslandPrefKey]) return;
    if (FQXIsAudioBookSessionAlive() || !sLastDramaPlayer) return;
    CFTimeInterval now = CACurrentMediaTime();
    BOOL recentlyPlaying = FQXDramaIsCurrentlyPlaying() ||
                           (!sDramaManuallyPausedInFeed && (now - sLastDramaPlayingTimestamp) < 1.35);
    if (!recentlyPlaying && !sDramaIslandActive) return;

    sLastDramaLeavingTimestamp = now;
    sDramaIslandActive = YES;
    sDramaIslandUserPaused = NO;
    FQXActivateDramaAudioSession();
    FQXSetDramaRemoteCommandsRegistered(YES);
    if (!FQXDramaIsCurrentlyPlaying()) {
        FQXVoidMsg0Safe(sLastDramaPlayer, "play");
        id eng = FQXObjGet(sLastDramaPlayer, "videoEngine") ?: sLastDramaEngine;
        if (!FQXDramaIsCurrentlyPlaying() && eng) FQXVoidMsg0Safe(eng, "play");
    }
    FQXUpdateDramaSystemNowPlaying();
    FQXScheduleDynamicIslandRefresh();

    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.12 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        if (!sDramaIslandActive || sDramaIslandUserPaused || FQXIsAudioBookSessionAlive()) return;
        if (!FQXIsDramaScreenCurrentlyVisible() ||
            UIApplication.sharedApplication.applicationState != UIApplicationStateActive) {
            if (!FQXDramaIsCurrentlyPlaying() && sLastDramaPlayer) {
                FQXActivateDramaAudioSession();
                FQXVoidMsg0Safe(sLastDramaPlayer, "play");
            }
            FQXUpdateDramaSystemNowPlaying();
            FQXRefreshDynamicIslandState();
        }
    });
}

BOOL FQXIsDramaDynamicIslandSessionActive(void) {
    return sDramaIslandActive && [NSUserDefaults.standardUserDefaults boolForKey:DramaDynamicIslandPrefKey];
}

void FQXNotifyAudioIslandStateChanged(void) {
    if (NSThread.isMainThread) {
        FQXScheduleDynamicIslandRefresh();
    } else {
        dispatch_async(dispatch_get_main_queue(), ^{
            FQXScheduleDynamicIslandRefresh();
        });
    }
}

void FQXNotifyDramaPlayerStateChanged(UIView *player, id engine, NSInteger state) {
    void (^work)(void) = ^{
        if (player) {
            sLastDramaPlayer = player;
            FQXCacheDramaAncestorsFromView(player);
        }
        if (engine) sLastDramaEngine = engine;
        CFTimeInterval now = CACurrentMediaTime();
        if (state == 1) {
            sLastDramaPlayingTimestamp = now;
            sDramaManuallyPausedInFeed = NO;
            sDramaIslandUserPaused = NO;
        } else if (state == 2) {
            if (sDramaIslandActive) {
                if (!sDramaIslandUserPaused && (now - sLastDramaLeavingTimestamp) < 0.85 &&
                    !FQXIsAudioBookSessionAlive()) {
                    FQXActivateDramaAudioSession();
                    FQXVoidMsg0Safe(player, "play");
                }
            } else if (FQXIsDramaScreenCurrentlyVisible() &&
                       UIApplication.sharedApplication.applicationState == UIApplicationStateActive) {
                CFTimeInterval pausedAt = now;
                dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.35 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                    if (!sDramaIslandActive && FQXIsDramaScreenCurrentlyVisible() &&
                        UIApplication.sharedApplication.applicationState == UIApplicationStateActive &&
                        !FQXDramaIsCurrentlyPlaying() && sLastDramaPlayingTimestamp < pausedAt) {
                        sDramaManuallyPausedInFeed = YES;
                    }
                });
            }
        }
        if (sDramaIslandActive) {
            FQXUpdateDramaSystemNowPlaying();
            FQXScheduleDynamicIslandRefresh();
        }
    };
    if (NSThread.isMainThread) {
        work();
    } else {
        dispatch_async(dispatch_get_main_queue(), work);
    }
}

static void FQXNoteDramaControllerAppeared(UIViewController *vc) {
    Class listCls = NSClassFromString(@"FQVShortVideoListViewController");
    Class feedCls = NSClassFromString(@"SSVideoSeriesFeedViewController");
    if (listCls && [vc isKindOfClass:listCls]) sLastDramaListVC = vc;
    if (feedCls && [vc isKindOfClass:feedCls]) sLastDramaFeedVC = vc;
    FQXScheduleDynamicIslandRefresh();
}

static void FQXNoteDramaControllerWillDisappear(UIViewController *vc) {
    Class listCls = NSClassFromString(@"FQVShortVideoListViewController");
    Class feedCls = NSClassFromString(@"SSVideoSeriesFeedViewController");
    if (listCls && [vc isKindOfClass:listCls]) sLastDramaListVC = vc;
    if (feedCls && [vc isKindOfClass:feedCls]) sLastDramaFeedVC = vc;
    dispatch_async(dispatch_get_main_queue(), ^{
        if (!FQXIsDramaScreenCurrentlyVisible()) {
            FQXEnterDramaIslandOnLeaveIfEligible();
        }
    });
}

static void FQXNoteDramaPlayerReady(UIView *player, id engine) {
    if (player) {
        sLastDramaPlayer = player;
        FQXCacheDramaAncestorsFromView(player);
    }
    if (engine) sLastDramaEngine = engine;
    if (FQXDramaIsCurrentlyPlaying()) {
        sLastDramaPlayingTimestamp = CACurrentMediaTime();
        sDramaManuallyPausedInFeed = NO;
    }
    if (sDramaIslandActive) {
        FQXUpdateDramaSystemNowPlaying();
        FQXScheduleDynamicIslandRefresh();
    }
}

static void FQXNoteDramaControlDisplayed(UIView *control) {
    if (!control) return;
    sLastDramaControlView = control;
    UIView *pl = FQXObjGet(control, "vPlayer");
    if ([pl isKindOfClass:UIView.class]) sLastDramaPlayer = pl;
    FQXCacheDramaAncestorsFromView(control);
    if (sDramaIslandActive) {
        FQXUpdateDramaSystemNowPlaying();
        FQXScheduleDynamicIslandRefresh();
    }
}

static void (*OrigAudioVCDidAppearIsland)(id, SEL, BOOL);
static void HookAudioVCDidAppearIsland(UIViewController *self, SEL _cmd, BOOL animated) {
    if (OrigAudioVCDidAppearIsland) OrigAudioVCDidAppearIsland(self, _cmd, animated);
    FQXScheduleDynamicIslandRefresh();
}

static void (*OrigAudioVCWillDisappearIsland)(id, SEL, BOOL);
static void HookAudioVCWillDisappearIsland(UIViewController *self, SEL _cmd, BOOL animated) {
    if (OrigAudioVCWillDisappearIsland) OrigAudioVCWillDisappearIsland(self, _cmd, animated);
    FQXScheduleDynamicIslandRefresh();
}

static void (*OrigAudioVCDidDisappearIsland)(id, SEL, BOOL);
static void HookAudioVCDidDisappearIsland(UIViewController *self, SEL _cmd, BOOL animated) {
    if (OrigAudioVCDidDisappearIsland) OrigAudioVCDidDisappearIsland(self, _cmd, animated);
    FQXScheduleDynamicIslandRefresh();
}

static void (*OrigTTSReaderDidAppearIsland)(id, SEL, BOOL);
static void HookTTSReaderDidAppearIsland(UIViewController *self, SEL _cmd, BOOL animated) {
    if (OrigTTSReaderDidAppearIsland) OrigTTSReaderDidAppearIsland(self, _cmd, animated);
    FQXScheduleDynamicIslandRefresh();
}

static void (*OrigTTSReaderDidDisappearIsland)(id, SEL, BOOL);
static void HookTTSReaderDidDisappearIsland(UIViewController *self, SEL _cmd, BOOL animated) {
    if (OrigTTSReaderDidDisappearIsland) OrigTTSReaderDidDisappearIsland(self, _cmd, animated);
    FQXScheduleDynamicIslandRefresh();
}

static BOOL FQXIsCommentComposerTextView(UIView *view) {
    if (![view isKindOfClass:UITextView.class] || !view.window) return NO;
    Class c1 = NSClassFromString(@"FQCShortVideoNewEditorView");
    Class c2 = NSClassFromString(@"FQCCommunityInputView");
    Class c3 = NSClassFromString(@"FQC503CommentInputView");
    Class c4 = NSClassFromString(@"FQCShortVideoInputView");
    Class c5 = NSClassFromString(@"FQCCommentBottomToolBar");
    NSInteger depth = 0;
    for (UIView *cur = view.superview; cur && depth < 10; cur = cur.superview, ++depth) {
        if (objc_getAssociatedObject(cur, DramaComposerGlassKey) ||
            objc_getAssociatedObject(cur, SheetGlassKey) ||
            (c1 && [cur isKindOfClass:c1]) || (c2 && [cur isKindOfClass:c2]) ||
            (c3 && [cur isKindOfClass:c3]) || (c4 && [cur isKindOfClass:c4]) ||
            (c5 && [cur isKindOfClass:c5])) {
            return YES;
        }
    }
    return NO;
}

static void FQXInstallCommentTextViewObservers(void) {
    static dispatch_once_t once;
    dispatch_once(&once, ^{
        NSNotificationCenter *nc = NSNotificationCenter.defaultCenter;
        [nc addObserverForName:UITextViewTextDidBeginEditingNotification object:nil queue:NSOperationQueue.mainQueue usingBlock:^(NSNotification *note) {
            UIView *tv = note.object;
            BOOL activeComposer = FQXCommentStylingEnabled() || FQXCurrentCommentComposerStyle() != FQXCommentComposerNative;
            if (!activeComposer || !FQXIsCommentComposerTextView(tv)) return;
            FQXStyleActiveCommentTextInput(tv);
            __weak UIView *weakTV = tv;
            dispatch_async(dispatch_get_main_queue(), ^{
                UIView *strongTV = weakTV;
                BOOL stillActive = FQXCommentStylingEnabled() || FQXCurrentCommentComposerStyle() != FQXCommentComposerNative;
                if (strongTV && stillActive && FQXIsCommentComposerTextView(strongTV)) {
                    FQXStyleActiveCommentTextInput(strongTV);
                }
            });
        }];
        [nc addObserverForName:UITextViewTextDidChangeNotification object:nil queue:NSOperationQueue.mainQueue usingBlock:^(NSNotification *note) {
            UIView *tv = note.object;
            BOOL activeComposer = FQXCommentStylingEnabled() || FQXCurrentCommentComposerStyle() != FQXCommentComposerNative;
            if (!activeComposer || !FQXIsCommentComposerTextView(tv)) return;
            FQXStyleActiveCommentTextInput(tv);
        }];
    });
}

void FQXInstallMotionAndAudioHooks(void);
static void FQXInstallPostGlassHooks(void);
void FQXInstallMotionAndAudioHooks(void) {
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        FQXInstallCommentTextViewObservers();
#define HOOK_INST(clsName, selName, enc, origVar, hookFn) do { \
    Class _c = NSClassFromString(@clsName); \
    if (_c) FQXInstallOwnedHook(_c, NSSelectorFromString(@selName), NO, enc, (IMP)(hookFn), (IMP *)&(origVar)); \
} while (0)

        HOOK_INST("SSMyUser621ViewController", "tabbarControllerCurrentBtnDidTapAt:", "v20@0:8i16", OrigMineTabBarCurrentTap, HookMineTabBarCurrentTap);
        HOOK_INST("SSMyUser621ViewController", "tabbarControllerCurrentBtnDidTapAt:", "v24@0:8q16", OrigMineTabBarCurrentTap64, HookMineTabBarCurrentTap64);
        HOOK_INST("SSMyUser621ViewController", "unlimitedBeginRefreshing:animated:", "v24@0:8B16B20", OrigMineUnlimitedRefresh, HookMineUnlimitedRefresh);
        HOOK_INST("SSVideoSeriesFeedViewController", "categoryView:scrollingFromLeftItem:atLeftIndex:toRightItem:atRightIndex:ratio:",
                  "v64@0:8@16@24q32@40q48d56", OrigDramaScrollBetweenTabs, HookDramaScrollBetweenTabs);
        HOOK_INST("SSVideoSeriesFeedViewController", "commitSelectedTabIndex:tabType:", "v28@0:8q16i24", OrigDramaCommitTabIndex, HookDramaCommitTabIndex);
        HOOK_INST("SSBookShelfFunctionCell", "layoutSubviews", "v16@0:8", OrigShelfFunctionCellLayout, HookShelfFunctionCellLayout);
        HOOK_INST("SSBookShelf525ViewController", "viewWillAppear:", "v20@0:8B16", OrigShelfWillAppearAudioDedup, HookShelfWillAppearAudioDedup);
        HOOK_INST("SSTabBarController", "impactFeedback", "v16@0:8", OrigBottomImpactFeedback, HookBottomImpactFeedback);
        HOOK_INST("SSShortVideoRightInteractionCommentView", "updateCommentLabelWithCount:", "v24@0:8q16", OrigDramaCommentCount, HookDramaCommentCount);
        HOOK_INST("SSShortVideoHostRightInteractionCommentView", "updateCommentLabelWithCount:", "v24@0:8q16", OrigHostDramaCommentCount, HookHostDramaCommentCount);
        HOOK_INST("SSShortVideoRightInteractionCommentView", "layoutSubviews", "v16@0:8", OrigDramaCommentLayout, HookDramaCommentLayout);
        HOOK_INST("SSShortVideoHostRightInteractionCommentView", "layoutSubviews", "v16@0:8", OrigHostDramaCommentLayout, HookHostDramaCommentLayout);
        HOOK_INST("FQCCommentBottomToolBar", "layoutSubviews", "v16@0:8", OrigBaseCommentBarLayout, HookBaseCommentBarLayout);
        HOOK_INST("FQCShortVideoBottomToolBar", "layoutSubviews", "v16@0:8", OrigDramaCommentBarLayout, HookDramaCommentBarLayout);
        HOOK_INST("FQCShortVideoCommentListBottomBarPlugin", "contextDidLayoutEnd", "v16@0:8", OrigBottomBarPluginDidLayoutEnd, HookBottomBarPluginDidLayoutEnd);
        HOOK_INST("FQCShortVideoCommentTopSectionPlugin", "contextDidLayoutEnd", "v16@0:8", OrigTopSectionPluginDidLayoutEnd, HookTopSectionPluginDidLayoutEnd);
        HOOK_INST("FQCShortVideoBottomToolBar", "configThemeWithDarkMode:", "v20@0:8B16", OrigDramaCommentBarTheme, HookDramaCommentBarTheme);
        HOOK_INST("FQCCommentV1BottomToolBar", "configThemeWithDarkMode:", "v20@0:8B16", OrigReaderCommentBarTheme, HookReaderCommentBarTheme);
        HOOK_INST("FQCShortVideoCommentPanelViewController", "viewDidLayoutSubviews", "v16@0:8", OrigDramaPanelLayout, HookDramaPanelLayout);
        HOOK_INST("FQCShortVideoCommentPanelViewController", "viewDidAppear:", "v20@0:8B16", OrigDramaPanelAppeared, HookDramaPanelAppeared);
        HOOK_INST("FQCShortVideoCommentPanelViewController", "setupTheme", "v16@0:8", OrigDramaPanelSetupTheme, HookDramaPanelSetupTheme);
        HOOK_INST("FQCShortVideoCommentPanelViewController", "adaptDarkModeIfNeed", "v16@0:8", OrigDramaPanelAdaptDark, HookDramaPanelAdaptDark);
        HOOK_INST("FQCShortVideoCommentPanelViewController", "traitCollectionDidChange:", "v24@0:8@16", OrigDramaPanelTraitChange, HookDramaPanelTraitChange);
        HOOK_INST("FQCShortVideoCommentPanelViewController", "onDarkModeChange:", "v20@0:8B16", OrigDramaPanelDarkChange, HookDramaPanelDarkChange);
        HOOK_INST("FQCShortVideoCommentListViewController", "viewDidLayoutSubviews", "v16@0:8", OrigDramaCommentListLayout, HookDramaCommentListLayout);
        HOOK_INST("FQCShortVideoCommentListViewController", "viewDidAppear:", "v20@0:8B16", OrigDramaCommentListAppeared, HookDramaCommentListAppeared);
        HOOK_INST("FQCShortVideoCommentListViewController", "setupTheme", "v16@0:8", OrigDramaCommentListSetupTheme, HookDramaCommentListSetupTheme);
        HOOK_INST("FQCShortVideoCommentListViewController", "adaptDarkModeIfNeed", "v16@0:8", OrigDramaCommentListAdaptDark, HookDramaCommentListAdaptDark);
        HOOK_INST("FQCShortVideoCommentListViewController", "traitCollectionDidChange:", "v24@0:8@16", OrigDramaCommentListTraitChange, HookDramaCommentListTraitChange);
        HOOK_INST("FQCShortVideoCommentListViewController", "onDarkModeChange:", "v20@0:8B16", OrigDramaCommentListDarkChange, HookDramaCommentListDarkChange);
        HOOK_INST("FQCShortVideoCommentSearchEntranceView", "layoutSubviews", "v16@0:8", OrigCommentSearchLayout, HookCommentSearchLayout);
        HOOK_INST("FQCShortVideoCommentSearchEntranceView", "configThemeWithDarkMode:", "v20@0:8B16", OrigCommentSearchTheme, HookCommentSearchTheme);
        HOOK_INST("FQCShortVideoCommentSearchEntranceView", "didMoveToWindow", "v16@0:8", OrigCommentSearchDidMoveWindow, HookCommentSearchDidMoveWindow);
        HOOK_INST("FQCShortVideoCommentSearchEntranceView", "setHidden:", "v20@0:8B16", OrigCommentSearchSetHidden, HookCommentSearchSetHidden);
        HOOK_INST("FQCShortVideoCommentSearchEntranceView", "setAlpha:", "v24@0:8d16", OrigCommentSearchSetAlpha, HookCommentSearchSetAlpha);
        HOOK_INST("FQCShortVideoCommentSearchEntranceView", "setFrame:", "v48@0:8{CGRect={CGPoint=dd}{CGSize=dd}}16", OrigCommentSearchSetFrame, HookCommentSearchSetFrame);
        HOOK_INST("FQCShortPlaySeriesCommentListViewController", "viewDidLayoutSubviews", "v16@0:8", OrigSeriesCommentLayout, HookSeriesCommentLayout);
        HOOK_INST("FQCShortPlaySeriesCommentListViewController", "viewDidAppear:", "v20@0:8B16", OrigSeriesCommentAppeared, HookSeriesCommentAppeared);
        HOOK_INST("FQCShortPlaySeriesCommentListViewController", "traitCollectionDidChange:", "v24@0:8@16", OrigSeriesCommentTraitChange, HookSeriesCommentTraitChange);
        HOOK_INST("FQCShortPlaySeriesCommentListViewController", "updateWriteReviewButtonUIAnimated:", "v20@0:8B16", OrigSeriesWriteReviewUpdate, HookSeriesWriteReviewUpdate);
        HOOK_INST("FQCShortPlaySeriesCommentListViewController", "setWriteReviewButtonHidden:animated:", "v24@0:8B16B20", OrigSeriesWriteReviewHidden, HookSeriesWriteReviewHidden);
        HOOK_INST("FQCShortPlaySeriesCommentCell", "layoutSubviews", "v16@0:8", OrigSeriesCommentCellLayout, HookSeriesCommentCellLayout);
        HOOK_INST("FQCShortPlayCommentPanelScoreView", "updateViews", "v16@0:8", OrigSeriesScoreUpdateViews, HookSeriesScoreUpdateViews);
        HOOK_INST("FQCShortPlayCommentListHeaderView", "updateWithListViewModel:", "v24@0:8@16", OrigDramaCommentHeaderUpdate, HookDramaCommentHeaderUpdate);
        HOOK_INST("FQCShortPlayCommentListHeaderView", "resumeBackgroundView", "v16@0:8", OrigDramaCommentHeaderResume, HookDramaCommentHeaderResume);
        HOOK_INST("FQCShortVideoCommentPanelListAdapterViewController", "viewDidLayoutSubviews", "v16@0:8", OrigDramaCommentAdapterLayout, HookDramaCommentAdapterLayout);
        HOOK_INST("SSBizShortVideoKmpCommentViewController", "viewDidLayoutSubviews", "v16@0:8", OrigKMPCommentLayout, HookKMPCommentLayout);
        HOOK_INST("SSBizShortVideoCommentKMPNativeTabContainerViewController", "viewDidLayoutSubviews", "v16@0:8", OrigKMPCommentTabLayout, HookKMPCommentTabLayout);
        HOOK_INST("FQCBaseCommentListViewController", "viewDidLayoutSubviews", "v16@0:8", OrigReaderCommentListLayout, HookReaderCommentListLayout);
        HOOK_INST("FQCBaseCommentListViewController", "setupTheme", "v16@0:8", OrigBaseCommentTheme, HookBaseCommentTheme);
        HOOK_INST("FQCParagraphCommentListViewController", "setupTheme", "v16@0:8", OrigReaderCommentTheme, HookReaderCommentTheme);
        HOOK_INST("FQCParagraphCommentV1ListViewController", "setupTheme", "v16@0:8", OrigReaderCommentV1Theme, HookReaderCommentV1Theme);
        HOOK_INST("FQCParagraphCommentV1ListViewController", "viewDidAppear:", "v20@0:8B16", OrigReaderCommentV1Appeared, HookReaderCommentV1Appeared);
        HOOK_INST("FQCParagraphCommentV1ListViewController", "setupLayout", "v16@0:8", OrigReaderCommentV1Layout, HookReaderCommentV1Layout);
        HOOK_INST("FQVTransitionView", "layoutSubviews", "v16@0:8", OrigReaderCommentTransitionLayout, HookReaderCommentTransitionLayout);
        HOOK_INST("FQCShortPlayReplySectionFooterView", "layoutSubviews", "v16@0:8", OrigReplyFooterLayout, HookReplyFooterLayout);
        HOOK_INST("FQCShortPlayReplySectionFooterView", "setupTheme", "v16@0:8", OrigReplyFooterTheme, HookReplyFooterTheme);
        HOOK_INST("FQCShortVideoCommentSectionFooterView", "layoutSubviews", "v16@0:8", OrigVideoReplyFooterLayout, HookVideoReplyFooterLayout);
        HOOK_INST("FQCShortVideoCommentSectionFooterView", "setupTheme", "v16@0:8", OrigVideoReplyFooterTheme, HookVideoReplyFooterTheme);
        HOOK_INST("FQCParagraphCommentV1SectionFooterView", "layoutSubviews", "v16@0:8", OrigParaFooterLayout, HookParaFooterLayout);
        HOOK_INST("FQCParagraphCommentV1SectionFooterView", "setupTheme", "v16@0:8", OrigParaFooterTheme, HookParaFooterTheme);
        HOOK_INST("FQCShortVideoCommentCommonCell", "configTheme:", "v20@0:8B16", OrigVideoReplyCellTheme, HookVideoReplyCellTheme);
        HOOK_INST("FQCShortVideoCommentCommonCell", "layoutSubviews", "v16@0:8", OrigVideoReplyCellLayout, HookVideoReplyCellLayout);
        HOOK_INST("FQCShortVideoCommentInvisibleTipCell", "layoutSubviews", "v16@0:8", OrigInvisibleTipCellLayout, HookInvisibleTipCellLayout);
        HOOK_INST("FQCShortVideoCommentInvisibleTipCell", "bindViewModel:", "v24@0:8@16", OrigInvisibleTipCellBind, HookInvisibleTipCellBind);
        HOOK_INST("FQCCommentFoldCell", "layoutSubviews", "v16@0:8", OrigCommentFoldCellLayout, HookCommentFoldCellLayout);
        HOOK_INST("FQCCommentEmptyCell", "layoutSubviews", "v16@0:8", OrigCommentEmptyCellLayout, HookCommentEmptyCellLayout);
        HOOK_INST("FQCShortVideoCommentSeriesIntroCell", "layoutSubviews", "v16@0:8", OrigSeriesIntroCellLayout, HookSeriesIntroCellLayout);
        {
            Class _titleCls = NSClassFromString(@"FQCShortVideoCommentTitleView");
            if (_titleCls) FQXInstallOwnedHook(_titleCls, NSSelectorFromString(@"commentTitleViewHeight"), YES, "d16@0:8", (IMP)HookCommentTitleHeight, (IMP *)&OrigCommentTitleHeight);
        }
        HOOK_INST("FQCShortVideoCommentTitleView", "layoutSubviews", "v16@0:8", OrigCommentTitleLayout, HookCommentTitleLayout);
        HOOK_INST("FQCShortVideoCommentTitleView", "updateWithModels:", "v24@0:8@16", OrigCommentTitleUpdateModels, HookCommentTitleUpdateModels);
        HOOK_INST("FQCShortVideoCommentTitleView", "setHidden:", "v20@0:8B16", OrigCommentTitleSetHidden, HookCommentTitleSetHidden);
        HOOK_INST("FQCShortVideoCommentTitleView", "setAlpha:", "v24@0:8d16", OrigCommentTitleSetAlpha, HookCommentTitleSetAlpha);
        HOOK_INST("FQCParagraphV1ListCell", "bindViewModel:", "v24@0:8@16", OrigParaV1CellBind, HookParaV1CellBind);
        HOOK_INST("FQCParagraphV1ListCell", "setupTheme", "v16@0:8", OrigParaV1CellTheme, HookParaV1CellTheme);
        HOOK_INST("FQCParagraphV1ListCell", "calLayout", "v16@0:8", OrigParaV1CellLayout, HookParaV1CellLayout);
        HOOK_INST("FQCParagraphReplyV1ListCell", "setupTheme", "v16@0:8", OrigParaReplyV1CellTheme, HookParaReplyV1CellTheme);
        HOOK_INST("FQCParagraphReplyV1ListCell", "calLayout", "v16@0:8", OrigParaReplyV1CellLayout, HookParaReplyV1CellLayout);
        HOOK_INST("FQVTransitionView", "setTopContentView:", "v24@0:8@16", OrigTransitionSetTopContent, HookTransitionSetTopContent);
        HOOK_INST("FQVTransitionPlayerTopContentView", "bindPlayerView:originPlayerFrameOnWindow:", "v56@0:8@16{CGRect={CGPoint=dd}{CGSize=dd}}24", OrigTopContentBindPlayer, HookTopContentBindPlayer);
        HOOK_INST("FQVTransitionPlayerTopContentView", "unbindPlayerView:", "v24@0:8@16", OrigTopContentUnbindPlayer, HookTopContentUnbindPlayer);
        HOOK_INST("FQVTransitionPlayerLimitScaleTopContentView", "bindPlayerView:originPlayerFrameOnWindow:", "v56@0:8@16{CGRect={CGPoint=dd}{CGSize=dd}}24", OrigLimitScaleBindPlayer, HookLimitScaleBindPlayer);
        HOOK_INST("FQVTransitionPlayerLimitScaleTopContentView", "unbindPlayerView:", "v24@0:8@16", OrigLimitScaleUnbindPlayer, HookLimitScaleUnbindPlayer);
        HOOK_INST("FQCShortVideoCommentPanelViewController", "onVCWillShow", "v16@0:8", OrigDramaPanelWillShow, HookDramaPanelWillShow);
        HOOK_INST("FQCShortVideoCommentPanelViewController", "onVCDismiss", "v16@0:8", OrigDramaPanelDismiss, HookDramaPanelDismiss);
        HOOK_INST("FQCShortVideoCommentListViewController", "viewDidDisappear:", "v20@0:8B16", OrigDramaCommentListDisappeared, HookDramaCommentListDisappeared);
        HOOK_INST("FQCParagraphCommentListViewController", "viewDidDisappear:", "v20@0:8B16", OrigReaderCommentListDisappeared, HookReaderCommentListDisappeared);
        HOOK_INST("FQCShortPlaySeriesCommentListViewController", "viewDidDisappear:", "v20@0:8B16", OrigSeriesCommentListDisappeared, HookSeriesCommentListDisappeared);
        HOOK_INST("FQVTransitionView", "showInView:animated:completion:", "v36@0:8@16B24@?28", OrigTransitionShowInView, HookTransitionShowInView);
        HOOK_INST("FQVTransitionView", "dismissAnimated:completion:", "v28@0:8B16@?20", OrigTransitionDismissAnimated, HookTransitionDismissAnimated);
        HOOK_INST("SSShortVideoPlayerExitInterruptDelegate", "shouldInterruptWhenExitPlayer:exitScene:", "B32@0:8@16Q24", OrigExitInterruptShouldInterrupt, HookExitInterruptShouldInterrupt);
        HOOK_INST("SSShortVideoPlayerExitInterruptDelegate", "shouldShowCollectExitRetentioDialogOptWithContext:seriesId:", "B32@0:8@16@24", OrigExitInterruptShouldShowCollectOpt, HookExitInterruptShouldShowCollectOpt);
        HOOK_INST("SSShortVideoPlayerExitInterruptDelegate", "showAddBookShelfAlert:", "v24@0:8@16", OrigExitInterruptShowAddShelf, HookExitInterruptShowAddShelf);
        HOOK_INST("SSShortVideoPlayerExitInterruptComponent", "shouldInterruptWhenExitPlayer:", "B24@0:8@16", OrigExitInterruptComponentShould, HookExitInterruptComponentShould);
        HOOK_INST("SSAudioPlayIndicatorView", "showInView:position:", "v56@0:8@16{CGRect={CGPoint=dd}{CGSize=dd}}24", OrigAudioIndicatorShowInView, HookAudioIndicatorShowInView);
        HOOK_INST("SSAudioPlayIndicatorView", "showInView:position:", "v40@0:8@16{CGPoint=dd}24", OrigAudioIndicatorShowInViewPoint, HookAudioIndicatorShowInViewPoint);
        HOOK_INST("SSAudioPlayIndicatorView", "setFrame:", "v48@0:8{CGRect={CGPoint=dd}{CGSize=dd}}16", OrigAudioIndicatorSetFrame, HookAudioIndicatorSetFrame);
        HOOK_INST("SSAudioPlayIndicatorView", "layoutSubviews", "v16@0:8", OrigAudioIndicatorLayout, HookAudioIndicatorLayout);
        HOOK_INST("SSAudioPlayIndicatorView", "willMoveToSuperview:", "v24@0:8@16", OrigAudioIndicatorWillMove, HookAudioIndicatorWillMove);
        HOOK_INST("SSAudioPlayIndicatorView", "setHidden:", "v20@0:8B16", OrigAudioIndicatorSetHidden, HookAudioIndicatorSetHidden);
        HOOK_INST("SSAudioPlayIndicatorView", "setAlpha:", "v24@0:8d16", OrigAudioIndicatorSetAlpha, HookAudioIndicatorSetAlpha);
        HOOK_INST("SSAudioPlayIndicatorView", "didMoveToWindow", "v16@0:8", OrigAudioIndicatorDidMoveWindow, HookAudioIndicatorDidMoveWindow);
        HOOK_INST("SSAudioPlayIndicatorView", "didMoveToSuperview", "v16@0:8", OrigAudioIndicatorDidMoveSuperview, HookAudioIndicatorDidMoveSuperview);
        HOOK_INST("SSAudioPlayIndicatorView", "lockInPosition:", "v32@0:8{CGPoint=dd}16", OrigAudioIndicatorLockPos, HookAudioIndicatorLockPos);
        HOOK_INST("SSAudioPlayIndicatorView", "hoverableArea", "{CGRect={CGPoint=dd}{CGSize=dd}}16@0:8", OrigAudioIndicatorHoverableArea, HookAudioIndicatorHoverableArea);
        HOOK_INST("SSAudioPlayIndicatorView", "setIsVisible:", "v20@0:8B16", OrigAudioIndicatorSetIsVisible, HookAudioIndicatorSetIsVisible);
        HOOK_INST("SSShortVideoPlayIndicatorView", "setIsVisible:", "v20@0:8B16", OrigVideoIndicatorSetIsVisible, HookVideoIndicatorSetIsVisible);
        HOOK_INST("SSShortVideoPlayIndicatorView", "setHidden:", "v20@0:8B16", OrigVideoIndicatorSetHidden, HookVideoIndicatorSetHidden);
        HOOK_INST("SSShortVideoPlayIndicatorView", "didMoveToWindow", "v16@0:8", OrigVideoIndicatorDidMoveWindow, HookVideoIndicatorDidMoveWindow);
        HOOK_INST("BDReaderViewController", "viewWillDisappear:", "v20@0:8B16", OrigReaderViewWillDisappear, HookReaderViewWillDisappear);
        HOOK_INST("BDReaderViewController", "viewDidAppear:", "v20@0:8B16", OrigReaderViewDidAppearForDedup, HookReaderViewDidAppearForDedup);
        HOOK_INST("SSShortVideoPlayIndicatorView", "hoverMove", "v16@0:8", OrigVideoIndicatorHoverMove, HookVideoIndicatorHoverMove);
        HOOK_INST("SSShortVideoPlayIndicatorView", "moveToArea:", "v48@0:8{CGRect={CGPoint=dd}{CGSize=dd}}16", OrigVideoIndicatorMoveToArea, HookVideoIndicatorMoveToArea);
        HOOK_INST("SSShortVideoPlayIndicatorView", "hoverableArea", "{CGRect={CGPoint=dd}{CGSize=dd}}16@0:8", OrigVideoIndicatorHoverableArea, HookVideoIndicatorHoverableArea);
        HOOK_INST("SSReaderAudioAdapter", "lockedIndicatorTopWithReaderManager:", "d24@0:8@16", OrigReaderLockedIndicatorTop, HookReaderLockedIndicatorTop);
        HOOK_INST("SSReaderAudioAdapter", "lockIndicator:", "v32@0:8{CGPoint=dd}16", OrigReaderLockIndicator, HookReaderLockIndicator);
        HOOK_INST("SSAudioSettingManager", "audioFloatingViewFrame", "{CGRect={CGPoint=dd}{CGSize=dd}}16@0:8", OrigAudioSettingFloatingFrame, HookAudioSettingFloatingFrame);
        HOOK_INST("SSAudioSettingManager", "saveAudioFloatingViewFrame:", "v48@0:8{CGRect={CGPoint=dd}{CGSize=dd}}16", OrigAudioSettingSaveFloatingFrame, HookAudioSettingSaveFloatingFrame);
        HOOK_INST("FQCCommunityInputView", "layoutSubviews", "v16@0:8", OrigCommunityInputLayout, HookCommunityInputLayout);
        HOOK_INST("FQC503CommentInputView", "layoutSubviews", "v16@0:8", Orig503CommentInputLayout, Hook503CommentInputLayout);
        HOOK_INST("FQC503CommentInputView", "configTheme:", "v20@0:8B16", Orig503CommentInputTheme, Hook503CommentInputTheme);
        HOOK_INST("FQCShortVideoInputView", "layoutSubviews", "v16@0:8", OrigShortVideoInputLayout, HookShortVideoInputLayout);
        HOOK_INST("FQCShortVideoNewEditorView", "layoutSubviews", "v16@0:8", OrigShortVideoNewEditorLayout, HookShortVideoNewEditorLayout);
        HOOK_INST("FQCCommentV1BottomToolBar", "layoutSubviews", "v16@0:8", OrigReaderCommentBarLayout, HookReaderCommentBarLayout);
        HOOK_INST("FQCParagraphCommentListViewController", "viewDidAppear:", "v20@0:8B16", OrigReaderCommentListAppeared, HookReaderCommentListAppeared);
        HOOK_INST("SSVideoSharePanelView", "layoutSubviews", "v16@0:8", OrigSharePanelLayout, HookSharePanelLayout);
        HOOK_INST("SSUGKmpSharePanelContainerViewController", "viewDidLayoutSubviews", "v16@0:8", OrigKMPShareLayout, HookKMPShareLayout);

        // 1. Drama spacing immediate sync on navigation push/pop & foreground crossfade
        HOOK_INST("FQVShortVideoListViewController", "viewWillAppear:", "v20@0:8B16", OrigShortVideoListWillAppear, HookShortVideoListWillAppear);
        HOOK_INST("FQVShortVideoListViewController", "viewDidAppear:", "v20@0:8B16", OrigShortVideoListDidAppear, HookShortVideoListDidAppear);
        HOOK_INST("FQVShortVideoListViewController", "viewWillDisappear:", "v20@0:8B16", OrigShortVideoListWillDisappear, HookShortVideoListWillDisappear);
        HOOK_INST("SSVideoSeriesFeedViewController", "viewWillAppear:", "v20@0:8B16", OrigSeriesFeedWillAppear, HookSeriesFeedWillAppear);
        HOOK_INST("SSVideoSeriesFeedViewController", "viewDidAppear:", "v20@0:8B16", OrigSeriesFeedDidAppear, HookSeriesFeedDidAppear);
        HOOK_INST("SSVideoSeriesFeedViewController", "viewWillDisappear:", "v20@0:8B16", OrigSeriesFeedWillDisappear, HookSeriesFeedWillDisappear);
        HOOK_INST("SSVideoFeedContainerViewController", "viewWillAppear:", "v20@0:8B16", OrigFeedContainerWillAppear, HookFeedContainerWillAppear);
        HOOK_INST("SSVideoFeedContainerViewController", "viewDidAppear:", "v20@0:8B16", OrigFeedContainerDidAppear, HookFeedContainerDidAppear);
        HOOK_INST("SSShortVideoBottomDistributionView", "performForegroundCrossfadeWithRenderBlock:", "v24@0:8@?16", OrigDistCrossfade, HookDistCrossfade);

        // 2. Highest available drama resolution.
        HOOK_INST("FQVShortVideoListVCPlayerComponent", "resolutionWithModel:", "@24@0:8@16", OrigResolutionWithModel, HookResolutionWithModel);
        HOOK_INST("FQVShortVideoListVCPlayerComponent", "resolutionItemWithModel:", "@24@0:8@16", OrigResolutionItemWithModel, HookResolutionItemWithModel);
        HOOK_INST("FQVPlayerEngineDataResolutionItem", "finalResolutionTypeWithSupportResolutions:videoModel:", "Q32@0:8@16@24", OrigFinalResolutionType, HookFinalResolutionType);
        HOOK_INST("FQVShortVideoListVCControlComponent", "updateCurrentPlayResolutionWithVideoDataModel:resolution:finishBlock:", "v40@0:8@16@24@?32", OrigControlUpdateResolution, HookControlUpdateResolution);
        HOOK_INST("FQVShortVideoListVCLandscapeSettingComponent", "didSelectResolution:", "v24@0:8@16", OrigLandscapeSelectResolution, HookLandscapeSelectResolution);
        HOOK_INST("FQVShortVideoListVCPlayerComponent", "updatePlayer:resolution:model:finish:", "v48@0:8@16@24@32@?40", OrigUpdatePlayerResolution, HookUpdatePlayerResolution);
        HOOK_INST("FQVShortVideoListVCPlayerComponent", "preparePlayer:model:async:", "v36@0:8@16@24B32", OrigPreparePlayerAsync, HookPreparePlayerAsync);
        HOOK_INST("FQVPlayer", "videoEngineReadyToPlay:", "v24@0:8@16", OrigPlayerReadyToPlay, HookPlayerReadyToPlay);

        // 3. Inner drama Episode 1/2 full-episode bottom black mask removal & full-height portrait canvas
        HOOK_INST("FQVShortVideoListVCPlayerComponent", "playerViewSizeWithModel:", "{CGSize=dd}24@0:8@16", OrigPlayerViewSizeWithModel, HookPlayerViewSizeWithModel);
        HOOK_INST("FQVShortVideoListVCPlayerComponent", "scaleAspectFitPlayerViewSizeWithModel:", "{CGSize=dd}24@0:8@16", OrigScaleAspectFitPlayerViewSizeWithModel, HookScaleAspectFitPlayerViewSizeWithModel);
        HOOK_INST("FQVShortVideoListVCPlayerComponent", "portraitPlayerViewFrameWithModel:", "{CGRect={CGPoint=dd}{CGSize=dd}}24@0:8@16", OrigPortraitPlayerViewFrameWithModel, HookPortraitPlayerViewFrameWithModel);
        HOOK_INST("FQVShortVideoListVCPlayerComponent", "scaleAspectFitContainerViewFrameWithModel:", "{CGRect={CGPoint=dd}{CGSize=dd}}24@0:8@16", OrigScaleAspectFitContainerViewFrameWithModel, HookScaleAspectFitContainerViewFrameWithModel);
        HOOK_INST("FQVShortVideoListVCPlayerComponent", "maxPlayerViewHeightWithModel:", "d24@0:8@16", OrigMaxPlayerViewHeightWithModel, HookMaxPlayerViewHeightWithModel);
        HOOK_INST("SSShortVideoBottomInsertView", "setupBottomSubviews", "v16@0:8", OrigBottomInsertSetup, HookBottomInsertSetup);
        HOOK_INST("SSShortVideoBottomInsertView", "refreshLayoutForResizing", "v16@0:8", OrigBottomInsertResize, HookBottomInsertResize);
        HOOK_INST("SSShortVideoSingleBottomInsertView", "setupViews", "v16@0:8", OrigSingleBottomInsertSetup, HookSingleBottomInsertSetup);
        HOOK_INST("FQVShortVideoPlayerBottomView", "setup", "v16@0:8", OrigPlayerBottomViewSetup, HookPlayerBottomViewSetup);
        HOOK_INST("FQVShortVideoVPlayerSeriesControlView", "setupSingleBottomViewIfNeed", "v16@0:8", OrigSeriesSetupSingleBottom, HookSeriesSetupSingleBottom);
        HOOK_INST("FQVShortVideoVPlayerSeriesControlView", "updatePlayerBottomViewAlpha:", "v24@0:8d16", OrigSeriesBottomAlpha, HookSeriesBottomAlpha);
        HOOK_INST("FQVShortVideoVPlayerSingleSeriesControlView", "setupSingleBottomViewIfNeed", "v16@0:8", OrigSingleSeriesSetupSingleBottom, HookSingleSeriesSetupSingleBottom);
        HOOK_INST("FQVShortVideoVPlayerSingleSeriesControlView", "updatePlayerBottomViewAlpha:", "v24@0:8d16", OrigSingleSeriesBottomAlpha, HookSingleSeriesBottomAlpha);
        HOOK_INST("FQVPlayer", "layoutSubviews", "v16@0:8", OrigPlayerCanvasLayout, HookPlayerCanvasLayout);
        HOOK_INST("FQVPlayer", "refreshPlayerViewLayout", "v16@0:8", OrigPlayerCanvasRefresh, HookPlayerCanvasRefresh);
        HOOK_INST("FQVShortVideoPlayerCellView", "layoutVideoView", "v16@0:8", OrigCellLayoutVideoView, HookCellLayoutVideoView);
        HOOK_INST("FQVShortVideoPlayerCellView", "refreshUIWithPlayViewFrame:", "v48@0:8{CGRect={CGPoint=dd}{CGSize=dd}}16", OrigCellRefreshPlayFrame, HookCellRefreshPlayFrame);
        HOOK_INST("FQVShortVideoPlayerCellView", "updatePlayerSuperViewLayout", "v16@0:8", OrigCellUpdatePlayerSuperLayout, HookCellUpdatePlayerSuperLayout);
        HOOK_INST("FQVShortVideoPlayerCellView", "refreshUIWithPlayerSuperViewSize:", "v32@0:8{CGSize=dd}16", OrigCellRefreshPlayerSuperSize, HookCellRefreshPlayerSuperSize);

        // 4. TikTok-style two-finger spread/pinch pure clean screen & double-tap opens comments
        HOOK_INST("FQVShortVideoVPlayerControlView", "setupGestures", "v16@0:8", OrigVPlayerSetupGestures, HookVPlayerSetupGestures);
        HOOK_INST("FQVShortVideoVPlayerControlView", "doubleTapGesture:", "v24@0:8@16", OrigVPlayerDoubleTap, HookVPlayerDoubleTap);
        HOOK_INST("FQVShortVideoVPlayerControlView", "controlViewWillDisplay", "v16@0:8", OrigVPlayerWillDisplay, HookVPlayerWillDisplay);
        HOOK_INST("FQVShortVideoVPlayerControlView", "controlViewWillEndDisplay", "v16@0:8", OrigVPlayerWillEndDisplay, HookVPlayerWillEndDisplay);
        HOOK_INST("FQVShortVideoVPlayerControlView", "updateControlState", "v16@0:8", OrigVPlayerUpdateControlState, HookVPlayerUpdateControlState);
        HOOK_INST("SSShortVideoOutterMultiGenreFeedControlView", "layoutSubviews", "v16@0:8", OrigOuterControlLayout, HookOuterControlLayout);
        HOOK_INST("SSShortVideoOutterMultiGenreFeedControlView", "didMoveToWindow", "v16@0:8", OrigOuterDidMoveToWindow, HookOuterDidMoveToWindow);
        HOOK_INST("SSShortVideoOutterMultiGenreFeedControlView", "bindContentModel:", "v24@0:8@16", OrigOuterBindContent, HookOuterBindContent);
        HOOK_INST("FQVShortVideoListVCBackgroundPlaybackComponent", "shouldPauseInBackground", "B16@0:8", OrigDramaShouldPauseInBackground, HookDramaShouldPauseInBackground);
        HOOK_INST("FQVShortVideoListVCGestureComponent", "gestureRecognizerShouldBegin:", "B24@0:8@16", OrigGestureCompShouldBegin, HookGestureCompShouldBegin);

        HOOK_INST("FQVShortVideoVPlayerControlView", "gestureRecognizerShouldBegin:", "B24@0:8@16", OrigInnerPinchSeekShouldBegin, HookInnerPinchSeekShouldBegin);
        HOOK_INST("SSShortVideoOutterMultiGenreFeedControlView", "gestureRecognizerShouldBegin:", "B24@0:8@16", OrigOuterPinchSeekShouldBegin, HookOuterPinchSeekShouldBegin);

        // 5. Reader back button centering, inline paragraph comment glass & Mine fold clipping
        HOOK_INST("FQReaderSaasNavigationView", "layoutSubviews", "v16@0:8", OrigReaderNavLayoutMotion, HookReaderNavLayoutMotion);
        HOOK_INST("SSReaderNavigationBarCommunitySwitchBtnInsertObject", "updateHotCommentBubble:", "v20@0:8B16", OrigUpdateReaderHotCommentBubble, HookUpdateReaderHotCommentBubble);

        // 5b. Short Drama progress bar right-overflow clamp & cold-start spacing sync
        HOOK_INST("FQVShortVideoProgressView", "layoutSubviews", "v16@0:8", OrigDramaProgLayoutSubviews, HookDramaProgLayoutSubviews);
        HOOK_INST("FQVShortVideoProgressView", "layoutProgressView", "v16@0:8", OrigDramaProgLayoutProgress, HookDramaProgLayoutProgress);
        HOOK_INST("FQVShortVideoProgressView", "updateProgressViewWithPlaying:animate:", "v24@0:8B16B20", OrigDramaProgPlaying, HookDramaProgPlaying);
        HOOK_INST("FQVShortVideoProgressView", "updateProgressViewWithActivatedState:", "v24@0:8Q16", OrigDramaProgActivated, HookDramaProgActivated);
        HOOK_INST("FQVShortVideoProgressView", "updateProgressViewWithStateChange:showDot:", "v28@0:8Q16B24", OrigDramaProgState, HookDramaProgState);
        HOOK_INST("FQVShortVideoProgressView", "updateProgressBarWithProgressBarType:configMaker:", "v32@0:8Q16@?24", OrigDramaProgConfigure, HookDramaProgConfigure);
        HOOK_INST("FQVShortVideoProgressView", "didMoveToWindow", "v16@0:8", OrigDramaProgDidMoveWindow, HookDramaProgDidMoveWindow);
        HOOK_INST("FQVShortVideoVPlayerControlView", "didMoveToWindow", "v16@0:8", OrigDramaControlDidMoveWindow, HookDramaControlDidMoveWindow);

        // 5c. Bookshelf bookstore anchor, single-owner Dock material guard, detached hit-test routing & Mine sidebar filters
        FQXInstallBookstoreAntiAutoScrollHooks();
        FQXInstallOwnedHook(UIVisualEffectView.class, @selector(setEffect:), NO, "v24@0:8@16",
                            (IMP)HookVisualEffectSetEffectForOwner, (IMP *)&OrigVisualEffectSetEffectForOwner);
        FQXInstallOwnedHook(UIVisualEffectView.class, @selector(layoutSubviews), NO, "v16@0:8",
                            (IMP)HookVisualEffectLayoutForProxyGuard, (IMP *)&OrigVisualEffectLayoutForProxyGuard);
        FQXInstallOwnedHook(UIVisualEffectView.class, @selector(didMoveToWindow), NO, "v16@0:8",
                            (IMP)HookVisualEffectWindowForProxyGuard, (IMP *)&OrigVisualEffectWindowForProxyGuard);
        HOOK_INST("SSTabBar", "pointInside:withEvent:", "B40@0:8{CGPoint=dd}16@32", OrigSSTabBarPointInside, HookSSTabBarPointInside);
        HOOK_INST("SSTabBar", "hitTest:withEvent:", "@40@0:8{CGPoint=dd}16@32", OrigSSTabBarHitTest, HookSSTabBarHitTest);
        HOOK_INST("SSMyUser621SideBarFunctionEntryListCell", "configureWithModels:titles:icons:darkIcons:", "v48@0:8@16@24@32@40", OrigSidebarConfigureFunctionList, HookSidebarConfigureFunctionList);
        IMP sidebarHeight = NULL;
        if (FQXInstallOwnedHook(objc_lookUpClass("SSMyUser621SideBarFunctionEntryListCell"),
                                sel_registerName("heightForModels:"), YES, "d24@0:8@16",
                                (IMP)HookSidebarFunctionListHeight, &sidebarHeight)) {
            OrigSidebarFunctionListHeight = (__typeof__(OrigSidebarFunctionListHeight))sidebarHeight;
        }
        HOOK_INST("SSMyUser621SideBarViewController", "collectionView:layout:sizeForItemAtIndexPath:",
                  "{CGSize=dd}40@0:8@16@24@32", OrigSidebarItemSize, HookSidebarItemSize);
        HOOK_INST("SSMyUser621SideBarViewController", "collectionView:layout:referenceSizeForFooterInSection:",
                  "{CGSize=dd}40@0:8@16@24q32", OrigSidebarFooterSize, HookSidebarFooterSize);
        HOOK_INST("SSMyUser621SideBarViewController", "viewDidLoad", "v16@0:8", OrigSidebarViewDidLoad, HookSidebarViewDidLoad);

        // 6. Audio Play Page Liquid Glass, Refraction & Seamless Background
        HOOK_INST("SSNewAudioPlayNavigationView", "layoutSubviews", "v16@0:8", OrigAudioNavLayout, HookAudioNavLayout);
        HOOK_INST("SSNewAudioPlayNavigationView", "setThemeTintColor:", "v24@0:8@16", OrigAudioNavSetTint, HookAudioNavSetTint);
        HOOK_INST("SSAudioPageBackView", "layoutSubviews", "v16@0:8", OrigAudioBackLayout, HookAudioBackLayout);
        HOOK_INST("SSAudioPageBackView", "_adjustAppearanceColor", "v16@0:8", OrigAudioBackAdjust, HookAudioBackAdjust);
        HOOK_INST("SSNewAudioPlayBookView", "layout", "v16@0:8", OrigAudioBookLayout, HookAudioBookLayout);
        HOOK_INST("SSNewAudioPlayBookView", "setShouldShowDetailEntrance:", "v20@0:8B16", OrigAudioBookDetailEntrance, HookAudioBookDetailEntrance);
        HOOK_INST("SSNewAudioPlayBookView", "setEnableBookNameClick:", "v20@0:8B16", OrigAudioBookClick, HookAudioBookClick);
        HOOK_INST("SSNewAudioPlayBookView", "updateThemeColor:", "v24@0:8@16", OrigAudioBookTheme, HookAudioBookTheme);
        HOOK_INST("SSNewAudioPlayMenuView", "layoutSubviews", "v16@0:8", OrigAudioMenuLayout, HookAudioMenuLayout);
        HOOK_INST("SSNewAudioPlayMenuViewCell", "layoutSubviews", "v16@0:8", OrigAudioMenuCellLayout, HookAudioMenuCellLayout);
        HOOK_INST("SSNewAudioPlayMenuViewCell", "touchesBegan:withEvent:", "v32@0:8@16@24", OrigAudioMenuCellBegan, HookAudioMenuCellBegan);
        HOOK_INST("SSNewAudioPlayMenuViewCell", "touchesEnded:withEvent:", "v32@0:8@16@24", OrigAudioMenuCellEnded, HookAudioMenuCellEnded);
        HOOK_INST("SSNewAudioPlayMenuViewCell", "touchesCancelled:withEvent:", "v32@0:8@16@24", OrigAudioMenuCellCancelled, HookAudioMenuCellCancelled);
        HOOK_INST("SSNewAudioPlayControlView", "layoutSubviews", "v16@0:8", OrigAudioControlLayout, HookAudioControlLayout);
        HOOK_INST("SSNewAudioPlayControlView", "setIconTintColor:", "v24@0:8@16", OrigAudioControlSetTint, HookAudioControlSetTint);
        HOOK_INST("SSAudioPlayToneView611", "layoutSubviews", "v16@0:8", OrigToneView611Layout, HookToneView611Layout);
        HOOK_INST("SSAudioPlayToneView611", "adjustAudioAppearance", "v16@0:8", OrigToneView611Adjust, HookToneView611Adjust);
        HOOK_INST("SSAudioPlayToneListView", "layoutSubviews", "v16@0:8", OrigToneListLayout, HookToneListLayout);
        HOOK_INST("SSAudioPlayToneListView", "adjustAudioAppearance", "v16@0:8", OrigToneListAdjust, HookToneListAdjust);
        HOOK_INST("SSAudioPlayToneListView", "setBackgroundColor:", "v24@0:8@16", OrigToneListSetBg, HookToneListSetBg);
        HOOK_INST("SSAudioReadingGuideView", "layoutSubviews", "v16@0:8", OrigReadingGuideLayout, HookReadingGuideLayout);
        HOOK_INST("SSAudioReadingGuideView", "adjustAppearance", "v16@0:8", OrigReadingGuideAdjust, HookReadingGuideAdjust);
        HOOK_INST("SSAudioV4ReadingGuideView", "layoutSubviews", "v16@0:8", OrigReadingGuideV4Layout, HookReadingGuideV4Layout);
        HOOK_INST("SSAudioV4ReadingGuideView", "setTextTintColor:", "v24@0:8@16", OrigReadingGuideV4Tint, HookReadingGuideV4Tint);
        HOOK_INST("SSAudioPlayToneCell", "layoutSubviews", "v16@0:8", OrigToneCellLayout, HookToneCellLayout);
        HOOK_INST("SSAudioPlayToneCell", "setupBackgroundView", "v16@0:8", OrigToneCellSetupBg, HookToneCellSetupBg);
        HOOK_INST("SSAudioPlayToneCell", "adjustAudioAppearance", "v16@0:8", OrigToneCellAdjust, HookToneCellAdjust);
        HOOK_INST("SSAudioPlayToneCell", "setSelected:", "v20@0:8B16", OrigToneCellSetSelected, HookToneCellSetSelected);
        HOOK_INST("SSAudioPlayToneCell", "setBlurSelected:", "v20@0:8B16", OrigToneCellSetBlurSelected, HookToneCellSetBlurSelected);
        HOOK_INST("SSNewAudioPlayBackgroundView", "setupLayout", "v16@0:8", OrigAudioBgSetupLayout, HookAudioBgSetupLayout);
        HOOK_INST("SSNewAudioPlayBackgroundView", "updateThemeColor:", "v24@0:8@16", OrigAudioBgUpdateTheme, HookAudioBgUpdateTheme);
        HOOK_INST("SSNewAudioPlayBackgroundView", "setPixelBlurBackgroundHidden:", "v20@0:8B16", OrigAudioBgBlurHidden, HookAudioBgBlurHidden);
        HOOK_INST("SSNewAudioPlayViewController", "layoutContentView", "v16@0:8", OrigAudioVCLayoutContent, HookAudioVCLayoutContent);
        HOOK_INST("SSNewAudioPlayViewController", "rd_layoutTopAndBottomMaskViews", "v16@0:8", OrigAudioVCLayoutMasks, HookAudioVCLayoutMasks);
        HOOK_INST("SSNewAudioPlayViewController", "sliderProgresslayoutTopAndBottomMaskViews", "v16@0:8", OrigAudioVCSliderMasks, HookAudioVCSliderMasks);
        HOOK_INST("SSNewAudioPlayViewController", "updateBottomMaskGradientThemeColor:", "v24@0:8@16", OrigAudioVCBottomMaskTheme, HookAudioVCBottomMaskTheme);
        HOOK_INST("SSNewAudioPlayViewController", "updateSlideBottomMaskGradientThemeColor:", "v24@0:8@16", OrigAudioVCSlideMaskTheme, HookAudioVCSlideMaskTheme);
        HOOK_INST("SSAudioPlayTTSReaderPageViewController", "layoutSubviews", "v16@0:8", OrigTTSReaderLayout, HookTTSReaderLayout);
        HOOK_INST("SSAudioPlayTTSReaderPageViewController", "updateCaptionMask", "v16@0:8", OrigTTSReaderUpdateMask, HookTTSReaderUpdateMask);

        // 7. Short Drama & Audiobook Dynamic Island ("像音频一样")
        FQXEnsureMediaPlayerLoaded();
        HOOK_INST("MPRemoteCommand", "addTarget:action:", "v32@0:8@16:24", OrigMPRemoteAddTargetAction, HookMPRemoteAddTargetAction);
        HOOK_INST("MPRemoteCommand", "addTargetWithHandler:", "@24@0:8@?16", OrigMPRemoteAddTargetHandler, HookMPRemoteAddTargetHandler);
        HOOK_INST("SSNewAudioPlayViewController", "viewDidAppear:", "v20@0:8B16", OrigAudioVCDidAppearIsland, HookAudioVCDidAppearIsland);
        HOOK_INST("SSNewAudioPlayViewController", "viewWillDisappear:", "v20@0:8B16", OrigAudioVCWillDisappearIsland, HookAudioVCWillDisappearIsland);
        HOOK_INST("SSNewAudioPlayViewController", "viewDidDisappear:", "v20@0:8B16", OrigAudioVCDidDisappearIsland, HookAudioVCDidDisappearIsland);
        HOOK_INST("SSAudioPlayTTSReaderPageViewController", "viewDidAppear:", "v20@0:8B16", OrigTTSReaderDidAppearIsland, HookTTSReaderDidAppearIsland);
        HOOK_INST("SSAudioPlayTTSReaderPageViewController", "viewDidDisappear:", "v20@0:8B16", OrigTTSReaderDidDisappearIsland, HookTTSReaderDidDisappearIsland);

        [NSNotificationCenter.defaultCenter addObserverForName:UIApplicationWillResignActiveNotification
                                                        object:nil
                                                         queue:NSOperationQueue.mainQueue
                                                    usingBlock:^(__unused NSNotification *note) {
            FQXEnterDramaIslandOnLeaveIfEligible();
        }];

        [NSNotificationCenter.defaultCenter addObserverForName:UIKeyboardWillChangeFrameNotification
                                                        object:nil
                                                         queue:NSOperationQueue.mainQueue
                                                    usingBlock:^(NSNotification *note) {
            FQXComposerKeyboardFrame = [note.userInfo[UIKeyboardFrameEndUserInfoKey] CGRectValue];
            if (FQXCurrentCommentComposerStyle() != FQXCommentComposerFloatingDetached) return;
            for (UIView *composer in FQXTrackedExpandedComposers().allObjects) {
                if (composer.window) [composer setNeedsLayout];
            }
        }];
        [NSNotificationCenter.defaultCenter addObserverForName:NSUserDefaultsDidChangeNotification
                                                        object:nil
                                                         queue:nil
                                                    usingBlock:^(__unused NSNotification *note) {
            FQXInvalidateHotPrefsCache();
        }];
        [NSNotificationCenter.defaultCenter addObserverForName:UIApplicationWillEnterForegroundNotification
                                                        object:nil
                                                         queue:NSOperationQueue.mainQueue
                                                    usingBlock:^(__unused NSNotification *note) {
            FQXScheduleCommentForegroundRefresh();
            FQXScheduleDynamicIslandRefresh();
        }];
        [NSNotificationCenter.defaultCenter addObserverForName:UIApplicationDidBecomeActiveNotification
                                                        object:nil
                                                         queue:NSOperationQueue.mainQueue
                                                    usingBlock:^(__unused NSNotification *note) {
            FQXScheduleCommentForegroundRefresh();
            FQXScheduleDynamicIslandRefresh();
        }];
        [NSNotificationCenter.defaultCenter addObserverForName:UIApplicationDidReceiveMemoryWarningNotification
                                                        object:nil
                                                         queue:NSOperationQueue.mainQueue
                                                    usingBlock:^(__unused NSNotification *note) {
            FQXCompactRuntimeMemory();
        }];
        [NSNotificationCenter.defaultCenter addObserverForName:UIApplicationDidEnterBackgroundNotification
                                                        object:nil
                                                         queue:NSOperationQueue.mainQueue
                                                    usingBlock:^(__unused NSNotification *note) {
            FQXComposerKeyboardFrame = CGRectZero;
            FQXResetPinchCleanStates();
            FQXEnterDramaIslandOnLeaveIfEligible();
            FQXCompactRuntimeMemory();
        }];
        [NSNotificationCenter.defaultCenter addObserverForName:UIAccessibilityReduceTransparencyStatusDidChangeNotification
                                                        object:nil
                                                         queue:NSOperationQueue.mainQueue
                                                    usingBlock:^(__unused NSNotification *note) {
            FQXReapplyAllTrackedCommentGlass();
        }];

        dispatch_async(dispatch_get_main_queue(), ^{
            FQXInstallPostGlassHooks();
        });

#undef HOOK_INST
    });
}

static void FQXInstallPostGlassHooks(void) {
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
#define POST_HOOK(clsName, selName, enc, origVar, hookFn) do { \
    Class _c = NSClassFromString(@clsName); \
    if (_c) FQXInstallOwnedHook(_c, NSSelectorFromString(@selName), NO, enc, (IMP)(hookFn), (IMP *)&(origVar)); \
} while (0)

        // Short Drama header capsule & search button alignment (runs after AlignedGlass)
        POST_HOOK("SSVideoSeriesFeedHeaderView", "layoutSubviews", "v16@0:8", OrigDramaHeaderLayoutForCapsule, HookDramaHeaderLayoutForCapsule);
        POST_HOOK("SSVideoSeriesFeedHeaderView", "didMoveToWindow", "v16@0:8", OrigDramaHeaderDidMoveWindow, HookDramaHeaderDidMoveWindow);
        POST_HOOK("SSVideoSeriesFeedHeaderView", "finishSearchIconVisibilityTransition:", "v20@0:8B16", OrigDramaHeaderSearchTransition, HookDramaHeaderSearchTransition);
        POST_HOOK("SSVideoSeriesFeedHeaderView", "updateTabViewWithContentSize:", "v32@0:8{CGSize=dd}16", OrigDramaHeaderUpdateTabs, HookDramaHeaderUpdateTabs);
        POST_HOOK("SSVideoSeriesFeedHeaderView", "layoutTabContainerWithDesiredWidth:baseWidth:reserveSearchButton:", "v36@0:8d16d24B32", OrigDramaHeaderTabGeometry, HookDramaHeaderTabGeometry);
        POST_HOOK("SSHGBookStoreCategoryTitleView", "layoutSubviews", "v16@0:8", OrigDramaTabsLayoutForCapsule, HookDramaTabsLayoutForCapsule);

        // Mine 4-button shortcut enforcement (runs after AlignedGlass)
        POST_HOOK("SSScrollFoldFuncView", "layoutSubviews", "v16@0:8", OrigScrollFoldLayout, HookScrollFoldLayout);
        POST_HOOK("SSMyUserShortcutCell", "layoutSubviews", "v16@0:8", OrigMineShortcutCardLayout, HookMineShortcutCardLayout);
        POST_HOOK("SSMyUserCollectionView1Cell", "layoutSubviews", "v16@0:8", OrigMineCard1Layout, HookMineCard1Layout);
        POST_HOOK("SSMyUserCollectionViewFunCell", "layoutSubviews", "v16@0:8", OrigMineFunCellLayoutForBadge, HookMineFunCellLayoutForBadge);
        POST_HOOK("SSMyUserCollectionViewFunCell", "setFrame:", "v48@0:8{CGRect={CGPoint=dd}{CGSize=dd}}16", OrigMineFunCellSetFrame, HookMineFunCellSetFrame);
        POST_HOOK("SSMyUserCollectionViewFunCell", "applyLayoutAttributes:", "v24@0:8@16", OrigMineFunCellApplyAttrs, HookMineFunCellApplyAttrs);
        POST_HOOK("SSMyUserCollectionViewOrderFunCell", "layoutSubviews", "v16@0:8", OrigMineOrderCellLayout, HookMineOrderCellLayout);
        POST_HOOK("SSMyUserCollectionViewOrderFunCell", "setFrame:", "v48@0:8{CGRect={CGPoint=dd}{CGSize=dd}}16", OrigMineOrderCellSetFrame, HookMineOrderCellSetFrame);
        POST_HOOK("SSMyUserCollectionViewOrderFunCell", "applyLayoutAttributes:", "v24@0:8@16", OrigMineOrderCellApplyAttrs, HookMineOrderCellApplyAttrs);
        POST_HOOK("SSMyUser621FunctionEntryItemCell", "layoutSubviews", "v16@0:8", OrigMineEntryItemLayout, HookMineEntryItemLayout);
        POST_HOOK("SSMyUser621FunctionEntryItemCell", "setFrame:", "v48@0:8{CGRect={CGPoint=dd}{CGSize=dd}}16", OrigMineEntryItemSetFrame, HookMineEntryItemSetFrame);
        POST_HOOK("SSMyUser621FunctionEntryItemCell", "applyLayoutAttributes:", "v24@0:8@16", OrigMineEntryItemApplyAttrs, HookMineEntryItemApplyAttrs);

        // Bookshelf header 14-toggle visibility & reflow (runs after AlignedGlass)
        POST_HOOK("SSBookShelfTabSelectView", "layoutSubviews", "v16@0:8", OrigShelfTabSelectLayout, HookShelfTabSelectLayout);
        POST_HOOK("SSBookShelfTabSelectViewTitleCell", "layoutSubviews", "v16@0:8", OrigShelfTabTitleCellLayout, HookShelfTabTitleCellLayout);
        POST_HOOK("SSBookShelf525ViewController", "viewLayout", "v16@0:8", OrigShelf525ViewLayout, HookShelf525ViewLayout);
        POST_HOOK("SSBookShelf525ViewController", "tryAddSelectRightView", "v16@0:8", OrigShelf525TryAddRightView, HookShelf525TryAddRightView);
        POST_HOOK("SSBookShelf525ViewController", "viewDidLayoutSubviews", "v16@0:8", OrigShelf525DidLayoutSubviews, HookShelf525DidLayoutSubviews);
        {
            Class _c525 = NSClassFromString(@"SSBookShelf525ViewController");
            if (_c525) {
                FQXInstallMineValidatedHook(_c525, NSSelectorFromString(@"categoryView:didSelectedItemAtIndex:"),
                                            4, "v", NULL, (IMP)HookShelf525DidSelectTab, (IMP *)&OrigShelf525DidSelectTab);
            }
        }
        POST_HOOK("SSBookShelfSubViewController", "viewDidLayoutSubviews", "v16@0:8", OrigShelfSubVCDidLayout, HookShelfSubVCDidLayout);
        {
            Class _cSub = NSClassFromString(@"SSBookShelfSubViewController");
            if (_cSub) {
                FQXInstallMineValidatedHook(_cSub, NSSelectorFromString(@"collectionView:viewForSupplementaryElementOfKind:atIndexPath:"),
                                            5, "@", NULL, (IMP)HookShelfSubSupView, &OrigShelfSubSupView);
                FQXInstallMineValidatedHook(_cSub, NSSelectorFromString(@"collectionView:layout:sizeForItemAtIndexPath:"),
                                            5, "{CGSize", NULL, (IMP)HookShelfSubSizeForItem, &OrigShelfSubSizeForItem);
                FQXInstallMineValidatedHook(_cSub, NSSelectorFromString(@"collectionView:layout:referenceSizeForHeaderInSection:"),
                                            5, "{CGSize", NULL, (IMP)HookShelfSubHeaderSize, &OrigShelfSubHeaderSize);
            }
        }
        POST_HOOK("SSBookShelfFunctionCell", "layoutContainerSubviews", "v16@0:8", OrigShelfFunctionContainerLayout, HookShelfFunctionContainerLayout);
        POST_HOOK("SS525BookShelfSubHeaderView", "layoutSubviews", "v16@0:8", OrigShelfSubHeaderLayoutForEdit, HookShelfSubHeaderLayoutForEdit);
        POST_HOOK("SS525BookShelfSubHeaderView", "layoutEditButton", "v16@0:8", OrigShelfSubHeaderLayoutEditBtn, HookShelfSubHeaderLayoutEditBtn);
        POST_HOOK("SSBookShelfFilterHeaderView", "layoutSubviews", "v16@0:8", OrigShelfFilterHeaderLayout, HookShelfFilterHeaderLayout);
        POST_HOOK("SSBookShelfFilterMixRowCollectionView", "layoutSubviews", "v16@0:8", OrigShelfFilterMixRowLayout, HookShelfFilterMixRowLayout);
        POST_HOOK("SSBookShelfFilter541Cell", "layoutSubviews", "v16@0:8", OrigShelfFilter541CellLayout, HookShelfFilter541CellLayout);

#undef POST_HOOK
    });
}
