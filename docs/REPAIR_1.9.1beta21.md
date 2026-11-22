# FanqieX 1.9.1beta21 修复说明

1. **清透玻璃 / 模糊玻璃评论区支持 `0%–100%` 实时模糊度调节（图一、图二）**：
   - 在 `FQXCommentGlassSurfaceView.contentView` 底层引入按需加载的纯净 `CABackdropLayer` 高斯模糊层（`commentPureMode = YES`，无灰/白/黑遮罩）。
   - 当「评论区模糊程度」为 `0%` 时，不挂载任何附加模糊视图，保留 100% 系统原生 `UIGlassEffectStyleClear` / `UIGlassEffectStyleRegular` 折射与边缘高光；当设为 `1%–100%` 时，在原生液态玻璃内侧按 1 档步进实时叠加对应高斯模糊半径并同步圆角裁剪，与底栏液态玻璃调级体验一致。
2. **「我的」页面快捷入口彻底固定每页 4 个按钮（图三）**：
   - 定位根因：`UIScrollView` 子视图包含系统滚动指示器（`subviews.count > 1`）以及中间包装层，导致原普通滚动容器识别提前退出；同时快捷按钮 Cell 在自身 `layoutSubviews` 首帧渲染圆形玻璃（`ProfileEntryGlass`）时仍处于原生 `48pt` 宽度（5 列 `86.7pt` 间距）。
   - 递归穿透 `UIScrollView` 包装层并过滤滚动指示器，解包 KVO 动态子类、清零并支持恢复 `estimatedItemSize`、兼容仅图标紧凑高度（`>= 32pt`）、拦截 `applyLayoutAttributes:`，并在快捷 Cell `layoutSubviews` 进入原生玻璃绘制**之前**完成 4 等分槽位重排与 `contentView.frame` 同步，确保首帧即稳定呈现每页 4 个按钮并正确更新分页指示器。
3. **新增「短剧灵动岛」与「听书灵动岛」双通道音频控制（图四、图五）**：
   - 在 `短剧/播放设置` 新增 **短剧灵动岛**（`FanqieX.DramaDynamicIsland.1`，默认关闭），在 `阅读/智能朗读` 新增 **听书灵动岛**（`FanqieX.AudioDynamicIsland.1`，默认关闭），支持配置备份导入导出与设置搜索。
   - **系统灵动岛 / 锁屏控制中心通道**：开启后退出短剧或返回 iOS 桌面时，以音频模式（`AVAudioSessionCategoryPlayback`）保持短剧后台续播并接管 `MPNowPlayingInfoCenter` 与 `MPRemoteCommandCenter`（支持桌面系统灵动岛与控制中心上一集/章、播放/暂停、下一集/章），听书与短剧互斥自动交接。
   - **番茄应用内顶部灵动岛胶囊通道**：离开短剧页或听书页切换到书城、书架、我的、阅读等页面时，顶部贴合摄像头挖孔呈现原生风格灵动岛胶囊（左侧封面、右侧动态音频波形，开启听书灵动岛时自动静音原右下角悬浮球）；点按弹簧展开卡片可执行 **上一集/上一章**、**播放/暂停**、**下一集/下一章**、**返回播放页** 与 **关闭停止**，上滑或点外部收起。
