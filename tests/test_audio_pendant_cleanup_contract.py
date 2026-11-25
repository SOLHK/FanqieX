"""Regression tests for Fanqie 7.4.3/7.4.5 audiobook ad-duration gate & reader pendant ABI contracts."""
from pathlib import Path
import re
import unittest

ROOT = Path(__file__).resolve().parents[1]


class AudioAndPendantCleanupContractTests(unittest.TestCase):
    def setUp(self) -> None:
        self.content_cleanup = (ROOT / "native" / "FQXContentCleanup.m").read_text(encoding="utf-8")
        self.fanqiex_cleanup = (ROOT / "native" / "FanqieXCleanup.m").read_text(encoding="utf-8")

    def test_welfare_listen_pendant_class_arg_selectors_use_instance_method_hooks(self) -> None:
        # Verified in 7.4.3.33 Mach-O:
        #   -[SSWelfareListenPendantManager canShowPendantInVC:]  enc=B24@0:8#16 (instance method, cm=NO)
        #   -[SSWelfareListenPendantManager tryShowPendant:]      enc=v24@0:8#16 (instance method, cm=NO)
        # Calling BoolClass/VoidClass (cm=YES) failed FQXLookupMatchingClass and never installed!
        self.assertNotRegex(
            self.content_cleanup,
            r'BoolClass\(\s*"SSWelfareListenPendantManager"\s*,\s*"canShowPendantInVC:"',
        )
        self.assertNotRegex(
            self.content_cleanup,
            r'VoidClass\(\s*"SSWelfareListenPendantManager"\s*,\s*"tryShowPendant:"',
        )
        self.assertIn('"SSWelfareListenPendantManager"', self.content_cleanup)
        self.assertIn('"canShowPendantInVC:"', self.content_cleanup)
        self.assertIn('"tryShowPendant:"', self.content_cleanup)
        self.assertIn('"B24@0:8#16"', self.content_cleanup)
        self.assertIn('"v24@0:8#16"', self.content_cleanup)

    def test_reader_bottom_right_hourglass_pendant_hooks_present(self) -> None:
        # Bottom-right pink hourglass ("01:52:42 听书时长") in BDReaderViewController:
        required_tokens = [
            "SSBizAudioAdNewReaderPendantManager",
            "canShowReaderPendant",
            "isPendantActive",
            "getReaderPendant",
            "showPendantView",
            "SSBizAudioAdNewReaderPendantView",
            "SSAudioTTSPreUnlockPendantInsertObj",
            "SSBizAudioAdABTestService",
            "ttsSyncPendantEnable",
            "ttsSyncPendantForceShow",
            "SSWelfareReadingToolPendantManager",
            "injectCyberPendant:",
            "SSReaderFloatingBtnBookActivityPendantInsertObj",
            "SSReaderAIGCTaskPendantInsertObj",
        ]
        for token in required_tokens:
            with self.subTest(token=token):
                self.assertIn(token, self.content_cleanup)

    def test_audiobook_duration_ad_gate_and_out_pointer_interceptors_present(self) -> None:
        # Verified 7.4.3/7.4.5 audiobook "看广告攒听书时长" / Inspire / PreUnlock chain:
        required_tokens = [
            "SSBizAudioAdInspireManager",
            "audioShouldInterceptWhenPlayCurrent:interceptSource:interceptInfo:",
            "v40@0:8^B16^@24^@32",
            "countDownHadFinishedInCountDownView:",
            "SSAdAudioInspireStrategyDataManager",
            "SSAdSettingsAudioInspireConfig",
            "audio_pre_lock_show_directly",
            "SSSpeechToneAudioAdFreeManager",
            "shouldSkipShowAudioPatchAd",
            "shouldHideAheadUnlock",
            "shouldSkipReportAudioConsumeTime",
            "SSBizAudioAdStartPlayPreUnlockManager",
            "showStartPlayPreUnlockWithCanShowView:canPlayTip:",
            "showStartPlayInterceptInspire",
            "SSBizAudioAdInspirePopupService",
            "showInspirePopupWithPopScene:",
            "showInspirePopupWithPopScene:dismissBlock:",
            "showInspirePopupWithProcessParam:",
            "SSBizAudioAdFunnelPopupManager",
            "showInspireFunnelPopupViewWithProcessParam:",
            "audioIndicatorWillShowWithPlayPosition:showContext:shouldIntercept:",
            "v40@0:8@16@24^B32",
            "SSBizAudioAdDefaultPopupManager",
            "showInspireFunnelPopupViewWithPopScene:",
            "SSAdAudioInspireAutoPlayManager",
            "checkCanAutoPlayAdWithPopScene:data:consumeLeftTime:isFromAudioStart:",
            "checkAndStartAutoPlayWithPopScene:data:consumeLeftTime:",
            "SSBizAudioAdPreUnlockViewManager",
            "canShowAheadUnlock",
            "SSBizAudioAdPreUnlockBarView",
            "SSAdAudioSettingManager",
            "hasFreeAdProfit",
            "audioAdOpenWithType:sceneType:hotStory:",
            "SSAdAudioManager",
            "adPlayingAuidoShouldIntercept:",
            "v24@0:8^B16",
            "SSAdAudioPatchClient",
            "SSAdAudioPatchAdapterClient",
            "SSAdBackgroundAudioClient",
            "FQXShouldForceDisableAudioPlayIntercept",
        ]
        for token in required_tokens:
            with self.subTest(token=token):
                self.assertIn(token, self.content_cleanup)

    def test_live_refresh_wired_for_pendant_and_audio_ad_toggles(self) -> None:
        self.assertIn("FQXRefreshReaderAndAudioPendants", self.content_cleanup)
        self.assertIn("FQXRefreshReaderAndAudioPendants", self.fanqiex_cleanup)
        self.assertRegex(
            self.fanqiex_cleanup,
            r"ListenPendantKey[\s\S]{0,240}FQXRefreshReaderAndAudioPendants",
        )


if __name__ == "__main__":
    unittest.main()
