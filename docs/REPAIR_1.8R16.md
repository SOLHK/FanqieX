# FanqieX 1.8R16 Release Notes

## Changes
1. **图一：修复双击「我的」页面卡一半/白屏偏移**：
   - 挂钩 `SSMyUser621ViewController -tabbarControllerCurrentBtnDidTapAt:` 与 `-shouldInsertUnlimited`。当关闭「我的」推荐内容或列表无长推荐流时，双击「我的」底栏不再触发 `unlimitedBeginRefreshing:animated:` 将页面滚动到空白区域，而是平滑回弹至顶部正常位置并对越界偏移进行安全钳制。
2. **图二：彻底修复短剧顶部「漫剧」关闭后仍显示的问题**：
   - 将「漫剧」（同时兼容「动态漫」标题）升级为与「看剧 / 最近 / 收藏」同级的具名开关 `DramaComicTag`（`FanqieX.DramaComicTab.1`，位于 **短剧 / 顶部分类 / 短剧分类：漫剧**），并同时联动校验与同步所有历史 `FanqieX.DramaCategory.<type>.1` 键值，避免服务端 `tabType` 变化导致「漫剧」重新弹出。
3. **图三 / 图四 → 图五：iOS 26 通知中心同款高通透液态玻璃评论区**：
   - 短剧评论、剧评、展开回复及小说段评面板全面升级为 `UIGlassEffectStyleClear`（`style = 1, tintColor = nil`）原生高通透光学折光玻璃，并在玻璃内层叠加轻柔微压暗亮度背衬（亮色阅读页 `0.34` / 暗背景与短剧 `0.24`），保留锐利通透的液态玻璃边缘高光。
   - 同步开启评论区暗色文字主题并通过 `FQXBoostCommentTypography` 增强正文（高亮白 `0.97` + 微阴影）、元信息（银白 `0.78`）、蓝链（天蓝）与模板图标对比度，在保持苹果通知中心通透感的同时确保极高可视度。
4. **新增开关 — 双指缩放清屏震动反馈**：
   - 在 **短剧 / 播放设置** 新增「**双指缩放清屏震动反馈**」（`FanqieX.DramaPinchHaptic.1`，默认开启，支持搜索与备份）；关闭后双指展开清屏与双指收缩退出均无震动反馈。
5. **恢复剧评页液态玻璃「写剧评」按钮**：
   - 修复 `FQCommunityGradientButton` 因 `+layerClass` 为 `CAGradientLayer`（即 `gradientLayer == btn.layer`）导致隐藏渐变层时误把整个按钮 `btn.layer.hidden = YES` 的根因，改为仅清空 `CAGradientLayer.colors` 并挂载通透 `UIGlassEffectStyleClear` 液态玻璃胶囊与高对比度白色图标文字。
