# FanqieX

番茄小说去广告与液态玻璃插件修补工程。

## 当前状态

**1.5.9 已完成源码修正、ARM64 构建和全部 16 个离线验证步骤；尚未完成 iPhone 实机验收。** 本次处理书架/我的列表没有延伸到悬浮底栏下方，以及阅读页返回箭头没有按可见笔画居中的问题。

- [下载 FanqieAdBlock-1.5.9.dylib](dist/1.5.9/FanqieAdBlock-1.5.9.dylib)
- [下载 ZIP 包](dist/1.5.9/FanqieAdBlock-1.5.9.zip)（同一插件、安装说明、校验值和验证摘要）
- [本次交付记录](docs/handoffs/FANQIEX_159_DELIVERY_20261108.md)
- [验证摘要](verification/1.5.9/ci-summary.json) · [设备验收清单](docs/DEVICE_ACCEPTANCE_159.md)

插件大小：139,792 字节。SHA-256：

```text
e4435d143a22e21991ae753bca5af3f2d945dd6cd6ac3ab514c71d2a5e4d0810
```

使用原有注入与重签名流程替换旧插件，一个宿主进程只加载一份 FanqieAdBlock。交付保存在 `work/159-scroll-mask-arrow-checkpoint-20261108` 分支，不合并到 `main`。

本工程基于固定 SHA-256 的原始插件二进制，提供 ARM64 修补源码、构建脚本和验证模型，不包含宿主 App 或原插件完整源代码。`baseline/` 中历史版本仅用于重建与回归对照，不代表推荐安装版本。

## 复现与验证

在 Python 3 与 LLVM 19 共享库可用的 Linux 环境执行：

```bash
python3 scripts/verify159.py --expect-candidate dist/1.5.9/FanqieAdBlock-1.5.9.dylib
```

此命令重建两次、核对仓库交付字节、独立检查 Mach-O 与签名，并执行旧版本负对照及保留功能回归。完整依赖和验证边界见 [CI_zh-CN.md](docs/CI_zh-CN.md)，技术依据见 [REPAIR_1.5.9.md](docs/REPAIR_1.5.9.md)。GitHub Actions 使用同一命令；仓库保存的报告是本次实际执行的本地离线结果，不冒称云端 CI 结果。

## 目录

- `repair159/`：1.5.9 ARM64 修补源码、构建器与 Mach-O 扩展工具。
- `audit159/`：执行真实候选/旧版机器码的边界模型、负对照和独立结构审计。
- `scripts/verify159.py`：统一构建与验证入口。
- `dist/1.5.9/`：本次插件、ZIP 和 SHA-256 校验值。
- `verification/1.5.9/`：冻结候选的验证报告、源文件清单与命令日志。
- `repair158/`：已交付 1.5.8 修补源码与构建器。
- `audit158/`：1.5.8 离线 ARM64 指令与 UIKit 边界模型。
- `baseline/`：固定哈希的历史插件。
- `docs/`：修复依据、诊断说明、交接历史与设备验收清单。

离线模型不执行真实 UIKit、CoreImage/GPU、dyld 或设备注入，不等同于 iPhone 实测通过。底栏实际合成、返回按钮实机观感、点击响应、滚动帧率和宿主全部动态布局时序仍未由本环境验证。不能仅据这些报告宣布手机上的两项现象已经消失。
