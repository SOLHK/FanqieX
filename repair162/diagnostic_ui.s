// Main-thread diagnostic capture and the plugin-owned export UI.
// All persisted fields are Foundation JSON values, never live UIKit objects.
// Only export commands briefly retain their requesting settings controller.

Lfactory: // x0 class CString, x1 no-argument selector CString -> object
    stp x29, x30, [sp, #-32]!
    mov x29, sp
    stp x19, x20, [sp, #16]
    mov x19, x1
    bl Lpatch + (0xa5b0 - PATCH_BASE)
    mov x1, x19
    bl Lmessage
    ldp x19, x20, [sp, #16]
    ldp x29, x30, [sp], #32
    ret
Lnewdict:
    adr x0, LSdictionary_class
    adr x1, LSdictionary
    b Lfactory
Lnewarray:
    adr x0, LSarray_class
    adr x1, LSarray
    b Lfactory
Lstr: // UTF-8 CString -> autoreleased NSString
    stp x29, x30, [sp, #-32]!
    mov x29, sp
    stp x19, x20, [sp, #16]
    mov x19, x0
    adr x0, LSstring_class
    bl Lpatch + (0xa5b0 - PATCH_BASE)
    mov x2, x19
    adr x1, LSstring_utf8
    bl Lmessage
    ldp x19, x20, [sp, #16]
    ldp x29, x30, [sp], #32
    ret
Luint:
    stp x29, x30, [sp, #-32]!
    mov x29, sp
    stp x19, x20, [sp, #16]
    mov x19, x0
    adr x0, Lnumber_class
    bl Lpatch + (0xa5b0 - PATCH_BASE)
    mov x2, x19
    adr x1, LSnumber_uint
    bl Lmessage
    ldp x19, x20, [sp, #16]
    ldp x29, x30, [sp], #32
    ret
Lnumber:
    stp x29, x30, [sp, #-32]!
    mov x29, sp
    stp d8, d9, [sp, #16]
    FINITE d0, LSnumber_invalid
    fmov d8, d0
    adr x0, Lnumber_class
    bl Lpatch + (0xa5b0 - PATCH_BASE)
    fmov d0, d8
    adr x1, LSnumber_double
    bl Lmessage
    b LSnumber_done
LSnumber_invalid:
    adr x0, LSnonfinite
    bl Lstr
LSnumber_done:
    ldp d8, d9, [sp, #16]
    ldp x29, x30, [sp], #32
    ret
Ldict_set: // mutable dictionary, key CString, value (nil becomes NSNull)
    stp x29, x30, [sp, #-48]!
    mov x29, sp
    stp x19, x20, [sp, #16]
    stp x21, x22, [sp, #32]
    mov x19, x0
    mov x21, x1
    mov x20, x2
    cbnz x20, LSdict_has_value
    adr x0, LSnull_class
    adr x1, LSnull
    bl Lfactory
    mov x20, x0
LSdict_has_value:
    mov x0, x21
    bl Lstr
    mov x3, x0
    mov x2, x20
    GET x19, LSset_object
    ldp x21, x22, [sp, #32]
    ldp x19, x20, [sp, #16]
    ldp x29, x30, [sp], #48
    ret
Lnow:
    stp x29, x30, [sp, #-16]!
    mov x29, sp
    adr x0, LSdate_class
    adr x1, LSdate
    bl Lfactory
    adr x1, LStime
    bl Lmessage
    ldp x29, x30, [sp], #16
    ret
Lrect_array:
    stp x29, x30, [sp, #-64]!
    mov x29, sp
    stp x19, x20, [sp, #16]
    stp d8, d9, [sp, #32]
    stp d10, d11, [sp, #48]
    fmov d8, d0
    fmov d9, d1
    fmov d10, d2
    fmov d11, d3
    bl Lnewarray
    mov x19, x0
    fmov d0, d8
    bl Lnumber
    mov x2, x0
    GET x19, LSadd_object
    fmov d0, d9
    bl Lnumber
    mov x2, x0
    GET x19, LSadd_object
    fmov d0, d10
    bl Lnumber
    mov x2, x0
    GET x19, LSadd_object
    fmov d0, d11
    bl Lnumber
    mov x2, x0
    GET x19, LSadd_object
    mov x0, x19
    ldp d10, d11, [sp, #48]
    ldp d8, d9, [sp, #32]
    ldp x19, x20, [sp, #16]
    ldp x29, x30, [sp], #64
    ret
Lclass_name: // Uses class description, never a view's/user-content description.
    stp x29, x30, [sp, #-16]!
    mov x29, sp
    adr x1, LSclass
    bl Lmessage
    adr x1, LSdescription
    bl Lmessage
    ldp x29, x30, [sp], #16
    ret

Ldescribe_view:
    stp x29, x30, [sp, #-48]!
    mov x29, sp
    stp x19, x20, [sp, #16]
    stp x21, x22, [sp, #32]
    mov x19, x0
    cbz x19, LSview_nil
    bl Lnewdict
    mov x20, x0
    mov x0, x19
    bl Luint
    mov x2, x0
    mov x0, x20
    adr x1, LSk_id
    bl Ldict_set
    mov x0, x19
    bl Lclass_name
    mov x2, x0
    mov x0, x20
    adr x1, LSk_class
    bl Ldict_set
    GET x19, LSframe
    bl Lrect_array
    mov x2, x0
    mov x0, x20
    adr x1, LSk_frame
    bl Ldict_set
    GET x19, Lbounds
    bl Lrect_array
    mov x2, x0
    mov x0, x20
    adr x1, LSk_bounds
    bl Ldict_set
    GET x19, Lalpha
    bl Lnumber
    mov x2, x0
    mov x0, x20
    adr x1, LSk_alpha
    bl Ldict_set
    GET x19, Lis_hidden
    and w0, w0, #1
    bl Luint
    mov x2, x0
    mov x0, x20
    adr x1, LSk_hidden
    bl Ldict_set
    GET x19, LSopaque
    and w0, w0, #1
    bl Luint
    mov x2, x0
    mov x0, x20
    adr x1, LSk_opaque
    bl Ldict_set
    GET x19, LSbackground
    adr x1, LSdescription
    bl Lmessage
    mov x2, x0
    mov x0, x20
    adr x1, LSk_background
    bl Ldict_set
    GET x19, Llayer
    mov x21, x0
    GET x21, LSbackground
    cbz x0, LSview_no_layer_color
    mov x22, x0
    adr x0, LScolor_class
    bl Lpatch + (0xa5b0 - PATCH_BASE)
    mov x2, x22
    adr x1, LScolor_cg
    bl Lmessage
    adr x1, LSdescription
    bl Lmessage
LSview_no_layer_color:
    mov x2, x0
    mov x0, x20
    adr x1, LSk_layer_color
    bl Ldict_set
    GET x21, LSopacity
    fcvt d0, s0
    bl Lnumber
    mov x2, x0
    mov x0, x20
    adr x1, LSk_layer_opacity
    bl Ldict_set
    GET x21, LSshadow_opacity
    fcvt d0, s0
    bl Lnumber
    mov x2, x0
    mov x0, x20
    adr x1, LSk_shadow_opacity
    bl Ldict_set
    GET x21, LSshadow_radius
    bl Lnumber
    mov x2, x0
    mov x0, x20
    adr x1, LSk_shadow_radius
    bl Ldict_set
    GET x21, LSshould_rasterize
    and w0, w0, #1
    bl Luint
    mov x2, x0
    mov x0, x20
    adr x1, LSk_rasterize
    bl Ldict_set
    GET x21, LSraster_scale
    bl Lnumber
    mov x2, x0
    mov x0, x20
    adr x1, LSk_raster_scale
    bl Ldict_set
    GET x21, LSmask
    cmp x0, #0
    cset w0, ne
    bl Luint
    mov x2, x0
    mov x0, x20
    adr x1, LSk_mask
    bl Ldict_set
    GET x21, LSmasks
    and w0, w0, #1
    bl Luint
    mov x2, x0
    mov x0, x20
    adr x1, LSk_clips
    bl Ldict_set
    mov x0, x19
    adr x1, LSbutton_class
    bl Lpatch + (0x7394 - PATCH_BASE)
    cbz w0, LSview_effect_details
    GET x19, LStitle_label
    mov x21, x0
    adr x1, LSlabel_class
    bl Lpatch + (0x7394 - PATCH_BASE)
    cbz w0, LSview_effect_details
    mov x0, x21
    bl Ldescribe_view
    mov x2, x0
    mov x0, x20
    adr x1, LSk_title_label
    bl Ldict_set
LSview_effect_details:
    mov x0, x19
    adr x1, LSeffect_view_class
    bl Lpatch + (0x7394 - PATCH_BASE)
    cbz w0, LSview_done
    GET x19, LSeffect
    mov x21, x0
    bl Lclass_name
    mov x2, x0
    mov x0, x20
    adr x1, LSk_effect
    bl Ldict_set
    mov x0, x21
    adr x1, LSglass_class
    bl Lpatch + (0x7394 - PATCH_BASE)
    cbz w0, LSview_done
    GET x21, LStint
    adr x1, LSdescription
    bl Lmessage
    mov x2, x0
    mov x0, x20
    adr x1, LSk_tint
    bl Ldict_set
    GET x21, LSinteractive
    and w0, w0, #1
    bl Luint
    mov x2, x0
    mov x0, x20
    adr x1, LSk_interactive
    bl Ldict_set
LSview_done:
    mov x0, x20
    b LSview_return
LSview_nil:
    adr x0, LSnull_class
    adr x1, LSnull
    bl Lfactory
LSview_return:
    ldp x21, x22, [sp, #32]
    ldp x19, x20, [sp, #16]
    ldp x29, x30, [sp], #48
    ret

Ldescribe_children: // Bounded metadata, with explicit truncation/count fields.
    mov w1, #0
Ldescribe_children_inner:
    stp x29, x30, [sp, #-96]!
    mov x29, sp
    stp x19, x20, [sp, #16]
    stp x21, x22, [sp, #32]
    stp x23, x24, [sp, #48]
    stp x25, x26, [sp, #64]
    stp x27, x28, [sp, #80]
    mov w28, w1
    mov x19, x0
    bl Lnewdict
    mov x20, x0
    bl Lnewarray
    mov x21, x0
    GET x19, Lsubviews
    mov x22, x0
    GET x22, Lcount
    mov x23, x0
    bl Luint
    mov x2, x0
    mov x0, x20
    adr x1, LSk_count
    bl Ldict_set
    cmp x23, #16
    cset w0, hi
    bl Luint
    mov x2, x0
    mov x0, x20
    adr x1, LSk_truncated
    bl Ldict_set
    mov x24, #16
    cmp x23, x24
    csel x24, x23, x24, lo
    mov x25, #0
LSchildren_loop:
    cmp x25, x24
    b.hs LSchildren_done
    mov x2, x25
    GET x22, Lobject_at
    mov x26, x0
    bl Ldescribe_view
    mov x27, x0
    cmp w28, #2
    b.hs LSchildren_append
    mov x0, x26
    adr x1, LSbar_wrapper_class
    bl Lpatch + (0x7394 - PATCH_BASE)
    cbnz w0, LSchildren_native
    mov x0, x26
    adr x1, LSnative_bar_class
    bl Lpatch + (0x7394 - PATCH_BASE)
    cbz w0, LSchildren_append
LSchildren_native:
    mov x0, x26
    add w1, w28, #1
    bl Ldescribe_children_inner
    mov x2, x0
    mov x0, x27
    adr x1, LSnative_children
    bl Ldict_set
LSchildren_append:
    mov x2, x27
    GET x21, LSadd_object
    add x25, x25, #1
    b LSchildren_loop
LSchildren_done:
    mov x0, x20
    adr x1, LSk_views
    mov x2, x21
    bl Ldict_set
    mov x0, x20
    ldp x27, x28, [sp, #80]
    ldp x25, x26, [sp, #64]
    ldp x23, x24, [sp, #48]
    ldp x21, x22, [sp, #32]
    ldp x19, x20, [sp, #16]
    ldp x29, x30, [sp], #96
    ret

// All owned effects, without reading titles, search text, or book contents.
Ldescribe_managed:
    stp x29, x30, [sp, #-80]!
    mov x29, sp
    stp x19, x20, [sp, #16]
    stp x21, x22, [sp, #32]
    stp x23, x24, [sp, #48]
    stp x25, x26, [sp, #64]
    mov x19, x0
    bl Lnewarray
    mov x20, x0
    GET x19, Lcount
    mov x21, x0
    mov x22, #0
LSmanaged_loop:
    cmp x22, x21
    b.hs LSmanaged_done
    mov x2, x22
    GET x19, Lobject_at
    mov x23, x0
    mov x2, #0
    GET x23, Lobject_at
    mov x24, x0
    bl Ldescribe_view
    mov x25, x0
    GET x24, Lcontent_size
    fmov d2, d0
    fmov d3, d1
    fmov d0, xzr
    fmov d1, xzr
    bl Lrect_array
    mov x2, x0
    mov x0, x25
    adr x1, LScontent_rect
    bl Ldict_set
    GET x24, Lwindow
    mov x26, x0
    GET x24, Lbounds
    mov x2, x26
    GET x24, Lconvert_rect
    bl Lrect_array
    mov x2, x0
    mov x0, x25
    adr x1, LSwindow_rect
    bl Ldict_set
    mov x2, #2
    GET x23, Lobject_at
    mov x2, x0
    mov x0, x25
    adr x1, LSoriginal_edge_hidden
    bl Ldict_set
    mov x2, #1
    GET x23, Lobject_at
    GET x0, Lis_hidden
    and w0, w0, #1
    bl Luint
    mov x2, x0
    mov x0, x25
    adr x1, LScurrent_edge_hidden
    bl Ldict_set
    mov x2, x25
    GET x20, LSadd_object
    add x22, x22, #1
    b LSmanaged_loop
LSmanaged_done:
    mov x0, x20
    ldp x25, x26, [sp, #64]
    ldp x23, x24, [sp, #48]
    ldp x21, x22, [sp, #32]
    ldp x19, x20, [sp, #16]
    ldp x29, x30, [sp], #80
    ret

Lrecord_named: // x0 event CString, x1 completed immutable-by-convention JSON data
    stp x29, x30, [sp, #-48]!
    mov x29, sp
    stp x19, x20, [sp, #16]
    stp x21, x22, [sp, #32]
    mov x19, x0
    mov x20, x1
    bl Lnewdict
    mov x21, x0
    mov x0, x19
    bl Lstr
    mov x2, x0
    mov x0, x21
    adr x1, LSk_event
    bl Ldict_set
    mov x0, x21
    adr x1, LSk_data
    mov x2, x20
    bl Ldict_set
    bl Lnow
    bl Lnumber
    mov x2, x0
    mov x0, x21
    adr x1, LSk_timestamp
    bl Ldict_set
    adr x0, LSversion
    bl Lstr
    mov x2, x0
    mov x0, x21
    adr x1, LSk_version
    bl Ldict_set
    mov x0, x21
    bl LDdiag_enqueue
    ldp x21, x22, [sp, #32]
    ldp x19, x20, [sp, #16]
    ldp x29, x30, [sp], #48
    ret

Ltracked_bars:
    stp x29, x30, [sp, #-32]!
    mov x29, sp
    stp x19, x20, [sp, #16]
    bl LDdiag_init
    mov x19, x0
    AGET x19, LSbars_key
    cbnz x0, LStracked_done
    adr x0, LShash_class
    adr x1, LSweak_hash
    bl Lfactory
    mov x20, x0
    ASET x19, LSbars_key, x20, 1
    mov x0, x20
LStracked_done:
    ldp x19, x20, [sp, #16]
    ldp x29, x30, [sp], #32
    ret

// Automatic capture uses value-based color/effect state and a 0.5-second
// monotonic gate in the extension. Explicit snapshots below stay unthrottled.
Ldiagnostic_observe:
    b LDobserve_semantic

Ldiagnostic_snapshot: // x0 bar, x1 event CString; main thread only
    stp x29, x30, [sp, #-80]!
    mov x29, sp
    stp x19, x20, [sp, #16]
    stp x21, x22, [sp, #32]
    stp x23, x24, [sp, #48]
    stp x25, x26, [sp, #64]
    mov x19, x0
    mov x20, x1
    cbz x19, LSsnapshot_done
    bl Lnewdict
    mov x21, x0
    mov x0, x19
    adr x1, Lpatch + (0xeb84 - PATCH_BASE)
    bl Lpatch + (0xa628 - PATCH_BASE)
    mov x22, x0
    mov x0, x19
    bl Ldescribe_view
    mov x2, x0
    mov x0, x21
    adr x1, LSk_bar
    bl Ldict_set
    mov x0, x22
    bl Ldescribe_view
    mov x2, x0
    mov x0, x21
    adr x1, LSk_proxy
    bl Ldict_set
    GET x19, Lcontent_view
    bl Ldescribe_view
    mov x2, x0
    mov x0, x21
    adr x1, LSk_bar_content
    bl Ldict_set
    GET x22, Lcontent_view
    bl Ldescribe_view
    mov x2, x0
    mov x0, x21
    adr x1, LSk_proxy_content
    bl Ldict_set
    mov x0, x19
    bl Ldescribe_children
    mov x2, x0
    mov x0, x21
    adr x1, LSk_bar_children
    bl Ldict_set
    mov x0, x22
    bl Ldescribe_children
    mov x2, x0
    mov x0, x21
    adr x1, LSk_proxy_children
    bl Ldict_set
    GET x22, Lcontent_view
    bl Ldescribe_children
    mov x2, x0
    mov x0, x21
    adr x1, LSk_content_children
    bl Ldict_set
    GET x19, Lsuperview
    mov x23, x0
    bl Ldescribe_children
    mov x2, x0
    mov x0, x21
    adr x1, LSk_siblings
    bl Ldict_set
    AGET x19, Ledge_key
    bl Ldescribe_managed
    mov x2, x0
    mov x0, x21
    adr x1, LSk_managed_scroll
    bl Ldict_set
    AGET x19, Lparent_key
    mov x2, x0
    mov x0, x21
    adr x1, LSk_edge_original
    bl Ldict_set
    AGET x19, Lselected_key
    mov x2, x0
    mov x0, x21
    adr x1, LSk_edge_current
    bl Ldict_set
    bl Lnewarray
    mov x24, x0
    mov w25, #8
LSancestor_loop:
    cbz x23, LSancestor_done
    cbz w25, LSancestor_done
    mov x0, x23
    bl Ldescribe_view
    mov x2, x0
    GET x24, LSadd_object
    GET x23, Lsuperview
    mov x23, x0
    sub w25, w25, #1
    b LSancestor_loop
LSancestor_done:
    mov x0, x21
    adr x1, LSk_ancestors
    mov x2, x24
    bl Ldict_set
    cmp x23, #0
    cset w0, ne
    bl Luint
    mov x2, x0
    mov x0, x21
    adr x1, LSk_ancestor_truncated
    bl Ldict_set
    GET x19, LSitems
    mov x23, x0
    cbz x23, LSsnapshot_unknown_selection
    GET x19, Lselected_item
    cbz x0, LSsnapshot_unknown_selection
    mov x2, x0
    GET x23, LSindex_identical
    cmp x0, #255
    b.hi LSsnapshot_unknown_selection
    bl Luint
    b LSsnapshot_selection_ready
LSsnapshot_unknown_selection:
    mov x0, #0
LSsnapshot_selection_ready:
    mov x2, x0
    mov x0, x21
    adr x1, LSk_selected
    bl Ldict_set
    AGET x19, Lpatch + (0xeb84 - PATCH_BASE)
    bl LNhas_native
    adr x8, LSnative_style
    adr x9, LSregular_style
    cmp w0, #0
    csel x0, x8, x9, ne
    bl Lstr
    mov x2, x0
    mov x0, x21
    adr x1, LSk_style
    bl Ldict_set
    GET x19, LStraits
    adr x1, LScontrast
    bl Lmessage
    bl Luint
    mov x2, x0
    mov x0, x21
    adr x1, LSk_contrast
    bl Ldict_set
    adr x0, LSunknown_transparency
    bl Lstr
    mov x2, x0
    mov x0, x21
    adr x1, LSk_transparency
    bl Ldict_set
    adr x0, LSprocess_class
    adr x1, LSprocess
    bl Lfactory
    adr x1, LSos_version
    bl Lmessage
    mov x2, x0
    mov x0, x21
    adr x1, LSk_os
    bl Ldict_set
    bl Lpatch + (0x4338 - PATCH_BASE)
    bl Luint
    mov x2, x0
    mov x0, x21
    adr x1, LSk_options
    bl Ldict_set
    mov x0, x19
    mov x1, x21
    bl LXsnapshot
    mov x0, x19
    mov x1, x21
    bl LFsnapshot
    mov x0, x20
    mov x1, x21
    bl Lrecord_named
LSsnapshot_done:
    ldp x25, x26, [sp, #64]
    ldp x23, x24, [sp, #48]
    ldp x21, x22, [sp, #32]
    ldp x19, x20, [sp, #16]
    ldp x29, x30, [sp], #80
    ret

Ldiagnostic_heartbeat:
    adr x0, LSperiodic
    b Ldiagnostic_snapshot_all
Ldiagnostic_snapshot_all:
    stp x29, x30, [sp, #-64]!
    mov x29, sp
    stp x19, x20, [sp, #16]
    stp x21, x22, [sp, #32]
    stp x23, x24, [sp, #48]
    mov x19, x0
    adr x0, LSthread_class
    adr x1, LSmain_thread
    bl Lfactory
    cbz w0, LSsnapshot_all_done
    bl Ltracked_bars
    adr x1, LSall_objects
    bl Lmessage
    mov x20, x0
    GET x20, Lcount
    mov x21, x0
    mov x22, #0
    cbnz x21, LSsnapshot_all_loop
    mov x0, x19
    mov x1, #0
    bl Lrecord_named
    b LSsnapshot_all_done
LSsnapshot_all_loop:
    cmp x22, x21
    b.hs LSsnapshot_all_done
    mov x2, x22
    GET x20, Lobject_at
    mov x1, x19
    bl Ldiagnostic_snapshot
    add x22, x22, #1
    b LSsnapshot_all_loop
LSsnapshot_all_done:
    ldp x23, x24, [sp, #48]
    ldp x21, x22, [sp, #32]
    ldp x19, x20, [sp, #16]
    ldp x29, x30, [sp], #64
    ret

Lsettings_boot:
    stp x29, x30, [sp, #-16]!
    mov x29, sp
    bl Lsettings_original
    bl LDdiag_init
    adr x0, LSstartup
    mov x1, #0
    bl Lrecord_named
    ldp x29, x30, [sp], #16
    ret
Lsettings_original:
    stp x22, x21, [sp, #-48]!
    b Lpatch + (0x4708 - PATCH_BASE)

// x0 Class, x1 selector CString, x2 IMP. Add only our methods; accept an
// already-installed identical implementation, never replace another owner.
LUIadd_method:
    stp x29, x30, [sp, #-48]!
    mov x29, sp
    stp x19, x20, [sp, #16]
    stp x21, x22, [sp, #32]
    mov x19, x0
    mov x21, x2
    mov x0, x1
    bl Lpatch + (0xa5a4 - PATCH_BASE)
    mov x20, x0
    mov x1, x20
    mov x0, x19
    mov x2, x21
    adr x3, Lobject_encoding
    bl Lpatch + (0xa58c - PATCH_BASE)
    cbnz w0, LUIadd_done
    mov x0, x19
    mov x1, x20
    bl Lpatch + (0xa5f8 - PATCH_BASE)
    cbz x0, LUIadd_done
    bl Lpatch + (0xa598 - PATCH_BASE)
    cmp x0, x21
    cset w0, eq
LUIadd_done:
    ldp x21, x22, [sp, #32]
    ldp x19, x20, [sp, #16]
    ldp x29, x30, [sp], #48
    ret

// Called at the audited NOP in _open_menu. x20 is the newly created plugin
// options controller; all original live callee-saved registers are preserved.
LUIinstall:
    stp x29, x30, [sp, #-64]!
    mov x29, sp
    stp x19, x20, [sp, #16]
    stp x21, x22, [sp, #32]
    stp x23, x24, [sp, #48]
    mov x19, x20
    cbz x19, LUIinstall_done
    // The product has one public name. Keep historical preference/class keys
    // intact so an upgrade preserves settings and the last hour of logs.
    adr x0, LUproduct_name
    bl Lstr
    mov x2, x0
    GET x19, LUset_title
    GET x19, LSclass
    mov x20, x0
    adr x1, LUexport_sel
    adr x2, LUIexport
    bl LUIadd_method
    cbz w0, LUIinstall_done
    mov x0, x20
    adr x1, LUpresent_sel
    adr x2, LUIpresent
    bl LUIadd_method
    cbz w0, LUIinstall_done
    adr x0, LUexport_title
    bl Lstr
    mov x21, x0
    adr x0, LUexport_sel
    bl Lpatch + (0xa5a4 - PATCH_BASE)
    mov x23, x0
    adr x0, LUitem_class
    adr x1, LUalloc
    bl Lfactory
    mov x2, x21
    mov w3, #0
    mov x4, x19
    mov x5, x23
    adr x1, LUinit_item
    bl Lmessage
    mov x22, x0
    cbz x22, LUIinstall_done
    GET x19, LUnavigation_item
    mov x2, x22
    adr x1, LUset_left_item
    bl Lmessage
    GET x22, Lrelease
    .if FQ_VERSION >= 0x10604
    mov x0, x19
    bl LFQD_FQDSettings
    .endif
LUIinstall_done:
    ldp x23, x24, [sp, #48]
    ldp x21, x22, [sp, #32]
    ldp x19, x20, [sp, #16]
    ldp x29, x30, [sp], #64
    ret

LUIexport: // Objective-C action: self, _cmd, sender
    stp x29, x30, [sp, #-48]!
    mov x29, sp
    stp x19, x20, [sp, #16]
    stp x21, x22, [sp, #32]
    mov x19, x0
    mov x20, x2
    cbz x20, LUIexport_done
    AGET x19, LUbusy_key
    cbnz x0, LUIexport_done
    GET x19, LUpresented
    cbnz x0, LUIexport_done
    GET x19, LUview
    GET x0, Lwindow
    cbz x0, LUIexport_done
    ASET x19, LUbusy_key, x19, 0
    ASET x19, LUsender_key, x20, 1
    mov w2, #0
    GET x20, LUset_enabled
    bl LDdiag_init
    cbz x0, LUIexport_unavailable
    adr x0, LUexport_snapshot
    bl Ldiagnostic_snapshot_all
    bl Lnewdict
    mov x21, x0
    mov x2, x19
    adr x1, LUexport_target
    bl Ldict_set
    bl Lnow
    bl Lnumber
    mov x2, x0
    mov x0, x21
    adr x1, LSk_timestamp
    bl Ldict_set
    mov x0, x21
    bl LDdiag_enqueue
    b LUIexport_done
LUIexport_unavailable:
    bl Lnewdict
    mov x21, x0
    adr x0, LUunavailable
    bl Lstr
    mov x2, x0
    mov x0, x21
    adr x1, LUerror
    bl Ldict_set
    mov x0, x19
    mov x2, x21
    bl LUIpresent
LUIexport_done:
    ldp x21, x22, [sp, #32]
    ldp x19, x20, [sp, #16]
    ldp x29, x30, [sp], #48
    ret

// Worker completion is explicitly scheduled on the main thread. The result
// contains a unique file URL or a readable error; UIKit never runs on worker.
LUIpresent:
    stp x29, x30, [sp, #-64]!
    mov x29, sp
    stp x19, x20, [sp, #16]
    stp x21, x22, [sp, #32]
    stp x23, x24, [sp, #48]
    mov x19, x0
    mov x21, x2
    AGET x19, LUsender_key
    GET x0, Lretain
    mov x20, x0
    ASET x19, LUbusy_key, xzr, 0
    mov w2, #1
    GET x20, LUset_enabled
    ASET x19, LUsender_key, xzr, 1
    cbz x20, LUIpresent_done
    GET x19, LUview
    GET x0, Lwindow
    cbz x0, LUIpresent_release_sender
    GET x19, LUpresented
    cbnz x0, LUIpresent_release_sender
    adr x0, LUurl
    bl Lstr
    mov x2, x0
    GET x21, LUobject_key
    mov x22, x0
    cbz x22, LUIpresent_error
    adr x0, LUarray_class
    bl Lpatch + (0xa5b0 - PATCH_BASE)
    mov x2, x22
    adr x1, LUarray_object
    bl Lmessage
    mov x23, x0
    adr x0, LUactivity_class
    adr x1, LUalloc
    bl Lfactory
    mov x2, x23
    mov x3, xzr
    adr x1, LUinit_activity
    bl Lmessage
    mov x22, x0
    cbz x22, LUIpresent_release_sender
    GET x22, LUpopover
    mov x2, x20
    adr x1, LUset_anchor
    bl Lmessage
    mov x2, x22
    mov w3, #1
    mov x4, xzr
    GET x19, LUpresent
    GET x22, Lrelease
    b LUIpresent_release_sender
LUIpresent_error:
    adr x0, LUerror
    bl Lstr
    mov x2, x0
    GET x21, LUobject_key
    mov x22, x0
    cbnz x22, LUIhas_error
    adr x0, LUunavailable
    bl Lstr
    mov x22, x0
LUIhas_error:
    adr x0, LUfailure_title
    bl Lstr
    mov x23, x0
    adr x0, LUalert_class
    bl Lpatch + (0xa5b0 - PATCH_BASE)
    mov x2, x23
    mov x3, x22
    mov w4, #1
    adr x1, LUalert_factory
    bl Lmessage
    mov x22, x0
    adr x0, LUokay
    bl Lstr
    mov x23, x0
    adr x0, LUaction_class
    bl Lpatch + (0xa5b0 - PATCH_BASE)
    mov x2, x23
    mov w3, #0
    mov x4, xzr
    adr x1, LUaction_factory
    bl Lmessage
    mov x2, x0
    GET x22, LUadd_action
    mov x2, x22
    mov w3, #1
    mov x4, xzr
    GET x19, LUpresent
LUIpresent_release_sender:
    GET x20, Lrelease
LUIpresent_done:
    ldp x23, x24, [sp, #48]
    ldp x21, x22, [sp, #32]
    ldp x19, x20, [sp, #16]
    ldp x29, x30, [sp], #64
    ret

// @COMPONENT_DATA
LSbar_wrapper_class: .asciz "UIKit._UITabBarContainerWrapperView"
LSnative_bar_class: .asciz "UITabBar"
LSnative_children: .asciz "nativeChildren"
LScontent_rect: .asciz "contentRect"
LSwindow_rect: .asciz "windowRect"
LSoriginal_edge_hidden: .asciz "originalBottomEdgeHidden"
LScurrent_edge_hidden: .asciz "bottomEdgeHidden"

LSdictionary_class: .asciz "NSMutableDictionary"
LSdictionary: .asciz "dictionary"
LSarray_class: .asciz "NSMutableArray"
LSarray: .asciz "array"
LSstring_class: .asciz "NSString"
LSstring_utf8: .asciz "stringWithUTF8String:"
LSnumber_uint: .asciz "numberWithUnsignedLongLong:"
LSnumber_double: .asciz "numberWithDouble:"
LSnonfinite: .asciz "non-finite"
LSnull_class: .asciz "NSNull"
LSnull: .asciz "null"
LSset_object: .asciz "setObject:forKey:"
LSdate_class: .asciz "NSDate"
LSdate: .asciz "date"
LStime: .asciz "timeIntervalSince1970"
LSadd_object: .asciz "addObject:"
LSclass: .asciz "class"
LSdescription: .asciz "description"
LSframe: .asciz "frame"
LSopaque: .asciz "isOpaque"
LSbackground: .asciz "backgroundColor"
LScolor_class: .asciz "UIColor"
LScolor_cg: .asciz "colorWithCGColor:"
LSopacity: .asciz "opacity"
LSshadow_opacity: .asciz "shadowOpacity"
LSshadow_radius: .asciz "shadowRadius"
LSshould_rasterize: .asciz "shouldRasterize"
LSraster_scale: .asciz "rasterizationScale"
LSbutton_class: .asciz "UIButton"
LSlabel_class: .asciz "UILabel"
LStitle_label: .asciz "titleLabel"
LSmask: .asciz "mask"
LSmasks: .asciz "masksToBounds"
LSeffect_view_class: .asciz "UIVisualEffectView"
LSeffect: .asciz "effect"
LSglass_class: .asciz "UIGlassEffect"
LStint: .asciz "tintColor"
LSinteractive: .asciz "isInteractive"
LSversion:
    .if FQ_VERSION == 0x10605
    .asciz "1.6.5"
    .elseif FQ_VERSION >= 0x10604
    .asciz "1.6.4"
    .elseif FQ_VERSION == 0x10603
    .asciz "1.6.3"
    .else
    .asciz "1.6.2"
    .endif
LSk_id: .asciz "viewId"
LSk_class: .asciz "class"
LSk_frame: .asciz "frame"
LSk_bounds: .asciz "bounds"
LSk_alpha: .asciz "alpha"
LSk_hidden: .asciz "hidden"
LSk_opaque: .asciz "opaqueHint"
LSk_background: .asciz "backgroundColor"
LSk_layer_color: .asciz "layerBackgroundColor"
LSk_layer_opacity: .asciz "layerOpacity"
LSk_shadow_opacity: .asciz "layerShadowOpacity"
LSk_shadow_radius: .asciz "layerShadowRadius"
LSk_rasterize: .asciz "layerShouldRasterize"
LSk_raster_scale: .asciz "layerRasterizationScale"
LSk_title_label: .asciz "buttonTitleLabel"
LSk_mask: .asciz "hasLayerMask"
LSk_clips: .asciz "masksToBounds"
LSk_effect: .asciz "effectClass"
LSk_tint: .asciz "effectTint"
LSk_interactive: .asciz "effectInteractive"
LSk_count: .asciz "totalCount"
LSk_truncated: .asciz "truncated"
LSk_views: .asciz "views"
LSk_event: .asciz "event"
LSk_data: .asciz "data"
LSk_timestamp: .asciz "timestamp"
LSk_version: .asciz "pluginVersion"
LShash_class: .asciz "NSHashTable"
LSweak_hash: .asciz "weakObjectsHashTable"
LSall_objects: .asciz "allObjects"
LSthread_class: .asciz "NSThread"
LSmain_thread: .asciz "isMainThread"
LSdata_class: .asciz "NSData"
LSdata_bytes: .asciz "dataWithBytes:length:"
LSequal_data: .asciz "isEqualToData:"
LSstate_changed: .asciz "bottom_bar_state_changed"
LSperiodic: .asciz "periodic_snapshot"
LSstartup: .asciz "plugin_start"
LSitems: .asciz "items"
LSindex_identical: .asciz "indexOfObjectIdenticalTo:"
LStraits: .asciz "traitCollection"
LScontrast: .asciz "accessibilityContrast"
LSregular_style: .asciz "Regular (0)"
LSnative_style: .asciz "System native (UISegmentedControl)"
LSunknown_transparency: .asciz "unknown: public C API is not linked by the original plugin"
LSprocess_class: .asciz "NSProcessInfo"
LSprocess: .asciz "processInfo"
LSos_version: .asciz "operatingSystemVersionString"
LSk_bar: .asciz "bar"
LSk_proxy: .asciz "glassProxy"
LSk_bar_content: .asciz "originalBarContent"
LSk_proxy_content: .asciz "glassContent"
LSk_bar_children: .asciz "barChildren"
LSk_proxy_children: .asciz "glassChildren"
LSk_content_children: .asciz "glassContentChildren"
LSk_siblings: .asciz "parentChildren"
LSk_managed_scroll: .asciz "managedScrolls"
LSk_edge_original: .asciz "scrollSearchVisited"
LSk_edge_current: .asciz "scrollSearchTruncationFlags"
LSk_ancestors: .asciz "ancestors"
LSk_ancestor_truncated: .asciz "ancestorChainTruncated"
LSk_selected: .asciz "selectedIndex"
LSk_style: .asciz "requestedGlassStyle"
LSk_contrast: .asciz "accessibilityContrast"
LSk_transparency: .asciz "reduceTransparency"
LSk_os: .asciz "osVersion"
LSk_options: .asciz "pluginOptions"
LSsignature_key: .byte 0
LSbars_key: .byte 0
LUbusy_key: .byte 0
LUsender_key: .byte 0
LUexport_sel: .asciz "fqab_156_exportDiagnostics:"
LUpresent_sel: .asciz "fqab_156_presentDiagnostics:"
LUexport_title: .asciz "导出日志"
LUproduct_name: .asciz "FanqieX"
LUset_title: .asciz "setTitle:"
LUfailure_title: .asciz "日志导出失败"
LUunavailable: .asciz "诊断日志暂时不可用，请稍后重试。"
LUokay: .asciz "好"
LUitem_class: .asciz "UIBarButtonItem"
LUalloc: .asciz "alloc"
LUinit_item: .asciz "initWithTitle:style:target:action:"
LUnavigation_item: .asciz "navigationItem"
LUset_left_item: .asciz "setLeftBarButtonItem:"
LUpresented: .asciz "presentedViewController"
LUview: .asciz "view"
LUset_enabled: .asciz "setEnabled:"
LUexport_snapshot: .asciz "export_snapshot"
LUexport_target: .asciz "exportTarget"
LUerror: .asciz "error"
LUurl: .asciz "url"
LUobject_key: .asciz "objectForKey:"
LUarray_class: .asciz "NSArray"
LUarray_object: .asciz "arrayWithObject:"
LUactivity_class: .asciz "UIActivityViewController"
LUinit_activity: .asciz "initWithActivityItems:applicationActivities:"
LUpopover: .asciz "popoverPresentationController"
LUset_anchor: .asciz "setBarButtonItem:"
LUpresent: .asciz "presentViewController:animated:completion:"
LUalert_class: .asciz "UIAlertController"
LUalert_factory: .asciz "alertControllerWithTitle:message:preferredStyle:"
LUaction_class: .asciz "UIAlertAction"
LUaction_factory: .asciz "actionWithTitle:style:handler:"
LUadd_action: .asciz "addAction:"
