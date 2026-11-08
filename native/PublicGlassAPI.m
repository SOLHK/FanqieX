// SDK contract for the public APIs invoked by the ARM64 repair.
// Type checking this file does not claim that the host application was run.
#import <UIKit/UIKit.h>

_Static_assert(UIGlassEffectStyleClear == 1,
               "The ARM64 factory call encodes native clear glass as style 1");
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
    UIGlassEffect *effect = [UIGlassEffect effectWithStyle:UIGlassEffectStyleClear];
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

UIImage *FQReaderBackSymbol(void) {
    UIImageSymbolConfiguration *configuration =
        [UIImageSymbolConfiguration configurationWithPointSize:20.0];
    return [UIImage systemImageNamed:@"chevron.backward" withConfiguration:configuration];
}

UIImage *FQUpdateManagedBackState(UIButton *button, UIImage *symbol, UIControlState state) {
    UIImage *original = [button imageForState:state];
    [button setImage:symbol forState:state];
    return original;
}

void FQSetListenForeground(UILabel *label) {
    label.textColor = UIColor.labelColor;
}

void FQSuppressOwnedScrollEdge(UIScrollView *scrollView) {
    scrollView.bottomEdgeEffect.hidden = YES;
}
