// Own only a geometrically coincident, UIKit-only duplicate tab decoration.
// All state is per-bar. Unknown/controller/scroll content is a hard rejection.
// The periodic monitor uses a weak owner and runs in common run-loop modes.

LXfront_target: // (bar, proxy): keep foreground buttons above both glass surfaces
    stp x29, x30, [sp, #-48]!
    mov x29, sp
    stp x19, x20, [sp, #16]
    stp x21, x22, [sp, #32]
    mov x19, x0
    mov x20, x1
    AGET x19, Lpatch + (0xeb84 - PATCH_BASE)
    cmp x0, x20
    b.ne LXfront_proxy
    AGET x20, LIoverlay_key
    mov x21, x0
    cbz x21, LXfront_proxy
    GET x21, Lsuperview
    cmp x0, x19
    b.ne LXfront_proxy
    GET x21, Lis_hidden
    cbnz w0, LXfront_proxy
    mov x0, x21
    b LXfront_done
LXfront_proxy:
    mov x0, x20
LXfront_done:
    ldp x21, x22, [sp, #32]
    ldp x19, x20, [sp, #16]
    ldp x29, x30, [sp], #48
    ret

LXupdate: // (bar, proxy), called inside Lrepair's busy scope
    stp x29, x30, [sp, #-32]!
    mov x29, sp
    stp x19, x20, [sp, #16]
    mov x19, x0
    mov x20, x1
    bl LXvalid_proxy
    cbz w0, LXupdate_inactive
    ASET x19, LXproxy_key, x20, 1
    mov x0, x19
    mov x1, x20
    bl LXnative_update
    mov x0, x19
    mov x1, x20
    bl LIupdate
    mov x0, x19
    bl LXmonitor_start
    b LXupdate_done
LXupdate_inactive:
    mov x0, x19
    mov x1, x20
    bl LXrestore
LXupdate_done:
    ldp x19, x20, [sp, #16]
    ldp x29, x30, [sp], #32
    ret

LXrestore: // (bar, proxy); safe when proxy is nil
    stp x29, x30, [sp, #-32]!
    mov x29, sp
    stp x19, x20, [sp, #16]
    mov x19, x0
    mov x20, x1
    cbnz x20, LXrestore_has_proxy
    AGET x19, LXproxy_key
    mov x20, x0
LXrestore_has_proxy:
    mov x0, x19
    bl LFrestore
    GET x20, Lretain
    mov x0, x19
    mov x1, x20
    bl LIrestore
    ASET x19, LXproxy_key, xzr, 0
    GET x20, Lrelease
    mov x0, x19
    bl LXnative_restore
    AGET x19, LXmonitor_key
    cbz x0, LXrestore_done
    mov x20, x0
    AGET x20, LXtimer_key
    GET x0, LXinvalidate
    ASET x20, LXtimer_key, xzr, 0
    ASET x19, LXmonitor_key, xzr, 0
LXrestore_done:
    ldp x19, x20, [sp, #16]
    ldp x29, x30, [sp], #32
    ret

LXvalid_proxy: // bar, proxy -> BOOL
    stp x29, x30, [sp, #-48]!
    mov x29, sp
    stp x19, x20, [sp, #16]
    stp x21, x22, [sp, #32]
    mov x19, x0
    mov x20, x1
    cbz x19, LXvalid_no
    cbz x20, LXvalid_no
    GET x19, Lwindow
    cbz x0, LXvalid_no
    mov x21, x0
    GET x20, Lsuperview
    cmp x0, x19
    b.ne LXvalid_no
    mov x0, x20
    mov x1, x21
    bl Lvisible_to
    cbz w0, LXvalid_no
    GET x20, Lbounds
    FINITE d0, LXvalid_no
    FINITE d1, LXvalid_no
    FINITE d2, LXvalid_no
    FINITE d3, LXvalid_no
    fcmp d2, #0.0
    b.le LXvalid_no
    fcmp d3, #0.0
    b.le LXvalid_no
    mov w0, #1
    b LXvalid_done
LXvalid_no:
    mov w0, #0
LXvalid_done:
    ldp x21, x22, [sp, #32]
    ldp x19, x20, [sp, #16]
    ldp x29, x30, [sp], #48
    ret

LXnative_restore:
    stp x29, x30, [sp, #-32]!
    mov x29, sp
    stp x19, x20, [sp, #16]
    mov x19, x0
    AGET x19, LXnative_key
    GET x0, Lretain
    mov x20, x0
    ASET x19, LXnative_key, xzr, 0
    mov x0, x20
    mov x1, #0
    mov x2, x19
    bl LXrelease_native
    GET x20, Lrelease
    ldp x19, x20, [sp, #16]
    ldp x29, x30, [sp], #32
    ret

LXnative_update:
    stp x29, x30, [sp, #-112]!
    mov x29, sp
    stp x19, x20, [sp, #16]
    stp x21, x22, [sp, #32]
    stp x23, x24, [sp, #48]
    stp x25, x26, [sp, #64]
    mov x19, x0
    bl LXvalid_proxy
    cbz w0, LXnative_inactive
    GET x19, Lwindow
    cbz x0, LXnative_inactive
    mov x1, x0
    mov x0, x19
    bl Lvisible_to
    cbz w0, LXnative_inactive
    GET x19, Lsuperview
    cbz x0, LXnative_inactive
    mov x20, x0
    AGET x19, LXnative_key
    GET x0, Lretain
    mov x21, x0
    bl Lnewarray
    mov x22, x0
    stp x22, x21, [sp, #88]
    str wzr, [sp, #84]
    GET x20, Lsubviews
    mov x23, x0
    GET x23, Lcount
    mov x8, #32
    cmp x0, x8
    csel x24, x0, x8, lo
    mov x25, #0
LXnative_loop:
    cmp x25, x24
    b.hs LXnative_publish
    mov x2, x25
    GET x23, Lobject_at
    mov x26, x0
    cmp x26, x19
    b.eq LXnative_next
    bl Lclass_name
    adr x1, LXwrapper_name
    bl LXstring_equal
    cbnz w0, LXnative_match
    mov x0, x26
    bl Lclass_name
    adr x1, LXwrapper_legacy
    bl LXstring_equal
    cbz w0, LXnative_next
LXnative_match:
    mov x0, x26
    mov x1, x19
    bl LXsame_bottom_rect
    cbz w0, LXnative_next
    mov w8, #192
    str w8, [sp, #80]
    mov x0, x26
    mov x1, x19
    add x2, sp, #80
    mov w3, #0
    bl LXsafe_tree
    cbnz w0, LXnative_capture
    ldr w8, [sp, #84]
    orr w8, w8, #1
    str w8, [sp, #84]
    b LXnative_next
LXnative_capture:
    GET x22, Lcount
    cmp x0, #16
    b.hs LXnative_next
    mov x0, x26
    mov x1, x19
    bl LXclaim_native
    cbz w0, LXnative_next
    cmp w0, #2
    b.ne LXnative_capture_owned
    str xzr, [sp, #96] // New ownership must capture the current hidden value.
LXnative_capture_owned:
    mov x0, x26
    mov x1, x26
    add x2, sp, #80
    bl Lcapture_edge
    str x21, [sp, #96]
LXnative_next:
    add x25, x25, #1
    b LXnative_loop
LXnative_publish:
    ASET x19, LXnative_key, x22, 1
    mov x0, x21
    mov x1, x22
    mov x2, x19
    bl LXrelease_native
    GET x21, Lrelease
    ldr w0, [sp, #84]
    bl Luint
    ASET x19, LXrejected_key, x0, 1
    b LXnative_done
LXnative_inactive:
    mov x0, x19
    bl LXnative_restore
LXnative_done:
    ldp x25, x26, [sp, #64]
    ldp x23, x24, [sp, #48]
    ldp x21, x22, [sp, #32]
    ldp x19, x20, [sp, #16]
    ldp x29, x30, [sp], #112
    ret

// Exact same parent and bottom geometry, no full-screen startup wrapper.
LXsame_bottom_rect: // wrapper, bar -> BOOL
    stp x29, x30, [sp, #-112]!
    mov x29, sp
    stp x19, x20, [sp, #16]
    stp x21, x22, [sp, #32]
    stp d8, d9, [sp, #48]
    stp d10, d11, [sp, #64]
    stp d12, d13, [sp, #80]
    mov x19, x0
    mov x20, x1
    GET x19, Lsuperview
    mov x21, x0
    cbz x21, LXrect_no
    GET x20, Lsuperview
    cmp x0, x21
    b.ne LXrect_no
    GET x19, LSframe
    FINITE d0, LXrect_no
    FINITE d1, LXrect_no
    FINITE d2, LXrect_no
    FINITE d3, LXrect_no
    fcmp d2, #0.0
    b.le LXrect_no
    fcmp d3, #0.0
    b.le LXrect_no
    mov w8, #120
    scvtf d4, w8
    fcmp d3, d4
    b.gt LXrect_no
    fmov d8, d0
    fmov d9, d1
    fmov d10, d2
    fmov d11, d3
    GET x20, LSframe
    FINITE d0, LXrect_no
    FINITE d1, LXrect_no
    FINITE d2, LXrect_no
    FINITE d3, LXrect_no
    fmov d4, #1.0
    fsub d0, d0, d8
    fabs d0, d0
    fcmp d0, d4
    b.gt LXrect_no
    fsub d1, d1, d9
    fabs d1, d1
    fcmp d1, d4
    b.gt LXrect_no
    fsub d2, d2, d10
    fabs d2, d2
    fcmp d2, d4
    b.gt LXrect_no
    fsub d3, d3, d11
    fabs d3, d3
    fcmp d3, d4
    b.gt LXrect_no
    GET x21, Lbounds
    FINITE d1, LXrect_no
    FINITE d3, LXrect_no
    fcmp d3, #0.0
    b.le LXrect_no
    fmov d4, #0.5
    fmul d4, d3, d4
    fsub d5, d9, d1
    fcmp d5, d4
    b.lt LXrect_no
    fadd d4, d9, d11
    fadd d3, d1, d3
    fsub d4, d4, d3
    fabs d4, d4
    fmov d5, #2.0
    fcmp d4, d5
    b.gt LXrect_no
    mov w0, #1
    b LXrect_done
LXrect_no:
    mov w0, #0
LXrect_done:
    ldp d12, d13, [sp, #80]
    ldp d10, d11, [sp, #64]
    ldp d8, d9, [sp, #48]
    ldp x21, x22, [sp, #32]
    ldp x19, x20, [sp, #16]
    ldp x29, x30, [sp], #112
    ret

// Fail closed on an unknown class, view-controller root, any scroll/web view,
// host content, unexpected large/deep tree or the real custom tab bar.
LXsafe_tree: // view, bar, remaining*, depth -> BOOL
    stp x29, x30, [sp, #-80]!
    mov x29, sp
    stp x19, x20, [sp, #16]
    stp x21, x22, [sp, #32]
    stp x23, x24, [sp, #48]
    stp x25, x26, [sp, #64]
    mov x19, x0
    mov x20, x1
    mov x21, x2
    mov w22, w3
    cbz x19, LXsafe_no
    cmp x19, x20
    b.eq LXsafe_no
    cmp w22, #12
    b.hi LXsafe_no
    ldr w8, [x21]
    cbz w8, LXsafe_no
    sub w8, w8, #1
    str w8, [x21]
    mov x0, x19
    adr x1, Lscroll_class
    bl Lpatch + (0x7394 - PATCH_BASE)
    cbnz w0, LXsafe_no
    GET x19, LXnext_responder
    adr x1, LXcontroller_class
    bl Lpatch + (0x7394 - PATCH_BASE)
    cbnz w0, LXsafe_no
    mov x0, x19
    bl Lclass_name
    mov x23, x0
    // A UIKit-looking name alone is not sufficient: require UIKit ownership.
    GET x19, LSclass
    mov x24, x0
    adr x0, LXbundle_class
    bl Lpatch + (0xa5b0 - PATCH_BASE)
    mov x2, x24
    adr x1, LXbundle_for_class
    bl Lmessage
    GET x0, LXbundle_id
    mov x24, x0
    adr x1, LXuikit_bundle
    bl LXstring_equal
    cbnz w0, LXsafe_bundle
    mov x0, x24
    adr x1, LXuikitcore_bundle
    bl LXstring_equal
    cbz w0, LXsafe_no
LXsafe_bundle:
    mov x0, x23
    adr x1, LXui_prefix
    bl LXstring_prefix
    cbnz w0, LXsafe_class
    mov x0, x23
    adr x1, LXprivate_prefix
    bl LXstring_prefix
    cbnz w0, LXsafe_class
    mov x0, x23
    adr x1, LXkit_prefix
    bl LXstring_prefix
    cbz w0, LXsafe_no
LXsafe_class:
    mov x0, x23
    adr x1, LXtransition_name
    bl LXstring_equal
    cbnz w0, LXsafe_no
    mov x0, x23
    adr x1, LXcontroller_wrapper
    bl LXstring_equal
    cbnz w0, LXsafe_no
    // Pure UIKit internal decorations must not contain legacy web rendering.
    mov x0, x19
    adr x1, LXweb_class
    bl Lpatch + (0x7394 - PATCH_BASE)
    cbnz w0, LXsafe_no
    GET x19, Lsubviews
    mov x23, x0
    GET x23, Lcount
    cmp x0, #48
    b.hi LXsafe_no
    mov x24, x0
    mov x25, #0
LXsafe_loop:
    cmp x25, x24
    b.hs LXsafe_yes
    mov x2, x25
    GET x23, Lobject_at
    mov x1, x20
    mov x2, x21
    add w3, w22, #1
    bl LXsafe_tree
    cbz w0, LXsafe_no
    add x25, x25, #1
    b LXsafe_loop
LXsafe_yes:
    mov w0, #1
    b LXsafe_done
LXsafe_no:
    mov w0, #0
LXsafe_done:
    ldp x25, x26, [sp, #64]
    ldp x23, x24, [sp, #48]
    ldp x21, x22, [sp, #32]
    ldp x19, x20, [sp, #16]
    ldp x29, x30, [sp], #80
    ret

LXstring_equal: // NSString, CString
    adr x2, LXis_equal
    b LXstring_compare
LXstring_prefix:
    adr x2, LXhas_prefix
LXstring_compare:
    stp x29, x30, [sp, #-48]!
    mov x29, sp
    stp x19, x20, [sp, #16]
    stp x21, x22, [sp, #32]
    mov x19, x0
    mov x20, x2
    mov x0, x1
    bl Lstr
    mov x2, x0
    mov x0, x19
    mov x1, x20
    bl Lmessage
    ldp x21, x22, [sp, #32]
    ldp x19, x20, [sp, #16]
    ldp x29, x30, [sp], #48
    ret

LXmonitor_start:
    stp x29, x30, [sp, #-64]!
    mov x29, sp
    stp x19, x20, [sp, #16]
    stp x21, x22, [sp, #32]
    stp x23, x24, [sp, #48]
    mov x19, x0
    AGET x19, LXmonitor_key
    cbnz x0, LXstart_done
    GET x19, Lwindow
    cbz x0, LXstart_done
    adr x0, LXmonitor_class
    bl Lpatch + (0xa5b0 - PATCH_BASE)
    mov x20, x0
    cbnz x20, LXstart_alloc
    adr x0, LDobject_class
    bl Lpatch + (0xa5b0 - PATCH_BASE)
    adr x1, LXmonitor_class
    mov x2, #0
    bl Lpatch + (0xa61c - PATCH_BASE)
    mov x20, x0
    cbz x20, LXstart_done
    mov x0, x20
    adr x1, LXpoll_sel
    adr x2, LXpoll
    adr x3, Lobject_encoding
    bl LDadd_method
    mov x0, x20
    bl Lpatch + (0xa610 - PATCH_BASE)
LXstart_alloc:
    GET x20, LMnew
    mov x21, x0
    cbz x21, LXstart_done
    adr x0, LShash_class
    adr x1, LSweak_hash
    bl Lfactory
    mov x22, x0
    mov x2, x19
    GET x22, LSadd_object
    ASET x21, LXowner_key, x22, 1
    ASET x19, LXmonitor_key, x21, 1
    adr x0, LXpoll_sel
    bl Lpatch + (0xa5a4 - PATCH_BASE)
    mov x22, x0
    adr x0, LXtimer_class
    bl Lpatch + (0xa5b0 - PATCH_BASE)
    mov x2, x21
    mov x3, x22
    mov x4, #0
    mov w5, #1
    fmov d0, #0.25
    adr x1, LXscheduled_timer
    bl Lmessage
    mov x23, x0
    ASET x21, LXtimer_key, x23, 1
    // NSTimer's default schedule alone stops during scroll tracking.
    adr x0, LXcommon_mode
    bl Lstr
    mov x24, x0
    adr x0, LXrunloop_class
    adr x1, LXmain_runloop
    bl Lfactory
    mov x2, x23
    mov x3, x24
    adr x1, LXadd_timer
    bl Lmessage
    GET x21, Lrelease
LXstart_done:
    ldp x23, x24, [sp, #48]
    ldp x21, x22, [sp, #32]
    ldp x19, x20, [sp, #16]
    ldp x29, x30, [sp], #64
    ret

LXpoll: // NSObject timer target, sel, timer
    stp x29, x30, [sp, #-64]!
    mov x29, sp
    stp x19, x20, [sp, #16]
    stp x21, x22, [sp, #32]
    stp x23, x24, [sp, #48]
    mov x19, x0
    mov x23, x2
    GET x19, Lretain
    GET x23, Lretain
    AGET x19, LXowner_key
    GET x0, LXany_object
    mov x20, x0
    GET x20, Lretain
    cbz x20, LXpoll_stop
    GET x20, Lwindow
    cbz x0, LXpoll_restore
    mov x1, x0
    mov x0, x20
    bl Lvisible_to
    cbz w0, LXpoll_restore
    AGET x20, Lpatch + (0xeb84 - PATCH_BASE)
    mov x21, x0
    cbz x21, LXpoll_restore
    GET x21, Lsuperview
    cmp x0, x20
    b.ne LXpoll_restore
    GET x21, Lis_hidden
    cbnz w0, LXpoll_restore
    AGET x20, Lbusy_key
    cbnz x0, LXpoll_done
    // Four bounded decoration/edge checks per second; content rediscovery 1Hz.
    AGET x19, LXtick_key
    GET x0, LXunsigned
    add x0, x0, #1
    and x22, x0, #3
    mov x0, x22
    bl Luint
    ASET x19, LXtick_key, x0, 1
    cbz x22, LXpoll_rescan
    ASET x20, Lbusy_key, x20, 0
    mov x0, x20
    mov x1, x21
    bl LXnative_update
    AGET x20, Ledge_key
    mov x21, x0
    GET x21, Lcount
    mov x22, x0
    mov x24, #0
LXpoll_edges:
    cmp x24, x22
    b.hs LXpoll_observe
    mov x2, x24
    GET x21, Lobject_at
    mov x2, #1
    GET x0, Lobject_at
    mov x2, #1
    GET x0, Lset_hidden
    add x24, x24, #1
    b LXpoll_edges
LXpoll_observe:
    mov x0, x20
    bl Ldiagnostic_observe
    ASET x20, Lbusy_key, xzr, 0
    b LXpoll_done
LXpoll_rescan:
    mov x0, x20
    bl Lrepair
    b LXpoll_done
LXpoll_restore:
    mov x0, x20
    bl Ledge_restore
    AGET x20, LXproxy_key
    mov x1, x0
    mov x0, x20
    bl LXrestore
LXpoll_stop:
    GET x23, LXinvalidate
    ASET x19, LXtimer_key, xzr, 0
LXpoll_done:
    GET x20, Lrelease
    GET x23, Lrelease
    GET x19, Lrelease
    ldp x23, x24, [sp, #48]
    ldp x21, x22, [sp, #32]
    ldp x19, x20, [sp, #16]
    ldp x29, x30, [sp], #64
    ret

LXsnapshot: // (bar, mutable snapshot)
    stp x29, x30, [sp, #-64]!
    mov x29, sp
    stp x19, x20, [sp, #16]
    stp x21, x22, [sp, #32]
    stp x23, x24, [sp, #48]
    mov x19, x0
    mov x20, x1
    bl Lnewarray
    mov x21, x0
    AGET x19, LXnative_key
    mov x22, x0
    GET x22, Lcount
    mov x23, x0
    mov x24, #0
LXsnapshot_loop:
    cmp x24, x23
    b.hs LXsnapshot_done_rows
    mov x2, x24
    GET x22, Lobject_at
    mov x2, #1
    GET x0, Lobject_at
    bl Ldescribe_view
    mov x2, x0
    GET x21, LSadd_object
    add x24, x24, #1
    b LXsnapshot_loop
LXsnapshot_done_rows:
    mov x0, x20
    adr x1, LXnative_field
    mov x2, x21
    bl Ldict_set
    AGET x19, LXrejected_key
    mov x2, x0
    mov x0, x20
    adr x1, LXrejected_field
    bl Ldict_set
    AGET x19, LXmonitor_key
    cmp x0, #0
    cset w0, ne
    bl Luint
    mov x2, x0
    mov x0, x20
    adr x1, LXmonitor_field
    bl Ldict_set
    AGET x19, LXproxy_key
    mov x21, x0
    AGET x21, LIoverlay_key
    mov x22, x0
    bl Ldescribe_view
    mov x2, x0
    mov x0, x20
    adr x1, LXoverlay_field
    bl Ldict_set
    mov x0, x22
    bl Ldescribe_children
    mov x2, x0
    mov x0, x20
    adr x1, LXinteraction_children
    bl Ldict_set
    AGET x21, LIlens_key
    bl Ldescribe_view
    mov x2, x0
    mov x0, x20
    adr x1, LXlens_field
    bl Ldict_set
    AGET x21, LIcontroller_key
    AGET x0, LIdrag_key
    cmp x0, #0
    cset w0, ne
    bl Luint
    mov x2, x0
    mov x0, x20
    adr x1, LXdrag_field
    bl Ldict_set
    ldp x23, x24, [sp, #48]
    ldp x21, x22, [sp, #32]
    ldp x19, x20, [sp, #16]
    ldp x29, x30, [sp], #64
    ret

LXstate_hash: // bar, preexisting scroll hash -> hash
    stp x29, x30, [sp, #-32]!
    mov x29, sp
    stp x19, x20, [sp, #16]
    mov x19, x0
    mov x20, x1
    AGET x19, LXnative_key
    GET x0, Lcount
    eor x20, x20, x0, lsl #48
    AGET x19, LXrejected_key
    GET x0, LXunsigned
    eor x0, x20, x0, lsl #56
    ldp x19, x20, [sp, #16]
    ldp x29, x30, [sp], #32
    ret

// @COMPONENT_DATA
LXnative_key: .byte 0
LXproxy_key: .byte 0
LXrejected_key: .byte 0
LXmonitor_key: .byte 0
LXowner_key: .byte 0
LXtimer_key: .byte 0
LXtick_key: .byte 0
LXwrapper_name: .asciz "UIKit._UITabBarContainerWrapperView"
LXwrapper_legacy: .asciz "_UITabBarContainerWrapperView"
LXui_prefix: .asciz "UI"
LXprivate_prefix: .asciz "_UI"
LXkit_prefix: .asciz "UIKit."
LXtransition_name: .asciz "UITransitionView"
LXcontroller_wrapper: .asciz "UIViewControllerWrapperView"
LXcontroller_class: .asciz "UIViewController"
LXweb_class: .asciz "UIWebView"
LXbundle_class: .asciz "NSBundle"
LXbundle_for_class: .asciz "bundleForClass:"
LXbundle_id: .asciz "bundleIdentifier"
LXuikit_bundle: .asciz "com.apple.UIKit"
LXuikitcore_bundle: .asciz "com.apple.UIKitCore"
LXnext_responder: .asciz "nextResponder"
LXis_equal: .asciz "isEqualToString:"
LXhas_prefix: .asciz "hasPrefix:"
LXmonitor_class: .asciz "FQABGlassMonitor158"
LXpoll_sel: .asciz "fqabPoll:"
LXtimer_class: .asciz "NSTimer"
LXscheduled_timer: .asciz "scheduledTimerWithTimeInterval:target:selector:userInfo:repeats:"
LXinvalidate: .asciz "invalidate"
LXrunloop_class: .asciz "NSRunLoop"
LXmain_runloop: .asciz "mainRunLoop"
LXadd_timer: .asciz "addTimer:forMode:"
LXcommon_mode: .asciz "kCFRunLoopCommonModes"
LXany_object: .asciz "anyObject"
LXunsigned: .asciz "unsignedIntegerValue"
LXnative_field: .asciz "suppressedNativeTabDecorations"
LXrejected_field: .asciz "nativeDecorationRejectedFlags"
LXmonitor_field: .asciz "scrollTrackingMonitorActive"
LXoverlay_field: .asciz "glassInteractionOverlay"
LXinteraction_children: .asciz "glassInteractionChildren"
LXlens_field: .asciz "glassSelectionLens"
LXdrag_field: .asciz "glassSelectionDragging"
.p2align 2
