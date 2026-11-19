# FanqieX 1.8R18 Repair & Native Liquid Glass Interaction Upgrade

## Summary of Changes

1. **Dock Native Liquid Glass Dynamic Interaction & Optical Refraction (`native/FanqieXMotion.m`)**
   - Mounted the Dock's interactive Liquid Glass lens (`UIGlassEffectStyleClear`, `interactive = YES`) inside a native iOS 26/27 `UIGlassContainerEffect` (`spacing = 14.0`) container pre-warmed once during `syncWithBar:` (zero per-tap allocation, zero first-tap shader stall).
   - Replaced the delayed `dispatch_async` + 2-stage tap chain with immediate synchronous touch-down bloom and interruptible `UIViewPropertyAnimator` + `UISpringTimingParameters` motion:
     - TouchDown immediately awakens & blooms the real interactive Liquid Glass lens (or starts gliding toward the pressed tab).
     - Tapping across distant tabs (including leftmost <-> rightmost) launches an interruptible spring glide immediately from the live `presentationLayer` geometry with smooth directional horizontal liquid elongation (`bounds`/`center` + subtle `transform` pulse) so heavy tab VC switches can never drop or swallow the animation.
     - Rapid consecutive taps & pan gestures interrupt cleanly mid-flight with velocity continuity.
   - Removed the static `resizableSnapshotViewFromRect:` overlay and `opacity: 0 -> 1` flash in `FQXDockMotion prepareDock:inBar:` / `animateDock:fromFrame:compact:button:`, replacing them with a live interruptible `UIViewPropertyAnimator` spring morph directly on the real `UIGlassEffect` capsule.
   - Kept `FQXScheduleCYLGlassResample` (adapted from `ChenYilong/CYLTabBarController`, MIT) lightweight and deferred until after spring settlement (never triggering synchronous `setNeedsLayout` mid-animation).

2. **Comment Area Dual Liquid Glass Mode: Clear vs iOS 27 Frosted (`FanqieX.CommentGlassFrosted.1`)**
   - Preserved the current `1.8R17` Clear Liquid Glass style as the default (`OFF`).
   - Added **`评论区模糊液态玻璃（iOS 27 级）`** under `外观 / 玻璃效果` (`ON` switches short-drama & novel comment sheets live to `UIGlassEffectStyleRegular` + iOS 27 frosted dark scrim and `0.75pt` top specular border).

3. **Short-Drama Comment Bottom Overlap & Floating Input Bar Fix**
   - Automatically fades out and disables `SSTabBar` (`FQXSyncDockHiddenForCommentSheets`) while any comment sheet is open in the window, restoring it cleanly upon dismissal (`onVCDismiss` / `viewDidDisappear:` / `FQVTransitionView dismissAnimated:completion:`) so the floating Dock never bleeds through behind comments.
   - Upgraded `FQCCommentBottomToolBar`'s floating input capsule to `UIGlassEffectStyleRegular` (`interactive = YES`) + clean frosted backing and stripped stray inner wrapper borders so scrolling comments softly diffuse behind the pill without text collision or vertical seams across the image/emoji icons.

4. **Short-Drama Exit "是否放入书架-收藏?" Popup Toggle (`FanqieX.DramaExitCollectAlert.1`)**
   - Added **`隐藏短剧退出收藏弹窗`** under `短剧 / 播放设置`, hooking `SSShortVideoPlayerExitInterruptDelegate` (`shouldInterruptWhenExitPlayer:exitScene:`, `shouldShowCollectExitRetentioDialogOptWithContext:seriesId:`, `showAddBookShelfAlert:`) and `SSShortVideoPlayerExitInterruptComponent` (`shouldInterruptWhenExitPlayer:`).

5. **Audiobook Floating Capsule Deduplication & Reader-Safe Clamping**
   - Extended deduplication across **both** `SSAudioPlayIndicatorView` and `SSShortVideoPlayIndicatorView` and across **all windows** in connected scenes, eliminating duplicate capsules during swipe-back from reader to bookshelf.
   - Hooked `lockInPosition:`, `hoverableArea`, `setIsVisible:`, `hoverMove`, `moveToArea:`, `SSReaderAudioAdapter` (`lockedIndicatorTopWithReaderManager:`, `lockIndicator:`), and `SSAudioSettingManager` (`audioFloatingViewFrame`, `saveAudioFloatingViewFrame:`), enforcing `152pt` reader-toolbar clearance inside `BDReaderViewController` and `96pt` Dock clearance elsewhere so the listen capsule never drops into unreachable bottom space.
