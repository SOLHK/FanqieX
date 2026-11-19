# FanqieX 1.8R14 修复与新功能说明

基于 `1.8R13` 的真机截图、诊断日志与交互反馈，本版完成以下 6 项修复与新增功能：

1. **修复短剧评论底栏悬浮条与“写剧评”按钮消失（根因修复）**：在 `FQXStyleDramaPanel`、`FQXStyleSeriesCommentList`、`FQXStyleCommentBar` 中改用原始 ivar 读取（`FQXRawIvarObj`），避免在评论面板初始化阶段误触发 `_videoCommentVC` / `_kmpVideoCommentVC` / `_seriesCommentVC` / `_writeReviewButton` 的懒加载 getter；并补充挂钩 `FQCShortVideoCommentListBottomBarPlugin -contextDidLayoutEnd`、`FQCShortVideoCommentTopSectionPlugin -contextDidLayoutEnd` 及 `FQCShortPlaySeriesCommentListViewController -setWriteReviewButtonHidden:animated:`，确保短剧底部发评论悬浮条、剧评液态玻璃“写剧评”按钮与“大家都在搜”胶囊稳定呈现。
2. **修复小说段评底栏占位文字缺失**：取消对 `FQCCommentBottomToolBar.bgView` 的隐藏逻辑（改为仅清除背景与边框）并将 `contentLabel` 纳入行高/布局计算，完整保留提示文案与图标。
3. **统一明亮纯白液态玻璃底色（去除评论区偏灰与多色割裂）**：将评论面板与展开输入框统一提升为明亮纯净的浅色液态玻璃底色（浅色模式 `white 1.0 @ 0.66`，深色模式 `0.15 @ 0.60`），悬浮发评论条、“写剧评”按钮与“大家都在搜”胶囊统一使用同色系 `interactive` 液态玻璃层，消除暗视频或阅读页遮罩下发灰及单页多色差问题。
4. **优化智能朗读底部卡片贴边问题**：将“音色设置”卡片右上角 `>` 圆形液态玻璃按钮与“边听边读”卡片右上角 `>` 按钮统一内收至距卡片右缘 `12pt`；同时为“音色设置”内部音色列表增加对称水平内边距，消除卡片内容贴边与拥挤感。
5. **新增短剧“双击打开评论区（关闭双击点赞）”开关**：在短剧设置分类新增 `FanqieX.DramaDoubleTapComment.1` 开关（默认关闭，支持配置备份与搜索）；开启后双击短剧画面（内外短剧流均适配）自动屏蔽双击点赞与红心动画，直接唤起当前集评论区。
6. **保持全版本兼容与多格式打包**：继续不限制宿主版本号并支持多格式分发（`.dylib` / `.zip` / `-rootless.deb` / `-rootful.deb` / `.framework.zip`）。
