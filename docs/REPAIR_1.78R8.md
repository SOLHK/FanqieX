# FanqieX 1.78R8 测试版

本版基于 1.78R7，协调底栏和短剧按钮的液态玻璃材质，补上短剧小按钮的玻璃外观以及阅读原著入口开关。

- 统一使用 Apple 的 Regular 液态玻璃，底栏全部图标使用系统前景色，提高浅色背景下的可读性。移除听书和书架筛选按钮各自附加的背景染色。
- 使用公开的 `UIGlassEffect` 与 `UIButtonConfiguration.glassButtonConfiguration`，运行时检测接口可用性，由手机所运行的 iOS 提供实现。这些 API 从 iOS 26 起可用，iOS 27 使用系统中提供的同一套公开接口。
- 视频播放页的玻璃控件统一采用与白色图文对应的深色材质。玻璃仍会采样周围画面，视频内容变化时折射和明暗也会变化。
- 补齐视频卡片重新显示、进度轨道布局和播放状态更新后的间距计算，让全集入口与可见轨道维持 8 pt。
- 「阅读原著」显示开关默认开启，关闭后隐藏该入口。「弹」「发弹幕」「全屏观看」采用一致的原生玻璃背景。

公开 API 参考见 [Apple UIGlassEffect](https://developer.apple.com/documentation/UIKit/UIGlassEffect?language=objc) 和 [UIButton 玻璃配置](https://developer.apple.com/documentation/uikit/uibuttonconfiguration/glassbuttonconfiguration)。

## 安装和复测

1. 移除旧 FanqieX 或 FanqieAdBlock 动态库，注入 1.78R8 的 dylib 并按原流程重新签名。
2. 重启番茄小说，在插件设置或诊断日志中确认版本为 1.78R8。
3. 在深浅背景上检查底栏与短剧玻璃按钮的外观，验证短剧控件点击和阅读原著入口开关。

构建与离线验证范围以随包报告为准。iPhone 上的玻璃合成和触控需要实机复测。
