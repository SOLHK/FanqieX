# FanqieX 1.9.1beta22 修复说明

1. **0% 模糊度评论区纯原生 `UIGlassEffect` 重构（对齐参考视觉质感与通透度）**：
   - 修复「清透玻璃（`UIGlassEffectStyleClear`）」无条件覆写浅/深 `overrideUserInterfaceStyle` 导致在亮/暗视频背景下出现灰白发蒙层的问题：在「跟随软件」模式下为 `Clear` 材质保留 `UIUserInterfaceStyleUnspecified`，由系统按底层实时画面自动适应折射；「模糊玻璃（`UIGlassEffectStyleRegular`）」保留 `Light/Dark` 与零 `tintColor`，确保两种原生玻璃处于真实 0% 额外叠加状态。
   - **按需创建与归零彻底销毁**：当 `FanqieX.CommentBlur.1` 为 `0%` 或禁用额外模糊时，`FQXBackdropBlurView` 与 `FQXSyncCommentSupplementalBlur` 不分配任何 `FQXBackdropHostView`（`CABackdropLayer`）或 `tintOverlay`；从 `>0%` 滑回 `0%` 时立即清空图层滤镜、移除全部 `CABackdropLayer`/遮罩子视图并置空引用。

2. **清理面板、转场遮罩、图层背景与滚动边缘雾化层**：
   - 升级 `FQXClearCommentSurface` 同步保存并清理/恢复 `layer.backgroundColor` 与渐变图层，深度遍历（上限 12 层、`>= 8pt` 覆盖面）清理包裹容器与 `UIScrollView` 包装层，并递归消除 `FQVTransitionView` 的 `bgView`/`backgroundView`/`dimView`/`dimmingView`/`coverView`/`overlayView`/`backdropView` 及残留宿主 `UIVisualEffectView`。
   - 抑制 iOS 26/27 `UIScrollView` 的 `topEdgeEffect`/`bottomEdgeEffect` 与 `ScrollEdgeEffect` 子视图在评论区边缘产生云雾遮挡，并在恢复「默认风格/原书底色」时通过弱引用表完整还原宿主视图与滚动边缘状态。

3. **消除面板与底部发评栏双重玻璃接缝与假灰底**：
   - 识别面板内置底部栏（`FQXEnclosingStyledCommentSheetForBar`）：评论区面板与静止底栏合并为整块连续原生 `SheetGlassKey` 玻璃（`FQXReadHostSheetCornerRadius` 贴合宿主 10–22pt 同心圆角，`configurationWithUniformTopRadius:bottomLeftRadius:bottomRightRadius:(topRad, nil, nil)`），不再截断高度造成 `y≈940` 亮线接缝，也不再将集合视图延伸到底栏文字下方引起头像/文字透底重影。
   - 移除底栏输入框胶囊旧版 `0.06`/`0.12` 灰色模拟底色，在清透/模糊原生玻璃模式下为输入框挂载独立纯净的原生胶囊 `FQXCommentFieldGlassKey`（`disablesSupplementalBlur = YES`），避免与主面板双层叠加模糊；同时在 `FQXClearStaleComposerHost` 统一复用 `FQXReleaseCommentSurface` 防止残留玻璃碎片。
