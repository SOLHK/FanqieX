# FanqieX 1.6.6 本地测试版

基于上一份本地交付 `9f7284e13543d8587d2ac8f0e446f5589a69cd10`（1.6.5），继续等待用户测试，不推送 GitHub 或 `test`。

## 对应三张截图

- 图一编辑上方的搜索、更多：原 UIButton 接入 `UIButtonConfiguration.glassButtonConfiguration`，保留原图标、target/action、启用状态和辅助功能。小于 36pt 的图标按钮扩为至少 36pt，中心保持不变，玻璃和实际点击区域一起扩大。
- 图一“今日已看听读…”：改用自身 bounds 内的单层 Regular 玻璃；不再用旧书架逻辑将这一长胶囊扩到父容器范围。解除这个控件本身的旧圆角裁剪和 opaque 标志，关闭功能时恢复。
- 图二搜索框两端：同样解除搜索容器自身的旧圆角裁剪及 opaque 标志，不移动搜索内容、轮播文字、图标，不更改祖先或子控件的裁剪。
- 图三返回、下载、段评开关、搜索、更多：原生 UIButton 使用系统玻璃按钮配置；非 UIButton 的下载容器使用公开 UIGlassEffect。右侧按钮通过宿主 `getInsertViewSize` 接口得到至少 36pt 的真实布局尺寸，继续由宿主计算间距。“已加书架”文字不加玻璃、不改内容。
- 系统在高亮等状态变化时会复制配置，关闭时仍恢复最初的宿主配置。原始图片、文字与事件不迁移到覆盖层。
- 新诊断字段 `readerNativeGlassButtons` 记录实际已设置样式的阅读顶部按钮数量；开启后不再把该状态误报为保留原始顶部外观。

## 缺口原因的证据与限制

附件日志确认宿主 7.4.3.33、插件 1.6.5、iOS 27.3（24C5037i），插件完成启动。该日志没有搜索框和时长按钮完整的图层快照，不能单凭它证明每一处像素缺口的成因。

在已核对宿主的机器码中，搜索框布局调用 `setSsCornerRadius:`；时长按钮 `SSBookShelfProfileDurationTipButton` 初始化也调用它。这个方法会设置 CALayer 的 `cornerRadius` 和 `masksToBounds`。旧插件把原生玻璃作为这些控件的子视图放进去，却保留原控件裁剪；旧时长几何还可能向父区域扩展。两项叠加有裁掉玻璃边缘的明确结构依据。

本版针对该结构修复，保存并恢复旧属性，不修改全局 UIView，不清除其他视图的 mask。以 1.6.5 原二进制作负对照，离线测试确认旧版保留裁剪、新版解除裁剪；最终光学边缘、文字轮播及触感仍需真机确认。

API 依据：[Apple UIVisualEffectView](https://developer.apple.com/documentation/uikit/uivisualeffectview)、[Apple UIButtonConfiguration](https://developer.apple.com/documentation/uikit/uibuttonconfiguration)、[Apple UIKit 新设计](https://developer.apple.com/videos/play/wwdc2025/284/)。本次代码独立实现，没有复制第三方项目代码。

## 安装与验收

1. 移除旧 FanqieX / FanqieAdBlock，注入 `FanqieX-1.6.6.dylib`，重新签名安装；同一宿主只加载一份插件。
2. 设置页确认 1.6.6、启用插件液态玻璃，彻底退出后重新打开。
3. 重点查看两个长胶囊左右边缘；切换频道、明暗外观，再检查搜索文字是否溢出或被遮挡。
4. 点击书架搜索/更多及阅读页五个按钮，检查功能、排列、点击区域、段评开关和下载进度。
5. 关闭玻璃后重新进入页面，检查按钮外观和尺寸恢复。其他设置仍沿用已有偏好。

兼容目标沿用 iOS 26+ 通用 ARM64，宿主仍为番茄小说 7.4.3.33；没有系统所需 API 时保留原功能。没有全机型真机验证。

## 验证与复现

最终 `VERIFICATION.json` 记录本包真实执行结果、源码冻结摘要和插件哈希。检查包括严格 Clang 编译、两次重建一致性、Mach-O/签名页/分支/异常展开、旧功能回归，以及新增按钮、原事件、尺寸、配置复制、重入、关闭恢复、缺失 API、旧版裁剪负对照和时长入口检查。

离线检查执行实际 ARM64 指令，UIKit/Foundation 服务采用显式模型。未在本机运行真实 iOS 渲染器，也未进行本次 Xcode SDK、iPhone 注入、真实触摸或像素验收。测试通过不等于缺口已在用户手机上视觉确认。

复现：`python scripts/verify162.py --version 1.6.6 --output build/verify166-new`。

`native/HomeGlass.m/.s` 保留 1.6.5 的可重建输入；1.6.6 使用 `native/ControlGlass.m/.s`，避免改变旧版负对照。原插件二进制和宿主完整源码不属于本次源码重编译范围。
