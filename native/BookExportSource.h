#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface FQXLocalBook : NSObject
@property (nonatomic, readonly, copy) NSDictionary<NSString *, NSString *> *metadata;
@property (nonatomic, readonly, copy) NSArray<NSString *> *chapterIdentifiers;
+ (nullable instancetype)bookWithIdentifier:(NSString *)identifier
                            fallbackTitle:(NSString *)title
                                    error:(NSError * _Nullable * _Nullable)error;
- (nullable instancetype)initWithManager:(id)manager
                             identifier:(NSString *)identifier
                          fallbackTitle:(NSString *)title
                                  error:(NSError * _Nullable * _Nullable)error;
- (nullable NSDictionary *)chapterAtIndex:(NSUInteger)index error:(NSError * _Nullable * _Nullable)error;
@end

NS_ASSUME_NONNULL_END
