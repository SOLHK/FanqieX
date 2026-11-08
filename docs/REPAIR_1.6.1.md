# FanqieX 1.6.1：原版阅读顶栏与系统底栏选择器

## 本轮用户要求

1. 阅读页上方返回、下载、评论、搜索、更多按钮恢复番茄原样。
2. 主底栏按用户提供的 App Store 参考改善可读性，避免书封和正文穿透文字。
3. 底栏滑动选择采用系统玻璃交互。

基于 `test` 的 `827a0ac82ef4a630bd5be66ffa8106a21aaea410` 继续开发。
该提交交付的 1.6.0 SHA-256 是
`2da6826d63d5e05ec6c2f20d3375d58186474490c9c92dc09c2cc734529560b1`。
没有回退到早期交接分支，也没有修改 `main`。

## 实际证据

此次两份一小时日志的顶层版本都是 1.6.0，但混合保留了 1.5.9 历史，且互相重叠。
分析只把当前 1.6.0 会话当成本次现象的直接证据。完整日志和阅读正文不进入仓库。

- 当前系统字段为 `Version 27.3 (Build 24C5037i)`。
- 主底栏使用 `Clear (1)`，存在的主材质均为 `UIGlassEffect`，alpha 为 1。
  过透不能归因于把整个视图 alpha 调低。
- 阅读页右上按钮的控件与材料尺寸都是 24×24 pt；继续修饰这个小圆圈不符合用户
  “恢复原样”的新要求。
- 日志中的选中镜片为空闲状态，`glassSelectionDragging=0`。空闲 effect=nil
  **不能证明实际拖动时没有玻璃**。旧代码确实在拖动开始时切换到 Clear 效果。
- 实际执行已发布 1.6.0 的 ARM64 指令，复现了一个拖动定位缺陷：选中第 3 项时，
  从第 1 项中心 x=55 起拖到 x=180，镜片被错误偏移推到第 4 项中心 x=361，
  最终走第 4 项路由。旧测试只覆盖从选中项内部开始，遗漏这个用户路径。

## 设计选择与实现

### 阅读页顶部：恢复宿主控制

`control_geometry.s` 和 `reader_fastpath.s` 对已确认的阅读顶栏建立优先作用域：
`FQReaderSaasNavigationView`、`SSStoryBigNavigationBar`、`SSStorySmallNavigationBar`
以及 `SSReaderNavigationBarDownloadButton`。

控件入口、图标入口和阅读栏布局入口都只执行插件状态清理，不再进入旧插件的玻璃
装饰函数；旧函数不是宿主的原生布局，不能简单把它当作“恢复原版”的 fallback。
清理覆盖旧玻璃、替换图片、状态图片、内边距和仍归插件管理的布局属性；如果宿主
后来自行修改了属性，则保留宿主的新值。原事件目标、宿主图片和控件尺寸由宿主管理。
顶栏不添加新的触摸观察器，不进行同步 `layoutIfNeeded`。

这项要求只针对阅读页上方按钮。底部目录、夜间、设置、改编剧场与“听”等现有路径
保留，并有独立回归覆盖。

### 主底栏：一个系统选择控件

正常路径使用公开 `UISegmentedControl` 作为整个底栏选择表面。标题与选中索引来自
实际宿主页签，`UIControlEventValueChanged` 通过原按钮身份映射回已有选页入口。
宿主从其他入口切页时，只同步系统控件的选中状态，不额外发送动作。
系统正在 tracking 且宿主选中项未变时，周期维护不抢写系统的临时选中状态；
实际宿主外部切页和 valueChanged 后的接受、拒绝或重定向结果仍以宿主为准。
原生控件和代理各自强持有回调 controller，其到 bar/proxy/window 的链接为弱引用；
清理先解绑 target，再释放强关联，防止代理先退出时留下悬挂 target。

原代理视图保留几何和归属以兼容现有滚动区域修复，但在系统选择器有效时不再提供
玻璃效果。旧自定义 pan 和选中镜片退出，避免争抢同一次触摸。
新增选择器不修改 UIKit 内部子视图、背景图片或私有滤镜，不伪造宿主 SDK 或全局设计模式。

若公开控件无法创建或当前宿主数据不适合桥接，则恢复原按钮，采用单一
`UIGlassEffectStyleRegular` 底材和普通灰色选中填充。兼容路径保留拖动选择，修正
非选中项起拖的偏移，但不冒称这个普通填充具有独立玻璃折射。
原始代理构造函数的样式立即数也从 Clear 改为 Regular，保证可见性尚未稳定时的
初始兼容材质一致；独立二进制审计核对该四字节指令，并以重算签名后的反例验证。
原生控件生效时，旧材质清理先于 alpha 稳定性检查，避免淡入中暂时叠加两个表面。

### 为什么没有交付“Regular 底＋Clear 镜片”

开发过程中曾验证这种组合在几何和归属模型中可执行。但苹果官方明确建议避免玻璃
叠玻璃以及混合 Regular/Clear；可执行并不等于适合交付。该实验已从最终实现移除。
系统控件的内部材质、选择透镜与触摸由 UIKit 统一管理。

官方依据：

- [Materials](https://developer.apple.com/design/human-interface-guidelines/materials)：
  Regular 会模糊并调整背景亮度以保持可读性；Clear 是高透明变体。
- [Meet Liquid Glass](https://developer.apple.com/videos/play/wwdc2025/219/)：
  避免光学叠加与混合变体，玻璃上的次级元素使用 fill 等方式区分。
- [Build a UIKit app with the new design](https://developer.apple.com/videos/play/wwdc2025/284/)：
  标准控件及分段选择的系统交互。
- [UISegmentedControl](https://developer.apple.com/documentation/uikit/uisegmentedcontrol)：
  公开标题、选中状态和事件接口。

## 诊断与验证边界

最近一小时日志与导出保留。新的关键字段包括：

- `readerTopOriginalControls=1`：确认阅读顶栏进入原版控件路径。
- `bottomBarRenderer` 与 `nativeSelectionControl`：区分系统选择器和兼容回退。
- `hostDesignRequiresCompatibility`、`hostSDKName`：记录宿主公开兼容信息；缺省为 null。
- `glassInteraction`：仅记录兼容交互的开始、结束、取消及有限几何；不记录每一帧，
  不读取书籍正文或标签内容，也不能冒充系统控件内部的拖动采样。

离线验证使用实际候选 ARM64 指令、明确的 UIKit/Foundation 边界模型、固定历史
二进制反例、独立 Mach-O/签名/修补范围检查以及两次逐字节一致构建。
原生桥接单元检查之外，完整编排检查执行真实 Lrepair、周期 monitor、原始选页入口
与退出恢复，覆盖首次安装、重复维护、fade 中兼容切换、tracking 与宿主同步。
原生控件桥接增加的代码使用最多 64 KiB 的 RX 扩展；新增第四页布局、实际跨越
旧 48 KiB 上限的内容和越界拒绝验证。没有增加可写可执行段。

Xcode 工作流使用真实 Xcode 27.2 / iOS 27.2 SDK 汇编实际插件、核对交付字节并
检查公开 API。具体运行是否通过应以对应提交的 Actions 结果为准。

**未在用户 iPhone 上执行本候选。** 未验证实际 GPU 折射、宿主系统选择器的最终
高度和外观、真机触摸竞争、帧率或 IPA 注入。宿主 SDK 与兼容模式可能影响系统控件
采用的新外观；仅将 dylib 用新工具链构建不能证明宿主完成了新设计适配。
不能把本报告或编译成功表述为“App Store 像素级一致/真机折射已验收”。

最终候选哈希和每个验证步骤记录在 `verification/1.6.1/ci-summary.json`；
设备观察点见 `DEVICE_ACCEPTANCE_161.md`。
