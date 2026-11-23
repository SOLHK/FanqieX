# FanqieX 1.9.5beta7 Repair Notes

- Target branch: `test`
- Baseline: `1.9.5beta6` (`b2ecd6cf8573597d8078f63241db06a9b2db938d`)
- `device_tested`: `false`

## Evidence Analyzed

- Real-device diagnostic JSON (`iOS 27.3 Build 24C5049f`, Fanqie `7.4.5`, `pluginVersion: "1.9.5beta6"`): `0D4452AB-01D1-45EA-AE09-4920A76D7D5E(1).json`
- Novel Reader share sheet screenshots (`media_1795422902969_183b0814.jpg`, `media_1795422916692_862581ee.jpg`): opaque `#FFFFFF` bottom sheet over warm light reading paper (`微信 / 朋友圈 / 抖音好友 / 发布到抖音 / 复制链接 / 微博 / 生成分享图 / 取消`).
- Feature request:
  1. Support Liquid Glass, Frosted Glass, Gaussian Blur, and Original Book Paper Background (`原书底色`) options for both Short Drama and Novel share pages.
  2. Add customizable Short Drama top button size (`顶部按钮大小`, `70%–130%`).

## Changes

### 1. Unified Short Drama & Novel Share Sheet Material System (`native/FanqieXMotion.m`)
- **Preference keys**:
  - `FanqieX.ShareMaterialStyle.1` (default `1` = `液态玻璃`): `0` 原版默认, `1` 液态玻璃 (Clear Liquid Glass), `4` 模糊玻璃 (Regular Liquid Glass), `2` 高斯模糊 (continuous Gaussian blur), `3` 原书底色 (live sampled Novel Reader paper color or matching theme surface on Short Drama).
  - `FanqieX.ShareBlur.1` (default `0`, `0%–100%`, 1% step): independent blur strength (at `0%` on Liquid Glass/Frosted Glass, adds zero extra blur layer; on Gaussian Blur defaults to `55%` when `0%`).
- **Universal Novel & Drama Share Sheet detection**:
  - Rewired existing `SSVideoSharePanelView` (`layoutSubviews`) and `SSUGKmpSharePanelContainerViewController` (`viewDidLayoutSubviews`) hooks to the unified `FQXStyleShareSheet` pipeline.
  - Added semantic universal detection via `UIWindow.addSubview:`, `UIViewController.presentViewController:animated:completion:` (arm64-verified `"v36@0:8@16B24@?28"` / `"v36@0:8@16B24@28"`), and one-time startup discovery of host `*SharePanel*` / `*ShareSheet*` / `*ShareBoard*` / `*SharePop*` / `*ShareMenu*` / `*ShareDialog*` / `*ShareContainer*` `UIView` subclasses: identifies full-width bottom-anchored cards holding `>= 2` share-channel labels (`微信 / 朋友圈 / 抖音好友 / 发布到抖音 / 复制链接 / 生成分享图 / 微博 / QQ ...`) and dynamically hooks their `layoutSubviews`.
- **Optical & color fidelity**:
  - Clear Liquid Glass (`1`) stays colorless in light mode (`overrideUserInterfaceStyle = Light`, `tintColor = nil`), and only applies dark tint on dark backgrounds when `FanqieX.GlassDarkTint.1` is explicitly enabled.
  - `原书底色` (`3`) samples the live opaque canvas color (or center pixel of full-screen paper texture `UIImageView`) from the active `BDReaderViewController`, computes luminance, and adapts neutral share labels & cancel button ink while strictly preserving colored/dark circular share channel icon badges (`微信 / 朋友圈 / 抖音好友 / ...`) and hairlines.
  - Emits `share_panel_styled` diagnostics recording `sheetClass`, `rootClass`, `materialStyle`, `blurPercent`, `fromReader`, `isDark`, `paperHex`, and `sheetFrame`.

### 2. Customizable Short Drama Top Button Size (`native/FanqieXMotion.m`)
- **Preference key**: `FanqieX.DramaHeaderButtonScale.1` (`70%–130%`, default `100%`, 1% step).
- **Zero-transform vector scaling**:
  - Preserves identity `CGAffineTransform` on all container/label views (preventing Auto Layout / `AlignedGlass` frame corruption).
  - Captures each `SSHGBookStoreCategoryTitleView`'s original `titleFont` once (`FQXDramaBaseTitleFontKey`) and applies crisp scaled fonts (`11pt–22pt`) across `titleFont`, `titleSelectedFont`, cell models, and visible cell labels (`titleLabel` / `maskTitleLabel`).
  - Extends `FQXComputeDramaCompactedRects` to recompute tight cell widths directly from scaled title metrics + scaled inter-item spacing whenever `scale != 100%` or hidden tabs exist, auto-invalidating cached collection layout when the scale changes offscreen.
  - Scales the top category capsule height (`26pt–48pt`), horizontal capsule padding, resting/interactive selection pill padding, and the top-right circular search button (`26pt–48pt` diameter + crisp SF Symbol `magnifyingglass` scaled `14pt–29pt` via `UIImageSymbolConfiguration`) while maintaining Dynamic Island horizontal centering, safe-top clearance, and capsule-vs-search clearance.
  - Logs `buttonScalePercent` and `outerHeight` in `drama_top_glass_material` and `drama_search_glass_material`.

### 3. Settings UI, Live Refresh & Backup (`native/FanqieXSettingsMenu.m`, `native/FanqieXCleanup.m`, `native/FanqieXSettingsBackup.m`)
- Generalized `FQXSettingRow` / `FQXBlurSlider` to support arbitrary min/max/default ranges (`ClampSliderPercent`), preventing 100% ceiling clamping on `70%–130%` scale sliders.
- Added `分享页面材质` + `分享页面模糊程度` in `外观/玻璃效果` (mirrored `分享页面材质` in `短剧/播放设置` and `阅读/阅读设置`) and `顶部按钮大小` (`70%–130%`, ±1% stepper + slider) in `短剧/顶部分类` (mirrored in `外观/玻璃与尺寸` and `短剧/播放设置`).
- Wired live `FQXCleanup.refreshForKey:` updates (including `GlassDarkTintKey` refreshing tracked share sheets) and backup/import schema defaults & range validation in `FanqieXSettingsBackup.m`.

## Protected Files

- `native/AlignedGlass.m`: untouched
- `native/AlignedGlass.s`: untouched
- `native/FQXBlurControl.h`: untouched
