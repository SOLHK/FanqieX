#import "BookExportSource.h"
#import "BookExportFormats.h"
#import <objc/message.h>
#import <objc/runtime.h>

static BOOL FQXMethod(id object, NSString *name, const char *result, NSArray<NSString *> *arguments) {
    Method method = class_getInstanceMethod(object_getClass(object), NSSelectorFromString(name));
    if (!method || method_getNumberOfArguments(method) != arguments.count + 2) return NO;
    char *type = method_copyReturnType(method);
    BOOL valid = type && strcmp(type, result) == 0;
    free(type);
    for (NSUInteger i = 0; valid && i < arguments.count; i++) {
        type = method_copyArgumentType(method, (unsigned int)i + 2);
        valid = type && strcmp(type, arguments[i].UTF8String) == 0;
        free(type);
    }
    return valid;
}

static id FQXObject(id object, NSString *name) {
    if (!FQXMethod(object, name, "@", @[])) return nil;
    return ((id (*)(id, SEL))objc_msgSend)(object, NSSelectorFromString(name));
}

static NSString *FQXText(id object) {
    return [object isKindOfClass:NSString.class] ? object : nil;
}

static id FQXLocalService(NSString *className) {
    Class serviceClass = NSClassFromString(className);
    id center = FQXObject(NSClassFromString(@"HTSServiceCenter"), @"defaultCenter");
    if (!serviceClass || !FQXMethod(center, @"getService:", "@", @[@"#"])) return nil;
    return ((id (*)(id, SEL, Class))objc_msgSend)(center, NSSelectorFromString(@"getService:"), serviceClass);
}

NSDictionary *FQXDownloadedBookRecord(id model) {
    Class bookModel = NSClassFromString(@"SSBookDownloadStatusModel");
    if (!bookModel || ![model isKindOfClass:bookModel] ||
        !FQXMethod(model, @"downloadedItemCount", "q", @[])) return nil;
    NSInteger count = ((NSInteger (*)(id, SEL))objc_msgSend)(model, NSSelectorFromString(@"downloadedItemCount"));
    NSString *identifier = FQXText(FQXObject(model, @"bookId"));
    if (!identifier.length || count <= 0) return nil;
    NSString *title = FQXText(FQXObject(model, @"bookName"));
    return @{@"id": [identifier copy], @"title": title.length ? [title copy] : @"未命名小说",
             @"downloadedCount": @(count)};
}

static void FQXSourceError(NSError **error, NSInteger code, NSString *message) {
    if (error) *error = [NSError errorWithDomain:@"FanqieX.BookExport" code:code
                                     userInfo:@{NSLocalizedDescriptionKey: message}];
}

@interface FQXLocalBook ()
@property (nonatomic, strong) id manager;
@property (nonatomic, copy) NSString *identifier;
@property (nonatomic, readwrite, copy) NSDictionary<NSString *, NSString *> *metadata;
@property (nonatomic, readwrite, copy) NSArray<NSString *> *chapterIdentifiers;
@property (nonatomic, readwrite) NSUInteger catalogCount;
@property (nonatomic, copy) NSSet<NSString *> *existingChapterIDs;
@property (nonatomic, copy) NSArray<NSNumber *> *chapterNumbers;
@end

@implementation FQXLocalBook

+ (NSArray<NSDictionary *> *)downloadedBooksWithError:(NSError **)error {
    @try {
        id models = FQXObject(FQXLocalService(@"SSBookDownloadManager"), @"getAllBookDownloadStatusModels");
        if ([models isKindOfClass:NSArray.class]) {
            NSMutableArray *books = [NSMutableArray array];
            NSMutableSet *seen = [NSMutableSet set];
            for (id model in models) {
                NSDictionary *book = FQXDownloadedBookRecord(model);
                if (!book || [seen containsObject:book[@"id"]]) continue;
                [seen addObject:book[@"id"]];
                [books addObject:book];
            }
            return books;
        }
    } @catch (NSException *exception) {
        (void)exception;
    }
    FQXSourceError(error, 10, @"当前无法读取下载列表。请打开“我的下载”后重试。");
    return nil;
}

+ (instancetype)bookWithIdentifier:(NSString *)identifier fallbackTitle:(NSString *)title error:(NSError **)error {
    @try {
        id manager = FQXLocalService(@"FQReaderSaaSBookManager");
        id tasks = FQXLocalService(@"SSBookDownloadTaskManager");
        if (!manager || !FQXMethod(tasks, @"getDownloadTaskWithBookId:", "@", @[@"@"])) {
            FQXSourceError(error, 1, @"当前版本的本地小说或下载服务不可用。");
            return nil;
        }
        id task = ((id (*)(id, SEL, id))objc_msgSend)(tasks, NSSelectorFromString(@"getDownloadTaskWithBookId:"), identifier);
        id downloaded = FQXObject(task, @"finishChapterIds");
        if (![downloaded isKindOfClass:NSArray.class] || ![downloaded count]) {
            FQXSourceError(error, 11, @"没有读取到已完成的下载记录，请在“我的下载”确认章节已下载后重试。");
            return nil;
        }
        return [[self alloc] initWithManager:manager identifier:identifier fallbackTitle:title
                        downloadedChapterIDs:downloaded error:error];
    } @catch (NSException *exception) {
        (void)exception;
        FQXSourceError(error, 3, @"读取本地书籍或下载记录失败，请重新打开下载管理后重试。");
    }
    return nil;
}

- (instancetype)initWithManager:(id)manager identifier:(NSString *)identifier
                  fallbackTitle:(NSString *)title downloadedChapterIDs:(NSArray<NSString *> *)downloadedChapterIDs
                          error:(NSError **)error {
    self = [super init];
    if (!self) return nil;
    if (!FQXText(identifier).length ||
        !FQXMethod(manager, @"chapterIdsWithBookId:", "@", @[@"@"]) ||
        !FQXMethod(manager, @"bookWithBookId:", "@", @[@"@"]) ||
        !FQXMethod(manager, @"existingChapterContentIdsWithBookId:", "@", @[@"@"]) ||
        !FQXMethod(manager, @"chapterContentWithBookId:chapterId:", "@", @[@"@", @"@"])) {
        FQXSourceError(error, 2, @"本地章节接口与当前版本不兼容。");
        return nil;
    }
    _manager = manager;
    _identifier = [identifier copy];
    id book;
    id identifiers;
    id existing;
    @try {
        book = ((id (*)(id, SEL, id))objc_msgSend)(manager, NSSelectorFromString(@"bookWithBookId:"), identifier);
        identifiers = ((id (*)(id, SEL, id))objc_msgSend)(manager, NSSelectorFromString(@"chapterIdsWithBookId:"), identifier);
        existing = ((id (*)(id, SEL, id))objc_msgSend)(manager, NSSelectorFromString(@"existingChapterContentIdsWithBookId:"), identifier);
    } @catch (NSException *exception) {
        (void)exception;
        FQXSourceError(error, 3, @"读取本地书籍信息失败，请重新打开下载管理后重试。");
        return nil;
    }
    if (![identifiers isKindOfClass:NSArray.class] || ![identifiers count]) {
        FQXSourceError(error, 4, @"没有可导出的本地章节目录。");
        return nil;
    }
    if (![existing isKindOfClass:NSSet.class]) {
        FQXSourceError(error, 12, @"无法读取本地章节正文索引。");
        return nil;
    }
    NSMutableSet<NSString *> *downloaded = [NSMutableSet set];
    for (id chapter in downloadedChapterIDs) {
        if (!FQXText(chapter).length) {
            FQXSourceError(error, 11, @"已下载章节记录包含无效编号。");
            return nil;
        }
        [downloaded addObject:chapter];
    }
    NSMutableSet *unique = [NSMutableSet set];
    NSMutableArray *chapters = [NSMutableArray array];
    NSMutableArray *numbers = [NSMutableArray array];
    for (id chapter in identifiers) {
        if (!FQXText(chapter).length || [unique containsObject:chapter]) {
            FQXSourceError(error, 5, @"本地章节目录包含空编号或重复章节。");
            return nil;
        }
        [unique addObject:chapter];
        if ([downloaded containsObject:chapter]) {
            [chapters addObject:chapter];
            [numbers addObject:@(unique.count)];
        }
    }
    if (!chapters.count) {
        FQXSourceError(error, 11, @"本地目录中没有匹配的已下载章节。");
        return nil;
    }
    NSString *name = FQXText(FQXObject(book, @"bookName"));
    NSString *author = FQXText(FQXObject(book, @"authorName")) ?: @"";
    _metadata = @{@"id": identifier, @"title": name.length ? name : title, @"author": author};
    _chapterIdentifiers = [chapters copy];
    _chapterNumbers = [numbers copy];
    _catalogCount = [identifiers count];
    _existingChapterIDs = [existing copy];
    return self;
}

- (NSDictionary *)chapterAtIndex:(NSUInteger)index error:(NSError **)error {
    if (index >= self.chapterIdentifiers.count) {
        FQXSourceError(error, 6, @"所选章节超出本地目录范围。");
        return nil;
    }
    NSString *chapterID = self.chapterIdentifiers[index];
    unsigned long number = self.chapterNumbers[index].unsignedLongValue;
    // The download ledger can mark an unavailable chapter finished. Do not
    // replace a selected missing chapter with an older cached one.
    if (![self.existingChapterIDs containsObject:chapterID]) {
        FQXSourceError(error, 8, [NSString stringWithFormat:@"第 %lu 章缺少本地正文，请重新下载该章节。", number]);
        return nil;
    }
    id content;
    NSString *body;
    @try {
        content = ((id (*)(id, SEL, id, id))objc_msgSend)(self.manager,
            NSSelectorFromString(@"chapterContentWithBookId:chapterId:"), self.identifier, chapterID);
        body = FQXText(FQXObject(content, @"decryptChapterContent"));
        if (content && !body.length) {
            id encrypted = FQXObject(content, @"encryptChapterContent");
            id crypto = FQXObject(self.manager, @"bookCrypt");
            BOOL supported = FQXMethod(content, @"cryptStatus", "s", @[]) &&
                FQXMethod(content, @"keyVersion", "q", @[]) &&
                FQXMethod(content, @"shouldDecompress", "B", @[]) &&
                FQXMethod(crypto, @"decryptContent:cryptStatus:keyVersion:shouldDecompress:",
                          "@", @[@"@", @"q", @"q", @"B"]);
            if (encrypted && supported) {
                short status = ((short (*)(id, SEL))objc_msgSend)(content, NSSelectorFromString(@"cryptStatus"));
                NSInteger keyVersion = ((NSInteger (*)(id, SEL))objc_msgSend)(content, NSSelectorFromString(@"keyVersion"));
                BOOL decompress = ((BOOL (*)(id, SEL))objc_msgSend)(content, NSSelectorFromString(@"shouldDecompress"));
                body = FQXText(((id (*)(id, SEL, id, NSInteger, NSInteger, BOOL))objc_msgSend)(crypto,
                    NSSelectorFromString(@"decryptContent:cryptStatus:keyVersion:shouldDecompress:"),
                    encrypted, (NSInteger)status, keyVersion, decompress));
            }
        }
    } @catch (NSException *exception) {
        (void)exception;
        FQXSourceError(error, 7, [NSString stringWithFormat:@"宿主读取第 %lu 章时发生错误。", number]);
        return nil;
    }
    if (!content || !body.length) {
        FQXSourceError(error, 8, [NSString stringWithFormat:@"第 %lu 章未下载或解密失败，导出已停止。", number]);
        return nil;
    }
    NSError *parseError;
    NSArray *paragraphs = FQXParagraphsFromContent(body, &parseError);
    if (!paragraphs.count) {
        FQXSourceError(error, 9, [NSString stringWithFormat:@"第 %lu 章正文解析失败，导出已停止。%@", number,
                                 parseError.localizedDescription ?: @""]);
        return nil;
    }
    NSString *name = FQXText(FQXObject(content, @"chapterName"));
    if (!name.length) name = [NSString stringWithFormat:@"第 %lu 章", number];
    return @{@"id": chapterID, @"title": name, @"paragraphs": paragraphs};
}
@end
