#ifndef FQX_LAYOUT_AND_SHEET_POLICY_H
#define FQX_LAYOUT_AND_SHEET_POLICY_H

#include <math.h>
#include <stddef.h>
#include "FQXBlurControl.h"

enum { FQXMaxCompactStripItems = 24 };

typedef struct {
    double x;
    double y;
    double width;
    double height;
    int hidden;
} FQXCompactStripItem;

typedef struct {
    int valid;
    size_t count;
    size_t visibleCount;
    size_t hiddenCount;
    double contentWidth;
    int allowStripScroll;
    int resetContentOffset;
    FQXCompactStripItem items[FQXMaxCompactStripItems];
} FQXCompactStripPlan;

typedef struct {
    int allowNativeScroll;
    int allowVisibleStepPan;
    int redirectIndex;
    size_t visibleCount;
    size_t hiddenCount;
} FQXVisiblePagerPolicy;

static inline double FQXDramaCapsuleOuterHorizontalPad(double scale) {
    return round(fmax(7.0, fmin(16.0, 11.0 * scale)) * 2.0) / 2.0;
}

static inline double FQXDramaCapsulePillInsetY(double scale) {
    return (scale < 0.85) ? 2.5 : 3.0;
}

static inline double FQXDramaCapsulePillExtraWidth(double scale) {
    double padX = FQXDramaCapsuleOuterHorizontalPad(scale);
    double insetY = FQXDramaCapsulePillInsetY(scale);
    return fmax(6.0, (padX - insetY) * 2.0);
}

static inline double FQXDramaCapsuleCategoriesShiftY(double outerMinYInHeader,
                                                     double outerMaxYInHeader,
                                                     double headerMinY,
                                                     double headerMaxY,
                                                     double safeTopInHeader,
                                                     int scalePct) {
    if (!isfinite(outerMinYInHeader) || !isfinite(outerMaxYInHeader)) return 0.0;
    double minAllowedY = fmax(headerMinY + 1.0, safeTopInHeader + 1.0);
    double shift = 0.0;
    if (scalePct <= 100) {
        double maxAllowedY = headerMaxY - 1.0;
        if (outerMaxYInHeader > maxAllowedY + 0.5) {
            shift = maxAllowedY - outerMaxYInHeader;
        }
    }
    if (outerMinYInHeader + shift < minAllowedY - 0.5) {
        shift = minAllowedY - outerMinYInHeader;
    }
    return fabs(shift) > 0.5 ? (round(shift * 2.0) / 2.0) : 0.0;
}

static inline int FQXResolvePlaybackOptionsUserBlur(int followDock,
                                                    int optionBlurPercent,
                                                    int dockBlurPercent) {
    int opt = FQXBlurPercent(optionBlurPercent);
    if (!followDock) return opt;
    int dock = FQXBlurPercent(dockBlurPercent);
    return opt > dock ? opt : dock;
}

static inline int FQXSheetUsesHardwareBackdropFilter(int backdropFilterAvailable,
                                                     int reduceTransparency) {
    return (backdropFilterAvailable && !reduceTransparency) ? 1 : 0;
}

static inline int FQXSheetBlurAttachesInsideGlassContent(int gaussian) {
    return gaussian ? 0 : 1;
}

static inline FQXCompactStripPlan FQXPlanCompactHorizontalStrip(const FQXCompactStripItem *raw,
                                                                const int *visibleFlags,
                                                                size_t count,
                                                                double fallbackGap,
                                                                double stripBoundsWidth,
                                                                double currentOffsetX) {
    FQXCompactStripPlan plan = {0};
    if (!raw || !visibleFlags || count == 0 || count > FQXMaxCompactStripItems) return plan;

    double gap = -1.0;
    for (size_t i = 0; i + 1 < count; ++i) {
        if (raw[i].width > 4.0 && raw[i + 1].width > 4.0) {
            double cand = raw[i + 1].x - (raw[i].x + raw[i].width);
            if (cand >= 4.0 && cand <= 36.0) {
                gap = cand;
                break;
            }
        }
    }
    if (gap < 0.0) gap = (fallbackGap >= 2.0 && fallbackGap <= 36.0) ? fallbackGap : 8.0;

    double lead = (isfinite(raw[0].x) && raw[0].x >= 0.0 && raw[0].x <= 24.0) ? raw[0].x : 0.0;
    double cursor = lead;
    int placedAny = 0;

    for (size_t i = 0; i < count; ++i) {
        int show = visibleFlags[i] != 0 && raw[i].width > 2.0;
        if (show) {
            if (placedAny) cursor += gap;
            double itemX = round(cursor * 2.0) / 2.0;
            double itemW = round(raw[i].width * 2.0) / 2.0;
            plan.items[i].x = itemX;
            plan.items[i].y = raw[i].y;
            plan.items[i].width = itemW;
            plan.items[i].height = raw[i].height;
            plan.items[i].hidden = 0;
            cursor = itemX + itemW;
            placedAny = 1;
            plan.visibleCount++;
        } else {
            plan.items[i].x = cursor;
            plan.items[i].y = raw[i].y;
            plan.items[i].width = 0.1;
            plan.items[i].height = raw[i].height > 1.0 ? raw[i].height : 1.0;
            plan.items[i].hidden = 1;
            plan.hiddenCount++;
        }
    }

    plan.valid = 1;
    plan.count = count;
    plan.contentWidth = plan.visibleCount > 0 ? fmax(1.0, cursor + lead) : 1.0;
    plan.allowStripScroll = (stripBoundsWidth > 20.0 && plan.contentWidth > stripBoundsWidth + 2.0) ? 1 : 0;
    double maxOffset = plan.allowStripScroll ? fmax(0.0, plan.contentWidth - stripBoundsWidth) : 0.0;
    plan.resetContentOffset = (!isfinite(currentOffsetX) ||
                               currentOffsetX < -0.5 ||
                               currentOffsetX > maxOffset + 0.5 ||
                               (!plan.allowStripScroll && fabs(currentOffsetX) > 0.5)) ? 1 : 0;
    return plan;
}

static inline FQXVisiblePagerPolicy FQXEvaluateVisiblePagerPolicy(size_t totalCount,
                                                                  unsigned int visibleMask,
                                                                  int masterVisible,
                                                                  int currentIndex) {
    FQXVisiblePagerPolicy policy = {0, 0, -1, 0, 0};
    if (totalCount == 0 || totalCount > FQXMaxCompactStripItems) return policy;

    int firstVisible = -1;
    for (size_t i = 0; i < totalCount; ++i) {
        if ((visibleMask >> i) & 1u) {
            if (firstVisible < 0) firstVisible = (int)i;
            policy.visibleCount++;
        } else {
            policy.hiddenCount++;
        }
    }

    policy.allowNativeScroll = (masterVisible && policy.visibleCount >= 2 && policy.hiddenCount == 0) ? 1 : 0;
    policy.allowVisibleStepPan = (masterVisible && policy.visibleCount >= 2 && policy.hiddenCount > 0) ? 1 : 0;

    if (masterVisible && firstVisible >= 0 && currentIndex >= 0 && (size_t)currentIndex < totalCount) {
        if (!((visibleMask >> (unsigned int)currentIndex) & 1u)) {
            policy.redirectIndex = firstVisible;
        }
    }
    return policy;
}

static inline int FQXStepVisiblePagerIndex(size_t totalCount,
                                           unsigned int visibleMask,
                                           int currentIndex,
                                           int step) {
    if (totalCount < 2 || totalCount > FQXMaxCompactStripItems || step == 0 || currentIndex < 0) return -1;

    int visible[FQXMaxCompactStripItems];
    size_t visCount = 0;
    int curPos = -1;
    for (size_t i = 0; i < totalCount; ++i) {
        if ((visibleMask >> i) & 1u) {
            if ((int)i == currentIndex) curPos = (int)visCount;
            visible[visCount++] = (int)i;
        }
    }
    if (visCount < 2) return -1;

    if (curPos >= 0) {
        int nextPos = curPos + (step > 0 ? 1 : -1);
        if (nextPos >= 0 && (size_t)nextPos < visCount) return visible[nextPos];
        return -1;
    }

    if (step > 0) {
        for (size_t i = 0; i < visCount; ++i) {
            if (visible[i] > currentIndex) return visible[i];
        }
    } else {
        for (size_t i = visCount; i > 0; --i) {
            if (visible[i - 1] < currentIndex) return visible[i - 1];
        }
    }
    return -1;
}

#endif
