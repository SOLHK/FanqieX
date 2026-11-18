#import <UIKit/UIKit.h>
#import <objc/message.h>
#import <objc/runtime.h>

static const void *MenuKey = &MenuKey;
static const void *RowKey = &RowKey;
static NSString *const CompactKey = @"FanqieX.BottomDramaCompact.1";
static NSString *const FollowWidthKey = @"FanqieX.DramaFollowBottomWidth.1";

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
    for (NSArray *pair in @[@[@"看听读时长", @"阅读时长"], @[@"听读时长", @"阅读时长"], @[@"朗读", @"听书"],
                           @[@"自动翻页", @"自动阅读"], @[@"动态漫", @"漫剧"],
                           @[@"改编剧场", @"改编剧"], @[@"发布", @"发帖"],
                           @[@"推荐卡片", @"推荐内容"], @[@"送礼物", @"送礼"],
                           @[@"折叠", @"收缩"], @[@"收起", @"收缩"],
                           @[@"保存", @"导出"], @[@"下载", @"导出"]])
        normalized = [normalized stringByReplacingOccurrencesOfString:pair[0] withString:pair[1]];
    for (NSString *word in @[@"隐藏", @"显示", @"关闭", @"开启", @"去掉", @"打开", @"按钮", @"入口", @"页面"])
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
@property(nonatomic) NSInteger matchScore;
@end
@implementation FQXSettingRow
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
@property(nonatomic, strong) NSArray<UIView *> *legacyPanels;
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
        if ([title containsString:@"分类"]) return @"短剧/顶部分类";
        if ([title containsString:@"收缩"] || [title containsString:@"跟随底栏长度"]) return @"短剧/底栏收缩";
        if ([title containsString:@"显示作者"] || [title containsString:@"显示阅读原著"] ||
            [title containsString:@"兴趣推荐"] || [title containsString:@"搜索按钮"]) return @"短剧/页面内容";
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
    if (!title.length || [title isEqualToString:@"诊断与日志"] || [title isEqualToString:@"广告与福利"]) return;
    FQXSettingRow *row = [FQXSettingRow new];
    row.title = title;
    row.originalTitle = title;
    row.path = PathForTitle(group, title);
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
    if ([title containsString:@"自动收缩"]) row.keywords = [row.keywords stringByAppendingString:@" 缩小 收起 折叠 底栏"];
    if ([title containsString:@"跟随底栏长度"]) row.keywords = [row.keywords stringByAppendingString:@" 查看全集 观看完整漫剧 进度条 底栏长度 胶囊长度 自动跟随 宽度"];
    if ([title containsString:@"时长"]) row.keywords = [row.keywords stringByAppendingString:@" 书架今日听读时长 阅读统计"];
    [menu.catalog addObject:row];
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
    menu.legacyPanels = @[legacy.tableHeaderView ?: [UIView new], legacy.tableFooterView ?: [UIView new]];
    for (UIView *group in legacy.tableHeaderView.subviews) {
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
                if (!title.length) continue;
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
    NSArray *options = Invoke(NSClassFromString(@"FQXCleanup"), @"optionRows") ?: @[];
    NSDictionary *paths = @{@"reader":@"阅读/阅读页面净化/章末内容", @"mine":@"我的页面净化/内容卡片", @"shelf":@"书架净化/推荐与导入", @"drama":@"短剧/播放设置", @"bookstore":@"书城/页面净化", @"ads":@"广告与福利/专项控制", @"readerFeatures":@"阅读/专项净化",
        @"notifications":@"通知管理", @"gestures":@"阅读/自动阅读"};
    NSDictionary *legacyTitles = @{@"FanqieX.ReaderEarnMore.1":@"阅读页显示去赚更多",
        @"FanqieX.MineRecommendations.1":@"我的显示推荐内容", @"FanqieX.MineBenefitsCard.1":@"我的显示金币与福利卡片"};
    for (NSDictionary *option in options) {
        FQXSettingRow *row = nil;
        for (FQXSettingRow *existing in menu.catalog)
            if ([existing.originalTitle isEqualToString:legacyTitles[option[@"key"]]]) { row = existing; break; }
        BOOL existing = row != nil;
        if (!row) row = [FQXSettingRow new];
        row.inverted = [@[@"reader", @"mine", @"shelf"] containsObject:option[@"category"]];
        row.title = row.inverted ? [option[@"title"] stringByReplacingOccurrencesOfString:@"显示" withString:@"隐藏"] : option[@"title"];
        row.path = paths[option[@"category"]] ?: @"阅读/阅读设置";
        if ([@[@"FanqieX.ReaderEarnMore.1", @"FanqieX.ReaderSpeechFloat.1", @"FanqieX.ReaderChapterEndDrama.1"] containsObject:option[@"key"]])
            row.path = @"阅读/阅读页面净化/正文与底栏";
        if ([option[@"key"] isEqualToString:@"FanqieX.AudioRecommendations.1"])
            row.path = @"阅读/听书页面净化";
        if ([@[@"FanqieX.MineScanButton.1", @"FanqieX.MineSearchBar.1", @"FanqieX.MineNightButton.1"] containsObject:option[@"key"]])
            row.path = @"我的页面净化/顶部栏";
        if ([option[@"key"] isEqualToString:@"FanqieX.MinePublish.1"]) row.path = @"我的页面净化/悬浮入口";
        if ([option[@"key"] isEqualToString:@"FanqieX.ShelfRecommendationBanner.1"]) row.path = @"书架净化/顶部与统计";
        row.keywords = [NSString stringWithFormat:@"%@ %@ %@ 显示 隐藏 开启 关闭 开关", row.path, row.title, option[@"aliases"] ?: @""];
        NSDictionary *aliases = @{
            @"FanqieX.MinePublish.1":@"发帖 羽毛 写帖子 右下角",
            @"FanqieX.MineScanButton.1":@"扫一扫 扫码 二维码 我的顶部 左上角 移除",
            @"FanqieX.MineSearchBar.1":@"搜索框 搜索栏 我的顶部 搜索 移除",
            @"FanqieX.MineNightButton.1":@"夜间 月亮 深色模式 日夜间 我的顶部 右上角 移除",
            @"FanqieX.MineShortcutCard.1":@"快捷功能 订单 历史 消息 创作 签到 快捷入口 卡片 移除",
            @"FanqieX.DramaPinchPureClean.1":@"双指 双指张开 双指收缩 双指捏合 双指缩放 自动清屏 纯净清屏 手势 tiktok 抖音",
            @"FanqieX.AudioRecommendations.1":@"听书 智能朗读 朗读页 听书页 底部推荐 推荐内容 猜你喜欢 瀑布流 移除",
            @"FanqieX.ReaderSpeechFloat.1":@"听书 朗读 悬浮",
            @"FanqieX.ReaderChapterCircle.1":@"书圈 圈子",
            @"FanqieX.ReaderDoubleTapAutoread.1":@"自动翻页 双击",
            @"FanqieX.ReaderAutoReadDurationLimit.1":@"时间限制 广告时长",
            @"FanqieX.NotificationsBadge.1":@"红点 数字 角标",
            @"FanqieX.ReaderChapterEndDrama.1":@"阅读底栏 改编剧场 改编剧入口",
            @"FanqieX.ReaderChapterEndActions.1":@"最新章节 三个按钮 最新章 章末",
            @"FanqieX.ShelfMotionComicRecommendation.1":@"书架 漫剧推荐 动态漫推荐",
            @"FanqieX.ShelfRecommendations.1":@"书架 推荐内容 展开全部 猜你喜欢 为你推荐 书架底部推荐 榜单推荐",
            @"FanqieX.ShelfLocalImport.1":@"书架本地书导入入口 本地图书 本地书导入 导入本地书",
            @"FanqieX.MineRecommendations.1":@"我的页面 推荐卡片",
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
    FQXSettingRow *diagnostics = [FQXSettingRow new];
    diagnostics.title = @"导出日志";
    diagnostics.path = @"诊断与其他";
    diagnostics.keywords = @"导出日志 诊断 保存 分享";
    diagnostics.height = 58;
    diagnostics.diagnosticExport = YES;
    [menu.catalog addObject:diagnostics];
    // The diagnostics card contains separate labels and controls. Give each
    // native action its own row while retaining the installed router.
    UIView *card = legacy.tableFooterView.subviews.firstObject;
    for (UIView *view in card.subviews) {
        if ([view isKindOfClass:UIButton.class] && ![view.accessibilityLabel isEqualToString:diagnostics.title])
            AddView(menu, view, @"诊断与其他");
        if ([view isKindOfClass:UISwitch.class]) {
            FQXSettingRow *row = [FQXSettingRow new];
            row.title = view.accessibilityLabel;
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
            BOOL follow = [stored respondsToSelector:@selector(boolValue)] ? [stored boolValue] : YES;
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
    NSArray *order = @[@"页面与导航", @"阅读", @"短剧", @"书架净化", @"我的页面净化", @"通知管理", @"外观", @"广告与福利", @"书城", @"导出与备份", @"诊断与其他"];
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
                sw.on = [stored respondsToSelector:@selector(boolValue)] ? [stored boolValue] : YES;
            }
        }
    } else {
        cell.textLabel.text = row.title;
        if (row.option || row.originalToggle) {
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
