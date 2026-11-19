# FanqieX 1.8R13 修复说明

基于 `1.8R12` 与真机日志及界面反馈，本版完成以下 8 项修复与扩展：

1. **短剧全集播放底部黑遮罩彻底去除**：扩展 `FQVShortVideoListVCPlayerComponent` 的 `scaleAspectFitPlayerViewSizeWithModel:`、`portraitPlayerViewFrameWithModel:`、`scaleAspectFitContainerViewFrameWithModel:` 及 `FQVShortVideoPlayerCellView` 的 `playerSuperView` 画布与 `FQVShortVideoVPlayerSingleSeriesControlView` / `FQVShortVideoVPlayerSeriesControlView` 底层容器背景，使竖屏短剧全集画面铺满至选集底栏下方，消除进度条下方的黑色遮罩。
2. **短剧与小说展开评论输入框左右全宽铺满**：去除 `FQXStyleExpandedCommentInput` 的左右 10pt 留白，改为左右与底部紧贴键盘工具栏的顶部双圆角液态玻璃卡片；小说段评输入框同时包裹引用原文行（`paraBgView`），并挂钩 `FQC503CommentInputView` 布局与主题回调避免嵌套白底。
3. **后台切回前台评论区变纯白卡片修复**：挂钩短剧/剧评评论面板与列表的 `setupTheme`、`adaptDarkModeIfNeed`、`traitCollectionDidChange:`、`onDarkModeChange:`，并监听 `UIApplicationWillEnterForegroundNotification` / `UIApplicationDidBecomeActiveNotification`，回到前台后自动重新同步液态玻璃外观。
4. **智能朗读页面四颗圆形液态玻璃按钮优化**：移除会裁切玻璃高光边缘的 `CAShapeLayer` 遮罩和外层 `clipsToBounds`，改用原生 1:1 正圆 `UIGlassEffect` + `UICornerConfiguration.capsuleConfiguration`（顶栏返回/更多升级为 42pt 并拉大与书名箭头的间距，底栏目录/定时为 54pt 正圆），与中间播放控制按钮保持统一质感。
5. **评论区“大家都在搜”搜索入口液态玻璃胶囊美化**：挂钩 `FQCShortVideoCommentSearchEntranceView`（`layoutSubviews` / `configThemeWithDarkMode:`），为其包裹自适应文本宽度的透明液态玻璃胶囊芯片。
6. **解除宿主版本号硬编码限制（全版本适配）**：移除 `FQHCompatibleHost` 中对 `CFBundleVersion == 7.4.3.33` 的绑定，并扩展 `FQHHostBundle` 同时支持 `com.dragon.read` 及自定义包名重签/多开的番茄小说宿主，各功能按运行时类与方法签名按需挂载。
7. **多格式分发打包**：新增 `scripts/package_formats.py`，从同一份通过 CI 校验的 dylib 无损生成 `.dylib`、`.zip`、`-rootless.deb`（`iphoneos-arm64`）、`-rootful.deb`（`iphoneos-arm`）与 `.framework.zip`。
