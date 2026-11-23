# FanqieX 1.9.5beta8 Repair Notes

- Target branch: `test`
- Baseline: `1.9.5beta7` (`fe8ef66fb530817ab81437c6d9f3b55c89f74d22`)
- `device_tested`: `false`

## Evidence Analyzed

- Real-device diagnostic JSON (`iOS 27.3 Build 24C5049f`, Fanqie `7.4.5`, `pluginVersion: "1.9.5beta7"`): `21C95F50-3AC3-4556-8030-E3EA28A90637(1).json`
- Real-device screenshots:
  - Screenshot 1 (`media_1795426345378_931d95f9.jpg`): Short Drama Share Sheet (`迷雾替换 >`, `分享至`, `微信 / 朋友圈 / 抖音好友 / 复制链接 / 微博 / QQ`) rendered as an opaque white sheet; `share_panel_styled` never fired because `#910` pushed a modal `UINavigationController` sheet whose `/share_strategy/v1/info/` completed `326ms` later.
  - Screenshot 2 (`media_1795426384719_77b88cb0.jpg`): Novel Reader Share Sheet (`rootClass: "SSReadingSharePanel"`, `sheetClass: "UIView"`, `sheetFrame: [0, 0, 440, 334]`, `materialStyle: 1`, `blurPercent: 0`) looked like flat gray Gaussian blur without Liquid Glass specular rim highlight or crisp background clarity.
  - Screenshot 3 (`media_1795426422075_9cda2586.jpg`): confirmed `分享页面材质 = 液态玻璃` and `分享页面模糊程度 = 0%`.
  - Also verified `顶部按钮大小` worked on real hardware (`buttonScalePercent: 70`, `outerHeight: 27`, `outerCenterDeltaX: 0`).

## Root Causes & Fixes (`native/FanqieXMotion.m`)

### 1. Fix Novel Share Sheet Rendering Like Flat Blur Instead of Clear Liquid Glass
- **Root causes**:
  - `SSReadingSharePanel`'s bottom card (`UIView [0,0,440,334]`) retained host `layer.mask` / `clipsToBounds` / `layer.cornerRadius` (forcing Core Animation offscreen compositing that degrades `UIGlassEffect` and clips off its top specular rim), and `FQXApplyShareSubtreeCleanup` did not neutralize host `UIVisualEffectView` (`UIBlurEffect`) or full-bleed background `UIImageView`/`CALayer` layers.
  - `FQXStyleShareSheet` forced `surface.overrideUserInterfaceStyle = UIUserInterfaceStyleLight` and cleared `gv.backgroundColor` on Clear Liquid Glass, unlike the verified Comment Sheet (`FQXSyncCommentSurface`), which uses `UIUserInterfaceStyleUnspecified` and leaves `FQXCommentGlassSurfaceView` layer defaults intact for crisp transparent refraction and rim highlights.
  - Because `card` was plain `UIView`, `FQXEnsureShareSheetClassHooked` skipped hooking `SSReadingSharePanel.layoutSubviews`.
- **Fix**:
  - Directly hooked `SSReadingSharePanel` (`layoutSubviews` + `didMoveToWindow`) and hooked both `root` and inner custom view classes (via crash-safe weak `FQXShareWeakBox` references).
  - Added `FQXSetShareSheetHostClipping` to save & clear `layer.mask`, `clipsToBounds`, `layer.cornerRadius`, and full-bleed host `CALayer` backdrops on `sheet` and full-size wrappers (restoring cleanly on `原版默认`).
  - Neutralized all non-FQX `UIVisualEffectView`s (`FQXNeutralizeHostEffectView`) and hid full-bleed background `UIImageView`s inside styled share sheets.
  - Matched Comment Sheet's verified Clear Liquid Glass compositor policy (`surface.overrideUserInterfaceStyle = UIUserInterfaceStyleUnspecified`, `[UIView performWithoutAnimation:^{ gv.effect = glassEffect; }]`, `FQXApplyCommentCornerConfig` top-sheet radius).
  - Enriched `share_panel_styled` diagnostics with `surfaceEffectClass`, `surfaceOverrideStyle`, `sheetHadMask`, `sheetHadClips`, `neutralizedEffects`, `monochromeIcons`, and `subviewSummary`.

### 2. Fix Short Drama Share Sheet Detection & Styling
- **Root causes**:
  - Short Drama presented its share sheet via a modal `UINavigationController` (`#910`) and populated share channels asynchronously after `/share_strategy/v1/info/` returned (`326ms`), missing our `0/100/280ms` inspection window, `depth > 9` limit, and `_UI*` sheet container skip.
- **Fix**:
  - Added `UINavigationController.pushViewController:animated:` (`v28@0:8@16B24` / `v32` fallback), `UIViewController.viewDidAppear:` (`v20@0:8B16`, installed after subclass hooks), `UIWindow.makeKeyAndVisible`, and 4-encoding fallback on `presentViewController:animated:completion:`.
  - Extended async inspection cadence to `0ms / 140ms / 380ms / 720ms`, allowed `_UI*Sheet*` / `_UI*Transition*` / `_UI*DropShadow*` / `_UI*Presentation*` containers, raised marker search depth to `16` / budget `320` / BFS `140`, added `"分享至"` & `attributedText`/`accessibilityLabel` matching, and added `FQXFindVisibleDramaVCInWindow` so Short Drama always resolves `isDark = YES`.
  - Dynamically hooked custom share `UICollectionViewCell` subclasses (`FQXEnsureShareCellClassHooked`) so asynchronously loaded or scrolled-in cells immediately receive transparent backgrounds and monochrome logos.

### 3. Unified Monochrome Pure-Black / Pure-White Share Channel Logos
- Added `FQXMakeMonochromeShareLogoImage(UIImage *orig, BOOL isDark)` with `NSCache` caching and `UICollectionViewCell` reuse-safe original image tracking (`FQXShareSavedOrigImageKey` + `FQXShareAppliedMonoImageKey`):
  - Samples the outer ring of solid colored/dark circular icons (`微信`, `朋友圈`, `抖音好友`, `发布到抖音`, `复制链接`, `微博`, `生成分享图`, `QQ`) and projects pixel RGB onto `(bg -> white)` to extract smooth anti-aliased foreground logos, re-centering & optically balancing them (`~68%` canvas, max `1.32x`) in pure black (`#000000`, light mode) or pure white (`#FFFFFF`, dark/night mode & Short Drama dark video).
  - Also supports white-disk icons, standalone transparent-background icons, `UIButton` icon images, circular badge container clearing, grabber pill tint adaptation, and full restoration to native colored icons when switched back to `原版默认`.

## Protected Files

- `native/AlignedGlass.m`: untouched
- `native/AlignedGlass.s`: untouched
- `native/FQXBlurControl.h`: untouched
