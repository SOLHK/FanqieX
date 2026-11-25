# FanqieX 1.9.8beta 修复说明

当前版本：`1.9.8beta`（Mach-O 构建标识 `0x15800`，诊断日志版本 `1.9.8beta`）

## 本轮修复内容

### 1. 修复「我的」页快捷入口卡片与下方附着横条（「继续追漫 / 历史外露」等）重叠错位
- **现象与根因**：
  - 宿主 `SSMyUserShortcutCell` 在 `SSScrollFoldFuncView` + `SSFuncLayout` 布局中，通过 `-[SSScrollFoldFuncView attachView:forType:]` 在第 1 页快捷图标下方附着上下文横条（如 `_historyExposedView`「继续追漫 >」、预约/动态/消息外露条），并向 `SSFuncLayout` 写入 `attachmentHeight`，使补充视图（kind `attach`）排布在 `y = itemSize.height + 6.0` 处、整卡高度随之增高。
  - 此前 `FQXUpdateMineFoldFirstPageBand` 直接取整个 `fold.bounds` 的垂直中点（`CGRectGetMidY(card)`）作为首行 4 个圆形快捷按钮的垂直中心，仅避让最底部的分页圆点而忽略了 `attachView` 与 `attachmentHeight`，导致 4 个圆形图标整体下移约 35–40pt，上方出现大片留白并与「继续追漫 >」横条严重重叠。
- **修复方案**：
  - 在 `native/FQXLayoutAndSheetPolicy.h` 新增纯 C11 布局策略 `FQXComputeMineFoldFirstPageBandY`：无附着视图时保持原居中逻辑零回归；存在 `attachView` 或 `attachmentHeight > 0.5` 时，严格以附着视图顶边 / `itemSize.height + 6.0` 为上区底界，将首行布局带约束在附着横条上方 `[max(cardMinY, 0), ceilingY - 2]` 区域内。
  - 在 `native/FanqieXMotion.m` 中更新 `FQXUpdateMineFoldFirstPageBand` 安全读取 `fold.attachView`、`layout.attachmentHeight` 与 `layout.itemSize`，并新增 `POST_HOOK("SSScrollFoldFuncView", "attachView:forType:", ...)` 在附着横条动态挂载或移除时即时更新布局带并失效布局。

### 2. 修复书架「收藏」页关闭「显示『查看短剧浏览历史』卡片」后不生效
- **现象与根因**：
  - 逆向宿主 `SSVideoCollectEmptyCell -updateWithCellStyle:uiConfigParams:`、`SSVideoCollectViewModel -addCellStyleString` 及 `SSVideoCollectViewController -collectionView:didSelectItemAtIndexPath:` 确认：
    - `videoCollectAddCellStyle == 0` 对应 `bookshelf_more_history`（即「查看短剧浏览历史」/「查看漫剧浏览历史」卡片，跳转 `bookshelf_video_history` / `showSubVCForTabType:historyType:`）。
    - `videoCollectAddCellStyle == 1` 对应 `video_goto_bookstore`（即「前往首页」卡片，跳转 `store_video_category`）。
  - 此前 `HookShelfFavoritesDisplayCount` 误将枚举值写反（仅在 `videoCollectAddCellStyle == 1` 时关闭 `includeExtra`），导致「查看短剧浏览历史」（`style == 0`）始终显示。
- **修复方案**：
  - 在 `native/FQXLayoutAndSheetPolicy.h` 新增纯 C11 策略 `FQXShouldHideShelfFavoritesExtraCell(showHistoryCard, addCellStyle)`，明确当关闭历史卡片开关且 `addCellStyle == 0` 时返回抑制。
  - 在 `native/FanqieXMotion.m` 的 `HookShelfFavoritesDisplayCount` 改用该策略修正枚举判断；在 `FQXIsShelfFavoritesController` 增加视图响应者链回退识别 `SSBookShelf525ViewController`；并新增 `POST_HOOK("SSVideoCollectViewController", "viewWillAppear:", ...)` 在进入页面时同步最新策略，避免配置恢复或提前创建控制器导致缓存策略过期。

### 3. 新增短剧左下角弹幕按钮开关（「短剧 › 页面内容 › 显示左下角弹幕按钮」）
- **实现方案**：
  - 在 `native/FanqieXCleanup.m`、`native/FanqieXSettingsMenu.m`、`native/FanqieXSettingsBackup.m` 新增配置项 `FanqieX.DramaShowDanmakuButton.1`（默认开启，位于「短剧 › 页面内容」）。
  - 在 `native/FQXLayoutAndSheetPolicy.h` 新增纯 C11 策略 `FQXShouldShowDramaDanmakuButton(showDanmakuButton, hostWantsDanmaku)`。
  - 在 `native/FanqieXMotion.m` 以 `POST_HOOK` 精准挂钩左下角弹幕入口管理器与视图（`SSShortVideoDanmakuLeftAboveManager -isViewShowing` / `-isCurrentEntranceVisible`、`SSShortVideoAboveLeftContainerViewManager -topActionContainerViewWithDanmaku:followUpdate:landingMute:` / `-orderedAboveLeftViewsForCurrentState`、`SSShortVideoDanmakuLeftAboveView -setHidden:`、`FQCShortVideoDanmakuEntranceView -setHidden:`）：关闭开关后原生移除顶部动作行中的弹幕按钮并自然收起空行，同时完全不干扰弹幕播放引擎（`FQCShortVideoDanmakuController`）与长按倍速面板中的弹幕设置。

### 4. 修复「显示阅读原著」关闭后在剧集播放页与外流推荐页仍显示
- **现象与根因**：
  - 剧集播放页进度条上方的「📖 原著《…》 >」横条由 `SSShortVideoAboveProgressViewManager`（`decideDistributionType == 3`）渲染到 `SSShortVideoBottomDistributionView`，而非仅由 `SSShortVideoRcmdReasonView` 提供；同时既有 `AlignedGlass` 的原著过滤仅覆盖主推荐流（`DramaVisibilityIsMainFeed`）且未在剧集播放页触发即时刷新。
  - 此外，选集底栏（`SSShortVideoTagListBottomInsertView`）、浮层书卡（`SSShortVideoBookCardManager` / `SSShortVideoOutterBookCardManager`）与右侧关联书籍入口（`SSShortVideoRightInteractionRelateBookManager`）均存在独立原著展示路径。
- **修复方案**：
  - 在 `native/FQXLayoutAndSheetPolicy.h` 新增 `FQXResolveDramaAboveProgressDistributionType`（仅当关闭「显示阅读原著」且类型为 `3` 时映射为 `0`，绝不影响类型 `1/2/4/6/9/14` 等「观看完整漫剧 / 追更 / 同类推荐」入口）与 `FQXShouldShowDramaOriginalNovelEntry`。
  - 在 `native/FanqieXMotion.m` 以 `POST_HOOK` 覆盖 `SSShortVideoAboveProgressViewManager`（`decideDistributionType`、`checkCanShowBook`、`checkCanShowNovelRelatedEntrance`、`configDistributionView:`）、`SSShortVideoAboveLeftContainerViewManager -orderedAboveLeftViewsForCurrentState`（同时覆盖剧集播放页与外流推荐页的 `isRelateNovelReason` 胶囊）、`SSShortVideoTagListBottomInsertView`、`SSShortVideoBookCardManager`、`SSShortVideoOutterBookCardManager` 与 `SSShortVideoRightInteractionRelateBookManager`，并在 `NSUserDefaultsDidChangeNotification` 中对已挂载的剧集播放页管理器执行即时刷新。

### 5. 修复「显示作者声明」关闭后在剧集播放页与外流推荐页仍显示
- **现象与根因**：
  - 在设置页切换 `AlignedGlass` 原生开关「显示作者声明」时，既有回调仅刷新主推荐流管理器，未通知剧集播放页的 `SSShortVideoBelowLeftContainerViewManager`；且此前仅挂钩 `shouldAddAiUsageView`、兜底文本扫描深度上限偏浅且未覆盖 `SSShortVideoAiUsageView` 自身状态。
- **修复方案**：
  - 在 `native/FQXLayoutAndSheetPolicy.h` 新增 `FQXShouldShowDramaAuthorDeclaration`。
  - 在 `native/FanqieXMotion.m` 补齐 `POST_HOOK`：`SSShortVideoBelowLeftContainerViewManager -shouldAddAiUsageView` / `-enableShowAiUsageTag`、`SSShortVideoAiUsageView -aiUsageString` / `-setHidden:` / `-layoutSubviews`，扩展兜底扫描直接识别 `SSShortVideoAiUsageView` 与按钮文本叶节点，并在 `NSUserDefaultsDidChangeNotification` 变化时自动触发 `FQXRefreshAllDramaSeriesPills` 与 `FQXRefreshAllDramaControlsInWindows` 即时刷新所有已挂载播放页。

### 6. 设置页版本号弹窗说明同步
- 更新 `native/FanqieXSettingsMenu.m` 左上角版本号点击弹窗的 `1.9.8beta` 更新摘要，并补强「作者声明」「阅读原著」「左下角弹幕按钮」搜索关键词。

## 验证摘要
- 在 `tests/native_layout_sheet_policy_smoke.c` 新增 `FQXComputeMineFoldFirstPageBandY`、`FQXShouldHideShelfFavoritesExtraCell`、`FQXShouldShowDramaDanmakuButton`、`FQXShouldShowDramaAuthorDeclaration`、`FQXResolveDramaAboveProgressDistributionType` 与 `FQXShouldShowDramaOriginalNovelEntry` 单元测试断言，并通过 Clang `-std=c11 -Wall -Wextra -Werror` 编译执行。
- 通过全部 4 项原生 C11 策略单测、11 项 Python 单元测试及 `scripts/verify162.py --version 1.9.8beta` 全量离线构建与仿真验证（双次构建产物字节完全一致）。
