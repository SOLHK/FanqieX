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

// @COMPONENT_DATA
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
