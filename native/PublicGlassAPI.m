// SDK contract for the public APIs invoked by the ARM64 repair.
// Type checking this file does not claim that the host application was run.
#import <UIKit/UIKit.h>
#import <QuartzCore/QuartzCore.h>
#include <stddef.h>

_Static_assert(UIGlassEffectStyleRegular == 0,
               "The main navigation capsule uses the readable regular variant");
_Static_assert(UIBlurEffectStyleSystemUltraThinMaterial == 6,
               "The full-width top bars use adaptive ultra-thin material");
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

void FQSetChapterCardCorners(UIVisualEffectView *surface) {
    surface.cornerConfiguration = [UICornerConfiguration capsuleConfigurationWithMaximumRadius:18.0];
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

void FQConfigureTopChrome(UIVisualEffectView *surface, UIScrollView *scrollView) {
    surface.contentView.backgroundColor = [UIColor.systemBackgroundColor colorWithAlphaComponent:0.0625];
    scrollView.topEdgeEffect.hidden = YES;
}

void FQKeepShelfFilterInline(UICollectionViewFlowLayout *layout) {
    layout.sectionHeadersPinToVisibleBounds = NO;
    [layout invalidateLayout];
}

// 1.6.6 uses the real UIButton configuration system for native icon buttons.
// Host target/action, per-state artwork and interaction stay on the same button.
void FQConfigureNativeIconButton(UIButton *button) {
    UIButtonConfiguration *configuration = [UIButtonConfiguration glassButtonConfiguration];
    configuration.image = [button imageForState:UIControlStateNormal];
    NSAttributedString *title = [button attributedTitleForState:UIControlStateNormal];
    if (title) configuration.attributedTitle = title;
    else configuration.title = [button titleForState:UIControlStateNormal];
    configuration.contentInsets = NSDirectionalEdgeInsetsZero;
    button.configuration = configuration;
}

// 1.6.8 uses native glass only on an owned empty background button. The host
// keeps its configuration, image layout and intrinsic size; no bitmap is copied.
UIButton *FQMakeAlignedGlassBackground(UIView *host, CGRect originalIconRect) {
    UIButton *glass = [UIButton buttonWithType:UIButtonTypeCustom];
    glass.configuration = [UIButtonConfiguration glassButtonConfiguration];
    glass.frame = CGRectMake(CGRectGetMidX(originalIconRect) - 18,
                             CGRectGetMidY(originalIconRect) - 18, 36, 36);
    glass.userInteractionEnabled = NO;
    glass.accessibilityElementsHidden = YES;
    [host insertSubview:glass atIndex:0];
    return glass;
}

// 1.78 uses a runtime-only bridge in AlignedGlass.m. These declarations check
// its public API calls against the real SDK, including the float slider ABI
// that would not be checked by an objc_msgSend cast alone.
_Static_assert(sizeof(void *) == 8 && sizeof(BOOL) == 1 &&
               sizeof(NSInteger) == 8 && sizeof(NSUInteger) == 8,
               "The runtime bridge is for the ARM64 Objective-C scalar ABI");
_Static_assert(__builtin_types_compatible_p(CGFloat, double),
               "The runtime geometry and font bridge passes double CGFloat values");
_Static_assert(sizeof(CGPoint) == 16 && _Alignof(CGPoint) == _Alignof(double) &&
               offsetof(CGPoint, x) == 0 && offsetof(CGPoint, y) == 8 &&
               sizeof(CGSize) == 16 && _Alignof(CGSize) == _Alignof(double) &&
               offsetof(CGSize, width) == 0 && offsetof(CGSize, height) == 8,
               "Point and Size use two consecutive ARM64 double components");
_Static_assert(sizeof(CGRect) == 32 && _Alignof(CGRect) == _Alignof(double) &&
               offsetof(CGRect, origin) == 0 && offsetof(CGRect, size) == 16 &&
               sizeof(UIEdgeInsets) == 32 &&
               offsetof(UIEdgeInsets, top) == 0 && offsetof(UIEdgeInsets, left) == 8 &&
               offsetof(UIEdgeInsets, bottom) == 16 && offsetof(UIEdgeInsets, right) == 24,
               "Rect and inset bridges use four consecutive ARM64 double components");
_Static_assert(__builtin_types_compatible_p(__typeof__(((UISlider *)nil).value), float) &&
               __builtin_types_compatible_p(__typeof__(((UISlider *)nil).minimumValue), float) &&
               __builtin_types_compatible_p(__typeof__(((UISlider *)nil).maximumValue), float),
               "UISlider values are float, not CGFloat or double");
_Static_assert(__builtin_types_compatible_p(__typeof__(((UISwitch *)nil).on), BOOL) &&
               __builtin_types_compatible_p(__typeof__(((UIFont *)nil).pointSize), CGFloat) &&
               __builtin_types_compatible_p(__typeof__(((UIScreen *)nil).scale), CGFloat) &&
               __builtin_types_compatible_p(__typeof__(((UITraitCollection *)nil).displayScale), CGFloat) &&
               __builtin_types_compatible_p(__typeof__(((UIScrollView *)nil).contentSize), CGSize) &&
               __builtin_types_compatible_p(__typeof__([(UIPanGestureRecognizer *)nil translationInView:nil]), CGPoint),
               "Switch, font, scroll and pan accessors must retain their bridge types");
_Static_assert(UIButtonTypeSystem == 1 && NSTextAlignmentRight == 2 &&
               UIViewAutoresizingFlexibleLeftMargin == 1 &&
               UIViewAutoresizingFlexibleWidth == 2 &&
               UIViewAutoresizingFlexibleHeight == 16,
               "The settings controls use the exact public layout enum values");
_Static_assert(UIImageSymbolWeightMedium == 5 && UIImageSymbolScaleMedium == 2 &&
               UIImageRenderingModeAlwaysTemplate == 2 && UIViewContentModeScaleAspectFit == 1,
               "The bottom symbols use medium template artwork with aspect fit");
_Static_assert(UIGestureRecognizerStateBegan == 1 && UIGestureRecognizerStateChanged == 2 &&
               UIGestureRecognizerStateEnded == 3 && UIGestureRecognizerStateCancelled == 4 &&
               UIGestureRecognizerStateFailed == 5,
               "The passive feed observer uses the exact public gesture states");

UISwitch *FQBottomSwitchSDK178(CGRect frame, NSInteger tag, BOOL on,
                              NSString *title, id target, SEL action) {
    UISwitch *toggle = [UISwitch new];
    toggle.frame = frame;
    toggle.tag = tag;
    toggle.autoresizingMask = UIViewAutoresizingFlexibleLeftMargin;
    [toggle setOn:on animated:NO];
    toggle.accessibilityLabel = title;
    [toggle addTarget:target action:action forControlEvents:UIControlEventValueChanged];
    return toggle;
}

UISlider *FQBottomSliderSDK178(CGRect frame, NSInteger tag, float minimum,
                              float maximum, float value, NSString *title,
                              id target, SEL action) {
    UISlider *slider = [UISlider new];
    slider.frame = frame;
    slider.tag = tag;
    slider.autoresizingMask = UIViewAutoresizingFlexibleWidth;
    slider.minimumValue = minimum;
    slider.maximumValue = maximum;
    [slider setValue:value animated:NO];
    slider.accessibilityLabel = title;
    [slider addTarget:target action:action forControlEvents:UIControlEventValueChanged];
    return slider;
}

void FQBottomReadSettingsSDK178(UISwitch *toggle, UISlider *slider,
                               NSUserDefaults *defaults, NSString *flagKey,
                               NSString *valueKey, UILabel *valueLabel) {
    [defaults setBool:toggle.isOn forKey:flagKey];
    [defaults setDouble:(double)slider.value forKey:valueKey];
    NSNumber *stored = [defaults objectForKey:valueKey];
    valueLabel.text = [stored.stringValue stringByAppendingString:@"%"];
    [slider setValue:(float)stored.doubleValue animated:YES];
    [defaults removeObjectForKey:valueKey];
}

UILabel *FQBottomSettingsLabelSDK178(CGRect frame, NSString *title, CGFloat pointSize) {
    UILabel *label = [UILabel new];
    label.frame = frame;
    label.text = title;
    label.font = [UIFont systemFontOfSize:pointSize];
    label.textColor = UIColor.secondaryLabelColor;
    label.textAlignment = NSTextAlignmentRight;
    label.numberOfLines = 0;
    label.autoresizingMask = UIViewAutoresizingFlexibleWidth;
    return label;
}

void FQBottomSettingsPageSDK178(UIViewController *owner, UIViewController *settings,
                               UIScrollView *scroll, UIView *content, CGSize contentSize,
                               id target, SEL action) {
    settings.title = @"底栏外观与尺寸";
    UIView *root = settings.view;
    root.backgroundColor = UIColor.systemGroupedBackgroundColor;
    scroll.frame = root.bounds;
    scroll.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
    scroll.alwaysBounceVertical = YES;
    scroll.contentSize = contentSize;
    [root addSubview:scroll];
    [scroll addSubview:content];
    UIButton *reset = [UIButton buttonWithType:UIButtonTypeSystem];
    [reset setTitle:@"恢复底栏默认设置" forState:UIControlStateNormal];
    [reset addTarget:target action:action forControlEvents:UIControlEventTouchUpInside];
    [content addSubview:reset];
    if (owner.navigationController && !owner.presentedViewController) {
        [owner.navigationController pushViewController:settings animated:YES];
    }
}

UIImageView *FQBottomSymbolSDK178(NSString *name, CGFloat pointSize, CGRect frame) {
    UIImageSymbolConfiguration *configuration =
        [UIImageSymbolConfiguration configurationWithPointSize:pointSize
                                                        weight:UIImageSymbolWeightMedium
                                                         scale:UIImageSymbolScaleMedium];
    UIImage *image = [UIImage systemImageNamed:name withConfiguration:configuration];
    image = [image imageWithRenderingMode:UIImageRenderingModeAlwaysTemplate];
    UIImageView *symbol = [UIImageView new];
    symbol.image = image;
    symbol.frame = frame;
    symbol.contentMode = UIViewContentModeScaleAspectFit;
    symbol.tintColor = UIColor.labelColor;
    symbol.userInteractionEnabled = NO;
    symbol.isAccessibilityElement = NO;
    symbol.accessibilityElementsHidden = YES;
    return symbol;
}

CGPoint FQBottomObservePanSDK178(UIScrollView *scroll, id observer, SEL action, BOOL attach) {
    UIPanGestureRecognizer *pan = scroll.panGestureRecognizer;
    if (attach) [pan addTarget:observer action:action];
    else [pan removeTarget:observer action:action];
    // Production observes the existing recognizer without changing its
    // delegate, translation, enabled state or the scroll view geometry.
    return [pan translationInView:pan.view];
}

NSHashTable<UIView *> *FQBottomWeakViewsSDK178(UIView *view) {
    NSHashTable<UIView *> *views = [NSHashTable weakObjectsHashTable];
    [views addObject:view];
    return views;
}

CGRect FQBottomGeometrySDK178(UIView *view, UIView *destination, CGRect frame) {
    NSValue *saved = [NSValue valueWithCGRect:frame];
    view.frame = saved.CGRectValue;
    return [view convertRect:view.bounds toView:destination];
}

NSArray<NSString *> *FQReaderShareActionsSDK178(UIControl *control) {
    NSArray *targets = control.allTargets.allObjects;
    id target = targets.count ? [targets objectAtIndex:0] : nil;
    if ([target isKindOfClass:NSNull.class]) target = nil;
    return [control actionsForTarget:target forControlEvent:UIControlEventTouchUpInside];
}

void FQReaderAppearanceSDK178(UILabel *caption, UIImageView *glyph, UIView *navigation,
                             CGFloat maximumPointSize, CGRect glyphFrame) {
    if (!caption.attributedText && caption.font.pointSize > maximumPointSize) {
        caption.font = [caption.font fontWithSize:maximumPointSize];
    }
    glyph.frame = glyphFrame;
    // Recognition reads the host's accessibility semantics; it neither sends
    // a sharing action nor replaces the control's registered target/action.
    NSString *label = navigation.accessibilityLabel;
    NSString *identifier = navigation.accessibilityIdentifier;
    (void)label;
    (void)identifier;
}
