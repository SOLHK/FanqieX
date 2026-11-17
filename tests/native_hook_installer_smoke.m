#import <Foundation/Foundation.h>
#include <stdio.h>
#import <objc/runtime.h>
#import "FQXHookInstaller.h"

@interface FQXHookBase : NSObject
- (NSInteger)value;
+ (NSInteger)classValue;
@end
@implementation FQXHookBase
- (NSInteger)value { return 3; }
+ (NSInteger)classValue { return 7; }
@end
@interface FQXHookChild : FQXHookBase @end
@implementation FQXHookChild @end
@interface FQXHookSibling : FQXHookBase @end
@implementation FQXHookSibling @end

static IMP InstanceOriginal;
static NSInteger InstanceReplacement(id self, SEL cmd) {
    return ((NSInteger(*)(id,SEL))InstanceOriginal)(self,cmd)+10;
}
static IMP ClassOriginal;
static NSInteger ClassReplacement(id self, SEL cmd) {
    return ((NSInteger(*)(id,SEL))ClassOriginal)(self,cmd)+20;
}
#define REQUIRE(c,m) do { if(!(c)){fprintf(stderr,"FAIL: %s\n",m);return 1;} } while(0)
int main(void) {
    FQXHookChild *child=[FQXHookChild new];
    FQXHookSibling *sibling=[FQXHookSibling new];
    IMP original=NULL;
    REQUIRE(FQXInstallOwnedHook(FQXHookChild.class,@selector(value),NO,"q16@0:8",(IMP)InstanceReplacement,&original),"localize inherited instance method");
    InstanceOriginal=original;
    REQUIRE([child value]==13,"replacement calls saved superclass implementation");
    REQUIRE([sibling value]==3,"sibling behavior remains untouched");
    REQUIRE([[FQXHookBase new] value]==3,"superclass behavior remains untouched");
    REQUIRE(!FQXInstallOwnedHook(FQXHookChild.class,@selector(value),NO,"q16@0:8",(IMP)InstanceReplacement,NULL),"duplicate hook declined");
    REQUIRE(!FQXInstallOwnedHook(FQXHookChild.class,@selector(value),NO,"v16@0:8",(IMP)InstanceReplacement,NULL),"ABI mismatch declined");
    original=NULL;
    REQUIRE(FQXInstallOwnedHook(FQXHookChild.class,@selector(classValue),YES,"q16@0:8",(IMP)ClassReplacement,&original),"localize inherited class method");
    ClassOriginal=original;
    REQUIRE([FQXHookChild classValue]==27,"class method uses metaclass ownership");
    REQUIRE([FQXHookSibling classValue]==7 && [FQXHookBase classValue]==7,"metaclass siblings and superclass remain untouched");
    puts("owned Objective-C hook installer: passed");
    return 0;
}
