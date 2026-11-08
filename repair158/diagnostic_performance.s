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

// @COMPONENT_DATA
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
