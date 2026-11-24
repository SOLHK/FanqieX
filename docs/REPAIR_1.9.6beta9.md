# FanqieX 1.9.6beta9 测试版

本版基于 1.9.6beta8，Mach-O 构建标识为 `0x15609`。

11 月 24 日 11:27 的四份 `Reading` 系统崩溃报告均定位到 FanqieX 的 `RefreshChapterTitle`。短剧信息流和全集详情页进入原著后，宿主会在顶部视图创建前调用刷新。插件对空视图调用 `objc_setAssociatedObject`，触发 `EXC_BAD_ACCESS`。

本版在顶部视图为空时直接转发原始刷新，让宿主照常处理阅读初始化。有顶部视图时保留章节名显示。撤回 Beta 8 的外观延迟处理，同时保留两处「原著」入口和上次会话的诊断记录。

用户在 iPhone 上确认，从短剧信息流和全集详情页分别点击「原著」均能进入阅读页，返回短剧也正常。

使用现有 IPA 注入和重签名流程，将原有 FanqieX 动态库替换为 `FanqieX-1.9.6beta9.dylib`。同一个宿主只加载一份 FanqieX。

构建报告中的 `device_tested: false` 表示本地构建流程未运行真机测试。真机结果以上述用户复测为准。
