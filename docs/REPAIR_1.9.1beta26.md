# FanqieX 1.9.1beta26 修复说明

## 核心目标

修复底栏「新液态玻璃（`FQXDockMaterialNewGlass`）」与短剧顶部区域（分类胶囊 `推荐 看剧 漫剧`、选中指示胶囊、右上角搜索按钮 `🔍`）在浅色模式下默认叠加黑色底色与深灰选中块的视觉偏差，对标 `HierarchThurs/DYKiller` 底栏对「玻璃材质外观档」与「图标/文字墨水极性」的解耦思路独立实现纯无底色通透液态玻璃，并新增可即时切换的独立开关。

## 根因核查与修复项

### 1. 底栏「新液态玻璃」纯通透无底色还原（`native/FanqieXMotion.m`）

- **问题根因**：
  1. 短剧页面宿主返回 `#222222` 深色底色，此前 `FQXTabBarInteraction` 将玻璃材质外观（`nativeDockBar.overrideUserInterfaceStyle`）与图标墨水极性绑定，导致即便手机与 App 处于浅色模式，进入短剧页也会强制下发 `UIUserInterfaceStyleDark`，使 `UITabBar` 原生选中胶囊（`_UITabSelectionView`）渲染为深炭灰块。
  2. `FQXMakeDockEffectForMode` 在 `FQXDockMaterialNewGlass` 分支对 `isDark == YES` 固定施加了 `[UIColor colorWithWhite:0.0 alpha:0.30]`（30% 纯黑染色），压暗了背景色彩与折射通透感。
  3. 初次挂载 `UITabBar` 时无条件读写 `tabBar.standardAppearance`，不必要地物化了旧版外观对象。
- **修复方式**：
  1. 将「玻璃材质档（`desiredDockGlassStyle`）」与「图标/文字墨水极性（`isDarkDock` -> `dockAppliedInkState`）」彻底解耦：默认未开启深色底色开关时，`新液态玻璃` 的 `tintColor` 恒为 `nil`（纯 `UIGlassEffectStyleClear`），且 `nativeDockBar.overrideUserInterfaceStyle` 保持 `UIUserInterfaceStyleLight`，使外层胶囊与选中透镜均呈现无黑底的清透折射质感；与此同时图标图片（`UIImageRenderingModeAlwaysOriginal`）仍按页面底色自动切换纯白（短剧/深底页）与纯黑（书城/书架/我的浅底页）。
  2. `FQXDockMaterialNewGlass` 默认不再读写 `tabBar.standardAppearance`，完整保留系统悬浮 `UITabBar` 原生透镜管线；在材质或条目变更时同步失效 `FQXPlatterAppliedStyleKey` 防止系统重置 `glassEffect`。

### 2. 短剧顶部胶囊、选中块与右上角搜索按钮无底色清透化（`native/FanqieXMotion.m`）

- **问题根因**：
  1. `FQXDramaTopCapsuleInteraction` 此前固定在外层胶囊施加 `0.30` 黑色染色、在选中胶囊施加 `0.50` 黑色染色，并强制 `UIUserInterfaceStyleDark`。
  2. 右上角搜索按钮由底层创建为 `UIButtonConfiguration.glassButtonConfiguration`（`Regular` 磨砂）+ `UIUserInterfaceStyleDark`，在浅色模式下同样呈深灰磨砂圆底。
- **修复方式**：
  1. 新增 `FQXDramaHeaderHostIsDark` 直接从宿主数据源读取页面明暗极性，避免与 `outer.overrideUserInterfaceStyle` 产生状态互相覆盖。
  2. 默认关闭「液态玻璃叠加深色底色」时：顶部分类外层胶囊与可拖拽选中胶囊均使用 `tintColor = nil` 的纯 `UIGlassEffectStyleClear` + `UIUserInterfaceStyleLight`；右上角搜索按钮通过 `+[UIButtonConfiguration clearGlassButtonConfiguration]` 切换为无底色清透液态玻璃圆钮，保留白色放大镜图标与几何对齐。

### 3. 新增「液态玻璃叠加深色底色」独立开关（默认关闭）

- **偏好键**：`FanqieX.GlassDarkTint.1`（默认 `NO` = 纯通透无底色液态玻璃；开启 `YES` = 在深色/短剧视频背景下为新液态玻璃底栏与短剧顶栏叠加 30% 深色对比底色）。
- **设置入口**：主入口位于 `外观 › 玻璃与尺寸`（支持全局搜索「底色 / 深色底色 / 通透 / 液态玻璃」等关键词），并在 `短剧 › 顶部分类` 与 `短剧 › 播放设置` 提供同步镜像开关；切换时同时实时刷新底栏与短剧顶栏，并纳入 `FanqieXSettingsBackup.m` 配置备份与恢复。

## 验证状态

- `device_tested: false`（尚未在真机完成本版回归验证，待安装 `1.9.1beta26` 实测确认）。
