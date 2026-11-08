// The pinned plugin's legacy glass and ad installers get their Method from
// image offset 0x4878, then call method_setImplementation. A runtime lookup
// can return a superclass Method. Localize it before exposing it to callers.
LHookOwned:
    cbz x0, LHookMissing
    cbz x1, LHookMissing
    cbz x3, LHookMissing
    stp x29, x30, [sp, #-80]!
    mov x29, sp
    stp x19, x20, [sp, #16]
    stp x21, x22, [sp, #32]
    stp x23, x24, [sp, #48]
    stp x25, x26, [sp, #64]
    mov x19, x0                          // target class
    mov x20, x1                          // selector
    mov w21, w2                          // class method flag
    mov x22, x3                          // expected type encoding
    bl LHookResolve
    cbz x0, LHookDecline
    mov x23, x0

    // This image has no class_getSuperclass import. Use NSObject's typed
    // +superclass IMP, so a host override on the target is never called.
    adr x0, LHookNSObject
    bl Lpatch + (0xa5b0 - PATCH_BASE)     // objc_getClass
    cbz x0, LHookDecline
    mov x24, x0
    adr x0, LHookSuperclass
    bl Lpatch + (0xa5a4 - PATCH_BASE)     // sel_registerName
    mov x25, x0
    mov x0, x24
    mov x1, x25
    mov w2, #1
    adr x3, LHookSuperclassType
    bl LHookResolve
    cbz x0, LHookDecline
    bl Lpatch + (0xa598 - PATCH_BASE)     // method_getImplementation
    cbz x0, LHookDecline
    mov x8, x0
    mov x0, x19
    mov x1, x25
    blr x8
    // A root metaclass may resolve a method in its own root class.
    cbz x0, LHookDecline
    mov x26, x0
    bl LHookLookupSuperclass
    cmp x0, x23
    b.ne LHookReturnOwned

    mov x0, x23
    bl Lpatch + (0xa598 - PATCH_BASE)
    cbz x0, LHookDecline
    mov x24, x0
    mov x0, x23
    bl Lpatch + (0xa5ec - PATCH_BASE)     // method_getTypeEncoding
    cbz x0, LHookDecline
    mov x25, x0
    mov x0, x19
    cbz w21, LHookAdd
    bl Lpatch + (0xa664 - PATCH_BASE)     // object_getClass: target metaclass
    cbz x0, LHookDecline
LHookAdd:
    mov x1, x20
    mov x2, x24
    mov x3, x25
    bl Lpatch + (0xa58c - PATCH_BASE)     // class_addMethod
    cbz w0, LHookDecline
    mov x0, x19
    mov x1, x20
    mov w2, w21
    mov x3, x22
    bl LHookResolve
    cbz x0, LHookDecline
    mov x23, x0
    bl LHookLookupSuperclass
    cmp x0, x23
    b.eq LHookDecline
LHookReturnOwned:
    mov x0, x23
    b LHookReturn
LHookDecline:
    mov x0, #0
LHookReturn:
    ldp x25, x26, [sp, #64]
    ldp x23, x24, [sp, #48]
    ldp x21, x22, [sp, #32]
    ldp x19, x20, [sp, #16]
    ldp x29, x30, [sp], #80
    ret
LHookLookupSuperclass:
    mov x0, x26
    cbz x0, LHookMissing
    mov x1, x20
    cbnz w21, LHookLookupClassMethod
    b Lpatch + (0xa5f8 - PATCH_BASE)     // class_getInstanceMethod
LHookLookupClassMethod:
    b Lpatch + (0xa604 - PATCH_BASE)     // class_getClassMethod
LHookResolve:
    cbz x0, LHookMissing
    b Lpatch + (0x487c - PATCH_BASE)     // original typed lookup after redirect
LHookMissing:
    mov x0, #0
    ret
// @COMPONENT_DATA
LHookNSObject:       .asciz "NSObject"
LHookSuperclass:     .asciz "superclass"
LHookSuperclassType: .asciz "#16@0:8"
