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

// @COMPONENT_DATA
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
