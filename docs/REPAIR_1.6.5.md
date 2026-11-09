# FanqieX 1.6.5 本地测试版

基于 `c65cc0d5b56debfe2dc8eaf529c275c67dd00006`。本版仅在本地制作，等待用户真机测试后再决定是否推送 `test`。

## 变化

- 底栏在基线里已实际调用 `UIGlassEffect`、`UICornerConfiguration` 和 `UISegmentedControl`，本版保留原生材质、选择桥接、登录拦截和 Safe Area 布局。不是仅修改 SDK 版本号。
- 为截图红框里的书城搜索框和分类入口增加系统 Regular 液态玻璃、原生胶囊形状及 interactive 属性。搜索框来自 `SSBookStoreNewViewController.searchBgView`；分类入口为 `SSBookStoreCategorySignView`。
- 这两个宿主控件不是普通 UIButton，使用公开 UIGlassEffect 装饰原控件，没有强行改用 UIButtonConfiguration 而改变原有布局和触摸回调。原文字、图标、分类红点、搜索词轮播和跳转方法保留。
- 材质在最终尺寸确定后插入；重复布局复用，切换频道和主题后更新；关闭插件液态玻璃后在下次布局恢复宿主最新背景。装饰不接管点击、不重复暴露辅助功能元素。

## iOS 26 及以上兼容策略

按用户最终要求，目标为 iOS 26 及以上的 ARM64 机型。插件使用通用 ARM64（CPU subtype 0），不使用机型名称白名单，不把架构头伪改成 arm64e。已有加载最低系统版本 15.0.1 保留，不额外抬高到 iOS 27。

原入口只认一个宿主可执行文件 UUID。现在增加 `com.dragon.read` + `CFBundleVersion 7.4.3.33` + 关键方法签名的识别路径，使同一已核对版本的其他 UUID 构建能够进入现有挂钩流程。每个实际 Hook 仍检查方法签名和方法归属；不通过新识别的包继续走原 UUID 校验，不盲目放开未知版本。

玻璃按运行时类和选择器能力启用，不写死 iOS 27。缺少 UIGlassEffect 或圆角等所需 API 时不安装新增玻璃 Hook；iOS 18 的缺失 API 路径也纳入离线检查。此处是兼容设计和本地证据，**不是已在市售所有设备上测试通过**。

“装上没效果”还可能是注入未加载、签名/安装流程、重复插件、关闭了开关、宿主版本不同或系统外观设置。没有故障机型和日志，不能认定 UUID 是每个现场故障的根因。本版宿主适配范围仍为番茄小说 7.4.3.33；未知版本需要单独核对。

## 安装与测试

1. 从原 IPA 移除旧 FanqieX / FanqieAdBlock 插件，再注入 `FanqieX-1.6.5.dylib` 并重新签名安装。同一 App 只保留一个版本。
2. 确认设置页显示 1.6.5，开启“启用插件液态玻璃”，彻底退出再打开。
3. 查看书城搜索框和分类入口：首屏有无矩形闪动，搜索、分类能否正常打开，返回后是否保持。
4. 切换推荐/小说/听书/看剧，切换系统明暗外观，检查背景和文字对比度。
5. 检查底栏四/五标签、点击/滑动切换、未登录拦截、书架顶部、阅读页和段评。
6. 如果仍无效果，确认加载的是新版本；在插件设置页开启增强诊断后复现并导出 JSON。看不到新版本设置页时，需先检查是否成功注入/加载。

## 验证范围与限制

本地验证包括严格 Clang 编译、确定性重建、独立 Mach-O/分支/签名页/异常展开检查、ARM64 实际指令配合显式 UIKit/Foundation 边界模型，以及既有底栏、书架、阅读、广告和启动诊断回归。新增测试涵盖七种视口宽度、ASLR、主题变化、重复布局、尺寸变化、关闭恢复、缺失 API、宿主身份/版本/ABI 拒绝和构造函数入口路由。

最终每项执行结果、源码冻结摘要和插件哈希在同包 `VERIFICATION.json`。没有进行 iPhone 安装、UIKit GPU 视觉、真实触摸、所有机型或本次 Apple SDK/CI 验证。Windows 交叉编译与离线模型不能替代这些验收。

工程在固定哈希的原插件二进制上重建 ARM64 修补层，不是宿主 App 完整源码重编译。本次实现独立编写，未复制第三方开源项目代码。

API 依据：[Apple UIGlassEffect](https://developer.apple.com/documentation/uikit/uiglasseffect)、[Apple UIButton configuration](https://developer.apple.com/documentation/uikit/uibutton/configuration-7gz60)。选择 UIGlassEffect 是为了保留现有自定义控件的交互，不改变为 UIButton 的 configuration 布局体系。

复现：`python scripts/verify162.py --version 1.6.5 --output build/verify165-new`。Windows 可复用现有 LLVM 适配环境；Apple 工具链检查入口为 `scripts/build_xcode27.py --repair-dir repair162 --version 1.6.5`，本次未运行该入口。
