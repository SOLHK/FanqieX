FanqieAdBlock 1.6.1 / FanqieX

使用现有 IPA 注入和重签名流程替换旧插件；同一个宿主只加载一份 FanqieAdBlock。
本文件是 ARM64 动态库，不能直接点击当作独立 iOS 应用安装。

修复范围：阅读页顶部按钮恢复宿主原始图标与布局；主底栏选择交互交给
系统原生 UISegmentedControl，保留番茄原始选页路径，由系统管理选择透镜。
不在原生控件后叠加第二层玻璃；无法创建时回退单 Regular 玻璃与普通选中底色。
兼容回退的拖动定位已修正。
保留去广告、主底栏交互、诊断入口和最近一小时导出。

本包二进制已通过可复现构建、结构与签名检查及明确范围的 ARM64 离线回归。
构建器支持并要求云端发布校验使用 Xcode 27.2 / iOS 27.2 SDK。
对应提交的真实云端构建结果见 GitHub Actions，不能从本地报告推断它已经通过。
尚未在用户 iPhone 上验证最终合成、系统选择透镜的光学表现及 IPA 注入。
宿主 SDK 与系统兼容模式可能影响原生控件外观；插件不会伪造宿主 SDK 或修改全局设计模式。

SHA-256: 8c8aedc3643c52efa1180119a983c8cd22006123ea095db617ea901be0fbcf8e
大小: 156304 bytes

源码与下载：https://github.com/SOLHK/FanqieX/tree/test
构建记录：https://github.com/SOLHK/FanqieX/actions
设备验收：docs/DEVICE_ACCEPTANCE_161.md
