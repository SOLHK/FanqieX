#include <assert.h>
#include <stdatomic.h>

static _Atomic int sLastObservedGateStateMask = -1;
static _Atomic int storedMask;
static int reads, refreshes, notifyDuringRead;

#ifdef REAL_FOUNDATION
#import <Foundation/Foundation.h>
#import <dispatch/dispatch.h>

static void postChange(void) {
    [NSNotificationCenter.defaultCenter postNotificationName:NSUserDefaultsDidChangeNotification object:nil];
}

static void drainMain(void) {
    __block BOOL reached = NO;
    dispatch_async(dispatch_get_main_queue(), ^{ reached = YES; });
    while (!reached) {
        [NSRunLoop.currentRunLoop runUntilDate:[NSDate dateWithTimeIntervalSinceNow:0.01]];
    }
}
#else
// Non-Darwin fixture for the two noncapturing production blocks.
void *_NSConcreteGlobalBlock[32];
static void (^onNotification)(void);
static void (^mainWork)(void);
static void postChange(void) { onNotification(); }
static int dispatch_get_main_queue(void) { return 1; }
static void dispatch_async(int queue, void (^work)(void)) {
    assert(queue == 1 && !mainWork);
    mainWork = work;
}
static void drainMain(void) {
    while (mainWork) {
        void (^current)(void) = mainWork;
        mainWork = 0;
        current();
    }
}
#endif

static int FQXCurrentPendantAndAudioGateStateMask(void) {
#ifdef REAL_FOUNDATION
    assert(NSThread.isMainThread);
#endif
    ++reads;
    int snapshot = atomic_load(&storedMask);
    if (notifyDuringRead) {
        notifyDuringRead = 0;
        atomic_store(&storedMask, 3);
        postChange();
    }
    return snapshot;
}

static void FQXRefreshReaderAndAudioPendants(void) {
#ifdef REAL_FOUNDATION
    assert(NSThread.isMainThread);
#endif
    ++refreshes;
}

static void installObserver(void) {
#include "defaults_observer.inc"
}

static void postBurst(void) {
    atomic_store(&storedMask, 1);
    for (int i = 0; i < 32; ++i) postChange();
}

int main(void) {
    installObserver();
#ifdef REAL_FOUNDATION
    dispatch_semaphore_t posted = dispatch_semaphore_create(0);
    dispatch_async(dispatch_get_global_queue(QOS_CLASS_UTILITY, 0), ^{
        postBurst();
        dispatch_semaphore_signal(posted);
    });
    // The startup caller cannot service the main queue while waiting here.
    assert(dispatch_semaphore_wait(posted, dispatch_time(DISPATCH_TIME_NOW, 2 * NSEC_PER_SEC)) == 0);
#else
    postBurst();
#endif
    assert(reads == 1 && refreshes == 0);
    drainMain();
    assert(reads == 2 && refreshes == 1);

    postChange();
    drainMain();
    assert(reads == 3 && refreshes == 1);

    // A write during the main-queue read must schedule another pass.
    atomic_store(&storedMask, 2);
    notifyDuringRead = 1;
    postChange();
    drainMain();
    drainMain();
    assert(reads == 5 && refreshes == 3 && atomic_load(&sLastObservedGateStateMask) == 3);
    return 0;
}
