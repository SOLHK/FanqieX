# FanqieX

番茄小说去广告与液态玻璃插件修补工程。

## 当前交付：1.6.1

**1.6.1 已通过冻结源码下的全部 21 个离线发布验证步骤；设备验收仍未完成。**
交付分支为 `test`。该分支每次推送同时执行 Linux 完整回归与真实 Xcode 27.2 构建，
两边都必须与仓库中的交付插件逐字节一致。具体提交的云端状态以
[GitHub Actions](https://github.com/SOLHK/FanqieX/actions?query=branch%3Atest) 为准。

- [下载 FanqieAdBlock-1.6.1.dylib](dist/1.6.1/FanqieAdBlock-1.6.1.dylib)
- [下载 ZIP 包](dist/1.6.1/FanqieAdBlock-1.6.1.zip)（同一插件、安装说明和验证摘要）
- [SHA-256 校验值](dist/1.6.1/SHA256SUMS.txt)
- [修复依据与边界](docs/REPAIR_1.6.1.md) · [去标识的现场证据](docs/1.6.1-observed-evidence.json)
- [验证摘要](verification/1.6.1/ci-summary.json) · [设备观察点](docs/DEVICE_ACCEPTANCE_161.md)

插件大小：156,304 字节。SHA-256：

```text
8c8aedc3643c52efa1180119a983c8cd22006123ea095db617ea901be0fbcf8e
```

使用原有 IPA 注入与重签名流程替换旧插件，一个宿主进程只加载一份 FanqieAdBlock。
`.dylib` 不能直接点击当作独立 iOS 应用安装。

## 本次修改

| 反馈 | 本次代码处理 |
| --- | --- |
| 阅读页顶部玻璃按钮太小，要求恢复原样 | 返回、下载、评论、搜索、更多退出插件的玻璃与图标改造，恢复由宿主管理原图、尺寸和布局 |
| 主底栏过透，背景影响读字 | 主路径改用一个公开的系统 `UISegmentedControl`，由系统统一管理底色与选中状态；兼容回退采用单 Regular 玻璃和普通选中底色 |
| 底栏滑动缺少系统玻璃交互 | 主路径移除旧自定义 pan 和镜片，使用原生控件的触摸与选择行为；周期维护尊重 `isTracking`，不抢写拖动预览 |
| 从未选中项开始滑动可能切错页 | 用已发布 1.6.0 指令复现旧偏移错误，修正兼容路径的起拖位置；原生和兼容路径都走原宿主选页入口 |

阅读顶栏恢复 29 组、原生桥接 10 组、完整原生编排 5 组，以及独立故障注入 27 项均已通过。
完整编排执行实际 Lrepair、周期监控、原始选页和退出清理，覆盖淡入时兼容切换、重复事件、
宿主拒绝或重定向选择、target 生命周期和寄存器保护。保留首帧、信息流、诊断与最近一小时
导出的回归；原去广告代码和宿主 UUID 检查由独立二进制范围审计保护。

**尚未在用户 iPhone 上验证最终可读性、GPU 折射、触感和注入。** 宿主 SDK 与兼容模式
可能影响系统控件外观；插件不会伪造宿主 SDK 或全局设计模式。兼容回退的普通选中底色
不提供独立光学折射。不能将离线机器码测试或 Xcode 编译等同于 App Store 外观的真机验收。

## 复现

Linux：Python 3 与 LLVM 19 共享库可用时，选择一个全新的输出目录：

```bash
python3 scripts/verify161.py --output build/verify161-fresh --expect-candidate dist/1.6.1/FanqieAdBlock-1.6.1.dylib
```

macOS：选择正式 Xcode 27.2 后，执行真实 Apple 工具链构建：

```bash
DEVELOPER_DIR=/Applications/Xcode_27.2.app/Contents/Developer python3 scripts/build_xcode27.py --repair-dir repair161 --expect-candidate dist/1.6.1/FanqieAdBlock-1.6.1.dylib
```

Xcode 脚本硬性检查 Xcode 27.2 / iOS 27.2 SDK，用 `xcrun clang` 汇编实际插件两次，
核对产物与上述插件字节一致，并用当前 SDK 类型检查公开 UIKit API。
`native/PublicGlassAPI.m` 是接口契约检查，不是宿主运行测试。

本工程基于固定 SHA-256 的原始插件二进制，提供可重建的 ARM64 修补源码、构建脚本和
验证模型，不包含宿主 App 或原插件完整源代码。不会把固定二进制修补冒充完整 App 重编译。

## 目录

- `repair161/`：1.6.1 修补源码、构建器与 Mach-O 工具。
- `audit161/`：独立结构审计、真实机器码执行及 UIKit/Foundation 边界模型；发布入口为 `scripts/verify161.py`。
- `native/`：使用 iOS 27.2 SDK 检查的公开 API 契约。
- `scripts/`：Linux 验证、Xcode 构建与冻结候选打包入口。
- `dist/1.6.1/`：当前插件、ZIP、摘要与校验值。
- `verification/1.6.1/`：本次实际本地结果、冻结源文件清单和命令日志；云端结果保存在对应 Actions 运行中。
- `repair158/`、`repair159/`、`repair160/`、历史 `audit*` 与 `baseline/`：历史重建和回归对照。
- `docs/`：修复依据、诊断说明和设备验收清单。
