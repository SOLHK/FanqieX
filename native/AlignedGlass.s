// Source SHA-256: a42d924dbc496bcfd0ef3be67881bcfead3956ffed02bcfbb0e37b6b9cd3b45c
.p2align	2
LFQH_FQHCompatibleHost:
.cfi_startproc
stp	x22, x21, [sp, #-48]!
stp	x20, x19, [sp, #16]
stp	x29, x30, [sp, #32]
add	x29, sp, #32
.cfi_def_cfa w29, 16
.cfi_offset w30, -8
.cfi_offset w29, -16
.cfi_offset w19, -24
.cfi_offset w20, -32
.cfi_offset w21, -40
.cfi_offset w22, -48
bl Lpatch + (0xa5bc - PATCH_BASE)
mov	x19, x0
LFQH_Lloh0:
adr x0, LFQH_l_.str
LFQH_Lloh1:
nop
bl Lpatch + (0xa5b0 - PATCH_BASE)
mov	x20, x0
LFQH_Lloh2:
adr x0, LFQH_l_.str.1
LFQH_Lloh3:
nop
bl Lpatch + (0xa5a4 - PATCH_BASE)
mov	x1, x0
mov	x0, x20
bl Lpatch + (0xa5d4 - PATCH_BASE)
mov	x20, x0
LFQH_Lloh4:
adr x0, LFQH_l_.str.2
LFQH_Lloh5:
nop
bl Lpatch + (0xa5a4 - PATCH_BASE)
mov	x1, x0
mov	x0, x20
bl Lpatch + (0xa5d4 - PATCH_BASE)
LFQH_Lloh6:
adr x1, LFQH_l_.str.3
LFQH_Lloh7:
nop
bl	LFQH_Equal
cbz	w0, LFQH_LBB0_4
LFQH_Lloh8:
adr x0, LFQH_l_.str.4
LFQH_Lloh9:
nop
bl Lpatch + (0xa5a4 - PATCH_BASE)
mov	x21, x0
LFQH_Lloh10:
adr x0, LFQH_l_.str.156
LFQH_Lloh11:
nop
bl Lpatch + (0xa5b0 - PATCH_BASE)
mov	x22, x0
LFQH_Lloh12:
adr x0, LFQH_l_.str.157
LFQH_Lloh13:
nop
bl Lpatch + (0xa5a4 - PATCH_BASE)
mov	x1, x0
LFQH_Lloh14:
adr x2, LFQH_l_.str.5
LFQH_Lloh15:
nop
mov	x0, x22
bl Lpatch + (0xa5d4 - PATCH_BASE)
mov	x2, x0
mov	x0, x20
mov	x1, x21
bl Lpatch + (0xa5d4 - PATCH_BASE)
LFQH_Lloh16:
adr x1, LFQH_l_.str.6
LFQH_Lloh17:
nop
bl	LFQH_Equal
cbz	w0, LFQH_LBB0_4
LFQH_Lloh18:
adr x0, LFQH_l_.str.8
LFQH_Lloh19:
nop
LFQH_Lloh20:
adr x1, LFQH_l_.str.9
LFQH_Lloh21:
nop
bl	LFQH_Signature
cbz	w0, LFQH_LBB0_4
LFQH_Lloh22:
adr x0, LFQH_l_.str.10
LFQH_Lloh23:
nop
LFQH_Lloh24:
adr x1, LFQH_l_.str.11
LFQH_Lloh25:
nop
bl	LFQH_Signature
mov	x20, x0
b	LFQH_LBB0_5
LFQH_LBB0_4:
mov	w20, #0
LFQH_LBB0_5:
mov	x0, x19
bl Lpatch + (0xa574 - PATCH_BASE)
mov	x0, x20
ldp	x29, x30, [sp, #32]
ldp	x20, x19, [sp, #16]
ldp	x22, x21, [sp], #48
ret
.cfi_endproc
.p2align	2
LFQH_Equal:
.cfi_startproc
cbz	x0, LFQH_LBB1_2
stp	x22, x21, [sp, #-48]!
stp	x20, x19, [sp, #16]
stp	x29, x30, [sp, #32]
add	x29, sp, #32
.cfi_def_cfa w29, 16
.cfi_offset w30, -8
.cfi_offset w29, -16
.cfi_offset w19, -24
.cfi_offset w20, -32
.cfi_offset w21, -40
.cfi_offset w22, -48
mov	x20, x1
mov	x19, x0
LFQH_Lloh26:
adr x0, LFQH_l_.str.51
LFQH_Lloh27:
nop
bl Lpatch + (0xa5a4 - PATCH_BASE)
mov	x21, x0
LFQH_Lloh28:
adr x0, LFQH_l_.str.156
LFQH_Lloh29:
nop
bl Lpatch + (0xa5b0 - PATCH_BASE)
mov	x22, x0
LFQH_Lloh30:
adr x0, LFQH_l_.str.157
LFQH_Lloh31:
nop
bl Lpatch + (0xa5a4 - PATCH_BASE)
mov	x1, x0
mov	x0, x22
mov	x2, x20
bl Lpatch + (0xa5d4 - PATCH_BASE)
mov	x2, x0
mov	x0, x19
mov	x1, x21
bl Lpatch + (0xa5d4 - PATCH_BASE)
cmp	w0, #0
cset	w0, ne
ldp	x29, x30, [sp, #32]
ldp	x20, x19, [sp, #16]
ldp	x22, x21, [sp], #48
LFQH_LBB1_2:
ret
.cfi_endproc
.p2align	2
LFQH_Text:
.cfi_startproc
stp	x20, x19, [sp, #-32]!
stp	x29, x30, [sp, #16]
add	x29, sp, #16
.cfi_def_cfa w29, 16
.cfi_offset w30, -8
.cfi_offset w29, -16
.cfi_offset w19, -24
.cfi_offset w20, -32
mov	x19, x0
LFQH_Lloh32:
adr x0, LFQH_l_.str.156
LFQH_Lloh33:
nop
bl Lpatch + (0xa5b0 - PATCH_BASE)
mov	x20, x0
LFQH_Lloh34:
adr x0, LFQH_l_.str.157
LFQH_Lloh35:
nop
bl Lpatch + (0xa5a4 - PATCH_BASE)
mov	x1, x0
mov	x0, x20
mov	x2, x19
ldp	x29, x30, [sp, #16]
ldp	x20, x19, [sp], #32
b Lpatch + (0xa5d4 - PATCH_BASE)
.cfi_endproc
.p2align	2
LFQH_Signature:
.cfi_startproc
stp	x22, x21, [sp, #-48]!
stp	x20, x19, [sp, #16]
stp	x29, x30, [sp, #32]
add	x29, sp, #32
.cfi_def_cfa w29, 16
.cfi_offset w30, -8
.cfi_offset w29, -16
.cfi_offset w19, -24
.cfi_offset w20, -32
.cfi_offset w21, -40
.cfi_offset w22, -48
mov	x19, x1
mov	x20, x0
LFQH_Lloh36:
adr x0, LFQH_l_.str.7
LFQH_Lloh37:
nop
bl Lpatch + (0xa5b0 - PATCH_BASE)
mov	x21, x0
mov	x0, x20
bl Lpatch + (0xa5a4 - PATCH_BASE)
mov	x1, x0
mov	x0, x21
bl Lpatch + (0xa5f8 - PATCH_BASE)
cbz	x0, LFQH_LBB3_8
bl Lpatch + (0xa5ec - PATCH_BASE)
cbz	x0, LFQH_LBB3_8
ldrb	w9, [x19]
cbz	w9, LFQH_LBB3_6
add	x8, x19, #1
LFQH_LBB3_4:
ldrb	w10, [x0], #1
cmp	w10, w9
b.ne	LFQH_LBB3_7
ldrb	w9, [x8], #1
cbnz	w9, LFQH_LBB3_4
LFQH_LBB3_6:
ldrb	w8, [x0]
cmp	w8, #0
cset	w0, eq
b	LFQH_LBB3_8
LFQH_LBB3_7:
mov	w0, #0
LFQH_LBB3_8:
ldp	x29, x30, [sp, #32]
ldp	x20, x19, [sp, #16]
ldp	x22, x21, [sp], #48
ret
.cfi_endproc
.p2align	2
LFQH_FQHGlassAvailable:
.cfi_startproc
stp	x20, x19, [sp, #-32]!
stp	x29, x30, [sp, #16]
add	x29, sp, #16
.cfi_def_cfa w29, 16
.cfi_offset w30, -8
.cfi_offset w29, -16
.cfi_offset w19, -24
.cfi_offset w20, -32
LFQH_Lloh38:
adr x0, LFQH_l_.str.12
LFQH_Lloh39:
nop
bl Lpatch + (0xa5b0 - PATCH_BASE)
LFQH_Lloh40:
adr x1, LFQH_l_.str.13
LFQH_Lloh41:
nop
bl	LFQH_Responds
cbz	w0, LFQH_LBB4_4
LFQH_Lloh42:
adr x0, LFQH_l_.str.14
LFQH_Lloh43:
nop
bl Lpatch + (0xa5b0 - PATCH_BASE)
LFQH_Lloh44:
adr x1, LFQH_l_.str.15
LFQH_Lloh45:
nop
bl	LFQH_Responds
cbz	w0, LFQH_LBB4_4
LFQH_Lloh46:
adr x0, LFQH_l_.str.16
LFQH_Lloh47:
nop
bl Lpatch + (0xa5b0 - PATCH_BASE)
mov	x19, x0
LFQH_Lloh48:
adr x0, LFQH_l_.str.17
LFQH_Lloh49:
nop
bl Lpatch + (0xa5a4 - PATCH_BASE)
mov	x1, x0
mov	x0, x19
bl Lpatch + (0xa5f8 - PATCH_BASE)
cbz	x0, LFQH_LBB4_4
LFQH_Lloh50:
adr x0, LFQH_l_.str.12
LFQH_Lloh51:
nop
bl Lpatch + (0xa5b0 - PATCH_BASE)
mov	x19, x0
LFQH_Lloh52:
adr x0, LFQH_l_.str.18
LFQH_Lloh53:
nop
bl Lpatch + (0xa5a4 - PATCH_BASE)
mov	x1, x0
mov	x0, x19
bl Lpatch + (0xa5f8 - PATCH_BASE)
cmp	x0, #0
cset	w0, ne
LFQH_LBB4_4:
ldp	x29, x30, [sp, #16]
ldp	x20, x19, [sp], #32
ret
.cfi_endproc
.p2align	2
LFQH_Responds:
.cfi_startproc
cbz	x0, LFQH_LBB5_2
stp	x22, x21, [sp, #-48]!
stp	x20, x19, [sp, #16]
stp	x29, x30, [sp, #32]
add	x29, sp, #32
.cfi_def_cfa w29, 16
.cfi_offset w30, -8
.cfi_offset w29, -16
.cfi_offset w19, -24
.cfi_offset w20, -32
.cfi_offset w21, -40
.cfi_offset w22, -48
mov	x20, x1
mov	x19, x0
LFQH_Lloh54:
adr x0, LFQH_l_.str.158
LFQH_Lloh55:
nop
bl Lpatch + (0xa5a4 - PATCH_BASE)
mov	x21, x0
mov	x0, x20
bl Lpatch + (0xa5a4 - PATCH_BASE)
mov	x2, x0
mov	x0, x19
mov	x1, x21
bl Lpatch + (0xa5d4 - PATCH_BASE)
cmp	w0, #0
cset	w0, ne
ldp	x29, x30, [sp, #32]
ldp	x20, x19, [sp, #16]
ldp	x22, x21, [sp], #48
LFQH_LBB5_2:
ret
.cfi_endproc
.p2align	2
LFQH_FQHIsDuration:
.cfi_startproc
stp	x26, x25, [sp, #-80]!
stp	x24, x23, [sp, #16]
stp	x22, x21, [sp, #32]
stp	x20, x19, [sp, #48]
stp	x29, x30, [sp, #64]
add	x29, sp, #64
.cfi_def_cfa w29, 16
.cfi_offset w30, -8
.cfi_offset w29, -16
.cfi_offset w19, -24
.cfi_offset w20, -32
.cfi_offset w21, -40
.cfi_offset w22, -48
.cfi_offset w23, -56
.cfi_offset w24, -64
.cfi_offset w25, -72
.cfi_offset w26, -80
mov	x19, x0
LFQH_Lloh56:
adr x1, LFQH_l_.str.19
LFQH_Lloh57:
nop
bl	LFQH_Kind
tbz	w0, #0, LFQH_LBB6_3
LFQH_LBB6_1:
mov	w0, #1
LFQH_LBB6_2:
ldp	x29, x30, [sp, #64]
ldp	x20, x19, [sp, #48]
ldp	x22, x21, [sp, #32]
ldp	x24, x23, [sp, #16]
ldp	x26, x25, [sp], #80
ret
LFQH_LBB6_3:
LFQH_Lloh58:
adr x1, LFQH_l_.str.20
LFQH_Lloh59:
nop
mov	x0, x19
bl	LFQH_Get
cbz	x0, LFQH_LBB6_2
mov	x20, x0
mov	w26, #0
LFQH_Lloh60:
adr x21, LFQH_l_.str.159
LFQH_Lloh61:
nop
LFQH_Lloh62:
adr x22, LFQH_l_.str.21
LFQH_Lloh63:
nop
LFQH_Lloh64:
adr x23, LFQH_l_.str.20
LFQH_Lloh65:
nop
LFQH_Lloh66:
adr x24, LFQH_l_.str.22
LFQH_Lloh67:
nop
LFQH_LBB6_5:
mov	x0, x21
bl Lpatch + (0xa5a4 - PATCH_BASE)
mov	x25, x0
mov	x0, x22
bl Lpatch + (0xa5b0 - PATCH_BASE)
mov	x2, x0
mov	x0, x20
mov	x1, x25
bl Lpatch + (0xa5d4 - PATCH_BASE)
cbz	w0, LFQH_LBB6_7
mov	x0, x20
mov	x1, x24
bl	LFQH_Get
cmp	x0, x19
b.eq	LFQH_LBB6_1
LFQH_LBB6_7:
mov	x0, x20
mov	x1, x23
bl	LFQH_Get
mov	x20, x0
mov	w0, #0
cbz	x20, LFQH_LBB6_2
cmp	w26, #3
add	w26, w26, #1
b.lo	LFQH_LBB6_5
b	LFQH_LBB6_2
.cfi_endproc
.p2align	2
LFQH_Kind:
.cfi_startproc
cbz	x0, LFQH_LBB7_2
stp	x22, x21, [sp, #-48]!
stp	x20, x19, [sp, #16]
stp	x29, x30, [sp, #32]
add	x29, sp, #32
.cfi_def_cfa w29, 16
.cfi_offset w30, -8
.cfi_offset w29, -16
.cfi_offset w19, -24
.cfi_offset w20, -32
.cfi_offset w21, -40
.cfi_offset w22, -48
mov	x20, x1
mov	x19, x0
LFQH_Lloh68:
adr x0, LFQH_l_.str.159
LFQH_Lloh69:
nop
bl Lpatch + (0xa5a4 - PATCH_BASE)
mov	x21, x0
mov	x0, x20
bl Lpatch + (0xa5b0 - PATCH_BASE)
mov	x2, x0
mov	x0, x19
mov	x1, x21
bl Lpatch + (0xa5d4 - PATCH_BASE)
cmp	w0, #0
cset	w0, ne
ldp	x29, x30, [sp, #32]
ldp	x20, x19, [sp, #16]
ldp	x22, x21, [sp], #48
LFQH_LBB7_2:
ret
.cfi_endproc
.p2align	2
LFQH_Get:
.cfi_startproc
stp	x20, x19, [sp, #-32]!
stp	x29, x30, [sp, #16]
add	x29, sp, #16
.cfi_def_cfa w29, 16
.cfi_offset w30, -8
.cfi_offset w29, -16
.cfi_offset w19, -24
.cfi_offset w20, -32
mov	x20, x1
mov	x19, x0
bl	LFQH_Responds
cbz	w0, LFQH_LBB8_2
mov	x0, x20
bl Lpatch + (0xa5a4 - PATCH_BASE)
mov	x1, x0
mov	x0, x19
ldp	x29, x30, [sp, #16]
ldp	x20, x19, [sp], #32
b Lpatch + (0xa5d4 - PATCH_BASE)
LFQH_LBB8_2:
mov	x0, #0
ldp	x29, x30, [sp, #16]
ldp	x20, x19, [sp], #32
ret
.cfi_endproc
.p2align	2
LFQH_FQHSurface:
.cfi_startproc
LFQH_Lloh70:
adr x1, LFQH_SurfaceKey
LFQH_Lloh71:
nop
b Lpatch + (0xa628 - PATCH_BASE)
.cfi_endproc
.p2align	2
LFQH_SurfaceKey:
.cfi_startproc
ret
.cfi_endproc
.p2align	2
LFQH_FQHApply:
.cfi_startproc
stp	x20, x19, [sp, #-32]!
stp	x29, x30, [sp, #16]
add	x29, sp, #16
.cfi_def_cfa w29, 16
.cfi_offset w30, -8
.cfi_offset w29, -16
.cfi_offset w19, -24
.cfi_offset w20, -32
mov	x19, x0
LFQH_Lloh72:
adr x1, LFQH_l_.str.23
LFQH_Lloh73:
nop
bl	LFQH_Kind
cbz	w0, LFQH_LBB11_2
LFQH_Lloh74:
adr x0, LFQH_l_.str.24
LFQH_Lloh75:
nop
bl Lpatch + (0xa5a4 - PATCH_BASE)
mov	x1, x0
mov	x0, x19
bl Lpatch + (0xa5d4 - PATCH_BASE)
mov	x0, x19
mov	w1, #0
ldp	x29, x30, [sp, #16]
ldp	x20, x19, [sp], #32
b	LFQH_ApplySurface
LFQH_LBB11_2:
ldp	x29, x30, [sp, #16]
ldp	x20, x19, [sp], #32
ret
.cfi_endproc
.p2align	2
LFQH_ApplySurface:
.cfi_startproc
stp	d11, d10, [sp, #-96]!
stp	d9, d8, [sp, #16]
stp	x24, x23, [sp, #32]
stp	x22, x21, [sp, #48]
stp	x20, x19, [sp, #64]
stp	x29, x30, [sp, #80]
add	x29, sp, #80
.cfi_def_cfa w29, 16
.cfi_offset w30, -8
.cfi_offset w29, -16
.cfi_offset w19, -24
.cfi_offset w20, -32
.cfi_offset w21, -40
.cfi_offset w22, -48
.cfi_offset w23, -56
.cfi_offset w24, -64
.cfi_offset b8, -72
.cfi_offset b9, -80
.cfi_offset b10, -88
.cfi_offset b11, -96
mov	x21, x1
mov.16b	v8, v3
mov.16b	v9, v2
mov.16b	v10, v1
mov.16b	v11, v0
mov	x19, x0
LFQH_Lloh76:
adr x1, LFQH_BusyKey
LFQH_Lloh77:
nop
bl Lpatch + (0xa628 - PATCH_BASE)
cbz	x0, LFQH_LBB12_2
ldp	x29, x30, [sp, #80]
ldp	x20, x19, [sp, #64]
ldp	x22, x21, [sp, #48]
ldp	x24, x23, [sp, #32]
ldp	d9, d8, [sp, #16]
ldp	d11, d10, [sp], #96
ret
LFQH_LBB12_2:
LFQH_Lloh78:
adr x1, LFQH_BusyKey
LFQH_Lloh79:
nop
mov	x0, x19
mov	x2, x19
mov	x3, #0
bl Lpatch + (0xa634 - PATCH_BASE)
LFQH_Lloh80:
adr x1, LFQH_SurfaceKey
LFQH_Lloh81:
nop
mov	x0, x19
bl Lpatch + (0xa628 - PATCH_BASE)
mov	x20, x0
bl	LFQH_Enabled
cbz	w0, LFQH_LBB12_4
bl	LFQH_FQHGlassAvailable
fmov	x8, d9
ubfx	x8, x8, #52, #11
cmp	x8, #2046
ccmp	w0, #0, #4, ls
fmov	x8, d11
ubfx	x8, x8, #52, #11
fmov	x9, d10
ubfx	x9, x9, #52, #11
mov	w10, #2046
ccmp	x9, x10, #2, ne
ccmp	x8, x10, #2, ls
b.ls	LFQH_LBB12_6
LFQH_LBB12_4:
mov	x0, x19
mov	x1, x20
bl	LFQH_Restore
LFQH_LBB12_5:
LFQH_Lloh82:
adr x1, LFQH_BusyKey
LFQH_Lloh83:
nop
mov	x0, x19
mov	x2, #0
mov	x3, #0
ldp	x29, x30, [sp, #80]
ldp	x20, x19, [sp, #64]
ldp	x22, x21, [sp, #48]
ldp	x24, x23, [sp, #32]
ldp	d9, d8, [sp, #16]
ldp	d11, d10, [sp], #96
b Lpatch + (0xa634 - PATCH_BASE)
LFQH_LBB12_6:
fmov	x8, d8
ubfx	x8, x8, #52, #11
cmp	x8, #2046
b.hi	LFQH_LBB12_4
fcmp	d9, #0.0
b.le	LFQH_LBB12_4
fcmp	d8, #0.0
b.le	LFQH_LBB12_4
cbz	x20, LFQH_LBB12_16
LFQH_LBB12_10:
LFQH_Lloh84:
adr x0, LFQH_l_.str.49
LFQH_Lloh85:
nop
bl Lpatch + (0xa5b0 - PATCH_BASE)
mov	x22, x0
LFQH_Lloh86:
adr x0, LFQH_l_.str.168
LFQH_Lloh87:
nop
bl Lpatch + (0xa5a4 - PATCH_BASE)
mov	x1, x0
mov	x0, x22
bl Lpatch + (0xa5d4 - PATCH_BASE)
mov	x23, x0
LFQH_Lloh88:
adr x0, LFQH_l_.str.169
LFQH_Lloh89:
nop
bl Lpatch + (0xa5b0 - PATCH_BASE)
mov	x22, x0
LFQH_Lloh90:
adr x0, LFQH_l_.str.170
LFQH_Lloh91:
nop
bl Lpatch + (0xa5a4 - PATCH_BASE)
mov	x1, x0
mov	x0, x22
bl Lpatch + (0xa5d4 - PATCH_BASE)
LFQH_Lloh92:
adr x0, LFQH_l_.str.171
LFQH_Lloh93:
nop
bl Lpatch + (0xa5a4 - PATCH_BASE)
mov	x1, x0
mov	x0, x22
mov	w2, #1
bl Lpatch + (0xa5d4 - PATCH_BASE)
cbnz	w21, LFQH_LBB12_22
LFQH_Lloh94:
adr x0, LFQH_l_.str.167
LFQH_Lloh95:
nop
bl Lpatch + (0xa5a4 - PATCH_BASE)
mov	x1, x0
mov	x0, x19
bl Lpatch + (0xa5d4 - PATCH_BASE)
cmp	x0, x23
b.eq	LFQH_LBB12_14
mov	x21, x0
LFQH_Lloh96:
adr x0, LFQH_l_.str.51
LFQH_Lloh97:
nop
bl Lpatch + (0xa5a4 - PATCH_BASE)
mov	x1, x0
mov	x0, x21
mov	x2, x23
bl Lpatch + (0xa5d4 - PATCH_BASE)
cbnz	w0, LFQH_LBB12_14
LFQH_Lloh98:
adr x1, LFQH_BackgroundKey
LFQH_Lloh99:
nop
mov	x0, x19
mov	x2, x21
mov	w3, #1
bl Lpatch + (0xa634 - PATCH_BASE)
LFQH_LBB12_14:
LFQH_Lloh100:
adr x1, LFQH_HeaderKey
LFQH_Lloh101:
nop
mov	x0, x19
bl Lpatch + (0xa628 - PATCH_BASE)
cbz	x0, LFQH_LBB12_20
mov	x0, x19
mov.16b	v0, v11
mov.16b	v1, v10
mov.16b	v2, v9
mov.16b	v3, v8
bl	LFQH_PrepareHeaderOwner
b	LFQH_LBB12_21
LFQH_LBB12_16:
LFQH_Lloh102:
adr x0, LFQH_l_.str.12
LFQH_Lloh103:
nop
bl Lpatch + (0xa5b0 - PATCH_BASE)
mov	x20, x0
LFQH_Lloh104:
adr x0, LFQH_l_.str.13
LFQH_Lloh105:
nop
bl Lpatch + (0xa5a4 - PATCH_BASE)
mov	x1, x0
mov	x0, x20
mov	x2, #0
bl Lpatch + (0xa5d4 - PATCH_BASE)
cbz	x0, LFQH_LBB12_5
mov	x20, x0
LFQH_Lloh106:
adr x0, LFQH_l_.str.18
LFQH_Lloh107:
nop
bl Lpatch + (0xa5a4 - PATCH_BASE)
mov	x1, x0
mov	x0, x20
mov	w2, #1
bl Lpatch + (0xa5d4 - PATCH_BASE)
LFQH_Lloh108:
adr x0, LFQH_l_.str.16
LFQH_Lloh109:
nop
bl Lpatch + (0xa5b0 - PATCH_BASE)
mov	x22, x0
LFQH_Lloh110:
adr x0, LFQH_l_.str.160
LFQH_Lloh111:
nop
bl Lpatch + (0xa5a4 - PATCH_BASE)
mov	x1, x0
mov	x0, x22
bl Lpatch + (0xa5d4 - PATCH_BASE)
mov	x22, x0
LFQH_Lloh112:
adr x0, LFQH_l_.str.161
LFQH_Lloh113:
nop
bl Lpatch + (0xa5a4 - PATCH_BASE)
mov	x1, x0
mov	x0, x22
mov	x2, x20
bl Lpatch + (0xa5d4 - PATCH_BASE)
cbz	x0, LFQH_LBB12_5
mov	x20, x0
LFQH_Lloh114:
adr x0, LFQH_l_.str.17
LFQH_Lloh115:
nop
bl Lpatch + (0xa5a4 - PATCH_BASE)
mov	x22, x0
LFQH_Lloh116:
adr x0, LFQH_l_.str.14
LFQH_Lloh117:
nop
bl Lpatch + (0xa5b0 - PATCH_BASE)
mov	x23, x0
LFQH_Lloh118:
adr x0, LFQH_l_.str.15
LFQH_Lloh119:
nop
bl Lpatch + (0xa5a4 - PATCH_BASE)
mov	x1, x0
mov	x0, x23
bl Lpatch + (0xa5d4 - PATCH_BASE)
mov	x2, x0
mov	x0, x20
mov	x1, x22
bl Lpatch + (0xa5d4 - PATCH_BASE)
LFQH_Lloh120:
adr x0, LFQH_l_.str.162
LFQH_Lloh121:
nop
bl Lpatch + (0xa5a4 - PATCH_BASE)
mov	x1, x0
mov	x0, x20
mov	w2, #0
bl Lpatch + (0xa5d4 - PATCH_BASE)
LFQH_Lloh122:
adr x0, LFQH_l_.str.163
LFQH_Lloh123:
nop
bl Lpatch + (0xa5a4 - PATCH_BASE)
mov	x1, x0
mov	x0, x20
mov	w2, #1
bl Lpatch + (0xa5d4 - PATCH_BASE)
LFQH_Lloh124:
adr x0, LFQH_l_.str.164
LFQH_Lloh125:
nop
bl Lpatch + (0xa5a4 - PATCH_BASE)
mov	x1, x0
mov	x0, x20
mov	w2, #0
bl Lpatch + (0xa5d4 - PATCH_BASE)
LFQH_Lloh126:
adr x0, LFQH_l_.str.165
LFQH_Lloh127:
nop
bl Lpatch + (0xa5a4 - PATCH_BASE)
mov	x1, x0
mov	x0, x20
mov	w2, #0
bl Lpatch + (0xa5d4 - PATCH_BASE)
LFQH_Lloh128:
adr x0, LFQH_l_.str.166
LFQH_Lloh129:
nop
bl Lpatch + (0xa5a4 - PATCH_BASE)
mov	x1, x0
mov	x0, x20
mov	w2, #18
bl Lpatch + (0xa5d4 - PATCH_BASE)
LFQH_Lloh130:
adr x1, LFQH_SurfaceKey
LFQH_Lloh131:
nop
mov	x0, x19
mov	x2, x20
mov	w3, #1
bl Lpatch + (0xa634 - PATCH_BASE)
LFQH_Lloh132:
adr x0, LFQH_l_.str.58
LFQH_Lloh133:
nop
bl Lpatch + (0xa5a4 - PATCH_BASE)
mov	x1, x0
mov	x0, x20
bl Lpatch + (0xa5d4 - PATCH_BASE)
cbnz	w21, LFQH_LBB12_10
LFQH_Lloh134:
adr x0, LFQH_l_.str.167
LFQH_Lloh135:
nop
bl Lpatch + (0xa5a4 - PATCH_BASE)
mov	x1, x0
mov	x0, x19
bl Lpatch + (0xa5d4 - PATCH_BASE)
mov	x2, x0
LFQH_Lloh136:
adr x1, LFQH_BackgroundKey
LFQH_Lloh137:
nop
mov	x0, x19
mov	w3, #1
bl Lpatch + (0xa634 - PATCH_BASE)
b	LFQH_LBB12_10
LFQH_LBB12_20:
mov	x0, x19
bl	LFQH_PrepareOwner
LFQH_LBB12_21:
mov	x0, x19
mov	x1, x23
bl	LFQH_ClearBackground
LFQH_LBB12_22:
LFQH_Lloh138:
adr x0, LFQH_l_.str.172
LFQH_Lloh139:
nop
bl Lpatch + (0xa5a4 - PATCH_BASE)
mov	x1, x0
mov	x0, x20
bl Lpatch + (0xa5d4 - PATCH_BASE)
fcmp	d0, d11
b.ne	LFQH_LBB12_26
fcmp	d1, d10
b.ne	LFQH_LBB12_26
fcmp	d2, d9
b.ne	LFQH_LBB12_26
fcmp	d3, d8
b.eq	LFQH_LBB12_27
LFQH_LBB12_26:
LFQH_Lloh140:
adr x0, LFQH_l_.str.173
LFQH_Lloh141:
nop
bl Lpatch + (0xa5a4 - PATCH_BASE)
mov	x1, x0
mov	x0, x20
mov.16b	v0, v11
mov.16b	v1, v10
mov.16b	v2, v9
mov.16b	v3, v8
bl Lpatch + (0xa5d4 - PATCH_BASE)
LFQH_LBB12_27:
mov	x0, x20
mov	x1, x23
bl	LFQH_ClearBackground
LFQH_Lloh142:
adr x0, LFQH_l_.str.174
LFQH_Lloh143:
nop
bl Lpatch + (0xa5a4 - PATCH_BASE)
mov	x1, x0
mov	x0, x20
bl Lpatch + (0xa5d4 - PATCH_BASE)
mov	x1, x23
bl	LFQH_ClearBackground
LFQH_Lloh144:
adr x0, LFQH_l_.str.20
LFQH_Lloh145:
nop
bl Lpatch + (0xa5a4 - PATCH_BASE)
mov	x1, x0
mov	x0, x20
bl Lpatch + (0xa5d4 - PATCH_BASE)
cmp	x0, x19
b.eq	LFQH_LBB12_29
LFQH_Lloh146:
adr x0, LFQH_l_.str.175
LFQH_Lloh147:
nop
bl Lpatch + (0xa5a4 - PATCH_BASE)
mov	x1, x0
mov	x0, x19
mov	x2, x20
mov	x3, #0
bl Lpatch + (0xa5d4 - PATCH_BASE)
LFQH_LBB12_29:
LFQH_Lloh148:
adr x0, LFQH_l_.str.176
LFQH_Lloh149:
nop
bl Lpatch + (0xa5a4 - PATCH_BASE)
mov	x1, x0
mov	x0, x22
bl Lpatch + (0xa5d4 - PATCH_BASE)
b	LFQH_LBB12_5
.cfi_endproc
.p2align	2
LFQH_FQHHeader:
.cfi_startproc
stp	d13, d12, [sp, #-144]!
stp	d11, d10, [sp, #16]
stp	d9, d8, [sp, #32]
stp	x28, x27, [sp, #48]
stp	x26, x25, [sp, #64]
stp	x24, x23, [sp, #80]
stp	x22, x21, [sp, #96]
stp	x20, x19, [sp, #112]
stp	x29, x30, [sp, #128]
add	x29, sp, #128
.cfi_def_cfa w29, 16
.cfi_offset w30, -8
.cfi_offset w29, -16
.cfi_offset w19, -24
.cfi_offset w20, -32
.cfi_offset w21, -40
.cfi_offset w22, -48
.cfi_offset w23, -56
.cfi_offset w24, -64
.cfi_offset w25, -72
.cfi_offset w26, -80
.cfi_offset w27, -88
.cfi_offset w28, -96
.cfi_offset b8, -104
.cfi_offset b9, -112
.cfi_offset b10, -120
.cfi_offset b11, -128
.cfi_offset b12, -136
.cfi_offset b13, -144
mov	x19, x0
LFQH_Lloh150:
adr x1, LFQH_l_.str.23
LFQH_Lloh151:
nop
bl	LFQH_Kind
cbz	w0, LFQH_LBB13_9
LFQH_Lloh152:
adr x1, LFQH_l_.str.25
LFQH_Lloh153:
nop
mov	x0, x19
bl	LFQH_Kind
LFQH_Lloh154:
adr x8, LFQH_l_.str.26
LFQH_Lloh155:
nop
LFQH_Lloh156:
adr x9, LFQH_l_.str.27
LFQH_Lloh157:
nop
cmp	w0, #0
csel	x20, x9, x8, eq
LFQH_Lloh158:
adr x0, LFQH_l_.str.156
LFQH_Lloh159:
nop
bl Lpatch + (0xa5b0 - PATCH_BASE)
mov	x21, x0
LFQH_Lloh160:
adr x0, LFQH_l_.str.157
LFQH_Lloh161:
nop
bl Lpatch + (0xa5a4 - PATCH_BASE)
mov	x1, x0
mov	x0, x21
mov	x2, x20
bl Lpatch + (0xa5d4 - PATCH_BASE)
mov	x2, x0
LFQH_Lloh162:
adr x1, LFQH_HeaderKey
LFQH_Lloh163:
nop
mov	x0, x19
mov	w3, #1
bl Lpatch + (0xa634 - PATCH_BASE)
mov	x0, x19
bl	LFQH_FQHApply
LFQH_Lloh164:
adr x1, LFQH_SurfaceKey
LFQH_Lloh165:
nop
mov	x0, x19
bl Lpatch + (0xa628 - PATCH_BASE)
cbz	x0, LFQH_LBB13_9
LFQH_Lloh166:
adr x0, LFQH_l_.str.24
LFQH_Lloh167:
nop
bl Lpatch + (0xa5a4 - PATCH_BASE)
mov	x1, x0
mov	x0, x19
bl Lpatch + (0xa5d4 - PATCH_BASE)
mov.16b	v8, v0
mov.16b	v9, v1
mov.16b	v10, v2
mov.16b	v11, v3
LFQH_Lloh168:
adr x1, LFQH_HeaderLogKey
LFQH_Lloh169:
nop
mov	x0, x19
bl Lpatch + (0xa628 - PATCH_BASE)
cbz	x0, LFQH_LBB13_7
mov	x20, x0
LFQH_Lloh170:
adr x0, LFQH_l_.str.200
LFQH_Lloh171:
nop
bl Lpatch + (0xa5a4 - PATCH_BASE)
mov	x1, x0
mov	x0, x20
bl Lpatch + (0xa5d4 - PATCH_BASE)
fcmp	d8, d0
b.ne	LFQH_LBB13_7
fcmp	d9, d1
b.ne	LFQH_LBB13_7
fcmp	d10, d2
b.ne	LFQH_LBB13_7
fcmp	d11, d3
b.eq	LFQH_LBB13_9
LFQH_LBB13_7:
LFQH_Lloh172:
adr x0, LFQH_l_.str.188
LFQH_Lloh173:
nop
bl Lpatch + (0xa5b0 - PATCH_BASE)
mov	x20, x0
LFQH_Lloh174:
adr x0, LFQH_l_.str.189
LFQH_Lloh175:
nop
bl Lpatch + (0xa5a4 - PATCH_BASE)
mov	x1, x0
mov	x0, x20
bl Lpatch + (0xa5d4 - PATCH_BASE)
mov	x20, x0
LFQH_Lloh176:
adr x0, LFQH_l_.str.190
LFQH_Lloh177:
nop
bl Lpatch + (0xa5a4 - PATCH_BASE)
mov	x1, x0
mov	x0, x20
bl Lpatch + (0xa5d4 - PATCH_BASE)
mov.16b	v12, v0
LFQH_Lloh178:
adr x1, LFQH_HeaderLogTimeKey
LFQH_Lloh179:
nop
mov	x0, x19
bl Lpatch + (0xa628 - PATCH_BASE)
cbz	x0, LFQH_LBB13_10
mov	x20, x0
LFQH_Lloh180:
adr x0, LFQH_l_.str.184
LFQH_Lloh181:
nop
bl Lpatch + (0xa5a4 - PATCH_BASE)
mov	x1, x0
mov	x0, x20
bl Lpatch + (0xa5d4 - PATCH_BASE)
fsub	d0, d12, d0
fmov	d1, #1.00000000
fcmp	d0, d1
b.pl	LFQH_LBB13_10
LFQH_LBB13_9:
ldp	x29, x30, [sp, #128]
ldp	x20, x19, [sp, #112]
ldp	x22, x21, [sp, #96]
ldp	x24, x23, [sp, #80]
ldp	x26, x25, [sp, #64]
ldp	x28, x27, [sp, #48]
ldp	d9, d8, [sp, #32]
ldp	d11, d10, [sp, #16]
ldp	d13, d12, [sp], #144
ret
LFQH_LBB13_10:
LFQH_Lloh182:
adr x0, LFQH_l_.str.201
LFQH_Lloh183:
nop
bl Lpatch + (0xa5b0 - PATCH_BASE)
mov	x20, x0
LFQH_Lloh184:
adr x0, LFQH_l_.str.202
LFQH_Lloh185:
nop
bl Lpatch + (0xa5a4 - PATCH_BASE)
mov	x1, x0
mov	x0, x20
mov.16b	v0, v8
mov.16b	v1, v9
mov.16b	v2, v10
mov.16b	v3, v11
bl Lpatch + (0xa5d4 - PATCH_BASE)
mov	x2, x0
LFQH_Lloh186:
adr x1, LFQH_HeaderLogKey
LFQH_Lloh187:
nop
mov	x0, x19
mov	w3, #1
bl Lpatch + (0xa634 - PATCH_BASE)
LFQH_Lloh188:
adr x21, LFQH_l_.str.182
LFQH_Lloh189:
nop
mov	x0, x21
bl Lpatch + (0xa5b0 - PATCH_BASE)
mov	x20, x0
LFQH_Lloh190:
adr x22, LFQH_l_.str.185
LFQH_Lloh191:
nop
mov	x0, x22
bl Lpatch + (0xa5a4 - PATCH_BASE)
mov	x1, x0
mov	x0, x20
mov.16b	v0, v12
bl Lpatch + (0xa5d4 - PATCH_BASE)
mov	x2, x0
LFQH_Lloh192:
adr x1, LFQH_HeaderLogTimeKey
LFQH_Lloh193:
nop
mov	x0, x19
mov	w3, #1
bl Lpatch + (0xa634 - PATCH_BASE)
LFQH_Lloh194:
adr x0, LFQH_l_.str.73
LFQH_Lloh195:
nop
bl Lpatch + (0xa5b0 - PATCH_BASE)
mov	x20, x0
LFQH_Lloh196:
adr x0, LFQH_l_.str.74
LFQH_Lloh197:
nop
bl Lpatch + (0xa5a4 - PATCH_BASE)
mov	x1, x0
mov	x0, x20
bl Lpatch + (0xa5d4 - PATCH_BASE)
mov	x20, x0
LFQH_Lloh198:
adr x1, LFQH_HeaderKey
LFQH_Lloh199:
nop
mov	x0, x19
bl Lpatch + (0xa628 - PATCH_BASE)
mov	x2, x0
LFQH_Lloh200:
adr x1, LFQH_l_.str.191
LFQH_Lloh201:
nop
mov	x0, x20
bl	LFQH_Put
LFQH_Lloh202:
adr x23, LFQH_l_.str.172
LFQH_Lloh203:
nop
mov	x0, x23
bl Lpatch + (0xa5a4 - PATCH_BASE)
mov	x1, x0
mov	x0, x19
bl Lpatch + (0xa5d4 - PATCH_BASE)
bl	LFQH_RectArray
mov	x2, x0
LFQH_Lloh204:
adr x1, LFQH_l_.str.192
LFQH_Lloh205:
nop
mov	x0, x20
bl	LFQH_Put
mov.16b	v0, v8
mov.16b	v1, v9
mov.16b	v2, v10
mov.16b	v3, v11
bl	LFQH_RectArray
mov	x2, x0
LFQH_Lloh206:
adr x1, LFQH_l_.str.193
LFQH_Lloh207:
nop
mov	x0, x20
bl	LFQH_Put
LFQH_Lloh208:
adr x1, LFQH_SurfaceKey
LFQH_Lloh209:
nop
mov	x0, x19
bl Lpatch + (0xa628 - PATCH_BASE)
mov	x24, x0
mov	x0, x23
bl Lpatch + (0xa5a4 - PATCH_BASE)
mov	x1, x0
mov	x0, x24
bl Lpatch + (0xa5d4 - PATCH_BASE)
bl	LFQH_RectArray
mov	x2, x0
LFQH_Lloh210:
adr x1, LFQH_l_.str.194
LFQH_Lloh211:
nop
mov	x0, x20
bl	LFQH_Put
LFQH_Lloh212:
adr x23, LFQH_l_.str.177
LFQH_Lloh213:
nop
mov	x0, x23
bl Lpatch + (0xa5a4 - PATCH_BASE)
mov	x1, x0
mov	x0, x19
bl Lpatch + (0xa5d4 - PATCH_BASE)
mov	x25, x0
mov	x0, x21
bl Lpatch + (0xa5b0 - PATCH_BASE)
mov	x26, x0
LFQH_Lloh214:
adr x24, LFQH_l_.str.183
LFQH_Lloh215:
nop
mov	x0, x24
bl Lpatch + (0xa5a4 - PATCH_BASE)
mov	x1, x0
mov	x0, x26
mov	x2, x25
bl Lpatch + (0xa5d4 - PATCH_BASE)
mov	x2, x0
mov	x0, x20
mov	x1, x23
bl	LFQH_Put
LFQH_Lloh216:
adr x0, LFQH_l_.str.180
LFQH_Lloh217:
nop
bl Lpatch + (0xa5a4 - PATCH_BASE)
mov	x1, x0
mov	x0, x19
bl Lpatch + (0xa5d4 - PATCH_BASE)
mov	x23, x0
LFQH_Lloh218:
adr x25, LFQH_l_.str.181
LFQH_Lloh219:
nop
mov	x0, x25
bl Lpatch + (0xa5a4 - PATCH_BASE)
mov	x1, x0
mov	x0, x23
bl Lpatch + (0xa5d4 - PATCH_BASE)
mov.16b	v8, v0
mov	x0, x21
bl Lpatch + (0xa5b0 - PATCH_BASE)
mov	x23, x0
mov	x0, x22
bl Lpatch + (0xa5a4 - PATCH_BASE)
mov	x1, x0
mov	x0, x23
mov.16b	v0, v8
bl Lpatch + (0xa5d4 - PATCH_BASE)
mov	x2, x0
mov	x0, x20
mov	x1, x25
bl	LFQH_Put
LFQH_Lloh220:
adr x1, LFQH_l_.str.195
LFQH_Lloh221:
nop
mov	x0, x19
bl	LFQH_Get
mov	x19, x0
LFQH_Lloh222:
adr x0, LFQH_l_.str.71
LFQH_Lloh223:
nop
bl Lpatch + (0xa5b0 - PATCH_BASE)
mov	x23, x0
LFQH_Lloh224:
adr x0, LFQH_l_.str.84
LFQH_Lloh225:
nop
bl Lpatch + (0xa5a4 - PATCH_BASE)
mov	x1, x0
mov	x0, x23
bl Lpatch + (0xa5d4 - PATCH_BASE)
mov	x23, x0
LFQH_Lloh226:
adr x0, LFQH_l_.str.36
LFQH_Lloh227:
nop
bl Lpatch + (0xa5a4 - PATCH_BASE)
mov	x1, x0
mov	x0, x19
bl Lpatch + (0xa5d4 - PATCH_BASE)
mov	x25, x0
ucvtf	d8, x0
mov	x0, x21
bl Lpatch + (0xa5b0 - PATCH_BASE)
mov	x26, x0
mov	x0, x22
bl Lpatch + (0xa5a4 - PATCH_BASE)
mov	x1, x0
mov	x0, x26
mov.16b	v0, v8
bl Lpatch + (0xa5d4 - PATCH_BASE)
mov	x2, x0
LFQH_Lloh228:
adr x1, LFQH_l_.str.196
LFQH_Lloh229:
nop
mov	x0, x20
bl	LFQH_Put
mov	x0, x21
bl Lpatch + (0xa5b0 - PATCH_BASE)
mov	x21, x0
mov	x0, x24
bl Lpatch + (0xa5a4 - PATCH_BASE)
mov	x1, x0
cmp	x25, #12
cset	w2, hi
mov	w8, #12
csel	x28, x25, x8, lo
mov	x0, x21
bl Lpatch + (0xa5d4 - PATCH_BASE)
mov	x2, x0
LFQH_Lloh230:
adr x1, LFQH_l_.str.197
LFQH_Lloh231:
nop
mov	x0, x20
bl	LFQH_Put
cbz	x25, LFQH_LBB13_13
mov	x21, #0
LFQH_Lloh232:
adr x22, LFQH_l_.str.88
LFQH_Lloh233:
nop
LFQH_Lloh234:
adr x24, LFQH_l_.str.229
LFQH_Lloh235:
nop
LFQH_Lloh236:
adr x25, LFQH_l_.str.172
LFQH_Lloh237:
nop
LFQH_LBB13_12:
mov	x0, x22
bl Lpatch + (0xa5a4 - PATCH_BASE)
mov	x26, x0
mov	x0, x24
bl Lpatch + (0xa5a4 - PATCH_BASE)
mov	x1, x0
mov	x0, x19
mov	x2, x21
bl Lpatch + (0xa5d4 - PATCH_BASE)
mov	x27, x0
mov	x0, x25
bl Lpatch + (0xa5a4 - PATCH_BASE)
mov	x1, x0
mov	x0, x27
bl Lpatch + (0xa5d4 - PATCH_BASE)
bl	LFQH_RectArray
mov	x2, x0
mov	x0, x23
mov	x1, x26
bl Lpatch + (0xa5d4 - PATCH_BASE)
add	x21, x21, #1
cmp	x28, x21
b.ne	LFQH_LBB13_12
LFQH_LBB13_13:
LFQH_Lloh238:
adr x1, LFQH_l_.str.198
LFQH_Lloh239:
nop
mov	x0, x20
mov	x2, x23
bl	LFQH_Put
LFQH_Lloh240:
adr x0, LFQH_l_.str.199
LFQH_Lloh241:
nop
mov	x1, x20
ldp	x29, x30, [sp, #128]
ldp	x20, x19, [sp, #112]
ldp	x22, x21, [sp, #96]
ldp	x24, x23, [sp, #80]
ldp	x26, x25, [sp, #64]
ldp	x28, x27, [sp, #48]
ldp	d9, d8, [sp, #32]
ldp	d11, d10, [sp, #16]
ldp	d13, d12, [sp], #144
b Lrecord_named
.cfi_endproc
.p2align	2
LFQH_HeaderKey:
.cfi_startproc
ret
.cfi_endproc
.p2align	2
LFQH_FQHButtonAvailable:
.cfi_startproc
stp	x29, x30, [sp, #-16]!
mov	x29, sp
.cfi_def_cfa w29, 16
.cfi_offset w30, -8
.cfi_offset w29, -16
LFQH_Lloh242:
adr x0, LFQH_l_.str.28
LFQH_Lloh243:
nop
bl Lpatch + (0xa5b0 - PATCH_BASE)
LFQH_Lloh244:
adr x1, LFQH_l_.str.29
LFQH_Lloh245:
nop
ldp	x29, x30, [sp], #16
b	LFQH_Responds
.cfi_endproc
.p2align	2
LFQH_FQHIconGlass:
.cfi_startproc
LFQH_Lloh246:
adr x1, LFQH_IconGlassKey
LFQH_Lloh247:
nop
b Lpatch + (0xa628 - PATCH_BASE)
.cfi_endproc
.p2align	2
LFQH_IconGlassKey:
.cfi_startproc
ret
.cfi_endproc
.p2align	2
LFQH_FQHButton:
.cfi_startproc
LFQH_Lloh248:
adr x1, LFQH_l_.str.30
LFQH_Lloh249:
nop
b	LFQH_Icon
.cfi_endproc
.p2align	2
LFQH_Icon:
.cfi_startproc
sub	sp, sp, #224
stp	d15, d14, [sp, #80]
stp	d13, d12, [sp, #96]
stp	d11, d10, [sp, #112]
stp	d9, d8, [sp, #128]
stp	x26, x25, [sp, #144]
stp	x24, x23, [sp, #160]
stp	x22, x21, [sp, #176]
stp	x20, x19, [sp, #192]
stp	x29, x30, [sp, #208]
add	x29, sp, #208
.cfi_def_cfa w29, 16
.cfi_offset w30, -8
.cfi_offset w29, -16
.cfi_offset w19, -24
.cfi_offset w20, -32
.cfi_offset w21, -40
.cfi_offset w22, -48
.cfi_offset w23, -56
.cfi_offset w24, -64
.cfi_offset w25, -72
.cfi_offset w26, -80
.cfi_offset b8, -88
.cfi_offset b9, -96
.cfi_offset b10, -104
.cfi_offset b11, -112
.cfi_offset b12, -120
.cfi_offset b13, -128
.cfi_offset b14, -136
.cfi_offset b15, -144
mov	x20, x1
mov	x19, x0
LFQH_Lloh250:
adr x1, LFQH_l_.str.23
LFQH_Lloh251:
nop
bl	LFQH_Kind
cbz	w0, LFQH_LBB19_2
LFQH_Lloh252:
adr x1, LFQH_BusyKey
LFQH_Lloh253:
nop
mov	x0, x19
bl Lpatch + (0xa628 - PATCH_BASE)
cbz	x0, LFQH_LBB19_3
LFQH_LBB19_2:
ldp	x29, x30, [sp, #208]
ldp	x20, x19, [sp, #192]
ldp	x22, x21, [sp, #176]
ldp	x24, x23, [sp, #160]
ldp	x26, x25, [sp, #144]
ldp	d9, d8, [sp, #128]
ldp	d11, d10, [sp, #112]
ldp	d13, d12, [sp, #96]
ldp	d15, d14, [sp, #80]
add	sp, sp, #224
ret
LFQH_LBB19_3:
LFQH_Lloh254:
adr x1, LFQH_BusyKey
LFQH_Lloh255:
nop
mov	x0, x19
mov	x2, x19
mov	x3, #0
bl Lpatch + (0xa634 - PATCH_BASE)
LFQH_Lloh256:
adr x1, LFQH_IconGlassKey
LFQH_Lloh257:
nop
mov	x0, x19
bl Lpatch + (0xa628 - PATCH_BASE)
mov	x21, x0
LFQH_Lloh258:
adr x0, LFQH_l_.str.24
LFQH_Lloh259:
nop
bl Lpatch + (0xa5a4 - PATCH_BASE)
mov	x1, x0
mov	x0, x19
bl Lpatch + (0xa5d4 - PATCH_BASE)
mov.16b	v12, v0
mov.16b	v14, v1
mov.16b	v13, v2
mov.16b	v15, v3
bl	LFQH_Enabled
cbz	w0, LFQH_LBB19_6
LFQH_Lloh260:
adr x0, LFQH_l_.str.28
LFQH_Lloh261:
nop
bl Lpatch + (0xa5b0 - PATCH_BASE)
LFQH_Lloh262:
adr x1, LFQH_l_.str.29
LFQH_Lloh263:
nop
bl	LFQH_Responds
cbz	w0, LFQH_LBB19_6
fmov	x8, d12
ubfx	x8, x8, #52, #11
fmov	x9, d14
ubfx	x9, x9, #52, #11
fmov	x10, d13
ubfx	x10, x10, #52, #11
cmp	x10, #2046
mov	w10, #2046
ccmp	x9, x10, #2, ls
ccmp	x8, x10, #2, ls
b.ls	LFQH_LBB19_8
LFQH_LBB19_6:
mov	x0, x19
mov	x1, x21
bl	LFQH_RestoreIcon
LFQH_LBB19_7:
LFQH_Lloh264:
adr x1, LFQH_BusyKey
LFQH_Lloh265:
nop
mov	x0, x19
mov	x2, #0
mov	x3, #0
ldp	x29, x30, [sp, #208]
ldp	x20, x19, [sp, #192]
ldp	x22, x21, [sp, #176]
ldp	x24, x23, [sp, #160]
ldp	x26, x25, [sp, #144]
ldp	d9, d8, [sp, #128]
ldp	d11, d10, [sp, #112]
ldp	d13, d12, [sp, #96]
ldp	d15, d14, [sp, #80]
add	sp, sp, #224
b Lpatch + (0xa634 - PATCH_BASE)
LFQH_LBB19_8:
fmov	x8, d15
ubfx	x8, x8, #52, #11
cmp	x8, #2046
b.hi	LFQH_LBB19_6
fcmp	d13, #0.0
b.le	LFQH_LBB19_6
fcmp	d15, #0.0
b.le	LFQH_LBB19_6
LFQH_Lloh266:
adr x1, LFQH_l_.str.203
LFQH_Lloh267:
nop
mov	x0, x19
bl	LFQH_Kind
cbz	w0, LFQH_LBB19_17
LFQH_Lloh268:
adr x1, LFQH_l_.str.204
LFQH_Lloh269:
nop
mov	x0, x19
bl	LFQH_Get
mov	x22, x0
cbz	x0, LFQH_LBB19_18
mov	w24, #0
LFQH_Lloh270:
adr x23, LFQH_l_.str.20
LFQH_Lloh271:
nop
mov	x0, x22
mov	w26, #1
LFQH_LBB19_14:
cmp	x0, x19
b.eq	LFQH_LBB19_19
mov	x1, x23
bl	LFQH_Get
cbz	x0, LFQH_LBB19_21
cmp	w24, #7
add	w24, w24, #1
b.lo	LFQH_LBB19_14
b	LFQH_LBB19_21
LFQH_LBB19_17:
mov	w26, #0
mov	x22, #0
b	LFQH_LBB19_21
LFQH_LBB19_18:
mov	w26, #0
b	LFQH_LBB19_21
LFQH_LBB19_19:
LFQH_Lloh272:
adr x0, LFQH_l_.str.205
LFQH_Lloh273:
nop
bl Lpatch + (0xa5a4 - PATCH_BASE)
mov	x1, x0
mov	x0, x22
bl Lpatch + (0xa5d4 - PATCH_BASE)
cbz	w0, LFQH_LBB19_57
LFQH_LBB19_20:
mov	w26, #1
LFQH_LBB19_21:
mov.16b	v8, v12
mov.16b	v9, v14
mov.16b	v10, v13
mov.16b	v11, v15
LFQH_LBB19_22:
LFQH_Lloh274:
adr x24, LFQH_l_.str.156
LFQH_Lloh275:
nop
mov	x0, x24
bl Lpatch + (0xa5b0 - PATCH_BASE)
mov	x23, x0
LFQH_Lloh276:
adr x25, LFQH_l_.str.157
LFQH_Lloh277:
nop
mov	x0, x25
bl Lpatch + (0xa5a4 - PATCH_BASE)
mov	x1, x0
mov	x0, x23
mov	x2, x20
bl Lpatch + (0xa5d4 - PATCH_BASE)
LFQH_Lloh278:
adr x1, LFQH_l_.str.33
LFQH_Lloh279:
nop
bl	LFQH_Equal
mov	x23, x0
mov	x0, x24
bl Lpatch + (0xa5b0 - PATCH_BASE)
mov	x24, x0
mov	x0, x25
bl Lpatch + (0xa5a4 - PATCH_BASE)
mov	x1, x0
mov	x0, x24
mov	x2, x20
bl Lpatch + (0xa5d4 - PATCH_BASE)
LFQH_Lloh280:
adr x1, LFQH_l_.str.42
LFQH_Lloh281:
nop
bl	LFQH_Equal
tbz	w0, #0, LFQH_LBB19_24
mov	w24, #1
b	LFQH_LBB19_25
LFQH_LBB19_24:
LFQH_Lloh282:
adr x0, LFQH_l_.str.156
LFQH_Lloh283:
nop
bl Lpatch + (0xa5b0 - PATCH_BASE)
mov	x24, x0
LFQH_Lloh284:
adr x0, LFQH_l_.str.157
LFQH_Lloh285:
nop
bl Lpatch + (0xa5a4 - PATCH_BASE)
mov	x1, x0
mov	x0, x24
mov	x2, x20
bl Lpatch + (0xa5d4 - PATCH_BASE)
LFQH_Lloh286:
adr x1, LFQH_l_.str.43
LFQH_Lloh287:
nop
bl	LFQH_Equal
mov	x24, x0
LFQH_LBB19_25:
orr	w8, w23, w24
tst	w26, w8
b.eq	LFQH_LBB19_43
LFQH_Lloh288:
adr x1, LFQH_GlyphViewKey
LFQH_Lloh289:
nop
mov	x0, x19
bl Lpatch + (0xa628 - PATCH_BASE)
cmp	x0, x22
b.eq	LFQH_LBB19_28
mov	x0, x19
bl	LFQH_RestoreGlyph
LFQH_LBB19_28:
stp	d11, d10, [sp, #32]
LFQH_Lloh290:
adr x0, LFQH_l_.str.172
LFQH_Lloh291:
nop
bl Lpatch + (0xa5a4 - PATCH_BASE)
mov	x1, x0
mov	x0, x22
bl Lpatch + (0xa5d4 - PATCH_BASE)
mov.16b	v10, v0
mov.16b	v11, v1
stp	d3, d2, [sp, #64]
LFQH_Lloh292:
adr x1, LFQH_GlyphOriginalKey
LFQH_Lloh293:
nop
mov	x0, x22
bl Lpatch + (0xa628 - PATCH_BASE)
mov	x25, x0
LFQH_Lloh294:
adr x1, LFQH_GlyphAppliedKey
LFQH_Lloh295:
nop
mov	x0, x22
bl Lpatch + (0xa628 - PATCH_BASE)
cbz	x25, LFQH_LBB19_34
mov	x26, x0
cbz	x0, LFQH_LBB19_34
LFQH_Lloh296:
adr x0, LFQH_l_.str.200
LFQH_Lloh297:
nop
bl Lpatch + (0xa5a4 - PATCH_BASE)
mov	x1, x0
mov	x0, x26
bl Lpatch + (0xa5d4 - PATCH_BASE)
fcmp	d10, d0
b.ne	LFQH_LBB19_34
fcmp	d11, d1
b.ne	LFQH_LBB19_34
ldr	d0, [sp, #72]
fcmp	d0, d2
b.ne	LFQH_LBB19_34
ldr	d0, [sp, #64]
fcmp	d0, d3
b.eq	LFQH_LBB19_35
LFQH_LBB19_34:
mov.16b	v0, v10
mov.16b	v1, v11
ldp	d3, d2, [sp, #64]
bl	LFQH_RectBox
mov	x25, x0
LFQH_Lloh298:
adr x1, LFQH_GlyphOriginalKey
LFQH_Lloh299:
nop
mov	x0, x22
mov	x2, x25
mov	w3, #1
bl Lpatch + (0xa634 - PATCH_BASE)
LFQH_LBB19_35:
stp	d11, d10, [sp, #16]
stp	d9, d8, [sp, #48]
LFQH_Lloh300:
adr x0, LFQH_l_.str.200
LFQH_Lloh301:
nop
bl Lpatch + (0xa5a4 - PATCH_BASE)
mov	x1, x0
mov	x0, x25
bl Lpatch + (0xa5d4 - PATCH_BASE)
mov.16b	v11, v1
mov.16b	v10, v2
cbz	w23, LFQH_LBB19_37
fmov	d1, #0.50000000
fmul	d1, d10, d1
fadd	d8, d0, d1
mov.16b	v9, v3
b	LFQH_LBB19_40
LFQH_LBB19_37:
fmov	d1, #0.75000000
fmul	d2, d10, d1
str	d2, [sp, #8]
fmul	d9, d3, d1
fmov	d1, #0.12500000
fmul	d2, d10, d1
fadd	d8, d0, d2
fmul	d0, d3, d1
fadd	d11, d11, d0
mov	x0, x20
bl	LFQH_Text
LFQH_Lloh302:
adr x1, LFQH_l_.str.42
LFQH_Lloh303:
nop
bl	LFQH_Equal
fmov	d0, #-12.00000000
fadd	d0, d8, d0
cmp	w0, #0
fcsel	d8, d8, d0, eq
mov	x0, x20
bl	LFQH_Text
LFQH_Lloh304:
adr x1, LFQH_l_.str.43
LFQH_Lloh305:
nop
bl	LFQH_Equal
cbz	w0, LFQH_LBB19_39
fmov	d0, #-0.25000000
fmul	d0, d10, d0
fadd	d8, d8, d0
LFQH_LBB19_39:
ldr	d10, [sp, #8]
LFQH_LBB19_40:
ldp	d0, d1, [sp, #16]
fcmp	d1, d8
fccmp	d0, d11, #0, eq
ldp	d0, d1, [sp, #64]
fccmp	d1, d10, #0, eq
fccmp	d0, d9, #0, eq
b.eq	LFQH_LBB19_42
LFQH_Lloh306:
adr x0, LFQH_l_.str.173
LFQH_Lloh307:
nop
bl Lpatch + (0xa5a4 - PATCH_BASE)
mov	x1, x0
mov	x0, x22
mov.16b	v0, v8
mov.16b	v1, v11
mov.16b	v2, v10
mov.16b	v3, v9
bl Lpatch + (0xa5d4 - PATCH_BASE)
LFQH_LBB19_42:
LFQH_Lloh308:
adr x0, LFQH_l_.str.201
LFQH_Lloh309:
nop
bl Lpatch + (0xa5b0 - PATCH_BASE)
mov	x25, x0
LFQH_Lloh310:
adr x0, LFQH_l_.str.202
LFQH_Lloh311:
nop
bl Lpatch + (0xa5a4 - PATCH_BASE)
mov	x1, x0
mov	x0, x25
mov.16b	v0, v8
mov.16b	v1, v11
mov.16b	v2, v10
mov.16b	v3, v9
bl Lpatch + (0xa5d4 - PATCH_BASE)
mov	x2, x0
LFQH_Lloh312:
adr x1, LFQH_GlyphAppliedKey
LFQH_Lloh313:
nop
mov	x0, x22
mov	w3, #1
bl Lpatch + (0xa634 - PATCH_BASE)
LFQH_Lloh314:
adr x1, LFQH_GlyphViewKey
LFQH_Lloh315:
nop
mov	x0, x19
mov	x2, x22
mov	w3, #1
bl Lpatch + (0xa634 - PATCH_BASE)
ldp	d9, d8, [sp, #48]
ldp	d11, d10, [sp, #32]
LFQH_LBB19_43:
LFQH_Lloh316:
adr x0, LFQH_l_.str.156
LFQH_Lloh317:
nop
bl Lpatch + (0xa5b0 - PATCH_BASE)
mov	x22, x0
LFQH_Lloh318:
adr x0, LFQH_l_.str.157
LFQH_Lloh319:
nop
bl Lpatch + (0xa5a4 - PATCH_BASE)
mov	x1, x0
mov	x0, x22
mov	x2, x20
bl Lpatch + (0xa5d4 - PATCH_BASE)
LFQH_Lloh320:
adr x1, LFQH_l_.str.42
LFQH_Lloh321:
nop
bl	LFQH_Equal
mov	x22, x0
mov	x0, x19
bl	LFQH_CanExpandHit
tbz	w0, #0, LFQH_LBB19_6
fmov	d0, #0.50000000
fmul	d1, d15, d0
fadd	d1, d14, d1
cmp	w24, #0
mov	x8, #4630263366890291200
fmov	d2, x8
fmov	d3, #28.00000000
fcsel	d14, d3, d2, ne
fmul	d2, d14, d0
fsub	d15, d1, d2
fmov	x8, d15
fmul	d0, d13, d0
fadd	d0, d12, d0
cmp	w23, #0
fmov	d1, xzr
fmov	d3, #6.00000000
fcsel	d3, d3, d1, ne
fadd	d0, d0, d3
cmp	w22, #0
fmov	d3, #12.00000000
fcsel	d1, d1, d3, eq
fsub	d0, d0, d1
fsub	d12, d0, d2
fmov	x9, d12
ubfx	x8, x8, #52, #11
cmp	x8, #2046
cset	w8, hi
ubfx	x9, x9, #52, #11
cmp	x9, #2046
ccmp	w8, #0, #0, ls
b.ne	LFQH_LBB19_6
cbz	x21, LFQH_LBB19_54
LFQH_LBB19_46:
LFQH_Lloh322:
adr x0, LFQH_l_.str.169
LFQH_Lloh323:
nop
bl Lpatch + (0xa5b0 - PATCH_BASE)
mov	x22, x0
LFQH_Lloh324:
adr x0, LFQH_l_.str.170
LFQH_Lloh325:
nop
bl Lpatch + (0xa5a4 - PATCH_BASE)
mov	x1, x0
mov	x0, x22
bl Lpatch + (0xa5d4 - PATCH_BASE)
LFQH_Lloh326:
adr x0, LFQH_l_.str.171
LFQH_Lloh327:
nop
bl Lpatch + (0xa5a4 - PATCH_BASE)
mov	x1, x0
mov	x0, x22
mov	w2, #1
bl Lpatch + (0xa5d4 - PATCH_BASE)
mov	x0, x19
bl	LFQH_PrepareOwner
LFQH_Lloh328:
adr x1, LFQH_IconRectKey
LFQH_Lloh329:
nop
mov	x0, x19
bl Lpatch + (0xa628 - PATCH_BASE)
cbz	x0, LFQH_LBB19_48
mov	x23, x0
LFQH_Lloh330:
adr x0, LFQH_l_.str.200
LFQH_Lloh331:
nop
bl Lpatch + (0xa5a4 - PATCH_BASE)
mov	x1, x0
mov	x0, x23
bl Lpatch + (0xa5d4 - PATCH_BASE)
fcmp	d0, d12
fccmp	d1, d15, #0, eq
fccmp	d2, d14, #0, eq
fccmp	d3, d14, #0, eq
b.eq	LFQH_LBB19_49
LFQH_LBB19_48:
LFQH_Lloh332:
adr x0, LFQH_l_.str.173
LFQH_Lloh333:
nop
bl Lpatch + (0xa5a4 - PATCH_BASE)
mov	x1, x0
mov	x0, x21
mov.16b	v0, v12
mov.16b	v1, v15
mov.16b	v2, v14
mov.16b	v3, v14
bl Lpatch + (0xa5d4 - PATCH_BASE)
mov.16b	v0, v12
mov.16b	v1, v15
mov.16b	v2, v14
mov.16b	v3, v14
bl	LFQH_RectBox
mov	x2, x0
LFQH_Lloh334:
adr x1, LFQH_IconRectKey
LFQH_Lloh335:
nop
mov	x0, x19
mov	w3, #1
bl Lpatch + (0xa634 - PATCH_BASE)
LFQH_LBB19_49:
LFQH_Lloh336:
adr x0, LFQH_l_.str.20
LFQH_Lloh337:
nop
bl Lpatch + (0xa5a4 - PATCH_BASE)
mov	x1, x0
mov	x0, x21
bl Lpatch + (0xa5d4 - PATCH_BASE)
cmp	x0, x19
b.eq	LFQH_LBB19_51
LFQH_Lloh338:
adr x0, LFQH_l_.str.175
LFQH_Lloh339:
nop
bl Lpatch + (0xa5a4 - PATCH_BASE)
mov	x1, x0
mov	x0, x19
mov	x2, x21
mov	x3, #0
bl Lpatch + (0xa5d4 - PATCH_BASE)
LFQH_LBB19_51:
LFQH_Lloh340:
adr x1, LFQH_l_.str.44
LFQH_Lloh341:
nop
mov	x0, x19
bl	LFQH_Kind
cbz	w0, LFQH_LBB19_53
LFQH_Lloh342:
adr x0, LFQH_l_.str.208
LFQH_Lloh343:
nop
bl Lpatch + (0xa5a4 - PATCH_BASE)
mov	x23, x0
LFQH_Lloh344:
adr x0, LFQH_l_.str.209
LFQH_Lloh345:
nop
bl Lpatch + (0xa5a4 - PATCH_BASE)
mov	x1, x0
mov	x0, x19
bl Lpatch + (0xa5d4 - PATCH_BASE)
mov	x2, x0
mov	x0, x21
mov	x1, x23
bl Lpatch + (0xa5d4 - PATCH_BASE)
LFQH_Lloh346:
adr x0, LFQH_l_.str.210
LFQH_Lloh347:
nop
bl Lpatch + (0xa5a4 - PATCH_BASE)
mov	x23, x0
LFQH_Lloh348:
adr x0, LFQH_l_.str.211
LFQH_Lloh349:
nop
bl Lpatch + (0xa5a4 - PATCH_BASE)
mov	x1, x0
mov	x0, x19
bl Lpatch + (0xa5d4 - PATCH_BASE)
mov	x2, x0
mov	x0, x21
mov	x1, x23
bl Lpatch + (0xa5d4 - PATCH_BASE)
LFQH_Lloh350:
adr x0, LFQH_l_.str.212
LFQH_Lloh351:
nop
bl Lpatch + (0xa5a4 - PATCH_BASE)
mov	x23, x0
LFQH_Lloh352:
adr x0, LFQH_l_.str.213
LFQH_Lloh353:
nop
bl Lpatch + (0xa5a4 - PATCH_BASE)
mov	x1, x0
mov	x0, x19
bl Lpatch + (0xa5d4 - PATCH_BASE)
mov	x2, x0
mov	x0, x21
mov	x1, x23
bl Lpatch + (0xa5d4 - PATCH_BASE)
LFQH_LBB19_53:
mov	x0, x19
mov.16b	v0, v12
mov.16b	v1, v15
mov.16b	v2, v14
mov.16b	v3, v14
bl	LFQH_EnsureHit
LFQH_Lloh354:
adr x0, LFQH_l_.str.176
LFQH_Lloh355:
nop
bl Lpatch + (0xa5a4 - PATCH_BASE)
mov	x1, x0
mov	x0, x22
bl Lpatch + (0xa5d4 - PATCH_BASE)
mov	x0, x19
mov	x1, x21
mov.16b	v0, v8
mov.16b	v1, v9
mov.16b	v2, v10
mov.16b	v3, v11
mov	x2, x20
bl	LFQH_RecordLayout
b	LFQH_LBB19_7
LFQH_LBB19_54:
LFQH_Lloh356:
adr x0, LFQH_l_.str.28
LFQH_Lloh357:
nop
bl Lpatch + (0xa5b0 - PATCH_BASE)
mov	x21, x0
LFQH_Lloh358:
adr x0, LFQH_l_.str.29
LFQH_Lloh359:
nop
bl Lpatch + (0xa5a4 - PATCH_BASE)
mov	x1, x0
mov	x0, x21
bl Lpatch + (0xa5d4 - PATCH_BASE)
cbz	x0, LFQH_LBB19_7
mov	x22, x0
bl	LFQH_GlassClass
mov	x21, x0
LFQH_Lloh360:
adr x0, LFQH_l_.str.206
LFQH_Lloh361:
nop
bl Lpatch + (0xa5a4 - PATCH_BASE)
mov	x1, x0
mov	x0, x21
bl Lpatch + (0xa5d4 - PATCH_BASE)
cbz	x0, LFQH_LBB19_7
mov	x21, x0
LFQH_Lloh362:
adr x0, LFQH_l_.str.207
LFQH_Lloh363:
nop
bl Lpatch + (0xa5a4 - PATCH_BASE)
mov	x1, x0
mov	x0, x21
mov	x2, x22
bl Lpatch + (0xa5d4 - PATCH_BASE)
LFQH_Lloh364:
adr x0, LFQH_l_.str.162
LFQH_Lloh365:
nop
bl Lpatch + (0xa5a4 - PATCH_BASE)
mov	x1, x0
mov	x0, x21
mov	w2, #0
bl Lpatch + (0xa5d4 - PATCH_BASE)
LFQH_Lloh366:
adr x0, LFQH_l_.str.163
LFQH_Lloh367:
nop
bl Lpatch + (0xa5a4 - PATCH_BASE)
mov	x1, x0
mov	x0, x21
mov	w2, #1
bl Lpatch + (0xa5d4 - PATCH_BASE)
LFQH_Lloh368:
adr x0, LFQH_l_.str.164
LFQH_Lloh369:
nop
bl Lpatch + (0xa5a4 - PATCH_BASE)
mov	x1, x0
mov	x0, x21
mov	w2, #0
bl Lpatch + (0xa5d4 - PATCH_BASE)
LFQH_Lloh370:
adr x0, LFQH_l_.str.165
LFQH_Lloh371:
nop
bl Lpatch + (0xa5a4 - PATCH_BASE)
mov	x1, x0
mov	x0, x21
mov	w2, #0
bl Lpatch + (0xa5d4 - PATCH_BASE)
LFQH_Lloh372:
adr x0, LFQH_l_.str.166
LFQH_Lloh373:
nop
bl Lpatch + (0xa5a4 - PATCH_BASE)
mov	x1, x0
mov	x0, x21
mov	x2, #0
bl Lpatch + (0xa5d4 - PATCH_BASE)
LFQH_Lloh374:
adr x1, LFQH_IconGlassKey
LFQH_Lloh375:
nop
mov	x0, x19
mov	x2, x21
mov	w3, #1
bl Lpatch + (0xa634 - PATCH_BASE)
LFQH_Lloh376:
adr x0, LFQH_l_.str.58
LFQH_Lloh377:
nop
bl Lpatch + (0xa5a4 - PATCH_BASE)
mov	x1, x0
mov	x0, x21
bl Lpatch + (0xa5d4 - PATCH_BASE)
mov	x0, x19
mov	x1, x21
mov	w2, #1
bl	LFQH_ObservePress
b	LFQH_LBB19_46
LFQH_LBB19_57:
LFQH_Lloh378:
adr x0, LFQH_l_.str.24
LFQH_Lloh379:
nop
bl Lpatch + (0xa5a4 - PATCH_BASE)
mov	x1, x0
mov	x0, x22
bl Lpatch + (0xa5d4 - PATCH_BASE)
bl	LFQH_VisibleRect
cbz	w0, LFQH_LBB19_20
LFQH_Lloh380:
adr x0, LFQH_l_.str.24
LFQH_Lloh381:
nop
bl Lpatch + (0xa5a4 - PATCH_BASE)
mov	x1, x0
mov	x0, x22
bl Lpatch + (0xa5d4 - PATCH_BASE)
mov.16b	v8, v0
mov.16b	v9, v1
mov.16b	v10, v2
mov.16b	v11, v3
LFQH_Lloh382:
adr x0, LFQH_l_.str.216
LFQH_Lloh383:
nop
bl Lpatch + (0xa5a4 - PATCH_BASE)
mov	x1, x0
mov	x0, x22
mov.16b	v0, v8
mov.16b	v1, v9
mov.16b	v2, v10
mov.16b	v3, v11
mov	x2, x19
bl Lpatch + (0xa5d4 - PATCH_BASE)
mov.16b	v8, v0
mov.16b	v9, v1
mov.16b	v10, v2
mov.16b	v11, v3
bl	LFQH_VisibleRect
cbz	w0, LFQH_LBB19_20
mov	w26, #1
b	LFQH_LBB19_22
.cfi_endproc
.p2align	2
LFQH_FQHReaderCount:
.cfi_startproc
stp	x20, x19, [sp, #-32]!
stp	x29, x30, [sp, #16]
add	x29, sp, #16
.cfi_def_cfa w29, 16
.cfi_offset w30, -8
.cfi_offset w29, -16
.cfi_offset w19, -24
.cfi_offset w20, -32
LFQH_Lloh384:
adr x1, LFQH_ReaderGlassKey
LFQH_Lloh385:
nop
bl Lpatch + (0xa628 - PATCH_BASE)
mov	x19, x0
LFQH_Lloh386:
adr x0, LFQH_l_.str.31
LFQH_Lloh387:
nop
bl Lpatch + (0xa5a4 - PATCH_BASE)
mov	x1, x0
mov	x0, x19
ldp	x29, x30, [sp, #16]
ldp	x20, x19, [sp], #32
b Lpatch + (0xa5d4 - PATCH_BASE)
.cfi_endproc
.p2align	2
LFQH_ReaderGlassKey:
.cfi_startproc
ret
.cfi_endproc
.p2align	2
LFQH_FQHReader:
.cfi_startproc
sub	sp, sp, #128
stp	x28, x27, [sp, #32]
stp	x26, x25, [sp, #48]
stp	x24, x23, [sp, #64]
stp	x22, x21, [sp, #80]
stp	x20, x19, [sp, #96]
stp	x29, x30, [sp, #112]
add	x29, sp, #112
.cfi_def_cfa w29, 16
.cfi_offset w30, -8
.cfi_offset w29, -16
.cfi_offset w19, -24
.cfi_offset w20, -32
.cfi_offset w21, -40
.cfi_offset w22, -48
.cfi_offset w23, -56
.cfi_offset w24, -64
.cfi_offset w25, -72
.cfi_offset w26, -80
.cfi_offset w27, -88
.cfi_offset w28, -96
mov	x19, x0
LFQH_Lloh388:
adr x1, LFQH_OwnerBusyKey
LFQH_Lloh389:
nop
bl Lpatch + (0xa628 - PATCH_BASE)
cbnz	x0, LFQH_LBB22_31
LFQH_Lloh390:
adr x1, LFQH_OwnerBusyKey
LFQH_Lloh391:
nop
mov	x0, x19
mov	x2, x19
mov	x3, #0
bl Lpatch + (0xa634 - PATCH_BASE)
LFQH_Lloh392:
adr x0, LFQH_l_.str.24
LFQH_Lloh393:
nop
bl Lpatch + (0xa5a4 - PATCH_BASE)
mov	x1, x0
mov	x0, x19
bl Lpatch + (0xa5d4 - PATCH_BASE)
stp	d0, d1, [sp]
stp	d2, d3, [sp, #16]
LFQH_Lloh394:
adr x1, LFQH_l_.str.32
LFQH_Lloh395:
nop
mov	x0, x19
bl	LFQH_Get
cbz	x0, LFQH_LBB22_6
mov	x21, x0
mov	w23, #0
LFQH_Lloh396:
adr x22, LFQH_l_.str.20
LFQH_Lloh397:
nop
LFQH_LBB22_3:
cmp	x0, x19
b.eq	LFQH_LBB22_7
mov	x1, x22
bl	LFQH_Get
mov	x20, #0
cbz	x0, LFQH_LBB22_8
cmp	w23, #7
add	w23, w23, #1
b.lo	LFQH_LBB22_3
b	LFQH_LBB22_8
LFQH_LBB22_6:
mov	x20, #0
b	LFQH_LBB22_8
LFQH_LBB22_7:
LFQH_Lloh398:
adr x1, LFQH_l_.str.33
LFQH_Lloh399:
nop
mov	x0, x21
bl	LFQH_Icon
mov	x2, sp
mov	x0, x21
mov	x1, x19
bl	LFQH_IncludeGlass
LFQH_Lloh400:
adr x1, LFQH_IconGlassKey
LFQH_Lloh401:
nop
mov	x0, x21
bl Lpatch + (0xa628 - PATCH_BASE)
cmp	x0, #0
cset	w20, ne
LFQH_LBB22_8:
LFQH_Lloh402:
adr x1, LFQH_l_.str.34
LFQH_Lloh403:
nop
mov	x0, x19
bl	LFQH_Get
mov	x21, x0
LFQH_Lloh404:
adr x1, LFQH_l_.str.35
LFQH_Lloh405:
nop
bl	LFQH_Kind
cbz	w0, LFQH_LBB22_22
LFQH_Lloh406:
adr x0, LFQH_l_.str.36
LFQH_Lloh407:
nop
bl Lpatch + (0xa5a4 - PATCH_BASE)
mov	x1, x0
mov	x0, x21
bl Lpatch + (0xa5d4 - PATCH_BASE)
cmp	x0, #16
mov	w8, #16
csel	x23, x0, x8, lo
cbz	x0, LFQH_LBB22_22
mov	x22, #0
LFQH_Lloh408:
adr x28, LFQH_l_.str.37
LFQH_Lloh409:
nop
LFQH_Lloh410:
adr x26, LFQH_l_.str.20
LFQH_Lloh411:
nop
LFQH_LBB22_11:
LFQH_Lloh412:
adr x0, LFQH_l_.str.229
LFQH_Lloh413:
nop
bl Lpatch + (0xa5a4 - PATCH_BASE)
mov	x1, x0
mov	x0, x21
mov	x2, x22
bl Lpatch + (0xa5d4 - PATCH_BASE)
mov	x25, x0
LFQH_Lloh414:
adr x1, LFQH_l_.str.230
LFQH_Lloh415:
nop
bl	LFQH_Kind
LFQH_Lloh416:
adr x27, LFQH_l_.str.231
LFQH_Lloh417:
nop
tbnz	w0, #0, LFQH_LBB22_15
mov	x0, x25
LFQH_Lloh418:
adr x1, LFQH_l_.str.232
LFQH_Lloh419:
nop
bl	LFQH_Kind
LFQH_Lloh420:
adr x27, LFQH_l_.str.233
LFQH_Lloh421:
nop
tbnz	w0, #0, LFQH_LBB22_15
mov	x0, x25
LFQH_Lloh422:
adr x1, LFQH_l_.str.234
LFQH_Lloh423:
nop
bl	LFQH_Kind
LFQH_Lloh424:
adr x27, LFQH_l_.str.235
LFQH_Lloh425:
nop
tbnz	w0, #0, LFQH_LBB22_15
mov	x0, x25
LFQH_Lloh426:
adr x1, LFQH_l_.str.236
LFQH_Lloh427:
nop
bl	LFQH_Kind
LFQH_Lloh428:
adr x27, LFQH_l_.str.237
LFQH_Lloh429:
nop
cbz	w0, LFQH_LBB22_21
LFQH_LBB22_15:
mov	x0, x25
mov	x1, x28
bl	LFQH_Get
cbz	x0, LFQH_LBB22_21
mov	x25, x0
mov	w24, #0
LFQH_LBB22_17:
cmp	x0, x19
b.eq	LFQH_LBB22_20
mov	x1, x26
bl	LFQH_Get
cbz	x0, LFQH_LBB22_21
cmp	w24, #7
add	w24, w24, #1
b.lo	LFQH_LBB22_17
b	LFQH_LBB22_21
LFQH_LBB22_20:
mov	x0, x25
mov	x1, x27
bl	LFQH_Icon
mov	x2, sp
mov	x0, x25
mov	x1, x19
bl	LFQH_IncludeGlass
mov	x0, x25
LFQH_Lloh430:
adr x1, LFQH_IconGlassKey
LFQH_Lloh431:
nop
bl Lpatch + (0xa628 - PATCH_BASE)
cmp	x0, #0
cinc	x20, x20, ne
LFQH_LBB22_21:
add	x22, x22, #1
cmp	x22, x23
b.ne	LFQH_LBB22_11
LFQH_LBB22_22:
cbz	x20, LFQH_LBB22_24
ldp	d0, d1, [sp]
ldp	d2, d3, [sp, #16]
mov	x0, x19
bl	LFQH_EnsureHit
b	LFQH_LBB22_25
LFQH_LBB22_24:
mov	x0, x19
bl	LFQH_RestoreHit
LFQH_LBB22_25:
LFQH_Lloh432:
adr x1, LFQH_ReaderGlassKey
LFQH_Lloh433:
nop
mov	x0, x19
bl Lpatch + (0xa628 - PATCH_BASE)
mov	x21, x0
LFQH_Lloh434:
adr x0, LFQH_l_.str.31
LFQH_Lloh435:
nop
bl Lpatch + (0xa5a4 - PATCH_BASE)
mov	x1, x0
mov	x0, x21
bl Lpatch + (0xa5d4 - PATCH_BASE)
cmp	x20, x0
b.eq	LFQH_LBB22_30
cbz	x20, LFQH_LBB22_28
LFQH_Lloh436:
adr x0, LFQH_l_.str.182
LFQH_Lloh437:
nop
bl Lpatch + (0xa5b0 - PATCH_BASE)
mov	x21, x0
LFQH_Lloh438:
adr x0, LFQH_l_.str.238
LFQH_Lloh439:
nop
bl Lpatch + (0xa5a4 - PATCH_BASE)
mov	x1, x0
mov	x0, x21
mov	x2, x20
bl Lpatch + (0xa5d4 - PATCH_BASE)
mov	x2, x0
b	LFQH_LBB22_29
LFQH_LBB22_28:
mov	x2, #0
LFQH_LBB22_29:
LFQH_Lloh440:
adr x1, LFQH_ReaderGlassKey
LFQH_Lloh441:
nop
mov	x0, x19
mov	w3, #1
bl Lpatch + (0xa634 - PATCH_BASE)
LFQH_LBB22_30:
LFQH_Lloh442:
adr x1, LFQH_OwnerBusyKey
LFQH_Lloh443:
nop
mov	x0, x19
mov	x2, #0
mov	x3, #0
bl Lpatch + (0xa634 - PATCH_BASE)
LFQH_LBB22_31:
ldp	x29, x30, [sp, #112]
ldp	x20, x19, [sp, #96]
ldp	x22, x21, [sp, #80]
ldp	x24, x23, [sp, #64]
ldp	x26, x25, [sp, #48]
ldp	x28, x27, [sp, #32]
add	sp, sp, #128
ret
.cfi_endproc
.p2align	2
LFQH_OwnerBusyKey:
.cfi_startproc
ret
.cfi_endproc
.p2align	2
LFQH_IncludeGlass:
.cfi_startproc
stp	d11, d10, [sp, #-96]!
stp	d9, d8, [sp, #16]
stp	x24, x23, [sp, #32]
stp	x22, x21, [sp, #48]
stp	x20, x19, [sp, #64]
stp	x29, x30, [sp, #80]
add	x29, sp, #80
.cfi_def_cfa w29, 16
.cfi_offset w30, -8
.cfi_offset w29, -16
.cfi_offset w19, -24
.cfi_offset w20, -32
.cfi_offset w21, -40
.cfi_offset w22, -48
.cfi_offset w23, -56
.cfi_offset w24, -64
.cfi_offset b8, -72
.cfi_offset b9, -80
.cfi_offset b10, -88
.cfi_offset b11, -96
mov	x19, x2
mov	x20, x1
mov	x21, x0
LFQH_Lloh444:
adr x1, LFQH_IconGlassKey
LFQH_Lloh445:
nop
bl Lpatch + (0xa628 - PATCH_BASE)
cbz	x21, LFQH_LBB24_15
mov	x22, x0
cbz	x0, LFQH_LBB24_15
mov	w24, #0
LFQH_Lloh446:
adr x23, LFQH_l_.str.20
LFQH_Lloh447:
nop
mov	x0, x21
LFQH_LBB24_3:
cmp	x0, x20
b.eq	LFQH_LBB24_6
mov	x1, x23
bl	LFQH_Get
cbz	x0, LFQH_LBB24_15
cmp	w24, #7
add	w24, w24, #1
b.lo	LFQH_LBB24_3
b	LFQH_LBB24_15
LFQH_LBB24_6:
LFQH_Lloh448:
adr x0, LFQH_l_.str.172
LFQH_Lloh449:
nop
bl Lpatch + (0xa5a4 - PATCH_BASE)
mov	x1, x0
mov	x0, x22
bl Lpatch + (0xa5d4 - PATCH_BASE)
mov.16b	v8, v0
mov.16b	v9, v1
mov.16b	v10, v2
mov.16b	v11, v3
LFQH_Lloh450:
adr x0, LFQH_l_.str.216
LFQH_Lloh451:
nop
bl Lpatch + (0xa5a4 - PATCH_BASE)
mov	x1, x0
mov	x0, x21
mov.16b	v0, v8
mov.16b	v1, v9
mov.16b	v2, v10
mov.16b	v3, v11
mov	x2, x20
bl Lpatch + (0xa5d4 - PATCH_BASE)
fmov	x8, d2
fmov	x9, d1
fmov	x10, d0
ubfx	x10, x10, #52, #11
ubfx	x9, x9, #52, #11
ubfx	x8, x8, #52, #11
cmp	x8, #2046
mov	w8, #2046
ccmp	x9, x8, #2, ls
ccmp	x10, x8, #2, ls
b.hi	LFQH_LBB24_15
fmov	x8, d3
ubfx	x8, x8, #52, #11
cmp	x8, #2046
b.hi	LFQH_LBB24_15
fcmp	d2, #0.0
b.le	LFQH_LBB24_15
fcmp	d3, #0.0
b.le	LFQH_LBB24_15
ldp	d6, d4, [x19]
ldp	d7, d16, [x19, #16]
fcmp	d0, d6
mov.16b	v5, v6
b.pl	LFQH_LBB24_12
str	d0, [x19]
mov.16b	v5, v0
LFQH_LBB24_12:
fadd	d7, d6, d7
fadd	d6, d4, d16
fcmp	d1, d4
b.pl	LFQH_LBB24_14
str	d1, [x19, #8]
mov.16b	v4, v1
LFQH_LBB24_14:
fadd	d0, d0, d2
fcmp	d0, d7
fcsel	d0, d0, d7, gt
fadd	d1, d1, d3
fcmp	d1, d6
fcsel	d1, d1, d6, gt
fsub	d0, d0, d5
fsub	d1, d1, d4
stp	d0, d1, [x19, #16]
LFQH_LBB24_15:
ldp	x29, x30, [sp, #80]
ldp	x20, x19, [sp, #64]
ldp	x22, x21, [sp, #48]
ldp	x24, x23, [sp, #32]
ldp	d9, d8, [sp, #16]
ldp	d11, d10, [sp], #96
ret
.cfi_endproc
.p2align	2
LFQH_EnsureHit:
.cfi_startproc
sub	sp, sp, #144
stp	d15, d14, [sp, #32]
stp	d13, d12, [sp, #48]
stp	d11, d10, [sp, #64]
stp	d9, d8, [sp, #80]
stp	x22, x21, [sp, #96]
stp	x20, x19, [sp, #112]
stp	x29, x30, [sp, #128]
add	x29, sp, #128
.cfi_def_cfa w29, 16
.cfi_offset w30, -8
.cfi_offset w29, -16
.cfi_offset w19, -24
.cfi_offset w20, -32
.cfi_offset w21, -40
.cfi_offset w22, -48
.cfi_offset b8, -56
.cfi_offset b9, -64
.cfi_offset b10, -72
.cfi_offset b11, -80
.cfi_offset b12, -88
.cfi_offset b13, -96
.cfi_offset b14, -104
.cfi_offset b15, -112
stp	d3, d2, [sp, #16]
mov.16b	v11, v1
mov.16b	v10, v0
mov	x19, x0
bl	LFQH_CanExpandHit
cbz	w0, LFQH_LBB25_2
LFQH_Lloh452:
adr x0, LFQH_l_.str.24
LFQH_Lloh453:
nop
bl Lpatch + (0xa5a4 - PATCH_BASE)
mov	x1, x0
mov	x0, x19
bl Lpatch + (0xa5d4 - PATCH_BASE)
mov.16b	v12, v0
mov.16b	v8, v1
mov.16b	v13, v2
mov.16b	v9, v3
fmov	x20, d13
fmov	x21, d8
fmov	x22, d12
LFQH_Lloh454:
adr x0, LFQH_l_.str.217
LFQH_Lloh455:
nop
bl Lpatch + (0xa5a4 - PATCH_BASE)
mov	x1, x0
mov	x0, x19
bl Lpatch + (0xa5d4 - PATCH_BASE)
ubfx	x8, x22, #52, #11
ubfx	x9, x21, #52, #11
ubfx	x10, x20, #52, #11
cmp	x10, #2046
mov	w10, #2046
ccmp	x9, x10, #2, ls
ccmp	x8, x10, #2, ls
b.ls	LFQH_LBB25_3
LFQH_LBB25_2:
ldp	x29, x30, [sp, #128]
ldp	x20, x19, [sp, #112]
ldp	x22, x21, [sp, #96]
ldp	d9, d8, [sp, #80]
ldp	d11, d10, [sp, #64]
ldp	d13, d12, [sp, #48]
ldp	d15, d14, [sp, #32]
add	sp, sp, #144
ret
LFQH_LBB25_3:
fmov	x8, d9
ubfx	x8, x8, #52, #11
cmp	x8, #2046
b.hi	LFQH_LBB25_2
fcmp	d13, #0.0
b.le	LFQH_LBB25_2
fcmp	d9, #0.0
b.le	LFQH_LBB25_2
mov.16b	v14, v0
mov.16b	v15, v1
fmov	x8, d3
fmov	x9, d2
fmov	x10, d15
fmov	x11, d14
ubfx	x11, x11, #52, #11
ubfx	x10, x10, #52, #11
ubfx	x9, x9, #52, #11
ubfx	x8, x8, #52, #11
cmp	x8, #2046
mov	w8, #2046
ccmp	x9, x8, #2, ls
ccmp	x10, x8, #2, ls
ccmp	x11, x8, #2, ls
b.hi	LFQH_LBB25_2
stp	d3, d2, [sp]
LFQH_Lloh456:
adr x1, LFQH_HitInsetsKey
LFQH_Lloh457:
nop
mov	x0, x19
bl Lpatch + (0xa628 - PATCH_BASE)
mov	x21, x0
LFQH_Lloh458:
adr x1, LFQH_AppliedHitInsetsKey
LFQH_Lloh459:
nop
mov	x0, x19
bl Lpatch + (0xa628 - PATCH_BASE)
mov	x20, x0
cbz	x21, LFQH_LBB25_13
cbz	x20, LFQH_LBB25_13
LFQH_Lloh460:
adr x0, LFQH_l_.str.200
LFQH_Lloh461:
nop
bl Lpatch + (0xa5a4 - PATCH_BASE)
mov	x1, x0
mov	x0, x20
bl Lpatch + (0xa5d4 - PATCH_BASE)
fcmp	d14, d0
b.ne	LFQH_LBB25_13
fcmp	d15, d1
b.ne	LFQH_LBB25_13
ldr	d0, [sp, #8]
fcmp	d0, d2
b.ne	LFQH_LBB25_13
ldr	d0, [sp]
fcmp	d0, d3
b.eq	LFQH_LBB25_14
LFQH_LBB25_13:
LFQH_Lloh462:
adr x0, LFQH_l_.str.201
LFQH_Lloh463:
nop
bl Lpatch + (0xa5b0 - PATCH_BASE)
mov	x21, x0
LFQH_Lloh464:
adr x0, LFQH_l_.str.202
LFQH_Lloh465:
nop
bl Lpatch + (0xa5a4 - PATCH_BASE)
mov	x1, x0
mov	x0, x21
mov.16b	v0, v14
mov.16b	v1, v15
ldp	d3, d2, [sp]
bl Lpatch + (0xa5d4 - PATCH_BASE)
mov	x21, x0
LFQH_Lloh466:
adr x1, LFQH_HitInsetsKey
LFQH_Lloh467:
nop
mov	x0, x19
mov	x2, x21
mov	w3, #1
bl Lpatch + (0xa634 - PATCH_BASE)
LFQH_LBB25_14:
LFQH_Lloh468:
adr x0, LFQH_l_.str.200
LFQH_Lloh469:
nop
bl Lpatch + (0xa5a4 - PATCH_BASE)
mov	x1, x0
mov	x0, x21
bl Lpatch + (0xa5d4 - PATCH_BASE)
fsub	d4, d11, d8
fsub	d5, d10, d12
fadd	d6, d8, d9
fsub	d6, d6, d11
ldp	d7, d16, [sp, #16]
fsub	d6, d6, d7
fadd	d7, d12, d13
fsub	d7, d7, d10
fsub	d7, d7, d16
fcmp	d4, d0
fcsel	d8, d4, d0, mi
fcmp	d5, d1
fcsel	d9, d5, d1, mi
fcmp	d6, d2
fcsel	d10, d6, d2, mi
fcmp	d7, d3
fcsel	d11, d7, d3, mi
fcmp	d14, d8
fccmp	d15, d9, #0, eq
ldp	d0, d1, [sp]
fccmp	d1, d10, #0, eq
fccmp	d0, d11, #0, eq
b.eq	LFQH_LBB25_16
LFQH_Lloh470:
adr x0, LFQH_l_.str.218
LFQH_Lloh471:
nop
bl Lpatch + (0xa5a4 - PATCH_BASE)
mov	x1, x0
mov	x0, x19
mov.16b	v0, v8
mov.16b	v1, v9
mov.16b	v2, v10
mov.16b	v3, v11
bl Lpatch + (0xa5d4 - PATCH_BASE)
LFQH_LBB25_16:
cbz	x20, LFQH_LBB25_18
LFQH_Lloh472:
adr x0, LFQH_l_.str.200
LFQH_Lloh473:
nop
bl Lpatch + (0xa5a4 - PATCH_BASE)
mov	x1, x0
mov	x0, x20
bl Lpatch + (0xa5d4 - PATCH_BASE)
fcmp	d8, d0
fccmp	d9, d1, #0, eq
fccmp	d10, d2, #0, eq
fccmp	d11, d3, #0, eq
b.eq	LFQH_LBB25_2
LFQH_LBB25_18:
LFQH_Lloh474:
adr x0, LFQH_l_.str.201
LFQH_Lloh475:
nop
bl Lpatch + (0xa5b0 - PATCH_BASE)
mov	x20, x0
LFQH_Lloh476:
adr x0, LFQH_l_.str.202
LFQH_Lloh477:
nop
bl Lpatch + (0xa5a4 - PATCH_BASE)
mov	x1, x0
mov	x0, x20
mov.16b	v0, v8
mov.16b	v1, v9
mov.16b	v2, v10
mov.16b	v3, v11
bl Lpatch + (0xa5d4 - PATCH_BASE)
mov	x2, x0
LFQH_Lloh478:
adr x1, LFQH_AppliedHitInsetsKey
LFQH_Lloh479:
nop
mov	x0, x19
mov	w3, #1
ldp	x29, x30, [sp, #128]
ldp	x20, x19, [sp, #112]
ldp	x22, x21, [sp, #96]
ldp	d9, d8, [sp, #80]
ldp	d11, d10, [sp, #64]
ldp	d13, d12, [sp, #48]
ldp	d15, d14, [sp, #32]
add	sp, sp, #144
b Lpatch + (0xa634 - PATCH_BASE)
.cfi_endproc
.p2align	2
LFQH_RestoreHit:
.cfi_startproc
stp	d11, d10, [sp, #-80]!
stp	d9, d8, [sp, #16]
stp	x22, x21, [sp, #32]
stp	x20, x19, [sp, #48]
stp	x29, x30, [sp, #64]
add	x29, sp, #64
.cfi_def_cfa w29, 16
.cfi_offset w30, -8
.cfi_offset w29, -16
.cfi_offset w19, -24
.cfi_offset w20, -32
.cfi_offset w21, -40
.cfi_offset w22, -48
.cfi_offset b8, -56
.cfi_offset b9, -64
.cfi_offset b10, -72
.cfi_offset b11, -80
mov	x19, x0
LFQH_Lloh480:
adr x1, LFQH_HitInsetsKey
LFQH_Lloh481:
nop
bl Lpatch + (0xa628 - PATCH_BASE)
mov	x20, x0
LFQH_Lloh482:
adr x1, LFQH_AppliedHitInsetsKey
LFQH_Lloh483:
nop
mov	x0, x19
bl Lpatch + (0xa628 - PATCH_BASE)
cmp	x20, #0
ccmp	x0, #0, #4, ne
b.eq	LFQH_LBB26_3
mov	x21, x0
LFQH_Lloh484:
adr x0, LFQH_l_.str.217
LFQH_Lloh485:
nop
bl Lpatch + (0xa5a4 - PATCH_BASE)
mov	x1, x0
mov	x0, x19
bl Lpatch + (0xa5d4 - PATCH_BASE)
mov.16b	v8, v0
mov.16b	v9, v1
mov.16b	v10, v2
mov.16b	v11, v3
LFQH_Lloh486:
adr x0, LFQH_l_.str.200
LFQH_Lloh487:
nop
bl Lpatch + (0xa5a4 - PATCH_BASE)
mov	x1, x0
mov	x0, x21
bl Lpatch + (0xa5d4 - PATCH_BASE)
fcmp	d8, d0
fccmp	d9, d1, #0, eq
fccmp	d10, d2, #0, eq
fccmp	d11, d3, #0, eq
b.ne	LFQH_LBB26_3
LFQH_Lloh488:
adr x0, LFQH_l_.str.200
LFQH_Lloh489:
nop
bl Lpatch + (0xa5a4 - PATCH_BASE)
mov	x1, x0
mov	x0, x20
bl Lpatch + (0xa5d4 - PATCH_BASE)
mov.16b	v8, v0
mov.16b	v9, v1
mov.16b	v10, v2
mov.16b	v11, v3
LFQH_Lloh490:
adr x0, LFQH_l_.str.218
LFQH_Lloh491:
nop
bl Lpatch + (0xa5a4 - PATCH_BASE)
mov	x1, x0
mov	x0, x19
mov.16b	v0, v8
mov.16b	v1, v9
mov.16b	v2, v10
mov.16b	v3, v11
bl Lpatch + (0xa5d4 - PATCH_BASE)
LFQH_LBB26_3:
LFQH_Lloh492:
adr x1, LFQH_HitInsetsKey
LFQH_Lloh493:
nop
mov	x0, x19
mov	x2, #0
mov	w3, #1
bl Lpatch + (0xa634 - PATCH_BASE)
LFQH_Lloh494:
adr x1, LFQH_AppliedHitInsetsKey
LFQH_Lloh495:
nop
mov	x0, x19
mov	x2, #0
mov	w3, #1
ldp	x29, x30, [sp, #64]
ldp	x20, x19, [sp, #48]
ldp	x22, x21, [sp, #32]
ldp	d9, d8, [sp, #16]
ldp	d11, d10, [sp], #80
b Lpatch + (0xa634 - PATCH_BASE)
.cfi_endproc
.p2align	2
LFQH_FQHShelf:
.cfi_startproc
sub	sp, sp, #112
stp	x26, x25, [sp, #32]
stp	x24, x23, [sp, #48]
stp	x22, x21, [sp, #64]
stp	x20, x19, [sp, #80]
stp	x29, x30, [sp, #96]
add	x29, sp, #96
.cfi_def_cfa w29, 16
.cfi_offset w30, -8
.cfi_offset w29, -16
.cfi_offset w19, -24
.cfi_offset w20, -32
.cfi_offset w21, -40
.cfi_offset w22, -48
.cfi_offset w23, -56
.cfi_offset w24, -64
.cfi_offset w25, -72
.cfi_offset w26, -80
mov	x19, x0
LFQH_Lloh496:
adr x1, LFQH_OwnerBusyKey
LFQH_Lloh497:
nop
bl Lpatch + (0xa628 - PATCH_BASE)
cbz	x0, LFQH_LBB27_2
ldp	x29, x30, [sp, #96]
ldp	x20, x19, [sp, #80]
ldp	x22, x21, [sp, #64]
ldp	x24, x23, [sp, #48]
ldp	x26, x25, [sp, #32]
add	sp, sp, #112
ret
LFQH_LBB27_2:
LFQH_Lloh498:
adr x1, LFQH_OwnerBusyKey
LFQH_Lloh499:
nop
mov	x0, x19
mov	x2, x19
mov	x3, #0
bl Lpatch + (0xa634 - PATCH_BASE)
LFQH_Lloh500:
adr x1, LFQH_l_.str.38
LFQH_Lloh501:
nop
mov	x0, x19
bl	LFQH_Get
mov	x22, x0
LFQH_Lloh502:
adr x1, LFQH_l_.str.39
LFQH_Lloh503:
nop
mov	x0, x19
bl	LFQH_Get
mov	x21, x0
LFQH_Lloh504:
adr x1, LFQH_l_.str.40
LFQH_Lloh505:
nop
mov	x0, x19
bl	LFQH_Get
mov	x20, x0
LFQH_Lloh506:
adr x23, LFQH_l_.str.156
LFQH_Lloh507:
nop
mov	x0, x23
bl Lpatch + (0xa5b0 - PATCH_BASE)
mov	x24, x0
LFQH_Lloh508:
adr x25, LFQH_l_.str.157
LFQH_Lloh509:
nop
mov	x0, x25
bl Lpatch + (0xa5a4 - PATCH_BASE)
mov	x1, x0
LFQH_Lloh510:
adr x2, LFQH_l_.str.27
LFQH_Lloh511:
nop
mov	x0, x24
bl Lpatch + (0xa5d4 - PATCH_BASE)
mov	x2, x0
LFQH_Lloh512:
adr x24, LFQH_ShelfRoleKey
LFQH_Lloh513:
nop
mov	x0, x22
mov	x1, x24
mov	w3, #1
bl Lpatch + (0xa634 - PATCH_BASE)
mov	x0, x23
bl Lpatch + (0xa5b0 - PATCH_BASE)
mov	x23, x0
mov	x0, x25
bl Lpatch + (0xa5a4 - PATCH_BASE)
mov	x1, x0
LFQH_Lloh514:
adr x2, LFQH_l_.str.41
LFQH_Lloh515:
nop
mov	x0, x23
bl Lpatch + (0xa5d4 - PATCH_BASE)
mov	x2, x0
mov	x0, x21
mov	x1, x24
mov	w3, #1
bl Lpatch + (0xa634 - PATCH_BASE)
LFQH_Lloh516:
adr x1, LFQH_l_.str.42
LFQH_Lloh517:
nop
mov	x0, x22
bl	LFQH_Icon
LFQH_Lloh518:
adr x1, LFQH_l_.str.43
LFQH_Lloh519:
nop
mov	x0, x21
bl	LFQH_Icon
LFQH_Lloh520:
adr x1, LFQH_l_.str.23
LFQH_Lloh521:
nop
mov	x0, x20
bl	LFQH_Kind
cbz	w0, LFQH_LBB27_6
LFQH_Lloh522:
adr x0, LFQH_l_.str.24
LFQH_Lloh523:
nop
bl Lpatch + (0xa5a4 - PATCH_BASE)
mov	x1, x0
mov	x0, x20
bl Lpatch + (0xa5d4 - PATCH_BASE)
stp	d0, d1, [sp]
stp	d2, d3, [sp, #16]
mov	x2, sp
mov	x0, x22
mov	x1, x20
bl	LFQH_IncludeGlass
mov	x2, sp
mov	x0, x21
mov	x1, x20
bl	LFQH_IncludeGlass
LFQH_Lloh524:
adr x1, LFQH_IconGlassKey
LFQH_Lloh525:
nop
mov	x0, x22
bl Lpatch + (0xa628 - PATCH_BASE)
cbnz	x0, LFQH_LBB27_5
LFQH_Lloh526:
adr x1, LFQH_IconGlassKey
LFQH_Lloh527:
nop
mov	x0, x21
bl Lpatch + (0xa628 - PATCH_BASE)
cbz	x0, LFQH_LBB27_7
LFQH_LBB27_5:
ldp	d0, d1, [sp]
ldp	d2, d3, [sp, #16]
mov	x0, x20
bl	LFQH_EnsureHit
LFQH_LBB27_6:
LFQH_Lloh528:
adr x1, LFQH_OwnerBusyKey
LFQH_Lloh529:
nop
mov	x0, x19
mov	x2, #0
mov	x3, #0
ldp	x29, x30, [sp, #96]
ldp	x20, x19, [sp, #80]
ldp	x22, x21, [sp, #64]
ldp	x24, x23, [sp, #48]
ldp	x26, x25, [sp, #32]
add	sp, sp, #112
b Lpatch + (0xa634 - PATCH_BASE)
LFQH_LBB27_7:
mov	x0, x20
bl	LFQH_RestoreHit
b	LFQH_LBB27_6
.cfi_endproc
.p2align	2
LFQH_ShelfRoleKey:
.cfi_startproc
ret
.cfi_endproc
.p2align	2
LFQH_FQHIsEdit:
.cfi_startproc
stp	x20, x19, [sp, #-32]!
stp	x29, x30, [sp, #16]
add	x29, sp, #16
.cfi_def_cfa w29, 16
.cfi_offset w30, -8
.cfi_offset w29, -16
.cfi_offset w19, -24
.cfi_offset w20, -32
mov	x19, x0
LFQH_Lloh530:
adr x1, LFQH_l_.str.44
LFQH_Lloh531:
nop
bl	LFQH_Kind
cbz	w0, LFQH_LBB29_2
LFQH_Lloh532:
adr x1, LFQH_l_.str.20
LFQH_Lloh533:
nop
mov	x0, x19
bl	LFQH_Get
LFQH_Lloh534:
adr x1, LFQH_l_.str.45
LFQH_Lloh535:
nop
bl	LFQH_Kind
LFQH_LBB29_2:
ldp	x29, x30, [sp, #16]
ldp	x20, x19, [sp], #32
ret
.cfi_endproc
.p2align	2
LFQH_FQHEditRect:
.cfi_startproc
stp	x20, x19, [sp, #-32]!
stp	x29, x30, [sp, #16]
add	x29, sp, #16
.cfi_def_cfa w29, 16
.cfi_offset w30, -8
.cfi_offset w29, -16
.cfi_offset w19, -24
.cfi_offset w20, -32
mov	x19, x0
LFQH_Lloh536:
adr x0, LFQH_l_.str.24
LFQH_Lloh537:
nop
bl Lpatch + (0xa5a4 - PATCH_BASE)
mov	x1, x0
mov	x0, x19
bl Lpatch + (0xa5d4 - PATCH_BASE)
mov	x8, #4630826316843712512
fmov	d4, x8
fcmp	d2, d4
fmov	d4, #24.00000000
fccmp	d3, d4, #4, gt
b.le	LFQH_LBB30_2
fmov	d4, #6.00000000
fadd	d0, d0, d4
fmov	d4, #-12.00000000
fadd	d2, d2, d4
fmov	d4, #4.00000000
fadd	d1, d1, d4
fmov	d4, #-8.00000000
fadd	d3, d3, d4
LFQH_LBB30_2:
ldp	x29, x30, [sp, #16]
ldp	x20, x19, [sp], #32
ret
.cfi_endproc
.p2align	2
LFQH_FQHListen:
.cfi_startproc
stp	x24, x23, [sp, #-64]!
stp	x22, x21, [sp, #16]
stp	x20, x19, [sp, #32]
stp	x29, x30, [sp, #48]
add	x29, sp, #48
.cfi_def_cfa w29, 16
.cfi_offset w30, -8
.cfi_offset w29, -16
.cfi_offset w19, -24
.cfi_offset w20, -32
.cfi_offset w21, -40
.cfi_offset w22, -48
.cfi_offset w23, -56
.cfi_offset w24, -64
mov	x19, x0
LFQH_Lloh538:
adr x1, LFQH_l_.str.46
LFQH_Lloh539:
nop
bl	LFQH_Kind
cbz	w0, LFQH_LBB31_12
mov	x0, x19
mov	w1, #2
bl	LFQH_ListenCaption
mov	x21, x0
LFQH_Lloh540:
adr x1, LFQH_ListenLabelKey
LFQH_Lloh541:
nop
mov	x0, x19
bl Lpatch + (0xa628 - PATCH_BASE)
mov	x22, x0
bl	LFQH_Enabled
cbz	w0, LFQH_LBB31_13
cbz	x21, LFQH_LBB31_13
bl	LFQH_FQHGlassAvailable
tbz	w0, #0, LFQH_LBB31_13
mov	x0, x19
bl	LFQH_FQHApply
LFQH_Lloh542:
adr x1, LFQH_SurfaceKey
LFQH_Lloh543:
nop
mov	x0, x19
bl Lpatch + (0xa628 - PATCH_BASE)
cbz	x0, LFQH_LBB31_12
mov	x20, x0
cmp	x22, x21
b.eq	LFQH_LBB31_9
cbz	x22, LFQH_LBB31_8
LFQH_Lloh544:
adr x0, LFQH_l_.str.47
LFQH_Lloh545:
nop
bl Lpatch + (0xa5a4 - PATCH_BASE)
mov	x23, x0
LFQH_Lloh546:
adr x1, LFQH_ListenColorKey
LFQH_Lloh547:
nop
mov	x0, x19
bl Lpatch + (0xa628 - PATCH_BASE)
mov	x2, x0
mov	x0, x22
mov	x1, x23
bl Lpatch + (0xa5d4 - PATCH_BASE)
LFQH_LBB31_8:
LFQH_Lloh548:
adr x1, LFQH_ListenLabelKey
LFQH_Lloh549:
nop
mov	x0, x19
mov	x2, x21
mov	w3, #1
bl Lpatch + (0xa634 - PATCH_BASE)
LFQH_Lloh550:
adr x1, LFQH_l_.str.48
LFQH_Lloh551:
nop
mov	x0, x21
bl	LFQH_Get
mov	x2, x0
LFQH_Lloh552:
adr x1, LFQH_ListenColorKey
LFQH_Lloh553:
nop
mov	x0, x19
mov	w3, #1
bl Lpatch + (0xa634 - PATCH_BASE)
LFQH_LBB31_9:
LFQH_Lloh554:
adr x0, LFQH_l_.str.49
LFQH_Lloh555:
nop
bl Lpatch + (0xa5b0 - PATCH_BASE)
mov	x22, x0
LFQH_Lloh556:
adr x0, LFQH_l_.str.50
LFQH_Lloh557:
nop
bl Lpatch + (0xa5a4 - PATCH_BASE)
mov	x1, x0
mov	x0, x22
bl Lpatch + (0xa5d4 - PATCH_BASE)
mov	x22, x0
LFQH_Lloh558:
adr x1, LFQH_l_.str.48
LFQH_Lloh559:
nop
mov	x0, x21
bl	LFQH_Get
mov	x23, x0
LFQH_Lloh560:
adr x0, LFQH_l_.str.51
LFQH_Lloh561:
nop
bl Lpatch + (0xa5a4 - PATCH_BASE)
mov	x1, x0
mov	x0, x23
mov	x2, x22
bl Lpatch + (0xa5d4 - PATCH_BASE)
cbnz	w0, LFQH_LBB31_11
LFQH_Lloh562:
adr x0, LFQH_l_.str.47
LFQH_Lloh563:
nop
bl Lpatch + (0xa5a4 - PATCH_BASE)
mov	x1, x0
mov	x0, x21
mov	x2, x22
bl Lpatch + (0xa5d4 - PATCH_BASE)
LFQH_LBB31_11:
LFQH_Lloh564:
adr x1, LFQH_ListenTintKey
LFQH_Lloh565:
nop
mov	x0, x19
bl Lpatch + (0xa628 - PATCH_BASE)
cbz	x0, LFQH_LBB31_16
LFQH_LBB31_12:
ldp	x29, x30, [sp, #48]
ldp	x20, x19, [sp, #32]
ldp	x22, x21, [sp, #16]
ldp	x24, x23, [sp], #64
ret
LFQH_LBB31_13:
cbz	x22, LFQH_LBB31_15
LFQH_Lloh566:
adr x0, LFQH_l_.str.47
LFQH_Lloh567:
nop
bl Lpatch + (0xa5a4 - PATCH_BASE)
mov	x20, x0
LFQH_Lloh568:
adr x1, LFQH_ListenColorKey
LFQH_Lloh569:
nop
mov	x0, x19
bl Lpatch + (0xa628 - PATCH_BASE)
mov	x2, x0
mov	x0, x22
mov	x1, x20
bl Lpatch + (0xa5d4 - PATCH_BASE)
LFQH_LBB31_15:
LFQH_Lloh570:
adr x1, LFQH_ListenLabelKey
LFQH_Lloh571:
nop
mov	x0, x19
mov	x2, #0
mov	w3, #1
bl Lpatch + (0xa634 - PATCH_BASE)
LFQH_Lloh572:
adr x1, LFQH_ListenColorKey
LFQH_Lloh573:
nop
mov	x0, x19
mov	x2, #0
mov	w3, #1
bl Lpatch + (0xa634 - PATCH_BASE)
LFQH_Lloh574:
adr x1, LFQH_ListenTintKey
LFQH_Lloh575:
nop
mov	x0, x19
mov	x2, #0
mov	w3, #1
bl Lpatch + (0xa634 - PATCH_BASE)
LFQH_Lloh576:
adr x1, LFQH_SurfaceKey
LFQH_Lloh577:
nop
mov	x0, x19
bl Lpatch + (0xa628 - PATCH_BASE)
mov	x1, x0
mov	x0, x19
ldp	x29, x30, [sp, #48]
ldp	x20, x19, [sp, #32]
ldp	x22, x21, [sp, #16]
ldp	x24, x23, [sp], #64
b	LFQH_Restore
LFQH_LBB31_16:
LFQH_Lloh578:
adr x0, LFQH_l_.str.49
LFQH_Lloh579:
nop
bl Lpatch + (0xa5b0 - PATCH_BASE)
mov	x21, x0
LFQH_Lloh580:
adr x0, LFQH_l_.str.52
LFQH_Lloh581:
nop
bl Lpatch + (0xa5a4 - PATCH_BASE)
mov	x1, x0
mov	x0, x21
bl Lpatch + (0xa5d4 - PATCH_BASE)
mov	x21, x0
LFQH_Lloh582:
adr x0, LFQH_l_.str.53
LFQH_Lloh583:
nop
bl Lpatch + (0xa5a4 - PATCH_BASE)
mov	x1, x0
fmov	d0, #0.50000000
mov	x0, x21
bl Lpatch + (0xa5d4 - PATCH_BASE)
mov	x21, x0
LFQH_Lloh584:
adr x1, LFQH_l_.str.54
LFQH_Lloh585:
nop
mov	x0, x20
bl	LFQH_Get
mov	x22, x0
LFQH_Lloh586:
adr x0, LFQH_l_.str.55
LFQH_Lloh587:
nop
bl Lpatch + (0xa5a4 - PATCH_BASE)
mov	x1, x0
mov	x0, x22
bl Lpatch + (0xa5d4 - PATCH_BASE)
mov	x22, x0
LFQH_Lloh588:
adr x0, LFQH_l_.str.56
LFQH_Lloh589:
nop
bl Lpatch + (0xa5a4 - PATCH_BASE)
mov	x1, x0
mov	x0, x22
mov	x2, x21
bl Lpatch + (0xa5d4 - PATCH_BASE)
LFQH_Lloh590:
adr x0, LFQH_l_.str.57
LFQH_Lloh591:
nop
bl Lpatch + (0xa5a4 - PATCH_BASE)
mov	x1, x0
mov	x0, x20
mov	x2, x22
bl Lpatch + (0xa5d4 - PATCH_BASE)
LFQH_Lloh592:
adr x0, LFQH_l_.str.58
LFQH_Lloh593:
nop
bl Lpatch + (0xa5a4 - PATCH_BASE)
mov	x1, x0
mov	x0, x22
bl Lpatch + (0xa5d4 - PATCH_BASE)
LFQH_Lloh594:
adr x1, LFQH_ListenTintKey
LFQH_Lloh595:
nop
mov	x0, x19
mov	x2, x20
mov	w3, #1
ldp	x29, x30, [sp, #48]
ldp	x20, x19, [sp, #32]
ldp	x22, x21, [sp, #16]
ldp	x24, x23, [sp], #64
b Lpatch + (0xa634 - PATCH_BASE)
.cfi_endproc
.p2align	2
LFQH_ListenCaption:
.cfi_startproc
stp	x24, x23, [sp, #-64]!
stp	x22, x21, [sp, #16]
stp	x20, x19, [sp, #32]
stp	x29, x30, [sp, #48]
add	x29, sp, #48
.cfi_def_cfa w29, 16
.cfi_offset w30, -8
.cfi_offset w29, -16
.cfi_offset w19, -24
.cfi_offset w20, -32
.cfi_offset w21, -40
.cfi_offset w22, -48
.cfi_offset w23, -56
.cfi_offset w24, -64
mov	x19, x1
mov	x20, x0
LFQH_Lloh596:
adr x1, LFQH_l_.str.239
LFQH_Lloh597:
nop
bl	LFQH_Kind
cbz	w0, LFQH_LBB32_2
LFQH_Lloh598:
adr x1, LFQH_l_.str.240
LFQH_Lloh599:
nop
mov	x0, x20
bl	LFQH_Get
LFQH_Lloh600:
adr x1, LFQH_l_.str.241
LFQH_Lloh601:
nop
bl	LFQH_Equal
tbnz	w0, #0, LFQH_LBB32_5
LFQH_LBB32_2:
cbz	w19, LFQH_LBB32_4
LFQH_Lloh602:
adr x1, LFQH_l_.str.16
LFQH_Lloh603:
nop
mov	x0, x20
bl	LFQH_Kind
tbz	w0, #0, LFQH_LBB32_6
LFQH_LBB32_4:
mov	x20, #0
LFQH_LBB32_5:
mov	x0, x20
ldp	x29, x30, [sp, #48]
ldp	x20, x19, [sp, #32]
ldp	x22, x21, [sp, #16]
ldp	x24, x23, [sp], #64
ret
LFQH_LBB32_6:
LFQH_Lloh604:
adr x1, LFQH_l_.str.195
LFQH_Lloh605:
nop
mov	x0, x20
bl	LFQH_Get
mov	x21, x0
LFQH_Lloh606:
adr x0, LFQH_l_.str.36
LFQH_Lloh607:
nop
bl Lpatch + (0xa5a4 - PATCH_BASE)
mov	x1, x0
mov	x0, x21
bl Lpatch + (0xa5d4 - PATCH_BASE)
cmp	x0, #12
mov	w8, #12
csel	x24, x0, x8, lo
cbz	x0, LFQH_LBB32_4
mov	x22, #0
sub	w19, w19, #1
LFQH_Lloh608:
adr x23, LFQH_l_.str.229
LFQH_Lloh609:
nop
LFQH_LBB32_8:
mov	x0, x23
bl Lpatch + (0xa5a4 - PATCH_BASE)
mov	x1, x0
mov	x0, x21
mov	x2, x22
bl Lpatch + (0xa5d4 - PATCH_BASE)
mov	x1, x19
bl	LFQH_ListenCaption
cbnz	x0, LFQH_LBB32_10
add	x22, x22, #1
cmp	x24, x22
b.eq	LFQH_LBB32_4
b	LFQH_LBB32_8
LFQH_LBB32_10:
mov	x20, x0
b	LFQH_LBB32_5
.cfi_endproc
.p2align	2
LFQH_ListenLabelKey:
.cfi_startproc
ret
.cfi_endproc
.p2align	2
LFQH_Enabled:
.cfi_startproc
stp	x22, x21, [sp, #-48]!
stp	x20, x19, [sp, #16]
stp	x29, x30, [sp, #32]
add	x29, sp, #32
.cfi_def_cfa w29, 16
.cfi_offset w30, -8
.cfi_offset w29, -16
.cfi_offset w19, -24
.cfi_offset w20, -32
.cfi_offset w21, -40
.cfi_offset w22, -48
LFQH_Lloh610:
adr x0, LFQH_l_.str.242
LFQH_Lloh611:
nop
bl Lpatch + (0xa5b0 - PATCH_BASE)
mov	x19, x0
LFQH_Lloh612:
adr x0, LFQH_l_.str.243
LFQH_Lloh613:
nop
bl Lpatch + (0xa5a4 - PATCH_BASE)
mov	x1, x0
mov	x0, x19
bl Lpatch + (0xa5d4 - PATCH_BASE)
mov	x19, x0
LFQH_Lloh614:
adr x0, LFQH_l_.str.244
LFQH_Lloh615:
nop
bl Lpatch + (0xa5a4 - PATCH_BASE)
mov	x20, x0
LFQH_Lloh616:
adr x0, LFQH_l_.str.156
LFQH_Lloh617:
nop
bl Lpatch + (0xa5b0 - PATCH_BASE)
mov	x21, x0
LFQH_Lloh618:
adr x0, LFQH_l_.str.157
LFQH_Lloh619:
nop
bl Lpatch + (0xa5a4 - PATCH_BASE)
mov	x1, x0
LFQH_Lloh620:
adr x2, LFQH_l_.str.245
LFQH_Lloh621:
nop
mov	x0, x21
bl Lpatch + (0xa5d4 - PATCH_BASE)
mov	x2, x0
mov	x0, x19
mov	x1, x20
bl Lpatch + (0xa5d4 - PATCH_BASE)
cmp	x0, #0
cset	w0, eq
ldp	x29, x30, [sp, #32]
ldp	x20, x19, [sp, #16]
ldp	x22, x21, [sp], #48
ret
.cfi_endproc
.p2align	2
LFQH_ListenColorKey:
.cfi_startproc
ret
.cfi_endproc
.p2align	2
LFQH_ListenTintKey:
.cfi_startproc
ret
.cfi_endproc
.p2align	2
LFQH_Restore:
.cfi_startproc
stp	x22, x21, [sp, #-48]!
stp	x20, x19, [sp, #16]
stp	x29, x30, [sp, #32]
add	x29, sp, #32
.cfi_def_cfa w29, 16
.cfi_offset w30, -8
.cfi_offset w29, -16
.cfi_offset w19, -24
.cfi_offset w20, -32
.cfi_offset w21, -40
.cfi_offset w22, -48
mov	x19, x0
cbz	x1, LFQH_LBB37_7
mov	x20, x1
LFQH_Lloh622:
adr x1, LFQH_ClipsKey
LFQH_Lloh623:
nop
mov	x0, x19
bl Lpatch + (0xa628 - PATCH_BASE)
cbnz	x0, LFQH_LBB37_3
LFQH_Lloh624:
adr x1, LFQH_HeaderClipsKey
LFQH_Lloh625:
nop
mov	x0, x19
bl Lpatch + (0xa628 - PATCH_BASE)
cbz	x0, LFQH_LBB37_6
LFQH_LBB37_3:
LFQH_Lloh626:
adr x0, LFQH_l_.str.49
LFQH_Lloh627:
nop
bl Lpatch + (0xa5b0 - PATCH_BASE)
mov	x21, x0
LFQH_Lloh628:
adr x0, LFQH_l_.str.168
LFQH_Lloh629:
nop
bl Lpatch + (0xa5a4 - PATCH_BASE)
mov	x1, x0
mov	x0, x21
bl Lpatch + (0xa5d4 - PATCH_BASE)
mov	x21, x0
LFQH_Lloh630:
adr x0, LFQH_l_.str.167
LFQH_Lloh631:
nop
bl Lpatch + (0xa5a4 - PATCH_BASE)
mov	x1, x0
mov	x0, x19
bl Lpatch + (0xa5d4 - PATCH_BASE)
cmp	x0, x21
b.eq	LFQH_LBB37_5
mov	x22, x0
LFQH_Lloh632:
adr x0, LFQH_l_.str.51
LFQH_Lloh633:
nop
bl Lpatch + (0xa5a4 - PATCH_BASE)
mov	x1, x0
mov	x0, x22
mov	x2, x21
bl Lpatch + (0xa5d4 - PATCH_BASE)
cbz	w0, LFQH_LBB37_6
LFQH_LBB37_5:
LFQH_Lloh634:
adr x0, LFQH_l_.str.187
LFQH_Lloh635:
nop
bl Lpatch + (0xa5a4 - PATCH_BASE)
mov	x21, x0
LFQH_Lloh636:
adr x1, LFQH_BackgroundKey
LFQH_Lloh637:
nop
mov	x0, x19
bl Lpatch + (0xa628 - PATCH_BASE)
mov	x2, x0
mov	x0, x19
mov	x1, x21
bl Lpatch + (0xa5d4 - PATCH_BASE)
LFQH_LBB37_6:
LFQH_Lloh638:
adr x0, LFQH_l_.str.214
LFQH_Lloh639:
nop
bl Lpatch + (0xa5a4 - PATCH_BASE)
mov	x1, x0
mov	x0, x20
bl Lpatch + (0xa5d4 - PATCH_BASE)
LFQH_Lloh640:
adr x1, LFQH_SurfaceKey
LFQH_Lloh641:
nop
mov	x0, x19
mov	x2, #0
mov	w3, #1
bl Lpatch + (0xa634 - PATCH_BASE)
LFQH_Lloh642:
adr x1, LFQH_BackgroundKey
LFQH_Lloh643:
nop
mov	x0, x19
mov	x2, #0
mov	w3, #1
bl Lpatch + (0xa634 - PATCH_BASE)
LFQH_LBB37_7:
mov	x0, x19
bl	LFQH_RestoreHeaderOwner
mov	x0, x19
ldp	x29, x30, [sp, #32]
ldp	x20, x19, [sp, #16]
ldp	x22, x21, [sp], #48
b	LFQH_RestoreOwner
.cfi_endproc
.p2align	2
LFQH_FQHReaderOwnsControl:
.cfi_startproc
stp	x26, x25, [sp, #-80]!
stp	x24, x23, [sp, #16]
stp	x22, x21, [sp, #32]
stp	x20, x19, [sp, #48]
stp	x29, x30, [sp, #64]
add	x29, sp, #64
.cfi_def_cfa w29, 16
.cfi_offset w30, -8
.cfi_offset w29, -16
.cfi_offset w19, -24
.cfi_offset w20, -32
.cfi_offset w21, -40
.cfi_offset w22, -48
.cfi_offset w23, -56
.cfi_offset w24, -64
.cfi_offset w25, -72
.cfi_offset w26, -80
cbz	x0, LFQH_LBB38_9
mov	x19, x0
mov	w25, #0
LFQH_Lloh644:
adr x20, LFQH_l_.str.159
LFQH_Lloh645:
nop
LFQH_Lloh646:
adr x21, LFQH_l_.str.59
LFQH_Lloh647:
nop
LFQH_Lloh648:
adr x22, LFQH_l_.str.61
LFQH_Lloh649:
nop
LFQH_Lloh650:
adr x23, LFQH_l_.str.20
LFQH_Lloh651:
nop
LFQH_LBB38_2:
mov	x0, x20
bl Lpatch + (0xa5a4 - PATCH_BASE)
mov	x24, x0
mov	x0, x21
bl Lpatch + (0xa5b0 - PATCH_BASE)
mov	x2, x0
mov	x0, x19
mov	x1, x24
bl Lpatch + (0xa5d4 - PATCH_BASE)
cbnz	w0, LFQH_LBB38_6
mov	x0, x20
bl Lpatch + (0xa5a4 - PATCH_BASE)
mov	x24, x0
mov	x0, x22
bl Lpatch + (0xa5b0 - PATCH_BASE)
mov	x2, x0
mov	x0, x19
mov	x1, x24
bl Lpatch + (0xa5d4 - PATCH_BASE)
cbnz	w0, LFQH_LBB38_10
mov	x0, x19
mov	x1, x23
bl	LFQH_Get
mov	x19, x0
mov	w0, #0
cbz	x19, LFQH_LBB38_9
cmp	w25, #3
add	w25, w25, #1
b.lo	LFQH_LBB38_2
b	LFQH_LBB38_9
LFQH_LBB38_6:
LFQH_Lloh652:
adr x1, LFQH_l_.str.20
LFQH_Lloh653:
nop
mov	x0, x19
bl	LFQH_Get
mov	x20, x0
LFQH_Lloh654:
adr x1, LFQH_l_.str.60
LFQH_Lloh655:
nop
bl	LFQH_Kind
cbz	w0, LFQH_LBB38_9
mov	x0, x19
mov	x1, x20
bl	LFQH_ReaderBottomItem
cbz	w0, LFQH_LBB38_9
bl	LFQH_FQHGlassAvailable
LFQH_LBB38_9:
ldp	x29, x30, [sp, #64]
ldp	x20, x19, [sp, #48]
ldp	x22, x21, [sp, #32]
ldp	x24, x23, [sp, #16]
ldp	x26, x25, [sp], #80
ret
LFQH_LBB38_10:
ldp	x29, x30, [sp, #64]
ldp	x20, x19, [sp, #48]
ldp	x22, x21, [sp, #32]
ldp	x24, x23, [sp, #16]
ldp	x26, x25, [sp], #80
b	LFQH_FQHGlassAvailable
.cfi_endproc
.p2align	2
LFQH_ReaderBottomItem:
.cfi_startproc
stp	x20, x19, [sp, #-32]!
stp	x29, x30, [sp, #16]
add	x29, sp, #16
.cfi_def_cfa w29, 16
.cfi_offset w30, -8
.cfi_offset w29, -16
.cfi_offset w19, -24
.cfi_offset w20, -32
mov	x20, x1
mov	x19, x0
LFQH_Lloh656:
adr x1, LFQH_l_.str.246
LFQH_Lloh657:
nop
mov	x0, x20
bl	LFQH_Get
cmp	x19, x0
b.eq	LFQH_LBB39_3
LFQH_Lloh658:
adr x1, LFQH_l_.str.247
LFQH_Lloh659:
nop
mov	x0, x20
bl	LFQH_Get
cmp	x19, x0
b.eq	LFQH_LBB39_3
LFQH_Lloh660:
adr x1, LFQH_l_.str.248
LFQH_Lloh661:
nop
mov	x0, x20
bl	LFQH_Get
cmp	x19, x0
cset	w0, eq
b	LFQH_LBB39_4
LFQH_LBB39_3:
mov	w0, #1
LFQH_LBB39_4:
ldp	x29, x30, [sp, #16]
ldp	x20, x19, [sp], #32
ret
.cfi_endproc
.p2align	2
LFQH_FQHPageTargetGame:
.cfi_startproc
stp	x20, x19, [sp, #-32]!
stp	x29, x30, [sp, #16]
add	x29, sp, #16
.cfi_def_cfa w29, 16
.cfi_offset w30, -8
.cfi_offset w29, -16
.cfi_offset w19, -24
.cfi_offset w20, -32
mov	x19, x0
LFQH_Lloh662:
adr x1, LFQH_l_.str.62
LFQH_Lloh663:
nop
bl	LFQH_Equal
tbnz	w0, #0, LFQH_LBB40_4
LFQH_Lloh664:
adr x1, LFQH_l_.str.63
LFQH_Lloh665:
nop
mov	x0, x19
bl	LFQH_Equal
tbnz	w0, #0, LFQH_LBB40_4
LFQH_Lloh666:
adr x1, LFQH_l_.str.64
LFQH_Lloh667:
nop
mov	x0, x19
bl	LFQH_Equal
tbnz	w0, #0, LFQH_LBB40_4
LFQH_Lloh668:
adr x1, LFQH_l_.str.65
LFQH_Lloh669:
nop
mov	x0, x19
bl	LFQH_Equal
tbz	w0, #0, LFQH_LBB40_6
LFQH_LBB40_4:
mov	w0, #1
LFQH_LBB40_5:
ldp	x29, x30, [sp, #16]
ldp	x20, x19, [sp], #32
ret
LFQH_LBB40_6:
LFQH_Lloh670:
adr x1, LFQH_l_.str.66
LFQH_Lloh671:
nop
mov	x0, x19
bl	LFQH_Responds
cbz	w0, LFQH_LBB40_5
LFQH_Lloh672:
adr x0, LFQH_l_.str.66
LFQH_Lloh673:
nop
bl Lpatch + (0xa5a4 - PATCH_BASE)
mov	x20, x0
LFQH_Lloh674:
adr x0, LFQH_l_.str.65
LFQH_Lloh675:
nop
bl	LFQH_Text
mov	x2, x0
mov	x0, x19
mov	x1, x20
bl Lpatch + (0xa5d4 - PATCH_BASE)
cmp	w0, #0
cset	w0, ne
b	LFQH_LBB40_5
.cfi_endproc
.p2align	2
LFQH_FQHPageFilterMiniGame:
.cfi_startproc
cbz	x0, LFQH_LBB41_13
stp	x22, x21, [sp, #-48]!
stp	x20, x19, [sp, #16]
stp	x29, x30, [sp, #32]
add	x29, sp, #32
.cfi_def_cfa w29, 16
.cfi_offset w30, -8
.cfi_offset w29, -16
.cfi_offset w19, -24
.cfi_offset w20, -32
.cfi_offset w21, -40
.cfi_offset w22, -48
mov	x20, x0
LFQH_Lloh676:
adr x1, LFQH_l_.str.67
LFQH_Lloh677:
nop
bl	LFQH_Get
cbz	x0, LFQH_LBB41_12
mov	x19, x0
LFQH_Lloh678:
adr x1, LFQH_l_.str.249
LFQH_Lloh679:
nop
bl	LFQH_Get
cbz	x0, LFQH_LBB41_5
mov	x21, x0
LFQH_Lloh680:
adr x1, LFQH_l_.str.85
LFQH_Lloh681:
nop
bl	LFQH_Get
bl	LFQH_FQHPageTargetGame
tbnz	w0, #0, LFQH_LBB41_8
LFQH_Lloh682:
adr x1, LFQH_l_.str.250
LFQH_Lloh683:
nop
mov	x0, x21
bl	LFQH_Get
bl	LFQH_FQHPageTargetGame
tbnz	w0, #0, LFQH_LBB41_8
LFQH_LBB41_5:
LFQH_Lloh684:
adr x1, LFQH_l_.str.251
LFQH_Lloh685:
nop
mov	x0, x19
bl	LFQH_Get
bl	LFQH_FQHPageTargetGame
tbnz	w0, #0, LFQH_LBB41_8
LFQH_Lloh686:
adr x1, LFQH_l_.str.250
LFQH_Lloh687:
nop
mov	x0, x19
bl	LFQH_Get
bl	LFQH_FQHPageTargetGame
tbnz	w0, #0, LFQH_LBB41_8
LFQH_Lloh688:
adr x1, LFQH_l_.str.85
LFQH_Lloh689:
nop
mov	x0, x19
bl	LFQH_Get
bl	LFQH_FQHPageTargetGame
tbz	w0, #0, LFQH_LBB41_14
LFQH_LBB41_8:
LFQH_Lloh690:
adr x0, LFQH_l_.str.68
LFQH_Lloh691:
nop
bl Lpatch + (0xa5a4 - PATCH_BASE)
mov	x1, x0
mov	x0, x19
mov	w2, #1
bl Lpatch + (0xa5d4 - PATCH_BASE)
LFQH_Lloh692:
adr x0, LFQH_l_.str.69
LFQH_Lloh693:
nop
bl Lpatch + (0xa5a4 - PATCH_BASE)
mov	x1, x0
mov	x0, x19
mov	w2, #1
bl Lpatch + (0xa5d4 - PATCH_BASE)
LFQH_Lloh694:
adr x1, LFQH_l_.str.70
LFQH_Lloh695:
nop
mov	x0, x20
bl	LFQH_Get
mov	x20, x0
LFQH_Lloh696:
adr x1, LFQH_l_.str.71
LFQH_Lloh697:
nop
bl	LFQH_Kind
cbz	w0, LFQH_LBB41_11
LFQH_Lloh698:
adr x1, LFQH_l_.str.72
LFQH_Lloh699:
nop
mov	x0, x20
bl	LFQH_Responds
cbz	w0, LFQH_LBB41_11
LFQH_Lloh700:
adr x0, LFQH_l_.str.72
LFQH_Lloh701:
nop
bl Lpatch + (0xa5a4 - PATCH_BASE)
mov	x1, x0
mov	x0, x20
mov	x2, x19
bl Lpatch + (0xa5d4 - PATCH_BASE)
LFQH_LBB41_11:
LFQH_Lloh702:
adr x0, LFQH_l_.str.73
LFQH_Lloh703:
nop
bl Lpatch + (0xa5b0 - PATCH_BASE)
mov	x19, x0
LFQH_Lloh704:
adr x0, LFQH_l_.str.74
LFQH_Lloh705:
nop
bl Lpatch + (0xa5a4 - PATCH_BASE)
mov	x1, x0
mov	x0, x19
bl Lpatch + (0xa5d4 - PATCH_BASE)
mov	x19, x0
LFQH_Lloh706:
adr x20, LFQH_l_.str.156
LFQH_Lloh707:
nop
mov	x0, x20
bl Lpatch + (0xa5b0 - PATCH_BASE)
mov	x22, x0
LFQH_Lloh708:
adr x21, LFQH_l_.str.157
LFQH_Lloh709:
nop
mov	x0, x21
bl Lpatch + (0xa5a4 - PATCH_BASE)
mov	x1, x0
LFQH_Lloh710:
adr x2, LFQH_l_.str.76
LFQH_Lloh711:
nop
mov	x0, x22
bl Lpatch + (0xa5d4 - PATCH_BASE)
mov	x2, x0
LFQH_Lloh712:
adr x1, LFQH_l_.str.75
LFQH_Lloh713:
nop
mov	x0, x19
bl	LFQH_Put
mov	x0, x20
bl Lpatch + (0xa5b0 - PATCH_BASE)
mov	x22, x0
mov	x0, x21
bl Lpatch + (0xa5a4 - PATCH_BASE)
mov	x1, x0
LFQH_Lloh714:
adr x2, LFQH_l_.str.78
LFQH_Lloh715:
nop
mov	x0, x22
bl Lpatch + (0xa5d4 - PATCH_BASE)
mov	x2, x0
LFQH_Lloh716:
adr x1, LFQH_l_.str.77
LFQH_Lloh717:
nop
mov	x0, x19
bl	LFQH_Put
mov	x0, x20
bl Lpatch + (0xa5b0 - PATCH_BASE)
mov	x22, x0
mov	x0, x21
bl Lpatch + (0xa5a4 - PATCH_BASE)
mov	x1, x0
LFQH_Lloh718:
adr x2, LFQH_l_.str.80
LFQH_Lloh719:
nop
mov	x0, x22
bl Lpatch + (0xa5d4 - PATCH_BASE)
mov	x2, x0
LFQH_Lloh720:
adr x1, LFQH_l_.str.79
LFQH_Lloh721:
nop
mov	x0, x19
bl	LFQH_Put
mov	x0, x20
bl Lpatch + (0xa5b0 - PATCH_BASE)
mov	x20, x0
mov	x0, x21
bl Lpatch + (0xa5a4 - PATCH_BASE)
mov	x1, x0
LFQH_Lloh722:
adr x2, LFQH_l_.str.82
LFQH_Lloh723:
nop
mov	x0, x20
bl Lpatch + (0xa5d4 - PATCH_BASE)
mov	x2, x0
LFQH_Lloh724:
adr x1, LFQH_l_.str.81
LFQH_Lloh725:
nop
mov	x0, x19
bl	LFQH_Put
LFQH_Lloh726:
adr x0, LFQH_l_.str.83
LFQH_Lloh727:
nop
mov	x1, x19
bl Lrecord_named
mov	w0, #1
LFQH_LBB41_12:
ldp	x29, x30, [sp, #32]
ldp	x20, x19, [sp, #16]
ldp	x22, x21, [sp], #48
LFQH_LBB41_13:
ret
LFQH_LBB41_14:
LFQH_Lloh728:
adr x1, LFQH_l_.str.252
LFQH_Lloh729:
nop
mov	x0, x19
bl	LFQH_Get
cbz	x0, LFQH_LBB41_12
LFQH_Lloh730:
adr x1, LFQH_l_.str.253
LFQH_Lloh731:
nop
bl	LFQH_Get
bl	LFQH_FQHPageTargetGame
cbnz	w0, LFQH_LBB41_8
b	LFQH_LBB41_12
.cfi_endproc
.p2align	2
LFQH_Put:
.cfi_startproc
stp	x24, x23, [sp, #-64]!
stp	x22, x21, [sp, #16]
stp	x20, x19, [sp, #32]
stp	x29, x30, [sp, #48]
add	x29, sp, #48
.cfi_def_cfa w29, 16
.cfi_offset w30, -8
.cfi_offset w29, -16
.cfi_offset w19, -24
.cfi_offset w20, -32
.cfi_offset w21, -40
.cfi_offset w22, -48
.cfi_offset w23, -56
.cfi_offset w24, -64
mov	x19, x2
mov	x20, x1
mov	x21, x0
LFQH_Lloh732:
adr x0, LFQH_l_.str.254
LFQH_Lloh733:
nop
bl Lpatch + (0xa5a4 - PATCH_BASE)
mov	x22, x0
LFQH_Lloh734:
adr x0, LFQH_l_.str.156
LFQH_Lloh735:
nop
bl Lpatch + (0xa5b0 - PATCH_BASE)
mov	x23, x0
LFQH_Lloh736:
adr x0, LFQH_l_.str.157
LFQH_Lloh737:
nop
bl Lpatch + (0xa5a4 - PATCH_BASE)
mov	x1, x0
mov	x0, x23
mov	x2, x20
bl Lpatch + (0xa5d4 - PATCH_BASE)
mov	x3, x0
mov	x0, x21
mov	x1, x22
mov	x2, x19
ldp	x29, x30, [sp, #48]
ldp	x20, x19, [sp, #32]
ldp	x22, x21, [sp, #16]
ldp	x24, x23, [sp], #64
b Lpatch + (0xa5d4 - PATCH_BASE)
.cfi_endproc
.p2align	2
LFQH_FQHPageTabItems:
.cfi_startproc
stp	x28, x27, [sp, #-96]!
stp	x26, x25, [sp, #16]
stp	x24, x23, [sp, #32]
stp	x22, x21, [sp, #48]
stp	x20, x19, [sp, #64]
stp	x29, x30, [sp, #80]
add	x29, sp, #80
.cfi_def_cfa w29, 16
.cfi_offset w30, -8
.cfi_offset w29, -16
.cfi_offset w19, -24
.cfi_offset w20, -32
.cfi_offset w21, -40
.cfi_offset w22, -48
.cfi_offset w23, -56
.cfi_offset w24, -64
.cfi_offset w25, -72
.cfi_offset w26, -80
.cfi_offset w27, -88
.cfi_offset w28, -96
mov	x19, x0
LFQH_Lloh738:
adr x1, LFQH_l_.str.35
LFQH_Lloh739:
nop
bl	LFQH_Kind
cbz	w0, LFQH_LBB43_10
LFQH_Lloh740:
adr x0, LFQH_l_.str.71
LFQH_Lloh741:
nop
bl Lpatch + (0xa5b0 - PATCH_BASE)
mov	x20, x0
LFQH_Lloh742:
adr x0, LFQH_l_.str.84
LFQH_Lloh743:
nop
bl Lpatch + (0xa5a4 - PATCH_BASE)
mov	x1, x0
mov	x0, x20
bl Lpatch + (0xa5d4 - PATCH_BASE)
mov	x20, x0
LFQH_Lloh744:
adr x0, LFQH_l_.str.36
LFQH_Lloh745:
nop
bl Lpatch + (0xa5a4 - PATCH_BASE)
mov	x1, x0
mov	x0, x19
bl Lpatch + (0xa5d4 - PATCH_BASE)
cmp	x0, #32
mov	w8, #32
csel	x28, x0, x8, lo
cbz	x0, LFQH_LBB43_9
mov	x21, #0
LFQH_Lloh746:
adr x22, LFQH_l_.str.229
LFQH_Lloh747:
nop
LFQH_Lloh748:
adr x23, LFQH_l_.str.85
LFQH_Lloh749:
nop
LFQH_Lloh750:
adr x24, LFQH_l_.str.86
LFQH_Lloh751:
nop
LFQH_Lloh752:
adr x25, LFQH_l_.str.87
LFQH_Lloh753:
nop
LFQH_LBB43_3:
mov	x0, x22
bl Lpatch + (0xa5a4 - PATCH_BASE)
mov	x1, x0
mov	x0, x19
mov	x2, x21
bl Lpatch + (0xa5d4 - PATCH_BASE)
mov	x27, x0
mov	x1, x23
bl	LFQH_Get
mov	x26, x0
mov	x1, x24
bl	LFQH_Equal
cbz	w0, LFQH_LBB43_5
LFQH_Lloh754:
adr x0, LFQH_l_.str.256
LFQH_Lloh755:
nop
bl	LFQH_DefaultEnabled
cbz	w0, LFQH_LBB43_8
LFQH_LBB43_5:
mov	x0, x26
mov	x1, x25
bl	LFQH_Equal
cbz	w0, LFQH_LBB43_7
LFQH_Lloh756:
adr x0, LFQH_l_.str.257
LFQH_Lloh757:
nop
bl	LFQH_DefaultEnabled
cbz	w0, LFQH_LBB43_8
LFQH_LBB43_7:
LFQH_Lloh758:
adr x0, LFQH_l_.str.88
LFQH_Lloh759:
nop
bl Lpatch + (0xa5a4 - PATCH_BASE)
mov	x1, x0
mov	x0, x20
mov	x2, x27
bl Lpatch + (0xa5d4 - PATCH_BASE)
LFQH_LBB43_8:
add	x21, x21, #1
cmp	x28, x21
b.ne	LFQH_LBB43_3
LFQH_LBB43_9:
LFQH_Lloh760:
adr x0, LFQH_l_.str.36
LFQH_Lloh761:
nop
bl Lpatch + (0xa5a4 - PATCH_BASE)
mov	x1, x0
mov	x0, x20
bl Lpatch + (0xa5d4 - PATCH_BASE)
cmp	x0, x28
csel	x19, x19, x20, eq
LFQH_LBB43_10:
mov	x0, x19
ldp	x29, x30, [sp, #80]
ldp	x20, x19, [sp, #64]
ldp	x22, x21, [sp, #48]
ldp	x24, x23, [sp, #32]
ldp	x26, x25, [sp, #16]
ldp	x28, x27, [sp], #96
ret
.cfi_endproc
.p2align	2
LFQH_FQHPageStyle:
.cfi_startproc
LFQH_Lloh762:
adr x1, LFQH_l_.str.89
LFQH_Lloh763:
nop
b	LFQH_PageStyle
.cfi_endproc
.p2align	2
LFQH_PageStyle:
.cfi_startproc
stp	x22, x21, [sp, #-48]!
stp	x20, x19, [sp, #16]
stp	x29, x30, [sp, #32]
add	x29, sp, #32
.cfi_def_cfa w29, 16
.cfi_offset w30, -8
.cfi_offset w29, -16
.cfi_offset w19, -24
.cfi_offset w20, -32
.cfi_offset w21, -40
.cfi_offset w22, -48
cbz	x0, LFQH_LBB45_4
mov	x20, x1
mov	x19, x0
LFQH_Lloh764:
adr x0, LFQH_l_.str.159
LFQH_Lloh765:
nop
bl Lpatch + (0xa5a4 - PATCH_BASE)
mov	x21, x0
LFQH_Lloh766:
adr x0, LFQH_l_.str.23
LFQH_Lloh767:
nop
bl Lpatch + (0xa5b0 - PATCH_BASE)
mov	x2, x0
mov	x0, x19
mov	x1, x21
bl Lpatch + (0xa5d4 - PATCH_BASE)
cbz	w0, LFQH_LBB45_4
LFQH_Lloh768:
adr x0, LFQH_l_.str.24
LFQH_Lloh769:
nop
bl Lpatch + (0xa5a4 - PATCH_BASE)
mov	x1, x0
mov	x0, x19
bl Lpatch + (0xa5d4 - PATCH_BASE)
fmov	x8, d2
fmov	x9, d1
fmov	x10, d0
ubfx	x10, x10, #52, #11
ubfx	x9, x9, #52, #11
ubfx	x8, x8, #52, #11
cmp	x8, #2046
mov	w8, #2046
ccmp	x9, x8, #2, ls
ccmp	x10, x8, #2, ls
b.ls	LFQH_LBB45_5
LFQH_LBB45_3:
mov	x0, x19
ldp	x29, x30, [sp, #32]
ldp	x20, x19, [sp, #16]
ldp	x22, x21, [sp], #48
b	LFQH_PageRestore
LFQH_LBB45_4:
ldp	x29, x30, [sp, #32]
ldp	x20, x19, [sp, #16]
ldp	x22, x21, [sp], #48
ret
LFQH_LBB45_5:
fmov	x8, d3
ubfx	x8, x8, #52, #11
cmp	x8, #2046
b.hi	LFQH_LBB45_3
fcmp	d2, #0.0
b.le	LFQH_LBB45_3
fcmp	d3, #0.0
b.le	LFQH_LBB45_3
mov	x0, x19
mov	x1, x20
bl	LFQH_PageRole
mov	x0, x19
ldp	x29, x30, [sp, #32]
ldp	x20, x19, [sp, #16]
ldp	x22, x21, [sp], #48
b	LFQH_FQHApply
.cfi_endproc
.p2align	2
LFQH_FQHPageTint:
.cfi_startproc
stp	x20, x19, [sp, #-32]!
stp	x29, x30, [sp, #16]
add	x29, sp, #16
.cfi_def_cfa w29, 16
.cfi_offset w30, -8
.cfi_offset w29, -16
.cfi_offset w19, -24
.cfi_offset w20, -32
mov	x19, x1
mov	x20, x0
LFQH_Lloh770:
adr x1, LFQH_l_.str.90
LFQH_Lloh771:
nop
bl	LFQH_Get
mov	x1, x0
mov	x0, x20
mov	x2, x19
ldp	x29, x30, [sp, #16]
ldp	x20, x19, [sp], #32
b	LFQH_ShelfTabStyle
.cfi_endproc
.p2align	2
LFQH_ShelfTabStyle:
.cfi_startproc
stp	d13, d12, [sp, #-96]!
stp	d11, d10, [sp, #16]
stp	d9, d8, [sp, #32]
stp	x22, x21, [sp, #48]
stp	x20, x19, [sp, #64]
stp	x29, x30, [sp, #80]
add	x29, sp, #80
.cfi_def_cfa w29, 16
.cfi_offset w30, -8
.cfi_offset w29, -16
.cfi_offset w19, -24
.cfi_offset w20, -32
.cfi_offset w21, -40
.cfi_offset w22, -48
.cfi_offset b8, -56
.cfi_offset b9, -64
.cfi_offset b10, -72
.cfi_offset b11, -80
.cfi_offset b12, -88
.cfi_offset b13, -96
mov	x19, x2
mov	x21, x1
mov	x20, x0
LFQH_Lloh772:
adr x0, LFQH_l_.str.24
LFQH_Lloh773:
nop
bl Lpatch + (0xa5a4 - PATCH_BASE)
mov	x1, x0
mov	x0, x20
bl Lpatch + (0xa5d4 - PATCH_BASE)
mov.16b	v9, v0
mov.16b	v8, v1
mov.16b	v11, v2
mov.16b	v10, v3
LFQH_Lloh774:
adr x1, LFQH_l_.str.258
LFQH_Lloh775:
nop
mov	x0, x21
bl	LFQH_Responds
fmov	d12, xzr
fmov	d0, xzr
cbz	w0, LFQH_LBB47_2
LFQH_Lloh776:
adr x0, LFQH_l_.str.258
LFQH_Lloh777:
nop
bl Lpatch + (0xa5a4 - PATCH_BASE)
mov	x1, x0
mov	x0, x21
bl Lpatch + (0xa5d4 - PATCH_BASE)
LFQH_LBB47_2:
fmov	d1, #-6.00000000
fadd	d1, d0, d1
fmov	d2, #6.00000000
fcmp	d0, d2
fcsel	d0, d1, d12, gt
fadd	d0, d11, d0
mov	x8, #4631107791820423168
fmov	d1, x8
fminnm	d12, d0, d1
fmov	d0, #-4.00000000
fadd	d0, d10, d0
fmov	d1, #28.00000000
fminnm	d13, d0, d1
fsub	d0, d11, d12
fmov	d1, #0.50000000
fmul	d0, d0, d1
fadd	d9, d9, d0
fsub	d0, d10, d13
fmul	d0, d0, d1
fadd	d8, d8, d0
LFQH_Lloh778:
adr x1, LFQH_l_.str.259
LFQH_Lloh779:
nop
mov	x0, x20
bl	LFQH_PageRole
mov	x0, x20
mov.16b	v0, v9
mov.16b	v1, v8
mov.16b	v2, v12
mov.16b	v3, v13
mov	w1, #0
bl	LFQH_ApplySurface
LFQH_Lloh780:
adr x1, LFQH_SurfaceKey
LFQH_Lloh781:
nop
mov	x0, x20
bl Lpatch + (0xa628 - PATCH_BASE)
mov	x1, x19
mov	w2, #0
ldp	x29, x30, [sp, #80]
ldp	x20, x19, [sp, #64]
ldp	x22, x21, [sp, #48]
ldp	d9, d8, [sp, #32]
ldp	d11, d10, [sp, #16]
ldp	d13, d12, [sp], #96
b	LFQH_ShelfTint
.cfi_endproc
.p2align	2
LFQH_FQHPageInstall:
.cfi_startproc
stp	x24, x23, [sp, #-64]!
stp	x22, x21, [sp, #16]
stp	x20, x19, [sp, #32]
stp	x29, x30, [sp, #48]
add	x29, sp, #48
.cfi_def_cfa w29, 16
.cfi_offset w30, -8
.cfi_offset w29, -16
.cfi_offset w19, -24
.cfi_offset w20, -32
.cfi_offset w21, -40
.cfi_offset w22, -48
.cfi_offset w23, -56
.cfi_offset w24, -64
LFQH_Lloh782:
adr x0, LFQH_l_.str.60
LFQH_Lloh783:
nop
LFQH_Lloh784:
adr x20, LFQH_l_.str.91
LFQH_Lloh785:
nop
LFQH_Lloh786:
adr x2, LFQH_l_.str.92
LFQH_Lloh787:
nop
LFQH_Lloh788:
adr x19, LFQH_l_.str.9
LFQH_Lloh789:
nop
LFQH_Lloh790:
adr x4, LFQH_PageBottomLayout
LFQH_Lloh791:
nop
mov	x1, x20
mov	x3, x19
bl	LFQH_Hook
LFQH_Lloh792:
adr x0, LFQH_l_.str.93
LFQH_Lloh793:
nop
LFQH_Lloh794:
adr x2, LFQH_l_.str.94
LFQH_Lloh795:
nop
LFQH_Lloh796:
adr x4, LFQH_PageProgressLayout
LFQH_Lloh797:
nop
mov	x1, x20
mov	x3, x19
bl	LFQH_Hook
LFQH_Lloh798:
adr x0, LFQH_l_.str.95
LFQH_Lloh799:
nop
LFQH_Lloh800:
adr x2, LFQH_l_.str.96
LFQH_Lloh801:
nop
LFQH_Lloh802:
adr x4, LFQH_PageDivertLayout
LFQH_Lloh803:
nop
mov	x1, x20
mov	x3, x19
bl	LFQH_Hook
LFQH_Lloh804:
adr x0, LFQH_l_.str.97
LFQH_Lloh805:
nop
LFQH_Lloh806:
adr x2, LFQH_l_.str.98
LFQH_Lloh807:
nop
LFQH_Lloh808:
adr x4, LFQH_PageGiftLayout
LFQH_Lloh809:
nop
mov	x1, x20
mov	x3, x19
bl	LFQH_Hook
LFQH_Lloh810:
adr x0, LFQH_l_.str.99
LFQH_Lloh811:
nop
LFQH_Lloh812:
adr x2, LFQH_l_.str.100
LFQH_Lloh813:
nop
LFQH_Lloh814:
adr x4, LFQH_PageBookGiftLayout
LFQH_Lloh815:
nop
mov	x1, x20
mov	x3, x19
bl	LFQH_Hook
LFQH_Lloh816:
adr x0, LFQH_l_.str.101
LFQH_Lloh817:
nop
LFQH_Lloh818:
adr x2, LFQH_l_.str.102
LFQH_Lloh819:
nop
LFQH_Lloh820:
adr x4, LFQH_PageDiscussLayout
LFQH_Lloh821:
nop
mov	x1, x20
mov	x3, x19
bl	LFQH_Hook
LFQH_Lloh822:
adr x0, LFQH_l_.str.103
LFQH_Lloh823:
nop
LFQH_Lloh824:
adr x2, LFQH_l_.str.104
LFQH_Lloh825:
nop
LFQH_Lloh826:
adr x4, LFQH_PageDiscussButtonLayout
LFQH_Lloh827:
nop
mov	x1, x20
mov	x3, x19
bl	LFQH_Hook
LFQH_Lloh828:
adr x21, LFQH_l_.str.105
LFQH_Lloh829:
nop
LFQH_Lloh830:
adr x2, LFQH_l_.str.106
LFQH_Lloh831:
nop
LFQH_Lloh832:
adr x4, LFQH_PageShelfTabLayout
LFQH_Lloh833:
nop
mov	x0, x21
mov	x1, x20
mov	x3, x19
bl	LFQH_Hook
LFQH_Lloh834:
adr x1, LFQH_l_.str.107
LFQH_Lloh835:
nop
LFQH_Lloh836:
adr x2, LFQH_l_.str.108
LFQH_Lloh837:
nop
LFQH_Lloh838:
adr x22, LFQH_l_.str.109
LFQH_Lloh839:
nop
LFQH_Lloh840:
adr x4, LFQH_PageShelfTabReload
LFQH_Lloh841:
nop
mov	x0, x21
mov	x3, x22
bl	LFQH_Hook
LFQH_Lloh842:
adr x23, LFQH_l_.str.110
LFQH_Lloh843:
nop
LFQH_Lloh844:
adr x2, LFQH_l_.str.111
LFQH_Lloh845:
nop
LFQH_Lloh846:
adr x4, LFQH_PageShelfFilterLayout
LFQH_Lloh847:
nop
mov	x0, x23
mov	x1, x20
mov	x3, x19
bl	LFQH_Hook
LFQH_Lloh848:
adr x1, LFQH_l_.str.112
LFQH_Lloh849:
nop
LFQH_Lloh850:
adr x2, LFQH_l_.str.113
LFQH_Lloh851:
nop
LFQH_Lloh852:
adr x21, LFQH_l_.str.114
LFQH_Lloh853:
nop
LFQH_Lloh854:
adr x4, LFQH_PageShelfFilterAppearance
LFQH_Lloh855:
nop
mov	x0, x23
mov	x3, x21
bl	LFQH_Hook
LFQH_Lloh856:
adr x1, LFQH_l_.str.115
LFQH_Lloh857:
nop
LFQH_Lloh858:
adr x2, LFQH_l_.str.116
LFQH_Lloh859:
nop
LFQH_Lloh860:
adr x4, LFQH_PageShelfFilterBackground
LFQH_Lloh861:
nop
mov	x0, x23
mov	x3, x22
bl	LFQH_Hook
LFQH_Lloh862:
adr x0, LFQH_l_.str.117
LFQH_Lloh863:
nop
LFQH_Lloh864:
adr x2, LFQH_l_.str.118
LFQH_Lloh865:
nop
LFQH_Lloh866:
adr x4, LFQH_PageProfileBarLayout
LFQH_Lloh867:
nop
mov	x1, x20
mov	x3, x19
bl	LFQH_Hook
LFQH_Lloh868:
adr x0, LFQH_l_.str.119
LFQH_Lloh869:
nop
LFQH_Lloh870:
adr x2, LFQH_l_.str.120
LFQH_Lloh871:
nop
LFQH_Lloh872:
adr x4, LFQH_PageProfileEntryLayout
LFQH_Lloh873:
nop
mov	x1, x20
mov	x3, x19
bl	LFQH_Hook
LFQH_Lloh874:
adr x0, LFQH_l_.str.121
LFQH_Lloh875:
nop
LFQH_Lloh876:
adr x2, LFQH_l_.str.122
LFQH_Lloh877:
nop
LFQH_Lloh878:
adr x4, LFQH_PageProfileEntry621Layout
LFQH_Lloh879:
nop
mov	x1, x20
mov	x3, x19
bl	LFQH_Hook
LFQH_Lloh880:
adr x0, LFQH_l_.str.78
LFQH_Lloh881:
nop
LFQH_Lloh882:
adr x1, LFQH_l_.str.123
LFQH_Lloh883:
nop
LFQH_Lloh884:
adr x2, LFQH_l_.str.124
LFQH_Lloh885:
nop
LFQH_Lloh886:
adr x4, LFQH_MiniGameSetup
LFQH_Lloh887:
nop
mov	x3, x19
bl	LFQH_Hook
LFQH_Lloh888:
adr x19, LFQH_l_.str.125
LFQH_Lloh889:
nop
LFQH_Lloh890:
adr x1, LFQH_l_.str.126
LFQH_Lloh891:
nop
LFQH_Lloh892:
adr x2, LFQH_l_.str.127
LFQH_Lloh893:
nop
LFQH_Lloh894:
adr x4, LFQH_TabSetItems
LFQH_Lloh895:
nop
mov	x0, x19
mov	x3, x22
bl	LFQH_Hook
LFQH_Lloh896:
adr x1, LFQH_l_.str.128
LFQH_Lloh897:
nop
LFQH_Lloh898:
adr x2, LFQH_l_.str.129
LFQH_Lloh899:
nop
LFQH_Lloh900:
adr x3, LFQH_l_.str.130
LFQH_Lloh901:
nop
LFQH_Lloh902:
adr x4, LFQH_TabSetItemsAnimated
LFQH_Lloh903:
nop
mov	x0, x19
bl	LFQH_Hook
LFQH_Lloh904:
adr x19, LFQH_l_.str.131
LFQH_Lloh905:
nop
LFQH_Lloh906:
adr x1, LFQH_l_.str.132
LFQH_Lloh907:
nop
LFQH_Lloh908:
adr x2, LFQH_l_.str.133
LFQH_Lloh909:
nop
LFQH_Lloh910:
adr x4, LFQH_OptionsAppear
LFQH_Lloh911:
nop
mov	x0, x19
mov	x3, x21
bl	LFQH_Hook
mov	x0, x19
bl Lpatch + (0xa5b0 - PATCH_BASE)
cbz	x0, LFQH_LBB48_2
mov	x19, x0
LFQH_Lloh912:
adr x0, LFQH_l_.str.133
LFQH_Lloh913:
nop
bl Lpatch + (0xa5a4 - PATCH_BASE)
mov	x1, x0
mov	x0, x19
bl Lpatch + (0xa5f8 - PATCH_BASE)
cbz	x0, LFQH_LBB48_3
LFQH_LBB48_2:
ldp	x29, x30, [sp, #48]
ldp	x20, x19, [sp, #32]
ldp	x22, x21, [sp, #16]
ldp	x24, x23, [sp], #64
ret
LFQH_LBB48_3:
LFQH_Lloh914:
adr x0, LFQH_l_.str.132
LFQH_Lloh915:
nop
bl Lpatch + (0xa5a4 - PATCH_BASE)
mov	x1, x0
mov	x0, x19
bl Lpatch + (0xa5f8 - PATCH_BASE)
cbz	x0, LFQH_LBB48_2
mov	x20, x0
LFQH_Lloh916:
adr x0, LFQH_l_.str.133
LFQH_Lloh917:
nop
bl Lpatch + (0xa5a4 - PATCH_BASE)
mov	x21, x0
mov	x0, x20
bl Lpatch + (0xa598 - PATCH_BASE)
mov	x2, x0
LFQH_Lloh918:
adr x3, LFQH_l_.str.114
LFQH_Lloh919:
nop
mov	x0, x19
mov	x1, x21
bl Lpatch + (0xa58c - PATCH_BASE)
cbz	w0, LFQH_LBB48_2
LFQH_Lloh920:
adr x0, LFQH_l_.str.132
LFQH_Lloh921:
nop
bl Lpatch + (0xa5a4 - PATCH_BASE)
mov	x1, x0
LFQH_Lloh922:
adr x2, LFQH_OptionsAppear
LFQH_Lloh923:
nop
LFQH_Lloh924:
adr x3, LFQH_l_.str.114
LFQH_Lloh925:
nop
mov	x0, x19
ldp	x29, x30, [sp, #48]
ldp	x20, x19, [sp, #32]
ldp	x22, x21, [sp, #16]
ldp	x24, x23, [sp], #64
b Lpatch + (0xa58c - PATCH_BASE)
.cfi_endproc
.p2align	2
LFQH_Hook:
.cfi_startproc
stp	x24, x23, [sp, #-64]!
stp	x22, x21, [sp, #16]
stp	x20, x19, [sp, #32]
stp	x29, x30, [sp, #48]
add	x29, sp, #48
.cfi_def_cfa w29, 16
.cfi_offset w30, -8
.cfi_offset w29, -16
.cfi_offset w19, -24
.cfi_offset w20, -32
.cfi_offset w21, -40
.cfi_offset w22, -48
.cfi_offset w23, -56
.cfi_offset w24, -64
mov	x19, x4
mov	x20, x3
mov	x22, x2
mov	x23, x1
bl Lpatch + (0xa5b0 - PATCH_BASE)
cbz	x0, LFQH_LBB49_2
mov	x21, x0
mov	x0, x22
bl Lpatch + (0xa5a4 - PATCH_BASE)
mov	x1, x0
mov	x0, x21
bl Lpatch + (0xa5f8 - PATCH_BASE)
cbz	x0, LFQH_LBB49_3
LFQH_LBB49_2:
ldp	x29, x30, [sp, #48]
ldp	x20, x19, [sp, #32]
ldp	x22, x21, [sp, #16]
ldp	x24, x23, [sp], #64
ret
LFQH_LBB49_3:
mov	x0, x23
bl Lpatch + (0xa5a4 - PATCH_BASE)
mov	x1, x0
mov	x0, x21
mov	w2, #0
mov	x3, x20
bl LHookOwned
cbz	x0, LFQH_LBB49_2
mov	x23, x0
mov	x0, x22
bl Lpatch + (0xa5a4 - PATCH_BASE)
mov	x22, x0
mov	x0, x23
bl Lpatch + (0xa598 - PATCH_BASE)
mov	x2, x0
mov	x0, x21
mov	x1, x22
mov	x3, x20
bl Lpatch + (0xa58c - PATCH_BASE)
cbz	w0, LFQH_LBB49_2
mov	x0, x23
mov	x1, x19
ldp	x29, x30, [sp, #48]
ldp	x20, x19, [sp, #32]
ldp	x22, x21, [sp, #16]
ldp	x24, x23, [sp], #64
b Lpatch + (0xa580 - PATCH_BASE)
.cfi_endproc
.p2align	2
LFQH_PageBottomLayout:
.cfi_startproc
stp	x28, x27, [sp, #-96]!
stp	x26, x25, [sp, #16]
stp	x24, x23, [sp, #32]
stp	x22, x21, [sp, #48]
stp	x20, x19, [sp, #64]
stp	x29, x30, [sp, #80]
add	x29, sp, #80
.cfi_def_cfa w29, 16
.cfi_offset w30, -8
.cfi_offset w29, -16
.cfi_offset w19, -24
.cfi_offset w20, -32
.cfi_offset w21, -40
.cfi_offset w22, -48
.cfi_offset w23, -56
.cfi_offset w24, -64
.cfi_offset w25, -72
.cfi_offset w26, -80
.cfi_offset w27, -88
.cfi_offset w28, -96
mov	x20, x1
mov	x19, x0
LFQH_Lloh926:
adr x0, LFQH_l_.str.60
LFQH_Lloh927:
nop
LFQH_Lloh928:
adr x1, LFQH_l_.str.92
LFQH_Lloh929:
nop
bl	LFQH_Original
mov	x8, x0
mov	x0, x19
mov	x1, x20
blr	x8
LFQH_Lloh930:
adr x1, LFQH_l_.str.261
LFQH_Lloh931:
nop
mov	x0, x19
bl	LFQH_Get
mov	x20, x0
LFQH_Lloh932:
adr x0, LFQH_l_.str.36
LFQH_Lloh933:
nop
bl Lpatch + (0xa5a4 - PATCH_BASE)
mov	x1, x0
mov	x0, x20
bl Lpatch + (0xa5d4 - PATCH_BASE)
cbz	x0, LFQH_LBB50_11
mov	x21, x0
mov	x22, #0
LFQH_Lloh934:
adr x23, LFQH_l_.str.229
LFQH_Lloh935:
nop
LFQH_Lloh936:
adr x24, LFQH_l_.str.59
LFQH_Lloh937:
nop
LFQH_Lloh938:
adr x25, LFQH_l_.str.20
LFQH_Lloh939:
nop
LFQH_LBB50_2:
mov	x0, x23
bl Lpatch + (0xa5a4 - PATCH_BASE)
mov	x1, x0
mov	x0, x20
mov	x2, x22
bl Lpatch + (0xa5d4 - PATCH_BASE)
mov	x26, x0
mov	x1, x24
bl	LFQH_Kind
cmp	x26, #0
ccmp	w0, #0, #4, ne
b.eq	LFQH_LBB50_10
mov	w27, #0
mov	x0, x26
LFQH_LBB50_4:
cmp	x0, x19
b.eq	LFQH_LBB50_7
mov	x1, x25
bl	LFQH_Get
cbz	x0, LFQH_LBB50_10
cmp	w27, #7
add	w27, w27, #1
b.lo	LFQH_LBB50_4
b	LFQH_LBB50_10
LFQH_LBB50_7:
mov	x0, x26
mov	x1, x19
bl	LFQH_ReaderBottomItem
cbz	w0, LFQH_LBB50_9
mov	x0, x26
bl	LFQH_ReaderBottomGlass
b	LFQH_LBB50_10
LFQH_LBB50_9:
mov	x0, x26
bl	LFQH_PageRestore
LFQH_LBB50_10:
add	x22, x22, #1
cmp	x22, x21
b.ne	LFQH_LBB50_2
LFQH_LBB50_11:
ldp	x29, x30, [sp, #80]
ldp	x20, x19, [sp, #64]
ldp	x22, x21, [sp, #48]
ldp	x24, x23, [sp, #32]
ldp	x26, x25, [sp, #16]
ldp	x28, x27, [sp], #96
ret
.cfi_endproc
.p2align	2
LFQH_PageProgressLayout:
.cfi_startproc
stp	x20, x19, [sp, #-32]!
stp	x29, x30, [sp, #16]
add	x29, sp, #16
.cfi_def_cfa w29, 16
.cfi_offset w30, -8
.cfi_offset w29, -16
.cfi_offset w19, -24
.cfi_offset w20, -32
mov	x19, x1
mov	x20, x0
LFQH_Lloh940:
adr x0, LFQH_l_.str.93
LFQH_Lloh941:
nop
LFQH_Lloh942:
adr x1, LFQH_l_.str.94
LFQH_Lloh943:
nop
bl	LFQH_Original
mov	x8, x0
mov	x0, x20
mov	x1, x19
blr	x8
LFQH_Lloh944:
adr x1, LFQH_l_.str.262
LFQH_Lloh945:
nop
mov	x0, x20
bl	LFQH_Get
mov	x19, x0
LFQH_Lloh946:
adr x1, LFQH_l_.str.263
LFQH_Lloh947:
nop
bl	LFQH_Kind
cbz	w0, LFQH_LBB51_2
LFQH_Lloh948:
adr x0, LFQH_l_.str.24
LFQH_Lloh949:
nop
bl Lpatch + (0xa5a4 - PATCH_BASE)
mov	x1, x0
mov	x0, x19
bl Lpatch + (0xa5d4 - PATCH_BASE)
fmov	d4, #6.00000000
fadd	d0, d0, d4
fmov	d4, #-12.00000000
fadd	d2, d2, d4
fmov	d4, #5.00000000
fadd	d1, d1, d4
fmov	d4, #-10.00000000
fadd	d3, d3, d4
mov	x0, x19
mov	w1, #1
ldp	x29, x30, [sp, #16]
ldp	x20, x19, [sp], #32
b	LFQH_ApplySurface
LFQH_LBB51_2:
ldp	x29, x30, [sp, #16]
ldp	x20, x19, [sp], #32
ret
.cfi_endproc
.p2align	2
LFQH_PageDivertLayout:
.cfi_startproc
stp	x20, x19, [sp, #-32]!
stp	x29, x30, [sp, #16]
add	x29, sp, #16
.cfi_def_cfa w29, 16
.cfi_offset w30, -8
.cfi_offset w29, -16
.cfi_offset w19, -24
.cfi_offset w20, -32
mov	x20, x1
mov	x19, x0
LFQH_Lloh950:
adr x0, LFQH_l_.str.95
LFQH_Lloh951:
nop
LFQH_Lloh952:
adr x1, LFQH_l_.str.96
LFQH_Lloh953:
nop
bl	LFQH_Original
mov	x8, x0
mov	x0, x19
mov	x1, x20
blr	x8
LFQH_Lloh954:
adr x1, LFQH_l_.str.60
LFQH_Lloh955:
nop
mov	x0, x19
bl	LFQH_HasAncestor
cbz	w0, LFQH_LBB52_3
LFQH_Lloh956:
adr x1, LFQH_l_.str.264
LFQH_Lloh957:
nop
mov	x0, x19
bl	LFQH_Get
LFQH_Lloh958:
adr x1, LFQH_l_.str.240
LFQH_Lloh959:
nop
bl	LFQH_Get
LFQH_Lloh960:
adr x1, LFQH_l_.str.265
LFQH_Lloh961:
nop
bl	LFQH_Equal
cbz	w0, LFQH_LBB52_3
mov	x0, x19
ldp	x29, x30, [sp, #16]
ldp	x20, x19, [sp], #32
b	LFQH_ReaderBottomGlass
LFQH_LBB52_3:
mov	x0, x19
ldp	x29, x30, [sp, #16]
ldp	x20, x19, [sp], #32
b	LFQH_PageRestore
.cfi_endproc
.p2align	2
LFQH_PageGiftLayout:
.cfi_startproc
stp	x20, x19, [sp, #-32]!
stp	x29, x30, [sp, #16]
add	x29, sp, #16
.cfi_def_cfa w29, 16
.cfi_offset w30, -8
.cfi_offset w29, -16
.cfi_offset w19, -24
.cfi_offset w20, -32
mov	x20, x1
mov	x19, x0
LFQH_Lloh962:
adr x0, LFQH_l_.str.97
LFQH_Lloh963:
nop
LFQH_Lloh964:
adr x1, LFQH_l_.str.98
LFQH_Lloh965:
nop
bl	LFQH_Original
mov	x8, x0
mov	x0, x19
mov	x1, x20
blr	x8
LFQH_Lloh966:
adr x1, LFQH_l_.str.266
LFQH_Lloh967:
nop
mov	x0, x19
bl	LFQH_Get
cbz	x0, LFQH_LBB53_2
LFQH_Lloh968:
adr x1, LFQH_l_.str.267
LFQH_Lloh969:
nop
ldp	x29, x30, [sp, #16]
ldp	x20, x19, [sp], #32
b	LFQH_PageStyle
LFQH_LBB53_2:
mov	x0, x19
ldp	x29, x30, [sp, #16]
ldp	x20, x19, [sp], #32
b	LFQH_PageRestore
.cfi_endproc
.p2align	2
LFQH_PageBookGiftLayout:
.cfi_startproc
stp	x20, x19, [sp, #-32]!
stp	x29, x30, [sp, #16]
add	x29, sp, #16
.cfi_def_cfa w29, 16
.cfi_offset w30, -8
.cfi_offset w29, -16
.cfi_offset w19, -24
.cfi_offset w20, -32
mov	x19, x1
mov	x20, x0
LFQH_Lloh970:
adr x0, LFQH_l_.str.99
LFQH_Lloh971:
nop
LFQH_Lloh972:
adr x1, LFQH_l_.str.100
LFQH_Lloh973:
nop
bl	LFQH_Original
mov	x8, x0
mov	x0, x20
mov	x1, x19
blr	x8
LFQH_Lloh974:
adr x1, LFQH_l_.str.267
LFQH_Lloh975:
nop
mov	x0, x20
ldp	x29, x30, [sp, #16]
ldp	x20, x19, [sp], #32
b	LFQH_PageStyle
.cfi_endproc
.p2align	2
LFQH_PageDiscussLayout:
.cfi_startproc
stp	x20, x19, [sp, #-32]!
stp	x29, x30, [sp, #16]
add	x29, sp, #16
.cfi_def_cfa w29, 16
.cfi_offset w30, -8
.cfi_offset w29, -16
.cfi_offset w19, -24
.cfi_offset w20, -32
mov	x20, x1
mov	x19, x0
LFQH_Lloh976:
adr x0, LFQH_l_.str.101
LFQH_Lloh977:
nop
LFQH_Lloh978:
adr x1, LFQH_l_.str.102
LFQH_Lloh979:
nop
bl	LFQH_Original
mov	x8, x0
mov	x0, x19
mov	x1, x20
blr	x8
LFQH_Lloh980:
adr x1, LFQH_l_.str.103
LFQH_Lloh981:
nop
mov	x0, x19
bl	LFQH_HasAncestor
cbz	w0, LFQH_LBB55_2
mov	x0, x19
ldp	x29, x30, [sp, #16]
ldp	x20, x19, [sp], #32
b	LFQH_PageRestore
LFQH_LBB55_2:
LFQH_Lloh982:
adr x1, LFQH_l_.str.268
LFQH_Lloh983:
nop
mov	x0, x19
ldp	x29, x30, [sp, #16]
ldp	x20, x19, [sp], #32
b	LFQH_PageStyle
.cfi_endproc
.p2align	2
LFQH_PageDiscussButtonLayout:
.cfi_startproc
stp	x20, x19, [sp, #-32]!
stp	x29, x30, [sp, #16]
add	x29, sp, #16
.cfi_def_cfa w29, 16
.cfi_offset w30, -8
.cfi_offset w29, -16
.cfi_offset w19, -24
.cfi_offset w20, -32
mov	x20, x1
mov	x19, x0
LFQH_Lloh984:
adr x0, LFQH_l_.str.103
LFQH_Lloh985:
nop
LFQH_Lloh986:
adr x1, LFQH_l_.str.104
LFQH_Lloh987:
nop
bl	LFQH_Original
mov	x8, x0
mov	x0, x19
mov	x1, x20
blr	x8
LFQH_Lloh988:
adr x1, LFQH_l_.str.101
LFQH_Lloh989:
nop
mov	x0, x19
bl	LFQH_HasAncestor
cbz	w0, LFQH_LBB56_2
mov	x0, x19
ldp	x29, x30, [sp, #16]
ldp	x20, x19, [sp], #32
b	LFQH_PageRestore
LFQH_LBB56_2:
LFQH_Lloh990:
adr x1, LFQH_l_.str.268
LFQH_Lloh991:
nop
mov	x0, x19
ldp	x29, x30, [sp, #16]
ldp	x20, x19, [sp], #32
b	LFQH_PageStyle
.cfi_endproc
.p2align	2
LFQH_PageShelfTabLayout:
.cfi_startproc
stp	x20, x19, [sp, #-32]!
stp	x29, x30, [sp, #16]
add	x29, sp, #16
.cfi_def_cfa w29, 16
.cfi_offset w30, -8
.cfi_offset w29, -16
.cfi_offset w19, -24
.cfi_offset w20, -32
mov	x19, x1
mov	x20, x0
LFQH_Lloh992:
adr x0, LFQH_l_.str.105
LFQH_Lloh993:
nop
LFQH_Lloh994:
adr x1, LFQH_l_.str.106
LFQH_Lloh995:
nop
bl	LFQH_Original
mov	x8, x0
mov	x0, x20
mov	x1, x19
blr	x8
LFQH_Lloh996:
adr x1, LFQH_l_.str.90
LFQH_Lloh997:
nop
mov	x0, x20
bl	LFQH_Get
mov	x19, x0
LFQH_Lloh998:
adr x1, LFQH_l_.str.211
LFQH_Lloh999:
nop
bl	LFQH_BoolProp
mov	x2, x0
mov	x0, x20
mov	x1, x19
ldp	x29, x30, [sp, #16]
ldp	x20, x19, [sp], #32
b	LFQH_ShelfTabStyle
.cfi_endproc
.p2align	2
LFQH_PageShelfTabReload:
.cfi_startproc
stp	x22, x21, [sp, #-48]!
stp	x20, x19, [sp, #16]
stp	x29, x30, [sp, #32]
add	x29, sp, #32
.cfi_def_cfa w29, 16
.cfi_offset w30, -8
.cfi_offset w29, -16
.cfi_offset w19, -24
.cfi_offset w20, -32
.cfi_offset w21, -40
.cfi_offset w22, -48
mov	x19, x2
mov	x20, x1
mov	x21, x0
LFQH_Lloh1000:
adr x0, LFQH_l_.str.105
LFQH_Lloh1001:
nop
LFQH_Lloh1002:
adr x1, LFQH_l_.str.108
LFQH_Lloh1003:
nop
bl	LFQH_Original
mov	x8, x0
mov	x0, x21
mov	x1, x20
mov	x2, x19
blr	x8
LFQH_Lloh1004:
adr x1, LFQH_l_.str.211
LFQH_Lloh1005:
nop
mov	x0, x19
bl	LFQH_BoolProp
mov	x2, x0
mov	x0, x21
mov	x1, x19
ldp	x29, x30, [sp, #32]
ldp	x20, x19, [sp, #16]
ldp	x22, x21, [sp], #48
b	LFQH_ShelfTabStyle
.cfi_endproc
.p2align	2
LFQH_PageShelfFilterLayout:
.cfi_startproc
stp	x20, x19, [sp, #-32]!
stp	x29, x30, [sp, #16]
add	x29, sp, #16
.cfi_def_cfa w29, 16
.cfi_offset w30, -8
.cfi_offset w29, -16
.cfi_offset w19, -24
.cfi_offset w20, -32
mov	x19, x1
mov	x20, x0
LFQH_Lloh1006:
adr x0, LFQH_l_.str.110
LFQH_Lloh1007:
nop
LFQH_Lloh1008:
adr x1, LFQH_l_.str.111
LFQH_Lloh1009:
nop
bl	LFQH_Original
mov	x8, x0
mov	x0, x20
mov	x1, x19
blr	x8
mov	x0, x20
ldp	x29, x30, [sp, #16]
ldp	x20, x19, [sp], #32
b	LFQH_ShelfFilterStyle
.cfi_endproc
.p2align	2
LFQH_PageShelfFilterAppearance:
.cfi_startproc
stp	x22, x21, [sp, #-48]!
stp	x20, x19, [sp, #16]
stp	x29, x30, [sp, #32]
add	x29, sp, #32
.cfi_def_cfa w29, 16
.cfi_offset w30, -8
.cfi_offset w29, -16
.cfi_offset w19, -24
.cfi_offset w20, -32
.cfi_offset w21, -40
.cfi_offset w22, -48
mov	x19, x2
mov	x20, x1
mov	x21, x0
LFQH_Lloh1010:
adr x0, LFQH_l_.str.110
LFQH_Lloh1011:
nop
LFQH_Lloh1012:
adr x1, LFQH_l_.str.113
LFQH_Lloh1013:
nop
bl	LFQH_Original
mov	x8, x0
mov	x0, x21
mov	x1, x20
mov	x2, x19
blr	x8
mov	x0, x21
ldp	x29, x30, [sp, #32]
ldp	x20, x19, [sp, #16]
ldp	x22, x21, [sp], #48
b	LFQH_ShelfFilterStyle
.cfi_endproc
.p2align	2
LFQH_PageShelfFilterBackground:
.cfi_startproc
stp	x22, x21, [sp, #-48]!
stp	x20, x19, [sp, #16]
stp	x29, x30, [sp, #32]
add	x29, sp, #32
.cfi_def_cfa w29, 16
.cfi_offset w30, -8
.cfi_offset w29, -16
.cfi_offset w19, -24
.cfi_offset w20, -32
.cfi_offset w21, -40
.cfi_offset w22, -48
mov	x19, x2
mov	x20, x1
mov	x21, x0
LFQH_Lloh1014:
adr x0, LFQH_l_.str.110
LFQH_Lloh1015:
nop
LFQH_Lloh1016:
adr x1, LFQH_l_.str.116
LFQH_Lloh1017:
nop
bl	LFQH_Original
mov	x8, x0
mov	x0, x21
mov	x1, x20
mov	x2, x19
blr	x8
mov	x0, x21
ldp	x29, x30, [sp, #32]
ldp	x20, x19, [sp, #16]
ldp	x22, x21, [sp], #48
b	LFQH_ShelfFilterStyle
.cfi_endproc
.p2align	2
LFQH_PageProfileBarLayout:
.cfi_startproc
stp	x20, x19, [sp, #-32]!
stp	x29, x30, [sp, #16]
add	x29, sp, #16
.cfi_def_cfa w29, 16
.cfi_offset w30, -8
.cfi_offset w29, -16
.cfi_offset w19, -24
.cfi_offset w20, -32
mov	x19, x1
mov	x20, x0
LFQH_Lloh1018:
adr x0, LFQH_l_.str.117
LFQH_Lloh1019:
nop
LFQH_Lloh1020:
adr x1, LFQH_l_.str.118
LFQH_Lloh1021:
nop
bl	LFQH_Original
mov	x8, x0
mov	x0, x20
mov	x1, x19
blr	x8
LFQH_Lloh1022:
adr x1, LFQH_l_.str.10
LFQH_Lloh1023:
nop
mov	x0, x20
bl	LFQH_Get
ldp	x29, x30, [sp, #16]
ldp	x20, x19, [sp], #32
b	LFQH_FQHHeader
.cfi_endproc
.p2align	2
LFQH_PageProfileEntryLayout:
.cfi_startproc
stp	x20, x19, [sp, #-32]!
stp	x29, x30, [sp, #16]
add	x29, sp, #16
.cfi_def_cfa w29, 16
.cfi_offset w30, -8
.cfi_offset w29, -16
.cfi_offset w19, -24
.cfi_offset w20, -32
mov	x20, x1
mov	x19, x0
LFQH_Lloh1024:
adr x0, LFQH_l_.str.119
LFQH_Lloh1025:
nop
LFQH_Lloh1026:
adr x1, LFQH_l_.str.120
LFQH_Lloh1027:
nop
bl	LFQH_Original
mov	x8, x0
mov	x0, x19
mov	x1, x20
blr	x8
mov	x0, x19
bl	LFQH_ProfileEntry
cbz	w0, LFQH_LBB63_2
LFQH_Lloh1028:
adr x1, LFQH_l_.str.273
LFQH_Lloh1029:
nop
mov	x0, x19
ldp	x29, x30, [sp, #16]
ldp	x20, x19, [sp], #32
b	LFQH_PageStyle
LFQH_LBB63_2:
mov	x0, x19
ldp	x29, x30, [sp, #16]
ldp	x20, x19, [sp], #32
b	LFQH_PageRestore
.cfi_endproc
.p2align	2
LFQH_PageProfileEntry621Layout:
.cfi_startproc
stp	x20, x19, [sp, #-32]!
stp	x29, x30, [sp, #16]
add	x29, sp, #16
.cfi_def_cfa w29, 16
.cfi_offset w30, -8
.cfi_offset w29, -16
.cfi_offset w19, -24
.cfi_offset w20, -32
mov	x20, x1
mov	x19, x0
LFQH_Lloh1030:
adr x0, LFQH_l_.str.121
LFQH_Lloh1031:
nop
LFQH_Lloh1032:
adr x1, LFQH_l_.str.122
LFQH_Lloh1033:
nop
bl	LFQH_Original
mov	x8, x0
mov	x0, x19
mov	x1, x20
blr	x8
mov	x0, x19
bl	LFQH_ProfileEntry
cbz	w0, LFQH_LBB64_2
LFQH_Lloh1034:
adr x1, LFQH_l_.str.273
LFQH_Lloh1035:
nop
mov	x0, x19
ldp	x29, x30, [sp, #16]
ldp	x20, x19, [sp], #32
b	LFQH_PageStyle
LFQH_LBB64_2:
mov	x0, x19
ldp	x29, x30, [sp, #16]
ldp	x20, x19, [sp], #32
b	LFQH_PageRestore
.cfi_endproc
.p2align	2
LFQH_MiniGameSetup:
.cfi_startproc
stp	x20, x19, [sp, #-32]!
stp	x29, x30, [sp, #16]
add	x29, sp, #16
.cfi_def_cfa w29, 16
.cfi_offset w30, -8
.cfi_offset w29, -16
.cfi_offset w19, -24
.cfi_offset w20, -32
mov	x19, x1
mov	x20, x0
LFQH_Lloh1036:
adr x0, LFQH_l_.str.78
LFQH_Lloh1037:
nop
LFQH_Lloh1038:
adr x1, LFQH_l_.str.124
LFQH_Lloh1039:
nop
bl	LFQH_Original
mov	x8, x0
mov	x0, x20
mov	x1, x19
blr	x8
mov	x0, x20
ldp	x29, x30, [sp, #16]
ldp	x20, x19, [sp], #32
b	LFQH_FQHPageFilterMiniGame
.cfi_endproc
.p2align	2
LFQH_TabSetItems:
.cfi_startproc
stp	x24, x23, [sp, #-64]!
stp	x22, x21, [sp, #16]
stp	x20, x19, [sp, #32]
stp	x29, x30, [sp, #48]
add	x29, sp, #48
.cfi_def_cfa w29, 16
.cfi_offset w30, -8
.cfi_offset w29, -16
.cfi_offset w19, -24
.cfi_offset w20, -32
.cfi_offset w21, -40
.cfi_offset w22, -48
.cfi_offset w23, -56
.cfi_offset w24, -64
mov	x21, x2
mov	x20, x1
mov	x19, x0
LFQH_Lloh1040:
adr x1, LFQH_TabBusyKey
LFQH_Lloh1041:
nop
bl Lpatch + (0xa628 - PATCH_BASE)
cbz	x0, LFQH_LBB66_2
LFQH_Lloh1042:
adr x0, LFQH_l_.str.125
LFQH_Lloh1043:
nop
LFQH_Lloh1044:
adr x1, LFQH_l_.str.127
LFQH_Lloh1045:
nop
bl	LFQH_Original
mov	x3, x0
mov	x0, x19
mov	x1, x20
mov	x2, x21
ldp	x29, x30, [sp, #48]
ldp	x20, x19, [sp, #32]
ldp	x22, x21, [sp, #16]
ldp	x24, x23, [sp], #64
br	x3
LFQH_LBB66_2:
LFQH_Lloh1046:
adr x1, LFQH_TabOriginalKey
LFQH_Lloh1047:
nop
mov	x0, x19
mov	x2, x21
mov	w3, #1
bl Lpatch + (0xa634 - PATCH_BASE)
LFQH_Lloh1048:
adr x22, LFQH_TabBusyKey
LFQH_Lloh1049:
nop
mov	x0, x19
mov	x1, x22
mov	x2, x19
mov	x3, #0
bl Lpatch + (0xa634 - PATCH_BASE)
LFQH_Lloh1050:
adr x0, LFQH_l_.str.125
LFQH_Lloh1051:
nop
LFQH_Lloh1052:
adr x1, LFQH_l_.str.127
LFQH_Lloh1053:
nop
bl	LFQH_Original
mov	x23, x0
mov	x0, x21
bl	LFQH_FQHPageTabItems
mov	x2, x0
mov	x0, x19
mov	x1, x20
blr	x23
mov	x0, x19
mov	x1, x22
mov	x2, #0
mov	x3, #0
ldp	x29, x30, [sp, #48]
ldp	x20, x19, [sp, #32]
ldp	x22, x21, [sp, #16]
ldp	x24, x23, [sp], #64
b Lpatch + (0xa634 - PATCH_BASE)
.cfi_endproc
.p2align	2
LFQH_TabSetItemsAnimated:
.cfi_startproc
stp	x24, x23, [sp, #-64]!
stp	x22, x21, [sp, #16]
stp	x20, x19, [sp, #32]
stp	x29, x30, [sp, #48]
add	x29, sp, #48
.cfi_def_cfa w29, 16
.cfi_offset w30, -8
.cfi_offset w29, -16
.cfi_offset w19, -24
.cfi_offset w20, -32
.cfi_offset w21, -40
.cfi_offset w22, -48
.cfi_offset w23, -56
.cfi_offset w24, -64
mov	x19, x3
mov	x22, x2
mov	x21, x1
mov	x20, x0
LFQH_Lloh1054:
adr x1, LFQH_TabBusyKey
LFQH_Lloh1055:
nop
bl Lpatch + (0xa628 - PATCH_BASE)
cbz	x0, LFQH_LBB67_2
LFQH_Lloh1056:
adr x0, LFQH_l_.str.125
LFQH_Lloh1057:
nop
LFQH_Lloh1058:
adr x1, LFQH_l_.str.129
LFQH_Lloh1059:
nop
bl	LFQH_Original
mov	x4, x0
mov	x0, x20
mov	x1, x21
mov	x2, x22
mov	x3, x19
ldp	x29, x30, [sp, #48]
ldp	x20, x19, [sp, #32]
ldp	x22, x21, [sp, #16]
ldp	x24, x23, [sp], #64
br	x4
LFQH_LBB67_2:
LFQH_Lloh1060:
adr x1, LFQH_TabOriginalKey
LFQH_Lloh1061:
nop
mov	x0, x20
mov	x2, x22
mov	w3, #1
bl Lpatch + (0xa634 - PATCH_BASE)
LFQH_Lloh1062:
adr x23, LFQH_TabBusyKey
LFQH_Lloh1063:
nop
mov	x0, x20
mov	x1, x23
mov	x2, x20
mov	x3, #0
bl Lpatch + (0xa634 - PATCH_BASE)
LFQH_Lloh1064:
adr x0, LFQH_l_.str.125
LFQH_Lloh1065:
nop
LFQH_Lloh1066:
adr x1, LFQH_l_.str.129
LFQH_Lloh1067:
nop
bl	LFQH_Original
mov	x24, x0
mov	x0, x22
bl	LFQH_FQHPageTabItems
mov	x2, x0
mov	x0, x20
mov	x1, x21
mov	x3, x19
blr	x24
mov	x0, x20
mov	x1, x23
mov	x2, #0
mov	x3, #0
ldp	x29, x30, [sp, #48]
ldp	x20, x19, [sp, #32]
ldp	x22, x21, [sp, #16]
ldp	x24, x23, [sp], #64
b Lpatch + (0xa634 - PATCH_BASE)
.cfi_endproc
.p2align	2
LFQH_OptionsAppear:
.cfi_startproc
stp	d9, d8, [sp, #-80]!
stp	x24, x23, [sp, #16]
stp	x22, x21, [sp, #32]
stp	x20, x19, [sp, #48]
stp	x29, x30, [sp, #64]
add	x29, sp, #64
.cfi_def_cfa w29, 16
.cfi_offset w30, -8
.cfi_offset w29, -16
.cfi_offset w19, -24
.cfi_offset w20, -32
.cfi_offset w21, -40
.cfi_offset w22, -48
.cfi_offset w23, -56
.cfi_offset w24, -64
.cfi_offset b8, -72
.cfi_offset b9, -80
mov	x20, x2
mov	x21, x1
mov	x19, x0
LFQH_Lloh1068:
adr x0, LFQH_l_.str.131
LFQH_Lloh1069:
nop
LFQH_Lloh1070:
adr x1, LFQH_l_.str.133
LFQH_Lloh1071:
nop
bl	LFQH_Original
mov	x8, x0
mov	x0, x19
mov	x1, x21
mov	x2, x20
blr	x8
LFQH_Lloh1072:
adr x1, LFQH_ToggleShortKey
LFQH_Lloh1073:
nop
mov	x0, x19
bl Lpatch + (0xa628 - PATCH_BASE)
mov	x21, x0
LFQH_Lloh1074:
adr x1, LFQH_ToggleMallKey
LFQH_Lloh1075:
nop
mov	x0, x19
bl Lpatch + (0xa628 - PATCH_BASE)
cbz	x21, LFQH_LBB68_2
mov	x20, x0
LFQH_Lloh1076:
adr x19, LFQH_l_.str.282
LFQH_Lloh1077:
nop
mov	x0, x19
bl Lpatch + (0xa5a4 - PATCH_BASE)
mov	x22, x0
LFQH_Lloh1078:
adr x0, LFQH_l_.str.256
LFQH_Lloh1079:
nop
bl	LFQH_DefaultEnabled
mov	x2, x0
mov	x0, x21
mov	x1, x22
mov	w3, #0
bl Lpatch + (0xa5d4 - PATCH_BASE)
mov	x0, x19
bl Lpatch + (0xa5a4 - PATCH_BASE)
mov	x19, x0
LFQH_Lloh1080:
adr x0, LFQH_l_.str.257
LFQH_Lloh1081:
nop
bl	LFQH_DefaultEnabled
mov	x2, x0
mov	x0, x20
mov	x1, x19
mov	w3, #0
ldp	x29, x30, [sp, #64]
ldp	x20, x19, [sp, #48]
ldp	x22, x21, [sp, #32]
ldp	x24, x23, [sp, #16]
ldp	d9, d8, [sp], #80
b Lpatch + (0xa5d4 - PATCH_BASE)
LFQH_LBB68_2:
LFQH_Lloh1082:
adr x1, LFQH_l_.str.283
LFQH_Lloh1083:
nop
mov	x0, x19
bl	LFQH_Get
mov	w1, #5
bl	LFQH_FindTable
cbz	x0, LFQH_LBB68_4
mov	x20, x0
LFQH_Lloh1084:
adr x1, LFQH_l_.str.284
LFQH_Lloh1085:
nop
bl	LFQH_Get
cbz	x0, LFQH_LBB68_5
LFQH_LBB68_4:
ldp	x29, x30, [sp, #64]
ldp	x20, x19, [sp, #48]
ldp	x22, x21, [sp, #32]
ldp	x24, x23, [sp, #16]
ldp	d9, d8, [sp], #80
ret
LFQH_LBB68_5:
LFQH_Lloh1086:
adr x0, LFQH_l_.str.290
LFQH_Lloh1087:
nop
bl Lpatch + (0xa5b0 - PATCH_BASE)
mov	x21, x0
cbnz	x0, LFQH_LBB68_8
LFQH_Lloh1088:
adr x0, LFQH_l_.str.291
LFQH_Lloh1089:
nop
bl Lpatch + (0xa5b0 - PATCH_BASE)
LFQH_Lloh1090:
adr x1, LFQH_l_.str.290
LFQH_Lloh1091:
nop
mov	x2, #0
bl Lpatch + (0xa61c - PATCH_BASE)
cbz	x0, LFQH_LBB68_4
mov	x21, x0
LFQH_Lloh1092:
adr x0, LFQH_l_.str.292
LFQH_Lloh1093:
nop
bl Lpatch + (0xa5a4 - PATCH_BASE)
mov	x1, x0
LFQH_Lloh1094:
adr x2, LFQH_ToggleChanged
LFQH_Lloh1095:
nop
LFQH_Lloh1096:
adr x3, LFQH_l_.str.109
LFQH_Lloh1097:
nop
mov	x0, x21
bl Lpatch + (0xa58c - PATCH_BASE)
mov	x0, x21
bl Lpatch + (0xa610 - PATCH_BASE)
LFQH_LBB68_8:
LFQH_Lloh1098:
adr x0, LFQH_l_.str.160
LFQH_Lloh1099:
nop
bl Lpatch + (0xa5a4 - PATCH_BASE)
mov	x1, x0
mov	x0, x21
bl Lpatch + (0xa5d4 - PATCH_BASE)
mov	x21, x0
LFQH_Lloh1100:
adr x0, LFQH_l_.str.285
LFQH_Lloh1101:
nop
bl Lpatch + (0xa5a4 - PATCH_BASE)
mov	x1, x0
mov	x0, x21
bl Lpatch + (0xa5d4 - PATCH_BASE)
cbz	x0, LFQH_LBB68_4
mov	x21, x0
LFQH_Lloh1102:
adr x0, LFQH_l_.str.23
LFQH_Lloh1103:
nop
bl Lpatch + (0xa5b0 - PATCH_BASE)
mov	x22, x0
LFQH_Lloh1104:
adr x0, LFQH_l_.str.160
LFQH_Lloh1105:
nop
bl Lpatch + (0xa5a4 - PATCH_BASE)
mov	x1, x0
mov	x0, x22
bl Lpatch + (0xa5d4 - PATCH_BASE)
mov	x22, x0
LFQH_Lloh1106:
adr x0, LFQH_l_.str.285
LFQH_Lloh1107:
nop
bl Lpatch + (0xa5a4 - PATCH_BASE)
mov	x1, x0
mov	x0, x22
bl Lpatch + (0xa5d4 - PATCH_BASE)
cbz	x0, LFQH_LBB68_14
mov	x22, x0
LFQH_Lloh1108:
adr x0, LFQH_l_.str.24
LFQH_Lloh1109:
nop
bl Lpatch + (0xa5a4 - PATCH_BASE)
mov	x1, x0
mov	x0, x20
bl Lpatch + (0xa5d4 - PATCH_BASE)
mov.16b	v8, v2
LFQH_Lloh1110:
adr x0, LFQH_l_.str.173
LFQH_Lloh1111:
nop
bl Lpatch + (0xa5a4 - PATCH_BASE)
mov	x1, x0
mov	x8, #4636455816377925632
fmov	d3, x8
fmov	d0, xzr
fmov	d1, xzr
mov	x0, x22
mov.16b	v2, v8
bl Lpatch + (0xa5d4 - PATCH_BASE)
LFQH_Lloh1112:
adr x0, LFQH_l_.str.187
LFQH_Lloh1113:
nop
bl Lpatch + (0xa5a4 - PATCH_BASE)
mov	x23, x0
LFQH_Lloh1114:
adr x0, LFQH_l_.str.49
LFQH_Lloh1115:
nop
bl Lpatch + (0xa5b0 - PATCH_BASE)
mov	x24, x0
LFQH_Lloh1116:
adr x0, LFQH_l_.str.168
LFQH_Lloh1117:
nop
bl Lpatch + (0xa5a4 - PATCH_BASE)
mov	x1, x0
mov	x0, x24
bl Lpatch + (0xa5d4 - PATCH_BASE)
mov	x2, x0
mov	x0, x22
mov	x1, x23
bl Lpatch + (0xa5d4 - PATCH_BASE)
LFQH_Lloh1118:
adr x0, LFQH_l_.str.256
LFQH_Lloh1119:
nop
bl	LFQH_DefaultEnabled
mov	x3, x0
LFQH_Lloh1120:
adr x1, LFQH_l_.str.286
LFQH_Lloh1121:
nop
fmov	d0, #8.00000000
mov	x0, x22
mov	w2, #1
mov	x4, x21
bl	LFQH_ToggleRow
mov	x23, x0
LFQH_Lloh1122:
adr x0, LFQH_l_.str.257
LFQH_Lloh1123:
nop
bl	LFQH_DefaultEnabled
mov	x3, x0
LFQH_Lloh1124:
adr x1, LFQH_l_.str.287
LFQH_Lloh1125:
nop
mov	x8, #4632233691727265792
fmov	d0, x8
mov	x0, x22
mov	w2, #2
mov	x4, x21
bl	LFQH_ToggleRow
cbz	x23, LFQH_LBB68_13
mov	x24, x0
cbz	x0, LFQH_LBB68_13
LFQH_Lloh1126:
adr x1, LFQH_ToggleObserverKey
LFQH_Lloh1127:
nop
mov	x0, x19
mov	x2, x21
mov	w3, #1
bl Lpatch + (0xa634 - PATCH_BASE)
LFQH_Lloh1128:
adr x1, LFQH_ToggleShortKey
LFQH_Lloh1129:
nop
mov	x0, x19
mov	x2, x23
mov	w3, #1
bl Lpatch + (0xa634 - PATCH_BASE)
LFQH_Lloh1130:
adr x1, LFQH_ToggleMallKey
LFQH_Lloh1131:
nop
mov	x0, x19
mov	x2, x24
mov	w3, #1
bl Lpatch + (0xa634 - PATCH_BASE)
LFQH_Lloh1132:
adr x1, LFQH_OptionsMarkKey
LFQH_Lloh1133:
nop
mov	x0, x19
mov	x2, x22
mov	w3, #1
bl Lpatch + (0xa634 - PATCH_BASE)
LFQH_Lloh1134:
adr x0, LFQH_l_.str.288
LFQH_Lloh1135:
nop
bl Lpatch + (0xa5a4 - PATCH_BASE)
mov	x1, x0
mov	x0, x20
mov	x2, x22
bl Lpatch + (0xa5d4 - PATCH_BASE)
LFQH_LBB68_13:
LFQH_Lloh1136:
adr x19, LFQH_l_.str.58
LFQH_Lloh1137:
nop
mov	x0, x19
bl Lpatch + (0xa5a4 - PATCH_BASE)
mov	x1, x0
mov	x0, x22
bl Lpatch + (0xa5d4 - PATCH_BASE)
mov	x0, x19
b	LFQH_LBB68_15
LFQH_LBB68_14:
LFQH_Lloh1138:
adr x0, LFQH_l_.str.58
LFQH_Lloh1139:
nop
LFQH_LBB68_15:
bl Lpatch + (0xa5a4 - PATCH_BASE)
mov	x1, x0
mov	x0, x21
ldp	x29, x30, [sp, #64]
ldp	x20, x19, [sp, #48]
ldp	x22, x21, [sp, #32]
ldp	x24, x23, [sp, #16]
ldp	d9, d8, [sp], #80
b Lpatch + (0xa5d4 - PATCH_BASE)
.cfi_endproc
.p2align	2
LFQH_FQHInstall:
.cfi_startproc
stp	x24, x23, [sp, #-64]!
stp	x22, x21, [sp, #16]
stp	x20, x19, [sp, #32]
stp	x29, x30, [sp, #48]
add	x29, sp, #48
.cfi_def_cfa w29, 16
.cfi_offset w30, -8
.cfi_offset w29, -16
.cfi_offset w19, -24
.cfi_offset w20, -32
.cfi_offset w21, -40
.cfi_offset w22, -48
.cfi_offset w23, -56
.cfi_offset w24, -64
bl	LFQH_FQHGlassAvailable
cbz	w0, LFQH_LBB69_2
LFQH_Lloh1140:
adr x0, LFQH_l_.str.46
LFQH_Lloh1141:
nop
LFQH_Lloh1142:
adr x19, LFQH_l_.str.91
LFQH_Lloh1143:
nop
LFQH_Lloh1144:
adr x2, LFQH_l_.str.134
LFQH_Lloh1145:
nop
LFQH_Lloh1146:
adr x20, LFQH_l_.str.9
LFQH_Lloh1147:
nop
LFQH_Lloh1148:
adr x4, LFQH_ListenLayout
LFQH_Lloh1149:
nop
mov	x1, x19
mov	x3, x20
bl	LFQH_Hook
LFQH_Lloh1150:
adr x22, LFQH_l_.str.61
LFQH_Lloh1151:
nop
LFQH_Lloh1152:
adr x2, LFQH_l_.str.135
LFQH_Lloh1153:
nop
LFQH_Lloh1154:
adr x4, LFQH_SpeechLayout
LFQH_Lloh1155:
nop
mov	x0, x22
mov	x1, x19
mov	x3, x20
bl	LFQH_Hook
LFQH_Lloh1156:
adr x1, LFQH_l_.str.136
LFQH_Lloh1157:
nop
LFQH_Lloh1158:
adr x2, LFQH_l_.str.137
LFQH_Lloh1159:
nop
LFQH_Lloh1160:
adr x21, LFQH_l_.str.109
LFQH_Lloh1161:
nop
LFQH_Lloh1162:
adr x4, LFQH_SpeechTheme
LFQH_Lloh1163:
nop
mov	x0, x22
mov	x3, x21
bl	LFQH_Hook
LFQH_Lloh1164:
adr x22, LFQH_l_.str.7
LFQH_Lloh1165:
nop
LFQH_Lloh1166:
adr x1, LFQH_l_.str.8
LFQH_Lloh1167:
nop
LFQH_Lloh1168:
adr x2, LFQH_l_.str.138
LFQH_Lloh1169:
nop
LFQH_Lloh1170:
adr x4, LFQH_HomeLayout
LFQH_Lloh1171:
nop
mov	x0, x22
mov	x3, x20
bl	LFQH_Hook
LFQH_Lloh1172:
adr x1, LFQH_l_.str.132
LFQH_Lloh1173:
nop
LFQH_Lloh1174:
adr x2, LFQH_l_.str.139
LFQH_Lloh1175:
nop
LFQH_Lloh1176:
adr x3, LFQH_l_.str.114
LFQH_Lloh1177:
nop
LFQH_Lloh1178:
adr x4, LFQH_HomeAppear
LFQH_Lloh1179:
nop
mov	x0, x22
bl	LFQH_Hook
LFQH_Lloh1180:
adr x22, LFQH_l_.str.25
LFQH_Lloh1181:
nop
LFQH_Lloh1182:
adr x2, LFQH_l_.str.140
LFQH_Lloh1183:
nop
LFQH_Lloh1184:
adr x4, LFQH_CategoryLayout
LFQH_Lloh1185:
nop
mov	x0, x22
mov	x1, x19
mov	x3, x20
bl	LFQH_Hook
LFQH_Lloh1186:
adr x1, LFQH_l_.str.141
LFQH_Lloh1187:
nop
LFQH_Lloh1188:
adr x2, LFQH_l_.str.142
LFQH_Lloh1189:
nop
LFQH_Lloh1190:
adr x23, LFQH_l_.str.143
LFQH_Lloh1191:
nop
LFQH_Lloh1192:
adr x4, LFQH_CategoryColor
LFQH_Lloh1193:
nop
mov	x0, x22
mov	x3, x23
bl	LFQH_Hook
LFQH_Lloh1194:
adr x0, LFQH_l_.str.144
LFQH_Lloh1195:
nop
LFQH_Lloh1196:
adr x1, LFQH_l_.str.145
LFQH_Lloh1197:
nop
LFQH_Lloh1198:
adr x2, LFQH_l_.str.146
LFQH_Lloh1199:
nop
LFQH_Lloh1200:
adr x4, LFQH_SearchColor
LFQH_Lloh1201:
nop
mov	x3, x23
bl	LFQH_Hook
LFQH_Lloh1202:
adr x0, LFQH_l_.str.147
LFQH_Lloh1203:
nop
LFQH_Lloh1204:
adr x2, LFQH_l_.str.148
LFQH_Lloh1205:
nop
LFQH_Lloh1206:
adr x4, LFQH_ShelfButtonLayout
LFQH_Lloh1207:
nop
mov	x1, x19
mov	x3, x20
bl	LFQH_Hook
LFQH_Lloh1208:
adr x0, LFQH_l_.str.149
LFQH_Lloh1209:
nop
LFQH_Lloh1210:
adr x1, LFQH_l_.str.150
LFQH_Lloh1211:
nop
LFQH_Lloh1212:
adr x2, LFQH_l_.str.151
LFQH_Lloh1213:
nop
LFQH_Lloh1214:
adr x4, LFQH_ShelfLayout
LFQH_Lloh1215:
nop
mov	x3, x20
bl	LFQH_Hook
LFQH_Lloh1216:
adr x22, LFQH_l_.str.152
LFQH_Lloh1217:
nop
LFQH_Lloh1218:
adr x2, LFQH_l_.str.153
LFQH_Lloh1219:
nop
LFQH_Lloh1220:
adr x4, LFQH_ReaderLayout
LFQH_Lloh1221:
nop
mov	x0, x22
mov	x1, x19
mov	x3, x20
bl	LFQH_Hook
LFQH_Lloh1222:
adr x1, LFQH_l_.str.154
LFQH_Lloh1223:
nop
LFQH_Lloh1224:
adr x2, LFQH_l_.str.155
LFQH_Lloh1225:
nop
LFQH_Lloh1226:
adr x4, LFQH_ReaderTheme
LFQH_Lloh1227:
nop
mov	x0, x22
mov	x3, x21
ldp	x29, x30, [sp, #48]
ldp	x20, x19, [sp, #32]
ldp	x22, x21, [sp, #16]
ldp	x24, x23, [sp], #64
b	LFQH_Hook
LFQH_LBB69_2:
ldp	x29, x30, [sp, #48]
ldp	x20, x19, [sp, #32]
ldp	x22, x21, [sp, #16]
ldp	x24, x23, [sp], #64
ret
.cfi_endproc
.p2align	2
LFQH_ListenLayout:
.cfi_startproc
stp	x20, x19, [sp, #-32]!
stp	x29, x30, [sp, #16]
add	x29, sp, #16
.cfi_def_cfa w29, 16
.cfi_offset w30, -8
.cfi_offset w29, -16
.cfi_offset w19, -24
.cfi_offset w20, -32
mov	x19, x1
mov	x20, x0
LFQH_Lloh1228:
adr x0, LFQH_l_.str.46
LFQH_Lloh1229:
nop
LFQH_Lloh1230:
adr x1, LFQH_l_.str.134
LFQH_Lloh1231:
nop
bl	LFQH_Original
mov	x8, x0
mov	x0, x20
mov	x1, x19
blr	x8
mov	x0, x20
ldp	x29, x30, [sp, #16]
ldp	x20, x19, [sp], #32
b	LFQH_FQHListen
.cfi_endproc
.p2align	2
LFQH_SpeechLayout:
.cfi_startproc
stp	x20, x19, [sp, #-32]!
stp	x29, x30, [sp, #16]
add	x29, sp, #16
.cfi_def_cfa w29, 16
.cfi_offset w30, -8
.cfi_offset w29, -16
.cfi_offset w19, -24
.cfi_offset w20, -32
mov	x19, x1
mov	x20, x0
LFQH_Lloh1232:
adr x0, LFQH_l_.str.61
LFQH_Lloh1233:
nop
LFQH_Lloh1234:
adr x1, LFQH_l_.str.135
LFQH_Lloh1235:
nop
bl	LFQH_Original
mov	x8, x0
mov	x0, x20
mov	x1, x19
blr	x8
mov	x0, x20
ldp	x29, x30, [sp, #16]
ldp	x20, x19, [sp], #32
b	LFQH_SpeechGlass
.cfi_endproc
.p2align	2
LFQH_SpeechTheme:
.cfi_startproc
stp	x22, x21, [sp, #-48]!
stp	x20, x19, [sp, #16]
stp	x29, x30, [sp, #32]
add	x29, sp, #32
.cfi_def_cfa w29, 16
.cfi_offset w30, -8
.cfi_offset w29, -16
.cfi_offset w19, -24
.cfi_offset w20, -32
.cfi_offset w21, -40
.cfi_offset w22, -48
mov	x19, x2
mov	x20, x1
mov	x21, x0
LFQH_Lloh1236:
adr x0, LFQH_l_.str.61
LFQH_Lloh1237:
nop
LFQH_Lloh1238:
adr x1, LFQH_l_.str.137
LFQH_Lloh1239:
nop
bl	LFQH_Original
mov	x8, x0
mov	x0, x21
mov	x1, x20
mov	x2, x19
blr	x8
mov	x0, x21
ldp	x29, x30, [sp, #32]
ldp	x20, x19, [sp, #16]
ldp	x22, x21, [sp], #48
b	LFQH_SpeechGlass
.cfi_endproc
.p2align	2
LFQH_HomeLayout:
.cfi_startproc
stp	x20, x19, [sp, #-32]!
stp	x29, x30, [sp, #16]
add	x29, sp, #16
.cfi_def_cfa w29, 16
.cfi_offset w30, -8
.cfi_offset w29, -16
.cfi_offset w19, -24
.cfi_offset w20, -32
mov	x19, x1
mov	x20, x0
LFQH_Lloh1240:
adr x0, LFQH_l_.str.7
LFQH_Lloh1241:
nop
LFQH_Lloh1242:
adr x1, LFQH_l_.str.138
LFQH_Lloh1243:
nop
bl	LFQH_Original
mov	x8, x0
mov	x0, x20
mov	x1, x19
blr	x8
LFQH_Lloh1244:
adr x1, LFQH_l_.str.10
LFQH_Lloh1245:
nop
mov	x0, x20
bl	LFQH_Get
ldp	x29, x30, [sp, #16]
ldp	x20, x19, [sp], #32
b	LFQH_FQHHeader
.cfi_endproc
.p2align	2
LFQH_HomeAppear:
.cfi_startproc
stp	x22, x21, [sp, #-48]!
stp	x20, x19, [sp, #16]
stp	x29, x30, [sp, #32]
add	x29, sp, #32
.cfi_def_cfa w29, 16
.cfi_offset w30, -8
.cfi_offset w29, -16
.cfi_offset w19, -24
.cfi_offset w20, -32
.cfi_offset w21, -40
.cfi_offset w22, -48
mov	x19, x2
mov	x20, x1
mov	x21, x0
LFQH_Lloh1246:
adr x0, LFQH_l_.str.7
LFQH_Lloh1247:
nop
LFQH_Lloh1248:
adr x1, LFQH_l_.str.139
LFQH_Lloh1249:
nop
bl	LFQH_Original
mov	x8, x0
mov	x0, x21
mov	x1, x20
mov	x2, x19
blr	x8
LFQH_Lloh1250:
adr x1, LFQH_l_.str.10
LFQH_Lloh1251:
nop
mov	x0, x21
bl	LFQH_Get
ldp	x29, x30, [sp, #32]
ldp	x20, x19, [sp, #16]
ldp	x22, x21, [sp], #48
b	LFQH_FQHHeader
.cfi_endproc
.p2align	2
LFQH_CategoryLayout:
.cfi_startproc
stp	x20, x19, [sp, #-32]!
stp	x29, x30, [sp, #16]
add	x29, sp, #16
.cfi_def_cfa w29, 16
.cfi_offset w30, -8
.cfi_offset w29, -16
.cfi_offset w19, -24
.cfi_offset w20, -32
mov	x19, x1
mov	x20, x0
LFQH_Lloh1252:
adr x0, LFQH_l_.str.25
LFQH_Lloh1253:
nop
LFQH_Lloh1254:
adr x1, LFQH_l_.str.140
LFQH_Lloh1255:
nop
bl	LFQH_Original
mov	x8, x0
mov	x0, x20
mov	x1, x19
blr	x8
mov	x0, x20
ldp	x29, x30, [sp, #16]
ldp	x20, x19, [sp], #32
b	LFQH_FQHHeader
.cfi_endproc
.p2align	2
LFQH_CategoryColor:
.cfi_startproc
stp	d9, d8, [sp, #-80]!
stp	x24, x23, [sp, #16]
stp	x22, x21, [sp, #32]
stp	x20, x19, [sp, #48]
stp	x29, x30, [sp, #64]
add	x29, sp, #64
.cfi_def_cfa w29, 16
.cfi_offset w30, -8
.cfi_offset w29, -16
.cfi_offset w19, -24
.cfi_offset w20, -32
.cfi_offset w21, -40
.cfi_offset w22, -48
.cfi_offset w23, -56
.cfi_offset w24, -64
.cfi_offset b8, -72
.cfi_offset b9, -80
mov	x19, x5
mov	x20, x4
mov	x21, x3
mov	x22, x2
mov.16b	v8, v0
mov	x23, x1
mov	x24, x0
LFQH_Lloh1256:
adr x0, LFQH_l_.str.25
LFQH_Lloh1257:
nop
LFQH_Lloh1258:
adr x1, LFQH_l_.str.142
LFQH_Lloh1259:
nop
bl	LFQH_Original
mov	x8, x0
mov	x0, x24
mov	x1, x23
mov.16b	v0, v8
mov	x2, x22
mov	x3, x21
mov	x4, x20
mov	x5, x19
blr	x8
mov	x0, x24
ldp	x29, x30, [sp, #64]
ldp	x20, x19, [sp, #48]
ldp	x22, x21, [sp, #32]
ldp	x24, x23, [sp, #16]
ldp	d9, d8, [sp], #80
b	LFQH_FQHHeader
.cfi_endproc
.p2align	2
LFQH_SearchColor:
.cfi_startproc
stp	d9, d8, [sp, #-80]!
stp	x24, x23, [sp, #16]
stp	x22, x21, [sp, #32]
stp	x20, x19, [sp, #48]
stp	x29, x30, [sp, #64]
add	x29, sp, #64
.cfi_def_cfa w29, 16
.cfi_offset w30, -8
.cfi_offset w29, -16
.cfi_offset w19, -24
.cfi_offset w20, -32
.cfi_offset w21, -40
.cfi_offset w22, -48
.cfi_offset w23, -56
.cfi_offset w24, -64
.cfi_offset b8, -72
.cfi_offset b9, -80
mov	x19, x5
mov	x20, x4
mov	x21, x3
mov	x22, x2
mov.16b	v8, v0
mov	x23, x1
mov	x24, x0
LFQH_Lloh1260:
adr x0, LFQH_l_.str.144
LFQH_Lloh1261:
nop
LFQH_Lloh1262:
adr x1, LFQH_l_.str.146
LFQH_Lloh1263:
nop
bl	LFQH_Original
mov	x8, x0
mov	x0, x24
mov	x1, x23
mov.16b	v0, v8
mov	x2, x22
mov	x3, x21
mov	x4, x20
mov	x5, x19
blr	x8
LFQH_Lloh1264:
adr x1, LFQH_l_.str.320
LFQH_Lloh1265:
nop
mov	x0, x24
bl	LFQH_Get
LFQH_Lloh1266:
adr x1, LFQH_l_.str.10
LFQH_Lloh1267:
nop
bl	LFQH_Get
ldp	x29, x30, [sp, #64]
ldp	x20, x19, [sp, #48]
ldp	x22, x21, [sp, #32]
ldp	x24, x23, [sp, #16]
ldp	d9, d8, [sp], #80
b	LFQH_FQHHeader
.cfi_endproc
.p2align	2
LFQH_ShelfButtonLayout:
.cfi_startproc
stp	x20, x19, [sp, #-32]!
stp	x29, x30, [sp, #16]
add	x29, sp, #16
.cfi_def_cfa w29, 16
.cfi_offset w30, -8
.cfi_offset w29, -16
.cfi_offset w19, -24
.cfi_offset w20, -32
mov	x20, x1
mov	x19, x0
LFQH_Lloh1268:
adr x0, LFQH_l_.str.147
LFQH_Lloh1269:
nop
LFQH_Lloh1270:
adr x1, LFQH_l_.str.148
LFQH_Lloh1271:
nop
bl	LFQH_Original
mov	x8, x0
mov	x0, x19
mov	x1, x20
blr	x8
LFQH_Lloh1272:
adr x1, LFQH_ShelfRoleKey
LFQH_Lloh1273:
nop
mov	x0, x19
bl Lpatch + (0xa628 - PATCH_BASE)
cbz	x0, LFQH_LBB78_2
LFQH_Lloh1274:
adr x1, LFQH_l_.str.27
LFQH_Lloh1275:
nop
bl	LFQH_Equal
LFQH_Lloh1276:
adr x8, LFQH_l_.str.42
LFQH_Lloh1277:
nop
LFQH_Lloh1278:
adr x9, LFQH_l_.str.43
LFQH_Lloh1279:
nop
cmp	w0, #0
csel	x1, x9, x8, eq
mov	x0, x19
ldp	x29, x30, [sp, #16]
ldp	x20, x19, [sp], #32
b	LFQH_Icon
LFQH_LBB78_2:
ldp	x29, x30, [sp, #16]
ldp	x20, x19, [sp], #32
ret
.cfi_endproc
.p2align	2
LFQH_ShelfLayout:
.cfi_startproc
stp	x20, x19, [sp, #-32]!
stp	x29, x30, [sp, #16]
add	x29, sp, #16
.cfi_def_cfa w29, 16
.cfi_offset w30, -8
.cfi_offset w29, -16
.cfi_offset w19, -24
.cfi_offset w20, -32
mov	x19, x1
mov	x20, x0
LFQH_Lloh1280:
adr x0, LFQH_l_.str.149
LFQH_Lloh1281:
nop
LFQH_Lloh1282:
adr x1, LFQH_l_.str.151
LFQH_Lloh1283:
nop
bl	LFQH_Original
mov	x8, x0
mov	x0, x20
mov	x1, x19
blr	x8
mov	x0, x20
ldp	x29, x30, [sp, #16]
ldp	x20, x19, [sp], #32
b	LFQH_FQHShelf
.cfi_endproc
.p2align	2
LFQH_ReaderLayout:
.cfi_startproc
stp	x20, x19, [sp, #-32]!
stp	x29, x30, [sp, #16]
add	x29, sp, #16
.cfi_def_cfa w29, 16
.cfi_offset w30, -8
.cfi_offset w29, -16
.cfi_offset w19, -24
.cfi_offset w20, -32
mov	x19, x1
mov	x20, x0
LFQH_Lloh1284:
adr x0, LFQH_l_.str.152
LFQH_Lloh1285:
nop
LFQH_Lloh1286:
adr x1, LFQH_l_.str.153
LFQH_Lloh1287:
nop
bl	LFQH_Original
mov	x8, x0
mov	x0, x20
mov	x1, x19
blr	x8
mov	x0, x20
ldp	x29, x30, [sp, #16]
ldp	x20, x19, [sp], #32
b	LFQH_FQHReader
.cfi_endproc
.p2align	2
LFQH_ReaderTheme:
.cfi_startproc
stp	x22, x21, [sp, #-48]!
stp	x20, x19, [sp, #16]
stp	x29, x30, [sp, #32]
add	x29, sp, #32
.cfi_def_cfa w29, 16
.cfi_offset w30, -8
.cfi_offset w29, -16
.cfi_offset w19, -24
.cfi_offset w20, -32
.cfi_offset w21, -40
.cfi_offset w22, -48
mov	x19, x2
mov	x20, x1
mov	x21, x0
LFQH_Lloh1288:
adr x0, LFQH_l_.str.152
LFQH_Lloh1289:
nop
LFQH_Lloh1290:
adr x1, LFQH_l_.str.155
LFQH_Lloh1291:
nop
bl	LFQH_Original
mov	x8, x0
mov	x0, x21
mov	x1, x20
mov	x2, x19
blr	x8
mov	x0, x21
ldp	x29, x30, [sp, #32]
ldp	x20, x19, [sp, #16]
ldp	x22, x21, [sp], #48
b	LFQH_FQHReader
.cfi_endproc
.p2align	2
LFQH_BusyKey:
.cfi_startproc
ret
.cfi_endproc
.p2align	2
LFQH_BackgroundKey:
.cfi_startproc
ret
.cfi_endproc
.p2align	2
LFQH_PrepareHeaderOwner:
.cfi_startproc
stp	d11, d10, [sp, #-96]!
stp	d9, d8, [sp, #16]
stp	x24, x23, [sp, #32]
stp	x22, x21, [sp, #48]
stp	x20, x19, [sp, #64]
stp	x29, x30, [sp, #80]
add	x29, sp, #80
.cfi_def_cfa w29, 16
.cfi_offset w30, -8
.cfi_offset w29, -16
.cfi_offset w19, -24
.cfi_offset w20, -32
.cfi_offset w21, -40
.cfi_offset w22, -48
.cfi_offset w23, -56
.cfi_offset w24, -64
.cfi_offset b8, -72
.cfi_offset b9, -80
.cfi_offset b10, -88
.cfi_offset b11, -96
mov.16b	v9, v3
mov.16b	v10, v2
mov	x19, x0
LFQH_Lloh1292:
adr x0, LFQH_l_.str.177
LFQH_Lloh1293:
nop
bl Lpatch + (0xa5a4 - PATCH_BASE)
mov	x1, x0
mov	x0, x19
bl Lpatch + (0xa5d4 - PATCH_BASE)
mov	x21, x0
LFQH_Lloh1294:
adr x0, LFQH_l_.str.178
LFQH_Lloh1295:
nop
bl Lpatch + (0xa5a4 - PATCH_BASE)
mov	x1, x0
mov	x0, x19
bl Lpatch + (0xa5d4 - PATCH_BASE)
mov	x20, x0
LFQH_Lloh1296:
adr x0, LFQH_l_.str.180
LFQH_Lloh1297:
nop
bl Lpatch + (0xa5a4 - PATCH_BASE)
mov	x1, x0
mov	x0, x19
bl Lpatch + (0xa5d4 - PATCH_BASE)
mov	x22, x0
LFQH_Lloh1298:
adr x0, LFQH_l_.str.181
LFQH_Lloh1299:
nop
bl Lpatch + (0xa5a4 - PATCH_BASE)
mov	x1, x0
mov	x0, x22
bl Lpatch + (0xa5d4 - PATCH_BASE)
mov.16b	v8, v0
fcmp	d10, d9
fcsel	d9, d10, d9, mi
LFQH_Lloh1300:
adr x1, LFQH_HeaderAppliedRadiusKey
LFQH_Lloh1301:
nop
mov	x0, x19
bl Lpatch + (0xa628 - PATCH_BASE)
mov	x22, x0
LFQH_Lloh1302:
adr x1, LFQH_HeaderClipsKey
LFQH_Lloh1303:
nop
mov	x0, x19
bl Lpatch + (0xa628 - PATCH_BASE)
cbz	x0, LFQH_LBB84_2
cbnz	w21, LFQH_LBB84_3
LFQH_LBB84_2:
LFQH_Lloh1304:
adr x0, LFQH_l_.str.182
LFQH_Lloh1305:
nop
bl Lpatch + (0xa5b0 - PATCH_BASE)
mov	x23, x0
LFQH_Lloh1306:
adr x0, LFQH_l_.str.183
LFQH_Lloh1307:
nop
bl Lpatch + (0xa5a4 - PATCH_BASE)
mov	x1, x0
mov	x0, x23
mov	x2, x21
bl Lpatch + (0xa5d4 - PATCH_BASE)
mov	x2, x0
LFQH_Lloh1308:
adr x1, LFQH_HeaderClipsKey
LFQH_Lloh1309:
nop
mov	x0, x19
mov	w3, #1
bl Lpatch + (0xa634 - PATCH_BASE)
LFQH_LBB84_3:
fmov	d10, #0.50000000
LFQH_Lloh1310:
adr x1, LFQH_HeaderOpaqueKey
LFQH_Lloh1311:
nop
mov	x0, x19
bl Lpatch + (0xa628 - PATCH_BASE)
cbz	x0, LFQH_LBB84_5
cbz	w20, LFQH_LBB84_6
LFQH_LBB84_5:
LFQH_Lloh1312:
adr x0, LFQH_l_.str.182
LFQH_Lloh1313:
nop
bl Lpatch + (0xa5b0 - PATCH_BASE)
mov	x23, x0
LFQH_Lloh1314:
adr x0, LFQH_l_.str.183
LFQH_Lloh1315:
nop
bl Lpatch + (0xa5a4 - PATCH_BASE)
mov	x1, x0
mov	x0, x23
mov	x2, x20
bl Lpatch + (0xa5d4 - PATCH_BASE)
mov	x2, x0
LFQH_Lloh1316:
adr x1, LFQH_HeaderOpaqueKey
LFQH_Lloh1317:
nop
mov	x0, x19
mov	w3, #1
bl Lpatch + (0xa634 - PATCH_BASE)
LFQH_LBB84_6:
fmul	d9, d9, d10
cbz	x22, LFQH_LBB84_8
LFQH_Lloh1318:
adr x0, LFQH_l_.str.184
LFQH_Lloh1319:
nop
bl Lpatch + (0xa5a4 - PATCH_BASE)
mov	x1, x0
mov	x0, x22
bl Lpatch + (0xa5d4 - PATCH_BASE)
fcmp	d8, d0
b.eq	LFQH_LBB84_9
LFQH_LBB84_8:
LFQH_Lloh1320:
adr x0, LFQH_l_.str.182
LFQH_Lloh1321:
nop
bl Lpatch + (0xa5b0 - PATCH_BASE)
mov	x23, x0
LFQH_Lloh1322:
adr x0, LFQH_l_.str.185
LFQH_Lloh1323:
nop
bl Lpatch + (0xa5a4 - PATCH_BASE)
mov	x1, x0
mov	x0, x23
mov.16b	v0, v8
bl Lpatch + (0xa5d4 - PATCH_BASE)
mov	x2, x0
LFQH_Lloh1324:
adr x1, LFQH_HeaderRadiusKey
LFQH_Lloh1325:
nop
mov	x0, x19
mov	w3, #1
bl Lpatch + (0xa634 - PATCH_BASE)
LFQH_LBB84_9:
fcmp	d8, d9
b.eq	LFQH_LBB84_11
LFQH_Lloh1326:
adr x0, LFQH_l_.str.180
LFQH_Lloh1327:
nop
bl Lpatch + (0xa5a4 - PATCH_BASE)
mov	x1, x0
mov	x0, x19
bl Lpatch + (0xa5d4 - PATCH_BASE)
mov	x23, x0
LFQH_Lloh1328:
adr x0, LFQH_l_.str.186
LFQH_Lloh1329:
nop
bl Lpatch + (0xa5a4 - PATCH_BASE)
mov	x1, x0
mov	x0, x23
mov.16b	v0, v9
bl Lpatch + (0xa5d4 - PATCH_BASE)
LFQH_LBB84_11:
cbz	x22, LFQH_LBB84_13
LFQH_Lloh1330:
adr x0, LFQH_l_.str.184
LFQH_Lloh1331:
nop
bl Lpatch + (0xa5a4 - PATCH_BASE)
mov	x1, x0
mov	x0, x22
bl Lpatch + (0xa5d4 - PATCH_BASE)
fcmp	d0, d9
b.eq	LFQH_LBB84_14
LFQH_LBB84_13:
LFQH_Lloh1332:
adr x0, LFQH_l_.str.182
LFQH_Lloh1333:
nop
bl Lpatch + (0xa5b0 - PATCH_BASE)
mov	x22, x0
LFQH_Lloh1334:
adr x0, LFQH_l_.str.185
LFQH_Lloh1335:
nop
bl Lpatch + (0xa5a4 - PATCH_BASE)
mov	x1, x0
mov	x0, x22
mov.16b	v0, v9
bl Lpatch + (0xa5d4 - PATCH_BASE)
mov	x2, x0
LFQH_Lloh1336:
adr x1, LFQH_HeaderAppliedRadiusKey
LFQH_Lloh1337:
nop
mov	x0, x19
mov	w3, #1
bl Lpatch + (0xa634 - PATCH_BASE)
LFQH_LBB84_14:
cbz	w21, LFQH_LBB84_17
cbz	w20, LFQH_LBB84_18
LFQH_LBB84_16:
LFQH_Lloh1338:
adr x0, LFQH_l_.str.165
LFQH_Lloh1339:
nop
bl Lpatch + (0xa5a4 - PATCH_BASE)
mov	x1, x0
mov	x0, x19
mov	w2, #0
ldp	x29, x30, [sp, #80]
ldp	x20, x19, [sp, #64]
ldp	x22, x21, [sp, #48]
ldp	x24, x23, [sp, #32]
ldp	d9, d8, [sp, #16]
ldp	d11, d10, [sp], #96
b Lpatch + (0xa5d4 - PATCH_BASE)
LFQH_LBB84_17:
LFQH_Lloh1340:
adr x0, LFQH_l_.str.179
LFQH_Lloh1341:
nop
bl Lpatch + (0xa5a4 - PATCH_BASE)
mov	x1, x0
mov	x0, x19
mov	w2, #1
bl Lpatch + (0xa5d4 - PATCH_BASE)
cbnz	w20, LFQH_LBB84_16
LFQH_LBB84_18:
ldp	x29, x30, [sp, #80]
ldp	x20, x19, [sp, #64]
ldp	x22, x21, [sp, #48]
ldp	x24, x23, [sp, #32]
ldp	d9, d8, [sp, #16]
ldp	d11, d10, [sp], #96
ret
.cfi_endproc
.p2align	2
LFQH_PrepareOwner:
.cfi_startproc
stp	x22, x21, [sp, #-48]!
stp	x20, x19, [sp, #16]
stp	x29, x30, [sp, #32]
add	x29, sp, #32
.cfi_def_cfa w29, 16
.cfi_offset w30, -8
.cfi_offset w29, -16
.cfi_offset w19, -24
.cfi_offset w20, -32
.cfi_offset w21, -40
.cfi_offset w22, -48
mov	x19, x0
LFQH_Lloh1342:
adr x0, LFQH_l_.str.177
LFQH_Lloh1343:
nop
bl Lpatch + (0xa5a4 - PATCH_BASE)
mov	x1, x0
mov	x0, x19
bl Lpatch + (0xa5d4 - PATCH_BASE)
mov	x21, x0
LFQH_Lloh1344:
adr x0, LFQH_l_.str.178
LFQH_Lloh1345:
nop
bl Lpatch + (0xa5a4 - PATCH_BASE)
mov	x1, x0
mov	x0, x19
bl Lpatch + (0xa5d4 - PATCH_BASE)
mov	x20, x0
LFQH_Lloh1346:
adr x1, LFQH_ClipsKey
LFQH_Lloh1347:
nop
mov	x0, x19
bl Lpatch + (0xa628 - PATCH_BASE)
cbz	x0, LFQH_LBB85_2
cbz	w21, LFQH_LBB85_3
LFQH_LBB85_2:
LFQH_Lloh1348:
adr x0, LFQH_l_.str.182
LFQH_Lloh1349:
nop
bl Lpatch + (0xa5b0 - PATCH_BASE)
mov	x22, x0
LFQH_Lloh1350:
adr x0, LFQH_l_.str.183
LFQH_Lloh1351:
nop
bl Lpatch + (0xa5a4 - PATCH_BASE)
mov	x1, x0
mov	x0, x22
mov	x2, x21
bl Lpatch + (0xa5d4 - PATCH_BASE)
mov	x2, x0
LFQH_Lloh1352:
adr x1, LFQH_ClipsKey
LFQH_Lloh1353:
nop
mov	x0, x19
mov	w3, #1
bl Lpatch + (0xa634 - PATCH_BASE)
LFQH_LBB85_3:
LFQH_Lloh1354:
adr x1, LFQH_OpaqueKey
LFQH_Lloh1355:
nop
mov	x0, x19
bl Lpatch + (0xa628 - PATCH_BASE)
cbz	x0, LFQH_LBB85_5
cbz	w20, LFQH_LBB85_6
LFQH_LBB85_5:
LFQH_Lloh1356:
adr x0, LFQH_l_.str.182
LFQH_Lloh1357:
nop
bl Lpatch + (0xa5b0 - PATCH_BASE)
mov	x22, x0
LFQH_Lloh1358:
adr x0, LFQH_l_.str.183
LFQH_Lloh1359:
nop
bl Lpatch + (0xa5a4 - PATCH_BASE)
mov	x1, x0
mov	x0, x22
mov	x2, x20
bl Lpatch + (0xa5d4 - PATCH_BASE)
mov	x2, x0
LFQH_Lloh1360:
adr x1, LFQH_OpaqueKey
LFQH_Lloh1361:
nop
mov	x0, x19
mov	w3, #1
bl Lpatch + (0xa634 - PATCH_BASE)
LFQH_LBB85_6:
cbz	w21, LFQH_LBB85_8
LFQH_Lloh1362:
adr x0, LFQH_l_.str.179
LFQH_Lloh1363:
nop
bl Lpatch + (0xa5a4 - PATCH_BASE)
mov	x1, x0
mov	x0, x19
mov	w2, #0
bl Lpatch + (0xa5d4 - PATCH_BASE)
LFQH_LBB85_8:
cbz	w20, LFQH_LBB85_10
LFQH_Lloh1364:
adr x0, LFQH_l_.str.165
LFQH_Lloh1365:
nop
bl Lpatch + (0xa5a4 - PATCH_BASE)
mov	x1, x0
mov	x0, x19
mov	w2, #0
ldp	x29, x30, [sp, #32]
ldp	x20, x19, [sp, #16]
ldp	x22, x21, [sp], #48
b Lpatch + (0xa5d4 - PATCH_BASE)
LFQH_LBB85_10:
ldp	x29, x30, [sp, #32]
ldp	x20, x19, [sp, #16]
ldp	x22, x21, [sp], #48
ret
.cfi_endproc
.p2align	2
LFQH_ClearBackground:
.cfi_startproc
stp	x22, x21, [sp, #-48]!
stp	x20, x19, [sp, #16]
stp	x29, x30, [sp, #32]
add	x29, sp, #32
.cfi_def_cfa w29, 16
.cfi_offset w30, -8
.cfi_offset w29, -16
.cfi_offset w19, -24
.cfi_offset w20, -32
.cfi_offset w21, -40
.cfi_offset w22, -48
mov	x19, x1
mov	x20, x0
LFQH_Lloh1366:
adr x0, LFQH_l_.str.167
LFQH_Lloh1367:
nop
bl Lpatch + (0xa5a4 - PATCH_BASE)
mov	x1, x0
mov	x0, x20
bl Lpatch + (0xa5d4 - PATCH_BASE)
cmp	x0, x19
b.eq	LFQH_LBB86_2
mov	x21, x0
LFQH_Lloh1368:
adr x0, LFQH_l_.str.51
LFQH_Lloh1369:
nop
bl Lpatch + (0xa5a4 - PATCH_BASE)
mov	x1, x0
mov	x0, x21
mov	x2, x19
bl Lpatch + (0xa5d4 - PATCH_BASE)
cbz	w0, LFQH_LBB86_3
LFQH_LBB86_2:
ldp	x29, x30, [sp, #32]
ldp	x20, x19, [sp, #16]
ldp	x22, x21, [sp], #48
ret
LFQH_LBB86_3:
LFQH_Lloh1370:
adr x0, LFQH_l_.str.187
LFQH_Lloh1371:
nop
bl Lpatch + (0xa5a4 - PATCH_BASE)
mov	x1, x0
mov	x0, x20
mov	x2, x19
ldp	x29, x30, [sp, #32]
ldp	x20, x19, [sp, #16]
ldp	x22, x21, [sp], #48
b Lpatch + (0xa5d4 - PATCH_BASE)
.cfi_endproc
.p2align	2
LFQH_HeaderAppliedRadiusKey:
.cfi_startproc
ret
.cfi_endproc
.p2align	2
LFQH_HeaderClipsKey:
.cfi_startproc
ret
.cfi_endproc
.p2align	2
LFQH_HeaderOpaqueKey:
.cfi_startproc
ret
.cfi_endproc
.p2align	2
LFQH_HeaderRadiusKey:
.cfi_startproc
ret
.cfi_endproc
.p2align	2
LFQH_ClipsKey:
.cfi_startproc
ret
.cfi_endproc
.p2align	2
LFQH_OpaqueKey:
.cfi_startproc
ret
.cfi_endproc
.p2align	2
LFQH_HeaderLogKey:
.cfi_startproc
ret
.cfi_endproc
.p2align	2
LFQH_HeaderLogTimeKey:
.cfi_startproc
ret
.cfi_endproc
.p2align	2
LFQH_RectBox:
.cfi_startproc
stp	d11, d10, [sp, #-64]!
stp	d9, d8, [sp, #16]
stp	x20, x19, [sp, #32]
stp	x29, x30, [sp, #48]
add	x29, sp, #48
.cfi_def_cfa w29, 16
.cfi_offset w30, -8
.cfi_offset w29, -16
.cfi_offset w19, -24
.cfi_offset w20, -32
.cfi_offset b8, -40
.cfi_offset b9, -48
.cfi_offset b10, -56
.cfi_offset b11, -64
mov.16b	v8, v3
mov.16b	v9, v2
mov.16b	v10, v1
mov.16b	v11, v0
LFQH_Lloh1372:
adr x0, LFQH_l_.str.201
LFQH_Lloh1373:
nop
bl Lpatch + (0xa5b0 - PATCH_BASE)
mov	x19, x0
LFQH_Lloh1374:
adr x0, LFQH_l_.str.202
LFQH_Lloh1375:
nop
bl Lpatch + (0xa5a4 - PATCH_BASE)
mov	x1, x0
mov	x0, x19
mov.16b	v0, v11
mov.16b	v1, v10
mov.16b	v2, v9
mov.16b	v3, v8
ldp	x29, x30, [sp, #48]
ldp	x20, x19, [sp, #32]
ldp	d9, d8, [sp, #16]
ldp	d11, d10, [sp], #64
b Lpatch + (0xa5d4 - PATCH_BASE)
.cfi_endproc
.p2align	2
LFQH_RectArray:
.cfi_startproc
stp	d11, d10, [sp, #-96]!
stp	d9, d8, [sp, #16]
stp	x24, x23, [sp, #32]
stp	x22, x21, [sp, #48]
stp	x20, x19, [sp, #64]
stp	x29, x30, [sp, #80]
add	x29, sp, #80
.cfi_def_cfa w29, 16
.cfi_offset w30, -8
.cfi_offset w29, -16
.cfi_offset w19, -24
.cfi_offset w20, -32
.cfi_offset w21, -40
.cfi_offset w22, -48
.cfi_offset w23, -56
.cfi_offset w24, -64
.cfi_offset b8, -72
.cfi_offset b9, -80
.cfi_offset b10, -88
.cfi_offset b11, -96
mov.16b	v8, v3
mov.16b	v9, v2
mov.16b	v10, v1
mov.16b	v11, v0
LFQH_Lloh1376:
adr x0, LFQH_l_.str.71
LFQH_Lloh1377:
nop
bl Lpatch + (0xa5b0 - PATCH_BASE)
mov	x19, x0
LFQH_Lloh1378:
adr x0, LFQH_l_.str.84
LFQH_Lloh1379:
nop
bl Lpatch + (0xa5a4 - PATCH_BASE)
mov	x1, x0
mov	x0, x19
bl Lpatch + (0xa5d4 - PATCH_BASE)
mov	x19, x0
LFQH_Lloh1380:
adr x20, LFQH_l_.str.88
LFQH_Lloh1381:
nop
mov	x0, x20
bl Lpatch + (0xa5a4 - PATCH_BASE)
mov	x23, x0
LFQH_Lloh1382:
adr x21, LFQH_l_.str.182
LFQH_Lloh1383:
nop
mov	x0, x21
bl Lpatch + (0xa5b0 - PATCH_BASE)
mov	x24, x0
LFQH_Lloh1384:
adr x22, LFQH_l_.str.185
LFQH_Lloh1385:
nop
mov	x0, x22
bl Lpatch + (0xa5a4 - PATCH_BASE)
mov	x1, x0
mov	x0, x24
mov.16b	v0, v11
bl Lpatch + (0xa5d4 - PATCH_BASE)
mov	x2, x0
mov	x0, x19
mov	x1, x23
bl Lpatch + (0xa5d4 - PATCH_BASE)
mov	x0, x20
bl Lpatch + (0xa5a4 - PATCH_BASE)
mov	x23, x0
mov	x0, x21
bl Lpatch + (0xa5b0 - PATCH_BASE)
mov	x24, x0
mov	x0, x22
bl Lpatch + (0xa5a4 - PATCH_BASE)
mov	x1, x0
mov	x0, x24
mov.16b	v0, v10
bl Lpatch + (0xa5d4 - PATCH_BASE)
mov	x2, x0
mov	x0, x19
mov	x1, x23
bl Lpatch + (0xa5d4 - PATCH_BASE)
mov	x0, x20
bl Lpatch + (0xa5a4 - PATCH_BASE)
mov	x23, x0
mov	x0, x21
bl Lpatch + (0xa5b0 - PATCH_BASE)
mov	x24, x0
mov	x0, x22
bl Lpatch + (0xa5a4 - PATCH_BASE)
mov	x1, x0
mov	x0, x24
mov.16b	v0, v9
bl Lpatch + (0xa5d4 - PATCH_BASE)
mov	x2, x0
mov	x0, x19
mov	x1, x23
bl Lpatch + (0xa5d4 - PATCH_BASE)
mov	x0, x20
bl Lpatch + (0xa5a4 - PATCH_BASE)
mov	x20, x0
mov	x0, x21
bl Lpatch + (0xa5b0 - PATCH_BASE)
mov	x21, x0
mov	x0, x22
bl Lpatch + (0xa5a4 - PATCH_BASE)
mov	x1, x0
mov	x0, x21
mov.16b	v0, v8
bl Lpatch + (0xa5d4 - PATCH_BASE)
mov	x2, x0
mov	x0, x19
mov	x1, x20
bl Lpatch + (0xa5d4 - PATCH_BASE)
mov	x0, x19
ldp	x29, x30, [sp, #80]
ldp	x20, x19, [sp, #64]
ldp	x22, x21, [sp, #48]
ldp	x24, x23, [sp, #32]
ldp	d9, d8, [sp, #16]
ldp	d11, d10, [sp], #96
ret
.cfi_endproc
.p2align	2
LFQH_VisibleRect:
.cfi_startproc
fmov	x8, d2
fmov	x9, d1
fmov	x10, d0
ubfx	x10, x10, #52, #11
ubfx	x9, x9, #52, #11
ubfx	x8, x8, #52, #11
fmov	x11, d3
ubfx	x11, x11, #52, #11
cmp	x11, #2047
cset	w11, lo
cmp	x8, #2046
mov	w8, #2046
ccmp	x9, x8, #2, ls
ccmp	x10, x8, #2, ls
csel	w8, wzr, w11, hi
fcmp	d2, #0.0
csel	w8, wzr, w8, le
fcmp	d3, #0.0
csel	w0, wzr, w8, le
ret
.cfi_endproc
.p2align	2
LFQH_RestoreIcon:
.cfi_startproc
stp	x20, x19, [sp, #-32]!
stp	x29, x30, [sp, #16]
add	x29, sp, #16
.cfi_def_cfa w29, 16
.cfi_offset w30, -8
.cfi_offset w29, -16
.cfi_offset w19, -24
.cfi_offset w20, -32
mov	x20, x1
mov	x19, x0
bl	LFQH_RestoreGlyph
cbz	x20, LFQH_LBB98_2
mov	x0, x19
mov	x1, x20
mov	w2, #0
bl	LFQH_ObservePress
LFQH_Lloh1386:
adr x0, LFQH_l_.str.214
LFQH_Lloh1387:
nop
bl Lpatch + (0xa5a4 - PATCH_BASE)
mov	x1, x0
mov	x0, x20
bl Lpatch + (0xa5d4 - PATCH_BASE)
LFQH_LBB98_2:
LFQH_Lloh1388:
adr x1, LFQH_IconGlassKey
LFQH_Lloh1389:
nop
mov	x0, x19
mov	x2, #0
mov	w3, #1
bl Lpatch + (0xa634 - PATCH_BASE)
LFQH_Lloh1390:
adr x1, LFQH_IconRectKey
LFQH_Lloh1391:
nop
mov	x0, x19
mov	x2, #0
mov	w3, #1
bl Lpatch + (0xa634 - PATCH_BASE)
LFQH_Lloh1392:
adr x1, LFQH_LayoutKey
LFQH_Lloh1393:
nop
mov	x0, x19
mov	x2, #0
mov	w3, #1
bl Lpatch + (0xa634 - PATCH_BASE)
LFQH_Lloh1394:
adr x1, LFQH_LayoutTimeKey
LFQH_Lloh1395:
nop
mov	x0, x19
mov	x2, #0
mov	w3, #1
bl Lpatch + (0xa634 - PATCH_BASE)
mov	x0, x19
bl	LFQH_RestoreHit
mov	x0, x19
ldp	x29, x30, [sp, #16]
ldp	x20, x19, [sp], #32
b	LFQH_RestoreOwner
.cfi_endproc
.p2align	2
LFQH_GlyphViewKey:
.cfi_startproc
ret
.cfi_endproc
.p2align	2
LFQH_RestoreGlyph:
.cfi_startproc
stp	d11, d10, [sp, #-80]!
stp	d9, d8, [sp, #16]
stp	x22, x21, [sp, #32]
stp	x20, x19, [sp, #48]
stp	x29, x30, [sp, #64]
add	x29, sp, #64
.cfi_def_cfa w29, 16
.cfi_offset w30, -8
.cfi_offset w29, -16
.cfi_offset w19, -24
.cfi_offset w20, -32
.cfi_offset w21, -40
.cfi_offset w22, -48
.cfi_offset b8, -56
.cfi_offset b9, -64
.cfi_offset b10, -72
.cfi_offset b11, -80
mov	x19, x0
LFQH_Lloh1396:
adr x1, LFQH_GlyphViewKey
LFQH_Lloh1397:
nop
bl Lpatch + (0xa628 - PATCH_BASE)
mov	x20, x0
LFQH_Lloh1398:
adr x1, LFQH_GlyphOriginalKey
LFQH_Lloh1399:
nop
bl Lpatch + (0xa628 - PATCH_BASE)
cbz	x0, LFQH_LBB100_2
mov	x21, x0
LFQH_Lloh1400:
adr x0, LFQH_l_.str.200
LFQH_Lloh1401:
nop
bl Lpatch + (0xa5a4 - PATCH_BASE)
mov	x1, x0
mov	x0, x21
bl Lpatch + (0xa5d4 - PATCH_BASE)
mov.16b	v8, v0
mov.16b	v9, v1
mov.16b	v10, v2
mov.16b	v11, v3
LFQH_Lloh1402:
adr x0, LFQH_l_.str.173
LFQH_Lloh1403:
nop
bl Lpatch + (0xa5a4 - PATCH_BASE)
mov	x1, x0
mov	x0, x20
mov.16b	v0, v8
mov.16b	v1, v9
mov.16b	v2, v10
mov.16b	v3, v11
bl Lpatch + (0xa5d4 - PATCH_BASE)
LFQH_LBB100_2:
LFQH_Lloh1404:
adr x1, LFQH_GlyphOriginalKey
LFQH_Lloh1405:
nop
mov	x0, x20
mov	x2, #0
mov	w3, #1
bl Lpatch + (0xa634 - PATCH_BASE)
LFQH_Lloh1406:
adr x1, LFQH_GlyphAppliedKey
LFQH_Lloh1407:
nop
mov	x0, x20
mov	x2, #0
mov	w3, #1
bl Lpatch + (0xa634 - PATCH_BASE)
LFQH_Lloh1408:
adr x1, LFQH_GlyphViewKey
LFQH_Lloh1409:
nop
mov	x0, x19
mov	x2, #0
mov	w3, #1
ldp	x29, x30, [sp, #64]
ldp	x20, x19, [sp, #48]
ldp	x22, x21, [sp, #32]
ldp	d9, d8, [sp, #16]
ldp	d11, d10, [sp], #80
b Lpatch + (0xa634 - PATCH_BASE)
.cfi_endproc
.p2align	2
LFQH_GlyphOriginalKey:
.cfi_startproc
ret
.cfi_endproc
.p2align	2
LFQH_GlyphAppliedKey:
.cfi_startproc
ret
.cfi_endproc
.p2align	2
LFQH_CanExpandHit:
.cfi_startproc
stp	x20, x19, [sp, #-32]!
stp	x29, x30, [sp, #16]
add	x29, sp, #16
.cfi_def_cfa w29, 16
.cfi_offset w30, -8
.cfi_offset w29, -16
.cfi_offset w19, -24
.cfi_offset w20, -32
mov	x19, x0
LFQH_Lloh1410:
adr x1, LFQH_l_.str.217
LFQH_Lloh1411:
nop
bl	LFQH_Responds
cbz	w0, LFQH_LBB103_2
LFQH_Lloh1412:
adr x1, LFQH_l_.str.218
LFQH_Lloh1413:
nop
mov	x0, x19
bl	LFQH_Responds
LFQH_LBB103_2:
ldp	x29, x30, [sp, #16]
ldp	x20, x19, [sp], #32
ret
.cfi_endproc
.p2align	2
LFQH_GlassClass:
.cfi_startproc
stp	x20, x19, [sp, #-32]!
stp	x29, x30, [sp, #16]
add	x29, sp, #16
.cfi_def_cfa w29, 16
.cfi_offset w30, -8
.cfi_offset w29, -16
.cfi_offset w19, -24
.cfi_offset w20, -32
LFQH_Lloh1414:
adr x0, LFQH_l_.str.219
LFQH_Lloh1415:
nop
bl Lpatch + (0xa5b0 - PATCH_BASE)
mov	x19, x0
cbnz	x0, LFQH_LBB104_3
LFQH_Lloh1416:
adr x0, LFQH_l_.str.203
LFQH_Lloh1417:
nop
bl Lpatch + (0xa5b0 - PATCH_BASE)
LFQH_Lloh1418:
adr x1, LFQH_l_.str.219
LFQH_Lloh1419:
nop
mov	x2, #0
bl Lpatch + (0xa61c - PATCH_BASE)
mov	x19, x0
cbz	x0, LFQH_LBB104_3
LFQH_Lloh1420:
adr x0, LFQH_l_.str.220
LFQH_Lloh1421:
nop
bl Lpatch + (0xa5a4 - PATCH_BASE)
mov	x1, x0
LFQH_Lloh1422:
adr x2, LFQH_Press
LFQH_Lloh1423:
nop
LFQH_Lloh1424:
adr x20, LFQH_l_.str.109
LFQH_Lloh1425:
nop
mov	x0, x19
mov	x3, x20
bl Lpatch + (0xa58c - PATCH_BASE)
LFQH_Lloh1426:
adr x0, LFQH_l_.str.221
LFQH_Lloh1427:
nop
bl Lpatch + (0xa5a4 - PATCH_BASE)
mov	x1, x0
LFQH_Lloh1428:
adr x2, LFQH_ReleasePress
LFQH_Lloh1429:
nop
mov	x0, x19
mov	x3, x20
bl Lpatch + (0xa58c - PATCH_BASE)
mov	x0, x19
bl Lpatch + (0xa610 - PATCH_BASE)
LFQH_LBB104_3:
mov	x0, x19
ldp	x29, x30, [sp, #16]
ldp	x20, x19, [sp], #32
ret
.cfi_endproc
.p2align	2
LFQH_ObservePress:
.cfi_startproc
stp	x22, x21, [sp, #-48]!
stp	x20, x19, [sp, #16]
stp	x29, x30, [sp, #32]
add	x29, sp, #32
.cfi_def_cfa w29, 16
.cfi_offset w30, -8
.cfi_offset w29, -16
.cfi_offset w19, -24
.cfi_offset w20, -32
.cfi_offset w21, -40
.cfi_offset w22, -48
mov	x21, x2
mov	x19, x1
mov	x20, x0
LFQH_Lloh1430:
adr x1, LFQH_l_.str.44
LFQH_Lloh1431:
nop
bl	LFQH_Kind
cbz	w0, LFQH_LBB105_2
LFQH_Lloh1432:
adr x8, LFQH_l_.str.222
LFQH_Lloh1433:
nop
LFQH_Lloh1434:
adr x9, LFQH_l_.str.223
LFQH_Lloh1435:
nop
cmp	w21, #0
csel	x0, x9, x8, eq
bl Lpatch + (0xa5a4 - PATCH_BASE)
mov	x21, x0
LFQH_Lloh1436:
adr x0, LFQH_l_.str.220
LFQH_Lloh1437:
nop
bl Lpatch + (0xa5a4 - PATCH_BASE)
mov	x3, x0
mov	x0, x20
mov	x1, x21
mov	x2, x19
mov	w4, #17
bl Lpatch + (0xa5d4 - PATCH_BASE)
LFQH_Lloh1438:
adr x0, LFQH_l_.str.221
LFQH_Lloh1439:
nop
bl Lpatch + (0xa5a4 - PATCH_BASE)
mov	x3, x0
mov	x0, x20
mov	x1, x21
mov	x2, x19
mov	w4, #480
ldp	x29, x30, [sp, #32]
ldp	x20, x19, [sp, #16]
ldp	x22, x21, [sp], #48
b Lpatch + (0xa5d4 - PATCH_BASE)
LFQH_LBB105_2:
ldp	x29, x30, [sp, #32]
ldp	x20, x19, [sp, #16]
ldp	x22, x21, [sp], #48
ret
.cfi_endproc
.p2align	2
LFQH_IconRectKey:
.cfi_startproc
ret
.cfi_endproc
.p2align	2
LFQH_RecordLayout:
.cfi_startproc
sub	sp, sp, #320
stp	d15, d14, [sp, #192]
stp	d13, d12, [sp, #208]
stp	d11, d10, [sp, #224]
stp	d9, d8, [sp, #240]
stp	x24, x23, [sp, #256]
stp	x22, x21, [sp, #272]
stp	x20, x19, [sp, #288]
stp	x29, x30, [sp, #304]
add	x29, sp, #304
.cfi_def_cfa w29, 16
.cfi_offset w30, -8
.cfi_offset w29, -16
.cfi_offset w19, -24
.cfi_offset w20, -32
.cfi_offset w21, -40
.cfi_offset w22, -48
.cfi_offset w23, -56
.cfi_offset w24, -64
.cfi_offset b8, -72
.cfi_offset b9, -80
.cfi_offset b10, -88
.cfi_offset b11, -96
.cfi_offset b12, -104
.cfi_offset b13, -112
.cfi_offset b14, -120
.cfi_offset b15, -128
mov	x19, x2
str	d3, [sp, #72]
stp	d2, d1, [sp, #112]
str	d0, [sp, #128]
mov	x21, x1
mov	x20, x0
LFQH_Lloh1440:
adr x22, LFQH_l_.str.172
LFQH_Lloh1441:
nop
mov	x0, x22
bl Lpatch + (0xa5a4 - PATCH_BASE)
mov	x1, x0
mov	x0, x20
bl Lpatch + (0xa5d4 - PATCH_BASE)
mov.16b	v12, v0
mov.16b	v15, v1
mov.16b	v8, v2
mov.16b	v9, v3
LFQH_Lloh1442:
adr x0, LFQH_l_.str.24
LFQH_Lloh1443:
nop
bl Lpatch + (0xa5a4 - PATCH_BASE)
mov	x1, x0
mov	x0, x20
bl Lpatch + (0xa5d4 - PATCH_BASE)
mov.16b	v11, v0
mov.16b	v14, v1
mov.16b	v13, v2
mov.16b	v10, v3
mov	x0, x22
bl Lpatch + (0xa5a4 - PATCH_BASE)
mov	x1, x0
mov	x0, x21
bl Lpatch + (0xa5d4 - PATCH_BASE)
str	d0, [sp, #64]
stp	d2, d1, [sp, #96]
str	d3, [sp, #88]
LFQH_Lloh1444:
adr x1, LFQH_l_.str.224
LFQH_Lloh1445:
nop
mov	x0, x20
bl	LFQH_Get
str	d12, [sp, #80]
stp	d8, d15, [sp, #136]
mov.16b	v2, v8
mov.16b	v8, v11
mov.16b	v11, v9
mov.16b	v3, v9
mov.16b	v9, v14
cbz	x0, LFQH_LBB107_2
mov	x21, x0
LFQH_Lloh1446:
adr x0, LFQH_l_.str.216
LFQH_Lloh1447:
nop
bl Lpatch + (0xa5a4 - PATCH_BASE)
mov	x1, x0
mov	x0, x20
mov.16b	v0, v8
mov.16b	v1, v9
mov.16b	v2, v13
mov.16b	v3, v10
mov	x2, x21
bl Lpatch + (0xa5d4 - PATCH_BASE)
mov.16b	v12, v0
mov.16b	v15, v1
LFQH_LBB107_2:
stp	d3, d2, [sp, #40]
str	d12, [sp, #56]
LFQH_Lloh1448:
adr x1, LFQH_LayoutKey
LFQH_Lloh1449:
nop
mov	x0, x20
bl Lpatch + (0xa628 - PATCH_BASE)
cbz	x0, LFQH_LBB107_23
mov	x21, x0
LFQH_Lloh1450:
adr x0, LFQH_l_.str.229
LFQH_Lloh1451:
nop
bl Lpatch + (0xa5a4 - PATCH_BASE)
mov	x1, x0
mov	x0, x21
mov	x2, #0
bl Lpatch + (0xa5d4 - PATCH_BASE)
mov	x22, x0
LFQH_Lloh1452:
adr x0, LFQH_l_.str.200
LFQH_Lloh1453:
nop
bl Lpatch + (0xa5a4 - PATCH_BASE)
mov	x1, x0
mov	x0, x22
bl Lpatch + (0xa5d4 - PATCH_BASE)
ldr	d4, [sp, #80]
fcmp	d4, d0
b.ne	LFQH_LBB107_23
ldr	d0, [sp, #144]
fcmp	d0, d1
b.ne	LFQH_LBB107_23
ldr	d0, [sp, #136]
fcmp	d0, d2
b.ne	LFQH_LBB107_23
fcmp	d11, d3
b.ne	LFQH_LBB107_23
LFQH_Lloh1454:
adr x0, LFQH_l_.str.229
LFQH_Lloh1455:
nop
bl Lpatch + (0xa5a4 - PATCH_BASE)
mov	x1, x0
mov	x0, x21
mov	w2, #1
bl Lpatch + (0xa5d4 - PATCH_BASE)
mov	x22, x0
LFQH_Lloh1456:
adr x0, LFQH_l_.str.200
LFQH_Lloh1457:
nop
bl Lpatch + (0xa5a4 - PATCH_BASE)
mov	x1, x0
mov	x0, x22
bl Lpatch + (0xa5d4 - PATCH_BASE)
fcmp	d8, d0
b.ne	LFQH_LBB107_23
fcmp	d9, d1
b.ne	LFQH_LBB107_23
fcmp	d13, d2
b.ne	LFQH_LBB107_23
fcmp	d10, d3
b.ne	LFQH_LBB107_23
LFQH_Lloh1458:
adr x0, LFQH_l_.str.229
LFQH_Lloh1459:
nop
bl Lpatch + (0xa5a4 - PATCH_BASE)
mov	x1, x0
mov	x0, x21
mov	w2, #2
bl Lpatch + (0xa5d4 - PATCH_BASE)
mov	x22, x0
LFQH_Lloh1460:
adr x0, LFQH_l_.str.200
LFQH_Lloh1461:
nop
bl Lpatch + (0xa5a4 - PATCH_BASE)
mov	x1, x0
mov	x0, x22
bl Lpatch + (0xa5d4 - PATCH_BASE)
ldr	d4, [sp, #128]
fcmp	d4, d0
b.ne	LFQH_LBB107_23
ldr	d0, [sp, #120]
fcmp	d0, d1
b.ne	LFQH_LBB107_23
ldr	d0, [sp, #112]
fcmp	d0, d2
b.ne	LFQH_LBB107_23
ldr	d0, [sp, #72]
fcmp	d0, d3
b.ne	LFQH_LBB107_23
LFQH_Lloh1462:
adr x0, LFQH_l_.str.229
LFQH_Lloh1463:
nop
bl Lpatch + (0xa5a4 - PATCH_BASE)
mov	x1, x0
mov	x0, x21
mov	w2, #3
bl Lpatch + (0xa5d4 - PATCH_BASE)
mov	x22, x0
LFQH_Lloh1464:
adr x0, LFQH_l_.str.200
LFQH_Lloh1465:
nop
bl Lpatch + (0xa5a4 - PATCH_BASE)
mov	x1, x0
mov	x0, x22
bl Lpatch + (0xa5d4 - PATCH_BASE)
ldr	d4, [sp, #64]
fcmp	d4, d0
b.ne	LFQH_LBB107_23
ldr	d0, [sp, #104]
fcmp	d0, d1
b.ne	LFQH_LBB107_23
ldr	d0, [sp, #96]
fcmp	d0, d2
b.ne	LFQH_LBB107_23
ldr	d0, [sp, #88]
fcmp	d0, d3
b.ne	LFQH_LBB107_23
LFQH_Lloh1466:
adr x0, LFQH_l_.str.229
LFQH_Lloh1467:
nop
bl Lpatch + (0xa5a4 - PATCH_BASE)
mov	x1, x0
mov	x0, x21
mov	w2, #4
bl Lpatch + (0xa5d4 - PATCH_BASE)
mov	x21, x0
LFQH_Lloh1468:
adr x0, LFQH_l_.str.200
LFQH_Lloh1469:
nop
bl Lpatch + (0xa5a4 - PATCH_BASE)
mov	x1, x0
mov	x0, x21
bl Lpatch + (0xa5d4 - PATCH_BASE)
ldr	d4, [sp, #56]
fcmp	d4, d0
b.ne	LFQH_LBB107_23
fcmp	d15, d1
b.ne	LFQH_LBB107_23
ldr	d0, [sp, #48]
fcmp	d0, d2
b.ne	LFQH_LBB107_23
ldr	d0, [sp, #40]
fcmp	d0, d3
b.eq	LFQH_LBB107_26
LFQH_LBB107_23:
LFQH_Lloh1470:
adr x0, LFQH_l_.str.188
LFQH_Lloh1471:
nop
bl Lpatch + (0xa5b0 - PATCH_BASE)
mov	x21, x0
LFQH_Lloh1472:
adr x0, LFQH_l_.str.189
LFQH_Lloh1473:
nop
bl Lpatch + (0xa5a4 - PATCH_BASE)
mov	x1, x0
mov	x0, x21
bl Lpatch + (0xa5d4 - PATCH_BASE)
mov	x21, x0
LFQH_Lloh1474:
adr x0, LFQH_l_.str.190
LFQH_Lloh1475:
nop
bl Lpatch + (0xa5a4 - PATCH_BASE)
mov	x1, x0
mov	x0, x21
bl Lpatch + (0xa5d4 - PATCH_BASE)
mov.16b	v12, v0
LFQH_Lloh1476:
adr x1, LFQH_LayoutTimeKey
LFQH_Lloh1477:
nop
mov	x0, x20
bl Lpatch + (0xa628 - PATCH_BASE)
cbz	x0, LFQH_LBB107_25
mov	x21, x0
LFQH_Lloh1478:
adr x0, LFQH_l_.str.184
LFQH_Lloh1479:
nop
bl Lpatch + (0xa5a4 - PATCH_BASE)
mov	x1, x0
mov	x0, x21
bl Lpatch + (0xa5d4 - PATCH_BASE)
fsub	d0, d12, d0
fmov	d1, #1.00000000
fcmp	d0, d1
b.mi	LFQH_LBB107_26
LFQH_LBB107_25:
LFQH_Lloh1480:
adr x21, LFQH_l_.str.201
LFQH_Lloh1481:
nop
mov	x0, x21
bl Lpatch + (0xa5b0 - PATCH_BASE)
mov	x23, x0
LFQH_Lloh1482:
adr x22, LFQH_l_.str.202
LFQH_Lloh1483:
nop
mov	x0, x22
bl Lpatch + (0xa5a4 - PATCH_BASE)
mov	x1, x0
mov	x0, x23
ldr	d14, [sp, #80]
mov.16b	v0, v14
ldp	d2, d1, [sp, #136]
stp	d9, d8, [sp, #16]
str	d11, [sp, #32]
mov.16b	v3, v11
bl Lpatch + (0xa5d4 - PATCH_BASE)
str	x0, [sp, #152]
mov	x0, x21
bl Lpatch + (0xa5b0 - PATCH_BASE)
mov	x23, x0
mov	x0, x22
bl Lpatch + (0xa5a4 - PATCH_BASE)
mov	x1, x0
mov	x0, x23
mov.16b	v0, v8
mov.16b	v1, v9
mov.16b	v2, v13
mov.16b	v3, v10
bl Lpatch + (0xa5d4 - PATCH_BASE)
str	x0, [sp, #160]
mov	x0, x21
bl Lpatch + (0xa5b0 - PATCH_BASE)
mov	x23, x0
mov	x0, x22
bl Lpatch + (0xa5a4 - PATCH_BASE)
mov	x1, x0
mov	x0, x23
ldp	d1, d0, [sp, #120]
ldr	d2, [sp, #112]
stp	d13, d10, [sp]
ldp	d11, d13, [sp, #64]
mov.16b	v3, v13
bl Lpatch + (0xa5d4 - PATCH_BASE)
str	x0, [sp, #168]
mov	x0, x21
bl Lpatch + (0xa5b0 - PATCH_BASE)
mov	x23, x0
mov	x0, x22
bl Lpatch + (0xa5a4 - PATCH_BASE)
mov	x1, x0
mov	x0, x23
mov.16b	v0, v11
ldp	d2, d1, [sp, #96]
ldr	d3, [sp, #88]
bl Lpatch + (0xa5d4 - PATCH_BASE)
str	x0, [sp, #176]
mov	x0, x21
bl Lpatch + (0xa5b0 - PATCH_BASE)
mov	x21, x0
mov	x0, x22
bl Lpatch + (0xa5a4 - PATCH_BASE)
mov	x1, x0
mov	x0, x21
ldp	d9, d8, [sp, #48]
mov.16b	v0, v8
mov.16b	v1, v15
mov.16b	v2, v9
ldr	d10, [sp, #40]
mov.16b	v3, v10
bl Lpatch + (0xa5d4 - PATCH_BASE)
str	x0, [sp, #184]
LFQH_Lloh1484:
adr x0, LFQH_l_.str.35
LFQH_Lloh1485:
nop
bl Lpatch + (0xa5b0 - PATCH_BASE)
mov	x21, x0
LFQH_Lloh1486:
adr x0, LFQH_l_.str.225
LFQH_Lloh1487:
nop
bl Lpatch + (0xa5a4 - PATCH_BASE)
mov	x1, x0
add	x2, sp, #152
mov	x0, x21
mov	w3, #5
bl Lpatch + (0xa5d4 - PATCH_BASE)
mov	x2, x0
LFQH_Lloh1488:
adr x1, LFQH_LayoutKey
LFQH_Lloh1489:
nop
mov	x0, x20
mov	w3, #1
bl Lpatch + (0xa634 - PATCH_BASE)
LFQH_Lloh1490:
adr x0, LFQH_l_.str.182
LFQH_Lloh1491:
nop
bl Lpatch + (0xa5b0 - PATCH_BASE)
mov	x21, x0
LFQH_Lloh1492:
adr x0, LFQH_l_.str.185
LFQH_Lloh1493:
nop
bl Lpatch + (0xa5a4 - PATCH_BASE)
mov	x1, x0
mov	x0, x21
mov.16b	v0, v12
bl Lpatch + (0xa5d4 - PATCH_BASE)
mov	x2, x0
LFQH_Lloh1494:
adr x1, LFQH_LayoutTimeKey
LFQH_Lloh1495:
nop
mov	x0, x20
mov	w3, #1
bl Lpatch + (0xa634 - PATCH_BASE)
LFQH_Lloh1496:
adr x0, LFQH_l_.str.73
LFQH_Lloh1497:
nop
bl Lpatch + (0xa5b0 - PATCH_BASE)
mov	x20, x0
LFQH_Lloh1498:
adr x0, LFQH_l_.str.74
LFQH_Lloh1499:
nop
bl Lpatch + (0xa5a4 - PATCH_BASE)
mov	x1, x0
mov	x0, x20
bl Lpatch + (0xa5d4 - PATCH_BASE)
mov	x20, x0
LFQH_Lloh1500:
adr x0, LFQH_l_.str.156
LFQH_Lloh1501:
nop
bl Lpatch + (0xa5b0 - PATCH_BASE)
mov	x21, x0
LFQH_Lloh1502:
adr x0, LFQH_l_.str.157
LFQH_Lloh1503:
nop
bl Lpatch + (0xa5a4 - PATCH_BASE)
mov	x1, x0
mov	x0, x21
mov	x2, x19
bl Lpatch + (0xa5d4 - PATCH_BASE)
mov	x2, x0
LFQH_Lloh1504:
adr x1, LFQH_l_.str.191
LFQH_Lloh1505:
nop
mov	x0, x20
bl	LFQH_Put
mov.16b	v0, v14
ldp	d2, d1, [sp, #136]
ldr	d3, [sp, #32]
bl	LFQH_RectArray
mov	x2, x0
LFQH_Lloh1506:
adr x1, LFQH_l_.str.192
LFQH_Lloh1507:
nop
mov	x0, x20
bl	LFQH_Put
ldp	d1, d0, [sp, #16]
ldp	d2, d3, [sp]
bl	LFQH_RectArray
mov	x2, x0
LFQH_Lloh1508:
adr x1, LFQH_l_.str.193
LFQH_Lloh1509:
nop
mov	x0, x20
bl	LFQH_Put
ldp	d1, d0, [sp, #120]
ldr	d2, [sp, #112]
mov.16b	v3, v13
bl	LFQH_RectArray
mov	x2, x0
LFQH_Lloh1510:
adr x1, LFQH_l_.str.226
LFQH_Lloh1511:
nop
mov	x0, x20
bl	LFQH_Put
mov.16b	v0, v11
ldp	d2, d1, [sp, #96]
ldr	d3, [sp, #88]
bl	LFQH_RectArray
mov	x2, x0
LFQH_Lloh1512:
adr x1, LFQH_l_.str.194
LFQH_Lloh1513:
nop
mov	x0, x20
bl	LFQH_Put
mov.16b	v0, v8
mov.16b	v1, v15
mov.16b	v2, v9
mov.16b	v3, v10
bl	LFQH_RectArray
mov	x2, x0
LFQH_Lloh1514:
adr x1, LFQH_l_.str.227
LFQH_Lloh1515:
nop
mov	x0, x20
bl	LFQH_Put
LFQH_Lloh1516:
adr x0, LFQH_l_.str.228
LFQH_Lloh1517:
nop
mov	x1, x20
bl Lrecord_named
LFQH_LBB107_26:
ldp	x29, x30, [sp, #304]
ldp	x20, x19, [sp, #288]
ldp	x22, x21, [sp, #272]
ldp	x24, x23, [sp, #256]
ldp	d9, d8, [sp, #240]
ldp	d11, d10, [sp, #224]
ldp	d13, d12, [sp, #208]
ldp	d15, d14, [sp, #192]
add	sp, sp, #320
ret
.cfi_endproc
.p2align	2
LFQH_LayoutKey:
.cfi_startproc
ret
.cfi_endproc
.p2align	2
LFQH_LayoutTimeKey:
.cfi_startproc
ret
.cfi_endproc
.p2align	2
LFQH_RestoreOwner:
.cfi_startproc
stp	x22, x21, [sp, #-48]!
stp	x20, x19, [sp, #16]
stp	x29, x30, [sp, #32]
add	x29, sp, #32
.cfi_def_cfa w29, 16
.cfi_offset w30, -8
.cfi_offset w29, -16
.cfi_offset w19, -24
.cfi_offset w20, -32
.cfi_offset w21, -40
.cfi_offset w22, -48
mov	x19, x0
LFQH_Lloh1518:
adr x1, LFQH_ClipsKey
LFQH_Lloh1519:
nop
bl Lpatch + (0xa628 - PATCH_BASE)
mov	x21, x0
LFQH_Lloh1520:
adr x1, LFQH_OpaqueKey
LFQH_Lloh1521:
nop
mov	x0, x19
bl Lpatch + (0xa628 - PATCH_BASE)
mov	x20, x0
cbz	x21, LFQH_LBB110_3
LFQH_Lloh1522:
adr x0, LFQH_l_.str.177
LFQH_Lloh1523:
nop
bl Lpatch + (0xa5a4 - PATCH_BASE)
mov	x1, x0
mov	x0, x19
bl Lpatch + (0xa5d4 - PATCH_BASE)
cbnz	w0, LFQH_LBB110_3
LFQH_Lloh1524:
adr x0, LFQH_l_.str.179
LFQH_Lloh1525:
nop
bl Lpatch + (0xa5a4 - PATCH_BASE)
mov	x22, x0
LFQH_Lloh1526:
adr x0, LFQH_l_.str.215
LFQH_Lloh1527:
nop
bl Lpatch + (0xa5a4 - PATCH_BASE)
mov	x1, x0
mov	x0, x21
bl Lpatch + (0xa5d4 - PATCH_BASE)
mov	x2, x0
mov	x0, x19
mov	x1, x22
bl Lpatch + (0xa5d4 - PATCH_BASE)
LFQH_LBB110_3:
cbz	x20, LFQH_LBB110_6
LFQH_Lloh1528:
adr x0, LFQH_l_.str.178
LFQH_Lloh1529:
nop
bl Lpatch + (0xa5a4 - PATCH_BASE)
mov	x1, x0
mov	x0, x19
bl Lpatch + (0xa5d4 - PATCH_BASE)
cbnz	w0, LFQH_LBB110_6
LFQH_Lloh1530:
adr x0, LFQH_l_.str.165
LFQH_Lloh1531:
nop
bl Lpatch + (0xa5a4 - PATCH_BASE)
mov	x21, x0
LFQH_Lloh1532:
adr x0, LFQH_l_.str.215
LFQH_Lloh1533:
nop
bl Lpatch + (0xa5a4 - PATCH_BASE)
mov	x1, x0
mov	x0, x20
bl Lpatch + (0xa5d4 - PATCH_BASE)
mov	x2, x0
mov	x0, x19
mov	x1, x21
bl Lpatch + (0xa5d4 - PATCH_BASE)
LFQH_LBB110_6:
LFQH_Lloh1534:
adr x1, LFQH_ClipsKey
LFQH_Lloh1535:
nop
mov	x0, x19
mov	x2, #0
mov	w3, #1
bl Lpatch + (0xa634 - PATCH_BASE)
LFQH_Lloh1536:
adr x1, LFQH_OpaqueKey
LFQH_Lloh1537:
nop
mov	x0, x19
mov	x2, #0
mov	w3, #1
ldp	x29, x30, [sp, #32]
ldp	x20, x19, [sp, #16]
ldp	x22, x21, [sp], #48
b Lpatch + (0xa634 - PATCH_BASE)
.cfi_endproc
.p2align	2
LFQH_Press:
.cfi_startproc
stp	x20, x19, [sp, #-32]!
stp	x29, x30, [sp, #16]
add	x29, sp, #16
.cfi_def_cfa w29, 16
.cfi_offset w30, -8
.cfi_offset w29, -16
.cfi_offset w19, -24
.cfi_offset w20, -32
mov	x19, x0
LFQH_Lloh1538:
adr x0, LFQH_l_.str.212
LFQH_Lloh1539:
nop
bl Lpatch + (0xa5a4 - PATCH_BASE)
mov	x1, x0
mov	x0, x19
mov	w2, #1
ldp	x29, x30, [sp, #16]
ldp	x20, x19, [sp], #32
b Lpatch + (0xa5d4 - PATCH_BASE)
.cfi_endproc
.p2align	2
LFQH_ReleasePress:
.cfi_startproc
stp	x20, x19, [sp, #-32]!
stp	x29, x30, [sp, #16]
add	x29, sp, #16
.cfi_def_cfa w29, 16
.cfi_offset w30, -8
.cfi_offset w29, -16
.cfi_offset w19, -24
.cfi_offset w20, -32
mov	x19, x0
LFQH_Lloh1540:
adr x0, LFQH_l_.str.212
LFQH_Lloh1541:
nop
bl Lpatch + (0xa5a4 - PATCH_BASE)
mov	x1, x0
mov	x0, x19
mov	w2, #0
ldp	x29, x30, [sp, #16]
ldp	x20, x19, [sp], #32
b Lpatch + (0xa5d4 - PATCH_BASE)
.cfi_endproc
.p2align	2
LFQH_HitInsetsKey:
.cfi_startproc
ret
.cfi_endproc
.p2align	2
LFQH_AppliedHitInsetsKey:
.cfi_startproc
ret
.cfi_endproc
.p2align	2
LFQH_RestoreHeaderOwner:
.cfi_startproc
stp	d9, d8, [sp, #-80]!
stp	x24, x23, [sp, #16]
stp	x22, x21, [sp, #32]
stp	x20, x19, [sp, #48]
stp	x29, x30, [sp, #64]
add	x29, sp, #64
.cfi_def_cfa w29, 16
.cfi_offset w30, -8
.cfi_offset w29, -16
.cfi_offset w19, -24
.cfi_offset w20, -32
.cfi_offset w21, -40
.cfi_offset w22, -48
.cfi_offset w23, -56
.cfi_offset w24, -64
.cfi_offset b8, -72
.cfi_offset b9, -80
mov	x19, x0
LFQH_Lloh1542:
adr x1, LFQH_HeaderClipsKey
LFQH_Lloh1543:
nop
bl Lpatch + (0xa628 - PATCH_BASE)
mov	x23, x0
LFQH_Lloh1544:
adr x1, LFQH_HeaderOpaqueKey
LFQH_Lloh1545:
nop
mov	x0, x19
bl Lpatch + (0xa628 - PATCH_BASE)
mov	x22, x0
LFQH_Lloh1546:
adr x1, LFQH_HeaderRadiusKey
LFQH_Lloh1547:
nop
mov	x0, x19
bl Lpatch + (0xa628 - PATCH_BASE)
mov	x20, x0
LFQH_Lloh1548:
adr x1, LFQH_HeaderAppliedRadiusKey
LFQH_Lloh1549:
nop
mov	x0, x19
bl Lpatch + (0xa628 - PATCH_BASE)
mov	x21, x0
cbz	x23, LFQH_LBB115_3
LFQH_Lloh1550:
adr x0, LFQH_l_.str.177
LFQH_Lloh1551:
nop
bl Lpatch + (0xa5a4 - PATCH_BASE)
mov	x1, x0
mov	x0, x19
bl Lpatch + (0xa5d4 - PATCH_BASE)
cbz	w0, LFQH_LBB115_3
LFQH_Lloh1552:
adr x0, LFQH_l_.str.179
LFQH_Lloh1553:
nop
bl Lpatch + (0xa5a4 - PATCH_BASE)
mov	x24, x0
LFQH_Lloh1554:
adr x0, LFQH_l_.str.215
LFQH_Lloh1555:
nop
bl Lpatch + (0xa5a4 - PATCH_BASE)
mov	x1, x0
mov	x0, x23
bl Lpatch + (0xa5d4 - PATCH_BASE)
mov	x2, x0
mov	x0, x19
mov	x1, x24
bl Lpatch + (0xa5d4 - PATCH_BASE)
LFQH_LBB115_3:
cbz	x22, LFQH_LBB115_6
LFQH_Lloh1556:
adr x0, LFQH_l_.str.178
LFQH_Lloh1557:
nop
bl Lpatch + (0xa5a4 - PATCH_BASE)
mov	x1, x0
mov	x0, x19
bl Lpatch + (0xa5d4 - PATCH_BASE)
cbnz	w0, LFQH_LBB115_6
LFQH_Lloh1558:
adr x0, LFQH_l_.str.165
LFQH_Lloh1559:
nop
bl Lpatch + (0xa5a4 - PATCH_BASE)
mov	x23, x0
LFQH_Lloh1560:
adr x0, LFQH_l_.str.215
LFQH_Lloh1561:
nop
bl Lpatch + (0xa5a4 - PATCH_BASE)
mov	x1, x0
mov	x0, x22
bl Lpatch + (0xa5d4 - PATCH_BASE)
mov	x2, x0
mov	x0, x19
mov	x1, x23
bl Lpatch + (0xa5d4 - PATCH_BASE)
LFQH_LBB115_6:
cbz	x20, LFQH_LBB115_10
cbz	x21, LFQH_LBB115_10
LFQH_Lloh1562:
adr x0, LFQH_l_.str.180
LFQH_Lloh1563:
nop
bl Lpatch + (0xa5a4 - PATCH_BASE)
mov	x1, x0
mov	x0, x19
bl Lpatch + (0xa5d4 - PATCH_BASE)
mov	x22, x0
LFQH_Lloh1564:
adr x0, LFQH_l_.str.181
LFQH_Lloh1565:
nop
bl Lpatch + (0xa5a4 - PATCH_BASE)
mov	x1, x0
mov	x0, x22
bl Lpatch + (0xa5d4 - PATCH_BASE)
mov.16b	v8, v0
LFQH_Lloh1566:
adr x0, LFQH_l_.str.184
LFQH_Lloh1567:
nop
bl Lpatch + (0xa5a4 - PATCH_BASE)
mov	x1, x0
mov	x0, x21
bl Lpatch + (0xa5d4 - PATCH_BASE)
fcmp	d8, d0
b.ne	LFQH_LBB115_10
LFQH_Lloh1568:
adr x0, LFQH_l_.str.184
LFQH_Lloh1569:
nop
bl Lpatch + (0xa5a4 - PATCH_BASE)
mov	x1, x0
mov	x0, x20
bl Lpatch + (0xa5d4 - PATCH_BASE)
mov.16b	v8, v0
LFQH_Lloh1570:
adr x0, LFQH_l_.str.180
LFQH_Lloh1571:
nop
bl Lpatch + (0xa5a4 - PATCH_BASE)
mov	x1, x0
mov	x0, x19
bl Lpatch + (0xa5d4 - PATCH_BASE)
mov	x20, x0
LFQH_Lloh1572:
adr x0, LFQH_l_.str.186
LFQH_Lloh1573:
nop
bl Lpatch + (0xa5a4 - PATCH_BASE)
mov	x1, x0
mov	x0, x20
mov.16b	v0, v8
bl Lpatch + (0xa5d4 - PATCH_BASE)
LFQH_LBB115_10:
LFQH_Lloh1574:
adr x1, LFQH_HeaderClipsKey
LFQH_Lloh1575:
nop
mov	x0, x19
mov	x2, #0
mov	w3, #1
bl Lpatch + (0xa634 - PATCH_BASE)
LFQH_Lloh1576:
adr x1, LFQH_HeaderOpaqueKey
LFQH_Lloh1577:
nop
mov	x0, x19
mov	x2, #0
mov	w3, #1
bl Lpatch + (0xa634 - PATCH_BASE)
LFQH_Lloh1578:
adr x1, LFQH_HeaderRadiusKey
LFQH_Lloh1579:
nop
mov	x0, x19
mov	x2, #0
mov	w3, #1
bl Lpatch + (0xa634 - PATCH_BASE)
LFQH_Lloh1580:
adr x1, LFQH_HeaderAppliedRadiusKey
LFQH_Lloh1581:
nop
mov	x0, x19
mov	x2, #0
mov	w3, #1
bl Lpatch + (0xa634 - PATCH_BASE)
LFQH_Lloh1582:
adr x1, LFQH_HeaderLogKey
LFQH_Lloh1583:
nop
mov	x0, x19
mov	x2, #0
mov	w3, #1
bl Lpatch + (0xa634 - PATCH_BASE)
LFQH_Lloh1584:
adr x1, LFQH_HeaderLogTimeKey
LFQH_Lloh1585:
nop
mov	x0, x19
mov	x2, #0
mov	w3, #1
ldp	x29, x30, [sp, #64]
ldp	x20, x19, [sp, #48]
ldp	x22, x21, [sp, #32]
ldp	x24, x23, [sp, #16]
ldp	d9, d8, [sp], #80
b Lpatch + (0xa634 - PATCH_BASE)
.cfi_endproc
.p2align	2
LFQH_DefaultEnabled:
.cfi_startproc
stp	x22, x21, [sp, #-48]!
stp	x20, x19, [sp, #16]
stp	x29, x30, [sp, #32]
add	x29, sp, #32
.cfi_def_cfa w29, 16
.cfi_offset w30, -8
.cfi_offset w29, -16
.cfi_offset w19, -24
.cfi_offset w20, -32
.cfi_offset w21, -40
.cfi_offset w22, -48
mov	x19, x0
LFQH_Lloh1586:
adr x0, LFQH_l_.str.242
LFQH_Lloh1587:
nop
bl Lpatch + (0xa5b0 - PATCH_BASE)
mov	x20, x0
LFQH_Lloh1588:
adr x0, LFQH_l_.str.243
LFQH_Lloh1589:
nop
bl Lpatch + (0xa5a4 - PATCH_BASE)
mov	x1, x0
mov	x0, x20
bl Lpatch + (0xa5d4 - PATCH_BASE)
mov	x20, x0
LFQH_Lloh1590:
adr x0, LFQH_l_.str.255
LFQH_Lloh1591:
nop
bl Lpatch + (0xa5a4 - PATCH_BASE)
mov	x21, x0
LFQH_Lloh1592:
adr x0, LFQH_l_.str.156
LFQH_Lloh1593:
nop
bl Lpatch + (0xa5b0 - PATCH_BASE)
mov	x22, x0
LFQH_Lloh1594:
adr x0, LFQH_l_.str.157
LFQH_Lloh1595:
nop
bl Lpatch + (0xa5a4 - PATCH_BASE)
mov	x1, x0
mov	x0, x22
mov	x2, x19
bl Lpatch + (0xa5d4 - PATCH_BASE)
mov	x2, x0
mov	x0, x20
mov	x1, x21
bl Lpatch + (0xa5d4 - PATCH_BASE)
cbz	x0, LFQH_LBB116_2
LFQH_Lloh1596:
adr x1, LFQH_l_.str.215
LFQH_Lloh1597:
nop
ldp	x29, x30, [sp, #32]
ldp	x20, x19, [sp, #16]
ldp	x22, x21, [sp], #48
b	LFQH_BoolProp
LFQH_LBB116_2:
mov	w0, #1
ldp	x29, x30, [sp, #32]
ldp	x20, x19, [sp, #16]
ldp	x22, x21, [sp], #48
ret
.cfi_endproc
.p2align	2
LFQH_BoolProp:
.cfi_startproc
stp	x20, x19, [sp, #-32]!
stp	x29, x30, [sp, #16]
add	x29, sp, #16
.cfi_def_cfa w29, 16
.cfi_offset w30, -8
.cfi_offset w29, -16
.cfi_offset w19, -24
.cfi_offset w20, -32
mov	x20, x1
mov	x19, x0
bl	LFQH_Responds
cbz	w0, LFQH_LBB117_2
mov	x0, x20
bl Lpatch + (0xa5a4 - PATCH_BASE)
mov	x1, x0
mov	x0, x19
ldp	x29, x30, [sp, #16]
ldp	x20, x19, [sp], #32
b Lpatch + (0xa5d4 - PATCH_BASE)
LFQH_LBB117_2:
ldp	x29, x30, [sp, #16]
ldp	x20, x19, [sp], #32
ret
.cfi_endproc
.p2align	2
LFQH_PageRestore:
.cfi_startproc
stp	x20, x19, [sp, #-32]!
stp	x29, x30, [sp, #16]
add	x29, sp, #16
.cfi_def_cfa w29, 16
.cfi_offset w30, -8
.cfi_offset w29, -16
.cfi_offset w19, -24
.cfi_offset w20, -32
cbz	x0, LFQH_LBB118_3
mov	x19, x0
LFQH_Lloh1598:
adr x0, LFQH_l_.str.159
LFQH_Lloh1599:
nop
bl Lpatch + (0xa5a4 - PATCH_BASE)
mov	x20, x0
LFQH_Lloh1600:
adr x0, LFQH_l_.str.23
LFQH_Lloh1601:
nop
bl Lpatch + (0xa5b0 - PATCH_BASE)
mov	x2, x0
mov	x0, x19
mov	x1, x20
bl Lpatch + (0xa5d4 - PATCH_BASE)
cbz	w0, LFQH_LBB118_3
LFQH_Lloh1602:
adr x1, LFQH_SurfaceKey
LFQH_Lloh1603:
nop
mov	x0, x19
bl Lpatch + (0xa628 - PATCH_BASE)
mov	x1, x0
mov	x0, x19
ldp	x29, x30, [sp, #16]
ldp	x20, x19, [sp], #32
b	LFQH_Restore
LFQH_LBB118_3:
ldp	x29, x30, [sp, #16]
ldp	x20, x19, [sp], #32
ret
.cfi_endproc
.p2align	2
LFQH_PageRole:
.cfi_startproc
stp	x22, x21, [sp, #-48]!
stp	x20, x19, [sp, #16]
stp	x29, x30, [sp, #32]
add	x29, sp, #32
.cfi_def_cfa w29, 16
.cfi_offset w30, -8
.cfi_offset w29, -16
.cfi_offset w19, -24
.cfi_offset w20, -32
.cfi_offset w21, -40
.cfi_offset w22, -48
mov	x19, x1
mov	x20, x0
LFQH_Lloh1604:
adr x0, LFQH_l_.str.156
LFQH_Lloh1605:
nop
bl Lpatch + (0xa5b0 - PATCH_BASE)
mov	x21, x0
LFQH_Lloh1606:
adr x0, LFQH_l_.str.157
LFQH_Lloh1607:
nop
bl Lpatch + (0xa5a4 - PATCH_BASE)
mov	x1, x0
mov	x0, x21
mov	x2, x19
bl Lpatch + (0xa5d4 - PATCH_BASE)
mov	x2, x0
LFQH_Lloh1608:
adr x1, LFQH_PageRoleKey
LFQH_Lloh1609:
nop
mov	x0, x20
mov	w3, #1
ldp	x29, x30, [sp, #32]
ldp	x20, x19, [sp, #16]
ldp	x22, x21, [sp], #48
b Lpatch + (0xa634 - PATCH_BASE)
.cfi_endproc
.p2align	2
LFQH_PageRoleKey:
.cfi_startproc
ret
.cfi_endproc
.p2align	2
LFQH_ShelfTint:
.cfi_startproc
stp	x24, x23, [sp, #-64]!
stp	x22, x21, [sp, #16]
stp	x20, x19, [sp, #32]
stp	x29, x30, [sp, #48]
add	x29, sp, #48
.cfi_def_cfa w29, 16
.cfi_offset w30, -8
.cfi_offset w29, -16
.cfi_offset w19, -24
.cfi_offset w20, -32
.cfi_offset w21, -40
.cfi_offset w22, -48
.cfi_offset w23, -56
.cfi_offset w24, -64
cbz	x0, LFQH_LBB121_6
mov	x22, x2
mov	x20, x1
mov	x19, x0
LFQH_Lloh1610:
adr x1, LFQH_PageTintKey
LFQH_Lloh1611:
nop
bl Lpatch + (0xa628 - PATCH_BASE)
cbz	x0, LFQH_LBB121_3
LFQH_Lloh1612:
adr x1, LFQH_l_.str.215
LFQH_Lloh1613:
nop
bl	LFQH_BoolProp
cmp	w0, w20
b.eq	LFQH_LBB121_6
LFQH_LBB121_3:
LFQH_Lloh1614:
adr x1, LFQH_l_.str.54
LFQH_Lloh1615:
nop
mov	x0, x19
bl	LFQH_Get
mov	x21, x0
LFQH_Lloh1616:
adr x0, LFQH_l_.str.55
LFQH_Lloh1617:
nop
bl Lpatch + (0xa5a4 - PATCH_BASE)
mov	x1, x0
mov	x0, x21
bl Lpatch + (0xa5d4 - PATCH_BASE)
cbz	x0, LFQH_LBB121_6
mov	x21, x0
cbz	w20, LFQH_LBB121_7
LFQH_Lloh1618:
adr x0, LFQH_l_.str.49
LFQH_Lloh1619:
nop
bl Lpatch + (0xa5b0 - PATCH_BASE)
mov	x23, x0
LFQH_Lloh1620:
adr x8, LFQH_l_.str.260
LFQH_Lloh1621:
nop
LFQH_Lloh1622:
adr x9, LFQH_l_.str.50
LFQH_Lloh1623:
nop
cmp	w22, #0
csel	x0, x9, x8, eq
bl Lpatch + (0xa5a4 - PATCH_BASE)
mov	x1, x0
mov	x0, x23
bl Lpatch + (0xa5d4 - PATCH_BASE)
mov	x22, x0
b	LFQH_LBB121_8
LFQH_LBB121_6:
ldp	x29, x30, [sp, #48]
ldp	x20, x19, [sp, #32]
ldp	x22, x21, [sp, #16]
ldp	x24, x23, [sp], #64
ret
LFQH_LBB121_7:
mov	x22, #0
LFQH_LBB121_8:
LFQH_Lloh1624:
adr x0, LFQH_l_.str.53
LFQH_Lloh1625:
nop
bl Lpatch + (0xa5a4 - PATCH_BASE)
mov	x1, x0
fmov	d0, #0.12500000
mov	x0, x22
bl Lpatch + (0xa5d4 - PATCH_BASE)
mov	x22, x0
LFQH_Lloh1626:
adr x0, LFQH_l_.str.56
LFQH_Lloh1627:
nop
bl Lpatch + (0xa5a4 - PATCH_BASE)
mov	x1, x0
mov	x0, x21
mov	x2, x22
bl Lpatch + (0xa5d4 - PATCH_BASE)
LFQH_Lloh1628:
adr x0, LFQH_l_.str.57
LFQH_Lloh1629:
nop
bl Lpatch + (0xa5a4 - PATCH_BASE)
mov	x1, x0
mov	x0, x19
mov	x2, x21
bl Lpatch + (0xa5d4 - PATCH_BASE)
LFQH_Lloh1630:
adr x0, LFQH_l_.str.58
LFQH_Lloh1631:
nop
bl Lpatch + (0xa5a4 - PATCH_BASE)
mov	x1, x0
mov	x0, x21
bl Lpatch + (0xa5d4 - PATCH_BASE)
LFQH_Lloh1632:
adr x0, LFQH_l_.str.182
LFQH_Lloh1633:
nop
bl Lpatch + (0xa5b0 - PATCH_BASE)
mov	x21, x0
LFQH_Lloh1634:
adr x0, LFQH_l_.str.183
LFQH_Lloh1635:
nop
bl Lpatch + (0xa5a4 - PATCH_BASE)
mov	x1, x0
mov	x0, x21
mov	x2, x20
bl Lpatch + (0xa5d4 - PATCH_BASE)
mov	x2, x0
LFQH_Lloh1636:
adr x1, LFQH_PageTintKey
LFQH_Lloh1637:
nop
mov	x0, x19
mov	w3, #1
ldp	x29, x30, [sp, #48]
ldp	x20, x19, [sp, #32]
ldp	x22, x21, [sp, #16]
ldp	x24, x23, [sp], #64
b Lpatch + (0xa634 - PATCH_BASE)
.cfi_endproc
.p2align	2
LFQH_PageTintKey:
.cfi_startproc
ret
.cfi_endproc
.p2align	2
LFQH_Original:
.cfi_startproc
stp	x20, x19, [sp, #-32]!
stp	x29, x30, [sp, #16]
add	x29, sp, #16
.cfi_def_cfa w29, 16
.cfi_offset w30, -8
.cfi_offset w29, -16
.cfi_offset w19, -24
.cfi_offset w20, -32
mov	x19, x1
bl Lpatch + (0xa5b0 - PATCH_BASE)
mov	x20, x0
mov	x0, x19
bl Lpatch + (0xa5a4 - PATCH_BASE)
mov	x1, x0
mov	x0, x20
bl Lpatch + (0xa5f8 - PATCH_BASE)
ldp	x29, x30, [sp, #16]
ldp	x20, x19, [sp], #32
b Lpatch + (0xa598 - PATCH_BASE)
.cfi_endproc
.p2align	2
LFQH_ReaderBottomGlass:
.cfi_startproc
stp	x20, x19, [sp, #-32]!
stp	x29, x30, [sp, #16]
add	x29, sp, #16
.cfi_def_cfa w29, 16
.cfi_offset w30, -8
.cfi_offset w29, -16
.cfi_offset w19, -24
.cfi_offset w20, -32
mov	x19, x0
LFQH_Lloh1638:
adr x0, LFQH_l_.str.24
LFQH_Lloh1639:
nop
bl Lpatch + (0xa5a4 - PATCH_BASE)
mov	x1, x0
mov	x0, x19
bl Lpatch + (0xa5d4 - PATCH_BASE)
fmov	d4, #6.00000000
fadd	d0, d0, d4
fmov	d4, #-12.00000000
fadd	d2, d2, d4
fmov	d4, #4.00000000
fadd	d1, d1, d4
fmov	d4, #-8.00000000
fadd	d3, d3, d4
mov	x0, x19
mov	w1, #0
ldp	x29, x30, [sp, #16]
ldp	x20, x19, [sp], #32
b	LFQH_ApplySurface
.cfi_endproc
.p2align	2
LFQH_HasAncestor:
.cfi_startproc
stp	x24, x23, [sp, #-64]!
stp	x22, x21, [sp, #16]
stp	x20, x19, [sp, #32]
stp	x29, x30, [sp, #48]
add	x29, sp, #48
.cfi_def_cfa w29, 16
.cfi_offset w30, -8
.cfi_offset w29, -16
.cfi_offset w19, -24
.cfi_offset w20, -32
.cfi_offset w21, -40
.cfi_offset w22, -48
.cfi_offset w23, -56
.cfi_offset w24, -64
mov	x19, x1
LFQH_Lloh1640:
adr x1, LFQH_l_.str.20
LFQH_Lloh1641:
nop
bl	LFQH_Get
cbz	x0, LFQH_LBB125_5
mov	x20, x0
mov	w24, #0
LFQH_Lloh1642:
adr x21, LFQH_l_.str.159
LFQH_Lloh1643:
nop
LFQH_Lloh1644:
adr x22, LFQH_l_.str.20
LFQH_Lloh1645:
nop
LFQH_LBB125_2:
mov	x0, x21
bl Lpatch + (0xa5a4 - PATCH_BASE)
mov	x23, x0
mov	x0, x19
bl Lpatch + (0xa5b0 - PATCH_BASE)
mov	x2, x0
mov	x0, x20
mov	x1, x23
bl Lpatch + (0xa5d4 - PATCH_BASE)
cmp	w0, #0
cset	w23, ne
cbnz	w0, LFQH_LBB125_6
mov	x0, x20
mov	x1, x22
bl	LFQH_Get
cbz	x0, LFQH_LBB125_6
mov	x20, x0
cmp	w24, #4
add	w24, w24, #1
b.lo	LFQH_LBB125_2
b	LFQH_LBB125_6
LFQH_LBB125_5:
mov	w23, #0
LFQH_LBB125_6:
mov	x0, x23
ldp	x29, x30, [sp, #48]
ldp	x20, x19, [sp, #32]
ldp	x22, x21, [sp, #16]
ldp	x24, x23, [sp], #64
ret
.cfi_endproc
.p2align	2
LFQH_ShelfFilterStyle:
.cfi_startproc
stp	d11, d10, [sp, #-64]!
stp	d9, d8, [sp, #16]
stp	x20, x19, [sp, #32]
stp	x29, x30, [sp, #48]
add	x29, sp, #48
.cfi_def_cfa w29, 16
.cfi_offset w30, -8
.cfi_offset w29, -16
.cfi_offset w19, -24
.cfi_offset w20, -32
.cfi_offset b8, -40
.cfi_offset b9, -48
.cfi_offset b10, -56
.cfi_offset b11, -64
mov	x19, x0
LFQH_Lloh1646:
adr x1, LFQH_l_.str.269
LFQH_Lloh1647:
nop
bl	LFQH_HasAncestor
cbz	w0, LFQH_LBB126_3
LFQH_Lloh1648:
adr x1, LFQH_l_.str.270
LFQH_Lloh1649:
nop
mov	x0, x19
bl	LFQH_HasAncestor
tbz	w0, #0, LFQH_LBB126_3
LFQH_Lloh1650:
adr x0, LFQH_l_.str.24
LFQH_Lloh1651:
nop
bl Lpatch + (0xa5a4 - PATCH_BASE)
mov	x1, x0
mov	x0, x19
bl Lpatch + (0xa5d4 - PATCH_BASE)
fmov	d4, #1.00000000
fadd	d8, d0, d4
fmov	d0, #-2.00000000
fadd	d9, d2, d0
fadd	d10, d1, d4
fadd	d11, d3, d0
LFQH_Lloh1652:
adr x1, LFQH_l_.str.271
LFQH_Lloh1653:
nop
mov	x0, x19
bl	LFQH_PageRole
mov	x0, x19
mov.16b	v0, v8
mov.16b	v1, v10
mov.16b	v2, v9
mov.16b	v3, v11
mov	w1, #0
bl	LFQH_ApplySurface
LFQH_Lloh1654:
adr x1, LFQH_SurfaceKey
LFQH_Lloh1655:
nop
mov	x0, x19
bl Lpatch + (0xa628 - PATCH_BASE)
mov	x20, x0
LFQH_Lloh1656:
adr x1, LFQH_l_.str.272
LFQH_Lloh1657:
nop
mov	x0, x19
bl	LFQH_BoolProp
mov	x1, x0
mov	x0, x20
mov	w2, #1
ldp	x29, x30, [sp, #48]
ldp	x20, x19, [sp, #32]
ldp	d9, d8, [sp, #16]
ldp	d11, d10, [sp], #64
b	LFQH_ShelfTint
LFQH_LBB126_3:
mov	x0, x19
ldp	x29, x30, [sp, #48]
ldp	x20, x19, [sp, #32]
ldp	d9, d8, [sp, #16]
ldp	d11, d10, [sp], #64
b	LFQH_PageRestore
.cfi_endproc
.p2align	2
LFQH_ProfileEntry:
.cfi_startproc
stp	x20, x19, [sp, #-32]!
stp	x29, x30, [sp, #16]
add	x29, sp, #16
.cfi_def_cfa w29, 16
.cfi_offset w30, -8
.cfi_offset w29, -16
.cfi_offset w19, -24
.cfi_offset w20, -32
mov	x19, x0
LFQH_Lloh1658:
adr x1, LFQH_l_.str.279
LFQH_Lloh1659:
nop
bl	LFQH_Get
cbnz	x0, LFQH_LBB127_2
LFQH_Lloh1660:
adr x1, LFQH_l_.str.280
LFQH_Lloh1661:
nop
mov	x0, x19
bl	LFQH_Get
cbz	x0, LFQH_LBB127_3
LFQH_LBB127_2:
LFQH_Lloh1662:
adr x1, LFQH_l_.str.240
LFQH_Lloh1663:
nop
bl	LFQH_Get
mov	x20, x0
cbnz	x0, LFQH_LBB127_4
LFQH_LBB127_3:
LFQH_Lloh1664:
adr x1, LFQH_l_.str.281
LFQH_Lloh1665:
nop
mov	x0, x19
bl	LFQH_Get
mov	x20, x0
LFQH_LBB127_4:
LFQH_Lloh1666:
adr x1, LFQH_l_.str.156
LFQH_Lloh1667:
nop
mov	x0, x20
bl	LFQH_Kind
cmp	w0, #0
csel	x19, xzr, x20, eq
LFQH_Lloh1668:
adr x1, LFQH_l_.str.274
LFQH_Lloh1669:
nop
mov	x0, x19
bl	LFQH_Equal
tbnz	w0, #0, LFQH_LBB127_8
LFQH_Lloh1670:
adr x1, LFQH_l_.str.275
LFQH_Lloh1671:
nop
mov	x0, x19
bl	LFQH_Equal
tbnz	w0, #0, LFQH_LBB127_8
LFQH_Lloh1672:
adr x1, LFQH_l_.str.276
LFQH_Lloh1673:
nop
mov	x0, x19
bl	LFQH_Equal
tbnz	w0, #0, LFQH_LBB127_8
LFQH_Lloh1674:
adr x1, LFQH_l_.str.277
LFQH_Lloh1675:
nop
mov	x0, x19
bl	LFQH_Equal
tbz	w0, #0, LFQH_LBB127_10
LFQH_LBB127_8:
mov	w0, #1
LFQH_LBB127_9:
ldp	x29, x30, [sp, #16]
ldp	x20, x19, [sp], #32
ret
LFQH_LBB127_10:
LFQH_Lloh1676:
adr x1, LFQH_l_.str.278
LFQH_Lloh1677:
nop
mov	x0, x19
bl	LFQH_Equal
b	LFQH_LBB127_9
.cfi_endproc
.p2align	2
LFQH_TabBusyKey:
.cfi_startproc
ret
.cfi_endproc
.p2align	2
LFQH_TabOriginalKey:
.cfi_startproc
ret
.cfi_endproc
.p2align	2
LFQH_ToggleShortKey:
.cfi_startproc
ret
.cfi_endproc
.p2align	2
LFQH_ToggleMallKey:
.cfi_startproc
ret
.cfi_endproc
.p2align	2
LFQH_FindTable:
.cfi_startproc
stp	x24, x23, [sp, #-64]!
stp	x22, x21, [sp, #16]
stp	x20, x19, [sp, #32]
stp	x29, x30, [sp, #48]
add	x29, sp, #48
.cfi_def_cfa w29, 16
.cfi_offset w30, -8
.cfi_offset w29, -16
.cfi_offset w19, -24
.cfi_offset w20, -32
.cfi_offset w21, -40
.cfi_offset w22, -48
.cfi_offset w23, -56
.cfi_offset w24, -64
mov	x21, x0
cbz	x0, LFQH_LBB132_8
mov	x20, x1
LFQH_Lloh1678:
adr x0, LFQH_l_.str.159
LFQH_Lloh1679:
nop
bl Lpatch + (0xa5a4 - PATCH_BASE)
mov	x19, x0
LFQH_Lloh1680:
adr x0, LFQH_l_.str.289
LFQH_Lloh1681:
nop
bl Lpatch + (0xa5b0 - PATCH_BASE)
mov	x2, x0
mov	x0, x21
mov	x1, x19
bl Lpatch + (0xa5d4 - PATCH_BASE)
cbnz	w0, LFQH_LBB132_8
cbz	w20, LFQH_LBB132_7
LFQH_Lloh1682:
adr x1, LFQH_l_.str.195
LFQH_Lloh1683:
nop
mov	x0, x21
bl	LFQH_Get
mov	x19, x0
LFQH_Lloh1684:
adr x0, LFQH_l_.str.36
LFQH_Lloh1685:
nop
bl Lpatch + (0xa5a4 - PATCH_BASE)
mov	x1, x0
mov	x0, x19
bl Lpatch + (0xa5d4 - PATCH_BASE)
cmp	x0, #64
mov	w8, #64
csel	x24, x0, x8, lo
cbz	x0, LFQH_LBB132_7
mov	x22, #0
sub	w20, w20, #1
LFQH_Lloh1686:
adr x23, LFQH_l_.str.229
LFQH_Lloh1687:
nop
LFQH_LBB132_5:
mov	x0, x23
bl Lpatch + (0xa5a4 - PATCH_BASE)
mov	x1, x0
mov	x0, x19
mov	x2, x22
bl Lpatch + (0xa5d4 - PATCH_BASE)
mov	x1, x20
bl	LFQH_FindTable
cbnz	x0, LFQH_LBB132_9
add	x22, x22, #1
cmp	x24, x22
b.ne	LFQH_LBB132_5
LFQH_LBB132_7:
mov	x21, #0
LFQH_LBB132_8:
mov	x0, x21
ldp	x29, x30, [sp, #48]
ldp	x20, x19, [sp, #32]
ldp	x22, x21, [sp, #16]
ldp	x24, x23, [sp], #64
ret
LFQH_LBB132_9:
mov	x21, x0
b	LFQH_LBB132_8
.cfi_endproc
.p2align	2
LFQH_ToggleRow:
.cfi_startproc
stp	d11, d10, [sp, #-112]!
stp	d9, d8, [sp, #16]
stp	x26, x25, [sp, #32]
stp	x24, x23, [sp, #48]
stp	x22, x21, [sp, #64]
stp	x20, x19, [sp, #80]
stp	x29, x30, [sp, #96]
add	x29, sp, #96
.cfi_def_cfa w29, 16
.cfi_offset w30, -8
.cfi_offset w29, -16
.cfi_offset w19, -24
.cfi_offset w20, -32
.cfi_offset w21, -40
.cfi_offset w22, -48
.cfi_offset w23, -56
.cfi_offset w24, -64
.cfi_offset w25, -72
.cfi_offset w26, -80
.cfi_offset b8, -88
.cfi_offset b9, -96
.cfi_offset b10, -104
.cfi_offset b11, -112
mov	x20, x4
mov	x21, x3
mov	x22, x2
mov	x24, x1
mov.16b	v8, v0
mov	x19, x0
LFQH_Lloh1688:
adr x0, LFQH_l_.str.24
LFQH_Lloh1689:
nop
bl Lpatch + (0xa5a4 - PATCH_BASE)
mov	x1, x0
mov	x0, x19
bl Lpatch + (0xa5d4 - PATCH_BASE)
fcmp	d2, #0.0
mov	x8, #4644337115725824000
fmov	d0, x8
fcsel	d10, d2, d0, gt
LFQH_Lloh1690:
adr x0, LFQH_l_.str.239
LFQH_Lloh1691:
nop
bl Lpatch + (0xa5b0 - PATCH_BASE)
mov	x23, x0
LFQH_Lloh1692:
adr x0, LFQH_l_.str.160
LFQH_Lloh1693:
nop
bl Lpatch + (0xa5a4 - PATCH_BASE)
mov	x1, x0
mov	x0, x23
bl Lpatch + (0xa5d4 - PATCH_BASE)
mov	x23, x0
LFQH_Lloh1694:
adr x0, LFQH_l_.str.285
LFQH_Lloh1695:
nop
bl Lpatch + (0xa5a4 - PATCH_BASE)
mov	x1, x0
mov	x0, x23
bl Lpatch + (0xa5d4 - PATCH_BASE)
mov	x23, x0
cbz	x0, LFQH_LBB133_3
mov	x8, #-4586916220476850176
fmov	d0, x8
fadd	d9, d10, d0
LFQH_Lloh1696:
adr x0, LFQH_l_.str.173
LFQH_Lloh1697:
nop
bl Lpatch + (0xa5a4 - PATCH_BASE)
mov	x1, x0
fmov	d0, #16.00000000
fmov	d3, #30.00000000
mov	x0, x23
mov.16b	v1, v8
mov.16b	v2, v9
bl Lpatch + (0xa5d4 - PATCH_BASE)
LFQH_Lloh1698:
adr x0, LFQH_l_.str.306
LFQH_Lloh1699:
nop
bl Lpatch + (0xa5a4 - PATCH_BASE)
mov	x25, x0
LFQH_Lloh1700:
adr x0, LFQH_l_.str.156
LFQH_Lloh1701:
nop
bl Lpatch + (0xa5b0 - PATCH_BASE)
mov	x26, x0
LFQH_Lloh1702:
adr x0, LFQH_l_.str.157
LFQH_Lloh1703:
nop
bl Lpatch + (0xa5a4 - PATCH_BASE)
mov	x1, x0
mov	x0, x26
mov	x2, x24
bl Lpatch + (0xa5d4 - PATCH_BASE)
mov	x2, x0
mov	x0, x23
mov	x1, x25
bl Lpatch + (0xa5d4 - PATCH_BASE)
LFQH_Lloh1704:
adr x0, LFQH_l_.str.307
LFQH_Lloh1705:
nop
bl Lpatch + (0xa5a4 - PATCH_BASE)
mov	x24, x0
LFQH_Lloh1706:
adr x0, LFQH_l_.str.308
LFQH_Lloh1707:
nop
bl Lpatch + (0xa5b0 - PATCH_BASE)
mov	x25, x0
LFQH_Lloh1708:
adr x0, LFQH_l_.str.309
LFQH_Lloh1709:
nop
bl Lpatch + (0xa5a4 - PATCH_BASE)
mov	x1, x0
fmov	d0, #15.00000000
mov	x0, x25
bl Lpatch + (0xa5d4 - PATCH_BASE)
mov	x2, x0
mov	x0, x23
mov	x1, x24
bl Lpatch + (0xa5d4 - PATCH_BASE)
LFQH_Lloh1710:
adr x0, LFQH_l_.str.47
LFQH_Lloh1711:
nop
bl Lpatch + (0xa5a4 - PATCH_BASE)
mov	x24, x0
LFQH_Lloh1712:
adr x0, LFQH_l_.str.49
LFQH_Lloh1713:
nop
bl Lpatch + (0xa5b0 - PATCH_BASE)
mov	x25, x0
LFQH_Lloh1714:
adr x0, LFQH_l_.str.50
LFQH_Lloh1715:
nop
bl Lpatch + (0xa5a4 - PATCH_BASE)
mov	x1, x0
mov	x0, x25
bl Lpatch + (0xa5d4 - PATCH_BASE)
mov	x2, x0
mov	x0, x23
mov	x1, x24
bl Lpatch + (0xa5d4 - PATCH_BASE)
LFQH_Lloh1716:
adr x0, LFQH_l_.str.166
LFQH_Lloh1717:
nop
bl Lpatch + (0xa5a4 - PATCH_BASE)
mov	x1, x0
mov	x0, x23
mov	w2, #2
bl Lpatch + (0xa5d4 - PATCH_BASE)
LFQH_Lloh1718:
adr x0, LFQH_l_.str.310
LFQH_Lloh1719:
nop
bl Lpatch + (0xa5a4 - PATCH_BASE)
mov	x1, x0
mov	x0, x19
mov	x2, x23
bl Lpatch + (0xa5d4 - PATCH_BASE)
LFQH_Lloh1720:
adr x0, LFQH_l_.str.58
LFQH_Lloh1721:
nop
bl Lpatch + (0xa5a4 - PATCH_BASE)
mov	x1, x0
mov	x0, x23
bl Lpatch + (0xa5d4 - PATCH_BASE)
LFQH_Lloh1722:
adr x0, LFQH_l_.str.311
LFQH_Lloh1723:
nop
bl Lpatch + (0xa5b0 - PATCH_BASE)
mov	x23, x0
LFQH_Lloh1724:
adr x0, LFQH_l_.str.160
LFQH_Lloh1725:
nop
bl Lpatch + (0xa5a4 - PATCH_BASE)
mov	x1, x0
mov	x0, x23
bl Lpatch + (0xa5d4 - PATCH_BASE)
mov	x23, x0
LFQH_Lloh1726:
adr x0, LFQH_l_.str.285
LFQH_Lloh1727:
nop
bl Lpatch + (0xa5a4 - PATCH_BASE)
mov	x1, x0
mov	x0, x23
bl Lpatch + (0xa5d4 - PATCH_BASE)
mov	x23, x0
cbz	x0, LFQH_LBB133_3
mov	x8, #-4588042120383692800
fmov	d0, x8
fadd	d9, d10, d0
fmov	d0, #2.00000000
fadd	d8, d8, d0
LFQH_Lloh1728:
adr x0, LFQH_l_.str.173
LFQH_Lloh1729:
nop
bl Lpatch + (0xa5a4 - PATCH_BASE)
mov	x1, x0
mov	x8, #4634204016564240384
fmov	d2, x8
fmov	d3, #31.00000000
mov	x0, x23
mov.16b	v0, v9
mov.16b	v1, v8
bl Lpatch + (0xa5d4 - PATCH_BASE)
LFQH_Lloh1730:
adr x0, LFQH_l_.str.312
LFQH_Lloh1731:
nop
bl Lpatch + (0xa5a4 - PATCH_BASE)
mov	x1, x0
mov	x0, x23
mov	x2, x22
bl Lpatch + (0xa5d4 - PATCH_BASE)
LFQH_Lloh1732:
adr x0, LFQH_l_.str.166
LFQH_Lloh1733:
nop
bl Lpatch + (0xa5a4 - PATCH_BASE)
mov	x1, x0
mov	x0, x23
mov	w2, #17
bl Lpatch + (0xa5d4 - PATCH_BASE)
LFQH_Lloh1734:
adr x0, LFQH_l_.str.282
LFQH_Lloh1735:
nop
bl Lpatch + (0xa5a4 - PATCH_BASE)
mov	x1, x0
mov	x0, x23
mov	x2, x21
mov	w3, #0
bl Lpatch + (0xa5d4 - PATCH_BASE)
LFQH_Lloh1736:
adr x0, LFQH_l_.str.222
LFQH_Lloh1737:
nop
bl Lpatch + (0xa5a4 - PATCH_BASE)
mov	x21, x0
LFQH_Lloh1738:
adr x0, LFQH_l_.str.292
LFQH_Lloh1739:
nop
bl Lpatch + (0xa5a4 - PATCH_BASE)
mov	x3, x0
mov	x0, x23
mov	x1, x21
mov	x2, x20
mov	w4, #4096
bl Lpatch + (0xa5d4 - PATCH_BASE)
LFQH_Lloh1740:
adr x0, LFQH_l_.str.310
LFQH_Lloh1741:
nop
bl Lpatch + (0xa5a4 - PATCH_BASE)
mov	x1, x0
mov	x0, x19
mov	x2, x23
bl Lpatch + (0xa5d4 - PATCH_BASE)
LFQH_LBB133_3:
mov	x0, x23
ldp	x29, x30, [sp, #96]
ldp	x20, x19, [sp, #80]
ldp	x22, x21, [sp, #64]
ldp	x24, x23, [sp, #48]
ldp	x26, x25, [sp, #32]
ldp	d9, d8, [sp, #16]
ldp	d11, d10, [sp], #112
ret
.cfi_endproc
.p2align	2
LFQH_ToggleObserverKey:
.cfi_startproc
ret
.cfi_endproc
.p2align	2
LFQH_OptionsMarkKey:
.cfi_startproc
ret
.cfi_endproc
.p2align	2
LFQH_ToggleChanged:
.cfi_startproc
stp	x26, x25, [sp, #-80]!
stp	x24, x23, [sp, #16]
stp	x22, x21, [sp, #32]
stp	x20, x19, [sp, #48]
stp	x29, x30, [sp, #64]
add	x29, sp, #64
.cfi_def_cfa w29, 16
.cfi_offset w30, -8
.cfi_offset w29, -16
.cfi_offset w19, -24
.cfi_offset w20, -32
.cfi_offset w21, -40
.cfi_offset w22, -48
.cfi_offset w23, -56
.cfi_offset w24, -64
.cfi_offset w25, -72
.cfi_offset w26, -80
mov	x19, x2
LFQH_Lloh1742:
adr x0, LFQH_l_.str.293
LFQH_Lloh1743:
nop
bl Lpatch + (0xa5a4 - PATCH_BASE)
mov	x1, x0
mov	x0, x19
bl Lpatch + (0xa5d4 - PATCH_BASE)
mov	x20, x0
LFQH_Lloh1744:
adr x1, LFQH_l_.str.294
LFQH_Lloh1745:
nop
mov	x0, x19
bl	LFQH_BoolProp
mov	x19, x0
LFQH_Lloh1746:
adr x8, LFQH_l_.str.257
LFQH_Lloh1747:
nop
LFQH_Lloh1748:
adr x9, LFQH_l_.str.256
LFQH_Lloh1749:
nop
cmp	x20, #1
csel	x21, x9, x8, eq
LFQH_Lloh1750:
adr x0, LFQH_l_.str.242
LFQH_Lloh1751:
nop
bl Lpatch + (0xa5b0 - PATCH_BASE)
mov	x22, x0
LFQH_Lloh1752:
adr x0, LFQH_l_.str.243
LFQH_Lloh1753:
nop
bl Lpatch + (0xa5a4 - PATCH_BASE)
mov	x1, x0
mov	x0, x22
bl Lpatch + (0xa5d4 - PATCH_BASE)
mov	x22, x0
LFQH_Lloh1754:
adr x0, LFQH_l_.str.300
LFQH_Lloh1755:
nop
bl Lpatch + (0xa5a4 - PATCH_BASE)
mov	x23, x0
LFQH_Lloh1756:
adr x0, LFQH_l_.str.156
LFQH_Lloh1757:
nop
bl Lpatch + (0xa5b0 - PATCH_BASE)
mov	x24, x0
LFQH_Lloh1758:
adr x0, LFQH_l_.str.157
LFQH_Lloh1759:
nop
bl Lpatch + (0xa5a4 - PATCH_BASE)
mov	x1, x0
mov	x0, x24
mov	x2, x21
bl Lpatch + (0xa5d4 - PATCH_BASE)
mov	x3, x0
mov	x0, x22
mov	x1, x23
mov	x2, x19
bl Lpatch + (0xa5d4 - PATCH_BASE)
LFQH_Lloh1760:
adr x0, LFQH_l_.str.301
LFQH_Lloh1761:
nop
bl Lpatch + (0xa5b0 - PATCH_BASE)
cbz	x0, LFQH_LBB136_6
mov	x21, x0
LFQH_Lloh1762:
adr x0, LFQH_l_.str.302
LFQH_Lloh1763:
nop
bl Lpatch + (0xa5a4 - PATCH_BASE)
mov	x1, x0
mov	x0, x21
bl Lpatch + (0xa5d4 - PATCH_BASE)
mov	x21, x0
LFQH_Lloh1764:
adr x1, LFQH_l_.str.303
LFQH_Lloh1765:
nop
bl	LFQH_Get
cbz	x0, LFQH_LBB136_3
mov	w1, #12
bl	LFQH_WalkTabBars
LFQH_LBB136_3:
LFQH_Lloh1766:
adr x1, LFQH_l_.str.304
LFQH_Lloh1767:
nop
mov	x0, x21
bl	LFQH_Get
mov	x21, x0
LFQH_Lloh1768:
adr x0, LFQH_l_.str.36
LFQH_Lloh1769:
nop
bl Lpatch + (0xa5a4 - PATCH_BASE)
mov	x1, x0
mov	x0, x21
bl Lpatch + (0xa5d4 - PATCH_BASE)
cmp	x0, #8
mov	w8, #8
csel	x24, x0, x8, lo
cbz	x0, LFQH_LBB136_6
mov	x22, #0
LFQH_Lloh1770:
adr x23, LFQH_l_.str.229
LFQH_Lloh1771:
nop
LFQH_LBB136_5:
mov	x0, x23
bl Lpatch + (0xa5a4 - PATCH_BASE)
mov	x1, x0
mov	x0, x21
mov	x2, x22
bl Lpatch + (0xa5d4 - PATCH_BASE)
mov	w1, #12
bl	LFQH_WalkTabBars
add	x22, x22, #1
cmp	x24, x22
b.ne	LFQH_LBB136_5
LFQH_LBB136_6:
LFQH_Lloh1772:
adr x0, LFQH_l_.str.73
LFQH_Lloh1773:
nop
bl Lpatch + (0xa5b0 - PATCH_BASE)
mov	x21, x0
LFQH_Lloh1774:
adr x0, LFQH_l_.str.74
LFQH_Lloh1775:
nop
bl Lpatch + (0xa5a4 - PATCH_BASE)
mov	x1, x0
mov	x0, x21
bl Lpatch + (0xa5d4 - PATCH_BASE)
mov	x21, x0
LFQH_Lloh1776:
adr x23, LFQH_l_.str.156
LFQH_Lloh1777:
nop
mov	x0, x23
bl Lpatch + (0xa5b0 - PATCH_BASE)
mov	x24, x0
LFQH_Lloh1778:
adr x25, LFQH_l_.str.157
LFQH_Lloh1779:
nop
mov	x0, x25
bl Lpatch + (0xa5a4 - PATCH_BASE)
mov	x1, x0
LFQH_Lloh1780:
adr x22, LFQH_l_.str.295
LFQH_Lloh1781:
nop
mov	x0, x24
mov	x2, x22
bl Lpatch + (0xa5d4 - PATCH_BASE)
mov	x2, x0
LFQH_Lloh1782:
adr x1, LFQH_l_.str.75
LFQH_Lloh1783:
nop
mov	x0, x21
bl	LFQH_Put
LFQH_Lloh1784:
adr x8, LFQH_l_.str.298
LFQH_Lloh1785:
nop
LFQH_Lloh1786:
adr x9, LFQH_l_.str.297
LFQH_Lloh1787:
nop
cmp	x20, #1
csel	x20, x9, x8, eq
mov	x0, x23
bl Lpatch + (0xa5b0 - PATCH_BASE)
mov	x23, x0
mov	x0, x25
bl Lpatch + (0xa5a4 - PATCH_BASE)
mov	x1, x0
mov	x0, x23
mov	x2, x20
bl Lpatch + (0xa5d4 - PATCH_BASE)
mov	x2, x0
LFQH_Lloh1788:
adr x1, LFQH_l_.str.296
LFQH_Lloh1789:
nop
mov	x0, x21
bl	LFQH_Put
LFQH_Lloh1790:
adr x0, LFQH_l_.str.182
LFQH_Lloh1791:
nop
bl Lpatch + (0xa5b0 - PATCH_BASE)
mov	x20, x0
LFQH_Lloh1792:
adr x0, LFQH_l_.str.183
LFQH_Lloh1793:
nop
bl Lpatch + (0xa5a4 - PATCH_BASE)
mov	x1, x0
mov	x0, x20
mov	x2, x19
bl Lpatch + (0xa5d4 - PATCH_BASE)
mov	x2, x0
LFQH_Lloh1794:
adr x1, LFQH_l_.str.299
LFQH_Lloh1795:
nop
mov	x0, x21
bl	LFQH_Put
mov	x0, x22
mov	x1, x21
ldp	x29, x30, [sp, #64]
ldp	x20, x19, [sp, #48]
ldp	x22, x21, [sp, #32]
ldp	x24, x23, [sp, #16]
ldp	x26, x25, [sp], #80
b Lrecord_named
.cfi_endproc
.p2align	2
LFQH_WalkTabBars:
.cfi_startproc
stp	x24, x23, [sp, #-64]!
stp	x22, x21, [sp, #16]
stp	x20, x19, [sp, #32]
stp	x29, x30, [sp, #48]
add	x29, sp, #48
.cfi_def_cfa w29, 16
.cfi_offset w30, -8
.cfi_offset w29, -16
.cfi_offset w19, -24
.cfi_offset w20, -32
.cfi_offset w21, -40
.cfi_offset w22, -48
.cfi_offset w23, -56
.cfi_offset w24, -64
cbz	x0, LFQH_LBB137_12
mov	x20, x1
tbnz	w1, #31, LFQH_LBB137_12
mov	x19, x0
LFQH_Lloh1796:
adr x1, LFQH_l_.str.125
LFQH_Lloh1797:
nop
bl	LFQH_Kind
cbz	w0, LFQH_LBB137_9
LFQH_Lloh1798:
adr x1, LFQH_TabBusyKey
LFQH_Lloh1799:
nop
mov	x0, x19
bl Lpatch + (0xa628 - PATCH_BASE)
cbnz	x0, LFQH_LBB137_12
LFQH_Lloh1800:
adr x1, LFQH_TabOriginalKey
LFQH_Lloh1801:
nop
mov	x0, x19
bl Lpatch + (0xa628 - PATCH_BASE)
mov	x20, x0
cbnz	x0, LFQH_LBB137_7
LFQH_Lloh1802:
adr x1, LFQH_l_.str.305
LFQH_Lloh1803:
nop
mov	x0, x19
bl	LFQH_Get
mov	x20, x0
cbz	x0, LFQH_LBB137_7
LFQH_Lloh1804:
adr x1, LFQH_TabOriginalKey
LFQH_Lloh1805:
nop
mov	x0, x19
mov	x2, x20
mov	w3, #1
bl Lpatch + (0xa634 - PATCH_BASE)
LFQH_LBB137_7:
mov	x0, x20
bl	LFQH_FQHPageTabItems
mov	x20, x0
LFQH_Lloh1806:
adr x1, LFQH_l_.str.305
LFQH_Lloh1807:
nop
mov	x0, x19
bl	LFQH_Get
cmp	x20, x0
b.eq	LFQH_LBB137_12
LFQH_Lloh1808:
adr x21, LFQH_TabBusyKey
LFQH_Lloh1809:
nop
mov	x0, x19
mov	x1, x21
mov	x2, x19
mov	x3, #0
bl Lpatch + (0xa634 - PATCH_BASE)
LFQH_Lloh1810:
adr x0, LFQH_l_.str.126
LFQH_Lloh1811:
nop
bl Lpatch + (0xa5a4 - PATCH_BASE)
mov	x1, x0
mov	x0, x19
mov	x2, x20
bl Lpatch + (0xa5d4 - PATCH_BASE)
mov	x0, x19
mov	x1, x21
mov	x2, #0
mov	x3, #0
ldp	x29, x30, [sp, #48]
ldp	x20, x19, [sp, #32]
ldp	x22, x21, [sp, #16]
ldp	x24, x23, [sp], #64
b Lpatch + (0xa634 - PATCH_BASE)
LFQH_LBB137_9:
LFQH_Lloh1812:
adr x1, LFQH_l_.str.195
LFQH_Lloh1813:
nop
mov	x0, x19
bl	LFQH_Get
mov	x19, x0
LFQH_Lloh1814:
adr x0, LFQH_l_.str.36
LFQH_Lloh1815:
nop
bl Lpatch + (0xa5a4 - PATCH_BASE)
mov	x1, x0
mov	x0, x19
bl Lpatch + (0xa5d4 - PATCH_BASE)
cmp	x0, #64
mov	w8, #64
csel	x23, x0, x8, lo
cbz	x0, LFQH_LBB137_12
mov	x21, #0
sub	w20, w20, #1
LFQH_Lloh1816:
adr x22, LFQH_l_.str.229
LFQH_Lloh1817:
nop
LFQH_LBB137_11:
mov	x0, x22
bl Lpatch + (0xa5a4 - PATCH_BASE)
mov	x1, x0
mov	x0, x19
mov	x2, x21
bl Lpatch + (0xa5d4 - PATCH_BASE)
mov	x1, x20
bl	LFQH_WalkTabBars
add	x21, x21, #1
cmp	x23, x21
b.ne	LFQH_LBB137_11
LFQH_LBB137_12:
ldp	x29, x30, [sp, #48]
ldp	x20, x19, [sp, #32]
ldp	x22, x21, [sp, #16]
ldp	x24, x23, [sp], #64
ret
.cfi_endproc
.p2align	2
LFQH_SpeechGlass:
.cfi_startproc
stp	x24, x23, [sp, #-64]!
stp	x22, x21, [sp, #16]
stp	x20, x19, [sp, #32]
stp	x29, x30, [sp, #48]
add	x29, sp, #48
.cfi_def_cfa w29, 16
.cfi_offset w30, -8
.cfi_offset w29, -16
.cfi_offset w19, -24
.cfi_offset w20, -32
.cfi_offset w21, -40
.cfi_offset w22, -48
.cfi_offset w23, -56
.cfi_offset w24, -64
mov	x20, x0
LFQH_Lloh1818:
adr x1, LFQH_l_.str.313
LFQH_Lloh1819:
nop
bl	LFQH_Get
mov	x19, x0
LFQH_Lloh1820:
adr x1, LFQH_l_.str.203
LFQH_Lloh1821:
nop
bl	LFQH_Kind
cmp	x19, #0
ccmp	w0, #0, #4, ne
b.ne	LFQH_LBB138_2
LFQH_LBB138_1:
ldp	x29, x30, [sp, #48]
ldp	x20, x19, [sp, #32]
ldp	x22, x21, [sp, #16]
ldp	x24, x23, [sp], #64
ret
LFQH_LBB138_2:
mov	w22, #0
LFQH_Lloh1822:
adr x21, LFQH_l_.str.20
LFQH_Lloh1823:
nop
mov	x0, x19
LFQH_LBB138_3:
cmp	x0, x20
b.eq	LFQH_LBB138_6
mov	x1, x21
bl	LFQH_Get
cbz	x0, LFQH_LBB138_1
cmp	w22, #7
add	w22, w22, #1
b.lo	LFQH_LBB138_3
b	LFQH_LBB138_1
LFQH_LBB138_6:
LFQH_Lloh1824:
adr x0, LFQH_l_.str.314
LFQH_Lloh1825:
nop
bl Lpatch + (0xa5a4 - PATCH_BASE)
mov	x1, x0
mov	x0, x19
mov	x2, #0
bl Lpatch + (0xa5d4 - PATCH_BASE)
mov	x20, x0
LFQH_Lloh1826:
adr x1, LFQH_SpeechGlyphKey
LFQH_Lloh1827:
nop
mov	x0, x19
bl Lpatch + (0xa628 - PATCH_BASE)
mov	x21, x0
LFQH_Lloh1828:
adr x0, LFQH_l_.str.49
LFQH_Lloh1829:
nop
bl Lpatch + (0xa5b0 - PATCH_BASE)
mov	x22, x0
LFQH_Lloh1830:
adr x0, LFQH_l_.str.50
LFQH_Lloh1831:
nop
bl Lpatch + (0xa5a4 - PATCH_BASE)
mov	x1, x0
mov	x0, x22
bl Lpatch + (0xa5d4 - PATCH_BASE)
mov	x22, x0
LFQH_Lloh1832:
adr x1, LFQH_l_.str.315
LFQH_Lloh1833:
nop
mov	x0, x19
bl	LFQH_Get
mov	x24, x0
LFQH_Lloh1834:
adr x0, LFQH_l_.str.51
LFQH_Lloh1835:
nop
bl Lpatch + (0xa5a4 - PATCH_BASE)
mov	x1, x0
mov	x0, x24
mov	x2, x22
bl Lpatch + (0xa5d4 - PATCH_BASE)
mov	x23, x0
bl	LFQH_Enabled
cbz	w0, LFQH_LBB138_9
bl	LFQH_FQHGlassAvailable
cbz	w0, LFQH_LBB138_9
LFQH_Lloh1836:
adr x0, LFQH_l_.str.24
LFQH_Lloh1837:
nop
bl Lpatch + (0xa5a4 - PATCH_BASE)
mov	x1, x0
mov	x0, x19
bl Lpatch + (0xa5d4 - PATCH_BASE)
fmov	x8, d2
fmov	x9, d1
fmov	x10, d0
ubfx	x10, x10, #52, #11
ubfx	x9, x9, #52, #11
ubfx	x8, x8, #52, #11
cmp	x8, #2046
mov	w8, #2046
ccmp	x9, x8, #2, ls
ccmp	x10, x8, #2, ls
b.ls	LFQH_LBB138_17
LFQH_LBB138_9:
cbz	x21, LFQH_LBB138_16
cmp	x20, x21
b.ne	LFQH_LBB138_12
LFQH_Lloh1838:
adr x1, LFQH_SpeechImageKey
LFQH_Lloh1839:
nop
mov	x0, x19
bl Lpatch + (0xa628 - PATCH_BASE)
mov	x20, x0
LFQH_Lloh1840:
adr x0, LFQH_l_.str.319
LFQH_Lloh1841:
nop
bl Lpatch + (0xa5a4 - PATCH_BASE)
mov	x1, x0
mov	x0, x19
mov	x2, x20
mov	x3, #0
bl Lpatch + (0xa5d4 - PATCH_BASE)
LFQH_LBB138_12:
LFQH_Lloh1842:
adr x1, LFQH_SpeechTintKey
LFQH_Lloh1843:
nop
mov	x0, x19
bl Lpatch + (0xa628 - PATCH_BASE)
cbz	w23, LFQH_LBB138_15
mov	x20, x0
cbz	x0, LFQH_LBB138_15
LFQH_Lloh1844:
adr x0, LFQH_l_.str.56
LFQH_Lloh1845:
nop
bl Lpatch + (0xa5a4 - PATCH_BASE)
mov	x1, x0
mov	x0, x19
mov	x2, x20
bl Lpatch + (0xa5d4 - PATCH_BASE)
LFQH_LBB138_15:
LFQH_Lloh1846:
adr x1, LFQH_SpeechImageKey
LFQH_Lloh1847:
nop
mov	x0, x19
mov	x2, #0
mov	w3, #1
bl Lpatch + (0xa634 - PATCH_BASE)
LFQH_Lloh1848:
adr x1, LFQH_SpeechGlyphKey
LFQH_Lloh1849:
nop
mov	x0, x19
mov	x2, #0
mov	w3, #1
bl Lpatch + (0xa634 - PATCH_BASE)
LFQH_Lloh1850:
adr x1, LFQH_SpeechTintKey
LFQH_Lloh1851:
nop
mov	x0, x19
mov	x2, #0
mov	w3, #1
bl Lpatch + (0xa634 - PATCH_BASE)
LFQH_LBB138_16:
LFQH_Lloh1852:
adr x1, LFQH_SurfaceKey
LFQH_Lloh1853:
nop
mov	x0, x19
bl Lpatch + (0xa628 - PATCH_BASE)
mov	x1, x0
mov	x0, x19
ldp	x29, x30, [sp, #48]
ldp	x20, x19, [sp, #32]
ldp	x22, x21, [sp, #16]
ldp	x24, x23, [sp], #64
b	LFQH_Restore
LFQH_LBB138_17:
fmov	x8, d3
ubfx	x8, x8, #52, #11
cmp	x8, #2046
b.hi	LFQH_LBB138_9
fcmp	d2, #0.0
b.le	LFQH_LBB138_9
fcmp	d3, #0.0
b.le	LFQH_LBB138_9
cbnz	x21, LFQH_LBB138_22
LFQH_Lloh1854:
adr x0, LFQH_l_.str.316
LFQH_Lloh1855:
nop
bl Lpatch + (0xa5b0 - PATCH_BASE)
LFQH_Lloh1856:
adr x1, LFQH_l_.str.317
LFQH_Lloh1857:
nop
bl	LFQH_Get
mov	x21, x0
LFQH_Lloh1858:
adr x0, LFQH_l_.str.318
LFQH_Lloh1859:
nop
bl Lpatch + (0xa5a4 - PATCH_BASE)
mov	x1, x0
mov	x0, x21
mov	w2, #2
bl Lpatch + (0xa5d4 - PATCH_BASE)
mov	x21, x0
cbz	x0, LFQH_LBB138_1
LFQH_LBB138_22:
mov	x0, x19
bl	LFQH_FQHApply
LFQH_Lloh1860:
adr x1, LFQH_SurfaceKey
LFQH_Lloh1861:
nop
mov	x0, x19
bl Lpatch + (0xa628 - PATCH_BASE)
cbz	x0, LFQH_LBB138_1
cbnz	w23, LFQH_LBB138_25
LFQH_Lloh1862:
adr x1, LFQH_SpeechTintKey
LFQH_Lloh1863:
nop
mov	x0, x19
mov	x2, x24
mov	w3, #1
bl Lpatch + (0xa634 - PATCH_BASE)
LFQH_Lloh1864:
adr x0, LFQH_l_.str.56
LFQH_Lloh1865:
nop
bl Lpatch + (0xa5a4 - PATCH_BASE)
mov	x1, x0
mov	x0, x19
mov	x2, x22
bl Lpatch + (0xa5d4 - PATCH_BASE)
LFQH_LBB138_25:
cmp	x20, x21
b.eq	LFQH_LBB138_1
LFQH_Lloh1866:
adr x1, LFQH_SpeechImageKey
LFQH_Lloh1867:
nop
mov	x0, x19
mov	x2, x20
mov	w3, #1
bl Lpatch + (0xa634 - PATCH_BASE)
LFQH_Lloh1868:
adr x1, LFQH_SpeechGlyphKey
LFQH_Lloh1869:
nop
mov	x0, x19
mov	x2, x21
mov	w3, #1
bl Lpatch + (0xa634 - PATCH_BASE)
LFQH_Lloh1870:
adr x0, LFQH_l_.str.319
LFQH_Lloh1871:
nop
bl Lpatch + (0xa5a4 - PATCH_BASE)
mov	x1, x0
mov	x0, x19
mov	x2, x21
mov	x3, #0
ldp	x29, x30, [sp, #48]
ldp	x20, x19, [sp, #32]
ldp	x22, x21, [sp, #16]
ldp	x24, x23, [sp], #64
b Lpatch + (0xa5d4 - PATCH_BASE)
.cfi_endproc
.p2align	2
LFQH_SpeechGlyphKey:
.cfi_startproc
ret
.cfi_endproc
.p2align	2
LFQH_SpeechImageKey:
.cfi_startproc
ret
.cfi_endproc
.p2align	2
LFQH_SpeechTintKey:
.cfi_startproc
ret
.cfi_endproc
// @COMPONENT_DATA
LFQH_l_.str:
.asciz	"NSBundle"
LFQH_l_.str.1:
.asciz	"mainBundle"
LFQH_l_.str.2:
.asciz	"bundleIdentifier"
LFQH_l_.str.3:
.asciz	"com.dragon.read"
LFQH_l_.str.4:
.asciz	"objectForInfoDictionaryKey:"
LFQH_l_.str.5:
.asciz	"CFBundleVersion"
LFQH_l_.str.6:
.asciz	"7.4.3.33"
LFQH_l_.str.7:
.asciz	"SSBookStoreNewViewController"
LFQH_l_.str.8:
.asciz	"relayout"
LFQH_l_.str.9:
.asciz	"v16@0:8"
LFQH_l_.str.10:
.asciz	"searchBgView"
LFQH_l_.str.11:
.asciz	"@16@0:8"
LFQH_l_.str.12:
.asciz	"UIGlassEffect"
LFQH_l_.str.13:
.asciz	"effectWithStyle:"
LFQH_l_.str.14:
.asciz	"UICornerConfiguration"
LFQH_l_.str.15:
.asciz	"capsuleConfiguration"
LFQH_l_.str.16:
.asciz	"UIVisualEffectView"
LFQH_l_.str.17:
.asciz	"setCornerConfiguration:"
LFQH_l_.str.18:
.asciz	"setInteractive:"
LFQH_l_.str.19:
.asciz	"SSBookShelfProfileDurationTipButton"
LFQH_l_.str.20:
.asciz	"superview"
LFQH_l_.str.21:
.asciz	"SS525BookShelfSubHeaderView"
LFQH_l_.str.22:
.asciz	"coinButton"
LFQH_l_.str.23:
.asciz	"UIView"
LFQH_l_.str.24:
.asciz	"bounds"
LFQH_l_.str.25:
.asciz	"SSBookStoreCategorySignView"
LFQH_l_.str.26:
.asciz	"categoryButton"
LFQH_l_.str.27:
.asciz	"search"
LFQH_l_.str.28:
.asciz	"UIButtonConfiguration"
LFQH_l_.str.29:
.asciz	"glassButtonConfiguration"
LFQH_l_.str.30:
.asciz	"icon"
LFQH_l_.str.31:
.asciz	"integerValue"
LFQH_l_.str.32:
.asciz	"backBtn"
LFQH_l_.str.33:
.asciz	"readerBack"
LFQH_l_.str.34:
.asciz	"insertObjs"
LFQH_l_.str.35:
.asciz	"NSArray"
LFQH_l_.str.36:
.asciz	"count"
LFQH_l_.str.37:
.asciz	"getInsertView"
LFQH_l_.str.38:
.asciz	"searchButton"
LFQH_l_.str.39:
.asciz	"moreButton"
LFQH_l_.str.40:
.asciz	"searchAndMoreView"
LFQH_l_.str.41:
.asciz	"more"
LFQH_l_.str.42:
.asciz	"shelfSearch"
LFQH_l_.str.43:
.asciz	"shelfMore"
LFQH_l_.str.44:
.asciz	"UIControl"
LFQH_l_.str.45:
.asciz	"SSBookshelfEditBottomView"
LFQH_l_.str.46:
.asciz	"SSReaderFloatingCommonButton"
LFQH_l_.str.47:
.asciz	"setTextColor:"
LFQH_l_.str.48:
.asciz	"textColor"
LFQH_l_.str.49:
.asciz	"UIColor"
LFQH_l_.str.50:
.asciz	"labelColor"
LFQH_l_.str.51:
.asciz	"isEqual:"
LFQH_l_.str.52:
.asciz	"secondarySystemBackgroundColor"
LFQH_l_.str.53:
.asciz	"colorWithAlphaComponent:"
LFQH_l_.str.54:
.asciz	"effect"
LFQH_l_.str.55:
.asciz	"copy"
LFQH_l_.str.56:
.asciz	"setTintColor:"
LFQH_l_.str.57:
.asciz	"setEffect:"
LFQH_l_.str.58:
.asciz	"release"
LFQH_l_.str.59:
.asciz	"FQReaderSaaSBottomToolItemView"
LFQH_l_.str.60:
.asciz	"FQReaderSaaSBottomToolView"
LFQH_l_.str.61:
.asciz	"FQReaderSaaSReaderSpeechButton"
LFQH_l_.str.62:
.asciz	"\346\212\223\345\244\247\351\271\205"
LFQH_l_.str.63:
.asciz	"\347\276\212\344\272\206\344\270\252\347\276\212\357\274\232\346\230\237\347\220\203"
LFQH_l_.str.64:
.asciz	"\347\276\212\344\272\206\344\270\252\347\276\212:\346\230\237\347\220\203"
LFQH_l_.str.65:
.asciz	"\347\276\212\344\272\206\344\270\252\347\276\212"
LFQH_l_.str.66:
.asciz	"hasPrefix:"
LFQH_l_.str.67:
.asciz	"miniGameEntranceCellModel"
LFQH_l_.str.68:
.asciz	"setIsInvisible:"
LFQH_l_.str.69:
.asciz	"setIsDisabled:"
LFQH_l_.str.70:
.asciz	"models"
LFQH_l_.str.71:
.asciz	"NSMutableArray"
LFQH_l_.str.72:
.asciz	"removeObjectIdenticalTo:"
LFQH_l_.str.73:
.asciz	"NSMutableDictionary"
LFQH_l_.str.74:
.asciz	"dictionary"
LFQH_l_.str.75:
.asciz	"event"
LFQH_l_.str.76:
.asciz	"pageAdRemoved174"
LFQH_l_.str.77:
.asciz	"ownerClass"
LFQH_l_.str.78:
.asciz	"SSMyUser621BaseViewController"
LFQH_l_.str.79:
.asciz	"source"
LFQH_l_.str.80:
.asciz	"serverGameModel"
LFQH_l_.str.81:
.asciz	"action"
LFQH_l_.str.82:
.asciz	"removeModelBeforeListAdapter"
LFQH_l_.str.83:
.asciz	"pageAdFilter174"
LFQH_l_.str.84:
.asciz	"array"
LFQH_l_.str.85:
.asciz	"title"
LFQH_l_.str.86:
.asciz	"\347\237\255\345\217\245"
LFQH_l_.str.87:
.asciz	"\345\225\206\345\237\216"
LFQH_l_.str.88:
.asciz	"addObject:"
LFQH_l_.str.89:
.asciz	"readerBottom"
LFQH_l_.str.90:
.asciz	"cellModel"
LFQH_l_.str.91:
.asciz	"layoutSubviews"
LFQH_l_.str.92:
.asciz	"fqx175_originalBottom"
LFQH_l_.str.93:
.asciz	"FQReaderSaaSNewProgressView"
LFQH_l_.str.94:
.asciz	"fqx174_originalProgress"
LFQH_l_.str.95:
.asciz	"SSReaderBottomToolDivertView"
LFQH_l_.str.96:
.asciz	"fqx175_originalDivert"
LFQH_l_.str.97:
.asciz	"SSReaderGiftView"
LFQH_l_.str.98:
.asciz	"fqx174_originalGift"
LFQH_l_.str.99:
.asciz	"SSReaderBookEndUserGiftView"
LFQH_l_.str.100:
.asciz	"fqx174_originalBookGift"
LFQH_l_.str.101:
.asciz	"SSReaderChapterEndDiscussionEntranceView"
LFQH_l_.str.102:
.asciz	"fqx174_originalDiscuss"
LFQH_l_.str.103:
.asciz	"SSReaderChapterEndDiscussionEntranceButton"
LFQH_l_.str.104:
.asciz	"fqx174_originalDiscussButton"
LFQH_l_.str.105:
.asciz	"SSBookShelfTabSelectViewTitleCell"
LFQH_l_.str.106:
.asciz	"fqx174_originalShelfCategory"
LFQH_l_.str.107:
.asciz	"reloadData:"
LFQH_l_.str.108:
.asciz	"fqx175_originalShelfTabReload:"
LFQH_l_.str.109:
.asciz	"v24@0:8@16"
LFQH_l_.str.110:
.asciz	"SSBookShelfFilter541Cell"
LFQH_l_.str.111:
.asciz	"fqx175_originalShelfFilterLayout"
LFQH_l_.str.112:
.asciz	"updateAppearance:"
LFQH_l_.str.113:
.asciz	"fqx175_originalShelfFilterAppearance:"
LFQH_l_.str.114:
.asciz	"v20@0:8B16"
LFQH_l_.str.115:
.asciz	"updateCellBgColor:"
LFQH_l_.str.116:
.asciz	"fqx175_originalShelfFilterBackground:"
LFQH_l_.str.117:
.asciz	"SSMyUserBar"
LFQH_l_.str.118:
.asciz	"fqx174_originalProfileBar"
LFQH_l_.str.119:
.asciz	"SSMyUserCollectionViewFunCell"
LFQH_l_.str.120:
.asciz	"fqx174_originalProfileEntry"
LFQH_l_.str.121:
.asciz	"SSMyUser621FunctionEntryItemCell"
LFQH_l_.str.122:
.asciz	"fqx174_originalProfileEntry621"
LFQH_l_.str.123:
.asciz	"setupCellMiniGameEntranceData"
LFQH_l_.str.124:
.asciz	"fqx174_originalMiniGameSetup"
LFQH_l_.str.125:
.asciz	"SSTabBar"
LFQH_l_.str.126:
.asciz	"setItems:"
LFQH_l_.str.127:
.asciz	"fqx174_originalTabItems"
LFQH_l_.str.128:
.asciz	"setItems:animated:"
LFQH_l_.str.129:
.asciz	"fqx174_originalTabItemsAnimated"
LFQH_l_.str.130:
.asciz	"v28@0:8@16B24"
LFQH_l_.str.131:
.asciz	"FanqieAdBlockOptionsController"
LFQH_l_.str.132:
.asciz	"viewDidAppear:"
LFQH_l_.str.133:
.asciz	"fqx174_originalOptionsAppear:"
LFQH_l_.str.134:
.asciz	"fqx171_originalLayout"
LFQH_l_.str.135:
.asciz	"fqx175_originalSpeechLayout"
LFQH_l_.str.136:
.asciz	"readerInsertedViewBackgroundConfigChange:"
LFQH_l_.str.137:
.asciz	"fqx175_originalSpeechTheme:"
LFQH_l_.str.138:
.asciz	"fqx165_originalRelayout"
LFQH_l_.str.139:
.asciz	"fqx165_originalAppear:"
LFQH_l_.str.140:
.asciz	"fqx173_originalLayout"
LFQH_l_.str.141:
.asciz	"resetColorWithRatio:fromTab:toTab:fromTabTemplate:toTabTemplate:"
LFQH_l_.str.142:
.asciz	"fqx173_originalColor:from:to:fromTemplate:toTemplate:"
LFQH_l_.str.143:
.asciz	"v40@0:8d16i24i28i32i36"
LFQH_l_.str.144:
.asciz	"SSBookStoreSearchBarComponent"
LFQH_l_.str.145:
.asciz	"resetTopTabSearchViewWithRatio:fromTab:toTab:fromTabTemplate:toTabTemplate:"
LFQH_l_.str.146:
.asciz	"fqx173_originalSearchColor:from:to:fromTemplate:toTemplate:"
LFQH_l_.str.147:
.asciz	"FQReaderSaaSBaseButton"
LFQH_l_.str.148:
.asciz	"fqx170_originalLayout"
LFQH_l_.str.149:
.asciz	"SSBookShelfSubViewController"
LFQH_l_.str.150:
.asciz	"viewDidLayoutSubviews"
LFQH_l_.str.151:
.asciz	"fqx167_originalShelfLayout"
LFQH_l_.str.152:
.asciz	"FQReaderSaasNavigationView"
LFQH_l_.str.153:
.asciz	"fqx167_originalLayout"
LFQH_l_.str.154:
.asciz	"readerInsertedViewThemeConfigChange:"
LFQH_l_.str.155:
.asciz	"fqx167_originalTheme:"
LFQH_l_.str.156:
.asciz	"NSString"
LFQH_l_.str.157:
.asciz	"stringWithUTF8String:"
LFQH_l_.str.158:
.asciz	"respondsToSelector:"
LFQH_l_.str.159:
.asciz	"isKindOfClass:"
LFQH_l_.str.160:
.asciz	"alloc"
LFQH_l_.str.161:
.asciz	"initWithEffect:"
LFQH_l_.str.162:
.asciz	"setUserInteractionEnabled:"
LFQH_l_.str.163:
.asciz	"setAccessibilityElementsHidden:"
LFQH_l_.str.164:
.asciz	"setIsAccessibilityElement:"
LFQH_l_.str.165:
.asciz	"setOpaque:"
LFQH_l_.str.166:
.asciz	"setAutoresizingMask:"
LFQH_l_.str.167:
.asciz	"backgroundColor"
LFQH_l_.str.168:
.asciz	"clearColor"
LFQH_l_.str.169:
.asciz	"CATransaction"
LFQH_l_.str.170:
.asciz	"begin"
LFQH_l_.str.171:
.asciz	"setDisableActions:"
LFQH_l_.str.172:
.asciz	"frame"
LFQH_l_.str.173:
.asciz	"setFrame:"
LFQH_l_.str.174:
.asciz	"contentView"
LFQH_l_.str.175:
.asciz	"insertSubview:atIndex:"
LFQH_l_.str.176:
.asciz	"commit"
LFQH_l_.str.177:
.asciz	"clipsToBounds"
LFQH_l_.str.178:
.asciz	"isOpaque"
LFQH_l_.str.179:
.asciz	"setClipsToBounds:"
LFQH_l_.str.180:
.asciz	"layer"
LFQH_l_.str.181:
.asciz	"cornerRadius"
LFQH_l_.str.182:
.asciz	"NSNumber"
LFQH_l_.str.183:
.asciz	"numberWithBool:"
LFQH_l_.str.184:
.asciz	"doubleValue"
LFQH_l_.str.185:
.asciz	"numberWithDouble:"
LFQH_l_.str.186:
.asciz	"setCornerRadius:"
LFQH_l_.str.187:
.asciz	"setBackgroundColor:"
LFQH_l_.str.188:
.asciz	"NSProcessInfo"
LFQH_l_.str.189:
.asciz	"processInfo"
LFQH_l_.str.190:
.asciz	"systemUptime"
LFQH_l_.str.191:
.asciz	"role"
LFQH_l_.str.192:
.asciz	"hostFrame"
LFQH_l_.str.193:
.asciz	"hostBounds"
LFQH_l_.str.194:
.asciz	"glassRect"
LFQH_l_.str.195:
.asciz	"subviews"
LFQH_l_.str.196:
.asciz	"childCount"
LFQH_l_.str.197:
.asciz	"childrenTruncated"
LFQH_l_.str.198:
.asciz	"childFrames"
LFQH_l_.str.199:
.asciz	"headerLayout173"
LFQH_l_.str.200:
.asciz	"CGRectValue"
LFQH_l_.str.201:
.asciz	"NSValue"
LFQH_l_.str.202:
.asciz	"valueWithCGRect:"
LFQH_l_.str.203:
.asciz	"UIButton"
LFQH_l_.str.204:
.asciz	"imageView"
LFQH_l_.str.205:
.asciz	"isHidden"
LFQH_l_.str.206:
.asciz	"new"
LFQH_l_.str.207:
.asciz	"setConfiguration:"
LFQH_l_.str.208:
.asciz	"setEnabled:"
LFQH_l_.str.209:
.asciz	"isEnabled"
LFQH_l_.str.210:
.asciz	"setSelected:"
LFQH_l_.str.211:
.asciz	"isSelected"
LFQH_l_.str.212:
.asciz	"setHighlighted:"
LFQH_l_.str.213:
.asciz	"isHighlighted"
LFQH_l_.str.214:
.asciz	"removeFromSuperview"
LFQH_l_.str.215:
.asciz	"boolValue"
LFQH_l_.str.216:
.asciz	"convertRect:toView:"
LFQH_l_.str.217:
.asciz	"btd_hitTestEdgeInsets"
LFQH_l_.str.218:
.asciz	"setBtd_hitTestEdgeInsets:"
LFQH_l_.str.219:
.asciz	"FQXGlassBackground167"
LFQH_l_.str.220:
.asciz	"fqx167_down:"
LFQH_l_.str.221:
.asciz	"fqx167_up:"
LFQH_l_.str.222:
.asciz	"addTarget:action:forControlEvents:"
LFQH_l_.str.223:
.asciz	"removeTarget:action:forControlEvents:"
LFQH_l_.str.224:
.asciz	"window"
LFQH_l_.str.225:
.asciz	"arrayWithObjects:count:"
LFQH_l_.str.226:
.asciz	"imageRect"
LFQH_l_.str.227:
.asciz	"windowRect"
LFQH_l_.str.228:
.asciz	"controlLayout167"
LFQH_l_.str.229:
.asciz	"objectAtIndex:"
LFQH_l_.str.230:
.asciz	"FQReaderNavigationBarMoreBtnInsertObject"
LFQH_l_.str.231:
.asciz	"readerMore"
LFQH_l_.str.232:
.asciz	"FQReaderNavigationBarSearchBtnInsertObject"
LFQH_l_.str.233:
.asciz	"readerSearch"
LFQH_l_.str.234:
.asciz	"SSReaderNavigationBarDownloadBtnInsertObject"
LFQH_l_.str.235:
.asciz	"readerDownload"
LFQH_l_.str.236:
.asciz	"SSReaderNavigationBarCommunitySwitchBtnInsertObject"
LFQH_l_.str.237:
.asciz	"readerCommunity"
LFQH_l_.str.238:
.asciz	"numberWithLongLong:"
LFQH_l_.str.239:
.asciz	"UILabel"
LFQH_l_.str.240:
.asciz	"text"
LFQH_l_.str.241:
.asciz	"\345\220\254"
LFQH_l_.str.242:
.asciz	"NSUserDefaults"
LFQH_l_.str.243:
.asciz	"standardUserDefaults"
LFQH_l_.str.244:
.asciz	"integerForKey:"
LFQH_l_.str.245:
.asciz	"FanqieAdBlock.GlassDisabled.1"
LFQH_l_.str.246:
.asciz	"chapterView"
LFQH_l_.str.247:
.asciz	"darkModeView"
LFQH_l_.str.248:
.asciz	"setttingView"
LFQH_l_.str.249:
.asciz	"info"
LFQH_l_.str.250:
.asciz	"name"
LFQH_l_.str.251:
.asciz	"gameName"
LFQH_l_.str.252:
.asciz	"gameContent"
LFQH_l_.str.253:
.asciz	"mpName"
LFQH_l_.str.254:
.asciz	"setObject:forKey:"
LFQH_l_.str.255:
.asciz	"objectForKey:"
LFQH_l_.str.256:
.asciz	"FanqieX.BottomShortSentences.1"
LFQH_l_.str.257:
.asciz	"FanqieX.BottomMall.1"
LFQH_l_.str.258:
.asciz	"cellSpacing"
LFQH_l_.str.259:
.asciz	"shelfTab"
LFQH_l_.str.260:
.asciz	"systemOrangeColor"
LFQH_l_.str.261:
.asciz	"itemViews"
LFQH_l_.str.262:
.asciz	"slider"
LFQH_l_.str.263:
.asciz	"BDReaderNewSlider"
LFQH_l_.str.264:
.asciz	"titleLabel"
LFQH_l_.str.265:
.asciz	"\346\224\271\347\274\226\345\211\247\345\234\272"
LFQH_l_.str.266:
.asciz	"giftButton"
LFQH_l_.str.267:
.asciz	"readerGift"
LFQH_l_.str.268:
.asciz	"readerDiscuss"
LFQH_l_.str.269:
.asciz	"SSBookShelfFilterMixRowCollectionView"
LFQH_l_.str.270:
.asciz	"SSBookShelfFilterHeaderView"
LFQH_l_.str.271:
.asciz	"shelfFilter"
LFQH_l_.str.272:
.asciz	"isSelect"
LFQH_l_.str.273:
.asciz	"profileEntry"
LFQH_l_.str.274:
.asciz	"\346\210\221\347\232\204\350\256\242\345\215\225"
LFQH_l_.str.275:
.asciz	"\346\265\217\350\247\210\345\216\206\345\217\262"
LFQH_l_.str.276:
.asciz	"\346\210\221\347\232\204\346\266\210\346\201\257"
LFQH_l_.str.277:
.asciz	"\345\210\233\344\275\234\344\270\255\345\277\203"
LFQH_l_.str.278:
.asciz	"\346\210\221\347\232\204\351\242\204\347\272\246"
LFQH_l_.str.279:
.asciz	"functionType"
LFQH_l_.str.280:
.asciz	"label"
LFQH_l_.str.281:
.asciz	"titleString"
LFQH_l_.str.282:
.asciz	"setOn:animated:"
LFQH_l_.str.283:
.asciz	"view"
LFQH_l_.str.284:
.asciz	"tableHeaderView"
LFQH_l_.str.285:
.asciz	"init"
LFQH_l_.str.286:
.asciz	"\345\272\225\346\240\217\346\230\276\347\244\272\357\274\232\347\237\255\345\217\245"
LFQH_l_.str.287:
.asciz	"\345\272\225\346\240\217\346\230\276\347\244\272\357\274\232\345\225\206\345\237\216"
LFQH_l_.str.288:
.asciz	"setTableHeaderView:"
LFQH_l_.str.289:
.asciz	"UITableView"
LFQH_l_.str.290:
.asciz	"FanqieXBottomToggles174"
LFQH_l_.str.291:
.asciz	"NSObject"
LFQH_l_.str.292:
.asciz	"fqx174_toggle:"
LFQH_l_.str.293:
.asciz	"tag"
LFQH_l_.str.294:
.asciz	"isOn"
LFQH_l_.str.295:
.asciz	"bottomEntryToggle174"
LFQH_l_.str.296:
.asciz	"entry"
LFQH_l_.str.297:
.asciz	"shortSentences"
LFQH_l_.str.298:
.asciz	"mall"
LFQH_l_.str.299:
.asciz	"enabled"
LFQH_l_.str.300:
.asciz	"setBool:forKey:"
LFQH_l_.str.301:
.asciz	"UIApplication"
LFQH_l_.str.302:
.asciz	"sharedApplication"
LFQH_l_.str.303:
.asciz	"keyWindow"
LFQH_l_.str.304:
.asciz	"windows"
LFQH_l_.str.305:
.asciz	"items"
LFQH_l_.str.306:
.asciz	"setText:"
LFQH_l_.str.307:
.asciz	"setFont:"
LFQH_l_.str.308:
.asciz	"UIFont"
LFQH_l_.str.309:
.asciz	"systemFontOfSize:"
LFQH_l_.str.310:
.asciz	"addSubview:"
LFQH_l_.str.311:
.asciz	"UISwitch"
LFQH_l_.str.312:
.asciz	"setTag:"
LFQH_l_.str.313:
.asciz	"speechBtn"
LFQH_l_.str.314:
.asciz	"imageForState:"
LFQH_l_.str.315:
.asciz	"tintColor"
LFQH_l_.str.316:
.asciz	"BDNovelNewAssetsGenerated"
LFQH_l_.str.317:
.asciz	"bdn_novelReaderListenButton"
LFQH_l_.str.318:
.asciz	"imageWithRenderingMode:"
LFQH_l_.str.319:
.asciz	"setImage:forState:"
LFQH_l_.str.320:
.asciz	"bookStoreVCContext"
