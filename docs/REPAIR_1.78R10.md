# FanqieX 1.78R10 测试版

基于本地 1.78R9 提交 `dd42faa`，处理这次四张实机截图。

- 阅读页返回箭头与玻璃圆心对齐，使用该按钮的原生图片内边距保留后续布局结果，关闭玻璃后恢复原值。
- 横屏返回按钮与标题留出 8 pt；弹幕输入框移除遮挡玻璃的宿主背景层；倍速、清晰度和选集在自身尺寸布局完成后添加玻璃。
- 书架按钮放大，文字与图标按同一中心对齐，时长、编辑与筛选增加内边距。
- 我的页快捷入口扩大玻璃与文字空间，图标和文字整体居中。

阅读页返回按钮在宿主中是未设置 configuration 的普通 UIButton。原生 imageEdgeInsets 的布局含义参考 [Apple 文档](https://developer.apple.com/documentation/uikit/uibutton/imageedgeinsets?language=objc)。本次只修改该返回按钮，不安装全局 UIButton Hook。

个人页快捷玻璃使用 [Apple 的胶囊最大圆角配置](https://developer.apple.com/documentation/uikit/uicornerconfiguration-c.class/capsuleconfigurationwithmaximumradius%3A?language=objc)，保留 18 pt 圆角，给文字两侧留下空间。

安装时移除旧 FanqieX / FanqieAdBlock 动态库，再注入本包并重新签名。同一 App 只加载一份；重启后确认版本为 **1.78R10**。

请重点检查四张截图中的居中、文字留白和玻璃显示，并点击返回、发弹幕、倍速、清晰度、选集及书架、个人页入口确认交互。

本轮使用 Windows Clang 18 ARM64 Objective-C 编译与 LLVM 汇编。实际执行的相关 ARM64 回归、候选 SHA 和二进制检查见 `VERIFICATION.json`。未运行 Xcode 构建、iPhone 安装及真实 UIKit 渲染测试，实机观感和触控仍待确认。
