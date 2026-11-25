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
    return round(fmax(8.0, fmin(16.0, 12.0 * scale)) * 2.0) / 2.0;
}

static inline double FQXDramaCompactedLeadingPad(double scale) {
    return ceil(FQXDramaCapsuleOuterHorizontalPad(scale)) + 2.0;
}

static inline int FQXShouldSuppressDramaScrollMask(int fitsInHeader, int glassEnabled) {
    return (glassEnabled && fitsInHeader) ? 1 : 0;
}

static inline double FQXResolveDramaItemAnchorX(double cellMinX,
                                                double cellWidth,
                                                int hasLabelCenter,
                                                double labelCenterX) {
    double fallback = cellMinX + cellWidth * 0.5;
    if (hasLabelCenter && isfinite(labelCenterX) && fabs(labelCenterX - fallback) <= 6.0) {
        return labelCenterX;
    }
    return fallback;
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

static inline int FQXShouldHideHistoryEdgeMask(int isRightMask,
                                               int showFilter,
                                               int showEdit,
                                               int allowStripScroll,
                                               int anyLeftVisible) {
    if (!anyLeftVisible || !allowStripScroll) return 1;
    if (isRightMask && !showFilter && !showEdit) return 1;
    return 0;
}

static inline int FQXShouldUnlockShortVideoDanmaku(int unlockOptionEnabled,
                                                   int isInListenMode,
                                                   int isTeenagerMode) {
    return (unlockOptionEnabled && !isInListenMode && !isTeenagerMode) ? 1 : 0;
}

static inline int FQXShouldRunShelfTabTapRecovery(int reflowApplied,
                                                  double cellX,
                                                  double layoutX,
                                                  double cellWidth,
                                                  double layoutWidth) {
    if (reflowApplied) return 1;
    if (!isfinite(cellX) || !isfinite(layoutX) || !isfinite(cellWidth) || !isfinite(layoutWidth)) return 0;
    if (fabs(cellX - layoutX) > 1.0 || fabs(cellWidth - layoutWidth) > 1.0) return 1;
    return 0;
}

static inline int FQXShouldCaptureHistorySavedFrame(double width, double height) {
    return (isfinite(width) && isfinite(height) && width >= 40.0 && height >= 16.0) ? 1 : 0;
}

static inline double FQXResolveHistoryExpandedWidth(double baseWidth,
                                                    double currentWidth,
                                                    double desiredWidth) {
    if (!isfinite(baseWidth) || !isfinite(currentWidth) || !isfinite(desiredWidth)) return 0.0;
    if (baseWidth < 40.0 || desiredWidth <= baseWidth + 2.0) return 0.0;
    double target = round(desiredWidth);
    if (fabs(currentWidth - target) <= 0.5) return 0.0;
    return target;
}

static inline int FQXShouldRunHistoryFullSync(int inFlight,
                                              int isViewLoaded,
                                              double vcWidth,
                                              double vcHeight,
                                              int isReentrantSublayoutHook) {
    if (inFlight || !isViewLoaded || isReentrantSublayoutHook) return 0;
    if (!isfinite(vcWidth) || !isfinite(vcHeight) || vcWidth < 180.0 || vcHeight < 180.0) return 0;
    return 1;
}

static inline int FQXShouldRunDramaCapsuleFullSync(int isMainThread,
                                                   int inFlight,
                                                   int hasWindow,
                                                   int glassEnabled,
                                                   int isScrollMaskKVO) {
    if (!isMainThread || inFlight || isScrollMaskKVO) return 0;
    if (glassEnabled && !hasWindow) return 0;
    return 1;
}

static inline int FQXShouldCommitDramaCompactVisMask(int resolvedHeaderOwner,
                                                     unsigned int prevMask,
                                                     unsigned int nextMask,
                                                     int hasPrevMask) {
    if (!resolvedHeaderOwner && hasPrevMask) return 0;
    if (!hasPrevMask) return 1;
    return (prevMask != nextMask) ? 1 : 0;
}

static inline int FQXShouldSuppressDockFeedbackGenerator(int bottomHapticsEnabled,
                                                         int belongsToDockView,
                                                         int hasSpecificNonDockView,
                                                         int dockTouchActive) {
    if (bottomHapticsEnabled) return 0;
    if (belongsToDockView) return 1;
    if (!hasSpecificNonDockView && dockTouchActive) return 1;
    return 0;
}

static inline void FQXComputeMineFoldFirstPageBandY(double cardMinY,
                                                    double cardMaxY,
                                                    int hasDots,
                                                    double dotsMinY,
                                                    int hasAttachment,
                                                    int hasAttachRect,
                                                    double attachMinY,
                                                    double attachmentHeight,
                                                    double itemHeight,
                                                    double radius,
                                                    double *outBandMinY,
                                                    double *outBandHeight) {
    if (!outBandMinY || !outBandHeight) return;
    *outBandMinY = cardMinY;
    *outBandHeight = 0.0;
    if (!isfinite(cardMinY) || !isfinite(cardMaxY) || cardMaxY <= cardMinY || !isfinite(radius) || radius <= 0.0) {
        return;
    }
    if (!hasAttachment) {
        double centerY = (cardMinY + cardMaxY) * 0.5;
        if (hasDots && isfinite(dotsMinY)) {
            centerY = fmin(centerY, dotsMinY - radius - 2.0);
        }
        if (centerY >= cardMinY + radius) {
            *outBandMinY = centerY - radius;
            *outBandHeight = radius * 2.0;
        }
        return;
    }
    double ceilingY = cardMaxY;
    if (hasDots && isfinite(dotsMinY) && dotsMinY > cardMinY) {
        ceilingY = fmin(ceilingY, dotsMinY);
    }
    if (hasAttachRect && isfinite(attachMinY) && attachMinY > cardMinY + 24.0) {
        ceilingY = fmin(ceilingY, attachMinY);
    }
    if (isfinite(attachmentHeight) && attachmentHeight > 0.5) {
        if (isfinite(itemHeight) && itemHeight > 20.0) {
            ceilingY = fmin(ceilingY, itemHeight + 6.0);
        } else if (!hasAttachRect) {
            double estBase = (hasDots && isfinite(dotsMinY) && dotsMinY > cardMinY) ? fmin(cardMaxY, dotsMinY) : cardMaxY;
            double estCeiling = estBase - attachmentHeight - 6.0;
            if (estCeiling > cardMinY + 24.0) {
                ceilingY = fmin(ceilingY, estCeiling);
            }
        }
    }
    double zoneTop = fmax(cardMinY, 0.0);
    double minNeeded = (isfinite(itemHeight) && itemHeight > 20.0) ? itemHeight : 32.0;
    double zoneBottom = ceilingY - 2.0;
    if (zoneBottom - zoneTop < minNeeded) {
        zoneBottom = ceilingY;
    }
    if (zoneBottom - zoneTop >= minNeeded) {
        *outBandMinY = zoneTop;
        *outBandHeight = zoneBottom - zoneTop;
    } else {
        *outBandMinY = zoneTop;
        *outBandHeight = 0.0;
    }
}

static inline int FQXShouldHideShelfFavoritesExtraCell(int showHistoryCard,
                                                       long long addCellStyle) {
    /* Verified in SSVideoCollectEmptyCell (-updateWithCellStyle:uiConfigParams:) and
       SSVideoCollectViewModel (-addCellStyleString):
       style 0 = bookshelf_more_history ("查看短剧浏览历史");
       style 1 = video_goto_bookstore ("前往首页"). */
    return (!showHistoryCard && addCellStyle == 0) ? 1 : 0;
}

static inline int FQXShouldShowDramaDanmakuButton(int showDanmakuButton,
                                                  int hostWantsDanmaku) {
    return (showDanmakuButton && hostWantsDanmaku) ? 1 : 0;
}

static inline int FQXShouldShowDramaAuthorDeclaration(int showAuthorDeclaration,
                                                      int hostWantsAiUsage) {
    return (showAuthorDeclaration && hostWantsAiUsage) ? 1 : 0;
}

static inline unsigned long long FQXResolveDramaAboveProgressDistributionType(int showOriginalNovel,
                                                                              unsigned long long hostDistributionType) {
    /* Verified in SSShortVideoAboveProgressViewManager -decideDistributionType & -distributionViewDidClick:
       distributionType == 3 is exclusively the Original Book ("原著《...》") bar above the progress bar.
       Non-book bars (1 = series/观看完整漫剧, 2 = recommend/game, 4 = playlist, 6/14 = follow update, 9 = same kind)
       remain unaffected. */
    if (!showOriginalNovel && hostDistributionType == 3ULL) {
        return 0ULL;
    }
    return hostDistributionType;
}

static inline int FQXShouldShowDramaOriginalNovelEntry(int showOriginalNovel,
                                                       int hostWantsEntry) {
    return (showOriginalNovel && hostWantsEntry) ? 1 : 0;
}

#endif
