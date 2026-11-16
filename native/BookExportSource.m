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

static void FQXSourceError(NSError **error, NSInteger code, NSString *message) {
    if (error) *error = [NSError errorWithDomain:@"FanqieX.BookExport" code:code
                                     userInfo:@{NSLocalizedDescriptionKey: message}];
}

@interface FQXLocalBook ()
@property (nonatomic, strong) id manager;
@property (nonatomic, copy) NSString *identifier;
@property (nonatomic, readwrite, copy) NSDictionary<NSString *, NSString *> *metadata;
@property (nonatomic, readwrite, copy) NSArray<NSString *> *chapterIdentifiers;
@end

@implementation FQXLocalBook

+ (instancetype)bookWithIdentifier:(NSString *)identifier fallbackTitle:(NSString *)title error:(NSError **)error {
    Class centerClass = NSClassFromString(@"HTSServiceCenter");
    Class managerClass = NSClassFromString(@"FQReaderSaaSBookManager");
    id center = FQXObject(centerClass, @"defaultCenter");
    if (!managerClass || !FQXMethod(center, @"getService:", "@", @[@"#"])) {
        FQXSourceError(error, 1, @"当前版本的本地小说服务不可用。");
        return nil;
    }
    id manager = ((id (*)(id, SEL, Class))objc_msgSend)(center, NSSelectorFromString(@"getService:"), managerClass);
    return [[self alloc] initWithManager:manager identifier:identifier fallbackTitle:title error:error];
}

- (instancetype)initWithManager:(id)manager identifier:(NSString *)identifier
                  fallbackTitle:(NSString *)title error:(NSError **)error {
    self = [super init];
    if (!self) return nil;
    if (!FQXText(identifier).length ||
        !FQXMethod(manager, @"chapterIdsWithBookId:", "@", @[@"@"]) ||
        !FQXMethod(manager, @"bookWithBookId:", "@", @[@"@"]) ||
        !FQXMethod(manager, @"chapterContentWithBookId:chapterId:", "@", @[@"@", @"@"])) {
        FQXSourceError(error, 2, @"本地章节接口与当前版本不兼容。");
        return nil;
    }
    _manager = manager;
    _identifier = [identifier copy];
    id book;
    id identifiers;
    @try {
        book = ((id (*)(id, SEL, id))objc_msgSend)(manager, NSSelectorFromString(@"bookWithBookId:"), identifier);
        identifiers = ((id (*)(id, SEL, id))objc_msgSend)(manager, NSSelectorFromString(@"chapterIdsWithBookId:"), identifier);
    } @catch (NSException *exception) {
        (void)exception;
        FQXSourceError(error, 3, @"读取本地书籍信息失败，请重新打开下载管理后重试。");
        return nil;
    }
    if (![identifiers isKindOfClass:NSArray.class] || ![identifiers count]) {
        FQXSourceError(error, 4, @"没有可导出的本地章节目录。");
        return nil;
    }
    NSMutableSet *unique = [NSMutableSet set];
    for (id chapter in identifiers) {
        if (!FQXText(chapter).length || [unique containsObject:chapter]) {
            FQXSourceError(error, 5, @"本地章节目录包含空编号或重复章节。");
            return nil;
        }
        [unique addObject:chapter];
    }
    NSString *name = FQXText(FQXObject(book, @"bookName"));
    NSString *author = FQXText(FQXObject(book, @"authorName")) ?: @"";
    _metadata = @{@"id": identifier, @"title": name.length ? name : title, @"author": author};
    _chapterIdentifiers = [identifiers copy];
    return self;
}

- (NSDictionary *)chapterAtIndex:(NSUInteger)index error:(NSError **)error {
    if (index >= self.chapterIdentifiers.count) {
        FQXSourceError(error, 6, @"所选章节超出本地目录范围。");
        return nil;
    }
    NSString *chapterID = self.chapterIdentifiers[index];
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
        FQXSourceError(error, 7, [NSString stringWithFormat:@"宿主读取第 %lu 章时发生错误。", (unsigned long)index + 1]);
        return nil;
    }
    if (!content || !body.length) {
        FQXSourceError(error, 8, [NSString stringWithFormat:@"第 %lu 章未下载或解密失败，导出已停止。", (unsigned long)index + 1]);
        return nil;
    }
    NSError *parseError;
    NSArray *paragraphs = FQXParagraphsFromContent(body, &parseError);
    if (!paragraphs.count) {
        FQXSourceError(error, 9, [NSString stringWithFormat:@"第 %lu 章正文解析失败，导出已停止。%@", (unsigned long)index + 1,
                                 parseError.localizedDescription ?: @""]);
        return nil;
    }
    NSString *name = FQXText(FQXObject(content, @"chapterName"));
    if (!name.length) name = [NSString stringWithFormat:@"第 %lu 章", (unsigned long)index + 1];
    return @{@"id": chapterID, @"title": name, @"paragraphs": paragraphs};
}
@end
