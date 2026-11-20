# FanqieX 1.9.1beta9

## Fixes & Features

1. **Short Drama Progress Bar Right-Overflow & Cold-Start Hug Fix**:
   - Clamped inner track, active progress fill, and thumb/dot views of `FQVShortVideoProgressView` strictly within `[16, railW - 16]` whenever the rail is narrowed to match the bottom Dock width (`FollowWidth`), preventing the 408pt host track from flying past the right edge of the screen (`[72, 873, 408, 2]` on 440pt width).
   - Added immediate + next-frame cold-start layout/spacing synchronization on `FQVShortVideoProgressView` and `FQVShortVideoVPlayerControlView` (`didMoveToWindow`) so the progress bar never hugs the "观看完整漫剧" pill on cold start.
2. **Mine ("我的") Quick-Entry Badge Clipping & Initial Position Alignment Fix**:
   - Replaced hard `clipsToBounds = YES` in `HookScrollFoldLayout` (`SSScrollFoldFuncView` & its horizontal `UICollectionView`) with a dynamic horizontal-only `CALayer` mask (`y - 28`, `h + 56`, tracking `bounds.origin.x` during scroll) so the 6th icon stays horizontally clipped inside the card while top red/orange badges above icons are never beheaded, and ensured badges stay above the circular glass pill.
   - Upgraded `RestoreMinePosition` in `FanqieXCleanup.m` to invalidate layout, reset nested scroll views, and perform a deferred main-queue settle after toggling Mine appearance/card switches so initial opening never requires double-tapping "我的".
3. **Bookshelf "编辑" Button Toggle (`FanqieX.ShelfEditButton.1`)**:
   - Added `隐藏书架编辑按钮` under `书架净化/顶部与统计`, cleanly hiding/restoring `editButton` across `SS525BookShelfSubHeaderView` and `SSBookShelfFunctionCell` with instant refresh.
4. **Mine Side Drawer Individual Toggles (13 Independent Switches under `我的页面净化/侧栏`)**:
   - Added individual hide switches for `我的消息`, `视频创作`, `阅读偏好`, `我的笔记`, `活动中心`, `看过的人`, `番茄指南`, `我的公益`, `会员中心`, `我的签约`, `我的钱包`, `转化记录`, and `底部清单` (`《个人信息清单》《三方信息共享清单》`).
5. **Dock Bar 3-Way Display Mode (`FanqieX.BottomDisplayMode.1`) + iOS Floating Popover Picker**:
   - Added `FQXPopoverPickerController` (iOS floating popover with title and stacked rounded capsule options, anchored to the right value chevron).
   - Added `底栏样式` (`图标与文字` / `仅图标` / `仅文字`) in `外观/玻璃与尺寸` & `页面与导航/底栏入口`, syncing live immediately on the native `UITabBar` Liquid Glass Dock.
6. **Comment Composer 3-Way Style Picker (`FanqieX.CommentComposerStyle.1`)**:
   - Added `发评论输入框样式` popover picker (`原生样式` / `贴底液态玻璃` / `悬浮分离卡片`) in `评论区净化` (+ shortcuts in Short Drama / Reader / Appearance), supporting native Fanqie composer, edge-to-edge bottom-docked Liquid Glass sheet, and CoolApk-style floating detached 4-corner rounded Liquid Glass card hovering cleanly above the keyboard.
