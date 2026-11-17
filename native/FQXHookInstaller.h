#import <Foundation/Foundation.h>
#import <objc/runtime.h>
NS_ASSUME_NONNULL_BEGIN
/// Installs on an owned method; inherited IMPs are localized before replacement.
/// ABI encoding must match exactly. Unsafe or duplicate installs are declined.
BOOL FQXInstallOwnedHook(Class target, SEL selector, BOOL classMethod,
                         const char *expectedEncoding, IMP replacement,
                         IMP _Nullable * _Nullable original);
NS_ASSUME_NONNULL_END
