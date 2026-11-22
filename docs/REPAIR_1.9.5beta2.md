# FanqieX 1.9.5beta2 修复说明

- **版本**：`1.9.5beta2`（Mach-O 构建标识 `0x15502`）
- **基线**：`1.9.5beta1`（`test` 分支）
- **验证状态**：`device_tested: false`（CI 静态审计、构建产物验证与 Xcode 27 交叉编译校验通过；待真机复测确认）

## 一、定位与根因分析（基于 1.9.5beta1 真机截图 + 4760 条 JSON 诊断记录）

### 1. 短剧页底栏 Dock、顶部胶囊/搜索按钮、收缩态出现发白底色
1. **iOS 26/27 `UIGlassEffectStyleClear` 在 `UIUserInterfaceStyleLight` 下的亮白光学抬升**：`1.9.1beta26` 为去除黑色底色将短剧页的底栏 `UITabBar`、顶部胶囊与搜索按钮强行锁定为 `UIUserInterfaceStyleLight`；但在深色短剧视频画面上，Light 外观档的 `Clear` 玻璃会产生约 `+40~+53` 亮度的乳白色光晕层，且与 `AlignedGlass` 每帧写入的深色外观来回打架。
2. **短剧顶部选中胶囊（如「推荐」）双层叠玻璃**：此前将 `self.pillGlass`（无染色 `Clear` 玻璃）直接叠放在 `outer.contentView`（同样为无染色 `Clear` 玻璃）内部，两层 Light 档 `Clear` 玻璃叠加导致亮度抬升翻倍（`L ≈ 95 → 136 → 182/197`），使选中项呈现明显乳白块。
3. **右上角搜索按钮配置回退与外观错位**：`FQXSyncDramaSearchButtonGlass` 仅在开启深色底色时显式写入 `cfg.background.visualEffect`，未开启时缺少显式 `UIGlassEffectStyleClear(tintColor = nil)` 与 `clearColor` 背景清理，且被强制设为 Light 外观导致按钮呈明显发白圆盘。
4. **底栏收缩态（`proxy`）首次收起仍持有默认磨砂 `Regular (0)`**：展开态使用原生 `UITabBar` 期间 `FQXApplyDockProxyMaterial` 未提前同步 `proxy`，导致收缩动画起始帧仍呈现 `AlignedGlass` 默认的 `Regular (0)` 磨砂白底；同时 `NewGlass` 下独立圆键/回退选中态使用了 `white:1.0 alpha:0.14` 白色填充。

### 2. 浅色模式下阅读页段评区呈灰黑底色
1. 真机截图实测显示，评论面板**上方**的小说正文（`< 第481章 ...`）与评论面板**背后**同时被压暗至 `RGB(123, 123, 123)`（正常浅色纸张约 `RGB(245, 245, 245)` 的 50%），说明番茄宿主在弹出段评面板时叠加了全屏约 50% 透明度的黑色模态遮罩层（`rgba(0,0,0,0.5)` 或 `blackColor + alpha = 0.5`）。
2. 当评论区采用无染色 `UIGlassEffectStyleClear`（`清透玻璃`）时，宿主全屏黑遮罩透过玻璃直接透出，使整个浅色评论区看起来发黑发灰。
3. 原有 `FQXCleanTransitionBackdrop` 仅在父视图为 `FQVTransitionView` 且遮罩恰好为精确类 `UIView`/`UIControl` 时清背景色，未能覆盖自定义遮罩子类、模态转场容器（如 `UITransitionView` / 祖先遮罩兄弟视图）、`blackColor + alpha` 动画回写及非 `FQVTransitionView` 弹出的段评容器。

## 二、本轮修复内容

1. **底栏「新液态玻璃」、独立圆形模块与收缩态彻底去除发白底色**（`native/FanqieXMotion.m`、`native/FanqieXDetachedDock.m`）：
   - 恢复 `UITabBar` 与独立圆键按真实页面背景明暗自动匹配 `overrideUserInterfaceStyle`（深色短剧/夜间页用 `Dark`，浅色书城/书架/我的页用 `Light`），默认（`液态玻璃叠加深色底色` 关闭）严格保持 `tintColor = nil`，既不叠加黑底，也不产生 Light 档乳白底。
   - 同步刷新 `UITabBar` 所有 `_UITabBarPlatterView` 兄弟底板，移除 `NewGlass` 下 `white:1.0 alpha:0.14` 白色选中底填充，改为与原生透镜一致的细腻中性凹陷态。
   - 在展开态预同步 `proxy` 材质，并在 `animateDock:fromFrame:compact:button:` 收缩/展开动画第 0 帧前强制校验 `proxy.effect` 为无底色 `UIGlassEffectStyleClear`（清除 `AlignedGlass` 遗留的 `Regular (0)` 磨砂白底及收缩按钮多余背景）。
2. **短剧顶部胶囊与右上角搜索按钮无色清透液态玻璃**（`native/FanqieXMotion.m`）：
   - 顶部分类胶囊 `outer` 恢复按页面真实明暗匹配 `overrideUserInterfaceStyle` 且默认 `tintColor = nil`，消除与 `AlignedGlass` 的外观反复覆盖和乳白光晕。
   - 消除静止态双层叠 `Clear` 玻璃发白问题：未开启「深色底色」且处于静止态时，仅由外层 `outer` 承载单层无染色 `UIGlassEffectStyleClear`，选中项改用单层无白底细腻凹陷胶囊；手指按压/拖动切换频道时即时激活实时交互式 `Clear` 液态水滴折射，松手后恢复单层清透态。
   - 右上角搜索按钮显式写入无染色 `UIGlassEffectStyleClear`（`interactive = YES`、`tintColor = nil`）并清理 `backgroundColor` 与 `baseBackgroundColor`，外观极性与顶栏保持一致。
3. **浅色评论区全屏黑色遮罩清扫与安全恢复**（`native/FanqieXMotion.m`）：
   - 新增 `FQXCleanCommentPresentationBackdrops` / `FQXViewLooksLikePureDimmingScrim` / `FQXSetCommentDimmerZeroMask`：同时扫描 `FQVTransitionView` 扩展遮罩 ivar（含自定义子类）以及评论面板向上的模态容器层级中位于面板**下方**的纯深色半透明遮罩层（同时识别 `rgba(0,0,0,α)` 与 `blackColor + alpha` 两种写法，严格跳过任意 `UIViewController` 根视图与含正文/列表/图片的业务视图）。
   - 采用可逆零尺寸 `CALayer` 遮罩 + 背景清空双重策略（参考业界不改动 `hidden`/`alpha`/`userInteractionEnabled` 的方案），彻底阻断宿主弹出动画回写黑色遮罩，同时完整保留点击面板上方空白关闭评论区的手势。
   - 在段评控制器 `viewDidAppear:` 增加动画结束后补扫，并在关闭评论区或切回「原版默认 / 原书底色」时完整还原所有被屏蔽遮罩。
4. **增强诊断遥测**：新增 `dock_glass_material`、`dock_proxy_material`、`drama_top_glass_material`、`drama_search_glass_material`、`comment_backdrop_clean` 变更触发记录（低开销去重，便于真机复测验证实际材质与已清扫遮罩类）。
