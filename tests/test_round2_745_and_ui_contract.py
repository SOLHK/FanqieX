"""Contract tests for 1.9.8beta2: swipe anti-jitter backdrop, pinch pure-clean persistence,
settings header bar UI, episode selection sheet switches, and 7.4.5.33 host regressions."""
from pathlib import Path
import re
import unittest

ROOT = Path(__file__).resolve().parents[1]


class Round2And745ContractTests(unittest.TestCase):
    def setUp(self) -> None:
        self.motion = (ROOT / "native" / "FanqieXMotion.m").read_text(encoding="utf-8")
        self.content_cleanup = (ROOT / "native" / "FQXContentCleanup.m").read_text(encoding="utf-8")
        self.cleanup = (ROOT / "native" / "FanqieXCleanup.m").read_text(encoding="utf-8")
        self.menu = (ROOT / "native" / "FanqieXSettingsMenu.m").read_text(encoding="utf-8")
        self.backup = (ROOT / "native" / "FanqieXSettingsBackup.m").read_text(encoding="utf-8")
        self.policy = (ROOT / "native" / "FQXLayoutAndSheetPolicy.h").read_text(encoding="utf-8")

    def test_video_backdrop_swipe_anti_jitter_architecture(self) -> None:
        # Must NOT mutate global FQVShortVideoListVCPlayerComponent sizes/frames (which shifted 16:9
        # horizontal videos and desynchronized refreshCoverImageView from TTMetalView by +44.5pt).
        for removed in (
            "HookMaxPlayerViewHeightWithModel",
            "HookPortraitPlayerViewFrameWithModel",
            "HookScaleAspectFitContainerViewFrameWithModel",
        ):
            self.assertFalse(removed in self.motion, f"Unexpected {removed} still in FanqieXMotion.m")

        for required in (
            "FQXVideoBackdrop",
            "FQXVideoBackdropMatchesViewport",
            "FQXDetailOwnerTrayRectKey",
            "FQVShortVideoListVCScrollComponent",
            "scrollViewDidScroll:",
            "refreshCoverImageView",
            "vPlayerReadyToDisPlay:",
            "TTPlayerView",
            "TTMetalView",
        ):
            with self.subTest(token=required):
                self.assertTrue(required in self.motion, f"Missing {required} in FanqieXMotion.m")

    def test_pinch_pure_clean_persists_across_swipes_and_blocks_host_pinch(self) -> None:
        for required in (
            "FQXPinchSessionOwnerForControl",
            "FQXApplyPinchPureCleanToCellControl",
            "FQXApplyPinchPureCleanSharedChrome",
            "hitTest:withEvent:",
            "handlePinchGesture:",
            "pinchGesture:",
            "_episodeNewInfoView",
            "_playBtn",
            "_fullscreenBtn",
        ):
            with self.subTest(token=required):
                self.assertTrue(required in self.motion, f"Missing {required} in FanqieXMotion.m")

    def test_settings_header_bar_version_label_and_custom_ios_minimize_icon(self) -> None:
        # Left version capsule uses readable semibold typography; right minimize button uses a custom
        # CoreGraphics-drawn iOS icon mounted ABOVE the UIGlassEffect/UIVisualEffectView surface.
        self.assertTrue("UIGraphicsImageRenderer" in self.menu)
        self.assertTrue("UIFontWeightSemibold" in self.menu)
        self.assertFalse('systemImageNamed:@"chevron.down"' in self.menu)

    def test_episode_selection_sheet_three_switches_wired_end_to_end(self) -> None:
        keys = (
            "DramaHideEpisodeAdaptations",
            "DramaHideEpisodeSameSeries",
            "DramaHideEpisodeRecommend",
        )
        for k in keys:
            with self.subTest(key=k):
                self.assertTrue(k in self.cleanup, f"Missing {k} in FanqieXCleanup.m")
                self.assertTrue(f"FanqieX.{k}.1" in self.menu, f"Missing FanqieX.{k}.1 in menu")
                self.assertTrue(f"FanqieX.{k}.1" in self.motion, f"Missing FanqieX.{k}.1 in motion")

        for host_cls in (
            "SSShortVideoEpisodeCompositeSubViewController",
            "SSShortVideoEpisodeRelatedWorksSectionController",
            "SSShortVideoEpisodeBookSectionController",
            "SSShortVideoEpisodeSeasonSubscribeSectionViewController",
            "SSShortVideoEpisodeDoubleColSectionController",
            "SSShortVideoEpisodeGridSectionController",
            "SSShortVideoEpisodeTitleSectionController",
            "SSShortVideoEpisodesViewController",
            "SSShortVideoEpisodesSeriesSectionView",
            "SSShortVideoEpisodesSeriesTab",
        ):
            with self.subTest(host_cls=host_cls):
                self.assertTrue(host_cls in self.motion, f"Missing {host_cls} in FanqieXMotion.m")

    def test_745_host_regressions_covered(self) -> None:
        self.assertTrue("SSMyUserUnlimitedHelper" in self.motion, "Missing SSMyUserUnlimitedHelper")
        self.assertTrue("SSMyUser621SideBarGameSkeletonCell" in self.motion, "Missing GameSkeletonCell")
        self.assertTrue("SSVideoSeriesFeedSideBarV725ViewController" in self.motion, "Missing V725 sidebar")
        self.assertRegex(self.backup, r"0x[7F]FFFF")
        for gate_token in (
            "SSBizVideoAdABTestHelper",
            "enableEcomForceCard",
            "SSShortVideoLiveService",
            "SSVideoMiniGameService",
            "BDADBackPatchAdService",
            "BDADPlotTouchAdService",
            "BDADShortVideoSideBarPatchSwitchComponent",
            "IESLiveUGBenefitCouponFragment",
            "SSCouponPopupFrequencyHelper",
            "SSShortVideoSatisfactionSurveyManager",
        ):
            with self.subTest(gate_token=gate_token):
                self.assertTrue(gate_token in self.content_cleanup, f"Missing {gate_token}")


if __name__ == "__main__":
    unittest.main()
