# FanqieX 1.9.7beta2 测试版

本版基于 1.9.7beta1，Mach-O 构建标识为 `0x15702`。

插件设置左上角显示版本号。底栏入口和点击震动开关在刷新前保存，重新打开设置时读取已保存的值。

使用现有 IPA 注入和重签名流程，将原有 FanqieX 动态库替换为 `FanqieX-1.9.7beta2.dylib`。同一个宿主只加载一份 FanqieX。

本版真机验证状态为 `device_tested: false`。
