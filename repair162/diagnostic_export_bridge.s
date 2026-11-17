// Registers the grouped menu export request on the existing diagnostics store.
LUIinstall_export_bridge:
    stp x29, x30, [sp, #-16]!
    adr x0, LUsettings_menu_class
    bl Lpatch + (0xa5b0 - PATCH_BASE)
    ldp x29, x30, [sp], #16
    cbz x0, LUIinstall_bridge_absent
    adr x1, LUenqueue_sel
    adr x2, LUIenqueue
    b LUIadd_method
LUIinstall_bridge_absent:
    ret

// Grouped settings request. The target owns feedback and presentation.
// No view/window or modal checks participate in creating the log file.
LUIenqueue:
    stp x29, x30, [sp, #-32]!
    mov x29, sp
    stp x19, x20, [sp, #16]
    mov x19, x2
    bl LDdiag_init
    cbz x0, LUIenqueue_unavailable
    adr x0, LUexport_snapshot
    bl Ldiagnostic_snapshot_all
    bl Lnewdict
    mov x20, x0
    mov x2, x19
    adr x1, LUexport_target
    bl Ldict_set
    bl Lnow
    bl Lnumber
    mov x2, x0
    mov x0, x20
    adr x1, LSk_timestamp
    bl Ldict_set
    mov x0, x20
    bl LDdiag_enqueue
    b LUIenqueue_done
LUIenqueue_unavailable:
    bl Lnewdict
    mov x20, x0
    adr x0, LUunavailable
    bl Lstr
    mov x2, x0
    mov x0, x20
    adr x1, LUerror
    bl Ldict_set
    mov x2, x20
    GET x19, LUpresent_sel
LUIenqueue_done:
    ldp x19, x20, [sp, #16]
    ldp x29, x30, [sp], #32
    ret

// @COMPONENT_DATA
LUsettings_menu_class: .asciz "FQXSettingsMenu"
LUenqueue_sel: .asciz "fqx_enqueueDiagnosticExport:"
