// FanqieX 1.6.2. Applies only to the SHA-256 pinned uploaded 1.5.6.
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
    .long 0x00010602
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
    // Register only known host scroll classes before their first usable
    // layout. Geometry application remains guarded per visible window/bar.
    bl LFlifecycle_install
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
    bl Ledge_update
    mov x0, x19
    mov x1, x20
    bl LXupdate
    // Choose the final material after native selection installation/fallback.
    mov x0, x19
    mov x1, x20
    bl Lmaterial_update
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

// @COMPONENT_CODE

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
// @COMPONENT_DATA
    .p2align 2
Lend:

// Additional independently mapped RX segment. Original TEXT/DATA addresses
// and chained pointer slots stay unchanged; only LINKEDIT moves behind this.
    .org EXT_BASE - PATCH_BASE
Lextension:
    .ascii "FQ162EXT"
    .long 0x10602
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
// @EXTENSION_CODE
LXcode_end:
    .p2align 3
LXstrings:
// @EXTENSION_DATA
    .p2align 2
LXend:
