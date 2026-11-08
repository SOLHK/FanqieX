// Reader-only settled layout, bounded traversal, and pixel-aware back centering.
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
LRback_restore: // UIImageView
    stp x29, x30, [sp, #-80]!
    mov x29, sp
    stp x19, x20, [sp, #16]
    stp d8, d9, [sp, #32]
    stp d10, d11, [sp, #48]
    mov x19, x0
    cbz x19, LRrestore_done
    AGET x19, LRback_owned_key
    mov x20, x0
    cbz x20, LRrestore_done
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
LRci_class: // class CString -> Class or nil
    stp x29, x30, [sp, #-48]!
    mov x29, sp
    stp x19, x20, [sp, #16]
    stp x21, x22, [sp, #32]
    mov x19, x0
    bl Lpatch + (0xa5b0 - PATCH_BASE)
    cbnz x0, LRci_class_done
    adr x0, LGimage_resource_class
    bl Lpatch + (0xa5b0 - PATCH_BASE)
    mov x20, x0
    AGET x20, LRci_load_key
    cbnz x0, LRci_class_nil
    ASET x20, LRci_load_key, x20, 0
    adr x0, LRci_framework
    bl Lstr
    mov x21, x0
    adr x0, LRbundle_class
    bl Lpatch + (0xa5b0 - PATCH_BASE)
    mov x2, x21
    adr x1, LRbundle_path
    bl Lmessage
    mov x21, x0
    cbz x21, LRci_class_nil
    GET x21, LRbundle_load
    cbz w0, LRci_class_nil
    ASET x20, LRci_bundle_key, x21, 1
    mov x0, x19
    bl Lpatch + (0xa5b0 - PATCH_BASE)
    b LRci_class_done
LRci_class_nil:
    mov x0, #0
LRci_class_done:
    ldp x21, x22, [sp, #32]
    ldp x19, x20, [sp, #16]
    ldp x29, x30, [sp], #48
    ret

// Determine bitmap row order once per context rather than guessing from a
// Python fixture. The opaque lower 1x1 pixel over a transparent 1x2 extent has
// a known Core Image (Cartesian) position. Inspect both alpha bytes. The
// result is 1=top-down, 2=bottom-up; 3 caches a failed/unsupported calibration.
// All calibration image factories are public and availability checked.
LRbitmap_rows: // CIContext -> w0 row order or zero
    stp x29, x30, [sp, #-96]!
    mov x29, sp
    stp x19, x20, [sp, #16]
    stp x21, x22, [sp, #32]
    stp x23, x24, [sp, #48]
    stp x25, x26, [sp, #64]
    mov x19, x0
    AGET x19, LRci_rows_key
    cbz x0, LRrows_start
    GET x0, LRunsigned
    cmp w0, #3
    b.ne LRrows_done
    mov w0, #0
    b LRrows_done
LRrows_start:
    mov w0, #3
    bl Luint
    ASET x19, LRci_rows_key, x0, 1
    mov x0, x19
    adr x1, LRrender
    bl LRresponds
    cbz w0, LRrows_fail
    adr x0, LRciimage_class
    bl Lpatch + (0xa5b0 - PATCH_BASE)
    mov x20, x0
    adr x1, LRblack_image
    bl LRresponds
    cbz w0, LRrows_fail
    mov x0, x20
    adr x1, LRclear_image
    bl LRresponds
    cbz w0, LRrows_fail
    GET x20, LRblack_image
    mov x21, x0
    cbz x21, LRrows_fail
    adr x1, LRcrop
    bl LRresponds
    cbz w0, LRrows_fail
    fmov d0, xzr
    fmov d1, xzr
    fmov d2, #1.0
    fmov d3, #1.0
    GET x21, LRcrop
    mov x21, x0
    cbz x21, LRrows_fail
    adr x1, LRcomposite
    bl LRresponds
    cbz w0, LRrows_fail
    GET x20, LRclear_image
    mov x22, x0
    cbz x22, LRrows_fail
    adr x1, LRcrop
    bl LRresponds
    cbz w0, LRrows_fail
    fmov d0, xzr
    fmov d1, xzr
    fmov d2, #1.0
    fmov d3, #2.0
    GET x22, LRcrop
    cbz x0, LRrows_fail
    mov x2, x0
    GET x21, LRcomposite
    mov x23, x0
    cbz x23, LRrows_fail
    adr x0, LRdata_class
    bl Lpatch + (0xa5b0 - PATCH_BASE)
    mov x2, #8
    adr x1, LRdata_length
    bl Lmessage
    mov x24, x0
    cbz x24, LRrows_fail
    GET x24, LRmutable_bytes
    mov x25, x0
    cbz x25, LRrows_fail
    mov x2, x23
    mov x3, x25
    mov x4, #4
    mov w5, #24
    mov x6, #0
    fmov d0, xzr
    fmov d1, xzr
    fmov d2, #1.0
    fmov d3, #2.0
    GET x19, LRrender
    ldrb w8, [x25, #3]
    ldrb w9, [x25, #7]
    cmp w8, #240
    b.lo LRrows_top
    cmp w9, #15
    b.hi LRrows_fail
    mov w26, #2
    b LRrows_cache
LRrows_top:
    cmp w8, #15
    b.hi LRrows_fail
    cmp w9, #240
    b.lo LRrows_fail
    mov w26, #1
LRrows_cache:
    mov w0, w26
    bl Luint
    ASET x19, LRci_rows_key, x0, 1
    mov w0, w26
    b LRrows_done
LRrows_fail:
    mov w0, #0
LRrows_done:
    ldp x25, x26, [sp, #64]
    ldp x23, x24, [sp, #48]
    ldp x21, x22, [sp, #32]
    ldp x19, x20, [sp, #16]
    ldp x29, x30, [sp], #96
    ret

// One bounded public CoreImage image read per immutable UIImage, after one
// two-pixel row-order calibration per shared CIContext. Scans actual RGBA
// alpha bytes (threshold >=16) in ARM64, not alignmentRectInsets metadata.
// Apply UIImage's orientation before measuring; the cached CGRect is in
// normalized UIKit top-left coordinates. UIImage.size already includes its
// orientation and scale, so callers map these fractions into its draw rect.
// kCIFormatRGBA8 = 24, see Chromium's original detection_utils_mac.mm and
// Apple's render:toBitmap:rowBytes:bounds:format:colorSpace: public contract.
LRalpha_fractions: // UIImage -> w0 success, w1 reason, CGRect d0..d3
    stp x29, x30, [sp, #-176]!
    mov x29, sp
    stp x19, x20, [sp, #16]
    stp x21, x22, [sp, #32]
    stp x23, x24, [sp, #48]
    stp x25, x26, [sp, #64]
    stp x27, x28, [sp, #80]
    stp d8, d9, [sp, #96]
    stp d10, d11, [sp, #112]
    mov x19, x0
    AGET x19, LRalpha_key
    cbz x0, LRalpha_failed_cache
    GET x0, LRrect_value
    mov w0, #1
    mov w1, #0
    b LRalpha_done
LRalpha_failed_cache:
    AGET x19, LRalpha_failure_key
    cbz x0, LRalpha_read
    GET x0, LRunsigned
    mov w1, w0
    mov w0, #0
    b LRalpha_done
LRalpha_read:
    bl LDsemantic_time
    fmov d10, d0
    GET x19, LRorientation
    mov w28, #2
    cmp w0, #7
    b.hi LRalpha_fail
    str w0, [sp, #160]
    GET x19, LRimages
    cbz x0, LRalpha_cg
    GET x0, LGcount
    mov w28, #14
    cmp x0, #1
    b.hi LRalpha_fail
LRalpha_cg:
    GET x19, LRcap_insets
    mov w28, #13
    FINITE d0, LRalpha_fail
    FINITE d1, LRalpha_fail
    FINITE d2, LRalpha_fail
    FINITE d3, LRalpha_fail
    fcmp d0, #0.0
    b.ne LRalpha_fail
    fcmp d1, #0.0
    b.ne LRalpha_fail
    fcmp d2, #0.0
    b.ne LRalpha_fail
    fcmp d3, #0.0
    b.ne LRalpha_fail
    GET x19, LRcgimage
    mov x20, x0
    mov w28, #1
    cbz x20, LRalpha_fail
    adr x0, LRciimage_class
    bl LRci_class
    mov w28, #4
    cbz x0, LRalpha_fail
    mov x2, x20
    adr x1, LRciimage_cg
    bl Lmessage
    mov x21, x0
    cbz x21, LRalpha_fail
    ldr w24, [sp, #160]
    cbz w24, LRalpha_extent
    adr x1, LRapply_orientation
    bl LRresponds
    mov w28, #2
    cbz w0, LRalpha_fail
    adr x8, LRorientation_exif
    ldrb w2, [x8, x24]
    GET x21, LRapply_orientation
    mov x21, x0
    cbz x21, LRalpha_fail
LRalpha_extent:
    GET x21, LRextent
    mov w28, #3
    FINITE d0, LRalpha_fail
    FINITE d1, LRalpha_fail
    FINITE d2, LRalpha_fail
    FINITE d3, LRalpha_fail
    fcmp d0, #0.0
    b.ne LRalpha_fail
    fcmp d1, #0.0
    b.ne LRalpha_fail
    fcmp d2, #0.0
    b.le LRalpha_fail
    fcmp d3, #0.0
    b.le LRalpha_fail
    ldr d4, LRpixel_limit
    fcmp d2, d4
    b.gt LRalpha_fail
    fcmp d3, d4
    b.gt LRalpha_fail
    fcvtzs w22, d2
    fcvtzs w23, d3
    ucvtf d8, w22
    ucvtf d9, w23
    fcmp d8, d2
    b.ne LRalpha_fail
    fcmp d9, d3
    b.ne LRalpha_fail
    adr x0, LGimage_resource_class
    bl Lpatch + (0xa5b0 - PATCH_BASE)
    mov x24, x0
    AGET x24, LRci_context_key
    mov x25, x0
    cbnz x25, LRalpha_buffer
    adr x0, LRcicontext_class
    bl LRci_class
    mov w28, #4
    cbz x0, LRalpha_fail
    mov x2, #0
    adr x1, LRcontext_options
    bl Lmessage
    mov x25, x0
    mov w28, #5
    cbz x25, LRalpha_fail
    ASET x24, LRci_context_key, x25, 1
LRalpha_buffer:
    mov x0, x25
    bl LRbitmap_rows
    mov w28, #18
    cbz w0, LRalpha_fail
    str w0, [sp, #164]
    adr x0, LRdata_class
    bl Lpatch + (0xa5b0 - PATCH_BASE)
    fmul d0, d8, d9
    fcvtzs w2, d0
    lsl x2, x2, #2
    adr x1, LRdata_length
    bl Lmessage
    mov x26, x0
    mov w28, #6
    cbz x26, LRalpha_fail
    GET x26, LRmutable_bytes
    mov x27, x0
    cbz x27, LRalpha_fail
    // x2 image; x3 bytes; x4 rowBytes; d0..d3 CGRect; w5 format; x6 space.
    mov x2, x21
    mov x3, x27
    lsl x4, x22, #2
    fmov d0, xzr
    fmov d1, xzr
    fmov d2, d8
    fmov d3, d9
    mov w5, #24
    mov x6, #0
    GET x25, LRrender
    mov w20, #0                  // current x
    mov w21, #0                  // current y
    mov w24, w22                 // first opaque x
    mov w25, #0                  // one past last opaque x
    mov w10, w23                 // first opaque buffer row
    mov w11, #0                  // one past last opaque buffer row
LRalpha_pixel:
    ldrb w8, [x27, #3]
    cmp w8, #16
    b.lo LRalpha_next
    cmp w20, w24
    csel w24, w20, w24, lo
    add w9, w20, #1
    cmp w9, w25
    csel w25, w9, w25, hi
    cmp w21, w10
    csel w10, w21, w10, lo
    add w9, w21, #1
    cmp w9, w11
    csel w11, w9, w11, hi
LRalpha_next:
    add x27, x27, #4
    add w20, w20, #1
    cmp w20, w22
    b.lo LRalpha_pixel
    mov w20, #0
    add w21, w21, #1
    cmp w21, w23
    b.lo LRalpha_pixel
    mov w28, #7
    cmp w25, w24
    b.ls LRalpha_fail
    ucvtf d0, w24
    fdiv d0, d0, d8
    sub w8, w25, w24
    ucvtf d2, w8
    fdiv d2, d2, d8
    sub w8, w11, w10
    ucvtf d3, w8
    fdiv d3, d3, d9
    ldr w8, [sp, #164]
    cmp w8, #2
    b.ne LRalpha_top_row
    sub w10, w23, w11
LRalpha_top_row:
    ucvtf d1, w10
    fdiv d1, d1, d9
    stp d0, d1, [sp, #128]
    stp d2, d3, [sp, #144]
    adr x0, LGvalue_class
    bl Lpatch + (0xa5b0 - PATCH_BASE)
    ldp d0, d1, [sp, #128]
    ldp d2, d3, [sp, #144]
    adr x1, LRvalue_rect
    bl Lmessage
    mov w28, #6
    cbz x0, LRalpha_fail
    ASET x19, LRalpha_key, x0, 1
    bl LDsemantic_time
    fsub d0, d0, d10
    ldr d1, LRthousand
    fmul d0, d0, d1
    bl Lnumber
    ASET x19, LRalpha_ms_key, x0, 1
    ldp d0, d1, [sp, #128]
    ldp d2, d3, [sp, #144]
    mov w0, #1
    mov w1, #0
    b LRalpha_done
LRalpha_fail:
    mov w0, w28
    bl Luint
    ASET x19, LRalpha_failure_key, x0, 1
    mov w1, w28
    mov w0, #0
LRalpha_done:
    ldp d10, d11, [sp, #112]
    ldp d8, d9, [sp, #96]
    ldp x27, x28, [sp, #80]
    ldp x25, x26, [sp, #64]
    ldp x23, x24, [sp, #48]
    ldp x21, x22, [sp, #32]
    ldp x19, x20, [sp, #16]
    ldp x29, x30, [sp], #176
    ret

// A shift is safe only if the resulting visible envelope remains inside each
// rectangular clipping ancestor. Nonrectangular masks cannot be inferred from
// a CGRect and are rejected. The earlier identity walk excludes transforms.
LRdraw_fits: // root, icon, owner, proposed visible rect d0..d3 -> BOOL
    stp x29, x30, [sp, #-128]!
    mov x29, sp
    stp x19, x20, [sp, #16]
    stp x21, x22, [sp, #32]
    stp x23, x24, [sp, #48]
    stp d8, d9, [sp, #64]
    stp d10, d11, [sp, #80]
    mov x19, x0
    mov x20, x1
    mov x21, x2
    mov w22, #7
    stp d0, d1, [sp, #96]
    stp d2, d3, [sp, #112]
    // The image's own mask can alter its visible envelope too. Its local
    // rectangular bounds were checked before measuring; they move with it.
    GET x20, Llayer
    mov x23, x0
    GET x23, LRlayer_mask
    cbnz x0, LRfits_no
    GET x20, LGclips
    cbz w0, LRfits_next
    GET x23, LRcorner_radius
    FINITE d0, LRfits_no
    fcmp d0, #0.0
    b.ne LRfits_no
LRfits_next:
    GET x20, LGsuperview
    mov x20, x0
    cbz x20, LRfits_no
    GET x20, Llayer
    mov x23, x0
    GET x23, LRlayer_mask
    cbnz x0, LRfits_no
    GET x20, LGclips
    cbz w0, LRfits_parent
    GET x23, LRcorner_radius
    FINITE d0, LRfits_no
    fcmp d0, #0.0
    b.ne LRfits_no
    ldp d0, d1, [sp, #96]
    ldp d2, d3, [sp, #112]
    mov x2, x20
    GET x19, LGconvert_rect
    FINITE d0, LRfits_no
    FINITE d1, LRfits_no
    FINITE d2, LRfits_no
    FINITE d3, LRfits_no
    fmov d8, d0
    fmov d9, d1
    fadd d10, d0, d2
    fadd d11, d1, d3
    GET x20, LGbounds
    FINITE d0, LRfits_no
    FINITE d1, LRfits_no
    FINITE d2, LRfits_no
    FINITE d3, LRfits_no
    fadd d2, d0, d2
    fadd d3, d1, d3
    ldr d4, LRcenter_epsilon
    fsub d0, d0, d4
    fsub d1, d1, d4
    fadd d2, d2, d4
    fadd d3, d3, d4
    fcmp d8, d0
    b.lt LRfits_no
    fcmp d9, d1
    b.lt LRfits_no
    fcmp d10, d2
    b.gt LRfits_no
    fcmp d11, d3
    b.gt LRfits_no
LRfits_parent:
    cmp x20, x21
    b.eq LRfits_yes
    subs w22, w22, #1
    b.ne LRfits_next
LRfits_no:
    mov w0, #0
    b LRfits_done
LRfits_yes:
    mov w0, #1
LRfits_done:
    ldp d10, d11, [sp, #80]
    ldp d8, d9, [sp, #64]
    ldp x23, x24, [sp, #48]
    ldp x21, x22, [sp, #32]
    ldp x19, x20, [sp, #16]
    ldp x29, x30, [sp], #128
    ret

// root + complete LGscan record. Only an FQ reader's leading, title-free,
// single-image control is eligible. The optional getter refines identity; its
// absence no longer disables the repair. Other reader bars remain untouched.
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
    mov w24, #7
LRprepare_owner_loop:
    cbz x23, LRprepare_restore
    mov x0, x23
    adr x1, LGreader_nav
    bl Lpatch + (0x7394 - PATCH_BASE)
    cbnz w0, LRprepare_owner_found
    subs w24, w24, #1
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
    cbz x0, LRprepare_identity
    cmp x0, x19
    b.eq LRprepare_identity
    cmp x0, x21
    b.eq LRprepare_identity
    mov x1, x19
    bl LRbelongs
    cbz w0, LRprepare_restore
LRprepare_identity:
    GET x21, LGimage
    mov x22, x0
    cbz x22, LRprepare_restore
    mov x0, x21
    mov x1, x23
    bl LRvisible
    mov w28, #12
    cbz w0, LRprepare_reject
    GET x21, LRanimating
    mov w28, #14
    cbnz w0, LRprepare_reject
    GET x21, LRhighlighted
    cbz w0, LRprepare_rtl
    GET x21, LRhighlighted_image
    mov w28, #15
    cbnz x0, LRprepare_reject
LRprepare_rtl:
    mov w27, #0
    GET x22, LRflips_rtl
    cbz w0, LRprepare_no_rtl
    GET x21, LGdirection
    cmp w0, #1
    cset w27, eq
LRprepare_no_rtl:
    // A cropped/aspect-fill draw cannot be treated as a linear full-image
    // alpha envelope. Only an untrimmed rect contained by the image bounds.
    GET x21, LGbounds
    mov w28, #16
    FINITE d0, LRprepare_reject
    FINITE d1, LRprepare_reject
    FINITE d2, LRprepare_reject
    FINITE d3, LRprepare_reject
    ldp d4, d5, [x20, #88]
    ldp d6, d7, [x20, #104]
    ldr d8, LRcenter_epsilon
    fadd d9, d4, d8
    fcmp d9, d0
    b.lt LRprepare_reject
    fadd d9, d5, d8
    fcmp d9, d1
    b.lt LRprepare_reject
    fadd d4, d4, d6
    fadd d0, d0, d2
    fadd d0, d0, d8
    fcmp d4, d0
    b.gt LRprepare_reject
    fadd d5, d5, d7
    fadd d1, d1, d3
    fadd d1, d1, d8
    fcmp d5, d1
    b.gt LRprepare_reject
    cmp x19, x21
    cset w26, eq                // standalone glyph: move only its decoration
    cbnz w26, LRprepare_transform
    GET x21, LRinteractive
    mov w28, #9
    cbnz w0, LRprepare_reject
LRprepare_transform:
    mov x24, x21
    mov w25, #7
LRprepare_transform_loop:
    mov x0, x24
    bl LRidentity
    mov w28, #8
    cbz w0, LRprepare_reject
    cmp x24, x23
    b.eq LRprepare_measure
    subs w25, w25, #1
    b.eq LRprepare_reject
    GET x24, LGsuperview
    mov x24, x0
    cbz x24, LRprepare_reject
    b LRprepare_transform_loop
LRprepare_measure:
    bl LRenabled
    cbz w0, LRprepare_restore
    GET x21, LRcenter
    fmov d8, d0               // current center
    fmov d9, d1
    fmov d10, d0              // baseline center
    fmov d11, d1
    fmov d12, xzr             // previous installed x/y displacement
    fmov d13, xzr
    AGET x21, LRback_owned_key
    mov x24, x0
    cbz x24, LRprepare_normalized
    GET x24, LRpoint_value
    LRNEAR d0, d8, LRprepare_normalized
    LRNEAR d1, d9, LRprepare_normalized
    AGET x21, LRback_original_key
    cbz x0, LRprepare_normalized
    GET x0, LRpoint_value
    fmov d10, d0
    fmov d11, d1
    fsub d12, d8, d10
    fsub d13, d9, d11
LRprepare_normalized:
    // Return a baseline union to LGgeometry. Otherwise moving the icon would
    // move its glass on the next pass and accumulate an offset every layout.
    ldr d0, [x20]
    ldr d1, [x20, #16]
    fsub d0, d0, d12
    fsub d1, d1, d12
    str d0, [x20]
    str d1, [x20, #16]
    ldr d0, [x20, #8]
    ldr d1, [x20, #24]
    fsub d0, d0, d13
    fsub d1, d1, d13
    str d0, [x20, #8]
    str d1, [x20, #24]
    mov x0, x19
    mov x1, x20
    bl LGgeometry
    cbz w0, LRprepare_restore
    fmov d4, #0.5
    fmul d2, d2, d4
    fmul d3, d3, d4
    fadd d0, d0, d2           // original glass center in the root control
    fadd d1, d1, d3
    stp d0, d1, [sp, #160]
    mov x0, x22
    bl LRalpha_fractions
    cbnz w0, LRprepare_alpha
    mov w28, w1
    b LRprepare_reject
LRprepare_alpha:
    cbz w27, LRprepare_alpha_rect
    // UIImage's directional flip is view-dependent, so it cannot be baked
    // into the immutable-image cache. Flip only the normalized horizontal
    // envelope; UIKit continues to render the original UIImage itself.
    fmov d4, #1.0
    fsub d0, d4, d0
    fsub d0, d0, d2
LRprepare_alpha_rect:
    stp d0, d1, [sp, #176]
    stp d2, d3, [sp, #192]
    ldp d0, d1, [x20, #88]
    ldp d2, d3, [x20, #104]
    mov x2, x19
    GET x21, LGconvert_rect
    FINITE d0, LRprepare_restore
    FINITE d1, LRprepare_restore
    FINITE d2, LRprepare_restore
    FINITE d3, LRprepare_restore
    fcmp d2, #0.0
    b.le LRprepare_restore
    fcmp d3, #0.0
    b.le LRprepare_restore
    fsub d0, d0, d12
    fsub d1, d1, d13
    ldp d4, d5, [sp, #176]
    ldp d6, d7, [sp, #192]
    fmul d4, d4, d2
    fadd d4, d4, d0           // visible left/top at baseline
    fmul d5, d5, d3
    fadd d5, d5, d1
    fmul d6, d6, d2          // visible width/height
    fmul d7, d7, d3
    cbnz w26, LRprepare_standalone
    stp d4, d5, [sp, #208]
    stp d6, d7, [sp, #224]
    fmov d2, #0.5
    fmul d6, d6, d2
    fmul d7, d7, d2
    fadd d6, d4, d6
    fadd d7, d5, d7
    ldp d0, d1, [sp, #160]
    fsub d4, d0, d6          // desired displacement from baseline
    fsub d5, d1, d7
    FINITE d4, LRprepare_restore
    FINITE d5, LRprepare_restore
    fabs d6, d4
    fabs d7, d5
    fmax d6, d6, d7
    fmov d7, #20.0
    fcmp d6, d7
    mov w28, #10
    b.gt LRprepare_reject
    stp d4, d5, [sp, #240]
    fadd d14, d10, d4        // absolute desired center, never accumulated
    fadd d15, d11, d5
    ldp d0, d1, [sp, #208]
    ldp d2, d3, [sp, #224]
    fadd d0, d0, d4
    fadd d1, d1, d5
    mov x0, x19
    mov x1, x21
    mov x2, x23
    bl LRdraw_fits
    mov w28, #19
    cbz w0, LRprepare_reject
    LRNEAR d14, d8, LRprepare_commit
    LRNEAR d15, d9, LRprepare_commit
    AGET x21, LRback_image_key
    cmp x0, x22
    b.ne LRprepare_commit
    AGET x21, LRback_owner_key
    GET x0, LXany_object
    cmp x0, x23
    b.ne LRprepare_commit
    AGET x19, LRcontrol_image_key
    GET x0, LXany_object
    cmp x0, x21
    b.eq LRprepare_done
LRprepare_commit:
    // Construct ALL reversible state before changing ownership or UIKit. Nil
    // allocation is a no-op, never a center mutation without a restore value.
    adr x0, LGvalue_class
    bl Lpatch + (0xa5b0 - PATCH_BASE)
    fmov d0, d10
    fmov d1, d11
    adr x1, LRvalue_point
    bl Lmessage
    mov x24, x0
    cbz x24, LRprepare_restore
    adr x0, LGvalue_class
    bl Lpatch + (0xa5b0 - PATCH_BASE)
    fmov d0, d14
    fmov d1, d15
    adr x1, LRvalue_point
    bl Lmessage
    mov x25, x0
    cbz x25, LRprepare_restore
    mov x0, x23
    bl LRweak_box
    mov x27, x0
    cbz x27, LRprepare_restore
    mov x0, x21
    bl LRweak_box
    mov x28, x0
    cbz x28, LRprepare_restore
    mov x0, x19
    bl LRweak_box
    mov x26, x0
    cbz x26, LRprepare_restore
    // A replaced view retains its host state unless its center is still ours.
    AGET x23, LRowner_back_key
    GET x0, LXany_object
    cbz x0, LRprepare_snapshots
    cmp x0, x21
    b.eq LRprepare_snapshots
    bl LRback_restore
LRprepare_snapshots:
    ASET x21, LRback_original_key, x24, 1
    ASET x21, LRback_owned_key, x25, 1
    ASET x21, LRback_image_key, x22, 1
    ASET x21, LRback_owner_key, x27, 1
    ASET x21, LRback_control_key, x26, 1
    ASET x23, LRowner_back_key, x28, 1
    ASET x19, LRcontrol_image_key, x28, 1
    LRNEAR d14, d8, LRprepare_set_center
    LRNEAR d15, d9, LRprepare_set_center
    b LRprepare_log_success
LRprepare_set_center:
    fmov d0, d14
    fmov d1, d15
    GET x21, LRset_center
LRprepare_log_success:
    mov x0, x19
    mov x1, x22
    mov w2, #0
    mov x3, x21
    ldp d0, d1, [sp, #240]
    bl LRback_log
    b LRprepare_done
LRprepare_standalone:
    // A standalone UIImageView may itself carry the gesture. Keep its frame
    // and center untouched and center only the decorative sibling on pixels.
    stp d4, d5, [sp, #208]
    stp d6, d7, [sp, #224]
    fmov d0, d4
    fmov d1, d5
    fmov d2, d6
    fmov d3, d7
    mov x0, x19
    mov x1, x21
    mov x2, x23
    bl LRdraw_fits
    mov w28, #19
    cbz w0, LRprepare_reject
    ldp d4, d5, [sp, #208]
    ldp d6, d7, [sp, #224]
    stp d4, d5, [x20]
    fadd d4, d4, d6
    fadd d5, d5, d7
    stp d4, d5, [x20, #16]
    mov x0, x19
    mov x1, x22
    mov w2, #11
    mov x3, x21
    fmov d0, xzr
    fmov d1, xzr
    bl LRback_log
    b LRprepare_done
LRprepare_reject:
    mov x0, x19
    mov x1, x22
    mov w2, w28
    mov x3, x21
    fmov d0, xzr
    fmov d1, xzr
    bl LRback_log
LRprepare_restore:
    // A transition may restore the center after LGscan measured the installed
    // one. Recompute the union before the caller places glass, so the old
    // displacement does not survive for one frame in its decoration.
    AGET x19, LRcontrol_image_key
    GET x0, LXany_object
    mov x24, x0
    mov x0, x19
    bl LRcontrol_restore
    cbz x24, LRprepare_done
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
    cbz w0, LRpanel_no_getter
    mov x0, x19
    adr x1, LGback_selector
    bl LGstyle_glyph
    b LRpanel_background
LRpanel_no_getter:
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
    .ascii "FQ159RDR"
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
LRmoved_alias: .asciz "fqab_159_readerOriginalDidMoveToWindow"
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
LRback_image_key: .byte 0
LRcontrol_image_key: .byte 0
LRlog_image_key: .byte 0
LRback_control_key: .byte 0
LRlog_reason_key: .byte 0
LRlog_shift_key: .byte 0
.p2align 2
