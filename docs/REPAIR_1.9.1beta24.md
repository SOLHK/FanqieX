# FanqieX 1.9.1beta24 修复说明

## 一、核心修复与优化内容

1. **短剧顶部胶囊与搜索按钮高度对齐**
   - 在 `FQXAlignDramaHeaderCapsuleAndSearch` 中统一短剧顶部栏分类胶囊（`outer`）与右上角圆形搜索按钮（`UIButton` `"搜索"`）的渲染高度与垂直中心线（`minY` / `midY` / `maxY`），并在 `tabContainer` 高度低于目标胶囊高度时放开 `clipsToBounds`。
   - 测量 `glassButtonConfiguration` 实际渲染出的内部原生玻璃视图高度，若与初始目标存在偏差则同步校正分类胶囊高度与搜索按钮纵向偏移，保证左右视觉完全平齐。
   - 将 `SSVideoSeriesFeedHeaderView`（含 `layoutSubviews`、`didMoveToWindow`、`finishSearchIconVisibilityTransition:`、`updateTabViewWithContentSize:`、`layoutTabContainerWithDesiredWidth:baseWidth:reserveSearchButton:`）与 `SSHGBookStoreCategoryTitleView`（`layoutSubviews`）钩子迁入 `FQXInstallPostGlassHooks()`，确保在 `AlignedGlass` 后最终生效。

2. **恢复短剧与小说评论区悬浮发评输入框**
   - 恢复 `FQXStyleCommentBar()` 在评论区面板底部挂载全四圆角胶囊液态玻璃发评栏（`FQXCommentCornerCapsule` + `FQXBarIsFloatingPillKey`），不再因处于 `FQVTransitionView` 或原生评论面板内而整栏剔除发评栏玻璃。
   - 对位于已配置样式的评论面板内部的发评胶囊保留 `gs.disablesSupplementalBlur = YES`，并在 `FQXComputeSheetYieldBottomY()` / `FQXResyncVisibleCommentSheetYields()` 中跳过悬浮胶囊栏，从而在保持 `beta23` 背后整块 `Regular` / `Clear` 面板无水平接缝、0% 模糊纯原生玻璃的同时，让发评输入胶囊清晰浮现并避免列表内容被遮挡。

3. **「我的」快捷入口强制每页 4 图标（全链路修复）**
   - 将 `+[FQXMineShortcutViewport applyToView:enabled:]`（由 `AlignedGlass` 直接调用）接入 `FQXSyncMineContainerUniversal()`，避免宿主/玻璃刷新路径绕过 4 列重排。
   - 修复 `FQXSyncOwnerCollectionFromShortcutCell` 与 `FQXApplyMineCellLayoutAttributes` 中遇到 `cur == SSScrollFoldFuncView` 即提前终止导致无法定位内层 `UICollectionView`/`UIScrollView` 的缺陷；新增 `FQXMineOuterRowForView` 限定外层边界为 `SSMyUserShortcutCell` / 非 VIP `SSMyUserCollectionView1Cell`。
   - 支持通过 `forwardingTargetForSelector:` 与 Proxy 成员变量（`_collectionViewTarget` / `_interceptor` / `_target` 等）解包 `IGListAdapterProxy` / `NSProxy` 委托对象；接入 `targetContentOffsetForProposedContentOffset:withScrollingVelocity:` 保证分页停靠准确，并对非 UIKit 自定义滚动子类加上 `setContentSize:` 护栏。
   - 为 `SSMyUserCollectionViewFunCell`、`SSMyUserCollectionViewOrderFunCell`、`SSMyUser621FunctionEntryItemCell` 全量补齐 `setFrame:` 与 `applyLayoutAttributes:` 拦截，同时兼容 `FQReaderSaaSBookStoreSelectView` 分页指示器。

4. **消除书架冷启动「书架暂无书籍」短暂闪现**
   - 重写 `FanqieXCleanup.m` 的冷启动抑制逻辑：通过 `ShelfViewIsEmptyBookPlaceholder` 精确识别包含「书架暂无书籍 / 去书城找书」的空白占位单元及背景视图，在冷启动后 `3.0s` / 首次展现后 `1.35s` 宽限窗内仅对空白占位视图置为 `alpha = 0.0`（保留顶部栏与「最近看过」）。
   - 一旦检测到任意真实书籍模型/Cell（`ShelfModelIsRealBook` / `ShelfHasRealBooksNow`）或宿主本地书架加载完成，立即解除抑制并放行；若用户书架确实为空，则于 `1.35s` 兜底恢复显示，并补挂 `SSBookShelfSubViewController viewDidLoad` 初始化同步。

5. **冗余代码清理、流畅度与内存优化**
   - 在 `FanqieXMotion.m` 中建立 `FQXHotPrefsCache` 集中缓存高频读取的用户偏好设置，在 `NSUserDefaultsDidChangeNotification` 与 `+refresh*` 变更时按需失效；在 `FanqieXCleanup.m` 中建立互斥锁保护的 `FQXOptionCache`。
   - 使用 `dispatch_once` 与编译期 `@selector(...)` 替换热路径上的重复 `NSClassFromString` / `NSSelectorFromString` 查找，并在 `NSHashTable` 遍历（`FQXComputeSheetYieldBottomY`、`FQXResyncVisibleCommentSheetYields`、`FQXTrackedExpandedComposers`、`ShelfRecRestoreController` 等）中直接迭代哈希表消除临时 `.allObjects` 数组分配。
   - 移除废弃的 `FQXCommentFieldGlassKey` / `FQXToolbarPillSavedBgKey` / `FQXReleaseCommentFieldGlass` 死代码以及重复注册的 `SSBookShelfFunctionCell layoutSubviews` 钩子。
