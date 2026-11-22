# FanqieX 1.9.5beta3 测试版

> `device_tested: false` — 当前已完成静态审计、ARM64 编译与离线验证，真机视觉折射、书城冷启动与多机型 Dock 几何以实机验收为准。

适用番茄小说 7.4.5（7.4.5.33），目标分支 `test`，基线版本 `1.9.5beta2`。

## 一、修复短剧顶部胶囊/搜索按钮白角与叠层发白、底栏双层玻璃叠加

1. **消除底栏底层 `proxy` 玻璃透出与双层叠加**（`native/FanqieXMotion.m`）：
   - 通过 `1.9.5beta2` 诊断日志与实机截图确认，iOS 26/27 的 `UIGlassEffect` 底层 Metal Backdrop / SDF 图层会忽略 `CALayer.mask = CGRectZero`，导致 `AlignedGlass` 底层 `proxy`（`UIVisualEffectView`）仍在 `nativeDockBar` 背后全透明渲染，造成普通 4 键底栏双层叠玻璃发白、且在 3 键/独立圆键机型上露出一整条宽胶囊重影。
   - 新增 `FQXSetProxyGlassSuppressed` 与轻量 `UIVisualEffectView` `layoutSubviews` / `didMoveToWindow` 快速守卫：在不改动 `proxy.hidden` / `proxy.alpha` / `proxy.frame` / `proxy.effect` / `proxy.contentView.hidden`（完全不触发 `Lvisible_to` 或 `LMmaterial_update` 死循环、不影响底栏收缩检测）的前提下，彻底隐藏 `proxy` 的非 `contentView` 子视图与子图层；进入收缩态时即时恢复，无首帧闪白。
2. **修复短剧右上角搜索按钮双层叠加发白与顶栏底部裁切白角**（`native/FanqieXMotion.m`）：
   - `1.9.5beta2` 中 `FQXSyncDramaSearchButtonGlass` 在 `clearGlassButtonConfiguration` 之上再次覆盖 `cfg.background.visualEffect`，导致搜索按钮叠加了两层 `UIGlassEffect` 明显发白；现改为参考 DYKiller 单层圆钮思路，使用无背景的 `plainButtonConfiguration` 承载图标 + 单层 `FQXFlexGlassView`（与顶部胶囊同源 `UIGlassEffectStyleClear` + `capsuleConfiguration`）。
   - 修复 `FQXAlignDramaHeaderCapsuleAndSearch` 中将 `targetH` 放大到超过 `headerBounds.height` 导致顶部胶囊与搜索按钮下缘被父容器平切出两个白色尖角的问题：限制高度 `MIN(38.0, headerBounds.height - 2.0)`，解除父容器 `clipsToBounds` 裁切，并保持顶部胶囊与搜索圆钮等高、同水平中线对齐。

## 二、修复其他机型（2~3 键 / 独立圆形模块）底栏 Dock 几何错位

- 修复 `layoutNativeDockInBar:` 中 2~3 键（及开启独立圆形模块后左侧剩余 2 键）场景下 `UITabBar` 达到自然最大宽度时，`measuredInset` 吸收余量引发 `dockPlatterInset` 与 `desiredBarW` 逐轮膨胀的缺陷：仅在真实受压区间（`8..32pt`）采纳实测内缩，否则固定使用系统默认值 `21.0pt` 并限制 `desiredBarW` 上限，在底栏宽度、模块数量或独立开关切换时重置测量缓存。
- 优化 `FQXFindDockPlatter` 稳定选取最宽可见胶囊底板；独立圆形按钮直径与纵坐标改为对齐实测缩放后胶囊高度与中线，彻底消除双胶囊重叠与偏移。

## 三、修复打开书城首页仍自动下滑跳过「推荐榜」

- 通过日志 `managedScrolls` 证实冷启动后 `SSNestedContainerScrollView` 在加载约 `0.5s` 内被宿主程序化动画从 `bounds.y = -188` 下滑 `+370pt` 至 `+182`（`SSBookStoreUnlimitedContainerView` 顶部）。
- 升级 `FQXInstallBookstoreAntiAutoScrollHooks`：
  1. 按实际方法签名动态安装 `SSBookStoreABTestHelper` 全部 `*AnchorToDoubleCol*` / `*LocateToInfinite*` / `*AutoScrollToInfinite*` 类方法 Hook（修复此前单一类型编码不匹配导致静默跳过的问题）；
  2. Hook `SSBookStoreDoubleRowTabModel` 的 `locateToInfinite` / `setLocateToInfinite:` 及 `SSBookStoreDoubleRowViewController.afterFirstLoad`；
  3. 在 `SSNestedContainerScrollView` 冷启动首屏未触发用户触摸的 `5.0s` 窗口内，拦截程序化向下跳转（保留顶栏安全内边距对齐与用户手动下拉刷新），并记录 `bookstore_autoscroll_blocked` 诊断事件。

## 四、修复听书页「音色设置」内「配乐版 / 多角色」右移错位裁切

- 移除 `FQXApplyAudioToneListGlass` 中强行给 `toneListView` 额外追加的 `+8pt` 左 `contentInset` / `+10pt` 右 `contentInset`（宿主原有布局已含边距，叠加后将「升级版」「配乐版」整体右推 `8pt` 并切掉「配乐版」右侧边框与「多角色」角标），并将音色子卡内圆角调整为 `14pt` 与宿主角标几何匹配。

## 五、完善网络与听书段落诊断准确度

- 修复 `FanqieXDiagnosticsHub.m` 中高速 `TTHttpTaskChromium` 请求（`< 450ms`）在轮询前自然释放时被误报为 `failed / task_deallocated_without_response` 的问题：前 `1.2s` 提高轮询采样频率至 `120ms`，未观测到错误即释放的任务改为如实归类为 `released_unobserved`，避免污染 `snssdkMonitorSummary.failed` 与 `recentNetworkFailures`。
- 补充探测 `SSReaderTTSParaEntranceManager` 类级布尔开关到 `paraFeatureFlags`。结合对比日志证实：开启 `DOMAIN,is.snssdk.com,REJECT` 时 `/service/settings/v3/` 配置下发被拦截，宿主不会创建 `SSReaderTTSParaEntranceManager`（`paraManagerPresent: 0`、`entranceViewsCreatedSession: 0`），并非插件误隐藏；如需保留段落箭头，需放行 `is.snssdk.com/service/settings/` 而非整域拒绝。
