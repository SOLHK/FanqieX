#import <UIKit/UIKit.h>
#import <objc/message.h>
#import <objc/runtime.h>

static const void *MenuKey = &MenuKey;
static const void *RowKey = &RowKey;
static NSString *const CompactKey = @"FanqieX.BottomDramaCompact.1";
static NSString *const FollowWidthKey = @"FanqieX.DramaFollowBottomWidth.1";
static NSString *const CommentMaterialStyleKey = @"FanqieX.CommentMaterialStyle.1";
static NSString *const CommentAppearanceModeKey = @"FanqieX.CommentAppearanceMode.1";
static NSString *const CommentComposerStyleKey = @"FanqieX.CommentComposerStyle.1";
static NSString *const BottomDisplayModeKey = @"FanqieX.BottomDisplayMode.1";
static NSString *const BottomIconsOnlyLegacyKey = @"FanqieX.BottomIconsOnly.1";

static id Invoke(id receiver, NSString *name) {
    SEL selector = NSSelectorFromString(name);
    return [receiver respondsToSelector:selector] ? ((id (*)(id, SEL))objc_msgSend)(receiver, selector) : nil;
}

static NSString *Fold(NSString *text) {
    NSString *simple = [text stringByApplyingTransform:@"Traditional-Simplified" reverse:NO];
    return [[simple ?: text lowercaseString] stringByFoldingWithOptions:NSDiacriticInsensitiveSearch | NSWidthInsensitiveSearch
        locale:[NSLocale localeWithLocaleIdentifier:@"zh_CN"]];
}

static NSString *SearchText(NSString *text) {
    NSString *normalized = Fold(text);
    // Normalize wording before matching, including queries without spaces.
    for (NSArray *pair in @[@[@"看听读时长", @"阅读时长"], @[@"听读时长", @"阅读时长"],
                           @[@"朗读", @"听书"], @[@"语音", @"听书"],
                           @[@"dock栏", @"底栏"], @[@"dock", @"底栏"], @[@"底部栏", @"底栏"], @[@"tabbar", @"底栏"], @[@"导航栏", @"底栏"],
                           @[@"液态玻璃", @"玻璃"], @[@"毛玻璃", @"高斯模糊"], @[@"磨砂", @"高斯模糊"],
                           @[@"黑夜", @"深色"], @[@"暗黑", @"深色"], @[@"深色模式", @"深色"],
                           @[@"白天", @"浅色"], @[@"日间", @"浅色"], @[@"浅色模式", @"浅色"],
                           @[@"看书", @"阅读"], @[@"读书", @"阅读"], @[@"小说", @"阅读"],
                           @[@"剧评", @"评论"], @[@"段评", @"评论"], @[@"章评", @"评论"], @[@"评价", @"评论"],
                           @[@"屏蔽", @"拦截"], @[@"去除", @"拦截"], @[@"去广告", @"广告"],
                           @[@"震动", @"振动"], @[@"触感", @"振动"],
                           @[@"自动翻页", @"自动阅读"], @[@"动态漫", @"漫剧"],
                           @[@"改编剧场", @"改编剧"], @[@"发布", @"发帖"],
                           @[@"推荐卡片", @"推荐内容"], @[@"送礼物", @"送礼"],
                           @[@"折叠", @"收缩"], @[@"收起", @"收缩"],
                           @[@"保存", @"导出"], @[@"下载", @"导出"]])
        normalized = [normalized stringByReplacingOccurrencesOfString:pair[0] withString:pair[1]];
    for (NSString *word in @[@"隐藏", @"显示", @"关闭", @"开启", @"去掉", @"打开", @"按钮", @"入口", @"页面", @"界面", @"功能"])
        normalized = [normalized stringByReplacingOccurrencesOfString:word withString:@""];
    return normalized;
}

static NSInteger MatchScore(NSString *folded, NSString *normalized) {
    NSInteger score = 0;
    for (NSString *word in [normalized componentsSeparatedByCharactersInSet:NSCharacterSet.whitespaceAndNewlineCharacterSet]) {
        if (!word.length) continue;
        if ([folded containsString:word]) { score += 100; continue; }
        NSUInteger matched = 0;
        for (NSUInteger i = 0; i < folded.length && matched < word.length; ++i)
            if ([folded characterAtIndex:i] == [word characterAtIndex:matched]) ++matched;
        if (matched != word.length) return -1;
        score += 10;
    }
    return score;
}

@interface FQXSettingRow : NSObject
@property(nonatomic, copy) NSString *title;
@property(nonatomic, copy) NSString *originalTitle;
@property(nonatomic, copy) NSString *path;
@property(nonatomic, copy) NSString *keywords;
@property(nonatomic, copy) NSString *searchText;
@property(nonatomic, copy) NSString *searchTitle;
@property(nonatomic, strong) UIView *content;
@property(nonatomic, strong) UITableViewCell *nativeCell;
@property(nonatomic, strong) UISwitch *originalToggle;
@property(nonatomic, copy) NSDictionary *option;
@property(nonatomic, copy) NSString *destination;
@property(nonatomic, copy) NSArray<NSDictionary *> *actions;
@property(nonatomic) CGFloat height;
@property(nonatomic) BOOL requiresCompact;
@property(nonatomic) BOOL inverted;
@property(nonatomic) BOOL diagnosticExport;
@property(nonatomic) BOOL authorInformation;
@property(nonatomic) BOOL hiddenFromSearch;
@property(nonatomic) NSInteger commentMaterialChoice;
@property(nonatomic) BOOL commentAppearanceRow;
@property(nonatomic, copy) NSString *popoverKey;
@property(nonatomic, copy) NSArray<NSString *> *popoverOptions;
@property(nonatomic) NSInteger popoverKind;
@property(nonatomic) NSInteger matchScore;
@end
@implementation FQXSettingRow
@end

@interface FQXPopoverPickerController : UIViewController <UIPopoverPresentationControllerDelegate>
@property(nonatomic, copy) NSString *pickerTitle;
@property(nonatomic, copy) NSArray<NSString *> *options;
@property(nonatomic) NSInteger selectedIndex;
@property(nonatomic, copy) void (^onSelect)(NSInteger index);
@end

@implementation FQXPopoverPickerController

- (UIModalPresentationStyle)adaptivePresentationStyleForPresentationController:(UIPresentationController *)controller {
    (void)controller;
    return UIModalPresentationNone;
}

- (UIModalPresentationStyle)adaptivePresentationStyleForPresentationController:(UIPresentationController *)controller
                                                               traitCollection:(UITraitCollection *)traitCollection {
    (void)controller; (void)traitCollection;
    return UIModalPresentationNone;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = UIColor.clearColor;
    UILabel *titleLabel = [UILabel new];
    titleLabel.text = self.pickerTitle;
    titleLabel.textAlignment = NSTextAlignmentCenter;
    titleLabel.font = [UIFont systemFontOfSize:16.0 weight:UIFontWeightSemibold];
    titleLabel.textColor = UIColor.labelColor;
    titleLabel.numberOfLines = 2;
    titleLabel.accessibilityTraits |= UIAccessibilityTraitHeader;

    UIStackView *stack = [[UIStackView alloc] initWithArrangedSubviews:@[titleLabel]];
    stack.axis = UILayoutConstraintAxisVertical;
    stack.spacing = 8.0;
    [stack setCustomSpacing:12.0 afterView:titleLabel];
    stack.translatesAutoresizingMaskIntoConstraints = NO;
    [self.view addSubview:stack];
    UILayoutGuide *area = self.view.safeAreaLayoutGuide;
    [NSLayoutConstraint activateConstraints:@[
        [stack.leadingAnchor constraintEqualToAnchor:area.leadingAnchor constant:14.0],
        [stack.trailingAnchor constraintEqualToAnchor:area.trailingAnchor constant:-14.0],
        [stack.topAnchor constraintEqualToAnchor:area.topAnchor constant:14.0],
        [stack.bottomAnchor constraintLessThanOrEqualToAnchor:area.bottomAnchor constant:-14.0]
    ]];

    for (NSUInteger i = 0; i < self.options.count; ++i) {
        UIButton *button = [UIButton buttonWithType:UIButtonTypeSystem];
        button.tag = (NSInteger)i;
        BOOL selected = ((NSInteger)i == self.selectedIndex);
        NSString *label = selected ? [self.options[i] stringByAppendingString:@"  ✓"] : self.options[i];
        [button setTitle:label forState:UIControlStateNormal];
        [button setTitleColor:UIColor.labelColor forState:UIControlStateNormal];
        button.titleLabel.font = [UIFont systemFontOfSize:15.0 weight:(selected ? UIFontWeightSemibold : UIFontWeightMedium)];
        button.backgroundColor = selected ? UIColor.secondarySystemFillColor : UIColor.tertiarySystemFillColor;
        button.layer.cornerRadius = 22.0;
        button.layer.cornerCurve = kCACornerCurveContinuous;
        if (selected) button.accessibilityTraits |= UIAccessibilityTraitSelected;
        [button addTarget:self action:@selector(optionTapped:) forControlEvents:UIControlEventTouchUpInside];
        [stack addArrangedSubview:button];
        [[button.heightAnchor constraintEqualToConstant:44.0] setActive:YES];
    }
}

- (void)optionTapped:(UIButton *)sender {
    NSInteger idx = sender.tag;
    void (^handler)(NSInteger) = self.onSelect;
    [self dismissViewControllerAnimated:YES completion:^{
        if (handler) handler(idx);
    }];
}

@end

@interface FQXSettingsMenu : UITableViewController <UISearchResultsUpdating>
@property(nonatomic, strong) NSMutableArray<FQXSettingRow *> *catalog;
@property(nonatomic, copy) NSArray<FQXSettingRow *> *visibleRows;
@property(nonatomic, copy) NSArray<NSString *> *folders;
@property(nonatomic, copy) NSString *path;
@property(nonatomic, strong) UISearchController *search;
@property(nonatomic, weak) UIViewController *settingsOwner;
@property(nonatomic, strong) id router;
@property(nonatomic, strong) UIViewController *adsOwner;
@property(nonatomic) BOOL diagnosticExportPending;
@property(nonatomic, strong) NSURL *diagnosticFile;
@property(nonatomic, copy) NSString *diagnosticError;
+ (void)installOnController:(UIViewController *)owner router:(id)router ads:(UIViewController *)ads;
+ (UIViewController *)controllerForController:(UIViewController *)owner;
+ (UIViewController *)visibleControllerForController:(UIViewController *)owner;
+ (BOOL)refreshOnController:(UIViewController *)owner;
+ (BOOL)isInstalledOnController:(UIViewController *)owner;
- (void)configureSearch;
- (BOOL)updateRows;
- (void)beginDiagnosticExport;
- (void)shareDiagnosticFile;
- (void)fqab_156_presentDiagnostics:(NSDictionary *)result;
@end

static FQXSettingsMenu *MenuForController(UIViewController *owner) {
    id linked = objc_getAssociatedObject(owner, MenuKey);
    return [linked isKindOfClass:NSHashTable.class] ? [linked anyObject] : linked;
}

static NSString *ControlTitle(UIView *view) {
    if ([view isKindOfClass:UIButton.class]) return [(UIButton *)view titleForState:UIControlStateNormal] ?: view.accessibilityLabel;
    for (UIView *child in view.subviews) {
        if ([child isKindOfClass:UILabel.class] && [(UILabel *)child text].length) return [(UILabel *)child text];
    }
    return view.accessibilityLabel ?: @"";
}

static NSString *PathForTitle(NSString *group, NSString *title) {
    if ([title isEqualToString:@"Telegram 频道"]) return @"";
    if ([group isEqualToString:@"底栏入口"]) return @"页面与导航/底栏入口";
    if ([group isEqualToString:@"短剧播放"]) {
        if ([title containsString:@"分类"] || [title isEqualToString:@"显示短剧右上角搜索按钮"]) return @"短剧/顶部分类";
        if ([title containsString:@"收缩"] || [title containsString:@"跟随底栏长度"]) return @"短剧/底栏收缩";
        if ([title containsString:@"显示作者"] || [title containsString:@"显示阅读原著"] ||
            [title containsString:@"兴趣推荐"]) return @"短剧/页面内容";
        return @"短剧/播放设置";
    }
    if ([title containsString:@"导出书籍"]) return @"导出与备份";
    if ([title containsString:@"书架"]) return [title containsString:@"漫剧"] ? @"书架净化/推荐与导入" : @"书架净化/顶部与统计";
    if ([title containsString:@"侧栏"]) return @"我的页面净化/侧栏";
    if ([title containsString:@"我的"]) return @"我的页面净化/内容卡片";
    if ([title containsString:@"去赚更多"]) return @"阅读/阅读页面净化/正文与底栏";
    if ([group isEqualToString:@"阅读与书架"]) return @"阅读/阅读设置";
    if ([title containsString:@"默认启动"] || [title containsString:@"书城顶部"]) return @"页面与导航";
    if ([title containsString:@"备份"]) return @"导出与备份";
    if ([title containsString:@"外观"] || [title containsString:@"液态玻璃"]) return @"外观/玻璃与尺寸";
    return @"诊断与其他";
}

static void AddView(FQXSettingsMenu *menu, UIView *view, NSString *group) {
    NSString *title = [ControlTitle(view) stringByReplacingOccurrencesOfString:@"  ›" withString:@""];
    if (!title.length || [title isEqualToString:@"诊断与日志"] || [title isEqualToString:@"广告与福利"] ||
        [title isEqualToString:@"Telegram 频道"] || [title containsString:@"本地激励"] ||
        [title containsString:@"测试激励"] || [title containsString:@"评论区模糊液态玻璃"] ||
        [title isEqualToString:@"底栏仅显示图标"] || [title isEqualToString:@"底栏纯图标"]) return;
    FQXSettingRow *row = [FQXSettingRow new];
    row.title = title;
    row.originalTitle = title;
    row.path = PathForTitle(group, title);
    if (!row.path.length) return;
    row.keywords = [NSString stringWithFormat:@"%@ %@ %@", title, row.path, view.accessibilityIdentifier ?: @""];
    for (UIView *child in view.subviews) {
        if ([child isKindOfClass:UISwitch.class]) {
            row.keywords = [row.keywords stringByAppendingString:@" 显示 隐藏 开启 关闭 开关"];
            if (([row.path hasPrefix:@"书架净化/"] || [row.path hasPrefix:@"我的页面净化/"] ||
                 [row.path hasPrefix:@"阅读/阅读页面净化/"]) && [title containsString:@"显示"]) {
                row.originalToggle = (UISwitch *)child;
                row.inverted = YES;
                row.title = [title stringByReplacingOccurrencesOfString:@"显示" withString:@"隐藏"];
            }
            break;
        }
    }
    row.content = row.originalToggle ? nil : view;
    row.height = row.originalToggle ? 52 : MAX(52, CGRectGetHeight(view.bounds));
    row.requiresCompact = [title containsString:@"收缩位置"];
    if ([title containsString:@"自动收缩"]) row.keywords = [row.keywords stringByAppendingString:@" 缩小 收起 折叠 底栏 dock 胶囊"];
    if ([title containsString:@"跟随底栏长度"]) row.keywords = [row.keywords stringByAppendingString:@" 查看全集 观看完整漫剧 进度条 底栏长度 胶囊长度 自动跟随 宽度"];
    if ([title containsString:@"时长"]) row.keywords = [row.keywords stringByAppendingString:@" 书架今日听读时长 阅读统计"];
    if ([title containsString:@"底栏"]) row.keywords = [row.keywords stringByAppendingString:@" dock dock栏 底部栏 导航栏 胶囊 图标 尺寸 大小 长度 高度"];
    if ([title containsString:@"纯图标"]) row.keywords = [row.keywords stringByAppendingString:@" 无文字 隐藏文字 仅图标 图标模式"];
    if ([title containsString:@"画质"]) row.keywords = [row.keywords stringByAppendingString:@" 1080p 清晰度 超清 蓝光 最高画质 视频"];
    if ([title containsString:@"清屏"]) row.keywords = [row.keywords stringByAppendingString:@" 纯净 隐藏界面 无遮挡 沉浸"];
    if ([title containsString:@"横屏"] || [title containsString:@"铺满"]) row.keywords = [row.keywords stringByAppendingString:@" 全屏 裁切 放大 黑边 视频"];
    if ([title containsString:@"主题"] || [title containsString:@"隔离"]) row.keywords = [row.keywords stringByAppendingString:@" 深色 浅色 夜间 日间 护眼 背景"];
    if ([title containsString:@"备份"] || [title containsString:@"导入"] || [title containsString:@"导出"]) row.keywords = [row.keywords stringByAppendingString:@" 备份 恢复 迁移 配置 设置 JSON TXT EPUB"];
    if ([title containsString:@"启动"]) row.keywords = [row.keywords stringByAppendingString:@" 默认页 首页 书架 短剧 书城 冷启动"];
    if ([title containsString:@"分类"]) row.keywords = [row.keywords stringByAppendingString:@" 顶部分类 顶部胶囊 推荐 看剧 漫剧 最近 收藏 频道"];
    if ([title containsString:@"玻璃"]) row.keywords = [row.keywords stringByAppendingString:@" 液态玻璃 毛玻璃 透明 材质 外观"];
    [menu.catalog addObject:row];
}

static NSInteger CurrentSavedCommentMaterialStyle(void) {
    NSUserDefaults *ud = NSUserDefaults.standardUserDefaults;
    if ([ud objectForKey:@"FanqieX.CommentGlassFrosted.1"]) [ud removeObjectForKey:@"FanqieX.CommentGlassFrosted.1"];
    if ([ud objectForKey:@"FanqieX.CommentMaterialMode.1"]) [ud removeObjectForKey:@"FanqieX.CommentMaterialMode.1"];
    id stored = [ud objectForKey:CommentMaterialStyleKey];
    if (!stored) return 0;
    NSInteger val = [stored respondsToSelector:@selector(integerValue)] ? [stored integerValue] : 0;
    return (val >= 0 && val <= 2) ? val : 0;
}

static NSInteger CurrentSavedCommentAppearanceMode(void) {
    id stored = [NSUserDefaults.standardUserDefaults objectForKey:CommentAppearanceModeKey];
    if (!stored) return 0;
    NSInteger val = [stored respondsToSelector:@selector(integerValue)] ? [stored integerValue] : 0;
    return (val >= 0 && val <= 2) ? val : 0;
}

static NSInteger CurrentSavedBottomDisplayMode(void) {
    NSUserDefaults *ud = NSUserDefaults.standardUserDefaults;
    id stored = [ud objectForKey:BottomDisplayModeKey];
    if (stored && [stored respondsToSelector:@selector(integerValue)]) {
        NSInteger val = [stored integerValue];
        if (val >= 0 && val <= 2) return val;
    }
    return [ud boolForKey:BottomIconsOnlyLegacyKey] ? 1 : 0;
}

static NSInteger CurrentSavedCommentComposerStyle(void) {
    NSUserDefaults *ud = NSUserDefaults.standardUserDefaults;
    id stored = [ud objectForKey:CommentComposerStyleKey];
    if (stored && [stored respondsToSelector:@selector(integerValue)]) {
        NSInteger val = [stored integerValue];
        if (val >= 0 && val <= 2) return val;
    }
    return CurrentSavedCommentMaterialStyle() > 0 ? 1 : 0;
}

static void AddDockDisplayStyleRow(FQXSettingsMenu *menu, NSString *route, BOOL hiddenFromSearch) {
    FQXSettingRow *dockModeRow = [FQXSettingRow new];
    dockModeRow.title = @"底栏样式";
    dockModeRow.path = route;
    dockModeRow.hiddenFromSearch = hiddenFromSearch;
    dockModeRow.keywords = @"底栏样式 底栏 dock dock栏 仅图标 只显示图标 仅文字 只显示文字 图标与文字 图文 纯图标 无文字 导航栏 样式";
    dockModeRow.popoverKey = BottomDisplayModeKey;
    dockModeRow.popoverOptions = @[@"图标与文字", @"仅图标", @"仅文字"];
    dockModeRow.popoverKind = 1;
    dockModeRow.height = 52;
    [menu.catalog addObject:dockModeRow];
}

static void AddCommentStyleRows(FQXSettingsMenu *menu, NSString *route, BOOL hiddenFromSearch) {
    FQXSettingRow *glassRow = [FQXSettingRow new];
    glassRow.title = @"评论区液态玻璃";
    glassRow.path = route;
    glassRow.hiddenFromSearch = hiddenFromSearch;
    glassRow.keywords = @"评论区 评价 短剧评论 看书评论 小说评论 段评 液态玻璃 液态玻璃评论区 评论液态玻璃 材质 透明 玻璃";
    glassRow.commentMaterialChoice = 1;
    glassRow.height = 52;
    [menu.catalog addObject:glassRow];

    FQXSettingRow *blurRow = [FQXSettingRow new];
    blurRow.title = @"评论区高斯模糊";
    blurRow.path = route;
    blurRow.hiddenFromSearch = hiddenFromSearch;
    blurRow.keywords = @"评论区 评价 短剧评论 看书评论 小说评论 段评 高斯模糊 高斯模糊评论区 毛玻璃 磨砂 iOS18 材质";
    blurRow.commentMaterialChoice = 2;
    blurRow.height = 52;
    [menu.catalog addObject:blurRow];

    FQXSettingRow *appearanceRow = [FQXSettingRow new];
    appearanceRow.title = @"评论区外观";
    appearanceRow.path = route;
    appearanceRow.hiddenFromSearch = hiddenFromSearch;
    appearanceRow.keywords = @"评论区 外观 浅色 深色 浅色深色 夜间模式 日间模式 跟随软件 独立 主题 颜色 背景 评论区深浅";
    appearanceRow.commentAppearanceRow = YES;
    appearanceRow.height = 52;
    [menu.catalog addObject:appearanceRow];

    FQXSettingRow *composerRow = [FQXSettingRow new];
    composerRow.title = @"发评论输入框样式";
    composerRow.path = route;
    composerRow.hiddenFromSearch = hiddenFromSearch;
    composerRow.keywords = @"发评论 评论 输入框 键盘 样式 原生 贴底 液态玻璃 悬浮 分离 分离式 卡片 酷安 写评论 回复";
    composerRow.popoverKey = CommentComposerStyleKey;
    composerRow.popoverOptions = @[@"原生样式", @"贴底液态玻璃", @"悬浮分离卡片"];
    composerRow.popoverKind = 2;
    composerRow.height = 52;
    [menu.catalog addObject:composerRow];
}

@implementation FQXSettingsMenu

+ (void)installOnController:(UIViewController *)owner router:(id)router ads:(UIViewController *)ads {
    if (MenuForController(owner)) return;
    UITableView *legacy = Invoke(owner, @"tableView");
    if (!legacy) return;
    FQXSettingsMenu *menu = [[self alloc] initWithStyle:UITableViewStyleInsetGrouped];
    menu.catalog = [NSMutableArray array];
    menu.settingsOwner = owner;
    menu.router = router;
    menu.adsOwner = ads;
    menu.path = @"";
    UIView *legacyHeader = legacy.tableHeaderView;
    UIView *legacyFooter = legacy.tableFooterView;
    for (UIView *group in legacyHeader.subviews) {
        if ([group isKindOfClass:UISearchBar.class]) continue;
        NSString *title = ControlTitle(group);
        for (NSUInteger index = 1; index < group.subviews.count; ++index) AddView(menu, group.subviews[index], title);
    }
    // Keep native ad/glass controls and their original target/selection actions.
    for (UITableViewController *page in @[(id)owner, (id)ads]) {
        [page loadViewIfNeeded];
        NSInteger sections = [page numberOfSectionsInTableView:page.tableView];
        for (NSInteger section = 0; section < sections; ++section) {
            NSString *group = [page tableView:page.tableView titleForHeaderInSection:section] ?: @"";
            NSInteger count = [page tableView:page.tableView numberOfRowsInSection:section];
            for (NSInteger index = 0; index < count; ++index) {
                NSIndexPath *path = [NSIndexPath indexPathForRow:index inSection:section];
                UITableViewCell *cell = [page tableView:page.tableView cellForRowAtIndexPath:path];
                NSString *title = cell.textLabel.text ?: ((UIListContentConfiguration *)cell.contentConfiguration).text;
                if (!title.length || [title containsString:@"评论区模糊液态玻璃"] ||
                    [title isEqualToString:@"Telegram 频道"]) continue;
                FQXSettingRow *row = [FQXSettingRow new];
                row.title = title;
                row.path = page == (id)owner ? @"外观/玻璃效果" : [@"广告与福利/" stringByAppendingString:group];
                row.keywords = [NSString stringWithFormat:@"%@ %@ 广告 拦截", row.path, title];
                row.nativeCell = cell;
                row.height = 52;
                [menu.catalog addObject:row];
            }
        }
    }
    // Add Dock 3-way display style popover picker (Icons+Text / Icons Only / Text Only)
    AddDockDisplayStyleRow(menu, @"外观/玻璃与尺寸", NO);
    AddDockDisplayStyleRow(menu, @"页面与导航/底栏入口", YES);

    // Add Comment Material toggles (Liquid Glass / Gaussian Blur, mutually exclusive, both off = native),
    // standalone Comment Appearance selector (Follow App / Light / Dark), and Composer Style popover.
    AddCommentStyleRows(menu, @"评论区净化", NO);
    AddCommentStyleRows(menu, @"短剧/播放设置", YES);
    AddCommentStyleRows(menu, @"阅读/阅读设置", YES);
    AddCommentStyleRows(menu, @"外观/玻璃效果", YES);

    NSArray *options = Invoke(NSClassFromString(@"FQXCleanup"), @"optionRows") ?: @[];
    NSDictionary *paths = @{@"reader":@"阅读/阅读页面净化/章末内容", @"mine":@"我的页面净化/内容卡片", @"sidebar":@"我的页面净化/侧栏", @"shelf":@"书架净化/推荐与导入", @"drama":@"短剧/播放设置", @"bookstore":@"书城/页面净化", @"ads":@"广告与福利/专项控制", @"readerFeatures":@"阅读/专项净化",
        @"notifications":@"通知管理", @"gestures":@"阅读/自动阅读", @"audio":@"阅读/智能朗读",
        @"dramaActions":@"短剧/右侧互动按钮", @"appearance":@"外观/玻璃效果", @"comment":@"评论区净化"};
    NSDictionary *legacyTitles = @{@"FanqieX.ReaderEarnMore.1":@"阅读页显示去赚更多",
        @"FanqieX.MineRecommendations.1":@"我的显示推荐内容", @"FanqieX.MineBenefitsCard.1":@"我的显示金币与福利卡片"};
    for (NSDictionary *option in options) {
        FQXSettingRow *row = nil;
        for (FQXSettingRow *existing in menu.catalog)
            if ([existing.originalTitle isEqualToString:legacyTitles[option[@"key"]]]) { row = existing; break; }
        BOOL existing = row != nil;
        if (!row) row = [FQXSettingRow new];
        row.inverted = [@[@"reader", @"mine", @"sidebar", @"shelf", @"comment"] containsObject:option[@"category"]];
        row.title = row.inverted ? [option[@"title"] stringByReplacingOccurrencesOfString:@"显示" withString:@"隐藏"] : option[@"title"];
        row.path = paths[option[@"category"]] ?: @"阅读/阅读设置";
        if ([@[@"FanqieX.ReaderEarnMore.1", @"FanqieX.ReaderSpeechFloat.1", @"FanqieX.ReaderChapterEndDrama.1"] containsObject:option[@"key"]])
            row.path = @"阅读/阅读页面净化/正文与底栏";
        if ([option[@"key"] isEqualToString:@"FanqieX.AudioRecommendations.1"])
            row.path = @"阅读/听书页面净化";
        if ([@[@"FanqieX.MineScanButton.1", @"FanqieX.MineSearchBar.1", @"FanqieX.MineNightButton.1"] containsObject:option[@"key"]])
            row.path = @"我的页面净化/顶部栏";
        if ([option[@"key"] isEqualToString:@"FanqieX.MinePublish.1"]) row.path = @"我的页面净化/悬浮入口";
        if ([@[@"FanqieX.ShelfRecommendationBanner.1", @"FanqieX.ShelfEditButton.1"] containsObject:option[@"key"]]) row.path = @"书架净化/顶部与统计";
        row.keywords = [NSString stringWithFormat:@"%@ %@ %@ 显示 隐藏 开启 关闭 开关", row.path, row.title, option[@"aliases"] ?: @""];
        NSDictionary *aliases = @{
            @"FanqieX.MinePublish.1":@"发帖 羽毛 写帖子 右下角",
            @"FanqieX.MineScanButton.1":@"扫一扫 扫码 二维码 我的顶部 左上角 移除",
            @"FanqieX.MineSearchBar.1":@"搜索框 搜索栏 我的顶部 搜索 移除",
            @"FanqieX.MineNightButton.1":@"夜间 月亮 深色模式 日夜间 我的顶部 右上角 移除",
            @"FanqieX.MineShortcutCard.1":@"快捷功能 订单 历史 消息 创作 签到 快捷入口 卡片 移除",
            @"FanqieX.DramaPinchPureClean.1":@"双指 双指张开 双指收缩 双指捏合 双指缩放 自动清屏 纯净清屏 手势 tiktok 抖音",
            @"FanqieX.DramaPinchHaptic.1":@"双指 双指张开 双指收缩 清屏 震动 振动 触感 反馈 haptic",
            @"FanqieX.DramaDoubleTapComment.1":@"短剧 双击 打开评论区 评论 关闭双击点赞 点赞 手势",
            @"FanqieX.DramaCommentNoVideoShift.1":@"短剧 评论区 画面不上移 视频不缩小 全屏 背景 透射 液态玻璃",
            @"FanqieX.DramaExitCollectAlert.1":@"短剧 退出 收藏 放入书架 是否放入书架 下次再说 弹窗 拦截 关闭",
            @"FanqieX.CommentActivityBanner.1":@"评论区 公告 活动 社区公约 文明发言 活动横幅 激励 创作者计划 段评 顶部 隐藏 关闭",
            @"FanqieX.CommentSearchEntrance.1":@"评论区 大家都在搜 大家在搜 热搜 搜索 推荐 顶部 隐藏 关闭",
            @"FanqieX.DramaOutlineActions.1":@"侧栏 点赞 评论 收藏 分享 线条 空心 轮廓 图标",
            @"FanqieX.DramaShowCollect.1":@"短剧 右侧 收藏 星星 互动按钮 隐藏",
            @"FanqieX.DramaShowComment.1":@"短剧 右侧 评论 气泡 互动按钮 隐藏",
            @"FanqieX.DramaShowLike.1":@"短剧 右侧 点赞 爱心 红心 互动按钮 隐藏",
            @"FanqieX.DramaShowShare.1":@"短剧 右侧 分享 转发 互动按钮 隐藏",
            @"FanqieX.DramaAutoplay.1":@"短剧 自动播放 进入播放 暂停 视频",
            @"FanqieX.AudioLiquidGlass.1":@"听书 液态玻璃 听书液态玻璃 液态玻璃听书 听书按钮 朗读液态玻璃 听书界面 朗读界面 原书 玻璃 外观",
            @"FanqieX.AudioRecommendations.1":@"听书 智能朗读 朗读页 听书页 底部推荐 推荐内容 猜你喜欢 瀑布流 移除",
            @"FanqieX.AudioControlIconsOnly.1":@"听书 隐藏文字 仅图标 纯图标 语速 下载 章评 目录 定时",
            @"FanqieX.ReaderSpeechFloat.1":@"听书 朗读 悬浮 悬浮球 按钮",
            @"FanqieX.ReaderChapterCircle.1":@"书圈 圈子 章末",
            @"FanqieX.ReaderDoubleTapAutoread.1":@"自动翻页 双击 自动阅读 手势",
            @"FanqieX.ReaderAutoReadDurationLimit.1":@"时间限制 广告时长 自动阅读 看广告",
            @"FanqieX.ReaderRatingInvite.1":@"评分 评价 邀请 弹窗 书评",
            @"FanqieX.ExcerptWidgetGuide.1":@"书摘 小组件 桌面 提醒 弹窗",
            @"FanqieX.ContentWidgetGuide.1":@"内容 小组件 桌面 提醒 弹窗",
            @"FanqieX.BookstorePublishButton.1":@"书城 发帖 发布 按钮 悬浮",
            @"FanqieX.ListenPendant.1":@"听读赚钱 赚钱 挂件 悬浮 福利 金币",
            @"FanqieX.StoryAds.1":@"短篇 正文 广告 拦截 净化",
            @"FanqieX.HotLaunchAds.1":@"热启动 开屏 广告 拦截 净化",
            @"FanqieX.AudioAds.1":@"听书 朗读 广告 拦截 净化",
            @"FanqieX.ChapterTitle.1":@"返回 标题 章节名 书名 阅读页",
            @"FanqieX.NotificationsBadge.1":@"红点 数字 角标 通知 提醒",
            @"FanqieX.ReaderChapterEndDrama.1":@"阅读底栏 改编剧场 改编剧入口",
            @"FanqieX.ReaderChapterEndActions.1":@"最新章节 三个按钮 最新章 章末",
            @"FanqieX.ShelfMotionComicRecommendation.1":@"书架 漫剧推荐 动态漫推荐",
            @"FanqieX.ShelfRecommendations.1":@"书架 推荐内容 展开全部 猜你喜欢 为你推荐 书架底部推荐 榜单推荐",
            @"FanqieX.ShelfLocalImport.1":@"书架本地书导入入口 本地图书 本地书导入 导入本地书",
            @"FanqieX.ShelfEditButton.1":@"书架 编辑 编辑按钮 顶部 编辑入口 隐藏 关闭",
            @"FanqieX.SidebarMessages.1":@"侧栏 我的消息 系统通知 创作通知 全部消息 消息 抽屉 隐藏",
            @"FanqieX.SidebarVideoCreate.1":@"侧栏 视频创作 创作 抽屉 隐藏",
            @"FanqieX.SidebarReadingPref.1":@"侧栏 阅读偏好 偏好 抽屉 隐藏",
            @"FanqieX.SidebarMyNotes.1":@"侧栏 我的笔记 笔记 抽屉 隐藏",
            @"FanqieX.SidebarActivityCenter.1":@"侧栏 活动中心 活动 抽屉 隐藏",
            @"FanqieX.SidebarViewedUsers.1":@"侧栏 看过的人 访客 抽屉 隐藏",
            @"FanqieX.SidebarFanqieGuide.1":@"侧栏 番茄指南 指南 抽屉 隐藏",
            @"FanqieX.SidebarMyCharity.1":@"侧栏 我的公益 公益 抽屉 隐藏",
            @"FanqieX.SidebarVipCenter.1":@"侧栏 会员中心 会员 VIP 抽屉 隐藏",
            @"FanqieX.SidebarMyContract.1":@"侧栏 我的签约 签约 抽屉 隐藏",
            @"FanqieX.SidebarMyWallet.1":@"侧栏 我的钱包 钱包 抽屉 隐藏",
            @"FanqieX.SidebarConversionRecord.1":@"侧栏 转化记录 转化 记录 抽屉 隐藏",
            @"FanqieX.SidebarPrivacyLinks.1":@"侧栏 底部清单 个人信息清单 三方信息共享清单 协议 抽屉 隐藏",
            @"FanqieX.MineRecommendations.1":@"我的页面 推荐卡片 无限流",
            @"FanqieX.MineBenefitsCard.1":@"我的页面 福利卡片 金币"
        };
        if (aliases[option[@"key"]]) row.keywords = [row.keywords stringByAppendingFormat:@" %@", aliases[option[@"key"]]];
        row.option = option;
        row.height = 52;
        // Reuse the original switch for shared keys so its refresh action runs.
        if (!existing) [menu.catalog addObject:row];
    }
    FQXSettingRow *video = [FQXSettingRow new];
    video.title = @"导出当前视频";
    video.path = @"导出与备份";
    video.keywords = @"导出当前视频 导出视频 视频导出 保存视频 下载视频 短剧 漫剧 MP4 MOV M4V MKV WebM HLS 原文件 原格式";
    video.destination = @"FQXVideoExport";
    video.height = 52;
    [menu.catalog addObject:video];
    FQXSettingRow *author = [FQXSettingRow new];
    author.title = @"作者信息";
    author.path = @"";
    author.keywords = @"Telegram TG GitHub 频道 仓库";
    author.height = 54.0;
    author.authorInformation = YES;
    [menu.catalog addObject:author];

    FQXSettingRow *diagnostics = [FQXSettingRow new];
    diagnostics.title = @"导出日志";
    diagnostics.path = @"诊断与其他";
    diagnostics.keywords = @"导出日志 诊断 保存 分享";
    diagnostics.height = 58;
    diagnostics.diagnosticExport = YES;
    [menu.catalog addObject:diagnostics];
    FQXSettingRow *purgeRow = [FQXSettingRow new];
    purgeRow.title = @"清理历史残留与缓存";
    purgeRow.path = @"诊断与其他";
    purgeRow.keywords = @"清理 历史残留 缓存 内存 占用 释放 优化 旧设置 诊断残留";
    purgeRow.destination = @"FQXCleanup";
    purgeRow.height = 52;
    [menu.catalog addObject:purgeRow];
    // The diagnostics card contains separate labels and controls. Give each
    // native action its own row while retaining the installed router.
    UIView *card = legacyFooter.subviews.firstObject;
    for (UIView *view in card.subviews) {
        if ([view isKindOfClass:UIButton.class] && ![view.accessibilityLabel isEqualToString:diagnostics.title])
            AddView(menu, view, @"诊断与其他");
        if ([view isKindOfClass:UISwitch.class]) {
            NSString *swTitle = view.accessibilityLabel ?: @"";
            if (!swTitle.length || [swTitle containsString:@"本地激励"] || [swTitle containsString:@"测试激励"]) continue;
            FQXSettingRow *row = [FQXSettingRow new];
            row.title = swTitle;
            row.path = @"诊断与其他";
            row.keywords = row.title;
            UIView *container = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 350, 52)];
            UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(20, 12, 240, 28)];
            label.font = [UIFont systemFontOfSize:16];
            label.text = row.title;
            label.autoresizingMask = UIViewAutoresizingFlexibleWidth;
            [container addSubview:label];
            view.center = CGPointMake(300, 26);
            view.autoresizingMask = UIViewAutoresizingFlexibleLeftMargin;
            [container addSubview:view];
            row.content = container;
            row.height = 52;
            [menu.catalog addObject:row];
        }
    }
    // Release dead legacy flat header/footer containers so only active harvested controls remain in memory.
    legacy.tableHeaderView = nil;
    legacy.tableFooterView = nil;
    UITableView *adsTable = Invoke(ads, @"tableView");
    if ([adsTable isKindOfClass:UITableView.class]) {
        adsTable.tableHeaderView = nil;
        adsTable.tableFooterView = nil;
    }
    for (FQXSettingRow *row in menu.catalog) {
        row.searchText = SearchText(row.keywords);
        row.searchTitle = SearchText(row.title);
    }
    // Own a separate table. The legacy controller only supplies existing
    // controls and actions; its later lifecycle cannot restore the flat page.
    [menu configureSearch];
    [menu updateRows];
    menu.title = owner.title ?: @"FanqieX";
    menu.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemDone
        target:menu action:@selector(dismissSettings:)];
    // Keep the result alive until the audited presentation boundary adopts it.
    objc_setAssociatedObject(owner, MenuKey, menu, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

+ (UIViewController *)controllerForController:(UIViewController *)owner {
    FQXSettingsMenu *menu = MenuForController(owner);
    if (!menu) return owner;
    if (owner.parentViewController != menu) {
        // The original controller stays offscreen as a child. Its switches and
        // router retain their target, and navigationController resolves through
        // this parent to the same stack used by all visible submenus.
        [menu addChildViewController:owner];
        [owner didMoveToParentViewController:menu];
        NSHashTable *reference = [NSHashTable weakObjectsHashTable];
        [reference addObject:menu];
        objc_setAssociatedObject(owner, MenuKey, reference, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
    }
    return menu;
}

+ (UIViewController *)visibleControllerForController:(UIViewController *)owner {
    FQXSettingsMenu *menu = MenuForController(owner);
    return menu.navigationController.topViewController ?: menu;
}

- (void)dismissSettings:(UIBarButtonItem *)sender {
    (void)sender;
    if (self.diagnosticFile.isFileURL) {
        [NSFileManager.defaultManager removeItemAtURL:self.diagnosticFile error:NULL];
        self.diagnosticFile = nil;
    }
    [self.navigationController dismissViewControllerAnimated:YES completion:nil];
}

+ (BOOL)refreshOnController:(UIViewController *)owner {
    FQXSettingsMenu *menu = MenuForController(owner);
    if (!menu) return NO;
    for (FQXSettingRow *row in menu.catalog) {
        if ([row.title isEqualToString:@"短剧滚动自动收缩"]) {
            for (UIView *control in row.content.subviews)
                if ([control isKindOfClass:UISwitch.class]) [(UISwitch *)control setOn:[NSUserDefaults.standardUserDefaults boolForKey:CompactKey]];
        } else if ([row.title isEqualToString:@"查看全集与进度条跟随底栏长度"]) {
            id stored = [NSUserDefaults.standardUserDefaults objectForKey:FollowWidthKey];
            BOOL follow = [stored respondsToSelector:@selector(boolValue)] ? [stored boolValue] : NO;
            for (UIView *control in row.content.subviews)
                if ([control isKindOfClass:UISwitch.class]) [(UISwitch *)control setOn:follow];
        }
    }
    [menu rebuild];
    return YES;
}
+ (BOOL)isInstalledOnController:(UIViewController *)owner {
    return MenuForController(owner) != nil;
}

- (void)configureSearch {
    if (self.search) return;
    self.search = [[UISearchController alloc] initWithSearchResultsController:nil];
    self.search.searchResultsUpdater = self;
    self.search.obscuresBackgroundDuringPresentation = NO;
    self.search.searchBar.placeholder = @"搜索所有设置";
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.tableView.keyboardDismissMode = UIScrollViewKeyboardDismissModeOnDrag;
    [self configureSearch];
    self.navigationItem.searchController = self.search;
    self.navigationItem.hidesSearchBarWhenScrolling = NO;
    self.definesPresentationContext = YES;
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [self rebuild];
}

- (BOOL)updateRows {
    NSString *query = [self.search.searchBar.text stringByTrimmingCharactersInSet:NSCharacterSet.whitespaceAndNewlineCharacterSet] ?: @"";
    NSString *terms = SearchText(query);
    NSMutableArray *rows = [NSMutableArray array];
    NSMutableOrderedSet *folders = [NSMutableOrderedSet orderedSet];
    NSString *prefix = self.path.length ? [self.path stringByAppendingString:@"/"] : @"";
    BOOL compact = [NSUserDefaults.standardUserDefaults boolForKey:CompactKey];
    for (FQXSettingRow *row in self.catalog) {
        if (row.requiresCompact && !compact && !query.length) continue;
        if (query.length) {
            if (row.hiddenFromSearch) continue;
            NSInteger score = MatchScore(row.searchText, terms);
            if (score >= 0) {
                row.matchScore = score + MAX(0, MatchScore(row.searchTitle, terms)) * 2;
                [rows addObject:row];
            }
        } else if ([row.path isEqualToString:self.path]) {
            [rows addObject:row];
        } else if (!self.path.length || [row.path hasPrefix:prefix]) {
            NSString *next = [[row.path substringFromIndex:prefix.length] componentsSeparatedByString:@"/"].firstObject;
            if (next.length) [folders addObject:next];
        }
    }
    if (query.length) [rows sortUsingComparator:^NSComparisonResult(FQXSettingRow *left, FQXSettingRow *right) {
        if (left.matchScore == right.matchScore) return NSOrderedSame;
        return left.matchScore > right.matchScore ? NSOrderedAscending : NSOrderedDescending;
    }];
    self.visibleRows = rows;
    NSArray *order = @[@"页面与导航", @"阅读", @"短剧", @"书架净化", @"我的页面净化", @"评论区净化", @"通知管理", @"外观", @"广告与福利", @"书城", @"导出与备份", @"诊断与其他"];
    NSUInteger fallback = [order indexOfObject:@"导出与备份"];
    self.folders = self.path.length ? folders.array : [folders.array sortedArrayUsingComparator:^NSComparisonResult(NSString *left, NSString *right) {
        NSUInteger a = [order indexOfObject:left], b = [order indexOfObject:right];
        NSUInteger ra = a == NSNotFound ? fallback : a;
        NSUInteger rb = b == NSNotFound ? fallback : b;
        if (ra == rb) return [left localizedCompare:right];
        return ra < rb ? NSOrderedAscending : NSOrderedDescending;
    }];
    return query.length > 0;
}

- (void)rebuild {
    BOOL filtering = [self updateRows];
    UITableView *table = self.tableView;
    [table reloadData];
    UILabel *empty = [[UILabel alloc] init];
    empty.text = @"没有匹配的设置，可尝试功能名称或关键词";
    empty.textColor = UIColor.secondaryLabelColor;
    empty.textAlignment = NSTextAlignmentCenter;
    empty.font = [UIFont systemFontOfSize:14];
    empty.numberOfLines = 0;
    table.backgroundView = filtering && !self.visibleRows.count ? empty : nil;
}

- (void)updateSearchResultsForSearchController:(UISearchController *)controller {
    (void)controller;
    [self rebuild];
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    (void)tableView;
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    (void)tableView; (void)section;
    return self.folders.count + self.visibleRows.count;
}

- (NSString *)tableView:(UITableView *)tableView titleForFooterInSection:(NSInteger)section {
    (void)tableView; (void)section;
    if (self.search.searchBar.text.length) return nil;
    if ([self.path hasPrefix:@"阅读/阅读页面净化"]) return @"开启“隐藏”才会移除对应入口，各项独立控制。章末内容在重新进入书籍后应用。";
    if ([self.path hasPrefix:@"阅读/听书页面净化"]) return @"开启“隐藏”后移除智能朗读/听书页面底部的推荐内容，即时生效。";
    if ([self.path hasPrefix:@"书架净化/"] || [self.path hasPrefix:@"我的页面净化/"]) return @"开启“隐藏”才会移除对应内容，各项独立控制。";
    if ([self.path isEqualToString:@"评论区净化"]) return @"“液态玻璃”与“高斯模糊”二选一开启，全部关闭则使用番茄小说原版评论区；“评论区外观”可跟随软件或独立指定浅色/深色。";
    if ([self.path isEqualToString:@"通知管理"]) return @"控制 App 运行期间的提醒和角标。后台系统推送由 iOS 通知设置管理。";
    if ([self.path hasPrefix:@"广告与福利"]) return @"开关开启表示拦截。重启 App 后完整生效。";
    return nil;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)path {
    (void)tableView;
    if ((NSUInteger)path.row < self.folders.count) return 54;
    FQXSettingRow *row = self.visibleRows[path.row - self.folders.count];
    return row.height + (self.search.searchBar.text.length ? 24 : 0);
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)path {
    (void)tableView;
    if ((NSUInteger)path.row < self.folders.count) {
        UITableViewCell *cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:nil];
        cell.textLabel.text = self.folders[path.row];
        cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
        return cell;
    }
    FQXSettingRow *row = self.visibleRows[path.row - self.folders.count];
    if (row.nativeCell) {
        row.nativeCell.accessibilityHint = self.search.searchBar.text.length ? [row.path stringByReplacingOccurrencesOfString:@"/" withString:@"，"] : nil;
        return row.nativeCell;
    }
    if (row.popoverKey.length && row.popoverOptions.count) {
        BOOL searching = self.search.searchBar.text.length > 0;
        UITableViewCell *cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:nil];
        cell.textLabel.text = row.title;
        cell.textLabel.numberOfLines = 2;
        NSInteger curIdx = (row.popoverKind == 1) ? CurrentSavedBottomDisplayMode()
                         : (row.popoverKind == 2) ? CurrentSavedCommentComposerStyle()
                         : 0;
        if (curIdx < 0 || (NSUInteger)curIdx >= row.popoverOptions.count) curIdx = 0;
        cell.detailTextLabel.text = searching
            ? [NSString stringWithFormat:@"%@ · %@", row.popoverOptions[(NSUInteger)curIdx], row.path]
            : row.popoverOptions[(NSUInteger)curIdx];
        cell.detailTextLabel.textColor = UIColor.secondaryLabelColor;
        cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
        cell.selectionStyle = UITableViewCellSelectionStyleDefault;
        return cell;
    }
    UITableViewCell *cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:nil];
    if (row.diagnosticExport) {
        cell.textLabel.text = row.title;
        cell.detailTextLabel.textColor = UIColor.secondaryLabelColor;
        cell.detailTextLabel.numberOfLines = 2;
        cell.accessibilityTraits |= UIAccessibilityTraitButton;
        if (self.diagnosticExportPending) {
            cell.detailTextLabel.text = @"正在生成日志…";
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
            UIActivityIndicatorView *progress = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleMedium];
            [progress startAnimating];
            cell.accessoryView = progress;
        } else {
            if (self.diagnosticFile) cell.detailTextLabel.text = @"已生成，点按分享";
            else if (self.diagnosticError) cell.detailTextLabel.text = self.diagnosticError;
            else if (self.search.searchBar.text.length) cell.detailTextLabel.text = row.path;
            cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
        }
        return cell;
    }
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    cell.textLabel.numberOfLines = 2;
    BOOL unavailable = row.requiresCompact && ![NSUserDefaults.standardUserDefaults boolForKey:CompactKey];
    if (unavailable) {
        cell.textLabel.text = row.title;
        cell.textLabel.textColor = UIColor.secondaryLabelColor;
    } else if (row.content) {
        row.content.hidden = NO;
        row.content.frame = CGRectMake(0, 0, CGRectGetWidth(cell.contentView.bounds), row.height);
        row.content.autoresizingMask = UIViewAutoresizingFlexibleWidth;
        [cell.contentView addSubview:row.content];
        if ([row.content isKindOfClass:UIButton.class]) {
            UIButton *button = (UIButton *)row.content;
            if (!row.actions) {
                NSMutableArray *actions = [NSMutableArray array];
                for (id target in button.allTargets) {
                    for (NSString *name in [button actionsForTarget:target forControlEvent:UIControlEventTouchUpInside]) {
                        NSHashTable *weakTarget = [NSHashTable weakObjectsHashTable];
                        [weakTarget addObject:target];
                        [actions addObject:@{@"target":weakTarget, @"selector":name}];
                        [button removeTarget:target action:NSSelectorFromString(name) forControlEvents:UIControlEventTouchUpInside];
                    }
                }
                row.actions = actions;
            }
            for (id target in button.allTargets.allObjects) {
                [button removeTarget:target action:@selector(performStoredAction:) forControlEvents:UIControlEventTouchUpInside];
            }
            [button addTarget:self action:@selector(performStoredAction:) forControlEvents:UIControlEventTouchUpInside];
        }
        for (UIView *control in row.content.subviews) {
            if (![control isKindOfClass:UISwitch.class]) continue;
            UISwitch *sw = (UISwitch *)control;
            if ([sw.accessibilityLabel isEqualToString:@"短剧滚动自动收缩"]) {
                sw.on = [NSUserDefaults.standardUserDefaults boolForKey:CompactKey];
                // Never pass nil target to removeTarget:action:forControlEvents: — UIKit treats nil
                // target as a wildcard that removes the settingsOwner's persistence action too!
                for (id target in sw.allTargets.allObjects) {
                    [sw removeTarget:target action:@selector(nativeToggleChanged:) forControlEvents:UIControlEventValueChanged];
                }
                [sw addTarget:self action:@selector(nativeToggleChanged:) forControlEvents:UIControlEventValueChanged];
            } else if ([sw.accessibilityLabel isEqualToString:@"查看全集与进度条跟随底栏长度"]) {
                id stored = [NSUserDefaults.standardUserDefaults objectForKey:FollowWidthKey];
                sw.on = [stored respondsToSelector:@selector(boolValue)] ? [stored boolValue] : NO;
            }
        }
    } else {
        cell.textLabel.text = row.title;
        if (row.commentMaterialChoice > 0) {
            UISwitch *toggle = [[UISwitch alloc] init];
            toggle.on = (CurrentSavedCommentMaterialStyle() == row.commentMaterialChoice);
            toggle.accessibilityIdentifier = CommentMaterialStyleKey;
            toggle.accessibilityLabel = row.title;
            objc_setAssociatedObject(toggle, RowKey, row, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
            [toggle addTarget:self action:@selector(commentMaterialSwitchChanged:) forControlEvents:UIControlEventValueChanged];
            cell.accessoryView = toggle;
        } else if (row.authorInformation) {
            cell.accessibilityTraits |= UIAccessibilityTraitButton;
            cell.selectionStyle = UITableViewCellSelectionStyleDefault;
            cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
        } else if (row.commentAppearanceRow) {
            UISegmentedControl *seg = [[UISegmentedControl alloc] initWithItems:@[@"跟随软件", @"浅色", @"深色"]];
            seg.frame = CGRectMake(0, 0, 186, 32);
            seg.accessibilityIdentifier = CommentAppearanceModeKey;
            seg.accessibilityLabel = row.title;
            NSDictionary *segAttrs = @{NSFontAttributeName: [UIFont systemFontOfSize:12 weight:UIFontWeightMedium]};
            [seg setTitleTextAttributes:segAttrs forState:UIControlStateNormal];
            [seg setTitleTextAttributes:segAttrs forState:UIControlStateSelected];
            seg.selectedSegmentIndex = CurrentSavedCommentAppearanceMode();
            [seg addTarget:self action:@selector(commentAppearanceChanged:) forControlEvents:UIControlEventValueChanged];
            cell.accessoryView = seg;
        } else if (row.option || row.originalToggle) {
            UISwitch *toggle = [[UISwitch alloc] init];
            id stored = row.option ? [NSUserDefaults.standardUserDefaults objectForKey:row.option[@"key"]] : nil;
            BOOL enabled = row.originalToggle ? row.originalToggle.on : (stored ? [stored boolValue] : [row.option[@"default"] boolValue]);
            toggle.on = row.inverted ? !enabled : enabled;
            toggle.accessibilityIdentifier = row.option[@"key"];
            toggle.accessibilityLabel = row.title;
            objc_setAssociatedObject(toggle, RowKey, row, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
            [toggle addTarget:self action:@selector(optionChanged:) forControlEvents:UIControlEventValueChanged];
            cell.accessoryView = toggle;
        } else cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    }
    if (self.search.searchBar.text.length) {
        if (row.content && !unavailable) {
            UILabel *pathLabel = [[UILabel alloc] initWithFrame:CGRectMake(20, row.height, CGRectGetWidth(cell.contentView.bounds) - 40, 22)];
            pathLabel.autoresizingMask = UIViewAutoresizingFlexibleWidth;
            pathLabel.font = [UIFont systemFontOfSize:11];
            pathLabel.textColor = UIColor.secondaryLabelColor;
            pathLabel.text = [row.path stringByReplacingOccurrencesOfString:@"/" withString:@" › "];
            [cell.contentView addSubview:pathLabel];
        } else cell.detailTextLabel.text = unavailable ? [@"先开启自动收缩 · " stringByAppendingString:row.path] : row.path;
    }
    return cell;
}

- (void)commentMaterialSwitchChanged:(UISwitch *)toggle {
    FQXSettingRow *row = objc_getAssociatedObject(toggle, RowKey);
    NSInteger choice = row ? row.commentMaterialChoice : 0;
    NSInteger nextStyle = toggle.isOn ? choice : 0;
    NSUserDefaults *ud = NSUserDefaults.standardUserDefaults;
    [ud setInteger:nextStyle forKey:CommentMaterialStyleKey];
    [ud removeObjectForKey:@"FanqieX.CommentGlassFrosted.1"];
    [ud removeObjectForKey:@"FanqieX.CommentMaterialMode.1"];
    for (UITableViewCell *cell in self.tableView.visibleCells) {
        if ([cell.accessoryView isKindOfClass:UISwitch.class] && cell.accessoryView != toggle) {
            UISwitch *other = (UISwitch *)cell.accessoryView;
            FQXSettingRow *otherRow = objc_getAssociatedObject(other, RowKey);
            if (otherRow && otherRow.commentMaterialChoice > 0) {
                BOOL shouldBeOn = (nextStyle == otherRow.commentMaterialChoice);
                if (other.isOn != shouldBeOn) [other setOn:shouldBeOn animated:YES];
            }
        }
    }
    Class cleanup = NSClassFromString(@"FQXCleanup");
    SEL selector = NSSelectorFromString(@"refreshForKey:");
    if ([cleanup respondsToSelector:selector]) {
        ((void (*)(id, SEL, id))objc_msgSend)(cleanup, selector, CommentMaterialStyleKey);
    }
}

- (void)commentAppearanceChanged:(UISegmentedControl *)sender {
    NSInteger mode = sender.selectedSegmentIndex;
    if (mode < 0 || mode > 2) mode = 0;
    [NSUserDefaults.standardUserDefaults setInteger:mode forKey:CommentAppearanceModeKey];
    Class cleanup = NSClassFromString(@"FQXCleanup");
    SEL selector = NSSelectorFromString(@"refreshForKey:");
    if ([cleanup respondsToSelector:selector]) {
        ((void (*)(id, SEL, id))objc_msgSend)(cleanup, selector, CommentAppearanceModeKey);
    }
}

- (void)nativeToggleChanged:(UISwitch *)toggle {
    BOOL isOn = toggle.isOn;
    [NSUserDefaults.standardUserDefaults setBool:isOn forKey:CompactKey];
    UIViewController *owner = self.settingsOwner;
    SEL optionSel = NSSelectorFromString(@"fqx178_bottomOptionChanged:");
    if (owner && [owner respondsToSelector:optionSel]) {
        ((void (*)(id, SEL, id))objc_msgSend)(owner, optionSel, toggle);
    }
    dispatch_async(dispatch_get_main_queue(), ^{ [self rebuild]; });
}

- (void)performStoredAction:(UIButton *)button {
    for (FQXSettingRow *row in self.catalog) {
        if (row.content != button) continue;
        void (^perform)(void) = ^{
            for (NSDictionary *action in row.actions) {
                id target = [action[@"target"] anyObject];
                SEL selector = NSSelectorFromString(action[@"selector"]);
                if ([target respondsToSelector:selector])
                    ((void (*)(id, SEL, id))objc_msgSend)(target, selector, button);
            }
        };
        UIViewController *presenter = self.search.presentingViewController;
        if (presenter.presentedViewController == self.search) {
            [presenter dismissViewControllerAnimated:NO completion:perform];
        } else {
            self.search.active = NO;
            perform();
        }
        return;
    }
}

- (void)optionChanged:(UISwitch *)toggle {
    FQXSettingRow *row = objc_getAssociatedObject(toggle, RowKey);
    BOOL enabled = row.inverted ? !toggle.on : toggle.on;
    if (row.originalToggle) {
        row.originalToggle.on = enabled;
        [row.originalToggle sendActionsForControlEvents:UIControlEventValueChanged];
        Class dockMotion = NSClassFromString(@"FQXDockMotion");
        SEL refreshSel = NSSelectorFromString(@"refreshAudioGlass");
        if ([dockMotion respondsToSelector:refreshSel]) {
            ((void (*)(id, SEL))objc_msgSend)(dockMotion, refreshSel);
        }
        return;
    }
    [NSUserDefaults.standardUserDefaults setBool:enabled forKey:toggle.accessibilityIdentifier];
    Class cleanup = NSClassFromString(@"FQXCleanup");
    SEL selector = NSSelectorFromString(@"refreshForKey:");
    if ([cleanup respondsToSelector:selector])
        ((void (*)(id, SEL, id))objc_msgSend)(cleanup, selector, toggle.accessibilityIdentifier);
}

- (void)beginDiagnosticExport {
    if (self.diagnosticExportPending) return;
    if (self.diagnosticFile) {
        [self shareDiagnosticFile];
        return;
    }
    SEL enqueue = NSSelectorFromString(@"fqx_enqueueDiagnosticExport:");
    if (![self respondsToSelector:enqueue]) {
        [self fqab_156_presentDiagnostics:@{@"error": @"诊断服务未加载，请重新打开设置后重试。"}];
        return;
    }
    self.diagnosticError = nil;
    self.diagnosticExportPending = YES;
    [self.tableView reloadData];
    ((void (*)(id, SEL, id))objc_msgSend)(self, enqueue, self);
}

- (void)fqab_156_presentDiagnostics:(NSDictionary *)result {
    self.diagnosticExportPending = NO;
    self.diagnosticFile = result[@"url"];
    self.diagnosticError = self.diagnosticFile ? nil : (result[@"error"] ?: @"日志生成失败，请重试。");
    [self.tableView reloadData];
    if (self.diagnosticFile) [self shareDiagnosticFile];
}

- (void)shareDiagnosticFile {
    if (!self.viewIfLoaded.window || self.navigationController.topViewController != self) return;
    NSURL *file = self.diagnosticFile;
    void (^present)(void) = ^{
        if (!self.viewIfLoaded.window || self.navigationController.topViewController != self ||
            self.presentedViewController || self.navigationController.presentedViewController ||
            self.diagnosticFile != file) return;
        UIActivityViewController *share = [[UIActivityViewController alloc] initWithActivityItems:@[file]
                                                                              applicationActivities:nil];
        CGRect bounds = self.view.bounds;
        share.popoverPresentationController.sourceView = self.view;
        share.popoverPresentationController.sourceRect = CGRectMake(CGRectGetMidX(bounds), CGRectGetMidY(bounds), 1, 1);
        share.completionWithItemsHandler = ^(UIActivityType type, BOOL completed, NSArray *items, NSError *error) {
            (void)type; (void)completed; (void)items; (void)error;
            if (file.isFileURL) [NSFileManager.defaultManager removeItemAtURL:file error:NULL];
        };
        [self presentViewController:share animated:YES completion:^{
            self.diagnosticFile = nil;
            [self.tableView reloadData];
        }];
    };
    UIViewController *presenter = self.search.presentingViewController;
    if (presenter && presenter.presentedViewController == self.search)
        [presenter dismissViewControllerAnimated:NO completion:present];
    else
        present();
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)path {
    [tableView deselectRowAtIndexPath:path animated:YES];
    UIViewController *owner = self;
    if ((NSUInteger)path.row < self.folders.count) {
        NSString *title = self.folders[path.row];
        FQXSettingsMenu *page = [[FQXSettingsMenu alloc] initWithStyle:UITableViewStyleInsetGrouped];
        page.catalog = self.catalog;
        page.path = self.path.length ? [self.path stringByAppendingFormat:@"/%@", title] : title;
        page.title = title;
        page.settingsOwner = self.settingsOwner;
        page.router = self.router;
        page.adsOwner = self.adsOwner;
        [owner.navigationController pushViewController:page animated:YES];
    } else {
        FQXSettingRow *row = self.visibleRows[path.row - self.folders.count];
        if (row.popoverKey.length && row.popoverOptions.count) {
            UITableViewCell *cell = [tableView cellForRowAtIndexPath:path];
            NSInteger curIdx = (row.popoverKind == 1) ? CurrentSavedBottomDisplayMode()
                             : (row.popoverKind == 2) ? CurrentSavedCommentComposerStyle()
                             : 0;
            if (curIdx < 0 || (NSUInteger)curIdx >= row.popoverOptions.count) curIdx = 0;
            FQXPopoverPickerController *picker = [FQXPopoverPickerController new];
            picker.pickerTitle = row.title;
            picker.options = row.popoverOptions;
            picker.selectedIndex = curIdx;
            picker.preferredContentSize = CGSizeMake(236.0, 72.0 + row.popoverOptions.count * 52.0);
            picker.modalPresentationStyle = UIModalPresentationPopover;
            UIPopoverPresentationController *pop = picker.popoverPresentationController;
            pop.delegate = picker;
            pop.permittedArrowDirections = UIPopoverArrowDirectionUp | UIPopoverArrowDirectionDown;
            if (cell) {
                pop.sourceView = cell;
                pop.sourceRect = CGRectMake(MAX(0.0, CGRectGetMaxX(cell.bounds) - 96.0),
                                            CGRectGetMidY(cell.bounds) - 10.0, 76.0, 20.0);
            } else {
                pop.sourceView = self.view;
                pop.sourceRect = CGRectMake(CGRectGetMidX(self.view.bounds), CGRectGetMidY(self.view.bounds), 1.0, 1.0);
            }
            __weak FQXSettingsMenu *weakMenu = self;
            NSString *prefKey = row.popoverKey;
            NSInteger kind = row.popoverKind;
            picker.onSelect = ^(NSInteger chosen) {
                NSUserDefaults *ud = NSUserDefaults.standardUserDefaults;
                [ud setInteger:chosen forKey:prefKey];
                if (kind == 1) {
                    [ud setBool:(chosen == 1) forKey:BottomIconsOnlyLegacyKey];
                }
                Class cleanup = NSClassFromString(@"FQXCleanup");
                SEL selector = NSSelectorFromString(@"refreshForKey:");
                if ([cleanup respondsToSelector:selector]) {
                    ((void (*)(id, SEL, id))objc_msgSend)(cleanup, selector, prefKey);
                }
                [weakMenu.tableView reloadData];
            };
            UIViewController *presenter = self.presentedViewController ?: self;
            [presenter presentViewController:picker animated:YES completion:nil];
            return;
        }
        if (row.authorInformation) {
            NSString *telegram = @"https://t.me/Naloiafeed";
            NSString *repository = @"https://github.com/SOLHK/FanqieX";
            UIAlertController *info = [UIAlertController alertControllerWithTitle:row.title
                message:[NSString stringWithFormat:@"%@\n%@", telegram, repository]
                preferredStyle:UIAlertControllerStyleAlert];
            for (NSArray<NSString *> *link in @[@[@"Telegram 频道", telegram], @[@"GitHub", repository]]) {
                [info addAction:[UIAlertAction actionWithTitle:link[0] style:UIAlertActionStyleDefault handler:^(__unused UIAlertAction *action) {
                    [UIApplication.sharedApplication openURL:[NSURL URLWithString:link[1]] options:@{} completionHandler:nil];
                }]];
            }
            [info addAction:[UIAlertAction actionWithTitle:@"关闭" style:UIAlertActionStyleCancel handler:nil]];
            UIViewController *presenter = self.presentedViewController ?: self;
            [presenter presentViewController:info animated:YES completion:nil];
            return;
        }
        if (row.diagnosticExport) {
            [self beginDiagnosticExport];
            return;
        }
        if (row.destination) {
            Class target = NSClassFromString(row.destination);
            SEL action = NSSelectorFromString(@"presentFromController:");
            void (^perform)(void) = ^{
                if ([target respondsToSelector:action]) ((void (*)(id, SEL, id))objc_msgSend)(target, action, owner);
            };
            UIViewController *presenter = self.search.presentingViewController;
            if (presenter.presentedViewController == self.search) [presenter dismissViewControllerAnimated:NO completion:perform];
            else { self.search.active = NO; perform(); }
        }
    }
}
@end
