#import <Foundation/Foundation.h>
#import <dispatch/dispatch.h>
#import <objc/runtime.h>

#include <stdio.h>
#include <stdlib.h>
#include <string.h>

extern void FQSettingsBoot(void);
extern id FQLogger(void);
extern const void *FQTimerKey(void);

static NSURL *Fixture;
static unsigned SettingsCalls;

static void Require(BOOL condition, const char *message) {
    if (!condition) {
        fprintf(stderr, "%s\n", message);
        exit(1);
    }
}

@interface FQFixtureFileManager : NSFileManager
@end

@implementation FQFixtureFileManager
+ (NSFileManager *)defaultManager {
    static FQFixtureFileManager *manager;
    static dispatch_once_t token;
    dispatch_once(&token, ^{ manager = [[self alloc] init]; });
    return manager;
}
- (NSArray<NSURL *> *)URLsForDirectory:(NSSearchPathDirectory)directory
                            inDomains:(NSSearchPathDomainMask)mask {
    if (directory == NSApplicationSupportDirectory && mask == NSUserDomainMask)
        return @[Fixture];
    return [super URLsForDirectory:directory inDomains:mask];
}
- (NSURL *)temporaryDirectory {
    return Fixture;
}
@end

// Existing plugin imports keep their real implementations. Only the class
// lookup for file management is redirected to isolate worker paths.
Class FQClassLookup(const char *name) {
    return strcmp(name, "NSFileManager") == 0 ? [FQFixtureFileManager class] : objc_lookUpClass(name);
}

BOOL FQIsKind(id value, const char *className) {
    return [value isKindOfClass:objc_lookUpClass(className)];
}

void FQOriginalSettings(void) {
    ++SettingsCalls;
}

void FQUnexpectedHostBranch(void) {
    fputs("logger smoke reached an unsupported application continuation\n", stderr);
    abort();
}

static NSArray<NSDictionary *> *ReadStore(NSURL *file) {
    NSData *bytes = [NSData dataWithContentsOfURL:file];
    if (!bytes)
        return nil;
    id envelope = [NSPropertyListSerialization propertyListWithData:bytes options:0 format:NULL error:NULL];
    if (![envelope isKindOfClass:[NSArray class]] || [envelope count] != 1 ||
        ![[envelope firstObject] isKindOfClass:[NSData class]])
        return nil;
    id records = [NSJSONSerialization JSONObjectWithData:[envelope firstObject] options:0 error:NULL];
    return [records isKindOfClass:[NSArray class]] ? records : nil;
}

static void WriteOldStore(NSURL *file) {
    NSArray *records = @[@{@"event": @"fixtureOld",
                           @"timestamp": @([[NSDate date] timeIntervalSince1970] - 1),
                           @"data": [NSNull null]}];
    NSData *json = [NSJSONSerialization dataWithJSONObject:records options:0 error:NULL];
    Require(json != nil, "old fixture event JSON serialization failed");
    NSData *plist = [NSPropertyListSerialization dataWithPropertyList:@[json]
                                                               format:NSPropertyListBinaryFormat_v1_0
                                                              options:0 error:NULL];
    Require(plist != nil, "old fixture binary plist serialization failed");
    Require([[NSFileManager defaultManager] createDirectoryAtURL:[file URLByDeletingLastPathComponent]
                                     withIntermediateDirectories:YES attributes:nil error:NULL],
            "old fixture directory could not be created");
    Require([plist writeToURL:file options:NSDataWritingAtomic error:NULL],
            "old fixture could not be written");
}

static NSDictionary *Event(NSArray<NSDictionary *> *records, NSString *name) {
    for (NSDictionary *record in records)
        if ([record[@"event"] isEqual:name])
            return record;
    return nil;
}

static NSArray<NSDictionary *> *WaitForEvent(NSURL *file, NSString *name) {
    NSDate *deadline = [NSDate dateWithTimeIntervalSinceNow:3];
    do {
        NSArray<NSDictionary *> *records = ReadStore(file);
        if (Event(records, name))
            return records;
        [[NSRunLoop mainRunLoop] runUntilDate:[NSDate dateWithTimeIntervalSinceNow:0.01]];
    } while ([deadline timeIntervalSinceNow] > 0);
    fprintf(stderr, "timed out waiting for persisted %s\n", [name UTF8String]);
    exit(1);
}

static void CheckNullDataEvent(NSDictionary *record) {
    Require(record[@"data"] == [NSNull null], "nil event payload must persist as JSON null");
    Require([[NSUUID alloc] initWithUUIDString:record[@"sessionId"]] != nil,
            "event must contain a valid session ID");
    Require([[NSUUID alloc] initWithUUIDString:record[@"correlationId"]] != nil,
            "null event payload must receive a fallback correlation ID");
}

int main(int argc, const char **argv) {
    @autoreleasepool {
        Require(argc == 3, "expected a smoke case name and isolated directory");
        BOOL existing = strcmp(argv[1], "existing-store") == 0;
        Require(existing || strcmp(argv[1], "fresh-store") == 0, "unknown smoke case");
        Fixture = [NSURL fileURLWithPath:[NSString stringWithUTF8String:argv[2]] isDirectory:YES];
        NSFileManager *manager = [FQFixtureFileManager defaultManager];
        Require([[[manager URLsForDirectory:NSApplicationSupportDirectory inDomains:NSUserDomainMask]
                  firstObject] isEqual:Fixture] && [manager.temporaryDirectory isEqual:Fixture],
                "file manager did not isolate both persistence paths");
        NSURL *folder = [Fixture URLByAppendingPathComponent:@"FanqieAdBlockDiagnostics" isDirectory:YES];
        NSURL *file = [folder URLByAppendingPathComponent:@"recent.plist" isDirectory:NO];
        if (existing)
            WriteOldStore(file);

        // The original regression threw from NSNull.objectForKey: here,
        // before the wrapper could return to the host launch sequence.
        FQSettingsBoot();
        Require(SettingsCalls == 1, "settings trampoline did not call the host boundary exactly once");
        NSArray<NSDictionary *> *records = WaitForEvent(file, @"plugin_start");
        NSDictionary *startup = Event(records, @"plugin_start");
        CheckNullDataEvent(startup);
        Require(!existing || Event(records, @"fixtureOld") != nil, "old persisted event was not restored");

        id logger = FQLogger();
        NSDate *timerDeadline = [NSDate dateWithTimeIntervalSinceNow:3];
        NSTimer *timer;
        do {
            timer = objc_getAssociatedObject(logger, FQTimerKey());
            if (!timer)
                [[NSRunLoop mainRunLoop] runUntilDate:[NSDate dateWithTimeIntervalSinceNow:0.01]];
        } while (!timer && [timerDeadline timeIntervalSinceNow] > 0);
        Require([timer isKindOfClass:[NSTimer class]] && [timer isValid], "startup timer was not scheduled");
        [timer setFireDate:[NSDate date]];
        records = WaitForEvent(file, @"periodic_snapshot");
        [timer invalidate];
        NSDictionary *periodic = Event(records, @"periodic_snapshot");
        CheckNullDataEvent(periodic);
        Require([startup[@"sessionId"] isEqual:periodic[@"sessionId"]],
                "startup and periodic events must share a session");
        Require(![startup[@"correlationId"] isEqual:periodic[@"correlationId"]],
                "unrelated null events must receive distinct correlation IDs");
        printf("{\"passed\":true,\"old_store_reused\":%s,\"records\":%lu,"
               "\"settings_boot_returned\":true,\"real_worker_persisted\":true,\"timer_fired\":true}\n",
               existing ? "true" : "false", (unsigned long)records.count);
    }
    return 0;
}
