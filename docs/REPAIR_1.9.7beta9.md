# FanqieX 1.9.7beta9 测试版

本版基于 1.9.7beta8，Mach-O 构建标识为 `0x15709`。

- **历史页竖向阴影黑线清除**：同步处理 `SSBookHistorySubViewController` 的 `rightMaskView`、`rightGradientView`（及对应 `CAGradientLayer` 遮罩层）与分隔线；当右侧「筛选 / 编辑」按钮隐藏或左侧分类无需横向滚动时自动隐藏边缘渐变遮罩，并在 `categoryLayout`、`loadMaskView:` 与 `layoutCategoryRightButtons` 后置重同步，彻底消除暗色背景下残留的竖向黑线。
- **跨机型短剧顶栏圆角防裁切与对齐**：当可见分类在顶栏内完整容纳时临时解除 `SSVideoFeedTabScrollMaskLayer`（`tabContainer.layer.mask`）对 `x < 0` 与边缘渐变的硬裁切，保证紧凑布局首项留白始终大于外层胶囊水平内边距，补齐 `SSVideoSeriesFeedViewController` / `SSVideoSeriesFeedHeaderView` 全生命周期后置对齐钩子，并基于实际渲染标题中心计算选中底框锚点。
- **短剧与漫剧弹幕功能解锁**：针对宿主客户端灰度实验门控（`kFQCShortVideoDanmakuOpenKey`、`kFQCShortVideoDanmakuNewGenreKey`、`disable_comic_video_danmaku` 与 `supportAll`）提供本地解锁钩子（保留听视频模式与青少年模式安全限制），使未命中灰度的账号及漫剧品类均可正常显示「弹幕」开关与「弹幕设置」入口；可在「短剧 › 播放设置 › 解锁短剧与漫剧弹幕功能」中随时开关。
- **版本更新说明**：插件设置左上角仅显示 `1.9.7beta9`，点击版本号按钮弹出本版更新内容。

沿用现有 IPA 注入及重签名流程，将旧库替换为 `FanqieX-1.9.7beta9.dylib`。同一个宿主只加载一份 FanqieX。

构建报告中的 `device_tested: false` 表示未进行真机验证。
