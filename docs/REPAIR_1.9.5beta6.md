# FanqieX 1.9.5beta6 Repair Notes

- Target branch: `test`
- Baseline: `1.9.5beta5` (`e0283f768f0e38db715c3ca7594c964ab5b24bf6`)
- `device_tested`: `false`

## Evidence Analyzed

- Real-device diagnostic JSON (`iOS 27.2 Build 24B119`, Fanqie `7.4.3.33`, `pluginVersion: "1.9.5beta5"`): `871BD784-DA38-4310-9F76-14046EFAEFD4.json`
- Screen recording (`340.mp4`): Short Drama with `看剧` & `漫剧` hidden (`推荐 / 最近 / 收藏` visible) and master toggle off (`显示短剧顶部分类 = OFF`).
- Screenshot 1: Bottom Dock on Short Drama (`402×874`) showing the iOS Home Indicator (`y = 861..865pt`) appearing right along the bottom edge of the Dock (`UITabBar` frame `[58.5, 6.7, 285.1, 68.9]` inside `SSTabBar [0, 800, 402, 74]`, extending down to `y = 875.6pt`).

## Root Causes & Fixes

### 1. Short Drama Hidden Top Tabs & Horizontal Swipe Guard (`native/FanqieXMotion.m`)
- **Root cause**: `AlignedGlass.m` hid cells in `SSHGBookStoreCategoryTitleView` and blocked cell taps, while `FQRJXCategoryListContainerView.scrollView` kept all 5 pages enabled and horizontally scrollable. Swiping left/right therefore still slid into hidden `漫剧` / `看剧` pages or kept switching pages even after turning off `显示短剧顶部分类`.
- **Fix**:
  - Mirrored `AlignedGlass.m`'s exact category visibility rules (`FanqieX.DramaCategories.1`, `FanqieX.DramaWatchTab.1`, `FanqieX.DramaRecentTab.1`, `FanqieX.DramaFavoritesTab.1`, `FanqieX.DramaComicTab.1`, `FanqieX.DramaCategory.<type>.1`).
  - Added `FQXSyncDramaPagerScrollPolicyForFeed` and `FQXDramaVisiblePagerPanController`:
    - When `显示短剧顶部分类` is OFF or `<= 1` visible category exists: `FQRJXCategoryListContainerView.scrollView.scrollEnabled = NO` and step-pan disabled (zero horizontal switching; vertical video swipe unaffected).
    - When all categories are visible (`hiddenCount == 0`): native continuous horizontal `scrollView` stays enabled (`scrollEnabled = YES`).
    - When some sub-categories are hidden (`hiddenCount > 0 && visibleCount >= 2`): disables raw contiguous `scrollView` dragging (so hidden pages never peek or leak video audio) and enables a conflict-free horizontal step-pan gesture that switches directly between adjacent visible tabs while yielding to vertical video swipes, header drags, and sub-page horizontal filter bars.
    - Redirects safely to the first visible category if the pager ever lands on an explicitly hidden sub-tab while the top bar is enabled, and live-syncs on `NSUserDefaultsDidChangeNotification`, `FQRJXCategoryListContainerView.layoutSubviews`, header layouts, and feed appearance.

### 2. Short Drama Top Capsule Width/Font Stability & True Screen Centering (`native/FanqieXMotion.m`)
- **Root cause**:
  - `SSHGBookStoreCategoryTitleView` (`JXCategoryTitleView` subclass) kept `titleLabelZoomEnabled`, `cellWidthZoomEnabled`, `titleLabelStrokeWidthEnabled`, and enlarged `titleSelectedFont` active, causing label font sizes and cell widths to expand/shrink on every swipe frame (and shrinking the entire capsule when passing through hidden tabs).
  - After `FQXDramaCompactLayout` removed `33pt` of dead gap, `AlignedGlass.m` centered against pre-compaction/header-local bounds and `FQXAlignDramaHeaderCapsuleAndSearch` skipped single-tab capsules (`< 60pt`), leaving the capsule visibly off-center from the Dynamic Island axis.
- **Fix**:
  - Added `FQXStabilizeDramaCategoryTabs` / `FQXStabilizeDramaCategoryCellModel` (plus `POST_HOOK`s on `refreshDataSource`, `refreshCellModel:index:`, `refreshSelectedCellModel:unselectedCellModel:`, and `refreshLeftCellModel:rightCellModel:ratio:`, scoped strictly to `SSVideoSeriesFeedHeaderView`), locking zoom scales to `1.0`, disabling zoom/stroke animation, setting `titleLabelAnchorPointStyle = 0`, unifying `titleSelectedFont = titleFont`, and resetting non-identity label transforms.
  - Lowered capsule width guard from `60.0pt` to `40.0pt`, normalized `collectionView.contentOffset.x = 0` when visible items fit, recomputed tight symmetric horizontal capsule bounds around visible compacted cells, and centered `tabContainer` directly against `header.window.bounds` horizontal midpoint (respecting visible search button clearance).

### 3. Bottom Dock Home-Indicator Interference & First-Tap Switch Reliability (`native/FanqieXMotion.m`)
- **Root cause**:
  - `nativeDockBar` (`UITabBar`) rendered at `[58.5, 6.7, 285.1, 68.9]` inside `SSTabBar [0, 800, 402, 74]`, extending `19.6pt` below the visual platter down to `y = 875.6pt` directly over the iOS Home Indicator (`y = 861..865pt`) and past the screen bottom (`874pt`).
  - With the capsule bottom sitting only `5.2pt` above the Home Indicator (`y = 856pt`) on iOS 26/27 (which auto-hides the Home Indicator globally), taps near the lower edge of the Dock could wake the Home Indicator / trigger edge-gesture deferral, stalling or cancelling `UITabBar`'s internal selection gesture so `tabBar:didSelectItem:` never fired on the first tap.
  - `tabBar:didSelectItem:` also bypassed the 3-stage `triggerHostNavigationForHostIndex:` fallback path, and `InstallTabRecovery`'s long-press recognizer (`FanqieXBottomToggles176`, active when `BottomMine` is off) kept default `cancelsTouchesInView = YES`.
- **Fix**:
  - Lifted `nativeDockBar` and `detachedButton` cleanly away from the Home Indicator strip (targeting `>= 22pt` bottom clearance on Face ID devices, capped safely so it never crowds the short-drama progress bar).
  - Updated `HookSSTabBarPointInside` and `HookSSTabBarHitTest` to reject touches below `renderedPlatterMaxY + 3pt`, preventing `nativeDockBar`'s bottom overhang from intercepting Home-Indicator-zone touches.
  - Stripped `UIRectEdgeBottom` from `preferredScreenEdgesDeferringSystemGestures` on portrait `SSVideoSeriesFeedViewController`, `FQVShortVideoListViewController`, and `SSTabBarController` whenever the Dock is visible (leaving landscape fullscreen untouched), and set `InstallTabRecovery`'s recognizer `cancelsTouchesInView = NO`.
  - Routed `tabBar:didSelectItem:` through `triggerHostNavigationForHostIndex:` and added a simultaneous `UITapGestureRecognizer` (`dockTapRescueGesture`) on `nativeDockBar` that rescues any edge-cancelled first tap within `35ms` without interfering with fluid drag selection or double-firing.

## Protected Files

- `native/AlignedGlass.m`: untouched
- `native/AlignedGlass.s`: untouched
- `native/FQXBlurControl.h`: untouched
