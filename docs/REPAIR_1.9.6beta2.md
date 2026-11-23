# FanqieX 1.9.6beta2 修复说明

- **版本**：`1.9.6beta2`（Mach-O 构建标识 `0x15602`）
- **基线**：`1.9.6beta1`（`test` 分支）
- **验证状态**：`device_tested: false`（CI 静态审计、构建产物验证与 Xcode 27 交叉编译校验通过；待真机复测确认）

## 一、定位与根因分析（基于 7 张实机截图与诊断日志 `B300F652`）

1. **历史页隐藏筛选与编辑栏后「筛选 / 编辑」仍残留并压在书封上（图二）**：
   - 根因：`1.9.6beta1` 中 `FQXFindHistoryFilterBarCandidates` 在首轮遍历命中宽于 `55%` 视口且包含 2 个以上关键词的左侧分类条（`全部 / 阅读 / 听书 / 短剧`）后直接 `return`，漏掉了右侧独立兄弟容器中的「筛选」「编辑」与竖分隔线；随后 `FQXSyncShelfHistoryFilterBar` 仍把下方历史书架列表上移，导致「筛选 | 编辑」直接叠压在右上角封面之上。
2. **历史页筛选与编辑栏原先仅为单一总开关（图三）**：
   - 需要拆分为 6 个独立按钮开关，支持按需隐藏任意子集且仅在全部隐藏时收起整行高度。
3. **短剧页面角标、题材/季数标签缺少关闭开关，且内页「作者声明」仍可见（图一、图四、图五、图六）**：
   - 标题前置角标（`上新` / `爆款` 等）与标题下方题材/季数标签行（`逆袭` / `都市日常` / `第2季` / `奇幻脑洞` 等）此前无独立关闭开关。
   - 图五内页播放器仍出现「ⓘ 作者声明：内容由AI生成」，根因是 `AlignedGlass.m` 中 `DramaVisibilityAuthor` 对 `SSShortVideoBelowLeftContainerViewManager.shouldAddAiUsageView` 仅在 `DramaVisibilityIsMainFeed(self)` 为真时生效，进入选集内页播放器时被放行。
4. **小说评论区开启液态玻璃后画面整体变亮**：
   - `B300F652` 日志显示浅色模式打开段评面板（`FQCParagraphCommentListViewController`，`darkTheme: false`，`materialStyle: 1`）时：
     1. 整块大尺寸评论面板背景使用 `UIGlassEffectStyleClear` 且同时开启了 `interactive = YES`、绑定了 `_flexInteractionGestureView` 并采用浅色外观（`UIUserInterfaceStyleUnspecified` 解析为 `Light`），在 iOS 26/27 下产生 `+35 ~ +53` 亮度级的白光光学抬升与交互式高光增益，使原本柔和的小说纸张底色在弹层出现后明显发亮。
     2. `FQXCleanCommentPresentationBackdrops` 向上扫描祖先层级至 `UIWindow` 时缺少对阅读页护眼/亮度遮罩类的显式保护，在过渡容器自带遮罩已清扫后仍可能继续触及上层阅读器视图。
5. **「我的」页面快捷功能卡片圆形按钮偏小（图七）**：
   - `AlignedGlass.m` 中 `ProfileEntryGlass` 将圆形玻璃直径上限锁在 `50pt`（并受限于单元格高度 `- 8pt` 与 `25pt` 最大圆角），图标高度上限锁在 `24pt`，在纯图标模式下圆形按钮与卡片留白比例偏小。

## 二、本轮修复内容

1. **拆分历史页筛选栏为 6 个独立按钮开关并根治「筛选 / 编辑」残留重叠（`native/FanqieXMotion.m`、`native/FanqieXCleanup.m`、`native/FanqieXSettingsMenu.m`、`native/FanqieXSettingsBackup.m`）**：
   - 在 `书架净化 / 筛选栏标签` 中将原先单一的「隐藏历史页筛选与编辑栏」拆分为 6 个独立开关（兼容旧版 `FanqieX.ShelfHistoryFilterBar.1 = NO` 一次性自动迁移）：
     - `隐藏历史「全部」标签`（`FanqieX.ShelfHistoryFilterAll.1`）
     - `隐藏历史「阅读」标签`（`FanqieX.ShelfHistoryFilterRead.1`）
     - `隐藏历史「听书」标签`（`FanqieX.ShelfHistoryFilterListen.1`）
     - `隐藏历史「短剧」标签`（`FanqieX.ShelfHistoryFilterDrama.1`）
     - `隐藏历史「筛选」按钮`（`FanqieX.ShelfHistoryFilterBtn.1`）
     - `隐藏历史「编辑」按钮`（`FanqieX.ShelfHistoryEditBtn.1`）
   - 重写 `FQXSyncShelfHistoryFilterBar` 全行扫描逻辑：不再命中左侧分类条后提前返回，而是完整定位左侧分类条（`UICollectionView` 或普通按钮容器）、右侧「筛选」按钮、「编辑」按钮与中间竖分隔线；隐藏任意一侧按钮时自动隐藏分隔线、单留「筛选」时自动靠右对齐；**仅当 6 个按钮全部隐藏时**才收起整行并上移书架列表，只要仍有任意按钮可见即保持列表原位，彻底杜绝按钮叠压封面。
2. **新增短剧标题角标与题材/季数标签关闭开关，并补全内页「作者声明」隐藏（`native/FanqieXMotion.m`、`native/FanqieXCleanup.m`、`native/FanqieXSettingsMenu.m`、`native/FanqieXSettingsBackup.m`）**：
   - 在 `短剧 / 页面内容` 新增两项独立开关（默认关闭，支持实时刷新与备份恢复），并将「隐藏短剧系列剧追剧标签」一并归入该分组：
     - `隐藏短剧标题角标（上新/爆款）`（`FanqieX.DramaHideTitleBadge.1`）：同时兼容富文本内联 `NSTextAttachment`/`YYTextAttachment` 角标前缀与独立左侧角标视图，隐藏后标题与 `>` 箭头自动左对齐，单元格复用或关闭开关时无损恢复。
     - `隐藏短剧题材与季数标签`（`FanqieX.DramaHideGenreTags.1`）：精准隐藏标题与剧情简介之间的题材/季数/演员标签行（`逆袭`、`都市日常`、`第2季`、`奇幻脑洞`等），并平滑收起垂直空隙，不影响标题、原著入口与选集栏。
   - 在 `FanqieXMotion.m` 中对 `SSShortVideoBelowLeftContainerViewManager.shouldAddAiUsageView` 增加后置 Hook 并在控制层补充兜底扫描，使「显示作者声明」关闭后在**外层信息流与选集内页播放器**中均可生效，彻底隐藏「ⓘ 作者声明：内容由AI生成」。
3. **修复小说评论区液态玻璃打开后画面变亮（`native/FanqieXMotion.m`）**：
   - 区分大面积评论面板背景玻璃（`isSheetBackdrop = YES`）与小尺寸交互输入胶囊：面板背景关闭 `UIGlassEffect.interactive` 并断开 `_flexInteractionGestureView`，消除全屏交互式高光增益与触控闪亮。
   - 浅色清透液态玻璃评论表面采用 `UIUserInterfaceStyleDark` + `tintColor = nil` 中性透明光学曲线（评论宿主面板与文字/图标仍保持浅色深墨水极性），彻底消除 iOS 26/27 浅色 `Clear` 玻璃的亮白亮度抬升。
   - 加固 `FQXCleanCommentPresentationBackdrops`：跳过护眼/亮度/色温类视图并禁止跨越已清理的过渡容器触及 `BDReader*` 视图或窗口级阅读器护眼遮罩。
4. **放大「我的」页面快捷功能圆形按钮（`native/FanqieXMotion.m`）**：
   - 在 `HookMineFunCellLayoutForBadge`、`HookMineOrderCellLayout` 与 `HookMineEntryItemLayout` 中新增 `FQXEnlargeMineShortcutButtonInCell`，在确保不遮挡底部分页圆点、不超出卡片与单元格间距的前提下，将圆形玻璃按钮由原 `42–50pt` 等比放大至最高 `62pt`（纯图标模式）/ `60pt`（图文模式），同步解除 `25pt` 圆角上限保持正圆，图标放大至 `26–32pt` 并严格居中，同时在 `FQXMineShortcutViewport` 预留垂直裁剪余量避免裁切。

## 三、待真机复测项

- **历史页筛选栏**：分别单独关闭/开启「全部」「阅读」「听书」「短剧」「筛选」「编辑」，确认任意组合无残影、无错位、不叠压书封；全部关闭时整行无缝收起。
- **短剧页面内容开关**：在推荐/漫剧/内页播放器分别开关「隐藏短剧标题角标（上新/爆款）」「隐藏短剧题材与季数标签」「显示作者声明」，确认滑切复用正常且无空白断层。
- **小说评论区亮度**：在浅色护眼/米色纸张及调低阅读亮度下打开/关闭液态玻璃段评区，确认画面亮度自然一致不再发亮。
- **「我的」快捷功能卡片**：验证纯图标与图文模式下圆形按钮尺寸饱满协调、无裁切、点击响应正常。
