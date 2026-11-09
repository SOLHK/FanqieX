# FanqieX 1.6.4 启动修复与加载诊断

用户报告：iOS 27.3 beta 1、番茄小说 7.4.3，旧插件能启动，初次交付的 1.6.4 注入后闪退。尚无该设备的系统崩溃报告，不能把离线推断等同于同机复现。

## 已复现的缺陷

新增的真实 macOS ARM64 Foundation/libobjc 测试在提交 `3ea97d026f45f40dbafb25e27fc0e8e1d81578b9` 上复现：

- 正常路径通过 763 个检查。
- `operationType` 为 NSNumber 或 NSNull 时，诊断代码发送 `isEqualToString:` 导致未识别 Selector 异常，进程退出 -6。
- 宿主评论 completion 主动抛出的异常经过 `Response` 后，外层原本可以捕获的异常变成未捕获异常，进程退出 -6。

证据：[真实运行时失败 CI](https://github.com/SOLHK/FanqieX/actions/runs/42541711960)。这些是实际 macOS 进程结果，宿主类由明确 fixture 提供，不是 iOS 真机结果；不能据此断定用户手机一定经过相同故障路径。

原生模块过去关闭了 unwind table，并且编译适配器没有保留 CFI。原 Mach-O 的 `__unwind_info` 只覆盖旧代码，新增原生 Hook 没有异常展开记录。此前自建 ARM64 边界模型把原回调按正常返回处理，没有检测真实异常传播，旧 CI 通过不能证明启动正常。

## 修复

1. 在接口标识进入精确匹配前验证 NSString 类型。未知值不记录为评论接口，继续转发原请求。
2. 启用同步异常 unwind，保留编译器生成的 CFI。读取同一个真实汇编对象的 ARM64 compact unwind，不手猜栈帧布局。
3. 将新函数记录和原记录合并，原位重建既有 4216 字节 `__unwind_info`。保留旧记录、函数间隙零编码、section 描述、依赖、导入和 chained fixup。未知 DWARF/personality/LSDA 或超容量直接拒绝构建。
4. 真实 Foundation 回归保留原异常对象和原 completion 调用语义，不能通过吞异常或删除失败用例修复。

格式与 ARM64 恢复规则依据 LLVM 的 [compact unwind 格式](https://github.com/llvm/llvm-project/blob/main/libunwind/include/mach-o/compact_unwind_encoding.h) 和 [CompactUnwinder](https://github.com/llvm/llvm-project/blob/main/libunwind/src/CompactUnwinder.hpp)。

## 插件加载诊断

独立小文件写入应用沙盒：

```text
Documents/FanqieX/load-diagnostics.json
```

该文件与异步事件队列独立，用于保留当前启动进度。最早记录位于通过原宿主 UUID 门槛后的过滤器安装入口；它不能记录尚未执行到此入口的加载失败。

记录固定阶段、时间、随机会话 ID、插件版本、系统版本、宿主版本和 build。当前接入的阶段为 `entry`、`diagnosticsInstallBegin`、`diagnosticsInstallComplete`、实际成功安装时的 `startupPopupInstalled`、`legacyHooksInstalled`，以及已知页面首次显示后的 `firstPageDidAppear`。允许的 `loadFinished` 和 `loggerReady` 保留为固定协议阶段，目前没有声称捕获整个构造函数返回或所有 logger 初始化。

`complete` 只在已知页面实际 `viewDidAppear:` 返回后置为 true。读取上一次启动时，仅保留其固定阶段、完成标记、时间和版本，不无限嵌套历史。上次未完成可能来自崩溃、杀进程或强行退出，不直接标为系统崩溃。

容量最多 24 个阶段、32 KiB；读取前后及序列化后均检查大小，原子写入。只在启动少量阶段同步写此小文件，常规一小时诊断仍在工作队列批量写入。写失败保留静态失败类别和 NSError code，不采集路径、错误描述、正文、Token、Cookie 或账号。

能进入应用时，导出 JSON 顶层 `loadDiagnostics` 和一次 `pluginLoad` 事件提供加载摘要。无法进入时，需要通过已有沙盒访问工具获取上述文件。dyld 拒绝签名或映像加载时插件代码无法执行，因此仍需要系统 `.ips` 崩溃记录，文件不存在不能证明插件没有注入。

## 验证与真实设备待验收

新增真实 Foundation/Objective-C runtime 回归在 Xcode 27.2 Runner 执行。其临时 Documents 路径由 fixture 隔离，不写 Runner 的真实 Documents。原 ARM64、二进制、签名、评论保护、广告和底栏回归全部保留，并增加加载诊断、CFI 和 unwind 表故障控制。

没有用户 iPhone、iOS 27.3 beta 1 原生运行环境或系统崩溃报告。最终同机冷启动、后台恢复、重复启动、段评开关/关闭、京东弹层、底栏触控和真实性能仍需验证。真实 Foundation 测试也不覆盖 UIKit 渲染、宿主网络实现或实际 IPA 注入签名。

目前 `[NSException raise]` 已有线程上下文清理路径；直接 `@throw` 绕过该观察入口时，关联 ID 的恢复仍有覆盖限制。unwind 修复保障异常可以传播，不等于所有未知异步路径的日志关联均完整。
