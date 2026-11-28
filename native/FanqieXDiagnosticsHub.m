#import "FanqieXDiagnosticsHub.h"
#import "FQXHookInstaller.h"
#import <QuartzCore/QuartzCore.h>
#import <objc/message.h>
#import <objc/runtime.h>
#import <os/lock.h>
#include <stdatomic.h>
#include <stdlib.h>
#include <string.h>

NSString *const FQXDiagCategoryFilterPrefKey = @"FanqieX.DiagCategoryFilter.1";

#ifndef FQX_BUILD_VERSION
#define FQX_BUILD_VERSION "2.0.1beta9"
#endif
static NSString *const kFQXHubPluginVersion = @FQX_BUILD_VERSION;

NSString *FQXPluginVersion(void) {
    return kFQXHubPluginVersion;
}
static const NSUInteger kFQXHubMaxDiskBytesPerFile = 256 * 1024; // 256 KB x 2 rotating files max
static const NSUInteger kFQXHubLastSessionBytes = 2 * 256 * 1024 + 4096;
static const NSUInteger kFQXHubWriteFlushBytes = 8 * 1024;       // Batch JSONL disk writes in 8 KB chunks
static const NSUInteger kFQXHubRingNormalLimit = 48;             // Disk JSONL stores history; keep tiny RAM tail
static const NSUInteger kFQXHubRingEnhancedLimit = 160;
static const NSUInteger kFQXHubRecentFailuresLimit = 20;

static _Atomic BOOL gFQXDiagEnabled = YES;
static _Atomic BOOL gFQXDiagEnhanced = NO;
static _Atomic uint64_t gFQXHubSequence = 0;
static _Atomic uint64_t gFQXHubDroppedCount = 0;
static _Atomic uint64_t gFQXNetReqSeq = 0;

static uint8_t gFQXSessionSalt[16];
static dispatch_once_t gFQXSaltOnce;
static NSString *gFQXHubSessionId = nil;

static os_unfair_lock gFQXRateLock = OS_UNFAIR_LOCK_INIT;
static CFTimeInterval gFQXBucketWindow[7] = {0};
static NSUInteger gFQXBucketCount[7] = {0};

static os_unfair_lock gFQXHookCountLock = OS_UNFAIR_LOCK_INIT;
static NSMutableDictionary<NSString *, NSNumber *> *gFQXHookCallCounts = nil;

static os_unfair_lock gFQXRecentFailLock = OS_UNFAIR_LOCK_INIT;
static NSMutableArray<NSDictionary<NSString *, id> *> *gFQXRecentNetFailures = nil;
static NSUInteger gFQXSnssdkIssuedCount = 0;
static NSUInteger gFQXSnssdkSuccessCount = 0;
static NSUInteger gFQXSnssdkFailureCount = 0;
static NSUInteger gFQXSnssdkCancelledCount = 0;
static NSUInteger gFQXSnssdkUnobservedCount = 0;

static char gFQXHubQueueKey;

static dispatch_queue_t FQXHubQueue(void) {
    static dispatch_queue_t q = nil;
    static dispatch_once_t once;
    dispatch_once(&once, ^{
        dispatch_queue_attr_t attr = dispatch_queue_attr_make_with_qos_class(DISPATCH_QUEUE_SERIAL, QOS_CLASS_UTILITY, 0);
        q = dispatch_queue_create("com.fanqiex.diagnostics.hub", attr);
        dispatch_queue_set_specific(q, &gFQXHubQueueKey, &gFQXHubQueueKey, NULL);
    });
    return q;
}

static NSMutableArray<NSDictionary<NSString *, id> *> *gFQXHubRing = nil;

typedef struct {
    const char *reason;
    const char *caller;
} FQXPluginReasonFrame;

static _Thread_local FQXPluginReasonFrame gFQXReasonStack[4];
static _Thread_local int gFQXReasonDepth = 0;

void FQXDiagPushPluginViewReason(const char *reason, const char *caller) {
    if (gFQXReasonDepth >= 0 && gFQXReasonDepth < 4) {
        gFQXReasonStack[gFQXReasonDepth].reason = reason;
        gFQXReasonStack[gFQXReasonDepth].caller = caller;
        ++gFQXReasonDepth;
    }
}

void FQXDiagPopPluginViewReason(void) {
    if (gFQXReasonDepth > 0) {
        --gFQXReasonDepth;
        gFQXReasonStack[gFQXReasonDepth].reason = NULL;
        gFQXReasonStack[gFQXReasonDepth].caller = NULL;
    }
}

static FQXPluginReasonFrame FQXCurrentPluginReason(void) {
    if (gFQXReasonDepth > 0 && gFQXReasonDepth <= 4) {
        return gFQXReasonStack[gFQXReasonDepth - 1];
    }
    FQXPluginReasonFrame empty = {NULL, NULL};
    return empty;
}

static void FQXRefreshDiagPrefsFromDefaults(void) {
    NSUserDefaults *ud = NSUserDefaults.standardUserDefaults;
    id enObj = [ud objectForKey:@"FanqieX.DiagnosticsEnabled"];
    BOOL enabled = (!enObj || ![enObj respondsToSelector:@selector(boolValue)]) ? YES : [enObj boolValue];
    id enhObj = [ud objectForKey:@"FanqieX.EnhancedDiagnostics.1"];
    BOOL enhanced = [enhObj respondsToSelector:@selector(boolValue)] ? [enhObj boolValue] : NO;
    atomic_store_explicit(&gFQXDiagEnabled, enabled, memory_order_relaxed);
    atomic_store_explicit(&gFQXDiagEnhanced, enhanced, memory_order_relaxed);
}

BOOL FQXDiagnosticsHubIsEnabled(void) {
    return atomic_load_explicit(&gFQXDiagEnabled, memory_order_relaxed);
}

BOOL FQXDiagnosticsHubIsEnhanced(void) {
    return atomic_load_explicit(&gFQXDiagEnhanced, memory_order_relaxed);
}

NSString *FQXDiagCategoryKey(FQXDiagCategory category) {
    switch (category) {
        case FQXDiagCategoryNetwork:  return @"network";
        case FQXDiagCategoryHook:     return @"hook";
        case FQXDiagCategoryView:     return @"view";
        case FQXDiagCategoryTTS:      return @"tts";
        case FQXDiagCategorySecurity: return @"security";
        case FQXDiagCategoryUI:       return @"ui";
        case FQXDiagCategoryAll:
        default:                      return @"all";
    }
}

static NSString *FQXDiagCategoryDisplayName(NSInteger category) {
    switch (category) {
        case FQXDiagCategoryNetwork:  return @"网络请求";
        case FQXDiagCategoryHook:     return @"Hook 拦截";
        case FQXDiagCategoryView:     return @"视图生命周期";
        case FQXDiagCategoryTTS:      return @"听书与段落定位";
        case FQXDiagCategorySecurity: return @"安全验证与启动";
        case FQXDiagCategoryUI:       return @"底栏与界面";
        default:                      return @"全部类别";
    }
}

static void FQXEnsureSessionSalt(void) {
    dispatch_once(&gFQXSaltOnce, ^{
        arc4random_buf(gFQXSessionSalt, sizeof(gFQXSessionSalt));
        gFQXHubSessionId = NSUUID.UUID.UUIDString ?: @"session";
    });
}

#define FQX_ROTL64(x, b) (uint64_t)(((x) << (b)) | ((x) >> (64 - (b))))
#define FQX_SIPROUND(v0, v1, v2, v3) do { \
    (v0) += (v1); (v1) = FQX_ROTL64((v1), 13); (v1) ^= (v0); (v0) = FQX_ROTL64((v0), 32); \
    (v2) += (v3); (v3) = FQX_ROTL64((v3), 16); (v3) ^= (v2); \
    (v0) += (v3); (v3) = FQX_ROTL64((v3), 21); (v3) ^= (v0); \
    (v2) += (v1); (v1) = FQX_ROTL64((v1), 17); (v1) ^= (v2); (v2) = FQX_ROTL64((v2), 32); \
} while (0)

static uint64_t FQXKeyedSipHash24(const uint8_t *inBuf, size_t inLen, const uint8_t key[16]) {
    uint64_t k0 = 0, k1 = 0;
    memcpy(&k0, key, 8);
    memcpy(&k1, key + 8, 8);
    uint64_t v0 = 0x736f6d6570736575ULL ^ k0;
    uint64_t v1 = 0x646f72616e646f6dULL ^ k1;
    uint64_t v2 = 0x6c7967656e657261ULL ^ k0;
    uint64_t v3 = 0x7465646279746573ULL ^ k1;
    const uint8_t *end = inBuf + (inLen - (inLen % 8));
    for (; inBuf != end; inBuf += 8) {
        uint64_t m = 0;
        memcpy(&m, inBuf, 8);
        v3 ^= m;
        FQX_SIPROUND(v0, v1, v2, v3);
        FQX_SIPROUND(v0, v1, v2, v3);
        v0 ^= m;
    }
    size_t rem = inLen & 7;
    uint64_t b = ((uint64_t)inLen) << 56;
    if (rem >= 7) b |= ((uint64_t)inBuf[6]) << 48;
    if (rem >= 6) b |= ((uint64_t)inBuf[5]) << 40;
    if (rem >= 5) b |= ((uint64_t)inBuf[4]) << 32;
    if (rem >= 4) b |= ((uint64_t)inBuf[3]) << 24;
    if (rem >= 3) b |= ((uint64_t)inBuf[2]) << 16;
    if (rem >= 2) b |= ((uint64_t)inBuf[1]) << 8;
    if (rem >= 1) b |= ((uint64_t)inBuf[0]);
    v3 ^= b;
    FQX_SIPROUND(v0, v1, v2, v3);
    FQX_SIPROUND(v0, v1, v2, v3);
    v0 ^= b;
    v2 ^= 0xff;
    FQX_SIPROUND(v0, v1, v2, v3);
    FQX_SIPROUND(v0, v1, v2, v3);
    FQX_SIPROUND(v0, v1, v2, v3);
    FQX_SIPROUND(v0, v1, v2, v3);
    return v0 ^ v1 ^ v2 ^ v3;
}

NSString *FQXDiagPseudonymize(id rawValue) {
    if (!rawValue || rawValue == NSNull.null) return @"none";
    NSString *str = nil;
    if ([rawValue isKindOfClass:NSString.class]) {
        str = (NSString *)rawValue;
    } else if ([rawValue isKindOfClass:NSNumber.class]) {
        str = [(NSNumber *)rawValue stringValue];
    } else {
        return @"obj";
    }
    if (!str.length || [str isEqualToString:@"0"]) return @"none";
    FQXEnsureSessionSalt();
    NSData *utf8 = [str dataUsingEncoding:NSUTF8StringEncoding];
    if (!utf8.length) return @"none";
    uint64_t h = FQXKeyedSipHash24((const uint8_t *)utf8.bytes, utf8.length, gFQXSessionSalt);
    return [NSString stringWithFormat:@"id_%010llx", (unsigned long long)(h & 0xffffffffffULL)];
}

#pragma mark - Safe ObjC Introspection Helpers

static id FQXSafeObjMsg0(id target, const char *selName) {
    if (!target || !selName) return nil;
    SEL sel = sel_registerName(selName);
    Method m = class_getInstanceMethod(object_getClass(target), sel);
    if (!m) return nil;
    const char *enc = method_getTypeEncoding(m);
    if (!enc || enc[0] != '@' || method_getNumberOfArguments(m) != 2) return nil;
    return ((id (*)(id, SEL))objc_msgSend)(target, sel);
}

static BOOL FQXSafeBoolMsg0(id target, const char *selName, BOOL *outFound) {
    if (outFound) *outFound = NO;
    if (!target || !selName) return NO;
    SEL sel = sel_registerName(selName);
    Method m = class_getInstanceMethod(object_getClass(target), sel);
    if (!m || method_getNumberOfArguments(m) != 2) return NO;
    const char *enc = method_getTypeEncoding(m);
    if (!enc || (enc[0] != 'B' && enc[0] != 'c')) return NO;
    if (outFound) *outFound = YES;
    return ((BOOL (*)(id, SEL))objc_msgSend)(target, sel);
}

static NSInteger FQXSafeIntMsg0(id target, const char *selName, BOOL *outFound) {
    if (outFound) *outFound = NO;
    if (!target || !selName) return -1;
    SEL sel = sel_registerName(selName);
    Method m = class_getInstanceMethod(object_getClass(target), sel);
    if (!m || method_getNumberOfArguments(m) != 2) return -1;
    const char *enc = method_getTypeEncoding(m);
    if (!enc) return -1;
    if (enc[0] == 'q' || enc[0] == 'Q') {
        if (outFound) *outFound = YES;
        return ((NSInteger (*)(id, SEL))objc_msgSend)(target, sel);
    }
    if (enc[0] == 'i' || enc[0] == 'I') {
        if (outFound) *outFound = YES;
        return (NSInteger)((int (*)(id, SEL))objc_msgSend)(target, sel);
    }
    return -1;
}

static double FQXSafeDoubleMsg0(id target, const char *selName, BOOL *outFound) {
    if (outFound) *outFound = NO;
    if (!target || !selName) return 0.0;
    SEL sel = sel_registerName(selName);
    Method m = class_getInstanceMethod(object_getClass(target), sel);
    if (!m || method_getNumberOfArguments(m) != 2) return 0.0;
    const char *enc = method_getTypeEncoding(m);
    if (!enc) return 0.0;
    if (enc[0] == 'd') {
        if (outFound) *outFound = YES;
        return ((double (*)(id, SEL))objc_msgSend)(target, sel);
    }
    if (enc[0] == 'f') {
        if (outFound) *outFound = YES;
        return (double)((float (*)(id, SEL))objc_msgSend)(target, sel);
    }
    return 0.0;
}

#pragma mark - Storage, Rate Limiting & Rotation

static NSURL *FQXHubDirectoryURL(void) {
    NSArray<NSURL *> *urls = [NSFileManager.defaultManager URLsForDirectory:NSApplicationSupportDirectory
                                                                  inDomains:NSUserDomainMask];
    NSURL *appSupport = urls.firstObject;
    if (!appSupport) return nil;
    return [appSupport URLByAppendingPathComponent:@"FanqieAdBlockDiagnostics" isDirectory:YES];
}

static NSURL *FQXHubActiveFileURL(void) {
    return [FQXHubDirectoryURL() URLByAppendingPathComponent:@"hub-active.jsonl" isDirectory:NO];
}

static NSURL *FQXHubPreviousFileURL(void) {
    return [FQXHubDirectoryURL() URLByAppendingPathComponent:@"hub-prev.jsonl" isDirectory:NO];
}

static NSURL *FQXHubLastSessionURL(void) {
    return [FQXHubDirectoryURL() URLByAppendingPathComponent:@"hub-last-session.json" isDirectory:NO];
}

static NSMutableData *gFQXWriteBuffer = nil;
static unsigned long long gFQXActiveFileBytes = 0;
static BOOL gFQXActiveBytesInitialized = NO;
static BOOL gFQXFlushTimerArmed = NO;

static void FQXFlushWriteBufferOnHubQueue(void) {
    if (!gFQXWriteBuffer.length) return;
    NSURL *dir = FQXHubDirectoryURL();
    NSURL *active = FQXHubActiveFileURL();
    NSURL *prev = FQXHubPreviousFileURL();
    if (!dir || !active || !prev) {
        [gFQXWriteBuffer setLength:0];
        return;
    }
    NSFileManager *fm = NSFileManager.defaultManager;
    if (!gFQXActiveBytesInitialized) {
        [fm createDirectoryAtURL:dir withIntermediateDirectories:YES attributes:nil error:NULL];
        NSDictionary<NSFileAttributeKey, id> *attrs = [fm attributesOfItemAtPath:active.path error:NULL];
        gFQXActiveFileBytes = attrs ? [attrs fileSize] : 0;
        gFQXActiveBytesInitialized = YES;
    }
    if (gFQXActiveFileBytes && gFQXActiveFileBytes + 1 + gFQXWriteBuffer.length > kFQXHubMaxDiskBytesPerFile) {
        [fm removeItemAtURL:prev error:NULL];
        [fm moveItemAtURL:active toURL:prev error:NULL];
        gFQXActiveFileBytes = 0;
    }
    if (gFQXActiveFileBytes == 0 || ![fm fileExistsAtPath:active.path]) {
        [fm createDirectoryAtURL:dir withIntermediateDirectories:YES attributes:nil error:NULL];
        if ([gFQXWriteBuffer writeToURL:active options:NSDataWritingAtomic error:NULL]) {
            gFQXActiveFileBytes = gFQXWriteBuffer.length;
        }
    } else {
        NSFileHandle *fh = [NSFileHandle fileHandleForWritingToURL:active error:NULL];
        if (fh) {
            // Separate the next batch even if a killed process left a partial final line.
            if ([fh seekToEndReturningOffset:NULL error:NULL] &&
                [fh writeData:[NSData dataWithBytes:"\n" length:1] error:NULL] &&
                [fh writeData:gFQXWriteBuffer error:NULL]) {
                gFQXActiveFileBytes += gFQXWriteBuffer.length + 1;
            } else {
                gFQXActiveBytesInitialized = NO;
            }
            [fh closeAndReturnError:NULL];
        }
    }
    [gFQXWriteBuffer setLength:0];
}

void FQXDiagnosticsHubPurgeFiles(void) {
    dispatch_async(FQXHubQueue(), ^{
        [gFQXHubRing removeAllObjects];
        [gFQXWriteBuffer setLength:0];
        gFQXActiveFileBytes = 0;
        gFQXActiveBytesInitialized = YES;
        NSFileManager *fm = NSFileManager.defaultManager;
        NSURL *active = FQXHubActiveFileURL();
        NSURL *prev = FQXHubPreviousFileURL();
        if (active) [fm removeItemAtURL:active error:NULL];
        if (prev) [fm removeItemAtURL:prev error:NULL];
        NSURL *session = FQXHubLastSessionURL();
        if (session) [fm removeItemAtURL:session error:NULL];
    });
}

static BOOL FQXAllowByRateLimiter(FQXDiagCategory category, BOOL highPriority) {
    NSUInteger idx = (category >= FQXDiagCategoryAll && category <= FQXDiagCategoryUI)
        ? (NSUInteger)category : 0;
    BOOL enhanced = FQXDiagnosticsHubIsEnhanced();
    NSUInteger limit = enhanced ? 90 : 28;
    if (highPriority) limit = enhanced ? 240 : 120;

    CFTimeInterval now = CACurrentMediaTime();
    os_unfair_lock_lock(&gFQXRateLock);
    if (now - gFQXBucketWindow[idx] >= 1.0) {
        gFQXBucketWindow[idx] = now;
        gFQXBucketCount[idx] = 0;
    }
    BOOL allowed = (gFQXBucketCount[idx] < limit);
    if (allowed) {
        ++gFQXBucketCount[idx];
    }
    os_unfair_lock_unlock(&gFQXRateLock);
    if (!allowed) {
        atomic_fetch_add_explicit(&gFQXHubDroppedCount, 1, memory_order_relaxed);
    }
    return allowed;
}

static void FQXAppendJSONLineOnHubQueue(NSDictionary<NSString *, id> *entry) {
    NSUInteger cap = FQXDiagnosticsHubIsEnhanced() ? kFQXHubRingEnhancedLimit : kFQXHubRingNormalLimit;
    if (!gFQXHubRing) {
        gFQXHubRing = [NSMutableArray arrayWithCapacity:cap];
    }
    if (gFQXHubRing.count >= cap) {
        NSUInteger dropCount = gFQXHubRing.count - cap + 1;
        [gFQXHubRing removeObjectsInRange:NSMakeRange(0, dropCount)];
    }
    [gFQXHubRing addObject:entry];

    if (![NSJSONSerialization isValidJSONObject:entry]) return;
    NSError *jsonErr = nil;
    NSData *jsonData = [NSJSONSerialization dataWithJSONObject:entry options:0 error:&jsonErr];
    if (!jsonData.length || jsonErr || jsonData.length + 1 > kFQXHubMaxDiskBytesPerFile) return;

    if (gFQXWriteBuffer.length + jsonData.length + 1 > kFQXHubMaxDiskBytesPerFile) {
        FQXFlushWriteBufferOnHubQueue();
    }

    if (!gFQXWriteBuffer) {
        gFQXWriteBuffer = [NSMutableData dataWithCapacity:kFQXHubWriteFlushBytes + 1024];
    }
    [gFQXWriteBuffer appendData:jsonData];
    const char nl = '\n';
    [gFQXWriteBuffer appendBytes:&nl length:1];

    if (gFQXWriteBuffer.length >= kFQXHubWriteFlushBytes) {
        FQXFlushWriteBufferOnHubQueue();
    } else if (!gFQXFlushTimerArmed) {
        gFQXFlushTimerArmed = YES;
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, 250 * NSEC_PER_MSEC), FQXHubQueue(), ^{
            gFQXFlushTimerArmed = NO;
            FQXFlushWriteBufferOnHubQueue();
        });
    }
}

static NSDictionary<NSString *, id> *FQXMakeHubEntry(FQXDiagCategory category,
                                                     NSString *eventName,
                                                     NSDictionary<NSString *, id> *data) {
    FQXEnsureSessionSalt();
    uint64_t seq = atomic_fetch_add_explicit(&gFQXHubSequence, 1, memory_order_relaxed) + 1;
    return @{@"hubSeq": @(seq), @"timestamp": @(NSDate.date.timeIntervalSince1970),
             @"sessionId": gFQXHubSessionId, @"pluginVersion": kFQXHubPluginVersion,
             @"category": FQXDiagCategoryKey(category), @"event": eventName, @"data": [data copy] ?: @{}};
}

void FQXDiagRecordEvent(FQXDiagCategory category,
                        NSString *eventName,
                        NSDictionary<NSString *, id> *data,
                        BOOL highPriority) {
    if (!FQXDiagnosticsHubIsEnabled() || !eventName.length) return;
    if (!FQXAllowByRateLimiter(category, highPriority)) return;
    NSDictionary *entry = FQXMakeHubEntry(category, eventName, data);
    dispatch_async(FQXHubQueue(), ^{
        FQXAppendJSONLineOnHubQueue(entry);
    });
}

void FQXDiagRecordCriticalEvent(FQXDiagCategory category,
                               NSString *eventName,
                               NSDictionary<NSString *, id> *data) {
    if (!FQXDiagnosticsHubIsEnabled() || !eventName.length) return;
    NSDictionary *entry = FQXMakeHubEntry(category, eventName, data);
    dispatch_block_t record = ^{
        FQXAppendJSONLineOnHubQueue(entry);
        FQXFlushWriteBufferOnHubQueue();
    };
    if (dispatch_get_specific(&gFQXHubQueueKey)) record();
    else dispatch_sync(FQXHubQueue(), record);
}

#pragma mark - URL Sanitizer & Network Failure Classification (2.1)

static NSString *FQXScrubNumericPathSegments(NSString *rawPath) {
    if (!rawPath.length) return @"/";
    NSArray<NSString *> *parts = [rawPath componentsSeparatedByString:@"/"];
    NSMutableArray<NSString *> *out = [NSMutableArray arrayWithCapacity:parts.count];
    for (NSString *seg in parts) {
        if (seg.length >= 6) {
            BOOL allDigits = YES;
            for (NSUInteger i = 0; i < seg.length; ++i) {
                unichar ch = [seg characterAtIndex:i];
                if (ch < '0' || ch > '9') {
                    allDigits = NO;
                    break;
                }
            }
            if (allDigits) {
                [out addObject:@":id"];
                continue;
            }
        }
        [out addObject:seg];
    }
    NSString *joined = [out componentsJoinedByString:@"/"];
    return joined.length ? joined : @"/";
}

static void FQXSanitizeURLInfo(id urlCandidate,
                               NSString **outDomain,
                               NSString **outPath,
                               NSArray<NSString *> **outQueryKeys) {
    NSString *domain = @"";
    NSString *path = @"";
    NSMutableArray<NSString *> *qKeys = [NSMutableArray array];

    NSURLComponents *comp = nil;
    if ([urlCandidate isKindOfClass:NSURL.class]) {
        comp = [NSURLComponents componentsWithURL:(NSURL *)urlCandidate resolvingAgainstBaseURL:YES];
    } else if ([urlCandidate isKindOfClass:NSString.class]) {
        NSString *s = (NSString *)urlCandidate;
        // Handle BDRpc operationType format like "$POST /novel/commentapi/..."
        if ([s hasPrefix:@"$"]) {
            NSRange sp = [s rangeOfString:@" "];
            if (sp.location != NSNotFound && sp.location + 1 < s.length) {
                s = [s substringFromIndex:sp.location + 1];
            }
        }
        comp = [NSURLComponents componentsWithString:s];
        if (!comp && [s hasPrefix:@"/"]) {
            path = FQXScrubNumericPathSegments(s);
        }
    }

    if (comp) {
        if (comp.host.length) domain = comp.host.lowercaseString;
        if (comp.path.length) path = FQXScrubNumericPathSegments(comp.path);
        for (NSURLQueryItem *item in comp.queryItems) {
            if (item.name.length && qKeys.count < 16 && ![qKeys containsObject:item.name]) {
                [qKeys addObject:item.name];
            }
        }
    }

    if (outDomain) *outDomain = domain.length ? domain : @"unknown";
    if (outPath) *outPath = path.length ? path : @"/";
    if (outQueryKeys) *outQueryKeys = qKeys;
}

static NSString *FQXNextNetReqId(void) {
    uint64_t n = atomic_fetch_add_explicit(&gFQXNetReqSeq, 1, memory_order_relaxed) + 1;
    return [NSString stringWithFormat:@"r%llx", (unsigned long long)(n & 0xffffffULL)];
}

static BOOL FQXIsStaticAssetRequest(NSString *domain, NSString *path) {
    NSString *lowerDom = domain.lowercaseString ?: @"";
    if ([lowerDom hasSuffix:@"fqnovelpic.com"] || [lowerDom hasSuffix:@"byteimg.com"] ||
        [lowerDom hasSuffix:@"ecombdimg.com"] || [lowerDom hasSuffix:@"bdstatic.com"]) {
        return YES;
    }
    NSString *lowerPath = path.lowercaseString ?: @"";
    return [lowerPath hasSuffix:@".heic"] || [lowerPath hasSuffix:@".webp"] ||
           [lowerPath hasSuffix:@".png"] || [lowerPath hasSuffix:@".jpg"] ||
           [lowerPath hasSuffix:@".jpeg"] || [lowerPath hasSuffix:@".gif"] ||
           [lowerPath hasSuffix:@".avif"] || [lowerPath hasSuffix:@".svg"];
}

static BOOL FQXDomainIsSnssdk(NSString *domain) {
    if (!domain.length) return NO;
    return [domain isEqualToString:@"is.snssdk.com"] || [domain hasSuffix:@".snssdk.com"];
}

static BOOL FQXPathLooksCritical(NSString *domain, NSString *path) {
    if (FQXIsStaticAssetRequest(domain, path)) return NO;
    if (FQXDomainIsSnssdk(domain)) return YES;
    NSString *lowerDom = domain.lowercaseString ?: @"";
    NSString *lowerPath = path.lowercaseString ?: @"";
    if ([lowerDom containsString:@"bdturing"] || [lowerDom containsString:@"verify"] ||
        [lowerDom containsString:@"captcha"] || [lowerDom containsString:@"passport"]) {
        return YES;
    }
    if ([lowerPath containsString:@"turing"] || [lowerPath containsString:@"verify"] ||
        [lowerPath containsString:@"captcha"] || [lowerPath containsString:@"tts"] ||
        [lowerPath containsString:@"audio"] || [lowerPath containsString:@"speech"] ||
        [lowerPath containsString:@"passport"] || [lowerPath containsString:@"account"]) {
        return YES;
    }
    return NO;
}

static void FQXClassifyNetworkError(NSInteger statusCode,
                                    NSError *error,
                                    BOOL cancelledFlag,
                                    NSString **outSource,
                                    BOOL *outTimeout,
                                    BOOL *outConnFail,
                                    NSString **outNote) {
    BOOL isTimeout = NO;
    BOOL isConnFail = NO;
    NSString *source = @"ok";
    NSString *note = nil;

    if (cancelledFlag || (error && [error.domain isEqualToString:NSURLErrorDomain] && error.code == NSURLErrorCancelled)) {
        source = @"cancelled";
    } else if (error) {
        NSInteger code = error.code;
        NSString *dom = error.domain ?: @"";
        if (code == NSURLErrorTimedOut || code == -1001) {
            isTimeout = YES;
            source = @"timeout";
        } else if (code == NSURLErrorCannotFindHost || code == NSURLErrorDNSLookupFailed ||
                   code == -1003 || code == -1006) {
            isConnFail = YES;
            source = @"dns_lookup_failure_or_proxy_dns";
            note = @"DNS 解析或域名查找失败；可能由网络环境、DNS 或代理规则引起，是否命中 Loon REJECT 需以 Loon 日志为准";
        } else if (code == NSURLErrorCannotConnectToHost || code == NSURLErrorNetworkConnectionLost ||
                   code == NSURLErrorNotConnectedToInternet || code == 61 /* ECONNREFUSED */ ||
                   code == 54 /* ECONNRESET */ || code == -1004 || code == -1005 || code == -1009 ||
                   ([dom containsString:@"TTNet"] || [dom containsString:@"Cronet"] || [dom containsString:@"Chromium"])) {
            isConnFail = YES;
            source = @"connection_failure_or_suspected_proxy_interception";
            note = @"底层传输连接被拒绝/重置或网络中断（非 FanqieX 插件拦截）；仅凭客户端错误不能直接判定为 Loon REJECT，请对照 Loon 请求日志确认规则命中";
        } else if (code <= -1200 && code >= -1206) {
            isConnFail = YES;
            source = @"tls_or_certificate_error";
            note = @"TLS/证书握手失败；若开启了 MITM 解密或代理拦截，请检查代理证书与域名直连列表";
        } else {
            source = @"network_or_rpc_error";
        }
    } else if (statusCode >= 500) {
        source = @"http_server_error";
    } else if (statusCode >= 400) {
        source = @"http_client_error";
    }

    if (outSource) *outSource = source;
    if (outTimeout) *outTimeout = isTimeout;
    if (outConnFail) *outConnFail = isConnFail;
    if (outNote) *outNote = note;
}

static void FQXRecordRecentFailureSummary(NSString *domain,
                                          NSString *path,
                                          NSString *stage,
                                          NSInteger statusCode,
                                          NSError *error,
                                          NSString *interceptSource) {
    if ([stage isEqualToString:@"cancelled"] && FQXIsStaticAssetRequest(domain, path)) {
        return;
    }
    BOOL isSnssdk = [domain isEqualToString:@"is.snssdk.com"];
    os_unfair_lock_lock(&gFQXRecentFailLock);
    if (isSnssdk) {
        if ([stage isEqualToString:@"issued"]) ++gFQXSnssdkIssuedCount;
        else if ([stage isEqualToString:@"released_unobserved"]) ++gFQXSnssdkUnobservedCount;
        else if ([stage isEqualToString:@"returned"] && !error && (statusCode == 0 || (statusCode >= 200 && statusCode < 400))) ++gFQXSnssdkSuccessCount;
        else if ([stage isEqualToString:@"cancelled"]) ++gFQXSnssdkCancelledCount;
        else if ([stage isEqualToString:@"failed"] || error || statusCode >= 400) ++gFQXSnssdkFailureCount;
    }
    if ([stage isEqualToString:@"failed"] || [stage isEqualToString:@"cancelled"] || statusCode >= 400) {
        if (!gFQXRecentNetFailures) gFQXRecentNetFailures = [NSMutableArray arrayWithCapacity:kFQXHubRecentFailuresLimit];
        if (gFQXRecentNetFailures.count >= kFQXHubRecentFailuresLimit) {
            [gFQXRecentNetFailures removeObjectAtIndex:0];
        }
        [gFQXRecentNetFailures addObject:@{
            @"timestamp": @([NSDate date].timeIntervalSince1970),
            @"domain": domain ?: @"unknown",
            @"path": path ?: @"/",
            @"stage": stage ?: @"failed",
            @"statusCode": @(statusCode),
            @"errorDomain": error.domain ?: @"",
            @"errorCode": @(error ? error.code : 0),
            @"classification": interceptSource ?: @"unknown",
        }];
    }
    os_unfair_lock_unlock(&gFQXRecentFailLock);
}

static NSArray<NSDictionary<NSString *, id> *> *FQXRecentFailuresWithinSeconds(NSTimeInterval windowSec) {
    NSTimeInterval cutoff = [NSDate date].timeIntervalSince1970 - windowSec;
    NSMutableArray<NSDictionary<NSString *, id> *> *matched = [NSMutableArray array];
    os_unfair_lock_lock(&gFQXRecentFailLock);
    for (NSDictionary<NSString *, id> *item in gFQXRecentNetFailures) {
        if ([item[@"timestamp"] doubleValue] >= cutoff) {
            [matched addObject:item];
        }
    }
    os_unfair_lock_unlock(&gFQXRecentFailLock);
    return matched;
}

#pragma mark - Collector 1: BDRpcAsyncOperation + TTNet + NSURLSession

static const char FQXK_kFQXRpcTrackKey = 0;
#define kFQXRpcTrackKey ((const void *)&FQXK_kFQXRpcTrackKey)
static const char FQXK_kFQXTaskTrackKey = 0;
#define kFQXTaskTrackKey ((const void *)&FQXK_kFQXTaskTrackKey)
static void FQXExtractBDRpcRequestMetadata(id req,
                                           NSString **outMethod,
                                           NSString **outDomain,
                                           NSString **outPath,
                                           NSArray<NSString *> **outQueryKeys) {
    NSString *httpMethod = @"POST";
    id methodObj = FQXSafeObjMsg0(req, "method");
    id opType = FQXSafeObjMsg0(methodObj, "operationType");
    if ([opType isKindOfClass:NSString.class]) {
        NSString *op = (NSString *)opType;
        if ([op hasPrefix:@"$GET "]) httpMethod = @"GET";
        else if ([op hasPrefix:@"$POST "]) httpMethod = @"POST";
    }
    id directMethod = FQXSafeObjMsg0(req, "HTTPMethod") ?: FQXSafeObjMsg0(req, "httpMethod");
    if ([directMethod isKindOfClass:NSString.class] && [(NSString *)directMethod length] > 0) {
        httpMethod = [(NSString *)directMethod uppercaseString];
    }

    id urlCand = FQXSafeObjMsg0(req, "URL")
        ?: FQXSafeObjMsg0(req, "url")
        ?: FQXSafeObjMsg0(req, "urlString")
        ?: FQXSafeObjMsg0(req, "requestURL");
    NSString *domain = nil;
    NSString *path = nil;
    NSArray<NSString *> *queryKeys = nil;
    if (urlCand) {
        FQXSanitizeURLInfo(urlCand, &domain, &path, &queryKeys);
    } else {
        FQXSanitizeURLInfo(opType, &domain, &path, &queryKeys);
        id base = FQXSafeObjMsg0(req, "baseURL") ?: FQXSafeObjMsg0(methodObj, "baseURL") ?: FQXSafeObjMsg0(req, "host");
        if ([base isKindOfClass:NSURL.class] && [(NSURL *)base host].length) {
            domain = [(NSURL *)base host].lowercaseString;
        } else if ([base isKindOfClass:NSString.class] && [(NSString *)base length] > 0) {
            NSURLComponents *bc = [NSURLComponents componentsWithString:(NSString *)base];
            domain = bc.host.length ? bc.host.lowercaseString : [(NSString *)base lowercaseString];
        }
        if (!domain.length || [domain isEqualToString:@"unknown"]) domain = @"rpc.fanqie";
    }
    if (outMethod) *outMethod = httpMethod;
    if (outDomain) *outDomain = domain ?: @"rpc.fanqie";
    if (outPath) *outPath = path ?: @"/";
    if (outQueryKeys) *outQueryKeys = queryKeys ?: @[];
}

static id (*gOrigBDRpcInit)(id, SEL, id, id) = NULL;
static void (*gOrigBDRpcSend)(id, SEL) = NULL;
static void (*gOrigBDRpcCancel)(id, SEL) = NULL;
static void (*gOrigBDRpcPostHandle)(id, SEL, id, id) = NULL;
static void (*gOrigBDRpcComplete)(id, SEL) = NULL;

static id FQXHookBDRpcInit(id self, SEL cmd, id request, id completion) {
    id res = gOrigBDRpcInit ? gOrigBDRpcInit(self, cmd, request, completion) : self;
    if (!res || !FQXDiagnosticsHubIsEnabled()) return res;

    NSString *method = nil, *domain = nil, *path = nil;
    NSArray<NSString *> *queryKeys = nil;
    FQXExtractBDRpcRequestMetadata(request, &method, &domain, &path, &queryKeys);

    NSMutableDictionary<NSString *, id> *ctx = [NSMutableDictionary dictionaryWithCapacity:8];
    ctx[@"requestId"] = FQXNextNetReqId();
    ctx[@"domain"] = domain ?: @"rpc.fanqie";
    ctx[@"path"] = path ?: @"/";
    ctx[@"queryKeys"] = queryKeys ?: @[];
    ctx[@"httpMethod"] = method ?: @"POST";
    ctx[@"sendCount"] = @0;
    ctx[@"createdMono"] = @(CACurrentMediaTime());
    objc_setAssociatedObject(res, kFQXRpcTrackKey, ctx, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
    return res;
}

static void FQXHookBDRpcSend(id self, SEL cmd) {
    NSMutableDictionary<NSString *, id> *ctx = objc_getAssociatedObject(self, kFQXRpcTrackKey);
    if (ctx && FQXDiagnosticsHubIsEnabled()) {
        NSInteger sends = [ctx[@"sendCount"] integerValue] + 1;
        ctx[@"sendCount"] = @(sends);
        ctx[@"sendMono"] = @(CACurrentMediaTime());
        NSString *domain = ctx[@"domain"] ?: @"unknown";
        NSString *path = ctx[@"path"] ?: @"/";
        BOOL important = FQXPathLooksCritical(domain, path) || sends > 1;
        FQXRecordRecentFailureSummary(domain, path, @"issued", 0, nil, @"issued");
        if (important || FQXDiagnosticsHubIsEnhanced()) {
            FQXDiagRecordEvent(FQXDiagCategoryNetwork, @"network_request", @{
                @"transport": @"BDRpc",
                @"requestId": ctx[@"requestId"] ?: @"",
                @"domain": domain,
                @"path": path,
                @"queryKeys": ctx[@"queryKeys"] ?: @[],
                @"httpMethod": ctx[@"httpMethod"] ?: @"POST",
                @"stage": @"issued",
                @"isRetry": @(sends > 1),
                @"attempt": @(sends),
                @"isMonitoredSnssdk": @([domain isEqualToString:@"is.snssdk.com"]),
            }, important);
        }
    }
    if (gOrigBDRpcSend) gOrigBDRpcSend(self, cmd);
}

static void FQXHookBDRpcCancel(id self, SEL cmd) {
    NSMutableDictionary<NSString *, id> *ctx = objc_getAssociatedObject(self, kFQXRpcTrackKey);
    if (ctx && FQXDiagnosticsHubIsEnabled() && ![ctx[@"finalized"] boolValue]) {
        ctx[@"cancelled"] = @YES;
        ctx[@"finalized"] = @YES;
        CFTimeInterval start = [ctx[@"sendMono"] ?: ctx[@"createdMono"] doubleValue];
        double durMs = start > 0 ? (CACurrentMediaTime() - start) * 1000.0 : 0.0;
        NSString *domain = ctx[@"domain"] ?: @"unknown";
        NSString *path = ctx[@"path"] ?: @"/";
        FQXRecordRecentFailureSummary(domain, path, @"cancelled", 0, nil, @"cancelled");
        FQXDiagRecordEvent(FQXDiagCategoryNetwork, @"network_request", @{
            @"transport": @"BDRpc",
            @"requestId": ctx[@"requestId"] ?: @"",
            @"domain": domain,
            @"path": path,
            @"httpMethod": ctx[@"httpMethod"] ?: @"POST",
            @"stage": @"cancelled",
            @"statusCode": @0,
            @"durationMs": @(round(durMs * 10.0) / 10.0),
            @"isRetry": @([ctx[@"sendCount"] integerValue] > 1),
            @"isTimeout": @NO,
            @"isConnectionFailure": @NO,
            @"interceptSource": @"cancelled",
            @"isMonitoredSnssdk": @([domain isEqualToString:@"is.snssdk.com"]),
        }, YES);
    }
    if (gOrigBDRpcCancel) gOrigBDRpcCancel(self, cmd);
}

static void FQXHookBDRpcPostHandle(id self, SEL cmd, id result, id headerFields) {
    NSMutableDictionary<NSString *, id> *ctx = objc_getAssociatedObject(self, kFQXRpcTrackKey);
    if (ctx && [result isKindOfClass:NSDictionary.class]) {
        id bizCode = ((NSDictionary *)result)[@"code"] ?: ((NSDictionary *)result)[@"status_code"];
        if ([bizCode respondsToSelector:@selector(integerValue)]) {
            ctx[@"bizCode"] = @([bizCode integerValue]);
        }
    }
    if (ctx && [headerFields isKindOfClass:NSDictionary.class]) {
        ctx[@"hasHeaders"] = @(((NSDictionary *)headerFields).count > 0);
    }
    if (gOrigBDRpcPostHandle) gOrigBDRpcPostHandle(self, cmd, result, headerFields);
}

static void FQXHookBDRpcComplete(id self, SEL cmd) {
    NSMutableDictionary<NSString *, id> *ctx = objc_getAssociatedObject(self, kFQXRpcTrackKey);
    if (ctx && FQXDiagnosticsHubIsEnabled() && ![ctx[@"finalized"] boolValue]) {
        ctx[@"finalized"] = @YES;
        id errObj = FQXSafeObjMsg0(self, "error");
        NSError *err = [errObj isKindOfClass:NSError.class] ? (NSError *)errObj : nil;
        id respObj = FQXSafeObjMsg0(self, "response");
        BOOL foundStatus = NO;
        NSInteger statusCode = FQXSafeIntMsg0(respObj, "statusCode", &foundStatus);
        if (!foundStatus || statusCode < 0) statusCode = err ? 0 : 200;

        CFTimeInterval start = [ctx[@"sendMono"] ?: ctx[@"createdMono"] doubleValue];
        double durMs = start > 0 ? (CACurrentMediaTime() - start) * 1000.0 : 0.0;
        NSString *domain = ctx[@"domain"] ?: @"unknown";
        NSString *path = ctx[@"path"] ?: @"/";
        BOOL cancelled = [ctx[@"cancelled"] boolValue];
        NSString *source = nil;
        BOOL isTimeout = NO, isConnFail = NO;
        NSString *note = nil;
        FQXClassifyNetworkError(statusCode, err, cancelled, &source, &isTimeout, &isConnFail, &note);
        NSString *stage = cancelled ? @"cancelled" : ((err || statusCode >= 400) ? @"failed" : @"returned");

        FQXRecordRecentFailureSummary(domain, path, stage, statusCode, err, source);
        BOOL important = (err != nil) || (statusCode >= 400) || FQXPathLooksCritical(domain, path);
        if (important || FQXDiagnosticsHubIsEnhanced()) {
            NSMutableDictionary<NSString *, id> *payload = [@{
                @"transport": @"BDRpc",
                @"requestId": ctx[@"requestId"] ?: @"",
                @"domain": domain,
                @"path": path,
                @"queryKeys": ctx[@"queryKeys"] ?: @[],
                @"httpMethod": ctx[@"httpMethod"] ?: @"POST",
                @"stage": stage,
                @"statusCode": @(statusCode),
                @"durationMs": @(round(durMs * 10.0) / 10.0),
                @"errorDomain": err.domain ?: @"",
                @"errorCode": @(err ? err.code : 0),
                @"isRetry": @([ctx[@"sendCount"] integerValue] > 1),
                @"attempt": ctx[@"sendCount"] ?: @1,
                @"isTimeout": @(isTimeout),
                @"isConnectionFailure": @(isConnFail),
                @"interceptSource": source ?: @"ok",
                @"isMonitoredSnssdk": @([domain isEqualToString:@"is.snssdk.com"]),
            } mutableCopy];
            if (ctx[@"bizCode"]) payload[@"rpcBusinessCode"] = ctx[@"bizCode"];
            if (note) payload[@"proxyAssessmentNote"] = note;
            FQXDiagRecordEvent(FQXDiagCategoryNetwork, @"network_request", payload, important);
        }
    }
    if (gOrigBDRpcComplete) gOrigBDRpcComplete(self, cmd);
}

// Weak background watcher for TTNet TTHttpTask / delegate-mode NSURLSessionTask completion
@interface FQXWatchedNetworkTask : NSObject {
@public
    __weak id task;
    NSString *transport;
    NSString *requestId;
    NSString *domain;
    NSString *path;
    NSArray<NSString *> *queryKeys;
    NSString *httpMethod;
    CFTimeInterval startMono;
    BOOL finalized;
}
@end

@implementation FQXWatchedNetworkTask
@end

static NSMutableArray<FQXWatchedNetworkTask *> *gFQXWatchedTasks = nil;
static BOOL gFQXWatcherScheduled = NO;

static void FQXFinalizeWatchedTaskOnQueue(FQXWatchedNetworkTask *entry, id strongTask, BOOL forceTimeoutCheck) {
    if (!entry || entry->finalized) return;
    id errObj = strongTask ? FQXSafeObjMsg0(strongTask, "error") : nil;
    NSError *err = [errObj isKindOfClass:NSError.class] ? (NSError *)errObj : nil;
    id respObj = strongTask ? FQXSafeObjMsg0(strongTask, "response") : nil;
    BOOL hasStatus = NO;
    NSInteger statusCode = FQXSafeIntMsg0(respObj, "statusCode", &hasStatus);
    if (!hasStatus) statusCode = FQXSafeIntMsg0(respObj, "httpStatusCode", &hasStatus);
    if (statusCode < 0) statusCode = 0;

    BOOL hasState = NO;
    NSInteger state = strongTask ? FQXSafeIntMsg0(strongTask, "state", &hasState) : 3;
    BOOL done = (!strongTask) || (err != nil) || (statusCode > 0) || (hasState && (state == 2 || state == 3));
    double durMs = (CACurrentMediaTime() - entry->startMono) * 1000.0;
    if (!done && !(forceTimeoutCheck && durMs > 18000.0)) {
        return;
    }

    entry->finalized = YES;
    BOOL cancelled = (hasState && state == 2) ||
                     (err && [err.domain isEqualToString:NSURLErrorDomain] && err.code == NSURLErrorCancelled);
    NSString *source = nil;
    BOOL isTimeout = NO, isConnFail = NO;
    NSString *note = nil;
    FQXClassifyNetworkError(statusCode, err, cancelled, &source, &isTimeout, &isConnFail, &note);
    BOOL releasedBeforePoll = (!strongTask && !err && statusCode == 0);
    if (releasedBeforePoll) {
        source = @"task_released_before_poll";
    }
    NSString *stage = cancelled ? @"cancelled"
        : (releasedBeforePoll ? @"released_unobserved"
           : ((err || statusCode >= 400) ? @"failed" : @"returned"));

    FQXRecordRecentFailureSummary(entry->domain, entry->path, stage, statusCode, err, source);
    NSMutableDictionary<NSString *, id> *payload = [@{
        @"transport": entry->transport ?: @"HTTP",
        @"requestId": entry->requestId ?: @"",
        @"domain": entry->domain ?: @"unknown",
        @"path": entry->path ?: @"/",
        @"queryKeys": entry->queryKeys ?: @[],
        @"httpMethod": entry->httpMethod ?: @"GET",
        @"stage": stage,
        @"statusCode": @(statusCode),
        @"durationMs": @(round(durMs * 10.0) / 10.0),
        @"errorDomain": err.domain ?: @"",
        @"errorCode": @(err ? err.code : 0),
        @"isRetry": @NO,
        @"isTimeout": @(isTimeout),
        @"isConnectionFailure": @(isConnFail),
        @"interceptSource": source ?: @"ok",
        @"isMonitoredSnssdk": @([entry->domain isEqualToString:@"is.snssdk.com"]),
    } mutableCopy];
    if (note) payload[@"proxyAssessmentNote"] = note;
    BOOL important = !releasedBeforePoll || [entry->domain isEqualToString:@"is.snssdk.com"];
    FQXDiagRecordEvent(FQXDiagCategoryNetwork, @"network_request", payload, important);
}

static void FQXScheduleWatchedTasksPollOnQueue(void) {
    if (gFQXWatcherScheduled || !gFQXWatchedTasks.count) return;
    gFQXWatcherScheduled = YES;
    CFTimeInterval now = CACurrentMediaTime();
    BOOL hasYoungTask = NO;
    for (FQXWatchedNetworkTask *item in gFQXWatchedTasks) {
        if ((now - item->startMono) < 1.2) {
            hasYoungTask = YES;
            break;
        }
    }
    int64_t delayMs = hasYoungTask ? 120 : 450;
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, delayMs * NSEC_PER_MSEC), FQXHubQueue(), ^{
        gFQXWatcherScheduled = NO;
        for (NSInteger i = (NSInteger)gFQXWatchedTasks.count - 1; i >= 0; --i) {
            FQXWatchedNetworkTask *item = gFQXWatchedTasks[(NSUInteger)i];
            id strong = item->task;
            FQXFinalizeWatchedTaskOnQueue(item, strong, YES);
            if (item->finalized) {
                [gFQXWatchedTasks removeObjectAtIndex:(NSUInteger)i];
            }
        }
        if (gFQXWatchedTasks.count > 0) {
            FQXScheduleWatchedTasksPollOnQueue();
        }
    });
}

static void FQXObserveGenericHttpTaskStart(id task, NSString *transport) {
    if (!task || !FQXDiagnosticsHubIsEnabled()) return;
    if (objc_getAssociatedObject(task, kFQXTaskTrackKey)) return;

    id req = FQXSafeObjMsg0(task, "currentRequest")
        ?: FQXSafeObjMsg0(task, "originalRequest")
        ?: FQXSafeObjMsg0(task, "request");
    id urlObj = FQXSafeObjMsg0(req, "URL")
        ?: FQXSafeObjMsg0(req, "url")
        ?: FQXSafeObjMsg0(task, "URL")
        ?: FQXSafeObjMsg0(task, "url");
    if (!urlObj) return;

    NSString *domain = nil, *path = nil;
    NSArray<NSString *> *queryKeys = nil;
    FQXSanitizeURLInfo(urlObj, &domain, &path, &queryKeys);
    BOOL important = FQXPathLooksCritical(domain, path);
    if (!important && !FQXDiagnosticsHubIsEnhanced()) return;

    id methodCand = FQXSafeObjMsg0(req, "HTTPMethod") ?: FQXSafeObjMsg0(req, "httpMethod");
    NSString *httpMethod = ([methodCand isKindOfClass:NSString.class] && [(NSString *)methodCand length])
        ? [(NSString *)methodCand uppercaseString] : @"GET";
    NSString *reqId = FQXNextNetReqId();

    FQXWatchedNetworkTask *watch = [[FQXWatchedNetworkTask alloc] init];
    watch->task = task;
    watch->transport = [transport copy];
    watch->requestId = [reqId copy];
    watch->domain = [domain copy];
    watch->path = [path copy];
    watch->queryKeys = [queryKeys copy];
    watch->httpMethod = [httpMethod copy];
    watch->startMono = CACurrentMediaTime();
    objc_setAssociatedObject(task, kFQXTaskTrackKey, watch, OBJC_ASSOCIATION_RETAIN_NONATOMIC);

    FQXRecordRecentFailureSummary(domain, path, @"issued", 0, nil, @"issued");
    FQXDiagRecordEvent(FQXDiagCategoryNetwork, @"network_request", @{
        @"transport": transport,
        @"requestId": reqId,
        @"domain": domain,
        @"path": path,
        @"queryKeys": queryKeys ?: @[],
        @"httpMethod": httpMethod,
        @"stage": @"issued",
        @"isRetry": @NO,
        @"isMonitoredSnssdk": @([domain isEqualToString:@"is.snssdk.com"]),
    }, important);

    __weak id weakTask = task;
    dispatch_async(FQXHubQueue(), ^{
        if (!gFQXWatchedTasks) gFQXWatchedTasks = [NSMutableArray arrayWithCapacity:32];
        if (gFQXWatchedTasks.count < 128 && !watch->finalized) {
            watch->task = weakTask;
            [gFQXWatchedTasks addObject:watch];
            FQXScheduleWatchedTasksPollOnQueue();
        }
    });
}

static void FQXObserveGenericHttpTaskCancel(id task) {
    FQXWatchedNetworkTask *watch = objc_getAssociatedObject(task, kFQXTaskTrackKey);
    if (!watch || watch->finalized || !FQXDiagnosticsHubIsEnabled()) return;
    watch->finalized = YES;
    double durMs = (CACurrentMediaTime() - watch->startMono) * 1000.0;
    FQXRecordRecentFailureSummary(watch->domain, watch->path, @"cancelled", 0, nil, @"cancelled");
    FQXDiagRecordEvent(FQXDiagCategoryNetwork, @"network_request", @{
        @"transport": watch->transport ?: @"HTTP",
        @"requestId": watch->requestId ?: @"",
        @"domain": watch->domain ?: @"unknown",
        @"path": watch->path ?: @"/",
        @"httpMethod": watch->httpMethod ?: @"GET",
        @"stage": @"cancelled",
        @"statusCode": @0,
        @"durationMs": @(round(durMs * 10.0) / 10.0),
        @"isRetry": @NO,
        @"isTimeout": @NO,
        @"isConnectionFailure": @NO,
        @"interceptSource": @"cancelled",
        @"isMonitoredSnssdk": @([watch->domain isEqualToString:@"is.snssdk.com"]),
    }, YES);
}

typedef void (^FQXURLSessionCompletionBlock)(NSData *data, NSURLResponse *response, NSError *error);
static id (*gOrigURLSessionDataReq)(id, SEL, NSURLRequest *, FQXURLSessionCompletionBlock) = NULL;

static id FQXHookURLSessionDataTaskWithRequest(id self,
                                               SEL cmd,
                                               NSURLRequest *request,
                                               FQXURLSessionCompletionBlock completionHandler) {
    // CRITICAL: Never substitute a non-nil block when completionHandler is nil,
    // otherwise delegate-driven NSURLSession streaming tasks would switch to block mode!
    if (!completionHandler || !FQXDiagnosticsHubIsEnabled() || ![request isKindOfClass:NSURLRequest.class]) {
        id rawTask = gOrigURLSessionDataReq ? gOrigURLSessionDataReq(self, cmd, request, completionHandler) : nil;
        if (rawTask && !completionHandler) {
            FQXObserveGenericHttpTaskStart(rawTask, @"NSURLSessionDelegate");
        }
        return rawTask;
    }

    NSString *domain = nil, *path = nil;
    NSArray<NSString *> *queryKeys = nil;
    FQXSanitizeURLInfo(request.URL, &domain, &path, &queryKeys);
    BOOL important = FQXPathLooksCritical(domain, path);
    if (!important && !FQXDiagnosticsHubIsEnhanced()) {
        return gOrigURLSessionDataReq ? gOrigURLSessionDataReq(self, cmd, request, completionHandler) : nil;
    }

    NSString *reqId = FQXNextNetReqId();
    NSString *httpMethod = request.HTTPMethod.length ? request.HTTPMethod.uppercaseString : @"GET";
    CFTimeInterval startMono = CACurrentMediaTime();

    FQXRecordRecentFailureSummary(domain, path, @"issued", 0, nil, @"issued");
    FQXDiagRecordEvent(FQXDiagCategoryNetwork, @"network_request", @{
        @"transport": @"NSURLSession",
        @"requestId": reqId,
        @"domain": domain,
        @"path": path,
        @"queryKeys": queryKeys ?: @[],
        @"httpMethod": httpMethod,
        @"stage": @"issued",
        @"isRetry": @NO,
        @"isMonitoredSnssdk": @([domain isEqualToString:@"is.snssdk.com"]),
    }, important);

    FQXURLSessionCompletionBlock wrapped = ^(NSData *data, NSURLResponse *response, NSError *error) {
        if (FQXDiagnosticsHubIsEnabled()) {
            NSInteger statusCode = [response isKindOfClass:NSHTTPURLResponse.class]
                ? ((NSHTTPURLResponse *)response).statusCode : (error ? 0 : 200);
            double durMs = (CACurrentMediaTime() - startMono) * 1000.0;
            BOOL cancelled = (error && [error.domain isEqualToString:NSURLErrorDomain] && error.code == NSURLErrorCancelled);
            NSString *source = nil;
            BOOL isTimeout = NO, isConnFail = NO;
            NSString *note = nil;
            FQXClassifyNetworkError(statusCode, error, cancelled, &source, &isTimeout, &isConnFail, &note);
            NSString *stage = cancelled ? @"cancelled" : ((error || statusCode >= 400) ? @"failed" : @"returned");
            FQXRecordRecentFailureSummary(domain, path, stage, statusCode, error, source);

            NSMutableDictionary<NSString *, id> *payload = [@{
                @"transport": @"NSURLSession",
                @"requestId": reqId,
                @"domain": domain,
                @"path": path,
                @"queryKeys": queryKeys ?: @[],
                @"httpMethod": httpMethod,
                @"stage": stage,
                @"statusCode": @(statusCode),
                @"durationMs": @(round(durMs * 10.0) / 10.0),
                @"errorDomain": error.domain ?: @"",
                @"errorCode": @(error ? error.code : 0),
                @"isRetry": @NO,
                @"isTimeout": @(isTimeout),
                @"isConnectionFailure": @(isConnFail),
                @"interceptSource": source ?: @"ok",
                @"isMonitoredSnssdk": @([domain isEqualToString:@"is.snssdk.com"]),
            } mutableCopy];
            if (note) payload[@"proxyAssessmentNote"] = note;
            FQXDiagRecordEvent(FQXDiagCategoryNetwork, @"network_request", payload, YES);
        }
        completionHandler(data, response, error);
    };

    id task = gOrigURLSessionDataReq ? gOrigURLSessionDataReq(self, cmd, request, wrapped) : nil;
    if (task) {
        // Mark so generic task watcher does not duplicate this block-tracked task.
        objc_setAssociatedObject(task, kFQXTaskTrackKey, @YES, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
    }
    return task;
}

static void InstallNetworkDiagnosticsHooks(void) {
    Class rpcOp = objc_lookUpClass("BDRpcAsyncOperation");
    if (rpcOp) {
        FQXDiagInstallOwnedHook(rpcOp, "BDRpcAsyncOperation", sel_registerName("initWithRequest:completion:"),
                                NO, "@32@0:8@16@?24", "diag.net.bdrpc.init", (IMP)FQXHookBDRpcInit, (IMP *)&gOrigBDRpcInit);
        FQXDiagInstallOwnedHook(rpcOp, "BDRpcAsyncOperation", sel_registerName("sendRequest"),
                                NO, "v16@0:8", "diag.net.bdrpc.send", (IMP)FQXHookBDRpcSend, (IMP *)&gOrigBDRpcSend);
        FQXDiagInstallOwnedHook(rpcOp, "BDRpcAsyncOperation", sel_registerName("cancel"),
                                NO, "v16@0:8", "diag.net.bdrpc.cancel", (IMP)FQXHookBDRpcCancel, (IMP *)&gOrigBDRpcCancel);
        FQXDiagInstallOwnedHook(rpcOp, "BDRpcAsyncOperation", sel_registerName("_postHandleResult:headerFields:"),
                                NO, "v32@0:8@16@24", "diag.net.bdrpc.parse", (IMP)FQXHookBDRpcPostHandle, (IMP *)&gOrigBDRpcPostHandle);
        FQXDiagInstallOwnedHook(rpcOp, "BDRpcAsyncOperation", sel_registerName("completeOperation"),
                                NO, "v16@0:8", "diag.net.bdrpc.complete", (IMP)FQXHookBDRpcComplete, (IMP *)&gOrigBDRpcComplete);
    }

    // Hook TTNet task classes if present in host binary
    static const char *const kTTClasses[] = {"TTHttpTaskChromium", "TTHttpTask", NULL};
    for (int i = 0; kTTClasses[i]; ++i) {
        const char *clsCStr = kTTClasses[i];
        Class ttCls = objc_lookUpClass(clsCStr);
        if (!ttCls) continue;
        NSString *clsName = [NSString stringWithUTF8String:clsCStr];
        SEL resumeSel = sel_registerName("resume");
        __block IMP origResume = NULL;
        IMP resumeHook = imp_implementationWithBlock(^(id task) {
            FQXObserveGenericHttpTaskStart(task, clsName);
            if (origResume) ((void (*)(id, SEL))origResume)(task, resumeSel);
        });
        if (!FQXInstallOwnedHook(ttCls, resumeSel, NO, "v16@0:8", resumeHook, &origResume)) {
            imp_removeBlock(resumeHook);
        }
        SEL cancelSel = sel_registerName("cancel");
        __block IMP origCancel = NULL;
        IMP cancelHook = imp_implementationWithBlock(^(id task) {
            FQXObserveGenericHttpTaskCancel(task);
            if (origCancel) ((void (*)(id, SEL))origCancel)(task, cancelSel);
        });
        if (!FQXInstallOwnedHook(ttCls, cancelSel, NO, "v16@0:8", cancelHook, &origCancel)) {
            imp_removeBlock(cancelHook);
        }
    }

    Class sessionCls = objc_lookUpClass("__NSURLSessionLocal") ?: NSURLSession.class;
    FQXInstallOwnedHook(sessionCls,
                        @selector(dataTaskWithRequest:completionHandler:),
                        NO,
                        "@32@0:8@16@?24",
                        (IMP)FQXHookURLSessionDataTaskWithRequest,
                        (IMP *)&gOrigURLSessionDataReq);
}

#pragma mark - Collector 2: Hook Interceptions (2.2)

void FQXDiagRecordHook(const char *hostClass,
                       const char *selector,
                       const char *ruleName,
                       const char *reason,
                       const char *outcome,
                       double durationMs) {
    if (!FQXDiagnosticsHubIsEnabled()) return;
    NSString *clsStr = hostClass ? [NSString stringWithUTF8String:hostClass] : @"Unknown";
    NSString *selStr = selector ? [NSString stringWithUTF8String:selector] : @"unknown";
    NSString *ruleStr = ruleName ? [NSString stringWithUTF8String:ruleName] : @"rule";
    NSString *reasonStr = reason ? [NSString stringWithUTF8String:reason] : @"";
    NSString *outStr = outcome ? [NSString stringWithUTF8String:outcome] : @"allowed";

    BOOL isFailure = [outStr isEqualToString:@"failed"];
    NSUInteger count = 1;
    NSString *counterKey = [NSString stringWithFormat:@"%@|%@|%@", ruleStr, selStr, outStr];

    os_unfair_lock_lock(&gFQXHookCountLock);
    if (!gFQXHookCallCounts) gFQXHookCallCounts = [NSMutableDictionary dictionaryWithCapacity:128];
    count = [gFQXHookCallCounts[counterKey] unsignedIntegerValue] + 1;
    gFQXHookCallCounts[counterKey] = @(count);
    os_unfair_lock_unlock(&gFQXHookCountLock);

    NSUInteger sampleMask = FQXDiagnosticsHubIsEnhanced() ? 15 : 63;
    if (!isFailure && count > 2 && ((count & sampleMask) != 0)) {
        return;
    }

    FQXDiagRecordEvent(FQXDiagCategoryHook, @"hook_interception", @{
        @"hostClass": clsStr,
        @"selector": selStr,
        @"ruleName": ruleStr,
        @"reason": reasonStr,
        @"result": outStr, // blocked | allowed | skipped | failed
        @"callCount": @(count),
        @"durationMs": @(round(durationMs * 1000.0) / 1000.0),
    }, isFailure);
}

BOOL FQXDiagInstallOwnedHook(Class target,
                             const char *hostClassName,
                             SEL selector,
                             BOOL classMethod,
                             const char *expectedEncoding,
                             const char *ruleName,
                             IMP replacement,
                             IMP *original) {
    const char *selName = selector ? sel_getName(selector) : "unknown";
    if (!target) {
        if (FQXDiagnosticsHubIsEnhanced()) {
            FQXDiagRecordHook(hostClassName ?: "MissingClass", selName, ruleName ?: "hook.install",
                              "host_class_absent_in_binary", "skipped", 0.0);
        }
        return NO;
    }
    CFTimeInterval t0 = CACurrentMediaTime();
    BOOL ok = FQXInstallOwnedHook(target, selector, classMethod, expectedEncoding, replacement, original);
    double dt = (CACurrentMediaTime() - t0) * 1000.0;
    if (!ok) {
        FQXDiagRecordHook(hostClassName ?: class_getName(target), selName, ruleName ?: "hook.install",
                          "signature_mismatch_or_duplicate_owner", "failed", dt);
    }
    return ok;
}

#pragma mark - Collector 3 & 4: View Lifecycle & TTS Paragraph Positioning (2.3, 2.4 & Part IV)

static const char FQXK_kFQXEntranceViewGenKey = 0;
#define kFQXEntranceViewGenKey ((const void *)&FQXK_kFQXEntranceViewGenKey)
static _Atomic uint64_t gFQXParaViewCreatedTotal = 0;
static _Atomic uint64_t gFQXParaViewHiddenByHostCount = 0;
static _Atomic uint64_t gFQXParaViewRemovedCount = 0;

static NSArray<NSNumber *> *FQXRectArray(CGRect r) {
    return @[
        @(round(r.origin.x * 10.0) / 10.0),
        @(round(r.origin.y * 10.0) / 10.0),
        @(round(r.size.width * 10.0) / 10.0),
        @(round(r.size.height * 10.0) / 10.0),
    ];
}

static void FQXEmitEntranceViewLifecycle(UIView *view,
                                         NSString *lifecycleAction,
                                         const char *entryMethod,
                                         BOOL highPriority) {
    if (!view || !FQXDiagnosticsHubIsEnabled()) return;
    FQXPluginReasonFrame pluginReason = FQXCurrentPluginReason();
    NSNumber *gen = objc_getAssociatedObject(view, kFQXEntranceViewGenKey);
    UIView *sup = view.superview;
    NSMutableDictionary<NSString *, id> *payload = [@{
        @"viewClass": NSStringFromClass(view.class) ?: @"UIView",
        @"instanceRef": FQXDiagPseudonymize([NSString stringWithFormat:@"%p", (void *)view]),
        @"generation": gen ?: @0,
        @"action": lifecycleAction,
        @"hidden": @(view.isHidden),
        @"alpha": @(round(view.alpha * 100.0) / 100.0),
        @"frame": FQXRectArray(view.frame),
        @"hasSuperview": @(sup != nil),
        @"superviewClass": sup ? (NSStringFromClass(sup.class) ?: @"UIView") : @"",
        @"inWindow": @(view.window != nil),
        @"entryMethod": entryMethod ? [NSString stringWithUTF8String:entryMethod] : @"",
        @"initiatedByPlugin": @(pluginReason.reason != NULL),
        @"pluginReason": pluginReason.reason ? [NSString stringWithUTF8String:pluginReason.reason] : @"",
        @"pluginCaller": pluginReason.caller ? [NSString stringWithUTF8String:pluginReason.caller] : @"",
    } mutableCopy];
    FQXDiagRecordEvent(FQXDiagCategoryView, @"view_lifecycle", payload, highPriority);
}

static NSUInteger FQXCountVisibleSubtreeClass(UIView *root, Class cls, NSUInteger *outTotal, NSInteger depth) {
    if (!root || !cls || depth > 9) return 0;
    NSUInteger vis = 0;
    if ([root isKindOfClass:cls]) {
        if (outTotal) *outTotal += 1;
        if (!root.isHidden && root.alpha > 0.02 && CGRectGetWidth(root.bounds) > 1.0 && CGRectGetHeight(root.bounds) > 1.0) {
            vis += 1;
        }
    }
    for (UIView *sub in root.subviews) {
        vis += FQXCountVisibleSubtreeClass(sub, cls, outTotal, depth + 1);
    }
    return vis;
}

static NSInteger FQXExtractParagraphIndexFromObject(id obj) {
    if (!obj) return -1;
    const char *candidates[] = {
        "paraIndex", "paragraphIndex", "curParaIndex", "currentParagraphIndex",
        "playingParaIndex", "sentenceIndex", "index", "startParaIndex", NULL
    };
    for (int i = 0; candidates[i]; ++i) {
        BOOL found = NO;
        NSInteger val = FQXSafeIntMsg0(obj, candidates[i], &found);
        if (found && val >= 0 && val < 1000000) return val;
    }
    // Check nested point/chapter info if present
    id inner = FQXSafeObjMsg0(obj, "readerPoint")
        ?: FQXSafeObjMsg0(obj, "playPosition")
        ?: FQXSafeObjMsg0(obj, "currentLineInfo");
    if (inner && inner != obj) {
        for (int i = 0; candidates[i]; ++i) {
            BOOL found = NO;
            NSInteger val = FQXSafeIntMsg0(inner, candidates[i], &found);
            if (found && val >= 0 && val < 1000000) return val;
        }
    }
    return -1;
}

static NSString *FQXPlaybackStateName(id sdkManager, id playManager) {
    BOOL found = NO;
    if (sdkManager) {
        if (FQXSafeBoolMsg0(sdkManager, "loading", &found) && found) return @"loading";
        if (FQXSafeBoolMsg0(sdkManager, "playing", &found) && found) return @"playing";
        if (FQXSafeBoolMsg0(sdkManager, "paused", &found) && found) return @"paused";
        if (FQXSafeBoolMsg0(sdkManager, "audioStopped", &found) && found) return @"stopped";
    }
    if (playManager) {
        if (FQXSafeBoolMsg0(playManager, "playIsStopped", &found) && found) return @"stopped";
        if (FQXSafeObjMsg0(playManager, "playInfo") != nil) return @"ready_or_active";
    }
    return @"idle";
}

void FQXDiagRecordReaderTTSCheck(id ttsMgr,
                                 id paraMgr,
                                 id readerMgr,
                                 const char *trigger) {
    if (!FQXDiagnosticsHubIsEnabled()) return;
    id effectiveReaderMgr = readerMgr
        ?: FQXSafeObjMsg0(paraMgr, "readerManager")
        ?: FQXSafeObjMsg0(ttsMgr, "readerMgr")
        ?: FQXSafeObjMsg0(ttsMgr, "readerManager");
    id bookId = FQXSafeObjMsg0(paraMgr, "bookId")
        ?: FQXSafeObjMsg0(effectiveReaderMgr, "bookId")
        ?: FQXSafeObjMsg0(FQXSafeObjMsg0(effectiveReaderMgr, "readerModel"), "bookId");
    id chapterInfo = FQXSafeObjMsg0(effectiveReaderMgr, "currentChapterInfo")
        ?: FQXSafeObjMsg0(effectiveReaderMgr, "chapterInfo");
    id chapterId = FQXSafeObjMsg0(chapterInfo, "chapterId")
        ?: FQXSafeObjMsg0(effectiveReaderMgr, "currentChapterId");

    BOOL bookValid = ([bookId isKindOfClass:NSString.class] && [(NSString *)bookId length] > 0) ||
                     ([bookId isKindOfClass:NSNumber.class] && [(NSNumber *)bookId longLongValue] > 0);
    BOOL chapterValid = ([chapterId isKindOfClass:NSString.class] && [(NSString *)chapterId length] > 0) ||
                        ([chapterId isKindOfClass:NSNumber.class] && [(NSNumber *)chapterId longLongValue] > 0) ||
                        (chapterInfo != nil);

    // Probe boolean feature flags on SSReaderTTSParaEntranceManager (instance or class-level gates)
    NSMutableDictionary<NSString *, id> *paraFlags = [NSMutableDictionary dictionary];
    if (paraMgr) {
        const char *flagNames[] = {
            "enable", "isEnable", "isEnabled", "paraEntranceEnable",
            "canShowParaEntrance", "shouldShowParaEntrance", "hasConfig", NULL
        };
        for (int i = 0; flagNames[i]; ++i) {
            BOOL found = NO;
            BOOL v = FQXSafeBoolMsg0(paraMgr, flagNames[i], &found);
            if (found) paraFlags[[NSString stringWithUTF8String:flagNames[i]]] = @(v);
        }
    }
    Class paraMgrCls = objc_lookUpClass("SSReaderTTSParaEntranceManager");
    if (paraMgrCls) {
        Class meta = object_getClass(paraMgrCls);
        unsigned int mc = 0;
        Method *mlist = class_copyMethodList(meta, &mc);
        for (unsigned int i = 0; i < mc && paraFlags.count < 16; ++i) {
            SEL s = method_getName(mlist[i]);
            const char *sname = sel_getName(s);
            const char *enc = method_getTypeEncoding(mlist[i]);
            if (!sname || !enc || strcmp(enc, "B16@0:8") != 0) continue;
            if (strstr(sname, "enable") || strstr(sname, "Enable") ||
                strstr(sname, "show") || strstr(sname, "Show") ||
                strstr(sname, "can") || strstr(sname, "Can") ||
                strstr(sname, "open") || strstr(sname, "Open") ||
                strstr(sname, "para") || strstr(sname, "Para")) {
                BOOL v = ((BOOL (*)(id, SEL))objc_msgSend)(paraMgrCls, s);
                paraFlags[[NSString stringWithFormat:@"+%s", sname]] = @(v);
            }
        }
        free(mlist);
    }

    NSUInteger totalArrows = 0;
    NSUInteger visibleArrows = 0;
    id rvc = FQXSafeObjMsg0(paraMgr, "readerVC") ?: FQXSafeObjMsg0(effectiveReaderMgr, "readerVC");
    BOOL vcLoaded = FQXSafeBoolMsg0(rvc, "isViewLoaded", NULL);
    UIView *rview = vcLoaded ? FQXSafeObjMsg0(rvc, "view") : nil;
    Class arrowCls = objc_lookUpClass("SSReaderTTSParagraphEntranceView");
    if ([rview isKindOfClass:UIView.class] && arrowCls) {
        visibleArrows = FQXCountVisibleSubtreeClass(rview, arrowCls, &totalArrows, 0);
    }

    NSInteger curPara = FQXExtractParagraphIndexFromObject(ttsMgr);
    if (curPara < 0) curPara = FQXExtractParagraphIndexFromObject(paraMgr);

    FQXDiagRecordEvent(FQXDiagCategoryTTS, @"tts_paragraph_state", @{
        @"trigger": trigger ? [NSString stringWithUTF8String:trigger] : @"check",
        @"bookValid": @(bookValid),
        @"chapterValid": @(chapterValid),
        @"bookRef": FQXDiagPseudonymize(bookId),
        @"chapterRef": FQXDiagPseudonymize(chapterId),
        @"paraManagerPresent": @(paraMgr != nil),
        @"ttsManagerPresent": @(ttsMgr != nil),
        @"paraFeatureFlags": paraFlags,
        @"currentParagraphIndex": @(curPara),
        @"entranceViewTotalInReader": @(totalArrows),
        @"entranceViewVisibleInReader": @(visibleArrows),
        @"totalEntranceViewsCreatedSession": @(atomic_load_explicit(&gFQXParaViewCreatedTotal, memory_order_relaxed)),
        @"recentNetworkFailures": FQXRecentFailuresWithinSeconds(12.0),
    }, YES);
}

void FQXDiagRecordTTSPlaybackEvent(id sdkManager,
                                   id playManager,
                                   id positionObj,
                                   NSString *entrySource,
                                   const char *stage,
                                   BOOL scheduleFollowUp) {
    if (!FQXDiagnosticsHubIsEnabled()) return;
    id effPlayMgr = playManager ?: FQXSafeObjMsg0(sdkManager, "bdfqPlayManager");
    id bookId = FQXSafeObjMsg0(sdkManager, "currentBookId")
        ?: FQXSafeObjMsg0(FQXSafeObjMsg0(effPlayMgr, "playInfo"), "bookId");
    id chapterId = FQXSafeObjMsg0(sdkManager, "currentChapterId")
        ?: FQXSafeObjMsg0(FQXSafeObjMsg0(effPlayMgr, "playInfo"), "chapterId")
        ?: FQXSafeObjMsg0(positionObj, "chapterId");

    BOOL bookValid = ([bookId isKindOfClass:NSString.class] && [(NSString *)bookId length] > 0) ||
                     ([bookId isKindOfClass:NSNumber.class] && [(NSNumber *)bookId longLongValue] > 0);
    BOOL chapterValid = ([chapterId isKindOfClass:NSString.class] && [(NSString *)chapterId length] > 0) ||
                        ([chapterId isKindOfClass:NSNumber.class] && [(NSNumber *)chapterId longLongValue] > 0);

    NSInteger clickedPara = FQXExtractParagraphIndexFromObject(positionObj);
    NSInteger currentPara = FQXExtractParagraphIndexFromObject(sdkManager);
    if (currentPara < 0) currentPara = FQXExtractParagraphIndexFromObject(effPlayMgr);

    NSString *stateStr = FQXPlaybackStateName(sdkManager, effPlayMgr);

    FQXDiagRecordEvent(FQXDiagCategoryTTS, @"tts_playback_transition", @{
        @"stage": stage ? [NSString stringWithUTF8String:stage] : @"event",
        @"entrySource": entrySource ?: @"",
        @"bookValid": @(bookValid),
        @"chapterValid": @(chapterValid),
        @"bookRef": FQXDiagPseudonymize(bookId),
        @"chapterRef": FQXDiagPseudonymize(chapterId),
        @"positionObjectPresent": @(positionObj != nil),
        @"positionObjectClass": positionObj ? (NSStringFromClass([positionObj class]) ?: @"Object") : @"",
        @"clickedParagraphIndex": @(clickedPara),
        @"currentParagraphIndex": @(currentPara),
        @"playbackState": stateStr,
        @"recentNetworkFailures": FQXRecentFailuresWithinSeconds(10.0),
    }, YES);

    if (scheduleFollowUp && (sdkManager || effPlayMgr)) {
        __weak id weakSDK = sdkManager;
        __weak id weakPlay = effPlayMgr;
        NSString *savedEntry = [entrySource copy] ?: @"";
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1600 * NSEC_PER_MSEC)),
                       dispatch_get_main_queue(), ^{
            id strongSDK = weakSDK;
            id strongPlay = weakPlay;
            if (!strongSDK && !strongPlay) return;
            FQXDiagRecordTTSPlaybackEvent(strongSDK, strongPlay, nil, savedEntry,
                                          "post_click_verify_1600ms", NO);
        });
    }
}

static void InstallTTSAndViewLifecycleHooks(void) {
    Class arrowCls = objc_lookUpClass("SSReaderTTSParagraphEntranceView");
    if (arrowCls) {
        SEL initSel = @selector(initWithFrame:);
        __block IMP origInit = NULL;
        IMP initHook = imp_implementationWithBlock(^id(UIView *v, CGRect f) {
            UIView *res = origInit ? ((id (*)(id, SEL, CGRect))origInit)(v, initSel, f) : v;
            if (res) {
                uint64_t gen = atomic_fetch_add_explicit(&gFQXParaViewCreatedTotal, 1, memory_order_relaxed) + 1;
                objc_setAssociatedObject(res, kFQXEntranceViewGenKey, @(gen), OBJC_ASSOCIATION_RETAIN_NONATOMIC);
                FQXEmitEntranceViewLifecycle(res, (gen > 1 ? @"created_or_recreated" : @"created"),
                                             "initWithFrame:", YES);
            }
            return res;
        });
        if (!FQXDiagInstallOwnedHook(arrowCls, "SSReaderTTSParagraphEntranceView", initSel, NO,
                                     "@48@0:8{CGRect={CGPoint=dd}{CGSize=dd}}16",
                                     "diag.view.ttsArrow.init", initHook, &origInit)) {
            imp_removeBlock(initHook);
        }

        SEL moveSupSel = @selector(didMoveToSuperview);
        __block IMP origMoveSup = NULL;
        IMP moveSupHook = imp_implementationWithBlock(^(UIView *v) {
            if (origMoveSup) ((void (*)(id, SEL))origMoveSup)(v, moveSupSel);
            FQXEmitEntranceViewLifecycle(v, v.superview ? @"attached_superview" : @"detached_superview",
                                         "didMoveToSuperview", NO);
        });
        if (!FQXInstallOwnedHook(arrowCls, moveSupSel, NO, "v16@0:8", moveSupHook, &origMoveSup)) {
            imp_removeBlock(moveSupHook);
        }

        SEL moveWinSel = @selector(didMoveToWindow);
        __block IMP origMoveWin = NULL;
        IMP moveWinHook = imp_implementationWithBlock(^(UIView *v) {
            if (origMoveWin) ((void (*)(id, SEL))origMoveWin)(v, moveWinSel);
            FQXEmitEntranceViewLifecycle(v, v.window ? @"shown_in_window" : @"left_window",
                                         "didMoveToWindow", NO);
        });
        if (!FQXInstallOwnedHook(arrowCls, moveWinSel, NO, "v16@0:8", moveWinHook, &origMoveWin)) {
            imp_removeBlock(moveWinHook);
        }

        SEL remSel = @selector(removeFromSuperview);
        __block IMP origRem = NULL;
        IMP remHook = imp_implementationWithBlock(^(UIView *v) {
            atomic_fetch_add_explicit(&gFQXParaViewRemovedCount, 1, memory_order_relaxed);
            FQXEmitEntranceViewLifecycle(v, @"removed", "removeFromSuperview", YES);
            if (origRem) ((void (*)(id, SEL))origRem)(v, remSel);
        });
        if (!FQXInstallOwnedHook(arrowCls, remSel, NO, "v16@0:8", remHook, &origRem)) {
            imp_removeBlock(remHook);
        }

        SEL hidSel = @selector(setHidden:);
        __block IMP origHid = NULL;
        IMP hidHook = imp_implementationWithBlock(^(UIView *v, BOOL hidden) {
            BOOL prev = v.isHidden;
            if (origHid) ((void (*)(id, SEL, BOOL))origHid)(v, hidSel, hidden);
            if (prev != hidden) {
                if (hidden && FQXCurrentPluginReason().reason == NULL) {
                    atomic_fetch_add_explicit(&gFQXParaViewHiddenByHostCount, 1, memory_order_relaxed);
                }
                FQXEmitEntranceViewLifecycle(v, hidden ? @"hidden" : @"shown", "setHidden:", hidden);
            }
        });
        if (!FQXInstallOwnedHook(arrowCls, hidSel, NO, "v20@0:8B16", hidHook, &origHid)) {
            imp_removeBlock(hidHook);
        }

        SEL alphaSel = @selector(setAlpha:);
        __block IMP origAlpha = NULL;
        IMP alphaHook = imp_implementationWithBlock(^(UIView *v, CGFloat alpha) {
            CGFloat prev = v.alpha;
            if (origAlpha) ((void (*)(id, SEL, CGFloat))origAlpha)(v, alphaSel, alpha);
            if ((prev > 0.05 && alpha <= 0.05) || (prev <= 0.05 && alpha > 0.05)) {
                FQXEmitEntranceViewLifecycle(v, alpha <= 0.05 ? @"alpha_zeroed" : @"alpha_restored",
                                             "setAlpha:", YES);
            }
        });
        if (!FQXInstallOwnedHook(arrowCls, alphaSel, NO, "v24@0:8d16", alphaHook, &origAlpha)) {
            imp_removeBlock(alphaHook);
        }
    }

    Class paraMgrCls = objc_lookUpClass("SSReaderTTSParaEntranceManager");
    if (paraMgrCls) {
        const char *voidSelectors[] = {
            "applyToHidePlayAnchorViews",
            "removeReaderInsertViewIfNeeded",
            "cancelDelayHidePlayAnchor",
            NULL
        };
        for (int i = 0; voidSelectors[i]; ++i) {
            const char *selCStr = voidSelectors[i];
            SEL s = sel_registerName(selCStr);
            __block IMP origImp = NULL;
            IMP hookImp = imp_implementationWithBlock(^(id mgr) {
                FQXPluginReasonFrame pr = FQXCurrentPluginReason();
                FQXDiagRecordEvent(FQXDiagCategoryView, @"tts_para_manager_call", @{
                    @"managerClass": @"SSReaderTTSParaEntranceManager",
                    @"selector": [NSString stringWithUTF8String:selCStr],
                    @"initiatedByPlugin": @(pr.reason != NULL),
                    @"pluginReason": pr.reason ? [NSString stringWithUTF8String:pr.reason] : @"",
                    @"bookRef": FQXDiagPseudonymize(FQXSafeObjMsg0(mgr, "bookId")),
                }, YES);
                if (origImp) ((void (*)(id, SEL))origImp)(mgr, s);
            });
            if (!FQXInstallOwnedHook(paraMgrCls, s, NO, "v16@0:8", hookImp, &origImp)) {
                imp_removeBlock(hookImp);
            }
        }

        // Safely discover and observe click/tap/show methods on SSReaderTTSParaEntranceManager
        unsigned int mCount = 0;
        Method *methods = class_copyMethodList(paraMgrCls, &mCount);
        for (unsigned int i = 0; i < mCount; ++i) {
            SEL s = method_getName(methods[i]);
            const char *sname = sel_getName(s);
            const char *enc = method_getTypeEncoding(methods[i]);
            if (!sname || !enc) continue;
            BOOL isTapOrPlay = (strstr(sname, "Click") != NULL || strstr(sname, "Tap") != NULL ||
                                strstr(sname, "click") != NULL || strstr(sname, "tap") != NULL ||
                                strstr(sname, "startPlay") != NULL || strstr(sname, "playFrom") != NULL);
            if (!isTapOrPlay) continue;
            if (strcmp(enc, "v24@0:8@16") == 0) {
                __block IMP origTap = NULL;
                NSString *selStr = [NSString stringWithUTF8String:sname];
                IMP tapHook = imp_implementationWithBlock(^(id mgr, id arg) {
                    NSInteger clickedIdx = FQXExtractParagraphIndexFromObject(arg);
                    if (clickedIdx < 0) clickedIdx = FQXExtractParagraphIndexFromObject(mgr);
                    FQXDiagRecordEvent(FQXDiagCategoryTTS, @"tts_paragraph_click", @{
                        @"managerClass": @"SSReaderTTSParaEntranceManager",
                        @"selector": selStr,
                        @"argPresent": @(arg != nil),
                        @"argClass": arg ? (NSStringFromClass([arg class]) ?: @"Object") : @"",
                        @"clickedParagraphIndex": @(clickedIdx),
                        @"bookRef": FQXDiagPseudonymize(FQXSafeObjMsg0(mgr, "bookId")),
                    }, YES);
                    if (origTap) ((void (*)(id, SEL, id))origTap)(mgr, s, arg);
                });
                if (!FQXInstallOwnedHook(paraMgrCls, s, NO, "v24@0:8@16", tapHook, &origTap)) {
                    imp_removeBlock(tapHook);
                }
            }
        }
        free(methods);
    }
}

#pragma mark - Collector 5: Security Verification & WKWebView Diagnostics + Blank Recovery (Part III)

static _Atomic int gFQXActiveSecurityVerifyViews = 0;
static const char FQXK_kFQXVerifyWebViewObservedKey = 0;
#define kFQXVerifyWebViewObservedKey ((const void *)&FQXK_kFQXVerifyWebViewObservedKey)
static const char FQXK_kFQXVerifyWebViewReloadedKey = 0;
#define kFQXVerifyWebViewReloadedKey ((const void *)&FQXK_kFQXVerifyWebViewReloadedKey)
static const char FQXK_kFQXVerifyLastURLKey = 0;
#define kFQXVerifyLastURLKey ((const void *)&FQXK_kFQXVerifyLastURLKey)
static BOOL FQXClassNameIsSecurityVerification(NSString *clsName) {
    if (!clsName.length) return NO;
    return [clsName hasPrefix:@"BDTuring"] ||
           [clsName containsString:@"TuringVerify"] ||
           [clsName containsString:@"SharkVerify"] ||
           [clsName containsString:@"CaptchaVerify"] ||
           [clsName containsString:@"SecurityVerify"] ||
           [clsName containsString:@"PassportVerify"];
}

BOOL FQXDiagIsSecurityVerificationObject(id obj) {
    if (!obj) return NO;
    Class cls = object_getClass(obj);
    for (int depth = 0; cls && depth < 6; ++depth, cls = class_getSuperclass(cls)) {
        if (FQXClassNameIsSecurityVerification(NSStringFromClass(cls))) return YES;
    }
    return NO;
}

BOOL FQXDiagIsSecurityVerificationHierarchy(UIView *view) {
    UIResponder *cur = view;
    for (int depth = 0; cur && depth < 14; ++depth, cur = cur.nextResponder) {
        if (FQXDiagIsSecurityVerificationObject(cur)) return YES;
    }
    return NO;
}

BOOL FQXDiagHasActiveSecurityVerificationInWindows(void) {
    return atomic_load_explicit(&gFQXActiveSecurityVerifyViews, memory_order_relaxed) > 0;
}

static BOOL FQXProbeAccountLoggedIn(void) {
    const char *accountClasses[] = {"TTAccount", "BDUGAccount", "SSAccountManager", NULL};
    for (int i = 0; accountClasses[i]; ++i) {
        Class cls = objc_lookUpClass(accountClasses[i]);
        if (!cls) continue;
        SEL sharedSel = sel_registerName("sharedAccount");
        if (![cls respondsToSelector:sharedSel]) sharedSel = sel_registerName("sharedInstance");
        if (![cls respondsToSelector:sharedSel]) sharedSel = sel_registerName("defaultManager");
        if ([cls respondsToSelector:sharedSel]) {
            Method m = class_getClassMethod(cls, sharedSel);
            if (m && method_getNumberOfArguments(m) == 2 && method_getTypeEncoding(m)[0] == '@') {
                id mgr = ((id (*)(id, SEL))objc_msgSend)(cls, sharedSel);
                BOOL found = NO;
                BOOL login = FQXSafeBoolMsg0(mgr, "isLogin", &found);
                if (!found) login = FQXSafeBoolMsg0(mgr, "hasLogin", &found);
                if (found) return login;
            }
        }
    }
    return NO;
}

void FQXDiagRecordSecurityDialogCheck(id dialog,
                                      id contentView,
                                      const char *entryPoint,
                                      BOOL suppressedByPlugin) {
    if (!FQXDiagnosticsHubIsEnabled()) return;
    if (!FQXDiagIsSecurityVerificationObject(dialog) && !FQXDiagIsSecurityVerificationObject(contentView)) {
        return;
    }
    FQXDiagRecordEvent(FQXDiagCategorySecurity, @"security_verify_dialog", @{
        @"dialogClass": dialog ? (NSStringFromClass([dialog class]) ?: @"") : @"",
        @"contentViewClass": contentView ? (NSStringFromClass([contentView class]) ?: @"") : @"",
        @"entryPoint": entryPoint ? [NSString stringWithUTF8String:entryPoint] : @"",
        @"suppressedByPlugin": @(suppressedByPlugin),
        @"pluginPolicy": @"preserve_legitimate_verification",
        @"accountLoggedIn": @(FQXProbeAccountLoggedIn()),
        @"recentNetworkFailures": FQXRecentFailuresWithinSeconds(15.0),
    }, YES);
}

static void FQXInspectVerificationWebView(UIView *webView, NSString *stage, BOOL allowProcessCrashRecovery) {
    if (!webView || !FQXDiagnosticsHubIsEnabled()) return;
    id urlObj = FQXSafeObjMsg0(webView, "URL");
    NSString *domain = nil, *path = nil;
    NSArray<NSString *> *qKeys = nil;
    if (urlObj) {
        FQXSanitizeURLInfo(urlObj, &domain, &path, &qKeys);
        objc_setAssociatedObject(webView, kFQXVerifyLastURLKey, urlObj, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
    }
    BOOL isLoading = FQXSafeBoolMsg0(webView, "isLoading", NULL);
    double progress = FQXSafeDoubleMsg0(webView, "estimatedProgress", NULL);
    id titleObj = FQXSafeObjMsg0(webView, "title");
    BOOL titlePresent = ([titleObj isKindOfClass:NSString.class] && [(NSString *)titleObj length] > 0);
    id cfg = FQXSafeObjMsg0(webView, "configuration");
    id ucc = FQXSafeObjMsg0(cfg, "userContentController");

    BOOL recoveredTerminatedProcess = NO;
    NSURL *prevURL = objc_getAssociatedObject(webView, kFQXVerifyLastURLKey);
    // Only recover if WebContent process terminated (URL became nil while previously loaded, not loading, still on screen)
    if (allowProcessCrashRecovery && !urlObj && [prevURL isKindOfClass:NSURL.class] &&
        !isLoading && webView.window && !objc_getAssociatedObject(webView, kFQXVerifyWebViewReloadedKey)) {
        objc_setAssociatedObject(webView, kFQXVerifyWebViewReloadedKey, @YES, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
        SEL reloadSel = sel_registerName("reload");
        Method rm = class_getInstanceMethod(object_getClass(webView), reloadSel);
        if (rm && method_getNumberOfArguments(rm) == 2) {
            ((id (*)(id, SEL))objc_msgSend)(webView, reloadSel);
            recoveredTerminatedProcess = YES;
        } else {
            SEL loadReqSel = sel_registerName("loadRequest:");
            Method lm = class_getInstanceMethod(object_getClass(webView), loadReqSel);
            if (lm && method_getNumberOfArguments(lm) == 3) {
                NSURLRequest *req = [NSURLRequest requestWithURL:prevURL];
                ((id (*)(id, SEL, id))objc_msgSend)(webView, loadReqSel, req);
                recoveredTerminatedProcess = YES;
            }
        }
    }

    FQXDiagRecordEvent(FQXDiagCategorySecurity, @"security_verify_webview", @{
        @"stage": stage ?: @"inspect",
        @"webViewClass": NSStringFromClass(webView.class) ?: @"WKWebView",
        @"domain": domain ?: (prevURL.host.lowercaseString ?: @"none"),
        @"path": path ?: @"/",
        @"queryKeys": qKeys ?: @[],
        @"urlPresent": @(urlObj != nil),
        @"isLoading": @(isLoading),
        @"estimatedProgress": @(round(progress * 100.0) / 100.0),
        @"titlePresent": @(titlePresent),
        @"jsBridgeControllerPresent": @(ucc != nil),
        @"inWindow": @(webView.window != nil),
        @"frame": FQXRectArray(webView.frame),
        @"recoveredTerminatedWebProcess": @(recoveredTerminatedProcess),
        @"accountLoggedIn": @(FQXProbeAccountLoggedIn()),
        @"recentNetworkFailures": FQXRecentFailuresWithinSeconds(15.0),
    }, YES);
}

static void InstallSecurityVerificationHooks(void) {
    // Observe WKWebView dynamically (no link-time WebKit dependency needed)
    Class wkCls = objc_lookUpClass("WKWebView");
    if (wkCls) {
        SEL moveWinSel = @selector(didMoveToWindow);
        __block IMP origMoveWin = NULL;
        IMP moveWinHook = imp_implementationWithBlock(^(UIView *wv) {
            if (origMoveWin) ((void (*)(id, SEL))origMoveWin)(wv, moveWinSel);
            if (!FQXDiagIsSecurityVerificationHierarchy(wv)) return;
            if (wv.window) {
                FQXInspectVerificationWebView(wv, @"did_move_to_window", NO);
                if (!objc_getAssociatedObject(wv, kFQXVerifyWebViewObservedKey)) {
                    objc_setAssociatedObject(wv, kFQXVerifyWebViewObservedKey, @YES, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
                    __weak UIView *weakWV = wv;
                    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(2200 * NSEC_PER_MSEC)),
                                   dispatch_get_main_queue(), ^{
                        UIView *strongWV = weakWV;
                        if (strongWV && strongWV.window) {
                            FQXInspectVerificationWebView(strongWV, @"check_2200ms", YES);
                        }
                    });
                    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(5200 * NSEC_PER_MSEC)),
                                   dispatch_get_main_queue(), ^{
                        UIView *strongWV = weakWV;
                        if (strongWV && strongWV.window) {
                            FQXInspectVerificationWebView(strongWV, @"check_5200ms", YES);
                        }
                    });
                }
            } else {
                FQXInspectVerificationWebView(wv, @"dismissed_from_window", NO);
            }
        });
        if (!FQXInstallOwnedHook(wkCls, moveWinSel, NO, "v16@0:8", moveWinHook, &origMoveWin)) {
            imp_removeBlock(moveWinHook);
        }

        SEL loadReqSel = sel_registerName("loadRequest:");
        __block IMP origLoadReq = NULL;
        IMP loadReqHook = imp_implementationWithBlock(^id(UIView *wv, NSURLRequest *req) {
            if ([req isKindOfClass:NSURLRequest.class] && req.URL) {
                NSString *dom = nil, *p = nil;
                NSArray<NSString *> *qk = nil;
                FQXSanitizeURLInfo(req.URL, &dom, &p, &qk);
                if (FQXDiagIsSecurityVerificationHierarchy(wv) || FQXPathLooksCritical(dom, p)) {
                    objc_setAssociatedObject(wv, kFQXVerifyLastURLKey, req.URL, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
                    FQXDiagRecordEvent(FQXDiagCategorySecurity, @"security_verify_load_request", @{
                        @"webViewClass": NSStringFromClass(wv.class) ?: @"WKWebView",
                        @"domain": dom ?: @"unknown",
                        @"path": p ?: @"/",
                        @"queryKeys": qk ?: @[],
                        @"accountLoggedIn": @(FQXProbeAccountLoggedIn()),
                        @"recentNetworkFailures": FQXRecentFailuresWithinSeconds(15.0),
                    }, YES);
                }
            }
            return origLoadReq ? ((id (*)(id, SEL, id))origLoadReq)(wv, loadReqSel, req) : nil;
        });
        if (!FQXInstallOwnedHook(wkCls, loadReqSel, NO, "@24@0:8@16", loadReqHook, &origLoadReq)) {
            imp_removeBlock(loadReqHook);
        }
    }

    // Probe well-known BDTuring view/controller classes without scanning all 40,000 runtime classes synchronously
    static const char *const kTuringViewClasses[] = {
        "BDTuringVerifyView", "BDTuringWebView", "BDTuringPopView",
        "BDTuringLoginView", "BDTuringSMSVerifyView", "BDTuringQAVerifyView", NULL
    };
    for (int i = 0; kTuringViewClasses[i]; ++i) {
        Class tc = objc_lookUpClass(kTuringViewClasses[i]);
        if (!tc || ![tc isSubclassOfClass:UIView.class]) continue;
        NSString *cn = [NSString stringWithUTF8String:kTuringViewClasses[i]];
        SEL mw = @selector(didMoveToWindow);
        __block IMP origMW = NULL;
        IMP mwHook = imp_implementationWithBlock(^(UIView *v) {
            if (origMW) ((void (*)(id, SEL))origMW)(v, mw);
            if (v.window) {
                atomic_fetch_add_explicit(&gFQXActiveSecurityVerifyViews, 1, memory_order_relaxed);
            } else {
                int prev = atomic_fetch_sub_explicit(&gFQXActiveSecurityVerifyViews, 1, memory_order_relaxed);
                if (prev <= 1) atomic_store_explicit(&gFQXActiveSecurityVerifyViews, 0, memory_order_relaxed);
            }
            FQXDiagRecordEvent(FQXDiagCategorySecurity, @"security_verify_view_lifecycle", @{
                @"viewClass": cn,
                @"stage": v.window ? @"presented_in_window" : @"removed_from_window",
                @"frame": FQXRectArray(v.frame),
                @"hidden": @(v.isHidden),
                @"alpha": @(round(v.alpha * 100.0) / 100.0),
                @"accountLoggedIn": @(FQXProbeAccountLoggedIn()),
                @"recentNetworkFailures": FQXRecentFailuresWithinSeconds(15.0),
            }, YES);
        });
        if (!FQXInstallOwnedHook(tc, mw, NO, "v16@0:8", mwHook, &origMW)) {
            imp_removeBlock(mwHook);
        }
    }
}

#pragma mark - Hub Install & Export Category Merger

static void FQXArchiveLastSessionOnHubQueue(void);

void FQXDiagnosticsHubInstall(void) {
    static dispatch_once_t once;
    dispatch_once(&once, ^{
        FQXEnsureSessionSalt();
        FQXRefreshDiagPrefsFromDefaults();
        dispatch_async(FQXHubQueue(), ^{
            FQXArchiveLastSessionOnHubQueue();
            FQXDiagRecordCriticalEvent(FQXDiagCategorySecurity, @"diagnostic_session_start", @{});
        });
        [NSNotificationCenter.defaultCenter addObserverForName:NSUserDefaultsDidChangeNotification
                                                        object:nil
                                                         queue:nil
                                                    usingBlock:^(__unused NSNotification *note) {
            FQXRefreshDiagPrefsFromDefaults();
        }];
        [NSNotificationCenter.defaultCenter addObserverForName:UIApplicationWillResignActiveNotification
                                                        object:nil queue:nil usingBlock:^(__unused NSNotification *note) {
            FQXDiagRecordCriticalEvent(FQXDiagCategorySecurity, @"diagnostic_session_inactive", @{});
        }];
        [NSNotificationCenter.defaultCenter addObserverForName:UIApplicationDidEnterBackgroundNotification
                                                        object:nil
                                                         queue:nil
                                                    usingBlock:^(__unused NSNotification *note) {
            FQXDiagRecordCriticalEvent(FQXDiagCategorySecurity, @"diagnostic_session_background", @{});
            dispatch_async(FQXHubQueue(), ^{
                FQXFlushWriteBufferOnHubQueue();
                [gFQXHubRing removeAllObjects];
            });
        }];
        [NSNotificationCenter.defaultCenter addObserverForName:UIApplicationWillTerminateNotification
                                                        object:nil queue:nil usingBlock:^(__unused NSNotification *note) {
            FQXDiagRecordCriticalEvent(FQXDiagCategorySecurity, @"diagnostic_session_end", @{});
        }];
        [NSNotificationCenter.defaultCenter addObserverForName:UIApplicationDidReceiveMemoryWarningNotification
                                                        object:nil
                                                         queue:nil
                                                    usingBlock:^(__unused NSNotification *note) {
            os_unfair_lock_lock(&gFQXHookCountLock);
            [gFQXHookCallCounts removeAllObjects];
            os_unfair_lock_unlock(&gFQXHookCountLock);
            os_unfair_lock_lock(&gFQXRecentFailLock);
            [gFQXRecentNetFailures removeAllObjects];
            os_unfair_lock_unlock(&gFQXRecentFailLock);
            dispatch_async(FQXHubQueue(), ^{
                FQXFlushWriteBufferOnHubQueue();
                [gFQXHubRing removeAllObjects];
                [gFQXWatchedTasks removeAllObjects];
            });
        }];

        // Keep only lightweight network diagnostic hooks synchronous in dyld init.
        // Defer TTS method-list scans, WKWebView/BDTuring hooks, and host Account SDK
        // singleton probing until after UIApplicationMain boots so cold launch never stalls.
        InstallNetworkDiagnosticsHooks();

        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.55 * NSEC_PER_SEC)),
                       dispatch_get_main_queue(), ^{
            InstallTTSAndViewLifecycleHooks();
            InstallSecurityVerificationHooks();

            FQXDiagRecordEvent(FQXDiagCategorySecurity, @"diagnostics_hub_ready", @{
                @"enhanced": @(FQXDiagnosticsHubIsEnhanced()),
                @"accountLoggedIn": @(FQXProbeAccountLoggedIn()),
                @"hasBDTuringVerifyView": @(objc_lookUpClass("BDTuringVerifyView") != Nil),
                @"hasTTSParaEntranceManager": @(objc_lookUpClass("SSReaderTTSParaEntranceManager") != Nil),
                @"hasTTSParaEntranceView": @(objc_lookUpClass("SSReaderTTSParagraphEntranceView") != Nil),
                @"deferredInstall": @YES,
            }, YES);
        });
    });
}

static NSString *FQXClassifyCoreEntryCategory(NSDictionary<NSString *, id> *entry) {
    NSString *existing = entry[@"category"];
    if ([existing isKindOfClass:NSString.class] && existing.length > 0) {
        return existing;
    }
    NSString *ev = [entry[@"event"] isKindOfClass:NSString.class] ? entry[@"event"] : @"";
    if ([ev isEqualToString:@"adRuleDecision"] || [ev containsString:@"Hook"] || [ev containsString:@"Rule"]) {
        return @"hook";
    }
    if ([ev hasPrefix:@"commentRequest"] || [ev hasPrefix:@"commentResponse"] ||
        [ev isEqualToString:@"commentNetworkResponse"] || [ev containsString:@"network"]) {
        return @"network";
    }
    if ([ev containsString:@"tts"] || [ev containsString:@"TTS"] || [ev containsString:@"audio"] ||
        [ev containsString:@"Audio"]) {
        return @"tts";
    }
    if ([ev isEqualToString:@"plugin_start"] || [ev isEqualToString:@"pluginLoad"] ||
        [ev isEqualToString:@"exceptionRaise"] || [ev hasPrefix:@"pageDid"] ||
        [ev containsString:@"security"] || [ev containsString:@"verify"]) {
        return @"security";
    }
    if ([ev hasPrefix:@"commentBubble"] || [ev containsString:@"View"] || [ev containsString:@"Layout"]) {
        return @"view";
    }
    return @"ui";
}

static NSString *FQXHubEntryIdentity(NSDictionary *entry) {
    id session = entry[@"sessionId"], sequence = entry[@"hubSeq"];
    if (![session isKindOfClass:NSString.class] || ![sequence isKindOfClass:NSNumber.class]) return nil;
    return [NSString stringWithFormat:@"%@/%@", session, sequence];
}

static void FQXAddHubEntry(id value, NSMutableArray *dest, NSMutableSet *seen, NSTimeInterval minTimestamp) {
    if (![value isKindOfClass:NSDictionary.class]) return;
    NSDictionary *entry = value;
    NSString *identity = FQXHubEntryIdentity(entry);
    if (!identity || [seen containsObject:identity] || ![entry[@"timestamp"] isKindOfClass:NSNumber.class]) return;
    if ([entry[@"timestamp"] doubleValue] < minTimestamp) return;
    [seen addObject:identity];
    [dest addObject:entry];
}

static void FQXReadJSONLinesFileInto(NSURL *fileURL,
                                    NSMutableArray *dest, NSMutableSet *seen,
                                    NSTimeInterval minTimestamp) {
    if (!fileURL) return;
    unsigned long long size = [NSFileManager.defaultManager attributesOfItemAtPath:fileURL.path error:NULL].fileSize;
    if (!size || size > kFQXHubMaxDiskBytesPerFile) return;
    NSData *raw = [NSData dataWithContentsOfURL:fileURL options:0 error:NULL];
    const uint8_t *cursor = raw.bytes;
    if (!raw.length || raw.length > kFQXHubMaxDiskBytesPerFile) return;
    const uint8_t *end = cursor + raw.length;
    while (cursor < end) {
        const uint8_t *newline = memchr(cursor, '\n', (size_t)(end - cursor));
        if (!newline) break;
        if (newline != cursor) @autoreleasepool {
            NSData *line = [NSData dataWithBytes:cursor length:(NSUInteger)(newline - cursor)];
            id parsed = [NSJSONSerialization JSONObjectWithData:line options:0 error:NULL];
            FQXAddHubEntry(parsed, dest, seen, minTimestamp);
        }
        cursor = newline + 1;
    }
}

static void FQXArchiveLastSessionOnHubQueue(void) {
    NSMutableArray<NSDictionary *> *entries = [NSMutableArray array];
    NSMutableSet *seen = [NSMutableSet set];
    FQXReadJSONLinesFileInto(FQXHubPreviousFileURL(), entries, seen, 0);
    FQXReadJSONLinesFileInto(FQXHubActiveFileURL(), entries, seen, 0);
    NSDictionary *last = entries.lastObject;
    NSString *previousID = last[@"sessionId"];
    if (!previousID || [previousID isEqual:gFQXHubSessionId]) return;

    NSMutableArray *previousEntries = [NSMutableArray array];
    BOOL observedEnd = NO;
    for (NSDictionary *entry in entries) {
        if (![entry[@"sessionId"] isEqual:previousID]) continue;
        [previousEntries addObject:entry];
        observedEnd |= [entry[@"event"] isEqual:@"diagnostic_session_end"];
    }
    NSDictionary *metadata = @{@"sessionId": previousID,
        @"pluginVersion": last[@"pluginVersion"] ?: @"unknown",
        @"lastRecordedAt": last[@"timestamp"], @"lastEvent": last[@"event"] ?: @"unknown",
        @"recordCount": @(previousEntries.count),
        @"endState": observedEnd ? @"termination_observed" : @"termination_unknown"};
    NSData *archive = [NSJSONSerialization dataWithJSONObject:@{@"session": metadata, @"entries": previousEntries}
                                                      options:0 error:NULL];
    NSURL *url = FQXHubLastSessionURL();
    if (url && archive.length && archive.length <= kFQXHubLastSessionBytes) {
        [archive writeToURL:url options:NSDataWritingAtomic error:NULL];
    }
}

static NSDictionary *FQXReadLastSessionOnHubQueue(void) {
    NSURL *url = FQXHubLastSessionURL();
    if (!url) return nil;
    unsigned long long size = [NSFileManager.defaultManager attributesOfItemAtPath:url.path error:NULL].fileSize;
    if (!size || size > kFQXHubLastSessionBytes) return nil;
    NSData *data = [NSData dataWithContentsOfURL:url];
    if (!data.length || data.length > kFQXHubLastSessionBytes) return nil;
    id result = [NSJSONSerialization JSONObjectWithData:data options:0 error:NULL];
    return [result isKindOfClass:NSDictionary.class] ? result : nil;
}

void FQXDiagnosticsHubFinalizeExport(NSURL *coreExportURL,
                                     NSInteger categoryFilter,
                                     void (^completion)(NSURL *finalURL, NSString *errorMessage)) {
    if (!coreExportURL) {
        if (completion) completion(nil, @"未找到基础诊断文件。");
        return;
    }
    NSInteger clampedFilter = (categoryFilter >= FQXDiagCategoryAll && categoryFilter <= FQXDiagCategoryUI)
        ? categoryFilter : FQXDiagCategoryAll;
    NSString *desiredCatKey = FQXDiagCategoryKey((FQXDiagCategory)clampedFilter);

    dispatch_async(FQXHubQueue(), ^{
        FQXFlushWriteBufferOnHubQueue();
        NSError *readErr = nil;
        NSData *coreData = [NSData dataWithContentsOfURL:coreExportURL options:0 error:&readErr];
        if (!coreData.length) {
            dispatch_async(dispatch_get_main_queue(), ^{
                if (completion) completion(coreExportURL, nil);
            });
            return;
        }
        id rootObj = [NSJSONSerialization JSONObjectWithData:coreData
                                                     options:NSJSONReadingMutableContainers
                                                       error:&readErr];
        if (![rootObj isKindOfClass:NSMutableDictionary.class]) {
            dispatch_async(dispatch_get_main_queue(), ^{
                if (completion) completion(coreExportURL, nil);
            });
            return;
        }

        NSMutableDictionary<NSString *, id> *root = (NSMutableDictionary<NSString *, id> *)rootObj;
        NSTimeInterval windowStart = [root[@"windowStart"] doubleValue];
        if (windowStart > 0.0) windowStart -= 60.0; // Allow startup events just before windowStart

        NSMutableArray<NSDictionary<NSString *, id> *> *hubItems = [NSMutableArray array];
        NSMutableSet<NSString *> *seen = [NSMutableSet set];
        NSDictionary *lastSession = FQXReadLastSessionOnHubQueue();
        NSArray *lastEntries = lastSession[@"entries"];
        if ([lastEntries isKindOfClass:NSArray.class]) {
            for (id entry in lastEntries) FQXAddHubEntry(entry, hubItems, seen, 0);
        }
        FQXReadJSONLinesFileInto(FQXHubPreviousFileURL(), hubItems, seen, windowStart);
        FQXReadJSONLinesFileInto(FQXHubActiveFileURL(), hubItems, seen, windowStart);
        for (NSDictionary<NSString *, id> *memItem in gFQXHubRing) {
            FQXAddHubEntry(memItem, hubItems, seen, windowStart);
        }

        NSArray *coreEntries = [root[@"entries"] isKindOfClass:NSArray.class] ? root[@"entries"] : @[];
        NSMutableArray<NSDictionary<NSString *, id> *> *combined =
            [NSMutableArray arrayWithCapacity:coreEntries.count + hubItems.count];
        NSMutableDictionary<NSString *, NSNumber *> *categoryCounts = [NSMutableDictionary dictionary];

        for (id rawEntry in coreEntries) {
            if (![rawEntry isKindOfClass:NSDictionary.class]) continue;
            NSMutableDictionary<NSString *, id> *mutableEntry = [(NSDictionary *)rawEntry mutableCopy];
            NSString *cat = FQXClassifyCoreEntryCategory(mutableEntry);
            mutableEntry[@"category"] = cat;
            categoryCounts[cat] = @([categoryCounts[cat] unsignedIntegerValue] + 1);
            if (clampedFilter == FQXDiagCategoryAll || [cat isEqualToString:desiredCatKey]) {
                [combined addObject:mutableEntry];
            }
        }

        for (NSDictionary<NSString *, id> *hubEntry in hubItems) {
            NSString *cat = [hubEntry[@"category"] isKindOfClass:NSString.class] ? hubEntry[@"category"] : @"ui";
            categoryCounts[cat] = @([categoryCounts[cat] unsignedIntegerValue] + 1);
            if (clampedFilter == FQXDiagCategoryAll || [cat isEqualToString:desiredCatKey]) {
                [combined addObject:hubEntry];
            }
        }

        [combined sortUsingComparator:^NSComparisonResult(NSDictionary *a, NSDictionary *b) {
            double ta = [a[@"timestamp"] doubleValue];
            double tb = [b[@"timestamp"] doubleValue];
            if (ta < tb) return NSOrderedAscending;
            if (ta > tb) return NSOrderedDescending;
            return NSOrderedSame;
        }];

        NSDictionary<NSString *, id> *snssdkSummary = nil;
        NSArray<NSDictionary<NSString *, id> *> *recentFails = nil;
        os_unfair_lock_lock(&gFQXRecentFailLock);
        snssdkSummary = @{
            @"monitoredHost": @"is.snssdk.com",
            @"issued": @(gFQXSnssdkIssuedCount),
            @"succeeded": @(gFQXSnssdkSuccessCount),
            @"failed": @(gFQXSnssdkFailureCount),
            @"cancelled": @(gFQXSnssdkCancelledCount),
            @"releasedUnobserved": @(gFQXSnssdkUnobservedCount),
            @"note": @"客户端错误仅反映连接/传输失败，是否命中 Loon REJECT 规则需以 Loon 请求日志为准",
        };
        recentFails = gFQXRecentNetFailures ? [gFQXRecentNetFailures copy] : @[];
        os_unfair_lock_unlock(&gFQXRecentFailLock);

        root[@"entries"] = combined;
        root[@"recordCount"] = @(combined.count);
        root[@"categoryFilter"] = desiredCatKey;
        root[@"categoryFilterDisplayName"] = FQXDiagCategoryDisplayName(clampedFilter);
        NSMutableDictionary *hubSummary = [@{
            @"hubVersion": kFQXHubPluginVersion,
            @"enhancedMode": @(FQXDiagnosticsHubIsEnhanced()),
            @"categoryFilter": desiredCatKey,
            @"categoryCountsBeforeFilter": categoryCounts,
            @"hubDroppedByRateLimit": @(atomic_load_explicit(&gFQXHubDroppedCount, memory_order_relaxed)),
            @"snssdkMonitorSummary": snssdkSummary,
            @"recentNetworkFailures": recentFails,
            @"ttsParagraphSummary": @{
                @"entranceViewsCreatedSession": @(atomic_load_explicit(&gFQXParaViewCreatedTotal, memory_order_relaxed)),
                @"entranceViewsHiddenByHost": @(atomic_load_explicit(&gFQXParaViewHiddenByHostCount, memory_order_relaxed)),
                @"entranceViewsRemoved": @(atomic_load_explicit(&gFQXParaViewRemovedCount, memory_order_relaxed)),
            },
        } mutableCopy];
        if ([lastSession[@"session"] isKindOfClass:NSDictionary.class]) hubSummary[@"previousSession"] = lastSession[@"session"];
        root[@"diagnosticsHub"] = hubSummary;

        NSError *writeErr = nil;
        NSData *finalData = [NSJSONSerialization dataWithJSONObject:root
                                                            options:NSJSONWritingPrettyPrinted
                                                              error:&writeErr];
        if (!finalData.length || writeErr) {
            dispatch_async(dispatch_get_main_queue(), ^{
                if (completion) completion(coreExportURL, nil);
            });
            return;
        }
        [finalData writeToURL:coreExportURL options:NSDataWritingAtomic error:&writeErr];
        dispatch_async(dispatch_get_main_queue(), ^{
            if (completion) completion(coreExportURL, nil);
        });
    });
}
