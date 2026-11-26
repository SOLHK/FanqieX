#import <CoreGraphics/CoreGraphics.h>
#import <dispatch/dispatch.h>

typedef enum {
    FQXNaloiaFavoriteMain,
    FQXNaloiaFavoriteLeft,
    FQXNaloiaFavoriteDot,
    FQXNaloiaCommentLeft,
    FQXNaloiaCommentRight,
    FQXNaloiaLikeHeart,
    FQXNaloiaLikeECG,
    FQXNaloiaShareAirfoil,
    FQXNaloiaPartCount,
} FQXNaloiaPart;

static CGPathRef FQXNaloiaCreatePath(FQXNaloiaPart part) CF_RETURNS_RETAINED;
static CGPathRef FQXNaloiaCreatePath(FQXNaloiaPart part) {
    // Keep the archived SVG operands in source coordinates. The viewBox and
    // the original group transform map them into the common 108-point canvas.
    CGFloat groupScale = part <= FQXNaloiaFavoriteDot ? 1.15 : 1.0;
    CGFloat scale = 108.0 / 88.0 * groupScale;
    CGFloat offset = 54.0 - 32.0 * scale;
    CGAffineTransform sourceToCanvas = CGAffineTransformMake(scale, 0, 0, scale, offset, offset);
    CGMutablePathRef path = CGPathCreateMutable();
    switch (part) {
        case FQXNaloiaFavoriteMain:
            CGPathMoveToPoint(path, &sourceToCanvas, 36, 12);
            CGPathAddCurveToPoint(path, &sourceToCanvas, 39, 12, 39, 18, 41, 23);
            CGPathAddQuadCurveToPoint(path, &sourceToCanvas, 45, 32, 56, 35);
            CGPathAddQuadCurveToPoint(path, &sourceToCanvas, 62, 37, 56, 40);
            CGPathAddQuadCurveToPoint(path, &sourceToCanvas, 45, 43, 41, 52);
            CGPathAddCurveToPoint(path, &sourceToCanvas, 39, 58, 39, 63, 36, 63);
            CGPathAddCurveToPoint(path, &sourceToCanvas, 33, 63, 33, 57, 31, 52);
            CGPathAddQuadCurveToPoint(path, &sourceToCanvas, 27, 43, 16, 40);
            CGPathAddQuadCurveToPoint(path, &sourceToCanvas, 10, 37, 16, 35);
            CGPathAddQuadCurveToPoint(path, &sourceToCanvas, 27, 32, 31, 23);
            CGPathAddCurveToPoint(path, &sourceToCanvas, 33, 18, 33, 12, 36, 12);
            CGPathCloseSubpath(path);
            break;
        case FQXNaloiaFavoriteLeft:
            CGPathMoveToPoint(path, &sourceToCanvas, 13, 2);
            CGPathAddQuadCurveToPoint(path, &sourceToCanvas, 15, 10, 23, 12);
            CGPathAddQuadCurveToPoint(path, &sourceToCanvas, 25, 13, 23, 14);
            CGPathAddQuadCurveToPoint(path, &sourceToCanvas, 15, 16, 13, 24);
            CGPathAddQuadCurveToPoint(path, &sourceToCanvas, 12, 26, 11, 24);
            CGPathAddQuadCurveToPoint(path, &sourceToCanvas, 9, 16, 1, 14);
            CGPathAddQuadCurveToPoint(path, &sourceToCanvas, -1, 13, 1, 12);
            CGPathAddQuadCurveToPoint(path, &sourceToCanvas, 9, 10, 11, 2);
            CGPathAddQuadCurveToPoint(path, &sourceToCanvas, 12, 0, 13, 2);
            CGPathCloseSubpath(path);
            break;
        case FQXNaloiaFavoriteDot:
            CGPathAddEllipseInRect(path, &sourceToCanvas, CGRectMake(48.5, 5.5, 7, 7));
            break;
        case FQXNaloiaCommentLeft:
            CGPathMoveToPoint(path, &sourceToCanvas, 21, 13);
            CGPathAddCurveToPoint(path, &sourceToCanvas, 12, 13, 8, 20, 8, 28);
            CGPathAddCurveToPoint(path, &sourceToCanvas, 8, 35, 13, 40, 21, 39);
            CGPathAddCurveToPoint(path, &sourceToCanvas, 20, 44, 16, 48, 12, 51);
            CGPathAddQuadCurveToPoint(path, &sourceToCanvas, 10, 54, 15, 53);
            CGPathAddCurveToPoint(path, &sourceToCanvas, 28, 49, 31, 36, 31, 25);
            CGPathAddCurveToPoint(path, &sourceToCanvas, 31, 17, 27, 13, 21, 13);
            CGPathCloseSubpath(path);
            break;
        case FQXNaloiaCommentRight:
            CGPathMoveToPoint(path, &sourceToCanvas, 46, 13);
            CGPathAddCurveToPoint(path, &sourceToCanvas, 37, 13, 33, 20, 33, 28);
            CGPathAddCurveToPoint(path, &sourceToCanvas, 33, 35, 38, 40, 46, 39);
            CGPathAddCurveToPoint(path, &sourceToCanvas, 45, 44, 41, 48, 37, 51);
            CGPathAddQuadCurveToPoint(path, &sourceToCanvas, 35, 54, 40, 53);
            CGPathAddCurveToPoint(path, &sourceToCanvas, 53, 49, 56, 36, 56, 25);
            CGPathAddCurveToPoint(path, &sourceToCanvas, 56, 17, 52, 13, 46, 13);
            CGPathCloseSubpath(path);
            break;
        case FQXNaloiaLikeHeart:
            CGPathMoveToPoint(path, &sourceToCanvas, 10, 18);
            CGPathAddCurveToPoint(path, &sourceToCanvas, 19, 9, 29, 18, 32, 25);
            CGPathAddCurveToPoint(path, &sourceToCanvas, 35, 18, 45, 9, 54, 18);
            CGPathAddCurveToPoint(path, &sourceToCanvas, 66, 32, 43, 50, 32, 57);
            CGPathAddCurveToPoint(path, &sourceToCanvas, 21, 50, -2, 32, 10, 18);
            CGPathCloseSubpath(path);
            break;
        case FQXNaloiaLikeECG:
            CGPathMoveToPoint(path, &sourceToCanvas, 15, 29);
            CGPathAddQuadCurveToPoint(path, &sourceToCanvas, 12, 29, 12, 33);
            CGPathAddQuadCurveToPoint(path, &sourceToCanvas, 12, 37, 16, 37);
            CGPathAddLineToPoint(path, &sourceToCanvas, 24, 37);
            CGPathAddLineToPoint(path, &sourceToCanvas, 30, 29);
            CGPathAddLineToPoint(path, &sourceToCanvas, 36, 44);
            CGPathAddLineToPoint(path, &sourceToCanvas, 43, 34);
            CGPathAddLineToPoint(path, &sourceToCanvas, 49, 34);
            CGPathAddQuadCurveToPoint(path, &sourceToCanvas, 53, 34, 53, 30);
            CGPathAddLineToPoint(path, &sourceToCanvas, 39, 30);
            CGPathAddLineToPoint(path, &sourceToCanvas, 37, 33);
            CGPathAddLineToPoint(path, &sourceToCanvas, 32, 21);
            CGPathAddQuadCurveToPoint(path, &sourceToCanvas, 30, 18, 27, 23);
            CGPathAddLineToPoint(path, &sourceToCanvas, 21, 29);
            CGPathCloseSubpath(path);
            break;
        case FQXNaloiaShareAirfoil:
            CGPathMoveToPoint(path, &sourceToCanvas, 8, 26);
            CGPathAddQuadCurveToPoint(path, &sourceToCanvas, 5, 22, 11, 23);
            CGPathAddCurveToPoint(path, &sourceToCanvas, 28, 25, 40, 17, 53, 9);
            CGPathAddQuadCurveToPoint(path, &sourceToCanvas, 59, 5, 57, 13);
            CGPathAddLineToPoint(path, &sourceToCanvas, 48, 46);
            CGPathAddQuadCurveToPoint(path, &sourceToCanvas, 46, 53, 41, 48);
            CGPathAddLineToPoint(path, &sourceToCanvas, 32, 37);
            CGPathAddLineToPoint(path, &sourceToCanvas, 19, 49);
            CGPathAddQuadCurveToPoint(path, &sourceToCanvas, 14, 53, 16, 46);
            CGPathAddLineToPoint(path, &sourceToCanvas, 23, 34);
            CGPathCloseSubpath(path);
            CGPathMoveToPoint(path, &sourceToCanvas, 25, 28);
            CGPathAddQuadCurveToPoint(path, &sourceToCanvas, 22, 30, 25, 32);
            CGPathAddQuadCurveToPoint(path, &sourceToCanvas, 26, 33, 28, 32);
            CGPathAddLineToPoint(path, &sourceToCanvas, 48, 20);
            CGPathAddQuadCurveToPoint(path, &sourceToCanvas, 51, 18, 49, 16);
            CGPathAddQuadCurveToPoint(path, &sourceToCanvas, 48, 15, 46, 16);
            CGPathCloseSubpath(path);
            break;
        case FQXNaloiaPartCount:
            break;
    }
    CGPathRef result = CGPathCreateCopy(path);
    CGPathRelease(path);
    return result;
}

static CGPathRef FQXNaloiaPath(FQXNaloiaPart part) {
    static CGPathRef paths[FQXNaloiaPartCount];
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        for (FQXNaloiaPart index = FQXNaloiaFavoriteMain; index < FQXNaloiaPartCount; ++index)
            paths[index] = FQXNaloiaCreatePath(index);
    });
    return paths[part];
}
