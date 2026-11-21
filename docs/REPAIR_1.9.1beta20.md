# FanqieX 1.9.1beta20 修复说明

1. **评论区原生双液态玻璃（Clear / Regular）与独立高斯模糊全面重构**：
   - 将评论区材质扩展为 5 项：`原版默认`（`0`）、`清透玻璃`（`1`，`UIGlassEffectStyleClear`）、`模糊玻璃`（`4`，`UIGlassEffectStyleRegular`）、`高斯模糊`（`2`，独立连续 1% 步进实时模糊）、`原书底色`（`3`）。
   - `清透玻璃` 与 `模糊玻璃` 彻底分离：去除叠加在玻璃上的普通 `CABackdropLayer` 模糊与灰色/白色/黑色蒙层（`scrim`）；`模糊玻璃` 使用原生 `UIGlassEffectStyleRegular` + `tintColor = nil` + `overrideUserInterfaceStyle` 明暗适配，浅深色切换不再重建 `UIGlassEffect`；`清透玻璃` 使用原生 `UIGlassEffectStyleClear`（浅色透明无遮罩、深色 `white:0 alpha:0.30`），在系统降低透明度辅助功能下自动平滑降级。
   - **独立高斯模糊 1% 精确调级（0%–100%）**：采用独立 `CABackdropLayer` + `CAFilter("gaussianBlur")` + `inputNormalizeEdges` 实时通道，`commentPureMode` 下固定恒定采样尺度 `0.5`、温和色彩饱和曲线且零遮罩叠加（`tintOverlay = clearColor`）；滑杆拖动过程中直接就地更新滤镜参数、松手时对齐整数步进，不重建视图、无闪烁跳级。
   - **层级避让、贴合圆角与转场动画**：新增 `FQXCommentGlassSurfaceView`（重写 `_flexInteractionGestureView` 绑定互动视图）与 `FQXComputeSheetYieldBottomY`，使评论面板底部玻璃精准让位到贴边底栏 / 贴边输入框顶部边界（重叠退让并按 `hidden` 隐藏而非设为 0 高度）；面板顶部采用 `UICornerConfiguration` 的 `containerConcentricRadiusWithMinimum:`、底栏采用 `fixedRadius:0.0` 平直贴边、悬浮分离卡片采用 `26pt` 连续圆角、写书评悬浮按钮采用 `capsuleConfiguration`；移除顶部伪描边及原生玻璃重复阴影，初次挂载以 `effect = nil` 在 `transitionCoordinator` 或 `0.25s` 动画中渐显材质，并监听 `UIWindowScene` 的 `UITraitUserInterfaceStyle` 变更与辅助功能变化，同步覆盖回复/二级评论列表子控制器。
2. **「我的」快捷入口严格固定每页 4 按钮（图一）**：
   - 通过参数个数与返回类型前缀校验 `FQXInstallMineValidatedHook` 替代严格字面量匹配，同步接管 `minimumLineSpacingForSectionAtIndex:`、`minimumInteritemSpacingForSectionAtIndex:`、`shouldInvalidateLayoutForBoundsChange:` 及 `SSScrollFoldFuncView` / `SSMyUserShortcutCell` / `SSMyUserCollectionView1Cell` / `SSMyUserCollectionViewFunCell` / `SSMyUserCollectionViewOrderFunCell` / `SSMyUser621FunctionEntryItemCell`（在 `FQXInstallPostGlassHooks` 挂载于 `AlignedGlass` 之后），并在布局后校验修正可见 Cell 几何帧及普通水平 `UIScrollView` 兜底分页。
3. **书架「去浏览历史」与「导入本地书」卡片净化（图二、图三）**：
   - 新增「隐藏书架浏览历史入口」（`FanqieX.ShelfHistoryCard.1`），同时为「隐藏书架本地书导入入口」（`FanqieX.ShelfLocalImport.1`）补全 BOOL 签名及网格数据源索引重映射，彻底消除网格空白占位并支持设置页即时刷新。
4. **书架顶部导航与筛选栏 14 项独立开关重排（图四）**：
   - 在 `书架净化` 下细分「顶部与统计」「顶部导航栏」「筛选栏标签」子目录，分别支持「书架」「历史」「收藏」「圈子」「搜索」「更多」及「全部」「阅读」「听书」「漫剧」「星标」独立开关，并与原有「阅读时长」「编辑按钮」「筛选按钮」协同重排或整行折叠，关闭任意一项或多项后剩余控件协调排版。
5. **短剧右侧互动栏隐藏「分享」后其余按钮下沉对齐**：
   - 支持遍历多级父容器与 `UIStackView` 包装视图，当「分享」等底部互动按钮隐藏时，上方「收藏」「评论」「点赞」自动下沉对齐底部基线并保持间距一致。
