#include "../native/FQXLayoutAndSheetPolicy.h"
#include <assert.h>
#include <math.h>
#include <stdio.h>

static void test_drama_top_capsule_alignment(void) {
    /* 1. Concentric pill geometry inside outer capsule across scales 70%..130% */
    for (int scalePct = 70; scalePct <= 130; scalePct += 5) {
        double scale = (double)scalePct / 100.0;
        double padX = FQXDramaCapsuleOuterHorizontalPad(scale);
        double insetY = FQXDramaCapsulePillInsetY(scale);
        double extraW = FQXDramaCapsulePillExtraWidth(scale);
        /* First visible item at x=10, width=32 -> outer left = 10 - padX.
           Item center in outer = padX + 16. Pill width = 32 + extraW.
           Pill left in outer = (padX + 16) - (16 + extraW * 0.5) = padX - extraW * 0.5.
           Concentric capsule requires pill left inset == pill top/bottom inset (insetY). */
        double leftInset = padX - extraW * 0.5;
        assert(fabs(leftInset - insetY) < 1e-6);

        /* 1b. Cross-device non-negative capsule origin: compacted leadPad always exceeds padX by >= 2pt
               so outer.frame.origin.x inside tabContainer is never < 0 (preventing left cap clipping). */
        double leadPad = FQXDramaCompactedLeadingPad(scale);
        assert(leadPad - padX >= 2.0 - 1e-6);
    }

    /* 1c. Scroll-fade mask (SSVideoFeedTabScrollMaskLayer) detaches whenever compact tabs fit in header */
    assert(FQXShouldSuppressDramaScrollMask(1, 1) == 1);
    assert(FQXShouldSuppressDramaScrollMask(0, 1) == 0);
    assert(FQXShouldSuppressDramaScrollMask(1, 0) == 0);

    /* 1d. Realized glyph center anchor tracks asymmetric titleLabel center within cell bounds */
    assert(fabs(FQXResolveDramaItemAnchorX(14.0, 36.0, 1, 33.5) - 33.5) < 1e-6);
    assert(fabs(FQXResolveDramaItemAnchorX(14.0, 36.0, 0, 0.0) - 32.0) < 1e-6);
    assert(fabs(FQXResolveDramaItemAnchorX(14.0, 36.0, 1, 99.0) - 32.0) < 1e-6);

    /* 2. iPhone 16 Pro vertical safe-area clamp shifts categories container (keeping text & capsule together) */
    double shiftY = FQXDramaCapsuleCategoriesShiftY(
        60.38, /* outerMinYInHeader */
        98.38, /* outerMaxYInHeader */
        54.0,  /* headerMinY */
        98.0,  /* headerMaxY */
        62.0,  /* safeTopInHeader */
        100    /* scalePct */
    );
    /* minAllowedY = max(55.0, 63.0) = 63.0 -> categories shifts down by +2.62pt (rounded to 0.5pt -> +2.5 or +3.0) */
    assert(shiftY >= 2.5 && shiftY <= 3.0);
    assert(60.38 + shiftY >= 62.5);
}

static void test_sheet_blur_policy(void) {
    /* 1. Follow Dock inherits DockBlur when PlaybackOptionsBlur is 0, while explicit mode stays independent */
    assert(FQXResolvePlaybackOptionsUserBlur(1, 0, 65) == 65);
    assert(FQXResolvePlaybackOptionsUserBlur(1, 80, 30) == 80);
    assert(FQXResolvePlaybackOptionsUserBlur(0, 0, 65) == 0);
    assert(FQXResolvePlaybackOptionsUserBlur(0, 45, 0) == 45);

    /* 2. Hardware CABackdropLayer filter enabled on iOS 26/27 & attached inside glass contentView */
    assert(FQXSheetUsesHardwareBackdropFilter(1, 0) == 1);
    assert(FQXSheetUsesHardwareBackdropFilter(1, 1) == 0);
    assert(FQXSheetUsesHardwareBackdropFilter(0, 0) == 0);
    assert(FQXSheetBlurAttachesInsideGlassContent(0) == 1);
    assert(FQXSheetBlurAttachesInsideGlassContent(1) == 0);
}

static void test_shelf_and_history_compaction_and_pager(void) {
    /* Reproduce Screenshot 3: 7 History pills [全部, 阅读, 听书, 短剧, 短篇, 漫画, 话题],
       previously scrolled to currentOffsetX = 140pt, then hidden down to only 全部(0) and 短剧(3). */
    FQXCompactStripItem raw[7] = {
        {  0.0, 2.0, 52.0, 28.0, 0 }, /* 0: 全部 */
        { 60.0, 2.0, 52.0, 28.0, 0 }, /* 1: 阅读 */
        {120.0, 2.0, 52.0, 28.0, 0 }, /* 2: 听书 */
        {180.0, 2.0, 52.0, 28.0, 0 }, /* 3: 短剧 */
        {240.0, 2.0, 52.0, 28.0, 0 }, /* 4: 短篇 */
        {300.0, 2.0, 52.0, 28.0, 0 }, /* 5: 漫画 */
        {360.0, 2.0, 52.0, 28.0, 0 }, /* 6: 话题 */
    };
    int vis[7] = { 1, 0, 0, 1, 0, 0, 0 };
    FQXCompactStripPlan plan = FQXPlanCompactHorizontalStrip(raw, vis, 7, 8.0, 240.0, 140.0);
    assert(plan.valid == 1);
    assert(plan.visibleCount == 2 && plan.hiddenCount == 5);
    /* 全部 starts cleanly at x = 0.0 (never shifted to 140pt!), 短剧 at x = 60.0 (fully inside 240pt!) */
    assert(fabs(plan.items[0].x - 0.0) < 1e-6 && !plan.items[0].hidden);
    assert(fabs(plan.items[3].x - 60.0) < 1e-6 && !plan.items[3].hidden);
    assert(plan.items[1].hidden && plan.items[2].hidden && plan.items[4].hidden);
    assert(plan.contentWidth <= 120.0);
    assert(plan.allowStripScroll == 0);
    assert(plan.resetContentOffset == 1);

    /* Visible pager policy for [0, 3] out of 7 */
    unsigned int mask = (1u << 0) | (1u << 3);
    FQXVisiblePagerPolicy pol = FQXEvaluateVisiblePagerPolicy(7, mask, 1, 2);
    assert(pol.allowNativeScroll == 0);
    assert(pol.allowVisibleStepPan == 1);
    assert(pol.redirectIndex == 0); /* Redirects off hidden index 2 to 0 */

    /* Stepping jumps directly 0 <-> 3 and blocks overshooting into hidden 4..6 or <0 */
    assert(FQXStepVisiblePagerIndex(7, mask, 0, +1) == 3);
    assert(FQXStepVisiblePagerIndex(7, mask, 3, +1) == -1);
    assert(FQXStepVisiblePagerIndex(7, mask, 3, -1) == 0);
    assert(FQXStepVisiblePagerIndex(7, mask, 0, -1) == -1);

    /* When only short story, comic and topic are shown, a hidden default must
       move to short story before the history list container is initialized. */
    unsigned int remaining = (1u << 4) | (1u << 5) | (1u << 6);
    assert(FQXEvaluateVisiblePagerPolicy(7, remaining, 1, 0).redirectIndex == 4);
    assert(FQXEvaluateVisiblePagerPolicy(7, remaining, 1, 3).redirectIndex == 4);
    assert(FQXEvaluateVisiblePagerPolicy(7, remaining, 1, 5).redirectIndex == -1);
    assert(FQXEvaluateVisiblePagerPolicy(7, 0, 1, 0).redirectIndex == -1);

    /* Single visible tab locks BOTH native scroll and step pan completely */
    unsigned int singleMask = (1u << 3);
    FQXVisiblePagerPolicy singlePol = FQXEvaluateVisiblePagerPolicy(7, singleMask, 1, 3);
    assert(singlePol.allowNativeScroll == 0);
    assert(singlePol.allowVisibleStepPan == 0);
    assert(singlePol.redirectIndex == -1);
    assert(FQXStepVisiblePagerIndex(7, singleMask, 3, +1) == -1);
    assert(FQXStepVisiblePagerIndex(7, singleMask, 3, -1) == -1);

    /* History right/left scroll-edge fade masks (rightMaskView / rightGradientView) hide when
       筛选 & 编辑 are hidden or when visible pills fit without scrolling (eliminating dark vertical band) */
    assert(FQXShouldHideHistoryEdgeMask(1, 0, 0, 1, 1) == 1);
    assert(FQXShouldHideHistoryEdgeMask(1, 1, 1, 0, 1) == 1);
    assert(FQXShouldHideHistoryEdgeMask(0, 1, 1, 0, 1) == 1);
    assert(FQXShouldHideHistoryEdgeMask(1, 1, 1, 1, 1) == 0);
    assert(FQXShouldHideHistoryEdgeMask(1, 1, 0, 1, 1) == 0);
    assert(FQXShouldHideHistoryEdgeMask(1, 1, 1, 1, 0) == 1);

    /* Danmaku unlock policy enables AB gate while respecting ListenMode & TeenagerMode */
    assert(FQXShouldUnlockShortVideoDanmaku(1, 0, 0) == 1);
    assert(FQXShouldUnlockShortVideoDanmaku(1, 1, 0) == 0);
    assert(FQXShouldUnlockShortVideoDanmaku(1, 0, 1) == 0);
    assert(FQXShouldUnlockShortVideoDanmaku(0, 0, 0) == 0);

    /* Main-thread freeze prevention policies:
       1. Shelf tab tap recovery never races native UIKit selection when no reflow/offset exists. */
    assert(FQXShouldRunShelfTabTapRecovery(0, 223.7, 223.7, 46.0, 46.0) == 0);
    assert(FQXShouldRunShelfTabTapRecovery(0, 223.7, 224.2, 46.0, 46.0) == 0);
    assert(FQXShouldRunShelfTabTapRecovery(1, 223.7, 223.7, 46.0, 46.0) == 1);
    assert(FQXShouldRunShelfTabTapRecovery(0, 120.0, 223.7, 46.0, 46.0) == 1);
    assert(FQXShouldRunShelfTabTapRecovery(0, 223.7, 223.7, 30.0, 46.0) == 1);

    /* 2. History saved-frame capture rejects premature zero/tiny frames during early viewDidLoad/loadMaskView. */
    assert(FQXShouldCaptureHistorySavedFrame(0.0, 0.0) == 0);
    assert(FQXShouldCaptureHistorySavedFrame(24.0, 32.0) == 0);
    assert(FQXShouldCaptureHistorySavedFrame(240.0, 10.0) == 0);
    assert(FQXShouldCaptureHistorySavedFrame(240.0, 32.0) == 1);

    /* 3. History expanded-width resolver converges monotonically with zero redundant frame writes. */
    assert(fabs(FQXResolveHistoryExpandedWidth(240.0, 240.0, 416.2) - 416.0) < 1e-6);
    assert(fabs(FQXResolveHistoryExpandedWidth(240.0, 416.0, 416.2) - 0.0) < 1e-6);
    assert(fabs(FQXResolveHistoryExpandedWidth(240.0, 240.0, 241.0) - 0.0) < 1e-6);
    assert(fabs(FQXResolveHistoryExpandedWidth(0.0, 0.0, 416.0) - 0.0) < 1e-6);

    /* 4. History full sync is blocked re-entrantly and blocked inside sub-layout hooks (categoryLayout /
          loadMaskView: / layoutCategoryRightButtons), allowing only O(1) edge-mask sync there. */
    assert(FQXShouldRunHistoryFullSync(0, 1, 440.0, 956.0, 0) == 1);
    assert(FQXShouldRunHistoryFullSync(1, 1, 440.0, 956.0, 0) == 0);
    assert(FQXShouldRunHistoryFullSync(0, 1, 440.0, 956.0, 1) == 0);
    assert(FQXShouldRunHistoryFullSync(0, 0, 440.0, 956.0, 0) == 0);
    assert(FQXShouldRunHistoryFullSync(0, 1, 120.0, 956.0, 0) == 0);

    /* 5. Drama top capsule crash prevention: never run full capsule sync off-main, re-entrantly,
          before window mount (when glass is on), or inside updateScrollMaskLayer KVO callbacks. */
    assert(FQXShouldRunDramaCapsuleFullSync(1, 0, 1, 1, 0) == 1);
    assert(FQXShouldRunDramaCapsuleFullSync(0, 0, 1, 1, 0) == 0);
    assert(FQXShouldRunDramaCapsuleFullSync(1, 1, 1, 1, 0) == 0);
    assert(FQXShouldRunDramaCapsuleFullSync(1, 0, 0, 1, 0) == 0);
    assert(FQXShouldRunDramaCapsuleFullSync(1, 0, 1, 1, 1) == 0);
    assert(FQXShouldRunDramaCapsuleFullSync(1, 0, 0, 0, 0) == 1);

    /* 6. Unresolved header owner (e.g. simpleHeader lacking delegate) must never clobber an
          existing Drama compact visMask and trigger a 0x03000007 <-> 0x03000000 relayout loop. */
    assert(FQXShouldCommitDramaCompactVisMask(1, 0x03000007u, 0x03000007u, 1) == 0);
    assert(FQXShouldCommitDramaCompactVisMask(1, 0x03000007u, 0x03000005u, 1) == 1);
    assert(FQXShouldCommitDramaCompactVisMask(0, 0x03000007u, 0x03000000u, 1) == 0);
    assert(FQXShouldCommitDramaCompactVisMask(0, 0u, 0x03000000u, 0) == 1);

    /* 7. Dock haptic suppression policy: when BottomHaptics is off, suppress any feedback
          generator owned by Dock views OR anonymous/window-bound UIKit feedback during active
          Dock touch/drag, while never suppressing haptics when enabled or on unrelated controls. */
    assert(FQXShouldSuppressDockFeedbackGenerator(1, 1, 0, 1) == 0);
    assert(FQXShouldSuppressDockFeedbackGenerator(1, 0, 0, 1) == 0);
    assert(FQXShouldSuppressDockFeedbackGenerator(0, 1, 0, 0) == 1);
    assert(FQXShouldSuppressDockFeedbackGenerator(0, 1, 0, 1) == 1);
    assert(FQXShouldSuppressDockFeedbackGenerator(0, 0, 0, 1) == 1);
    assert(FQXShouldSuppressDockFeedbackGenerator(0, 0, 0, 0) == 0);
    assert(FQXShouldSuppressDockFeedbackGenerator(0, 0, 1, 1) == 0);
    assert(FQXShouldSuppressDockFeedbackGenerator(0, 0, 1, 0) == 0);

    /* 8. Mine shortcut fold first-page vertical band: without attachment preserve centered band;
          with attached continue-watching/history banner (attachmentHeight > 0 or attachView rect),
          confine band strictly above the attachment so circular icons never overlap the banner. */
    {
        double by = 0.0, bh = 0.0;
        /* No attachment: card [-12, 84] (midY = 36), dots at 72 -> centered at 36, height 54. */
        FQXComputeMineFoldFirstPageBandY(-12.0, 84.0, 1, 72.0, 0, 0, 0.0, 0.0, 47.0, 27.0, &by, &bh);
        assert(fabs(by - 9.0) < 1e-6 && fabs(bh - 54.0) < 1e-6);

        /* With mounted attachment at y=64 (itemHeight=58, attachHeight=56, card=[-12,148], dots=132):
           band stays in [0, 62] (midY=31, cell [2, 60]), zero overlap with attachMinY=64. */
        FQXComputeMineFoldFirstPageBandY(-12.0, 148.0, 1, 132.0, 1, 1, 64.0, 56.0, 58.0, 27.0, &by, &bh);
        assert(fabs(by - 0.0) < 1e-6 && fabs(bh - 62.0) < 1e-6);
        assert(by + bh <= 64.0 - 1.5);

        /* First layout pass before attachView is mounted (hasAttachRect=0, attachmentHeight=56, itemHeight=47):
           ceiling derived from itemHeight+6=53 -> band [0, 51], zero overlap with 53. */
        FQXComputeMineFoldFirstPageBandY(-12.0, 140.0, 1, 124.0, 1, 0, 0.0, 56.0, 47.0, 27.0, &by, &bh);
        assert(fabs(by - 0.0) < 1e-6 && fabs(bh - 51.0) < 1e-6);
        assert(by + bh <= 53.0 - 1.5);

        /* Tight/degenerate attachment ceiling below itemHeight: fall back to bh=0 (keep native y=0). */
        FQXComputeMineFoldFirstPageBandY(-12.0, 120.0, 1, 108.0, 1, 1, 44.0, 56.0, 58.0, 27.0, &by, &bh);
        assert(fabs(bh - 0.0) < 1e-6);
    }

    /* 9. Shelf Favorites extra history card suppression: style 0 is "查看短剧浏览历史",
          style 1 is "前往首页" (store_video_category). */
    assert(FQXShouldHideShelfFavoritesExtraCell(0, 0) == 1);
    assert(FQXShouldHideShelfFavoritesExtraCell(0, 1) == 0);
    assert(FQXShouldHideShelfFavoritesExtraCell(0, -1) == 0);
    assert(FQXShouldHideShelfFavoritesExtraCell(1, 0) == 0);
    assert(FQXShouldHideShelfFavoritesExtraCell(1, 1) == 0);

    /* 10. Short drama bottom-left Danmaku button, Author AI declaration, and Original Novel visibility policies. */
    assert(FQXShouldShowDramaDanmakuButton(1, 1) == 1);
    assert(FQXShouldShowDramaDanmakuButton(1, 0) == 0);
    assert(FQXShouldShowDramaDanmakuButton(0, 1) == 0);
    assert(FQXShouldShowDramaDanmakuButton(0, 0) == 0);

    assert(FQXShouldShowDramaAuthorDeclaration(1, 1) == 1);
    assert(FQXShouldShowDramaAuthorDeclaration(1, 0) == 0);
    assert(FQXShouldShowDramaAuthorDeclaration(0, 1) == 0);
    assert(FQXShouldShowDramaAuthorDeclaration(0, 0) == 0);

    assert(FQXResolveDramaAboveProgressDistributionType(1, 3ULL) == 3ULL);
    assert(FQXResolveDramaAboveProgressDistributionType(0, 3ULL) == 0ULL);
    assert(FQXResolveDramaAboveProgressDistributionType(0, 1ULL) == 1ULL);
    assert(FQXResolveDramaAboveProgressDistributionType(0, 2ULL) == 2ULL);
    assert(FQXResolveDramaAboveProgressDistributionType(0, 4ULL) == 4ULL);
    assert(FQXResolveDramaAboveProgressDistributionType(0, 6ULL) == 6ULL);
    assert(FQXResolveDramaAboveProgressDistributionType(0, 9ULL) == 9ULL);
    assert(FQXResolveDramaAboveProgressDistributionType(0, 14ULL) == 14ULL);
    assert(FQXResolveDramaAboveProgressDistributionType(0, 0ULL) == 0ULL);

    assert(FQXShouldShowDramaOriginalNovelEntry(1, 1) == 1);
    assert(FQXShouldShowDramaOriginalNovelEntry(1, 0) == 0);
    assert(FQXShouldShowDramaOriginalNovelEntry(0, 1) == 0);
    assert(FQXShouldShowDramaOriginalNovelEntry(0, 0) == 0);
}

static void test_audio_ad_duration_gate_and_pendant_purification_policy(void) {
    /* 1. Default legacy options mask when FanqieAdBlock.Options.1 is unset is 0x57FFF
          (bits 0..14, 16, 18 ON; bit 15 welfare tab & bit 17 welfare pendant OFF). */
    assert(FQXEffectiveLegacyAdOptionsMask(0, 0u) == 0x57FFFu);
    assert(FQXEffectiveLegacyAdOptionsMask(1, 0x7FFFFu) == 0x7FFFFu);
    assert(FQXEffectiveLegacyAdOptionsMask(1, 0u) == 0u);

    /* 2. Audiobook ad & "看广告攒时长" duration gate policy:
          Active when FanqieX.AudioAds.1 is ON OR legacy mask has bit 7 (0x80) or bit 8 (0x100). */
    assert(FQXShouldBlockAudioAdsAndDurationGate(0, 0u, 0) == 1);          /* Default 0x57FFF includes 0x180 */
    assert(FQXShouldBlockAudioAdsAndDurationGate(1, 0x7FFFFu, 0) == 1);    /* User's 524287 (all 19 switches ON) */
    assert(FQXShouldBlockAudioAdsAndDurationGate(1, (1u << 7), 0) == 1);   /* Audio patch ad switch only */
    assert(FQXShouldBlockAudioAdsAndDurationGate(1, (1u << 8), 0) == 1);   /* Audio info-flow ad switch only */
    assert(FQXShouldBlockAudioAdsAndDurationGate(1, 0u, 1) == 1);          /* Standalone FanqieX.AudioAds.1 ON */
    assert(FQXShouldBlockAudioAdsAndDurationGate(1, 0x57E7Fu, 0) == 0);    /* Bits 7 & 8 explicitly turned OFF, AudioAds OFF */
    assert(FQXShouldBlockAudioAdsAndDurationGate(1, 0u, 0) == 0);          /* Everything OFF */

    /* 3. Welfare / gold-coin / listen-earn pendant suppression policy:
          Active when FanqieX.ListenPendant.1 is ON OR legacy mask has bit 17 (0x20000). */
    assert(FQXShouldSuppressWelfareListenPendant(0, 0u, 0) == 0);          /* Default 0x57FFF has bit 17 OFF */
    assert(FQXShouldSuppressWelfareListenPendant(0, 0u, 1) == 1);          /* ListenPendant ON */
    assert(FQXShouldSuppressWelfareListenPendant(1, 0x7FFFFu, 0) == 1);    /* Legacy bit 17 ON */
    assert(FQXShouldSuppressWelfareListenPendant(1, (1u << 17), 0) == 1);  /* Bit 17 only */
    assert(FQXShouldSuppressWelfareListenPendant(1, 0x5FFFFu, 0) == 0);    /* Bit 17 OFF and ListenPendant OFF */

    /* 4. Bottom-right reader "01:52:42 听书时长" hourglass pendant (SSBizAudioAdNewReaderPendantView /
          SSAudioTTSPreUnlockPendantInsertObj): suppressed when EITHER pendant purification OR
          audiobook ad-duration blocking is active; restores when both are disabled. */
    assert(FQXShouldSuppressReaderAudioDurationPendant(0, 0u, 0, 0) == 1);
    assert(FQXShouldSuppressReaderAudioDurationPendant(1, 0x7FFFFu, 1, 0) == 1);
    assert(FQXShouldSuppressReaderAudioDurationPendant(1, (1u << 17), 0, 0) == 1);
    assert(FQXShouldSuppressReaderAudioDurationPendant(1, 0u, 1, 0) == 1);
    assert(FQXShouldSuppressReaderAudioDurationPendant(1, 0u, 0, 1) == 1);
    assert(FQXShouldSuppressReaderAudioDurationPendant(1, 0x57E7Fu, 0, 0) == 0);
    assert(FQXShouldSuppressReaderAudioDurationPendant(1, 0u, 0, 0) == 0);

    /* 5. BDFQPlayManager -tryToPlayAtTime:position:disableIntercept:source: force-disable policy:
          Forces disableIntercept=YES for normal indicator/chapter playback when audio ad gate is blocked,
          and always preserves remote/play/toggle lock-screen resume. */
    assert(FQXShouldForceDisableAudioPlayIntercept(1, 0x7FFFFu, 0, 0) == 1);
    assert(FQXShouldForceDisableAudioPlayIntercept(0, 0u, 0, 0) == 1);
    assert(FQXShouldForceDisableAudioPlayIntercept(1, 0x57E7Fu, 0, 0) == 0);
    assert(FQXShouldForceDisableAudioPlayIntercept(1, 0u, 0, 0) == 0);
    assert(FQXShouldForceDisableAudioPlayIntercept(1, 0u, 0, 1) == 1);
}

static void test_video_backdrop_viewport_and_single_series_tray_policy(void) {
    /* 1. Exact viewport match */
    assert(FQXVideoBackdropSameRect(0.0, 0.0, 440.0, 867.0, 0.0, 0.0, 440.0, 867.0, 0.75) == 1);
    assert(FQXVideoBackdropSameRect(0.0, 0.0, 440.0, 867.0, 0.0, 0.0, 440.0, 956.0, 0.75) == 0);

    /* 2. Overscanned aspect-fill portrait cover centered on (0, 0, 440, 867) viewport (MidY=433.5):
          Fixes the +44.5pt downward jump ~0.3-0.4s after swipe settle when coverImageView hands off to TTMetalView! */
    assert(FQXVideoBackdropMatchesViewport(0.0, 0.0, 440.0, 867.0, 0.0, 0.0, 440.0, 867.0) == 1);
    assert(FQXVideoBackdropMatchesViewport(-24.0, 0.0, 488.0, 867.0, 0.0, 0.0, 440.0, 867.0) == 1);
    assert(FQXVideoBackdropMatchesViewport(0.0, -36.0, 440.0, 939.0, 0.0, 0.0, 440.0, 867.0) == 1);
    /* Already-expanded full-screen cover (MidY=478.0) or 16:9 letterbox cover must NOT match 867pt viewport */
    assert(FQXVideoBackdropMatchesViewport(-27.0, 0.0, 494.0, 956.0, 0.0, 0.0, 440.0, 867.0) == 0);
    assert(FQXVideoBackdropMatchesViewport(0.0, 310.0, 440.0, 247.5, 0.0, 0.0, 440.0, 867.0) == 0);

    /* 3. Cached single-series bottom tray height validation for frame-0 alignment before HUD transfer */
    assert(FQXShouldUseCachedSingleSeriesTrayHeight(89.0, 440.0, 956.0, 440.0, 956.0) == 1);
    assert(FQXShouldUseCachedSingleSeriesTrayHeight(0.0, 440.0, 956.0, 440.0, 956.0) == 0);
    assert(FQXShouldUseCachedSingleSeriesTrayHeight(180.0, 440.0, 956.0, 440.0, 956.0) == 0);
    assert(FQXShouldUseCachedSingleSeriesTrayHeight(89.0, 320.0, 956.0, 440.0, 956.0) == 0);
}

static void test_pinch_pure_clean_session_and_745_gates(void) {
    /* 1. Two-finger spread (+1) enters Pure-Clean; two-finger shrink (-1) exits Pure-Clean */
    assert(FQXEvaluatePinchCleanTransition(0, 1.15, 0.10) == 1);
    assert(FQXEvaluatePinchCleanTransition(0, 1.05, 0.45) == 1);
    assert(FQXEvaluatePinchCleanTransition(0, 0.85, -0.50) == 0);
    assert(FQXEvaluatePinchCleanTransition(1, 0.88, -0.10) == -1);
    assert(FQXEvaluatePinchCleanTransition(1, 0.95, -0.45) == -1);
    assert(FQXEvaluatePinchCleanTransition(1, 1.18, 0.50) == 0);

    /* 2. Session-level persistence across vertical video swipes:
          Incoming cell adopts active feed session Pure-Clean immediately;
          outgoing cell unmasks ONLY its own overlays while keeping shared header/Dock masked! */
    assert(FQXShouldApplyPinchCleanToIncomingCell(1, 1, 1, 0) == 1);
    assert(FQXShouldApplyPinchCleanToIncomingCell(1, 0, 1, 0) == 0);
    assert(FQXShouldApplyPinchCleanToIncomingCell(1, 1, 0, 0) == 0); /* Landscape window */
    assert(FQXShouldApplyPinchCleanToIncomingCell(1, 1, 1, 1) == 0); /* Fullscreen player */
    assert(FQXShouldApplyPinchCleanToIncomingCell(0, 1, 1, 0) == 0); /* Feature disabled */

    assert(FQXShouldKeepSharedChromeMaskedOnCellDepart(1, 1, 0) == 1); /* Swiping to next video */
    assert(FQXShouldKeepSharedChromeMaskedOnCellDepart(1, 1, 1) == 0); /* Leaving feed VC */
    assert(FQXShouldKeepSharedChromeMaskedOnCellDepart(1, 0, 0) == 0); /* Session exited */
    assert(FQXShouldKeepSharedChromeMaskedOnCellDepart(0, 1, 0) == 0); /* Feature toggled off */

    /* 3. Episode selection sheet 3 module switches (default OFF -> visible) */
    assert(FQXShouldHideEpisodePanelAdaptations(0) == 0);
    assert(FQXShouldHideEpisodePanelAdaptations(1) == 1);
    assert(FQXShouldHideEpisodePanelSameSeries(0) == 0);
    assert(FQXShouldHideEpisodePanelSameSeries(1) == 1);
    assert(FQXShouldHideEpisodePanelRecommend(0) == 0);
    assert(FQXShouldHideEpisodePanelRecommend(1) == 1);

    /* 4. 7.4.5 Short-Video Feed / Patch / Bookstore-Popup legacy ad bitmask gates */
    assert(FQXShouldBlockShortVideoFeedAd(0, 0u) == 1);
    assert(FQXShouldBlockShortVideoFeedAd(1, (1u << 9)) == 1);
    assert(FQXShouldBlockShortVideoFeedAd(1, 0u) == 0);

    assert(FQXShouldBlockShortVideoPatchAd(0, 0u) == 1);
    assert(FQXShouldBlockShortVideoPatchAd(1, (1u << 10)) == 1);
    assert(FQXShouldBlockShortVideoPatchAd(1, 0u) == 0);

    assert(FQXShouldBlockBookstoreAndPopupAd(0, 0u) == 1);
    assert(FQXShouldBlockBookstoreAndPopupAd(1, (1u << 6)) == 1);
    assert(FQXShouldBlockBookstoreAndPopupAd(1, 0u) == 0);
}

static void test_audiobook_sheets_and_video_palette_policy(void) {
    /* 1. Audiobook half-sheets material & blur resolution (7 sheets + More panel) */
    assert(FQXResolveAudioSheetMaterial(0, 0, 1, 0) == 1);      /* Unset defaults to Liquid Glass (1) */
    assert(FQXResolveAudioSheetMaterial(0, 0, 4, 0) == 4);      /* Unset inherits Regular Frosted (4) from Share */
    assert(FQXResolveAudioSheetMaterial(1, 0, 1, 50) == 0);     /* Explicit Native (0) stays Native */
    assert(FQXResolveAudioSheetMaterial(1, 4, 1, 20) == 4);     /* Explicit Frosted Glass (4) */
    assert(FQXResolveAudioSheetMaterial(1, 2, 1, 40) == 2);     /* Explicit Gaussian Blur (2) */
    assert(FQXResolveAudioSheetMaterial(1, 3, 1, 0) == 0);      /* Legacy 3 normalizes to 0 */
    assert(FQXResolveAudioSheetMaterial(1, 99, 1, 0) == 1);     /* Out-of-range defaults to Liquid Glass (1) */

    assert(FQXResolveAudioSheetBlur(1, 42, 1, 15) == 42);       /* Prefers AudioSheetBlur */
    assert(FQXResolveAudioSheetBlur(0, 0, 1, 35) == 35);        /* Falls back to legacy AudioMoreBlur */
    assert(FQXResolveAudioSheetBlur(0, 0, 0, 0) == 0);
    assert(FQXResolveAudioSheetBlur(1, 140, 0, 0) == 100);      /* Clamped to 0..100 */
    assert(FQXResolveAudioSheetBlur(1, -10, 0, 0) == 0);

    /* 2. Audiobook sheet card geometry: accepts both short sheets (已加书架/语速 ~240pt)
          and tall sheets (章评/选择章节/播放目录 ~89% height), rejects full-screen root (minY=0) */
    assert(FQXAudioSheetCardGeometryValid(105.0, 956.0, 440.0, 851.0, 440.0, 956.0) == 1); /* 章评/目录 */
    assert(FQXAudioSheetCardGeometryValid(700.0, 956.0, 440.0, 256.0, 440.0, 956.0) == 1); /* 语速/已加书架 */
    assert(FQXAudioSheetCardGeometryValid(0.0, 956.0, 440.0, 956.0, 440.0, 956.0) == 0);   /* Full-screen root */
    assert(FQXAudioSheetCardGeometryValid(880.0, 956.0, 440.0, 76.0, 440.0, 956.0) == 0);  /* Too short */
    assert(FQXAudioSheetCardGeometryValid(200.0, 600.0, 200.0, 400.0, 440.0, 956.0) == 0); /* Not bottom-anchored */

    /* 2b. Main audiobook player guard strictly rejects SSNestedContainerScrollView /
           FQRJXCategoryListContainerView / main player subtree so player is never double-glassed */
    assert(FQXAudioSheetCandidateIsMainPlayer(1, 0, 0) == 1); /* SSNestedContainerScrollView */
    assert(FQXAudioSheetCandidateIsMainPlayer(0, 1, 0) == 1); /* FQRJXCategoryListContainerView */
    assert(FQXAudioSheetCandidateIsMainPlayer(0, 0, 1) == 1); /* Contains 边听边读 / core player controls */
    assert(FQXAudioSheetCandidateIsMainPlayer(0, 0, 0) == 0); /* Real secondary half-sheet container */

    /* 3. Reference video palette: matte VideoBase + translucent RoseMistGlass (粉雾玻璃) */
    FQXRGBAColor baseFill = FQXVideoBaseSurfaceFillColor();
    assert(fabs(baseFill.r - 238.0 / 255.0) < 1e-6);
    assert(fabs(baseFill.g - 237.0 / 255.0) < 1e-6);
    assert(fabs(baseFill.b - 240.0 / 255.0) < 1e-6);
    assert(baseFill.a > 0.90 && baseFill.a <= 1.0);

    FQXRGBAColor glassTint = FQXRoseMistGlassBaseTintColor();
    assert(glassTint.r > glassTint.g && glassTint.b > glassTint.g); /* Cool-pearl rose-mist undertone */
    assert(glassTint.a > 0.30 && glassTint.a < 0.60);               /* Truly translucent Liquid Glass tint */

    FQXRGBAColor selFallback = FQXVideoSelectedPillFallbackColor();
    assert(selFallback.r > selFallback.g && selFallback.b > selFallback.g); /* SoftRoseMist (柔性粉雾) */
    FQXRGBAColor glassSel = FQXRoseMistGlassSelectedFallbackColor();
    assert(glassSel.r > glassSel.g && glassSel.b > glassSel.g);             /* RoseMistGlass (粉雾玻璃) */
    assert(glassSel.a > 0.35 && glassSel.a < 0.65);

    /* 4. Dock material modes: VideoBase (4) disables glass+blur; RoseMistGlass (5) enables glass & obeys blur slider */
    assert(FQXNormalizeDockMaterialMode(4) == FQXDockMaterialModeVideoBase);
    assert(FQXNormalizeDockMaterialMode(5) == FQXDockMaterialModeRoseMistGlass);
    assert(FQXNormalizeDockMaterialMode(6) == FQXDockMaterialModeNewGlass);
    assert(FQXDockMaterialUsesGlass(FQXDockMaterialModeNewGlass) == 1);
    assert(FQXDockMaterialUsesGlass(FQXDockMaterialModeFrostedGlass) == 1);
    assert(FQXDockMaterialUsesGlass(FQXDockMaterialModeIOS18Gaussian) == 0);
    assert(FQXDockMaterialUsesGlass(FQXDockMaterialModeVideoBase) == 0);
    assert(FQXDockMaterialUsesGlass(FQXDockMaterialModeRoseMistGlass) == 1);
    assert(FQXDockMaterialUsesVideoLightBase(FQXDockMaterialModeVideoBase) == 1);
    assert(FQXDockMaterialUsesVideoLightBase(FQXDockMaterialModeRoseMistGlass) == 1);
    assert(FQXDockMaterialUsesVideoLightBase(FQXDockMaterialModeNewGlass) == 0);
    assert(FQXDockMaterialUsesBlur(FQXDockMaterialModeVideoBase, 100) == 0);
    assert(FQXDockMaterialUsesBlur(FQXDockMaterialModeVideoBase, 0) == 0);
    assert(FQXDockMaterialUsesBlur(FQXDockMaterialModeRoseMistGlass, 0) == 0);
    assert(FQXDockMaterialUsesBlur(FQXDockMaterialModeRoseMistGlass, 30) == 1);
    assert(FQXDockMaterialUsesBlur(FQXDockMaterialModeIOS18Gaussian, 0) == 1);
    assert(FQXDockMaterialUsesBlur(FQXDockMaterialModeNewGlass, 25) == 1);

    /* 5. Split Dock vs Drama top-bar selection tint (柔性粉雾=1, 粉雾玻璃=2), smart pairing, & right-rail guard */
    assert(FQXNormalizeSelectionTintStyle(1) == FQXSelectionTintStyleSoftRoseMist);
    assert(FQXNormalizeSelectionTintStyle(2) == FQXSelectionTintStyleRoseMistGlass);
    assert(FQXNormalizeSelectionTintStyle(3) == FQXSelectionTintStyleDefault);
    assert(FQXResolveSplitSelectionTintStyle(1, 2, 1, 1) == FQXSelectionTintStyleRoseMistGlass); /* Specific wins */
    assert(FQXResolveSplitSelectionTintStyle(1, 0, 1, 2) == FQXSelectionTintStyleDefault);       /* Explicit default overrides legacy */
    assert(FQXResolveSplitSelectionTintStyle(0, 0, 1, 1) == FQXSelectionTintStyleSoftRoseMist);  /* Legacy migration fallback */
    assert(FQXResolveSplitSelectionTintStyle(0, 0, 0, 0) == FQXSelectionTintStyleDefault);
    assert(FQXEffectiveSelectionTintStyle(0, 0) == FQXSelectionTintStyleDefault);
    assert(FQXEffectiveSelectionTintStyle(0, 1) == FQXSelectionTintStyleRoseMistGlass);
    assert(FQXEffectiveSelectionTintStyle(1, 1) == FQXSelectionTintStyleSoftRoseMist);
    assert(FQXEffectiveSelectionTintStyle(2, 0) == FQXSelectionTintStyleRoseMistGlass);
    assert(FQXShouldApplyDramaActionSurfaceOverlay(1, 0, 0) == 1); /* Original/stock right-rail icons get Liquid Glass / configured surface */
    assert(FQXShouldApplyDramaActionSurfaceOverlay(1, 1, 0) == 0); /* Naloia custom icons stay clean borderless without glass mask */
    assert(FQXShouldApplyDramaActionSurfaceOverlay(1, 0, 1) == 0); /* Hollow outline mode stays clean borderless */
    assert(FQXShouldApplyDramaActionSurfaceOverlay(0, 0, 0) == 0); /* Glass disabled */
    assert(FQXNormalizeDramaButtonSurfaceStyle(1) == FQXDramaButtonSurfaceVideoBase);
    assert(FQXNormalizeDramaButtonSurfaceStyle(2) == FQXDramaButtonSurfaceRoseMistGlass);
    assert(FQXNormalizeDramaButtonSurfaceStyle(-1) == FQXDramaButtonSurfaceDefaultGlass);
    assert(FQXShouldUseDarkInkForSurface(1, 0, 1) == 1); /* Dark ink on VideoBase/RoseMistGlass over dark video */
    assert(FQXShouldUseDarkInkForSurface(0, 1, 1) == 1); /* Dark ink on RoseMist pill over dark video */
    assert(FQXShouldUseDarkInkForSurface(0, 0, 1) == 0); /* White ink on normal dark glass */
    assert(FQXShouldUseDarkInkForSurface(0, 0, 0) == 1); /* Dark ink on normal light glass */
}

int main(void) {
    test_drama_top_capsule_alignment();
    test_sheet_blur_policy();
    test_shelf_and_history_compaction_and_pager();
    test_audio_ad_duration_gate_and_pendant_purification_policy();
    test_video_backdrop_viewport_and_single_series_tray_policy();
    test_pinch_pure_clean_session_and_745_gates();
    test_audiobook_sheets_and_video_palette_policy();
    puts("Layout and sheet policy: concentric capsule, hardware sheet blur, strip compaction & visible pager passed.");
    return 0;
}
