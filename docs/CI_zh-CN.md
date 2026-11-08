# 1.5.9 的可复现构建与验证

在仓库根目录运行：

```sh
python3 scripts/verify159.py
```

此命令会从固定 SHA256 的 1.5.6 基础镜像重建修补内容，并与用户提供的
1.5.8 原件核对保留区域。它执行两次完整构建，要求生成的 dylib 逐字节相同，
然后对这一份输出运行结构、签名和 ARM64 回归检查。结果在 `build/ci159/`。

若需核对已交付的插件，也可以传入其路径：

```sh
python3 scripts/verify159.py --expect-candidate dist/1.5.9/FanqieAdBlock-1.5.9.dylib
```

命令不会自动上传文件、创建 Release 或执行输入 dylib。GitHub 工作流只有读取
仓库的权限；验证报告始终作为 Actions 附件保存，插件只在全部步骤成功后保存。
工作流还强制要求重建结果与 `dist/1.5.9/` 中已交付的 dylib 逐字节相同。

## 环境

构建目标是 ARM64 iOS Mach-O，构建主机是 Linux x86_64。需要 Python 3.10+
和 LLVM 19 共享库，无第三方 Python 包依赖。现有组装器使用 LLVM C API；
不需要 clang、llvm-mc、Xcode、iOS SDK 或 Objective-C 运行时。

GitHub 工作流使用 `ubuntu-24.04` 并安装 `libllvm19`。Ubuntu 官方文件清单确认该包
提供 `/usr/lib/x86_64-linux-gnu/libLLVM.so.19.1`；Ubuntu 的 `/lib` 合并路径与现有
组装器使用的路径兼容。[软件包详情](https://packages.ubuntu.com/noble-updates/libllvm19)
和[文件清单](https://packages.ubuntu.com/noble-updates/amd64/libllvm19/filelist)。

本地同类主机可安装：

```sh
sudo apt-get update
sudo apt-get install --no-install-recommends -y libllvm19 python3
```

摘要记录 Python 版本、LLVM 版本及其共享库 SHA256。两次重建一致只证明当前环境
内的重复构建；跨工具链版本是否一致以实际生成文件的 SHA256 为准。

`source-manifest.json` 记录实际构建与测试所用源码和固定输入的逐文件 SHA256。
摘要同时记录当时的 Git HEAD 和工作树是否干净；未提交的工作树不能仅凭 HEAD
冒充某个已保存提交。验证结束时会再次核对源码清单与候选二进制，任何中途变化
都会令整轮失败，必须在源码冻结后重跑。

## 检查范围

| 检查 | 约束 |
| --- | --- |
| 输入与复现 | 三个历史基础镜像固定 SHA256；两次重建逐字节相同 |
| 独立二进制审计 | 直接使用 Python 标准库解析候选文件，不导入生产构建器或其验证函数 |
| Mach-O 与原代码 | ARM64 dylib 头、原 section 元数据、明确白名单之外的原始内容不变 |
| 扩展映射 | 16/32/48 KiB、16 KiB 对齐、RX、无 W+X；原段地址保持不变 |
| 链接数据 | 所有 LINKEDIT 偏移、表内容及完整未签名区域；656 个 chained slots 和 23 个 imports |
| 代码地址 | 每条新增代码中的直接分支、ADR、ADRP、literal-load 目标；被改入口必须准确跳到目录项 |
| 签名 | 完整 ad-hoc CodeDirectory 结构与全部 4 KiB 页 SHA256 |
| 版本一致 | 安装名、数值版本、设置文字、签名标识；事件和导出写入同一版本常量 |
| 故障注入 | 23 个负对照，多数重算合法页签名后仍必须被其结构/内容检查拒绝 |
| 行为回归 | 运行候选 ARM64 指令；以明确的 Objective-C/UIKit 边界模型提供平台对象 |

负对照包含原始 1.5.8：其二进制与签名检查通过，但导出常量仍为 1.5.7，必须由
版本一致性检查拒绝，不能因为文件名写着 1.5.8 就算正确。

行为回归覆盖底栏材质、交互、诊断去重、feed 裁剪和祖先链、浮点转换误差与类继承、
reader 控件几何、返回图像 alpha 扫描、重复布局及撤销所有权。每份报告以实际候选
SHA256 识别输入，不复用旧候选的通过结果。

负对照按缺陷引入时期选择固定版本：基础控件几何用尚未包含该修补的 1.5.6，
重复布局与诊断去重用 1.5.7，本轮列表、可见箭头和导出版本错误用 1.5.8。
不能将已经修过基础几何的 1.5.7 误传给 1.5.6 的原入口测试。

## 结果的边界

`ci-summary.json` 的 `passed: true` 只代表列出的软件检查成功。它始终保留
`device_tested: false`：CI 没有运行真实 iPhone、UIKit 渲染、Core Animation 事务、
触摸分发或 dyld 注入。模拟的像素缓冲区与框架返回值不能代替设备截图或延迟测量。
ad-hoc 页签名校验也不能证明设备接受最终注入和重签名后的 IPA。

只要任一步失败，脚本返回非零并保留该步骤日志，后续不会生成“已验证”插件附件。
需要从失败报告定位具体约束，不能删掉检查或放宽断言来制造成功结果。
