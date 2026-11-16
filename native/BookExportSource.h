#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

// The download manager and its visible reading rows share this model shape.
NSDictionary * _Nullable FQXDownloadedBookRecord(id _Nullable model);

@interface FQXLocalBook : NSObject
@property (nonatomic, readonly, copy) NSDictionary<NSString *, NSString *> *metadata;
// Explicit downloads, in the book catalog's original order.
@property (nonatomic, readonly, copy) NSArray<NSString *> *chapterIdentifiers;
@property (nonatomic, readonly) NSUInteger catalogCount;
+ (nullable NSArray<NSDictionary *> *)downloadedBooksWithError:(NSError * _Nullable * _Nullable)error;
+ (nullable instancetype)bookWithIdentifier:(NSString *)identifier
                            fallbackTitle:(NSString *)title
                                    error:(NSError * _Nullable * _Nullable)error;
- (nullable instancetype)initWithManager:(id)manager
                             identifier:(NSString *)identifier
                          fallbackTitle:(NSString *)title
                   downloadedChapterIDs:(NSArray<NSString *> *)downloadedChapterIDs
                                  error:(NSError * _Nullable * _Nullable)error;
- (nullable NSDictionary *)chapterAtIndex:(NSUInteger)index error:(NSError * _Nullable * _Nullable)error;
@end

NS_ASSUME_NONNULL_END
