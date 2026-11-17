#import <UIKit/UIKit.h>
#import <objc/message.h>
#import <objc/runtime.h>
#import "NavigationPreferenceLogic.h"

static NSString *const StartupKey = @"FanqieX.StartupTab.1";
static NSString *const HiddenCategoriesKey = @"FanqieX.BookstoreHiddenCategories.1";
static NSString *const CategoryTitlesKey = @"FanqieX.BookstoreCategoryTitles.1";

typedef NS_ENUM(NSInteger, StartupPage) {
    StartupFollowApp, StartupBookstore, StartupDrama, StartupBookshelf, StartupMine,
};

static int (*NativeLandingType)(id, SEL);
static BOOL (*NativeLandingLast)(id, SEL);
static void (*NativeSelectType)(id, SEL, int, id, id, BOOL);
static NSArray *(*NativeBookstoreModels)(id, SEL);
static NSUInteger (*NativeBookstoreIndex)(id, SEL);
static NSSet<NSString *> *ActiveHiddenCategories;
static __weak UITabBarController *CurrentTabs;

static BOOL HasHostMethod(Class cls, SEL selector, const char *encoding) {
    Method method = class_getInstanceMethod(cls, selector);
    return method && strcmp(method_getTypeEncoding(method), encoding) == 0;
}

static IMP ReplaceHostMethod(Class cls, SEL selector, IMP replacement) {
    Method method = class_getInstanceMethod(cls, selector);
    IMP original = method_getImplementation(method);
    if (!class_addMethod(cls, selector, replacement, method_getTypeEncoding(method))) {
        method_setImplementation(method, replacement);
    }
    return original;
}

static id HostObject(id owner, SEL selector) {
    if (!HasHostMethod(object_getClass(owner), selector, "@16@0:8")) return nil;
    return ((id (*)(id, SEL))objc_msgSend)(owner, selector);
}

static NSArray<NSString *> *StoredTitles(NSString *key) {
    id value = [NSUserDefaults.standardUserDefaults objectForKey:key];
    if (![value isKindOfClass:NSArray.class]) return @[];
    NSMutableOrderedSet<NSString *> *titles = [NSMutableOrderedSet orderedSet];
    for (id title in value) {
        if ([title isKindOfClass:NSString.class] && [title length]) [titles addObject:title];
    }
    return titles.array;
}

static StartupPage StoredStartupPage(void) {
    id value = [NSUserDefaults.standardUserDefaults objectForKey:StartupKey];
    NSInteger page = [value isKindOfClass:NSNumber.class] ? [value integerValue] : StartupFollowApp;
    return page >= StartupFollowApp && page <= StartupMine ? page : StartupFollowApp;
}

static NSString *StartupTitle(StartupPage page) {
    switch (page) {
        case StartupBookstore: return @"书城";
        case StartupDrama: return @"短剧";
        case StartupBookshelf: return @"书架";
        case StartupMine: return @"我的";
        default: return @"跟随 App";
    }
}

static NSString *BottomVisibilityKey(StartupPage page) {
    switch (page) {
        case StartupBookstore: return @"FanqieX.BottomBookstore.1";
        case StartupDrama: return @"FanqieX.BottomDrama.1";
        case StartupBookshelf: return @"FanqieX.BottomBookshelf.1";
        case StartupMine: return @"FanqieX.BottomMine.1";
        default: return nil;
    }
}

static int HostTabType(StartupPage page) {
    switch (page) {
        case StartupBookstore: return 0;
        case StartupDrama: return 7;
        case StartupBookshelf: return 3;
        case StartupMine: return 4;
        default: return -1;
    }
}

static BOOL StartupPageVisible(StartupPage page, NSArray *types) {
    if (page == StartupFollowApp) return YES;
    id value = [NSUserDefaults.standardUserDefaults objectForKey:BottomVisibilityKey(page)];
    if ([value isKindOfClass:NSNumber.class] && ![value boolValue]) return NO;
    return ![types isKindOfClass:NSArray.class] || !types.count || [types containsObject:@(HostTabType(page))];
}

static int ChosenHostType(NSArray *types) {
    StartupPage page = StoredStartupPage();
    if (![types isKindOfClass:NSArray.class] || !types.count || !StartupPageVisible(page, types)) return -1;
    return HostTabType(page);
}

static int StartupLandingType(id alignment, SEL selector) {
    int choice = ChosenHostType(HostObject(alignment, @selector(tabBarTypes)));
    return choice >= 0 ? choice : NativeLandingType(alignment, selector);
}

static BOOL StartupLandingLast(id alignment, SEL selector) {
    return ChosenHostType(HostObject(alignment, @selector(tabBarTypes))) < 0 && NativeLandingLast(alignment, selector);
}

static void StartupSelectType(id tabs, SEL selector, int type, id source, id params, BOOL coldStart) {
    CurrentTabs = tabs;
    if (coldStart) {
        NSArray *types = HostObject(tabs, @selector(typeArray));
        if ([types isKindOfClass:NSArray.class] && [types.firstObject isKindOfClass:NSNumber.class]) {
            type = FQXResolveColdLanding(ChosenHostType(types), type, [types containsObject:@(type)],
                                        [types.firstObject intValue]);
        }
    }
    NativeSelectType(tabs, selector, type, source, params, coldStart);
}

static NSArray *BookstoreProjection(NSArray *models, BOOL rememberTitles) {
    if (![models isKindOfClass:NSArray.class] || !models.count) return models;
    NSMutableOrderedSet<NSString *> *titles = rememberTitles ? [NSMutableOrderedSet orderedSet] : nil;
    NSMutableArray *visible = ActiveHiddenCategories.count ? [NSMutableArray arrayWithCapacity:models.count] : nil;
    for (id model in models) {
        id title = HostObject(model, @selector(title));
        NSString *name = [title isKindOfClass:NSString.class] && [title length] ? title : nil;
        if (name) [titles addObject:name];
        if (!name || ![ActiveHiddenCategories containsObject:name]) [visible addObject:model];
    }
    if (titles.count) {
        NSUserDefaults *defaults = NSUserDefaults.standardUserDefaults;
        NSArray *actual = titles.array;
        if (![actual isEqual:[defaults objectForKey:CategoryTitlesKey]]) [defaults setObject:actual forKey:CategoryTitlesKey];
    }
    return FQXUseBookstoreSubset(visible.count, models.count) ? visible.copy : models;
}

static NSArray *BookstoreModels(id manager, SEL selector) {
    return BookstoreProjection(NativeBookstoreModels(manager, selector), YES);
}

static NSUInteger BookstoreSelectedIndex(id manager, SEL selector) {
    NSArray *stock = NativeBookstoreModels(manager, @selector(models));
    NSArray *visible = BookstoreProjection(stock, NO);
    if (visible == stock) return NativeBookstoreIndex(manager, selector);
    int lastType = ((int (*)(id, SEL))objc_msgSend)(manager, @selector(lastTabValueIgnoreUID));
    id selected = ((id (*)(id, SEL, int))objc_msgSend)(manager, @selector(getTabModelWithTabValue:), lastType);
    NSUInteger index = selected ? [visible indexOfObjectIdenticalTo:selected] : NSNotFound;
    return FQXProjectedBookstoreIndex(index, visible.count);
}

@interface FQXNavigationOptionsController : UITableViewController
@property(nonatomic) BOOL bookstore;
@property(nonatomic, copy) NSArray<NSString *> *categories;
@property(nonatomic, copy) NSArray<NSNumber *> *startupPages;
@end

@implementation FQXNavigationOptionsController

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    self.categories = StoredTitles(CategoryTitlesKey);
    NSArray *types = HostObject(CurrentTabs, @selector(typeArray));
    NSMutableArray<NSNumber *> *pages = [NSMutableArray array];
    for (StartupPage page = StartupFollowApp; page <= StartupMine; ++page) {
        if (StartupPageVisible(page, types)) [pages addObject:@(page)];
    }
    self.startupPages = pages;
    [self.tableView reloadData];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.bookstore ? self.categories.count : self.startupPages.count;
}

- (NSString *)tableView:(UITableView *)tableView titleForFooterInSection:(NSInteger)section {
    if (self.bookstore && !self.categories.count) return @"打开书城并加载后，这里会显示可管理的分类。";
    if (self.bookstore) return @"至少保留一个分类。重启 App 后应用。";
    return @"下次启动时打开所选页面。底栏隐藏的页面不会出现在选项里。";
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)path {
    static NSString *const identifier = @"FQXNavigationOption";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier];
    if (!cell) cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identifier];
    if (!self.bookstore) {
        StartupPage page = self.startupPages[path.row].integerValue;
        StartupPage saved = StoredStartupPage();
        if (![self.startupPages containsObject:@(saved)]) saved = StartupFollowApp;
        cell.textLabel.text = StartupTitle(page);
        cell.accessoryType = page == saved ? UITableViewCellAccessoryCheckmark : UITableViewCellAccessoryNone;
        return cell;
    }
    NSString *title = self.categories[path.row];
    NSArray *hidden = StoredTitles(HiddenCategoriesKey);
    NSUInteger visibleCount = 0;
    for (NSString *name in self.categories) if (![hidden containsObject:name]) ++visibleCount;
    UISwitch *toggle = [[UISwitch alloc] init];
    toggle.tag = path.row;
    toggle.on = ![hidden containsObject:title];
    toggle.enabled = !toggle.on || visibleCount > 1;
    toggle.accessibilityLabel = title;
    [toggle addTarget:self action:@selector(toggleCategory:) forControlEvents:UIControlEventValueChanged];
    cell.textLabel.text = title;
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    cell.accessoryView = toggle;
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)path {
    if (self.bookstore) return;
    StartupPage page = self.startupPages[path.row].integerValue;
    [NSUserDefaults.standardUserDefaults setInteger:page forKey:StartupKey];
    [tableView deselectRowAtIndexPath:path animated:YES];
    [tableView reloadData];
}

- (void)toggleCategory:(UISwitch *)sender {
    NSString *title = self.categories[sender.tag];
    NSMutableOrderedSet<NSString *> *hidden = [NSMutableOrderedSet orderedSetWithArray:StoredTitles(HiddenCategoriesKey)];
    if (sender.on) [hidden removeObject:title]; else [hidden addObject:title];
    for (NSString *name in self.categories) {
        if (![hidden containsObject:name]) {
            [NSUserDefaults.standardUserDefaults setObject:hidden.array forKey:HiddenCategoriesKey];
            break;
        }
    }
    [self.tableView reloadData];
}

- (void)closeOptions {
    [self dismissViewControllerAnimated:YES completion:nil];
}

@end

@interface FQXNavigationPreferences : NSObject
+ (void)install;
+ (void)openStartupFromController:(UIViewController *)controller;
+ (void)openBookstoreFromController:(UIViewController *)controller;
@end

@implementation FQXNavigationPreferences

+ (void)install {
    static dispatch_once_t once;
    dispatch_once(&once, ^{
        ActiveHiddenCategories = [NSSet setWithArray:StoredTitles(HiddenCategoriesKey)];
        Class alignment = objc_lookUpClass("SSBookStoreAlignmentData");
        if (HasHostMethod(alignment, @selector(landingTabBarType), "i16@0:8") &&
            HasHostMethod(alignment, @selector(landingToLastTab), "B16@0:8")) {
            NativeLandingType = (void *)ReplaceHostMethod(alignment, @selector(landingTabBarType), (IMP)StartupLandingType);
            NativeLandingLast = (void *)ReplaceHostMethod(alignment, @selector(landingToLastTab), (IMP)StartupLandingLast);
        }
        Class tabs = objc_lookUpClass("SSTabBarController");
        SEL selection = @selector(setCurrentSelectType:enterFrom:params:isFirstEnterTabAfterColdStart:);
        if (HasHostMethod(tabs, selection, "v40@0:8i16@20@28B36")) {
            NativeSelectType = (void *)ReplaceHostMethod(tabs, selection, (IMP)StartupSelectType);
        }
        Class bookstore = objc_lookUpClass("SSBookStoreManager");
        if (HasHostMethod(bookstore, @selector(models), "@16@0:8") &&
            HasHostMethod(bookstore, @selector(getCurrentTabIndex), "Q16@0:8") &&
            HasHostMethod(bookstore, @selector(lastTabValueIgnoreUID), "i16@0:8") &&
            HasHostMethod(bookstore, @selector(getTabModelWithTabValue:), "@20@0:8i16")) {
            NativeBookstoreModels = (void *)ReplaceHostMethod(bookstore, @selector(models), (IMP)BookstoreModels);
            NativeBookstoreIndex = (void *)ReplaceHostMethod(bookstore, @selector(getCurrentTabIndex), (IMP)BookstoreSelectedIndex);
        }
    });
}

+ (void)openBookstore:(BOOL)bookstore fromController:(UIViewController *)source {
    if (![source isKindOfClass:UIViewController.class]) return;
    FQXNavigationOptionsController *page = [[FQXNavigationOptionsController alloc] initWithStyle:UITableViewStyleInsetGrouped];
    page.bookstore = bookstore;
    page.title = bookstore ? @"书城顶部分类" : @"默认启动页";
    if (source.navigationController) {
        [source.navigationController pushViewController:page animated:YES];
    } else {
        page.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"完成"
            style:UIBarButtonItemStyleDone target:page action:@selector(closeOptions)];
        [source presentViewController:[[UINavigationController alloc] initWithRootViewController:page] animated:YES completion:nil];
    }
}

+ (void)openStartupFromController:(UIViewController *)controller {
    [self openBookstore:NO fromController:controller];
}

+ (void)openBookstoreFromController:(UIViewController *)controller {
    [self openBookstore:YES fromController:controller];
}

@end
