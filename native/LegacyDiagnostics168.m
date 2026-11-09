// Runtime-only Objective-C bridge for the pinned host. Compiled without ARC,
// literals, class metadata, blocks or writable globals into the RX extension.
typedef void *Obj;
typedef void *Sel;
typedef void *Method;
typedef void (*Imp)(void);
typedef unsigned long U;
typedef long I;
typedef signed char B;
// A message dispatch entry has no single C prototype. Each call below casts
// it to the selector's exact ABI. Link aliases avoid redeclaring Clang's
// special runtime builtins with this freestanding bridge's opaque C types.
extern void FQDMessage(void) __asm__("_objc_msgSend");
extern Obj FQDLookupClass(const char *) __asm__("_objc_getClass");
#define objc_msgSend FQDMessage
#define objc_getClass FQDLookupClass
extern Sel sel_registerName(const char *);
extern Obj object_getClass(Obj);
extern Method class_getInstanceMethod(Obj, Sel);
extern Imp method_getImplementation(Method);
extern Imp method_setImplementation(Method, Imp);
extern B class_addMethod(Obj, Sel, Imp, const char *);
extern Obj objc_getAssociatedObject(Obj, const void *);
extern void objc_setAssociatedObject(Obj, const void *, Obj, U);
extern void FQDRecord(const char *, Obj);
extern Obj FQDVersion(void);
extern Method FQDResolveOwned(Obj, Sel, int, const char *);

#define O0(o, s) ((Obj (*)(Obj, Sel))objc_msgSend)((o), sel_registerName(s))
#define O1(o, s, a) ((Obj (*)(Obj, Sel, Obj))objc_msgSend)((o), sel_registerName(s), (a))
#define V0(o, s) ((void (*)(Obj, Sel))objc_msgSend)((o), sel_registerName(s))
#define V1(o, s, a) ((void (*)(Obj, Sel, Obj))objc_msgSend)((o), sel_registerName(s), (a))
#define Q0(o, s) ((I (*)(Obj, Sel))objc_msgSend)((o), sel_registerName(s))
#define B0(o, s) ((B (*)(Obj, Sel))objc_msgSend)((o), sel_registerName(s))
#define B1(o, s, a) ((B (*)(Obj, Sel, Obj))objc_msgSend)((o), sel_registerName(s), (a))

static void ObjectKey(void) {
}
static void ContextKey(void) {
}
static void PanelKey(void) {
}
static void RequestKey(void) {
}
static void SendsKey(void) {
}
static void ExceptionKey(void) {
}
static void StateKey(void) {
}
static void LoadStateKey(void) {
}
extern Obj objc_allocateClassPair(Obj, const char *, U);
extern void objc_registerClassPair(Obj);

static Obj Text(const char *s) {
    return ((Obj (*)(Obj, Sel, const char *))objc_msgSend)(
        objc_getClass("NSString"), sel_registerName("stringWithUTF8String:"), s);
}
static Obj Dict(void) {
    return O0(objc_getClass("NSMutableDictionary"), "dictionary");
}
static Obj Num(I n) {
    return ((Obj (*)(Obj, Sel, I))objc_msgSend)(objc_getClass("NSNumber"),
                                                sel_registerName("numberWithLongLong:"), n);
}
static void Put(Obj d, const char *key, Obj value) {
    if (!value)
        value = O0(objc_getClass("NSNull"), "null");
    ((void (*)(Obj, Sel, Obj, Obj))objc_msgSend)(d, sel_registerName("setObject:forKey:"), value,
                                                 Text(key));
}
static Obj At(Obj d, const char *key) {
    return O1(d, "objectForKey:", Text(key));
}
static Obj UUID(void) {
    return O0(O0(objc_getClass("NSUUID"), "UUID"), "UUIDString");
}
static Obj Root(void) {
    return objc_getClass("SSReaderParagraphCommentAdapter");
}
static Obj Id(Obj o) {
    if (!o)
        return 0;
    Obj value = objc_getAssociatedObject(o, ObjectKey);
    if (!value) {
        value = UUID();
        objc_setAssociatedObject(o, ObjectKey, value, 0x301);
    }
    return value;
}
static Obj Context(void) {
    Obj thread = O0(objc_getClass("NSThread"), "currentThread");
    Obj scoped = objc_getAssociatedObject(thread, ContextKey);
    if (scoped)
        return scoped;
    Obj value = objc_getAssociatedObject(Root(), ContextKey);
    return value ? value : Id(Root());
}
static B Responds(Obj o, const char *s) {
    return o && ((B (*)(Obj, Sel, Sel))objc_msgSend)(o, sel_registerName("respondsToSelector:"),
                                                     sel_registerName(s));
}
static Obj Get(Obj o, const char *s) {
    return Responds(o, s) ? O0(o, s) : 0;
}
static B Kind(Obj o, const char *name) {
    return o && ((B (*)(Obj, Sel, Obj))objc_msgSend)(o, sel_registerName("isKindOfClass:"),
                                                     objc_getClass(name));
}
static I Count(Obj o, const char *s) {
    return Responds(o, s) ? Q0(o, s) : -1;
}
static Obj Clock(void) {
    double t = ((double (*)(Obj, Sel))objc_msgSend)(
        O0(objc_getClass("NSProcessInfo"), "processInfo"), sel_registerName("systemUptime"));
    return ((Obj (*)(Obj, Sel, double))objc_msgSend)(objc_getClass("NSNumber"),
                                                     sel_registerName("numberWithDouble:"), t);
}
static Obj Elapsed(Obj start) {
    double now = ((double (*)(Obj, Sel))objc_msgSend)(Clock(), sel_registerName("doubleValue"));
    double before = ((double (*)(Obj, Sel))objc_msgSend)(start, sel_registerName("doubleValue"));
    return ((Obj (*)(Obj, Sel, double))objc_msgSend)(
        objc_getClass("NSNumber"), sel_registerName("numberWithDouble:"), now - before);
}
static B Enhanced(void) {
    return ((B (*)(Obj, Sel, Obj))objc_msgSend)(
        O0(objc_getClass("NSUserDefaults"), "standardUserDefaults"),
        sel_registerName("boolForKey:"), Text("FanqieX.EnhancedDiagnostics.1"));
}

// This small journal is separate from the asynchronous diagnostic logger. It
// can show the last completed plugin stage after a later process termination;
// it cannot run when dyld rejects the image or identify a system crash cause.
static void Emit(const char *, const char *, Obj, Obj, Obj);
static B LoadStageKnown(Obj stage) {
    if (!Kind(stage, "NSString"))
        return 0;
    return B1(stage, "isEqualToString:", Text("entry")) ||
           B1(stage, "isEqualToString:", Text("diagnosticsInstallBegin")) ||
           B1(stage, "isEqualToString:", Text("diagnosticsInstallComplete")) ||
           B1(stage, "isEqualToString:", Text("startupPopupInstalled")) ||
           B1(stage, "isEqualToString:", Text("legacyHooksInstalled")) ||
           B1(stage, "isEqualToString:", Text("firstPageDidAppear")) ||
           B1(stage, "isEqualToString:", Text("loadFinished")) ||
           B1(stage, "isEqualToString:", Text("loggerReady"));
}
static Obj LoadTime(void) {
    double value = ((double (*)(Obj, Sel))objc_msgSend)(
        O0(objc_getClass("NSDate"), "date"), sel_registerName("timeIntervalSince1970"));
    return ((Obj (*)(Obj, Sel, double))objc_msgSend)(
        objc_getClass("NSNumber"), sel_registerName("numberWithDouble:"), value);
}
static Obj LoadMetadata(Obj value, I limit) {
    return Kind(value, "NSString") && Q0(value, "length") <= limit ? value : (Obj)0;
}
static void LoadPrevious(Obj report, Obj url) {
    Obj manager = O0(objc_getClass("NSFileManager"), "defaultManager");
    Obj path = O0(url, "path");
    if (!B1(manager, "fileExistsAtPath:", path)) {
        Put(report, "previousRead", Text("absent"));
        return;
    }
    Obj error = 0;
    Obj attributes = ((Obj (*)(Obj, Sel, Obj, Obj *))objc_msgSend)(
        manager, sel_registerName("attributesOfItemAtPath:error:"), path, &error);
    if (!attributes || Q0(At(attributes, "NSFileSize"), "unsignedLongLongValue") > 32768) {
        Put(report, "previousRead", Text(attributes ? "oversized" : "statFailed"));
        return;
    }
    Obj data = ((Obj (*)(Obj, Sel, Obj, U, Obj *))objc_msgSend)(
        objc_getClass("NSData"), sel_registerName("dataWithContentsOfURL:options:error:"),
        url, 1, &error);
    if (!data || Q0(data, "length") > 32768) {
        Put(report, "previousRead", Text(data ? "oversized" : "readFailed"));
        return;
    }
    Obj previous = ((Obj (*)(Obj, Sel, Obj, U, Obj *))objc_msgSend)(
        objc_getClass("NSJSONSerialization"), sel_registerName("JSONObjectWithData:options:error:"),
        data, 0, &error);
    if (!Kind(previous, "NSDictionary") ||
        !Kind(At(previous, "version"), "NSString") ||
        !B1(At(previous, "version"), "isEqualToString:", FQDVersion()) ||
        !LoadStageKnown(At(previous, "stage")) ||
        !Kind(At(previous, "complete"), "NSNumber") ||
        !Kind(At(previous, "time"), "NSNumber")) {
        Put(report, "previousRead", Text("invalid"));
        return;
    }
    // Keep four validated fields, never a nested previous attempt or any
    // arbitrary text/metadata from the user-editable Documents file.
    Obj summary = Dict();
    Put(summary, "stage", At(previous, "stage"));
    Put(summary, "complete", Num(B0(At(previous, "complete"), "boolValue")));
    Put(summary, "time", At(previous, "time"));
    Put(summary, "version", FQDVersion());
    Put(report, "previous", summary);
    Put(report, "previousRead", Text("loaded"));
}
static Obj LoadState(void) {
    Obj owner = objc_getClass("NSProcessInfo");
    Obj state = objc_getAssociatedObject(owner, LoadStateKey);
    if (state)
        return state;
    state = Dict();
    Obj lock = O0(O0(objc_getClass("NSLock"), "alloc"), "init");
    Put(state, "lock", lock);
    V0(lock, "release");
    Obj report = Dict();
    Put(report, "version", FQDVersion());
    Put(report, "sessionId", UUID());
    Put(report, "complete", Num(0));
    Put(report, "startedAt", LoadTime());
    Put(report, "osVersion", LoadMetadata(
        O0(O0(objc_getClass("NSProcessInfo"), "processInfo"), "operatingSystemVersionString"), 128));
    Obj bundle = O0(objc_getClass("NSBundle"), "mainBundle");
    Put(report, "hostVersion", LoadMetadata(O1(bundle, "objectForInfoDictionaryKey:",
                                               Text("CFBundleShortVersionString")), 64));
    Put(report, "hostBuild", LoadMetadata(O1(bundle, "objectForInfoDictionaryKey:",
                                             Text("CFBundleVersion")), 64));
    Put(report, "stages", O0(objc_getClass("NSMutableArray"), "array"));
    Put(state, "report", report);
    Obj manager = O0(objc_getClass("NSFileManager"), "defaultManager");
    Obj locations = ((Obj (*)(Obj, Sel, U, U))objc_msgSend)(
        manager, sel_registerName("URLsForDirectory:inDomains:"), 9, 1);
    Obj documents = O0(locations, "firstObject");
    if (documents) {
        Obj directory = O1(documents, "URLByAppendingPathComponent:", Text("FanqieX"));
        Obj url = O1(directory, "URLByAppendingPathComponent:", Text("load-diagnostics.json"));
        Put(state, "directory", directory);
        Put(state, "url", url);
        LoadPrevious(report, url);
    } else {
        Put(report, "previousRead", Text("documentsUnavailable"));
        Put(report, "writeFailed", Num(1));
        Put(report, "writeFailure", Text("documentsUnavailable"));
    }
    objc_setAssociatedObject(owner, LoadStateKey, state, 0x301);
    return state;
}
static void LoadFailure(Obj report, const char *reason, Obj error) {
    Put(report, "writeFailed", Num(1));
    Put(report, "writeFailure", Text(reason));
    Put(report, "writeErrorCode", Num(error ? Q0(error, "code") : 0));
}
static void LoadPersist(Obj state) {
    Obj report = At(state, "report");
    Obj url = At(state, "url");
    if (!url)
        return;
    Obj error = 0;
    if (!B0(At(state, "directoryReady"), "boolValue")) {
        B created = ((B (*)(Obj, Sel, Obj, B, Obj, Obj *))objc_msgSend)(
            O0(objc_getClass("NSFileManager"), "defaultManager"),
            sel_registerName("createDirectoryAtURL:withIntermediateDirectories:attributes:error:"),
            At(state, "directory"), 1, 0, &error);
        if (!created) {
            LoadFailure(report, "directoryFailed", error);
            return;
        }
        Put(state, "directoryReady", Num(1));
    }
    Obj data = ((Obj (*)(Obj, Sel, Obj, U, Obj *))objc_msgSend)(
        objc_getClass("NSJSONSerialization"), sel_registerName("dataWithJSONObject:options:error:"),
        report, 0, &error);
    if (!data || Q0(data, "length") > 32768) {
        LoadFailure(report, data ? "oversized" : "serializationFailed", error);
        return;
    }
    B written = ((B (*)(Obj, Sel, Obj, U, Obj *))objc_msgSend)(
        data, sel_registerName("writeToURL:options:error:"), url, 1, &error);
    if (!written)
        LoadFailure(report, "writeFailed", error);
}
Obj FQDLoadSummary(void) {
    Obj state = LoadState();
    Obj lock = At(state, "lock");
    V0(lock, "lock");
    Obj report = At(state, "report");
    Obj summary = O0(report, "mutableCopy");
    Obj stages = O0(At(report, "stages"), "copy");
    Put(summary, "stages", stages);
    V0(stages, "release");
    V0(lock, "unlock");
    return O0(summary, "autorelease");
}
void FQDLoadStage(const char *stage) {
    Obj name = Text(stage);
    if (!LoadStageKnown(name))
        return;
    Obj state = LoadState();
    Obj lock = At(state, "lock");
    V0(lock, "lock");
    Obj report = At(state, "report");
    Obj stages = At(report, "stages");
    if (B0(At(report, "complete"), "boolValue") ||
        B1(name, "isEqualToString:", At(report, "stage"))) {
        V0(lock, "unlock");
        return;
    }
    if (Q0(stages, "count") >= 24) {
        if (!B0(At(report, "stagesTruncated"), "boolValue")) {
            Put(report, "stagesTruncated", Num(1));
            LoadPersist(state);
        }
        V0(lock, "unlock");
        return;
    }
    Obj time = LoadTime();
    Obj entry = Dict();
    Put(entry, "stage", name);
    Put(entry, "time", time);
    V1(stages, "addObject:", entry);
    Put(report, "stage", name);
    Put(report, "time", time);
    B complete = B1(name, "isEqualToString:", Text("firstPageDidAppear"));
    Put(report, "complete", Num(complete));
    LoadPersist(state);
    V0(lock, "unlock");
    if (complete)
        Emit("pluginLoad", "FanqieX", 0, 0, FQDLoadSummary());
}

static Obj State(void) {
    return objc_getAssociatedObject(Root(), StateKey);
}
static Obj Lock(void) {
    return At(State(), "lock");
}
static Obj Pseudonym(Obj value) {
    if (!Kind(value, "NSString") || Q0(value, "length") > 256)
        return 0;
    Obj lock = Lock();
    V0(lock, "lock");
    Obj map = At(State(), "identityLabels");
    Obj label = O1(map, "objectForKey:", value);
    if (!label) {
        if (Q0(map, "count") >= 2048) {
            V0(map, "removeAllObjects");
            Put(State(), "identityGeneration",
                Num(Q0(At(State(), "identityGeneration"), "longLongValue") + 1));
        }
        label = UUID();
        ((void (*)(Obj, Sel, Obj, Obj))objc_msgSend)(map, sel_registerName("setObject:forKey:"),
                                                     label, value);
    }
    O0(label, "retain");
    V0(lock, "unlock");
    return O0(label, "autorelease");
}
static I NextActivity(void) {
    Obj lock = Lock();
    V0(lock, "lock");
    Obj state = State();
    I n = Q0(At(state, "activity"), "longLongValue") + 1;
    Put(state, "activity", Num(n));
    V0(lock, "unlock");
    return n;
}
static void Emit(const char *event, const char *cls, Obj o, Obj correlation, Obj d) {
    Obj snapshot = O0(d, "mutableCopy");
    Put(snapshot, "class", Text(cls));
    Put(snapshot, "objectId", Id(o));
    Put(snapshot, "correlationId", correlation ? correlation : Context());
    Put(snapshot, "uptime", Clock());
    Put(snapshot, "activityOrdinal", Num(NextActivity()));
    Obj lock = Lock();
    V0(lock, "lock");
    Put(snapshot, "identityGeneration", At(State(), "identityGeneration"));
    V0(lock, "unlock");
    FQDRecord(event, snapshot);
    V0(snapshot, "release");
}
static Obj Values(Obj model) {
    Obj d = Dict();
    Put(d, "modelPresent", Num(model != 0));
    Put(d, "modelId", Id(model));
    Put(d, "count", Num(Count(model, "ideaCount")));
    Put(d, "originalCount", Num(Count(model, "ideaOriginCount")));
    Put(d, "rawCount", Num(Count(model, "_ideaCount")));
    Put(d, "cacheFlagKnown", Num(Responds(model, "isFromCache")));
    Put(d, "fromCache", Num(Responds(model, "isFromCache") ? B0(model, "isFromCache") : 0));
    Obj bubbles = Get(model, "bubbleData");
    Put(d, "bubbleDataPresent", Num(bubbles != 0));
    Put(d, "bubbleDataCount", Num(Count(bubbles, "count")));
    Put(d, "currentBubblePresent", Num(Get(model, "currentBubbleData") != 0));
    // Identifiers are correlated through per-session random labels. Their
    // original strings and the bubble/comment bodies never enter an event.
    Put(d, "chapterId", Pseudonym(Get(model, "chapterId")));
    Put(d, "paragraphId", Pseudonym(Get(model, "paragraphId")));
    return d;
}
static Imp Original(Obj self, const char *alias) {
    Method m = class_getInstanceMethod(object_getClass(self), sel_registerName(alias));
    return m ? method_getImplementation(m) : (Imp)0;
}

static void Bind(Obj self, Sel cmd, Obj model) {
    Obj d = Dict();
    Put(d, "before", Values(Get(self, "model")));
    Put(d, "afterInput", Values(model));
    Imp original = Original(self, "fqx164_bind");
    if (original)
        ((void (*)(Obj, Sel, Obj))original)(self, cmd, model);
    Put(d, "after", Values(Get(self, "model")));
    Emit("commentBubbleBind", "FQCReaderParagraphEndView", self, Context(), d);
}
static void BubbleUpdate(Obj self, Sel cmd) {
    Obj d = Dict();
    Obj model = Get(self, "model");
    Put(d, "before", Values(model));
    Imp original = Original(self, "fqx164_bubbleUpdate");
    if (original)
        ((void (*)(Obj, Sel))original)(self, cmd);
    Put(d, "after", Values(Get(self, "model")));
    Put(d, "hidden", Num(B0(self, "isHidden")));
    Emit("commentBubbleCountUI", "FQCReaderParagraphEndView", self, Context(), d);
}
static void BubbleTap(Obj self, Sel cmd) {
    Obj correlation = UUID();
    objc_setAssociatedObject(Root(), ContextKey, correlation, 0x301);
    Obj d = Values(Get(self, "model"));
    Emit("commentBubbleTap", "FQCReaderParagraphEndView", self, correlation, d);
    Imp original = Original(self, "fqx164_bubbleTap");
    if (original)
        ((void (*)(Obj, Sel))original)(self, cmd);
}
static void Hidden(Obj self, Sel cmd, B hidden) {
    Obj d = Values(Get(self, "model"));
    Put(d, "beforeHidden", Num(B0(self, "isHidden")));
    Put(d, "requestedHidden", Num(hidden));
    Imp original = Original(self, "fqx164_hidden");
    if (original)
        ((void (*)(Obj, Sel, B))original)(self, cmd, hidden);
    Put(d, "afterHidden", Num(B0(self, "isHidden")));
    Emit("commentBubbleHidden", "FQCReaderParagraphEndView", self, Context(), d);
}
static void Removed(Obj self, Sel cmd) {
    Obj d = Values(Get(self, "model"));
    Imp original = Original(self, "fqx164_removed");
    if (original)
        ((void (*)(Obj, Sel))original)(self, cmd);
    Emit("commentBubbleRemoved", "FQCReaderParagraphEndView", self, Context(), d);
}
static void Window(Obj self, Sel cmd) {
    Imp original = Original(self, "fqx164_window");
    if (original)
        ((void (*)(Obj, Sel))original)(self, cmd);
    Obj d = Values(Get(self, "model"));
    Put(d, "attached", Num(Get(self, "window") != 0));
    Emit("commentBubbleAttachment", "FQCReaderParagraphEndView", self, Context(), d);
}
static void Released(Obj self, Sel cmd) {
    if (objc_getAssociatedObject(self, ObjectKey))
        Emit("commentBubbleDealloc", "FQCReaderParagraphEndView", self, Context(), Dict());
    Imp original = Original(self, "fqx164_dealloc");
    if (original)
        ((void (*)(Obj, Sel))original)(self, cmd);
}
static void ModelCount(Obj self, Sel cmd, I value, const char *alias, const char *cls) {
    Obj d = Dict();
    Put(d, "before", Values(self));
    Put(d, "newValue", Num(value));
    Imp original = Original(self, alias);
    if (original)
        ((void (*)(Obj, Sel, I))original)(self, cmd, value);
    Put(d, "after", Values(self));
    Put(d, "source", Text("modelSetter"));
    Emit("commentCountChanged", cls, self, Context(), d);
}
static void EntranceCount(Obj o, Sel s, I n) {
    ModelCount(o, s, n, "fqx164_entranceCount", "FQCParagraphEntranceViewModel");
}
static void EntranceOrigin(Obj o, Sel s, I n) {
    ModelCount(o, s, n, "fqx164_entranceOrigin", "FQCParagraphEntranceViewModel");
}
static void DataCount(Obj o, Sel s, I n) {
    ModelCount(o, s, n, "fqx164_dataCount", "SSParagraphIdeaDataVal");
}
static void DataRaw(Obj o, Sel s, I n) {
    ModelCount(o, s, n, "fqx164_dataRaw", "SSParagraphIdeaDataVal");
}
static void BubbleData(Obj self, Sel cmd, Obj value) {
    Obj d = Dict();
    Put(d, "before", Values(self));
    Put(d, "incomingPresent", Num(value != 0));
    Put(d, "incomingCount", Num(Count(value, "count")));
    Imp original = Original(self, "fqx164_bubbleData");
    if (original)
        ((void (*)(Obj, Sel, Obj))original)(self, cmd, value);
    Put(d, "after", Values(self));
    Emit("commentDataReplaced", "SSParagraphIdeaDataVal", self, Context(), d);
}
static void Open(Obj self, Sel cmd, Obj params) {
    Obj correlation = Context();
    objc_setAssociatedObject(self, ContextKey, correlation, 0x301);
    Emit("commentPanelOpenBegin", "SSReaderParagraphCommentAdapter", self, correlation, Dict());
    Imp original = Original(self, "fqx164_open");
    if (original)
        ((void (*)(Obj, Sel, Obj))original)(self, cmd, params);
    Obj token = Get(self, "paragraphCommentPanelSessionToken");
    objc_setAssociatedObject(token, PanelKey, correlation, 0x301);
    Obj d = Dict();
    Put(d, "sessionTokenId", Id(token));
    Emit("commentPanelOpenReturned", "SSReaderParagraphCommentAdapter", self, correlation, d);
}
static void Dismiss(Obj self, Sel cmd, Obj token) {
    Obj correlation = objc_getAssociatedObject(token, PanelKey);
    if (!correlation)
        correlation = objc_getAssociatedObject(self, ContextKey);
    Emit("commentPanelDismissBegin", "SSReaderParagraphCommentAdapter", self, correlation, Dict());
    Imp original = Original(self, "fqx164_dismiss");
    if (original)
        ((void (*)(Obj, Sel, Obj))original)(self, cmd, token);
    Emit("commentPanelDismissReturned", "SSReaderParagraphCommentAdapter", self, correlation,
         Dict());
}
static void Panel(Obj self, Sel cmd, B animated, const char *alias, const char *event) {
    Obj correlation = objc_getAssociatedObject(self, ContextKey);
    if (!correlation) {
        correlation = Context();
        objc_setAssociatedObject(self, ContextKey, correlation, 0x301);
    }
    Imp original = Original(self, alias);
    if (original)
        ((void (*)(Obj, Sel, B))original)(self, cmd, animated);
    Emit(event, "FQCParagraphCommentListViewController", self, correlation, Dict());
}
static void Appeared(Obj o, Sel s, B b) {
    Panel(o, s, b, "fqx164_appeared", "commentPanelDidAppear");
}
static void WillDisappear(Obj o, Sel s, B b) {
    Panel(o, s, b, "fqx164_willDisappear", "commentPanelWillDisappear");
}
static void Disappeared(Obj o, Sel s, B b) {
    Panel(o, s, b, "fqx164_disappeared", "commentPanelDidDisappear");
}
static void Commit(Obj self, Sel cmd, Obj chapter, Obj book, I paragraph, I count) {
    Obj d = Dict();
    Put(d, "chapterId", Pseudonym(chapter));
    Put(d, "bookId", Pseudonym(book));
    Put(d, "paragraphIndex", Num(paragraph));
    Put(d, "count", Num(count));
    Put(d, "source", Text("commentListCompletion"));
    Emit("commentCountCommitBegin", "SSReaderCommunityDataManager", self, Context(), d);
    Imp original = Original(self, "fqx164_commit");
    if (original)
        ((void (*)(Obj, Sel, Obj, Obj, I, I))original)(self, cmd, chapter, book, paragraph, count);
    Emit("commentCountCommitReturned", "SSReaderCommunityDataManager", self, Context(), d);
}
static void Cache(Obj self, Sel cmd, Obj chapter, Obj data) {
    Obj d = Dict();
    Put(d, "chapterId", Pseudonym(chapter));
    Put(d, "dataPresent", Num(data != 0));
    Put(d, "stage", Text("cacheWriteCall"));
    Imp original = Original(self, "fqx164_cache");
    if (original)
        ((void (*)(Obj, Sel, Obj, Obj))original)(self, cmd, chapter, data);
    Put(d, "result", Text("returned"));
    Emit("commentCacheWrite", "FQCCommunityReaderDataDispatcher", self, Context(), d);
}

static void PageEvent(Obj self, Sel cmd, B animated, const char *alias, const char *cls,
                      const char *event) {
    Obj correlation = objc_getAssociatedObject(self, ContextKey);
    if (!correlation) {
        correlation = Context();
        objc_setAssociatedObject(self, ContextKey, correlation, 0x301);
    }
    Imp original = Original(self, alias);
    if (original)
        ((void (*)(Obj, Sel, B))original)(self, cmd, animated);
    if (B1(Text(event), "isEqualToString:", Text("pageDidAppear")))
        FQDLoadStage("firstPageDidAppear");
    Emit(event, cls, self, correlation, Dict());
}
#define PAGE_PAIR(name, cls)                                                                       \
    static void name##Load(Obj o, Sel s) {                                                         \
        Imp p = Original(o, "fqx164_" #name "Load");                                               \
        if (p)                                                                                     \
            ((void (*)(Obj, Sel))p)(o, s);                                                         \
        Emit("pageDidLoad", cls, o, Context(), Dict());                                            \
    }                                                                                              \
    static void name##Appear(Obj o, Sel s, B b) {                                                  \
        PageEvent(o, s, b, "fqx164_" #name "Appear", cls, "pageDidAppear");                        \
    }                                                                                              \
    static void name##Disappear(Obj o, Sel s, B b) {                                               \
        PageEvent(o, s, b, "fqx164_" #name "Disappear", cls, "pageDidDisappear");                  \
    }
PAGE_PAIR(Reader, "BDReaderViewController")
PAGE_PAIR(Store, "SSBookStoreNewViewController")
PAGE_PAIR(Shelf, "SSBookShelf525ViewController")
PAGE_PAIR(Mine, "SSMine737KMPViewController")
PAGE_PAIR(ShortVideo, "SSShortVideoRcmdMainViewController")

static const char *RequestPath(Obj request) {
    Obj method = Get(request, "method");
    Obj value = Get(method, "operationType");
    // This field originates outside the plugin. Unknown values must not turn
    // an unrelated startup request into an unrecognized-selector exception.
    if (!Kind(value, "NSString"))
        return (const char *)0;
    if (B1(value, "isEqualToString:", Text("$POST /novel/commentapi/idea/list/:item_id/v1/")))
        return "idea/list/:item_id/v1";
    if (B1(value, "isEqualToString:", Text("$POST /novel/commentapi/comment/list/:group_id/v1/")))
        return "comment/list/:group_id/v1";
    return (const char *)0;
}
static Obj RequestInit(Obj self, Sel cmd, Obj request, Obj completion) {
    Imp original = Original(self, "fqx164_requestInit");
    Obj result =
        original ? ((Obj (*)(Obj, Sel, Obj, Obj))original)(self, cmd, request, completion) : self;
    const char *path = RequestPath(request);
    if (result && path) {
        Obj d = Dict();
        Put(d, "requestId", UUID());
        Put(d, "correlationId", Context());
        Put(d, "path", Text(path));
        Put(d, "method", Text("POST"));
        Put(d, "startedUptime", Clock());
        Obj lock = Lock();
        V0(lock, "lock");
        I ordinal = Q0(At(State(), "requestsIssued"), "longLongValue") + 1;
        Put(State(), "requestsIssued", Num(ordinal));
        Put(d, "requestOrdinal", Num(ordinal));
        V0(lock, "unlock");
        objc_setAssociatedObject(result, RequestKey, d, 0x301);
        objc_setAssociatedObject(request, RequestKey, d, 0x301);
        Emit("commentRequestCreated", "BDRpcAsyncOperation", result, At(d, "correlationId"), d);
    }
    return result;
}
static void RequestSend(Obj self, Sel cmd) {
    Obj context = objc_getAssociatedObject(self, RequestKey);
    if (context) {
        Obj lock = Lock();
        V0(lock, "lock");
        I count = Q0(objc_getAssociatedObject(self, SendsKey), "longLongValue") + 1;
        objc_setAssociatedObject(self, SendsKey, Num(count), 0x301);
        Obj d = O0(context, "mutableCopy");
        Put(d, "sendCount", Num(count));
        V0(lock, "unlock");
        Put(d, "stage", Text("send"));
        Put(d, "retry", Num(count > 1));
        Emit("commentRequestSend", "BDRpcAsyncOperation", self, At(context, "correlationId"), d);
        V0(d, "release");
    }
    Imp original = Original(self, "fqx164_send");
    if (original)
        ((void (*)(Obj, Sel))original)(self, cmd);
}
static void RequestCancel(Obj self, Sel cmd) {
    Obj context = objc_getAssociatedObject(self, RequestKey);
    if (context)
        Emit("commentRequestCancel", "BDRpcAsyncOperation", self, At(context, "correlationId"),
             context);
    Imp original = Original(self, "fqx164_cancel");
    if (original)
        ((void (*)(Obj, Sel))original)(self, cmd);
}
static void Response(Obj self, Sel cmd, Obj result, Obj headers) {
    Obj context = objc_getAssociatedObject(self, RequestKey);
    Imp original = Original(self, "fqx164_response");
    Obj thread = O0(objc_getClass("NSThread"), "currentThread");
    Obj previous = objc_getAssociatedObject(thread, ContextKey);
    O0(previous, "retain");
    if (context) {
        Obj d = O0(context, "mutableCopy");
        Put(d, "resultPresent", Num(result != 0));
        Put(d, "duration", Elapsed(At(context, "startedUptime")));
        Obj lock = Lock();
        V0(lock, "lock");
        I ordinal = Q0(At(context, "requestOrdinal"), "longLongValue");
        I previousOrdinal = Q0(At(State(), "lastResponseOrdinal"), "longLongValue");
        Put(d, "responseOutOfOrder", Num(ordinal < previousOrdinal));
        if (ordinal > previousOrdinal)
            Put(State(), "lastResponseOrdinal", Num(ordinal));
        V0(lock, "unlock");
        Put(d, "resultCount", Num(Count(result, "count")));
        Put(d, "headersPresent", Num(headers != 0));
        Put(d, "jsonStructurePresent", Num(Kind(result, "NSDictionary")));
        if (Kind(result, "NSDictionary")) {
            Obj data = At(result, "data");
            Put(d, "dataFieldPresent", Num(data != 0));
            if (Kind(data, "NSDictionary")) {
                Obj list = At(data, "data_list");
                Put(d, "listFieldPresent", Num(list != 0));
                Put(d, "listCount", Num(Count(list, "count")));
                Put(d, "totalFieldPresent", Num(At(data, "total") != 0));
                Put(d, "paginationFieldPresent", Num(At(data, "has_more") != 0));
            }
        }
        Put(d, "stage", Text("parsedResultBeforeCompletion"));
        Emit("commentResponseParsed", "BDRpcAsyncOperation", self, At(context, "correlationId"), d);
        V0(d, "release");
        objc_setAssociatedObject(thread, ContextKey, At(context, "correlationId"), 0x301);
    }
    if (original)
        ((void (*)(Obj, Sel, Obj, Obj))original)(self, cmd, result, headers);
    objc_setAssociatedObject(thread, ContextKey, previous, 0x301);
    V0(previous, "release");
    if (context)
        Emit("commentResponseDelivered", "BDRpcAsyncOperation", self, At(context, "correlationId"),
             context);
}
static void RequestComplete(Obj self, Sel cmd) {
    Obj context = objc_getAssociatedObject(self, RequestKey);
    if (context) {
        Obj d = O0(context, "mutableCopy");
        Obj error = Get(self, "error");
        Put(d, "errorPresent", Num(error != 0));
        Put(d, "errorCode", Num(Count(error, "code")));
        Put(d, "stage", Text("operationComplete"));
        Emit("commentRequestComplete", "BDRpcAsyncOperation", self, At(context, "correlationId"),
             d);
        V0(d, "release");
    }
    Imp original = Original(self, "fqx164_complete");
    if (original)
        ((void (*)(Obj, Sel))original)(self, cmd);
}
static Obj TransportResponse(Obj self, Sel cmd, Obj request, Obj response) {
    Imp original = Original(self, "fqx164_transport");
    Obj result =
        original ? ((Obj (*)(Obj, Sel, Obj, Obj))original)(self, cmd, request, response) : self;
    Obj context = objc_getAssociatedObject(request, RequestKey);
    if (context) {
        Obj d = O0(context, "mutableCopy");
        Obj raw = Get(result, "rawData");
        Obj error = Get(result, "error");
        Put(d, "statusCode", Num(Count(result, "statusCode")));
        Put(d, "errorCode", Num(Count(error, "code")));
        Put(d, "responseBytes", Num(Kind(raw, "NSData") ? Q0(raw, "length") : -1));
        Put(d, "stage", Text("transportResponse"));
        Emit("commentNetworkResponse", "BDRpcResponse", result, At(context, "correlationId"), d);
        V0(d, "release");
    }
    return result;
}

static void ActionTimeout(Obj self, Sel cmd, Obj token) {
    (void)self;
    (void)cmd;
    Obj lock = Lock();
    V0(lock, "lock");
    I ordinal = Q0(At(State(), "activity"), "longLongValue");
    I pending = Q0(At(State(), "watchdogs"), "longLongValue");
    Put(State(), "watchdogs", Num(pending > 0 ? pending - 1 : 0));
    V0(lock, "unlock");
    if (Enhanced() && ordinal == Q0(At(token, "activity"), "longLongValue")) {
        Obj d = O0(token, "mutableCopy");
        Put(d, "result", Text("noObservedTransition"));
        Put(d, "timeoutSeconds", Num(2));
        Put(d, "coverage", Text("monitoredHostEventsOnly"));
        Emit("uiActionObservationTimeout", "UIApplication", 0, At(token, "correlationId"), d);
        V0(d, "release");
    }
}
static B SendAction(Obj self, Sel cmd, Sel action, Obj target, Obj sender, Obj event) {
    Obj context = Context();
    B capture = Enhanced() && Kind(sender, "UIControl");
    Obj page = sender;
    for (int i = 0; capture && page && i < 12 && !Kind(page, "UIViewController"); i++)
        page = Get(page, "nextResponder");
    capture = capture && Kind(page, "UIViewController");
    Obj d = capture ? Dict() : (Obj)0;
    if (capture) {
        Put(d, "pageId", Id(page));
        Put(d, "controlId", Id(sender));
        Put(d, "enabled", Num(B0(sender, "isEnabled")));
        Emit("uiActionBegin", "UIApplication", sender, context, d);
    }
    Imp original = Original(self, "fqx164_sendAction");
    B result = original ? ((B (*)(Obj, Sel, Sel, Obj, Obj, Obj))original)(self, cmd, action, target,
                                                                          sender, event)
                        : 0;
    if (capture) {
        Obj after = O0(d, "mutableCopy");
        Put(after, "handled", Num(result));
        Emit("uiActionReturned", "UIApplication", sender, context, after);
        V0(after, "release");
        Obj token = O0(d, "mutableCopy");
        Put(token, "correlationId", context);
        Obj lock = Lock();
        V0(lock, "lock");
        Put(token, "activity", At(State(), "activity"));
        I pending = Q0(At(State(), "watchdogs"), "longLongValue");
        if (pending < 64)
            Put(State(), "watchdogs", Num(pending + 1));
        V0(lock, "unlock");
        Obj observer = At(State(), "observer");
        if (pending < 64)
            ((void (*)(Obj, Sel, Sel, Obj, double))objc_msgSend)(
                observer, sel_registerName("performSelector:withObject:afterDelay:"),
                sel_registerName("fqx164_actionTimeout:"), token, 2.0);
        else {
            Obj skipped = Dict();
            Put(skipped, "result", Text("watchdogCapacityReached"));
            Emit("uiActionObservationSkipped", "UIApplication", sender, context, skipped);
        }
        V0(token, "release");
    }
    return result;
}

static void Mode(Obj self, Sel cmd, Obj item) {
    (void)self;
    (void)cmd;
    B value = !Enhanced();
    ((void (*)(Obj, Sel, B, Obj))objc_msgSend)(
        O0(objc_getClass("NSUserDefaults"), "standardUserDefaults"),
        sel_registerName("setBool:forKey:"), value, Text("FanqieX.EnhancedDiagnostics.1"));
    V1(item, "setTitle:", Text(value ? "增强诊断开" : "增强诊断关"));
    Obj d = Dict();
    Put(d, "enhanced", Num(value));
    Emit("diagnosticModeChanged", "FanqieX", self, 0, d);
}
static void Push(Obj self, Sel cmd, Obj controller, B animated) {
    if (Enhanced()) {
        Obj d = Dict();
        Put(d, "targetPageId", Id(controller));
        Emit("navigationPushBegin", "UINavigationController", self, 0, d);
    }
    Imp original = Original(self, "fqx164_push");
    if (original)
        ((void (*)(Obj, Sel, Obj, B))original)(self, cmd, controller, animated);
    if (Enhanced()) {
        Obj d = Dict();
        Put(d, "targetPageId", Id(controller));
        Emit("navigationPushReturned", "UINavigationController", self, 0, d);
    }
}
static Obj Pop(Obj self, Sel cmd, B animated) {
    Imp original = Original(self, "fqx164_pop");
    Obj result = original ? ((Obj (*)(Obj, Sel, B))original)(self, cmd, animated) : (Obj)0;
    if (Enhanced()) {
        Obj d = Dict();
        Put(d, "poppedPageId", Id(result));
        Put(d, "resultPresent", Num(result != 0));
        Emit("navigationPopReturned", "UINavigationController", self, 0, d);
    }
    return result;
}
static void Exception(Obj self, Sel cmd) {
    Obj thread = O0(objc_getClass("NSThread"), "currentThread");
    if (!objc_getAssociatedObject(thread, ExceptionKey)) {
        objc_setAssociatedObject(thread, ExceptionKey, self, 0);
        Obj d = Dict();
        Put(d, "exceptionPresent", Num(1));
        Put(d, "coverage", Text("ObjectiveCExceptionRaise"));
        Emit("exceptionRaise", "NSException", self, 0, d);
        objc_setAssociatedObject(thread, ExceptionKey, 0, 0);
    }
    // A host exception can unwind a scoped response callback before it returns.
    objc_setAssociatedObject(thread, ContextKey, 0, 0x301);
    Imp original = Original(self, "fqx164_exception");
    if (original)
        ((void (*)(Obj, Sel))original)(self, cmd);
}
void FQDSettings(Obj controller) {
    class_addMethod(object_getClass(controller), sel_registerName("fqx164_diagnosticMode:"),
                    (Imp)Mode, "v24@0:8@16");
    Obj nav = Get(controller, "navigationItem");
    Obj done = Get(nav, "rightBarButtonItem");
    Obj allocated = O0(objc_getClass("UIBarButtonItem"), "alloc");
    Obj item = ((Obj (*)(Obj, Sel, Obj, I, Obj, Sel))objc_msgSend)(
        allocated, sel_registerName("initWithTitle:style:target:action:"),
        Text(Enhanced() ? "增强诊断开" : "增强诊断关"), 0, controller,
        sel_registerName("fqx164_diagnosticMode:"));
    if (item) {
        Obj items[2];
        items[0] = done ? done : item;
        items[1] = item;
        Obj array = ((Obj (*)(Obj, Sel, Obj *, U))objc_msgSend)(
            objc_getClass("NSArray"), sel_registerName("arrayWithObjects:count:"), items,
            done ? 2 : 1);
        V1(nav, "setRightBarButtonItems:", array);
        V0(item, "release");
    }
}
static void Install(const char *cls, const char *selector, const char *encoding, const char *alias,
                    Imp replacement) {
    Obj target = objc_getClass(cls);
    Sel sel = sel_registerName(selector);
    Method method = FQDResolveOwned(target, sel, 0, encoding);
    if (!method)
        return;
    Imp original = method_getImplementation(method);
    if (!class_addMethod(target, sel_registerName(alias), original, encoding))
        return;
    method_setImplementation(method, replacement);
}
void FQDInstall(void) {
    FQDLoadStage("diagnosticsInstallBegin");
    if (!State()) {
        Obj state = Dict();
        Obj lock = O0(O0(objc_getClass("NSLock"), "alloc"), "init");
        Put(state, "lock", lock);
        V0(lock, "release");
        Put(state, "ruleCounts", Dict());
        Put(state, "identityLabels", Dict());
        Put(state, "identityGeneration", Num(0));
        Obj observerClass = objc_getClass("FanqieXDiagnosticsObserver");
        if (!observerClass) {
            observerClass =
                objc_allocateClassPair(objc_getClass("NSObject"), "FanqieXDiagnosticsObserver", 0);
            if (observerClass) {
                class_addMethod(observerClass, sel_registerName("fqx164_actionTimeout:"),
                                (Imp)ActionTimeout, "v24@0:8@16");
                objc_registerClassPair(observerClass);
            }
        }
        Obj observer = O0(O0(observerClass, "alloc"), "init");
        Put(state, "observer", observer);
        V0(observer, "release");
        objc_setAssociatedObject(Root(), StateKey, state, 0x301);
    }
    Install("FQCReaderParagraphEndView", "setModel:", "v24@0:8@16", "fqx164_bind", (Imp)Bind);
    Install("FQCReaderParagraphEndView", "updateIdeaLabelCount", "v16@0:8", "fqx164_bubbleUpdate",
            (Imp)BubbleUpdate);
    Install("FQCReaderParagraphEndView", "ideaCountTap", "v16@0:8", "fqx164_bubbleTap",
            (Imp)BubbleTap);
    Install("FQCReaderParagraphEndView", "setHidden:", "v20@0:8B16", "fqx164_hidden", (Imp)Hidden);
    Install("FQCReaderParagraphEndView", "removeFromSuperview", "v16@0:8", "fqx164_removed",
            (Imp)Removed);
    Install("FQCReaderParagraphEndView", "didMoveToWindow", "v16@0:8", "fqx164_window",
            (Imp)Window);
    Install("FQCReaderParagraphEndView", "dealloc", "v16@0:8", "fqx164_dealloc", (Imp)Released);
    Install("FQCParagraphEntranceViewModel", "setIdeaCount:", "v24@0:8q16", "fqx164_entranceCount",
            (Imp)EntranceCount);
    Install("FQCParagraphEntranceViewModel", "setIdeaOriginCount:", "v24@0:8q16",
            "fqx164_entranceOrigin", (Imp)EntranceOrigin);
    Install("SSParagraphIdeaDataVal", "setIdeaCount:", "v24@0:8q16", "fqx164_dataCount",
            (Imp)DataCount);
    Install("SSParagraphIdeaDataVal", "set_ideaCount:", "v24@0:8q16", "fqx164_dataRaw",
            (Imp)DataRaw);
    Install("SSParagraphIdeaDataVal", "setBubbleData:", "v24@0:8@16", "fqx164_bubbleData",
            (Imp)BubbleData);
    Install("SSReaderParagraphCommentAdapter",
            "showParagraphCommentVCWithOpenParams:", "v24@0:8@16", "fqx164_open", (Imp)Open);
    Install("SSReaderParagraphCommentAdapter",
            "paragraphCommentPanelDidDismissForSessionToken:", "v24@0:8@16", "fqx164_dismiss",
            (Imp)Dismiss);
    Install("FQCParagraphCommentListViewController", "viewDidAppear:", "v20@0:8B16",
            "fqx164_appeared", (Imp)Appeared);
    Install("FQCParagraphCommentListViewController", "viewWillDisappear:", "v20@0:8B16",
            "fqx164_willDisappear", (Imp)WillDisappear);
    Install("FQCParagraphCommentListViewController", "viewDidDisappear:", "v20@0:8B16",
            "fqx164_disappeared", (Imp)Disappeared);
    Install("SSReaderCommunityDataManager",
            "paragraphIdeaUpdateCountWithChapterId:bookId:paraIndex:count:", "v48@0:8@16@24q32q40",
            "fqx164_commit", (Imp)Commit);
    Install("FQCCommunityReaderDataDispatcher",
            "saveParagraphIdeaListIntoCacheWithChapterId:paragraphListData:", "v32@0:8@16@24",
            "fqx164_cache", (Imp)Cache);
    Install("BDRpcAsyncOperation", "initWithRequest:completion:", "@32@0:8@16@?24",
            "fqx164_requestInit", (Imp)RequestInit);
    Install("BDRpcAsyncOperation", "sendRequest", "v16@0:8", "fqx164_send", (Imp)RequestSend);
    Install("BDRpcAsyncOperation", "cancel", "v16@0:8", "fqx164_cancel", (Imp)RequestCancel);
    Install("BDRpcAsyncOperation", "completeOperation", "v16@0:8", "fqx164_complete",
            (Imp)RequestComplete);
    Install("BDRpcAsyncOperation", "_postHandleResult:headerFields:", "v32@0:8@16@24",
            "fqx164_response", (Imp)Response);
    Install("BDRpcResponse", "initWithRequest:response:", "@32@0:8@16@24", "fqx164_transport",
            (Imp)TransportResponse);
    Install("UIApplication", "sendAction:to:from:forEvent:", "B48@0:8:16@24@32@40",
            "fqx164_sendAction", (Imp)SendAction);
    Install("UINavigationController", "pushViewController:animated:", "v28@0:8@16B24",
            "fqx164_push", (Imp)Push);
    Install("UINavigationController", "popViewControllerAnimated:", "@20@0:8B16", "fqx164_pop",
            (Imp)Pop);
    Install("NSException", "raise", "v16@0:8", "fqx164_exception", (Imp)Exception);
#define INSTALL_PAGE(name, cls)                                                                    \
    Install(cls, "viewDidLoad", "v16@0:8", "fqx164_" #name "Load", (Imp)name##Load);               \
    Install(cls, "viewDidAppear:", "v20@0:8B16", "fqx164_" #name "Appear", (Imp)name##Appear);     \
    Install(cls, "viewDidDisappear:", "v20@0:8B16", "fqx164_" #name "Disappear",                   \
            (Imp)name##Disappear);
    INSTALL_PAGE(Reader, "BDReaderViewController")
    INSTALL_PAGE(Store, "SSBookStoreNewViewController")
    INSTALL_PAGE(Shelf, "SSBookShelf525ViewController")
    INSTALL_PAGE(Mine, "SSMine737KMPViewController")
    INSTALL_PAGE(ShortVideo, "SSShortVideoRcmdMainViewController")
    FQDLoadStage("diagnosticsInstallComplete");
}

void FQDAdDecision(Obj object, Sel selector, I rule, const char *cls, const char *method, I kind) {
    (void)selector;
    Obj start = Clock();
    Obj lock = Lock();
    V0(lock, "lock");
    Obj counts = At(State(), "ruleCounts");
    Obj key = Num(rule);
    I count = Q0(O1(counts, "objectForKey:", key), "longLongValue") + 1;
    ((void (*)(Obj, Sel, Obj, Obj))objc_msgSend)(counts, sel_registerName("setObject:forKey:"),
                                                 Num(count), key);
    V0(lock, "unlock");
    Obj d = Dict();
    Put(d, "ruleId", Num(rule));
    Put(d, "ruleType", Text("exactHostMethod"));
    Put(d, "selector", Text(method));
    Put(d, "matched", Num(1));
    Put(d, "result", Text(kind < 8 ? "blocked" : "skipped"));
    Put(d, "callCount", Num(count));
    Put(d, "duration", Elapsed(start));
    Put(d, "methodOwnedByTarget", Num(1));
    Put(d, "inputSummary", Text("argumentsOmitted"));
    Put(d, "pageDisplay", Text("unobserved"));
    Emit("adRuleDecision", cls, object, Context(), d);
}
