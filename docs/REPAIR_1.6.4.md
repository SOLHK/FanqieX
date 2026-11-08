# FanqieX 1.6.4

本版在 1.6.3 的继承方法隔离基础上增加冷启动首页非标广告规则、评论诊断和对称底栏留白。
宿主仍受原有 UUID 检查约束。现有修补工程包含固定原始二进制和可重建的修补源码。

## 实际事件范围

| 入口 | 记录 |
| --- | --- |
| 现有 45 条广告规则 | 每次实际执行的规则编号、精确类和 Selector、调用次数、结果、耗时及方法归属确认。输入参数省略。页面展示状态为 unobserved |
| 首页非标广告 | 使用开屏广告开关和宿主原有跳过并标记已读分支，记录规则命中 |
| 段评气泡 | 模型绑定、计数刷新、点击、挂载、隐藏、移除、释放。计数包括原始值、有效值、数据是否存在和缓存标志 |
| 评论数据模型 | 计数 setter 的前后值、数据替换、网络完成后的计数提交及缓存写入调用返回 |
| 评论面板 | 打开调用前后、显示、开始退出、消失及宿主会话 Token 的关闭回调 |
| 评论网络 | 只观察 idea/list 与 comment/list 两个精确 RPC 模板。记录创建、发送、重发、取消、操作完成、响应结构、状态和错误码、字节数、响应乱序 |
| 页面 | 对已验证的阅读页、书城、短剧、书架及我的控制器观察加载、显示和消失 |
| 增强模式 | UIKit UIControl 的 action 交付、导航入栈/出栈，以及两秒未观察到相关转变的超时。该超时表示监测范围内没有转变 |
| Objective-C 异常 | 记录 NSException.raise 发生并转发原方法，省略异常 reason |

所有新增事件进入同一异步队列，包含时间、会话 ID 和关联 ID。评论面板使用宿主 Token 绑定操作，网络响应同步分发时携带请求上下文。不同响应先后顺序单独标记。
同一会话内相同书籍、章节、段落 ID 使用随机标签。标签映射最多保存 2048 个标识，重置后通过 identityGeneration 区分。原始标识不写入文件。

增强模式由设置页的「增强诊断关」按钮主动开启。默认仅记录规则、评论和已知生命周期事件。导出沿用「导出日志」。

## 存储与隐私

- 默认保留最近一小时。每批写入和每次导出按请求时间清理，序列化及文件操作在 worker 执行。
- 最多 2048 条待写事件和 8192 条保留事件，一个调度任务服务整个队列。满队列时累计丢失统计，导出控制请求会明确返回失败。
- 持久 JSON 数据最多 8 MiB，读取旧文件前检查大小，过大时拒绝解析。容量不足时删除最旧记录，导出标记 truncated 和 droppedRecords。
- 最多保留八个不可变导出文件。超过一小时的文件由维护任务和导出入口清理。维护计时器加入 common run-loop modes。写入失败会锁存错误，后续成功写入仍保留该错误信息。
- 点击观察计时器最多 64 个。每条新增事件由固定字段生成，省略正文、评论、Cookie、Authorization、Token、查询参数和请求体。
- 已持久化的原子文件可在进程重新启动后读取。尚在内存中的事件可能随异常退出丢失。

计数上限和文件字节上限约束日志资源。真实 Foundation 对象、临时序列化副本和系统文件缓存的峰值内存仍需 Instruments 测量。

## 底栏实现

宿主使用 SSTabBar，工厂单独计算胶囊和按钮列。1.6.4 在这一步读取 safeAreaInsets，以每侧约 20pt 为基准对称增加留白，同时保留至少 44pt 的按钮列。宽度不足时恢复宿主布局。
使用已有 UIGlassEffect Regular、UIVisualEffectView、UICornerConfiguration 和 UISegmentedControl。几何修改发生在按钮布局之前。
苹果的系统浮动标签栏由 UITabBarController 提供。UITabBarAppearance 本身负责外观，无法把此宿主自定义导航结构转换为系统控制器。
本次没有替换宿主导航控制器，原有标签内容继续呈现。

依据来自 [Tab bars](https://developer.apple.com/design/human-interface-guidelines/tab-bars)、[Materials](https://developer.apple.com/design/human-interface-guidelines/materials)、[WWDC25 284](https://developer.apple.com/videos/play/wwdc2025/284/) 和 [UITabBarAppearance](https://developer.apple.com/documentation/uikit/uitabbarappearance)。

## 可复现验证

```bash
python3 scripts/verify162.py --version 1.6.4 --output build/ci164 \
  --expect-candidate dist/1.6.4/FanqieX-1.6.4.dylib
DEVELOPER_DIR=/Applications/Xcode_27.2.app/Contents/Developer \
  python3 scripts/build_xcode27.py --version 1.6.4 \
  --expect-candidate dist/1.6.4/FanqieX-1.6.4.dylib
```

原生运行时模块使用精确类型的 objc_msgSend 调用。编译适配器拒绝未审查的导入、可写状态和重定位。已生成组件带有规范化源码哈希，构建和回归验证该对应关系。公开 API 契约及原生模块均由 Xcode CI 检查。
离线模型执行候选真实 ARM64 指令，Foundation、UIKit、网络和宿主方法使用明示边界模型。

## 设备验收及覆盖限制

用户需要在相同宿主上验证冷启动京东素材是否消失，随后检查段评 0/1/多条、打开关闭重进、翻页返回及重新启动。当前数据保留和异常调用模型不能证明真机故障已复现并修复。
四个页面顶部、中部、底部，浅色/深色、字体大小、旋转、安全区、后台恢复、快速切换，以及减少透明度/增强对比度仍待设备验收。实际图标、文字像素、折射、拖动和矩形闪帧需要最终注入后观察。
真实 CPU、内存、卡顿和页面延迟对比尚待 Instruments；本地测试时间属于指令解释器执行成本。

WKWebView 内部点击、SwiftUI 内部事件、未调用这些宿主入口的异步操作、任意第三方广告网络、系统级崩溃报告和底层信号崩溃尚未直接观察。
RPC statusCode 是宿主响应字段。没有独立的 URLSession HTTP 层观测，不能把该字段保证为每次请求的 HTTP 状态。解析事件反映宿主已经分发的结构，并不代表额外重跑 JSON 解析。
缓存记录确认调用已返回，未验证宿主缓存文件持久化。气泡复用通过重新绑定和模型 ID 变化观察，未推断宿主没有公开入口的复用原因。
