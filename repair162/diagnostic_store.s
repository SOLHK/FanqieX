// FanqieAdBlock 1.5.7 diagnostic store component.
// Main assembly owns Lpatch/PATCH_BASE, GET/AGET/ASET, Lmessage, Lstr,
// Lnumber, Ldict_set and Ldiagnostic_heartbeat. No imports or writable globals.
// Public: LDdiag_init, LDdiag_enqueue, LDdiag_tick, LDdiag_maintenance.
// Store format: binary plist NSArray containing ONE NSData. That NSData is
// JSON for the complete retained record array, preserving JSON null values.

.macro LDGET receiver, key
    mov x0, \receiver
    adr x1, \key
    bl LDdict_get
.endm
.macro LDSET receiver, key, value
    mov x2, \value
    mov x0, \receiver
    adr x1, \key
    bl Ldict_set
.endm
.macro LDNEW name
    adr x0, \name
    bl LDnew
.endm
.macro LDADD klass, sel, imp, encoding
    mov x0, \klass
    adr x1, \sel
    adr x2, \imp
    adr x3, \encoding
    bl LDadd_method
.endm
.macro LDFINITE reg, failure
    fmov x8, \reg
    ubfx x8, x8, #52, #11
    cmp x8, #2047
    b.eq \failure
.endm

// Class bootstrap is called before installing capture hooks. +initialize
// serializes singleton construction even when subsequent callers race.
LDdiag_init:
    stp x29, x30, [sp, #-48]!
    mov x29, sp
    stp x19, x20, [sp, #16]
    stp x21, x22, [sp, #32]
    adr x0, LDclass_name
    bl Lpatch + (0xa5b0 - PATCH_BASE)
    mov x19, x0
    cbnz x19, LDinit_use
    adr x0, LDobject_class
    bl Lpatch + (0xa5b0 - PATCH_BASE)
    adr x1, LDclass_name
    mov x2, #0
    bl Lpatch + (0xa61c - PATCH_BASE)
    mov x19, x0
    cbz x19, LDinit_retry
    LDADD x19, LDdrain_sel, LDdrain, LDobject_encoding
    LDADD x19, LDtick_sel, LDdiag_tick, LDobject_encoding
    LDADD x19, LDtimer_sel, LDstart_timer, LDobject_encoding
    mov x0, x19
    bl Lpatch + (0xa664 - PATCH_BASE)
    mov x20, x0
    LDADD x20, LDinitialize_sel, LDinitialize, LDvoid_encoding
    LDADD x20, LDshared_sel, LDshared, LDreturn_encoding
    mov x0, x19
    bl Lpatch + (0xa610 - PATCH_BASE)
    b LDinit_use
LDinit_retry:
    adr x0, LDclass_name
    bl Lpatch + (0xa5b0 - PATCH_BASE)
    mov x19, x0
LDinit_use:
    cbz x19, LDinit_none
    adr x0, LDshared_sel
    bl Lpatch + (0xa5a4 - PATCH_BASE)
    mov x2, x0
    GET x19, LDresponds
    cbz w0, LDinit_none
    GET x19, LDshared_sel
    b LDinit_done
LDinit_none:
    mov x0, #0
LDinit_done:
    ldp x21, x22, [sp, #32]
    ldp x19, x20, [sp, #16]
    ldp x29, x30, [sp], #48
    ret

LDadd_method:
    stp x29, x30, [sp, #-48]!
    mov x29, sp
    stp x19, x20, [sp, #16]
    stp x21, x22, [sp, #32]
    mov x19, x0
    mov x20, x2
    mov x21, x3
    mov x0, x1
    bl Lpatch + (0xa5a4 - PATCH_BASE)
    mov x1, x0
    mov x0, x19
    mov x2, x20
    mov x3, x21
    bl Lpatch + (0xa58c - PATCH_BASE)
    ldp x21, x22, [sp, #32]
    ldp x19, x20, [sp, #16]
    ldp x29, x30, [sp], #48
    ret

LDshared:
    adr x1, LDsingleton_key
    b Lpatch + (0xa628 - PATCH_BASE)

LDinitialize:
    stp x29, x30, [sp, #-48]!
    mov x29, sp
    stp x19, x20, [sp, #16]
    stp x21, x22, [sp, #32]
    mov x19, x0
    AGET x19, LDsingleton_key
    cbnz x0, LDinitialize_done
    GET x19, LDalloc
    GET x0, LDinit
    mov x20, x0
    LDNEW LDlock_class
    ASET x20, LDlock_key, x0, 1
    LDNEW LDmutable_array
    ASET x20, LDpending_key, x0, 1
    LDNEW LDqueue_class
    mov x21, x0
    mov x2, #1
    GET x21, LDmax_concurrent
    ASET x20, LDqueue_key, x21, 1
    bl LDnow
    bl Lnumber
    ASET x20, LDstart_key, x0, 1
    ASET x19, LDsingleton_key, x20, 1
    GET x20, LDrelease
    adr x0, LDtimer_sel
    bl Lpatch + (0xa5a4 - PATCH_BASE)
    mov x2, x0
    mov x3, #0
    mov w4, #0
    GET x20, LDperform_main
    bl LDdiag_maintenance
LDinitialize_done:
    ldp x21, x22, [sp, #32]
    ldp x19, x20, [sp, #16]
    ldp x29, x30, [sp], #48
    ret

// Invoked on the main thread through NSObject, not assumed in constructor.
LDstart_timer:
    stp x29, x30, [sp, #-48]!
    mov x29, sp
    stp x19, x20, [sp, #16]
    stp x21, x22, [sp, #32]
    mov x19, x0
    AGET x19, LDtimer_key
    cbnz x0, LDtimer_done
    adr x0, LDtimer_class
    bl Lpatch + (0xa5b0 - PATCH_BASE)
    mov x20, x0
    adr x0, LDtick_sel
    bl Lpatch + (0xa5a4 - PATCH_BASE)
    mov x3, x0
    mov x2, x19
    mov x4, #0
    mov w5, #1
    mov w8, #60
    scvtf d0, w8
    GET x20, LDscheduled_timer
    ASET x19, LDtimer_key, x0, 1
LDtimer_done:
    ldp x21, x22, [sp, #32]
    ldp x19, x20, [sp, #16]
    ldp x29, x30, [sp], #48
    ret

LDdiag_tick:
    stp x29, x30, [sp, #-16]!
    mov x29, sp
    bl Ldiagnostic_heartbeat
    bl LDdiag_maintenance
    ldp x29, x30, [sp], #16
    ret

LDdiag_maintenance:
    stp x29, x30, [sp, #-32]!
    mov x29, sp
    stp x19, x20, [sp, #16]
    LDNEW LDmutable_dict
    mov x19, x0
    adr x0, LDtrue_string
    bl Lstr
    LDSET x19, LDmaintenance_field, x0
    mov x0, x19
    bl LDdiag_enqueue
    ldp x19, x20, [sp, #16]
    ldp x29, x30, [sp], #32
    ret

// Commands must be NSDictionary graphs. Root provides fresh, stable nested
// data. The mutable top-level copy owns exportTarget until the marker runs.
// Lock covers timestamp completion, sequence allocation and FIFO insertion.
LDdiag_enqueue:
    stp x29, x30, [sp, #-80]!
    mov x29, sp
    stp x19, x20, [sp, #16]
    stp x21, x22, [sp, #32]
    stp x23, x24, [sp, #48]
    stp x25, x26, [sp, #64]
    mov x19, x0
    cbz x19, LDenqueue_done
    adr x1, LDdict_class
    bl Lpatch + (0x7394 - PATCH_BASE)
    cbz w0, LDenqueue_done
    bl LDdiag_init
    mov x20, x0
    cbz x20, LDenqueue_done
    GET x19, LDmutable_copy
    mov x19, x0
    AGET x20, LDlock_key
    mov x21, x0
    GET x21, LDlock
    LDGET x19, LDtimestamp_field
    mov x22, x0
    adr x1, LDnumber_class
    bl Lpatch + (0x7394 - PATCH_BASE)
    cbz w0, LDenqueue_time
    GET x22, LDdouble_value
    LDFINITE d0, LDenqueue_time
    b LDenqueue_sequence
LDenqueue_time:
    bl LDnow
    bl Lnumber
    LDSET x19, LDtimestamp_field, x0
LDenqueue_sequence:
    AGET x20, LDsequence_key
    GET x0, LDunsigned_value
    add x23, x0, #1
    adr x0, LDnumber_class
    bl Lpatch + (0xa5b0 - PATCH_BASE)
    mov x2, x23
    GET x0, LDunsigned_number
    mov x23, x0
    ASET x20, LDsequence_key, x23, 1
    LDSET x19, LDsequence_field, x23
    AGET x20, LDpending_key
    mov x2, x19
    GET x0, LDadd_object
    GET x21, LDunlock
    GET x19, LDrelease
    mov x0, x20
    bl LDschedule
LDenqueue_done:
    ldp x25, x26, [sp, #64]
    ldp x23, x24, [sp, #48]
    ldp x21, x22, [sp, #32]
    ldp x19, x20, [sp, #16]
    ldp x29, x30, [sp], #80
    ret

// Every enqueue schedules a drain; no running flag and no lost-wakeup window.
// Queue order is irrelevant: every drain consumes the shared FIFO itself.
LDschedule:
    stp x29, x30, [sp, #-48]!
    mov x29, sp
    stp x19, x20, [sp, #16]
    stp x21, x22, [sp, #32]
    mov x19, x0
    adr x0, LDoperation_class
    bl Lpatch + (0xa5b0 - PATCH_BASE)
    GET x0, LDalloc
    mov x20, x0
    adr x0, LDdrain_sel
    bl Lpatch + (0xa5a4 - PATCH_BASE)
    mov x3, x0
    mov x2, x19
    mov x4, #0
    GET x20, LDoperation_init
    mov x20, x0
    cbz x20, LDschedule_done
    AGET x19, LDqueue_key
    mov x2, x20
    GET x0, LDadd_operation
    GET x20, LDrelease
LDschedule_done:
    ldp x21, x22, [sp, #32]
    ldp x19, x20, [sp, #16]
    ldp x29, x30, [sp], #48
    ret

LDnow:
    stp x29, x30, [sp, #-16]!
    mov x29, sp
    adr x0, LDdate_class
    bl Lpatch + (0xa5b0 - PATCH_BASE)
    GET x0, LDdate
    GET x0, LDunix_time
    ldp x29, x30, [sp], #16
    ret

// (class CString) -> autoreleased default-initialized object.
LDnew:
    stp x29, x30, [sp, #-16]!
    mov x29, sp
    bl Lpatch + (0xa5b0 - PATCH_BASE)
    GET x0, LDalloc
    GET x0, LDinit
    GET x0, LDautorelease
    ldp x29, x30, [sp], #16
    ret

// (dictionary, key CString) -> borrowed value.
LDdict_get:
    stp x29, x30, [sp, #-32]!
    mov x29, sp
    stp x19, x20, [sp, #16]
    mov x19, x0
    mov x0, x1
    bl Lstr
    mov x2, x0
    GET x19, LDobject_key
    ldp x19, x20, [sp, #16]
    ldp x29, x30, [sp], #32
    ret

// Worker only: retain a readable, latched error. Successful later writes do
// not hide an earlier lost-history / storage incident in this process.
// (logger, NSError or nil, fallback CString) -> associated NSString.
LDerror:
    stp x29, x30, [sp, #-48]!
    mov x29, sp
    stp x19, x20, [sp, #16]
    stp x21, x22, [sp, #32]
    mov x19, x0
    mov x20, x1
    mov x21, x2
    cbz x20, LDerror_fallback
    GET x20, LDlocalized_error
    cbnz x0, LDerror_store
LDerror_fallback:
    mov x0, x21
    bl Lstr
LDerror_store:
    mov x20, x0
    ASET x19, LDerror_key, x20, 1
    mov x0, x20
    ldp x21, x22, [sp, #32]
    ldp x19, x20, [sp, #16]
    ldp x29, x30, [sp], #48
    ret

// (logger) -> retained-by-logger Application Support recent.plist URL.
// No I/O on UI threads. Unlike Caches, this directory is persistent storage.
LDpath:
    stp x29, x30, [sp, #-48]!
    mov x29, sp
    stp x19, x20, [sp, #16]
    stp x21, x22, [sp, #32]
    mov x19, x0
    AGET x19, LDurl_key
    cbnz x0, LDpath_done
    adr x0, LDfilemanager_class
    bl Lpatch + (0xa5b0 - PATCH_BASE)
    GET x0, LDdefault_manager
    mov x2, #14 // NSApplicationSupportDirectory
    mov x3, #1  // NSUserDomainMask
    GET x0, LDcache_urls
    GET x0, LDfirst_object
    mov x20, x0
    cbz x20, LDpath_fail
    adr x0, LDcache_name
    bl Lstr
    mov x2, x0
    GET x20, LDappend_component
    mov x20, x0
    adr x0, LDstore_name
    bl Lstr
    mov x2, x0
    GET x20, LDappend_component
    mov x20, x0
    ASET x19, LDurl_key, x20, 1
    mov x0, x20
    b LDpath_done
LDpath_fail:
    mov x0, x19
    mov x1, #0
    adr x2, LDcache_error
    bl LDerror
    mov x0, #0
LDpath_done:
    ldp x21, x22, [sp, #32]
    ldp x19, x20, [sp, #16]
    ldp x29, x30, [sp], #48
    ret

// Load once, without pruning against worker.now: a queued export marker may
// have an earlier fixed request time. The first command supplies the cutoff.
LDload:
    stp x29, x30, [sp, #-80]!
    mov x29, sp
    stp x19, x20, [sp, #16]
    stp x21, x22, [sp, #32]
    stp x23, x24, [sp, #48]
    mov x19, x0
    AGET x19, LDentries_key
    cbnz x0, LDload_done
    LDNEW LDmutable_array
    mov x20, x0
    ASET x19, LDentries_key, x20, 1
    mov x0, x19
    bl LDpath
    mov x21, x0
    cbz x21, LDload_return
    adr x0, LDfilemanager_class
    bl Lpatch + (0xa5b0 - PATCH_BASE)
    GET x0, LDdefault_manager
    mov x22, x0
    GET x21, LDpath_sel
    mov x2, x0
    GET x22, LDexists
    cbz w0, LDload_return
    str xzr, [sp, #64]
    adr x0, LDdata_class
    bl Lpatch + (0xa5b0 - PATCH_BASE)
    mov x2, x21
    mov x3, #0
    add x4, sp, #64
    GET x0, LDread_data
    cbz x0, LDload_io_error
    mov x21, x0
    adr x0, LDplist_class
    bl Lpatch + (0xa5b0 - PATCH_BASE)
    mov x2, x21
    mov x3, #0
    mov x4, #0
    add x5, sp, #64
    GET x0, LDread_plist
    cbz x0, LDload_io_error
    mov x21, x0
    adr x1, LDarray_class
    bl Lpatch + (0x7394 - PATCH_BASE)
    cbz w0, LDload_invalid
    GET x21, LDcount
    cmp x0, #1
    b.ne LDload_invalid
    GET x21, LDfirst_object
    mov x21, x0
    adr x1, LDdata_class
    bl Lpatch + (0x7394 - PATCH_BASE)
    cbz w0, LDload_invalid
    adr x0, LDjson_class
    bl Lpatch + (0xa5b0 - PATCH_BASE)
    mov x2, x21
    mov x3, #0
    add x4, sp, #64
    GET x0, LDread_json
    cbz x0, LDload_io_error
    mov x21, x0
    adr x1, LDarray_class
    bl Lpatch + (0x7394 - PATCH_BASE)
    cbz w0, LDload_invalid
    mov x2, x21
    GET x20, LDadd_array
    b LDload_return
LDload_io_error:
    mov x0, x19
    ldr x1, [sp, #64]
    adr x2, LDread_error
    bl LDerror
    b LDload_return
LDload_invalid:
    mov x0, x19
    mov x1, #0
    adr x2, LDformat_error
    bl LDerror
LDload_return:
    mov x0, x20
LDload_done:
    ldp x23, x24, [sp, #48]
    ldp x21, x22, [sp, #32]
    ldp x19, x20, [sp, #16]
    ldp x29, x30, [sp], #80
    ret

// (logger, d0=command timestamp). Inclusive one-hour lower bound. Do not
// discard future timestamps after a clock rollback; expose clockSkew instead.
LDprune:
    stp x29, x30, [sp, #-80]!
    mov x29, sp
    stp x19, x20, [sp, #16]
    stp x21, x22, [sp, #32]
    stp x23, x24, [sp, #48]
    stp d8, d9, [sp, #64]
    mov x19, x0
    fmov d9, d0
    mov w8, #3600
    scvtf d1, w8
    fsub d8, d0, d1
    AGET x19, LDentries_key
    mov x20, x0
    GET x20, LDcount
    mov x21, x0
LDprune_loop:
    cbz x21, LDprune_done
    sub x21, x21, #1
    mov x2, x21
    GET x20, LDobject_index
    mov x22, x0
    adr x1, LDdict_class
    bl Lpatch + (0x7394 - PATCH_BASE)
    cbz w0, LDprune_invalid
    LDGET x22, LDtimestamp_field
    mov x23, x0
    adr x1, LDnumber_class
    bl Lpatch + (0x7394 - PATCH_BASE)
    cbz w0, LDprune_invalid
    GET x23, LDdouble_value
    LDFINITE d0, LDprune_invalid
    fcmp d0, d8
    b.lt LDprune_remove
    fcmp d0, d9
    b.le LDprune_loop
    ASET x19, LDclock_key, x19, 0
    b LDprune_loop
LDprune_invalid:
    mov x0, x19
    mov x1, #0
    adr x2, LDrecord_error
    bl LDerror
LDprune_remove:
    mov x2, x21
    GET x20, LDremove_index
    b LDprune_loop
LDprune_done:
    ldp d8, d9, [sp, #64]
    ldp x23, x24, [sp, #48]
    ldp x21, x22, [sp, #32]
    ldp x19, x20, [sp, #16]
    ldp x29, x30, [sp], #80
    ret

// (JSON object, logger) -> NSData or nil. Validate before the serializer;
// NSError alone does not catch invalid-object Objective-C exceptions.
LDjson:
    stp x29, x30, [sp, #-64]!
    mov x29, sp
    stp x19, x20, [sp, #16]
    stp x21, x22, [sp, #32]
    mov x19, x0
    mov x20, x1
    adr x0, LDjson_class
    bl Lpatch + (0xa5b0 - PATCH_BASE)
    mov x21, x0
    mov x2, x19
    GET x21, LDjson_valid
    cbz w0, LDjson_invalid
    str xzr, [sp, #48]
    mov x2, x19
    mov x3, #0
    add x4, sp, #48
    GET x21, LDwrite_json
    cbnz x0, LDjson_done
    mov x0, x20
    ldr x1, [sp, #48]
    adr x2, LDserialize_error
    bl LDerror
    b LDjson_none
LDjson_invalid:
    mov x0, x20
    mov x1, #0
    adr x2, LDjson_error
    bl LDerror
LDjson_none:
    mov x0, #0
LDjson_done:
    ldp x21, x22, [sp, #32]
    ldp x19, x20, [sp, #16]
    ldp x29, x30, [sp], #64
    ret

// (NSData, NSURL, logger) -> BOOL. Only a plugin-owned directory is created.
// No in-memory record is removed or marked durable when either I/O fails.
LDwrite:
    stp x29, x30, [sp, #-80]!
    mov x29, sp
    stp x19, x20, [sp, #16]
    stp x21, x22, [sp, #32]
    stp x23, x24, [sp, #48]
    mov x19, x0
    mov x20, x1
    mov x21, x2
    cbz x19, LDwrite_none
    cbz x20, LDwrite_path_error
    GET x20, LDdelete_component
    mov x22, x0
    adr x0, LDfilemanager_class
    bl Lpatch + (0xa5b0 - PATCH_BASE)
    GET x0, LDdefault_manager
    str xzr, [sp, #64]
    mov x2, x22
    mov w3, #1
    mov x4, #0
    add x5, sp, #64
    GET x0, LDcreate_directory
    cbz w0, LDwrite_directory_error
    mov x2, x20
    mov x3, #1 // NSDataWritingAtomic
    add x4, sp, #64
    GET x19, LDwrite_data
    cbnz w0, LDwrite_done
    adr x2, LDwrite_error
    b LDwrite_error_common
LDwrite_directory_error:
    adr x2, LDdirectory_error
LDwrite_error_common:
    mov x0, x21
    ldr x1, [sp, #64]
    bl LDerror
    b LDwrite_none
LDwrite_path_error:
    mov x0, x21
    mov x1, #0
    adr x2, LDexport_path_error
    bl LDerror
LDwrite_none:
    mov w0, #0
LDwrite_done:
    ldp x23, x24, [sp, #48]
    ldp x21, x22, [sp, #32]
    ldp x19, x20, [sp, #16]
    ldp x29, x30, [sp], #80
    ret

// Serial-worker only. Atomic persistent envelope, no record-count cap.
LDpersist:
    stp x29, x30, [sp, #-64]!
    mov x29, sp
    stp x19, x20, [sp, #16]
    stp x21, x22, [sp, #32]
    mov x19, x0
    AGET x19, LDentries_key
    mov x1, x19
    bl LDjson
    cbz x0, LDpersist_none
    mov x20, x0
    adr x0, LDarray_class
    bl Lpatch + (0xa5b0 - PATCH_BASE)
    mov x2, x20
    GET x0, LDarray_object
    mov x20, x0
    adr x0, LDplist_class
    bl Lpatch + (0xa5b0 - PATCH_BASE)
    str xzr, [sp, #48]
    mov x2, x20
    mov x3, #200 // NSPropertyListBinaryFormat_v1_0
    mov x4, #0
    add x5, sp, #48
    GET x0, LDwrite_plist
    cbz x0, LDpersist_serialize_error
    mov x20, x0
    mov x0, x19
    bl LDpath
    mov x1, x0
    mov x0, x20
    mov x2, x19
    bl LDwrite
    b LDpersist_done
LDpersist_serialize_error:
    mov x0, x19
    ldr x1, [sp, #48]
    adr x2, LDserialize_error
    bl LDerror
LDpersist_none:
    mov w0, #0
LDpersist_done:
    ldp x21, x22, [sp, #32]
    ldp x19, x20, [sp, #16]
    ldp x29, x30, [sp], #64
    ret

LDdrain:
    stp x29, x30, [sp, #-112]!
    mov x29, sp
    stp x19, x20, [sp, #16]
    stp x21, x22, [sp, #32]
    stp x23, x24, [sp, #48]
    stp x25, x26, [sp, #64]
    stp x27, x28, [sp, #80]
    mov x19, x0
    bl Lpatch + (0xa5bc - PATCH_BASE)
    str x0, [sp, #96]
    mov x0, x19
    bl LDload
LDdrain_batch:
    AGET x19, LDlock_key
    mov x21, x0
    GET x21, LDlock
    AGET x19, LDpending_key
    mov x22, x0
    GET x22, LDcount
    cbz x0, LDdrain_empty
    GET x22, LDcopy
    mov x23, x0
    GET x22, LDremove_all
    GET x21, LDunlock
    GET x23, LDcount
    mov x25, x0
    mov x24, #0
    mov w28, #0
LDdrain_command:
    cmp x24, x25
    b.hs LDdrain_flush
    mov x2, x24
    GET x23, LDobject_index
    mov x1, x0
    mov x0, x19
    bl LDprocess
    mov w28, w0 // export already flushed; later append makes it dirty again
    add x24, x24, #1
    b LDdrain_command
LDdrain_flush:
    cbz w28, LDdrain_release
    mov x0, x19
    bl LDpersist
LDdrain_release:
    GET x23, LDrelease
    ldr x0, [sp, #96]
    bl Lpatch + (0xa574 - PATCH_BASE)
    bl Lpatch + (0xa5bc - PATCH_BASE)
    str x0, [sp, #96]
    b LDdrain_batch
LDdrain_empty:
    GET x21, LDunlock
    ldr x0, [sp, #96]
    bl Lpatch + (0xa574 - PATCH_BASE)
    ldp x27, x28, [sp, #80]
    ldp x25, x26, [sp, #64]
    ldp x23, x24, [sp, #48]
    ldp x21, x22, [sp, #32]
    ldp x19, x20, [sp, #16]
    ldp x29, x30, [sp], #112
    ret

// (logger, command) -> 1 if a final batch flush is required, 0 after export.
// All cutoffs are command timestamps, NEVER delayed worker wall-clock time.
LDprocess:
    stp x29, x30, [sp, #-48]!
    mov x29, sp
    stp x19, x20, [sp, #16]
    stp x21, x22, [sp, #32]
    mov x19, x0
    mov x20, x1
    LDGET x20, LDtimestamp_field
    GET x0, LDdouble_value
    mov x0, x19
    bl LDprune
    LDGET x20, LDexport_target
    cbnz x0, LDprocess_export
    LDGET x20, LDmaintenance_field
    cbnz x0, LDprocess_dirty
    AGET x19, LDentries_key
    mov x2, x20
    GET x0, LDadd_object
LDprocess_dirty:
    mov w0, #1
    b LDprocess_done
LDprocess_export:
    mov x0, x19
    bl LDpersist
    mov x0, x19
    mov x1, x20
    bl LDexport
    mov w0, #0
LDprocess_done:
    ldp x21, x22, [sp, #32]
    ldp x19, x20, [sp, #16]
    ldp x29, x30, [sp], #48
    ret

// Fixed [requestTime-3600, requestTime] snapshot, delivered on main thread.
// The exportTarget and the marker itself are never included in stored entries.
LDexport:
    stp x29, x30, [sp, #-128]!
    mov x29, sp
    stp x19, x20, [sp, #16]
    stp x21, x22, [sp, #32]
    stp x23, x24, [sp, #48]
    stp x25, x26, [sp, #64]
    stp x27, x28, [sp, #80]
    stp d8, d9, [sp, #96]
    mov x19, x0
    mov x20, x1
    LDGET x20, LDtimestamp_field
    GET x0, LDdouble_value
    fmov d8, d0
    mov w8, #3600
    scvtf d1, w8
    fsub d9, d0, d1
    LDNEW LDmutable_array
    mov x22, x0
    AGET x19, LDentries_key
    mov x21, x0
    GET x21, LDcount
    mov x23, x0
    mov x24, #0
LDexport_filter:
    cmp x24, x23
    b.hs LDexport_payload
    mov x2, x24
    GET x21, LDobject_index
    mov x25, x0
    LDGET x25, LDtimestamp_field
    GET x0, LDdouble_value
    fcmp d0, d9
    b.lt LDexport_next
    fcmp d0, d8
    b.gt LDexport_next
    mov x2, x25
    GET x22, LDadd_object
LDexport_next:
    add x24, x24, #1
    b LDexport_filter
LDexport_payload:
    LDNEW LDmutable_dict
    mov x26, x0
    LDSET x26, LDentries_field, x22
    GET x22, LDcount
    ucvtf d0, x0
    bl Lnumber
    mov x23, x0
    LDSET x26, LDcount_field, x23
    fmov d0, d9
    bl Lnumber
    LDSET x26, LDwindow_start, x0
    fmov d0, d8
    bl Lnumber
    LDSET x26, LDwindow_end, x0
    adr x0, LDversion
    bl Lstr
    LDSET x26, LDversion_field, x0
    AGET x19, LDstart_key
    LDSET x26, LDsession_start, x0
    LDGET x20, LDsequence_field
    LDSET x26, LDrequest_sequence, x0
    AGET x19, LDclock_key
    cmp x0, #0
    cset w8, ne
    ucvtf d0, w8
    bl Lnumber
    LDSET x26, LDclock_field, x0
    AGET x19, LDerror_key
    cbnz x0, LDexport_status
    adr x0, LDno_error
    bl Lstr
LDexport_status:
    LDSET x26, LDstorage_error, x0
    LDNEW LDmutable_dict
    mov x27, x0
    mov x0, x26
    mov x1, x19
    bl LDjson
    cbz x0, LDexport_failure
    mov x25, x0
    adr x0, LDfilemanager_class
    bl Lpatch + (0xa5b0 - PATCH_BASE)
    GET x0, LDdefault_manager
    GET x0, LDtemporary_dir
    mov x21, x0
    adr x0, LDexport_dir_name
    bl Lstr
    mov x2, x0
    GET x21, LDappend_component
    mov x21, x0
    adr x0, LDuuid_class
    bl Lpatch + (0xa5b0 - PATCH_BASE)
    GET x0, LDuuid
    GET x0, LDuuid_string
    mov x22, x0
    adr x0, LDjson_extension
    bl Lstr
    mov x2, x0
    GET x22, LDappend_string
    mov x2, x0
    GET x21, LDappend_component
    mov x28, x0
    mov x0, x25
    mov x1, x28
    mov x2, x19
    bl LDwrite
    cbz w0, LDexport_failure
    LDSET x27, LDurl_field, x28
    LDSET x27, LDcount_field, x23
    b LDexport_result
LDexport_failure:
    AGET x19, LDerror_key
    cbnz x0, LDexport_failure_text
    adr x0, LDwrite_error
    bl Lstr
LDexport_failure_text:
    LDSET x27, LDerror_field, x0
LDexport_result:
    AGET x19, LDerror_key
    cbnz x0, LDexport_result_status
    adr x0, LDno_error
    bl Lstr
LDexport_result_status:
    LDSET x27, LDstorage_error, x0
    LDGET x20, LDexport_target
    mov x21, x0
    adr x0, LDpresent_sel
    bl Lpatch + (0xa5a4 - PATCH_BASE)
    mov x22, x0
    mov x2, x22
    GET x21, LDresponds
    cbz w0, LDexport_done
    mov x2, x22
    mov x3, x27
    mov w4, #0
    GET x21, LDperform_main
LDexport_done:
    ldp d8, d9, [sp, #96]
    ldp x27, x28, [sp, #80]
    ldp x25, x26, [sp, #64]
    ldp x23, x24, [sp, #48]
    ldp x21, x22, [sp, #32]
    ldp x19, x20, [sp, #16]
    ldp x29, x30, [sp], #128
    ret

// @COMPONENT_DATA
LDclass_name: .asciz "FQABDiagnosticsV155"
LDobject_class: .asciz "NSObject"
LDlock_class: .asciz "NSLock"
LDqueue_class: .asciz "NSOperationQueue"
LDoperation_class: .asciz "NSInvocationOperation"
LDtimer_class: .asciz "NSTimer"
LDmutable_array: .asciz "NSMutableArray"
LDmutable_dict: .asciz "NSMutableDictionary"
LDdict_class: .asciz "NSDictionary"
LDarray_class: .asciz "NSArray"
LDnumber_class: .asciz "NSNumber"
LDdate_class: .asciz "NSDate"
LDfilemanager_class: .asciz "NSFileManager"
LDdata_class: .asciz "NSData"
LDplist_class: .asciz "NSPropertyListSerialization"
LDjson_class: .asciz "NSJSONSerialization"
LDuuid_class: .asciz "NSUUID"
LDvoid_encoding: .asciz "v16@0:8"
LDobject_encoding: .asciz "v24@0:8@16"
LDreturn_encoding: .asciz "@16@0:8"
LDinitialize_sel: .asciz "initialize"
LDshared_sel: .asciz "fqab_156_sharedLogger"
LDdrain_sel: .asciz "fqab_156_drain:"
LDtick_sel: .asciz "fqab_156_tick:"
LDtimer_sel: .asciz "fqab_156_startTimer:"
LDpresent_sel: .asciz "fqab_156_presentDiagnostics:"
LDalloc: .asciz "alloc"
LDinit: .asciz "init"
LDrelease: .asciz "release"
LDautorelease: .asciz "autorelease"
LDcopy: .asciz "copy"
LDmutable_copy: .asciz "mutableCopy"
LDresponds: .asciz "respondsToSelector:"
LDlock: .asciz "lock"
LDunlock: .asciz "unlock"
LDmax_concurrent: .asciz "setMaxConcurrentOperationCount:"
LDscheduled_timer: .asciz "scheduledTimerWithTimeInterval:target:selector:userInfo:repeats:"
LDperform_main: .asciz "performSelectorOnMainThread:withObject:waitUntilDone:"
LDoperation_init: .asciz "initWithTarget:selector:object:"
LDadd_operation: .asciz "addOperation:"
LDunsigned_value: .asciz "unsignedLongLongValue"
LDunsigned_number: .asciz "numberWithUnsignedLongLong:"
LDdouble_value: .asciz "doubleValue"
LDadd_object: .asciz "addObject:"
LDadd_array: .asciz "addObjectsFromArray:"
LDremove_all: .asciz "removeAllObjects"
LDremove_index: .asciz "removeObjectAtIndex:"
LDobject_key: .asciz "objectForKey:"
LDobject_index: .asciz "objectAtIndex:"
LDarray_object: .asciz "arrayWithObject:"
LDfirst_object: .asciz "firstObject"
LDcount: .asciz "count"
LDdate: .asciz "date"
LDunix_time: .asciz "timeIntervalSince1970"
LDdefault_manager: .asciz "defaultManager"
LDcache_urls: .asciz "URLsForDirectory:inDomains:"
LDappend_component: .asciz "URLByAppendingPathComponent:"
LDdelete_component: .asciz "URLByDeletingLastPathComponent"
LDpath_sel: .asciz "path"
LDexists: .asciz "fileExistsAtPath:"
LDread_data: .asciz "dataWithContentsOfURL:options:error:"
LDread_plist: .asciz "propertyListWithData:options:format:error:"
LDwrite_plist: .asciz "dataWithPropertyList:format:options:error:"
LDread_json: .asciz "JSONObjectWithData:options:error:"
LDwrite_json: .asciz "dataWithJSONObject:options:error:"
LDjson_valid: .asciz "isValidJSONObject:"
LDwrite_data: .asciz "writeToURL:options:error:"
LDcreate_directory: .asciz "createDirectoryAtURL:withIntermediateDirectories:attributes:error:"
LDlocalized_error: .asciz "localizedDescription"
LDtemporary_dir: .asciz "temporaryDirectory"
LDuuid: .asciz "UUID"
LDuuid_string: .asciz "UUIDString"
LDappend_string: .asciz "stringByAppendingString:"
LDtimestamp_field: .asciz "timestamp"
LDsequence_field: .asciz "sequence"
LDmaintenance_field: .asciz "maintenance"
LDexport_target: .asciz "exportTarget"
LDentries_field: .asciz "entries"
LDcount_field: .asciz "recordCount"
LDwindow_start: .asciz "windowStart"
LDwindow_end: .asciz "windowEnd"
LDversion_field: .asciz "pluginVersion"
LDstorage_error: .asciz "storageError"
LDsession_start: .asciz "sessionStart"
LDrequest_sequence: .asciz "requestSequence"
LDclock_field: .asciz "clockSkew"
LDurl_field: .asciz "url"
LDerror_field: .asciz "error"
LDtrue_string: .asciz "1"
.set LDversion, LSversion
LDno_error: .asciz "none"
LDcache_name: .asciz "FanqieAdBlockDiagnostics"
LDstore_name: .asciz "recent.plist"
LDexport_dir_name: .asciz "FanqieXDiagnosticsExports"
LDjson_extension: .asciz ".json"
LDcache_error: .asciz "Cannot locate persistent diagnostics application support directory."
LDread_error: .asciz "Cannot read saved diagnostics."
LDformat_error: .asciz "Invalid diagnostic store; saved history was not loaded."
LDrecord_error: .asciz "Removed an invalid undated saved diagnostic record."
LDjson_error: .asciz "Invalid JSON diagnostic data; records remain in memory."
LDserialize_error: .asciz "Could not serialize diagnostics; records remain in memory."
LDdirectory_error: .asciz "Could not create diagnostics directory."
LDwrite_error: .asciz "Could not write diagnostics; records remain in memory."
LDexport_path_error: .asciz "Could not construct diagnostics file path."
LDsingleton_key: .byte 0
LDlock_key: .byte 0
LDpending_key: .byte 0
LDqueue_key: .byte 0
LDentries_key: .byte 0
LDurl_key: .byte 0
LDerror_key: .byte 0
LDstart_key: .byte 0
LDsequence_key: .byte 0
LDtimer_key: .byte 0
LDclock_key: .byte 0
    .p2align 2
