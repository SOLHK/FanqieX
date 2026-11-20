# FanqieX 1.9.1beta6 Repair Notes

## Changes

1. **采用 DYKiller 原生 `UITabBar` 液态玻璃底栏方案 (`native/FanqieXMotion.m`)**
   - 参考 `HierarchThurs/DYKiller`（`DKGlassTabBar.xm`），在 iOS 26/27 上以系统原生 `UITabBar` 替换自定义胶囊滑块，完整获得系统原生 `UIKit._UITabBarPlatterView`、长按玻璃浮现、拖拽折射透镜、原生弹性动效与边界收敛。
   - 沿用 `DKGlassApplyPlatterGlass` 方案将 `platter.glassEffect` 升级为 Clear 清透液态玻璃（保留 `interactive = YES`，深色 30% 黑色染色 / 浅色无染色），严格比较后再写入几何尺寸与图标，不打断系统长按与滑动手势。
   - 完整兼容 FanqieX 现有底栏长度/高度缩放、纯图标/图标+文字模式、图标字号、深浅色自动跟随、隐藏底栏项与短剧自动收缩模式。

2. **彻底修复双击「我的」底栏界面上弹且拉不下来的问题 (`native/FanqieXMotion.m`)**
   - 根因：在顶部玻璃延伸（`adjustedContentInset.top = 106`）下，「我的」列表静止顶部偏移为 `-106`。此前 `HookMineTabBarCurrentTap` 在开启推荐流时放行了宿主 `OrigMineTabBarCurrentTap`，宿主强行将外层 `FQFeedListCollectionView` 偏移设为 `0` 并触发内层 `unlimitedBeginRefreshing:animated:`，导致整页向上顶起 106pt 且下拉手势被内层推荐列表截获无法拉回。
   - 修复：在 `HookMineTabBarCurrentTap`（同时兼容 32/64 位参数签名）与 `HookMineUnlimitedRefresh` 中统一调用 `FQXResetMineScrollToTop`，先复位内层推荐流滚动位置，再平滑将外层列表回到真实顶部 `-adjustedContentInset.top`。
