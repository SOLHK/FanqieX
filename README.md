# FanqieX

番茄小说去广告与液态玻璃插件修补工程。

## 当前交付：1.6.0

**1.6.0 已通过冻结源码下的全部17个离线验证步骤；设备验收仍未完成。**
交付分支为 `test`。该分支每次推送同时执行 Linux 完整回归与真实 Xcode 27.2 构建，
两边都必须与仓库中的交付插件逐字节一致。具体提交的云端状态以
[GitHub Actions](https://github.com/SOLHK/FanqieX/actions?query=branch%3Atest) 为准。

- [下载 FanqieAdBlock-1.6.0.dylib](dist/1.6.0/FanqieAdBlock-1.6.0.dylib)
- [下载 ZIP 包](dist/1.6.0/FanqieAdBlock-1.6.0.zip)（同一插件、安装说明和验证摘要）
- [SHA-256 校验值](dist/1.6.0/SHA256SUMS.txt)
- [修复依据与边界](docs/REPAIR_1.6.0.md) · [去标识的现场证据](docs/1.6.0-observed-evidence.json)
- [验证摘要](verification/1.6.0/ci-summary.json) · [设备验收清单](docs/DEVICE_ACCEPTANCE_160.md)

插件大小：139,792 字节。SHA-256：

```text
2da6826d63d5e05ec6c2f20d3375d58186474490c9c92dc09c2cc734529560b1
```

使用原有 IPA 注入与重签名流程替换旧插件，一个宿主进程只加载一份 FanqieAdBlock。
`.dylib` 不能直接点击当作独立 iOS 应用安装。

## 本次修改

| 反馈 | 本次代码处理 |
| --- | --- |
| 首次点击、切换或重新打开时底部短暂遮罩 | 空列表也提前建立观察；日志中的书城迟建视图在布局/挂窗时同步处理滚动边缘；去掉空 effect 过渡和隐藏后反复重建 |
| 阅读返回箭头仍偏左 | 真机 `reason18` 表明旧位图校准失败；改用系统 `chevron.backward`，并处理 UIButton 高亮等普通状态及条件恢复 |
| 底部玻璃紧贴图标和文字 | 按完整“图标＋标题”计算留白，覆盖嵌套图标控件，材料限制在实际可点击 bounds 内 |
| 改编剧场和听风格不统一 | 扩展精确阅读控件作用域，使用同一系统玻璃入口；听的动态文字颜色、原背景与复用恢复一起处理 |
| 右上更多延迟 | 四个阅读栏/菜单/底部尾调用统一为有界处理，补菜单挂窗和被动触摸诊断；旧日志不足以证明1–2秒等待的唯一原因 |

新阅读回归38组、首帧回归39项及26项独立故障注入均已通过，并保留主底栏、去广告相关
原始代码、诊断入口、最近一小时历史和恢复逻辑的回归。各报告说明自身执行范围。
没有把 ARM64 边界模型或编译成功当作手机渲染、真实菜单延迟和注入验收。

## 复现

Linux：Python 3 与 LLVM 19 共享库可用时，选择一个全新的输出目录：

```bash
python3 scripts/verify160.py --output build/verify160-fresh --expect-candidate dist/1.6.0/FanqieAdBlock-1.6.0.dylib
```

macOS：选择正式 Xcode 27.2 后，执行真实 Apple 工具链构建：

```bash
DEVELOPER_DIR=/Applications/Xcode_27.2.app/Contents/Developer python3 scripts/build_xcode27.py --repair-dir repair160 --expect-candidate dist/1.6.0/FanqieAdBlock-1.6.0.dylib
```

Xcode 脚本硬性检查 Xcode 27.2 / iOS 27.2 SDK，用 `xcrun clang` 汇编实际插件两次，
核对产物与上述插件字节一致，并用当前 SDK 类型检查公开 UIKit API。
`native/PublicGlassAPI.m` 是接口契约检查，不是宿主运行测试。

本工程基于固定 SHA-256 的原始插件二进制，提供可重建的 ARM64 修补源码、构建脚本和
验证模型，不包含宿主 App 或原插件完整源代码。不会把固定二进制修补冒充完整 App 重编译。

## 目录

- `repair160/`：1.6.0 修补源码、构建器与 Mach-O 工具。
- `audit160/`：独立结构审计、真实机器码执行及 UIKit/Foundation 边界模型；发布入口为 `scripts/verify160.py`。
- `native/`：使用 iOS 27.2 SDK 检查的公开 API 契约。
- `scripts/`：Linux 验证、Xcode 构建与冻结候选打包入口。
- `dist/1.6.0/`：当前插件、ZIP、摘要与校验值。
- `verification/1.6.0/`：本次实际本地结果、冻结源文件清单和命令日志；云端结果保存在对应 Actions 运行中。
- `repair158/`、`repair159/`、历史 `audit*` 与 `baseline/`：历史重建和回归对照，非当前推荐安装版本。
- `docs/`：修复依据、诊断说明和设备验收清单。
