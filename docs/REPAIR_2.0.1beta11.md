# FanqieX 2.0.1beta11 Notes

## Summary
1. **Audiobook Half-Sheets Liquid Glass / Frosted Glass & Custom Blur (`0%–100%`)**:
   - Extended Liquid Glass (`UIGlassEffectStyleClear`), Frosted Glass (`UIGlassEffectStyleRegular`), Gaussian Blur (`FQXBackdropBlurView`), and Native restoration across all 7 audiobook half-sheets (`章评`, `选择章节`, `已加书架`, `语速`, `定时关闭`, `简介 / 播放目录`, `音色设置`) plus the existing `更多` (`SSReadingSharePanel`) panel.
   - Added `FanqieX.AudioSheetMaterial.1` (`原版默认` / `液态玻璃` / `模糊玻璃` / `高斯模糊`, default `液态玻璃`) and `FanqieX.AudioSheetBlur.1` (`0%–100%`, bridged with legacy `FanqieX.AudioMoreBlur.1`) under `阅读 → 智能朗读` and `外观 → 玻璃效果`, with full settings backup and live refresh.
   - Added passive non-interfering `FQXAudioTouchObserverGesture` and dynamic `UITableViewCell` / `UICollectionViewCell` hooks so scrolled cells remain translucent and colored accents (selected chapter, tone card, switch, download CTA) stay preserved.

2. **Exact Reference Video Selected Pill Color (`视频同款粉雾`) for Top Buttons & Dock**:
   - Added `FanqieX.SelectionTintStyle.1` (`默认` / `视频同款粉雾`) under `外观 → 玻璃与尺寸`, `短剧 → 顶部分类`, and `页面与导航 → 底栏入口`.
   - Renders the exact calibrated 5-stop diagonal rose-blush-to-pearl gradient (`#E0A6B6 → #DFB6C1 → #E2D3D8 → #E2E1E4 → #DFDEE2`), top-left organic rose bloom, upper specular sheen, and 0.75pt rose-to-silver hairline rim via `FQXVideoSelectedPillView` / `+videoSelectedPillImageForSize:` on the short-drama top category selection pill, native `UITabBar` selection view, compact/proxy lens, and detached circular Dock button, automatically switching selected ink to crisp charcoal `#141316`.

3. **Exact Reference Video Non-Glass Base Surface (`视频同款底色（非玻璃）`) for All Short-Drama Buttons & Dock**:
   - Added option `4` (`视频同款底色（非玻璃）`) to `Dock 材质` (`FanqieX.DockMaterial.1`) and added `短剧按钮底色` (`FanqieX.DramaButtonSurfaceStyle.1`: `默认液态玻璃` / `视频同款底色（非玻璃）`).
   - Renders calibrated matte cool porcelain `#EEEDF0` (`alpha 0.965`, `0.5pt` `#D2D1D6` border) with strictly zero `UIGlassEffect` and zero `UIBlurEffect` across Dock (native platter, proxy, detached circle), top category capsule, top search button, right-rail interaction buttons (`点赞/评论/收藏/分享`), and all short-drama controls (`查看全集`, `原著`, `弹幕`, `全屏观看`, portrait detail nav, landscape controls) via pure-runtime post-glass hooks in `FanqieXMotion.m` (zero bytes added to `AlignedGlass.s`), with reversible high-contrast dark charcoal `#141316` ink/icon adaptation.

4. **Cold-Start & Long-Idle First-Swipe Reliability Fix for TikTok / Siri AI Dock Motion**:
   - Added Phase-1 `UIWindow -sendEvent:` pre-pan attachment on `UITouchPhaseBegan` (`prepareForTouchOnView:`), ensuring every ancestor `UIScrollView` under the finger has `handleFeedPan:` attached and any stale `_feedPan` is cleared before UIKit begins recognizing the pan.
   - Added `Changed`-state mid-swipe adoption if `Began` was missed, `UICollectionView` / `UITableView` `didMoveToWindow` hooks, deeper window scan (`depth <= 36`), cold-start delayed rescans, `UIApplicationDidBecomeActiveNotification` stale-pan reset & rescan, and offscreen `FQVTransitionView` filtering.

## Verification
- C11 unit tests (`-Wall -Wextra -Werror`) covering `FQXLayoutAndSheetPolicy.h` and `FQXSiriaiDockMotion.h`.
- Full 71-step `scripts/verify162.py --version 2.0.1beta11` reproducible build & audit verification.
- GitHub Actions macOS Xcode 27 arm64 dylib build, legacy 1.6.2 signing compatibility, and verify workflows.
- Physical iOS device visual validation pending on user's device.
