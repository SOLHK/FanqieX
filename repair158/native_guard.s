// Intercept visibility only on the exact native tab-decoration wrapper class.
// A wrapper owns a weak box, never the bar. Unknown/runtime-altered subclasses
// or a conflicting hook fail closed. No UIView method is replaced here.

LXclaim_native: // wrapper, bar -> 0 rejected, 1 same ownership, 2 new epoch
    stp x29, x30, [sp, #-64]!
    mov x29, sp
    stp x19, x20, [sp, #16]
    stp x21, x22, [sp, #32]
    stp x23, x24, [sp, #48]
    mov x19, x0
    mov x20, x1
    cbz x19, LXclaim_no
    cbz x20, LXclaim_no
    cmp x19, x20
    b.eq LXclaim_no
    bl Lpatch + (0xa664 - PATCH_BASE) // object_getClass, not an overridable -class
    mov x21, x0
    cbz x21, LXclaim_no
    adr x0, LXwrapper_name
    bl Lpatch + (0xa5b0 - PATCH_BASE)
    cmp x0, x21
    b.eq LXclaim_class
    adr x0, LXwrapper_legacy
    bl Lpatch + (0xa5b0 - PATCH_BASE)
    cmp x0, x21
    b.ne LXclaim_no
LXclaim_class:
    mov w23, #2
    AGET x19, LXguard_owner_key
    mov x22, x0
    GET x22, LXany_object
    cbz x0, LXclaim_install
    cmp x0, x20
    b.ne LXclaim_no // Do not steal a live wrapper from another bar.
    mov w23, #1
LXclaim_install:
    mov x0, x21
    adr x1, Lset_hidden
    adr x2, LXguard_alias
    adr x3, LXnative_hidden
    adr x4, LXguard_encoding
    bl Linstall_method
    // The generic installer deliberately rejects inherited aliases. Verify
    // the effective implementation before creating ownership; a subclass's
    // own override must never be mistaken for an installed inherited hook.
    adr x0, Lset_hidden
    bl Lpatch + (0xa5a4 - PATCH_BASE)
    mov x1, x0
    mov x0, x21
    bl Lpatch + (0xa5f8 - PATCH_BASE)
    cbz x0, LXclaim_no
    bl Lpatch + (0xa598 - PATCH_BASE)
    adr x8, LXnative_hidden
    cmp x0, x8
    b.ne LXclaim_no
    adr x0, LXguard_alias
    bl Lpatch + (0xa5a4 - PATCH_BASE)
    mov x1, x0
    mov x0, x21
    bl Lpatch + (0xa5f8 - PATCH_BASE)
    cbz x0, LXclaim_no
    bl Lpatch + (0xa598 - PATCH_BASE)
    cbz x0, LXclaim_no
    adr x8, LXnative_hidden
    cmp x0, x8
    b.eq LXclaim_no
    cbnz x22, LXclaim_box
    adr x0, LShash_class
    adr x1, LSweak_hash
    bl Lfactory
    mov x22, x0
    cbz x22, LXclaim_no
LXclaim_box:
    mov x2, x20
    GET x22, LSadd_object
    ASET x19, LXguard_owner_key, x22, 1
    mov w0, w23
    b LXclaim_done
LXclaim_no:
    mov w0, #0
LXclaim_done:
    ldp x23, x24, [sp, #48]
    ldp x21, x22, [sp, #32]
    ldp x19, x20, [sp, #16]
    ldp x29, x30, [sp], #64
    ret

// Restore only wrappers still owned by this bar. A revoked guard means the
// host reclaimed visibility; an old hidden snapshot must not override it.
// Identity lookup preserves a new epoch's row/guard even when its NSNumber
// differs from the previous row. A different bar's claim is never removed.
LXrelease_native: // oldRows, newRows, expectedBar
    stp x29, x30, [sp, #-80]!
    mov x29, sp
    stp x19, x20, [sp, #16]
    stp x21, x22, [sp, #32]
    stp x23, x24, [sp, #48]
    stp x25, x26, [sp, #64]
    mov x19, x0
    mov x20, x1
    mov x26, x2
    cbz x26, LXrelease_done
    bl Lnewarray
    mov x25, x0
    GET x19, Lcount
    mov x21, x0
    mov x22, #0
LXrelease_loop:
    cmp x22, x21
    b.hs LXrelease_restore
    mov x2, x22
    GET x19, Lobject_at
    mov x23, x0
    mov x2, #1
    GET x23, Lobject_at
    mov x24, x0
    mov x0, x20
    mov x1, x24
    bl Lfind_record
    cbnz x0, LXrelease_next
    AGET x24, LXguard_owner_key
    GET x0, LXany_object
    cmp x0, x26
    b.ne LXrelease_next
    ASET x24, LXguard_owner_key, xzr, 0
    mov x2, x23
    GET x25, LSadd_object
LXrelease_next:
    add x22, x22, #1
    b LXrelease_loop
LXrelease_restore:
    mov x0, x25
    mov x1, #0
    bl Lrestore_removed
LXrelease_done:
    ldp x25, x26, [sp, #64]
    ldp x23, x24, [sp, #48]
    ldp x21, x22, [sp, #32]
    ldp x19, x20, [sp, #16]
    ldp x29, x30, [sp], #80
    ret

LXnative_hidden: // self, original _cmd, BOOL
    stp x29, x30, [sp, #-80]!
    mov x29, sp
    stp x19, x20, [sp, #16]
    stp x21, x22, [sp, #32]
    stp x23, x24, [sp, #48]
    mov x19, x0
    mov x20, x1
    mov w21, w2
    mov x22, #0 // retained weak owner for this invocation
    mov x23, #0 // retained active proxy for this invocation
    mov x24, #0 // self retained only when validating owned visibility
    cbnz w21, LXhidden_call
    AGET x19, LXguard_owner_key
    cbz x0, LXhidden_call
    GET x0, LXany_object
    GET x0, Lretain
    mov x22, x0
    cbz x22, LXhidden_unclaim
    GET x19, Lretain
    mov x24, #1
    AGET x22, Lpatch + (0xeb84 - PATCH_BASE)
    GET x0, Lretain
    mov x23, x0
    mov x0, x22
    mov x1, x23
    bl LXvalid_proxy
    cbz w0, LXhidden_unclaim
    mov x0, x19
    mov x1, x22
    bl LXsame_bottom_rect
    cbz w0, LXhidden_unclaim
    mov w8, #192
    str w8, [sp, #64]
    mov x0, x19
    mov x1, x22
    add x2, sp, #64
    mov w3, #0
    bl LXsafe_tree
    cbz w0, LXhidden_unclaim
    mov w21, #1
    b LXhidden_call
LXhidden_unclaim:
    ASET x19, LXguard_owner_key, xzr, 0
LXhidden_call:
    mov x0, x19
    mov x1, x20
    mov w2, w21
    bl LXnative_original
    GET x23, Lrelease
    GET x22, Lrelease
    cbz x24, LXhidden_done
    GET x19, Lrelease
LXhidden_done:
    ldp x23, x24, [sp, #48]
    ldp x21, x22, [sp, #32]
    ldp x19, x20, [sp, #16]
    ldp x29, x30, [sp], #80
    ret

// Preserve _cmd == setHidden: when invoking the saved implementation. A send
// to the alias would change _cmd and can break UIKit selector-sensitive code.
LXnative_original: // self, original _cmd, BOOL
    stp x29, x30, [sp, #-48]!
    mov x29, sp
    stp x19, x20, [sp, #16]
    stp x21, x22, [sp, #32]
    mov x19, x0
    mov x20, x1
    mov w21, w2
    bl Lpatch + (0xa664 - PATCH_BASE)
    mov x22, x0
    adr x0, LXguard_alias
    bl Lpatch + (0xa5a4 - PATCH_BASE)
    mov x1, x0
    mov x0, x22
    bl Lpatch + (0xa5f8 - PATCH_BASE)
    cbz x0, LXoriginal_fallback
    bl Lpatch + (0xa598 - PATCH_BASE)
    cbz x0, LXoriginal_fallback
    adr x8, LXnative_hidden
    cmp x0, x8
    b.ne LXoriginal_call
LXoriginal_fallback:
    // Only reachable if another runtime mutation removes/corrupts our alias.
    // UIView is never hooked by this module, so its setter is a safe last
    // resort for applying the requested visibility without recursing.
    adr x0, LXguard_view_class
    bl Lpatch + (0xa5b0 - PATCH_BASE)
    mov x22, x0
    adr x0, Lset_hidden
    bl Lpatch + (0xa5a4 - PATCH_BASE)
    mov x1, x0
    mov x0, x22
    bl Lpatch + (0xa5f8 - PATCH_BASE)
    cbz x0, LXoriginal_done
    bl Lpatch + (0xa598 - PATCH_BASE)
    cbz x0, LXoriginal_done
    adr x8, LXnative_hidden
    cmp x0, x8
    b.eq LXoriginal_done
LXoriginal_call:
    mov x16, x0
    mov x0, x19
    mov x1, x20
    mov w2, w21
    ldp x21, x22, [sp, #32]
    ldp x19, x20, [sp, #16]
    ldp x29, x30, [sp], #48
    br x16
LXoriginal_done:
    ldp x21, x22, [sp, #32]
    ldp x19, x20, [sp, #16]
    ldp x29, x30, [sp], #48
    ret

// @COMPONENT_DATA
LXguard_owner_key: .byte 0
LXguard_alias: .asciz "fqab_native157_originalSetHidden:"
LXguard_encoding: .asciz "v20@0:8B16"
LXguard_view_class: .asciz "UIView"
