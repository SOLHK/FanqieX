# FanqieX 1.9.5beta5 修复说明

- **版本标识**：`1.9.5beta5`（Mach-O 版本常量 `0x15505`）
- **目标分支**：`test`（基于 `1.9.5beta4` / `0f78201ab3321bf8c270ea00f67104a87a112a94`）
- **实机验证状态**：`device_tested: false`（基于第二台实机 `iOS 27.2 Build 24B119 / 番茄 7.4.3` 的完整诊断 JSON 与实机截图定位根因并完成修复与 CI 校验，待真机安装确认）

## 一、基于第二台设备日志（`4A091239-...json`）与截图的根因事实

1. **短剧顶部胶囊中间出现大段空白（`[推荐      最近 收藏]`）且选中胶囊在黑底视频下不可见**
   - **空白间隔根因**：该设备隐藏了中间短剧子标签（如「看剧」「漫剧」）。`AlignedGlass.m` 中 `DramaCategoryCellSize` 仅将隐藏项宽度压到 `0.5pt`，但 `UICollectionViewFlowLayout` 仍会在每个 `0.5pt` 隐藏单元格两侧插入完整的 `minimumInteritemSpacing`（约 `20pt`），隐藏 2 项时累计产生约 `60pt` 空白，同时撑宽并拉偏顶部玻璃胶囊。
   - **选中胶囊不可见根因**：`1.9.5beta4` 静止态深色模式下使用 `colorWithWhite:0.0 alpha:0.18`（18% 黑色），叠加在 `#1D1D1D` 纯黑横屏视频黑边上近乎完全不可见。
   - **极性回退**：`drama_top_glass_material` 日志显示 `darkSource: "default_dark"`，因未回查 `tabs.delegate.curTabIndex` 及可见 cell 文字颜色。
2. **底栏「我的」独立按钮不显示**
   - 日志证据交叉印证该设备当前处于 **`FanqieX.BottomMine.1 == NO`（「底栏显示：我的」关闭）** 状态：
     1. 跨 3 次启动会话，`glassInteractionChildren` 中始终仅有 3 个宿主 `UIButton`（`书城 / 短剧 / 书架`），`dock_detached_state` 显示 `totalVisibleModules: 3`。
     2. 启动时 `SSMyUser621ViewController` 曾被宿主原始方法创建，随后被 `TabPlan` 按 `FanqieX.BottomMine.1 == NO` 从 `SSTabBarController` 移除。
     3. 用户在短剧页（`selectedIndex = 1`）直接弹出设置页，触发的正是 `AlignedGlass.m` 仅在 `!DefaultEnabled("FanqieX.BottomMine.1")` 时才安装的 `0.75s` 长按底栏恢复手势。
   - 当用户曾关闭「底栏显示：我的」后再打开「启用 Dock 独立圆形模块」或选择「我的」时，旧版既不提供一键恢复，也没有刷新 `SSTabBarController`，导致独立圆键静默不显示且日志只记录 `detachedEnabled: 0`。
3. **iOS 27.2 兼容布局下 `dock_glass_material` 84 次反复 `hostReset` 触发日志限流**
   - 日志显示在 `iOS 27.2 (Build 24B119)` + `hostDesignRequiresCompatibility: true` 环境下，原生 `UITabBar` 使用 `UIKit._UITabBarItemPlatterView`。旧版 `FQXGlassEffectNeedsStyleReapply` 通过读取 `UIGlassEffect.style == 0` 判断重置，导致每次布局误判 `hostReset: true` 并反复写入 `effect`（单会话触发 84 次并挤占 `hubDroppedByRateLimit: 217` 条日志）。

## 二、核心修改

1. **短剧顶部隐藏子标签空白消除 + 深色选中胶囊修复（`native/FanqieXMotion.m`）**
   - 新增 `FQXDramaCompactLayout`（仅通过关联键 `FQXDramaCompactLayoutActiveKey` 精准作用于短剧顶部 `collectionViewLayout`，其余列表零影响）：Hook `layoutAttributesForElementsInRect:`、`layoutAttributesForItemAtIndexPath:` 与 `collectionViewContentSize`，当存在隐藏的 `<= 2.0pt` 项时实时折叠多余间距并复制返回紧凑坐标。
   - 由于 `AlignedGlass.m` 的 `DramaCategoryLayoutFrame` 直接读取 `layoutAttributesForItemAtIndexPath:`，顶部文字间距、点击热区、拖拽过渡、外层玻璃胶囊宽度与居中位置一次性全部自动对齐。
   - 修复深色背景静止态选中胶囊填充色为 `[UIColor colorWithWhite:1.0 alpha:0.16]`（纯黑黑边下清晰可见、不叠双层玻璃不发白）；浅色背景维持 `[UIColor colorWithWhite:0.0 alpha:0.08]`。
   - 完善 `FQXDramaHeaderHostIsDark`（补充 `curTabIndex` 与 `visibleCells` 墨色采样）并向 `drama_top_glass_material` 补充 `pillFrame`、`pillHidden`、`selectedIndex`、`hiddenItemCount`、`compactedRemovedGapPt`。
2. **底栏独立模块一键恢复与完整诊断（`native/FanqieXDetachedDock.h`、`native/FanqieXDetachedDock.m`、`native/FanqieXSettingsMenu.m`、`native/FanqieXMotion.m`）**
   - 新增 `FQXDockBottomPrefKeyForModuleTitle`、`FQXDockIsModuleAllowedByBottomPrefs`、`FQXDockDetachedAllKnownModules`、`FQXDockRestoreBottomEntryForModule` 与 `FQXDockDetachedResolveIndexWithReason`。
   - 当用户打开「启用 Dock 独立圆形模块」开关或于「选择独立模块」中点选被隐藏的模块（如 `我的（已隐藏·点选恢复）`）时，自动将对应 `FanqieX.Bottom*.1` 恢复为 `YES` 并调用 `SSTabBarController refreshTabBar` 即时重建 4 键与独立圆键，无需重启 App；设置页副标题与对应开关同步刷新。
   - 强化 `dock_detached_state` 诊断输出：`prefEnabled`、`detachedActive`、`storedModule`、`detachedModule`、`resolvedIndex`、`visibleTitles`、`bottomMineEnabled`、`inactiveReason`。
3. **消除 iOS 27.2 `_UITabBarItemPlatterView` 误判循环（`native/FanqieXMotion.m`）**
   - 新增 `FQXPlatterAppliedEffectKey` 记录实际安装的 `UIVisualEffect` 实例，仅当 UIKit 真正替换对象或回退为 `UIBlurEffect`/`nil` 时才触发 `hostReset`，并将同级清理同时覆盖 `_UITabBarPlatterView` 与 `_UITabBarItemPlatterView`。

## 三、未修改的受保护文件
- `native/AlignedGlass.m`（未修改）
- `native/AlignedGlass.s`（未修改）
- `native/FQXBlurControl.h`（未修改）
