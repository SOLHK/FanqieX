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

// @COMPONENT_DATA
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
