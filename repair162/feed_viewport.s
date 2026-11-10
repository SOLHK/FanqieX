// FanqieAdBlock 1.6.0: the shelf/profile nested recommendation viewport.
// The current 1.5.8 log shows its lower edge at y=890 / y=882 while the
// floating bar ends at y=956. Clearing a material cannot create content there.
//
// Public entry points:
//   LFbegin(bar), LFconsider(feed, bar), LFend(bar), LFrestore(bar).
// A bar owns at most one member of the FQFeedListCollectionView family, on Shelf or Mine.
// Rows: [feed, NSData(6 doubles), clipRows, immediateParent, outerScroll].
// Scalar data: originalHeight, appliedHeight, originalInsetBottom,
//              appliedInsetBottom, originalWidth, extensionHeight.
// clipRows: [ancestor, NSNumber(originalClipsToBounds)].
// Feed origin, width, top/side insets and content offset are never redesigned.

// A geometric identity is tolerant of sub-pixel floating-point roundoff only.
// Callers use b.hi to reject either a mismatch or an unordered/NaN comparison.
.macro LFNEAR left, right
    fsub d6, \left, \right
    fabs d6, d6
    adr x8, LFstable_epsilon
    ldr d7, [x8]
    fcmp d6, d7
.endm
.macro LFSTAGE value
    mov w8, #\value
    str w8, [sp, #408]
.endm
.if FQ_VERSION >= 0x10704
    .set LF_OLD_SCALARS, 288
.else
    .set LF_OLD_SCALARS, 240
.endif

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

// A converted rectangle alone does not prove that UIKit can paint it: an
// ancestor above the chosen outer scroll may still clip the bottom away.
// Validate that path without changing ANY of its geometry or clipping state.
LFouter_path: // outer scroll, bar, shared ancestor -> BOOL; at most 8 ancestors
    stp x29, x30, [sp, #-96]!
    mov x29, sp
    stp x19, x20, [sp, #16]
    stp x21, x22, [sp, #32]
    stp x23, x24, [sp, #48]
    stp d8, d9, [sp, #64]
    mov x19, x0
    mov x20, x1
    mov x21, x2
    mov x22, #8
    GET x20, Lwindow
    mov x23, x0
    cbz x23, LFouter_path_no
    GET x20, Lbounds
    fadd d8, d1, d3
    GET x19, Lsuperview
    mov x19, x0
LFouter_path_loop:
    cbz x19, LFouter_path_no
    cbz x22, LFouter_path_no
    sub x22, x22, #1
    GET x19, Lwindow
    cmp x0, x23
    b.ne LFouter_path_no
    GET x19, Lis_hidden
    cbnz w0, LFouter_path_no
    GET x19, Lalpha
    FINITE d0, LFouter_path_no
    fcmp d0, #0.0
    b.le LFouter_path_no
    mov x0, x19
    bl LFidentity
    cbz w0, LFouter_path_no
    GET x19, Llayer
    mov x24, x0
    GET x24, LFmask
    cbnz x0, LFouter_path_no
    GET x19, LFclips
    cbz w0, LFouter_path_next
    GET x24, LFcorner_radius
    fcmp d0, #0.0
    b.ne LFouter_path_no
    mov x0, x19
    mov x1, x20
    bl LFrect
    cbz w0, LFouter_path_no
    fadd d4, d1, d3
    fmov d5, #1.0
    fsub d5, d8, d5
    fcmp d4, d5
    b.lt LFouter_path_no
LFouter_path_next:
    cmp x19, x21
    b.eq LFouter_path_yes
    GET x19, Lsuperview
    mov x19, x0
    b LFouter_path_loop
LFouter_path_yes:
    mov w0, #1
    b LFouter_path_done
LFouter_path_no:
    mov w0, #0
LFouter_path_done:
    ldp d8, d9, [sp, #64]
    ldp x23, x24, [sp, #48]
    ldp x21, x22, [sp, #32]
    ldp x19, x20, [sp, #16]
    ldp x29, x30, [sp], #96
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
    str wzr, [sp, #412] // Only recognized feed candidates receive diagnostics.
    cbz x19, LFconsider_no
    cbz x20, LFconsider_no
    mov x0, x19
    adr x1, LFfeed_class
    bl Lpatch + (0x7394 - PATCH_BASE)
    cbz w0, LFconsider_no
    mov w8, #1
    str w8, [sp, #412]
    mov x0, x19
    mov x1, x20
    bl LFremember
    LFSTAGE 2 // missing begin scope or another candidate already owns this pass
    AGET x20, LFnext_key
    mov x22, x0
    cbz x22, LFconsider_no
    GET x22, Lcount
    cbnz x0, LFconsider_no // Never overlap ownership of shared clip ancestors.
    LFSTAGE 3 // unsupported tab
    GET x20, LSitems
    mov x21, x0
    GET x21, Lcount
    .if FQ_VERSION >= 0x10704
    // Hiding an entry changes its neighbors' indices, not their host types.
    mov x25, x0
    GET x20, Lselected_item
    mov x24, x0
    cbz x24, LFconsider_no
    mov x2, x24
    GET x21, LSindex_identical
    cmp x0, x25
    b.hs LFconsider_no
    mov x0, x24
    adr x1, LFtab_item_class
    bl Lpatch + (0x7394 - PATCH_BASE)
    cbz w0, LFconsider_no
    GET x24, LFtab_item_type
    sub w0, w0, #3 // SSTabBarButtonItem.type: 3 = Shelf, 4 = Mine.
    cmp w0, #1
    b.hi LFconsider_no
    .else
    cmp x0, #4
    b.ne LFconsider_no
    GET x20, Lselected_item
    cbz x0, LFconsider_no
    mov x2, x0
    GET x21, LSindex_identical
    sub x0, x0, #2
    cmp x0, #1
    b.hi LFconsider_no
    .endif
    LFSTAGE 4 // proxy is not mounted/visible
    AGET x20, Lpatch + (0xeb84 - PATCH_BASE)
    mov x1, x0
    mov x0, x20
    bl LXvalid_proxy
    cbz w0, LFconsider_no
    LFSTAGE 5 // visibility or window mismatch
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
    // Empty/reloading data and pre-constraint frames still need the NEXT host
    // layout. Observation does not mutate geometry; do not gate it on contentSize.
    LFSTAGE 11
    mov x0, x19
    mov x1, x20
    bl LFwatch
    cbz w0, LFconsider_no
    LFSTAGE 6 // bar/window geometry
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
    LFSTAGE 7 // feed geometry
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
    fsub d4, d3, d11
    fabs d4, d4
    fmov d5, #0.5
    fcmp d4, d5
    b.hi LFconsider_no // convertRect may differ by several ULPs.
    fmov d14, d3 // baseline height, possibly normalized below
    GET x19, Llayer
    mov x21, x0
    GET x21, LFmask
    cbnz x0, LFconsider_no
    GET x21, LFcorner_radius
    fcmp d0, #0.0
    b.ne LFconsider_no
    LFSTAGE 8 // inset, original baseline or scrollable content
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
    add x2, sp, #LF_OLD_SCALARS
    mov x3, #48
    GET x0, LFget_bytes
    ldr d0, [sp, #(LF_OLD_SCALARS + 32)] // previous width
    ldr d1, [sp, #176]
    LFNEAR d0, d1
    b.hi LFconsider_inset_base
    ldr d0, [sp, #(LF_OLD_SCALARS + 8)] // previously applied height
    LFNEAR d14, d0
    b.hi LFconsider_inset_base
    ldr d14, [sp, #LF_OLD_SCALARS]
LFconsider_inset_base:
    ldr d0, [sp, #(LF_OLD_SCALARS + 24)] // previously applied inset bottom
    LFNEAR d15, d0
    b.hi LFconsider_old_clips
    ldr d15, [sp, #(LF_OLD_SCALARS + 16)]
LFconsider_old_clips:
    mov x2, #2
    GET x21, Lobject_at
    mov x27, x0
LFconsider_baseline:
    .if FQ_VERSION >= 0x10704
    str x21, [sp, #416] // previous ownership row
    .endif
    GET x19, Lcontent_size
    FINITE d0, LFconsider_no
    FINITE d1, LFconsider_no
    fmov d4, #1.0
    fadd d4, d14, d4
    fcmp d1, d4
    b.le LFconsider_no
    LFSTAGE 9 // ancestor safety or no enclosing viewport
    GET x19, Lsuperview
    mov x26, x0
    mov x24, x0
    .if FQ_VERSION >= 0x10704
    add x25, sp, #336 // bounded path of 8 intermediate ancestors
    .else
    bl Lnewarray
    mov x25, x0 // intermediate path, excludes the feed and enclosing scroll
    .endif
    mov x28, #0
LFconsider_parent_loop:
    cbz x24, LFconsider_no
    cmp x24, x23
    b.eq LFconsider_no // No enclosing scroll: never change a root feed.
    cmp x28, #8
    b.hs LFconsider_no
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
    .if FQ_VERSION >= 0x10704
    mov x21, x0
    GET x21, LFmask
    cbnz x0, LFconsider_no
    GET x21, LFcorner_radius
    .else
    mov x28, x0
    GET x28, LFmask
    cbnz x0, LFconsider_no
    GET x28, LFcorner_radius
    .endif
    fcmp d0, #0.0
    b.ne LFconsider_no
    mov x0, x24
    adr x1, Lscroll_class
    bl Lpatch + (0x7394 - PATCH_BASE)
    cbnz w0, LFconsider_outer
LFconsider_intermediate:
    .if FQ_VERSION >= 0x10704
    str x24, [x25, x28, lsl #3]
    add x28, x28, #1
    .else
    mov x2, x24
    GET x25, LSadd_object
    GET x25, Lcount
    mov x28, x0
    .endif
    GET x24, Lsuperview
    mov x24, x0
    b LFconsider_parent_loop
LFconsider_outer:
    mov x0, x24
    mov x1, x20
    bl LFrect
    cbz w0, LFconsider_no
    fmov d12, d1 // enclosing viewport top
    fadd d4, d1, d3
    fmov d5, #1.0
    fsub d5, d9, d5
    fcmp d4, d5
    b.lt LFconsider_intermediate // A short nested pager is not the outer viewport.
    LFSTAGE 10 // enclosing viewport or extension is not safe
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
    GET x24, LFclips
    cbz w0, LFconsider_no // Keep final outer clipping; do not redesign its host state.
    LFSTAGE 12 // An ancestor above the chosen outer would still hide the extension.
    mov x0, x24
    mov x1, x20
    mov x2, x23
    bl LFouter_path
    cbz w0, LFconsider_no
    LFSTAGE 10
    fsub d13, d9, d10 // Feed itself must end at the physical window bottom.
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
    // All geometry/content guards complete before the first host mutation.
    .if FQ_VERSION >= 0x10704
    // Keep the existing restoration state if its scalars and ancestors match.
    ldr x21, [sp, #416]
    cbz x21, LFconsider_new_row
    add x8, sp, #240
    add x9, sp, #LF_OLD_SCALARS
    mov x10, #6
LFconsider_compare_scalars:
    ldr x11, [x8], #8
    ldr x12, [x9], #8
    cmp x11, x12
    b.ne LFconsider_new_row
    subs x10, x10, #1
    b.ne LFconsider_compare_scalars
    mov x2, #3
    GET x21, Lobject_at
    cmp x0, x26
    b.ne LFconsider_new_row
    mov x2, #4
    GET x21, Lobject_at
    cmp x0, x24
    b.ne LFconsider_new_row
    GET x27, Lcount
    cmp x0, x28
    b.ne LFconsider_new_row
    mov x23, #0
LFconsider_compare_clips:
    cmp x23, x28
    b.hs LFconsider_reuse_row
    mov x2, x23
    GET x27, Lobject_at
    mov x2, #0
    GET x0, Lobject_at
    ldr x8, [x25, x23, lsl #3]
    cmp x0, x8
    b.ne LFconsider_new_row
    add x23, x23, #1
    b LFconsider_compare_clips
LFconsider_reuse_row:
    mov x27, x21
    b LFconsider_publish
LFconsider_new_row:
    mov x0, x25
    mov x1, x28
    mov x2, x27
    .else
    mov x0, x25
    mov x1, x27
    .endif
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
LFconsider_publish:
    mov x2, x27
    GET x22, LSadd_object // Publish before any synchronous UIKit reentry.
    AGET x19, LFbusy_key
    str x0, [sp, #400]
    ASET x19, LFbusy_key, x19, 0
    mov x0, x27
    bl LFapply_row
    ldr x0, [sp, #400]
    ASET x19, LFbusy_key, x0, 0
    mov x0, x19
    mov w1, #1 // applied
    bl LFstage
    mov w0, #1
    b LFconsider_done
LFconsider_no:
    ldr w8, [sp, #412]
    cbz w8, LFconsider_no_record
    mov x0, x19
    ldr w1, [sp, #408]
    bl LFstage
LFconsider_no_record:
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

LFclips_capture: // path of views, path length, old clip rows -> new clip rows
    stp x29, x30, [sp, #-80]!
    mov x29, sp
    stp x19, x20, [sp, #16]
    stp x21, x22, [sp, #32]
    stp x23, x24, [sp, #48]
    stp x25, x26, [sp, #64]
    mov x19, x0
    mov x20, x1
    .if FQ_VERSION >= 0x10704
    mov x22, x2
    .endif
    bl Lnewarray
    mov x21, x0
    .if FQ_VERSION < 0x10704
    GET x19, Lcount
    mov x22, x0
    .endif
    mov x23, #0
LFclips_capture_loop:
    .if FQ_VERSION >= 0x10704
    cmp x23, x20
    b.hs LFclips_capture_done
    ldr x24, [x19, x23, lsl #3]
    mov x1, x24
    mov x0, x22
    .else
    cmp x23, x22
    b.hs LFclips_capture_done
    mov x2, x23
    GET x19, Lobject_at
    mov x24, x0
    mov x1, x24
    mov x0, x20
    .endif
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
    LFNEAR d2, d4
    b.ls LFapply_frame
    fmov d2, d4
    GET x20, LFset_inset // Grow scrollable padding before increasing viewport.
LFapply_frame:
    GET x20, LSframe
    ldr d4, [sp, #104]
    LFNEAR d3, d4
    b.ls LFapply_clips
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
    LFNEAR d0, d8
    b.hi LFapply_offset_write
    LFNEAR d1, d9
    b.ls LFapply_done
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
    LFNEAR d2, d4
    b.hi LFrestore_inset
    ldr d4, [sp, #88]
    LFNEAR d3, d4
    b.hi LFrestore_inset
    ldr d3, [sp, #80]
    GET x20, LFset_frame // Shrink viewport before removing corresponding padding.
LFrestore_inset:
    GET x20, LFcontent_inset
    ldr d4, [sp, #104]
    LFNEAR d2, d4
    b.hi LFrestore_clips
    ldr d2, [sp, #96]
    GET x20, LFset_inset
LFrestore_clips:
    mov x2, #2
    GET x19, Lobject_at
    mov x1, #0
    bl LFclips_release
    GET x20, LFcontent_offset
    LFNEAR d0, d8
    b.hi LFrestore_offset
    LFNEAR d1, d9
    b.ls LFrestore_row_unbusy
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

// Install once on the declared feed base, preserving its real implementation and
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
    bl LFinstall_base
    cbz w0, LFwatch_no
LFwatch_owner:
    // A real subclass may reset the frame after calling super's layout.
    // Wrap that runtime entry too, with its own bound original IMP.
    mov x0, x19
    bl LFdynamic_watch
    cbz w0, LFwatch_no
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

LFinstall_base:
    stp x29, x30, [sp, #-64]!
    mov x29, sp
    stp x19, x20, [sp, #16]
    stp x21, x22, [sp, #32]
    stp x23, x24, [sp, #48]
    adr x0, LFfeed_class
    bl Lpatch + (0xa5b0 - PATCH_BASE)
    mov x21, x0
    cbz x21, LFinstall_base_no
    adr x0, Llayout_sel
    bl Lpatch + (0xa5a4 - PATCH_BASE)
    mov x1, x0
    mov x0, x21
    bl Lpatch + (0xa5f8 - PATCH_BASE)
    cbz x0, LFinstall_base_no
    bl Lpatch + (0xa5ec - PATCH_BASE) // method_getTypeEncoding
    cbz x0, LFinstall_base_no
    mov x24, x0
    adr x1, Lvoid_encoding
    bl Lpatch + (0xa5e0 - PATCH_BASE) // strcmp
    cbz w0, LFinstall_encoding_ok
    mov x0, x24
    adr x1, LFcompact_void
    bl Lpatch + (0xa5e0 - PATCH_BASE)
    cbnz w0, LFinstall_base_no
LFinstall_encoding_ok:
    mov x0, x21
    adr x1, Llayout_sel
    adr x2, LFlayout_alias
    adr x3, LFfeed_layout
    mov x4, x24 // Pass the actual compatible ABI spelling to the installer.
    bl Linstall_method
    adr x0, Llayout_sel
    bl Lpatch + (0xa5a4 - PATCH_BASE)
    mov x1, x0
    mov x0, x21
    bl Lpatch + (0xa5f8 - PATCH_BASE)
    cbz x0, LFinstall_base_no
    bl Lpatch + (0xa598 - PATCH_BASE)
    adr x8, LFfeed_layout
    cmp x0, x8
    b.ne LFinstall_base_no
    adr x0, LFlayout_alias
    bl Lpatch + (0xa5a4 - PATCH_BASE)
    mov x1, x0
    mov x0, x21
    bl Lpatch + (0xa5f8 - PATCH_BASE)
    cbz x0, LFinstall_base_no
    bl Lpatch + (0xa598 - PATCH_BASE)
    cbz x0, LFinstall_base_no
    adr x8, LFfeed_layout
    cmp x0, x8
    b.eq LFinstall_base_no
    mov x23, x0
    AGET x21, LFimp_key
    cbnz x0, LFinstall_base_yes
    mov x0, x23
    bl Luint
    ASET x21, LFimp_key, x0, 1
LFinstall_base_yes:
    mov w0, #1
    b LFinstall_base_done
LFinstall_base_no:
    mov w0, #0
LFinstall_base_done:
    ldp x23, x24, [sp, #48]
    ldp x21, x22, [sp, #32]
    ldp x19, x20, [sp, #16]
    ldp x29, x30, [sp], #64
    ret

// The base-class observer cannot run after a subclass's after-super writes.
// Each runtime override receives a distinct, fixed trampoline. Its slot stores
// its own original IMP, so a super call through another installed trampoline
// cannot resolve the most-derived alias again or recurse. No methods outside
// the already-eligible FQ feed family are observed. The process-wide table is
// bounded to eight distinct runtime overrides; inherited observers reuse a slot.
LFis_layout_observer: // IMP -> BOOL
    adr x8, LFfeed_layout
    cmp x0, x8
    b.eq LFis_layout_yes
    adr x8, LFdynamic_layout0
    mov x9, #8
LFis_layout_loop:
    cmp x0, x8
    b.eq LFis_layout_yes
    add x8, x8, #8
    subs x9, x9, #1
    b.ne LFis_layout_loop
    mov w0, #0
    ret
LFis_layout_yes:
    mov w0, #1
    ret

LFdynamic_watch: // observed host scroll -> BOOL
    stp x29, x30, [sp, #-16]!
    mov x29, sp
    bl Lpatch + (0xa664 - PATCH_BASE) // actual isa, never an overridden -class
    bl LFdynamic_class_watch
    ldp x29, x30, [sp], #16
    ret

LFdynamic_class_watch: // exact known class or observed runtime class -> BOOL
    stp x29, x30, [sp, #-96]!
    mov x29, sp
    stp x19, x20, [sp, #16]
    stp x21, x22, [sp, #32]
    stp x23, x24, [sp, #48]
    stp x25, x26, [sp, #64]
    stp x27, x28, [sp, #80]
    mov x19, x0
    cbz x19, LFdynamic_watch_no
    adr x0, Llayout_sel
    bl Lpatch + (0xa5a4 - PATCH_BASE)
    mov x20, x0
    mov x1, x20
    mov x0, x19
    bl Lpatch + (0xa5f8 - PATCH_BASE)
    cbz x0, LFdynamic_watch_no
    mov x27, x0
    bl Lpatch + (0xa598 - PATCH_BASE)
    mov x21, x0
    cbz x21, LFdynamic_watch_no
    bl LFis_layout_observer
    cbnz w0, LFdynamic_watch_yes
    // If somebody replaces an already-observed runtime method, do not chain
    // a new wrapper to the old wrapper and change its original under its feet.
    AGET x19, LFdynamic_slot_key
    cbnz x0, LFdynamic_watch_no
    mov x0, x27
    bl Lpatch + (0xa5ec - PATCH_BASE)
    mov x22, x0
    cbz x22, LFdynamic_watch_no
    adr x1, Lvoid_encoding
    bl Lpatch + (0xa5e0 - PATCH_BASE)
    cbz w0, LFdynamic_encoding_ok
    mov x0, x22
    adr x1, LFcompact_void
    bl Lpatch + (0xa5e0 - PATCH_BASE)
    cbnz w0, LFdynamic_watch_no
LFdynamic_encoding_ok:
    adr x0, LFfeed_class
    bl Lpatch + (0xa5b0 - PATCH_BASE)
    mov x23, x0
    cbz x23, LFdynamic_watch_no
    AGET x23, LFdynamic_classes_key
    mov x24, x0
    cbnz x24, LFdynamic_have_table
    bl Lnewarray
    mov x24, x0
    cbz x24, LFdynamic_watch_no
    ASET x23, LFdynamic_classes_key, x24, 1
LFdynamic_have_table:
    GET x24, Lcount
    mov x25, x0
    cmp x25, #8
    b.hs LFdynamic_watch_no
    adr x26, LFdynamic_layout0
    add x26, x26, x25, lsl #3
    // Publish the immutable original before making the trampoline reachable.
    bl Lnewarray
    mov x28, x0
    cbz x28, LFdynamic_watch_no
    mov x2, x19
    GET x28, LSadd_object
    mov x0, x21
    bl Luint
    mov x2, x0
    GET x28, LSadd_object
    mov x2, x28
    GET x24, LSadd_object
    ASET x19, LFdynamic_slot_key, x28, 1
    mov x0, x19
    mov x1, x20
    mov x2, x26
    mov x3, x22
    bl Lpatch + (0xa58c - PATCH_BASE) // class_addMethod keeps inherited methods local.
    cbnz w0, LFdynamic_verify
    mov x0, x19
    mov x1, x20
    bl Lpatch + (0xa5f8 - PATCH_BASE)
    cbz x0, LFdynamic_watch_no
    mov x27, x0
    bl Lpatch + (0xa598 - PATCH_BASE)
    cmp x0, x21
    b.ne LFdynamic_watch_no
    mov x0, x27
    mov x1, x26
    bl Lpatch + (0xa580 - PATCH_BASE)
LFdynamic_verify:
    mov x0, x19
    mov x1, x20
    bl Lpatch + (0xa5f8 - PATCH_BASE)
    cbz x0, LFdynamic_watch_no
    bl Lpatch + (0xa598 - PATCH_BASE)
    cmp x0, x26
    b.ne LFdynamic_watch_no
LFdynamic_watch_yes:
    mov w0, #1
    b LFdynamic_watch_done
LFdynamic_watch_no:
    mov w0, #0
LFdynamic_watch_done:
    ldp x27, x28, [sp, #80]
    ldp x25, x26, [sp, #64]
    ldp x23, x24, [sp, #48]
    ldp x21, x22, [sp, #32]
    ldp x19, x20, [sp, #16]
    ldp x29, x30, [sp], #96
    ret

// Exactly eight bytes per entry; LFdynamic_watch computes the entry address.
LFdynamic_layout0:
    mov w2, #0
    b LFfeed_dynamic_layout
LFdynamic_layout1:
    mov w2, #1
    b LFfeed_dynamic_layout
LFdynamic_layout2:
    mov w2, #2
    b LFfeed_dynamic_layout
LFdynamic_layout3:
    mov w2, #3
    b LFfeed_dynamic_layout
LFdynamic_layout4:
    mov w2, #4
    b LFfeed_dynamic_layout
LFdynamic_layout5:
    mov w2, #5
    b LFfeed_dynamic_layout
LFdynamic_layout6:
    mov w2, #6
    b LFfeed_dynamic_layout
LFdynamic_layout7:
    mov w2, #7
    b LFfeed_dynamic_layout

LFfeed_dynamic_layout: // self, original _cmd, bound original slot
    stp x29, x30, [sp, #-80]!
    mov x29, sp
    stp x19, x20, [sp, #16]
    stp x21, x22, [sp, #32]
    stp x23, x24, [sp, #48]
    mov x19, x0
    mov x20, x1
    mov x24, x2
    AGET x19, LFbusy_key
    mov x23, x0
    cbnz x23, LFdynamic_call_original
    ASET x19, LFbusy_key, x19, 0
LFdynamic_call_original:
    mov x0, x19
    mov x1, x20
    mov x2, x24
    bl LFdynamic_original
    cbnz x23, LFfeed_done // The outermost observer repairs after the whole chain.
    b LFfeed_after_original

LFdynamic_original: // Call this trampoline's immutable original with original _cmd.
    stp x29, x30, [sp, #-64]!
    mov x29, sp
    stp x19, x20, [sp, #16]
    stp x21, x22, [sp, #32]
    mov x19, x0
    mov x20, x1
    mov x21, x2
    cmp x21, #8
    b.hs LFdynamic_original_done
    adr x0, LFfeed_class
    bl Lpatch + (0xa5b0 - PATCH_BASE)
    AGET x0, LFdynamic_classes_key
    mov x22, x0
    GET x22, Lcount
    cmp x21, x0
    b.hs LFdynamic_original_done
    mov x2, x21
    GET x22, Lobject_at
    mov x2, #1
    GET x0, Lobject_at
    GET x0, LXunsigned
    mov x22, x0
    cbz x22, LFdynamic_original_done
    bl LFis_layout_observer
    cbnz w0, LFdynamic_original_done
    mov x16, x22
    mov x0, x19
    mov x1, x20
    ldp x21, x22, [sp, #32]
    ldp x19, x20, [sp, #16]
    ldp x29, x30, [sp], #64
    br x16
LFdynamic_original_done:
    ldp x21, x22, [sp, #32]
    ldp x19, x20, [sp, #16]
    ldp x29, x30, [sp], #64
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
LFfeed_after_original:
    AGET x19, LFowner_key
    GET x0, LXany_object
    GET x0, Lretain
    mov x21, x0
    cbnz x21, LFfeed_owner_alive
    // A newly attached page was absent from the tab's previous traversal.
    // Find its bar in a weak, bounded registry; never walk a whole window.
    mov x0, x19
    bl LFlifecycle_bar
    GET x0, Lretain
    mov x21, x0
    cbz x21, LFfeed_no_bar
    mov x0, x19
    mov x1, x21
    bl LFwatch
    cbz w0, LFfeed_release
    b LFfeed_owner_alive
LFfeed_no_bar:
    mov x0, x19
    bl LFrestore_orphan
    b LFfeed_unbusy
LFfeed_owner_alive:
    AGET x21, Lbusy_key
    cbnz x0, LFfeed_release
    AGET x21, LFnext_key
    cbnz x0, LFfeed_release
    ASET x21, Lbusy_key, x21, 0
    mov x0, x19
    mov x1, x21
    bl LFlifecycle_edge
    // SS bookstore containers use only the edge path; they cannot evict a
    // nested feed's geometry record or resize themselves as if they were one.
    mov x0, x19
    adr x1, LFfeed_class
    bl Lpatch + (0x7394 - PATCH_BASE)
    cbz w0, LFfeed_bar_unbusy
    // An old invisible page must not evict the active page's feed record.
    AGET x21, LFrecords_key
    mov x22, x0
    GET x22, Lcount
    cbz x0, LFfeed_refresh
    mov x0, x22
    mov x1, x19
    bl LFfind
    cbz x0, LFfeed_bar_unbusy
LFfeed_refresh:
    mov x0, x21
    bl LFbegin
    mov x0, x19
    mov x1, x21
    bl LFconsider
    mov x0, x21
    bl LFend
LFfeed_bar_unbusy:
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
    adr x0, LFfeed_class
    bl Lpatch + (0xa5b0 - PATCH_BASE)
    mov x21, x0 // Never resolve an inherited alias through a dynamic subclass.
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

// Candidate tracking is weak and capped. Hot layouts only retain a stage number
// when the final decision changes; detailed geometry is captured at export time.
LFremember: // feed, bar
    stp x29, x30, [sp, #-48]!
    mov x29, sp
    stp x19, x20, [sp, #16]
    stp x21, x22, [sp, #32]
    mov x19, x0
    mov x20, x1
    AGET x20, LFcandidates_key
    mov x21, x0
    cbnz x21, LFremember_have
    adr x0, LShash_class
    adr x1, LSweak_hash
    bl Lfactory
    mov x21, x0
    cbz x21, LFremember_done
    ASET x20, LFcandidates_key, x21, 1
LFremember_have:
    mov x2, x19
    GET x21, Lcontains
    cbnz w0, LFremember_done
    GET x21, Lcount
    cmp x0, #12
    b.hs LFremember_done
    mov x2, x19
    GET x21, LSadd_object
LFremember_done:
    ldp x21, x22, [sp, #32]
    ldp x19, x20, [sp, #16]
    ldp x29, x30, [sp], #48
    ret

LFstage: // feed, numeric final decision
    stp x29, x30, [sp, #-48]!
    mov x29, sp
    stp x19, x20, [sp, #16]
    mov x19, x0
    mov x20, x1
    AGET x19, LFstage_key
    cbz x0, LFstage_changed
    GET x0, LXunsigned
    cmp x0, x20
    b.eq LFstage_done
LFstage_changed:
    mov x0, x20
    bl Luint
    ASET x19, LFstage_key, x0, 1
LFstage_done:
    ldp x19, x20, [sp, #16]
    ldp x29, x30, [sp], #48
    ret

.macro LFPUT dictionary, key
    mov x2, x0
    mov x0, \dictionary
    adr x1, \key
    bl Ldict_set
.endm

LFdecision: // number -> descriptive NSString
    adr x8, LFdecision_unknown
    cmp x0, #1
    b.ne LFdecision_2
    adr x8, LFdecision_applied
    b LFdecision_string
LFdecision_2:
    cmp x0, #2
    b.ne LFdecision_3
    adr x8, LFdecision_scope
    b LFdecision_string
LFdecision_3:
    cmp x0, #3
    b.ne LFdecision_4
    adr x8, LFdecision_tab
    b LFdecision_string
LFdecision_4:
    cmp x0, #4
    b.ne LFdecision_5
    adr x8, LFdecision_proxy
    b LFdecision_string
LFdecision_5:
    cmp x0, #5
    b.ne LFdecision_6
    adr x8, LFdecision_visibility
    b LFdecision_string
LFdecision_6:
    cmp x0, #6
    b.ne LFdecision_7
    adr x8, LFdecision_bar
    b LFdecision_string
LFdecision_7:
    cmp x0, #7
    b.ne LFdecision_8
    adr x8, LFdecision_feed
    b LFdecision_string
LFdecision_8:
    cmp x0, #8
    b.ne LFdecision_9
    adr x8, LFdecision_baseline
    b LFdecision_string
LFdecision_9:
    cmp x0, #9
    b.ne LFdecision_10
    adr x8, LFdecision_ancestors
    b LFdecision_string
LFdecision_10:
    cmp x0, #10
    b.ne LFdecision_11
    adr x8, LFdecision_outer
    b LFdecision_string
LFdecision_11:
    cmp x0, #11
    b.ne LFdecision_12
    adr x8, LFdecision_observer
    b LFdecision_string
LFdecision_12:
    cmp x0, #12
    b.ne LFdecision_string
    adr x8, LFdecision_above_outer
LFdecision_string:
    mov x0, x8
    b Lstr

LFdescribe: // UIView -> diagnostic dictionary, with actual isa and clipping
    stp x29, x30, [sp, #-64]!
    mov x29, sp
    stp x19, x20, [sp, #16]
    stp x21, x22, [sp, #32]
    stp x23, x24, [sp, #48]
    mov x19, x0
    bl Ldescribe_view
    mov x20, x0
    mov x0, x19
    bl Lclass_name
    LFPUT x20, LFk_reported_class
    mov x0, x19
    bl Lpatch + (0xa664 - PATCH_BASE)
    GET x0, LSdescription
    LFPUT x20, LFk_runtime_class
    GET x19, Lwindow
    mov x23, x0
    GET x19, Lbounds
    mov x2, x23
    GET x19, Lconvert_rect
    bl Lrect_array
    LFPUT x20, LFk_window_rect
    GET x19, LFclips
    and w0, w0, #1
    bl Luint
    LFPUT x20, LFk_clips
    GET x19, Llayer
    mov x21, x0
    GET x21, LFmask
    cmp x0, #0
    cset w0, ne
    bl Luint
    LFPUT x20, LFk_mask
    GET x21, LFcorner_radius
    bl Lnumber
    LFPUT x20, LFk_corner
    mov x0, x19
    bl LFidentity
    bl Luint
    LFPUT x20, LFk_identity
    mov x0, x20
    ldp x23, x24, [sp, #48]
    ldp x21, x22, [sp, #32]
    ldp x19, x20, [sp, #16]
    ldp x29, x30, [sp], #64
    ret

LFdetail: // feed, bar -> one diagnostic dictionary
    stp x29, x30, [sp, #-176]!
    mov x29, sp
    stp x19, x20, [sp, #16]
    stp x21, x22, [sp, #32]
    stp x23, x24, [sp, #48]
    stp x25, x26, [sp, #64]
    mov x19, x0
    mov x21, x1
    bl LFdescribe
    mov x20, x0
    AGET x19, LFstage_key
    LFPUT x20, LFk_stage
    AGET x19, LFstage_key
    GET x0, LXunsigned
    bl LFdecision
    LFPUT x20, LFk_decision
    GET x19, LSframe
    fmov d0, d3
    bl Lnumber
    LFPUT x20, LFk_current_height
    GET x19, LFcontent_inset
    bl Lrect_array
    LFPUT x20, LFk_inset
    AGET x21, LFrecords_key
    mov x1, x19
    bl LFfind
    mov x22, x0
    cmp x22, #0
    cset w0, ne
    bl Luint
    LFPUT x20, LFk_owned
    cbz x22, LFdetail_no_row
    mov x2, #1
    GET x22, Lobject_at
    add x2, sp, #112
    mov x3, #48
    GET x0, LFget_bytes
    ldr d0, [sp, #112]
    bl Lnumber
    LFPUT x20, LFk_original_height
    ldr d0, [sp, #120]
    bl Lnumber
    LFPUT x20, LFk_applied_height
    ldr d0, [sp, #128]
    bl Lnumber
    LFPUT x20, LFk_original_inset
    ldr d0, [sp, #136]
    bl Lnumber
    LFPUT x20, LFk_applied_inset
    b LFdetail_observer
LFdetail_no_row:
    // Stage is the last attempted decision. An old success is not current
    // ownership after restore/detach; state that explicitly in exported logs.
    AGET x19, LFstage_key
    GET x0, LXunsigned
    cmp x0, #1
    b.ne LFdetail_no_row_values
    adr x0, LFdecision_unowned
    bl Lstr
    LFPUT x20, LFk_decision
LFdetail_no_row_values:
    mov x0, #0
    LFPUT x20, LFk_original_height
    mov x0, #0
    LFPUT x20, LFk_applied_height
    mov x0, #0
    LFPUT x20, LFk_original_inset
    mov x0, #0
    LFPUT x20, LFk_applied_inset
LFdetail_observer:
    AGET x19, LFowner_key
    GET x0, LXany_object
    cmp x0, x21
    cset w0, eq
    bl Luint
    LFPUT x20, LFk_observed
    mov x0, x19
    bl Lpatch + (0xa664 - PATCH_BASE)
    mov x26, x0
    adr x0, Llayout_sel
    bl Lpatch + (0xa5a4 - PATCH_BASE)
    mov x1, x0
    mov x0, x26
    bl Lpatch + (0xa5f8 - PATCH_BASE)
    str x0, [sp, #96]
    cbz x0, LFdetail_no_encoding
    bl Lpatch + (0xa5ec - PATCH_BASE)
    cbz x0, LFdetail_no_encoding
    bl Lstr
LFdetail_no_encoding:
    LFPUT x20, LFk_encoding
    ldr x0, [sp, #96]
    cbz x0, LFdetail_no_inherit
    bl Lpatch + (0xa598 - PATCH_BASE)
    str x0, [sp, #104]
    bl LFis_layout_observer
LFdetail_no_inherit:
    mov x25, x0
    bl Luint
    LFPUT x20, LFk_inherits_observer
    mov x0, #0
    cbz x25, LFdetail_runtime_observer
    ldr x8, [sp, #104]
    adr x9, LFfeed_layout
    cmp x8, x9
    cset w0, ne
LFdetail_runtime_observer:
    bl Luint
    LFPUT x20, LFk_runtime_observer
    adr x0, LFfeed_class
    bl Lpatch + (0xa5b0 - PATCH_BASE)
    mov x26, x0
    adr x0, Llayout_sel
    bl Lpatch + (0xa5a4 - PATCH_BASE)
    mov x1, x0
    mov x0, x26
    bl Lpatch + (0xa5f8 - PATCH_BASE)
    cbz x0, LFdetail_no_base_observer
    bl Lpatch + (0xa598 - PATCH_BASE)
    adr x8, LFfeed_layout
    cmp x0, x8
    cset w0, eq
LFdetail_no_base_observer:
    bl Luint
    LFPUT x20, LFk_base_observer
    bl Lnewarray
    mov x23, x0
    GET x19, Lsuperview
    mov x24, x0
    mov x25, #0
LFdetail_ancestors:
    cbz x24, LFdetail_ancestors_done
    cmp x25, #8
    b.hs LFdetail_ancestors_done
    mov x0, x24
    bl LFdescribe
    mov x2, x0
    GET x23, LSadd_object
    GET x24, Lsuperview
    mov x24, x0
    add x25, x25, #1
    b LFdetail_ancestors
LFdetail_ancestors_done:
    mov x0, x23
    LFPUT x20, LFk_ancestors
    cmp x24, #0
    cset w0, ne
    bl Luint
    LFPUT x20, LFk_ancestors_truncated
    mov x0, x20
    ldp x25, x26, [sp, #64]
    ldp x23, x24, [sp, #48]
    ldp x21, x22, [sp, #32]
    ldp x19, x20, [sp, #16]
    ldp x29, x30, [sp], #176
    ret

LFsnapshot: // bar, NSMutableDictionary; called only by the diagnostic capture
    stp x29, x30, [sp, #-80]!
    mov x29, sp
    stp x19, x20, [sp, #16]
    stp x21, x22, [sp, #32]
    stp x23, x24, [sp, #48]
    stp x25, x26, [sp, #64]
    mov x19, x0
    mov x20, x1
    AGET x19, LFcandidates_key
    GET x0, LSall_objects
    mov x21, x0
    GET x21, Lcount
    mov x8, #12
    cmp x0, x8
    csel x22, x0, x8, lo
    bl Lnewarray
    mov x23, x0
    mov x24, #0
LFsnapshot_loop:
    cmp x24, x22
    b.hs LFsnapshot_done
    mov x2, x24
    GET x21, Lobject_at
    mov x1, x19
    bl LFdetail
    mov x2, x0
    GET x23, LSadd_object
    add x24, x24, #1
    b LFsnapshot_loop
LFsnapshot_done:
    mov x0, x23
    LFPUT x20, LFk_diagnostics
    ldp x25, x26, [sp, #64]
    ldp x23, x24, [sp, #48]
    ldp x21, x22, [sp, #32]
    ldp x19, x20, [sp, #16]
    ldp x29, x30, [sp], #80
    ret

// 1.6.0 first-layout observation. Only the three host scroll families actually
// present in the device trace are hooked. UIView/UIScrollView are unchanged.
// The weak registry has at most eight bars and never retains a controller.
LFlifecycle_register: // bar; called as soon as a floating proxy is mounted
    stp x29, x30, [sp, #-64]!
    mov x29, sp
    stp x19, x20, [sp, #16]
    stp x21, x22, [sp, #32]
    mov x19, x0
    cbz x19, LFlifecycle_register_done
    AGET x19, LFlifecycle_active_key
    cbnz x0, LFlifecycle_register_done
    adr x0, Lbar_class
    bl Lpatch + (0xa5b0 - PATCH_BASE)
    mov x20, x0
    cbz x20, LFlifecycle_register_done
    AGET x20, LFlifecycle_bars_key
    mov x21, x0
    cbnz x21, LFlifecycle_register_have
    adr x0, LShash_class
    adr x1, LSweak_hash
    bl Lfactory
    mov x21, x0
    cbz x21, LFlifecycle_register_done
    ASET x20, LFlifecycle_bars_key, x21, 1
LFlifecycle_register_have:
    mov x2, x19
    GET x21, Lcontains
    cbnz w0, LFlifecycle_register_add
    GET x21, Lcount
    cmp x0, #8
    b.hs LFlifecycle_register_done
LFlifecycle_register_add:
    mov x2, x19
    GET x21, LSadd_object
    ASET x19, LFlifecycle_active_key, x19, 0
    // Retry only on a new mount, in case the app loaded a named class late.
    bl LFlifecycle_install
LFlifecycle_register_done:
    ldp x21, x22, [sp, #32]
    ldp x19, x20, [sp, #16]
    ldp x29, x30, [sp], #64
    ret

LFlifecycle_unregister: // bar; weak registry entries may expire naturally
    stp x29, x30, [sp, #-16]!
    mov x29, sp
    ASET x0, LFlifecycle_active_key, xzr, 0
    ldp x29, x30, [sp], #16
    ret

LFlifecycle_bar: // known host scroll -> one mounted visible same-window bar
    stp x29, x30, [sp, #-96]!
    mov x29, sp
    stp x19, x20, [sp, #16]
    stp x21, x22, [sp, #32]
    stp x23, x24, [sp, #48]
    stp x25, x26, [sp, #64]
    mov x19, x0
    mov x26, #0
    GET x19, Lwindow
    mov x20, x0
    cbz x20, LFlifecycle_bar_no
    adr x0, Lbar_class
    bl Lpatch + (0xa5b0 - PATCH_BASE)
    AGET x0, LFlifecycle_bars_key
    GET x0, LSall_objects
    mov x21, x0
    GET x21, Lcount
    cmp x0, #8
    b.hi LFlifecycle_bar_no
    mov x22, x0
    mov x23, #0
LFlifecycle_bar_loop:
    cmp x23, x22
    b.hs LFlifecycle_bar_found
    mov x2, x23
    GET x21, Lobject_at
    mov x24, x0
    AGET x24, LFlifecycle_active_key
    cbz x0, LFlifecycle_bar_next
    GET x24, Lwindow
    cmp x0, x20
    b.ne LFlifecycle_bar_next
    mov x0, x24
    mov x1, x20
    bl Lvisible_to
    cbz w0, LFlifecycle_bar_next
    AGET x24, Lpatch + (0xeb84 - PATCH_BASE)
    mov x1, x0
    mov x0, x24
    bl LXvalid_proxy
    cbz w0, LFlifecycle_bar_next
    GET x24, Lsuperview
    mov x1, x0
    mov x0, x19
    bl Lvisible_to
    cbz w0, LFlifecycle_bar_next
    cbnz x26, LFlifecycle_bar_no // Ambiguous overlapping mounted bars fail closed.
    mov x26, x24
LFlifecycle_bar_next:
    add x23, x23, #1
    b LFlifecycle_bar_loop
LFlifecycle_bar_no:
    mov x26, #0
LFlifecycle_bar_found:
    mov x0, x26
    ldp x25, x26, [sp, #64]
    ldp x23, x24, [sp, #48]
    ldp x21, x22, [sp, #32]
    ldp x19, x20, [sp, #16]
    ldp x29, x30, [sp], #96
    ret

// Install compatible void lifecycle callbacks with immutable original entries.
// Distinct window aliases keep lexical superclass calls from resolving a
// subclass's original again. The layout trampolines already use fixed slots.
LFlifecycle_install:
    stp x29, x30, [sp, #-80]!
    mov x29, sp
    stp x19, x20, [sp, #16]
    stp x21, x22, [sp, #32]
    stp x23, x24, [sp, #48]
    bl LFinstall_base
    cbz w0, LFlifecycle_install_done
    adr x19, LFlifecycle_table
    mov x20, #0
LFlifecycle_install_loop:
    cmp x20, #3
    b.hs LFlifecycle_install_done
    ldr w8, [x19]
    adr x0, Lpatch
    add x0, x0, x8
    bl Lpatch + (0xa5b0 - PATCH_BASE)
    mov x21, x0
    cbz x21, LFlifecycle_install_next
    bl LFdynamic_class_watch
    cbz w0, LFlifecycle_install_next
    adr x0, Lwindow_sel
    bl Lpatch + (0xa5a4 - PATCH_BASE)
    mov x1, x0
    mov x0, x21
    bl Lpatch + (0xa5f8 - PATCH_BASE)
    cbz x0, LFlifecycle_install_next
    bl Lpatch + (0xa5ec - PATCH_BASE)
    mov x22, x0
    cbz x22, LFlifecycle_install_next
    adr x1, Lvoid_encoding
    bl Lpatch + (0xa5e0 - PATCH_BASE)
    cbz w0, LFlifecycle_install_window
    mov x0, x22
    adr x1, LFcompact_void
    bl Lpatch + (0xa5e0 - PATCH_BASE)
    cbnz w0, LFlifecycle_install_next
LFlifecycle_install_window:
    ldr w8, [x19, #4]
    ldr w9, [x19, #8]
    adr x2, Lpatch
    add x3, x2, x9
    add x2, x2, x8
    mov x0, x21
    adr x1, Lwindow_sel
    mov x4, x22
    bl Linstall_method
LFlifecycle_install_next:
    add x20, x20, #1
    add x19, x19, #16
    b LFlifecycle_install_loop
LFlifecycle_install_done:
    ldp x23, x24, [sp, #48]
    ldp x21, x22, [sp, #32]
    ldp x19, x20, [sp, #16]
    ldp x29, x30, [sp], #80
    ret

LFlifecycle_window0:
    mov w2, #0
    b LFlifecycle_window
LFlifecycle_window1:
    mov w2, #1
    b LFlifecycle_window
LFlifecycle_window2:
    mov w2, #2
    b LFlifecycle_window
LFlifecycle_window: // self, original _cmd, lexical class slot
    stp x29, x30, [sp, #-80]!
    mov x29, sp
    stp x19, x20, [sp, #16]
    stp x21, x22, [sp, #32]
    stp x23, x24, [sp, #48]
    mov x19, x0
    mov x20, x1
    mov x24, x2
    // Dynamic layout overrides are wrapped before a host window callback can
    // force its first layout or write a final frame after a superclass call.
    bl LFdynamic_watch
    AGET x19, LFbusy_key
    mov x23, x0
    cbnz x23, LFlifecycle_window_call
    ASET x19, LFbusy_key, x19, 0
LFlifecycle_window_call:
    mov x0, x19
    mov x1, x20
    mov x2, x24
    bl LFlifecycle_window_original
    cbnz x23, LFfeed_done
    b LFfeed_after_original

LFlifecycle_window_original:
    stp x29, x30, [sp, #-64]!
    mov x29, sp
    stp x19, x20, [sp, #16]
    stp x21, x22, [sp, #32]
    stp x23, x24, [sp, #48]
    mov x19, x0
    mov x20, x1
    cmp x2, #3
    b.hs LFlifecycle_window_original_done
    adr x8, LFlifecycle_table
    add x8, x8, x2, lsl #4
    ldr w9, [x8]
    ldr w10, [x8, #4]
    ldr w11, [x8, #8]
    adr x0, Lpatch
    add x22, x0, x10
    add x24, x0, x11
    add x0, x0, x9
    bl Lpatch + (0xa5b0 - PATCH_BASE)
    mov x21, x0
    mov x0, x22
    bl Lpatch + (0xa5a4 - PATCH_BASE)
    mov x1, x0
    mov x0, x21
    bl Lpatch + (0xa5f8 - PATCH_BASE)
    cbz x0, LFlifecycle_window_original_done
    bl Lpatch + (0xa598 - PATCH_BASE)
    cbz x0, LFlifecycle_window_original_done
    cmp x0, x24
    b.eq LFlifecycle_window_original_done
    mov x16, x0
    mov x0, x19
    mov x1, x20
    ldp x23, x24, [sp, #48]
    ldp x21, x22, [sp, #32]
    ldp x19, x20, [sp, #16]
    ldp x29, x30, [sp], #64
    br x16
LFlifecycle_window_original_done:
    ldp x23, x24, [sp, #48]
    ldp x21, x22, [sp, #32]
    ldp x19, x20, [sp, #16]
    ldp x29, x30, [sp], #64
    ret

// Current-view edge refresh; at most sixteen cached rows, no descendant walk.
// Stable layouts allocate nothing. Replaced/offscreen edges release their
// original hidden state without disturbing another scroll's ownership.
LFlifecycle_edge: // known scroll, its bar (caller owns bar busy guard)
    stp x29, x30, [sp, #-128]!
    mov x29, sp
    stp x19, x20, [sp, #16]
    stp x21, x22, [sp, #32]
    stp x23, x24, [sp, #48]
    stp x25, x26, [sp, #64]
    stp x27, x28, [sp, #80]
    mov x19, x0
    mov x20, x1
    mov x24, #0
    AGET x20, Ledge_key
    GET x0, Lretain
    mov x21, x0
    GET x21, Lcount
    cmp x0, #16
    b.hi LFlifecycle_edge_done
    mov x22, x0
    mov x23, #0
    // Original callers without the new registry still retain the old behavior.
    // Mount validity is necessary before taking NEW edge ownership.
    AGET x20, Lpatch + (0xeb84 - PATCH_BASE)
    mov x1, x0
    mov x0, x20
    bl LXvalid_proxy
    cbz w0, LFlifecycle_edge_scan
    GET x20, Lwindow
    mov x1, x0
    mov x0, x20
    bl Lvisible_to
    cbz w0, LFlifecycle_edge_scan
    GET x20, Lsuperview
    mov x2, x0
    mov x1, x20
    mov x0, x19
    bl Leligible
    mov x24, x0
LFlifecycle_edge_scan:
    mov x25, #0
LFlifecycle_edge_scan_loop:
    cmp x23, x22
    b.hs LFlifecycle_edge_scanned
    mov x2, x23
    GET x21, Lobject_at
    mov x26, x0
    mov x2, #0
    GET x26, Lobject_at
    cmp x0, x19
    b.ne LFlifecycle_edge_scan_next
    mov x25, x26
    mov x2, #1
    GET x26, Lobject_at
    cmp x0, x24
    b.eq LFlifecycle_edge_apply // Existing effect; original snapshot is stable.
LFlifecycle_edge_scan_next:
    add x23, x23, #1
    b LFlifecycle_edge_scan_loop
LFlifecycle_edge_scanned:
    orr x8, x24, x25
    cbz x8, LFlifecycle_edge_done
    bl Lnewarray
    mov x27, x0
    mov x23, #0
LFlifecycle_edge_copy:
    cmp x23, x22
    b.hs LFlifecycle_edge_capture
    mov x2, x23
    GET x21, Lobject_at
    mov x26, x0
    mov x2, #0
    GET x26, Lobject_at
    cmp x0, x19
    b.eq LFlifecycle_edge_copy_next
    mov x2, x26
    GET x27, LSadd_object
LFlifecycle_edge_copy_next:
    add x23, x23, #1
    b LFlifecycle_edge_copy
LFlifecycle_edge_capture:
    // Publish before setters can synchronously reenter a framework callback.
    ASET x20, Ledge_key, x27, 1
    cbz x24, LFlifecycle_edge_release
    stp wzr, wzr, [sp, #104]
    stp x27, x21, [sp, #112]
    mov x0, x19
    mov x1, x24
    add x2, sp, #104
    bl Lcapture_edge
LFlifecycle_edge_release:
    mov x0, x21
    mov x1, x27
    bl Lrestore_removed
    b LFlifecycle_edge_done
LFlifecycle_edge_apply:
    cbz x24, LFlifecycle_edge_done
    GET x24, Lis_hidden
    cbnz w0, LFlifecycle_edge_done
    mov w2, #1
    GET x24, Lset_hidden
LFlifecycle_edge_done:
    GET x21, Lrelease
    ldp x27, x28, [sp, #80]
    ldp x25, x26, [sp, #64]
    ldp x23, x24, [sp, #48]
    ldp x21, x22, [sp, #32]
    ldp x19, x20, [sp, #16]
    ldp x29, x30, [sp], #128
    ret

// @COMPONENT_DATA
LFrecords_key: .byte 0
LFnext_key: .byte 0
LFowner_key: .byte 0
LFwatched_key: .byte 0
LFbusy_key: .byte 0
LFimp_key: .byte 0
LFdynamic_classes_key: .byte 0
LFdynamic_slot_key: .byte 0
LForphan_key: .byte 0
LFfeed_class: .asciz "FQFeedListCollectionView"
.if FQ_VERSION >= 0x10704
LFtab_item_class: .asciz "SSTabBarButtonItem"
LFtab_item_type: .asciz "type"
.endif
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
LFlayout_alias: .asciz "fqab_feed159_originalLayout"
LFcompact_void: .asciz "v@:"
.p2align 3
LFstable_epsilon: .double 0.000001
.p2align 2
LFcandidates_key: .byte 0
LFstage_key: .byte 0
LFk_diagnostics: .asciz "feedViewportDiagnostics"
LFk_reported_class: .asciz "reportedClass"
LFk_runtime_class: .asciz "runtimeClass"
LFk_window_rect: .asciz "windowRect"
LFk_clips: .asciz "clipsToBounds"
LFk_mask: .asciz "hasLayerMask"
LFk_corner: .asciz "cornerRadius"
LFk_identity: .asciz "identityTransform"
LFk_stage: .asciz "rejectionStage"
LFk_decision: .asciz "decision"
LFk_current_height: .asciz "currentHeight"
LFk_original_height: .asciz "originalHeight"
LFk_applied_height: .asciz "appliedHeight"
LFk_inset: .asciz "contentInset"
LFk_original_inset: .asciz "originalInsetBottom"
LFk_applied_inset: .asciz "appliedInsetBottom"
LFk_owned: .asciz "currentlyOwned"
LFk_observed: .asciz "observedByThisBar"
LFk_base_observer: .asciz "baseLayoutObserverInstalled"
LFk_inherits_observer: .asciz "inheritsLayoutObserver"
LFk_runtime_observer: .asciz "runtimeLayoutObserverInstalled"
LFk_encoding: .asciz "layoutMethodEncoding"
LFk_ancestors: .asciz "ancestors"
LFk_ancestors_truncated: .asciz "ancestorsTruncated"
LFdecision_unknown: .asciz "unobserved"
LFdecision_applied: .asciz "applied"
LFdecision_scope: .asciz "missing-scope-or-other-owner"
LFdecision_tab: .asciz "unsupported-tab"
LFdecision_proxy: .asciz "invalid-floating-proxy"
LFdecision_visibility: .asciz "hidden-detached-or-different-window"
LFdecision_bar: .asciz "invalid-bar-or-window-geometry"
LFdecision_feed: .asciz "unsafe-feed-geometry"
LFdecision_baseline: .asciz "invalid-inset-baseline-or-content"
LFdecision_ancestors: .asciz "unsafe-ancestor-or-no-covering-outer"
LFdecision_outer: .asciz "outer-viewport-or-extension-mismatch"
LFdecision_observer: .asciz "layout-observer-unavailable"
LFdecision_above_outer: .asciz "ancestor-above-outer-clip-mask-or-transform"

.p2align 2

LFlifecycle_bars_key: .byte 0
LFlifecycle_active_key: .byte 0
LFlifecycle_nested_class: .asciz "SSNestedContainerScrollView"
LFlifecycle_bookstore_class: .asciz "SSBookStoreUnlimitedContainerView"
LFlifecycle_feed_window_alias: .asciz "fqab_feed160_originalWindow"
LFlifecycle_nested_window_alias: .asciz "fqab_nested160_originalWindow"
LFlifecycle_bookstore_window_alias: .asciz "fqab_bookstore160_originalWindow"
.p2align 2
LFlifecycle_table:
    .long LFfeed_class - Lpatch, LFlifecycle_feed_window_alias - Lpatch
    .long LFlifecycle_window0 - Lpatch, 0
    .long LFlifecycle_nested_class - Lpatch, LFlifecycle_nested_window_alias - Lpatch
    .long LFlifecycle_window1 - Lpatch, 0
    .long LFlifecycle_bookstore_class - Lpatch, LFlifecycle_bookstore_window_alias - Lpatch
    .long LFlifecycle_window2 - Lpatch, 0

LFdecision_unowned: .asciz "previously-applied-now-unowned"
