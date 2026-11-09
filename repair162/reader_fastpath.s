// Reader-only settled layout and bounded traversal. Reader-top controls keep
// their original host artwork, layout and actions in 1.6.2. Historical symbol
// snapshots below are retained only to make owned-state cleanup reversible.
// Entry patch: 0x5d50 (after the real reader layout returned) -> LRreader_panel.
// No host touch method, control frame, target/action, or accessibility value
// is changed. Decorations always remain noninteractive.

.macro LRNEAR lhs, rhs, failure
    fsub d6, \lhs, \rhs
    FINITE d6, \failure
    fabs d6, d6
    ldr d7, LRcenter_epsilon
    fcmp d6, d7
    b.hi \failure
.endm

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

// Resolve only the leading compact control inside the FQ reader family. This
// runs before scanning; it never guesses at glyph data that may still be stale.
LRleading_owner: // control -> FQ navigation owner or nil
    stp x29, x30, [sp, #-64]!
    mov x29, sp
    stp x19, x20, [sp, #16]
    stp x21, x22, [sp, #32]
    stp d8, d9, [sp, #48]
    mov x19, x0
    adr x1, LGcontrol_class
    bl Lpatch + (0x7394 - PATCH_BASE)
    cbz w0, LRleading_no
    mov x20, x19
    mov w21, #7
LRleading_loop:
    cbz x20, LRleading_no
    mov x0, x20
    adr x1, LGreader_nav
    bl Lpatch + (0x7394 - PATCH_BASE)
    cbnz w0, LRleading_found
    subs w21, w21, #1
    b.eq LRleading_no
    GET x20, LGsuperview
    mov x20, x0
    b LRleading_loop
LRleading_found:
    mov x0, x19
    mov x1, x20
    bl LRis_leading
    cbz w0, LRleading_no
    mov x0, x20
    b LRleading_done
LRleading_no:
    mov x0, #0
LRleading_done:
    ldp d8, d9, [sp, #48]
    ldp x21, x22, [sp, #32]
    ldp x19, x20, [sp, #16]
    ldp x29, x30, [sp], #64
    ret

LRis_leading: // compact view, reader owner -> BOOL in owner's layout direction
    stp x29, x30, [sp, #-64]!
    mov x29, sp
    stp x19, x20, [sp, #16]
    stp d8, d9, [sp, #32]
    mov x19, x0
    mov x20, x1
    GET x19, LGbounds
    mov x2, x20
    GET x19, LGconvert_rect
    FINITE d0, LRis_leading_no
    FINITE d2, LRis_leading_no
    fcmp d2, #0.0
    b.le LRis_leading_no
    ldr d4, LRleading_limit
    fcmp d2, d4
    b.gt LRis_leading_no
    fmov d4, #0.5
    fmul d2, d2, d4
    fadd d8, d0, d2
    GET x20, LGbounds
    FINITE d0, LRis_leading_no
    FINITE d2, LRis_leading_no
    fcmp d2, #0.0
    b.le LRis_leading_no
    fsub d8, d8, d0
    fmov d9, d2
    fcmp d8, #0.0
    b.lt LRis_leading_no
    fcmp d8, d9
    b.gt LRis_leading_no
    GET x20, LGdirection
    cmp w0, #1
    b.ne LRis_leading_limit
    fsub d8, d9, d8
LRis_leading_limit:
    fmov d4, #0.25
    fmul d9, d9, d4
    ldr d4, LRleading_limit
    fmin d9, d9, d4
    fcmp d8, d9
    b.gt LRis_leading_no
    mov w0, #1
    b LRis_leading_done
LRis_leading_no:
    mov w0, #0
LRis_leading_done:
    ldp d8, d9, [sp, #32]
    ldp x19, x20, [sp, #16]
    ldp x29, x30, [sp], #64
    ret

LRvisible: // descendant, owner -> BOOL; checks every ancestor, bounded to 7
    stp x29, x30, [sp, #-48]!
    mov x29, sp
    stp x19, x20, [sp, #16]
    stp x21, x22, [sp, #32]
    mov x19, x0
    mov x20, x1
    mov w21, #7
LRvisible_loop:
    cbz x19, LRvisible_no
    GET x19, LGhidden
    cbnz w0, LRvisible_no
    GET x19, LGalpha
    FINITE d0, LRvisible_no
    fcmp d0, #0.0
    b.le LRvisible_no
    cmp x19, x20
    b.eq LRvisible_yes
    subs w21, w21, #1
    b.eq LRvisible_no
    GET x19, LGsuperview
    mov x19, x0
    b LRvisible_loop
LRvisible_yes:
    mov w0, #1
    b LRvisible_done
LRvisible_no:
    mov w0, #0
LRvisible_done:
    ldp x21, x22, [sp, #32]
    ldp x19, x20, [sp, #16]
    ldp x29, x30, [sp], #48
    ret

// Consume an already-pending descendant layout BEFORE measuring its image.
// No setNeedsLayout and no UIButton/UIImageView global hook. The surrounding
// LGstyle_control busy marker is already set, so synchronous reentry is inert.
LRsettle_control:
    stp x29, x30, [sp, #-32]!
    mov x29, sp
    stp x19, x20, [sp, #16]
    mov x19, x0
    bl LRleading_owner
    cbz x0, LRsettle_done
    mov x1, x0
    mov x0, x19
    bl LRvisible
    cbz w0, LRsettle_done
    GET x19, LRlayout_if_needed
LRsettle_done:
    ldp x19, x20, [sp, #16]
    ldp x29, x30, [sp], #32
    ret

// Only centers that still equal our last installed value are restored. Host
// layout or user code changing center always wins; no transform is assigned.
LRback_restore: // UIImageView; restore only values still owned by this patch
    stp x29, x30, [sp, #-80]!
    mov x29, sp
    stp x19, x20, [sp, #16]
    stp d8, d9, [sp, #32]
    stp d10, d11, [sp, #48]
    mov x19, x0
    cbz x19, LRrestore_done
    // UIKit owns UIButton.imageView state. Restore the button's public state
    // images/alignment first, then reconcile independently owned image fields.
    AGET x19, LRback_control_key
    GET x0, LXany_object
    mov x1, x19
    bl LRmanaged_restore
    AGET x19, LRnative_image_key
    mov x20, x0
    cbz x20, LRrestore_center
    GET x19, LGimage
    cmp x0, x20
    b.ne LRrestore_mode
    AGET x19, LRback_image_key
    mov x2, x0
    GET x19, LRset_image
LRrestore_mode:
    GET x19, LGcontent_mode
    cmp w0, #4
    b.ne LRrestore_center
    AGET x19, LRback_mode_key
    cbz x0, LRrestore_center
    GET x0, LRunsigned
    mov x2, x0
    GET x19, LRset_mode
LRrestore_center:
    AGET x19, LRback_owned_key
    mov x20, x0
    cbz x20, LRrestore_clear
    GET x19, LRcenter
    fmov d8, d0
    fmov d9, d1
    GET x20, LRpoint_value
    LRNEAR d0, d8, LRrestore_clear
    LRNEAR d1, d9, LRrestore_clear
    AGET x19, LRback_original_key
    cbz x0, LRrestore_clear
    GET x0, LRpoint_value
    GET x19, LRset_center
LRrestore_clear:
    ASET x19, LRback_owned_key, xzr, 0
    ASET x19, LRback_original_key, xzr, 0
    ASET x19, LRback_owner_key, xzr, 0
    ASET x19, LRback_control_key, xzr, 0
    ASET x19, LRback_image_key, xzr, 0
    ASET x19, LRback_mode_key, xzr, 0
    ASET x19, LRnative_image_key, xzr, 0
LRrestore_done:
    ldp d10, d11, [sp, #48]
    ldp d8, d9, [sp, #32]
    ldp x19, x20, [sp, #16]
    ldp x29, x30, [sp], #80
    ret

LRcontrol_restore: // root control -> restore its last weakly owned icon
    stp x29, x30, [sp, #-32]!
    mov x29, sp
    stp x19, x20, [sp, #16]
    mov x19, x0
    AGET x19, LRcontrol_image_key
    GET x0, LXany_object
    mov x20, x0
    cbz x20, LRcontrol_restore_clear
    AGET x20, LRback_control_key
    GET x0, LXany_object
    cmp x0, x19
    b.ne LRcontrol_restore_clear
    mov x0, x20
    bl LRback_restore
LRcontrol_restore_clear:
    ASET x19, LRcontrol_image_key, xzr, 0
    ldp x19, x20, [sp, #16]
    ldp x29, x30, [sp], #32
    ret

// A reused image can move to another control or become a standalone gesture
// view before its former owner receives any callback. Revoke that old offset
// while LGscan has not yet measured the new role. A current host-set centre
// still wins through LRback_restore's conditional ownership check.
LRreconcile_back: // image, current scan root
    stp x29, x30, [sp, #-32]!
    mov x29, sp
    stp x19, x20, [sp, #16]
    mov x19, x0
    mov x20, x1
    AGET x19, LRback_control_key
    cbz x0, LRreconcile_done
    GET x0, LXany_object
    cbz x0, LRreconcile_restore
    cmp x0, x20
    b.eq LRreconcile_done
LRreconcile_restore:
    mov x0, x19
    bl LRback_restore
LRreconcile_done:
    ldp x19, x20, [sp, #16]
    ldp x29, x30, [sp], #32
    ret

// UIView.transform is a six-double struct: the ABI uses x8 for its result.
// Do not call through Lmessage, which legitimately clobbers caller-saved x8.
LRidentity: // view -> BOOL, no transform mutation
    stp x29, x30, [sp, #-80]!
    mov x29, sp
    stp x19, x20, [sp, #16]
    mov x19, x0
    adr x0, LRtransform
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
    b.ne LRidentity_no
    fcmp d3, d6
    b.ne LRidentity_no
    fcmp d1, #0.0
    b.ne LRidentity_no
    fcmp d2, #0.0
    b.ne LRidentity_no
    fcmp d4, #0.0
    b.ne LRidentity_no
    fcmp d5, #0.0
    b.ne LRidentity_no
    mov w0, #1
    b LRidentity_done
LRidentity_no:
    mov w0, #0
LRidentity_done:
    ldp x19, x20, [sp, #16]
    ldp x29, x30, [sp], #80
    ret

// Coordinate conversion and subtraction may differ by an ulp on a repeated
// pass. Preserve the exact installed rectangle within a sub-micropoint
// tolerance before the original material helper's strict equality check.
// Continue calling that helper so its other lifecycle work is preserved.
LRstable_rect: // existing decoration or nil, desired CGRect -> stable CGRect
    stp x29, x30, [sp, #-80]!
    mov x29, sp
    stp x19, x20, [sp, #16]
    stp d8, d9, [sp, #32]
    stp d10, d11, [sp, #48]
    mov x19, x0
    fmov d8, d0
    fmov d9, d1
    fmov d10, d2
    fmov d11, d3
    cbz x19, LRstable_original
    GET x19, LSframe
    LRNEAR d0, d8, LRstable_original
    LRNEAR d1, d9, LRstable_original
    LRNEAR d2, d10, LRstable_original
    LRNEAR d3, d11, LRstable_original
    b LRstable_done
LRstable_original:
    fmov d0, d8
    fmov d1, d9
    fmov d2, d10
    fmov d3, d11
LRstable_done:
    mov x0, x19
    ldp d10, d11, [sp, #48]
    ldp d8, d9, [sp, #32]
    ldp x19, x20, [sp, #16]
    ldp x29, x30, [sp], #80
    ret

// Resolve CoreImage without adding an unbound import to the original Mach-O.
// A failed framework load is cached on UIImage; it is not retried per layout.
// Public SF Symbol, cached once per UIImage class. This path never creates a
// CIContext, loads CoreImage, reads a bitmap, or blocks on a renderer. 1.5.9
// reason 18 on the actual device made bitmap calibration an unsafe prerequisite
// for centering. Native symbol metrics remove that dependency completely.
LRnative_symbol:
    stp x29, x30, [sp, #-48]!
    mov x29, sp
    stp x19, x20, [sp, #16]
    stp x21, x22, [sp, #32]
    adr x0, LGimage_resource_class
    bl Lpatch + (0xa5b0 - PATCH_BASE)
    mov x19, x0
    cbz x19, LRsymbol_nil
    AGET x19, LRnative_symbol_key
    cbnz x0, LRsymbol_done
    mov x0, x19
    adr x1, LRsystem_image
    bl LRresponds
    cbz w0, LRsymbol_nil
    adr x0, LRsymbol_configuration
    bl Lpatch + (0xa5b0 - PATCH_BASE)
    mov x20, x0
    cbz x20, LRsymbol_nil
    adr x1, LRpoint_configuration
    bl LRresponds
    cbz w0, LRsymbol_nil
    fmov d0, #22.0
    GET x20, LRpoint_configuration
    mov x21, x0
    cbz x21, LRsymbol_nil
    adr x0, LRback_symbol
    bl Lstr
    mov x2, x0
    mov x3, x21
    GET x19, LRsystem_image
    mov x22, x0
    cbz x22, LRsymbol_nil
    ASET x19, LRnative_symbol_key, x22, 1
    mov x0, x22
    b LRsymbol_done
LRsymbol_nil:
    mov x0, #0
LRsymbol_done:
    ldp x21, x22, [sp, #32]
    ldp x19, x20, [sp, #16]
    ldp x29, x30, [sp], #48
    ret

// A UIKit-managed UIButton.imageView is driven by button state and can be
// rewritten by highlight/layout after the parent's callback. Use the public
// UIButton state APIs ONLY when imageView identity proves that relationship.
// Custom child UIImageViews continue down the independent image path.
LRmanaged_apply: // root, image view, native image -> BOOL
    stp x29, x30, [sp, #-176]!
    mov x29, sp
    stp x19, x20, [sp, #16]
    stp x21, x22, [sp, #32]
    stp x23, x24, [sp, #48]
    stp x25, x26, [sp, #64]
    stp x27, x28, [sp, #80]
    mov x19, x0
    mov x20, x1
    mov x21, x2
    adr x1, LRbutton_class
    bl Lpatch + (0x7394 - PATCH_BASE)
    cbz w0, LRmanaged_apply_yes
    GET x19, LRbutton_image_view
    cmp x0, x20
    b.ne LRmanaged_apply_yes
    bl Lnewarray
    mov x22, x0
    cbz x22, LRmanaged_apply_no
    adr x0, LSnull_class
    adr x1, LSnull
    bl Lfactory
    mov x24, x0
    cbz x24, LRmanaged_apply_no
    mov x23, #0
LRmanaged_capture_images:
    mov x2, x23
    GET x19, LRimage_for_state
    cbnz x0, LRmanaged_capture_image
    mov x0, x24
LRmanaged_capture_image:
    mov x2, x0
    GET x22, LSadd_object
    add x23, x23, #1
    cmp x23, #8
    b.lo LRmanaged_capture_images
    GET x19, LRhorizontal_alignment
    bl Luint
    mov x25, x0
    cbz x25, LRmanaged_apply_no
    GET x19, LRvertical_alignment
    bl Luint
    mov x26, x0
    cbz x26, LRmanaged_apply_no
    GET x19, LRimage_insets
    stp d0, d1, [sp, #96]
    stp d2, d3, [sp, #112]
    adr x0, LGvalue_class
    bl Lpatch + (0xa5b0 - PATCH_BASE)
    ldp d0, d1, [sp, #96]
    ldp d2, d3, [sp, #112]
    adr x1, LRvalue_rect
    bl Lmessage
    mov x27, x0
    cbz x27, LRmanaged_apply_no
    GET x19, LRcontent_insets
    stp d0, d1, [sp, #128]
    stp d2, d3, [sp, #144]
    adr x0, LGvalue_class
    bl Lpatch + (0xa5b0 - PATCH_BASE)
    ldp d0, d1, [sp, #128]
    ldp d2, d3, [sp, #144]
    adr x1, LRvalue_rect
    bl Lmessage
    mov x28, x0
    cbz x28, LRmanaged_apply_no
    // Root already holds a weakly owned icon in LRcontrol_image_key. All new
    // state has been allocated before setImage:forState: can invalidate UIKit.
    ASET x19, LRmanaged_images_key, x22, 1
    ASET x19, LRmanaged_native_key, x21, 1
    ASET x19, LRmanaged_horizontal_key, x25, 1
    ASET x19, LRmanaged_vertical_key, x26, 1
    ASET x19, LRmanaged_image_insets_key, x27, 1
    ASET x19, LRmanaged_content_insets_key, x28, 1
    mov x23, #0
LRmanaged_set_images:
    mov x2, x21
    mov x3, x23
    GET x19, LRset_image_for_state
    add x23, x23, #1
    cmp x23, #8
    b.lo LRmanaged_set_images
    mov w2, #0
    GET x19, LRset_horizontal_alignment
    mov w2, #0
    GET x19, LRset_vertical_alignment
    fmov d0, xzr
    fmov d1, xzr
    fmov d2, xzr
    fmov d3, xzr
    GET x19, LRset_image_insets
    fmov d0, xzr
    fmov d1, xzr
    fmov d2, xzr
    fmov d3, xzr
    GET x19, LRset_content_insets
LRmanaged_apply_yes:
    mov w0, #1
    b LRmanaged_apply_done
LRmanaged_apply_no:
    mov w0, #0
LRmanaged_apply_done:
    ldp x27, x28, [sp, #80]
    ldp x25, x26, [sp, #64]
    ldp x23, x24, [sp, #48]
    ldp x21, x22, [sp, #32]
    ldp x19, x20, [sp, #16]
    ldp x29, x30, [sp], #176
    ret

LRmanaged_restore: // root, expected image view
    stp x29, x30, [sp, #-96]!
    mov x29, sp
    stp x19, x20, [sp, #16]
    stp x21, x22, [sp, #32]
    stp x23, x24, [sp, #48]
    stp x25, x26, [sp, #64]
    mov x19, x0
    mov x20, x1
    cbz x19, LRmanaged_restore_done
    AGET x19, LRmanaged_native_key
    mov x21, x0
    cbz x21, LRmanaged_restore_done
    AGET x19, LRcontrol_image_key
    GET x0, LXany_object
    cmp x0, x20
    b.ne LRmanaged_restore_done
    AGET x19, LRmanaged_images_key
    mov x22, x0
    cbz x22, LRmanaged_restore_done
    adr x0, LSnull_class
    adr x1, LSnull
    bl Lfactory
    mov x24, x0
    mov x23, #0
LRmanaged_restore_images:
    mov x2, x23
    GET x19, LRimage_for_state
    cmp x0, x21
    b.ne LRmanaged_restore_next
    mov x2, x23
    GET x22, LGobject_at
    cmp x0, x24
    b.ne LRmanaged_restore_image
    mov x0, #0
LRmanaged_restore_image:
    mov x2, x0
    mov x3, x23
    GET x19, LRset_image_for_state
LRmanaged_restore_next:
    add x23, x23, #1
    cmp x23, #8
    b.lo LRmanaged_restore_images
    GET x19, LRhorizontal_alignment
    cbnz w0, LRmanaged_restore_vertical
    AGET x19, LRmanaged_horizontal_key
    GET x0, LRunsigned
    mov x2, x0
    GET x19, LRset_horizontal_alignment
LRmanaged_restore_vertical:
    GET x19, LRvertical_alignment
    cbnz w0, LRmanaged_restore_image_insets
    AGET x19, LRmanaged_vertical_key
    GET x0, LRunsigned
    mov x2, x0
    GET x19, LRset_vertical_alignment
LRmanaged_restore_image_insets:
    GET x19, LRimage_insets
    fcmp d0, #0.0
    b.ne LRmanaged_restore_content_insets
    fcmp d1, #0.0
    b.ne LRmanaged_restore_content_insets
    fcmp d2, #0.0
    b.ne LRmanaged_restore_content_insets
    fcmp d3, #0.0
    b.ne LRmanaged_restore_content_insets
    AGET x19, LRmanaged_image_insets_key
    GET x0, LRrect_value
    GET x19, LRset_image_insets
LRmanaged_restore_content_insets:
    GET x19, LRcontent_insets
    fcmp d0, #0.0
    b.ne LRmanaged_restore_clear
    fcmp d1, #0.0
    b.ne LRmanaged_restore_clear
    fcmp d2, #0.0
    b.ne LRmanaged_restore_clear
    fcmp d3, #0.0
    b.ne LRmanaged_restore_clear
    AGET x19, LRmanaged_content_insets_key
    GET x0, LRrect_value
    GET x19, LRset_content_insets
LRmanaged_restore_clear:
    ASET x19, LRmanaged_images_key, xzr, 0
    ASET x19, LRmanaged_native_key, xzr, 0
    ASET x19, LRmanaged_horizontal_key, xzr, 0
    ASET x19, LRmanaged_vertical_key, xzr, 0
    ASET x19, LRmanaged_image_insets_key, xzr, 0
    ASET x19, LRmanaged_content_insets_key, xzr, 0
LRmanaged_restore_done:
    ldp x25, x26, [sp, #64]
    ldp x23, x24, [sp, #48]
    ldp x21, x22, [sp, #32]
    ldp x19, x20, [sp, #16]
    ldp x29, x30, [sp], #96
    ret

// Known leading reader back image only. The host control, target, actions,
// accessibility and hit rect remain untouched. The native image is centered
// inside that real control, with public alignment insets used for its optical
// envelope. All reversible snapshots exist before the first UIKit mutation.
LRback_prepare:
    stp x29, x30, [sp, #-256]!
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
    ldr x8, [x20, #56]
    cmp x8, #1
    b.ne LRprepare_restore
    ldr x8, [x20, #48]
    cbnz x8, LRprepare_restore
    ldr x21, [x20, #80]
    cbz x21, LRprepare_restore
    mov x23, x19
    mov w25, #7
LRprepare_owner_loop:
    cbz x23, LRprepare_restore
    mov x0, x23
    adr x1, LGreader_nav
    bl Lpatch + (0x7394 - PATCH_BASE)
    cbnz w0, LRprepare_owner_found
    subs w25, w25, #1
    b.eq LRprepare_restore
    GET x23, LGsuperview
    mov x23, x0
    b LRprepare_owner_loop
LRprepare_owner_found:
    mov x0, x19
    mov x1, x23
    bl LRis_leading
    cbz w0, LRprepare_restore
    mov x0, x23
    adr x1, LGback_selector
    bl LRresponds
    cbz w0, LRprepare_identity
    GET x23, LGback_selector
    cbz x0, LRprepare_restore
    cmp x0, x19
    b.eq LRprepare_identity
    cmp x0, x21
    b.eq LRprepare_identity
    mov x1, x19
    bl LRbelongs
    cbz w0, LRprepare_restore
LRprepare_identity:
    bl LRenabled
    cbz w0, LRprepare_restore
    mov x0, x21
    mov x1, x23
    bl LRvisible
    cbz w0, LRprepare_restore
    GET x21, LRanimating
    cbnz w0, LRprepare_restore
    GET x21, LRhighlighted
    cbz w0, LRprepare_transform
    GET x21, LRhighlighted_image
    cbnz x0, LRprepare_restore
LRprepare_transform:
    mov x25, x21
    mov w26, #7
LRprepare_transform_loop:
    mov x0, x25
    bl LRidentity
    cbz w0, LRprepare_restore
    cmp x25, x23
    b.eq LRprepare_symbol
    subs w26, w26, #1
    b.eq LRprepare_restore
    GET x25, LGsuperview
    mov x25, x0
    cbz x25, LRprepare_restore
    b LRprepare_transform_loop
LRprepare_symbol:
    bl LRnative_symbol
    mov x24, x0
    cbz x24, LRprepare_restore
    GET x24, LGsize
    FINITE d0, LRprepare_restore
    FINITE d1, LRprepare_restore
    fcmp d0, #0.0
    b.le LRprepare_restore
    fcmp d1, #0.0
    b.le LRprepare_restore
    fmov d12, d0
    fmov d13, d1
    GET x21, LGbounds
    FINITE d0, LRprepare_restore
    FINITE d1, LRprepare_restore
    FINITE d2, LRprepare_restore
    FINITE d3, LRprepare_restore
    fcmp d2, d12
    b.lt LRprepare_restore
    fcmp d3, d13
    b.lt LRprepare_restore
    fmov d4, #0.5
    fmul d2, d2, d4
    fmul d3, d3, d4
    fadd d8, d0, d2          // UIImageView bounds centre
    fadd d9, d1, d3
    fmul d2, d12, d4
    fmul d3, d13, d4
    fsub d0, d8, d2
    fsub d1, d9, d3
    fmov d2, d12
    fmov d3, d13
    mov x0, x24
    bl LRimage_alignment
    fmov d4, #0.5
    fmul d2, d2, d4
    fmul d3, d3, d4
    fadd d0, d0, d2
    fadd d1, d1, d3
    fsub d10, d0, d8        // public optical inset compensation
    fsub d11, d1, d9
    GET x24, LRflips_rtl
    cbz w0, LRprepare_target
    GET x21, LGdirection
    cmp w0, #1
    b.ne LRprepare_target
    fmov d4, xzr
    fsub d10, d4, d10
LRprepare_target:
    // A standalone glyph carries its own hit area. Keep its view centre;
    // centre only the new image inside its current bounds.
    cmp x19, x21
    b.ne LRprepare_control_target
    GET x21, LRcenter
    fmov d14, d0
    fmov d15, d1
    b LRprepare_target_ready
LRprepare_control_target:
    GET x19, LGbounds
    fmov d4, #0.5
    fmul d2, d2, d4
    fmul d3, d3, d4
    fadd d8, d0, d2
    fadd d9, d1, d3
    GET x21, LGsuperview
    mov x2, x0
    fmov d0, d8
    fmov d1, d9
    fmov d2, xzr
    fmov d3, xzr
    GET x19, LGconvert_rect
    fsub d14, d0, d10
    fsub d15, d1, d11
LRprepare_target_ready:
    FINITE d14, LRprepare_restore
    FINITE d15, LRprepare_restore
    GET x21, LGimage
    cmp x0, x24
    b.ne LRprepare_snapshot
    GET x21, LGcontent_mode
    cmp w0, #4
    b.ne LRprepare_snapshot
    GET x21, LRcenter
    LRNEAR d0, d14, LRprepare_snapshot
    LRNEAR d1, d15, LRprepare_snapshot
    AGET x21, LRback_control_key
    GET x0, LXany_object
    cmp x0, x19
    b.ne LRprepare_snapshot
    AGET x21, LRback_owner_key
    GET x0, LXany_object
    cmp x0, x23
    b.eq LRprepare_rescan
LRprepare_snapshot:
    // Reconcile a host rewrite first; do not restore a value changed by host.
    mov x0, x21
    bl LRback_restore
    GET x21, LGimage
    mov x22, x0
    cbz x22, LRprepare_restore
    GET x21, LRcenter
    fmov d8, d0
    fmov d9, d1
    adr x0, LGvalue_class
    bl Lpatch + (0xa5b0 - PATCH_BASE)
    fmov d0, d8
    fmov d1, d9
    adr x1, LRvalue_point
    bl Lmessage
    str x0, [sp, #160]
    cbz x0, LRprepare_restore
    adr x0, LGvalue_class
    bl Lpatch + (0xa5b0 - PATCH_BASE)
    fmov d0, d14
    fmov d1, d15
    adr x1, LRvalue_point
    bl Lmessage
    str x0, [sp, #168]
    cbz x0, LRprepare_restore
    GET x21, LGcontent_mode
    bl Luint
    str x0, [sp, #176]
    cbz x0, LRprepare_restore
    mov x0, x23
    bl LRweak_box
    mov x25, x0
    cbz x25, LRprepare_restore
    mov x0, x19
    bl LRweak_box
    mov x26, x0
    cbz x26, LRprepare_restore
    mov x0, x21
    bl LRweak_box
    mov x27, x0
    cbz x27, LRprepare_restore
    AGET x23, LRowner_back_key
    GET x0, LXany_object
    cbz x0, LRprepare_commit
    cmp x0, x21
    b.eq LRprepare_commit
    bl LRback_restore
LRprepare_commit:
    ldr x0, [sp, #160]
    ASET x21, LRback_original_key, x0, 1
    ldr x0, [sp, #168]
    ASET x21, LRback_owned_key, x0, 1
    ldr x0, [sp, #176]
    ASET x21, LRback_mode_key, x0, 1
    ASET x21, LRback_image_key, x22, 1
    ASET x21, LRnative_image_key, x24, 1
    ASET x21, LRback_owner_key, x25, 1
    ASET x21, LRback_control_key, x26, 1
    ASET x23, LRowner_back_key, x27, 1
    ASET x19, LRcontrol_image_key, x27, 1
    mov x0, x19
    mov x1, x21
    mov x2, x24
    bl LRmanaged_apply
    cbz w0, LRprepare_restore
    mov x2, x24
    GET x21, LRset_image
    mov w2, #4
    GET x21, LRset_mode
    LRNEAR d14, d8, LRprepare_set_center
    LRNEAR d15, d9, LRprepare_set_center
    b LRprepare_log
LRprepare_set_center:
    fmov d0, d14
    fmov d1, d15
    GET x21, LRset_center
LRprepare_log:
    fsub d0, d14, d8
    fsub d1, d15, d9
    mov x0, x19
    mov x1, x24
    mov w2, #20             // system chevron; no pixel read attempted
    mov x3, x21
    bl LRback_log
LRprepare_rescan:
    stp xzr, xzr, [x20]
    stp xzr, xzr, [x20, #16]
    stp xzr, xzr, [x20, #32]
    stp xzr, xzr, [x20, #48]
    mov x8, #32
    stp x8, xzr, [x20, #64]
    str xzr, [x20, #80]
    mov x0, x19
    mov x1, x19
    mov x2, x20
    mov w3, #3
    bl LGscan
    ldr x25, [x20, #80]
    cbz x25, LRprepare_done
    cmp x25, x19
    b.eq LRprepare_done
    AGET x25, LRnative_image_key
    mov x26, x0
    cbz x26, LRprepare_done
    GET x25, LGimage
    cmp x0, x26
    b.ne LRprepare_done
    // Native back geometry is anchored to the real control centre. Public
    // asymmetric/RTL symbol metrics compensate the icon, never move the glass.
    ldp d4, d5, [x20]
    ldp d6, d7, [x20, #16]
    fsub d6, d6, d4
    fsub d7, d7, d5
    stp d6, d7, [sp, #184]
    GET x19, LGbounds
    fmov d4, #0.5
    fmul d2, d2, d4
    fmul d3, d3, d4
    fadd d0, d0, d2
    fadd d1, d1, d3
    ldp d6, d7, [sp, #184]
    fmul d6, d6, d4
    fmul d7, d7, d4
    fsub d2, d0, d6
    fsub d3, d1, d7
    fadd d0, d0, d6
    fadd d1, d1, d7
    stp d2, d3, [x20]
    stp d0, d1, [x20, #16]
    b LRprepare_done
LRprepare_restore:
    AGET x19, LRcontrol_image_key
    GET x0, LXany_object
    mov x25, x0
    mov x0, x19
    bl LRcontrol_restore
    cbnz x25, LRprepare_rescan
LRprepare_done:
    ldp d14, d15, [sp, #144]
    ldp d12, d13, [sp, #128]
    ldp d10, d11, [sp, #112]
    ldp d8, d9, [sp, #96]
    ldp x27, x28, [sp, #80]
    ldp x25, x26, [sp, #64]
    ldp x23, x24, [sp, #48]
    ldp x21, x22, [sp, #32]
    ldp x19, x20, [sp, #16]
    ldp x29, x30, [sp], #256
    ret

// One record per image/reason transition, never a per-frame tree dump.
// Reason: 0 centered child, 1 noCGImage, 2 invalid/unavailable orientation,
// 3 size,
// 4 framework missing, 5 context missing, 6 storage failure, 7 transparent,
// 8 transform, 9 interactive child, 10 excessive shift, 11 standalone glass,
// 12 hidden hierarchy, 13 capInsets, 14 animation, 15 alternate highlighted
// image, 16 clipped draw envelope, 18 unsupported bitmap row calibration,
// 19 proposed pixels clipped or masked by an ancestor.
LRback_log: // root, UIImage, reason, UIImageView, shifts d0/d1
    stp x29, x30, [sp, #-80]!
    mov x29, sp
    stp x19, x20, [sp, #16]
    stp x21, x22, [sp, #32]
    stp x23, x24, [sp, #48]
    stp d8, d9, [sp, #64]
    mov x19, x0
    mov x20, x1
    mov w21, w2
    mov x24, x3
    fmov d8, d0
    fmov d9, d1
    AGET x19, LRlog_image_key
    cmp x0, x20
    b.ne LRback_log_write
    AGET x19, LRlog_reason_key
    cbz x0, LRback_log_write
    GET x0, LRunsigned
    cmp w0, w21
    b.ne LRback_log_write
    AGET x19, LRlog_shift_key
    cbz x0, LRback_log_write
    GET x0, LRpoint_value
    LRNEAR d0, d8, LRback_log_write
    LRNEAR d1, d9, LRback_log_write
    b LRback_log_done
LRback_log_write:
    ASET x19, LRlog_image_key, x20, 1
    mov w0, w21
    bl Luint
    mov x23, x0
    ASET x19, LRlog_reason_key, x23, 1
    adr x0, LGvalue_class
    bl Lpatch + (0xa5b0 - PATCH_BASE)
    fmov d0, d8
    fmov d1, d9
    adr x1, LRvalue_point
    bl Lmessage
    ASET x19, LRlog_shift_key, x0, 1
    bl Lnewdict
    mov x22, x0
    mov x2, x23
    adr x1, LRfield_reason
    bl Ldict_set
    fmov d0, d8
    bl Lnumber
    mov x2, x0
    mov x0, x22
    adr x1, LRfield_shift
    bl Ldict_set
    fmov d0, d9
    bl Lnumber
    mov x2, x0
    mov x0, x22
    adr x1, LRfield_shift_y
    bl Ldict_set
    mov x0, x19
    bl Lclass_name
    mov x2, x0
    mov x0, x22
    adr x1, LRfield_control
    bl Ldict_set
    mov x0, x24
    bl Lclass_name
    mov x2, x0
    mov x0, x22
    adr x1, LRfield_icon_class
    bl Ldict_set
    GET x24, LGsuperview
    bl Lclass_name
    mov x2, x0
    mov x0, x22
    adr x1, LRfield_icon_parent
    bl Ldict_set
    GET x24, LSframe
    bl Lrect_array
    mov x2, x0
    mov x0, x22
    adr x1, LRfield_icon_frame
    bl Ldict_set
    GET x24, LGbounds
    bl Lrect_array
    mov x2, x0
    mov x0, x22
    adr x1, LRfield_icon_bounds
    bl Ldict_set
    GET x20, LRorientation
    bl Luint
    mov x2, x0
    mov x0, x22
    adr x1, LRfield_orientation
    bl Ldict_set
    GET x20, LRimage_scale
    bl Lnumber
    mov x2, x0
    mov x0, x22
    adr x1, LRfield_scale
    bl Ldict_set
    AGET x20, LRalpha_key
    cbz x0, LRback_log_ms
    GET x0, LRrect_value
    bl Lrect_array
    mov x2, x0
    mov x0, x22
    adr x1, LRfield_alpha_rect
    bl Ldict_set
LRback_log_ms:
    AGET x20, LRalpha_ms_key
    cbz x0, LRback_log_record
    mov x2, x0
    mov x0, x22
    adr x1, LRfield_alpha_ms
    bl Ldict_set
LRback_log_record:
    adr x0, LRback_event
    mov x1, x22
    bl Lrecord_named
LRback_log_done:
    ldp d8, d9, [sp, #64]
    ldp x23, x24, [sp, #48]
    ldp x21, x22, [sp, #32]
    ldp x19, x20, [sp, #16]
    ldp x29, x30, [sp], #80
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
    stp x29, x30, [sp, #-48]!
    mov x29, sp
    stp x19, x20, [sp, #16]
    stp x21, x22, [sp, #32]
    adr x21, LRowner_classes
    mov w22, #6
LRinstall_next:
    ldr w8, [x21], #4
    adr x0, Lpatch
    add x0, x0, x8
    bl Lpatch + (0xa5b0 - PATCH_BASE)
    mov x19, x0
    cbz x19, LRinstall_advance
    AGET x19, LRlifecycle_key
    cbnz x0, LRinstall_advance
    mov x0, x19
    adr x1, Lwindow_sel
    adr x2, LRmoved_alias
    adr x3, LRreader_moved
    adr x4, Lvoid_encoding
    bl Linstall_method
    ASET x19, LRlifecycle_key, x19, 0
LRinstall_advance:
    subs w22, w22, #1
    b.ne LRinstall_next
    ldp x21, x22, [sp, #32]
    ldp x19, x20, [sp, #16]
    ldp x29, x30, [sp], #48
    ret

// All exact reader owners receive an attachment callback. In particular a
// menu's setupLayout often runs BEFORE it has a window; its first didMove must
// apply the same bounded path. No UIView/UIButton global method is changed.
LRreader_moved:
    stp x29, x30, [sp, #-64]!
    mov x29, sp
    stp x19, x20, [sp, #16]
    stp x21, x22, [sp, #32]
    stp x23, x24, [sp, #48]
    mov x19, x0
    mov x20, x1
    adr x21, LRowner_classes
    mov w22, #6
LRmoved_owner:
    ldr w8, [x21], #4
    adr x23, Lpatch
    add x23, x23, x8
    mov x0, x19
    mov x1, x23
    bl Lpatch + (0x7394 - PATCH_BASE)
    cbnz w0, LRmoved_original
    subs w22, w22, #1
    b.ne LRmoved_owner
    b LRmoved_style
LRmoved_original:
    mov x0, x23
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
    ldp x23, x24, [sp, #48]
    ldp x21, x22, [sp, #32]
    ldp x19, x20, [sp, #16]
    ldp x29, x30, [sp], #64
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
    mov x0, x19
    bl LGscope
    cmp w0, #1
    b.eq LRpanel_original_top
    bl LRenabled
    mov w21, w0
    GET x19, LGhidden
    cbnz w0, LRpanel_restore
    GET x19, Lwindow
    cbz x0, LRpanel_restore
    cbz w21, LRpanel_restore
    // Existing generic traversal is the primary path; the host is not required
    // to implement leftBackIconView. Check stale ownership independently.
    AGET x19, LRowner_back_key
    GET x0, LXany_object
    mov x20, x0
    cbz x20, LRpanel_getter
    AGET x20, LRback_owner_key
    GET x0, LXany_object
    cmp x0, x19
    b.ne LRpanel_clear_stale_owner
    mov x0, x20
    mov x1, x19
    bl LRvisible
    cbnz w0, LRpanel_getter
    mov x0, x20
    bl LRback_restore
LRpanel_clear_stale_owner:
    ASET x19, LRowner_back_key, xzr, 0
LRpanel_getter:
    mov x0, x19
    adr x1, LGback_selector
    bl LRresponds
    cbz w0, LRpanel_missing_getter
    GET x19, LGback_selector
    cbz x0, LRpanel_no_getter
    mov x0, x19
    adr x1, LGback_selector
    bl LGstyle_glyph
    b LRpanel_background
LRpanel_missing_getter:
    // Generic leading UIControls do not require a host getter. Only a former
    // standalone getter-owned image loses its role when that getter vanishes.
    AGET x19, LRowner_back_key
    GET x0, LXany_object
    mov x20, x0
    AGET x20, LRback_control_key
    GET x0, LXany_object
    cmp x0, x20
    b.eq LRpanel_no_getter
    mov x0, x19
    bl LRremove_back_material
    b LRpanel_background
LRpanel_no_getter:
    mov x0, x19
    bl LRrelease_owner_back
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
LRpanel_original_top:
    // This runs after the host's original callback; no material factory,
    // layoutIfNeeded, symbol substitution or glyph getter is invoked.
    mov x0, x19
    bl LRrestore_original_top
    mov w1, w0
    mov x0, x19
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

// Remove a selector-keyed decoration, never the getter's host return value.
// The existing plugin stores only its own sibling glass under these keys.
LRremove_glyph_material: // owner, selector CString
    stp x29, x30, [sp, #-48]!
    mov x29, sp
    stp x19, x20, [sp, #16]
    mov x19, x0
    mov x20, x1
    cbz x19, LRremove_glyph_done
    cbz x20, LRremove_glyph_done
    bl Lpatch + (0xa628 - PATCH_BASE)
    cbz x0, LRremove_glyph_done
    GET x0, LGremove
    mov x0, x19
    mov x1, x20
    mov x2, #0
    mov x3, #0
    bl Lpatch + (0xa634 - PATCH_BASE)
LRremove_glyph_done:
    ldp x19, x20, [sp, #16]
    ldp x29, x30, [sp], #48
    ret

LRrestore_original_top: // owner/control -> unspent cleanup visit budget
    stp x29, x30, [sp, #-48]!
    mov x29, sp
    stp x19, x20, [sp, #16]
    mov x19, x0
    adr x1, LGback_selector
    bl LRremove_glyph_material
    mov x0, x19
    adr x1, LGshare_selector
    bl LRremove_glyph_material
    mov x0, x19
    adr x1, LGmore_selector
    bl LRremove_glyph_material
    mov x0, x19
    bl LRrelease_owner_back
    mov w8, #64
    str w8, [sp, #32]
    mov x0, x19
    mov w1, #7
    add x2, sp, #32
    mov w3, #0
    bl LRwalk
    ldr w0, [sp, #32]
    ldp x19, x20, [sp, #16]
    ldp x29, x30, [sp], #48
    ret

LRrelease_owner_back:
    stp x29, x30, [sp, #-32]!
    mov x29, sp
    stp x19, x20, [sp, #16]
    mov x19, x0
    AGET x19, LRowner_back_key
    GET x0, LXany_object
    mov x20, x0
    AGET x20, LRback_owner_key
    GET x0, LXany_object
    cmp x0, x19
    b.ne LRrelease_owner_clear
    mov x0, x20
    bl LRback_restore
LRrelease_owner_clear:
    ASET x19, LRowner_back_key, xzr, 0
    ldp x19, x20, [sp, #16]
    ldp x29, x30, [sp], #32
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
    mov x0, x19
    bl LDreader_detach
    mov x0, x19
    bl LRcontrol_background_restore
    mov x0, x19
    bl LRcontrol_restore
    AGET x19, LRback_owned_key
    cbnz x0, LRwalk_restore_image
    AGET x19, LRnative_image_key
    cbz x0, LRwalk_kind
LRwalk_restore_image:
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
    cbnz w0, LRwalk_control
    mov x0, x19
    adr x1, LGreader_bottom_button
    bl Lpatch + (0x7394 - PATCH_BASE)
    cbnz w0, LRwalk_control
    mov x0, x19
    adr x1, LGreader_floating_button
    bl Lpatch + (0x7394 - PATCH_BASE)
    cbz w0, LRwalk_children
LRwalk_control:
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
    mov x0, x19
    bl Lclass_name
    mov x2, x0
    mov x0, x21
    adr x1, LRfield_owner
    bl Ldict_set
    .if FQ_VERSION >= 0x10606
    mov x0, x19
    bl LFQH_FQHReaderCount
    mov x22, x0
    bl Luint
    mov x2, x0
    mov x0, x21
    adr x1, LRfield_native_buttons
    bl Ldict_set
    .endif
    mov x0, x19
    bl LGscope
    cmp w0, #1
    cset w0, eq
    .if FQ_VERSION >= 0x10606
    cmp x22, #0
    csel w0, w0, wzr, eq
    .endif
    bl Luint
    mov x2, x0
    mov x0, x21
    adr x1, LRfield_original_top
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

// A gray listen fill below native glass defeats transparency. Save its color
// only for the exact existing floating-reader class; never clear content views,
// labels, custom artwork, or the general reader page background.
LRcolors_equal: // immutable UIColor values, nil-safe
    cmp x0, x1
    b.eq LRcolors_equal_yes
    mov x2, x1
    adr x1, LRcolor_is_equal
    b Lmessage
LRcolors_equal_yes:
    mov w0, #1
    ret

LRcontrol_background: // exact floating reader control, unique visible UILabel
    stp x29, x30, [sp, #-64]!
    mov x29, sp
    stp x19, x20, [sp, #16]
    stp x21, x22, [sp, #32]
    mov x19, x0
    mov x22, x1
    adr x1, LGreader_floating_button
    bl Lpatch + (0x7394 - PATCH_BASE)
    cbz w0, LRcontrol_bg_done
    adr x0, LRcolor_class
    adr x1, LRclear_color
    bl Lfactory
    mov x21, x0
    cbz x21, LRcontrol_bg_done
    GET x19, LRcontrol_bg
    mov x20, x0
    mov x1, x21
    bl LRcolors_equal
    cbnz w0, LRcontrol_foreground
    ASET x19, LRcontrol_background_key, x20, 1
    ASET x19, LRcontrol_background_saved_key, x19, 0
    mov x2, x21
    GET x19, LRcontrol_set_bg
LRcontrol_foreground:
    // Reuse/reparent may replace the caption while the button survives. Restore
    // the old weakly owned caption before publishing a new ownership epoch.
    AGET x19, LRforeground_view_key
    GET x0, LXany_object
    cmp x0, x22
    b.eq LRcontrol_foreground_current
    mov x0, x19
    bl LRcontrol_foreground_restore
LRcontrol_foreground_current:
    // The original listen caption is white over gray. Resolve its foreground
    // semantically for light AND dark reading backgrounds after clearing gray.
    cbz x22, LRcontrol_bg_done
    // If another listen button still owns this reused caption, end that epoch
    // before recording our own original color. Old cleanup cannot alter us.
    AGET x22, LRforeground_owner_key
    cbz x0, LRcontrol_foreground_take
    GET x0, LXany_object
    cbnz x0, LRcontrol_foreground_live_owner
    mov x0, x22
    bl LRforeground_restore_orphan
    b LRcontrol_foreground_take
LRcontrol_foreground_live_owner:
    cmp x0, x19
    b.eq LRcontrol_foreground_take
    bl LRcontrol_foreground_restore
LRcontrol_foreground_take:
    adr x0, LRcolor_class
    adr x1, LRlabel_color
    bl Lfactory
    mov x21, x0
    cbz x21, LRcontrol_bg_done
    GET x22, LRtext_color
    mov x20, x0
    mov x1, x21
    bl LRcolors_equal
    cbnz w0, LRcontrol_bg_done
    mov x0, x22
    bl LRweak_box
    cbz x0, LRcontrol_bg_done
    str x0, [sp, #48]
    mov x0, x19
    bl LRweak_box
    cbz x0, LRcontrol_bg_done
    ASET x22, LRforeground_owner_key, x0, 1
    ldr x0, [sp, #48]
    ASET x19, LRforeground_view_key, x0, 1
    ASET x22, LRforeground_original_key, x20, 1
    ASET x22, LRforeground_saved_key, x22, 0
    mov x2, x21
    GET x22, LRset_text_color
LRcontrol_bg_done:
    ldp x21, x22, [sp, #32]
    ldp x19, x20, [sp, #16]
    ldp x29, x30, [sp], #64
    ret

// A caption may outlive its previous button. Its weak owner then becomes nil
// while the original color remains recoverable on the caption itself.
LRforeground_restore_orphan:
    stp x29, x30, [sp, #-48]!
    mov x29, sp
    stp x19, x20, [sp, #16]
    stp x21, x22, [sp, #32]
    mov x19, x0
    AGET x19, LRforeground_saved_key
    cbz x0, LRforeground_orphan_clear
    adr x0, LRcolor_class
    adr x1, LRlabel_color
    bl Lfactory
    mov x20, x0
    GET x19, LRtext_color
    mov x1, x20
    bl LRcolors_equal
    cbz w0, LRforeground_orphan_clear
    AGET x19, LRforeground_original_key
    mov x2, x0
    GET x19, LRset_text_color
LRforeground_orphan_clear:
    ASET x19, LRforeground_original_key, xzr, 0
    ASET x19, LRforeground_saved_key, xzr, 0
    ASET x19, LRforeground_owner_key, xzr, 0
    ldp x21, x22, [sp, #32]
    ldp x19, x20, [sp, #16]
    ldp x29, x30, [sp], #48
    ret

LRcontrol_foreground_restore:
    stp x29, x30, [sp, #-48]!
    mov x29, sp
    stp x19, x20, [sp, #16]
    stp x21, x22, [sp, #32]
    mov x19, x0
    b LRcontrol_fg_restore

LRcontrol_background_restore:
    stp x29, x30, [sp, #-48]!
    mov x29, sp
    stp x19, x20, [sp, #16]
    stp x21, x22, [sp, #32]
    mov x19, x0
    AGET x19, LRcontrol_background_saved_key
    cbz x0, LRcontrol_fg_restore
    adr x0, LRcolor_class
    adr x1, LRclear_color
    bl Lfactory
    mov x20, x0
    GET x19, LRcontrol_bg
    mov x1, x20
    bl LRcolors_equal
    cbz w0, LRcontrol_bg_restore_clear
    AGET x19, LRcontrol_background_key
    mov x2, x0
    GET x19, LRcontrol_set_bg
LRcontrol_bg_restore_clear:
    ASET x19, LRcontrol_background_key, xzr, 0
    ASET x19, LRcontrol_background_saved_key, xzr, 0
LRcontrol_fg_restore:
    AGET x19, LRforeground_view_key
    GET x0, LXany_object
    mov x22, x0
    cbz x22, LRcontrol_bg_restore_done
    AGET x22, LRforeground_owner_key
    GET x0, LXany_object
    cmp x0, x19
    b.ne LRcontrol_fg_clear_owner
    AGET x22, LRforeground_saved_key
    cbz x0, LRcontrol_fg_clear
    adr x0, LRcolor_class
    adr x1, LRlabel_color
    bl Lfactory
    mov x20, x0
    GET x22, LRtext_color
    mov x1, x20
    bl LRcolors_equal
    cbz w0, LRcontrol_fg_clear
    AGET x22, LRforeground_original_key
    mov x2, x0
    GET x22, LRset_text_color
LRcontrol_fg_clear:
    ASET x22, LRforeground_original_key, xzr, 0
    ASET x22, LRforeground_saved_key, xzr, 0
    ASET x22, LRforeground_owner_key, xzr, 0
LRcontrol_fg_clear_owner:
    ASET x19, LRforeground_view_key, xzr, 0
LRcontrol_bg_restore_done:
    ldp x21, x22, [sp, #32]
    ldp x19, x20, [sp, #16]
    ldp x29, x30, [sp], #48
    ret

// @COMPONENT_DATA
.p2align 3
LRdirectory:
    .ascii "FQ162RDR"
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
    .long LRsettle_control - Lpatch
.p2align 3
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
LRmoved_alias: .asciz "fqab_160_readerOriginalDidMoveToWindow"
.p2align 2
LRowner_classes:
    .long LGreader_nav - Lpatch, LGreader_menu - Lpatch
    .long LGreader_tools - Lpatch, LGreader_buttons - Lpatch
    .long LGreader_bottom_button - Lpatch, LGreader_floating_button - Lpatch
LRfield_owner: .asciz "readerOwnerClass"
LRfield_original_top: .asciz "readerTopOriginalControls"
LRcontrol_background_key: .byte 0
LRcontrol_background_saved_key: .byte 0
LRcontrol_bg: .asciz "backgroundColor"
LRcontrol_set_bg: .asciz "setBackgroundColor:"
LRcolor_class: .asciz "UIColor"
LRclear_color: .asciz "clearColor"
LRcolor_is_equal: .asciz "isEqual:"
LRlabel_color: .asciz "labelColor"
LRtext_color: .asciz "textColor"
LRset_text_color: .asciz "setTextColor:"
LRforeground_view_key: .byte 0
LRforeground_original_key: .byte 0
LRforeground_saved_key: .byte 0
LRforeground_owner_key: .byte 0
.p2align 2

.p2align 3
LRcenter_epsilon: .double 0.000001
// 256 covers 44pt@3x (132px) and 72pt@3x assets while bounding allocation to
// 256 KiB per uncached image. This is not a logical-point size threshold.
LRpixel_limit: .double 256.0
LRleading_limit: .double 72.0
LRlayout_if_needed: .asciz "layoutIfNeeded"
LRcap_insets: .asciz "capInsets"
LRanimating: .asciz "isAnimating"
LRhighlighted: .asciz "isHighlighted"
LRhighlighted_image: .asciz "highlightedImage"
LRflips_rtl: .asciz "flipsForRightToLeftLayoutDirection"
LRcenter: .asciz "center"
LRset_center: .asciz "setCenter:"
LRpoint_value: .asciz "CGPointValue"
LRvalue_point: .asciz "valueWithCGPoint:"
LRrect_value: .asciz "CGRectValue"
LRvalue_rect: .asciz "valueWithCGRect:"
LRtransform: .asciz "transform"
LRlayer_mask: .asciz "mask"
LRcorner_radius: .asciz "cornerRadius"
LRinteractive: .asciz "isUserInteractionEnabled"
LRorientation: .asciz "imageOrientation"
LRimage_scale: .asciz "scale"
LRimages: .asciz "images"
LRcgimage: .asciz "CGImage"
LRciimage_class: .asciz "CIImage"
LRcicontext_class: .asciz "CIContext"
LRciimage_cg: .asciz "imageWithCGImage:"
LRapply_orientation: .asciz "imageByApplyingOrientation:"
LRorientation_exif: .byte 1, 3, 8, 6, 2, 4, 5, 7
LRblack_image: .asciz "blackImage"
LRclear_image: .asciz "clearImage"
LRcrop: .asciz "imageByCroppingToRect:"
LRcomposite: .asciz "imageByCompositingOverImage:"
LRextent: .asciz "extent"
LRcontext_options: .asciz "contextWithOptions:"
LRrender: .asciz "render:toBitmap:rowBytes:bounds:format:colorSpace:"
LRdata_class: .asciz "NSMutableData"
LRdata_length: .asciz "dataWithLength:"
LRmutable_bytes: .asciz "mutableBytes"
LRbundle_class: .asciz "NSBundle"
LRbundle_path: .asciz "bundleWithPath:"
LRbundle_load: .asciz "load"
LRci_framework: .asciz "/System/Library/Frameworks/CoreImage.framework"
LRback_event: .asciz "reader_back_alignment"
LRfield_reason: .asciz "readerBackReason"
LRfield_shift: .asciz "readerBackShiftX"
LRfield_shift_y: .asciz "readerBackShiftY"
LRfield_control: .asciz "readerBackControlClass"
LRfield_icon_class: .asciz "readerBackIconClass"
LRfield_icon_parent: .asciz "readerBackIconParentClass"
LRfield_icon_frame: .asciz "readerBackIconFrame"
LRfield_icon_bounds: .asciz "readerBackIconBounds"
LRfield_orientation: .asciz "readerBackImageOrientation"
LRfield_scale: .asciz "readerBackImageScale"
LRfield_alpha_rect: .asciz "readerBackAlphaRect"
LRfield_alpha_ms: .asciz "readerBackPixelReadMs"
LRalpha_key: .byte 0
LRalpha_failure_key: .byte 0
LRalpha_ms_key: .byte 0
LRci_load_key: .byte 0
LRci_bundle_key: .byte 0
LRci_context_key: .byte 0
LRci_rows_key: .byte 0
LRbutton_class: .asciz "UIButton"
LRbutton_image_view: .asciz "imageView"
LRimage_for_state: .asciz "imageForState:"
LRset_image_for_state: .asciz "setImage:forState:"
LRhorizontal_alignment: .asciz "contentHorizontalAlignment"
LRset_horizontal_alignment: .asciz "setContentHorizontalAlignment:"
LRvertical_alignment: .asciz "contentVerticalAlignment"
LRset_vertical_alignment: .asciz "setContentVerticalAlignment:"
LRimage_insets: .asciz "imageEdgeInsets"
LRset_image_insets: .asciz "setImageEdgeInsets:"
LRcontent_insets: .asciz "contentEdgeInsets"
LRset_content_insets: .asciz "setContentEdgeInsets:"
LRmanaged_images_key: .byte 0
LRmanaged_native_key: .byte 0
LRmanaged_horizontal_key: .byte 0
LRmanaged_vertical_key: .byte 0
LRmanaged_image_insets_key: .byte 0
LRmanaged_content_insets_key: .byte 0
LRnative_symbol_key: .byte 0
LRnative_image_key: .byte 0
LRback_image_key: .byte 0
LRcontrol_image_key: .byte 0
LRlog_image_key: .byte 0
LRback_control_key: .byte 0
LRlog_reason_key: .byte 0
LRlog_shift_key: .byte 0
.p2align 2

.if FQ_VERSION >= 0x10606
LRfield_native_buttons: .asciz "readerNativeGlassButtons"
.endif
