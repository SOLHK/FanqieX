# FanqieX 1.9.8beta2 修复说明

当前版本：`1.9.8beta2`（Mach-O 构建标识 `0x15802`，诊断日志版本 `1.9.8beta2`）

## 本轮修复与新增内容

### 1. 修复短剧全屏播放与普通首页上下滑动画面抖动（对齐 Honggo 防抖方案）
- **根因**：
  1. 旧逻辑直接改写 `FQVShortVideoListVCPlayerComponent` 的全局尺寸/Frame 返回值，不但破坏 16:9 横版视频 `horizontalVideoAvoidance` 居中基准，而且未同步处理 `FQVShortVideoPlayerCellView -refreshCoverImageView` 设置的等比超界竖屏封面（如 `(-24, 0, 488, 867)`），导致翻页停稳约 `0.3~0.4s` 封面交接给 `TTMetalView` 瞬间画面整体向下跳变 `+44.5pt`。
  2. 单剧/系列剧全屏列表滑入下一集时，共享的 `FQVShortVideoVPlayerSingleSeriesControlView` / `FQVShortVideoVPlayerSeriesControlView`（含底部选集栏）尚未迁移到新 cell，导致新 cell 第 0 帧缺少底部栏高度参考。
  3. 垂直信息流滚动时缺少同步 1:1 跟手背景刷新。
- **修复**：
  - 移除对 `FQVShortVideoListVCPlayerComponent` 宿主几何尺寸的侵入改写，改用 `FQXVideoBackdrop`（`TTPlayerView.layer.sublayerTransform` + 封面等比同步，零侵入宿主布局）。
  - 新增 `FQXVideoBackdropMatchesViewport` 识别居中于 viewport 的等比裁切超界竖屏封面，使其与 `TTMetalView` 共享完全一致的全屏锚点，并在 `vPlayerReadyToDisPlay:` 交接前完成对齐。
  - 在 `FQVShortVideoListViewController` 控制器上缓存已验证的单剧底部栏高度（`FQXDetailOwnerTrayRectKey`），供尚未接管共享 HUD 的滑入 cell 从第 0 帧起对齐，同时与根短剧页 `DramaDockPortraitSize178R4` 互斥共存不重复缩放。
  - 挂钩 `FQVShortVideoListVCScrollComponent -scrollViewDidScroll:` 同步刷新视频背景，无 `topFull.origin.y` 位移拉扯，全程保持画面 1:1 跟手移动。

### 2. 修复短剧/漫剧「双指清屏」滑到下一个视频即失效
- **根因**：
  1. 旧实现将 `FQXPinchPureCleanActiveKey` 存在单个视频 cell 的 `control` 上；滑到下一集时新 cell 未进入清屏，而滑出屏幕的旧 cell 在 `controlViewWillEndDisplay` 触发退出清屏，连带把共享的顶部导航栏与底部 `SSTabBar` Dock 一并恢复显示。
  2. 共享视图遮罩未按视图幂等去重；`FQVShortVideoListVCGestureComponent` 与 `FQVShortVideoVPlayerSingleSeriesControlView` 的宿主捏合手势在内流/漫剧控制层抢占触摸；且 `SSShortVideoOutterMultiGenreFeedControlView` 在子视图禁用交互后需要 `hitTest:withEvent:` 兜底返回自身以接收双指捏合退出手势。
- **修复**：
  - 改为按当前视频流会话宿主（`SSVideoSeriesFeedViewController` / `FQVShortVideoListViewController`）持久化清屏状态（`FQXPinchSessionOwnerForControl`），拆分单 cell 浮层遮罩（`FQXApplyPinchPureCleanToCellControl`，纯读取底层 ivar 与已挂载子视图及 `decorationContentView`，杜绝冷启动触发懒加载按钮）与共享顶栏/底栏/独立圆形 Dock 按钮遮罩（`FQXApplyPinchPureCleanSharedChrome`）及每视图幂等状态保存。
  - 上下滑动切集时新 cell 自动继承清屏态，滑出 cell 仅释放自身浮层遮罩而不误恢复顶栏与底栏；补齐 `hitTest:withEvent:` 命中兜底与宿主 `pinchGesture:` / `handlePinchGesture:` 冲突隔离。

### 3. 新增短剧/漫剧选集面板三项净化开关
- 在「短剧 › 页面内容」新增三项独立开关（默认关闭即保持原样，支持实时生效与设置备份导入导出）：
  1. **隐藏选集原著和更多改编**（`FanqieX.DramaHideEpisodeAdaptations.1`）：接管 `SSShortVideoEpisodeCompositeSubViewController`、`SSShortVideoEpisodeRelatedWorksSectionController`、`SSShortVideoEpisodeBookSectionController`、`SSShortVideoEpisodeMoreRelatedSectionView` 与 `SSShortVideoEpisodesViewController` 相关作品/原著模块及高度归零。
  2. **隐藏选集同系列剧**（`FanqieX.DramaHideEpisodeSameSeries.1`）：接管 `SSShortVideoEpisodesViewController`、`SSShortVideoEpisodesSeriesSectionView`、`SSShortVideoEpisodesSeriesTab` 与 `SSShortVideoEpisodeSeasonSubscribeSectionViewController`（新季预约卡）及高度归零，不影响当前季选集网格。
  3. **隐藏选集底部推荐视频**（`FanqieX.DramaHideEpisodeRecommend.1`）：接管选集双列/三列瀑布流推荐控制器（`SSShortVideoEpisodeDoubleColSectionController`、`SSShortVideoEpisodeGridSectionController`、`SSShortVideoEpisodeTitleSectionController` 等）及请求拦截。

### 4. 优化 FanqieX 设置顶栏按钮视觉
- 左侧版本号胶囊调整为 `96x40` 并采用 `14.5pt Semibold` 自适应标签置于液态玻璃表层之上，与标题 `FanqieX` 比例协调清晰。
- 右侧收起胶囊调整为圆润 `48x40` 比例，使用 `UIGraphicsImageRenderer` 绘制圆角柔和的 iOS 风格向下收起箭头+托盘横杠图标，挂载于 `UIGlassEffect` 表层之上确保在 iOS 26/27 下清晰可见。

### 5. 修复听书「看广告攒时长」、阅读页右下角「听书时长」沙漏挂件净化及番茄 7.4.5 适配补齐
- 完整接管 7.4.3 / 7.4.5 听书激励/预解锁子系统（`SSBizAudioAdInspire*`、`SSAdAudioInspire*`、`SSSpeechToneAudioAdFreeManager`、`BDFQPlayManager` 播放拦截位等），并与「广告与福利 › 听书贴片/信息流广告」及「听书广告专项控制」联动。
- 补齐阅读页右下角 `SSBizAudioAdNewReaderPendantManager` / `SSBizAudioAdNewReaderPendantView` / `SSAudioTTSPreUnlockPendantInsertObj` 粉色沙漏「听书时长」挂件拦截与即时隐藏恢复，修正 `SSWelfareListenPendantManager` 实例方法（`cm = NO`）签名匹配。
- 核对番茄 `7.4.5`（`7.4.5.33`）全量符号表补齐适配：`SSMyUserUnlimitedHelper -unlimitedBeginRefreshing:animated:`、「我的」侧栏 `SSMyUser621SideBarGameSkeletonCell` 与短剧侧栏 `SSVideoSeriesFeedSideBarV725ViewController -showsGameSection` 游戏入口隐藏、设置备份 `0xFFFFF` 掩码上限，以及短剧电商强插卡/直播间/小游戏直玩卡/后贴片与剧情触点广告/直播优惠券与满意度问卷门控。

## 验证摘要
- 通过 `tests/native_layout_sheet_policy_smoke.c`（`-std=c11 -Wall -Wextra -Werror`）、`tests/test_audio_pendant_cleanup_contract.py`、`tests/test_round2_745_and_ui_contract.py` 全量单元测试及 `scripts/verify162.py --version 1.9.8beta2` 完整构建与确定性双次字节一致性校验。
