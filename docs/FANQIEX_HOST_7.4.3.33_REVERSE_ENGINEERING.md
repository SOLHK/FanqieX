# 番茄小说 iOS 7.4.3（7.4.3.33）宿主逆向与 FanqieX 适配记录

本文记录一份具体 IPA 的包结构、Mach-O 加载信息和目标功能的原生调用链。样本、反汇编工具、诊断和录屏各有独立证据。方法偏移只用于复核这个构建，插件运行时按类、实例归属和方法编码定位。本分支发表分析，文中修复策略与离线验证对应本地构建。

## 1. 样本指纹和证据

| 字段 | 值 |
| --- | --- |
| 包标识 | `com.dragon.read` |
| 主 bundle | `Payload/Reading.app` |
| 主可执行文件 | `Reading` |
| 应用版本 / 构建号 | `7.4.3` / `7.4.3.33` |
| IPA 文件大小 | 311,524,286 字节 |
| IPA SHA-256 | `744a604f3d7803ea9ad93a99e805ad47e2602f645f8a0f36ccb4e4eabcd31ede` |
| Reading 大小 | 511,603,408 字节 |
| Reading SHA-256 | `8ddf85f4c490d595109f7a4352ce842e07f66e4802d7da6705610a4050abf271` |
| 架构 | 薄 Mach-O，ARM64_ALL |
| 主 Mach-O UUID | `BEE37D93-3E70-332F-98F1-20890F02BB12` |
| 平台 / 最低版本 / 链接 SDK | iOS / 15.0.1 / iOS 26.0 |
| UI 设计兼容标志 | `UIDesignRequiresCompatibility = true` |
| 加载元数据 | `LC_BUILD_VERSION`、`LC_UUID`、`LC_DYLD_CHAINED_FIXUPS`、`LC_ENCRYPTION_INFO_64` |
| 样本的 cryptid | 0 |
| 设备诊断范围 | iOS 27.3，FanqieX 1.78R15，记录到 `firstPageDidAppear` |

对 IPA 内的 `Reading` 直接做流式哈希，并与本地反汇编输入逐字节比对。后续文件偏移、类表和指令锚点绑定到这份文件。重新打包会改变 IPA 的压缩外壳。比较宿主版本时还要检查主程序 SHA-256、UUID、架构和方法编码。

| 证据 | 建立的事实 | 使用边界 |
| --- | --- | --- |
| REA 6.7.0 IPA inventory | 原始 ZIP 中有哪些条目、来自哪一份归档、覆盖了哪些条目 | 结构识别和包内路径 |
| REA Apple Application Graph | 应用、扩展、资源 bundle、框架、脚本等组件的关系 | 路径和格式规则得到的角色，调用关系需另外核对 |
| Python `zipfile` / `plistlib` / SHA-256 | 可执行文件的内容身份、Info.plist 版本、包内路径数量 | 可独立重复计算 |
| LLVM `llvm-objdump --macho --private-headers` | 架构、分段、load commands、签名和重定位表的位置 | 文件结构与指令检查 |
| 本地 Objective-C 元数据解析、Capstone AArch64 | 类继承、实例方法列表、选择器、编码、IMP 及分支路径 | 动态分发处要结合 selector/ref 和宿主布局核对 |
| 设备日志和录屏 | 首帧、触摸归属的可观察结果、轨道与底栏几何、出现时序 | 适用于实际交互和画面，单帧无法识别接收触摸的对象 |
| ARM64 离线执行 | 编译后 hook 在建模的 UIKit 边界内的分支、安装和还原 | 交付包仍需在 iPhone 上验证最终渲染、触摸与分享 |

REA 的 `inspect-artifact`、`project-apple-application-graph`、`trace-dylib-resolution` 和 `execute-rizin-command` 已在本地执行，其中组件投影返回 `complete-within-inventory`。Windows 上 `inspect-macho` 的 `native-macos` provider 不可用，深度 dispatch 查询也缺少配置好的引擎。本报告用 LLVM、ObjC 元数据解析和 Capstone 完成本机 ARM64 反汇编核对。 [REA 上游仓库](https://github.com/morluto/rea)

## 2. 包内结构与适配边界

归档有 3,812 个文件，共 615,298,509 字节解压数据。主应用包含 14 个直接位于 `Frameworks/` 的框架。其中有 `TTFFmpeg`、`bytevc0`、`bytevc1enc`、`byteaudio`、`VolcEngineRTC`、`ByteRTCNICOExtension`、`RealXBase`、`libvcn` 和 `boringssl`。包名可以作为进一步调查的入口。LLVM 还确认 `TTFFmpeg` 导出了 `avcodec_find_decoder` 和 `avcodec_find_encoder`，`VolcEngineRTC` 暴露了 `ByteRTCEngine` 等类，`boringssl` 导出了 `SSL_connect` 和 `TLS_method`。本文短剧布局和进度拖动的直接证据都来自主程序 `Reading` 中的 Objective-C 类，框架清单不能独立证明某个播放页面在运行时选用了哪条媒体传输或解码路径。

`PlugIns/` 下的 `ReadingNotificationExtension.appex`、`ReadingWidgetExtension.appex` 有独立的 bundle 和可执行文件。主界面适配的宿主边界是 `Reading`，应对加载目标做主 bundle、可执行文件、构建指纹校验。资源形式包括 67 个 `.car`、36 个 `.nib` 和 22 个 `.js` 文件。REA 识别出 native 和 javascript 两种包内模式。页面是否由某段脚本生成需要脚本到原生桥接的单独证据，本文仅对已核对的 UIKit/ObjC 路径作结论。

### 2.1 从方法列表到执行路径

1. 取 `__objc_classlist` 中的类记录，沿类元数据读取类名、父类和实例方法列表。ARM64 的相对方法条目与由 chained fixups 编码的对象指针需分别处理。
2. 把相对 IMP 映射回文件区间。从 `__objc_selrefs`、类引用、GOT 和短转发桩取出 `objc_msgSend` 目标选择器。保留动态分发边界。
3. 继续核对首个确定的条件跳转、几何计算和属性写入。遇到相同名称但不同 owner 的方法要分别验证。例如短剧的两个 `progressPanGesture` getter 对应两套互不共享的触摸路径。
4. 将文件偏移与虚拟地址区分。下面表里的十六进制值是样本的**文件偏移**。对一个落在某段内的文件偏移，首选镜像地址为 `segment.vmaddr + (offset - segment.fileoff)`。调试器里的地址还要加加载时的 ASLR slide。
5. 运行时钩子通过类名、选择器和 Objective-C 类型编码匹配。对象返回、`BOOL`、`double`、`CGPoint` 和 `CGRect` 的调用约定不同，缺失或失配时走该处宿主路径。插件内的布局判断也需验证当前选中的 tab 控制器、window、父子关系和呈现生命周期。

### 2.2 三个可执行入口和 dylib 路径

从样本本地暂存 `Info.plist` 和相关可执行文件，再用 REA 的 `trace-dylib-resolution` 复核。结果包含三个 ARM64 根，即 Reading、通知扩展和 WidgetKit 扩展，共 17 个 Mach-O 镜像与 348 条依赖边。主程序直接以 `@rpath` 引用 14 个包内框架，搜索路径依次含 `/usr/lib/swift` 和 `@executable_path/Frameworks`。31 条为条件解析，另有 245 条普通和 72 条弱引用处于待解析状态。这些边涉及设备系统目录、共享缓存或不在暂存范围内的前缀。设备安装和重签后的实际加载结果还需对照 iOS dyld。应用声明了 `audio`、`fetch` 两类后台模式，声明本身不能解释具体控件状态。

### 2.3 用 REA 与 Rizin 交叉核对原始机器码

整份约 512 MB 主可执行文件的 Rizin 会话超过工具时限。对三个确定的文件范围分别取样，计算各段 SHA-256，再在 REA 的 Rizin 入口以 ARM64 模式解码。解码前后的文件字节及摘要均核对，合计返回 23 条 A64 指令。在切片采用相对地址时，加上切片起点即可得到对应宿主文件偏移。`ADRP` 的页基需要从真实指令地址计算，ObjC 调用语义则从完整 Mach-O 中的 selector 引用和类引用获得。

| 切片起点 / 长度 | SHA-256 | 独立核对 |
| --- | --- | --- |
| `0xFC7DF80` / 60 B | `cf9bf5897440dd40965e4634813d3d92388ab5fc7d640a51d6d190076f35a197` | 背景的创建、属性写入与释放调用顺序 |
| `0xFC7ED0C` / 12 B | `8b4d38245690bc9ac8ebd5b9a5b81c3ee77bb146882da01810932b4a08782795` | setter 处的转发跳转 |
| `0xE9BF30` / 20 B | `07b40031dcc8a2764f5f30bd7a09238f133b16964906a464799e49548025c3af` | `0xE9BF3C` 处将 Bool 参数置零，随后调用显示状态 setter 的桥接 |

切片用于指令级交叉验证。iOS 的运行行为依靠设备诊断和对应的离线模型核对。

## 3. 主底栏与短剧拖动

### 3.1 设备现象和坐标

12.03 秒录屏中，约 0–4 秒能在书架、我的、书城之间通过玻璃底栏拖动切换。进入短剧后，约 5 秒以及 7.5–9.5 秒可见进度预览缩略图和进度时间变化。对应时段设备日志有短剧胶囊的状态和轨道样式变化，缺少新的底栏 `glassInteraction began/ended`。离开短剧时底栏事件恢复。录屏没有触点叠层。

| 控件 | 实测 window 坐标（pt） |
| --- | --- |
| 宿主 `SSTabBar` | `[0, 882, 440, 74]` |
| 玻璃胶囊 `UIVisualEffectView` | `[20, 882, 400, 62]` |
| 插件拖动层 | `[20, 882, 400, 62]` |
| 原生进度容器的一个常见状态 | `[0, 851, 440, 30]` |
| 一般播放 / 点位变粗时的可见轨道 | `[16, 873, 408, 2]` / `[16, 871, 408, 4]` |

这些坐标解释了为什么仅看截图会误判。轨道画在胶囊上方，但识别器使用的是扩大的触摸区域。底栏同时有系统玻璃材质视图与负责手势和原生按钮的透明层。

### 3.2 两套播放控制路径

| 类和方法 | 类型编码 | 文件偏移 | 指令证据 |
| --- | --- | --- | --- |
| `FQVShortVideoVPlayerControlView.progressPanGesture` | `@16@0:8` | `0x8150400` | 取内层识别器实例 |
| `FQVShortVideoVPlayerControlView.gestureRecognizerShouldBegin:` | `B24@0:8@16` | `0x8148318` | 对比识别器，后续由扩展轨道区域决定是否允许 |
| `FQVShortVideoVPlayerControlView.progressPanGesture:gestureState:` | `v32@0:8@16q24` | `0x814b624` | 处理实际播放定位状态 |
| `SSShortVideoOutterMultiGenreFeedControlView.progressPanGesture` | `@16@0:8` | `0xefeab98` | 建立独立目标 `progressPanGestureAction:` |
| 同类 `hitTest:withEvent:` | `@40@0:8{CGPoint=dd}16@32` | `0xefe6188` | 常规命中以后检查 `shouldHandleProgressGesture` 和扩展热区 |
| 同类 `gestureRecognizerShouldBegin:` | `B24@0:8@16` | `0xefeab0c` | 比较独立识别器，取 `locationInView:` 并执行 `CGRectContainsPoint` |
| 同类 `gestureRecognizer:shouldReceiveTouch:` | `B32@0:8@16@24` | `0xefeabcc` | 可在触摸开始时对该识别器做归属判定 |
| 同类 `progressSliderExHotAreaFrame` | `{CGRect={CGPoint=dd}{CGSize=dd}}16@0:8` | `0xefeaa8c` | 外层扩展热区 |
| 同类 `progressPanGestureAction:` | `v24@0:8@16` | `0xefe9b54` | 分派 `beginSlideProgressAtLocation:`、更新与结束 |

上一版只覆盖内层 `FQVShortVideoVPlayerControlView` 的 delegate。外层控制视图也有扩展命中区，所以仍会在短剧拖动中抢到触摸。适配在外层命中测试和识别器接收开始触摸时让出胶囊范围。内层保留由当前位置与 translation 还原起点的检查。两处只对主短剧页面的可见胶囊生效，弹窗打开、底栏隐藏、其它页面或轨道范围内继续走宿主。拖动镜片及 release 后的选择沿用现有 UIKit 玻璃与 tab 路由。

### 3.3 「查看全集」与轨道间距

旧布局路径针对 `SSShortVideoBottomDistributionView` 与 `SSShortVideoAlbumSeriesBottomInsertView`，沿着 `FQVShortVideoVPlayerControlView` 找所属的 `insertAboveProgressView`，用实际轨道顶边和胶囊底边计算 8 pt 间距。真机日志中已有 34 次 `separated` 以及 39 次 `noUniqueEpisodeEntry`，说明该修正只覆盖其中一部分布局。后一状态也会出现在离屏切换帧，不能把每一次记录都当成截图里的重叠。

外层的 `setupSubviewsIfNeeded`（`0xefe66e4`）挂载 `SSShortVideoOutterMultiGenreFeedAboveProgressView` 和 `SSShortVideoOutterMultiGenreProgressView`。外层进度视图用 `progressBgWidth`、`progressBarHeight` 和 `progressBarYWithHeight:` 设置轨道的可见矩形，x 为 16 pt。由这些属性重建轨道几何，定位全集入口自己的 `backgroundView`，取它的实际可见底边。可复核的锚点如下。

| 外层方法或指令 | 文件偏移 | 作用 |
| --- | --- | --- |
| `layoutSubviews`（控制视图） | `0xefe66b0` | 容器布局后的同步点 |
| `updateAboveProgressLayout` | `0xefe8630` | 更新全集入口、标题与约束 |
| `setupConstraints` 中的 Masonry block | `0xefe80c4`–`0xefe8130` | 上方入口 bottom 约束指向 `progressView.mas_bottom`，常量 -7 pt |
| `layoutSubviews`（轨道） | `0xefe56a0` | 使用宽度、高度与 y 方法，写入背景和填充 |
| `progressBarHeight` / `progressBarYWithHeight:` / `progressBgWidth` | `0xefe57d8` / `0xefe57f8` / `0xefe58f0` | 直接复用宿主轨道几何 |

外层修正只调整这条 bottom 约束所需的偏移，并提交相同的当次 frame。轨道的触摸面积、点位和播放时间交由宿主管理。以宿主基准常量计算修复位置，重复布局不会累计偏移。入口隐藏、页面切换或不满足归属条件时恢复插件拥有的改动。

## 4. 短剧顶部横向搜索框

### 现象与宿主边界

设备截图中的灰色控件是短剧首页顶部的整行搜索提示框。宿主把整行搜索框和单独的放大镜按钮做成不同视图，使用各自的挂载与显示逻辑。关闭插件里的独立放大镜开关之后，整行搜索框仍可能出现。上一轮对整行搜索框的抑制依赖少数布局回调结束时再隐藏，而宿主还可以在其后调整或恢复搜索视图。

分析使用番茄小说 7.4.3，内部版本 7.4.3.33。样本 IPA 中 `Payload/Reading.app/Reading` 的 SHA-256 为 `8ddf85f4c490d595109f7a4352ce842e07f66e4802d7da6705610a4050abf271`，与本地用于检查 Objective-C 方法表及 ARM64 指令的 `Reading` 文件完全一致。诊断确认宿主版本与上述分析一致，且插件到达 `firstPageDidAppear`。截图说明灰色搜索框实际显示过。诊断未记录搜索视图状态，无法从日志单独归因到某次具体的重显调用。以下地址是宿主 Mach-O 文件偏移，用于复查此版本。

### 视图归属与原生调用链

| 宿主方法 | Objective-C 类型编码 | ARM64 文件偏移 | 观察结果 |
| --- | --- | --- | --- |
| `-[SSVideoSeriesFeedViewController setupHeaderViews]` | `v16@0:8` | `0xFC946D0` | 创建并赋值 `headerView`，设置 delegate，调用 `setupSubViews`，随后挂载 header。 |
| `-[SSVideoSeriesFeedHeaderView setupSearchViewContainer]` | `v16@0:8` | `0xFC7FF3C` | 创建 `SSVideoSeriesFeedHeaderSearchView`，分别调用 `setupNewSearchBar` 和 `setupSearchButtonView`。 |
| `-[SSVideoSeriesFeedHeaderSearchView setupNewSearchBar]` | `v16@0:8` | `0xFC7DF80` | `0xFC7DF90` 调用 `[UIView new]`，`0xFC7DF94` 调用 `setSearchBgView:`，`0xFC7DF98` 释放创建时持有的引用。之后通过属性读取背景，继续设置样式和子视图。 |
| `-[SSVideoSeriesFeedHeaderSearchView setSearchBgView:]` | `v24@0:8@16` | `0xFC7ED0C` | 使用 `objc_storeStrong` 保存背景。getter 是 `searchBgView`，类型 `@16@0:8`，偏移 `0xFC7ED00`。 |
| `-[SSVideoSeriesFeedHeaderView prepareFindDramaPageSearchRowV731IfNeeded]` | `v16@0:8` | `0xFC83548` | 获取同一个背景，迁移到 `findDramaSearchRowViewV731`。这解释了为什么只隐藏原来的父容器无法覆盖所有布局。 |
| `-[SSVideoSeriesFeedHeaderView applySearchBarVisibilityForCurrentLayout]` | `d16@0:8` | `0xFC86110` | 迁移和旧布局分支均会写入 `searchBgView.hidden = NO`，之后写入 alpha。返回值是双精度浮点数，供上层布局使用。 |
| `-[SSVideoSeriesFeedHeaderView updateFindDramaSearchAlphaV731:]` | `v24@0:8d16` | `0xFC843A0` | 短剧搜索状态变化时先重新显示背景，再写入动画 alpha。 |
| `-[SSVideoSeriesFeedHeaderView resetTopTabSearchViewWithRatio:fromTab:toTab:fromTabTemplate:toTabTemplate:]` | `v40@0:8d16i24i28i32i36` | `0xFC824C8` | 分类横滑时的原生过渡也访问同一个搜索背景。 |

单独的放大镜使用 `searchButtonSlotView` 和 `searchButtonView`。冷启动时宿主的 `SSVideoSeriesFeedSearchIconCoordinator` 还可以把放大镜移动到过渡层，所以沿用已有的冷启动开关处理。

### 修复与验证

在已核对的 `SSVideoSeriesFeedHeaderSearchView` 创建入口，为新建且未挂载的横向搜索背景使用专用的 `UIView` 子类。子类在调用原生 `setHidden:` 实现时固定传入隐藏状态。宿主仍通过原 getter 保存、布局和迁移这个对象。背景在第一次挂载前即隐藏，即使 native 布局稍后执行 `setHidden:NO`，也不会恢复显示。现有的放大镜、短剧分类和其他原生入口分别使用其原有视图。

只针对这一类搜索容器的属性写入，并检查构建方法、getter、setter 和 `UIView.setHidden:` 的类型编码。替换仅接受原生的普通 `UIView`，同时要求它尚未挂载。成熟视图不会被换掉。无需替换整个头部容器，也无需改写全局 `UIView` 方法。

本地 ARM64 专项验证已通过，覆盖首次赋值、迁移到独立行、宿主直接调用 `setHidden:NO`、原生 alpha 返回、独立放大镜开关和冷启动过渡。修复核心 SHA-256 为 `0b9114db50c19e0980309457b27ee9d7e7470be80849cfc85ed2802c2cd68d2b`。上一个核心在同一专项测试中未能通过首次赋值断言。此处的行为测试使用 ARM64 离线执行环境，iPhone 上的首次短剧进入、分类切换、上下刷剧及放大镜开关仍需实机查看。安装测试包后可以从书架切入短剧，再上下刷一集并切回书架。预期整行灰色框不出现，放大镜独立响应其设置。

其他宿主版本应重新核对类、类型签名和背景初始化顺序。特别是 `setSearchBgView:` 若开始接收已配置的背景或自定义背景类，现有挂载假设需要重新验证。

## 5. 书架顶栏与吸顶筛选行

### 宿主调用路径

以下位置为 7.4.3（内部构建号 7.4.3.33）宿主 `Reading` 的 ARM64 文件偏移。运行时按类名、选择器和方法编码定位。

| 宿主类 | 选择器 | Objective-C 方法编码 | 文件偏移 |
|---|---|---|---:|
| `SSBookShelf525ViewController` | `viewLayout` | `v16@0:8` | `0xd3a183c` |
| `SSBookShelfSubViewController` | `updateFullGenreFloatingViewWithScrollView:` | `v24@0:8@16` | `0xd3de400` |
| `SSBookShelfSubViewController` | `fullGenreFloatingContainerView` | `@16@0:8` | `0xd3ec2d0` |
| `SSBookShelfFunctionCell` | `layoutContainerView` | `@16@0:8` | `0xd4f0f68` |
| `SSBookShelfFunctionCell` | `headerView` | `@16@0:8` | `0xd4f0ee4` |
| `SSBookShelfFilterHeaderView` | `initWithFrame:` | `@48@0:8{CGRect={CGPoint=dd}{CGSize=dd}}16` | `0xd4ee7b0` |

`SSBookShelf525ViewController` 管理根视图、书架分类标题和分页容器。活动子页的 `SSBookShelfSubViewController` 管理纵向列表和筛选吸顶。两排按钮在屏幕上相邻，分别由根控制器和活动子页布局。

`0xd3de780` 至 `0xd3de84c` 创建一个普通 `UIView`，设置 `clipsToBounds`，从 `viewModel.uiConfigParams.backgroundColor` 取背景，随后把浮动容器加入子页的 `view`。从 `0xd3de854` 起，原函数检查 `SSBookShelfFunctionCell.layoutContainerView` 的父视图，必要时把同一个控件容器加入浮动容器。函数的另一条路径把它放回列表。`SSBookShelfFunctionCell.headerView` 可根据分支返回 `SS525BookShelfSubHeaderView` 或 `SSBookShelfFilterHeaderView`。后者初始化时另设语义背景色。

原实现把 `UIVisualEffectView` 加到根视图，止于书架标题排的原始边界。设备侧几何诊断记录原始滚动分页视口从 106 pt 开始，截图中的接缝正落在此边界。上方采样滚动内容，下方的浮动容器及筛选视图仍使用宿主画布色。

### 共用背景的视图顺序

吸顶路径先执行宿主布局。在活动子页、可见浮动容器紧邻标题边缘且祖先裁剪区域可覆盖两排时，插件将同一个轻薄模糊视图挂到浮动容器的父视图。模糊位于列表上方、浮动容器下方，根视图内的标题控件仍处于其上。模糊从页面顶部延伸到实际筛选容器底边。

吸顶坐标继续由原始标题排的范围计算。扩展后的模糊高度仅用于绘制，因此重复滚动不会把筛选排不断向下推。只清理已确认归属的浮动容器和筛选表头背景。铺在分页视图之上的装饰图在双排共用模糊时退场，防止它只覆盖第一排形成接缝。退出吸顶时同一个模糊回到标题排，恢复筛选层的宿主填充。关闭玻璃时撤销插件的模糊、背景和滚动 inset 改动，筛选控件和宿主的吸顶行为继续生效。

## 6. 书架冷启动标题居中

| 宿主类 | 选择器 | Objective-C 方法编码 | 文件偏移 |
|---|---|---|---:|
| `SSBookShelfTabSelectView` | `preferredCellWidthAtIndex:` | `d24@0:8q16` | `0xd502cec` |
| `SSBookShelfTabSelectViewTitleCell` | `reloadData:` | `v24@0:8@16` | `0xd503f80` |
| `SSBookShelfTabSelectViewTitleCell` | `layoutSubviews` | `v16@0:8` | `0xd50369c` |
| `SSBookShelfTabSelectViewTitleCell` | `updateLabelWithModel:` | `v24@0:8@16` | `0xd504974` |
| `SSBookShelfTabSelectViewTitleCell` | `updateLayoutWithModel:` | `v24@0:8@16` | `0xd505208` |
| `SSBookShelfTabSelectViewTitleCell` | `titleContainerView` | `@16@0:8` | `0xd5064bc` |
| `FQRJXCategoryBaseView` | `collectionView:willDisplayCell:forItemAtIndexPath:` | `v40@0:8@16@24@32` | `0x7f7a400` |

标题同时存在普通和蒙版两个标签。`layoutSubviews` 设置其共同容器的中心。`updateLayoutWithModel:` 读取锚点和缩放模型，在 `0xd50534c` 起重建 Masonry 约束。对应约束 block 从 `0xd50557c` 起构造 `centerX`、`centerY` 和偏移，普通、蒙版标签各有布局分支。原插件的帧修正可能先于 UIKit 提交这批约束和集合视图最终的首帧宽度。冷启动出现一致的偏移，而触发选择后重新布局恢复，这个时序与截图相符。静态分析能确认约束写入位置，UIKit 的首帧提交顺序需要运行时验证。

居中逻辑先让原生 `titleContainerView` 完成自身约束，再把两层标签按胶囊几何居中，保留蒙版 bounds。首帧另由书架专属 `SSBookShelfTabSelectView` 的 `willDisplayCell` 收敛，先执行继承的实现，然后限定同一个书架集合视图和书架标题 cell。hook 核对 Objective-C 方法编码，仅在书架子类添加覆盖，父类及书城使用的其它分类容器继续由宿主管理。

### 验证边界

`audit162/test_top_chrome.py` 的宿主边界模型检查共用模糊、视图顺序、复用、解除吸顶和关闭玻璃后的恢复、书城原有布局。ARM64 离线执行覆盖 hook 的状态和布局变换。像素级颜色混合、首帧布局及真机点击仍需使用实际设备检查。

书架首帧专项在 `audit162/test_shelf_selection178r11.py` 中执行原始委托转发、内层约束提交和两层文字居中。夹具把最终 46 pt 单元中的两层 34 pt 标签设为 x=0，经 `willDisplayCell` 后均为 x=6，验证父类方法实现保持原样。两组专项均通过。

## 7. 阅读工具栏与本地小说导出的宿主分析

### 阅读工具栏的所有权与布局

| 所有者 | 方法 | ARM64 Objective-C 编码 | 静态偏移 | 责任 |
| --- | --- | --- | --- | --- |
| `FQReaderUIManager` | `tabbarItems` | `@16@0:8` | `0x7e3a94c` | 构建阅读底部工具模型 |
| `FQReaderUIManager` | `tabBar` | `@16@0:8` | `0x7e44818` | 提供阅读工具行 |
| `FQReaderSaaSBottomToolView` | `setItems:` | `v24@0:8@16` | `0x7f45cc8` | 写入模型并构建条目视图 |
| `FQReaderSaaSBottomToolView` | `itemViews` | `@16@0:8` | `0x7f469a0` | 原生普通条目集合 |
| `FQReaderSaaSBottomToolView` | `layoutSubviews` | `v16@0:8` | `0x7f44e00` | 确定原生工具行的条目位置 |
| `FQReaderSaaSBottomToolItem` | `type` | `i16@0:8` | `0x7f43d44` | 工具分类，1 为目录，2 为日夜间，3 为设置 |
| `FQReaderSaaSBottomToolItemView` | `onBtnClick:` | `v24@0:8@16` | `0x7f44430` | 原生条目点击路径 |
| `SSReaderBottomToolDivertView` | `layoutSubviews` | `v16@0:8` | `0xea0c864` | 单独布局改编入口的原图标、标题等子视图 |
| `SSReaderBottomToolDivertView` | `onTap:` | `v24@0:8@16` | `0xea0cd24` | 改编入口原生回调 |
| `SSReaderBottomToolDivertView` | `titleLabel` | `@16@0:8` | `0xea0ce04` | 宿主绑定的入口标题 |
| `FQReaderSaaSNewProgressView` | `layoutSubviews` | `v16@0:8` | `0x7f58e68` | 阅读页上一章、下一章和章节滑轨所在的独立布局 |

阅读工具栏同时承载原生条目和另行加入的改编视图。分析 `setItems:` 与 `layoutSubviews` 时可以看到原生条目通过 `itemViews` 处理。改编入口由独立类布局。真机诊断记录了这两个来源在同一行内的实际几何。正常四项排列的中心在约 `x = 67、169、271、373 pt`。前三项的 native frame 是 `24 × 40 pt`，改编入口是 `40 × 40 pt`。旧插件写入的玻璃 frame 分别是 `60 × 44 pt` 和 `76 × 44 pt`。宽度差来自插件此前专门为改编文字预留的额外横向空间。宿主为四项保留的中心与触发逻辑都可以继续复用。

本次实现从工具行实际挂载的直接子视图找出三个已知类型与已显示的改编入口。以 `76 × 44 pt` 为标准，在屏宽和同排中心间距内计算单一宽度。每个胶囊相对原控件中心对齐，工具之间和可用边缘保留 `8 pt`。空间变窄时整行统一缩小。隐藏的改编入口从宽度计算中排除并恢复其装饰状态。只要原布局不给出可用触控空间，原生工具仍然可用。

两条布局路径均先执行原方法，再更新同一工具行的材质。这样宿主首次挂载、改编标题完成更新或旋转后，都使用同一组尺寸。玻璃是不可交互的装饰子视图，位于原生图标和标题后面。原生按钮的图像、标题与回调仍由宿主管理。目录胶囊外侧已有的补充点击仅接收落在胶囊内且由目录项自身接收的触点，再调用宿主 `onBtnClick:`。目标为原图标或标题的触摸继续走原路径。

这一调整以阅读工具行的具体类为作用域。阅读进度滑轨、正文、改编详情页和其它页面复用的类分别保留各自的布局路径。方法签名、复用关系或布局层级变动后应以新宿主重新验证。

### 已下载列表如何绑定到本地正文

| 所有者 | 方法 | ARM64 Objective-C 编码 | 静态偏移 | 观察 |
| --- | --- | --- | --- | --- |
| `HTSServiceCenter` | `+defaultCenter` | `@16@0:8` | `0xa086164` | 全局服务中心入口 |
| `HTSServiceCenter` | `-getService:` | `@24@0:8#16` | `0xa086fe8` | 以 Objective-C Class 作为参数获取服务 |
| `SSDownloadedTabViewController` | `tableView:cellForRowAtIndexPath:` | `@32@0:8@16@24` | `0xe337218` | 复用下载行并写入当前模型 |
| `SSBookDownloadItemCell` | `layoutSubviews` | `v16@0:8` | `0xe36c2bc` | 布局阅读类下载行 |
| `SSBookDownloadItemCell` | `setModel:` | `v24@0:8@16` | `0xe36d2bc` | 切换复用行的数据 |
| `SSBookDownloadItemCell` | `setEditMode:` | `v20@0:8B16` | `0xe36d6c0` | 切换列表编辑态 |
| `SSBookDownloadItemCell` | `manageBtn` | `@16@0:8` | `0xe36d0d8` | 宿主管理按钮的定位参照 |
| `SSBookDownloadManager` | `getAllBookDownloadStatusModels` | `@16@0:8` | `0x7e6783c` | 已下载列表的状态模型来源 |
| `FQReaderSaaSDownloadStatusModel` | `bookId` / `bookName` | `@16@0:8` | `0x7f4ea90` / `0x7f4eaa0` | 书籍 ID 与显示名称，由 `SSBookDownloadStatusModel` 继承 |
| `FQReaderSaaSDownloadStatusModel` | `downloadedItemCount` | `q16@0:8` | `0x7f4eab8` | 显示给用户的已下载数量 |
| `SSBookDownloadTaskManager` | `getDownloadTaskWithBookId:` | `@24@0:8@16` | `0x7e6c498` | 按书籍 ID 获取本地持久化任务 |
| `SSBookDownloadTask` | `finishChapterIds` | `@16@0:8` | `0x7e6bbe4` | 下载任务保存在本地的已完成章节 ID 数组 |
| `FQReaderSaaSBookManager` | `bookWithBookId:` | `@24@0:8@16` | `0x7dda0d8` | 从本地取小说元数据 |
| `FQReaderSaaSBookManager` | `chapterIdsWithBookId:` | `@24@0:8@16` | `0x7ddbe98` | 读本地 protobuf 缓存中的完整章节目录顺序 |
| `FQReaderSaaSBookManager` | `existingChapterContentIdsWithBookId:` | `@24@0:8@16` | `0x7dd4ba8` | 查该书本地正文表并返回章节 ID 集合 |
| `FQReaderSaaSBookManager` | `chapterContentWithBookId:chapterId:` | `@32@0:8@16@24` | `0x7ddbfd8` | 根据本地正文索引加载选中章节 |
| `FQReaderSaaSBookCrypto` | `loadEncryptContent:chapterId:` | `@32@0:8@16@24` | `0x7f3a2f8` | 读取宿主维护的本地正文文件 |

设置中的「导出书籍」通过下载状态服务展示有已下载章节的普通小说。下载列表里的「导出」按钮在真实下载页的阅读行中出现。单元格复用、行重新布局与编辑态变化都重新校验模型和控制器归属。关联对象保存每行的辅助按钮，避免布局重复创建。插件保留宿主「管理」按钮，并依据其实际位置给「导出」留出空间。两个入口最终使用同一导出流程。

显示数量、目录顺序与正文存在性是三个独立条件。宿主的进度辅助方法 `getDownloadChapterIdsWithBookId:chapterIds:` 在处理下载进度时也会纳入部分锁定章节。它的返回值用于描述宿主进度状态，正文可读性仍由本地索引和读取结果决定。导出使用持久化任务的 `finishChapterIds` 来确认用户已完成下载，再按照本地原目录排序。点击「最近 N 章」时只截取这组记录的尾部。整本模式要求目录的每一章都已有完成记录。这样单纯阅读时留下的缓存不会进入导出，未下载的全书末尾也不会挤占用户选择。

完成记录加上正文索引能定位某章，正文文件仍可能缺失或不可读。每一章在后台读取前检查索引，之后检查宿主返回的文本与解析结果。选中的章节出现错误时报告实际目录章号并停止，便于用户定位缺失下载。插件调用宿主本地正文接口，优先取宿主已解析文本，需要时按宿主已有运行时接口解释本地正文对象。ARM64 上该对象的 `cryptStatus` 是 `s16@0:8` 的有符号短整型，`keyVersion` 是 `q16@0:8`，`shouldDecompress` 是 `B16@0:8`。这些签名决定 `objc_msgSend` 的桥接类型以及短整型到宿主参数有符号整数的扩展。导出通路使用本地方法，遇到锁定、缺失或解码失败的正文直接结束本次导出。

序列化在串行后台队列逐章处理。正文解析统一 XML、CDATA、实体和纯文本段落，外部实体解析关闭。TXT、Markdown、HTML、JSON 与 EPUB 使用同一份经过校验的章节表示。EPUB 把 `mimetype` 放在 ZIP 首项并以 stored 方式写入，配套目录、阅读顺序与元数据与正文统一生成。写入使用单次导出的临时目录，完整结束后才交给 iOS 原生分享面板。用户取消或写入失败时清理这次导出的中间文件。

### 复核边界

现有阅读玻璃测试覆盖工具行首次布局、可选改编入口、变窄时统一尺寸、旋转后恢复及目录原生点击转发。宿主桌面静态分析支持类与方法 ABI 的确认。iPhone 上的实际折射、交互命中、宿主下载内容读取和分享流程仍需按对应构建验证。适配新宿主时，从新二进制的 UUID、目标类链、实例方法类型编码及调用者重新核对这组边界。

## 8. 单库加载与适配策略

FanqieX 核心沿用原生运行时边界。导出用 Objective-C ARC 编译，以独立的 Objective-C 类注册入口接入设置和下载列表。最终产物在加载器看来只有一份原生 Mach-O，内含核心构造入口和导出类的非懒加载记录。独立编译阶段的两个输入用于构建，运行时只加载一份 FanqieX。

历史失效的合并库缺少 iOS 对新版 SDK 要求的 `LC_UUID`。本地复核结合 Apple dyld 规则以及原包和新包的真实头部，确认为包体缺陷。现有构建按最终内容生成 UUID，再计算签名页。加载结构审核同时核对段和节的边界与权限、`__LINKEDIT` 范围与对齐、链式重定位的段和目标、构造入口、导出类注册、异常展开和重建后的页哈希。ARM64 离线验证还会从实际成品中读取重定位和构造入口，在不同加载地址执行核心启动。离线执行使用建模的宿主边界。 [Apple dyld Mach-O 检查](https://github.com/apple-oss-distributions/dyld/blob/main/common/MachOAnalyzer.cpp#L292-L308)

### 8.1 新版本复核顺序

| 变化 | 先复核 | 可保留的行为 |
| --- | --- | --- |
| 宿主主程序 UUID 或构建变更 | 实际 IPA 主程序，平台、架构、类表、类型编码和调用者 | 已匹配的局部路径 |
| 短剧新入口或实验布局 | 两套进度视图、各自 gesture delegate、首次命中与 recognizer 挂载位置 | 轨道原生拖动、暂停、进度预览和底栏原生选中 |
| 书架吸顶变化 | 活动子页的浮动容器、列表层次、裁剪链及背景写入 | 分类、筛选、顶部原生交互 |
| 书架首帧变化 | `reloadData:`、标题约束、首次显示回调相对顺序 | 原生普通标题、蒙版、字体和选中态 |
| 阅读工具栏新增按钮 | 实际可见项和原控件中心、长标题、窄屏、编辑和切换 | 每个原控件的动作及内容 |
| 下载模型或数据库变更 | 服务注册、下载记录、目录与本地正文读取的独立条件 | 五种文件格式和原生分享 |

### 8.2 面向真机的验收顺序

1. 完全退出应用后从书架冷启动，首次出现时对比「书架、历史、收藏、圈子」在胶囊里的相对中心。滑过时长区，让「全部、阅读、听书、星标、筛选」吸顶，观察两排之间有无割裂。
2. 从书架拖入短剧。从胶囊内分别向左、向右拖动，预期镜片随手并可切换 tab。随后只在进度轨道拖动，预期出现播放进度预览。
3. 在关闭放大镜开关的情况下首次进入短剧、切换分类并继续刷剧。灰色整行搜索框应保持隐藏。开启按钮时只显示独立搜索入口。
4. 对普通短剧和漫剧分别让「查看全集」出现。播放、暂停、进度条拖动和变粗状态都核对全集下方留白与入口点击。
5. 阅读页底部打开控制工具，观察四个胶囊的尺寸、横向中心和文本。依次触发目录、日夜间、设置、改编剧场。若某本书没有改编入口，再检查剩余工具的统一尺寸。
6. 从设置和「我的下载」各打开一次导出。完整书籍选择整本，部分下载选择最近章，观察错误处理、系统分享与文件内容。

这些验收点对应 7.4.3.33 这份样本。其它宿主构建或系统渲染版本要重新记录实际界面和触摸结果。

## 9. 本地复现命令与输出

以下示例使用已取得的本地 IPA 和从同一归档提取的主执行文件。中间结果按需保存在本地。对外复核使用最上面的两个内容指纹。

```powershell
$ipa = 'path/to/Reading.ipa'
$reading = 'path/to/Reading'
Get-FileHash -Algorithm SHA256 $ipa, $reading
npx -y rea-agents@6.7.0 inspect-artifact $ipa --format json > ipa-evidence.json
llvm-objdump --macho --private-headers $reading
```

从 `ipa-evidence.json` 取 `normalized_result.substeps` 里 `operation = inventory_artifact` 的 `evidence`，组成 `{"inventory_evidence":[...]}` 并保存为 `inventory-input.json`。

```powershell
npx -y rea-agents@6.7.0 project-apple-application-graph inventory-input.json --format json > apple-graph.json
npx -y rea-agents@6.7.0 trace-dylib-resolution 'path/to/staged/Reading.app' --format json > dylib-graph.json
```

已有 Rizin 时也能复查一段按上述映射保存的 ARM64 切片。以搜索创建路径的 60 字节为例。

```powershell
npx -y rea-agents@6.7.0 execute-rizin-command 'search-background-setup.bin' 'e asm.arch=arm; e asm.bits=64; pdj 15'
```

公开记录保留样本指纹、包结构、调用链和汇总结果。原始 IPA、录屏、设备日志和完整反汇编输出只用于本地核对。
