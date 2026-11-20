#import <UIKit/UIKit.h>
#import <QuartzCore/QuartzCore.h>
#import <objc/message.h>
#import <objc/runtime.h>
#import "FQXHookInstaller.h"

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
static const void *FQXPinchTriggeredInGestureKey = &FQXPinchTriggeredInGestureKey;
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
static NSString *const LegacyCommentMaterialModePrefKey = @"FanqieX.CommentMaterialMode.1";
static NSString *const LegacyCommentGlassFrostedPrefKey = @"FanqieX.CommentGlassFrosted.1";
static NSString *const CommentActivityBannerPrefKey = @"FanqieX.CommentActivityBanner.1";
static NSString *const CommentSearchEntrancePrefKey = @"FanqieX.CommentSearchEntrance.1";
static NSString *const AudioRecsPrefKey = @"FanqieX.AudioRecommendations.1";
static NSString *const AudioIconsOnlyPrefKey = @"FanqieX.AudioControlIconsOnly.1";
static NSString *const AudioLiquidGlassPrefKey = @"FanqieX.AudioLiquidGlass.1";
static NSString *const BottomHapticsPrefKey = @"FanqieX.BottomHaptics.1";
static NSString *const FQXCTForegroundColorAttr = @"CTForegroundColor";
static const CGFloat AudioNavigationButtonDiameter = 42.0;
static const CGFloat AudioBookArrowDiameter = 28.0;

typedef NS_ENUM(NSInteger, FQXCommentMaterialStyle) {
    FQXCommentMaterialNative = 0,       // Original Fanqie comment background (neither option enabled)
    FQXCommentMaterialLiquidGlass = 1,  // iOS 26/27 Liquid Glass
    FQXCommentMaterialGaussianBlur = 2, // iOS 18 Gaussian Blur
};

typedef NS_ENUM(NSInteger, FQXCommentAppearanceMode) {
    FQXCommentAppearanceFollowApp = 0, // Follow Fanqie Novel's in-app Night/Light mode
    FQXCommentAppearanceLight = 1,     // Force Light
    FQXCommentAppearanceDark = 2,      // Force Dark
};

static BOOL FQXDramaCommentNoVideoShiftEnabled(void) {
    return [NSUserDefaults.standardUserDefaults boolForKey:DramaCommentNoVideoShiftPrefKey];
}

static BOOL FQXDramaExitCollectAlertHidden(void) {
    return [NSUserDefaults.standardUserDefaults boolForKey:DramaExitCollectAlertPrefKey];
}

static FQXCommentMaterialStyle FQXCurrentCommentMaterialStyle(void) {
    NSUserDefaults *ud = NSUserDefaults.standardUserDefaults;
    if ([ud objectForKey:LegacyCommentGlassFrostedPrefKey]) {
        [ud removeObjectForKey:LegacyCommentGlassFrostedPrefKey];
    }
    if ([ud objectForKey:LegacyCommentMaterialModePrefKey]) {
        [ud removeObjectForKey:LegacyCommentMaterialModePrefKey];
    }
    id stored = [ud objectForKey:CommentMaterialStylePrefKey];
    if (!stored) return FQXCommentMaterialNative;
    NSInteger mode = [stored respondsToSelector:@selector(integerValue)] ? [stored integerValue] : 0;
    if (mode < FQXCommentMaterialNative || mode > FQXCommentMaterialGaussianBlur) {
        return FQXCommentMaterialNative;
    }
    return (FQXCommentMaterialStyle)mode;
}

static FQXCommentAppearanceMode FQXCurrentCommentAppearanceMode(void) {
    id stored = [NSUserDefaults.standardUserDefaults objectForKey:CommentAppearanceModePrefKey];
    if (!stored) return FQXCommentAppearanceFollowApp;
    NSInteger mode = [stored respondsToSelector:@selector(integerValue)] ? [stored integerValue] : 0;
    if (mode < FQXCommentAppearanceFollowApp || mode > FQXCommentAppearanceDark) {
        return FQXCommentAppearanceFollowApp;
    }
    return (FQXCommentAppearanceMode)mode;
}

static BOOL FQXCommentAppearanceOverrideActive(void) {
    return FQXCurrentCommentAppearanceMode() != FQXCommentAppearanceFollowApp;
}

static BOOL FQXAppIsInNightMode(void) {
    Class adapterCls = NSClassFromString(@"SSUIColorAdaptedManager");
    Class serviceCls = NSClassFromString(@"HTSServiceCenter");
    SEL defaultSel = NSSelectorFromString(@"defaultCenter");
    SEL getSel = NSSelectorFromString(@"getService:");
    if (adapterCls && serviceCls && [serviceCls respondsToSelector:defaultSel]) {
        id center = ((id (*)(id, SEL))objc_msgSend)(serviceCls, defaultSel);
        if (center && [center respondsToSelector:getSel]) {
            id adapter = ((id (*)(id, SEL, Class))objc_msgSend)(center, getSel, adapterCls);
            if (adapter) {
                SEL curDarkSel = NSSelectorFromString(@"isCurrentDarkMode");
                Method m = class_getInstanceMethod(object_getClass(adapter), curDarkSel);
                if (m && method_getNumberOfArguments(m) == 2) {
                    return ((BOOL (*)(id, SEL))objc_msgSend)(adapter, curDarkSel);
                }
                SEL darkSel = NSSelectorFromString(@"isDarkMode");
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
    FQXCommentAppearanceMode appMode = FQXCurrentCommentAppearanceMode();
    if (appMode == FQXCommentAppearanceLight) return NO;
    if (appMode == FQXCommentAppearanceDark) return YES;
    return FQXAppIsInNightMode();
}

static BOOL FQXGlassEnabled(void) {
    if ([NSUserDefaults.standardUserDefaults integerForKey:GlassDisabledPrefKey] != 0) return NO;
    Class glassCls = NSClassFromString(@"UIGlassEffect");
    Class cornerCls = NSClassFromString(@"UICornerConfiguration");
    return glassCls != Nil && cornerCls != Nil &&
           [glassCls respondsToSelector:NSSelectorFromString(@"effectWithStyle:")] &&
           [cornerCls respondsToSelector:NSSelectorFromString(@"capsuleConfiguration")] &&
           [UIVisualEffectView instancesRespondToSelector:NSSelectorFromString(@"setCornerConfiguration:")];
}

static BOOL FQXAudioGlassEnabled(void) {
    return FQXGlassEnabled() && [NSUserDefaults.standardUserDefaults boolForKey:AudioLiquidGlassPrefKey];
}

static BOOL FQXCommentStylingEnabled(void) {
    if ([NSUserDefaults.standardUserDefaults integerForKey:GlassDisabledPrefKey] != 0) return NO;
    FQXCommentMaterialStyle style = FQXCurrentCommentMaterialStyle();
    if (style == FQXCommentMaterialNative) return NO;
    if (style == FQXCommentMaterialGaussianBlur) return YES;
    return FQXGlassEnabled();
}

static BOOL FQXShouldOverrideCommentTheme(void) {
    return FQXCommentStylingEnabled() || FQXCommentAppearanceOverrideActive();
}

static UIUserInterfaceStyle FQXDesiredCommentInterfaceStyle(void) {
    if (!FQXShouldOverrideCommentTheme()) return UIUserInterfaceStyleUnspecified;
    return FQXCommentsUseDarkTheme() ? UIUserInterfaceStyleDark : UIUserInterfaceStyleLight;
}

static BOOL FQXCommentActivityBannerEnabled(void) {
    id stored = [NSUserDefaults.standardUserDefaults objectForKey:CommentActivityBannerPrefKey];
    return stored ? [stored boolValue] : YES;
}

static BOOL FQXCommentSearchEntranceEnabled(void) {
    id stored = [NSUserDefaults.standardUserDefaults objectForKey:CommentSearchEntrancePrefKey];
    return stored ? [stored boolValue] : YES;
}

// Unified Liquid Glass rendering layer shared across Dock, Short-Drama Comments, and Novel Comments.
// Dock dynamic background resampling adapts the iOS 26/27 pattern from ChenYilong/CYLTabBarController (MIT).
typedef NS_ENUM(NSInteger, FQXGlassRole) {
    FQXGlassRoleDock = 0,
    FQXGlassRoleCommentSheet = 1,
    FQXGlassRoleFloatingPill = 2,
    FQXGlassRoleExpandedComposer = 3,
    FQXGlassRoleClearCommentComposer = 4,
};

static const void *FQXUnifiedClearDockKey = &FQXUnifiedClearDockKey;
static const void *FQXOwnedGlassElementKey = &FQXOwnedGlassElementKey;
static const void *FQXNoVideoShiftSuppressedKey = &FQXNoVideoShiftSuppressedKey;
static const void *FQXAudioIndicatorDedupHiddenKey = &FQXAudioIndicatorDedupHiddenKey;
static const void *FQXCommentGlassStyleAppliedKey = &FQXCommentGlassStyleAppliedKey;
static const void *FQXDockHiddenByCommentKey = &FQXDockHiddenByCommentKey;
static const void *FQXSheetTopRimLayerKey = &FQXSheetTopRimLayerKey;
static const void *FQXSheetSavedCornerRadiusKey = &FQXSheetSavedCornerRadiusKey;
static const void *FQXSheetSavedMaskedCornersKey = &FQXSheetSavedMaskedCornersKey;
static const void *FQXCommentBannerSavedHeightKey = &FQXCommentBannerSavedHeightKey;
static const void *FQXReaderDisappearingKey = &FQXReaderDisappearingKey;
static const void *FQXReaderSwipeHiddenIndicatorKey = &FQXReaderSwipeHiddenIndicatorKey;
static const void *FQXShelfHeaderFixPendingKey = &FQXShelfHeaderFixPendingKey;
static const void *FQXCommentTypographyStampKey = &FQXCommentTypographyStampKey;

static UIVisualEffect *FQXMakeGlassEffect(NSInteger style, BOOL interactive, UIColor *tintColor) {
    Class glassCls = NSClassFromString(@"UIGlassEffect");
    SEL makeSel = NSSelectorFromString(@"effectWithStyle:");
    if (glassCls && [glassCls respondsToSelector:makeSel]) {
        UIVisualEffect *effect = ((id (*)(id, SEL, NSInteger))objc_msgSend)(glassCls, makeSel, style);
        if (effect) {
            SEL interactiveSel = NSSelectorFromString(@"setInteractive:");
            if ([effect respondsToSelector:interactiveSel]) {
                ((void (*)(id, SEL, BOOL))objc_msgSend)(effect, interactiveSel, interactive);
            }
            SEL tintSel = NSSelectorFromString(@"setTintColor:");
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

static NSInteger FQXDesiredGlassStampForRole(FQXGlassRole role) {
    NSInteger reduce = UIAccessibilityIsReduceTransparencyEnabled() ? 64 : 0;
    if (role == FQXGlassRoleDock) return 1 + reduce;
    FQXCommentMaterialStyle style = FQXCurrentCommentMaterialStyle();
    NSInteger darkBit = FQXCommentsUseDarkTheme() ? 1 : 0;
    return 100 + ((NSInteger)style * 16) + (darkBit * 8) + (NSInteger)role + reduce;
}

static UIVisualEffect *FQXMakeUnifiedGlassEffect(FQXGlassRole role) {
    BOOL reduce = UIAccessibilityIsReduceTransparencyEnabled();
    if (role == FQXGlassRoleDock) {
        return FQXMakeGlassEffect(reduce ? 0 : 1, YES, nil);
    }
    FQXCommentMaterialStyle style = FQXCurrentCommentMaterialStyle();
    BOOL dark = FQXCommentsUseDarkTheme();
    if (style == FQXCommentMaterialGaussianBlur) {
        UIBlurEffectStyle blurStyle;
        if (dark) {
            blurStyle = (role == FQXGlassRoleFloatingPill)
                ? UIBlurEffectStyleSystemThinMaterialDark
                : UIBlurEffectStyleSystemChromeMaterialDark;
        } else {
            blurStyle = (role == FQXGlassRoleFloatingPill)
                ? UIBlurEffectStyleSystemThinMaterialLight
                : UIBlurEffectStyleSystemChromeMaterialLight;
        }
        return [UIBlurEffect effectWithStyle:blurStyle];
    }
    BOOL clearComposer = (role == FQXGlassRoleClearCommentComposer);
    BOOL interactive = (role == FQXGlassRoleFloatingPill || clearComposer);
    NSInteger glassStyle = (reduce || role == FQXGlassRoleFloatingPill) ? 0 : 1;
    UIColor *tint = (!dark && !clearComposer &&
                     (role != FQXGlassRoleCommentSheet || reduce))
        ? [UIColor colorWithWhite:1.0 alpha:(role == FQXGlassRoleFloatingPill ? 0.34 : 0.24)]
        : nil;
    return FQXMakeGlassEffect(glassStyle, interactive, tint);
}

static void FQXApplyCornerConfiguration(UIView *view, CGFloat radius, BOOL continuousCard) {
    if (!view) return;
    Class cornerCls = NSClassFromString(@"UICornerConfiguration");
    SEL setCornerSel = NSSelectorFromString(@"setCornerConfiguration:");
    if (!cornerCls || ![view respondsToSelector:setCornerSel]) return;
    id config = nil;
    if (radius < 0.0 || (radius > 0.0 && continuousCard)) {
        Class radiusCls = NSClassFromString(@"UICornerRadius");
        SEL fixedSel = NSSelectorFromString(@"fixedRadius:");
        SEL uniformSel = NSSelectorFromString(@"configurationWithUniformRadius:");
        if (radiusCls && [radiusCls respondsToSelector:fixedSel] && [cornerCls respondsToSelector:uniformSel]) {
            CGFloat fixedR = radius < 0.0 ? 0.0 : radius;
            id radObj = ((id (*)(id, SEL, CGFloat))objc_msgSend)(radiusCls, fixedSel, fixedR);
            if (radObj) {
                config = ((id (*)(id, SEL, id))objc_msgSend)(cornerCls, uniformSel, radObj);
            }
        }
    }
    SEL maxSel = NSSelectorFromString(@"capsuleConfigurationWithMaximumRadius:");
    SEL capSel = NSSelectorFromString(@"capsuleConfiguration");
    if (!config && radius > 0.0 && [cornerCls respondsToSelector:maxSel]) {
        config = ((id (*)(id, SEL, CGFloat))objc_msgSend)(cornerCls, maxSel, radius);
    }
    if (!config && radius >= 0.0 && [cornerCls respondsToSelector:capSel]) {
        config = ((id (*)(id, SEL))objc_msgSend)(cornerCls, capSel);
    }
    if (config) {
        ((void (*)(id, SEL, id))objc_msgSend)(view, setCornerSel, config);
    }
}

static void FQXApplyUnifiedSurfaceCorners(UIVisualEffectView *surface,
                                          FQXGlassRole role,
                                          CGFloat radius,
                                          BOOL continuousCard) {
    if (!surface) return;
    BOOL useBlurCorners = (role != FQXGlassRoleDock &&
                           FQXCurrentCommentMaterialStyle() == FQXCommentMaterialGaussianBlur);
    if (useBlurCorners) {
        // NEVER pass nil to -[UIView setCornerConfiguration:] (nonnull on iOS 26/27, throws
        // NSInvalidArgumentException). Switching UIGlassEffect <-> UIBlurEffect recreates the
        // UIVisualEffectView via FQXEnsureUnifiedGlassView so default cornerConfiguration is clean.
        surface.layer.cornerCurve = kCACornerCurveContinuous;
        CGFloat half = MIN(CGRectGetWidth(surface.bounds), CGRectGetHeight(surface.bounds)) * 0.5;
        CGFloat r = radius < 0.0 ? 0.0 : (radius == 0.0 ? half : radius);
        if (fabs(surface.layer.cornerRadius - r) > 0.25) surface.layer.cornerRadius = r;
        if (!surface.clipsToBounds) surface.clipsToBounds = YES;
        return;
    }
    if (surface.layer.cornerRadius > 0.0) surface.layer.cornerRadius = 0.0;
    if (surface.clipsToBounds) surface.clipsToBounds = NO;
    FQXApplyCornerConfiguration(surface, radius, continuousCard);
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

static UIVisualEffectView *FQXNewUnifiedGlassView(FQXGlassRole role, CGFloat radius, BOOL continuousCard) {
    UIVisualEffect *effect = FQXMakeUnifiedGlassEffect(role);
    if (!effect) return nil;
    UIVisualEffectView *surface = [[UIVisualEffectView alloc] initWithEffect:effect];
    if (!surface) return nil;
    FQXApplyUnifiedSurfaceCorners(surface, role, radius, continuousCard);
    objc_setAssociatedObject(surface, FQXCommentGlassStyleAppliedKey, @(FQXDesiredGlassStampForRole(role)), OBJC_ASSOCIATION_RETAIN_NONATOMIC);
    surface.userInteractionEnabled = NO;
    surface.accessibilityElementsHidden = YES;
    surface.isAccessibilityElement = NO;
    surface.opaque = NO;
    surface.backgroundColor = UIColor.clearColor;
    surface.contentView.backgroundColor = UIColor.clearColor;
    return surface;
}

static void FQXSyncUnifiedGlassEffect(UIVisualEffectView *surface, FQXGlassRole role, CGFloat radius, BOOL continuousCard) {
    if (!surface) return;
    NSInteger desired = FQXDesiredGlassStampForRole(role);
    NSNumber *applied = objc_getAssociatedObject(surface, FQXCommentGlassStyleAppliedKey);
    if (!applied || applied.integerValue != desired) {
        UIVisualEffect *effect = FQXMakeUnifiedGlassEffect(role);
        if (effect) {
            surface.effect = effect;
            objc_setAssociatedObject(surface, FQXCommentGlassStyleAppliedKey, @(desired), OBJC_ASSOCIATION_RETAIN_NONATOMIC);
        }
    }
    FQXApplyUnifiedSurfaceCorners(surface, role, radius, continuousCard);
}

static UIVisualEffectView *FQXEnsureUnifiedGlassView(UIView *host,
                                                     const void *assocKey,
                                                     FQXGlassRole role,
                                                     CGFloat radius,
                                                     BOOL continuousCard) {
    if (!host || !assocKey) return nil;
    UIVisualEffectView *glass = objc_getAssociatedObject(host, assocKey);
    BOOL wantsBlur = (role != FQXGlassRoleDock &&
                      FQXCurrentCommentMaterialStyle() == FQXCommentMaterialGaussianBlur);
    BOOL isBlur = glass && [glass.effect isKindOfClass:UIBlurEffect.class];
    if (glass && wantsBlur != isBlur) {
        [glass removeFromSuperview];
        objc_setAssociatedObject(host, assocKey, nil, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
        glass = nil;
    }
    if (!glass) {
        glass = FQXNewUnifiedGlassView(role, radius, continuousCard);
        if (glass) {
            objc_setAssociatedObject(host, assocKey, glass, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
        }
    }
    return glass;
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

static void FQXUpgradeDockProxyToClearGlass(UIView *bar, UIVisualEffectView *proxy, UIVisualEffectView *lens) {
    if (!proxy || !FQXGlassEnabled()) return;
    // Upgrade dock glass from Regular (milky blur) to Clear (CoolApk crystal-clear refraction).
    BOOL reduceTrans = UIAccessibilityIsReduceTransparencyEnabled();
    NSNumber *appliedMode = objc_getAssociatedObject(proxy, FQXUnifiedClearDockKey);
    NSInteger desiredMode = reduceTrans ? 2 : 1;
    if (!appliedMode || appliedMode.integerValue != desiredMode) {
        UIVisualEffect *clearGlass = FQXMakeUnifiedGlassEffect(FQXGlassRoleDock);
        if (clearGlass) {
            proxy.effect = clearGlass;
            FQXApplyCornerConfiguration(proxy, 0.0, NO);
            objc_setAssociatedObject(proxy, FQXUnifiedClearDockKey, @(desiredMode), OBJC_ASSOCIATION_RETAIN_NONATOMIC);
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
    // Eliminate duplicate/milky sibling blur layers inside the tab bar so only one clean glass exists.
    // Never hide our own interactive UIGlassContainerEffect / droplet lens views.
    if (bar) {
        for (UIView *sub in [bar.subviews copy]) {
            if (sub == proxy || sub == lens || ![sub isKindOfClass:UIVisualEffectView.class]) continue;
            if ([objc_getAssociatedObject(sub, FQXOwnedGlassElementKey) boolValue]) continue;
            if (!sub.hidden) sub.hidden = YES;
        }
    }
    // Keep resting selection indicator subtle, unclipped, and matched to the dock appearance.
    if (lens) {
        UIUserInterfaceStyle dockStyle = proxy.overrideUserInterfaceStyle;
        if (lens.overrideUserInterfaceStyle != dockStyle) {
            lens.overrideUserInterfaceStyle = dockStyle;
        }
        if (lens.clipsToBounds) lens.clipsToBounds = NO;
        if (!lens.effect) {
            BOOL darkDock = (dockStyle == UIUserInterfaceStyleDark) ||
                            (dockStyle == UIUserInterfaceStyleUnspecified &&
                             proxy.traitCollection.userInterfaceStyle == UIUserInterfaceStyleDark);
            UIColor *airyFill = darkDock
                ? [UIColor colorWithWhite:1.0 alpha:0.14]
                : [UIColor colorWithWhite:0.0 alpha:0.065];
            if (![lens.contentView.backgroundColor isEqual:airyFill]) {
                lens.contentView.backgroundColor = airyFill;
            }
        }
    }
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

static UIView *FQXFindDockPlatter(UITabBar *tabBar) {
    static Class platterCls = Nil;
    static dispatch_once_t once;
    dispatch_once(&once, ^{ platterCls = NSClassFromString(@"UIKit._UITabBarPlatterView"); });
    if (!platterCls || !tabBar) return nil;
    UIView *first = FQXFindViewOfClassRecursive(tabBar, platterCls);
    if (!first) return nil;
    for (UIView *sib in first.superview.subviews) {
        if ([sib isKindOfClass:platterCls] && fabs(CGRectGetWidth(sib.bounds) - CGRectGetHeight(sib.bounds)) > 1.0) {
            return sib;
        }
    }
    return first;
}

// Upgrade UIKit._UITabBarPlatterView's glassEffect to Clear Liquid Glass while preserving
// Apple's native interactive=YES press/long-press floating glass lift and refraction lens.
static void FQXApplyDockPlatterClearGlass(UIView *platter, BOOL isDark) {
    if (!platter) return;
    NSNumber *applied = objc_getAssociatedObject(platter, FQXPlatterAppliedStyleKey);
    BOOL reduce = UIAccessibilityIsReduceTransparencyEnabled();
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
    NSInteger desiredStamp = isDark ? 2 : 1;
    if (applied && applied.integerValue == desiredStamp) return;
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
    // Clear Light uses nil tint; Clear Dark uses 30% black tint so icons read crisply over dark video.
    UIColor *tint = isDark ? [UIColor colorWithWhite:0.0 alpha:0.30] : nil;
    UIVisualEffect *clearEffect = FQXMakeGlassEffect(1, interactive, tint);
    if (!clearEffect) return;
    @try {
        [platter setValue:clearEffect forKey:@"glassEffect"];
    } @catch (__unused NSException *e) {
        gFQXPlatterGlassSupported = NO;
        return;
    }
    objc_setAssociatedObject(platter, FQXPlatterAppliedStyleKey, @(desiredStamp), OBJC_ASSOCIATION_RETAIN_NONATOMIC);
    [platter setNeedsLayout];
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

static UIImage *FQXDockTitleImage(NSString *title, UIColor *color) {
    if (!title.length) return nil;
    UIFont *font = [UIFont systemFontOfSize:14.5 weight:UIFontWeightSemibold];
    CGFloat maxW = 64.0;
    CGFloat w = [title sizeWithAttributes:@{NSFontAttributeName: font}].width;
    if (w > maxW) {
        font = [UIFont systemFontOfSize:MAX(11.0, floor(14.5 * maxW / w)) weight:UIFontWeightSemibold];
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

static UIImage *FQXDockIconCaptionImage(UIImage *icon, NSString *title, UIColor *color) {
    if (!icon) return FQXDockTitleImage(title, color);
    if (!title.length) return [icon imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
    NSMutableParagraphStyle *para = [[NSMutableParagraphStyle alloc] init];
    para.alignment = NSTextAlignmentCenter;
    para.lineBreakMode = NSLineBreakByTruncatingTail;
    NSDictionary *attrs = @{
        NSFontAttributeName: [UIFont systemFontOfSize:10.0 weight:UIFontWeightSemibold],
        NSForegroundColorAttributeName: color,
        NSParagraphStyleAttributeName: para,
    };
    CGSize textSz = [title sizeWithAttributes:attrs];
    CGFloat iconW = icon.size.width > 1.0 ? MIN(26.0, icon.size.width) : 22.0;
    CGFloat iconH = icon.size.height > 1.0 ? MIN(24.0, icon.size.height) : 22.0;
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
                                 BOOL iconsOnly,
                                 CGFloat iconPointSize,
                                 BOOL selected,
                                 UIColor *color) {
    CGFloat symPt = iconsOnly ? MAX(16.0, MIN(26.0, iconPointSize * 0.72)) : 18.0;
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
        return icon ?: FQXDockTitleImage(title, color);
    }
    return FQXDockIconCaptionImage(icon, title, color);
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

@interface FQXTabBarInteraction : NSObject <UITabBarDelegate>
@property(nonatomic, weak) UIView *bar;
@property(nonatomic, weak) UIVisualEffectView *proxy;
@property(nonatomic, weak) UIView *overlay;
@property(nonatomic, weak) UIView *nativeControl;
@property(nonatomic, weak) UIVisualEffectView *restingLens;
@property(nonatomic, copy) NSArray<UIButton *> *buttons;
@property(nonatomic, strong) NSHashTable<UIControl *> *wiredControls;
@property(nonatomic, strong) UITabBar *nativeDockBar;
@property(nonatomic, copy) NSString *dockSignature;
@property(nonatomic, copy) NSArray<NSString *> *dockTitles;
@property(nonatomic) UIUserInterfaceStyle dockAppliedStyle;
@property(nonatomic) BOOL dockPlatterMeasured;
@property(nonatomic) CGFloat dockPlatterHeight;
@property(nonatomic) CGFloat dockPlatterInset;
@property(nonatomic) CGFloat dockPlatterMidOffsetX;
@property(nonatomic) CGFloat dockPlatterMidOffsetY;
@property(nonatomic) CGRect dockLastProxyFrame;
@property(nonatomic) NSUInteger dockLastItemCount;
@property(nonatomic) BOOL nativeDockActive;
- (void)syncWithBar:(UIView *)bar
              proxy:(UIVisualEffectView *)proxy
            buttons:(NSArray<UIButton *> *)buttons
             native:(UIView *)native
               lens:(UIVisualEffectView *)lens;
- (void)updateLens:(UIVisualEffectView *)lens native:(UIView *)native;
- (void)teardown;
@end

@implementation FQXTabBarInteraction

- (instancetype)init {
    self = [super init];
    if (self) {
        _wiredControls = [NSHashTable weakObjectsHashTable];
        _dockAppliedStyle = UIUserInterfaceStyleUnspecified;
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

- (BOOL)dockIconsOnlyEnabled {
    return [NSUserDefaults.standardUserDefaults boolForKey:@"FanqieX.BottomIconsOnly.1"];
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
    BOOL isDark = (self.dockAppliedStyle == UIUserInterfaceStyleDark);
    CGFloat white = isDark ? 1.0 : 0.0;
    UIColor *selectedInk = [UIColor colorWithWhite:white alpha:1.0];
    UIColor *normalInk = [UIColor colorWithWhite:white alpha:(isDark ? 0.68 : 0.86)];
    BOOL iconsOnly = [self dockIconsOnlyEnabled];
    CGFloat ptSize = [self dockIconPointSize];
    NSArray<UITabBarItem *> *items = tabBar.items;
    NSArray<NSString *> *titles = self.dockTitles;
    NSArray<UIButton *> *buttons = self.buttons;
    for (NSUInteger i = 0; i < items.count; ++i) {
        UITabBarItem *item = items[i];
        NSString *title = (i < titles.count) ? titles[i] : (item.accessibilityLabel ?: @"");
        UIButton *btn = (i < buttons.count && [buttons[i] isKindOfClass:UIButton.class]) ? buttons[i] : nil;
        item.image = FQXDockItemImage(title, btn, iconsOnly, ptSize, NO, normalInk);
        item.selectedImage = FQXDockItemImage(title, btn, iconsOnly, ptSize, YES, selectedInk);
    }
}

- (BOOL)syncDockItems {
    UITabBar *tabBar = self.nativeDockBar;
    if (!tabBar || !self.buttons.count) return NO;
    BOOL iconsOnly = [self dockIconsOnlyEnabled];
    CGFloat ptSize = [self dockIconPointSize];
    NSMutableArray<NSString *> *titles = [NSMutableArray arrayWithCapacity:self.buttons.count];
    NSMutableString *sig = [NSMutableString stringWithFormat:@"io=%d|pt=%.1f|", iconsOnly ? 1 : 0, ptSize];
    for (NSUInteger i = 0; i < self.buttons.count; ++i) {
        UIButton *btn = self.buttons[i];
        NSString *title = [btn isKindOfClass:UIButton.class] ? FQXDockButtonTitle(btn, self.bar, i) : @"";
        [titles addObject:title];
        [sig appendFormat:@"%@|", title];
    }
    BOOL rebuilt = ![sig isEqualToString:self.dockSignature];
    if (rebuilt) {
        NSMutableArray<UITabBarItem *> *items = [NSMutableArray arrayWithCapacity:titles.count];
        for (NSUInteger i = 0; i < titles.count; ++i) {
            UITabBarItem *item = [[UITabBarItem alloc] initWithTitle:nil image:nil tag:(NSInteger)i];
            item.accessibilityLabel = titles[i];
            [items addObject:item];
        }
        self.dockTitles = titles;
        self.dockSignature = sig;
        tabBar.items = items;
        [self applyDockItemImages];
    }
    NSUInteger selIdx = [self currentSelectedIndex];
    if (selIdx < tabBar.items.count) {
        UITabBarItem *desiredItem = tabBar.items[selIdx];
        if (tabBar.selectedItem != desiredItem) {
            tabBar.selectedItem = desiredItem;
        }
    }
    return rebuilt;
}

- (void)layoutNativeDockInBar:(UIView *)bar proxy:(UIVisualEffectView *)proxy forceMeasure:(BOOL)forceMeasure {
    UITabBar *tabBar = self.nativeDockBar;
    if (!tabBar || !bar || !proxy) return;
    CGRect proxyFrame = proxy.frame;
    if (CGRectGetWidth(proxyFrame) < 60.0 || CGRectGetHeight(proxyFrame) < 30.0) return;

    NSUInteger itemCount = tabBar.items.count;
    BOOL geometryChanged = forceMeasure || !self.dockPlatterMeasured ||
                           itemCount != self.dockLastItemCount ||
                           fabs(CGRectGetMinX(proxyFrame) - CGRectGetMinX(self.dockLastProxyFrame)) > 0.5 ||
                           fabs(CGRectGetMinY(proxyFrame) - CGRectGetMinY(self.dockLastProxyFrame)) > 0.5 ||
                           fabs(CGRectGetWidth(proxyFrame) - CGRectGetWidth(self.dockLastProxyFrame)) > 0.5 ||
                           fabs(CGRectGetHeight(proxyFrame) - CGRectGetHeight(self.dockLastProxyFrame)) > 0.5;

    BOOL isDark = (self.dockAppliedStyle == UIUserInterfaceStyleDark);
    if (!geometryChanged) {
        UIView *platter = FQXFindDockPlatter(tabBar);
        if (platter) FQXApplyDockPlatterClearGlass(platter, isDark);
        return;
    }

    CGFloat barH = MAX(CGRectGetHeight(bar.bounds), CGRectGetHeight(proxyFrame) + 12.0);
    CGFloat targetW = CGRectGetWidth(proxyFrame);
    CGFloat targetH = CGRectGetHeight(proxyFrame);
    UIView *platter = nil;

    for (NSUInteger pass = 0; pass < 2; ++pass) {
        CGFloat platterH = self.dockPlatterHeight > 20.0 ? self.dockPlatterHeight : 62.0;
        CGFloat scale = MAX(0.70, MIN(1.30, targetH / platterH));
        CGFloat desiredBarW = (targetW / scale) + 2.0 * self.dockPlatterInset;
        CGRect curBounds = tabBar.bounds;
        if (fabs(CGRectGetWidth(curBounds) - desiredBarW) > 0.5 || fabs(CGRectGetHeight(curBounds) - barH) > 0.5) {
            tabBar.bounds = CGRectMake(0.0, 0.0, desiredBarW, barH);
        }
        [tabBar layoutIfNeeded];
        platter = FQXFindDockPlatter(tabBar);
        if (!platter || CGRectGetHeight(platter.bounds) <= 10.0) break;

        CGRect pf = [platter convertRect:platter.bounds toView:tabBar];
        CGFloat measuredH = CGRectGetHeight(pf);
        CGFloat measuredInset = MAX(4.0, (CGRectGetWidth(tabBar.bounds) - CGRectGetWidth(pf)) * 0.5);
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

    if (platter) {
        FQXApplyDockPlatterClearGlass(platter, isDark);
    }

    CGFloat finalScale = MAX(0.70, MIN(1.30, targetH / MAX(20.0, self.dockPlatterHeight)));
    CGPoint center = CGPointMake(CGRectGetMidX(proxyFrame) - self.dockPlatterMidOffsetX * finalScale,
                                 CGRectGetMidY(proxyFrame) - self.dockPlatterMidOffsetY * finalScale);
    if (fabs(tabBar.center.x - center.x) > 0.25 || fabs(tabBar.center.y - center.y) > 0.25) {
        tabBar.center = center;
    }
    CGAffineTransform xform = CGAffineTransformMakeScale(finalScale, finalScale);
    if (!CGAffineTransformEqualToTransform(tabBar.transform, xform)) {
        tabBar.transform = xform;
    }
    self.dockLastProxyFrame = proxyFrame;
    self.dockLastItemCount = itemCount;
}

- (void)setNativeDockVisible:(BOOL)visible restoreProxy:(BOOL)restoreProxy {
    if (self.nativeDockBar && self.nativeDockBar.hidden == visible) {
        self.nativeDockBar.hidden = !visible;
    }
    if (visible) {
        if (self.proxy && self.proxy.layer.opacity != 0.0f) self.proxy.layer.opacity = 0.0f;
        if (self.overlay) {
            if (self.overlay.layer.opacity != 0.0f) self.overlay.layer.opacity = 0.0f;
            if (self.overlay.userInteractionEnabled) self.overlay.userInteractionEnabled = NO;
        }
        self.nativeDockActive = YES;
    } else {
        if (restoreProxy) {
            if (self.proxy && self.proxy.layer.opacity != 1.0f) self.proxy.layer.opacity = 1.0f;
            if (self.overlay) {
                if (self.overlay.layer.opacity != 1.0f) self.overlay.layer.opacity = 1.0f;
                if (!self.overlay.userInteractionEnabled) self.overlay.userInteractionEnabled = YES;
            }
        }
        self.nativeDockActive = NO;
    }
}

#pragma mark - UITabBarDelegate

- (void)tabBar:(UITabBar *)tabBar didSelectItem:(UITabBarItem *)item {
    NSUInteger idx = [tabBar.items indexOfObjectIdenticalTo:item];
    if (idx == NSNotFound || idx >= self.buttons.count) return;
    UIButton *btn = self.buttons[idx];
    if (![btn isKindOfClass:UIButton.class]) return;
    [btn sendActionsForControlEvents:UIControlEventTouchUpInside];
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
        if (self.nativeDockActive && self.overlay) {
            if (self.overlay.layer.opacity != 0.0f) self.overlay.layer.opacity = 0.0f;
            if (self.overlay.userInteractionEnabled) self.overlay.userInteractionEnabled = NO;
        }
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
        self.dockSignature = nil;
        self.dockPlatterMeasured = NO;
        self.dockAppliedStyle = UIUserInterfaceStyleUnspecified;
    }
    self.bar = bar;
    self.proxy = proxy;
    self.nativeControl = native;
    if (lens) self.restingLens = lens;
    self.buttons = buttons;
    FQXUpgradeDockProxyToClearGlass(bar, proxy, lens);

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
    UIView *anchor = (overlay && overlay.superview == bar) ? overlay : (proxy.superview == bar ? proxy : nil);
    if (anchor) {
        NSUInteger nativeIdx = [bar.subviews indexOfObjectIdenticalTo:self.nativeDockBar];
        NSUInteger anchorIdx = [bar.subviews indexOfObjectIdenticalTo:anchor];
        if (nativeIdx == NSNotFound || (anchorIdx != NSNotFound && nativeIdx < anchorIdx)) {
            [bar insertSubview:self.nativeDockBar aboveSubview:anchor];
        }
    }

    UIUserInterfaceStyle desiredStyle = [self isDarkDock] ? UIUserInterfaceStyleDark : UIUserInterfaceStyleLight;
    BOOL styleChanged = (self.dockAppliedStyle != desiredStyle);
    if (styleChanged) {
        self.dockAppliedStyle = desiredStyle;
        if (self.nativeDockBar.overrideUserInterfaceStyle != desiredStyle) {
            self.nativeDockBar.overrideUserInterfaceStyle = desiredStyle;
        }
    }

    BOOL itemsRebuilt = [self syncDockItems];
    if (styleChanged && !itemsRebuilt) {
        [self applyDockItemImages];
    }

    [self layoutNativeDockInBar:bar proxy:proxy forceMeasure:itemsRebuilt];
    [self setNativeDockVisible:YES restoreProxy:NO];
}

- (void)teardown {
    [self setNativeDockVisible:NO restoreProxy:YES];
    self.nativeDockBar.delegate = nil;
    [self.nativeDockBar removeFromSuperview];
    self.nativeDockBar = nil;
    self.dockSignature = nil;
    self.dockTitles = nil;
    self.dockPlatterMeasured = NO;
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
@property(nonatomic) NSInteger hoverIndex;
@property(nonatomic) CGFloat anchorX;
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

- (void)applyMaterialToOuter:(UIVisualEffectView *)outer isDark:(BOOL)isDark {
    if (!outer || !self.pillGlass) return;
    BOOL reduce = UIAccessibilityIsReduceTransparencyEnabled();
    NSInteger stamp = (isDark ? 2 : 1) | (reduce ? 4 : 0);
    NSNumber *applied = objc_getAssociatedObject(outer, FQXDramaTopGlassStampKey);
    if (applied && applied.integerValue == stamp) return;
    objc_setAssociatedObject(outer, FQXDramaTopGlassStampKey, @(stamp), OBJC_ASSOCIATION_RETAIN_NONATOMIC);

    UIUserInterfaceStyle uiStyle = isDark ? UIUserInterfaceStyleDark : UIUserInterfaceStyleLight;
    NSInteger glassStyle = reduce ? 0 : 1;
    UIColor *outerTint = (!reduce && isDark) ? [UIColor colorWithWhite:0.0 alpha:0.30] : nil;
    UIColor *pillTint = [UIColor colorWithWhite:0.0 alpha:(isDark ? 0.50 : 0.10)];
    void (^changes)(void) = ^{
        outer.overrideUserInterfaceStyle = uiStyle;
        outer.effect = FQXMakeGlassEffect(glassStyle, NO, outerTint);
        self.pillGlass.overrideUserInterfaceStyle = uiStyle;
        self.pillGlass.effect = FQXMakeGlassEffect(glassStyle, YES, pillTint);
    };
    if (applied) {
        [UIView animateWithDuration:0.20 animations:changes];
    } else {
        changes();
    }
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
        } completion:nil];
    } else {
        [UIView performWithoutAnimation:^{
            self.pillGlass.frame = target;
        }];
    }
}

- (void)placePillAtRestingAnimated:(BOOL)animated {
    if (self.flatLens && !self.flatLens.hidden && CGRectGetWidth(self.flatLens.frame) >= 12.0) {
        [self placePill:self.flatLens.frame animated:animated];
        return;
    }
    NSInteger sel = [self currentHostSelectedIndex];
    UICollectionView *cv = self.collectionView;
    if (sel != NSNotFound && cv) {
        UICollectionViewLayoutAttributes *attr = [cv layoutAttributesForItemAtIndexPath:[NSIndexPath indexPathForItem:sel inSection:0]];
        if (attr && CGRectGetWidth(attr.frame) >= 6.0) {
            self.anchorX = CGRectGetMidX(attr.frame);
            [self placePill:[self pillRectForAnchorX:self.anchorX] animated:animated];
        }
    }
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
        self.anchorX = CGRectGetMidX(attr.frame);
        [self placePill:[self pillRectForAnchorX:self.anchorX] animated:YES];
    } else if (gr.state == UIGestureRecognizerStateEnded ||
               gr.state == UIGestureRecognizerStateCancelled ||
               gr.state == UIGestureRecognizerStateFailed) {
        if (self.mode != FQXTopCapsuleTouchPressing) return;
        self.mode = FQXTopCapsuleTouchIdle;
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
        self.hoverIndex = [self currentHostSelectedIndex];
        cv.panGestureRecognizer.enabled = NO;
        UIImpactFeedbackGenerator *impact = [[UIImpactFeedbackGenerator alloc] initWithStyle:UIImpactFeedbackStyleLight];
        [impact impactOccurred];
        [self updateDragAtGesture:gr animated:YES];
    } else if (gr.state == UIGestureRecognizerStateChanged) {
        [self updateDragAtGesture:gr animated:NO];
    } else if (self.mode == FQXTopCapsuleTouchDragging) {
        self.mode = FQXTopCapsuleTouchIdle;
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

- (void)invalidate {
    if (self.pressGesture.view) [self.pressGesture.view removeGestureRecognizer:self.pressGesture];
    if (self.dragGesture.view) [self.dragGesture.view removeGestureRecognizer:self.dragGesture];
    [self.pillGlass removeFromSuperview];
    self.pillGlass = nil;
    if (self.flatLens && self.flatLens.layer.opacity != 1.0f) self.flatLens.layer.opacity = 1.0f;
    if (self.mode == FQXTopCapsuleTouchDragging && self.collectionView) {
        self.collectionView.panGestureRecognizer.enabled = YES;
    }
    self.mode = FQXTopCapsuleTouchIdle;
}

- (void)syncWithTabs:(UIView *)tabs {
    if (!tabs || !FQXGlassEnabled()) {
        [self invalidate];
        return;
    }
    UIView *categories = tabs.superview;
    UICollectionView *cv = FQXObjGet(tabs, "collectionView");
    if (!categories || ![cv isKindOfClass:UICollectionView.class]) return;

    UIVisualEffectView *outer = nil;
    for (UIView *sub in categories.subviews) {
        if ([sub isKindOfClass:UIVisualEffectView.class] && ![sub isKindOfClass:FQXFlexGlassView.class] &&
            !sub.hidden && CGRectGetWidth(sub.bounds) >= 60.0 && CGRectGetHeight(sub.bounds) <= 48.0) {
            outer = (UIVisualEffectView *)sub;
            break;
        }
    }
    if (!outer) {
        if (self.pillGlass) self.pillGlass.hidden = YES;
        return;
    }

    UIView *flat = nil;
    for (UIView *sub in outer.contentView.subviews) {
        if (sub != self.pillGlass && ![sub isKindOfClass:FQXFlexGlassView.class]) {
            flat = sub;
            break;
        }
    }

    self.tabsView = tabs;
    self.collectionView = cv;
    self.outerGlass = outer;
    self.flatLens = flat;
    if (flat && flat.layer.opacity != 0.0f) flat.layer.opacity = 0.0f;

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

    BOOL isDark = (outer.overrideUserInterfaceStyle == UIUserInterfaceStyleDark) ||
                  (outer.overrideUserInterfaceStyle == UIUserInterfaceStyleUnspecified &&
                   outer.traitCollection.userInterfaceStyle == UIUserInterfaceStyleDark);
    [self applyMaterialToOuter:outer isDark:isDark];

    if (self.mode == FQXTopCapsuleTouchIdle) {
        NSInteger sel = [self currentHostSelectedIndex];
        BOOL selChanged = (self.lastSelectedIndex != NSNotFound && sel != NSNotFound && sel != self.lastSelectedIndex);
        self.lastSelectedIndex = sel;
        [self placePillAtRestingAnimated:selChanged];
    }
}

@end

static void FQXSyncDramaTopCapsuleForHeader(UIView *header) {
    if (!header || !FQXGlassEnabled()) return;
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

static void (*OrigDramaTabsLayoutForCapsule)(id, SEL);
static void HookDramaTabsLayoutForCapsule(UIView *tabs, SEL cmd) {
    if (OrigDramaTabsLayoutForCapsule) OrigDramaTabsLayoutForCapsule(tabs, cmd);
    FQXDramaTopCapsuleInteraction *interaction = objc_getAssociatedObject(tabs, FQXDramaTopCapsuleKey);
    if (interaction) [interaction syncWithTabs:tabs];
}

static void FQXRefreshAllAudioGlass(void);
static void FQXRefreshAllDramaControlsInWindows(void);
static void FQXRefreshAllPinchCleanStates(void);
static void FQXReapplyAllTrackedCommentGlass(void);
static void FQXCompactRuntimeMemory(void);

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
+ (void)refreshDramaPinchClean;
+ (void)refreshCommentGlass;
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
    [interaction syncWithBar:bar proxy:proxy buttons:buttons native:native lens:lens];
}

+ (void)refreshAudioGlass {
    FQXRefreshAllAudioGlass();
}

+ (void)refreshDramaControls {
    FQXRefreshAllDramaControlsInWindows();
}

+ (void)refreshDramaPinchClean {
    FQXRefreshAllPinchCleanStates();
}

+ (void)refreshCommentGlass {
    FQXReapplyAllTrackedCommentGlass();
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

static void (*OrigShortVideoListWillAppear)(id, SEL, BOOL);
static void HookShortVideoListWillAppear(UIViewController *self, SEL _cmd, BOOL animated) {
    if (OrigShortVideoListWillAppear) OrigShortVideoListWillAppear(self, _cmd, animated);
    FQXRefreshDramaControllerControls(self, YES);
}

static void (*OrigShortVideoListDidAppear)(id, SEL, BOOL);
static void HookShortVideoListDidAppear(UIViewController *self, SEL _cmd, BOOL animated) {
    if (OrigShortVideoListDidAppear) OrigShortVideoListDidAppear(self, _cmd, animated);
    FQXRefreshDramaControllerControls(self, NO);
}

static void (*OrigSeriesFeedWillAppear)(id, SEL, BOOL);
static void HookSeriesFeedWillAppear(UIViewController *self, SEL _cmd, BOOL animated) {
    if (OrigSeriesFeedWillAppear) OrigSeriesFeedWillAppear(self, _cmd, animated);
    FQXRefreshDramaControllerControls(self, YES);
}

static void (*OrigSeriesFeedDidAppear)(id, SEL, BOOL);
static void HookSeriesFeedDidAppear(UIViewController *self, SEL _cmd, BOOL animated) {
    if (OrigSeriesFeedDidAppear) OrigSeriesFeedDidAppear(self, _cmd, animated);
    FQXRefreshDramaControllerControls(self, NO);
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

static void FQXHideViewForPinchClean(UIView *target, NSHashTable<UIView *> *hiddenSet) {
    if (![target isKindOfClass:UIView.class]) return;
    if (!target.hidden) {
        [hiddenSet addObject:target];
        target.hidden = YES;
    }
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
    [FQXPinchCleanControls() addObject:control];

    id hostContext = FQXObjGet(control, "hostContext");
    id context = FQXObjGet(control, "listVCContext") ?: FQXObjGet(hostContext, "listVCContext");

    if (enterClean) {
        objc_setAssociatedObject(control, FQXPinchPureCleanActiveKey, @YES, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
        NSHashTable<UIView *> *hiddenSet = objc_getAssociatedObject(control, FQXPinchHiddenViewsKey);
        if (!hiddenSet) {
            hiddenSet = [NSHashTable weakObjectsHashTable];
            objc_setAssociatedObject(control, FQXPinchHiddenViewsKey, hiddenSet, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
        }

        Class outerCls = NSClassFromString(@"SSShortVideoOutterMultiGenreFeedControlView");
        if (outerCls && [control isKindOfClass:outerCls]) {
            const char *outerKeys[] = {
                "aboveProgressView", "progressView", "rightInteractionView",
                "baseInfoView", "bookCardView", "progressFloatView", "playBtn",
                "topGradientView", "bottomGradientView"
            };
            for (size_t i = 0; i < sizeof(outerKeys) / sizeof(outerKeys[0]); ++i) {
                FQXHideViewForPinchClean(FQXObjGet(control, outerKeys[i]), hiddenSet);
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
        NSHashTable<UIView *> *hiddenSet = objc_getAssociatedObject(control, FQXPinchHiddenViewsKey);
        objc_setAssociatedObject(control, FQXPinchHiddenViewsKey, nil, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
        for (UIView *view in hiddenSet.allObjects) view.hidden = NO;
        [control setNeedsLayout];
    }
}

static void FQXRefreshAllPinchCleanStates(void) {
    if (!FQXPinchPureCleanEnabled()) {
        for (UIView *control in [FQXPinchCleanControls() allObjects]) {
            if ([objc_getAssociatedObject(control, FQXPinchPureCleanActiveKey) boolValue]) {
                FQXApplyPinchPureCleanState(control, NO);
            }
        }
    }
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
    if (gesture.numberOfTouches >= 2) return YES;
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

- (void)triggerHaptic {
    if (!FQXPinchHapticEnabled()) return;
    UIImpactFeedbackGenerator *gen = [[UIImpactFeedbackGenerator alloc] initWithStyle:UIImpactFeedbackStyleLight];
    [gen impactOccurred];
}

- (void)handlePinch:(FQXDramaPinchGestureRecognizer *)pinch {
    UIView *control = pinch.view;
    if (!control || !FQXPinchPureCleanEnabled()) return;
    UIGestureRecognizerState state = pinch.state;
    if (state == UIGestureRecognizerStateBegan) {
        objc_setAssociatedObject(pinch, FQXPinchTriggeredInGestureKey, nil, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
        if (FQXBoolGet(control, "isDraggingProgress", NO) || FQXBoolGet(control, "isSeekingProgress", NO)) {
            SEL reset = sel_registerName("resetProgressInteractionForInterruption");
            if ([control respondsToSelector:reset]) ((void (*)(id, SEL))objc_msgSend)(control, reset);
        } else if (FQXBoolGet(control, "isDragingProgress", NO)) {
            UIGestureRecognizer *seek = FQXObjGet(control, "progressPanGesture");
            if (seek.enabled) {
                seek.enabled = NO;
                seek.enabled = YES;
            }
        }
        return;
    }
    BOOL alreadyTriggered = [objc_getAssociatedObject(pinch, FQXPinchTriggeredInGestureKey) boolValue];
    BOOL isClean = [objc_getAssociatedObject(control, FQXPinchPureCleanActiveKey) boolValue];

    if (state == UIGestureRecognizerStateChanged && !alreadyTriggered) {
        if (pinch.scale >= 1.15 && !isClean) {
            objc_setAssociatedObject(pinch, FQXPinchTriggeredInGestureKey, @YES, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
            [self triggerHaptic];
            FQXApplyPinchPureCleanState(control, YES);
        }
    } else if (state == UIGestureRecognizerStateEnded && !alreadyTriggered) {
        if ((pinch.scale >= 1.10 || (pinch.scale > 1.03 && pinch.velocity > 0.35)) && !isClean) {
            [self triggerHaptic];
            FQXApplyPinchPureCleanState(control, YES);
        } else if ((pinch.scale <= 0.90 || (pinch.scale < 0.97 && pinch.velocity < -0.35)) && isClean) {
            [self triggerHaptic];
            FQXApplyPinchPureCleanState(control, NO);
        }
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
    if ([objc_getAssociatedObject(self, FQXPinchPureCleanActiveKey) boolValue]) {
        FQXApplyPinchPureCleanState(self, YES);
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

static void (*OrigGestureCompPinch)(id, SEL, id);
static void HookGestureCompPinch(id self, SEL _cmd, UIPinchGestureRecognizer *gesture) {
    if (FQXPinchPureCleanEnabled() && ![gesture isKindOfClass:FQXDramaPinchGestureRecognizer.class]) {
        UIView *view = gesture.view;
        if (view.window && view.window.bounds.size.height > view.window.bounds.size.width) {
            return;
        }
    }
    if (OrigGestureCompPinch) OrigGestureCompPinch(self, _cmd, gesture);
}

static BOOL (*OrigGestureCompShouldBegin)(id, SEL, id);
static BOOL HookGestureCompShouldBegin(id self, SEL _cmd, UIGestureRecognizer *gesture) {
    if (FQXPinchPureCleanEnabled() && [gesture isKindOfClass:UIPinchGestureRecognizer.class] &&
        ![gesture isKindOfClass:FQXDramaPinchGestureRecognizer.class]) {
        UIView *view = gesture.view;
        if (view.window && view.window.bounds.size.height > view.window.bounds.size.width) {
            return NO;
        }
    }
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
    FQXExitPinchCleanInViewController(self);
    if (OrigShortVideoListWillDisappear) OrigShortVideoListWillDisappear(self, _cmd, animated);
}

static void (*OrigSeriesFeedWillDisappear)(id, SEL, BOOL);
static void HookSeriesFeedWillDisappear(UIViewController *self, SEL _cmd, BOOL animated) {
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

static void (*OrigReaderNavLayoutMotion)(id, SEL);
static void HookReaderNavLayoutMotion(UIView *self, SEL cmd) {
    OrigReaderNavLayoutMotion(self, cmd);
    UIButton *button = FQXObjGet(self, "backBtn");
    if ([button isKindOfClass:UIButton.class]) FQXCenterReaderBackButton(button);
}

#pragma mark - Mine Shortcut Card Fold Clipping Fix ("我的" 第6个按钮溢出修复)

static void (*OrigScrollFoldLayout)(id, SEL);
static void HookScrollFoldLayout(UIView *self, SEL _cmd) {
    if (OrigScrollFoldLayout) OrigScrollFoldLayout(self, _cmd);
    if (FQXGlassEnabled()) {
        if (!self.clipsToBounds) self.clipsToBounds = YES;
        UICollectionView *cv = FQXObjGet(self, "collectionView");
        if ([cv isKindOfClass:UICollectionView.class] && !cv.clipsToBounds) {
            cv.clipsToBounds = YES;
        }
    }
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
    UIView *header = FQXObjGet(cell, "headerView");
    if (![header isKindOfClass:UIView.class]) return;
    FQXFixShelfHeaderEditFilterOverlap(header);
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

static void FQXSyncGlassStyleForDark(UIVisualEffectView *glass, BOOL dark) {
    if (!glass) return;
    UIUserInterfaceStyle desired = dark ? UIUserInterfaceStyleDark : UIUserInterfaceStyleLight;
    if (glass.overrideUserInterfaceStyle != desired) glass.overrideUserInterfaceStyle = desired;
}

static void FQXApplyCommentGlassBacking(UIVisualEffectView *glass, UIColor *scrimColor, CGFloat radius, BOOL continuous) {
    if (!glass) return;
    FQXSyncGlassStyleForDark(glass, FQXCommentsUseDarkTheme());
    UIColor *scrim = scrimColor ?: UIColor.clearColor;
    if (![glass.contentView.backgroundColor isEqual:scrim]) {
        glass.contentView.backgroundColor = scrim;
    }
    CGFloat halfSide = MIN(CGRectGetWidth(glass.bounds), CGRectGetHeight(glass.bounds)) * 0.5;
    CGFloat targetRadius = radius < 0.0 ? 0.0 : (radius > 0.0 ? MIN(radius, halfSide) : halfSide);
    glass.contentView.layer.cornerCurve = continuous ? kCACornerCurveContinuous : kCACornerCurveCircular;
    if (fabs(glass.contentView.layer.cornerRadius - targetRadius) > 0.25) {
        glass.contentView.layer.cornerRadius = targetRadius;
    }
    if (!glass.contentView.clipsToBounds) glass.contentView.clipsToBounds = YES;
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
    return FQXCurrentCommentMaterialStyle() == FQXCommentMaterialLiquidGlass && FQXCommentsUseDarkTheme();
}

static void FQXSyncLabelShadowForCommentMode(UILabel *label) {
    if (!label) return;
    if (FQXCommentUsesTextShadow()) {
        label.shadowColor = [UIColor colorWithWhite:0.0 alpha:0.36];
        label.shadowOffset = CGSizeMake(0.0, 0.5);
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
    if (!view || !FQXCommentStylingEnabled()) return;
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
            ((void (*)(id, SEL, BOOL))objc_msgSend)(view, setIsDarkSel, FQXCommentsUseDarkTheme());
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

static void FQXNeutralizeStrayBarGlass(UIView *view, UIVisualEffectView *keepGlass, BOOL active, NSInteger depth) {
    if (![view isKindOfClass:UIView.class] || depth > 4) return;
    Class glassBtnCls = NSClassFromString(@"FQXGlassBackground167");
    for (UIView *child in view.subviews) {
        if (child == keepGlass) continue;
        if ([child isKindOfClass:UIVisualEffectView.class]) {
            UIVisualEffectView *effectView = (UIVisualEffectView *)child;
            UIVisualEffect *saved = objc_getAssociatedObject(effectView, CommentStockEffectKey);
            if (active && effectView.effect) {
                objc_setAssociatedObject(effectView, CommentStockEffectKey, effectView.effect, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
                effectView.effect = nil;
            } else if (!active && saved) {
                if (!effectView.effect) effectView.effect = saved;
                objc_setAssociatedObject(effectView, CommentStockEffectKey, nil, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
            }
            FQXAudioClearBackground(effectView, active);
            FQXAudioClearBackground(effectView.contentView, active);
            FQXAudioSetHiddenTracked(effectView, active);
            continue;
        }
        if (glassBtnCls && [child isKindOfClass:glassBtnCls]) {
            FQXAudioSetHiddenTracked(child, active);
            continue;
        }
        FQXNeutralizeStrayBarGlass(child, keepGlass, active, depth + 1);
    }
}

static void FQXSyncSheetTopRimLayer(UIView *sheet, CGFloat radius, CGFloat lineWidth, CGFloat alpha) {
    if (!sheet) return;
    CGFloat w = CGRectGetWidth(sheet.bounds);
    if (w < 60.0 || radius < 2.0) return;
    CAShapeLayer *rim = objc_getAssociatedObject(sheet, FQXSheetTopRimLayerKey);
    if (!rim) {
        rim = [CAShapeLayer layer];
        rim.fillColor = UIColor.clearColor.CGColor;
        rim.lineCap = kCALineCapRound;
        rim.zPosition = 999.0;
        objc_setAssociatedObject(sheet, FQXSheetTopRimLayerKey, rim, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
    }
    CGFloat r = MIN(radius, w * 0.5);
    CGFloat inset = lineWidth * 0.5;
    UIBezierPath *path = [UIBezierPath bezierPath];
    // Top-left quarter arc -> top edge -> top-right quarter arc ONLY (no vertical left/right borders).
    [path moveToPoint:CGPointMake(inset, r)];
    [path addArcWithCenter:CGPointMake(r, r) radius:MAX(1.0, r - inset) startAngle:M_PI endAngle:(CGFloat)(1.5 * M_PI) clockwise:YES];
    [path addLineToPoint:CGPointMake(w - r, inset)];
    [path addArcWithCenter:CGPointMake(w - r, r) radius:MAX(1.0, r - inset) startAngle:(CGFloat)(1.5 * M_PI) endAngle:0.0 clockwise:YES];
    rim.path = path.CGPath;
    rim.lineWidth = lineWidth;
    rim.strokeColor = [UIColor colorWithWhite:1.0 alpha:alpha].CGColor;
    rim.frame = sheet.bounds;
    if (rim.superlayer != sheet.layer) [sheet.layer addSublayer:rim];
}

static void FQXRemoveSheetTopRimLayer(UIView *sheet) {
    if (!sheet) return;
    CAShapeLayer *rim = objc_getAssociatedObject(sheet, FQXSheetTopRimLayerKey);
    if (rim) {
        [rim removeFromSuperlayer];
        objc_setAssociatedObject(sheet, FQXSheetTopRimLayerKey, nil, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
    }
}

static void FQXApplySheetTopCornerMask(UIView *sheet, CGFloat radius) {
    if (!sheet) return;
    if (!objc_getAssociatedObject(sheet, SheetSavedClipsKey)) {
        objc_setAssociatedObject(sheet, SheetSavedClipsKey, @(sheet.clipsToBounds), OBJC_ASSOCIATION_RETAIN_NONATOMIC);
    }
    if (!objc_getAssociatedObject(sheet, FQXSheetSavedCornerRadiusKey)) {
        objc_setAssociatedObject(sheet, FQXSheetSavedCornerRadiusKey, @(sheet.layer.cornerRadius), OBJC_ASSOCIATION_RETAIN_NONATOMIC);
    }
    if (!objc_getAssociatedObject(sheet, FQXSheetSavedMaskedCornersKey)) {
        objc_setAssociatedObject(sheet, FQXSheetSavedMaskedCornersKey, @(sheet.layer.maskedCorners), OBJC_ASSOCIATION_RETAIN_NONATOMIC);
    }
    if (!sheet.clipsToBounds) sheet.clipsToBounds = YES;
    sheet.layer.cornerCurve = kCACornerCurveContinuous;
    if (fabs(sheet.layer.cornerRadius - radius) > 0.25) sheet.layer.cornerRadius = radius;
    CACornerMask topOnly = kCALayerMinXMinYCorner | kCALayerMaxXMinYCorner;
    if (sheet.layer.maskedCorners != topOnly) sheet.layer.maskedCorners = topOnly;
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
}

static BOOL FQXPlaceCommentComposerGlass(UIView *host, CGRect frame, CGFloat radius, BOOL dark, BOOL nestedPill) {
    (void)dark;
    UIVisualEffectView *glass = objc_getAssociatedObject(host, DramaComposerGlassKey);
    BOOL active = host.window && FQXCommentStylingEnabled() &&
                  CGRectGetWidth(frame) >= 44.0 && CGRectGetHeight(frame) >= 30.0;
    if (!active) {
        [glass removeFromSuperview];
        if (glass) objc_setAssociatedObject(host, DramaComposerGlassKey, nil, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
        if (!nestedPill) FQXRestoreSheetTopCornerMask(host);
        return NO;
    }
    FQXCommentMaterialStyle matStyle = FQXCurrentCommentMaterialStyle();
    BOOL darkTheme = FQXCommentsUseDarkTheme();
    BOOL clearComposer = nestedPill && matStyle == FQXCommentMaterialLiquidGlass && !darkTheme &&
                         !UIAccessibilityIsReduceTransparencyEnabled();
    FQXGlassRole role = FQXGlassRoleExpandedComposer;
    if (nestedPill) role = clearComposer ? FQXGlassRoleClearCommentComposer : FQXGlassRoleFloatingPill;
    BOOL topAlignedSheet = !nestedPill && frame.origin.y <= 1.0;
    CGFloat sideBleed = (matStyle == FQXCommentMaterialGaussianBlur) ? 0.0 : 12.0;
    CGFloat glassRad = nestedPill ? 0.0 : (topAlignedSheet ? -1.0 : radius);
    CGRect placedFrame = nestedPill
        ? frame
        : CGRectMake(frame.origin.x - sideBleed, frame.origin.y, CGRectGetWidth(frame) + sideBleed * 2.0, CGRectGetHeight(frame));
    glass = FQXEnsureUnifiedGlassView(host, DramaComposerGlassKey, role, glassRad, !nestedPill && !topAlignedSheet);
    if (!glass) return NO;
    if (!CGRectEqualToRect(glass.frame, placedFrame)) glass.frame = placedFrame;
    FQXSyncUnifiedGlassEffect(glass, role, glassRad, !nestedPill && !topAlignedSheet);
    UIColor *scrim = nil;
    if (clearComposer) {
        scrim = [UIColor colorWithWhite:1.0 alpha:0.05];
    } else if (matStyle == FQXCommentMaterialGaussianBlur) {
        scrim = darkTheme
            ? [UIColor colorWithWhite:0.01 alpha:(nestedPill ? 0.22 : 0.28)]
            : [UIColor colorWithWhite:0.98 alpha:(nestedPill ? 0.16 : 0.20)];
    } else if (!darkTheme) {
        scrim = nestedPill
            ? [UIColor colorWithWhite:1.0 alpha:0.64]
            : [UIColor colorWithWhite:0.97 alpha:0.78];
    } else {
        scrim = [UIColor colorWithWhite:0.01 alpha:(nestedPill ? 0.50 : 0.46)];
    }
    FQXApplyCommentGlassBacking(glass, scrim, glassRad, !nestedPill && !topAlignedSheet);
    if (nestedPill) {
        glass.contentView.layer.borderWidth = clearComposer ? 0.0 : 0.5;
        UIColor *borderCol = !darkTheme
            ? [UIColor colorWithWhite:0.0 alpha:0.10]
            : [UIColor colorWithWhite:1.0 alpha:(matStyle == FQXCommentMaterialGaussianBlur ? 0.14 : 0.22)];
        glass.contentView.layer.borderColor = borderCol.CGColor;
    } else if (topAlignedSheet) {
        glass.contentView.layer.borderWidth = 0.0;
        FQXApplySheetTopCornerMask(host, radius > 0.0 ? radius : 22.0);
        CGFloat rimAlpha = !darkTheme ? 0.70 : (matStyle == FQXCommentMaterialGaussianBlur ? 0.14 : 0.20);
        FQXSyncSheetTopRimLayer(host, radius > 0.0 ? radius : 22.0, 0.5, rimAlpha);
    } else {
        glass.contentView.layer.borderWidth = 0.0;
        FQXRemoveSheetTopRimLayer(host);
    }
    if (host.subviews.firstObject != glass) [host insertSubview:glass atIndex:0];
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
static NSHashTable<UIView *> *FQXTrackedCommentBars(void) {
    static NSHashTable<UIView *> *table;
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
    if (![toolbar isKindOfClass:NSClassFromString(@"FQCCommentBottomToolBar")]) return;
    [FQXTrackedCommentBars() addObject:toolbar];
    UIView *text = FQXObjGet(toolbar, "textView");
    UIView *placeholder = FQXObjGet(toolbar, "placeholderLabel");
    UIView *contentLabel = FQXRawIvarObj(toolbar, "_contentLabel");
    UIView *image = FQXObjGet(toolbar, "addImageBtn") ?: FQXObjGet(toolbar, "textViewAddImageBtn");
    UIView *emoji = FQXObjGet(toolbar, "textViewEmojiBtn") ?: FQXObjGet(toolbar, "emojiBtn");
    UIView *aigc = FQXObjGet(toolbar, "textViewAIGCImageBtn");
    CGRect row = CGRectNull;
    for (UIView *view in @[placeholder ?: contentLabel ?: text ?: toolbar,
                           contentLabel ?: toolbar,
                           image ?: toolbar,
                           emoji ?: toolbar,
                           aigc ?: toolbar]) {
        if (view != toolbar && [view isDescendantOfView:toolbar] && !view.hidden && CGRectGetHeight(view.bounds) > 1.0)
            row = CGRectUnion(row, [view convertRect:view.bounds toView:toolbar]);
    }
    CGRect frame = CGRectZero;
    if (!CGRectIsNull(row)) {
        CGFloat height = MIN(50.0, MAX(44.0, CGRectGetHeight(row) + 10.0));
        frame = CGRectIntersection(CGRectInset(toolbar.bounds, 12.0, 0.0),
            CGRectMake(CGRectGetMinX(toolbar.bounds) + 12.0, CGRectGetMidY(row) - height * 0.5,
                       CGRectGetWidth(toolbar.bounds) - 24.0, height));
    }
    BOOL dark = FQXCommentsUseDarkTheme();
    BOOL styled = FQXPlaceCommentComposerGlass(toolbar, frame, 0.0, dark, YES);
    CGPoint position = FQXAudioStockCenter(toolbar);
    position.y -= 6.0;
    FQXAudioPlaceView(toolbar, position, styled);
    FQXAudioClearBackground(toolbar, styled);
    FQXHideLayerGradients(toolbar.layer, styled);
    if (styled && toolbar.opaque) toolbar.opaque = NO;
    UIView *bg = FQXObjGet(toolbar, "bgView");
    FQXAudioClearBackground(bg, styled);
    FQXHideLayerGradients(bg.layer, styled);
    if (styled && bg) {
        if (bg.layer.borderWidth > 0.0) bg.layer.borderWidth = 0.0;
    }
    FQXAudioClearBackground(text, styled);
    if (styled && text) {
        if (text.layer.borderWidth > 0.0) text.layer.borderWidth = 0.0;
    }
    // Strip stray inner input capsule outlines/backgrounds (e.g. wrapper around textView that
    // would otherwise draw a vertical rounded seam cutting across the image/emoji icons).
    if (styled) {
        UIVisualEffectView *keepGlass = objc_getAssociatedObject(toolbar, DramaComposerGlassKey);
        for (UIView *child in toolbar.subviews) {
            if (child == keepGlass || [child isKindOfClass:UIControl.class] || [child isKindOfClass:UILabel.class] ||
                [child isKindOfClass:UIImageView.class]) continue;
            if (CGRectGetWidth(child.bounds) >= 80.0) {
                FQXAudioClearBackground(child, YES);
                if (child.layer.borderWidth > 0.0) child.layer.borderWidth = 0.0;
                for (UIView *grand in child.subviews) {
                    if ([grand isKindOfClass:UIControl.class] || [grand isKindOfClass:UILabel.class] ||
                        [grand isKindOfClass:UIImageView.class]) continue;
                    if (CGRectGetWidth(grand.bounds) >= 80.0) {
                        FQXAudioClearBackground(grand, YES);
                        if (grand.layer.borderWidth > 0.0) grand.layer.borderWidth = 0.0;
                    }
                }
            }
        }
    }
    FQXAudioClearBackground(FQXRawIvarObj(toolbar, "_sendButtonBackgroundImageview"), styled);
    FQXAudioClearBackground(FQXRawIvarObj(toolbar, "_addImageBtnCoverView"), styled);
    FQXAudioClearBackground(FQXRawIvarObj(toolbar, "_addAIGCImageBtnCoverView"), styled);
    FQXAudioClearBackground(FQXRawIvarObj(toolbar, "_sendBtnCoverView"), styled);
    FQXAudioClearBackground(image, styled);
    FQXAudioClearBackground(emoji, styled);
    FQXAudioClearBackground(aigc, styled);

    UIVisualEffectView *glass = objc_getAssociatedObject(toolbar, DramaComposerGlassKey);
    UIVisualEffectView *official = FQXObjGet(toolbar, "effectView");
    if ([official isKindOfClass:UIVisualEffectView.class] && official != glass) {
        UIVisualEffect *saved = objc_getAssociatedObject(official, CommentStockEffectKey);
        if (styled && official.effect) {
            objc_setAssociatedObject(official, CommentStockEffectKey, official.effect, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
            official.effect = nil;
        } else if (!styled && saved) {
            if (!official.effect) official.effect = saved;
            objc_setAssociatedObject(official, CommentStockEffectKey, nil, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
        }
        FQXAudioClearBackground(official, styled);
        FQXAudioClearBackground(official.contentView, styled);
        FQXAudioSetHiddenTracked(official, styled);
    }
    FQXNeutralizeStrayBarGlass(toolbar, glass, styled, 0);
    FQXAudioSetHiddenTracked(FQXObjGet(toolbar, "topLineView"), styled);
    UIUserInterfaceStyle desiredUIStyle = FQXDesiredCommentInterfaceStyle();
    if (toolbar.overrideUserInterfaceStyle != desiredUIStyle)
        toolbar.overrideUserInterfaceStyle = desiredUIStyle;
    if (styled) {
        FQXBoostCommentTypography(toolbar, 0);
    }
    FQXExtendSiblingScrollForCommentBar(toolbar, styled);
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

static const void *SheetGlassKey = &SheetGlassKey;
static void FQXRemoveGlassSheet(UIView *sheet) {
    UIVisualEffectView *glass = objc_getAssociatedObject(sheet, SheetGlassKey);
    if (glass) {
        [glass removeFromSuperview];
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

static void FQXSyncDockHiddenForCommentSheets(UIWindow *window, UIViewController *excludingVC) {
    if (!window) return;
    BOOL shouldHideDock = FQXCommentStylingEnabled() && FQXHasVisibleCommentSheetInWindow(window, excludingVC);
    Class tabBarCls = NSClassFromString(@"SSTabBar");
    if (!tabBarCls) return;
    NSMutableArray<UIView *> *bars = [NSMutableArray array];
    FQXFindTabBarsInView(window, tabBarCls, bars, 0);
    for (UIView *bar in bars) {
        BOOL hiddenByUs = [objc_getAssociatedObject(bar, FQXDockHiddenByCommentKey) boolValue];
        if (shouldHideDock && !hiddenByUs) {
            objc_setAssociatedObject(bar, FQXDockHiddenByCommentKey, @YES, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
            bar.userInteractionEnabled = NO;
            [UIView animateWithDuration:0.16 delay:0.0
                                options:UIViewAnimationOptionBeginFromCurrentState | UIViewAnimationOptionAllowUserInteraction
                             animations:^{ bar.alpha = 0.0; } completion:nil];
        } else if (!shouldHideDock && hiddenByUs) {
            objc_setAssociatedObject(bar, FQXDockHiddenByCommentKey, nil, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
            bar.userInteractionEnabled = YES;
            [UIView animateWithDuration:0.20 delay:0.0
                                options:UIViewAnimationOptionBeginFromCurrentState | UIViewAnimationOptionAllowUserInteraction
                             animations:^{ bar.alpha = 1.0; } completion:nil];
        }
    }
}

static BOOL FQXStyleGlassSheet(UIView *sheet, BOOL commentSheet, BOOL readerSheet) {
    if (!sheet) return NO;
    BOOL enabled = (commentSheet ? FQXCommentStylingEnabled() : FQXGlassEnabled()) &&
                   CGRectGetWidth(sheet.bounds) > 100.0 &&
                   CGRectGetHeight(sheet.bounds) > 72.0;
    UIVisualEffectView *glass = nil;
    if (enabled) {
        if (commentSheet) {
            glass = FQXEnsureUnifiedGlassView(sheet, SheetGlassKey, FQXGlassRoleCommentSheet, -1.0, NO);
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
            UIUserInterfaceStyle desiredUIStyle = FQXDesiredCommentInterfaceStyle();
            if (sheet.overrideUserInterfaceStyle != desiredUIStyle) {
                sheet.overrideUserInterfaceStyle = desiredUIStyle;
            }
        }
        return NO;
    }
    [UIView performWithoutAnimation:^{
        FQXCommentMaterialStyle matStyle = FQXCurrentCommentMaterialStyle();
        BOOL darkTheme = FQXCommentsUseDarkTheme();
        CGFloat sideBleed = (commentSheet && matStyle != FQXCommentMaterialGaussianBlur) ? 12.0 : 0.0;
        CGRect frame = commentSheet
            ? CGRectMake(-sideBleed, 0.0, CGRectGetWidth(sheet.bounds) + sideBleed * 2.0, CGRectGetHeight(sheet.bounds) + 28.0)
            : sheet.bounds;
        if (!CGRectEqualToRect(glass.frame, frame)) glass.frame = frame;
        if (commentSheet) {
            FQXSyncUnifiedGlassEffect(glass, FQXGlassRoleCommentSheet, -1.0, NO);
            FQXApplySheetTopCornerMask(sheet, 28.0);
            UIUserInterfaceStyle desiredUIStyle = FQXDesiredCommentInterfaceStyle();
            if (sheet.overrideUserInterfaceStyle != desiredUIStyle) {
                sheet.overrideUserInterfaceStyle = desiredUIStyle;
            }
            UIColor *scrim = nil;
            CGFloat rimAlpha = 0.20;
            if (matStyle == FQXCommentMaterialGaussianBlur) {
                scrim = darkTheme
                    ? [UIColor colorWithWhite:0.01 alpha:0.28]
                    : [UIColor colorWithWhite:0.98 alpha:0.18];
                rimAlpha = darkTheme ? 0.14 : 0.42;
            } else if (!darkTheme) {
                // Unified Light Liquid Glass across Short Drama, Series Reviews, and Novel Comments.
                BOOL reduce = UIAccessibilityIsReduceTransparencyEnabled();
                scrim = [UIColor colorWithWhite:0.97 alpha:(reduce ? 0.68 : 0.34)];
                rimAlpha = reduce ? 0.72 : 0.50;
            } else {
                // Unified Dark Liquid Glass calibrated to Short Drama translucency, slightly deeper black.
                if (!readerSheet && !FQXDramaCommentNoVideoShiftEnabled()) {
                    scrim = [UIColor colorWithWhite:0.05 alpha:0.34];
                } else {
                    scrim = [UIColor colorWithWhite:0.01 alpha:0.44];
                }
                rimAlpha = 0.20;
            }
            FQXApplyCommentGlassBacking(glass, scrim, -1.0, NO);
            glass.contentView.layer.borderWidth = 0.0;
            FQXSyncSheetTopRimLayer(sheet, 28.0, 0.5, rimAlpha);
        }
        if (sheet.subviews.firstObject != glass) [sheet insertSubview:glass atIndex:0];
        FQXAudioClearBackground(sheet, YES);
    }];
    return YES;
}

static const void *CommentSavedOpaqueKey = &CommentSavedOpaqueKey;

static void FQXClearCommentSurface(UIView *view, BOOL clear) {
    if (![view isKindOfClass:UIView.class]) return;
    FQXAudioClearBackground(view, clear);
    if (clear && view.opaque) {
        objc_setAssociatedObject(view, CommentSavedOpaqueKey, @YES, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
        view.opaque = NO;
    } else if (!clear && objc_getAssociatedObject(view, CommentSavedOpaqueKey)) {
        view.opaque = YES;
        objc_setAssociatedObject(view, CommentSavedOpaqueKey, nil, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
    }
}

static void FQXClearCommentCell(UIView *cell, BOOL clear) {
    if (![cell isKindOfClass:UIView.class]) return;
    FQXClearCommentSurface(cell, clear);
    if ([cell isKindOfClass:UICollectionViewCell.class]) {
        UICollectionViewCell *cvCell = (UICollectionViewCell *)cell;
        FQXClearCommentSurface(cvCell.contentView, clear);
        FQXClearCommentSurface(cvCell.backgroundView, clear);
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
        UIUserInterfaceStyle desiredUIStyle = FQXDesiredCommentInterfaceStyle();
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
        UIUserInterfaceStyle desiredUIStyle = FQXDesiredCommentInterfaceStyle();
        if (footer.overrideUserInterfaceStyle != desiredUIStyle)
            footer.overrideUserInterfaceStyle = desiredUIStyle;
        FQXBoostCommentTypography(footer, 0);
    }
}

static void FQXClearCommentCollection(UIView *view, BOOL clear) {
    FQXClearCommentSurface(view, clear);
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

static void FQXClearCommentCovers(UIView *view, CGFloat width, BOOL clear) {
    if (![view isKindOfClass:UIView.class]) return;
    Class toolbarClass = NSClassFromString(@"FQCCommentBottomToolBar");
    Class gradBtnClass = NSClassFromString(@"FQCommunityGradientButton");
    for (UIView *child in view.subviews) {
        if ([child isKindOfClass:UIVisualEffectView.class] ||
            (toolbarClass && [child isKindOfClass:toolbarClass]) ||
            (gradBtnClass && [child isKindOfClass:gradBtnClass]) ||
            [child isKindOfClass:UICollectionReusableView.class] || [child isKindOfClass:UIControl.class] ||
            [child isKindOfClass:UIImageView.class] || [child isKindOfClass:UILabel.class] ||
            [child isKindOfClass:UITextView.class]) continue;
        if ([child isKindOfClass:UICollectionView.class]) {
            FQXClearCommentCollection(child, clear);
            continue;
        }
        if (CGRectGetWidth(child.bounds) < width * 0.82 || CGRectGetHeight(child.bounds) < 28.0) continue;
        FQXClearCommentSurface(child, clear);
        FQXClearCommentCovers(child, width, clear);
    }
}

static BOOL FQXStyleCommentSheet(UIView *root, BOOL reader) {
    if (!root.window) return NO;
    UIView *sheet = root;
    UIView *transition = nil;
    CGFloat rootW = CGRectGetWidth(root.bounds);
    CGFloat rootH = CGRectGetHeight(root.bounds);
    CGFloat winH = CGRectGetHeight(root.window.bounds);
    Class transCls = NSClassFromString(@"FQVTransitionView");
    for (UIView *view = root.superview; view && ![view isKindOfClass:UIWindow.class]; view = view.superview) {
        if (transCls && [view isKindOfClass:transCls]) {
            UIView *content = FQXObjGet(view, "contentView");
            if (content && [root isDescendantOfView:content]) transition = view;
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
    BOOL glass = FQXStyleGlassSheet(sheet, YES, reader);
    for (UIView *w = root; w && w != sheet.superview; w = w.superview) {
        FQXClearCommentSurface(w, glass);
    }
    if (transition) {
        FQXClearCommentSurface(FQXObjGet(transition, "bgView"), glass);
        UIView *tEffect = FQXObjGet(transition, "effectView");
        if ([tEffect isKindOfClass:UIVisualEffectView.class]) {
            FQXAudioSetHiddenTracked(tEffect, glass);
        }
        UIView *carrier = FQXObjGet(transition, "contentScrollView");
        if (carrier && [sheet isDescendantOfView:carrier]) FQXClearCommentSurface(carrier, glass);
    }
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

static BOOL FQXStyleDramaCommentList(UIViewController *controller) {
    if (!controller) return NO;
    [FQXTrackedCommentLists() addObject:controller];
    UIView *root = controller.viewIfLoaded;
    if (!root.window) return NO;
    BOOL embedded = NO;
    Class panelClass = NSClassFromString(@"FQCShortVideoCommentPanelViewController");
    for (UIViewController *parent = controller.parentViewController; parent; parent = parent.parentViewController) {
        if ([parent isKindOfClass:panelClass]) {
            embedded = YES;
            break;
        }
    }
    for (UIView *view = root.superview; !embedded && view; view = view.superview) {
        if (objc_getAssociatedObject(view, SheetGlassKey)) embedded = YES;
    }
    if (embedded && objc_getAssociatedObject(root, SheetGlassKey)) FQXRemoveGlassSheet(root);
    BOOL glass = embedded ? FQXCommentStylingEnabled() : FQXStyleCommentSheet(root, NO);
    FQXClearCommentSurface(root, glass);
    FQXClearCommentSurface(FQXObjGet(controller, "fqc_headerView"), glass);
    UICollectionView *collection = FQXObjGet(controller, "collectionView");
    FQXClearCommentCollection(collection, glass);
    FQXClearCommentCovers(root, CGRectGetWidth(root.bounds), glass);
    if (glass) FQXBoostCommentTypography(root, 0);
    FQXScanAndStyleCommentTopBanners(root);
    Class toolbarClass = NSClassFromString(@"FQCCommentBottomToolBar");
    UIView *bar = nil;
    for (UIView *sub in root.subviews) {
        if (toolbarClass && [sub isKindOfClass:toolbarClass]) {
            bar = sub;
            break;
        }
    }
    if ([collection isKindOfClass:UIScrollView.class] && bar) {
        FQXExtendCommentCollectionForFloatingBar(collection, bar, glass);
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
    if ([view isKindOfClass:UILabel.class]) {
        UILabel *label = (UILabel *)view;
        label.textColor = color;
        if (addShadow && FQXCommentUsesTextShadow()) {
            label.shadowColor = [UIColor colorWithWhite:0.0 alpha:0.38];
            label.shadowOffset = CGSizeMake(0.0, 0.5);
        } else if (label.shadowColor) {
            label.shadowColor = nil;
            label.shadowOffset = CGSizeZero;
        }
        if (label.attributedText.length > 0) {
            NSMutableAttributedString *mut = [label.attributedText mutableCopy];
            NSRange full = NSMakeRange(0, mut.length);
            [mut addAttribute:NSForegroundColorAttributeName value:color range:full];
            [mut addAttribute:FQXCTForegroundColorAttr value:(id)color.CGColor range:full];
            label.attributedText = mut;
        }
        return;
    }
    if ([view isKindOfClass:UIButton.class]) {
        UIButton *btn = (UIButton *)view;
        [btn setTitleColor:color forState:UIControlStateNormal];
        btn.tintColor = color;
        if (btn.titleLabel) FQXSetLabelColorForce(btn.titleLabel, color, addShadow);
        return;
    }
    if ([view isKindOfClass:UIImageView.class]) {
        UIImageView *iv = (UIImageView *)view;
        if (iv.image) {
            if (iv.image.renderingMode != UIImageRenderingModeAlwaysTemplate) {
                iv.image = [iv.image imageWithRenderingMode:UIImageRenderingModeAlwaysTemplate];
            }
            iv.tintColor = color;
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
                NSMutableAttributedString *mut = [(NSAttributedString *)lText mutableCopy];
                NSRange full = NSMakeRange(0, mut.length);
                [mut addAttribute:NSForegroundColorAttributeName value:color range:full];
                [mut addAttribute:FQXCTForegroundColorAttr value:(id)color.CGColor range:full];
                Class layoutCls = [layout class];
                SEL makeLayout = NSSelectorFromString(@"layoutWithContainer:text:");
                if ([layoutCls respondsToSelector:makeLayout]) {
                    id newLayout = ((id (*)(id, SEL, id, id))objc_msgSend)(layoutCls, makeLayout, container, mut);
                    if (newLayout) ((void (*)(id, SEL, id))objc_msgSend)(view, setLayout, newLayout);
                }
            }
        }
    } else if ([view respondsToSelector:@selector(attributedText)] && [view respondsToSelector:@selector(setAttributedText:)]) {
        id cur = ((id (*)(id, SEL))objc_msgSend)(view, @selector(attributedText));
        if ([cur isKindOfClass:NSAttributedString.class] && [(NSAttributedString *)cur length] > 0) {
            NSMutableAttributedString *mut = [(NSAttributedString *)cur mutableCopy];
            NSRange full = NSMakeRange(0, mut.length);
            [mut addAttribute:NSForegroundColorAttributeName value:color range:full];
            [mut addAttribute:FQXCTForegroundColorAttr value:(id)color.CGColor range:full];
            ((void (*)(id, SEL, id))objc_msgSend)(view, @selector(setAttributedText:), mut);
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
    if ([view isKindOfClass:UILabel.class]) {
        UILabel *label = (UILabel *)view;
        NSString *txt = label.text ?: label.attributedText.string ?: @"";
        if ([txt containsString:@"大家都在搜"] || [txt containsString:@"大家在搜"]) {
            if (txt.length > 6) {
                NSAttributedString *styled = FQXSplitStyleSearchAttributed(label.attributedText, txt, label.font);
                if (styled) {
                    label.attributedText = styled;
                    FQXSyncLabelShadowForCommentMode(label);
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
            NSAttributedString *curAttr = [btn attributedTitleForState:UIControlStateNormal];
            NSAttributedString *styled = FQXSplitStyleSearchAttributed(curAttr, t, btn.titleLabel.font);
            if (styled) [btn setAttributedTitle:styled forState:UIControlStateNormal];
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
                if ([txt containsString:@"大家都在搜"] || [txt containsString:@"大家在搜"]) {
                    NSAttributedString *styled = FQXSplitStyleSearchAttributed(as, txt, nil);
                    Class layoutCls = [layout class];
                    SEL makeLayout = NSSelectorFromString(@"layoutWithContainer:text:");
                    if (styled && [layoutCls respondsToSelector:makeLayout]) {
                        id newLayout = ((id (*)(id, SEL, id, id))objc_msgSend)(layoutCls, makeLayout, container, styled);
                        if (newLayout) {
                            ((void (*)(id, SEL, id))objc_msgSend)(view, setLayout, newLayout);
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
                NSAttributedString *styled = FQXSplitStyleSearchAttributed(as, txt, nil);
                if (styled) ((void (*)(id, SEL, id))objc_msgSend)(view, @selector(setAttributedText:), styled);
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
    for (UIScene *scene in UIApplication.sharedApplication.connectedScenes) {
        if (![scene isKindOfClass:UIWindowScene.class]) continue;
        for (UIWindow *win in ((UIWindowScene *)scene).windows) {
            FQXSyncDockHiddenForCommentSheets(win, nil);
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
            [glass removeFromSuperview];
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
    glass = FQXEnsureUnifiedGlassView(btn, WriteReviewGlassKey, FQXGlassRoleFloatingPill, 0.0, NO);
    if (!glass) return;
    CGRect frame = btn.bounds;
    if (!CGRectEqualToRect(glass.frame, frame)) glass.frame = frame;
    FQXSyncUnifiedGlassEffect(glass, FQXGlassRoleFloatingPill, 0.0, NO);
    FQXCommentMaterialStyle matStyle = FQXCurrentCommentMaterialStyle();
    BOOL darkTheme = FQXCommentsUseDarkTheme();
    UIColor *pillScrim = (matStyle == FQXCommentMaterialGaussianBlur)
        ? (darkTheme ? [UIColor colorWithWhite:0.01 alpha:0.20] : [UIColor colorWithWhite:1.0 alpha:0.16])
        : (!darkTheme ? [UIColor colorWithWhite:1.0 alpha:0.64] : [UIColor colorWithWhite:0.01 alpha:0.38]);
    FQXApplyCommentGlassBacking(glass, pillScrim, 0.0, NO);
    if (btn.subviews.firstObject != glass) [btn insertSubview:glass atIndex:0];
    if (btn.clipsToBounds) btn.clipsToBounds = NO;
    UIUserInterfaceStyle desiredUIStyle = FQXDesiredCommentInterfaceStyle();
    if (btn.overrideUserInterfaceStyle != desiredUIStyle)
        btn.overrideUserInterfaceStyle = desiredUIStyle;
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

static void FQXStyleReaderCommentList(UIViewController *controller) {
    if (![controller isKindOfClass:NSClassFromString(@"FQCParagraphCommentListViewController")]) return;
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

    Class transitionClass = NSClassFromString(@"FQVTransitionView");
    for (UIView *view = root.superview; view; view = view.superview) {
        if (![view isKindOfClass:transitionClass]) continue;
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

static void (*OrigReaderCommentV1Appeared)(id, SEL, BOOL);
static void HookReaderCommentV1Appeared(UIViewController *controller, SEL cmd, BOOL animated) {
    OrigReaderCommentV1Appeared(controller, cmd, animated);
    FQXStyleReaderCommentList(controller);
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
    if (controller && [controller.viewIfLoaded isDescendantOfView:transition]) FQXStyleReaderCommentList(controller);
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
            [barGlass removeFromSuperview];
            objc_setAssociatedObject(bar, DramaComposerGlassKey, nil, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
        }
    }
    UIView *writeBtn = FQXRawIvarObj(controller, "_writeReviewButton");
    if (writeBtn && !writeBtn.window) {
        UIVisualEffectView *wGlass = objc_getAssociatedObject(writeBtn, WriteReviewGlassKey);
        if (wGlass) {
            [wGlass removeFromSuperview];
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
                [g removeFromSuperview];
                objc_setAssociatedObject(bar, DramaComposerGlassKey, nil, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
            }
        }
    }
    FQXCompactWeakTable(FQXTrackedCommentBars());
    FQXCompactWeakTable(FQXTrackedSearchEntrances());
    FQXCompactWeakTable(FQXTrackedDynamicSearchBanners());
    FQXCompactWeakTable(FQXTrackedDynamicNoticeBanners());
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
    if (win) {
        dispatch_async(dispatch_get_main_queue(), ^{
            FQXSyncDockHiddenForCommentSheets(win, nil);
        });
    }
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
    FQXAudioDedupInFlight = NO;
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
    FQXAudioDedupInFlight = NO;
}

static void (*OrigAudioIndicatorShowInView)(id, SEL, id, CGRect);
static void HookAudioIndicatorShowInView(UIView *self, SEL cmd, UIView *parent, CGRect pos) {
    CGRect clamped = FQXClampAudioIndicatorFrame(self, parent, pos);
    OrigAudioIndicatorShowInView(self, cmd, parent, clamped);
    FQXDeduplicateAudioIndicators(self);
}

static void (*OrigAudioIndicatorShowInViewPoint)(id, SEL, id, CGPoint);
static void HookAudioIndicatorShowInViewPoint(UIView *self, SEL cmd, UIView *parent, CGPoint pos) {
    CGRect probe = CGRectMake(pos.x, pos.y, MAX(48.0, CGRectGetWidth(self.bounds)), MAX(40.0, CGRectGetHeight(self.bounds)));
    CGRect clamped = FQXClampAudioIndicatorFrame(self, parent, probe);
    OrigAudioIndicatorShowInViewPoint(self, cmd, parent, clamped.origin);
    FQXDeduplicateAudioIndicators(self);
}

static void (*OrigAudioIndicatorSetHidden)(id, SEL, BOOL);
static void HookAudioIndicatorSetHidden(UIView *self, SEL cmd, BOOL hidden) {
    OrigAudioIndicatorSetHidden(self, cmd, hidden);
    if (FQXAudioDedupInFlight) return;
    if (!hidden && self.window && self.alpha > 0.01) {
        FQXDeduplicateAudioIndicators(self);
    } else if (hidden) {
        FQXRestoreSuppressedAudioIndicatorIfNeeded(self);
    }
}

static void (*OrigAudioIndicatorSetAlpha)(id, SEL, CGFloat);
static void HookAudioIndicatorSetAlpha(UIView *self, SEL cmd, CGFloat alpha) {
    OrigAudioIndicatorSetAlpha(self, cmd, alpha);
    if (FQXAudioDedupInFlight) return;
    if (alpha > 0.01 && self.window && !self.hidden) {
        FQXDeduplicateAudioIndicators(self);
    } else if (alpha <= 0.01) {
        FQXRestoreSuppressedAudioIndicatorIfNeeded(self);
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

static void FQXStyleExpandedCommentInput(UIView *sheet, UIView *text, UIView *emoji) {
    if (!sheet) return;
    // Span full edge-to-edge width (0pt side margins) and extend past the bottom
    // so only the top two corners round cleanly above the full-width keyboard bar.
    CGRect frame = CGRectMake(0.0, 0.0, CGRectGetWidth(sheet.bounds), CGRectGetHeight(sheet.bounds) + 24.0);
    BOOL glass = FQXPlaceCommentComposerGlass(sheet, frame, 22.0, FQXCommentViewIsDark(sheet), NO);
    if (glass) {
        if (!objc_getAssociatedObject(sheet, ExpandedInputSavedClipsKey)) {
            objc_setAssociatedObject(sheet, ExpandedInputSavedClipsKey, @(sheet.clipsToBounds), OBJC_ASSOCIATION_RETAIN_NONATOMIC);
        }
        if (!sheet.clipsToBounds) sheet.clipsToBounds = YES;
    } else {
        NSNumber *savedClips = objc_getAssociatedObject(sheet, ExpandedInputSavedClipsKey);
        if (savedClips) {
            sheet.clipsToBounds = savedClips.boolValue;
            objc_setAssociatedObject(sheet, ExpandedInputSavedClipsKey, nil, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
        }
    }
    FQXClearCommentSurface(sheet, glass);
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
        [stale removeFromSuperview];
        objc_setAssociatedObject(host, DramaComposerGlassKey, nil, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
    }
    FQXRestoreSheetTopCornerMask(host);
    NSNumber *savedClips = objc_getAssociatedObject(host, ExpandedInputSavedClipsKey);
    if (savedClips) {
        host.clipsToBounds = savedClips.boolValue;
        objc_setAssociatedObject(host, ExpandedInputSavedClipsKey, nil, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
    }
}

static void FQXStyleCommunityInput(UIView *editor) {
    if (![editor isKindOfClass:UIView.class]) return;
    UIView *sheet = FQXObjGet(editor, "containerView");
    UIView *input = FQXObjGet(editor, "commentInputView");
    UIView *paraBg = FQXObjGet(input, "paraBgView");
    UIView *emoji = FQXObjGet(editor, "subEmojiPanelView");
    UIView *text = FQXObjGet(input, "textView");

    // In reader paragraph comments, paraBgView ("| quote") can sit above containerView.
    // Only expand the glass card onto editor when paraBgView ACTUALLY displays visible quote text;
    // otherwise keep glass anchored on containerView so an empty paraBgView never creates a dark
    // blurred mask band above the rounded composer card.
    UIView *glassHost = sheet;
    CGRect glassFrame = sheet ? CGRectMake(0.0, 0.0, CGRectGetWidth(sheet.bounds), CGRectGetHeight(sheet.bounds) + 24.0) : CGRectZero;
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
            glassFrame = CGRectMake(0.0, topY, CGRectGetWidth(editor.bounds), (botY - topY) + 24.0);
            useEditorHost = YES;
        }
    }
    if (useEditorHost) {
        FQXClearStaleComposerHost(sheet);
    } else if (editor != sheet) {
        FQXClearStaleComposerHost(editor);
    }

    BOOL glass = NO;
    if (glassHost) {
        glass = FQXPlaceCommentComposerGlass(glassHost, glassFrame, 22.0, FQXCommentViewIsDark(glassHost), NO);
        if (glass) {
            if (!objc_getAssociatedObject(glassHost, ExpandedInputSavedClipsKey)) {
                objc_setAssociatedObject(glassHost, ExpandedInputSavedClipsKey, @(glassHost.clipsToBounds), OBJC_ASSOCIATION_RETAIN_NONATOMIC);
            }
            if (!glassHost.clipsToBounds) glassHost.clipsToBounds = YES;
        } else {
            NSNumber *savedClips = objc_getAssociatedObject(glassHost, ExpandedInputSavedClipsKey);
            if (savedClips) {
                glassHost.clipsToBounds = savedClips.boolValue;
                objc_setAssociatedObject(glassHost, ExpandedInputSavedClipsKey, nil, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
            }
        }
    }
    UIVisualEffectView *keep = glassHost ? objc_getAssociatedObject(glassHost, DramaComposerGlassKey) : nil;
    FQXClearCommentSurface(editor, glass);
    FQXClearCommentSurface(sheet, glass);
    FQXClearCommentSurface(input, glass);
    FQXClearCommentSurface(text, glass);
    FQXClearCommentSurface(emoji, glass);
    FQXClearCommentSurface(FQXObjGet(input, "bgView"), glass);
    FQXClearCommentSurface(FQXObjGet(input, "contentView"), glass);
    FQXClearCommentSurface(FQXObjGet(editor, "bgView"), glass);
    FQXClearCommentSurface(FQXObjGet(editor, "backView"), glass);
    FQXClearCommentSurface(FQXObjGet(editor, "coverView"), glass);
    FQXClearCommentSurface(FQXObjGet(editor, "topMaskView"), glass);
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
    if (sheet != inputContainer && inputContainer) {
        FQXClearStaleComposerHost(inputContainer);
    }
    FQXStyleExpandedCommentInput(sheet, FQXObjGet(editor, "textView"), FQXObjGet(editor, "emojiListView"));
    BOOL glass = objc_getAssociatedObject(sheet, DramaComposerGlassKey) != nil;
    FQXClearCommentSurface(editor, glass);
    FQXClearCommentSurface(content, glass);
    FQXClearCommentSurface(inputContainer, glass);
    FQXClearCommentSurface(FQXObjGet(editor, "emoticonContainerView"), glass);
    FQXClearCommentSurface(FQXObjGet(editor, "funcView"), glass);
    FQXClearCommentSurface(FQXObjGet(editor, "bgView"), glass);
    FQXClearCommentSurface(FQXObjGet(editor, "topMaskView"), glass);
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
    FQXInstallAudioSurfaceFull(cell, cell.contentView, nil, pill, 0, 18.0, YES, YES, nil, enabled);
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
        if (enabled && cardW > 120.0) {
            if (!objc_getAssociatedObject(cv, AudioToneStockInsetKey)) {
                objc_setAssociatedObject(cv, AudioToneStockInsetKey,
                                         [NSValue valueWithUIEdgeInsets:cv.contentInset],
                                         OBJC_ASSOCIATION_RETAIN_NONATOMIC);
            }
            UIEdgeInsets stockInset = [objc_getAssociatedObject(cv, AudioToneStockInsetKey) UIEdgeInsetsValue];
            UIEdgeInsets targetInset = UIEdgeInsetsMake(stockInset.top, MAX(stockInset.left, 8.0),
                                                        stockInset.bottom, MAX(stockInset.right, 10.0));
            if (!UIEdgeInsetsEqualToEdgeInsets(cv.contentInset, targetInset)) {
                cv.contentInset = targetInset;
            }
        } else if (!enabled) {
            NSValue *saved = objc_getAssociatedObject(cv, AudioToneStockInsetKey);
            if (saved) {
                cv.contentInset = saved.UIEdgeInsetsValue;
                objc_setAssociatedObject(cv, AudioToneStockInsetKey, nil, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
            }
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
            if (!FQXCommentStylingEnabled() || !FQXIsCommentComposerTextView(tv)) return;
            FQXStyleActiveCommentTextInput(tv);
            __weak UIView *weakTV = tv;
            dispatch_async(dispatch_get_main_queue(), ^{
                UIView *strongTV = weakTV;
                if (strongTV && FQXCommentStylingEnabled() && FQXIsCommentComposerTextView(strongTV)) {
                    FQXStyleActiveCommentTextInput(strongTV);
                }
            });
        }];
        [nc addObserverForName:UITextViewTextDidChangeNotification object:nil queue:NSOperationQueue.mainQueue usingBlock:^(NSNotification *note) {
            UIView *tv = note.object;
            if (!FQXCommentStylingEnabled() || !FQXIsCommentComposerTextView(tv)) return;
            FQXStyleActiveCommentTextInput(tv);
        }];
    });
}

void FQXInstallMotionAndAudioHooks(void);
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
        HOOK_INST("SSVideoSeriesFeedHeaderView", "layoutSubviews", "v16@0:8", OrigDramaHeaderLayoutForCapsule, HookDramaHeaderLayoutForCapsule);
        HOOK_INST("SSHGBookStoreCategoryTitleView", "layoutSubviews", "v16@0:8", OrigDramaTabsLayoutForCapsule, HookDramaTabsLayoutForCapsule);
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
        HOOK_INST("SSShortVideoOutterMultiGenreFeedControlView", "bindContentModel:", "v24@0:8@16", OrigOuterBindContent, HookOuterBindContent);
        HOOK_INST("FQVShortVideoListVCGestureComponent", "pinchGesture:", "v24@0:8@16", OrigGestureCompPinch, HookGestureCompPinch);
        HOOK_INST("FQVShortVideoListVCGestureComponent", "gestureRecognizerShouldBegin:", "B24@0:8@16", OrigGestureCompShouldBegin, HookGestureCompShouldBegin);

        HOOK_INST("FQVShortVideoVPlayerControlView", "gestureRecognizerShouldBegin:", "B24@0:8@16", OrigInnerPinchSeekShouldBegin, HookInnerPinchSeekShouldBegin);
        HOOK_INST("SSShortVideoOutterMultiGenreFeedControlView", "gestureRecognizerShouldBegin:", "B24@0:8@16", OrigOuterPinchSeekShouldBegin, HookOuterPinchSeekShouldBegin);

        // 5. Reader back button centering, inline paragraph comment glass & Mine fold clipping
        HOOK_INST("FQReaderSaasNavigationView", "layoutSubviews", "v16@0:8", OrigReaderNavLayoutMotion, HookReaderNavLayoutMotion);
        HOOK_INST("SSScrollFoldFuncView", "layoutSubviews", "v16@0:8", OrigScrollFoldLayout, HookScrollFoldLayout);

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

        [NSNotificationCenter.defaultCenter addObserverForName:UIApplicationWillEnterForegroundNotification
                                                        object:nil
                                                         queue:NSOperationQueue.mainQueue
                                                    usingBlock:^(__unused NSNotification *note) {
            FQXScheduleCommentForegroundRefresh();
        }];
        [NSNotificationCenter.defaultCenter addObserverForName:UIApplicationDidBecomeActiveNotification
                                                        object:nil
                                                         queue:NSOperationQueue.mainQueue
                                                    usingBlock:^(__unused NSNotification *note) {
            FQXScheduleCommentForegroundRefresh();
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
            FQXCompactRuntimeMemory();
        }];

#undef HOOK_INST
    });
}
