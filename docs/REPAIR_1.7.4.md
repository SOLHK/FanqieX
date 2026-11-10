# FanqieX 1.7.4 · test

## 范围

本次以 `test` 的 `3f60ead` 为起点，针对番茄小说 7.4.3（`com.dragon.read` /
`7.4.3.33`）完成：

- 阅读页：本章讨论入口、礼物入口、右侧“听”、底部章节进度、目录、夜间、设置、改编剧场；
- 书架：全部、阅读、听书、星标四个分类入口；
- 个人页：顶部搜索栏，我的订单、浏览历史、我的消息、创作中心、我的预约；
- 个人页第三人称游戏推广卡“羊了个羊：星球”精准移除；
- 底栏“短句”和“商城”的独立显示开关。

所有玻璃均使用现有 `AlignedGlass.m` 原生引擎：`UIGlassEffect` Regular +
`UICornerConfiguration` capsule。iOS 27 原生 API 可用时启用；不可用时直接恢复宿主，
不伪造矩形遮罩。每个入口都是精确类 Hook，不使用全局 `UIView` 布局 Hook。

## 逆向材料核对

`番茄小说_7.4.3.ipa_Decompiler.com 3.zip` 的实际 SHA-256 为
`b09aa914960b77097190bcb7d5a769dc00460f46bd339172d510f203145ba5c3`。

ZIP 包含 101,166 个条目：97,348 个重建 Header、3,812 个 App 资源/二进制、
Info.plist、entitlements、frameworks 清单、Mach-O 摘要和 Swift 元数据列表。
**不包含**传统 class-dump、方法体或 ARM64 反汇编清单。

已核对：

| 项目 | 实际值 |
| --- | --- |
| Bundle ID | `com.dragon.read` |
| CFBundleVersion | `7.4.3.33` |
| CFBundleShortVersionString | `7.4.3` |
| 主程序 | `Reading`，arm64，MH_EXECUTE |
| UUID | `BEE37D93-3E70-332F-98F1-20890F02BB12` |
| 加密 | `cryptid = 0` |
| 最低系统 | iOS 15.0.1 |
| 宿主构建 SDK | iOS 26.0，`UIDesignRequiresCompatibility = true` |

因此原有 `com.dragon.read` / `7.4.3.33` 兼容检查继续有效，但没有沿用“ZIP 里有反汇编”的假设。
完整证据边界见 [REVERSE_ARCHIVE_174_EVIDENCE.json](REVERSE_ARCHIVE_174_EVIDENCE.json)。

## 液态玻璃实现

### 阅读页

| 控件 | 真实类 | 处理 |
| --- | --- | --- |
| 本章讨论 | `SSReaderChapterEndDiscussionEntranceView` / `...Button` | 精确类 `layoutSubviews`，完整入口 bounds 内插入被动材质 |
| 礼物 | `SSReaderGiftView.giftButton`、`SSReaderBookEndUserGiftView` | 只装饰礼物入口，不覆盖整段榜单 |
| 听 | `SSReaderFloatingCommonButton` | 沿用 1.7.1 的圆形材质与语义前景色 |
| 进度滑块 | `FQReaderSaaSNewProgressView.slider` | 玻璃放入滑块 bounds，保留拖动与长按手势 |
| 目录/夜间/设置/改编剧场 | `SSReaderBottomToolButton` | 整颗按钮 bounds 玻璃，图标/文字仍由宿主绘制 |

### 书架与个人页

- `SSBookShelfTabSelectViewTitleCell`：四个分类 cell 各自使用完整 bounds 玻璃；选中态通过玻璃 tint 表达，`hasSelected` 与切换动画仍由宿主拥有。
- `SSMyUserBar.searchBgView`：搜索容器内单层玻璃，不改变输入框、轮播词或点击链。
- `SSMyUserCollectionViewFunCell` / `SSMyUser621FunctionEntryItemCell`：只在标题精确为“我的订单 / 浏览历史 / 我的消息 / 创作中心 / 我的预约”时启用；其他入口恢复宿主原状，避免误判广告或误改容器。

所有材质在插入前完成 frame、胶囊、透明背景、无交互和无障碍隐藏设置；优先复用同一个
`UIVisualEffectView`，重复布局不重写 frame。关闭玻璃键
`FanqieAdBlock.GlassDisabled.1` 后移除材质并恢复宿主背景/裁剪状态。

## “羊了个羊：星球”广告

宿主二进制中没有“羊了个羊”字面量，说明该卡片标题由服务端下发。ZIP 的类关系指向：

1. `SSMyUser621BaseViewController setupCellMiniGameEntranceData` 创建个人页小游戏卡；
2. 数据模型为 `SSMyUserMiniGameEntranceCellModel`，标题在 `SSSSTimorCellInfo.title/name`；
3. 视图为 `SSMyUserMiniGameEntranceCell`（titleLabel/textLabel/tagLabel/playButton）；
4. 卡片进入 `SSMyUser621BaseViewController.models` 后由列表适配器创建 Cell。

本版在 `setupCellMiniGameEntranceData` 返回后检查该模型的精确标题/前缀，命中后对模型设置
`isInvisible`、`isDisabled`，并从可变 `models` 计划中移除该对象，再交给列表适配器。
删除的是数据项本身，不是隐藏父容器或留空 Cell；非目标游戏和其他快捷入口不受影响（专项测试）。

## 底栏开关

- 默认键：`FanqieX.BottomShortSentences.1`、`FanqieX.BottomMall.1`，默认开启。
- 设置页表头新增两个真实 `UISwitch`，文案“底栏显示：短句 / 商城”。
- `SSTabBar setItems:` / `setItems:animated:` 精确 Hook，按 `SSTabBarButtonItem.title` 过滤；保留未命中的 Tab。
- 切换后遍历当前窗口中的 `SSTabBar` 立即重算；原始 item 数组保存在 Associated Object 中，重新开启可恢复。
- 关闭当前正在显示的“短句/商城”时，由 `SSTabBar` 自身重选首项，不修改宿主点击回调。

## 验证边界

- 本地验证执行实际候选 ARM64 指令，UIKit/Foundation/CA 使用显式边界模型；
- 新增 `page-glass174` 覆盖材质复用、关闭恢复、四类页面入口、目标广告删除、正常内容保留、底栏开关；
- 既有回归继续覆盖布局、触摸、主题、重复布局、Hook 所有权、ARM64 指令与签名页哈希；
- **未在 iPhone 上注入，未做真实 UIKit 像素渲染/GPU 折射/触感测试**。构建和模型通过不等于实机验收；
- Xcode 27.2 / iOS 27.2 SDK 的云端构建结果以 GitHub Actions 实际记录为准。

本地冻结源码验证共 39 步，候选 SHA-256：
`001d98496a6665f7e263e750b01a94155ff0d4d8740228208651a8e2a59e079d`，
大小 222,352 字节。该候选由 Windows LLVM Clang 23.1.5 组装，属于非 Apple 工作站的
等价构建检查；Apple 发布工具链构建需以同一提交的 Xcode 27.2 Actions 记录为准。

## 安装

移除旧 FanqieX / FanqieAdBlock 动态库，再注入本包并重新签名；同一 App 只加载一份。
`.dylib` 不是可独立安装的 App。只更新 `test`，不修改 `main`。
