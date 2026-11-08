FanqieAdBlock 1.6.0 / FanqieX

使用现有 IPA 注入和重签名流程替换旧插件；同一个宿主只加载一份 FanqieAdBlock。
本文件是 ARM64 动态库，不能直接点击当作独立 iOS 应用安装。

修复范围：首次显示/切页的滚动边缘与列表布局、阅读返回箭头的系统符号、
阅读菜单/底部的有界样式处理、完整按钮的原生玻璃及留白。
保留去广告、主底栏交互、诊断入口和最近一小时导出。

本包二进制已通过可复现构建、结构与签名检查及明确范围的 ARM64 离线回归。
构建器支持并要求云端发布校验使用 Xcode 27.2 / iOS 27.2 SDK。
对应提交的真实云端构建结果见 GitHub Actions，不能从本地报告推断它已经通过。
尚未在用户 iPhone 上验证最终合成、点击到菜单显示的实际延迟及 IPA 注入。

SHA-256: 2da6826d63d5e05ec6c2f20d3375d58186474490c9c92dc09c2cc734529560b1
大小: 139792 bytes

源码与下载：https://github.com/SOLHK/FanqieX/tree/test
构建记录：https://github.com/SOLHK/FanqieX/actions
设备验收：docs/DEVICE_ACCEPTANCE_160.md
