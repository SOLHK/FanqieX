# FanqieX

番茄小说 7.4.3 液态玻璃与精准广告移除插件修补工程。

## FanqieX 1.78 测试版

新增底栏纯图标、短剧滚动收缩和独立尺寸设置，补齐阅读分享按钮的玻璃适配，并统一阅读与个人页工具控件的图标、文字比例。

设置入口：**FanqieX 设置 → 底栏外观与尺寸**。纯图标和自动收缩默认关闭；可调胶囊长度、高度、按钮宽度及图标大小，支持恢复默认。

- [本版说明、范围与安装方式](docs/REPAIR_1.78.md)
- [构建与验证记录](https://github.com/SOLHK/FanqieX/actions)
- 测试产物由对应提交的 Actions 提供，本分支不会自动发布 Release。

完整验证执行候选 ARM64 指令并检查 Mach-O、签名页、展开表和实际构建来源。最终 iPhone 渲染与注入效果需在设备上确认。

1.78 的可核验源码基线为下方 1.76；已纳入上传 1.77r3 日志能确认的原生视频尺寸处理，无法证实的未公开改动不声称已继承。

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

## 主要修改

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

交付文件来自 Xcode 27.2 构建。真实 UIKit 渲染、GPU 折射、触感和 IPA 注入仍需在 iPhone 上验证。

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
python3 scripts/verify162.py --version 1.76 --output build/ci176
```

macOS / Xcode 27.2 构建：

```bash
DEVELOPER_DIR=/Applications/Xcode_27.2.app/Contents/Developer \
python3 scripts/build_xcode27.py --repair-dir repair162 --version 1.76
```

Windows 工作站可用本地 LLVM Clang 做非 Apple 工具链的等价构建检查：

```powershell
$env:FQ_ASSEMBLER = "clang"
$env:FQ_CLANG = "C:\Program Files\LLVM\bin\clang.exe"
python scripts/verify162.py --version 1.76 --output build/ci176
```

该 Windows 路径不替代 Xcode 27.2 发布构建；它只用于执行同一套 ARM64 指令、结构审计和回归测试。
