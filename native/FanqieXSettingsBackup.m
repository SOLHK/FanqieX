#import <UIKit/UIKit.h>
#import <UniformTypeIdentifiers/UniformTypeIdentifiers.h>
#import <math.h>
#import <objc/message.h>

#import "FQXLayoutAndSheetPolicy.h"
#import "FQXSiriaiDockMotion.h"
#import "FanqieXSettingsCodec.h"

static NSString *const DramaPreferencePrefix = @"FanqieX.DramaCategory.";
static NSString *const HiddenBookstoreCategories = @"FanqieX.BookstoreHiddenCategories.1";
static NSString *const ReaderThemePreset = @"FanqieX.ReaderThemePreset.1";
static NSString *const LegacyCompact = @"FanqieX.BottomDramaCompact.1";
static NSString *const ScrollZoom = @"FanqieX.DramaDockScrollZoom.1";
static NSString *const DockCollapseMode = @"FanqieX.DockCollapseMode.1";
static NSString *const DockSiriaiHideLine = @"FanqieX.DockSiriaiHideLine.1";
static NSString *const BottomDisplayMode = @"FanqieX.BottomDisplayMode.1";
static NSString *const BottomIconsOnly = @"FanqieX.BottomIconsOnly.1";
static NSString *const CommentMaterialStyle = @"FanqieX.CommentMaterialStyle.1";
static NSString *const CommentComposerStyle = @"FanqieX.CommentComposerStyle.1";

static NSDictionary<NSString *, id> *BuiltInSettings(void) {
    NSMutableDictionary<NSString *, id> *defaults = [@{
        @"FanqieAdBlock.Options.1": @(FQXLegacyAdDefaultOptionsMask),
        @"FanqieAdBlock.GlassDisabled.1": @NO,
        @"FanqieX.DiagnosticsEnabled": @YES,
        @"FanqieX.EnhancedDiagnostics.1": @NO,
        @"FanqieX.BottomBookstore.1": @YES,
        @"FanqieX.BottomDrama.1": @YES,
        @"FanqieX.BottomBookshelf.1": @YES,
        @"FanqieX.BottomMine.1": @YES,
        @"FanqieX.BottomMall.1": @YES,
        BottomIconsOnly: @NO,
        BottomDisplayMode: @0,
        @"FanqieX.DockMaterial.1": @0,
        @"FanqieX.SelectionTintStyle.1": @0,
        @"FanqieX.DramaButtonSurfaceStyle.1": @0,
        @"FanqieX.GlassDarkTint.1": @NO,
        @"FanqieX.DockDetachedEnabled.1": @NO,
        @"FanqieX.DockDetachedModule.1": @"",
        @"FanqieX.DiagCategoryFilter.1": @0,
        @"FanqieX.DockBlur.1": @0,
        @"FanqieX.CommentBlur.1": @0,
        @"FanqieX.AudioButtonBlur.1": @0,
        @"FanqieX.AudioMoreBlur.1": @0,
        @"FanqieX.AudioSheetMaterial.1": @1,
        @"FanqieX.AudioSheetBlur.1": @0,
        @"FanqieX.DramaHeaderBlur.1": @0,
        @"FanqieX.DramaHeaderButtonScale.1": @100,
        @"FanqieX.DramaPlaybackOptionsMaterial.1": @0,
        @"FanqieX.DramaPlaybackOptionsBlur.1": @0,
        @"FanqieX.ShareMaterialStyle.1": @1,
        @"FanqieX.ShareBlur.1": @0,
        @"FanqieX.DramaAlbumTitleLines.1": @0,
        @"FanqieX.DramaNaloiaFavorite.1": @NO,
        @"FanqieX.DramaNaloiaComment.1": @NO,
        @"FanqieX.DramaNaloiaLike.1": @NO,
        @"FanqieX.DramaNaloiaShare.1": @NO,
        @"FanqieX.ReaderHotCommentBadge.1": @YES,
        @"FanqieX.BottomHaptics.1": @YES,
        LegacyCompact: @NO,
        ScrollZoom: @NO,
        DockCollapseMode: @0,
        DockSiriaiHideLine: @NO,
        @"FanqieX.BottomDramaCompactPosition.1": @0,
        @"FanqieX.BottomLengthScale.1": @100,
        @"FanqieX.BottomHeightScale.1": @100,
        @"FanqieX.BottomButtonWidthScale.1": @100,
        @"FanqieX.BottomIconPointSize.1": @28,
        @"FanqieX.DramaActionDiameter.1": @50,
        @"FanqieX.DramaOutlinePointSize.1": @36,
        @"FanqieX.DramaCategories.1": @YES,
        @"FanqieX.DramaWatchTab.1": @YES,
        @"FanqieX.DramaRecentTab.1": @YES,
        @"FanqieX.DramaFavoritesTab.1": @YES,
        @"FanqieX.DramaComicTab.1": @YES,
        @"FanqieX.DramaSearch.1": @YES,
        @"FanqieX.DramaAuthorDeclaration.1": @YES,
        @"FanqieX.DramaOriginalNovel.1": @YES,
        @"FanqieX.DramaRecommendationReason.1": @YES,
        @"FanqieX.DramaDefaultClean.1": @NO,
        @"FanqieX.DramaRevealOnPause.1": @NO,
        @"FanqieX.DramaHighestQuality.1": @NO,
        @"FanqieX.DramaPureClean.1": @NO,
        @"FanqieX.DramaPinchPureClean.1": @NO,
        @"FanqieX.DramaPinchHaptic.1": @YES,
        @"FanqieX.DramaDoubleTapComment.1": @NO,
        @"FanqieX.DramaCommentNoVideoShift.1": @NO,
        @"FanqieX.DramaExitCollectAlert.1": @NO,
        @"FanqieX.DramaHideSeriesTag.1": @NO,
        @"FanqieX.DramaHideTitleBadge.1": @NO,
        @"FanqieX.DramaHideGenreTags.1": @NO,
        @"FanqieX.DramaHideEpisodeAdaptations.1": @NO,
        @"FanqieX.DramaHideEpisodeSameSeries.1": @NO,
        @"FanqieX.DramaHideEpisodeRecommend.1": @NO,
        @"FanqieX.DramaUnlockDanmaku.1": @YES,
        @"FanqieX.DramaShowDanmakuButton.1": @YES,
        CommentMaterialStyle: @0,
        @"FanqieX.CommentAppearanceMode.1": @0,
        CommentComposerStyle: @0,
        @"FanqieX.AudioLiquidGlass.1": @NO,
        @"FanqieX.CommentActivityBanner.1": @YES,
        @"FanqieX.CommentSearchEntrance.1": @YES,
        @"FanqieX.DramaFollowBottomWidth.1": @NO,
        @"FanqieX.FullscreenFill.1": @NO,
        @"FanqieX.MineBenefitsCard.1": @YES,
        @"FanqieX.MineRecommendations.1": @YES,
        @"FanqieX.MineContinueDrama.1": @YES,
        @"FanqieX.MineQuickIconsOnly.1": @NO,
        @"FanqieX.ReaderBottomBackground.1": @YES,
        @"FanqieX.ReaderEarnMore.1": @YES,
        @"FanqieX.ReaderScreenshotQuickShare.1": @YES,
        @"FanqieX.ReaderThemeIsolation.1": @NO,
        @"FanqieX.ShelfFilterButton.1": @YES,
        @"FanqieX.ShelfHistoryFilterAll.1": @YES,
        @"FanqieX.ShelfHistoryFilterRead.1": @YES,
        @"FanqieX.ShelfHistoryFilterListen.1": @YES,
        @"FanqieX.ShelfHistoryFilterDrama.1": @YES,
        @"FanqieX.ShelfHistoryFilterShortStory.1": @YES,
        @"FanqieX.ShelfHistoryFilterComic.1": @YES,
        @"FanqieX.ShelfHistoryFilterTopic.1": @YES,
        @"FanqieX.ShelfHistoryFilterBtn.1": @YES,
        @"FanqieX.ShelfHistoryEditBtn.1": @YES,
        @"FanqieX.ShelfMotionComic.1": @YES,
        @"FanqieX.ShelfReadingDuration.1": @YES,
        @"FanqieX.SidebarGames.1": @YES,
        @"FanqieX.StartupTab.1": @0,
        HiddenBookstoreCategories: @[],
    } mutableCopy];
    Class cleanup = NSClassFromString(@"FQXCleanup");
    SEL optionRows = NSSelectorFromString(@"optionRows");
    if ([cleanup respondsToSelector:optionRows]) {
        NSArray<NSDictionary *> *rows = ((id (*)(id, SEL))objc_msgSend)(cleanup, optionRows);
        for (NSDictionary *row in rows) {
            NSString *key = row[@"key"];
            NSNumber *value = row[@"default"];
            if (key.length && value && !defaults[key]) defaults[key] = @([value boolValue]);
        }
    }
    return defaults;
}

static BOOL IsDramaPreference(NSString *key) {
    if (![key hasPrefix:DramaPreferencePrefix] || ![key hasSuffix:@".1"] ||
        key.length <= DramaPreferencePrefix.length + 2) return NO;
    NSString *type = [key substringWithRange:NSMakeRange(DramaPreferencePrefix.length,
        key.length - DramaPreferencePrefix.length - 2)];
    if (type.length > 10 || (type.length > 1 && [type characterAtIndex:0] == '0')) return NO;
    unsigned long long identifier = 0;
    for (NSUInteger index = 0; index < type.length; index++) {
        unichar digit = [type characterAtIndex:index];
        if (digit < '0' || digit > '9') return NO;
        identifier = identifier * 10 + digit - '0';
    }
    return identifier <= INT32_MAX;
}

static id ValidSetting(NSString *key, id value, NSDictionary<NSString *, id> *defaults, BOOL *known) {
    id fallback = defaults[key];
    *known = YES;
    if ([key isEqualToString:ReaderThemePreset]) {
        return [value isKindOfClass:NSString.class] && [value length] > 0 && [value length] <= 256 ? value : nil;
    }
    if ([key isEqualToString:@"FanqieX.DockDetachedModule.1"]) {
        return [value isKindOfClass:NSString.class] && [(NSString *)value length] <= 64 ? value : nil;
    }
    if ([key isEqualToString:HiddenBookstoreCategories]) {
        if (![value isKindOfClass:NSArray.class]) return nil;
        for (id title in value) {
            if (![title isKindOfClass:NSString.class] || [title length] == 0 || [title length] > 256) return nil;
        }
        return value;
    }
    if (!fallback && !IsDramaPreference(key)) {
        *known = NO;
        return nil;
    }
    if (![value isKindOfClass:NSNumber.class]) return nil;
    double number = [value doubleValue];
    if (!isfinite(number)) return nil;
    if ([key isEqualToString:@"FanqieAdBlock.Options.1"]) {
        return number >= 0 && number <= 0xFFFFF && number == trunc(number) ? @((NSInteger)number) : nil;
    }
    if ([key isEqualToString:@"FanqieX.DramaPlaybackOptionsMaterial.1"]) {
        return number == -1 || number == 0 || number == 1 || number == 2 || number == 4
            ? @((NSInteger)number) : nil;
    }
    if ([key isEqualToString:@"FanqieX.StartupTab.1"] ||
        [key isEqualToString:@"FanqieX.DockMaterial.1"] ||
        [key isEqualToString:@"FanqieX.SelectionTintStyle.1"] ||
        [key isEqualToString:@"FanqieX.DramaButtonSurfaceStyle.1"] ||
        [key isEqualToString:DockCollapseMode] ||
        [key isEqualToString:@"FanqieX.DockBlur.1"] ||
        [key isEqualToString:@"FanqieX.CommentBlur.1"] ||
        [key isEqualToString:@"FanqieX.AudioButtonBlur.1"] ||
        [key isEqualToString:@"FanqieX.AudioMoreBlur.1"] ||
        [key isEqualToString:@"FanqieX.AudioSheetMaterial.1"] ||
        [key isEqualToString:@"FanqieX.AudioSheetBlur.1"] ||
        [key isEqualToString:@"FanqieX.DramaHeaderBlur.1"] ||
        [key isEqualToString:@"FanqieX.DramaPlaybackOptionsBlur.1"] ||
        [key isEqualToString:@"FanqieX.ShareMaterialStyle.1"] ||
        [key isEqualToString:@"FanqieX.ShareBlur.1"] ||
        [key isEqualToString:@"FanqieX.DramaAlbumTitleLines.1"] ||
        [key isEqualToString:@"FanqieX.BottomDramaCompactPosition.1"] ||
        [key isEqualToString:BottomDisplayMode] ||
        [key isEqualToString:CommentMaterialStyle] ||
        [key isEqualToString:@"FanqieX.CommentAppearanceMode.1"] ||
        [key isEqualToString:CommentComposerStyle] ||
        [key isEqualToString:@"FanqieX.CommentMaterialMode.1"] ||
        [key isEqualToString:@"FanqieX.DiagCategoryFilter.1"]) {
        NSInteger maximum = [key isEqualToString:@"FanqieX.StartupTab.1"] ? 4 : 2;
        if ([key isEqualToString:@"FanqieX.DramaAlbumTitleLines.1"]) maximum = 1;
        if ([key isEqualToString:DockCollapseMode]) maximum = 3;
        if ([key isEqualToString:@"FanqieX.DockMaterial.1"]) maximum = 5;
        if ([key isEqualToString:CommentMaterialStyle] ||
            [key isEqualToString:@"FanqieX.ShareMaterialStyle.1"] ||
            [key isEqualToString:@"FanqieX.AudioSheetMaterial.1"]) {
            maximum = 4;
            if (number == 3) return @0;
        }
        if ([key isEqualToString:@"FanqieX.DiagCategoryFilter.1"]) maximum = 6;
        if ([key isEqualToString:@"FanqieX.DockBlur.1"] || [key isEqualToString:@"FanqieX.CommentBlur.1"] ||
            [key isEqualToString:@"FanqieX.AudioButtonBlur.1"] || [key isEqualToString:@"FanqieX.AudioMoreBlur.1"] ||
            [key isEqualToString:@"FanqieX.AudioSheetBlur.1"] ||
            [key isEqualToString:@"FanqieX.DramaHeaderBlur.1"] ||
            [key isEqualToString:@"FanqieX.DramaPlaybackOptionsBlur.1"] ||
            [key isEqualToString:@"FanqieX.ShareBlur.1"]) maximum = 100;
        return number >= 0 && number <= maximum && number == trunc(number) ? @((NSInteger)number) : nil;
    }
    NSDictionary<NSString *, NSArray<NSNumber *> *> *ranges = @{
        @"FanqieX.BottomLengthScale.1": @[@50, @100],
        @"FanqieX.BottomHeightScale.1": @[@80, @125],
        @"FanqieX.BottomButtonWidthScale.1": @[@70, @100],
        @"FanqieX.BottomIconPointSize.1": @[@16, @32],
        @"FanqieX.DramaHeaderButtonScale.1": @[@70, @130],
        @"FanqieX.DramaActionDiameter.1": @[@36, @54],
        @"FanqieX.DramaOutlinePointSize.1": @[@26, @42],
    };
    NSArray<NSNumber *> *range = ranges[key];
    if (range) return number >= range[0].doubleValue && number <= range[1].doubleValue ? @(number) : nil;
    // Prior exporters used both JSON booleans and numeric 0/1 for switches.
    if (number != 0 && number != 1) return nil;
    return @((BOOL)(number == 1));
}

static NSDictionary<NSString *, id> *BackupSnapshot(NSUserDefaults *storage) {
    NSDictionary<NSString *, id> *defaults = BuiltInSettings();
    NSMutableDictionary<NSString *, id> *snapshot = [NSMutableDictionary dictionary];
    NSArray *inherited = @[BottomDisplayMode, DockCollapseMode, CommentComposerStyle, @"FanqieX.DramaWatchTab.1",
        @"FanqieX.DramaRecentTab.1", @"FanqieX.DramaFavoritesTab.1", @"FanqieX.DramaComicTab.1"];
    [defaults enumerateKeysAndObjectsUsingBlock:^(NSString *key, id value, BOOL *stop) {
        (void)stop;
        if ([inherited containsObject:key]) return;
        BOOL known;
        id normalized = ValidSetting(key, value, defaults, &known);
        if (normalized) snapshot[key] = normalized;
    }];
    [storage.dictionaryRepresentation enumerateKeysAndObjectsUsingBlock:^(NSString *key, id value, BOOL *stop) {
        (void)stop;
        BOOL known;
        id normalized = ValidSetting(key, value, defaults, &known);
        if (normalized) snapshot[key] = normalized;
    }];
    // Resolve the legacy Dock layout and the composer’s material-dependent default.
    if (!snapshot[BottomDisplayMode]) snapshot[BottomDisplayMode] = @([snapshot[BottomIconsOnly] boolValue] ? 1 : 0);
    if (!snapshot[CommentComposerStyle]) {
        NSInteger material = [snapshot[CommentMaterialStyle] integerValue];
        snapshot[CommentComposerStyle] = @(material == 1 || material == 2 || material == 4 ? 1 : 0);
    }
    for (id row in [storage arrayForKey:@"FanqieX.DramaCategoryTitles.1"]) {
        if (![row isKindOfClass:NSDictionary.class] || ![row[@"type"] isKindOfClass:NSNumber.class]) continue;
        NSString *key = [NSString stringWithFormat:@"%@%@.1", DramaPreferencePrefix, row[@"type"]];
        if (IsDramaPreference(key) && !snapshot[key]) snapshot[key] = @YES;
    }
    if ([snapshot[LegacyCompact] boolValue]) snapshot[ScrollZoom] = @NO;
    int storedMode = snapshot[DockCollapseMode] ? [snapshot[DockCollapseMode] intValue] : -1;
    FQXDockCollapseMode resolvedMode = FQXResolveDockCollapseMode(storedMode,
        [snapshot[LegacyCompact] boolValue] ? 1 : 0, [snapshot[ScrollZoom] boolValue] ? 1 : 0);
    snapshot[DockCollapseMode] = @((NSInteger)resolvedMode);
    if (storedMode >= 0) {
        snapshot[LegacyCompact] = @(resolvedMode == FQXDockCollapseModeLegacy);
        snapshot[ScrollZoom] = @NO;
    }
    return snapshot;
}

static BOOL ApplySettings(NSUserDefaults *storage, NSString *domainName,
                          NSDictionary<NSString *, id> *settings, BOOL replace) {
    if (!domainName.length) return NO;
    NSDictionary<NSString *, id> *current = [storage persistentDomainForName:domainName];
    // A partial merge may select one mode while the other is already enabled.
    // For a contradictory backup, preserve the original single-button mode.
    BOOL legacy = settings[LegacyCompact] ? [settings[LegacyCompact] boolValue] : (!replace && [current[LegacyCompact] boolValue]);
    BOOL zoom = settings[ScrollZoom] ? [settings[ScrollZoom] boolValue] : (!replace && [current[ScrollZoom] boolValue]);
    if (legacy && zoom) {
        NSString *other = [settings[ScrollZoom] boolValue] && ![settings[LegacyCompact] boolValue] ? LegacyCompact : ScrollZoom;
        NSMutableDictionary *normalized = [settings mutableCopy];
        normalized[other] = @NO;
        settings = normalized;
    }
    if (settings[DockCollapseMode]) {
        NSInteger modeVal = [settings[DockCollapseMode] integerValue];
        BOOL wantLegacy = (modeVal == FQXDockCollapseModeLegacy);
        if ((settings[LegacyCompact] && [settings[LegacyCompact] boolValue] != wantLegacy) ||
            (!replace && !settings[LegacyCompact] && [current[LegacyCompact] boolValue] != wantLegacy) ||
            (settings[ScrollZoom] && [settings[ScrollZoom] boolValue]) ||
            (!replace && !settings[ScrollZoom] && [current[ScrollZoom] boolValue])) {
            NSMutableDictionary *normalized = [settings mutableCopy];
            if (settings[LegacyCompact] || (!replace && [current[LegacyCompact] boolValue] != wantLegacy))
                normalized[LegacyCompact] = @(wantLegacy);
            if (settings[ScrollZoom] || (!replace && [current[ScrollZoom] boolValue]))
                normalized[ScrollZoom] = @NO;
            settings = normalized;
        }
    }
    NSMutableArray<NSString *> *removals = [NSMutableArray array];
    if (!replace && !settings[DockCollapseMode] && (settings[LegacyCompact] || settings[ScrollZoom]) && current[DockCollapseMode]) {
        [removals addObject:DockCollapseMode];
    }
    if (replace) {
        NSDictionary<NSString *, id> *defaults = BuiltInSettings();
        for (NSString *key in current) {
            if (!settings[key] && (defaults[key] || [key isEqualToString:ReaderThemePreset] || IsDramaPreference(key))) {
                [removals addObject:key];
            }
        }
    }
    // Use the same store and change notifications as the settings controls.
    for (NSString *key in removals) [storage removeObjectForKey:key];
    for (NSString *key in settings) {
        if (![current[key] isEqual:settings[key]]) [storage setObject:settings[key] forKey:key];
    }

    NSDictionary<NSString *, id> *saved = [storage persistentDomainForName:domainName];
    for (NSString *key in removals) {
        if (saved[key]) return NO;
    }
    for (NSString *key in settings) {
        if (![saved[key] isEqual:settings[key]] || ![[storage objectForKey:key] isEqual:settings[key]]) return NO;
    }
    return YES;
}

static NSString *CodecError(FQXSettingsCodecStatus status) {
    switch (status) {
        case FQXSettingsCodecFormat: return @"请选择由 FanqieX 生成的 .fqcfg 文件。";
        case FQXSettingsCodecVersion: return @"这个备份的版本或压缩格式与当前 FanqieX 不兼容。";
        case FQXSettingsCodecLength: return @"备份大小无效或文件不完整。";
        case FQXSettingsCodecChecksum: return @"校验失败，备份文件可能已损坏。";
        case FQXSettingsCodecCompression: return @"备份文件的压缩数据无效。";
        default: return @"暂时无法处理备份文件。";
    }
}

static void AfterDismissal(UIViewController *controller, dispatch_block_t action) {
    dispatch_async(dispatch_get_main_queue(), ^{
        if (!controller.presentingViewController) {
            action();
            return;
        }
        if (controller.isBeingDismissed &&
            [controller.transitionCoordinator animateAlongsideTransition:nil
                completion:^(__unused id<UIViewControllerTransitionCoordinatorContext> context) { action(); }]) return;
        [controller dismissViewControllerAnimated:YES completion:action];
    });
}

@interface FQXSettingsBackup : UITableViewController <UIDocumentPickerDelegate>
@property (nonatomic, weak) UIViewController *settingsOwner;
+ (void)presentFromController:(UIViewController *)owner;
@end

@implementation FQXSettingsBackup

+ (void)presentFromController:(UIViewController *)owner {
    if (!owner || owner.presentedViewController) return;
    FQXSettingsBackup *page = [[self alloc] initWithStyle:UITableViewStyleInsetGrouped];
    page.settingsOwner = owner;
    page.title = @"设置备份与恢复";
    if (owner.navigationController) {
        [owner.navigationController pushViewController:page animated:YES];
    } else {
        page.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc]
            initWithBarButtonSystemItem:UIBarButtonSystemItemDone target:page action:@selector(closePage)];
        [owner presentViewController:[[UINavigationController alloc] initWithRootViewController:page]
                             animated:YES completion:nil];
    }
}

- (void)closePage {
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    (void)tableView;
    return 2;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    (void)tableView;
    return section == 0 ? 2 : 1;
}

- (NSString *)tableView:(UITableView *)tableView titleForFooterInSection:(NSInteger)section {
    (void)tableView;
    return section == 0 ? @"备份仅包含 FanqieX 设置。导入后请完全退出并重新打开番茄小说。"
                        : @"移除已保存的 FanqieX 设置，恢复这一版的默认值。";
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"FanqieXBackup"];
    if (!cell) cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"FanqieXBackup"];
    UIListContentConfiguration *content = cell.defaultContentConfiguration;
    if (indexPath.section == 1) {
        content.text = @"恢复默认设置";
        content.textProperties.color = UIColor.systemRedColor;
    } else {
        content.text = indexPath.row == 0 ? @"导出设置备份" : @"导入设置备份";
    }
    cell.contentConfiguration = content;
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    if (indexPath.section == 1) [self confirmReset];
    else if (indexPath.row == 0) [self exportFromCell:[tableView cellForRowAtIndexPath:indexPath]];
    else [self showImportPicker];
}

- (void)showMessage:(NSString *)message title:(NSString *)title {
    UIAlertController *alert = [UIAlertController alertControllerWithTitle:title message:message preferredStyle:UIAlertControllerStyleAlert];
    [alert addAction:[UIAlertAction actionWithTitle:@"好" style:UIAlertActionStyleDefault handler:nil]];
    [self presentViewController:alert animated:YES completion:nil];
}

- (void)exportFromCell:(UITableViewCell *)cell {
    NSDictionary *snapshot = BackupSnapshot(NSUserDefaults.standardUserDefaults);
    NSData *payload = [NSJSONSerialization dataWithJSONObject:snapshot options:NSJSONWritingSortedKeys error:NULL];
    FQXSettingsBuffer encoded;
    FQXSettingsCodecStatus status = FQXSettingsEncode(payload.bytes, payload.length, &encoded);
    if (status != FQXSettingsCodecOK) {
        [self showMessage:CodecError(status) title:@"无法导出设置"];
        return;
    }
    NSData *data = [NSData dataWithBytesNoCopy:encoded.bytes length:encoded.length freeWhenDone:YES];
    NSFileManager *files = NSFileManager.defaultManager;
    NSURL *directory = [files.temporaryDirectory URLByAppendingPathComponent:NSUUID.UUID.UUIDString isDirectory:YES];
    NSURL *url = [directory URLByAppendingPathComponent:@"FanqieX-设置备份.fqcfg" isDirectory:NO];
    if (![files createDirectoryAtURL:directory withIntermediateDirectories:NO attributes:nil error:NULL] ||
        ![data writeToURL:url options:NSDataWritingAtomic error:NULL]) {
        [files removeItemAtURL:directory error:NULL];
        [self showMessage:@"无法创建备份文件。" title:@"无法导出设置"];
        return;
    }
    UIActivityViewController *share = [[UIActivityViewController alloc] initWithActivityItems:@[url] applicationActivities:nil];
    share.popoverPresentationController.sourceView = cell ?: self.view;
    share.popoverPresentationController.sourceRect = (cell ?: self.view).bounds;
    share.completionWithItemsHandler = ^(UIActivityType type, BOOL completed, NSArray *items, NSError *error) {
        (void)type;
        (void)completed;
        (void)items;
        (void)error;
        [files removeItemAtURL:directory error:NULL];
    };
    [self presentViewController:share animated:YES completion:nil];
}

- (void)showImportPicker {
    UIDocumentPickerViewController *picker = [[UIDocumentPickerViewController alloc]
        initForOpeningContentTypes:@[UTTypeData] asCopy:YES];
    picker.delegate = self;
    [self presentViewController:picker animated:YES completion:nil];
}

- (void)documentPicker:(UIDocumentPickerViewController *)controller didPickDocumentsAtURLs:(NSArray<NSURL *> *)urls {
    NSURL *url = urls.firstObject;
    AfterDismissal(controller, ^{ [self processImportURL:url]; });
}

- (void)processImportURL:(NSURL *)url {
    NSData *file = nil;
    if (url.isFileURL && [url.pathExtension caseInsensitiveCompare:@"fqcfg"] == NSOrderedSame) {
        BOOL access = [url startAccessingSecurityScopedResource];
        NSFileHandle *handle = [NSFileHandle fileHandleForReadingFromURL:url error:NULL];
        file = [handle readDataUpToLength:FQXSettingsFileLimit + 1 error:NULL];
        [handle closeAndReturnError:NULL];
        if (access) [url stopAccessingSecurityScopedResource];
    }
    FQXSettingsBuffer decoded;
    FQXSettingsCodecStatus status = FQXSettingsDecode(file.bytes, file.length, &decoded);
    if (status != FQXSettingsCodecOK) {
        [self showMessage:CodecError(status) title:@"无法导入设置"];
        return;
    }
    NSData *payload = [NSData dataWithBytesNoCopy:decoded.bytes length:decoded.length freeWhenDone:YES];
    id object = [NSJSONSerialization JSONObjectWithData:payload options:0 error:NULL];
    if (![object isKindOfClass:NSDictionary.class]) {
        [self showMessage:@"备份中的配置内容无效。" title:@"无法导入设置"];
        return;
    }
    NSDictionary<NSString *, id> *defaults = BuiltInSettings();
    NSMutableDictionary<NSString *, id> *settings = [NSMutableDictionary dictionary];
    NSUInteger skipped = 0;
    for (NSString *key in (NSDictionary *)object) {
        BOOL known;
        id value = ValidSetting(key, object[key], defaults, &known);
        if (value) settings[key] = value;
        else if (!known) skipped++;
        else {
            NSString *field = [key hasPrefix:@"FanqieX."] ? [key substringFromIndex:8] : key;
            [self showMessage:[NSString stringWithFormat:@"备份中的「%@」设置值无效，未修改当前设置。", field]
                        title:@"无法导入设置"];
            return;
        }
    }
    if (!settings.count) {
        [self showMessage:@"备份没有这一版可导入的设置项。" title:@"无法导入设置"];
        return;
    }
    [self confirmImport:[settings copy] skipped:skipped];
}

- (void)confirmImport:(NSDictionary<NSString *, id> *)settings skipped:(NSUInteger)skipped {
    NSString *instructions = @"合并只覆盖备份中包含的设置。替换会将其余 FanqieX 设置恢复默认。";
    if (skipped) instructions = [instructions stringByAppendingFormat:@" 已跳过 %lu 个未知项。", (unsigned long)skipped];
    UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"导入设置备份"
        message:instructions preferredStyle:UIAlertControllerStyleAlert];
    [alert addAction:[UIAlertAction actionWithTitle:@"合并" style:UIAlertActionStyleDefault handler:^(UIAlertAction *action) {
        (void)action;
        [self importSettings:settings replace:NO];
    }]];
    [alert addAction:[UIAlertAction actionWithTitle:@"替换" style:UIAlertActionStyleDestructive handler:^(UIAlertAction *action) {
        (void)action;
        [self importSettings:settings replace:YES];
    }]];
    [alert addAction:[UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:nil]];
    [self presentViewController:alert animated:YES completion:nil];
}

- (void)importSettings:(NSDictionary<NSString *, id> *)settings replace:(BOOL)replace {
    [self applySettings:settings replace:replace successTitle:@"设置已导入"];
}

- (void)applySettings:(NSDictionary<NSString *, id> *)settings replace:(BOOL)replace successTitle:(NSString *)title {
    AfterDismissal(self.presentedViewController, ^{
        BOOL saved = ApplySettings(NSUserDefaults.standardUserDefaults, NSBundle.mainBundle.bundleIdentifier, settings, replace);
        if (!saved) {
            [self showMessage:@"无法写入配置，请重试。" title:@"设置未保存"];
            return;
        }
        UIAlertController *notice = [UIAlertController alertControllerWithTitle:title
            message:@"请完全退出并重新打开番茄小说。" preferredStyle:UIAlertControllerStyleAlert];
        [notice addAction:[UIAlertAction actionWithTitle:@"好" style:UIAlertActionStyleDefault handler:^(UIAlertAction *action) {
            (void)action;
            AfterDismissal(self.presentedViewController, ^{ [self closeSettings]; });
        }]];
        [self presentViewController:notice animated:YES completion:nil];
    });
}

- (void)closeSettings {
    UIViewController *owner = self.settingsOwner;
    UINavigationController *navigation = owner.navigationController;
    if (navigation.presentingViewController) {
        [navigation dismissViewControllerAnimated:YES completion:nil];
    } else if (owner.presentingViewController) {
        [owner dismissViewControllerAnimated:YES completion:nil];
    } else {
        NSUInteger index = [navigation.viewControllers indexOfObjectIdenticalTo:owner];
        if (index != NSNotFound && index > 0) {
            [navigation popToViewController:navigation.viewControllers[index - 1] animated:YES];
        }
    }
}

- (void)confirmReset {
    UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"恢复 FanqieX 默认设置？"
        message:@"此操作会移除已保存的 FanqieX 设置。" preferredStyle:UIAlertControllerStyleAlert];
    [alert addAction:[UIAlertAction actionWithTitle:@"恢复默认" style:UIAlertActionStyleDestructive handler:^(UIAlertAction *action) {
        (void)action;
        [self applySettings:@{} replace:YES successTitle:@"已恢复默认设置"];
    }]];
    [alert addAction:[UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:nil]];
    [self presentViewController:alert animated:YES completion:nil];
}

@end
