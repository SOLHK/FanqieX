// FanqieAdBlock 1.5.8. Applies only to the SHA-256 pinned uploaded 1.5.6.
// Existing RX __TEXT padding, image-relative references, no new imports/fixups.
.text
.set PATCH_BASE, 0x800
.set DATA_BASE, 0x11900
.set EXT_BASE, 0x14000
.p2align 2
Lpatch:
    .long Lratio - Lpatch
    .long Llayout - Lpatch
    .long Linstall - Lpatch
    .long Lrepair - Lpatch
    .long Lstrings - Lpatch
    .long Lend - Lpatch
    .long 0x00010508
    .long 0
    .long Lbutton_frame - Lpatch
    .long Lbackground - Lpatch
    .long Lrestore - Lpatch
    .long Ledge_update - Lpatch
    .long Ledge_restore - Lpatch
    .long Lfind_scroll - Lpatch
    .long Lbutton_round - Lpatch
    .long Lsync - Lpatch
    .long Leligible - Lpatch
    .long Lvisible_to - Lpatch
    .long Lmessage - Lpatch
    .long Linstall_method - Lpatch
    .long Lbusy_key - Lpatch
    .long Lscroll_key - Lpatch
    .long Ledge_key - Lpatch
    .long Lhidden_key - Lpatch
    .long Lparent_key - Lpatch
    .long Lselected_key - Lpatch
    .long Lsync_original - Lpatch
    .long Lrestore_original - Lpatch
    .long Lproxy_frame - Lpatch
    .long Lmaterial_update - Lpatch
    .long Lmaterial_reset - Lpatch
    .long Lsettings_boot - Lpatch
    .long LUIinstall - Lpatch
    .long LUIexport - Lpatch
    .long LUIpresent - Lpatch
    .long LDdiag_init - Lpatch
    .long LDdiag_enqueue - Lpatch
    .long LDdiag_tick - Lpatch
    .long LDdiag_maintenance - Lpatch
    .long Ldiagnostic_observe - Lpatch
    .long Ldiagnostic_snapshot - Lpatch
    .long Ldiagnostic_snapshot_all - Lpatch
    .long Ldiagnostic_heartbeat - Lpatch
    .long Ldescribe_view - Lpatch
    .long Ldescribe_children - Lpatch
    .long Lstr - Lpatch
    .long Lnumber - Lpatch
    .long Ldict_set - Lpatch
    .long Luint - Lpatch
    .long Lnow - Lpatch
    .long Lsettings_original - Lpatch
    .long LSsignature_key - Lpatch
    .long LSbars_key - Lpatch
    .long LUbusy_key - Lpatch
    .long LUsender_key - Lpatch
    .long Lcode_end - Lpatch
    .long Lwindow_hook - Lpatch
    .long Lfind_record - Lpatch, Lcapture_edge - Lpatch, Lrestore_removed - Lpatch
    .long Lextension - Lpatch, LXcode_end - Lpatch, LXstrings - Lpatch, LXend - Lpatch

// Only these local macros are used; receivers and live values are held in
// callee-saved registers. Lmessage preserves the method arguments while it
// registers the selector, then tail-calls objc_msgSend with the true selector.
.macro GET receiver, selector
    mov x0, \receiver
    adr x1, \selector
    bl Lmessage
.endm
.macro AGET receiver, key
    mov x0, \receiver
    adr x1, \key
    bl Lpatch + (0xa628 - PATCH_BASE)
.endm
.macro ASET receiver, key, value, policy
    mov x2, \value
    mov x0, \receiver
    adr x1, \key
    mov x3, #\policy
    bl Lpatch + (0xa634 - PATCH_BASE)
.endm
.macro FINITE value, failure
    fmov x8, \value
    ubfx x8, x8, #52, #11
    cmp x8, #2047
    b.eq \failure
.endm

// Gate only the legacy transition of the mounted glass bar. Inactive paths
// retain the exact original receiver, selector, BOOL and CGFloat arguments.
Lratio:
    stp x29, x30, [sp, #-64]!
    mov x29, sp
    stp x0, x1, [sp, #16]
    str x2, [sp, #32]
    str d0, [sp, #40]
    bl Lrepair
    cbz w0, Lratio_original
    ldp x29, x30, [sp], #64
    ret
Lratio_original:
    ldp x0, x1, [sp, #16]
    ldr x2, [sp, #32]
    ldr d0, [sp, #40]
    ldp x29, x30, [sp], #64
    stp d9, d8, [sp, #-64]!
    b Lpatch + (0x5b98 - PATCH_BASE)

Llayout:
    adr x2, Llayout_alias
    b Lvoid_callback
Lwindow_hook:
    adr x2, Lwindow_alias
Lvoid_callback:
    stp x29, x30, [sp, #-32]!
    mov x29, sp
    stp x19, x20, [sp, #16]
    mov x19, x0
    mov x20, x1
    adr x0, Lbar_class
    mov x1, x2
    bl Lpatch + (0x6274 - PATCH_BASE)
    cbz x0, Llayout_repair
    mov x8, x0
    mov x0, x19
    mov x1, x20
    blr x8
Llayout_repair:
    mov x0, x19
    bl Lrepair
    ldp x19, x20, [sp, #16]
    ldp x29, x30, [sp], #32
    ret

// Bar-local late background writes: the original method runs first.
Lbackground:
    stp x29, x30, [sp, #-48]!
    mov x29, sp
    stp x19, x20, [sp, #16]
    stp x21, x22, [sp, #32]
    mov x19, x0
    mov x20, x1
    mov x21, x2
    adr x0, Lbar_class
    adr x1, Lbackground_alias
    bl Lpatch + (0x6274 - PATCH_BASE)
    cbz x0, Lbackground_repair
    mov x8, x0
    mov x0, x19
    mov x1, x20
    mov x2, x21
    blr x8
Lbackground_repair:
    mov x0, x19
    bl Lrepair
    ldp x21, x22, [sp, #32]
    ldp x19, x20, [sp, #16]
    ldp x29, x30, [sp], #48
    ret

// Constructor call remains after all original host UUID/preferences/glass
// capability gates. Never swizzle UIView or UIScrollView globally.
Linstall:
    stp x29, x30, [sp, #-32]!
    mov x29, sp
    stp x19, x20, [sp, #16]
    adr x0, Lbar_class
    bl Lpatch + (0xa5b0 - PATCH_BASE)
    cbz x0, Linstall_done
    mov x19, x0
    adr x0, Lratio_alias
    bl Lpatch + (0xa5a4 - PATCH_BASE)
    mov x1, x0
    mov x0, x19
    bl Lpatch + (0xa5f8 - PATCH_BASE)
    cbz x0, Linstall_done
    mov x0, x19
    adr x1, Llayout_sel
    adr x2, Llayout_alias
    adr x3, Llayout
    adr x4, Lvoid_encoding
    bl Linstall_method
    mov x0, x19
    adr x1, Lwindow_sel
    adr x2, Lwindow_alias
    adr x3, Lwindow_hook
    adr x4, Lvoid_encoding
    bl Linstall_method
    mov x0, x19
    adr x1, Lset_background
    adr x2, Lbackground_alias
    adr x3, Lbackground
    adr x4, Lobject_encoding
    bl Linstall_method
Linstall_done:
    ldp x19, x20, [sp, #16]
    ldp x29, x30, [sp], #32
    ret

// (Class, selector CString, alias CString, replacement IMP, type CString).
// Add an own method first; an inherited implementation is never overwritten.
Linstall_method:
    stp x29, x30, [sp, #-64]!
    mov x29, sp
    stp x19, x20, [sp, #16]
    stp x21, x22, [sp, #32]
    stp x23, x24, [sp, #48]
    mov x19, x0
    mov x20, x1
    mov x21, x2
    mov x22, x3
    mov x23, x4
    mov x0, x21
    bl Lpatch + (0xa5a4 - PATCH_BASE)
    mov x24, x0
    mov x1, x0
    mov x0, x19
    bl Lpatch + (0xa5f8 - PATCH_BASE)
    cbnz x0, Linstall_method_done
    mov x0, x20
    bl Lpatch + (0xa5a4 - PATCH_BASE)
    mov x20, x0
    mov x1, x0
    mov x0, x19
    mov w2, #0
    mov x3, x23
    bl Lpatch + (0x4878 - PATCH_BASE)
    cbz x0, Linstall_method_done
    bl Lpatch + (0xa598 - PATCH_BASE)
    mov x2, x0
    mov x0, x19
    mov x1, x24
    mov x3, x23
    bl Lpatch + (0xa58c - PATCH_BASE)
    cbz w0, Linstall_method_done
    mov x0, x19
    mov x1, x20
    mov x2, x22
    mov x3, x23
    bl Lpatch + (0xa58c - PATCH_BASE)
    cbnz w0, Linstall_method_done
    mov x0, x19
    mov x1, x20
    bl Lpatch + (0xa5f8 - PATCH_BASE)
    cbz x0, Linstall_method_done
    mov x1, x22
    bl Lpatch + (0xa580 - PATCH_BASE)
Linstall_method_done:
    ldp x23, x24, [sp, #48]
    ldp x21, x22, [sp, #32]
    ldp x19, x20, [sp, #16]
    ldp x29, x30, [sp], #64
    ret

// These internal wrappers preserve the original prologues and the entry bar.
// The sync path also covers visibility/selection changes when an already
// clear background does not produce another setter or layout callback.
Lsync:
    stp x29, x30, [sp, #-32]!
    mov x29, sp
    stp x19, x20, [sp, #16]
    mov x19, x0
    bl Lsync_original
    mov x0, x19
    bl Lrepair
    ldp x19, x20, [sp, #16]
    ldp x29, x30, [sp], #32
    ret
Lsync_original:
    stp x28, x27, [sp, #-96]!
    b Lpatch + (0x60bc - PATCH_BASE)

Lrestore:
    stp x29, x30, [sp, #-32]!
    mov x29, sp
    stp x19, x20, [sp, #16]
    mov x19, x0
    mov x20, x1
    bl Lrestore_original
    mov x0, x19
    bl Ledge_restore
    mov x0, x20
    bl Lmaterial_reset
    mov x0, x19
    mov x1, x20
    bl LXrestore
    mov x0, x19
    bl Ldiagnostic_observe
    ldp x19, x20, [sp, #16]
    ldp x29, x30, [sp], #32
    ret
Lrestore_original:
    stp x26, x25, [sp, #-80]!
    b Lpatch + (0x6db8 - PATCH_BASE)

// The original _set_frame may return early for an unchanged frame. Rounding
// therefore always follows it, using actual bounds, even on that fast path.
Lbutton_frame:
    stp x29, x30, [sp, #-32]!
    mov x29, sp
    stp x19, x20, [sp, #16]
    mov x19, x0
    bl Lpatch + (0x711c - PATCH_BASE)
    mov x0, x19
    bl Lbutton_round
    ldp x19, x20, [sp, #16]
    ldp x29, x30, [sp], #32
    ret
Lbutton_round:
    stp x29, x30, [sp, #-48]!
    mov x29, sp
    stp x19, x20, [sp, #16]
    stp d8, d9, [sp, #32]
    mov x19, x0
    cbz x19, Lbutton_round_done
    GET x19, Lbounds
    FINITE d2, Lbutton_round_done
    FINITE d3, Lbutton_round_done
    fcmp d2, #0.0
    b.le Lbutton_round_done
    fcmp d3, #0.0
    b.le Lbutton_round_done
    fmin d8, d2, d3
    fmov d0, #0.5
    fmul d8, d8, d0
    GET x19, Llayer
    mov x20, x0
    fmov d0, d8
    GET x20, Lset_radius
    mov w2, #1
    GET x20, Lset_masks
Lbutton_round_done:
    ldp d8, d9, [sp, #32]
    ldp x19, x20, [sp, #16]
    ldp x29, x30, [sp], #48
    ret

// Return YES only for a mounted active proxy. The busy marker is per bar and
// nonretaining. All new edge ownership is released on inactive/detached paths.
Lrepair:
    stp x29, x30, [sp, #-48]!
    mov x29, sp
    stp x19, x20, [sp, #16]
    stp x21, x22, [sp, #32]
    mov x19, x0
    adr x1, Lpatch + (0xeb84 - PATCH_BASE)
    bl Lpatch + (0xa628 - PATCH_BASE)
    cbz x0, Lrepair_inactive
    mov x20, x0
    GET x20, Lsuperview
    cmp x0, x19
    b.ne Lrepair_detached
    AGET x19, Lbusy_key
    cbnz x0, Lrepair_active
    ASET x19, Lbusy_key, x19, 0
    mov x0, x19
    bl Lpatch + (0x71bc - PATCH_BASE)
    GET x19, Lcontent_view
    cbz x0, Lrepair_front
    cmp x0, x20
    b.eq Lrepair_front
    cmp x0, x19
    b.eq Lrepair_front
    mov x21, x0
    GET x21, Lis_hidden
    cbnz w0, Lrepair_front
    mov w2, #1
    GET x21, Lset_hidden
Lrepair_front:
    mov x0, x19
    mov x1, x20
    bl LXfront_target
    mov x22, x0
    GET x19, Lsubviews
    mov x21, x0
    GET x21, Llast_object
    cmp x0, x22
    b.eq Lrepair_edges
    mov x2, x22
    GET x19, Lbring_front
Lrepair_edges:
    mov x0, x19
    mov x1, x20
    bl Lmaterial_update
    mov x0, x19
    mov x1, x20
    bl Ledge_update
    mov x0, x19
    mov x1, x20
    bl LXupdate
    mov x0, x19
    bl Ldiagnostic_observe
    ASET x19, Lbusy_key, xzr, 0
Lrepair_active:
    mov w0, #1
    b Lrepair_done
Lrepair_detached:
    mov x0, x20
    bl Lmaterial_reset
Lrepair_inactive:
    mov x1, #0
    mov x0, x19
    bl LXrestore
    mov x0, x19
    bl Ledge_restore
    mov x0, x19
    bl Ldiagnostic_observe
    mov w0, #0
Lrepair_done:
    ldp x21, x22, [sp, #32]
    ldp x19, x20, [sp, #16]
    ldp x29, x30, [sp], #48
    ret

// Own a bounded set of public bottom-edge effects, including nested scrolls.
// A row is [scrollView, effect, NSNumber(originalHidden)]. Reuse rows by effect
// identity, so a late host write never replaces the initial restoration value.
Ledge_update:
    stp x29, x30, [sp, #-112]!
    mov x29, sp
    stp x19, x20, [sp, #16]
    stp x21, x22, [sp, #32]
    stp x23, x24, [sp, #48]
    stp x25, x26, [sp, #64]
    mov x19, x0
    mov x20, x1
    cbz x19, Ledge_update_restore
    cbz x20, Ledge_update_restore
    GET x19, Lwindow
    cbz x0, Ledge_update_restore
    mov x1, x0
    mov x0, x19
    bl Lvisible_to
    cbz w0, Ledge_update_restore
    mov x0, x20
    mov x1, x19
    bl Lvisible_to
    cbz w0, Ledge_update_restore
    GET x19, Lsuperview
    cbz x0, Ledge_update_restore
    mov x21, x0
    mov x0, x19
    bl LFbegin
    AGET x19, Ledge_key
    GET x0, Lretain
    mov x23, x0
    bl Lnewarray
    mov x22, x0
    mov w8, #768
    str w8, [sp, #80]
    str wzr, [sp, #84]
    stp x22, x23, [sp, #88]
    mov x0, x21
    mov x1, x19
    mov x2, x21
    add x3, sp, #80
    mov w4, #0
    bl Lfind_scroll
    mov x0, x19
    bl LFend
    // Publish the new ownership set before restoration can reenter UIKit.
    ASET x19, Ledge_key, x22, 1
    mov x0, x23
    mov x1, x22
    bl Lrestore_removed
    GET x23, Lrelease
    ldr w8, [sp, #80]
    mov w0, #768
    sub w0, w0, w8
    bl Luint
    ASET x19, Lparent_key, x0, 1
    ldr w0, [sp, #84]
    bl Luint
    ASET x19, Lselected_key, x0, 1
    b Ledge_update_done
Ledge_update_restore:
    mov x0, x19
    bl Ledge_restore
Ledge_update_done:
    ldp x25, x26, [sp, #64]
    ldp x23, x24, [sp, #48]
    ldp x21, x22, [sp, #32]
    ldp x19, x20, [sp, #16]
    ldp x29, x30, [sp], #112
    ret

Ledge_restore:
    stp x29, x30, [sp, #-32]!
    mov x29, sp
    stp x19, x20, [sp, #16]
    mov x19, x0
    cbz x19, Ledge_restore_done
    mov x0, x19
    bl LFrestore
    AGET x19, Ledge_key
    GET x0, Lretain
    mov x20, x0
    ASET x19, Ledge_key, xzr, 0
    ASET x19, Lparent_key, xzr, 0
    ASET x19, Lselected_key, xzr, 0
    mov x0, x20
    mov x1, #0
    bl Lrestore_removed
    GET x20, Lrelease
Ledge_restore_done:
    ldp x19, x20, [sp, #16]
    ldp x29, x30, [sp], #32
    ret

// (oldRows, newRows) restore every row no longer owned.
Lrestore_removed:
    stp x29, x30, [sp, #-64]!
    mov x29, sp
    stp x19, x20, [sp, #16]
    stp x21, x22, [sp, #32]
    stp x23, x24, [sp, #48]
    mov x19, x0
    mov x20, x1
    GET x19, Lcount
    mov x21, x0
    mov x22, #0
Lrestore_removed_loop:
    cmp x22, x21
    b.hs Lrestore_removed_done
    mov x2, x22
    GET x19, Lobject_at
    mov x23, x0
    mov x2, x23
    GET x20, Lcontains
    cbnz w0, Lrestore_removed_next
    mov x2, #1
    GET x23, Lobject_at
    mov x24, x0
    mov x2, #2
    GET x23, Lobject_at
    GET x0, Lbool_value
    mov w23, w0
    GET x24, Lis_hidden
    cmp w0, w23
    b.eq Lrestore_removed_next
    mov w2, w23
    GET x24, Lset_hidden
Lrestore_removed_next:
    add x22, x22, #1
    b Lrestore_removed_loop
Lrestore_removed_done:
    ldp x23, x24, [sp, #48]
    ldp x21, x22, [sp, #32]
    ldp x19, x20, [sp, #16]
    ldp x29, x30, [sp], #64
    ret

// (rows, effect) -> row by effect identity, never value equality of a view.
Lfind_record:
    stp x29, x30, [sp, #-64]!
    mov x29, sp
    stp x19, x20, [sp, #16]
    stp x21, x22, [sp, #32]
    stp x23, x24, [sp, #48]
    mov x19, x0
    mov x20, x1
    GET x19, Lcount
    mov x21, x0
    mov x22, #0
Lfind_record_loop:
    cmp x22, x21
    b.hs Lfind_record_no
    mov x2, x22
    GET x19, Lobject_at
    mov x23, x0
    mov x2, #1
    GET x23, Lobject_at
    cmp x0, x20
    b.eq Lfind_record_yes
    add x22, x22, #1
    b Lfind_record_loop
Lfind_record_yes:
    mov x0, x23
    b Lfind_record_done
Lfind_record_no:
    mov x0, #0
Lfind_record_done:
    ldp x23, x24, [sp, #48]
    ldp x21, x22, [sp, #32]
    ldp x19, x20, [sp, #16]
    ldp x29, x30, [sp], #64
    ret

// (scroll, effect, context*) append once, retaining original hidden on reuse.
Lcapture_edge:
    stp x29, x30, [sp, #-64]!
    mov x29, sp
    stp x19, x20, [sp, #16]
    stp x21, x22, [sp, #32]
    stp x23, x24, [sp, #48]
    mov x19, x0
    mov x20, x1
    mov x21, x2
    ldr x22, [x21, #8]
    mov x0, x22
    bl Lfind_record
    cbnz x0, Lcapture_done
    GET x22, Lcount
    cmp x0, #16
    b.lo Lcapture_room
    ldr w8, [x21, #4]
    orr w8, w8, #8
    str w8, [x21, #4]
    b Lcapture_done
Lcapture_room:
    ldr x0, [x21, #16]
    mov x1, x20
    bl Lfind_record
    mov x23, x0
    cbnz x23, Lcapture_append
    bl Lnewarray
    mov x23, x0
    mov x2, x19
    GET x23, LSadd_object
    mov x2, x20
    GET x23, LSadd_object
    GET x20, Lis_hidden
    and w0, w0, #1
    bl Luint
    mov x2, x0
    GET x23, LSadd_object
Lcapture_append:
    mov x2, x23
    GET x22, LSadd_object
    GET x20, Lis_hidden
    cbnz w0, Lcapture_done
    mov w2, #1
    GET x20, Lset_hidden
Lcapture_done:
    ldp x23, x24, [sp, #48]
    ldp x21, x22, [sp, #32]
    ldp x19, x20, [sp, #16]
    ldp x29, x30, [sp], #64
    ret

// (view, stopAncestor) -> BOOL. Includes both endpoints and rejects detached
// chains. Bounds traversal to 32 ancestors, without messaging cached ASSIGNs.
Lvisible_to:
    stp x29, x30, [sp, #-48]!
    mov x29, sp
    stp x19, x20, [sp, #16]
    stp x21, x22, [sp, #32]
    mov x19, x0
    mov x20, x1
    mov w21, #32
    cbz x20, Lvisible_no
Lvisible_loop:
    cbz x19, Lvisible_no
    cbz w21, Lvisible_no
    sub w21, w21, #1
    GET x19, Lis_hidden
    cbnz w0, Lvisible_no
    GET x19, Lalpha
    fcmp d0, #0.0
    b.le Lvisible_no
    cmp x19, x20
    b.eq Lvisible_yes
    GET x19, Lsuperview
    mov x19, x0
    b Lvisible_loop
Lvisible_yes:
    mov w0, #1
    b Lvisible_done
Lvisible_no:
    mov w0, #0
Lvisible_done:
    ldp x21, x22, [sp, #32]
    ldp x19, x20, [sp, #16]
    ldp x29, x30, [sp], #48
    ret

// (scrollCandidate, bar, parent) -> current bottomEdgeEffect or nil.
// Geometry is rechecked even on cache hits. Offscreen sibling pages, hidden
// ancestors, other windows, small carousels and horizontal pagers are rejected.
Leligible:
    stp x29, x30, [sp, #-160]!
    mov x29, sp
    stp x19, x20, [sp, #16]
    stp x21, x22, [sp, #32]
    stp d8, d9, [sp, #48]
    stp d10, d11, [sp, #64]
    stp d12, d13, [sp, #80]
    stp d14, d15, [sp, #96]
    mov x19, x0
    mov x20, x1
    mov x21, x2
    cbz x19, Leligible_no
    // Never retain the bar's parent as a candidate: parent owns the bar and
    // caching it would form a retain cycle. Search only sibling subtrees.
    cmp x19, x21
    b.eq Leligible_no
    adr x1, Lscroll_class
    bl Lpatch + (0x7394 - PATCH_BASE)
    cbz w0, Leligible_no
    adr x0, Lbottom_edge
    bl Lpatch + (0xa5a4 - PATCH_BASE)
    mov x2, x0
    GET x19, Lresponds
    cbz w0, Leligible_no
    GET x19, Lwindow
    cbz x0, Leligible_no
    mov x22, x0
    GET x20, Lwindow
    cmp x0, x22
    b.ne Leligible_no
    mov x0, x19
    mov x1, x21
    bl Lvisible_to
    cbz w0, Leligible_no
    GET x19, Lbounds
    FINITE d2, Leligible_no
    FINITE d3, Leligible_no
    fcmp d2, #0.0
    b.le Leligible_no
    mov w8, #160
    scvtf d4, w8
    fcmp d3, d4
    b.lt Leligible_no
    stp d0, d1, [sp, #112]
    stp d2, d3, [sp, #128]
    fmov d9, d3
    GET x19, Lcontent_size
    FINITE d1, Leligible_no
    fmov d4, #1.0
    fadd d4, d9, d4
    fcmp d1, d4
    b.le Leligible_no
    GET x20, Lbounds
    FINITE d0, Leligible_no
    FINITE d1, Leligible_no
    FINITE d2, Leligible_no
    FINITE d3, Leligible_no
    fcmp d2, #0.0
    b.le Leligible_no
    fcmp d3, #0.0
    b.le Leligible_no
    fmov d12, d0
    fmov d13, d1
    fmov d14, d2
    fmov d15, d3
    ldp d0, d1, [sp, #112]
    ldp d2, d3, [sp, #128]
    mov x2, x20
    GET x19, Lconvert_rect
    FINITE d0, Leligible_no
    FINITE d1, Leligible_no
    FINITE d2, Leligible_no
    FINITE d3, Leligible_no
    fcmp d2, #0.0
    b.le Leligible_no
    fcmp d3, #0.0
    b.le Leligible_no
    fadd d4, d0, d2
    fadd d5, d12, d14
    fmin d4, d4, d5
    fmax d5, d0, d12
    fsub d4, d4, d5
    fmov d5, #0.75
    fmul d5, d14, d5
    fcmp d4, d5
    b.lt Leligible_no
    fadd d4, d13, d15
    fcmp d1, d4
    b.ge Leligible_no
    fadd d4, d1, d3
    fmov d5, #1.0
    fsub d5, d13, d5
    fcmp d4, d5
    b.lt Leligible_no
    GET x19, Lbottom_edge
    b Leligible_done
Leligible_no:
    mov x0, #0
Leligible_done:
    ldp d14, d15, [sp, #96]
    ldp d12, d13, [sp, #80]
    ldp d10, d11, [sp, #64]
    ldp d8, d9, [sp, #48]
    ldp x21, x22, [sp, #32]
    ldp x19, x20, [sp, #16]
    ldp x29, x30, [sp], #160
    ret

// Bounded DFS of all eligible nested scrolls. Context is remaining:uint,
// truncationFlags:uint, newRows:id, oldRows:id. Never visits the bar subtree.
Lfind_scroll:
    stp x29, x30, [sp, #-80]!
    mov x29, sp
    stp x19, x20, [sp, #16]
    stp x21, x22, [sp, #32]
    stp x23, x24, [sp, #48]
    stp x25, x26, [sp, #64]
    mov x19, x0
    mov x20, x1
    mov x21, x2
    mov x22, x3
    mov w23, w4
    cbz x19, Lfind_done
    cmp x19, x20
    b.eq Lfind_done
    cmp w23, #24
    b.le Lfind_depth_ok
    ldr w8, [x22, #4]
    orr w8, w8, #2
    str w8, [x22, #4]
    b Lfind_done
Lfind_depth_ok:
    ldr w8, [x22]
    cbnz w8, Lfind_node_ok
    ldr w8, [x22, #4]
    orr w8, w8, #1
    str w8, [x22, #4]
    b Lfind_done
Lfind_node_ok:
    sub w8, w8, #1
    str w8, [x22]
    GET x19, Lis_hidden
    cbnz w0, Lfind_done
    GET x19, Lalpha
    fcmp d0, #0.0
    b.le Lfind_done
    mov x0, x19
    mov x1, x20
    bl LFconsider
    mov x0, x19
    mov x1, x20
    mov x2, x21
    bl Leligible
    cbz x0, Lfind_children
    mov x1, x0
    mov x0, x19
    mov x2, x22
    bl Lcapture_edge
Lfind_children:
    GET x19, Lsubviews
    mov x24, x0
    GET x24, Lcount
    mov x8, #64
    cmp x0, x8
    csel x25, x0, x8, lo
    b.ls Lfind_children_limit_ok
    ldr w8, [x22, #4]
    orr w8, w8, #4
    str w8, [x22, #4]
Lfind_children_limit_ok:
    mov x26, #0
Lfind_loop:
    cmp x26, x25
    b.hs Lfind_done
    mov x2, x26
    GET x24, Lobject_at
    mov x1, x20
    mov x2, x21
    mov x3, x22
    add w4, w23, #1
    bl Lfind_scroll
    add x26, x26, #1
    b Lfind_loop
Lfind_done:
    ldp x25, x26, [sp, #64]
    ldp x23, x24, [sp, #48]
    ldp x21, x22, [sp, #32]
    ldp x19, x20, [sp, #16]
    ldp x29, x30, [sp], #80
    ret

// Full non-variadic dispatcher. CGRect/CGSize use d0..d3; additional
// Foundation/UIKit object arguments through x7 survive selector registration.
Lmessage:
    stp x29, x30, [sp, #-144]!
    mov x29, sp
    stp x0, x2, [sp, #16]
    stp x3, x4, [sp, #32]
    stp x5, x6, [sp, #48]
    str x7, [sp, #64]
    stp d0, d1, [sp, #80]
    stp d2, d3, [sp, #96]
    stp d4, d5, [sp, #112]
    stp d6, d7, [sp, #128]
    mov x0, x1
    bl Lpatch + (0xa5a4 - PATCH_BASE)
    mov x1, x0
    ldp x0, x2, [sp, #16]
    ldp x3, x4, [sp, #32]
    ldp x5, x6, [sp, #48]
    ldr x7, [sp, #64]
    ldp d0, d1, [sp, #80]
    ldp d2, d3, [sp, #96]
    ldp d4, d5, [sp, #112]
    ldp d6, d7, [sp, #128]
    ldp x29, x30, [sp], #144
    b Lpatch + (0xa5d4 - PATCH_BASE)

// Scoped material lifecycle for the owned floating-bar proxy.
// Included by floating_bar_155.s: PATCH_BASE, Lpatch, GET, AGET, ASET,
// FINITE and Lmessage are supplied by the parent assembly.
// The cached ASSIGN window is comparison-only. The frame adapter uses the
// original bound-bar association; material updates run inside Lrepair's busy scope.

.set Lproxy_frame, LMproxy_frame
.set Lmaterial_update, LMmaterial_update
.set Lmaterial_reset, LMmaterial_reset

// Reuse immutable strings in the exact supported 1.5.2 image.
.set LMbound_bar_key, Lpatch + (0xeb87 - PATCH_BASE)
.set LMbounds, Lpatch + (0xbb3c - PATCH_BASE)
.set LMsuperview, Lpatch + (0xbb1e - PATCH_BASE)
.set LMis_hidden, Lpatch + (0xbe75 - PATCH_BASE)
.set LMis_kind, Lpatch + (0xbe66 - PATCH_BASE)
.set LMcontent_view, Lpatch + (0xbbae - PATCH_BASE)
.set LMadd_subview, Lpatch + (0xb583 - PATCH_BASE)
.set LMresponds, Lpatch + (0xb5cb - PATCH_BASE)
.set LMglass_class, Lpatch + (0xa6bc - PATCH_BASE)
.set LMglass_factory, Lpatch + (0xb58f - PATCH_BASE)
.set LMset_interactive, Lpatch + (0xbb43 - PATCH_BASE)
.set LMcorner_class, Lpatch + (0xb5a0 - PATCH_BASE)
.set LMcapsule, Lpatch + (0xb5b6 - PATCH_BASE)
.set LMset_corner, Lpatch + (0xbc63 - PATCH_BASE)
.set LMrelease, Lpatch + (0xb1c0 - PATCH_BASE)

// (proxy, CGRect in d0..d3). Keep the original frame operation, then attach
// only with a finite, positive frame. The old pre-frame addSubview is removed
// by the parent patch; subsequent original show/front behavior is unchanged.
LMproxy_frame:
    stp x29, x30, [sp, #-64]!
    mov x29, sp
    stp x19, x20, [sp, #16]
    stp d0, d1, [sp, #32]
    stp d2, d3, [sp, #48]
    mov x19, x0
    bl Lpatch + (0x711c - PATCH_BASE)
    cbz x19, LMframe_done
    ldp d0, d1, [sp, #32]
    ldp d2, d3, [sp, #48]
    FINITE d0, LMframe_done
    FINITE d1, LMframe_done
    FINITE d2, LMframe_done
    FINITE d3, LMframe_done
    fcmp d2, #0.0
    b.le LMframe_done
    fcmp d3, #0.0
    b.le LMframe_done
    AGET x19, LMbound_bar_key
    mov x20, x0
    cbz x20, LMframe_done
    GET x19, LMsuperview
    cmp x0, x20
    b.eq LMframe_done
    mov x2, x19
    GET x20, LMadd_subview
LMframe_done:
    ldp x19, x20, [sp, #16]
    ldp x29, x30, [sp], #64
    ret

// (bar, proxy) -> 1 only when this call installs a fresh Clear glass effect.
// A window-visible, finite-sized proxy is installed once, then reused until
// unrenderable, reattached to another window, or replaced by a non-glass effect.
LMmaterial_update:
    stp x29, x30, [sp, #-80]!
    mov x29, sp
    stp x19, x20, [sp, #16]
    stp x21, x22, [sp, #32]
    stp x23, x24, [sp, #48]
    stp d8, d9, [sp, #64]
    mov x19, x0
    mov x20, x1
    cbz x20, LMupdate_zero
    cbz x19, LMinvalidate
    GET x20, LMsuperview
    cmp x0, x19
    b.ne LMinvalidate
    GET x20, LMbounds
    FINITE d0, LMinvalidate
    FINITE d1, LMinvalidate
    FINITE d2, LMinvalidate
    FINITE d3, LMinvalidate
    fcmp d2, #0.0
    b.le LMinvalidate
    fcmp d3, #0.0
    b.le LMinvalidate
    GET x20, LMwindow
    mov x21, x0
    cbz x21, LMinvalidate

    // Include both proxy and fresh window. Reject broken/cyclic/long chains,
    // hidden views, nonfinite alpha and meaningful ancestor compositing.
    mov x22, x20
    mov w23, #32
    fmov d8, #1.0
LMvisible_loop:
    cbz x22, LMinvalidate
    cbz w23, LMinvalidate
    sub w23, w23, #1
    GET x22, LMis_hidden
    cbnz w0, LMinvalidate
    GET x22, LMalpha
    FINITE d0, LMinvalidate
    fcmp d0, #0.0
    b.le LMinvalidate
    fmov d1, #1.0
    fcmp d0, d1
    b.gt LMinvalidate
    fmul d8, d8, d0
    ldr d1, LMalpha_floor
    fcmp d8, d1
    b.lt LMinvalidate
    cmp x22, x21
    b.eq LMvisible
    GET x22, LMsuperview
    mov x22, x0
    b LMvisible_loop

LMvisible:
    // Constrain only our own public surfaces. Opaque is a drawing hint,
    // not a substitute for clear background or a modification of host alpha.
    mov x0, x20
    bl Lpatch + (0x73e0 - PATCH_BASE)
    mov w2, #0
    GET x20, LMset_opaque
    GET x20, LMcontent_view
    mov x24, x0
    cbz x24, LMcheck_cache
    mov x0, x24
    bl Lpatch + (0x73e0 - PATCH_BASE)
    mov w2, #0
    GET x24, LMset_opaque

LMcheck_cache:
    adr x0, LMglass_class
    bl Lpatch + (0xa5b0 - PATCH_BASE)
    mov x22, x0
    cbz x22, LMinvalidate
    GET x20, LMeffect
    mov x2, x22
    GET x0, LMis_kind
    cbz w0, LMrebuild
    AGET x20, LMmounted_key
    cbz x0, LMrebuild
    AGET x20, LMwindow_key
    cmp x0, x21
    b.eq LMupdate_zero

LMrebuild:
    // The class may exist on a pre-release runtime without its factory.
    adr x0, LMglass_factory
    bl Lpatch + (0xa5a4 - PATCH_BASE)
    mov x2, x0
    GET x22, LMresponds
    cbz w0, LMinvalidate
    mov w2, #1
    GET x22, LMglass_factory
    mov x23, x0
    cbz x23, LMinvalidate
    mov w2, #1
    GET x23, LMset_interactive
    mov x2, xzr
    GET x23, LMset_tint

    // Allocate both replacements before disturbing the current effect.
    // The factory's glass is autoreleased; UIVisualEffect.new is owned here.
    adr x0, LMvisual_effect_class
    bl Lpatch + (0xa5b0 - PATCH_BASE)
    cbz x0, LMinvalidate
    GET x0, LMnew
    mov x24, x0
    cbz x24, LMinvalidate
    mov x2, x24
    GET x20, LMset_effect
    GET x24, LMrelease
    mov x2, x23
    GET x20, LMset_effect

    // Refresh the public shape after final bounds exist. Never add an
    // ancestor mask or inspect UIKit's internal backdrop subviews.
    adr x0, LMcorner_class
    bl Lpatch + (0xa5b0 - PATCH_BASE)
    cbz x0, LMremember
    GET x0, LMcapsule
    cbz x0, LMremember
    mov x2, x0
    GET x20, LMset_corner
LMremember:
    ASET x20, LMwindow_key, x21, 0
    ASET x20, LMmounted_key, x20, 0
    mov w0, #1
    b LMupdate_done

LMinvalidate:
    mov x0, x20
    bl LMmaterial_reset
LMupdate_zero:
    mov w0, #0
LMupdate_done:
    ldp d8, d9, [sp, #64]
    ldp x23, x24, [sp, #48]
    ldp x21, x22, [sp, #32]
    ldp x19, x20, [sp, #16]
    ldp x29, x30, [sp], #80
    ret

// (proxy). Clear only our associated metadata. A stale cached window is
// never retained, released or messaged by this component.
LMmaterial_reset:
    stp x29, x30, [sp, #-32]!
    mov x29, sp
    stp x19, x20, [sp, #16]
    mov x19, x0
    cbz x19, LMreset_done
    ASET x19, LMmounted_key, xzr, 0
    ASET x19, LMwindow_key, xzr, 0
LMreset_done:
    ldp x19, x20, [sp, #16]
    ldp x29, x30, [sp], #32
    ret


// Main-thread diagnostic capture and the plugin-owned export UI.
// All persisted fields are Foundation JSON values, never live UIKit objects.
// Only export commands briefly retain their requesting settings controller.

Lfactory: // x0 class CString, x1 no-argument selector CString -> object
    stp x29, x30, [sp, #-32]!
    mov x29, sp
    stp x19, x20, [sp, #16]
    mov x19, x1
    bl Lpatch + (0xa5b0 - PATCH_BASE)
    mov x1, x19
    bl Lmessage
    ldp x19, x20, [sp, #16]
    ldp x29, x30, [sp], #32
    ret
Lnewdict:
    adr x0, LSdictionary_class
    adr x1, LSdictionary
    b Lfactory
Lnewarray:
    adr x0, LSarray_class
    adr x1, LSarray
    b Lfactory
Lstr: // UTF-8 CString -> autoreleased NSString
    stp x29, x30, [sp, #-32]!
    mov x29, sp
    stp x19, x20, [sp, #16]
    mov x19, x0
    adr x0, LSstring_class
    bl Lpatch + (0xa5b0 - PATCH_BASE)
    mov x2, x19
    adr x1, LSstring_utf8
    bl Lmessage
    ldp x19, x20, [sp, #16]
    ldp x29, x30, [sp], #32
    ret
Luint:
    stp x29, x30, [sp, #-32]!
    mov x29, sp
    stp x19, x20, [sp, #16]
    mov x19, x0
    adr x0, Lnumber_class
    bl Lpatch + (0xa5b0 - PATCH_BASE)
    mov x2, x19
    adr x1, LSnumber_uint
    bl Lmessage
    ldp x19, x20, [sp, #16]
    ldp x29, x30, [sp], #32
    ret
Lnumber:
    stp x29, x30, [sp, #-32]!
    mov x29, sp
    stp d8, d9, [sp, #16]
    FINITE d0, LSnumber_invalid
    fmov d8, d0
    adr x0, Lnumber_class
    bl Lpatch + (0xa5b0 - PATCH_BASE)
    fmov d0, d8
    adr x1, LSnumber_double
    bl Lmessage
    b LSnumber_done
LSnumber_invalid:
    adr x0, LSnonfinite
    bl Lstr
LSnumber_done:
    ldp d8, d9, [sp, #16]
    ldp x29, x30, [sp], #32
    ret
Ldict_set: // mutable dictionary, key CString, value (nil becomes NSNull)
    stp x29, x30, [sp, #-48]!
    mov x29, sp
    stp x19, x20, [sp, #16]
    stp x21, x22, [sp, #32]
    mov x19, x0
    mov x21, x1
    mov x20, x2
    cbnz x20, LSdict_has_value
    adr x0, LSnull_class
    adr x1, LSnull
    bl Lfactory
    mov x20, x0
LSdict_has_value:
    mov x0, x21
    bl Lstr
    mov x3, x0
    mov x2, x20
    GET x19, LSset_object
    ldp x21, x22, [sp, #32]
    ldp x19, x20, [sp, #16]
    ldp x29, x30, [sp], #48
    ret
Lnow:
    stp x29, x30, [sp, #-16]!
    mov x29, sp
    adr x0, LSdate_class
    adr x1, LSdate
    bl Lfactory
    adr x1, LStime
    bl Lmessage
    ldp x29, x30, [sp], #16
    ret
Lrect_array:
    stp x29, x30, [sp, #-64]!
    mov x29, sp
    stp x19, x20, [sp, #16]
    stp d8, d9, [sp, #32]
    stp d10, d11, [sp, #48]
    fmov d8, d0
    fmov d9, d1
    fmov d10, d2
    fmov d11, d3
    bl Lnewarray
    mov x19, x0
    fmov d0, d8
    bl Lnumber
    mov x2, x0
    GET x19, LSadd_object
    fmov d0, d9
    bl Lnumber
    mov x2, x0
    GET x19, LSadd_object
    fmov d0, d10
    bl Lnumber
    mov x2, x0
    GET x19, LSadd_object
    fmov d0, d11
    bl Lnumber
    mov x2, x0
    GET x19, LSadd_object
    mov x0, x19
    ldp d10, d11, [sp, #48]
    ldp d8, d9, [sp, #32]
    ldp x19, x20, [sp, #16]
    ldp x29, x30, [sp], #64
    ret
Lclass_name: // Uses class description, never a view's/user-content description.
    stp x29, x30, [sp, #-16]!
    mov x29, sp
    adr x1, LSclass
    bl Lmessage
    adr x1, LSdescription
    bl Lmessage
    ldp x29, x30, [sp], #16
    ret

Ldescribe_view:
    stp x29, x30, [sp, #-48]!
    mov x29, sp
    stp x19, x20, [sp, #16]
    stp x21, x22, [sp, #32]
    mov x19, x0
    cbz x19, LSview_nil
    bl Lnewdict
    mov x20, x0
    mov x0, x19
    bl Luint
    mov x2, x0
    mov x0, x20
    adr x1, LSk_id
    bl Ldict_set
    mov x0, x19
    bl Lclass_name
    mov x2, x0
    mov x0, x20
    adr x1, LSk_class
    bl Ldict_set
    GET x19, LSframe
    bl Lrect_array
    mov x2, x0
    mov x0, x20
    adr x1, LSk_frame
    bl Ldict_set
    GET x19, Lbounds
    bl Lrect_array
    mov x2, x0
    mov x0, x20
    adr x1, LSk_bounds
    bl Ldict_set
    GET x19, Lalpha
    bl Lnumber
    mov x2, x0
    mov x0, x20
    adr x1, LSk_alpha
    bl Ldict_set
    GET x19, Lis_hidden
    and w0, w0, #1
    bl Luint
    mov x2, x0
    mov x0, x20
    adr x1, LSk_hidden
    bl Ldict_set
    GET x19, LSopaque
    and w0, w0, #1
    bl Luint
    mov x2, x0
    mov x0, x20
    adr x1, LSk_opaque
    bl Ldict_set
    GET x19, LSbackground
    adr x1, LSdescription
    bl Lmessage
    mov x2, x0
    mov x0, x20
    adr x1, LSk_background
    bl Ldict_set
    GET x19, Llayer
    mov x21, x0
    GET x21, LSbackground
    cbz x0, LSview_no_layer_color
    mov x22, x0
    adr x0, LScolor_class
    bl Lpatch + (0xa5b0 - PATCH_BASE)
    mov x2, x22
    adr x1, LScolor_cg
    bl Lmessage
    adr x1, LSdescription
    bl Lmessage
LSview_no_layer_color:
    mov x2, x0
    mov x0, x20
    adr x1, LSk_layer_color
    bl Ldict_set
    GET x21, LSopacity
    fcvt d0, s0
    bl Lnumber
    mov x2, x0
    mov x0, x20
    adr x1, LSk_layer_opacity
    bl Ldict_set
    GET x21, LSshadow_opacity
    fcvt d0, s0
    bl Lnumber
    mov x2, x0
    mov x0, x20
    adr x1, LSk_shadow_opacity
    bl Ldict_set
    GET x21, LSshadow_radius
    bl Lnumber
    mov x2, x0
    mov x0, x20
    adr x1, LSk_shadow_radius
    bl Ldict_set
    GET x21, LSshould_rasterize
    and w0, w0, #1
    bl Luint
    mov x2, x0
    mov x0, x20
    adr x1, LSk_rasterize
    bl Ldict_set
    GET x21, LSraster_scale
    bl Lnumber
    mov x2, x0
    mov x0, x20
    adr x1, LSk_raster_scale
    bl Ldict_set
    GET x21, LSmask
    cmp x0, #0
    cset w0, ne
    bl Luint
    mov x2, x0
    mov x0, x20
    adr x1, LSk_mask
    bl Ldict_set
    GET x21, LSmasks
    and w0, w0, #1
    bl Luint
    mov x2, x0
    mov x0, x20
    adr x1, LSk_clips
    bl Ldict_set
    mov x0, x19
    adr x1, LSbutton_class
    bl Lpatch + (0x7394 - PATCH_BASE)
    cbz w0, LSview_effect_details
    GET x19, LStitle_label
    mov x21, x0
    adr x1, LSlabel_class
    bl Lpatch + (0x7394 - PATCH_BASE)
    cbz w0, LSview_effect_details
    mov x0, x21
    bl Ldescribe_view
    mov x2, x0
    mov x0, x20
    adr x1, LSk_title_label
    bl Ldict_set
LSview_effect_details:
    mov x0, x19
    adr x1, LSeffect_view_class
    bl Lpatch + (0x7394 - PATCH_BASE)
    cbz w0, LSview_done
    GET x19, LSeffect
    mov x21, x0
    bl Lclass_name
    mov x2, x0
    mov x0, x20
    adr x1, LSk_effect
    bl Ldict_set
    mov x0, x21
    adr x1, LSglass_class
    bl Lpatch + (0x7394 - PATCH_BASE)
    cbz w0, LSview_done
    GET x21, LStint
    adr x1, LSdescription
    bl Lmessage
    mov x2, x0
    mov x0, x20
    adr x1, LSk_tint
    bl Ldict_set
    GET x21, LSinteractive
    and w0, w0, #1
    bl Luint
    mov x2, x0
    mov x0, x20
    adr x1, LSk_interactive
    bl Ldict_set
LSview_done:
    mov x0, x20
    b LSview_return
LSview_nil:
    adr x0, LSnull_class
    adr x1, LSnull
    bl Lfactory
LSview_return:
    ldp x21, x22, [sp, #32]
    ldp x19, x20, [sp, #16]
    ldp x29, x30, [sp], #48
    ret

Ldescribe_children: // Bounded metadata, with explicit truncation/count fields.
    mov w1, #0
Ldescribe_children_inner:
    stp x29, x30, [sp, #-96]!
    mov x29, sp
    stp x19, x20, [sp, #16]
    stp x21, x22, [sp, #32]
    stp x23, x24, [sp, #48]
    stp x25, x26, [sp, #64]
    stp x27, x28, [sp, #80]
    mov w28, w1
    mov x19, x0
    bl Lnewdict
    mov x20, x0
    bl Lnewarray
    mov x21, x0
    GET x19, Lsubviews
    mov x22, x0
    GET x22, Lcount
    mov x23, x0
    bl Luint
    mov x2, x0
    mov x0, x20
    adr x1, LSk_count
    bl Ldict_set
    cmp x23, #16
    cset w0, hi
    bl Luint
    mov x2, x0
    mov x0, x20
    adr x1, LSk_truncated
    bl Ldict_set
    mov x24, #16
    cmp x23, x24
    csel x24, x23, x24, lo
    mov x25, #0
LSchildren_loop:
    cmp x25, x24
    b.hs LSchildren_done
    mov x2, x25
    GET x22, Lobject_at
    mov x26, x0
    bl Ldescribe_view
    mov x27, x0
    cmp w28, #2
    b.hs LSchildren_append
    mov x0, x26
    adr x1, LSbar_wrapper_class
    bl Lpatch + (0x7394 - PATCH_BASE)
    cbnz w0, LSchildren_native
    mov x0, x26
    adr x1, LSnative_bar_class
    bl Lpatch + (0x7394 - PATCH_BASE)
    cbz w0, LSchildren_append
LSchildren_native:
    mov x0, x26
    add w1, w28, #1
    bl Ldescribe_children_inner
    mov x2, x0
    mov x0, x27
    adr x1, LSnative_children
    bl Ldict_set
LSchildren_append:
    mov x2, x27
    GET x21, LSadd_object
    add x25, x25, #1
    b LSchildren_loop
LSchildren_done:
    mov x0, x20
    adr x1, LSk_views
    mov x2, x21
    bl Ldict_set
    mov x0, x20
    ldp x27, x28, [sp, #80]
    ldp x25, x26, [sp, #64]
    ldp x23, x24, [sp, #48]
    ldp x21, x22, [sp, #32]
    ldp x19, x20, [sp, #16]
    ldp x29, x30, [sp], #96
    ret

// All owned effects, without reading titles, search text, or book contents.
Ldescribe_managed:
    stp x29, x30, [sp, #-80]!
    mov x29, sp
    stp x19, x20, [sp, #16]
    stp x21, x22, [sp, #32]
    stp x23, x24, [sp, #48]
    stp x25, x26, [sp, #64]
    mov x19, x0
    bl Lnewarray
    mov x20, x0
    GET x19, Lcount
    mov x21, x0
    mov x22, #0
LSmanaged_loop:
    cmp x22, x21
    b.hs LSmanaged_done
    mov x2, x22
    GET x19, Lobject_at
    mov x23, x0
    mov x2, #0
    GET x23, Lobject_at
    mov x24, x0
    bl Ldescribe_view
    mov x25, x0
    GET x24, Lcontent_size
    fmov d2, d0
    fmov d3, d1
    fmov d0, xzr
    fmov d1, xzr
    bl Lrect_array
    mov x2, x0
    mov x0, x25
    adr x1, LScontent_rect
    bl Ldict_set
    GET x24, Lwindow
    mov x26, x0
    GET x24, Lbounds
    mov x2, x26
    GET x24, Lconvert_rect
    bl Lrect_array
    mov x2, x0
    mov x0, x25
    adr x1, LSwindow_rect
    bl Ldict_set
    mov x2, #2
    GET x23, Lobject_at
    mov x2, x0
    mov x0, x25
    adr x1, LSoriginal_edge_hidden
    bl Ldict_set
    mov x2, #1
    GET x23, Lobject_at
    GET x0, Lis_hidden
    and w0, w0, #1
    bl Luint
    mov x2, x0
    mov x0, x25
    adr x1, LScurrent_edge_hidden
    bl Ldict_set
    mov x2, x25
    GET x20, LSadd_object
    add x22, x22, #1
    b LSmanaged_loop
LSmanaged_done:
    mov x0, x20
    ldp x25, x26, [sp, #64]
    ldp x23, x24, [sp, #48]
    ldp x21, x22, [sp, #32]
    ldp x19, x20, [sp, #16]
    ldp x29, x30, [sp], #80
    ret

Lrecord_named: // x0 event CString, x1 completed immutable-by-convention JSON data
    stp x29, x30, [sp, #-48]!
    mov x29, sp
    stp x19, x20, [sp, #16]
    stp x21, x22, [sp, #32]
    mov x19, x0
    mov x20, x1
    bl Lnewdict
    mov x21, x0
    mov x0, x19
    bl Lstr
    mov x2, x0
    mov x0, x21
    adr x1, LSk_event
    bl Ldict_set
    mov x0, x21
    adr x1, LSk_data
    mov x2, x20
    bl Ldict_set
    bl Lnow
    bl Lnumber
    mov x2, x0
    mov x0, x21
    adr x1, LSk_timestamp
    bl Ldict_set
    adr x0, LSversion
    bl Lstr
    mov x2, x0
    mov x0, x21
    adr x1, LSk_version
    bl Ldict_set
    mov x0, x21
    bl LDdiag_enqueue
    ldp x21, x22, [sp, #32]
    ldp x19, x20, [sp, #16]
    ldp x29, x30, [sp], #48
    ret

Ltracked_bars:
    stp x29, x30, [sp, #-32]!
    mov x29, sp
    stp x19, x20, [sp, #16]
    bl LDdiag_init
    mov x19, x0
    AGET x19, LSbars_key
    cbnz x0, LStracked_done
    adr x0, LShash_class
    adr x1, LSweak_hash
    bl Lfactory
    mov x20, x0
    ASET x19, LSbars_key, x20, 1
    mov x0, x20
LStracked_done:
    ldp x19, x20, [sp, #16]
    ldp x29, x30, [sp], #32
    ret

// Automatic capture uses value-based color/effect state and a 0.5-second
// monotonic gate in the extension. Explicit snapshots below stay unthrottled.
Ldiagnostic_observe:
    b LDobserve_semantic

Ldiagnostic_snapshot: // x0 bar, x1 event CString; main thread only
    stp x29, x30, [sp, #-80]!
    mov x29, sp
    stp x19, x20, [sp, #16]
    stp x21, x22, [sp, #32]
    stp x23, x24, [sp, #48]
    stp x25, x26, [sp, #64]
    mov x19, x0
    mov x20, x1
    cbz x19, LSsnapshot_done
    bl Lnewdict
    mov x21, x0
    mov x0, x19
    adr x1, Lpatch + (0xeb84 - PATCH_BASE)
    bl Lpatch + (0xa628 - PATCH_BASE)
    mov x22, x0
    mov x0, x19
    bl Ldescribe_view
    mov x2, x0
    mov x0, x21
    adr x1, LSk_bar
    bl Ldict_set
    mov x0, x22
    bl Ldescribe_view
    mov x2, x0
    mov x0, x21
    adr x1, LSk_proxy
    bl Ldict_set
    GET x19, Lcontent_view
    bl Ldescribe_view
    mov x2, x0
    mov x0, x21
    adr x1, LSk_bar_content
    bl Ldict_set
    GET x22, Lcontent_view
    bl Ldescribe_view
    mov x2, x0
    mov x0, x21
    adr x1, LSk_proxy_content
    bl Ldict_set
    mov x0, x19
    bl Ldescribe_children
    mov x2, x0
    mov x0, x21
    adr x1, LSk_bar_children
    bl Ldict_set
    mov x0, x22
    bl Ldescribe_children
    mov x2, x0
    mov x0, x21
    adr x1, LSk_proxy_children
    bl Ldict_set
    GET x22, Lcontent_view
    bl Ldescribe_children
    mov x2, x0
    mov x0, x21
    adr x1, LSk_content_children
    bl Ldict_set
    GET x19, Lsuperview
    mov x23, x0
    bl Ldescribe_children
    mov x2, x0
    mov x0, x21
    adr x1, LSk_siblings
    bl Ldict_set
    AGET x19, Ledge_key
    bl Ldescribe_managed
    mov x2, x0
    mov x0, x21
    adr x1, LSk_managed_scroll
    bl Ldict_set
    AGET x19, Lparent_key
    mov x2, x0
    mov x0, x21
    adr x1, LSk_edge_original
    bl Ldict_set
    AGET x19, Lselected_key
    mov x2, x0
    mov x0, x21
    adr x1, LSk_edge_current
    bl Ldict_set
    bl Lnewarray
    mov x24, x0
    mov w25, #8
LSancestor_loop:
    cbz x23, LSancestor_done
    cbz w25, LSancestor_done
    mov x0, x23
    bl Ldescribe_view
    mov x2, x0
    GET x24, LSadd_object
    GET x23, Lsuperview
    mov x23, x0
    sub w25, w25, #1
    b LSancestor_loop
LSancestor_done:
    mov x0, x21
    adr x1, LSk_ancestors
    mov x2, x24
    bl Ldict_set
    cmp x23, #0
    cset w0, ne
    bl Luint
    mov x2, x0
    mov x0, x21
    adr x1, LSk_ancestor_truncated
    bl Ldict_set
    GET x19, LSitems
    mov x23, x0
    cbz x23, LSsnapshot_unknown_selection
    GET x19, Lselected_item
    cbz x0, LSsnapshot_unknown_selection
    mov x2, x0
    GET x23, LSindex_identical
    cmp x0, #255
    b.hi LSsnapshot_unknown_selection
    bl Luint
    b LSsnapshot_selection_ready
LSsnapshot_unknown_selection:
    mov x0, #0
LSsnapshot_selection_ready:
    mov x2, x0
    mov x0, x21
    adr x1, LSk_selected
    bl Ldict_set
    adr x0, LSclear_style
    bl Lstr
    mov x2, x0
    mov x0, x21
    adr x1, LSk_style
    bl Ldict_set
    GET x19, LStraits
    adr x1, LScontrast
    bl Lmessage
    bl Luint
    mov x2, x0
    mov x0, x21
    adr x1, LSk_contrast
    bl Ldict_set
    adr x0, LSunknown_transparency
    bl Lstr
    mov x2, x0
    mov x0, x21
    adr x1, LSk_transparency
    bl Ldict_set
    adr x0, LSprocess_class
    adr x1, LSprocess
    bl Lfactory
    adr x1, LSos_version
    bl Lmessage
    mov x2, x0
    mov x0, x21
    adr x1, LSk_os
    bl Ldict_set
    bl Lpatch + (0x4338 - PATCH_BASE)
    bl Luint
    mov x2, x0
    mov x0, x21
    adr x1, LSk_options
    bl Ldict_set
    mov x0, x19
    mov x1, x21
    bl LXsnapshot
    mov x0, x20
    mov x1, x21
    bl Lrecord_named
LSsnapshot_done:
    ldp x25, x26, [sp, #64]
    ldp x23, x24, [sp, #48]
    ldp x21, x22, [sp, #32]
    ldp x19, x20, [sp, #16]
    ldp x29, x30, [sp], #80
    ret

Ldiagnostic_heartbeat:
    adr x0, LSperiodic
    b Ldiagnostic_snapshot_all
Ldiagnostic_snapshot_all:
    stp x29, x30, [sp, #-64]!
    mov x29, sp
    stp x19, x20, [sp, #16]
    stp x21, x22, [sp, #32]
    stp x23, x24, [sp, #48]
    mov x19, x0
    adr x0, LSthread_class
    adr x1, LSmain_thread
    bl Lfactory
    cbz w0, LSsnapshot_all_done
    bl Ltracked_bars
    adr x1, LSall_objects
    bl Lmessage
    mov x20, x0
    GET x20, Lcount
    mov x21, x0
    mov x22, #0
    cbnz x21, LSsnapshot_all_loop
    mov x0, x19
    mov x1, #0
    bl Lrecord_named
    b LSsnapshot_all_done
LSsnapshot_all_loop:
    cmp x22, x21
    b.hs LSsnapshot_all_done
    mov x2, x22
    GET x20, Lobject_at
    mov x1, x19
    bl Ldiagnostic_snapshot
    add x22, x22, #1
    b LSsnapshot_all_loop
LSsnapshot_all_done:
    ldp x23, x24, [sp, #48]
    ldp x21, x22, [sp, #32]
    ldp x19, x20, [sp, #16]
    ldp x29, x30, [sp], #64
    ret

Lsettings_boot:
    stp x29, x30, [sp, #-16]!
    mov x29, sp
    bl Lsettings_original
    bl LDdiag_init
    adr x0, LSstartup
    mov x1, #0
    bl Lrecord_named
    ldp x29, x30, [sp], #16
    ret
Lsettings_original:
    stp x22, x21, [sp, #-48]!
    b Lpatch + (0x4708 - PATCH_BASE)

// x0 Class, x1 selector CString, x2 IMP. Add only our methods; accept an
// already-installed identical implementation, never replace another owner.
LUIadd_method:
    stp x29, x30, [sp, #-48]!
    mov x29, sp
    stp x19, x20, [sp, #16]
    stp x21, x22, [sp, #32]
    mov x19, x0
    mov x21, x2
    mov x0, x1
    bl Lpatch + (0xa5a4 - PATCH_BASE)
    mov x20, x0
    mov x1, x20
    mov x0, x19
    mov x2, x21
    adr x3, Lobject_encoding
    bl Lpatch + (0xa58c - PATCH_BASE)
    cbnz w0, LUIadd_done
    mov x0, x19
    mov x1, x20
    bl Lpatch + (0xa5f8 - PATCH_BASE)
    cbz x0, LUIadd_done
    bl Lpatch + (0xa598 - PATCH_BASE)
    cmp x0, x21
    cset w0, eq
LUIadd_done:
    ldp x21, x22, [sp, #32]
    ldp x19, x20, [sp, #16]
    ldp x29, x30, [sp], #48
    ret

// Called at the audited NOP in _open_menu. x20 is the newly created plugin
// options controller; all original live callee-saved registers are preserved.
LUIinstall:
    stp x29, x30, [sp, #-64]!
    mov x29, sp
    stp x19, x20, [sp, #16]
    stp x21, x22, [sp, #32]
    stp x23, x24, [sp, #48]
    mov x19, x20
    cbz x19, LUIinstall_done
    GET x19, LSclass
    mov x20, x0
    adr x1, LUexport_sel
    adr x2, LUIexport
    bl LUIadd_method
    cbz w0, LUIinstall_done
    mov x0, x20
    adr x1, LUpresent_sel
    adr x2, LUIpresent
    bl LUIadd_method
    cbz w0, LUIinstall_done
    adr x0, LUexport_title
    bl Lstr
    mov x21, x0
    adr x0, LUexport_sel
    bl Lpatch + (0xa5a4 - PATCH_BASE)
    mov x23, x0
    adr x0, LUitem_class
    adr x1, LUalloc
    bl Lfactory
    mov x2, x21
    mov w3, #0
    mov x4, x19
    mov x5, x23
    adr x1, LUinit_item
    bl Lmessage
    mov x22, x0
    cbz x22, LUIinstall_done
    GET x19, LUnavigation_item
    mov x2, x22
    adr x1, LUset_left_item
    bl Lmessage
    GET x22, Lrelease
LUIinstall_done:
    ldp x23, x24, [sp, #48]
    ldp x21, x22, [sp, #32]
    ldp x19, x20, [sp, #16]
    ldp x29, x30, [sp], #64
    ret

LUIexport: // Objective-C action: self, _cmd, sender
    stp x29, x30, [sp, #-48]!
    mov x29, sp
    stp x19, x20, [sp, #16]
    stp x21, x22, [sp, #32]
    mov x19, x0
    mov x20, x2
    cbz x20, LUIexport_done
    AGET x19, LUbusy_key
    cbnz x0, LUIexport_done
    GET x19, LUpresented
    cbnz x0, LUIexport_done
    GET x19, LUview
    GET x0, Lwindow
    cbz x0, LUIexport_done
    ASET x19, LUbusy_key, x19, 0
    ASET x19, LUsender_key, x20, 1
    mov w2, #0
    GET x20, LUset_enabled
    bl LDdiag_init
    cbz x0, LUIexport_unavailable
    adr x0, LUexport_snapshot
    bl Ldiagnostic_snapshot_all
    bl Lnewdict
    mov x21, x0
    mov x2, x19
    adr x1, LUexport_target
    bl Ldict_set
    bl Lnow
    bl Lnumber
    mov x2, x0
    mov x0, x21
    adr x1, LSk_timestamp
    bl Ldict_set
    mov x0, x21
    bl LDdiag_enqueue
    b LUIexport_done
LUIexport_unavailable:
    bl Lnewdict
    mov x21, x0
    adr x0, LUunavailable
    bl Lstr
    mov x2, x0
    mov x0, x21
    adr x1, LUerror
    bl Ldict_set
    mov x0, x19
    mov x2, x21
    bl LUIpresent
LUIexport_done:
    ldp x21, x22, [sp, #32]
    ldp x19, x20, [sp, #16]
    ldp x29, x30, [sp], #48
    ret

// Worker completion is explicitly scheduled on the main thread. The result
// contains a unique file URL or a readable error; UIKit never runs on worker.
LUIpresent:
    stp x29, x30, [sp, #-64]!
    mov x29, sp
    stp x19, x20, [sp, #16]
    stp x21, x22, [sp, #32]
    stp x23, x24, [sp, #48]
    mov x19, x0
    mov x21, x2
    AGET x19, LUsender_key
    GET x0, Lretain
    mov x20, x0
    ASET x19, LUbusy_key, xzr, 0
    mov w2, #1
    GET x20, LUset_enabled
    ASET x19, LUsender_key, xzr, 1
    cbz x20, LUIpresent_done
    GET x19, LUview
    GET x0, Lwindow
    cbz x0, LUIpresent_release_sender
    GET x19, LUpresented
    cbnz x0, LUIpresent_release_sender
    adr x0, LUurl
    bl Lstr
    mov x2, x0
    GET x21, LUobject_key
    mov x22, x0
    cbz x22, LUIpresent_error
    adr x0, LUarray_class
    bl Lpatch + (0xa5b0 - PATCH_BASE)
    mov x2, x22
    adr x1, LUarray_object
    bl Lmessage
    mov x23, x0
    adr x0, LUactivity_class
    adr x1, LUalloc
    bl Lfactory
    mov x2, x23
    mov x3, xzr
    adr x1, LUinit_activity
    bl Lmessage
    mov x22, x0
    cbz x22, LUIpresent_release_sender
    GET x22, LUpopover
    mov x2, x20
    adr x1, LUset_anchor
    bl Lmessage
    mov x2, x22
    mov w3, #1
    mov x4, xzr
    GET x19, LUpresent
    GET x22, Lrelease
    b LUIpresent_release_sender
LUIpresent_error:
    adr x0, LUerror
    bl Lstr
    mov x2, x0
    GET x21, LUobject_key
    mov x22, x0
    cbnz x22, LUIhas_error
    adr x0, LUunavailable
    bl Lstr
    mov x22, x0
LUIhas_error:
    adr x0, LUfailure_title
    bl Lstr
    mov x23, x0
    adr x0, LUalert_class
    bl Lpatch + (0xa5b0 - PATCH_BASE)
    mov x2, x23
    mov x3, x22
    mov w4, #1
    adr x1, LUalert_factory
    bl Lmessage
    mov x22, x0
    adr x0, LUokay
    bl Lstr
    mov x23, x0
    adr x0, LUaction_class
    bl Lpatch + (0xa5b0 - PATCH_BASE)
    mov x2, x23
    mov w3, #0
    mov x4, xzr
    adr x1, LUaction_factory
    bl Lmessage
    mov x2, x0
    GET x22, LUadd_action
    mov x2, x22
    mov w3, #1
    mov x4, xzr
    GET x19, LUpresent
LUIpresent_release_sender:
    GET x20, Lrelease
LUIpresent_done:
    ldp x23, x24, [sp, #48]
    ldp x21, x22, [sp, #32]
    ldp x19, x20, [sp, #16]
    ldp x29, x30, [sp], #64
    ret


// FanqieAdBlock 1.5.7 diagnostic store component.
// Main assembly owns Lpatch/PATCH_BASE, GET/AGET/ASET, Lmessage, Lstr,
// Lnumber, Ldict_set and Ldiagnostic_heartbeat. No imports or writable globals.
// Public: LDdiag_init, LDdiag_enqueue, LDdiag_tick, LDdiag_maintenance.
// Store format: binary plist NSArray containing ONE NSData. That NSData is
// JSON for the complete retained record array, preserving JSON null values.

.macro LDGET receiver, key
    mov x0, \receiver
    adr x1, \key
    bl LDdict_get
.endm
.macro LDSET receiver, key, value
    mov x2, \value
    mov x0, \receiver
    adr x1, \key
    bl Ldict_set
.endm
.macro LDNEW name
    adr x0, \name
    bl LDnew
.endm
.macro LDADD klass, sel, imp, encoding
    mov x0, \klass
    adr x1, \sel
    adr x2, \imp
    adr x3, \encoding
    bl LDadd_method
.endm
.macro LDFINITE reg, failure
    fmov x8, \reg
    ubfx x8, x8, #52, #11
    cmp x8, #2047
    b.eq \failure
.endm

// Class bootstrap is called before installing capture hooks. +initialize
// serializes singleton construction even when subsequent callers race.
LDdiag_init:
    stp x29, x30, [sp, #-48]!
    mov x29, sp
    stp x19, x20, [sp, #16]
    stp x21, x22, [sp, #32]
    adr x0, LDclass_name
    bl Lpatch + (0xa5b0 - PATCH_BASE)
    mov x19, x0
    cbnz x19, LDinit_use
    adr x0, LDobject_class
    bl Lpatch + (0xa5b0 - PATCH_BASE)
    adr x1, LDclass_name
    mov x2, #0
    bl Lpatch + (0xa61c - PATCH_BASE)
    mov x19, x0
    cbz x19, LDinit_retry
    LDADD x19, LDdrain_sel, LDdrain, LDobject_encoding
    LDADD x19, LDtick_sel, LDdiag_tick, LDobject_encoding
    LDADD x19, LDtimer_sel, LDstart_timer, LDobject_encoding
    mov x0, x19
    bl Lpatch + (0xa664 - PATCH_BASE)
    mov x20, x0
    LDADD x20, LDinitialize_sel, LDinitialize, LDvoid_encoding
    LDADD x20, LDshared_sel, LDshared, LDreturn_encoding
    mov x0, x19
    bl Lpatch + (0xa610 - PATCH_BASE)
    b LDinit_use
LDinit_retry:
    adr x0, LDclass_name
    bl Lpatch + (0xa5b0 - PATCH_BASE)
    mov x19, x0
LDinit_use:
    cbz x19, LDinit_none
    adr x0, LDshared_sel
    bl Lpatch + (0xa5a4 - PATCH_BASE)
    mov x2, x0
    GET x19, LDresponds
    cbz w0, LDinit_none
    GET x19, LDshared_sel
    b LDinit_done
LDinit_none:
    mov x0, #0
LDinit_done:
    ldp x21, x22, [sp, #32]
    ldp x19, x20, [sp, #16]
    ldp x29, x30, [sp], #48
    ret

LDadd_method:
    stp x29, x30, [sp, #-48]!
    mov x29, sp
    stp x19, x20, [sp, #16]
    stp x21, x22, [sp, #32]
    mov x19, x0
    mov x20, x2
    mov x21, x3
    mov x0, x1
    bl Lpatch + (0xa5a4 - PATCH_BASE)
    mov x1, x0
    mov x0, x19
    mov x2, x20
    mov x3, x21
    bl Lpatch + (0xa58c - PATCH_BASE)
    ldp x21, x22, [sp, #32]
    ldp x19, x20, [sp, #16]
    ldp x29, x30, [sp], #48
    ret

LDshared:
    adr x1, LDsingleton_key
    b Lpatch + (0xa628 - PATCH_BASE)

LDinitialize:
    stp x29, x30, [sp, #-48]!
    mov x29, sp
    stp x19, x20, [sp, #16]
    stp x21, x22, [sp, #32]
    mov x19, x0
    AGET x19, LDsingleton_key
    cbnz x0, LDinitialize_done
    GET x19, LDalloc
    GET x0, LDinit
    mov x20, x0
    LDNEW LDlock_class
    ASET x20, LDlock_key, x0, 1
    LDNEW LDmutable_array
    ASET x20, LDpending_key, x0, 1
    LDNEW LDqueue_class
    mov x21, x0
    mov x2, #1
    GET x21, LDmax_concurrent
    ASET x20, LDqueue_key, x21, 1
    bl LDnow
    bl Lnumber
    ASET x20, LDstart_key, x0, 1
    ASET x19, LDsingleton_key, x20, 1
    GET x20, LDrelease
    adr x0, LDtimer_sel
    bl Lpatch + (0xa5a4 - PATCH_BASE)
    mov x2, x0
    mov x3, #0
    mov w4, #0
    GET x20, LDperform_main
    bl LDdiag_maintenance
LDinitialize_done:
    ldp x21, x22, [sp, #32]
    ldp x19, x20, [sp, #16]
    ldp x29, x30, [sp], #48
    ret

// Invoked on the main thread through NSObject, not assumed in constructor.
LDstart_timer:
    stp x29, x30, [sp, #-48]!
    mov x29, sp
    stp x19, x20, [sp, #16]
    stp x21, x22, [sp, #32]
    mov x19, x0
    AGET x19, LDtimer_key
    cbnz x0, LDtimer_done
    adr x0, LDtimer_class
    bl Lpatch + (0xa5b0 - PATCH_BASE)
    mov x20, x0
    adr x0, LDtick_sel
    bl Lpatch + (0xa5a4 - PATCH_BASE)
    mov x3, x0
    mov x2, x19
    mov x4, #0
    mov w5, #1
    mov w8, #60
    scvtf d0, w8
    GET x20, LDscheduled_timer
    ASET x19, LDtimer_key, x0, 1
LDtimer_done:
    ldp x21, x22, [sp, #32]
    ldp x19, x20, [sp, #16]
    ldp x29, x30, [sp], #48
    ret

LDdiag_tick:
    stp x29, x30, [sp, #-16]!
    mov x29, sp
    bl Ldiagnostic_heartbeat
    bl LDdiag_maintenance
    ldp x29, x30, [sp], #16
    ret

LDdiag_maintenance:
    stp x29, x30, [sp, #-32]!
    mov x29, sp
    stp x19, x20, [sp, #16]
    LDNEW LDmutable_dict
    mov x19, x0
    adr x0, LDtrue_string
    bl Lstr
    LDSET x19, LDmaintenance_field, x0
    mov x0, x19
    bl LDdiag_enqueue
    ldp x19, x20, [sp, #16]
    ldp x29, x30, [sp], #32
    ret

// Commands must be NSDictionary graphs. Root provides fresh, stable nested
// data. The mutable top-level copy owns exportTarget until the marker runs.
// Lock covers timestamp completion, sequence allocation and FIFO insertion.
LDdiag_enqueue:
    stp x29, x30, [sp, #-80]!
    mov x29, sp
    stp x19, x20, [sp, #16]
    stp x21, x22, [sp, #32]
    stp x23, x24, [sp, #48]
    stp x25, x26, [sp, #64]
    mov x19, x0
    cbz x19, LDenqueue_done
    adr x1, LDdict_class
    bl Lpatch + (0x7394 - PATCH_BASE)
    cbz w0, LDenqueue_done
    bl LDdiag_init
    mov x20, x0
    cbz x20, LDenqueue_done
    GET x19, LDmutable_copy
    mov x19, x0
    AGET x20, LDlock_key
    mov x21, x0
    GET x21, LDlock
    LDGET x19, LDtimestamp_field
    mov x22, x0
    adr x1, LDnumber_class
    bl Lpatch + (0x7394 - PATCH_BASE)
    cbz w0, LDenqueue_time
    GET x22, LDdouble_value
    LDFINITE d0, LDenqueue_time
    b LDenqueue_sequence
LDenqueue_time:
    bl LDnow
    bl Lnumber
    LDSET x19, LDtimestamp_field, x0
LDenqueue_sequence:
    AGET x20, LDsequence_key
    GET x0, LDunsigned_value
    add x23, x0, #1
    adr x0, LDnumber_class
    bl Lpatch + (0xa5b0 - PATCH_BASE)
    mov x2, x23
    GET x0, LDunsigned_number
    mov x23, x0
    ASET x20, LDsequence_key, x23, 1
    LDSET x19, LDsequence_field, x23
    AGET x20, LDpending_key
    mov x2, x19
    GET x0, LDadd_object
    GET x21, LDunlock
    GET x19, LDrelease
    mov x0, x20
    bl LDschedule
LDenqueue_done:
    ldp x25, x26, [sp, #64]
    ldp x23, x24, [sp, #48]
    ldp x21, x22, [sp, #32]
    ldp x19, x20, [sp, #16]
    ldp x29, x30, [sp], #80
    ret

// Every enqueue schedules a drain; no running flag and no lost-wakeup window.
// Queue order is irrelevant: every drain consumes the shared FIFO itself.
LDschedule:
    stp x29, x30, [sp, #-48]!
    mov x29, sp
    stp x19, x20, [sp, #16]
    stp x21, x22, [sp, #32]
    mov x19, x0
    adr x0, LDoperation_class
    bl Lpatch + (0xa5b0 - PATCH_BASE)
    GET x0, LDalloc
    mov x20, x0
    adr x0, LDdrain_sel
    bl Lpatch + (0xa5a4 - PATCH_BASE)
    mov x3, x0
    mov x2, x19
    mov x4, #0
    GET x20, LDoperation_init
    mov x20, x0
    cbz x20, LDschedule_done
    AGET x19, LDqueue_key
    mov x2, x20
    GET x0, LDadd_operation
    GET x20, LDrelease
LDschedule_done:
    ldp x21, x22, [sp, #32]
    ldp x19, x20, [sp, #16]
    ldp x29, x30, [sp], #48
    ret

LDnow:
    stp x29, x30, [sp, #-16]!
    mov x29, sp
    adr x0, LDdate_class
    bl Lpatch + (0xa5b0 - PATCH_BASE)
    GET x0, LDdate
    GET x0, LDunix_time
    ldp x29, x30, [sp], #16
    ret

// (class CString) -> autoreleased default-initialized object.
LDnew:
    stp x29, x30, [sp, #-16]!
    mov x29, sp
    bl Lpatch + (0xa5b0 - PATCH_BASE)
    GET x0, LDalloc
    GET x0, LDinit
    GET x0, LDautorelease
    ldp x29, x30, [sp], #16
    ret

// (dictionary, key CString) -> borrowed value.
LDdict_get:
    stp x29, x30, [sp, #-32]!
    mov x29, sp
    stp x19, x20, [sp, #16]
    mov x19, x0
    mov x0, x1
    bl Lstr
    mov x2, x0
    GET x19, LDobject_key
    ldp x19, x20, [sp, #16]
    ldp x29, x30, [sp], #32
    ret

// Worker only: retain a readable, latched error. Successful later writes do
// not hide an earlier lost-history / storage incident in this process.
// (logger, NSError or nil, fallback CString) -> associated NSString.
LDerror:
    stp x29, x30, [sp, #-48]!
    mov x29, sp
    stp x19, x20, [sp, #16]
    stp x21, x22, [sp, #32]
    mov x19, x0
    mov x20, x1
    mov x21, x2
    cbz x20, LDerror_fallback
    GET x20, LDlocalized_error
    cbnz x0, LDerror_store
LDerror_fallback:
    mov x0, x21
    bl Lstr
LDerror_store:
    mov x20, x0
    ASET x19, LDerror_key, x20, 1
    mov x0, x20
    ldp x21, x22, [sp, #32]
    ldp x19, x20, [sp, #16]
    ldp x29, x30, [sp], #48
    ret

// (logger) -> retained-by-logger Application Support recent.plist URL.
// No I/O on UI threads. Unlike Caches, this directory is persistent storage.
LDpath:
    stp x29, x30, [sp, #-48]!
    mov x29, sp
    stp x19, x20, [sp, #16]
    stp x21, x22, [sp, #32]
    mov x19, x0
    AGET x19, LDurl_key
    cbnz x0, LDpath_done
    adr x0, LDfilemanager_class
    bl Lpatch + (0xa5b0 - PATCH_BASE)
    GET x0, LDdefault_manager
    mov x2, #14 // NSApplicationSupportDirectory
    mov x3, #1  // NSUserDomainMask
    GET x0, LDcache_urls
    GET x0, LDfirst_object
    mov x20, x0
    cbz x20, LDpath_fail
    adr x0, LDcache_name
    bl Lstr
    mov x2, x0
    GET x20, LDappend_component
    mov x20, x0
    adr x0, LDstore_name
    bl Lstr
    mov x2, x0
    GET x20, LDappend_component
    mov x20, x0
    ASET x19, LDurl_key, x20, 1
    mov x0, x20
    b LDpath_done
LDpath_fail:
    mov x0, x19
    mov x1, #0
    adr x2, LDcache_error
    bl LDerror
    mov x0, #0
LDpath_done:
    ldp x21, x22, [sp, #32]
    ldp x19, x20, [sp, #16]
    ldp x29, x30, [sp], #48
    ret

// Load once, without pruning against worker.now: a queued export marker may
// have an earlier fixed request time. The first command supplies the cutoff.
LDload:
    stp x29, x30, [sp, #-80]!
    mov x29, sp
    stp x19, x20, [sp, #16]
    stp x21, x22, [sp, #32]
    stp x23, x24, [sp, #48]
    mov x19, x0
    AGET x19, LDentries_key
    cbnz x0, LDload_done
    LDNEW LDmutable_array
    mov x20, x0
    ASET x19, LDentries_key, x20, 1
    mov x0, x19
    bl LDpath
    mov x21, x0
    cbz x21, LDload_return
    adr x0, LDfilemanager_class
    bl Lpatch + (0xa5b0 - PATCH_BASE)
    GET x0, LDdefault_manager
    mov x22, x0
    GET x21, LDpath_sel
    mov x2, x0
    GET x22, LDexists
    cbz w0, LDload_return
    str xzr, [sp, #64]
    adr x0, LDdata_class
    bl Lpatch + (0xa5b0 - PATCH_BASE)
    mov x2, x21
    mov x3, #0
    add x4, sp, #64
    GET x0, LDread_data
    cbz x0, LDload_io_error
    mov x21, x0
    adr x0, LDplist_class
    bl Lpatch + (0xa5b0 - PATCH_BASE)
    mov x2, x21
    mov x3, #0
    mov x4, #0
    add x5, sp, #64
    GET x0, LDread_plist
    cbz x0, LDload_io_error
    mov x21, x0
    adr x1, LDarray_class
    bl Lpatch + (0x7394 - PATCH_BASE)
    cbz w0, LDload_invalid
    GET x21, LDcount
    cmp x0, #1
    b.ne LDload_invalid
    GET x21, LDfirst_object
    mov x21, x0
    adr x1, LDdata_class
    bl Lpatch + (0x7394 - PATCH_BASE)
    cbz w0, LDload_invalid
    adr x0, LDjson_class
    bl Lpatch + (0xa5b0 - PATCH_BASE)
    mov x2, x21
    mov x3, #0
    add x4, sp, #64
    GET x0, LDread_json
    cbz x0, LDload_io_error
    mov x21, x0
    adr x1, LDarray_class
    bl Lpatch + (0x7394 - PATCH_BASE)
    cbz w0, LDload_invalid
    mov x2, x21
    GET x20, LDadd_array
    b LDload_return
LDload_io_error:
    mov x0, x19
    ldr x1, [sp, #64]
    adr x2, LDread_error
    bl LDerror
    b LDload_return
LDload_invalid:
    mov x0, x19
    mov x1, #0
    adr x2, LDformat_error
    bl LDerror
LDload_return:
    mov x0, x20
LDload_done:
    ldp x23, x24, [sp, #48]
    ldp x21, x22, [sp, #32]
    ldp x19, x20, [sp, #16]
    ldp x29, x30, [sp], #80
    ret

// (logger, d0=command timestamp). Inclusive one-hour lower bound. Do not
// discard future timestamps after a clock rollback; expose clockSkew instead.
LDprune:
    stp x29, x30, [sp, #-80]!
    mov x29, sp
    stp x19, x20, [sp, #16]
    stp x21, x22, [sp, #32]
    stp x23, x24, [sp, #48]
    stp d8, d9, [sp, #64]
    mov x19, x0
    fmov d9, d0
    mov w8, #3600
    scvtf d1, w8
    fsub d8, d0, d1
    AGET x19, LDentries_key
    mov x20, x0
    GET x20, LDcount
    mov x21, x0
LDprune_loop:
    cbz x21, LDprune_done
    sub x21, x21, #1
    mov x2, x21
    GET x20, LDobject_index
    mov x22, x0
    adr x1, LDdict_class
    bl Lpatch + (0x7394 - PATCH_BASE)
    cbz w0, LDprune_invalid
    LDGET x22, LDtimestamp_field
    mov x23, x0
    adr x1, LDnumber_class
    bl Lpatch + (0x7394 - PATCH_BASE)
    cbz w0, LDprune_invalid
    GET x23, LDdouble_value
    LDFINITE d0, LDprune_invalid
    fcmp d0, d8
    b.lt LDprune_remove
    fcmp d0, d9
    b.le LDprune_loop
    ASET x19, LDclock_key, x19, 0
    b LDprune_loop
LDprune_invalid:
    mov x0, x19
    mov x1, #0
    adr x2, LDrecord_error
    bl LDerror
LDprune_remove:
    mov x2, x21
    GET x20, LDremove_index
    b LDprune_loop
LDprune_done:
    ldp d8, d9, [sp, #64]
    ldp x23, x24, [sp, #48]
    ldp x21, x22, [sp, #32]
    ldp x19, x20, [sp, #16]
    ldp x29, x30, [sp], #80
    ret

// (JSON object, logger) -> NSData or nil. Validate before the serializer;
// NSError alone does not catch invalid-object Objective-C exceptions.
LDjson:
    stp x29, x30, [sp, #-64]!
    mov x29, sp
    stp x19, x20, [sp, #16]
    stp x21, x22, [sp, #32]
    mov x19, x0
    mov x20, x1
    adr x0, LDjson_class
    bl Lpatch + (0xa5b0 - PATCH_BASE)
    mov x21, x0
    mov x2, x19
    GET x21, LDjson_valid
    cbz w0, LDjson_invalid
    str xzr, [sp, #48]
    mov x2, x19
    mov x3, #0
    add x4, sp, #48
    GET x21, LDwrite_json
    cbnz x0, LDjson_done
    mov x0, x20
    ldr x1, [sp, #48]
    adr x2, LDserialize_error
    bl LDerror
    b LDjson_none
LDjson_invalid:
    mov x0, x20
    mov x1, #0
    adr x2, LDjson_error
    bl LDerror
LDjson_none:
    mov x0, #0
LDjson_done:
    ldp x21, x22, [sp, #32]
    ldp x19, x20, [sp, #16]
    ldp x29, x30, [sp], #64
    ret

// (NSData, NSURL, logger) -> BOOL. Only a plugin-owned directory is created.
// No in-memory record is removed or marked durable when either I/O fails.
LDwrite:
    stp x29, x30, [sp, #-80]!
    mov x29, sp
    stp x19, x20, [sp, #16]
    stp x21, x22, [sp, #32]
    stp x23, x24, [sp, #48]
    mov x19, x0
    mov x20, x1
    mov x21, x2
    cbz x19, LDwrite_none
    cbz x20, LDwrite_path_error
    GET x20, LDdelete_component
    mov x22, x0
    adr x0, LDfilemanager_class
    bl Lpatch + (0xa5b0 - PATCH_BASE)
    GET x0, LDdefault_manager
    str xzr, [sp, #64]
    mov x2, x22
    mov w3, #1
    mov x4, #0
    add x5, sp, #64
    GET x0, LDcreate_directory
    cbz w0, LDwrite_directory_error
    mov x2, x20
    mov x3, #1 // NSDataWritingAtomic
    add x4, sp, #64
    GET x19, LDwrite_data
    cbnz w0, LDwrite_done
    adr x2, LDwrite_error
    b LDwrite_error_common
LDwrite_directory_error:
    adr x2, LDdirectory_error
LDwrite_error_common:
    mov x0, x21
    ldr x1, [sp, #64]
    bl LDerror
    b LDwrite_none
LDwrite_path_error:
    mov x0, x21
    mov x1, #0
    adr x2, LDexport_path_error
    bl LDerror
LDwrite_none:
    mov w0, #0
LDwrite_done:
    ldp x23, x24, [sp, #48]
    ldp x21, x22, [sp, #32]
    ldp x19, x20, [sp, #16]
    ldp x29, x30, [sp], #80
    ret

// Serial-worker only. Atomic persistent envelope, no record-count cap.
LDpersist:
    stp x29, x30, [sp, #-64]!
    mov x29, sp
    stp x19, x20, [sp, #16]
    stp x21, x22, [sp, #32]
    mov x19, x0
    AGET x19, LDentries_key
    mov x1, x19
    bl LDjson
    cbz x0, LDpersist_none
    mov x20, x0
    adr x0, LDarray_class
    bl Lpatch + (0xa5b0 - PATCH_BASE)
    mov x2, x20
    GET x0, LDarray_object
    mov x20, x0
    adr x0, LDplist_class
    bl Lpatch + (0xa5b0 - PATCH_BASE)
    str xzr, [sp, #48]
    mov x2, x20
    mov x3, #200 // NSPropertyListBinaryFormat_v1_0
    mov x4, #0
    add x5, sp, #48
    GET x0, LDwrite_plist
    cbz x0, LDpersist_serialize_error
    mov x20, x0
    mov x0, x19
    bl LDpath
    mov x1, x0
    mov x0, x20
    mov x2, x19
    bl LDwrite
    b LDpersist_done
LDpersist_serialize_error:
    mov x0, x19
    ldr x1, [sp, #48]
    adr x2, LDserialize_error
    bl LDerror
LDpersist_none:
    mov w0, #0
LDpersist_done:
    ldp x21, x22, [sp, #32]
    ldp x19, x20, [sp, #16]
    ldp x29, x30, [sp], #64
    ret

LDdrain:
    stp x29, x30, [sp, #-112]!
    mov x29, sp
    stp x19, x20, [sp, #16]
    stp x21, x22, [sp, #32]
    stp x23, x24, [sp, #48]
    stp x25, x26, [sp, #64]
    stp x27, x28, [sp, #80]
    mov x19, x0
    bl Lpatch + (0xa5bc - PATCH_BASE)
    str x0, [sp, #96]
    mov x0, x19
    bl LDload
LDdrain_batch:
    AGET x19, LDlock_key
    mov x21, x0
    GET x21, LDlock
    AGET x19, LDpending_key
    mov x22, x0
    GET x22, LDcount
    cbz x0, LDdrain_empty
    GET x22, LDcopy
    mov x23, x0
    GET x22, LDremove_all
    GET x21, LDunlock
    GET x23, LDcount
    mov x25, x0
    mov x24, #0
    mov w28, #0
LDdrain_command:
    cmp x24, x25
    b.hs LDdrain_flush
    mov x2, x24
    GET x23, LDobject_index
    mov x1, x0
    mov x0, x19
    bl LDprocess
    mov w28, w0 // export already flushed; later append makes it dirty again
    add x24, x24, #1
    b LDdrain_command
LDdrain_flush:
    cbz w28, LDdrain_release
    mov x0, x19
    bl LDpersist
LDdrain_release:
    GET x23, LDrelease
    ldr x0, [sp, #96]
    bl Lpatch + (0xa574 - PATCH_BASE)
    bl Lpatch + (0xa5bc - PATCH_BASE)
    str x0, [sp, #96]
    b LDdrain_batch
LDdrain_empty:
    GET x21, LDunlock
    ldr x0, [sp, #96]
    bl Lpatch + (0xa574 - PATCH_BASE)
    ldp x27, x28, [sp, #80]
    ldp x25, x26, [sp, #64]
    ldp x23, x24, [sp, #48]
    ldp x21, x22, [sp, #32]
    ldp x19, x20, [sp, #16]
    ldp x29, x30, [sp], #112
    ret

// (logger, command) -> 1 if a final batch flush is required, 0 after export.
// All cutoffs are command timestamps, NEVER delayed worker wall-clock time.
LDprocess:
    stp x29, x30, [sp, #-48]!
    mov x29, sp
    stp x19, x20, [sp, #16]
    stp x21, x22, [sp, #32]
    mov x19, x0
    mov x20, x1
    LDGET x20, LDtimestamp_field
    GET x0, LDdouble_value
    mov x0, x19
    bl LDprune
    LDGET x20, LDexport_target
    cbnz x0, LDprocess_export
    LDGET x20, LDmaintenance_field
    cbnz x0, LDprocess_dirty
    AGET x19, LDentries_key
    mov x2, x20
    GET x0, LDadd_object
LDprocess_dirty:
    mov w0, #1
    b LDprocess_done
LDprocess_export:
    mov x0, x19
    bl LDpersist
    mov x0, x19
    mov x1, x20
    bl LDexport
    mov w0, #0
LDprocess_done:
    ldp x21, x22, [sp, #32]
    ldp x19, x20, [sp, #16]
    ldp x29, x30, [sp], #48
    ret

// Fixed [requestTime-3600, requestTime] snapshot, delivered on main thread.
// The exportTarget and the marker itself are never included in stored entries.
LDexport:
    stp x29, x30, [sp, #-128]!
    mov x29, sp
    stp x19, x20, [sp, #16]
    stp x21, x22, [sp, #32]
    stp x23, x24, [sp, #48]
    stp x25, x26, [sp, #64]
    stp x27, x28, [sp, #80]
    stp d8, d9, [sp, #96]
    mov x19, x0
    mov x20, x1
    LDGET x20, LDtimestamp_field
    GET x0, LDdouble_value
    fmov d8, d0
    mov w8, #3600
    scvtf d1, w8
    fsub d9, d0, d1
    LDNEW LDmutable_array
    mov x22, x0
    AGET x19, LDentries_key
    mov x21, x0
    GET x21, LDcount
    mov x23, x0
    mov x24, #0
LDexport_filter:
    cmp x24, x23
    b.hs LDexport_payload
    mov x2, x24
    GET x21, LDobject_index
    mov x25, x0
    LDGET x25, LDtimestamp_field
    GET x0, LDdouble_value
    fcmp d0, d9
    b.lt LDexport_next
    fcmp d0, d8
    b.gt LDexport_next
    mov x2, x25
    GET x22, LDadd_object
LDexport_next:
    add x24, x24, #1
    b LDexport_filter
LDexport_payload:
    LDNEW LDmutable_dict
    mov x26, x0
    LDSET x26, LDentries_field, x22
    GET x22, LDcount
    ucvtf d0, x0
    bl Lnumber
    mov x23, x0
    LDSET x26, LDcount_field, x23
    fmov d0, d9
    bl Lnumber
    LDSET x26, LDwindow_start, x0
    fmov d0, d8
    bl Lnumber
    LDSET x26, LDwindow_end, x0
    adr x0, LDversion
    bl Lstr
    LDSET x26, LDversion_field, x0
    AGET x19, LDstart_key
    LDSET x26, LDsession_start, x0
    LDGET x20, LDsequence_field
    LDSET x26, LDrequest_sequence, x0
    AGET x19, LDclock_key
    cmp x0, #0
    cset w8, ne
    ucvtf d0, w8
    bl Lnumber
    LDSET x26, LDclock_field, x0
    AGET x19, LDerror_key
    cbnz x0, LDexport_status
    adr x0, LDno_error
    bl Lstr
LDexport_status:
    LDSET x26, LDstorage_error, x0
    LDNEW LDmutable_dict
    mov x27, x0
    mov x0, x26
    mov x1, x19
    bl LDjson
    cbz x0, LDexport_failure
    mov x25, x0
    adr x0, LDfilemanager_class
    bl Lpatch + (0xa5b0 - PATCH_BASE)
    GET x0, LDdefault_manager
    GET x0, LDtemporary_dir
    mov x21, x0
    adr x0, LDexport_dir_name
    bl Lstr
    mov x2, x0
    GET x21, LDappend_component
    mov x21, x0
    adr x0, LDuuid_class
    bl Lpatch + (0xa5b0 - PATCH_BASE)
    GET x0, LDuuid
    GET x0, LDuuid_string
    mov x22, x0
    adr x0, LDjson_extension
    bl Lstr
    mov x2, x0
    GET x22, LDappend_string
    mov x2, x0
    GET x21, LDappend_component
    mov x28, x0
    mov x0, x25
    mov x1, x28
    mov x2, x19
    bl LDwrite
    cbz w0, LDexport_failure
    LDSET x27, LDurl_field, x28
    LDSET x27, LDcount_field, x23
    b LDexport_result
LDexport_failure:
    AGET x19, LDerror_key
    cbnz x0, LDexport_failure_text
    adr x0, LDwrite_error
    bl Lstr
LDexport_failure_text:
    LDSET x27, LDerror_field, x0
LDexport_result:
    AGET x19, LDerror_key
    cbnz x0, LDexport_result_status
    adr x0, LDno_error
    bl Lstr
LDexport_result_status:
    LDSET x27, LDstorage_error, x0
    LDGET x20, LDexport_target
    mov x21, x0
    adr x0, LDpresent_sel
    bl Lpatch + (0xa5a4 - PATCH_BASE)
    mov x22, x0
    mov x2, x22
    GET x21, LDresponds
    cbz w0, LDexport_done
    mov x2, x22
    mov x3, x27
    mov w4, #0
    GET x21, LDperform_main
LDexport_done:
    ldp d8, d9, [sp, #96]
    ldp x27, x28, [sp, #80]
    ldp x25, x26, [sp, #64]
    ldp x23, x24, [sp, #48]
    ldp x21, x22, [sp, #32]
    ldp x19, x20, [sp, #16]
    ldp x29, x30, [sp], #128
    ret



// Only this prefix is copied into RX padding. The intervening .org bytes
// are never written to the original image. Constants occupy unused mapped
// __DATA_CONST padding after every original section and chained fixup.
Lcode_end:
    .org DATA_BASE - PATCH_BASE
Lstrings:
Lbar_class:          .asciz "SSTabBar"
Lscroll_class:       .asciz "UIScrollView"
Lnumber_class:       .asciz "NSNumber"
Llayout_alias:       .asciz "fqab_158_originalTabLayout"
Lwindow_alias:       .asciz "fqab_158_originalWindowMove"
Lbackground_alias:   .asciz "fqab_158_originalBackground"
Lratio_alias:        .asciz "fqab_barRatio"
Lvoid_encoding:      .asciz "v16@0:8"
Lobject_encoding:    .asciz "v24@0:8@16"
Llayout_sel:         .asciz "layoutSubviews"
Lwindow_sel:         .asciz "didMoveToWindow"
Lset_background:     .asciz "setBackgroundColor:"
Lsuperview:          .asciz "superview"
Lcontent_view:       .asciz "contentView"
Lis_hidden:          .asciz "isHidden"
Lset_hidden:         .asciz "setHidden:"
Lsubviews:           .asciz "subviews"
Llast_object:        .asciz "lastObject"
Lbring_front:        .asciz "bringSubviewToFront:"
Lbounds:             .asciz "bounds"
Llayer:              .asciz "layer"
Lset_radius:         .asciz "setCornerRadius:"
Lset_masks:          .asciz "setMasksToBounds:"
Lwindow:             .asciz "window"
Lselected_item:      .asciz "selectedItem"
Lnumber_bool:        .asciz "numberWithBool:"
Lbool_value:         .asciz "boolValue"
Lretain:             .asciz "retain"
Lrelease:            .asciz "release"
Lalpha:              .asciz "alpha"
Lbottom_edge:        .asciz "bottomEdgeEffect"
Lresponds:           .asciz "respondsToSelector:"
Lcontent_size:       .asciz "contentSize"
Lconvert_rect:       .asciz "convertRect:toView:"
Lcount:              .asciz "count"
Lobject_at:          .asciz "objectAtIndex:"
Lcontains:           .asciz "containsObject:"
Lbusy_key:           .byte 0
Lscroll_key:         .byte 0
Ledge_key:           .byte 0
Lhidden_key:         .byte 0
Lparent_key:         .byte 0
Lselected_key:       .byte 0

.p2align 3
LMalpha_floor: .double 0.999
LMmounted_key: .byte 0
LMwindow_key: .byte 0
LMwindow: .asciz "window"
LMalpha: .asciz "alpha"
LMeffect: .asciz "effect"
LMset_effect: .asciz "setEffect:"
LMset_tint: .asciz "setTintColor:"
LMset_opaque: .asciz "setOpaque:"
LMvisual_effect_class: .asciz "UIVisualEffect"
LMnew: .asciz "new"
.p2align 2


LSbar_wrapper_class: .asciz "UIKit._UITabBarContainerWrapperView"
LSnative_bar_class: .asciz "UITabBar"
LSnative_children: .asciz "nativeChildren"
LScontent_rect: .asciz "contentRect"
LSwindow_rect: .asciz "windowRect"
LSoriginal_edge_hidden: .asciz "originalBottomEdgeHidden"
LScurrent_edge_hidden: .asciz "bottomEdgeHidden"

LSdictionary_class: .asciz "NSMutableDictionary"
LSdictionary: .asciz "dictionary"
LSarray_class: .asciz "NSMutableArray"
LSarray: .asciz "array"
LSstring_class: .asciz "NSString"
LSstring_utf8: .asciz "stringWithUTF8String:"
LSnumber_uint: .asciz "numberWithUnsignedLongLong:"
LSnumber_double: .asciz "numberWithDouble:"
LSnonfinite: .asciz "non-finite"
LSnull_class: .asciz "NSNull"
LSnull: .asciz "null"
LSset_object: .asciz "setObject:forKey:"
LSdate_class: .asciz "NSDate"
LSdate: .asciz "date"
LStime: .asciz "timeIntervalSince1970"
LSadd_object: .asciz "addObject:"
LSclass: .asciz "class"
LSdescription: .asciz "description"
LSframe: .asciz "frame"
LSopaque: .asciz "isOpaque"
LSbackground: .asciz "backgroundColor"
LScolor_class: .asciz "UIColor"
LScolor_cg: .asciz "colorWithCGColor:"
LSopacity: .asciz "opacity"
LSshadow_opacity: .asciz "shadowOpacity"
LSshadow_radius: .asciz "shadowRadius"
LSshould_rasterize: .asciz "shouldRasterize"
LSraster_scale: .asciz "rasterizationScale"
LSbutton_class: .asciz "UIButton"
LSlabel_class: .asciz "UILabel"
LStitle_label: .asciz "titleLabel"
LSmask: .asciz "mask"
LSmasks: .asciz "masksToBounds"
LSeffect_view_class: .asciz "UIVisualEffectView"
LSeffect: .asciz "effect"
LSglass_class: .asciz "UIGlassEffect"
LStint: .asciz "tintColor"
LSinteractive: .asciz "isInteractive"
LSversion: .asciz "1.5.8"
LSk_id: .asciz "viewId"
LSk_class: .asciz "class"
LSk_frame: .asciz "frame"
LSk_bounds: .asciz "bounds"
LSk_alpha: .asciz "alpha"
LSk_hidden: .asciz "hidden"
LSk_opaque: .asciz "opaqueHint"
LSk_background: .asciz "backgroundColor"
LSk_layer_color: .asciz "layerBackgroundColor"
LSk_layer_opacity: .asciz "layerOpacity"
LSk_shadow_opacity: .asciz "layerShadowOpacity"
LSk_shadow_radius: .asciz "layerShadowRadius"
LSk_rasterize: .asciz "layerShouldRasterize"
LSk_raster_scale: .asciz "layerRasterizationScale"
LSk_title_label: .asciz "buttonTitleLabel"
LSk_mask: .asciz "hasLayerMask"
LSk_clips: .asciz "masksToBounds"
LSk_effect: .asciz "effectClass"
LSk_tint: .asciz "effectTint"
LSk_interactive: .asciz "effectInteractive"
LSk_count: .asciz "totalCount"
LSk_truncated: .asciz "truncated"
LSk_views: .asciz "views"
LSk_event: .asciz "event"
LSk_data: .asciz "data"
LSk_timestamp: .asciz "timestamp"
LSk_version: .asciz "pluginVersion"
LShash_class: .asciz "NSHashTable"
LSweak_hash: .asciz "weakObjectsHashTable"
LSall_objects: .asciz "allObjects"
LSthread_class: .asciz "NSThread"
LSmain_thread: .asciz "isMainThread"
LSdata_class: .asciz "NSData"
LSdata_bytes: .asciz "dataWithBytes:length:"
LSequal_data: .asciz "isEqualToData:"
LSstate_changed: .asciz "bottom_bar_state_changed"
LSperiodic: .asciz "periodic_snapshot"
LSstartup: .asciz "plugin_start"
LSitems: .asciz "items"
LSindex_identical: .asciz "indexOfObjectIdenticalTo:"
LStraits: .asciz "traitCollection"
LScontrast: .asciz "accessibilityContrast"
LSclear_style: .asciz "Clear (1)"
LSunknown_transparency: .asciz "unknown: public C API is not linked by the original plugin"
LSprocess_class: .asciz "NSProcessInfo"
LSprocess: .asciz "processInfo"
LSos_version: .asciz "operatingSystemVersionString"
LSk_bar: .asciz "bar"
LSk_proxy: .asciz "glassProxy"
LSk_bar_content: .asciz "originalBarContent"
LSk_proxy_content: .asciz "glassContent"
LSk_bar_children: .asciz "barChildren"
LSk_proxy_children: .asciz "glassChildren"
LSk_content_children: .asciz "glassContentChildren"
LSk_siblings: .asciz "parentChildren"
LSk_managed_scroll: .asciz "managedScrolls"
LSk_edge_original: .asciz "scrollSearchVisited"
LSk_edge_current: .asciz "scrollSearchTruncationFlags"
LSk_ancestors: .asciz "ancestors"
LSk_ancestor_truncated: .asciz "ancestorChainTruncated"
LSk_selected: .asciz "selectedIndex"
LSk_style: .asciz "requestedGlassStyle"
LSk_contrast: .asciz "accessibilityContrast"
LSk_transparency: .asciz "reduceTransparency"
LSk_os: .asciz "osVersion"
LSk_options: .asciz "pluginOptions"
LSsignature_key: .byte 0
LSbars_key: .byte 0
LUbusy_key: .byte 0
LUsender_key: .byte 0
LUexport_sel: .asciz "fqab_156_exportDiagnostics:"
LUpresent_sel: .asciz "fqab_156_presentDiagnostics:"
LUexport_title: .asciz "导出日志"
LUfailure_title: .asciz "日志导出失败"
LUunavailable: .asciz "诊断日志暂时不可用，请稍后重试。"
LUokay: .asciz "好"
LUitem_class: .asciz "UIBarButtonItem"
LUalloc: .asciz "alloc"
LUinit_item: .asciz "initWithTitle:style:target:action:"
LUnavigation_item: .asciz "navigationItem"
LUset_left_item: .asciz "setLeftBarButtonItem:"
LUpresented: .asciz "presentedViewController"
LUview: .asciz "view"
LUset_enabled: .asciz "setEnabled:"
LUexport_snapshot: .asciz "export_snapshot"
LUexport_target: .asciz "exportTarget"
LUerror: .asciz "error"
LUurl: .asciz "url"
LUobject_key: .asciz "objectForKey:"
LUarray_class: .asciz "NSArray"
LUarray_object: .asciz "arrayWithObject:"
LUactivity_class: .asciz "UIActivityViewController"
LUinit_activity: .asciz "initWithActivityItems:applicationActivities:"
LUpopover: .asciz "popoverPresentationController"
LUset_anchor: .asciz "setBarButtonItem:"
LUpresent: .asciz "presentViewController:animated:completion:"
LUalert_class: .asciz "UIAlertController"
LUalert_factory: .asciz "alertControllerWithTitle:message:preferredStyle:"
LUaction_class: .asciz "UIAlertAction"
LUaction_factory: .asciz "actionWithTitle:style:handler:"
LUadd_action: .asciz "addAction:"


LDclass_name: .asciz "FQABDiagnosticsV155"
LDobject_class: .asciz "NSObject"
LDlock_class: .asciz "NSLock"
LDqueue_class: .asciz "NSOperationQueue"
LDoperation_class: .asciz "NSInvocationOperation"
LDtimer_class: .asciz "NSTimer"
LDmutable_array: .asciz "NSMutableArray"
LDmutable_dict: .asciz "NSMutableDictionary"
LDdict_class: .asciz "NSDictionary"
LDarray_class: .asciz "NSArray"
LDnumber_class: .asciz "NSNumber"
LDdate_class: .asciz "NSDate"
LDfilemanager_class: .asciz "NSFileManager"
LDdata_class: .asciz "NSData"
LDplist_class: .asciz "NSPropertyListSerialization"
LDjson_class: .asciz "NSJSONSerialization"
LDuuid_class: .asciz "NSUUID"
LDvoid_encoding: .asciz "v16@0:8"
LDobject_encoding: .asciz "v24@0:8@16"
LDreturn_encoding: .asciz "@16@0:8"
LDinitialize_sel: .asciz "initialize"
LDshared_sel: .asciz "fqab_156_sharedLogger"
LDdrain_sel: .asciz "fqab_156_drain:"
LDtick_sel: .asciz "fqab_156_tick:"
LDtimer_sel: .asciz "fqab_156_startTimer:"
LDpresent_sel: .asciz "fqab_156_presentDiagnostics:"
LDalloc: .asciz "alloc"
LDinit: .asciz "init"
LDrelease: .asciz "release"
LDautorelease: .asciz "autorelease"
LDcopy: .asciz "copy"
LDmutable_copy: .asciz "mutableCopy"
LDresponds: .asciz "respondsToSelector:"
LDlock: .asciz "lock"
LDunlock: .asciz "unlock"
LDmax_concurrent: .asciz "setMaxConcurrentOperationCount:"
LDscheduled_timer: .asciz "scheduledTimerWithTimeInterval:target:selector:userInfo:repeats:"
LDperform_main: .asciz "performSelectorOnMainThread:withObject:waitUntilDone:"
LDoperation_init: .asciz "initWithTarget:selector:object:"
LDadd_operation: .asciz "addOperation:"
LDunsigned_value: .asciz "unsignedLongLongValue"
LDunsigned_number: .asciz "numberWithUnsignedLongLong:"
LDdouble_value: .asciz "doubleValue"
LDadd_object: .asciz "addObject:"
LDadd_array: .asciz "addObjectsFromArray:"
LDremove_all: .asciz "removeAllObjects"
LDremove_index: .asciz "removeObjectAtIndex:"
LDobject_key: .asciz "objectForKey:"
LDobject_index: .asciz "objectAtIndex:"
LDarray_object: .asciz "arrayWithObject:"
LDfirst_object: .asciz "firstObject"
LDcount: .asciz "count"
LDdate: .asciz "date"
LDunix_time: .asciz "timeIntervalSince1970"
LDdefault_manager: .asciz "defaultManager"
LDcache_urls: .asciz "URLsForDirectory:inDomains:"
LDappend_component: .asciz "URLByAppendingPathComponent:"
LDdelete_component: .asciz "URLByDeletingLastPathComponent"
LDpath_sel: .asciz "path"
LDexists: .asciz "fileExistsAtPath:"
LDread_data: .asciz "dataWithContentsOfURL:options:error:"
LDread_plist: .asciz "propertyListWithData:options:format:error:"
LDwrite_plist: .asciz "dataWithPropertyList:format:options:error:"
LDread_json: .asciz "JSONObjectWithData:options:error:"
LDwrite_json: .asciz "dataWithJSONObject:options:error:"
LDjson_valid: .asciz "isValidJSONObject:"
LDwrite_data: .asciz "writeToURL:options:error:"
LDcreate_directory: .asciz "createDirectoryAtURL:withIntermediateDirectories:attributes:error:"
LDlocalized_error: .asciz "localizedDescription"
LDtemporary_dir: .asciz "temporaryDirectory"
LDuuid: .asciz "UUID"
LDuuid_string: .asciz "UUIDString"
LDappend_string: .asciz "stringByAppendingString:"
LDtimestamp_field: .asciz "timestamp"
LDsequence_field: .asciz "sequence"
LDmaintenance_field: .asciz "maintenance"
LDexport_target: .asciz "exportTarget"
LDentries_field: .asciz "entries"
LDcount_field: .asciz "recordCount"
LDwindow_start: .asciz "windowStart"
LDwindow_end: .asciz "windowEnd"
LDversion_field: .asciz "pluginVersion"
LDstorage_error: .asciz "storageError"
LDsession_start: .asciz "sessionStart"
LDrequest_sequence: .asciz "requestSequence"
LDclock_field: .asciz "clockSkew"
LDurl_field: .asciz "url"
LDerror_field: .asciz "error"
LDtrue_string: .asciz "1"
LDversion: .asciz "1.5.7"
LDno_error: .asciz "none"
LDcache_name: .asciz "FanqieAdBlockDiagnostics"
LDstore_name: .asciz "recent.plist"
LDexport_dir_name: .asciz "FanqieAdBlockDiagnosticsExports"
LDjson_extension: .asciz ".json"
LDcache_error: .asciz "Cannot locate persistent diagnostics application support directory."
LDread_error: .asciz "Cannot read saved diagnostics."
LDformat_error: .asciz "Invalid diagnostic store; saved history was not loaded."
LDrecord_error: .asciz "Removed an invalid undated saved diagnostic record."
LDjson_error: .asciz "Invalid JSON diagnostic data; records remain in memory."
LDserialize_error: .asciz "Could not serialize diagnostics; records remain in memory."
LDdirectory_error: .asciz "Could not create diagnostics directory."
LDwrite_error: .asciz "Could not write diagnostics; records remain in memory."
LDexport_path_error: .asciz "Could not construct diagnostics file path."
LDsingleton_key: .byte 0
LDlock_key: .byte 0
LDpending_key: .byte 0
LDqueue_key: .byte 0
LDentries_key: .byte 0
LDurl_key: .byte 0
LDerror_key: .byte 0
LDstart_key: .byte 0
LDsequence_key: .byte 0
LDtimer_key: .byte 0
LDclock_key: .byte 0
    .p2align 2

    .p2align 2
Lend:

// Additional independently mapped RX segment. Original TEXT/DATA addresses
// and chained pointer slots stay unchanged; only LINKEDIT moves behind this.
    .org EXT_BASE - PATCH_BASE
Lextension:
    .ascii "FQ158EXT"
    .long 0x10508
    .long 32
    .long LXupdate - Lpatch
    .long LXrestore - Lpatch
    .long LXnative_update - Lpatch
    .long LXnative_restore - Lpatch
    .long LXsame_bottom_rect - Lpatch
    .long LXsafe_tree - Lpatch
    .long LXmonitor_start - Lpatch
    .long LXpoll - Lpatch
    .long LXsnapshot - Lpatch
    .long LIupdate - Lpatch
    .long LIrestore - Lpatch
    .long LIpan - Lpatch
    .long LIshould_begin - Lpatch
    .long LGstyle_control - Lpatch
    .long LGstyle_glyph - Lpatch
    .long LXcode_end - Lpatch
    .long LXstrings - Lpatch
    .long LXend - Lpatch
    .long LXnative_key - Lpatch
    .long LXmonitor_key - Lpatch
    .long LXowner_key - Lpatch
    .long LXtimer_key - Lpatch
    .long LXtick_key - Lpatch
    .long LXrejected_key - Lpatch
    .long 0,0,0,0
    .p2align 2
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


// Explicit horizontal selection interaction for the owned floating bottom bar.
// The base proxy and the clear lens are sibling visual-effect surfaces, not
// nested glass. Original UIButton objects stay intact and retain their target,
// accessibility and selection state; only their decoration/parent is changed.
// Native UIKit rendering is used. Matching another application's optical
// appearance is deliberately not an offline test claim.
//
// Public: LIupdate(bar, proxy), LIrestore(bar, proxy), LIpan(self, _cmd, pan),
// LIshould_begin(self, _cmd, pan). All callers and UIKit callbacks are main-thread.
// The parent supplies GET/AGET/ASET, FINITE, Lmessage, Lfactory, Lnumber,
// LDadd_method, Lvisible_to, Lsync_original and the exact-image entry points.

.set LIactive_key, Lpatch + (0xeb84 - PATCH_BASE)
.set LIbuttons_key, Lpatch + (0xeb85 - PATCH_BASE)
.set LIbound_key, Lpatch + (0xeb87 - PATCH_BASE)

// Validate a CGRect without consuming its FP arguments. BOOL result in w0.
LIrect_valid:
    FINITE d0, LIrect_invalid
    FINITE d1, LIrect_invalid
    FINITE d2, LIrect_invalid
    FINITE d3, LIrect_invalid
    fcmp d2, #0.0
    b.le LIrect_invalid
    fcmp d3, #0.0
    b.le LIrect_invalid
    mov w0, #1
    ret
LIrect_invalid:
    mov w0, #0
    ret

// (bar, proxy) -> BOOL. Never follow a cached, nonretaining bar pointer.
LIvalid:
    stp x29, x30, [sp, #-48]!
    mov x29, sp
    stp x19, x20, [sp, #16]
    stp x21, x22, [sp, #32]
    mov x19, x0
    mov x20, x1
    cbz x19, LIvalid_no
    cbz x20, LIvalid_no
    AGET x19, LIactive_key
    cmp x0, x20
    b.ne LIvalid_no
    AGET x20, LIbound_key
    cmp x0, x19
    b.ne LIvalid_no
    GET x20, Lsuperview
    cmp x0, x19
    b.ne LIvalid_no
    GET x19, Lwindow
    mov x21, x0
    cbz x21, LIvalid_no
    GET x20, Lwindow
    cmp x0, x21
    b.ne LIvalid_no
    mov x0, x19
    mov x1, x21
    bl Lvisible_to
    cbz w0, LIvalid_no
    mov x0, x20
    mov x1, x19
    bl Lvisible_to
    b LIvalid_done
LIvalid_no:
    mov w0, #0
LIvalid_done:
    ldp x21, x22, [sp, #32]
    ldp x19, x20, [sp, #16]
    ldp x29, x30, [sp], #48
    ret

// (bar, buttons) -> the UIButton corresponding to the true selectedItem.
// Mapping is by array identity, exactly like the original click route.
LIselected:
    stp x29, x30, [sp, #-48]!
    mov x29, sp
    stp x19, x20, [sp, #16]
    stp x21, x22, [sp, #32]
    mov x19, x0
    mov x20, x1
    cbz x19, LIselected_no
    cbz x20, LIselected_no
    GET x20, Lcount
    mov x21, x0
    sub x8, x21, #1
    cmp x8, #7
    b.hi LIselected_no
    GET x19, Lselected_item
    mov x22, x0
    cbz x22, LIselected_no
    GET x19, LIitems
    cbz x0, LIselected_no
    mov x2, x22
    GET x0, LIindex_identical
    cmp x0, x21
    b.hs LIselected_no
    mov x2, x0
    GET x20, Lobject_at
    b LIselected_done
LIselected_no:
    mov x0, #0
LIselected_done:
    ldp x21, x22, [sp, #32]
    ldp x19, x20, [sp, #16]
    ldp x29, x30, [sp], #48
    ret

// (proxy, current buttons) -> BOOL, exact identity/order comparison with the
// immutable ownership snapshot. Array replacement/reorder cancels a gesture.
LIbuttons_match:
    stp x29, x30, [sp, #-64]!
    mov x29, sp
    stp x19, x20, [sp, #16]
    stp x21, x22, [sp, #32]
    stp x23, x24, [sp, #48]
    mov x19, x0
    mov x20, x1
    cbz x20, LIbuttons_no
    AGET x19, LIowned_buttons_key
    mov x19, x0
    cbz x19, LIbuttons_no
    GET x19, Lcount
    mov x21, x0
    sub x8, x21, #1
    cmp x8, #7
    b.hi LIbuttons_no
    GET x20, Lcount
    cmp x0, x21
    b.ne LIbuttons_no
    mov x22, #0
LIbuttons_loop:
    cmp x22, x21
    b.hs LIbuttons_yes
    mov x2, x22
    GET x19, Lobject_at
    mov x23, x0
    mov x2, x22
    GET x20, Lobject_at
    cmp x0, x23
    b.ne LIbuttons_no
    add x22, x22, #1
    b LIbuttons_loop
LIbuttons_yes:
    mov w0, #1
    b LIbuttons_done
LIbuttons_no:
    mov w0, #0
LIbuttons_done:
    ldp x23, x24, [sp, #48]
    ldp x21, x22, [sp, #32]
    ldp x19, x20, [sp, #16]
    ldp x29, x30, [sp], #64
    ret

// Runtime class is private to this version; its delegate owns no bar/view.
LIcontroller_class:
    stp x29, x30, [sp, #-32]!
    mov x29, sp
    stp x19, x20, [sp, #16]
    adr x0, LIcontroller_name
    bl Lpatch + (0xa5b0 - PATCH_BASE)
    mov x19, x0
    cbnz x19, LIclass_check
    adr x0, LIobject_name
    bl Lpatch + (0xa5b0 - PATCH_BASE)
    cbz x0, LIclass_no
    adr x1, LIcontroller_name
    mov x2, #0
    bl Lpatch + (0xa61c - PATCH_BASE)
    mov x19, x0
    cbz x19, LIclass_retry
    mov x0, x19
    adr x1, LIpan_sel
    adr x2, LIpan
    adr x3, LIobject_encoding
    bl LDadd_method
    mov x0, x19
    adr x1, LIshould_sel
    adr x2, LIshould_begin
    adr x3, LIbool_encoding
    bl LDadd_method
    mov x0, x19
    bl Lpatch + (0xa610 - PATCH_BASE)
    b LIclass_check
LIclass_retry:
    adr x0, LIcontroller_name
    bl Lpatch + (0xa5b0 - PATCH_BASE)
    mov x19, x0
LIclass_check:
    cbz x19, LIclass_no
    adr x0, LIpan_sel
    bl Lpatch + (0xa5a4 - PATCH_BASE)
    mov x1, x0
    mov x0, x19
    bl Lpatch + (0xa5f8 - PATCH_BASE)
    cbz x0, LIclass_no
    adr x0, LIshould_sel
    bl Lpatch + (0xa5a4 - PATCH_BASE)
    mov x1, x0
    mov x0, x19
    bl Lpatch + (0xa5f8 - PATCH_BASE)
    cbz x0, LIclass_no
    mov x0, x19
    b LIclass_done
LIclass_no:
    mov x0, #0
LIclass_done:
    ldp x19, x20, [sp, #16]
    ldp x29, x30, [sp], #32
    ret

// (bar, proxy, selectedButton) -> retained-by-proxy overlay or nil.
// No original button is moved until every required allocation succeeds.
LIbuild:
    stp x29, x30, [sp, #-128]!
    mov x29, sp
    stp x19, x20, [sp, #16]
    stp x21, x22, [sp, #32]
    stp x23, x24, [sp, #48]
    stp x25, x26, [sp, #64]
    stp x27, x28, [sp, #80]
    mov x19, x0
    mov x20, x1
    mov x21, x2
    mov x22, #0
    mov x23, #0
    mov x24, #0
    mov x25, #0
    mov x28, #0
    GET x21, LIframe
    bl LIrect_valid
    cbz w0, LIbuild_done
    stp d0, d1, [sp, #96]
    stp d2, d3, [sp, #112]
    AGET x20, LIbuttons_key
    GET x0, LIcopy
    mov x28, x0
    cbz x28, LIbuild_done
    bl LIcontroller_class
    cbz x0, LIbuild_done
    GET x0, LInew
    mov x24, x0
    cbz x24, LIbuild_done
    adr x0, LIview_name
    adr x1, LInew
    bl Lfactory
    mov x22, x0
    cbz x22, LIbuild_done
    bl Lpatch + (0x73e0 - PATCH_BASE)
    mov w2, #0
    GET x22, LIset_opaque
    mov w2, #0
    GET x22, LIset_access_hidden
    mov w2, #1
    GET x22, LIset_interaction
    GET x20, LIframe
    mov x0, x22
    bl Lpatch + (0x711c - PATCH_BASE)

    adr x0, LIeffect_view_name
    adr x1, LIalloc
    bl Lfactory
    mov x2, #0
    GET x0, LIinit_effect
    mov x23, x0
    cbz x23, LIbuild_done
    bl Lpatch + (0x73e0 - PATCH_BASE)
    mov w2, #0
    GET x23, LIset_opaque
    mov w2, #0
    GET x23, LIset_interaction
    mov w2, #1
    GET x23, LIset_access_hidden
    GET x23, Lcontent_view
    bl Lpatch + (0x73e0 - PATCH_BASE)
    ldp d0, d1, [sp, #96]
    ldp d2, d3, [sp, #112]
    mov x0, x23
    bl Lpatch + (0x711c - PATCH_BASE)

    adr x0, LIglass_name
    bl Lpatch + (0xa5b0 - PATCH_BASE)
    mov x27, x0
    cbz x27, LIbuild_done
    adr x0, LIeffect_factory
    bl Lpatch + (0xa5a4 - PATCH_BASE)
    mov x2, x0
    GET x27, Lresponds
    cbz w0, LIbuild_done
    mov w2, #1
    GET x27, LIeffect_factory
    mov x26, x0
    cbz x26, LIbuild_done
    mov w2, #1
    GET x26, LIset_interactive
    mov x2, #0
    GET x26, LIset_tint

    adr x0, LIpan_name
    adr x1, LIalloc
    bl Lfactory
    mov x27, x0
    cbz x27, LIbuild_done
    adr x0, LIpan_sel
    bl Lpatch + (0xa5a4 - PATCH_BASE)
    mov x3, x0
    mov x2, x24
    GET x27, LIinit_target
    mov x25, x0
    cbz x25, LIbuild_done
    mov x2, x24
    GET x25, LIset_delegate
    mov w2, #1
    GET x25, LIset_min_touches
    mov w2, #1
    GET x25, LIset_max_touches
    mov w2, #1
    GET x25, LIset_cancel_touches
    mov w2, #0
    GET x25, LIset_delay_began
    mov w2, #0
    GET x25, LIset_delay_ended

    mov x2, x23
    GET x22, LIadd_subview
    mov x2, x25
    GET x22, LIadd_gesture
    ASET x20, LIoverlay_key, x22, 1
    ASET x20, LIlens_key, x23, 1
    ASET x20, LIcontroller_key, x24, 1
    ASET x20, LIpan_key, x25, 1
    ASET x20, LIowned_buttons_key, x28, 1
    mov x2, x22
    GET x19, LIadd_subview

    // Keep the native glass effect for drag only; resting selection is a
    // thin adaptive gray fill, rather than a second glass lens on glass.
    ASET x23, LIlens_effect_key, x26, 1
    adr x0, LIcorner_name
    adr x1, LIcapsule
    bl Lfactory
    cbz x0, LIbuild_commit
    mov x2, x0
    GET x23, LIset_corner
LIbuild_commit:
    mov x0, x23
    mov w1, #0
    bl LIappearance
    mov x27, x22
    b LIbuild_cleanup
LIbuild_done:
    mov x27, #0
LIbuild_cleanup:
    GET x28, Lrelease
    GET x25, Lrelease
    GET x24, Lrelease
    GET x23, Lrelease
    GET x22, Lrelease
    mov x0, x27
    ldp x27, x28, [sp, #80]
    ldp x25, x26, [sp, #64]
    ldp x23, x24, [sp, #48]
    ldp x21, x22, [sp, #32]
    ldp x19, x20, [sp, #16]
    ldp x29, x30, [sp], #128
    ret

// Clear state before disabling recognizers: their cancellation can call back.
LIclear_state:
    stp x29, x30, [sp, #-32]!
    mov x29, sp
    stp x19, x20, [sp, #16]
    mov x19, x0
    cbz x19, LIclear_done
    ASET x19, LIdrag_key, xzr, 0
    ASET x19, LIstart_item_key, xzr, 0
    ASET x19, LIoffset_key, xzr, 0
LIclear_done:
    ldp x19, x20, [sp, #16]
    ldp x29, x30, [sp], #32
    ret

// (proxy). Used only for active layout/selection cancellation, not teardown.
LIcancel:
    stp x29, x30, [sp, #-32]!
    mov x29, sp
    stp x19, x20, [sp, #16]
    mov x19, x0
    AGET x19, LIcontroller_key
    mov x20, x0
    AGET x20, LIdrag_key
    cbz x0, LIcancel_done
    mov x0, x20
    bl LIclear_state
    AGET x19, LIpan_key
    mov x20, x0
    mov w2, #0
    GET x20, LIset_enabled
    mov w2, #1
    GET x20, LIset_enabled
LIcancel_done:
    ldp x19, x20, [sp, #16]
    ldp x29, x30, [sp], #32
    ret

LIupdate:
    stp x29, x30, [sp, #-128]!
    mov x29, sp
    stp x19, x20, [sp, #16]
    stp x21, x22, [sp, #32]
    stp x23, x24, [sp, #48]
    stp x25, x26, [sp, #64]
    stp x27, x28, [sp, #80]
    mov x19, x0
    mov x20, x1
    bl LIvalid
    cbz w0, LIupdate_restore
    AGET x20, LIbuttons_key
    mov x21, x0
    GET x21, Lcount
    mov x22, x0
    sub x8, x22, #1
    cmp x8, #7
    b.hi LIupdate_restore
    mov x0, x19
    mov x1, x21
    bl LIselected
    mov x23, x0
    cbz x23, LIupdate_restore
    GET x20, LIframe
    bl LIrect_valid
    cbz w0, LIupdate_restore
    stp d0, d1, [sp, #96]
    stp d2, d3, [sp, #112]
    AGET x20, LIoverlay_key
    mov x24, x0
    cbz x24, LIupdate_build
    mov x0, x20
    mov x1, x21
    bl LIbuttons_match
    cbnz w0, LIupdate_overlay
    mov x0, x19
    mov x1, x20
    bl LIrestore
LIupdate_build:
    mov x0, x19
    mov x1, x20
    mov x2, x23
    bl LIbuild
    mov x24, x0
    cbz x24, LIupdate_no
LIupdate_overlay:
    // Identical layout keeps the active lens and its native effect untouched.
    GET x24, LIframe
    ldp d4, d5, [sp, #96]
    ldp d6, d7, [sp, #112]
    fcmp d0, d4
    fccmp d1, d5, #0, eq
    fccmp d2, d6, #0, eq
    fccmp d3, d7, #0, eq
    b.eq LIupdate_bounds
    mov x0, x20
    bl LIcancel
    ldp d0, d1, [sp, #96]
    ldp d2, d3, [sp, #112]
    mov x0, x24
    bl Lpatch + (0x711c - PATCH_BASE)
LIupdate_bounds:
    GET x20, Lcontent_view
    cbz x0, LIupdate_restore
    GET x0, Lbounds
    bl LIrect_valid
    cbz w0, LIupdate_restore
    stp d0, d1, [sp, #96]
    stp d2, d3, [sp, #112]
    GET x24, Lbounds
    ldp d4, d5, [sp, #96]
    ldp d6, d7, [sp, #112]
    fcmp d0, d4
    fccmp d1, d5, #0, eq
    fccmp d2, d6, #0, eq
    fccmp d3, d7, #0, eq
    b.eq LIupdate_parent
    mov x0, x20
    bl LIcancel
    ldp d0, d1, [sp, #96]
    ldp d2, d3, [sp, #112]
    GET x24, LIset_bounds
LIupdate_parent:
    GET x24, Lsuperview
    cmp x0, x19
    b.eq LIupdate_visible
    mov x0, x20
    bl LIcancel
    mov x2, x24
    GET x19, LIadd_subview
LIupdate_visible:
    GET x24, Lis_hidden
    cbz w0, LIupdate_z
    mov w2, #0
    GET x24, Lset_hidden
LIupdate_z:
    GET x19, Lsubviews
    GET x0, Llast_object
    cmp x0, x24
    b.eq LIupdate_buttons
    mov x2, x24
    GET x19, Lbring_front
LIupdate_buttons:
    mov x25, #0
LIupdate_button_loop:
    cmp x25, x22
    b.hs LIupdate_state
    mov x2, x25
    GET x21, Lobject_at
    mov x26, x0
    GET x26, Lsuperview
    cmp x0, x24
    b.eq LIupdate_clear_button
    mov x2, x26
    GET x24, LIadd_subview
LIupdate_clear_button:
    mov x0, x26
    bl Lpatch + (0x73e0 - PATCH_BASE)
    add x25, x25, #1
    b LIupdate_button_loop
LIupdate_state:
    AGET x20, LIcontroller_key
    mov x25, x0
    AGET x25, LIdrag_key
    cbz x0, LIupdate_snap
    GET x19, Lselected_item
    mov x26, x0
    AGET x25, LIstart_item_key
    cmp x0, x26
    b.eq LIupdate_yes
    mov x0, x20
    bl LIcancel
LIupdate_snap:
    AGET x20, LIlens_key
    mov x27, x0
    cbz x27, LIupdate_restore
    GET x23, LIframe
    bl LIrect_valid
    cbz w0, LIupdate_restore
    mov x0, x27
    bl Lpatch + (0x711c - PATCH_BASE)
LIupdate_yes:
    AGET x20, LIlens_key
    mov x27, x0
    AGET x20, LIcontroller_key
    AGET x0, LIdrag_key
    cmp x0, #0
    cset w1, ne
    mov x0, x27
    bl LIappearance
    mov w0, #1
    b LIupdate_done
LIupdate_restore:
    mov x0, x19
    mov x1, x20
    bl LIrestore
LIupdate_no:
    mov w0, #0
LIupdate_done:
    ldp x27, x28, [sp, #80]
    ldp x25, x26, [sp, #64]
    ldp x23, x24, [sp, #48]
    ldp x21, x22, [sp, #32]
    ldp x19, x20, [sp, #16]
    ldp x29, x30, [sp], #128
    ret

LIrestore:
    stp x29, x30, [sp, #-96]!
    mov x29, sp
    stp x19, x20, [sp, #16]
    stp x21, x22, [sp, #32]
    stp x23, x24, [sp, #48]
    stp x25, x26, [sp, #64]
    stp x27, x28, [sp, #80]
    mov x19, x0
    mov x20, x1
    cbz x19, LIrestore_done
    cbz x20, LIrestore_done
    AGET x20, LIbound_key
    cmp x0, x19
    b.ne LIrestore_done
    AGET x20, LIoverlay_key
    mov x21, x0
    cbz x21, LIrestore_done
    GET x21, Lretain
    AGET x20, LIcontroller_key
    bl LIclear_state
    AGET x20, LIpan_key
    mov x22, x0
    mov w2, #0
    GET x22, LIset_enabled
    mov x2, #0
    GET x22, LIset_delegate
    mov x2, x22
    GET x21, LIremove_gesture
    GET x20, Lcontent_view
    mov x22, x0
    AGET x20, LIowned_buttons_key
    mov x23, x0
    GET x23, Lcount
    mov x24, x0
    sub x8, x24, #1
    cmp x8, #7
    b.hi LIrestore_remove
    AGET x20, LIbuttons_key
    mov x27, x0
    mov x25, #0
LIrestore_button_loop:
    cmp x25, x24
    b.hs LIrestore_remove
    mov x2, x25
    GET x23, Lobject_at
    mov x26, x0
    GET x26, Lsuperview
    cmp x0, x21
    b.ne LIrestore_next
    cbz x22, LIrestore_detach_button
    cbz x27, LIrestore_detach_button
    mov x2, x26
    GET x27, Lcontains
    cbz w0, LIrestore_detach_button
    mov x2, x26
    GET x22, LIadd_subview
    b LIrestore_next
LIrestore_detach_button:
    GET x26, LIremove_from_super
LIrestore_next:
    add x25, x25, #1
    b LIrestore_button_loop
LIrestore_remove:
    GET x21, LIremove_from_super
    ASET x20, LIpan_key, xzr, 0
    ASET x20, LIcontroller_key, xzr, 0
    ASET x20, LIlens_key, xzr, 0
    ASET x20, LIowned_buttons_key, xzr, 0
    ASET x20, LIoverlay_key, xzr, 0
    GET x21, Lrelease
    // When used as an active failure fallback, restore the native gray
    // selected decoration. Inactive/removed bars need no additional sync.
    AGET x19, LIactive_key
    cmp x0, x20
    b.ne LIrestore_done
    mov x0, x19
    mov x1, x20
    bl Lsync_original
LIrestore_done:
    ldp x27, x28, [sp, #80]
    ldp x25, x26, [sp, #64]
    ldp x23, x24, [sp, #48]
    ldp x21, x22, [sp, #32]
    ldp x19, x20, [sp, #16]
    ldp x29, x30, [sp], #96
    ret

// (controller, recognizer) -> bar/proxy/overlay/lens in x0..x3, or all zero.
// Ownership is recovered from recognizer.view and checked in both directions.
LIowner:
    stp x29, x30, [sp, #-64]!
    mov x29, sp
    stp x19, x20, [sp, #16]
    stp x21, x22, [sp, #32]
    stp x23, x24, [sp, #48]
    mov x19, x0
    mov x20, x1
    GET x20, LIview
    mov x21, x0
    cbz x21, LIowner_no
    GET x21, Lsuperview
    mov x22, x0
    cbz x22, LIowner_no
    AGET x22, LIactive_key
    mov x23, x0
    cbz x23, LIowner_no
    AGET x23, LIoverlay_key
    cmp x0, x21
    b.ne LIowner_no
    AGET x23, LIcontroller_key
    cmp x0, x19
    b.ne LIowner_no
    AGET x23, LIpan_key
    cmp x0, x20
    b.ne LIowner_no
    AGET x23, LIlens_key
    mov x24, x0
    cbz x24, LIowner_no
    GET x24, Lsuperview
    cmp x0, x21
    b.ne LIowner_no
    mov x0, x22
    mov x1, x23
    bl LIvalid
    cbz w0, LIowner_no
    GET x21, Lis_hidden
    cbnz w0, LIowner_no
    mov x0, x22
    mov x1, x23
    mov x2, x21
    mov x3, x24
    b LIowner_done
LIowner_no:
    mov x0, #0
    mov x1, #0
    mov x2, #0
    mov x3, #0
LIowner_done:
    ldp x23, x24, [sp, #48]
    ldp x21, x22, [sp, #32]
    ldp x19, x20, [sp, #16]
    ldp x29, x30, [sp], #64
    ret

LIshould_begin:
    stp x29, x30, [sp, #-48]!
    mov x29, sp
    stp x19, x20, [sp, #16]
    stp x21, x22, [sp, #32]
    mov x19, x0
    mov x20, x2
    mov x1, x20
    bl LIowner
    cbz x0, LIshould_no
    mov x21, x0
    mov x22, x2
    mov x19, x1
    AGET x19, LIbuttons_key
    mov x1, x0
    mov x0, x19
    bl LIbuttons_match
    cbz w0, LIshould_no
    AGET x19, LIbuttons_key
    mov x1, x0
    mov x0, x21
    bl LIselected
    cbz x0, LIshould_no
    GET x20, LItouch_count
    cmp x0, #1
    b.ne LIshould_no
    mov x2, x22
    GET x20, LIvelocity
    FINITE d0, LIshould_no
    FINITE d1, LIshould_no
    fabs d0, d0
    fabs d1, d1
    fcmp d0, d1
    cset w0, gt
    b LIshould_done
LIshould_no:
    mov w0, #0
LIshould_done:
    ldp x21, x22, [sp, #32]
    ldp x19, x20, [sp, #16]
    ldp x29, x30, [sp], #48
    ret

// (proxy, desired center in d0) -> nearest button, and move only our lens.
// All centers are measured from the actual button frames; array order need
// not be visual order, so RTL and differing widths do not invert selection.
LIplace:
    stp x29, x30, [sp, #-272]!
    mov x29, sp
    stp x19, x20, [sp, #16]
    stp x21, x22, [sp, #32]
    stp x23, x24, [sp, #48]
    stp x25, x26, [sp, #64]
    stp d8, d9, [sp, #80]
    stp d10, d11, [sp, #96]
    stp d12, d13, [sp, #112]
    stp d14, d15, [sp, #128]
    mov x19, x0
    FINITE d0, LIplace_no
    fmov d8, d0
    AGET x19, LIoverlay_key
    mov x22, x0
    AGET x19, LIlens_key
    mov x20, x0
    cbz x22, LIplace_no
    cbz x20, LIplace_no
    GET x20, LIframe
    bl LIrect_valid
    cbz w0, LIplace_no
    fmov d12, d2
    fmov d13, d3
    fmov d14, d1
    GET x22, Lbounds
    bl LIrect_valid
    cbz w0, LIplace_no
    fcmp d12, d2
    b.gt LIplace_no
    fcmp d13, d3
    b.gt LIplace_no
    fmov d4, #0.5
    fmul d4, d12, d4
    fadd d15, d0, d4
    fadd d11, d0, d2
    fsub d11, d11, d4
    fmax d14, d14, d1
    fadd d3, d1, d3
    fsub d3, d3, d13
    fmin d14, d14, d3
    AGET x19, LIbuttons_key
    mov x21, x0
    GET x21, Lcount
    mov x23, x0
    sub x8, x23, #1
    cmp x8, #7
    b.hi LIplace_no
    mov x24, #0
LIplace_collect:
    cmp x24, x23
    b.hs LIplace_clamp
    mov x2, x24
    GET x21, Lobject_at
    mov x25, x0
    GET x25, LIframe
    bl LIrect_valid
    cbz w0, LIplace_no
    fmov d4, #0.5
    fmul d4, d2, d4
    fadd d0, d0, d4
    FINITE d0, LIplace_no
    add x8, sp, #144
    add x8, x8, x24, lsl #4
    str x25, [x8]
    str d0, [x8, #8]
    cbnz x24, LIplace_minmax
    fmov d9, d0
    fmov d10, d0
    b LIplace_collect_next
LIplace_minmax:
    fmin d9, d9, d0
    fmax d10, d10, d0
LIplace_collect_next:
    add x24, x24, #1
    b LIplace_collect
LIplace_clamp:
    // Intersect actual center range with the lens-containing bounds range.
    fmax d9, d9, d15
    fmin d10, d10, d11
    fcmp d9, d10
    b.gt LIplace_no
    fmax d8, d8, d9
    fmin d8, d8, d10
    mov x24, #0
    mov x26, #0
LIplace_nearest:
    cmp x24, x23
    b.hs LIplace_set
    add x8, sp, #144
    add x8, x8, x24, lsl #4
    ldr x25, [x8]
    ldr d0, [x8, #8]
    fsub d0, d0, d8
    fabs d0, d0
    cbz x26, LIplace_choose
    fcmp d0, d11
    b.ge LIplace_nearest_next
LIplace_choose:
    mov x26, x25
    fmov d11, d0
LIplace_nearest_next:
    add x24, x24, #1
    b LIplace_nearest
LIplace_set:
    fmov d0, #0.5
    fmul d0, d12, d0
    fsub d0, d8, d0
    fmov d1, d14
    fmov d2, d12
    fmov d3, d13
    mov x0, x20
    bl Lpatch + (0x711c - PATCH_BASE)
    mov x0, x26
    b LIplace_done
LIplace_no:
    mov x0, #0
LIplace_done:
    ldp d14, d15, [sp, #128]
    ldp d12, d13, [sp, #112]
    ldp d10, d11, [sp, #96]
    ldp d8, d9, [sp, #80]
    ldp x25, x26, [sp, #64]
    ldp x23, x24, [sp, #48]
    ldp x21, x22, [sp, #32]
    ldp x19, x20, [sp, #16]
    ldp x29, x30, [sp], #272
    ret

LIpan:
    stp x29, x30, [sp, #-112]!
    mov x29, sp
    stp x19, x20, [sp, #16]
    stp x21, x22, [sp, #32]
    stp x23, x24, [sp, #48]
    stp x25, x26, [sp, #64]
    stp d8, d9, [sp, #80]
    stp x27, x28, [sp, #96]
    mov x19, x0
    mov x20, x2
    // Selection callbacks may synchronously tear down this interaction.
    GET x19, Lretain
    GET x20, Lretain
    mov x0, x19
    mov x1, x20
    bl LIowner
    cbz x0, LIpan_unowned
    mov x21, x0
    mov x22, x1
    mov x23, x2
    mov x24, x3
    AGET x22, LIbuttons_key
    mov x1, x0
    mov x0, x22
    bl LIbuttons_match
    cbz w0, LIpan_cancel
    GET x20, LIstate
    mov x25, x0
    cmp x25, #1
    b.eq LIpan_begin
    AGET x19, LIdrag_key
    cbz x0, LIpan_done
    cmp x25, #2
    b.eq LIpan_move
    cmp x25, #3
    b.eq LIpan_move
    cmp x25, #4
    b.eq LIpan_snap
    cmp x25, #5
    b.eq LIpan_snap
    b LIpan_done
LIpan_begin:
    AGET x22, LIbuttons_key
    mov x1, x0
    mov x0, x21
    bl LIselected
    cbz x0, LIpan_snap
    GET x0, LIframe
    bl LIrect_valid
    cbz w0, LIpan_snap
    fmov d4, #0.5
    fmul d4, d2, d4
    fadd d8, d0, d4
    mov x0, x24
    bl Lpatch + (0x711c - PATCH_BASE)
    mov x2, x23
    GET x20, LIlocation
    FINITE d0, LIpan_snap
    FINITE d1, LIpan_snap
    fsub d0, d0, d8
    FINITE d0, LIpan_snap
    bl Lnumber
    ASET x19, LIoffset_key, x0, 1
    GET x21, Lselected_item
    cbz x0, LIpan_snap
    ASET x19, LIstart_item_key, x0, 1
    ASET x19, LIdrag_key, x19, 0
    mov x0, x24
    mov w1, #1
    bl LIappearance
    b LIpan_done
LIpan_move:
    // A host selection change wins over an in-flight gesture.
    GET x21, Lselected_item
    mov x26, x0
    AGET x19, LIstart_item_key
    cmp x0, x26
    b.ne LIpan_cancel
    AGET x19, LIoffset_key
    cbz x0, LIpan_cancel
    GET x0, LIdouble_value
    FINITE d0, LIpan_cancel
    fmov d8, d0
    mov x2, x23
    GET x20, LIlocation
    FINITE d0, LIpan_cancel
    FINITE d1, LIpan_cancel
    fsub d0, d0, d8
    mov x0, x22
    bl LIplace
    mov x26, x0
    cbz x26, LIpan_cancel
    cmp x25, #3
    b.ne LIpan_done
    // Commit only once on ended; all changed events are geometry-only.
    mov x0, x19
    bl LIclear_state
    mov x0, x21
    mov x1, #0
    mov x2, x26
    bl Lpatch + (0x56c0 - PATCH_BASE)
    b LIpan_done
LIpan_cancel:
    mov x0, x22
    bl LIcancel
LIpan_snap:
    mov x0, x19
    bl LIclear_state
    mov x0, x21
    mov x1, x22
    bl LIupdate
    b LIpan_done
LIpan_unowned:
    mov x0, x19
    bl LIclear_state
LIpan_done:
    GET x20, Lrelease
    GET x19, Lrelease
    ldp x27, x28, [sp, #96]
    ldp d8, d9, [sp, #80]
    ldp x25, x26, [sp, #64]
    ldp x23, x24, [sp, #48]
    ldp x21, x22, [sp, #32]
    ldp x19, x20, [sp, #16]
    ldp x29, x30, [sp], #112
    ret

// (lens, dragging). A semantic mode key prevents effect replacement on each
// finger move/layout. Alpha remains one on every visual-effect ancestor.
LIappearance:
    stp x29, x30, [sp, #-48]!
    mov x29, sp
    stp x19, x20, [sp, #16]
    stp x21, x22, [sp, #32]
    mov x19, x0
    cbz x19, LIappearance_done
    cmp w1, #0
    mov w20, #1
    cinc w20, w20, ne
    AGET x19, LIlens_mode_key
    cmp x0, x20
    b.eq LIappearance_done
    cmp w20, #2
    b.ne LIappearance_rest
    AGET x19, LIlens_effect_key
    cbz x0, LIappearance_rest
    mov x2, x0
    GET x19, LIset_effect
    adr x0, LIcolor_class
    adr x1, LIclear_color
    bl Lfactory
    b LIappearance_color
LIappearance_rest:
    mov w20, #1
    mov x2, #0
    GET x19, LIset_effect
    adr x0, LIcolor_class
    adr x1, LIgray_fill
    bl Lfactory
LIappearance_color:
    mov x22, x0
    GET x19, Lcontent_view
    mov x21, x0
    mov x2, x22
    GET x21, Lset_background
    mov x0, x21
    bl Lbutton_round
    ASET x19, LIlens_mode_key, x20, 0
LIappearance_done:
    ldp x21, x22, [sp, #32]
    ldp x19, x20, [sp, #16]
    ldp x29, x30, [sp], #48
    ret


// Scoped control geometry, FanqieAdBlock 1.5.8.
// Two entry patches only: 0x7848 -> LGstyle_control; 0x7ac4 -> LGstyle_glyph.
// No host control frame, target/action, title, font, or label layout is changed.
// All geometry is expressed in the original view's coordinate system.

.set LGsurface_key, Lpatch + (0xeb8b - PATCH_BASE)
.set LGbounds, Lpatch + (0xbb3c - PATCH_BASE)
.set LGsuperview, Lpatch + (0xbb1e - PATCH_BASE)
.set LGhidden, Lpatch + (0xbe75 - PATCH_BASE)
.set LGset_hidden, Lpatch + (0xbba3 - PATCH_BASE)
.set LGsubviews, Lpatch + (0xbed0 - PATCH_BASE)
.set LGresponds, Lpatch + (0xb5cb - PATCH_BASE)
.set LGremove, Lpatch + (0xbb28 - PATCH_BASE)
.set LGreader_nav, Lpatch + (0xb890 - PATCH_BASE)
.set LGstory_big, Lpatch + (0xc31a - PATCH_BASE)
.set LGstory_small, Lpatch + (0xc348 - PATCH_BASE)
.set LGreader_download, Lpatch + (0xc2d7 - PATCH_BASE)
.set LGshelf_header, Lpatch + (0xc16b - PATCH_BASE)
.set LGshelf_subheader, Lpatch + (0xc196 - PATCH_BASE)
.set LGshelf_edit, Lpatch + (0xc1ca - PATCH_BASE)
.set LGshelf_filter, Lpatch + (0xc1fe - PATCH_BASE)
.set LGback_selector, Lpatch + (0xbf9b - PATCH_BASE)
.set LGshare_selector, Lpatch + (0xbfac - PATCH_BASE)
.set LGmore_selector, Lpatch + (0xbfb8 - PATCH_BASE)

// Return 1 for reader navigation, 2 for bookshelf headers, zero otherwise.
// Class names are the exact owners installed in the original hook tables.
// The six-level bound also prevents cycles from hanging layout callbacks.
LGscope:
    stp x29, x30, [sp, #-64]!
    mov x29, sp
    stp x19, x20, [sp, #16]
    stp x21, x22, [sp, #32]
    stp x23, x24, [sp, #48]
    mov x19, x0
    mov w20, #6
LGscope_level:
    cbz x19, LGscope_no
    cbz w20, LGscope_no
    adr x21, LGscope_table
    mov w22, #8
LGscope_class:
    ldr w23, [x21]
    adr x1, Lpatch
    add x1, x1, x23
    mov x0, x19
    bl Lpatch + (0x7394 - PATCH_BASE)
    cbnz w0, LGscope_yes
    add x21, x21, #8
    subs w22, w22, #1
    b.ne LGscope_class
    GET x19, LGsuperview
    mov x19, x0
    sub w20, w20, #1
    b LGscope_level
LGscope_yes:
    ldr w0, [x21, #4]
    b LGscope_done
LGscope_no:
    mov w0, #0
LGscope_done:
    ldp x23, x24, [sp, #48]
    ldp x21, x22, [sp, #32]
    ldp x19, x20, [sp, #16]
    ldp x29, x30, [sp], #64
    ret

// CGRect union record: minX,minY,maxX,maxY,lineHeight at +0..32;
// all-content count +40, nonempty-label count +48, image count +56,
// remaining visit budget +64, recognized-content count +72.
// At most 32 descendants and three levels.
// Uses UILabel intrinsic size/alignment and UIImageView's actual draw mode.
// Plugin UIVisualEffectView subtrees and nested controls are not content.
LGscan:
    stp x29, x30, [sp, #-128]!
    mov x29, sp
    stp x19, x20, [sp, #16]
    stp x21, x22, [sp, #32]
    stp x23, x24, [sp, #48]
    stp x25, x26, [sp, #64]
    stp d8, d9, [sp, #80]
    stp d10, d11, [sp, #96]
    stp d12, d13, [sp, #112]
    mov x19, x0
    mov x20, x1
    mov x21, x2
    mov w22, w3
    cbz x19, LGscan_done
    ldr x8, [x21, #64]
    cbz x8, LGscan_done
    sub x8, x8, #1
    str x8, [x21, #64]
    GET x19, LGhidden
    cbnz w0, LGscan_hidden_content
    GET x19, LGalpha
    FINITE d0, LGscan_hidden_content
    fcmp d0, #0.0
    b.le LGscan_hidden_content
    mov x0, x19
    adr x1, LGvisual_class
    bl Lpatch + (0x7394 - PATCH_BASE)
    cbnz w0, LGscan_done
    mov x0, x19
    adr x1, LGlabel_class
    bl Lpatch + (0x7394 - PATCH_BASE)
    cbnz w0, LGscan_label
    mov x0, x19
    adr x1, LGimage_class
    bl Lpatch + (0x7394 - PATCH_BASE)
    cbnz w0, LGscan_image
    cmp x19, x20
    b.eq LGscan_children
    mov x0, x19
    adr x1, LGcontrol_class
    bl Lpatch + (0x7394 - PATCH_BASE)
    cbnz w0, LGscan_done
LGscan_children:
    cbz w22, LGscan_done
    GET x19, LGsubviews
    mov x23, x0
    GET x23, LGcount
    mov x24, x0
    mov x25, #0
LGscan_child_loop:
    cmp x25, x24
    b.hs LGscan_done
    ldr x8, [x21, #64]
    cbz x8, LGscan_done
    mov x2, x25
    GET x23, LGobject_at
    mov x1, x20
    mov x2, x21
    sub w3, w22, #1
    bl LGscan
    add x25, x25, #1
    b LGscan_child_loop

LGscan_label:
    ldr x8, [x21, #72]
    add x8, x8, #1
    str x8, [x21, #72]
    GET x19, LGtext
    mov x23, x0
    GET x23, LGlength
    cbz x0, LGscan_done
    GET x19, LGbounds
    fmov d8, d0
    fmov d9, d1
    fmov d10, d2
    fmov d11, d3
    GET x19, LGfont
    cbz x0, LGscan_label_size
    adr x1, LGline_height
    bl Lmessage
    FINITE d0, LGscan_label_size
    fcmp d0, #0.0
    b.le LGscan_label_size
    ldr d1, [x21, #32]
    fmax d0, d0, d1
    str d0, [x21, #32]
LGscan_label_size:
    GET x19, LGintrinsic_size
    FINITE d0, LGscan_label_rect
    FINITE d1, LGscan_label_rect
    fcmp d0, #0.0
    b.le LGscan_label_rect
    fcmp d1, #0.0
    b.le LGscan_label_rect
    fmin d12, d0, d10
    fmin d13, d1, d11
    GET x19, LGtext_alignment
    cmp w0, #4
    b.ne LGscan_label_alignment
    GET x19, LGdirection
    cmp w0, #1
    mov w0, #2
    b.eq LGscan_label_alignment
    mov w0, #0
LGscan_label_alignment:
    fsub d4, d10, d12
    cmp w0, #1
    b.eq LGscan_label_center
    cmp w0, #2
    b.eq LGscan_label_right
    fmov d4, xzr
    b LGscan_label_position
LGscan_label_center:
    fmov d5, #0.5
    fmul d4, d4, d5
LGscan_label_right:
LGscan_label_position:
    fadd d8, d8, d4
    fsub d4, d11, d13
    fmov d5, #0.5
    fmul d4, d4, d5
    fadd d9, d9, d4
    fmov d10, d12
    fmov d11, d13
LGscan_label_rect:
    mov w24, #1
    b LGscan_convert

LGscan_image:
    ldr x8, [x21, #72]
    add x8, x8, #1
    str x8, [x21, #72]
    GET x19, LGimage
    mov x23, x0
    cbz x23, LGscan_done
    GET x19, LGbounds
    fmov d8, d0
    fmov d9, d1
    fmov d10, d2
    fmov d11, d3
    GET x23, LGsize
    FINITE d0, LGscan_done
    FINITE d1, LGscan_done
    fcmp d0, #0.0
    b.le LGscan_done
    fcmp d1, #0.0
    b.le LGscan_done
    fmov d12, d0
    fmov d13, d1
    GET x19, LGcontent_mode
    cbz w0, LGscan_image_rect
    cmp w0, #3
    b.eq LGscan_image_rect
    cmp w0, #1
    b.eq LGscan_image_fit
    cmp w0, #2
    b.eq LGscan_image_fill
    // Center/edge/corner modes retain intrinsic image size.
    fsub d4, d10, d12
    fsub d5, d11, d13
    fmov d6, #0.5
    cmp w0, #7
    b.eq LGscan_image_left
    cmp w0, #8
    b.eq LGscan_image_right
    cmp w0, #5
    b.eq LGscan_image_top
    cmp w0, #6
    b.eq LGscan_image_bottom
    cmp w0, #9
    b.eq LGscan_image_top_left
    cmp w0, #10
    b.eq LGscan_image_top_right
    cmp w0, #11
    b.eq LGscan_image_bottom_left
    cmp w0, #12
    b.eq LGscan_image_position
    fmul d4, d4, d6
    fmul d5, d5, d6
    b LGscan_image_position
LGscan_image_left:
    fmov d4, xzr
    fmul d5, d5, d6
    b LGscan_image_position
LGscan_image_right:
    fmul d5, d5, d6
    b LGscan_image_position
LGscan_image_top:
    fmul d4, d4, d6
    fmov d5, xzr
    b LGscan_image_position
LGscan_image_bottom:
    fmul d4, d4, d6
    b LGscan_image_position
LGscan_image_top_left:
    fmov d4, xzr
LGscan_image_top_right:
    fmov d5, xzr
    b LGscan_image_position
LGscan_image_bottom_left:
    fmov d4, xzr
    b LGscan_image_position
LGscan_image_fit:
    fdiv d4, d10, d12
    fdiv d5, d11, d13
    fmin d4, d4, d5
    b LGscan_image_scale
LGscan_image_fill:
    fdiv d4, d10, d12
    fdiv d5, d11, d13
    fmax d4, d4, d5
LGscan_image_scale:
    fmul d12, d12, d4
    fmul d13, d13, d4
    fsub d4, d10, d12
    fsub d5, d11, d13
    fmov d6, #0.5
    fmul d4, d4, d6
    fmul d5, d5, d6
LGscan_image_position:
    fadd d8, d8, d4
    fadd d9, d9, d5
    fmov d10, d12
    fmov d11, d13
LGscan_image_rect:
    mov x0, x23
    fmov d0, d8
    fmov d1, d9
    fmov d2, d10
    fmov d3, d11
    bl LRimage_alignment
    fmov d8, d0
    fmov d9, d1
    fmov d10, d2
    fmov d11, d3
    mov w24, #0
LGscan_convert:
    fmov d0, d8
    fmov d1, d9
    fmov d2, d10
    fmov d3, d11
    mov x2, x20
    GET x19, LGconvert_rect
    FINITE d0, LGscan_done
    FINITE d1, LGscan_done
    FINITE d2, LGscan_done
    FINITE d3, LGscan_done
    fcmp d2, #0.0
    b.le LGscan_done
    fcmp d3, #0.0
    b.le LGscan_done
    fadd d2, d0, d2
    fadd d3, d1, d3
    ldr x8, [x21, #40]
    cbz x8, LGscan_first
    ldp d4, d5, [x21]
    ldp d6, d7, [x21, #16]
    fmin d0, d0, d4
    fmin d1, d1, d5
    fmax d2, d2, d6
    fmax d3, d3, d7
LGscan_first:
    stp d0, d1, [x21]
    stp d2, d3, [x21, #16]
    add x8, x8, #1
    str x8, [x21, #40]
    cbz w24, LGscan_add_image
    ldr x8, [x21, #48]
    add x8, x8, #1
    str x8, [x21, #48]
    b LGscan_done
LGscan_add_image:
    ldr x8, [x21, #56]
    add x8, x8, #1
    str x8, [x21, #56]
    b LGscan_done
LGscan_hidden_content:
    mov x0, x19
    adr x1, LGlabel_class
    bl Lpatch + (0x7394 - PATCH_BASE)
    cbnz w0, LGscan_mark_hidden
    mov x0, x19
    adr x1, LGimage_class
    bl Lpatch + (0x7394 - PATCH_BASE)
    cbz w0, LGscan_done
LGscan_mark_hidden:
    ldr x8, [x21, #72]
    add x8, x8, #1
    str x8, [x21, #72]
LGscan_done:
    ldp d12, d13, [sp, #112]
    ldp d10, d11, [sp, #96]
    ldp d8, d9, [sp, #80]
    ldp x25, x26, [sp, #64]
    ldp x23, x24, [sp, #48]
    ldp x21, x22, [sp, #32]
    ldp x19, x20, [sp, #16]
    ldp x29, x30, [sp], #128
    ret

// (view, union record) -> BOOL and CGRect in d0..d3.
// The shape is centered on drawn content, not on an arbitrary hit-area origin.
// Nominal icon diameter 36pt, growing to at most 44pt for larger glyphs.
// Text receives 10pt horizontal / 5pt vertical desired padding and a pill
// aspect of at least 1.5. Parent bounds and the control's own clipping bound
// constrain the shape; insufficient padding causes a conservative no-op.
LGgeometry:
    stp x29, x30, [sp, #-112]!
    mov x29, sp
    stp x19, x20, [sp, #16]
    stp x21, x22, [sp, #32]
    stp d8, d9, [sp, #48]
    stp d10, d11, [sp, #64]
    stp d12, d13, [sp, #80]
    stp d14, d15, [sp, #96]
    mov x19, x0
    mov x20, x1
    ldr x8, [x20, #40]
    cbz x8, LGgeometry_no
    ldp d8, d9, [x20]
    ldp d10, d11, [x20, #16]
    fsub d12, d10, d8
    fsub d13, d11, d9
    fmov d4, #0.5
    fadd d8, d8, d10
    fadd d9, d9, d11
    fmul d8, d8, d4
    fmul d9, d9, d4
    ldr x21, [x20, #48]
    cbnz x21, LGgeometry_text
    fmax d10, d12, d13
    ldr d4, LGforty
    fcmp d10, d4
    b.gt LGgeometry_no
    fmov d4, #10.0
    fadd d10, d10, d4
    ldr d4, LGthirty_six
    fmax d10, d10, d4
    ldr d4, LGforty_four
    fmin d10, d10, d4
    fmov d11, d10
    b LGgeometry_bounds
LGgeometry_text:
    ldr d4, [x20, #32]
    fmax d11, d4, d13
    fmov d4, #10.0
    fadd d11, d11, d4
    ldr d4, LGthirty_two
    fmax d11, d11, d4
    fmov d4, #20.0
    fadd d10, d12, d4
    fmov d4, #1.5
    fmul d4, d11, d4
    fmax d10, d10, d4
LGgeometry_bounds:
    GET x19, LGclips
    cbnz w0, LGgeometry_own_bounds
    GET x19, LGsuperview
    mov x22, x0
    cbz x22, LGgeometry_own_bounds
    GET x22, LGbounds
    mov x2, x19
    GET x22, LGconvert_rect
    b LGgeometry_limit
LGgeometry_own_bounds:
    GET x19, LGbounds
LGgeometry_limit:
    FINITE d0, LGgeometry_no
    FINITE d1, LGgeometry_no
    FINITE d2, LGgeometry_no
    FINITE d3, LGgeometry_no
    fadd d2, d0, d2
    fadd d3, d1, d3
    fsub d0, d8, d0
    fsub d1, d9, d1
    fsub d2, d2, d8
    fsub d3, d3, d9
    fmin d0, d0, d2
    fmin d1, d1, d3
    fadd d0, d0, d0
    fadd d1, d1, d1
    fcmp d0, #0.0
    b.le LGgeometry_no
    fcmp d1, #0.0
    b.le LGgeometry_no
    fmin d10, d10, d0
    fmin d11, d11, d1
    cbnz x21, LGgeometry_limit_text
    fmin d10, d10, d11
    fmov d11, d10
    fmax d4, d12, d13
    fmov d5, #4.0
    fadd d4, d4, d5
    fcmp d10, d4
    b.lt LGgeometry_no
    b LGgeometry_yes
LGgeometry_limit_text:
    fmov d4, #1.5
    fdiv d4, d10, d4
    fmin d11, d11, d4
    fmov d4, #12.0
    fadd d4, d12, d4
    fcmp d10, d4
    b.lt LGgeometry_no
    fmov d4, #6.0
    fadd d4, d13, d4
    fcmp d11, d4
    b.lt LGgeometry_no
LGgeometry_yes:
    fmov d4, #0.5
    fmul d0, d10, d4
    fmul d1, d11, d4
    fsub d0, d8, d0
    fsub d1, d9, d1
    fmov d2, d10
    fmov d3, d11
    mov w0, #1
    b LGgeometry_done
LGgeometry_no:
    mov w0, #0
LGgeometry_done:
    ldp d14, d15, [sp, #96]
    ldp d12, d13, [sp, #80]
    ldp d10, d11, [sp, #64]
    ldp d8, d9, [sp, #48]
    ldp x21, x22, [sp, #32]
    ldp x19, x20, [sp, #16]
    ldp x29, x30, [sp], #112
    ret

// Commit the native capsule only AFTER final positive bounds are installed.
// The old finish changed cornerConfiguration on EVERY layout. In reader bars
// both the parent and the download control run layout hooks, so that setter
// could continuously invalidate the same material. The size snapshot makes
// repeated settled layouts mutation-free; a real resize still reapplies it.
// The material remains decorative and cannot intercept the host's hit testing.
LGfinish:
    stp x29, x30, [sp, #-64]!
    mov x29, sp
    stp x19, x20, [sp, #16]
    stp x21, x22, [sp, #32]
    stp d8, d9, [sp, #48]
    mov x19, x0
    cbz x19, LGfinish_done
    GET x19, LGhidden
    cbz w0, LGfinish_size
    mov w2, #0
    GET x19, LGset_hidden
LGfinish_size:
    GET x19, LGbounds
    FINITE d2, LGfinish_done
    FINITE d3, LGfinish_done
    fcmp d2, #0.0
    b.le LGfinish_done
    fcmp d3, #0.0
    b.le LGfinish_done
    fmov d8, d2
    fmov d9, d3
    AGET x19, LGfinish_size_key
    mov x20, x0
    cbz x20, LGfinish_first
    GET x20, LGsize_value
    fcmp d0, d8
    b.ne LGfinish_commit
    fcmp d1, d9
    b.eq LGfinish_done
    b LGfinish_commit
LGfinish_first:
    mov x2, #0
    GET x19, LGautoresize
    mov w2, #0
    GET x19, LGdisable_touch
    mov w2, #1
    GET x19, LGhide_accessibility
LGfinish_commit:
    adr x0, LMcorner_class
    bl Lpatch + (0xa5b0 - PATCH_BASE)
    adr x1, LMcapsule
    bl Lmessage
    cbz x0, LGfinish_done
    mov x2, x0
    GET x19, LMset_corner
    adr x0, LGvalue_class
    bl Lpatch + (0xa5b0 - PATCH_BASE)
    fmov d0, d8
    fmov d1, d9
    adr x1, LGvalue_size
    bl Lmessage
    cbz x0, LGfinish_done
    ASET x19, LGfinish_size_key, x0, 1
LGfinish_done:
    mov x0, x19
    ldp d8, d9, [sp, #48]
    ldp x21, x22, [sp, #32]
    ldp x19, x20, [sp, #16]
    ldp x29, x30, [sp], #64
    ret

LGstyle_control:
    stp x29, x30, [sp, #-144]!
    mov x29, sp
    stp x19, x20, [sp, #16]
    stp x21, x22, [sp, #32]
    str x1, [sp, #48]
    mov x19, x0
    mov x22, #0
    bl LGscope
    cbz w0, LGcontrol_fallback
    str w0, [sp, #56]
    AGET x19, LGcontrol_busy_key
    cbnz x0, LGcontrol_reentrant
    ASET x19, LGcontrol_busy_key, x19, 0
    mov x22, #1
    ldr w8, [sp, #56]
    cmp w8, #1
    b.ne LGcontrol_visibility
    bl LRenabled
    cbz w0, LGcontrol_too_small
LGcontrol_visibility:
    GET x19, LGhidden
    cbnz w0, LGcontrol_too_small
    GET x19, LGalpha
    FINITE d0, LGcontrol_too_small
    fcmp d0, #0.0
    b.le LGcontrol_too_small
    // Retain the original control-size envelope; this is not a panel skin.
    GET x19, LGbounds
    FINITE d0, LGcontrol_too_small
    FINITE d1, LGcontrol_too_small
    FINITE d2, LGcontrol_too_small
    FINITE d3, LGcontrol_too_small
    fmov d4, #22.0
    fcmp d2, d4
    b.lt LGcontrol_fallback
    fcmp d3, d4
    b.lt LGcontrol_fallback
    ldr d4, LGmax_control_width
    fcmp d2, d4
    b.gt LGcontrol_fallback
    ldr d4, LGmax_control_height
    fcmp d3, d4
    b.gt LGcontrol_fallback
    add x20, sp, #64
    stp xzr, xzr, [x20]
    stp xzr, xzr, [x20, #16]
    stp xzr, xzr, [x20, #32]
    stp xzr, xzr, [x20, #48]
    mov x8, #32
    stp x8, xzr, [x20, #64]
    mov x0, x19
    mov x1, x19
    mov x2, x20
    mov w3, #3
    bl LGscan
    ldr x8, [x20, #40]
    // Unknown custom drawing is not guessed at: preserve the original path.
    cbnz x8, LGcontrol_geometry
    ldr x8, [x20, #72]
    cbz x8, LGcontrol_fallback
    b LGcontrol_too_small
LGcontrol_geometry:
    mov x0, x19
    mov x1, x20
    bl LGgeometry
    cbz w0, LGcontrol_too_small
    mov x0, x19
    bl Lpatch + (0x74d0 - PATCH_BASE)
    bl LGfinish
    b LGcontrol_done
LGcontrol_too_small:
    AGET x19, LGsurface_key
    mov x21, x0
    cbz x21, LGcontrol_empty
    // Release only the plugin-owned decoration. A later visible layout or an
    // out-of-scope original path can then create an unhidden material afresh.
    GET x21, LGremove
    mov x0, x19
    adr x1, LGsurface_key
    mov x2, #0
    mov w3, #1
    bl Lpatch + (0xa634 - PATCH_BASE)
LGcontrol_empty:
    mov x0, #0
    b LGcontrol_done
LGcontrol_fallback:
    mov x0, x19
    ldr x1, [sp, #48]
    bl LGcontrol_original
LGcontrol_done:
    cbz x22, LGcontrol_return
    mov x21, x0
    ASET x19, LGcontrol_busy_key, xzr, 0
    mov x0, x21
LGcontrol_return:
    ldp x21, x22, [sp, #32]
    ldp x19, x20, [sp, #16]
    ldp x29, x30, [sp], #144
    ret
LGcontrol_reentrant:
    // A nested layout must leave the outer call's marker in place.
    AGET x19, LGsurface_key
    b LGcontrol_return
LGcontrol_original:
    stp x20, x19, [sp, #-32]!
    b Lpatch + (0x784c - PATCH_BASE)

// Preserve original glyph lifecycle; modify only three established reader
// selectors and exact reader owners. Other short-video/share/library glyphs
// retain the original implementation byte-for-byte through the trampoline.
LGstyle_glyph:
    stp x29, x30, [sp, #-160]!
    mov x29, sp
    stp x19, x20, [sp, #16]
    stp x21, x22, [sp, #32]
    stp x23, x24, [sp, #48]
    mov x19, x0
    mov x20, x1
    bl LGscope
    cmp w0, #1
    b.ne LGglyph_fallback
    mov x0, x20
    adr x1, LGback_selector
    bl LGstreq
    cbnz w0, LGglyph_scoped
    mov x0, x20
    adr x1, LGshare_selector
    bl LGstreq
    cbnz w0, LGglyph_scoped
    mov x0, x20
    adr x1, LGmore_selector
    bl LGstreq
    cbz w0, LGglyph_fallback
LGglyph_scoped:
    mov x0, x19
    mov x1, x20
    bl Lmessage
    mov x21, x0
    cbz x21, LGglyph_fallback
    mov x0, x21
    adr x1, LGcontrol_class
    bl Lpatch + (0x7394 - PATCH_BASE)
    cbnz w0, LGglyph_control
    mov x0, x21
    adr x1, LGimage_class
    bl Lpatch + (0x7394 - PATCH_BASE)
    cbz w0, LGglyph_fallback
    // Only the documented back getter is eligible for glyph normalization.
    // Its original UIButton ancestor, if any, remains the hit target.
    mov x0, x20
    adr x1, LGback_selector
    bl LGstreq
    cbz w0, LGglyph_image_parent
    mov x0, x21
    mov x1, x19
    bl LRback_prepare
LGglyph_image_parent:
    // An image nested inside a control shares that control's material.
    // Do not add a glyph sibling and then a second ancestor capsule.
    GET x21, LGsuperview
    mov x24, x0
    mov w23, #2
LGglyph_parent_control:
    cbz x24, LGglyph_image
    cmp x24, x19
    b.eq LGglyph_image
    mov x0, x24
    adr x1, LGcontrol_class
    bl Lpatch + (0x7394 - PATCH_BASE)
    cbnz w0, LGglyph_use_parent_control
    subs w23, w23, #1
    b.eq LGglyph_image
    GET x24, LGsuperview
    mov x24, x0
    b LGglyph_parent_control
LGglyph_use_parent_control:
    mov x21, x24
    b LGglyph_control
LGglyph_image:
    // The legacy glyph path expands the full image view by 4pt. Calling it
    // before the drawn-content geometry below made settled layouts alternate
    // between the legacy frame and the new 36pt circle on every pass. Only
    // invoke that lifecycle when creating, moving, or hiding the material.
    mov x0, x19
    mov x1, x20
    bl Lpatch + (0xa628 - PATCH_BASE)
    mov x22, x0
    cbz x22, LGglyph_legacy_material
    GET x21, LGhidden
    cbnz w0, LGglyph_legacy_material
    GET x21, LGsuperview
    mov x24, x0
    cbz x24, LGglyph_legacy_material
    GET x22, LGsuperview
    cmp x0, x24
    b.eq LGglyph_measure
LGglyph_legacy_material:
    mov x0, x19
    mov x1, x20
    bl LGglyph_original
    mov x0, x19
    mov x1, x20
    bl Lpatch + (0xa628 - PATCH_BASE)
    mov x22, x0
    cbz x22, LGglyph_done
LGglyph_measure:
    add x23, sp, #80
    stp xzr, xzr, [x23]
    stp xzr, xzr, [x23, #16]
    stp xzr, xzr, [x23, #32]
    stp xzr, xzr, [x23, #48]
    mov x8, #32
    stp x8, xzr, [x23, #64]
    mov x0, x21
    mov x1, x21
    mov x2, x23
    mov w3, #0
    bl LGscan
    mov x0, x21
    mov x1, x23
    bl LGgeometry
    cbz w0, LGglyph_done
    // The existing glyph material is a sibling, not an image subview.
    stp d0, d1, [sp, #80]
    stp d2, d3, [sp, #96]
    GET x21, LGsuperview
    mov x2, x0
    ldp d0, d1, [sp, #80]
    ldp d2, d3, [sp, #96]
    GET x21, LGconvert_rect
    mov x0, x22
    bl Lpatch + (0x711c - PATCH_BASE)
    mov x0, x22
    bl LGfinish
    b LGglyph_done
LGglyph_control:
    // A getter returning a UIButton must have ONE owned material. Remove the
    // old owner/selector sibling before using the control's surface_key.
    mov x0, x19
    mov x1, x20
    bl Lpatch + (0xa628 - PATCH_BASE)
    mov x22, x0
    cbz x22, LGglyph_control_style
    GET x22, LGremove
    mov x0, x19
    mov x1, x20
    mov x2, #0
    mov w3, #1
    bl Lpatch + (0xa634 - PATCH_BASE)
LGglyph_control_style:
    mov x0, x21
    bl LGstyle_control
    b LGglyph_done
LGglyph_fallback:
    mov x0, x19
    mov x1, x20
    ldp x23, x24, [sp, #48]
    ldp x21, x22, [sp, #32]
    ldp x19, x20, [sp, #16]
    ldp x29, x30, [sp], #160
    b LGglyph_original
LGglyph_done:
    ldp x23, x24, [sp, #48]
    ldp x21, x22, [sp, #32]
    ldp x19, x20, [sp, #16]
    ldp x29, x30, [sp], #160
    ret
LGglyph_original:
    stp d11, d10, [sp, #-96]!
    b Lpatch + (0x7ac8 - PATCH_BASE)

LGstreq:
    cbz x0, LGstreq_no
    cbz x1, LGstreq_no
    mov w10, #64
LGstreq_loop:
    ldrb w8, [x0], #1
    ldrb w9, [x1], #1
    cmp w8, w9
    b.ne LGstreq_no
    cbz w8, LGstreq_yes
    subs w10, w10, #1
    b.ne LGstreq_loop
LGstreq_no:
    mov w0, #0
    ret
LGstreq_yes:
    mov w0, #1
    ret


// FanqieAdBlock 1.5.8: the shelf/profile nested recommendation viewport.
// The exported 1.5.7 log shows its lower edge at y=890 / y=882 while the
// floating bar ends at y=956. Clearing a material cannot create content there.
//
// Public entry points:
//   LFbegin(bar), LFconsider(feed, bar), LFend(bar), LFrestore(bar).
// A bar owns at most one exact FQFeedListCollectionView, only on tab 2 or 3.
// Rows: [feed, NSData(6 doubles), clipRows, immediateParent, outerScroll].
// Scalar data: originalHeight, appliedHeight, originalInsetBottom,
//              appliedInsetBottom, originalWidth, extensionHeight.
// clipRows: [ancestor, NSNumber(originalClipsToBounds)].
// Feed origin, width, top/side insets and content offset are never redesigned.

LFbegin:
    stp x29, x30, [sp, #-32]!
    mov x29, sp
    stp x19, x20, [sp, #16]
    mov x19, x0
    bl Lnewarray
    ASET x19, LFnext_key, x0, 1
    ldp x19, x20, [sp, #16]
    ldp x29, x30, [sp], #32
    ret

LFfind: // array of rows, first-item identity -> row or nil; bounded to 12
    stp x29, x30, [sp, #-64]!
    mov x29, sp
    stp x19, x20, [sp, #16]
    stp x21, x22, [sp, #32]
    stp x23, x24, [sp, #48]
    mov x19, x0
    mov x20, x1
    GET x19, Lcount
    mov x8, #12
    cmp x0, x8
    csel x21, x0, x8, lo
    mov x22, #0
LFfind_loop:
    cmp x22, x21
    b.hs LFfind_no
    mov x2, x22
    GET x19, Lobject_at
    mov x23, x0
    mov x2, #0
    GET x23, Lobject_at
    cmp x0, x20
    b.eq LFfind_yes
    add x22, x22, #1
    b LFfind_loop
LFfind_no:
    mov x0, #0
    b LFfind_done
LFfind_yes:
    mov x0, x23
LFfind_done:
    ldp x23, x24, [sp, #48]
    ldp x21, x22, [sp, #32]
    ldp x19, x20, [sp, #16]
    ldp x29, x30, [sp], #64
    ret

// CGRect is undefined for nonidentity transforms. This selector returns its
// six-double struct indirectly in x8; bypass Lmessage, which handles HFAs.
LFidentity:
    stp x29, x30, [sp, #-96]!
    mov x29, sp
    stp x19, x20, [sp, #16]
    mov x19, x0
    adr x0, LFtransform
    bl Lpatch + (0xa5a4 - PATCH_BASE)
    mov x1, x0
    mov x0, x19
    add x8, sp, #32
    bl Lpatch + (0xa5d4 - PATCH_BASE)
    ldp d0, d1, [sp, #32]
    ldp d2, d3, [sp, #48]
    ldp d4, d5, [sp, #64]
    fmov d6, #1.0
    fcmp d0, d6
    b.ne LFidentity_no
    fcmp d3, d6
    b.ne LFidentity_no
    fcmp d1, #0.0
    b.ne LFidentity_no
    fcmp d2, #0.0
    b.ne LFidentity_no
    fcmp d4, #0.0
    b.ne LFidentity_no
    fcmp d5, #0.0
    b.ne LFidentity_no
    mov w0, #1
    b LFidentity_done
LFidentity_no:
    mov w0, #0
LFidentity_done:
    ldp x19, x20, [sp, #16]
    ldp x29, x30, [sp], #96
    ret

// Read a view's visible rect in the bar's coordinate system. All relevant
// views must have identity transforms, positive finite dimensions and be
// essentially full width. Returns BOOL, with rect d0..d3 on success.
LFrect: // view, bar -> BOOL and CGRect
    stp x29, x30, [sp, #-80]!
    mov x29, sp
    stp x19, x20, [sp, #16]
    stp d8, d9, [sp, #32]
    mov x19, x0
    mov x20, x1
    bl LFidentity
    cbz w0, LFrect_no
    GET x20, Lbounds
    FINITE d0, LFrect_no
    FINITE d2, LFrect_no
    fcmp d2, #0.0
    b.le LFrect_no
    fmov d8, d0
    fmov d9, d2
    GET x19, Lbounds
    mov x2, x20
    GET x19, Lconvert_rect
    FINITE d0, LFrect_no
    FINITE d1, LFrect_no
    FINITE d2, LFrect_no
    FINITE d3, LFrect_no
    fcmp d3, #0.0
    b.le LFrect_no
    fmov d6, #1.0
    fsub d4, d0, d8
    fabs d4, d4
    fcmp d4, d6
    b.gt LFrect_no
    fsub d4, d2, d9
    fabs d4, d4
    fcmp d4, d6
    b.gt LFrect_no
    mov w0, #1
    b LFrect_done
LFrect_no:
    mov w0, #0
LFrect_done:
    ldp d8, d9, [sp, #32]
    ldp x19, x20, [sp, #16]
    ldp x29, x30, [sp], #80
    ret

LFconsider:
    stp x29, x30, [sp, #-496]!
    mov x29, sp
    stp x19, x20, [sp, #16]
    stp x21, x22, [sp, #32]
    stp x23, x24, [sp, #48]
    stp x25, x26, [sp, #64]
    stp x27, x28, [sp, #80]
    stp d8, d9, [sp, #96]
    stp d10, d11, [sp, #112]
    stp d12, d13, [sp, #128]
    stp d14, d15, [sp, #144]
    mov x19, x0
    mov x20, x1
    cbz x19, LFconsider_no
    cbz x20, LFconsider_no
    mov x0, x19
    bl Lpatch + (0xa664 - PATCH_BASE)
    mov x21, x0
    adr x0, LFfeed_class
    bl Lpatch + (0xa5b0 - PATCH_BASE)
    cbz x0, LFconsider_no
    cmp x0, x21
    b.ne LFconsider_no // Exact class; unrelated/subclassed feeds are excluded.
    AGET x20, LFnext_key
    mov x22, x0
    cbz x22, LFconsider_no
    GET x22, Lcount
    cbnz x0, LFconsider_no // Never overlap ownership of shared clip ancestors.
    GET x20, LSitems
    mov x21, x0
    GET x21, Lcount
    cmp x0, #4
    b.ne LFconsider_no
    GET x20, Lselected_item
    cbz x0, LFconsider_no
    mov x2, x0
    GET x21, LSindex_identical
    sub x0, x0, #2
    cmp x0, #1
    b.hi LFconsider_no
    AGET x20, Lpatch + (0xeb84 - PATCH_BASE)
    mov x1, x0
    mov x0, x20
    bl LXvalid_proxy
    cbz w0, LFconsider_no
    GET x20, Lsuperview
    mov x23, x0
    cbz x23, LFconsider_no
    mov x0, x19
    mov x1, x23
    bl Lvisible_to
    cbz w0, LFconsider_no
    GET x19, Lwindow
    mov x21, x0
    cbz x21, LFconsider_no
    GET x20, Lwindow
    cmp x0, x21
    b.ne LFconsider_no
    mov x0, x20
    bl LFidentity
    cbz w0, LFconsider_no
    GET x20, Lbounds
    FINITE d3, LFconsider_no
    mov w8, #40
    scvtf d4, w8
    fcmp d3, d4
    b.lt LFconsider_no
    mov w8, #120
    scvtf d4, w8
    fcmp d3, d4
    b.gt LFconsider_no
    fmov d8, d3 // bar height
    fadd d9, d1, d3 // target bottom, in bar coordinates
    // The mounted bar must end at the physical window bottom, not at a popup.
    mov x0, x21
    mov x1, x20
    bl LFrect
    cbz w0, LFconsider_no
    fadd d4, d1, d3
    fsub d4, d4, d9
    fabs d4, d4
    fmov d5, #2.0
    fcmp d4, d5
    b.gt LFconsider_no
    mov x0, x19
    mov x1, x20
    bl LFrect
    cbz w0, LFconsider_no
    fmov d10, d1 // current feed top in bar coordinates
    fmov d11, d3
    mov w8, #160
    scvtf d4, w8
    fcmp d11, d4
    b.lt LFconsider_no
    fmov d4, #1.0
    fcmp d10, d4
    b.gt LFconsider_no // An entirely below-bar feed is not the visible feed.
    GET x19, LSframe
    FINITE d0, LFconsider_no
    FINITE d1, LFconsider_no
    FINITE d2, LFconsider_no
    FINITE d3, LFconsider_no
    stp d0, d1, [sp, #160]
    stp d2, d3, [sp, #176]
    fcmp d3, d11
    b.ne LFconsider_no
    fmov d14, d3 // baseline height, possibly normalized below
    GET x19, LFcontent_inset
    FINITE d0, LFconsider_no
    FINITE d1, LFconsider_no
    FINITE d2, LFconsider_no
    FINITE d3, LFconsider_no
    stp d0, d1, [sp, #192]
    stp d2, d3, [sp, #208]
    fmov d15, d2 // baseline bottom inset, possibly normalized below
    AGET x20, LFrecords_key
    mov x1, x19
    bl LFfind
    mov x21, x0
    mov x27, #0 // original clip rows
    cbz x21, LFconsider_baseline
    mov x2, #1
    GET x21, Lobject_at
    add x2, sp, #240
    mov x3, #48
    GET x0, LFget_bytes
    ldr d0, [sp, #272] // previous width
    ldr d1, [sp, #176]
    fcmp d0, d1
    b.ne LFconsider_inset_base
    ldr d0, [sp, #248] // previously applied height
    fcmp d14, d0
    b.ne LFconsider_inset_base
    ldr d14, [sp, #240]
LFconsider_inset_base:
    ldr d0, [sp, #264] // previously applied inset bottom
    fcmp d15, d0
    b.ne LFconsider_old_clips
    ldr d15, [sp, #256]
LFconsider_old_clips:
    mov x2, #2
    GET x21, Lobject_at
    mov x27, x0
LFconsider_baseline:
    GET x19, Lcontent_size
    FINITE d0, LFconsider_no
    FINITE d1, LFconsider_no
    fmov d4, #1.0
    fadd d4, d14, d4
    fcmp d1, d4
    b.le LFconsider_no
    GET x19, Lsuperview
    mov x26, x0
    mov x24, x0
    bl Lnewarray
    mov x25, x0 // intermediate path, excludes the feed and enclosing scroll
    mov x28, #0
LFconsider_parent_loop:
    cbz x24, LFconsider_no
    cmp x24, x23
    b.eq LFconsider_no // No enclosing scroll: never change a root feed.
    cmp x28, #8
    b.hs LFconsider_no
    mov x0, x24
    adr x1, Lscroll_class
    bl Lpatch + (0x7394 - PATCH_BASE)
    cbnz w0, LFconsider_outer
    mov x0, x24
    adr x1, LFcontrol_class
    bl Lpatch + (0x7394 - PATCH_BASE)
    cbnz w0, LFconsider_no
    mov x0, x24
    adr x1, LFweb_class
    bl Lpatch + (0x7394 - PATCH_BASE)
    cbnz w0, LFconsider_no
    mov x0, x24
    adr x1, LFeffect_class
    bl Lpatch + (0x7394 - PATCH_BASE)
    cbnz w0, LFconsider_no
    mov x0, x24
    mov x1, x20
    bl LFrect
    cbz w0, LFconsider_no
    // No small card/rail can be un-clipped by this full-page repair.
    fmov d4, #1.0
    fsub d4, d14, d4
    fcmp d3, d4
    b.lt LFconsider_no
    fmov d4, #1.0
    fadd d4, d10, d4
    fcmp d1, d4
    b.gt LFconsider_no
    GET x24, Llayer
    mov x28, x0
    GET x28, LFmask
    cbnz x0, LFconsider_no
    GET x28, LFcorner_radius
    fcmp d0, #0.0
    b.ne LFconsider_no
    mov x2, x24
    GET x25, LSadd_object
    GET x25, Lcount
    mov x28, x0
    GET x24, Lsuperview
    mov x24, x0
    b LFconsider_parent_loop
LFconsider_outer:
    mov x0, x24
    mov x1, x20
    bl LFrect
    cbz w0, LFconsider_no
    fmov d12, d1 // enclosing viewport top
    fmov d4, #1.0
    fadd d4, d10, d4
    fcmp d12, d4
    b.gt LFconsider_no
    // Only the pinned inner viewport is deficient in the supplied trace.
    // A feed partway down its outer page already renders behind the bar.
    fsub d4, d10, d12
    fabs d4, d4
    fmov d5, #2.0
    fcmp d4, d5
    b.gt LFconsider_no
    fadd d4, d1, d3
    fmov d5, #1.0
    fsub d5, d9, d5
    fcmp d4, d5
    b.lt LFconsider_no // Outer viewport itself must already reach the bottom.
    fsub d13, d9, d12 // desired inner viewport height when pinned at outer top
    fsub d4, d13, d14
    mov w8, #20
    scvtf d5, w8
    fcmp d4, d5
    b.lt LFconsider_no
    mov w8, #120
    scvtf d5, w8
    fcmp d4, d5
    b.gt LFconsider_no
    fsub d5, d4, d8
    fabs d5, d5
    mov w8, #16
    scvtf d6, w8
    fcmp d5, d6
    b.gt LFconsider_no // Missing area must agree with the actual tab-bar height.
    fadd d5, d15, d4
    FINITE d5, LFconsider_no
    str d14, [sp, #240]
    str d13, [sp, #248]
    str d15, [sp, #256]
    str d5, [sp, #264]
    ldr d0, [sp, #176]
    str d0, [sp, #272]
    str d4, [sp, #280]
    // All guards complete before the first host mutation.
    mov x0, x19
    mov x1, x20
    bl LFwatch
    cbz w0, LFconsider_no
    mov x0, x25
    mov x1, x27
    bl LFclips_capture
    mov x28, x0
    mov x0, x27
    mov x1, x28
    bl LFclips_release
    bl Lnewarray
    mov x27, x0
    mov x2, x19
    GET x27, LSadd_object
    adr x0, LSdata_class
    bl Lpatch + (0xa5b0 - PATCH_BASE)
    add x2, sp, #240
    mov x3, #48
    adr x1, LSdata_bytes
    bl Lmessage
    mov x2, x0
    GET x27, LSadd_object
    mov x2, x28
    GET x27, LSadd_object
    mov x2, x26
    GET x27, LSadd_object
    mov x2, x24
    GET x27, LSadd_object
    mov x0, x27
    bl LFbackup_row
    mov x2, x27
    GET x22, LSadd_object // Publish before any synchronous UIKit reentry.
    AGET x19, LFbusy_key
    str x0, [sp, #400]
    ASET x19, LFbusy_key, x19, 0
    mov x0, x27
    bl LFapply_row
    ldr x0, [sp, #400]
    ASET x19, LFbusy_key, x0, 0
    mov w0, #1
    b LFconsider_done
LFconsider_no:
    mov w0, #0
LFconsider_done:
    ldp d14, d15, [sp, #144]
    ldp d12, d13, [sp, #128]
    ldp d10, d11, [sp, #112]
    ldp d8, d9, [sp, #96]
    ldp x27, x28, [sp, #80]
    ldp x25, x26, [sp, #64]
    ldp x23, x24, [sp, #48]
    ldp x21, x22, [sp, #32]
    ldp x19, x20, [sp, #16]
    ldp x29, x30, [sp], #496
    ret

LFclips_capture: // path of views, old clip rows -> new clip rows
    stp x29, x30, [sp, #-80]!
    mov x29, sp
    stp x19, x20, [sp, #16]
    stp x21, x22, [sp, #32]
    stp x23, x24, [sp, #48]
    stp x25, x26, [sp, #64]
    mov x19, x0
    mov x20, x1
    bl Lnewarray
    mov x21, x0
    GET x19, Lcount
    mov x22, x0
    mov x23, #0
LFclips_capture_loop:
    cmp x23, x22
    b.hs LFclips_capture_done
    mov x2, x23
    GET x19, Lobject_at
    mov x24, x0
    mov x1, x24
    mov x0, x20
    bl LFfind
    mov x25, x0
    cbnz x25, LFclips_capture_append
    bl Lnewarray
    mov x25, x0
    mov x2, x24
    GET x25, LSadd_object
    GET x24, LFclips
    and w0, w0, #1
    bl Luint
    mov x2, x0
    GET x25, LSadd_object
LFclips_capture_append:
    mov x2, x25
    GET x21, LSadd_object
    add x23, x23, #1
    b LFclips_capture_loop
LFclips_capture_done:
    mov x0, x21
    ldp x25, x26, [sp, #64]
    ldp x23, x24, [sp, #48]
    ldp x21, x22, [sp, #32]
    ldp x19, x20, [sp, #16]
    ldp x29, x30, [sp], #80
    ret

LFclips_release: // old clip rows, new clip rows (nil restores all)
    stp x29, x30, [sp, #-80]!
    mov x29, sp
    stp x19, x20, [sp, #16]
    stp x21, x22, [sp, #32]
    stp x23, x24, [sp, #48]
    stp x25, x26, [sp, #64]
    mov x19, x0
    mov x20, x1
    GET x19, Lcount
    mov x21, x0
    mov x22, #0
LFclips_release_loop:
    cmp x22, x21
    b.hs LFclips_release_done
    mov x2, x22
    GET x19, Lobject_at
    mov x23, x0
    mov x2, #0
    GET x23, Lobject_at
    mov x24, x0
    mov x1, x24
    mov x0, x20
    bl LFfind
    cbnz x0, LFclips_release_next
    GET x24, LFclips
    cbnz w0, LFclips_release_next // Respect a later host change back to clipping.
    mov x2, #1
    GET x23, Lobject_at
    GET x0, Lbool_value
    cbz w0, LFclips_release_next
    mov w2, #1
    GET x24, LFset_clips
LFclips_release_next:
    add x22, x22, #1
    b LFclips_release_loop
LFclips_release_done:
    ldp x25, x26, [sp, #64]
    ldp x23, x24, [sp, #48]
    ldp x21, x22, [sp, #32]
    ldp x19, x20, [sp, #16]
    ldp x29, x30, [sp], #80
    ret

LFapply_row: // row; no allocation, no full tree walk, no redundant geometry writes
    stp x29, x30, [sp, #-176]!
    mov x29, sp
    stp x19, x20, [sp, #16]
    stp x21, x22, [sp, #32]
    stp x23, x24, [sp, #48]
    stp d8, d9, [sp, #64]
    mov x19, x0
    mov x2, #0
    GET x19, Lobject_at
    mov x20, x0
    GET x20, LFcontent_offset
    fmov d8, d0
    fmov d9, d1
    mov x2, #1
    GET x19, Lobject_at
    add x2, sp, #96
    mov x3, #48
    GET x0, LFget_bytes
    GET x20, LFcontent_inset
    ldr d4, [sp, #120]
    fcmp d2, d4
    b.eq LFapply_frame
    fmov d2, d4
    GET x20, LFset_inset // Grow scrollable padding before increasing viewport.
LFapply_frame:
    GET x20, LSframe
    ldr d4, [sp, #104]
    fcmp d3, d4
    b.eq LFapply_clips
    fmov d3, d4
    GET x20, LFset_frame
LFapply_clips:
    mov x2, #2
    GET x19, Lobject_at
    mov x21, x0
    GET x21, Lcount
    mov x22, x0
    mov x23, #0
LFapply_clips_loop:
    cmp x23, x22
    b.hs LFapply_offset
    mov x2, x23
    GET x21, Lobject_at
    mov x2, #0
    GET x0, Lobject_at
    mov x24, x0
    GET x24, LFclips
    cbz w0, LFapply_clips_next
    mov w2, #0
    GET x24, LFset_clips
LFapply_clips_next:
    add x23, x23, #1
    b LFapply_clips_loop
LFapply_offset:
    GET x20, LFcontent_offset
    fcmp d0, d8
    b.ne LFapply_offset_write
    fcmp d1, d9
    b.eq LFapply_done
LFapply_offset_write:
    fmov d0, d8
    fmov d1, d9
    GET x20, LFset_offset
LFapply_done:
    ldp d8, d9, [sp, #64]
    ldp x23, x24, [sp, #48]
    ldp x21, x22, [sp, #32]
    ldp x19, x20, [sp, #16]
    ldp x29, x30, [sp], #176
    ret

LFrestore_row: // row, expected bar; never overwrite a new owner's state
    stp x29, x30, [sp, #-160]!
    mov x29, sp
    stp x19, x20, [sp, #16]
    stp x21, x22, [sp, #32]
    stp d8, d9, [sp, #48]
    mov x19, x0
    mov x21, x1
    mov x2, #0
    GET x19, Lobject_at
    mov x20, x0
    AGET x20, LFowner_key
    GET x0, LXany_object
    cbz x0, LFrestore_row_owned
    cmp x0, x21
    b.ne LFrestore_row_done
LFrestore_row_owned:
    AGET x20, LFbusy_key
    str x0, [sp, #136]
    ASET x20, LFbusy_key, x20, 0
    GET x20, LFcontent_offset
    fmov d8, d0
    fmov d9, d1
    mov x2, #1
    GET x19, Lobject_at
    add x2, sp, #80
    mov x3, #48
    GET x0, LFget_bytes
    GET x20, LSframe
    ldr d4, [sp, #112]
    fcmp d2, d4
    b.ne LFrestore_inset
    ldr d4, [sp, #88]
    fcmp d3, d4
    b.ne LFrestore_inset
    ldr d3, [sp, #80]
    GET x20, LFset_frame // Shrink viewport before removing corresponding padding.
LFrestore_inset:
    GET x20, LFcontent_inset
    ldr d4, [sp, #104]
    fcmp d2, d4
    b.ne LFrestore_clips
    ldr d2, [sp, #96]
    GET x20, LFset_inset
LFrestore_clips:
    mov x2, #2
    GET x19, Lobject_at
    mov x1, #0
    bl LFclips_release
    GET x20, LFcontent_offset
    fcmp d0, d8
    b.ne LFrestore_offset
    fcmp d1, d9
    b.eq LFrestore_row_unbusy
LFrestore_offset:
    fmov d0, d8
    fmov d1, d9
    GET x20, LFset_offset
LFrestore_row_unbusy:
    ASET x20, LForphan_key, xzr, 0
    ldr x0, [sp, #136]
    ASET x20, LFbusy_key, x0, 0
LFrestore_row_done:
    ldp d8, d9, [sp, #48]
    ldp x21, x22, [sp, #32]
    ldp x19, x20, [sp, #16]
    ldp x29, x30, [sp], #160
    ret

LFend:
    stp x29, x30, [sp, #-80]!
    mov x29, sp
    stp x19, x20, [sp, #16]
    stp x21, x22, [sp, #32]
    stp x23, x24, [sp, #48]
    mov x19, x0
    AGET x19, LFnext_key
    GET x0, Lretain
    mov x20, x0
    cbz x20, LFend_done
    AGET x19, LFrecords_key
    GET x0, Lretain
    mov x21, x0
    ASET x19, LFrecords_key, x20, 1
    ASET x19, LFnext_key, xzr, 0
    GET x21, Lcount
    mov x22, x0
    mov x23, #0
LFend_loop:
    cmp x23, x22
    b.hs LFend_release
    mov x2, x23
    GET x21, Lobject_at
    mov x24, x0
    mov x2, #0
    GET x24, Lobject_at
    mov x1, x0
    mov x0, x20
    bl LFfind
    cbnz x0, LFend_next
    mov x0, x24
    mov x1, x19
    bl LFrestore_row
LFend_next:
    add x23, x23, #1
    b LFend_loop
LFend_release:
    GET x21, Lrelease
    GET x20, Lrelease
LFend_done:
    ldp x23, x24, [sp, #48]
    ldp x21, x22, [sp, #32]
    ldp x19, x20, [sp, #16]
    ldp x29, x30, [sp], #80
    ret

LFrestore:
    stp x29, x30, [sp, #-32]!
    mov x29, sp
    stp x19, x20, [sp, #16]
    mov x19, x0
    cbz x19, LFrestore_done
    bl LFbegin
    mov x0, x19
    bl LFend
    ASET x19, LFrecords_key, xzr, 0
    mov x0, x19
    bl LFunwatch
LFrestore_done:
    ldp x19, x20, [sp, #16]
    ldp x29, x30, [sp], #32
    ret

// Install only this exact host class, preserving its real implementation and
// original layoutSubviews selector. Weak ownership permits a previously
// pinned feed to be restored at the header and repaired again when repinned,
// without a full-tree traversal or a 250ms/1s retry delay.
LFwatch: // feed, bar -> BOOL
    stp x29, x30, [sp, #-80]!
    mov x29, sp
    stp x19, x20, [sp, #16]
    stp x21, x22, [sp, #32]
    stp x23, x24, [sp, #48]
    stp x25, x26, [sp, #64]
    mov x19, x0
    mov x20, x1
    AGET x19, LFowner_key
    mov x22, x0
    GET x22, LXany_object
    cbz x0, LFwatch_class
    cmp x0, x20
    b.ne LFwatch_no
LFwatch_class:
    mov x0, x19
    bl Lpatch + (0xa664 - PATCH_BASE)
    mov x21, x0
    mov x0, x21
    adr x1, Llayout_sel
    adr x2, LFlayout_alias
    adr x3, LFfeed_layout
    adr x4, Lvoid_encoding
    bl Linstall_method
    adr x0, Llayout_sel
    bl Lpatch + (0xa5a4 - PATCH_BASE)
    mov x1, x0
    mov x0, x21
    bl Lpatch + (0xa5f8 - PATCH_BASE)
    cbz x0, LFwatch_no
    bl Lpatch + (0xa598 - PATCH_BASE)
    adr x8, LFfeed_layout
    cmp x0, x8
    b.ne LFwatch_no
    adr x0, LFlayout_alias
    bl Lpatch + (0xa5a4 - PATCH_BASE)
    mov x1, x0
    mov x0, x21
    bl Lpatch + (0xa5f8 - PATCH_BASE)
    cbz x0, LFwatch_no
    bl Lpatch + (0xa598 - PATCH_BASE)
    cbz x0, LFwatch_no
    adr x8, LFfeed_layout
    cmp x0, x8
    b.eq LFwatch_no
    mov x23, x0
    AGET x21, LFimp_key
    cbnz x0, LFwatch_owner
    mov x0, x23
    bl Luint
    ASET x21, LFimp_key, x0, 1
LFwatch_owner:
    cbnz x22, LFwatch_have_box
    adr x0, LShash_class
    adr x1, LSweak_hash
    bl Lfactory
    mov x22, x0
    cbz x22, LFwatch_no
LFwatch_have_box:
    mov x2, x20
    GET x22, LSadd_object
    ASET x19, LFowner_key, x22, 1
    AGET x20, LFwatched_key
    mov x23, x0
    cbnz x23, LFwatch_have_set
    adr x0, LShash_class
    adr x1, LSweak_hash
    bl Lfactory
    mov x23, x0
    cbz x23, LFwatch_no
    ASET x20, LFwatched_key, x23, 1
LFwatch_have_set:
    mov x2, x19
    GET x23, LSadd_object
    mov w0, #1
    b LFwatch_done
LFwatch_no:
    mov w0, #0
LFwatch_done:
    ldp x25, x26, [sp, #64]
    ldp x23, x24, [sp, #48]
    ldp x21, x22, [sp, #32]
    ldp x19, x20, [sp, #16]
    ldp x29, x30, [sp], #80
    ret

LFunwatch: // bar; observer table is weak in both directions
    stp x29, x30, [sp, #-64]!
    mov x29, sp
    stp x19, x20, [sp, #16]
    stp x21, x22, [sp, #32]
    stp x23, x24, [sp, #48]
    mov x19, x0
    AGET x19, LFwatched_key
    GET x0, LSall_objects
    mov x20, x0
    GET x20, Lcount
    mov x21, x0
    mov x22, #0
    ASET x19, LFwatched_key, xzr, 0
LFunwatch_loop:
    cmp x22, x21
    b.hs LFunwatch_done
    mov x2, x22
    GET x20, Lobject_at
    mov x23, x0
    AGET x23, LFowner_key
    GET x0, LXany_object
    cmp x0, x19
    b.ne LFunwatch_next
    ASET x23, LFowner_key, xzr, 0
LFunwatch_next:
    add x22, x22, #1
    b LFunwatch_loop
LFunwatch_done:
    ldp x23, x24, [sp, #48]
    ldp x21, x22, [sp, #32]
    ldp x19, x20, [sp, #16]
    ldp x29, x30, [sp], #64
    ret

LFfeed_layout: // self, original _cmd
    stp x29, x30, [sp, #-80]!
    mov x29, sp
    stp x19, x20, [sp, #16]
    stp x21, x22, [sp, #32]
    stp x23, x24, [sp, #48]
    mov x19, x0
    mov x20, x1
    AGET x19, LFbusy_key
    cbnz x0, LFfeed_original_only
    ASET x19, LFbusy_key, x19, 0
    mov x0, x19
    mov x1, x20
    bl LFfeed_original
    AGET x19, LFowner_key
    GET x0, LXany_object
    GET x0, Lretain
    mov x21, x0
    cbnz x21, LFfeed_owner_alive
    mov x0, x19
    bl LFrestore_orphan
    b LFfeed_unbusy
LFfeed_owner_alive:
    AGET x21, Lbusy_key
    cbnz x0, LFfeed_release
    AGET x21, LFnext_key
    cbnz x0, LFfeed_release
    // An old invisible page must not evict the active page's feed record.
    AGET x21, LFrecords_key
    mov x22, x0
    GET x22, Lcount
    cbz x0, LFfeed_refresh
    mov x0, x22
    mov x1, x19
    bl LFfind
    cbz x0, LFfeed_release
LFfeed_refresh:
    ASET x21, Lbusy_key, x21, 0
    mov x0, x21
    bl LFbegin
    mov x0, x19
    mov x1, x21
    bl LFconsider
    mov x0, x21
    bl LFend
    ASET x21, Lbusy_key, xzr, 0
LFfeed_release:
    GET x21, Lrelease
LFfeed_unbusy:
    ASET x19, LFbusy_key, xzr, 0
    b LFfeed_done
LFfeed_original_only:
    mov x0, x19
    mov x1, x20
    bl LFfeed_original
LFfeed_done:
    ldp x23, x24, [sp, #48]
    ldp x21, x22, [sp, #32]
    ldp x19, x20, [sp, #16]
    ldp x29, x30, [sp], #80
    ret

LFfeed_original: // call saved IMP with unchanged self and original _cmd
    stp x29, x30, [sp, #-48]!
    mov x29, sp
    stp x19, x20, [sp, #16]
    stp x21, x22, [sp, #32]
    mov x19, x0
    mov x20, x1
    bl Lpatch + (0xa664 - PATCH_BASE)
    mov x21, x0
    adr x0, LFlayout_alias
    bl Lpatch + (0xa5a4 - PATCH_BASE)
    mov x1, x0
    mov x0, x21
    bl Lpatch + (0xa5f8 - PATCH_BASE)
    cbz x0, LFfeed_original_fallback
    bl Lpatch + (0xa598 - PATCH_BASE)
    cbz x0, LFfeed_original_fallback
    adr x8, LFfeed_layout
    cmp x0, x8
    b.ne LFfeed_original_call
LFfeed_original_fallback:
    adr x0, LFfeed_class
    bl Lpatch + (0xa5b0 - PATCH_BASE)
    AGET x0, LFimp_key
    GET x0, LXunsigned
    cbz x0, LFfeed_original_done
    adr x8, LFfeed_layout
    cmp x0, x8
    b.eq LFfeed_original_done
LFfeed_original_call:
    mov x16, x0
    mov x0, x19
    mov x1, x20
    ldp x21, x22, [sp, #32]
    ldp x19, x20, [sp, #16]
    ldp x29, x30, [sp], #48
    br x16
LFfeed_original_done:
    ldp x21, x22, [sp, #32]
    ldp x19, x20, [sp, #16]
    ldp x29, x30, [sp], #48
    ret

// A bar may disappear while the host retains its feed. Store only scalars
// and individually weak ancestor boxes on the feed, never a row retaining
// the feed or its parents. This permits restoration after weak-owner loss.
// Unchanged layouts reuse this snapshot without allocating another weak tree.
LFbackup_row:
    stp x29, x30, [sp, #-96]!
    mov x29, sp
    stp x19, x20, [sp, #16]
    stp x21, x22, [sp, #32]
    stp x23, x24, [sp, #48]
    stp x25, x26, [sp, #64]
    stp x27, x28, [sp, #80]
    mov x19, x0
    mov x2, #0
    GET x19, Lobject_at
    mov x20, x0
    mov x2, #1
    GET x19, Lobject_at
    mov x21, x0
    mov x2, #2
    GET x19, Lobject_at
    mov x22, x0
    AGET x20, LForphan_key
    mov x23, x0
    cbz x23, LFbackup_new
    mov x2, #0
    GET x23, Lobject_at
    mov x2, x21
    GET x0, LSequal_data
    cbz w0, LFbackup_new
    mov x2, #1
    GET x23, Lobject_at
    mov x24, x0
    GET x24, Lcount
    mov x25, x0
    GET x22, Lcount
    cmp x0, x25
    b.ne LFbackup_new
    mov x26, #0
LFbackup_match_loop:
    cmp x26, x25
    b.hs LFbackup_done
    mov x2, x26
    GET x24, Lobject_at
    mov x2, #0
    GET x0, Lobject_at
    GET x0, LXany_object
    mov x27, x0
    mov x2, x26
    GET x22, Lobject_at
    mov x2, #0
    GET x0, Lobject_at
    cmp x0, x27
    b.ne LFbackup_new
    add x26, x26, #1
    b LFbackup_match_loop
LFbackup_new:
    bl Lnewarray
    mov x23, x0
    mov x2, x21
    GET x23, LSadd_object
    bl Lnewarray
    mov x24, x0
    GET x22, Lcount
    mov x25, x0
    mov x26, #0
LFbackup_new_loop:
    cmp x26, x25
    b.hs LFbackup_publish
    mov x2, x26
    GET x22, Lobject_at
    mov x27, x0
    bl Lnewarray
    mov x28, x0
    adr x0, LShash_class
    adr x1, LSweak_hash
    bl Lfactory
    mov x21, x0
    mov x2, #0
    GET x27, Lobject_at
    mov x2, x0
    GET x21, LSadd_object
    mov x2, x21
    GET x28, LSadd_object
    mov x2, #1
    GET x27, Lobject_at
    mov x2, x0
    GET x28, LSadd_object
    mov x2, x28
    GET x24, LSadd_object
    add x26, x26, #1
    b LFbackup_new_loop
LFbackup_publish:
    mov x2, x24
    GET x23, LSadd_object
    ASET x20, LForphan_key, x23, 1
LFbackup_done:
    ldp x27, x28, [sp, #80]
    ldp x25, x26, [sp, #64]
    ldp x23, x24, [sp, #48]
    ldp x21, x22, [sp, #32]
    ldp x19, x20, [sp, #16]
    ldp x29, x30, [sp], #96
    ret

LFrestore_orphan: // feed whose weak owner has become nil
    stp x29, x30, [sp, #-96]!
    mov x29, sp
    stp x19, x20, [sp, #16]
    stp x21, x22, [sp, #32]
    stp x23, x24, [sp, #48]
    stp x25, x26, [sp, #64]
    stp x27, x28, [sp, #80]
    mov x19, x0
    AGET x19, LFowner_key
    GET x0, LXany_object
    cbnz x0, LForphan_done
    AGET x19, LForphan_key
    GET x0, Lretain
    mov x20, x0
    cbz x20, LForphan_clear_owner
    ASET x19, LForphan_key, xzr, 0
    bl Lnewarray
    mov x21, x0
    mov x2, x19
    GET x21, LSadd_object
    mov x2, #0
    GET x20, Lobject_at
    mov x2, x0
    GET x21, LSadd_object
    bl Lnewarray
    mov x22, x0
    mov x2, #1
    GET x20, Lobject_at
    mov x23, x0
    GET x23, Lcount
    mov x24, x0
    mov x25, #0
LForphan_loop:
    cmp x25, x24
    b.hs LForphan_apply
    mov x2, x25
    GET x23, Lobject_at
    mov x26, x0
    mov x2, #0
    GET x26, Lobject_at
    GET x0, LXany_object
    mov x27, x0
    cbz x27, LForphan_next
    bl Lnewarray
    mov x28, x0
    mov x2, x27
    GET x28, LSadd_object
    mov x2, #1
    GET x26, Lobject_at
    mov x2, x0
    GET x28, LSadd_object
    mov x2, x28
    GET x22, LSadd_object
LForphan_next:
    add x25, x25, #1
    b LForphan_loop
LForphan_apply:
    mov x2, x22
    GET x21, LSadd_object
    mov x0, x21
    mov x1, #0
    bl LFrestore_row
    GET x20, Lrelease
LForphan_clear_owner:
    ASET x19, LFowner_key, xzr, 0
LForphan_done:
    ldp x27, x28, [sp, #80]
    ldp x25, x26, [sp, #64]
    ldp x23, x24, [sp, #48]
    ldp x21, x22, [sp, #32]
    ldp x19, x20, [sp, #16]
    ldp x29, x30, [sp], #96
    ret


// Reader-only settled layout, bounded traversal, and a scoped back glyph.
// Entry patch: 0x5d50 (after the real reader layout returned) -> LRreader_panel.
// No host touch method, control frame, target/action, or accessibility value
// is changed. Decorations always remain noninteractive.

LRresponds: // receiver, selector CString -> BOOL
    stp x29, x30, [sp, #-32]!
    mov x29, sp
    stp x19, x20, [sp, #16]
    mov x19, x0
    mov x0, x1
    bl Lpatch + (0xa5a4 - PATCH_BASE)
    mov x2, x0
    GET x19, LGresponds
    ldp x19, x20, [sp, #16]
    ldp x29, x30, [sp], #32
    ret

LRenabled:
    stp x29, x30, [sp, #-16]!
    mov x29, sp
    adr x0, LRdefaults_class
    adr x1, LRstandard_defaults
    bl Lfactory
    adr x2, Lpatch + (0x11318 - PATCH_BASE) // original GlassDisabled key
    adr x1, LRinteger_key
    bl Lmessage
    cmp x0, #0
    cset w0, eq
    ldp x29, x30, [sp], #16
    ret

LRbelongs: // view, expected ancestor -> BOOL; bounded and cycle-safe
    stp x29, x30, [sp, #-48]!
    mov x29, sp
    stp x19, x20, [sp, #16]
    stp x21, x22, [sp, #32]
    mov x19, x0
    mov x20, x1
    mov w21, #7
LRbelongs_loop:
    cbz x19, LRbelongs_no
    cbz x20, LRbelongs_no
    cmp x19, x20
    b.eq LRbelongs_yes
    subs w21, w21, #1
    b.eq LRbelongs_no
    GET x19, LGsuperview
    mov x19, x0
    b LRbelongs_loop
LRbelongs_yes:
    mov w0, #1
    b LRbelongs_done
LRbelongs_no:
    mov w0, #0
LRbelongs_done:
    ldp x21, x22, [sp, #32]
    ldp x19, x20, [sp, #16]
    ldp x29, x30, [sp], #48
    ret

LRweak_box: // object -> autoreleased weak box
    stp x29, x30, [sp, #-32]!
    mov x29, sp
    stp x19, x20, [sp, #16]
    mov x19, x0
    adr x0, LShash_class
    adr x1, LSweak_hash
    bl Lfactory
    mov x20, x0
    cbz x19, LRweak_done
    mov x2, x19
    GET x20, LSadd_object
LRweak_done:
    mov x0, x20
    ldp x19, x20, [sp, #16]
    ldp x29, x30, [sp], #32
    ret

// Restore each property only while it still has the value installed here.
// A host image replacement wins and is never overwritten by an old snapshot.
// The image view's frame, gestures, actions, and accessibility were never set.
LRback_restore: // UIImageView
    stp x29, x30, [sp, #-64]!
    mov x29, sp
    stp x19, x20, [sp, #16]
    stp x21, x22, [sp, #32]
    stp x23, x24, [sp, #48]
    mov x19, x0
    cbz x19, LRrestore_done
    GET x19, Lretain
    AGET x19, LRback_owned_key
    mov x20, x0
    cbnz x20, LRrestore_image
    AGET x19, LRback_blocked_key
    cbz x0, LRrestore_release
    b LRrestore_clear
LRrestore_image:
    GET x19, LGimage
    cmp x0, x20
    b.ne LRrestore_mode
    AGET x19, LRback_original_key
    mov x2, x0
    GET x19, LRset_image
LRrestore_mode:
    AGET x19, LRback_mode_key
    mov x21, x0
    cbz x21, LRrestore_clear
    GET x19, LGcontent_mode
    cmp x0, #4
    b.ne LRrestore_clear
    GET x21, LRunsigned
    mov x2, x0
    GET x19, LRset_mode
LRrestore_clear:
    ASET x19, LRback_owned_key, xzr, 0
    ASET x19, LRback_original_key, xzr, 0
    ASET x19, LRback_mode_key, xzr, 0
    ASET x19, LRback_owner_key, xzr, 0
    ASET x19, LRback_blocked_key, xzr, 0
LRrestore_release:
    GET x19, Lrelease
LRrestore_done:
    ldp x23, x24, [sp, #48]
    ldp x21, x22, [sp, #32]
    ldp x19, x20, [sp, #16]
    ldp x29, x30, [sp], #64
    ret

// Called only for an actual UIImageView returned by leftBackIconView on an
// already-scoped reader owner. This does not guess at arbitrary left controls.
LRback_prepare: // image view, scoped reader owner
    stp x29, x30, [sp, #-96]!
    mov x29, sp
    stp x19, x20, [sp, #16]
    stp x21, x22, [sp, #32]
    stp x23, x24, [sp, #48]
    stp x25, x26, [sp, #64]
    stp d8, d9, [sp, #80]
    mov x19, x0
    mov x20, x1
    cbz x19, LRprepare_done
    cbz x20, LRprepare_restore
    // The glyph replacement has a lifecycle hook only on this exact reader
    // family. Story bars share the geometry helper but retain their artwork.
    mov x0, x20
    adr x1, LGreader_nav
    bl Lpatch + (0x7394 - PATCH_BASE)
    cbz w0, LRprepare_restore
    mov x0, x19
    mov x1, x20
    bl LRbelongs
    cbz w0, LRprepare_restore
    bl LRenabled
    cbz w0, LRprepare_restore
    // Release a previous getter result when the host replaces this glyph.
    AGET x20, LRowner_back_key
    GET x0, LXany_object
    cbz x0, LRprepare_image
    cmp x0, x19
    b.eq LRprepare_image
    mov x26, x0
    AGET x26, LRback_owner_key
    GET x0, LXany_object
    cmp x0, x20
    b.ne LRprepare_image
    mov x0, x26
    bl LRback_restore
LRprepare_image:
    GET x19, LGimage
    mov x21, x0
    cbz x21, LRprepare_restore
    AGET x19, LRback_owned_key
    mov x22, x0
    cbz x22, LRprepare_new
    AGET x19, LRback_owner_key
    GET x0, LXany_object
    cmp x0, x20
    b.eq LRprepare_owned
    // A reused image view has left its old reader; restore the old epoch
    // before adopting it for a new explicitly identified reader owner.
    mov x0, x19
    bl LRback_restore
    GET x19, LGimage
    mov x21, x0
    cbz x21, LRprepare_done
    b LRprepare_new
LRprepare_owned:
    cmp x21, x22
    b.eq LRprepare_done
    // Host changed the icon. Relinquish ownership and do not fight this image
    // again on the next layout. Another genuinely new image can be considered.
    mov x0, x19
    bl LRback_restore
    ASET x19, LRback_blocked_key, x21, 1
    b LRprepare_done
LRprepare_new:
    AGET x19, LRback_blocked_key
    cmp x0, x21
    b.eq LRprepare_done
    // A public alignment rectangle can supply the real drawing envelope
    // without changing a host image. Prefer it when it has useful insets.
    mov x0, x21
    adr x1, LRalignment
    bl LRresponds
    cbz w0, LRprepare_symbol
    GET x21, LRalignment
    FINITE d0, LRprepare_symbol
    FINITE d1, LRprepare_symbol
    FINITE d2, LRprepare_symbol
    FINITE d3, LRprepare_symbol
    fcmp d0, #0.0
    b.lt LRprepare_symbol
    fcmp d1, #0.0
    b.lt LRprepare_symbol
    fcmp d2, #0.0
    b.lt LRprepare_symbol
    fcmp d3, #0.0
    b.lt LRprepare_symbol
    fadd d8, d1, d3
    fadd d9, d0, d2
    fadd d0, d8, d9
    fcmp d0, #0.0
    b.le LRprepare_symbol
    GET x21, LGsize
    FINITE d0, LRprepare_symbol
    FINITE d1, LRprepare_symbol
    fcmp d0, d8
    b.le LRprepare_symbol
    fcmp d1, d9
    b.gt LRprepare_done
LRprepare_symbol:
    // Use explicit public symbol sizing. A missing configuration/factory
    // preserves the original artwork instead of falling back to a tiny icon.
    GET x21, LGsize
    fmov d8, #22.0
    FINITE d1, LRprepare_configuration
    fmov d0, #20.0
    fmax d8, d1, d0
    fmov d0, #24.0
    fmin d8, d8, d0
LRprepare_configuration:
    adr x0, LRsymbol_configuration
    bl Lpatch + (0xa5b0 - PATCH_BASE)
    mov x22, x0
    cbz x22, LRprepare_done
    adr x1, LRpoint_configuration
    bl LRresponds
    cbz w0, LRprepare_done
    fmov d0, d8
    GET x22, LRpoint_configuration
    mov x24, x0
    cbz x24, LRprepare_done
    adr x0, LGimage_resource_class
    bl Lpatch + (0xa5b0 - PATCH_BASE)
    mov x22, x0
    cbz x22, LRprepare_done
    adr x1, LRsystem_image
    bl LRresponds
    cbz w0, LRprepare_done
    adr x0, LRback_symbol
    bl Lstr
    mov x2, x0
    mov x3, x24
    GET x22, LRsystem_image
    mov x23, x0
    cbz x23, LRprepare_done
    // All snapshots are retained associations. There is no owner/image cycle:
    // both directions use NSHashTable weak objects.
    GET x19, LGcontent_mode
    bl Luint
    mov x24, x0
    mov x0, x20
    bl LRweak_box
    mov x25, x0
    mov x0, x19
    bl LRweak_box
    mov x26, x0
    ASET x19, LRback_original_key, x21, 1
    ASET x19, LRback_owned_key, x23, 1
    ASET x19, LRback_mode_key, x24, 1
    ASET x19, LRback_owner_key, x25, 1
    ASET x20, LRowner_back_key, x26, 1
    ASET x19, LRback_blocked_key, xzr, 0
    mov x2, x23
    GET x19, LRset_image
    mov x2, #4 // UIViewContentModeCenter; button and image frames are untouched.
    GET x19, LRset_mode
    b LRprepare_done
LRprepare_restore:
    mov x0, x19
    bl LRback_restore
LRprepare_done:
    ldp d8, d9, [sp, #80]
    ldp x25, x26, [sp, #64]
    ldp x23, x24, [sp, #48]
    ldp x21, x22, [sp, #32]
    ldp x19, x20, [sp, #16]
    ldp x29, x30, [sp], #96
    ret

// Map public UIImage alignment insets into an already-computed draw rect.
// Invalid/negative/exhausted insets fail closed to the unchanged rectangle.
LRimage_alignment: // UIImage, CGRect d0..d3 -> CGRect d0..d3
    stp x29, x30, [sp, #-112]!
    mov x29, sp
    stp x19, x20, [sp, #16]
    stp d8, d9, [sp, #32]
    stp d10, d11, [sp, #48]
    stp d12, d13, [sp, #64]
    stp d14, d15, [sp, #80]
    mov x19, x0
    fmov d8, d0
    fmov d9, d1
    fmov d10, d2
    fmov d11, d3
    adr x1, LRalignment
    bl LRresponds
    cbz w0, LRalign_done
    GET x19, LRalignment
    FINITE d0, LRalign_done
    FINITE d1, LRalign_done
    FINITE d2, LRalign_done
    FINITE d3, LRalign_done
    fcmp d0, #0.0
    b.lt LRalign_done
    fcmp d1, #0.0
    b.lt LRalign_done
    fcmp d2, #0.0
    b.lt LRalign_done
    fcmp d3, #0.0
    b.lt LRalign_done
    fmov d12, d0
    fmov d13, d1
    fmov d14, d2
    fmov d15, d3
    GET x19, LGsize
    FINITE d0, LRalign_done
    FINITE d1, LRalign_done
    fadd d2, d13, d15
    fadd d3, d12, d14
    fcmp d0, d2
    b.le LRalign_done
    fcmp d1, d3
    b.le LRalign_done
    fdiv d4, d10, d0
    fdiv d5, d11, d1
    fmul d13, d13, d4
    fmul d12, d12, d5
    fmul d2, d2, d4
    fmul d3, d3, d5
    fadd d8, d8, d13
    fadd d9, d9, d12
    fsub d10, d10, d2
    fsub d11, d11, d3
LRalign_done:
    fmov d0, d8
    fmov d1, d9
    fmov d2, d10
    fmov d3, d11
    ldp d14, d15, [sp, #80]
    ldp d12, d13, [sp, #64]
    ldp d10, d11, [sp, #48]
    ldp d8, d9, [sp, #32]
    ldp x19, x20, [sp, #16]
    ldp x29, x30, [sp], #112
    ret

// Observe detachment only on the exact host reader navigation class. This
// restores the temporary glyph before a detached reader can reuse its views.
// An inherited UIView method is shadowed on this class, never globally changed.
LRinstall_lifecycle:
    stp x29, x30, [sp, #-32]!
    mov x29, sp
    stp x19, x20, [sp, #16]
    adr x0, LGreader_nav
    bl Lpatch + (0xa5b0 - PATCH_BASE)
    mov x19, x0
    cbz x19, LRinstall_done
    AGET x19, LRlifecycle_key
    cbnz x0, LRinstall_done
    mov x0, x19
    adr x1, Lwindow_sel
    adr x2, LRmoved_alias
    adr x3, LRreader_moved
    adr x4, Lvoid_encoding
    bl Linstall_method
    ASET x19, LRlifecycle_key, x19, 0
LRinstall_done:
    ldp x19, x20, [sp, #16]
    ldp x29, x30, [sp], #32
    ret

LRreader_moved:
    stp x29, x30, [sp, #-32]!
    mov x29, sp
    stp x19, x20, [sp, #16]
    mov x19, x0
    mov x20, x1
    adr x0, LGreader_nav
    adr x1, LRmoved_alias
    bl Lpatch + (0x6274 - PATCH_BASE)
    cbz x0, LRmoved_style
    mov x8, x0
    mov x0, x19
    mov x1, x20
    blr x8
LRmoved_style:
    mov x0, x19
    bl LRreader_panel
    ldp x19, x20, [sp, #16]
    ldp x29, x30, [sp], #32
    ret

LRreader_panel: // self; original host layout has already returned exactly once
    stp x29, x30, [sp, #-80]!
    mov x29, sp
    stp x19, x20, [sp, #16]
    stp x21, x22, [sp, #32]
    stp d8, d9, [sp, #48]
    mov x19, x0
    cbz x19, LRpanel_done
    AGET x19, LRbusy_key
    cbnz x0, LRpanel_done
    ASET x19, LRbusy_key, x19, 0
    bl LRinstall_lifecycle
    bl LDsemantic_time
    fmov d8, d0
    bl LRenabled
    mov w21, w0
    GET x19, LGhidden
    cbnz w0, LRpanel_restore
    GET x19, Lwindow
    cbz x0, LRpanel_restore
    cbz w21, LRpanel_restore
    // Only use the confirmed getter when present; never infer an arrow from
    // arbitrary leftmost controls, and never add a new button or gesture.
    AGET x19, LRowner_back_key
    GET x0, LXany_object
    mov x20, x0
    mov x0, x19
    adr x1, LGback_selector
    bl LRresponds
    cbz w0, LRpanel_missing_back
    GET x19, LGback_selector
    mov x22, x0
    cmp x20, x22
    b.eq LRpanel_style_back
    cbz x20, LRpanel_style_back
    AGET x20, LRback_owner_key
    GET x0, LXany_object
    cmp x0, x19
    b.ne LRpanel_style_back
    mov x0, x20
    bl LRback_restore
    ASET x19, LRowner_back_key, xzr, 0
LRpanel_style_back:
    mov x0, x19
    adr x1, LGback_selector
    bl LGstyle_glyph
    b LRpanel_background
LRpanel_missing_back:
    cbz x20, LRpanel_missing_material
    AGET x20, LRback_owner_key
    GET x0, LXany_object
    cmp x0, x19
    b.ne LRpanel_missing_material
    mov x0, x20
    bl LRback_restore
LRpanel_missing_material:
    ASET x19, LRowner_back_key, xzr, 0
    mov x0, x19
    bl LRremove_back_material
LRpanel_background:
    mov x0, x19
    adr x1, LRbackground_view
    bl LRresponds
    cbz w0, LRpanel_walk
    GET x19, LRbackground_view
    mov x20, x0
    cbz x20, LRpanel_walk
    GET x20, LGbounds
    mov x0, x20
    bl Lpatch + (0x74d0 - PATCH_BASE)
    bl LGfinish
LRpanel_walk:
    mov w8, #64
    str w8, [sp, #64]
    mov x0, x19
    mov w1, #3
    add x2, sp, #64
    mov w3, #1
    bl LRwalk
    mov x0, x19
    ldr w1, [sp, #64]
    fmov d0, d8
    bl LRlayout_observe
    b LRpanel_clear
LRpanel_restore:
    // A standalone back UIImageView has a sibling material keyed by the
    // getter on its owner; it is not a control's surface_key decoration.
    mov x0, x19
    bl LRremove_back_material
LRpanel_restore_image:
    AGET x19, LRowner_back_key
    GET x0, LXany_object
    mov x20, x0
    AGET x20, LRback_owner_key
    GET x0, LXany_object
    cmp x0, x19
    b.ne LRpanel_clear_owner
    mov x0, x20
    bl LRback_restore
LRpanel_clear_owner:
    ASET x19, LRowner_back_key, xzr, 0
    mov w8, #64
    str w8, [sp, #64]
    mov x0, x19
    mov w1, #3
    add x2, sp, #64
    mov w3, #0
    bl LRwalk
LRpanel_clear:
    ASET x19, LRbusy_key, xzr, 0
LRpanel_done:
    ldp d8, d9, [sp, #48]
    ldp x21, x22, [sp, #32]
    ldp x19, x20, [sp, #16]
    ldp x29, x30, [sp], #80
    ret

LRremove_back_material:
    stp x29, x30, [sp, #-32]!
    mov x29, sp
    stp x19, x20, [sp, #16]
    mov x19, x0
    adr x1, LGback_selector
    bl Lpatch + (0xa628 - PATCH_BASE)
    cbz x0, LRremove_back_done
    GET x0, LGremove
    mov x0, x19
    adr x1, LGback_selector
    mov x2, #0
    mov x3, #0
    bl Lpatch + (0xa634 - PATCH_BASE)
LRremove_back_done:
    ldp x19, x20, [sp, #16]
    ldp x29, x30, [sp], #32
    ret

// A shared visit budget bounds the entire tree, not each branch separately.
// Material and scrolling subtrees are leaves. Thus adding a decoration never
// makes the next layout descend through UIKit's internal visual effect tree.
LRwalk: // view, depth, uint32_t *remaining, BOOL apply (false -> cleanup)
    stp x29, x30, [sp, #-80]!
    mov x29, sp
    stp x19, x20, [sp, #16]
    stp x21, x22, [sp, #32]
    stp x23, x24, [sp, #48]
    stp x25, x26, [sp, #64]
    mov x19, x0
    mov w20, w1
    mov x21, x2
    mov w25, w3
    cbz x19, LRwalk_done
    ldr w8, [x21]
    cbz w8, LRwalk_done
    sub w8, w8, #1
    str w8, [x21]
    cbnz w25, LRwalk_visible
    AGET x19, LGsurface_key
    cbz x0, LRwalk_cleanup_image
    GET x0, LGremove
    ASET x19, LGsurface_key, xzr, 0
LRwalk_cleanup_image:
    AGET x19, LRback_owned_key
    cbz x0, LRwalk_kind
    mov x0, x19
    bl LRback_restore
    b LRwalk_kind
LRwalk_visible:
    GET x19, LGhidden
    cbnz w0, LRwalk_done
LRwalk_kind:
    mov x0, x19
    adr x1, LGvisual_class
    bl Lpatch + (0x7394 - PATCH_BASE)
    cbnz w0, LRwalk_done
    mov x0, x19
    adr x1, LRscroll_class
    bl Lpatch + (0x7394 - PATCH_BASE)
    cbnz w0, LRwalk_done
    cbz w25, LRwalk_children
    mov x0, x19
    adr x1, LGcontrol_class
    bl Lpatch + (0x7394 - PATCH_BASE)
    cbz w0, LRwalk_children
    adr x22, LRexcluded_controls
    mov w23, #4
LRwalk_exclude:
    ldr w8, [x22], #4
    adr x1, Lpatch
    add x1, x1, x8
    mov x0, x19
    bl Lpatch + (0x7394 - PATCH_BASE)
    cbnz w0, LRwalk_done
    subs w23, w23, #1
    b.ne LRwalk_exclude
    mov x0, x19
    bl LGstyle_control
    b LRwalk_done
LRwalk_children:
    cbz w20, LRwalk_done
    GET x19, LGsubviews
    mov x22, x0
    GET x22, LGcount
    mov x23, x0
    mov x24, #0
LRwalk_loop:
    cmp x24, x23
    b.hs LRwalk_done
    ldr w8, [x21]
    cbz w8, LRwalk_done
    mov x2, x24
    GET x22, LGobject_at
    sub w1, w20, #1
    mov x2, x21
    mov w3, w25
    bl LRwalk
    add x24, x24, #1
    b LRwalk_loop
LRwalk_done:
    ldp x25, x26, [sp, #64]
    ldp x23, x24, [sp, #48]
    ldp x21, x22, [sp, #32]
    ldp x19, x20, [sp, #16]
    ldp x29, x30, [sp], #80
    ret

// One initial sample plus slow layouts (8ms), rate-limited to one/second.
// This measures only this plugin's post-layout work, not end-to-end tap time.
LRlayout_observe: // owner, remaining visits, start seconds in d0
    stp x29, x30, [sp, #-80]!
    mov x29, sp
    stp x19, x20, [sp, #16]
    stp x21, x22, [sp, #32]
    stp d8, d9, [sp, #48]
    stp d10, d11, [sp, #64]
    mov x19, x0
    mov w20, w1
    fmov d8, d0
    bl LDsemantic_time
    fmov d9, d0
    fsub d8, d9, d8
    ldr d0, LRthousand
    fmul d8, d8, d0
    FINITE d8, LRobserve_done
    fcmp d8, #0.0
    b.lt LRobserve_done
    AGET x19, LRlast_log_key
    cbz x0, LRobserve_record
    fmov d0, #8.0
    fcmp d8, d0
    b.lt LRobserve_done
    adr x1, LIdouble_value
    bl Lmessage
    fsub d0, d9, d0
    fmov d1, #1.0
    fcmp d0, d1
    b.lt LRobserve_done
LRobserve_record:
    fmov d0, d9
    bl Lnumber
    ASET x19, LRlast_log_key, x0, 1
    bl Lnewdict
    mov x21, x0
    fmov d0, d8
    bl Lnumber
    mov x2, x0
    mov x0, x21
    adr x1, LRfield_elapsed
    bl Ldict_set
    mov w0, #64
    sub w0, w0, w20
    bl Luint
    mov x2, x0
    mov x0, x21
    adr x1, LRfield_visited
    bl Ldict_set
    cmp w20, #0
    cset w0, eq
    bl Luint
    mov x2, x0
    mov x0, x21
    adr x1, LRfield_exhausted
    bl Ldict_set
    adr x0, LRlayout_event
    mov x1, x21
    bl Lrecord_named
LRobserve_done:
    ldp d10, d11, [sp, #64]
    ldp d8, d9, [sp, #48]
    ldp x21, x22, [sp, #32]
    ldp x19, x20, [sp, #16]
    ldp x29, x30, [sp], #80
    ret


// 1.5.8: semantic, bounded automatic diagnostic capture.
// Public entry: LDobserve_semantic(bar), called by Ldiagnostic_observe.
// Explicit export/periodic snapshots and the one-hour journal are unchanged.
//
// UIColor/effect allocation identities are deliberately absent. Colors are
// resolved with their view's traits and converted to extended-sRGB components.
// Public effect class/tint/interactivity are sampled; private effect internals
// are not queried. Unconvertible/pattern colors use an explicit unknown marker
// and remain visible in the existing periodic/export snapshot descriptions.
//
// A small critical prefix detects selection, attachment and visible/inactive
// transitions immediately. Remaining layout/color/scroll changes are sampled
// at most every 0.5 seconds, using monotonic uptime. The saved full signature
// always describes the last emitted state, never an unreported interim state.
// The existing common-mode visibility monitor supplies later observations;
// no timer, retained view owner, UIKit snapshot or file IO is added here.

LDobserve_semantic:
    stp x29, x30, [sp, #-512]!
    mov x29, sp
    stp x19, x20, [sp, #16]
    stp x21, x22, [sp, #32]
    stp x23, x24, [sp, #48]
    stp x25, x26, [sp, #64]
    stp x27, x28, [sp, #80]
    stp d8, d9, [sp, #96]
    mov x19, x0
    cbz x19, LDPobserve_done
    adr x0, LSthread_class
    adr x1, LSmain_thread
    bl Lfactory
    cbz w0, LDPobserve_done
    AGET x19, LDsemantic_busy_key
    cbnz x0, LDPobserve_done
    ASET x19, LDsemantic_busy_key, x19, 0

    // 384 bytes, initialized in full so no stack padding enters equality.
    add x8, sp, #128
    mov w9, #24
LDPobserve_zero:
    stp xzr, xzr, [x8]
    add x8, x8, #16
    subs w9, w9, #1
    b.ne LDPobserve_zero

    // Critical signature [0,72): real UI object identities are intentional
    // lifecycle/selection state; color and effect object identities are not.
    mov x0, x19
    adr x1, Lpatch + (0xeb84 - PATCH_BASE)
    bl Lpatch + (0xa628 - PATCH_BASE)
    mov x20, x0
    str x20, [sp, #152]
    GET x19, Lselected_item
    str x0, [sp, #128]
    GET x19, Lwindow
    str x0, [sp, #136]
    GET x19, Lsuperview
    mov x21, x0
    str x21, [sp, #144]
    GET x19, Lis_hidden
    and w0, w0, #1
    str x0, [sp, #168]
    GET x19, Lalpha
    str d0, [sp, #200]
    bl LDsemantic_visible_alpha
    str x0, [sp, #184]
    cbz x20, LDPobserve_critical
    GET x20, Lsuperview
    str x0, [sp, #160]
    GET x20, Lis_hidden
    and w0, w0, #1
    str x0, [sp, #176]
    GET x20, Lalpha
    str d0, [sp, #208]
    bl LDsemantic_visible_alpha
    str x0, [sp, #192]
LDPobserve_critical:
    add x2, sp, #128
    mov x3, #72
    bl LDsemantic_data
    mov x27, x0
    AGET x19, LDsemantic_critical_key
    mov x2, x0
    GET x27, LSequal_data
    eor w28, w0, #1
    bl LDsemantic_time
    fmov d8, d0
    cbnz w28, LDPobserve_sample
    AGET x19, LDsemantic_time_key
    cbz x0, LDPobserve_sample
    GET x0, LDdouble_value
    FINITE d8, LDPobserve_sample
    FINITE d0, LDPobserve_sample
    fsub d0, d8, d0
    fcmp d0, #0.0
    b.lt LDPobserve_sample
    fmov d1, #0.5
    fcmp d0, d1
    b.lt LDPobserve_release

LDPobserve_sample:
    // Save sampling time even when semantically unchanged. This bounds color
    // conversion and scroll traversal as well as full snapshot generation.
    fmov d0, d8
    FINITE d0, LDPobserve_no_time
    bl Lnumber
    ASET x19, LDsemantic_time_key, x0, 1
LDPobserve_no_time:
    GET x21, Lsubviews
    adr x1, Lcount
    bl Lmessage
    str x0, [sp, #216]
    GET x19, Lbounds
    stp d0, d1, [sp, #224]
    stp d2, d3, [sp, #240]
    GET x19, LSframe
    stp d0, d1, [sp, #256]
    stp d2, d3, [sp, #272]
    GET x19, LStraits
    mov x22, x0
    GET x22, LScontrast
    str x0, [sp, #496]
    GET x22, LDsemantic_interface_style
    str x0, [sp, #504]
    GET x19, LSbackground
    mov x1, x22
    add x2, sp, #352
    bl LDsemantic_color
    GET x21, LStraits
    mov x22, x0
    GET x21, LSbackground
    mov x1, x22
    add x2, sp, #392
    bl LDsemantic_color
    cbz x20, LDPobserve_encode
    GET x20, Lbounds
    stp d0, d1, [sp, #288]
    stp d2, d3, [sp, #304]
    GET x20, LSframe
    stp d0, d1, [sp, #320]
    stp d2, d3, [sp, #336]
    GET x20, LSeffect
    mov x24, x0
    GET x24, LSclass
    str x0, [sp, #432]
    mov x0, x24
    adr x1, LSglass_class
    bl Lpatch + (0x7394 - PATCH_BASE)
    cbz w0, LDPobserve_scroll
    GET x24, LSinteractive
    and w0, w0, #1
    str x0, [sp, #440]
    GET x20, LStraits
    mov x22, x0
    GET x24, LStint
    mov x1, x22
    add x2, sp, #448
    bl LDsemantic_color

LDPobserve_scroll:
    // Preserve the existing 128-point scroll buckets and owned/native state.
    AGET x19, Ledge_key
    mov x22, x0
    GET x22, Lcount
    mov x23, x0
    mov x24, #0
    mov x26, #0
LDPobserve_scroll_loop:
    cmp x24, x23
    b.hs LDPobserve_scroll_done
    mov x2, x24
    GET x22, Lobject_at
    mov x2, #0
    GET x0, Lobject_at
    mov x25, x0
    add x26, x26, x26, lsl #5
    eor x26, x26, x25
    GET x25, Lbounds
    FINITE d1, LDPobserve_scroll_next
    mov w8, #128
    scvtf d0, w8
    fdiv d1, d1, d0
    fcvtzs x8, d1
    eor x26, x26, x8
LDPobserve_scroll_next:
    add x24, x24, #1
    b LDPobserve_scroll_loop
LDPobserve_scroll_done:
    mov x0, x19
    mov x1, x26
    bl LXstate_hash
    str x0, [sp, #488]
LDPobserve_encode:
    add x2, sp, #128
    mov x3, #384
    bl LDsemantic_data
    mov x22, x0
    AGET x19, LSsignature_key
    mov x2, x0
    GET x22, LSequal_data
    cbnz w0, LDPobserve_release
    ASET x19, LSsignature_key, x22, 1
    ASET x19, LDsemantic_critical_key, x27, 1
    bl Ltracked_bars
    mov x2, x19
    adr x1, LSadd_object
    bl Lmessage
    mov x0, x19
    adr x1, LSstate_changed
    bl Ldiagnostic_snapshot
LDPobserve_release:
    ASET x19, LDsemantic_busy_key, xzr, 0
LDPobserve_done:
    ldp d8, d9, [sp, #96]
    ldp x27, x28, [sp, #80]
    ldp x25, x26, [sp, #64]
    ldp x23, x24, [sp, #48]
    ldp x21, x22, [sp, #32]
    ldp x19, x20, [sp, #16]
    ldp x29, x30, [sp]
    add sp, sp, #512
    ret

// d0 alpha -> 0 invisible, 1 nonzero, 2 nonfinite (stable invalid state).
LDsemantic_visible_alpha:
    FINITE d0, LDPalpha_invalid
    fcmp d0, #0.0
    cset w0, gt
    ret
LDPalpha_invalid:
    mov w0, #2
    ret

LDsemantic_time:
    stp x29, x30, [sp, #-16]!
    mov x29, sp
    adr x0, LSprocess_class
    adr x1, LSprocess
    bl Lfactory
    adr x1, LDsemantic_uptime
    bl Lmessage
    ldp x29, x30, [sp], #16
    ret

// x2 byte buffer, x3 count -> copied immutable NSData.
LDsemantic_data:
    stp x29, x30, [sp, #-32]!
    mov x29, sp
    stp x2, x3, [sp, #16]
    adr x0, LSdata_class
    bl Lpatch + (0xa5b0 - PATCH_BASE)
    ldp x2, x3, [sp, #16]
    adr x1, LSdata_bytes
    bl Lmessage
    ldp x29, x30, [sp], #32
    ret

// color, traitCollection, writable 40-byte record -> no object identities.
// record: uint64 status (0 nil, 1 extended sRGB, 2 unsupported, 3 invalid),
// then four canonical finite CGFloat values. Preserve negative/extended RGB;
// normalize signed zero and irrelevant RGB when alpha is zero.
LDsemantic_color:
    stp x29, x30, [sp, #-48]!
    mov x29, sp
    stp x19, x20, [sp, #16]
    stp x21, x22, [sp, #32]
    mov x19, x0
    mov x20, x1
    mov x21, x2
    stp xzr, xzr, [x21]
    stp xzr, xzr, [x21, #16]
    str xzr, [x21, #32]
    cbz x19, LDPcolor_done
    cbz x20, LDPcolor_extract
    mov x2, x20
    GET x19, LDsemantic_resolve_color
    mov x19, x0
    cbz x19, LDPcolor_done
LDPcolor_extract:
    add x2, x21, #8
    add x3, x21, #16
    add x4, x21, #24
    add x5, x21, #32
    GET x19, LDsemantic_get_red
    cbnz w0, LDPcolor_canonical
    add x2, x21, #8
    add x3, x21, #32
    GET x19, LDsemantic_get_white
    cbz w0, LDPcolor_unsupported
    ldr d0, [x21, #8]
    stp d0, d0, [x21, #16]
LDPcolor_canonical:
    ldp d0, d1, [x21, #8]
    ldp d2, d3, [x21, #24]
    FINITE d0, LDPcolor_invalid
    FINITE d1, LDPcolor_invalid
    FINITE d2, LDPcolor_invalid
    FINITE d3, LDPcolor_invalid
    fcmp d3, #0.0
    b.ne LDPcolor_red
    fmov d0, xzr
    fmov d1, xzr
    fmov d2, xzr
    fmov d3, xzr
    b LDPcolor_store
LDPcolor_red:
    fcmp d0, #0.0
    b.ne LDPcolor_green
    fmov d0, xzr
LDPcolor_green:
    fcmp d1, #0.0
    b.ne LDPcolor_blue
    fmov d1, xzr
LDPcolor_blue:
    fcmp d2, #0.0
    b.ne LDPcolor_store
    fmov d2, xzr
LDPcolor_store:
    stp d0, d1, [x21, #8]
    stp d2, d3, [x21, #24]
    mov w8, #1
    str x8, [x21]
    b LDPcolor_done
LDPcolor_invalid:
    mov w8, #3
    b LDPcolor_unknown
LDPcolor_unsupported:
    mov w8, #2
LDPcolor_unknown:
    str x8, [x21]
    stp xzr, xzr, [x21, #8]
    stp xzr, xzr, [x21, #24]
LDPcolor_done:
    ldp x21, x22, [sp, #32]
    ldp x19, x20, [sp, #16]
    ldp x29, x30, [sp], #48
    ret


LXcode_end:
    .p2align 3
LXstrings:

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


LXguard_owner_key: .byte 0
LXguard_alias: .asciz "fqab_native157_originalSetHidden:"
LXguard_encoding: .asciz "v20@0:8B16"
LXguard_view_class: .asciz "UIView"


LIcontroller_name:    .asciz "FQABGlassInteraction158"
LIobject_name:        .asciz "NSObject"
LIview_name:          .asciz "UIView"
LIeffect_view_name:   .asciz "UIVisualEffectView"
LIglass_name:         .asciz "UIGlassEffect"
LIpan_name:           .asciz "UIPanGestureRecognizer"
LIcorner_name:        .asciz "UICornerConfiguration"
LInew:               .asciz "new"
LIalloc:             .asciz "alloc"
LIcopy:              .asciz "copy"
LIframe:             .asciz "frame"
LIset_bounds:        .asciz "setBounds:"
LIitems:             .asciz "items"
LIindex_identical:   .asciz "indexOfObjectIdenticalTo:"
LIinit_effect:       .asciz "initWithEffect:"
LIeffect_factory:    .asciz "effectWithStyle:"
LIset_effect:        .asciz "setEffect:"
LIset_interactive:   .asciz "setInteractive:"
LIset_tint:          .asciz "setTintColor:"
LIcapsule:           .asciz "capsuleConfiguration"
LIset_corner:        .asciz "setCornerConfiguration:"
LIset_opaque:        .asciz "setOpaque:"
LIset_interaction:   .asciz "setUserInteractionEnabled:"
LIset_access_hidden: .asciz "setAccessibilityElementsHidden:"
LIadd_subview:       .asciz "addSubview:"
LIremove_from_super: .asciz "removeFromSuperview"
LIadd_gesture:       .asciz "addGestureRecognizer:"
LIremove_gesture:    .asciz "removeGestureRecognizer:"
LIinit_target:       .asciz "initWithTarget:action:"
LIset_delegate:      .asciz "setDelegate:"
LIset_min_touches:   .asciz "setMinimumNumberOfTouches:"
LIset_max_touches:   .asciz "setMaximumNumberOfTouches:"
LIset_cancel_touches:.asciz "setCancelsTouchesInView:"
LIset_delay_began:   .asciz "setDelaysTouchesBegan:"
LIset_delay_ended:   .asciz "setDelaysTouchesEnded:"
LIset_enabled:      .asciz "setEnabled:"
LIview:             .asciz "view"
LIstate:            .asciz "state"
LItouch_count:      .asciz "numberOfTouches"
LIvelocity:         .asciz "velocityInView:"
LIlocation:         .asciz "locationInView:"
LIdouble_value:     .asciz "doubleValue"
LIpan_sel:          .asciz "pan:"
LIshould_sel:       .asciz "gestureRecognizerShouldBegin:"
LIobject_encoding:  .asciz "v24@0:8@16"
LIbool_encoding:    .asciz "B24@0:8@16"
LIoverlay_key:      .byte 0
LIlens_key:         .byte 0
LIcontroller_key:   .byte 0
LIpan_key:          .byte 0
LIdrag_key:         .byte 0
LIstart_item_key:   .byte 0
LIoffset_key:       .byte 0
LIowned_buttons_key:.byte 0
    .p2align 2
LIkeys:
    .ascii "FQ158INT"
    .long LIoverlay_key - Lpatch + PATCH_BASE
    .long LIlens_key - Lpatch + PATCH_BASE
    .long LIcontroller_key - Lpatch + PATCH_BASE
    .long LIpan_key - Lpatch + PATCH_BASE
    .long LIdrag_key - Lpatch + PATCH_BASE
    .long LIstart_item_key - Lpatch + PATCH_BASE
    .long LIoffset_key - Lpatch + PATCH_BASE
    .long LIowned_buttons_key - Lpatch + PATCH_BASE

LIlens_effect_key: .byte 0
LIlens_mode_key: .byte 0
LIcolor_class: .asciz "UIColor"
LIgray_fill: .asciz "secondarySystemFillColor"
LIclear_color: .asciz "clearColor"


.p2align 3
LGscope_table:
    .long LGreader_nav - Lpatch, 1
    .long LGstory_big - Lpatch, 1
    .long LGstory_small - Lpatch, 1
    .long LGreader_download - Lpatch, 1
    .long LGshelf_header - Lpatch, 2
    .long LGshelf_subheader - Lpatch, 2
    .long LGshelf_edit - Lpatch, 2
    .long LGshelf_filter - Lpatch, 2
LGthirty_two: .double 32.0
LGthirty_six: .double 36.0
LGforty: .double 40.0
LGforty_four: .double 44.0
LGmax_control_width: .double 250.0
LGmax_control_height: .double 72.0
LGlabel_class: .asciz "UILabel"
LGimage_class: .asciz "UIImageView"
LGvisual_class: .asciz "UIVisualEffectView"
LGcontrol_class: .asciz "UIControl"
LGalpha: .asciz "alpha"
LGclips: .asciz "clipsToBounds"
LGcount: .asciz "count"
LGobject_at: .asciz "objectAtIndex:"
LGtext: .asciz "text"
LGlength: .asciz "length"
LGfont: .asciz "font"
LGline_height: .asciz "lineHeight"
LGintrinsic_size: .asciz "intrinsicContentSize"
LGtext_alignment: .asciz "textAlignment"
LGdirection: .asciz "effectiveUserInterfaceLayoutDirection"
LGimage: .asciz "image"
LGsize: .asciz "size"
LGcontent_mode: .asciz "contentMode"
LGconvert_rect: .asciz "convertRect:toView:"
LGautoresize: .asciz "setAutoresizingMask:"
LGdisable_touch: .asciz "setUserInteractionEnabled:"
LGhide_accessibility: .asciz "setAccessibilityElementsHidden:"
LGvalue_class: .asciz "NSValue"
LGvalue_size: .asciz "valueWithCGSize:"
LGsize_value: .asciz "CGSizeValue"
LGfinish_size_key: .byte 0
LGcontrol_busy_key: .byte 0


LFrecords_key: .byte 0
LFnext_key: .byte 0
LFowner_key: .byte 0
LFwatched_key: .byte 0
LFbusy_key: .byte 0
LFimp_key: .byte 0
LForphan_key: .byte 0
LFfeed_class: .asciz "FQFeedListCollectionView"
LFcontrol_class: .asciz "UIControl"
LFweb_class: .asciz "WKWebView"
LFeffect_class: .asciz "UIVisualEffectView"
LFtransform: .asciz "transform"
LFget_bytes: .asciz "getBytes:length:"
LFcontent_inset: .asciz "contentInset"
LFset_inset: .asciz "setContentInset:"
LFcontent_offset: .asciz "contentOffset"
LFset_offset: .asciz "setContentOffset:"
LFset_frame: .asciz "setFrame:"
LFclips: .asciz "clipsToBounds"
LFset_clips: .asciz "setClipsToBounds:"
LFmask: .asciz "mask"
LFcorner_radius: .asciz "cornerRadius"
LFlayout_alias: .asciz "fqab_feed158_originalLayout"
.p2align 2


.p2align 3
LRdirectory:
    .ascii "FQ158RDR"
    .long LRreader_panel - Lpatch
    .long LRwalk - Lpatch
    .long LRback_prepare - Lpatch
    .long LRback_restore - Lpatch
    .long LRimage_alignment - Lpatch
    .long LRlayout_observe - Lpatch
    .long LGfinish - Lpatch
    .long LGcontrol_busy_key - Lpatch
    .long LRbusy_key - Lpatch
    .long LRowner_back_key - Lpatch
    .long LRback_owned_key - Lpatch
    .long LRback_original_key - Lpatch
    .long LRback_mode_key - Lpatch
    .long LRlast_log_key - Lpatch
LRthousand: .double 1000.0
LRexcluded_controls:
    .long LRswitch_class - Lpatch, LRslider_class - Lpatch
    .long LRtext_class - Lpatch, LRsegmented_class - Lpatch
LRdefaults_class: .asciz "NSUserDefaults"
LRstandard_defaults: .asciz "standardUserDefaults"
LRinteger_key: .asciz "integerForKey:"
LGimage_resource_class: .asciz "UIImage"
LRsystem_image: .asciz "systemImageNamed:withConfiguration:"
LRsymbol_configuration: .asciz "UIImageSymbolConfiguration"
LRpoint_configuration: .asciz "configurationWithPointSize:"
LRback_symbol: .asciz "chevron.backward"
LRset_image: .asciz "setImage:"
LRset_mode: .asciz "setContentMode:"
LRalignment: .asciz "alignmentRectInsets"
LRunsigned: .asciz "unsignedIntegerValue"
LRbackground_view: .asciz "bgView"
LRscroll_class: .asciz "UIScrollView"
LRswitch_class: .asciz "UISwitch"
LRslider_class: .asciz "UISlider"
LRtext_class: .asciz "UITextField"
LRsegmented_class: .asciz "UISegmentedControl"
LRlayout_event: .asciz "reader_layout"
LRfield_event: .asciz "event"
LRfield_elapsed: .asciz "readerPluginLayoutMs"
LRfield_visited: .asciz "readerVisitedViews"
LRfield_exhausted: .asciz "readerTraversalBudgetExhausted"
LRbusy_key: .byte 0
LRback_owned_key: .byte 0
LRback_original_key: .byte 0
LRback_mode_key: .byte 0
LRback_owner_key: .byte 0
LRback_blocked_key: .byte 0
LRowner_back_key: .byte 0
LRlast_log_key: .byte 0
LRlifecycle_key: .byte 0
LRmoved_alias: .asciz "fqab_158_readerOriginalDidMoveToWindow"
.p2align 2


.p2align 3
LDsemantic_directory:
    .ascii "FQ158DIA"
    .long LDobserve_semantic - Lpatch + PATCH_BASE
    .long LDsemantic_color - Lpatch + PATCH_BASE
    .long LDsemantic_time - Lpatch + PATCH_BASE
    .long LDsemantic_critical_key - Lpatch + PATCH_BASE
    .long LDsemantic_time_key - Lpatch + PATCH_BASE
    .long LDsemantic_busy_key - Lpatch + PATCH_BASE
LDsemantic_critical_key: .byte 0
LDsemantic_time_key: .byte 0
LDsemantic_busy_key: .byte 0
LDsemantic_uptime: .asciz "systemUptime"
LDsemantic_interface_style: .asciz "userInterfaceStyle"
LDsemantic_resolve_color: .asciz "resolvedColorWithTraitCollection:"
LDsemantic_get_red: .asciz "getRed:green:blue:alpha:"
LDsemantic_get_white: .asciz "getWhite:alpha:"
.p2align 2

    .p2align 2
LXend:
