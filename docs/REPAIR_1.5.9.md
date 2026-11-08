# 1.5.9 修复依据与验证边界

本次处理书架与“我的”页面滑动到底栏时的白色区域，以及阅读页返回箭头偏左的问题。源工程从已保存的 1.5.8 修补包恢复；本仓库同时保留固定哈希的旧插件，便于执行真实旧指令的负对照。

## 底栏下方的内容缺口

用户日志中，窗口为 440 × 956 pt，底栏起点为 y=882 pt。书架内层 `FQFeedListCollectionView` 在页面顶部折叠后位于 y=106 pt、高 784 pt，底边到 y=890 pt；“我的”内层列表同样位于 y=106 pt、高 776 pt，底边到 y=882 pt。两者分别缺少 66 pt 和 74 pt 的内容覆盖。日志同时显示列表背景已透明、底部边缘效果已隐藏，因此仅继续清除背景不能补齐缺少的内容区域。

旧代码还有明确的浮点判断缺陷：第 43 条记录的 frame 高度是 `784`，转换到窗口后的高度是 `784.0000000000005`；第 39 条记录中相应数值是 `776` 与 `775.9999999999998`。旧 ARM64 使用完全相等判断，真实旧二进制在这些输入上拒绝修复。去标识的几何值见 [1.5.9-observed-geometry.json](1.5.9-observed-geometry.json)。

新实现将转换坐标比较的容差限定为 0.5 pt，属性幂等与条件恢复比较使用 0.000001 pt 容差。它只处理选中的书架/“我的”内、确认属于 FQ feed 家族且满足完整窗口宽度、祖先坐标和裁剪约束的候选。找到覆盖屏幕底部的外层滚动容器后，扩展内层 feed 到窗口底部，并等量增加 bottom contentInset，保留原滚动位置与末尾内容的可达范围。

短的中间滚动容器不会终止祖先搜索；只有经过验证的中间裁剪节点会暂时放开裁剪，最终外层的裁剪仍保留。禁用、切页、移除或所有权变化时，仅恢复仍等于插件最后写入值的属性。宿主后续主动改动的属性优先保留。未折叠的页面头部、横向翻页中间状态、mask、圆角或非单位变换仍拒绝处理。

运行时子类和紧凑方法编码也纳入兼容与负对照；这些是有依据的防御性边界，现有日志没有证明该设备一定使用了 KVO 子类或特定中间容器。1.5.9 对目标 feed 的真实布局实现链进行观察，覆盖子类在调用父实现后重置高度，以及子类不调用父实现的路径。回归要求最外层宿主布局返回时视口已补齐，不能把等待下次监测当作这两种情形已经修好。宿主在这些回调以外、稍后再次改写布局的完整 UIKit 时序，仍需设备验收。

每个动态布局入口使用独立固定 trampoline，保存其原始 IMP；嵌套的父类回调不会经由最派生类重新查找 alias。注册表最多接管八个不同的运行时布局重写类，继承已有 observer 的类复用原入口；超出上限或遇到外部替换的入口会拒绝安装并记录诊断，不无限增加运行时 hook。

## 返回图标的可见像素居中

截图中的箭头深色像素横向范围为 x=50…77 px，中心为 63.5 px；圆形玻璃的横向中心约为 83.5 px，差约 20 px。截图只能证明可见结果偏左，不能据此确定宿主实际 UIImage 的透明边界、私有 getter 或视图类别。

旧实现只在部分 getter 返回 UIImageView 的路径处理返回图。没有该 getter、或 getter 返回 UIButton 时，通用扫描没有进入相同修正。新实现直接检查 FQ 阅读栏左侧的单图标控件，不再要求该 getter 存在；仍保留 getter 身份校验作为附加约束。

新实现通过公开 CoreImage API 获得至多 256 × 256 RGBA 像素，实际运行 ARM64 扫描 alpha≥16 的二维包围框。256 像素上限覆盖 44pt、3× 图像所需的 132 × 132 像素；缓冲区有固定上限，不读取任意大图。每张不可变 UIImage 缓存扫描结果和失败原因，复用 CIContext。它保留宿主 UIImage、contentMode、按钮 frame 与 target/action，调整非交互图标子视图的二维 center，使可见笔画中心与原玻璃中心一致。独立交互 UIImageView 自身不移动，只调整非交互装饰的位置。

UIImage 的旋转/镜像信息先通过 CoreImage 的公开 orientation 接口应用；RTL 的显示翻转在读取缓存后按当前布局方向处理。共享 CIContext 首次使用时，以一组已知透明/不透明的两像素图像校准行序，避免用测试模型的行序假定代替实际运行时结果。校准成功和失败均缓存。完整不透明图像只能测得整个可见矩形，不能据 alpha 扫描区分其中的文字与背景；诊断会保留测得的范围。

位移以保存的原中心计算，不在当前中心上连续叠加；后续几何扫描使用归一化的原始位置，防止玻璃跟着图标一起漂移。恢复值和弱所有权先准备完整，再提交位移。页面隐藏、移除、图标更换、宿主覆盖或控件复用时，都需要核对当前所有权后再撤销。

普通父视图布局回调还不能证明 UIButton 子视图已经完成布局。因此目标控件在测量前调用 `layoutIfNeeded`，先处理已有的子布局请求；不额外调用 `setNeedsLayout`，也不全局改写 UIButton/UIImageView 的布局方法。回归模型保留待执行子布局队列，并在父修复后再次执行队列，检查是否把居中结果覆盖。

这里使用 center 而不添加 transform：Apple 文档说明，非单位 transform 会让 frame 的值失去定义，不宜再用 frame 推导幂等布局。框架实际像素渲染、Core Animation 提交顺序、首次 CoreImage 初始化耗时和真机点击延迟仍需设备检查。

## 日志与版本

旧导出器把顶层 `pluginVersion` 固定写为 1.5.7，而新会话事件写为 1.5.8。原日志包含 899 条保留的 1.5.7 历史事件和 53 条 1.5.8 当前事件，不能据顶层字符串判断用户未更新。1.5.9 让事件与导出器使用同一版本常量，并独立检查两条实际写入路径引用同一地址。

新增 feed 候选诊断包含实际运行时类、拒绝阶段、原始/当前/应用高度、底部 inset、祖先几何和布局观察状态。返回图标诊断包含处理原因、水平/垂直位移、图标及父视图类、frame/bounds、图像方向与倍率、alpha 包围框及首次像素读取时间。详细候选数量有上限，稳定状态去重；保留最近一小时日志及原导出入口。

日志回归实际执行 1.5.8 的 ARM64 指令并写出 JSON，复现“新事件 1.5.8 / 导出顶层 1.5.7”的不一致，再检查 1.5.9 的两处值。三个独立模拟进程共享真实 plist 文件，检查跨版本保留历史事件、恰好一小时边界以及导出队列延迟；不会把历史 1.5.7/1.5.8 事件重写为新版本。

## 如何复核

构建和全部离线验证命令见 [CI_zh-CN.md](CI_zh-CN.md)。最终报告均标记实际输入 dylib 的 SHA256；只对同一冻结候选报告通过。

- 字节级核验：两次重建必须逐字节一致；原始代码保留区域、Mach-O 段、链接信息、656 个修复链槽位、23 个导入、版本和 ad-hoc 页签名独立验证。
- 行为核验：自定义 ARM64 指令解释器执行候选与旧版真实机器码；Objective-C、UIKit、CoreImage 的接口返回值由明确的边界模型提供。模型不会把 Python 版修复算法冒充插件执行。
- 负对照：真实旧版必须复现坐标拒绝、入口遗漏及版本错误；故障注入必须被独立审计拒绝，不能通过删检查制造成功。
- 设备边界：离线验证不运行真实 UIKit/GPU、iPhone、dyld 注入或最终签名 IPA，所有结果保留 `device_tested: false`。

## API 依据

- [Apple UIView.center](https://developer.apple.com/documentation/uikit/uiview/center)
- [Apple UIView.frame](https://developer.apple.com/documentation/uikit/uiview/frame)
- [Apple UIView.layoutIfNeeded](https://developer.apple.com/documentation/uikit/uiview/layoutifneeded())
- [Apple CIContext bitmap render](https://developer.apple.com/documentation/coreimage/cicontext/render(_:tobitmap:rowbytes:bounds:format:colorspace:))
- [Apple UIImage.size：逻辑尺寸包含图像方向](https://developer.apple.com/documentation/uikit/uiimage/size)
- [Apple UIImage RTL 显示标记](https://developer.apple.com/documentation/uikit/uiimage/imageflippedforrighttoleftlayoutdirection())
- [Apple kCIFormatRGBA8：RGBA 的 8 位分量格式](https://developer.apple.com/documentation/coreimage/ciformat/rgba8)
- [Chromium 原实现中的 kCIFormatRGBA8 数值](https://codereview.chromium.org/2799153005/diff/1/services/shape_detection/detection_utils_mac.mm)
