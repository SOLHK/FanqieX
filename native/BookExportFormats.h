#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

FOUNDATION_EXPORT NSString *const FQXBookExportErrorDomain;

typedef NS_ENUM(NSInteger, FQXBookExportFormat) {
    FQXBookExportFormatTXT = 0,
    FQXBookExportFormatMarkdown,
    FQXBookExportFormatHTML,
    FQXBookExportFormatEPUB,
    FQXBookExportFormatJSON,
};

// Reads already obtained local content. It never resolves external resources.
FOUNDATION_EXPORT NSArray<NSString *> * _Nullable
FQXParagraphsFromContent(NSString *content, NSError * _Nullable * _Nullable error);

// Book: title, optional id/author. Chapter: title, optional id, paragraphs.
// All values are strings except paragraphs, which is an array of strings.
// A writer owns only its hidden staging file. The destination must not exist;
// it becomes visible only after finish succeeds. Calls must be serialized.
@interface FQXBookExportWriter : NSObject
- (nullable instancetype)initWithBook:(NSDictionary *)book
                              format:(FQXBookExportFormat)format
                         destination:(NSURL *)destination
                               error:(NSError * _Nullable * _Nullable)error;
- (BOOL)appendChapter:(NSDictionary *)chapter error:(NSError * _Nullable * _Nullable)error;
- (BOOL)finish:(NSError * _Nullable * _Nullable)error;
- (void)cancel;
@end

NS_ASSUME_NONNULL_END
