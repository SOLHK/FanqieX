// Foundation validation is called directly from the original constructor at
// 0x4018, so its return address retains the original valid unwind frame.
// This continuation leaves the original constructor frame intact.
LHomeHostGate:
    cbnz w0, LHomeHostAccepted
    .if FQ_VERSION >= 0x10704
    b Lpatch + (0x40a0 - PATCH_BASE)
    .else
    mov w0, #0
    bl Lpatch + (0xa5c8 - PATCH_BASE)
    b Lpatch + (0x4020 - PATCH_BASE)
    .endif
LHomeHostAccepted:
    b Lpatch + (0x40b8 - PATCH_BASE)
// @COMPONENT_DATA
    .p2align 2
LHomeEntries:
    .ascii "FQ165HOM"
    .long LHomeHostGate - Lpatch
    .if FQ_VERSION >= 0x10704
    .long LFQH_FQHHostBundle - Lpatch
    .else
    .long LFQH_FQHCompatibleHost - Lpatch
    .endif
