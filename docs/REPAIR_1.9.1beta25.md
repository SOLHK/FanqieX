# FanqieX 1.9.1beta25 修复说明

> 说明：本版为基于 `1.9.1beta24` 源码与启动链路静态/回归审计的紧急修复版本，当前构建仅在 CI 环境完成编译与机器校验，`device_tested: false`。

## 一、1.9.1beta24 卡开屏启动冻结的根因定位与修复

1. **修复书架数据源回调内同步调用 `visibleCells` 引发 UIKit 重入/主线程卡死（`native/FanqieXCleanup.m`）**
   - **根因**：`1.9.1beta24` 在 `ShelfHasRealBooksNow`、`ShelfSyncColdStartVisibility` 与 `ShelfRefreshVisibleHeaderLayout` 中调用了 `UICollectionView.visibleCells`，并在 `numberOfSectionsInCollectionView:`（`ShelfRecNumberOfSections`）、`cellForItemAtIndexPath:`（`ShelfRecCellForItem`）、`viewForSupplementaryElementOfKind:`（`ShelfRecSupplementaryView`）、`viewWillAppear:`（`ShelfWillAppear`）以及新增的 `viewDidLoad`（`ShelfViewDidLoad`）中同步触发；此外 `ShelfRestoreColdStartMutedViews` 即使未静音任何视图也会无条件触发 `visibleCells` 与 `[collection setNeedsLayout]`。在启动页直达书架场景下，`visibleCells` 会迫使 UIKit 同步执行布局并再次重入数据源方法，导致开屏阶段主线程死循环或卡死。
   - **修复**：
     - 移除 `SSBookShelfSubViewController viewDidLoad` 挂钩（`NativeShelfViewDidLoad` / `ShelfViewDidLoad`），取消 `ShelfWillAppear`/`ShelfAppeared` 的原生前调用，以及移除数据源回调中的 `ShelfSyncColdStartVisibility` 同步扫描。
     - `ShelfHasRealBooksNow`、`ShelfSyncColdStartVisibility` 与 `ShelfRefreshVisibleHeaderLayout` 改为仅检查已挂载的 `subviews` / `backgroundView`，彻底消除对 `visibleCells` 的调用。
     - 将 1.35 秒兜底计时器抽离为 `ShelfEnsureColdStartRestoreTimer`，为 `ShelfSyncColdStartVisibility` 增加重入锁 `ShelfColdStartSyncInFlight`；`ShelfRestoreColdStartMutedViews` 仅在实际恢复过静音视图且允许刷新时才通过 `dispatch_async` 异步触发头视图布局更新。
     - `ShelfRecRestoreController` 恢复通过 `[views allObjects]` 安全快照遍历 `NSHashTable`。

2. **修复 `FQXHotPrefsGet()` `dispatch_once` 内删键触发通知重入死锁（`native/FanqieXMotion.m`）**
   - **根因**：`FQXHotPrefsGet()` 在 `dispatch_once(&legacyOnce, ...)` 中调用 `[ud removeObjectForKey:...]`，删除偏好键会同步派发 `NSUserDefaultsDidChangeNotification`，一旦宿主或插件观察者在同一线程再次读取偏好设置即会重入同一个 `dispatch_once` 导致启动死锁，且 `gFQXHotPrefs` 读写缺少线程互斥保护。历史键清理已由 `FanqieXCleanup.m` 的 `FQXPurgeHistoricalResidueImpl` 在启动 3 秒后后台队列执行。
   - **修复**：移除 `FQXHotPrefsGet()` 中的 `dispatch_once` 及删键逻辑，改为基于 `_Atomic uint64_t` 代次与 `pthread_mutex_t` 值拷贝快照的 `FQXHotPrefsSnapshot()`；`FanqieXMotion.m` 与 `FanqieXCleanup.m` 的 `NSUserDefaultsDidChangeNotification` 观察器（`queue:nil`）仅执行无锁原子自增，彻底避免启动期间的锁竞争与死锁。
   - 将 `FQXAppIsInNightMode` 中的宿主类解析改为按需懒查找，避免类尚未加载时永久缓存 `Nil`。

3. **消除短剧顶栏与「我的」卡片布局回调中的 UIKit 重入及弱引用解包风险（`native/FanqieXMotion.m`）**
   - **短剧顶栏（`FQXAlignDramaHeaderCapsuleAndSearch`）**：移除 `layoutSubviews` 路径中的同步 `[searchBtn layoutIfNeeded]`，改为单遍读取原生按钮玻璃尺寸、增加 `FQXDramaHeaderAlignInFlight` 重入保护及 `HookDramaTabsLayoutForCapsule` 守卫，并将几何比较容差放宽至 `0.5 pt`，避免与 `AlignedGlass.m` 产生往复重排。
   - **「我的」快捷入口 4 图标**：
     - `FQXFindMineCollectionView` 移除 `visibleCells` 与 `FQXMineTotalItemCount` 调用，仅扫描已挂载 `subviews`。
     - `FQXCollectMineDelegateTargets` 移除直接读取可能为 `__weak` 成员变量的 `object_getIvar`，改为先校验 `@16@0:8` 方法签名再通过安全 ObjC Getter 探测转发目标。
     - `FQXApplyMineCellLayoutAttributes` 与 `FQXRewriteMineCellFrame` 不再在 `applyLayoutAttributes:`/`setFrame:` 内同步调用 `FQXSyncMineFlow`/`invalidateLayout`，改为调用 `FQXScheduleDeferredMineCollectionPass` 在下一主队列周期延迟初始化并重排。
   - 为 `FQXComputeSheetYieldBottomY`、`FQXResyncVisibleCommentSheetYields` 与键盘通知中的 `NSHashTable` 遍历补充 `.allObjects` 快照，防止枚举期间集合变更崩溃。

4. **保留 `1.9.1beta24` 的既有修复能力**
   - 保留短剧顶部胶囊与右上角搜索按钮高度对齐、短剧与小说评论区底部悬浮液态玻璃发评输入框与无接缝 `Regular`/`Clear` 面板、「我的」快捷入口 4 图标分页及 `1.35s` 书架冷启动空白占位定向抑制与高频偏好缓存。
