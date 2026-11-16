#import <UIKit/UIKit.h>
#import <objc/message.h>
#import <objc/runtime.h>
#import "BookExportSource.h"
#import "BookExportFormats.h"

static const void *FQXExportAccessoryKey = &FQXExportAccessoryKey;
static const void *FQXExportSessionKey = &FQXExportSessionKey;
static void (*FQXDownloadLayout)(id, SEL);
static void (*FQXDownloadModel)(id, SEL, id);
static void (*FQXDownloadEditing)(id, SEL, BOOL);

static BOOL FQXGetter(id object, NSString *name, const char *type) {
    Method method = class_getInstanceMethod(object_getClass(object), NSSelectorFromString(name));
    if (!method || method_getNumberOfArguments(method) != 2) return NO;
    char *result = method_copyReturnType(method);
    BOOL supported = result && strcmp(result, type) == 0;
    free(result);
    return supported;
}

static id FQXGet(id object, NSString *name) {
    return FQXGetter(object, name, "@") ?
        ((id (*)(id, SEL))objc_msgSend)(object, NSSelectorFromString(name)) : nil;
}

static UIViewController *FQXOwner(UIView *view) {
    for (UIResponder *responder = view; responder; responder = responder.nextResponder) {
        if ([responder isKindOfClass:UIViewController.class]) return (UIViewController *)responder;
    }
    return nil;
}

static void FQXAnchor(UIAlertController *alert, UIViewController *owner, UIView *source) {
    UIPopoverPresentationController *popover = alert.popoverPresentationController;
    if (!popover) return;
    UIView *view = source.window ? source : owner.view;
    popover.sourceView = view;
    popover.sourceRect = source.window ? source.bounds :
        CGRectMake(CGRectGetMidX(view.bounds), CGRectGetMidY(view.bounds), 1, 1);
}

@interface FQXExportSession : NSObject <UIAdaptivePresentationControllerDelegate, UIPopoverPresentationControllerDelegate>
@property (nonatomic, copy) NSString *bookIdentifier;
@property (nonatomic, copy) NSString *bookTitle;
@property (nonatomic, weak) UIViewController *owner;
@property (nonatomic, weak) UIView *sender;
@property (nonatomic, strong) UIAlertController *progress;
@property (nonatomic, strong) UIAlertController *currentAlert;
@property (nonatomic, strong) NSOperationQueue *queue;
@property (atomic) BOOL cancelled;
@property (nonatomic) NSUInteger requestedCount;
- (void)chooseRange;
@end

@implementation FQXExportSession

- (void)releaseSession {
    self.progress = nil;
    self.currentAlert = nil;
    self.queue = nil;
    objc_setAssociatedObject(UIApplication.sharedApplication, FQXExportSessionKey, nil, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

- (void)presentAlert:(UIAlertController *)alert completion:(void (^)(void))completion {
    if (!self.owner.view.window) { [self releaseSession]; return; }
    UIAlertController *previous = self.currentAlert;
    self.currentAlert = alert;
    void (^present)(void) = ^{
        alert.presentationController.delegate = self;
        alert.popoverPresentationController.delegate = self;
        [self.owner presentViewController:alert animated:YES completion:completion];
    };
    if (previous.presentingViewController) [previous dismissViewControllerAnimated:YES completion:present];
    else present();
}

- (void)presentationControllerDidDismiss:(UIPresentationController *)controller {
    if (controller.presentedViewController != self.currentAlert) return;
    self.cancelled = YES;
    if (!self.queue) [self releaseSession];
}

- (void)popoverPresentationControllerDidDismissPopover:(UIPopoverPresentationController *)controller {
    [self presentationControllerDidDismiss:controller];
}

- (void)showError:(NSString *)message {
    UIViewController *owner = self.owner;
    if (!owner.view.window) { [self releaseSession]; return; }
    UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"导出失败"
        message:message preferredStyle:UIAlertControllerStyleAlert];
    [alert addAction:[UIAlertAction actionWithTitle:@"好" style:UIAlertActionStyleCancel handler:nil]];
    [self presentAlert:alert completion:^{ [self releaseSession]; }];
}

- (void)chooseRange {
    UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"导出本地小说"
        message:self.bookTitle preferredStyle:UIAlertControllerStyleActionSheet];
    [alert addAction:[UIAlertAction actionWithTitle:@"整本小说（需完整下载）" style:UIAlertActionStyleDefault handler:^(__unused UIAlertAction *action) {
        self.requestedCount = 0;
        [self chooseFormat];
    }]];
    [alert addAction:[UIAlertAction actionWithTitle:@"最新一章" style:UIAlertActionStyleDefault handler:^(__unused UIAlertAction *action) {
        self.requestedCount = 1;
        [self chooseFormat];
    }]];
    [alert addAction:[UIAlertAction actionWithTitle:@"最近 N 章…" style:UIAlertActionStyleDefault handler:^(__unused UIAlertAction *action) {
        [self enterChapterCount];
    }]];
    [alert addAction:[UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:^(__unused UIAlertAction *action) {
        [self releaseSession];
    }]];
    FQXAnchor(alert, self.owner, self.sender);
    [self presentAlert:alert completion:nil];
}

- (void)enterChapterCount {
    UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"最近 N 章"
        message:@"按目录顺序从已下载章节中选择，最多导出输入的章数。" preferredStyle:UIAlertControllerStyleAlert];
    [alert addTextFieldWithConfigurationHandler:^(UITextField *field) {
        field.keyboardType = UIKeyboardTypeNumberPad;
        field.placeholder = @"章节数";
        field.text = @"10";
    }];
    [alert addAction:[UIAlertAction actionWithTitle:@"下一步" style:UIAlertActionStyleDefault handler:^(__unused UIAlertAction *action) {
        NSString *text = [alert.textFields.firstObject.text stringByTrimmingCharactersInSet:NSCharacterSet.whitespaceAndNewlineCharacterSet];
        NSScanner *scanner = [NSScanner scannerWithString:text];
        unsigned long long count = 0;
        NSCharacterSet *digits = [NSCharacterSet characterSetWithCharactersInString:@"0123456789"];
        if (!text.length || [text rangeOfCharacterFromSet:digits.invertedSet].location != NSNotFound ||
            ![scanner scanUnsignedLongLong:&count] || !scanner.isAtEnd || !count || count > NSUIntegerMax) {
            [self showError:@"请输入大于零的章节数。"];
            return;
        }
        self.requestedCount = (NSUInteger)count;
        [self chooseFormat];
    }]];
    [alert addAction:[UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:^(__unused UIAlertAction *action) {
        [self releaseSession];
    }]];
    [self presentAlert:alert completion:nil];
}

- (void)chooseFormat {
    UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"选择导出格式"
        message:nil preferredStyle:UIAlertControllerStyleActionSheet];
    NSArray<NSString *> *names = @[@"TXT", @"Markdown", @"HTML", @"EPUB", @"JSON"];
    [names enumerateObjectsUsingBlock:^(NSString *name, NSUInteger index, __unused BOOL *stop) {
        [alert addAction:[UIAlertAction actionWithTitle:name style:UIAlertActionStyleDefault handler:^(__unused UIAlertAction *action) {
            [self exportFormat:(FQXBookExportFormat)index];
        }]];
    }];
    [alert addAction:[UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:^(__unused UIAlertAction *action) {
        [self releaseSession];
    }]];
    FQXAnchor(alert, self.owner, self.sender);
    [self presentAlert:alert completion:nil];
}

- (void)exportFormat:(FQXBookExportFormat)format {
    UIAlertController *progress = [UIAlertController alertControllerWithTitle:@"正在导出"
        message:@"正在读取本地下载记录和目录…" preferredStyle:UIAlertControllerStyleAlert];
    [progress addAction:[UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:^(__unused UIAlertAction *action) {
        self.cancelled = YES;
    }]];
    self.progress = progress;
    self.queue = [NSOperationQueue new];
    self.queue.name = @"FanqieX.LocalBookExport";
    self.queue.maxConcurrentOperationCount = 1;
    [self presentAlert:progress completion:^{
        [self.queue addOperationWithBlock:^{
            [self writeBookWithFormat:format];
        }];
    }];
}

- (void)completeExportWithFile:(NSURL *)file folder:(NSURL *)folder error:(NSString *)message {
    dispatch_async(dispatch_get_main_queue(), ^{
        void (^finished)(void) = ^{
            if (self.cancelled || !file) {
                if (folder) [NSFileManager.defaultManager removeItemAtURL:folder error:NULL];
                if (self.cancelled) [self releaseSession];
                else [self showError:message ?: @"写入导出文件失败。"];
                return;
            }
            [self shareFile:file folder:folder];
        };
        if (self.progress.presentingViewController)
            [self.progress dismissViewControllerAnimated:YES completion:finished];
        else finished();
    });
}

- (void)writeBookWithFormat:(FQXBookExportFormat)format {
    @autoreleasepool {
        NSError *error;
        FQXLocalBook *book = [FQXLocalBook bookWithIdentifier:self.bookIdentifier fallbackTitle:self.bookTitle error:&error];
        if (!book || self.cancelled) {
            [self completeExportWithFile:nil folder:nil error:error.localizedDescription];
            return;
        }
        NSUInteger total = book.chapterIdentifiers.count;
        if (!self.requestedCount && total != book.catalogCount) {
            NSString *message = [NSString stringWithFormat:
                @"整本小说尚未完整下载（%lu / %lu 章）。请选择最新一章或最近 N 章，或下载完成后重试。",
                (unsigned long)total, (unsigned long)book.catalogCount];
            [self completeExportWithFile:nil folder:nil error:message];
            return;
        }
        NSURL *folder = [[NSURL fileURLWithPath:NSTemporaryDirectory() isDirectory:YES]
            URLByAppendingPathComponent:[@"FanqieX-Export-" stringByAppendingString:NSUUID.UUID.UUIDString] isDirectory:YES];
        BOOL created = [NSFileManager.defaultManager createDirectoryAtURL:folder
            withIntermediateDirectories:NO attributes:nil error:&error];
        NSString *name = book.metadata[@"title"];
        NSCharacterSet *unsafe = [NSCharacterSet characterSetWithCharactersInString:@"/\\:\n\r\t"];
        name = [[name componentsSeparatedByCharactersInSet:unsafe] componentsJoinedByString:@"_"];
        name = [name stringByTrimmingCharactersInSet:NSCharacterSet.whitespaceAndNewlineCharacterSet];
        if (name.length > 80) name = [name substringWithRange:[name rangeOfComposedCharacterSequencesForRange:NSMakeRange(0, 80)]];
        if (!name.length || [name isEqualToString:@"."] || [name isEqualToString:@".."]) name = @"小说";
        NSArray *extensions = @[@"txt", @"md", @"html", @"epub", @"json"];
        NSURL *destination = [folder URLByAppendingPathComponent:[name stringByAppendingPathExtension:extensions[format]]];
        FQXBookExportWriter *writer = created ? [[FQXBookExportWriter alloc] initWithBook:book.metadata
            format:format destination:destination error:&error] : nil;
        NSUInteger count = self.requestedCount ? MIN(self.requestedCount, total) : total;
        NSUInteger first = total - count;
        BOOL complete = writer != nil;
        for (NSUInteger offset = 0; complete && offset < count; offset++) {
            @autoreleasepool {
                if (self.cancelled) { complete = NO; break; }
                NSDictionary *chapter = [book chapterAtIndex:first + offset error:&error];
                complete = chapter && [writer appendChapter:chapter error:&error];
                if (complete && (offset % 25 == 0 || offset + 1 == count)) {
                    NSString *message = [NSString stringWithFormat:@"%lu / %lu 章", (unsigned long)offset + 1, (unsigned long)count];
                    dispatch_async(dispatch_get_main_queue(), ^{ self.progress.message = message; });
                }
            }
        }
        if (complete && !self.cancelled) complete = [writer finish:&error];
        if (!complete || self.cancelled) [writer cancel];
        [self completeExportWithFile:complete ? destination : nil folder:created ? folder : nil
                              error:error.localizedDescription];
    }
}

- (void)shareFile:(NSURL *)file folder:(NSURL *)folder {
    UIViewController *owner = self.owner;
    if (!owner.view.window) {
        [NSFileManager.defaultManager removeItemAtURL:folder error:NULL];
        [self releaseSession];
        return;
    }
    UIActivityViewController *share = [[UIActivityViewController alloc] initWithActivityItems:@[file] applicationActivities:nil];
    UIPopoverPresentationController *popover = share.popoverPresentationController;
    popover.sourceView = self.sender.window ? self.sender : owner.view;
    popover.sourceRect = self.sender.window ? self.sender.bounds :
        CGRectMake(CGRectGetMidX(owner.view.bounds), CGRectGetMidY(owner.view.bounds), 1, 1);
    share.completionWithItemsHandler = ^(__unused UIActivityType type, __unused BOOL completed,
                                         __unused NSArray *items, __unused NSError *activityError) {
        [NSFileManager.defaultManager removeItemAtURL:folder error:NULL];
        [self releaseSession];
    };
    [owner presentViewController:share animated:YES completion:nil];
}
@end

static void FQXBeginExport(UIViewController *owner, UIView *sender, NSDictionary *book) {
    if (!book || !owner.view.window || owner.presentedViewController) return;
    UIApplication *application = UIApplication.sharedApplication;
    if (objc_getAssociatedObject(application, FQXExportSessionKey)) return;
    FQXExportSession *session = [FQXExportSession new];
    session.bookIdentifier = book[@"id"];
    session.bookTitle = book[@"title"];
    session.owner = owner;
    session.sender = sender;
    objc_setAssociatedObject(application, FQXExportSessionKey, session, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
    [session chooseRange];
}

@interface FQXDownloadedBooksController : UITableViewController
@property (nonatomic, copy) NSArray<NSDictionary *> *books;
@end

@implementation FQXDownloadedBooksController
- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"导出书籍";
    if (self.navigationController.viewControllers.firstObject == self) {
        self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc]
            initWithBarButtonSystemItem:UIBarButtonSystemItemDone target:self action:@selector(close)];
    }
    [self.tableView registerClass:UITableViewCell.class forCellReuseIdentifier:@"FanqieX.DownloadedBook"];
}

- (void)close {
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    NSError *error = nil;
    self.books = [FQXLocalBook downloadedBooksWithError:&error] ?: @[];
    if (self.books.count) {
        self.tableView.backgroundView = nil;
    } else {
        UILabel *message = [UILabel new];
        message.text = error.localizedDescription ?: @"暂无可导出的小说。请先在番茄小说下载章节。";
        message.textAlignment = NSTextAlignmentCenter;
        message.textColor = UIColor.secondaryLabelColor;
        message.numberOfLines = 0;
        self.tableView.backgroundView = message;
    }
    [self.tableView reloadData];
}

- (NSInteger)tableView:(__unused UITableView *)tableView numberOfRowsInSection:(__unused NSInteger)section {
    return self.books.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"FanqieX.DownloadedBook" forIndexPath:indexPath];
    NSDictionary *book = self.books[indexPath.row];
    UIListContentConfiguration *configuration = [cell defaultContentConfiguration];
    configuration.text = book[@"title"];
    configuration.secondaryText = [NSString stringWithFormat:@"已下载 %@ 章", book[@"downloadedCount"]];
    cell.contentConfiguration = configuration;
    cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    FQXBeginExport(self, [tableView cellForRowAtIndexPath:indexPath], self.books[indexPath.row]);
}
@end

@interface FQXExportAccessory : NSObject
@property (nonatomic, weak) UIView *cell;
@property (nonatomic, strong) UIButton *button;
- (void)update;
@end

@implementation FQXExportAccessory
- (void)update {
    UIView *cell = self.cell;
    id model = FQXGet(cell, @"model");
    BOOL editing = !FQXGetter(cell, @"editMode", "B") ||
        ((BOOL (*)(id, SEL))objc_msgSend)(cell, NSSelectorFromString(@"editMode"));
    Class downloadedTab = NSClassFromString(@"SSDownloadedTabViewController");
    BOOL eligible = !editing && downloadedTab && [FQXOwner(cell) isKindOfClass:downloadedTab] &&
        FQXDownloadedBookRecord(model);
    UIView *manage = FQXGet(cell, @"manageBtn");
    UIView *content = FQXGet(cell, @"contentView");
    CGRect bounds = content.bounds;
    if (!eligible || ![content isKindOfClass:UIView.class] || bounds.size.width < 120 || bounds.size.height < 40) {
        self.button.hidden = YES;
        return;
    }
    if (!self.button) {
        UIButtonConfiguration *configuration = [UIButtonConfiguration tintedButtonConfiguration];
        configuration.title = @"导出";
        configuration.buttonSize = UIButtonConfigurationSizeSmall;
        configuration.cornerStyle = UIButtonConfigurationCornerStyleCapsule;
        self.button = [UIButton buttonWithConfiguration:configuration primaryAction:nil];
        [self.button addTarget:self action:@selector(begin:) forControlEvents:UIControlEventTouchUpInside];
        self.button.accessibilityIdentifier = @"FanqieX.ExportDownloadedBook";
    }
    if (self.button.superview != content) [content addSubview:self.button];
    CGRect manageFrame = [manage isKindOfClass:UIView.class] && [manage isDescendantOfView:content] ?
        [manage convertRect:manage.bounds toView:content] : CGRectZero;
    CGFloat width = 56;
    CGFloat bottom = CGRectGetMaxY(bounds) - 5;
    CGFloat right = CGRectIsEmpty(manageFrame) ? CGRectGetMaxX(bounds) - 16 : CGRectGetMaxX(manageFrame);
    CGFloat top = MAX(bottom - 32, CGRectGetMaxY(manageFrame) + 3);
    if (bottom - top < 28) {
        top = MAX(CGRectGetMinY(bounds), CGRectGetMidY(manageFrame) - 16);
        bottom = MIN(CGRectGetMaxY(bounds), top + 32);
        right = CGRectGetMinX(manageFrame) - 8;
    }
    CGRect frame = CGRectMake(MAX(CGRectGetMinX(bounds), right - width), top, width, bottom - top);
    if (!CGRectEqualToRect(self.button.frame, frame)) self.button.frame = frame;
    self.button.hidden = NO;
}

- (void)begin:(UIButton *)sender {
    [self update];
    if (!self.button.hidden) FQXBeginExport(FQXOwner(self.cell), sender, FQXDownloadedBookRecord(FQXGet(self.cell, @"model")));
}
@end

static void FQXUpdateExportCell(UIView *cell) {
    FQXExportAccessory *accessory = objc_getAssociatedObject(cell, FQXExportAccessoryKey);
    if (!accessory) {
        accessory = [FQXExportAccessory new];
        accessory.cell = cell;
        objc_setAssociatedObject(cell, FQXExportAccessoryKey, accessory, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
    }
    [accessory update];
}

static void FQXExportCellLayout(id cell, SEL selector) {
    FQXDownloadLayout(cell, selector);
    FQXUpdateExportCell(cell);
}
static void FQXExportCellModel(id cell, SEL selector, id model) {
    FQXDownloadModel(cell, selector, model);
    FQXUpdateExportCell(cell);
}
static void FQXExportCellEditing(id cell, SEL selector, BOOL editing) {
    FQXDownloadEditing(cell, selector, editing);
    FQXUpdateExportCell(cell);
}

@interface FQXBookExportPlugin : NSObject
+ (void)openFromSettingsController:(UIViewController *)owner;
@end
@implementation FQXBookExportPlugin
+ (void)openFromSettingsController:(UIViewController *)owner {
    if (!owner.view.window || owner.presentedViewController) return;
    [owner.view endEditing:YES];
    FQXDownloadedBooksController *books = [[FQXDownloadedBooksController alloc] initWithStyle:UITableViewStyleInsetGrouped];
    if (owner.navigationController)
        [owner.navigationController pushViewController:books animated:YES];
    else
        [owner presentViewController:[[UINavigationController alloc] initWithRootViewController:books]
                            animated:YES completion:nil];
}

+ (void)load {
    dispatch_async(dispatch_get_main_queue(), ^{
        Class cell = NSClassFromString(@"SSBookDownloadItemCell");
        Method layout = class_getInstanceMethod(cell, @selector(layoutSubviews));
        Method model = class_getInstanceMethod(cell, NSSelectorFromString(@"setModel:"));
        Method editing = class_getInstanceMethod(cell, NSSelectorFromString(@"setEditMode:"));
        if (!layout || !model || !editing ||
            strcmp(method_getTypeEncoding(layout), "v16@0:8") ||
            strcmp(method_getTypeEncoding(model), "v24@0:8@16") ||
            strcmp(method_getTypeEncoding(editing), "v20@0:8B16")) return;
        FQXDownloadLayout = (void (*)(id, SEL))method_setImplementation(layout, (IMP)FQXExportCellLayout);
        FQXDownloadModel = (void (*)(id, SEL, id))method_setImplementation(model, (IMP)FQXExportCellModel);
        FQXDownloadEditing = (void (*)(id, SEL, BOOL))method_setImplementation(editing, (IMP)FQXExportCellEditing);
    });
}
@end
