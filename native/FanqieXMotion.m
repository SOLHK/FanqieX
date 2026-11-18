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
static const void *DramaSpacingPendingKey = &DramaSpacingPendingKey;
static NSString *const DockContentAnimation = @"FanqieX.dock.content";
static NSString *const GlassDisabledPrefKey = @"FanqieAdBlock.GlassDisabled.1";

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

static void FQXApplyCapsuleCorner(UIVisualEffectView *view, CGFloat maxRadius) {
    if (!view) return;
    Class cornerCls = NSClassFromString(@"UICornerConfiguration");
    SEL setCornerSel = NSSelectorFromString(@"setCornerConfiguration:");
    if (!cornerCls || ![view respondsToSelector:setCornerSel]) return;
    id config = nil;
    SEL maxSel = NSSelectorFromString(@"capsuleConfigurationWithMaximumRadius:");
    SEL capSel = NSSelectorFromString(@"capsuleConfiguration");
    if (maxRadius > 0.0 && [cornerCls respondsToSelector:maxSel]) {
        config = ((id (*)(id, SEL, CGFloat))objc_msgSend)(cornerCls, maxSel, maxRadius);
    } else if ([cornerCls respondsToSelector:capSel]) {
        config = ((id (*)(id, SEL))objc_msgSend)(cornerCls, capSel);
    }
    if (config) {
        ((void (*)(id, SEL, id))objc_msgSend)(view, setCornerSel, config);
    }
}

static UIVisualEffectView *FQXNewGlassView(NSInteger style, BOOL interactive, CGFloat maxRadius, UIColor *tintColor) {
    UIVisualEffect *effect = FQXMakeGlassEffect(style, interactive, tintColor);
    if (!effect) return nil;
    UIVisualEffectView *surface = [[UIVisualEffectView alloc] initWithEffect:effect];
    if (!surface) return nil;
    FQXApplyCapsuleCorner(surface, maxRadius);
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

#pragma mark - Apple Store Tab Bar Interactive Liquid Glass Droplet

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
    CGFloat pillW = MAX(32.0, CGRectGetWidth(btnRect) - 4.0);
    if (self.restingLens && button == [self currentSelectedButton] &&
        CGRectGetWidth(self.restingLens.bounds) >= 28.0 && !self.dropletActive) {
        pillW = CGRectGetWidth(self.restingLens.bounds);
    }
    return CGRectMake(CGRectGetMidX(btnRect) - pillW * 0.5,
                      CGRectGetMidY(track) - pillH * 0.5,
                      pillW,
                      pillH);
}

- (CGRect)bloomRectAtCenterX:(CGFloat)centerX baseWidth:(CGFloat)baseWidth inHost:(UIView *)host {
    if (!host) return CGRectZero;
    CGRect track = [self trackBoundsInHost:host];
    CGFloat W = CGRectGetWidth(track);
    CGFloat H = CGRectGetHeight(track);
    if (W <= 1.0 || H <= 1.0) return CGRectZero;
    CGFloat vOut = round(MIN(MAX(H * 0.13, 6.0), 8.5));
    CGFloat bloomH = H + vOut * 2.0;
    CGFloat desiredW = MAX(baseWidth + round(H * 0.36), round(H * 1.32));
    CGFloat maxAllowedW = MAX(baseWidth, MIN(W - 4.0, MAX(baseWidth * 1.65, H * 1.36)));
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
        UIVisualEffectView *droplet = FQXNewGlassView(1, YES, 0.0, nil);
        if (!droplet) return nil;
        droplet.hidden = YES;
        droplet.alpha = 0.0;
        droplet.clipsToBounds = NO;
        droplet.contentView.clipsToBounds = NO;
        droplet.contentView.layer.borderWidth = 0.65;
        droplet.contentView.layer.borderColor = [UIColor colorWithWhite:1.0 alpha:0.34].CGColor;
        droplet.layer.shadowColor = UIColor.blackColor.CGColor;
        droplet.layer.shadowOpacity = 0.12f;
        droplet.layer.shadowRadius = 10.0;
        droplet.layer.shadowOffset = CGSizeMake(0.0, 3.0);
        self.dropletView = droplet;
    }
    if (self.proxy) {
        self.dropletView.overrideUserInterfaceStyle = self.proxy.overrideUserInterfaceStyle;
    }
    if (host == self.overlay) {
        UIButton *firstBtn = nil;
        for (UIButton *btn in self.buttons) {
            if ([btn isKindOfClass:UIButton.class] && btn.superview == host) {
                firstBtn = btn;
                break;
            }
        }
        if (firstBtn) {
            if (self.dropletView.superview != host) {
                [host insertSubview:self.dropletView belowSubview:firstBtn];
            }
        } else if (self.dropletView.superview != host) {
            [host addSubview:self.dropletView];
        }
    } else {
        if (self.dropletView.superview != host) {
            [host addSubview:self.dropletView];
        }
        [host bringSubviewToFront:self.dropletView];
    }
    return host;
}

- (void)animateButtonScalesHighlighting:(UIButton *)activeButton scale:(CGFloat)scale {
    if (UIAccessibilityIsReduceMotionEnabled()) return;
    [UIView animateWithDuration:0.24
                          delay:0.0
         usingSpringWithDamping:0.70
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
    if (self.dropletView) {
        [self.dropletView.layer removeAllAnimations];
        self.dropletView.alpha = 0.0;
        self.dropletView.hidden = YES;
    }
    if (self.restingLens && self.restingLens.alpha < 1.0) {
        self.restingLens.alpha = 1.0;
    }
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
        [UIView animateWithDuration:0.28
                              delay:0.0
             usingSpringWithDamping:0.82
              initialSpringVelocity:0.0
                            options:UIViewAnimationOptionBeginFromCurrentState | UIViewAnimationOptionAllowUserInteraction
                         animations:^{
            strongSelf.dropletView.frame = rest;
            strongSelf.dropletView.contentView.layer.cornerRadius = MIN(rest.size.width, rest.size.height) * 0.5;
        } completion:nil];

        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.12 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            __strong typeof(weakSelf) innerSelf = weakSelf;
            if (!innerSelf || innerSelf.generation != gen || innerSelf.panning) return;
            [UIView animateWithDuration:0.15
                                  delay:0.0
                                options:UIViewAnimationOptionBeginFromCurrentState | UIViewAnimationOptionAllowUserInteraction | UIViewAnimationOptionCurveEaseOut
                             animations:^{
                if (innerSelf.restingLens) innerSelf.restingLens.alpha = 1.0;
                innerSelf.dropletView.alpha = 0.0;
            } completion:^(BOOL finished) {
                (void)finished;
                if (innerSelf.generation == gen && !innerSelf.panning) {
                    innerSelf.dropletActive = NO;
                    innerSelf.dropletView.hidden = YES;
                    if (innerSelf.restingLens) innerSelf.restingLens.alpha = 1.0;
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
    self.generation += 1;

    UIButton *originBtn = [self currentSelectedButton] ?: sender;
    self.lastSelectedButton = originBtn;
    UIView *host = [self ensureDropletMounted];
    if (!host || !self.dropletView) return;

    if (!self.dropletActive) {
        CGRect startRect = [self restingRectForButton:originBtn inHost:host];
        if (!CGRectIsEmpty(startRect)) {
            [CATransaction begin];
            [CATransaction setDisableActions:YES];
            self.dropletView.frame = startRect;
            self.dropletView.contentView.layer.cornerRadius = MIN(startRect.size.width, startRect.size.height) * 0.5;
            [CATransaction commit];
        }
    }
    self.dropletActive = YES;
    self.dropletView.hidden = NO;
    self.dropletView.alpha = 1.0;
    if (self.restingLens) self.restingLens.alpha = 0.0;

    CGRect restTarget = [self restingRectForButton:sender inHost:host];
    CGRect bloom = [self bloomRectAtCenterX:CGRectGetMidX(restTarget) baseWidth:CGRectGetWidth(restTarget) inHost:host];
    [self animateButtonScalesHighlighting:sender scale:1.10];
    [UIView animateWithDuration:0.28
                          delay:0.0
         usingSpringWithDamping:0.72
          initialSpringVelocity:0.0
                        options:UIViewAnimationOptionBeginFromCurrentState | UIViewAnimationOptionAllowUserInteraction
                     animations:^{
        self.dropletView.frame = bloom;
        self.dropletView.contentView.layer.cornerRadius = MIN(bloom.size.width, bloom.size.height) * 0.5;
    } completion:nil];
}

- (void)onButtonTap:(UIButton *)sender {
    if (![sender isKindOfClass:UIButton.class] || UIAccessibilityIsReduceMotionEnabled()) return;
    if (!self.bar || self.proxy.hidden || (self.overlay && self.overlay.hidden)) return;
    if (!FQXGlassEnabled()) return;
    NSUInteger gen = ++self.generation;

    UIView *host = [self ensureDropletMounted];
    if (!host || !self.dropletView) return;

    if (!self.dropletActive) {
        UIButton *startBtn = self.lastSelectedButton ?: [self currentSelectedButton] ?: sender;
        CGRect startRect = [self restingRectForButton:startBtn inHost:host];
        if (!CGRectIsEmpty(startRect)) {
            [CATransaction begin];
            [CATransaction setDisableActions:YES];
            self.dropletView.frame = startRect;
            self.dropletView.contentView.layer.cornerRadius = MIN(startRect.size.width, startRect.size.height) * 0.5;
            [CATransaction commit];
        }
    }
    self.dropletActive = YES;
    self.dropletView.hidden = NO;
    self.dropletView.alpha = 1.0;
    if (self.restingLens) self.restingLens.alpha = 0.0;

    CGRect restTarget = [self restingRectForButton:sender inHost:host];
    CGRect bloom = [self bloomRectAtCenterX:CGRectGetMidX(restTarget) baseWidth:CGRectGetWidth(restTarget) inHost:host];
    [self animateButtonScalesHighlighting:sender scale:1.10];
    [UIView animateWithDuration:0.34
                          delay:0.0
         usingSpringWithDamping:0.74
          initialSpringVelocity:0.0
                        options:UIViewAnimationOptionBeginFromCurrentState | UIViewAnimationOptionAllowUserInteraction
                     animations:^{
        self.dropletView.frame = bloom;
        self.dropletView.contentView.layer.cornerRadius = MIN(bloom.size.width, bloom.size.height) * 0.5;
    } completion:nil];

    self.lastSelectedButton = sender;
    CFTimeInterval elapsed = CACurrentMediaTime() - self.touchDownTimestamp;
    NSTimeInterval hold = MAX(0.15, 0.22 - MAX(0.0, elapsed));
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
        [self settleDropletToButton:[self currentSelectedButton] afterDelay:0.04 generation:gen];
    } else {
        [self animateButtonScalesHighlighting:nil scale:1.0];
    }
}

- (void)handleOverlayPan:(UIPanGestureRecognizer *)pan {
    if (!self.overlay || !FQXGlassEnabled() || UIAccessibilityIsReduceMotionEnabled()) return;
    UIGestureRecognizerState state = pan.state;
    if (state == UIGestureRecognizerStateBegan || state == UIGestureRecognizerStateChanged) {
        self.panning = YES;
        self.dropletActive = YES;
        self.generation += 1;
        UIView *host = [self ensureDropletMounted];
        if (!host || !self.dropletView) return;
        self.dropletView.hidden = NO;
        self.dropletView.alpha = 1.0;
        if (self.restingLens) self.restingLens.alpha = 0.0;

        CGPoint loc = [pan locationInView:host];
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
            ? MAX(32.0, CGRectGetWidth([hovered.superview convertRect:hovered.frame toView:host]) - 4.0)
            : 56.0;
        CGRect bloom = [self bloomRectAtCenterX:loc.x baseWidth:baseW inHost:host];
        [self animateButtonScalesHighlighting:hovered scale:1.10];
        if (state == UIGestureRecognizerStateBegan) {
            [UIView animateWithDuration:0.22
                                  delay:0.0
                 usingSpringWithDamping:0.76
                  initialSpringVelocity:0.0
                                options:UIViewAnimationOptionBeginFromCurrentState | UIViewAnimationOptionAllowUserInteraction
                             animations:^{
                self.dropletView.frame = bloom;
                self.dropletView.contentView.layer.cornerRadius = MIN(bloom.size.width, bloom.size.height) * 0.5;
            } completion:nil];
        } else {
            [UIView animateWithDuration:0.08
                                  delay:0.0
                                options:UIViewAnimationOptionBeginFromCurrentState | UIViewAnimationOptionAllowUserInteraction | UIViewAnimationOptionCurveEaseOut
                             animations:^{
                self.dropletView.frame = bloom;
                self.dropletView.contentView.layer.cornerRadius = MIN(bloom.size.width, bloom.size.height) * 0.5;
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
        [self settleDropletToButton:selected afterDelay:0.02 generation:gen];
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
        if (self.dropletActive && lens.alpha > 0.0) {
            lens.alpha = 0.0;
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
        self.dropletView.overrideUserInterfaceStyle = proxy.overrideUserInterfaceStyle;
        if (self.restingLens && self.restingLens.alpha > 0.0) self.restingLens.alpha = 0.0;
    } else {
        if (self.restingLens && self.restingLens.alpha < 1.0) self.restingLens.alpha = 1.0;
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
@end

#pragma mark - Drama Spacing Recovery on Navigation Pop & Crossfade

static void FQXTriggerDramaSpacingForControl(UIView *control) {
    if (![control isKindOfClass:UIView.class] || !control.window) return;
    [control setNeedsLayout];
    if ([objc_getAssociatedObject(control, DramaSpacingPendingKey) boolValue]) return;
    objc_setAssociatedObject(control, DramaSpacingPendingKey, @YES, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
    __weak UIView *weakControl = control;
    dispatch_async(dispatch_get_main_queue(), ^{
        UIView *strongControl = weakControl;
        if (!strongControl) return;
        objc_setAssociatedObject(strongControl, DramaSpacingPendingKey, nil, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
        if (strongControl.window) {
            [strongControl setNeedsLayout];
        }
    });
}

static void FQXMarkDramaControlsInSubtree(UIView *root, Class c1, Class c2, NSInteger depth) {
    if (![root isKindOfClass:UIView.class] || depth > 10) return;
    if ((c1 && [root isKindOfClass:c1]) || (c2 && [root isKindOfClass:c2])) {
        FQXTriggerDramaSpacingForControl(root);
    }
    for (UIView *sub in root.subviews) {
        FQXMarkDramaControlsInSubtree(sub, c1, c2, depth + 1);
    }
}

static void FQXRefreshDramaControllerControls(UIViewController *vc) {
    if (![vc isKindOfClass:UIViewController.class] || !vc.isViewLoaded) return;
    Class vPlayerCls = NSClassFromString(@"FQVShortVideoVPlayerControlView");
    Class outerCls = NSClassFromString(@"SSShortVideoOutterMultiGenreFeedControlView");
    FQXMarkDramaControlsInSubtree(vc.view, vPlayerCls, outerCls, 0);
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

static void (*OrigShortVideoListDidAppear)(id, SEL, BOOL);
static void HookShortVideoListDidAppear(UIViewController *self, SEL _cmd, BOOL animated) {
    if (OrigShortVideoListDidAppear) OrigShortVideoListDidAppear(self, _cmd, animated);
    FQXRefreshDramaControllerControls(self);
}

static void (*OrigSeriesFeedDidAppear)(id, SEL, BOOL);
static void HookSeriesFeedDidAppear(UIViewController *self, SEL _cmd, BOOL animated) {
    if (OrigSeriesFeedDidAppear) OrigSeriesFeedDidAppear(self, _cmd, animated);
    FQXRefreshDramaControllerControls(self);
}

static void (*OrigFeedContainerDidAppear)(id, SEL, BOOL);
static void HookFeedContainerDidAppear(UIViewController *self, SEL _cmd, BOOL animated) {
    if (OrigFeedContainerDidAppear) OrigFeedContainerDidAppear(self, _cmd, animated);
    FQXRefreshDramaControllerControls(self);
}

static void (*OrigDistCrossfade)(id, SEL, dispatch_block_t);
static void HookDistCrossfade(UIView *self, SEL _cmd, dispatch_block_t renderBlock) {
    if (OrigDistCrossfade) OrigDistCrossfade(self, _cmd, renderBlock);
    UIView *control = FQXEnclosingDramaControl(self);
    if (control) FQXTriggerDramaSpacingForControl(control);
}

#pragma mark - Audio Play Page ("智能朗读") iOS 26 Liquid Glass (1号 ~ 7号)

static NSHashTable<UIView *> *FQXAudioGlassOwners(void) {
    static NSHashTable<UIView *> *table;
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

static UIVisualEffectView *FQXInstallAudioSurface(UIView *host,
                                                  UIView *mountParent,
                                                  UIView *belowSibling,
                                                  CGRect frame,
                                                  CGFloat maxRadius,
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
        surface = FQXNewGlassView(0, interactive, maxRadius, tintColor);
        if (!surface) return nil;
        objc_setAssociatedObject(host, AudioGlassSurfaceKey, surface, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
    } else if (tintColor) {
        UIVisualEffect *updated = FQXMakeGlassEffect(0, interactive, tintColor);
        if (updated) surface.effect = updated;
    }
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

static void FQXStyleAudioCircleButton(UIButton *btn, CGFloat diameter, UIUserInterfaceStyle style, BOOL enabled) {
    if (![btn isKindOfClass:UIButton.class]) return;
    BOOL visible = enabled && !btn.hidden && btn.alpha > 0.01 && btn.superview != nil &&
                   CGRectGetWidth(btn.bounds) > 1.0 && CGRectGetHeight(btn.bounds) > 1.0;
    FQXAudioSetUnclipped(btn, visible);
    FQXAudioClearBackground(btn, visible);
    CGRect b = btn.bounds;
    CGRect frame = CGRectMake((b.size.width - diameter) * 0.5,
                              (b.size.height - diameter) * 0.5,
                              diameter,
                              diameter);
    FQXInstallAudioSurface(btn, btn, nil, frame, 0.0, YES, style, nil, visible);
    if (visible) [FQXAudioButtonFeedback wireControl:btn];
}

// 1号 & 2号: SSNewAudioPlayNavigationView & SSAudioPageBackView
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
    FQXStyleAudioCircleButton(backBtn, 36.0, style, enabled && !backViewVisible);
    FQXStyleAudioCircleButton(moreBtn, 36.0, style, enabled);
    FQXStyleAudioCircleButton(gameBtn, 34.0, style, enabled);
    FQXStyleAudioCircleButton(shopBtn, 34.0, style, enabled);
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
        FQXStyleAudioCircleButton(closeBtn, 36.0, style, NO);
        CGRect pill = CGRectInset(backView.bounds, 0.0, MAX(0.0, (CGRectGetHeight(backView.bounds) - 36.0) * 0.5));
        FQXInstallAudioSurface(backView, backView, nil, pill, 0.0, YES, style, nil, enabled);
        if (enabled) {
            [FQXAudioButtonFeedback wireControl:closeBtn];
            [FQXAudioButtonFeedback wireControl:backLastBtn];
        }
    } else {
        FQXInstallAudioSurface(backView, backView, nil, CGRectZero, 0.0, YES, style, nil, NO);
        FQXStyleAudioCircleButton(closeBtn, 36.0, style, enabled);
    }
}

// 3号: SSNewAudioPlayBookView.bookNameArrowView
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
    UIVisualEffectView *surface = FQXInstallAudioSurface(arrow, parent, arrow, pill, 0.0, YES, style, nil, active);
    if (surface) {
        surface.hidden = arrow.hidden;
        surface.alpha = arrow.alpha;
    }
}

// 4号: SSNewAudioPlayMenuView & SSNewAudioPlayMenuViewCell
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
                                b.origin.y - 3.0,
                                MAX(0.0, b.size.width - insetX * 2.0),
                                b.size.height + 6.0);
    FQXInstallAudioSurface(menuView, menuView, cv, barRect, 18.0, YES, style, nil, enabled);
}

static void FQXApplyAudioMenuCellPress(UICollectionViewCell *cell, BOOL pressed) {
    if (![cell isKindOfClass:UICollectionViewCell.class]) return;
    FQXTrackAudioView(cell);
    BOOL enabled = FQXGlassEnabled();
    FQXAudioSetUnclipped(cell, enabled);
    FQXAudioSetUnclipped(cell.contentView, enabled);
    UILabel *lbl = FQXObjGet(cell, "nameLabel");
    UIUserInterfaceStyle style = FQXAudioInterfaceStyleForColor(lbl.textColor, NO);
    CGRect pill = CGRectInset(cell.contentView.bounds, 4.0, 1.0);
    UIColor *pressTint = [UIColor colorWithWhite:1.0 alpha:(style == UIUserInterfaceStyleDark ? 0.14 : 0.35)];
    UIVisualEffectView *surface = FQXInstallAudioSurface(cell, cell.contentView, nil, pill, 14.0, YES, style, pressTint, enabled && pressed);
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

// 5号 & 6号: SSNewAudioPlayControlView (目录 menuBtn & 定时 timingBtnBtn + transport circles)
static void FQXStyleAudioPillControlButton(UIButton *btn, UIView *controlOwner, UIUserInterfaceStyle style, BOOL enabled) {
    if (![btn isKindOfClass:UIButton.class]) return;
    BOOL visible = enabled && !btn.hidden && btn.alpha > 0.01 && btn.superview != nil &&
                   CGRectGetWidth(btn.bounds) > 4.0 && CGRectGetHeight(btn.bounds) > 4.0;
    FQXAudioSetUnclipped(btn, visible);
    FQXAudioClearBackground(btn, visible);
    CGRect b = btn.bounds;
    CGFloat w = MAX(b.size.width + 14.0, 50.0);
    CGFloat h = MAX(b.size.height + 8.0, 52.0);
    CGFloat x = (b.size.width - w) * 0.5;
    CGFloat y = (b.size.height - h) * 0.5;
    if (controlOwner && btn.superview == controlOwner) {
        CGFloat minInOwner = 12.0 - btn.frame.origin.x;
        CGFloat maxInOwner = (CGRectGetWidth(controlOwner.bounds) - 12.0) - btn.frame.origin.x - w;
        if (btn.frame.origin.x < CGRectGetWidth(controlOwner.bounds) * 0.5 && x < minInOwner) {
            x = minInOwner;
        } else if (btn.frame.origin.x >= CGRectGetWidth(controlOwner.bounds) * 0.5 && x > maxInOwner) {
            x = maxInOwner;
        }
    }
    FQXInstallAudioSurface(btn, btn, nil, CGRectMake(x, y, w, h), 16.0, YES, style, nil, visible);
    if (visible) [FQXAudioButtonFeedback wireControl:btn];
}

static void FQXApplyAudioControlGlass(UIView *control) {
    if (![control isKindOfClass:UIView.class]) return;
    FQXTrackAudioView(control);
    BOOL enabled = FQXGlassEnabled() && !control.hidden;
    FQXAudioSetUnclipped(control, enabled);
    UIColor *iconTint = FQXObjGet(control, "iconTintColor");
    UIUserInterfaceStyle style = FQXAudioInterfaceStyleForColor(iconTint, NO);

    UIButton *menuBtn = FQXObjGet(control, "menuBtn");
    UIButton *timingBtn = FQXObjGet(control, "timingBtnBtn");
    FQXStyleAudioPillControlButton(menuBtn, control, style, enabled);
    FQXStyleAudioPillControlButton(timingBtn, control, style, enabled);

    const char *bgKeys[] = {"preBtnBgView", "pauseBtnBgView", "nextBtnBgView"};
    for (size_t i = 0; i < sizeof(bgKeys) / sizeof(bgKeys[0]); ++i) {
        UIView *bgView = FQXObjGet(control, bgKeys[i]);
        if (![bgView isKindOfClass:UIView.class]) continue;
        BOOL active = enabled && !bgView.hidden && CGRectGetWidth(bgView.bounds) > 10.0;
        FQXAudioSetUnclipped(bgView, active);
        FQXAudioClearBackground(bgView, active);
        FQXInstallAudioSurface(bgView, bgView, nil, bgView.bounds, 0.0, YES, style, nil, active);
    }
    const char *btnKeys[] = {"preBtn", "pauseBtn", "nextBtn"};
    for (size_t i = 0; i < sizeof(btnKeys) / sizeof(btnKeys[0]); ++i) {
        UIButton *btn = FQXObjGet(control, btnKeys[i]);
        if (enabled && [btn isKindOfClass:UIButton.class]) [FQXAudioButtonFeedback wireControl:btn];
    }
}

// 7号: SSAudioPlayToneView611, SSAudioPlayToneListView, SSAudioPlayToneCell, SSAudioReadingGuideView, SSAudioV4ReadingGuideView
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
        ? [UIColor colorWithWhite:1.0 alpha:(dark ? 0.18 : 0.46)]
        : [UIColor colorWithWhite:1.0 alpha:(dark ? 0.05 : 0.16)];
    CGRect pill = CGRectInset(cell.contentView.bounds, 1.5, 1.5);
    UIVisualEffectView *surface = FQXInstallAudioSurface(cell, cell.contentView, nil, pill, 12.0, YES, style, tint, enabled);
    if (surface) {
        surface.contentView.layer.cornerRadius = MIN(12.0, MIN(pill.size.width, pill.size.height) * 0.5);
        surface.contentView.layer.borderWidth = selected ? 0.85 : 0.4;
        surface.contentView.layer.borderColor = [UIColor colorWithWhite:1.0
                                                                  alpha:selected ? (dark ? 0.46 : 0.72) : (dark ? 0.16 : 0.30)].CGColor;
    }
}

static void FQXApplyAudioOuterCardGlass(UIView *card, UIColor *textSample, BOOL isTrueTone) {
    if (![card isKindOfClass:UIView.class]) return;
    FQXTrackAudioView(card);
    BOOL enabled = FQXGlassEnabled() && !card.hidden &&
                   CGRectGetWidth(card.bounds) > 24.0 && CGRectGetHeight(card.bounds) > 24.0;
    FQXAudioSetUnclipped(card, enabled);
    FQXAudioClearBackground(card, enabled);
    UIUserInterfaceStyle style = FQXAudioInterfaceStyleForColor(textSample, isTrueTone);
    FQXInstallAudioSurface(card, card, nil, card.bounds, 18.0, YES, style, nil, enabled);
}

static void FQXApplyAudioToneListGlass(UIView *toneList) {
    if (![toneList isKindOfClass:UIView.class]) return;
    UILabel *title = FQXObjGet(toneList, "titleLabel");
    BOOL trueTone = FQXBoolGet(toneList, "isTrueTone", NO);
    FQXApplyAudioOuterCardGlass(toneList, title.textColor, trueTone);

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
    FQXApplyAudioOuterCardGlass(guide, tint, trueTone);
}

static void FQXApplyAudioToneView611Glass(UIView *container) {
    if (![container isKindOfClass:UIView.class]) return;
    FQXTrackAudioView(container);
    FQXAudioSetUnclipped(container, FQXGlassEnabled());
    UIView *toneList = FQXObjGet(container, "toneListView");
    UIView *readingView = FQXObjGet(container, "readingView");
    if (toneList) FQXApplyAudioToneListGlass(toneList);
    if (readingView) FQXApplyAudioReadingGuideGlass(readingView);
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
        [view setNeedsLayout];
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

void FQXInstallMotionAndAudioHooks(void);
void FQXInstallMotionAndAudioHooks(void) {
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
#define HOOK_INST(clsName, selName, enc, origVar, hookFn) do { \
    Class _c = NSClassFromString(@clsName); \
    if (_c) FQXInstallOwnedHook(_c, NSSelectorFromString(@selName), NO, enc, (IMP)(hookFn), (IMP *)&(origVar)); \
} while (0)

        // Drama spacing recovery on navigation pop & foreground crossfade (OWN methods only)
        HOOK_INST("FQVShortVideoListViewController", "viewDidAppear:", "v20@0:8B16", OrigShortVideoListDidAppear, HookShortVideoListDidAppear);
        HOOK_INST("SSVideoSeriesFeedViewController", "viewDidAppear:", "v20@0:8B16", OrigSeriesFeedDidAppear, HookSeriesFeedDidAppear);
        HOOK_INST("SSVideoFeedContainerViewController", "viewDidAppear:", "v20@0:8B16", OrigFeedContainerDidAppear, HookFeedContainerDidAppear);
        HOOK_INST("SSShortVideoBottomDistributionView", "performForegroundCrossfadeWithRenderBlock:", "v24@0:8@?16", OrigDistCrossfade, HookDistCrossfade);

        // Audio Play Page Liquid Glass (1号 ~ 7号, verified OWN methods only)
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

#undef HOOK_INST
    });
}
