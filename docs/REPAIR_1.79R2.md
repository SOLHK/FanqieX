# FanqieX 1.79R2 测试版

适用番茄小说 7.4.3（7.4.3.33），工作分支 `work/179r1-build`（暂不推送 `test`）。

## 布局与液态玻璃修复
- 修复短剧推荐/漫剧信息流中同时存在「原著」标签和底部「观看完整漫剧 / 全集」入口时，底部入口贴着进度条的问题：直接定位 `insertAboveProgressView` 与 `progressContainer`，区分主选集入口与原著标签，并在更新锚点约束时通知父容器重新布局上方信息块，稳定保持 12 pt 间距。
- 修复点进剧集详情播放页后，「原著 《...》 >」入口贴着进度条的问题：覆盖 `SSShortVideoOriginalNovelEntranceView` 与 `SSShortVideoBottomDistributionView` 相关书渲染回调（含跨层渐隐包装子视图），稳定保持 12 pt 间距。
- 将「我的」页面快捷功能区统一为覆盖内容区与分页指示器（`UIPageControl` / `FQReaderSaaSBookStoreSelectView`）的一整块圆角（最大半径 18 pt）液态玻璃卡片：在 7.4.3 全宽单元格中解除外层 12 pt 矩形裁剪以完整呈现液态玻璃圆角，并排除带 `lynxVipView` 的会员卡，支持关闭与复用可逆还原。

## 书架推荐与正文短剧广告净化
- 完善「显示书架推荐内容」（`FanqieX.ShelfRecommendations.1`）开关：同步接管 7.4.3 双列推荐管线（`SSBookShelfDoubleColumn` / `SSBookShelfDoubleColumnConfig` / `SSBookShelfSubVCOpenParams` / `SSBookShelfViewModel`），关闭后隐藏「展开全部v」与双列推荐瀑布流，同时保持用户自有书架书籍完整展开并即时刷新管线。
- 移除遗漏的阅读正文内嵌短剧视频推广卡片（如「雾夜守楼人 / 播放全集」）：该卡片并非传统商业 `SSBizAd` 广告槽，而是宿主 7.4.3 新增的站内垂类导流管线（`SSReaderGenreContentManager`、`SSReaderParaShortVideoManager`、`SSReaderParaShortVideoDataManager`、`SSReaderGenreContentRerankManager` -> `SSReaderLayoutProcessData.paraShortVideoAttachmentDict` -> `SSReaderParaShortVideoView`）。现已从策略请求、附件缓存与排版注入全链路拦截。

## 听书状态与耳机线控修复
- 修复关闭听书后仍残留播放态的问题：在 `SSAudioPlaySDKManager` 执行 `audioStopWithEntry:` / `audioResetWithEntry:` 及返回阅读页时，主动清理 `FQReaderSaaSTTSManager` 行高亮与底部「原进度 | 从本页听」同步条，隐藏 `SSReaderTTSParaEntranceManager` 段落左侧播放小标并刷新当前页，同时清空系统 `MPNowPlayingInfoCenter` 残留信息。
- 修复耳机暂停听书后无法用耳机继续播放的问题：在听书暂停期间保持 `AVAudioSessionCategoryPlayback` 会话不被降级（拦截非 `Playback` 类别改写并开启 `audioPlaybackCategoryRecoverEnable`），阻止 `FQVNowPlayingInfoCenter` 与 `disableAllRemoteCommands` 在无视频播放时误禁用 `MPRemoteCommandCenter` 的 `playCommand` / `togglePlayPauseCommand`，并在远程恢复（`remote*` / `toggle*`）时自动激活音频会话且跳过弹窗拦截（`disableIntercept = YES`），保留当前播放时间点无缝续播。

## 验证边界
GitHub Actions 使用 Xcode 27.3/27.2 编译 ARM64 核心与集成 Objective-C 模块，并通过可复现构建与 1.79R2 全部 ARM64 离线回归校验；UIKit 真机动态折射、AirPods 蓝牙路由与 IPA 重签名仍以实机验收为准。
