// Real Foundation/runtime checks for the production diagnostics translation unit.
// These host fixtures model selected public method contracts, not UIKit or iOS.
#import <Foundation/Foundation.h>
#import <objc/runtime.h>
#include <stdio.h>
#include <stdlib.h>
#include <string.h>

extern void FQDInstall(void);
extern void FQDAdDecision(void *, void *, long, const char *, const char *, long);
extern void FQDLoadStage(const char *);
extern void *FQDLoadSummary(void);

static NSMutableArray *SmokeEvents;
static NSMutableDictionary *OriginalCalls;
static NSUInteger SmokeChecks;
static NSString *const PrivateSentinel = @"FANQIEX_PRIVATE_BODY_QUERY_TOKEN_SENTINEL";
static NSURL *DocumentsFixture;
static NSURL *FixtureParent;
static Method DocumentsMethod;
static IMP OriginalDocumentsMethod;
static BOOL CleanupDocuments(void);
static NSArray *Events(NSString *name);

static void Check(BOOL condition, const char *message) {
    SmokeChecks++;
    if (!condition) {
        fprintf(stderr, "native smoke failed: %s\n", message);
        (void)CleanupDocuments();
        exit(2);
    }
}

static NSArray *FixtureDocumentURLs(id self, SEL cmd, NSSearchPathDirectory directory,
                                   NSSearchPathDomainMask domains) {
    if (directory == NSDocumentDirectory && domains == NSUserDomainMask)
        return @[DocumentsFixture];
    return ((NSArray *(*)(id, SEL, NSSearchPathDirectory, NSSearchPathDomainMask))
            OriginalDocumentsMethod)(self, cmd, directory, domains);
}

static BOOL CleanupDocuments(void) {
    if (DocumentsMethod && OriginalDocumentsMethod) {
        method_setImplementation(DocumentsMethod, OriginalDocumentsMethod);
        DocumentsMethod = NULL; OriginalDocumentsMethod = NULL;
    }
    if (!DocumentsFixture)
        return YES;
    // Delete only our directly-created UUID child of the resolved temp base.
    BOOL inside = [[DocumentsFixture URLByDeletingLastPathComponent] isEqual:FixtureParent] &&
                  [[DocumentsFixture lastPathComponent] hasPrefix:@"fanqiex-native-smoke-"];
    BOOL removed = inside && [[NSFileManager defaultManager] removeItemAtURL:DocumentsFixture error:NULL];
    [DocumentsFixture release]; DocumentsFixture = nil;
    [FixtureParent release]; FixtureParent = nil;
    return removed;
}

static void IsolateDocuments(void) {
    NSFileManager *manager = [NSFileManager defaultManager];
    FixtureParent = [[NSURL fileURLWithPath:[NSTemporaryDirectory() stringByResolvingSymlinksInPath]
                              isDirectory:YES] retain];
    NSString *name = [@"fanqiex-native-smoke-" stringByAppendingString:[NSUUID UUID].UUIDString];
    DocumentsFixture = [[FixtureParent URLByAppendingPathComponent:name isDirectory:YES] retain];
    Check([[DocumentsFixture URLByDeletingLastPathComponent] isEqual:FixtureParent],
          "fixture is a checked direct temp child");
    Check([manager createDirectoryAtURL:DocumentsFixture withIntermediateDirectories:NO attributes:nil error:NULL],
          "fixture temp directory created");
    SEL selector = @selector(URLsForDirectory:inDomains:);
    DocumentsMethod = class_getInstanceMethod([manager class], selector);
    Check(DocumentsMethod != NULL, "Foundation document-directory selector exists");
    OriginalDocumentsMethod = method_setImplementation(DocumentsMethod, (IMP)FixtureDocumentURLs);
    Check([[manager URLsForDirectory:NSDocumentDirectory inDomains:NSUserDomainMask]
           isEqualToArray:@[DocumentsFixture]], "Documents resolves only to fixture temp directory");
    NSArray *forwarded = [manager URLsForDirectory:NSCachesDirectory inDomains:NSUserDomainMask];
    NSArray *original = ((NSArray *(*)(id, SEL, NSSearchPathDirectory, NSSearchPathDomainMask))
                         OriginalDocumentsMethod)(manager, selector, NSCachesDirectory, NSUserDomainMask);
    Check([forwarded isEqualToArray:original], "other directory queries preserve Foundation behavior");
}

static NSURL *LoadJournalURL(void) {
    return [[DocumentsFixture URLByAppendingPathComponent:@"FanqieX" isDirectory:YES]
            URLByAppendingPathComponent:@"load-diagnostics.json"];
}

static void RunLoadDiagnostics(void) {
    NSFileManager *manager = [NSFileManager defaultManager];
    NSURL *url = LoadJournalURL();
    FQDLoadStage("unknown-private-stage");
    Check(![manager fileExistsAtPath:url.path], "unknown load stage creates no journal");
    NSArray *stages = @[@"entry", @"diagnosticsInstallBegin", @"diagnosticsInstallComplete",
                        @"startupPopupInstalled", @"legacyHooksInstalled", @"loggerReady",
                        @"loadFinished", @"firstPageDidAppear"];
    NSTimeInterval previousTime = 0;
    NSString *session = nil;
    for (NSUInteger index = 0; index < stages.count; index++) {
        NSString *stage = stages[index];
        FQDLoadStage(stage.UTF8String);
        NSData *data = [NSData dataWithContentsOfURL:url];
        Check(data && data.length <= 32768, "atomic journal exists within 32 KiB limit");
        NSDictionary *journal = [NSJSONSerialization JSONObjectWithData:data options:0 error:NULL];
        Check([journal isKindOfClass:[NSDictionary class]], "journal is valid real Foundation JSON");
        Check([journal[@"stage"] isEqual:stage] && [journal[@"stages"] count] == index + 1,
              "every fixed stage appends in order");
        Check([journal[@"time"] doubleValue] >= previousTime, "journal timestamps are nondecreasing");
        previousTime = [journal[@"time"] doubleValue];
        Check([journal[@"complete"] boolValue] == (index == stages.count - 1),
              "only first page appearance completes plugin load");
        Check([journal[@"version"] isEqualToString:@"1.6.4"] &&
              [journal[@"previousRead"] isEqualToString:@"absent"], "fresh journal metadata");
        if (!session) session = [[journal[@"sessionId"] copy] autorelease];
        Check([journal[@"sessionId"] isEqual:session] &&
              [[[NSUUID alloc] initWithUUIDString:session] autorelease] != nil, "load session stays stable");
        for (NSString *key in @[@"hostVersion", @"hostBuild"])
            Check(journal[key] == [NSNull null] || [journal[key] isKindOfClass:[NSString class]],
                  "optional host metadata accepts nil or bounded string");
        NSString *expectedVersion = [[NSBundle mainBundle] objectForInfoDictionaryKey:@"CFBundleShortVersionString"];
        NSString *expectedBuild = [[NSBundle mainBundle] objectForInfoDictionaryKey:@"CFBundleVersion"];
        if (!expectedVersion) Check(journal[@"hostVersion"] == [NSNull null], "nil host version is represented safely");
        if (!expectedBuild) Check(journal[@"hostBuild"] == [NSNull null], "nil host build is represented safely");
    }
    NSData *completed = [NSData dataWithContentsOfURL:url];
    FQDLoadStage("entry");
    Check([[NSData dataWithContentsOfURL:url] isEqual:completed], "completed journal is immutable within process");
    NSDictionary *summary = (NSDictionary *)FQDLoadSummary();
    Check([summary[@"stages"] count] == 8 && [summary[@"complete"] boolValue], "summary contains eight fixed stages");
    Check(Events(@"pluginLoad").count == 1, "completed load is emitted exactly once");
}

static void Called(id object, SEL selector) {
    NSString *key = [NSString stringWithFormat:@"%@.%@", NSStringFromClass([object class]),
                                              NSStringFromSelector(selector)];
    OriginalCalls[key] = @([OriginalCalls[key] unsignedIntegerValue] + 1);
}

static NSUInteger Calls(Class cls, SEL selector) {
    NSString *key = [NSString stringWithFormat:@"%@.%@", NSStringFromClass(cls),
                                              NSStringFromSelector(selector)];
    return [OriginalCalls[key] unsignedIntegerValue];
}

static NSArray *Events(NSString *name) {
    NSMutableArray *result = [NSMutableArray array];
    for (NSDictionary *record in SmokeEvents)
        if ([record[@"event"] isEqualToString:name])
            [result addObject:record[@"data"]];
    return result;
}

// Match the production bridge's C ABI while using actual libobjc lookup,
// encoding comparison, local Method allocation and IMP replacement semantics.
void *FQDResolveOwned(void *object, void *selector, int classMethod, const char *encoding) {
    Class cls = (Class)object;
    SEL sel = (SEL)selector;
    if (!cls || !sel || !encoding)
        return NULL;
    Class target = classMethod ? object_getClass(cls) : cls;
    Method method = class_getInstanceMethod(target, sel);
    if (!method || strcmp(method_getTypeEncoding(method), encoding))
        return NULL;
    Class superclass = class_getSuperclass(target);
    if (superclass && class_getInstanceMethod(superclass, sel) == method) {
        if (!class_addMethod(target, sel, method_getImplementation(method),
                             method_getTypeEncoding(method)))
            return NULL;
        Method local = class_getInstanceMethod(target, sel);
        if (!local || local == method)
            return NULL;
        method = local;
    }
    return method;
}

void FQDRecord(const char *event, void *payload) {
    NSDictionary *data = (NSDictionary *)payload;
    Check(event && [data isKindOfClass:[NSDictionary class]], "record is a dictionary");
    Check([NSJSONSerialization isValidJSONObject:data], "record is real Foundation JSON");
    NSDictionary *snapshot = [[data copy] autorelease];
    [SmokeEvents addObject:@{@"event" : [NSString stringWithUTF8String:event],
                            @"data" : snapshot}];
}

void *FQDVersion(void) {
    return @"1.6.4";
}

@interface SmokePageBase : NSObject
- (void)viewDidLoad;
- (void)viewDidAppear:(BOOL)animated;
- (void)viewDidDisappear:(BOOL)animated;
@end
@implementation SmokePageBase
- (void)viewDidLoad { Called(self, _cmd); }
- (void)viewDidAppear:(BOOL)animated { (void)animated; Called(self, _cmd); }
- (void)viewDidDisappear:(BOOL)animated { (void)animated; Called(self, _cmd); }
@end
#define PAGE_FIXTURE(name) @interface name : SmokePageBase @end @implementation name @end
PAGE_FIXTURE(BDReaderViewController)
PAGE_FIXTURE(SSBookStoreNewViewController)
PAGE_FIXTURE(SSBookShelf525ViewController)
PAGE_FIXTURE(SSMine737KMPViewController)
PAGE_FIXTURE(SSShortVideoRcmdMainViewController)
PAGE_FIXTURE(FQCParagraphCommentListViewController)
PAGE_FIXTURE(SmokeUntargetedPage)

@interface FQCParagraphEntranceViewModel : NSObject {
    long _smokeRawIdeaCount;
}
@property(nonatomic) long ideaCount;
@property(nonatomic) long ideaOriginCount;
@property(nonatomic) long _ideaCount;
@property(nonatomic) BOOL isFromCache;
@property(nonatomic, copy) NSString *chapterId;
@property(nonatomic, copy) NSString *paragraphId;
@property(nonatomic, retain) NSArray *bubbleData;
@property(nonatomic, retain) id currentBubbleData;
@end
@implementation FQCParagraphEntranceViewModel
@synthesize _ideaCount = _smokeRawIdeaCount;
- (void)dealloc {
    [_chapterId release]; [_paragraphId release];
    [_bubbleData release]; [_currentBubbleData release];
    [super dealloc];
}
@end
@interface SSParagraphIdeaDataVal : FQCParagraphEntranceViewModel @end
@implementation SSParagraphIdeaDataVal @end

@interface SmokeBubbleBase : NSObject
@property(nonatomic, getter=isHidden) BOOL hidden;
@property(nonatomic, retain) id window;
- (void)removeFromSuperview;
- (void)didMoveToWindow;
@end
@implementation SmokeBubbleBase
- (void)removeFromSuperview { self.window = nil; Called(self, _cmd); }
- (void)didMoveToWindow { Called(self, _cmd); }
- (void)dealloc { [_window release]; [super dealloc]; }
@end
@interface FQCReaderParagraphEndView : SmokeBubbleBase
@property(nonatomic, retain) FQCParagraphEntranceViewModel *model;
- (void)updateIdeaLabelCount;
- (void)ideaCountTap;
@end
@implementation FQCReaderParagraphEndView
- (void)updateIdeaLabelCount { Called(self, _cmd); }
- (void)ideaCountTap { Called(self, _cmd); }
- (void)dealloc { [_model release]; [super dealloc]; }
@end
@interface SmokeUntargetedBubble : SmokeBubbleBase @end
@implementation SmokeUntargetedBubble @end

@interface SSReaderParagraphCommentAdapter : NSObject
@property(nonatomic, retain) id paragraphCommentPanelSessionToken;
- (void)showParagraphCommentVCWithOpenParams:(id)params;
- (void)paragraphCommentPanelDidDismissForSessionToken:(id)token;
@end
@implementation SSReaderParagraphCommentAdapter
- (void)showParagraphCommentVCWithOpenParams:(id)params {
    (void)params;
    self.paragraphCommentPanelSessionToken = [[[NSObject alloc] init] autorelease];
    Called(self, _cmd);
}
- (void)paragraphCommentPanelDidDismissForSessionToken:(id)token {
    (void)token; self.paragraphCommentPanelSessionToken = nil; Called(self, _cmd);
}
- (void)dealloc { [_paragraphCommentPanelSessionToken release]; [super dealloc]; }
@end

@interface BDRpcMethod : NSObject
// operationType is intentionally id so the boundary cases can supply an
// NSNumber/NSNull without invoking undefined Objective-C calling conventions.
@property(nonatomic, retain) id operationType;
@end
@implementation BDRpcMethod
- (void)dealloc { [_operationType release]; [super dealloc]; }
@end
@interface BDRpcInternalRequest : NSObject
@property(nonatomic, retain) BDRpcMethod *method;
@property(nonatomic, retain) NSDictionary *headers;
@property(nonatomic, retain) NSString *URL;
@end
@implementation BDRpcInternalRequest
- (void)dealloc { [_method release]; [_headers release]; [_URL release]; [super dealloc]; }
@end

typedef void (^SmokeCompletion)(id);
@interface BDRpcAsyncOperation : NSObject
@property(nonatomic, retain) BDRpcInternalRequest *request;
@property(nonatomic, retain) NSError *error;
@property(nonatomic, copy) SmokeCompletion completion;
- (instancetype)initWithRequest:(id)request completion:(SmokeCompletion)completion;
- (void)sendRequest;
- (void)cancel;
- (void)completeOperation;
- (void)_postHandleResult:(id)result headerFields:(id)headers;
@end
@implementation BDRpcAsyncOperation
- (instancetype)initWithRequest:(id)request completion:(SmokeCompletion)completion {
    self = [super init];
    if (self) { self.request = request; self.completion = completion; Called(self, _cmd); }
    return self;
}
- (void)sendRequest { Called(self, _cmd); }
- (void)cancel { Called(self, _cmd); }
- (void)completeOperation { Called(self, _cmd); }
- (void)_postHandleResult:(id)result headerFields:(id)headers {
    (void)headers; Called(self, _cmd);
    if (_completion) _completion(result);
}
- (void)dealloc { [_request release]; [_error release]; [_completion release]; [super dealloc]; }
@end

@interface SmokeTransport : NSObject
@property(nonatomic) long statusCode;
@property(nonatomic, retain) NSData *rawData;
@property(nonatomic, retain) NSError *error;
@end
@implementation SmokeTransport
- (void)dealloc { [_rawData release]; [_error release]; [super dealloc]; }
@end
@interface BDRpcResponse : SmokeTransport
- (instancetype)initWithRequest:(id)request response:(SmokeTransport *)response;
@end
@implementation BDRpcResponse
- (instancetype)initWithRequest:(id)request response:(SmokeTransport *)response {
    (void)request; self = [super init];
    if (self) {
        self.statusCode = response.statusCode; self.rawData = response.rawData;
        self.error = response.error; Called(self, _cmd);
    }
    return self;
}
@end

static BDRpcInternalRequest *Request(id operationType) {
    BDRpcMethod *method = [[[BDRpcMethod alloc] init] autorelease];
    method.operationType = operationType;
    BDRpcInternalRequest *request = [[[BDRpcInternalRequest alloc] init] autorelease];
    request.method = method;
    request.headers = @{@"Authorization" : PrivateSentinel, @"Cookie" : PrivateSentinel};
    request.URL = [@"https://example.invalid/?token=" stringByAppendingString:PrivateSentinel];
    return request;
}

static void CheckEventsHaveCorrelation(void) {
    for (NSDictionary *record in SmokeEvents) {
        NSDictionary *data = record[@"data"];
        if ([record[@"event"] isEqualToString:@"pluginLoad"])
            continue;
        Check([data[@"objectId"] isKindOfClass:[NSString class]] || data[@"objectId"] == [NSNull null],
              "anonymous object identity");
        Check([data[@"correlationId"] isKindOfClass:[NSString class]], "correlation is a string");
        Check([data[@"uptime"] isKindOfClass:[NSNumber class]], "uptime is numeric");
    }
}

static void RunSmoke(NSString *failureCase) {
    Check(!strcmp(@encode(BOOL), "B"), "fixtures use arm64 BOOL encoding");
    Method baseLoad = class_getInstanceMethod([SmokePageBase class], @selector(viewDidLoad));
    IMP baseLoadIMP = method_getImplementation(baseLoad);
    Method baseHidden = class_getInstanceMethod([SmokeBubbleBase class], @selector(setHidden:));
    IMP baseHiddenIMP = method_getImplementation(baseHidden);
    FQDInstall();
    Method hookedLoad = class_getInstanceMethod([BDReaderViewController class], @selector(viewDidLoad));
    IMP hookedLoadIMP = method_getImplementation(hookedLoad);
    Check(hookedLoad != baseLoad && hookedLoadIMP != baseLoadIMP, "page inherited Method localized");
    Check(method_getImplementation(baseLoad) == baseLoadIMP, "page base implementation unchanged");
    Check(method_getImplementation(baseHidden) == baseHiddenIMP, "bubble base implementation unchanged");
    Check(class_getInstanceMethod([SmokeUntargetedPage class], @selector(viewDidLoad)) == baseLoad,
          "unrelated page keeps inherited Method");
    FQDInstall();
    Check(method_getImplementation(hookedLoad) == hookedLoadIMP, "reinstall preserves original alias");

    NSUInteger before = SmokeEvents.count;
    BDRpcInternalRequest *startup = Request(@"$POST /novel/home/v1/");
    BDRpcAsyncOperation *unrelated = [[BDRpcAsyncOperation alloc] initWithRequest:startup completion:nil];
    [unrelated sendRequest];
    [unrelated _postHandleResult:@{@"body" : PrivateSentinel} headerFields:startup.headers];
    [unrelated completeOperation];
    [unrelated release];
    Check(SmokeEvents.count == before, "unrelated startup request is not recorded");

    if ([failureCase hasPrefix:@"operation-type-"]) {
        id unexpected = [failureCase isEqualToString:@"operation-type-number"] ? (id)@42 : [NSNull null];
        NSUInteger originalInits = Calls([BDRpcAsyncOperation class], @selector(initWithRequest:completion:));
        BDRpcAsyncOperation *unknown = [[BDRpcAsyncOperation alloc]
            initWithRequest:Request(unexpected) completion:nil];
        [unknown sendRequest];
        [unknown release];
        Check(Calls([BDRpcAsyncOperation class], @selector(initWithRequest:completion:)) == originalInits + 1,
              "non-string operation type preserves original request");
        Check(SmokeEvents.count == before, "non-string operation type is excluded");
    }

    for (Class pageClass in @[[BDReaderViewController class], [SSBookStoreNewViewController class],
                              [SSBookShelf525ViewController class], [SSMine737KMPViewController class],
                              [SSShortVideoRcmdMainViewController class]]) {
        SmokePageBase *page = [[pageClass alloc] init];
        [page viewDidLoad]; [page viewDidAppear:YES]; [page viewDidDisappear:YES];
        Check(Calls(pageClass, @selector(viewDidLoad)) == 1, "page original called once");
        [page release];
    }
    Check(Events(@"pageDidLoad").count == 5 && Events(@"pageDidAppear").count == 5 &&
          Events(@"pageDidDisappear").count == 5, "known page events emitted");
    before = SmokeEvents.count;
    SmokeUntargetedPage *sibling = [[SmokeUntargetedPage alloc] init];
    [sibling viewDidLoad]; [sibling release];
    Check(SmokeEvents.count == before, "sibling page is not observed");

    FQCParagraphEntranceViewModel *model = [[FQCParagraphEntranceViewModel alloc] init];
    model.chapterId = PrivateSentinel; model.paragraphId = PrivateSentinel;
    model.ideaOriginCount = 1; model.ideaCount = 1;
    FQCReaderParagraphEndView *bubble = [[FQCReaderParagraphEndView alloc] init];
    bubble.model = model; [bubble updateIdeaLabelCount]; [bubble ideaCountTap];
    SSReaderParagraphCommentAdapter *adapter = [[SSReaderParagraphCommentAdapter alloc] init];
    [adapter showParagraphCommentVCWithOpenParams:@{@"private" : PrivateSentinel}];
    id token = [adapter.paragraphCommentPanelSessionToken retain];
    FQCParagraphCommentListViewController *panel = [[FQCParagraphCommentListViewController alloc] init];
    [panel viewDidAppear:YES]; [panel viewDidDisappear:YES];
    [adapter paragraphCommentPanelDidDismissForSessionToken:token];
    Check(model.ideaCount == 1, "diagnostic observation preserves the fixture count");
    NSArray *opened = Events(@"commentPanelOpenBegin");
    NSArray *closed = Events(@"commentPanelDismissReturned");
    Check(opened.count == 1 && closed.count == 1, "panel open/close observed");
    Check([opened[0][@"correlationId"] isEqual:closed[0][@"correlationId"]], "panel correlation stable");
    [token release]; [adapter release]; [panel release];

    __block NSUInteger completions = 0;
    for (NSString *path in @[@"$POST /novel/commentapi/idea/list/:item_id/v1/",
                             @"$POST /novel/commentapi/comment/list/:group_id/v1/"]) {
        BDRpcInternalRequest *request = Request(path);
        BDRpcAsyncOperation *operation = [[BDRpcAsyncOperation alloc]
            initWithRequest:request completion:^(id result) {
                (void)result; completions++; model.ideaCount = 2;
            }];
        [operation sendRequest]; [operation sendRequest];
        SmokeTransport *transport = [[SmokeTransport alloc] init];
        transport.statusCode = 200; transport.rawData = [PrivateSentinel dataUsingEncoding:NSUTF8StringEncoding];
        BDRpcResponse *response = [[BDRpcResponse alloc] initWithRequest:request response:transport];
        [response release]; [transport release];
        NSDictionary *parsed = @{@"data" : @{@"data_list" : @[@{@"text" : PrivateSentinel}],
                                             @"total" : @1, @"has_more" : @NO}};
        [operation _postHandleResult:parsed headerFields:request.headers];
        [operation completeOperation]; [operation cancel]; [operation release];
    }
    Check(completions == 2, "original RPC completions delivered once each");
    Check(Events(@"commentRequestCreated").count == 2, "both precise comment templates observed");
    Check(Events(@"commentRequestSend").count == 4, "send and retry observed");
    Check(Events(@"commentNetworkResponse").count == 2, "transport metadata observed");
    Check(Events(@"commentResponseParsed").count == 2 && Events(@"commentResponseDelivered").count == 2,
          "parsed callback delivered without replacement");
    NSArray *counts = Events(@"commentCountChanged");
    NSDictionary *lastCount = [counts lastObject];
    NSDictionary *lastResponse = [Events(@"commentResponseParsed") lastObject];
    Check([lastCount[@"correlationId"] isEqual:lastResponse[@"correlationId"]],
          "synchronous network completion carries correlation to model update");
    if ([failureCase isEqualToString:@"callback-throws"]) {
        NSException *expectedCallback = [NSException exceptionWithName:@"SmokeExpectedCallbackException"
                                                               reason:PrivateSentinel userInfo:nil];
        __block NSUInteger throwingCalls = 0;
        BDRpcAsyncOperation *throwing = [[BDRpcAsyncOperation alloc]
            initWithRequest:Request(@"$POST /novel/commentapi/idea/list/:item_id/v1/")
            completion:^(id result) {
                (void)result; throwingCalls++; [expectedCallback raise];
            }];
        NSString *throwingCorrelation = [Events(@"commentRequestCreated") lastObject][@"correlationId"];
        // Establish a distinct current UI operation while the older request
        // remains in flight. Its throwing callback must not leave its scoped
        // network correlation attached to the current thread.
        [bubble ideaCountTap];
        NSString *currentCorrelation = [Events(@"commentBubbleTap") lastObject][@"correlationId"];
        Check(![currentCorrelation isEqual:throwingCorrelation], "overlapping request has distinct context");
        BOOL caughtCallback = NO;
        @try { [throwing _postHandleResult:@{} headerFields:nil]; }
        @catch (NSException *actual) { caughtCallback = actual == expectedCallback; }
        Check(caughtCallback && throwingCalls == 1,
              "exception from original RPC completion crosses production callback unchanged");
        BDRpcAsyncOperation *afterFailure = [[BDRpcAsyncOperation alloc]
            initWithRequest:Request(@"$POST /novel/commentapi/comment/list/:group_id/v1/")
            completion:^(id result) { (void)result; model.ideaCount = 3; }];
        NSDictionary *nextCreated = [Events(@"commentRequestCreated") lastObject];
        Check([nextCreated[@"correlationId"] isEqual:currentCorrelation] &&
              ![nextCreated[@"correlationId"] isEqual:throwingCorrelation],
              "later request does not inherit the failed callback's thread context");
        [afterFailure _postHandleResult:@{@"data" : @{}} headerFields:nil];
        NSDictionary *nextCount = [Events(@"commentCountChanged") lastObject];
        NSDictionary *nextDelivered = [Events(@"commentResponseDelivered") lastObject];
        Check([nextCount[@"correlationId"] isEqual:currentCorrelation] &&
              [nextDelivered[@"correlationId"] isEqual:currentCorrelation],
              "later response and model update retain the fresh correlation");
        [afterFailure release]; [throwing release];
    }
    bubble.hidden = YES; [bubble removeFromSuperview]; [bubble release]; [model release];
    Check(Events(@"commentBubbleDealloc").count == 1, "real deallocation forwarded after observation");

    NSObject *ad = [[NSObject alloc] init];
    for (long call = 0; call < 2; call++)
        for (long rule = 0; rule < 45; rule++)
            FQDAdDecision(ad, @selector(description), rule, "SmokeAdTarget", "smokeRule", 0);
    [ad release];
    NSArray *decisions = Events(@"adRuleDecision");
    Check(decisions.count == 90, "all 45 indexed ad decisions reach Foundation logging");
    for (NSUInteger i = 45; i < 90; i++)
        Check([decisions[i][@"callCount"] longLongValue] == 2, "per-rule NSNumber key counter is stable");

    NSException *expected = [NSException exceptionWithName:@"SmokeExpectedException"
                                                  reason:PrivateSentinel userInfo:nil];
    BOOL caught = NO;
    @try { [expected raise]; }
    @catch (NSException *actual) { caught = actual == expected; }
    Check(caught, "original NSException still raises the exact exception");
    Check(Events(@"exceptionRaise").count ==
          ([failureCase isEqualToString:@"callback-throws"] ? 2u : 1u),
          "each intentional exception raise observed once");
    CheckEventsHaveCorrelation();
    NSData *json = [NSJSONSerialization dataWithJSONObject:SmokeEvents options:0 error:NULL];
    NSString *text = [[[NSString alloc] initWithData:json encoding:NSUTF8StringEncoding] autorelease];
    Check(text && [text rangeOfString:PrivateSentinel].location == NSNotFound,
          "body, headers, query, model identifiers and exception reason stay private");
}

int main(int argc, const char **argv) {
    @autoreleasepool {
        SmokeEvents = [[NSMutableArray alloc] init];
        OriginalCalls = [[NSMutableDictionary alloc] init];
        NSString *failureCase = nil;
        if (argc == 3 && !strcmp(argv[1], "--failure-case")) {
            failureCase = [NSString stringWithUTF8String:argv[2]];
            if (![failureCase isEqualToString:@"operation-type-number"] &&
                ![failureCase isEqualToString:@"operation-type-null"] &&
                ![failureCase isEqualToString:@"callback-throws"] &&
                ![failureCase isEqualToString:@"load-diagnostics-normal"]) {
                fprintf(stderr, "unknown native smoke case\n"); return 2;
            }
        } else if (argc != 1) { fprintf(stderr, "unexpected native smoke arguments\n"); return 2; }
        BOOL passed = YES;
        NSString *exceptionName = nil;
        @try {
            IsolateDocuments();
            if ([failureCase isEqualToString:@"load-diagnostics-normal"])
                RunLoadDiagnostics();
            else
                RunSmoke(failureCase);
        }
        @catch (NSException *exception) { passed = NO; exceptionName = exception.name; }
        BOOL fixtureCleaned = CleanupDocuments();
        passed = passed && fixtureCleaned;
        NSMutableDictionary *report = [NSMutableDictionary dictionaryWithDictionary:@{
            @"passed" : @(passed), @"checks" : @(SmokeChecks), @"events" : @(SmokeEvents.count),
            @"case" : failureCase ?: @"normal", @"native_foundation_tested" : @YES,
            @"documents_isolated" : @YES, @"fixture_cleaned" : @(fixtureCleaned),
            @"ios_or_uikit_tested" : @NO,
            @"scope" : @"Production diagnostics linked to real macOS Foundation and libobjc with explicit host fixtures"}];
        if (exceptionName) report[@"unexpected_exception_name"] = exceptionName;
        NSData *json = [NSJSONSerialization dataWithJSONObject:report options:NSJSONWritingPrettyPrinted error:NULL];
        fwrite(json.bytes, 1, json.length, stdout); fputc('\n', stdout);
        [OriginalCalls release]; [SmokeEvents release];
        return passed ? 0 : 1;
    }
}
