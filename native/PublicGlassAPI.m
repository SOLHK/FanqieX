// SDK contract for the public APIs invoked by the ARM64 repair.
// Type checking this file does not claim that the host application was run.
#import <UIKit/UIKit.h>

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

// One public native selection control owns its track, thumb and gestures.
// No custom glass, background image or private subview is added around it.
UISegmentedControl *FQMakeNativeSelection(NSArray<NSString *> *titles, CGRect frame,
                                        NSInteger selected, id target, SEL action) {
    UISegmentedControl *selection = [[UISegmentedControl alloc] initWithItems:titles];
    selection.frame = frame;
    selection.momentary = NO;
    selection.apportionsSegmentWidthsByContent = NO;
    selection.selectedSegmentIndex = selected;
    [selection addTarget:target action:action forControlEvents:UIControlEventValueChanged];
    return selection;
}

void FQRestoreNativeSelection(UISegmentedControl *selection, id target, SEL action) {
    [selection removeTarget:target action:action forControlEvents:UIControlEventValueChanged];
    [selection removeFromSuperview];
}

BOOL FQNativeSelectionIsTracking(UISegmentedControl *selection) {
    return selection.isTracking;
}

// Reader navigation controls deliberately receive no replacement symbol,
// geometry adjustment or glass decoration in 1.6.1.

void FQSetListenForeground(UILabel *label) {
    label.textColor = UIColor.labelColor;
}

void FQSuppressOwnedScrollEdge(UIScrollView *scrollView) {
    scrollView.bottomEdgeEffect.hidden = YES;
}
