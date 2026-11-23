# FanqieX 1.9.6beta1 修复与新功能说明

- **目标分支**：`test`
- **基线版本**：`1.9.5beta9` (`431850de2f010fad47cec5c1470fe043c08efc05`)
- **目标版本**：`1.9.6beta1` (`0x15601`)
- **实机验证状态**：`device_tested: false`（尚未完成真机验证）

---

## 一、实机问题定位（基于 `215133B8` 日志、录屏 `341.mp4` 与四张实机截图）

> 顺带核验：`215133B8` 日志证实 `1.9.5beta9` 冷启动同步耗时（`diagnosticsInstallComplete -> legacyHooksInstalled`）已由 `1.9.5beta8` 的 **1,076.4 ms** 降至 **36.3 ms**。

1. **短剧顶部胶囊点击/切换选中指示错位 & 图一「收藏」偏位（录屏 `341.mp4` + 图一）**
   - 日志证据：`drama_top_glass_material` 在隐藏「看剧 / 漫剧」后（`visibleIndices: [0, 3, 4]`）记录 `selectedIndex: 0`（推荐）时 `pillFrame` 仍停留在 `[53, 3, 44, 32]`（最近）。
   - 根因一：`FQXDramaTopCapsuleInteraction.currentHostSelectedIndex` 优先读取滞后缓存 `owner.curTabIndex` 而非实时驱动高亮文字的 `tabs.dataSource[i].isSelected`，导致点击或切回「推荐」等标签时选中胶囊读到上一标签索引并回弹到错位位置。
   - 根因二：`HookDramaScrollBetweenTabs` 在跨隐藏标签程序化切页时也将 `interaction.paging` 置为 `YES` 影响胶囊刷新；同时 `FQXAlignDramaHeaderCapsuleAndSearch` 未锁定非溢出态 `collectionView.scrollEnabled`，`JXCategoryView` 点击标签后内部触发 `scrollToItemAtIndexPath:` 产生横向 `contentOffset.x` 偏移，使「推荐」贴边、「收藏」相对胶囊偏左（图一）。
   - 根因三：`FQXEnsureDramaCompactLayoutForCollectionView` 未追踪可见标签位掩码变化，隐藏/恢复子标签后需额外触发重排；`FQXComputeDramaCompactedRects` 左右留白不完全对称。

2. **书架顶部「历史」标签偶发点不动（图四）**
   - 根因一：当用户隐藏尾部标签（如隐藏「收藏 / 圈子」，仅保留「书架 / 历史」）时，`FQXReflowShelfCollectionCells` 仍以硬编码 `gap = 10pt` 直接修改 `cell.frame.origin.x` 而未更新 `UICollectionViewLayout`，导致「历史」按钮视觉位置左移约 10pt、左侧边缘落入 `UICollectionView` `indexPathForItemAtPoint:` 的命中死区。
   - 根因二：`SSBookShelfTabSelectView` 内嵌 `collectionView` 默认可横向滑动，手指微移易被滑动手势拦截；且当 `tabSelectView.selectedIndex` 与 `SSBookShelf525ViewController.currentTabIndex` 短暂不同步时点击会被宿主静默忽略。

3. **新增两项可开关隐藏设置（图二、图三）**
   - **图二**：短剧播放页标题上方「`系列剧·xxx | 共XX万人在追 >`」追剧标签胶囊，新增可开关隐藏项。
   - **图三**：书架 → 历史页（`SSBookHistorySubViewController`）顶部「`全部 | 阅读 | 听书 | 短剧 | 筛选 | 编辑`」筛选与编辑栏，新增可开关隐藏项并在隐藏后无缝收起垂直空白。

---

## 二、本轮修改方案

### 1. 修复短剧顶部胶囊选中同步与对称居中（`native/FanqieXMotion.m`）
- **`currentHostSelectedIndex` 权威优先级重排**：改为优先读取 `tabs.dataSource[i].isSelected`（与高亮标题文字完全同源），其次 `tabs.selectedIndex`，最后才回退 `owner.curTabIndex`，并校验目标项为可见项。
- **精准同步与防卡滞**：新增 `placePillAtIndex:animated:`（优先采用实际可见 `cell.frame`）；`HookDramaScrollBetweenTabs` 仅在用户真实手势拖动原生 `pagerScroll` 时标记 `paging`；`FQXSelectDramaTabIndex`、`HookDramaCommitTabIndex`、`HookDramaTabsRefreshSelectedModels` 均立即清除 `paging` 并即时 + 下一帧同步胶囊位置。
- **消除「推荐 / 收藏」横向漂移与贴边**：`FQXComputeDramaCompactedRects` 统一采用对称左右留白；`FQXEnsureDramaCompactLayoutForCollectionView` 新增可见标签位掩码检测；`FQXAlignDramaHeaderCapsuleAndSearch` 在所有可见标签可完整容纳于顶栏内时锁定 `headerCV.scrollEnabled = NO`、展开不足容器宽度并调用 `setContentOffset:(0, y) animated:NO` 取消宿主异步横滚。

### 2. 修复书架顶部「历史」标签偶发点不动（`native/FanqieXMotion.m`）
- **零死区保留原生布局**：`FQXReflowShelfCollectionCells` 仅在确实存在「前置隐藏标签」位于可见标签之前时才重排并沿用实测原生间距；仅隐藏尾部标签（如保留「书架 / 历史」隐藏「收藏 / 圈子」）时完全保持原生 `UICollectionViewLayout` 坐标，视觉与命中区域 100% 重合。
- **锁定非溢出横滚 + 容错点击桥接（`FQXShelfTabTapBridge`）**：所有可见书架标签未溢出时锁定 `collectionView.scrollEnabled = NO`；并在 `SSBookShelfTabSelectView` 上挂载非拦截并发 `UITapGestureRecognizer`（含 6pt 容错区），仅在原生点击未生效或 `selectedIndex` 与 `currentTabIndex` 不同步时通过宿主原生选择方法补发切换并记录 `shelf_tab_tap_recovery` 诊断事件。

### 3. 新增两项独立开关（`native/FanqieXCleanup.m`、`native/FanqieXSettingsMenu.m`、`native/FanqieXSettingsBackup.m`、`native/FanqieXMotion.m`）
- **短剧 → 播放设置 → 「隐藏短剧系列剧追剧标签」**（`FanqieX.DramaHideSeriesTag.1`，默认关闭）：
  - 在 `FQVShortVideoVPlayerControlView` 与 `SSShortVideoOutterMultiGenreFeedControlView` 中精确定位含「系列剧 / 人在追」且不含「选集 / 观看完整 / 展开 / 作者声明」的外层圆角胶囊容器（不误伤标题与底部选集条），支持即时切换隐藏与无损恢复，并上报 `drama_series_pill_visibility`。
- **书架净化 → 筛选栏标签 → 「隐藏历史页筛选与编辑栏」**（`FanqieX.ShelfHistoryFilterBar.1`，默认显示，设置中反转展示为隐藏开关）：
  - 挂钩 `SSBookHistorySubViewController`（`viewWillAppear:` / `viewDidAppear:` / `viewDidLayoutSubviews`）及书架 Tab 切换回调，兼容整条容器与左右拆分兄弟布局两种宿主结构，隐藏「全部 / 阅读 / 听书 / 短剧 / 筛选 / 编辑」顶栏并自动向上收起列表垂直空隙，关闭隐藏开关后完整恢复原栏位与列表几何，并上报 `shelf_history_bar_visibility`。
- 两项新键均已加入 `FanqieXSettingsBackup.m` 支持配置导入/导出备份。

---

## 三、受保护文件核查

- `native/AlignedGlass.m`：未修改（0 diff）
- `native/AlignedGlass.s`：未修改（0 diff）
- `native/FQXBlurControl.h`：未修改（0 diff）

---

## 四、待实机验收清单（`device_tested: false`）

1. **短剧顶部胶囊（含隐藏部分分类场景）**：仅保留 `[推荐, 最近, 收藏]` 或 `[推荐, 收藏]`，反复点击及左右滑动切换所有标签，确认选中高亮胶囊始终与白色高亮文字严格重合、无错位滞后、且「推荐 / 收藏」左右边距对称不贴边。
2. **图二开关**：在 FanqieX 设置 → 短剧 → 播放设置开启「隐藏短剧系列剧追剧标签」，进入短剧详情/播放页确认「`系列剧·xxx | 共XX万人在追 >`」胶囊消失且不留断层、不影响剧名与选集条；关闭开关后即时恢复。
3. **图三开关**：在 FanqieX 设置 → 书架净化 → 筛选栏标签开启「隐藏历史页筛选与编辑栏」，切到书架 → 历史页确认「全部 / 阅读 / 听书 / 短剧 / 筛选 / 编辑」整栏隐藏且下方三列历史卡片无缝上移；关闭开关后即时恢复。
4. **图四书架「历史」标签点击**：隐藏「收藏 / 圈子」后多次从不同位置（含按钮左半边与边缘）点击「历史」与「书架」反复切换，确认每次均灵敏响应、不再出现点击无反应。
