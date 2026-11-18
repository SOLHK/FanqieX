# FanqieX 1.79R5 修复与更新说明

## 核心修复与新增特性

1. **修复「短剧滚动自动收缩」无法关闭并自动恢复开启**
   - 根因：`FQXSettingsMenu` 在配置「底栏收缩」子页面开关时调用 `-[UIControl removeTarget:nil action:...]`，UIKit 对 `nil` target 采用通配移除策略，误删了宿主 `FanqieAdBlockOptionsController` 上的持久化回调 `fqx178_bottomOptionChanged:`。
   - 修复：改为按明确非空 target 移除重复监听器，并在 `nativeToggleChanged:` 中即时持久化 `FanqieX.BottomDramaCompact.1` 与联动刷新底栏状态。

2. **底栏 Apple Store 透明折射液态透镜与粘滞流体动效**
   - 采用 iOS 26/27 `UIGlassEffectStyleClear` 前置无描边透明光学透镜（`overrideUserInterfaceStyle = Unspecified`），浮动于图标与文字正上方实时折射扭曲边缘像素。
   - 重构点击与滑动手势时序：点击跨标签时透镜从原选中标签平滑滑移并膨胀跨越至目标标签，停留展现完整折射后以高阻尼粘滞弹簧优雅融回常态胶囊；滑动时随手指水平速度自适应拉伸形变，彻底消除「一闪而过」的突兀感。

3. **短剧播放与布局优化**
   - **原著返回零延迟间距**：放宽 `UINavigationController` 侧滑返回视差区间（`-0.5 * screenWidth .. +2`）并在 `viewWillAppear:` + `transitionCoordinator` 同步布局，消除从原著返回时胶囊贴进度条再跳动的问题。
   - **全场景强制 1080P+ 最高画质**：接管 `FQVPlayerEngineDataResolutionItem -finalResolutionTypeWithSupportResolutions:videoModel:` 及播放器准备完成回调，在推荐流、漫剧、看剧、剧集内页与横屏全屏均强制选择最高像素/码率档位（1080P+），仅当用户手动切换当前视频画质时保留手动选择。
   - **「查看全集与进度条跟随底栏长度」开关**：新增 `FanqieX.DramaFollowBottomWidth.1`（默认开启，可在「短剧 -> 底栏收缩」或「外观 -> 玻璃与尺寸」随时关闭恢复全宽）。
   - **移除剧集内页（第 2 集等）底部黑色遮罩**：在竖屏下将内页视频画布延伸至屏幕底端，清除 `SSShortVideoBottomInsertView` / `FQVShortVideoPlayerBottomView` 黑底并羽化底部渐变边缘。
   - **双指缩放切换纯净清屏**：在「短剧 -> 播放设置」新增 `FanqieX.DramaPinchPureClean.1`，开启后双指张开进入纯净清屏（隐藏全部控件与底栏/顶栏），双指收缩退出清屏。

4. **智能朗读（听书）液态玻璃协调重构与歌词透射**
   - 圆形按钮统一：顶部返回/更多（`38×38`）、书名箭头（`28×28`）、5/6 号「目录 / 定时」（`54×54` 正圆，对齐播放控制圆钮）、「音色设置 >」箭头（`28×28`）、「边听边读 >」箭头（`26×26`）。
   - 大倒角无描边卡片：4 号菜单栏（`22 pt` 透明折射玻璃）、7 号外层卡片（`24 pt`）与内部音色按钮（`18 pt`）统一采用屏幕级连续大倒角并移除人工白边。
   - 1 号歌词实时折射与 2/3 号去阴影：向下延伸 `_pageContainerView` 与 `_captionMaskLayer` 不透明区至 1 号后方，隐藏 `_bottomMaskView`、`_bottomBgMaskGradientLayer` 与 `_bottomBgView`，实现歌词透过 1 号液态玻璃清晰折射且关闭推荐后背景浑然一体。

5. **阅读器、「我的」快捷卡片与设置菜单排序**
   - 阅读页正文行尾段评气泡（`FQCReaderParagraphEndView`）与章末书圈入口（`SSReaderChapterEndForumEntranceView`）接入自适应液态玻璃。
   - 修复阅读页左上角返回按钮 `<` 图标被 UIKit 边界夹紧偏左的问题，光学居中对齐圆形玻璃中心。
   - 修复「我的」快捷入口折叠态第 6 个按钮（游戏中心）向下凸出外层卡片的问题，并协调放大内部液态玻璃按钮与图标比例。
   - 一级设置菜单排序调整：「导出与备份」置于「诊断与其他」正上方，「诊断与其他」置于「书城」下方及除 Telegram 频道外所有一级菜单最底部。
