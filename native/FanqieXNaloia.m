#import "FanqieXNaloia.h"
#import <QuartzCore/QuartzCore.h>
#import <objc/runtime.h>
#import <math.h>
#import "FanqieXNaloiaPaths.inc"
#import "FanqieXNaloiaScan.h"

static NSString *const MovementKey = @"naloia.vector.movement";
static NSString *const ColorKey = @"naloia.vector.color";
static NSString *const ScanKey = @"naloia.vector.scan";
static const CGRect Canvas = {{0, 0}, {108, 108}};
static char PresentationKey;
static char GlyphPresentationKey;

NSString *FQXNaloiaPreferenceKey(FQXNaloiaRole role) {
    switch (role) {
        case FQXNaloiaFavorite: return @"FanqieX.DramaNaloiaFavorite.1";
        case FQXNaloiaComment: return @"FanqieX.DramaNaloiaComment.1";
        case FQXNaloiaLike: return @"FanqieX.DramaNaloiaLike.1";
        case FQXNaloiaShare: return @"FanqieX.DramaNaloiaShare.1";
        case FQXNaloiaRoleCount: break;
    }
    return nil;
}

BOOL FQXNaloiaEnabled(FQXNaloiaRole role) {
    NSString *key = FQXNaloiaPreferenceKey(role);
    return key && [NSUserDefaults.standardUserDefaults integerForKey:key] == 1;
}

static UIColor *Ink(FQXNaloiaRole role, BOOL selected) {
    if (selected && role == FQXNaloiaFavorite)
        return [UIColor colorWithRed:52.0/255.0 green:156.0/255.0 blue:1 alpha:1];
    if (selected && role == FQXNaloiaLike)
        return [UIColor colorWithRed:1 green:55.0/255.0 blue:95.0/255.0 alpha:1];
    return UIColor.whiteColor;
}

// The mask is the mathematical complement of the SVG cutout. It belongs
// only to the heart's shape layer and samples no view or background pixels.
static CGPathRef NewCutout(CGPathRef hole) CF_RETURNS_RETAINED {
    CGMutablePathRef mask = CGPathCreateMutable();
    CGPathAddRect(mask, NULL, Canvas);
    CGPathAddPath(mask, NULL, hole);
    return mask;
}

static CGPathRef StaticLikePath(void) {
    static CGPathRef path;
    static dispatch_once_t once;
    dispatch_once(&once, ^{
        CGMutablePathRef combined = CGPathCreateMutable();
        CGPathAddPath(combined, NULL, FQXNaloiaPath(FQXNaloiaLikeHeart));
        CGPathAddPath(combined, NULL, FQXNaloiaPath(FQXNaloiaLikeECG));
        path = combined;
    });
    return path;
}

enum { ContourPoints = 96 };

static CGPoint MixPoint(CGPoint a, CGPoint b, CGFloat fraction) {
    return CGPointMake(a.x + (b.x - a.x) * fraction, a.y + (b.y - a.y) * fraction);
}

static void SampleContour(const CGPoint *raw, NSUInteger count, CGPoint *samples) {
    CGFloat length[160];
    length[0] = 0;
    for (NSUInteger i = 1; i < count; i++)
        length[i] = length[i - 1] + hypot(raw[i].x - raw[i - 1].x, raw[i].y - raw[i - 1].y);
    for (NSUInteger i = 0, segment = 1; i < ContourPoints; i++) {
        CGFloat distance = length[count - 1] * i / ContourPoints;
        while (segment + 1 < count && distance > length[segment]) segment++;
        CGFloat run = length[segment] - length[segment - 1];
        samples[i] = MixPoint(raw[segment - 1], raw[segment], run > 0 ?
            (distance - length[segment - 1]) / run : 0);
    }
}

static const CGPoint *StaticContour(void) {
    static CGPoint samples[ContourPoints];
    static dispatch_once_t once;
    dispatch_once(&once, ^{
        CGPoint storage[160];
        CGPoint *raw = storage;
        __block NSUInteger count = 0;
        CGPathApplyWithBlock(FQXNaloiaPath(FQXNaloiaLikeECG), ^(const CGPathElement *element) {
            switch (element->type) {
                case kCGPathElementMoveToPoint:
                case kCGPathElementAddLineToPoint:
                    raw[count++] = element->points[0];
                    break;
                case kCGPathElementAddQuadCurveToPoint: {
                    CGPoint start = raw[count - 1];
                    for (NSUInteger i = 1; i <= 12; i++) {
                        CGFloat t = i / 12.0;
                        raw[count++] = MixPoint(MixPoint(start, element->points[0], t),
                            MixPoint(element->points[0], element->points[1], t), t);
                    }
                    break;
                }
                case kCGPathElementCloseSubpath:
                    raw[count++] = raw[0];
                    break;
                default: break;
            }
        });
        SampleContour(raw, count, samples);
    });
    return samples;
}

static void WaveContour(FQXNaloiaScanSample sample, CGPoint *samples) {
    const CGFloat left = 34, right = 75.5, radius = 4;
    CGPoint raw[114];
    NSUInteger count = 0;
    CGFloat leftY = FQXNaloiaWaveHeight(left, sample), rightY = FQXNaloiaWaveHeight(right, sample);
    for (NSUInteger i = 0; i <= 8; i++) {
        CGFloat angle = -M_PI_2 - i * M_PI / 8;
        raw[count++] = CGPointMake(left + radius * cos(angle), leftY + radius * sin(angle));
    }
    for (NSUInteger i = 1; i < 48; i++) {
        CGFloat x = left + (right - left) * i / 48;
        raw[count++] = CGPointMake(x, FQXNaloiaWaveHeight(x, sample) + radius);
    }
    for (NSUInteger i = 0; i <= 8; i++) {
        CGFloat angle = M_PI_2 - i * M_PI / 8;
        raw[count++] = CGPointMake(right + radius * cos(angle), rightY + radius * sin(angle));
    }
    for (NSUInteger i = 1; i < 48; i++) {
        CGFloat x = right - (right - left) * i / 48;
        raw[count++] = CGPointMake(x, FQXNaloiaWaveHeight(x, sample) - radius);
    }
    raw[count++] = raw[0];
    SampleContour(raw, count, samples);
}

static CGPathRef NewScanFrame(CGFloat progress, BOOL selected) CF_RETURNS_RETAINED {
    FQXNaloiaScanSample sample = FQXNaloiaScanAt(progress, selected);
    CGPoint moving[ContourPoints];
    WaveContour(sample, moving);
    const CGPoint *resting = StaticContour();
    CGMutablePathRef path = CGPathCreateMutable();
    CGPathAddRect(path, NULL, Canvas);
    for (NSUInteger i = 0; i < ContourPoints; i++) {
        CGPoint point = MixPoint(resting[i], moving[i], sample.blend);
        if (i == 0) CGPathMoveToPoint(path, NULL, point.x, point.y);
        else CGPathAddLineToPoint(path, NULL, point.x, point.y);
    }
    CGPathCloseSubpath(path);
    return path;
}

static CATransform3D Pose(CGFloat x, CGFloat y, CGFloat sx, CGFloat sy, CGFloat degrees) {
    CATransform3D result = CATransform3DMakeTranslation(x, y, 0);
    result = CATransform3DRotate(result, degrees * M_PI / 180, 0, 0, 1);
    return CATransform3DScale(result, sx, sy, 1);
}

static NSValue *Motion(CGFloat x, CGFloat y, CGFloat sx, CGFloat sy, CGFloat angle) {
    return [NSValue valueWithCATransform3D:Pose(x, y, sx, sy, angle)];
}

static void AnimateShape(CALayer *layer, NSArray<NSValue *> *poses, NSArray<NSNumber *> *times,
                         CFTimeInterval duration) {
    CALayer *shown = layer.presentationLayer ?: layer;
    CAKeyframeAnimation *animation = [CAKeyframeAnimation animationWithKeyPath:@"transform"];
    animation.values = [@[[NSValue valueWithCATransform3D:shown.transform]] arrayByAddingObjectsFromArray:poses];
    animation.keyTimes = times;
    animation.calculationMode = kCAAnimationLinear;
    CAMediaTimingFunction *ease = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseInEaseOut];
    NSMutableArray *curves = [NSMutableArray arrayWithCapacity:poses.count];
    for (NSUInteger i = 0; i < poses.count; i++) [curves addObject:ease];
    animation.timingFunctions = curves;
    animation.duration = duration;
    [layer addAnimation:animation forKey:MovementKey];
}

@interface FQXNaloiaPresentation : NSObject
@property(nonatomic, weak) UIImageView *glyph;
@property(nonatomic) FQXNaloiaRole role;
@property(nonatomic, strong) id identity;
@property(nonatomic) BOOL selected;
@property(nonatomic) BOOL panelOpen;
@property(nonatomic, strong) CALayer *canvas;
@property(nonatomic, copy) NSArray<CAShapeLayer *> *parts;
@property(nonatomic, strong) CAShapeLayer *cutout;
@property(nonatomic, strong) UIImage *stockImage;
@property(nonatomic, strong) UIImage *stockHighlight;
@property(nonatomic, strong) UIImage *emptyImage;
@property(nonatomic, strong) UIImage *emptyHighlight;
@property(nonatomic) BOOL replacingContents;
@property(nonatomic) NSUInteger scanGeneration;
+ (BOOL)enabledForRole:(NSInteger)role;
+ (void)updateOwner:(UIView *)owner glyph:(UIImageView *)glyph role:(NSInteger)role
          identity:(id)identity selected:(BOOL)selected animate:(BOOL)animate;
+ (void)detachOwner:(UIView *)owner;
+ (void)pressOwner:(UIView *)owner;
+ (void)imageDidChange:(UIImageView *)glyph;
- (void)finishMotion;
@end

static NSHashTable<UIView *> *Owners(void) {
    static NSHashTable<UIView *> *owners;
    static dispatch_once_t once;
    dispatch_once(&once, ^{
        owners = NSHashTable.weakObjectsHashTable;
        NSNotificationCenter *center = NSNotificationCenter.defaultCenter;
        void (^finish)(NSNotification *) = ^(__unused NSNotification *note) {
            for (UIView *owner in owners.allObjects) {
                FQXNaloiaPresentation *state = objc_getAssociatedObject(owner, &PresentationKey);
                [state finishMotion];
            }
        };
        [center addObserverForName:UIApplicationDidEnterBackgroundNotification object:nil
            queue:NSOperationQueue.mainQueue usingBlock:finish];
        [center addObserverForName:UIAccessibilityReduceMotionStatusDidChangeNotification object:nil
            queue:NSOperationQueue.mainQueue usingBlock:finish];
    });
    return owners;
}

static BOOL WantsMotion(UIView *owner) {
    return owner.window && !owner.hidden && !UIAccessibilityIsReduceMotionEnabled() &&
        UIApplication.sharedApplication.applicationState != UIApplicationStateBackground;
}

static CAShapeLayer *Shape(FQXNaloiaPart part) {
    CAShapeLayer *layer = [CAShapeLayer layer];
    layer.path = FQXNaloiaPath(part);
    layer.fillRule = kCAFillRuleEvenOdd;
    layer.fillColor = UIColor.whiteColor.CGColor;
    layer.bounds = Canvas;
    CGRect artwork = CGPathGetPathBoundingBox(layer.path);
    CGPoint pivot = CGPointMake(CGRectGetMidX(artwork), CGRectGetMidY(artwork));
    layer.anchorPoint = CGPointMake(pivot.x / 108, pivot.y / 108);
    layer.position = pivot;
    return layer;
}

static UIImage *ClearImageMatching(UIImage *source) {
    if (!source || source.size.width <= 0 || source.size.height <= 0) return nil;
    UIGraphicsImageRendererFormat *format = [UIGraphicsImageRendererFormat defaultFormat];
    format.opaque = NO;
    format.scale = source.scale;
    UIGraphicsImageRenderer *renderer = [[UIGraphicsImageRenderer alloc] initWithSize:source.size format:format];
    return [renderer imageWithActions:^(__unused UIGraphicsImageRendererContext *context) {}];
}

@implementation FQXNaloiaPresentation
+ (BOOL)enabledForRole:(NSInteger)role {
    return FQXNaloiaEnabled(role);
}

- (void)mountArtwork {
    self.canvas = [CALayer layer];
    self.canvas.name = @"FanqieX.Naloia.vector";
    self.canvas.bounds = Canvas;
    switch (self.role) {
        case FQXNaloiaFavorite:
            self.parts = @[Shape(FQXNaloiaFavoriteMain), Shape(FQXNaloiaFavoriteLeft), Shape(FQXNaloiaFavoriteDot)];
            break;
        case FQXNaloiaComment:
            self.parts = @[Shape(FQXNaloiaCommentLeft), Shape(FQXNaloiaCommentRight)];
            break;
        case FQXNaloiaLike: {
            self.parts = @[Shape(FQXNaloiaLikeHeart)];
            self.parts[0].path = StaticLikePath();
            self.cutout = [CAShapeLayer layer];
            self.cutout.frame = Canvas;
            self.cutout.fillRule = kCAFillRuleEvenOdd;
            CGPathRef cutout = NewCutout(FQXNaloiaPath(FQXNaloiaLikeECG));
            self.cutout.path = cutout;
            CGPathRelease(cutout);
            break;
        }
        case FQXNaloiaShare: self.parts = @[Shape(FQXNaloiaShareAirfoil)]; break;
        case FQXNaloiaRoleCount: return;
    }
    for (CAShapeLayer *part in self.parts) [self.canvas addSublayer:part];
    [self.glyph.layer addSublayer:self.canvas];
}

- (void)replaceImageContents {
    if (self.replacingContents) return;
    self.replacingContents = YES;
    UIImageView *glyph = self.glyph;
    UIImage *image = glyph.image;
    if (image && image != self.emptyImage) {
        self.stockImage = image;
        if (!CGSizeEqualToSize(self.emptyImage.size, image.size) || self.emptyImage.scale != image.scale)
            self.emptyImage = ClearImageMatching(image);
        glyph.image = self.emptyImage;
    }
    UIImage *highlight = glyph.highlightedImage;
    if (highlight && highlight != self.emptyHighlight) {
        self.stockHighlight = highlight;
        if (!CGSizeEqualToSize(self.emptyHighlight.size, highlight.size) || self.emptyHighlight.scale != highlight.scale)
            self.emptyHighlight = ClearImageMatching(highlight);
        glyph.highlightedImage = self.emptyHighlight;
    }
    self.replacingContents = NO;
}

- (void)layoutArtwork {
    CGRect bounds = self.glyph.bounds;
    CGFloat scale = fmin(CGRectGetWidth(bounds), CGRectGetHeight(bounds)) / 108;
    // Offsets are the archived icon's alpha centroid relative to its canvas.
    static const CGPoint opticalOffsets[] = {{0, .25}, {-.7, 2.6}, {-.5, -.8}, {-5.7, 1.7}};
    CGPoint offset = opticalOffsets[self.role];
    CGPoint center = CGPointMake(CGRectGetMidX(bounds) + offset.x * scale,
                                 CGRectGetMidY(bounds) + offset.y * scale);
    CATransform3D transform = CATransform3DMakeScale(scale, scale, 1);
    if (!CGPointEqualToPoint(self.canvas.position, center)) self.canvas.position = center;
    if (!CATransform3DEqualToTransform(self.canvas.transform, transform)) self.canvas.transform = transform;
}

- (void)restoreStaticHeart {
    if (!self.cutout) return;
    self.scanGeneration++;
    [self.cutout removeAnimationForKey:ScanKey];
    [CATransaction begin];
    [CATransaction setDisableActions:YES];
    self.parts[0].mask = nil;
    self.parts[0].path = StaticLikePath();
    [CATransaction commit];
}

- (void)finishMotion {
    for (CALayer *part in self.parts) [part removeAllAnimations];
    [self restoreStaticHeart];
}

- (void)setFinalInk:(UIColor *)color duration:(CFTimeInterval)duration {
    for (CAShapeLayer *part in self.parts) {
        CGColorRef from = ((CAShapeLayer *)part.presentationLayer).fillColor ?: part.fillColor;
        if (CGColorEqualToColor(from, color.CGColor)) {
            part.fillColor = color.CGColor;
            [part removeAnimationForKey:ColorKey];
            continue;
        }
        if (duration > 0) {
            CABasicAnimation *tint = [CABasicAnimation animationWithKeyPath:@"fillColor"];
            tint.fromValue = (__bridge id)from;
            tint.toValue = (__bridge id)color.CGColor;
            tint.duration = duration;
            tint.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseInEaseOut];
            [part addAnimation:tint forKey:ColorKey];
        } else {
            [part removeAnimationForKey:ColorKey];
        }
        part.fillColor = color.CGColor;
    }
}

- (void)animateFavorite:(BOOL)selected {
    CFTimeInterval d = selected ? .52 : .36;
    CGFloat direction = selected ? 1 : -1;
    AnimateShape(self.parts[0], @[Motion(0, -1, selected ? 1.15 : .87, selected ? 1.15 : .87, 9 * direction),
        Motion(0, 1, selected ? .96 : 1.04, selected ? .96 : 1.04, -3 * direction),
        Motion(0, 0, 1, 1, 0)], @[@0, @.28, @.66, @1], d);
    AnimateShape(self.parts[1], @[Motion(0, 0, 1, 1, 0), Motion(-2, -5 * direction, selected ? 1.17 : .82,
        selected ? 1.17 : .82, -7 * direction), Motion(0, 1, 1.02, 1.02, 0), Motion(0, 0, 1, 1, 0)],
        @[@0, @.12, @.40, @.76, @1], d);
    AnimateShape(self.parts[2], @[Motion(0, 0, 1, 1, 0), Motion(2, -7 * direction, selected ? 1.23 : .72,
        selected ? 1.23 : .72, 0), Motion(0, 1, 1.02, 1.02, 0), Motion(0, 0, 1, 1, 0)],
        @[@0, @.24, @.50, @.80, @1], d);
}

- (void)animateLike:(BOOL)selected {
    CFTimeInterval duration = selected ? 1.15 : .65;
    CAShapeLayer *visible = (CAShapeLayer *)self.cutout.presentationLayer;
    CGPathRef inFlight = [self.cutout animationForKey:ScanKey] ? visible.path : NULL;
    NSMutableArray *frames = [NSMutableArray arrayWithCapacity:43];
    const NSUInteger steps = selected ? 42 : 24;
    for (NSUInteger i = 0; i <= steps; i++) {
        if (i == 0 && inFlight) {
            [frames addObject:(__bridge id)inFlight];
            continue;
        }
        CGPathRef shape = NewScanFrame((CGFloat)i / steps, selected);
        [frames addObject:CFBridgingRelease(shape)];
    }
    CAKeyframeAnimation *scan = [CAKeyframeAnimation animationWithKeyPath:@"path"];
    scan.duration = duration;
    scan.values = frames;
    scan.calculationMode = kCAAnimationLinear;
    // During motion restrict the advancing cutout to the heart. Restore the
    // exact compound SVG silhouette at rest, including its central notch.
    NSUInteger generation = ++self.scanGeneration;
    __weak FQXNaloiaPresentation *weakSelf = self;
    [CATransaction begin];
    [CATransaction setDisableActions:YES];
    [CATransaction setCompletionBlock:^{
        FQXNaloiaPresentation *state = weakSelf;
        if (state.scanGeneration == generation) [state restoreStaticHeart];
    }];
    self.parts[0].path = FQXNaloiaPath(FQXNaloiaLikeHeart);
    self.parts[0].mask = self.cutout;
    [self.cutout addAnimation:scan forKey:ScanKey];
    [CATransaction commit];
    if (selected) {
        AnimateShape(self.parts[0], @[Motion(0, 0, 1, 1, 0), Motion(0, 0, 1.09, 1.13, 0),
            Motion(0, 0, .98, .98, 0), Motion(0, 0, 1, 1, 0), Motion(0, 0, 1.045, 1.07, 0),
            Motion(0, 0, .99, .99, 0), Motion(0, 0, 1, 1, 0)],
            @[@0, @.22, @.28, @.37, @.58, @.70, @.83, @1], duration);
    } else {
        AnimateShape(self.parts[0], @[Motion(0, 0, 1, 1, 0), Motion(0, 0, .94, .91, 0),
            Motion(0, 0, 1.022, 1.018, 0), Motion(0, 0, 1, 1, 0)],
            @[@0, @.27, @.50, @.76, @1], duration);
    }
}

- (void)animatePanel:(BOOL)opening {
    if (self.role == FQXNaloiaComment) {
        CFTimeInterval d = opening ? .40 : .30;
        CGFloat y = opening ? -7 : 4;
        CGFloat sy = opening ? 1.12 : .88;
        for (NSUInteger i = 0; i < self.parts.count; i++) {
            CGFloat offset = i ? (.048 / d) : .018;
            AnimateShape(self.parts[i], @[Motion(0, 0, 1, 1, 0), Motion(0, y, 1.035, sy, 0),
                Motion(0, -y * .3, .98, opening ? .97 : 1.04, 0), Motion(0, 0, 1, 1, 0)],
                @[@0, @(offset), @(.26 + offset), @(.58 + offset), @1], d);
        }
    } else if (self.role == FQXNaloiaShare) {
        if (opening) {
            AnimateShape(self.parts[0], @[Motion(-4, 3, .93, .92, -7), Motion(8, -8, 1.08, 1.04, 9),
                Motion(-1, 2, .98, .99, -2), Motion(0, 0, 1, 1, 0)], @[@0, @.18, @.46, @.74, @1], .45);
        } else {
            AnimateShape(self.parts[0], @[Motion(-6, 5, .93, .95, -8), Motion(2, -2, 1.04, 1.02, 3),
                Motion(0, 0, 1, 1, 0)], @[@0, @.31, @.71, @1], .35);
        }
    }
}

+ (void)updateOwner:(UIView *)owner glyph:(UIImageView *)glyph role:(NSInteger)role
          identity:(id)identity selected:(BOOL)selected animate:(BOOL)animate {
    if (!owner.window || !glyph.superview || !FQXNaloiaEnabled(role) || CGRectIsEmpty(glyph.bounds)) {
        [self detachOwner:owner];
        return;
    }
    FQXNaloiaPresentation *state = objc_getAssociatedObject(owner, &PresentationKey);
    BOOL newGlyph = !state || state.glyph != glyph || state.role != role;
    [CATransaction begin];
    [CATransaction setDisableActions:YES];
    if (newGlyph) {
        [self detachOwner:owner];
        state = [FQXNaloiaPresentation new];
        state.glyph = glyph;
        state.role = role;
        [state mountArtwork];
        objc_setAssociatedObject(owner, &PresentationKey, state, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
        objc_setAssociatedObject(glyph, &GlyphPresentationKey, state, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
        [Owners() addObject:owner];
    }
    BOOL reuse = newGlyph || (state.identity != identity && ![state.identity isEqual:identity]);
    BOOL changed = state.selected != selected;
    if (reuse) {
        [state finishMotion];
        state.panelOpen = NO;
        state.identity = identity;
    }
    [state replaceImageContents];
    [state layoutArtwork];
    if (reuse || changed) {
        BOOL canAnimate = !reuse && changed && animate && WantsMotion(owner) && !glyph.hidden;
        [state setFinalInk:Ink(role, selected) duration:canAnimate ? (role == FQXNaloiaLike ? .24 : .20) : 0];
        if (canAnimate && role == FQXNaloiaFavorite) [state animateFavorite:selected];
        else if (canAnimate && role == FQXNaloiaLike) [state animateLike:selected];
        else [state finishMotion];
        state.selected = selected;
    }
    [CATransaction commit];
}

+ (void)detachOwner:(UIView *)owner {
    FQXNaloiaPresentation *state = objc_getAssociatedObject(owner, &PresentationKey);
    if (!state) return;
    [state finishMotion];
    [state.canvas removeFromSuperlayer];
    UIImageView *glyph = state.glyph;
    if (objc_getAssociatedObject(glyph, &GlyphPresentationKey) == state)
        objc_setAssociatedObject(glyph, &GlyphPresentationKey, nil, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
    if (glyph.image == state.emptyImage) glyph.image = state.stockImage;
    if (glyph.highlightedImage == state.emptyHighlight) glyph.highlightedImage = state.stockHighlight;
    objc_setAssociatedObject(owner, &PresentationKey, nil, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

+ (void)pressOwner:(UIView *)owner {
    FQXNaloiaPresentation *state = objc_getAssociatedObject(owner, &PresentationKey);
    if (!state || !WantsMotion(owner) || state.glyph.hidden) return;
    CAShapeLayer *part = state.parts.firstObject;
    AnimateShape(part, @[Motion(0, 1, .95, .95, 0), Motion(0, 0, 1, 1, 0)],
        @[@0, @.36, @1], .15);
}

+ (void)imageDidChange:(UIImageView *)glyph {
    FQXNaloiaPresentation *state = objc_getAssociatedObject(glyph, &GlyphPresentationKey);
    [state replaceImageContents];
}
@end

static void PanelChanged(UIView *owner, FQXNaloiaRole role, BOOL opening) {
    FQXNaloiaPresentation *state = objc_getAssociatedObject(owner, &PresentationKey);
    if (!state || state.role != role || state.panelOpen == opening) return;
    state.panelOpen = opening;
    if (WantsMotion(owner) && !state.glyph.hidden) [state animatePanel:opening];
}

void FQXNaloiaPanelDidOpen(UIView *owner, FQXNaloiaRole role) {
    PanelChanged(owner, role, YES);
}

void FQXNaloiaPanelDidClose(UIView *owner, FQXNaloiaRole role) {
    PanelChanged(owner, role, NO);
}
