# FanqieX 1.8R17 Release Notes

## 全局 Liquid Glass UI 升级（参考酷安 iOS 26 悬浮底栏 + 适配 CYLTabBarController）
1. **统一原生液态玻璃引擎（`FQXUnifiedGlass`）**：
   - 在 `native/FanqieXMotion.m` 建立面向 Dock 栏、短剧评论区、小说阅读评论区及悬浮交互胶囊的统一原生玻璃工厂（`FQXGlassRole` + `FQXMakeUnifiedGlassEffect` + `FQXNewUnifiedGlassView`），仅调用官方公开 `UIKit` API（iOS 26+ 使用 `UIGlassEffectStyleClear`，低版本自动降级 `UIBlurEffectStyleSystemThinMaterial / SystemChromeMaterial`，并遵循系统「降低透明度」设置）。
   - 研究并最小侵入式适配开源项目 [ChenYilong/CYLTabBarController](https://github.com/ChenYilong/CYLTabBarController)（MIT 许可证，详见 `THIRD_PARTY_NOTICES.md`）的 iOS 26 液态玻璃动态背景重采样机制（`FQXScheduleCYLGlassResample`），在不替换宿主 `SSTabBarController` 的前提下，切页后下一轮主线程自动重采样底部滚动视图，消除浅/深色页切换时的底色残留。
2. **底部 Dock 升级为酷安同款清透液态玻璃（图六～图十）**：
   - 将悬浮 Dock 材质升级为 `UIGlassEffectStyleClear`（`style = 1, interactive = YES, tintColor = nil`），去除乳白色重模糊与多余灰色遮罩、隐藏重复玻璃兄弟层，并将静息选中胶囊柔化为轻盈半透明质感，使后方文字、图片轮廓清晰透射并保留细腻边缘高光。
3. **图一：小说评论区活动横幅开关 + 段评正文高亮白字修复**：
   - 新增开关 **隐藏评论区活动横幅**（`FanqieX.CommentActivityBanner.1`，位于 `阅读 / 阅读页面净化 / 正文与底栏`），挂钩 `FQCShortVideoCommentTitleView` 隐藏活动条并自动回收顶部高度。
   - 修复 `YYLabel` / `FQCCommentContentLabel` 因使用 CoreText `CTForegroundColor` 与缓存 `YYTextLayout` 导致正文仍呈黑色的问题；同时挂钩 `FQCParagraphV1ListCell` 与 `FQCParagraphReplyV1ListCell`，确保段评与回复正文在所有阅读背景下均清晰呈现高亮白色。
4. **图二 & 图五：短剧评论区真正液态玻璃 + 新增「打开评论区短剧画面不上移」开关**：
   - 统一短剧评论面板为 `FQXGlassRoleCommentSheet` 清透液态玻璃，补充 `0.5pt` 顶部折光高光边与自适应亮度背衬，避免在黑底下呈现纯黑实体块。
   - 新增开关 **打开评论区短剧画面不上移**（`FanqieX.DramaCommentNoVideoShift.1`，位于 `短剧 / 播放设置`，默认关闭），挂钩 `FQVTransitionView`、`FQVTransitionPlayerTopContentView` 与 `FQVTransitionPlayerLimitScaleTopContentView`，开启后打开评论区视频保持全屏原位在液态玻璃后流畅播放。
5. **图三 & 图四：修复听读悬浮菜单左滑双菜单与掉出底部不可见**：
   - 挂钩 `SSAudioPlayIndicatorView`（`showInView:position:`、`setFrame:`、`layoutSubviews`、`willMoveToSuperview:`），在窗口级自动去重避免左滑返回时同时出现两个听读悬浮菜单，并将悬浮菜单纵横坐标严格钳制在阅读底栏与 Dock 之上可见可点击区域内。
