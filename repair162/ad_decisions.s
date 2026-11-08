// Per-rule trampolines preserve every argument and tail-call the pinned
// rule replacement after recording one safe decision.
LAdInstall164:
    adr x1, LAdRule0
    add x1, x1, x21, lsl #3
    b Lpatch + (0xa580 - PATCH_BASE)
LAdRule0:
    mov w16, #0
    b LAdDecision164
LAdRule1:
    mov w16, #1
    b LAdDecision164
LAdRule2:
    mov w16, #2
    b LAdDecision164
LAdRule3:
    mov w16, #3
    b LAdDecision164
LAdRule4:
    mov w16, #4
    b LAdDecision164
LAdRule5:
    mov w16, #5
    b LAdDecision164
LAdRule6:
    mov w16, #6
    b LAdDecision164
LAdRule7:
    mov w16, #7
    b LAdDecision164
LAdRule8:
    mov w16, #8
    b LAdDecision164
LAdRule9:
    mov w16, #9
    b LAdDecision164
LAdRule10:
    mov w16, #10
    b LAdDecision164
LAdRule11:
    mov w16, #11
    b LAdDecision164
LAdRule12:
    mov w16, #12
    b LAdDecision164
LAdRule13:
    mov w16, #13
    b LAdDecision164
LAdRule14:
    mov w16, #14
    b LAdDecision164
LAdRule15:
    mov w16, #15
    b LAdDecision164
LAdRule16:
    mov w16, #16
    b LAdDecision164
LAdRule17:
    mov w16, #17
    b LAdDecision164
LAdRule18:
    mov w16, #18
    b LAdDecision164
LAdRule19:
    mov w16, #19
    b LAdDecision164
LAdRule20:
    mov w16, #20
    b LAdDecision164
LAdRule21:
    mov w16, #21
    b LAdDecision164
LAdRule22:
    mov w16, #22
    b LAdDecision164
LAdRule23:
    mov w16, #23
    b LAdDecision164
LAdRule24:
    mov w16, #24
    b LAdDecision164
LAdRule25:
    mov w16, #25
    b LAdDecision164
LAdRule26:
    mov w16, #26
    b LAdDecision164
LAdRule27:
    mov w16, #27
    b LAdDecision164
LAdRule28:
    mov w16, #28
    b LAdDecision164
LAdRule29:
    mov w16, #29
    b LAdDecision164
LAdRule30:
    mov w16, #30
    b LAdDecision164
LAdRule31:
    mov w16, #31
    b LAdDecision164
LAdRule32:
    mov w16, #32
    b LAdDecision164
LAdRule33:
    mov w16, #33
    b LAdDecision164
LAdRule34:
    mov w16, #34
    b LAdDecision164
LAdRule35:
    mov w16, #35
    b LAdDecision164
LAdRule36:
    mov w16, #36
    b LAdDecision164
LAdRule37:
    mov w16, #37
    b LAdDecision164
LAdRule38:
    mov w16, #38
    b LAdDecision164
LAdRule39:
    mov w16, #39
    b LAdDecision164
LAdRule40:
    mov w16, #40
    b LAdDecision164
LAdRule41:
    mov w16, #41
    b LAdDecision164
LAdRule42:
    mov w16, #42
    b LAdDecision164
LAdRule43:
    mov w16, #43
    b LAdDecision164
LAdRule44:
    mov w16, #44
    b LAdDecision164
LAdDecision164:
    stp x29, x30, [sp, #-112]!
    mov x29, sp
    stp x0, x1, [sp, #16]
    stp x2, x3, [sp, #32]
    stp x4, x5, [sp, #48]
    stp x6, x7, [sp, #64]
    str x16, [sp, #80]
    adr x8, Lpatch + (0x10170 - PATCH_BASE)
    mov x9, #24
    madd x8, x16, x9, x8
    ldr x3, [x8, #8]
    ldr x4, [x8, #16]
    ldrb w5, [x8, #1]
    mov x2, x16
    bl LFQD_FQDAdDecision
    ldr x16, [sp, #80]
    adr x8, Lpatch + (0x10170 - PATCH_BASE)
    mov x9, #24
    madd x8, x16, x9, x8
    ldrb w8, [x8, #1]
    adr x9, Lpatch + (0x100b0 - PATCH_BASE)
    add x9, x9, x8, lsl #4
    ldr x16, [x9, #8]
    ldp x0, x1, [sp, #16]
    ldp x2, x3, [sp, #32]
    ldp x4, x5, [sp, #48]
    ldp x6, x7, [sp, #64]
    ldp x29, x30, [sp], #112
    br x16
// @COMPONENT_DATA
.p2align 2
LFQDdirectory:
    .ascii "FQ164DIA"
    .long LFQD_FQDInstall - Lpatch
    .long LFQD_FQDSettings - Lpatch
    .long LFQD_FQDAdDecision - Lpatch

