#import "FQXHookInstaller.h"
#import <pthread.h>
#include <stdint.h>
#import <stdlib.h>
#import <string.h>

typedef struct {
    uintptr_t owner;
    SEL sel;
    uint8_t classMethod;
} FQXHookKey;

static pthread_mutex_t FQXHookLock = PTHREAD_MUTEX_INITIALIZER;
static FQXHookKey *FQXHookTable = NULL;
static size_t FQXHookCap = 0;
static size_t FQXHookCount = 0;

static inline size_t FQXHookHash(uintptr_t owner, SEL sel, uint8_t clsMethod) {
    uintptr_t selAddr = (uintptr_t)sel_getName(sel);
    uint64_t h = ((uint64_t)owner * 11400714819323198485ULL) ^
                 ((uint64_t)selAddr * 14029467366897019727ULL) ^
                 ((uint64_t)clsMethod * 0x9e3779b97f4a7c15ULL);
    h ^= h >> 33;
    h *= 0xff51afd7ed558ccdULL;
    h ^= h >> 33;
    return (size_t)h;
}

static BOOL FQXHookTableContains(uintptr_t owner, SEL sel, uint8_t clsMethod) {
    if (!FQXHookTable || FQXHookCap == 0) return NO;
    size_t mask = FQXHookCap - 1;
    size_t idx = FQXHookHash(owner, sel, clsMethod) & mask;
    for (;;) {
        FQXHookKey entry = FQXHookTable[idx];
        if (entry.owner == 0) return NO;
        if (entry.owner == owner && sel_isEqual(entry.sel, sel) && entry.classMethod == clsMethod) return YES;
        idx = (idx + 1) & mask;
    }
}

static void FQXHookTableInsert(uintptr_t owner, SEL sel, uint8_t clsMethod) {
    if (!FQXHookTable || (FQXHookCount + 1) * 10 >= FQXHookCap * 7) {
        size_t newCap = FQXHookCap ? (FQXHookCap * 2) : 1024;
        FQXHookKey *newTable = (FQXHookKey *)calloc(newCap, sizeof(FQXHookKey));
        if (!newTable) return;
        size_t newMask = newCap - 1;
        for (size_t i = 0; i < FQXHookCap; ++i) {
            if (FQXHookTable[i].owner != 0) {
                size_t idx = FQXHookHash(FQXHookTable[i].owner, FQXHookTable[i].sel, FQXHookTable[i].classMethod) & newMask;
                while (newTable[idx].owner != 0) idx = (idx + 1) & newMask;
                newTable[idx] = FQXHookTable[i];
            }
        }
        free(FQXHookTable);
        FQXHookTable = newTable;
        FQXHookCap = newCap;
    }
    size_t mask = FQXHookCap - 1;
    size_t idx = FQXHookHash(owner, sel, clsMethod) & mask;
    while (FQXHookTable[idx].owner != 0) {
        if (FQXHookTable[idx].owner == owner &&
            sel_isEqual(FQXHookTable[idx].sel, sel) &&
            FQXHookTable[idx].classMethod == clsMethod) return;
        idx = (idx + 1) & mask;
    }
    FQXHookTable[idx].owner = owner;
    FQXHookTable[idx].sel = sel;
    FQXHookTable[idx].classMethod = clsMethod;
    FQXHookCount += 1;
}

BOOL FQXInstallOwnedHook(Class target, SEL selector, BOOL classMethod,
                         const char *expectedEncoding, IMP replacement, IMP *original) {
    if (!target || !selector || !expectedEncoding || !replacement) return NO;
    Class owner = classMethod ? object_getClass(target) : target;
    if (!owner) return NO;
    uintptr_t ownerKey = (uintptr_t)(__bridge void *)owner;
    uint8_t clsFlag = classMethod ? 1 : 0;

    pthread_mutex_lock(&FQXHookLock);
    if (FQXHookTableContains(ownerKey, selector, clsFlag)) {
        pthread_mutex_unlock(&FQXHookLock);
        return NO;
    }
    Method resolved = class_getInstanceMethod(owner, selector);
    if (!resolved) {
        pthread_mutex_unlock(&FQXHookLock);
        return NO;
    }
    const char *encoding = method_getTypeEncoding(resolved);
    if (!encoding || strcmp(encoding, expectedEncoding) != 0) {
        pthread_mutex_unlock(&FQXHookLock);
        return NO;
    }
    IMP previous = method_getImplementation(resolved);
    if (!previous || previous == replacement) {
        pthread_mutex_unlock(&FQXHookLock);
        return NO;
    }
    Class superCls = class_getSuperclass(owner);
    Method superMethod = superCls ? class_getInstanceMethod(superCls, selector) : NULL;
    Method own = (resolved != superMethod) ? resolved : NULL;
    if (!own) {
        class_addMethod(owner, selector, previous, encoding);
        own = class_getInstanceMethod(owner, selector);
        if (own == superMethod) own = NULL;
    }
    if (!own || strcmp(method_getTypeEncoding(own), expectedEncoding) != 0) {
        pthread_mutex_unlock(&FQXHookLock);
        return NO;
    }
    previous = method_getImplementation(own);
    if (!previous || previous == replacement) {
        pthread_mutex_unlock(&FQXHookLock);
        return NO;
    }
    if (original) *original = previous;
    method_setImplementation(own, replacement);
    FQXHookTableInsert(ownerKey, selector, clsFlag);
    pthread_mutex_unlock(&FQXHookLock);
    return YES;
}
