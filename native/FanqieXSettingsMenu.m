#import <UIKit/UIKit.h>
#import <objc/message.h>
#import <objc/runtime.h>

static const void *MenuKey = &MenuKey;
static NSString *const CompactKey = @"FanqieX.BottomDramaCompact.1";

static id Invoke(id receiver, NSString *name) {
    SEL selector = NSSelectorFromString(name);
    return [receiver respondsToSelector:selector] ? ((id (*)(id, SEL))objc_msgSend)(receiver, selector) : nil;
}

static NSString *Fold(NSString *text) {
    NSString *simple = [text stringByApplyingTransform:@"Traditional-Simplified" reverse:NO];
    return [[simple ?: text lowercaseString] stringByFoldingWithOptions:NSDiacriticInsensitiveSearch | NSWidthInsensitiveSearch
        locale:[NSLocale localeWithLocaleIdentifier:@"zh_CN"]];
}

static BOOL Matches(NSString *text, NSString *query) {
    NSString *folded = Fold(text);
    NSString *normalized = Fold(query);
    for (NSString *prefix in @[@"隐藏", @"显示", @"关闭", @"开启", @"去掉"]) {
        if ([normalized hasPrefix:prefix] && normalized.length > prefix.length) {
            normalized = [normalized substringFromIndex:prefix.length];
            break;
        }
    }
    for (NSString *word in [normalized componentsSeparatedByCharactersInSet:NSCharacterSet.whitespaceAndNewlineCharacterSet]) {
        if (!word.length || [folded containsString:word]) continue;
        NSUInteger matched = 0;
        for (NSUInteger i = 0; i < folded.length && matched < word.length; ++i)
            if ([folded characterAtIndex:i] == [word characterAtIndex:matched]) ++matched;
        if (matched != word.length) return NO;
    }
    return YES;
}

@interface FQXSettingRow : NSObject
@property(nonatomic, copy) NSString *title;
@property(nonatomic, copy) NSString *path;
@property(nonatomic, copy) NSString *keywords;
@property(nonatomic, strong) UIView *content;
@property(nonatomic, strong) UITableViewCell *nativeCell;
@property(nonatomic, copy) NSDictionary *option;
@property(nonatomic, copy) NSString *destination;
@property(nonatomic, copy) NSArray<NSDictionary *> *actions;
@property(nonatomic) CGFloat height;
@property(nonatomic) BOOL requiresCompact;
@end
@implementation FQXSettingRow
@end

@interface FQXSettingsMenu : UITableViewController <UISearchResultsUpdating>
@property(nonatomic, strong) NSMutableArray<FQXSettingRow *> *catalog;
@property(nonatomic, copy) NSArray<FQXSettingRow *> *visibleRows;
@property(nonatomic, copy) NSArray<NSString *> *folders;
@property(nonatomic, copy) NSString *path;
@property(nonatomic, strong) UISearchController *search;
@property(nonatomic, weak) UITableView *rootTable;
@property(nonatomic, weak) UIViewController *settingsOwner;
@property(nonatomic, strong) id router;
@property(nonatomic, strong) UIViewController *adsOwner;
@property(nonatomic, strong) NSArray<UIView *> *legacyPanels;
+ (void)installOnController:(UIViewController *)owner router:(id)router ads:(UIViewController *)ads;
+ (BOOL)refreshOnController:(UIViewController *)owner;
+ (BOOL)isInstalledOnController:(UIViewController *)owner;
- (void)configureSearch;
- (BOOL)updateRows;
@end

static NSString *ControlTitle(UIView *view) {
    if ([view isKindOfClass:UIButton.class]) return [(UIButton *)view titleForState:UIControlStateNormal] ?: view.accessibilityLabel;
    for (UIView *child in view.subviews) {
        if ([child isKindOfClass:UILabel.class] && [(UILabel *)child text].length) return [(UILabel *)child text];
    }
    return view.accessibilityLabel ?: @"";
}

static NSString *PathForTitle(NSString *group, NSString *title) {
    if ([group isEqualToString:@"底栏入口"]) return @"页面与导航/底栏入口";
    if ([group isEqualToString:@"短剧播放"]) {
        if ([title containsString:@"分类"]) return @"短剧/顶部分类";
        if ([title containsString:@"收缩"]) return @"短剧/底栏收缩";
        if ([title containsString:@"显示作者"] || [title containsString:@"显示阅读原著"] ||
            [title containsString:@"兴趣推荐"] || [title containsString:@"搜索按钮"]) return @"短剧/页面内容";
        return @"短剧/播放设置";
    }
    if ([title containsString:@"导出书籍"]) return @"导出与备份";
    if ([title containsString:@"书架"]) return @"书架净化";
    if ([title containsString:@"我的"] || [title containsString:@"侧栏"]) return @"我的页面净化";
    if ([title containsString:@"去赚更多"]) return @"阅读/页面净化";
    if ([group isEqualToString:@"阅读与书架"]) return @"阅读/阅读设置";
    if ([title containsString:@"默认启动"] || [title containsString:@"书城顶部"]) return @"页面与导航";
    if ([title containsString:@"备份"]) return @"导出与备份";
    if ([title containsString:@"外观"] || [title containsString:@"液态玻璃"]) return @"外观";
    return @"诊断与其他";
}

static void AddView(FQXSettingsMenu *menu, UIView *view, NSString *group) {
    NSString *title = [ControlTitle(view) stringByReplacingOccurrencesOfString:@"  ›" withString:@""];
    if (!title.length || [title isEqualToString:@"诊断与日志"] || [title isEqualToString:@"广告与福利"]) return;
    FQXSettingRow *row = [FQXSettingRow new];
    row.title = title;
    row.path = PathForTitle(group, title);
    row.keywords = [NSString stringWithFormat:@"%@ %@ %@", title, row.path, view.accessibilityIdentifier ?: @""];
    for (UIView *child in view.subviews) {
        if ([child isKindOfClass:UISwitch.class]) {
            row.keywords = [row.keywords stringByAppendingString:@" 显示 隐藏 开启 关闭 开关"];
            break;
        }
    }
    row.content = view;
    row.height = MAX(52, CGRectGetHeight(view.bounds));
    row.requiresCompact = [title containsString:@"收缩位置"];
    if ([title containsString:@"自动收缩"]) row.keywords = [row.keywords stringByAppendingString:@" 缩小 收起 折叠 底栏"];
    [menu.catalog addObject:row];
}

@implementation FQXSettingsMenu

+ (void)installOnController:(UIViewController *)owner router:(id)router ads:(UIViewController *)ads {
    if (objc_getAssociatedObject(owner, MenuKey)) return;
    UITableView *legacy = Invoke(owner, @"tableView");
    if (!legacy.tableHeaderView) return;
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
    if (!menu.catalog.count) return;
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
                row.path = page == (id)owner ? @"外观" : [@"广告与福利/" stringByAppendingString:group];
                row.keywords = [NSString stringWithFormat:@"%@ %@ 广告 拦截", row.path, title];
                row.nativeCell = cell;
                row.height = 52;
                [menu.catalog addObject:row];
            }
        }
    }
    NSArray *options = Invoke(NSClassFromString(@"FQXCleanup"), @"optionRows") ?: @[];
    NSDictionary *paths = @{@"reader":@"阅读/页面净化", @"mine":@"我的页面净化", @"shelf":@"书架净化",
        @"notifications":@"通知管理", @"gestures":@"阅读/自动阅读"};
    for (NSDictionary *option in options) {
        if ([@[@"FanqieX.ReaderEarnMore.1", @"FanqieX.MineRecommendations.1", @"FanqieX.MineBenefitsCard.1"]
            containsObject:option[@"key"]]) continue;
        FQXSettingRow *row = [FQXSettingRow new];
        row.title = option[@"title"];
        row.path = paths[option[@"category"]] ?: @"阅读/阅读设置";
        row.keywords = [NSString stringWithFormat:@"%@ %@ %@ 显示 隐藏 开启 关闭 开关", row.path, row.title, option[@"aliases"] ?: @""];
        NSDictionary *aliases = @{
            @"FanqieX.MinePublish.1":@"发帖 羽毛 写帖子 右下角",
            @"FanqieX.ReaderSpeechFloat.1":@"听书 朗读 悬浮",
            @"FanqieX.ReaderChapterCircle.1":@"书圈 圈子",
            @"FanqieX.ReaderDoubleTapAutoread.1":@"自动翻页 双击",
            @"FanqieX.ReaderAutoReadDurationLimit.1":@"时间限制 广告时长",
            @"FanqieX.NotificationsBadge.1":@"红点 数字 角标"
        };
        if (aliases[option[@"key"]]) row.keywords = [row.keywords stringByAppendingFormat:@" %@", aliases[option[@"key"]]];
        row.option = option;
        row.height = 52;
        // Existing settings retain their runtime refresh callbacks.
        if ([menu.catalog indexesOfObjectsPassingTest:^BOOL(FQXSettingRow *item, NSUInteger index, BOOL *stop) {
            (void)index; (void)stop;
            return [item.title isEqualToString:row.title];
        }].count == 0) [menu.catalog addObject:row];
    }
    FQXSettingRow *video = [FQXSettingRow new];
    video.title = @"导出当前视频";
    video.path = @"导出与备份";
    video.keywords = @"导出 下载 保存 视频 短剧 漫剧 MP4 MOV M4V 原格式";
    video.destination = @"FQXVideoExport";
    video.height = 52;
    [menu.catalog addObject:video];
    // The diagnostics card contains separate labels and controls. Give each
    // native action its own row while retaining the installed router.
    UIView *card = legacy.tableFooterView.subviews.firstObject;
    for (UIView *view in card.subviews) {
        if ([view isKindOfClass:UIButton.class]) AddView(menu, view, @"诊断与其他");
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
    // The entry is already a UITableViewController. Prepare its rows before
    // replacing the existing data source, independently of child appearances.
    [menu configureSearch];
    [menu updateRows];
    if (!menu.folders.count && !menu.visibleRows.count) return;
    menu.rootTable = legacy;
    objc_setAssociatedObject(owner, MenuKey, menu, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
    legacy.tableHeaderView = nil;
    legacy.tableFooterView = nil;
    legacy.dataSource = menu;
    legacy.delegate = menu;
    legacy.keyboardDismissMode = UIScrollViewKeyboardDismissModeOnDrag;
    [legacy reloadData];
    owner.navigationItem.leftBarButtonItem = nil;
    UIBarButtonItem *done = owner.navigationItem.rightBarButtonItems.firstObject;
    owner.navigationItem.rightBarButtonItems = done ? @[done] : @[];
    owner.navigationItem.searchController = menu.search;
    owner.navigationItem.hidesSearchBarWhenScrolling = NO;
    owner.definesPresentationContext = YES;
}

+ (BOOL)refreshOnController:(UIViewController *)owner {
    FQXSettingsMenu *menu = objc_getAssociatedObject(owner, MenuKey);
    if (!menu) return NO;
    for (FQXSettingRow *row in menu.catalog) {
        if (![row.title isEqualToString:@"短剧滚动自动收缩"]) continue;
        for (UIView *control in row.content.subviews)
            if ([control isKindOfClass:UISwitch.class]) [(UISwitch *)control setOn:[NSUserDefaults.standardUserDefaults boolForKey:CompactKey]];
    }
    [menu rebuild];
    return YES;
}
+ (BOOL)isInstalledOnController:(UIViewController *)owner {
    return objc_getAssociatedObject(owner, MenuKey) != nil;
}

- (void)configureSearch {
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
    NSMutableArray *rows = [NSMutableArray array];
    NSMutableOrderedSet *folders = [NSMutableOrderedSet orderedSet];
    NSString *prefix = self.path.length ? [self.path stringByAppendingString:@"/"] : @"";
    BOOL compact = [NSUserDefaults.standardUserDefaults boolForKey:CompactKey];
    for (FQXSettingRow *row in self.catalog) {
        if (row.requiresCompact && !compact) continue;
        if (query.length) {
            if (Matches(row.keywords, query)) [rows addObject:row];
        } else if ([row.path isEqualToString:self.path]) {
            [rows addObject:row];
        } else if ([row.path hasPrefix:prefix]) {
            NSString *next = [[row.path substringFromIndex:prefix.length] componentsSeparatedByString:@"/"].firstObject;
            if (next.length) [folders addObject:next];
        }
    }
    self.visibleRows = rows;
    self.folders = folders.array;
    return query.length > 0;
}

- (void)rebuild {
    BOOL filtering = [self updateRows];
    UITableView *table = self.rootTable ?: self.tableView;
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
    if ([self.path isEqualToString:@"阅读/页面净化"]) return @"关闭对应开关可隐藏入口。章末内容在重新进入书籍后应用。";
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
    if (row.nativeCell) return row.nativeCell;
    UITableViewCell *cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:nil];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    if (row.content) {
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
            [button removeTarget:nil action:@selector(performStoredAction:) forControlEvents:UIControlEventTouchUpInside];
            [button addTarget:self action:@selector(performStoredAction:) forControlEvents:UIControlEventTouchUpInside];
        }
        for (UIView *control in row.content.subviews) {
            if ([control isKindOfClass:UISwitch.class] && [control.accessibilityLabel isEqualToString:@"短剧滚动自动收缩"]) {
                [(UISwitch *)control removeTarget:nil action:@selector(nativeToggleChanged:) forControlEvents:UIControlEventValueChanged];
                [(UISwitch *)control addTarget:self action:@selector(nativeToggleChanged:) forControlEvents:UIControlEventValueChanged];
            }
        }
    } else {
        cell.textLabel.text = row.title;
        if (row.option) {
            UISwitch *toggle = [[UISwitch alloc] init];
            id stored = [NSUserDefaults.standardUserDefaults objectForKey:row.option[@"key"]];
            toggle.on = stored ? [stored boolValue] : [row.option[@"default"] boolValue];
            toggle.accessibilityIdentifier = row.option[@"key"];
            toggle.accessibilityLabel = row.title;
            [toggle addTarget:self action:@selector(optionChanged:) forControlEvents:UIControlEventValueChanged];
            cell.accessoryView = toggle;
        } else cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    }
    if (self.search.searchBar.text.length) {
        if (row.content) {
            UILabel *pathLabel = [[UILabel alloc] initWithFrame:CGRectMake(20, row.height, CGRectGetWidth(cell.contentView.bounds) - 40, 22)];
            pathLabel.autoresizingMask = UIViewAutoresizingFlexibleWidth;
            pathLabel.font = [UIFont systemFontOfSize:11];
            pathLabel.textColor = UIColor.secondaryLabelColor;
            pathLabel.text = [row.path stringByReplacingOccurrencesOfString:@"/" withString:@" › "];
            [cell.contentView addSubview:pathLabel];
        } else cell.detailTextLabel.text = row.path;
    }
    return cell;
}

- (void)nativeToggleChanged:(UISwitch *)toggle {
    (void)toggle;
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
        if (self.search.presentingViewController) {
            [self.search dismissViewControllerAnimated:NO completion:perform];
        } else {
            self.search.active = NO;
            perform();
        }
        return;
    }
}

- (void)optionChanged:(UISwitch *)toggle {
    [NSUserDefaults.standardUserDefaults setBool:toggle.on forKey:toggle.accessibilityIdentifier];
    Class cleanup = NSClassFromString(@"FQXCleanup");
    SEL selector = NSSelectorFromString(@"refreshForKey:");
    if ([cleanup respondsToSelector:selector])
        ((void (*)(id, SEL, id))objc_msgSend)(cleanup, selector, toggle.accessibilityIdentifier);
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)path {
    [tableView deselectRowAtIndexPath:path animated:YES];
    UIViewController *owner = self.rootTable ? self.settingsOwner : self;
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
        if (row.destination) {
            Class target = NSClassFromString(row.destination);
            SEL action = NSSelectorFromString(@"presentFromController:");
            void (^perform)(void) = ^{
                if ([target respondsToSelector:action]) ((void (*)(id, SEL, id))objc_msgSend)(target, action, owner);
            };
            if (self.search.presentingViewController) [self.search dismissViewControllerAnimated:NO completion:perform];
            else { self.search.active = NO; perform(); }
        }
    }
}
@end
