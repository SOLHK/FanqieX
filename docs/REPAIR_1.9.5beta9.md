# FanqieX 1.9.5beta9 修复与冷启动优化说明

- **目标分支**：`test`
- **基线版本**：`1.9.5beta8` (`05910636bfdcb204c90f5f45fbd53da4df9f67d8`)
- **目标版本**：`1.9.5beta9` (`0x15509`)
- **实机验证状态**：`device_tested: false`（尚未完成真机验证）

---

## 一、实机问题与日志定位（基于 `E138118A` 日志与两张实机截图）

1. **短剧分享页浅色模式下 Logo 与文字仍为白色（图一）**
   - 原因：`FQXStyleShareSheet` 在 `1.9.5beta8` 中为短剧分享页硬编码 `forceDarkDrama = YES`，导致系统与 App 处于浅色模式时，短剧分享页的 `isDark` 仍为 `YES`，渠道单色 Logo 与标题文字均呈纯白色，而图二的小说分享页在同为浅色模式下已正确渲染为纯黑 Logo 与黑色文字。
2. **小说分享页出现全屏暗色背景遮罩（图二）**
   - 原因：宿主 `SSReadingSharePanel` 弹出时会在阅读页上方叠加全屏半透明暗色遮罩，而短剧分享页本身无暗色遮罩；此前分享页材质逻辑仅清理了分享面板卡片内部子视图背景，未清理外层/同级暗色全屏遮罩。
3. **注入插件后冷启动变慢**
   - 实机 `loadDiagnostics` 日志直接记录：
     - `1.9.5beta7`：`diagnosticsInstallComplete (+3.0ms) -> legacyHooksInstalled (+1506.5ms)`，同步阶段耗时 **1,503.5 ms**，`firstPageDidAppear` 在 `+2406.2ms`。
     - `1.9.5beta8`：`diagnosticsInstallComplete (+2.5ms) -> legacyHooksInstalled (+1078.9ms)`，同步阶段耗时 **1,076.4 ms**，`firstPageDidAppear` 在 `+2039.2ms`。
   - 五个可量化根因：
     1. **`FQXHookInstaller.m` (`FQXOwnMethod`)**：启动阶段同步安装约 550+ 个 Hook，每次调用均执行 1～2 次 `class_copyMethodList`（获取 ObjC 全局锁 + `malloc` + 线性扫描数百至上千个方法 + `free`），且每次使用 `[NSString stringWithFormat:]` 与 `NSMutableSet` 做去重。
     2. **`FanqieXMotion.m` (`FQXHookHostSharePanelSubclasses`)**：在 dyld 初始化阶段同步调用 `objc_copyClassList` 遍历宿主约 45,000+ 个 ObjC 类。
     3. **`FanqieXDiagnosticsHub.m` (`FQXDiagnosticsHubInstall`)**：在 `main()` 之前同步调用 `FQXProbeAccountLoggedIn()` 触碰宿主 `TTAccount`/`BDUGAccount`/`SSAccountManager` 单例（提前拉起账号/存储栈），同时同步扫描 `SSReaderTTSParaEntranceManager` 方法列表、挂钩 `WKWebView`/`BDTuring*` 并立即触发 `diagnostics_hub_ready` 落盘任务。
     4. **`FanqieXMotion.m` (`FQXEnsureMediaPlayerLoaded`) & 316 个 Hook 全部同步安装**：在灵动岛默认关闭的情况下仍在 dyld 初始化阶段同步 `dlopen("MediaPlayer.framework")`；评论区、阅读器、听书页、我的侧边栏、分享页等非首屏 Hook 及全局 `UIWindow.addSubview:` / `UIViewController.viewDidAppear:` 均在冷启动首屏之前同步注入。
     5. **`FQXContentCleanup.m`**：在确认宿主类/方法是否存在之前就调用 `NSStringFromClass` 桥接与 `imp_implementationWithBlock` 分配可执行跳板页，随后失败再 `imp_removeBlock` 释放。

---

## 二、本轮修改方案

### 1. 统一短剧与小说分享页浅色/深色极性（`native/FanqieXMotion.m`）
- `FQXStyleShareSheet` 改为统一以 `FQXAppIsInNightMode()` 判定当前浅色/夜间模式（仅在阅读页可采样到当前纸张底色且亮度 `< 0.45` 时随纸张深浅自动切换）：
  - **浅色模式**：短剧与小说分享页统一渲染 **纯黑单色 Logo (`#000000`) + 黑色文字**。
  - **夜间模式**：短剧与小说分享页统一渲染 **纯白单色 Logo (`#FFFFFF`) + 白色文字**。
- `FQXApplyShareSubtreeCleanup` 同步补齐 `UILabel.attributedText` 前景色适配与恢复（通过 `FQXShareSavedAttrTextKey` 缓存原始富文本，切回原版默认时无损还原），避免短剧/小说富文本标题（如“分享至”）残留白色。

### 2. 移除小说分享页暗色背景遮罩并保持点击空白关闭（`native/FanqieXMotion.m`）
- 新增 `FQXClearOneShareDimmerView` 与 `FQXSyncShareBackdropDimmer`：
  - 沿分享卡片父链向上检查非受保护宿主容器及其位于分享分支下方、覆盖窗口 ≥72% 宽且 ≥40% 高、无可见内容的暗色半透明遮罩层（含 1 级嵌套遮罩子视图及纯暗色无委托 sublayer）。
  - 仅清空其暗色填充与暗色子图层，**保留 `hidden = NO` 与 `userInteractionEnabled = YES`**，确保点击分享页外空白区域关闭手势完全正常，且视觉上与短剧分享页一致无暗色蒙层。
  - 切换回「原版默认」或关闭玻璃效果时通过 `FQXTrackedShareDimmers()` 完整恢复原遮罩颜色；在 `share_panel_styled` 诊断事件中新增 `clearedDimmers` 计数。

### 3. 全链路冷启动性能优化
- **O(1) 零分配 Hook 安装器（`native/FQXHookInstaller.m`）**：
  - 删除 `FQXOwnMethod` 中的 `class_copyMethodList` 线性扫描，改用 O(1) `class_getInstanceMethod(owner, sel)` 与 `class_getInstanceMethod(class_getSuperclass(owner), sel)` 指针比较判定自有方法，本地化继承方法时仍严格保留父类及兄弟类隔离（由 `tests/native_hook_installer_smoke.m` 持续验证）。
  - 用锁保护的 C 开放定址哈希表（初始 1024 槽，0 次 `NSString`/`NSMutableSet` 分配）替代字符串去重集合。
- **彻底删除冷启动全类扫描（`native/FanqieXMotion.m`）**：
  - 移除 `FQXHookHostSharePanelSubclasses`（删除 `objc_copyClassList` 45,000+ 类遍历），保留既有的动态按需接管（`UIWindow` / `UIViewController` / `UINavigationController` + `SSReadingSharePanel` / `SSVideoSharePanelView` / `SSUGKmpSharePanelContainerViewController`）。
- **延迟非首屏诊断初始化（`native/FanqieXDiagnosticsHub.m`）**：
  - dyld 同步阶段仅保留轻量网络诊断 Hook（10 个）；将 `InstallTTSAndViewLifecycleHooks()`、`InstallSecurityVerificationHooks()` 以及 `FQXProbeAccountLoggedIn()` / `diagnostics_hub_ready` 推迟至主线程 `+0.55s` 执行，避免在 `main()` 之前拉起宿主账号 SDK。
- **三阶段 Hook 调度 + 按需加载 `MediaPlayer.framework`（`native/FanqieXMotion.m`、`native/FanqieXCleanup.m`、`native/FQXContentCleanup.m`）**：
  - **Phase 1（dyld 同步）**：仅保留冷启动防广告/防热启/防书城自动下滑、Dock 材质与独立圆钮命中、首屏 Tab 与书架/通知 Hook。
  - **Phase 2（主线程首个 RunLoop tick，`dispatch_async(main)`）**：短剧顶栏/书架/我的 PostGlass Hook、短剧清晰度/画布/手势/进度条/右侧栏与 App 生命周期通知。
  - **Phase 3（首屏后 `+0.25s`）**：评论区面板与输入框、阅读器章末/自动阅读/段评、听书页玻璃与广告、我的侧边栏、分享页 Hook（确保启动期间 `UIWindow.addSubview:` 与 `UIViewController.viewDidAppear:` 零额外开销，且 `UIViewController.viewDidAppear:` 保持最后安装）。
  - **按需加载 `MediaPlayer.framework`**：新增 `FQXInstallDynamicIslandMediaPlayerHooksIfNeeded`，当灵动岛开关关闭且宿主尚未加载 `MPRemoteCommand` 时不再调用 `dlopen`，开启灵动岛时即时装载。
  - **`FQXContentCleanup.m` 预检防无效跳板**：新增 `FQXLookupMatchingClass`（直接使用 `objc_lookUpClass` + 签名预检），类或方法不存在时不再无谓调用 `imp_implementationWithBlock` / `imp_removeBlock`。
  - **新增冷启动耗时埋点**：`FanqieXCleanup` 在 `+1.2s` 上报一次轻量 `startup_perf_summary`（记录 `hubSyncMs`、`cleanupSyncMs`、`contentSyncMs`、`motionSyncMs`、`totalSyncMs`），便于实机对比验证。

---

## 三、受保护文件核查

- `native/AlignedGlass.m`：未修改（0 diff）
- `native/AlignedGlass.s`：未修改（0 diff）
- `native/FQXBlurControl.h`：未修改（0 diff）

---

## 四、待实机验收清单（`device_tested: false`）

1. **浅色模式短剧分享页**：单色 Logo 为纯黑、文字（含“分享至”及渠道名称）为黑色，液态玻璃无泛白、高光清晰。
2. **夜间模式短剧与小说分享页**：单色 Logo 为纯白、文字为白色。
3. **浅色模式小说分享页**：背景阅读页面不再被全屏暗色遮罩压暗（与短剧分享页视觉统一），点击空白阅读区仍可正常收起分享页；切换回「原版默认」可完整恢复原生样式与彩色图标。
4. **冷启动速度**：强杀重启番茄小说，观察冷启动进入首屏体感，并在导出诊断 JSON 中核对 `loadDiagnostics`（`diagnosticsInstallComplete -> legacyHooksInstalled` 耗时应由 ~1076ms 大幅回落）及 `startup_perf_summary` 各阶段毫秒数。
5. **回归核对**：短剧顶部胶囊/自定义大小、Dock 独立圆钮、评论区、阅读器章末净化、听书页及灵动岛开关按需开启均无回归。
