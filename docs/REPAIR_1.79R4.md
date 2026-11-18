# FanqieX 1.79R4 测试版

适用番茄小说 7.4.3（7.4.3.33），工作分支 `work/179r1-build`（暂不推送 `test`）。

## 1. 紧急修复 1.79R3 导入后打不开软件 / 界面卡死
- **根因 1（`dyld` 初始化死锁）**：1.79R3 在 `FQHPageInstall()`（位于 Mach-O `__init_offsets`，由 `dyld` 在 `UIApplicationMain` 之前持加载器锁执行）内同步调用了 `FQXGlassEnabled()`（触发 iOS 26/27 Swift 桥接类 `UIGlassEffect` / `UICornerConfiguration` 的 `+initialize`）以及 `[NSNotificationCenter.defaultCenter addObserverForName:NSUserDefaultsDidChangeNotification ... queue:NSOperationQueue.mainQueue]`，导致启动阶段在写出首条诊断日志前即发生主线程死锁。本版改为仅执行纯 C `libobjc` 自有方法安装，玻璃开关切换由 `FQXSettingsMenu` 直接通知 `[FQXDockMotion refreshAudioGlass]`。
- **根因 2（首帧布局循环与悬垂关联标记）**：移除 `FQXTabBarInteraction` 在 `SSTabBar -layoutSubviews` 中对 `proxy` / `proxy.contentView` `clipsToBounds` 的写入（避免触发 iOS 26/27 `UIVisualEffectView` 内部重排死循环），将 `OBJC_ASSOCIATION_ASSIGN` 裸指针全部替换为自动清零的 `NSHashTable weakObjectsHashTable`，并将透明交互水滴透镜改为仅在手指按下/拖动时按需挂载；同时将跨继承链的 `didMoveToWindow` 同步 `layoutIfNeeded` 替换为播放器控制器自有 `viewDidAppear:` 异步 `setNeedsLayout`，移除 `SSNewAudioPlayViewController -viewDidLayoutSubviews` 钩子。
- **段容量回落**：精简 `AlignedGlass.m` 重复辅助逻辑，使 `__FQPATCH` 代码体积重新收敛至与 1.79R2 完全一致的 `0x5c000`（23 页）。

## 2. 修复耳机单击不能播放 / 恢复听小说
- **解除 `MixWithOthers` 对系统耳机路由的屏蔽**：宿主 `BDFQAVSpecialLogicConfig` 与 `SSAudioPlaySDKManager` 在开启“允许与其他应用同时播放”时会附加 `AVAudioSessionCategoryOptionMixWithOthers` 并关闭 `showCommandCenter`，导致暂停后 iOS `mediaserverd` 不再把耳机单击事件路由给番茄小说，且 `BDFQPlayManager` 主动移除远程控制。本版在听书存活且无短剧视频播放时强制保持独占 `AVAudioSessionCategoryPlayback`（无 `MixWithOthers`）与 `showCommandCenter = YES`。
- **清理短剧 `FQVNowPlayingInfoCenter` 残留冲突目标**：当无短剧播放（`playingPlayer == nil`）且听书存活时，主动调用 `removeRemoteCommandTarget` 卸载短剧残留 target，防止其 `handlePlayCommand` 返回 `MPRemoteCommandHandlerStatusCommandFailed (200)` 或通过 `refreshRemoteCommandEnable` 将 `playCommand.enabled` 置为 `NO`。
- **补全 AirPods `playCommand`（`source = @"play"`）与异步暂停保护**：拦截 `SSAudioMutualExclutionManager -removeAudioRemoteCommandIfNeeded` 误删听书远程命令；针对 `BDFQPlayManager -pauseWithSource:` 异步暂停窗口期及耳机单击触发的 `tryToPlayWithSource:@"play"` / `@"toggle"`，自动激活播放会话并设置 `disableIntercept = YES` 直接恢复朗读。

## 3. 完整保留 1.79R3 全部优化
- 「我的」页面整块液态玻璃快捷卡片（消除底部分页条白底裁切）+ 内部协调放大的单格独立液态玻璃按钮。
- 短剧信息流、详情页跨层渐隐及从原著返回后的 12 pt 进度条间距保护。
- 智能朗读 / 听书页 1~7 号控件 iOS 26 液态玻璃（含 7 号音色卡片内部独立液态玻璃按钮）。
- 5 项新增净化开关（隐藏我的顶部扫一扫 / 搜索框 / 夜间按钮 / 快捷功能卡片，以及隐藏听书页推荐内容 8 号）。
- 悬浮底栏在默认尺寸与所有缩放档位下的 Apple Store 风格液态水滴点击与滑动交互动画。
