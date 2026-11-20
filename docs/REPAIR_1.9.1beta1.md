# FanqieX 1.9.1beta1 更新说明

基于 `1.8R19` 真机反馈与日志（iOS 27.3 `24C5049f`），本版进入 `1.9.1beta` 测试系列，重点完成以下两项核心修复：

1. **官方 iOS 26 / iOS 27 液态玻璃 Dock 交互动画重构 (`native/FanqieXMotion.m`)**
   - 移除此前独立套壳的单子节点 `UIGlassContainerEffect`、硬切 `hidden = YES/NO` 显隐跳变、与帧动画冲突的 `CGAffineTransformMakeScale` 拉伸畸变以及拖拽时每秒 120 次叠加的 `0.06s` 延迟动画。
   - 严格采用 Apple 官方 iOS 26 / iOS 27 `UIVisualEffectView.effect` 动画 API：
     - **零跳变起手**：触控瞬间以与静息胶囊像素一致的状态接管，并在 `UIViewPropertyAnimator` + `UISpringTimingParameters` 弹簧动画块内直接将 `effect` 从 `nil` 过渡为交互式 `UIGlassEffect(style: Clear, interactive: YES)`（官方 Materialize 凝结动效）。
     - **克制原生比例与 120Hz 跟手**：选区玻璃透镜保持贴合底栏胶囊比例（不再夸张溢出胶囊上下边缘），横向滑动期间 1:1 直出 120Hz 坐标跟踪并保留边缘阻尼回弹。
     - **官方 Dematerialize 消融落位**：切换落位后在 `UIView.animate` 动画块内平滑将 `effect` 过渡回 `nil` 与轻盈底色胶囊，彻底消除硬切闪烁。
   - 同步 `restingLens` 与交互透镜的 `overrideUserInterfaceStyle` 与底栏代理完全一致，消除浅色系统下深色短剧底栏白圈异常。

2. **去除写评论输入框上方多余暗色遮罩 (`native/FanqieXMotion.m`)**
   - 修复 `FQXStyleCommunityInput` 中当 `paraBgView` 无可见引用文字时仍向上扩展 34pt 玻璃容器、且切换宿主时未调用 `FQXRestoreSheetTopCornerMask` 残留内层圆角白边的问题。
   - 仅当 `paraBgView` 存在真实可见引用文本时才将玻璃卡片扩展至引用行，否则严格锚定在 `containerView` 顶边，并清理 `editor` 上方多余的遮罩、渐变与背景层。
