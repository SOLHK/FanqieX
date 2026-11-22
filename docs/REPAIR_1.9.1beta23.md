# FanqieX 1.9.1beta23 修复说明

## 一、与 DYKiller 的底层 API 接入对比与差异排查

两个项目底层调用的**是同一套 Apple iOS 26+ 原生 `UIGlassEffect` 公开 API**（`UIGlassEffectStyleRegular = 0`、`UIGlassEffectStyleClear = 1`、`interactive = YES`、`tintColor` 与 `UIVisualEffectView.cornerConfiguration`），此前 FanqieX 的「模糊玻璃（`Regular`）」与 DYKiller 视觉差异源于以下 5 处实现差异：

1. **顶部圆角接入方式差异**：此前 `FQXApplyCommentCornerConfig` 在无圆角宿主视图上直接调用 `[UICornerRadius containerConcentricRadiusWithMinimum:]`，会向上穿透到屏幕硬件 bezel ~48–55pt 圆角导致边角大块弧形拉伸；现改为仅当宿主开启 `clipsToBounds` 且具有 `[8, 22]` 圆角时才使用 `containerConcentricRadiusWithMinimum:`，否则采用 `[UICornerRadius fixedRadius:]`（14–16pt）并配合 `(topRad, nil, nil)`，同时调整 `FQXReadHostSheetCornerRadius` 到 `8–20pt`（默认 `14pt`）。
2. **宿主 `overrideUserInterfaceStyle` 覆写与文字重绘干扰**：`Regular` 材质的自适应对比度依赖系统原生 trait 传递；此前无条件在 `sheet` / `toolbar` / `cell` / `footer` 上写入显式 `Light/Dark` 覆写，并通过 `FQXBoostCommentTypography` 重绘标题、副文本灰色和图片 tint。现对齐 DYKiller：仅在显式开启「深/浅色固定外观」时才覆写宿主（`FQXDesiredCommentHostOverrideStyle`），在「模糊玻璃（`Regular`）+ 跟随软件」下保留系统原字色、`UIUserInterfaceStyleUnspecified` 与原图色阶，并优先从 `UIWindowScene.traitCollection` 获取系统深浅色。
3. **玻璃外壳属性污染与零尺寸早熟渲染**：此前对 `FQXCommentGlassSurfaceView` 强行写入 `shadowOpacity = 0` / `backgroundColor = clearColor` / `opaque = NO`，并在 `bounds` 尚为 `0` 时提前写入 `effect` 或因多次布局并发触发重复 materialize 动画；现还原原生空白外壳，`[CATransaction begin]/[setDisableActions:YES]` 同步就位几何与圆角，增加 `>= 1pt` 尺寸门槛与 `isMaterializing` 防抖，且转场动画仅在 `tc.isAnimated` 时并行执行（含 `0.25s` 兜底）。
4. **`FQVTransitionView` 暗幕遮罩穿透清理**：扩充 `FQXCleanTransitionBackdrop` 清理范围（含 `transition` 本身、`maskBgView` 及无标题/图标的暗色 `UIControl`/`UIButton` 幕布），在短剧 `FQVTransitionView.layoutSubviews` 及 `showInView:animated:completion:` 的 `+0.06s` / `+0.36s` 时序同步二次清理，消除玻璃背后的暗沉底幕。
5. **输入框胶囊、独立底栏与材质细节对齐**：输入框胶囊 `FQXCommentFieldGlassKey` 跟随 `bgView.layer.cornerRadius > 0` 采用 `fixedRadius:`（无圆角时才退回 `capsuleConfiguration`），弹出编辑器圆角上限收敛至 `16pt`（悬浮卡片 `24pt`），且仅 `isBarGlass` 触发父级面板让位重算避免主面板玻璃自循环重算；`_flexInteractionGestureView` 仅在源视图仍在窗口内时重定向触摸，分离前释放。
