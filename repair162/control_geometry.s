// Scoped control geometry, FanqieX 1.6.2.
// Two entry patches only: 0x7848 -> LGstyle_control; 0x7ac4 -> LGstyle_glyph.
// No host control frame, target/action, title, font, or label layout is changed.
// All geometry is expressed in the original view's coordinate system.

.set LGsurface_key, Lpatch + (0xeb8b - PATCH_BASE)
.set LGbounds, Lpatch + (0xbb3c - PATCH_BASE)
.set LGsuperview, Lpatch + (0xbb1e - PATCH_BASE)
.set LGhidden, Lpatch + (0xbe75 - PATCH_BASE)
.set LGset_hidden, Lpatch + (0xbba3 - PATCH_BASE)
.set LGsubviews, Lpatch + (0xbed0 - PATCH_BASE)
.set LGresponds, Lpatch + (0xb5cb - PATCH_BASE)
.set LGremove, Lpatch + (0xbb28 - PATCH_BASE)
.set LGreader_nav, Lpatch + (0xb890 - PATCH_BASE)
.set LGstory_big, Lpatch + (0xc31a - PATCH_BASE)
.set LGstory_small, Lpatch + (0xc348 - PATCH_BASE)
.set LGreader_download, Lpatch + (0xc2d7 - PATCH_BASE)
.set LGshelf_header, Lpatch + (0xc16b - PATCH_BASE)
.set LGshelf_subheader, Lpatch + (0xc196 - PATCH_BASE)
.set LGshelf_edit, Lpatch + (0xc1ca - PATCH_BASE)
.set LGshelf_filter, Lpatch + (0xc1fe - PATCH_BASE)
.set LGback_selector, Lpatch + (0xbf9b - PATCH_BASE)
.set LGshare_selector, Lpatch + (0xbfac - PATCH_BASE)
.set LGmore_selector, Lpatch + (0xbfb8 - PATCH_BASE)

// The reader's complete top-navigation subtree is an explicit opt-out. It
// wins over a nested recognized control (including a downloaded/reused button)
// so no legacy material trampoline can recreate a glass circle there.
LGtop_scope: // view -> recognized top-navigation ancestor or nil
    stp x29, x30, [sp, #-64]!
    mov x29, sp
    stp x19, x20, [sp, #16]
    stp x21, x22, [sp, #32]
    stp x23, x24, [sp, #48]
    mov x19, x0
    mov w20, #16
LGtop_level:
    cbz x19, LGtop_no
    adr x21, LGscope_table
    mov w22, #4
LGtop_class:
    ldr w23, [x21]
    adr x1, Lpatch
    add x1, x1, x23
    mov x0, x19
    bl Lpatch + (0x7394 - PATCH_BASE)
    cbnz w0, LGtop_yes
    add x21, x21, #8
    subs w22, w22, #1
    b.ne LGtop_class
    subs w20, w20, #1
    b.eq LGtop_no
    GET x19, LGsuperview
    mov x19, x0
    b LGtop_level
LGtop_yes:
    mov x0, x19
    b LGtop_done
LGtop_no:
    mov x0, #0
LGtop_done:
    ldp x23, x24, [sp, #48]
    ldp x21, x22, [sp, #32]
    ldp x19, x20, [sp, #16]
    ldp x29, x30, [sp], #64
    ret

// Return 1 for original reader navigation, 2 for bookshelf headers, and the
// existing bottom/menu scopes below. Zero retains the legacy non-reader path.
// Class names are the exact owners installed in the original hook tables.
// Both ancestor walks are bounded; malformed cycles cannot hang a callback.
LGscope:
    stp x29, x30, [sp, #-64]!
    mov x29, sp
    stp x19, x20, [sp, #16]
    stp x21, x22, [sp, #32]
    stp x23, x24, [sp, #48]
    mov x19, x0
    bl LGtop_scope
    cbz x0, LGscope_other
    mov x1, x0
    mov w0, #1
    b LGscope_done
LGscope_other:
    mov w20, #6
LGscope_level:
    cbz x19, LGscope_no
    cbz w20, LGscope_no
    adr x21, LGscope_table
    mov w22, #14
LGscope_class:
    ldr w23, [x21]
    adr x1, Lpatch
    add x1, x1, x23
    mov x0, x19
    bl Lpatch + (0x7394 - PATCH_BASE)
    cbnz w0, LGscope_yes
    add x21, x21, #8
    subs w22, w22, #1
    b.ne LGscope_class
    GET x19, LGsuperview
    mov x19, x0
    sub w20, w20, #1
    b LGscope_level
LGscope_yes:
    ldr w0, [x21, #4]
    mov x1, x19
    b LGscope_done
LGscope_no:
    mov w0, #0
    mov x1, #0
LGscope_done:
    ldp x23, x24, [sp, #48]
    ldp x21, x22, [sp, #32]
    ldp x19, x20, [sp, #16]
    ldp x29, x30, [sp], #64
    ret

// CGRect union record: minX,minY,maxX,maxY,lineHeight at +0..32;
// all-content count +40, nonempty-label count +48, image count +56,
// remaining visit budget +64, recognized-content count +72; last image +80,
// untrimmed local image draw CGRect +88..112. Callers allocate 128 bytes.
// At most 32 descendants and three levels.
// Uses UILabel intrinsic size/alignment and UIImageView's actual draw mode.
// Plugin UIVisualEffectView subtrees and nested controls are not content.
LGscan:
    stp x29, x30, [sp, #-128]!
    mov x29, sp
    stp x19, x20, [sp, #16]
    stp x21, x22, [sp, #32]
    stp x23, x24, [sp, #48]
    stp x25, x26, [sp, #64]
    stp d8, d9, [sp, #80]
    stp d10, d11, [sp, #96]
    stp d12, d13, [sp, #112]
    mov x19, x0
    mov x20, x1
    mov x21, x2
    mov w22, w3
    cbz x19, LGscan_done
    ldr x8, [x21, #64]
    cbz x8, LGscan_done
    sub x8, x8, #1
    str x8, [x21, #64]
    GET x19, LGhidden
    cbnz w0, LGscan_hidden_content
    GET x19, LGalpha
    FINITE d0, LGscan_hidden_content
    fcmp d0, #0.0
    b.le LGscan_hidden_content
    mov x0, x19
    adr x1, LGvisual_class
    bl Lpatch + (0x7394 - PATCH_BASE)
    cbnz w0, LGscan_done
    mov x0, x19
    adr x1, LGlabel_class
    bl Lpatch + (0x7394 - PATCH_BASE)
    cbnz w0, LGscan_label
    mov x0, x19
    adr x1, LGimage_class
    bl Lpatch + (0x7394 - PATCH_BASE)
    cbnz w0, LGscan_image
    cmp x19, x20
    b.eq LGscan_children
    mov x0, x19
    adr x1, LGcontrol_class
    bl Lpatch + (0x7394 - PATCH_BASE)
    cbz w0, LGscan_children
    // Existing leaf reader-button classes own one semantic control. Their
    // nested icon UIButton and caption UILabel must be measured together.
    mov x0, x20
    adr x1, LGreader_bottom_button
    bl Lpatch + (0x7394 - PATCH_BASE)
    cbnz w0, LGscan_children
    mov x0, x20
    adr x1, LGreader_floating_button
    bl Lpatch + (0x7394 - PATCH_BASE)
    cbz w0, LGscan_done
LGscan_children:
    cbz w22, LGscan_done
    GET x19, LGsubviews
    mov x23, x0
    GET x23, LGcount
    mov x24, x0
    mov x25, #0
LGscan_child_loop:
    cmp x25, x24
    b.hs LGscan_done
    ldr x8, [x21, #64]
    cbz x8, LGscan_done
    mov x2, x25
    GET x23, LGobject_at
    mov x1, x20
    mov x2, x21
    sub w3, w22, #1
    bl LGscan
    add x25, x25, #1
    b LGscan_child_loop

LGscan_label:
    str x19, [x21, #120]
    ldr x8, [x21, #72]
    add x8, x8, #1
    str x8, [x21, #72]
    GET x19, LGtext
    mov x23, x0
    GET x23, LGlength
    cbz x0, LGscan_done
    GET x19, LGbounds
    fmov d8, d0
    fmov d9, d1
    fmov d10, d2
    fmov d11, d3
    GET x19, LGfont
    cbz x0, LGscan_label_size
    adr x1, LGline_height
    bl Lmessage
    FINITE d0, LGscan_label_size
    fcmp d0, #0.0
    b.le LGscan_label_size
    ldr d1, [x21, #32]
    fmax d0, d0, d1
    str d0, [x21, #32]
LGscan_label_size:
    GET x19, LGintrinsic_size
    FINITE d0, LGscan_label_rect
    FINITE d1, LGscan_label_rect
    fcmp d0, #0.0
    b.le LGscan_label_rect
    fcmp d1, #0.0
    b.le LGscan_label_rect
    fmin d12, d0, d10
    fmin d13, d1, d11
    GET x19, LGtext_alignment
    cmp w0, #4
    b.ne LGscan_label_alignment
    GET x19, LGdirection
    cmp w0, #1
    mov w0, #2
    b.eq LGscan_label_alignment
    mov w0, #0
LGscan_label_alignment:
    fsub d4, d10, d12
    cmp w0, #1
    b.eq LGscan_label_center
    cmp w0, #2
    b.eq LGscan_label_right
    fmov d4, xzr
    b LGscan_label_position
LGscan_label_center:
    fmov d5, #0.5
    fmul d4, d4, d5
LGscan_label_right:
LGscan_label_position:
    fadd d8, d8, d4
    fsub d4, d11, d13
    fmov d5, #0.5
    fmul d4, d4, d5
    fadd d9, d9, d4
    fmov d10, d12
    fmov d11, d13
LGscan_label_rect:
    mov w24, #1
    b LGscan_convert

LGscan_image:
    ldr x8, [x21, #72]
    add x8, x8, #1
    str x8, [x21, #72]
    mov x0, x19
    mov x1, x20
    bl LRreconcile_back
    GET x19, LGimage
    mov x23, x0
    cbz x23, LGscan_done
    GET x19, LGbounds
    fmov d8, d0
    fmov d9, d1
    fmov d10, d2
    fmov d11, d3
    GET x23, LGsize
    FINITE d0, LGscan_done
    FINITE d1, LGscan_done
    fcmp d0, #0.0
    b.le LGscan_done
    fcmp d1, #0.0
    b.le LGscan_done
    fmov d12, d0
    fmov d13, d1
    GET x19, LGcontent_mode
    cbz w0, LGscan_image_rect
    cmp w0, #3
    b.eq LGscan_image_rect
    cmp w0, #1
    b.eq LGscan_image_fit
    cmp w0, #2
    b.eq LGscan_image_fill
    // Center/edge/corner modes retain intrinsic image size.
    fsub d4, d10, d12
    fsub d5, d11, d13
    fmov d6, #0.5
    cmp w0, #7
    b.eq LGscan_image_left
    cmp w0, #8
    b.eq LGscan_image_right
    cmp w0, #5
    b.eq LGscan_image_top
    cmp w0, #6
    b.eq LGscan_image_bottom
    cmp w0, #9
    b.eq LGscan_image_top_left
    cmp w0, #10
    b.eq LGscan_image_top_right
    cmp w0, #11
    b.eq LGscan_image_bottom_left
    cmp w0, #12
    b.eq LGscan_image_position
    fmul d4, d4, d6
    fmul d5, d5, d6
    b LGscan_image_position
LGscan_image_left:
    fmov d4, xzr
    fmul d5, d5, d6
    b LGscan_image_position
LGscan_image_right:
    fmul d5, d5, d6
    b LGscan_image_position
LGscan_image_top:
    fmul d4, d4, d6
    fmov d5, xzr
    b LGscan_image_position
LGscan_image_bottom:
    fmul d4, d4, d6
    b LGscan_image_position
LGscan_image_top_left:
    fmov d4, xzr
LGscan_image_top_right:
    fmov d5, xzr
    b LGscan_image_position
LGscan_image_bottom_left:
    fmov d4, xzr
    b LGscan_image_position
LGscan_image_fit:
    fdiv d4, d10, d12
    fdiv d5, d11, d13
    fmin d4, d4, d5
    b LGscan_image_scale
LGscan_image_fill:
    fdiv d4, d10, d12
    fdiv d5, d11, d13
    fmax d4, d4, d5
LGscan_image_scale:
    fmul d12, d12, d4
    fmul d13, d13, d4
    fsub d4, d10, d12
    fsub d5, d11, d13
    fmov d6, #0.5
    fmul d4, d4, d6
    fmul d5, d5, d6
LGscan_image_position:
    fadd d8, d8, d4
    fadd d9, d9, d5
    fmov d10, d12
    fmov d11, d13
LGscan_image_rect:
    str x19, [x21, #80]
    stp d8, d9, [x21, #88]
    stp d10, d11, [x21, #104]
    mov x0, x23
    fmov d0, d8
    fmov d1, d9
    fmov d2, d10
    fmov d3, d11
    bl LRimage_alignment
    fmov d8, d0
    fmov d9, d1
    fmov d10, d2
    fmov d11, d3
    mov w24, #0
LGscan_convert:
    fmov d0, d8
    fmov d1, d9
    fmov d2, d10
    fmov d3, d11
    mov x2, x20
    GET x19, LGconvert_rect
    FINITE d0, LGscan_done
    FINITE d1, LGscan_done
    FINITE d2, LGscan_done
    FINITE d3, LGscan_done
    fcmp d2, #0.0
    b.le LGscan_done
    fcmp d3, #0.0
    b.le LGscan_done
    fadd d2, d0, d2
    fadd d3, d1, d3
    ldr x8, [x21, #40]
    cbz x8, LGscan_first
    ldp d4, d5, [x21]
    ldp d6, d7, [x21, #16]
    fmin d0, d0, d4
    fmin d1, d1, d5
    fmax d2, d2, d6
    fmax d3, d3, d7
LGscan_first:
    stp d0, d1, [x21]
    stp d2, d3, [x21, #16]
    add x8, x8, #1
    str x8, [x21, #40]
    cbz w24, LGscan_add_image
    ldr x8, [x21, #48]
    add x8, x8, #1
    str x8, [x21, #48]
    b LGscan_done
LGscan_add_image:
    ldr x8, [x21, #56]
    add x8, x8, #1
    str x8, [x21, #56]
    b LGscan_done
LGscan_hidden_content:
    mov x0, x19
    adr x1, LGlabel_class
    bl Lpatch + (0x7394 - PATCH_BASE)
    cbnz w0, LGscan_mark_hidden
    mov x0, x19
    adr x1, LGimage_class
    bl Lpatch + (0x7394 - PATCH_BASE)
    cbz w0, LGscan_done
LGscan_mark_hidden:
    ldr x8, [x21, #72]
    add x8, x8, #1
    str x8, [x21, #72]
LGscan_done:
    ldp d12, d13, [sp, #112]
    ldp d10, d11, [sp, #96]
    ldp d8, d9, [sp, #80]
    ldp x25, x26, [sp, #64]
    ldp x23, x24, [sp, #48]
    ldp x21, x22, [sp, #32]
    ldp x19, x20, [sp, #16]
    ldp x29, x30, [sp], #128
    ret

// (view, union record) -> BOOL and CGRect in d0..d3.
// FQ reader navigation requests 44pt while respecting the real hit rectangle;
// whole bottom buttons include icon + caption, and listen uses a padded circle.
// Historical shelf/story geometry stays unchanged. Shapes never shrink text,
// move host controls, or turn a decorative outside ring into a fake hit target.
LGgeometry:
    stp x29, x30, [sp, #-112]!
    mov x29, sp
    stp x19, x20, [sp, #16]
    stp x21, x22, [sp, #32]
    stp d8, d9, [sp, #48]
    stp d10, d11, [sp, #64]
    stp d12, d13, [sp, #80]
    stp d14, d15, [sp, #96]
    mov x19, x0
    mov x20, x1
    bl LGscope
    mov x22, x0
    cmp w22, #1
    b.ne LGgeometry_scope_ready
    // Unrelated short-story bars retain their historical artwork geometry.
    // Reader download buttons and FQ navigation stay within real hit bounds.
    mov x22, x1
    mov x0, x22
    adr x1, LGstory_big
    bl Lpatch + (0x7394 - PATCH_BASE)
    cbnz w0, LGgeometry_story_scope
    mov x0, x22
    adr x1, LGstory_small
    bl Lpatch + (0x7394 - PATCH_BASE)
    cbnz w0, LGgeometry_story_scope
    mov x22, #1
    b LGgeometry_scope_ready
LGgeometry_story_scope:
    mov x22, #2
LGgeometry_scope_ready:
    ldr x8, [x20, #40]
    cbz x8, LGgeometry_no
    ldp d8, d9, [x20]
    ldp d10, d11, [x20, #16]
    fsub d12, d10, d8
    fsub d13, d11, d9
    fmov d4, #0.5
    fadd d8, d8, d10
    fadd d9, d9, d11
    fmul d8, d8, d4
    fmul d9, d9, d4
    ldr x21, [x20, #48]
    cmp w22, #4
    b.eq LGgeometry_floating
    cbnz x21, LGgeometry_text
    fmax d10, d12, d13
    ldr d4, LGforty
    fcmp d10, d4
    b.gt LGgeometry_no
    fmov d4, #10.0
    fadd d10, d10, d4
    ldr d4, LGthirty_six
    cmp w22, #2
    b.eq LGgeometry_icon_min
    ldr d4, LGforty_four
LGgeometry_icon_min:
    fmax d10, d10, d4
    ldr d4, LGforty_four
    fmin d10, d10, d4
    fmov d11, d10
    b LGgeometry_bounds
LGgeometry_floating:
    // A one-character listen control uses one roomy native circular material.
    fmax d10, d12, d13
    fmov d4, #20.0
    fadd d10, d10, d4
    ldr d4, LGfifty_two
    fmax d10, d10, d4
    fmov d11, d10
    mov x21, #0
    b LGgeometry_bounds
LGgeometry_text:
    cmp w22, #3
    b.eq LGgeometry_bottom
    ldr d4, [x20, #32]
    fmax d11, d4, d13
    fmov d4, #10.0
    fadd d11, d11, d4
    ldr d4, LGthirty_two
    fmax d11, d11, d4
    fmov d4, #20.0
    fadd d10, d12, d4
    fmov d4, #1.5
    fmul d4, d11, d4
    fmax d10, d10, d4
    b LGgeometry_bounds
LGgeometry_bottom:
    // One shape encloses the complete icon + caption. A bottom toolbar button
    // is not an icon-only circle; retain 12pt horizontal and 10pt vertical
    // desired padding, constrained by the existing touch region below.
    fmov d4, #24.0
    fadd d10, d12, d4
    ldr d4, LGsixty_eight
    fmax d10, d10, d4
    fmov d4, #20.0
    fadd d11, d13, d4
    ldr d4, LGsixty_four
    fmax d11, d11, d4
LGgeometry_bounds:
    // Every reader material stays within its REAL host hit rectangle. The
    // previous parent-bounds expansion produced a visible 6pt untappable rim
    // around a 24pt-wide More UIButton. Shelf styling keeps its former rules.
    cmp w22, #2
    b.ne LGgeometry_own_bounds
    GET x19, LGclips
    cbnz w0, LGgeometry_own_bounds
    GET x19, LGsuperview
    mov x22, x0
    cbz x22, LGgeometry_own_bounds
    GET x22, LGbounds
    mov x2, x19
    GET x22, LGconvert_rect
    b LGgeometry_limit
LGgeometry_own_bounds:
    GET x19, LGbounds
LGgeometry_limit:
    FINITE d0, LGgeometry_no
    FINITE d1, LGgeometry_no
    FINITE d2, LGgeometry_no
    FINITE d3, LGgeometry_no
    fadd d2, d0, d2
    fadd d3, d1, d3
    fsub d0, d8, d0
    fsub d1, d9, d1
    fsub d2, d2, d8
    fsub d3, d3, d9
    fmin d0, d0, d2
    fmin d1, d1, d3
    fadd d0, d0, d0
    fadd d1, d1, d1
    fcmp d0, #0.0
    b.le LGgeometry_no
    fcmp d1, #0.0
    b.le LGgeometry_no
    fmin d10, d10, d0
    fmin d11, d11, d1
    cbnz x21, LGgeometry_limit_text
    fmin d10, d10, d11
    fmov d11, d10
    fmax d4, d12, d13
    fmov d5, #2.0
    cmp w22, #1
    b.ne LGgeometry_icon_padding
    // A narrow navigation UIButton may expose a padded 24pt image canvas.
    // Keep a glass inside its real hit bounds even when that canvas consumes
    // the entire width; never manufacture the old untappable outside ring.
    fmov d5, xzr
LGgeometry_icon_padding:
    fadd d4, d4, d5
    fcmp d10, d4
    b.lt LGgeometry_no
    b LGgeometry_yes
LGgeometry_limit_text:
    cmp w22, #3
    b.eq LGgeometry_text_padding
    fmov d4, #1.5
    fdiv d4, d10, d4
    fmin d11, d11, d4
LGgeometry_text_padding:
    fmov d4, #12.0
    fadd d4, d12, d4
    fcmp d10, d4
    b.lt LGgeometry_no
    fmov d4, #6.0
    fadd d4, d13, d4
    fcmp d11, d4
    b.lt LGgeometry_no
LGgeometry_yes:
    fmov d4, #0.5
    fmul d0, d10, d4
    fmul d1, d11, d4
    fsub d0, d8, d0
    fsub d1, d9, d1
    fmov d2, d10
    fmov d3, d11
    mov w0, #1
    b LGgeometry_done
LGgeometry_no:
    mov w0, #0
LGgeometry_done:
    ldp d14, d15, [sp, #96]
    ldp d12, d13, [sp, #80]
    ldp d10, d11, [sp, #64]
    ldp d8, d9, [sp, #48]
    ldp x21, x22, [sp, #32]
    ldp x19, x20, [sp, #16]
    ldp x29, x30, [sp], #112
    ret

// Commit the native capsule only AFTER final positive bounds are installed.
// The old finish changed cornerConfiguration on EVERY layout. In reader bars
// both the parent and the download control run layout hooks, so that setter
// could continuously invalidate the same material. The size snapshot makes
// repeated settled layouts mutation-free; a real resize still reapplies it.
// The material remains decorative and cannot intercept the host's hit testing.
LGfinish:
    stp x29, x30, [sp, #-64]!
    mov x29, sp
    stp x19, x20, [sp, #16]
    stp x21, x22, [sp, #32]
    stp d8, d9, [sp, #48]
    mov x19, x0
    cbz x19, LGfinish_done
    GET x19, LGhidden
    cbz w0, LGfinish_size
    mov w2, #0
    GET x19, LGset_hidden
LGfinish_size:
    GET x19, LGbounds
    FINITE d2, LGfinish_done
    FINITE d3, LGfinish_done
    fcmp d2, #0.0
    b.le LGfinish_done
    fcmp d3, #0.0
    b.le LGfinish_done
    fmov d8, d2
    fmov d9, d3
    AGET x19, LGfinish_size_key
    mov x20, x0
    cbz x20, LGfinish_first
    GET x20, LGsize_value
    fcmp d0, d8
    b.ne LGfinish_commit
    fcmp d1, d9
    b.eq LGfinish_done
    b LGfinish_commit
LGfinish_first:
    mov x2, #0
    GET x19, LGautoresize
    mov w2, #0
    GET x19, LGdisable_touch
    mov w2, #1
    GET x19, LGhide_accessibility
LGfinish_commit:
    adr x0, LMcorner_class
    bl Lpatch + (0xa5b0 - PATCH_BASE)
    adr x1, LMcapsule
    bl Lmessage
    cbz x0, LGfinish_done
    mov x2, x0
    GET x19, LMset_corner
    adr x0, LGvalue_class
    bl Lpatch + (0xa5b0 - PATCH_BASE)
    fmov d0, d8
    fmov d1, d9
    adr x1, LGvalue_size
    bl Lmessage
    cbz x0, LGfinish_done
    ASET x19, LGfinish_size_key, x0, 1
LGfinish_done:
    mov x0, x19
    ldp d8, d9, [sp, #48]
    ldp x21, x22, [sp, #32]
    ldp x19, x20, [sp, #16]
    ldp x29, x30, [sp], #64
    ret

// The original factory (0x74d0) attaches an effect made at CGRectZero, THEN
// assigns its frame. Its capsule was chosen at zero size and was only fixed
// later by LGfinish. A synchronous didMoveToWindow/layout during insertion,
// or an inherited UIView animation, can therefore expose an unfinished shape.
//
// Bookshelf pills publish one fully configured native capsule. Creation and
// any later size change happen inside our own disabled-actions transaction;
// a new effect remains detached until its frame and capsule are both final.
// Host geometry, ancestors, masks, actions and label/image layout are untouched.
// x0: bookshelf control, d0..d3: finite desired local material frame.
LGshelf_material:
    stp x29, x30, [sp, #-128]!
    mov x29, sp
    stp x19, x20, [sp, #16]
    stp x21, x22, [sp, #32]
    stp x23, x24, [sp, #48]
    stp d8, d9, [sp, #64]
    stp d10, d11, [sp, #80]
    stp d12, d13, [sp, #96]
    stp d14, d15, [sp, #112]
    mov x19, x0
    mov x20, #0
    mov x21, #0
    mov x23, #0
    cbz x19, LGshelf_material_done
    FINITE d0, LGshelf_material_done
    FINITE d1, LGshelf_material_done
    FINITE d2, LGshelf_material_done
    FINITE d3, LGshelf_material_done
    fcmp d2, #0.0
    b.le LGshelf_material_done
    fcmp d3, #0.0
    b.le LGshelf_material_done
    fmov d8, d0
    fmov d9, d1
    fmov d10, d2
    fmov d11, d3
    AGET x19, LGsurface_key
    mov x20, x0
    cbz x20, LGshelf_material_create
    GET x20, LGsuperview
    cbz x0, LGshelf_material_snapshot
    cmp x0, x19
    b.eq LGshelf_material_snapshot
    // A decoration moved elsewhere is no longer this control's surface.
    // Drop only our association; never mutate or remove that other subtree.
    ASET x19, LGsurface_key, xzr, 1
    mov x20, #0
    b LGshelf_material_create
LGshelf_material_snapshot:
    GET x20, LSframe
    fmov d12, d0
    fmov d13, d1
    fmov d14, d2
    fmov d15, d3
    GET x20, LGcorner_configuration
    GET x0, Lretain
    mov x21, x0
    GET x20, LGhidden
    mov x24, x0
    b LGshelf_material_transaction
LGshelf_material_create:
    // The existing constructor creates a retained UIVisualEffectView with Regular glass.
    // It does not attach it. Its provisional zero-size capsule is replaced
    // below before any live parent can observe the view.
    bl Lpatch + (0x7804 - PATCH_BASE)
    mov x20, x0
    cbz x20, LGshelf_material_done
    mov x23, #1
LGshelf_material_transaction:
    adr x0, LGtransaction_class
    bl Lpatch + (0xa5b0 - PATCH_BASE)
    mov x22, x0
    cbz x22, LGshelf_material_prepare
    GET x22, LGtransaction_begin
    mov w2, #1
    GET x22, LGtransaction_disable
LGshelf_material_prepare:
    cbz x23, LGshelf_material_frame
    mov w2, #0
    GET x20, LMset_opaque
    mov x0, x20
    bl Lpatch + (0x73e0 - PATCH_BASE)
    GET x20, LMcontent_view
    mov x24, x0
    cbz x24, LGshelf_material_frame
    mov w2, #0
    GET x24, LMset_opaque
    mov x0, x24
    bl Lpatch + (0x73e0 - PATCH_BASE)
LGshelf_material_frame:
    mov x0, x20
    fmov d0, d8
    fmov d1, d9
    fmov d2, d10
    fmov d3, d11
    bl Lpatch + (0x711c - PATCH_BASE)
    mov x0, x20
    bl LGfinish
LGshelf_material_publish:
    // A cache from the previous size is not proof that this resize succeeded.
    // Missing corner configuration or failed snapshot allocation must leave a
    // fresh object detached, or restore the reused object's previous shape.
    AGET x20, LGfinish_size_key
    cbz x0, LGshelf_material_discard
    GET x0, LGsize_value
    fcmp d0, d10
    b.ne LGshelf_material_discard
    fcmp d1, d11
    b.ne LGshelf_material_discard
    cbz x23, LGshelf_material_background
    ASET x19, LGsurface_key, x20, 1
LGshelf_material_background:
    // Preserve the old factory's clear-background behavior, before insertion
    // so a synchronous mount callback cannot expose a rectangular host fill.
    mov x0, x19
    bl Lpatch + (0x73e0 - PATCH_BASE)
    GET x20, LGsuperview
    cmp x0, x19
    b.eq LGshelf_material_release
    mov x2, x20
    mov x3, #0
    GET x19, LGinsert_at
LGshelf_material_release:
    cbz x23, LGshelf_material_commit
    GET x20, Lrelease
    b LGshelf_material_commit
LGshelf_material_discard:
    cbz x23, LGshelf_material_rollback
    GET x20, Lrelease
    mov x20, #0
    b LGshelf_material_commit
LGshelf_material_rollback:
    mov x0, x20
    fmov d0, d12
    fmov d1, d13
    fmov d2, d14
    fmov d3, d15
    bl Lpatch + (0x711c - PATCH_BASE)
    mov x2, x21
    GET x20, LMset_corner
    GET x20, LGhidden
    cmp x0, x24
    b.eq LGshelf_material_commit
    mov x2, x24
    GET x20, LGset_hidden
LGshelf_material_commit:
    // Keep host-background clearing and insertion in this same transaction:
    // ending it earlier would let a reading-pop animation fade a rectangular
    // host fill to clear while the already-shaped capsule was visible.
    cbz x22, LGshelf_material_release_snapshot
    GET x22, LGtransaction_commit
LGshelf_material_release_snapshot:
    GET x21, Lrelease
LGshelf_material_done:
    mov x0, x20
    ldp d14, d15, [sp, #112]
    ldp d12, d13, [sp, #96]
    ldp d10, d11, [sp, #80]
    ldp d8, d9, [sp, #64]
    ldp x23, x24, [sp, #48]
    ldp x21, x22, [sp, #32]
    ldp x19, x20, [sp, #16]
    ldp x29, x30, [sp], #128
    ret

LGstyle_control:
    stp x29, x30, [sp, #-224]!
    mov x29, sp
    stp x19, x20, [sp, #16]
    stp x21, x22, [sp, #32]
    str x1, [sp, #48]
    mov x19, x0
    mov x22, #0
    bl LGscope
    str x1, [sp, #192]
    str xzr, [sp, #200]
    str w0, [sp, #56]
    .if FQ_VERSION >= 0x10606
    cmp w0, #2
    b.ne LGcontrol_166_scope
    mov x0, x19
    bl LFQH_FQHIsDuration
    cbz w0, LGcontrol_166_scope
    // One material inside the duration owner's own bounds. In particular,
    // never expand this long pill into its clipped parent's coordinate area.
    mov x0, x19
    bl LFQH_FQHApply
    mov x0, x19
    bl LFQH_FQHSurface
    b LGcontrol_return
LGcontrol_166_scope:
    ldr w0, [sp, #56]
    .endif
    .if FQ_VERSION >= 0x10701
    mov x0, x19
    bl LFQH_FQHIsEdit
    cbz w0, LGedit171_other
    AGET x19, LGcontrol_busy_key
    cbnz x0, LGcontrol_reentrant
    ASET x19, LGcontrol_busy_key, x19, 0
    mov x22, #1
    bl LRenabled
    cbz w0, LGcontrol_too_small
    mov x0, x19
    bl LFQH_FQHEditRect
    mov x0, x19
    bl LGshelf_material
    b LGcontrol_done
LGedit171_other:
    ldr w0, [sp, #56]
    .endif
    cbz w0, LGcontrol_fallback
    AGET x19, LGcontrol_busy_key
    cbnz x0, LGcontrol_reentrant
    ASET x19, LGcontrol_busy_key, x19, 0
    mov x22, #1
    ldr w8, [sp, #56]
    cmp w8, #1
    b.eq LGcontrol_original_top
    .if FQ_VERSION >= 0x10704
    sub w9, w8, #3
    cmp w9, #1
    b.hi LGcontrol_page_scope_done
    mov x0, x19
    bl LFQH_FQHReaderOwnsControl
    cbnz w0, LGcontrol_too_small
    ldr w8, [sp, #56]
LGcontrol_page_scope_done:
    .endif
    cmp w8, #2
    b.eq LGcontrol_visibility
    bl LRenabled
    cbz w0, LGcontrol_too_small
LGcontrol_visibility:
    GET x19, LGhidden
    cbnz w0, LGcontrol_too_small
    GET x19, LGalpha
    FINITE d0, LGcontrol_too_small
    fcmp d0, #0.0
    b.le LGcontrol_too_small
    // Settle only pending layout in the scoped leading FQ control before its
    // image is measured; busy was set above to protect synchronous reentry.
    ldr w8, [sp, #56]
    cmp w8, #1
    b.ne LGcontrol_measure
    mov x0, x19
    bl LRsettle_control
LGcontrol_measure:
    // Retain the original control-size envelope; this is not a panel skin.
    GET x19, LGbounds
    FINITE d0, LGcontrol_too_small
    FINITE d1, LGcontrol_too_small
    FINITE d2, LGcontrol_too_small
    FINITE d3, LGcontrol_too_small
    fmov d4, #22.0
    fcmp d2, d4
    b.lt LGcontrol_fallback
    fcmp d3, d4
    b.lt LGcontrol_fallback
    ldr d4, LGmax_control_width
    fcmp d2, d4
    b.gt LGcontrol_fallback
    ldr d4, LGmax_control_height
    fcmp d3, d4
    b.gt LGcontrol_fallback
    add x20, sp, #64
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
    ldr x8, [x20, #40]
    // Unknown custom drawing is not guessed at: preserve the original path.
    cbnz x8, LGcontrol_geometry
    ldr x8, [x20, #72]
    cbz x8, LGcontrol_fallback
    b LGcontrol_too_small
LGcontrol_geometry:
    ldr x8, [x20, #48]
    cmp x8, #1
    b.ne LGcontrol_prepare_geometry
    ldr x8, [x20, #120]
    str x8, [sp, #200]
LGcontrol_prepare_geometry:
    mov x0, x19
    mov x1, x20
    bl LRback_prepare
    mov x0, x19
    mov x1, x20
    bl LGgeometry
    cbz w0, LGcontrol_too_small
    stp d0, d1, [sp, #64]
    stp d2, d3, [sp, #80]
    // The original material factory itself clears host backgroundColor.
    // Capture the exact listen background/foreground BEFORE calling it.
    mov x0, x19
    ldr x1, [sp, #200]
    bl LRcontrol_background
    AGET x19, LGsurface_key
    ldp d0, d1, [sp, #64]
    ldp d2, d3, [sp, #80]
    bl LRstable_rect
    mov x0, x19
    ldr w8, [sp, #56]
    cmp w8, #2
    b.ne LGcontrol_legacy_material
    bl LGshelf_material
    b LGcontrol_material_ready
LGcontrol_legacy_material:
    bl Lpatch + (0x74d0 - PATCH_BASE)
    bl LGfinish
LGcontrol_material_ready:
    mov x21, x0
    cbz x21, LGcontrol_material_failed
    mov x0, x19
    ldr x1, [sp, #192]
    bl LDreader_attach
    mov x0, x21
    b LGcontrol_done
LGcontrol_material_failed:
    mov x0, x19
    bl LRcontrol_background_restore
    mov x0, #0
    b LGcontrol_done
LGcontrol_original_top:
    // LGcontrol_original is the OLD PLUGIN material factory, not a host
    // callback. Returning through it would recreate the unwanted tiny glass.
    // Restore only recorded plugin ownership, without touching host artwork,
    // hit bounds, label layout or target/action registration.
    mov x0, x19
    bl LRrestore_original_top
    mov x0, #0
    b LGcontrol_done
LGcontrol_too_small:
    mov x0, x19
    bl LDreader_detach
    mov x0, x19
    bl LRcontrol_background_restore
    mov x0, x19
    bl LRcontrol_restore
    AGET x19, LGsurface_key
    mov x21, x0
    cbz x21, LGcontrol_empty
    // Release only the plugin-owned decoration. A later visible layout or an
    // out-of-scope original path can then create an unhidden material afresh.
    GET x21, LGsuperview
    cmp x0, x19
    b.ne LGcontrol_clear_surface
    GET x21, LGremove
LGcontrol_clear_surface:
    mov x0, x19
    adr x1, LGsurface_key
    mov x2, #0
    mov w3, #1
    bl Lpatch + (0xa634 - PATCH_BASE)
LGcontrol_empty:
    mov x0, #0
    b LGcontrol_done
LGcontrol_fallback:
    mov x0, x19
    bl LDreader_detach
    mov x0, x19
    bl LRcontrol_background_restore
    mov x0, x19
    bl LRcontrol_restore
    ldr w8, [sp, #56]
    cmp w8, #2
    b.eq LGcontrol_shelf_fallback
    mov x0, x19
    ldr x1, [sp, #48]
    bl LGcontrol_original
    b LGcontrol_done
LGcontrol_shelf_fallback:
    // Unknown/custom-drawn shelf content retains the full-control material
    // envelope but cannot escape into the attach-before-frame legacy helper.
    GET x19, LGbounds
    FINITE d0, LGcontrol_too_small
    FINITE d1, LGcontrol_too_small
    FINITE d2, LGcontrol_too_small
    FINITE d3, LGcontrol_too_small
    fmov d4, #22.0
    fcmp d2, d4
    b.lt LGcontrol_too_small
    fcmp d3, d4
    b.lt LGcontrol_too_small
    ldr d4, LGmax_control_width
    fcmp d2, d4
    b.gt LGcontrol_too_small
    // Match the old fallback's 72pt maximum (scoped reader controls have a
    // separate, larger envelope). Unknown shelf panels are not decorated.
    ldr d4, LGshelf_fallback_height
    fcmp d3, d4
    b.gt LGcontrol_too_small
    mov x0, x19
    bl LGshelf_material
LGcontrol_done:
    cbz x22, LGcontrol_return
    mov x21, x0
    ASET x19, LGcontrol_busy_key, xzr, 0
    mov x0, x21
LGcontrol_return:
    ldp x21, x22, [sp, #32]
    ldp x19, x20, [sp, #16]
    ldp x29, x30, [sp], #224
    ret
LGcontrol_reentrant:
    // A nested layout must leave the outer call's marker in place.
    AGET x19, LGsurface_key
    b LGcontrol_return
LGcontrol_original:
    stp x20, x19, [sp, #-32]!
    b Lpatch + (0x784c - PATCH_BASE)

// Reader-top glyph calls restore original host controls. The legacy plugin
// trampoline remains only for out-of-scope short-video/share/library glyphs.
LGstyle_glyph:
    stp x29, x30, [sp, #-208]!
    mov x29, sp
    stp x19, x20, [sp, #16]
    stp x21, x22, [sp, #32]
    stp x23, x24, [sp, #48]
    mov x19, x0
    mov x20, x1
    bl LGscope
    cmp w0, #1
    b.ne LGglyph_fallback
    // Remove a selector-keyed sibling from the old path, including any caller
    // selector beyond the three historically known navigation getter names.
    mov x0, x19
    mov x1, x20
    bl LRremove_glyph_material
    mov x0, x19
    bl LRrestore_original_top
    b LGglyph_done
LGglyph_fallback:
    mov x0, x19
    mov x1, x20
    ldp x23, x24, [sp, #48]
    ldp x21, x22, [sp, #32]
    ldp x19, x20, [sp, #16]
    ldp x29, x30, [sp], #208
    b LGglyph_original
LGglyph_done:
    ldp x23, x24, [sp, #48]
    ldp x21, x22, [sp, #32]
    ldp x19, x20, [sp, #16]
    ldp x29, x30, [sp], #208
    ret
LGglyph_original:
    stp d11, d10, [sp, #-96]!
    b Lpatch + (0x7ac8 - PATCH_BASE)

LGstreq:
    cbz x0, LGstreq_no
    cbz x1, LGstreq_no
    mov w10, #64
LGstreq_loop:
    ldrb w8, [x0], #1
    ldrb w9, [x1], #1
    cmp w8, w9
    b.ne LGstreq_no
    cbz w8, LGstreq_yes
    subs w10, w10, #1
    b.ne LGstreq_loop
LGstreq_no:
    mov w0, #0
    ret
LGstreq_yes:
    mov w0, #1
    ret

// @COMPONENT_DATA
.p2align 3
LGscope_table:
    .long LGreader_nav - Lpatch, 1
    .long LGstory_big - Lpatch, 1
    .long LGstory_small - Lpatch, 1
    .long LGreader_download - Lpatch, 1
    .long LGshelf_header - Lpatch, 2
    .long LGshelf_subheader - Lpatch, 2
    .long LGshelf_edit - Lpatch, 2
    .long LGshelf_filter - Lpatch, 2
    .long LGreader_menu - Lpatch, 5
    .long LGreader_tools - Lpatch, 3
    .long LGreader_buttons - Lpatch, 3
    .long LGreader_bottom_button - Lpatch, 3
    .long LGreader_floating_button - Lpatch, 4
    .long LGreader_audio_controls - Lpatch, 3
LGreader_menu: .asciz "SSReaderMenuView"
LGreader_tools: .asciz "FQReaderSaaSBottomToolView"
LGreader_buttons: .asciz "FQReaderBottomButtonContainerView"
LGreader_bottom_button: .asciz "SSReaderBottomToolButton"
LGreader_floating_button: .asciz "SSReaderFloatingCommonButton"
LGreader_audio_controls: .asciz "SSNewAudioPlayControlView"
.p2align 3
LGthirty_two: .double 32.0
LGthirty_six: .double 36.0
LGforty: .double 40.0
LGforty_four: .double 44.0
LGfifty_two: .double 52.0
LGsixty_four: .double 64.0
LGsixty_eight: .double 68.0
LGmax_control_width: .double 250.0
LGmax_control_height: .double 96.0
LGshelf_fallback_height: .double 72.0
LGlabel_class: .asciz "UILabel"
LGimage_class: .asciz "UIImageView"
LGvisual_class: .asciz "UIVisualEffectView"
LGcontrol_class: .asciz "UIControl"
LGalpha: .asciz "alpha"
LGclips: .asciz "clipsToBounds"
LGcount: .asciz "count"
LGobject_at: .asciz "objectAtIndex:"
LGtext: .asciz "text"
LGlength: .asciz "length"
LGfont: .asciz "font"
LGline_height: .asciz "lineHeight"
LGintrinsic_size: .asciz "intrinsicContentSize"
LGtext_alignment: .asciz "textAlignment"
LGdirection: .asciz "effectiveUserInterfaceLayoutDirection"
LGimage: .asciz "image"
LGsize: .asciz "size"
LGcontent_mode: .asciz "contentMode"
LGconvert_rect: .asciz "convertRect:toView:"
LGautoresize: .asciz "setAutoresizingMask:"
LGdisable_touch: .asciz "setUserInteractionEnabled:"
LGhide_accessibility: .asciz "setAccessibilityElementsHidden:"
LGvalue_class: .asciz "NSValue"
LGvalue_size: .asciz "valueWithCGSize:"
LGsize_value: .asciz "CGSizeValue"
LGfinish_size_key: .byte 0
LGcontrol_busy_key: .byte 0
LGtransaction_class: .asciz "CATransaction"
LGtransaction_begin: .asciz "begin"
LGtransaction_disable: .asciz "setDisableActions:"
LGtransaction_commit: .asciz "commit"
LGinsert_at: .asciz "insertSubview:atIndex:"
LGcorner_configuration: .asciz "cornerConfiguration"
