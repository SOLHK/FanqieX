# FanqieX 1.9.7beta5 测试版

本版基于 1.9.7beta4，Mach-O 构建标识为 `0x15705`。

插件设置首页的两侧控件对称排列，番茄小说设置页调整入口间距，并将插件入口命名为「FanqieX」。

使用现有 IPA 注入和重签名流程，将原有 FanqieX 动态库替换为 `FanqieX-1.9.7beta5.dylib`。同一个宿主只加载一份 FanqieX。

构建报告中的 `device_tested: false` 表示构建流程未进行真机验证。
