// One public UISegmentedControl owns the entire bottom selection surface.
// No custom pan, private subview inspection, glass overlay or artwork snapshot.
// The original plugin's buttons remain the only bridge to its selection route.
// All entry points are main-thread; object references crossing callbacks are
// retained locally and controller->bar/proxy/window references are weak boxes.

LNcontroller_class:
    stp x29, x30, [sp, #-32]!
    mov x29, sp
    stp x19, x20, [sp, #16]
    adr x0, LNcontroller_name
    bl Lpatch + (0xa5b0 - PATCH_BASE)
    mov x19, x0
    cbnz x19, LNclass_check
    adr x0, LIobject_name
    bl Lpatch + (0xa5b0 - PATCH_BASE)
    adr x1, LNcontroller_name
    mov x2, #0
    bl Lpatch + (0xa61c - PATCH_BASE)
    mov x19, x0
    cbz x19, LNclass_no
    mov x0, x19
    adr x1, LNchanged_sel
    adr x2, LNvalueChanged
    adr x3, LIobject_encoding
    bl LDadd_method
    mov x0, x19
    bl Lpatch + (0xa610 - PATCH_BASE)
LNclass_check:
    adr x0, LNchanged_sel
    bl Lpatch + (0xa5a4 - PATCH_BASE)
    mov x1, x0
    mov x0, x19
    bl Lpatch + (0xa5f8 - PATCH_BASE)
    cbz x0, LNclass_no
    mov x0, x19
    b LNclass_done
LNclass_no:
    mov x0, #0
LNclass_done:
    ldp x19, x20, [sp, #16]
    ldp x29, x30, [sp], #32
    ret

LNarrays_match: // arrays -> BOOL, identity/order; replacement containers allowed
    stp x29, x30, [sp, #-64]!
    mov x29, sp
    stp x19, x20, [sp, #16]
    stp x21, x22, [sp, #32]
    stp x23, x24, [sp, #48]
    mov x19, x0
    mov x20, x1
    cbz x19, LNarrays_no
    cbz x20, LNarrays_no
    GET x19, Lcount
    mov x21, x0
    sub x8, x21, #1
    cmp x8, #7
    b.hi LNarrays_no
    GET x20, Lcount
    cmp x0, x21
    b.ne LNarrays_no
    mov x22, #0
LNarrays_loop:
    mov x2, x22
    GET x19, Lobject_at
    mov x23, x0
    mov x2, x22
    GET x20, Lobject_at
    cmp x0, x23
    b.ne LNarrays_no
    add x22, x22, #1
    cmp x22, x21
    b.lo LNarrays_loop
    mov w0, #1
    b LNarrays_done
LNarrays_no:
    mov w0, #0
LNarrays_done:
    ldp x23, x24, [sp, #48]
    ldp x21, x22, [sp, #32]
    ldp x19, x20, [sp, #16]
    ldp x29, x30, [sp], #64
    ret

LNowns_button: // button, proxy -> BOOL; never hide a host-adopted control
    stp x29, x30, [sp, #-48]!
    mov x29, sp
    stp x19, x20, [sp, #16]
    stp x21, x22, [sp, #32]
    mov x19, x0
    mov x20, x1
    adr x1, LNbutton_name
    bl Lpatch + (0x7394 - PATCH_BASE)
    cbz w0, LNowns_no
    GET x19, Lsuperview
    mov x21, x0
    cbz x21, LNowns_no
    cmp x21, x20
    b.eq LNowns_yes
    GET x20, Lcontent_view
    cmp x0, x21
    b.eq LNowns_yes
    AGET x20, LIoverlay_key
    cmp x0, x21
    b.ne LNowns_no
LNowns_yes:
    mov w0, #1
    b LNowns_done
LNowns_no:
    mov w0, #0
LNowns_done:
    ldp x21, x22, [sp, #32]
    ldp x19, x20, [sp, #16]
    ldp x29, x30, [sp], #48
    ret

LNcontext: // (bar,proxy) -> items,buttons,count,selectedIndex; nil items on fail
    stp x29, x30, [sp, #-80]!
    mov x29, sp
    stp x19, x20, [sp, #16]
    stp x21, x22, [sp, #32]
    stp x23, x24, [sp, #48]
    stp x25, x26, [sp, #64]
    mov x19, x0
    mov x20, x1
    bl LIvalid
    cbz w0, LNcontext_no
    GET x20, LIframe
    bl LIrect_valid
    cbz w0, LNcontext_no
    GET x19, LIitems
    mov x21, x0
    AGET x20, LIbuttons_key
    mov x22, x0
    cbz x21, LNcontext_no
    cbz x22, LNcontext_no
    GET x21, Lcount
    mov x23, x0
    sub x8, x23, #1
    cmp x8, #7
    b.hi LNcontext_no
    GET x22, Lcount
    cmp x0, x23
    b.ne LNcontext_no
    GET x19, Lselected_item
    cbz x0, LNcontext_no
    mov x2, x0
    GET x21, LIindex_identical
    cmp x0, x23
    b.hs LNcontext_no
    mov x24, x0
    mov x25, #0
LNcontext_buttons:
    mov x2, x25
    GET x22, Lobject_at
    mov x1, x20
    bl LNowns_button
    cbz w0, LNcontext_no
    add x25, x25, #1
    cmp x25, x23
    b.lo LNcontext_buttons
    mov x0, x21
    mov x1, x22
    mov x2, x23
    mov x3, x24
    b LNcontext_done
LNcontext_no:
    mov x0, #0
    mov x1, #0
    mov x2, #0
    mov x3, #0
LNcontext_done:
    ldp x25, x26, [sp, #64]
    ldp x23, x24, [sp, #48]
    ldp x21, x22, [sp, #32]
    ldp x19, x20, [sp, #16]
    ldp x29, x30, [sp], #80
    ret

LNtitle_valid: // nonempty bounded NSString -> BOOL
    stp x29, x30, [sp, #-32]!
    mov x29, sp
    str x19, [sp, #16]
    mov x19, x0
    adr x1, LNstring_name
    bl Lpatch + (0x7394 - PATCH_BASE)
    cbz w0, LNtitle_valid_done
    GET x19, LGlength
    sub x0, x0, #1
    cmp x0, #63
    cset w0, ls
LNtitle_valid_done:
    ldr x19, [sp, #16]
    ldp x29, x30, [sp], #32
    ret

LNtitle: // item,button -> title or nil; no blank or invented segment labels
    stp x29, x30, [sp, #-48]!
    mov x29, sp
    stp x19, x20, [sp, #16]
    stp x21, x22, [sp, #32]
    mov x19, x0
    mov x20, x1
    adr x1, LNtitle_sel
    bl LRresponds
    cbz w0, LNtitle_button
    GET x19, LNtitle_sel
    mov x21, x0
    bl LNtitle_valid
    cbnz w0, LNtitle_yes
LNtitle_button:
    mov x0, x20
    adr x1, LNbutton_title
    bl LRresponds
    cbz w0, LNtitle_no
    mov x2, #0
    GET x20, LNbutton_title
    mov x21, x0
    bl LNtitle_valid
    cbz w0, LNtitle_no
LNtitle_yes:
    mov x0, x21
    b LNtitle_done
LNtitle_no:
    mov x0, #0
LNtitle_done:
    ldp x21, x22, [sp, #32]
    ldp x19, x20, [sp, #16]
    ldp x29, x30, [sp], #48
    ret

LNitem_enabled: // item,button -> BOOL, model the original route's disabled state
    stp x29, x30, [sp, #-32]!
    mov x29, sp
    stp x19, x20, [sp, #16]
    mov x19, x0
    mov x20, x1
    GET x20, LNis_enabled
    cbz w0, LNenabled_done
    mov x0, x19
    adr x1, LNis_enabled
    bl LRresponds
    cbz w0, LNenabled_yes
    GET x19, LNis_enabled
    b LNenabled_done
LNenabled_yes:
    mov w0, #1
LNenabled_done:
    ldp x19, x20, [sp, #16]
    ldp x29, x30, [sp], #32
    ret

LNhas_native: // proxy -> BOOL; weak ownership, mount and window are all checked
    stp x29, x30, [sp, #-64]!
    mov x29, sp
    stp x19, x20, [sp, #16]
    stp x21, x22, [sp, #32]
    stp x23, x24, [sp, #48]
    mov x19, x0
    cbz x19, LNhas_no
    AGET x19, LNcontrol_key
    mov x20, x0
    cbz x20, LNhas_no
    AGET x19, LNcontroller_key
    mov x21, x0
    cbz x21, LNhas_no
    AGET x20, LNcontroller_key
    cmp x0, x21
    b.ne LNhas_no
    AGET x21, LNproxy_box_key
    GET x0, LXany_object
    cmp x0, x19
    b.ne LNhas_no
    AGET x21, LNbar_box_key
    GET x0, LXany_object
    mov x22, x0
    cbz x22, LNhas_no
    mov x1, x19
    bl LIvalid
    cbz w0, LNhas_no
    GET x20, Lsuperview
    cmp x0, x22
    b.ne LNhas_no
    GET x20, Lis_hidden
    cbnz w0, LNhas_no
    GET x22, Lwindow
    mov x23, x0
    cbz x23, LNhas_no
    GET x20, Lwindow
    cmp x0, x23
    b.ne LNhas_no
    AGET x21, LNwindow_box_key
    GET x0, LXany_object
    cmp x0, x23
    b.ne LNhas_no
    mov w0, #1
    b LNhas_done
LNhas_no:
    mov w0, #0
LNhas_done:
    ldp x23, x24, [sp, #48]
    ldp x21, x22, [sp, #32]
    ldp x19, x20, [sp, #16]
    ldp x29, x30, [sp], #64
    ret

// State synchronization never sends UIControl events. In particular a host
// selection change cannot route back into the host as a second user action.
LNsync: // native,items,buttons,count,selectedIndex,titles
    stp x29, x30, [sp, #-96]!
    mov x29, sp
    stp x19, x20, [sp, #16]
    stp x21, x22, [sp, #32]
    stp x23, x24, [sp, #48]
    stp x25, x26, [sp, #64]
    stp x27, x28, [sp, #80]
    mov x19, x0
    mov x20, x1
    mov x21, x2
    mov x22, x3
    mov x23, x4
    mov x24, x5
    mov x25, #0
LNsync_loop:
    mov x2, x25
    GET x24, Lobject_at
    mov x26, x0
    mov x2, x25
    GET x19, LNsegment_title
    cmp x0, x26
    b.eq LNsync_enabled
    mov x2, x26
    adr x1, LNstring_equal
    bl Lmessage
    cbnz w0, LNsync_enabled
    mov x2, x26
    mov x3, x25
    GET x19, LNset_title
LNsync_enabled:
    mov x2, x25
    GET x20, Lobject_at
    mov x26, x0
    mov x2, x25
    GET x21, Lobject_at
    mov x1, x0
    mov x0, x26
    bl LNitem_enabled
    mov w27, w0
    mov x2, x25
    GET x19, LNsegment_enabled
    cmp w0, w27
    b.eq LNsync_next
    mov w2, w27
    mov x3, x25
    GET x19, LNset_segment_enabled
LNsync_next:
    add x25, x25, #1
    cmp x25, x22
    b.lo LNsync_loop
    // UIKit owns the thumb while a touch is tracking. A maintenance tick
    // must not replace its preview with the unchanged host selection. A new
    // host item is authoritative even during tracking (external navigation).
    mov x2, x23
    GET x20, Lobject_at
    mov x26, x0
    AGET x19, LNsynced_item_key
    cmp x0, x26
    b.ne LNsync_selection
    GET x19, LNis_tracking
    cbnz w0, LNsync_done
LNsync_selection:
    GET x19, LNselected_index
    cmp x0, x23
    b.eq LNsync_remember
    mov x2, x23
    GET x19, LNset_selected_index
LNsync_remember:
    AGET x19, LNsynced_item_key
    cmp x0, x26
    b.eq LNsync_done
    ASET x19, LNsynced_item_key, x26, 1
LNsync_done:
    ldp x27, x28, [sp, #80]
    ldp x25, x26, [sp, #64]
    ldp x23, x24, [sp, #48]
    ldp x21, x22, [sp, #32]
    ldp x19, x20, [sp, #16]
    ldp x29, x30, [sp], #96
    ret

LNupdate: // bar,proxy -> BOOL; capability gate precedes any tab-title queries
    stp x29, x30, [sp, #-160]!
    mov x29, sp
    stp x19, x20, [sp, #16]
    stp x21, x22, [sp, #32]
    stp x23, x24, [sp, #48]
    stp x25, x26, [sp, #64]
    stp x27, x28, [sp, #80]
    mov x19, x0
    mov x20, x1
    stp xzr, xzr, [sp, #96]  // +1 copies, always released on exit
    str xzr, [sp, #112]      // own +1 native
    str xzr, [sp, #120]      // own +1 controller
    adr x0, LNsegmented_name
    bl Lpatch + (0xa5b0 - PATCH_BASE)
    str x0, [sp, #128]
    cbz x0, LNupdate_fail
    mov x21, x0
    adr x0, LNinit_items
    bl Lpatch + (0xa5a4 - PATCH_BASE)
    mov x1, x0
    mov x0, x21
    bl Lpatch + (0xa5f8 - PATCH_BASE)
    cbz x0, LNupdate_fail
    // A synchronous host route can reenter Lrepair. Preserve the mounted
    // native control until that route finishes and authoritative sync runs.
    AGET x20, LNcontroller_key
    mov x26, x0
    AGET x26, LNbusy_key
    cbz x0, LNupdate_context
    mov x0, x20
    bl LNhas_native
    cbnz w0, LNupdate_yes
LNupdate_context:
    mov x0, x19
    mov x1, x20
    bl LNcontext
    mov x21, x0
    mov x22, x1
    mov x23, x2
    mov x24, x3
    cbz x21, LNupdate_fail
    bl Lnewarray
    mov x27, x0
    cbz x27, LNupdate_fail
    mov x25, #0
LNupdate_titles:
    mov x2, x25
    GET x21, Lobject_at
    mov x26, x0
    mov x2, x25
    GET x22, Lobject_at
    mov x1, x0
    mov x0, x26
    bl LNtitle
    cbz x0, LNupdate_fail
    mov x2, x0
    GET x27, LSadd_object
    add x25, x25, #1
    cmp x25, x23
    b.lo LNupdate_titles
    AGET x20, LNcontrol_key
    mov x25, x0
    cbz x25, LNupdate_build
    mov x0, x20
    bl LNhas_native
    cbz w0, LNupdate_rebuild
    AGET x20, LNbuttons_key
    mov x1, x22
    bl LNarrays_match
    cbz w0, LNupdate_rebuild
    AGET x20, LNitems_key
    mov x1, x21
    bl LNarrays_match
    cbnz w0, LNupdate_sync
LNupdate_rebuild:
    mov x0, x19
    mov x1, x20
    bl LNrestore
LNupdate_build:
    // Stage all allocations before hiding any original control or clearing
    // its backdrop. nil/unsupported construction preserves the live fallback.
    GET x22, LIcopy
    str x0, [sp, #96]
    cbz x0, LNupdate_fail
    GET x21, LIcopy
    str x0, [sp, #104]
    cbz x0, LNupdate_fail
    bl Lnewarray
    mov x28, x0
    cbz x28, LNupdate_fail
    mov x25, #0
LNbuild_hidden:
    mov x2, x25
    GET x22, Lobject_at
    mov x26, x0
    bl Lnewarray
    mov x8, x0
    str x8, [sp, #136]
    cbz x8, LNupdate_fail
    mov x2, x26
    GET x8, LSadd_object
    GET x26, Lis_hidden
    bl Luint
    cbz x0, LNupdate_fail
    mov x2, x0
    ldr x0, [sp, #136]
    adr x1, LSadd_object
    bl Lmessage
    ldr x2, [sp, #136]
    GET x28, LSadd_object
    add x25, x25, #1
    cmp x25, x23
    b.lo LNbuild_hidden
    ldr x0, [sp, #128]
    adr x1, LIalloc
    bl Lmessage
    cbz x0, LNupdate_fail
    mov x2, x27
    adr x1, LNinit_items
    bl Lmessage
    mov x25, x0
    str x25, [sp, #112]
    cbz x25, LNupdate_fail
    bl LNcontroller_class
    cbz x0, LNupdate_fail
    GET x0, LInew
    mov x26, x0
    str x26, [sp, #120]
    cbz x26, LNupdate_fail
    mov x0, x19
    bl LRweak_box
    cbz x0, LNupdate_fail
    ASET x26, LNbar_box_key, x0, 1
    mov x0, x20
    bl LRweak_box
    cbz x0, LNupdate_fail
    ASET x26, LNproxy_box_key, x0, 1
    GET x19, Lwindow
    cbz x0, LNupdate_fail
    bl LRweak_box
    cbz x0, LNupdate_fail
    ASET x26, LNwindow_box_key, x0, 1
    mov w2, #0
    GET x25, LNset_momentary
    mov w2, #0
    GET x25, LNset_content_widths
    mov x0, x25
    mov x1, x21
    mov x2, x22
    mov x3, x23
    mov x4, x24
    mov x5, x27
    bl LNsync
    GET x20, LIframe
    mov x0, x25
    bl Lpatch + (0x711c - PATCH_BASE)
    // Verify mapping again before publishing; setters may synchronously run
    // host layout, which is permitted to replace/reorder its tab arrays.
    GET x19, LIitems
    mov x1, x21
    bl LNarrays_match
    cbz w0, LNupdate_fail
    AGET x20, LIbuttons_key
    mov x1, x22
    bl LNarrays_match
    cbz w0, LNupdate_fail
    mov x0, x19
    mov x1, x20
    bl LIvalid
    cbz w0, LNupdate_fail
    ASET x26, LNbusy_key, x26, 0
    // UIControl targets are nonretaining. The sibling native view can outlive
    // its proxy, so it also owns the controller for as long as the target is
    // attached. The controller's three owner links remain weak: no cycle.
    ASET x25, LNcontroller_key, x26, 1
    ASET x20, LNcontrol_key, x25, 1
    ASET x20, LNcontroller_key, x26, 1
    ldr x0, [sp, #96]
    ASET x20, LNbuttons_key, x0, 1
    ldr x0, [sp, #104]
    ASET x20, LNitems_key, x0, 1
    ASET x20, LNhidden_rows_key, x28, 1
    adr x0, LNchanged_sel
    bl Lpatch + (0xa5a4 - PATCH_BASE)
    mov x3, x0
    mov x2, x26
    mov w4, #4096          // UIControlEventValueChanged
    GET x25, LNadd_target
    mov x2, x25
    GET x19, LIadd_subview
    ASET x26, LNbusy_key, xzr, 0
    mov x0, x20
    bl LNhas_native
    cbz w0, LNupdate_fail
    b LNupdate_hide
LNupdate_sync:
    mov x0, x25
    mov x1, x21
    mov x2, x22
    mov x3, x23
    mov x4, x24
    mov x5, x27
    bl LNsync
    GET x20, LIframe
    mov x0, x25
    bl Lpatch + (0x711c - PATCH_BASE)
LNupdate_hide:
    mov x26, #0
LNhide_loop:
    mov x2, x26
    GET x22, Lobject_at
    mov x28, x0
    GET x28, Lis_hidden
    cbnz w0, LNhide_next
    mov w2, #1
    GET x28, Lset_hidden
LNhide_next:
    add x26, x26, #1
    cmp x26, x23
    b.lo LNhide_loop
    GET x19, Lsubviews
    GET x0, Llast_object
    cmp x0, x25
    b.eq LNupdate_yes
    mov x2, x25
    GET x19, Lbring_front
LNupdate_yes:
    mov w8, #1
    str w8, [sp, #144]
    b LNupdate_cleanup
LNupdate_fail:
    mov x0, x19
    mov x1, x20
    bl LNrestore
    str wzr, [sp, #144]
LNupdate_cleanup:
    ldr x0, [sp, #96]
    GET x0, Lrelease
    ldr x0, [sp, #104]
    GET x0, Lrelease
    ldr x0, [sp, #112]
    GET x0, Lrelease
    ldr x0, [sp, #120]
    GET x0, Lrelease
    ldr w0, [sp, #144]
    ldp x27, x28, [sp, #80]
    ldp x25, x26, [sp, #64]
    ldp x23, x24, [sp, #48]
    ldp x21, x22, [sp, #32]
    ldp x19, x20, [sp, #16]
    ldp x29, x30, [sp], #160
    ret

LNrestore: // bar,proxy; clear ownership before cancellation/removal callbacks
    stp x29, x30, [sp, #-96]!
    mov x29, sp
    stp x19, x20, [sp, #16]
    stp x21, x22, [sp, #32]
    stp x23, x24, [sp, #48]
    stp x25, x26, [sp, #64]
    stp x27, x28, [sp, #80]
    mov x19, x0
    mov x20, x1
    cbz x19, LNrestore_done
    cbz x20, LNrestore_done
    AGET x20, LNcontrol_key
    mov x21, x0
    AGET x20, LNcontroller_key
    mov x22, x0
    cbnz x22, LNrestore_check_owner
    AGET x21, LNcontroller_key
    mov x22, x0
LNrestore_check_owner:
    AGET x20, LIbound_key
    cmp x0, x19
    b.eq LNrestore_owned
    AGET x22, LNbar_box_key
    GET x0, LXany_object
    cmp x0, x19
    b.ne LNrestore_done
LNrestore_owned:
    GET x21, Lretain
    GET x22, Lretain
    AGET x20, LNhidden_rows_key
    GET x0, Lretain
    mov x23, x0
    ASET x20, LNcontrol_key, xzr, 0
    ASET x20, LNcontroller_key, xzr, 0
    ASET x20, LNbuttons_key, xzr, 0
    ASET x20, LNitems_key, xzr, 0
    ASET x20, LNhidden_rows_key, xzr, 0
    cbz x22, LNrestore_remove
    ASET x22, LNbusy_key, x22, 0
    adr x0, LNchanged_sel
    bl Lpatch + (0xa5a4 - PATCH_BASE)
    mov x3, x0
    mov x2, x22
    mov w4, #4096
    GET x21, LNremove_target
LNrestore_remove:
    // Detach target first, then release the view's strong target-lifetime
    // owner. The local retain above protects removal/reentrancy until exit.
    ASET x21, LNcontroller_key, xzr, 0
    GET x21, LIremove_from_super
    GET x23, Lcount
    mov x24, x0
    cmp x24, #8
    b.hi LNrestore_release
    mov x25, #0
LNrestore_loop:
    cmp x25, x24
    b.hs LNrestore_release
    mov x2, x25
    GET x23, Lobject_at
    mov x26, x0
    GET x26, Lcount
    cmp x0, #2
    b.ne LNrestore_next
    mov x2, #0
    GET x26, Lobject_at
    mov x27, x0
    mov x1, x20
    bl LNowns_button
    cbz w0, LNrestore_next
    GET x27, Lis_hidden
    cbz w0, LNrestore_next
    mov x2, #1
    GET x26, Lobject_at
    GET x0, Lbool_value
    cbnz w0, LNrestore_next
    mov w2, #0
    GET x27, Lset_hidden
LNrestore_next:
    add x25, x25, #1
    b LNrestore_loop
LNrestore_release:
    GET x23, Lrelease
    GET x22, Lrelease
    GET x21, Lrelease
LNrestore_done:
    ldp x27, x28, [sp, #80]
    ldp x25, x26, [sp, #64]
    ldp x23, x24, [sp, #48]
    ldp x21, x22, [sp, #32]
    ldp x19, x20, [sp, #16]
    ldp x29, x30, [sp], #96
    ret

LNvalueChanged: // controller,_cmd,native control; sole user-selection bridge
    stp x29, x30, [sp, #-96]!
    mov x29, sp
    stp x19, x20, [sp, #16]
    stp x21, x22, [sp, #32]
    stp x23, x24, [sp, #48]
    stp x25, x26, [sp, #64]
    stp x27, x28, [sp, #80]
    mov x19, x0
    mov x20, x2
    mov x21, #0
    mov x22, #0
    GET x19, Lretain
    GET x20, Lretain
    AGET x19, LNbusy_key
    cbnz x0, LNchanged_done
    AGET x19, LNbar_box_key
    GET x0, LXany_object
    GET x0, Lretain
    mov x21, x0
    AGET x19, LNproxy_box_key
    GET x0, LXany_object
    GET x0, Lretain
    mov x22, x0
    cbz x21, LNchanged_done
    cbz x22, LNchanged_done
    AGET x22, LNcontroller_key
    cmp x0, x19
    b.ne LNchanged_done
    AGET x22, LNcontrol_key
    cmp x0, x20
    b.ne LNchanged_done
    mov x0, x22
    bl LNhas_native
    cbz w0, LNchanged_repair
    GET x20, LNis_enabled
    cbz w0, LNchanged_repair
    mov x0, x21
    mov x1, x22
    bl LNcontext
    mov x23, x0
    mov x24, x1
    mov x25, x2
    mov x26, x3
    cbz x23, LNchanged_repair
    AGET x22, LNitems_key
    mov x1, x23
    bl LNarrays_match
    cbz w0, LNchanged_repair
    AGET x22, LNbuttons_key
    mov x1, x24
    bl LNarrays_match
    cbz w0, LNchanged_repair
    GET x20, LNselected_index
    mov x27, x0
    cmp x27, x25
    b.hs LNchanged_repair  // Includes UISegmentedControlNoSegment (-1).
    cmp x27, x26
    b.eq LNchanged_repair // Duplicate/current selection must not route twice.
    mov x2, x27
    GET x24, Lobject_at
    mov x28, x0
    mov x2, x27
    GET x23, Lobject_at
    mov x1, x28
    bl LNitem_enabled
    cbz w0, LNchanged_repair
    ASET x19, LNbusy_key, x19, 0
    mov x0, x21
    mov x1, #0
    mov x2, x28
    bl Lpatch + (0x56c0 - PATCH_BASE)
    ASET x19, LNbusy_key, xzr, 0
    // The original route may reject, redirect, replace or detach this bar.
    // Reconcile through Lrepair, never assume the requested index became true.
LNchanged_repair:
    // An actual valueChanged, including a rejected host route, ends the
    // preview's authority. Reconcile the accepted host item immediately even
    // if UIKit is still tracking when it delivers this callback.
    ASET x20, LNsynced_item_key, xzr, 0
    mov x0, x21
    bl Lrepair
LNchanged_done:
    GET x22, Lrelease
    GET x21, Lrelease
    GET x20, Lrelease
    GET x19, Lrelease
    ldp x27, x28, [sp, #80]
    ldp x25, x26, [sp, #64]
    ldp x23, x24, [sp, #48]
    ldp x21, x22, [sp, #32]
    ldp x19, x20, [sp, #16]
    ldp x29, x30, [sp], #96
    ret

// @COMPONENT_DATA
.p2align 3
LNdirectory:
    .ascii "FQ161SEG"
    .long 0x10601, 13
    .long LNupdate - Lpatch + PATCH_BASE
    .long LNrestore - Lpatch + PATCH_BASE
    .long LNhas_native - Lpatch + PATCH_BASE
    .long LNvalueChanged - Lpatch + PATCH_BASE
    .long LNcontrol_key - Lpatch + PATCH_BASE
    .long LNcontroller_key - Lpatch + PATCH_BASE
    .long LNbuttons_key - Lpatch + PATCH_BASE
    .long LNitems_key - Lpatch + PATCH_BASE
    .long LNhidden_rows_key - Lpatch + PATCH_BASE
    .long LNbar_box_key - Lpatch + PATCH_BASE
    .long LNproxy_box_key - Lpatch + PATCH_BASE
    .long LNbusy_key - Lpatch + PATCH_BASE
    .long LNwindow_box_key - Lpatch + PATCH_BASE
LNcontrol_key: .byte 0
LNcontroller_key: .byte 0
LNbuttons_key: .byte 0
LNitems_key: .byte 0
LNhidden_rows_key: .byte 0
LNbar_box_key: .byte 0
LNproxy_box_key: .byte 0
LNbusy_key: .byte 0
LNwindow_box_key: .byte 0
LNsynced_item_key: .byte 0
LNcontroller_name: .asciz "FQABNativeSelection161"
LNsegmented_name: .asciz "UISegmentedControl"
LNbutton_name: .asciz "UIButton"
LNstring_name: .asciz "NSString"
LNinit_items: .asciz "initWithItems:"
LNtitle_sel: .asciz "title"
LNbutton_title: .asciz "titleForState:"
LNis_enabled: .asciz "isEnabled"
LNis_tracking: .asciz "isTracking"
LNsegment_title: .asciz "titleForSegmentAtIndex:"
LNset_title: .asciz "setTitle:forSegmentAtIndex:"
LNsegment_enabled: .asciz "isEnabledForSegmentAtIndex:"
LNset_segment_enabled: .asciz "setEnabled:forSegmentAtIndex:"
LNselected_index: .asciz "selectedSegmentIndex"
LNset_selected_index: .asciz "setSelectedSegmentIndex:"
LNset_momentary: .asciz "setMomentary:"
LNset_content_widths: .asciz "setApportionsSegmentWidthsByContent:"
LNstring_equal: .asciz "isEqualToString:"
LNchanged_sel: .asciz "nativeSelectionChanged:"
LNadd_target: .asciz "addTarget:action:forControlEvents:"
LNremove_target: .asciz "removeTarget:action:forControlEvents:"
.p2align 2
