#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

typedef NS_ENUM(NSInteger, FQXDiagCategory) {
    FQXDiagCategoryAll = 0,
    FQXDiagCategoryNetwork = 1,
    FQXDiagCategoryHook = 2,
    FQXDiagCategoryView = 3,
    FQXDiagCategoryTTS = 4,
    FQXDiagCategorySecurity = 5,
    FQXDiagCategoryUI = 6,
};

FOUNDATION_EXPORT NSString *const FQXDiagCategoryFilterPrefKey;

void FQXDiagnosticsHubInstall(void);
BOOL FQXDiagnosticsHubIsEnabled(void);
BOOL FQXDiagnosticsHubIsEnhanced(void);
NSString *FQXDiagCategoryKey(FQXDiagCategory category);
NSString *FQXDiagPseudonymize(id _Nullable rawValue);

BOOL FQXDiagIsSecurityVerificationObject(id _Nullable obj);
BOOL FQXDiagIsSecurityVerificationHierarchy(UIView * _Nullable view);
BOOL FQXDiagHasActiveSecurityVerificationInWindows(void);

void FQXDiagPushPluginViewReason(const char * _Nullable reason, const char * _Nullable caller);
void FQXDiagPopPluginViewReason(void);

void FQXDiagRecordEvent(FQXDiagCategory category,
                        NSString *eventName,
                        NSDictionary<NSString *, id> *data,
                        BOOL highPriority);

// For infrequent lifecycle and navigation checkpoints that must reach disk before returning.
void FQXDiagRecordCriticalEvent(FQXDiagCategory category,
                               NSString *eventName,
                               NSDictionary<NSString *, id> *data);

void FQXDiagRecordHook(const char *hostClass,
                       const char *selector,
                       const char *ruleName,
                       const char *reason,
                       const char *outcome,
                       double durationMs);

BOOL FQXDiagInstallOwnedHook(Class _Nullable target,
                             const char *hostClassName,
                             SEL selector,
                             BOOL classMethod,
                             const char *expectedEncoding,
                             const char *ruleName,
                             IMP replacement,
                             IMP _Nullable * _Nullable original);

void FQXDiagRecordReaderTTSCheck(id _Nullable ttsMgr,
                                 id _Nullable paraMgr,
                                 id _Nullable readerMgr,
                                 const char *trigger);

void FQXDiagRecordTTSPlaybackEvent(id _Nullable sdkManager,
                                   id _Nullable playManager,
                                   id _Nullable positionObj,
                                   NSString * _Nullable entrySource,
                                   const char *stage,
                                   BOOL scheduleFollowUp);

void FQXDiagRecordSecurityDialogCheck(id _Nullable dialog,
                                      id _Nullable contentView,
                                      const char *entryPoint,
                                      BOOL suppressedByPlugin);

void FQXDiagnosticsHubPurgeFiles(void);

void FQXDiagnosticsHubFinalizeExport(NSURL *coreExportURL,
                                     NSInteger categoryFilter,
                                     void (^completion)(NSURL * _Nullable finalURL,
                                                        NSString * _Nullable errorMessage));

NS_ASSUME_NONNULL_END
