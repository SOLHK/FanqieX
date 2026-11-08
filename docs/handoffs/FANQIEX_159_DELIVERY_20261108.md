# FanqieX 1.5.9 构建与离线验证交付

日期：2026-11-08。开发分支：`work/159-scroll-mask-arrow-checkpoint-20261108`。

**状态：源码修正、可复现 ARM64 构建与离线回归已完成；实机验收未执行。** 不据离线模型宣称用户手机上的白色区域或箭头偏移已经消失。不合并 `main`。

## 接手续接

从 GitHub 分支 HEAD `a812989150311311cb715cf801b90d61885c9f1c` 建立工作副本，读取完整检查点及已有 1.5.8 源工程。后续发现旧临时工作区残留了比交接记录更多的 1.5.9 草稿；仅恢复其中可审阅的源码、测试和脚本，没有将旧草稿二进制或旧结果当作本次证据。确认历史 1.5.8 源文件及基线字节一致，重新补齐实现、增加反例并从源码完成本次全部构建。

草稿审查发现并修正了宿主子类在父布局返回后再次覆盖 feed 高度、图标只测水平 alpha、图标角色/所有权切换时残留位移等问题。最终证据全部来自 `verification/1.5.9/`，不使用此前临时报告。

## 交付文件

- [FanqieAdBlock-1.5.9.dylib](../../dist/1.5.9/FanqieAdBlock-1.5.9.dylib)
- [FanqieAdBlock-1.5.9.zip](../../dist/1.5.9/FanqieAdBlock-1.5.9.zip)
- [SHA256SUMS.txt](../../dist/1.5.9/SHA256SUMS.txt)

ARM64 Mach-O 插件大小 **139,792 字节**，SHA-256：

```text
e4435d143a22e21991ae753bca5af3f2d945dd6cd6ac3ab514c71d2a5e4d0810
```

ZIP 内插件与独立 `.dylib` 逐字节相同。使用既有注入与重签名流程替换旧版，同一宿主只加载一份插件。

## 两项修正及证据

### 书架/我的底栏内容缺口

真实日志中的内层列表分别欠缺约 66pt/74pt，背景透明及边缘效果隐藏并不能弥补列表高度。旧版还会因 `784` 与 `784.0000000000005` 一类坐标尾差拒绝修补。新实现对转换误差使用受限容差，识别实际运行时子类，检查中间分页容器和裁剪链，在满足目标页面及几何条件时将内层列表延伸至窗口底部并等量调整底部内边距。

布局观察覆盖宿主子类的 after-super 重置和不调用 super 的路径；只有外层宿主布局已结束才应用修正。最多保存八个独立布局重写入口，超限或第三方已替换入口会记录拒绝。切页、禁用、移除或所有权丢失时条件恢复，避免覆盖宿主的新值。现场未提供实际祖先树，相关动态链测试属于明确构造的防御性回归场景。

证据：[去标识的现场几何](../1.5.9-observed-geometry.json)、[61 项视口回归](../../verification/1.5.9/feed-audit.json)、[16 项集成回归](../../verification/1.5.9/feed-integration-audit.json)、[52 项扩展回归及旧版负对照](../../verification/1.5.9/feed-realistic159-audit.json)。

### 返回箭头的可见笔画居中

截图中可见箭头中心比圆形玻璃中心左偏约 20px（约 6.67pt）。截图不能证明宿主一定使用哪种 getter 或图像透明边距。

新实现支持缺少专用 getter、getter 返回 UIButton 以及嵌套图标路径。对可用 UIImage 经方向处理后扫描二维 alpha 包围框，用实际可见范围计算水平和垂直位移；保留宿主图像、点击框、target/action 和 contentMode。扫描有 256×256 上限、结果缓存及真实运行时行序校准。位移依据原中心，条件恢复并覆盖角色切换、复用与重复布局，避免积累或玻璃跟随图标一起漂移。

证据：[19 组居中回归及 3 个真实 1.5.8 负对照](../../verification/1.5.9/reader-alignment-audit.json)、[28 项阅读栏回归](../../verification/1.5.9/reader-fastpath-audit.json)、[16 项几何回归](../../verification/1.5.9/control-geometry-audit.json)。实际旧 1.5.8 在缺少 getter/返回 UIButton 两例保持约 −6.67pt 横向偏移，在非对称上下透明边距例保持 −8pt 纵向偏移；候选通过相应断言。

## 保留功能与日志

独立结构审计比较原始代码区域和链接信息，只允许显式修补位置及版本变化；原去广告相关机器码保留，并执行既有功能回归。液态玻璃交互、原诊断入口、限频去重、跨重启历史和最近一小时导出继续保留。

旧导出器顶层版本错误地写为 1.5.7，不能据此说用户没有更新。回归实际执行旧 1.5.8 导出并复现该错误；候选让顶层版本和当前事件同为 1.5.9，保留历史事件的真实版本。测试还覆盖共享 plist 的 1.5.7→1.5.8→1.5.9 重启、精确一小时边界与队列延迟。

证据：[日志回归](../../verification/1.5.9/diagnostic-dedup-report.json)、[玻璃交互](../../verification/1.5.9/interaction-audit.json)、[保留功能执行报告](../../verification/1.5.9/execution-audit.json)。新增诊断字段及拒绝原因见 [DIAGNOSTICS_159.md](../DIAGNOSTICS_159.md)。

## 实际执行与验证边界

冻结源码后实际执行：

```bash
python3 scripts/verify159.py --output output159/final
```

退出码 0，全部 16 个步骤通过，两次构建逐字节一致。报告同时记录候选 SHA-256、46 个源文件/输入文件的清单、构建环境和“设备未测试”状态。验证期间源码未变化。由于当时工作树尚未提交，摘要明确记录旧父提交及 `git_working_tree_clean_at_start: false`；源码身份由清单中的逐文件 SHA-256 确定，不能把旧父提交冒充本次修复提交。

| 范围 | 已执行结果 |
| --- | --- |
| 两次 ARM64 构建 | 字节相同，交付大小 139,792 字节 |
| 独立 Mach-O、修复链、页签名检查 | 通过；656 个 chained fixup 槽位、23 个导入受校验 |
| 独立校验器负对照 | 22 个注入破坏样本及 1 个原版 1.5.8 版本错误，共 23 个负对照全部被拒绝 |
| 列表视口/集成/新增边界 | 61 / 16 / 52 项通过 |
| 阅读栏快速路径/几何/可见范围 | 28 / 16 / 19 组通过，另含旧版负对照 |
| 玻璃表面/交互/集成/旧功能/日志 | 全部命令退出码 0，报告已保存 |
| UIKit、CoreImage/GPU、dyld 和 iPhone | 未执行真实系统或设备验证 |

源清单 SHA-256：`5d50747afd3ba7b43131678768f89eeead2e1e817438fd57a41b47fce7a7a16f`。

完整记录：[ci-summary.json](../../verification/1.5.9/ci-summary.json)、[source-manifest.json](../../verification/1.5.9/source-manifest.json)、[独立二进制审计](../../verification/1.5.9/independent-audit.json)、[故障对照](../../verification/1.5.9/independent-fault-tests.json)、[命令日志](../../verification/1.5.9/logs/)。GitHub Actions 使用同一入口重新构建并核对交付插件；本地保存的结果不代表 Actions 已经运行。

离线执行器运行真实 ARM64 插件指令，但 Objective-C、UIKit 和 CoreImage 边界由模型提供。它能证明这些已列明输入下的分支和几何计算，不能证明真实系统渲染与动态注入。无 CGImage、动画图像、非单位变换或不支持的裁剪会安全拒绝；完全不透明的图像只能按整个 alpha 范围测量，不能从背景中识别箭头前景。

设备上的最终合成、返回按钮观感、点击响应、首次 CoreImage 初始化耗时、滑动帧率、最终签名 IPA 与宿主全部动态布局时序仍待验收。下一步应按 [DEVICE_ACCEPTANCE_159.md](../DEVICE_ACCEPTANCE_159.md) 记录实际结果；只有实机证据齐备才更新设备通过状态。
