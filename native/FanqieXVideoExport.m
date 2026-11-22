#import <AVFoundation/AVFoundation.h>
#import <UIKit/UIKit.h>
#import <objc/message.h>
#import <objc/runtime.h>
#import "VideoContainer.h"
#import "FQXHookInstaller.h"

// The host uses TTVideoEngine's playback-state enum. A ready/preloaded
// player is deliberately insufficient to replace the current selection.
enum { PlaybackPlaying = 1 };

static void (*NativePlaybackChanged)(id, SEL, id, NSInteger);
static __weak UIView *RecentPlayer;
static __weak id RecentEngine;
static __weak id RecentVideoInfo;
static NSString *RecentVideoID;
static NSURL *RecentSource;
static NSString *RecentTitle;
static NSString *RecentFormat;
static NSString *RecentUnavailableReason;

static Method HostMethod(id owner, SEL selector, const char *encoding) {
    Method method = class_getInstanceMethod(object_getClass(owner), selector);
    return method && strcmp(method_getTypeEncoding(method), encoding) == 0 ? method : NULL;
}

static id HostObject(id owner, SEL selector) {
    if (!HostMethod(owner, selector, "@16@0:8")) return nil;
    return ((id (*)(id, SEL))objc_msgSend)(owner, selector);
}

static BOOL HostFlag(id owner, SEL selector) {
    return HostMethod(owner, selector, "B16@0:8") != NULL &&
           ((BOOL (*)(id, SEL))objc_msgSend)(owner, selector);
}

static BOOL HasProtectionMarker(id value) {
    if ([value isKindOfClass:NSString.class] || [value isKindOfClass:NSData.class]) return [value length] > 0;
    if ([value isKindOfClass:NSNumber.class]) return [value boolValue];
    if ([value isKindOfClass:NSDictionary.class]) return [value count] > 0;
    return value != nil && value != NSNull.null;
}

static NSURL *MediaSourceURL(id value) {
    NSURL *source = nil;
    if ([value isKindOfClass:NSURL.class]) source = value;
    else if ([value isKindOfClass:NSString.class] && [value length]) {
        source = [value hasPrefix:@"/"] ? [NSURL fileURLWithPath:value] : [NSURL URLWithString:value];
    }
    if (source.isFileURL) {
        NSURL *local = source.URLByResolvingSymlinksInPath.URLByStandardizingPath;
        NSString *home = [NSURL fileURLWithPath:NSHomeDirectory() isDirectory:YES].URLByResolvingSymlinksInPath.path;
        NSNumber *regular = nil;
        return [local.path hasPrefix:[home stringByAppendingString:@"/"]] &&
            [local getResourceValue:&regular forKey:NSURLIsRegularFileKey error:NULL] && regular.boolValue ? local : nil;
    }
    NSString *scheme = source.scheme.lowercaseString;
    NSString *host = source.host.lowercaseString;
    if (!([scheme isEqualToString:@"https"] || [scheme isEqualToString:@"http"]) || !host.length ||
        source.user || source.password) return nil;
    return source;
}

static NSString *SafeTitle(id value) {
    if (![value isKindOfClass:NSString.class]) return @"短剧视频";
    NSMutableCharacterSet *unsafe = NSCharacterSet.controlCharacterSet.mutableCopy;
    [unsafe addCharactersInString:@"/\\:*?\"<>|"];
    NSString *title = [[value componentsSeparatedByCharactersInSet:unsafe] componentsJoinedByString:@" "];
    title = [title stringByTrimmingCharactersInSet:NSCharacterSet.whitespaceAndNewlineCharacterSet];
    if (!title.length || [title hasPrefix:@"."]) return @"短剧视频";
    if (title.length > 70) title = [title substringToIndex:[title rangeOfComposedCharacterSequenceAtIndex:69].location];
    return title.length ? title : @"短剧视频";
}

static void CaptureSource(UIView *player, id engine) {
    id source = HostObject(engine, @selector(playSource));
    id urlInfo = HostObject(source, NSSelectorFromString(@"usingUrlInfo"));
    id videoInfo = HostObject(HostObject(player, @selector(model)), NSSelectorFromString(@"videoInfo"));
    id videoID = HostObject(videoInfo, NSSelectorFromString(@"videoId"));
    RecentPlayer = player;
    RecentEngine = engine;
    RecentVideoInfo = videoInfo;
    RecentVideoID = [videoID isKindOfClass:NSString.class] ? [videoID copy] : nil;
    RecentSource = nil;
    RecentFormat = nil;
    // FQVPlayerModel has videoInfo, not videoTitle. A video ID also keeps
    // separate episodes distinguishable when the host supplies no title.
    RecentTitle = SafeTitle(RecentVideoID.length ? [@"短剧视频-" stringByAppendingString:RecentVideoID] : nil);
    RecentUnavailableReason = nil;
    if (HostFlag(urlInfo, NSSelectorFromString(@"encrypt")) || HasProtectionMarker(HostObject(urlInfo, NSSelectorFromString(@"fps"))) ||
        HasProtectionMarker(HostObject(engine, NSSelectorFromString(@"fpsLicenseUrl"))) ||
        HasProtectionMarker(HostObject(engine, NSSelectorFromString(@"encryptedDecryptionKey"))) ||
        HasProtectionMarker(HostObject(engine, NSSelectorFromString(@"decryptionKey")))) {
        RecentUnavailableReason = @"当前视频的来源受到保护。";
        return;
    }
    if (HostFlag(source, NSSelectorFromString(@"isLivePlayback")) ||
        HostFlag(engine, NSSelectorFromString(@"isDashSource")) || HostFlag(engine, NSSelectorFromString(@"isBashSource"))) {
        RecentUnavailableReason = @"当前视频是直播或分离音视频流，无法作为完整文件导出。";
        return;
    }
    RecentSource = MediaSourceURL(HostObject(source, NSSelectorFromString(@"currentUrl")));
    id format = HostObject(engine, NSSelectorFromString(@"getFileFormat"));
    if ([format isKindOfClass:NSString.class]) RecentFormat = [format lowercaseString];
    if (!RecentSource) RecentUnavailableReason = @"请重新播放这条视频，再尝试导出可读取的视频来源。";
}

extern void FQXNotifyDramaPlayerStateChanged(UIView *player, id engine, NSInteger state);

static void PlaybackChanged(id self, SEL cmd, id engine, NSInteger state) {
    NativePlaybackChanged(self, cmd, engine, state);
    if ([self isKindOfClass:UIView.class]) {
        FQXNotifyDramaPlayerStateChanged((UIView *)self, engine, state);
    }
    if (state != PlaybackPlaying || !engine || ![self isKindOfClass:UIView.class]) return;
    UIView *player = self;
    void (^capture)(void) = ^{
        UIWindow *window = player.window;
        if (!window || !CGRectIntersectsRect([player convertRect:player.bounds toView:window], window.bounds) ||
            HostObject(player, NSSelectorFromString(@"videoEngine")) != engine) return;
        for (UIView *view = player; view; view = view.superview) {
            if (view.hidden || view.alpha == 0) return;
        }
        CaptureSource(player, engine);
    };
    if (NSThread.isMainThread) capture();
    else dispatch_async(dispatch_get_main_queue(), capture);
}

static NSString *MediaExtension(NSURL *url, NSString *hint) {
    static NSSet<NSString *> *extensions;
    static dispatch_once_t once;
    dispatch_once(&once, ^{ extensions = [NSSet setWithArray:@[@"mp4", @"mov", @"m4v", @"ts", @"m2ts", @"mpg", @"mpeg",
                                                               @"avi", @"mkv", @"webm", @"flv", @"f4v", @"3gp", @"3g2"]]; });
    NSString *extension = url.pathExtension.lowercaseString;
    if ([extensions containsObject:extension]) return extension;
    return hint && [extensions containsObject:hint] ? hint : nil;
}

static NSString *ContainerExtension(NSURL *file) {
    NSFileHandle *handle = [NSFileHandle fileHandleForReadingFromURL:file error:NULL];
    NSData *prefix = [handle readDataUpToLength:4096 error:NULL];
    [handle closeAndReturnError:NULL];
    if (FQXVideoIsHLSPlaylist(prefix.bytes, prefix.length)) return @"m3u8";
    const char *extension = FQXVideoContainerExtension(prefix.bytes, prefix.length);
    return extension ? [NSString stringWithUTF8String:extension] : nil;
}

@interface FQXVideoExport : UITableViewController <AVAssetDownloadDelegate>
@property (nonatomic, strong) NSURL *source;
@property (nonatomic, copy) NSString *sourceFormat;
@property (nonatomic, copy) NSString *mediaTitle;
@property (nonatomic, copy) NSString *unavailableReason;
@property (nonatomic) BOOL hls;
@property (nonatomic, strong) NSURL *directory;
@property (nonatomic, strong) UIAlertController *progress;
@property (nonatomic, strong) NSURLSessionTask *task;
@property (nonatomic, strong) NSURLSession *session;
@property (nonatomic, strong) AVAssetExportSession *exporter;
@property (nonatomic, strong) NSURL *hlsLocation;
+ (void)install;
+ (void)presentFromController:(UIViewController *)owner;
@end

@implementation FQXVideoExport

+ (void)install {
    Class cls = NSClassFromString(@"FQVPlayer");
    SEL selector = NSSelectorFromString(@"videoEngine:playbackStateDidChanged:");
    Method method = class_getInstanceMethod(cls, selector);
    if (NativePlaybackChanged || !method || strcmp(method_getTypeEncoding(method), "v32@0:8@16q24")) return;
    IMP original = NULL;
    if (!FQXInstallOwnedHook(cls, selector, NO, "v32@0:8@16q24", (IMP)PlaybackChanged, &original)) return;
    NativePlaybackChanged = (void (*)(id, SEL, id, NSInteger))original;
}

+ (void)presentFromController:(UIViewController *)owner {
    if (!owner || owner.presentedViewController) return;
    UIView *player = RecentPlayer;
    id engine = RecentEngine;
    if (player && engine && HostObject(player, NSSelectorFromString(@"videoEngine")) == engine) {
        id videoInfo = HostObject(HostObject(player, @selector(model)), NSSelectorFromString(@"videoInfo"));
        id videoID = HostObject(videoInfo, NSSelectorFromString(@"videoId"));
        NSURL *current = MediaSourceURL(HostObject(HostObject(engine, @selector(playSource)), NSSelectorFromString(@"currentUrl")));
        // The CDN URL can become ready after the playing callback or change
        // with resolution. Refresh only the captured episode, not a reused
        // player's next preloaded model.
        BOOL sameVideo = RecentVideoID.length ?
            ([videoID isKindOfClass:NSString.class] && [RecentVideoID isEqualToString:videoID]) :
            (videoInfo && videoInfo == RecentVideoInfo);
        if (sameVideo || [current isEqual:RecentSource]) CaptureSource(player, engine);
    }
    FQXVideoExport *page = [[self alloc] initWithStyle:UITableViewStyleInsetGrouped];
    page.title = @"导出视频";
    page.mediaTitle = RecentTitle ?: @"短剧视频";
    page.source = RecentSource;
    page.sourceFormat = RecentFormat;
    page.unavailableReason = RecentUnavailableReason ?: @"先播放一条短剧，再打开这个页面。";
    page.hls = [page.source.pathExtension.lowercaseString isEqualToString:@"m3u8"] ||
               [page.sourceFormat isEqualToString:@"hls"] || [page.sourceFormat isEqualToString:@"m3u8"];
    if (owner.navigationController) [owner.navigationController pushViewController:page animated:YES];
    else {
        page.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc]
            initWithBarButtonSystemItem:UIBarButtonSystemItemDone target:page action:@selector(closePage)];
        [owner presentViewController:[[UINavigationController alloc] initWithRootViewController:page] animated:YES completion:nil];
    }
}

- (void)closePage {
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    (void)tableView;
    (void)section;
    return !self.source ? 0 : self.hls ? 1 : 4;
}

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section {
    (void)tableView;
    (void)section;
    return self.source ? self.mediaTitle : nil;
}

- (NSString *)tableView:(UITableView *)tableView titleForFooterInSection:(NSInteger)section {
    (void)tableView;
    (void)section;
    if (!self.source) return self.unavailableReason;
    return self.hls ? @"保存系统支持的 HLS 离线包。请保持 App 打开直到完成。"
                    : @"原文件保留视频本身的格式。MP4、MOV、M4V 转换取决于当前视频与设备支持。";
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"FanqieXVideoFormat"];
    if (!cell) cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"FanqieXVideoFormat"];
    UIListContentConfiguration *content = cell.defaultContentConfiguration;
    content.text = self.hls ? @"HLS 离线包（MOVPKG）" : @[@"原文件", @"MP4", @"MOV", @"M4V"][indexPath.row];
    cell.contentConfiguration = content;
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    if (!self.source || self.directory) return;
    NSString *extension = @[@"", @"mp4", @"mov", @"m4v"][indexPath.row];
    [self beginExport:extension];
}

- (void)message:(NSString *)text {
    UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"无法导出视频" message:text preferredStyle:UIAlertControllerStyleAlert];
    [alert addAction:[UIAlertAction actionWithTitle:@"好" style:UIAlertActionStyleDefault handler:nil]];
    [self presentViewController:alert animated:YES completion:nil];
}

- (void)cancelExport {
    [self.task cancel];
    [self.exporter cancelExport];
    [self.session invalidateAndCancel];
    if (self.hlsLocation) [NSFileManager.defaultManager removeItemAtURL:self.hlsLocation error:NULL];
    if (self.directory) [NSFileManager.defaultManager removeItemAtURL:self.directory error:NULL];
    self.task = nil;
    self.exporter = nil;
    self.session = nil;
    self.hlsLocation = nil;
    self.directory = nil;
    self.progress = nil;
}

- (void)finishDirectory:(NSURL *)directory file:(NSURL *)file error:(NSString *)error {
    if (![self.directory isEqual:directory]) return;
    self.directory = nil;
    [self.session finishTasksAndInvalidate];
    self.session = nil;
    self.task = nil;
    self.exporter = nil;
    UIAlertController *progress = self.progress;
    self.progress = nil;
    void (^show)(void) = ^{
        NSFileManager *files = NSFileManager.defaultManager;
        if (!file || !self.view.window) {
            [files removeItemAtURL:directory error:NULL];
            if (self.view.window) [self message:error ?: @"暂时无法处理该视频来源。"];
            return;
        }
        UIActivityViewController *share = [[UIActivityViewController alloc] initWithActivityItems:@[file] applicationActivities:nil];
        share.popoverPresentationController.sourceView = self.view;
        share.popoverPresentationController.sourceRect = CGRectMake(CGRectGetMidX(self.view.bounds), CGRectGetMidY(self.view.bounds), 1, 1);
        share.completionWithItemsHandler = ^(UIActivityType type, BOOL completed, NSArray *items, NSError *shareError) {
            (void)type;
            (void)completed;
            (void)items;
            (void)shareError;
            [files removeItemAtURL:directory error:NULL];
        };
        [self presentViewController:share animated:YES completion:nil];
    };
    if (progress.presentingViewController) [progress dismissViewControllerAnimated:YES completion:show];
    else show();
}

- (void)beginExport:(NSString *)extension {
    NSURL *directory = [NSFileManager.defaultManager.temporaryDirectory
        URLByAppendingPathComponent:NSUUID.UUID.UUIDString isDirectory:YES];
    if (![NSFileManager.defaultManager createDirectoryAtURL:directory withIntermediateDirectories:NO attributes:nil error:NULL]) {
        [self message:@"无法创建临时文件夹，请检查可用储存空间。"];
        return;
    }
    self.directory = directory;
    UIAlertController *progress = [UIAlertController alertControllerWithTitle:@"正在准备视频"
        message:@"完成后可存到文件或分享。" preferredStyle:UIAlertControllerStyleAlert];
    __weak typeof(self) weakSelf = self;
    [progress addAction:[UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:^(UIAlertAction *action) {
        (void)action;
        [weakSelf cancelExport];
    }]];
    self.progress = progress;
    [self presentViewController:progress animated:YES completion:^{
        if (![self.directory isEqual:directory]) return;
        if (self.hls) [self startHLSPackageInDirectory:directory];
        else if (self.source.isFileURL) [self inspectFile:self.source extension:extension directory:directory];
        else [self downloadFileWithExtension:extension directory:directory];
    }];
}

- (void)downloadFileWithExtension:(NSString *)extension directory:(NSURL *)directory {
    NSURLSessionConfiguration *configuration = NSURLSessionConfiguration.ephemeralSessionConfiguration;
    configuration.HTTPShouldSetCookies = NO;
    configuration.URLCredentialStorage = nil;
    self.session = [NSURLSession sessionWithConfiguration:configuration];
    self.task = [self.session downloadTaskWithURL:self.source completionHandler:^(NSURL *location, NSURLResponse *response, NSError *error) {
        NSHTTPURLResponse *http = [response isKindOfClass:NSHTTPURLResponse.class] ? (NSHTTPURLResponse *)response : nil;
        NSString *inputExtension = MediaExtension(response.URL ?: self.source, self.sourceFormat) ?: @"video";
        NSURL *input = [[directory URLByAppendingPathComponent:NSUUID.UUID.UUIDString] URLByAppendingPathExtension:inputExtension];
        BOOL downloaded = !error && http.statusCode == 200 && location &&
            [NSFileManager.defaultManager moveItemAtURL:location toURL:input error:NULL];
        dispatch_async(dispatch_get_main_queue(), ^{
            if (![self.directory isEqual:directory]) return;
            if (downloaded) [self inspectFile:input extension:extension directory:directory];
            else [self finishDirectory:directory file:nil error:@"当前视频源无法下载。请重新播放视频，取得新的来源后再试。"];
        });
    }];
    [self.task resume];
}

- (void)inspectFile:(NSURL *)input extension:(NSString *)extension directory:(NSURL *)directory {
    NSString *sourceExtension = ContainerExtension(input);
    BOOL original = !extension.length;
    if ([sourceExtension isEqualToString:@"m3u8"]) {
        self.hls = YES;
        [self.tableView reloadData];
        if (original) [self startHLSPackageInDirectory:directory];
        else [self finishDirectory:directory file:nil error:@"此来源是 HLS 视频，请选择 HLS 离线包保存。"];
        return;
    }
    if (original && !sourceExtension) {
        [self finishDirectory:directory file:nil error:@"无法识别原文件格式。可尝试 MP4、MOV 或 M4V。"];
        return;
    }
    if (!original && (!sourceExtension || [input.pathExtension.lowercaseString isEqualToString:sourceExtension])) {
        [self inspectConvertibleFile:input extension:extension directory:directory];
        return;
    }
    NSString *name = original ? self.mediaTitle : NSUUID.UUID.UUIDString;
    NSURL *target = [[directory URLByAppendingPathComponent:name] URLByAppendingPathExtension:sourceExtension];
    BOOL downloaded = [input.URLByDeletingLastPathComponent.path isEqualToString:directory.path];
    dispatch_async(dispatch_get_global_queue(QOS_CLASS_USER_INITIATED, 0), ^{
        NSFileManager *files = NSFileManager.defaultManager;
        BOOL staged = downloaded ? [files moveItemAtURL:input toURL:target error:NULL] :
                                   [files copyItemAtURL:input toURL:target error:NULL];
        dispatch_async(dispatch_get_main_queue(), ^{
            if (![self.directory isEqual:directory]) return;
            if (!staged) [self finishDirectory:directory file:nil error:@"无法保存临时视频，请检查可用储存空间。"];
            else if (original) [self finishDirectory:directory file:target error:nil];
            else [self inspectConvertibleFile:target extension:extension directory:directory];
        });
    });
}

// The Objective-C async-key and export APIs also work on the plugin's original
// iOS deployment target. New typed loading/export APIs are Swift-only.
#pragma clang diagnostic push
#pragma clang diagnostic ignored "-Wdeprecated-declarations"
- (void)inspectConvertibleFile:(NSURL *)input extension:(NSString *)extension directory:(NSURL *)directory {
    AVURLAsset *asset = [AVURLAsset URLAssetWithURL:input options:nil];
    NSArray<NSString *> *keys = @[@"hasProtectedContent", @"tracks", @"exportable"];
    [asset loadValuesAsynchronouslyForKeys:keys completionHandler:^{
        dispatch_async(dispatch_get_main_queue(), ^{
            if (![self.directory isEqual:directory]) return;
            if ([asset statusOfValueForKey:@"hasProtectedContent" error:NULL] != AVKeyValueStatusLoaded || asset.hasProtectedContent) {
                [self finishDirectory:directory file:nil error:@"当前文件受到保护或无法读取。"];
            } else if ([asset statusOfValueForKey:@"tracks" error:NULL] != AVKeyValueStatusLoaded ||
                       ![asset tracksWithMediaType:AVMediaTypeVideo].count) {
                [self finishDirectory:directory file:nil error:@"无法识别视频轨道或确认来源文件完整。"];
            } else if ([asset statusOfValueForKey:@"exportable" error:NULL] == AVKeyValueStatusLoaded && asset.exportable) {
                [self exportAsset:asset extension:extension directory:directory presetIndex:0];
            } else {
                [self finishDirectory:directory file:nil error:@"系统无法转换此视频。可尝试保存原文件。"];
            }
        });
    }];
}

- (void)exportAsset:(AVURLAsset *)asset extension:(NSString *)extension directory:(NSURL *)directory presetIndex:(NSUInteger)index {
    AVFileType type = [extension isEqualToString:@"mov"] ? AVFileTypeQuickTimeMovie :
                      [extension isEqualToString:@"m4v"] ? AVFileTypeAppleM4V : AVFileTypeMPEG4;
    NSString *preset = index ? AVAssetExportPresetHighestQuality : AVAssetExportPresetPassthrough;
    AVAssetExportSession *exporter = [[AVAssetExportSession alloc] initWithAsset:asset presetName:preset];
    void (^unavailable)(void) = ^{
        if (index == 0) [self exportAsset:asset extension:extension directory:directory presetIndex:1];
        else [self finishDirectory:directory file:nil error:@"当前视频或系统不支持所选格式。"];
    };
    if (!exporter) { unavailable(); return; }
    self.exporter = exporter;
    [exporter determineCompatibleFileTypesWithCompletionHandler:^(NSArray<AVFileType> *types) {
        dispatch_async(dispatch_get_main_queue(), ^{
            if (![self.directory isEqual:directory]) return;
            if (![types containsObject:type]) { unavailable(); return; }
            NSURL *file = [[directory URLByAppendingPathComponent:self.mediaTitle] URLByAppendingPathExtension:extension];
            exporter.outputURL = file;
            exporter.outputFileType = type;
            [exporter exportAsynchronouslyWithCompletionHandler:^{
                dispatch_async(dispatch_get_main_queue(), ^{
                    if (![self.directory isEqual:directory]) return;
                    if (exporter.status == AVAssetExportSessionStatusCompleted) [self finishDirectory:directory file:file error:nil];
                    else [self finishDirectory:directory file:nil error:@"转换未完成。可尝试其他格式或保存原文件。"];
                });
            }];
        });
    }];
}

- (void)startHLSPackageInDirectory:(NSURL *)directory {
    AVURLAsset *asset = [AVURLAsset URLAssetWithURL:self.source options:nil];
    [asset loadValuesAsynchronouslyForKeys:@[@"hasProtectedContent", @"duration"] completionHandler:^{
        dispatch_async(dispatch_get_main_queue(), ^{
            if (![self.directory isEqual:directory]) return;
            if ([asset statusOfValueForKey:@"hasProtectedContent" error:NULL] != AVKeyValueStatusLoaded || asset.hasProtectedContent) {
                [self finishDirectory:directory file:nil error:@"系统无法读取此 HLS 来源，或内容受到保护。"];
                return;
            }
            if ([asset statusOfValueForKey:@"duration" error:NULL] != AVKeyValueStatusLoaded || !CMTIME_IS_NUMERIC(asset.duration) || asset.duration.value <= 0) {
                [self finishDirectory:directory file:nil error:@"此 HLS 来源不是可完整下载的点播视频。"];
                return;
            }
            NSString *identifier = [@"FanqieX.VideoExport." stringByAppendingString:NSUUID.UUID.UUIDString];
            NSURLSessionConfiguration *configuration = [NSURLSessionConfiguration backgroundSessionConfigurationWithIdentifier:identifier];
            configuration.HTTPShouldSetCookies = NO;
            configuration.URLCredentialStorage = nil;
            AVAssetDownloadURLSession *session = [AVAssetDownloadURLSession sessionWithConfiguration:configuration
                assetDownloadDelegate:self delegateQueue:NSOperationQueue.mainQueue];
            AVAssetDownloadConfiguration *assetConfiguration = [AVAssetDownloadConfiguration downloadConfigurationWithAsset:asset title:self.mediaTitle];
            self.session = session;
            self.task = [session assetDownloadTaskWithConfiguration:assetConfiguration];
            if (self.task) [self.task resume];
            else [self finishDirectory:directory file:nil error:@"系统不支持下载此 HLS 来源。"];
        });
    }];
}

- (void)URLSession:(NSURLSession *)session assetDownloadTask:(AVAssetDownloadTask *)task willDownloadToURL:(NSURL *)location {
    if (session == self.session && task == self.task) self.hlsLocation = location;
}

- (void)URLSession:(NSURLSession *)session assetDownloadTask:(AVAssetDownloadTask *)task didFinishDownloadingToURL:(NSURL *)location {
    if (session == self.session && task == self.task) self.hlsLocation = location;
    else [NSFileManager.defaultManager removeItemAtURL:location error:NULL];
}

- (void)URLSession:(NSURLSession *)session task:(NSURLSessionTask *)task didCompleteWithError:(NSError *)error {
    if (session != self.session || task != self.task || !self.hls) return;
    NSURL *directory = self.directory;
    NSURL *location = self.hlsLocation;
    self.hlsLocation = nil;
    NSURL *file = [[directory URLByAppendingPathComponent:self.mediaTitle] URLByAppendingPathExtension:@"movpkg"];
    dispatch_async(dispatch_get_global_queue(QOS_CLASS_USER_INITIATED, 0), ^{
        NSFileManager *files = NSFileManager.defaultManager;
        BOOL copied = !error && location && [files copyItemAtURL:location toURL:file error:NULL];
        if (location) [files removeItemAtURL:location error:NULL];
        dispatch_async(dispatch_get_main_queue(), ^{
            [self finishDirectory:directory file:copied ? file : nil error:@"HLS 离线包未完成。请重新播放后再试。"];
        });
    });
}
#pragma clang diagnostic pop

@end
