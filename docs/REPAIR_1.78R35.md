# FanqieX 1.78R35 测试版

适用番茄小说 7.4.3（7.4.3.33）。替换旧插件后重新注入并签名，同一宿主只保留一份 FanqieX。

R34 已统一材质类型，但顶部仍通过外围 `contentView.backgroundColor` 判断明暗。宿主的视频模型可以给这个容器使用浅色 `SS_COLOR_BG_F6`，底栏则针对视频分类单独返回 `#222222`。因此同样的 Regular 玻璃仍可能显示为一浅一深。

R35 顶部改用底栏相同的 `bottomTabBackgroundColorWithTabModel:`，通过 `rootTabBarController` 调用，并传入当前原生已选标题对应的模型，避免受滞后的分类缓存影响。保留 R34 的 Regular 材质与详情标题间距。

## 源码与证据

- 修改限于 `native/AlignedGlass.m` 的顶部颜色来源、对应生成汇编、回归验证及版本标识。
- 宿主 `updateContentBackgroundColorWithTabModel:`（`0x10fc9804c`）给 contentView 设置通用／模型背景；`FQFeedTabPageModel` 与 `FQFeedCategoryTabModel` 的背景实现都使用 `SS_COLOR_BG_F6`。
- 底栏颜色解析（`0x10a3c56ec`）及注册分类解析（`0x10f422678`）另有视频分类分支，使用 `#222222`。
- 新日志确认 R34 底栏 style=2、Regular 玻璃与透明底色；日志未记录顶部完整视图树，顶部原因由上述宿主调用链和截图共同定位。

## 验证与设备观察

包内 `VERIFICATION.json` 记录本地编译、相关 ARM64 测试、启动及二进制完整性检查。新增对照覆盖“浅色容器、深色视频”的配色差异；旧 R34 可复现顶部错误的浅色样式。

实际 UIKit 渲染与触摸尚未在 iPhone 验证。本地包的验证记录不包含远端 CI 结果，推送后的 CI 状态以 GitHub Actions 为准。

请重点查看推荐／漫剧播放时顶部与底栏的明暗是否一致，再切换分类并返回，确认选中胶囊和搜索入口正常。
