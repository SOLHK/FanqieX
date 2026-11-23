# FanqieX 1.9.6beta3 修复说明

- **版本**：`1.9.6beta3`（Mach-O 构建标识 `0x15603`）
- **基线**：`1.9.6beta2`（`test` 分支）
- **验证状态**：`device_tested: false`（CI 静态审计、构建产物验证与 Xcode 27 交叉编译校验通过；待真机复测确认）

## 一、定位与根因分析（基于 5 张实机截图与诊断日志 `D9ABA429`）

1. **短剧顶部胶囊切换交互动画存在 0.24–0.65 秒延迟（图一）**：
   - `D9ABA429` 日志记录了完整切换时序：`20.788s -> 21.031s`（`+243ms`）、`22.988s -> 23.249s`（`+261ms`）、`24.696s -> 24.947s`（`+251ms`）、`26.263s -> 26.514s`（`+251ms`）、`27.755s -> 27.997s`（`+242ms`），滑动期间均出现 `pillHidden: true`。
   - 根因：
     1. `HookDramaScrollBetweenTabs` 在横向滑动过程中将 `interaction.paging` 置为 `YES` 并调用 `placePill:CGRectZero` 直接隐藏选中胶囊，直到滑动减速彻底结束、`commitSelectedTabIndex:` 在 240–400ms 后回调时才重新显示并补播长达 `0.42s` 的弹性动画，造成“页面早已滑到看剧/漫剧，顶栏过零点几秒才开始动”的明显滞后感。
     2. 点击切换时 `handlePress:` 松手瞬间会立刻将胶囊弹回原位，再等宿主回传新选中索引后二次跳动，且切换期间玻璃材质切换带有 `0.20s` 额外淡入耗时。
2. **「我的」页面快捷功能圆形按钮上下错位且与底部分页圆点叠压（图二、图三）**：
   - `D9ABA429` 日志显示单元格实际尺寸为 `cellWidth: 60`、`cellHeight: 47`、`availCardH: 79`，而 `SSScrollFoldFuncView` 在第 1 页（单行展开约 `83pt`）与第 2 页（展开约 `148pt`）之间会动态变化高度。
   - 根因：`1.9.6beta2` 的 `FQXEnlargeMineShortcutButtonInCell` 依据外部卡片 `card.bounds` 换算出的 `topLimit + availH * 0.5` 作为圆形中心纵坐标；不同单元格在折叠/展开或分页动画的不同帧触发 `layoutSubviews` 时捕获了不同的卡片高度，导致同排按钮纵向落差达 `16–24px`（第 1 页「订单/历史/消息」下沉并直接压在底部分页圆点上，第 2 页「游戏/钻石」偏高、「反馈/下载」偏低）。此外，`SSMyUserCollectionViewOrderFunCell` 与 `SSMyUser621FunctionEntryItemCell` 的图标属性选择顺序与 `AlignedGlass.m` 不一致。
3. **「分享页面材质」「评论区材质」中仍保留多余的「原书底色」选项（图四、图五）**：
   - 已有「原版默认」选项，无需再并列提供「原书底色」。

## 二、本轮修复内容

1. **短剧顶部胶囊实时 120Hz 跟手滑动与零延迟点击切换（`native/FanqieXMotion.m`）**：
   - 移除 `paging = YES` 时隐藏选中胶囊的逻辑；新增 `-updatePillForSwipeFromIndex:toIndex:ratio:`，同时由 `HookDramaScrollBetweenTabs` 与 `HookDramaTabsRefreshLeftRight` 双向驱动，在横向滑切 `推荐 / 看剧 / 漫剧`（及自定义可见分类组合）时按 `ratio` 实时无延迟插值 `anchorX` 与胶囊宽度，并同步启用即时交互式清透液态玻璃折射（进入滑动无延迟动画，落定后 `0.12s` 利落收束）。
   - 为 `FQXDramaTopCapsuleInteraction` 新增 `lastSwipeTime` 防重入保护：防止 `JXCategoryBaseView` 在滑过 50% 中点触发 `refreshSelectedCellModel:unselectedCellModel:` 时提前打断跟手滑动，并在 `commitSelectedTabIndex:` 到达时若胶囊已位于目标位置附近则直接无跳动锁定。
   - 收紧点击切换弹簧参数（`0.24s / damping 0.86`），并通过 `pendingTapIndex` / `pendingTapExpiry` 消除松手回弹后再二次跳动的延迟感。
2. **统一「我的」页面快捷按钮水平中轴线并彻底消除与分页圆点重叠（`native/FanqieXMotion.m`）**：
   - 重写 `FQXEnlargeMineShortcutButtonInCell`：彻底移除对外部动态变化的 `card.bounds` 与 `pageControl` 纵坐标的依赖，所有单元格统一以自身 `content.bounds` 垂直中点 `CGRectGetMidY(cb)` 为绝对水平基线，按钮直径限制在安全饱满区间（纯图标最高 `54pt`、图文模式最高 `52pt`，较原版 `39pt` 显著放大且顶部留白充足、底部距分页圆点留有 `10pt+` 安全间距），确保第 1 页与第 2 页所有按钮严格处于同一水平线、永不叠压分页圆点。
   - 按 `AlignedGlass.m` 一致规则匹配 `SSMyUserCollectionViewFunCell` / `SSMyUserCollectionViewOrderFunCell`（优先 `image/label` 并同步 `productImage` 覆盖层）与 `SSMyUser621FunctionEntryItemCell`（优先 `productImage/functionType`）。
   - 将 `FQXMineShortcutViewport` 纵向裁剪余量收紧为对称 `±8pt` 并保留分页圆点上方安全限位。
3. **全局移除「原书底色」选项并兼容旧配置无缝回落（`native/FanqieXSettingsMenu.m`、`native/FanqieXMotion.m`、`native/FanqieXSettingsBackup.m`）**：
   - 从「分享页面材质」（保留：`原版默认 / 液态玻璃 / 模糊玻璃 / 高斯模糊`）与「评论区材质」（保留：`原版默认 / 清透玻璃 / 模糊玻璃 / 高斯模糊`）中删除「原书底色」选项及相关搜索关键词。
   - 删除 `FQXCommentMaterialBookBackground`、`FQXShareMaterialBookBackground`、`FQXSharePaperBackdropKey` 及分享页 Mode 3 渲染分支；同时保留阅读纸张采样以维持小说分享页浅/深色极性自动判断。
   - 保持现有选项枚举值（`0 / 1 / 4 / 2`）不变，且在设置读取、运行时热配置与备份导入中自动将历史保存的旧值 `3` 映射为 `0`（原版默认），避免升级后偏好错乱。

## 三、待真机复测项

- **短剧顶部切换交互**：在 `推荐 <-> 看剧 <-> 漫剧` 之间慢滑、快滑、滑到一半取消回弹以及直接点击切换，确认顶部胶囊零延迟实时跟手、无停顿无闪隐、落位利落。
- **「我的」快捷功能卡片**：在纯图标与图文模式下检查第 1 页与第 2 页，确认所有圆形按钮严格处于同一水平线上、尺寸饱满协调、与底部分页圆点留白清晰不重叠。
- **材质菜单清理**：进入「外观材质 → 分享页面材质」与「评论区设置 → 评论区材质」，确认「原书底色」已彻底移除且其它选项切换与备份导入正常。
