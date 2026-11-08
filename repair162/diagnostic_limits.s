// 1.6.4 limits for the existing serial logger. Pending graphs come from the
// bounded native capture or bounded legacy UIKit snapshots. Serialization and
// all file operations stay on the worker. Count limits also apply after load.
LDLimitsID:
    stp x29, x30, [sp, #-16]!
    mov x29, sp
    adr x0, LDuuid_class
    bl Lpatch + (0xa5b0 - PATCH_BASE)
    GET x0, LDuuid
    GET x0, LDuuid_string
    ldp x29, x30, [sp], #16
    ret

LDLimitsSession:
    stp x29, x30, [sp, #-32]!
    mov x29, sp
    stp x19, x20, [sp, #16]
    mov x19, x0
    bl LDLimitsID
    ASET x19, LDLimitsSessionKey, x0, 1
    ldp x19, x20, [sp, #16]
    ldp x29, x30, [sp], #32
    ret

// Called while the producer lock is held. Every event gets a stable session
// and correlation envelope, including legacy snapshots and direct producers.
LDLimitsPrepare:
    stp x29, x30, [sp, #-64]!
    mov x29, sp
    stp x19, x20, [sp, #16]
    stp x21, x22, [sp, #32]
    stp x23, x24, [sp, #48]
    mov x19, x0
    mov x20, x1
    AGET x19, LDpending_key
    GET x0, LDcount
    cmp x0, #2048
    b.hs LDLimitsPrepareFull
    LDGET x20, LSk_event
    cbz x0, LDLimitsPrepareYes
    AGET x19, LDLimitsSessionKey
    LDSET x20, LDLimitsSessionField, x0
    LDGET x20, LSk_data
    cbz x0, LDLimitsPrepareUUID
    adr x1, LDLimitsCorrelationField
    bl LDdict_get
    mov x21, x0
    adr x1, LSstring_class
    bl Lpatch + (0x7394 - PATCH_BASE)
    cbnz w0, LDLimitsPrepareCorrelation
LDLimitsPrepareUUID:
    bl LDLimitsID
    mov x21, x0
LDLimitsPrepareCorrelation:
    LDSET x20, LDLimitsCorrelationField, x21
LDLimitsPrepareYes:
    mov w0, #1
    b LDLimitsPrepareDone
LDLimitsPrepareFull:
    LDGET x20, LSk_event
    cbz x0, LDLimitsPrepareRejectExport
    mov x0, x19
    mov x1, #1
    bl LDLimitsDropLocked
LDLimitsPrepareRejectExport:
    LDGET x20, LDexport_target
    mov x21, x0
    cbz x21, LDLimitsPrepareNo
    LDNEW LDmutable_dict
    mov x22, x0
    adr x0, LDLimitsQueueError
    bl Lstr
    LDSET x22, LDerror_field, x0
    adr x0, LDLimitsQueueError
    bl Lstr
    LDSET x22, LDstorage_error, x0
    adr x0, LDpresent_sel
    bl Lpatch + (0xa5a4 - PATCH_BASE)
    mov x2, x0
    mov x3, x22
    mov w4, #0
    GET x21, LDperform_main
LDLimitsPrepareNo:
    mov w0, #0
LDLimitsPrepareDone:
    ldp x23, x24, [sp, #48]
    ldp x21, x22, [sp, #32]
    ldp x19, x20, [sp, #16]
    ldp x29, x30, [sp], #64
    ret

// Caller holds producer lock. The counter is independent of retained events.
LDLimitsDropLocked:
    stp x29, x30, [sp, #-48]!
    mov x29, sp
    stp x19, x20, [sp, #16]
    stp x21, x22, [sp, #32]
    mov x19, x0
    mov x20, x1
    AGET x19, LDLimitsDroppedKey
    GET x0, LDunsigned_value
    add x0, x0, x20
    bl Luint
    ASET x19, LDLimitsDroppedKey, x0, 1
    ASET x19, LDLimitsLossKey, x19, 0
    ldp x21, x22, [sp, #32]
    ldp x19, x20, [sp, #16]
    ldp x29, x30, [sp], #48
    ret

LDLimitsEvict:
    stp x29, x30, [sp, #-64]!
    mov x29, sp
    stp x19, x20, [sp, #16]
    stp x21, x22, [sp, #32]
    stp x23, x24, [sp, #48]
    mov x19, x0
    mov x20, x1
    AGET x19, LDentries_key
    mov x21, x0
    mov x22, x20
LDLimitsEvictLoop:
    cbz x22, LDLimitsEvictCount
    mov x2, #0
    GET x21, LDremove_index
    sub x22, x22, #1
    b LDLimitsEvictLoop
LDLimitsEvictCount:
    AGET x19, LDlock_key
    mov x21, x0
    GET x21, LDlock
    mov x0, x19
    mov x1, x20
    bl LDLimitsDropLocked
    GET x21, LDunlock
    ldp x23, x24, [sp, #48]
    ldp x21, x22, [sp, #32]
    ldp x19, x20, [sp, #16]
    ldp x29, x30, [sp], #64
    ret

LDLimitsRetained:
    stp x29, x30, [sp, #-32]!
    mov x29, sp
    stp x19, x20, [sp, #16]
    mov x19, x0
    AGET x19, LDentries_key
    GET x0, LDcount
    mov x1, #8192
    subs x1, x0, x1
    b.ls LDLimitsRetainedDone
    mov x0, x19
    bl LDLimitsEvict
LDLimitsRetainedDone:
    ldp x19, x20, [sp, #16]
    ldp x29, x30, [sp], #32
    ret

LDLimitsScheduleFailure:
    stp x29, x30, [sp, #-48]!
    mov x29, sp
    stp x19, x20, [sp, #16]
    stp x21, x22, [sp, #32]
    mov x19, x0
    AGET x19, LDlock_key
    mov x20, x0
    GET x20, LDlock
    ASET x19, LDLimitsScheduledKey, xzr, 0
    mov x0, x19
    mov x1, #0
    adr x2, LDLimitsScheduleError
    bl LDerror
    GET x20, LDunlock
    ldp x21, x22, [sp, #32]
    ldp x19, x20, [sp, #16]
    ldp x29, x30, [sp], #48
    ret

// A full queue must also recover from an earlier operation allocation failure.
LDLimitsRetry:
    stp x29, x30, [sp, #-48]!
    mov x29, sp
    stp x19, x20, [sp, #16]
    stp x21, x22, [sp, #32]
    mov x19, x0
    AGET x19, LDlock_key
    mov x20, x0
    GET x20, LDlock
    mov w21, #0
    AGET x19, LDLimitsScheduledKey
    cbnz x0, LDLimitsRetryUnlock
    AGET x19, LDpending_key
    GET x0, LDcount
    cbz x0, LDLimitsRetryUnlock
    ASET x19, LDLimitsScheduledKey, x19, 0
    mov w21, #1
LDLimitsRetryUnlock:
    GET x20, LDunlock
    cbz w21, LDLimitsRetryDone
    mov x0, x19
    bl LDschedule
LDLimitsRetryDone:
    ldp x21, x22, [sp, #32]
    ldp x19, x20, [sp, #16]
    ldp x29, x30, [sp], #48
    ret

LDLimitsExportMetadata:
    stp x29, x30, [sp, #-64]!
    mov x29, sp
    stp x19, x20, [sp, #16]
    stp x21, x22, [sp, #32]
    stp x23, x24, [sp, #48]
    mov x19, x0
    mov x20, x1
    AGET x19, LDlock_key
    mov x21, x0
    GET x21, LDlock
    AGET x19, LDLimitsSessionKey
    LDSET x20, LDLimitsSessionField, x0
    AGET x19, LDLimitsDroppedKey
    GET x0, LDunsigned_value
    bl Luint
    LDSET x20, LDLimitsDroppedField, x0
    AGET x19, LDLimitsLossKey
    cmp x0, #0
    cset w0, ne
    bl Luint
    LDSET x20, LDLimitsTruncatedField, x0
    GET x21, LDunlock
    ldp x23, x24, [sp, #48]
    ldp x21, x22, [sp, #32]
    ldp x19, x20, [sp, #16]
    ldp x29, x30, [sp], #64
    ret

// Worker only. Reject oversized stores before NSData/plist/JSON allocation.
LDLimitsLoadAllowed:
    stp x29, x30, [sp, #-64]!
    mov x29, sp
    stp x19, x20, [sp, #16]
    stp x21, x22, [sp, #32]
    mov x19, x0
    mov x20, x1
    adr x0, LDfilemanager_class
    bl Lpatch + (0xa5b0 - PATCH_BASE)
    GET x0, LDdefault_manager
    mov x21, x0
    GET x20, LDpath_sel
    mov x2, x0
    str xzr, [sp, #48]
    add x3, sp, #48
    GET x21, LDLimitsAttributes
    cbz x0, LDLimitsLoadStatError
    adr x1, LDLimitsFileSize
    bl LDdict_get
    GET x0, LDunsigned_value
    mov x8, #0x800000
    add x8, x8, #1024
    cmp x0, x8
    b.hi LDLimitsLoadTooLarge
    mov w0, #1
    b LDLimitsLoadDone
LDLimitsLoadStatError:
    mov x0, x19
    ldr x1, [sp, #48]
    adr x2, LDread_error
    bl LDerror
    b LDLimitsLoadNo
LDLimitsLoadTooLarge:
    ASET x19, LDLimitsLossKey, x19, 0
    mov x0, x19
    mov x1, #0
    adr x2, LDLimitsReadError
    bl LDerror
LDLimitsLoadNo:
    mov w0, #0
LDLimitsLoadDone:
    ldp x21, x22, [sp, #32]
    ldp x19, x20, [sp, #16]
    ldp x29, x30, [sp], #64
    ret

LDLimitsReadBytes:
    mov x2, #0x800000
    add x2, x2, #1024
    b LDLimitsBytes
LDLimitsJSONBytes:
    mov x2, #0x800000
LDLimitsBytes:
    stp x29, x30, [sp, #-48]!
    mov x29, sp
    stp x19, x20, [sp, #16]
    stp x21, x22, [sp, #32]
    mov x19, x0
    mov x20, x2
    mov x0, x1
    GET x0, LDLimitsLength
    cmp x0, x20
    b.hi LDLimitsBytesError
    mov w0, #1
    b LDLimitsBytesDone
LDLimitsBytesError:
    ASET x19, LDLimitsLossKey, x19, 0
    mov x0, x19
    mov x1, #0
    adr x2, LDLimitsReadError
    bl LDerror
    mov w0, #0
LDLimitsBytesDone:
    ldp x21, x22, [sp, #32]
    ldp x19, x20, [sp, #16]
    ldp x29, x30, [sp], #48
    ret

// Keep the newest suffix that fits the byte cap. A nested pool bounds
// temporary serialization data across retries. The retained array is owned
// by the singleton, independent of that temporary pool.
LDLimitsPersist:
    stp x29, x30, [sp, #-80]!
    mov x29, sp
    stp x19, x20, [sp, #16]
    stp x21, x22, [sp, #32]
    stp x23, x24, [sp, #48]
    mov x19, x0
    AGET x19, LDLimitsLastCommandKey
    cbz x0, LDLimitsPersistRetry
    GET x0, LDdouble_value
    mov x0, x19
    bl LDprune
LDLimitsPersistRetry:
    bl Lpatch + (0xa5bc - PATCH_BASE)
    mov x24, x0
    AGET x19, LDentries_key
    mov x1, x19
    bl LDjson
    cbz x0, LDLimitsPersistNone
    mov x20, x0
    mov x0, x19
    mov x1, x20
    bl LDLimitsJSONBytes
    cbz w0, LDLimitsPersistTrim
    adr x0, LDarray_class
    bl Lpatch + (0xa5b0 - PATCH_BASE)
    mov x2, x20
    GET x0, LDarray_object
    mov x20, x0
    adr x0, LDplist_class
    bl Lpatch + (0xa5b0 - PATCH_BASE)
    str xzr, [sp, #64]
    mov x2, x20
    mov x3, #200
    mov x4, #0
    add x5, sp, #64
    GET x0, LDwrite_plist
    cbz x0, LDLimitsPersistPlistError
    mov x20, x0
    mov x0, x19
    bl LDpath
    mov x1, x0
    mov x0, x20
    mov x2, x19
    bl LDwrite
    mov w23, w0
    b LDLimitsPersistReturn
LDLimitsPersistTrim:
    AGET x19, LDentries_key
    GET x0, LDcount
    cbz x0, LDLimitsPersistNone
    lsr x1, x0, #1
    cmp x1, #0
    csinc x1, x1, xzr, ne
    mov x0, x19
    bl LDLimitsEvict
    mov x0, x24
    bl Lpatch + (0xa574 - PATCH_BASE)
    b LDLimitsPersistRetry
LDLimitsPersistPlistError:
    mov x0, x19
    ldr x1, [sp, #64]
    adr x2, LDserialize_error
    bl LDerror
LDLimitsPersistNone:
    mov w23, #0
LDLimitsPersistReturn:
    mov x0, x24
    bl Lpatch + (0xa574 - PATCH_BASE)
    mov w0, w23
    ldp x23, x24, [sp, #48]
    ldp x21, x22, [sp, #32]
    ldp x19, x20, [sp, #16]
    ldp x29, x30, [sp], #80
    ret

// Export files are immutable once handed to sharing. Remove only files older
// than the one-hour retention window. At most eight live JSON exports may
// coexist; a new request receives an explicit error if those slots are busy.
LDLimitsExports:
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
    adr x0, LDfilemanager_class
    bl Lpatch + (0xa5b0 - PATCH_BASE)
    GET x0, LDdefault_manager
    mov x21, x0
    GET x20, LDpath_sel
    mov x2, x0
    GET x21, LDexists
    cbz w0, LDLimitsExportsYes
    str xzr, [sp, #112]
    mov x2, x20
    mov x3, #0
    mov x4, #4
    add x5, sp, #112
    GET x21, LDLimitsList
    cbz x0, LDLimitsExportsIOError
    mov x22, x0
    GET x22, LDcount
    mov x23, x0
    mov x24, #0
    mov x25, #0
    bl LDnow
    mov w8, #3600
    scvtf d1, w8
    fsub d8, d0, d1
LDLimitsExportsLoop:
    cmp x24, x23
    b.hs LDLimitsExportsCount
    mov x2, x24
    GET x22, LDobject_index
    mov x26, x0
    add x24, x24, #1
    GET x26, LDLimitsLastComponent
    mov x27, x0
    adr x0, LDjson_extension
    bl Lstr
    mov x2, x0
    GET x27, LDLimitsHasSuffix
    cbz w0, LDLimitsExportsLoop
    GET x26, LDpath_sel
    mov x2, x0
    add x3, sp, #112
    GET x21, LDLimitsAttributes
    cbz x0, LDLimitsExportsIOError
    adr x1, LDLimitsModified
    bl LDdict_get
    cbz x0, LDLimitsExportsIOError
    GET x0, LDunix_time
    fcmp d0, d8
    b.ge LDLimitsExportsKeep
    mov x2, x26
    add x3, sp, #112
    GET x21, LDLimitsRemove
    cbz w0, LDLimitsExportsIOError
    b LDLimitsExportsLoop
LDLimitsExportsKeep:
    add x25, x25, #1
    b LDLimitsExportsLoop
LDLimitsExportsCount:
    cmp x25, #8
    b.lo LDLimitsExportsYes
    mov x0, x19
    mov x1, #0
    adr x2, LDLimitsExportError
    bl LDerror
    b LDLimitsExportsNo
LDLimitsExportsIOError:
    mov x0, x19
    ldr x1, [sp, #112]
    adr x2, LDLimitsExportCleanupError
    bl LDerror
LDLimitsExportsNo:
    mov w0, #0
    b LDLimitsExportsDone
LDLimitsExportsYes:
    mov w0, #1
LDLimitsExportsDone:
    ldp d8, d9, [sp, #96]
    ldp x27, x28, [sp, #80]
    ldp x25, x26, [sp, #64]
    ldp x23, x24, [sp, #48]
    ldp x21, x22, [sp, #32]
    ldp x19, x20, [sp, #16]
    ldp x29, x30, [sp], #128
    ret

// Append commands only update the batch cutoff. Exports and maintenance
// prune immediately. Persistence prunes once for the final batch timestamp.
LDLimitsCommandTime:
    stp x29, x30, [sp, #-48]!
    mov x29, sp
    stp x19, x20, [sp, #16]
    stp d8, d9, [sp, #32]
    mov x19, x0
    mov x20, x1
    fmov d8, d0
    bl Lnumber
    ASET x19, LDLimitsLastCommandKey, x0, 1
    LDGET x20, LDexport_target
    cbnz x0, LDLimitsCommandPrune
    LDGET x20, LDmaintenance_field
    cbz x0, LDLimitsCommandDone
LDLimitsCommandPrune:
    mov x0, x19
    fmov d0, d8
    bl LDprune
LDLimitsCommandDone:
    ldp d8, d9, [sp, #32]
    ldp x19, x20, [sp, #16]
    ldp x29, x30, [sp], #48
    ret

// @COMPONENT_DATA
.p2align 2
LDLimitsTable:
    .ascii "FQ164LIM"
    .long LDLimitsRetained - Lpatch + PATCH_BASE
    .long LDLimitsPersist - Lpatch + PATCH_BASE
    .long Lrecord_named - Lpatch + PATCH_BASE
    .long LDLimitsDroppedKey - Lpatch + PATCH_BASE
    .long LDentries_key - Lpatch + PATCH_BASE
    .long LDpending_key - Lpatch + PATCH_BASE
    .long LDLimitsSessionKey - Lpatch + PATCH_BASE
    .long LDLimitsScheduledKey - Lpatch + PATCH_BASE
LDLimitsSessionKey: .byte 0
LDLimitsScheduledKey: .byte 0
LDLimitsDroppedKey: .byte 0
LDLimitsLossKey: .byte 0
LDLimitsLastCommandKey: .byte 0
LDLimitsSessionField: .asciz "sessionId"
LDLimitsCorrelationField: .asciz "correlationId"
LDLimitsDroppedField: .asciz "droppedRecords"
LDLimitsTruncatedField: .asciz "truncated"
LDLimitsLength: .asciz "length"
LDLimitsAttributes: .asciz "attributesOfItemAtPath:error:"
LDLimitsFileSize: .asciz "NSFileSize"
LDLimitsModified: .asciz "NSFileModificationDate"
LDLimitsList: .asciz "contentsOfDirectoryAtURL:includingPropertiesForKeys:options:error:"
LDLimitsLastComponent: .asciz "lastPathComponent"
LDLimitsHasSuffix: .asciz "hasSuffix:"
LDLimitsRemove: .asciz "removeItemAtURL:error:"
LDLimitsQueueError: .asciz "Diagnostic pending queue reached its 2048-record limit. Retry the export."
LDLimitsReadError: .asciz "Diagnostic byte limit reached; history was truncated."
LDLimitsScheduleError: .asciz "Could not schedule diagnostics. Buffered records will retry on the next event."
LDLimitsExportError: .asciz "Eight diagnostic exports are still retained. Retry after their one-hour retention window."
LDLimitsExportCleanupError: .asciz "Could not clean expired diagnostic exports."
.p2align 2
