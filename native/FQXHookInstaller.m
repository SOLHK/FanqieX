#import "FQXHookInstaller.h"
#import <pthread.h>
#import <stdlib.h>
#import <string.h>
static pthread_mutex_t FQXHookLock = PTHREAD_MUTEX_INITIALIZER;
static NSMutableSet<NSString *> *FQXInstalledHooks;
static Method FQXOwnMethod(Class cls, SEL selector) {
    unsigned int count=0; Method *methods=class_copyMethodList(cls,&count); Method found=NULL;
    for(unsigned int i=0;i<count;++i) if(method_getName(methods[i])==selector){found=methods[i];break;}
    free(methods); return found;
}
BOOL FQXInstallOwnedHook(Class target, SEL selector, BOOL classMethod,
                         const char *expectedEncoding, IMP replacement, IMP *original) {
    if(!target||!selector||!expectedEncoding||!replacement)return NO;
    Class owner=classMethod?object_getClass(target):target; if(!owner)return NO;
    pthread_mutex_lock(&FQXHookLock);
    if(!FQXInstalledHooks) FQXInstalledHooks=[NSMutableSet set];
    NSString *identity=[NSString stringWithFormat:@"%p:%p:%d",(void *)owner,(void *)selector,classMethod];
    if([FQXInstalledHooks containsObject:identity]){pthread_mutex_unlock(&FQXHookLock);return NO;}
    Method own=FQXOwnMethod(owner,selector);
    Method resolved=own?:class_getInstanceMethod(owner,selector);
    if(!resolved){pthread_mutex_unlock(&FQXHookLock);return NO;}
    const char *encoding=method_getTypeEncoding(resolved);
    if(!encoding||strcmp(encoding,expectedEncoding)!=0){pthread_mutex_unlock(&FQXHookLock);return NO;}
    IMP previous=method_getImplementation(resolved);
    if(!previous||previous==replacement){pthread_mutex_unlock(&FQXHookLock);return NO;}
    if(!own){class_addMethod(owner,selector,previous,encoding);own=FQXOwnMethod(owner,selector);}
    if(!own||strcmp(method_getTypeEncoding(own),expectedEncoding)!=0){
        pthread_mutex_unlock(&FQXHookLock);return NO;
    }
    previous=method_getImplementation(own);
    if(!previous||previous==replacement){pthread_mutex_unlock(&FQXHookLock);return NO;}
    if(original)*original=previous;
    method_setImplementation(own,replacement);
    [FQXInstalledHooks addObject:identity];
    pthread_mutex_unlock(&FQXHookLock);return YES;
}
