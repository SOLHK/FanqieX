// SDK contract for the public APIs invoked by the ARM64 repair.
// Type checking this file does not claim that the host application was run.
#import <UIKit/UIKit.h>
#import <QuartzCore/QuartzCore.h>

_Static_assert(UIGlassEffectStyleRegular == 0,
               "The main navigation capsule uses the readable regular variant");
_Static_assert(UIControlEventValueChanged == 4096,
               "The native selection bridge observes only value changes");
_Static_assert(UIControlEventTouchDown == 1 && UIControlEventTouchUpInside == 64 &&
               UIControlEventTouchUpOutside == 128 && UIControlEventTouchCancel == 256,
               "Passive observation must subscribe to the exact public touch events");
_Static_assert(UIControlStateNormal == 0 && UIControlStateHighlighted == 1 &&
               UIControlStateDisabled == 2 && UIControlStateSelected == 4,
               "The state-image loop uses the public low three state bits");

@protocol FQPassiveTouchObserver
- (void)observeTouch:(UIControl *)sender;
@end

void FQAddPassiveTouchObserver(UIControl *control, id<FQPassiveTouchObserver> observer) {
    if (control.isEnabled) {
        [control addTarget:observer action:@selector(observeTouch:)
          forControlEvents:UIControlEventTouchDown];
    }
}

void FQRemovePassiveTouchObserver(UIControl *control, id<FQPassiveTouchObserver> observer) {
    [control removeTarget:observer action:@selector(observeTouch:)
         forControlEvents:UIControlEventTouchDown];
}

UIVisualEffectView *FQMakePublicGlassSurface(CGRect frame) {
    UIGlassEffect *effect = [UIGlassEffect effectWithStyle:UIGlassEffectStyleRegular];
    effect.interactive = YES;
    effect.tintColor = nil;
    UIVisualEffectView *surface = [[UIVisualEffectView alloc] initWithEffect:effect];
    surface.frame = frame;
    surface.alpha = 1.0;
    surface.opaque = NO;
    surface.backgroundColor = UIColor.clearColor;
    surface.contentView.backgroundColor = UIColor.clearColor;
    surface.cornerConfiguration = [UICornerConfiguration capsuleConfiguration];
    surface.userInteractionEnabled = NO;
    return surface;
}

// One Regular surface remains present in both native and fallback modes.
// The native selector lives in its contentView. Existing icon/title buttons
// are presentation-only siblings above it, preserving actual font rendering.
UISegmentedControl *FQMakeNativeSelection(NSArray<NSString *> *titles,
                                        UIVisualEffectView *surface,
                                        NSInteger selected, id target, SEL action) {
    UISegmentedControl *selection = [[UISegmentedControl alloc] initWithItems:titles];
    selection.frame = surface.contentView.bounds;
    selection.momentary = NO;
    selection.apportionsSegmentWidthsByContent = NO;
    selection.backgroundColor = UIColor.clearColor;
    selection.tintColor = UIColor.labelColor;
    selection.selectedSegmentTintColor = UIColor.secondarySystemFillColor;
    NSDictionary<NSAttributedStringKey, id> *attributes = @{
        NSForegroundColorAttributeName: UIColor.clearColor
    };
    for (UIControlState state = 0; state < 8; state++) {
        [selection setTitleTextAttributes:attributes forState:state];
    }
    selection.selectedSegmentIndex = selected;
    [selection addTarget:target action:action forControlEvents:UIControlEventValueChanged];
    surface.userInteractionEnabled = YES;
    surface.contentView.userInteractionEnabled = YES;
    [surface.contentView insertSubview:selection atIndex:0];
    return selection;
}

// Production records and conditionally restores these properties on teardown.
void FQPresentOriginalButtonAboveNativeSelection(UIButton *button) {
    button.backgroundColor = UIColor.clearColor;
    button.userInteractionEnabled = NO;
    button.accessibilityElementsHidden = YES;
    button.isAccessibilityElement = NO;
}

// Shelf decoration is fully configured before its first live attachment.
// No mask, cornerRadius override, or geometry change is applied to the host.
UIVisualEffectView *FQAttachShelfGlass(UIView *host, CGRect frame) {
    UIGlassEffect *effect = [UIGlassEffect effectWithStyle:UIGlassEffectStyleRegular];
    effect.interactive = YES;
    UIVisualEffectView *surface = [[UIVisualEffectView alloc] initWithEffect:effect];
    [CATransaction begin];
    [CATransaction setDisableActions:YES];
    surface.frame = frame;
    surface.cornerConfiguration = [UICornerConfiguration capsuleConfiguration];
    surface.autoresizingMask = UIViewAutoresizingNone;
    surface.opaque = NO;
    surface.backgroundColor = UIColor.clearColor;
    surface.contentView.backgroundColor = UIColor.clearColor;
    surface.userInteractionEnabled = NO;
    surface.accessibilityElementsHidden = YES;
    surface.isAccessibilityElement = NO;
    [host insertSubview:surface atIndex:0];
    [CATransaction commit];
    return surface;
}

void FQRestoreNativeSelection(UISegmentedControl *selection, id target, SEL action) {
    [selection removeTarget:target action:action forControlEvents:UIControlEventValueChanged];
    [selection removeFromSuperview];
}

BOOL FQNativeSelectionIsTracking(UISegmentedControl *selection) {
    return selection.isTracking;
}

// Reader navigation controls deliberately receive no replacement symbol,
// geometry adjustment or glass decoration in 1.6.2.

void FQSetListenForeground(UILabel *label) {
    label.textColor = UIColor.labelColor;
}

void FQSuppressOwnedScrollEdge(UIScrollView *scrollView) {
    scrollView.bottomEdgeEffect.hidden = YES;
}
