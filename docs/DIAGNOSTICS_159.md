# 1.5.9 布局诊断字段

日志仍通过原来的“最近一小时”导出入口生成。顶层 `pluginVersion` 表示当前导出器版本，事件内的版本表示事件产生时的真实版本，因此升级后保留的历史事件可以与顶层版本不同。

## 列表视口

底栏快照中的 `feedViewportDiagnostics` 保存有上限的候选列表。每个候选包括：

| 字段 | 含义 |
| --- | --- |
| `reportedClass` / `runtimeClass` | `-class` 报告的类与真实运行时类，用于识别动态子类 |
| `windowRect` / `currentHeight` | 当前窗口坐标与列表高度 |
| `decision` / `rejectionStage` | 最近的修补决定与拒绝阶段；阶段 11 表示布局 observer 未能安全安装 |
| `originalHeight` / `appliedHeight` | 插件持有的原高度与扩展后的高度 |
| `contentInset` | 当前滚动内边距 |
| `originalInsetBottom` / `appliedInsetBottom` | 本轮接管前后的底部内边距 |
| `currentlyOwned` / `observedByThisBar` | 当前是否由该底栏持有修正或观察关系 |
| `baseLayoutObserverInstalled` | 基础 feed 布局 observer 的安装状态 |
| `inheritsLayoutObserver` / `runtimeLayoutObserverInstalled` | 当前有效入口是否为观察入口，以及是否为运行时专用 trampoline |
| `layoutMethodEncoding` | 用于验证原布局方法 ABI 的编码 |
| `ancestors` / `ancestorsTruncated` | 最多八层祖先的几何、裁剪与变换信息，以及是否达到记录上限 |

修正后还应结合 `windowRect`、窗口大小及父级裁剪检查实际覆盖范围。记录存在或 `decision` 成功不等于已经验证了 UIKit 的最终合成像素。

## 阅读返回图标

`reader_back_alignment` 事件在图像或处理原因变化时记录，稳定布局不会逐帧输出整棵视图树。

| 字段 | 含义 |
| --- | --- |
| `readerBackReason` | 下表所列的处理结果 |
| `readerBackShiftX` / `readerBackShiftY` | 计算并应用的水平、垂直位移，单位 pt |
| `readerBackControlClass` | 目标控件的类 |
| `readerBackIconClass` / `readerBackIconParentClass` | 图标及直接父视图的类 |
| `readerBackIconFrame` / `readerBackIconBounds` | 记录时的图标 frame/bounds |
| `readerBackImageOrientation` / `readerBackImageScale` | UIImage 的方向和倍率 |
| `readerBackAlphaRect` | 已应用 UIImage orientation、左上为原点的归一化二维 alpha 包围框；RTL 在使用时另外映射 |
| `readerBackPixelReadMs` | 首次像素读取路径的耗时；不是端到端触摸延迟 |

| 原因值 | 含义 |
| ---: | --- |
| 0 | 图标子视图居中 |
| 1 | 图像未提供 CGImage，无法进入本版像素扫描路径 |
| 2 | orientation 非法，或对应公开 API 不可用 |
| 3 | 图像尺寸或 extent 不在允许范围 |
| 4 | Core Image 类不可用 |
| 5 | CIContext 创建失败 |
| 6 | 缓冲区或缓存对象创建失败 |
| 7 | 没有 alpha 达到 16 的像素 |
| 8 | 存在非单位 UIView transform |
| 9 | 子图标自身可交互，不移动其点击区域 |
| 10 | 需要的位移超出 20pt |
| 11 | 独立手势图标，只移动其玻璃装饰 |
| 12 | 图标或祖先隐藏 |
| 13 | 非零 capInsets 的可拉伸图像 |
| 14 | 动画图像或动画视图 |
| 15 | 正在显示替代高亮图像 |
| 16 | 原图绘制矩形受裁切 |
| 17 | 保留值；本版已支持 RTL |
| 18 | 位图行序校准不可用或失败 |
| 19 | 图标或祖先有 mask、圆角裁剪，或目标笔画会超出裁剪区域 |

## 本版支持边界

像素扫描的原图上限为每轴 256px、每次缓冲区最多 256KiB；每个不可变 UIImage 缓存扫描结果和失败原因。八种 UIImage orientation、RTL、常见 3× 图片与嵌套 UIImageView 有指令级测试。

本版不能从全不透明位图的 alpha 判断其内部哪个颜色是箭头前景；也不会为无 CGImage 的图像、未知 mask 或非单位视图变换猜测修正。遇到这些路径会保留原图和交互，并按原因记录。需要将真实设备导出的原因和图像/视图信息与截图对应，才能判断目标宿主是否进入了已覆盖的路径。
