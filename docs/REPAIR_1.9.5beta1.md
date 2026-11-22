# FanqieX 1.9.5beta1 测试版说明

- 目标分支：`test`（不修改 `main`，不创建正式 Release）
- 构建版本：`1.9.5beta1`（Mach-O 构建标识 `0x15501`）
- 真机验证状态：`device_tested: false`（已完成静态审计、单元测试与 GitHub Actions Xcode 全流程编译校验，待真机实测确认）

---

## 一、新增 Dock 独立圆形模块

### 1. 设置入口与持久化
- 在 **「页面与导航 › 底栏入口」**（并同步镜像至 **「外观 › 玻璃与尺寸」**）新增：
  - **「启用 Dock 独立圆形模块」**（`FanqieX.DockDetachedEnabled.1`，默认关闭，支持配置备份与恢复）。
  - **「选择独立模块」**（`FanqieX.DockDetachedModule.1`，单选列表，动态读取宿主当前实际存在且未被隐藏的底栏模块，如 `书城`、`短剧`、`书架`、`我的`、`商城` 等）。
- 每次最多独立显示 1 个模块；切换开关、切换独立模块或隐藏底栏入口时均立即刷新 Dock，无需重启 App。
- 若当前所选独立模块被隐藏或宿主仅剩不足 2 个可见模块，自动安全回退为完整胶囊 Dock；关闭开关后立即恢复原始单胶囊 Dock。

### 2. 视觉材质、布局与交互
- 模块化实现于 `native/FanqieXDetachedDock.h` / `native/FanqieXDetachedDock.m`，与 `native/FanqieXMotion.m` 现有 `FQXTabBarInteraction` 共享同一底栏材质管线：
  - 左侧保留原生 `UITabBar` 悬浮液态玻璃胶囊（其余模块保持原有顺序），右侧挂载单层 `UIVisualEffectView` + `UICornerConfiguration.capsuleConfiguration` 独立圆形按钮，直径跟随胶囊高度，间距 `12pt`，整体水平居中、底部对齐。
  - 完全复用当前 `新液态玻璃 (Clear)` / `老液态玻璃` / `模糊玻璃 (Regular)` / `高斯模糊`、`液态玻璃叠加深色底色` 与深浅色自动适配逻辑；当 `Dock 模糊程度 = 0%` 时不创建任何附加高斯模糊层或灰色衬底。
  - 启用 `UIGlassEffect.interactive = YES` 与 `_flexInteractionGestureView` 原生按压流体折射高光，并配合图标/选中透镜弹性回弹动画。
  - 严格互斥选中态：独立模块激活时自动清空左侧胶囊选中态并隐藏残留 `_UITabSelectionView`；切换回左侧任意模块时立即恢复胶囊选中透镜并收起右侧圆键选中态，杜绝双图标或双选中。
  - 直接转发宿主原始底栏 `UIButton` 点击事件，完整保留原生 Tab 切换、重按刷新、震动反馈、底栏长宽高缩放、图标尺寸与短剧滚动自动收缩兼容。

---

## 二、模块化增强 JSON 诊断日志系统

新增 `native/FanqieXDiagnosticsHub.h` / `native/FanqieXDiagnosticsHub.m`，在不阻塞主线程的前提下扩展 JSON 诊断能力：

1. **网络请求监控 (`category: "network"`, `event: "network_request"`)**
   - 覆盖 `BDRpcAsyncOperation` 全量接口、`TTHttpTask` / `TTHttpTaskChromium` 及 `NSURLSession`（严格保持 `completionHandler == nil` 的流式代理模式不被改写）。
   - 记录请求 ID、域名、脱敏路径、查询参数键名（不记录值）、HTTP 方法、阶段（`issued` / `returned` / `failed` / `cancelled`）、状态码、耗时（ms）、`NSError` 域与错误码、重试/超时/连接失败标记，并专项统计 `is.snssdk.com`。
   - 严格区分插件自身行为与底层网络/传输错误：客户端出现连接拒绝、重置或 DNS 失败时仅标记为 `connection_failure_or_suspected_proxy_interception` 并附注提示，**绝不凭客户端错误直接断言为 Loon `REJECT`**（Loon 规则命中需结合 Loon 请求日志确认）。
2. **Hook 拦截审计 (`category: "hook"`, `event: "hook_interception"`)**
   - 记录宿主类名、Selector、规则名称、触发原因、处理结果（`blocked` / `allowed` / `skipped` / `failed`）、累计次数与执行耗时。
3. **视图生命周期监控 (`category: "view"`, `event: "view_lifecycle"` / `"tts_para_manager_call"`)**
   - 重点监控 `SSReaderTTSParagraphEntranceView` 与 `SSReaderTTSParaEntranceManager` 的创建、挂载、显示、隐藏、透明度归零、移除及宿主刷新重建，明确区分宿主行为与插件主动操作（含插件调用入口与原因）。
4. **听书与段落定位监控 (`category: "tts"`, `event: "tts_paragraph_state"` / `"tts_playback_transition"` / `"tts_paragraph_click"`)**
   - 记录书籍与章节有效性、会话随机盐值 SipHash-2-4 匿名化标识（不保存真实书籍 ID、账号信息、正文、Cookie、Token 或请求体）、当前段落索引、点击段落索引、定位对象存在性、播放状态及点击后 `1.6s` 实际状态核验。
5. **异步限流、轮转与按类别导出过滤**
   - 采用 `QOS_CLASS_UTILITY` 串行后台队列异步落盘、按类别令牌桶限流与双文件 `512 KB × 2` 自动轮转；普通诊断模式仅记录关键异常与核心链路，增强诊断模式输出完整关联记录。
   - 在 **「诊断与其他」** 新增 **「导出日志类别过滤」**（支持 `全部类别` / `网络请求` / `Hook 拦截` / `视图生命周期` / `听书与段落定位` / `安全验证与启动` / `底栏与界面`）。

---

## 三、启动「我的」页面「安全验证 — 服务错误，请与我们联系。」排查与修复

### 1. 事实与根因定位
- **核查事实**：经逐条审计核心 45 条广告规则与全部 Objective-C Hook，FanqieX 未挂钩拦截任何 `BDTuring*`、`TTAccount*` 或底层 `NSURLSession` / `TTNetworkManager` 请求；截图中的弹窗为字节风控组件 `BDTuringVerifyView` 在验证初始化请求或挑战配置加载失败时的原生兜底错误页。
- **外部网络因素**：当代理规则拦截了字节风控/设备网关域名（如 `is.snssdk.com` 或 `bdturing` 相关接口）或冷启动瞬时网络/DNS 异常时，`BDTuring` 无法拉取验证码配置即会显示「服务错误，请与我们联系。」。
- **插件侧兼容隐患**：
  1. `FanqieXCleanup.m` 的 `RestoreMinePosition` 在「我的」页出现时会同步强制执行 `invalidateLayout`、`layoutIfNeeded` 与滚动偏移复位，若恰逢冷启动弹出安全验证遮罩，会产生不必要的底层布局重排竞争。
  2. `WKWebView` 内容进程若在冷启动内存压力下异常终止（`URL` 变为空且停止加载），会导致验证弹窗白屏卡死。

### 2. 合规修复措施（不隐藏弹窗、不伪造校验、不绕过风控）
1. 在 `SuppressWidgetDialog` 中显式豁免所有 `BDTuring*` / 安全验证 / 账号验证视图，100% 保留原生验证与重试/反馈交互。
2. 在 `RestoreMinePosition` 中检测 `presentedViewController` 及窗口内活动的安全验证视图，验证展示期间暂停插件对「我的」页的强制同步重排。
3. 新增 `security_verify_view_lifecycle`、`security_verify_load_request` 与 `security_verify_webview` 诊断事件，自动关联最近 15 秒内的失败网络请求（如 `is.snssdk.com` 连接错误）及登录态布尔值；仅当检测到 `WKWebView` WebContent 进程崩溃置空时自动执行一次原生 `reload` 防止空白页。

---

## 四、阅读页「段落播放箭头消失」排查与修复

### 1. 已确认的插件根因（事实）
- 在旧版 `native/FQXContentCleanup.m` 中，`FQReaderSaaSTTSManager -onReaderDidAppear:` 在未处于听书同步状态时调用了 `FQXScheduleStaleReaderAudioUIClean()`。
- `FQXCleanStaleReaderAudioUIOnMain()` 在听书未激活时遍历了全部 `SSReaderTTSParaEntranceManager`，主动调用了 `applyToHidePlayAnchorViews`、`removeReaderInsertViewIfNeeded`，并通过 `FQXHideParaEntranceSubviews` 递归将阅读页内所有 `SSReaderTTSParagraphEntranceView` 设为 `hidden = YES`！
- **与 Loon `DOMAIN,is.snssdk.com,REJECT` 的耦合机制**：
  - `SSReaderTTSParagraphEntranceView` 实际是阅读正文每段末尾的「从本段开始听书」播放箭头入口，而非残留浮条。
  - 当未拦截 `is.snssdk.com` 时，后续到达的远端配置回调往往会触发阅读器二次刷新并重新创建箭头（同时放行了 `is.snssdk.com` 下发的其他听读页配置）；而开启 `DOMAIN,is.snssdk.com,REJECT` 后，远端回调不再到达，插件在 `onReaderDidAppear:` 中执行的同步+异步清理直接将本地已创建的段落播放箭头彻底隐藏且不再恢复。

### 2. 修复与边界说明
1. **彻底移除误伤逻辑**：从 `FQXCleanStaleReaderAudioUIOnMain()` 中删除 `FQXHideParaEntranceSubviews` 及对 `SSReaderTTSParaEntranceManager` 的隐藏/移除调用；仅在 `FQReaderSaaSTTSManager` 残留 `hasShowSyncBtn == YES` 时清理同步定位按钮。
2. **全链路日志核验**：进入阅读页后 `350ms` 自动记录 `SSReaderTTSParaEntranceManager` 开关状态与阅读器内 `SSReaderTTSParagraphEntranceView` 的总数量/可见数量，并在点击段落播放时记录定位对象传递及 `1.6s` 后真实播放状态。
3. **服务端数据边界说明**：本修复已消除插件对段落播放箭头的误隐藏，使宿主在本地缓存或离线配置可用时即使保留 `is.snssdk.com` 屏蔽也能正常显示原生箭头；若某书籍首次加载段落语音配置或在线合成流本身必须请求 `is.snssdk.com` 服务端接口且被代理拒绝，插件不会绘制无功能的假图标或伪造播放成功，而是在 `tts` 与 `network` 诊断日志中如实记录缺失配置与失败请求供定位。
