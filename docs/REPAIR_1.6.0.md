# 1.6.0：首次显示、阅读控件与原生玻璃

## 本轮依据

用户实际安装的 1.5.9 SHA-256 为
`e4435d143a22e21991ae753bca5af3f2d945dd6cd6ac3ab514c71d2a5e4d0810`，
与仓库 `dist/1.5.9/` 完全相同。本次分析了用户新提供的两份诊断导出和三张截图。
原始日志不上传公开仓库；必要字段见 [去标识的现场证据](1.6.0-observed-evidence.json)。

### 已证实的现象与代码缺陷

1. 首次进入页面时，列表和滚动边缘尚未进入管理集合。部分内层列表在初始化阶段
   因 `invalid-inset-baseline-or-content` 被拒绝，布局观察者也未安装；稍后扫描才修正。
   书架内层原高度 784pt、我的内层原高度 776pt，正常延伸高度均为 850pt。
2. 底栏本来就在使用系统 `UIGlassEffect` 的 Clear 样式；不能将缺陷解释成完全没有调用原生 API。
3. 返回箭头的真机记录两次都是 `readerBackReason=18`、位移 `(0,0)`。
   对照实际源码，18 是位图行方向校准失败；此前以 CoreImage 扫描作为必要条件的修正未执行成功。
   真机结构为 `UIButton → UIImageView`，图像视图 24×24pt、图像 scale=3、orientation=0。
4. 阅读底部目录、夜间、设置只有图标背板，文字位于背板外；改编剧场和听未得到同样样式。
   旧的作用域表没有覆盖完整的阅读底部控制单元。
5. 1.5.9 只替换了顶部阅读栏的旧样式尾调用；菜单和另外两个阅读容器仍走旧的递归处理。
6. 旧材质安装先设置空 `UIVisualEffect`，再设置最终玻璃；暂时隐藏/淡入后也重做这两次设置。
   新的机器码负对照直接复现了多余切换；这不是对 GPU 白闪帧数的测量。

### 尚不能由旧日志确定的事项

用户报告右上“更多”点击后延迟约 1–2 秒。两次旧顶部栏插件处理计时只有约20.43ms和1.15ms，
且不包括触摸分发、原宿主 action、菜单呈现以及未被替换的菜单/底部样式路径。
不能据此宣布完整延迟已定位到某一个方法，也不能把日志的采样间隔当作白闪实际持续时间。

## 首次显示与滚动边缘

`repair160/feed_viewport.s` 把观察器注册提前到目标视图已确认同窗口、可见之后。
初始化时内容为空可以推迟几何修正，仍会观察下一次正常布局。
启动时只注册日志证实的 `FQFeedListCollectionView`、`SSNestedContainerScrollView`、
`SSBookStoreUnlimitedContainerView` 的布局和挂窗回调；不修改 UIView/UIScrollView 基类。

回调通过最多八个弱引用 bar 找到唯一的可见同窗口宿主，只检查当前滚动视图和最多十六条
已有边缘记录。首帧不需要等待轮询，也不重新遍历整个窗口。既有变换、可见性、窗口、
内容和祖先裁剪检查仍约束实际修正；不合格的列表不会被强制拉高。

`audit160/test_first_frame160.py` 包含39项机器码回归。固定1.5.9分别在“空feed随后有数据”、
“迟创建书城嵌套滚动视图”和“迟创建书城无限内容视图”上作为必失败对照。
历史已应用但现已恢复的诊断结果明确显示 `previously-applied-now-unowned`。

## 材质生命周期

`repair160/material_lifecycle.s` 只安装最终的 `UIGlassEffect`，不再插入空效果。
相同窗口中临时隐藏、淡入和零尺寸布局保留缓存；实际脱离宿主、换窗口及效果被替换仍重新检查。

`audit160/test_material_transitions.py` 执行候选及固定 1.5.9 的 ARM64 指令：

- 旧版首次挂载写入两次 effect，隐藏/淡入/显示再写两次。
- 候选首次挂载写入一次 effect，隐藏/淡入/显示不再写入。

这些断言约束必要的生命周期行为，不将模拟的 setter 顺序冒充真实 UIKit 渲染验收。

## 阅读返回箭头与玻璃尺寸

返回箭头改为系统 `chevron.backward` 符号，按22pt配置缓存；正常布局路径不再加载
CoreImage、不创建 CIContext、不扫描位图。只有识别为阅读页左侧返回控件的图像才替换。
对于 UIKit 管理的 `UIButton.imageView`，必须先确认图像视图身份，再通过公开的
`imageForState:` / `setImage:forState:` 同步普通0–7状态，并保存居中对齐和边距。
自定义子图像视图走独立恢复路径。关闭效果或控件复用时，只恢复仍由本插件持有的值，
不覆盖宿主后来换上的图像或颜色。

阅读底部扩大到完整的“图标＋文字”控制单元，期望最小尺寸68×64pt，横向12pt、纵向10pt留白，
按内容增长并受实际控件 bounds 约束；浮动“听”期望最小为52pt圆形。玻璃始终位于真实可点击 bounds 内，
避免画出能看见却点不到的边缘。最终尺寸取决于宿主真实控件大小，离线模型不能保证所有
设备的宿主控件均有足够空间达到目标尺寸。

作用域增加改编剧场、阅读底部容器及浮动听书控件。沿用系统 Clear `UIGlassEffect` 与
`UICornerConfiguration`；“听”清理旧实色底后使用动态 `labelColor` 保证文字可读，
保存并条件恢复原颜色。玻璃视图不接管宿主触摸。

## 菜单处理与点击诊断

四个既有阅读栏/菜单/底部处理尾调用统一进入有界处理：深度最多3层、每次共享64个节点
预算，视觉效果与滚动子树作为叶节点。保留原宿主布局和 action；菜单先初始化、后挂窗时，
通过精确类的挂窗回调补齐样式。稳定几何避免反复写回，重入由已有忙碌标记阻止。

新增 `reader_touch` 记录对正确作用域中的 UIControl 被动添加四种 target：按下、内部抬起、
外部抬起和取消。不替换或再调用宿主 action。观察器由控件持有，对控件和 owner 用弱引用；
卸载只移除自己的 target，主线程守卫避免后台访问 UIKit。每个控件125ms内至多接受一次
手势，每次一个按下记录和第一个终态记录，后续正常点击继续记录。

记录包含实际控件 bounds、owner 中的 frame、玻璃是否越界和单调时钟。
`readerTouchCallbackIntervalMs` 是 target 回调间隔，可能包括先执行的宿主 target 耗时，
**不是**独立测量的 action 耗时或菜单呈现耗时。回归包含两种 target 顺序：人为注入200ms
派发间隔及1.5秒宿主耗时，观察者先执行记录约200ms，宿主先执行记录约1700ms；两种情形
宿主 action 都仅执行一次。这样防止将诊断字段误解成已测得完整延迟。

## Xcode 27.2 与系统 API

`scripts/build_xcode27.py` 要求真实 macOS、`Xcode 27.2` 和 iOS 27.2 SDK，使用所选 Xcode 的
`xcrun clang` 汇编实际插件补丁，再由原有受限 Mach-O 构建器组合成完整交付插件。
连续构建两次，并与已经执行离线回归的交付文件逐字节比较。

原始插件的代码、导入、链接结构和既有部署版本保持受校验的布局；这是一份基于固定二进制的
可重建修补工程，不冒充已经恢复了原始完整 Objective-C 工程。新汇编通过 Objective-C runtime
调用系统公开 API。

`native/PublicGlassAPI.m` 用当前 SDK 对 `UIGlassEffect`、`UICornerConfiguration`、
`UIImage` 系统符号和 `UIScrollEdgeEffect` 接口做类型检查，并静态校验 Clear 枚举值等于实际
汇编使用的1。该文件是 SDK 契约检查，不作为另外一份运行时样式实现，也不代表宿主被运行。

官方依据：

- [Xcode 27.2 正式版](https://developer.apple.com/news/releases/?id=10292026a)
- [UIGlassEffect](https://developer.apple.com/documentation/uikit/uiglasseffect)
- [UIVisualEffectView](https://developer.apple.com/documentation/uikit/uivisualeffectview)
- [UIButtonConfiguration](https://developer.apple.com/documentation/uikit/uibuttonconfiguration)

## 验证边界

本地 ARM64 执行器实际解释候选机器码，但 Objective-C/UIKit 边界使用模型。
Xcode 构建验证真实 Apple 工具链和 SDK，无法替代番茄小说内的真机注入、触摸和最终玻璃合成。
最终验收必须包括首次启动、反复切页、重进阅读页、更多菜单、底部按钮及关闭玻璃后的恢复。
未获得设备结果前，设备测试字段保持 `false`。
