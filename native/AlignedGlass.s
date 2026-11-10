// Source SHA-256: acadb4bec72f193957b484ac6143fe23cb039d0af7a3b58259bf91a7fa6ae850
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
adr x0, LFQH_l_.str.182
LFQH_Lloh11:
nop
bl Lpatch + (0xa5b0 - PATCH_BASE)
mov	x22, x0
LFQH_Lloh12:
adr x0, LFQH_l_.str.183
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
adr x0, LFQH_l_.str.48
LFQH_Lloh27:
nop
bl Lpatch + (0xa5a4 - PATCH_BASE)
mov	x21, x0
LFQH_Lloh28:
adr x0, LFQH_l_.str.182
LFQH_Lloh29:
nop
bl Lpatch + (0xa5b0 - PATCH_BASE)
mov	x22, x0
LFQH_Lloh30:
adr x0, LFQH_l_.str.183
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
LFQH_Lloh32:
adr x0, LFQH_l_.str.7
LFQH_Lloh33:
nop
bl Lpatch + (0xa5b0 - PATCH_BASE)
mov	x21, x0
mov	x0, x20
bl Lpatch + (0xa5a4 - PATCH_BASE)
mov	x1, x0
mov	x0, x21
bl Lpatch + (0xa5f8 - PATCH_BASE)
cbz	x0, LFQH_LBB2_8
bl Lpatch + (0xa5ec - PATCH_BASE)
cbz	x0, LFQH_LBB2_8
ldrb	w9, [x19]
cbz	w9, LFQH_LBB2_6
add	x8, x19, #1
LFQH_LBB2_4:
ldrb	w10, [x0], #1
cmp	w10, w9
b.ne	LFQH_LBB2_7
ldrb	w9, [x8], #1
cbnz	w9, LFQH_LBB2_4
LFQH_LBB2_6:
ldrb	w8, [x0]
cmp	w8, #0
cset	w0, eq
b	LFQH_LBB2_8
LFQH_LBB2_7:
mov	w0, #0
LFQH_LBB2_8:
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
LFQH_Lloh34:
adr x0, LFQH_l_.str.12
LFQH_Lloh35:
nop
bl Lpatch + (0xa5b0 - PATCH_BASE)
LFQH_Lloh36:
adr x1, LFQH_l_.str.13
LFQH_Lloh37:
nop
bl	LFQH_Responds
cbz	w0, LFQH_LBB3_4
LFQH_Lloh38:
adr x0, LFQH_l_.str.14
LFQH_Lloh39:
nop
bl Lpatch + (0xa5b0 - PATCH_BASE)
LFQH_Lloh40:
adr x1, LFQH_l_.str.15
LFQH_Lloh41:
nop
bl	LFQH_Responds
cbz	w0, LFQH_LBB3_4
LFQH_Lloh42:
adr x0, LFQH_l_.str.16
LFQH_Lloh43:
nop
bl Lpatch + (0xa5b0 - PATCH_BASE)
mov	x19, x0
LFQH_Lloh44:
adr x0, LFQH_l_.str.17
LFQH_Lloh45:
nop
bl Lpatch + (0xa5a4 - PATCH_BASE)
mov	x1, x0
mov	x0, x19
bl Lpatch + (0xa5f8 - PATCH_BASE)
cbz	x0, LFQH_LBB3_4
LFQH_Lloh46:
adr x0, LFQH_l_.str.12
LFQH_Lloh47:
nop
bl Lpatch + (0xa5b0 - PATCH_BASE)
mov	x19, x0
LFQH_Lloh48:
adr x0, LFQH_l_.str.18
LFQH_Lloh49:
nop
bl Lpatch + (0xa5a4 - PATCH_BASE)
mov	x1, x0
mov	x0, x19
bl Lpatch + (0xa5f8 - PATCH_BASE)
cmp	x0, #0
cset	w0, ne
LFQH_LBB3_4:
ldp	x29, x30, [sp, #16]
ldp	x20, x19, [sp], #32
ret
.cfi_endproc
.p2align	2
LFQH_Responds:
.cfi_startproc
cbz	x0, LFQH_LBB4_2
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
LFQH_Lloh50:
adr x0, LFQH_l_.str.184
LFQH_Lloh51:
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
LFQH_LBB4_2:
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
LFQH_Lloh52:
adr x1, LFQH_l_.str.19
LFQH_Lloh53:
nop
bl	LFQH_Kind
tbz	w0, #0, LFQH_LBB5_3
LFQH_LBB5_1:
mov	w0, #1
LFQH_LBB5_2:
ldp	x29, x30, [sp, #64]
ldp	x20, x19, [sp, #48]
ldp	x22, x21, [sp, #32]
ldp	x24, x23, [sp, #16]
ldp	x26, x25, [sp], #80
ret
LFQH_LBB5_3:
LFQH_Lloh54:
adr x1, LFQH_l_.str.20
LFQH_Lloh55:
nop
mov	x0, x19
bl	LFQH_Get
cbz	x0, LFQH_LBB5_2
mov	x20, x0
mov	w26, #0
LFQH_Lloh56:
adr x21, LFQH_l_.str.185
LFQH_Lloh57:
nop
LFQH_Lloh58:
adr x22, LFQH_l_.str.21
LFQH_Lloh59:
nop
LFQH_Lloh60:
adr x23, LFQH_l_.str.20
LFQH_Lloh61:
nop
LFQH_Lloh62:
adr x24, LFQH_l_.str.22
LFQH_Lloh63:
nop
LFQH_LBB5_5:
mov	x0, x21
bl Lpatch + (0xa5a4 - PATCH_BASE)
mov	x25, x0
mov	x0, x22
bl Lpatch + (0xa5b0 - PATCH_BASE)
mov	x2, x0
mov	x0, x20
mov	x1, x25
bl Lpatch + (0xa5d4 - PATCH_BASE)
cbz	w0, LFQH_LBB5_7
mov	x0, x20
mov	x1, x24
bl	LFQH_Get
cmp	x0, x19
b.eq	LFQH_LBB5_1
LFQH_LBB5_7:
mov	x0, x20
mov	x1, x23
bl	LFQH_Get
mov	x20, x0
mov	w0, #0
cbz	x20, LFQH_LBB5_2
cmp	w26, #3
add	w26, w26, #1
b.lo	LFQH_LBB5_5
b	LFQH_LBB5_2
.cfi_endproc
.p2align	2
LFQH_Kind:
.cfi_startproc
cbz	x0, LFQH_LBB6_2
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
LFQH_Lloh64:
adr x0, LFQH_l_.str.185
LFQH_Lloh65:
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
LFQH_LBB6_2:
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
cbz	w0, LFQH_LBB7_2
mov	x0, x20
bl Lpatch + (0xa5a4 - PATCH_BASE)
mov	x1, x0
mov	x0, x19
ldp	x29, x30, [sp, #16]
ldp	x20, x19, [sp], #32
b Lpatch + (0xa5d4 - PATCH_BASE)
LFQH_LBB7_2:
mov	x0, #0
ldp	x29, x30, [sp, #16]
ldp	x20, x19, [sp], #32
ret
.cfi_endproc
.p2align	2
LFQH_FQHSurface:
.cfi_startproc
LFQH_Lloh66:
adr x1, LFQH_SurfaceKey
LFQH_Lloh67:
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
LFQH_Lloh68:
adr x1, LFQH_l_.str.23
LFQH_Lloh69:
nop
bl	LFQH_Kind
cbz	w0, LFQH_LBB10_2
LFQH_Lloh70:
adr x0, LFQH_l_.str.24
LFQH_Lloh71:
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
LFQH_LBB10_2:
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
mov	x22, x1
mov.16b	v8, v3
mov.16b	v9, v2
mov.16b	v10, v1
mov.16b	v11, v0
mov	x19, x0
LFQH_Lloh72:
adr x1, LFQH_BusyKey
LFQH_Lloh73:
nop
bl Lpatch + (0xa628 - PATCH_BASE)
cbz	x0, LFQH_LBB11_2
ldp	x29, x30, [sp, #80]
ldp	x20, x19, [sp, #64]
ldp	x22, x21, [sp, #48]
ldp	x24, x23, [sp, #32]
ldp	d9, d8, [sp, #16]
ldp	d11, d10, [sp], #96
ret
LFQH_LBB11_2:
LFQH_Lloh74:
adr x1, LFQH_BusyKey
LFQH_Lloh75:
nop
mov	x0, x19
mov	x2, x19
mov	x3, #0
bl Lpatch + (0xa634 - PATCH_BASE)
LFQH_Lloh76:
adr x1, LFQH_SurfaceKey
LFQH_Lloh77:
nop
mov	x0, x19
bl Lpatch + (0xa628 - PATCH_BASE)
mov	x20, x0
bl	LFQH_Enabled
cbz	w0, LFQH_LBB11_4
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
b.ls	LFQH_LBB11_6
LFQH_LBB11_4:
mov	x0, x19
mov	x1, x20
bl	LFQH_Restore
LFQH_LBB11_5:
LFQH_Lloh78:
adr x1, LFQH_BusyKey
LFQH_Lloh79:
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
LFQH_LBB11_6:
fmov	x8, d8
ubfx	x8, x8, #52, #11
cmp	x8, #2046
b.hi	LFQH_LBB11_4
fcmp	d9, #0.0
b.le	LFQH_LBB11_4
fcmp	d8, #0.0
b.le	LFQH_LBB11_4
cbz	x20, LFQH_LBB11_16
LFQH_LBB11_10:
LFQH_Lloh80:
adr x0, LFQH_l_.str.46
LFQH_Lloh81:
nop
bl Lpatch + (0xa5b0 - PATCH_BASE)
mov	x21, x0
LFQH_Lloh82:
adr x0, LFQH_l_.str.73
LFQH_Lloh83:
nop
bl Lpatch + (0xa5a4 - PATCH_BASE)
mov	x1, x0
mov	x0, x21
bl Lpatch + (0xa5d4 - PATCH_BASE)
mov	x23, x0
LFQH_Lloh84:
adr x0, LFQH_l_.str.187
LFQH_Lloh85:
nop
bl Lpatch + (0xa5b0 - PATCH_BASE)
mov	x21, x0
LFQH_Lloh86:
adr x0, LFQH_l_.str.188
LFQH_Lloh87:
nop
bl Lpatch + (0xa5a4 - PATCH_BASE)
mov	x1, x0
mov	x0, x21
bl Lpatch + (0xa5d4 - PATCH_BASE)
LFQH_Lloh88:
adr x0, LFQH_l_.str.189
LFQH_Lloh89:
nop
bl Lpatch + (0xa5a4 - PATCH_BASE)
mov	x1, x0
mov	x0, x21
mov	w2, #1
bl Lpatch + (0xa5d4 - PATCH_BASE)
cbnz	w22, LFQH_LBB11_21
LFQH_Lloh90:
adr x0, LFQH_l_.str.186
LFQH_Lloh91:
nop
bl Lpatch + (0xa5a4 - PATCH_BASE)
mov	x1, x0
mov	x0, x19
bl Lpatch + (0xa5d4 - PATCH_BASE)
cmp	x0, x23
b.eq	LFQH_LBB11_14
mov	x22, x0
LFQH_Lloh92:
adr x0, LFQH_l_.str.48
LFQH_Lloh93:
nop
bl Lpatch + (0xa5a4 - PATCH_BASE)
mov	x1, x0
mov	x0, x22
mov	x2, x23
bl Lpatch + (0xa5d4 - PATCH_BASE)
cbnz	w0, LFQH_LBB11_14
LFQH_Lloh94:
adr x1, LFQH_BackgroundKey
LFQH_Lloh95:
nop
mov	x0, x19
mov	x2, x22
mov	w3, #1
bl Lpatch + (0xa634 - PATCH_BASE)
LFQH_LBB11_14:
LFQH_Lloh96:
adr x1, LFQH_HeaderKey
LFQH_Lloh97:
nop
mov	x0, x19
bl Lpatch + (0xa628 - PATCH_BASE)
cbz	x0, LFQH_LBB11_19
mov	x0, x19
mov.16b	v0, v11
mov.16b	v1, v10
mov.16b	v2, v9
mov.16b	v3, v8
bl	LFQH_PrepareHeaderOwner
b	LFQH_LBB11_20
LFQH_LBB11_16:
bl	LFQH_NewGlassSurface
cbz	x0, LFQH_LBB11_5
mov	x20, x0
LFQH_Lloh98:
adr x0, LFQH_l_.str.81
LFQH_Lloh99:
nop
bl Lpatch + (0xa5a4 - PATCH_BASE)
mov	x1, x0
mov	x0, x20
mov	w2, #18
bl Lpatch + (0xa5d4 - PATCH_BASE)
LFQH_Lloh100:
adr x1, LFQH_SurfaceKey
LFQH_Lloh101:
nop
mov	x0, x19
mov	x2, x20
mov	w3, #1
bl Lpatch + (0xa634 - PATCH_BASE)
LFQH_Lloh102:
adr x0, LFQH_l_.str.55
LFQH_Lloh103:
nop
bl Lpatch + (0xa5a4 - PATCH_BASE)
mov	x1, x0
mov	x0, x20
bl Lpatch + (0xa5d4 - PATCH_BASE)
cbnz	w22, LFQH_LBB11_10
LFQH_Lloh104:
adr x0, LFQH_l_.str.186
LFQH_Lloh105:
nop
bl Lpatch + (0xa5a4 - PATCH_BASE)
mov	x1, x0
mov	x0, x19
bl Lpatch + (0xa5d4 - PATCH_BASE)
mov	x2, x0
LFQH_Lloh106:
adr x1, LFQH_BackgroundKey
LFQH_Lloh107:
nop
mov	x0, x19
mov	w3, #1
bl Lpatch + (0xa634 - PATCH_BASE)
b	LFQH_LBB11_10
LFQH_LBB11_19:
LFQH_Lloh108:
adr x0, LFQH_l_.str.190
LFQH_Lloh109:
nop
bl Lpatch + (0xa5a4 - PATCH_BASE)
mov	x1, x0
mov	x0, x19
bl Lpatch + (0xa5d4 - PATCH_BASE)
mov	x22, x0
LFQH_Lloh110:
adr x0, LFQH_l_.str.191
LFQH_Lloh111:
nop
bl Lpatch + (0xa5a4 - PATCH_BASE)
mov	x1, x0
mov	x0, x19
bl Lpatch + (0xa5d4 - PATCH_BASE)
mov	x2, x0
mov	x0, x19
mov	x1, x22
bl	LFQH_PrepareOwner
LFQH_LBB11_20:
mov	x0, x19
mov	x1, x23
bl	LFQH_ClearBackground
LFQH_LBB11_21:
LFQH_Lloh112:
adr x0, LFQH_l_.str.192
LFQH_Lloh113:
nop
bl Lpatch + (0xa5a4 - PATCH_BASE)
mov	x1, x0
mov	x0, x20
bl Lpatch + (0xa5d4 - PATCH_BASE)
fcmp	d0, d11
b.ne	LFQH_LBB11_25
fcmp	d1, d10
b.ne	LFQH_LBB11_25
fcmp	d2, d9
b.ne	LFQH_LBB11_25
fcmp	d3, d8
b.eq	LFQH_LBB11_26
LFQH_LBB11_25:
LFQH_Lloh114:
adr x0, LFQH_l_.str.71
LFQH_Lloh115:
nop
bl Lpatch + (0xa5a4 - PATCH_BASE)
mov	x1, x0
mov	x0, x20
mov.16b	v0, v11
mov.16b	v1, v10
mov.16b	v2, v9
mov.16b	v3, v8
bl Lpatch + (0xa5d4 - PATCH_BASE)
LFQH_LBB11_26:
mov	x0, x20
mov	x1, x23
bl	LFQH_ClearBackground
LFQH_Lloh116:
adr x0, LFQH_l_.str.193
LFQH_Lloh117:
nop
bl Lpatch + (0xa5a4 - PATCH_BASE)
mov	x1, x0
mov	x0, x20
bl Lpatch + (0xa5d4 - PATCH_BASE)
mov	x1, x23
bl	LFQH_ClearBackground
LFQH_Lloh118:
adr x0, LFQH_l_.str.20
LFQH_Lloh119:
nop
bl Lpatch + (0xa5a4 - PATCH_BASE)
mov	x1, x0
mov	x0, x20
bl Lpatch + (0xa5d4 - PATCH_BASE)
cmp	x0, x19
b.eq	LFQH_LBB11_28
LFQH_Lloh120:
adr x0, LFQH_l_.str.194
LFQH_Lloh121:
nop
bl Lpatch + (0xa5a4 - PATCH_BASE)
mov	x1, x0
mov	x0, x19
mov	x2, x20
mov	x3, #0
bl Lpatch + (0xa5d4 - PATCH_BASE)
LFQH_LBB11_28:
LFQH_Lloh122:
adr x0, LFQH_l_.str.195
LFQH_Lloh123:
nop
bl Lpatch + (0xa5a4 - PATCH_BASE)
mov	x1, x0
mov	x0, x21
bl Lpatch + (0xa5d4 - PATCH_BASE)
b	LFQH_LBB11_5
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
LFQH_Lloh124:
adr x1, LFQH_l_.str.23
LFQH_Lloh125:
nop
bl	LFQH_Kind
cbz	w0, LFQH_LBB12_11
LFQH_Lloh126:
adr x1, LFQH_HeaderKey
LFQH_Lloh127:
nop
mov	x0, x19
bl Lpatch + (0xa628 - PATCH_BASE)
cbnz	x0, LFQH_LBB12_3
LFQH_Lloh128:
adr x1, LFQH_l_.str.25
LFQH_Lloh129:
nop
mov	x0, x19
bl	LFQH_Kind
LFQH_Lloh130:
adr x8, LFQH_l_.str.26
LFQH_Lloh131:
nop
LFQH_Lloh132:
adr x9, LFQH_l_.str.27
LFQH_Lloh133:
nop
cmp	w0, #0
csel	x20, x9, x8, eq
LFQH_Lloh134:
adr x0, LFQH_l_.str.182
LFQH_Lloh135:
nop
bl Lpatch + (0xa5b0 - PATCH_BASE)
mov	x21, x0
LFQH_Lloh136:
adr x0, LFQH_l_.str.183
LFQH_Lloh137:
nop
bl Lpatch + (0xa5a4 - PATCH_BASE)
mov	x1, x0
mov	x0, x21
mov	x2, x20
bl Lpatch + (0xa5d4 - PATCH_BASE)
mov	x2, x0
LFQH_Lloh138:
adr x1, LFQH_HeaderKey
LFQH_Lloh139:
nop
mov	x0, x19
mov	w3, #1
bl Lpatch + (0xa634 - PATCH_BASE)
LFQH_LBB12_3:
mov	x0, x19
bl	LFQH_FQHApply
LFQH_Lloh140:
adr x1, LFQH_SurfaceKey
LFQH_Lloh141:
nop
mov	x0, x19
bl Lpatch + (0xa628 - PATCH_BASE)
cbz	x0, LFQH_LBB12_11
LFQH_Lloh142:
adr x0, LFQH_l_.str.24
LFQH_Lloh143:
nop
bl Lpatch + (0xa5a4 - PATCH_BASE)
mov	x1, x0
mov	x0, x19
bl Lpatch + (0xa5d4 - PATCH_BASE)
mov.16b	v8, v0
mov.16b	v9, v1
mov.16b	v10, v2
mov.16b	v11, v3
LFQH_Lloh144:
adr x1, LFQH_HeaderLogKey
LFQH_Lloh145:
nop
mov	x0, x19
bl Lpatch + (0xa628 - PATCH_BASE)
cbz	x0, LFQH_LBB12_9
mov	x20, x0
LFQH_Lloh146:
adr x0, LFQH_l_.str.224
LFQH_Lloh147:
nop
bl Lpatch + (0xa5a4 - PATCH_BASE)
mov	x1, x0
mov	x0, x20
bl Lpatch + (0xa5d4 - PATCH_BASE)
fcmp	d8, d0
b.ne	LFQH_LBB12_9
fcmp	d9, d1
b.ne	LFQH_LBB12_9
fcmp	d10, d2
b.ne	LFQH_LBB12_9
fcmp	d11, d3
b.eq	LFQH_LBB12_11
LFQH_LBB12_9:
LFQH_Lloh148:
adr x0, LFQH_l_.str.208
LFQH_Lloh149:
nop
bl Lpatch + (0xa5b0 - PATCH_BASE)
mov	x20, x0
LFQH_Lloh150:
adr x0, LFQH_l_.str.209
LFQH_Lloh151:
nop
bl Lpatch + (0xa5a4 - PATCH_BASE)
mov	x1, x0
mov	x0, x20
bl Lpatch + (0xa5d4 - PATCH_BASE)
mov	x20, x0
LFQH_Lloh152:
adr x0, LFQH_l_.str.210
LFQH_Lloh153:
nop
bl Lpatch + (0xa5a4 - PATCH_BASE)
mov	x1, x0
mov	x0, x20
bl Lpatch + (0xa5d4 - PATCH_BASE)
mov.16b	v12, v0
LFQH_Lloh154:
adr x1, LFQH_HeaderLogTimeKey
LFQH_Lloh155:
nop
mov	x0, x19
bl Lpatch + (0xa628 - PATCH_BASE)
cbz	x0, LFQH_LBB12_12
mov	x20, x0
LFQH_Lloh156:
adr x0, LFQH_l_.str.204
LFQH_Lloh157:
nop
bl Lpatch + (0xa5a4 - PATCH_BASE)
mov	x1, x0
mov	x0, x20
bl Lpatch + (0xa5d4 - PATCH_BASE)
fsub	d0, d12, d0
fmov	d1, #1.00000000
fcmp	d0, d1
b.pl	LFQH_LBB12_12
LFQH_LBB12_11:
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
LFQH_LBB12_12:
LFQH_Lloh158:
adr x0, LFQH_l_.str.225
LFQH_Lloh159:
nop
bl Lpatch + (0xa5b0 - PATCH_BASE)
mov	x20, x0
LFQH_Lloh160:
adr x0, LFQH_l_.str.226
LFQH_Lloh161:
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
LFQH_Lloh162:
adr x1, LFQH_HeaderLogKey
LFQH_Lloh163:
nop
mov	x0, x19
mov	w3, #1
bl Lpatch + (0xa634 - PATCH_BASE)
LFQH_Lloh164:
adr x21, LFQH_l_.str.205
LFQH_Lloh165:
nop
mov	x0, x21
bl Lpatch + (0xa5b0 - PATCH_BASE)
mov	x20, x0
LFQH_Lloh166:
adr x22, LFQH_l_.str.206
LFQH_Lloh167:
nop
mov	x0, x22
bl Lpatch + (0xa5a4 - PATCH_BASE)
mov	x1, x0
mov	x0, x20
mov.16b	v0, v12
bl Lpatch + (0xa5d4 - PATCH_BASE)
mov	x2, x0
LFQH_Lloh168:
adr x1, LFQH_HeaderLogTimeKey
LFQH_Lloh169:
nop
mov	x0, x19
mov	w3, #1
bl Lpatch + (0xa634 - PATCH_BASE)
LFQH_Lloh170:
adr x0, LFQH_l_.str.211
LFQH_Lloh171:
nop
bl Lpatch + (0xa5b0 - PATCH_BASE)
mov	x20, x0
LFQH_Lloh172:
adr x0, LFQH_l_.str.212
LFQH_Lloh173:
nop
bl Lpatch + (0xa5a4 - PATCH_BASE)
mov	x1, x0
mov	x0, x20
bl Lpatch + (0xa5d4 - PATCH_BASE)
mov	x20, x0
LFQH_Lloh174:
adr x1, LFQH_HeaderKey
LFQH_Lloh175:
nop
mov	x0, x19
bl Lpatch + (0xa628 - PATCH_BASE)
mov	x2, x0
LFQH_Lloh176:
adr x1, LFQH_l_.str.213
LFQH_Lloh177:
nop
mov	x0, x20
bl	LFQH_Put
LFQH_Lloh178:
adr x23, LFQH_l_.str.192
LFQH_Lloh179:
nop
mov	x0, x23
bl Lpatch + (0xa5a4 - PATCH_BASE)
mov	x1, x0
mov	x0, x19
bl Lpatch + (0xa5d4 - PATCH_BASE)
bl	LFQH_RectArray
mov	x2, x0
LFQH_Lloh180:
adr x1, LFQH_l_.str.214
LFQH_Lloh181:
nop
mov	x0, x20
bl	LFQH_Put
mov.16b	v0, v8
mov.16b	v1, v9
mov.16b	v2, v10
mov.16b	v3, v11
bl	LFQH_RectArray
mov	x2, x0
LFQH_Lloh182:
adr x1, LFQH_l_.str.215
LFQH_Lloh183:
nop
mov	x0, x20
bl	LFQH_Put
LFQH_Lloh184:
adr x1, LFQH_SurfaceKey
LFQH_Lloh185:
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
LFQH_Lloh186:
adr x1, LFQH_l_.str.216
LFQH_Lloh187:
nop
mov	x0, x20
bl	LFQH_Put
LFQH_Lloh188:
adr x23, LFQH_l_.str.190
LFQH_Lloh189:
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
LFQH_Lloh190:
adr x24, LFQH_l_.str.271
LFQH_Lloh191:
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
LFQH_Lloh192:
adr x0, LFQH_l_.str.202
LFQH_Lloh193:
nop
bl Lpatch + (0xa5a4 - PATCH_BASE)
mov	x1, x0
mov	x0, x19
bl Lpatch + (0xa5d4 - PATCH_BASE)
mov	x23, x0
LFQH_Lloh194:
adr x25, LFQH_l_.str.203
LFQH_Lloh195:
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
LFQH_Lloh196:
adr x1, LFQH_l_.str.217
LFQH_Lloh197:
nop
mov	x0, x19
bl	LFQH_Get
mov	x19, x0
LFQH_Lloh198:
adr x0, LFQH_l_.str.63
LFQH_Lloh199:
nop
bl Lpatch + (0xa5b0 - PATCH_BASE)
mov	x23, x0
LFQH_Lloh200:
adr x0, LFQH_l_.str.218
LFQH_Lloh201:
nop
bl Lpatch + (0xa5a4 - PATCH_BASE)
mov	x1, x0
mov	x0, x23
bl Lpatch + (0xa5d4 - PATCH_BASE)
mov	x23, x0
LFQH_Lloh202:
adr x0, LFQH_l_.str.34
LFQH_Lloh203:
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
LFQH_Lloh204:
adr x1, LFQH_l_.str.219
LFQH_Lloh205:
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
LFQH_Lloh206:
adr x1, LFQH_l_.str.220
LFQH_Lloh207:
nop
mov	x0, x20
bl	LFQH_Put
cbz	x25, LFQH_LBB12_15
mov	x21, #0
LFQH_Lloh208:
adr x22, LFQH_l_.str.221
LFQH_Lloh209:
nop
LFQH_Lloh210:
adr x24, LFQH_l_.str.264
LFQH_Lloh211:
nop
LFQH_Lloh212:
adr x25, LFQH_l_.str.192
LFQH_Lloh213:
nop
LFQH_LBB12_14:
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
b.ne	LFQH_LBB12_14
LFQH_LBB12_15:
LFQH_Lloh214:
adr x1, LFQH_l_.str.222
LFQH_Lloh215:
nop
mov	x0, x20
mov	x2, x23
bl	LFQH_Put
LFQH_Lloh216:
adr x0, LFQH_l_.str.223
LFQH_Lloh217:
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
LFQH_Lloh218:
adr x0, LFQH_l_.str.28
LFQH_Lloh219:
nop
bl Lpatch + (0xa5b0 - PATCH_BASE)
LFQH_Lloh220:
adr x1, LFQH_l_.str.29
LFQH_Lloh221:
nop
ldp	x29, x30, [sp], #16
b	LFQH_Responds
.cfi_endproc
.p2align	2
LFQH_FQHIconGlass:
.cfi_startproc
LFQH_Lloh222:
adr x1, LFQH_IconGlassKey
LFQH_Lloh223:
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
mov	w1, #1
b	LFQH_Icon
.cfi_endproc
.p2align	2
LFQH_Icon:
.cfi_startproc
sub	sp, sp, #272
stp	d15, d14, [sp, #112]
stp	d13, d12, [sp, #128]
stp	d11, d10, [sp, #144]
stp	d9, d8, [sp, #160]
stp	x28, x27, [sp, #176]
stp	x26, x25, [sp, #192]
stp	x24, x23, [sp, #208]
stp	x22, x21, [sp, #224]
stp	x20, x19, [sp, #240]
stp	x29, x30, [sp, #256]
add	x29, sp, #256
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
.cfi_offset b14, -152
.cfi_offset b15, -160
mov	x20, x1
mov	x19, x0
LFQH_Lloh224:
adr x1, LFQH_l_.str.23
LFQH_Lloh225:
nop
bl	LFQH_Kind
cbz	w0, LFQH_LBB18_2
LFQH_Lloh226:
adr x1, LFQH_BusyKey
LFQH_Lloh227:
nop
mov	x0, x19
bl Lpatch + (0xa628 - PATCH_BASE)
cbz	x0, LFQH_LBB18_3
LFQH_LBB18_2:
ldp	x29, x30, [sp, #256]
ldp	x20, x19, [sp, #240]
ldp	x22, x21, [sp, #224]
ldp	x24, x23, [sp, #208]
ldp	x26, x25, [sp, #192]
ldp	x28, x27, [sp, #176]
ldp	d9, d8, [sp, #160]
ldp	d11, d10, [sp, #144]
ldp	d13, d12, [sp, #128]
ldp	d15, d14, [sp, #112]
add	sp, sp, #272
ret
LFQH_LBB18_3:
LFQH_Lloh228:
adr x1, LFQH_BusyKey
LFQH_Lloh229:
nop
mov	x0, x19
mov	x2, x19
mov	x3, #0
bl Lpatch + (0xa634 - PATCH_BASE)
LFQH_Lloh230:
adr x1, LFQH_IconGlassKey
LFQH_Lloh231:
nop
mov	x0, x19
bl Lpatch + (0xa628 - PATCH_BASE)
mov	x21, x0
LFQH_Lloh232:
adr x0, LFQH_l_.str.24
LFQH_Lloh233:
nop
bl Lpatch + (0xa5a4 - PATCH_BASE)
mov	x1, x0
mov	x0, x19
bl Lpatch + (0xa5d4 - PATCH_BASE)
mov.16b	v15, v0
mov.16b	v12, v1
mov.16b	v14, v2
mov.16b	v13, v3
bl	LFQH_Enabled
cbz	w0, LFQH_LBB18_6
LFQH_Lloh234:
adr x0, LFQH_l_.str.28
LFQH_Lloh235:
nop
bl Lpatch + (0xa5b0 - PATCH_BASE)
LFQH_Lloh236:
adr x1, LFQH_l_.str.29
LFQH_Lloh237:
nop
bl	LFQH_Responds
cbz	w0, LFQH_LBB18_6
fmov	x8, d15
ubfx	x8, x8, #52, #11
fmov	x9, d12
ubfx	x9, x9, #52, #11
fmov	x10, d14
ubfx	x10, x10, #52, #11
cmp	x10, #2046
mov	w10, #2046
ccmp	x9, x10, #2, ls
ccmp	x8, x10, #2, ls
b.ls	LFQH_LBB18_8
LFQH_LBB18_6:
mov	x0, x19
mov	x1, x21
bl	LFQH_RestoreIcon
LFQH_LBB18_7:
LFQH_Lloh238:
adr x1, LFQH_BusyKey
LFQH_Lloh239:
nop
mov	x0, x19
mov	x2, #0
mov	x3, #0
ldp	x29, x30, [sp, #256]
ldp	x20, x19, [sp, #240]
ldp	x22, x21, [sp, #224]
ldp	x24, x23, [sp, #208]
ldp	x26, x25, [sp, #192]
ldp	x28, x27, [sp, #176]
ldp	d9, d8, [sp, #160]
ldp	d11, d10, [sp, #144]
ldp	d13, d12, [sp, #128]
ldp	d15, d14, [sp, #112]
add	sp, sp, #272
b Lpatch + (0xa634 - PATCH_BASE)
LFQH_LBB18_8:
fmov	x8, d13
ubfx	x8, x8, #52, #11
cmp	x8, #2046
b.hi	LFQH_LBB18_6
fcmp	d14, #0.0
b.le	LFQH_LBB18_6
fcmp	d13, #0.0
b.le	LFQH_LBB18_6
LFQH_Lloh240:
adr x1, LFQH_l_.str.228
LFQH_Lloh241:
nop
mov	x0, x19
bl	LFQH_Kind
cbz	w0, LFQH_LBB18_17
LFQH_Lloh242:
adr x1, LFQH_l_.str.229
LFQH_Lloh243:
nop
mov	x0, x19
bl	LFQH_Get
mov	x22, x0
cbz	x0, LFQH_LBB18_18
mov	w24, #0
LFQH_Lloh244:
adr x23, LFQH_l_.str.20
LFQH_Lloh245:
nop
mov	x0, x22
LFQH_LBB18_14:
cmp	x0, x19
b.eq	LFQH_LBB18_19
mov	x1, x23
bl	LFQH_Get
mov	w8, #1
cbz	x0, LFQH_LBB18_21
cmp	w24, #7
add	w24, w24, #1
b.lo	LFQH_LBB18_14
b	LFQH_LBB18_21
LFQH_LBB18_17:
mov	w8, #0
mov	x22, #0
b	LFQH_LBB18_21
LFQH_LBB18_18:
mov	w8, #0
b	LFQH_LBB18_21
LFQH_LBB18_19:
LFQH_Lloh246:
adr x0, LFQH_l_.str.230
LFQH_Lloh247:
nop
bl Lpatch + (0xa5a4 - PATCH_BASE)
mov	x1, x0
mov	x0, x22
bl Lpatch + (0xa5d4 - PATCH_BASE)
cbz	w0, LFQH_LBB18_63
LFQH_LBB18_20:
mov	w8, #1
LFQH_LBB18_21:
mov.16b	v9, v15
mov.16b	v10, v12
mov.16b	v11, v14
str	d13, [sp, #72]
LFQH_LBB18_22:
sub	w26, w20, #9
cmp	w20, #2
ccmp	w26, #2, #0, ne
csel	w8, wzr, w8, hs
cbz	w8, LFQH_LBB18_43
LFQH_Lloh248:
adr x1, LFQH_GlyphViewKey
LFQH_Lloh249:
nop
mov	x0, x19
bl Lpatch + (0xa628 - PATCH_BASE)
mov	x23, x0
cmp	x0, x22
b.eq	LFQH_LBB18_25
mov	x0, x19
bl	LFQH_RestoreGlyph
LFQH_LBB18_25:
LFQH_Lloh250:
adr x0, LFQH_l_.str.192
LFQH_Lloh251:
nop
bl Lpatch + (0xa5a4 - PATCH_BASE)
mov	x1, x0
mov	x0, x22
bl Lpatch + (0xa5d4 - PATCH_BASE)
mov.16b	v8, v0
stp	d2, d1, [sp, #88]
str	d3, [sp, #80]
LFQH_Lloh252:
adr x1, LFQH_GlyphOriginalKey
LFQH_Lloh253:
nop
mov	x0, x22
bl Lpatch + (0xa628 - PATCH_BASE)
mov	x25, x0
LFQH_Lloh254:
adr x1, LFQH_GlyphAppliedKey
LFQH_Lloh255:
nop
mov	x0, x22
bl Lpatch + (0xa628 - PATCH_BASE)
mov	x24, x0
stp	d10, d9, [sp, #56]
str	d11, [sp, #48]
cbz	x0, LFQH_LBB18_31
LFQH_Lloh256:
adr x0, LFQH_l_.str.224
LFQH_Lloh257:
nop
bl Lpatch + (0xa5a4 - PATCH_BASE)
mov	x1, x0
mov	x0, x24
bl Lpatch + (0xa5d4 - PATCH_BASE)
stp	d2, d1, [sp, #24]
stp	d0, d3, [sp, #8]
cbz	x25, LFQH_LBB18_32
fcmp	d8, d0
b.ne	LFQH_LBB18_32
ldr	d0, [sp, #96]
ldr	d1, [sp, #32]
fcmp	d0, d1
b.ne	LFQH_LBB18_32
ldr	d0, [sp, #88]
ldr	d1, [sp, #24]
fcmp	d0, d1
b.ne	LFQH_LBB18_32
ldr	d0, [sp, #80]
ldr	d1, [sp, #16]
fcmp	d0, d1
b.ne	LFQH_LBB18_32
b	LFQH_LBB18_33
LFQH_LBB18_31:
fmov	d0, xzr
stp	d0, d0, [sp, #8]
stp	d0, d0, [sp, #24]
LFQH_LBB18_32:
mov.16b	v0, v8
ldp	d2, d1, [sp, #88]
ldr	d3, [sp, #80]
bl	LFQH_RectBox
mov	x25, x0
LFQH_Lloh258:
adr x1, LFQH_GlyphOriginalKey
LFQH_Lloh259:
nop
mov	x0, x22
mov	x2, x25
mov	w3, #1
bl Lpatch + (0xa634 - PATCH_BASE)
LFQH_LBB18_33:
str	d8, [sp, #40]
LFQH_Lloh260:
adr x0, LFQH_l_.str.224
LFQH_Lloh261:
nop
bl Lpatch + (0xa5a4 - PATCH_BASE)
mov	x1, x0
mov	x0, x25
bl Lpatch + (0xa5d4 - PATCH_BASE)
mov.16b	v11, v1
mov.16b	v9, v2
mov.16b	v10, v3
cmp	w20, #2
b.ne	LFQH_LBB18_35
fmov	d1, #0.50000000
fmul	d1, d9, d1
fadd	d8, d0, d1
b	LFQH_LBB18_36
LFQH_LBB18_35:
fmov	d1, #0.75000000
fmov	d2, #0.12500000
fmul	d3, d9, d2
fmov	d4, #-0.25000000
fmul	d4, d9, d4
fmul	d9, d9, d1
fmul	d2, d10, d2
fmul	d10, d10, d1
fadd	d0, d0, d3
fadd	d11, d11, d2
fmov	d1, #-12.00000000
fadd	d1, d0, d1
cmp	w20, #9
fcsel	d1, d1, d0, eq
cmp	w20, #10
fadd	d0, d0, d4
fcsel	d8, d1, d0, ne
LFQH_LBB18_36:
ldr	d0, [sp, #40]
fcmp	d0, d8
ldp	d0, d1, [sp, #88]
fccmp	d1, d11, #0, eq
fccmp	d0, d9, #0, eq
ldr	d0, [sp, #80]
fccmp	d0, d10, #0, eq
b.eq	LFQH_LBB18_38
LFQH_Lloh262:
adr x0, LFQH_l_.str.71
LFQH_Lloh263:
nop
bl Lpatch + (0xa5a4 - PATCH_BASE)
mov	x1, x0
mov	x0, x22
mov.16b	v0, v8
mov.16b	v1, v11
mov.16b	v2, v9
mov.16b	v3, v10
bl Lpatch + (0xa5d4 - PATCH_BASE)
LFQH_LBB18_38:
cbz	x24, LFQH_LBB18_40
ldr	d0, [sp, #8]
fcmp	d0, d8
ldp	d0, d1, [sp, #24]
fccmp	d1, d11, #0, eq
fccmp	d0, d9, #0, eq
ldr	d0, [sp, #16]
fccmp	d0, d10, #0, eq
b.eq	LFQH_LBB18_41
LFQH_LBB18_40:
mov.16b	v0, v8
mov.16b	v1, v11
mov.16b	v2, v9
mov.16b	v3, v10
bl	LFQH_RectBox
mov	x2, x0
LFQH_Lloh264:
adr x1, LFQH_GlyphAppliedKey
LFQH_Lloh265:
nop
mov	x0, x22
mov	w3, #1
bl Lpatch + (0xa634 - PATCH_BASE)
LFQH_LBB18_41:
cmp	x23, x22
ldp	d10, d9, [sp, #56]
ldr	d11, [sp, #48]
b.eq	LFQH_LBB18_43
LFQH_Lloh266:
adr x1, LFQH_GlyphViewKey
LFQH_Lloh267:
nop
mov	x0, x19
mov	x2, x22
mov	w3, #1
bl Lpatch + (0xa634 - PATCH_BASE)
LFQH_LBB18_43:
cmp	w26, #2
mov	w8, #36
mov	w9, #28
csel	w23, w9, w8, lo
cmp	w20, #2
mov	w8, #6
csel	w24, w8, wzr, eq
cmp	w20, #9
mov	w8, #12
csel	w25, w8, wzr, eq
cmp	w20, #8
b.eq	LFQH_LBB18_45
cmp	w20, #5
b.ne	LFQH_LBB18_47
LFQH_LBB18_45:
LFQH_Lloh268:
adr x1, LFQH_l_.str.36
LFQH_Lloh269:
nop
mov	x0, x19
bl	LFQH_Kind
cbz	w0, LFQH_LBB18_47
LFQH_Lloh270:
adr x0, LFQH_l_.str.20
LFQH_Lloh271:
nop
bl Lpatch + (0xa5a4 - PATCH_BASE)
mov	x1, x0
mov	x0, x19
bl Lpatch + (0xa5d4 - PATCH_BASE)
mov	x22, x0
mov	w27, #1
b	LFQH_LBB18_48
LFQH_LBB18_47:
mov	w27, #0
mov	x22, x19
LFQH_LBB18_48:
cbz	x22, LFQH_LBB18_6
mov	x0, x19
bl	LFQH_CanExpandHit
cbz	w0, LFQH_LBB18_6
cbz	w27, LFQH_LBB18_53
LFQH_Lloh272:
adr x0, LFQH_l_.str.230
LFQH_Lloh273:
nop
bl Lpatch + (0xa5a4 - PATCH_BASE)
mov	x1, x0
mov	x0, x19
bl Lpatch + (0xa5d4 - PATCH_BASE)
cbnz	w0, LFQH_LBB18_6
fmov	d0, #-6.00000000
fadd	d15, d15, d0
fmov	d0, #-5.00000000
fadd	d12, d12, d0
fmov	d0, #12.00000000
fadd	d14, d14, d0
fmov	d0, #10.00000000
fadd	d8, d13, d0
b	LFQH_LBB18_56
LFQH_LBB18_53:
cmp	w20, #7
b.ne	LFQH_LBB18_55
fmov	d0, #6.00000000
fadd	d0, d13, d0
fmov	d1, #30.00000000
fmaxnm	d8, d0, d1
fmov	d0, #-6.00000000
fadd	d15, d15, d0
fsub	d0, d13, d8
fmov	d1, #0.50000000
fmul	d0, d0, d1
fadd	d12, d12, d0
fmov	d0, #12.00000000
fadd	d14, d14, d0
b	LFQH_LBB18_56
LFQH_LBB18_55:
fmov	d0, #0.50000000
fmul	d1, d14, d0
fadd	d1, d15, d1
ucvtf	d2, w24
fadd	d1, d1, d2
ucvtf	d2, w25
fmul	d0, d13, d0
fsub	d1, d1, d2
ucvtf	d2, w23, #1
fadd	d0, d12, d0
ucvtf	d14, w23
fsub	d15, d1, d2
fsub	d12, d0, d2
mov.16b	v8, v14
LFQH_LBB18_56:
mov.16b	v0, v15
mov.16b	v1, v12
mov.16b	v2, v14
mov.16b	v3, v8
bl	LFQH_VisibleRect
tbz	w0, #0, LFQH_LBB18_6
mov.16b	v13, v8
mov.16b	v2, v14
mov.16b	v1, v12
mov.16b	v0, v15
cbz	w27, LFQH_LBB18_59
LFQH_Lloh274:
adr x0, LFQH_l_.str.241
LFQH_Lloh275:
nop
bl Lpatch + (0xa5a4 - PATCH_BASE)
mov	x1, x0
mov	x0, x19
mov.16b	v0, v15
mov.16b	v1, v12
mov.16b	v2, v14
mov.16b	v3, v8
mov	x2, x22
bl Lpatch + (0xa5d4 - PATCH_BASE)
mov.16b	v13, v3
LFQH_LBB18_59:
stp	d8, d12, [sp, #32]
mov.16b	v8, v0
mov.16b	v12, v1
str	d15, [sp, #80]
mov.16b	v15, v2
cbz	x21, LFQH_LBB18_66
LFQH_LBB18_60:
LFQH_Lloh276:
adr x1, LFQH_IconRectKey
LFQH_Lloh277:
nop
mov	x0, x19
bl Lpatch + (0xa628 - PATCH_BASE)
cbz	x0, LFQH_LBB18_62
mov	x23, x0
LFQH_Lloh278:
adr x0, LFQH_l_.str.224
LFQH_Lloh279:
nop
bl Lpatch + (0xa5a4 - PATCH_BASE)
mov	x1, x0
mov	x0, x23
bl Lpatch + (0xa5d4 - PATCH_BASE)
fcmp	d0, d8
fccmp	d1, d12, #0, eq
fccmp	d2, d15, #0, eq
b.eq	LFQH_LBB18_69
LFQH_LBB18_62:
mov	w8, #1
b	LFQH_LBB18_70
LFQH_LBB18_63:
LFQH_Lloh280:
adr x0, LFQH_l_.str.24
LFQH_Lloh281:
nop
bl Lpatch + (0xa5a4 - PATCH_BASE)
mov	x1, x0
mov	x0, x22
bl Lpatch + (0xa5d4 - PATCH_BASE)
bl	LFQH_VisibleRect
cbz	w0, LFQH_LBB18_20
LFQH_Lloh282:
adr x0, LFQH_l_.str.24
LFQH_Lloh283:
nop
bl Lpatch + (0xa5a4 - PATCH_BASE)
mov	x1, x0
mov	x0, x22
bl Lpatch + (0xa5d4 - PATCH_BASE)
mov.16b	v8, v0
mov.16b	v9, v1
mov.16b	v10, v2
mov.16b	v11, v3
LFQH_Lloh284:
adr x0, LFQH_l_.str.241
LFQH_Lloh285:
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
mov.16b	v9, v0
mov.16b	v10, v1
mov.16b	v11, v2
str	d3, [sp, #72]
bl	LFQH_VisibleRect
cbz	w0, LFQH_LBB18_20
mov	w8, #1
b	LFQH_LBB18_22
LFQH_LBB18_66:
LFQH_Lloh286:
adr x0, LFQH_l_.str.28
LFQH_Lloh287:
nop
bl Lpatch + (0xa5b0 - PATCH_BASE)
mov	x21, x0
LFQH_Lloh288:
adr x0, LFQH_l_.str.29
LFQH_Lloh289:
nop
bl Lpatch + (0xa5a4 - PATCH_BASE)
mov	x1, x0
mov	x0, x21
bl Lpatch + (0xa5d4 - PATCH_BASE)
cbz	x0, LFQH_LBB18_7
mov	x23, x0
bl	LFQH_GlassClass
mov	x21, x0
LFQH_Lloh290:
adr x0, LFQH_l_.str.231
LFQH_Lloh291:
nop
bl Lpatch + (0xa5a4 - PATCH_BASE)
mov	x1, x0
mov	x0, x21
bl Lpatch + (0xa5d4 - PATCH_BASE)
cbz	x0, LFQH_LBB18_7
mov	x21, x0
LFQH_Lloh292:
adr x0, LFQH_l_.str.232
LFQH_Lloh293:
nop
bl Lpatch + (0xa5a4 - PATCH_BASE)
mov	x1, x0
mov	x0, x21
mov	x2, x23
bl Lpatch + (0xa5d4 - PATCH_BASE)
LFQH_Lloh294:
adr x0, LFQH_l_.str.197
LFQH_Lloh295:
nop
bl Lpatch + (0xa5a4 - PATCH_BASE)
mov	x1, x0
mov	x0, x21
mov	w2, #0
bl Lpatch + (0xa5d4 - PATCH_BASE)
LFQH_Lloh296:
adr x0, LFQH_l_.str.198
LFQH_Lloh297:
nop
bl Lpatch + (0xa5a4 - PATCH_BASE)
mov	x1, x0
mov	x0, x21
mov	w2, #1
bl Lpatch + (0xa5d4 - PATCH_BASE)
LFQH_Lloh298:
adr x0, LFQH_l_.str.199
LFQH_Lloh299:
nop
bl Lpatch + (0xa5a4 - PATCH_BASE)
mov	x1, x0
mov	x0, x21
mov	w2, #0
bl Lpatch + (0xa5d4 - PATCH_BASE)
LFQH_Lloh300:
adr x0, LFQH_l_.str.200
LFQH_Lloh301:
nop
bl Lpatch + (0xa5a4 - PATCH_BASE)
mov	x1, x0
mov	x0, x21
mov	w2, #0
bl Lpatch + (0xa5d4 - PATCH_BASE)
LFQH_Lloh302:
adr x0, LFQH_l_.str.81
LFQH_Lloh303:
nop
bl Lpatch + (0xa5a4 - PATCH_BASE)
mov	x1, x0
mov	x0, x21
mov	x2, #0
bl Lpatch + (0xa5d4 - PATCH_BASE)
LFQH_Lloh304:
adr x1, LFQH_IconGlassKey
LFQH_Lloh305:
nop
mov	x0, x19
mov	x2, x21
mov	w3, #1
bl Lpatch + (0xa634 - PATCH_BASE)
LFQH_Lloh306:
adr x0, LFQH_l_.str.55
LFQH_Lloh307:
nop
bl Lpatch + (0xa5a4 - PATCH_BASE)
mov	x1, x0
mov	x0, x21
bl Lpatch + (0xa5d4 - PATCH_BASE)
mov	x0, x19
mov	x1, x21
mov	w2, #1
bl	LFQH_ObservePress
b	LFQH_LBB18_60
LFQH_LBB18_69:
fcmp	d3, d13
cset	w8, ne
LFQH_LBB18_70:
str	w8, [sp, #88]
LFQH_Lloh308:
adr x0, LFQH_l_.str.20
LFQH_Lloh309:
nop
bl Lpatch + (0xa5a4 - PATCH_BASE)
mov	x1, x0
mov	x0, x21
bl Lpatch + (0xa5d4 - PATCH_BASE)
str	x0, [sp, #96]
tbz	w27, #0, LFQH_LBB18_72
str	wzr, [sp, #4]
mov	w24, #0
mov	w28, #0
b	LFQH_LBB18_73
LFQH_LBB18_72:
LFQH_Lloh310:
adr x0, LFQH_l_.str.190
LFQH_Lloh311:
nop
bl Lpatch + (0xa5a4 - PATCH_BASE)
mov	x1, x0
mov	x0, x19
bl Lpatch + (0xa5d4 - PATCH_BASE)
cmp	w0, #0
cset	w24, ne
LFQH_Lloh312:
adr x0, LFQH_l_.str.191
LFQH_Lloh313:
nop
bl Lpatch + (0xa5a4 - PATCH_BASE)
mov	x1, x0
mov	x0, x19
bl Lpatch + (0xa5d4 - PATCH_BASE)
cmp	w0, #0
cset	w28, ne
str	w24, [sp, #4]
LFQH_LBB18_73:
LFQH_Lloh314:
adr x1, LFQH_l_.str.41
LFQH_Lloh315:
nop
mov	x0, x19
bl	LFQH_Kind
cbz	w0, LFQH_LBB18_75
str	w24, [sp]
LFQH_Lloh316:
adr x24, LFQH_l_.str.233
LFQH_Lloh317:
nop
mov	x0, x24
bl Lpatch + (0xa5a4 - PATCH_BASE)
mov	x1, x0
mov	x0, x19
bl Lpatch + (0xa5d4 - PATCH_BASE)
mov	x26, x0
LFQH_Lloh318:
adr x0, LFQH_l_.str.234
LFQH_Lloh319:
nop
bl Lpatch + (0xa5a4 - PATCH_BASE)
mov	x1, x0
mov	x0, x19
bl Lpatch + (0xa5d4 - PATCH_BASE)
mov	x25, x28
mov	x28, x0
LFQH_Lloh320:
adr x0, LFQH_l_.str.235
LFQH_Lloh321:
nop
bl Lpatch + (0xa5a4 - PATCH_BASE)
mov	x1, x0
mov	x0, x19
bl Lpatch + (0xa5d4 - PATCH_BASE)
mov	x23, x0
mov	x0, x24
bl Lpatch + (0xa5a4 - PATCH_BASE)
mov	x1, x0
mov	x0, x21
bl Lpatch + (0xa5d4 - PATCH_BASE)
str	w26, [sp, #8]
cmp	w0, w26
cset	w24, ne
LFQH_Lloh322:
adr x0, LFQH_l_.str.234
LFQH_Lloh323:
nop
bl Lpatch + (0xa5a4 - PATCH_BASE)
mov	x1, x0
mov	x0, x21
bl Lpatch + (0xa5d4 - PATCH_BASE)
str	w28, [sp, #16]
cmp	w0, w28
mov	x28, x25
cset	w25, ne
LFQH_Lloh324:
adr x0, LFQH_l_.str.235
LFQH_Lloh325:
nop
bl Lpatch + (0xa5a4 - PATCH_BASE)
mov	x1, x0
mov	x0, x21
bl Lpatch + (0xa5d4 - PATCH_BASE)
str	w23, [sp, #24]
cmp	w0, w23
mov	x23, x24
ldr	w24, [sp]
cset	w26, ne
b	LFQH_LBB18_76
LFQH_LBB18_75:
mov	w23, #0
mov	w25, #0
mov	w26, #0
str	wzr, [sp, #8]
str	wzr, [sp, #16]
str	wzr, [sp, #24]
LFQH_LBB18_76:
ldr	x8, [sp, #96]
cmp	x8, x22
ldr	w8, [sp, #88]
csinc	w8, w8, wzr, eq
orr	w8, w8, w24
tbnz	w8, #0, LFQH_LBB18_82
tbnz	w28, #0, LFQH_LBB18_82
tbnz	w23, #0, LFQH_LBB18_82
tbnz	w25, #0, LFQH_LBB18_82
cbnz	w26, LFQH_LBB18_82
mov	x24, #0
b	LFQH_LBB18_83
LFQH_LBB18_82:
LFQH_Lloh326:
adr x0, LFQH_l_.str.187
LFQH_Lloh327:
nop
bl Lpatch + (0xa5b0 - PATCH_BASE)
mov	x24, x0
LFQH_Lloh328:
adr x0, LFQH_l_.str.188
LFQH_Lloh329:
nop
bl Lpatch + (0xa5a4 - PATCH_BASE)
mov	x1, x0
mov	x0, x24
bl Lpatch + (0xa5d4 - PATCH_BASE)
LFQH_Lloh330:
adr x0, LFQH_l_.str.189
LFQH_Lloh331:
nop
bl Lpatch + (0xa5a4 - PATCH_BASE)
mov	x1, x0
mov	x0, x24
mov	w2, #1
bl Lpatch + (0xa5d4 - PATCH_BASE)
LFQH_LBB18_83:
tbnz	w27, #0, LFQH_LBB18_85
mov	x0, x19
ldr	w1, [sp, #4]
mov	x2, x28
bl	LFQH_PrepareOwner
LFQH_LBB18_85:
ldr	w8, [sp, #88]
cbz	w8, LFQH_LBB18_87
LFQH_Lloh332:
adr x0, LFQH_l_.str.71
LFQH_Lloh333:
nop
bl Lpatch + (0xa5a4 - PATCH_BASE)
mov	x1, x0
mov	x0, x21
mov.16b	v0, v8
mov.16b	v1, v12
mov.16b	v2, v15
mov.16b	v3, v13
bl Lpatch + (0xa5d4 - PATCH_BASE)
mov.16b	v0, v8
mov.16b	v1, v12
mov.16b	v2, v15
mov.16b	v3, v13
bl	LFQH_RectBox
mov	x2, x0
LFQH_Lloh334:
adr x1, LFQH_IconRectKey
LFQH_Lloh335:
nop
mov	x0, x19
mov	w3, #1
bl Lpatch + (0xa634 - PATCH_BASE)
LFQH_LBB18_87:
ldr	x8, [sp, #96]
cmp	x8, x22
ldr	d13, [sp, #80]
ldp	d8, d12, [sp, #32]
b.eq	LFQH_LBB18_92
cbz	w27, LFQH_LBB18_90
LFQH_Lloh336:
adr x0, LFQH_l_.str.236
LFQH_Lloh337:
nop
bl Lpatch + (0xa5a4 - PATCH_BASE)
mov	x1, x0
mov	x0, x22
mov	x2, x21
mov	x3, x19
b	LFQH_LBB18_91
LFQH_LBB18_90:
LFQH_Lloh338:
adr x0, LFQH_l_.str.194
LFQH_Lloh339:
nop
bl Lpatch + (0xa5a4 - PATCH_BASE)
mov	x1, x0
mov	x0, x22
mov	x2, x21
mov	x3, #0
LFQH_LBB18_91:
bl Lpatch + (0xa5d4 - PATCH_BASE)
LFQH_LBB18_92:
cbnz	w23, LFQH_LBB18_99
cbnz	w25, LFQH_LBB18_100
LFQH_LBB18_94:
cbz	w26, LFQH_LBB18_96
LFQH_LBB18_95:
LFQH_Lloh340:
adr x0, LFQH_l_.str.239
LFQH_Lloh341:
nop
bl Lpatch + (0xa5a4 - PATCH_BASE)
mov	x1, x0
mov	x0, x21
ldr	w2, [sp, #24]
bl Lpatch + (0xa5d4 - PATCH_BASE)
LFQH_LBB18_96:
mov	x0, x19
mov.16b	v0, v13
mov.16b	v1, v12
mov.16b	v2, v14
mov.16b	v3, v8
bl	LFQH_EnsureHit
cbz	x24, LFQH_LBB18_98
LFQH_Lloh342:
adr x0, LFQH_l_.str.195
LFQH_Lloh343:
nop
bl Lpatch + (0xa5a4 - PATCH_BASE)
mov	x1, x0
mov	x0, x24
bl Lpatch + (0xa5d4 - PATCH_BASE)
LFQH_LBB18_98:
mov	x0, x20
bl	LFQH_IconRoleName
mov	x2, x0
mov	x0, x19
mov	x1, x21
mov.16b	v0, v9
mov.16b	v1, v10
mov.16b	v2, v11
ldr	d3, [sp, #72]
bl	LFQH_RecordLayout
b	LFQH_LBB18_7
LFQH_LBB18_99:
LFQH_Lloh344:
adr x0, LFQH_l_.str.237
LFQH_Lloh345:
nop
bl Lpatch + (0xa5a4 - PATCH_BASE)
mov	x1, x0
mov	x0, x21
ldr	w2, [sp, #8]
bl Lpatch + (0xa5d4 - PATCH_BASE)
cbz	w25, LFQH_LBB18_94
LFQH_LBB18_100:
LFQH_Lloh346:
adr x0, LFQH_l_.str.238
LFQH_Lloh347:
nop
bl Lpatch + (0xa5a4 - PATCH_BASE)
mov	x1, x0
mov	x0, x21
ldr	w2, [sp, #16]
bl Lpatch + (0xa5d4 - PATCH_BASE)
cbnz	w26, LFQH_LBB18_95
b	LFQH_LBB18_96
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
LFQH_Lloh348:
adr x1, LFQH_ReaderGlassKey
LFQH_Lloh349:
nop
bl Lpatch + (0xa628 - PATCH_BASE)
mov	x19, x0
LFQH_Lloh350:
adr x0, LFQH_l_.str.30
LFQH_Lloh351:
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
sub	sp, sp, #144
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
mov	x19, x0
LFQH_Lloh352:
adr x1, LFQH_OwnerBusyKey
LFQH_Lloh353:
nop
bl Lpatch + (0xa628 - PATCH_BASE)
cbnz	x0, LFQH_LBB21_41
LFQH_Lloh354:
adr x1, LFQH_OwnerBusyKey
LFQH_Lloh355:
nop
mov	x0, x19
mov	x2, x19
mov	x3, #0
bl Lpatch + (0xa634 - PATCH_BASE)
LFQH_Lloh356:
adr x0, LFQH_l_.str.24
LFQH_Lloh357:
nop
bl Lpatch + (0xa5a4 - PATCH_BASE)
mov	x1, x0
mov	x0, x19
bl Lpatch + (0xa5d4 - PATCH_BASE)
stp	d0, d1, [sp, #16]
stp	d2, d3, [sp, #32]
LFQH_Lloh358:
adr x1, LFQH_l_.str.31
LFQH_Lloh359:
nop
mov	x0, x19
bl	LFQH_Get
cbz	x0, LFQH_LBB21_6
mov	x21, x0
mov	w23, #0
LFQH_Lloh360:
adr x22, LFQH_l_.str.20
LFQH_Lloh361:
nop
LFQH_LBB21_3:
cmp	x0, x19
b.eq	LFQH_LBB21_7
mov	x1, x22
bl	LFQH_Get
mov	x20, #0
cbz	x0, LFQH_LBB21_8
cmp	w23, #7
add	w23, w23, #1
b.lo	LFQH_LBB21_3
b	LFQH_LBB21_8
LFQH_LBB21_6:
mov	x20, #0
b	LFQH_LBB21_8
LFQH_LBB21_7:
mov	x0, x21
mov	w1, #2
bl	LFQH_Icon
LFQH_Lloh362:
adr x20, LFQH_IconGlassKey
LFQH_Lloh363:
nop
mov	x0, x21
mov	x1, x20
bl Lpatch + (0xa628 - PATCH_BASE)
add	x2, sp, #16
mov	x1, x19
bl	LFQH_IncludeMaterial
mov	x0, x21
mov	x1, x20
bl Lpatch + (0xa628 - PATCH_BASE)
cmp	x0, #0
cset	w20, ne
LFQH_LBB21_8:
LFQH_Lloh364:
adr x1, LFQH_l_.str.32
LFQH_Lloh365:
nop
mov	x0, x19
bl	LFQH_Get
mov	x21, x0
LFQH_Lloh366:
adr x1, LFQH_l_.str.33
LFQH_Lloh367:
nop
bl	LFQH_Kind
cbz	w0, LFQH_LBB21_31
LFQH_Lloh368:
adr x0, LFQH_l_.str.34
LFQH_Lloh369:
nop
bl Lpatch + (0xa5a4 - PATCH_BASE)
mov	x1, x0
mov	x0, x21
bl Lpatch + (0xa5d4 - PATCH_BASE)
cmp	x0, #16
mov	w8, #16
csel	x23, x0, x8, lo
cbz	x0, LFQH_LBB21_31
stp	xzr, xzr, [sp]
mov	x24, #0
LFQH_Lloh370:
adr x27, LFQH_l_.str.20
LFQH_Lloh371:
nop
LFQH_LBB21_11:
LFQH_Lloh372:
adr x0, LFQH_l_.str.264
LFQH_Lloh373:
nop
bl Lpatch + (0xa5a4 - PATCH_BASE)
mov	x1, x0
mov	x0, x21
mov	x2, x24
bl Lpatch + (0xa5d4 - PATCH_BASE)
mov	x25, x0
LFQH_Lloh374:
adr x1, LFQH_l_.str.265
LFQH_Lloh375:
nop
bl	LFQH_Kind
tbz	w0, #0, LFQH_LBB21_13
mov	w28, #0
mov	w22, #3
b	LFQH_LBB21_21
LFQH_LBB21_13:
mov	x0, x25
LFQH_Lloh376:
adr x1, LFQH_l_.str.266
LFQH_Lloh377:
nop
bl	LFQH_Kind
tbz	w0, #0, LFQH_LBB21_15
mov	w28, #0
mov	w22, #4
b	LFQH_LBB21_21
LFQH_LBB21_15:
mov	x0, x25
LFQH_Lloh378:
adr x1, LFQH_l_.str.267
LFQH_Lloh379:
nop
bl	LFQH_Kind
tbz	w0, #0, LFQH_LBB21_17
mov	w22, #5
mov	w28, #1
b	LFQH_LBB21_21
LFQH_LBB21_17:
mov	x0, x25
LFQH_Lloh380:
adr x1, LFQH_l_.str.268
LFQH_Lloh381:
nop
bl	LFQH_Kind
tbz	w0, #0, LFQH_LBB21_19
mov	w28, #0
mov	w22, #8
b	LFQH_LBB21_21
LFQH_LBB21_19:
mov	x0, x25
LFQH_Lloh382:
adr x1, LFQH_l_.str.269
LFQH_Lloh383:
nop
bl	LFQH_Kind
cbz	w0, LFQH_LBB21_30
mov	w28, #0
mov	w22, #6
LFQH_LBB21_21:
mov	x0, x25
LFQH_Lloh384:
adr x1, LFQH_l_.str.35
LFQH_Lloh385:
nop
bl	LFQH_Get
cbz	x0, LFQH_LBB21_30
mov	x25, x0
mov	w26, #0
LFQH_LBB21_23:
cmp	x0, x19
b.eq	LFQH_LBB21_26
mov	x1, x27
bl	LFQH_Get
cbz	x0, LFQH_LBB21_30
cmp	w26, #7
add	w26, w26, #1
b.lo	LFQH_LBB21_23
b	LFQH_LBB21_30
LFQH_LBB21_26:
mov	x0, x25
mov	x1, x22
bl	LFQH_Icon
mov	x0, x25
LFQH_Lloh386:
adr x1, LFQH_IconGlassKey
LFQH_Lloh387:
nop
bl Lpatch + (0xa628 - PATCH_BASE)
mov	x26, x0
add	x2, sp, #16
mov	x1, x19
bl	LFQH_IncludeMaterial
cmp	x26, #0
cinc	x20, x20, ne
cbz	x26, LFQH_LBB21_30
cmp	w22, #8
b.eq	LFQH_LBB21_29
cmp	w22, #5
b.ne	LFQH_LBB21_30
LFQH_LBB21_29:
mov	x0, x25
LFQH_Lloh388:
adr x1, LFQH_l_.str.36
LFQH_Lloh389:
nop
bl	LFQH_Kind
cmp	w28, #0
ldp	x11, x10, [sp]
csel	x8, x10, x25, ne
csel	x9, x25, x11, ne
cmp	w0, #0
csel	x10, x10, x8, eq
csel	x11, x11, x9, eq
stp	x11, x10, [sp]
LFQH_LBB21_30:
add	x24, x24, #1
cmp	x24, x23
b.ne	LFQH_LBB21_11
b	LFQH_LBB21_32
LFQH_LBB21_31:
stp	xzr, xzr, [sp]
LFQH_LBB21_32:
LFQH_Lloh390:
adr x1, LFQH_ReaderDownloadLabelKey
LFQH_Lloh391:
nop
mov	x0, x19
ldr	x2, [sp]
bl	LFQH_TrackReaderLabel
LFQH_Lloh392:
adr x1, LFQH_ReaderShelfLabelKey
LFQH_Lloh393:
nop
mov	x0, x19
ldr	x2, [sp, #8]
bl	LFQH_TrackReaderLabel
cbz	x20, LFQH_LBB21_34
ldp	d0, d1, [sp, #16]
ldp	d2, d3, [sp, #32]
mov	x0, x19
bl	LFQH_EnsureHit
b	LFQH_LBB21_35
LFQH_LBB21_34:
mov	x0, x19
bl	LFQH_RestoreHit
LFQH_LBB21_35:
LFQH_Lloh394:
adr x1, LFQH_ReaderGlassKey
LFQH_Lloh395:
nop
mov	x0, x19
bl Lpatch + (0xa628 - PATCH_BASE)
mov	x21, x0
LFQH_Lloh396:
adr x0, LFQH_l_.str.30
LFQH_Lloh397:
nop
bl Lpatch + (0xa5a4 - PATCH_BASE)
mov	x1, x0
mov	x0, x21
bl Lpatch + (0xa5d4 - PATCH_BASE)
cmp	x20, x0
b.eq	LFQH_LBB21_40
cbz	x20, LFQH_LBB21_38
LFQH_Lloh398:
adr x0, LFQH_l_.str.205
LFQH_Lloh399:
nop
bl Lpatch + (0xa5b0 - PATCH_BASE)
mov	x21, x0
LFQH_Lloh400:
adr x0, LFQH_l_.str.270
LFQH_Lloh401:
nop
bl Lpatch + (0xa5a4 - PATCH_BASE)
mov	x1, x0
mov	x0, x21
mov	x2, x20
bl Lpatch + (0xa5d4 - PATCH_BASE)
mov	x2, x0
b	LFQH_LBB21_39
LFQH_LBB21_38:
mov	x2, #0
LFQH_LBB21_39:
LFQH_Lloh402:
adr x1, LFQH_ReaderGlassKey
LFQH_Lloh403:
nop
mov	x0, x19
mov	w3, #1
bl Lpatch + (0xa634 - PATCH_BASE)
LFQH_LBB21_40:
LFQH_Lloh404:
adr x1, LFQH_OwnerBusyKey
LFQH_Lloh405:
nop
mov	x0, x19
mov	x2, #0
mov	x3, #0
bl Lpatch + (0xa634 - PATCH_BASE)
LFQH_LBB21_41:
ldp	x29, x30, [sp, #128]
ldp	x20, x19, [sp, #112]
ldp	x22, x21, [sp, #96]
ldp	x24, x23, [sp, #80]
ldp	x26, x25, [sp, #64]
ldp	x28, x27, [sp, #48]
add	sp, sp, #144
ret
.cfi_endproc
.p2align	2
LFQH_OwnerBusyKey:
.cfi_startproc
ret
.cfi_endproc
.p2align	2
LFQH_IncludeMaterial:
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
mov	x22, x0
LFQH_Lloh406:
adr x0, LFQH_l_.str.20
LFQH_Lloh407:
nop
bl Lpatch + (0xa5a4 - PATCH_BASE)
mov	x1, x0
mov	x0, x22
bl Lpatch + (0xa5d4 - PATCH_BASE)
cbz	x0, LFQH_LBB23_14
mov	x21, x0
mov	w24, #0
LFQH_Lloh408:
adr x23, LFQH_l_.str.20
LFQH_Lloh409:
nop
LFQH_LBB23_2:
cmp	x0, x20
b.eq	LFQH_LBB23_5
mov	x1, x23
bl	LFQH_Get
cbz	x0, LFQH_LBB23_14
cmp	w24, #7
add	w24, w24, #1
b.lo	LFQH_LBB23_2
b	LFQH_LBB23_14
LFQH_LBB23_5:
LFQH_Lloh410:
adr x0, LFQH_l_.str.192
LFQH_Lloh411:
nop
bl Lpatch + (0xa5a4 - PATCH_BASE)
mov	x1, x0
mov	x0, x22
bl Lpatch + (0xa5d4 - PATCH_BASE)
mov.16b	v8, v0
mov.16b	v9, v1
mov.16b	v10, v2
mov.16b	v11, v3
LFQH_Lloh412:
adr x0, LFQH_l_.str.241
LFQH_Lloh413:
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
b.hi	LFQH_LBB23_14
fmov	x8, d3
ubfx	x8, x8, #52, #11
cmp	x8, #2046
b.hi	LFQH_LBB23_14
fcmp	d2, #0.0
b.le	LFQH_LBB23_14
fcmp	d3, #0.0
b.le	LFQH_LBB23_14
ldp	d6, d4, [x19]
ldp	d7, d16, [x19, #16]
fcmp	d0, d6
mov.16b	v5, v6
b.pl	LFQH_LBB23_11
str	d0, [x19]
mov.16b	v5, v0
LFQH_LBB23_11:
fadd	d7, d6, d7
fadd	d6, d4, d16
fcmp	d1, d4
b.pl	LFQH_LBB23_13
str	d1, [x19, #8]
mov.16b	v4, v1
LFQH_LBB23_13:
fadd	d0, d0, d2
fcmp	d0, d7
fcsel	d0, d0, d7, gt
fadd	d1, d1, d3
fcmp	d1, d6
fcsel	d1, d1, d6, gt
fsub	d0, d0, d5
fsub	d1, d1, d4
stp	d0, d1, [x19, #16]
LFQH_LBB23_14:
ldp	x29, x30, [sp, #80]
ldp	x20, x19, [sp, #64]
ldp	x22, x21, [sp, #48]
ldp	x24, x23, [sp, #32]
ldp	d9, d8, [sp, #16]
ldp	d11, d10, [sp], #96
ret
.cfi_endproc
.p2align	2
LFQH_TrackReaderLabel:
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
bl Lpatch + (0xa628 - PATCH_BASE)
cmp	x0, x19
b.eq	LFQH_LBB24_4
mov	x22, x0
cbz	x0, LFQH_LBB24_3
LFQH_Lloh414:
adr x1, LFQH_IconGlassKey
LFQH_Lloh415:
nop
mov	x0, x22
bl Lpatch + (0xa628 - PATCH_BASE)
mov	x1, x0
mov	x0, x22
bl	LFQH_RestoreIcon
LFQH_LBB24_3:
mov	x0, x21
mov	x1, x20
mov	x2, x19
mov	w3, #1
ldp	x29, x30, [sp, #32]
ldp	x20, x19, [sp, #16]
ldp	x22, x21, [sp], #48
b Lpatch + (0xa634 - PATCH_BASE)
LFQH_LBB24_4:
ldp	x29, x30, [sp, #32]
ldp	x20, x19, [sp, #16]
ldp	x22, x21, [sp], #48
ret
.cfi_endproc
.p2align	2
LFQH_ReaderDownloadLabelKey:
.cfi_startproc
ret
.cfi_endproc
.p2align	2
LFQH_ReaderShelfLabelKey:
.cfi_startproc
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
cbz	w0, LFQH_LBB27_2
LFQH_Lloh416:
adr x0, LFQH_l_.str.24
LFQH_Lloh417:
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
LFQH_Lloh418:
adr x0, LFQH_l_.str.242
LFQH_Lloh419:
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
b.ls	LFQH_LBB27_3
LFQH_LBB27_2:
ldp	x29, x30, [sp, #128]
ldp	x20, x19, [sp, #112]
ldp	x22, x21, [sp, #96]
ldp	d9, d8, [sp, #80]
ldp	d11, d10, [sp, #64]
ldp	d13, d12, [sp, #48]
ldp	d15, d14, [sp, #32]
add	sp, sp, #144
ret
LFQH_LBB27_3:
fmov	x8, d9
ubfx	x8, x8, #52, #11
cmp	x8, #2046
b.hi	LFQH_LBB27_2
fcmp	d13, #0.0
b.le	LFQH_LBB27_2
fcmp	d9, #0.0
b.le	LFQH_LBB27_2
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
b.hi	LFQH_LBB27_2
stp	d3, d2, [sp]
LFQH_Lloh420:
adr x1, LFQH_HitInsetsKey
LFQH_Lloh421:
nop
mov	x0, x19
bl Lpatch + (0xa628 - PATCH_BASE)
mov	x21, x0
LFQH_Lloh422:
adr x1, LFQH_AppliedHitInsetsKey
LFQH_Lloh423:
nop
mov	x0, x19
bl Lpatch + (0xa628 - PATCH_BASE)
mov	x20, x0
cbz	x21, LFQH_LBB27_13
cbz	x20, LFQH_LBB27_13
LFQH_Lloh424:
adr x0, LFQH_l_.str.224
LFQH_Lloh425:
nop
bl Lpatch + (0xa5a4 - PATCH_BASE)
mov	x1, x0
mov	x0, x20
bl Lpatch + (0xa5d4 - PATCH_BASE)
fcmp	d14, d0
b.ne	LFQH_LBB27_13
fcmp	d15, d1
b.ne	LFQH_LBB27_13
ldr	d0, [sp, #8]
fcmp	d0, d2
b.ne	LFQH_LBB27_13
ldr	d0, [sp]
fcmp	d0, d3
b.eq	LFQH_LBB27_14
LFQH_LBB27_13:
LFQH_Lloh426:
adr x0, LFQH_l_.str.225
LFQH_Lloh427:
nop
bl Lpatch + (0xa5b0 - PATCH_BASE)
mov	x21, x0
LFQH_Lloh428:
adr x0, LFQH_l_.str.226
LFQH_Lloh429:
nop
bl Lpatch + (0xa5a4 - PATCH_BASE)
mov	x1, x0
mov	x0, x21
mov.16b	v0, v14
mov.16b	v1, v15
ldp	d3, d2, [sp]
bl Lpatch + (0xa5d4 - PATCH_BASE)
mov	x21, x0
LFQH_Lloh430:
adr x1, LFQH_HitInsetsKey
LFQH_Lloh431:
nop
mov	x0, x19
mov	x2, x21
mov	w3, #1
bl Lpatch + (0xa634 - PATCH_BASE)
LFQH_LBB27_14:
LFQH_Lloh432:
adr x0, LFQH_l_.str.224
LFQH_Lloh433:
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
b.eq	LFQH_LBB27_16
LFQH_Lloh434:
adr x0, LFQH_l_.str.243
LFQH_Lloh435:
nop
bl Lpatch + (0xa5a4 - PATCH_BASE)
mov	x1, x0
mov	x0, x19
mov.16b	v0, v8
mov.16b	v1, v9
mov.16b	v2, v10
mov.16b	v3, v11
bl Lpatch + (0xa5d4 - PATCH_BASE)
LFQH_LBB27_16:
cbz	x20, LFQH_LBB27_18
LFQH_Lloh436:
adr x0, LFQH_l_.str.224
LFQH_Lloh437:
nop
bl Lpatch + (0xa5a4 - PATCH_BASE)
mov	x1, x0
mov	x0, x20
bl Lpatch + (0xa5d4 - PATCH_BASE)
fcmp	d8, d0
fccmp	d9, d1, #0, eq
fccmp	d10, d2, #0, eq
fccmp	d11, d3, #0, eq
b.eq	LFQH_LBB27_2
LFQH_LBB27_18:
LFQH_Lloh438:
adr x0, LFQH_l_.str.225
LFQH_Lloh439:
nop
bl Lpatch + (0xa5b0 - PATCH_BASE)
mov	x20, x0
LFQH_Lloh440:
adr x0, LFQH_l_.str.226
LFQH_Lloh441:
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
LFQH_Lloh442:
adr x1, LFQH_AppliedHitInsetsKey
LFQH_Lloh443:
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
LFQH_Lloh444:
adr x1, LFQH_HitInsetsKey
LFQH_Lloh445:
nop
bl Lpatch + (0xa628 - PATCH_BASE)
mov	x20, x0
LFQH_Lloh446:
adr x1, LFQH_AppliedHitInsetsKey
LFQH_Lloh447:
nop
mov	x0, x19
bl Lpatch + (0xa628 - PATCH_BASE)
cmp	x20, #0
ccmp	x0, #0, #4, ne
b.eq	LFQH_LBB28_3
mov	x21, x0
LFQH_Lloh448:
adr x0, LFQH_l_.str.242
LFQH_Lloh449:
nop
bl Lpatch + (0xa5a4 - PATCH_BASE)
mov	x1, x0
mov	x0, x19
bl Lpatch + (0xa5d4 - PATCH_BASE)
mov.16b	v8, v0
mov.16b	v9, v1
mov.16b	v10, v2
mov.16b	v11, v3
LFQH_Lloh450:
adr x0, LFQH_l_.str.224
LFQH_Lloh451:
nop
bl Lpatch + (0xa5a4 - PATCH_BASE)
mov	x1, x0
mov	x0, x21
bl Lpatch + (0xa5d4 - PATCH_BASE)
fcmp	d8, d0
fccmp	d9, d1, #0, eq
fccmp	d10, d2, #0, eq
fccmp	d11, d3, #0, eq
b.ne	LFQH_LBB28_3
LFQH_Lloh452:
adr x0, LFQH_l_.str.224
LFQH_Lloh453:
nop
bl Lpatch + (0xa5a4 - PATCH_BASE)
mov	x1, x0
mov	x0, x20
bl Lpatch + (0xa5d4 - PATCH_BASE)
mov.16b	v8, v0
mov.16b	v9, v1
mov.16b	v10, v2
mov.16b	v11, v3
LFQH_Lloh454:
adr x0, LFQH_l_.str.243
LFQH_Lloh455:
nop
bl Lpatch + (0xa5a4 - PATCH_BASE)
mov	x1, x0
mov	x0, x19
mov.16b	v0, v8
mov.16b	v1, v9
mov.16b	v2, v10
mov.16b	v3, v11
bl Lpatch + (0xa5d4 - PATCH_BASE)
LFQH_LBB28_3:
LFQH_Lloh456:
adr x1, LFQH_HitInsetsKey
LFQH_Lloh457:
nop
mov	x0, x19
mov	x2, #0
mov	w3, #1
bl Lpatch + (0xa634 - PATCH_BASE)
LFQH_Lloh458:
adr x1, LFQH_AppliedHitInsetsKey
LFQH_Lloh459:
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
LFQH_Lloh460:
adr x1, LFQH_OwnerBusyKey
LFQH_Lloh461:
nop
bl Lpatch + (0xa628 - PATCH_BASE)
cbz	x0, LFQH_LBB29_2
ldp	x29, x30, [sp, #48]
ldp	x20, x19, [sp, #32]
ldp	x22, x21, [sp, #16]
ldp	x24, x23, [sp], #64
ret
LFQH_LBB29_2:
LFQH_Lloh462:
adr x1, LFQH_OwnerBusyKey
LFQH_Lloh463:
nop
mov	x0, x19
mov	x2, x19
mov	x3, #0
bl Lpatch + (0xa634 - PATCH_BASE)
LFQH_Lloh464:
adr x1, LFQH_l_.str.37
LFQH_Lloh465:
nop
mov	x0, x19
bl	LFQH_Get
mov	x20, x0
LFQH_Lloh466:
adr x1, LFQH_l_.str.38
LFQH_Lloh467:
nop
mov	x0, x19
bl	LFQH_Get
mov	x21, x0
LFQH_Lloh468:
adr x1, LFQH_l_.str.39
LFQH_Lloh469:
nop
mov	x0, x19
bl	LFQH_Get
mov	x22, x0
LFQH_Lloh470:
adr x23, LFQH_ShelfRoleKey
LFQH_Lloh471:
nop
mov	x0, x20
mov	x1, x23
bl Lpatch + (0xa628 - PATCH_BASE)
mov	x24, x0
mov	x0, x21
mov	x1, x23
bl Lpatch + (0xa628 - PATCH_BASE)
mov	x23, x0
cbz	x20, LFQH_LBB29_6
cbz	x24, LFQH_LBB29_5
LFQH_Lloh472:
adr x0, LFQH_l_.str.40
LFQH_Lloh473:
nop
bl Lpatch + (0xa5a4 - PATCH_BASE)
mov	x1, x0
mov	x0, x24
bl Lpatch + (0xa5d4 - PATCH_BASE)
cbnz	w0, LFQH_LBB29_6
LFQH_LBB29_5:
LFQH_Lloh474:
adr x0, LFQH_l_.str.205
LFQH_Lloh475:
nop
bl Lpatch + (0xa5b0 - PATCH_BASE)
mov	x24, x0
LFQH_Lloh476:
adr x0, LFQH_l_.str.271
LFQH_Lloh477:
nop
bl Lpatch + (0xa5a4 - PATCH_BASE)
mov	x1, x0
mov	x0, x24
mov	w2, #1
bl Lpatch + (0xa5d4 - PATCH_BASE)
mov	x2, x0
LFQH_Lloh478:
adr x1, LFQH_ShelfRoleKey
LFQH_Lloh479:
nop
mov	x0, x20
mov	w3, #1
bl Lpatch + (0xa634 - PATCH_BASE)
LFQH_LBB29_6:
cbz	x21, LFQH_LBB29_10
cbz	x23, LFQH_LBB29_9
LFQH_Lloh480:
adr x0, LFQH_l_.str.40
LFQH_Lloh481:
nop
bl Lpatch + (0xa5a4 - PATCH_BASE)
mov	x1, x0
mov	x0, x23
bl Lpatch + (0xa5d4 - PATCH_BASE)
cbz	w0, LFQH_LBB29_10
LFQH_LBB29_9:
LFQH_Lloh482:
adr x0, LFQH_l_.str.205
LFQH_Lloh483:
nop
bl Lpatch + (0xa5b0 - PATCH_BASE)
mov	x23, x0
LFQH_Lloh484:
adr x0, LFQH_l_.str.271
LFQH_Lloh485:
nop
bl Lpatch + (0xa5a4 - PATCH_BASE)
mov	x1, x0
mov	x0, x23
mov	w2, #0
bl Lpatch + (0xa5d4 - PATCH_BASE)
mov	x2, x0
LFQH_Lloh486:
adr x1, LFQH_ShelfRoleKey
LFQH_Lloh487:
nop
mov	x0, x21
mov	w3, #1
bl Lpatch + (0xa634 - PATCH_BASE)
LFQH_LBB29_10:
mov	x0, x20
mov	w1, #9
bl	LFQH_Icon
mov	x0, x21
mov	w1, #10
bl	LFQH_Icon
LFQH_Lloh488:
adr x1, LFQH_l_.str.23
LFQH_Lloh489:
nop
mov	x0, x22
bl	LFQH_Kind
cbz	w0, LFQH_LBB29_12
mov	x0, x19
mov	x1, x22
bl	LFQH_ShelfEditPlacement
mov	x3, x0
mov	x0, x22
mov	x1, x20
mov	x2, x21
bl	LFQH_ShelfTopHit
LFQH_LBB29_12:
LFQH_Lloh490:
adr x1, LFQH_OwnerBusyKey
LFQH_Lloh491:
nop
mov	x0, x19
mov	x2, #0
mov	x3, #0
ldp	x29, x30, [sp, #48]
ldp	x20, x19, [sp, #32]
ldp	x22, x21, [sp, #16]
ldp	x24, x23, [sp], #64
b Lpatch + (0xa634 - PATCH_BASE)
.cfi_endproc
.p2align	2
LFQH_ShelfRoleKey:
.cfi_startproc
ret
.cfi_endproc
.p2align	2
LFQH_ShelfTopHit:
.cfi_startproc
sub	sp, sp, #96
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
mov	x20, x3
mov	x22, x2
mov	x21, x1
mov	x19, x0
LFQH_Lloh492:
adr x0, LFQH_l_.str.24
LFQH_Lloh493:
nop
bl Lpatch + (0xa5a4 - PATCH_BASE)
mov	x1, x0
mov	x0, x19
bl Lpatch + (0xa5d4 - PATCH_BASE)
stp	d0, d1, [sp]
stp	d2, d3, [sp, #16]
LFQH_Lloh494:
adr x23, LFQH_IconGlassKey
LFQH_Lloh495:
nop
mov	x0, x21
mov	x1, x23
bl Lpatch + (0xa628 - PATCH_BASE)
mov	x21, x0
mov	x0, x22
mov	x1, x23
bl Lpatch + (0xa628 - PATCH_BASE)
mov	x22, x0
mov	x2, sp
mov	x0, x21
mov	x1, x19
bl	LFQH_IncludeMaterial
mov	x2, sp
mov	x0, x22
mov	x1, x19
bl	LFQH_IncludeMaterial
mov	x2, sp
mov	x0, x20
mov	x1, x19
bl	LFQH_IncludeMaterial
cbnz	x20, LFQH_LBB31_4
cbnz	x21, LFQH_LBB31_4
cbnz	x22, LFQH_LBB31_4
mov	x0, x19
ldp	x29, x30, [sp, #80]
ldp	x20, x19, [sp, #64]
ldp	x22, x21, [sp, #48]
ldp	x24, x23, [sp, #32]
add	sp, sp, #96
b	LFQH_RestoreHit
LFQH_LBB31_4:
ldp	d0, d1, [sp]
ldp	d2, d3, [sp, #16]
mov	x0, x19
ldp	x29, x30, [sp, #80]
ldp	x20, x19, [sp, #64]
ldp	x22, x21, [sp, #48]
ldp	x24, x23, [sp, #32]
add	sp, sp, #96
b	LFQH_EnsureHit
.cfi_endproc
.p2align	2
LFQH_ShelfEditPlacement:
.cfi_startproc
sub	sp, sp, #144
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
mov	x22, x1
mov	x19, x0
LFQH_Lloh496:
adr x1, LFQH_l_.str.290
LFQH_Lloh497:
nop
bl	LFQH_Get
mov	x28, x0
LFQH_Lloh498:
adr x1, LFQH_l_.str.291
LFQH_Lloh499:
nop
bl	LFQH_Get
mov	x23, x0
LFQH_Lloh500:
adr x1, LFQH_ShelfEditHeaderKey
LFQH_Lloh501:
nop
mov	x0, x22
bl Lpatch + (0xa628 - PATCH_BASE)
mov	x24, x0
LFQH_Lloh502:
adr x1, LFQH_l_.str.21
LFQH_Lloh503:
nop
mov	x0, x23
bl	LFQH_Kind
fmov	d8, xzr
cbz	w0, LFQH_LBB32_3
LFQH_Lloh504:
adr x0, LFQH_l_.str.292
LFQH_Lloh505:
nop
bl Lpatch + (0xa5a4 - PATCH_BASE)
mov	x1, x0
mov	x0, x23
bl Lpatch + (0xa5d4 - PATCH_BASE)
cbnz	w0, LFQH_LBB32_3
LFQH_Lloh506:
adr x0, LFQH_l_.str.230
LFQH_Lloh507:
nop
bl Lpatch + (0xa5a4 - PATCH_BASE)
mov	x1, x0
mov	x0, x23
bl Lpatch + (0xa5d4 - PATCH_BASE)
cbz	w0, LFQH_LBB32_26
LFQH_LBB32_3:
mov	x25, #0
mov	x21, #0
LFQH_LBB32_4:
fmov	d9, xzr
fmov	d10, xzr
fmov	d11, xzr
LFQH_LBB32_5:
fmov	x8, d11
fmov	x9, d10
fmov	x10, d9
ubfx	x8, x8, #52, #11
ubfx	x9, x9, #52, #11
ubfx	x10, x10, #52, #11
fmov	x11, d8
ubfx	x11, x11, #52, #11
cmp	x11, #2047
cset	w11, lo
cmp	x10, #2046
mov	w10, #2046
ccmp	x9, x10, #2, ls
ccmp	x8, x10, #2, ls
csel	w8, wzr, w11, hi
fcmp	d9, #0.0
csel	w8, wzr, w8, le
fcmp	d8, #0.0
csel	w20, wzr, w8, le
cmp	x24, x23
csel	w8, wzr, w20, ne
cbz	x24, LFQH_LBB32_10
tbnz	w8, #0, LFQH_LBB32_10
LFQH_Lloh508:
adr x1, LFQH_l_.str.293
LFQH_Lloh509:
nop
mov	x0, x24
bl	LFQH_Get
mov	x26, x0
LFQH_Lloh510:
adr x1, LFQH_l_.str.20
LFQH_Lloh511:
nop
bl	LFQH_Get
cmp	x0, x22
b.ne	LFQH_LBB32_9
LFQH_Lloh512:
adr x1, LFQH_l_.str.294
LFQH_Lloh513:
nop
mov	x0, x24
bl	LFQH_Get
mov	x27, x0
LFQH_Lloh514:
adr x0, LFQH_l_.str.82
LFQH_Lloh515:
nop
bl Lpatch + (0xa5a4 - PATCH_BASE)
mov	x1, x0
mov	x0, x27
mov	x2, x26
bl Lpatch + (0xa5d4 - PATCH_BASE)
LFQH_Lloh516:
adr x0, LFQH_l_.str.295
LFQH_Lloh517:
nop
bl Lpatch + (0xa5a4 - PATCH_BASE)
mov	x1, x0
mov	x0, x24
bl Lpatch + (0xa5d4 - PATCH_BASE)
LFQH_LBB32_9:
LFQH_Lloh518:
adr x1, LFQH_ShelfEditHeaderKey
LFQH_Lloh519:
nop
mov	x0, x22
mov	x2, #0
mov	w3, #1
bl Lpatch + (0xa634 - PATCH_BASE)
LFQH_LBB32_10:
cbz	w20, LFQH_LBB32_22
LFQH_Lloh520:
adr x1, LFQH_l_.str.20
LFQH_Lloh521:
nop
mov	x0, x21
bl	LFQH_Get
cmp	x0, x22
b.eq	LFQH_LBB32_13
LFQH_Lloh522:
adr x0, LFQH_l_.str.82
LFQH_Lloh523:
nop
bl Lpatch + (0xa5a4 - PATCH_BASE)
mov	x1, x0
mov	x0, x22
mov	x2, x21
bl Lpatch + (0xa5d4 - PATCH_BASE)
LFQH_LBB32_13:
LFQH_Lloh524:
adr x0, LFQH_l_.str.192
LFQH_Lloh525:
nop
bl Lpatch + (0xa5a4 - PATCH_BASE)
mov	x1, x0
mov	x0, x21
bl Lpatch + (0xa5d4 - PATCH_BASE)
fcmp	d0, d11
b.ne	LFQH_LBB32_17
fcmp	d1, d10
b.ne	LFQH_LBB32_17
fcmp	d2, d9
b.ne	LFQH_LBB32_17
fcmp	d3, d8
b.eq	LFQH_LBB32_18
LFQH_LBB32_17:
LFQH_Lloh526:
adr x0, LFQH_l_.str.71
LFQH_Lloh527:
nop
bl Lpatch + (0xa5a4 - PATCH_BASE)
mov	x1, x0
mov	x0, x21
mov.16b	v0, v11
mov.16b	v1, v10
mov.16b	v2, v9
mov.16b	v3, v8
bl Lpatch + (0xa5d4 - PATCH_BASE)
LFQH_LBB32_18:
mov	x0, x21
bl	LFQH_ShelfActionGlass
cmp	x24, x23
b.eq	LFQH_LBB32_20
LFQH_Lloh528:
adr x1, LFQH_ShelfEditHeaderKey
LFQH_Lloh529:
nop
mov	x0, x22
mov	x2, x23
mov	w3, #1
bl Lpatch + (0xa634 - PATCH_BASE)
LFQH_LBB32_20:
LFQH_Lloh530:
adr x0, LFQH_l_.str.296
LFQH_Lloh531:
nop
bl Lpatch + (0xa5a4 - PATCH_BASE)
mov	x1, x0
mov	x0, x23
bl Lpatch + (0xa5d4 - PATCH_BASE)
cbnz	w0, LFQH_LBB32_22
LFQH_Lloh532:
adr x0, LFQH_l_.str.230
LFQH_Lloh533:
nop
bl Lpatch + (0xa5a4 - PATCH_BASE)
mov	x1, x0
mov	x0, x25
bl Lpatch + (0xa5d4 - PATCH_BASE)
cbz	w0, LFQH_LBB32_30
LFQH_LBB32_22:
mov	x24, #0
LFQH_LBB32_23:
LFQH_Lloh534:
adr x1, LFQH_ShelfCompactKey
LFQH_Lloh535:
nop
mov	x0, x19
bl Lpatch + (0xa628 - PATCH_BASE)
cmp	x0, x24
b.eq	LFQH_LBB32_25
LFQH_Lloh536:
adr x1, LFQH_ShelfCompactKey
LFQH_Lloh537:
nop
mov	x0, x19
mov	x2, x24
mov	w3, #1
bl Lpatch + (0xa634 - PATCH_BASE)
LFQH_Lloh538:
adr x0, LFQH_l_.str.297
LFQH_Lloh539:
nop
bl Lpatch + (0xa5a4 - PATCH_BASE)
mov	x1, x0
mov	x0, x28
bl Lpatch + (0xa5d4 - PATCH_BASE)
LFQH_Lloh540:
adr x1, LFQH_l_.str.298
LFQH_Lloh541:
nop
mov	x0, x19
bl	LFQH_Get
LFQH_Lloh542:
adr x1, LFQH_l_.str.299
LFQH_Lloh543:
nop
bl	LFQH_Get
mov	x19, x0
LFQH_Lloh544:
adr x0, LFQH_l_.str.300
LFQH_Lloh545:
nop
bl Lpatch + (0xa5a4 - PATCH_BASE)
mov	x1, x0
mov	x0, x19
bl Lpatch + (0xa5d4 - PATCH_BASE)
LFQH_LBB32_25:
cmp	w20, #0
csel	x0, x21, xzr, ne
ldp	x29, x30, [sp, #128]
ldp	x20, x19, [sp, #112]
ldp	x22, x21, [sp, #96]
ldp	x24, x23, [sp, #80]
ldp	x26, x25, [sp, #64]
ldp	x28, x27, [sp, #48]
ldp	d9, d8, [sp, #32]
ldp	d11, d10, [sp, #16]
add	sp, sp, #144
ret
LFQH_LBB32_26:
LFQH_Lloh546:
adr x1, LFQH_l_.str.293
LFQH_Lloh547:
nop
mov	x0, x23
bl	LFQH_Get
mov	x21, x0
LFQH_Lloh548:
adr x1, LFQH_l_.str.294
LFQH_Lloh549:
nop
mov	x0, x23
bl	LFQH_Get
mov	x25, x0
LFQH_Lloh550:
adr x1, LFQH_l_.str.20
LFQH_Lloh551:
nop
mov	x0, x21
bl	LFQH_Get
cbz	x25, LFQH_LBB32_4
cmp	x0, x22
ccmp	x0, x25, #4, ne
b.ne	LFQH_LBB32_4
LFQH_Lloh552:
adr x0, LFQH_l_.str.230
LFQH_Lloh553:
nop
bl Lpatch + (0xa5a4 - PATCH_BASE)
mov	x1, x0
mov	x0, x21
bl Lpatch + (0xa5d4 - PATCH_BASE)
cbnz	w0, LFQH_LBB32_4
mov	x0, x19
mov	x1, x22
mov	x2, x21
bl	LFQH_ShelfEditFrame
mov.16b	v11, v0
mov.16b	v10, v1
mov.16b	v9, v2
mov.16b	v8, v3
b	LFQH_LBB32_5
LFQH_LBB32_30:
LFQH_Lloh554:
adr x1, LFQH_l_.str.217
LFQH_Lloh555:
nop
mov	x0, x25
bl	LFQH_Get
mov	x22, x0
LFQH_Lloh556:
adr x0, LFQH_l_.str.34
LFQH_Lloh557:
nop
bl Lpatch + (0xa5a4 - PATCH_BASE)
mov	x1, x0
mov	x0, x22
bl Lpatch + (0xa5d4 - PATCH_BASE)
mov	x24, x28
cbz	x0, LFQH_LBB32_23
mov	x23, x0
str	x28, [sp, #8]
mov	x24, #0
LFQH_Lloh558:
adr x25, LFQH_l_.str.264
LFQH_Lloh559:
nop
LFQH_Lloh560:
adr x26, LFQH_l_.str.230
LFQH_Lloh561:
nop
mov	w27, #2046
LFQH_LBB32_32:
mov	x0, x25
bl Lpatch + (0xa5a4 - PATCH_BASE)
mov	x1, x0
mov	x0, x22
mov	x2, x24
bl Lpatch + (0xa5d4 - PATCH_BASE)
mov	x28, x0
mov	x0, x26
bl Lpatch + (0xa5a4 - PATCH_BASE)
mov	x1, x0
mov	x0, x28
bl Lpatch + (0xa5d4 - PATCH_BASE)
cbnz	w0, LFQH_LBB32_37
LFQH_Lloh562:
adr x0, LFQH_l_.str.192
LFQH_Lloh563:
nop
bl Lpatch + (0xa5a4 - PATCH_BASE)
mov	x1, x0
mov	x0, x28
bl Lpatch + (0xa5d4 - PATCH_BASE)
fmov	x8, d2
fmov	x9, d1
fmov	x10, d0
ubfx	x10, x10, #52, #11
ubfx	x9, x9, #52, #11
ubfx	x8, x8, #52, #11
cmp	x8, #2046
ccmp	x9, x27, #2, ls
ccmp	x10, x27, #2, ls
b.hi	LFQH_LBB32_37
fmov	x8, d3
ubfx	x8, x8, #52, #11
cmp	x8, #2046
b.hi	LFQH_LBB32_37
fcmp	d2, #0.0
b.le	LFQH_LBB32_37
fcmp	d3, #0.0
b.gt	LFQH_LBB32_39
LFQH_LBB32_37:
add	x24, x24, #1
cmp	x23, x24
b.ne	LFQH_LBB32_32
ldr	x28, [sp, #8]
mov	x24, x28
b	LFQH_LBB32_23
LFQH_LBB32_39:
mov	x24, #0
ldr	x28, [sp, #8]
b	LFQH_LBB32_23
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
LFQH_Lloh564:
adr x1, LFQH_l_.str.41
LFQH_Lloh565:
nop
bl	LFQH_Kind
cbz	w0, LFQH_LBB33_2
LFQH_Lloh566:
adr x1, LFQH_l_.str.20
LFQH_Lloh567:
nop
mov	x0, x19
bl	LFQH_Get
LFQH_Lloh568:
adr x1, LFQH_l_.str.42
LFQH_Lloh569:
nop
bl	LFQH_Kind
LFQH_LBB33_2:
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
LFQH_Lloh570:
adr x0, LFQH_l_.str.24
LFQH_Lloh571:
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
b.le	LFQH_LBB34_2
fmov	d4, #6.00000000
fadd	d0, d0, d4
fmov	d4, #-12.00000000
fadd	d2, d2, d4
fmov	d4, #4.00000000
fadd	d1, d1, d4
fmov	d4, #-8.00000000
fadd	d3, d3, d4
LFQH_LBB34_2:
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
LFQH_Lloh572:
adr x1, LFQH_l_.str.43
LFQH_Lloh573:
nop
bl	LFQH_Kind
cbz	w0, LFQH_LBB35_12
mov	x0, x19
mov	w1, #2
bl	LFQH_ListenCaption
mov	x21, x0
LFQH_Lloh574:
adr x1, LFQH_ListenLabelKey
LFQH_Lloh575:
nop
mov	x0, x19
bl Lpatch + (0xa628 - PATCH_BASE)
mov	x22, x0
bl	LFQH_Enabled
cbz	w0, LFQH_LBB35_13
cbz	x21, LFQH_LBB35_13
bl	LFQH_FQHGlassAvailable
tbz	w0, #0, LFQH_LBB35_13
mov	x0, x19
bl	LFQH_FQHApply
LFQH_Lloh576:
adr x1, LFQH_SurfaceKey
LFQH_Lloh577:
nop
mov	x0, x19
bl Lpatch + (0xa628 - PATCH_BASE)
cbz	x0, LFQH_LBB35_12
mov	x20, x0
cmp	x22, x21
b.eq	LFQH_LBB35_9
cbz	x22, LFQH_LBB35_8
LFQH_Lloh578:
adr x0, LFQH_l_.str.44
LFQH_Lloh579:
nop
bl Lpatch + (0xa5a4 - PATCH_BASE)
mov	x23, x0
LFQH_Lloh580:
adr x1, LFQH_ListenColorKey
LFQH_Lloh581:
nop
mov	x0, x19
bl Lpatch + (0xa628 - PATCH_BASE)
mov	x2, x0
mov	x0, x22
mov	x1, x23
bl Lpatch + (0xa5d4 - PATCH_BASE)
LFQH_LBB35_8:
LFQH_Lloh582:
adr x1, LFQH_ListenLabelKey
LFQH_Lloh583:
nop
mov	x0, x19
mov	x2, x21
mov	w3, #1
bl Lpatch + (0xa634 - PATCH_BASE)
LFQH_Lloh584:
adr x1, LFQH_l_.str.45
LFQH_Lloh585:
nop
mov	x0, x21
bl	LFQH_Get
mov	x2, x0
LFQH_Lloh586:
adr x1, LFQH_ListenColorKey
LFQH_Lloh587:
nop
mov	x0, x19
mov	w3, #1
bl Lpatch + (0xa634 - PATCH_BASE)
LFQH_LBB35_9:
LFQH_Lloh588:
adr x0, LFQH_l_.str.46
LFQH_Lloh589:
nop
bl Lpatch + (0xa5b0 - PATCH_BASE)
mov	x22, x0
LFQH_Lloh590:
adr x0, LFQH_l_.str.47
LFQH_Lloh591:
nop
bl Lpatch + (0xa5a4 - PATCH_BASE)
mov	x1, x0
mov	x0, x22
bl Lpatch + (0xa5d4 - PATCH_BASE)
mov	x22, x0
LFQH_Lloh592:
adr x1, LFQH_l_.str.45
LFQH_Lloh593:
nop
mov	x0, x21
bl	LFQH_Get
mov	x23, x0
LFQH_Lloh594:
adr x0, LFQH_l_.str.48
LFQH_Lloh595:
nop
bl Lpatch + (0xa5a4 - PATCH_BASE)
mov	x1, x0
mov	x0, x23
mov	x2, x22
bl Lpatch + (0xa5d4 - PATCH_BASE)
cbnz	w0, LFQH_LBB35_11
LFQH_Lloh596:
adr x0, LFQH_l_.str.44
LFQH_Lloh597:
nop
bl Lpatch + (0xa5a4 - PATCH_BASE)
mov	x1, x0
mov	x0, x21
mov	x2, x22
bl Lpatch + (0xa5d4 - PATCH_BASE)
LFQH_LBB35_11:
LFQH_Lloh598:
adr x1, LFQH_ListenTintKey
LFQH_Lloh599:
nop
mov	x0, x19
bl Lpatch + (0xa628 - PATCH_BASE)
cbz	x0, LFQH_LBB35_16
LFQH_LBB35_12:
ldp	x29, x30, [sp, #48]
ldp	x20, x19, [sp, #32]
ldp	x22, x21, [sp, #16]
ldp	x24, x23, [sp], #64
ret
LFQH_LBB35_13:
cbz	x22, LFQH_LBB35_15
LFQH_Lloh600:
adr x0, LFQH_l_.str.44
LFQH_Lloh601:
nop
bl Lpatch + (0xa5a4 - PATCH_BASE)
mov	x20, x0
LFQH_Lloh602:
adr x1, LFQH_ListenColorKey
LFQH_Lloh603:
nop
mov	x0, x19
bl Lpatch + (0xa628 - PATCH_BASE)
mov	x2, x0
mov	x0, x22
mov	x1, x20
bl Lpatch + (0xa5d4 - PATCH_BASE)
LFQH_LBB35_15:
LFQH_Lloh604:
adr x1, LFQH_ListenLabelKey
LFQH_Lloh605:
nop
mov	x0, x19
mov	x2, #0
mov	w3, #1
bl Lpatch + (0xa634 - PATCH_BASE)
LFQH_Lloh606:
adr x1, LFQH_ListenColorKey
LFQH_Lloh607:
nop
mov	x0, x19
mov	x2, #0
mov	w3, #1
bl Lpatch + (0xa634 - PATCH_BASE)
LFQH_Lloh608:
adr x1, LFQH_ListenTintKey
LFQH_Lloh609:
nop
mov	x0, x19
mov	x2, #0
mov	w3, #1
bl Lpatch + (0xa634 - PATCH_BASE)
LFQH_Lloh610:
adr x1, LFQH_SurfaceKey
LFQH_Lloh611:
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
LFQH_LBB35_16:
LFQH_Lloh612:
adr x0, LFQH_l_.str.46
LFQH_Lloh613:
nop
bl Lpatch + (0xa5b0 - PATCH_BASE)
mov	x21, x0
LFQH_Lloh614:
adr x0, LFQH_l_.str.49
LFQH_Lloh615:
nop
bl Lpatch + (0xa5a4 - PATCH_BASE)
mov	x1, x0
mov	x0, x21
bl Lpatch + (0xa5d4 - PATCH_BASE)
mov	x21, x0
LFQH_Lloh616:
adr x0, LFQH_l_.str.50
LFQH_Lloh617:
nop
bl Lpatch + (0xa5a4 - PATCH_BASE)
mov	x1, x0
fmov	d0, #0.50000000
mov	x0, x21
bl Lpatch + (0xa5d4 - PATCH_BASE)
mov	x21, x0
LFQH_Lloh618:
adr x1, LFQH_l_.str.51
LFQH_Lloh619:
nop
mov	x0, x20
bl	LFQH_Get
mov	x22, x0
LFQH_Lloh620:
adr x0, LFQH_l_.str.52
LFQH_Lloh621:
nop
bl Lpatch + (0xa5a4 - PATCH_BASE)
mov	x1, x0
mov	x0, x22
bl Lpatch + (0xa5d4 - PATCH_BASE)
mov	x22, x0
LFQH_Lloh622:
adr x0, LFQH_l_.str.53
LFQH_Lloh623:
nop
bl Lpatch + (0xa5a4 - PATCH_BASE)
mov	x1, x0
mov	x0, x22
mov	x2, x21
bl Lpatch + (0xa5d4 - PATCH_BASE)
LFQH_Lloh624:
adr x0, LFQH_l_.str.54
LFQH_Lloh625:
nop
bl Lpatch + (0xa5a4 - PATCH_BASE)
mov	x1, x0
mov	x0, x20
mov	x2, x22
bl Lpatch + (0xa5d4 - PATCH_BASE)
LFQH_Lloh626:
adr x0, LFQH_l_.str.55
LFQH_Lloh627:
nop
bl Lpatch + (0xa5a4 - PATCH_BASE)
mov	x1, x0
mov	x0, x22
bl Lpatch + (0xa5d4 - PATCH_BASE)
LFQH_Lloh628:
adr x1, LFQH_ListenTintKey
LFQH_Lloh629:
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
LFQH_Lloh630:
adr x1, LFQH_l_.str.36
LFQH_Lloh631:
nop
bl	LFQH_Kind
cbz	w0, LFQH_LBB36_2
LFQH_Lloh632:
adr x1, LFQH_l_.str.272
LFQH_Lloh633:
nop
mov	x0, x20
bl	LFQH_Get
LFQH_Lloh634:
adr x1, LFQH_l_.str.273
LFQH_Lloh635:
nop
bl	LFQH_Equal
tbnz	w0, #0, LFQH_LBB36_5
LFQH_LBB36_2:
cbz	w19, LFQH_LBB36_4
LFQH_Lloh636:
adr x1, LFQH_l_.str.16
LFQH_Lloh637:
nop
mov	x0, x20
bl	LFQH_Kind
tbz	w0, #0, LFQH_LBB36_6
LFQH_LBB36_4:
mov	x20, #0
LFQH_LBB36_5:
mov	x0, x20
ldp	x29, x30, [sp, #48]
ldp	x20, x19, [sp, #32]
ldp	x22, x21, [sp, #16]
ldp	x24, x23, [sp], #64
ret
LFQH_LBB36_6:
LFQH_Lloh638:
adr x1, LFQH_l_.str.217
LFQH_Lloh639:
nop
mov	x0, x20
bl	LFQH_Get
mov	x21, x0
LFQH_Lloh640:
adr x0, LFQH_l_.str.34
LFQH_Lloh641:
nop
bl Lpatch + (0xa5a4 - PATCH_BASE)
mov	x1, x0
mov	x0, x21
bl Lpatch + (0xa5d4 - PATCH_BASE)
cmp	x0, #12
mov	w8, #12
csel	x24, x0, x8, lo
cbz	x0, LFQH_LBB36_4
mov	x22, #0
sub	w19, w19, #1
LFQH_Lloh642:
adr x23, LFQH_l_.str.264
LFQH_Lloh643:
nop
LFQH_LBB36_8:
mov	x0, x23
bl Lpatch + (0xa5a4 - PATCH_BASE)
mov	x1, x0
mov	x0, x21
mov	x2, x22
bl Lpatch + (0xa5d4 - PATCH_BASE)
mov	x1, x19
bl	LFQH_ListenCaption
cbnz	x0, LFQH_LBB36_10
add	x22, x22, #1
cmp	x24, x22
b.eq	LFQH_LBB36_4
b	LFQH_LBB36_8
LFQH_LBB36_10:
mov	x20, x0
b	LFQH_LBB36_5
.cfi_endproc
.p2align	2
LFQH_ListenLabelKey:
.cfi_startproc
ret
.cfi_endproc
.p2align	2
LFQH_Enabled:
.cfi_startproc
stp	x20, x19, [sp, #-32]!
stp	x29, x30, [sp, #16]
add	x29, sp, #16
.cfi_def_cfa w29, 16
.cfi_offset w30, -8
.cfi_offset w29, -16
.cfi_offset w19, -24
.cfi_offset w20, -32
LFQH_Lloh644:
adr x0, LFQH_l_.str.274
LFQH_Lloh645:
nop
bl Lpatch + (0xa5b0 - PATCH_BASE)
mov	x19, x0
LFQH_Lloh646:
adr x0, LFQH_l_.str.275
LFQH_Lloh647:
nop
bl Lpatch + (0xa5a4 - PATCH_BASE)
mov	x1, x0
mov	x0, x19
bl Lpatch + (0xa5d4 - PATCH_BASE)
mov	x19, x0
LFQH_Lloh648:
adr x1, LFQH_GlassPreferenceKey
LFQH_Lloh649:
nop
bl Lpatch + (0xa628 - PATCH_BASE)
mov	x20, x0
cbnz	x0, LFQH_LBB38_2
LFQH_Lloh650:
adr x0, LFQH_l_.str.182
LFQH_Lloh651:
nop
bl Lpatch + (0xa5b0 - PATCH_BASE)
mov	x20, x0
LFQH_Lloh652:
adr x0, LFQH_l_.str.183
LFQH_Lloh653:
nop
bl Lpatch + (0xa5a4 - PATCH_BASE)
mov	x1, x0
LFQH_Lloh654:
adr x2, LFQH_l_.str.276
LFQH_Lloh655:
nop
mov	x0, x20
bl Lpatch + (0xa5d4 - PATCH_BASE)
mov	x20, x0
LFQH_Lloh656:
adr x1, LFQH_GlassPreferenceKey
LFQH_Lloh657:
nop
mov	x0, x19
mov	x2, x20
mov	w3, #1
bl Lpatch + (0xa634 - PATCH_BASE)
LFQH_LBB38_2:
LFQH_Lloh658:
adr x0, LFQH_l_.str.277
LFQH_Lloh659:
nop
bl Lpatch + (0xa5a4 - PATCH_BASE)
mov	x1, x0
mov	x0, x19
mov	x2, x20
bl Lpatch + (0xa5d4 - PATCH_BASE)
cmp	x0, #0
cset	w0, eq
ldp	x29, x30, [sp, #16]
ldp	x20, x19, [sp], #32
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
cbz	x1, LFQH_LBB41_7
mov	x20, x1
LFQH_Lloh660:
adr x1, LFQH_ClipsKey
LFQH_Lloh661:
nop
mov	x0, x19
bl Lpatch + (0xa628 - PATCH_BASE)
cbnz	x0, LFQH_LBB41_3
LFQH_Lloh662:
adr x1, LFQH_HeaderClipsKey
LFQH_Lloh663:
nop
mov	x0, x19
bl Lpatch + (0xa628 - PATCH_BASE)
cbz	x0, LFQH_LBB41_6
LFQH_LBB41_3:
LFQH_Lloh664:
adr x0, LFQH_l_.str.46
LFQH_Lloh665:
nop
bl Lpatch + (0xa5b0 - PATCH_BASE)
mov	x21, x0
LFQH_Lloh666:
adr x0, LFQH_l_.str.73
LFQH_Lloh667:
nop
bl Lpatch + (0xa5a4 - PATCH_BASE)
mov	x1, x0
mov	x0, x21
bl Lpatch + (0xa5d4 - PATCH_BASE)
mov	x21, x0
LFQH_Lloh668:
adr x0, LFQH_l_.str.186
LFQH_Lloh669:
nop
bl Lpatch + (0xa5a4 - PATCH_BASE)
mov	x1, x0
mov	x0, x19
bl Lpatch + (0xa5d4 - PATCH_BASE)
cmp	x0, x21
b.eq	LFQH_LBB41_5
mov	x22, x0
LFQH_Lloh670:
adr x0, LFQH_l_.str.48
LFQH_Lloh671:
nop
bl Lpatch + (0xa5a4 - PATCH_BASE)
mov	x1, x0
mov	x0, x22
mov	x2, x21
bl Lpatch + (0xa5d4 - PATCH_BASE)
cbz	w0, LFQH_LBB41_6
LFQH_LBB41_5:
LFQH_Lloh672:
adr x0, LFQH_l_.str.72
LFQH_Lloh673:
nop
bl Lpatch + (0xa5a4 - PATCH_BASE)
mov	x21, x0
LFQH_Lloh674:
adr x1, LFQH_BackgroundKey
LFQH_Lloh675:
nop
mov	x0, x19
bl Lpatch + (0xa628 - PATCH_BASE)
mov	x2, x0
mov	x0, x19
mov	x1, x21
bl Lpatch + (0xa5d4 - PATCH_BASE)
LFQH_LBB41_6:
LFQH_Lloh676:
adr x0, LFQH_l_.str.240
LFQH_Lloh677:
nop
bl Lpatch + (0xa5a4 - PATCH_BASE)
mov	x1, x0
mov	x0, x20
bl Lpatch + (0xa5d4 - PATCH_BASE)
LFQH_Lloh678:
adr x1, LFQH_SurfaceKey
LFQH_Lloh679:
nop
mov	x0, x19
mov	x2, #0
mov	w3, #1
bl Lpatch + (0xa634 - PATCH_BASE)
LFQH_Lloh680:
adr x1, LFQH_BackgroundKey
LFQH_Lloh681:
nop
mov	x0, x19
mov	x2, #0
mov	w3, #1
bl Lpatch + (0xa634 - PATCH_BASE)
LFQH_LBB41_7:
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
cbz	x0, LFQH_LBB42_11
mov	x19, x0
mov	w25, #0
LFQH_Lloh682:
adr x20, LFQH_l_.str.185
LFQH_Lloh683:
nop
LFQH_Lloh684:
adr x21, LFQH_l_.str.56
LFQH_Lloh685:
nop
LFQH_Lloh686:
adr x22, LFQH_l_.str.58
LFQH_Lloh687:
nop
LFQH_Lloh688:
adr x23, LFQH_l_.str.20
LFQH_Lloh689:
nop
LFQH_LBB42_2:
mov	x0, x20
bl Lpatch + (0xa5a4 - PATCH_BASE)
mov	x24, x0
mov	x0, x21
bl Lpatch + (0xa5b0 - PATCH_BASE)
mov	x2, x0
mov	x0, x19
mov	x1, x24
bl Lpatch + (0xa5d4 - PATCH_BASE)
cbnz	w0, LFQH_LBB42_6
mov	x0, x20
bl Lpatch + (0xa5a4 - PATCH_BASE)
mov	x24, x0
mov	x0, x22
bl Lpatch + (0xa5b0 - PATCH_BASE)
mov	x2, x0
mov	x0, x19
mov	x1, x24
bl Lpatch + (0xa5d4 - PATCH_BASE)
cbnz	w0, LFQH_LBB42_9
mov	x0, x19
mov	x1, x23
bl	LFQH_Get
mov	x19, x0
mov	w0, #0
cbz	x19, LFQH_LBB42_11
cmp	w25, #3
add	w25, w25, #1
b.lo	LFQH_LBB42_2
b	LFQH_LBB42_11
LFQH_LBB42_6:
LFQH_Lloh690:
adr x1, LFQH_l_.str.20
LFQH_Lloh691:
nop
mov	x0, x19
bl	LFQH_Get
LFQH_Lloh692:
adr x1, LFQH_l_.str.57
LFQH_Lloh693:
nop
bl	LFQH_Kind
cbz	w0, LFQH_LBB42_11
mov	x0, x19
bl	LFQH_ReaderBottomType
sub	w8, w0, #4
cmn	w8, #3
b.hs	LFQH_LBB42_10
mov	w0, #0
b	LFQH_LBB42_11
LFQH_LBB42_9:
ldp	x29, x30, [sp, #64]
ldp	x20, x19, [sp, #48]
ldp	x22, x21, [sp, #32]
ldp	x24, x23, [sp, #16]
ldp	x26, x25, [sp], #80
b	LFQH_FQHGlassAvailable
LFQH_LBB42_10:
bl	LFQH_FQHGlassAvailable
LFQH_LBB42_11:
ldp	x29, x30, [sp, #64]
ldp	x20, x19, [sp, #48]
ldp	x22, x21, [sp, #32]
ldp	x24, x23, [sp, #16]
ldp	x26, x25, [sp], #80
ret
.cfi_endproc
.p2align	2
LFQH_FQHPageFilterMiniGame:
.cfi_startproc
cbz	x0, LFQH_LBB43_7
stp	x20, x19, [sp, #-32]!
stp	x29, x30, [sp, #16]
add	x29, sp, #16
.cfi_def_cfa w29, 16
.cfi_offset w30, -8
.cfi_offset w29, -16
.cfi_offset w19, -24
.cfi_offset w20, -32
mov	x20, x0
LFQH_Lloh694:
adr x1, LFQH_l_.str.59
LFQH_Lloh695:
nop
bl	LFQH_Get
mov	x19, x0
bl	LFQH_MineStandaloneGameRow
cbz	w0, LFQH_LBB43_6
LFQH_Lloh696:
adr x0, LFQH_l_.str.60
LFQH_Lloh697:
nop
bl Lpatch + (0xa5a4 - PATCH_BASE)
mov	x1, x0
mov	x0, x19
mov	w2, #1
bl Lpatch + (0xa5d4 - PATCH_BASE)
LFQH_Lloh698:
adr x0, LFQH_l_.str.61
LFQH_Lloh699:
nop
bl Lpatch + (0xa5a4 - PATCH_BASE)
mov	x1, x0
mov	x0, x19
mov	w2, #1
bl Lpatch + (0xa5d4 - PATCH_BASE)
LFQH_Lloh700:
adr x1, LFQH_l_.str.62
LFQH_Lloh701:
nop
mov	x0, x20
bl	LFQH_Get
mov	x20, x0
LFQH_Lloh702:
adr x1, LFQH_l_.str.63
LFQH_Lloh703:
nop
bl	LFQH_Kind
cbz	w0, LFQH_LBB43_5
LFQH_Lloh704:
adr x1, LFQH_l_.str.64
LFQH_Lloh705:
nop
mov	x0, x20
bl	LFQH_Responds
cbz	w0, LFQH_LBB43_5
LFQH_Lloh706:
adr x0, LFQH_l_.str.64
LFQH_Lloh707:
nop
bl Lpatch + (0xa5a4 - PATCH_BASE)
mov	x1, x0
mov	x0, x20
mov	x2, x19
bl Lpatch + (0xa5d4 - PATCH_BASE)
LFQH_LBB43_5:
LFQH_Lloh708:
adr x0, LFQH_l_.str.65
LFQH_Lloh709:
nop
LFQH_Lloh710:
adr x1, LFQH_l_.str.66
LFQH_Lloh711:
nop
bl	LFQH_RecordMineGameRemoval
mov	w0, #1
LFQH_LBB43_6:
ldp	x29, x30, [sp, #16]
ldp	x20, x19, [sp], #32
LFQH_LBB43_7:
ret
.cfi_endproc
.p2align	2
LFQH_MineStandaloneGameRow:
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
LFQH_Lloh712:
adr x1, LFQH_l_.str.281
LFQH_Lloh713:
nop
bl	LFQH_Kind
cbz	w0, LFQH_LBB44_2
LFQH_Lloh714:
adr x1, LFQH_l_.str.282
LFQH_Lloh715:
nop
mov	x0, x19
bl	LFQH_Kind
cmp	w0, #0
cset	w0, eq
LFQH_LBB44_2:
ldp	x29, x30, [sp, #16]
ldp	x20, x19, [sp], #32
ret
.cfi_endproc
.p2align	2
LFQH_RecordMineGameRemoval:
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
mov	x23, x0
LFQH_Lloh716:
adr x0, LFQH_l_.str.211
LFQH_Lloh717:
nop
bl Lpatch + (0xa5b0 - PATCH_BASE)
mov	x20, x0
LFQH_Lloh718:
adr x0, LFQH_l_.str.212
LFQH_Lloh719:
nop
bl Lpatch + (0xa5a4 - PATCH_BASE)
mov	x1, x0
mov	x0, x20
bl Lpatch + (0xa5d4 - PATCH_BASE)
mov	x20, x0
LFQH_Lloh720:
adr x21, LFQH_l_.str.182
LFQH_Lloh721:
nop
mov	x0, x21
bl Lpatch + (0xa5b0 - PATCH_BASE)
mov	x24, x0
LFQH_Lloh722:
adr x22, LFQH_l_.str.183
LFQH_Lloh723:
nop
mov	x0, x22
bl Lpatch + (0xa5a4 - PATCH_BASE)
mov	x1, x0
LFQH_Lloh724:
adr x2, LFQH_l_.str.284
LFQH_Lloh725:
nop
mov	x0, x24
bl Lpatch + (0xa5d4 - PATCH_BASE)
mov	x2, x0
LFQH_Lloh726:
adr x1, LFQH_l_.str.283
LFQH_Lloh727:
nop
mov	x0, x20
bl	LFQH_Put
mov	x0, x21
bl Lpatch + (0xa5b0 - PATCH_BASE)
mov	x24, x0
mov	x0, x22
bl Lpatch + (0xa5a4 - PATCH_BASE)
mov	x1, x0
mov	x0, x24
mov	x2, x23
bl Lpatch + (0xa5d4 - PATCH_BASE)
mov	x2, x0
LFQH_Lloh728:
adr x1, LFQH_l_.str.285
LFQH_Lloh729:
nop
mov	x0, x20
bl	LFQH_Put
mov	x0, x21
bl Lpatch + (0xa5b0 - PATCH_BASE)
mov	x23, x0
mov	x0, x22
bl Lpatch + (0xa5a4 - PATCH_BASE)
mov	x1, x0
LFQH_Lloh730:
adr x2, LFQH_l_.str.287
LFQH_Lloh731:
nop
mov	x0, x23
bl Lpatch + (0xa5d4 - PATCH_BASE)
mov	x2, x0
LFQH_Lloh732:
adr x1, LFQH_l_.str.286
LFQH_Lloh733:
nop
mov	x0, x20
bl	LFQH_Put
mov	x0, x21
bl Lpatch + (0xa5b0 - PATCH_BASE)
mov	x21, x0
mov	x0, x22
bl Lpatch + (0xa5a4 - PATCH_BASE)
mov	x1, x0
mov	x0, x21
mov	x2, x19
bl Lpatch + (0xa5d4 - PATCH_BASE)
mov	x2, x0
LFQH_Lloh734:
adr x1, LFQH_l_.str.288
LFQH_Lloh735:
nop
mov	x0, x20
bl	LFQH_Put
LFQH_Lloh736:
adr x0, LFQH_l_.str.289
LFQH_Lloh737:
nop
mov	x1, x20
ldp	x29, x30, [sp, #48]
ldp	x20, x19, [sp, #32]
ldp	x22, x21, [sp, #16]
ldp	x24, x23, [sp], #64
b Lrecord_named
.cfi_endproc
.p2align	2
LFQH_FQHInstallOptionsToggles:
.cfi_startproc
sub	sp, sp, #176
stp	d15, d14, [sp, #16]
stp	d13, d12, [sp, #32]
stp	d11, d10, [sp, #48]
stp	d9, d8, [sp, #64]
stp	x28, x27, [sp, #80]
stp	x26, x25, [sp, #96]
stp	x24, x23, [sp, #112]
stp	x22, x21, [sp, #128]
stp	x20, x19, [sp, #144]
stp	x29, x30, [sp, #160]
add	x29, sp, #160
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
.cfi_offset b14, -152
.cfi_offset b15, -160
LFQH_Lloh738:
adr x1, LFQH_l_.str.67
LFQH_Lloh739:
nop
bl	LFQH_Get
cbz	x0, LFQH_LBB46_2
mov	x19, x0
LFQH_Lloh740:
adr x1, LFQH_l_.str.68
LFQH_Lloh741:
nop
bl	LFQH_Get
cbz	x0, LFQH_LBB46_3
LFQH_LBB46_2:
ldp	x29, x30, [sp, #160]
ldp	x20, x19, [sp, #144]
ldp	x22, x21, [sp, #128]
ldp	x24, x23, [sp, #112]
ldp	x26, x25, [sp, #96]
ldp	x28, x27, [sp, #80]
ldp	d9, d8, [sp, #64]
ldp	d11, d10, [sp, #48]
ldp	d13, d12, [sp, #32]
ldp	d15, d14, [sp, #16]
add	sp, sp, #176
ret
LFQH_LBB46_3:
bl	LFQH_ToggleObserver
cbz	x0, LFQH_LBB46_2
mov	x20, x0
LFQH_Lloh742:
adr x0, LFQH_l_.str.69
LFQH_Lloh743:
nop
bl Lpatch + (0xa5a4 - PATCH_BASE)
mov	x1, x0
mov	x0, x20
bl Lpatch + (0xa5d4 - PATCH_BASE)
mov	x20, x0
LFQH_Lloh744:
adr x0, LFQH_l_.str.70
LFQH_Lloh745:
nop
bl Lpatch + (0xa5a4 - PATCH_BASE)
mov	x1, x0
mov	x0, x20
bl Lpatch + (0xa5d4 - PATCH_BASE)
str	x0, [sp, #8]
cbz	x0, LFQH_LBB46_2
LFQH_Lloh746:
adr x0, LFQH_l_.str.23
LFQH_Lloh747:
nop
bl Lpatch + (0xa5b0 - PATCH_BASE)
mov	x20, x0
LFQH_Lloh748:
adr x0, LFQH_l_.str.69
LFQH_Lloh749:
nop
bl Lpatch + (0xa5a4 - PATCH_BASE)
mov	x1, x0
mov	x0, x20
bl Lpatch + (0xa5d4 - PATCH_BASE)
mov	x20, x0
LFQH_Lloh750:
adr x0, LFQH_l_.str.70
LFQH_Lloh751:
nop
bl Lpatch + (0xa5a4 - PATCH_BASE)
mov	x1, x0
mov	x0, x20
bl Lpatch + (0xa5d4 - PATCH_BASE)
cbz	x0, LFQH_LBB46_29
mov	x21, x0
LFQH_Lloh752:
adr x0, LFQH_l_.str.24
LFQH_Lloh753:
nop
bl Lpatch + (0xa5a4 - PATCH_BASE)
mov	x1, x0
str	x19, [sp]
mov	x0, x19
bl Lpatch + (0xa5d4 - PATCH_BASE)
fcmp	d2, #0.0
mov	x8, #4644337115725824000
fmov	d0, x8
fcsel	d8, d2, d0, gt
LFQH_Lloh754:
adr x0, LFQH_l_.str.71
LFQH_Lloh755:
nop
bl Lpatch + (0xa5a4 - PATCH_BASE)
mov	x1, x0
mov	x8, #4645744490609377280
fmov	d3, x8
fmov	d0, xzr
fmov	d1, xzr
mov	x0, x21
mov.16b	v2, v8
bl Lpatch + (0xa5d4 - PATCH_BASE)
LFQH_Lloh756:
adr x0, LFQH_l_.str.72
LFQH_Lloh757:
nop
bl Lpatch + (0xa5a4 - PATCH_BASE)
mov	x20, x0
LFQH_Lloh758:
adr x0, LFQH_l_.str.46
LFQH_Lloh759:
nop
bl Lpatch + (0xa5b0 - PATCH_BASE)
mov	x22, x0
LFQH_Lloh760:
adr x0, LFQH_l_.str.73
LFQH_Lloh761:
nop
bl Lpatch + (0xa5a4 - PATCH_BASE)
mov	x1, x0
mov	x0, x22
bl Lpatch + (0xa5d4 - PATCH_BASE)
mov	x2, x0
mov	x0, x21
mov	x1, x20
bl Lpatch + (0xa5d4 - PATCH_BASE)
mov	w25, #1
mov	w24, #10
LFQH_Lloh762:
adr x26, LFQH_l_.str.69
LFQH_Lloh763:
nop
LFQH_Lloh764:
adr x19, LFQH_l_.str.70
LFQH_Lloh765:
nop
mov	x8, #-4586916220476850176
fmov	d13, x8
mov	x8, #-4588042120383692800
fmov	d14, x8
mov	x8, #4634204016564240384
fmov	d9, x8
LFQH_LBB46_7:
cmp	x25, #3
b.le	LFQH_LBB46_12
cmp	x25, #5
b.gt	LFQH_LBB46_16
cmp	x25, #4
b.eq	LFQH_LBB46_21
cmp	x25, #5
b.ne	LFQH_LBB46_20
LFQH_Lloh766:
adr x22, LFQH_l_.str.357
LFQH_Lloh767:
nop
b	LFQH_LBB46_24
LFQH_LBB46_12:
cmp	x25, #1
b.eq	LFQH_LBB46_19
cmp	x25, #2
b.eq	LFQH_LBB46_23
cmp	x25, #3
b.ne	LFQH_LBB46_20
LFQH_Lloh768:
adr x22, LFQH_l_.str.355
LFQH_Lloh769:
nop
b	LFQH_LBB46_24
LFQH_LBB46_16:
cmp	x25, #6
b.eq	LFQH_LBB46_22
cmp	x25, #7
b.ne	LFQH_LBB46_20
LFQH_Lloh770:
adr x22, LFQH_l_.str.359
LFQH_Lloh771:
nop
b	LFQH_LBB46_24
LFQH_LBB46_19:
LFQH_Lloh772:
adr x22, LFQH_l_.str.353
LFQH_Lloh773:
nop
b	LFQH_LBB46_24
LFQH_LBB46_20:
LFQH_Lloh774:
adr x22, LFQH_l_.str.360
LFQH_Lloh775:
nop
b	LFQH_LBB46_24
LFQH_LBB46_21:
LFQH_Lloh776:
adr x22, LFQH_l_.str.356
LFQH_Lloh777:
nop
b	LFQH_LBB46_24
LFQH_LBB46_22:
LFQH_Lloh778:
adr x22, LFQH_l_.str.358
LFQH_Lloh779:
nop
b	LFQH_LBB46_24
LFQH_LBB46_23:
LFQH_Lloh780:
adr x22, LFQH_l_.str.354
LFQH_Lloh781:
nop
LFQH_LBB46_24:
LFQH_Lloh782:
adr x0, LFQH_l_.str.182
LFQH_Lloh783:
nop
bl Lpatch + (0xa5b0 - PATCH_BASE)
mov	x27, x0
LFQH_Lloh784:
adr x0, LFQH_l_.str.183
LFQH_Lloh785:
nop
bl Lpatch + (0xa5a4 - PATCH_BASE)
mov	x1, x0
mov	x0, x27
mov	x2, x22
bl Lpatch + (0xa5d4 - PATCH_BASE)
mov	x27, x0
mov	x0, x25
bl	LFQH_PagePreference
bl	LFQH_DefaultEnabled
mov	x28, x0
LFQH_Lloh786:
adr x0, LFQH_l_.str.24
LFQH_Lloh787:
nop
bl Lpatch + (0xa5a4 - PATCH_BASE)
mov	x1, x0
mov	x0, x21
bl Lpatch + (0xa5d4 - PATCH_BASE)
mov.16b	v10, v2
LFQH_Lloh788:
adr x0, LFQH_l_.str.36
LFQH_Lloh789:
nop
bl Lpatch + (0xa5b0 - PATCH_BASE)
mov	x22, x0
mov	x0, x26
bl Lpatch + (0xa5a4 - PATCH_BASE)
mov	x1, x0
mov	x0, x22
bl Lpatch + (0xa5d4 - PATCH_BASE)
mov	x22, x0
mov	x0, x19
bl Lpatch + (0xa5a4 - PATCH_BASE)
mov	x1, x0
mov	x0, x22
bl Lpatch + (0xa5d4 - PATCH_BASE)
cbz	x0, LFQH_LBB46_27
mov	x22, x0
sub	x8, x24, #2
ucvtf	d11, x8
fadd	d12, d10, d13
LFQH_Lloh790:
adr x0, LFQH_l_.str.71
LFQH_Lloh791:
nop
bl Lpatch + (0xa5a4 - PATCH_BASE)
mov	x1, x0
fmov	d0, #16.00000000
fmov	d3, #30.00000000
mov	x0, x22
mov.16b	v1, v11
mov.16b	v2, v12
bl Lpatch + (0xa5d4 - PATCH_BASE)
LFQH_Lloh792:
adr x0, LFQH_l_.str.74
LFQH_Lloh793:
nop
bl Lpatch + (0xa5a4 - PATCH_BASE)
mov	x1, x0
mov	x0, x22
mov	x2, x27
bl Lpatch + (0xa5d4 - PATCH_BASE)
LFQH_Lloh794:
adr x0, LFQH_l_.str.77
LFQH_Lloh795:
nop
bl Lpatch + (0xa5a4 - PATCH_BASE)
mov	x23, x0
LFQH_Lloh796:
adr x0, LFQH_l_.str.78
LFQH_Lloh797:
nop
bl Lpatch + (0xa5b0 - PATCH_BASE)
mov	x20, x26
mov	x26, x0
LFQH_Lloh798:
adr x0, LFQH_l_.str.79
LFQH_Lloh799:
nop
bl Lpatch + (0xa5a4 - PATCH_BASE)
mov	x1, x0
fmov	d0, #15.00000000
mov	x0, x26
bl Lpatch + (0xa5d4 - PATCH_BASE)
mov	x2, x0
mov	x0, x22
mov	x1, x23
bl Lpatch + (0xa5d4 - PATCH_BASE)
LFQH_Lloh800:
adr x0, LFQH_l_.str.44
LFQH_Lloh801:
nop
bl Lpatch + (0xa5a4 - PATCH_BASE)
mov	x23, x0
LFQH_Lloh802:
adr x0, LFQH_l_.str.46
LFQH_Lloh803:
nop
bl Lpatch + (0xa5b0 - PATCH_BASE)
mov	x26, x0
LFQH_Lloh804:
adr x0, LFQH_l_.str.47
LFQH_Lloh805:
nop
bl Lpatch + (0xa5a4 - PATCH_BASE)
mov	x1, x0
mov	x0, x26
mov	x26, x20
bl Lpatch + (0xa5d4 - PATCH_BASE)
mov	x2, x0
mov	x0, x22
mov	x1, x23
bl Lpatch + (0xa5d4 - PATCH_BASE)
LFQH_Lloh806:
adr x0, LFQH_l_.str.81
LFQH_Lloh807:
nop
bl Lpatch + (0xa5a4 - PATCH_BASE)
mov	x1, x0
mov	x0, x22
mov	w2, #2
bl Lpatch + (0xa5d4 - PATCH_BASE)
LFQH_Lloh808:
adr x0, LFQH_l_.str.82
LFQH_Lloh809:
nop
bl Lpatch + (0xa5a4 - PATCH_BASE)
mov	x1, x0
mov	x0, x21
mov	x2, x22
bl Lpatch + (0xa5d4 - PATCH_BASE)
LFQH_Lloh810:
adr x0, LFQH_l_.str.55
LFQH_Lloh811:
nop
bl Lpatch + (0xa5a4 - PATCH_BASE)
mov	x1, x0
mov	x0, x22
bl Lpatch + (0xa5d4 - PATCH_BASE)
LFQH_Lloh812:
adr x0, LFQH_l_.str.350
LFQH_Lloh813:
nop
bl Lpatch + (0xa5b0 - PATCH_BASE)
mov	x22, x0
mov	x0, x20
bl Lpatch + (0xa5a4 - PATCH_BASE)
mov	x1, x0
mov	x0, x22
bl Lpatch + (0xa5d4 - PATCH_BASE)
mov	x22, x0
mov	x0, x19
bl Lpatch + (0xa5a4 - PATCH_BASE)
mov	x1, x0
mov	x0, x22
bl Lpatch + (0xa5d4 - PATCH_BASE)
cbz	x0, LFQH_LBB46_27
mov	x22, x0
fadd	d10, d10, d14
ucvtf	d11, x24
LFQH_Lloh814:
adr x0, LFQH_l_.str.71
LFQH_Lloh815:
nop
bl Lpatch + (0xa5a4 - PATCH_BASE)
mov	x1, x0
fmov	d3, #31.00000000
mov	x0, x22
mov.16b	v0, v10
mov.16b	v1, v11
mov.16b	v2, v9
bl Lpatch + (0xa5d4 - PATCH_BASE)
LFQH_Lloh816:
adr x0, LFQH_l_.str.351
LFQH_Lloh817:
nop
bl Lpatch + (0xa5a4 - PATCH_BASE)
mov	x1, x0
mov	x0, x22
mov	x2, x25
bl Lpatch + (0xa5d4 - PATCH_BASE)
LFQH_Lloh818:
adr x0, LFQH_l_.str.81
LFQH_Lloh819:
nop
bl Lpatch + (0xa5a4 - PATCH_BASE)
mov	x1, x0
mov	x0, x22
mov	w2, #17
bl Lpatch + (0xa5d4 - PATCH_BASE)
LFQH_Lloh820:
adr x0, LFQH_l_.str.316
LFQH_Lloh821:
nop
bl Lpatch + (0xa5a4 - PATCH_BASE)
mov	x1, x0
mov	x0, x22
mov	x2, x28
mov	w3, #0
bl Lpatch + (0xa5d4 - PATCH_BASE)
LFQH_Lloh822:
adr x0, LFQH_l_.str.247
LFQH_Lloh823:
nop
bl Lpatch + (0xa5a4 - PATCH_BASE)
mov	x23, x0
LFQH_Lloh824:
adr x0, LFQH_l_.str.309
LFQH_Lloh825:
nop
bl Lpatch + (0xa5a4 - PATCH_BASE)
mov	x3, x0
mov	x0, x22
mov	x1, x23
ldr	x2, [sp, #8]
mov	w4, #4096
bl Lpatch + (0xa5d4 - PATCH_BASE)
LFQH_Lloh826:
adr x0, LFQH_l_.str.352
LFQH_Lloh827:
nop
bl Lpatch + (0xa5a4 - PATCH_BASE)
mov	x1, x0
mov	x0, x22
mov	x2, x27
bl Lpatch + (0xa5d4 - PATCH_BASE)
LFQH_Lloh828:
adr x0, LFQH_l_.str.82
LFQH_Lloh829:
nop
bl Lpatch + (0xa5a4 - PATCH_BASE)
mov	x1, x0
mov	x0, x21
mov	x2, x22
bl Lpatch + (0xa5d4 - PATCH_BASE)
LFQH_Lloh830:
adr x0, LFQH_l_.str.55
LFQH_Lloh831:
nop
bl Lpatch + (0xa5a4 - PATCH_BASE)
mov	x1, x0
mov	x0, x22
bl Lpatch + (0xa5d4 - PATCH_BASE)
LFQH_LBB46_27:
add	x25, x25, #1
add	x24, x24, #42
cmp	x24, #346
b.ne	LFQH_LBB46_7
LFQH_Lloh832:
adr x0, LFQH_l_.str.36
LFQH_Lloh833:
nop
bl Lpatch + (0xa5b0 - PATCH_BASE)
mov	x20, x0
LFQH_Lloh834:
adr x0, LFQH_l_.str.69
LFQH_Lloh835:
nop
bl Lpatch + (0xa5a4 - PATCH_BASE)
mov	x1, x0
mov	x0, x20
bl Lpatch + (0xa5d4 - PATCH_BASE)
mov	x20, x0
LFQH_Lloh836:
adr x0, LFQH_l_.str.70
LFQH_Lloh837:
nop
bl Lpatch + (0xa5a4 - PATCH_BASE)
mov	x1, x0
mov	x0, x20
bl Lpatch + (0xa5d4 - PATCH_BASE)
mov	x20, x0
mov	x8, #-4593671619917905920
fmov	d0, x8
fadd	d8, d8, d0
LFQH_Lloh838:
adr x0, LFQH_l_.str.71
LFQH_Lloh839:
nop
bl Lpatch + (0xa5a4 - PATCH_BASE)
mov	x1, x0
mov	x8, #4644900065679245312
fmov	d1, x8
mov	x8, #4630826316843712512
fmov	d3, x8
fmov	d0, #16.00000000
mov	x0, x20
mov.16b	v2, v8
bl Lpatch + (0xa5d4 - PATCH_BASE)
LFQH_Lloh840:
adr x0, LFQH_l_.str.74
LFQH_Lloh841:
nop
bl Lpatch + (0xa5a4 - PATCH_BASE)
mov	x22, x0
LFQH_Lloh842:
adr x0, LFQH_l_.str.182
LFQH_Lloh843:
nop
bl Lpatch + (0xa5b0 - PATCH_BASE)
mov	x23, x0
LFQH_Lloh844:
adr x0, LFQH_l_.str.183
LFQH_Lloh845:
nop
bl Lpatch + (0xa5a4 - PATCH_BASE)
mov	x1, x0
LFQH_Lloh846:
adr x2, LFQH_l_.str.75
LFQH_Lloh847:
nop
mov	x0, x23
bl Lpatch + (0xa5d4 - PATCH_BASE)
mov	x2, x0
mov	x0, x20
mov	x1, x22
bl Lpatch + (0xa5d4 - PATCH_BASE)
LFQH_Lloh848:
adr x0, LFQH_l_.str.76
LFQH_Lloh849:
nop
bl Lpatch + (0xa5a4 - PATCH_BASE)
mov	x1, x0
mov	x0, x20
mov	w2, #2
bl Lpatch + (0xa5d4 - PATCH_BASE)
LFQH_Lloh850:
adr x0, LFQH_l_.str.77
LFQH_Lloh851:
nop
bl Lpatch + (0xa5a4 - PATCH_BASE)
mov	x22, x0
LFQH_Lloh852:
adr x0, LFQH_l_.str.78
LFQH_Lloh853:
nop
bl Lpatch + (0xa5b0 - PATCH_BASE)
mov	x23, x0
LFQH_Lloh854:
adr x0, LFQH_l_.str.79
LFQH_Lloh855:
nop
bl Lpatch + (0xa5a4 - PATCH_BASE)
mov	x1, x0
fmov	d0, #12.00000000
mov	x0, x23
bl Lpatch + (0xa5d4 - PATCH_BASE)
mov	x2, x0
mov	x0, x20
mov	x1, x22
bl Lpatch + (0xa5d4 - PATCH_BASE)
LFQH_Lloh856:
adr x0, LFQH_l_.str.44
LFQH_Lloh857:
nop
bl Lpatch + (0xa5a4 - PATCH_BASE)
mov	x22, x0
LFQH_Lloh858:
adr x0, LFQH_l_.str.46
LFQH_Lloh859:
nop
bl Lpatch + (0xa5b0 - PATCH_BASE)
mov	x23, x0
LFQH_Lloh860:
adr x0, LFQH_l_.str.80
LFQH_Lloh861:
nop
bl Lpatch + (0xa5a4 - PATCH_BASE)
mov	x1, x0
mov	x0, x23
bl Lpatch + (0xa5d4 - PATCH_BASE)
mov	x2, x0
mov	x0, x20
mov	x1, x22
bl Lpatch + (0xa5d4 - PATCH_BASE)
LFQH_Lloh862:
adr x0, LFQH_l_.str.81
LFQH_Lloh863:
nop
bl Lpatch + (0xa5a4 - PATCH_BASE)
mov	x1, x0
mov	x0, x20
mov	w2, #2
bl Lpatch + (0xa5d4 - PATCH_BASE)
LFQH_Lloh864:
adr x0, LFQH_l_.str.82
LFQH_Lloh865:
nop
bl Lpatch + (0xa5a4 - PATCH_BASE)
mov	x1, x0
mov	x0, x21
mov	x2, x20
bl Lpatch + (0xa5d4 - PATCH_BASE)
LFQH_Lloh866:
adr x22, LFQH_l_.str.55
LFQH_Lloh867:
nop
mov	x0, x22
bl Lpatch + (0xa5a4 - PATCH_BASE)
mov	x1, x0
mov	x0, x20
bl Lpatch + (0xa5d4 - PATCH_BASE)
LFQH_Lloh868:
adr x1, LFQH_ToggleObserverKey
LFQH_Lloh869:
nop
mov	x0, x21
ldr	x2, [sp, #8]
mov	w3, #1
bl Lpatch + (0xa634 - PATCH_BASE)
LFQH_Lloh870:
adr x0, LFQH_l_.str.83
LFQH_Lloh871:
nop
bl Lpatch + (0xa5a4 - PATCH_BASE)
mov	x1, x0
ldr	x0, [sp]
mov	x2, x21
bl Lpatch + (0xa5d4 - PATCH_BASE)
mov	x0, x22
bl Lpatch + (0xa5a4 - PATCH_BASE)
mov	x1, x0
mov	x0, x21
bl Lpatch + (0xa5d4 - PATCH_BASE)
LFQH_LBB46_29:
LFQH_Lloh872:
adr x0, LFQH_l_.str.55
LFQH_Lloh873:
nop
bl Lpatch + (0xa5a4 - PATCH_BASE)
mov	x1, x0
ldr	x0, [sp, #8]
ldp	x29, x30, [sp, #160]
ldp	x20, x19, [sp, #144]
ldp	x22, x21, [sp, #128]
ldp	x24, x23, [sp, #112]
ldp	x26, x25, [sp, #96]
ldp	x28, x27, [sp, #80]
ldp	d9, d8, [sp, #64]
ldp	d11, d10, [sp, #48]
ldp	d13, d12, [sp, #32]
ldp	d15, d14, [sp, #16]
add	sp, sp, #176
b Lpatch + (0xa5d4 - PATCH_BASE)
.cfi_endproc
.p2align	2
LFQH_ToggleObserver:
.cfi_startproc
stp	x20, x19, [sp, #-32]!
stp	x29, x30, [sp, #16]
add	x29, sp, #16
.cfi_def_cfa w29, 16
.cfi_offset w30, -8
.cfi_offset w29, -16
.cfi_offset w19, -24
.cfi_offset w20, -32
LFQH_Lloh874:
adr x0, LFQH_l_.str.307
LFQH_Lloh875:
nop
bl Lpatch + (0xa5b0 - PATCH_BASE)
mov	x19, x0
cbnz	x0, LFQH_LBB47_3
LFQH_Lloh876:
adr x0, LFQH_l_.str.308
LFQH_Lloh877:
nop
bl Lpatch + (0xa5b0 - PATCH_BASE)
LFQH_Lloh878:
adr x1, LFQH_l_.str.307
LFQH_Lloh879:
nop
mov	x2, #0
bl Lpatch + (0xa61c - PATCH_BASE)
mov	x19, x0
cbz	x0, LFQH_LBB47_3
LFQH_Lloh880:
adr x0, LFQH_l_.str.309
LFQH_Lloh881:
nop
bl Lpatch + (0xa5a4 - PATCH_BASE)
mov	x1, x0
LFQH_Lloh882:
adr x2, LFQH_ToggleChanged
LFQH_Lloh883:
nop
LFQH_Lloh884:
adr x20, LFQH_l_.str.98
LFQH_Lloh885:
nop
mov	x0, x19
mov	x3, x20
bl Lpatch + (0xa58c - PATCH_BASE)
LFQH_Lloh886:
adr x0, LFQH_l_.str.310
LFQH_Lloh887:
nop
bl Lpatch + (0xa5a4 - PATCH_BASE)
mov	x1, x0
LFQH_Lloh888:
adr x2, LFQH_RecoverOptions
LFQH_Lloh889:
nop
mov	x0, x19
mov	x3, x20
bl Lpatch + (0xa58c - PATCH_BASE)
LFQH_Lloh890:
adr x0, LFQH_l_.str.311
LFQH_Lloh891:
nop
bl Lpatch + (0xa5a4 - PATCH_BASE)
mov	x1, x0
LFQH_Lloh892:
adr x2, LFQH_RecoveryTouch
LFQH_Lloh893:
nop
LFQH_Lloh894:
adr x3, LFQH_l_.str.312
LFQH_Lloh895:
nop
mov	x0, x19
bl Lpatch + (0xa58c - PATCH_BASE)
mov	x0, x19
bl Lpatch + (0xa610 - PATCH_BASE)
LFQH_LBB47_3:
mov	x0, x19
ldp	x29, x30, [sp, #16]
ldp	x20, x19, [sp], #32
ret
.cfi_endproc
.p2align	2
LFQH_DefaultEnabled:
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
LFQH_Lloh896:
adr x0, LFQH_l_.str.274
LFQH_Lloh897:
nop
bl Lpatch + (0xa5b0 - PATCH_BASE)
mov	x20, x0
LFQH_Lloh898:
adr x0, LFQH_l_.str.275
LFQH_Lloh899:
nop
bl Lpatch + (0xa5a4 - PATCH_BASE)
mov	x1, x0
mov	x0, x20
bl Lpatch + (0xa5d4 - PATCH_BASE)
mov	x20, x0
LFQH_Lloh900:
adr x0, LFQH_l_.str.361
LFQH_Lloh901:
nop
bl Lpatch + (0xa5a4 - PATCH_BASE)
mov	x1, x0
mov	x0, x20
mov	x2, x19
bl Lpatch + (0xa5d4 - PATCH_BASE)
cbz	x0, LFQH_LBB48_2
LFQH_Lloh902:
adr x1, LFQH_l_.str.40
LFQH_Lloh903:
nop
ldp	x29, x30, [sp, #16]
ldp	x20, x19, [sp], #32
b	LFQH_BoolProp
LFQH_LBB48_2:
mov	w0, #1
ldp	x29, x30, [sp, #16]
ldp	x20, x19, [sp], #32
ret
.cfi_endproc
.p2align	2
LFQH_PagePreference:
.cfi_startproc
stp	x20, x19, [sp, #-32]!
stp	x29, x30, [sp, #16]
add	x29, sp, #16
.cfi_def_cfa w29, 16
.cfi_offset w30, -8
.cfi_offset w29, -16
.cfi_offset w19, -24
.cfi_offset w20, -32
cmp	x0, #4
b.gt	LFQH_LBB49_5
cmp	x0, #2
b.gt	LFQH_LBB49_9
cmp	x0, #1
b.eq	LFQH_LBB49_15
cmp	x0, #2
b.ne	LFQH_LBB49_20
LFQH_Lloh904:
adr x19, LFQH_l_.str.363
LFQH_Lloh905:
nop
b	LFQH_LBB49_19
LFQH_LBB49_5:
cmp	x0, #6
b.gt	LFQH_LBB49_12
cmp	x0, #5
b.eq	LFQH_LBB49_16
cmp	x0, #6
b.ne	LFQH_LBB49_20
LFQH_Lloh906:
adr x19, LFQH_l_.str.367
LFQH_Lloh907:
nop
b	LFQH_LBB49_19
LFQH_LBB49_9:
cmp	x0, #3
b.eq	LFQH_LBB49_17
cmp	x0, #4
b.ne	LFQH_LBB49_20
LFQH_Lloh908:
adr x19, LFQH_l_.str.365
LFQH_Lloh909:
nop
b	LFQH_LBB49_19
LFQH_LBB49_12:
cmp	x0, #7
b.eq	LFQH_LBB49_18
cmp	x0, #8
b.ne	LFQH_LBB49_20
LFQH_Lloh910:
adr x19, LFQH_l_.str.369
LFQH_Lloh911:
nop
b	LFQH_LBB49_19
LFQH_LBB49_15:
LFQH_Lloh912:
adr x19, LFQH_l_.str.362
LFQH_Lloh913:
nop
b	LFQH_LBB49_19
LFQH_LBB49_16:
LFQH_Lloh914:
adr x19, LFQH_l_.str.366
LFQH_Lloh915:
nop
b	LFQH_LBB49_19
LFQH_LBB49_17:
LFQH_Lloh916:
adr x19, LFQH_l_.str.364
LFQH_Lloh917:
nop
b	LFQH_LBB49_19
LFQH_LBB49_18:
LFQH_Lloh918:
adr x19, LFQH_l_.str.368
LFQH_Lloh919:
nop
LFQH_LBB49_19:
LFQH_Lloh920:
adr x0, LFQH_l_.str.182
LFQH_Lloh921:
nop
bl Lpatch + (0xa5b0 - PATCH_BASE)
mov	x20, x0
LFQH_Lloh922:
adr x0, LFQH_l_.str.183
LFQH_Lloh923:
nop
bl Lpatch + (0xa5a4 - PATCH_BASE)
mov	x1, x0
mov	x0, x20
mov	x2, x19
ldp	x29, x30, [sp, #16]
ldp	x20, x19, [sp], #32
b Lpatch + (0xa5d4 - PATCH_BASE)
LFQH_LBB49_20:
mov	x0, #0
ldp	x29, x30, [sp, #16]
ldp	x20, x19, [sp], #32
ret
.cfi_endproc
.p2align	2
LFQH_ToggleObserverKey:
.cfi_startproc
ret
.cfi_endproc
.p2align	2
LFQH_FQHPageStyle:
.cfi_startproc
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
LFQH_Lloh924:
adr x1, LFQH_l_.str.84
LFQH_Lloh925:
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
mov	x20, x2
mov	x21, x1
mov	x19, x0
LFQH_Lloh926:
adr x0, LFQH_l_.str.24
LFQH_Lloh927:
nop
bl Lpatch + (0xa5a4 - PATCH_BASE)
mov	x1, x0
mov	x0, x19
bl Lpatch + (0xa5d4 - PATCH_BASE)
mov.16b	v9, v0
mov.16b	v8, v1
mov.16b	v11, v2
mov.16b	v10, v3
LFQH_Lloh928:
adr x1, LFQH_l_.str.370
LFQH_Lloh929:
nop
mov	x0, x21
bl	LFQH_Responds
fmov	d12, xzr
fmov	d0, xzr
cbz	w0, LFQH_LBB53_2
LFQH_Lloh930:
adr x0, LFQH_l_.str.370
LFQH_Lloh931:
nop
bl Lpatch + (0xa5a4 - PATCH_BASE)
mov	x1, x0
mov	x0, x21
bl Lpatch + (0xa5d4 - PATCH_BASE)
LFQH_LBB53_2:
fmov	d1, #-6.00000000
fadd	d1, d0, d1
fmov	d2, #6.00000000
fcmp	d0, d2
fcsel	d0, d1, d12, gt
fadd	d0, d11, d0
mov	x8, #4631107791820423168
fmov	d1, x8
fminnm	d2, d0, d1
fmov	d0, #-4.00000000
fadd	d0, d10, d0
fmov	d1, #28.00000000
fminnm	d3, d0, d1
fsub	d0, d11, d2
fmov	d1, #0.50000000
fmul	d0, d0, d1
fadd	d0, d9, d0
fsub	d4, d10, d3
fmul	d1, d4, d1
fadd	d1, d8, d1
mov	x0, x19
mov	w1, #0
bl	LFQH_ApplySurface
LFQH_Lloh932:
adr x1, LFQH_SurfaceKey
LFQH_Lloh933:
nop
mov	x0, x19
bl Lpatch + (0xa628 - PATCH_BASE)
mov	x21, x0
mov	x1, x20
mov	w2, #0
bl	LFQH_ShelfTint
LFQH_Lloh934:
adr x1, LFQH_l_.str.371
LFQH_Lloh935:
nop
mov	x0, x19
bl	LFQH_Get
cmp	x21, #0
cset	w20, ne
mov	x1, x20
bl	LFQH_ShelfTitleFont
LFQH_Lloh936:
adr x1, LFQH_l_.str.372
LFQH_Lloh937:
nop
mov	x0, x19
bl	LFQH_Get
mov	x1, x20
ldp	x29, x30, [sp, #80]
ldp	x20, x19, [sp, #64]
ldp	x22, x21, [sp, #48]
ldp	d9, d8, [sp, #32]
ldp	d11, d10, [sp, #16]
ldp	d13, d12, [sp], #96
b	LFQH_ShelfTitleFont
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
LFQH_Lloh938:
adr x20, LFQH_l_.str.85
LFQH_Lloh939:
nop
LFQH_Lloh940:
adr x1, LFQH_l_.str.86
LFQH_Lloh941:
nop
LFQH_Lloh942:
adr x2, LFQH_l_.str.87
LFQH_Lloh943:
nop
LFQH_Lloh944:
adr x19, LFQH_l_.str.88
LFQH_Lloh945:
nop
LFQH_Lloh946:
adr x4, LFQH_ReaderMenuShow
LFQH_Lloh947:
nop
mov	x0, x20
mov	x3, x19
bl	LFQH_Hook
LFQH_Lloh948:
adr x1, LFQH_l_.str.89
LFQH_Lloh949:
nop
LFQH_Lloh950:
adr x2, LFQH_l_.str.90
LFQH_Lloh951:
nop
LFQH_Lloh952:
adr x3, LFQH_l_.str.91
LFQH_Lloh953:
nop
LFQH_Lloh954:
adr x4, LFQH_ReaderBackdropTheme
LFQH_Lloh955:
nop
mov	x0, x20
bl	LFQH_Hook
LFQH_Lloh956:
adr x0, LFQH_l_.str.57
LFQH_Lloh957:
nop
LFQH_Lloh958:
adr x21, LFQH_l_.str.92
LFQH_Lloh959:
nop
LFQH_Lloh960:
adr x2, LFQH_l_.str.93
LFQH_Lloh961:
nop
LFQH_Lloh962:
adr x20, LFQH_l_.str.9
LFQH_Lloh963:
nop
LFQH_Lloh964:
adr x4, LFQH_PageBottomLayout
LFQH_Lloh965:
nop
mov	x1, x21
mov	x3, x20
bl	LFQH_Hook
LFQH_Lloh966:
adr x23, LFQH_l_.str.94
LFQH_Lloh967:
nop
LFQH_Lloh968:
adr x2, LFQH_l_.str.95
LFQH_Lloh969:
nop
LFQH_Lloh970:
adr x4, LFQH_PageProgressLayout
LFQH_Lloh971:
nop
mov	x0, x23
mov	x1, x21
mov	x3, x20
bl	LFQH_Hook
LFQH_Lloh972:
adr x1, LFQH_l_.str.96
LFQH_Lloh973:
nop
LFQH_Lloh974:
adr x2, LFQH_l_.str.97
LFQH_Lloh975:
nop
LFQH_Lloh976:
adr x22, LFQH_l_.str.98
LFQH_Lloh977:
nop
LFQH_Lloh978:
adr x4, LFQH_PageProgressTheme
LFQH_Lloh979:
nop
mov	x0, x23
mov	x3, x22
bl	LFQH_Hook
LFQH_Lloh980:
adr x0, LFQH_l_.str.99
LFQH_Lloh981:
nop
LFQH_Lloh982:
adr x2, LFQH_l_.str.100
LFQH_Lloh983:
nop
LFQH_Lloh984:
adr x4, LFQH_PageDivertLayout
LFQH_Lloh985:
nop
mov	x1, x21
mov	x3, x20
bl	LFQH_Hook
LFQH_Lloh986:
adr x0, LFQH_l_.str.101
LFQH_Lloh987:
nop
LFQH_Lloh988:
adr x2, LFQH_l_.str.102
LFQH_Lloh989:
nop
LFQH_Lloh990:
adr x4, LFQH_PageGiftLayout
LFQH_Lloh991:
nop
mov	x1, x21
mov	x3, x20
bl	LFQH_Hook
LFQH_Lloh992:
adr x0, LFQH_l_.str.103
LFQH_Lloh993:
nop
LFQH_Lloh994:
adr x2, LFQH_l_.str.104
LFQH_Lloh995:
nop
LFQH_Lloh996:
adr x4, LFQH_PageBookGiftLayout
LFQH_Lloh997:
nop
mov	x1, x21
mov	x3, x20
bl	LFQH_Hook
LFQH_Lloh998:
adr x0, LFQH_l_.str.105
LFQH_Lloh999:
nop
LFQH_Lloh1000:
adr x2, LFQH_l_.str.106
LFQH_Lloh1001:
nop
LFQH_Lloh1002:
adr x4, LFQH_PageDiscussLayout
LFQH_Lloh1003:
nop
mov	x1, x21
mov	x3, x20
bl	LFQH_Hook
LFQH_Lloh1004:
adr x0, LFQH_l_.str.107
LFQH_Lloh1005:
nop
LFQH_Lloh1006:
adr x2, LFQH_l_.str.108
LFQH_Lloh1007:
nop
LFQH_Lloh1008:
adr x4, LFQH_PageDiscussButtonLayout
LFQH_Lloh1009:
nop
mov	x1, x21
mov	x3, x20
bl	LFQH_Hook
LFQH_Lloh1010:
adr x23, LFQH_l_.str.109
LFQH_Lloh1011:
nop
LFQH_Lloh1012:
adr x2, LFQH_l_.str.110
LFQH_Lloh1013:
nop
LFQH_Lloh1014:
adr x4, LFQH_PageChapterCardLayout
LFQH_Lloh1015:
nop
mov	x0, x23
mov	x1, x21
mov	x3, x20
bl	LFQH_Hook
LFQH_Lloh1016:
adr x1, LFQH_l_.str.111
LFQH_Lloh1017:
nop
LFQH_Lloh1018:
adr x2, LFQH_l_.str.112
LFQH_Lloh1019:
nop
LFQH_Lloh1020:
adr x4, LFQH_PageChapterCardTheme
LFQH_Lloh1021:
nop
mov	x0, x23
mov	x3, x22
bl	LFQH_Hook
LFQH_Lloh1022:
adr x0, LFQH_l_.str.113
LFQH_Lloh1023:
nop
LFQH_Lloh1024:
adr x2, LFQH_l_.str.114
LFQH_Lloh1025:
nop
LFQH_Lloh1026:
adr x4, LFQH_PageChapterButtonLayout
LFQH_Lloh1027:
nop
mov	x1, x21
mov	x3, x20
bl	LFQH_Hook
LFQH_Lloh1028:
adr x0, LFQH_l_.str.115
LFQH_Lloh1029:
nop
LFQH_Lloh1030:
adr x1, LFQH_l_.str.116
LFQH_Lloh1031:
nop
LFQH_Lloh1032:
adr x2, LFQH_l_.str.117
LFQH_Lloh1033:
nop
LFQH_Lloh1034:
adr x4, LFQH_PageChapterRewardTheme
LFQH_Lloh1035:
nop
mov	x3, x22
bl	LFQH_Hook
LFQH_Lloh1036:
adr x23, LFQH_l_.str.118
LFQH_Lloh1037:
nop
LFQH_Lloh1038:
adr x2, LFQH_l_.str.119
LFQH_Lloh1039:
nop
LFQH_Lloh1040:
adr x4, LFQH_PageShelfTabLayout
LFQH_Lloh1041:
nop
mov	x0, x23
mov	x1, x21
mov	x3, x20
bl	LFQH_Hook
LFQH_Lloh1042:
adr x1, LFQH_l_.str.120
LFQH_Lloh1043:
nop
LFQH_Lloh1044:
adr x2, LFQH_l_.str.121
LFQH_Lloh1045:
nop
LFQH_Lloh1046:
adr x4, LFQH_PageShelfTabReload
LFQH_Lloh1047:
nop
mov	x0, x23
mov	x3, x22
bl	LFQH_Hook
LFQH_Lloh1048:
adr x23, LFQH_l_.str.122
LFQH_Lloh1049:
nop
LFQH_Lloh1050:
adr x2, LFQH_l_.str.123
LFQH_Lloh1051:
nop
LFQH_Lloh1052:
adr x4, LFQH_PageShelfFilterLayout
LFQH_Lloh1053:
nop
mov	x0, x23
mov	x1, x21
mov	x3, x20
bl	LFQH_Hook
LFQH_Lloh1054:
adr x1, LFQH_l_.str.124
LFQH_Lloh1055:
nop
LFQH_Lloh1056:
adr x2, LFQH_l_.str.125
LFQH_Lloh1057:
nop
LFQH_Lloh1058:
adr x4, LFQH_PageShelfFilterAppearance
LFQH_Lloh1059:
nop
mov	x0, x23
mov	x3, x19
bl	LFQH_Hook
LFQH_Lloh1060:
adr x1, LFQH_l_.str.126
LFQH_Lloh1061:
nop
LFQH_Lloh1062:
adr x2, LFQH_l_.str.127
LFQH_Lloh1063:
nop
LFQH_Lloh1064:
adr x4, LFQH_PageShelfFilterBackground
LFQH_Lloh1065:
nop
mov	x0, x23
mov	x3, x22
bl	LFQH_Hook
LFQH_Lloh1066:
adr x0, LFQH_l_.str.128
LFQH_Lloh1067:
nop
LFQH_Lloh1068:
adr x2, LFQH_l_.str.129
LFQH_Lloh1069:
nop
LFQH_Lloh1070:
adr x4, LFQH_ShelfFilterHeaderLayout
LFQH_Lloh1071:
nop
mov	x1, x21
mov	x3, x20
bl	LFQH_Hook
LFQH_Lloh1072:
adr x0, LFQH_l_.str.130
LFQH_Lloh1073:
nop
LFQH_Lloh1074:
adr x2, LFQH_l_.str.131
LFQH_Lloh1075:
nop
LFQH_Lloh1076:
adr x4, LFQH_PageProfileBarLayout
LFQH_Lloh1077:
nop
mov	x1, x21
mov	x3, x20
bl	LFQH_Hook
LFQH_Lloh1078:
adr x0, LFQH_l_.str.132
LFQH_Lloh1079:
nop
LFQH_Lloh1080:
adr x2, LFQH_l_.str.133
LFQH_Lloh1081:
nop
LFQH_Lloh1082:
adr x4, LFQH_PageProfileEntryLayout
LFQH_Lloh1083:
nop
mov	x1, x21
mov	x3, x20
bl	LFQH_Hook
LFQH_Lloh1084:
adr x0, LFQH_l_.str.134
LFQH_Lloh1085:
nop
LFQH_Lloh1086:
adr x2, LFQH_l_.str.135
LFQH_Lloh1087:
nop
LFQH_Lloh1088:
adr x4, LFQH_PageProfileOrderLayout
LFQH_Lloh1089:
nop
mov	x1, x21
mov	x3, x20
bl	LFQH_Hook
LFQH_Lloh1090:
adr x0, LFQH_l_.str.65
LFQH_Lloh1091:
nop
LFQH_Lloh1092:
adr x1, LFQH_l_.str.136
LFQH_Lloh1093:
nop
LFQH_Lloh1094:
adr x2, LFQH_l_.str.137
LFQH_Lloh1095:
nop
LFQH_Lloh1096:
adr x4, LFQH_MiniGameSetup
LFQH_Lloh1097:
nop
mov	x3, x20
bl	LFQH_Hook
LFQH_Lloh1098:
adr x0, LFQH_l_.str.138
LFQH_Lloh1099:
nop
LFQH_Lloh1100:
adr x1, LFQH_l_.str.139
LFQH_Lloh1101:
nop
LFQH_Lloh1102:
adr x2, LFQH_l_.str.140
LFQH_Lloh1103:
nop
LFQH_Lloh1104:
adr x3, LFQH_l_.str.141
LFQH_Lloh1105:
nop
LFQH_Lloh1106:
adr x4, LFQH_MineConfiguredEntrances
LFQH_Lloh1107:
nop
bl	LFQH_Hook
LFQH_Lloh1108:
adr x0, LFQH_l_.str.142
LFQH_Lloh1109:
nop
LFQH_Lloh1110:
adr x1, LFQH_l_.str.143
LFQH_Lloh1111:
nop
LFQH_Lloh1112:
adr x2, LFQH_l_.str.144
LFQH_Lloh1113:
nop
LFQH_Lloh1114:
adr x3, LFQH_l_.str.145
LFQH_Lloh1115:
nop
LFQH_Lloh1116:
adr x4, LFQH_MineListObjects
LFQH_Lloh1117:
nop
bl	LFQH_Hook
LFQH_Lloh1118:
adr x22, LFQH_l_.str.21
LFQH_Lloh1119:
nop
LFQH_Lloh1120:
adr x1, LFQH_l_.str.146
LFQH_Lloh1121:
nop
LFQH_Lloh1122:
adr x2, LFQH_l_.str.147
LFQH_Lloh1123:
nop
LFQH_Lloh1124:
adr x4, LFQH_ShelfDurationVisible
LFQH_Lloh1125:
nop
mov	x0, x22
mov	x3, x19
bl	LFQH_Hook
LFQH_Lloh1126:
adr x2, LFQH_l_.str.148
LFQH_Lloh1127:
nop
LFQH_Lloh1128:
adr x4, LFQH_ShelfDurationLayout
LFQH_Lloh1129:
nop
mov	x0, x22
mov	x1, x21
mov	x3, x20
bl	LFQH_Hook
LFQH_Lloh1130:
adr x0, LFQH_l_.str.149
LFQH_Lloh1131:
nop
LFQH_Lloh1132:
adr x1, LFQH_l_.str.150
LFQH_Lloh1133:
nop
LFQH_Lloh1134:
adr x2, LFQH_l_.str.151
LFQH_Lloh1135:
nop
LFQH_Lloh1136:
adr x3, LFQH_l_.str.152
LFQH_Lloh1137:
nop
LFQH_Lloh1138:
adr x4, LFQH_ShelfFunctionSize
LFQH_Lloh1139:
nop
bl	LFQH_Hook
LFQH_Lloh1140:
adr x0, LFQH_l_.str.153
LFQH_Lloh1141:
nop
LFQH_Lloh1142:
adr x1, LFQH_l_.str.154
LFQH_Lloh1143:
nop
LFQH_Lloh1144:
adr x2, LFQH_l_.str.155
LFQH_Lloh1145:
nop
LFQH_Lloh1146:
adr x4, LFQH_ShelfFunctionLayout
LFQH_Lloh1147:
nop
mov	x3, x20
bl	LFQH_Hook
LFQH_Lloh1148:
adr x20, LFQH_l_.str.156
LFQH_Lloh1149:
nop
LFQH_Lloh1150:
adr x1, LFQH_l_.str.157
LFQH_Lloh1151:
nop
LFQH_Lloh1152:
adr x2, LFQH_l_.str.158
LFQH_Lloh1153:
nop
LFQH_Lloh1154:
adr x3, LFQH_l_.str.11
LFQH_Lloh1155:
nop
LFQH_Lloh1156:
adr x4, LFQH_TabPlan
LFQH_Lloh1157:
nop
mov	x0, x20
bl	LFQH_Hook
LFQH_Lloh1158:
adr x1, LFQH_l_.str.159
LFQH_Lloh1159:
nop
LFQH_Lloh1160:
adr x2, LFQH_l_.str.160
LFQH_Lloh1161:
nop
LFQH_Lloh1162:
adr x4, LFQH_TabOwnerAppear
LFQH_Lloh1163:
nop
mov	x0, x20
mov	x3, x19
ldp	x29, x30, [sp, #48]
ldp	x20, x19, [sp, #32]
ldp	x22, x21, [sp, #16]
ldp	x24, x23, [sp], #64
b	LFQH_Hook
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
cbz	x0, LFQH_LBB55_2
mov	x21, x0
mov	x0, x22
bl Lpatch + (0xa5a4 - PATCH_BASE)
mov	x1, x0
mov	x0, x21
bl Lpatch + (0xa5f8 - PATCH_BASE)
cbz	x0, LFQH_LBB55_3
LFQH_LBB55_2:
ldp	x29, x30, [sp, #48]
ldp	x20, x19, [sp, #32]
ldp	x22, x21, [sp, #16]
ldp	x24, x23, [sp], #64
ret
LFQH_LBB55_3:
mov	x0, x23
bl Lpatch + (0xa5a4 - PATCH_BASE)
mov	x1, x0
mov	x0, x21
mov	w2, #0
mov	x3, x20
bl LHookOwned
cbz	x0, LFQH_LBB55_2
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
cbz	w0, LFQH_LBB55_2
mov	x0, x23
mov	x1, x19
ldp	x29, x30, [sp, #48]
ldp	x20, x19, [sp, #32]
ldp	x22, x21, [sp, #16]
ldp	x24, x23, [sp], #64
b Lpatch + (0xa580 - PATCH_BASE)
.cfi_endproc
.p2align	2
LFQH_ReaderMenuShow:
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
LFQH_Lloh1164:
adr x0, LFQH_l_.str.85
LFQH_Lloh1165:
nop
LFQH_Lloh1166:
adr x1, LFQH_l_.str.87
LFQH_Lloh1167:
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
b	LFQH_ReaderMenuBackdrop
.cfi_endproc
.p2align	2
LFQH_ReaderBackdropTheme:
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
mov	x19, x3
mov	x20, x2
mov	x21, x1
mov	x22, x0
LFQH_Lloh1168:
adr x0, LFQH_l_.str.85
LFQH_Lloh1169:
nop
LFQH_Lloh1170:
adr x1, LFQH_l_.str.90
LFQH_Lloh1171:
nop
bl	LFQH_Original
mov	x8, x0
mov	x0, x22
mov	x1, x21
mov	x2, x20
mov	x3, x19
blr	x8
mov	x0, x22
ldp	x29, x30, [sp, #32]
ldp	x20, x19, [sp, #16]
ldp	x22, x21, [sp], #48
b	LFQH_ReaderMenuBackdrop
.cfi_endproc
.p2align	2
LFQH_PageBottomLayout:
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
mov	x20, x1
mov	x19, x0
LFQH_Lloh1172:
adr x0, LFQH_l_.str.57
LFQH_Lloh1173:
nop
LFQH_Lloh1174:
adr x1, LFQH_l_.str.93
LFQH_Lloh1175:
nop
bl	LFQH_Original
mov	x8, x0
mov	x0, x19
mov	x1, x20
blr	x8
bl	LFQH_ReaderBottomBackgroundEnabled
mov	x1, x0
mov	x0, x19
bl	LFQH_ReaderBackdrop
LFQH_Lloh1176:
adr x1, LFQH_l_.str.384
LFQH_Lloh1177:
nop
mov	x0, x19
bl	LFQH_Get
mov	x20, x0
LFQH_Lloh1178:
adr x0, LFQH_l_.str.34
LFQH_Lloh1179:
nop
bl Lpatch + (0xa5a4 - PATCH_BASE)
mov	x1, x0
mov	x0, x20
bl Lpatch + (0xa5d4 - PATCH_BASE)
mov	x21, x0
LFQH_Lloh1180:
adr x0, LFQH_l_.str.24
LFQH_Lloh1181:
nop
bl Lpatch + (0xa5a4 - PATCH_BASE)
mov	x1, x0
mov	x0, x19
bl Lpatch + (0xa5d4 - PATCH_BASE)
stp	d0, d1, [sp]
stp	d2, d3, [sp, #16]
cbz	x21, LFQH_LBB58_26
mov	x23, #0
mov	x22, #0
LFQH_Lloh1182:
adr x27, LFQH_l_.str.20
LFQH_Lloh1183:
nop
LFQH_LBB58_2:
LFQH_Lloh1184:
adr x0, LFQH_l_.str.264
LFQH_Lloh1185:
nop
bl Lpatch + (0xa5a4 - PATCH_BASE)
mov	x1, x0
mov	x0, x20
mov	x2, x22
bl Lpatch + (0xa5d4 - PATCH_BASE)
mov	x25, x0
LFQH_Lloh1186:
adr x1, LFQH_l_.str.56
LFQH_Lloh1187:
nop
bl	LFQH_Kind
cmp	w0, #0
ccmp	x25, #0, #4, ne
b.eq	LFQH_LBB58_23
mov	w24, #0
mov	x0, x25
LFQH_LBB58_4:
cmp	x0, x19
b.eq	LFQH_LBB58_7
mov	x1, x27
bl	LFQH_Get
cbz	x0, LFQH_LBB58_23
cmp	w24, #7
add	w24, w24, #1
b.lo	LFQH_LBB58_4
b	LFQH_LBB58_23
LFQH_LBB58_7:
mov	x0, x25
bl	LFQH_ReaderBottomType
sub	w8, w0, #1
cmp	w8, #3
b.hs	LFQH_LBB58_10
mov	x26, x0
mov	x0, x25
bl	LFQH_ReaderBottomGlass
cmp	w26, #1
b.ne	LFQH_LBB58_11
mov	x0, x25
LFQH_Lloh1188:
adr x1, LFQH_SurfaceKey
LFQH_Lloh1189:
nop
bl Lpatch + (0xa628 - PATCH_BASE)
mov	x28, x0
b	LFQH_LBB58_12
LFQH_LBB58_10:
mov	x0, x25
bl	LFQH_PageRestore
mov	x0, x25
bl	LFQH_RestoreHit
LFQH_LBB58_11:
mov	x28, #0
LFQH_LBB58_12:
mov	x0, x25
LFQH_Lloh1190:
adr x1, LFQH_CatalogTapKey
LFQH_Lloh1191:
nop
bl Lpatch + (0xa628 - PATCH_BASE)
mov	x26, x0
cbnz	x28, LFQH_LBB58_15
cbz	x26, LFQH_LBB58_15
LFQH_Lloh1192:
adr x0, LFQH_l_.str.336
LFQH_Lloh1193:
nop
bl Lpatch + (0xa5a4 - PATCH_BASE)
mov	x1, x0
mov	x0, x25
mov	x2, x26
bl Lpatch + (0xa5d4 - PATCH_BASE)
mov	x0, x25
LFQH_Lloh1194:
adr x1, LFQH_CatalogTapKey
LFQH_Lloh1195:
nop
mov	x2, #0
mov	w3, #1
bl Lpatch + (0xa634 - PATCH_BASE)
b	LFQH_LBB58_23
LFQH_LBB58_15:
cbz	x28, LFQH_LBB58_21
cbnz	x26, LFQH_LBB58_21
LFQH_Lloh1196:
adr x0, LFQH_l_.str.386
LFQH_Lloh1197:
nop
bl Lpatch + (0xa5b0 - PATCH_BASE)
mov	x26, x0
cbnz	x0, LFQH_LBB58_20
LFQH_Lloh1198:
adr x0, LFQH_l_.str.308
LFQH_Lloh1199:
nop
bl Lpatch + (0xa5b0 - PATCH_BASE)
LFQH_Lloh1200:
adr x1, LFQH_l_.str.386
LFQH_Lloh1201:
nop
mov	x2, #0
bl Lpatch + (0xa61c - PATCH_BASE)
cbz	x0, LFQH_LBB58_22
mov	x26, x0
LFQH_Lloh1202:
adr x0, LFQH_l_.str.387
LFQH_Lloh1203:
nop
bl Lpatch + (0xa5a4 - PATCH_BASE)
mov	x1, x0
mov	x0, x26
LFQH_Lloh1204:
adr x2, LFQH_CatalogTapped
LFQH_Lloh1205:
nop
LFQH_Lloh1206:
adr x3, LFQH_l_.str.98
LFQH_Lloh1207:
nop
bl Lpatch + (0xa58c - PATCH_BASE)
LFQH_Lloh1208:
adr x0, LFQH_l_.str.311
LFQH_Lloh1209:
nop
bl Lpatch + (0xa5a4 - PATCH_BASE)
mov	x1, x0
mov	x0, x26
LFQH_Lloh1210:
adr x2, LFQH_CatalogTouch
LFQH_Lloh1211:
nop
LFQH_Lloh1212:
adr x3, LFQH_l_.str.312
LFQH_Lloh1213:
nop
bl Lpatch + (0xa58c - PATCH_BASE)
mov	x0, x26
bl Lpatch + (0xa610 - PATCH_BASE)
LFQH_LBB58_20:
LFQH_Lloh1214:
adr x0, LFQH_l_.str.231
LFQH_Lloh1215:
nop
bl Lpatch + (0xa5a4 - PATCH_BASE)
mov	x1, x0
mov	x0, x26
bl Lpatch + (0xa5d4 - PATCH_BASE)
mov	x26, x0
LFQH_Lloh1216:
adr x0, LFQH_l_.str.388
LFQH_Lloh1217:
nop
bl Lpatch + (0xa5b0 - PATCH_BASE)
mov	x23, x0
LFQH_Lloh1218:
adr x0, LFQH_l_.str.69
LFQH_Lloh1219:
nop
bl Lpatch + (0xa5a4 - PATCH_BASE)
mov	x1, x0
mov	x0, x23
bl Lpatch + (0xa5d4 - PATCH_BASE)
mov	x23, x0
LFQH_Lloh1220:
adr x0, LFQH_l_.str.340
LFQH_Lloh1221:
nop
bl Lpatch + (0xa5a4 - PATCH_BASE)
mov	x24, x0
LFQH_Lloh1222:
adr x0, LFQH_l_.str.387
LFQH_Lloh1223:
nop
bl Lpatch + (0xa5a4 - PATCH_BASE)
mov	x3, x0
mov	x0, x23
mov	x1, x24
mov	x2, x26
bl Lpatch + (0xa5d4 - PATCH_BASE)
mov	x23, x0
LFQH_Lloh1224:
adr x0, LFQH_l_.str.342
LFQH_Lloh1225:
nop
bl Lpatch + (0xa5a4 - PATCH_BASE)
mov	x1, x0
mov	x0, x23
mov	x2, x26
bl Lpatch + (0xa5d4 - PATCH_BASE)
LFQH_Lloh1226:
adr x0, LFQH_l_.str.389
LFQH_Lloh1227:
nop
bl Lpatch + (0xa5a4 - PATCH_BASE)
mov	x1, x0
mov	x0, x23
mov	w2, #0
bl Lpatch + (0xa5d4 - PATCH_BASE)
mov	x0, x23
LFQH_Lloh1228:
adr x24, LFQH_CatalogTapKey
LFQH_Lloh1229:
nop
mov	x1, x24
mov	x2, x26
mov	w3, #1
bl Lpatch + (0xa634 - PATCH_BASE)
mov	x0, x25
mov	x1, x24
mov	x2, x23
mov	w3, #1
bl Lpatch + (0xa634 - PATCH_BASE)
LFQH_Lloh1230:
adr x0, LFQH_l_.str.343
LFQH_Lloh1231:
nop
bl Lpatch + (0xa5a4 - PATCH_BASE)
mov	x1, x0
mov	x0, x25
mov	x2, x23
bl Lpatch + (0xa5d4 - PATCH_BASE)
LFQH_Lloh1232:
adr x24, LFQH_l_.str.55
LFQH_Lloh1233:
nop
mov	x0, x24
bl Lpatch + (0xa5a4 - PATCH_BASE)
mov	x1, x0
mov	x0, x23
bl Lpatch + (0xa5d4 - PATCH_BASE)
mov	x0, x24
bl Lpatch + (0xa5a4 - PATCH_BASE)
mov	x1, x0
mov	x0, x26
bl Lpatch + (0xa5d4 - PATCH_BASE)
b	LFQH_LBB58_22
LFQH_LBB58_21:
cbz	x28, LFQH_LBB58_23
LFQH_LBB58_22:
mov	x2, sp
mov	x0, x28
mov	x1, x19
bl	LFQH_IncludeMaterial
mov	x23, x25
LFQH_LBB58_23:
add	x22, x22, #1
cmp	x22, x21
b.ne	LFQH_LBB58_2
cbz	x23, LFQH_LBB58_26
ldp	d0, d1, [sp]
ldp	d2, d3, [sp, #16]
mov	x0, x19
ldp	x29, x30, [sp, #112]
ldp	x20, x19, [sp, #96]
ldp	x22, x21, [sp, #80]
ldp	x24, x23, [sp, #64]
ldp	x26, x25, [sp, #48]
ldp	x28, x27, [sp, #32]
add	sp, sp, #128
b	LFQH_EnsureHit
LFQH_LBB58_26:
mov	x0, x19
ldp	x29, x30, [sp, #112]
ldp	x20, x19, [sp, #96]
ldp	x22, x21, [sp, #80]
ldp	x24, x23, [sp, #64]
ldp	x26, x25, [sp, #48]
ldp	x28, x27, [sp, #32]
add	sp, sp, #128
b	LFQH_RestoreHit
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
LFQH_Lloh1234:
adr x0, LFQH_l_.str.94
LFQH_Lloh1235:
nop
LFQH_Lloh1236:
adr x1, LFQH_l_.str.95
LFQH_Lloh1237:
nop
bl	LFQH_Original
mov	x8, x0
mov	x0, x20
mov	x1, x19
blr	x8
bl	LFQH_ReaderBottomBackgroundEnabled
mov	x1, x0
mov	x0, x20
bl	LFQH_ReaderBackdrop
mov	x0, x20
ldp	x29, x30, [sp, #16]
ldp	x20, x19, [sp], #32
b	LFQH_ReaderProgressGlass
.cfi_endproc
.p2align	2
LFQH_PageProgressTheme:
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
LFQH_Lloh1238:
adr x0, LFQH_l_.str.94
LFQH_Lloh1239:
nop
LFQH_Lloh1240:
adr x1, LFQH_l_.str.97
LFQH_Lloh1241:
nop
bl	LFQH_Original
mov	x8, x0
mov	x0, x21
mov	x1, x20
mov	x2, x19
blr	x8
bl	LFQH_ReaderBottomBackgroundEnabled
mov	x1, x0
mov	x0, x21
bl	LFQH_ReaderBackdrop
mov	x0, x21
ldp	x29, x30, [sp, #32]
ldp	x20, x19, [sp, #16]
ldp	x22, x21, [sp], #48
b	LFQH_ReaderProgressGlass
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
LFQH_Lloh1242:
adr x0, LFQH_l_.str.99
LFQH_Lloh1243:
nop
LFQH_Lloh1244:
adr x1, LFQH_l_.str.100
LFQH_Lloh1245:
nop
bl	LFQH_Original
mov	x8, x0
mov	x0, x19
mov	x1, x20
blr	x8
LFQH_Lloh1246:
adr x1, LFQH_l_.str.57
LFQH_Lloh1247:
nop
mov	x0, x19
bl	LFQH_HasAncestor
cbz	w0, LFQH_LBB61_2
mov	x0, x19
ldp	x29, x30, [sp, #16]
ldp	x20, x19, [sp], #32
b	LFQH_ReaderBottomGlass
LFQH_LBB61_2:
mov	x0, x19
bl	LFQH_PageRestore
mov	x0, x19
ldp	x29, x30, [sp, #16]
ldp	x20, x19, [sp], #32
b	LFQH_RestoreHit
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
LFQH_Lloh1248:
adr x0, LFQH_l_.str.101
LFQH_Lloh1249:
nop
LFQH_Lloh1250:
adr x1, LFQH_l_.str.102
LFQH_Lloh1251:
nop
bl	LFQH_Original
mov	x8, x0
mov	x0, x19
mov	x1, x20
blr	x8
LFQH_Lloh1252:
adr x1, LFQH_l_.str.398
LFQH_Lloh1253:
nop
mov	x0, x19
bl	LFQH_Get
cbz	x0, LFQH_LBB62_2
ldp	x29, x30, [sp, #16]
ldp	x20, x19, [sp], #32
b	LFQH_FQHApply
LFQH_LBB62_2:
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
LFQH_Lloh1254:
adr x0, LFQH_l_.str.103
LFQH_Lloh1255:
nop
LFQH_Lloh1256:
adr x1, LFQH_l_.str.104
LFQH_Lloh1257:
nop
bl	LFQH_Original
mov	x8, x0
mov	x0, x20
mov	x1, x19
blr	x8
mov	x0, x20
ldp	x29, x30, [sp, #16]
ldp	x20, x19, [sp], #32
b	LFQH_FQHApply
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
LFQH_Lloh1258:
adr x0, LFQH_l_.str.105
LFQH_Lloh1259:
nop
LFQH_Lloh1260:
adr x1, LFQH_l_.str.106
LFQH_Lloh1261:
nop
bl	LFQH_Original
mov	x8, x0
mov	x0, x19
mov	x1, x20
blr	x8
LFQH_Lloh1262:
adr x20, LFQH_l_.str.20
LFQH_Lloh1263:
nop
mov	x0, x19
mov	x1, x20
bl	LFQH_Get
mov	x1, x20
bl	LFQH_Get
mov	x20, x0
LFQH_Lloh1264:
adr x1, LFQH_l_.str.109
LFQH_Lloh1265:
nop
bl	LFQH_Kind
cbz	w0, LFQH_LBB64_2
LFQH_Lloh1266:
adr x1, LFQH_l_.str.399
LFQH_Lloh1267:
nop
mov	x0, x20
bl	LFQH_Get
mov	x20, x0
LFQH_Lloh1268:
adr x0, LFQH_l_.str.400
LFQH_Lloh1269:
nop
bl Lpatch + (0xa5a4 - PATCH_BASE)
mov	x1, x0
mov	x0, x20
bl Lpatch + (0xa5d4 - PATCH_BASE)
cmp	x0, #1
b.eq	LFQH_LBB64_3
LFQH_LBB64_2:
LFQH_Lloh1270:
adr x1, LFQH_l_.str.107
LFQH_Lloh1271:
nop
mov	x0, x19
bl	LFQH_HasAncestor
cbz	w0, LFQH_LBB64_6
LFQH_LBB64_3:
LFQH_Lloh1272:
adr x1, LFQH_SurfaceKey
LFQH_Lloh1273:
nop
mov	x0, x19
bl Lpatch + (0xa628 - PATCH_BASE)
cbz	x0, LFQH_LBB64_5
mov	x0, x19
ldp	x29, x30, [sp, #16]
ldp	x20, x19, [sp], #32
b	LFQH_PageRestore
LFQH_LBB64_5:
ldp	x29, x30, [sp, #16]
ldp	x20, x19, [sp], #32
ret
LFQH_LBB64_6:
mov	x0, x19
ldp	x29, x30, [sp, #16]
ldp	x20, x19, [sp], #32
b	LFQH_FQHApply
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
LFQH_Lloh1274:
adr x0, LFQH_l_.str.107
LFQH_Lloh1275:
nop
LFQH_Lloh1276:
adr x1, LFQH_l_.str.108
LFQH_Lloh1277:
nop
bl	LFQH_Original
mov	x8, x0
mov	x0, x19
mov	x1, x20
blr	x8
LFQH_Lloh1278:
adr x1, LFQH_l_.str.105
LFQH_Lloh1279:
nop
mov	x0, x19
bl	LFQH_HasAncestor
cbz	w0, LFQH_LBB65_2
mov	x0, x19
ldp	x29, x30, [sp, #16]
ldp	x20, x19, [sp], #32
b	LFQH_PageRestore
LFQH_LBB65_2:
mov	x0, x19
ldp	x29, x30, [sp, #16]
ldp	x20, x19, [sp], #32
b	LFQH_FQHApply
.cfi_endproc
.p2align	2
LFQH_PageChapterCardLayout:
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
adr x0, LFQH_l_.str.109
LFQH_Lloh1281:
nop
LFQH_Lloh1282:
adr x1, LFQH_l_.str.110
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
b	LFQH_ChapterDiscussionGlass
.cfi_endproc
.p2align	2
LFQH_PageChapterCardTheme:
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
LFQH_Lloh1284:
adr x0, LFQH_l_.str.109
LFQH_Lloh1285:
nop
LFQH_Lloh1286:
adr x1, LFQH_l_.str.112
LFQH_Lloh1287:
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
b	LFQH_ChapterDiscussionGlass
.cfi_endproc
.p2align	2
LFQH_PageChapterButtonLayout:
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
LFQH_Lloh1288:
adr x0, LFQH_l_.str.113
LFQH_Lloh1289:
nop
LFQH_Lloh1290:
adr x1, LFQH_l_.str.114
LFQH_Lloh1291:
nop
bl	LFQH_Original
mov	x8, x0
mov	x0, x19
mov	x1, x20
blr	x8
LFQH_Lloh1292:
adr x1, LFQH_l_.str.115
LFQH_Lloh1293:
nop
mov	x0, x19
bl	LFQH_Kind
cbz	w0, LFQH_LBB68_2
mov	x0, x19
ldp	x29, x30, [sp, #16]
ldp	x20, x19, [sp], #32
b	LFQH_ChapterRewardGlass
LFQH_LBB68_2:
ldp	x29, x30, [sp, #16]
ldp	x20, x19, [sp], #32
ret
.cfi_endproc
.p2align	2
LFQH_PageChapterRewardTheme:
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
LFQH_Lloh1294:
adr x0, LFQH_l_.str.115
LFQH_Lloh1295:
nop
LFQH_Lloh1296:
adr x1, LFQH_l_.str.117
LFQH_Lloh1297:
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
b	LFQH_ChapterRewardGlass
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
LFQH_Lloh1298:
adr x0, LFQH_l_.str.118
LFQH_Lloh1299:
nop
LFQH_Lloh1300:
adr x1, LFQH_l_.str.119
LFQH_Lloh1301:
nop
bl	LFQH_Original
mov	x8, x0
mov	x0, x20
mov	x1, x19
blr	x8
LFQH_Lloh1302:
adr x1, LFQH_l_.str.84
LFQH_Lloh1303:
nop
mov	x0, x20
bl	LFQH_Get
mov	x19, x0
LFQH_Lloh1304:
adr x1, LFQH_l_.str.234
LFQH_Lloh1305:
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
LFQH_Lloh1306:
adr x0, LFQH_l_.str.118
LFQH_Lloh1307:
nop
LFQH_Lloh1308:
adr x1, LFQH_l_.str.121
LFQH_Lloh1309:
nop
bl	LFQH_Original
mov	x8, x0
mov	x0, x21
mov	x1, x20
mov	x2, x19
blr	x8
LFQH_Lloh1310:
adr x1, LFQH_l_.str.234
LFQH_Lloh1311:
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
LFQH_Lloh1312:
adr x0, LFQH_l_.str.122
LFQH_Lloh1313:
nop
LFQH_Lloh1314:
adr x1, LFQH_l_.str.123
LFQH_Lloh1315:
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
LFQH_Lloh1316:
adr x0, LFQH_l_.str.122
LFQH_Lloh1317:
nop
LFQH_Lloh1318:
adr x1, LFQH_l_.str.125
LFQH_Lloh1319:
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
LFQH_Lloh1320:
adr x0, LFQH_l_.str.122
LFQH_Lloh1321:
nop
LFQH_Lloh1322:
adr x1, LFQH_l_.str.127
LFQH_Lloh1323:
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
LFQH_ShelfFilterHeaderLayout:
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
mov	x20, x1
mov	x19, x0
LFQH_Lloh1324:
adr x0, LFQH_l_.str.128
LFQH_Lloh1325:
nop
LFQH_Lloh1326:
adr x1, LFQH_l_.str.129
LFQH_Lloh1327:
nop
bl	LFQH_Original
mov	x8, x0
mov	x0, x19
mov	x1, x20
blr	x8
LFQH_Lloh1328:
adr x1, LFQH_l_.str.407
LFQH_Lloh1329:
nop
mov	x0, x19
bl	LFQH_Get
cbz	x0, LFQH_LBB75_5
mov	x20, x0
mov	w22, #0
LFQH_Lloh1330:
adr x21, LFQH_l_.str.20
LFQH_Lloh1331:
nop
LFQH_LBB75_2:
cmp	x0, x19
b.eq	LFQH_LBB75_6
mov	x1, x21
bl	LFQH_Get
cbz	x0, LFQH_LBB75_5
cmp	w22, #7
add	w22, w22, #1
b.lo	LFQH_LBB75_2
LFQH_LBB75_5:
ldp	x29, x30, [sp, #32]
ldp	x20, x19, [sp, #16]
ldp	x22, x21, [sp], #48
ret
LFQH_LBB75_6:
mov	x0, x20
ldp	x29, x30, [sp, #32]
ldp	x20, x19, [sp, #16]
ldp	x22, x21, [sp], #48
b	LFQH_ShelfActionGlass
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
mov	x20, x1
mov	x19, x0
LFQH_Lloh1332:
adr x0, LFQH_l_.str.130
LFQH_Lloh1333:
nop
LFQH_Lloh1334:
adr x1, LFQH_l_.str.131
LFQH_Lloh1335:
nop
bl	LFQH_Original
mov	x8, x0
mov	x0, x19
mov	x1, x20
blr	x8
LFQH_Lloh1336:
adr x1, LFQH_l_.str.10
LFQH_Lloh1337:
nop
mov	x0, x19
bl	LFQH_Get
bl	LFQH_FQHHeader
bl	LFQH_Enabled
cbz	w0, LFQH_LBB76_3
bl	LFQH_FQHGlassAvailable
tbz	w0, #0, LFQH_LBB76_3
LFQH_Lloh1338:
adr x1, LFQH_l_.str.408
LFQH_Lloh1339:
nop
mov	x0, x19
bl	LFQH_Get
mov	x1, x0
LFQH_Lloh1340:
adr x2, LFQH_ProfileScanKey
LFQH_Lloh1341:
nop
mov	x0, x19
bl	LFQH_ProfileIconGlass
LFQH_Lloh1342:
adr x1, LFQH_l_.str.409
LFQH_Lloh1343:
nop
mov	x0, x19
bl	LFQH_Get
mov	x1, x0
LFQH_Lloh1344:
adr x2, LFQH_ProfileNightKey
LFQH_Lloh1345:
nop
mov	x0, x19
bl	LFQH_ProfileIconGlass
LFQH_Lloh1346:
adr x1, LFQH_l_.str.410
LFQH_Lloh1347:
nop
mov	x0, x19
bl	LFQH_Get
mov	x1, x0
b	LFQH_LBB76_4
LFQH_LBB76_3:
LFQH_Lloh1348:
adr x2, LFQH_ProfileScanKey
LFQH_Lloh1349:
nop
mov	x0, x19
mov	x1, #0
bl	LFQH_ProfileIconGlass
LFQH_Lloh1350:
adr x2, LFQH_ProfileNightKey
LFQH_Lloh1351:
nop
mov	x0, x19
mov	x1, #0
bl	LFQH_ProfileIconGlass
mov	x1, #0
LFQH_LBB76_4:
LFQH_Lloh1352:
adr x2, LFQH_ProfileMenuKey
LFQH_Lloh1353:
nop
mov	x0, x19
ldp	x29, x30, [sp, #16]
ldp	x20, x19, [sp], #32
b	LFQH_ProfileIconGlass
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
LFQH_Lloh1354:
adr x0, LFQH_l_.str.132
LFQH_Lloh1355:
nop
LFQH_Lloh1356:
adr x1, LFQH_l_.str.133
LFQH_Lloh1357:
nop
bl	LFQH_Original
mov	x8, x0
mov	x0, x19
mov	x1, x20
blr	x8
LFQH_Lloh1358:
adr x1, LFQH_l_.str.411
LFQH_Lloh1359:
nop
mov	x0, x19
bl	LFQH_Kind
tbz	w0, #0, LFQH_LBB77_2
ldp	x29, x30, [sp, #16]
ldp	x20, x19, [sp], #32
ret
LFQH_LBB77_2:
mov	x0, x19
mov	w1, #0
ldp	x29, x30, [sp, #16]
ldp	x20, x19, [sp], #32
b	LFQH_ProfileEntryGlass
.cfi_endproc
.p2align	2
LFQH_PageProfileOrderLayout:
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
LFQH_Lloh1360:
adr x0, LFQH_l_.str.134
LFQH_Lloh1361:
nop
LFQH_Lloh1362:
adr x1, LFQH_l_.str.135
LFQH_Lloh1363:
nop
bl	LFQH_Original
mov	x8, x0
mov	x0, x19
mov	x1, x20
blr	x8
LFQH_Lloh1364:
adr x1, LFQH_l_.str.411
LFQH_Lloh1365:
nop
mov	x0, x19
bl	LFQH_Kind
cbz	w0, LFQH_LBB78_2
mov	x0, x19
mov	w1, #1
ldp	x29, x30, [sp, #16]
ldp	x20, x19, [sp], #32
b	LFQH_ProfileEntryGlass
LFQH_LBB78_2:
ldp	x29, x30, [sp, #16]
ldp	x20, x19, [sp], #32
ret
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
LFQH_Lloh1366:
adr x0, LFQH_l_.str.65
LFQH_Lloh1367:
nop
LFQH_Lloh1368:
adr x1, LFQH_l_.str.137
LFQH_Lloh1369:
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
LFQH_MineConfiguredEntrances:
.cfi_startproc
sub	sp, sp, #112
stp	x28, x27, [sp, #16]
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
.cfi_offset w27, -88
.cfi_offset w28, -96
str	x3, [sp, #8]
mov	x22, x2
mov	x20, x1
mov	x21, x0
LFQH_Lloh1370:
adr x1, LFQH_l_.str.33
LFQH_Lloh1371:
nop
mov	x0, x2
bl	LFQH_Kind
cbz	w0, LFQH_LBB80_9
LFQH_Lloh1372:
adr x0, LFQH_l_.str.34
LFQH_Lloh1373:
nop
bl Lpatch + (0xa5a4 - PATCH_BASE)
mov	x1, x0
mov	x0, x22
bl Lpatch + (0xa5d4 - PATCH_BASE)
cbz	x0, LFQH_LBB80_9
mov	x23, #0
sub	x24, x0, #1
LFQH_Lloh1374:
adr x25, LFQH_l_.str.264
LFQH_Lloh1375:
nop
LFQH_Lloh1376:
adr x26, LFQH_l_.str.418
LFQH_Lloh1377:
nop
LFQH_Lloh1378:
adr x27, LFQH_l_.str.419
LFQH_Lloh1379:
nop
LFQH_Lloh1380:
adr x28, LFQH_l_.str.422
LFQH_Lloh1381:
nop
LFQH_LBB80_3:
mov	x0, x25
bl Lpatch + (0xa5a4 - PATCH_BASE)
mov	x1, x0
mov	x0, x22
mov	x2, x24
bl Lpatch + (0xa5d4 - PATCH_BASE)
mov	x19, x0
mov	x1, x26
bl	LFQH_Kind
cbz	w0, LFQH_LBB80_8
mov	x0, x27
bl Lpatch + (0xa5a4 - PATCH_BASE)
mov	x1, x0
mov	x0, x19
bl Lpatch + (0xa5d4 - PATCH_BASE)
cmp	w0, #9
b.ne	LFQH_LBB80_8
cbnz	x23, LFQH_LBB80_7
LFQH_Lloh1382:
adr x0, LFQH_l_.str.420
LFQH_Lloh1383:
nop
bl Lpatch + (0xa5a4 - PATCH_BASE)
mov	x1, x0
mov	x0, x22
bl Lpatch + (0xa5d4 - PATCH_BASE)
mov	x19, x0
LFQH_Lloh1384:
adr x0, LFQH_l_.str.421
LFQH_Lloh1385:
nop
bl Lpatch + (0xa5a4 - PATCH_BASE)
mov	x1, x0
mov	x0, x19
bl Lpatch + (0xa5d4 - PATCH_BASE)
mov	x23, x0
LFQH_LBB80_7:
mov	x0, x28
bl Lpatch + (0xa5a4 - PATCH_BASE)
mov	x1, x0
mov	x0, x23
mov	x2, x24
bl Lpatch + (0xa5d4 - PATCH_BASE)
LFQH_LBB80_8:
sub	x24, x24, #1
cmn	x24, #1
b.ne	LFQH_LBB80_3
b	LFQH_LBB80_10
LFQH_LBB80_9:
mov	x23, #0
LFQH_LBB80_10:
LFQH_Lloh1386:
adr x0, LFQH_l_.str.138
LFQH_Lloh1387:
nop
LFQH_Lloh1388:
adr x1, LFQH_l_.str.140
LFQH_Lloh1389:
nop
bl	LFQH_Original
mov	x8, x0
cmp	x23, #0
csel	x2, x22, x23, eq
mov	x0, x21
mov	x1, x20
ldr	x3, [sp, #8]
blr	x8
cbz	x23, LFQH_LBB80_12
LFQH_Lloh1390:
adr x0, LFQH_l_.str.138
LFQH_Lloh1391:
nop
LFQH_Lloh1392:
adr x1, LFQH_l_.str.423
LFQH_Lloh1393:
nop
ldp	x29, x30, [sp, #96]
ldp	x20, x19, [sp, #80]
ldp	x22, x21, [sp, #64]
ldp	x24, x23, [sp, #48]
ldp	x26, x25, [sp, #32]
ldp	x28, x27, [sp, #16]
add	sp, sp, #112
b	LFQH_RecordMineGameRemoval
LFQH_LBB80_12:
ldp	x29, x30, [sp, #96]
ldp	x20, x19, [sp, #80]
ldp	x22, x21, [sp, #64]
ldp	x24, x23, [sp, #48]
ldp	x26, x25, [sp, #32]
ldp	x28, x27, [sp, #16]
add	sp, sp, #112
ret
.cfi_endproc
.p2align	2
LFQH_MineListObjects:
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
mov	x19, x2
mov	x21, x1
mov	x20, x0
LFQH_Lloh1394:
adr x0, LFQH_l_.str.142
LFQH_Lloh1395:
nop
LFQH_Lloh1396:
adr x1, LFQH_l_.str.144
LFQH_Lloh1397:
nop
bl	LFQH_Original
mov	x8, x0
mov	x0, x20
mov	x1, x21
mov	x2, x19
blr	x8
mov	x19, x0
LFQH_Lloh1398:
adr x1, LFQH_l_.str.33
LFQH_Lloh1399:
nop
bl	LFQH_Kind
cbz	w0, LFQH_LBB81_20
LFQH_Lloh1400:
adr x0, LFQH_l_.str.142
LFQH_Lloh1401:
nop
bl Lpatch + (0xa5b0 - PATCH_BASE)
mov	x21, x0
LFQH_Lloh1402:
adr x1, LFQH_MineControllersKey
LFQH_Lloh1403:
nop
bl Lpatch + (0xa628 - PATCH_BASE)
mov	x22, x0
cbnz	x0, LFQH_LBB81_3
LFQH_Lloh1404:
adr x0, LFQH_l_.str.337
LFQH_Lloh1405:
nop
bl Lpatch + (0xa5b0 - PATCH_BASE)
mov	x22, x0
LFQH_Lloh1406:
adr x0, LFQH_l_.str.338
LFQH_Lloh1407:
nop
bl Lpatch + (0xa5a4 - PATCH_BASE)
mov	x1, x0
mov	x0, x22
bl Lpatch + (0xa5d4 - PATCH_BASE)
mov	x22, x0
LFQH_Lloh1408:
adr x1, LFQH_MineControllersKey
LFQH_Lloh1409:
nop
mov	x0, x21
mov	x2, x22
mov	w3, #1
bl Lpatch + (0xa634 - PATCH_BASE)
LFQH_LBB81_3:
LFQH_Lloh1410:
adr x0, LFQH_l_.str.221
LFQH_Lloh1411:
nop
bl Lpatch + (0xa5a4 - PATCH_BASE)
mov	x1, x0
mov	x0, x22
mov	x2, x20
bl Lpatch + (0xa5d4 - PATCH_BASE)
LFQH_Lloh1412:
adr x0, LFQH_l_.str.182
LFQH_Lloh1413:
nop
bl Lpatch + (0xa5b0 - PATCH_BASE)
mov	x20, x0
LFQH_Lloh1414:
adr x0, LFQH_l_.str.183
LFQH_Lloh1415:
nop
bl Lpatch + (0xa5a4 - PATCH_BASE)
mov	x1, x0
LFQH_Lloh1416:
adr x2, LFQH_l_.str.368
LFQH_Lloh1417:
nop
mov	x0, x20
bl Lpatch + (0xa5d4 - PATCH_BASE)
bl	LFQH_DefaultEnabled
mov	x20, x0
LFQH_Lloh1418:
adr x0, LFQH_l_.str.34
LFQH_Lloh1419:
nop
bl Lpatch + (0xa5a4 - PATCH_BASE)
mov	x1, x0
mov	x0, x19
bl Lpatch + (0xa5d4 - PATCH_BASE)
cbz	x0, LFQH_LBB81_18
mov	w28, #0
mov	x22, #0
sub	x21, x0, #1
LFQH_Lloh1420:
adr x23, LFQH_l_.str.264
LFQH_Lloh1421:
nop
LFQH_Lloh1422:
adr x27, LFQH_l_.str.421
LFQH_Lloh1423:
nop
LFQH_Lloh1424:
adr x26, LFQH_l_.str.422
LFQH_Lloh1425:
nop
LFQH_LBB81_5:
mov	x0, x23
bl Lpatch + (0xa5a4 - PATCH_BASE)
mov	x1, x0
mov	x0, x19
mov	x2, x21
bl Lpatch + (0xa5d4 - PATCH_BASE)
mov	x24, x0
bl	LFQH_MineStandaloneGameRow
mov	x25, x0
tbz	w0, #0, LFQH_LBB81_9
LFQH_LBB81_6:
cbnz	x22, LFQH_LBB81_8
LFQH_Lloh1426:
adr x0, LFQH_l_.str.420
LFQH_Lloh1427:
nop
bl Lpatch + (0xa5a4 - PATCH_BASE)
mov	x1, x0
mov	x0, x19
bl Lpatch + (0xa5d4 - PATCH_BASE)
mov	x22, x0
mov	x0, x27
bl Lpatch + (0xa5a4 - PATCH_BASE)
mov	x1, x0
mov	x0, x22
bl Lpatch + (0xa5d4 - PATCH_BASE)
mov	x22, x0
LFQH_LBB81_8:
orr	w28, w25, w28
mov	x0, x26
bl Lpatch + (0xa5a4 - PATCH_BASE)
mov	x1, x0
mov	x0, x22
mov	x2, x21
bl Lpatch + (0xa5d4 - PATCH_BASE)
b	LFQH_LBB81_10
LFQH_LBB81_9:
cbz	w20, LFQH_LBB81_11
LFQH_LBB81_10:
sub	x21, x21, #1
cmn	x21, #1
b.eq	LFQH_LBB81_16
b	LFQH_LBB81_5
LFQH_LBB81_11:
mov	x0, x24
LFQH_Lloh1428:
adr x1, LFQH_l_.str.138
LFQH_Lloh1429:
nop
bl	LFQH_Kind
cbz	w0, LFQH_LBB81_10
LFQH_Lloh1430:
adr x0, LFQH_l_.str.425
LFQH_Lloh1431:
nop
bl Lpatch + (0xa5a4 - PATCH_BASE)
mov	x1, x0
mov	x0, x24
bl Lpatch + (0xa5d4 - PATCH_BASE)
and	x8, x0, #0xfffffffffffffffe
cmp	x8, #4
b.eq	LFQH_LBB81_6
cbnz	x0, LFQH_LBB81_10
mov	x0, x24
LFQH_Lloh1432:
adr x1, LFQH_l_.str.426
LFQH_Lloh1433:
nop
bl	LFQH_BoolProp
cbnz	w0, LFQH_LBB81_6
mov	x0, x24
LFQH_Lloh1434:
adr x1, LFQH_l_.str.427
LFQH_Lloh1435:
nop
bl	LFQH_BoolProp
cbz	w0, LFQH_LBB81_6
b	LFQH_LBB81_10
LFQH_LBB81_16:
tst	w28, #0xff
b.eq	LFQH_LBB81_19
LFQH_Lloh1436:
adr x0, LFQH_l_.str.142
LFQH_Lloh1437:
nop
LFQH_Lloh1438:
adr x1, LFQH_l_.str.424
LFQH_Lloh1439:
nop
bl	LFQH_RecordMineGameRemoval
b	LFQH_LBB81_19
LFQH_LBB81_18:
mov	x22, #0
LFQH_LBB81_19:
cmp	x22, #0
csel	x19, x19, x22, eq
LFQH_LBB81_20:
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
LFQH_ShelfDurationVisible:
.cfi_startproc
sub	sp, sp, #64
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
mov	x20, x2
mov	x19, x0
LFQH_Lloh1440:
adr x1, LFQH_ShelfDurationRequestedKey
LFQH_Lloh1441:
nop
bl Lpatch + (0xa628 - PATCH_BASE)
cbnz	x0, LFQH_LBB82_4
LFQH_Lloh1442:
adr x0, LFQH_l_.str.21
LFQH_Lloh1443:
nop
bl Lpatch + (0xa5b0 - PATCH_BASE)
mov	x21, x0
LFQH_Lloh1444:
adr x1, LFQH_ShelfDurationHeadersKey
LFQH_Lloh1445:
nop
bl Lpatch + (0xa628 - PATCH_BASE)
mov	x22, x0
cbnz	x0, LFQH_LBB82_3
LFQH_Lloh1446:
adr x0, LFQH_l_.str.337
LFQH_Lloh1447:
nop
bl Lpatch + (0xa5b0 - PATCH_BASE)
mov	x22, x0
LFQH_Lloh1448:
adr x0, LFQH_l_.str.338
LFQH_Lloh1449:
nop
bl Lpatch + (0xa5a4 - PATCH_BASE)
mov	x1, x0
mov	x0, x22
bl Lpatch + (0xa5d4 - PATCH_BASE)
mov	x22, x0
LFQH_Lloh1450:
adr x1, LFQH_ShelfDurationHeadersKey
LFQH_Lloh1451:
nop
mov	x0, x21
mov	x2, x22
mov	w3, #1
bl Lpatch + (0xa634 - PATCH_BASE)
LFQH_LBB82_3:
LFQH_Lloh1452:
adr x0, LFQH_l_.str.221
LFQH_Lloh1453:
nop
bl Lpatch + (0xa5a4 - PATCH_BASE)
mov	x1, x0
mov	x0, x22
mov	x2, x19
bl Lpatch + (0xa5d4 - PATCH_BASE)
LFQH_LBB82_4:
LFQH_Lloh1454:
adr x0, LFQH_l_.str.205
LFQH_Lloh1455:
nop
bl Lpatch + (0xa5b0 - PATCH_BASE)
mov	x21, x0
LFQH_Lloh1456:
adr x0, LFQH_l_.str.271
LFQH_Lloh1457:
nop
bl Lpatch + (0xa5a4 - PATCH_BASE)
mov	x1, x0
mov	x0, x21
mov	x2, x20
bl Lpatch + (0xa5d4 - PATCH_BASE)
mov	x2, x0
LFQH_Lloh1458:
adr x1, LFQH_ShelfDurationRequestedKey
LFQH_Lloh1459:
nop
mov	x0, x19
mov	w3, #1
bl Lpatch + (0xa634 - PATCH_BASE)
cbz	w20, LFQH_LBB82_6
LFQH_Lloh1460:
adr x0, LFQH_l_.str.182
LFQH_Lloh1461:
nop
bl Lpatch + (0xa5b0 - PATCH_BASE)
mov	x20, x0
LFQH_Lloh1462:
adr x0, LFQH_l_.str.183
LFQH_Lloh1463:
nop
bl Lpatch + (0xa5a4 - PATCH_BASE)
mov	x1, x0
LFQH_Lloh1464:
adr x2, LFQH_l_.str.367
LFQH_Lloh1465:
nop
mov	x0, x20
bl Lpatch + (0xa5d4 - PATCH_BASE)
bl	LFQH_DefaultEnabled
cmp	w0, #0
cset	w20, ne
LFQH_LBB82_6:
LFQH_Lloh1466:
adr x0, LFQH_l_.str.21
LFQH_Lloh1467:
nop
LFQH_Lloh1468:
adr x1, LFQH_l_.str.147
LFQH_Lloh1469:
nop
bl	LFQH_Original
str	x0, [sp, #8]
LFQH_Lloh1470:
adr x0, LFQH_l_.str.146
LFQH_Lloh1471:
nop
bl Lpatch + (0xa5a4 - PATCH_BASE)
mov	x1, x0
mov	x0, x19
mov	x2, x20
ldr	x3, [sp, #8]
ldp	x29, x30, [sp, #48]
ldp	x20, x19, [sp, #32]
ldp	x22, x21, [sp, #16]
add	sp, sp, #64
br	x3
.cfi_endproc
.p2align	2
LFQH_ShelfDurationLayout:
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
mov	x20, x1
mov	x19, x0
LFQH_Lloh1472:
adr x1, LFQH_ShelfDurationRequestedKey
LFQH_Lloh1473:
nop
bl Lpatch + (0xa628 - PATCH_BASE)
cbnz	x0, LFQH_LBB83_2
LFQH_Lloh1474:
adr x0, LFQH_l_.str.296
LFQH_Lloh1475:
nop
bl Lpatch + (0xa5a4 - PATCH_BASE)
mov	x1, x0
mov	x0, x19
bl Lpatch + (0xa5d4 - PATCH_BASE)
mov	x2, x0
mov	x0, x19
bl	LFQH_ShelfDurationVisible
LFQH_LBB83_2:
LFQH_Lloh1476:
adr x0, LFQH_l_.str.21
LFQH_Lloh1477:
nop
LFQH_Lloh1478:
adr x1, LFQH_l_.str.148
LFQH_Lloh1479:
nop
bl	LFQH_Original
mov	x8, x0
mov	x0, x19
mov	x1, x20
blr	x8
LFQH_Lloh1480:
adr x1, LFQH_l_.str.301
LFQH_Lloh1481:
nop
mov	x0, x19
bl	LFQH_Get
mov	x20, x0
LFQH_Lloh1482:
adr x1, LFQH_l_.str.39
LFQH_Lloh1483:
nop
bl	LFQH_Get
mov	x21, x0
LFQH_Lloh1484:
adr x1, LFQH_l_.str.23
LFQH_Lloh1485:
nop
bl	LFQH_Kind
cbz	w0, LFQH_LBB83_4
mov	x0, x20
mov	x1, x21
bl	LFQH_ShelfEditPlacement
mov	x22, x0
LFQH_Lloh1486:
adr x1, LFQH_l_.str.37
LFQH_Lloh1487:
nop
mov	x0, x20
bl	LFQH_Get
mov	x23, x0
LFQH_Lloh1488:
adr x1, LFQH_l_.str.38
LFQH_Lloh1489:
nop
mov	x0, x20
bl	LFQH_Get
mov	x2, x0
mov	x0, x21
mov	x1, x23
mov	x3, x22
bl	LFQH_ShelfTopHit
cbnz	x22, LFQH_LBB83_5
LFQH_LBB83_4:
LFQH_Lloh1490:
adr x1, LFQH_l_.str.293
LFQH_Lloh1491:
nop
mov	x0, x19
bl	LFQH_Get
bl	LFQH_ShelfActionGlass
LFQH_LBB83_5:
LFQH_Lloh1492:
adr x1, LFQH_l_.str.407
LFQH_Lloh1493:
nop
mov	x0, x19
bl	LFQH_Get
bl	LFQH_ShelfActionGlass
LFQH_Lloh1494:
adr x1, LFQH_l_.str.428
LFQH_Lloh1495:
nop
mov	x0, x19
bl	LFQH_Get
ldp	x29, x30, [sp, #48]
ldp	x20, x19, [sp, #32]
ldp	x22, x21, [sp, #16]
ldp	x24, x23, [sp], #64
b	LFQH_ShelfActionGlass
.cfi_endproc
.p2align	2
LFQH_ShelfFunctionSize:
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
mov	x19, x4
mov	x21, x3
mov	x22, x2
mov	x23, x1
mov	x20, x0
LFQH_Lloh1496:
adr x0, LFQH_l_.str.149
LFQH_Lloh1497:
nop
LFQH_Lloh1498:
adr x1, LFQH_l_.str.151
LFQH_Lloh1499:
nop
bl	LFQH_Original
mov	x8, x0
mov	x0, x20
mov	x1, x23
mov	x2, x22
mov	x3, x21
mov	x4, x19
blr	x8
mov.16b	v8, v0
mov.16b	v9, v1
LFQH_Lloh1500:
adr x1, LFQH_ShelfCompactKey
LFQH_Lloh1501:
nop
mov	x0, x20
bl Lpatch + (0xa628 - PATCH_BASE)
cbz	x0, LFQH_LBB84_4
fmov	d0, #6.00000000
fcmp	d9, d0
b.le	LFQH_LBB84_4
LFQH_Lloh1502:
adr x1, LFQH_l_.str.429
LFQH_Lloh1503:
nop
mov	x0, x20
bl	LFQH_Get
mov	x20, x0
LFQH_Lloh1504:
adr x0, LFQH_l_.str.430
LFQH_Lloh1505:
nop
bl Lpatch + (0xa5a4 - PATCH_BASE)
mov	x1, x0
mov	x0, x19
bl Lpatch + (0xa5d4 - PATCH_BASE)
mov	x19, x0
LFQH_Lloh1506:
adr x0, LFQH_l_.str.431
LFQH_Lloh1507:
nop
bl Lpatch + (0xa5a4 - PATCH_BASE)
mov	x1, x0
mov	x0, x20
mov	x2, x19
bl Lpatch + (0xa5d4 - PATCH_BASE)
cmp	x0, #1
b.ne	LFQH_LBB84_4
LFQH_Lloh1508:
adr x0, LFQH_l_.str.153
LFQH_Lloh1509:
nop
bl Lpatch + (0xa5b0 - PATCH_BASE)
mov	x19, x0
LFQH_Lloh1510:
adr x0, LFQH_l_.str.432
LFQH_Lloh1511:
nop
bl Lpatch + (0xa5a4 - PATCH_BASE)
mov	x1, x0
mov	x0, x19
mov	w2, #0
bl Lpatch + (0xa5d4 - PATCH_BASE)
fsub	d1, d9, d0
fmov	d2, #-12.00000000
fadd	d1, d1, d2
fmov	d2, #2.00000000
fadd	d1, d1, d2
fcmp	d9, d0
fmov	d0, #6.00000000
fcsel	d9, d1, d0, gt
LFQH_LBB84_4:
mov.16b	v0, v8
mov.16b	v1, v9
ldp	x29, x30, [sp, #64]
ldp	x20, x19, [sp, #48]
ldp	x22, x21, [sp, #32]
ldp	x24, x23, [sp, #16]
ldp	d9, d8, [sp], #80
ret
.cfi_endproc
.p2align	2
LFQH_ShelfFunctionLayout:
.cfi_startproc
stp	d13, d12, [sp, #-80]!
stp	d11, d10, [sp, #16]
stp	d9, d8, [sp, #32]
stp	x20, x19, [sp, #48]
stp	x29, x30, [sp, #64]
add	x29, sp, #64
.cfi_def_cfa w29, 16
.cfi_offset w30, -8
.cfi_offset w29, -16
.cfi_offset w19, -24
.cfi_offset w20, -32
.cfi_offset b8, -40
.cfi_offset b9, -48
.cfi_offset b10, -56
.cfi_offset b11, -64
.cfi_offset b12, -72
.cfi_offset b13, -80
mov	x20, x1
mov	x19, x0
LFQH_Lloh1512:
adr x0, LFQH_l_.str.153
LFQH_Lloh1513:
nop
LFQH_Lloh1514:
adr x1, LFQH_l_.str.155
LFQH_Lloh1515:
nop
bl	LFQH_Original
mov	x8, x0
mov	x0, x19
mov	x1, x20
blr	x8
LFQH_Lloh1516:
adr x1, LFQH_l_.str.301
LFQH_Lloh1517:
nop
mov	x0, x19
bl	LFQH_Get
LFQH_Lloh1518:
adr x1, LFQH_ShelfCompactKey
LFQH_Lloh1519:
nop
bl Lpatch + (0xa628 - PATCH_BASE)
cmp	x0, x19
b.ne	LFQH_LBB85_3
LFQH_Lloh1520:
adr x1, LFQH_l_.str.433
LFQH_Lloh1521:
nop
mov	x0, x19
bl	LFQH_Get
mov	x20, x0
LFQH_Lloh1522:
adr x0, LFQH_l_.str.192
LFQH_Lloh1523:
nop
bl Lpatch + (0xa5a4 - PATCH_BASE)
mov	x1, x0
mov	x0, x20
bl Lpatch + (0xa5d4 - PATCH_BASE)
mov.16b	v8, v0
mov.16b	v12, v1
mov.16b	v9, v2
mov.16b	v10, v3
LFQH_Lloh1524:
adr x0, LFQH_l_.str.434
LFQH_Lloh1525:
nop
bl Lpatch + (0xa5a4 - PATCH_BASE)
mov	x1, x0
mov	x0, x19
bl Lpatch + (0xa5d4 - PATCH_BASE)
cmp	w0, #0
fmov	d0, #2.00000000
fmov	d1, #18.00000000
fcsel	d11, d1, d0, eq
fcmp	d12, d11
b.le	LFQH_LBB85_3
LFQH_Lloh1526:
adr x0, LFQH_l_.str.71
LFQH_Lloh1527:
nop
bl Lpatch + (0xa5a4 - PATCH_BASE)
mov	x1, x0
mov	x0, x20
mov.16b	v0, v8
mov.16b	v1, v11
mov.16b	v2, v9
mov.16b	v3, v10
ldp	x29, x30, [sp, #64]
ldp	x20, x19, [sp, #48]
ldp	d9, d8, [sp, #32]
ldp	d11, d10, [sp, #16]
ldp	d13, d12, [sp], #80
b Lpatch + (0xa5d4 - PATCH_BASE)
LFQH_LBB85_3:
ldp	x29, x30, [sp, #64]
ldp	x20, x19, [sp, #48]
ldp	d9, d8, [sp, #32]
ldp	d11, d10, [sp, #16]
ldp	d13, d12, [sp], #80
ret
.cfi_endproc
.p2align	2
LFQH_TabPlan:
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
mov	x20, x1
mov	x19, x0
LFQH_Lloh1528:
adr x0, LFQH_l_.str.156
LFQH_Lloh1529:
nop
LFQH_Lloh1530:
adr x1, LFQH_l_.str.158
LFQH_Lloh1531:
nop
bl	LFQH_Original
mov	x8, x0
mov	x0, x19
mov	x1, x20
blr	x8
mov	x20, x0
LFQH_Lloh1532:
adr x1, LFQH_l_.str.315
LFQH_Lloh1533:
nop
str	x19, [sp, #24]
mov	x0, x19
bl	LFQH_Get
mov	x24, x0
LFQH_Lloh1534:
adr x1, LFQH_l_.str.33
LFQH_Lloh1535:
nop
mov	x0, x20
bl	LFQH_Kind
cbz	w0, LFQH_LBB86_14
LFQH_Lloh1536:
adr x1, LFQH_l_.str.33
LFQH_Lloh1537:
nop
mov	x0, x24
bl	LFQH_Kind
cbz	w0, LFQH_LBB86_14
LFQH_Lloh1538:
adr x0, LFQH_l_.str.34
LFQH_Lloh1539:
nop
bl Lpatch + (0xa5a4 - PATCH_BASE)
mov	x1, x0
mov	x0, x24
bl Lpatch + (0xa5d4 - PATCH_BASE)
cbz	x0, LFQH_LBB86_14
mov	x25, x0
LFQH_Lloh1540:
adr x0, LFQH_l_.str.34
LFQH_Lloh1541:
nop
bl Lpatch + (0xa5a4 - PATCH_BASE)
mov	x1, x0
mov	x0, x20
bl Lpatch + (0xa5d4 - PATCH_BASE)
cmp	x0, x25
b.ne	LFQH_LBB86_14
str	x20, [sp, #16]
LFQH_Lloh1542:
adr x21, LFQH_l_.str.63
LFQH_Lloh1543:
nop
mov	x0, x21
bl Lpatch + (0xa5b0 - PATCH_BASE)
mov	x22, x0
LFQH_Lloh1544:
adr x23, LFQH_l_.str.218
LFQH_Lloh1545:
nop
mov	x0, x23
bl Lpatch + (0xa5a4 - PATCH_BASE)
mov	x1, x0
mov	x0, x22
bl Lpatch + (0xa5d4 - PATCH_BASE)
str	x0, [sp, #8]
mov	x0, x21
bl Lpatch + (0xa5b0 - PATCH_BASE)
mov	x21, x0
mov	x0, x23
bl Lpatch + (0xa5a4 - PATCH_BASE)
mov	x1, x0
mov	x0, x21
bl Lpatch + (0xa5d4 - PATCH_BASE)
mov	x20, x0
LFQH_Lloh1546:
adr x0, LFQH_l_.str.211
LFQH_Lloh1547:
nop
bl Lpatch + (0xa5b0 - PATCH_BASE)
mov	x22, x0
LFQH_Lloh1548:
adr x0, LFQH_l_.str.212
LFQH_Lloh1549:
nop
bl Lpatch + (0xa5a4 - PATCH_BASE)
mov	x1, x0
mov	x0, x22
bl Lpatch + (0xa5d4 - PATCH_BASE)
str	x0, [sp]
mov	x28, #0
mov	x26, #0
LFQH_Lloh1550:
adr x27, LFQH_l_.str.264
LFQH_Lloh1551:
nop
LFQH_Lloh1552:
adr x22, LFQH_l_.str.221
LFQH_Lloh1553:
nop
LFQH_LBB86_5:
mov	x0, x27
bl Lpatch + (0xa5a4 - PATCH_BASE)
mov	x1, x0
mov	x0, x24
mov	x2, x26
bl Lpatch + (0xa5d4 - PATCH_BASE)
mov	x23, x0
ldr	x0, [sp, #24]
mov	x1, x23
bl	LFQH_TabOption
bl	LFQH_PagePreference
cbz	x0, LFQH_LBB86_7
bl	LFQH_DefaultEnabled
cbz	w0, LFQH_LBB86_8
LFQH_LBB86_7:
LFQH_Lloh1554:
adr x0, LFQH_l_.str.205
LFQH_Lloh1555:
nop
bl Lpatch + (0xa5b0 - PATCH_BASE)
mov	x21, x0
LFQH_Lloh1556:
adr x0, LFQH_l_.str.435
LFQH_Lloh1557:
nop
bl Lpatch + (0xa5a4 - PATCH_BASE)
mov	x1, x0
add	x19, x28, #1
mov	x0, x21
mov	x2, x28
bl Lpatch + (0xa5d4 - PATCH_BASE)
mov	x21, x0
LFQH_Lloh1558:
adr x0, LFQH_l_.str.227
LFQH_Lloh1559:
nop
bl Lpatch + (0xa5a4 - PATCH_BASE)
mov	x1, x0
ldr	x0, [sp]
mov	x2, x21
mov	x3, x23
bl Lpatch + (0xa5d4 - PATCH_BASE)
mov	x0, x22
bl Lpatch + (0xa5a4 - PATCH_BASE)
mov	x1, x0
ldr	x0, [sp, #8]
mov	x2, x23
bl Lpatch + (0xa5d4 - PATCH_BASE)
mov	x0, x22
bl Lpatch + (0xa5a4 - PATCH_BASE)
mov	x21, x0
mov	x0, x27
bl Lpatch + (0xa5a4 - PATCH_BASE)
mov	x1, x0
ldr	x0, [sp, #16]
mov	x2, x26
bl Lpatch + (0xa5d4 - PATCH_BASE)
mov	x2, x0
mov	x0, x20
mov	x1, x21
bl Lpatch + (0xa5d4 - PATCH_BASE)
mov	x28, x19
LFQH_LBB86_8:
add	x26, x26, #1
cmp	x25, x26
b.ne	LFQH_LBB86_5
cmp	x28, x25
b.ne	LFQH_LBB86_11
ldr	x20, [sp, #16]
b	LFQH_LBB86_14
LFQH_LBB86_11:
cbnz	x28, LFQH_LBB86_13
LFQH_Lloh1560:
adr x23, LFQH_l_.str.264
LFQH_Lloh1561:
nop
mov	x0, x23
bl Lpatch + (0xa5a4 - PATCH_BASE)
mov	x1, x0
mov	x0, x24
mov	x2, #0
bl Lpatch + (0xa5d4 - PATCH_BASE)
mov	x22, x0
LFQH_Lloh1562:
adr x0, LFQH_l_.str.205
LFQH_Lloh1563:
nop
bl Lpatch + (0xa5b0 - PATCH_BASE)
mov	x21, x0
LFQH_Lloh1564:
adr x0, LFQH_l_.str.435
LFQH_Lloh1565:
nop
bl Lpatch + (0xa5a4 - PATCH_BASE)
mov	x1, x0
mov	x0, x21
mov	x2, #0
bl Lpatch + (0xa5d4 - PATCH_BASE)
mov	x21, x0
LFQH_Lloh1566:
adr x0, LFQH_l_.str.227
LFQH_Lloh1567:
nop
bl Lpatch + (0xa5a4 - PATCH_BASE)
mov	x1, x0
ldr	x0, [sp]
mov	x2, x21
mov	x3, x22
bl Lpatch + (0xa5d4 - PATCH_BASE)
LFQH_Lloh1568:
adr x21, LFQH_l_.str.221
LFQH_Lloh1569:
nop
mov	x0, x21
bl Lpatch + (0xa5a4 - PATCH_BASE)
mov	x1, x0
ldr	x0, [sp, #8]
mov	x2, x22
bl Lpatch + (0xa5d4 - PATCH_BASE)
mov	x0, x21
bl Lpatch + (0xa5a4 - PATCH_BASE)
mov	x21, x0
mov	x0, x23
bl Lpatch + (0xa5a4 - PATCH_BASE)
mov	x1, x0
ldr	x0, [sp, #16]
mov	x2, #0
bl Lpatch + (0xa5d4 - PATCH_BASE)
mov	x2, x0
mov	x0, x20
mov	x1, x21
bl Lpatch + (0xa5d4 - PATCH_BASE)
ldr	x0, [sp, #24]
mov	x1, x22
bl	LFQH_TabOption
bl	LFQH_PagePreference
mov	w1, #1
bl	LFQH_SetDefault
LFQH_LBB86_13:
LFQH_Lloh1570:
adr x0, LFQH_l_.str.436
LFQH_Lloh1571:
nop
bl Lpatch + (0xa5a4 - PATCH_BASE)
mov	x1, x0
ldr	x19, [sp, #24]
mov	x0, x19
ldr	x2, [sp, #8]
bl Lpatch + (0xa5d4 - PATCH_BASE)
LFQH_Lloh1572:
adr x0, LFQH_l_.str.437
LFQH_Lloh1573:
nop
bl Lpatch + (0xa5a4 - PATCH_BASE)
mov	x1, x0
mov	x0, x19
ldr	x2, [sp]
bl Lpatch + (0xa5d4 - PATCH_BASE)
LFQH_LBB86_14:
mov	x0, x20
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
LFQH_TabOwnerAppear:
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
LFQH_Lloh1574:
adr x0, LFQH_l_.str.156
LFQH_Lloh1575:
nop
LFQH_Lloh1576:
adr x1, LFQH_l_.str.160
LFQH_Lloh1577:
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
b	LFQH_InstallTabRecovery
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
cbz	w0, LFQH_LBB88_2
LFQH_Lloh1578:
adr x0, LFQH_l_.str.43
LFQH_Lloh1579:
nop
LFQH_Lloh1580:
adr x19, LFQH_l_.str.92
LFQH_Lloh1581:
nop
LFQH_Lloh1582:
adr x2, LFQH_l_.str.161
LFQH_Lloh1583:
nop
LFQH_Lloh1584:
adr x20, LFQH_l_.str.9
LFQH_Lloh1585:
nop
LFQH_Lloh1586:
adr x4, LFQH_ListenLayout
LFQH_Lloh1587:
nop
mov	x1, x19
mov	x3, x20
bl	LFQH_Hook
LFQH_Lloh1588:
adr x22, LFQH_l_.str.58
LFQH_Lloh1589:
nop
LFQH_Lloh1590:
adr x2, LFQH_l_.str.162
LFQH_Lloh1591:
nop
LFQH_Lloh1592:
adr x4, LFQH_SpeechLayout
LFQH_Lloh1593:
nop
mov	x0, x22
mov	x1, x19
mov	x3, x20
bl	LFQH_Hook
LFQH_Lloh1594:
adr x1, LFQH_l_.str.163
LFQH_Lloh1595:
nop
LFQH_Lloh1596:
adr x2, LFQH_l_.str.164
LFQH_Lloh1597:
nop
LFQH_Lloh1598:
adr x21, LFQH_l_.str.98
LFQH_Lloh1599:
nop
LFQH_Lloh1600:
adr x4, LFQH_SpeechTheme
LFQH_Lloh1601:
nop
mov	x0, x22
mov	x3, x21
bl	LFQH_Hook
LFQH_Lloh1602:
adr x22, LFQH_l_.str.7
LFQH_Lloh1603:
nop
LFQH_Lloh1604:
adr x1, LFQH_l_.str.8
LFQH_Lloh1605:
nop
LFQH_Lloh1606:
adr x2, LFQH_l_.str.165
LFQH_Lloh1607:
nop
LFQH_Lloh1608:
adr x4, LFQH_HomeLayout
LFQH_Lloh1609:
nop
mov	x0, x22
mov	x3, x20
bl	LFQH_Hook
LFQH_Lloh1610:
adr x1, LFQH_l_.str.159
LFQH_Lloh1611:
nop
LFQH_Lloh1612:
adr x2, LFQH_l_.str.166
LFQH_Lloh1613:
nop
LFQH_Lloh1614:
adr x3, LFQH_l_.str.88
LFQH_Lloh1615:
nop
LFQH_Lloh1616:
adr x4, LFQH_HomeAppear
LFQH_Lloh1617:
nop
mov	x0, x22
bl	LFQH_Hook
LFQH_Lloh1618:
adr x22, LFQH_l_.str.25
LFQH_Lloh1619:
nop
LFQH_Lloh1620:
adr x2, LFQH_l_.str.167
LFQH_Lloh1621:
nop
LFQH_Lloh1622:
adr x4, LFQH_CategoryLayout
LFQH_Lloh1623:
nop
mov	x0, x22
mov	x1, x19
mov	x3, x20
bl	LFQH_Hook
LFQH_Lloh1624:
adr x1, LFQH_l_.str.168
LFQH_Lloh1625:
nop
LFQH_Lloh1626:
adr x2, LFQH_l_.str.169
LFQH_Lloh1627:
nop
LFQH_Lloh1628:
adr x23, LFQH_l_.str.170
LFQH_Lloh1629:
nop
LFQH_Lloh1630:
adr x4, LFQH_CategoryColor
LFQH_Lloh1631:
nop
mov	x0, x22
mov	x3, x23
bl	LFQH_Hook
LFQH_Lloh1632:
adr x0, LFQH_l_.str.171
LFQH_Lloh1633:
nop
LFQH_Lloh1634:
adr x1, LFQH_l_.str.172
LFQH_Lloh1635:
nop
LFQH_Lloh1636:
adr x2, LFQH_l_.str.173
LFQH_Lloh1637:
nop
LFQH_Lloh1638:
adr x4, LFQH_SearchColor
LFQH_Lloh1639:
nop
mov	x3, x23
bl	LFQH_Hook
LFQH_Lloh1640:
adr x0, LFQH_l_.str.174
LFQH_Lloh1641:
nop
LFQH_Lloh1642:
adr x2, LFQH_l_.str.175
LFQH_Lloh1643:
nop
LFQH_Lloh1644:
adr x4, LFQH_ShelfButtonLayout
LFQH_Lloh1645:
nop
mov	x1, x19
mov	x3, x20
bl	LFQH_Hook
LFQH_Lloh1646:
adr x0, LFQH_l_.str.149
LFQH_Lloh1647:
nop
LFQH_Lloh1648:
adr x1, LFQH_l_.str.176
LFQH_Lloh1649:
nop
LFQH_Lloh1650:
adr x2, LFQH_l_.str.177
LFQH_Lloh1651:
nop
LFQH_Lloh1652:
adr x4, LFQH_ShelfLayout
LFQH_Lloh1653:
nop
mov	x3, x20
bl	LFQH_Hook
LFQH_Lloh1654:
adr x22, LFQH_l_.str.178
LFQH_Lloh1655:
nop
LFQH_Lloh1656:
adr x2, LFQH_l_.str.179
LFQH_Lloh1657:
nop
LFQH_Lloh1658:
adr x4, LFQH_ReaderLayout
LFQH_Lloh1659:
nop
mov	x0, x22
mov	x1, x19
mov	x3, x20
bl	LFQH_Hook
LFQH_Lloh1660:
adr x1, LFQH_l_.str.180
LFQH_Lloh1661:
nop
LFQH_Lloh1662:
adr x2, LFQH_l_.str.181
LFQH_Lloh1663:
nop
LFQH_Lloh1664:
adr x4, LFQH_ReaderTheme
LFQH_Lloh1665:
nop
mov	x0, x22
mov	x3, x21
ldp	x29, x30, [sp, #48]
ldp	x20, x19, [sp, #32]
ldp	x22, x21, [sp, #16]
ldp	x24, x23, [sp], #64
b	LFQH_Hook
LFQH_LBB88_2:
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
LFQH_Lloh1666:
adr x0, LFQH_l_.str.43
LFQH_Lloh1667:
nop
LFQH_Lloh1668:
adr x1, LFQH_l_.str.161
LFQH_Lloh1669:
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
LFQH_Lloh1670:
adr x0, LFQH_l_.str.58
LFQH_Lloh1671:
nop
LFQH_Lloh1672:
adr x1, LFQH_l_.str.162
LFQH_Lloh1673:
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
LFQH_Lloh1674:
adr x0, LFQH_l_.str.58
LFQH_Lloh1675:
nop
LFQH_Lloh1676:
adr x1, LFQH_l_.str.164
LFQH_Lloh1677:
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
LFQH_Lloh1678:
adr x0, LFQH_l_.str.7
LFQH_Lloh1679:
nop
LFQH_Lloh1680:
adr x1, LFQH_l_.str.165
LFQH_Lloh1681:
nop
bl	LFQH_Original
mov	x8, x0
mov	x0, x20
mov	x1, x19
blr	x8
LFQH_Lloh1682:
adr x1, LFQH_l_.str.10
LFQH_Lloh1683:
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
LFQH_Lloh1684:
adr x0, LFQH_l_.str.7
LFQH_Lloh1685:
nop
LFQH_Lloh1686:
adr x1, LFQH_l_.str.166
LFQH_Lloh1687:
nop
bl	LFQH_Original
mov	x8, x0
mov	x0, x21
mov	x1, x20
mov	x2, x19
blr	x8
LFQH_Lloh1688:
adr x1, LFQH_l_.str.10
LFQH_Lloh1689:
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
LFQH_Lloh1690:
adr x0, LFQH_l_.str.25
LFQH_Lloh1691:
nop
LFQH_Lloh1692:
adr x1, LFQH_l_.str.167
LFQH_Lloh1693:
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
LFQH_Lloh1694:
adr x0, LFQH_l_.str.25
LFQH_Lloh1695:
nop
LFQH_Lloh1696:
adr x1, LFQH_l_.str.169
LFQH_Lloh1697:
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
LFQH_Lloh1698:
adr x0, LFQH_l_.str.171
LFQH_Lloh1699:
nop
LFQH_Lloh1700:
adr x1, LFQH_l_.str.173
LFQH_Lloh1701:
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
LFQH_Lloh1702:
adr x1, LFQH_l_.str.445
LFQH_Lloh1703:
nop
mov	x0, x24
bl	LFQH_Get
LFQH_Lloh1704:
adr x1, LFQH_l_.str.10
LFQH_Lloh1705:
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
LFQH_Lloh1706:
adr x0, LFQH_l_.str.174
LFQH_Lloh1707:
nop
LFQH_Lloh1708:
adr x1, LFQH_l_.str.175
LFQH_Lloh1709:
nop
bl	LFQH_Original
mov	x8, x0
mov	x0, x19
mov	x1, x20
blr	x8
LFQH_Lloh1710:
adr x1, LFQH_ShelfRoleKey
LFQH_Lloh1711:
nop
mov	x0, x19
bl Lpatch + (0xa628 - PATCH_BASE)
cbz	x0, LFQH_LBB97_2
mov	x20, x0
LFQH_Lloh1712:
adr x0, LFQH_l_.str.40
LFQH_Lloh1713:
nop
bl Lpatch + (0xa5a4 - PATCH_BASE)
mov	x1, x0
mov	x0, x20
bl Lpatch + (0xa5d4 - PATCH_BASE)
cmp	w0, #0
mov	w8, #9
cinc	w1, w8, eq
mov	x0, x19
ldp	x29, x30, [sp, #16]
ldp	x20, x19, [sp], #32
b	LFQH_Icon
LFQH_LBB97_2:
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
LFQH_Lloh1714:
adr x0, LFQH_l_.str.149
LFQH_Lloh1715:
nop
LFQH_Lloh1716:
adr x1, LFQH_l_.str.177
LFQH_Lloh1717:
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
LFQH_Lloh1718:
adr x0, LFQH_l_.str.178
LFQH_Lloh1719:
nop
LFQH_Lloh1720:
adr x1, LFQH_l_.str.179
LFQH_Lloh1721:
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
LFQH_Lloh1722:
adr x0, LFQH_l_.str.178
LFQH_Lloh1723:
nop
LFQH_Lloh1724:
adr x1, LFQH_l_.str.181
LFQH_Lloh1725:
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
LFQH_NewGlassSurface:
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
LFQH_Lloh1726:
adr x0, LFQH_l_.str.12
LFQH_Lloh1727:
nop
bl Lpatch + (0xa5b0 - PATCH_BASE)
mov	x19, x0
LFQH_Lloh1728:
adr x0, LFQH_l_.str.13
LFQH_Lloh1729:
nop
bl Lpatch + (0xa5a4 - PATCH_BASE)
mov	x1, x0
mov	x0, x19
mov	x2, #0
bl Lpatch + (0xa5d4 - PATCH_BASE)
mov	x19, x0
cbz	x0, LFQH_LBB102_3
LFQH_Lloh1730:
adr x0, LFQH_l_.str.18
LFQH_Lloh1731:
nop
bl Lpatch + (0xa5a4 - PATCH_BASE)
mov	x1, x0
mov	x0, x19
mov	w2, #1
bl Lpatch + (0xa5d4 - PATCH_BASE)
LFQH_Lloh1732:
adr x0, LFQH_l_.str.16
LFQH_Lloh1733:
nop
bl Lpatch + (0xa5b0 - PATCH_BASE)
mov	x20, x0
LFQH_Lloh1734:
adr x0, LFQH_l_.str.69
LFQH_Lloh1735:
nop
bl Lpatch + (0xa5a4 - PATCH_BASE)
mov	x1, x0
mov	x0, x20
bl Lpatch + (0xa5d4 - PATCH_BASE)
mov	x20, x0
LFQH_Lloh1736:
adr x0, LFQH_l_.str.196
LFQH_Lloh1737:
nop
bl Lpatch + (0xa5a4 - PATCH_BASE)
mov	x1, x0
mov	x0, x20
mov	x2, x19
bl Lpatch + (0xa5d4 - PATCH_BASE)
mov	x19, x0
cbz	x0, LFQH_LBB102_3
LFQH_Lloh1738:
adr x0, LFQH_l_.str.17
LFQH_Lloh1739:
nop
bl Lpatch + (0xa5a4 - PATCH_BASE)
mov	x20, x0
LFQH_Lloh1740:
adr x0, LFQH_l_.str.14
LFQH_Lloh1741:
nop
bl Lpatch + (0xa5b0 - PATCH_BASE)
mov	x21, x0
LFQH_Lloh1742:
adr x0, LFQH_l_.str.15
LFQH_Lloh1743:
nop
bl Lpatch + (0xa5a4 - PATCH_BASE)
mov	x1, x0
mov	x0, x21
bl Lpatch + (0xa5d4 - PATCH_BASE)
mov	x2, x0
mov	x0, x19
mov	x1, x20
bl Lpatch + (0xa5d4 - PATCH_BASE)
LFQH_Lloh1744:
adr x0, LFQH_l_.str.197
LFQH_Lloh1745:
nop
bl Lpatch + (0xa5a4 - PATCH_BASE)
mov	x1, x0
mov	x0, x19
mov	w2, #0
bl Lpatch + (0xa5d4 - PATCH_BASE)
LFQH_Lloh1746:
adr x0, LFQH_l_.str.198
LFQH_Lloh1747:
nop
bl Lpatch + (0xa5a4 - PATCH_BASE)
mov	x1, x0
mov	x0, x19
mov	w2, #1
bl Lpatch + (0xa5d4 - PATCH_BASE)
LFQH_Lloh1748:
adr x0, LFQH_l_.str.199
LFQH_Lloh1749:
nop
bl Lpatch + (0xa5a4 - PATCH_BASE)
mov	x1, x0
mov	x0, x19
mov	w2, #0
bl Lpatch + (0xa5d4 - PATCH_BASE)
LFQH_Lloh1750:
adr x0, LFQH_l_.str.200
LFQH_Lloh1751:
nop
bl Lpatch + (0xa5a4 - PATCH_BASE)
mov	x1, x0
mov	x0, x19
mov	w2, #0
bl Lpatch + (0xa5d4 - PATCH_BASE)
LFQH_LBB102_3:
mov	x0, x19
ldp	x29, x30, [sp, #32]
ldp	x20, x19, [sp, #16]
ldp	x22, x21, [sp], #48
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
LFQH_Lloh1752:
adr x0, LFQH_l_.str.190
LFQH_Lloh1753:
nop
bl Lpatch + (0xa5a4 - PATCH_BASE)
mov	x1, x0
mov	x0, x19
bl Lpatch + (0xa5d4 - PATCH_BASE)
mov	x21, x0
LFQH_Lloh1754:
adr x0, LFQH_l_.str.191
LFQH_Lloh1755:
nop
bl Lpatch + (0xa5a4 - PATCH_BASE)
mov	x1, x0
mov	x0, x19
bl Lpatch + (0xa5d4 - PATCH_BASE)
mov	x20, x0
LFQH_Lloh1756:
adr x0, LFQH_l_.str.202
LFQH_Lloh1757:
nop
bl Lpatch + (0xa5a4 - PATCH_BASE)
mov	x1, x0
mov	x0, x19
bl Lpatch + (0xa5d4 - PATCH_BASE)
mov	x22, x0
LFQH_Lloh1758:
adr x0, LFQH_l_.str.203
LFQH_Lloh1759:
nop
bl Lpatch + (0xa5a4 - PATCH_BASE)
mov	x1, x0
mov	x0, x22
bl Lpatch + (0xa5d4 - PATCH_BASE)
mov.16b	v8, v0
fcmp	d10, d9
fcsel	d9, d10, d9, mi
LFQH_Lloh1760:
adr x1, LFQH_HeaderAppliedRadiusKey
LFQH_Lloh1761:
nop
mov	x0, x19
bl Lpatch + (0xa628 - PATCH_BASE)
mov	x22, x0
LFQH_Lloh1762:
adr x1, LFQH_HeaderClipsKey
LFQH_Lloh1763:
nop
mov	x0, x19
bl Lpatch + (0xa628 - PATCH_BASE)
cbz	x0, LFQH_LBB104_2
cbnz	w21, LFQH_LBB104_3
LFQH_LBB104_2:
LFQH_Lloh1764:
adr x0, LFQH_l_.str.205
LFQH_Lloh1765:
nop
bl Lpatch + (0xa5b0 - PATCH_BASE)
mov	x23, x0
LFQH_Lloh1766:
adr x0, LFQH_l_.str.271
LFQH_Lloh1767:
nop
bl Lpatch + (0xa5a4 - PATCH_BASE)
mov	x1, x0
mov	x0, x23
mov	x2, x21
bl Lpatch + (0xa5d4 - PATCH_BASE)
mov	x2, x0
LFQH_Lloh1768:
adr x1, LFQH_HeaderClipsKey
LFQH_Lloh1769:
nop
mov	x0, x19
mov	w3, #1
bl Lpatch + (0xa634 - PATCH_BASE)
LFQH_LBB104_3:
fmov	d10, #0.50000000
LFQH_Lloh1770:
adr x1, LFQH_HeaderOpaqueKey
LFQH_Lloh1771:
nop
mov	x0, x19
bl Lpatch + (0xa628 - PATCH_BASE)
cbz	x0, LFQH_LBB104_5
cbz	w20, LFQH_LBB104_6
LFQH_LBB104_5:
LFQH_Lloh1772:
adr x0, LFQH_l_.str.205
LFQH_Lloh1773:
nop
bl Lpatch + (0xa5b0 - PATCH_BASE)
mov	x23, x0
LFQH_Lloh1774:
adr x0, LFQH_l_.str.271
LFQH_Lloh1775:
nop
bl Lpatch + (0xa5a4 - PATCH_BASE)
mov	x1, x0
mov	x0, x23
mov	x2, x20
bl Lpatch + (0xa5d4 - PATCH_BASE)
mov	x2, x0
LFQH_Lloh1776:
adr x1, LFQH_HeaderOpaqueKey
LFQH_Lloh1777:
nop
mov	x0, x19
mov	w3, #1
bl Lpatch + (0xa634 - PATCH_BASE)
LFQH_LBB104_6:
fmul	d9, d9, d10
cbz	x22, LFQH_LBB104_8
LFQH_Lloh1778:
adr x0, LFQH_l_.str.204
LFQH_Lloh1779:
nop
bl Lpatch + (0xa5a4 - PATCH_BASE)
mov	x1, x0
mov	x0, x22
bl Lpatch + (0xa5d4 - PATCH_BASE)
fcmp	d8, d0
b.eq	LFQH_LBB104_9
LFQH_LBB104_8:
LFQH_Lloh1780:
adr x0, LFQH_l_.str.205
LFQH_Lloh1781:
nop
bl Lpatch + (0xa5b0 - PATCH_BASE)
mov	x23, x0
LFQH_Lloh1782:
adr x0, LFQH_l_.str.206
LFQH_Lloh1783:
nop
bl Lpatch + (0xa5a4 - PATCH_BASE)
mov	x1, x0
mov	x0, x23
mov.16b	v0, v8
bl Lpatch + (0xa5d4 - PATCH_BASE)
mov	x2, x0
LFQH_Lloh1784:
adr x1, LFQH_HeaderRadiusKey
LFQH_Lloh1785:
nop
mov	x0, x19
mov	w3, #1
bl Lpatch + (0xa634 - PATCH_BASE)
LFQH_LBB104_9:
fcmp	d8, d9
b.eq	LFQH_LBB104_11
LFQH_Lloh1786:
adr x0, LFQH_l_.str.202
LFQH_Lloh1787:
nop
bl Lpatch + (0xa5a4 - PATCH_BASE)
mov	x1, x0
mov	x0, x19
bl Lpatch + (0xa5d4 - PATCH_BASE)
mov	x23, x0
LFQH_Lloh1788:
adr x0, LFQH_l_.str.207
LFQH_Lloh1789:
nop
bl Lpatch + (0xa5a4 - PATCH_BASE)
mov	x1, x0
mov	x0, x23
mov.16b	v0, v9
bl Lpatch + (0xa5d4 - PATCH_BASE)
LFQH_LBB104_11:
cbz	x22, LFQH_LBB104_13
LFQH_Lloh1790:
adr x0, LFQH_l_.str.204
LFQH_Lloh1791:
nop
bl Lpatch + (0xa5a4 - PATCH_BASE)
mov	x1, x0
mov	x0, x22
bl Lpatch + (0xa5d4 - PATCH_BASE)
fcmp	d0, d9
b.eq	LFQH_LBB104_14
LFQH_LBB104_13:
LFQH_Lloh1792:
adr x0, LFQH_l_.str.205
LFQH_Lloh1793:
nop
bl Lpatch + (0xa5b0 - PATCH_BASE)
mov	x22, x0
LFQH_Lloh1794:
adr x0, LFQH_l_.str.206
LFQH_Lloh1795:
nop
bl Lpatch + (0xa5a4 - PATCH_BASE)
mov	x1, x0
mov	x0, x22
mov.16b	v0, v9
bl Lpatch + (0xa5d4 - PATCH_BASE)
mov	x2, x0
LFQH_Lloh1796:
adr x1, LFQH_HeaderAppliedRadiusKey
LFQH_Lloh1797:
nop
mov	x0, x19
mov	w3, #1
bl Lpatch + (0xa634 - PATCH_BASE)
LFQH_LBB104_14:
cbz	w21, LFQH_LBB104_17
cbz	w20, LFQH_LBB104_18
LFQH_LBB104_16:
LFQH_Lloh1798:
adr x0, LFQH_l_.str.200
LFQH_Lloh1799:
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
LFQH_LBB104_17:
LFQH_Lloh1800:
adr x0, LFQH_l_.str.201
LFQH_Lloh1801:
nop
bl Lpatch + (0xa5a4 - PATCH_BASE)
mov	x1, x0
mov	x0, x19
mov	w2, #1
bl Lpatch + (0xa5d4 - PATCH_BASE)
cbnz	w20, LFQH_LBB104_16
LFQH_LBB104_18:
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
mov	x20, x2
mov	x21, x1
mov	x19, x0
LFQH_Lloh1802:
adr x1, LFQH_ClipsKey
LFQH_Lloh1803:
nop
bl Lpatch + (0xa628 - PATCH_BASE)
cbnz	w21, LFQH_LBB105_2
cbnz	x0, LFQH_LBB105_3
LFQH_LBB105_2:
LFQH_Lloh1804:
adr x0, LFQH_l_.str.205
LFQH_Lloh1805:
nop
bl Lpatch + (0xa5b0 - PATCH_BASE)
mov	x22, x0
LFQH_Lloh1806:
adr x0, LFQH_l_.str.271
LFQH_Lloh1807:
nop
bl Lpatch + (0xa5a4 - PATCH_BASE)
mov	x1, x0
mov	x0, x22
mov	x2, x21
bl Lpatch + (0xa5d4 - PATCH_BASE)
mov	x2, x0
LFQH_Lloh1808:
adr x1, LFQH_ClipsKey
LFQH_Lloh1809:
nop
mov	x0, x19
mov	w3, #1
bl Lpatch + (0xa634 - PATCH_BASE)
LFQH_LBB105_3:
LFQH_Lloh1810:
adr x1, LFQH_OpaqueKey
LFQH_Lloh1811:
nop
mov	x0, x19
bl Lpatch + (0xa628 - PATCH_BASE)
cbnz	w20, LFQH_LBB105_5
cbnz	x0, LFQH_LBB105_6
LFQH_LBB105_5:
LFQH_Lloh1812:
adr x0, LFQH_l_.str.205
LFQH_Lloh1813:
nop
bl Lpatch + (0xa5b0 - PATCH_BASE)
mov	x22, x0
LFQH_Lloh1814:
adr x0, LFQH_l_.str.271
LFQH_Lloh1815:
nop
bl Lpatch + (0xa5a4 - PATCH_BASE)
mov	x1, x0
mov	x0, x22
mov	x2, x20
bl Lpatch + (0xa5d4 - PATCH_BASE)
mov	x2, x0
LFQH_Lloh1816:
adr x1, LFQH_OpaqueKey
LFQH_Lloh1817:
nop
mov	x0, x19
mov	w3, #1
bl Lpatch + (0xa634 - PATCH_BASE)
LFQH_LBB105_6:
cbz	w21, LFQH_LBB105_8
LFQH_Lloh1818:
adr x0, LFQH_l_.str.201
LFQH_Lloh1819:
nop
bl Lpatch + (0xa5a4 - PATCH_BASE)
mov	x1, x0
mov	x0, x19
mov	w2, #0
bl Lpatch + (0xa5d4 - PATCH_BASE)
LFQH_LBB105_8:
cbz	w20, LFQH_LBB105_10
LFQH_Lloh1820:
adr x0, LFQH_l_.str.200
LFQH_Lloh1821:
nop
bl Lpatch + (0xa5a4 - PATCH_BASE)
mov	x1, x0
mov	x0, x19
mov	w2, #0
ldp	x29, x30, [sp, #32]
ldp	x20, x19, [sp, #16]
ldp	x22, x21, [sp], #48
b Lpatch + (0xa5d4 - PATCH_BASE)
LFQH_LBB105_10:
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
LFQH_Lloh1822:
adr x0, LFQH_l_.str.186
LFQH_Lloh1823:
nop
bl Lpatch + (0xa5a4 - PATCH_BASE)
mov	x1, x0
mov	x0, x20
bl Lpatch + (0xa5d4 - PATCH_BASE)
cmp	x0, x19
b.eq	LFQH_LBB106_2
mov	x21, x0
LFQH_Lloh1824:
adr x0, LFQH_l_.str.48
LFQH_Lloh1825:
nop
bl Lpatch + (0xa5a4 - PATCH_BASE)
mov	x1, x0
mov	x0, x21
mov	x2, x19
bl Lpatch + (0xa5d4 - PATCH_BASE)
cbz	w0, LFQH_LBB106_3
LFQH_LBB106_2:
ldp	x29, x30, [sp, #32]
ldp	x20, x19, [sp, #16]
ldp	x22, x21, [sp], #48
ret
LFQH_LBB106_3:
LFQH_Lloh1826:
adr x0, LFQH_l_.str.72
LFQH_Lloh1827:
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
LFQH_Number:
.cfi_startproc
stp	d9, d8, [sp, #-48]!
stp	x20, x19, [sp, #16]
stp	x29, x30, [sp, #32]
add	x29, sp, #32
.cfi_def_cfa w29, 16
.cfi_offset w30, -8
.cfi_offset w29, -16
.cfi_offset w19, -24
.cfi_offset w20, -32
.cfi_offset b8, -40
.cfi_offset b9, -48
mov.16b	v8, v0
LFQH_Lloh1828:
adr x0, LFQH_l_.str.205
LFQH_Lloh1829:
nop
bl Lpatch + (0xa5b0 - PATCH_BASE)
mov	x19, x0
LFQH_Lloh1830:
adr x0, LFQH_l_.str.206
LFQH_Lloh1831:
nop
bl Lpatch + (0xa5a4 - PATCH_BASE)
mov	x1, x0
mov	x0, x19
mov.16b	v0, v8
ldp	x29, x30, [sp, #32]
ldp	x20, x19, [sp, #16]
ldp	d9, d8, [sp], #48
b Lpatch + (0xa5d4 - PATCH_BASE)
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
LFQH_Lloh1832:
adr x0, LFQH_l_.str.225
LFQH_Lloh1833:
nop
bl Lpatch + (0xa5b0 - PATCH_BASE)
mov	x19, x0
LFQH_Lloh1834:
adr x0, LFQH_l_.str.226
LFQH_Lloh1835:
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
LFQH_Lloh1836:
adr x0, LFQH_l_.str.227
LFQH_Lloh1837:
nop
bl Lpatch + (0xa5a4 - PATCH_BASE)
mov	x22, x0
LFQH_Lloh1838:
adr x0, LFQH_l_.str.182
LFQH_Lloh1839:
nop
bl Lpatch + (0xa5b0 - PATCH_BASE)
mov	x23, x0
LFQH_Lloh1840:
adr x0, LFQH_l_.str.183
LFQH_Lloh1841:
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
LFQH_Lloh1842:
adr x0, LFQH_l_.str.63
LFQH_Lloh1843:
nop
bl Lpatch + (0xa5b0 - PATCH_BASE)
mov	x19, x0
LFQH_Lloh1844:
adr x0, LFQH_l_.str.218
LFQH_Lloh1845:
nop
bl Lpatch + (0xa5a4 - PATCH_BASE)
mov	x1, x0
mov	x0, x19
bl Lpatch + (0xa5d4 - PATCH_BASE)
mov	x19, x0
LFQH_Lloh1846:
adr x20, LFQH_l_.str.221
LFQH_Lloh1847:
nop
mov	x0, x20
bl Lpatch + (0xa5a4 - PATCH_BASE)
mov	x23, x0
LFQH_Lloh1848:
adr x21, LFQH_l_.str.205
LFQH_Lloh1849:
nop
mov	x0, x21
bl Lpatch + (0xa5b0 - PATCH_BASE)
mov	x24, x0
LFQH_Lloh1850:
adr x22, LFQH_l_.str.206
LFQH_Lloh1851:
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
cbz	x20, LFQH_LBB120_2
mov	x0, x19
mov	x1, x20
mov	w2, #0
bl	LFQH_ObservePress
LFQH_Lloh1852:
adr x0, LFQH_l_.str.240
LFQH_Lloh1853:
nop
bl Lpatch + (0xa5a4 - PATCH_BASE)
mov	x1, x0
mov	x0, x20
bl Lpatch + (0xa5d4 - PATCH_BASE)
LFQH_LBB120_2:
LFQH_Lloh1854:
adr x1, LFQH_IconGlassKey
LFQH_Lloh1855:
nop
mov	x0, x19
mov	x2, #0
mov	w3, #1
bl Lpatch + (0xa634 - PATCH_BASE)
LFQH_Lloh1856:
adr x1, LFQH_IconRectKey
LFQH_Lloh1857:
nop
mov	x0, x19
mov	x2, #0
mov	w3, #1
bl Lpatch + (0xa634 - PATCH_BASE)
LFQH_Lloh1858:
adr x1, LFQH_LayoutKey
LFQH_Lloh1859:
nop
mov	x0, x19
mov	x2, #0
mov	w3, #1
bl Lpatch + (0xa634 - PATCH_BASE)
LFQH_Lloh1860:
adr x1, LFQH_LayoutTimeKey
LFQH_Lloh1861:
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
LFQH_Lloh1862:
adr x1, LFQH_GlyphViewKey
LFQH_Lloh1863:
nop
bl Lpatch + (0xa628 - PATCH_BASE)
mov	x20, x0
LFQH_Lloh1864:
adr x1, LFQH_GlyphOriginalKey
LFQH_Lloh1865:
nop
bl Lpatch + (0xa628 - PATCH_BASE)
cbz	x0, LFQH_LBB122_2
mov	x21, x0
LFQH_Lloh1866:
adr x0, LFQH_l_.str.224
LFQH_Lloh1867:
nop
bl Lpatch + (0xa5a4 - PATCH_BASE)
mov	x1, x0
mov	x0, x21
bl Lpatch + (0xa5d4 - PATCH_BASE)
mov.16b	v8, v0
mov.16b	v9, v1
mov.16b	v10, v2
mov.16b	v11, v3
LFQH_Lloh1868:
adr x0, LFQH_l_.str.71
LFQH_Lloh1869:
nop
bl Lpatch + (0xa5a4 - PATCH_BASE)
mov	x1, x0
mov	x0, x20
mov.16b	v0, v8
mov.16b	v1, v9
mov.16b	v2, v10
mov.16b	v3, v11
bl Lpatch + (0xa5d4 - PATCH_BASE)
LFQH_LBB122_2:
LFQH_Lloh1870:
adr x1, LFQH_GlyphOriginalKey
LFQH_Lloh1871:
nop
mov	x0, x20
mov	x2, #0
mov	w3, #1
bl Lpatch + (0xa634 - PATCH_BASE)
LFQH_Lloh1872:
adr x1, LFQH_GlyphAppliedKey
LFQH_Lloh1873:
nop
mov	x0, x20
mov	x2, #0
mov	w3, #1
bl Lpatch + (0xa634 - PATCH_BASE)
LFQH_Lloh1874:
adr x1, LFQH_GlyphViewKey
LFQH_Lloh1875:
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
LFQH_Lloh1876:
adr x1, LFQH_l_.str.242
LFQH_Lloh1877:
nop
bl	LFQH_Responds
cbz	w0, LFQH_LBB125_2
LFQH_Lloh1878:
adr x1, LFQH_l_.str.243
LFQH_Lloh1879:
nop
mov	x0, x19
bl	LFQH_Responds
LFQH_LBB125_2:
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
LFQH_Lloh1880:
adr x0, LFQH_l_.str.244
LFQH_Lloh1881:
nop
bl Lpatch + (0xa5b0 - PATCH_BASE)
mov	x19, x0
cbnz	x0, LFQH_LBB126_3
LFQH_Lloh1882:
adr x0, LFQH_l_.str.228
LFQH_Lloh1883:
nop
bl Lpatch + (0xa5b0 - PATCH_BASE)
LFQH_Lloh1884:
adr x1, LFQH_l_.str.244
LFQH_Lloh1885:
nop
mov	x2, #0
bl Lpatch + (0xa61c - PATCH_BASE)
mov	x19, x0
cbz	x0, LFQH_LBB126_3
LFQH_Lloh1886:
adr x0, LFQH_l_.str.245
LFQH_Lloh1887:
nop
bl Lpatch + (0xa5a4 - PATCH_BASE)
mov	x1, x0
LFQH_Lloh1888:
adr x2, LFQH_Press
LFQH_Lloh1889:
nop
LFQH_Lloh1890:
adr x20, LFQH_l_.str.98
LFQH_Lloh1891:
nop
mov	x0, x19
mov	x3, x20
bl Lpatch + (0xa58c - PATCH_BASE)
LFQH_Lloh1892:
adr x0, LFQH_l_.str.246
LFQH_Lloh1893:
nop
bl Lpatch + (0xa5a4 - PATCH_BASE)
mov	x1, x0
LFQH_Lloh1894:
adr x2, LFQH_ReleasePress
LFQH_Lloh1895:
nop
mov	x0, x19
mov	x3, x20
bl Lpatch + (0xa58c - PATCH_BASE)
mov	x0, x19
bl Lpatch + (0xa610 - PATCH_BASE)
LFQH_LBB126_3:
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
LFQH_Lloh1896:
adr x1, LFQH_l_.str.41
LFQH_Lloh1897:
nop
bl	LFQH_Kind
cbz	w0, LFQH_LBB127_2
LFQH_Lloh1898:
adr x8, LFQH_l_.str.247
LFQH_Lloh1899:
nop
LFQH_Lloh1900:
adr x9, LFQH_l_.str.248
LFQH_Lloh1901:
nop
cmp	w21, #0
csel	x0, x9, x8, eq
bl Lpatch + (0xa5a4 - PATCH_BASE)
mov	x21, x0
LFQH_Lloh1902:
adr x0, LFQH_l_.str.245
LFQH_Lloh1903:
nop
bl Lpatch + (0xa5a4 - PATCH_BASE)
mov	x3, x0
mov	x0, x20
mov	x1, x21
mov	x2, x19
mov	w4, #17
bl Lpatch + (0xa5d4 - PATCH_BASE)
LFQH_Lloh1904:
adr x0, LFQH_l_.str.246
LFQH_Lloh1905:
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
LFQH_LBB127_2:
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
stp	d3, d2, [sp, #48]
stp	d1, d0, [sp, #64]
mov	x21, x1
mov	x20, x0
LFQH_Lloh1906:
adr x22, LFQH_l_.str.192
LFQH_Lloh1907:
nop
mov	x0, x22
bl Lpatch + (0xa5a4 - PATCH_BASE)
mov	x1, x0
mov	x0, x20
bl Lpatch + (0xa5d4 - PATCH_BASE)
mov.16b	v10, v0
mov.16b	v12, v1
mov.16b	v13, v2
mov.16b	v14, v3
LFQH_Lloh1908:
adr x0, LFQH_l_.str.24
LFQH_Lloh1909:
nop
bl Lpatch + (0xa5a4 - PATCH_BASE)
mov	x1, x0
mov	x0, x20
bl Lpatch + (0xa5d4 - PATCH_BASE)
mov.16b	v9, v0
stp	d2, d1, [sp, #136]
str	d3, [sp, #128]
mov	x0, x22
bl Lpatch + (0xa5a4 - PATCH_BASE)
mov	x1, x0
mov	x0, x21
bl Lpatch + (0xa5d4 - PATCH_BASE)
stp	d1, d0, [sp, #112]
stp	d3, d2, [sp, #96]
LFQH_Lloh1910:
adr x0, LFQH_l_.str.20
LFQH_Lloh1911:
nop
bl Lpatch + (0xa5a4 - PATCH_BASE)
mov	x1, x0
mov	x0, x21
bl Lpatch + (0xa5d4 - PATCH_BASE)
cmp	x0, x20
b.eq	LFQH_LBB129_2
mov	x21, x0
LFQH_Lloh1912:
adr x0, LFQH_l_.str.241
LFQH_Lloh1913:
nop
bl Lpatch + (0xa5a4 - PATCH_BASE)
mov	x1, x0
mov	x0, x21
ldp	d1, d0, [sp, #112]
ldp	d3, d2, [sp, #96]
mov	x2, x20
bl Lpatch + (0xa5d4 - PATCH_BASE)
stp	d1, d0, [sp, #112]
stp	d3, d2, [sp, #96]
LFQH_LBB129_2:
LFQH_Lloh1914:
adr x1, LFQH_l_.str.249
LFQH_Lloh1915:
nop
mov	x0, x20
bl	LFQH_Get
mov.16b	v8, v10
stp	d13, d12, [sp, #80]
mov.16b	v3, v14
cbz	x0, LFQH_LBB129_4
mov	x21, x0
LFQH_Lloh1916:
adr x0, LFQH_l_.str.241
LFQH_Lloh1917:
nop
bl Lpatch + (0xa5a4 - PATCH_BASE)
mov	x1, x0
mov	x0, x20
mov.16b	v0, v9
ldp	d2, d1, [sp, #136]
ldr	d3, [sp, #128]
mov	x2, x21
bl Lpatch + (0xa5d4 - PATCH_BASE)
mov.16b	v10, v0
mov.16b	v12, v1
mov.16b	v13, v2
LFQH_LBB129_4:
str	d3, [sp, #40]
LFQH_Lloh1918:
adr x1, LFQH_LayoutKey
LFQH_Lloh1919:
nop
mov	x0, x20
bl Lpatch + (0xa628 - PATCH_BASE)
cbz	x0, LFQH_LBB129_25
mov	x21, x0
LFQH_Lloh1920:
adr x0, LFQH_l_.str.264
LFQH_Lloh1921:
nop
bl Lpatch + (0xa5a4 - PATCH_BASE)
mov	x1, x0
mov	x0, x21
mov	x2, #0
bl Lpatch + (0xa5d4 - PATCH_BASE)
mov	x22, x0
LFQH_Lloh1922:
adr x0, LFQH_l_.str.224
LFQH_Lloh1923:
nop
bl Lpatch + (0xa5a4 - PATCH_BASE)
mov	x1, x0
mov	x0, x22
bl Lpatch + (0xa5d4 - PATCH_BASE)
fcmp	d8, d0
b.ne	LFQH_LBB129_25
ldr	d0, [sp, #88]
fcmp	d0, d1
b.ne	LFQH_LBB129_25
ldr	d0, [sp, #80]
fcmp	d0, d2
b.ne	LFQH_LBB129_25
fcmp	d14, d3
b.ne	LFQH_LBB129_25
LFQH_Lloh1924:
adr x0, LFQH_l_.str.264
LFQH_Lloh1925:
nop
bl Lpatch + (0xa5a4 - PATCH_BASE)
mov	x1, x0
mov	x0, x21
mov	w2, #1
bl Lpatch + (0xa5d4 - PATCH_BASE)
mov	x22, x0
LFQH_Lloh1926:
adr x0, LFQH_l_.str.224
LFQH_Lloh1927:
nop
bl Lpatch + (0xa5a4 - PATCH_BASE)
mov	x1, x0
mov	x0, x22
bl Lpatch + (0xa5d4 - PATCH_BASE)
fcmp	d9, d0
b.ne	LFQH_LBB129_25
ldr	d0, [sp, #144]
fcmp	d0, d1
b.ne	LFQH_LBB129_25
ldr	d0, [sp, #136]
fcmp	d0, d2
b.ne	LFQH_LBB129_25
ldr	d0, [sp, #128]
fcmp	d0, d3
b.ne	LFQH_LBB129_25
LFQH_Lloh1928:
adr x0, LFQH_l_.str.264
LFQH_Lloh1929:
nop
bl Lpatch + (0xa5a4 - PATCH_BASE)
mov	x1, x0
mov	x0, x21
mov	w2, #2
bl Lpatch + (0xa5d4 - PATCH_BASE)
mov	x22, x0
LFQH_Lloh1930:
adr x0, LFQH_l_.str.224
LFQH_Lloh1931:
nop
bl Lpatch + (0xa5a4 - PATCH_BASE)
mov	x1, x0
mov	x0, x22
bl Lpatch + (0xa5d4 - PATCH_BASE)
ldr	d4, [sp, #72]
fcmp	d4, d0
b.ne	LFQH_LBB129_25
ldr	d0, [sp, #64]
fcmp	d0, d1
b.ne	LFQH_LBB129_25
ldr	d0, [sp, #56]
fcmp	d0, d2
b.ne	LFQH_LBB129_25
ldr	d0, [sp, #48]
fcmp	d0, d3
b.ne	LFQH_LBB129_25
LFQH_Lloh1932:
adr x0, LFQH_l_.str.264
LFQH_Lloh1933:
nop
bl Lpatch + (0xa5a4 - PATCH_BASE)
mov	x1, x0
mov	x0, x21
mov	w2, #3
bl Lpatch + (0xa5d4 - PATCH_BASE)
mov	x22, x0
LFQH_Lloh1934:
adr x0, LFQH_l_.str.224
LFQH_Lloh1935:
nop
bl Lpatch + (0xa5a4 - PATCH_BASE)
mov	x1, x0
mov	x0, x22
bl Lpatch + (0xa5d4 - PATCH_BASE)
ldr	d4, [sp, #120]
fcmp	d4, d0
b.ne	LFQH_LBB129_25
ldr	d0, [sp, #112]
fcmp	d0, d1
b.ne	LFQH_LBB129_25
ldr	d0, [sp, #104]
fcmp	d0, d2
b.ne	LFQH_LBB129_25
ldr	d0, [sp, #96]
fcmp	d0, d3
b.ne	LFQH_LBB129_25
LFQH_Lloh1936:
adr x0, LFQH_l_.str.264
LFQH_Lloh1937:
nop
bl Lpatch + (0xa5a4 - PATCH_BASE)
mov	x1, x0
mov	x0, x21
mov	w2, #4
bl Lpatch + (0xa5d4 - PATCH_BASE)
mov	x21, x0
LFQH_Lloh1938:
adr x0, LFQH_l_.str.224
LFQH_Lloh1939:
nop
bl Lpatch + (0xa5a4 - PATCH_BASE)
mov	x1, x0
mov	x0, x21
bl Lpatch + (0xa5d4 - PATCH_BASE)
fcmp	d10, d0
b.ne	LFQH_LBB129_25
fcmp	d12, d1
b.ne	LFQH_LBB129_25
fcmp	d13, d2
b.ne	LFQH_LBB129_25
ldr	d0, [sp, #40]
fcmp	d0, d3
b.eq	LFQH_LBB129_28
LFQH_LBB129_25:
LFQH_Lloh1940:
adr x0, LFQH_l_.str.208
LFQH_Lloh1941:
nop
bl Lpatch + (0xa5b0 - PATCH_BASE)
mov	x21, x0
LFQH_Lloh1942:
adr x0, LFQH_l_.str.209
LFQH_Lloh1943:
nop
bl Lpatch + (0xa5a4 - PATCH_BASE)
mov	x1, x0
mov	x0, x21
bl Lpatch + (0xa5d4 - PATCH_BASE)
mov	x21, x0
LFQH_Lloh1944:
adr x0, LFQH_l_.str.210
LFQH_Lloh1945:
nop
bl Lpatch + (0xa5a4 - PATCH_BASE)
mov	x1, x0
mov	x0, x21
bl Lpatch + (0xa5d4 - PATCH_BASE)
mov.16b	v15, v0
LFQH_Lloh1946:
adr x1, LFQH_LayoutTimeKey
LFQH_Lloh1947:
nop
mov	x0, x20
bl Lpatch + (0xa628 - PATCH_BASE)
cbz	x0, LFQH_LBB129_27
mov	x21, x0
LFQH_Lloh1948:
adr x0, LFQH_l_.str.204
LFQH_Lloh1949:
nop
bl Lpatch + (0xa5a4 - PATCH_BASE)
mov	x1, x0
mov	x0, x21
bl Lpatch + (0xa5d4 - PATCH_BASE)
fsub	d0, d15, d0
fmov	d1, #1.00000000
fcmp	d0, d1
b.mi	LFQH_LBB129_28
LFQH_LBB129_27:
LFQH_Lloh1950:
adr x21, LFQH_l_.str.225
LFQH_Lloh1951:
nop
mov	x0, x21
bl Lpatch + (0xa5b0 - PATCH_BASE)
mov	x23, x0
LFQH_Lloh1952:
adr x22, LFQH_l_.str.226
LFQH_Lloh1953:
nop
mov	x0, x22
bl Lpatch + (0xa5a4 - PATCH_BASE)
mov	x1, x0
mov	x0, x23
stp	d14, d8, [sp, #24]
mov.16b	v0, v8
ldp	d2, d1, [sp, #80]
str	d9, [sp, #16]
mov.16b	v3, v14
bl Lpatch + (0xa5d4 - PATCH_BASE)
str	x0, [sp, #152]
mov	x0, x21
bl Lpatch + (0xa5b0 - PATCH_BASE)
mov	x23, x0
mov	x0, x22
bl Lpatch + (0xa5a4 - PATCH_BASE)
mov	x1, x0
mov	x0, x23
mov.16b	v0, v9
ldp	d2, d1, [sp, #136]
str	d10, [sp, #8]
ldr	d3, [sp, #128]
bl Lpatch + (0xa5d4 - PATCH_BASE)
str	x0, [sp, #160]
mov	x0, x21
bl Lpatch + (0xa5b0 - PATCH_BASE)
mov	x23, x0
mov	x0, x22
bl Lpatch + (0xa5a4 - PATCH_BASE)
mov	x1, x0
mov	x0, x23
ldp	d1, d0, [sp, #64]
ldp	d3, d2, [sp, #48]
ldp	d11, d14, [sp, #112]
ldp	d8, d9, [sp, #96]
bl Lpatch + (0xa5d4 - PATCH_BASE)
str	x0, [sp, #168]
mov	x0, x21
bl Lpatch + (0xa5b0 - PATCH_BASE)
mov	x23, x0
mov	x0, x22
bl Lpatch + (0xa5a4 - PATCH_BASE)
mov	x1, x0
mov	x0, x23
mov.16b	v0, v14
mov.16b	v1, v11
mov.16b	v2, v9
mov.16b	v3, v8
bl Lpatch + (0xa5d4 - PATCH_BASE)
str	x0, [sp, #176]
mov	x0, x21
bl Lpatch + (0xa5b0 - PATCH_BASE)
mov	x21, x0
mov	x0, x22
bl Lpatch + (0xa5a4 - PATCH_BASE)
mov	x1, x0
mov	x0, x21
mov.16b	v0, v10
mov.16b	v1, v12
mov.16b	v10, v12
mov.16b	v2, v13
ldr	d12, [sp, #40]
mov.16b	v3, v12
bl Lpatch + (0xa5d4 - PATCH_BASE)
str	x0, [sp, #184]
LFQH_Lloh1954:
adr x0, LFQH_l_.str.33
LFQH_Lloh1955:
nop
bl Lpatch + (0xa5b0 - PATCH_BASE)
mov	x21, x0
LFQH_Lloh1956:
adr x0, LFQH_l_.str.250
LFQH_Lloh1957:
nop
bl Lpatch + (0xa5a4 - PATCH_BASE)
mov	x1, x0
add	x2, sp, #152
mov	x0, x21
mov	w3, #5
bl Lpatch + (0xa5d4 - PATCH_BASE)
mov	x2, x0
LFQH_Lloh1958:
adr x1, LFQH_LayoutKey
LFQH_Lloh1959:
nop
mov	x0, x20
mov	w3, #1
bl Lpatch + (0xa634 - PATCH_BASE)
LFQH_Lloh1960:
adr x0, LFQH_l_.str.205
LFQH_Lloh1961:
nop
bl Lpatch + (0xa5b0 - PATCH_BASE)
mov	x21, x0
LFQH_Lloh1962:
adr x0, LFQH_l_.str.206
LFQH_Lloh1963:
nop
bl Lpatch + (0xa5a4 - PATCH_BASE)
mov	x1, x0
mov	x0, x21
mov.16b	v0, v15
bl Lpatch + (0xa5d4 - PATCH_BASE)
mov	x2, x0
LFQH_Lloh1964:
adr x1, LFQH_LayoutTimeKey
LFQH_Lloh1965:
nop
mov	x0, x20
mov	w3, #1
bl Lpatch + (0xa634 - PATCH_BASE)
LFQH_Lloh1966:
adr x0, LFQH_l_.str.211
LFQH_Lloh1967:
nop
bl Lpatch + (0xa5b0 - PATCH_BASE)
mov	x20, x0
LFQH_Lloh1968:
adr x0, LFQH_l_.str.212
LFQH_Lloh1969:
nop
bl Lpatch + (0xa5a4 - PATCH_BASE)
mov	x1, x0
mov	x0, x20
bl Lpatch + (0xa5d4 - PATCH_BASE)
mov	x20, x0
LFQH_Lloh1970:
adr x0, LFQH_l_.str.182
LFQH_Lloh1971:
nop
bl Lpatch + (0xa5b0 - PATCH_BASE)
mov	x21, x0
LFQH_Lloh1972:
adr x0, LFQH_l_.str.183
LFQH_Lloh1973:
nop
bl Lpatch + (0xa5a4 - PATCH_BASE)
mov	x1, x0
mov	x0, x21
mov	x2, x19
bl Lpatch + (0xa5d4 - PATCH_BASE)
mov	x2, x0
LFQH_Lloh1974:
adr x1, LFQH_l_.str.213
LFQH_Lloh1975:
nop
mov	x0, x20
bl	LFQH_Put
ldp	d3, d0, [sp, #24]
ldp	d2, d1, [sp, #80]
bl	LFQH_RectArray
mov	x2, x0
LFQH_Lloh1976:
adr x1, LFQH_l_.str.214
LFQH_Lloh1977:
nop
mov	x0, x20
bl	LFQH_Put
ldr	d0, [sp, #16]
ldp	d2, d1, [sp, #136]
ldr	d3, [sp, #128]
bl	LFQH_RectArray
mov	x2, x0
LFQH_Lloh1978:
adr x1, LFQH_l_.str.215
LFQH_Lloh1979:
nop
mov	x0, x20
bl	LFQH_Put
ldp	d1, d0, [sp, #64]
ldp	d3, d2, [sp, #48]
bl	LFQH_RectArray
mov	x2, x0
LFQH_Lloh1980:
adr x1, LFQH_l_.str.251
LFQH_Lloh1981:
nop
mov	x0, x20
bl	LFQH_Put
mov.16b	v0, v14
mov.16b	v1, v11
mov.16b	v2, v9
mov.16b	v3, v8
bl	LFQH_RectArray
mov	x2, x0
LFQH_Lloh1982:
adr x1, LFQH_l_.str.216
LFQH_Lloh1983:
nop
mov	x0, x20
bl	LFQH_Put
ldr	d0, [sp, #8]
mov.16b	v1, v10
mov.16b	v2, v13
mov.16b	v3, v12
bl	LFQH_RectArray
mov	x2, x0
LFQH_Lloh1984:
adr x1, LFQH_l_.str.252
LFQH_Lloh1985:
nop
mov	x0, x20
bl	LFQH_Put
LFQH_Lloh1986:
adr x0, LFQH_l_.str.253
LFQH_Lloh1987:
nop
mov	x1, x20
bl Lrecord_named
LFQH_LBB129_28:
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
LFQH_IconRoleName:
.cfi_startproc
cmp	w0, #5
b.le	LFQH_LBB130_6
cmp	w0, #7
b.le	LFQH_LBB130_13
cmp	w0, #8
b.eq	LFQH_LBB130_18
cmp	w0, #9
b.eq	LFQH_LBB130_20
cmp	w0, #10
b.ne	LFQH_LBB130_21
LFQH_Lloh1988:
adr x0, LFQH_l_.str.262
LFQH_Lloh1989:
nop
ret
LFQH_LBB130_6:
cmp	w0, #3
b.gt	LFQH_LBB130_10
cmp	w0, #2
b.eq	LFQH_LBB130_16
cmp	w0, #3
b.ne	LFQH_LBB130_21
LFQH_Lloh1990:
adr x0, LFQH_l_.str.255
LFQH_Lloh1991:
nop
ret
LFQH_LBB130_10:
cmp	w0, #4
b.eq	LFQH_LBB130_17
cmp	w0, #5
b.ne	LFQH_LBB130_21
LFQH_Lloh1992:
adr x0, LFQH_l_.str.257
LFQH_Lloh1993:
nop
ret
LFQH_LBB130_13:
cmp	w0, #6
b.eq	LFQH_LBB130_19
cmp	w0, #7
b.ne	LFQH_LBB130_21
LFQH_Lloh1994:
adr x0, LFQH_l_.str.259
LFQH_Lloh1995:
nop
ret
LFQH_LBB130_16:
LFQH_Lloh1996:
adr x0, LFQH_l_.str.254
LFQH_Lloh1997:
nop
ret
LFQH_LBB130_17:
LFQH_Lloh1998:
adr x0, LFQH_l_.str.256
LFQH_Lloh1999:
nop
ret
LFQH_LBB130_18:
LFQH_Lloh2000:
adr x0, LFQH_l_.str.260
LFQH_Lloh2001:
nop
ret
LFQH_LBB130_19:
LFQH_Lloh2002:
adr x0, LFQH_l_.str.258
LFQH_Lloh2003:
nop
ret
LFQH_LBB130_20:
LFQH_Lloh2004:
adr x0, LFQH_l_.str.261
LFQH_Lloh2005:
nop
ret
LFQH_LBB130_21:
LFQH_Lloh2006:
adr x0, LFQH_l_.str.263
LFQH_Lloh2007:
nop
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
LFQH_Lloh2008:
adr x1, LFQH_ClipsKey
LFQH_Lloh2009:
nop
bl Lpatch + (0xa628 - PATCH_BASE)
mov	x21, x0
LFQH_Lloh2010:
adr x1, LFQH_OpaqueKey
LFQH_Lloh2011:
nop
mov	x0, x19
bl Lpatch + (0xa628 - PATCH_BASE)
mov	x20, x0
cbz	x21, LFQH_LBB133_3
LFQH_Lloh2012:
adr x0, LFQH_l_.str.190
LFQH_Lloh2013:
nop
bl Lpatch + (0xa5a4 - PATCH_BASE)
mov	x1, x0
mov	x0, x19
bl Lpatch + (0xa5d4 - PATCH_BASE)
cbnz	w0, LFQH_LBB133_3
LFQH_Lloh2014:
adr x0, LFQH_l_.str.201
LFQH_Lloh2015:
nop
bl Lpatch + (0xa5a4 - PATCH_BASE)
mov	x22, x0
LFQH_Lloh2016:
adr x0, LFQH_l_.str.40
LFQH_Lloh2017:
nop
bl Lpatch + (0xa5a4 - PATCH_BASE)
mov	x1, x0
mov	x0, x21
bl Lpatch + (0xa5d4 - PATCH_BASE)
mov	x2, x0
mov	x0, x19
mov	x1, x22
bl Lpatch + (0xa5d4 - PATCH_BASE)
LFQH_LBB133_3:
cbz	x20, LFQH_LBB133_6
LFQH_Lloh2018:
adr x0, LFQH_l_.str.191
LFQH_Lloh2019:
nop
bl Lpatch + (0xa5a4 - PATCH_BASE)
mov	x1, x0
mov	x0, x19
bl Lpatch + (0xa5d4 - PATCH_BASE)
cbnz	w0, LFQH_LBB133_6
LFQH_Lloh2020:
adr x0, LFQH_l_.str.200
LFQH_Lloh2021:
nop
bl Lpatch + (0xa5a4 - PATCH_BASE)
mov	x21, x0
LFQH_Lloh2022:
adr x0, LFQH_l_.str.40
LFQH_Lloh2023:
nop
bl Lpatch + (0xa5a4 - PATCH_BASE)
mov	x1, x0
mov	x0, x20
bl Lpatch + (0xa5d4 - PATCH_BASE)
mov	x2, x0
mov	x0, x19
mov	x1, x21
bl Lpatch + (0xa5d4 - PATCH_BASE)
LFQH_LBB133_6:
LFQH_Lloh2024:
adr x1, LFQH_ClipsKey
LFQH_Lloh2025:
nop
mov	x0, x19
mov	x2, #0
mov	w3, #1
bl Lpatch + (0xa634 - PATCH_BASE)
LFQH_Lloh2026:
adr x1, LFQH_OpaqueKey
LFQH_Lloh2027:
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
LFQH_Lloh2028:
adr x0, LFQH_l_.str.239
LFQH_Lloh2029:
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
LFQH_Lloh2030:
adr x0, LFQH_l_.str.239
LFQH_Lloh2031:
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
LFQH_GlassPreferenceKey:
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
LFQH_Lloh2032:
adr x1, LFQH_HeaderClipsKey
LFQH_Lloh2033:
nop
bl Lpatch + (0xa628 - PATCH_BASE)
mov	x23, x0
LFQH_Lloh2034:
adr x1, LFQH_HeaderOpaqueKey
LFQH_Lloh2035:
nop
mov	x0, x19
bl Lpatch + (0xa628 - PATCH_BASE)
mov	x22, x0
LFQH_Lloh2036:
adr x1, LFQH_HeaderRadiusKey
LFQH_Lloh2037:
nop
mov	x0, x19
bl Lpatch + (0xa628 - PATCH_BASE)
mov	x20, x0
LFQH_Lloh2038:
adr x1, LFQH_HeaderAppliedRadiusKey
LFQH_Lloh2039:
nop
mov	x0, x19
bl Lpatch + (0xa628 - PATCH_BASE)
mov	x21, x0
cbz	x23, LFQH_LBB139_3
LFQH_Lloh2040:
adr x0, LFQH_l_.str.190
LFQH_Lloh2041:
nop
bl Lpatch + (0xa5a4 - PATCH_BASE)
mov	x1, x0
mov	x0, x19
bl Lpatch + (0xa5d4 - PATCH_BASE)
cbz	w0, LFQH_LBB139_3
LFQH_Lloh2042:
adr x0, LFQH_l_.str.201
LFQH_Lloh2043:
nop
bl Lpatch + (0xa5a4 - PATCH_BASE)
mov	x24, x0
LFQH_Lloh2044:
adr x0, LFQH_l_.str.40
LFQH_Lloh2045:
nop
bl Lpatch + (0xa5a4 - PATCH_BASE)
mov	x1, x0
mov	x0, x23
bl Lpatch + (0xa5d4 - PATCH_BASE)
mov	x2, x0
mov	x0, x19
mov	x1, x24
bl Lpatch + (0xa5d4 - PATCH_BASE)
LFQH_LBB139_3:
cbz	x22, LFQH_LBB139_6
LFQH_Lloh2046:
adr x0, LFQH_l_.str.191
LFQH_Lloh2047:
nop
bl Lpatch + (0xa5a4 - PATCH_BASE)
mov	x1, x0
mov	x0, x19
bl Lpatch + (0xa5d4 - PATCH_BASE)
cbnz	w0, LFQH_LBB139_6
LFQH_Lloh2048:
adr x0, LFQH_l_.str.200
LFQH_Lloh2049:
nop
bl Lpatch + (0xa5a4 - PATCH_BASE)
mov	x23, x0
LFQH_Lloh2050:
adr x0, LFQH_l_.str.40
LFQH_Lloh2051:
nop
bl Lpatch + (0xa5a4 - PATCH_BASE)
mov	x1, x0
mov	x0, x22
bl Lpatch + (0xa5d4 - PATCH_BASE)
mov	x2, x0
mov	x0, x19
mov	x1, x23
bl Lpatch + (0xa5d4 - PATCH_BASE)
LFQH_LBB139_6:
cbz	x20, LFQH_LBB139_10
cbz	x21, LFQH_LBB139_10
LFQH_Lloh2052:
adr x0, LFQH_l_.str.202
LFQH_Lloh2053:
nop
bl Lpatch + (0xa5a4 - PATCH_BASE)
mov	x1, x0
mov	x0, x19
bl Lpatch + (0xa5d4 - PATCH_BASE)
mov	x22, x0
LFQH_Lloh2054:
adr x0, LFQH_l_.str.203
LFQH_Lloh2055:
nop
bl Lpatch + (0xa5a4 - PATCH_BASE)
mov	x1, x0
mov	x0, x22
bl Lpatch + (0xa5d4 - PATCH_BASE)
mov.16b	v8, v0
LFQH_Lloh2056:
adr x0, LFQH_l_.str.204
LFQH_Lloh2057:
nop
bl Lpatch + (0xa5a4 - PATCH_BASE)
mov	x1, x0
mov	x0, x21
bl Lpatch + (0xa5d4 - PATCH_BASE)
fcmp	d8, d0
b.ne	LFQH_LBB139_10
LFQH_Lloh2058:
adr x0, LFQH_l_.str.204
LFQH_Lloh2059:
nop
bl Lpatch + (0xa5a4 - PATCH_BASE)
mov	x1, x0
mov	x0, x20
bl Lpatch + (0xa5d4 - PATCH_BASE)
mov.16b	v8, v0
LFQH_Lloh2060:
adr x0, LFQH_l_.str.202
LFQH_Lloh2061:
nop
bl Lpatch + (0xa5a4 - PATCH_BASE)
mov	x1, x0
mov	x0, x19
bl Lpatch + (0xa5d4 - PATCH_BASE)
mov	x20, x0
LFQH_Lloh2062:
adr x0, LFQH_l_.str.207
LFQH_Lloh2063:
nop
bl Lpatch + (0xa5a4 - PATCH_BASE)
mov	x1, x0
mov	x0, x20
mov.16b	v0, v8
bl Lpatch + (0xa5d4 - PATCH_BASE)
LFQH_LBB139_10:
LFQH_Lloh2064:
adr x1, LFQH_HeaderClipsKey
LFQH_Lloh2065:
nop
mov	x0, x19
mov	x2, #0
mov	w3, #1
bl Lpatch + (0xa634 - PATCH_BASE)
LFQH_Lloh2066:
adr x1, LFQH_HeaderOpaqueKey
LFQH_Lloh2067:
nop
mov	x0, x19
mov	x2, #0
mov	w3, #1
bl Lpatch + (0xa634 - PATCH_BASE)
LFQH_Lloh2068:
adr x1, LFQH_HeaderRadiusKey
LFQH_Lloh2069:
nop
mov	x0, x19
mov	x2, #0
mov	w3, #1
bl Lpatch + (0xa634 - PATCH_BASE)
LFQH_Lloh2070:
adr x1, LFQH_HeaderAppliedRadiusKey
LFQH_Lloh2071:
nop
mov	x0, x19
mov	x2, #0
mov	w3, #1
bl Lpatch + (0xa634 - PATCH_BASE)
LFQH_Lloh2072:
adr x1, LFQH_HeaderLogKey
LFQH_Lloh2073:
nop
mov	x0, x19
mov	x2, #0
mov	w3, #1
bl Lpatch + (0xa634 - PATCH_BASE)
LFQH_Lloh2074:
adr x1, LFQH_HeaderLogTimeKey
LFQH_Lloh2075:
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
LFQH_ReaderBottomType:
.cfi_startproc
stp	x20, x19, [sp, #-32]!
stp	x29, x30, [sp, #16]
add	x29, sp, #16
.cfi_def_cfa w29, 16
.cfi_offset w30, -8
.cfi_offset w29, -16
.cfi_offset w19, -24
.cfi_offset w20, -32
LFQH_Lloh2076:
adr x1, LFQH_l_.str.278
LFQH_Lloh2077:
nop
bl	LFQH_Get
mov	x19, x0
LFQH_Lloh2078:
adr x1, LFQH_l_.str.279
LFQH_Lloh2079:
nop
bl	LFQH_Kind
cbz	w0, LFQH_LBB140_2
LFQH_Lloh2080:
adr x0, LFQH_l_.str.280
LFQH_Lloh2081:
nop
bl Lpatch + (0xa5a4 - PATCH_BASE)
mov	x1, x0
mov	x0, x19
ldp	x29, x30, [sp, #16]
ldp	x20, x19, [sp], #32
b Lpatch + (0xa5d4 - PATCH_BASE)
LFQH_LBB140_2:
ldp	x29, x30, [sp, #16]
ldp	x20, x19, [sp], #32
ret
.cfi_endproc
.p2align	2
LFQH_ShelfEditHeaderKey:
.cfi_startproc
ret
.cfi_endproc
.p2align	2
LFQH_ShelfEditFrame:
.cfi_startproc
sub	sp, sp, #192
stp	d15, d14, [sp, #32]
stp	d13, d12, [sp, #48]
stp	d11, d10, [sp, #64]
stp	d9, d8, [sp, #80]
stp	x28, x27, [sp, #96]
stp	x26, x25, [sp, #112]
stp	x24, x23, [sp, #128]
stp	x22, x21, [sp, #144]
stp	x20, x19, [sp, #160]
stp	x29, x30, [sp, #176]
add	x29, sp, #176
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
.cfi_offset b14, -152
.cfi_offset b15, -160
mov	x21, x2
mov	x20, x1
mov	x23, x0
LFQH_Lloh2082:
adr x1, LFQH_l_.str.301
LFQH_Lloh2083:
nop
bl	LFQH_Get
mov	x22, x0
LFQH_Lloh2084:
adr x1, LFQH_l_.str.291
LFQH_Lloh2085:
nop
bl	LFQH_Get
mov	x19, x0
LFQH_Lloh2086:
adr x1, LFQH_l_.str.302
LFQH_Lloh2087:
nop
mov	x0, x22
bl	LFQH_Kind
fmov	d8, xzr
cbz	w0, LFQH_LBB142_5
LFQH_Lloh2088:
adr x1, LFQH_l_.str.303
LFQH_Lloh2089:
nop
mov	x0, x22
bl	LFQH_Get
cmp	x19, #0
ccmp	x0, x23, #0, ne
b.ne	LFQH_LBB142_5
LFQH_Lloh2090:
adr x1, LFQH_l_.str.304
LFQH_Lloh2091:
nop
mov	x0, x22
bl	LFQH_Get
cmp	x0, x20
b.ne	LFQH_LBB142_5
LFQH_Lloh2092:
adr x1, LFQH_l_.str.20
LFQH_Lloh2093:
nop
mov	x0, x20
bl	LFQH_Get
cmp	x0, x19
b.ne	LFQH_LBB142_5
LFQH_Lloh2094:
adr x0, LFQH_l_.str.190
LFQH_Lloh2095:
nop
bl Lpatch + (0xa5a4 - PATCH_BASE)
mov	x1, x0
mov	x0, x20
bl Lpatch + (0xa5d4 - PATCH_BASE)
cbz	w0, LFQH_LBB142_7
LFQH_LBB142_5:
fmov	d1, xzr
fmov	d2, xzr
fmov	d3, xzr
LFQH_LBB142_6:
mov.16b	v0, v8
ldp	x29, x30, [sp, #176]
ldp	x20, x19, [sp, #160]
ldp	x22, x21, [sp, #144]
ldp	x24, x23, [sp, #128]
ldp	x26, x25, [sp, #112]
ldp	x28, x27, [sp, #96]
ldp	d9, d8, [sp, #80]
ldp	d11, d10, [sp, #64]
ldp	d13, d12, [sp, #48]
ldp	d15, d14, [sp, #32]
add	sp, sp, #192
ret
LFQH_LBB142_7:
mov	x0, x20
bl	LFQH_CanExpandHit
cbz	w0, LFQH_LBB142_5
LFQH_Lloh2096:
adr x1, LFQH_l_.str.37
LFQH_Lloh2097:
nop
mov	x0, x23
bl	LFQH_Get
mov	x24, x0
LFQH_Lloh2098:
adr x1, LFQH_l_.str.38
LFQH_Lloh2099:
nop
mov	x0, x23
bl	LFQH_Get
mov	x23, x0
LFQH_Lloh2100:
adr x0, LFQH_l_.str.230
LFQH_Lloh2101:
nop
bl Lpatch + (0xa5a4 - PATCH_BASE)
mov	x1, x0
mov	x0, x24
bl Lpatch + (0xa5d4 - PATCH_BASE)
cmp	w0, #0
csel	x23, x24, x23, eq
LFQH_Lloh2102:
adr x1, LFQH_l_.str.305
LFQH_Lloh2103:
nop
mov	x0, x22
bl	LFQH_Get
mov	x22, x0
LFQH_Lloh2104:
adr x1, LFQH_l_.str.249
LFQH_Lloh2105:
nop
mov	x0, x20
bl	LFQH_Get
cbz	x0, LFQH_LBB142_5
mov	x24, x0
LFQH_Lloh2106:
adr x1, LFQH_l_.str.249
LFQH_Lloh2107:
nop
mov	x0, x22
bl	LFQH_Get
cmp	x0, x24
b.ne	LFQH_LBB142_5
LFQH_Lloh2108:
adr x0, LFQH_l_.str.230
LFQH_Lloh2109:
nop
bl Lpatch + (0xa5a4 - PATCH_BASE)
mov	x1, x0
mov	x0, x22
bl Lpatch + (0xa5d4 - PATCH_BASE)
cbnz	w0, LFQH_LBB142_5
cbz	x23, LFQH_LBB142_5
mov	w25, #0
LFQH_Lloh2110:
adr x24, LFQH_l_.str.20
LFQH_Lloh2111:
nop
mov	x0, x23
LFQH_LBB142_13:
cmp	x0, x20
b.eq	LFQH_LBB142_16
mov	x1, x24
bl	LFQH_Get
cbz	x0, LFQH_LBB142_5
cmp	w25, #7
add	w25, w25, #1
b.hs	LFQH_LBB142_5
b	LFQH_LBB142_13
LFQH_LBB142_16:
LFQH_Lloh2112:
adr x0, LFQH_l_.str.230
LFQH_Lloh2113:
nop
bl Lpatch + (0xa5a4 - PATCH_BASE)
mov	x1, x0
mov	x0, x23
bl Lpatch + (0xa5d4 - PATCH_BASE)
fmov	d1, xzr
fmov	d2, xzr
fmov	d3, xzr
cbnz	w0, LFQH_LBB142_6
LFQH_Lloh2114:
adr x0, LFQH_l_.str.24
LFQH_Lloh2115:
nop
bl Lpatch + (0xa5a4 - PATCH_BASE)
mov	x1, x0
mov	x0, x23
bl Lpatch + (0xa5d4 - PATCH_BASE)
mov.16b	v8, v0
mov.16b	v9, v1
mov.16b	v10, v2
mov.16b	v11, v3
LFQH_Lloh2116:
adr x0, LFQH_l_.str.241
LFQH_Lloh2117:
nop
bl Lpatch + (0xa5a4 - PATCH_BASE)
mov	x1, x0
mov	x0, x23
mov.16b	v0, v8
mov.16b	v1, v9
mov.16b	v2, v10
mov.16b	v3, v11
mov	x2, x20
bl Lpatch + (0xa5d4 - PATCH_BASE)
mov.16b	v11, v0
stp	d3, d1, [sp, #16]
str	d2, [sp, #8]
LFQH_Lloh2118:
adr x1, LFQH_IconGlassKey
LFQH_Lloh2119:
nop
mov	x0, x23
bl Lpatch + (0xa628 - PATCH_BASE)
cbz	x0, LFQH_LBB142_19
mov	x24, x0
LFQH_Lloh2120:
adr x0, LFQH_l_.str.192
LFQH_Lloh2121:
nop
bl Lpatch + (0xa5a4 - PATCH_BASE)
mov	x1, x0
mov	x0, x24
bl Lpatch + (0xa5d4 - PATCH_BASE)
mov.16b	v8, v0
mov.16b	v13, v1
mov.16b	v14, v2
mov.16b	v15, v3
LFQH_Lloh2122:
adr x0, LFQH_l_.str.241
LFQH_Lloh2123:
nop
bl Lpatch + (0xa5a4 - PATCH_BASE)
mov	x1, x0
mov	x0, x23
mov.16b	v0, v8
mov.16b	v1, v13
mov.16b	v2, v14
mov.16b	v3, v15
mov	x2, x20
bl Lpatch + (0xa5d4 - PATCH_BASE)
fcmp	d0, d11
fcsel	d11, d0, d11, mi
LFQH_LBB142_19:
LFQH_Lloh2124:
adr x1, LFQH_l_.str.298
LFQH_Lloh2125:
nop
mov	x0, x22
bl	LFQH_Get
LFQH_Lloh2126:
adr x1, LFQH_l_.str.306
LFQH_Lloh2127:
nop
bl	LFQH_Get
mov	x22, x0
LFQH_Lloh2128:
adr x0, LFQH_l_.str.34
LFQH_Lloh2129:
nop
bl Lpatch + (0xa5a4 - PATCH_BASE)
mov	x1, x0
mov	x0, x22
bl Lpatch + (0xa5d4 - PATCH_BASE)
fmov	d8, xzr
cbz	x0, LFQH_LBB142_26
mov	x23, x0
mov	w27, #0
mov	x24, #0
LFQH_Lloh2130:
adr x25, LFQH_l_.str.264
LFQH_Lloh2131:
nop
LFQH_Lloh2132:
adr x26, LFQH_l_.str.118
LFQH_Lloh2133:
nop
fmov	d9, xzr
fmov	d10, #4.00000000
LFQH_LBB142_21:
mov	x0, x25
bl Lpatch + (0xa5a4 - PATCH_BASE)
mov	x1, x0
mov	x0, x22
mov	x2, x24
bl Lpatch + (0xa5d4 - PATCH_BASE)
mov	x28, x0
mov	x1, x26
bl	LFQH_Kind
cbz	w0, LFQH_LBB142_24
LFQH_Lloh2134:
adr x0, LFQH_l_.str.230
LFQH_Lloh2135:
nop
bl Lpatch + (0xa5a4 - PATCH_BASE)
mov	x1, x0
mov	x0, x28
bl Lpatch + (0xa5d4 - PATCH_BASE)
cbnz	w0, LFQH_LBB142_24
LFQH_Lloh2136:
adr x0, LFQH_l_.str.24
LFQH_Lloh2137:
nop
bl Lpatch + (0xa5a4 - PATCH_BASE)
mov	x1, x0
mov	x0, x28
bl Lpatch + (0xa5d4 - PATCH_BASE)
mov.16b	v13, v0
mov.16b	v14, v1
mov.16b	v15, v2
mov.16b	v12, v3
LFQH_Lloh2138:
adr x0, LFQH_l_.str.241
LFQH_Lloh2139:
nop
bl Lpatch + (0xa5a4 - PATCH_BASE)
mov	x1, x0
mov	x0, x28
mov.16b	v0, v13
mov.16b	v1, v14
mov.16b	v2, v15
mov.16b	v3, v12
mov	x2, x20
bl Lpatch + (0xa5d4 - PATCH_BASE)
fadd	d0, d0, d2
fadd	d0, d0, d10
fcmp	d0, d9
ccmp	w27, #0, #4, le
fcsel	d9, d0, d9, eq
mov	w27, #1
LFQH_LBB142_24:
add	x24, x24, #1
cmp	x23, x24
b.ne	LFQH_LBB142_21
cmp	w27, #0
cset	w22, eq
b	LFQH_LBB142_27
LFQH_LBB142_26:
mov	w22, #1
fmov	d9, xzr
LFQH_LBB142_27:
LFQH_Lloh2140:
adr x0, LFQH_l_.str.24
LFQH_Lloh2141:
nop
bl Lpatch + (0xa5a4 - PATCH_BASE)
mov	x1, x0
mov	x0, x21
bl Lpatch + (0xa5d4 - PATCH_BASE)
mov	x8, #4631389266797133824
fmov	d0, x8
fcmp	d2, d0
fcsel	d13, d0, d2, mi
tbnz	w22, #0, LFQH_LBB142_5
mov.16b	v0, v11
ldp	d3, d1, [sp, #16]
ldr	d2, [sp, #8]
bl	LFQH_VisibleRect
cbz	w0, LFQH_LBB142_5
fsub	d0, d11, d9
fmov	d1, #20.00000000
fadd	d1, d13, d1
fcmp	d0, d1
b.mi	LFQH_LBB142_5
fmov	d0, #10.00000000
fadd	d11, d9, d0
fmov	d0, #0.50000000
ldp	d2, d1, [sp, #16]
fmul	d0, d2, d0
fadd	d0, d1, d0
fmov	d1, #-15.00000000
fadd	d9, d0, d1
LFQH_Lloh2142:
adr x0, LFQH_l_.str.241
LFQH_Lloh2143:
nop
bl Lpatch + (0xa5a4 - PATCH_BASE)
mov	x1, x0
fmov	d3, #30.00000000
mov	x0, x20
mov.16b	v0, v11
mov.16b	v1, v9
mov.16b	v2, v13
mov	x2, x19
bl Lpatch + (0xa5d4 - PATCH_BASE)
mov.16b	v14, v0
mov.16b	v10, v1
mov.16b	v15, v2
mov.16b	v12, v3
LFQH_Lloh2144:
adr x0, LFQH_l_.str.24
LFQH_Lloh2145:
nop
bl Lpatch + (0xa5a4 - PATCH_BASE)
mov	x1, x0
mov	x0, x19
bl Lpatch + (0xa5d4 - PATCH_BASE)
fcmp	d14, d0
fccmp	d10, d1, #8, pl
b.mi	LFQH_LBB142_5
fadd	d4, d14, d15
fadd	d0, d0, d2
fcmp	d4, d0
b.gt	LFQH_LBB142_5
fadd	d0, d10, d12
fadd	d1, d1, d3
fcmp	d0, d1
fmov	d1, xzr
fmov	d2, xzr
fmov	d3, xzr
b.gt	LFQH_LBB142_6
fmov	d3, #30.00000000
mov.16b	v8, v11
mov.16b	v1, v9
mov.16b	v2, v13
b	LFQH_LBB142_6
.cfi_endproc
.p2align	2
LFQH_ShelfActionGlass:
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
LFQH_Lloh2146:
adr x1, LFQH_l_.str.228
LFQH_Lloh2147:
nop
bl	LFQH_Kind
cbz	w0, LFQH_LBB143_3
LFQH_Lloh2148:
adr x0, LFQH_l_.str.230
LFQH_Lloh2149:
nop
bl Lpatch + (0xa5a4 - PATCH_BASE)
mov	x1, x0
mov	x0, x19
bl Lpatch + (0xa5d4 - PATCH_BASE)
cbz	w0, LFQH_LBB143_4
mov	x0, x19
ldp	x29, x30, [sp, #16]
ldp	x20, x19, [sp], #32
b	LFQH_PageRestore
LFQH_LBB143_3:
ldp	x29, x30, [sp, #16]
ldp	x20, x19, [sp], #32
ret
LFQH_LBB143_4:
LFQH_Lloh2150:
adr x0, LFQH_l_.str.24
LFQH_Lloh2151:
nop
bl Lpatch + (0xa5a4 - PATCH_BASE)
mov	x1, x0
mov	x0, x19
bl Lpatch + (0xa5d4 - PATCH_BASE)
fmov	d4, #1.00000000
fadd	d1, d1, d4
fmov	d4, #-2.00000000
fadd	d3, d3, d4
mov	x0, x19
mov	w1, #0
ldp	x29, x30, [sp, #16]
ldp	x20, x19, [sp], #32
b	LFQH_ApplySurface
.cfi_endproc
.p2align	2
LFQH_ShelfCompactKey:
.cfi_startproc
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
cbz	x0, LFQH_LBB145_3
mov	x19, x0
LFQH_Lloh2152:
adr x0, LFQH_l_.str.185
LFQH_Lloh2153:
nop
bl Lpatch + (0xa5a4 - PATCH_BASE)
mov	x20, x0
LFQH_Lloh2154:
adr x0, LFQH_l_.str.23
LFQH_Lloh2155:
nop
bl Lpatch + (0xa5b0 - PATCH_BASE)
mov	x2, x0
mov	x0, x19
mov	x1, x20
bl Lpatch + (0xa5d4 - PATCH_BASE)
cbz	w0, LFQH_LBB145_3
LFQH_Lloh2156:
adr x1, LFQH_SurfaceKey
LFQH_Lloh2157:
nop
mov	x0, x19
bl Lpatch + (0xa628 - PATCH_BASE)
mov	x1, x0
mov	x0, x19
ldp	x29, x30, [sp, #16]
ldp	x20, x19, [sp], #32
b	LFQH_Restore
LFQH_LBB145_3:
ldp	x29, x30, [sp, #16]
ldp	x20, x19, [sp], #32
ret
.cfi_endproc
.p2align	2
LFQH_ToggleChanged:
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
mov	x21, x2
LFQH_Lloh2158:
adr x0, LFQH_l_.str.313
LFQH_Lloh2159:
nop
bl Lpatch + (0xa5a4 - PATCH_BASE)
mov	x1, x0
mov	x0, x21
bl Lpatch + (0xa5d4 - PATCH_BASE)
mov	x22, x0
bl	LFQH_PagePreference
cbz	x0, LFQH_LBB146_27
mov	x20, x0
LFQH_Lloh2160:
adr x1, LFQH_l_.str.314
LFQH_Lloh2161:
nop
mov	x0, x21
bl	LFQH_BoolProp
mov	x28, x0
cmp	x22, #6
b.lt	LFQH_LBB146_10
mov	x0, x20
mov	x1, x28
bl	LFQH_SetDefault
cmp	x22, #7
b.eq	LFQH_LBB146_24
cmp	x22, #6
b.ne	LFQH_LBB146_27
LFQH_Lloh2162:
adr x0, LFQH_l_.str.21
LFQH_Lloh2163:
nop
bl Lpatch + (0xa5b0 - PATCH_BASE)
LFQH_Lloh2164:
adr x1, LFQH_ShelfDurationHeadersKey
LFQH_Lloh2165:
nop
bl Lpatch + (0xa628 - PATCH_BASE)
mov	x19, x0
LFQH_Lloh2166:
adr x0, LFQH_l_.str.322
LFQH_Lloh2167:
nop
bl Lpatch + (0xa5a4 - PATCH_BASE)
mov	x1, x0
mov	x0, x19
bl Lpatch + (0xa5d4 - PATCH_BASE)
mov	x20, x0
LFQH_Lloh2168:
adr x0, LFQH_l_.str.34
LFQH_Lloh2169:
nop
bl Lpatch + (0xa5a4 - PATCH_BASE)
mov	x1, x0
mov	x0, x20
bl Lpatch + (0xa5d4 - PATCH_BASE)
cbz	x0, LFQH_LBB146_27
mov	x21, x0
mov	x22, #0
LFQH_Lloh2170:
adr x26, LFQH_l_.str.147
LFQH_Lloh2171:
nop
LFQH_Lloh2172:
adr x27, LFQH_l_.str.146
LFQH_Lloh2173:
nop
LFQH_Lloh2174:
adr x25, LFQH_l_.str.297
LFQH_Lloh2175:
nop
LFQH_LBB146_6:
LFQH_Lloh2176:
adr x0, LFQH_l_.str.264
LFQH_Lloh2177:
nop
bl Lpatch + (0xa5a4 - PATCH_BASE)
mov	x1, x0
mov	x0, x20
mov	x2, x22
bl Lpatch + (0xa5d4 - PATCH_BASE)
mov	x19, x0
LFQH_Lloh2178:
adr x1, LFQH_ShelfDurationRequestedKey
LFQH_Lloh2179:
nop
bl Lpatch + (0xa628 - PATCH_BASE)
cbz	w28, LFQH_LBB146_8
LFQH_Lloh2180:
adr x1, LFQH_l_.str.40
LFQH_Lloh2181:
nop
bl	LFQH_BoolProp
cmp	w0, #0
cset	w23, ne
b	LFQH_LBB146_9
LFQH_LBB146_8:
mov	w23, #0
LFQH_LBB146_9:
LFQH_Lloh2182:
adr x0, LFQH_l_.str.21
LFQH_Lloh2183:
nop
mov	x1, x26
bl	LFQH_Original
mov	x24, x0
mov	x0, x27
bl Lpatch + (0xa5a4 - PATCH_BASE)
mov	x1, x0
mov	x0, x19
mov	x2, x23
blr	x24
mov	x0, x25
bl Lpatch + (0xa5a4 - PATCH_BASE)
mov	x1, x0
mov	x0, x19
bl Lpatch + (0xa5d4 - PATCH_BASE)
add	x22, x22, #1
cmp	x21, x22
b.ne	LFQH_LBB146_6
b	LFQH_LBB146_27
LFQH_LBB146_10:
LFQH_Lloh2184:
adr x0, LFQH_l_.str.324
LFQH_Lloh2185:
nop
bl Lpatch + (0xa5b0 - PATCH_BASE)
mov	x19, x0
LFQH_Lloh2186:
adr x0, LFQH_l_.str.325
LFQH_Lloh2187:
nop
bl Lpatch + (0xa5a4 - PATCH_BASE)
mov	x1, x0
mov	x0, x19
bl Lpatch + (0xa5d4 - PATCH_BASE)
mov	x19, x0
LFQH_Lloh2188:
adr x1, LFQH_l_.str.326
LFQH_Lloh2189:
nop
bl	LFQH_Get
LFQH_Lloh2190:
adr x1, LFQH_l_.str.327
LFQH_Lloh2191:
nop
bl	LFQH_Get
mov	w1, #5
bl	LFQH_FindTabOwner
cbz	x0, LFQH_LBB146_12
LFQH_LBB146_11:
mov	x23, x0
b	LFQH_LBB146_17
LFQH_LBB146_12:
LFQH_Lloh2192:
adr x1, LFQH_l_.str.328
LFQH_Lloh2193:
nop
mov	x0, x19
bl	LFQH_Get
mov	x24, x0
LFQH_Lloh2194:
adr x0, LFQH_l_.str.34
LFQH_Lloh2195:
nop
bl Lpatch + (0xa5a4 - PATCH_BASE)
mov	x1, x0
mov	x0, x24
bl Lpatch + (0xa5d4 - PATCH_BASE)
cbz	x0, LFQH_LBB146_16
mov	x19, x0
mov	x25, #0
LFQH_Lloh2196:
adr x26, LFQH_l_.str.264
LFQH_Lloh2197:
nop
LFQH_Lloh2198:
adr x27, LFQH_l_.str.327
LFQH_Lloh2199:
nop
LFQH_LBB146_14:
mov	x0, x26
bl Lpatch + (0xa5a4 - PATCH_BASE)
mov	x1, x0
mov	x0, x24
mov	x2, x25
bl Lpatch + (0xa5d4 - PATCH_BASE)
mov	x1, x27
bl	LFQH_Get
mov	w1, #5
bl	LFQH_FindTabOwner
cbnz	x0, LFQH_LBB146_11
add	x25, x25, #1
cmp	x19, x25
b.ne	LFQH_LBB146_14
LFQH_LBB146_16:
mov	x23, #0
LFQH_LBB146_17:
LFQH_Lloh2200:
adr x1, LFQH_l_.str.315
LFQH_Lloh2201:
nop
mov	x0, x23
bl	LFQH_Get
cbnz	w28, LFQH_LBB146_21
mov	x19, x0
LFQH_Lloh2202:
adr x0, LFQH_l_.str.34
LFQH_Lloh2203:
nop
bl Lpatch + (0xa5a4 - PATCH_BASE)
mov	x1, x0
mov	x0, x19
bl Lpatch + (0xa5d4 - PATCH_BASE)
cmp	x0, #1
b.ne	LFQH_LBB146_21
LFQH_Lloh2204:
adr x0, LFQH_l_.str.264
LFQH_Lloh2205:
nop
bl Lpatch + (0xa5a4 - PATCH_BASE)
mov	x1, x0
mov	x0, x19
mov	x2, #0
bl Lpatch + (0xa5d4 - PATCH_BASE)
mov	x1, x0
mov	x0, x23
bl	LFQH_TabOption
cmp	x0, x22
b.ne	LFQH_LBB146_21
LFQH_Lloh2206:
adr x0, LFQH_l_.str.316
LFQH_Lloh2207:
nop
bl Lpatch + (0xa5a4 - PATCH_BASE)
mov	x1, x0
mov	x0, x21
mov	w2, #1
mov	w3, #1
ldp	x29, x30, [sp, #80]
ldp	x20, x19, [sp, #64]
ldp	x22, x21, [sp, #48]
ldp	x24, x23, [sp, #32]
ldp	x26, x25, [sp, #16]
ldp	x28, x27, [sp], #96
b Lpatch + (0xa5d4 - PATCH_BASE)
LFQH_LBB146_21:
mov	x0, x20
mov	x1, x28
bl	LFQH_SetDefault
cbz	x23, LFQH_LBB146_23
LFQH_Lloh2208:
adr x0, LFQH_l_.str.317
LFQH_Lloh2209:
nop
bl Lpatch + (0xa5a4 - PATCH_BASE)
mov	x1, x0
mov	x0, x23
bl Lpatch + (0xa5d4 - PATCH_BASE)
mov	x0, x23
bl	LFQH_InstallTabRecovery
LFQH_LBB146_23:
LFQH_Lloh2210:
adr x0, LFQH_l_.str.211
LFQH_Lloh2211:
nop
bl Lpatch + (0xa5b0 - PATCH_BASE)
mov	x19, x0
LFQH_Lloh2212:
adr x0, LFQH_l_.str.212
LFQH_Lloh2213:
nop
bl Lpatch + (0xa5a4 - PATCH_BASE)
mov	x1, x0
mov	x0, x19
bl Lpatch + (0xa5d4 - PATCH_BASE)
mov	x21, x0
LFQH_Lloh2214:
adr x0, LFQH_l_.str.182
LFQH_Lloh2215:
nop
bl Lpatch + (0xa5b0 - PATCH_BASE)
mov	x19, x0
LFQH_Lloh2216:
adr x0, LFQH_l_.str.183
LFQH_Lloh2217:
nop
bl Lpatch + (0xa5a4 - PATCH_BASE)
mov	x1, x0
LFQH_Lloh2218:
adr x22, LFQH_l_.str.318
LFQH_Lloh2219:
nop
mov	x0, x19
mov	x2, x22
bl Lpatch + (0xa5d4 - PATCH_BASE)
mov	x2, x0
LFQH_Lloh2220:
adr x1, LFQH_l_.str.283
LFQH_Lloh2221:
nop
mov	x0, x21
bl	LFQH_Put
LFQH_Lloh2222:
adr x1, LFQH_l_.str.319
LFQH_Lloh2223:
nop
mov	x0, x21
mov	x2, x20
bl	LFQH_Put
LFQH_Lloh2224:
adr x0, LFQH_l_.str.205
LFQH_Lloh2225:
nop
bl Lpatch + (0xa5b0 - PATCH_BASE)
mov	x19, x0
LFQH_Lloh2226:
adr x0, LFQH_l_.str.271
LFQH_Lloh2227:
nop
bl Lpatch + (0xa5a4 - PATCH_BASE)
mov	x1, x0
mov	x0, x19
mov	x2, x28
bl Lpatch + (0xa5d4 - PATCH_BASE)
mov	x2, x0
LFQH_Lloh2228:
adr x1, LFQH_l_.str.320
LFQH_Lloh2229:
nop
mov	x0, x21
bl	LFQH_Put
mov	x0, x22
mov	x1, x21
ldp	x29, x30, [sp, #80]
ldp	x20, x19, [sp, #64]
ldp	x22, x21, [sp, #48]
ldp	x24, x23, [sp, #32]
ldp	x26, x25, [sp, #16]
ldp	x28, x27, [sp], #96
b Lrecord_named
LFQH_LBB146_24:
LFQH_Lloh2230:
adr x0, LFQH_l_.str.142
LFQH_Lloh2231:
nop
bl Lpatch + (0xa5b0 - PATCH_BASE)
LFQH_Lloh2232:
adr x1, LFQH_MineControllersKey
LFQH_Lloh2233:
nop
bl Lpatch + (0xa628 - PATCH_BASE)
mov	x19, x0
LFQH_Lloh2234:
adr x0, LFQH_l_.str.322
LFQH_Lloh2235:
nop
bl Lpatch + (0xa5a4 - PATCH_BASE)
mov	x1, x0
mov	x0, x19
bl Lpatch + (0xa5d4 - PATCH_BASE)
mov	x19, x0
LFQH_Lloh2236:
adr x0, LFQH_l_.str.34
LFQH_Lloh2237:
nop
bl Lpatch + (0xa5a4 - PATCH_BASE)
mov	x1, x0
mov	x0, x19
bl Lpatch + (0xa5d4 - PATCH_BASE)
cbz	x0, LFQH_LBB146_27
mov	x20, x0
mov	x21, #0
LFQH_Lloh2238:
adr x23, LFQH_l_.str.120
LFQH_Lloh2239:
nop
LFQH_Lloh2240:
adr x24, LFQH_l_.str.182
LFQH_Lloh2241:
nop
LFQH_Lloh2242:
adr x25, LFQH_l_.str.183
LFQH_Lloh2243:
nop
LFQH_Lloh2244:
adr x26, LFQH_l_.str.323
LFQH_Lloh2245:
nop
LFQH_LBB146_26:
LFQH_Lloh2246:
adr x0, LFQH_l_.str.264
LFQH_Lloh2247:
nop
bl Lpatch + (0xa5a4 - PATCH_BASE)
mov	x1, x0
mov	x0, x19
mov	x2, x21
bl Lpatch + (0xa5d4 - PATCH_BASE)
mov	x27, x0
mov	x0, x23
bl Lpatch + (0xa5a4 - PATCH_BASE)
mov	x28, x0
mov	x0, x24
bl Lpatch + (0xa5b0 - PATCH_BASE)
mov	x22, x0
mov	x0, x25
bl Lpatch + (0xa5a4 - PATCH_BASE)
mov	x1, x0
mov	x0, x22
mov	x2, x26
bl Lpatch + (0xa5d4 - PATCH_BASE)
mov	x2, x0
mov	x0, x27
mov	x1, x28
bl Lpatch + (0xa5d4 - PATCH_BASE)
add	x21, x21, #1
cmp	x20, x21
b.ne	LFQH_LBB146_26
LFQH_LBB146_27:
ldp	x29, x30, [sp, #80]
ldp	x20, x19, [sp, #64]
ldp	x22, x21, [sp, #48]
ldp	x24, x23, [sp, #32]
ldp	x26, x25, [sp, #16]
ldp	x28, x27, [sp], #96
ret
.cfi_endproc
.p2align	2
LFQH_RecoverOptions:
.cfi_startproc
stp	x20, x19, [sp, #-32]!
stp	x29, x30, [sp, #16]
add	x29, sp, #16
.cfi_def_cfa w29, 16
.cfi_offset w30, -8
.cfi_offset w29, -16
.cfi_offset w19, -24
.cfi_offset w20, -32
mov	x20, x2
mov	x19, x0
LFQH_Lloh2248:
adr x0, LFQH_l_.str.344
LFQH_Lloh2249:
nop
bl Lpatch + (0xa5a4 - PATCH_BASE)
mov	x1, x0
mov	x0, x20
bl Lpatch + (0xa5d4 - PATCH_BASE)
cmp	x0, #1
b.ne	LFQH_LBB147_3
LFQH_Lloh2250:
adr x1, LFQH_RecoveryBarKey
LFQH_Lloh2251:
nop
mov	x0, x19
bl Lpatch + (0xa628 - PATCH_BASE)
mov	x19, x0
LFQH_Lloh2252:
adr x0, LFQH_l_.str.348
LFQH_Lloh2253:
nop
bl Lpatch + (0xa5a4 - PATCH_BASE)
mov	x1, x0
mov	x0, x19
bl Lpatch + (0xa5d4 - PATCH_BASE)
LFQH_Lloh2254:
adr x1, LFQH_l_.str.301
LFQH_Lloh2255:
nop
bl	LFQH_Get
mov	x19, x0
LFQH_Lloh2256:
adr x1, LFQH_l_.str.156
LFQH_Lloh2257:
nop
bl	LFQH_Kind
cbz	w0, LFQH_LBB147_3
LFQH_Lloh2258:
adr x1, LFQH_l_.str.345
LFQH_Lloh2259:
nop
mov	x0, x19
bl	LFQH_Get
cbz	x0, LFQH_LBB147_4
LFQH_LBB147_3:
ldp	x29, x30, [sp, #16]
ldp	x20, x19, [sp], #32
ret
LFQH_LBB147_4:
LFQH_Lloh2260:
adr x0, LFQH_l_.str.346
LFQH_Lloh2261:
nop
bl Lpatch + (0xa5a4 - PATCH_BASE)
mov	x20, x0
LFQH_Lloh2262:
adr x0, LFQH_l_.str.347
LFQH_Lloh2263:
nop
bl Lpatch + (0xa5b0 - PATCH_BASE)
mov	x1, x20
bl Lpatch + (0xa5f8 - PATCH_BASE)
cbz	x0, LFQH_LBB147_3
bl Lpatch + (0xa598 - PATCH_BASE)
mov	x2, x0
mov	x0, x19
mov	x1, x20
ldp	x29, x30, [sp, #16]
ldp	x20, x19, [sp], #32
br	x2
.cfi_endproc
.p2align	2
LFQH_RecoveryTouch:
.cfi_startproc
stp	d9, d8, [sp, #-64]!
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
.cfi_offset b8, -56
.cfi_offset b9, -64
mov	x19, x3
LFQH_Lloh2264:
adr x1, LFQH_RecoveryBarKey
LFQH_Lloh2265:
nop
bl Lpatch + (0xa628 - PATCH_BASE)
mov	x20, x0
LFQH_Lloh2266:
adr x0, LFQH_l_.str.348
LFQH_Lloh2267:
nop
bl Lpatch + (0xa5a4 - PATCH_BASE)
mov	x1, x0
mov	x0, x20
bl Lpatch + (0xa5d4 - PATCH_BASE)
cbz	x0, LFQH_LBB148_4
mov	x20, x0
LFQH_Lloh2268:
adr x0, LFQH_l_.str.230
LFQH_Lloh2269:
nop
bl Lpatch + (0xa5a4 - PATCH_BASE)
mov	x1, x0
mov	x0, x20
bl Lpatch + (0xa5d4 - PATCH_BASE)
cbnz	w0, LFQH_LBB148_3
LFQH_Lloh2270:
adr x0, LFQH_l_.str.182
LFQH_Lloh2271:
nop
bl Lpatch + (0xa5b0 - PATCH_BASE)
mov	x21, x0
LFQH_Lloh2272:
adr x0, LFQH_l_.str.183
LFQH_Lloh2273:
nop
bl Lpatch + (0xa5a4 - PATCH_BASE)
mov	x1, x0
LFQH_Lloh2274:
adr x2, LFQH_l_.str.365
LFQH_Lloh2275:
nop
mov	x0, x21
bl Lpatch + (0xa5d4 - PATCH_BASE)
bl	LFQH_DefaultEnabled
cbz	w0, LFQH_LBB148_5
LFQH_LBB148_3:
mov	w0, #0
LFQH_LBB148_4:
ldp	x29, x30, [sp, #48]
ldp	x20, x19, [sp, #32]
ldp	x22, x21, [sp, #16]
ldp	d9, d8, [sp], #64
ret
LFQH_LBB148_5:
LFQH_Lloh2276:
adr x0, LFQH_l_.str.349
LFQH_Lloh2277:
nop
bl Lpatch + (0xa5a4 - PATCH_BASE)
mov	x1, x0
mov	x0, x19
mov	x2, x20
bl Lpatch + (0xa5d4 - PATCH_BASE)
mov.16b	v8, v0
mov.16b	v9, v1
LFQH_Lloh2278:
adr x0, LFQH_l_.str.24
LFQH_Lloh2279:
nop
bl Lpatch + (0xa5a4 - PATCH_BASE)
mov	x1, x0
mov	x0, x20
bl Lpatch + (0xa5d4 - PATCH_BASE)
fcmp	d8, d0
cset	w8, ge
fadd	d0, d0, d2
fcmp	d9, d1
csel	w8, wzr, w8, lt
fcmp	d8, d0
csel	w8, wzr, w8, pl
fadd	d0, d1, d3
fcmp	d9, d0
csel	w0, wzr, w8, pl
b	LFQH_LBB148_4
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
cbz	w0, LFQH_LBB149_2
mov	x0, x20
bl Lpatch + (0xa5a4 - PATCH_BASE)
mov	x1, x0
mov	x0, x19
ldp	x29, x30, [sp, #16]
ldp	x20, x19, [sp], #32
b Lpatch + (0xa5d4 - PATCH_BASE)
LFQH_LBB149_2:
ldp	x29, x30, [sp, #16]
ldp	x20, x19, [sp], #32
ret
.cfi_endproc
.p2align	2
LFQH_SetDefault:
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
LFQH_Lloh2280:
adr x0, LFQH_l_.str.274
LFQH_Lloh2281:
nop
bl Lpatch + (0xa5b0 - PATCH_BASE)
mov	x21, x0
LFQH_Lloh2282:
adr x0, LFQH_l_.str.275
LFQH_Lloh2283:
nop
bl Lpatch + (0xa5a4 - PATCH_BASE)
mov	x1, x0
mov	x0, x21
bl Lpatch + (0xa5d4 - PATCH_BASE)
mov	x21, x0
LFQH_Lloh2284:
adr x0, LFQH_l_.str.321
LFQH_Lloh2285:
nop
bl Lpatch + (0xa5a4 - PATCH_BASE)
mov	x1, x0
mov	x0, x21
mov	x2, x19
mov	x3, x20
ldp	x29, x30, [sp, #32]
ldp	x20, x19, [sp, #16]
ldp	x22, x21, [sp], #48
b Lpatch + (0xa5d4 - PATCH_BASE)
.cfi_endproc
.p2align	2
LFQH_TabOption:
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
LFQH_Lloh2286:
adr x0, LFQH_l_.str.330
LFQH_Lloh2287:
nop
bl Lpatch + (0xa5a4 - PATCH_BASE)
mov	x1, x0
mov	x0, x20
bl Lpatch + (0xa5d4 - PATCH_BASE)
mov	x20, x0
cmp	w0, #3
b.gt	LFQH_LBB151_4
cbz	w20, LFQH_LBB151_8
cmp	w20, #3
b.ne	LFQH_LBB151_6
mov	w0, #3
b	LFQH_LBB151_11
LFQH_LBB151_4:
cmp	w20, #4
b.eq	LFQH_LBB151_9
cmp	w20, #7
b.eq	LFQH_LBB151_7
LFQH_LBB151_6:
LFQH_Lloh2288:
adr x0, LFQH_l_.str.331
LFQH_Lloh2289:
nop
bl Lpatch + (0xa5a4 - PATCH_BASE)
mov	x1, x0
mov	x0, x19
mov	x2, x20
bl Lpatch + (0xa5d4 - PATCH_BASE)
mov	x19, x0
LFQH_Lloh2290:
adr x1, LFQH_l_.str.332
LFQH_Lloh2291:
nop
bl	LFQH_Equal
tbz	w0, #0, LFQH_LBB151_10
LFQH_LBB151_7:
mov	w0, #2
b	LFQH_LBB151_11
LFQH_LBB151_8:
mov	w0, #1
b	LFQH_LBB151_11
LFQH_LBB151_9:
mov	w0, #4
b	LFQH_LBB151_11
LFQH_LBB151_10:
LFQH_Lloh2292:
adr x1, LFQH_l_.str.333
LFQH_Lloh2293:
nop
mov	x0, x19
bl	LFQH_Equal
cmp	w0, #0
mov	w8, #5
csel	x0, xzr, x8, eq
LFQH_LBB151_11:
ldp	x29, x30, [sp, #16]
ldp	x20, x19, [sp], #32
ret
.cfi_endproc
.p2align	2
LFQH_InstallTabRecovery:
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
LFQH_Lloh2294:
adr x1, LFQH_l_.str.334
LFQH_Lloh2295:
nop
bl	LFQH_Get
mov	x22, x0
LFQH_Lloh2296:
adr x1, LFQH_l_.str.20
LFQH_Lloh2297:
nop
bl	LFQH_Get
mov	x20, x0
LFQH_Lloh2298:
adr x1, LFQH_TabRecoveryKey
LFQH_Lloh2299:
nop
mov	x0, x19
bl Lpatch + (0xa628 - PATCH_BASE)
mov	x21, x0
LFQH_Lloh2300:
adr x1, LFQH_l_.str.335
LFQH_Lloh2301:
nop
bl	LFQH_Get
mov	x23, x0
cbz	x20, LFQH_LBB152_3
LFQH_Lloh2302:
adr x0, LFQH_l_.str.182
LFQH_Lloh2303:
nop
bl Lpatch + (0xa5b0 - PATCH_BASE)
mov	x24, x0
LFQH_Lloh2304:
adr x0, LFQH_l_.str.183
LFQH_Lloh2305:
nop
bl Lpatch + (0xa5a4 - PATCH_BASE)
mov	x1, x0
LFQH_Lloh2306:
adr x2, LFQH_l_.str.365
LFQH_Lloh2307:
nop
mov	x0, x24
bl Lpatch + (0xa5d4 - PATCH_BASE)
bl	LFQH_DefaultEnabled
cmp	w0, #0
cset	w24, eq
cbnz	x21, LFQH_LBB152_4
LFQH_LBB152_2:
cbnz	w24, LFQH_LBB152_6
b	LFQH_LBB152_10
LFQH_LBB152_3:
mov	w24, #0
cbz	x21, LFQH_LBB152_2
LFQH_LBB152_4:
cmp	x23, x20
cset	w8, eq
and	w8, w8, w24
tbnz	w8, #0, LFQH_LBB152_10
LFQH_Lloh2308:
adr x0, LFQH_l_.str.336
LFQH_Lloh2309:
nop
bl Lpatch + (0xa5a4 - PATCH_BASE)
mov	x1, x0
mov	x0, x23
mov	x2, x21
bl Lpatch + (0xa5d4 - PATCH_BASE)
LFQH_Lloh2310:
adr x1, LFQH_TabRecoveryKey
LFQH_Lloh2311:
nop
mov	x0, x19
mov	x2, #0
mov	w3, #1
bl Lpatch + (0xa634 - PATCH_BASE)
cbz	w24, LFQH_LBB152_10
LFQH_LBB152_6:
bl	LFQH_ToggleObserver
mov	x21, x0
LFQH_Lloh2312:
adr x0, LFQH_l_.str.69
LFQH_Lloh2313:
nop
bl Lpatch + (0xa5a4 - PATCH_BASE)
mov	x1, x0
mov	x0, x21
bl Lpatch + (0xa5d4 - PATCH_BASE)
mov	x21, x0
LFQH_Lloh2314:
adr x0, LFQH_l_.str.70
LFQH_Lloh2315:
nop
bl Lpatch + (0xa5a4 - PATCH_BASE)
mov	x1, x0
mov	x0, x21
bl Lpatch + (0xa5d4 - PATCH_BASE)
cbz	x0, LFQH_LBB152_10
mov	x21, x0
LFQH_Lloh2316:
adr x0, LFQH_l_.str.337
LFQH_Lloh2317:
nop
bl Lpatch + (0xa5b0 - PATCH_BASE)
mov	x23, x0
LFQH_Lloh2318:
adr x0, LFQH_l_.str.338
LFQH_Lloh2319:
nop
bl Lpatch + (0xa5a4 - PATCH_BASE)
mov	x1, x0
mov	x0, x23
bl Lpatch + (0xa5d4 - PATCH_BASE)
mov	x23, x0
LFQH_Lloh2320:
adr x0, LFQH_l_.str.221
LFQH_Lloh2321:
nop
bl Lpatch + (0xa5a4 - PATCH_BASE)
mov	x1, x0
mov	x0, x23
mov	x2, x22
bl Lpatch + (0xa5d4 - PATCH_BASE)
LFQH_Lloh2322:
adr x1, LFQH_RecoveryBarKey
LFQH_Lloh2323:
nop
mov	x0, x21
mov	x2, x23
mov	w3, #1
bl Lpatch + (0xa634 - PATCH_BASE)
LFQH_Lloh2324:
adr x0, LFQH_l_.str.339
LFQH_Lloh2325:
nop
bl Lpatch + (0xa5b0 - PATCH_BASE)
mov	x22, x0
LFQH_Lloh2326:
adr x0, LFQH_l_.str.69
LFQH_Lloh2327:
nop
bl Lpatch + (0xa5a4 - PATCH_BASE)
mov	x1, x0
mov	x0, x22
bl Lpatch + (0xa5d4 - PATCH_BASE)
mov	x22, x0
LFQH_Lloh2328:
adr x0, LFQH_l_.str.340
LFQH_Lloh2329:
nop
bl Lpatch + (0xa5a4 - PATCH_BASE)
mov	x23, x0
LFQH_Lloh2330:
adr x0, LFQH_l_.str.310
LFQH_Lloh2331:
nop
bl Lpatch + (0xa5a4 - PATCH_BASE)
mov	x3, x0
mov	x0, x22
mov	x1, x23
mov	x2, x21
bl Lpatch + (0xa5d4 - PATCH_BASE)
cbz	x0, LFQH_LBB152_9
mov	x22, x0
LFQH_Lloh2332:
adr x0, LFQH_l_.str.341
LFQH_Lloh2333:
nop
bl Lpatch + (0xa5a4 - PATCH_BASE)
mov	x1, x0
fmov	d0, #0.75000000
mov	x0, x22
bl Lpatch + (0xa5d4 - PATCH_BASE)
LFQH_Lloh2334:
adr x0, LFQH_l_.str.342
LFQH_Lloh2335:
nop
bl Lpatch + (0xa5a4 - PATCH_BASE)
mov	x1, x0
mov	x0, x22
mov	x2, x21
bl Lpatch + (0xa5d4 - PATCH_BASE)
LFQH_Lloh2336:
adr x1, LFQH_ToggleObserverKey
LFQH_Lloh2337:
nop
mov	x0, x22
mov	x2, x21
mov	w3, #1
bl Lpatch + (0xa634 - PATCH_BASE)
LFQH_Lloh2338:
adr x1, LFQH_TabRecoveryKey
LFQH_Lloh2339:
nop
mov	x0, x19
mov	x2, x22
mov	w3, #1
bl Lpatch + (0xa634 - PATCH_BASE)
LFQH_Lloh2340:
adr x0, LFQH_l_.str.343
LFQH_Lloh2341:
nop
bl Lpatch + (0xa5a4 - PATCH_BASE)
mov	x1, x0
mov	x0, x20
mov	x2, x22
bl Lpatch + (0xa5d4 - PATCH_BASE)
LFQH_Lloh2342:
adr x0, LFQH_l_.str.55
LFQH_Lloh2343:
nop
bl Lpatch + (0xa5a4 - PATCH_BASE)
mov	x1, x0
mov	x0, x22
bl Lpatch + (0xa5d4 - PATCH_BASE)
LFQH_LBB152_9:
LFQH_Lloh2344:
adr x0, LFQH_l_.str.55
LFQH_Lloh2345:
nop
bl Lpatch + (0xa5a4 - PATCH_BASE)
mov	x1, x0
mov	x0, x21
ldp	x29, x30, [sp, #48]
ldp	x20, x19, [sp, #32]
ldp	x22, x21, [sp, #16]
ldp	x24, x23, [sp], #64
b Lpatch + (0xa5d4 - PATCH_BASE)
LFQH_LBB152_10:
ldp	x29, x30, [sp, #48]
ldp	x20, x19, [sp, #32]
ldp	x22, x21, [sp, #16]
ldp	x24, x23, [sp], #64
ret
.cfi_endproc
.p2align	2
LFQH_ShelfDurationHeadersKey:
.cfi_startproc
ret
.cfi_endproc
.p2align	2
LFQH_ShelfDurationRequestedKey:
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
LFQH_MineControllersKey:
.cfi_startproc
ret
.cfi_endproc
.p2align	2
LFQH_FindTabOwner:
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
mov	x20, x1
mov	x19, x0
LFQH_Lloh2346:
adr x1, LFQH_l_.str.156
LFQH_Lloh2347:
nop
bl	LFQH_Kind
tbz	w0, #0, LFQH_LBB157_3
mov	x0, x19
LFQH_LBB157_2:
ldp	x29, x30, [sp, #48]
ldp	x20, x19, [sp, #32]
ldp	x22, x21, [sp, #16]
ldp	x24, x23, [sp], #64
ret
LFQH_LBB157_3:
mov	x0, #0
cbz	x19, LFQH_LBB157_2
cbz	w20, LFQH_LBB157_2
LFQH_Lloh2348:
adr x1, LFQH_l_.str.329
LFQH_Lloh2349:
nop
mov	x0, x19
bl	LFQH_Get
mov	x19, x0
LFQH_Lloh2350:
adr x0, LFQH_l_.str.34
LFQH_Lloh2351:
nop
bl Lpatch + (0xa5a4 - PATCH_BASE)
mov	x1, x0
mov	x0, x19
bl Lpatch + (0xa5d4 - PATCH_BASE)
cbz	x0, LFQH_LBB157_2
mov	x21, x0
mov	x22, #0
sub	w20, w20, #1
LFQH_Lloh2352:
adr x23, LFQH_l_.str.264
LFQH_Lloh2353:
nop
LFQH_LBB157_7:
mov	x0, x23
bl Lpatch + (0xa5a4 - PATCH_BASE)
mov	x1, x0
mov	x0, x19
mov	x2, x22
bl Lpatch + (0xa5d4 - PATCH_BASE)
mov	x1, x20
bl	LFQH_FindTabOwner
cbnz	x0, LFQH_LBB157_2
add	x22, x22, #1
cmp	x21, x22
b.ne	LFQH_LBB157_7
mov	x0, #0
b	LFQH_LBB157_2
.cfi_endproc
.p2align	2
LFQH_TabRecoveryKey:
.cfi_startproc
ret
.cfi_endproc
.p2align	2
LFQH_RecoveryBarKey:
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
cbz	x0, LFQH_LBB160_6
mov	x22, x2
mov	x20, x1
mov	x19, x0
LFQH_Lloh2354:
adr x1, LFQH_PageTintKey
LFQH_Lloh2355:
nop
bl Lpatch + (0xa628 - PATCH_BASE)
cbz	x0, LFQH_LBB160_3
LFQH_Lloh2356:
adr x1, LFQH_l_.str.40
LFQH_Lloh2357:
nop
bl	LFQH_BoolProp
cmp	w0, w20
b.eq	LFQH_LBB160_6
LFQH_LBB160_3:
LFQH_Lloh2358:
adr x1, LFQH_l_.str.51
LFQH_Lloh2359:
nop
mov	x0, x19
bl	LFQH_Get
mov	x21, x0
LFQH_Lloh2360:
adr x0, LFQH_l_.str.52
LFQH_Lloh2361:
nop
bl Lpatch + (0xa5a4 - PATCH_BASE)
mov	x1, x0
mov	x0, x21
bl Lpatch + (0xa5d4 - PATCH_BASE)
cbz	x0, LFQH_LBB160_6
mov	x21, x0
cbz	w20, LFQH_LBB160_7
LFQH_Lloh2362:
adr x0, LFQH_l_.str.46
LFQH_Lloh2363:
nop
bl Lpatch + (0xa5b0 - PATCH_BASE)
mov	x23, x0
LFQH_Lloh2364:
adr x8, LFQH_l_.str.373
LFQH_Lloh2365:
nop
LFQH_Lloh2366:
adr x9, LFQH_l_.str.47
LFQH_Lloh2367:
nop
cmp	w22, #0
csel	x0, x9, x8, eq
bl Lpatch + (0xa5a4 - PATCH_BASE)
mov	x1, x0
mov	x0, x23
bl Lpatch + (0xa5d4 - PATCH_BASE)
mov	x22, x0
b	LFQH_LBB160_8
LFQH_LBB160_6:
ldp	x29, x30, [sp, #48]
ldp	x20, x19, [sp, #32]
ldp	x22, x21, [sp, #16]
ldp	x24, x23, [sp], #64
ret
LFQH_LBB160_7:
mov	x22, #0
LFQH_LBB160_8:
LFQH_Lloh2368:
adr x0, LFQH_l_.str.50
LFQH_Lloh2369:
nop
bl Lpatch + (0xa5a4 - PATCH_BASE)
mov	x1, x0
fmov	d0, #0.12500000
mov	x0, x22
bl Lpatch + (0xa5d4 - PATCH_BASE)
mov	x22, x0
LFQH_Lloh2370:
adr x0, LFQH_l_.str.53
LFQH_Lloh2371:
nop
bl Lpatch + (0xa5a4 - PATCH_BASE)
mov	x1, x0
mov	x0, x21
mov	x2, x22
bl Lpatch + (0xa5d4 - PATCH_BASE)
LFQH_Lloh2372:
adr x0, LFQH_l_.str.54
LFQH_Lloh2373:
nop
bl Lpatch + (0xa5a4 - PATCH_BASE)
mov	x1, x0
mov	x0, x19
mov	x2, x21
bl Lpatch + (0xa5d4 - PATCH_BASE)
LFQH_Lloh2374:
adr x0, LFQH_l_.str.55
LFQH_Lloh2375:
nop
bl Lpatch + (0xa5a4 - PATCH_BASE)
mov	x1, x0
mov	x0, x21
bl Lpatch + (0xa5d4 - PATCH_BASE)
LFQH_Lloh2376:
adr x0, LFQH_l_.str.205
LFQH_Lloh2377:
nop
bl Lpatch + (0xa5b0 - PATCH_BASE)
mov	x21, x0
LFQH_Lloh2378:
adr x0, LFQH_l_.str.271
LFQH_Lloh2379:
nop
bl Lpatch + (0xa5a4 - PATCH_BASE)
mov	x1, x0
mov	x0, x21
mov	x2, x20
bl Lpatch + (0xa5d4 - PATCH_BASE)
mov	x2, x0
LFQH_Lloh2380:
adr x1, LFQH_PageTintKey
LFQH_Lloh2381:
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
LFQH_ShelfTitleFont:
.cfi_startproc
stp	d9, d8, [sp, #-64]!
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
.cfi_offset b8, -56
.cfi_offset b9, -64
cbz	x0, LFQH_LBB161_11
mov	x21, x1
mov	x19, x0
LFQH_Lloh2382:
adr x0, LFQH_l_.str.374
LFQH_Lloh2383:
nop
bl Lpatch + (0xa5a4 - PATCH_BASE)
mov	x1, x0
mov	x0, x19
bl Lpatch + (0xa5d4 - PATCH_BASE)
mov	x20, x0
LFQH_Lloh2384:
adr x1, LFQH_ShelfTitleGlassFontKey
LFQH_Lloh2385:
nop
mov	x0, x19
bl Lpatch + (0xa628 - PATCH_BASE)
cbz	x0, LFQH_LBB161_5
mov	x22, x0
cmp	x20, x0
b.eq	LFQH_LBB161_10
LFQH_Lloh2386:
adr x0, LFQH_l_.str.48
LFQH_Lloh2387:
nop
bl Lpatch + (0xa5a4 - PATCH_BASE)
mov	x1, x0
mov	x0, x20
mov	x2, x22
bl Lpatch + (0xa5d4 - PATCH_BASE)
cmp	w0, #0
cset	w8, ne
cbnz	w21, LFQH_LBB161_7
cbnz	w0, LFQH_LBB161_12
b	LFQH_LBB161_13
LFQH_LBB161_5:
cbz	w21, LFQH_LBB161_11
mov	w8, #0
LFQH_LBB161_7:
cmp	x20, #0
cset	w9, eq
orr	w8, w9, w8
tbnz	w8, #0, LFQH_LBB161_11
LFQH_Lloh2388:
adr x0, LFQH_l_.str.375
LFQH_Lloh2389:
nop
bl Lpatch + (0xa5a4 - PATCH_BASE)
mov	x1, x0
mov	x0, x20
bl Lpatch + (0xa5d4 - PATCH_BASE)
mov.16b	v8, v0
LFQH_Lloh2390:
adr x0, LFQH_l_.str.376
LFQH_Lloh2391:
nop
bl Lpatch + (0xa5a4 - PATCH_BASE)
mov	x1, x0
fmov	d0, #0.87500000
fmul	d0, d8, d0
mov	x0, x20
bl Lpatch + (0xa5d4 - PATCH_BASE)
cbz	x0, LFQH_LBB161_11
mov	x21, x0
LFQH_Lloh2392:
adr x1, LFQH_ShelfTitleHostFontKey
LFQH_Lloh2393:
nop
mov	x0, x19
mov	x2, x20
mov	w3, #1
bl Lpatch + (0xa634 - PATCH_BASE)
LFQH_Lloh2394:
adr x1, LFQH_ShelfTitleGlassFontKey
LFQH_Lloh2395:
nop
mov	x0, x19
mov	x2, x21
mov	w3, #1
bl Lpatch + (0xa634 - PATCH_BASE)
LFQH_Lloh2396:
adr x0, LFQH_l_.str.77
LFQH_Lloh2397:
nop
bl Lpatch + (0xa5a4 - PATCH_BASE)
mov	x1, x0
mov	x0, x19
mov	x2, x21
ldp	x29, x30, [sp, #48]
ldp	x20, x19, [sp, #32]
ldp	x22, x21, [sp, #16]
ldp	d9, d8, [sp], #64
b Lpatch + (0xa5d4 - PATCH_BASE)
LFQH_LBB161_10:
cbz	w21, LFQH_LBB161_12
LFQH_LBB161_11:
ldp	x29, x30, [sp, #48]
ldp	x20, x19, [sp, #32]
ldp	x22, x21, [sp, #16]
ldp	d9, d8, [sp], #64
ret
LFQH_LBB161_12:
LFQH_Lloh2398:
adr x0, LFQH_l_.str.77
LFQH_Lloh2399:
nop
bl Lpatch + (0xa5a4 - PATCH_BASE)
mov	x20, x0
LFQH_Lloh2400:
adr x1, LFQH_ShelfTitleHostFontKey
LFQH_Lloh2401:
nop
mov	x0, x19
bl Lpatch + (0xa628 - PATCH_BASE)
mov	x2, x0
mov	x0, x19
mov	x1, x20
bl Lpatch + (0xa5d4 - PATCH_BASE)
LFQH_LBB161_13:
LFQH_Lloh2402:
adr x1, LFQH_ShelfTitleHostFontKey
LFQH_Lloh2403:
nop
mov	x0, x19
mov	x2, #0
mov	w3, #1
bl Lpatch + (0xa634 - PATCH_BASE)
LFQH_Lloh2404:
adr x1, LFQH_ShelfTitleGlassFontKey
LFQH_Lloh2405:
nop
mov	x0, x19
mov	x2, #0
mov	w3, #1
ldp	x29, x30, [sp, #48]
ldp	x20, x19, [sp, #32]
ldp	x22, x21, [sp, #16]
ldp	d9, d8, [sp], #64
b Lpatch + (0xa634 - PATCH_BASE)
.cfi_endproc
.p2align	2
LFQH_PageTintKey:
.cfi_startproc
ret
.cfi_endproc
.p2align	2
LFQH_ShelfTitleGlassFontKey:
.cfi_startproc
ret
.cfi_endproc
.p2align	2
LFQH_ShelfTitleHostFontKey:
.cfi_startproc
ret
.cfi_endproc
.p2align	2
LFQH_ReaderMenuBackdrop:
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
bl	LFQH_ReaderBottomBackgroundEnabled
mov	x20, x0
LFQH_Lloh2406:
adr x1, LFQH_l_.str.377
LFQH_Lloh2407:
nop
mov	x0, x19
bl	LFQH_Get
mov	x1, x20
bl	LFQH_ReaderBackdrop
LFQH_Lloh2408:
adr x1, LFQH_l_.str.378
LFQH_Lloh2409:
nop
mov	x0, x19
bl	LFQH_Get
mov	x1, x20
ldp	x29, x30, [sp, #16]
ldp	x20, x19, [sp], #32
b	LFQH_ReaderBackdrop
.cfi_endproc
.p2align	2
LFQH_ReaderBottomBackgroundEnabled:
.cfi_startproc
stp	x20, x19, [sp, #-32]!
stp	x29, x30, [sp, #16]
add	x29, sp, #16
.cfi_def_cfa w29, 16
.cfi_offset w30, -8
.cfi_offset w29, -16
.cfi_offset w19, -24
.cfi_offset w20, -32
LFQH_Lloh2410:
adr x0, LFQH_l_.str.182
LFQH_Lloh2411:
nop
bl Lpatch + (0xa5b0 - PATCH_BASE)
mov	x19, x0
LFQH_Lloh2412:
adr x0, LFQH_l_.str.183
LFQH_Lloh2413:
nop
bl Lpatch + (0xa5a4 - PATCH_BASE)
mov	x1, x0
LFQH_Lloh2414:
adr x2, LFQH_l_.str.369
LFQH_Lloh2415:
nop
mov	x0, x19
bl Lpatch + (0xa5d4 - PATCH_BASE)
ldp	x29, x30, [sp, #16]
ldp	x20, x19, [sp], #32
b	LFQH_DefaultEnabled
.cfi_endproc
.p2align	2
LFQH_ReaderBackdrop:
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
cbz	x0, LFQH_LBB167_13
mov	x19, x1
mov	x20, x0
LFQH_Lloh2416:
adr x1, LFQH_ReaderBackdropAppliedKey
LFQH_Lloh2417:
nop
bl Lpatch + (0xa628 - PATCH_BASE)
mov	x21, x0
cbz	w19, LFQH_LBB167_3
cbz	x21, LFQH_LBB167_13
LFQH_LBB167_3:
LFQH_Lloh2418:
adr x0, LFQH_l_.str.185
LFQH_Lloh2419:
nop
bl Lpatch + (0xa5a4 - PATCH_BASE)
mov	x22, x0
LFQH_Lloh2420:
adr x0, LFQH_l_.str.94
LFQH_Lloh2421:
nop
bl Lpatch + (0xa5b0 - PATCH_BASE)
mov	x2, x0
mov	x0, x20
mov	x1, x22
bl Lpatch + (0xa5d4 - PATCH_BASE)
mov	x22, x0
cbnz	w0, LFQH_LBB167_5
LFQH_Lloh2422:
adr x0, LFQH_l_.str.185
LFQH_Lloh2423:
nop
bl Lpatch + (0xa5a4 - PATCH_BASE)
mov	x23, x0
LFQH_Lloh2424:
adr x0, LFQH_l_.str.57
LFQH_Lloh2425:
nop
bl Lpatch + (0xa5b0 - PATCH_BASE)
mov	x2, x0
mov	x0, x20
mov	x1, x23
bl Lpatch + (0xa5d4 - PATCH_BASE)
cbz	w0, LFQH_LBB167_13
LFQH_LBB167_5:
LFQH_Lloh2426:
adr x0, LFQH_l_.str.20
LFQH_Lloh2427:
nop
bl Lpatch + (0xa5a4 - PATCH_BASE)
mov	x1, x0
mov	x0, x20
bl Lpatch + (0xa5d4 - PATCH_BASE)
mov	x23, x0
mov	x0, x20
mov	x1, x19
bl	LFQH_ReaderBackdropFill
LFQH_Lloh2428:
adr x1, LFQH_l_.str.379
LFQH_Lloh2429:
nop
mov	x0, x23
bl	LFQH_Kind
cbz	w0, LFQH_LBB167_8
LFQH_Lloh2430:
adr x1, LFQH_l_.str.193
LFQH_Lloh2431:
nop
mov	x0, x23
bl	LFQH_Get
cmp	x0, x20
b.ne	LFQH_LBB167_8
mov	x0, x23
mov	x1, x19
bl	LFQH_ReaderBackdropFill
LFQH_LBB167_8:
cmp	x21, #0
cset	w8, ne
cmp	w19, w8
b.ne	LFQH_LBB167_10
cmp	w19, #0
csel	x2, x20, xzr, eq
LFQH_Lloh2432:
adr x1, LFQH_ReaderBackdropAppliedKey
LFQH_Lloh2433:
nop
mov	x0, x20
mov	x3, #0
bl Lpatch + (0xa634 - PATCH_BASE)
LFQH_LBB167_10:
LFQH_Lloh2434:
adr x8, LFQH_l_.str.380
LFQH_Lloh2435:
nop
LFQH_Lloh2436:
adr x9, LFQH_l_.str.381
LFQH_Lloh2437:
nop
cmp	w22, #0
csel	x1, x9, x8, eq
mov	x0, x20
bl	LFQH_Get
mov	x21, x0
LFQH_Lloh2438:
adr x0, LFQH_l_.str.20
LFQH_Lloh2439:
nop
bl Lpatch + (0xa5a4 - PATCH_BASE)
mov	x1, x0
mov	x0, x21
bl Lpatch + (0xa5d4 - PATCH_BASE)
cmp	x0, x20
b.ne	LFQH_LBB167_13
LFQH_Lloh2440:
adr x1, LFQH_ReaderBackdropAlphaKey
LFQH_Lloh2441:
nop
mov	x0, x21
bl Lpatch + (0xa628 - PATCH_BASE)
mov	x20, x0
cbz	w19, LFQH_LBB167_14
cbnz	x20, LFQH_LBB167_14
LFQH_LBB167_13:
ldp	x29, x30, [sp, #48]
ldp	x20, x19, [sp, #32]
ldp	x22, x21, [sp, #16]
ldp	x24, x23, [sp], #64
ret
LFQH_LBB167_14:
LFQH_Lloh2442:
adr x0, LFQH_l_.str.382
LFQH_Lloh2443:
nop
bl Lpatch + (0xa5a4 - PATCH_BASE)
mov	x1, x0
mov	x0, x21
bl Lpatch + (0xa5d4 - PATCH_BASE)
cbz	w19, LFQH_LBB167_18
fcmp	d0, #0.0
b.ne	LFQH_LBB167_17
LFQH_Lloh2444:
adr x0, LFQH_l_.str.383
LFQH_Lloh2445:
nop
bl Lpatch + (0xa5a4 - PATCH_BASE)
mov	x19, x0
LFQH_Lloh2446:
adr x0, LFQH_l_.str.204
LFQH_Lloh2447:
nop
bl Lpatch + (0xa5a4 - PATCH_BASE)
mov	x1, x0
mov	x0, x20
bl Lpatch + (0xa5d4 - PATCH_BASE)
mov	x0, x21
mov	x1, x19
bl Lpatch + (0xa5d4 - PATCH_BASE)
LFQH_LBB167_17:
LFQH_Lloh2448:
adr x1, LFQH_ReaderBackdropAlphaKey
LFQH_Lloh2449:
nop
mov	x0, x21
mov	x2, #0
mov	w3, #1
ldp	x29, x30, [sp, #48]
ldp	x20, x19, [sp, #32]
ldp	x22, x21, [sp, #16]
ldp	x24, x23, [sp], #64
b Lpatch + (0xa634 - PATCH_BASE)
LFQH_LBB167_18:
fcmp	d0, #0.0
b.le	LFQH_LBB167_13
bl	LFQH_Number
mov	x2, x0
LFQH_Lloh2450:
adr x1, LFQH_ReaderBackdropAlphaKey
LFQH_Lloh2451:
nop
mov	x0, x21
mov	w3, #1
bl Lpatch + (0xa634 - PATCH_BASE)
LFQH_Lloh2452:
adr x0, LFQH_l_.str.383
LFQH_Lloh2453:
nop
bl Lpatch + (0xa5a4 - PATCH_BASE)
mov	x1, x0
fmov	d0, xzr
mov	x0, x21
ldp	x29, x30, [sp, #48]
ldp	x20, x19, [sp, #32]
ldp	x22, x21, [sp, #16]
ldp	x24, x23, [sp], #64
b Lpatch + (0xa5d4 - PATCH_BASE)
.cfi_endproc
.p2align	2
LFQH_ReaderBackdropAppliedKey:
.cfi_startproc
ret
.cfi_endproc
.p2align	2
LFQH_ReaderBackdropFill:
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
mov	x21, x1
mov	x19, x0
LFQH_Lloh2454:
adr x1, LFQH_ReaderBackdropColorKey
LFQH_Lloh2455:
nop
bl Lpatch + (0xa628 - PATCH_BASE)
mov	x20, x0
cbz	w21, LFQH_LBB169_3
cbnz	x20, LFQH_LBB169_3
LFQH_LBB169_2:
ldp	x29, x30, [sp, #32]
ldp	x20, x19, [sp, #16]
ldp	x22, x21, [sp], #48
ret
LFQH_LBB169_3:
LFQH_Lloh2456:
adr x0, LFQH_l_.str.186
LFQH_Lloh2457:
nop
bl Lpatch + (0xa5a4 - PATCH_BASE)
mov	x1, x0
mov	x0, x19
bl Lpatch + (0xa5d4 - PATCH_BASE)
mov	x2, x0
cbz	w21, LFQH_LBB169_7
cbnz	x2, LFQH_LBB169_6
LFQH_Lloh2458:
adr x0, LFQH_l_.str.72
LFQH_Lloh2459:
nop
bl Lpatch + (0xa5a4 - PATCH_BASE)
mov	x1, x0
mov	x0, x19
mov	x2, x20
bl Lpatch + (0xa5d4 - PATCH_BASE)
LFQH_LBB169_6:
LFQH_Lloh2460:
adr x1, LFQH_ReaderBackdropColorKey
LFQH_Lloh2461:
nop
mov	x0, x19
mov	x2, #0
mov	w3, #1
ldp	x29, x30, [sp, #32]
ldp	x20, x19, [sp, #16]
ldp	x22, x21, [sp], #48
b Lpatch + (0xa634 - PATCH_BASE)
LFQH_LBB169_7:
cbz	x2, LFQH_LBB169_2
LFQH_Lloh2462:
adr x1, LFQH_ReaderBackdropColorKey
LFQH_Lloh2463:
nop
mov	x0, x19
mov	w3, #1
bl Lpatch + (0xa634 - PATCH_BASE)
LFQH_Lloh2464:
adr x0, LFQH_l_.str.72
LFQH_Lloh2465:
nop
bl Lpatch + (0xa5a4 - PATCH_BASE)
mov	x1, x0
mov	x0, x19
mov	x2, #0
ldp	x29, x30, [sp, #32]
ldp	x20, x19, [sp, #16]
ldp	x22, x21, [sp], #48
b Lpatch + (0xa5d4 - PATCH_BASE)
.cfi_endproc
.p2align	2
LFQH_ReaderBackdropAlphaKey:
.cfi_startproc
ret
.cfi_endproc
.p2align	2
LFQH_ReaderBackdropColorKey:
.cfi_startproc
ret
.cfi_endproc
.p2align	2
LFQH_ReaderBottomGlass:
.cfi_startproc
stp	d15, d14, [sp, #-96]!
stp	d13, d12, [sp, #16]
stp	d11, d10, [sp, #32]
stp	d9, d8, [sp, #48]
stp	x20, x19, [sp, #64]
stp	x29, x30, [sp, #80]
add	x29, sp, #80
.cfi_def_cfa w29, 16
.cfi_offset w30, -8
.cfi_offset w29, -16
.cfi_offset w19, -24
.cfi_offset w20, -32
.cfi_offset b8, -40
.cfi_offset b9, -48
.cfi_offset b10, -56
.cfi_offset b11, -64
.cfi_offset b12, -72
.cfi_offset b13, -80
.cfi_offset b14, -88
.cfi_offset b15, -96
mov	x19, x0
LFQH_Lloh2466:
adr x0, LFQH_l_.str.24
LFQH_Lloh2467:
nop
bl Lpatch + (0xa5a4 - PATCH_BASE)
mov	x1, x0
mov	x0, x19
bl Lpatch + (0xa5d4 - PATCH_BASE)
mov.16b	v8, v0
mov.16b	v9, v1
mov.16b	v10, v2
fmov	x8, d10
fmov	x9, d9
fmov	x10, d8
ubfx	x10, x10, #52, #11
ubfx	x9, x9, #52, #11
ubfx	x8, x8, #52, #11
cmp	x8, #2046
mov	w8, #2046
ccmp	x9, x8, #2, ls
ccmp	x10, x8, #2, ls
b.ls	LFQH_LBB172_3
LFQH_LBB172_1:
mov	x0, x19
bl	LFQH_PageRestore
LFQH_LBB172_2:
mov	x0, x19
ldp	x29, x30, [sp, #80]
ldp	x20, x19, [sp, #64]
ldp	d9, d8, [sp, #48]
ldp	d11, d10, [sp, #32]
ldp	d13, d12, [sp, #16]
ldp	d15, d14, [sp], #96
b	LFQH_RestoreHit
LFQH_LBB172_3:
mov.16b	v11, v3
fmov	x8, d11
ubfx	x8, x8, #52, #11
cmp	x8, #2046
b.hi	LFQH_LBB172_1
fcmp	d10, #0.0
b.le	LFQH_LBB172_1
fcmp	d11, #0.0
b.le	LFQH_LBB172_1
mov	x8, #-4589168020290535424
fmov	d0, x8
fadd	d0, d10, d0
fmov	d1, #0.50000000
fmul	d0, d0, d1
fadd	d12, d8, d0
mov	x8, #-4591419820104220672
fmov	d0, x8
fadd	d0, d11, d0
fmul	d0, d0, d1
fadd	d13, d9, d0
mov	x8, #4631952216750555136
fmov	d14, x8
mov	x8, #4634204016564240384
fmov	d15, x8
mov	x0, x19
mov.16b	v0, v12
mov.16b	v1, v13
mov.16b	v2, v15
mov.16b	v3, v14
mov	w1, #0
bl	LFQH_ApplySurface
LFQH_Lloh2468:
adr x1, LFQH_SurfaceKey
LFQH_Lloh2469:
nop
mov	x0, x19
bl Lpatch + (0xa628 - PATCH_BASE)
cbz	x0, LFQH_LBB172_2
mov	x20, x0
mov	x0, x19
mov.16b	v0, v12
mov.16b	v1, v13
mov.16b	v2, v15
mov.16b	v3, v14
bl	LFQH_EnsureHit
LFQH_Lloh2470:
adr x2, LFQH_l_.str.385
LFQH_Lloh2471:
nop
mov	x0, x19
mov	x1, x20
mov.16b	v0, v8
mov.16b	v1, v9
mov.16b	v2, v10
mov.16b	v3, v11
ldp	x29, x30, [sp, #80]
ldp	x20, x19, [sp, #64]
ldp	d9, d8, [sp, #48]
ldp	d11, d10, [sp, #32]
ldp	d13, d12, [sp, #16]
ldp	d15, d14, [sp], #96
b	LFQH_RecordLayout
.cfi_endproc
.p2align	2
LFQH_CatalogTapKey:
.cfi_startproc
ret
.cfi_endproc
.p2align	2
LFQH_CatalogTapped:
.cfi_startproc
stp	x20, x19, [sp, #-32]!
stp	x29, x30, [sp, #16]
add	x29, sp, #16
.cfi_def_cfa w29, 16
.cfi_offset w30, -8
.cfi_offset w29, -16
.cfi_offset w19, -24
.cfi_offset w20, -32
mov	x19, x2
LFQH_Lloh2472:
adr x0, LFQH_l_.str.344
LFQH_Lloh2473:
nop
bl Lpatch + (0xa5a4 - PATCH_BASE)
mov	x1, x0
mov	x0, x19
bl Lpatch + (0xa5d4 - PATCH_BASE)
cmp	x0, #3
b.ne	LFQH_LBB174_4
LFQH_Lloh2474:
adr x0, LFQH_l_.str.335
LFQH_Lloh2475:
nop
bl Lpatch + (0xa5a4 - PATCH_BASE)
mov	x1, x0
mov	x0, x19
bl Lpatch + (0xa5d4 - PATCH_BASE)
mov	x20, x0
LFQH_Lloh2476:
adr x1, LFQH_SurfaceKey
LFQH_Lloh2477:
nop
bl Lpatch + (0xa628 - PATCH_BASE)
cbz	x0, LFQH_LBB174_4
mov	x0, x20
bl	LFQH_ReaderBottomType
cmp	w0, #1
b.ne	LFQH_LBB174_4
LFQH_Lloh2478:
adr x0, LFQH_l_.str.390
LFQH_Lloh2479:
nop
bl Lpatch + (0xa5a4 - PATCH_BASE)
mov	x1, x0
mov	x0, x20
mov	x2, x19
ldp	x29, x30, [sp, #16]
ldp	x20, x19, [sp], #32
b Lpatch + (0xa5d4 - PATCH_BASE)
LFQH_LBB174_4:
ldp	x29, x30, [sp, #16]
ldp	x20, x19, [sp], #32
ret
.cfi_endproc
.p2align	2
LFQH_CatalogTouch:
.cfi_startproc
stp	d9, d8, [sp, #-64]!
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
.cfi_offset b8, -56
.cfi_offset b9, -64
mov	x19, x3
mov	x20, x2
LFQH_Lloh2480:
adr x0, LFQH_l_.str.335
LFQH_Lloh2481:
nop
bl Lpatch + (0xa5a4 - PATCH_BASE)
mov	x1, x0
mov	x0, x20
bl Lpatch + (0xa5d4 - PATCH_BASE)
mov	x21, x0
LFQH_Lloh2482:
adr x1, LFQH_SurfaceKey
LFQH_Lloh2483:
nop
bl Lpatch + (0xa628 - PATCH_BASE)
cbz	x0, LFQH_LBB175_4
mov	x20, x0
LFQH_Lloh2484:
adr x0, LFQH_l_.str.335
LFQH_Lloh2485:
nop
bl Lpatch + (0xa5a4 - PATCH_BASE)
mov	x1, x0
mov	x0, x19
bl Lpatch + (0xa5d4 - PATCH_BASE)
cmp	x0, x21
b.eq	LFQH_LBB175_3
mov	w0, #0
b	LFQH_LBB175_4
LFQH_LBB175_3:
LFQH_Lloh2486:
adr x0, LFQH_l_.str.349
LFQH_Lloh2487:
nop
bl Lpatch + (0xa5a4 - PATCH_BASE)
mov	x1, x0
mov	x0, x19
mov	x2, x21
bl Lpatch + (0xa5d4 - PATCH_BASE)
mov.16b	v8, v0
mov.16b	v9, v1
LFQH_Lloh2488:
adr x0, LFQH_l_.str.192
LFQH_Lloh2489:
nop
bl Lpatch + (0xa5a4 - PATCH_BASE)
mov	x1, x0
mov	x0, x20
bl Lpatch + (0xa5d4 - PATCH_BASE)
fmov	d4, #0.50000000
fmul	d3, d3, d4
fmul	d2, d2, d4
fadd	d0, d0, d2
fabd	d0, d8, d0
fsub	d2, d3, d2
fadd	d0, d2, d0
fadd	d1, d1, d3
fsub	d1, d9, d1
fcmp	d0, #0.0
fmov	d2, xzr
fcsel	d0, d2, d0, mi
fmul	d0, d0, d0
fmul	d1, d1, d1
fadd	d0, d1, d0
fmul	d1, d3, d3
fcmp	d0, d1
cset	w0, ls
LFQH_LBB175_4:
ldp	x29, x30, [sp, #48]
ldp	x20, x19, [sp, #32]
ldp	x22, x21, [sp, #16]
ldp	d9, d8, [sp], #64
ret
.cfi_endproc
.p2align	2
LFQH_ReaderProgressGlass:
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
LFQH_Lloh2490:
adr x1, LFQH_l_.str.391
LFQH_Lloh2491:
nop
bl	LFQH_Get
mov	x21, x0
LFQH_Lloh2492:
adr x1, LFQH_l_.str.392
LFQH_Lloh2493:
nop
mov	x0, x19
bl	LFQH_Get
mov	x20, x0
LFQH_Lloh2494:
adr x1, LFQH_l_.str.228
LFQH_Lloh2495:
nop
mov	x0, x21
bl	LFQH_Kind
cbz	w0, LFQH_LBB176_3
LFQH_Lloh2496:
adr x0, LFQH_l_.str.20
LFQH_Lloh2497:
nop
bl Lpatch + (0xa5a4 - PATCH_BASE)
mov	x1, x0
mov	x0, x21
bl Lpatch + (0xa5d4 - PATCH_BASE)
cmp	x0, x19
b.ne	LFQH_LBB176_3
mov	x0, x21
mov	w1, #7
bl	LFQH_Icon
LFQH_LBB176_3:
LFQH_Lloh2498:
adr x1, LFQH_l_.str.228
LFQH_Lloh2499:
nop
mov	x0, x20
bl	LFQH_Kind
cbz	w0, LFQH_LBB176_6
LFQH_Lloh2500:
adr x0, LFQH_l_.str.20
LFQH_Lloh2501:
nop
bl Lpatch + (0xa5a4 - PATCH_BASE)
mov	x1, x0
mov	x0, x20
bl Lpatch + (0xa5d4 - PATCH_BASE)
cmp	x0, x19
b.ne	LFQH_LBB176_6
mov	x0, x20
mov	w1, #7
bl	LFQH_Icon
LFQH_LBB176_6:
LFQH_Lloh2502:
adr x1, LFQH_l_.str.393
LFQH_Lloh2503:
nop
mov	x0, x19
bl	LFQH_Get
mov	x20, x0
LFQH_Lloh2504:
adr x1, LFQH_l_.str.394
LFQH_Lloh2505:
nop
bl	LFQH_Kind
cbz	w0, LFQH_LBB176_9
LFQH_Lloh2506:
adr x1, LFQH_l_.str.395
LFQH_Lloh2507:
nop
mov	x0, x20
bl	LFQH_Get
mov	x19, x0
LFQH_Lloh2508:
adr x1, LFQH_l_.str.396
LFQH_Lloh2509:
nop
bl	LFQH_Kind
cbz	w0, LFQH_LBB176_9
LFQH_Lloh2510:
adr x1, LFQH_l_.str.20
LFQH_Lloh2511:
nop
mov	x0, x19
bl	LFQH_Get
cmp	x0, x20
b.eq	LFQH_LBB176_10
LFQH_LBB176_9:
ldp	x29, x30, [sp, #32]
ldp	x20, x19, [sp, #16]
ldp	x22, x21, [sp], #48
ret
LFQH_LBB176_10:
mov	x0, x19
bl	LFQH_FQHApply
LFQH_Lloh2512:
adr x1, LFQH_SurfaceKey
LFQH_Lloh2513:
nop
mov	x0, x19
bl Lpatch + (0xa628 - PATCH_BASE)
cbz	x0, LFQH_LBB176_9
mov	x20, x0
LFQH_Lloh2514:
adr x0, LFQH_l_.str.24
LFQH_Lloh2515:
nop
bl Lpatch + (0xa5a4 - PATCH_BASE)
mov	x1, x0
mov	x0, x19
bl Lpatch + (0xa5d4 - PATCH_BASE)
LFQH_Lloh2516:
adr x2, LFQH_l_.str.397
LFQH_Lloh2517:
nop
mov	x0, x19
mov	x1, x20
ldp	x29, x30, [sp, #32]
ldp	x20, x19, [sp, #16]
ldp	x22, x21, [sp], #48
b	LFQH_RecordLayout
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
LFQH_Lloh2518:
adr x1, LFQH_l_.str.20
LFQH_Lloh2519:
nop
bl	LFQH_Get
cbz	x0, LFQH_LBB177_5
mov	x20, x0
mov	w24, #0
LFQH_Lloh2520:
adr x21, LFQH_l_.str.185
LFQH_Lloh2521:
nop
LFQH_Lloh2522:
adr x22, LFQH_l_.str.20
LFQH_Lloh2523:
nop
LFQH_LBB177_2:
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
cbnz	w0, LFQH_LBB177_6
mov	x0, x20
mov	x1, x22
bl	LFQH_Get
cbz	x0, LFQH_LBB177_6
mov	x20, x0
cmp	w24, #4
add	w24, w24, #1
b.lo	LFQH_LBB177_2
b	LFQH_LBB177_6
LFQH_LBB177_5:
mov	w23, #0
LFQH_LBB177_6:
mov	x0, x23
ldp	x29, x30, [sp, #48]
ldp	x20, x19, [sp, #32]
ldp	x22, x21, [sp, #16]
ldp	x24, x23, [sp], #64
ret
.cfi_endproc
.p2align	2
LFQH_ChapterDiscussionGlass:
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
mov	x19, x0
LFQH_Lloh2524:
adr x1, LFQH_ChapterDiscussionKey
LFQH_Lloh2525:
nop
bl Lpatch + (0xa628 - PATCH_BASE)
mov	x20, x0
LFQH_Lloh2526:
adr x1, LFQH_l_.str.401
LFQH_Lloh2527:
nop
mov	x0, x19
bl	LFQH_Get
mov	x21, x0
LFQH_Lloh2528:
adr x1, LFQH_l_.str.105
LFQH_Lloh2529:
nop
bl	LFQH_Kind
cbz	w0, LFQH_LBB178_3
LFQH_Lloh2530:
adr x1, LFQH_l_.str.399
LFQH_Lloh2531:
nop
mov	x0, x19
bl	LFQH_Get
mov	x22, x0
LFQH_Lloh2532:
adr x0, LFQH_l_.str.400
LFQH_Lloh2533:
nop
bl Lpatch + (0xa5a4 - PATCH_BASE)
mov	x1, x0
mov	x0, x22
bl Lpatch + (0xa5d4 - PATCH_BASE)
cmp	x0, #1
b.ne	LFQH_LBB178_3
LFQH_Lloh2534:
adr x0, LFQH_l_.str.230
LFQH_Lloh2535:
nop
bl Lpatch + (0xa5a4 - PATCH_BASE)
mov	x1, x0
mov	x0, x21
bl Lpatch + (0xa5d4 - PATCH_BASE)
cmp	w0, #0
cset	w23, eq
b	LFQH_LBB178_4
LFQH_LBB178_3:
mov	w23, #0
LFQH_LBB178_4:
cmp	x20, #0
csinc	w8, w23, wzr, eq
cbz	w8, LFQH_LBB178_12
LFQH_Lloh2536:
adr x1, LFQH_l_.str.402
LFQH_Lloh2537:
nop
mov	x0, x19
bl	LFQH_Get
mov	x22, x0
cbz	w23, LFQH_LBB178_8
LFQH_Lloh2538:
adr x1, LFQH_l_.str.20
LFQH_Lloh2539:
nop
mov	x0, x21
bl	LFQH_Get
cmp	x0, x22
b.ne	LFQH_LBB178_8
LFQH_Lloh2540:
adr x1, LFQH_l_.str.20
LFQH_Lloh2541:
nop
mov	x0, x22
bl	LFQH_Get
cmp	x0, x19
b.eq	LFQH_LBB178_13
LFQH_LBB178_8:
mov	x0, x22
bl	LFQH_PageRestore
LFQH_LBB178_9:
mov	x21, #0
LFQH_LBB178_10:
cmp	x20, x21
b.eq	LFQH_LBB178_12
mov	x0, x20
bl	LFQH_RestoreHit
LFQH_Lloh2542:
adr x1, LFQH_ChapterDiscussionKey
LFQH_Lloh2543:
nop
mov	x0, x19
mov	x2, x21
mov	w3, #1
ldp	x29, x30, [sp, #80]
ldp	x20, x19, [sp, #64]
ldp	x22, x21, [sp, #48]
ldp	x24, x23, [sp, #32]
ldp	d9, d8, [sp, #16]
ldp	d11, d10, [sp], #96
b Lpatch + (0xa634 - PATCH_BASE)
LFQH_LBB178_12:
ldp	x29, x30, [sp, #80]
ldp	x20, x19, [sp, #64]
ldp	x22, x21, [sp, #48]
ldp	x24, x23, [sp, #32]
ldp	d9, d8, [sp, #16]
ldp	d11, d10, [sp], #96
ret
LFQH_LBB178_13:
LFQH_Lloh2544:
adr x1, LFQH_SurfaceKey
LFQH_Lloh2545:
nop
mov	x0, x21
bl Lpatch + (0xa628 - PATCH_BASE)
cbz	x0, LFQH_LBB178_15
mov	x0, x21
bl	LFQH_PageRestore
LFQH_LBB178_15:
mov	x0, x22
bl	LFQH_FQHApply
LFQH_Lloh2546:
adr x1, LFQH_SurfaceKey
LFQH_Lloh2547:
nop
mov	x0, x22
bl Lpatch + (0xa628 - PATCH_BASE)
cbz	x0, LFQH_LBB178_9
LFQH_Lloh2548:
adr x0, LFQH_l_.str.24
LFQH_Lloh2549:
nop
bl Lpatch + (0xa5a4 - PATCH_BASE)
mov	x1, x0
mov	x0, x22
bl Lpatch + (0xa5d4 - PATCH_BASE)
mov.16b	v8, v0
mov.16b	v9, v1
mov.16b	v10, v2
mov.16b	v11, v3
LFQH_Lloh2550:
adr x0, LFQH_l_.str.241
LFQH_Lloh2551:
nop
bl Lpatch + (0xa5a4 - PATCH_BASE)
mov	x1, x0
mov	x0, x22
mov.16b	v0, v8
mov.16b	v1, v9
mov.16b	v2, v10
mov.16b	v3, v11
mov	x2, x21
bl Lpatch + (0xa5d4 - PATCH_BASE)
mov	x0, x21
bl	LFQH_EnsureHit
b	LFQH_LBB178_10
.cfi_endproc
.p2align	2
LFQH_ChapterDiscussionKey:
.cfi_startproc
ret
.cfi_endproc
.p2align	2
LFQH_ChapterRewardGlass:
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
mov	x20, x0
LFQH_Lloh2552:
adr x1, LFQH_l_.str.20
LFQH_Lloh2553:
nop
bl	LFQH_Get
mov	x21, x0
LFQH_Lloh2554:
adr x1, LFQH_l_.str.403
LFQH_Lloh2555:
nop
mov	x0, x20
bl	LFQH_Get
mov	x19, x0
LFQH_Lloh2556:
adr x1, LFQH_l_.str.109
LFQH_Lloh2557:
nop
mov	x0, x21
bl	LFQH_Kind
tbnz	w0, #0, LFQH_LBB180_2
LFQH_Lloh2558:
adr x1, LFQH_l_.str.404
LFQH_Lloh2559:
nop
mov	x0, x21
bl	LFQH_Kind
cbz	w0, LFQH_LBB180_4
LFQH_LBB180_2:
LFQH_Lloh2560:
adr x1, LFQH_l_.str.20
LFQH_Lloh2561:
nop
mov	x0, x19
bl	LFQH_Get
cmp	x0, x20
b.ne	LFQH_LBB180_4
LFQH_Lloh2562:
adr x0, LFQH_l_.str.230
LFQH_Lloh2563:
nop
bl Lpatch + (0xa5a4 - PATCH_BASE)
mov	x1, x0
mov	x0, x20
bl Lpatch + (0xa5d4 - PATCH_BASE)
cbz	w0, LFQH_LBB180_7
LFQH_LBB180_4:
LFQH_Lloh2564:
adr x1, LFQH_SurfaceKey
LFQH_Lloh2565:
nop
mov	x0, x19
bl Lpatch + (0xa628 - PATCH_BASE)
cbz	x0, LFQH_LBB180_6
mov	x0, x19
ldp	x29, x30, [sp, #32]
ldp	x20, x19, [sp, #16]
ldp	x22, x21, [sp], #48
b	LFQH_PageRestore
LFQH_LBB180_6:
ldp	x29, x30, [sp, #32]
ldp	x20, x19, [sp, #16]
ldp	x22, x21, [sp], #48
ret
LFQH_LBB180_7:
mov	x0, x19
ldp	x29, x30, [sp, #32]
ldp	x20, x19, [sp, #16]
ldp	x22, x21, [sp], #48
b	LFQH_FQHApply
.cfi_endproc
.p2align	2
LFQH_ShelfFilterStyle:
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
LFQH_Lloh2566:
adr x1, LFQH_l_.str.405
LFQH_Lloh2567:
nop
bl	LFQH_HasAncestor
cbz	w0, LFQH_LBB181_3
LFQH_Lloh2568:
adr x1, LFQH_l_.str.128
LFQH_Lloh2569:
nop
mov	x0, x19
bl	LFQH_HasAncestor
tbz	w0, #0, LFQH_LBB181_3
LFQH_Lloh2570:
adr x0, LFQH_l_.str.24
LFQH_Lloh2571:
nop
bl Lpatch + (0xa5a4 - PATCH_BASE)
mov	x1, x0
mov	x0, x19
bl Lpatch + (0xa5d4 - PATCH_BASE)
fmov	d4, #1.00000000
fadd	d0, d0, d4
fmov	d5, #-2.00000000
fadd	d2, d2, d5
fadd	d1, d1, d4
fadd	d3, d3, d5
mov	x0, x19
mov	w1, #0
bl	LFQH_ApplySurface
LFQH_Lloh2572:
adr x1, LFQH_SurfaceKey
LFQH_Lloh2573:
nop
mov	x0, x19
bl Lpatch + (0xa628 - PATCH_BASE)
mov	x20, x0
LFQH_Lloh2574:
adr x1, LFQH_l_.str.406
LFQH_Lloh2575:
nop
mov	x0, x19
bl	LFQH_BoolProp
mov	x1, x0
mov	x0, x20
mov	w2, #1
ldp	x29, x30, [sp, #16]
ldp	x20, x19, [sp], #32
b	LFQH_ShelfTint
LFQH_LBB181_3:
mov	x0, x19
ldp	x29, x30, [sp, #16]
ldp	x20, x19, [sp], #32
b	LFQH_PageRestore
.cfi_endproc
.p2align	2
LFQH_ProfileIconGlass:
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
mov	x22, x2
mov	x23, x1
mov	x19, x0
mov	x1, x2
bl Lpatch + (0xa628 - PATCH_BASE)
mov	x20, x0
LFQH_Lloh2576:
adr x1, LFQH_l_.str.396
LFQH_Lloh2577:
nop
mov	x0, x23
bl	LFQH_Kind
fmov	d8, xzr
cmp	w0, #0
ccmp	x23, #0, #4, ne
b.ne	LFQH_LBB182_6
LFQH_LBB182_1:
mov	x21, #0
LFQH_LBB182_2:
fmov	d10, xzr
fmov	d9, xzr
fmov	d11, xzr
LFQH_LBB182_3:
fmov	x8, d11
ubfx	x8, x8, #52, #11
fmov	x9, d9
ubfx	x9, x9, #52, #11
fmov	x10, d10
ubfx	x10, x10, #52, #11
cmp	x10, #2046
mov	w10, #2046
ccmp	x9, x10, #2, ls
ccmp	x8, x10, #2, ls
b.ls	LFQH_LBB182_14
LFQH_LBB182_4:
LFQH_Lloh2578:
adr x0, LFQH_l_.str.240
LFQH_Lloh2579:
nop
bl Lpatch + (0xa5a4 - PATCH_BASE)
mov	x1, x0
mov	x0, x20
bl Lpatch + (0xa5d4 - PATCH_BASE)
mov	x0, x19
mov	x1, x22
mov	x2, #0
LFQH_LBB182_5:
mov	w3, #1
ldp	x29, x30, [sp, #96]
ldp	x20, x19, [sp, #80]
ldp	x22, x21, [sp, #64]
ldp	x24, x23, [sp, #48]
ldp	x26, x25, [sp, #32]
ldp	d9, d8, [sp, #16]
ldp	d11, d10, [sp], #112
b Lpatch + (0xa634 - PATCH_BASE)
LFQH_LBB182_6:
mov	w26, #0
LFQH_Lloh2580:
adr x24, LFQH_l_.str.230
LFQH_Lloh2581:
nop
mov	x21, x23
LFQH_Lloh2582:
adr x25, LFQH_l_.str.20
LFQH_Lloh2583:
nop
LFQH_LBB182_7:
mov	x0, x24
bl Lpatch + (0xa5a4 - PATCH_BASE)
mov	x1, x0
mov	x0, x21
bl Lpatch + (0xa5d4 - PATCH_BASE)
cbnz	w0, LFQH_LBB182_1
mov	x0, x21
mov	x1, x25
bl	LFQH_Get
cmp	x0, x19
b.eq	LFQH_LBB182_12
cbz	x0, LFQH_LBB182_11
mov	x21, x0
cmp	w26, #2
add	w26, w26, #1
b.ls	LFQH_LBB182_7
LFQH_LBB182_11:
mov	x21, x0
cbz	x0, LFQH_LBB182_2
LFQH_LBB182_12:
LFQH_Lloh2584:
adr x1, LFQH_l_.str.20
LFQH_Lloh2585:
nop
mov	x0, x21
bl	LFQH_Get
cmp	x0, x19
b.ne	LFQH_LBB182_2
LFQH_Lloh2586:
adr x0, LFQH_l_.str.24
LFQH_Lloh2587:
nop
bl Lpatch + (0xa5a4 - PATCH_BASE)
mov	x1, x0
mov	x0, x23
bl Lpatch + (0xa5d4 - PATCH_BASE)
mov.16b	v8, v0
mov.16b	v9, v1
mov.16b	v10, v2
mov.16b	v11, v3
LFQH_Lloh2588:
adr x0, LFQH_l_.str.241
LFQH_Lloh2589:
nop
bl Lpatch + (0xa5a4 - PATCH_BASE)
mov	x1, x0
mov	x0, x23
mov.16b	v0, v8
mov.16b	v1, v9
mov.16b	v2, v10
mov.16b	v3, v11
mov	x2, x19
bl Lpatch + (0xa5d4 - PATCH_BASE)
mov.16b	v11, v0
mov.16b	v9, v1
mov.16b	v10, v2
mov.16b	v8, v3
b	LFQH_LBB182_3
LFQH_LBB182_14:
fmov	x8, d8
ubfx	x8, x8, #52, #11
cmp	x8, #2046
b.hi	LFQH_LBB182_4
fcmp	d10, #0.0
b.le	LFQH_LBB182_4
fcmp	d8, #0.0
b.le	LFQH_LBB182_4
cbnz	x20, LFQH_LBB182_20
bl	LFQH_NewGlassSurface
cbz	x0, LFQH_LBB182_25
mov	x20, x0
mov	x0, x19
mov	x1, x22
mov	x2, x20
mov	w3, #1
bl Lpatch + (0xa634 - PATCH_BASE)
LFQH_Lloh2590:
adr x0, LFQH_l_.str.55
LFQH_Lloh2591:
nop
bl Lpatch + (0xa5a4 - PATCH_BASE)
mov	x1, x0
mov	x0, x20
bl Lpatch + (0xa5d4 - PATCH_BASE)
LFQH_LBB182_20:
mov	x8, #-4593108669964484608
fmov	d0, x8
fadd	d1, d10, d0
fmov	d2, #0.50000000
fmul	d1, d1, d2
fadd	d10, d11, d1
fadd	d0, d8, d0
fmul	d0, d0, d2
fadd	d8, d9, d0
LFQH_Lloh2592:
adr x0, LFQH_l_.str.192
LFQH_Lloh2593:
nop
bl Lpatch + (0xa5a4 - PATCH_BASE)
mov	x1, x0
mov	x0, x20
bl Lpatch + (0xa5d4 - PATCH_BASE)
fcmp	d0, d10
fccmp	d1, d8, #0, eq
mov	x8, #4630263366890291200
fmov	d0, x8
fccmp	d2, d0, #0, eq
fccmp	d3, d0, #0, eq
b.eq	LFQH_LBB182_22
LFQH_Lloh2594:
adr x0, LFQH_l_.str.71
LFQH_Lloh2595:
nop
bl Lpatch + (0xa5a4 - PATCH_BASE)
mov	x1, x0
mov	x8, #4630263366890291200
fmov	d2, x8
mov	x0, x20
mov.16b	v0, v10
mov.16b	v1, v8
mov.16b	v3, v2
bl Lpatch + (0xa5d4 - PATCH_BASE)
LFQH_LBB182_22:
LFQH_Lloh2596:
adr x1, LFQH_l_.str.20
LFQH_Lloh2597:
nop
mov	x0, x20
bl	LFQH_Get
cmp	x0, x19
b.ne	LFQH_LBB182_24
LFQH_Lloh2598:
adr x1, LFQH_ProfileAnchorKey
LFQH_Lloh2599:
nop
mov	x0, x20
bl Lpatch + (0xa628 - PATCH_BASE)
cmp	x0, x21
b.eq	LFQH_LBB182_25
LFQH_LBB182_24:
LFQH_Lloh2600:
adr x0, LFQH_l_.str.236
LFQH_Lloh2601:
nop
bl Lpatch + (0xa5a4 - PATCH_BASE)
mov	x1, x0
mov	x0, x19
mov	x2, x20
mov	x3, x21
bl Lpatch + (0xa5d4 - PATCH_BASE)
LFQH_Lloh2602:
adr x1, LFQH_ProfileAnchorKey
LFQH_Lloh2603:
nop
mov	x0, x20
mov	x2, x21
b	LFQH_LBB182_5
LFQH_LBB182_25:
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
LFQH_ProfileScanKey:
.cfi_startproc
ret
.cfi_endproc
.p2align	2
LFQH_ProfileNightKey:
.cfi_startproc
ret
.cfi_endproc
.p2align	2
LFQH_ProfileMenuKey:
.cfi_startproc
ret
.cfi_endproc
.p2align	2
LFQH_ProfileAnchorKey:
.cfi_startproc
ret
.cfi_endproc
.p2align	2
LFQH_ProfileEntryGlass:
.cfi_startproc
sub	sp, sp, #160
stp	d15, d14, [sp, #48]
stp	d13, d12, [sp, #64]
stp	d11, d10, [sp, #80]
stp	d9, d8, [sp, #96]
stp	x22, x21, [sp, #112]
stp	x20, x19, [sp, #128]
stp	x29, x30, [sp, #144]
add	x29, sp, #144
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
mov	x22, x1
mov	x21, x0
LFQH_Lloh2604:
adr x1, LFQH_l_.str.193
LFQH_Lloh2605:
nop
bl	LFQH_Get
cbz	x0, LFQH_LBB187_28
mov	x19, x0
LFQH_Lloh2606:
adr x1, LFQH_l_.str.412
LFQH_Lloh2607:
nop
mov	x0, x21
bl	LFQH_HasAncestor
tbnz	w0, #0, LFQH_LBB187_3
LFQH_Lloh2608:
adr x1, LFQH_l_.str.413
LFQH_Lloh2609:
nop
mov	x0, x21
bl	LFQH_HasAncestor
cbz	w0, LFQH_LBB187_7
LFQH_LBB187_3:
bl	LFQH_Enabled
cbz	w0, LFQH_LBB187_7
bl	LFQH_FQHGlassAvailable
cbz	w0, LFQH_LBB187_7
LFQH_Lloh2610:
adr x8, LFQH_l_.str.414
LFQH_Lloh2611:
nop
LFQH_Lloh2612:
adr x9, LFQH_l_.str.415
LFQH_Lloh2613:
nop
cmp	w22, #0
csel	x1, x9, x8, eq
mov	x0, x21
bl	LFQH_Get
mov	x20, x0
cbz	x0, LFQH_LBB187_8
LFQH_Lloh2614:
adr x8, LFQH_l_.str.416
LFQH_Lloh2615:
nop
LFQH_Lloh2616:
adr x9, LFQH_l_.str.417
LFQH_Lloh2617:
nop
cmp	w22, #0
csel	x1, x9, x8, eq
mov	x0, x21
bl	LFQH_Get
mov	x21, x0
b	LFQH_LBB187_9
LFQH_LBB187_7:
mov	x20, #0
LFQH_LBB187_8:
mov	x21, #0
LFQH_LBB187_9:
LFQH_Lloh2618:
adr x1, LFQH_l_.str.396
LFQH_Lloh2619:
nop
mov	x0, x20
bl	LFQH_Kind
cbz	w0, LFQH_LBB187_29
LFQH_Lloh2620:
adr x1, LFQH_l_.str.20
LFQH_Lloh2621:
nop
mov	x0, x20
bl	LFQH_Get
cmp	x0, x19
b.ne	LFQH_LBB187_29
LFQH_Lloh2622:
adr x0, LFQH_l_.str.230
LFQH_Lloh2623:
nop
bl Lpatch + (0xa5a4 - PATCH_BASE)
mov	x1, x0
mov	x0, x20
bl Lpatch + (0xa5d4 - PATCH_BASE)
cbnz	w0, LFQH_LBB187_29
LFQH_Lloh2624:
adr x1, LFQH_l_.str.20
LFQH_Lloh2625:
nop
mov	x0, x21
bl	LFQH_Get
cmp	x0, x19
b.ne	LFQH_LBB187_29
LFQH_Lloh2626:
adr x1, LFQH_GlyphViewKey
LFQH_Lloh2627:
nop
mov	x0, x19
bl Lpatch + (0xa628 - PATCH_BASE)
cmp	x0, x20
b.eq	LFQH_LBB187_15
mov	x0, x19
bl	LFQH_RestoreProfileEntryGlyph
LFQH_LBB187_15:
LFQH_Lloh2628:
adr x0, LFQH_l_.str.24
LFQH_Lloh2629:
nop
bl Lpatch + (0xa5a4 - PATCH_BASE)
mov	x1, x0
mov	x0, x19
bl Lpatch + (0xa5d4 - PATCH_BASE)
str	d0, [sp, #24]
mov.16b	v14, v1
mov.16b	v15, v2
mov.16b	v12, v3
LFQH_Lloh2630:
adr x22, LFQH_l_.str.192
LFQH_Lloh2631:
nop
mov	x0, x22
bl Lpatch + (0xa5a4 - PATCH_BASE)
mov	x1, x0
mov	x0, x21
bl Lpatch + (0xa5d4 - PATCH_BASE)
stp	d2, d0, [sp, #32]
mov.16b	v9, v1
mov.16b	v11, v3
mov	x0, x22
bl Lpatch + (0xa5a4 - PATCH_BASE)
mov	x1, x0
mov	x0, x20
bl Lpatch + (0xa5d4 - PATCH_BASE)
mov.16b	v8, v1
mov.16b	v10, v3
fadd	d3, d14, d12
fmov	d1, #-2.00000000
fadd	d4, d3, d1
fmov	d3, #-3.00000000
fadd	d3, d9, d3
fminnm	d13, d4, d3
fmov	d3, #-4.00000000
fadd	d4, d15, d3
fsub	d3, d13, d14
fadd	d1, d3, d1
fminnm	d3, d4, d1
mov	x8, #4629981891913580544
fmov	d1, x8
fminnm	d12, d3, d1
fmov	d1, #20.00000000
fcmp	d12, d1
b.lt	LFQH_LBB187_29
mov.16b	v1, v8
mov.16b	v3, v10
stp	d2, d0, [sp, #8]
bl	LFQH_VisibleRect
cbz	w0, LFQH_LBB187_29
ldp	d2, d0, [sp, #32]
mov.16b	v1, v9
mov.16b	v3, v11
bl	LFQH_VisibleRect
ldp	d2, d4, [sp, #8]
tbz	w0, #0, LFQH_LBB187_29
fmov	d0, #2.00000000
ldr	d5, [sp, #24]
fadd	d1, d5, d0
fsub	d2, d2, d12
fmov	d3, #0.50000000
fmul	d2, d2, d3
fadd	d2, d4, d2
fadd	d4, d5, d15
fsub	d4, d4, d12
fmov	d5, #-2.00000000
fadd	d4, d4, d5
fminnm	d2, d2, d4
fmaxnm	d9, d1, d2
fadd	d0, d14, d0
fsub	d1, d10, d12
fmul	d1, d1, d3
fadd	d1, d8, d1
fsub	d2, d13, d12
fminnm	d1, d1, d2
fmaxnm	d14, d0, d1
mov	x0, x19
mov.16b	v0, v9
mov.16b	v1, v14
mov.16b	v2, v12
mov.16b	v3, v12
mov	w1, #1
bl	LFQH_ApplySurface
LFQH_Lloh2632:
adr x1, LFQH_SurfaceKey
LFQH_Lloh2633:
nop
mov	x0, x19
bl Lpatch + (0xa628 - PATCH_BASE)
cbz	x0, LFQH_LBB187_28
mov.16b	v13, v8
mov.16b	v15, v10
LFQH_Lloh2634:
adr x1, LFQH_GlyphAppliedKey
LFQH_Lloh2635:
nop
mov	x0, x20
bl Lpatch + (0xa628 - PATCH_BASE)
mov	x21, x0
cbz	x0, LFQH_LBB187_24
LFQH_Lloh2636:
adr x0, LFQH_l_.str.224
LFQH_Lloh2637:
nop
bl Lpatch + (0xa5a4 - PATCH_BASE)
mov	x1, x0
mov	x0, x21
bl Lpatch + (0xa5d4 - PATCH_BASE)
ldr	d4, [sp, #16]
fcmp	d4, d0
b.ne	LFQH_LBB187_24
fcmp	d13, d1
b.ne	LFQH_LBB187_24
ldr	d0, [sp, #8]
fcmp	d0, d2
b.ne	LFQH_LBB187_24
fcmp	d15, d3
b.eq	LFQH_LBB187_25
LFQH_LBB187_24:
ldp	d2, d0, [sp, #8]
mov.16b	v1, v13
mov.16b	v3, v15
bl	LFQH_RectBox
mov	x2, x0
LFQH_Lloh2638:
adr x1, LFQH_GlyphOriginalKey
LFQH_Lloh2639:
nop
mov	x0, x20
mov	w3, #1
bl Lpatch + (0xa634 - PATCH_BASE)
LFQH_LBB187_25:
LFQH_Lloh2640:
adr x1, LFQH_GlyphOriginalKey
LFQH_Lloh2641:
nop
mov	x0, x20
bl Lpatch + (0xa628 - PATCH_BASE)
mov	x22, x0
LFQH_Lloh2642:
adr x0, LFQH_l_.str.224
LFQH_Lloh2643:
nop
bl Lpatch + (0xa5a4 - PATCH_BASE)
mov	x1, x0
mov	x0, x22
bl Lpatch + (0xa5d4 - PATCH_BASE)
fmaxnm	d0, d2, d3
fmov	d1, #-10.00000000
fadd	d1, d12, d1
fmov	d4, #16.00000000
fminnm	d1, d1, d4
fdiv	d0, d1, d0
fmov	d1, #0.75000000
fminnm	d0, d0, d1
fmul	d8, d2, d0
fsub	d1, d12, d8
fmov	d2, #0.50000000
fmul	d1, d1, d2
fadd	d10, d9, d1
fmul	d9, d3, d0
fsub	d0, d12, d9
fmul	d0, d0, d2
fadd	d11, d14, d0
ldp	d0, d1, [sp, #8]
fcmp	d1, d10
fccmp	d13, d11, #0, eq
fccmp	d0, d8, #0, eq
fccmp	d15, d9, #0, eq
b.eq	LFQH_LBB187_27
LFQH_Lloh2644:
adr x0, LFQH_l_.str.71
LFQH_Lloh2645:
nop
bl Lpatch + (0xa5a4 - PATCH_BASE)
mov	x1, x0
mov	x0, x20
mov.16b	v0, v10
mov.16b	v1, v11
mov.16b	v2, v8
mov.16b	v3, v9
bl Lpatch + (0xa5d4 - PATCH_BASE)
mov.16b	v0, v10
mov.16b	v1, v11
mov.16b	v2, v8
mov.16b	v3, v9
bl	LFQH_RectBox
mov	x2, x0
LFQH_Lloh2646:
adr x1, LFQH_GlyphAppliedKey
LFQH_Lloh2647:
nop
mov	x0, x20
mov	w3, #1
bl Lpatch + (0xa634 - PATCH_BASE)
LFQH_LBB187_27:
cbz	x21, LFQH_LBB187_30
LFQH_LBB187_28:
ldp	x29, x30, [sp, #144]
ldp	x20, x19, [sp, #128]
ldp	x22, x21, [sp, #112]
ldp	d9, d8, [sp, #96]
ldp	d11, d10, [sp, #80]
ldp	d13, d12, [sp, #64]
ldp	d15, d14, [sp, #48]
add	sp, sp, #160
ret
LFQH_LBB187_29:
mov	x0, x19
bl	LFQH_RestoreProfileEntryGlyph
mov	x0, x19
ldp	x29, x30, [sp, #144]
ldp	x20, x19, [sp, #128]
ldp	x22, x21, [sp, #112]
ldp	d9, d8, [sp, #96]
ldp	d11, d10, [sp, #80]
ldp	d13, d12, [sp, #64]
ldp	d15, d14, [sp, #48]
add	sp, sp, #160
b	LFQH_PageRestore
LFQH_LBB187_30:
LFQH_Lloh2648:
adr x1, LFQH_GlyphViewKey
LFQH_Lloh2649:
nop
mov	x0, x19
mov	x2, x20
mov	w3, #1
ldp	x29, x30, [sp, #144]
ldp	x20, x19, [sp, #128]
ldp	x22, x21, [sp, #112]
ldp	d9, d8, [sp, #96]
ldp	d11, d10, [sp, #80]
ldp	d13, d12, [sp, #64]
ldp	d15, d14, [sp, #48]
add	sp, sp, #160
b Lpatch + (0xa634 - PATCH_BASE)
.cfi_endproc
.p2align	2
LFQH_RestoreProfileEntryGlyph:
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
LFQH_Lloh2650:
adr x1, LFQH_GlyphViewKey
LFQH_Lloh2651:
nop
bl Lpatch + (0xa628 - PATCH_BASE)
mov	x20, x0
LFQH_Lloh2652:
adr x1, LFQH_GlyphAppliedKey
LFQH_Lloh2653:
nop
bl Lpatch + (0xa628 - PATCH_BASE)
cbz	x0, LFQH_LBB188_3
mov	x21, x0
LFQH_Lloh2654:
adr x0, LFQH_l_.str.192
LFQH_Lloh2655:
nop
bl Lpatch + (0xa5a4 - PATCH_BASE)
mov	x1, x0
mov	x0, x20
bl Lpatch + (0xa5d4 - PATCH_BASE)
mov.16b	v8, v0
mov.16b	v9, v1
mov.16b	v10, v2
mov.16b	v11, v3
LFQH_Lloh2656:
adr x0, LFQH_l_.str.224
LFQH_Lloh2657:
nop
bl Lpatch + (0xa5a4 - PATCH_BASE)
mov	x1, x0
mov	x0, x21
bl Lpatch + (0xa5d4 - PATCH_BASE)
fcmp	d8, d0
fccmp	d9, d1, #0, eq
fccmp	d10, d2, #0, eq
fccmp	d11, d3, #0, eq
b.eq	LFQH_LBB188_3
LFQH_Lloh2658:
adr x1, LFQH_GlyphOriginalKey
LFQH_Lloh2659:
nop
mov	x0, x20
mov	x2, #0
mov	w3, #1
bl Lpatch + (0xa634 - PATCH_BASE)
LFQH_LBB188_3:
mov	x0, x19
ldp	x29, x30, [sp, #64]
ldp	x20, x19, [sp, #48]
ldp	x22, x21, [sp, #32]
ldp	d9, d8, [sp, #16]
ldp	d11, d10, [sp], #80
b	LFQH_RestoreGlyph
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
LFQH_Lloh2660:
adr x1, LFQH_l_.str.438
LFQH_Lloh2661:
nop
bl	LFQH_Get
mov	x19, x0
LFQH_Lloh2662:
adr x1, LFQH_l_.str.228
LFQH_Lloh2663:
nop
bl	LFQH_Kind
cmp	w0, #0
ccmp	x19, #0, #4, ne
b.ne	LFQH_LBB189_2
LFQH_LBB189_1:
ldp	x29, x30, [sp, #48]
ldp	x20, x19, [sp, #32]
ldp	x22, x21, [sp, #16]
ldp	x24, x23, [sp], #64
ret
LFQH_LBB189_2:
mov	w22, #0
LFQH_Lloh2664:
adr x21, LFQH_l_.str.20
LFQH_Lloh2665:
nop
mov	x0, x19
LFQH_LBB189_3:
cmp	x0, x20
b.eq	LFQH_LBB189_6
mov	x1, x21
bl	LFQH_Get
cbz	x0, LFQH_LBB189_1
cmp	w22, #7
add	w22, w22, #1
b.lo	LFQH_LBB189_3
b	LFQH_LBB189_1
LFQH_LBB189_6:
LFQH_Lloh2666:
adr x0, LFQH_l_.str.439
LFQH_Lloh2667:
nop
bl Lpatch + (0xa5a4 - PATCH_BASE)
mov	x1, x0
mov	x0, x19
mov	x2, #0
bl Lpatch + (0xa5d4 - PATCH_BASE)
mov	x20, x0
LFQH_Lloh2668:
adr x1, LFQH_SpeechGlyphKey
LFQH_Lloh2669:
nop
mov	x0, x19
bl Lpatch + (0xa628 - PATCH_BASE)
mov	x21, x0
LFQH_Lloh2670:
adr x0, LFQH_l_.str.46
LFQH_Lloh2671:
nop
bl Lpatch + (0xa5b0 - PATCH_BASE)
mov	x22, x0
LFQH_Lloh2672:
adr x0, LFQH_l_.str.47
LFQH_Lloh2673:
nop
bl Lpatch + (0xa5a4 - PATCH_BASE)
mov	x1, x0
mov	x0, x22
bl Lpatch + (0xa5d4 - PATCH_BASE)
mov	x22, x0
LFQH_Lloh2674:
adr x1, LFQH_l_.str.440
LFQH_Lloh2675:
nop
mov	x0, x19
bl	LFQH_Get
mov	x24, x0
LFQH_Lloh2676:
adr x0, LFQH_l_.str.48
LFQH_Lloh2677:
nop
bl Lpatch + (0xa5a4 - PATCH_BASE)
mov	x1, x0
mov	x0, x24
mov	x2, x22
bl Lpatch + (0xa5d4 - PATCH_BASE)
mov	x23, x0
bl	LFQH_Enabled
cbz	w0, LFQH_LBB189_9
bl	LFQH_FQHGlassAvailable
cbz	w0, LFQH_LBB189_9
LFQH_Lloh2678:
adr x0, LFQH_l_.str.24
LFQH_Lloh2679:
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
b.ls	LFQH_LBB189_17
LFQH_LBB189_9:
cbz	x21, LFQH_LBB189_16
cmp	x20, x21
b.ne	LFQH_LBB189_12
LFQH_Lloh2680:
adr x1, LFQH_SpeechImageKey
LFQH_Lloh2681:
nop
mov	x0, x19
bl Lpatch + (0xa628 - PATCH_BASE)
mov	x20, x0
LFQH_Lloh2682:
adr x0, LFQH_l_.str.444
LFQH_Lloh2683:
nop
bl Lpatch + (0xa5a4 - PATCH_BASE)
mov	x1, x0
mov	x0, x19
mov	x2, x20
mov	x3, #0
bl Lpatch + (0xa5d4 - PATCH_BASE)
LFQH_LBB189_12:
LFQH_Lloh2684:
adr x1, LFQH_SpeechTintKey
LFQH_Lloh2685:
nop
mov	x0, x19
bl Lpatch + (0xa628 - PATCH_BASE)
cbz	w23, LFQH_LBB189_15
mov	x20, x0
cbz	x0, LFQH_LBB189_15
LFQH_Lloh2686:
adr x0, LFQH_l_.str.53
LFQH_Lloh2687:
nop
bl Lpatch + (0xa5a4 - PATCH_BASE)
mov	x1, x0
mov	x0, x19
mov	x2, x20
bl Lpatch + (0xa5d4 - PATCH_BASE)
LFQH_LBB189_15:
LFQH_Lloh2688:
adr x1, LFQH_SpeechImageKey
LFQH_Lloh2689:
nop
mov	x0, x19
mov	x2, #0
mov	w3, #1
bl Lpatch + (0xa634 - PATCH_BASE)
LFQH_Lloh2690:
adr x1, LFQH_SpeechGlyphKey
LFQH_Lloh2691:
nop
mov	x0, x19
mov	x2, #0
mov	w3, #1
bl Lpatch + (0xa634 - PATCH_BASE)
LFQH_Lloh2692:
adr x1, LFQH_SpeechTintKey
LFQH_Lloh2693:
nop
mov	x0, x19
mov	x2, #0
mov	w3, #1
bl Lpatch + (0xa634 - PATCH_BASE)
LFQH_LBB189_16:
LFQH_Lloh2694:
adr x1, LFQH_SurfaceKey
LFQH_Lloh2695:
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
LFQH_LBB189_17:
fmov	x8, d3
ubfx	x8, x8, #52, #11
cmp	x8, #2046
b.hi	LFQH_LBB189_9
fcmp	d2, #0.0
b.le	LFQH_LBB189_9
fcmp	d3, #0.0
b.le	LFQH_LBB189_9
cbnz	x21, LFQH_LBB189_22
LFQH_Lloh2696:
adr x0, LFQH_l_.str.441
LFQH_Lloh2697:
nop
bl Lpatch + (0xa5b0 - PATCH_BASE)
LFQH_Lloh2698:
adr x1, LFQH_l_.str.442
LFQH_Lloh2699:
nop
bl	LFQH_Get
mov	x21, x0
LFQH_Lloh2700:
adr x0, LFQH_l_.str.443
LFQH_Lloh2701:
nop
bl Lpatch + (0xa5a4 - PATCH_BASE)
mov	x1, x0
mov	x0, x21
mov	w2, #2
bl Lpatch + (0xa5d4 - PATCH_BASE)
mov	x21, x0
cbz	x0, LFQH_LBB189_1
LFQH_LBB189_22:
mov	x0, x19
bl	LFQH_FQHApply
LFQH_Lloh2702:
adr x1, LFQH_SurfaceKey
LFQH_Lloh2703:
nop
mov	x0, x19
bl Lpatch + (0xa628 - PATCH_BASE)
cbz	x0, LFQH_LBB189_1
cbnz	w23, LFQH_LBB189_25
LFQH_Lloh2704:
adr x1, LFQH_SpeechTintKey
LFQH_Lloh2705:
nop
mov	x0, x19
mov	x2, x24
mov	w3, #1
bl Lpatch + (0xa634 - PATCH_BASE)
LFQH_Lloh2706:
adr x0, LFQH_l_.str.53
LFQH_Lloh2707:
nop
bl Lpatch + (0xa5a4 - PATCH_BASE)
mov	x1, x0
mov	x0, x19
mov	x2, x22
bl Lpatch + (0xa5d4 - PATCH_BASE)
LFQH_LBB189_25:
cmp	x20, x21
b.eq	LFQH_LBB189_1
LFQH_Lloh2708:
adr x1, LFQH_SpeechImageKey
LFQH_Lloh2709:
nop
mov	x0, x19
mov	x2, x20
mov	w3, #1
bl Lpatch + (0xa634 - PATCH_BASE)
LFQH_Lloh2710:
adr x1, LFQH_SpeechGlyphKey
LFQH_Lloh2711:
nop
mov	x0, x19
mov	x2, x21
mov	w3, #1
bl Lpatch + (0xa634 - PATCH_BASE)
LFQH_Lloh2712:
adr x0, LFQH_l_.str.444
LFQH_Lloh2713:
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
.asciz	"integerValue"
LFQH_l_.str.31:
.asciz	"backBtn"
LFQH_l_.str.32:
.asciz	"insertObjs"
LFQH_l_.str.33:
.asciz	"NSArray"
LFQH_l_.str.34:
.asciz	"count"
LFQH_l_.str.35:
.asciz	"getInsertView"
LFQH_l_.str.36:
.asciz	"UILabel"
LFQH_l_.str.37:
.asciz	"searchButton"
LFQH_l_.str.38:
.asciz	"moreButton"
LFQH_l_.str.39:
.asciz	"searchAndMoreView"
LFQH_l_.str.40:
.asciz	"boolValue"
LFQH_l_.str.41:
.asciz	"UIControl"
LFQH_l_.str.42:
.asciz	"SSBookshelfEditBottomView"
LFQH_l_.str.43:
.asciz	"SSReaderFloatingCommonButton"
LFQH_l_.str.44:
.asciz	"setTextColor:"
LFQH_l_.str.45:
.asciz	"textColor"
LFQH_l_.str.46:
.asciz	"UIColor"
LFQH_l_.str.47:
.asciz	"labelColor"
LFQH_l_.str.48:
.asciz	"isEqual:"
LFQH_l_.str.49:
.asciz	"secondarySystemBackgroundColor"
LFQH_l_.str.50:
.asciz	"colorWithAlphaComponent:"
LFQH_l_.str.51:
.asciz	"effect"
LFQH_l_.str.52:
.asciz	"copy"
LFQH_l_.str.53:
.asciz	"setTintColor:"
LFQH_l_.str.54:
.asciz	"setEffect:"
LFQH_l_.str.55:
.asciz	"release"
LFQH_l_.str.56:
.asciz	"FQReaderSaaSBottomToolItemView"
LFQH_l_.str.57:
.asciz	"FQReaderSaaSBottomToolView"
LFQH_l_.str.58:
.asciz	"FQReaderSaaSReaderSpeechButton"
LFQH_l_.str.59:
.asciz	"miniGameEntranceCellModel"
LFQH_l_.str.60:
.asciz	"setIsInvisible:"
LFQH_l_.str.61:
.asciz	"setIsDisabled:"
LFQH_l_.str.62:
.asciz	"models"
LFQH_l_.str.63:
.asciz	"NSMutableArray"
LFQH_l_.str.64:
.asciz	"removeObjectIdenticalTo:"
LFQH_l_.str.65:
.asciz	"SSMyUser621BaseViewController"
LFQH_l_.str.66:
.asciz	"removeModelBeforeListAdapter"
LFQH_l_.str.67:
.asciz	"tableView"
LFQH_l_.str.68:
.asciz	"tableHeaderView"
LFQH_l_.str.69:
.asciz	"alloc"
LFQH_l_.str.70:
.asciz	"init"
LFQH_l_.str.71:
.asciz	"setFrame:"
LFQH_l_.str.72:
.asciz	"setBackgroundColor:"
LFQH_l_.str.73:
.asciz	"clearColor"
LFQH_l_.str.74:
.asciz	"setText:"
LFQH_l_.str.75:
.asciz	"\345\272\225\346\240\217\350\207\263\345\260\221\344\277\235\347\225\231\344\270\200\351\241\271\343\200\202\n\345\205\263\351\227\255\342\200\234\346\210\221\347\232\204\342\200\235\345\220\216\357\274\214\351\225\277\346\214\211\345\272\225\346\240\217\346\211\223\345\274\200 FanqieX \350\256\276\347\275\256\343\200\202"
LFQH_l_.str.76:
.asciz	"setNumberOfLines:"
LFQH_l_.str.77:
.asciz	"setFont:"
LFQH_l_.str.78:
.asciz	"UIFont"
LFQH_l_.str.79:
.asciz	"systemFontOfSize:"
LFQH_l_.str.80:
.asciz	"secondaryLabelColor"
LFQH_l_.str.81:
.asciz	"setAutoresizingMask:"
LFQH_l_.str.82:
.asciz	"addSubview:"
LFQH_l_.str.83:
.asciz	"setTableHeaderView:"
LFQH_l_.str.84:
.asciz	"cellModel"
LFQH_l_.str.85:
.asciz	"FQReaderUIManager"
LFQH_l_.str.86:
.asciz	"showBottomBarContainer:"
LFQH_l_.str.87:
.asciz	"fqx180_originalReaderMenu:"
LFQH_l_.str.88:
.asciz	"v20@0:8B16"
LFQH_l_.str.89:
.asciz	"onConfigThemeChange:context:"
LFQH_l_.str.90:
.asciz	"fqx180_originalReaderTheme:context:"
LFQH_l_.str.91:
.asciz	"v32@0:8@16@24"
LFQH_l_.str.92:
.asciz	"layoutSubviews"
LFQH_l_.str.93:
.asciz	"fqx175_originalBottom"
LFQH_l_.str.94:
.asciz	"FQReaderSaaSNewProgressView"
LFQH_l_.str.95:
.asciz	"fqx174_originalProgress"
LFQH_l_.str.96:
.asciz	"updateWithConfigData:"
LFQH_l_.str.97:
.asciz	"fqx176_originalProgressTheme:"
LFQH_l_.str.98:
.asciz	"v24@0:8@16"
LFQH_l_.str.99:
.asciz	"SSReaderBottomToolDivertView"
LFQH_l_.str.100:
.asciz	"fqx175_originalDivert"
LFQH_l_.str.101:
.asciz	"SSReaderGiftView"
LFQH_l_.str.102:
.asciz	"fqx174_originalGift"
LFQH_l_.str.103:
.asciz	"SSReaderBookEndUserGiftView"
LFQH_l_.str.104:
.asciz	"fqx174_originalBookGift"
LFQH_l_.str.105:
.asciz	"SSReaderChapterEndDiscussionEntranceView"
LFQH_l_.str.106:
.asciz	"fqx174_originalDiscuss"
LFQH_l_.str.107:
.asciz	"SSReaderChapterEndDiscussionEntranceButton"
LFQH_l_.str.108:
.asciz	"fqx174_originalDiscussButton"
LFQH_l_.str.109:
.asciz	"SSReaderChapterEndCommunityCardView"
LFQH_l_.str.110:
.asciz	"fqx177_originalChapterCard"
LFQH_l_.str.111:
.asciz	"updateWithReaderConfig:"
LFQH_l_.str.112:
.asciz	"fqx177_originalChapterCardTheme:"
LFQH_l_.str.113:
.asciz	"SSReaderChapterEndBaseButton"
LFQH_l_.str.114:
.asciz	"fqx177_originalChapterButton"
LFQH_l_.str.115:
.asciz	"SSReaderChapterEndRewardButton"
LFQH_l_.str.116:
.asciz	"updateWithThemeConfigChange:"
LFQH_l_.str.117:
.asciz	"fqx177_originalChapterRewardTheme:"
LFQH_l_.str.118:
.asciz	"SSBookShelfTabSelectViewTitleCell"
LFQH_l_.str.119:
.asciz	"fqx174_originalShelfCategory"
LFQH_l_.str.120:
.asciz	"reloadData:"
LFQH_l_.str.121:
.asciz	"fqx175_originalShelfTabReload:"
LFQH_l_.str.122:
.asciz	"SSBookShelfFilter541Cell"
LFQH_l_.str.123:
.asciz	"fqx175_originalShelfFilterLayout"
LFQH_l_.str.124:
.asciz	"updateAppearance:"
LFQH_l_.str.125:
.asciz	"fqx175_originalShelfFilterAppearance:"
LFQH_l_.str.126:
.asciz	"updateCellBgColor:"
LFQH_l_.str.127:
.asciz	"fqx175_originalShelfFilterBackground:"
LFQH_l_.str.128:
.asciz	"SSBookShelfFilterHeaderView"
LFQH_l_.str.129:
.asciz	"fqx179_originalShelfFilterHeader"
LFQH_l_.str.130:
.asciz	"SSMyUserBar"
LFQH_l_.str.131:
.asciz	"fqx174_originalProfileBar"
LFQH_l_.str.132:
.asciz	"SSMyUserCollectionViewFunCell"
LFQH_l_.str.133:
.asciz	"fqx174_originalProfileEntry"
LFQH_l_.str.134:
.asciz	"SSMyUserCollectionViewOrderFunCell"
LFQH_l_.str.135:
.asciz	"fqx178_originalProfileOrder"
LFQH_l_.str.136:
.asciz	"setupCellMiniGameEntranceData"
LFQH_l_.str.137:
.asciz	"fqx174_originalMiniGameSetup"
LFQH_l_.str.138:
.asciz	"SSMyUserCell2Model"
LFQH_l_.str.139:
.asciz	"applyConfiguredMineEcomEntranceData:mineMonetizationStyle:"
LFQH_l_.str.140:
.asciz	"fqx176_originalMineEntrances:style:"
LFQH_l_.str.141:
.asciz	"v32@0:8@16q24"
LFQH_l_.str.142:
.asciz	"SSMyUser621ViewController"
LFQH_l_.str.143:
.asciz	"objectsForListAdapter:"
LFQH_l_.str.144:
.asciz	"fqx176_originalMineListObjects:"
LFQH_l_.str.145:
.asciz	"@24@0:8@16"
LFQH_l_.str.146:
.asciz	"setShowReadTimeView:"
LFQH_l_.str.147:
.asciz	"fqx177_originalDurationVisible:"
LFQH_l_.str.148:
.asciz	"fqx177_originalDurationLayout"
LFQH_l_.str.149:
.asciz	"SSBookShelfSubViewController"
LFQH_l_.str.150:
.asciz	"collectionView:layout:sizeForItemAtIndexPath:"
LFQH_l_.str.151:
.asciz	"fqx178_originalShelfFunctionSize:layout:index:"
LFQH_l_.str.152:
.asciz	"{CGSize=dd}40@0:8@16@24@32"
LFQH_l_.str.153:
.asciz	"SSBookShelfFunctionCell"
LFQH_l_.str.154:
.asciz	"layoutContainerSubviews"
LFQH_l_.str.155:
.asciz	"fqx178_originalShelfFunctionLayout"
LFQH_l_.str.156:
.asciz	"SSTabBarController"
LFQH_l_.str.157:
.asciz	"tabbarVCAndAttributeInit"
LFQH_l_.str.158:
.asciz	"fqx176_originalTabPlan"
LFQH_l_.str.159:
.asciz	"viewDidAppear:"
LFQH_l_.str.160:
.asciz	"fqx176_originalTabAppear:"
LFQH_l_.str.161:
.asciz	"fqx171_originalLayout"
LFQH_l_.str.162:
.asciz	"fqx175_originalSpeechLayout"
LFQH_l_.str.163:
.asciz	"readerInsertedViewBackgroundConfigChange:"
LFQH_l_.str.164:
.asciz	"fqx175_originalSpeechTheme:"
LFQH_l_.str.165:
.asciz	"fqx165_originalRelayout"
LFQH_l_.str.166:
.asciz	"fqx165_originalAppear:"
LFQH_l_.str.167:
.asciz	"fqx173_originalLayout"
LFQH_l_.str.168:
.asciz	"resetColorWithRatio:fromTab:toTab:fromTabTemplate:toTabTemplate:"
LFQH_l_.str.169:
.asciz	"fqx173_originalColor:from:to:fromTemplate:toTemplate:"
LFQH_l_.str.170:
.asciz	"v40@0:8d16i24i28i32i36"
LFQH_l_.str.171:
.asciz	"SSBookStoreSearchBarComponent"
LFQH_l_.str.172:
.asciz	"resetTopTabSearchViewWithRatio:fromTab:toTab:fromTabTemplate:toTabTemplate:"
LFQH_l_.str.173:
.asciz	"fqx173_originalSearchColor:from:to:fromTemplate:toTemplate:"
LFQH_l_.str.174:
.asciz	"FQReaderSaaSBaseButton"
LFQH_l_.str.175:
.asciz	"fqx170_originalLayout"
LFQH_l_.str.176:
.asciz	"viewDidLayoutSubviews"
LFQH_l_.str.177:
.asciz	"fqx167_originalShelfLayout"
LFQH_l_.str.178:
.asciz	"FQReaderSaasNavigationView"
LFQH_l_.str.179:
.asciz	"fqx167_originalLayout"
LFQH_l_.str.180:
.asciz	"readerInsertedViewThemeConfigChange:"
LFQH_l_.str.181:
.asciz	"fqx167_originalTheme:"
LFQH_l_.str.182:
.asciz	"NSString"
LFQH_l_.str.183:
.asciz	"stringWithUTF8String:"
LFQH_l_.str.184:
.asciz	"respondsToSelector:"
LFQH_l_.str.185:
.asciz	"isKindOfClass:"
LFQH_l_.str.186:
.asciz	"backgroundColor"
LFQH_l_.str.187:
.asciz	"CATransaction"
LFQH_l_.str.188:
.asciz	"begin"
LFQH_l_.str.189:
.asciz	"setDisableActions:"
LFQH_l_.str.190:
.asciz	"clipsToBounds"
LFQH_l_.str.191:
.asciz	"isOpaque"
LFQH_l_.str.192:
.asciz	"frame"
LFQH_l_.str.193:
.asciz	"contentView"
LFQH_l_.str.194:
.asciz	"insertSubview:atIndex:"
LFQH_l_.str.195:
.asciz	"commit"
LFQH_l_.str.196:
.asciz	"initWithEffect:"
LFQH_l_.str.197:
.asciz	"setUserInteractionEnabled:"
LFQH_l_.str.198:
.asciz	"setAccessibilityElementsHidden:"
LFQH_l_.str.199:
.asciz	"setIsAccessibilityElement:"
LFQH_l_.str.200:
.asciz	"setOpaque:"
LFQH_l_.str.201:
.asciz	"setClipsToBounds:"
LFQH_l_.str.202:
.asciz	"layer"
LFQH_l_.str.203:
.asciz	"cornerRadius"
LFQH_l_.str.204:
.asciz	"doubleValue"
LFQH_l_.str.205:
.asciz	"NSNumber"
LFQH_l_.str.206:
.asciz	"numberWithDouble:"
LFQH_l_.str.207:
.asciz	"setCornerRadius:"
LFQH_l_.str.208:
.asciz	"NSProcessInfo"
LFQH_l_.str.209:
.asciz	"processInfo"
LFQH_l_.str.210:
.asciz	"systemUptime"
LFQH_l_.str.211:
.asciz	"NSMutableDictionary"
LFQH_l_.str.212:
.asciz	"dictionary"
LFQH_l_.str.213:
.asciz	"role"
LFQH_l_.str.214:
.asciz	"hostFrame"
LFQH_l_.str.215:
.asciz	"hostBounds"
LFQH_l_.str.216:
.asciz	"glassRect"
LFQH_l_.str.217:
.asciz	"subviews"
LFQH_l_.str.218:
.asciz	"array"
LFQH_l_.str.219:
.asciz	"childCount"
LFQH_l_.str.220:
.asciz	"childrenTruncated"
LFQH_l_.str.221:
.asciz	"addObject:"
LFQH_l_.str.222:
.asciz	"childFrames"
LFQH_l_.str.223:
.asciz	"headerLayout173"
LFQH_l_.str.224:
.asciz	"CGRectValue"
LFQH_l_.str.225:
.asciz	"NSValue"
LFQH_l_.str.226:
.asciz	"valueWithCGRect:"
LFQH_l_.str.227:
.asciz	"setObject:forKey:"
LFQH_l_.str.228:
.asciz	"UIButton"
LFQH_l_.str.229:
.asciz	"imageView"
LFQH_l_.str.230:
.asciz	"isHidden"
LFQH_l_.str.231:
.asciz	"new"
LFQH_l_.str.232:
.asciz	"setConfiguration:"
LFQH_l_.str.233:
.asciz	"isEnabled"
LFQH_l_.str.234:
.asciz	"isSelected"
LFQH_l_.str.235:
.asciz	"isHighlighted"
LFQH_l_.str.236:
.asciz	"insertSubview:belowSubview:"
LFQH_l_.str.237:
.asciz	"setEnabled:"
LFQH_l_.str.238:
.asciz	"setSelected:"
LFQH_l_.str.239:
.asciz	"setHighlighted:"
LFQH_l_.str.240:
.asciz	"removeFromSuperview"
LFQH_l_.str.241:
.asciz	"convertRect:toView:"
LFQH_l_.str.242:
.asciz	"btd_hitTestEdgeInsets"
LFQH_l_.str.243:
.asciz	"setBtd_hitTestEdgeInsets:"
LFQH_l_.str.244:
.asciz	"FQXGlassBackground167"
LFQH_l_.str.245:
.asciz	"fqx167_down:"
LFQH_l_.str.246:
.asciz	"fqx167_up:"
LFQH_l_.str.247:
.asciz	"addTarget:action:forControlEvents:"
LFQH_l_.str.248:
.asciz	"removeTarget:action:forControlEvents:"
LFQH_l_.str.249:
.asciz	"window"
LFQH_l_.str.250:
.asciz	"arrayWithObjects:count:"
LFQH_l_.str.251:
.asciz	"imageRect"
LFQH_l_.str.252:
.asciz	"windowRect"
LFQH_l_.str.253:
.asciz	"controlLayout167"
LFQH_l_.str.254:
.asciz	"readerBack"
LFQH_l_.str.255:
.asciz	"readerMore"
LFQH_l_.str.256:
.asciz	"readerSearch"
LFQH_l_.str.257:
.asciz	"readerDownload"
LFQH_l_.str.258:
.asciz	"readerCommunity"
LFQH_l_.str.259:
.asciz	"readerChapter"
LFQH_l_.str.260:
.asciz	"readerShelf"
LFQH_l_.str.261:
.asciz	"shelfSearch"
LFQH_l_.str.262:
.asciz	"shelfMore"
LFQH_l_.str.263:
.asciz	"icon"
LFQH_l_.str.264:
.asciz	"objectAtIndex:"
LFQH_l_.str.265:
.asciz	"FQReaderNavigationBarMoreBtnInsertObject"
LFQH_l_.str.266:
.asciz	"FQReaderNavigationBarSearchBtnInsertObject"
LFQH_l_.str.267:
.asciz	"SSReaderNavigationBarDownloadBtnInsertObject"
LFQH_l_.str.268:
.asciz	"SSReaderNavigationBarBookShelfBtnInsertObject"
LFQH_l_.str.269:
.asciz	"SSReaderNavigationBarCommunitySwitchBtnInsertObject"
LFQH_l_.str.270:
.asciz	"numberWithLongLong:"
LFQH_l_.str.271:
.asciz	"numberWithBool:"
LFQH_l_.str.272:
.asciz	"text"
LFQH_l_.str.273:
.asciz	"\345\220\254"
LFQH_l_.str.274:
.asciz	"NSUserDefaults"
LFQH_l_.str.275:
.asciz	"standardUserDefaults"
LFQH_l_.str.276:
.asciz	"FanqieAdBlock.GlassDisabled.1"
LFQH_l_.str.277:
.asciz	"integerForKey:"
LFQH_l_.str.278:
.asciz	"item"
LFQH_l_.str.279:
.asciz	"FQReaderSaaSBottomToolItem"
LFQH_l_.str.280:
.asciz	"type"
LFQH_l_.str.281:
.asciz	"SSMyUserMiniGameEntranceCellModel"
LFQH_l_.str.282:
.asciz	"SSMyUserShopAndMiniGameEntranceCellModel"
LFQH_l_.str.283:
.asciz	"event"
LFQH_l_.str.284:
.asciz	"pageAdRemoved174"
LFQH_l_.str.285:
.asciz	"ownerClass"
LFQH_l_.str.286:
.asciz	"source"
LFQH_l_.str.287:
.asciz	"serverGameModel"
LFQH_l_.str.288:
.asciz	"action"
LFQH_l_.str.289:
.asciz	"pageAdFilter174"
LFQH_l_.str.290:
.asciz	"functionCell"
LFQH_l_.str.291:
.asciz	"headerView"
LFQH_l_.str.292:
.asciz	"isFiltering"
LFQH_l_.str.293:
.asciz	"editButton"
LFQH_l_.str.294:
.asciz	"secondaryView"
LFQH_l_.str.295:
.asciz	"layoutEditButton"
LFQH_l_.str.296:
.asciz	"showReadTimeView"
LFQH_l_.str.297:
.asciz	"setNeedsLayout"
LFQH_l_.str.298:
.asciz	"collectionView"
LFQH_l_.str.299:
.asciz	"collectionViewLayout"
LFQH_l_.str.300:
.asciz	"invalidateLayout"
LFQH_l_.str.301:
.asciz	"delegate"
LFQH_l_.str.302:
.asciz	"SSBookShelf525ViewController"
LFQH_l_.str.303:
.asciz	"currentTabVC"
LFQH_l_.str.304:
.asciz	"headerRightView"
LFQH_l_.str.305:
.asciz	"tabSelectView"
LFQH_l_.str.306:
.asciz	"visibleCells"
LFQH_l_.str.307:
.asciz	"FanqieXBottomToggles176"
LFQH_l_.str.308:
.asciz	"NSObject"
LFQH_l_.str.309:
.asciz	"fqx176_toggle:"
LFQH_l_.str.310:
.asciz	"fqx176_recoverOptions:"
LFQH_l_.str.311:
.asciz	"gestureRecognizer:shouldReceiveTouch:"
LFQH_l_.str.312:
.asciz	"B32@0:8@16@24"
LFQH_l_.str.313:
.asciz	"tag"
LFQH_l_.str.314:
.asciz	"isOn"
LFQH_l_.str.315:
.asciz	"typeArray"
LFQH_l_.str.316:
.asciz	"setOn:animated:"
LFQH_l_.str.317:
.asciz	"refreshTabBar"
LFQH_l_.str.318:
.asciz	"bottomEntryToggle176"
LFQH_l_.str.319:
.asciz	"entry"
LFQH_l_.str.320:
.asciz	"enabled"
LFQH_l_.str.321:
.asciz	"setBool:forKey:"
LFQH_l_.str.322:
.asciz	"allObjects"
LFQH_l_.str.323:
.asciz	"FanqieXMineBenefits"
LFQH_l_.str.324:
.asciz	"UIApplication"
LFQH_l_.str.325:
.asciz	"sharedApplication"
LFQH_l_.str.326:
.asciz	"keyWindow"
LFQH_l_.str.327:
.asciz	"rootViewController"
LFQH_l_.str.328:
.asciz	"windows"
LFQH_l_.str.329:
.asciz	"children"
LFQH_l_.str.330:
.asciz	"intValue"
LFQH_l_.str.331:
.asciz	"titleStrWithType:"
LFQH_l_.str.332:
.asciz	"\347\237\255\345\211\247"
LFQH_l_.str.333:
.asciz	"\345\225\206\345\237\216"
LFQH_l_.str.334:
.asciz	"customTabBar"
LFQH_l_.str.335:
.asciz	"view"
LFQH_l_.str.336:
.asciz	"removeGestureRecognizer:"
LFQH_l_.str.337:
.asciz	"NSHashTable"
LFQH_l_.str.338:
.asciz	"weakObjectsHashTable"
LFQH_l_.str.339:
.asciz	"UILongPressGestureRecognizer"
LFQH_l_.str.340:
.asciz	"initWithTarget:action:"
LFQH_l_.str.341:
.asciz	"setMinimumPressDuration:"
LFQH_l_.str.342:
.asciz	"setDelegate:"
LFQH_l_.str.343:
.asciz	"addGestureRecognizer:"
LFQH_l_.str.344:
.asciz	"state"
LFQH_l_.str.345:
.asciz	"presentedViewController"
LFQH_l_.str.346:
.asciz	"fqab_openMenu"
LFQH_l_.str.347:
.asciz	"SSSettingViewController"
LFQH_l_.str.348:
.asciz	"anyObject"
LFQH_l_.str.349:
.asciz	"locationInView:"
LFQH_l_.str.350:
.asciz	"UISwitch"
LFQH_l_.str.351:
.asciz	"setTag:"
LFQH_l_.str.352:
.asciz	"setAccessibilityLabel:"
LFQH_l_.str.353:
.asciz	"\345\272\225\346\240\217\346\230\276\347\244\272\357\274\232\344\271\246\345\237\216"
LFQH_l_.str.354:
.asciz	"\345\272\225\346\240\217\346\230\276\347\244\272\357\274\232\347\237\255\345\211\247"
LFQH_l_.str.355:
.asciz	"\345\272\225\346\240\217\346\230\276\347\244\272\357\274\232\344\271\246\346\236\266"
LFQH_l_.str.356:
.asciz	"\345\272\225\346\240\217\346\230\276\347\244\272\357\274\232\346\210\221\347\232\204"
LFQH_l_.str.357:
.asciz	"\345\272\225\346\240\217\346\230\276\347\244\272\357\274\232\345\225\206\345\237\216"
LFQH_l_.str.358:
.asciz	"\344\271\246\346\236\266\346\230\276\347\244\272\344\273\212\346\227\245\347\234\213\345\220\254\350\257\273\346\227\266\351\225\277"
LFQH_l_.str.359:
.asciz	"\346\210\221\347\232\204\346\230\276\347\244\272\351\207\221\345\270\201\344\270\216\347\246\217\345\210\251\345\215\241\347\211\207"
LFQH_l_.str.360:
.asciz	"\351\230\205\350\257\273\350\217\234\345\215\225\346\230\276\347\244\272\345\272\225\346\240\217\350\203\214\346\231\257"
LFQH_l_.str.361:
.asciz	"objectForKey:"
LFQH_l_.str.362:
.asciz	"FanqieX.BottomBookstore.1"
LFQH_l_.str.363:
.asciz	"FanqieX.BottomDrama.1"
LFQH_l_.str.364:
.asciz	"FanqieX.BottomBookshelf.1"
LFQH_l_.str.365:
.asciz	"FanqieX.BottomMine.1"
LFQH_l_.str.366:
.asciz	"FanqieX.BottomMall.1"
LFQH_l_.str.367:
.asciz	"FanqieX.ShelfReadingDuration.1"
LFQH_l_.str.368:
.asciz	"FanqieX.MineBenefitsCard.1"
LFQH_l_.str.369:
.asciz	"FanqieX.ReaderBottomBackground.1"
LFQH_l_.str.370:
.asciz	"cellSpacing"
LFQH_l_.str.371:
.asciz	"titleLabel"
LFQH_l_.str.372:
.asciz	"maskTitleLabel"
LFQH_l_.str.373:
.asciz	"systemOrangeColor"
LFQH_l_.str.374:
.asciz	"font"
LFQH_l_.str.375:
.asciz	"pointSize"
LFQH_l_.str.376:
.asciz	"fontWithSize:"
LFQH_l_.str.377:
.asciz	"nProgressView"
LFQH_l_.str.378:
.asciz	"tabBar"
LFQH_l_.str.379:
.asciz	"BDReaderViewContainer"
LFQH_l_.str.380:
.asciz	"horizonLineView"
LFQH_l_.str.381:
.asciz	"lineView"
LFQH_l_.str.382:
.asciz	"alpha"
LFQH_l_.str.383:
.asciz	"setAlpha:"
LFQH_l_.str.384:
.asciz	"itemViews"
LFQH_l_.str.385:
.asciz	"readerBottomTool"
LFQH_l_.str.386:
.asciz	"FQXReaderCatalogTap"
LFQH_l_.str.387:
.asciz	"fqx_catalogTapped:"
LFQH_l_.str.388:
.asciz	"UITapGestureRecognizer"
LFQH_l_.str.389:
.asciz	"setCancelsTouchesInView:"
LFQH_l_.str.390:
.asciz	"onBtnClick:"
LFQH_l_.str.391:
.asciz	"leftBtn"
LFQH_l_.str.392:
.asciz	"rightBtn"
LFQH_l_.str.393:
.asciz	"slider"
LFQH_l_.str.394:
.asciz	"BDReaderNewSlider"
LFQH_l_.str.395:
.asciz	"trackView"
LFQH_l_.str.396:
.asciz	"UIImageView"
LFQH_l_.str.397:
.asciz	"readerProgressTrack"
LFQH_l_.str.398:
.asciz	"giftButton"
LFQH_l_.str.399:
.asciz	"model"
LFQH_l_.str.400:
.asciz	"displayMode"
LFQH_l_.str.401:
.asciz	"activeEntranceView"
LFQH_l_.str.402:
.asciz	"contentBackgroundView"
LFQH_l_.str.403:
.asciz	"customBackgroundView"
LFQH_l_.str.404:
.asciz	"SSReaderChapterEndCombineContainerView"
LFQH_l_.str.405:
.asciz	"SSBookShelfFilterMixRowCollectionView"
LFQH_l_.str.406:
.asciz	"isSelect"
LFQH_l_.str.407:
.asciz	"filterButton"
LFQH_l_.str.408:
.asciz	"scanQRCodeView"
LFQH_l_.str.409:
.asciz	"darkModeImageView"
LFQH_l_.str.410:
.asciz	"sideBarButtonView"
LFQH_l_.str.411:
.asciz	"SSMyUser621FunctionEntryItemCell"
LFQH_l_.str.412:
.asciz	"SSMyUserShortcutCell"
LFQH_l_.str.413:
.asciz	"SSMyUserCollectionView1Cell"
LFQH_l_.str.414:
.asciz	"productImage"
LFQH_l_.str.415:
.asciz	"image"
LFQH_l_.str.416:
.asciz	"functionType"
LFQH_l_.str.417:
.asciz	"label"
LFQH_l_.str.418:
.asciz	"SSMineEcomEntranceData"
LFQH_l_.str.419:
.asciz	"entranceType"
LFQH_l_.str.420:
.asciz	"mutableCopy"
LFQH_l_.str.421:
.asciz	"autorelease"
LFQH_l_.str.422:
.asciz	"removeObjectAtIndex:"
LFQH_l_.str.423:
.asciz	"filterConfiguredGameEntrances"
LFQH_l_.str.424:
.asciz	"filterStandaloneGameRows"
LFQH_l_.str.425:
.asciz	"businessStyle"
LFQH_l_.str.426:
.asciz	"isShowPersonalizedBar"
LFQH_l_.str.427:
.asciz	"isShowFriendView"
LFQH_l_.str.428:
.asciz	"fullGenreFilterButton"
LFQH_l_.str.429:
.asciz	"viewModel"
LFQH_l_.str.430:
.asciz	"section"
LFQH_l_.str.431:
.asciz	"sectionTypeAtIndex:"
LFQH_l_.str.432:
.asciz	"cellHeightWithFilterExposure:"
LFQH_l_.str.433:
.asciz	"filterClipView"
LFQH_l_.str.434:
.asciz	"showsFilterExposure"
LFQH_l_.str.435:
.asciz	"numberWithUnsignedInteger:"
LFQH_l_.str.436:
.asciz	"setTypeArray:"
LFQH_l_.str.437:
.asciz	"setTypeIndexMap:"
LFQH_l_.str.438:
.asciz	"speechBtn"
LFQH_l_.str.439:
.asciz	"imageForState:"
LFQH_l_.str.440:
.asciz	"tintColor"
LFQH_l_.str.441:
.asciz	"BDNovelNewAssetsGenerated"
LFQH_l_.str.442:
.asciz	"bdn_novelReaderListenButton"
LFQH_l_.str.443:
.asciz	"imageWithRenderingMode:"
LFQH_l_.str.444:
.asciz	"setImage:forState:"
LFQH_l_.str.445:
.asciz	"bookStoreVCContext"
