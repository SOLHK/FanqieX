# FanqieX 1.9.1beta3 Repair & Optimization Notes

## Summary of Changes

1. **Official iOS 26/27 Perceptual Bounce ("Q弹") Dock Selection & Collapse Physics (`native/FanqieXMotion.m`)**
   - Upgraded `FQXTabBarInteraction` from over-damped linear translation (`damping = 0.84`) to Apple's official perceptual bounce spring API `+[UIView animateWithSpringDuration:bounce:initialSpringVelocity:delay:options:animations:completion:]` (`bounce = 0.44`–`0.48`) at 120Hz ProMotion on `backboardd`.
   - Added incompressible liquid-droplet stretch and landing jelly recoil (`CAKeyframeAnimation` with `additive = YES`, `calculationMode = kCAAnimationCubic`) on `pillView.layer`, synchronized icon Q-elastic pop on the selected `UIButton.layer`, velocity-coupled stretch during pan gestures, and subtle additive Liquid Glass breath on `proxy.layer` / `overlay.layer` (preserving `UIView.transform == Identity` and zero nested `UIGlassEffect` white/black refraction borders).
   - Upgraded `+[FQXDockMotion animateDock:fromFrame:compact:button:]` damping (`0.66 / 0.62`) for Q-elastic compact Dock transitions.

2. **3-Way Unified Comment Material Mode for Short Drama & Book Reading (`native/FanqieXMotion.m`, `native/FanqieXSettingsMenu.m`, `native/FanqieXCleanup.m`, `native/FanqieXSettingsBackup.m`)**
   - Added `FanqieX.CommentMaterialMode.1` (`0` = **深色液态玻璃**, `1` = **浅色液态玻璃**, `2` = **iOS 18 高斯模糊**), automatically migrating any legacy `FanqieX.CommentGlassFrosted.1` preference and retiring the old single switch.
   - Synchronized the 3-way `UISegmentedControl` selector across `短剧/播放设置`, `阅读/阅读设置`, `评论区净化`, and `外观/玻璃效果`; switching any option updates both Short-Drama comments (`评论` / `剧评` / input bar / composer) and Book Reading paragraph/chapter comments (`段评` / `章评` / input bar / composer) in real time.
   - Added full bidirectional typography & scrim adaptation for Light Liquid Glass (`UIUserInterfaceStyleLight`, pearl-white translucent veil, crisp dark charcoal primary ink, deep royal-blue links) and classic iOS 18 Gaussian Blur (`UIBlurEffectStyleSystemChromeMaterialDark` / `SystemThinMaterialDark` with standard continuous corner curves).

3. **Memory, Historical Residue, Legacy Settings & Binary Size Optimization (`native/FanqieXMotion.m`, `native/FanqieXCleanup.m`, `native/FanqieXSettingsMenu.m`, `scripts/build_book_export.py`)**
   - Released offscreen comment sheet & composer `UIVisualEffectView` Metal IOSurfaces automatically after panel dismiss/disappear and upon `UIApplicationDidReceiveMemoryWarningNotification` / `UIApplicationDidEnterBackgroundNotification`.
   - Added `FQXCommentTypographyStampKey` fast-path caching so 120Hz comment scrolling skips redundant `NSAttributedString` cloning and `YYTextLayout` rebuilds.
   - Removed retained `legacyPanels` view hierarchy (`legacy.tableHeaderView` / `tableFooterView`) and retired dead historical settings code (`CommentGlassFrosted`, `LocalRewardTest`, `Telegram 频道`).
   - Added automatic background + manual (`诊断与其他 -> 清理历史残留与缓存`) historical sandbox residue sweeper cleaning stale diagnostic exports, oversized legacy logs, temp staging files, and obsolete `FanqieAdBlock.*` defaults keys.
   - Enabled `-Oz` size optimization and `-x` local symbol stripping in `scripts/build_book_export.py`, shrinking the compiled Mach-O `.dylib` footprint by ~180 KB.
