// Bounded transition diagnostics for the plugin-owned selection lens.
// Public: LIrecord_transition(proxy, phase CString, candidate UIButton or nil).
// The interaction caller has already validated ownership. This helper follows
// only strong proxy/controller associations; it never follows the raw bound-bar
// pointer, routes a selection, reads labels, or walks a UIKit view subtree.
// Call only at began/ended/cancelled, never on changed or a layout/scroll tick.
// Phase pointers are restricted to this component's three immutable strings.

LIrecord_transition:
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
    cbz x19, LITrecord_done
    adr x8, LIphase_begin
    cmp x20, x8
    b.eq LITrecord_thread
    adr x8, LIphase_ended
    cmp x20, x8
    b.eq LITrecord_thread
    adr x8, LIphase_cancel
    cmp x20, x8
    b.ne LITrecord_done
LITrecord_thread:
    adr x0, LSthread_class
    adr x1, LSmain_thread
    bl Lfactory
    cbz w0, LITrecord_done       // no UIKit access or queue mutation off main
    AGET x19, LIcontroller_key
    mov x23, x0
    AGET x19, LIlens_key
    mov x24, x0
    bl Lnewdict
    mov x22, x0
    cbz x22, LITrecord_done

    mov x0, x20
    bl Lstr
    mov x2, x0
    mov x0, x22
    adr x1, LITfield_phase
    bl Ldict_set

    mov x0, x24
    bl Ldescribe_view           // one owned lens; no children or user text
    mov x2, x0
    mov x0, x22
    adr x1, LITfield_lens
    bl Ldict_set

    AGET x23, LIdrag_key
    cmp x0, #0
    cset w0, ne
    bl Luint
    mov x2, x0
    mov x0, x22
    adr x1, LITfield_dragging
    bl Ldict_set

    AGET x23, LIoffset_key
    cbz x0, LITrecord_no_offset
    GET x0, LIdouble_value
    FINITE d0, LITrecord_no_offset
    bl Lnumber
    mov x2, x0
    b LITrecord_offset
LITrecord_no_offset:
    mov x2, #0                 // missing/nonfinite offset becomes JSON null
LITrecord_offset:
    mov x0, x22
    adr x1, LITfield_offset
    bl Ldict_set

    // Compare the candidate identity with at most eight owned buttons. Do not
    // message the candidate or use its title/accessibility text as an index.
    mov x25, #0
    cbz x21, LITrecord_index
    AGET x19, LIbuttons_key
    mov x26, x0
    cbz x26, LITrecord_index
    GET x26, Lcount
    mov x27, x0
    sub x8, x27, #1
    cmp x8, #7
    b.hi LITrecord_index
    mov x28, #0
LITrecord_find:
    cmp x28, x27
    b.hs LITrecord_index
    mov x2, x28
    GET x26, Lobject_at
    cmp x0, x21
    b.eq LITrecord_found
    add x28, x28, #1
    b LITrecord_find
LITrecord_found:
    mov x0, x28
    bl Luint
    mov x25, x0
LITrecord_index:
    mov x2, x25
    mov x0, x22
    adr x1, LITfield_candidate
    bl Ldict_set

    adr x0, LITevent
    mov x1, x22
    bl Lrecord_named
LITrecord_done:
    ldp x27, x28, [sp, #80]
    ldp x25, x26, [sp, #64]
    ldp x23, x24, [sp, #48]
    ldp x21, x22, [sp, #32]
    ldp x19, x20, [sp, #16]
    ldp x29, x30, [sp], #96
    ret

// @COMPONENT_DATA
.p2align 2
LITdirectory:
    .ascii "FQ161PAN"
    .long 0x10601
    .long 4
    .long LIrecord_transition - Lpatch + PATCH_BASE
    .long LIphase_begin - Lpatch + PATCH_BASE
    .long LIphase_ended - Lpatch + PATCH_BASE
    .long LIphase_cancel - Lpatch + PATCH_BASE
LIphase_begin:  .asciz "began"
LIphase_ended:  .asciz "ended"
LIphase_cancel: .asciz "cancelled"
LITevent: .asciz "glassInteraction"
LITfield_phase: .asciz "phase"
LITfield_lens: .asciz "glassSelectionLens"
LITfield_dragging: .asciz "glassSelectionDragging"
LITfield_offset: .asciz "glassSelectionFingerOffsetX"
LITfield_candidate: .asciz "candidateIndex"
.p2align 2
