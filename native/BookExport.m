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
    [alert addAction:[UIAlertAction actionWithTitle:@"整本已下载小说" style:UIAlertActionStyleDefault handler:^(__unused UIAlertAction *action) {
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
        message:@"按本地目录末尾选择章节。" preferredStyle:UIAlertControllerStyleAlert];
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
    NSError *error;
    FQXLocalBook *book = [FQXLocalBook bookWithIdentifier:self.bookIdentifier fallbackTitle:self.bookTitle error:&error];
    if (!book) {
        [self showError:error.localizedDescription];
        return;
    }
    UIAlertController *progress = [UIAlertController alertControllerWithTitle:@"正在导出"
        message:@"正在读取本地章节…" preferredStyle:UIAlertControllerStyleAlert];
    [progress addAction:[UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:^(__unused UIAlertAction *action) {
        self.cancelled = YES;
    }]];
    self.progress = progress;
    self.queue = [NSOperationQueue new];
    self.queue.name = @"FanqieX.LocalBookExport";
    self.queue.maxConcurrentOperationCount = 1;
    [self presentAlert:progress completion:^{
        [self.queue addOperationWithBlock:^{
            [self writeBook:book format:format];
        }];
    }];
}

- (void)writeBook:(FQXLocalBook *)book format:(FQXBookExportFormat)format {
    @autoreleasepool {
        NSError *error;
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
        NSUInteger total = book.chapterIdentifiers.count;
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
        if (!complete || self.cancelled) {
            [writer cancel];
            if (created) [NSFileManager.defaultManager removeItemAtURL:folder error:NULL];
        }
        dispatch_async(dispatch_get_main_queue(), ^{
            void (^finished)(void) = ^{
                if (self.cancelled) {
                    if (created) [NSFileManager.defaultManager removeItemAtURL:folder error:NULL];
                    [self releaseSession];
                    return;
                }
                if (!complete) { [self showError:error.localizedDescription ?: @"写入导出文件失败。"]; return; }
                [self shareFile:destination folder:folder];
            };
            if (self.progress.presentingViewController)
                [self.progress dismissViewControllerAnimated:YES completion:finished];
            else finished();
        });
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

@interface FQXExportAccessory : NSObject
@property (nonatomic, weak) UIView *cell;
@property (nonatomic, strong) UIButton *button;
@property (nonatomic, weak) UILabel *statusLabel;
@property (nonatomic) BOOL statusWasHidden;
- (void)update;
@end

@implementation FQXExportAccessory
- (void)update {
    UIView *cell = self.cell;
    id model = FQXGet(cell, @"model");
    BOOL eligible = FQXGetter(model, @"status", "Q") && FQXGetter(model, @"bookType", "i") &&
        FQXGetter(cell, @"editMode", "B") &&
        ((NSUInteger (*)(id, SEL))objc_msgSend)(model, NSSelectorFromString(@"status")) == 3 &&
        ((int (*)(id, SEL))objc_msgSend)(model, NSSelectorFromString(@"bookType")) == 0 &&
        !((BOOL (*)(id, SEL))objc_msgSend)(cell, NSSelectorFromString(@"editMode"));
    NSString *bookID = FQXGet(model, @"bookId");
    eligible = eligible && [bookID isKindOfClass:NSString.class] && bookID.length;
    UILabel *status = FQXGet(cell, @"statusLabel");
    UIView *content = FQXGet(cell, @"contentView");
    if (self.statusLabel && (self.statusLabel != status || !eligible)) {
        self.statusLabel.hidden = self.statusWasHidden;
        self.statusLabel = nil;
    }
    if (!eligible || ![status isKindOfClass:UILabel.class] ||
        ![content isKindOfClass:UIView.class] || ![status isDescendantOfView:content] ||
        status.bounds.size.width <= 0 || status.bounds.size.height <= 0) {
        self.button.hidden = YES;
        return;
    }
    if (self.statusLabel != status) {
        self.statusLabel = status;
        self.statusWasHidden = status.hidden;
    }
    if (!self.button) {
        self.button = [UIButton buttonWithType:UIButtonTypeSystem];
        [self.button setTitle:@"导出" forState:UIControlStateNormal];
        self.button.titleLabel.font = [UIFont systemFontOfSize:14 weight:UIFontWeightMedium];
        [self.button addTarget:self action:@selector(begin:) forControlEvents:UIControlEventTouchUpInside];
        self.button.accessibilityIdentifier = @"FanqieX.ExportDownloadedBook";
        [content addSubview:self.button];
    }
    CGRect frame = [status convertRect:status.bounds toView:content];
    CGFloat width = MAX(44, frame.size.width);
    CGFloat right = MIN(CGRectGetMaxX(frame), CGRectGetMaxX(content.bounds) - 8);
    CGFloat y = MAX(CGRectGetMinY(content.bounds), CGRectGetMidY(frame) - 22);
    y = MIN(y, MAX(0, CGRectGetMaxY(content.bounds) - 44));
    self.button.frame = CGRectMake(MAX(0, right - width), y, width, 44);
    self.button.hidden = NO;
    status.hidden = YES;
}

- (void)begin:(UIButton *)sender {
    UIViewController *owner = FQXOwner(self.cell);
    if (!owner.view.window || owner.presentedViewController) return;
    if (objc_getAssociatedObject(UIApplication.sharedApplication, FQXExportSessionKey)) return;
    [self update];
    if (self.button.hidden) return;
    id model = FQXGet(self.cell, @"model");
    FQXExportSession *session = [FQXExportSession new];
    session.bookIdentifier = FQXGet(model, @"bookId");
    NSString *name = FQXGet(model, @"bookName");
    session.bookTitle = [name isKindOfClass:NSString.class] && name.length ? name : @"小说";
    session.owner = owner;
    session.sender = sender;
    objc_setAssociatedObject(UIApplication.sharedApplication, FQXExportSessionKey, session, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
    [session chooseRange];
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
@end
@implementation FQXBookExportPlugin
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
