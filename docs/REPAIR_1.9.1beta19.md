# FanqieX 1.9.1beta19

基于 `test` 分支的 `1.9.1beta18` 完成四项改进：合并多选设置为图四风格锚定弹窗、解除原书底色对悬浮分离卡片的选择限制，并通用化「我的」快捷入口每页 4 按钮布局。

## 本轮修复内容

### 1. 多项设置统一为锚定液态玻璃弹窗（图一 / 图四）
- **「评论区材质」（`FanqieX.CommentMaterialStyle.1`）**：将「评论区净化」「阅读设置」「短剧/播放设置」「外观/玻璃效果」中原有的 3 个互斥开关（「评论区液态玻璃」「评论区高斯模糊」「评论区原书底色」）合并为单个 **「评论区材质 >」** 弹窗选择器，提供「原版默认 / 液态玻璃 / 高斯模糊 / 原书底色」4 项勾选，保留原有偏好键值与全部搜索关键词。
- **「评论区外观」（`FanqieX.CommentAppearanceMode.1`）**：由行内分段控件改为与「Dock 材质」一致的锚定弹窗选择器（「跟随软件 / 浅色 / 深色」）。
- **「收缩位置」（`FanqieX.BottomDramaCompactPosition.1`）与「默认启动页」（`FanqieX.StartupTab.1`）**：同步由二级推送页面升级为锚定弹窗选择器；「收缩位置」保留「短剧滚动自动收缩」关闭时的置灰不可点击提示，「默认启动页」继续动态过滤底栏已隐藏的页签，并在切换后即时刷新底栏状态。

### 2. 修复「原书底色」下无法选择「悬浮分离卡片」（图二）
- **原因**：`CurrentSavedCommentComposerStyle()`（`FanqieXSettingsMenu.m`）与 `FQXCurrentCommentComposerStyle()`（`FanqieXMotion.m`）此前在 `CommentMaterialStyle == 3`（原书底色）时硬编码强制返回 `0`（原生样式），导致用户在弹窗中点选「悬浮分离卡片」或「贴底液态玻璃」后仍被覆盖回「原生样式」。
- **修复**：移除上述强制覆盖逻辑；仅在用户从未主动设置输入框样式时按材质给出默认值，只要用户主动选择「贴底液态玻璃」或「悬浮分离卡片」，在「原书底色」或「原版默认」下均可正常保存并渲染独立液态玻璃输入卡片。

### 3. 「我的」快捷入口通用 4 按钮分页布局（图三）
- **不再依赖单一容器或标准 `FlowLayout`**：同时由 `SSScrollFoldFuncView`、`SSMyUserShortcutCell` 与 `SSMyUserCollectionViewFunCell` 的 `layoutSubviews` 触发并追踪卡片内的 `UICollectionView`，移除 `estimatedItemSize == CGSizeZero`、`numberOfSections == 1` 与精确类限制，并兼容自定义分页指示器（`numberOfPages` / `currentPage`）。
- **通用 `UICollectionViewLayout` 几何接管**：挂钩卡片布局对象的 `collectionViewContentSize`、`layoutAttributesForItemAtIndexPath:` 与 `layoutAttributesForElementsInRect:`（严格限定于受追踪的「我的」快捷入口卡片实例），按每页固定 4 栏（`width / 4.0`）重新映射跨页索引 `0..3` 与 `4..`，确保第 1 页完整显示 4 个等距圆形按钮、第 5 个起平滑进入第 2 页且不再在右侧裁切露出一半。

## 构建与版本
- 版本号：`1.9.1beta19`（Mach-O 版本字 `0x15113`，扩展页上限维持 `0x64000`）。
- 验证范围：本地 Objective-C 语法/编码静态检查、`test_release_capacity178.py`，以及 GitHub Actions `Xcode 27 plugin build` 与 `Verify FanqieX 1.9.1beta19` 完整工作流。
