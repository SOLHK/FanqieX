# FanqieX 1.9.1beta4 Repair Notes

## Root Causes & Fixes

1. **短剧与小说评论区点击闪退修复 (`native/FanqieXMotion.m`)**
   - 根因：在 `1.9.1beta3` 中，`FQXApplyUnifiedSurfaceCorners()` 切换到 `iOS 18 高斯模糊`（或由旧版 `CommentGlassFrosted` 偏好迁移触发）时调用了 `-[UIVisualEffectView setCornerConfiguration:nil]`。在 iOS 26/27 上 `setCornerConfiguration:` 参数为 `nonnull UICornerConfiguration *`，传入 `nil` 会立刻抛出 `NSInvalidArgumentException` 导致短剧评论区与小说评论区双双闪退。
   - 修复：
     - 彻底移除 `setCornerConfiguration:nil` 调用。
     - 新增 `FQXEnsureUnifiedGlassView()`，在 `UIGlassEffect` 与 `UIBlurEffect` 之间切换时重建干净的 `UIVisualEffectView`，避免原地切换材质导致的内部断言与圆角状态冲突。
     - `FQXCurrentCommentMaterialMode()` 清理废弃的 `LegacyCommentGlassFrostedPrefKey` 并默认使用深色液态玻璃（`0`），同时加固 `FQXBoostCommentTypography()` 与 `FQXReapplyAllTrackedCommentGlass()` 的方法签名与哈希保护。

2. **底栏 Dock 最左侧 / 最右侧按钮交互动画闪出液态玻璃外修复 (`native/FanqieXMotion.m`)**
   - 根因：`FQXTabBarInteraction` 的 `pillView` 直接挂在非裁剪的 `overlay` 上，在最左（书城）/ 最右（我的）按钮触发 Q 弹弹簧超调与水平拉伸时，胶囊滑块会溢出液态玻璃外沿约 15–20pt。
   - 修复：
     - 新增与液态玻璃底栏轨道完全等大、连续圆角（`H * 0.5`）的 `pillClipView`（`clipsToBounds = YES`），将 `pillView` 挂载在 `pillClipView` 内，从几何与渲染层彻底杜绝滑块超出玻璃外沿。
     - 针对首尾边缘按钮细调弹簧 `bounce`、水平拉伸幅度与按压微膨胀范围，保留丝滑 Q 弹手感的同时不贴边生硬截断。
