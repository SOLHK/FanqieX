// Foundation validation is called directly from the original constructor at
// 0x4018, so its return address retains the original valid unwind frame.
// This continuation only branches or calls the nonthrowing dyld header getter.
LHomeHostGate:
    cbnz w0, LHomeHostAccepted
    mov w0, #0
    bl Lpatch + (0xa5c8 - PATCH_BASE)
    b Lpatch + (0x4020 - PATCH_BASE)
LHomeHostAccepted:
    b Lpatch + (0x40b8 - PATCH_BASE)
// @COMPONENT_DATA
    .p2align 2
LHomeEntries:
    .ascii "FQ165HOM"
    .long LHomeHostGate - Lpatch
    .long LFQH_FQHCompatibleHost - Lpatch
