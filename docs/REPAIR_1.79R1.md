# FanqieX 1.79R1 测试版

适用番茄小说 7.4.3（7.4.3.33），工作分支 `work/179r1-build`（暂不推送 `test`）。

## 布局修复
- 修复短剧推荐/漫剧信息流中同时存在「原著」标签和底部「观看完整漫剧 / 全集」入口时，扫描优先判别主选集入口与原著入口并在直接定位 `insertAboveProgressView` 与 `progressView` 时保持 12 pt 间距（避免入口贴在进度条与圆点上）。
- 修复点进剧集详情播放页后，「原著 《...》 >」入口贴着进度条的问题：识别 `SSShortVideoOriginalNovelEntranceView` 与相关书关联视图，支持底部/中心点对齐约束，并在详情布局刷新时触发间距校正，保持 12 pt 间距。
- 将「我的」页面快捷功能区（`SSMyUserShortcutCell` / `SSMyUserCollectionView1Cell`）由逐项独立小胶囊改为覆盖白色卡片与底部分页指示器（`UIPageControl`）的一整块圆角（最大半径 18 pt）液态玻璃卡片；清理容器及格子的原生不透明底色，在关闭玻璃或脱离父视图/复用时可逆还原，保留仅图标模式与无障碍/点击行为。

## 新增设置
1. 隐藏书架推荐内容（`FanqieX.ShelfRecommendations.1`，开启后隐藏书架底部推荐内容与瀑布流，保留用户书架书籍及顶部功能区）。

## 验证边界
GitHub Actions 使用 Xcode 27.3/27.2 重新生成 `AlignedGlass` 汇编，构建 ARM64 核心与集成 Objective-C companion，并执行 1.79R1 专项 ARM64 指令回归与现有审计；UIKit 实际渲染、手势与真机注入仍需设备测试。
