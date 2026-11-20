# FanqieX 1.9.1beta8

## Fixes

1. **Fix Complete Freeze & Main-Thread Stutter When Opening Short Drama / Novel Comments**:
   - **Root Cause 1 (250Hz Dock Reset Death Spiral)**: `FQXTabBarInteraction` previously hid the legacy `proxy` and `overlay` views via `layer.opacity = 0.0f`, which made `proxy.alpha == 0.0`. `repair162/native_surface.s` (`LXvalid_proxy`) and `repair162/floating_bar_162.s` (`Lvisible_to`) treat `alpha <= 0.0` as an invalid proxy and invoke `LXrestore -> FQHBottomReset178`, which restored `proxy.layer.opacity = 1.0f` and dirtied `SSTabBar` layout — triggering `FQHBottomFinish` again 3.5ms later in an infinite 250Hz loop (5,559 consecutive `bottomAppearance178` events in the diagnostic log). Replaced `layer.opacity = 0.0f` with `FQXSetZeroMaskHidden` (an empty `CGRectZero` `CALayer` mask) so `proxy.hidden == NO` and `proxy.alpha == 1.0` stay invariant while 0 pixels are rendered.
   - **Root Cause 2 (Dock Teardown While Comment Sheet Is Open)**: `FQXSyncDockHiddenForCommentSheets` set `bar.alpha = 0.0` when opening comments, which also caused `Lvisible_to(bar, window)` in `native_surface.s` and `feed_viewport.s` to return `0` and trigger `LXrestore`. Changed target alpha to `0.002` (visually 0/255 invisible, `userInteractionEnabled = NO`, strictly `> 0.0`).
   - **Root Cause 3 (Comment Sheet Re-Entrant Layout Loops)**:
     - Guarded `FQXApplyCornerConfiguration` with an associated stamp (`FQXAppliedCornerStampKey`) so `setCornerConfiguration:` is not re-invoked on `UIVisualEffectView` on every `viewDidLayoutSubviews` tick.
     - Guarded `FQXSyncSheetTopRimLayer`, `FQXSyncLabelShadowForCommentMode`, `FQXPlaceCommentComposerGlass`, and `setIsDark:` in `FQXBoostCommentTypography` against redundant mutations.
     - Added stamp guards to `FQXSetLabelColorForce` and `FQXStyleSearchBannerSubtree` so `FQCShortVideoCommentSearchEntranceView -layoutSubviews` never loops by reassigning `attributedText` / `setTextLayout:` on every pass.
     - Skipped `FQXUpgradeDockProxyToClearGlass` while `nativeDockBar` is active, and applied `FQXSetZeroMaskHidden` to the Short Drama top capsule's legacy `flatLens`.
