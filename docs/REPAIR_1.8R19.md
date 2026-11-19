# FanqieX 1.8R19 修复与液态玻璃体验优化

## 本次更新内容

1. **修复底部 Dock 液态玻璃交互动画消失（恢复 iOS 26/27 原生交互动画）**：
   - 修复 `FQXUpgradeDockProxyToClearGlass` 在早期 fallback 阶段误将本插件自建的 `UIGlassContainerEffect` 交互容器设为 `hidden = YES` 导致 `dropletView` 动画不可见的根因。
   - 为自建 `UIGlassContainerEffect` 与 `UIGlassEffectStyleClear`（`interactive = YES`）交互镜片打上 `FQXOwnedGlassElementKey` 标记，并在 `ensureDropletMounted` / `startDropletFrom:` 始终确保可见且置于按钮前景层（`userInteractionEnabled = NO`），使点击与滑动切页时实时呈现原生光学折射放大与弹性形变。
   - 修正 `liveDropletFrameInHost:` 仅在动画活跃时读取 `presentationLayer`，避免快速连点读取过期位置。

2. **设置项精简与默认值调整**：
   - 将 `外观 / 玻璃效果` 中的 `评论区模糊液态玻璃（iOS 27 级）` 精简为 **`评论区模糊液态玻璃`**。
   - 将 `外观 / 悬浮底栏尺寸` 中的 **`查看全集与进度条跟随底栏长度`** 调整为**默认关闭**，支持手动开启；恢复默认设置时同步还原为关闭状态。

3. **修复短剧/合集底部胶囊文字溢出**：
   - 在 `AlignedGlass.m` 的 `DramaWatchGlass` 与 `DramaWatchAlbumLayout` 增加 `DramaClampEpisodeText`，自动触发布局刷新并对超出胶囊右边界的标题文本执行宽度钳制与尾部省略（`NSLineBreakByTruncatingTail`），避免长合集标题冲出玻璃胶囊。

4. **修复从阅读页返回书架出现双听书悬浮按钮**：
   - 将全窗口听读悬浮胶囊扫描深度由 9 提升至 20，并新增 `setHidden:`、`setAlpha:`、`didMoveToWindow`、`didMoveToSuperview`、`showInView:position:`（兼容 `CGRect` / `CGPoint`）及 `BDReaderViewController viewWillDisappear:` 钩子，左滑返回瞬间自动隐藏阅读页内冗余胶囊，取消左滑时通过 `transitionCoordinator` 自动恢复。

5. **评论区视觉、文字可读性与净化设置全面升级**：
   - **左右边全覆盖优化**：将评论区与展开输入面板的液态玻璃层左右各外延 `12pt`（底部外延 `28pt`），由宿主容器以 `28pt` 连续顶部双圆角裁剪，移除四边边框并改为仅顶部圆弧高光边，彻底消除左右边缘折射未覆盖缝隙与竖直白线。
   - **评论区文字全面提亮**：重构 `FQXBoostColorForClearGlass`，基于有效亮度（`lum * alpha`）将主正文与黑字提亮至纯白 `100%`，将用户名、时间、回复、占位符等暗淡灰白字提亮至高清晰度 `88%` 白并补充轻微阴影，递归深度提升至 14。
   - **发评论输入文字纯白**：修复 `FQXBoostCommentTypography` 跳过 `isFirstResponder` 的问题，并监听 `UITextViewTextDidBeginEditingNotification` / `UITextViewTextDidChangeNotification` 安全同步纯白输入字色（兼容中文拼音输入法 `markedTextRange`）。
   - **「大家都在搜」字色优化 + 独立关闭开关**：将「大家都在搜：」前缀强制替换为纯白，将蓝色推荐词加深为饱和清晰的鲜亮蓝（`RGB 0.24, 0.62, 1.0`）；新增 **`评论区净化 / 隐藏评论区大家都在搜`** 开关。
   - **评论区公告与活动关闭开关**：升级 **`评论区净化 / 隐藏评论区公告与活动`**，覆盖短剧评论区「公告 · 社区公约」及小说/剧集评论活动横幅，开启后自动隐藏并回收顶部高度。
