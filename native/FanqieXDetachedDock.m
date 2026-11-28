#import "FanqieXDetachedDock.h"
#import "FQXLayoutAndSheetPolicy.h"
#import <QuartzCore/QuartzCore.h>
#import <objc/message.h>
#import <objc/runtime.h>
#import <os/lock.h>

NSString *const FQXDockDetachedEnabledPrefKey = @"FanqieX.DockDetachedEnabled.1";
NSString *const FQXDockDetachedModulePrefKey = @"FanqieX.DockDetachedModule.1";

static os_unfair_lock gFQXDetachedModulesLock = OS_UNFAIR_LOCK_INIT;
static NSArray<NSString *> *gFQXObservedHostModules = nil;

NSString * _Nullable FQXDockBottomPrefKeyForModuleTitle(NSString *title) {
    if (!title.length) return nil;
    if ([title isEqualToString:@"书城"] || [title isEqualToString:@"首页"]) {
        return @"FanqieX.BottomBookstore.1";
    } else if ([title isEqualToString:@"短剧"] || [title isEqualToString:@"视频"]) {
        return @"FanqieX.BottomDrama.1";
    } else if ([title isEqualToString:@"书架"]) {
        return @"FanqieX.BottomBookshelf.1";
    } else if ([title isEqualToString:@"我的"]) {
        return @"FanqieX.BottomMine.1";
    } else if ([title isEqualToString:@"商城"]) {
        return @"FanqieX.BottomMall.1";
    }
    return nil;
}

BOOL FQXDockIsModuleAllowedByBottomPrefs(NSString *title) {
    if (!title.length) return NO;
    NSString *prefKey = FQXDockBottomPrefKeyForModuleTitle(title);
    if (!prefKey) return YES;
    id stored = [NSUserDefaults.standardUserDefaults objectForKey:prefKey];
    if ([stored respondsToSelector:@selector(boolValue)]) {
        return [stored boolValue];
    }
    return YES;
}

static UIViewController *FQXFindSSTabBarControllerInHierarchy(UIViewController *vc, NSInteger depth) {
    if (!vc || depth > 5) return nil;
    Class tabCls = objc_lookUpClass("SSTabBarController");
    if (tabCls && [vc isKindOfClass:tabCls]) return vc;
    for (UIViewController *child in vc.childViewControllers) {
        UIViewController *found = FQXFindSSTabBarControllerInHierarchy(child, depth + 1);
        if (found) return found;
    }
    return nil;
}

static UIViewController *FQXActiveSSTabBarController(void) {
    for (UIScene *scene in UIApplication.sharedApplication.connectedScenes) {
        if (![scene isKindOfClass:UIWindowScene.class]) continue;
        UIWindowScene *ws = (UIWindowScene *)scene;
        for (UIWindow *win in ws.windows) {
            UIViewController *found = FQXFindSSTabBarControllerInHierarchy(win.rootViewController, 0);
            if (found) return found;
        }
    }
    return nil;
}

BOOL FQXDockRestoreBottomEntryForModule(NSString *title) {
    NSString *prefKey = FQXDockBottomPrefKeyForModuleTitle(title);
    if (!prefKey) return NO;
    if (FQXDockIsModuleAllowedByBottomPrefs(title)) return NO;
    [NSUserDefaults.standardUserDefaults setBool:YES forKey:prefKey];
    UIViewController *tabVC = FQXActiveSSTabBarController();
    SEL refreshSel = sel_registerName("refreshTabBar");
    if (tabVC && [tabVC respondsToSelector:refreshSel]) {
        ((void (*)(id, SEL))objc_msgSend)(tabVC, refreshSel);
    }
    return YES;
}

BOOL FQXDockDetachedIsEnabled(void) {
    id val = [NSUserDefaults.standardUserDefaults objectForKey:FQXDockDetachedEnabledPrefKey];
    return [val respondsToSelector:@selector(boolValue)] ? [val boolValue] : NO;
}

NSString *FQXDockDetachedStoredModule(void) {
    id val = [NSUserDefaults.standardUserDefaults objectForKey:FQXDockDetachedModulePrefKey];
    if ([val isKindOfClass:NSString.class]) {
        return [(NSString *)val stringByTrimmingCharactersInSet:NSCharacterSet.whitespaceAndNewlineCharacterSet];
    }
    return @"";
}

void FQXDockDetachedUpdateHostModules(NSArray<NSString *> *visibleTitles) {
    NSMutableArray<NSString *> *cleaned = [NSMutableArray arrayWithCapacity:visibleTitles.count];
    for (NSString *raw in visibleTitles) {
        if (![raw isKindOfClass:NSString.class] || !raw.length) continue;
        if (![cleaned containsObject:raw]) [cleaned addObject:raw];
    }
    if (!cleaned.count) return;
    os_unfair_lock_lock(&gFQXDetachedModulesLock);
    // Merge newly seen modules while keeping current live order authoritative when count >= previous.
    if (!gFQXObservedHostModules.count || cleaned.count >= gFQXObservedHostModules.count) {
        gFQXObservedHostModules = [cleaned copy];
    } else {
        NSMutableArray<NSString *> *merged = [NSMutableArray arrayWithCapacity:gFQXObservedHostModules.count];
        for (NSString *prev in gFQXObservedHostModules) {
            if ([cleaned containsObject:prev] || !FQXDockIsModuleAllowedByBottomPrefs(prev)) {
                if (![merged containsObject:prev]) [merged addObject:prev];
            }
        }
        for (NSString *cur in cleaned) {
            if (![merged containsObject:cur]) [merged addObject:cur];
        }
        gFQXObservedHostModules = [merged copy];
    }
    os_unfair_lock_unlock(&gFQXDetachedModulesLock);
}

NSArray<NSString *> *FQXDockDetachedAvailableModules(void) {
    os_unfair_lock_lock(&gFQXDetachedModulesLock);
    NSArray<NSString *> *observed = gFQXObservedHostModules;
    os_unfair_lock_unlock(&gFQXDetachedModulesLock);

    NSArray<NSString *> *source = observed.count ? observed : @[@"书城", @"短剧", @"书架", @"我的"];
    NSMutableArray<NSString *> *available = [NSMutableArray arrayWithCapacity:source.count];
    for (NSString *title in source) {
        if (FQXDockIsModuleAllowedByBottomPrefs(title) && ![available containsObject:title]) {
            [available addObject:title];
        }
    }
    return available;
}

NSArray<NSString *> *FQXDockDetachedAllKnownModules(void) {
    os_unfair_lock_lock(&gFQXDetachedModulesLock);
    NSArray<NSString *> *observed = gFQXObservedHostModules;
    os_unfair_lock_unlock(&gFQXDetachedModulesLock);

    NSMutableArray<NSString *> *result = [NSMutableArray arrayWithCapacity:5];
    for (NSString *title in observed) {
        if (title.length > 0 && ![result containsObject:title]) {
            [result addObject:title];
        }
    }
    for (NSString *std in @[@"书城", @"短剧", @"书架", @"我的"]) {
        if (![result containsObject:std]) {
            [result addObject:std];
        }
    }
    return result;
}

NSInteger FQXDockDetachedResolveIndexWithReason(NSArray<NSString *> *visibleTitles,
                                                NSString * _Nullable __autoreleasing * _Nullable outReason) {
    if (!FQXDockDetachedIsEnabled()) {
        if (outReason) *outReason = @"pref_disabled";
        return NSNotFound;
    }
    if (visibleTitles.count < 2) {
        if (outReason) *outReason = @"too_few_modules";
        return NSNotFound;
    }
    NSString *saved = FQXDockDetachedStoredModule();
    if (!saved.length) {
        for (NSInteger i = (NSInteger)visibleTitles.count - 1; i >= 0; --i) {
            NSString *candidate = visibleTitles[(NSUInteger)i];
            if (candidate.length > 0 && FQXDockIsModuleAllowedByBottomPrefs(candidate)) {
                [NSUserDefaults.standardUserDefaults setObject:candidate forKey:FQXDockDetachedModulePrefKey];
                if (outReason) *outReason = @"ok_auto_default";
                return i;
            }
        }
        if (outReason) *outReason = @"no_allowed_candidate";
        return NSNotFound;
    }
    if (!FQXDockIsModuleAllowedByBottomPrefs(saved)) {
        if (outReason) *outReason = @"module_hidden_by_bottom_pref";
        return NSNotFound;
    }
    NSUInteger idx = [visibleTitles indexOfObject:saved];
    if (idx == NSNotFound) {
        if (outReason) *outReason = @"module_not_in_host_buttons";
        return NSNotFound;
    }
    // Never leave the left capsule empty: require at least 1 remaining non-empty module.
    NSUInteger remaining = 0;
    for (NSUInteger i = 0; i < visibleTitles.count; ++i) {
        if (i != idx && visibleTitles[i].length > 0) ++remaining;
    }
    if (remaining < 1) {
        if (outReason) *outReason = @"insufficient_remaining_modules";
        return NSNotFound;
    }
    if (outReason) *outReason = @"ok";
    return (NSInteger)idx;
}

NSInteger FQXDockDetachedResolveIndex(NSArray<NSString *> *visibleTitles) {
    return FQXDockDetachedResolveIndexWithReason(visibleTitles, NULL);
}

static void FQXApplyCapsuleCornerToGlass(UIView *view) {
    if (!view) return;
    Class cornerCls = objc_lookUpClass("UICornerConfiguration");
    SEL capSel = sel_registerName("capsuleConfiguration");
    SEL setSel = sel_registerName("setCornerConfiguration:");
    if (cornerCls && [cornerCls respondsToSelector:capSel] && [view respondsToSelector:setSel]) {
        id cfg = ((id (*)(id, SEL))objc_msgSend)(cornerCls, capSel);
        if (cfg) {
            ((void (*)(id, SEL, id))objc_msgSend)(view, setSel, cfg);
            return;
        }
    }
    view.layer.cornerCurve = kCACornerCurveContinuous;
    view.layer.cornerRadius = MIN(CGRectGetWidth(view.bounds), CGRectGetHeight(view.bounds)) * 0.5;
}

@interface FQXDetachedCircleGlassView : UIVisualEffectView
@property(nonatomic, weak) UIView *interactionSourceView;
@end

@implementation FQXDetachedCircleGlassView
- (UIView *)_flexInteractionGestureView {
    UIView *source = self.interactionSourceView;
    if (source && source.window) return source;
    SEL sel = sel_registerName("_flexInteractionGestureView");
    if ([UIVisualEffectView instancesRespondToSelector:sel]) {
        struct objc_super sup = { self, UIVisualEffectView.class };
        return ((id (*)(struct objc_super *, SEL))objc_msgSendSuper)(&sup, sel);
    }
    return nil;
}
@end

@interface FQXDetachedDockButtonView ()
@property(nonatomic, strong, readwrite) FQXDetachedCircleGlassView *internalGlassView;
@property(nonatomic, strong, readwrite) UIView *selectionLens;
@property(nonatomic, strong) UIImageView *videoSelectedPillView;
@property(nonatomic, strong) UIView *contentScaleHost;
@property(nonatomic, strong) UIImageView *iconView;
@property(nonatomic, strong) UIView *unreadDot;
@property(nonatomic, strong, readwrite) UIButton *hitButton;
@property(nonatomic, strong, nullable) UIImage *normalImage;
@property(nonatomic, strong, nullable) UIImage *selectedImage;
@property(nonatomic, readwrite, getter=isModuleSelected) BOOL moduleSelected;
@property(nonatomic) NSInteger appliedGlassStamp;
@property(nonatomic) NSInteger surfaceStyle;
@property(nonatomic) NSInteger selectionTintStyle;
@property(nonatomic) BOOL lastVideoPillTranslucent;
@property(nonatomic) CGSize lastVideoPillSize;
@end

@implementation FQXDetachedDockButtonView

- (UIVisualEffectView *)glassView {
    return self.internalGlassView;
}

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        self.backgroundColor = UIColor.clearColor;
        self.opaque = NO;
        self.clipsToBounds = NO;
        self.userInteractionEnabled = YES;
        _appliedGlassStamp = NSIntegerMin;
        _feedGlyphScale = 1.0;

        FQXDetachedCircleGlassView *glass = [[FQXDetachedCircleGlassView alloc] initWithEffect:nil];
        glass.frame = self.bounds;
        glass.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
        glass.userInteractionEnabled = NO;
        glass.backgroundColor = UIColor.clearColor;
        glass.contentView.backgroundColor = UIColor.clearColor;
        glass.clipsToBounds = NO;
        FQXApplyCapsuleCornerToGlass(glass);
        [self addSubview:glass];
        _internalGlassView = glass;

        UIView *lens = [[UIView alloc] initWithFrame:CGRectInset(glass.contentView.bounds, 4.0, 4.0)];
        lens.userInteractionEnabled = NO;
        lens.backgroundColor = UIColor.clearColor;
        lens.layer.cornerCurve = kCACornerCurveContinuous;
        lens.alpha = 0.0;
        [glass.contentView addSubview:lens];
        _selectionLens = lens;

        UIImageView *videoPill = [[UIImageView alloc] initWithFrame:lens.bounds];
        videoPill.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
        videoPill.contentMode = UIViewContentModeScaleToFill;
        videoPill.userInteractionEnabled = NO;
        videoPill.hidden = YES;
        [lens addSubview:videoPill];
        _videoSelectedPillView = videoPill;

        UIView *scaleHost = [[UIView alloc] initWithFrame:glass.contentView.bounds];
        scaleHost.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
        scaleHost.userInteractionEnabled = NO;
        scaleHost.backgroundColor = UIColor.clearColor;
        [glass.contentView addSubview:scaleHost];
        _contentScaleHost = scaleHost;

        UIImageView *iv = [[UIImageView alloc] initWithFrame:scaleHost.bounds];
        iv.contentMode = UIViewContentModeCenter;
        iv.userInteractionEnabled = NO;
        [scaleHost addSubview:iv];
        _iconView = iv;

        UIView *dot = [[UIView alloc] initWithFrame:CGRectMake(0.0, 0.0, 8.0, 8.0)];
        dot.backgroundColor = UIColor.systemRedColor;
        dot.layer.cornerRadius = 4.0;
        dot.userInteractionEnabled = NO;
        dot.hidden = YES;
        [scaleHost addSubview:dot];
        _unreadDot = dot;

        // Place hitButton as the topmost direct sibling above internalGlassView so iOS 26/27
        // UIGlassEffect internal views can never intercept taps, while interactionSourceView
        // still routes fluid liquid-glass press physics to internalGlassView.
        UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
        btn.frame = self.bounds;
        btn.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
        btn.backgroundColor = UIColor.clearColor;
        btn.isAccessibilityElement = YES;
        btn.exclusiveTouch = YES;
        [btn addTarget:self action:@selector(handleTouchDown) forControlEvents:UIControlEventTouchDown | UIControlEventTouchDragEnter];
        [btn addTarget:self action:@selector(handleTouchRelease) forControlEvents:UIControlEventTouchCancel | UIControlEventTouchDragExit | UIControlEventTouchUpOutside];
        [btn addTarget:self action:@selector(handleTapUpInside) forControlEvents:UIControlEventTouchUpInside];
        [self addSubview:btn];
        glass.interactionSourceView = btn;
        _hitButton = btn;
    }
    return self;
}

- (void)setModuleTitle:(NSString *)moduleTitle {
    _moduleTitle = [moduleTitle copy];
    self.hitButton.accessibilityLabel = moduleTitle;
}

- (BOOL)pointInside:(CGPoint)point withEvent:(UIEvent *)event {
    (void)event;
    if (self.hidden || self.alpha <= 0.01 || !self.userInteractionEnabled) return NO;
    CGRect bounds = self.bounds;
    if (CGRectGetWidth(bounds) < 12.0 || CGRectGetHeight(bounds) < 12.0) return NO;
    return CGRectContainsPoint(CGRectInset(bounds, -4.0, -4.0), point);
}

- (UIView *)hitTest:(CGPoint)point withEvent:(UIEvent *)event {
    if (![self pointInside:point withEvent:event]) return nil;
    if (self.hitButton && !self.hitButton.hidden && self.hitButton.enabled && self.hitButton.userInteractionEnabled) {
        return self.hitButton;
    }
    return [super hitTest:point withEvent:event];
}

- (void)layoutSubviews {
    [super layoutSubviews];
    CGRect bounds = self.bounds;
    if (!CGRectEqualToRect(self.internalGlassView.frame, bounds)) {
        self.internalGlassView.frame = bounds;
    }
    FQXApplyCapsuleCornerToGlass(self.internalGlassView);

    CGRect contentBounds = self.internalGlassView.contentView.bounds;
    if (CGRectIsEmpty(contentBounds)) contentBounds = bounds;
    if (self.surfaceStyle != 0) {
        CGFloat r = MIN(CGRectGetWidth(contentBounds), CGRectGetHeight(contentBounds)) * 0.5;
        self.internalGlassView.contentView.layer.cornerCurve = kCACornerCurveContinuous;
        if (fabs(self.internalGlassView.contentView.layer.cornerRadius - r) > 0.25) {
            self.internalGlassView.contentView.layer.cornerRadius = r;
        }
        self.internalGlassView.contentView.clipsToBounds = YES;
    }
    CGRect lensRect = CGRectInset(contentBounds, 4.0, 4.0);
    if (CGRectGetWidth(lensRect) > 4.0 && CGRectGetHeight(lensRect) > 4.0) {
        self.selectionLens.bounds = CGRectMake(0.0, 0.0, CGRectGetWidth(lensRect), CGRectGetHeight(lensRect));
        self.selectionLens.center = CGPointMake(CGRectGetMidX(contentBounds), CGRectGetMidY(contentBounds));
        self.selectionLens.layer.cornerRadius = MIN(CGRectGetWidth(lensRect), CGRectGetHeight(lensRect)) * 0.5;
        if (self.selectionTintStyle != 0) {
            [self syncVideoSelectedPillImageForSize:lensRect.size];
        }
    }
    self.contentScaleHost.bounds = contentBounds;
    self.contentScaleHost.center = CGPointMake(CGRectGetMidX(contentBounds), CGRectGetMidY(contentBounds));
    self.iconView.frame = CGRectInset(contentBounds, 4.0, 4.0);
    CGFloat d = MIN(CGRectGetWidth(contentBounds), CGRectGetHeight(contentBounds));
    self.unreadDot.center = CGPointMake(d - 13.0, 12.0);
    if (!CGRectEqualToRect(self.hitButton.frame, bounds)) {
        self.hitButton.frame = bounds;
    }
    if (self.hitButton.superview == self && self.subviews.lastObject != self.hitButton) {
        [self bringSubviewToFront:self.hitButton];
    }
}

- (void)updateImagesNormal:(UIImage *)normalImage selected:(UIImage *)selectedImage {
    self.normalImage = normalImage;
    self.selectedImage = selectedImage ?: normalImage;
    self.iconView.image = self.moduleSelected ? self.selectedImage : self.normalImage;
}

- (void)setModuleSelected:(BOOL)selected animated:(BOOL)animated {
    BOOL changed = (_moduleSelected != selected);
    _moduleSelected = selected;
    self.hitButton.selected = selected;
    self.hitButton.accessibilityTraits = selected
        ? (UIAccessibilityTraitButton | UIAccessibilityTraitSelected)
        : UIAccessibilityTraitButton;

    UIImage *desiredImg = selected ? (self.selectedImage ?: self.normalImage) : self.normalImage;
    if (self.iconView.image != desiredImg) {
        self.iconView.image = desiredImg;
    }

    CGFloat targetAlpha = selected ? 1.0 : 0.0;
    CGAffineTransform targetLensTransform = selected
        ? CGAffineTransformIdentity
        : CGAffineTransformMakeScale(0.84, 0.84);

    if (!changed || !animated || !self.window || UIAccessibilityIsReduceMotionEnabled()) {
        self.selectionLens.alpha = targetAlpha;
        self.selectionLens.transform = targetLensTransform;
        return;
    }

    [UIView animateWithDuration:0.32
                          delay:0.0
         usingSpringWithDamping:0.72
          initialSpringVelocity:0.35
                        options:(UIViewAnimationOptionBeginFromCurrentState |
                                 UIViewAnimationOptionAllowUserInteraction)
                     animations:^{
        self.selectionLens.alpha = targetAlpha;
        self.selectionLens.transform = targetLensTransform;
    } completion:nil];
}

- (void)syncVideoSelectedPillImageForSize:(CGSize)size {
    if (!self.videoSelectedPillView || size.width < 6.0 || size.height < 6.0) return;
    BOOL translucent = (self.selectionTintStyle == FQXSelectionTintStyleRoseMistGlass);
    if (self.videoSelectedPillView.image &&
        self.lastVideoPillTranslucent == translucent &&
        fabs(self.lastVideoPillSize.width - size.width) < 0.5 &&
        fabs(self.lastVideoPillSize.height - size.height) < 0.5) {
        return;
    }
    Class motionCls = objc_lookUpClass("FQXDockMotion");
    SEL imgSel = sel_registerName("videoSelectedPillImageForSize:translucentGlass:");
    if (motionCls && [motionCls respondsToSelector:imgSel]) {
        UIImage *img = ((UIImage *(*)(id, SEL, CGSize, BOOL))objc_msgSend)(motionCls, imgSel, size, translucent);
        if (img) {
            self.videoSelectedPillView.image = img;
            self.lastVideoPillSize = size;
            self.lastVideoPillTranslucent = translucent;
        }
    }
}

- (void)applySurfaceStyle:(NSInteger)surfaceStyle
       selectionTintStyle:(NSInteger)selectionTintStyle {
    self.surfaceStyle = surfaceStyle;
    self.selectionTintStyle = selectionTintStyle;
    if (surfaceStyle == 1) {
        FQXRGBAColor fill = FQXVideoBaseSurfaceFillColor();
        FQXRGBAColor border = FQXVideoBaseSurfaceBorderColor();
        self.internalGlassView.effect = nil;
        self.internalGlassView.backgroundColor = UIColor.clearColor;
        self.internalGlassView.contentView.backgroundColor =
            [UIColor colorWithRed:(CGFloat)fill.r green:(CGFloat)fill.g blue:(CGFloat)fill.b alpha:(CGFloat)fill.a];
        self.internalGlassView.contentView.layer.borderWidth = 0.5;
        self.internalGlassView.contentView.layer.borderColor =
            [UIColor colorWithRed:(CGFloat)border.r green:(CGFloat)border.g blue:(CGFloat)border.b alpha:(CGFloat)border.a].CGColor;
        CGFloat r = MIN(CGRectGetWidth(self.internalGlassView.contentView.bounds),
                        CGRectGetHeight(self.internalGlassView.contentView.bounds)) * 0.5;
        self.internalGlassView.contentView.layer.cornerCurve = kCACornerCurveContinuous;
        self.internalGlassView.contentView.layer.cornerRadius = r;
        self.internalGlassView.contentView.clipsToBounds = YES;
    } else if (surfaceStyle == 2) {
        FQXRGBAColor border = FQXRoseMistGlassBaseBorderColor();
        self.internalGlassView.backgroundColor = UIColor.clearColor;
        self.internalGlassView.contentView.backgroundColor = UIColor.clearColor;
        self.internalGlassView.contentView.layer.borderWidth = 0.5;
        self.internalGlassView.contentView.layer.borderColor =
            [UIColor colorWithRed:(CGFloat)border.r green:(CGFloat)border.g blue:(CGFloat)border.b alpha:(CGFloat)border.a].CGColor;
        CGFloat r = MIN(CGRectGetWidth(self.internalGlassView.contentView.bounds),
                        CGRectGetHeight(self.internalGlassView.contentView.bounds)) * 0.5;
        self.internalGlassView.contentView.layer.cornerCurve = kCACornerCurveContinuous;
        self.internalGlassView.contentView.layer.cornerRadius = r;
        self.internalGlassView.contentView.clipsToBounds = YES;
    } else {
        self.internalGlassView.contentView.layer.borderWidth = 0.0;
        self.internalGlassView.contentView.layer.borderColor = NULL;
        self.internalGlassView.contentView.backgroundColor = UIColor.clearColor;
    }
    if (selectionTintStyle != 0) {
        self.selectionLens.backgroundColor = UIColor.clearColor;
        self.videoSelectedPillView.hidden = NO;
        [self syncVideoSelectedPillImageForSize:self.selectionLens.bounds.size];
    } else {
        self.videoSelectedPillView.hidden = YES;
    }
}

- (void)applyGlassEffect:(UIVisualEffect *)effect
          interfaceStyle:(UIUserInterfaceStyle)style
          selectionColor:(UIColor *)selectionColor
      reduceTransparency:(BOOL)reduceTransparency
              styleStamp:(NSInteger)styleStamp {
    if (self.internalGlassView.overrideUserInterfaceStyle != style) {
        self.internalGlassView.overrideUserInterfaceStyle = style;
    }
    if (self.selectionTintStyle == 0 && selectionColor && ![self.selectionLens.backgroundColor isEqual:selectionColor]) {
        self.selectionLens.backgroundColor = selectionColor;
    }
    BOOL effectLost = (effect != nil && !self.internalGlassView.effect);
    if (self.appliedGlassStamp != styleStamp || effectLost) {
        self.appliedGlassStamp = styleStamp;
        self.internalGlassView.effect = effect;
        self.internalGlassView.backgroundColor = reduceTransparency
            ? [UIColor secondarySystemBackgroundColor]
            : UIColor.clearColor;
        if (self.surfaceStyle != 1) {
            self.internalGlassView.contentView.backgroundColor = UIColor.clearColor;
        }
        FQXApplyCapsuleCornerToGlass(self.internalGlassView);
    }
}

- (void)syncUnreadBadgeFromHostButton:(UIButton *)hostButton {
    BOOL hasUnread = NO;
    if ([hostButton isKindOfClass:UIView.class]) {
        for (UIView *sub in hostButton.subviews) {
            if (sub == hostButton.imageView || sub == hostButton.titleLabel) continue;
            if (sub.hidden || sub.alpha < 0.05) continue;
            CGRect b = sub.bounds;
            if (CGRectGetWidth(b) >= 4.0 && CGRectGetWidth(b) <= 28.0 &&
                CGRectGetHeight(b) >= 4.0 && CGRectGetHeight(b) <= 22.0) {
                NSString *clsName = NSStringFromClass(sub.class);
                if ([clsName rangeOfString:@"Badge" options:NSCaseInsensitiveSearch].location != NSNotFound ||
                    [clsName rangeOfString:@"Dot" options:NSCaseInsensitiveSearch].location != NSNotFound ||
                    [clsName rangeOfString:@"RedPoint" options:NSCaseInsensitiveSearch].location != NSNotFound) {
                    hasUnread = YES;
                    break;
                }
            }
        }
    }
    if (self.unreadDot.hidden == hasUnread) {
        self.unreadDot.hidden = !hasUnread;
    }
}

- (void)setFeedGlyphScale:(CGFloat)feedGlyphScale {
    CGFloat clamped = MAX(0.001, feedGlyphScale);
    if (fabs(_feedGlyphScale - clamped) < 0.0005) return;
    _feedGlyphScale = clamped;
    [CATransaction begin];
    [CATransaction setDisableActions:YES];
    self.contentScaleHost.transform = CGAffineTransformMakeScale(clamped, clamped);
    [CATransaction commit];
}

- (void)handleTouchDown {
    if (self.onTouchDiagnostic) {
        self.onTouchDiagnostic(@"touch_down", @{
            @"moduleTitle": self.moduleTitle ?: @"",
            @"hasTargetHostButton": @(self.targetHostButton != nil),
        });
    }
    if (UIAccessibilityIsReduceMotionEnabled()) return;
    CGFloat base = self.feedGlyphScale > 0.0 ? self.feedGlyphScale : 1.0;
    [UIView animateWithDuration:0.14
                          delay:0.0
                        options:(UIViewAnimationOptionBeginFromCurrentState |
                                 UIViewAnimationOptionAllowUserInteraction |
                                 UIViewAnimationOptionCurveEaseOut)
                     animations:^{
        self.contentScaleHost.transform = CGAffineTransformMakeScale(0.88 * base, 0.88 * base);
        if (self.moduleSelected) {
            self.selectionLens.transform = CGAffineTransformMakeScale(0.92, 0.92);
        }
    } completion:nil];
}

- (void)animateReleaseBounce {
    CGFloat base = self.feedGlyphScale > 0.0 ? self.feedGlyphScale : 1.0;
    if (UIAccessibilityIsReduceMotionEnabled()) {
        self.contentScaleHost.transform = CGAffineTransformMakeScale(base, base);
        return;
    }
    [UIView animateWithDuration:0.42
                          delay:0.0
         usingSpringWithDamping:0.54
          initialSpringVelocity:0.65
                        options:(UIViewAnimationOptionBeginFromCurrentState |
                                 UIViewAnimationOptionAllowUserInteraction)
                     animations:^{
        self.contentScaleHost.transform = CGAffineTransformMakeScale(base, base);
        self.selectionLens.transform = self.moduleSelected
            ? CGAffineTransformIdentity
            : CGAffineTransformMakeScale(0.84, 0.84);
    } completion:nil];
}

- (void)handleTouchRelease {
    [self animateReleaseBounce];
}

- (void)handleTapUpInside {
    [self animateReleaseBounce];
    UIButton *hostBtn = self.targetHostButton;
    if (self.onTouchDiagnostic) {
        CGRect f = self.frame;
        CGRect b = self.bounds;
        self.onTouchDiagnostic(@"touch_up_inside", @{
            @"moduleTitle": self.moduleTitle ?: @"",
            @"frame": @[@(round(f.origin.x * 10.0) / 10.0), @(round(f.origin.y * 10.0) / 10.0),
                        @(round(f.size.width * 10.0) / 10.0), @(round(f.size.height * 10.0) / 10.0)],
            @"bounds": @[@(round(b.origin.x * 10.0) / 10.0), @(round(b.origin.y * 10.0) / 10.0),
                         @(round(b.size.width * 10.0) / 10.0), @(round(b.size.height * 10.0) / 10.0)],
            @"superviewClass": self.superview ? (NSStringFromClass(self.superview.class) ?: @"") : @"",
            @"hasTargetHostButton": @(hostBtn != nil),
            @"hostButtonClass": hostBtn ? (NSStringFromClass(hostBtn.class) ?: @"") : @"",
            @"hostButtonEnabled": @(hostBtn ? hostBtn.enabled : NO),
            @"hostTargetsCount": @(hostBtn ? [hostBtn allTargets].count : 0),
        });
    }
    if (self.onTapModule) {
        self.onTapModule([hostBtn isKindOfClass:UIButton.class] ? hostBtn : nil);
    } else if ([hostBtn isKindOfClass:UIButton.class]) {
        [hostBtn sendActionsForControlEvents:UIControlEventTouchUpInside];
    }
}

@end
