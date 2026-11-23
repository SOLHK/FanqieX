# FanqieX 1.9.6beta4 修复说明

- **版本**：`1.9.6beta4`（Mach-O 构建标识 `0x15604`）
- **基线**：`1.9.6beta3`（`test` 分支）
- **验证状态**：`device_tested: false`（CI 静态审计、构建产物验证与 Xcode 27 交叉编译校验通过；待真机复测确认）

## 一、定位与根因分析（基于实机截图、诊断日志 `BE85B406` 与宿主逆向分析）

1. **短剧顶部胶囊在滑动/切换结尾时左右晃动（图一）**：
   - `BE85B406` 日志记录了完整结尾时序：`39.839s` 时 `ratio` 到达 `0.995`（`x = 52.5`，`pillInteractiveLens = false`），此时 `self.paging` 已提前归为 `NO`，但宿主 `JXCategoryBaseView` 的 `selectedIndex` 仍停留在旧值 `0`，直到 `39.894s`（`+55ms` 后）`commitSelectedTabIndex:1` 才落定到 `x = 53.0`；反向滑切在 `40.655s`（`x = 5.5`）同样存在 `selectedIndex` 滞后窗口。
   - 根因：
     1. 滑切接近终点时 `paging` 先于宿主 `dataSource.isSelected` 更新归零，导致这 ~55ms 空窗期内任意一次 `layoutSubviews -> syncWithTabs:` 都会读到旧选中索引并把胶囊往回拉，随后 `commitSelectedTabIndex:` 到达再弹回目标位，形成结尾往返晃动。
     2. `HookDramaScrollBetweenTabs` 与 `HookDramaTabsRefreshLeftRight` 双路回调在减速末段的 `ratio` 存在微小抖动，且 `placePill:animated:` 使用了欠阻尼弹簧（`damping: 0.86 / initialSpringVelocity: 0.6`），导致点击或收尾动画产生过冲回弹。
2. **「我的」页面快捷功能卡片第一页露出第五个按钮及第二排顶边（图二）**：
   - 对照番茄小说 `7.4.3 / 7.4.5` 宿主结构与 `BE85B406` 日志（`SSMyUserShortcutCell` + `SSScrollFoldFuncView` + `SSMyUserCollectionViewOrderFunCell` / `SSMyUser621FunctionEntryItemCell`，`cellWidth: 60`、`cellHeight: 47`）：宿主默认将第 1 页 4 个单行按钮排在约 `312pt` 宽度内，并让第 2 页（双行网格）从 `x ≈ 312pt` 处提前露边进入 `366pt` 卡片右侧，从而在右侧同时露出第 5 列第 1 排图标与第 2 排圆形顶部残边。
   - 根因：展开后内部滚动容器高度（双行页）超过旧版 `220/240pt` 过滤上限；单元格初次创建执行 `applyLayoutAttributes:` 时 `superview` 尚未挂载且未缓存 `indexPath`；`SSScrollFoldFuncView` 双容器/混合折页布局未将第 2 页整体外推至 `x = cardWidth`；同时 `FQXMineShortcutViewport` 在折叠态底部留有 `+8pt` 余量，暴露了第 2 排顶边。
3. **二进制 `.dylib` 体积升至 `1.55 MB`（系统四舍五入显示 `1.6M`）与运行时内存占用偏高**：
   - Mach-O 结构拆解显示：`1.9.6beta3` 共 `1,552,048` 字节（十进制 `1.55 MB`，iOS 按十进制四舍五入显示为 `1.6 MB`），由两部分组成：固定 `491,520` 字节（`480 KB`）的 ARM64 核心补丁区（`__FQCORETEXT` + `__FQCOREDATA` + 预留容量的 `__FQPATCH`，自 `1.9.1beta18` 起恒定不变）与 Objective-C 功能伴随模块（书城/短剧/书架/听书/灵动岛/评论/分享/备份/导出/诊断）。其中 `__DATA` 段因 `166` 个自引用指针关联键等仅超出 `49,152` 字节页边界 `1,264` 字节，触发 iOS ARM64 `16 KB` 页对齐额外填充了整整 `16,384` 字节零页；同时 `FanqieXMotion.m` 内 `12` 处 `@try/@catch` 异常表与 `215` 处宏内联展开占用了大量 `__TEXT` 空间。
   - 运行时内存方面：`FanqieXDiagnosticsHub.m` 默认在内存中常驻保留 `1,500–3,600` 条嵌套 `NSDictionary` 事件对象（约 `3–5 MB` 堆内存，尽管导出时本身已从磁盘 JSONL 读取），且每条日志均单独执行文件属性查询与句柄打开/关闭，并对被取消的 `.heic` 书封缩略图请求重复记录。

## 二、本轮修复与优化内容

1. **彻底消除短剧顶部胶囊结尾左右晃动（`native/FanqieXMotion.m`）**：
   - 将 `placePill:animated:` 弹簧改为临界阻尼（`damping: 1.0 / initialSpringVelocity: 0.0 / CurveEaseOut`），彻底消除物理过冲回弹。
   - 在 `-updatePillForSwipeFromIndex:toIndex:ratio:` 中优先直接读取底层 `contentScrollView.contentOffset.x / pageW` 单一硬件位移源并钳制橡皮筋越界，消除双回调尾段 `ratio` 冲突；当滑切进入终点阈值（`<= 0.012` 或 `>= 0.988`）时直接吸附到精确终点，并在清除 `paging` 前先行锁定 `lastSelectedIndex` 与 `pendingTapIndex`（`0.35s` 保护窗），杜绝 `syncWithTabs:` 在宿主选中态更新前发生反向回拉。
2. **「我的」页面快捷卡片严格每页四列等宽排布并隐藏第二排露边（`native/FanqieXMotion.m`）**：
   - 放宽内部快捷滚动视图高度识别上限至 `520pt`（排除瀑布流与侧栏），覆盖 `SSScrollFoldFuncView` 双行展开态；在 `applyLayoutAttributes:` 中持久缓存 `indexPath` 并在单元格布局前后双向同步四列槽位几何。
   - 新增 `FQXSyncScrollFoldDualContainerSV` 与分页吸附代理 Hook（`scrollViewDidScroll:` / `scrollViewWillEndDragging:withVelocity:targetContentOffset:`），同时升级 `FQXSyncMineFlow` 原生帧探测（兼容第 1 页单行 4 项 + 第 2 页双行 8 项的折页布局与纯双行网格）：将第 1 页 4 个按钮按 `cardWidth / 4` 全宽均匀排布，将第 2 页起始横坐标严格推至 `x = cardWidth` 屏外，并收紧折叠态 `FQXMineShortcutViewport` 底部裁剪边界，确保第 1 页只显示 4 个按钮、绝不露出第 5 列或第 2 排残边，滑到第 2 页仍完整显示双行四列功能。
3. **大幅降低运行时堆内存占用并压缩 Mach-O 二进制体积（`native/FanqieXDiagnosticsHub.m`、`native/FanqieXMotion.m`、`native/FQXContentCleanup.m`）**：
   - **运行时内存与磁盘 I/O 优化**：将 `gFQXHubRing` 常驻内存上限从 `1500 / 3600` 降至 `48 / 160`（释放约 `3–5 MB` 常驻堆对象），改为 `8 KB` 内存缓冲批量落盘并在导出/退后台/内存告警时自动刷盘清空；过滤 `fqnovelpic.com` / `byteimg.com` 等静态图片请求的取消噪音并用 64 位 Tagged Pointer 短请求号替代每次请求分配 `NSUUID`；为各高频布局诊断点补齐 `FQXDiagnosticsHubIsEnabled()` 前置短路，并在退后台与低内存时主动清空单色分享图标缓存及压缩全部弱引用表。
   - **二进制段体积压缩**：将 `172` 个自引用 `void *` 关联对象键改为零重定位只读常量地址（消除 `__DATA` 段指针占用与冷启动 rebase 开销），合并重复 `FQXShareWeakBox` 到 `FQXWeakBox`，移除 `FanqieXMotion.m` 与 `FQXContentCleanup.m` 中全部 `13` 处 `@try/@catch` 异常表改为直接运行时方法/成员变量访问，并将 `215` 处内联 Hook 注册宏收敛为共用辅助函数 `FQXHookInst`。

## 三、待真机复测项

- **短剧顶部胶囊**：左右慢滑、快滑及点击切换 `推荐 / 看剧 / 漫剧`，确认收尾落定平稳利落、无任何左右晃动或回弹。
- **「我的」快捷卡片**：确认第 1 页严格居中均分只显示 4 个按钮，右侧不再露出第 5 个按钮或第 2 排顶边；左滑至第 2 页双行四列按钮显示与点击均正常。
- **体积与流畅度**：确认新版 `.dylib` 文件体积已显著回落至 `1.5 MB` 以下，冷启动与页面滑动流畅轻快。
