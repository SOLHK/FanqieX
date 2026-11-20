# FanqieX 1.9.1beta2 测试版说明

- **版本标识**：`1.9.1beta2`（Mach-O 版本编码 `0x15102`）
- **本轮修复内容**：
  1. **底栏 Dock 交互动画全面顺滑无闪烁、无黑白描边**：底栏保持单层原生 iOS 26/27 `UIGlassEffect` 透明液态玻璃胶囊，内部选中指示器改为持久驻留的无描边柔和胶囊（位于图标下层），彻底消除嵌套 `UIGlassEffect` 造成的深色白边/浅色黑边与拆卸闪烁；点击与滑动手势全程采用 Core Animation 叠加弹簧（`UIViewAnimationOptionBeginFromCurrentState`）在系统渲染进程以 120Hz ProMotion 连续驱动，切换页面不顿挫。
  2. **闪退修复**：修复阅读页与听书悬浮球重排时 `OrigAudioIndicatorSetFrame` 空指针跳转导致的进入正文闪退，并为视图子树遍历补充不可变快照保护。
  3. **书架冷启动闪现空书架与重叠修复**：在 `SSBookShelfViewModel` 完成本地书架加载（`hasLoadBookShelf`）前隐藏冷启动过渡态空书架占位页（含 0.75s 安全兜底恢复），同时修正空态顶栏「编辑」与「筛选」同排避让，不再闪现「书架暂无书籍 / 最近看过 / 编筛选」。
  4. **阅读页听书侧滑返回双悬浮球修复**：在 `BDReaderViewController viewWillDisappear:` 首帧立即收起阅读器内听书悬浮球（手势取消时自动恢复），并在书架 `viewWillAppear:` 同步去重，彻底消除返回过程中的双听书胶囊重叠。
