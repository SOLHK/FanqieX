#import <UIKit/UIKit.h>
#import <QuartzCore/QuartzCore.h>
#import <objc/runtime.h>

static const void *DockSnapshotKey = &DockSnapshotKey;
static const void *DockAnimatorKey = &DockAnimatorKey;
static NSString *const DockContentAnimation = @"FanqieX.dock.content";

@interface FQXDockMotion : NSObject
+ (void)prepareDock:(UIView *)dock inBar:(UIView *)bar;
+ (void)animateDock:(UIView *)dock fromFrame:(CGRect)frame compact:(BOOL)compact button:(UIView *)button;
@end

@implementation FQXDockMotion
+ (void)prepareDock:(UIView *)dock inBar:(UIView *)bar {
    UIViewPropertyAnimator *previous = objc_getAssociatedObject(dock, DockAnimatorKey);
    [previous stopAnimation:YES];
    [objc_getAssociatedObject(dock, DockSnapshotKey) removeFromSuperview];
    objc_setAssociatedObject(dock, DockAnimatorKey, nil, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
    objc_setAssociatedObject(dock, DockSnapshotKey, nil, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
    if (!dock.window || UIAccessibilityIsReduceMotionEnabled()) return;
    // Snapshot the full native bar region so the fallback sibling labels are
    // included too. Outgoing text fades at its natural size instead of squashing.
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
        // Finish has already detached the compact button. Clear its outgoing
        // animations so a quick collapse does not revive an old flight/fade.
        [button.layer removeAnimationForKey:@"FanqieX.dock.position"];
        [button.layer removeAnimationForKey:DockContentAnimation];
    }
    if (!reduceMotion) {
        // Critically damped geometry; resume from the visible presentation when
        // the user expands before a collapse has finished.
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
            // Let the critical spring settle instead of snapping the last
            // fraction of the full-width-to-circle distance at a fixed cut.
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
@end
