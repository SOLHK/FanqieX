# FanqieX 1.9.1beta18

基于 `test` 分支的 `1.9.1beta17` 修复书架冷启动异常、「我的」快捷入口行数与按钮数、以及 Dock 四档材质和 100 档渐进模糊度。

## 本轮修复内容

### 1. 书架冷启动空态闪现与「筛选」胶囊挤压
- **「筛选」胶囊尺寸与对齐（`AlignedGlass.m`）**：修复 `ShelfDurationLayout` 中当 `fullGenreFilterButton` 为 `nil` 或不在当前行时选中错误邻居的问题；当「编辑」与「筛选」共处同一行时，先对筛选按钮应用横向内边距并按 `sizeThatFits:`（至少 `56pt`）展开胶囊宽度并居中「筛选」文字，随后将「编辑」对齐其左侧，避免「筛选」被挤成小圆圈与「编辑」重叠。
- **冷启动等待与头部同步（`FanqieXCleanup.m`）**：挂钩 `viewWillAppear:` 在首帧绘制前触发冷启动遮罩检查，并在判定加载完成时同步检查书籍分区的实际条目数；将冷启动等待超时从 `0.75s` 放宽到 `2.0s`，并在显示恢复时主动触发布局刷新。

### 2. 「我的」快捷入口每行 4 个按钮
- `FQXMineShortcutGeometry.h` 将单页最大列数上限设为 `4`，4 个圆形快捷按钮均分卡片宽度，其余按钮平滑翻至第 2 页。
- `FanqieXMotion.m` 将布局检测从精确类匹配扩展为 `UICollectionViewFlowLayout` 子类，放宽容器高度阈值至 `144pt`，并通过 `collectionView:layout:insetForSectionAtIndex:` 代理钩子统一归零左右 section inset，避免第 5 个按钮边缘被裁切。

### 3. Dock 4 种材质与 100 档真渐进模糊（交互动画零改动）
- **4 档材质选项（`FanqieXSettingsMenu.m` / `FanqieXSettingsBackup.m` / `FanqieXMotion.m`）**：
  - `新液态玻璃`（0）：最新透明液态玻璃，保持原生胶囊选中样式。
  - `老液态玻璃`（1）：还原 `beta5` 以前版本的液态玻璃底色、选中文案底色（浅色 `black 0.065` / 深色 `white 0.14`）与玻璃质感。
  - `模糊玻璃`（2）：采用更柔和且高于 `beta5` 的磨砂玻璃材质（`UIGlassEffect style = 0` + 磨砂底色）。
  - `高斯模糊`（3）：新增 iOS 18 风格高斯模糊选项，搭配细腻细框与系统材质底色；同步优化弹窗锚点方向避免遮挡状态栏时间。
- **真 100 档渐进模糊（`FQXBlurControl.h` / `FQXBackdropBlurView`）**：
  - 改用硬件 `CABackdropLayer` + `CAFilter(gaussianBlur / colorSaturate)` 连续渲染 1–100 档（步进 `1`），`1%` 仅施加极轻微的 `0.25pt` 模糊与微量底色，不再出现旧版 `UIViewPropertyAnimator` 在 `1%` 直接跳变重度模糊的问题，4 种材质均支持平滑 1–100 档调节。
  - 全程保留底栏原生 `UITabBar` 交互（`interactive = YES`、`FQXDockInteractor` 按压折射、滑动切换与弹簧回弹动画完全未改动）。

## 构建与版本
- 版本号：`1.9.1beta18`（Mach-O 版本字 `0x15112`，扩展页上限维持 `0x64000`）。
- 验证范围：本地 Objective-C 语法与平衡检查、`test_release_capacity178.py`、原生几何/模糊单元检查，以及 GitHub Actions `Xcode 27 plugin build` 与 `Verify FanqieX 1.9.1beta18` 完整工作流。
