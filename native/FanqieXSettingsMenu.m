#import <UIKit/UIKit.h>
#import <objc/message.h>
#import <objc/runtime.h>
#import "FQXBlurControl.h"
#import "FQXLayoutAndSheetPolicy.h"
#import "FQXSiriaiDockMotion.h"
#import "FanqieXDetachedDock.h"
#import "FanqieXDiagnosticsHub.h"
#import "FanqieXNaloia.h"
#import "FanqieXReleaseNotes.h"

@interface FQXReleaseHistoryController : UITableViewController
@end

@implementation FQXReleaseHistoryController
- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"历代更新";
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc]
        initWithBarButtonSystemItem:UIBarButtonSystemItemDone target:self action:@selector(closeHistory)];
    [self.tableView registerClass:UITableViewCell.class forCellReuseIdentifier:@"ReleaseNote"];
    self.tableView.rowHeight = UITableViewAutomaticDimension;
}

- (void)closeHistory {
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return sizeof(FQXReleaseNotes) / sizeof(FQXReleaseNotes[0]);
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"ReleaseNote" forIndexPath:indexPath];
    const FQXReleaseNote *entry = &FQXReleaseNotes[indexPath.row];
    UIListContentConfiguration *content = [UIListContentConfiguration subtitleCellConfiguration];
    content.text = entry->version;
    content.secondaryText = entry->summary;
    content.secondaryTextProperties.numberOfLines = 0;
    cell.contentConfiguration = content;
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    return cell;
}
@end

@interface FQXReleaseNotesController : UIViewController
- (void)showHistory;
@end

@implementation FQXReleaseNotesController
- (void)showHistory {
    if (self.presentedViewController) return;
    FQXReleaseHistoryController *history = [[FQXReleaseHistoryController alloc] initWithStyle:UITableViewStyleInsetGrouped];
    UINavigationController *sheet = [[UINavigationController alloc] initWithRootViewController:history];
    sheet.modalPresentationStyle = UIModalPresentationPageSheet;
    [self presentViewController:sheet animated:YES completion:nil];
}
@end

static const void *MenuKey = &MenuKey;
static const void *RowKey = &RowKey;
static NSString *const CompactKey = @"FanqieX.BottomDramaCompact.1";
static NSString *const ScrollZoomKey = @"FanqieX.DramaDockScrollZoom.1";
static NSString *const DockCollapseModeKey = @"FanqieX.DockCollapseMode.1";
static NSString *const DockSiriaiHideLineKey = @"FanqieX.DockSiriaiHideLine.1";
static NSString *const CompactPositionKey = @"FanqieX.BottomDramaCompactPosition.1";
static NSString *const FollowWidthKey = @"FanqieX.DramaFollowBottomWidth.1";
static NSString *const BottomEntryTitlePrefix = @"底栏显示：";
static NSString *const StartupTabKey = @"FanqieX.StartupTab.1";
static NSString *const CommentMaterialStyleKey = @"FanqieX.CommentMaterialStyle.1";
static NSString *const CommentAppearanceModeKey = @"FanqieX.CommentAppearanceMode.1";
static NSString *const CommentComposerStyleKey = @"FanqieX.CommentComposerStyle.1";
static NSString *const BottomDisplayModeKey = @"FanqieX.BottomDisplayMode.1";
static NSString *const DockMaterialKey = @"FanqieX.DockMaterial.1";
static NSString *const SelectionTintStyleKey = @"FanqieX.SelectionTintStyle.1";
static NSString *const DockSelectionTintStyleKey = @"FanqieX.DockSelectionTintStyle.1";
static NSString *const DramaTopSelectionTintStyleKey = @"FanqieX.DramaTopSelectionTintStyle.1";
static NSString *const DramaButtonSurfaceStyleKey = @"FanqieX.DramaButtonSurfaceStyle.1";
static NSString *const DockBlurKey = @"FanqieX.DockBlur.1";
static NSString *const ShareMaterialStyleKey = @"FanqieX.ShareMaterialStyle.1";
static NSString *const ShareBlurKey = @"FanqieX.ShareBlur.1";
static NSString *const AudioMoreBlurKey = @"FanqieX.AudioMoreBlur.1";
static NSString *const AudioSheetMaterialKey = @"FanqieX.AudioSheetMaterial.1";
static NSString *const AudioSheetBlurKey = @"FanqieX.AudioSheetBlur.1";
static NSString *const DramaPlaybackOptionsMaterialKey = @"FanqieX.DramaPlaybackOptionsMaterial.1";
static NSString *const DramaPlaybackOptionsBlurKey = @"FanqieX.DramaPlaybackOptionsBlur.1";
static NSString *const DramaHeaderButtonScaleKey = @"FanqieX.DramaHeaderButtonScale.1";
static const char BlurSliderKey;
static NSString *const BottomIconsOnlyLegacyKey = @"FanqieX.BottomIconsOnly.1";

static NSInteger ClampSliderPercent(double value, double minVal, double maxVal) {
    if (!isfinite(value)) return (NSInteger)llround(minVal);
    NSInteger rounded = (NSInteger)llround(value);
    NSInteger lo = (NSInteger)llround(minVal);
    NSInteger hi = (NSInteger)llround(maxVal);
    if (rounded < lo) return lo;
    if (rounded > hi) return hi;
    return rounded;
}

@interface FQXBlurSlider : UISlider
@property(nonatomic, weak) UILabel *valueLabel;
@property(nonatomic, weak) UIStepper *stepper;
@end

@implementation FQXBlurSlider
- (void)accessibilityIncrement {
    self.value = (float)ClampSliderPercent(self.value + 1.0, self.minimumValue, self.maximumValue);
    [self sendActionsForControlEvents:UIControlEventValueChanged];
}
- (void)accessibilityDecrement {
    self.value = (float)ClampSliderPercent(self.value - 1.0, self.minimumValue, self.maximumValue);
    [self sendActionsForControlEvents:UIControlEventValueChanged];
}
@end

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
@property(nonatomic) BOOL requiresSiriai;
@property(nonatomic) BOOL inverted;
@property(nonatomic) BOOL diagnosticExport;
@property(nonatomic) BOOL authorInformation;
@property(nonatomic) BOOL hiddenFromSearch;
@property(nonatomic, copy) NSString *blurKey;
@property(nonatomic) NSInteger sliderMin;
@property(nonatomic) NSInteger sliderMax;
@property(nonatomic) NSInteger sliderDefault;
@property(nonatomic, copy) NSString *popoverKey;
@property(nonatomic, copy) NSArray<NSString *> *popoverOptions;
@property(nonatomic, copy) NSArray<NSNumber *> *popoverValues;
@property(nonatomic) NSInteger popoverKind;
@property(nonatomic) NSInteger matchScore;
@end
@implementation FQXSettingRow
@end

@interface FQXSettingsMenu : UITableViewController <UISearchResultsUpdating, UIPopoverPresentationControllerDelegate>
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
- (void)showReleaseNotes:(UIButton *)sender;
- (void)dismissSettings:(id)sender;
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
        [title isEqualToString:@"短剧滚动自动收缩"] || [title isEqualToString:@"刷视频时自动缩放 Dock"] ||
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
    if ([title isEqualToString:@"收缩位置"]) {
        row.content = nil;
        row.popoverKey = CompactPositionKey;
        row.popoverOptions = @[@"左侧", @"居中", @"右侧"];
        row.popoverValues = @[@1, @2, @0];
        row.popoverKind = 6;
        row.requiresCompact = YES;
        row.height = 52;
    } else if ([title isEqualToString:@"默认启动页"]) {
        row.content = nil;
        row.popoverKey = StartupTabKey;
        row.popoverOptions = @[@"跟随 App", @"书城", @"短剧", @"书架", @"我的"];
        row.popoverValues = @[@0, @1, @2, @3, @4];
        row.popoverKind = 7;
        row.height = 52;
    }
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
    if ([title containsString:@"作者声明"]) row.keywords = [row.keywords stringByAppendingString:@" 短剧 漫剧 作者声明 AI生成 内容由AI生成 声明 隐藏 关闭"];
    if ([title containsString:@"阅读原著"]) row.keywords = [row.keywords stringByAppendingString:@" 短剧 漫剧 原著 阅读原著 同名小说 底部栏 进度条上方 隐藏 关闭"];
    [menu.catalog addObject:row];
}

static NSInteger CurrentSavedCommentMaterialStyle(void) {
    NSUserDefaults *ud = NSUserDefaults.standardUserDefaults;
    if ([ud objectForKey:@"FanqieX.CommentGlassFrosted.1"]) [ud removeObjectForKey:@"FanqieX.CommentGlassFrosted.1"];
    if ([ud objectForKey:@"FanqieX.CommentMaterialMode.1"]) [ud removeObjectForKey:@"FanqieX.CommentMaterialMode.1"];
    id stored = [ud objectForKey:CommentMaterialStyleKey];
    if (!stored) return 0;
    NSInteger val = [stored respondsToSelector:@selector(integerValue)] ? [stored integerValue] : 0;
    if (val == 3) return 0;
    return (val >= 0 && val <= 4) ? val : 0;
}

static NSInteger CurrentSavedShareMaterialStyle(void) {
    id stored = [NSUserDefaults.standardUserDefaults objectForKey:ShareMaterialStyleKey];
    if (!stored) return 1;
    NSInteger val = [stored respondsToSelector:@selector(integerValue)] ? [stored integerValue] : 1;
    if (val == 3) return 0;
    return (val >= 0 && val <= 4) ? val : 1;
}

static NSInteger CurrentSavedSplitSelectionStyle(NSString *specificKey) {
    NSUserDefaults *ud = NSUserDefaults.standardUserDefaults;
    id specObj = specificKey.length ? [ud objectForKey:specificKey] : nil;
    id legObj = [ud objectForKey:SelectionTintStyleKey];
    int hasSpec = (specObj && [specObj respondsToSelector:@selector(integerValue)]) ? 1 : 0;
    int hasLeg = (legObj && [legObj respondsToSelector:@selector(integerValue)]) ? 1 : 0;
    return (NSInteger)FQXResolveSplitSelectionTintStyle(
        hasSpec,
        hasSpec ? (int)[specObj integerValue] : 0,
        hasLeg,
        hasLeg ? (int)[legObj integerValue] : 0);
}

static NSInteger CurrentSavedAudioSheetMaterialStyle(void) {
    id stored = [NSUserDefaults.standardUserDefaults objectForKey:AudioSheetMaterialKey];
    if (!stored) return 1;
    NSInteger val = [stored respondsToSelector:@selector(integerValue)] ? [stored integerValue] : 1;
    if (val == 3) return 0;
    return (val >= 0 && val <= 4) ? val : 1;
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

static NSInteger CurrentSavedDockCollapseMode(void) {
    NSUserDefaults *ud = NSUserDefaults.standardUserDefaults;
    id stored = [ud objectForKey:DockCollapseModeKey];
    int raw = (stored && [stored respondsToSelector:@selector(intValue)]) ? [stored intValue] : -1;
    return (NSInteger)FQXResolveDockCollapseMode(raw, [ud boolForKey:CompactKey] ? 1 : 0, [ud boolForKey:ScrollZoomKey] ? 1 : 0);
}

static NSInteger CurrentSavedCommentComposerStyle(void) {
    NSUserDefaults *ud = NSUserDefaults.standardUserDefaults;
    NSInteger material = CurrentSavedCommentMaterialStyle();
    id stored = [ud objectForKey:CommentComposerStyleKey];
    if (stored && [stored respondsToSelector:@selector(integerValue)]) {
        NSInteger val = [stored integerValue];
        if (val >= 0 && val <= 2) return val;
    }
    return (material == 1 || material == 2 || material == 4) ? 1 : 0;
}

static void StartupPopoverChoices(NSArray<NSString *> **outOptions, NSArray<NSNumber *> **outValues) {
    NSUserDefaults *ud = NSUserDefaults.standardUserDefaults;
    NSMutableArray<NSString *> *options = [NSMutableArray arrayWithObject:@"跟随 App"];
    NSMutableArray<NSNumber *> *values = [NSMutableArray arrayWithObject:@0];
    NSArray<NSArray *> *tabs = @[
        @[@1, @"书城", @"FanqieX.BottomBookstore.1"],
        @[@2, @"短剧", @"FanqieX.BottomDrama.1"],
        @[@3, @"书架", @"FanqieX.BottomBookshelf.1"],
        @[@4, @"我的", @"FanqieX.BottomMine.1"],
    ];
    for (NSArray *item in tabs) {
        id stored = [ud objectForKey:item[2]];
        if ([stored isKindOfClass:NSNumber.class] && ![stored boolValue]) continue;
        [options addObject:item[1]];
        [values addObject:item[0]];
    }
    if (outOptions) *outOptions = options;
    if (outValues) *outValues = values;
}

static NSInteger PopoverOptionsAndCurrentIndex(FQXSettingRow *row,
                                               NSArray<NSString *> **outOptions,
                                               NSArray<NSNumber *> **outValues) {
    NSArray<NSString *> *options = row.popoverOptions ?: @[];
    NSArray<NSNumber *> *values = row.popoverValues;
    NSInteger idx = 0;
    if (row.popoverKind == 1) {
        idx = CurrentSavedBottomDisplayMode();
    } else if (row.popoverKind == 2) {
        idx = CurrentSavedCommentComposerStyle();
    } else if (row.popoverKind == 4) {
        NSInteger saved = CurrentSavedCommentMaterialStyle();
        NSUInteger found = values.count == options.count ? [values indexOfObject:@(saved)] : NSNotFound;
        idx = (found != NSNotFound) ? (NSInteger)found : 0;
    } else if (row.popoverKind == 5) {
        idx = CurrentSavedCommentAppearanceMode();
    } else if (row.popoverKind == 6) {
        NSNumber *saved = [NSUserDefaults.standardUserDefaults objectForKey:CompactPositionKey];
        NSUInteger found = [values indexOfObject:saved ?: @0];
        idx = found == NSNotFound ? 2 : (NSInteger)found;
    } else if (row.popoverKind == 7) {
        StartupPopoverChoices(&options, &values);
        NSInteger saved = [NSUserDefaults.standardUserDefaults integerForKey:row.popoverKey];
        NSUInteger found = [values indexOfObject:@(saved)];
        idx = (found != NSNotFound) ? (NSInteger)found : 0;
    } else if (row.popoverKind == 8) {
        NSArray<NSString *> *mods = FQXDockDetachedAllKnownModules();
        options = mods;
        values = nil;
        NSString *saved = FQXDockDetachedStoredModule();
        if (saved.length > 0) {
            NSUInteger found = [mods indexOfObject:saved];
            idx = (found != NSNotFound) ? (NSInteger)found : -1;
        } else {
            NSArray<NSString *> *avail = FQXDockDetachedAvailableModules();
            NSString *defMod = avail.lastObject ?: mods.lastObject;
            NSUInteger found = defMod ? [mods indexOfObject:defMod] : NSNotFound;
            idx = (found != NSNotFound) ? (NSInteger)found : -1;
        }
        if (outOptions) *outOptions = options;
        if (outValues) *outValues = nil;
        return idx;
    } else if (row.popoverKind == 10) {
        NSInteger saved = CurrentSavedShareMaterialStyle();
        NSUInteger found = values.count == options.count ? [values indexOfObject:@(saved)] : NSNotFound;
        idx = (found != NSNotFound) ? (NSInteger)found : 1;
    } else if (row.popoverKind == 11) {
        idx = CurrentSavedDockCollapseMode();
    } else if (row.popoverKind == 12) {
        NSInteger saved = CurrentSavedAudioSheetMaterialStyle();
        NSUInteger found = values.count == options.count ? [values indexOfObject:@(saved)] : NSNotFound;
        idx = (found != NSNotFound) ? (NSInteger)found : 1;
    } else if (row.popoverKind == 13) {
        NSInteger saved = CurrentSavedSplitSelectionStyle(row.popoverKey);
        NSUInteger found = values.count == options.count ? [values indexOfObject:@(saved)] : NSNotFound;
        idx = (found != NSNotFound) ? (NSInteger)found : 0;
    } else if (values.count == options.count && options.count > 0) {
        NSInteger saved = [NSUserDefaults.standardUserDefaults integerForKey:row.popoverKey];
        NSUInteger found = [values indexOfObject:@(saved)];
        if (found != NSNotFound) {
            idx = (NSInteger)found;
        } else {
            NSUInteger fallback = [values indexOfObject:@0];
            idx = (fallback != NSNotFound) ? (NSInteger)fallback : 0;
        }
    } else {
        idx = [NSUserDefaults.standardUserDefaults integerForKey:row.popoverKey];
    }
    if (idx < 0 || (NSUInteger)idx >= options.count) idx = 0;
    if (outOptions) *outOptions = options;
    if (outValues) *outValues = values;
    return idx;
}

static void AddDockCollapseModeRows(FQXSettingsMenu *menu, NSString *route, BOOL hiddenFromSearch) {
    FQXSettingRow *modeRow = [FQXSettingRow new];
    modeRow.title = @"动态收缩底栏";
    modeRow.path = route;
    modeRow.hiddenFromSearch = hiddenFromSearch;
    modeRow.keywords = @"动态收缩底栏 底栏收缩 短剧 书城 书架 我的 首页 底栏 Dock 原有收缩模式 TikTok 交互 Siri AI 交互 缩小 放大 收起 短线 上滑 下滑";
    modeRow.popoverKey = DockCollapseModeKey;
    modeRow.popoverOptions = @[@"关闭", @"原有收缩模式", @"TikTok 交互", @"Siri AI 交互"];
    modeRow.popoverValues = @[@0, @1, @2, @3];
    modeRow.popoverKind = 11;
    modeRow.height = 52;
    [menu.catalog addObject:modeRow];

    FQXSettingRow *hideLineRow = [FQXSettingRow new];
    hideLineRow.title = @"Siri AI 收缩后隐藏短线";
    hideLineRow.path = route;
    hideLineRow.hiddenFromSearch = hiddenFromSearch;
    hideLineRow.requiresSiriai = YES;
    hideLineRow.option = @{@"key": DockSiriaiHideLineKey, @"default": @NO,
                           @"detail": @"收缩成白色短线后自动淡出，下拉可恢复"};
    hideLineRow.keywords = @"Siri AI 收缩后隐藏短线 短线 白条 隐藏 自动淡出 底栏 Dock";
    hideLineRow.height = 58;
    [menu.catalog addObject:hideLineRow];
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

static void AddDetachedDockModuleRow(FQXSettingsMenu *menu, NSString *route, BOOL hiddenFromSearch) {
    FQXSettingRow *modRow = [FQXSettingRow new];
    modRow.title = @"选择独立模块";
    modRow.path = route;
    modRow.hiddenFromSearch = hiddenFromSearch;
    modRow.keywords = @"选择独立模块 独立模块 独立圆形模块 圆形按钮 右侧按钮 底栏 dock 书城 短剧 书架 我的 商城";
    modRow.popoverKey = FQXDockDetachedModulePrefKey;
    modRow.popoverOptions = @[@"自动"];
    modRow.popoverKind = 8;
    modRow.height = 52;
    [menu.catalog addObject:modRow];
}

static void AddDiagCategoryFilterRow(FQXSettingsMenu *menu) {
    FQXSettingRow *filterRow = [FQXSettingRow new];
    filterRow.title = @"导出日志类别过滤";
    filterRow.path = @"诊断与其他";
    filterRow.keywords = @"导出日志 类别 过滤 筛选 网络请求 Hook 拦截 视图生命周期 听书 段落定位 安全验证 底栏 诊断 JSON";
    filterRow.popoverKey = FQXDiagCategoryFilterPrefKey;
    filterRow.popoverOptions = @[@"全部类别", @"网络请求", @"Hook 拦截", @"视图生命周期", @"听书与段落定位", @"安全验证与启动", @"底栏与界面"];
    filterRow.popoverKind = 9;
    filterRow.height = 52;
    [menu.catalog addObject:filterRow];
}

static void AddBlurRowEx(FQXSettingsMenu *menu,
                         NSString *route,
                         NSString *title,
                         NSString *key,
                         BOOL hiddenFromSearch,
                         NSString *keywords) {
    FQXSettingRow *blur = [FQXSettingRow new];
    blur.title = title;
    blur.path = route;
    blur.hiddenFromSearch = hiddenFromSearch;
    blur.keywords = keywords ?: @"模糊程度 模糊强度 自定义 玻璃";
    blur.blurKey = key;
    blur.sliderMin = 0;
    blur.sliderMax = 100;
    blur.sliderDefault = 0;
    blur.height = 82;
    [menu.catalog addObject:blur];
}

static void AddBlurRow(FQXSettingsMenu *menu, NSString *route, NSString *title, NSString *key) {
    AddBlurRowEx(menu, route, title, key, NO, nil);
}

static void AddPlaybackOptionsStyleRows(FQXSettingsMenu *menu, NSString *route, BOOL hiddenFromSearch) {
    FQXSettingRow *playbackOptionsMaterial = [FQXSettingRow new];
    playbackOptionsMaterial.title = @"长按播放选项面板材质";
    playbackOptionsMaterial.path = route;
    playbackOptionsMaterial.hiddenFromSearch = hiddenFromSearch;
    playbackOptionsMaterial.keywords = @"短剧 漫剧 长按视频 长按面板 更多 播放选项 倍速 清晰度 弹幕设置 液态玻璃 清透玻璃 模糊玻璃 高斯模糊";
    playbackOptionsMaterial.popoverKey = DramaPlaybackOptionsMaterialKey;
    playbackOptionsMaterial.popoverOptions = @[@"跟随 Dock", @"原版默认", @"清透玻璃", @"模糊玻璃", @"高斯模糊"];
    playbackOptionsMaterial.popoverValues = @[@0, @(-1), @1, @4, @2];
    playbackOptionsMaterial.height = 52;
    [menu.catalog addObject:playbackOptionsMaterial];
    AddBlurRowEx(menu,
                 route,
                 @"长按播放选项面板额外模糊",
                 DramaPlaybackOptionsBlurKey,
                 hiddenFromSearch,
                 @"短剧 长按面板 播放选项 模糊程度 额外模糊 液态玻璃 模糊玻璃 高斯模糊");
}

static void AddScaleSliderRow(FQXSettingsMenu *menu,
                              NSString *route,
                              NSString *title,
                              NSString *key,
                              NSInteger minVal,
                              NSInteger maxVal,
                              NSInteger defVal,
                              BOOL hiddenFromSearch,
                              NSString *keywords) {
    FQXSettingRow *row = [FQXSettingRow new];
    row.title = title;
    row.path = route;
    row.hiddenFromSearch = hiddenFromSearch;
    row.keywords = keywords ?: @"大小 尺寸 缩放 自定义";
    row.blurKey = key;
    row.sliderMin = minVal;
    row.sliderMax = maxVal;
    row.sliderDefault = defVal;
    row.height = 82;
    [menu.catalog addObject:row];
}

static void AddShareStyleRows(FQXSettingsMenu *menu, NSString *route, BOOL hiddenFromSearch, BOOL includeBlur) {
    FQXSettingRow *shareRow = [FQXSettingRow new];
    shareRow.title = @"分享页面材质";
    shareRow.path = route;
    shareRow.hiddenFromSearch = hiddenFromSearch;
    shareRow.keywords = @"分享页面材质 分享面板 分享页面 分享 分享弹窗 短剧分享 小说分享 液态玻璃 模糊玻璃 清透玻璃 高斯模糊 毛玻璃 磨砂 原版默认 材质 玻璃 透明";
    shareRow.popoverKey = ShareMaterialStyleKey;
    shareRow.popoverOptions = @[@"原版默认", @"液态玻璃", @"模糊玻璃", @"高斯模糊"];
    shareRow.popoverValues = @[@0, @1, @4, @2];
    shareRow.popoverKind = 10;
    shareRow.height = 52;
    [menu.catalog addObject:shareRow];

    if (includeBlur) {
        FQXSettingRow *blur = [FQXSettingRow new];
        blur.title = @"分享页面额外模糊";
        blur.path = route;
        blur.hiddenFromSearch = hiddenFromSearch;
        blur.keywords = @"分享页面模糊程度 分享 模糊程度 模糊强度 液态玻璃 高斯模糊 短剧 小说";
        blur.blurKey = ShareBlurKey;
        blur.sliderMin = 0;
        blur.sliderMax = 100;
        blur.sliderDefault = 0;
        blur.height = 82;
        [menu.catalog addObject:blur];
    }
}

static void AddAudioSheetStyleRows(FQXSettingsMenu *menu, NSString *route, BOOL hiddenFromSearch) {
    FQXSettingRow *matRow = [FQXSettingRow new];
    matRow.title = @"听书弹窗材质";
    matRow.path = route;
    matRow.hiddenFromSearch = hiddenFromSearch;
    matRow.keywords = @"听书弹窗材质 听书 弹窗 面板 半屏 章评 选择章节 下载 已加书架 语速 定时关闭 播放目录 简介 音色设置 更多 分享 液态玻璃 模糊玻璃 清透玻璃 高斯模糊 原版默认 智能朗读 真人讲书";
    matRow.popoverKey = AudioSheetMaterialKey;
    matRow.popoverOptions = @[@"原版默认", @"液态玻璃", @"模糊玻璃", @"高斯模糊"];
    matRow.popoverValues = @[@0, @1, @4, @2];
    matRow.popoverKind = 12;
    matRow.height = 52;
    [menu.catalog addObject:matRow];

    AddBlurRowEx(menu,
                 route,
                 @"听书弹窗模糊程度",
                 AudioSheetBlurKey,
                 hiddenFromSearch,
                 @"听书弹窗模糊程度 听书 更多 分享 章评 选择章节 下载 已加书架 语速 定时关闭 播放目录 音色设置 弹窗 面板 模糊程度 模糊强度 模糊度 自定义 液态玻璃 模糊玻璃 高斯模糊 智能朗读 真人讲书");
}

static void AddDockSelectionTintRow(FQXSettingsMenu *menu, NSString *route, BOOL hiddenFromSearch) {
    FQXSettingRow *selRow = [FQXSettingRow new];
    selRow.title = @"Dock 选中色";
    selRow.path = route;
    selRow.hiddenFromSearch = hiddenFromSearch;
    selRow.keywords = @"Dock 选中色 底栏 选中色 选中 胶囊 柔性粉雾 粉雾玻璃 粉雾 粉色 液态玻璃 透明 渐变 颜色 视频同款";
    selRow.popoverKey = DockSelectionTintStyleKey;
    selRow.popoverOptions = @[@"默认", @"柔性粉雾", @"粉雾玻璃"];
    selRow.popoverValues = @[@0, @1, @2];
    selRow.popoverKind = 13;
    selRow.height = 52;
    [menu.catalog addObject:selRow];
}

static void AddDramaTopStyleRows(FQXSettingsMenu *menu, NSString *route, BOOL hiddenFromSearch) {
    FQXSettingRow *baseRow = [FQXSettingRow new];
    baseRow.title = @"短剧顶部与按钮底色";
    baseRow.path = route;
    baseRow.hiddenFromSearch = hiddenFromSearch;
    baseRow.keywords = @"短剧顶部与按钮底色 短剧 顶部按钮 按钮 底色 粉雾玻璃 柔性粉雾 液态玻璃 透明 粉色 视频同款 非玻璃 哑光 灰白 搜索 查看全集 全屏 弹幕 横屏";
    baseRow.popoverKey = DramaButtonSurfaceStyleKey;
    baseRow.popoverOptions = @[@"默认液态玻璃", @"视频同款底色（非玻璃）", @"粉雾玻璃"];
    baseRow.popoverValues = @[@0, @1, @2];
    baseRow.height = 52;
    [menu.catalog addObject:baseRow];

    FQXSettingRow *topSelRow = [FQXSettingRow new];
    topSelRow.title = @"短剧顶部按钮选中色";
    topSelRow.path = route;
    topSelRow.hiddenFromSearch = hiddenFromSearch;
    topSelRow.keywords = @"短剧顶部按钮选中色 顶部按钮 选中色 顶部分类 选中 胶囊 柔性粉雾 粉雾玻璃 粉雾 粉色 液态玻璃 透明 渐变 颜色 短剧 视频同款";
    topSelRow.popoverKey = DramaTopSelectionTintStyleKey;
    topSelRow.popoverOptions = @[@"默认", @"柔性粉雾", @"粉雾玻璃"];
    topSelRow.popoverValues = @[@0, @1, @2];
    topSelRow.popoverKind = 13;
    topSelRow.height = 52;
    [menu.catalog addObject:topSelRow];
}

static void AddDockMaterialRows(FQXSettingsMenu *menu) {
    NSString *route = @"外观/玻璃与尺寸";
    FQXSettingRow *material = [FQXSettingRow new];
    material.title = @"Dock 材质";
    material.path = route;
    material.keywords = @"底栏 导航栏 材质 新液态玻璃 老液态玻璃 液态玻璃 模糊玻璃 毛玻璃 高斯模糊 iOS18 视频同款底色 非玻璃 底色 灰白 粉雾玻璃 柔性粉雾 粉色 透明";
    material.popoverKey = DockMaterialKey;
    material.popoverOptions = @[@"新液态玻璃", @"老液态玻璃", @"模糊玻璃", @"高斯模糊", @"视频同款底色（非玻璃）", @"粉雾玻璃"];
    material.popoverValues = @[@0, @1, @2, @3, @4, @5];
    material.popoverKind = 3;
    material.height = 52;
    [menu.catalog addObject:material];

    AddDockSelectionTintRow(menu, route, NO);
    AddBlurRow(menu, route, @"Dock 模糊程度", DockBlurKey);
}

static void AddCommentStyleRows(FQXSettingsMenu *menu, NSString *route, BOOL hiddenFromSearch) {
    FQXSettingRow *materialRow = [FQXSettingRow new];
    materialRow.title = @"评论区材质";
    materialRow.path = route;
    materialRow.hiddenFromSearch = hiddenFromSearch;
    materialRow.keywords = @"评论区材质 评论区清透玻璃 评论区模糊玻璃 评论区液态玻璃 评论区高斯模糊 评论区 原版默认 评价 短剧评论 看书评论 小说评论 段评 清透玻璃 模糊玻璃 Clear Regular 液态玻璃 高斯模糊 毛玻璃 磨砂 iOS18 原生 不透明 默认背景 材质 透明 玻璃";
    materialRow.popoverKey = CommentMaterialStyleKey;
    materialRow.popoverOptions = @[@"原版默认", @"清透玻璃", @"模糊玻璃", @"高斯模糊"];
    materialRow.popoverValues = @[@0, @1, @4, @2];
    materialRow.popoverKind = 4;
    materialRow.height = 52;
    [menu.catalog addObject:materialRow];

    FQXSettingRow *appearanceRow = [FQXSettingRow new];
    appearanceRow.title = @"评论区外观";
    appearanceRow.path = route;
    appearanceRow.hiddenFromSearch = hiddenFromSearch;
    appearanceRow.keywords = @"评论区 外观 浅色 深色 浅色深色 夜间模式 日间模式 跟随软件 独立 主题 颜色 背景 评论区深浅";
    appearanceRow.popoverKey = CommentAppearanceModeKey;
    appearanceRow.popoverOptions = @[@"跟随软件", @"浅色", @"深色"];
    appearanceRow.popoverKind = 5;
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

static UIImage *DrawSettingsMinimizeIcon(void) {
    CGSize canvas = CGSizeMake(24.0, 24.0);
    UIGraphicsImageRendererFormat *fmt = [UIGraphicsImageRendererFormat defaultFormat];
    fmt.opaque = NO;
    UIGraphicsImageRenderer *renderer = [[UIGraphicsImageRenderer alloc] initWithSize:canvas format:fmt];
    UIImage *img = [renderer imageWithActions:^(__unused UIGraphicsImageRendererContext *ctx) {
        [UIColor.blackColor setStroke];

        // Cute, clean iOS-style rounded downward chevron + soft dock pill bar
        UIBezierPath *chevron = [UIBezierPath bezierPath];
        [chevron moveToPoint:CGPointMake(7.2, 8.6)];
        [chevron addLineToPoint:CGPointMake(12.0, 13.4)];
        [chevron addLineToPoint:CGPointMake(16.8, 8.6)];
        chevron.lineWidth = 2.25;
        chevron.lineCapStyle = kCGLineCapRound;
        chevron.lineJoinStyle = kCGLineJoinRound;
        [chevron stroke];

        UIBezierPath *tray = [UIBezierPath bezierPath];
        [tray moveToPoint:CGPointMake(8.0, 16.8)];
        [tray addLineToPoint:CGPointMake(16.0, 16.8)];
        tray.lineWidth = 2.25;
        tray.lineCapStyle = kCGLineCapRound;
        [tray stroke];
    }];
    return [img imageWithRenderingMode:UIImageRenderingModeAlwaysTemplate];
}

static UIBarButtonItem *SettingsHeaderItem(NSString *title, UIImage *image, id target, SEL action) {
    BOOL hasTitle = title.length > 0;
    CGRect frame = CGRectMake(0, 0, hasTitle ? 96.0 : 48.0, 40.0);
    UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
    button.frame = frame;
    button.translatesAutoresizingMaskIntoConstraints = NO;
    button.tintColor = UIColor.labelColor;
    [button addTarget:target action:action forControlEvents:UIControlEventPrimaryActionTriggered];

    UIVisualEffectView *surface;
    Class glassClass = NSClassFromString(@"UIGlassEffect");
    if (glassClass) {
        const NSInteger regularGlassStyle = 0;
        SEL effectSelector = sel_registerName("effectWithStyle:");
        UIVisualEffect *effect = ((id (*)(Class, SEL, NSInteger))objc_msgSend)(glassClass, effectSelector, regularGlassStyle);
        surface = [[UIVisualEffectView alloc] initWithEffect:effect];
        id corners = Invoke(NSClassFromString(@"UICornerConfiguration"), @"capsuleConfiguration");
        ((void (*)(id, SEL, id))objc_msgSend)(surface, sel_registerName("setCornerConfiguration:"), corners);
    } else {
        surface = [[UIVisualEffectView alloc] initWithEffect:[UIBlurEffect effectWithStyle:UIBlurEffectStyleSystemThinMaterial]];
        surface.layer.cornerRadius = CGRectGetHeight(frame) * 0.5;
        surface.clipsToBounds = YES;
    }
    surface.frame = frame;
    surface.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
    surface.userInteractionEnabled = NO;
    [button addSubview:surface];

    if (hasTitle) {
        UILabel *label = [UILabel new];
        label.translatesAutoresizingMaskIntoConstraints = NO;
        label.text = title;
        label.font = [UIFont systemFontOfSize:14.5 weight:UIFontWeightSemibold];
        label.textColor = UIColor.labelColor;
        label.textAlignment = NSTextAlignmentCenter;
        label.adjustsFontSizeToFitWidth = YES;
        label.minimumScaleFactor = 0.85;
        label.userInteractionEnabled = NO;
        [button addSubview:label];
        [NSLayoutConstraint activateConstraints:@[
            [label.leadingAnchor constraintEqualToAnchor:button.leadingAnchor constant:10.0],
            [label.trailingAnchor constraintEqualToAnchor:button.trailingAnchor constant:-10.0],
            [label.centerYAnchor constraintEqualToAnchor:button.centerYAnchor],
        ]];
    } else if (image) {
        UIImageView *iconView = [[UIImageView alloc] initWithImage:image];
        iconView.translatesAutoresizingMaskIntoConstraints = NO;
        iconView.tintColor = UIColor.labelColor;
        iconView.contentMode = UIViewContentModeCenter;
        iconView.userInteractionEnabled = NO;
        [button addSubview:iconView];
        [NSLayoutConstraint activateConstraints:@[
            [iconView.centerXAnchor constraintEqualToAnchor:button.centerXAnchor],
            [iconView.centerYAnchor constraintEqualToAnchor:button.centerYAnchor],
            [iconView.widthAnchor constraintEqualToConstant:24.0],
            [iconView.heightAnchor constraintEqualToConstant:24.0],
        ]];
    }

    [NSLayoutConstraint activateConstraints:@[[button.widthAnchor constraintEqualToConstant:CGRectGetWidth(frame)],
                                              [button.heightAnchor constraintEqualToConstant:CGRectGetHeight(frame)]]];
    UIBarButtonItem *item = [[UIBarButtonItem alloc] initWithCustomView:button];
    if (glassClass) ((void (*)(id, SEL, BOOL))objc_msgSend)(item, sel_registerName("setHidesSharedBackground:"), YES);
    return item;
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
    AddDockCollapseModeRows(menu, @"短剧/底栏收缩", NO);
    AddDockCollapseModeRows(menu, @"页面与导航/底栏入口", YES);
    AddDockCollapseModeRows(menu, @"外观/玻璃与尺寸", YES);
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
    AddDockSelectionTintRow(menu, @"页面与导航/底栏入口", YES);
    AddDockMaterialRows(menu);

    // Add Comment Material toggles (Liquid Glass / Gaussian Blur, mutually exclusive, both off = native),
    // standalone Comment Appearance selector (Follow App / Light / Dark), and Composer Style popover.
    AddCommentStyleRows(menu, @"评论区净化", NO);
    AddBlurRow(menu, @"评论区净化", @"评论区模糊程度", @"FanqieX.CommentBlur.1");
    AddCommentStyleRows(menu, @"短剧/播放设置", YES);
    AddBlurRowEx(menu, @"短剧/播放设置", @"评论区模糊程度", @"FanqieX.CommentBlur.1", YES, nil);
    AddCommentStyleRows(menu, @"阅读/阅读设置", YES);
    AddBlurRowEx(menu, @"阅读/阅读设置", @"评论区模糊程度", @"FanqieX.CommentBlur.1", YES, nil);
    AddCommentStyleRows(menu, @"外观/玻璃效果", YES);
    AddBlurRowEx(menu, @"外观/玻璃效果", @"评论区模糊程度", @"FanqieX.CommentBlur.1", YES, nil);
    AddShareStyleRows(menu, @"外观/玻璃效果", NO, YES);
    AddAudioSheetStyleRows(menu, @"外观/玻璃效果", YES);
    AddPlaybackOptionsStyleRows(menu, @"外观/玻璃效果", YES);
    AddShareStyleRows(menu, @"阅读/阅读设置", YES, NO);
    // Keep Short Drama top-bar & button appearance controls directly on the top-level "短剧" page for instant access.
    AddDramaTopStyleRows(menu, @"短剧", NO);
    NSString *topSizeKeywords = @"顶部按钮大小 顶部按钮自定义大小 顶部按钮 顶部分类 顶部胶囊 顶栏 大小 尺寸 缩放 比例 搜索按钮 短剧 推荐 看剧 漫剧 自定义";
    AddScaleSliderRow(menu, @"短剧", @"顶部按钮大小", DramaHeaderButtonScaleKey, 70, 130, 100, NO, topSizeKeywords);
    AddBlurRow(menu, @"短剧", @"短剧顶部按钮模糊程度", @"FanqieX.DramaHeaderBlur.1");
    AddPlaybackOptionsStyleRows(menu, @"短剧", NO);
    AddShareStyleRows(menu, @"短剧/播放设置", YES, YES);
    AddBlurRow(menu, @"阅读/智能朗读", @"听书按钮模糊程度", @"FanqieX.AudioButtonBlur.1");
    AddAudioSheetStyleRows(menu, @"阅读/智能朗读", NO);
    FQXSettingRow *albumTitle = [FQXSettingRow new];
    albumTitle.title = @"合集标题显示";
    albumTitle.path = @"短剧/播放设置";
    albumTitle.popoverKey = @"FanqieX.DramaAlbumTitleLines.1";
    albumTitle.popoverOptions = @[@"单行省略", @"双行显示"];
    albumTitle.height = 52;
    [menu.catalog addObject:albumTitle];

    NSArray<NSString *> *actionIcons = @[@"收藏图标", @"评论图标", @"点赞图标", @"分享图标"];
    NSArray<NSString *> *naloiaNames = @[@"Naloia · 大繁星", @"Naloia · 双语引号",
                                        @"Naloia · 心弦爱心", @"Naloia · 折翼飞梭"];
    for (FQXNaloiaRole role = FQXNaloiaFavorite; role < FQXNaloiaRoleCount; role++) {
        FQXSettingRow *row = [FQXSettingRow new];
        row.title = actionIcons[role];
        row.path = @"短剧/右侧互动按钮";
        row.popoverKey = FQXNaloiaPreferenceKey(role);
        row.popoverOptions = @[@"跟随现有图标", naloiaNames[role]];
        row.height = 52;
        row.keywords = naloiaNames[role];
        [menu.catalog addObject:row];
    }

    NSArray *options = Invoke(objc_lookUpClass("FQXCleanup"), @"optionRows") ?: @[];
    NSDictionary *paths = @{@"reader":@"阅读/阅读页面净化/章末内容", @"mine":@"我的页面净化/内容卡片", @"sidebar":@"我的页面净化/侧栏", @"shelf":@"书架净化/推荐与导入", @"drama":@"短剧/播放设置", @"bookstore":@"书城/页面净化", @"ads":@"广告与福利/专项控制", @"readerFeatures":@"阅读/专项净化",
        @"notifications":@"通知管理", @"gestures":@"阅读/自动阅读", @"audio":@"阅读/智能朗读",
        @"dramaActions":@"短剧/右侧互动按钮", @"appearance":@"外观/玻璃效果", @"comment":@"评论区净化",
        @"bottom":@"页面与导航/底栏入口"};
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
        if ([@[@"FanqieX.ReaderEarnMore.1", @"FanqieX.ReaderSpeechFloat.1", @"FanqieX.ReaderChapterEndDrama.1", @"FanqieX.ReaderHotCommentBadge.1"] containsObject:option[@"key"]])
            row.path = @"阅读/阅读页面净化/正文与底栏";
        if ([option[@"key"] isEqualToString:@"FanqieX.AudioRecommendations.1"])
            row.path = @"阅读/听书页面净化";
        if ([@[@"FanqieX.MineScanButton.1", @"FanqieX.MineSearchBar.1", @"FanqieX.MineNightButton.1"] containsObject:option[@"key"]])
            row.path = @"我的页面净化/顶部栏";
        if ([option[@"key"] isEqualToString:@"FanqieX.MinePublish.1"]) row.path = @"我的页面净化/悬浮入口";
        if ([@[@"FanqieX.ShelfRecommendationBanner.1", @"FanqieX.ShelfActivityNotice.1", @"FanqieX.ShelfEditButton.1"] containsObject:option[@"key"]]) row.path = @"书架净化/顶部与统计";
        if ([@[@"FanqieX.ShelfTabBookshelf.1", @"FanqieX.ShelfTabHistory.1", @"FanqieX.ShelfTabCollect.1", @"FanqieX.ShelfTabCircle.1", @"FanqieX.ShelfSearchButton.1", @"FanqieX.ShelfMoreButton.1"] containsObject:option[@"key"]])
            row.path = @"书架净化/顶部导航栏";
        if ([@[@"FanqieX.ShelfFilterAll.1", @"FanqieX.ShelfFilterRead.1", @"FanqieX.ShelfFilterListen.1", @"FanqieX.ShelfFilterComic.1", @"FanqieX.ShelfFilterStar.1",
               @"FanqieX.ShelfHistoryFilterAll.1", @"FanqieX.ShelfHistoryFilterRead.1", @"FanqieX.ShelfHistoryFilterListen.1", @"FanqieX.ShelfHistoryFilterDrama.1",
               @"FanqieX.ShelfHistoryFilterShortStory.1", @"FanqieX.ShelfHistoryFilterComic.1", @"FanqieX.ShelfHistoryFilterTopic.1",
               @"FanqieX.ShelfHistoryFilterBtn.1", @"FanqieX.ShelfHistoryEditBtn.1"] containsObject:option[@"key"]])
            row.path = @"书架净化/筛选栏标签";
        if ([option[@"key"] hasPrefix:@"FanqieX.ShelfFavorites"])
            row.path = @"书架净化/收藏页";
        if ([@[@"FanqieX.DramaHideFullscreenButton.1", @"FanqieX.DramaHideTitleEntry.1", @"FanqieX.DramaHideSeriesTag.1",
               @"FanqieX.DramaHideTitleBadge.1", @"FanqieX.DramaHideGenreTags.1",
               @"FanqieX.DramaHideEpisodeAdaptations.1", @"FanqieX.DramaHideEpisodeSameSeries.1", @"FanqieX.DramaHideEpisodeRecommend.1",
               @"FanqieX.DramaShowDanmakuButton.1"] containsObject:option[@"key"]])
            row.path = @"短剧/页面内容";
        if ([option[@"key"] isEqualToString:@"FanqieX.GlassDarkTint.1"])
            row.path = @"外观/玻璃与尺寸";
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
            @"FanqieX.DramaHideFullscreenButton.1":@"短剧 漫剧 全屏观看 横屏播放 播放器 原位置 点击",
            @"FanqieX.DramaHideTitleEntry.1":@"短剧 漫剧 剧名 标题 箭头 详情 入口 左下角",
            @"FanqieX.DramaHideSeriesTag.1":@"短剧 漫剧 系列剧 追剧 共 万人在追 在追 标签 入口 横幅 隐藏 关闭",
            @"FanqieX.DramaHideTitleBadge.1":@"短剧 漫剧 上新 爆款 热播 新剧 独播 角标 徽标 标题 标签 隐藏 关闭",
            @"FanqieX.DramaHideGenreTags.1":@"短剧 漫剧 题材 分类 季数 第1季 第2季 逆袭 都市日常 奇幻脑洞 重生 演员 标签 隐藏 关闭",
            @"FanqieX.DramaHideEpisodeAdaptations.1":@"短剧 漫剧 选集 原著 更多改编 改编 有声书 原著小说 衍生 隐藏 关闭",
            @"FanqieX.DramaHideEpisodeSameSeries.1":@"短剧 漫剧 选集 同系列剧 同系列 第二季 第三季 第四季 预约 系列 隐藏 关闭",
            @"FanqieX.DramaHideEpisodeRecommend.1":@"短剧 漫剧 选集 底部推荐 推荐视频 猜你喜欢 双列推荐 更多推荐 隐藏 关闭",
            @"FanqieX.CommentActivityBanner.1":@"评论区 公告 活动 社区公约 文明发言 活动横幅 激励 创作者计划 段评 顶部 隐藏 关闭",
            @"FanqieX.CommentSearchEntrance.1":@"评论区 大家都在搜 大家在搜 热搜 搜索 推荐 顶部 隐藏 关闭",
            @"FanqieX.DramaOutlineActions.1":@"侧栏 点赞 评论 收藏 分享 线条 空心 轮廓 图标",
            @"FanqieX.DramaShowCollect.1":@"短剧 右侧 收藏 星星 互动按钮 隐藏",
            @"FanqieX.DramaShowComment.1":@"短剧 右侧 评论 气泡 互动按钮 隐藏",
            @"FanqieX.DramaShowLike.1":@"短剧 右侧 点赞 爱心 红心 互动按钮 隐藏",
            @"FanqieX.DramaShowShare.1":@"短剧 右侧 分享 转发 互动按钮 隐藏",
            @"FanqieX.DramaAutoplay.1":@"短剧 自动播放 进入播放 暂停 视频",
            @"FanqieX.DramaUnlockDanmaku.1":@"短剧 漫剧 动态漫 弹幕 弹幕开关 弹幕设置 弹幕按钮 解锁 开启 显示 长按倍速面板",
            @"FanqieX.DramaShowDanmakuButton.1":@"短剧 漫剧 动态漫 左下角 弹幕 弹幕按钮 弹 按钮 显示 隐藏 关闭 开关",
            @"FanqieX.AudioLiquidGlass.1":@"听书 液态玻璃 听书液态玻璃 液态玻璃听书 听书按钮 朗读液态玻璃 听书界面 朗读界面 原版默认 玻璃 外观",
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
            @"FanqieX.ListenPendant.1":@"听读赚钱 赚钱 挂件 悬浮 福利 金币 听书时长 沙漏 右下角 阅读挂件",
            @"FanqieX.StoryAds.1":@"短篇 正文 广告 拦截 净化",
            @"FanqieX.HotLaunchAds.1":@"热启动 开屏 广告 拦截 净化",
            @"FanqieX.AudioAds.1":@"听书 朗读 看广告 攒时长 免广告 听书时长 解锁 贴片 信息流 广告 拦截 净化",
            @"FanqieX.ChapterTitle.1":@"返回 标题 章节名 书名 阅读页",
            @"FanqieX.NotificationsBadge.1":@"红点 数字 角标 通知 提醒",
            @"FanqieX.ReaderChapterEndDrama.1":@"阅读底栏 改编剧场 改编剧入口",
            @"FanqieX.ReaderChapterEndActions.1":@"最新章节 三个按钮 最新章 章末",
            @"FanqieX.ShelfMotionComicRecommendation.1":@"书架 漫剧推荐 动态漫推荐",
            @"FanqieX.ShelfAdaptationCard.1":@"书架 小说改编剧 改编短剧 推荐卡片",
            @"FanqieX.ShelfRecommendations.1":@"书架 推荐内容 展开全部 猜你喜欢 为你推荐 书架底部推荐 榜单推荐",
            @"FanqieX.ShelfLocalImport.1":@"书架本地书导入入口 本地图书 本地书导入 导入本地书 畅享免费听书",
            @"FanqieX.ShelfHistoryCard.1":@"书架 浏览历史 去浏览历史 看更多书籍 历史入口 卡片 隐藏",
            @"FanqieX.ShelfEditButton.1":@"书架 编辑 编辑按钮 顶部 编辑入口 隐藏 关闭",
            @"FanqieX.ShelfTabBookshelf.1":@"书架 顶部 书架标签 标签 导航",
            @"FanqieX.ShelfTabHistory.1":@"书架 顶部 历史标签 历史 阅读历史 标签",
            @"FanqieX.ShelfTabCollect.1":@"书架 顶部 收藏标签 收藏 标签",
            @"FanqieX.ShelfTabCircle.1":@"书架 顶部 圈子标签 圈子 书圈 标签",
            @"FanqieX.ShelfSearchButton.1":@"书架 顶部 搜索 搜索按钮 放大镜",
            @"FanqieX.ShelfMoreButton.1":@"书架 顶部 更多 更多按钮 三点",
            @"FanqieX.ShelfFilterAll.1":@"书架 筛选栏 全部 标签 分类",
            @"FanqieX.ShelfFilterRead.1":@"书架 筛选栏 阅读 标签 分类",
            @"FanqieX.ShelfFilterListen.1":@"书架 筛选栏 听书 标签 分类",
            @"FanqieX.ShelfFilterComic.1":@"书架 筛选栏 漫剧 标签 分类",
            @"FanqieX.ShelfFilterStar.1":@"书架 筛选栏 星标 标签 分类",
            @"FanqieX.ShelfHistoryFilterAll.1":@"书架 历史 历史页 筛选栏 全部 标签 分类 隐藏 关闭",
            @"FanqieX.ShelfHistoryFilterRead.1":@"书架 历史 历史页 筛选栏 阅读 标签 分类 隐藏 关闭",
            @"FanqieX.ShelfHistoryFilterListen.1":@"书架 历史 历史页 筛选栏 听书 标签 分类 隐藏 关闭",
            @"FanqieX.ShelfHistoryFilterDrama.1":@"书架 历史 历史页 筛选栏 短剧 漫剧 标签 分类 隐藏 关闭",
            @"FanqieX.ShelfHistoryFilterBtn.1":@"书架 历史 历史页 筛选栏 筛选 按钮 漏斗 隐藏 关闭",
            @"FanqieX.ShelfHistoryEditBtn.1":@"书架 历史 历史页 筛选栏 编辑 按钮 隐藏 关闭",
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
            @"FanqieX.MineBenefitsCard.1":@"我的页面 福利卡片 金币",
            @"FanqieX.GlassDarkTint.1":@"液态玻璃 深色底色 底色 黑色 染色 压暗 通透 透明 无底色 顶部 顶栏 顶部分类 搜索按钮 底栏 Dock 新液态玻璃 短剧",
            @"FanqieX.DockDetachedEnabled.1":@"底栏 dock 独立圆形模块 独立模块 圆形按钮 右侧按钮 相机样式 分离 胶囊"
        };
        if (aliases[option[@"key"]]) row.keywords = [row.keywords stringByAppendingFormat:@" %@", aliases[option[@"key"]]];
        row.option = option;
        row.height = 52;
        // Reuse the original switch for shared keys so its refresh action runs.
        if (!existing) [menu.catalog addObject:row];
        if ([option[@"key"] isEqualToString:@"FanqieX.GlassDarkTint.1"]) {
            for (NSString *mirrorPath in @[@"短剧"]) {
                FQXSettingRow *mirror = [FQXSettingRow new];
                mirror.title = row.title;
                mirror.path = mirrorPath;
                mirror.hiddenFromSearch = YES;
                mirror.option = option;
                mirror.height = 52;
                [menu.catalog addObject:mirror];
            }
        }
        if ([option[@"key"] isEqualToString:@"FanqieX.DockDetachedEnabled.1"]) {
            AddDetachedDockModuleRow(menu, @"页面与导航/底栏入口", NO);
            FQXSettingRow *dockMirror = [FQXSettingRow new];
            dockMirror.title = row.title;
            dockMirror.path = @"外观/玻璃与尺寸";
            dockMirror.hiddenFromSearch = YES;
            dockMirror.option = option;
            dockMirror.height = 52;
            [menu.catalog addObject:dockMirror];
            AddDetachedDockModuleRow(menu, @"外观/玻璃与尺寸", YES);
        }
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

    AddDiagCategoryFilterRow(menu);
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
    NSString *version = FQXPluginVersion();
    UIBarButtonItem *releaseNotes = SettingsHeaderItem(version, nil, menu, @selector(showReleaseNotes:));
    releaseNotes.customView.accessibilityLabel = [@"插件版本 " stringByAppendingString:version];
    releaseNotes.customView.accessibilityHint = @"展开本版更新";
    UIBarButtonItem *minimize = SettingsHeaderItem(nil, DrawSettingsMinimizeIcon(), menu, @selector(dismissSettings:));
    minimize.customView.accessibilityLabel = @"收起设置";
    menu.navigationItem.leftBarButtonItem = releaseNotes;
    menu.navigationItem.rightBarButtonItem = minimize;
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

- (void)showReleaseNotes:(UIButton *)sender {
    if (self.presentedViewController) return;

    NSString *version = FQXPluginVersion();
    NSString *summary = nil;
    for (NSUInteger i = 0; i < sizeof(FQXReleaseNotes) / sizeof(FQXReleaseNotes[0]); ++i) {
        if ([version isEqualToString:FQXReleaseNotes[i].version]) {
            summary = FQXReleaseNotes[i].summary;
            break;
        }
    }

    FQXReleaseNotesController *page = [FQXReleaseNotesController new];
    UITextView *notes = [UITextView new];
    notes.text = [NSString stringWithFormat:@"%@ 更新内容\n\n%@", version, summary ?: @"暂无更新说明"];
    notes.font = [UIFont preferredFontForTextStyle:UIFontTextStyleBody];
    notes.adjustsFontForContentSizeCategory = YES;
    notes.textColor = UIColor.labelColor;
    notes.backgroundColor = UIColor.clearColor;
    notes.textContainerInset = UIEdgeInsetsMake(16, 16, 4, 16);
    notes.editable = NO;
    notes.selectable = NO;
    [notes addGestureRecognizer:[[UITapGestureRecognizer alloc] initWithTarget:page action:@selector(showHistory)]];

    UIButtonConfiguration *configuration = [UIButtonConfiguration plainButtonConfiguration];
    configuration.title = @"查看历代更新";
    configuration.image = [UIImage systemImageNamed:@"chevron.forward"];
    configuration.imagePlacement = NSDirectionalRectEdgeTrailing;
    configuration.imagePadding = 8;
    configuration.contentInsets = NSDirectionalEdgeInsetsMake(10, 21, 10, 21);
    UIButton *history = [UIButton buttonWithConfiguration:configuration primaryAction:nil];
    history.contentHorizontalAlignment = UIControlContentHorizontalAlignmentLeading;
    [history addTarget:page action:@selector(showHistory) forControlEvents:UIControlEventTouchUpInside];

    UIStackView *body = [[UIStackView alloc] initWithArrangedSubviews:@[notes, history]];
    body.axis = UILayoutConstraintAxisVertical;
    body.translatesAutoresizingMaskIntoConstraints = NO;
    [page.view addSubview:body];
    [NSLayoutConstraint activateConstraints:@[
        [body.topAnchor constraintEqualToAnchor:page.view.topAnchor],
        [body.leadingAnchor constraintEqualToAnchor:page.view.leadingAnchor],
        [body.trailingAnchor constraintEqualToAnchor:page.view.trailingAnchor],
        [body.bottomAnchor constraintEqualToAnchor:page.view.bottomAnchor],
        [history.heightAnchor constraintGreaterThanOrEqualToConstant:44]
    ]];
    page.modalPresentationStyle = UIModalPresentationPopover;
    CGFloat width = MIN(312.0, CGRectGetWidth(self.view.bounds) - 32.0);
    CGSize contentSize = [notes sizeThatFits:CGSizeMake(width, CGFLOAT_MAX)];
    CGFloat historyHeight = MAX(44.0, [history sizeThatFits:CGSizeMake(width, CGFLOAT_MAX)].height);
    page.preferredContentSize = CGSizeMake(width, MIN(300.0, ceil(contentSize.height)) + historyHeight);
    UIPopoverPresentationController *popover = page.popoverPresentationController;
    popover.delegate = self;
    popover.sourceView = sender;
    popover.sourceRect = sender.bounds;
    popover.permittedArrowDirections = UIPopoverArrowDirectionUp;
    [self presentViewController:page animated:YES completion:nil];
}

- (UIModalPresentationStyle)adaptivePresentationStyleForPresentationController:(UIPresentationController *)controller {
    (void)controller;
    return UIModalPresentationNone;
}

- (UIModalPresentationStyle)adaptivePresentationStyleForPresentationController:(UIPresentationController *)controller
                                                               traitCollection:(UITraitCollection *)traitCollection {
    (void)controller;
    (void)traitCollection;
    return UIModalPresentationNone;
}

- (void)dismissSettings:(id)sender {
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
        if ([row.title isEqualToString:@"查看全集与进度条跟随底栏长度"]) {
            id stored = [NSUserDefaults.standardUserDefaults objectForKey:FollowWidthKey];
            BOOL follow = [stored respondsToSelector:@selector(boolValue)] ? [stored boolValue] : NO;
            for (UIView *control in row.content.subviews)
                if ([control isKindOfClass:UISwitch.class]) [(UISwitch *)control setOn:follow];
        }
    }
    UIViewController *visible = menu.navigationController.topViewController;
    FQXSettingsMenu *page = [visible isKindOfClass:FQXSettingsMenu.class] ? (FQXSettingsMenu *)visible : menu;
    [page rebuild];
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
    NSInteger collapseMode = CurrentSavedDockCollapseMode();
    BOOL compact = (collapseMode == FQXDockCollapseModeLegacy);
    BOOL siriai = (collapseMode == FQXDockCollapseModeSiriai);
    for (FQXSettingRow *row in self.catalog) {
        if (row.requiresSiriai && !siriai) continue;
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
    if ([self.path isEqualToString:@"短剧"]) return @"短剧顶栏与按钮底色、顶部选中色、按钮大小、模糊度与播放选项材质均集中在此设置，与底栏 Dock 选中色相互独立。";
    if ([self.path isEqualToString:@"评论区净化"]) return @"评论区材质与发评论输入框样式可独立搭配选择。";
    if ([self.path isEqualToString:@"阅读/智能朗读"]) return @"听书弹窗材质与模糊程度作用于章评、选择章节、已加书架、语速、定时关闭、简介/播放目录、音色设置与更多弹窗；听书按钮模糊程度在听书界面液态玻璃开启时生效。";
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
    if (row.blurKey) {
        UITableViewCell *cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:nil];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        UILabel *title = [UILabel new];
        title.text = row.title;
        title.font = [UIFont preferredFontForTextStyle:UIFontTextStyleBody];
        UILabel *value = [UILabel new];
        value.font = [UIFont monospacedDigitSystemFontOfSize:14 weight:UIFontWeightRegular];
        value.textColor = UIColor.secondaryLabelColor;
        FQXBlurSlider *slider = [FQXBlurSlider new];
        NSInteger minV = row.sliderMax > row.sliderMin ? row.sliderMin : 0;
        NSInteger maxV = row.sliderMax > row.sliderMin ? row.sliderMax : 100;
        NSInteger defV = row.sliderMax > row.sliderMin ? row.sliderDefault : 0;
        id storedObj = [NSUserDefaults.standardUserDefaults objectForKey:row.blurKey];
        if (!storedObj && [row.blurKey isEqualToString:AudioSheetBlurKey]) {
            storedObj = [NSUserDefaults.standardUserDefaults objectForKey:AudioMoreBlurKey];
        }
        NSInteger storedVal = (storedObj && [storedObj respondsToSelector:@selector(integerValue)])
            ? [storedObj integerValue] : defV;
        slider.minimumValue = (float)minV;
        slider.maximumValue = (float)maxV;
        slider.continuous = ![row.blurKey isEqualToString:@"FanqieX.AudioButtonBlur.1"];
        slider.value = (float)ClampSliderPercent((double)storedVal, (double)minV, (double)maxV);
        slider.accessibilityIdentifier = row.blurKey;
        slider.accessibilityLabel = row.title;
        value.text = [NSString stringWithFormat:@"%.0f%%", slider.value];
        slider.accessibilityValue = value.text;
        slider.valueLabel = value;
        UIStepper *stepper = [UIStepper new];
        stepper.minimumValue = (double)minV;
        stepper.maximumValue = (double)maxV;
        stepper.stepValue = 1;
        stepper.value = slider.value;
        stepper.wraps = NO;
        stepper.accessibilityLabel = [row.title stringByAppendingString:@"，每次调整1%"];
        stepper.accessibilityValue = value.text;
        slider.stepper = stepper;
        objc_setAssociatedObject(stepper, &BlurSliderKey, slider, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
        [stepper addTarget:self action:@selector(blurStepperChanged:) forControlEvents:UIControlEventValueChanged];
        [slider addTarget:self action:@selector(blurChanged:) forControlEvents:UIControlEventValueChanged];
        [slider addTarget:self action:@selector(blurDidEndTracking:) forControlEvents:UIControlEventTouchUpInside | UIControlEventTouchUpOutside | UIControlEventTouchCancel];
        UIView *content = cell.contentView;
        title.adjustsFontSizeToFitWidth = YES;
        title.minimumScaleFactor = 0.75;
        value.textAlignment = NSTextAlignmentRight;
        for (UIView *view in @[title, value, slider, stepper]) {
            view.translatesAutoresizingMaskIntoConstraints = NO;
            [content addSubview:view];
        }
        UILayoutGuide *margins = content.layoutMarginsGuide;
        [NSLayoutConstraint activateConstraints:@[
            [title.leadingAnchor constraintEqualToAnchor:margins.leadingAnchor],
            [title.centerYAnchor constraintEqualToAnchor:stepper.centerYAnchor],
            [title.trailingAnchor constraintLessThanOrEqualToAnchor:value.leadingAnchor constant:-8],
            [value.widthAnchor constraintEqualToConstant:48],
            [value.trailingAnchor constraintEqualToAnchor:stepper.leadingAnchor constant:-8],
            [value.centerYAnchor constraintEqualToAnchor:stepper.centerYAnchor],
            [stepper.trailingAnchor constraintEqualToAnchor:margins.trailingAnchor],
            [stepper.topAnchor constraintEqualToAnchor:content.topAnchor constant:6],
            [slider.leadingAnchor constraintEqualToAnchor:margins.leadingAnchor],
            [slider.trailingAnchor constraintEqualToAnchor:margins.trailingAnchor],
            [slider.topAnchor constraintEqualToAnchor:content.topAnchor constant:35],
            [slider.heightAnchor constraintEqualToConstant:44],
        ]];
        if (self.search.searchBar.text.length) {
            UILabel *pathLabel = [[UILabel alloc] initWithFrame:CGRectMake(20, row.height, CGRectGetWidth(content.bounds) - 40, 22)];
            pathLabel.autoresizingMask = UIViewAutoresizingFlexibleWidth;
            pathLabel.font = [UIFont systemFontOfSize:11];
            pathLabel.textColor = UIColor.secondaryLabelColor;
            pathLabel.text = [row.path stringByReplacingOccurrencesOfString:@"/" withString:@" › "];
            [content addSubview:pathLabel];
        }
        return cell;
    }
    if (row.popoverKey.length && row.popoverOptions.count) {
        BOOL searching = self.search.searchBar.text.length > 0;
        UITableViewCell *cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:nil];
        cell.textLabel.text = row.title;
        cell.textLabel.numberOfLines = 2;
        if (row.popoverKind == 8) {
            NSArray<NSString *> *avail = FQXDockDetachedAvailableModules();
            NSArray<NSString *> *allMods = FQXDockDetachedAllKnownModules();
            if (allMods.count < 2) {
                cell.textLabel.textColor = UIColor.secondaryLabelColor;
                cell.detailTextLabel.text = searching
                    ? [@"可用模块不足 · " stringByAppendingString:row.path]
                    : @"可用模块不足";
                cell.detailTextLabel.textColor = UIColor.secondaryLabelColor;
                cell.accessoryType = UITableViewCellAccessoryNone;
                cell.selectionStyle = UITableViewCellSelectionStyleNone;
                return cell;
            }
            NSString *saved = FQXDockDetachedStoredModule();
            NSString *detail = nil;
            if (saved.length > 0 && !FQXDockIsModuleAllowedByBottomPrefs(saved)) {
                detail = [NSString stringWithFormat:@"%@（底栏已隐藏·点此恢复）", saved];
            } else if (saved.length > 0 && ![avail containsObject:saved]) {
                detail = [NSString stringWithFormat:@"%@（当前未启用）", saved];
            } else {
                detail = saved.length > 0 ? saved : (avail.lastObject ?: allMods.lastObject ?: @"");
            }
            cell.detailTextLabel.text = searching
                ? [NSString stringWithFormat:@"%@ · %@", detail, row.path]
                : detail;
            cell.detailTextLabel.textColor = UIColor.secondaryLabelColor;
            cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
            cell.selectionStyle = UITableViewCellSelectionStyleDefault;
            return cell;
        }
        BOOL unavailable = row.requiresCompact && (CurrentSavedDockCollapseMode() != FQXDockCollapseModeLegacy);
        if (unavailable) {
            cell.textLabel.textColor = UIColor.secondaryLabelColor;
            cell.detailTextLabel.text = searching
                ? [@"先开启自动收缩 · " stringByAppendingString:row.path]
                : @"先开启自动收缩";
            cell.detailTextLabel.textColor = UIColor.secondaryLabelColor;
            cell.accessoryType = UITableViewCellAccessoryNone;
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
            return cell;
        }
        NSArray<NSString *> *options = nil;
        NSInteger curIdx = PopoverOptionsAndCurrentIndex(row, &options, nil);
        cell.detailTextLabel.text = searching
            ? [NSString stringWithFormat:@"%@ · %@", options[(NSUInteger)curIdx], row.path]
            : options[(NSUInteger)curIdx];
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
    BOOL unavailable = row.requiresCompact && (CurrentSavedDockCollapseMode() != FQXDockCollapseModeLegacy);
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
            if ([sw.accessibilityLabel isEqualToString:@"查看全集与进度条跟随底栏长度"]) {
                id stored = [NSUserDefaults.standardUserDefaults objectForKey:FollowWidthKey];
                sw.on = [stored respondsToSelector:@selector(boolValue)] ? [stored boolValue] : NO;
            } else if ([row.path isEqualToString:@"页面与导航/底栏入口"]) {
                NSString *lbl = sw.accessibilityLabel ?: @"";
                BOOL entry = [lbl hasPrefix:BottomEntryTitlePrefix];
                if (!entry && ![lbl isEqualToString:@"底栏点击震动"]) continue;
                if (entry) {
                    NSString *modName = [lbl substringFromIndex:BottomEntryTitlePrefix.length];
                    BOOL allowed = FQXDockIsModuleAllowedByBottomPrefs(modName);
                    if (sw.on != allowed) sw.on = allowed;
                } else {
                    id storedHaptics = [NSUserDefaults.standardUserDefaults objectForKey:@"FanqieX.BottomHaptics.1"];
                    BOOL hapticsOn = [storedHaptics respondsToSelector:@selector(boolValue)] ? [storedHaptics boolValue] : YES;
                    if (sw.on != hapticsOn) sw.on = hapticsOn;
                }
                SEL original = sel_registerName(entry ? "fqx176_toggle:" : "fqx178_bottomOptionChanged:");
                // The visible menu owns one event route. Forward the native
                // persistence action before re-reading the switches from defaults.
                for (id target in sw.allTargets.allObjects) {
                    [sw removeTarget:target action:original forControlEvents:UIControlEventValueChanged];
                    [sw removeTarget:target action:@selector(bottomTabToggleChanged:) forControlEvents:UIControlEventValueChanged];
                }
                [sw addTarget:self action:@selector(bottomTabToggleChanged:) forControlEvents:UIControlEventValueChanged];
            }
        }
    } else {
        cell.textLabel.text = row.title;
        if (row.authorInformation) {
            cell.accessibilityTraits |= UIAccessibilityTraitButton;
            cell.selectionStyle = UITableViewCellSelectionStyleDefault;
            cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
        } else if (row.option || row.originalToggle) {
            UISwitch *toggle = [[UISwitch alloc] init];
            id stored = row.option ? [NSUserDefaults.standardUserDefaults objectForKey:row.option[@"key"]] : nil;
            BOOL enabled = row.originalToggle ? row.originalToggle.on : (stored ? [stored boolValue] : [row.option[@"default"] boolValue]);
            // Both preferences can be true only in externally edited or malformed older data.
            if ([row.option[@"key"] isEqualToString:ScrollZoomKey] && [NSUserDefaults.standardUserDefaults boolForKey:CompactKey])
                enabled = NO;
            toggle.on = row.inverted ? !enabled : enabled;
            cell.detailTextLabel.text = row.option[@"detail"];
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

- (void)blurStepperChanged:(UIStepper *)stepper {
    FQXBlurSlider *slider = objc_getAssociatedObject(stepper, &BlurSliderKey);
    slider.value = (float)ClampSliderPercent(stepper.value, slider.minimumValue, slider.maximumValue);
    [self blurChanged:slider];
}

- (void)blurDidEndTracking:(FQXBlurSlider *)slider {
    NSInteger strength = ClampSliderPercent(slider.value, slider.minimumValue, slider.maximumValue);
    [slider setValue:(float)strength animated:NO];
    [self blurChanged:slider];
}

- (void)blurChanged:(FQXBlurSlider *)slider {
    NSInteger strength = ClampSliderPercent(slider.value, slider.minimumValue, slider.maximumValue);
    NSUserDefaults *defaults = NSUserDefaults.standardUserDefaults;
    NSString *key = slider.accessibilityIdentifier;
    if (!key.length) return;
    // Keep thumb drag smooth while tracking; snap cleanly on release or stepper change.
    if (!slider.isTracking) [slider setValue:(float)strength animated:NO];
    slider.stepper.value = strength;
    NSString *text = [NSString stringWithFormat:@"%ld%%", (long)strength];
    slider.valueLabel.text = text;
    slider.accessibilityValue = text;
    slider.stepper.accessibilityValue = text;
    if ([defaults objectForKey:key] && [defaults integerForKey:key] == strength) return;
    [defaults setInteger:strength forKey:key];
    if ([key isEqualToString:AudioSheetBlurKey]) {
        [defaults setInteger:strength forKey:AudioMoreBlurKey];
    }
    Class cleanup = objc_lookUpClass("FQXCleanup");
    SEL refresh = sel_registerName("refreshForKey:");
    if ([cleanup respondsToSelector:refresh]) ((void (*)(id, SEL, id))objc_msgSend)(cleanup, refresh, key);
}

- (void)bottomTabToggleChanged:(UISwitch *)toggle {
    BOOL entry = [toggle.accessibilityLabel hasPrefix:BottomEntryTitlePrefix];
    id target = entry ? self.router : self.settingsOwner;
    SEL action = sel_registerName(entry ? "fqx176_toggle:" : "fqx178_bottomOptionChanged:");
    if ([target respondsToSelector:action]) {
        ((void (*)(id, SEL, id))objc_msgSend)(target, action, toggle);
    } else if (!entry && [toggle.accessibilityLabel isEqualToString:@"底栏点击震动"]) {
        [NSUserDefaults.standardUserDefaults setBool:toggle.isOn forKey:@"FanqieX.BottomHaptics.1"];
        return;
    } else {
        return;
    }
    if (!entry) return;
    dispatch_async(dispatch_get_main_queue(), ^{
        Class dockMotion = objc_lookUpClass("FQXDockMotion");
        SEL refreshSel = sel_registerName("refreshDockAppearance");
        if ([dockMotion respondsToSelector:refreshSel]) {
            ((void (*)(id, SEL))objc_msgSend)(dockMotion, refreshSel);
        }
        [self rebuild];
    });
}

- (void)performStoredAction:(UIButton *)button {
    for (FQXSettingRow *row in self.catalog) {
        if (row.content != button) continue;
        __weak FQXSettingsMenu *weakSelf = self;
        void (^perform)(void) = ^{
            BOOL resetsBottom = NO;
            for (NSDictionary *action in row.actions) {
                id target = [action[@"target"] anyObject];
                NSString *selName = action[@"selector"];
                if ([selName isEqualToString:@"fqx178_resetBottom:"]) resetsBottom = YES;
                SEL selector = NSSelectorFromString(selName);
                if ([target respondsToSelector:selector])
                    ((void (*)(id, SEL, id))objc_msgSend)(target, selector, button);
            }
            if (resetsBottom) {
                NSUserDefaults *ud = NSUserDefaults.standardUserDefaults;
                [ud removeObjectForKey:DockCollapseModeKey];
                [ud removeObjectForKey:DockSiriaiHideLineKey];
                Class cleanup = objc_lookUpClass("FQXCleanup");
                SEL refreshSel = sel_registerName("refreshForKey:");
                if ([cleanup respondsToSelector:refreshSel]) {
                    ((void (*)(id, SEL, id))objc_msgSend)(cleanup, refreshSel, DockCollapseModeKey);
                }
                [weakSelf rebuild];
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
    if ([toggle.accessibilityIdentifier isEqualToString:CompactKey] || [toggle.accessibilityIdentifier isEqualToString:ScrollZoomKey]) {
        // The core owns both preferences, their mutual exclusion and the live Dock refresh.
        toggle.tag = [toggle.accessibilityIdentifier isEqualToString:CompactKey] ? 2 : 48;
        ((void (*)(id, SEL, id))objc_msgSend)(self.settingsOwner, sel_registerName("fqx178_bottomOptionChanged:"), toggle);
        return;
    }
    if (row.originalToggle) {
        row.originalToggle.on = enabled;
        [row.originalToggle sendActionsForControlEvents:UIControlEventValueChanged];
        Class dockMotion = objc_lookUpClass("FQXDockMotion");
        SEL refreshSel = sel_registerName("refreshAudioGlass");
        if ([dockMotion respondsToSelector:refreshSel]) {
            ((void (*)(id, SEL))objc_msgSend)(dockMotion, refreshSel);
        }
        return;
    }
    [NSUserDefaults.standardUserDefaults setBool:enabled forKey:toggle.accessibilityIdentifier];
    if (enabled && [toggle.accessibilityIdentifier isEqualToString:FQXDockDetachedEnabledPrefKey]) {
        NSString *savedMod = FQXDockDetachedStoredModule();
        if (savedMod.length > 0 && !FQXDockIsModuleAllowedByBottomPrefs(savedMod)) {
            FQXDockRestoreBottomEntryForModule(savedMod);
        }
        dispatch_async(dispatch_get_main_queue(), ^{ [self rebuild]; });
    }
    Class cleanup = objc_lookUpClass("FQXCleanup");
    SEL selector = sel_registerName("refreshForKey:");
    if ([cleanup respondsToSelector:selector])
        ((void (*)(id, SEL, id))objc_msgSend)(cleanup, selector, toggle.accessibilityIdentifier);
}

- (void)beginDiagnosticExport {
    if (self.diagnosticExportPending) return;
    if (self.diagnosticFile) {
        [self shareDiagnosticFile];
        return;
    }
    SEL enqueue = sel_registerName("fqx_enqueueDiagnosticExport:");
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
    NSURL *coreFile = result[@"url"];
    if (!coreFile) {
        self.diagnosticExportPending = NO;
        self.diagnosticFile = nil;
        self.diagnosticError = result[@"error"] ?: @"日志生成失败，请重试。";
        [self.tableView reloadData];
        return;
    }
    NSInteger filter = [NSUserDefaults.standardUserDefaults integerForKey:FQXDiagCategoryFilterPrefKey];
    __weak FQXSettingsMenu *weakSelf = self;
    FQXDiagnosticsHubFinalizeExport(coreFile, filter, ^(NSURL *finalURL, NSString *errorMessage) {
        FQXSettingsMenu *strongSelf = weakSelf;
        if (!strongSelf) return;
        strongSelf.diagnosticExportPending = NO;
        strongSelf.diagnosticFile = finalURL;
        strongSelf.diagnosticError = finalURL ? nil : (errorMessage ?: @"日志生成失败，请重试。");
        [strongSelf.tableView reloadData];
        if (strongSelf.diagnosticFile) {
            [strongSelf shareDiagnosticFile];
        }
    });
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
            if (row.requiresCompact && (CurrentSavedDockCollapseMode() != FQXDockCollapseModeLegacy)) return;
            UITableViewCell *cell = [tableView cellForRowAtIndexPath:path];
            NSArray<NSString *> *options = nil;
            NSArray<NSNumber *> *values = nil;
            NSInteger curIdx = PopoverOptionsAndCurrentIndex(row, &options, &values);
            if (!options.count) return;
            UIAlertController *picker = [UIAlertController alertControllerWithTitle:row.title
                message:nil preferredStyle:UIAlertControllerStyleActionSheet];
            UIPopoverPresentationController *popover = picker.popoverPresentationController;
            popover.sourceView = cell ?: self.view;
            popover.sourceRect = cell
                ? CGRectMake(CGRectGetMaxX(cell.bounds) - 120.0, CGRectGetMaxY(cell.bounds) - 4.0, 100.0, 4.0)
                : CGRectMake(CGRectGetMidX(self.view.bounds), CGRectGetMidY(self.view.bounds), 1.0, 1.0);
            popover.permittedArrowDirections = UIPopoverArrowDirectionUp | UIPopoverArrowDirectionDown;
            __weak FQXSettingsMenu *weakMenu = self;
            NSString *prefKey = row.popoverKey;
            NSInteger kind = row.popoverKind;
            if (kind == 8) {
                if (options.count < 2) return;
                for (NSUInteger i = 0; i < options.count; ++i) {
                    NSString *modTitle = options[i];
                    BOOL hiddenInBottom = !FQXDockIsModuleAllowedByBottomPrefs(modTitle);
                    NSString *label = hiddenInBottom
                        ? [modTitle stringByAppendingString:@"（已隐藏·点选恢复）"]
                        : modTitle;
                    NSString *optTitle = ((NSInteger)i == curIdx)
                        ? [label stringByAppendingString:@"  ✓"] : label;
                    [picker addAction:[UIAlertAction actionWithTitle:optTitle style:UIAlertActionStyleDefault
                        handler:^(__unused UIAlertAction *action) {
                            if (!FQXDockIsModuleAllowedByBottomPrefs(modTitle)) {
                                FQXDockRestoreBottomEntryForModule(modTitle);
                            }
                            [NSUserDefaults.standardUserDefaults setObject:modTitle forKey:prefKey];
                            Class cleanup = objc_lookUpClass("FQXCleanup");
                            SEL selector = sel_registerName("refreshForKey:");
                            if ([cleanup respondsToSelector:selector]) {
                                ((void (*)(id, SEL, id))objc_msgSend)(cleanup, selector, prefKey);
                            }
                            [weakMenu rebuild];
                        }]];
                }
                [picker addAction:[UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:nil]];
                UIViewController *presenter = self.presentedViewController ?: self;
                [presenter presentViewController:picker animated:YES completion:nil];
                return;
            }
            for (NSUInteger i = 0; i < options.count; ++i) {
                NSString *optTitle = (NSInteger)i == curIdx
                    ? [options[i] stringByAppendingString:@"  ✓"] : options[i];
                NSInteger savedVal = (i < values.count) ? values[i].integerValue : (NSInteger)i;
                [picker addAction:[UIAlertAction actionWithTitle:optTitle style:UIAlertActionStyleDefault
                    handler:^(__unused UIAlertAction *action) {
                        NSUserDefaults *ud = NSUserDefaults.standardUserDefaults;
                        if (kind == 13 && [ud objectForKey:SelectionTintStyleKey] != nil) {
                            NSInteger legacyVal = [ud integerForKey:SelectionTintStyleKey];
                            NSString *siblingKey = [prefKey isEqualToString:DockSelectionTintStyleKey]
                                ? DramaTopSelectionTintStyleKey
                                : DockSelectionTintStyleKey;
                            if ([ud objectForKey:siblingKey] == nil) {
                                [ud setInteger:legacyVal forKey:siblingKey];
                            }
                            [ud removeObjectForKey:SelectionTintStyleKey];
                        }
                        [ud setInteger:savedVal forKey:prefKey];
                        if (kind == 11) {
                            FQXSettingsMenu *strongMenu = weakMenu;
                            BOOL wantLegacyCompact = (savedVal == FQXDockCollapseModeLegacy);
                            SEL ownerAction = sel_registerName("fqx178_bottomOptionChanged:");
                            if ([ud boolForKey:ScrollZoomKey]) {
                                if ([strongMenu.settingsOwner respondsToSelector:ownerAction]) {
                                    UISwitch *offZoom = [UISwitch new];
                                    offZoom.on = NO;
                                    offZoom.tag = 48;
                                    ((void (*)(id, SEL, id))objc_msgSend)(strongMenu.settingsOwner, ownerAction, offZoom);
                                } else {
                                    [ud setBool:NO forKey:ScrollZoomKey];
                                }
                            }
                            if ([ud boolForKey:CompactKey] != wantLegacyCompact) {
                                if ([strongMenu.settingsOwner respondsToSelector:ownerAction]) {
                                    UISwitch *compactSw = [UISwitch new];
                                    compactSw.on = wantLegacyCompact;
                                    compactSw.tag = 2;
                                    ((void (*)(id, SEL, id))objc_msgSend)(strongMenu.settingsOwner, ownerAction, compactSw);
                                } else {
                                    [ud setBool:wantLegacyCompact forKey:CompactKey];
                                }
                            }
                        }
                        if (kind == 1) [ud setBool:(savedVal == 1) forKey:BottomIconsOnlyLegacyKey];
                        if (kind == 4) {
                            [ud removeObjectForKey:@"FanqieX.CommentGlassFrosted.1"];
                            [ud removeObjectForKey:@"FanqieX.CommentMaterialMode.1"];
                        }
                        if (kind == 9) {
                            FQXSettingsMenu *strongMenu = weakMenu;
                            if (strongMenu.diagnosticFile.isFileURL) {
                                [NSFileManager.defaultManager removeItemAtURL:strongMenu.diagnosticFile error:NULL];
                            }
                            strongMenu.diagnosticFile = nil;
                        }
                        Class cleanup = objc_lookUpClass("FQXCleanup");
                        SEL selector = sel_registerName("refreshForKey:");
                        if ([cleanup respondsToSelector:selector]) {
                            ((void (*)(id, SEL, id))objc_msgSend)(cleanup, selector, prefKey);
                        }
                        if (kind == 11) [weakMenu rebuild];
                        else [weakMenu.tableView reloadData];
                    }]];
            }
            [picker addAction:[UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:nil]];
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
            SEL action = sel_registerName("presentFromController:");
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
