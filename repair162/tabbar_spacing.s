// Inside the pinned home bar factory, after its item-count and size gates.
// d10/d11 are the original bar bounds origin and width; d13 is the item
// count. Adjust these before the factory lays out the proxy and its buttons.
LTabBarSpacing:
    stp x29, x30, [sp, #-16]!
    mov x29, sp
    GET x19, LTabBarSafeArea
    fmax d0, d1, d3                    // max(left, right) in bar coordinates
    mov x8, #0x4046000000000000
    fmov d1, x8                       // 44 pt per host button
    fmov d2, #8.0                     // original button row padding
    fmul d1, d13, d1
    fadd d1, d1, d2
    fsub d1, d11, d1
    fmov d2, #0.5
    fmul d1, d1, d2                   // largest symmetric inset that fits
    fcmp d0, d1
    b.gt LTabBarSpacingRestore
    fmov d2, #20.0
    fmax d0, d0, d2
    fmin d0, d0, d1
    fadd d10, d10, d0
    fadd d0, d0, d0
    fsub d11, d11, d0
    ldp x29, x30, [sp], #16
    adr x21, Lpatch + (0xbac9 - PATCH_BASE)
    b Lpatch + (0x6580 - PATCH_BASE)
LTabBarSpacingRestore:
    ldp x29, x30, [sp], #16
    b Lpatch + (0x643c - PATCH_BASE)   // factory restores the host bar

// @COMPONENT_DATA
LTabBarSafeArea: .asciz "safeAreaInsets"
