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

// (bar, proxy) -> 1 only when this call changes the owned material.
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
    FINITE d0, LMupdate_zero
    FINITE d1, LMupdate_zero
    FINITE d2, LMupdate_zero
    FINITE d3, LMupdate_zero
    fcmp d2, #0.0
    b.le LMupdate_zero
    fcmp d3, #0.0
    b.le LMupdate_zero
    GET x20, LMwindow
    mov x21, x0
    cbz x21, LMinvalidate

    // A UISegmentedControl is an interaction/selection control, not proof
    // that this legacy-linked host supplies a readable glass navigation
    // surface. Keep our single Regular material for BOTH native and fallback
    // controls. Native content lives inside this effect's contentView.
    // Never dematerialize the track merely because native allocation worked.
    // Include both proxy and fresh window. Reject broken/cyclic/long chains,
    // hidden views, nonfinite alpha and meaningful ancestor compositing.
    mov x22, x20
    mov w23, #32
    fmov d8, #1.0
LMvisible_loop:
    cbz x22, LMupdate_zero
    cbz w23, LMupdate_zero
    sub w23, w23, #1
    GET x22, LMis_hidden
    cbnz w0, LMupdate_zero
    GET x22, LMalpha
    FINITE d0, LMupdate_zero
    fcmp d0, #0.0
    b.le LMupdate_zero
    fmov d1, #1.0
    fcmp d0, d1
    b.gt LMupdate_zero
    fmul d8, d8, d0
    ldr d1, LMalpha_floor
    fcmp d8, d1
    b.lt LMupdate_zero
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
    // Regular keeps navigation labels legible over book artwork.
    mov w2, #0
    GET x22, LMglass_factory
    mov x23, x0
    cbz x23, LMinvalidate
    mov w2, #1
    GET x23, LMset_interactive
    mov x2, xzr
    GET x23, LMset_tint

    // Install only the final native material. An empty UIVisualEffect between
    // two glass states invalidates UIKit's backdrop and creates an avoidable
    // transition. A temporarily hidden/fading ancestor keeps the same cache;
    // an actual detach/reparent/window change still invalidates it above.
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

// @COMPONENT_DATA
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
