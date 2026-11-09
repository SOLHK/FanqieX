# FanqieX

番茄小说去广告与液态玻璃插件修补工程。

## FanqieX 1.6.5 本地测试候选

书城搜索框和分类入口接入原生液态玻璃，补充同宿主版本不同 UUID 的识别路径。
iOS 26+ 按 API 能力启用；尚待用户真机验收，未推送 `test`。
范围、安装步骤和限制见 [1.6.5 测试说明](docs/REPAIR_1.6.5.md)。

## FanqieX 1.6.4 候选

增加冷启动首页非标广告规则、评论生命周期与网络/模型诊断，并将底栏左右留白按 Safe Area 对称校准。
设置页可主动开启增强诊断并导出最近一小时 JSON。
源码、事件覆盖与设备验收范围见 [1.6.4 修复记录](docs/REPAIR_1.6.4.md)。
候选及完整验证结果见 [dist/1.6.4](dist/1.6.4) 和 [verification/1.6.4](verification/1.6.4)。

## FanqieX 1.6.3 段评保护修复

1.6.3 在旧广告及玻璃 Hook 安装入口隔离继承方法，避免改写父类实现而波及共享该实现的段评组件。
定位依据、复现命令与真机验收步骤见 [1.6.3 修复记录](docs/REPAIR_1.6.3.md)。
候选插件见 [FanqieX-1.6.3.dylib](dist/1.6.3/FanqieX-1.6.3.dylib) 和 [SHA-256](dist/1.6.3/SHA256SUMS.txt)。

## 当前交付：FanqieX 1.6.2

**1.6.2 已通过冻结源码下全部 23 项本地发布验证，两次重建的插件逐字节一致。**
交付分支为 `test`；同一提交的云端完整回归与真实 Xcode 27.2 / iOS 27.2 SDK
构建结果见 [GitHub Actions](https://github.com/SOLHK/FanqieX/actions?query=branch%3Atest)。
设备视觉验收尚未完成。

- [下载 FanqieX-1.6.2.zip](dist/1.6.2/FanqieX-1.6.2.zip)（插件、安装说明和验证摘要）
- [下载 FanqieX-1.6.2.dylib](dist/1.6.2/FanqieX-1.6.2.dylib)
- [SHA-256 校验值](dist/1.6.2/SHA256SUMS.txt)
- [代码依据与边界](docs/REPAIR_1.6.2.md) · [去标识现场证据](docs/1.6.2-observed-evidence.json)
- [23 项验证摘要](verification/1.6.2/ci-summary.json) · [设备观察点](docs/DEVICE_ACCEPTANCE_162.md)

插件大小：156,304 字节。SHA-256：

```text
8784d9d4a065d2bff4dc9f602e503a80bc41c877937d02ebb019e1dbfb0a9a01
```

使用原有 IPA 注入和重签名流程替换旧插件。**先移除旧版，再注入本版本，
同一宿主只加载一份插件。** 新文件统一使用 FanqieX 名称，历史交付文件名保持不变。
`.dylib` 不能作为独立 iOS 应用直接安装。

## 本次修改

| 反馈 | 代码处理 |
| --- | --- |
| 底栏几乎全透明 | 删除原生选择器安装后清空玻璃的分支，保留一层 Regular 磨砂底座 |
| 选中项纯白 | 使用动态语义灰色选中底，原生选择器放入玻璃内容容器 |
| 文字与交互 | 保留原按钮文字与内容，统一由原生控件处理点击、拖动和选择语义；退出时恢复原状态 |
| 书架时长、编辑、筛选闪矩形 | 未挂入页面前完成最终尺寸和原生胶囊形状；背景清理、插入与更新放在同一禁用隐式动画事务中 |
| 名称和版本 | 交付文件、内部安装标识、签名标识、设置页统一 FanqieX；版本、运行和导出诊断统一 1.6.2 |

保留 1.6.1 的阅读顶部原始控件。旧设置键和诊断持久目录继续兼容，保存已有用户设置
与近期日志。实际旧基线的底栏为文字按钮；本版保留已有内容，不声称已补回宿主图标。

## 验证

新增书架首帧检查 11 组（20 个具体场景），覆盖四个真实布局入口、冷启动与阅读返回、
环境动画、同步重入、零尺寸、材质复用与失败回滚。固定 1.6.1 负对照复现旧发布顺序。
底栏原生选择 10 组、完整编排 5 组、本轮可读性负对照 4 组，以及保留阅读控件 29 组均通过。
另保留独立 Mach-O 审计、27 项故障注入、信息流覆盖、诊断及最近一小时导出回归。

**尚未在用户 iPhone 上验证最终材质浓度、GPU 折射、闪动时长、触感和注入。**
离线测试执行真实 ARM64 指令，UIKit / Foundation / Core Animation 边界采用显式模型。
Xcode 构建检查实际插件与公开 API 类型，不运行宿主 App，不能替代设备视觉验收。
本次修复未新增全局设计模式覆盖；宿主 SDK、系统与既有外观设置仍可能影响原生控件外观。

## 复现

Linux（Python 3 与 LLVM 19 共享库）：

```bash
python3 scripts/verify162.py --output build/verify162-fresh \
  --expect-candidate dist/1.6.2/FanqieX-1.6.2.dylib
```

macOS（真实 Xcode 27.2 / iOS 27.2 SDK）：

```bash
DEVELOPER_DIR=/Applications/Xcode_27.2.app/Contents/Developer \
python3 scripts/build_xcode27.py --repair-dir repair162 \
  --expect-candidate dist/1.6.2/FanqieX-1.6.2.dylib
```

两种构建都重建两次并比对交付插件的字节；源码冻结清单可检测验证期间的修改。
本工程基于固定 SHA-256 的原始二进制提供可重建的 ARM64 修补源码，不包含
宿主 App 或原插件完整源码，不将二进制修补称为宿主 App 完整重编译。

## 目录

- `repair162/`：当前 ARM64 修补源码、构建器与 Mach-O 工具。
- `audit162/`：二进制审计、实际指令执行与明确的 UIKit / Foundation 边界模型。
- `native/`：公开 UIKit / Core Animation API 契约。
- `scripts/`：Linux 验证、Xcode 构建与冻结候选打包入口。
- `dist/1.6.2/`：交付 ZIP、插件、摘要与校验值。
- `verification/1.6.2/`：本地实际验证结果、冻结清单与命令日志。
- 历史 `repair*`、`audit*`、`dist/`、`verification/`、`baseline/`：此前重建、交付与负对照。
- `docs/`：修复依据与设备观察点。
