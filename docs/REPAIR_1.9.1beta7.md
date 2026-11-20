# FanqieX 1.9.1beta7 Repair Notes

## Changes

1. **修复点短剧评论区卡死与点读书评论区卡顿 (`native/FanqieXMotion.m`)**
   - 根因：在 `1.9.1beta6` 中，`FQXTabBarInteraction syncWithBar:` 每次调用 `[bar bringSubviewToFront:self.nativeDockBar]`，与 `AlignedGlass.m` 中 `[bar bringSubviewToFront:compactButton]` 互相抢占 `lastObject`，在打开评论区触发底栏布局时引发 250Hz 无限 `layoutSubviews` 死循环（日志中连续触发 5,559 次 `bottomAppearance178`），导致主线程卡死。
   - 修复：改为仅在 `nativeDockBar` 位于 `overlay`/`proxy` 之下时执行一次 `insertSubview:aboveSubview:`，彻底消除布局死循环。

2. **还原底栏 Dock 图标大小与精细线宽 (`native/FanqieXMotion.m`)**
   - 仅调整 `FQXDockItemImage` 图标字重与字号（`UIImageSymbolWeightRegular` + `iconPointSize * 0.72`），保持与旧版图二一致的大小与纤细线条，不改动任何其他底栏交互与外观。

3. **短剧顶部频道胶囊引入 DYKiller 交互动画与长按玻璃浮现 (`native/FanqieXMotion.m`)**
   - 引入 `FQXFlexGlassView`（重写 `-_flexInteractionGestureView` 桥接 iOS 26/27 原生 `_UIGlassFlexInteraction`）与 `FQXDramaTopCapsuleInteraction`，参考 `DYKiller/DKTopChannelCapsule.m` 为短剧顶部「推荐 / 看剧 / 漫剧」胶囊增加按压玻璃浮现、长按拖选平滑插值与触感反馈。

4. **新增「听书界面液态玻璃」独立开关 (`native/FanqieXMotion.m`, `native/FanqieXCleanup.m`, `native/FanqieXSettingsBackup.m`)**
   - 新增偏好 `FanqieX.AudioLiquidGlass.1`（默认关闭，保持番茄小说原书听书界面）；开启后听书页按钮与控制栏即时切换为液态玻璃样式。

5. **增强设置搜索匹配能力 (`native/FanqieXSettingsMenu.m`)**
   - 扩充同义词归一（如 `dock/底栏`、`毛玻璃/磨砂/高斯模糊`、`黑夜/暗黑/深色`、`看书/读书/小说/阅读`、`剧评/段评/评价/评论`、`液态玻璃/玻璃`、`语音/朗读/听书`、`屏蔽/拦截`）并补全全部设置项正反向关键词别名。
