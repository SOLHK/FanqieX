# FanqieX

番茄小说 7.4.3 液态玻璃与精准广告移除插件修补工程。

## 当前版本：FanqieX 1.7.4（test）

本版以 `test` 的 `3f60ead` 为基线，新增阅读页、书架和个人页的指定入口液态玻璃，
精准移除个人页“羊了个羊：星球”游戏推广卡，并为底栏“短句 / 商城”增加独立开关。

- [修复说明](docs/REPAIR_1.7.4.md)
- [逆向材料核对证据](docs/REVERSE_ARCHIVE_174_EVIDENCE.json)
- [设备观察点](docs/DEVICE_ACCEPTANCE_174.md)
- 交付插件：`dist/1.7.4/FanqieX-1.7.4.dylib`
- 插件包：`dist/1.7.4/FanqieX-1.7.4.zip`
- 校验值：`dist/1.7.4/SHA256SUMS.txt`
- 本地验证：`verification/1.7.4/ci-summary.json`
- 最终候选：Xcode 27.2 构建，SHA-256 `b37381470e3f8d4f391f0a950b39e096e477a4f8966fcc2edb4ba62b9d83b337`
- [GitHub Actions](https://github.com/SOLHK/FanqieX/actions?query=branch%3Atest)

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

## 1.7.4 修改

- 阅读页：本章讨论、礼物、听、章节进度、目录、夜间、设置、改编剧场。
- 书架：全部、阅读、听书、星标四个分类入口。
- 个人页：搜索栏，我的订单、浏览历史、我的消息、创作中心、我的预约。
- 广告：在 `SSMyUser621BaseViewController.setupCellMiniGameEntranceData` 后识别
  `SSMyUserMiniGameEntranceCellModel.info.title/name`，从模型计划中删除
  “羊了个羊：星球”，不隐藏父容器、不留空白 Cell。
- 底栏：`FanqieX.BottomShortSentences.1`、`FanqieX.BottomMall.1` 两个真实开关；
  `SSTabBar` item 数组过滤，关闭后立即移除，重新开启恢复。

玻璃优先使用 `UIGlassEffect` Regular 与 `UICornerConfiguration` capsule；低版本直接
恢复宿主状态。所有 Hook 都是精确类级别，不替换 `UIView layoutSubviews`，材质位于宿主
内容之下且不接收触摸。

## 验证边界

本地验证执行候选的实际 ARM64 指令，UIKit / Foundation / Core Animation 是显式边界模型。
已覆盖材质复用、关闭恢复、重复布局、浅/深色语义、目标广告删除、正常内容保留、底栏开关、
Mach-O 页哈希和 Hook 所有权。

**未在 iPhone 上注入，未执行真实 UIKit 像素渲染、GPU 折射或触感测试。**
本地与模型通过不代表实机验收通过；Xcode 27.2 / iOS 27.2 SDK 的云端结果以 Actions 实际记录为准。

## 安装

先移除旧 FanqieX / FanqieAdBlock 动态库，再注入本包并重新签名。同一 App 只加载一份。
`.dylib` 不是可独立安装的 App。本版只更新 `test`，不修改 `main`。

## 目录

- `repair162/`：当前 ARM64 修补源码、构建器与 Mach-O 工具。
- `audit162/`：候选指令执行、结构审计和明确的 UIKit/Foundation 边界模型。
- `native/`：原生玻璃、诊断源码及其固定汇编组件。
- `scripts/`：构建、验证与打包入口。
- `docs/`：1.7.4 修复说明、逆向证据和设备观察点。
- `dist/`、`verification/`：交付包与验证记录。
- 历史 `repair*`、`audit*`、`baseline/` 保留此前重建和负对照，不覆盖既有成果。

## 复现

Linux 验证：

```bash
python3 scripts/verify162.py --version 1.7.4 --output build/ci174
```

macOS / Xcode 27.2 构建：

```bash
DEVELOPER_DIR=/Applications/Xcode_27.2.app/Contents/Developer \
python3 scripts/build_xcode27.py --repair-dir repair162 --version 1.7.4
```

Windows 工作站可用本地 LLVM Clang 做非 Apple 工具链的等价构建检查：

```powershell
$env:FQ_ASSEMBLER = "clang"
$env:FQ_CLANG = "C:\Program Files\LLVM\bin\clang.exe"
python scripts/verify162.py --version 1.7.4 --output build/ci174
```

该 Windows 路径不替代 Xcode 27.2 发布构建；它只用于执行同一套 ARM64 指令、结构审计和回归测试。
