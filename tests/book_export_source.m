#import <Foundation/Foundation.h>
#import "BookExportSource.h"

@interface FQXTestBook : NSObject
- (NSString *)bookName;
- (NSString *)authorName;
@end
@implementation FQXTestBook
- (NSString *)bookName { return @"本地测试小说"; }
- (NSString *)authorName { return @"测试作者"; }
@end

@interface FQXTestContent : NSObject
@property (nonatomic, copy) NSString *chapterName;
@property (nonatomic, copy) NSString *decryptChapterContent;
@property (nonatomic, copy) NSString *encryptChapterContent;
@property (nonatomic) short cryptStatus;
@property (nonatomic) NSInteger keyVersion;
@property (nonatomic) BOOL shouldDecompress;
@end
@implementation FQXTestContent
@end

@interface FQXTestCrypto : NSObject
@property (nonatomic) NSUInteger calls;
@property (nonatomic) BOOL fail;
- (id)decryptContent:(id)value cryptStatus:(NSInteger)status keyVersion:(NSInteger)version shouldDecompress:(BOOL)decompress;
@end
@implementation FQXTestCrypto
- (id)decryptContent:(id)value cryptStatus:(NSInteger)status keyVersion:(NSInteger)version shouldDecompress:(BOOL)decompress {
    NSCAssert(status == -2 && version == 7 && decompress, @"Exact signed status and scalar ABI");
    NSCAssert([value isEqual:@"local encoded chapter"], @"Use the cached encrypted object");
    self.calls++;
    return self.fail ? nil : @"<body><p>第二章 &amp; 本地正文</p></body>";
}
@end

@interface FQXTestManager : NSObject
@property (nonatomic, copy) NSArray *identifiers;
@property (nonatomic, copy) NSSet *indexed;
@property (nonatomic, strong) NSMutableDictionary *contents;
@property (nonatomic, strong) FQXTestCrypto *bookCrypt;
@property (nonatomic, strong) NSMutableArray *reads;
- (id)bookWithBookId:(id)identifier;
- (id)chapterIdsWithBookId:(id)identifier;
- (id)existingChapterContentIdsWithBookId:(id)identifier;
- (id)chapterContentWithBookId:(id)identifier chapterId:(id)chapter;
@end
@implementation FQXTestManager
- (id)bookWithBookId:(id)identifier {
    NSCAssert([identifier isEqual:@"book-1"], @"Pass the chosen book ID");
    return [FQXTestBook new];
}
- (id)chapterIdsWithBookId:(id)identifier {
    NSCAssert([identifier isEqual:@"book-1"], @"Read the local directory");
    return self.identifiers;
}
- (id)existingChapterContentIdsWithBookId:(id)identifier {
    NSCAssert([identifier isEqual:@"book-1"], @"Read the selected book's local body index");
    return self.indexed;
}
- (id)chapterContentWithBookId:(id)identifier chapterId:(id)chapter {
    NSCAssert([identifier isEqual:@"book-1"], @"Read the selected local book");
    [self.reads addObject:chapter];
    return self.contents[chapter];
}
@end

int main(void) {
    @autoreleasepool {
        FQXTestManager *manager = [FQXTestManager new];
        manager.identifiers = @[@"chapter-3", @"reader-cache", @"chapter-9", @"not-downloaded"];
        manager.indexed = [NSSet setWithArray:@[@"chapter-3", @"reader-cache", @"chapter-9"]];
        NSArray *downloaded = @[@"chapter-9", @"chapter-3"];
        manager.contents = [NSMutableDictionary dictionary];
        manager.reads = [NSMutableArray array];
        manager.bookCrypt = [FQXTestCrypto new];
        FQXTestContent *plain = [FQXTestContent new];
        plain.chapterName = @"第一章";
        plain.decryptChapterContent = @"<body><p>第一段😀</p><p>第二段</p></body>";
        manager.contents[@"chapter-3"] = plain;
        FQXTestContent *encoded = [FQXTestContent new];
        encoded.chapterName = @"第二章";
        encoded.encryptChapterContent = @"local encoded chapter";
        encoded.cryptStatus = -2;
        encoded.keyVersion = 7;
        encoded.shouldDecompress = YES;
        manager.contents[@"chapter-9"] = encoded;
        NSError *error;
        FQXLocalBook *book = [[FQXLocalBook alloc] initWithManager:manager identifier:@"book-1" fallbackTitle:@"备用书名"
                                            downloadedChapterIDs:downloaded error:&error];
        NSCAssert(book && !error && [book.metadata[@"author"] isEqual:@"测试作者"], @"Read local book metadata");
        NSCAssert(([book.chapterIdentifiers isEqual:@[@"chapter-3", @"chapter-9"]] && book.catalogCount == 4),
                  @"Download records select chapters in catalog order; incidental cache and unloaded catalog tail stay out");
        NSDictionary *first = [book chapterAtIndex:0 error:&error];
        NSCAssert([first[@"id"] isEqual:@"chapter-3"] && [first[@"paragraphs"] count] == 2, @"Normalize the plaintext local chapter");
        NSDictionary *last = [book chapterAtIndex:1 error:&error];
        NSCAssert([last[@"paragraphs"][0] containsString:@"&"] && manager.bookCrypt.calls == 1, @"Decode through host crypto");
        NSCAssert(([manager.reads isEqual:@[@"chapter-3", @"chapter-9"]]), @"Only local selected chapters are read");
        [manager.contents removeObjectForKey:@"chapter-9"];
        error = nil;
        NSCAssert(![book chapterAtIndex:1 error:&error] && error, @"Missing chapter is a hard failure");
        manager.indexed = [NSSet setWithArray:@[@"chapter-3", @"reader-cache"]];
        error = nil;
        FQXLocalBook *missing = [[FQXLocalBook alloc] initWithManager:manager identifier:@"book-1" fallbackTitle:@"备用书名"
                                               downloadedChapterIDs:downloaded error:&error];
        NSUInteger reads = manager.reads.count;
        NSCAssert(missing && ![missing chapterAtIndex:1 error:&error] &&
                  [error.localizedDescription containsString:@"第 3 章"] && manager.reads.count == reads,
                  @"A missing selected chapter is reported by catalog position and is not replaced by cached text");
        manager.contents[@"chapter-9"] = encoded;
        manager.bookCrypt.fail = YES;
        error = nil;
        NSCAssert(![book chapterAtIndex:1 error:&error] && error, @"Decrypt failure is reported");
        error = nil;
        NSCAssert(![book chapterAtIndex:2 error:&error] && error, @"Out-of-range chapter is rejected");
        manager.identifiers = @[@"chapter-3", @"chapter-3"];
        error = nil;
        NSCAssert(![[FQXLocalBook alloc] initWithManager:manager identifier:@"book-1" fallbackTitle:@"书名"
                                   downloadedChapterIDs:downloaded error:&error] && error,
                  @"Reject duplicate catalog entries");
        manager.identifiers = @[];
        error = nil;
        NSCAssert(![[FQXLocalBook alloc] initWithManager:manager identifier:@"book-1" fallbackTitle:@"书名"
                                   downloadedChapterIDs:downloaded error:&error] && error,
                  @"Reject empty catalog");
        error = nil;
        NSCAssert(![[FQXLocalBook alloc] initWithManager:[NSObject new] identifier:@"book-1" fallbackTitle:@"书名"
                                   downloadedChapterIDs:downloaded error:&error] && error,
                  @"Reject unsupported host ABI");
        puts("Book export local source checks passed");
    }
    return 0;
}
