// Passive reader-control diagnostics. These callbacks observe UIControl touch
// events only: their ordering relative to host targets is unspecified. A held
// interval is never reported as host action or menu presentation latency.
// The control strongly owns its observer; both observer back-references are
// zeroing weak tables. No gesture, host method replacement, or global hook.
// Public: LDreader_attach(control, exact scoped owner), LDreader_detach(control).

LDrscope: // control, expected nearest scoped owner -> BOOL
    stp x29, x30, [sp, #-64]!
    mov x29, sp
    stp x19, x20, [sp, #16]
    stp x21, x22, [sp, #32]
    mov x19, x0
    mov x20, x1
    cbz x19, LDrscope_no
    cbz x20, LDrscope_no
    adr x1, LGcontrol_class
    bl Lpatch + (0x7394 - PATCH_BASE)
    cbz w0, LDrscope_no
    mov x0, x19
    bl LGscope
    cbz w0, LDrscope_no
    cmp w0, #2                 // bookshelf controls are outside reader scope
    b.eq LDrscope_no
    cmp w0, #5
    b.hi LDrscope_no
    cmp x1, x20
    b.ne LDrscope_no
    adr x21, LRexcluded_controls
    mov w22, #4
LDrscope_excluded:
    ldr w8, [x21], #4
    adr x1, Lpatch
    add x1, x1, x8
    mov x0, x19
    bl Lpatch + (0x7394 - PATCH_BASE)
    cbnz w0, LDrscope_no
    subs w22, w22, #1
    b.ne LDrscope_excluded
    bl LRenabled
    cbz w0, LDrscope_no
    GET x19, Lwindow
    mov x21, x0
    cbz x21, LDrscope_no
    GET x20, Lwindow
    cmp x0, x21
    b.ne LDrscope_no
    mov x0, x19
    mov x1, x20
    bl LRvisible
    b LDrscope_done
LDrscope_no:
    mov w0, #0
LDrscope_done:
    ldp x21, x22, [sp, #32]
    ldp x19, x20, [sp, #16]
    ldp x29, x30, [sp], #64
    ret

LDrclass: // one private observer class, main-thread reader lifecycle only
    stp x29, x30, [sp, #-48]!
    mov x29, sp
    stp x19, x20, [sp, #16]
    adr x0, LDrclass_name
    bl Lpatch + (0xa5b0 - PATCH_BASE)
    mov x19, x0
    cbz x19, LDrclass_create
    AGET x19, LDrclass_owned_key
    cmp x0, x19
    b.ne LDrclass_no         // a foreign class with this name is not ours
    mov x0, x19
    b LDrclass_done
LDrclass_create:
    adr x0, LDobject_class
    bl Lpatch + (0xa5b0 - PATCH_BASE)
    cbz x0, LDrclass_no
    adr x1, LDrclass_name
    mov x2, #0
    bl Lpatch + (0xa61c - PATCH_BASE)
    mov x19, x0
    cbz x19, LDrclass_no
    LDADD x19, LDrdown_sel, LDrdown, LDrtarget_encoding
    cbz w0, LDrclass_no
    LDADD x19, LDrinside_sel, LDrinside, LDrtarget_encoding
    cbz w0, LDrclass_no
    LDADD x19, LDroutside_sel, LDroutside, LDrtarget_encoding
    cbz w0, LDrclass_no
    LDADD x19, LDrcancel_sel, LDrcancel, LDrtarget_encoding
    cbz w0, LDrclass_no
    ASET x19, LDrclass_owned_key, x19, 0
    mov x0, x19
    bl Lpatch + (0xa610 - PATCH_BASE)
    mov x0, x19
    b LDrclass_done
LDrclass_no:
    mov x0, #0
LDrclass_done:
    ldp x19, x20, [sp, #16]
    ldp x29, x30, [sp], #48
    ret

LDreader_attach: // adds only this observer's four targets, once per ownership
    stp x29, x30, [sp, #-80]!
    mov x29, sp
    stp x19, x20, [sp, #16]
    stp x21, x22, [sp, #32]
    stp x23, x24, [sp, #48]
    mov x19, x0
    mov x20, x1
    adr x0, LSthread_class
    adr x1, LSmain_thread
    bl Lfactory
    cbz w0, LDrattach_no       // never inspect or detach UIKit off main
    mov x0, x19
    mov x1, x20
    bl LDrscope
    cbz w0, LDrattach_reject
    AGET x19, LDrobserver_key
    mov x21, x0
    cbz x21, LDrattach_create
    AGET x21, LDrcontrol_key
    GET x0, LXany_object
    cmp x0, x19
    b.ne LDrattach_replace
    AGET x21, LDrowner_key
    GET x0, LXany_object
    cmp x0, x20
    b.eq LDrattach_yes
LDrattach_replace:
    mov x0, x19
    bl LDreader_detach
LDrattach_create:
    mov x0, x19
    bl LRweak_box
    mov x22, x0
    cbz x22, LDrattach_no
    mov x0, x20
    bl LRweak_box
    mov x23, x0
    cbz x23, LDrattach_no
    bl LDrclass
    cbz x0, LDrattach_no
    GET x0, LDalloc
    GET x0, LDinit
    mov x21, x0
    cbz x21, LDrattach_no
    ASET x21, LDrcontrol_key, x22, 1
    ASET x21, LDrowner_key, x23, 1
    // Publish complete ownership before the target becomes reachable.
    ASET x19, LDrobserver_key, x21, 1
    adr x0, LDrdown_sel
    bl Lpatch + (0xa5a4 - PATCH_BASE)
    mov x3, x0
    mov x2, x21
    mov w4, #1                 // UIControlEventTouchDown
    GET x19, LDradd_target
    adr x0, LDrinside_sel
    bl Lpatch + (0xa5a4 - PATCH_BASE)
    mov x3, x0
    mov x2, x21
    mov w4, #64                // UIControlEventTouchUpInside
    GET x19, LDradd_target
    adr x0, LDroutside_sel
    bl Lpatch + (0xa5a4 - PATCH_BASE)
    mov x3, x0
    mov x2, x21
    mov w4, #128               // UIControlEventTouchUpOutside
    GET x19, LDradd_target
    adr x0, LDrcancel_sel
    bl Lpatch + (0xa5a4 - PATCH_BASE)
    mov x3, x0
    mov x2, x21
    mov w4, #256               // UIControlEventTouchCancel
    GET x19, LDradd_target
    GET x21, Lrelease
LDrattach_yes:
    mov w0, #1
    b LDrattach_done
LDrattach_reject:
    mov x0, x19
    bl LDreader_detach
LDrattach_no:
    mov w0, #0
LDrattach_done:
    ldp x23, x24, [sp, #48]
    ldp x21, x22, [sp, #32]
    ldp x19, x20, [sp, #16]
    ldp x29, x30, [sp], #80
    ret

LDreader_detach: // remove only our target; host targets/actions stay intact
    stp x29, x30, [sp, #-32]!
    mov x29, sp
    stp x19, x20, [sp, #16]
    mov x19, x0
    cbz x19, LDrdetach_done
    adr x0, LSthread_class
    adr x1, LSmain_thread
    bl Lfactory
    cbz w0, LDrdetach_done
    AGET x19, LDrobserver_key
    GET x0, Lretain
    mov x20, x0
    cbz x20, LDrdetach_done
    // A queued/reentrant callback fails its association check immediately.
    ASET x19, LDrobserver_key, xzr, 0
    mov x2, x20
    mov x3, #0
    mov w4, #449               // only the four events installed above
    GET x19, LDrremove_target
    ASET x20, LDrcontrol_key, xzr, 0
    ASET x20, LDrowner_key, xzr, 0
    ASET x20, LDrdown_key, xzr, 0
    ASET x20, LDrcontext_key, xzr, 0
    GET x20, Lrelease
LDrdetach_done:
    ldp x19, x20, [sp, #16]
    ldp x29, x30, [sp], #32
    ret

LDrdown:                        // self, _cmd, sender
    mov w3, #0
    b LDreader_touch
LDrinside:
    mov w3, #1
    b LDreader_touch
LDroutside:
    mov w3, #2
    b LDreader_touch
LDrcancel:
    mov w3, #3
    b LDreader_touch

// At most one accepted gesture per 125 ms, with one down and its first terminal
// event. This resets by time, not a permanent per-view counter. Geometry is
// captured once on down and reused as immutable JSON on terminal callbacks;
// a host action may already have detached the reader before our target runs.
LDreader_touch:
    stp x29, x30, [sp, #-128]!
    mov x29, sp
    stp x19, x20, [sp, #16]
    stp x21, x22, [sp, #32]
    stp x23, x24, [sp, #48]
    stp x25, x26, [sp, #64]
    stp d8, d9, [sp, #80]
    mov x19, x0
    mov x20, x2
    mov w22, w3
    mov x21, #0                // retained owner during down validation
    mov x23, #0                // retained immutable geometry
    mov w25, #0                // this callback owns the busy marker
    adr x0, LSthread_class
    adr x1, LSmain_thread
    bl Lfactory
    cbz w0, LDrtouch_done       // observer and UIKit ownership are main-only
    GET x19, Lretain
    cbz x19, LDrtouch_done
    cbz x20, LDrtouch_release
    AGET x20, LDrobserver_key
    cmp x0, x19
    b.ne LDrtouch_release
    AGET x19, LDrcontrol_key
    GET x0, LXany_object
    cmp x0, x20
    b.ne LDrtouch_release
    AGET x19, LDrbusy_key
    cbnz x0, LDrtouch_release
    ASET x19, LDrbusy_key, x19, 0
    mov w25, #1
    bl LRenabled
    cbz w0, LDrtouch_detach
    cmp w22, #3
    b.hi LDrtouch_release
    bl LDsemantic_time
    fmov d8, d0
    FINITE d8, LDrtouch_clear
    fcmp d8, #0.0
    b.lt LDrtouch_clear
    cbnz w22, LDrtouch_terminal
    AGET x19, LDrowner_key
    GET x0, LXany_object
    GET x0, Lretain
    mov x21, x0
    mov x0, x20
    mov x1, x21
    bl LDrscope
    cbz w0, LDrtouch_detach
    AGET x19, LDrlast_down_key
    cbz x0, LDrtouch_accept
    GET x0, LIdouble_value
    fsub d0, d8, d0
    FINITE d0, LDrtouch_clear
    fcmp d0, #0.0
    b.lt LDrtouch_accept       // reset a discontinuous test/system clock
    ldr d1, LDrminimum_gap
    fcmp d0, d1
    b.lt LDrtouch_clear
LDrtouch_accept:
    mov x0, x20
    mov x1, x21
    bl LDrgeometry
    GET x0, Lretain
    mov x23, x0
    cbz x23, LDrtouch_clear
    fmov d0, d8
    bl Lnumber
    mov x24, x0
    cbz x24, LDrtouch_clear
    ASET x19, LDrcontext_key, x23, 1
    ASET x19, LDrdown_key, x24, 1
    ASET x19, LDrlast_down_key, x24, 1
    mov x0, x23
    mov w1, #0
    fmov d0, d8
    fmov d1, xzr
    bl LDrrecord
    b LDrtouch_release
LDrtouch_terminal:
    AGET x19, LDrdown_key
    cbz x0, LDrtouch_release
    GET x0, LIdouble_value
    fsub d9, d8, d0
    FINITE d9, LDrtouch_clear
    fcmp d9, #0.0
    b.lt LDrtouch_clear
    AGET x19, LDrcontext_key
    GET x0, Lretain
    mov x23, x0
    // Consume the pair before enqueueing; duplicate completions cannot log.
    ASET x19, LDrdown_key, xzr, 0
    ASET x19, LDrcontext_key, xzr, 0
    cbz x23, LDrtouch_release
    mov x0, x23
    mov w1, w22
    fmov d0, d8
    fmov d1, d9
    bl LDrrecord
    b LDrtouch_release
LDrtouch_detach:
    mov x0, x20
    bl LDreader_detach
    b LDrtouch_release
LDrtouch_clear:
    ASET x19, LDrdown_key, xzr, 0
    ASET x19, LDrcontext_key, xzr, 0
LDrtouch_release:
    cbz w25, LDrtouch_unretained
    ASET x19, LDrbusy_key, xzr, 0
LDrtouch_unretained:
    GET x23, Lrelease
    GET x21, Lrelease
    GET x19, Lrelease
LDrtouch_done:
    ldp d8, d9, [sp, #80]
    ldp x25, x26, [sp, #64]
    ldp x23, x24, [sp, #48]
    ldp x21, x22, [sp, #32]
    ldp x19, x20, [sp, #16]
    ldp x29, x30, [sp], #128
    ret

LDr_runtime_class: // true runtime class; never a view/user-content description
    stp x29, x30, [sp, #-16]!
    mov x29, sp
    bl Lpatch + (0xa664 - PATCH_BASE)
    GET x0, LSdescription
    ldp x29, x30, [sp], #16
    ret

LDrgeometry: // control, owner -> immutable-by-convention geometry dictionary
    stp x29, x30, [sp, #-112]!
    mov x29, sp
    stp x19, x20, [sp, #16]
    stp x21, x22, [sp, #32]
    stp d8, d9, [sp, #48]
    stp d10, d11, [sp, #64]
    mov x19, x0
    mov x20, x1
    GET x19, LGbounds
    FINITE d0, LDrgeometry_no
    FINITE d1, LDrgeometry_no
    FINITE d2, LDrgeometry_no
    FINITE d3, LDrgeometry_no
    fcmp d2, #0.0
    b.le LDrgeometry_no
    fcmp d3, #0.0
    b.le LDrgeometry_no
    fmov d8, d0
    fmov d9, d1
    fmov d10, d2
    fmov d11, d3
    bl Lnewdict
    mov x21, x0
    cbz x21, LDrgeometry_no
    fmov d0, d8
    fmov d1, d9
    fmov d2, d10
    fmov d3, d11
    bl Lrect_array
    mov x2, x0
    mov x0, x21
    adr x1, LDrfield_bounds
    bl Ldict_set
    fmov d0, d8
    fmov d1, d9
    fmov d2, d10
    fmov d3, d11
    mov x2, x20
    GET x19, LGconvert_rect
    FINITE d0, LDrgeometry_no
    FINITE d1, LDrgeometry_no
    FINITE d2, LDrgeometry_no
    FINITE d3, LDrgeometry_no
    bl Lrect_array
    mov x2, x0
    mov x0, x21
    adr x1, LDrfield_owner_rect
    bl Ldict_set
    mov x0, x19
    bl LDr_runtime_class
    mov x2, x0
    mov x0, x21
    adr x1, LDrfield_control_class
    bl Ldict_set
    mov x0, x20
    bl LDr_runtime_class
    mov x2, x0
    mov x0, x21
    adr x1, LDrfield_owner_class
    bl Ldict_set
    GET x19, LDris_enabled
    bl Luint
    mov x2, x0
    mov x0, x21
    adr x1, LDrfield_enabled
    bl Ldict_set
    GET x19, LRinteractive
    bl Luint
    mov x2, x0
    mov x0, x21
    adr x1, LDrfield_interactive
    bl Ldict_set
    AGET x19, LGsurface_key
    mov x22, x0
    cbz x22, LDrgeometry_yes
    GET x22, LGsuperview
    cmp x0, x19
    b.ne LDrgeometry_yes
    GET x22, LSframe
    FINITE d0, LDrgeometry_yes
    FINITE d1, LDrgeometry_yes
    FINITE d2, LDrgeometry_yes
    FINITE d3, LDrgeometry_yes
    stp d0, d1, [sp, #80]
    stp d2, d3, [sp, #96]
    bl Lrect_array
    mov x2, x0
    mov x0, x21
    adr x1, LDrfield_material
    bl Ldict_set
    ldp d0, d1, [sp, #80]
    ldp d2, d3, [sp, #96]
    mov w0, #0
    fcmp d2, #0.0
    b.lt LDrgeometry_fits
    fcmp d3, #0.0
    b.lt LDrgeometry_fits
    fcmp d0, d8
    b.lt LDrgeometry_fits
    fcmp d1, d9
    b.lt LDrgeometry_fits
    fadd d0, d0, d2
    fadd d1, d1, d3
    fadd d2, d8, d10
    fadd d3, d9, d11
    fcmp d0, d2
    b.gt LDrgeometry_fits
    fcmp d1, d3
    b.gt LDrgeometry_fits
    mov w0, #1
LDrgeometry_fits:
    bl Luint
    mov x2, x0
    mov x0, x21
    adr x1, LDrfield_material_fits
    bl Ldict_set
LDrgeometry_yes:
    mov x0, x21
    b LDrgeometry_done
LDrgeometry_no:
    mov x0, #0
LDrgeometry_done:
    ldp d10, d11, [sp, #64]
    ldp d8, d9, [sp, #48]
    ldp x21, x22, [sp, #32]
    ldp x19, x20, [sp, #16]
    ldp x29, x30, [sp], #112
    ret

LDrrecord: // geometry, phase; d0 uptime, d1 held seconds (terminal only)
    stp x29, x30, [sp, #-80]!
    mov x29, sp
    stp x19, x20, [sp, #16]
    stp x21, x22, [sp, #32]
    stp d8, d9, [sp, #48]
    mov x19, x0
    mov w20, w1
    fmov d8, d0
    fmov d9, d1
    bl Lnewdict
    mov x21, x0
    cbz x21, LDrrecord_done
    mov x2, x19
    adr x1, LDrfield_geometry
    bl Ldict_set
    adr x8, LDrphase_table
    ldr w8, [x8, x20, lsl #2]
    adr x0, Lpatch
    add x0, x0, x8
    bl Lstr
    mov x2, x0
    mov x0, x21
    adr x1, LDrfield_phase
    bl Ldict_set
    fmov d0, d8
    bl Lnumber
    mov x2, x0
    mov x0, x21
    adr x1, LDrfield_uptime
    bl Ldict_set
    cbz w20, LDrrecord_scope
    ldr d0, LRthousand
    fmul d0, d9, d0
    bl Lnumber
    mov x2, x0
    mov x0, x21
    adr x1, LDrfield_held
    bl Ldict_set
LDrrecord_scope:
    adr x0, LDrscope_description
    bl Lstr
    mov x2, x0
    mov x0, x21
    adr x1, LDrfield_scope
    bl Ldict_set
    adr x0, LDrevent
    mov x1, x21
    bl Lrecord_named
LDrrecord_done:
    ldp d8, d9, [sp, #48]
    ldp x21, x22, [sp, #32]
    ldp x19, x20, [sp, #16]
    ldp x29, x30, [sp], #80
    ret

// @COMPONENT_DATA
.p2align 3
LDrminimum_gap: .double 0.125
LDrobserver_key: .byte 0
LDrcontrol_key: .byte 0
LDrowner_key: .byte 0
LDrdown_key: .byte 0
LDrcontext_key: .byte 0
LDrlast_down_key: .byte 0
LDrbusy_key: .byte 0
LDrclass_owned_key: .byte 0
LDrclass_name: .asciz "FQABReaderTouchObserver160"
LDrtarget_encoding: .asciz "v24@0:8@16"
LDrdown_sel: .asciz "fqab160_readerTouchDown:"
LDrinside_sel: .asciz "fqab160_readerTouchUpInside:"
LDroutside_sel: .asciz "fqab160_readerTouchUpOutside:"
LDrcancel_sel: .asciz "fqab160_readerTouchCancel:"
LDradd_target: .asciz "addTarget:action:forControlEvents:"
LDrremove_target: .asciz "removeTarget:action:forControlEvents:"
LDris_enabled: .asciz "isEnabled"
LDrevent: .asciz "reader_touch"
LDrfield_geometry: .asciz "readerTouchDownGeometry"
LDrfield_phase: .asciz "readerTouchPhase"
LDrfield_uptime: .asciz "readerTouchUptime"
LDrfield_held: .asciz "readerTouchCallbackIntervalMs"
LDrfield_scope: .asciz "readerTouchObservationScope"
LDrscope_description: .asciz "UIControl callback interval; may include earlier targets; not host action or presentation timing"
LDrfield_bounds: .asciz "readerControlBounds"
LDrfield_owner_rect: .asciz "readerControlFrameInOwner"
LDrfield_control_class: .asciz "readerControlRuntimeClass"
LDrfield_owner_class: .asciz "readerOwnerClass"
LDrfield_enabled: .asciz "readerControlEnabled"
LDrfield_interactive: .asciz "readerControlUserInteractionEnabled"
LDrfield_material: .asciz "readerMaterialFrame"
LDrfield_material_fits: .asciz "readerMaterialWithinControlBounds"
LDrdown_name: .asciz "down"
LDrinside_name: .asciz "upInside"
LDroutside_name: .asciz "upOutside"
LDrcancel_name: .asciz "cancel"
.p2align 2
LDrphase_table:
    .long LDrdown_name - Lpatch, LDrinside_name - Lpatch
    .long LDroutside_name - Lpatch, LDrcancel_name - Lpatch
