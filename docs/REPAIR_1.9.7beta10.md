# FanqieX 1.9.7beta10 修复说明

版本标识：`1.9.7beta10`（Mach-O 构建标识 `0x1570A`）

## 根因定位

结合 iPhone 16 Pro Max（iOS 27.3，宿主 `7.4.5.33`）两份现场诊断日志与宿主 ARM64 反汇编，确认 `1.9.7beta9` 存在两类布局/KVO 同步重入回归：

1. **点击底栏「短剧」按钮立即闪退（同步 KVO 无限递归栈溢出）**：
   - 反汇编 `SSVideoSeriesFeedHeaderView -setupScrollMaskLayer`（`0x11057bbb0`）确认宿主对 `collectionView` 注册了 `contentOffset` 与 `contentSize` 两个同步 KVO 监听，回调均直接触发 `[self updateScrollMaskLayer]`。
   - `FQXDramaTopCapsuleInteraction`（`syncWithTabs:` 与 `currentResolvedDarkState`）原先通过 `categories.superview` 查找顶栏，但 `tabContainer` 位于 `simpleHeader` 容器内而非 `SSVideoSeriesFeedHeaderView` 直接子视图，导致 `delegate` 为 `nil`：
     - `FQXAlignDramaHeaderCapsuleAndSearch(header)` 计算可见掩码为 `0x03000007`（且正确解析 `tab_model_bg` 深色）；
     - 紧随其后的 `syncWithTabs:` 因拿到 `simpleHeader` 计算出 `0x03000000`（并误判 `overrideStyle = 1` 浅色），触发 `maskChanged == YES`。
   - `1.9.7beta9` 新增的 `FQXEnsureDramaCompactLayoutForCollectionView` 同步调用 `[layout invalidateLayout]; [cv layoutIfNeeded];`，实时改动 `collectionView.contentSize` 并同步触发 `updateScrollMaskLayer` KVO 回调；同时 `beta9` 新增的 `HookDramaHeaderScrollMaskForCapsule` 无防重入地调用完整 `FQXSyncDramaTopCapsuleForHeader`，形成 `0x03000007 <-> 0x03000000` 同步无限递归，在进入短剧后约 0.17 秒栈溢出闪退。
   - 此外，`beta9` 对继承自 `UIView` 的 `SSVideoSeriesFeedHeaderView -setBounds:` 挂钩会在初始化与动画阶段提前触发顶栏同步；`FQCShortVideoDanmakuABSetting +danmakuConfig` 原生返回 `NSMutableDictionary`，Hook 中返回不可变副本并在可能运行于 `serialSetQueue` 的 `-enableNewGenreDanmaku` 中读取 `UIDevice.currentDevice` 亦存在潜在风险。
2. **`SSBookHistorySubViewController` 子布局重入与懒加载拉锯（暗黑切换与书架/历史/收藏/圈子卡死）**：
   - `1.9.7beta9` 新增的 `categoryLayout`、`loadMaskView:`、`layoutCategoryRightButtons` 三个后置 Hook 均直接无防重入地调用完整 `FQXSyncShelfHistoryFilterBar`。
   - 宿主 `viewWillLayoutSubviews -> categoryLayout -> layoutCategoryRightButtons` 途中被我们修改 `categoryView.frame`（宽度由 ~240pt 扩至 ~416pt）并同步执行 `layoutIfNeeded` / `invalidateLayout`，随后 `categoryLayout` 尾部检测到 `categoryView.bounds` 与 `profileHistoryRevisitCategoryLayoutInputs` 不一致并触发 `[categoryView reloadData]` 与 `retryReloadCategoryIfNeeded`，与 `FQRJXCategoryBaseView::layoutSubviews` 形成 `240pt <-> 416pt` 死循环。
   - 同时直接调用 `rightMaskView`/`rightGradientView`/`leftMaskView`/`leftGradientView` 属性 getter 会触发宿主懒加载分配新视图（暗黑模式 `traitCollectionDidChange:` 也会刷新其渐变层），且在 `loadMaskView:` 早期捕获无效的零宽度 `FQXHistoryLeftSavedFrameKey`。
   - 由于 `FQRJXCategoryListContainerView::layoutSubviews` 会遍历所有已挂载子控制器，即使当前停留在「书架」「收藏」或切换至「圈子」，一旦历史页已挂载或切换命中，主线程即被锁死。
3. **关闭「底栏点击震动」后 Dock 仍会震动（iOS 26/27 原生 `UITabBar` 系统触感未拦截）**：
   - 反汇编 `SSTabBar*` 确认宿主仅在 `-[SSTabBarController impactFeedback]` 中调用 `UIImpactFeedbackGenerator`，原有钩子仅拦截了宿主自身震动。
   - 但在 iOS 26/27 液态玻璃 Dock 模式下，底栏核心胶囊采用真实原生 `UITabBar`（`_nativeDockBar`），点击与滑动液态玻璃透镜时 UIKit 内部的 `_UITabBarPlatterView` / `_UILiquidLensView` 会直接通过 `UIFeedbackGenerator`（`UISelectionFeedbackGenerator` / `UIImpactFeedbackGenerator` 及 `_playFeedback*`）触发系统触感反馈，完全绕过宿主 `impactFeedback`。
   - 同时设置页 `页面与导航/底栏入口` 重建 cell 时未将「底栏点击震动」开关状态从 `FanqieX.BottomHaptics.1` 回刷同步。
4. **书架筛选/顶栏集合视图与数据回调中的同步布局循环隐患**：
   - `FQXReflowShelfCollectionCells` 在 `layoutSubviews` 及每个 cell 的 `layoutSubviews` 中无防重入地同步调用 `[layout invalidateLayout]`，`FQXReflowShelfTabSelectView` 与其争夺 `scrollEnabled`。
   - `FQXSelectShelfCategoryIndex`、`FQXSyncShelfFavoritesFilters`（位于 `cellForItemAtIndexPath:` / `willDisplayCell:` 内）以及 `FQXEnsureDramaCompactLayoutForCollectionView` 存在同步 `layoutIfNeeded` 调用。
   - `FQXShelfTabTapBridge` 在未隐藏任何书架顶栏标签且 `cellFrame == layoutFrame` 时仍触发恢复切页，与原生 UIKit 点击态竞争。
   - `FQXInstallCompactLayoutHooksOnClass` 共享函数派发在父子类均被 Hook 时存在 `[super ...]` 递归隐患。

## 本版修复

- **短剧顶栏 KVO 遮罩解耦与闪退根治**：
  - 将 `FQXDramaTopCapsuleInteraction` 的 `currentResolvedDarkState` 与 `syncWithTabs:` 改为通过 `FQXDramaHeaderForTabs` 解析真正的 `SSVideoSeriesFeedHeaderView`，并在 `FQXEnsureDramaCompactLayoutForCollectionView` 中通过纯 C11 策略 `FQXShouldCommitDramaCompactVisMask` 防止未解析宿主时覆写有效可见掩码，同时一并修正进入短剧首帧的深浅胶囊材质误判。
  - 新增 O(1) 无副作用的 `FQXApplyDramaScrollMaskOnlyForHeader`，让 `HookDramaHeaderScrollMaskForCapsule`（`updateScrollMaskLayer`）仅做 `CALayer.mask` 轻量同步，彻底阻断 `contentOffset`/`contentSize` KVO 引起的布局重入；移除继承自 `UIView` 的 `SSVideoSeriesFeedHeaderView -setBounds:` 与重复的 `SSVideoSeriesFeedViewController -viewDidAppear:` 后置 Hook。
  - `FQXSyncDramaTopCapsuleForHeader` 接入 `FQXShouldRunDramaCapsuleFullSync` 主线程、窗口挂载与防重入校验；加固 `HookDanmakuConfig` 返回 `NSMutableDictionary` 并在主线程初始化时缓存 `gFQXDanmakuIsPhone`。
- **底栏关闭震动全链路生效（宿主 + iOS 26/27 原生 `UITabBar`）**：
  - 将 `FanqieX.BottomHaptics.1` 接入热缓存 `FQXHotPrefsCache`，新增纯 C11 策略 `FQXShouldSuppressDockFeedbackGenerator` 并纳入单测。
  - 在「底栏点击震动」关闭时，除继续拦截宿主 `-[SSTabBarController impactFeedback]` 外，同步精准拦截归属底栏视图树或处于底栏触摸/滑动窗口内的 `UIFeedbackGenerator` / `UISelectionFeedbackGenerator` / `UIImpactFeedbackGenerator` 触感播放，不影响设置开关、滚轮、顶栏拖拽或清屏等其他场景震动；同时在设置页同步回刷并兜底持久化「底栏点击震动」开关状态。
- **历史页遮罩与全量同步彻底解耦**：新增 O(1) 无副作用的 `FQXApplyHistoryEdgeMasksOnly`，仅读取已存在的 `_rightMaskView` / `_rightGradientView` / `_leftMaskView` / `_leftGradientView` / `_rightMaskLayer` / `_leftMaskLayer` / `_filterLineView` / `_modeLineView` 原始 ivar 并更新隐藏状态；`categoryLayout`、`loadMaskView:`、`layoutCategoryRightButtons` 仅调用此轻量函数，不再在子布局中修改 frame 或触发 `reloadData`。
- **完整重入与收敛保护**：为 `FQXSyncShelfHistoryFilterBar`、`FQXReflowShelfCollectionCells` 与 `FQXSyncDramaTopCapsuleForHeader` 添加防重入锁；在 `FQXLayoutAndSheetPolicy.h` 中新增纯 C11 策略函数并通过单测校验初始帧有效性、宽度单调收敛、短剧同步门控与点击恢复门控；确保 `FQRJXCategoryBaseView.collectionView.frame` 始终严格等于 `outerLeft.bounds`。
- **消除同步 `invalidateLayout` / `layoutIfNeeded` 与 `super` 递归风险**：将集合视图布局失效改为合并异步调度；单个 cell 的 `layoutSubviews` 仅同步控制自身可见性并合并异步触发父级重排；移除 `FQXSelectShelfCategoryIndex`、`FQXSyncShelfFavoritesFilters`、`FQXEnsureDramaCompactLayoutForCollectionView` 中的同步 `layoutIfNeeded`；将 `FQXInstallCompactLayoutHooksOnClass` 改为按类独立 block 捕获各自原始 IMP，并在原始布局调用期间保持 `gFQXDramaCompactComputing` 透传保护；`FQXShelfTabTapBridge` 仅在确实发生隐藏重排或坐标偏移时介入。
- **版本更新说明**：插件左上角版本号更新为 `1.9.7beta10`，点击版本号弹出本版修复说明。

## 安装方式

移除旧版 `FanqieX` / `FanqieAdBlock` 动态库后，注入 `FanqieX-1.9.7beta10.dylib` 并重新签名。
