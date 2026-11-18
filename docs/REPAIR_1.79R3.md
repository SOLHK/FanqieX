# FanqieX 1.79R3 测试版

适用番茄小说 7.4.3（7.4.3.33），工作分支 `work/179r1-build`（暂不推送 `test`）。

## 液态玻璃与间距深度修复
- **「我的」快捷功能卡片与内部液态玻璃按钮**：清除底部全宽分页指示条（`FQReaderSaaSBookStoreSelectView` / `_indicatorBgView`）的纯白遮挡背景并解除外层矩形裁剪，消除卡片底部“被砍一截”的现象；同时在外层整块液态玻璃卡片内部恢复每个快捷入口的独立交互式液态玻璃按钮（圆角最大半径 14 pt），并将按钮与图标尺寸协调放大（图标由 20 pt 提升至 24–26 pt，兼顾图文模式与仅图标模式）。
- **短剧「原著」与进度条间距全场景根治**：解决 `SSShortVideoBottomDistributionView` 在 `performForegroundCrossfadeWithRenderBlock:` 渐隐初态（`alpha = 0`）无法测距、`maskViewContainer` 子树约束未同步标记重排、以及点击原著进入阅读器再返回（`didMoveToWindow` 重新挂载）后锚点被清零未重算的问题，始终稳定保持 12 pt 间距。
- **智能朗读 / 听书页（1号～7号）接入 iOS 26 液态玻璃 API**：
  - **1号 & 2号**：左上角收起按钮（`SSNewAudioPlayNavigationView` / `SSAudioPageBackView`）与右上角更多按钮采用 iOS 26 `UIGlassEffect` 圆形交互玻璃。
  - **3号**：书籍信息行右侧箭头（`SSNewAudioPlayBookView.bookNameArrowView`）增加圆形液态玻璃底衬并保留原点击热区。
  - **4号**：五项功能栏（语速 / 加入书架 / 下载 / 章评 / 更多）整合为液态玻璃胶囊条并附带按压回弹玻璃高亮。
  - **5号 & 6号**：播放控制栏左侧「目录」与右侧「定时」按钮（及中部播放控制底衬）升级为 iOS 26 交互式液态玻璃按钮。
  - **7号**：「音色设置」与「边听边读」双外层卡片采用不裁切底部的完整液态玻璃卡片，同时「音色设置」内部的每个音色选项（`SSAudioPlayToneCell`，如「升级版」「成熟大叔音」）均独立构建为 iOS 26 液态玻璃按钮，区分选中高光边框与未选中态。

## 新增页面净化移除开关
- **我的页面净化**：
  - `隐藏我的顶部扫一扫`（`FanqieX.MineScanButton.1`）
  - `隐藏我的顶部搜索框`（`FanqieX.MineSearchBar.1`）
  - `隐藏我的顶部夜间按钮`（`FanqieX.MineNightButton.1`，保留最右侧菜单入口）
  - `隐藏我的快捷功能卡片`（`FanqieX.MineShortcutCard.1`）
- **阅读 / 听书页面净化**：
  - `隐藏听书页推荐内容`（`FanqieX.AudioRecommendations.1`，对应图四 **8号**，关闭后隐藏底部推荐瀑布流并收紧滚动高度，即时生效）。

## 底栏 Apple Store 级交互动画（全尺寸档位支持）
- 为悬浮底栏新增 `FQXTabBarInteraction` 交互式透明液态玻璃水滴透镜（`UIGlassEffect` Clear 交互材质 + 弹性物理曲线）：无论是默认尺寸，还是在插件外观设置中调小胶囊长度、高度、按钮宽度或开启仅图标模式，按下、快速点按切换或横向拖动底栏按钮时，均呈现水滴纵向微凸膨胀、跨标签弹性滑移与柔和回落定型的 Apple Store 同款交互动画。

## 验证边界
GitHub Actions 使用 Xcode 27.3/27.2 编译 ARM64 核心与集成 Objective-C 模块，并通过可复现构建与 1.79R3 全部 ARM64 离线回归校验；真机光学折射细节与触控手感以 iOS 26+ 实机验收为准。
