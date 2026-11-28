# FanqieX

番茄小说 7.4.3 液态玻璃与精准广告移除插件修补工程。

## FanqieX 2.0.1

将「Dock 选中色」与「短剧顶部按钮选中色」完全独立拆分并修复 iOS 27 深色底栏选中胶囊显示；移除短剧右侧点赞、收藏、评论、分享四个互动按钮的圆形玻璃遮罩；并将短剧顶部与按钮底色、选中色、大小、模糊度与播放选项材质统一集中至「短剧」一级设置页面。

- [安装与更新说明](docs/REPAIR_2.0.1.md)
- [2.0.1 真机验收](TESTING.md#201-真机验收)

## FanqieX 2.0.1beta12

修复听书主界面被误叠加第二层玻璃的问题，仅对听书各按钮的二级半屏弹窗（语速、已加书架、选择章节/下载、章评、更多、简介/播放目录、定时关闭、音色设置）应用液态玻璃/模糊玻璃；将「视频同款粉雾」改名为「柔性粉雾」；并在顶部按钮与 Dock 栏新增可选「粉雾玻璃」（带透明粉雾底色与同色系粉雾渐变选中的真实液态玻璃）。

- [安装与更新说明](docs/REPAIR_2.0.1beta12.md)
- [2.0.1beta12 真机验收](TESTING.md#201beta12-真机验收)

## FanqieX 2.0.1beta11

听书页右上角与「更多」半屏弹窗新增独立可调节的「听书更多面板模糊程度」（0%–100%）；为 TikTok 与 Siri AI 交互引入三阶 $C^2$ 流体弹簧释放模型，优化轻提/轻拉放手动画的顺滑与优雅质感；并将 TikTok 与 Siri AI 动态收缩底栏扩展至书城、书架、我的与短剧四大主页面。

- [安装与更新说明](docs/REPAIR_2.0.1beta11.md)
- [2.0.1beta11 真机验收](TESTING.md#201beta11-真机验收)

## FanqieX 2.0.1beta9

对照慢动作视频优化 TikTok 交互与 Siri AI 交互：文字在原下方位置就地缩放淡出，消除收缩/展开过程中文字与图标重叠，并补齐近端点松手的自适应弹性回弹与贴底比例。

- [安装与更新说明](docs/REPAIR_2.0.1beta9.md)
- [2.0.1beta9 真机验收](TESTING.md#201beta9-真机验收)

## FanqieX 2.0.1beta8

优化「动态收缩底栏」的 TikTok 交互与 Siri AI 交互动画，使胶囊、图标、文字与右侧独立圆形模块在滑动、快滑惯性与回弹中全程同步缩放。

- [安装与更新说明](docs/REPAIR_2.0.1beta8.md)
- [2.0.1beta8 真机验收](TESTING.md#201beta8-真机验收)

## FanqieX 2.0.1beta7

「页面与导航 → 底栏入口」新增「动态收缩底栏」（关闭、原有收缩模式、TikTok 交互、Siri AI 交互）与仅在 Siri AI 模式下显示的「Siri AI 收缩后隐藏短线」，接入右侧独立圆形模块的同步缩放、聚拢与收缩态点击穿透。

- [安装与更新说明](docs/REPAIR_2.0.1beta7.md)
- [2.0.1beta7 真机验收](TESTING.md#201beta7-真机验收)

## FanqieX 2.0.1beta6

调整多图标 Dock 在小幅拖动、松手和快速翻页时的动画衔接。

- [安装与更新说明](docs/REPAIR_2.0.1beta6.md)
- [2.0.1beta6 真机验收](TESTING.md#201beta6-真机验收)

## FanqieX 2.0.1beta5

开启「刷视频时自动缩放 Dock」后，底栏大小跟随拖动距离。手指停住时可以停在中间尺寸，反向拖动时会跟着变回去，松手后补完剩余动画。短剧右侧的点赞、评论、收藏和分享按钮去掉了玻璃底。

- [安装与更新说明](docs/REPAIR_2.0.1beta5.md)
- [2.0.1beta5 真机验收](TESTING.md#201beta5-真机验收)

## FanqieX 2.0.1beta4

「短剧滚动自动收缩」恢复为单个圆形按钮。要使用多个图标一起缩放的交互，请在「页面与导航 → 底栏入口」开启「刷视频时自动缩放 Dock」。两种模式分别设置，开启一种会关闭另一种。

- [安装与更新说明](docs/REPAIR_2.0.1beta4.md)
- [2.0.1beta4 真机验收](TESTING.md#201beta4-真机验收)

## FanqieX 2.0.1beta3

开启「短剧滚动自动收缩」后，继续刷下一条视频时 Dock 会缩小。往回看上一条，或在当前视频轻轻上提后松手，Dock 会展开。

- [安装与更新说明](docs/REPAIR_2.0.1beta3.md)
- [2.0.1beta3 真机验收](TESTING.md#201beta3-真机验收)

## FanqieX 2.0.1beta2

修复短剧顶部点按和书架历史首次打开空白。短剧设置新增标题入口开关，版本弹窗可继续打开历代更新。

- [安装与更新说明](docs/REPAIR_2.0.1beta2.md)
- [2.0.1beta2 真机验收](TESTING.md#201beta2-真机验收)

## FanqieX 2.0.1beta1

短剧的合集入口和进度条随 Dock 宽度更新。底栏切页保留宿主原来的选择动作，并将切页与玻璃布局刷新错开。顶部分类的选中效果跟随实际落页。「短剧 → 页面内容」新增隐藏「全屏观看」按钮的开关，打开后原位置仍可点按进入全屏。备份导入现在会核验插件设置已写入。

- [2.0.1beta1 真机验收](TESTING.md#201beta1-真机验收)

## FanqieX 2.0

本版修复 1.9.8beta2 在启动时处理设置通知引起的卡死，并在「书架净化 → 推荐与导入」增加「隐藏小说改编剧推荐卡」开关。插件文件为 `FanqieX-2.0.dylib`，设置首页和诊断日志显示 `2.0`，Mach-O 构建标识为 `0x20000`。

- [2.0 安装和启动验收](docs/REPAIR_2.0.md)
- [1.9.8beta2 历史更新](docs/REPAIR_1.9.8beta2.md)
- [测试版本与分支规范](TESTING.md)

## FanqieX 1.76

本版修复短剧悬浮底栏的遮罩、视频透出和全集入口重叠，并让底栏按当前页面的明暗自动适配玻璃与文字颜色。
横屏播放保留原始画面比例，使用原生动态背景填充剩余区域；阅读页深色背景与应用外部主题独立。
插件会检查宿主的类和方法签名，再逐项启用匹配的功能。

- [修复说明和设备观察点](docs/REPAIR_1.76.md)
- [逆向材料核对证据](docs/REVERSE_ARCHIVE_174_EVIDENCE.json)
- [插件](https://github.com/SOLHK/FanqieX/releases/download/v1.76/FanqieX-1.76.dylib)
- [插件包](https://github.com/SOLHK/FanqieX/releases/download/v1.76/FanqieX-1.76.zip)
- [SHA-256 校验值](https://github.com/SOLHK/FanqieX/releases/download/v1.76/SHA256SUMS.txt)
- [验证记录](https://github.com/SOLHK/FanqieX/releases/download/v1.76/VERIFICATION.json)
- [GitHub Release](https://github.com/SOLHK/FanqieX/releases/tag/v1.76)
- [GitHub Actions](https://github.com/SOLHK/FanqieX/actions)

宿主身份已按本次上传的 IPA 逆向 ZIP 重新核对：

| 项目 | 值 |
| --- | --- |
| Bundle ID | `com.dragon.read` |
| CFBundleVersion | `7.4.3.33` |
| CFBundleShortVersionString | `7.4.3` |
| 架构 / UUID | arm64 / `BEE37D93-3E70-332F-98F1-20890F02BB12` |
| 最低系统 | iOS 15.0.1 |
| 宿主构建 SDK | iOS 26.0 |

ZIP 中没有传统 class-dump、方法体或 ARM64 反汇编清单；它提供 97,348 个重建 Header、
Mach-O 元数据、Info.plist、Frameworks 和 Swift 元数据列表。缺失项已明确记录在修复说明中。

## 1.76 历史修改

- 短剧视频延伸到底栏后方，底栏保持单层悬浮玻璃；全集、合集入口与底栏分别布局。
- 底栏根据当前页面的背景色自动切换深浅材质、文字及选中态，切回浅色页面时同步恢复。
- 全屏播放保持视频原始宽高比，连续切换视频时重新应用设置，剩余屏幕使用原生动态背景。
- 书架筛选开关控制实际入口显示；阅读页的黑色背景与玻璃控件采用局部深色外观，应用主题遵从设置。
- 阅读页的章末讨论与作者说共用整张玻璃卡片，新书的「听书」与「左滑开始阅读」入口采用玻璃样式。
- 书城、书架和「我的」使用同一套顶部模糊材质，滚动时可透出后方封面。书城刷新后恢复列表位置，书架编辑按钮随今日看听读时长的显示状态切换位置。
- 书城与「我的」右下角写作按钮采用液态玻璃。「我的」将顶部模糊限制在工具栏内。
- 广告过滤覆盖书城传统弹窗、IMC 入口及缓存和个人页游戏推广卡。
- 「短句」和「商城」可以在插件设置中独立开启或关闭。

玻璃优先使用 `UIGlassEffect` Regular 与 `UICornerConfiguration` capsule；低版本直接
恢复宿主状态。所有 Hook 都是精确类级别，不替换 `UIView layoutSubviews`，材质位于宿主
内容之下且不接收触摸。

## 验证边界

本地验证执行候选的实际 ARM64 指令，UIKit / Foundation / Core Animation 是显式边界模型。
已覆盖材质复用、关闭恢复、重复布局、浅/深色语义、目标广告删除、正常内容保留、底栏开关、
Mach-O 页哈希和 Hook 所有权。

历史 1.76 交付来自 Xcode 27.2。真实 UIKit 渲染、GPU 折射、触感和 IPA 注入仍需在 iPhone 上验证。

## 安装

先移除旧 FanqieX / FanqieAdBlock 动态库，再注入本包并重新签名。同一 App 只加载一份。
`.dylib` 需要注入宿主后使用。

## 目录

- `repair162/`：当前 ARM64 修补源码、构建器与 Mach-O 工具。
- `audit162/`：候选指令执行、结构审计和明确的 UIKit/Foundation 边界模型。
- `native/`：原生玻璃、诊断源码及其固定汇编组件。
- `scripts/`：构建、验证与打包入口。
- `docs/` 保存修复说明、逆向证据和设备观察点。
- `dist/`、`verification/`：交付包与验证记录。
- 历史 `repair*`、`audit*`、`baseline/` 保留此前重建和负对照，不覆盖既有成果。

## 复现

Linux 验证：

```bash
python3 scripts/verify162.py --version 1.78R35 --output build/ci178r35
```

macOS / Xcode 27.2 构建：

```bash
DEVELOPER_DIR=/Applications/Xcode_27.2.app/Contents/Developer \
python3 scripts/build_xcode27.py --repair-dir repair162 --version 1.78R25
DEVELOPER_DIR=/Applications/Xcode_27.2.app/Contents/Developer \
python3 scripts/build_book_export.py --core build/xcode27/FanqieX-1.78R25.dylib --output build/xcode27/integrated
```

Windows 工作站可用本地 LLVM Clang 做非 Apple 工具链的等价构建检查：

```powershell
$env:FQ_ASSEMBLER = "clang"
$env:FQ_CLANG = "C:\Program Files\LLVM\bin\clang.exe"
python scripts/verify162.py --version 1.78R25 --output build/ci178r25
```

该 Windows 路径不替代 Xcode 27.2 发布构建；它只用于执行同一套 ARM64 指令、结构审计和回归测试。
