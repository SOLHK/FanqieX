# FanqieX 1.9.1beta5 Repair Notes

## Changes

1. **底栏 Dock 交互动画调慢至更接近原生 iOS 节奏 (`native/FanqieXMotion.m`)**
   - 调整 `FQXTabBarInteraction` 弹簧时长（切换 `0.66s–0.72s`、原位 `0.52s`）、Q 弹脉冲（`0.66s`）、图标微弹（`0.58s`）、按压微膨胀（`0.34s`）与底栏呼吸时长（`0.62s`），回弹更柔和从容。

2. **评论区材质改为“液态玻璃 / 高斯模糊”双开关 + 独立浅色/深色外观设置 (`native/FanqieXMotion.m`, `native/FanqieXSettingsMenu.m`, `native/FanqieXCleanup.m`, `native/FanqieXSettingsBackup.m`)**
   - `评论区液态玻璃` 与 `评论区高斯模糊` 改为两个互斥开关（`FanqieX.CommentMaterialStyle.1`），全部关闭时默认保持番茄小说原版评论区，彻底修复设置页旧分段控件标题被裁剪的问题。
   - 新增 `评论区外观`（`FanqieX.CommentAppearanceMode.1`：`跟随软件` / `浅色` / `深色`）：
     - `跟随软件`：自动读取番茄小说应用内夜间/浅色模式（`SSUIColorAdaptedManager` / 窗口外观），夜间自动深色液态玻璃或深色高斯模糊，浅色自动浅色液态玻璃或浅色高斯模糊。
     - `浅色` / `深色`：独立覆盖评论区深浅外观，即使软件开启夜间模式也可强制显示浅色液态玻璃、浅色高斯模糊或浅色原版番茄小说评论区。

3. **统一小说评论区、剧评与短剧评论区透明度与底色 (`native/FanqieXMotion.m`)**
   - 取消小说评论区与短剧评论区的差异透明度，以短剧评论区透明度为基准统一三者底色，并将深色模式底色进一步加深，提升正文背衬下的评论文字清晰度。
