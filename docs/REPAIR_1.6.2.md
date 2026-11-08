# FanqieX 1.6.2 — 底栏材质与书架按钮首帧

## 反馈与证据

本次从 `test` 的 `9e09670b498affb253b98d55d975fb0dc6696404`（1.6.1）继续。
用户截图显示底栏文字直接叠在书封面上，选中项为纯白胶囊。用户同时报告，
冷启动与阅读返回书架时，“今日已看听读”、编辑、筛选短暂出现矩形遮罩。
截图中的红圈用于定位按钮，本身不能证明闪动的持续时间。

视觉参照是用户此前提供的 App Store 截图（Today / Games / Apps / 搜索）：
整条底栏保留磨砂材质，背景颜色仍能透入，选中项为内缩的半透明强调层。
该参照不是 Apple Store 购物应用。

## 已定位的源码原因

### 1. 原生选择控件把底栏玻璃清掉

1.6.1 的 `LMmaterial_update` 在 `LNhas_native` 成功后执行 `setEffect:nil`。
与此同时，`LNupdate` 创建的是未配置选中颜色的 `UISegmentedControl`，
并把原按钮隐藏。原生控件存在不等于宿主已获得新 SDK 的完整导航外观。

这条执行路径会主动撤掉插件的 Regular 玻璃底座，并把选中外观交给
宿主兼容模式下的默认分段控件，和截图中的过透、纯白选中现象一致。

### 2. 书架装饰在配置最终几何之前挂入页面

旧工厂在 `0x7568` 插入玻璃视图，到 `0x75b0` 才设置最终 frame；
圆角配置由后续流程补全。四个真实书架布局入口最终均经过这一工厂路径。
这留下了首次加入页面时观察到零尺寸或未完成形状的窗口。

对已有装饰的修改还必须遵守当前导航动画事务，避免宿主的矩形背景在
阅读返回动画中单独渐变。本版把完整的可见状态配置作为一个步骤处理。

## 1.6.2 的改动

| 部位 | 行为 |
| --- | --- |
| 主底栏 | 保留一个 Regular `UIGlassEffect` 底座，原生选择器挂在其 `contentView` 内 |
| 选中项 | 显式使用 `secondarySystemFillColor`，避免依赖默认纯白选中样式 |
| 文字与内容 | 保留原按钮内容，原生选择器的重复文字隐藏；实际字形继续由 UIKit 绘制 |
| 点击与拖动 | 保留 `UISegmentedControl` 的系统跟踪和选择事件，继续调用原宿主选页入口 |
| 辅助功能 | 原生选择器保留语义标题，展示按钮避免产生重复可访问元素，并在退出时恢复状态 |
| 书架按钮 | 玻璃在挂入页面前完成最终尺寸、原生胶囊形状和非交互装饰配置 |
| 生命周期 | 缓存已配置装饰；仅在几何确实变化时更新，使用局部禁用隐式动画的事务 |
| 产品名 | 文件、ZIP、Mach-O 安装标识、签名标识和设置页统一为 FanqieX |
| 版本 | 设置页、运行诊断、导出诊断与二进制目录统一为 1.6.2 |

书架修复只作用于原插件已识别的四个宿主区域：`SSBookShelfHeaderView`、
`SS525BookShelfSubHeaderView`、`SSBookShelfEditHeaderView`、
`SSBookShelfFilterHeaderView`。阅读页顶部继续使用宿主原来的图标与布局。
不对 `UIView`、`UIScrollView` 或系统私有材质子视图作新的全局修改。

已发布的固定基线本来使用文字按钮。本版保留已有内容；条件测试中的图片
保留检查不代表已经给所有宿主补上图标，也不构成像素级复刻承诺。

旧偏好键、Objective-C 类名和诊断持久目录保留其兼容标识，以免丢失设置
和最近一小时日志。历史版本文件保持原名。本次修改没有新增全局设计模式覆盖；
原二进制已有外观开关的行为不应被描述为本次全新实现。

## 验证方法与边界

发布入口为 `scripts/verify162.py`。它从固定哈希的原始二进制重建两次，
要求逐字节一致，再执行独立 Mach-O/签名/地址/版本审计、故障注入和
实际 ARM64 指令回归。UIKit、Foundation 与 Core Animation 边界在离线
测试中使用显式模型，不模拟 GPU 像素或物理触摸。

书架新测试调用四个真实入口，并以已发布 1.6.1 为负对照，检查首次挂载、
阅读返回事务、同步重入、尺寸改变、零尺寸及复用路径。底栏测试检查
Regular 材质保留、语义灰色、触摸祖先、拖动期间同步、兼容切换和状态恢复。

真实 Xcode 27.2 / iOS 27.2 SDK 构建由 `.github/workflows/xcode27.yml`
执行，要求产物与本地审核的插件一致。`native/PublicGlassAPI.m` 负责检查
所调用公开 API 的类型契约，不能替代在番茄小说进程中运行。

最终本地结果见 `verification/1.6.2/ci-summary.json`；云端结果以交付提交
对应的 GitHub Actions 为准。真机上最终的材质浓度、动态折射、短暂遮罩
是否消失及注入签名，仍需安装该版本后观察，不将编译通过表述为真机验收。

## 参考

- [Apple：Build a UIKit app with the new design](https://developer.apple.com/videos/play/wwdc2025/284/)
  — 新 SDK 的适配条件、玻璃内容容器、原生控件跟踪和 `cornerConfiguration`。
- [Apple：Materials](https://developer.apple.com/design/human-interface-guidelines/materials)
  — Regular 材质和导航内容可读性。
- [Apple：UIVisualEffectView](https://developer.apple.com/documentation/uikit/uivisualeffectview)
  — 效果视图的内容容器、透明度和遮罩边界。

## 复现

```bash
python3 scripts/verify162.py --output build/verify162-fresh \
  --expect-candidate dist/1.6.2/FanqieX-1.6.2.dylib
```

macOS 上选择真实 Xcode 27.2 后：

```bash
DEVELOPER_DIR=/Applications/Xcode_27.2.app/Contents/Developer \
python3 scripts/build_xcode27.py --repair-dir repair162 \
  --expect-candidate dist/1.6.2/FanqieX-1.6.2.dylib
```
