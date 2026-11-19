# FanqieX 1.8R15 Release Notes

## Changes
1. **图一 / 图二 / 图四统一升级为图三同款原生通透液态玻璃风格**：
   - 评论区卡片面板（短剧评论、剧评、展开回复、小说段评）去除高不透明度纯色 `tintColor` 遮盖，切换为与悬浮底栏一致的原生无染色 `UIGlassEffectStyleRegular`（`style = 0, tintColor = nil`），还原通透折光与边缘高光。
   - 底部悬浮发评条（短剧 `FQCShortVideoBottomToolBar` / 小说 `FQCCommentV1BottomToolBar`）、「大家都在搜」搜索胶囊与「写剧评」按钮升级为原生 `UIGlassEffectStyleClear`（`style = 1, interactive = YES, tintColor = nil, capsuleConfiguration`）悬浮液态玻璃胶囊。
2. **图一 / 图四底部发评论真正悬浮 + 去除底栏遮罩**：
   - 扩展评论列表 `collectionView` / `containerScrollView` 高度直达面板底部并动态维护安全底部 `contentInset` 与滚动条边距，彻底消除发评条上方的硬裁剪线与底栏遮罩，评论内容与图片可流畅滚动穿过悬浮液态玻璃胶囊下方。
   - 清理 `toolbar`、`bgView`、`textView`、`_sendButtonBackgroundImageview`、各类 CoverView 及渐变遮罩层，仅保留通透悬浮玻璃胶囊。
3. **图二「已为你隐藏不可见评论」小白块及滚动新增 Cell/Footer 彻底清理**：
   - 新增挂钩 `FQCShortVideoCommentInvisibleTipCell`（`layoutSubviews` / `bindViewModel:`）、`FQCCommentFoldCell`、`FQCCommentEmptyCell`、`FQCShortVideoCommentSeriesIntroCell`、`FQCShortPlayReplySectionFooterView`（`setupTheme`）、`FQCParagraphCommentV1SectionFooterView`（`layoutSubviews` / `setupTheme`），并放宽 `FQCShortVideoCommentCommonCell` 通用清理范围，避免滚动复用或展开回复时出现纯白底块。
