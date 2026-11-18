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
static const void *FQXPinchRecognizerKey = &FQXPinchRecognizerKey;
static const void *FQXPinchPureCleanActiveKey = &FQXPinchPureCleanActiveKey;
static const void *FQXPinchHiddenViewsKey = &FQXPinchHiddenViewsKey;
static const void *FQXPinchTriggeredInGestureKey = &FQXPinchTriggeredInGestureKey;
static const void *FQXDramaFeatheredGradKey = &FQXDramaFeatheredGradKey;
static const void *FQXParagraphSavedAlphaKey = &FQXParagraphSavedAlphaKey;

static NSString *const DockContentAnimation = @"FanqieX.dock.content";
static NSString *const GlassDisabledPrefKey = @"FanqieAdBlock.GlassDisabled.1";
static NSString *const HighestQualityPrefKey = @"FanqieX.DramaHighestQuality.1";
static NSString *const PinchPureCleanPrefKey = @"FanqieX.DramaPinchPureClean.1";
static NSString *const AudioRecsPrefKey = @"FanqieX.AudioRecommendations.1";

static BOOL FQXGlassEnabled(void) {
    if ([NSUserDefaults.standardUserDefaults integerForKey:GlassDisabledPrefKey] != 0) return NO;
    Class glassCls = NSClassFromString(@"UIGlassEffect");
    Class cornerCls = NSClassFromString(@"UICornerConfiguration");
    return glassCls != Nil && cornerCls != Nil &&
           [glassCls respondsToSelector:NSSelectorFromString(@"effectWithStyle:")] &&
           [cornerCls respondsToSelector:NSSelectorFromString(@"capsuleConfiguration")] &&
           [UIVisualEffectView instancesRespondToSelector:NSSelectorFromString(@"setCornerConfiguration:")];
}

static UIVisualEffect *FQXMakeGlassEffect(NSInteger style, BOOL interactive, UIColor *tintColor) {
    Class glassCls = NSClassFromString(@"UIGlassEffect");
    SEL makeSel = NSSelectorFromString(@"effectWithStyle:");
    if (!glassCls || ![glassCls respondsToSelector:makeSel]) return nil;
    UIVisualEffect *effect = ((id (*)(id, SEL, NSInteger))objc_msgSend)(glassCls, makeSel, style);
    if (!effect) return nil;
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

static void FQXApplyCornerConfiguration(UIVisualEffectView *view, CGFloat radius, BOOL continuousCard) {
    if (!view) return;
    Class cornerCls = NSClassFromString(@"UICornerConfiguration");
    SEL setCornerSel = NSSelectorFromString(@"setCornerConfiguration:");
    if (!cornerCls || ![view respondsToSelector:setCornerSel]) return;
    id config = nil;
    if (radius > 0.0 && continuousCard) {
        Class radiusCls = NSClassFromString(@"UICornerRadius");
        SEL fixedSel = NSSelectorFromString(@"fixedRadius:");
        SEL uniformSel = NSSelectorFromString(@"configurationWithUniformRadius:");
        if (radiusCls && [radiusCls respondsToSelector:fixedSel] && [cornerCls respondsToSelector:uniformSel]) {
            id radObj = ((id (*)(id, SEL, CGFloat))objc_msgSend)(radiusCls, fixedSel, radius);
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
    if (!config && [cornerCls respondsToSelector:capSel]) {
        config = ((id (*)(id, SEL))objc_msgSend)(cornerCls, capSel);
    }
    if (config) {
        ((void (*)(id, SEL, id))objc_msgSend)(view, setCornerSel, config);
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

#pragma mark - Apple Store Tab Bar Refractive Clear Liquid Glass Droplet (iOS 26/27)

@interface FQXTabBarInteraction : NSObject
@property(nonatomic, weak) UIView *bar;
@property(nonatomic, weak) UIVisualEffectView *proxy;
@property(nonatomic, weak) UIView *overlay;
@property(nonatomic, weak) UIView *nativeControl;
@property(nonatomic, weak) UIVisualEffectView *restingLens;
@property(nonatomic, copy) NSArray<UIButton *> *buttons;
@property(nonatomic, strong) NSHashTable<UIButton *> *wiredButtons;
@property(nonatomic, strong) NSHashTable<UIGestureRecognizer *> *wiredRecognizers;
@property(nonatomic, strong) NSHashTable<UIControl *> *wiredControls;
@property(nonatomic, strong) UIVisualEffectView *dropletView;
@property(nonatomic) BOOL dropletActive;
@property(nonatomic) BOOL panning;
@property(nonatomic) NSUInteger generation;
@property(nonatomic) CFTimeInterval touchDownTimestamp;
@property(nonatomic, weak) UIButton *touchDownTargetButton;
@property(nonatomic, weak) UIButton *lastSelectedButton;
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
        _wiredButtons = [NSHashTable weakObjectsHashTable];
        _wiredRecognizers = [NSHashTable weakObjectsHashTable];
        _wiredControls = [NSHashTable weakObjectsHashTable];
    }
    return self;
}

- (UIView *)mountHostView {
    UIView *overlay = self.overlay;
    if (overlay && overlay.superview == self.bar && !overlay.hidden && !overlay.clipsToBounds &&
        (!self.nativeControl || self.nativeControl.hidden)) {
        return overlay;
    }
    return self.bar;
}

- (CGRect)trackBoundsInHost:(UIView *)host {
    if (!host) return CGRectZero;
    if (host == self.overlay) return host.bounds;
    if (self.proxy && self.proxy.superview) {
        return [self.proxy.superview convertRect:self.proxy.frame toView:host];
    }
    return host.bounds;
}

- (UIButton *)currentSelectedButton {
    if ([self.nativeControl isKindOfClass:UISegmentedControl.class] && !self.nativeControl.hidden) {
        NSInteger idx = ((UISegmentedControl *)self.nativeControl).selectedSegmentIndex;
        if (idx >= 0 && (NSUInteger)idx < self.buttons.count) {
            UIButton *cand = self.buttons[(NSUInteger)idx];
            if ([cand isKindOfClass:UIButton.class]) return cand;
        }
    }
    for (UIButton *btn in self.buttons) {
        if ([btn isKindOfClass:UIButton.class] && btn.isSelected) return btn;
    }
    if (self.restingLens && self.restingLens.superview && self.buttons.count) {
        CGFloat midX = CGRectGetMidX(self.restingLens.frame);
        UIButton *best = nil;
        CGFloat bestDist = CGFLOAT_MAX;
        for (UIButton *btn in self.buttons) {
            if (![btn isKindOfClass:UIButton.class] || !btn.superview) continue;
            CGRect bf = [btn.superview convertRect:btn.frame toView:self.restingLens.superview];
            CGFloat dist = fabs(CGRectGetMidX(bf) - midX);
            if (dist < bestDist) {
                bestDist = dist;
                best = btn;
            }
        }
        if (best) return best;
    }
    return self.buttons.firstObject;
}

- (CGRect)restingRectForButton:(UIButton *)button inHost:(UIView *)host {
    if (!button || !button.superview || !host) return CGRectZero;
    CGRect track = [self trackBoundsInHost:host];
    CGRect btnRect = [button.superview convertRect:button.frame toView:host];
    CGFloat barH = CGRectGetHeight(track);
    if (barH <= 1.0 || CGRectGetWidth(btnRect) <= 1.0) return btnRect;
    CGFloat pillH = MAX(28.0, barH - 8.0);
    if (self.restingLens && self.restingLens.superview &&
        CGRectGetHeight(self.restingLens.bounds) >= 24.0 && !self.dropletActive) {
        pillH = MIN(barH - 4.0, CGRectGetHeight(self.restingLens.bounds));
    }
    CGFloat pillW = MAX(36.0, CGRectGetWidth(btnRect) - 4.0);
    if (self.restingLens && button == [self currentSelectedButton] &&
        CGRectGetWidth(self.restingLens.bounds) >= 28.0 && !self.dropletActive) {
        pillW = CGRectGetWidth(self.restingLens.bounds);
    }
    return CGRectMake(CGRectGetMidX(btnRect) - pillW * 0.5,
                      CGRectGetMidY(track) - pillH * 0.5,
                      pillW,
                      pillH);
}

- (CGRect)bloomRectAtCenterX:(CGFloat)centerX
                   baseWidth:(CGFloat)baseWidth
                    velocity:(CGFloat)velocityX
                      inHost:(UIView *)host {
    if (!host) return CGRectZero;
    CGRect track = [self trackBoundsInHost:host];
    CGFloat W = CGRectGetWidth(track);
    CGFloat H = CGRectGetHeight(track);
    if (W <= 1.0 || H <= 1.0) return CGRectZero;
    // Volume-conserving Apple Store horizontal refractive lens (~1.54:1 at rest, gently elongating with velocity).
    CGFloat speedRatio = MIN(1.0, fabs(velocityX) / 1350.0);
    CGFloat stretchW = round(speedRatio * 16.0);
    CGFloat squishV = round(speedRatio * 1.8);
    CGFloat vOut = 5.0 - squishV * 0.5;
    CGFloat bloomH = H + vOut * 2.0;
    CGFloat desiredW = MAX(baseWidth + 20.0, round(H * 1.56)) + stretchW;
    CGFloat maxAllowedW = MAX(baseWidth, MIN(W - 4.0, MAX(baseWidth * 1.80, H * 1.78)));
    CGFloat bloomW = MIN(desiredW, maxAllowedW);
    CGFloat minX = CGRectGetMinX(track) - 4.0;
    CGFloat maxX = CGRectGetMaxX(track) - bloomW + 4.0;
    CGFloat rawX = centerX - bloomW * 0.5;
    if (rawX < minX) {
        rawX = minX - (minX - rawX) * 0.22;
    } else if (rawX > maxX) {
        rawX = maxX + (rawX - maxX) * 0.22;
    }
    return CGRectMake(rawX, CGRectGetMinY(track) - vOut, bloomW, bloomH);
}

- (UIView *)ensureDropletMounted {
    UIView *host = [self mountHostView];
    if (!host || !FQXGlassEnabled()) return nil;
    if (!self.dropletView) {
        // Style 1 = UIGlassEffectStyleClear: pure crystal-clear optical refraction lens.
        UIVisualEffectView *droplet = FQXNewGlassViewFull(1, YES, 0.0, NO, nil);
        if (!droplet) return nil;
        droplet.hidden = YES;
        droplet.alpha = 0.0;
        droplet.clipsToBounds = NO;
        droplet.contentView.clipsToBounds = NO;
        droplet.overrideUserInterfaceStyle = UIUserInterfaceStyleUnspecified;
        self.dropletView = droplet;
    }
    if (self.dropletView.overrideUserInterfaceStyle != UIUserInterfaceStyleUnspecified) {
        self.dropletView.overrideUserInterfaceStyle = UIUserInterfaceStyleUnspecified;
    }
    // Mount IN FRONT of tab icons so Clear glass refracts and warps the underlying
    // tab icons, labels, and dock edge exactly like Apple Store's Liquid Glass tab bar.
    if (self.dropletView.superview != host) {
        [host addSubview:self.dropletView];
    }
    [host bringSubviewToFront:self.dropletView];
    return host;
}

- (void)setRestingLensSuppressed:(BOOL)suppressed animated:(BOOL)animated {
    if (!self.restingLens) return;
    if (suppressed) {
        if (animated && !self.restingLens.hidden && self.restingLens.alpha > 0.01) {
            UIVisualEffectView *lens = self.restingLens;
            [UIView animateWithDuration:0.14
                                  delay:0.0
                                options:UIViewAnimationOptionBeginFromCurrentState | UIViewAnimationOptionAllowUserInteraction | UIViewAnimationOptionCurveEaseOut
                             animations:^{
                lens.alpha = 0.0;
            } completion:^(BOOL finished) {
                if (finished && self.dropletActive) lens.hidden = YES;
            }];
        } else {
            self.restingLens.alpha = 0.0;
            self.restingLens.hidden = YES;
        }
    } else {
        self.restingLens.hidden = NO;
        if (animated) {
            UIVisualEffectView *lens = self.restingLens;
            [UIView animateWithDuration:0.24
                                  delay:0.0
                                options:UIViewAnimationOptionBeginFromCurrentState | UIViewAnimationOptionAllowUserInteraction | UIViewAnimationOptionCurveEaseInOut
                             animations:^{
                lens.alpha = 1.0;
            } completion:nil];
        } else {
            self.restingLens.alpha = 1.0;
        }
    }
}

- (void)animateButtonScalesHighlighting:(UIButton *)activeButton scale:(CGFloat)scale {
    if (UIAccessibilityIsReduceMotionEnabled()) return;
    [UIView animateWithDuration:0.34
                          delay:0.0
         usingSpringWithDamping:0.82
          initialSpringVelocity:0.0
                        options:UIViewAnimationOptionBeginFromCurrentState | UIViewAnimationOptionAllowUserInteraction
                     animations:^{
        for (UIButton *btn in self.buttons) {
            if (![btn isKindOfClass:UIButton.class]) continue;
            btn.transform = (btn == activeButton && scale != 1.0)
                ? CGAffineTransformMakeScale(scale, scale)
                : CGAffineTransformIdentity;
        }
    } completion:nil];
}

- (void)cancelDropletImmediately {
    self.generation += 1;
    self.dropletActive = NO;
    self.panning = NO;
    self.touchDownTargetButton = nil;
    if (self.dropletView) {
        [self.dropletView.layer removeAllAnimations];
        self.dropletView.alpha = 0.0;
        self.dropletView.hidden = YES;
    }
    [self setRestingLensSuppressed:NO animated:NO];
    for (UIButton *btn in self.buttons) {
        if ([btn isKindOfClass:UIButton.class] && !CGAffineTransformIsIdentity(btn.transform)) {
            btn.transform = CGAffineTransformIdentity;
        }
    }
}

- (void)settleDropletToButton:(UIButton *)targetButton afterDelay:(NSTimeInterval)delay generation:(NSUInteger)gen {
    __weak typeof(self) weakSelf = self;
    dispatch_block_t runSettle = ^{
        __strong typeof(weakSelf) strongSelf = weakSelf;
        if (!strongSelf || strongSelf.generation != gen || strongSelf.panning) return;
        UIView *host = strongSelf.dropletView.superview ?: [strongSelf mountHostView];
        UIButton *dest = targetButton ?: [strongSelf currentSelectedButton];
        CGRect rest = [strongSelf restingRectForButton:dest inHost:host];
        if (CGRectIsEmpty(rest) || !strongSelf.dropletView) {
            [strongSelf cancelDropletImmediately];
            return;
        }
        [strongSelf animateButtonScalesHighlighting:nil scale:1.0];
        // Unhurried, viscous Apple Store liquid settle into the resting capsule.
        [UIView animateWithDuration:0.46
                              delay:0.0
             usingSpringWithDamping:0.86
              initialSpringVelocity:0.0
                            options:UIViewAnimationOptionBeginFromCurrentState | UIViewAnimationOptionAllowUserInteraction
                         animations:^{
            strongSelf.dropletView.frame = rest;
        } completion:nil];

        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.20 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            __strong typeof(weakSelf) innerSelf = weakSelf;
            if (!innerSelf || innerSelf.generation != gen || innerSelf.panning) return;
            if (innerSelf.restingLens) innerSelf.restingLens.hidden = NO;
            [UIView animateWithDuration:0.26
                                  delay:0.0
                                options:UIViewAnimationOptionBeginFromCurrentState | UIViewAnimationOptionAllowUserInteraction | UIViewAnimationOptionCurveEaseInOut
                             animations:^{
                if (innerSelf.restingLens) innerSelf.restingLens.alpha = 1.0;
                innerSelf.dropletView.alpha = 0.0;
            } completion:^(BOOL finished) {
                (void)finished;
                if (innerSelf.generation == gen && !innerSelf.panning) {
                    innerSelf.dropletActive = NO;
                    innerSelf.touchDownTargetButton = nil;
                    innerSelf.dropletView.hidden = YES;
                    [innerSelf setRestingLensSuppressed:NO animated:NO];
                }
            }];
        });
    };
    if (delay <= 0.001) {
        runSettle();
    } else {
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(delay * NSEC_PER_SEC)), dispatch_get_main_queue(), runSettle);
    }
}

- (void)onButtonTouchDown:(UIButton *)sender {
    if (![sender isKindOfClass:UIButton.class] || UIAccessibilityIsReduceMotionEnabled()) return;
    if (!self.bar || self.proxy.hidden || (self.overlay && self.overlay.hidden)) return;
    if (!FQXGlassEnabled()) return;
    self.touchDownTimestamp = CACurrentMediaTime();
    self.touchDownTargetButton = sender;
    self.generation += 1;

    UIButton *originBtn = [self currentSelectedButton] ?: sender;
    self.lastSelectedButton = originBtn;
    UIView *host = [self ensureDropletMounted];
    if (!host || !self.dropletView) return;

    BOOL wasActive = self.dropletActive && !self.dropletView.hidden && self.dropletView.alpha > 0.05;
    CGRect originRect = [self restingRectForButton:originBtn inHost:host];
    if (!wasActive && !CGRectIsEmpty(originRect)) {
        [CATransaction begin];
        [CATransaction setDisableActions:YES];
        self.dropletView.frame = originRect;
        self.dropletView.alpha = 0.0;
        self.dropletView.hidden = NO;
        [CATransaction commit];
    } else {
        self.dropletView.hidden = NO;
    }
    self.dropletActive = YES;
    [self setRestingLensSuppressed:YES animated:!wasActive];

    CGRect restTarget = [self restingRectForButton:sender inHost:host];
    CGFloat travelDist = fabs(CGRectGetMidX(restTarget) - CGRectGetMidX(originRect));
    CGRect bloom = [self bloomRectAtCenterX:CGRectGetMidX(restTarget)
                                  baseWidth:CGRectGetWidth(restTarget)
                                   velocity:travelDist * 4.5
                                     inHost:host];
    [self animateButtonScalesHighlighting:sender scale:1.06];

    // Smoothly emerge Clear glass without any 0ms flash.
    [UIView animateWithDuration:0.16
                          delay:0.0
                        options:UIViewAnimationOptionBeginFromCurrentState | UIViewAnimationOptionAllowUserInteraction | UIViewAnimationOptionCurveEaseOut
                     animations:^{
        self.dropletView.alpha = 1.0;
    } completion:nil];

    // Glide gracefully from origin tab across the dock to destination tab with Apple Store viscous spring.
    NSTimeInterval glideDuration = (originBtn != sender) ? 0.48 : 0.40;
    [UIView animateWithDuration:glideDuration
                          delay:0.0
         usingSpringWithDamping:0.82
          initialSpringVelocity:0.0
                        options:UIViewAnimationOptionBeginFromCurrentState | UIViewAnimationOptionAllowUserInteraction
                     animations:^{
        self.dropletView.frame = bloom;
    } completion:nil];
}

- (void)onButtonTap:(UIButton *)sender {
    if (![sender isKindOfClass:UIButton.class] || UIAccessibilityIsReduceMotionEnabled()) return;
    if (!self.bar || self.proxy.hidden || (self.overlay && self.overlay.hidden)) return;
    if (!FQXGlassEnabled()) return;
    NSUInteger gen = ++self.generation;

    UIView *host = [self ensureDropletMounted];
    if (!host || !self.dropletView) return;

    BOOL alreadyGlidingToSender = self.dropletActive && !self.dropletView.hidden && (self.touchDownTargetButton == sender);
    if (!alreadyGlidingToSender) {
        UIButton *startBtn = self.lastSelectedButton ?: [self currentSelectedButton] ?: sender;
        CGRect startRect = [self restingRectForButton:startBtn inHost:host];
        if (!self.dropletActive && !CGRectIsEmpty(startRect)) {
            [CATransaction begin];
            [CATransaction setDisableActions:YES];
            self.dropletView.frame = startRect;
            self.dropletView.alpha = 0.0;
            self.dropletView.hidden = NO;
            [CATransaction commit];
        } else {
            self.dropletView.hidden = NO;
        }
        self.dropletActive = YES;
        [self setRestingLensSuppressed:YES animated:YES];

        CGRect restTarget = [self restingRectForButton:sender inHost:host];
        CGFloat travelDist = fabs(CGRectGetMidX(restTarget) - CGRectGetMidX(startRect));
        CGRect bloom = [self bloomRectAtCenterX:CGRectGetMidX(restTarget)
                                      baseWidth:CGRectGetWidth(restTarget)
                                       velocity:travelDist * 4.5
                                         inHost:host];
        [self animateButtonScalesHighlighting:sender scale:1.06];
        [UIView animateWithDuration:0.16
                              delay:0.0
                            options:UIViewAnimationOptionBeginFromCurrentState | UIViewAnimationOptionAllowUserInteraction | UIViewAnimationOptionCurveEaseOut
                         animations:^{
            self.dropletView.alpha = 1.0;
        } completion:nil];
        [UIView animateWithDuration:0.48
                              delay:0.0
             usingSpringWithDamping:0.82
              initialSpringVelocity:0.0
                            options:UIViewAnimationOptionBeginFromCurrentState | UIViewAnimationOptionAllowUserInteraction
                         animations:^{
            self.dropletView.frame = bloom;
        } completion:nil];
        self.touchDownTimestamp = CACurrentMediaTime();
    }

    self.lastSelectedButton = sender;
    // Allow the glide + refractive swell to arrive gracefully over the target tab before settling!
    CFTimeInterval elapsed = CACurrentMediaTime() - self.touchDownTimestamp;
    NSTimeInterval hold = MAX(0.28, 0.40 - MAX(0.0, elapsed));
    [self settleDropletToButton:sender afterDelay:hold generation:gen];
}

- (void)onNativeValueChanged:(UIControl *)sender {
    if (![sender isKindOfClass:UISegmentedControl.class]) return;
    NSInteger idx = ((UISegmentedControl *)sender).selectedSegmentIndex;
    if (idx >= 0 && (NSUInteger)idx < self.buttons.count) {
        [self onButtonTap:self.buttons[(NSUInteger)idx]];
    }
}

- (void)onButtonCancel:(UIButton *)sender {
    (void)sender;
    if (self.panning) return;
    for (UIGestureRecognizer *gr in self.overlay.gestureRecognizers) {
        if ([gr isKindOfClass:UIPanGestureRecognizer.class] &&
            (gr.state == UIGestureRecognizerStateBegan || gr.state == UIGestureRecognizerStateChanged)) {
            return;
        }
    }
    NSUInteger gen = ++self.generation;
    if (self.dropletActive) {
        [self settleDropletToButton:[self currentSelectedButton] afterDelay:0.08 generation:gen];
    } else {
        [self animateButtonScalesHighlighting:nil scale:1.0];
    }
}

- (void)handleOverlayPan:(UIPanGestureRecognizer *)pan {
    if (!self.overlay || !FQXGlassEnabled() || UIAccessibilityIsReduceMotionEnabled()) return;
    UIGestureRecognizerState state = pan.state;
    if (state == UIGestureRecognizerStateBegan || state == UIGestureRecognizerStateChanged) {
        BOOL justBegan = !self.panning || state == UIGestureRecognizerStateBegan;
        self.panning = YES;
        self.generation += 1;
        UIView *host = [self ensureDropletMounted];
        if (!host || !self.dropletView) return;

        if (!self.dropletActive) {
            UIButton *curBtn = [self currentSelectedButton];
            CGRect startRect = [self restingRectForButton:curBtn inHost:host];
            if (!CGRectIsEmpty(startRect)) {
                [CATransaction begin];
                [CATransaction setDisableActions:YES];
                self.dropletView.frame = startRect;
                self.dropletView.alpha = 0.0;
                [CATransaction commit];
            }
        }
        self.dropletActive = YES;
        self.dropletView.hidden = NO;
        [self setRestingLensSuppressed:YES animated:justBegan];

        CGPoint loc = [pan locationInView:host];
        CGPoint vel = [pan velocityInView:host];
        UIButton *hovered = nil;
        CGFloat bestDist = CGFLOAT_MAX;
        for (UIButton *btn in self.buttons) {
            if (![btn isKindOfClass:UIButton.class] || !btn.superview) continue;
            CGRect bf = [btn.superview convertRect:btn.frame toView:host];
            CGFloat dist = fabs(CGRectGetMidX(bf) - loc.x);
            if (dist < bestDist) {
                bestDist = dist;
                hovered = btn;
            }
        }
        CGFloat baseW = hovered && hovered.superview
            ? MAX(36.0, CGRectGetWidth([hovered.superview convertRect:hovered.frame toView:host]) - 4.0)
            : 60.0;
        CGRect bloom = [self bloomRectAtCenterX:loc.x baseWidth:baseW velocity:vel.x inHost:host];
        [self animateButtonScalesHighlighting:hovered scale:1.06];
        if (justBegan) {
            [UIView animateWithDuration:0.14
                                  delay:0.0
                                options:UIViewAnimationOptionBeginFromCurrentState | UIViewAnimationOptionAllowUserInteraction | UIViewAnimationOptionCurveEaseOut
                             animations:^{
                self.dropletView.alpha = 1.0;
            } completion:nil];
            [UIView animateWithDuration:0.36
                                  delay:0.0
                 usingSpringWithDamping:0.82
                  initialSpringVelocity:0.0
                                options:UIViewAnimationOptionBeginFromCurrentState | UIViewAnimationOptionAllowUserInteraction
                             animations:^{
                self.dropletView.frame = bloom;
            } completion:nil];
        } else {
            self.dropletView.alpha = 1.0;
            [UIView animateWithDuration:0.11
                                  delay:0.0
                 usingSpringWithDamping:0.92
                  initialSpringVelocity:0.0
                                options:UIViewAnimationOptionBeginFromCurrentState | UIViewAnimationOptionAllowUserInteraction
                             animations:^{
                self.dropletView.frame = bloom;
            } completion:nil];
        }
    } else if (self.panning &&
               (state == UIGestureRecognizerStateEnded ||
                state == UIGestureRecognizerStateCancelled ||
                state == UIGestureRecognizerStateFailed)) {
        self.panning = NO;
        NSUInteger gen = ++self.generation;
        UIButton *selected = [self currentSelectedButton];
        self.lastSelectedButton = selected;
        [self settleDropletToButton:selected afterDelay:0.06 generation:gen];
    }
}

- (void)updateLens:(UIVisualEffectView *)lens native:(UIView *)native {
    if (lens) {
        self.restingLens = lens;
        if (lens.superview && lens.superview != self.proxy && lens.superview.superview == self.bar) {
            self.overlay = lens.superview;
            for (UIGestureRecognizer *gr in self.overlay.gestureRecognizers) {
                if ([gr isKindOfClass:UIPanGestureRecognizer.class] && ![self.wiredRecognizers containsObject:gr]) {
                    [gr addTarget:self action:@selector(handleOverlayPan:)];
                    [self.wiredRecognizers addObject:gr];
                }
            }
        }
        if (self.dropletActive) {
            [self setRestingLensSuppressed:YES animated:NO];
            if (self.dropletView.superview) {
                [self.dropletView.superview bringSubviewToFront:self.dropletView];
            }
        }
    }
    if (native) self.nativeControl = native;
}

- (void)syncWithBar:(UIView *)bar
              proxy:(UIVisualEffectView *)proxy
            buttons:(NSArray<UIButton *> *)buttons
             native:(UIView *)native
               lens:(UIVisualEffectView *)lens {
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
    if (compact || !buttons.count) {
        if (self.dropletActive) [self cancelDropletImmediately];
        return;
    }

    for (UIButton *btn in buttons) {
        if (![btn isKindOfClass:UIButton.class]) continue;
        if (![self.wiredButtons containsObject:btn]) {
            [btn addTarget:self action:@selector(onButtonTouchDown:) forControlEvents:UIControlEventTouchDown];
            [btn addTarget:self action:@selector(onButtonTap:) forControlEvents:UIControlEventTouchUpInside];
            [btn addTarget:self action:@selector(onButtonCancel:)
          forControlEvents:UIControlEventTouchUpOutside | UIControlEventTouchCancel | UIControlEventTouchDragExit];
            [self.wiredButtons addObject:btn];
        }
    }

    if (overlay && !native) {
        for (UIGestureRecognizer *gr in overlay.gestureRecognizers) {
            if ([gr isKindOfClass:UIPanGestureRecognizer.class] && ![self.wiredRecognizers containsObject:gr]) {
                [gr addTarget:self action:@selector(handleOverlayPan:)];
                [self.wiredRecognizers addObject:gr];
            }
        }
    }

    if ([native isKindOfClass:UISegmentedControl.class]) {
        UIControl *seg = (UIControl *)native;
        if (![self.wiredControls containsObject:seg]) {
            [seg addTarget:self action:@selector(onNativeValueChanged:) forControlEvents:UIControlEventValueChanged];
            [self.wiredControls addObject:seg];
        }
    }

    if (self.dropletActive && self.dropletView) {
        [self setRestingLensSuppressed:YES animated:NO];
        if (self.dropletView.superview) {
            [self.dropletView.superview bringSubviewToFront:self.dropletView];
        }
    } else {
        [self setRestingLensSuppressed:NO animated:NO];
        self.lastSelectedButton = [self currentSelectedButton];
    }
}

- (void)teardown {
    [self cancelDropletImmediately];
    [self.dropletView removeFromSuperview];
    self.dropletView = nil;
}

@end

static void FQXRefreshAllAudioGlass(void);
static void FQXRefreshAllDramaControlsInWindows(void);
static void FQXRefreshAllPinchCleanStates(void);

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
@end

@implementation FQXDockMotion
+ (void)prepareDock:(UIView *)dock inBar:(UIView *)bar {
    UIViewPropertyAnimator *previous = objc_getAssociatedObject(dock, DockAnimatorKey);
    [previous stopAnimation:YES];
    [objc_getAssociatedObject(dock, DockSnapshotKey) removeFromSuperview];
    objc_setAssociatedObject(dock, DockAnimatorKey, nil, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
    objc_setAssociatedObject(dock, DockSnapshotKey, nil, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
    if (!dock.window || UIAccessibilityIsReduceMotionEnabled()) return;
    CGRect frame = dock.layer.presentationLayer ? dock.layer.presentationLayer.frame : dock.frame;
    UIView *snapshot = [bar resizableSnapshotViewFromRect:frame afterScreenUpdates:NO withCapInsets:UIEdgeInsetsZero];
    snapshot.frame = frame;
    snapshot.userInteractionEnabled = NO;
    snapshot.accessibilityElementsHidden = YES;
    objc_setAssociatedObject(dock, DockSnapshotKey, snapshot, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

+ (void)animateDock:(UIView *)dock fromFrame:(CGRect)frame compact:(BOOL)compact button:(UIView *)button {
    UIView *snapshot = objc_getAssociatedObject(dock, DockSnapshotKey);
    BOOL reduceMotion = UIAccessibilityIsReduceMotionEnabled();
    CALayer *layer = dock.layer;
    CALayer *presentation = layer.presentationLayer;
    CGRect start = presentation ? presentation.frame : frame;
    if (!compact) {
        [button.layer removeAnimationForKey:@"FanqieX.dock.position"];
        [button.layer removeAnimationForKey:DockContentAnimation];
    }
    if (!reduceMotion) {
        NSArray<NSString *> *keys = @[@"bounds", @"position", @"cornerRadius"];
        NSArray *values = @[
            [NSValue valueWithCGRect:(CGRect){dock.bounds.origin, start.size}],
            [NSValue valueWithCGPoint:CGPointMake(CGRectGetMidX(start), CGRectGetMidY(start))],
            @(MIN(start.size.width, start.size.height) * 0.5)
        ];
        for (NSUInteger i = 0; i < keys.count; ++i) {
            CASpringAnimation *spring = [CASpringAnimation animationWithKeyPath:keys[i]];
            spring.mass = 1;
            spring.stiffness = 400;
            spring.damping = 40;
            spring.fromValue = values[i];
            spring.duration = spring.settlingDuration;
            NSString *animationKey = [@"FanqieX.dock." stringByAppendingString:keys[i]];
            [layer addAnimation:spring forKey:animationKey];
            if (compact && i == 1) [button.layer addAnimation:spring forKey:animationKey];
        }
    } else {
        for (NSString *key in @[@"bounds", @"position", @"cornerRadius"]) {
            NSString *animationKey = [@"FanqieX.dock." stringByAppendingString:key];
            [layer removeAnimationForKey:animationKey];
            [button.layer removeAnimationForKey:animationKey];
        }
    }
    UIView *incoming = compact ? button : dock;
    CABasicAnimation *fade = [CABasicAnimation animationWithKeyPath:@"opacity"];
    CALayer *visibleIncoming = incoming.layer.presentationLayer;
    fade.fromValue = [incoming.layer animationForKey:DockContentAnimation] && visibleIncoming ?
        @(visibleIncoming.opacity) : @0;
    fade.toValue = @1;
    fade.duration = reduceMotion ? 0.12 : 0.20;
    [incoming.layer addAnimation:fade forKey:DockContentAnimation];
    if (!snapshot) return;
    [dock.superview addSubview:snapshot];
    UIViewPropertyAnimator *animator = [[UIViewPropertyAnimator alloc] initWithDuration:0.18 curve:UIViewAnimationCurveEaseOut animations:^{
        snapshot.alpha = 0;
    }];
    objc_setAssociatedObject(dock, DockAnimatorKey, animator, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
    __weak UIView *weakDock = dock;
    [animator addCompletion:^(UIViewAnimatingPosition position) {
        (void)position;
        [snapshot removeFromSuperview];
        UIView *owner = weakDock;
        if (owner && objc_getAssociatedObject(owner, DockSnapshotKey) == snapshot) {
            objc_setAssociatedObject(owner, DockSnapshotKey, nil, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
            objc_setAssociatedObject(owner, DockAnimatorKey, nil, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
        }
    }];
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

#pragma mark - Force Highest Available Drama Resolution (1080P+) Across All Scenes

static BOOL sFQXAutoUpdatingResolution = NO;

static BOOL FQXHighestQualityEnabled(void) {
    return [NSUserDefaults.standardUserDefaults boolForKey:HighestQualityPrefKey];
}

static NSMutableSet<NSString *> *FQXManualResolutionVideoIDs(void) {
    static NSMutableSet<NSString *> *set;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        set = [NSMutableSet set];
    });
    return set;
}

static NSString *FQXExtractVideoIdentifier(id model) {
    if (!model) return nil;
    id shortModel = FQXObjGet(model, "shortVideoModel");
    id videoInfo = FQXObjGet(model, "videoInfo");
    const char *keys[] = {"videoId", "vid", "itemId"};
    id targets[] = {model, shortModel, videoInfo};
    for (size_t t = 0; t < sizeof(targets) / sizeof(targets[0]); ++t) {
        if (!targets[t]) continue;
        for (size_t k = 0; k < sizeof(keys) / sizeof(keys[0]); ++k) {
            id val = FQXObjGet(targets[t], keys[k]);
            if ([val isKindOfClass:NSString.class] && [(NSString *)val length] > 0) {
                return (NSString *)val;
            }
        }
    }
    return nil;
}

static BOOL FQXIsVideoLockedOrOffline(id model) {
    if (!model) return NO;
    id shortModel = FQXObjGet(model, "shortVideoModel");
    if (FQXBoolGet(shortModel, "isVideoLocked", NO) || FQXBoolGet(shortModel, "videoModelDisabled", NO)) {
        return YES;
    }
    return FQXBoolGet(model, "useDownloadedEngineData", NO);
}

static NSNumber *FQXBestResolutionNumber(id videoModel, NSArray *supportResolutions) {
    NSArray *candidates = nil;
    if (videoModel) {
        id supported = FQXObjGet(videoModel, "supportedResolutionTypes");
        if ([supported isKindOfClass:NSArray.class] && [(NSArray *)supported count] > 0) {
            candidates = (NSArray *)supported;
        }
    }
    if (!candidates.count && [supportResolutions isKindOfClass:NSArray.class]) {
        candidates = supportResolutions;
    }
    if (!candidates.count) return nil;

    SEL infoSel = NSSelectorFromString(@"videoInfoForType:");
    BOOL canInspectInfo = videoModel && [videoModel respondsToSelector:infoSel];
    Method infoMethod = canInspectInfo ? class_getInstanceMethod(object_getClass(videoModel), infoSel) : NULL;
    if (!infoMethod || strcmp(method_getTypeEncoding(infoMethod), "@24@0:8Q16") != 0) {
        canInspectInfo = NO;
    }

    NSNumber *best = nil;
    NSInteger bestPixels = -1;
    NSInteger bestBitrate = -1;
    NSUInteger bestType = 0;

    for (id item in candidates) {
        if (![item isKindOfClass:NSNumber.class]) continue;
        NSUInteger resType = [(NSNumber *)item unsignedIntegerValue];
        // Skip TTVideoEngineResolutionTypeAuto (4 or 0 depending on table) only if real tiers exist;
        // note in BDFQ/TTVideoEngine: 0=360P(SD), 1=480P(HQ), 2=720P(HD), 3=1080P(FullHD), 5=540P, 6+=2K/4K, 4=Auto.
        if (resType == 4 || resType > 32) continue;
        NSInteger pixels = 0;
        NSInteger bitrate = 0;
        if (canInspectInfo) {
            id urlInfo = ((id (*)(id, SEL, NSUInteger))objc_msgSend)(videoModel, infoSel, resType);
            if (!urlInfo) continue;
            NSInteger w = FQXIntGet(urlInfo, "vWidth", 0);
            NSInteger h = FQXIntGet(urlInfo, "vHeight", 0);
            if (w > 0 && h > 0) pixels = w * h;
            bitrate = FQXIntGet(urlInfo, "bitrate", 0);
        }
        // Rank standard resolution enum order accurately when pixel metadata is absent:
        // 360P(0)->360, 480P(1)->480, 540P(5)->540, 720P(2)->720, 1080P(3)->1080, >=6 -> 1440+resType.
        if (pixels <= 0) {
            switch (resType) {
                case 0: pixels = 640 * 360; break;
                case 1: pixels = 854 * 480; break;
                case 5: pixels = 960 * 540; break;
                case 2: pixels = 1280 * 720; break;
                case 3: pixels = 1920 * 1080; break;
                default: pixels = (NSInteger)(2560 * 1440 + resType * 1000); break;
            }
        }
        if (!best || pixels > bestPixels ||
            (pixels == bestPixels && bitrate > bestBitrate) ||
            (pixels == bestPixels && bitrate == bestBitrate && resType > bestType)) {
            best = (NSNumber *)item;
            bestPixels = pixels;
            bestBitrate = bitrate;
            bestType = resType;
        }
    }
    return best;
}

static void FQXUpgradePlayerToHighestIfNeeded(id component, id player, id model) {
    if (!FQXHighestQualityEnabled() || !player || FQXIsVideoLockedOrOffline(model)) return;
    NSString *vid = FQXExtractVideoIdentifier(model);
    if (vid.length && [FQXManualResolutionVideoIDs() containsObject:vid]) return;

    id engine = FQXObjGet(player, "videoEngine");
    id videoModel = FQXObjGet(FQXObjGet(model, "videoInfo"), "videoModel") ?: FQXObjGet(engine, "videoModel");
    NSArray *supported = engine ? FQXObjGet(engine, "supportedResolutionTypes") : nil;
    NSNumber *best = FQXBestResolutionNumber(videoModel, supported);
    if (!best) return;

    NSUInteger bestType = best.unsignedIntegerValue;
    NSInteger currentType = engine ? FQXIntGet(engine, "currentResolution", -1) : -1;
    if (currentType >= 0 && (NSUInteger)currentType == bestType) return;

    SEL updateSel = NSSelectorFromString(@"updatePlayer:resolution:model:finish:");
    if (component && model && [component respondsToSelector:updateSel]) {
        Method m = class_getInstanceMethod(object_getClass(component), updateSel);
        if (m && strcmp(method_getTypeEncoding(m), "v48@0:8@16@24@32@?40") == 0) {
            sFQXAutoUpdatingResolution = YES;
            ((void (*)(id, SEL, id, id, id, id))objc_msgSend)(component, updateSel, player, best, model, nil);
            sFQXAutoUpdatingResolution = NO;
            return;
        }
    }
    SEL configSel = NSSelectorFromString(@"configResolution:");
    if (engine && [engine respondsToSelector:configSel]) {
        Method cm = class_getInstanceMethod(object_getClass(engine), configSel);
        if (cm) {
            const char *enc = method_getTypeEncoding(cm);
            if (enc && strcmp(enc, "B24@0:8Q16") == 0) {
                (void)((BOOL (*)(id, SEL, NSUInteger))objc_msgSend)(engine, configSel, bestType);
            } else if (enc && strcmp(enc, "v24@0:8Q16") == 0) {
                ((void (*)(id, SEL, NSUInteger))objc_msgSend)(engine, configSel, bestType);
            }
        }
    }
}

static NSUInteger (*OrigFinalResolutionType)(id, SEL, id, id);
static NSUInteger HookFinalResolutionType(id self, SEL _cmd, NSArray *supportResolutions, id videoModel) {
    NSUInteger orig = OrigFinalResolutionType ? OrigFinalResolutionType(self, _cmd, supportResolutions, videoModel) : 0;
    if (!FQXHighestQualityEnabled()) return orig;
    if ([objc_getAssociatedObject(self, FQXManualResItemKey) boolValue]) return orig;
    id modelObj = videoModel ?: FQXObjGet(self, "videoModel");
    NSNumber *best = FQXBestResolutionNumber(modelObj, supportResolutions);
    if (!best) return orig;
    SEL setForceSel = NSSelectorFromString(@"setForceResolutionTypeNumber:");
    if ([self respondsToSelector:setForceSel]) {
        ((void (*)(id, SEL, id))objc_msgSend)(self, setForceSel, best);
    }
    return best.unsignedIntegerValue;
}

static void (*OrigControlUpdateResolution)(id, SEL, id, id, id);
static void HookControlUpdateResolution(id self, SEL _cmd, id model, id resolution, id finishBlock) {
    if (!sFQXAutoUpdatingResolution) {
        NSString *vid = FQXExtractVideoIdentifier(model);
        if (vid.length) {
            NSMutableSet<NSString *> *manual = FQXManualResolutionVideoIDs();
            if (manual.count >= 256) [manual removeAllObjects];
            [manual addObject:vid];
        }
    }
    if (OrigControlUpdateResolution) OrigControlUpdateResolution(self, _cmd, model, resolution, finishBlock);
}

static void (*OrigPreparePlayerAsync)(id, SEL, id, id, BOOL);
static void HookPreparePlayerAsync(id self, SEL _cmd, id player, id model, BOOL asyncFlag) {
    NSString *vid = FQXExtractVideoIdentifier(model);
    BOOL isManual = (vid.length && [FQXManualResolutionVideoIDs() containsObject:vid]) || FQXIsVideoLockedOrOffline(model);
    if (OrigPreparePlayerAsync) OrigPreparePlayerAsync(self, _cmd, player, model, asyncFlag);
    id engineData = player ? FQXObjGet(player, "engineData") : nil;
    id resItem = engineData ? FQXObjGet(engineData, "resolutionItem") : nil;
    if (resItem) {
        objc_setAssociatedObject(resItem, FQXManualResItemKey, isManual ? @YES : nil, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
    }
    if (!isManual && FQXHighestQualityEnabled()) {
        FQXUpgradePlayerToHighestIfNeeded(self, player, model);
    }
}

static void (*OrigUpdateResolutionIfNeed)(id, SEL, id, id);
static void HookUpdateResolutionIfNeed(id self, SEL _cmd, id player, id model) {
    if (OrigUpdateResolutionIfNeed) OrigUpdateResolutionIfNeed(self, _cmd, player, model);
    if (FQXHighestQualityEnabled()) {
        FQXUpgradePlayerToHighestIfNeeded(self, player, model);
    }
}

static void (*OrigSeriesDidPreparedVideoInfo)(id, SEL, id);
static void HookSeriesDidPreparedVideoInfo(UIView *self, SEL _cmd, id player) {
    if (OrigSeriesDidPreparedVideoInfo) OrigSeriesDidPreparedVideoInfo(self, _cmd, player);
    if (!FQXHighestQualityEnabled()) return;
    id model = FQXObjGet(self, "videoDataModel");
    id ctx = FQXObjGet(self, "listVCContext");
    id playerComp = ctx ? FQXObjGet(ctx, "playerContext") : nil;
    FQXUpgradePlayerToHighestIfNeeded(playerComp, player ?: FQXObjGet(self, "vPlayer"), model);
    id engine = FQXObjGet(player ?: FQXObjGet(self, "vPlayer"), "videoEngine");
    NSInteger curRes = engine ? FQXIntGet(engine, "currentResolution", -1) : -1;
    SEL updateTextSel = NSSelectorFromString(@"updateResolutionText:");
    if (curRes >= 0 && [self respondsToSelector:updateTextSel]) {
        ((void (*)(id, SEL, NSUInteger))objc_msgSend)(self, updateTextSel, (NSUInteger)curRes);
    }
}

#pragma mark - Inner Drama Episode 2 Bottom Black Mask Removal & Portrait Full-Canvas

static void FQXAudioClearBackground(UIView *view, BOOL clear);

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
        FQXFeatherDramaBottomGradientView(control);
    }
}

static CGSize (*OrigPlayerViewSizeWithModel)(id, SEL, id);
static CGSize HookPlayerViewSizeWithModel(id self, SEL _cmd, id model) {
    CGSize stock = OrigPlayerViewSizeWithModel ? OrigPlayerViewSizeWithModel(self, _cmd, model) : CGSizeZero;
    if (!FQXGlassEnabled() || stock.width <= 0.0 || stock.height <= stock.width) return stock;
    CGRect screen = UIScreen.mainScreen.bounds;
    CGFloat screenW = MIN(screen.size.width, screen.size.height);
    CGFloat screenH = MAX(screen.size.width, screen.size.height);
    CGFloat diff = screenH - stock.height;
    if (fabs(stock.width - screenW) <= 2.0 && diff >= 36.0 && diff <= 136.0) {
        stock.height = screenH;
    }
    return stock;
}

static CGFloat (*OrigMaxPlayerViewHeightWithModel)(id, SEL, id);
static CGFloat HookMaxPlayerViewHeightWithModel(id self, SEL _cmd, id model) {
    CGFloat stock = OrigMaxPlayerViewHeightWithModel ? OrigMaxPlayerViewHeightWithModel(self, _cmd, model) : 0.0;
    if (!FQXGlassEnabled() || stock <= 0.0) return stock;
    CGRect screen = UIScreen.mainScreen.bounds;
    CGFloat screenW = MIN(screen.size.width, screen.size.height);
    CGFloat screenH = MAX(screen.size.width, screen.size.height);
    CGFloat diff = screenH - stock;
    if (stock > screenW && diff >= 36.0 && diff <= 136.0) {
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

static void (*OrigSeriesSetupSingleBottom)(id, SEL);
static void HookSeriesSetupSingleBottom(UIView *self, SEL _cmd) {
    if (OrigSeriesSetupSingleBottom) OrigSeriesSetupSingleBottom(self, _cmd);
    UIView *singleBottom = FQXObjGet(self, "singleSeriesBottomView");
    if ([singleBottom isKindOfClass:UIView.class]) FQXClearDramaBottomInsertMask(singleBottom);
    UIView *bottomView = FQXObjGet(self, "bottomView");
    if ([bottomView isKindOfClass:UIView.class]) FQXClearDramaBottomInsertMask(bottomView);
    FQXFeatherDramaBottomGradientView(self);
}

#pragma mark - TikTok-Style Two-Finger Spread/Pinch Pure Clean Screen

static BOOL FQXPinchPureCleanEnabled(void) {
    return [NSUserDefaults.standardUserDefaults boolForKey:PinchPureCleanPrefKey];
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
    if (!target.hidden || [hiddenSet containsObject:target]) {
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

static void FQXApplyPinchPureCleanState(UIView *control, BOOL enterClean, BOOL animated) {
    if (![control isKindOfClass:UIView.class]) return;
    [FQXPinchCleanControls() addObject:control];

    id context = FQXObjGet(control, "listVCContext");
    id controlComp = context ? FQXObjGet(context, "controlContext") : nil;

    if (enterClean) {
        objc_setAssociatedObject(control, FQXPinchPureCleanActiveKey, @YES, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
        SEL enterSel = NSSelectorFromString(@"enterCleanMode");
        if (controlComp && [controlComp respondsToSelector:enterSel]) {
            Method m = class_getInstanceMethod(object_getClass(controlComp), enterSel);
            if (m && strcmp(method_getTypeEncoding(m), "v16@0:8") == 0) {
                ((void (*)(id, SEL))objc_msgSend)(controlComp, enterSel);
            }
        }
        NSHashTable<UIView *> *hiddenSet = objc_getAssociatedObject(control, FQXPinchHiddenViewsKey);
        if (!hiddenSet) {
            hiddenSet = [NSHashTable weakObjectsHashTable];
            objc_setAssociatedObject(control, FQXPinchHiddenViewsKey, hiddenSet, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
        }

        Class outerCls = NSClassFromString(@"SSShortVideoOutterMultiGenreFeedControlView");
        if (outerCls && [control isKindOfClass:outerCls]) {
            const char *outerKeys[] = {
                "aboveProgressView", "progressView", "rightInteractionView",
                "leftContainerView", "topGradientView", "bottomGradientView"
            };
            for (size_t i = 0; i < sizeof(outerKeys) / sizeof(outerKeys[0]); ++i) {
                FQXHideViewForPinchClean(FQXObjGet(control, outerKeys[i]), hiddenSet);
            }
            for (UIView *sub in control.subviews) {
                NSString *subCls = NSStringFromClass(sub.class);
                if (![subCls containsString:@"Player"] && ![subCls containsString:@"VideoEngine"]) {
                    FQXHideViewForPinchClean(sub, hiddenSet);
                }
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

        Class seriesFeedCls = NSClassFromString(@"SSVideoSeriesFeedViewController");
        for (UIResponder *resp = control.nextResponder; resp; resp = resp.nextResponder) {
            if (seriesFeedCls && [resp isKindOfClass:seriesFeedCls]) {
                FQXHideViewForPinchClean(FQXObjGet(resp, "headerView"), hiddenSet);
                break;
            }
        }
        FQXHideViewForPinchClean(FQXFindDramaDockForControl(control), hiddenSet);
    } else {
        BOOL wasActive = [objc_getAssociatedObject(control, FQXPinchPureCleanActiveKey) boolValue];
        objc_setAssociatedObject(control, FQXPinchPureCleanActiveKey, nil, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
        NSHashTable<UIView *> *hiddenSet = objc_getAssociatedObject(control, FQXPinchHiddenViewsKey);
        objc_setAssociatedObject(control, FQXPinchHiddenViewsKey, nil, OBJC_ASSOCIATION_RETAIN_NONATOMIC);

        if (wasActive) {
            SEL exitSel = NSSelectorFromString(@"exitCleanMode");
            if (controlComp && [controlComp respondsToSelector:exitSel]) {
                Method m = class_getInstanceMethod(object_getClass(controlComp), exitSel);
                if (m && strcmp(method_getTypeEncoding(m), "v16@0:8") == 0) {
                    ((void (*)(id, SEL))objc_msgSend)(controlComp, exitSel);
                }
            }
        }
        NSArray<UIView *> *restored = [hiddenSet allObjects];
        for (UIView *v in restored) {
            v.hidden = NO;
            if (animated && !UIAccessibilityIsReduceMotionEnabled()) {
                v.alpha = 0.0;
            } else {
                v.alpha = 1.0;
            }
        }
        if (animated && restored.count > 0 && !UIAccessibilityIsReduceMotionEnabled()) {
            [UIView animateWithDuration:0.20
                                  delay:0.0
                                options:UIViewAnimationOptionBeginFromCurrentState | UIViewAnimationOptionAllowUserInteraction | UIViewAnimationOptionCurveEaseOut
                             animations:^{
                for (UIView *v in restored) v.alpha = 1.0;
            } completion:nil];
        }
        [control setNeedsLayout];
    }
}

static void FQXRefreshAllPinchCleanStates(void) {
    if (!FQXPinchPureCleanEnabled()) {
        for (UIView *control in [FQXPinchCleanControls() allObjects]) {
            if ([objc_getAssociatedObject(control, FQXPinchPureCleanActiveKey) boolValue]) {
                FQXApplyPinchPureCleanState(control, NO, YES);
            }
        }
    }
}

@interface FQXDramaPinchGestureRecognizer : UIPinchGestureRecognizer
@end
@implementation FQXDramaPinchGestureRecognizer
@end

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
    if ([otherGestureRecognizer isKindOfClass:UIPanGestureRecognizer.class]) return NO;
    return YES;
}

- (void)triggerHaptic {
    UIImpactFeedbackGenerator *gen = [[UIImpactFeedbackGenerator alloc] initWithStyle:UIImpactFeedbackStyleLight];
    [gen impactOccurred];
}

- (void)handlePinch:(FQXDramaPinchGestureRecognizer *)pinch {
    UIView *control = pinch.view;
    if (!control || !FQXPinchPureCleanEnabled()) return;
    UIGestureRecognizerState state = pinch.state;
    if (state == UIGestureRecognizerStateBegan) {
        objc_setAssociatedObject(pinch, FQXPinchTriggeredInGestureKey, nil, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
        return;
    }
    BOOL alreadyTriggered = [objc_getAssociatedObject(pinch, FQXPinchTriggeredInGestureKey) boolValue];
    BOOL isClean = [objc_getAssociatedObject(control, FQXPinchPureCleanActiveKey) boolValue] ||
                   FQXBoolGet(control, "isCleanMode", NO);

    if (state == UIGestureRecognizerStateChanged && !alreadyTriggered) {
        if (pinch.scale >= 1.15 && !isClean) {
            objc_setAssociatedObject(pinch, FQXPinchTriggeredInGestureKey, @YES, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
            [self triggerHaptic];
            FQXApplyPinchPureCleanState(control, YES, YES);
        } else if (pinch.scale <= 0.86 && isClean) {
            objc_setAssociatedObject(pinch, FQXPinchTriggeredInGestureKey, @YES, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
            [self triggerHaptic];
            FQXApplyPinchPureCleanState(control, NO, YES);
        }
    } else if (state == UIGestureRecognizerStateEnded && !alreadyTriggered) {
        if ((pinch.scale >= 1.10 || (pinch.scale > 1.03 && pinch.velocity > 0.35)) && !isClean) {
            [self triggerHaptic];
            FQXApplyPinchPureCleanState(control, YES, YES);
        } else if ((pinch.scale <= 0.90 || (pinch.scale < 0.97 && pinch.velocity < -0.35)) && isClean) {
            [self triggerHaptic];
            FQXApplyPinchPureCleanState(control, NO, YES);
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
    pinch.cancelsTouchesInView = NO;
    pinch.delaysTouchesBegan = NO;
    pinch.delaysTouchesEnded = NO;
    pinch.delegate = [FQXDramaPinchHandler shared];
    [control addGestureRecognizer:pinch];
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
        FQXApplyPinchPureCleanState(self, NO, NO);
    }
    if (OrigVPlayerWillEndDisplay) OrigVPlayerWillEndDisplay(self, _cmd);
}

static void (*OrigVPlayerUpdateControlState)(id, SEL);
static void HookVPlayerUpdateControlState(UIView *self, SEL _cmd) {
    if (OrigVPlayerUpdateControlState) OrigVPlayerUpdateControlState(self, _cmd);
    if ([objc_getAssociatedObject(self, FQXPinchPureCleanActiveKey) boolValue]) {
        FQXApplyPinchPureCleanState(self, YES, NO);
    }
}

static void (*OrigOuterControlLayout)(id, SEL);
static void HookOuterControlLayout(UIView *self, SEL _cmd) {
    if (OrigOuterControlLayout) OrigOuterControlLayout(self, _cmd);
    FQXAttachDramaPinchIfNeeded(self);
    if ([objc_getAssociatedObject(self, FQXPinchPureCleanActiveKey) boolValue]) {
        FQXApplyPinchPureCleanState(self, YES, NO);
    }
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
    return OrigGestureCompShouldBegin ? OrigGestureCompShouldBegin(self, _cmd, gesture) : YES;
}

static void FQXExitPinchCleanInViewController(UIViewController *vc) {
    if (!vc.isViewLoaded) return;
    for (UIView *control in [FQXPinchCleanControls() allObjects]) {
        if (![objc_getAssociatedObject(control, FQXPinchPureCleanActiveKey) boolValue]) continue;
        for (UIView *cur = control; cur; cur = cur.superview) {
            if (cur == vc.view) {
                FQXApplyPinchPureCleanState(control, NO, NO);
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

static void FQXReaderBackButtonLayout(UIButton *self, SEL _cmd) {
    Class dynCls = object_getClass(self);
    Class supCls = class_getSuperclass(dynCls);
    struct objc_super sup = { .receiver = self, .super_class = supCls };
    ((void (*)(struct objc_super *, SEL))objc_msgSendSuper)(&sup, _cmd);

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

static void FQXEnsureReaderBackButtonSubclass(UIButton *backBtn) {
    if (![backBtn isKindOfClass:UIButton.class]) return;
    Class curCls = object_getClass(backBtn);
    const char *curName = class_getName(curCls);
    if (!curName || strncmp(curName, "FQXReaderBackBtn_", 17) == 0) return;
    if (strncmp(curName, "NSKVONotifying_", 15) == 0) return;

    char subName[128];
    snprintf(subName, sizeof(subName), "FQXReaderBackBtn_%s", curName);
    Class subCls = objc_getClass(subName);
    if (!subCls) {
        subCls = objc_allocateClassPair(curCls, subName, 0);
        if (subCls) {
            class_addMethod(subCls, @selector(layoutSubviews), (IMP)FQXReaderBackButtonLayout, "v16@0:8");
            objc_registerClassPair(subCls);
        }
    }
    if (subCls) {
        object_setClass(backBtn, subCls);
        [backBtn setNeedsLayout];
    }
}

static void (*OrigReaderNavLayoutMotion)(id, SEL);
static void HookReaderNavLayoutMotion(UIView *self, SEL _cmd) {
    if (OrigReaderNavLayoutMotion) OrigReaderNavLayoutMotion(self, _cmd);
    UIButton *backBtn = FQXObjGet(self, "backBtn");
    if ([backBtn isKindOfClass:UIButton.class]) {
        FQXEnsureReaderBackButtonSubclass(backBtn);
        [backBtn setNeedsLayout];
    }
}

static UIUserInterfaceStyle FQXAudioInterfaceStyleForColor(UIColor *sampleTextOrIconColor, BOOL isTrueTone);
static UIVisualEffectView *FQXInstallAudioSurfaceFull(UIView *host,
                                                      UIView *mountParent,
                                                      UIView *belowSibling,
                                                      CGRect frame,
                                                      NSInteger glassStyle,
                                                      CGFloat radius,
                                                      BOOL continuousCard,
                                                      BOOL interactive,
                                                      UIUserInterfaceStyle interfaceStyle,
                                                      UIColor *tintColor,
                                                      BOOL active);
static void FQXAudioSetUnclipped(UIView *view, BOOL unclip);

static void FQXSetParagraphOutlineSuppressed(UIView *imgView, BOOL suppress) {
    if (![imgView isKindOfClass:UIView.class]) return;
    NSNumber *saved = objc_getAssociatedObject(imgView, FQXParagraphSavedAlphaKey);
    if (suppress) {
        if (!saved) {
            objc_setAssociatedObject(imgView, FQXParagraphSavedAlphaKey, @(imgView.alpha), OBJC_ASSOCIATION_RETAIN_NONATOMIC);
        }
        if (imgView.alpha > 0.001) imgView.alpha = 0.0;
    } else if (saved) {
        imgView.alpha = saved.doubleValue;
        objc_setAssociatedObject(imgView, FQXParagraphSavedAlphaKey, nil, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
    }
}

static void FQXApplyReaderParagraphBubbleGlass(UIView *view) {
    if (![view isKindOfClass:UIView.class]) return;
    UILabel *label = FQXObjGet(view, "ideaCountLabel");
    UIView *bubbleImg = FQXObjGet(view, "bubbleImg");
    UIView *commentedImg = FQXObjGet(view, "bubbleCommentedImg");
    UIView *notchImg = FQXObjGet(view, "bubbleNotchImg");
    UIView *authorImg = FQXObjGet(view, "bubbleAuthorImg");
    UIView *lottieView = FQXObjGet(view, "bubbleLottieView");

    BOOL specialBadge = ([authorImg isKindOfClass:UIView.class] && !authorImg.hidden && authorImg.superview == view && authorImg.alpha > 0.05) ||
                        ([lottieView isKindOfClass:UIView.class] && !lottieView.hidden && lottieView.superview == view && lottieView.alpha > 0.05);
    BOOL hasCount = [label isKindOfClass:UILabel.class] && !label.hidden && label.text.length > 0 &&
                    CGRectGetWidth(view.bounds) > 6.0 && CGRectGetHeight(view.bounds) > 6.0;
    BOOL active = FQXGlassEnabled() && hasCount && !specialBadge && !view.hidden;

    FQXAudioSetUnclipped(view, active);
    FQXSetParagraphOutlineSuppressed(bubbleImg, active);
    FQXSetParagraphOutlineSuppressed(commentedImg, active);
    FQXSetParagraphOutlineSuppressed(notchImg, active);

    UIUserInterfaceStyle style = FQXAudioInterfaceStyleForColor(label.textColor, NO);
    CGRect b = view.bounds;
    CGFloat pillH = MAX(18.0, b.size.height + 2.0);
    CGFloat pillW = MAX(pillH + 4.0, b.size.width + 5.0);
    CGRect pill = CGRectMake(CGRectGetMidX(b) - pillW * 0.5,
                             CGRectGetMidY(b) - pillH * 0.5,
                             pillW,
                             pillH);
    FQXInstallAudioSurfaceFull(view, view, label, pill, 0, 0.0, NO, NO, style, nil, active);
    if (active && [label isKindOfClass:UILabel.class]) {
        label.textAlignment = NSTextAlignmentCenter;
        label.frame = b;
    }
}

static void (*OrigParagraphEndLayout)(id, SEL);
static void HookParagraphEndLayout(UIView *self, SEL _cmd) {
    if (OrigParagraphEndLayout) OrigParagraphEndLayout(self, _cmd);
    FQXApplyReaderParagraphBubbleGlass(self);
}

static void (*OrigParagraphEndUpdateCount)(id, SEL);
static void HookParagraphEndUpdateCount(UIView *self, SEL _cmd) {
    if (OrigParagraphEndUpdateCount) OrigParagraphEndUpdateCount(self, _cmd);
    FQXApplyReaderParagraphBubbleGlass(self);
}

static void (*OrigParagraphEndUpdateColor)(id, SEL, id);
static void HookParagraphEndUpdateColor(UIView *self, SEL _cmd, id config) {
    if (OrigParagraphEndUpdateColor) OrigParagraphEndUpdateColor(self, _cmd, config);
    FQXApplyReaderParagraphBubbleGlass(self);
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

static UIUserInterfaceStyle FQXAudioInterfaceStyleForColor(UIColor *sampleTextOrIconColor, BOOL isTrueTone) {
    if (isTrueTone) return UIUserInterfaceStyleLight;
    if ([sampleTextOrIconColor isKindOfClass:UIColor.class]) {
        CGFloat r = 1.0, g = 1.0, b = 1.0, a = 1.0;
        if ([sampleTextOrIconColor getRed:&r green:&g blue:&b alpha:&a]) {
            CGFloat lum = 0.299 * r + 0.587 * g + 0.114 * b;
            return lum < 0.45 ? UIUserInterfaceStyleLight : UIUserInterfaceStyleDark;
        }
        CGFloat w = 1.0;
        if ([sampleTextOrIconColor getWhite:&w alpha:&a]) {
            return w < 0.45 ? UIUserInterfaceStyleLight : UIUserInterfaceStyleDark;
        }
    }
    return UIUserInterfaceStyleDark;
}

static UIVisualEffectView *FQXInstallAudioSurfaceFull(UIView *host,
                                                      UIView *mountParent,
                                                      UIView *belowSibling,
                                                      CGRect frame,
                                                      NSInteger glassStyle,
                                                      CGFloat radius,
                                                      BOOL continuousCard,
                                                      BOOL interactive,
                                                      UIUserInterfaceStyle interfaceStyle,
                                                      UIColor *tintColor,
                                                      BOOL active) {
    if (!host) return nil;
    UIVisualEffectView *surface = objc_getAssociatedObject(host, AudioGlassSurfaceKey);
    if (!active || !FQXGlassEnabled() || !mountParent ||
        CGRectGetWidth(frame) <= 2.0 || CGRectGetHeight(frame) <= 2.0) {
        if (surface) {
            [surface removeFromSuperview];
            objc_setAssociatedObject(host, AudioGlassSurfaceKey, nil, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
        }
        return nil;
    }
    if (!surface) {
        surface = FQXNewGlassViewFull(glassStyle, interactive, radius, continuousCard, tintColor);
        if (!surface) return nil;
        objc_setAssociatedObject(host, AudioGlassSurfaceKey, surface, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
    } else {
        UIVisualEffect *updated = FQXMakeGlassEffect(glassStyle, interactive, tintColor);
        if (updated) surface.effect = updated;
        FQXApplyCornerConfiguration(surface, radius, continuousCard);
    }
    // Strip any legacy artificial border/corner overrides so true iOS 26/27 UIGlassEffect shines cleanly.
    if (surface.contentView.layer.borderWidth != 0.0) surface.contentView.layer.borderWidth = 0.0;
    if (surface.contentView.layer.cornerRadius != 0.0) surface.contentView.layer.cornerRadius = 0.0;

    [CATransaction begin];
    [CATransaction setDisableActions:YES];
    if (!CGRectEqualToRect(surface.frame, frame)) {
        surface.frame = frame;
    }
    if (surface.overrideUserInterfaceStyle != interfaceStyle) {
        surface.overrideUserInterfaceStyle = interfaceStyle;
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
    if (UIAccessibilityIsReduceMotionEnabled() || !FQXGlassEnabled()) return;
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

static void FQXStyleAudioCircleButton(UIButton *btn,
                                      CGFloat diameter,
                                      UIView *clampContainer,
                                      UIUserInterfaceStyle style,
                                      BOOL enabled) {
    if (![btn isKindOfClass:UIButton.class]) return;
    BOOL visible = enabled && !btn.hidden && btn.alpha > 0.01 && btn.superview != nil &&
                   CGRectGetWidth(btn.bounds) > 1.0 && CGRectGetHeight(btn.bounds) > 1.0;
    FQXAudioSetUnclipped(btn, visible);
    FQXAudioClearBackground(btn, visible);
    CGRect b = btn.bounds;
    CGFloat x = (b.size.width - diameter) * 0.5;
    CGFloat y = (b.size.height - diameter) * 0.5;
    if (clampContainer && btn.superview == clampContainer) {
        CGFloat minInOwner = 12.0 - btn.frame.origin.x;
        CGFloat maxInOwner = (CGRectGetWidth(clampContainer.bounds) - 12.0) - btn.frame.origin.x - diameter;
        if (btn.frame.origin.x < CGRectGetWidth(clampContainer.bounds) * 0.5 && x < minInOwner) {
            x = minInOwner;
        } else if (btn.frame.origin.x >= CGRectGetWidth(clampContainer.bounds) * 0.5 && x > maxInOwner) {
            x = maxInOwner;
        }
    }
    CGRect frame = CGRectMake(x, y, diameter, diameter);
    FQXInstallAudioSurfaceFull(btn, btn, nil, frame, 0, 0.0, NO, YES, style, nil, visible);
    if (visible) [FQXAudioButtonFeedback wireControl:btn];
}

// Top Nav: SSNewAudioPlayNavigationView & SSAudioPageBackView (38x38 circles)
static void FQXApplyAudioNavigationGlass(UIView *nav) {
    if (![nav isKindOfClass:UIView.class]) return;
    FQXTrackAudioView(nav);
    BOOL enabled = FQXGlassEnabled();
    UIColor *tint = FQXObjGet(nav, "themeTintColor");
    UIUserInterfaceStyle style = FQXAudioInterfaceStyleForColor(tint, NO);
    FQXAudioSetUnclipped(nav, enabled);

    UIButton *backBtn = FQXObjGet(nav, "backBtn");
    UIView *backView = FQXObjGet(nav, "backView");
    UIButton *moreBtn = FQXObjGet(nav, "moreBtn");
    UIButton *gameBtn = FQXObjGet(nav, "gameEntranceBtn");
    UIButton *shopBtn = FQXObjGet(nav, "shopEntranceBtn");

    BOOL backViewVisible = [backView isKindOfClass:UIView.class] && backView.superview == nav && !backView.hidden;
    FQXStyleAudioCircleButton(backBtn, 38.0, nil, style, enabled && !backViewVisible);
    FQXStyleAudioCircleButton(moreBtn, 38.0, nil, style, enabled);
    FQXStyleAudioCircleButton(gameBtn, 36.0, nil, style, enabled);
    FQXStyleAudioCircleButton(shopBtn, 36.0, nil, style, enabled);
}

static void FQXApplyAudioBackViewGlass(UIView *backView) {
    if (![backView isKindOfClass:UIView.class]) return;
    FQXTrackAudioView(backView);
    BOOL enabled = FQXGlassEnabled() && !backView.hidden;
    UIButton *closeBtn = FQXObjGet(backView, "closeButton");
    UIButton *backLastBtn = FQXObjGet(backView, "backLastButton");
    UIView *splitLine = FQXObjGet(backView, "splitLineView");
    UIUserInterfaceStyle style = FQXAudioInterfaceStyleForColor(closeBtn.tintColor ?: backLastBtn.currentTitleColor, NO);

    BOOL dualButtons = [backLastBtn isKindOfClass:UIButton.class] && !backLastBtn.hidden &&
                       backLastBtn.superview == backView && CGRectGetWidth(backLastBtn.bounds) > 8.0;
    FQXAudioSetUnclipped(backView, enabled);
    FQXAudioClearBackground(backView, enabled);
    if ([splitLine isKindOfClass:UIView.class]) {
        splitLine.alpha = (enabled && dualButtons) ? 0.25 : (enabled ? 0.0 : 1.0);
    }
    if (dualButtons) {
        FQXStyleAudioCircleButton(closeBtn, 38.0, nil, style, NO);
        CGRect pill = CGRectInset(backView.bounds, 0.0, MAX(0.0, (CGRectGetHeight(backView.bounds) - 38.0) * 0.5));
        FQXInstallAudioSurfaceFull(backView, backView, nil, pill, 0, 0.0, NO, YES, style, nil, enabled);
        if (enabled) {
            [FQXAudioButtonFeedback wireControl:closeBtn];
            [FQXAudioButtonFeedback wireControl:backLastBtn];
        }
    } else {
        FQXInstallAudioSurfaceFull(backView, backView, nil, CGRectZero, 0, 0.0, NO, YES, style, nil, NO);
        FQXStyleAudioCircleButton(closeBtn, 38.0, nil, style, enabled);
    }
}

// Book Title Arrow: SSNewAudioPlayBookView.bookNameArrowView (28x28 circle)
static void FQXApplyAudioBookGlass(UIView *bookView) {
    if (![bookView isKindOfClass:UIView.class]) return;
    FQXTrackAudioView(bookView);
    UIImageView *arrow = FQXObjGet(bookView, "bookNameArrowView");
    if (![arrow isKindOfClass:UIView.class]) return;
    UILabel *chapterLabel = FQXObjGet(bookView, "chapterLabel");
    UIUserInterfaceStyle style = FQXAudioInterfaceStyleForColor(chapterLabel.textColor, NO);
    UIView *parent = arrow.superview;
    BOOL showEntrance = FQXBoolGet(bookView, "shouldShowDetailEntrance", YES);
    BOOL active = FQXGlassEnabled() && showEntrance && parent != nil && !arrow.hidden &&
                  arrow.alpha > 0.01 && CGRectGetWidth(arrow.bounds) > 1.0;
    if (parent) FQXAudioSetUnclipped(parent, active);
    FQXAudioSetUnclipped(bookView, active);
    CGFloat size = 28.0;
    CGRect arrowFrame = arrow.frame;
    CGRect pill = CGRectMake(CGRectGetMidX(arrowFrame) - size * 0.5,
                             CGRectGetMidY(arrowFrame) - size * 0.5,
                             size,
                             size);
    UIVisualEffectView *surface = FQXInstallAudioSurfaceFull(arrow, parent, arrow, pill, 0, 0.0, NO, YES, style, nil, active);
    if (surface) {
        surface.hidden = arrow.hidden;
        surface.alpha = arrow.alpha;
    }
}

// 图七 1号 / 图六 4号: SSNewAudioPlayMenuView — Clear refractive glass card (style = 1) with Apple-bezel 22pt continuous corners
static void FQXApplyAudioMenuGlass(UIView *menuView) {
    if (![menuView isKindOfClass:UIView.class]) return;
    FQXTrackAudioView(menuView);
    BOOL enabled = FQXGlassEnabled() && !menuView.hidden && CGRectGetWidth(menuView.bounds) > 40.0;
    FQXAudioSetUnclipped(menuView, enabled);
    FQXAudioClearBackground(menuView, enabled);

    UICollectionView *cv = nil;
    for (UIView *sub in menuView.subviews) {
        if ([sub isKindOfClass:UICollectionView.class]) {
            cv = (UICollectionView *)sub;
            break;
        }
    }
    UIColor *sampleColor = nil;
    if (cv) {
        FQXAudioSetUnclipped(cv, enabled);
        FQXAudioClearBackground(cv, enabled);
        for (UICollectionViewCell *cell in cv.visibleCells) {
            UILabel *lbl = FQXObjGet(cell, "nameLabel");
            if ([lbl isKindOfClass:UILabel.class] && lbl.textColor) {
                sampleColor = lbl.textColor;
                break;
            }
        }
    }
    UIUserInterfaceStyle style = FQXAudioInterfaceStyleForColor(sampleColor, NO);
    CGRect b = menuView.bounds;
    CGFloat insetX = (menuView.frame.origin.x <= 2.0 && menuView.superview &&
                      CGRectGetWidth(b) >= CGRectGetWidth(menuView.superview.bounds) - 4.0) ? 12.0 : 0.0;
    CGRect barRect = CGRectMake(b.origin.x + insetX,
                                b.origin.y - 4.0,
                                MAX(0.0, b.size.width - insetX * 2.0),
                                b.size.height + 8.0);
    // Use UIGlassEffectStyleClear (style = 1) with UIUserInterfaceStyleUnspecified (0) when dark
    // so scrolling novel lyrics directly behind 1号 refract visibly through the glass!
    UIUserInterfaceStyle menuGlassStyle = (style == UIUserInterfaceStyleLight) ? UIUserInterfaceStyleLight : UIUserInterfaceStyleUnspecified;
    FQXInstallAudioSurfaceFull(menuView, menuView, cv, barRect, 1, 22.0, YES, YES, menuGlassStyle, nil, enabled);
}

static void FQXApplyAudioMenuCellPress(UICollectionViewCell *cell, BOOL pressed) {
    if (![cell isKindOfClass:UICollectionViewCell.class]) return;
    FQXTrackAudioView(cell);
    BOOL enabled = FQXGlassEnabled();
    FQXAudioSetUnclipped(cell, enabled);
    FQXAudioSetUnclipped(cell.contentView, enabled);
    UILabel *lbl = FQXObjGet(cell, "nameLabel");
    UIUserInterfaceStyle style = FQXAudioInterfaceStyleForColor(lbl.textColor, NO);
    CGRect pill = CGRectInset(cell.contentView.bounds, 4.0, 0.0);
    UIColor *pressTint = [UIColor colorWithWhite:1.0 alpha:(style == UIUserInterfaceStyleDark ? 0.14 : 0.35)];
    UIVisualEffectView *surface = FQXInstallAudioSurfaceFull(cell, cell.contentView, nil, pill, 1, 16.0, YES, YES, style, pressTint, enabled && pressed);
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
    BOOL enabled = FQXGlassEnabled() && !control.hidden;
    FQXAudioSetUnclipped(control, enabled);
    FQXAudioClearBackground(control, enabled);
    UIColor *iconTint = FQXObjGet(control, "iconTintColor");
    UIUserInterfaceStyle style = FQXAudioInterfaceStyleForColor(iconTint, NO);

    UIButton *menuBtn = FQXObjGet(control, "menuBtn");
    UIButton *timingBtn = FQXObjGet(control, "timingBtnBtn");
    FQXStyleAudioCircleButton(menuBtn, 54.0, control, style, enabled);
    FQXStyleAudioCircleButton(timingBtn, 54.0, control, style, enabled);

    const char *bgKeys[] = {"preBtnBgView", "pauseBtnBgView", "nextBtnBgView"};
    for (size_t i = 0; i < sizeof(bgKeys) / sizeof(bgKeys[0]); ++i) {
        UIView *bgView = FQXObjGet(control, bgKeys[i]);
        if (![bgView isKindOfClass:UIView.class]) continue;
        BOOL active = enabled && !bgView.hidden && CGRectGetWidth(bgView.bounds) > 10.0;
        FQXAudioSetUnclipped(bgView, active);
        FQXAudioClearBackground(bgView, active);
        FQXInstallAudioSurfaceFull(bgView, bgView, nil, bgView.bounds, 0, 0.0, NO, YES, style, nil, active);
    }
    const char *btnKeys[] = {"preBtn", "pauseBtn", "nextBtn"};
    for (size_t i = 0; i < sizeof(btnKeys) / sizeof(btnKeys[0]); ++i) {
        UIButton *btn = FQXObjGet(control, btnKeys[i]);
        if (enabled && [btn isKindOfClass:UIButton.class]) [FQXAudioButtonFeedback wireControl:btn];
    }
}

// 图六 7号: Borderless Apple-bezel continuous large-corner cards (24pt outer, 18pt inner) + circular > arrows
static void FQXApplyAudioToneCellGlass(UICollectionViewCell *cell) {
    if (![cell isKindOfClass:UICollectionViewCell.class]) return;
    FQXTrackAudioView(cell);
    BOOL enabled = FQXGlassEnabled() && CGRectGetWidth(cell.contentView.bounds) > 16.0 &&
                   CGRectGetHeight(cell.contentView.bounds) > 16.0;
    FQXAudioSetUnclipped(cell, enabled);
    FQXAudioSetUnclipped(cell.contentView, enabled);
    FQXAudioClearBackground(cell, enabled);
    FQXAudioClearBackground(cell.contentView, enabled);
    if (cell.backgroundView) {
        cell.backgroundView.hidden = enabled;
    }
    UIView *edgeShadow = FQXObjGet(cell, "edgeShadowView");
    if ([edgeShadow isKindOfClass:UIView.class]) {
        edgeShadow.hidden = enabled;
    }

    UILabel *titleLabel = FQXObjGet(cell, "titleLabel");
    UIUserInterfaceStyle style = FQXAudioInterfaceStyleForColor(titleLabel.textColor, NO);
    BOOL selected = cell.isSelected || FQXBoolGet(cell, "blurSelected", NO);
    BOOL dark = (style != UIUserInterfaceStyleLight);
    UIColor *tint = selected
        ? [UIColor colorWithWhite:1.0 alpha:(dark ? 0.22 : 0.50)]
        : [UIColor colorWithWhite:1.0 alpha:(dark ? 0.06 : 0.16)];
    CGRect pill = CGRectInset(cell.contentView.bounds, 1.0, 1.0);
    FQXInstallAudioSurfaceFull(cell, cell.contentView, nil, pill, 0, 18.0, YES, YES, style, tint, enabled);
}

static void FQXApplyAudioOuterCardGlass(UIView *card, UIColor *textSample, BOOL isTrueTone) {
    if (![card isKindOfClass:UIView.class]) return;
    FQXTrackAudioView(card);
    BOOL enabled = FQXGlassEnabled() && !card.hidden &&
                   CGRectGetWidth(card.bounds) > 24.0 && CGRectGetHeight(card.bounds) > 24.0;
    FQXAudioSetUnclipped(card, enabled);
    FQXAudioClearBackground(card, enabled);
    UIUserInterfaceStyle style = FQXAudioInterfaceStyleForColor(textSample, isTrueTone);
    FQXInstallAudioSurfaceFull(card, card, nil, card.bounds, 0, 24.0, YES, YES, style, nil, enabled);
}

static void FQXApplyAudioToneListGlass(UIView *toneList) {
    if (![toneList isKindOfClass:UIView.class]) return;
    UILabel *title = FQXObjGet(toneList, "titleLabel");
    BOOL trueTone = FQXBoolGet(toneList, "isTrueTone", NO);
    UIUserInterfaceStyle style = FQXAudioInterfaceStyleForColor(title.textColor, trueTone);
    FQXApplyAudioOuterCardGlass(toneList, title.textColor, trueTone);

    // Circular Liquid Glass button on `音色设置 >` arrow (`moreButton`)
    UIButton *moreBtn = FQXObjGet(toneList, "moreButton");
    if ([moreBtn isKindOfClass:UIButton.class]) {
        FQXStyleAudioCircleButton(moreBtn, 28.0, nil, style, FQXGlassEnabled());
    }

    UICollectionView *cv = FQXObjGet(toneList, "toneListView");
    if ([cv isKindOfClass:UICollectionView.class]) {
        FQXAudioClearBackground(cv, FQXGlassEnabled());
        for (UICollectionViewCell *cell in cv.visibleCells) {
            FQXApplyAudioToneCellGlass(cell);
        }
    }
}

static void FQXApplyAudioReadingGuideGlass(UIView *guide) {
    if (![guide isKindOfClass:UIView.class]) return;
    UILabel *title = FQXObjGet(guide, "titleLabel");
    UIColor *tint = FQXObjGet(guide, "textTintColor") ?: title.textColor;
    BOOL trueTone = FQXBoolGet(guide, "isTrueTone", NO);
    UIUserInterfaceStyle style = FQXAudioInterfaceStyleForColor(tint, trueTone);
    FQXApplyAudioOuterCardGlass(guide, tint, trueTone);

    // Circular Liquid Glass pill behind `边听边读 >` arrow (`indicatorImageView`)
    UIView *arrow = FQXObjGet(guide, "indicatorImageView");
    if ([arrow isKindOfClass:UIView.class] && arrow.superview != nil) {
        BOOL active = FQXGlassEnabled() && !arrow.hidden && arrow.alpha > 0.01 && CGRectGetWidth(arrow.bounds) > 1.0;
        CGFloat d = 26.0;
        CGRect af = arrow.frame;
        CGRect circle = CGRectMake(CGRectGetMidX(af) - d * 0.5, CGRectGetMidY(af) - d * 0.5, d, d);
        FQXInstallAudioSurfaceFull(arrow, arrow.superview, arrow, circle, 0, 0.0, NO, YES, style, nil, active);
    }
}

static void FQXApplyAudioToneView611Glass(UIView *container) {
    if (![container isKindOfClass:UIView.class]) return;
    FQXTrackAudioView(container);
    BOOL enabled = FQXGlassEnabled();
    FQXAudioSetUnclipped(container, enabled);
    FQXAudioClearBackground(container, enabled);
    UIView *toneList = FQXObjGet(container, "toneListView");
    UIView *readingView = FQXObjGet(container, "readingView");
    if (toneList) FQXApplyAudioToneListGlass(toneList);
    if (readingView) FQXApplyAudioReadingGuideGlass(readingView);
}

// 图七 2号 & 3号: Seamless Audio Background (remove bottom dark shadow bands)
static void FQXApplyAudioBackgroundSeamless(UIView *bgView) {
    if (![bgView isKindOfClass:UIView.class]) return;
    FQXTrackAudioView(bgView);
    NSNumber *recsVal = [NSUserDefaults.standardUserDefaults objectForKey:AudioRecsPrefKey];
    BOOL recsHidden = [recsVal isKindOfClass:NSNumber.class] && !recsVal.boolValue;
    BOOL seamless = FQXGlassEnabled() || recsHidden;

    CALayer *gradLayer = FQXObjGet(bgView, "bottomBgMaskGradientLayer");
    if ([gradLayer isKindOfClass:CALayer.class]) {
        [CATransaction begin];
        [CATransaction setDisableActions:YES];
        gradLayer.hidden = seamless;
        [CATransaction commit];
    }
    UIView *bottomBgView = FQXObjGet(bgView, "bottomBgView");
    FQXAudioSetHiddenTracked(bottomBgView, seamless);

    UIView *bottomView = FQXObjGet(bgView, "bottomView");
    UIView *pixelBlur = FQXObjGet(bgView, "pixelBlurBgImageView");
    BOOL hasBlurArt = [pixelBlur isKindOfClass:UIView.class] && !pixelBlur.hidden && pixelBlur.alpha > 0.05;
    if ([bottomView isKindOfClass:UIView.class]) {
        if (seamless && hasBlurArt) {
            FQXAudioSetHiddenTracked(bottomView, YES);
        } else {
            FQXAudioSetHiddenTracked(bottomView, NO);
            if (seamless && bgView.backgroundColor) {
                bottomView.backgroundColor = bgView.backgroundColor;
            }
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
    if (!FQXGlassEnabled()) return;
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

static void FQXApplyAudioPlayControllerRefractionAndSeamless(UIViewController *vc) {
    if (![vc isKindOfClass:UIViewController.class] || !vc.isViewLoaded) return;
    [FQXAudioPlayVCs() addObject:vc];

    BOOL glassOn = FQXGlassEnabled();
    BOOL expanded = FQXBoolGet(vc, "isReaderVCExpanded", NO);
    BOOL active = glassOn && !expanded;

    // 1. Hide opaque brown bottom masks that blocked novel text behind 1号 and created seams at 2号/3号.
    UIView *bottomMask = FQXObjGet(vc, "bottomMaskView");
    UIView *bottomHalfMask = FQXObjGet(vc, "bottomMaskViewHalfBgView");
    FQXAudioSetHiddenTracked(bottomMask, active);
    FQXAudioSetHiddenTracked(bottomHalfMask, active);

    UIView *slideContainer = FQXObjGet(vc, "bottomSlideContainerView");
    UIView *pinnedContainer = FQXObjGet(vc, "pinnedControlContainerView");
    FQXAudioClearBackground(slideContainer, glassOn);
    FQXAudioClearBackground(pinnedContainer, glassOn);

    UIView *bgView = FQXObjGet(vc, "backgroundView");
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
    if (FQXGlassEnabled() && ![objc_getAssociatedObject(self, AudioClearingBgKey) boolValue]) {
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

static void (*OrigAudioVCLayoutContent)(id, SEL);
static void HookAudioVCLayoutContent(UIViewController *self, SEL _cmd) {
    if (OrigAudioVCLayoutContent) OrigAudioVCLayoutContent(self, _cmd);
    FQXApplyAudioPlayControllerRefractionAndSeamless(self);
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

void FQXInstallMotionAndAudioHooks(void);
void FQXInstallMotionAndAudioHooks(void) {
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
#define HOOK_INST(clsName, selName, enc, origVar, hookFn) do { \
    Class _c = NSClassFromString(@clsName); \
    if (_c) FQXInstallOwnedHook(_c, NSSelectorFromString(@selName), NO, enc, (IMP)(hookFn), (IMP *)&(origVar)); \
} while (0)

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

        // 2. Drama highest available resolution (1080P+) across all scenes
        HOOK_INST("FQVPlayerEngineDataResolutionItem", "finalResolutionTypeWithSupportResolutions:videoModel:", "Q32@0:8@16@24", OrigFinalResolutionType, HookFinalResolutionType);
        HOOK_INST("FQVShortVideoListVCControlComponent", "updateCurrentPlayResolutionWithVideoDataModel:resolution:finishBlock:", "v40@0:8@16@24@?32", OrigControlUpdateResolution, HookControlUpdateResolution);
        HOOK_INST("FQVShortVideoListVCPlayerComponent", "preparePlayer:model:async:", "v36@0:8@16@24B32", OrigPreparePlayerAsync, HookPreparePlayerAsync);
        HOOK_INST("FQVShortVideoListVCPlayerComponent", "updateResolutionIfNeedWithPlayer:model:", "v32@0:8@16@24", OrigUpdateResolutionIfNeed, HookUpdateResolutionIfNeed);
        HOOK_INST("FQVShortVideoVPlayerSeriesControlView", "vPlayerDidPreparedVideoInfo:", "v24@0:8@16", OrigSeriesDidPreparedVideoInfo, HookSeriesDidPreparedVideoInfo);

        // 3. Inner drama Episode 2 bottom black mask removal & full-height portrait canvas
        HOOK_INST("FQVShortVideoListVCPlayerComponent", "playerViewSizeWithModel:", "{CGSize=dd}24@0:8@16", OrigPlayerViewSizeWithModel, HookPlayerViewSizeWithModel);
        HOOK_INST("FQVShortVideoListVCPlayerComponent", "maxPlayerViewHeightWithModel:", "d24@0:8@16", OrigMaxPlayerViewHeightWithModel, HookMaxPlayerViewHeightWithModel);
        HOOK_INST("SSShortVideoBottomInsertView", "setupBottomSubviews", "v16@0:8", OrigBottomInsertSetup, HookBottomInsertSetup);
        HOOK_INST("SSShortVideoBottomInsertView", "refreshLayoutForResizing", "v16@0:8", OrigBottomInsertResize, HookBottomInsertResize);
        HOOK_INST("SSShortVideoSingleBottomInsertView", "setupViews", "v16@0:8", OrigSingleBottomInsertSetup, HookSingleBottomInsertSetup);
        HOOK_INST("FQVShortVideoPlayerBottomView", "setup", "v16@0:8", OrigPlayerBottomViewSetup, HookPlayerBottomViewSetup);
        HOOK_INST("FQVShortVideoVPlayerSeriesControlView", "setupSingleBottomViewIfNeed", "v16@0:8", OrigSeriesSetupSingleBottom, HookSeriesSetupSingleBottom);

        // 4. TikTok-style two-finger spread/pinch pure clean screen
        HOOK_INST("FQVShortVideoVPlayerControlView", "setupGestures", "v16@0:8", OrigVPlayerSetupGestures, HookVPlayerSetupGestures);
        HOOK_INST("FQVShortVideoVPlayerControlView", "controlViewWillDisplay", "v16@0:8", OrigVPlayerWillDisplay, HookVPlayerWillDisplay);
        HOOK_INST("FQVShortVideoVPlayerControlView", "controlViewWillEndDisplay", "v16@0:8", OrigVPlayerWillEndDisplay, HookVPlayerWillEndDisplay);
        HOOK_INST("FQVShortVideoVPlayerControlView", "updateControlState", "v16@0:8", OrigVPlayerUpdateControlState, HookVPlayerUpdateControlState);
        HOOK_INST("SSShortVideoOutterMultiGenreFeedControlView", "layoutSubviews", "v16@0:8", OrigOuterControlLayout, HookOuterControlLayout);
        HOOK_INST("FQVShortVideoListVCGestureComponent", "pinchGesture:", "v24@0:8@16", OrigGestureCompPinch, HookGestureCompPinch);
        HOOK_INST("FQVShortVideoListVCGestureComponent", "gestureRecognizerShouldBegin:", "B24@0:8@16", OrigGestureCompShouldBegin, HookGestureCompShouldBegin);

        // 5. Reader back button centering, inline paragraph comment glass & Mine fold clipping
        HOOK_INST("FQReaderSaasNavigationView", "layoutSubviews", "v16@0:8", OrigReaderNavLayoutMotion, HookReaderNavLayoutMotion);
        HOOK_INST("FQCReaderParagraphEndView", "layoutSubviews", "v16@0:8", OrigParagraphEndLayout, HookParagraphEndLayout);
        HOOK_INST("FQCReaderParagraphEndView", "updateIdeaLabelCount", "v16@0:8", OrigParagraphEndUpdateCount, HookParagraphEndUpdateCount);
        HOOK_INST("FQCReaderParagraphEndView", "updateBubbleColorWithConfig:", "v24@0:8@16", OrigParagraphEndUpdateColor, HookParagraphEndUpdateColor);
        HOOK_INST("SSScrollFoldFuncView", "layoutSubviews", "v16@0:8", OrigScrollFoldLayout, HookScrollFoldLayout);

        // 6. Audio Play Page Liquid Glass, Refraction & Seamless Background
        HOOK_INST("SSNewAudioPlayNavigationView", "layoutSubviews", "v16@0:8", OrigAudioNavLayout, HookAudioNavLayout);
        HOOK_INST("SSNewAudioPlayNavigationView", "setThemeTintColor:", "v24@0:8@16", OrigAudioNavSetTint, HookAudioNavSetTint);
        HOOK_INST("SSAudioPageBackView", "layoutSubviews", "v16@0:8", OrigAudioBackLayout, HookAudioBackLayout);
        HOOK_INST("SSAudioPageBackView", "_adjustAppearanceColor", "v16@0:8", OrigAudioBackAdjust, HookAudioBackAdjust);
        HOOK_INST("SSNewAudioPlayBookView", "layout", "v16@0:8", OrigAudioBookLayout, HookAudioBookLayout);
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
        HOOK_INST("SSNewAudioPlayViewController", "layoutContentView", "v16@0:8", OrigAudioVCLayoutContent, HookAudioVCLayoutContent);
        HOOK_INST("SSNewAudioPlayViewController", "rd_layoutTopAndBottomMaskViews", "v16@0:8", OrigAudioVCLayoutMasks, HookAudioVCLayoutMasks);
        HOOK_INST("SSNewAudioPlayViewController", "sliderProgresslayoutTopAndBottomMaskViews", "v16@0:8", OrigAudioVCSliderMasks, HookAudioVCSliderMasks);
        HOOK_INST("SSNewAudioPlayViewController", "updateBottomMaskGradientThemeColor:", "v24@0:8@16", OrigAudioVCBottomMaskTheme, HookAudioVCBottomMaskTheme);
        HOOK_INST("SSNewAudioPlayViewController", "updateSlideBottomMaskGradientThemeColor:", "v24@0:8@16", OrigAudioVCSlideMaskTheme, HookAudioVCSlideMaskTheme);
        HOOK_INST("SSAudioPlayTTSReaderPageViewController", "layoutSubviews", "v16@0:8", OrigTTSReaderLayout, HookTTSReaderLayout);
        HOOK_INST("SSAudioPlayTTSReaderPageViewController", "updateCaptionMask", "v16@0:8", OrigTTSReaderUpdateMask, HookTTSReaderUpdateMask);

#undef HOOK_INST
    });
}
