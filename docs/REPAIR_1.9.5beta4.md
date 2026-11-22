# FanqieX 1.9.5beta4 修复说明

- **版本标识**：`1.9.5beta4`（Mach-O 版本常量 `0x15504`）
- **目标分支**：`test`（基于 `1.9.5beta3` / `6ed85942ba0971bb8e92d87b180550c0fc048f68`）
- **实机验证状态**：`device_tested: false`（本轮完成根因定位、源码重构、静态审计与 GitHub Actions Xcode 27 / 签名兼容性构建验证，实机视觉与交互表现待真机安装确认）

## 一、实机截图根因复盘（基于 1.9.5beta3 实机证据）

1. **底栏深/浅色均出现乳白色覆盖、书架白色蒙层与左右胶囊粘连桥接**
   - 经核查 `repair162/floating_bar_162.s` 执行时序：每次 `SSTabBar layoutSubviews` 中，`FQHBottomFinish`（触发 `syncWithBar:`）运行在先，而 `Lmaterial_update`（`repair162/material_lifecycle.s`）运行在后，反复向底层 `proxy` 写入乳白色 `UIGlassEffectStyleRegular (0)`；同时 iOS 26/27 的 `UIGlassEffect` Metal 渲染会忽略 `CALayer.mask = CGRectZero` 且仅靠隐藏子图层无法阻止后续回写。
   - 结果：展开态下 `proxy` 的全宽乳白胶囊与前方的原生 `UITabBar` 胶囊双层叠加，在书架等浅色页面表现为厚重白膜与双边缘重影，在开启独立圆形模块后表现为跨过右侧按钮的全宽灰白桥接。
2. **「Dock 独立圆形模块」选择「我的」后与左侧粘连、灰暗且无法点击**
   - **Z 序被反复压底**：`Lrepair_front` 每次布局均调用 `bringSubviewToFront:` 提升 `proxy/overlay`，而 `layoutNativeDockInBar:` 在 `!geometryChanged` 快路径直接返回，导致 `detachedButton` 长期被压在 `proxy`（`userInteractionEnabled = YES`）、`overlay` 与 `nativeDockBar` 下方，呈现灰暗且触摸被完全拦截。
   - **左侧实际宽度被截断导致物理碰撞**：旧计算使用 `MIN(availCapsuleW, pf.width * finalScale)`，当 UIKit 3 键 `_UITabBarPlatterView` 最小自然宽度大于 `availCapsuleW` 时，左侧胶囊右边缘直接侵入右侧圆形按钮，且 `UITabBar` 两侧约 `21pt` 不可见边距覆盖了圆形按钮左侧点击区。
   - **按钮层级与弱引用中断**：旧 `FQXDetachedDockButtonView` 将 `hitButton` 放在 `UIVisualEffectView.contentView` 内且 `internalGlassView.userInteractionEnabled = YES`，且 `targetHostButton` 弱引用一旦在宿主重建期间置空就会直接丢弃点击。
3. **短剧顶部明暗切换与诊断覆盖**
   - `1.9.5beta3` 截图确认顶部白角与搜索实体白圆底已消除；但不同子页切换时若 `bottomTabBackgroundColorWithTabModel:` 未及时返回不透明颜色，仅依赖 `contentView.backgroundColor` 可能滞后于文字墨色切换。

## 二、核心修改

### 1. 底栏单材质所有权机制（`native/FanqieXMotion.m`）
- 新增 `FQXDockMaterialOwner`（`None` / `Native` / `Proxy`）及受控 `-[UIVisualEffectView setEffect:]` Hook（`HookVisualEffectSetEffectForOwner`），仅对标记 `FQXDockMaterialOwnerKey` 的底栏 `proxy` 生效，对 App 内其他所有 `UIVisualEffectView` 零开销零影响。
- **展开态（`FQXDockMaterialOwnerNative`）**：
  - `nativeDockBar`（含独立圆形模块）拥有全部可见液态玻璃；`proxy.effect` 强制保持 `nil`、清除内部 backdrop blur、`proxy.userInteractionEnabled = NO`、背景透明，同时保留 `proxy.hidden == NO`、`proxy.alpha == 1.0`、`proxy.bounds` 与 `proxy.contentView.hidden` 供 `Lvisible_to` 与收缩态检测继续正常工作。
  - `Lmaterial_update` 在展开态对 `proxy` 回写 `Regular (0)` 时会被 `HookVisualEffectSetEffectForOwner` 拦截并计数；`updateLens:native:`（位于 `FQHBottomPolish178R7`，晚于 `Lrepair_front` 与 `Lmaterial_update`）再次强制确认所有权、Z 序与可见玻璃层审计。
  - 强化 `FQXApplyDockPlatterGlass`：检测 UIKit 是否将 `_UITabBarPlatterView.glassEffect` 静默回退为 `Regular (0)`，并在样式/条目变更时同步清理同级 platter 缓存。
- **收缩态 / 兼容分段回退（`FQXDockMaterialOwnerProxy`）**：
  - 在 `setNativeDockVisible:NO restoreProxy:YES` 与 `animateDock:fromFrame:compact:YES` 时将所有权移交 `proxy`，恢复 `proxy.userInteractionEnabled = YES` 并通过 `HookVisualEffectSetEffectForOwner` 保持用户配置的清透/旧版/磨砂/iOS18 高斯材质，杜绝收缩态被回写为乳白 `Regular (0)`。

### 2. 「Dock 独立圆形模块」彻底重构（`native/FanqieXDetachedDock.h`、`native/FanqieXDetachedDock.m`、`native/FanqieXMotion.m`）
- **真正分离的几何布局**：移除 `MIN(availCapsuleW, pf.width * finalScale)` 截断，始终使用 `_UITabBarPlatterView` 实测渲染宽度 `realCapsuleW = pfW * finalScale` 计算坐标；按屏宽自适应 `8~12pt` 间距；总宽超出安全区时等比缩放 `finalScale`（下限 `0.64`），确保 2~5 个模块、不同底栏宽高和任意屏幕宽度下均保证 `actualGapPt >= 8pt` 与 `overlapPt == 0`。
- **绝对顶层 Z 序与触摸直达**：
  - 新增 `-[FQXTabBarInteraction ensureDockZOrderInBar:]`，在 `syncWithBar:`、`layoutNativeDockInBar:`（含 `!geometryChanged` 快路径）、`setNativeDockVisible:`、`updateLens:native:`、`refreshDockMaterial` 与 `FQXRefreshAllDockAppearances` 全路径无条件维护 `detachedButton` 处于 `SSTabBar` 最顶层。
  - `FQXDetachedDockButtonView` 将 `hitButton` 置于 `self` 最顶层直接子视图、`internalGlassView.userInteractionEnabled = NO`（同时保留 `interactionSourceView = hitButton` 驱动 iOS 26/27 原生按压流体形变），提供 `4pt` 外扩 `pointInside:withEvent:` 与直返 `hitButton` 的 `hitTest:withEvent:`。
  - 为 `SSTabBar` 安装 `pointInside:withEvent:`（`B40@0:8{CGPoint=dd}16@32`）与 `hitTest:withEvent:`（`@40@0:8{CGPoint=dd}16@32`）Hook，在 `detachedButton` 命中区域优先路由到独立圆键，彻底杜绝 `UITabBar` 不可见边距、`proxy` 或 `overlay` 抢占事件。
- **真实宿主导航回退链（零坐标模拟）**：
  - 新增 `-[FQXTabBarInteraction triggerHostNavigationForHostIndex:fallbackButton:source:]`：优先触发实时宿主按钮 `UIControlEventTouchUpInside`；若宿主重建导致按钮未切换成功，则依次走 `SSTabBar.delegate` 的 `tabBar:didSelectItem:` 与 `UITabBarController.selectedIndex`，随后立即及下一 RunLoop 同步互斥选中态。

### 3. 短剧顶部明暗判定增强与 9 项低噪节流诊断
- 增强 `FQXDramaHeaderHostIsDark`：在 `tab_model_bg` 之后新增选中分类 `UILabel.textColor` 亮度采样（`active_label_ink`），提升深/浅色子页切换响应准确度。
- 新增/完善 9 项变化去重或节流（`>= 0.15s`）的诊断事件（绝不逐帧刷屏）：
  - `dock_material_owner`
  - `dock_visible_glass_layers`
  - `dock_detached_layout`
  - `dock_detached_hit_test`
  - `dock_detached_touch`
  - `dock_detached_navigation`
  - `dock_proxy_suppressed`
  - `drama_top_glass_material`
  - `drama_search_glass_material`

## 三、未修改的受保护文件
- `native/AlignedGlass.m`（未修改）
- `native/AlignedGlass.s`（未修改）
- `native/FQXBlurControl.h`（未修改）
