// Source SHA-256: 8ab350e2f3567a40b3de5358a910f55fb3e67c7b1b2cd46c70b9ccbcc5c37859
.p2align	2
LFQH_FQHHostBundle:
.cfi_startproc
stp	x20, x19, [sp, #-32]!
stp	x29, x30, [sp, #16]
add	x29, sp, #16
.cfi_def_cfa w29, 16
.cfi_offset w30, -8
.cfi_offset w29, -16
.cfi_offset w19, -24
.cfi_offset w20, -32
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
mov	x20, x0
mov	x0, x19
bl Lpatch + (0xa574 - PATCH_BASE)
mov	x0, x20
ldp	x29, x30, [sp, #16]
ldp	x20, x19, [sp], #32
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
LFQH_Lloh8:
adr x0, LFQH_l_.str.48
LFQH_Lloh9:
nop
bl Lpatch + (0xa5a4 - PATCH_BASE)
mov	x21, x0
LFQH_Lloh10:
adr x0, LFQH_l_.str.244
LFQH_Lloh11:
nop
bl Lpatch + (0xa5b0 - PATCH_BASE)
mov	x22, x0
LFQH_Lloh12:
adr x0, LFQH_l_.str.245
LFQH_Lloh13:
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
LFQH_Lloh14:
adr x0, LFQH_l_.str
LFQH_Lloh15:
nop
bl Lpatch + (0xa5b0 - PATCH_BASE)
mov	x20, x0
LFQH_Lloh16:
adr x0, LFQH_l_.str.1
LFQH_Lloh17:
nop
bl Lpatch + (0xa5a4 - PATCH_BASE)
mov	x1, x0
mov	x0, x20
bl Lpatch + (0xa5d4 - PATCH_BASE)
mov	x20, x0
LFQH_Lloh18:
adr x0, LFQH_l_.str.2
LFQH_Lloh19:
nop
bl Lpatch + (0xa5a4 - PATCH_BASE)
mov	x1, x0
mov	x0, x20
bl Lpatch + (0xa5d4 - PATCH_BASE)
LFQH_Lloh20:
adr x1, LFQH_l_.str.3
LFQH_Lloh21:
nop
bl	LFQH_Equal
cbz	w0, LFQH_LBB2_4
LFQH_Lloh22:
adr x0, LFQH_l_.str.4
LFQH_Lloh23:
nop
bl Lpatch + (0xa5a4 - PATCH_BASE)
mov	x21, x0
LFQH_Lloh24:
adr x0, LFQH_l_.str.244
LFQH_Lloh25:
nop
bl Lpatch + (0xa5b0 - PATCH_BASE)
mov	x22, x0
LFQH_Lloh26:
adr x0, LFQH_l_.str.245
LFQH_Lloh27:
nop
bl Lpatch + (0xa5a4 - PATCH_BASE)
mov	x1, x0
LFQH_Lloh28:
adr x2, LFQH_l_.str.5
LFQH_Lloh29:
nop
mov	x0, x22
bl Lpatch + (0xa5d4 - PATCH_BASE)
mov	x2, x0
mov	x0, x20
mov	x1, x21
bl Lpatch + (0xa5d4 - PATCH_BASE)
LFQH_Lloh30:
adr x1, LFQH_l_.str.6
LFQH_Lloh31:
nop
bl	LFQH_Equal
cbz	w0, LFQH_LBB2_4
LFQH_Lloh32:
adr x0, LFQH_l_.str.7
LFQH_Lloh33:
nop
bl Lpatch + (0xa5b0 - PATCH_BASE)
LFQH_Lloh34:
adr x1, LFQH_l_.str.8
LFQH_Lloh35:
nop
LFQH_Lloh36:
adr x2, LFQH_l_.str.9
LFQH_Lloh37:
nop
bl	LFQH_ClassABI
cbz	w0, LFQH_LBB2_4
LFQH_Lloh38:
adr x0, LFQH_l_.str.7
LFQH_Lloh39:
nop
bl Lpatch + (0xa5b0 - PATCH_BASE)
LFQH_Lloh40:
adr x1, LFQH_l_.str.10
LFQH_Lloh41:
nop
LFQH_Lloh42:
adr x2, LFQH_l_.str.11
LFQH_Lloh43:
nop
bl	LFQH_ClassABI
mov	x20, x0
b	LFQH_LBB2_5
LFQH_LBB2_4:
mov	w20, #0
LFQH_LBB2_5:
mov	x0, x19
bl Lpatch + (0xa574 - PATCH_BASE)
mov	x0, x20
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
LFQH_Lloh44:
adr x0, LFQH_l_.str.12
LFQH_Lloh45:
nop
bl Lpatch + (0xa5b0 - PATCH_BASE)
LFQH_Lloh46:
adr x1, LFQH_l_.str.13
LFQH_Lloh47:
nop
bl	LFQH_Responds
cbz	w0, LFQH_LBB3_4
LFQH_Lloh48:
adr x0, LFQH_l_.str.14
LFQH_Lloh49:
nop
bl Lpatch + (0xa5b0 - PATCH_BASE)
LFQH_Lloh50:
adr x1, LFQH_l_.str.15
LFQH_Lloh51:
nop
bl	LFQH_Responds
cbz	w0, LFQH_LBB3_4
LFQH_Lloh52:
adr x0, LFQH_l_.str.16
LFQH_Lloh53:
nop
bl Lpatch + (0xa5b0 - PATCH_BASE)
mov	x19, x0
LFQH_Lloh54:
adr x0, LFQH_l_.str.17
LFQH_Lloh55:
nop
bl Lpatch + (0xa5a4 - PATCH_BASE)
mov	x1, x0
mov	x0, x19
bl Lpatch + (0xa5f8 - PATCH_BASE)
cbz	x0, LFQH_LBB3_4
LFQH_Lloh56:
adr x0, LFQH_l_.str.12
LFQH_Lloh57:
nop
bl Lpatch + (0xa5b0 - PATCH_BASE)
mov	x19, x0
LFQH_Lloh58:
adr x0, LFQH_l_.str.18
LFQH_Lloh59:
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
LFQH_Lloh60:
adr x0, LFQH_l_.str.246
LFQH_Lloh61:
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
LFQH_Lloh62:
adr x1, LFQH_l_.str.19
LFQH_Lloh63:
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
LFQH_Lloh64:
adr x1, LFQH_l_.str.20
LFQH_Lloh65:
nop
mov	x0, x19
bl	LFQH_Get
cbz	x0, LFQH_LBB5_2
mov	x20, x0
mov	w26, #0
LFQH_Lloh66:
adr x21, LFQH_l_.str.247
LFQH_Lloh67:
nop
LFQH_Lloh68:
adr x22, LFQH_l_.str.21
LFQH_Lloh69:
nop
LFQH_Lloh70:
adr x23, LFQH_l_.str.20
LFQH_Lloh71:
nop
LFQH_Lloh72:
adr x24, LFQH_l_.str.22
LFQH_Lloh73:
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
LFQH_Lloh74:
adr x0, LFQH_l_.str.247
LFQH_Lloh75:
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
LFQH_Lloh76:
adr x1, LFQH_SurfaceKey
LFQH_Lloh77:
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
LFQH_Lloh78:
adr x1, LFQH_l_.str.23
LFQH_Lloh79:
nop
bl	LFQH_Kind
cbz	w0, LFQH_LBB10_2
LFQH_Lloh80:
adr x0, LFQH_l_.str.24
LFQH_Lloh81:
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
sub	sp, sp, #192
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
mov	x21, x1
mov.16b	v8, v3
mov.16b	v9, v2
mov.16b	v10, v1
mov.16b	v11, v0
mov	x19, x0
LFQH_Lloh82:
adr x1, LFQH_BusyKey
LFQH_Lloh83:
nop
bl Lpatch + (0xa628 - PATCH_BASE)
cbz	x0, LFQH_LBB11_2
ldp	x29, x30, [sp, #176]
ldp	x20, x19, [sp, #160]
ldp	x22, x21, [sp, #144]
ldp	x24, x23, [sp, #128]
ldp	x26, x25, [sp, #112]
ldp	x28, x27, [sp, #96]
ldp	d9, d8, [sp, #80]
ldp	d11, d10, [sp, #64]
ldp	d13, d12, [sp, #48]
add	sp, sp, #192
ret
LFQH_LBB11_2:
LFQH_Lloh84:
adr x1, LFQH_BusyKey
LFQH_Lloh85:
nop
mov	x0, x19
mov	x2, x19
mov	x3, #0
bl Lpatch + (0xa634 - PATCH_BASE)
LFQH_Lloh86:
adr x1, LFQH_SurfaceKey
LFQH_Lloh87:
nop
mov	x0, x19
bl Lpatch + (0xa628 - PATCH_BASE)
mov	x22, x0
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
mov	x1, x22
bl	LFQH_Restore
LFQH_LBB11_5:
LFQH_Lloh88:
adr x1, LFQH_BusyKey
LFQH_Lloh89:
nop
mov	x0, x19
mov	x2, #0
mov	x3, #0
ldp	x29, x30, [sp, #176]
ldp	x20, x19, [sp, #160]
ldp	x22, x21, [sp, #144]
ldp	x24, x23, [sp, #128]
ldp	x26, x25, [sp, #112]
ldp	x28, x27, [sp, #96]
ldp	d9, d8, [sp, #80]
ldp	d11, d10, [sp, #64]
ldp	d13, d12, [sp, #48]
add	sp, sp, #192
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
mov	x20, x22
cbnz	x22, LFQH_LBB11_12
bl	LFQH_NewGlassSurface
cbz	x0, LFQH_LBB11_5
mov	x20, x0
LFQH_Lloh90:
adr x0, LFQH_l_.str.88
LFQH_Lloh91:
nop
bl Lpatch + (0xa5a4 - PATCH_BASE)
mov	x1, x0
mov	x0, x20
mov	w2, #18
bl Lpatch + (0xa5d4 - PATCH_BASE)
LFQH_Lloh92:
adr x1, LFQH_SurfaceKey
LFQH_Lloh93:
nop
mov	x0, x19
mov	x2, x20
mov	w3, #1
bl Lpatch + (0xa634 - PATCH_BASE)
LFQH_Lloh94:
adr x0, LFQH_l_.str.55
LFQH_Lloh95:
nop
bl Lpatch + (0xa5a4 - PATCH_BASE)
mov	x1, x0
mov	x0, x20
bl Lpatch + (0xa5d4 - PATCH_BASE)
LFQH_LBB11_12:
LFQH_Lloh96:
adr x0, LFQH_l_.str.46
LFQH_Lloh97:
nop
bl Lpatch + (0xa5b0 - PATCH_BASE)
mov	x23, x0
LFQH_Lloh98:
adr x0, LFQH_l_.str.80
LFQH_Lloh99:
nop
bl Lpatch + (0xa5a4 - PATCH_BASE)
mov	x1, x0
mov	x0, x23
bl Lpatch + (0xa5d4 - PATCH_BASE)
mov	x23, x0
LFQH_Lloh100:
adr x0, LFQH_l_.str.248
LFQH_Lloh101:
nop
bl Lpatch + (0xa5a4 - PATCH_BASE)
mov	x1, x0
mov	x0, x20
bl Lpatch + (0xa5d4 - PATCH_BASE)
mov	x28, x0
LFQH_Lloh102:
adr x0, LFQH_l_.str.20
LFQH_Lloh103:
nop
bl Lpatch + (0xa5a4 - PATCH_BASE)
mov	x1, x0
mov	x0, x20
bl Lpatch + (0xa5d4 - PATCH_BASE)
str	x0, [sp, #32]
LFQH_Lloh104:
adr x0, LFQH_l_.str.249
LFQH_Lloh105:
nop
bl Lpatch + (0xa5a4 - PATCH_BASE)
mov	x1, x0
mov	x0, x20
bl Lpatch + (0xa5d4 - PATCH_BASE)
mov	w8, #1
str	w8, [sp, #44]
fcmp	d0, d11
b.ne	LFQH_LBB11_16
fcmp	d1, d10
b.ne	LFQH_LBB11_16
fcmp	d2, d9
b.ne	LFQH_LBB11_16
fcmp	d3, d8
cset	w8, ne
str	w8, [sp, #44]
LFQH_LBB11_16:
LFQH_Lloh106:
adr x0, LFQH_l_.str.250
LFQH_Lloh107:
nop
bl Lpatch + (0xa5a4 - PATCH_BASE)
mov	x1, x0
mov	x0, x20
bl Lpatch + (0xa5d4 - PATCH_BASE)
cmp	x0, x23
b.eq	LFQH_LBB11_18
mov	x24, x0
LFQH_Lloh108:
adr x0, LFQH_l_.str.48
LFQH_Lloh109:
nop
bl Lpatch + (0xa5a4 - PATCH_BASE)
mov	x1, x0
mov	x0, x24
mov	x2, x23
bl Lpatch + (0xa5d4 - PATCH_BASE)
cmp	w0, #0
cset	w8, eq
str	w8, [sp, #28]
b	LFQH_LBB11_19
LFQH_LBB11_18:
str	wzr, [sp, #28]
LFQH_LBB11_19:
LFQH_Lloh110:
adr x0, LFQH_l_.str.250
LFQH_Lloh111:
nop
bl Lpatch + (0xa5a4 - PATCH_BASE)
mov	x1, x0
mov	x0, x28
bl Lpatch + (0xa5d4 - PATCH_BASE)
cmp	x0, x23
b.eq	LFQH_LBB11_21
mov	x24, x0
LFQH_Lloh112:
adr x0, LFQH_l_.str.48
LFQH_Lloh113:
nop
bl Lpatch + (0xa5a4 - PATCH_BASE)
mov	x1, x0
mov	x0, x24
mov	x2, x23
bl Lpatch + (0xa5d4 - PATCH_BASE)
cmp	w0, #0
cset	w8, eq
str	w8, [sp, #24]
b	LFQH_LBB11_22
LFQH_LBB11_21:
str	wzr, [sp, #24]
LFQH_LBB11_22:
fmov	d12, xzr
cbz	w21, LFQH_LBB11_24
str	xzr, [sp, #8]
mov	w8, #0
mov	w27, #0
mov	w24, #0
mov	w25, #0
fmov	d13, xzr
mov	w26, #1
b	LFQH_LBB11_30
LFQH_LBB11_24:
LFQH_Lloh114:
adr x0, LFQH_l_.str.250
LFQH_Lloh115:
nop
bl Lpatch + (0xa5a4 - PATCH_BASE)
mov	x1, x0
mov	x0, x19
bl Lpatch + (0xa5d4 - PATCH_BASE)
cmp	x0, x23
str	x0, [sp, #8]
b.eq	LFQH_LBB11_26
mov	x24, x0
LFQH_Lloh116:
adr x0, LFQH_l_.str.48
LFQH_Lloh117:
nop
bl Lpatch + (0xa5a4 - PATCH_BASE)
mov	x1, x0
mov	x0, x24
mov	x2, x23
bl Lpatch + (0xa5d4 - PATCH_BASE)
cmp	w0, #0
cset	w25, eq
b	LFQH_LBB11_27
LFQH_LBB11_26:
mov	w25, #0
LFQH_LBB11_27:
LFQH_Lloh118:
adr x0, LFQH_l_.str.251
LFQH_Lloh119:
nop
bl Lpatch + (0xa5a4 - PATCH_BASE)
mov	x1, x0
mov	x0, x19
bl Lpatch + (0xa5d4 - PATCH_BASE)
mov	x27, x0
LFQH_Lloh120:
adr x0, LFQH_l_.str.252
LFQH_Lloh121:
nop
bl Lpatch + (0xa5a4 - PATCH_BASE)
mov	x1, x0
mov	x0, x19
bl Lpatch + (0xa5d4 - PATCH_BASE)
mov	x24, x0
LFQH_Lloh122:
adr x1, LFQH_HeaderKey
LFQH_Lloh123:
nop
mov	x0, x19
bl Lpatch + (0xa628 - PATCH_BASE)
cbz	x0, LFQH_LBB11_29
mov	x0, x19
bl	LFQH_Radius
mov.16b	v12, v0
mov	w26, #0
fcmp	d9, d8
fcsel	d0, d9, d8, mi
fmov	d1, #0.50000000
fmul	d13, d0, d1
mov	w8, #1
b	LFQH_LBB11_30
LFQH_LBB11_29:
mov	w8, #0
mov	w26, #1
fmov	d13, xzr
LFQH_LBB11_30:
str	x28, [sp, #16]
ldr	x9, [sp, #32]
cmp	x9, x19
cset	w9, ne
ldr	w10, [sp, #44]
ldr	w11, [sp, #28]
orr	w10, w10, w11
ldr	w11, [sp, #24]
orr	w10, w10, w11
orr	w9, w9, w10
tbnz	w9, #0, LFQH_LBB11_36
tbnz	w25, #0, LFQH_LBB11_36
cbnz	w24, LFQH_LBB11_36
cmp	w27, w8
b.ne	LFQH_LBB11_36
fcmp	d12, d13
b.ne	LFQH_LBB11_36
mov	x28, #0
b	LFQH_LBB11_37
LFQH_LBB11_36:
LFQH_Lloh124:
adr x0, LFQH_l_.str.253
LFQH_Lloh125:
nop
bl Lpatch + (0xa5b0 - PATCH_BASE)
mov	x28, x0
LFQH_Lloh126:
adr x0, LFQH_l_.str.254
LFQH_Lloh127:
nop
bl Lpatch + (0xa5a4 - PATCH_BASE)
mov	x1, x0
mov	x0, x28
bl Lpatch + (0xa5d4 - PATCH_BASE)
LFQH_Lloh128:
adr x0, LFQH_l_.str.255
LFQH_Lloh129:
nop
bl Lpatch + (0xa5a4 - PATCH_BASE)
mov	x1, x0
mov	x0, x28
mov	w2, #1
bl Lpatch + (0xa5d4 - PATCH_BASE)
LFQH_LBB11_37:
cbnz	w21, LFQH_LBB11_45
cmp	x22, #0
cset	w8, eq
orr	w8, w8, w25
tbz	w8, #0, LFQH_LBB11_40
LFQH_Lloh130:
adr x1, LFQH_BackgroundKey
LFQH_Lloh131:
nop
mov	x0, x19
ldr	x2, [sp, #8]
mov	w3, #1
bl Lpatch + (0xa634 - PATCH_BASE)
LFQH_LBB11_40:
mov	x0, x19
mov	x1, x27
mov	x2, x24
tbz	w26, #0, LFQH_LBB11_42
bl	LFQH_PrepareOwner
b	LFQH_LBB11_43
LFQH_LBB11_42:
mov.16b	v0, v12
mov.16b	v1, v13
bl	LFQH_PrepareHeaderOwner
LFQH_LBB11_43:
cbz	w25, LFQH_LBB11_45
LFQH_Lloh132:
adr x0, LFQH_l_.str.79
LFQH_Lloh133:
nop
bl Lpatch + (0xa5a4 - PATCH_BASE)
mov	x1, x0
mov	x0, x19
mov	x2, x23
bl Lpatch + (0xa5d4 - PATCH_BASE)
LFQH_LBB11_45:
ldr	w8, [sp, #44]
cbz	w8, LFQH_LBB11_47
LFQH_Lloh134:
adr x0, LFQH_l_.str.78
LFQH_Lloh135:
nop
bl Lpatch + (0xa5a4 - PATCH_BASE)
mov	x1, x0
mov	x0, x20
mov.16b	v0, v11
mov.16b	v1, v10
mov.16b	v2, v9
mov.16b	v3, v8
bl Lpatch + (0xa5d4 - PATCH_BASE)
LFQH_LBB11_47:
ldr	w8, [sp, #28]
cbz	w8, LFQH_LBB11_49
LFQH_Lloh136:
adr x0, LFQH_l_.str.79
LFQH_Lloh137:
nop
bl Lpatch + (0xa5a4 - PATCH_BASE)
mov	x1, x0
mov	x0, x20
mov	x2, x23
bl Lpatch + (0xa5d4 - PATCH_BASE)
LFQH_LBB11_49:
ldr	w8, [sp, #24]
cbz	w8, LFQH_LBB11_51
LFQH_Lloh138:
adr x0, LFQH_l_.str.79
LFQH_Lloh139:
nop
bl Lpatch + (0xa5a4 - PATCH_BASE)
mov	x1, x0
ldr	x0, [sp, #16]
mov	x2, x23
bl Lpatch + (0xa5d4 - PATCH_BASE)
LFQH_LBB11_51:
ldr	x8, [sp, #32]
cmp	x8, x19
b.eq	LFQH_LBB11_53
LFQH_Lloh140:
adr x0, LFQH_l_.str.256
LFQH_Lloh141:
nop
bl Lpatch + (0xa5a4 - PATCH_BASE)
mov	x1, x0
mov	x0, x19
mov	x2, x20
mov	x3, #0
bl Lpatch + (0xa5d4 - PATCH_BASE)
LFQH_LBB11_53:
cbz	x28, LFQH_LBB11_5
LFQH_Lloh142:
adr x0, LFQH_l_.str.257
LFQH_Lloh143:
nop
bl Lpatch + (0xa5a4 - PATCH_BASE)
mov	x1, x0
mov	x0, x28
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
LFQH_Lloh144:
adr x1, LFQH_l_.str.23
LFQH_Lloh145:
nop
bl	LFQH_Kind
cbz	w0, LFQH_LBB12_11
LFQH_Lloh146:
adr x1, LFQH_HeaderKey
LFQH_Lloh147:
nop
mov	x0, x19
bl Lpatch + (0xa628 - PATCH_BASE)
cbnz	x0, LFQH_LBB12_3
LFQH_Lloh148:
adr x1, LFQH_l_.str.25
LFQH_Lloh149:
nop
mov	x0, x19
bl	LFQH_Kind
LFQH_Lloh150:
adr x8, LFQH_l_.str.26
LFQH_Lloh151:
nop
LFQH_Lloh152:
adr x9, LFQH_l_.str.27
LFQH_Lloh153:
nop
cmp	w0, #0
csel	x20, x9, x8, eq
LFQH_Lloh154:
adr x0, LFQH_l_.str.244
LFQH_Lloh155:
nop
bl Lpatch + (0xa5b0 - PATCH_BASE)
mov	x21, x0
LFQH_Lloh156:
adr x0, LFQH_l_.str.245
LFQH_Lloh157:
nop
bl Lpatch + (0xa5a4 - PATCH_BASE)
mov	x1, x0
mov	x0, x21
mov	x2, x20
bl Lpatch + (0xa5d4 - PATCH_BASE)
mov	x2, x0
LFQH_Lloh158:
adr x1, LFQH_HeaderKey
LFQH_Lloh159:
nop
mov	x0, x19
mov	w3, #1
bl Lpatch + (0xa634 - PATCH_BASE)
LFQH_LBB12_3:
mov	x0, x19
bl	LFQH_FQHApply
LFQH_Lloh160:
adr x1, LFQH_SurfaceKey
LFQH_Lloh161:
nop
mov	x0, x19
bl Lpatch + (0xa628 - PATCH_BASE)
cbz	x0, LFQH_LBB12_11
LFQH_Lloh162:
adr x0, LFQH_l_.str.24
LFQH_Lloh163:
nop
bl Lpatch + (0xa5a4 - PATCH_BASE)
mov	x1, x0
mov	x0, x19
bl Lpatch + (0xa5d4 - PATCH_BASE)
mov.16b	v8, v0
mov.16b	v9, v1
mov.16b	v10, v2
mov.16b	v11, v3
LFQH_Lloh164:
adr x1, LFQH_HeaderLogKey
LFQH_Lloh165:
nop
mov	x0, x19
bl Lpatch + (0xa628 - PATCH_BASE)
cbz	x0, LFQH_LBB12_9
mov	x20, x0
LFQH_Lloh166:
adr x0, LFQH_l_.str.286
LFQH_Lloh167:
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
LFQH_Lloh168:
adr x0, LFQH_l_.str.270
LFQH_Lloh169:
nop
bl Lpatch + (0xa5b0 - PATCH_BASE)
mov	x20, x0
LFQH_Lloh170:
adr x0, LFQH_l_.str.271
LFQH_Lloh171:
nop
bl Lpatch + (0xa5a4 - PATCH_BASE)
mov	x1, x0
mov	x0, x20
bl Lpatch + (0xa5d4 - PATCH_BASE)
mov	x20, x0
LFQH_Lloh172:
adr x0, LFQH_l_.str.272
LFQH_Lloh173:
nop
bl Lpatch + (0xa5a4 - PATCH_BASE)
mov	x1, x0
mov	x0, x20
bl Lpatch + (0xa5d4 - PATCH_BASE)
mov.16b	v12, v0
LFQH_Lloh174:
adr x1, LFQH_HeaderLogTimeKey
LFQH_Lloh175:
nop
mov	x0, x19
bl Lpatch + (0xa628 - PATCH_BASE)
cbz	x0, LFQH_LBB12_12
mov	x20, x0
LFQH_Lloh176:
adr x0, LFQH_l_.str.266
LFQH_Lloh177:
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
LFQH_Lloh178:
adr x0, LFQH_l_.str.287
LFQH_Lloh179:
nop
bl Lpatch + (0xa5b0 - PATCH_BASE)
mov	x20, x0
LFQH_Lloh180:
adr x0, LFQH_l_.str.288
LFQH_Lloh181:
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
LFQH_Lloh182:
adr x1, LFQH_HeaderLogKey
LFQH_Lloh183:
nop
mov	x0, x19
mov	w3, #1
bl Lpatch + (0xa634 - PATCH_BASE)
LFQH_Lloh184:
adr x21, LFQH_l_.str.267
LFQH_Lloh185:
nop
mov	x0, x21
bl Lpatch + (0xa5b0 - PATCH_BASE)
mov	x20, x0
LFQH_Lloh186:
adr x22, LFQH_l_.str.268
LFQH_Lloh187:
nop
mov	x0, x22
bl Lpatch + (0xa5a4 - PATCH_BASE)
mov	x1, x0
mov	x0, x20
mov.16b	v0, v12
bl Lpatch + (0xa5d4 - PATCH_BASE)
mov	x2, x0
LFQH_Lloh188:
adr x1, LFQH_HeaderLogTimeKey
LFQH_Lloh189:
nop
mov	x0, x19
mov	w3, #1
bl Lpatch + (0xa634 - PATCH_BASE)
LFQH_Lloh190:
adr x0, LFQH_l_.str.273
LFQH_Lloh191:
nop
bl Lpatch + (0xa5b0 - PATCH_BASE)
mov	x20, x0
LFQH_Lloh192:
adr x0, LFQH_l_.str.274
LFQH_Lloh193:
nop
bl Lpatch + (0xa5a4 - PATCH_BASE)
mov	x1, x0
mov	x0, x20
bl Lpatch + (0xa5d4 - PATCH_BASE)
mov	x20, x0
LFQH_Lloh194:
adr x1, LFQH_HeaderKey
LFQH_Lloh195:
nop
mov	x0, x19
bl Lpatch + (0xa628 - PATCH_BASE)
mov	x2, x0
LFQH_Lloh196:
adr x1, LFQH_l_.str.275
LFQH_Lloh197:
nop
mov	x0, x20
bl	LFQH_Put
LFQH_Lloh198:
adr x23, LFQH_l_.str.249
LFQH_Lloh199:
nop
mov	x0, x23
bl Lpatch + (0xa5a4 - PATCH_BASE)
mov	x1, x0
mov	x0, x19
bl Lpatch + (0xa5d4 - PATCH_BASE)
bl	LFQH_RectArray
mov	x2, x0
LFQH_Lloh200:
adr x1, LFQH_l_.str.276
LFQH_Lloh201:
nop
mov	x0, x20
bl	LFQH_Put
mov.16b	v0, v8
mov.16b	v1, v9
mov.16b	v2, v10
mov.16b	v3, v11
bl	LFQH_RectArray
mov	x2, x0
LFQH_Lloh202:
adr x1, LFQH_l_.str.277
LFQH_Lloh203:
nop
mov	x0, x20
bl	LFQH_Put
LFQH_Lloh204:
adr x1, LFQH_SurfaceKey
LFQH_Lloh205:
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
LFQH_Lloh206:
adr x1, LFQH_l_.str.278
LFQH_Lloh207:
nop
mov	x0, x20
bl	LFQH_Put
LFQH_Lloh208:
adr x23, LFQH_l_.str.251
LFQH_Lloh209:
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
LFQH_Lloh210:
adr x24, LFQH_l_.str.334
LFQH_Lloh211:
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
LFQH_Lloh212:
adr x0, LFQH_l_.str.263
LFQH_Lloh213:
nop
bl Lpatch + (0xa5a4 - PATCH_BASE)
mov	x1, x0
mov	x0, x19
bl Lpatch + (0xa5d4 - PATCH_BASE)
mov	x23, x0
LFQH_Lloh214:
adr x25, LFQH_l_.str.264
LFQH_Lloh215:
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
LFQH_Lloh216:
adr x1, LFQH_l_.str.279
LFQH_Lloh217:
nop
mov	x0, x19
bl	LFQH_Get
mov	x19, x0
LFQH_Lloh218:
adr x0, LFQH_l_.str.70
LFQH_Lloh219:
nop
bl Lpatch + (0xa5b0 - PATCH_BASE)
mov	x23, x0
LFQH_Lloh220:
adr x0, LFQH_l_.str.280
LFQH_Lloh221:
nop
bl Lpatch + (0xa5a4 - PATCH_BASE)
mov	x1, x0
mov	x0, x23
bl Lpatch + (0xa5d4 - PATCH_BASE)
mov	x23, x0
LFQH_Lloh222:
adr x0, LFQH_l_.str.34
LFQH_Lloh223:
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
LFQH_Lloh224:
adr x1, LFQH_l_.str.281
LFQH_Lloh225:
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
LFQH_Lloh226:
adr x1, LFQH_l_.str.282
LFQH_Lloh227:
nop
mov	x0, x20
bl	LFQH_Put
cbz	x25, LFQH_LBB12_15
mov	x21, #0
LFQH_Lloh228:
adr x22, LFQH_l_.str.283
LFQH_Lloh229:
nop
LFQH_Lloh230:
adr x24, LFQH_l_.str.327
LFQH_Lloh231:
nop
LFQH_Lloh232:
adr x25, LFQH_l_.str.249
LFQH_Lloh233:
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
LFQH_Lloh234:
adr x1, LFQH_l_.str.284
LFQH_Lloh235:
nop
mov	x0, x20
mov	x2, x23
bl	LFQH_Put
LFQH_Lloh236:
adr x0, LFQH_l_.str.285
LFQH_Lloh237:
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
LFQH_Lloh238:
adr x0, LFQH_l_.str.28
LFQH_Lloh239:
nop
bl Lpatch + (0xa5b0 - PATCH_BASE)
LFQH_Lloh240:
adr x1, LFQH_l_.str.29
LFQH_Lloh241:
nop
ldp	x29, x30, [sp], #16
b	LFQH_Responds
.cfi_endproc
.p2align	2
LFQH_FQHIconGlass:
.cfi_startproc
LFQH_Lloh242:
adr x1, LFQH_IconGlassKey
LFQH_Lloh243:
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
LFQH_Lloh244:
adr x1, LFQH_l_.str.23
LFQH_Lloh245:
nop
bl	LFQH_Kind
cbz	w0, LFQH_LBB18_2
LFQH_Lloh246:
adr x1, LFQH_BusyKey
LFQH_Lloh247:
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
LFQH_Lloh248:
adr x1, LFQH_BusyKey
LFQH_Lloh249:
nop
mov	x0, x19
mov	x2, x19
mov	x3, #0
bl Lpatch + (0xa634 - PATCH_BASE)
LFQH_Lloh250:
adr x1, LFQH_IconGlassKey
LFQH_Lloh251:
nop
mov	x0, x19
bl Lpatch + (0xa628 - PATCH_BASE)
mov	x21, x0
LFQH_Lloh252:
adr x0, LFQH_l_.str.24
LFQH_Lloh253:
nop
bl Lpatch + (0xa5a4 - PATCH_BASE)
mov	x1, x0
mov	x0, x19
bl Lpatch + (0xa5d4 - PATCH_BASE)
mov.16b	v12, v0
mov.16b	v13, v1
mov.16b	v14, v2
mov.16b	v15, v3
bl	LFQH_Enabled
cbz	w0, LFQH_LBB18_6
LFQH_Lloh254:
adr x0, LFQH_l_.str.28
LFQH_Lloh255:
nop
bl Lpatch + (0xa5b0 - PATCH_BASE)
LFQH_Lloh256:
adr x1, LFQH_l_.str.29
LFQH_Lloh257:
nop
bl	LFQH_Responds
cbz	w0, LFQH_LBB18_6
fmov	x8, d12
fmov	x9, d13
fmov	x10, d14
ubfx	x8, x8, #52, #11
ubfx	x9, x9, #52, #11
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
LFQH_Lloh258:
adr x1, LFQH_BusyKey
LFQH_Lloh259:
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
fmov	x8, d15
ubfx	x8, x8, #52, #11
cmp	x8, #2046
b.hi	LFQH_LBB18_6
fcmp	d14, #0.0
b.le	LFQH_LBB18_6
fcmp	d15, #0.0
b.le	LFQH_LBB18_6
LFQH_Lloh260:
adr x1, LFQH_l_.str.290
LFQH_Lloh261:
nop
mov	x0, x19
bl	LFQH_Kind
cbz	w0, LFQH_LBB18_17
LFQH_Lloh262:
adr x1, LFQH_l_.str.291
LFQH_Lloh263:
nop
mov	x0, x19
bl	LFQH_Get
mov	x22, x0
cbz	x0, LFQH_LBB18_18
mov	w24, #0
LFQH_Lloh264:
adr x23, LFQH_l_.str.20
LFQH_Lloh265:
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
LFQH_Lloh266:
adr x0, LFQH_l_.str.292
LFQH_Lloh267:
nop
bl Lpatch + (0xa5a4 - PATCH_BASE)
mov	x1, x0
mov	x0, x22
bl Lpatch + (0xa5d4 - PATCH_BASE)
cbz	w0, LFQH_LBB18_65
LFQH_LBB18_20:
mov	w8, #1
LFQH_LBB18_21:
stp	d13, d12, [sp, #88]
stp	d15, d14, [sp, #72]
LFQH_LBB18_22:
sub	w26, w20, #9
cmp	w20, #2
ccmp	w26, #2, #0, ne
csel	w8, wzr, w8, hs
cbz	w8, LFQH_LBB18_43
LFQH_Lloh268:
adr x1, LFQH_GlyphViewKey
LFQH_Lloh269:
nop
mov	x0, x19
bl Lpatch + (0xa628 - PATCH_BASE)
mov	x23, x0
cmp	x0, x22
b.eq	LFQH_LBB18_25
mov	x0, x19
bl	LFQH_RestoreGlyph
LFQH_LBB18_25:
LFQH_Lloh270:
adr x0, LFQH_l_.str.249
LFQH_Lloh271:
nop
bl Lpatch + (0xa5a4 - PATCH_BASE)
mov	x1, x0
mov	x0, x22
bl Lpatch + (0xa5d4 - PATCH_BASE)
mov.16b	v8, v0
mov.16b	v9, v1
mov.16b	v10, v2
mov.16b	v11, v3
LFQH_Lloh272:
adr x1, LFQH_GlyphOriginalKey
LFQH_Lloh273:
nop
mov	x0, x22
bl Lpatch + (0xa628 - PATCH_BASE)
mov	x25, x0
LFQH_Lloh274:
adr x1, LFQH_GlyphAppliedKey
LFQH_Lloh275:
nop
mov	x0, x22
bl Lpatch + (0xa628 - PATCH_BASE)
mov	x24, x0
cbz	x0, LFQH_LBB18_31
LFQH_Lloh276:
adr x0, LFQH_l_.str.286
LFQH_Lloh277:
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
ldr	d1, [sp, #32]
fcmp	d9, d1
b.ne	LFQH_LBB18_32
ldr	d0, [sp, #24]
fcmp	d10, d0
b.ne	LFQH_LBB18_32
ldr	d0, [sp, #16]
fcmp	d11, d0
b.ne	LFQH_LBB18_32
b	LFQH_LBB18_33
LFQH_LBB18_31:
fmov	d0, xzr
stp	d0, d0, [sp, #8]
stp	d0, d0, [sp, #24]
LFQH_LBB18_32:
mov.16b	v0, v8
mov.16b	v1, v9
mov.16b	v2, v10
mov.16b	v3, v11
bl	LFQH_RectBox
mov	x25, x0
LFQH_Lloh278:
adr x1, LFQH_GlyphOriginalKey
LFQH_Lloh279:
nop
mov	x0, x22
mov	x2, x25
mov	w3, #1
bl Lpatch + (0xa634 - PATCH_BASE)
LFQH_LBB18_33:
stp	d11, d10, [sp, #40]
stp	d9, d8, [sp, #56]
LFQH_Lloh280:
adr x0, LFQH_l_.str.286
LFQH_Lloh281:
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
ldp	d0, d1, [sp, #56]
fcmp	d1, d8
fccmp	d0, d11, #0, eq
ldp	d0, d1, [sp, #40]
fccmp	d1, d9, #0, eq
fccmp	d0, d10, #0, eq
b.eq	LFQH_LBB18_38
LFQH_Lloh282:
adr x0, LFQH_l_.str.78
LFQH_Lloh283:
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
LFQH_Lloh284:
adr x1, LFQH_GlyphAppliedKey
LFQH_Lloh285:
nop
mov	x0, x22
mov	w3, #1
bl Lpatch + (0xa634 - PATCH_BASE)
LFQH_LBB18_41:
cmp	x23, x22
b.eq	LFQH_LBB18_43
LFQH_Lloh286:
adr x1, LFQH_GlyphViewKey
LFQH_Lloh287:
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
LFQH_Lloh288:
adr x1, LFQH_l_.str.36
LFQH_Lloh289:
nop
mov	x0, x19
bl	LFQH_Kind
cbz	w0, LFQH_LBB18_47
LFQH_Lloh290:
adr x0, LFQH_l_.str.20
LFQH_Lloh291:
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
LFQH_Lloh292:
adr x0, LFQH_l_.str.292
LFQH_Lloh293:
nop
bl Lpatch + (0xa5a4 - PATCH_BASE)
mov	x1, x0
mov	x0, x19
bl Lpatch + (0xa5d4 - PATCH_BASE)
cbnz	w0, LFQH_LBB18_6
fmov	d0, #-6.00000000
fadd	d8, d12, d0
fmov	d0, #-5.00000000
fadd	d9, d13, d0
fmov	d0, #12.00000000
fadd	d11, d14, d0
fmov	d0, #10.00000000
fadd	d10, d15, d0
b	LFQH_LBB18_56
LFQH_LBB18_53:
cmp	w20, #7
b.ne	LFQH_LBB18_55
fmov	d0, #6.00000000
fadd	d0, d15, d0
fmov	d1, #30.00000000
fmaxnm	d10, d0, d1
fmov	d0, #-6.00000000
fadd	d8, d12, d0
fsub	d0, d15, d10
fmov	d1, #0.50000000
fmul	d0, d0, d1
fadd	d9, d13, d0
fmov	d0, #12.00000000
fadd	d11, d14, d0
b	LFQH_LBB18_56
LFQH_LBB18_55:
fmov	d0, #0.50000000
fmul	d1, d14, d0
fadd	d1, d12, d1
ucvtf	d2, w24
fadd	d1, d1, d2
ucvtf	d2, w25
fmul	d0, d15, d0
fsub	d1, d1, d2
ucvtf	d2, w23, #1
fadd	d0, d13, d0
ucvtf	d11, w23
fsub	d8, d1, d2
fsub	d9, d0, d2
mov.16b	v10, v11
LFQH_LBB18_56:
mov.16b	v0, v8
mov.16b	v1, v9
mov.16b	v2, v11
mov.16b	v3, v10
bl	LFQH_VisibleRect
tbz	w0, #0, LFQH_LBB18_6
cbz	x21, LFQH_LBB18_68
LFQH_LBB18_58:
cmp	w20, #8
eor	w8, w27, #0x1
csinc	w8, w8, wzr, eq
tbnz	w8, #0, LFQH_LBB18_60
mov	x0, x19
mov	x1, x22
mov.16b	v0, v12
mov.16b	v1, v13
mov.16b	v2, v14
mov.16b	v3, v15
bl	LFQH_ReaderShelfMaterial
mov.16b	v8, v0
mov.16b	v9, v1
mov.16b	v11, v2
mov	x8, #4630263366890291200
fmov	d10, x8
LFQH_LBB18_60:
mov.16b	v12, v10
mov.16b	v13, v11
mov.16b	v14, v9
mov.16b	v15, v8
cbz	w27, LFQH_LBB18_62
LFQH_Lloh294:
adr x0, LFQH_l_.str.303
LFQH_Lloh295:
nop
bl Lpatch + (0xa5a4 - PATCH_BASE)
mov	x1, x0
mov	x0, x19
mov.16b	v0, v8
mov.16b	v1, v9
mov.16b	v2, v11
mov.16b	v3, v10
mov	x2, x22
bl Lpatch + (0xa5d4 - PATCH_BASE)
mov.16b	v15, v0
mov.16b	v14, v1
mov.16b	v13, v2
mov.16b	v12, v3
LFQH_LBB18_62:
LFQH_Lloh296:
adr x1, LFQH_IconRectKey
LFQH_Lloh297:
nop
mov	x0, x19
bl Lpatch + (0xa628 - PATCH_BASE)
cbz	x0, LFQH_LBB18_64
mov	x23, x0
LFQH_Lloh298:
adr x0, LFQH_l_.str.286
LFQH_Lloh299:
nop
bl Lpatch + (0xa5a4 - PATCH_BASE)
mov	x1, x0
mov	x0, x23
bl Lpatch + (0xa5d4 - PATCH_BASE)
fcmp	d0, d15
fccmp	d1, d14, #0, eq
fccmp	d2, d13, #0, eq
b.eq	LFQH_LBB18_71
LFQH_LBB18_64:
mov	w8, #1
b	LFQH_LBB18_72
LFQH_LBB18_65:
LFQH_Lloh300:
adr x0, LFQH_l_.str.24
LFQH_Lloh301:
nop
bl Lpatch + (0xa5a4 - PATCH_BASE)
mov	x1, x0
mov	x0, x22
bl Lpatch + (0xa5d4 - PATCH_BASE)
bl	LFQH_VisibleRect
cbz	w0, LFQH_LBB18_20
LFQH_Lloh302:
adr x0, LFQH_l_.str.24
LFQH_Lloh303:
nop
bl Lpatch + (0xa5a4 - PATCH_BASE)
mov	x1, x0
mov	x0, x22
bl Lpatch + (0xa5d4 - PATCH_BASE)
mov.16b	v8, v0
mov.16b	v9, v1
mov.16b	v10, v2
mov.16b	v11, v3
LFQH_Lloh304:
adr x0, LFQH_l_.str.303
LFQH_Lloh305:
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
stp	d1, d0, [sp, #88]
stp	d3, d2, [sp, #72]
bl	LFQH_VisibleRect
cbz	w0, LFQH_LBB18_20
mov	w8, #1
b	LFQH_LBB18_22
LFQH_LBB18_68:
LFQH_Lloh306:
adr x0, LFQH_l_.str.28
LFQH_Lloh307:
nop
bl Lpatch + (0xa5b0 - PATCH_BASE)
mov	x21, x0
LFQH_Lloh308:
adr x0, LFQH_l_.str.29
LFQH_Lloh309:
nop
bl Lpatch + (0xa5a4 - PATCH_BASE)
mov	x1, x0
mov	x0, x21
bl Lpatch + (0xa5d4 - PATCH_BASE)
cbz	x0, LFQH_LBB18_7
mov	x23, x0
bl	LFQH_GlassClass
mov	x21, x0
LFQH_Lloh310:
adr x0, LFQH_l_.str.293
LFQH_Lloh311:
nop
bl Lpatch + (0xa5a4 - PATCH_BASE)
mov	x1, x0
mov	x0, x21
bl Lpatch + (0xa5d4 - PATCH_BASE)
cbz	x0, LFQH_LBB18_7
mov	x21, x0
LFQH_Lloh312:
adr x0, LFQH_l_.str.294
LFQH_Lloh313:
nop
bl Lpatch + (0xa5a4 - PATCH_BASE)
mov	x1, x0
mov	x0, x21
mov	x2, x23
bl Lpatch + (0xa5d4 - PATCH_BASE)
LFQH_Lloh314:
adr x0, LFQH_l_.str.259
LFQH_Lloh315:
nop
bl Lpatch + (0xa5a4 - PATCH_BASE)
mov	x1, x0
mov	x0, x21
mov	w2, #0
bl Lpatch + (0xa5d4 - PATCH_BASE)
LFQH_Lloh316:
adr x0, LFQH_l_.str.260
LFQH_Lloh317:
nop
bl Lpatch + (0xa5a4 - PATCH_BASE)
mov	x1, x0
mov	x0, x21
mov	w2, #1
bl Lpatch + (0xa5d4 - PATCH_BASE)
LFQH_Lloh318:
adr x0, LFQH_l_.str.261
LFQH_Lloh319:
nop
bl Lpatch + (0xa5a4 - PATCH_BASE)
mov	x1, x0
mov	x0, x21
mov	w2, #0
bl Lpatch + (0xa5d4 - PATCH_BASE)
LFQH_Lloh320:
adr x0, LFQH_l_.str.262
LFQH_Lloh321:
nop
bl Lpatch + (0xa5a4 - PATCH_BASE)
mov	x1, x0
mov	x0, x21
mov	w2, #0
bl Lpatch + (0xa5d4 - PATCH_BASE)
LFQH_Lloh322:
adr x0, LFQH_l_.str.88
LFQH_Lloh323:
nop
bl Lpatch + (0xa5a4 - PATCH_BASE)
mov	x1, x0
mov	x0, x21
mov	x2, #0
bl Lpatch + (0xa5d4 - PATCH_BASE)
LFQH_Lloh324:
adr x1, LFQH_IconGlassKey
LFQH_Lloh325:
nop
mov	x0, x19
mov	x2, x21
mov	w3, #1
bl Lpatch + (0xa634 - PATCH_BASE)
LFQH_Lloh326:
adr x0, LFQH_l_.str.55
LFQH_Lloh327:
nop
bl Lpatch + (0xa5a4 - PATCH_BASE)
mov	x1, x0
mov	x0, x21
bl Lpatch + (0xa5d4 - PATCH_BASE)
mov	x0, x19
mov	x1, x21
mov	w2, #1
bl	LFQH_ObservePress
b	LFQH_LBB18_58
LFQH_LBB18_71:
fcmp	d3, d12
cset	w8, ne
LFQH_LBB18_72:
str	w8, [sp, #56]
LFQH_Lloh328:
adr x0, LFQH_l_.str.20
LFQH_Lloh329:
nop
bl Lpatch + (0xa5a4 - PATCH_BASE)
mov	x1, x0
mov	x0, x21
bl Lpatch + (0xa5d4 - PATCH_BASE)
str	x0, [sp, #64]
tbz	w27, #0, LFQH_LBB18_74
str	wzr, [sp, #24]
mov	w24, #0
mov	w28, #0
b	LFQH_LBB18_75
LFQH_LBB18_74:
LFQH_Lloh330:
adr x0, LFQH_l_.str.251
LFQH_Lloh331:
nop
bl Lpatch + (0xa5a4 - PATCH_BASE)
mov	x1, x0
mov	x0, x19
bl Lpatch + (0xa5d4 - PATCH_BASE)
cmp	w0, #0
cset	w24, ne
LFQH_Lloh332:
adr x0, LFQH_l_.str.252
LFQH_Lloh333:
nop
bl Lpatch + (0xa5a4 - PATCH_BASE)
mov	x1, x0
mov	x0, x19
bl Lpatch + (0xa5d4 - PATCH_BASE)
cmp	w0, #0
cset	w28, ne
str	w24, [sp, #24]
LFQH_LBB18_75:
LFQH_Lloh334:
adr x1, LFQH_l_.str.41
LFQH_Lloh335:
nop
mov	x0, x19
bl	LFQH_Kind
cbz	w0, LFQH_LBB18_77
str	w24, [sp, #16]
LFQH_Lloh336:
adr x24, LFQH_l_.str.295
LFQH_Lloh337:
nop
mov	x0, x24
bl Lpatch + (0xa5a4 - PATCH_BASE)
mov	x1, x0
mov	x0, x19
bl Lpatch + (0xa5d4 - PATCH_BASE)
mov	x26, x0
LFQH_Lloh338:
adr x0, LFQH_l_.str.296
LFQH_Lloh339:
nop
bl Lpatch + (0xa5a4 - PATCH_BASE)
mov	x1, x0
mov	x0, x19
bl Lpatch + (0xa5d4 - PATCH_BASE)
mov	x25, x28
mov	x28, x0
LFQH_Lloh340:
adr x0, LFQH_l_.str.297
LFQH_Lloh341:
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
str	w26, [sp, #32]
cmp	w0, w26
cset	w24, ne
LFQH_Lloh342:
adr x0, LFQH_l_.str.296
LFQH_Lloh343:
nop
bl Lpatch + (0xa5a4 - PATCH_BASE)
mov	x1, x0
mov	x0, x21
bl Lpatch + (0xa5d4 - PATCH_BASE)
str	w28, [sp, #40]
cmp	w0, w28
mov	x28, x25
cset	w25, ne
LFQH_Lloh344:
adr x0, LFQH_l_.str.297
LFQH_Lloh345:
nop
bl Lpatch + (0xa5a4 - PATCH_BASE)
mov	x1, x0
mov	x0, x21
bl Lpatch + (0xa5d4 - PATCH_BASE)
str	w23, [sp, #48]
cmp	w0, w23
mov	x23, x24
ldr	w24, [sp, #16]
cset	w26, ne
b	LFQH_LBB18_78
LFQH_LBB18_77:
mov	w23, #0
mov	w25, #0
mov	w26, #0
str	wzr, [sp, #32]
str	wzr, [sp, #40]
str	wzr, [sp, #48]
LFQH_LBB18_78:
ldr	x8, [sp, #64]
cmp	x8, x22
ldr	w8, [sp, #56]
csinc	w8, w8, wzr, eq
orr	w8, w8, w24
tbnz	w8, #0, LFQH_LBB18_84
tbnz	w28, #0, LFQH_LBB18_84
tbnz	w23, #0, LFQH_LBB18_84
tbnz	w25, #0, LFQH_LBB18_84
cbnz	w26, LFQH_LBB18_84
mov	x24, #0
b	LFQH_LBB18_85
LFQH_LBB18_84:
LFQH_Lloh346:
adr x0, LFQH_l_.str.253
LFQH_Lloh347:
nop
bl Lpatch + (0xa5b0 - PATCH_BASE)
mov	x24, x0
LFQH_Lloh348:
adr x0, LFQH_l_.str.254
LFQH_Lloh349:
nop
bl Lpatch + (0xa5a4 - PATCH_BASE)
mov	x1, x0
mov	x0, x24
bl Lpatch + (0xa5d4 - PATCH_BASE)
LFQH_Lloh350:
adr x0, LFQH_l_.str.255
LFQH_Lloh351:
nop
bl Lpatch + (0xa5a4 - PATCH_BASE)
mov	x1, x0
mov	x0, x24
mov	w2, #1
bl Lpatch + (0xa5d4 - PATCH_BASE)
LFQH_LBB18_85:
tbnz	w27, #0, LFQH_LBB18_87
mov	x0, x19
ldr	w1, [sp, #24]
mov	x2, x28
bl	LFQH_PrepareOwner
LFQH_LBB18_87:
ldr	w8, [sp, #56]
cbz	w8, LFQH_LBB18_89
LFQH_Lloh352:
adr x0, LFQH_l_.str.78
LFQH_Lloh353:
nop
bl Lpatch + (0xa5a4 - PATCH_BASE)
mov	x1, x0
mov	x0, x21
mov.16b	v0, v15
mov.16b	v1, v14
mov.16b	v2, v13
mov.16b	v3, v12
bl Lpatch + (0xa5d4 - PATCH_BASE)
mov.16b	v0, v15
mov.16b	v1, v14
mov.16b	v2, v13
mov.16b	v3, v12
bl	LFQH_RectBox
mov	x2, x0
LFQH_Lloh354:
adr x1, LFQH_IconRectKey
LFQH_Lloh355:
nop
mov	x0, x19
mov	w3, #1
bl Lpatch + (0xa634 - PATCH_BASE)
LFQH_LBB18_89:
ldr	x8, [sp, #64]
cmp	x8, x22
b.eq	LFQH_LBB18_94
cbz	w27, LFQH_LBB18_92
LFQH_Lloh356:
adr x0, LFQH_l_.str.298
LFQH_Lloh357:
nop
bl Lpatch + (0xa5a4 - PATCH_BASE)
mov	x1, x0
mov	x0, x22
mov	x2, x21
mov	x3, x19
b	LFQH_LBB18_93
LFQH_LBB18_92:
LFQH_Lloh358:
adr x0, LFQH_l_.str.256
LFQH_Lloh359:
nop
bl Lpatch + (0xa5a4 - PATCH_BASE)
mov	x1, x0
mov	x0, x22
mov	x2, x21
mov	x3, #0
LFQH_LBB18_93:
bl Lpatch + (0xa5d4 - PATCH_BASE)
LFQH_LBB18_94:
cbnz	w23, LFQH_LBB18_101
cbnz	w25, LFQH_LBB18_102
LFQH_LBB18_96:
cbz	w26, LFQH_LBB18_98
LFQH_LBB18_97:
LFQH_Lloh360:
adr x0, LFQH_l_.str.301
LFQH_Lloh361:
nop
bl Lpatch + (0xa5a4 - PATCH_BASE)
mov	x1, x0
mov	x0, x21
ldr	w2, [sp, #48]
bl Lpatch + (0xa5d4 - PATCH_BASE)
LFQH_LBB18_98:
mov	x0, x19
mov.16b	v0, v8
mov.16b	v1, v9
mov.16b	v2, v11
mov.16b	v3, v10
bl	LFQH_EnsureHit
cbz	x24, LFQH_LBB18_100
LFQH_Lloh362:
adr x0, LFQH_l_.str.257
LFQH_Lloh363:
nop
bl Lpatch + (0xa5a4 - PATCH_BASE)
mov	x1, x0
mov	x0, x24
bl Lpatch + (0xa5d4 - PATCH_BASE)
LFQH_LBB18_100:
mov	x0, x20
bl	LFQH_IconRoleName
mov	x2, x0
mov	x0, x19
mov	x1, x21
ldp	d1, d0, [sp, #88]
ldp	d3, d2, [sp, #72]
bl	LFQH_RecordLayout
b	LFQH_LBB18_7
LFQH_LBB18_101:
LFQH_Lloh364:
adr x0, LFQH_l_.str.299
LFQH_Lloh365:
nop
bl Lpatch + (0xa5a4 - PATCH_BASE)
mov	x1, x0
mov	x0, x21
ldr	w2, [sp, #32]
bl Lpatch + (0xa5d4 - PATCH_BASE)
cbz	w25, LFQH_LBB18_96
LFQH_LBB18_102:
LFQH_Lloh366:
adr x0, LFQH_l_.str.300
LFQH_Lloh367:
nop
bl Lpatch + (0xa5a4 - PATCH_BASE)
mov	x1, x0
mov	x0, x21
ldr	w2, [sp, #40]
bl Lpatch + (0xa5d4 - PATCH_BASE)
cbnz	w26, LFQH_LBB18_97
b	LFQH_LBB18_98
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
LFQH_Lloh368:
adr x1, LFQH_ReaderGlassKey
LFQH_Lloh369:
nop
bl Lpatch + (0xa628 - PATCH_BASE)
mov	x19, x0
LFQH_Lloh370:
adr x0, LFQH_l_.str.30
LFQH_Lloh371:
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
LFQH_Lloh372:
adr x1, LFQH_OwnerBusyKey
LFQH_Lloh373:
nop
bl Lpatch + (0xa628 - PATCH_BASE)
cbnz	x0, LFQH_LBB21_41
LFQH_Lloh374:
adr x1, LFQH_OwnerBusyKey
LFQH_Lloh375:
nop
mov	x0, x19
mov	x2, x19
mov	x3, #0
bl Lpatch + (0xa634 - PATCH_BASE)
LFQH_Lloh376:
adr x0, LFQH_l_.str.24
LFQH_Lloh377:
nop
bl Lpatch + (0xa5a4 - PATCH_BASE)
mov	x1, x0
mov	x0, x19
bl Lpatch + (0xa5d4 - PATCH_BASE)
stp	d0, d1, [sp, #16]
stp	d2, d3, [sp, #32]
LFQH_Lloh378:
adr x1, LFQH_l_.str.31
LFQH_Lloh379:
nop
mov	x0, x19
bl	LFQH_Get
cbz	x0, LFQH_LBB21_6
mov	x21, x0
mov	w23, #0
LFQH_Lloh380:
adr x22, LFQH_l_.str.20
LFQH_Lloh381:
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
LFQH_Lloh382:
adr x20, LFQH_IconGlassKey
LFQH_Lloh383:
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
LFQH_Lloh384:
adr x1, LFQH_l_.str.32
LFQH_Lloh385:
nop
mov	x0, x19
bl	LFQH_Get
mov	x21, x0
LFQH_Lloh386:
adr x1, LFQH_l_.str.33
LFQH_Lloh387:
nop
bl	LFQH_Kind
cbz	w0, LFQH_LBB21_31
LFQH_Lloh388:
adr x0, LFQH_l_.str.34
LFQH_Lloh389:
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
LFQH_Lloh390:
adr x27, LFQH_l_.str.20
LFQH_Lloh391:
nop
LFQH_LBB21_11:
LFQH_Lloh392:
adr x0, LFQH_l_.str.327
LFQH_Lloh393:
nop
bl Lpatch + (0xa5a4 - PATCH_BASE)
mov	x1, x0
mov	x0, x21
mov	x2, x24
bl Lpatch + (0xa5d4 - PATCH_BASE)
mov	x25, x0
LFQH_Lloh394:
adr x1, LFQH_l_.str.328
LFQH_Lloh395:
nop
bl	LFQH_Kind
tbz	w0, #0, LFQH_LBB21_13
mov	w28, #0
mov	w22, #3
b	LFQH_LBB21_21
LFQH_LBB21_13:
mov	x0, x25
LFQH_Lloh396:
adr x1, LFQH_l_.str.329
LFQH_Lloh397:
nop
bl	LFQH_Kind
tbz	w0, #0, LFQH_LBB21_15
mov	w28, #0
mov	w22, #4
b	LFQH_LBB21_21
LFQH_LBB21_15:
mov	x0, x25
LFQH_Lloh398:
adr x1, LFQH_l_.str.330
LFQH_Lloh399:
nop
bl	LFQH_Kind
tbz	w0, #0, LFQH_LBB21_17
mov	w22, #5
mov	w28, #1
b	LFQH_LBB21_21
LFQH_LBB21_17:
mov	x0, x25
LFQH_Lloh400:
adr x1, LFQH_l_.str.331
LFQH_Lloh401:
nop
bl	LFQH_Kind
tbz	w0, #0, LFQH_LBB21_19
mov	w28, #0
mov	w22, #8
b	LFQH_LBB21_21
LFQH_LBB21_19:
mov	x0, x25
LFQH_Lloh402:
adr x1, LFQH_l_.str.332
LFQH_Lloh403:
nop
bl	LFQH_Kind
cbz	w0, LFQH_LBB21_30
mov	w28, #0
mov	w22, #6
LFQH_LBB21_21:
mov	x0, x25
LFQH_Lloh404:
adr x1, LFQH_l_.str.35
LFQH_Lloh405:
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
LFQH_Lloh406:
adr x1, LFQH_IconGlassKey
LFQH_Lloh407:
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
LFQH_Lloh408:
adr x1, LFQH_l_.str.36
LFQH_Lloh409:
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
LFQH_Lloh410:
adr x1, LFQH_ReaderDownloadLabelKey
LFQH_Lloh411:
nop
mov	x0, x19
ldr	x2, [sp]
bl	LFQH_TrackReaderLabel
LFQH_Lloh412:
adr x1, LFQH_ReaderShelfLabelKey
LFQH_Lloh413:
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
LFQH_Lloh414:
adr x1, LFQH_ReaderGlassKey
LFQH_Lloh415:
nop
mov	x0, x19
bl Lpatch + (0xa628 - PATCH_BASE)
mov	x21, x0
LFQH_Lloh416:
adr x0, LFQH_l_.str.30
LFQH_Lloh417:
nop
bl Lpatch + (0xa5a4 - PATCH_BASE)
mov	x1, x0
mov	x0, x21
bl Lpatch + (0xa5d4 - PATCH_BASE)
cmp	x20, x0
b.eq	LFQH_LBB21_40
cbz	x20, LFQH_LBB21_38
LFQH_Lloh418:
adr x0, LFQH_l_.str.267
LFQH_Lloh419:
nop
bl Lpatch + (0xa5b0 - PATCH_BASE)
mov	x21, x0
LFQH_Lloh420:
adr x0, LFQH_l_.str.333
LFQH_Lloh421:
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
LFQH_Lloh422:
adr x1, LFQH_ReaderGlassKey
LFQH_Lloh423:
nop
mov	x0, x19
mov	w3, #1
bl Lpatch + (0xa634 - PATCH_BASE)
LFQH_LBB21_40:
LFQH_Lloh424:
adr x1, LFQH_OwnerBusyKey
LFQH_Lloh425:
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
LFQH_Lloh426:
adr x0, LFQH_l_.str.20
LFQH_Lloh427:
nop
bl Lpatch + (0xa5a4 - PATCH_BASE)
mov	x1, x0
mov	x0, x22
bl Lpatch + (0xa5d4 - PATCH_BASE)
cbz	x0, LFQH_LBB23_14
mov	x21, x0
mov	w24, #0
LFQH_Lloh428:
adr x23, LFQH_l_.str.20
LFQH_Lloh429:
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
LFQH_Lloh430:
adr x0, LFQH_l_.str.249
LFQH_Lloh431:
nop
bl Lpatch + (0xa5a4 - PATCH_BASE)
mov	x1, x0
mov	x0, x22
bl Lpatch + (0xa5d4 - PATCH_BASE)
mov.16b	v8, v0
mov.16b	v9, v1
mov.16b	v10, v2
mov.16b	v11, v3
LFQH_Lloh432:
adr x0, LFQH_l_.str.303
LFQH_Lloh433:
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
LFQH_Lloh434:
adr x1, LFQH_IconGlassKey
LFQH_Lloh435:
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
LFQH_Lloh436:
adr x0, LFQH_l_.str.24
LFQH_Lloh437:
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
LFQH_Lloh438:
adr x0, LFQH_l_.str.304
LFQH_Lloh439:
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
LFQH_Lloh440:
adr x1, LFQH_HitInsetsKey
LFQH_Lloh441:
nop
mov	x0, x19
bl Lpatch + (0xa628 - PATCH_BASE)
mov	x21, x0
LFQH_Lloh442:
adr x1, LFQH_AppliedHitInsetsKey
LFQH_Lloh443:
nop
mov	x0, x19
bl Lpatch + (0xa628 - PATCH_BASE)
mov	x20, x0
cbz	x21, LFQH_LBB27_13
cbz	x20, LFQH_LBB27_13
LFQH_Lloh444:
adr x0, LFQH_l_.str.286
LFQH_Lloh445:
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
LFQH_Lloh446:
adr x0, LFQH_l_.str.287
LFQH_Lloh447:
nop
bl Lpatch + (0xa5b0 - PATCH_BASE)
mov	x21, x0
LFQH_Lloh448:
adr x0, LFQH_l_.str.288
LFQH_Lloh449:
nop
bl Lpatch + (0xa5a4 - PATCH_BASE)
mov	x1, x0
mov	x0, x21
mov.16b	v0, v14
mov.16b	v1, v15
ldp	d3, d2, [sp]
bl Lpatch + (0xa5d4 - PATCH_BASE)
mov	x21, x0
LFQH_Lloh450:
adr x1, LFQH_HitInsetsKey
LFQH_Lloh451:
nop
mov	x0, x19
mov	x2, x21
mov	w3, #1
bl Lpatch + (0xa634 - PATCH_BASE)
LFQH_LBB27_14:
LFQH_Lloh452:
adr x0, LFQH_l_.str.286
LFQH_Lloh453:
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
LFQH_Lloh454:
adr x0, LFQH_l_.str.305
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
LFQH_LBB27_16:
cbz	x20, LFQH_LBB27_18
LFQH_Lloh456:
adr x0, LFQH_l_.str.286
LFQH_Lloh457:
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
LFQH_Lloh458:
adr x0, LFQH_l_.str.287
LFQH_Lloh459:
nop
bl Lpatch + (0xa5b0 - PATCH_BASE)
mov	x20, x0
LFQH_Lloh460:
adr x0, LFQH_l_.str.288
LFQH_Lloh461:
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
LFQH_Lloh462:
adr x1, LFQH_AppliedHitInsetsKey
LFQH_Lloh463:
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
LFQH_Lloh464:
adr x1, LFQH_HitInsetsKey
LFQH_Lloh465:
nop
bl Lpatch + (0xa628 - PATCH_BASE)
mov	x20, x0
LFQH_Lloh466:
adr x1, LFQH_AppliedHitInsetsKey
LFQH_Lloh467:
nop
mov	x0, x19
bl Lpatch + (0xa628 - PATCH_BASE)
cmp	x20, #0
ccmp	x0, #0, #4, ne
b.eq	LFQH_LBB28_3
mov	x21, x0
LFQH_Lloh468:
adr x0, LFQH_l_.str.304
LFQH_Lloh469:
nop
bl Lpatch + (0xa5a4 - PATCH_BASE)
mov	x1, x0
mov	x0, x19
bl Lpatch + (0xa5d4 - PATCH_BASE)
mov.16b	v8, v0
mov.16b	v9, v1
mov.16b	v10, v2
mov.16b	v11, v3
LFQH_Lloh470:
adr x0, LFQH_l_.str.286
LFQH_Lloh471:
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
LFQH_Lloh472:
adr x0, LFQH_l_.str.286
LFQH_Lloh473:
nop
bl Lpatch + (0xa5a4 - PATCH_BASE)
mov	x1, x0
mov	x0, x20
bl Lpatch + (0xa5d4 - PATCH_BASE)
mov.16b	v8, v0
mov.16b	v9, v1
mov.16b	v10, v2
mov.16b	v11, v3
LFQH_Lloh474:
adr x0, LFQH_l_.str.305
LFQH_Lloh475:
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
LFQH_Lloh476:
adr x1, LFQH_HitInsetsKey
LFQH_Lloh477:
nop
mov	x0, x19
mov	x2, #0
mov	w3, #1
bl Lpatch + (0xa634 - PATCH_BASE)
LFQH_Lloh478:
adr x1, LFQH_AppliedHitInsetsKey
LFQH_Lloh479:
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
LFQH_Lloh480:
adr x1, LFQH_OwnerBusyKey
LFQH_Lloh481:
nop
bl Lpatch + (0xa628 - PATCH_BASE)
cbz	x0, LFQH_LBB29_2
ldp	x29, x30, [sp, #48]
ldp	x20, x19, [sp, #32]
ldp	x22, x21, [sp, #16]
ldp	x24, x23, [sp], #64
ret
LFQH_LBB29_2:
LFQH_Lloh482:
adr x1, LFQH_OwnerBusyKey
LFQH_Lloh483:
nop
mov	x0, x19
mov	x2, x19
mov	x3, #0
bl Lpatch + (0xa634 - PATCH_BASE)
LFQH_Lloh484:
adr x1, LFQH_l_.str.37
LFQH_Lloh485:
nop
mov	x0, x19
bl	LFQH_Get
mov	x20, x0
LFQH_Lloh486:
adr x1, LFQH_l_.str.38
LFQH_Lloh487:
nop
mov	x0, x19
bl	LFQH_Get
mov	x21, x0
LFQH_Lloh488:
adr x1, LFQH_l_.str.39
LFQH_Lloh489:
nop
mov	x0, x19
bl	LFQH_Get
mov	x22, x0
LFQH_Lloh490:
adr x23, LFQH_ShelfRoleKey
LFQH_Lloh491:
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
LFQH_Lloh492:
adr x0, LFQH_l_.str.40
LFQH_Lloh493:
nop
bl Lpatch + (0xa5a4 - PATCH_BASE)
mov	x1, x0
mov	x0, x24
bl Lpatch + (0xa5d4 - PATCH_BASE)
cbnz	w0, LFQH_LBB29_6
LFQH_LBB29_5:
LFQH_Lloh494:
adr x0, LFQH_l_.str.267
LFQH_Lloh495:
nop
bl Lpatch + (0xa5b0 - PATCH_BASE)
mov	x24, x0
LFQH_Lloh496:
adr x0, LFQH_l_.str.334
LFQH_Lloh497:
nop
bl Lpatch + (0xa5a4 - PATCH_BASE)
mov	x1, x0
mov	x0, x24
mov	w2, #1
bl Lpatch + (0xa5d4 - PATCH_BASE)
mov	x2, x0
LFQH_Lloh498:
adr x1, LFQH_ShelfRoleKey
LFQH_Lloh499:
nop
mov	x0, x20
mov	w3, #1
bl Lpatch + (0xa634 - PATCH_BASE)
LFQH_LBB29_6:
cbz	x21, LFQH_LBB29_10
cbz	x23, LFQH_LBB29_9
LFQH_Lloh500:
adr x0, LFQH_l_.str.40
LFQH_Lloh501:
nop
bl Lpatch + (0xa5a4 - PATCH_BASE)
mov	x1, x0
mov	x0, x23
bl Lpatch + (0xa5d4 - PATCH_BASE)
cbz	w0, LFQH_LBB29_10
LFQH_LBB29_9:
LFQH_Lloh502:
adr x0, LFQH_l_.str.267
LFQH_Lloh503:
nop
bl Lpatch + (0xa5b0 - PATCH_BASE)
mov	x23, x0
LFQH_Lloh504:
adr x0, LFQH_l_.str.334
LFQH_Lloh505:
nop
bl Lpatch + (0xa5a4 - PATCH_BASE)
mov	x1, x0
mov	x0, x23
mov	w2, #0
bl Lpatch + (0xa5d4 - PATCH_BASE)
mov	x2, x0
LFQH_Lloh506:
adr x1, LFQH_ShelfRoleKey
LFQH_Lloh507:
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
LFQH_Lloh508:
adr x1, LFQH_l_.str.23
LFQH_Lloh509:
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
LFQH_Lloh510:
adr x1, LFQH_OwnerBusyKey
LFQH_Lloh511:
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
LFQH_BoolBox:
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
LFQH_Lloh512:
adr x0, LFQH_l_.str.267
LFQH_Lloh513:
nop
bl Lpatch + (0xa5b0 - PATCH_BASE)
mov	x20, x0
LFQH_Lloh514:
adr x0, LFQH_l_.str.334
LFQH_Lloh515:
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
LFQH_Lloh516:
adr x0, LFQH_l_.str.24
LFQH_Lloh517:
nop
bl Lpatch + (0xa5a4 - PATCH_BASE)
mov	x1, x0
mov	x0, x19
bl Lpatch + (0xa5d4 - PATCH_BASE)
stp	d0, d1, [sp]
stp	d2, d3, [sp, #16]
LFQH_Lloh518:
adr x23, LFQH_IconGlassKey
LFQH_Lloh519:
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
cbnz	x20, LFQH_LBB32_4
cbnz	x21, LFQH_LBB32_4
cbnz	x22, LFQH_LBB32_4
mov	x0, x19
ldp	x29, x30, [sp, #80]
ldp	x20, x19, [sp, #64]
ldp	x22, x21, [sp, #48]
ldp	x24, x23, [sp, #32]
add	sp, sp, #96
b	LFQH_RestoreHit
LFQH_LBB32_4:
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
mov	x23, x1
mov	x19, x0
LFQH_Lloh520:
adr x1, LFQH_l_.str.354
LFQH_Lloh521:
nop
bl	LFQH_Get
mov	x27, x0
LFQH_Lloh522:
adr x1, LFQH_l_.str.355
LFQH_Lloh523:
nop
bl	LFQH_Get
mov	x22, x0
LFQH_Lloh524:
adr x1, LFQH_ShelfEditHeaderKey
LFQH_Lloh525:
nop
mov	x0, x23
bl Lpatch + (0xa628 - PATCH_BASE)
mov	x24, x0
LFQH_Lloh526:
adr x0, LFQH_l_.str.244
LFQH_Lloh527:
nop
bl Lpatch + (0xa5b0 - PATCH_BASE)
mov	x20, x0
LFQH_Lloh528:
adr x0, LFQH_l_.str.245
LFQH_Lloh529:
nop
bl Lpatch + (0xa5a4 - PATCH_BASE)
mov	x1, x0
LFQH_Lloh530:
adr x2, LFQH_l_.str.436
LFQH_Lloh531:
nop
mov	x0, x20
bl Lpatch + (0xa5d4 - PATCH_BASE)
bl	LFQH_DefaultEnabled
fmov	d8, xzr
cbz	w0, LFQH_LBB33_35
LFQH_LBB33_1:
mov	x25, #0
mov	x21, #0
LFQH_LBB33_2:
fmov	d9, xzr
fmov	d10, xzr
fmov	d11, xzr
LFQH_LBB33_3:
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
csel	w28, wzr, w8, le
cmp	x24, x22
csel	w8, wzr, w28, ne
cbz	x24, LFQH_LBB33_8
tbnz	w8, #0, LFQH_LBB33_8
LFQH_Lloh532:
adr x1, LFQH_l_.str.60
LFQH_Lloh533:
nop
mov	x0, x24
bl	LFQH_Get
mov	x20, x0
LFQH_Lloh534:
adr x1, LFQH_l_.str.20
LFQH_Lloh535:
nop
bl	LFQH_Get
cmp	x0, x23
b.ne	LFQH_LBB33_7
LFQH_Lloh536:
adr x1, LFQH_l_.str.358
LFQH_Lloh537:
nop
mov	x0, x24
bl	LFQH_Get
mov	x26, x0
LFQH_Lloh538:
adr x0, LFQH_l_.str.89
LFQH_Lloh539:
nop
bl Lpatch + (0xa5a4 - PATCH_BASE)
mov	x1, x0
mov	x0, x26
mov	x2, x20
bl Lpatch + (0xa5d4 - PATCH_BASE)
LFQH_Lloh540:
adr x0, LFQH_l_.str.180
LFQH_Lloh541:
nop
bl Lpatch + (0xa5a4 - PATCH_BASE)
mov	x1, x0
mov	x0, x24
bl Lpatch + (0xa5d4 - PATCH_BASE)
LFQH_LBB33_7:
LFQH_Lloh542:
adr x1, LFQH_ShelfEditHeaderKey
LFQH_Lloh543:
nop
mov	x0, x23
mov	x2, #0
mov	w3, #1
bl Lpatch + (0xa634 - PATCH_BASE)
LFQH_LBB33_8:
cbz	w28, LFQH_LBB33_31
LFQH_Lloh544:
adr x1, LFQH_l_.str.20
LFQH_Lloh545:
nop
mov	x0, x21
bl	LFQH_Get
cmp	x0, x23
b.eq	LFQH_LBB33_11
LFQH_Lloh546:
adr x0, LFQH_l_.str.89
LFQH_Lloh547:
nop
bl Lpatch + (0xa5a4 - PATCH_BASE)
mov	x1, x0
mov	x0, x23
mov	x2, x21
bl Lpatch + (0xa5d4 - PATCH_BASE)
LFQH_LBB33_11:
LFQH_Lloh548:
adr x0, LFQH_l_.str.249
LFQH_Lloh549:
nop
bl Lpatch + (0xa5a4 - PATCH_BASE)
mov	x1, x0
mov	x0, x21
bl Lpatch + (0xa5d4 - PATCH_BASE)
fcmp	d0, d11
b.ne	LFQH_LBB33_15
fcmp	d1, d10
b.ne	LFQH_LBB33_15
fcmp	d2, d9
b.ne	LFQH_LBB33_15
fcmp	d3, d8
b.eq	LFQH_LBB33_16
LFQH_LBB33_15:
LFQH_Lloh550:
adr x0, LFQH_l_.str.78
LFQH_Lloh551:
nop
bl Lpatch + (0xa5a4 - PATCH_BASE)
mov	x1, x0
mov	x0, x21
mov.16b	v0, v11
mov.16b	v1, v10
mov.16b	v2, v9
mov.16b	v3, v8
bl Lpatch + (0xa5d4 - PATCH_BASE)
LFQH_LBB33_16:
mov	x0, x21
mov	w1, #0
bl	LFQH_ShelfActionGlass
cmp	x24, x22
b.eq	LFQH_LBB33_18
LFQH_Lloh552:
adr x1, LFQH_ShelfEditHeaderKey
LFQH_Lloh553:
nop
mov	x0, x23
mov	x2, x22
mov	w3, #1
bl Lpatch + (0xa634 - PATCH_BASE)
LFQH_LBB33_18:
mov	x0, x27
bl Lpatch + (0xa664 - PATCH_BASE)
mov	x20, x0
LFQH_Lloh554:
adr x0, LFQH_l_.str.359
LFQH_Lloh555:
nop
bl Lpatch + (0xa5a4 - PATCH_BASE)
mov	x1, x0
mov	x0, x20
bl Lpatch + (0xa5f8 - PATCH_BASE)
cbz	x0, LFQH_LBB33_31
LFQH_Lloh556:
adr x0, LFQH_l_.str.292
LFQH_Lloh557:
nop
bl Lpatch + (0xa5a4 - PATCH_BASE)
mov	x1, x0
mov	x0, x25
bl Lpatch + (0xa5d4 - PATCH_BASE)
mov	x20, x27
cbnz	w0, LFQH_LBB33_32
LFQH_Lloh558:
adr x1, LFQH_l_.str.360
LFQH_Lloh559:
nop
mov	x0, x22
bl	LFQH_Get
mov	x23, x0
LFQH_Lloh560:
adr x1, LFQH_l_.str.361
LFQH_Lloh561:
nop
mov	x0, x22
bl	LFQH_Get
mov	x22, x0
LFQH_Lloh562:
adr x1, LFQH_l_.str.279
LFQH_Lloh563:
nop
mov	x0, x25
bl	LFQH_Get
mov	x24, x0
LFQH_Lloh564:
adr x0, LFQH_l_.str.34
LFQH_Lloh565:
nop
bl Lpatch + (0xa5a4 - PATCH_BASE)
mov	x1, x0
mov	x0, x24
bl Lpatch + (0xa5d4 - PATCH_BASE)
mov	x20, x27
cbz	x0, LFQH_LBB33_32
mov	x25, x0
str	x27, [sp, #8]
mov	x26, #0
LFQH_Lloh566:
adr x27, LFQH_l_.str.327
LFQH_Lloh567:
nop
LFQH_LBB33_22:
mov	x0, x27
bl Lpatch + (0xa5a4 - PATCH_BASE)
mov	x1, x0
mov	x0, x24
mov	x2, x26
bl Lpatch + (0xa5d4 - PATCH_BASE)
cmp	x0, x22
ccmp	x0, x23, #4, ne
b.eq	LFQH_LBB33_29
mov	x20, x0
LFQH_Lloh568:
adr x0, LFQH_l_.str.292
LFQH_Lloh569:
nop
bl Lpatch + (0xa5a4 - PATCH_BASE)
mov	x1, x0
mov	x0, x20
bl Lpatch + (0xa5d4 - PATCH_BASE)
cbnz	w0, LFQH_LBB33_29
LFQH_Lloh570:
adr x0, LFQH_l_.str.362
LFQH_Lloh571:
nop
bl Lpatch + (0xa5a4 - PATCH_BASE)
mov	x1, x0
mov	x0, x20
bl Lpatch + (0xa5d4 - PATCH_BASE)
fcmp	d0, #0.0
b.le	LFQH_LBB33_29
LFQH_Lloh572:
adr x0, LFQH_l_.str.249
LFQH_Lloh573:
nop
bl Lpatch + (0xa5a4 - PATCH_BASE)
mov	x1, x0
mov	x0, x20
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
b.hi	LFQH_LBB33_29
fmov	x8, d3
ubfx	x8, x8, #52, #11
cmp	x8, #2046
b.hi	LFQH_LBB33_29
fcmp	d2, #0.0
b.le	LFQH_LBB33_29
fcmp	d3, #0.0
b.gt	LFQH_LBB33_47
LFQH_LBB33_29:
add	x26, x26, #1
cmp	x25, x26
b.ne	LFQH_LBB33_22
ldr	x27, [sp, #8]
mov	x20, x27
b	LFQH_LBB33_32
LFQH_LBB33_31:
mov	x20, #0
LFQH_LBB33_32:
LFQH_Lloh574:
adr x1, LFQH_ShelfCompactKey
LFQH_Lloh575:
nop
mov	x0, x19
bl Lpatch + (0xa628 - PATCH_BASE)
cmp	x0, x20
b.eq	LFQH_LBB33_34
LFQH_Lloh576:
adr x1, LFQH_ShelfCompactKey
LFQH_Lloh577:
nop
mov	x0, x19
mov	x2, x20
mov	w3, #1
bl Lpatch + (0xa634 - PATCH_BASE)
LFQH_Lloh578:
adr x0, LFQH_l_.str.363
LFQH_Lloh579:
nop
bl Lpatch + (0xa5a4 - PATCH_BASE)
mov	x1, x0
mov	x0, x27
bl Lpatch + (0xa5d4 - PATCH_BASE)
LFQH_Lloh580:
adr x1, LFQH_l_.str.364
LFQH_Lloh581:
nop
mov	x0, x19
bl	LFQH_Get
LFQH_Lloh582:
adr x1, LFQH_l_.str.365
LFQH_Lloh583:
nop
bl	LFQH_Get
mov	x19, x0
LFQH_Lloh584:
adr x0, LFQH_l_.str.366
LFQH_Lloh585:
nop
bl Lpatch + (0xa5a4 - PATCH_BASE)
mov	x1, x0
mov	x0, x19
bl Lpatch + (0xa5d4 - PATCH_BASE)
LFQH_LBB33_34:
cmp	w28, #0
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
LFQH_LBB33_35:
LFQH_Lloh586:
adr x1, LFQH_l_.str.21
LFQH_Lloh587:
nop
mov	x0, x22
bl	LFQH_Kind
cbz	w0, LFQH_LBB33_1
mov	x0, x22
bl Lpatch + (0xa664 - PATCH_BASE)
LFQH_Lloh588:
adr x1, LFQH_l_.str.356
LFQH_Lloh589:
nop
LFQH_Lloh590:
adr x2, LFQH_l_.str.97
LFQH_Lloh591:
nop
bl	LFQH_ClassABI
cbz	w0, LFQH_LBB33_1
LFQH_Lloh592:
adr x0, LFQH_l_.str.356
LFQH_Lloh593:
nop
bl Lpatch + (0xa5a4 - PATCH_BASE)
mov	x1, x0
mov	x0, x22
bl Lpatch + (0xa5d4 - PATCH_BASE)
cbnz	w0, LFQH_LBB33_1
mov	x0, x22
bl Lpatch + (0xa664 - PATCH_BASE)
LFQH_Lloh594:
adr x1, LFQH_l_.str.357
LFQH_Lloh595:
nop
LFQH_Lloh596:
adr x2, LFQH_l_.str.97
LFQH_Lloh597:
nop
bl	LFQH_ClassABI
cbz	w0, LFQH_LBB33_1
LFQH_Lloh598:
adr x0, LFQH_l_.str.357
LFQH_Lloh599:
nop
bl Lpatch + (0xa5a4 - PATCH_BASE)
mov	x1, x0
mov	x0, x22
bl Lpatch + (0xa5d4 - PATCH_BASE)
cbnz	w0, LFQH_LBB33_1
mov	x0, x22
bl Lpatch + (0xa664 - PATCH_BASE)
LFQH_Lloh600:
adr x1, LFQH_l_.str.180
LFQH_Lloh601:
nop
LFQH_Lloh602:
adr x2, LFQH_l_.str.9
LFQH_Lloh603:
nop
bl	LFQH_ClassABI
cbz	w0, LFQH_LBB33_1
LFQH_Lloh604:
adr x0, LFQH_l_.str.292
LFQH_Lloh605:
nop
bl Lpatch + (0xa5a4 - PATCH_BASE)
mov	x1, x0
mov	x0, x22
bl Lpatch + (0xa5d4 - PATCH_BASE)
cbnz	w0, LFQH_LBB33_1
LFQH_Lloh606:
adr x1, LFQH_l_.str.60
LFQH_Lloh607:
nop
mov	x0, x22
bl	LFQH_Get
mov	x21, x0
LFQH_Lloh608:
adr x1, LFQH_l_.str.358
LFQH_Lloh609:
nop
mov	x0, x22
bl	LFQH_Get
mov	x25, x0
LFQH_Lloh610:
adr x1, LFQH_l_.str.20
LFQH_Lloh611:
nop
mov	x0, x21
bl	LFQH_Get
cbz	x25, LFQH_LBB33_2
cmp	x0, x23
ccmp	x0, x25, #4, ne
b.ne	LFQH_LBB33_2
LFQH_Lloh612:
adr x1, LFQH_l_.str.290
LFQH_Lloh613:
nop
mov	x0, x21
bl	LFQH_Kind
cbz	w0, LFQH_LBB33_2
LFQH_Lloh614:
adr x0, LFQH_l_.str.292
LFQH_Lloh615:
nop
bl Lpatch + (0xa5a4 - PATCH_BASE)
mov	x1, x0
mov	x0, x21
bl Lpatch + (0xa5d4 - PATCH_BASE)
cbnz	w0, LFQH_LBB33_2
mov	x0, x21
bl	LFQH_ShelfEditPadding
mov	x0, x19
mov	x1, x23
mov	x2, x21
bl	LFQH_ShelfEditFrame
mov.16b	v11, v0
mov.16b	v10, v1
mov.16b	v9, v2
mov.16b	v8, v3
b	LFQH_LBB33_3
LFQH_LBB33_47:
mov	x20, #0
ldr	x27, [sp, #8]
b	LFQH_LBB33_32
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
LFQH_Lloh616:
adr x1, LFQH_l_.str.41
LFQH_Lloh617:
nop
bl	LFQH_Kind
cbz	w0, LFQH_LBB34_2
LFQH_Lloh618:
adr x1, LFQH_l_.str.20
LFQH_Lloh619:
nop
mov	x0, x19
bl	LFQH_Get
LFQH_Lloh620:
adr x1, LFQH_l_.str.42
LFQH_Lloh621:
nop
bl	LFQH_Kind
LFQH_LBB34_2:
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
LFQH_Lloh622:
adr x0, LFQH_l_.str.24
LFQH_Lloh623:
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
b.le	LFQH_LBB35_2
fmov	d4, #6.00000000
fadd	d0, d0, d4
fmov	d4, #-12.00000000
fadd	d2, d2, d4
fmov	d4, #4.00000000
fadd	d1, d1, d4
fmov	d4, #-8.00000000
fadd	d3, d3, d4
LFQH_LBB35_2:
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
LFQH_Lloh624:
adr x1, LFQH_l_.str.43
LFQH_Lloh625:
nop
bl	LFQH_Kind
cbz	w0, LFQH_LBB36_12
mov	x0, x19
mov	w1, #2
bl	LFQH_ListenCaption
mov	x21, x0
LFQH_Lloh626:
adr x1, LFQH_ListenLabelKey
LFQH_Lloh627:
nop
mov	x0, x19
bl Lpatch + (0xa628 - PATCH_BASE)
mov	x22, x0
bl	LFQH_Enabled
cbz	w0, LFQH_LBB36_13
cbz	x21, LFQH_LBB36_13
bl	LFQH_FQHGlassAvailable
tbz	w0, #0, LFQH_LBB36_13
mov	x0, x19
bl	LFQH_FQHApply
LFQH_Lloh628:
adr x1, LFQH_SurfaceKey
LFQH_Lloh629:
nop
mov	x0, x19
bl Lpatch + (0xa628 - PATCH_BASE)
cbz	x0, LFQH_LBB36_12
mov	x20, x0
cmp	x22, x21
b.eq	LFQH_LBB36_9
cbz	x22, LFQH_LBB36_8
LFQH_Lloh630:
adr x0, LFQH_l_.str.44
LFQH_Lloh631:
nop
bl Lpatch + (0xa5a4 - PATCH_BASE)
mov	x23, x0
LFQH_Lloh632:
adr x1, LFQH_ListenColorKey
LFQH_Lloh633:
nop
mov	x0, x19
bl Lpatch + (0xa628 - PATCH_BASE)
mov	x2, x0
mov	x0, x22
mov	x1, x23
bl Lpatch + (0xa5d4 - PATCH_BASE)
LFQH_LBB36_8:
LFQH_Lloh634:
adr x1, LFQH_ListenLabelKey
LFQH_Lloh635:
nop
mov	x0, x19
mov	x2, x21
mov	w3, #1
bl Lpatch + (0xa634 - PATCH_BASE)
LFQH_Lloh636:
adr x1, LFQH_l_.str.45
LFQH_Lloh637:
nop
mov	x0, x21
bl	LFQH_Get
mov	x2, x0
LFQH_Lloh638:
adr x1, LFQH_ListenColorKey
LFQH_Lloh639:
nop
mov	x0, x19
mov	w3, #1
bl Lpatch + (0xa634 - PATCH_BASE)
LFQH_LBB36_9:
LFQH_Lloh640:
adr x0, LFQH_l_.str.46
LFQH_Lloh641:
nop
bl Lpatch + (0xa5b0 - PATCH_BASE)
mov	x22, x0
LFQH_Lloh642:
adr x0, LFQH_l_.str.47
LFQH_Lloh643:
nop
bl Lpatch + (0xa5a4 - PATCH_BASE)
mov	x1, x0
mov	x0, x22
bl Lpatch + (0xa5d4 - PATCH_BASE)
mov	x22, x0
LFQH_Lloh644:
adr x1, LFQH_l_.str.45
LFQH_Lloh645:
nop
mov	x0, x21
bl	LFQH_Get
mov	x23, x0
LFQH_Lloh646:
adr x0, LFQH_l_.str.48
LFQH_Lloh647:
nop
bl Lpatch + (0xa5a4 - PATCH_BASE)
mov	x1, x0
mov	x0, x23
mov	x2, x22
bl Lpatch + (0xa5d4 - PATCH_BASE)
cbnz	w0, LFQH_LBB36_11
LFQH_Lloh648:
adr x0, LFQH_l_.str.44
LFQH_Lloh649:
nop
bl Lpatch + (0xa5a4 - PATCH_BASE)
mov	x1, x0
mov	x0, x21
mov	x2, x22
bl Lpatch + (0xa5d4 - PATCH_BASE)
LFQH_LBB36_11:
LFQH_Lloh650:
adr x1, LFQH_ListenTintKey
LFQH_Lloh651:
nop
mov	x0, x19
bl Lpatch + (0xa628 - PATCH_BASE)
cbz	x0, LFQH_LBB36_16
LFQH_LBB36_12:
ldp	x29, x30, [sp, #48]
ldp	x20, x19, [sp, #32]
ldp	x22, x21, [sp, #16]
ldp	x24, x23, [sp], #64
ret
LFQH_LBB36_13:
cbz	x22, LFQH_LBB36_15
LFQH_Lloh652:
adr x0, LFQH_l_.str.44
LFQH_Lloh653:
nop
bl Lpatch + (0xa5a4 - PATCH_BASE)
mov	x20, x0
LFQH_Lloh654:
adr x1, LFQH_ListenColorKey
LFQH_Lloh655:
nop
mov	x0, x19
bl Lpatch + (0xa628 - PATCH_BASE)
mov	x2, x0
mov	x0, x22
mov	x1, x20
bl Lpatch + (0xa5d4 - PATCH_BASE)
LFQH_LBB36_15:
LFQH_Lloh656:
adr x1, LFQH_ListenLabelKey
LFQH_Lloh657:
nop
mov	x0, x19
mov	x2, #0
mov	w3, #1
bl Lpatch + (0xa634 - PATCH_BASE)
LFQH_Lloh658:
adr x1, LFQH_ListenColorKey
LFQH_Lloh659:
nop
mov	x0, x19
mov	x2, #0
mov	w3, #1
bl Lpatch + (0xa634 - PATCH_BASE)
LFQH_Lloh660:
adr x1, LFQH_ListenTintKey
LFQH_Lloh661:
nop
mov	x0, x19
mov	x2, #0
mov	w3, #1
bl Lpatch + (0xa634 - PATCH_BASE)
LFQH_Lloh662:
adr x1, LFQH_SurfaceKey
LFQH_Lloh663:
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
LFQH_LBB36_16:
LFQH_Lloh664:
adr x0, LFQH_l_.str.46
LFQH_Lloh665:
nop
bl Lpatch + (0xa5b0 - PATCH_BASE)
mov	x21, x0
LFQH_Lloh666:
adr x0, LFQH_l_.str.49
LFQH_Lloh667:
nop
bl Lpatch + (0xa5a4 - PATCH_BASE)
mov	x1, x0
mov	x0, x21
bl Lpatch + (0xa5d4 - PATCH_BASE)
mov	x21, x0
LFQH_Lloh668:
adr x0, LFQH_l_.str.50
LFQH_Lloh669:
nop
bl Lpatch + (0xa5a4 - PATCH_BASE)
mov	x1, x0
fmov	d0, #0.50000000
mov	x0, x21
bl Lpatch + (0xa5d4 - PATCH_BASE)
mov	x21, x0
LFQH_Lloh670:
adr x1, LFQH_l_.str.51
LFQH_Lloh671:
nop
mov	x0, x20
bl	LFQH_Get
mov	x22, x0
LFQH_Lloh672:
adr x0, LFQH_l_.str.52
LFQH_Lloh673:
nop
bl Lpatch + (0xa5a4 - PATCH_BASE)
mov	x1, x0
mov	x0, x22
bl Lpatch + (0xa5d4 - PATCH_BASE)
mov	x22, x0
LFQH_Lloh674:
adr x0, LFQH_l_.str.53
LFQH_Lloh675:
nop
bl Lpatch + (0xa5a4 - PATCH_BASE)
mov	x1, x0
mov	x0, x22
mov	x2, x21
bl Lpatch + (0xa5d4 - PATCH_BASE)
LFQH_Lloh676:
adr x0, LFQH_l_.str.54
LFQH_Lloh677:
nop
bl Lpatch + (0xa5a4 - PATCH_BASE)
mov	x1, x0
mov	x0, x20
mov	x2, x22
bl Lpatch + (0xa5d4 - PATCH_BASE)
LFQH_Lloh678:
adr x0, LFQH_l_.str.55
LFQH_Lloh679:
nop
bl Lpatch + (0xa5a4 - PATCH_BASE)
mov	x1, x0
mov	x0, x22
bl Lpatch + (0xa5d4 - PATCH_BASE)
LFQH_Lloh680:
adr x1, LFQH_ListenTintKey
LFQH_Lloh681:
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
LFQH_Lloh682:
adr x1, LFQH_l_.str.36
LFQH_Lloh683:
nop
bl	LFQH_Kind
cbz	w0, LFQH_LBB37_2
LFQH_Lloh684:
adr x1, LFQH_l_.str.335
LFQH_Lloh685:
nop
mov	x0, x20
bl	LFQH_Get
LFQH_Lloh686:
adr x1, LFQH_l_.str.336
LFQH_Lloh687:
nop
bl	LFQH_Equal
tbnz	w0, #0, LFQH_LBB37_5
LFQH_LBB37_2:
cbz	w19, LFQH_LBB37_4
LFQH_Lloh688:
adr x1, LFQH_l_.str.16
LFQH_Lloh689:
nop
mov	x0, x20
bl	LFQH_Kind
tbz	w0, #0, LFQH_LBB37_6
LFQH_LBB37_4:
mov	x20, #0
LFQH_LBB37_5:
mov	x0, x20
ldp	x29, x30, [sp, #48]
ldp	x20, x19, [sp, #32]
ldp	x22, x21, [sp, #16]
ldp	x24, x23, [sp], #64
ret
LFQH_LBB37_6:
LFQH_Lloh690:
adr x1, LFQH_l_.str.279
LFQH_Lloh691:
nop
mov	x0, x20
bl	LFQH_Get
mov	x21, x0
LFQH_Lloh692:
adr x0, LFQH_l_.str.34
LFQH_Lloh693:
nop
bl Lpatch + (0xa5a4 - PATCH_BASE)
mov	x1, x0
mov	x0, x21
bl Lpatch + (0xa5d4 - PATCH_BASE)
cmp	x0, #12
mov	w8, #12
csel	x24, x0, x8, lo
cbz	x0, LFQH_LBB37_4
mov	x22, #0
sub	w19, w19, #1
LFQH_Lloh694:
adr x23, LFQH_l_.str.327
LFQH_Lloh695:
nop
LFQH_LBB37_8:
mov	x0, x23
bl Lpatch + (0xa5a4 - PATCH_BASE)
mov	x1, x0
mov	x0, x21
mov	x2, x22
bl Lpatch + (0xa5d4 - PATCH_BASE)
mov	x1, x19
bl	LFQH_ListenCaption
cbnz	x0, LFQH_LBB37_10
add	x22, x22, #1
cmp	x24, x22
b.eq	LFQH_LBB37_4
b	LFQH_LBB37_8
LFQH_LBB37_10:
mov	x20, x0
b	LFQH_LBB37_5
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
LFQH_Lloh696:
adr x0, LFQH_l_.str.337
LFQH_Lloh697:
nop
bl Lpatch + (0xa5b0 - PATCH_BASE)
mov	x19, x0
LFQH_Lloh698:
adr x0, LFQH_l_.str.338
LFQH_Lloh699:
nop
bl Lpatch + (0xa5a4 - PATCH_BASE)
mov	x1, x0
mov	x0, x19
bl Lpatch + (0xa5d4 - PATCH_BASE)
mov	x19, x0
LFQH_Lloh700:
adr x1, LFQH_GlassPreferenceKey
LFQH_Lloh701:
nop
bl Lpatch + (0xa628 - PATCH_BASE)
mov	x20, x0
cbnz	x0, LFQH_LBB39_2
LFQH_Lloh702:
adr x0, LFQH_l_.str.244
LFQH_Lloh703:
nop
bl Lpatch + (0xa5b0 - PATCH_BASE)
mov	x20, x0
LFQH_Lloh704:
adr x0, LFQH_l_.str.245
LFQH_Lloh705:
nop
bl Lpatch + (0xa5a4 - PATCH_BASE)
mov	x1, x0
LFQH_Lloh706:
adr x2, LFQH_l_.str.339
LFQH_Lloh707:
nop
mov	x0, x20
bl Lpatch + (0xa5d4 - PATCH_BASE)
mov	x20, x0
LFQH_Lloh708:
adr x1, LFQH_GlassPreferenceKey
LFQH_Lloh709:
nop
mov	x0, x19
mov	x2, x20
mov	w3, #1
bl Lpatch + (0xa634 - PATCH_BASE)
LFQH_LBB39_2:
LFQH_Lloh710:
adr x0, LFQH_l_.str.340
LFQH_Lloh711:
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
cbz	x1, LFQH_LBB42_7
mov	x20, x1
LFQH_Lloh712:
adr x1, LFQH_ClipsKey
LFQH_Lloh713:
nop
mov	x0, x19
bl Lpatch + (0xa628 - PATCH_BASE)
cbnz	x0, LFQH_LBB42_3
LFQH_Lloh714:
adr x1, LFQH_HeaderClipsKey
LFQH_Lloh715:
nop
mov	x0, x19
bl Lpatch + (0xa628 - PATCH_BASE)
cbz	x0, LFQH_LBB42_6
LFQH_LBB42_3:
LFQH_Lloh716:
adr x0, LFQH_l_.str.46
LFQH_Lloh717:
nop
bl Lpatch + (0xa5b0 - PATCH_BASE)
mov	x21, x0
LFQH_Lloh718:
adr x0, LFQH_l_.str.80
LFQH_Lloh719:
nop
bl Lpatch + (0xa5a4 - PATCH_BASE)
mov	x1, x0
mov	x0, x21
bl Lpatch + (0xa5d4 - PATCH_BASE)
mov	x21, x0
LFQH_Lloh720:
adr x0, LFQH_l_.str.250
LFQH_Lloh721:
nop
bl Lpatch + (0xa5a4 - PATCH_BASE)
mov	x1, x0
mov	x0, x19
bl Lpatch + (0xa5d4 - PATCH_BASE)
cmp	x0, x21
b.eq	LFQH_LBB42_5
mov	x22, x0
LFQH_Lloh722:
adr x0, LFQH_l_.str.48
LFQH_Lloh723:
nop
bl Lpatch + (0xa5a4 - PATCH_BASE)
mov	x1, x0
mov	x0, x22
mov	x2, x21
bl Lpatch + (0xa5d4 - PATCH_BASE)
cbz	w0, LFQH_LBB42_6
LFQH_LBB42_5:
LFQH_Lloh724:
adr x0, LFQH_l_.str.79
LFQH_Lloh725:
nop
bl Lpatch + (0xa5a4 - PATCH_BASE)
mov	x21, x0
LFQH_Lloh726:
adr x1, LFQH_BackgroundKey
LFQH_Lloh727:
nop
mov	x0, x19
bl Lpatch + (0xa628 - PATCH_BASE)
mov	x2, x0
mov	x0, x19
mov	x1, x21
bl Lpatch + (0xa5d4 - PATCH_BASE)
LFQH_LBB42_6:
LFQH_Lloh728:
adr x0, LFQH_l_.str.302
LFQH_Lloh729:
nop
bl Lpatch + (0xa5a4 - PATCH_BASE)
mov	x1, x0
mov	x0, x20
bl Lpatch + (0xa5d4 - PATCH_BASE)
LFQH_Lloh730:
adr x1, LFQH_SurfaceKey
LFQH_Lloh731:
nop
mov	x0, x19
mov	x2, #0
mov	w3, #1
bl Lpatch + (0xa634 - PATCH_BASE)
LFQH_Lloh732:
adr x1, LFQH_BackgroundKey
LFQH_Lloh733:
nop
mov	x0, x19
mov	x2, #0
mov	w3, #1
bl Lpatch + (0xa634 - PATCH_BASE)
LFQH_LBB42_7:
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
cbz	x0, LFQH_LBB43_11
mov	x19, x0
mov	w25, #0
LFQH_Lloh734:
adr x20, LFQH_l_.str.247
LFQH_Lloh735:
nop
LFQH_Lloh736:
adr x21, LFQH_l_.str.56
LFQH_Lloh737:
nop
LFQH_Lloh738:
adr x22, LFQH_l_.str.58
LFQH_Lloh739:
nop
LFQH_Lloh740:
adr x23, LFQH_l_.str.20
LFQH_Lloh741:
nop
LFQH_LBB43_2:
mov	x0, x20
bl Lpatch + (0xa5a4 - PATCH_BASE)
mov	x24, x0
mov	x0, x21
bl Lpatch + (0xa5b0 - PATCH_BASE)
mov	x2, x0
mov	x0, x19
mov	x1, x24
bl Lpatch + (0xa5d4 - PATCH_BASE)
cbnz	w0, LFQH_LBB43_6
mov	x0, x20
bl Lpatch + (0xa5a4 - PATCH_BASE)
mov	x24, x0
mov	x0, x22
bl Lpatch + (0xa5b0 - PATCH_BASE)
mov	x2, x0
mov	x0, x19
mov	x1, x24
bl Lpatch + (0xa5d4 - PATCH_BASE)
cbnz	w0, LFQH_LBB43_9
mov	x0, x19
mov	x1, x23
bl	LFQH_Get
mov	x19, x0
mov	w0, #0
cbz	x19, LFQH_LBB43_11
cmp	w25, #3
add	w25, w25, #1
b.lo	LFQH_LBB43_2
b	LFQH_LBB43_11
LFQH_LBB43_6:
LFQH_Lloh742:
adr x1, LFQH_l_.str.20
LFQH_Lloh743:
nop
mov	x0, x19
bl	LFQH_Get
LFQH_Lloh744:
adr x1, LFQH_l_.str.57
LFQH_Lloh745:
nop
bl	LFQH_Kind
cbz	w0, LFQH_LBB43_11
mov	x0, x19
bl	LFQH_ReaderBottomType
sub	w8, w0, #4
cmn	w8, #3
b.hs	LFQH_LBB43_10
mov	w0, #0
b	LFQH_LBB43_11
LFQH_LBB43_9:
ldp	x29, x30, [sp, #64]
ldp	x20, x19, [sp, #48]
ldp	x22, x21, [sp, #32]
ldp	x24, x23, [sp, #16]
ldp	x26, x25, [sp], #80
b	LFQH_FQHGlassAvailable
LFQH_LBB43_10:
bl	LFQH_FQHGlassAvailable
LFQH_LBB43_11:
ldp	x29, x30, [sp, #64]
ldp	x20, x19, [sp, #48]
ldp	x22, x21, [sp, #32]
ldp	x24, x23, [sp, #16]
ldp	x26, x25, [sp], #80
ret
.cfi_endproc
.p2align	2
LFQH_FQHShelfOwnsAction:
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
LFQH_Lloh746:
adr x1, LFQH_l_.str.21
LFQH_Lloh747:
nop
mov	x0, x20
bl	LFQH_Kind
cbz	w0, LFQH_LBB44_5
LFQH_Lloh748:
adr x1, LFQH_l_.str.59
LFQH_Lloh749:
nop
mov	x0, x20
bl	LFQH_Responds
cbz	w0, LFQH_LBB44_10
LFQH_Lloh750:
adr x1, LFQH_l_.str.60
LFQH_Lloh751:
nop
mov	x0, x20
bl	LFQH_Get
cmp	x0, x19
b.eq	LFQH_LBB44_9
LFQH_Lloh752:
adr x1, LFQH_l_.str.61
LFQH_Lloh753:
nop
mov	x0, x20
bl	LFQH_Get
cmp	x0, x19
b.eq	LFQH_LBB44_9
LFQH_Lloh754:
adr x1, LFQH_l_.str.62
LFQH_Lloh755:
nop
b	LFQH_LBB44_8
LFQH_LBB44_5:
LFQH_Lloh756:
adr x1, LFQH_l_.str.63
LFQH_Lloh757:
nop
mov	x0, x20
bl	LFQH_Kind
cbz	w0, LFQH_LBB44_10
LFQH_Lloh758:
adr x1, LFQH_l_.str.64
LFQH_Lloh759:
nop
mov	x0, x20
bl	LFQH_Responds
cbz	w0, LFQH_LBB44_10
LFQH_Lloh760:
adr x1, LFQH_l_.str.61
LFQH_Lloh761:
nop
LFQH_LBB44_8:
mov	x0, x20
bl	LFQH_Get
cmp	x0, x19
cset	w0, eq
b	LFQH_LBB44_10
LFQH_LBB44_9:
mov	w0, #1
LFQH_LBB44_10:
ldp	x29, x30, [sp, #16]
ldp	x20, x19, [sp], #32
ret
.cfi_endproc
.p2align	2
LFQH_FQHPageFilterMiniGame:
.cfi_startproc
cbz	x0, LFQH_LBB45_9
stp	x20, x19, [sp, #-32]!
stp	x29, x30, [sp, #16]
add	x29, sp, #16
.cfi_def_cfa w29, 16
.cfi_offset w30, -8
.cfi_offset w29, -16
.cfi_offset w19, -24
.cfi_offset w20, -32
mov	x20, x0
LFQH_Lloh762:
adr x1, LFQH_l_.str.65
LFQH_Lloh763:
nop
bl	LFQH_Get
mov	x19, x0
bl	LFQH_MineStandaloneGameRow
cbz	w0, LFQH_LBB45_8
mov	x0, x19
bl Lpatch + (0xa664 - PATCH_BASE)
LFQH_Lloh764:
adr x1, LFQH_l_.str.66
LFQH_Lloh765:
nop
LFQH_Lloh766:
adr x2, LFQH_l_.str.67
LFQH_Lloh767:
nop
bl	LFQH_ClassABI
cbz	w0, LFQH_LBB45_8
mov	x0, x19
bl Lpatch + (0xa664 - PATCH_BASE)
LFQH_Lloh768:
adr x1, LFQH_l_.str.68
LFQH_Lloh769:
nop
LFQH_Lloh770:
adr x2, LFQH_l_.str.67
LFQH_Lloh771:
nop
bl	LFQH_ClassABI
cbz	w0, LFQH_LBB45_8
LFQH_Lloh772:
adr x0, LFQH_l_.str.66
LFQH_Lloh773:
nop
bl Lpatch + (0xa5a4 - PATCH_BASE)
mov	x1, x0
mov	x0, x19
mov	w2, #1
bl Lpatch + (0xa5d4 - PATCH_BASE)
LFQH_Lloh774:
adr x0, LFQH_l_.str.68
LFQH_Lloh775:
nop
bl Lpatch + (0xa5a4 - PATCH_BASE)
mov	x1, x0
mov	x0, x19
mov	w2, #1
bl Lpatch + (0xa5d4 - PATCH_BASE)
LFQH_Lloh776:
adr x1, LFQH_l_.str.69
LFQH_Lloh777:
nop
mov	x0, x20
bl	LFQH_Get
mov	x20, x0
LFQH_Lloh778:
adr x1, LFQH_l_.str.70
LFQH_Lloh779:
nop
bl	LFQH_Kind
cbz	w0, LFQH_LBB45_7
LFQH_Lloh780:
adr x1, LFQH_l_.str.71
LFQH_Lloh781:
nop
mov	x0, x20
bl	LFQH_Responds
cbz	w0, LFQH_LBB45_7
LFQH_Lloh782:
adr x0, LFQH_l_.str.71
LFQH_Lloh783:
nop
bl Lpatch + (0xa5a4 - PATCH_BASE)
mov	x1, x0
mov	x0, x20
mov	x2, x19
bl Lpatch + (0xa5d4 - PATCH_BASE)
LFQH_LBB45_7:
LFQH_Lloh784:
adr x0, LFQH_l_.str.72
LFQH_Lloh785:
nop
LFQH_Lloh786:
adr x1, LFQH_l_.str.73
LFQH_Lloh787:
nop
bl	LFQH_RecordMineGameRemoval
mov	w0, #1
LFQH_LBB45_8:
ldp	x29, x30, [sp, #16]
ldp	x20, x19, [sp], #32
LFQH_LBB45_9:
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
LFQH_Lloh788:
adr x1, LFQH_l_.str.345
LFQH_Lloh789:
nop
bl	LFQH_Kind
cbz	w0, LFQH_LBB46_2
LFQH_Lloh790:
adr x1, LFQH_l_.str.346
LFQH_Lloh791:
nop
mov	x0, x19
bl	LFQH_Kind
cmp	w0, #0
cset	w0, eq
LFQH_LBB46_2:
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
LFQH_Lloh792:
adr x0, LFQH_l_.str.273
LFQH_Lloh793:
nop
bl Lpatch + (0xa5b0 - PATCH_BASE)
mov	x20, x0
LFQH_Lloh794:
adr x0, LFQH_l_.str.274
LFQH_Lloh795:
nop
bl Lpatch + (0xa5a4 - PATCH_BASE)
mov	x1, x0
mov	x0, x20
bl Lpatch + (0xa5d4 - PATCH_BASE)
mov	x20, x0
LFQH_Lloh796:
adr x21, LFQH_l_.str.244
LFQH_Lloh797:
nop
mov	x0, x21
bl Lpatch + (0xa5b0 - PATCH_BASE)
mov	x24, x0
LFQH_Lloh798:
adr x22, LFQH_l_.str.245
LFQH_Lloh799:
nop
mov	x0, x22
bl Lpatch + (0xa5a4 - PATCH_BASE)
mov	x1, x0
LFQH_Lloh800:
adr x2, LFQH_l_.str.348
LFQH_Lloh801:
nop
mov	x0, x24
bl Lpatch + (0xa5d4 - PATCH_BASE)
mov	x2, x0
LFQH_Lloh802:
adr x1, LFQH_l_.str.347
LFQH_Lloh803:
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
LFQH_Lloh804:
adr x1, LFQH_l_.str.349
LFQH_Lloh805:
nop
mov	x0, x20
bl	LFQH_Put
mov	x0, x21
bl Lpatch + (0xa5b0 - PATCH_BASE)
mov	x23, x0
mov	x0, x22
bl Lpatch + (0xa5a4 - PATCH_BASE)
mov	x1, x0
LFQH_Lloh806:
adr x2, LFQH_l_.str.351
LFQH_Lloh807:
nop
mov	x0, x23
bl Lpatch + (0xa5d4 - PATCH_BASE)
mov	x2, x0
LFQH_Lloh808:
adr x1, LFQH_l_.str.350
LFQH_Lloh809:
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
LFQH_Lloh810:
adr x1, LFQH_l_.str.352
LFQH_Lloh811:
nop
mov	x0, x20
bl	LFQH_Put
LFQH_Lloh812:
adr x0, LFQH_l_.str.353
LFQH_Lloh813:
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
LFQH_Lloh814:
adr x1, LFQH_l_.str.74
LFQH_Lloh815:
nop
bl	LFQH_Get
cbz	x0, LFQH_LBB48_2
mov	x19, x0
LFQH_Lloh816:
adr x1, LFQH_l_.str.75
LFQH_Lloh817:
nop
bl	LFQH_Get
cbz	x0, LFQH_LBB48_3
LFQH_LBB48_2:
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
LFQH_LBB48_3:
bl	LFQH_ToggleObserver
cbz	x0, LFQH_LBB48_2
mov	x20, x0
LFQH_Lloh818:
adr x0, LFQH_l_.str.76
LFQH_Lloh819:
nop
bl Lpatch + (0xa5a4 - PATCH_BASE)
mov	x1, x0
mov	x0, x20
bl Lpatch + (0xa5d4 - PATCH_BASE)
mov	x20, x0
LFQH_Lloh820:
adr x0, LFQH_l_.str.77
LFQH_Lloh821:
nop
bl Lpatch + (0xa5a4 - PATCH_BASE)
mov	x1, x0
mov	x0, x20
bl Lpatch + (0xa5d4 - PATCH_BASE)
str	x0, [sp, #8]
cbz	x0, LFQH_LBB48_2
LFQH_Lloh822:
adr x0, LFQH_l_.str.23
LFQH_Lloh823:
nop
bl Lpatch + (0xa5b0 - PATCH_BASE)
mov	x20, x0
LFQH_Lloh824:
adr x0, LFQH_l_.str.76
LFQH_Lloh825:
nop
bl Lpatch + (0xa5a4 - PATCH_BASE)
mov	x1, x0
mov	x0, x20
bl Lpatch + (0xa5d4 - PATCH_BASE)
mov	x20, x0
LFQH_Lloh826:
adr x0, LFQH_l_.str.77
LFQH_Lloh827:
nop
bl Lpatch + (0xa5a4 - PATCH_BASE)
mov	x1, x0
mov	x0, x20
bl Lpatch + (0xa5d4 - PATCH_BASE)
cbz	x0, LFQH_LBB48_29
mov	x21, x0
LFQH_Lloh828:
adr x0, LFQH_l_.str.24
LFQH_Lloh829:
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
LFQH_Lloh830:
adr x0, LFQH_l_.str.78
LFQH_Lloh831:
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
LFQH_Lloh832:
adr x0, LFQH_l_.str.79
LFQH_Lloh833:
nop
bl Lpatch + (0xa5a4 - PATCH_BASE)
mov	x20, x0
LFQH_Lloh834:
adr x0, LFQH_l_.str.46
LFQH_Lloh835:
nop
bl Lpatch + (0xa5b0 - PATCH_BASE)
mov	x22, x0
LFQH_Lloh836:
adr x0, LFQH_l_.str.80
LFQH_Lloh837:
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
LFQH_Lloh838:
adr x26, LFQH_l_.str.76
LFQH_Lloh839:
nop
LFQH_Lloh840:
adr x19, LFQH_l_.str.77
LFQH_Lloh841:
nop
mov	x8, #-4586916220476850176
fmov	d13, x8
mov	x8, #-4588042120383692800
fmov	d14, x8
mov	x8, #4634204016564240384
fmov	d9, x8
LFQH_LBB48_7:
cmp	x25, #3
b.le	LFQH_LBB48_12
cmp	x25, #5
b.gt	LFQH_LBB48_16
cmp	x25, #4
b.eq	LFQH_LBB48_21
cmp	x25, #5
b.ne	LFQH_LBB48_20
LFQH_Lloh842:
adr x22, LFQH_l_.str.426
LFQH_Lloh843:
nop
b	LFQH_LBB48_24
LFQH_LBB48_12:
cmp	x25, #1
b.eq	LFQH_LBB48_19
cmp	x25, #2
b.eq	LFQH_LBB48_23
cmp	x25, #3
b.ne	LFQH_LBB48_20
LFQH_Lloh844:
adr x22, LFQH_l_.str.424
LFQH_Lloh845:
nop
b	LFQH_LBB48_24
LFQH_LBB48_16:
cmp	x25, #6
b.eq	LFQH_LBB48_22
cmp	x25, #7
b.ne	LFQH_LBB48_20
LFQH_Lloh846:
adr x22, LFQH_l_.str.428
LFQH_Lloh847:
nop
b	LFQH_LBB48_24
LFQH_LBB48_19:
LFQH_Lloh848:
adr x22, LFQH_l_.str.422
LFQH_Lloh849:
nop
b	LFQH_LBB48_24
LFQH_LBB48_20:
LFQH_Lloh850:
adr x22, LFQH_l_.str.429
LFQH_Lloh851:
nop
b	LFQH_LBB48_24
LFQH_LBB48_21:
LFQH_Lloh852:
adr x22, LFQH_l_.str.425
LFQH_Lloh853:
nop
b	LFQH_LBB48_24
LFQH_LBB48_22:
LFQH_Lloh854:
adr x22, LFQH_l_.str.427
LFQH_Lloh855:
nop
b	LFQH_LBB48_24
LFQH_LBB48_23:
LFQH_Lloh856:
adr x22, LFQH_l_.str.423
LFQH_Lloh857:
nop
LFQH_LBB48_24:
LFQH_Lloh858:
adr x0, LFQH_l_.str.244
LFQH_Lloh859:
nop
bl Lpatch + (0xa5b0 - PATCH_BASE)
mov	x27, x0
LFQH_Lloh860:
adr x0, LFQH_l_.str.245
LFQH_Lloh861:
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
LFQH_Lloh862:
adr x0, LFQH_l_.str.24
LFQH_Lloh863:
nop
bl Lpatch + (0xa5a4 - PATCH_BASE)
mov	x1, x0
mov	x0, x21
bl Lpatch + (0xa5d4 - PATCH_BASE)
mov.16b	v10, v2
LFQH_Lloh864:
adr x0, LFQH_l_.str.36
LFQH_Lloh865:
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
cbz	x0, LFQH_LBB48_27
mov	x22, x0
sub	x8, x24, #2
ucvtf	d11, x8
fadd	d12, d10, d13
LFQH_Lloh866:
adr x0, LFQH_l_.str.78
LFQH_Lloh867:
nop
bl Lpatch + (0xa5a4 - PATCH_BASE)
mov	x1, x0
fmov	d0, #16.00000000
fmov	d3, #30.00000000
mov	x0, x22
mov.16b	v1, v11
mov.16b	v2, v12
bl Lpatch + (0xa5d4 - PATCH_BASE)
LFQH_Lloh868:
adr x0, LFQH_l_.str.81
LFQH_Lloh869:
nop
bl Lpatch + (0xa5a4 - PATCH_BASE)
mov	x1, x0
mov	x0, x22
mov	x2, x27
bl Lpatch + (0xa5d4 - PATCH_BASE)
LFQH_Lloh870:
adr x0, LFQH_l_.str.84
LFQH_Lloh871:
nop
bl Lpatch + (0xa5a4 - PATCH_BASE)
mov	x23, x0
LFQH_Lloh872:
adr x0, LFQH_l_.str.85
LFQH_Lloh873:
nop
bl Lpatch + (0xa5b0 - PATCH_BASE)
mov	x20, x26
mov	x26, x0
LFQH_Lloh874:
adr x0, LFQH_l_.str.86
LFQH_Lloh875:
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
LFQH_Lloh876:
adr x0, LFQH_l_.str.44
LFQH_Lloh877:
nop
bl Lpatch + (0xa5a4 - PATCH_BASE)
mov	x23, x0
LFQH_Lloh878:
adr x0, LFQH_l_.str.46
LFQH_Lloh879:
nop
bl Lpatch + (0xa5b0 - PATCH_BASE)
mov	x26, x0
LFQH_Lloh880:
adr x0, LFQH_l_.str.47
LFQH_Lloh881:
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
LFQH_Lloh882:
adr x0, LFQH_l_.str.88
LFQH_Lloh883:
nop
bl Lpatch + (0xa5a4 - PATCH_BASE)
mov	x1, x0
mov	x0, x22
mov	w2, #2
bl Lpatch + (0xa5d4 - PATCH_BASE)
LFQH_Lloh884:
adr x0, LFQH_l_.str.89
LFQH_Lloh885:
nop
bl Lpatch + (0xa5a4 - PATCH_BASE)
mov	x1, x0
mov	x0, x21
mov	x2, x22
bl Lpatch + (0xa5d4 - PATCH_BASE)
LFQH_Lloh886:
adr x0, LFQH_l_.str.55
LFQH_Lloh887:
nop
bl Lpatch + (0xa5a4 - PATCH_BASE)
mov	x1, x0
mov	x0, x22
bl Lpatch + (0xa5d4 - PATCH_BASE)
LFQH_Lloh888:
adr x0, LFQH_l_.str.419
LFQH_Lloh889:
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
cbz	x0, LFQH_LBB48_27
mov	x22, x0
fadd	d10, d10, d14
ucvtf	d11, x24
LFQH_Lloh890:
adr x0, LFQH_l_.str.78
LFQH_Lloh891:
nop
bl Lpatch + (0xa5a4 - PATCH_BASE)
mov	x1, x0
fmov	d3, #31.00000000
mov	x0, x22
mov.16b	v0, v10
mov.16b	v1, v11
mov.16b	v2, v9
bl Lpatch + (0xa5d4 - PATCH_BASE)
LFQH_Lloh892:
adr x0, LFQH_l_.str.420
LFQH_Lloh893:
nop
bl Lpatch + (0xa5a4 - PATCH_BASE)
mov	x1, x0
mov	x0, x22
mov	x2, x25
bl Lpatch + (0xa5d4 - PATCH_BASE)
LFQH_Lloh894:
adr x0, LFQH_l_.str.88
LFQH_Lloh895:
nop
bl Lpatch + (0xa5a4 - PATCH_BASE)
mov	x1, x0
mov	x0, x22
mov	w2, #17
bl Lpatch + (0xa5d4 - PATCH_BASE)
LFQH_Lloh896:
adr x0, LFQH_l_.str.384
LFQH_Lloh897:
nop
bl Lpatch + (0xa5a4 - PATCH_BASE)
mov	x1, x0
mov	x0, x22
mov	x2, x28
mov	w3, #0
bl Lpatch + (0xa5d4 - PATCH_BASE)
LFQH_Lloh898:
adr x0, LFQH_l_.str.309
LFQH_Lloh899:
nop
bl Lpatch + (0xa5a4 - PATCH_BASE)
mov	x23, x0
LFQH_Lloh900:
adr x0, LFQH_l_.str.377
LFQH_Lloh901:
nop
bl Lpatch + (0xa5a4 - PATCH_BASE)
mov	x3, x0
mov	x0, x22
mov	x1, x23
ldr	x2, [sp, #8]
mov	w4, #4096
bl Lpatch + (0xa5d4 - PATCH_BASE)
LFQH_Lloh902:
adr x0, LFQH_l_.str.421
LFQH_Lloh903:
nop
bl Lpatch + (0xa5a4 - PATCH_BASE)
mov	x1, x0
mov	x0, x22
mov	x2, x27
bl Lpatch + (0xa5d4 - PATCH_BASE)
LFQH_Lloh904:
adr x0, LFQH_l_.str.89
LFQH_Lloh905:
nop
bl Lpatch + (0xa5a4 - PATCH_BASE)
mov	x1, x0
mov	x0, x21
mov	x2, x22
bl Lpatch + (0xa5d4 - PATCH_BASE)
LFQH_Lloh906:
adr x0, LFQH_l_.str.55
LFQH_Lloh907:
nop
bl Lpatch + (0xa5a4 - PATCH_BASE)
mov	x1, x0
mov	x0, x22
bl Lpatch + (0xa5d4 - PATCH_BASE)
LFQH_LBB48_27:
add	x25, x25, #1
add	x24, x24, #42
cmp	x24, #346
b.ne	LFQH_LBB48_7
LFQH_Lloh908:
adr x0, LFQH_l_.str.36
LFQH_Lloh909:
nop
bl Lpatch + (0xa5b0 - PATCH_BASE)
mov	x20, x0
LFQH_Lloh910:
adr x0, LFQH_l_.str.76
LFQH_Lloh911:
nop
bl Lpatch + (0xa5a4 - PATCH_BASE)
mov	x1, x0
mov	x0, x20
bl Lpatch + (0xa5d4 - PATCH_BASE)
mov	x20, x0
LFQH_Lloh912:
adr x0, LFQH_l_.str.77
LFQH_Lloh913:
nop
bl Lpatch + (0xa5a4 - PATCH_BASE)
mov	x1, x0
mov	x0, x20
bl Lpatch + (0xa5d4 - PATCH_BASE)
mov	x20, x0
mov	x8, #-4593671619917905920
fmov	d0, x8
fadd	d8, d8, d0
LFQH_Lloh914:
adr x0, LFQH_l_.str.78
LFQH_Lloh915:
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
LFQH_Lloh916:
adr x0, LFQH_l_.str.81
LFQH_Lloh917:
nop
bl Lpatch + (0xa5a4 - PATCH_BASE)
mov	x22, x0
LFQH_Lloh918:
adr x0, LFQH_l_.str.244
LFQH_Lloh919:
nop
bl Lpatch + (0xa5b0 - PATCH_BASE)
mov	x23, x0
LFQH_Lloh920:
adr x0, LFQH_l_.str.245
LFQH_Lloh921:
nop
bl Lpatch + (0xa5a4 - PATCH_BASE)
mov	x1, x0
LFQH_Lloh922:
adr x2, LFQH_l_.str.82
LFQH_Lloh923:
nop
mov	x0, x23
bl Lpatch + (0xa5d4 - PATCH_BASE)
mov	x2, x0
mov	x0, x20
mov	x1, x22
bl Lpatch + (0xa5d4 - PATCH_BASE)
LFQH_Lloh924:
adr x0, LFQH_l_.str.83
LFQH_Lloh925:
nop
bl Lpatch + (0xa5a4 - PATCH_BASE)
mov	x1, x0
mov	x0, x20
mov	w2, #2
bl Lpatch + (0xa5d4 - PATCH_BASE)
LFQH_Lloh926:
adr x0, LFQH_l_.str.84
LFQH_Lloh927:
nop
bl Lpatch + (0xa5a4 - PATCH_BASE)
mov	x22, x0
LFQH_Lloh928:
adr x0, LFQH_l_.str.85
LFQH_Lloh929:
nop
bl Lpatch + (0xa5b0 - PATCH_BASE)
mov	x23, x0
LFQH_Lloh930:
adr x0, LFQH_l_.str.86
LFQH_Lloh931:
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
LFQH_Lloh932:
adr x0, LFQH_l_.str.44
LFQH_Lloh933:
nop
bl Lpatch + (0xa5a4 - PATCH_BASE)
mov	x22, x0
LFQH_Lloh934:
adr x0, LFQH_l_.str.46
LFQH_Lloh935:
nop
bl Lpatch + (0xa5b0 - PATCH_BASE)
mov	x23, x0
LFQH_Lloh936:
adr x0, LFQH_l_.str.87
LFQH_Lloh937:
nop
bl Lpatch + (0xa5a4 - PATCH_BASE)
mov	x1, x0
mov	x0, x23
bl Lpatch + (0xa5d4 - PATCH_BASE)
mov	x2, x0
mov	x0, x20
mov	x1, x22
bl Lpatch + (0xa5d4 - PATCH_BASE)
LFQH_Lloh938:
adr x0, LFQH_l_.str.88
LFQH_Lloh939:
nop
bl Lpatch + (0xa5a4 - PATCH_BASE)
mov	x1, x0
mov	x0, x20
mov	w2, #2
bl Lpatch + (0xa5d4 - PATCH_BASE)
LFQH_Lloh940:
adr x0, LFQH_l_.str.89
LFQH_Lloh941:
nop
bl Lpatch + (0xa5a4 - PATCH_BASE)
mov	x1, x0
mov	x0, x21
mov	x2, x20
bl Lpatch + (0xa5d4 - PATCH_BASE)
LFQH_Lloh942:
adr x22, LFQH_l_.str.55
LFQH_Lloh943:
nop
mov	x0, x22
bl Lpatch + (0xa5a4 - PATCH_BASE)
mov	x1, x0
mov	x0, x20
bl Lpatch + (0xa5d4 - PATCH_BASE)
LFQH_Lloh944:
adr x1, LFQH_ToggleObserverKey
LFQH_Lloh945:
nop
mov	x0, x21
ldr	x2, [sp, #8]
mov	w3, #1
bl Lpatch + (0xa634 - PATCH_BASE)
LFQH_Lloh946:
adr x0, LFQH_l_.str.90
LFQH_Lloh947:
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
LFQH_LBB48_29:
LFQH_Lloh948:
adr x0, LFQH_l_.str.55
LFQH_Lloh949:
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
LFQH_Lloh950:
adr x0, LFQH_l_.str.375
LFQH_Lloh951:
nop
bl Lpatch + (0xa5b0 - PATCH_BASE)
mov	x19, x0
cbnz	x0, LFQH_LBB49_3
LFQH_Lloh952:
adr x0, LFQH_l_.str.376
LFQH_Lloh953:
nop
bl Lpatch + (0xa5b0 - PATCH_BASE)
LFQH_Lloh954:
adr x1, LFQH_l_.str.375
LFQH_Lloh955:
nop
mov	x2, #0
bl Lpatch + (0xa61c - PATCH_BASE)
mov	x19, x0
cbz	x0, LFQH_LBB49_3
LFQH_Lloh956:
adr x0, LFQH_l_.str.377
LFQH_Lloh957:
nop
bl Lpatch + (0xa5a4 - PATCH_BASE)
mov	x1, x0
LFQH_Lloh958:
adr x2, LFQH_ToggleChanged
LFQH_Lloh959:
nop
LFQH_Lloh960:
adr x20, LFQH_l_.str.120
LFQH_Lloh961:
nop
mov	x0, x19
mov	x3, x20
bl Lpatch + (0xa58c - PATCH_BASE)
LFQH_Lloh962:
adr x0, LFQH_l_.str.378
LFQH_Lloh963:
nop
bl Lpatch + (0xa5a4 - PATCH_BASE)
mov	x1, x0
LFQH_Lloh964:
adr x2, LFQH_RecoverOptions
LFQH_Lloh965:
nop
mov	x0, x19
mov	x3, x20
bl Lpatch + (0xa58c - PATCH_BASE)
LFQH_Lloh966:
adr x0, LFQH_l_.str.379
LFQH_Lloh967:
nop
bl Lpatch + (0xa5a4 - PATCH_BASE)
mov	x1, x0
LFQH_Lloh968:
adr x2, LFQH_RecoveryTouch
LFQH_Lloh969:
nop
LFQH_Lloh970:
adr x3, LFQH_l_.str.380
LFQH_Lloh971:
nop
mov	x0, x19
bl Lpatch + (0xa58c - PATCH_BASE)
mov	x0, x19
bl Lpatch + (0xa610 - PATCH_BASE)
LFQH_LBB49_3:
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
LFQH_Lloh972:
adr x0, LFQH_l_.str.337
LFQH_Lloh973:
nop
bl Lpatch + (0xa5b0 - PATCH_BASE)
mov	x20, x0
LFQH_Lloh974:
adr x0, LFQH_l_.str.338
LFQH_Lloh975:
nop
bl Lpatch + (0xa5a4 - PATCH_BASE)
mov	x1, x0
mov	x0, x20
bl Lpatch + (0xa5d4 - PATCH_BASE)
mov	x20, x0
LFQH_Lloh976:
adr x0, LFQH_l_.str.430
LFQH_Lloh977:
nop
bl Lpatch + (0xa5a4 - PATCH_BASE)
mov	x1, x0
mov	x0, x20
mov	x2, x19
bl Lpatch + (0xa5d4 - PATCH_BASE)
cbz	x0, LFQH_LBB50_2
LFQH_Lloh978:
adr x1, LFQH_l_.str.40
LFQH_Lloh979:
nop
ldp	x29, x30, [sp, #16]
ldp	x20, x19, [sp], #32
b	LFQH_BoolProp
LFQH_LBB50_2:
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
b.gt	LFQH_LBB51_5
cmp	x0, #2
b.gt	LFQH_LBB51_9
cmp	x0, #1
b.eq	LFQH_LBB51_15
cmp	x0, #2
b.ne	LFQH_LBB51_20
LFQH_Lloh980:
adr x19, LFQH_l_.str.432
LFQH_Lloh981:
nop
b	LFQH_LBB51_19
LFQH_LBB51_5:
cmp	x0, #6
b.gt	LFQH_LBB51_12
cmp	x0, #5
b.eq	LFQH_LBB51_16
cmp	x0, #6
b.ne	LFQH_LBB51_20
LFQH_Lloh982:
adr x19, LFQH_l_.str.436
LFQH_Lloh983:
nop
b	LFQH_LBB51_19
LFQH_LBB51_9:
cmp	x0, #3
b.eq	LFQH_LBB51_17
cmp	x0, #4
b.ne	LFQH_LBB51_20
LFQH_Lloh984:
adr x19, LFQH_l_.str.434
LFQH_Lloh985:
nop
b	LFQH_LBB51_19
LFQH_LBB51_12:
cmp	x0, #7
b.eq	LFQH_LBB51_18
cmp	x0, #8
b.ne	LFQH_LBB51_20
LFQH_Lloh986:
adr x19, LFQH_l_.str.438
LFQH_Lloh987:
nop
b	LFQH_LBB51_19
LFQH_LBB51_15:
LFQH_Lloh988:
adr x19, LFQH_l_.str.431
LFQH_Lloh989:
nop
b	LFQH_LBB51_19
LFQH_LBB51_16:
LFQH_Lloh990:
adr x19, LFQH_l_.str.435
LFQH_Lloh991:
nop
b	LFQH_LBB51_19
LFQH_LBB51_17:
LFQH_Lloh992:
adr x19, LFQH_l_.str.433
LFQH_Lloh993:
nop
b	LFQH_LBB51_19
LFQH_LBB51_18:
LFQH_Lloh994:
adr x19, LFQH_l_.str.437
LFQH_Lloh995:
nop
LFQH_LBB51_19:
LFQH_Lloh996:
adr x0, LFQH_l_.str.244
LFQH_Lloh997:
nop
bl Lpatch + (0xa5b0 - PATCH_BASE)
mov	x20, x0
LFQH_Lloh998:
adr x0, LFQH_l_.str.245
LFQH_Lloh999:
nop
bl Lpatch + (0xa5a4 - PATCH_BASE)
mov	x1, x0
mov	x0, x20
mov	x2, x19
ldp	x29, x30, [sp, #16]
ldp	x20, x19, [sp], #32
b Lpatch + (0xa5d4 - PATCH_BASE)
LFQH_LBB51_20:
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
LFQH_Lloh1000:
adr x1, LFQH_l_.str.91
LFQH_Lloh1001:
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
LFQH_Lloh1002:
adr x0, LFQH_l_.str.24
LFQH_Lloh1003:
nop
bl Lpatch + (0xa5a4 - PATCH_BASE)
mov	x1, x0
mov	x0, x19
bl Lpatch + (0xa5d4 - PATCH_BASE)
mov.16b	v9, v0
mov.16b	v8, v1
mov.16b	v11, v2
mov.16b	v10, v3
mov	x0, x21
bl Lpatch + (0xa664 - PATCH_BASE)
LFQH_Lloh1004:
adr x1, LFQH_l_.str.439
LFQH_Lloh1005:
nop
LFQH_Lloh1006:
adr x2, LFQH_l_.str.440
LFQH_Lloh1007:
nop
bl	LFQH_ClassABI
fmov	d12, xzr
fmov	d0, xzr
cbz	w0, LFQH_LBB55_2
LFQH_Lloh1008:
adr x0, LFQH_l_.str.439
LFQH_Lloh1009:
nop
bl Lpatch + (0xa5a4 - PATCH_BASE)
mov	x1, x0
mov	x0, x21
bl Lpatch + (0xa5d4 - PATCH_BASE)
LFQH_LBB55_2:
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
LFQH_Lloh1010:
adr x1, LFQH_SurfaceKey
LFQH_Lloh1011:
nop
mov	x0, x19
bl Lpatch + (0xa628 - PATCH_BASE)
mov	x21, x0
mov	x1, x20
mov	w2, #0
bl	LFQH_ShelfTint
LFQH_Lloh1012:
adr x1, LFQH_l_.str.441
LFQH_Lloh1013:
nop
mov	x0, x19
bl	LFQH_Get
cmp	x21, #0
cset	w20, ne
mov	x1, x20
bl	LFQH_ShelfTitleFont
LFQH_Lloh1014:
adr x1, LFQH_l_.str.442
LFQH_Lloh1015:
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
LFQH_FQHBookstoreAdInstall:
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
LFQH_Lloh1016:
adr x0, LFQH_l_.str.92
LFQH_Lloh1017:
nop
bl Lpatch + (0xa5b0 - PATCH_BASE)
LFQH_Lloh1018:
adr x1, LFQH_l_.str.93
LFQH_Lloh1019:
nop
LFQH_Lloh1020:
adr x2, LFQH_l_.str.94
LFQH_Lloh1021:
nop
bl	LFQH_ClassABI
mov	x19, x0
LFQH_Lloh1022:
adr x0, LFQH_l_.str.95
LFQH_Lloh1023:
nop
bl Lpatch + (0xa5b0 - PATCH_BASE)
cbz	x0, LFQH_LBB56_5
mov	x20, x0
LFQH_Lloh1024:
adr x0, LFQH_l_.str.96
LFQH_Lloh1025:
nop
bl Lpatch + (0xa5a4 - PATCH_BASE)
mov	x1, x0
LFQH_Lloh1026:
adr x3, LFQH_l_.str.97
LFQH_Lloh1027:
nop
mov	x0, x20
mov	w2, #0
bl LHookOwned
cbz	x0, LFQH_LBB56_4
mov	x20, x0
LFQH_Lloh1028:
adr x21, LFQH_l_.str.98
LFQH_Lloh1029:
nop
LFQH_Lloh1030:
adr x1, LFQH_l_.str.99
LFQH_Lloh1031:
nop
LFQH_Lloh1032:
adr x22, LFQH_l_.str.100
LFQH_Lloh1033:
nop
LFQH_Lloh1034:
adr x23, LFQH_l_.str.101
LFQH_Lloh1035:
nop
LFQH_Lloh1036:
adr x4, LFQH_BookstorePopupHandler
LFQH_Lloh1037:
nop
mov	x0, x21
mov	x2, x22
mov	x3, x23
bl	LFQH_Hook
mov	x0, x21
bl Lpatch + (0xa5b0 - PATCH_BASE)
mov	x1, x22
mov	x2, x23
bl	LFQH_ClassABI
cbz	w0, LFQH_LBB56_4
LFQH_Lloh1038:
adr x1, LFQH_DenyBookstorePopup
LFQH_Lloh1039:
nop
mov	x0, x20
bl Lpatch + (0xa580 - PATCH_BASE)
b	LFQH_LBB56_5
LFQH_LBB56_4:
mov	w19, #0
LFQH_LBB56_5:
mov	x0, x19
ldp	x29, x30, [sp, #48]
ldp	x20, x19, [sp, #32]
ldp	x22, x21, [sp, #16]
ldp	x24, x23, [sp], #64
ret
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
cbz	x0, LFQH_LBB57_2
mov	x21, x0
mov	x0, x22
bl Lpatch + (0xa5a4 - PATCH_BASE)
mov	x1, x0
mov	x0, x21
bl Lpatch + (0xa5f8 - PATCH_BASE)
cbz	x0, LFQH_LBB57_3
LFQH_LBB57_2:
ldp	x29, x30, [sp, #48]
ldp	x20, x19, [sp, #32]
ldp	x22, x21, [sp, #16]
ldp	x24, x23, [sp], #64
ret
LFQH_LBB57_3:
mov	x0, x23
bl Lpatch + (0xa5a4 - PATCH_BASE)
mov	x1, x0
mov	x0, x21
mov	w2, #0
mov	x3, x20
bl LHookOwned
cbz	x0, LFQH_LBB57_2
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
cbz	w0, LFQH_LBB57_2
mov	x0, x23
mov	x1, x19
ldp	x29, x30, [sp, #48]
ldp	x20, x19, [sp, #32]
ldp	x22, x21, [sp, #16]
ldp	x24, x23, [sp], #64
b Lpatch + (0xa580 - PATCH_BASE)
.cfi_endproc
.p2align	2
LFQH_BookstorePopupHandler:
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
LFQH_Lloh1040:
adr x0, LFQH_l_.str.98
LFQH_Lloh1041:
nop
LFQH_Lloh1042:
adr x1, LFQH_l_.str.100
LFQH_Lloh1043:
nop
bl	LFQH_Original
mov	x8, x0
mov	x0, x21
mov	x1, x20
mov	x2, x19
blr	x8
mov	x19, x0
LFQH_Lloh1044:
adr x1, LFQH_l_.str.95
LFQH_Lloh1045:
nop
bl	LFQH_Kind
cbz	w0, LFQH_LBB58_2
LFQH_Lloh1046:
adr x0, LFQH_l_.str.273
LFQH_Lloh1047:
nop
bl Lpatch + (0xa5b0 - PATCH_BASE)
mov	x19, x0
LFQH_Lloh1048:
adr x0, LFQH_l_.str.274
LFQH_Lloh1049:
nop
bl Lpatch + (0xa5a4 - PATCH_BASE)
mov	x1, x0
mov	x0, x19
bl Lpatch + (0xa5d4 - PATCH_BASE)
mov	x19, x0
LFQH_Lloh1050:
adr x20, LFQH_l_.str.244
LFQH_Lloh1051:
nop
mov	x0, x20
bl Lpatch + (0xa5b0 - PATCH_BASE)
mov	x22, x0
LFQH_Lloh1052:
adr x21, LFQH_l_.str.245
LFQH_Lloh1053:
nop
mov	x0, x21
bl Lpatch + (0xa5a4 - PATCH_BASE)
mov	x1, x0
LFQH_Lloh1054:
adr x2, LFQH_l_.str.448
LFQH_Lloh1055:
nop
mov	x0, x22
bl Lpatch + (0xa5d4 - PATCH_BASE)
mov	x2, x0
LFQH_Lloh1056:
adr x1, LFQH_l_.str.447
LFQH_Lloh1057:
nop
mov	x0, x19
bl	LFQH_Put
mov	x0, x20
bl Lpatch + (0xa5b0 - PATCH_BASE)
mov	x22, x0
mov	x0, x21
bl Lpatch + (0xa5a4 - PATCH_BASE)
mov	x1, x0
LFQH_Lloh1058:
adr x2, LFQH_l_.str.450
LFQH_Lloh1059:
nop
mov	x0, x22
bl Lpatch + (0xa5d4 - PATCH_BASE)
mov	x2, x0
LFQH_Lloh1060:
adr x1, LFQH_l_.str.449
LFQH_Lloh1061:
nop
mov	x0, x19
bl	LFQH_Put
mov	x0, x20
bl Lpatch + (0xa5b0 - PATCH_BASE)
mov	x22, x0
mov	x0, x21
bl Lpatch + (0xa5a4 - PATCH_BASE)
mov	x1, x0
LFQH_Lloh1062:
adr x2, LFQH_l_.str.98
LFQH_Lloh1063:
nop
mov	x0, x22
bl Lpatch + (0xa5d4 - PATCH_BASE)
mov	x2, x0
LFQH_Lloh1064:
adr x1, LFQH_l_.str.451
LFQH_Lloh1065:
nop
mov	x0, x19
bl	LFQH_Put
mov	x0, x20
bl Lpatch + (0xa5b0 - PATCH_BASE)
mov	x22, x0
mov	x0, x21
bl Lpatch + (0xa5a4 - PATCH_BASE)
mov	x1, x0
LFQH_Lloh1066:
adr x2, LFQH_l_.str.99
LFQH_Lloh1067:
nop
mov	x0, x22
bl Lpatch + (0xa5d4 - PATCH_BASE)
mov	x2, x0
LFQH_Lloh1068:
adr x1, LFQH_l_.str.452
LFQH_Lloh1069:
nop
mov	x0, x19
bl	LFQH_Put
mov	x0, x20
bl Lpatch + (0xa5b0 - PATCH_BASE)
mov	x22, x0
mov	x0, x21
bl Lpatch + (0xa5a4 - PATCH_BASE)
mov	x1, x0
LFQH_Lloh1070:
adr x2, LFQH_l_.str.454
LFQH_Lloh1071:
nop
mov	x0, x22
bl Lpatch + (0xa5d4 - PATCH_BASE)
mov	x2, x0
LFQH_Lloh1072:
adr x1, LFQH_l_.str.453
LFQH_Lloh1073:
nop
mov	x0, x19
bl	LFQH_Put
mov	x0, x20
bl Lpatch + (0xa5b0 - PATCH_BASE)
mov	x20, x0
mov	x0, x21
bl Lpatch + (0xa5a4 - PATCH_BASE)
mov	x1, x0
LFQH_Lloh1074:
adr x2, LFQH_l_.str.456
LFQH_Lloh1075:
nop
mov	x0, x20
bl Lpatch + (0xa5d4 - PATCH_BASE)
mov	x2, x0
LFQH_Lloh1076:
adr x1, LFQH_l_.str.455
LFQH_Lloh1077:
nop
mov	x0, x19
bl	LFQH_Put
LFQH_Lloh1078:
adr x0, LFQH_l_.str.457
LFQH_Lloh1079:
nop
mov	x1, x19
bl Lrecord_named
mov	x19, #0
LFQH_LBB58_2:
mov	x0, x19
ldp	x29, x30, [sp, #32]
ldp	x20, x19, [sp, #16]
ldp	x22, x21, [sp], #48
ret
.cfi_endproc
.p2align	2
LFQH_DenyBookstorePopup:
.cfi_startproc
mov	w0, #0
ret
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
LFQH_Lloh1080:
adr x0, LFQH_l_.str.102
LFQH_Lloh1081:
nop
LFQH_Lloh1082:
adr x20, LFQH_l_.str.103
LFQH_Lloh1083:
nop
LFQH_Lloh1084:
adr x2, LFQH_l_.str.104
LFQH_Lloh1085:
nop
LFQH_Lloh1086:
adr x19, LFQH_l_.str.9
LFQH_Lloh1087:
nop
LFQH_Lloh1088:
adr x4, LFQH_ReaderShelfWrapperLayout
LFQH_Lloh1089:
nop
mov	x1, x20
mov	x3, x19
bl	LFQH_Hook
LFQH_Lloh1090:
adr x23, LFQH_l_.str.105
LFQH_Lloh1091:
nop
LFQH_Lloh1092:
adr x1, LFQH_l_.str.106
LFQH_Lloh1093:
nop
LFQH_Lloh1094:
adr x2, LFQH_l_.str.107
LFQH_Lloh1095:
nop
LFQH_Lloh1096:
adr x22, LFQH_l_.str.67
LFQH_Lloh1097:
nop
LFQH_Lloh1098:
adr x4, LFQH_ReaderMenuShow
LFQH_Lloh1099:
nop
mov	x0, x23
mov	x3, x22
bl	LFQH_Hook
LFQH_Lloh1100:
adr x1, LFQH_l_.str.108
LFQH_Lloh1101:
nop
LFQH_Lloh1102:
adr x2, LFQH_l_.str.109
LFQH_Lloh1103:
nop
LFQH_Lloh1104:
adr x21, LFQH_l_.str.110
LFQH_Lloh1105:
nop
LFQH_Lloh1106:
adr x4, LFQH_ReaderBackdropTheme
LFQH_Lloh1107:
nop
mov	x0, x23
mov	x3, x21
bl	LFQH_Hook
LFQH_Lloh1108:
adr x1, LFQH_l_.str.111
LFQH_Lloh1109:
nop
LFQH_Lloh1110:
adr x2, LFQH_l_.str.112
LFQH_Lloh1111:
nop
LFQH_Lloh1112:
adr x4, LFQH_PageReaderCommunityRefresh
LFQH_Lloh1113:
nop
mov	x0, x23
mov	x3, x19
bl	LFQH_Hook
LFQH_Lloh1114:
adr x0, LFQH_l_.str.113
LFQH_Lloh1115:
nop
LFQH_Lloh1116:
adr x2, LFQH_l_.str.114
LFQH_Lloh1117:
nop
LFQH_Lloh1118:
adr x4, LFQH_PageReaderCommunityLayout
LFQH_Lloh1119:
nop
mov	x1, x20
mov	x3, x19
bl	LFQH_Hook
LFQH_Lloh1120:
adr x0, LFQH_l_.str.57
LFQH_Lloh1121:
nop
LFQH_Lloh1122:
adr x2, LFQH_l_.str.115
LFQH_Lloh1123:
nop
LFQH_Lloh1124:
adr x4, LFQH_PageBottomLayout
LFQH_Lloh1125:
nop
mov	x1, x20
mov	x3, x19
bl	LFQH_Hook
LFQH_Lloh1126:
adr x24, LFQH_l_.str.116
LFQH_Lloh1127:
nop
LFQH_Lloh1128:
adr x2, LFQH_l_.str.117
LFQH_Lloh1129:
nop
LFQH_Lloh1130:
adr x4, LFQH_PageProgressLayout
LFQH_Lloh1131:
nop
mov	x0, x24
mov	x1, x20
mov	x3, x19
bl	LFQH_Hook
LFQH_Lloh1132:
adr x1, LFQH_l_.str.118
LFQH_Lloh1133:
nop
LFQH_Lloh1134:
adr x2, LFQH_l_.str.119
LFQH_Lloh1135:
nop
LFQH_Lloh1136:
adr x23, LFQH_l_.str.120
LFQH_Lloh1137:
nop
LFQH_Lloh1138:
adr x4, LFQH_PageProgressTheme
LFQH_Lloh1139:
nop
mov	x0, x24
mov	x3, x23
bl	LFQH_Hook
LFQH_Lloh1140:
adr x0, LFQH_l_.str.121
LFQH_Lloh1141:
nop
LFQH_Lloh1142:
adr x2, LFQH_l_.str.122
LFQH_Lloh1143:
nop
LFQH_Lloh1144:
adr x4, LFQH_PageDivertLayout
LFQH_Lloh1145:
nop
mov	x1, x20
mov	x3, x19
bl	LFQH_Hook
LFQH_Lloh1146:
adr x0, LFQH_l_.str.123
LFQH_Lloh1147:
nop
LFQH_Lloh1148:
adr x2, LFQH_l_.str.124
LFQH_Lloh1149:
nop
LFQH_Lloh1150:
adr x4, LFQH_PageGiftLayout
LFQH_Lloh1151:
nop
mov	x1, x20
mov	x3, x19
bl	LFQH_Hook
LFQH_Lloh1152:
adr x0, LFQH_l_.str.125
LFQH_Lloh1153:
nop
LFQH_Lloh1154:
adr x2, LFQH_l_.str.126
LFQH_Lloh1155:
nop
LFQH_Lloh1156:
adr x4, LFQH_PageBookGiftLayout
LFQH_Lloh1157:
nop
mov	x1, x20
mov	x3, x19
bl	LFQH_Hook
LFQH_Lloh1158:
adr x0, LFQH_l_.str.127
LFQH_Lloh1159:
nop
LFQH_Lloh1160:
adr x2, LFQH_l_.str.128
LFQH_Lloh1161:
nop
LFQH_Lloh1162:
adr x4, LFQH_PageCoverListenLayout
LFQH_Lloh1163:
nop
mov	x1, x20
mov	x3, x19
bl	LFQH_Hook
LFQH_Lloh1164:
adr x24, LFQH_l_.str.129
LFQH_Lloh1165:
nop
LFQH_Lloh1166:
adr x1, LFQH_l_.str.130
LFQH_Lloh1167:
nop
LFQH_Lloh1168:
adr x2, LFQH_l_.str.131
LFQH_Lloh1169:
nop
LFQH_Lloh1170:
adr x4, LFQH_PageCoverGuideSetup
LFQH_Lloh1171:
nop
mov	x0, x24
mov	x3, x19
bl	LFQH_Hook
LFQH_Lloh1172:
adr x1, LFQH_l_.str.132
LFQH_Lloh1173:
nop
LFQH_Lloh1174:
adr x2, LFQH_l_.str.133
LFQH_Lloh1175:
nop
LFQH_Lloh1176:
adr x4, LFQH_PageCoverGuideLayout
LFQH_Lloh1177:
nop
mov	x0, x24
mov	x3, x19
bl	LFQH_Hook
LFQH_Lloh1178:
adr x0, LFQH_l_.str.134
LFQH_Lloh1179:
nop
LFQH_Lloh1180:
adr x2, LFQH_l_.str.135
LFQH_Lloh1181:
nop
LFQH_Lloh1182:
adr x4, LFQH_PageDiscussLayout
LFQH_Lloh1183:
nop
mov	x1, x20
mov	x3, x19
bl	LFQH_Hook
LFQH_Lloh1184:
adr x0, LFQH_l_.str.136
LFQH_Lloh1185:
nop
LFQH_Lloh1186:
adr x2, LFQH_l_.str.137
LFQH_Lloh1187:
nop
LFQH_Lloh1188:
adr x4, LFQH_PageDiscussButtonLayout
LFQH_Lloh1189:
nop
mov	x1, x20
mov	x3, x19
bl	LFQH_Hook
LFQH_Lloh1190:
adr x24, LFQH_l_.str.138
LFQH_Lloh1191:
nop
LFQH_Lloh1192:
adr x2, LFQH_l_.str.139
LFQH_Lloh1193:
nop
LFQH_Lloh1194:
adr x4, LFQH_PageChapterCardLayout
LFQH_Lloh1195:
nop
mov	x0, x24
mov	x1, x20
mov	x3, x19
bl	LFQH_Hook
LFQH_Lloh1196:
adr x1, LFQH_l_.str.140
LFQH_Lloh1197:
nop
LFQH_Lloh1198:
adr x2, LFQH_l_.str.141
LFQH_Lloh1199:
nop
LFQH_Lloh1200:
adr x4, LFQH_PageChapterCardTheme
LFQH_Lloh1201:
nop
mov	x0, x24
mov	x3, x23
bl	LFQH_Hook
LFQH_Lloh1202:
adr x0, LFQH_l_.str.142
LFQH_Lloh1203:
nop
LFQH_Lloh1204:
adr x2, LFQH_l_.str.143
LFQH_Lloh1205:
nop
LFQH_Lloh1206:
adr x4, LFQH_PageChapterButtonLayout
LFQH_Lloh1207:
nop
mov	x1, x20
mov	x3, x19
bl	LFQH_Hook
LFQH_Lloh1208:
adr x0, LFQH_l_.str.144
LFQH_Lloh1209:
nop
LFQH_Lloh1210:
adr x1, LFQH_l_.str.145
LFQH_Lloh1211:
nop
LFQH_Lloh1212:
adr x2, LFQH_l_.str.146
LFQH_Lloh1213:
nop
LFQH_Lloh1214:
adr x4, LFQH_PageChapterRewardTheme
LFQH_Lloh1215:
nop
mov	x3, x23
bl	LFQH_Hook
LFQH_Lloh1216:
adr x24, LFQH_l_.str.147
LFQH_Lloh1217:
nop
LFQH_Lloh1218:
adr x2, LFQH_l_.str.148
LFQH_Lloh1219:
nop
LFQH_Lloh1220:
adr x4, LFQH_PageShelfTabLayout
LFQH_Lloh1221:
nop
mov	x0, x24
mov	x1, x20
mov	x3, x19
bl	LFQH_Hook
LFQH_Lloh1222:
adr x1, LFQH_l_.str.149
LFQH_Lloh1223:
nop
LFQH_Lloh1224:
adr x2, LFQH_l_.str.150
LFQH_Lloh1225:
nop
LFQH_Lloh1226:
adr x4, LFQH_PageShelfTabReload
LFQH_Lloh1227:
nop
mov	x0, x24
mov	x3, x23
bl	LFQH_Hook
LFQH_Lloh1228:
adr x24, LFQH_l_.str.151
LFQH_Lloh1229:
nop
LFQH_Lloh1230:
adr x2, LFQH_l_.str.152
LFQH_Lloh1231:
nop
LFQH_Lloh1232:
adr x4, LFQH_PageShelfFilterLayout
LFQH_Lloh1233:
nop
mov	x0, x24
mov	x1, x20
mov	x3, x19
bl	LFQH_Hook
LFQH_Lloh1234:
adr x1, LFQH_l_.str.153
LFQH_Lloh1235:
nop
LFQH_Lloh1236:
adr x2, LFQH_l_.str.154
LFQH_Lloh1237:
nop
LFQH_Lloh1238:
adr x4, LFQH_PageShelfFilterAppearance
LFQH_Lloh1239:
nop
mov	x0, x24
mov	x3, x22
bl	LFQH_Hook
LFQH_Lloh1240:
adr x1, LFQH_l_.str.155
LFQH_Lloh1241:
nop
LFQH_Lloh1242:
adr x2, LFQH_l_.str.156
LFQH_Lloh1243:
nop
LFQH_Lloh1244:
adr x4, LFQH_PageShelfFilterBackground
LFQH_Lloh1245:
nop
mov	x0, x24
mov	x3, x23
bl	LFQH_Hook
LFQH_Lloh1246:
adr x0, LFQH_l_.str.63
LFQH_Lloh1247:
nop
LFQH_Lloh1248:
adr x2, LFQH_l_.str.64
LFQH_Lloh1249:
nop
LFQH_Lloh1250:
adr x4, LFQH_ShelfFilterHeaderLayout
LFQH_Lloh1251:
nop
mov	x1, x20
mov	x3, x19
bl	LFQH_Hook
LFQH_Lloh1252:
adr x0, LFQH_l_.str.157
LFQH_Lloh1253:
nop
LFQH_Lloh1254:
adr x1, LFQH_l_.str.158
LFQH_Lloh1255:
nop
LFQH_Lloh1256:
adr x2, LFQH_l_.str.159
LFQH_Lloh1257:
nop
LFQH_Lloh1258:
adr x3, LFQH_l_.str.160
LFQH_Lloh1259:
nop
LFQH_Lloh1260:
adr x4, LFQH_ShelfInlineFilterInsets
LFQH_Lloh1261:
nop
bl	LFQH_Hook
LFQH_Lloh1262:
adr x0, LFQH_l_.str.161
LFQH_Lloh1263:
nop
LFQH_Lloh1264:
adr x2, LFQH_l_.str.162
LFQH_Lloh1265:
nop
LFQH_Lloh1266:
adr x4, LFQH_PageProfileBarLayout
LFQH_Lloh1267:
nop
mov	x1, x20
mov	x3, x19
bl	LFQH_Hook
LFQH_Lloh1268:
adr x23, LFQH_l_.str.72
LFQH_Lloh1269:
nop
LFQH_Lloh1270:
adr x1, LFQH_l_.str.163
LFQH_Lloh1271:
nop
LFQH_Lloh1272:
adr x2, LFQH_l_.str.164
LFQH_Lloh1273:
nop
LFQH_Lloh1274:
adr x4, LFQH_ProfileCollectionLayout
LFQH_Lloh1275:
nop
mov	x0, x23
mov	x3, x19
bl	LFQH_Hook
LFQH_Lloh1276:
adr x0, LFQH_l_.str.165
LFQH_Lloh1277:
nop
LFQH_Lloh1278:
adr x2, LFQH_l_.str.166
LFQH_Lloh1279:
nop
LFQH_Lloh1280:
adr x4, LFQH_PageProfileEntryLayout
LFQH_Lloh1281:
nop
mov	x1, x20
mov	x3, x19
bl	LFQH_Hook
LFQH_Lloh1282:
adr x0, LFQH_l_.str.167
LFQH_Lloh1283:
nop
LFQH_Lloh1284:
adr x2, LFQH_l_.str.168
LFQH_Lloh1285:
nop
LFQH_Lloh1286:
adr x4, LFQH_PageProfileOrderLayout
LFQH_Lloh1287:
nop
mov	x1, x20
mov	x3, x19
bl	LFQH_Hook
LFQH_Lloh1288:
adr x1, LFQH_l_.str.169
LFQH_Lloh1289:
nop
LFQH_Lloh1290:
adr x2, LFQH_l_.str.170
LFQH_Lloh1291:
nop
LFQH_Lloh1292:
adr x4, LFQH_MiniGameSetup
LFQH_Lloh1293:
nop
mov	x0, x23
mov	x3, x19
bl	LFQH_Hook
LFQH_Lloh1294:
adr x0, LFQH_l_.str.171
LFQH_Lloh1295:
nop
LFQH_Lloh1296:
adr x1, LFQH_l_.str.172
LFQH_Lloh1297:
nop
LFQH_Lloh1298:
adr x2, LFQH_l_.str.173
LFQH_Lloh1299:
nop
LFQH_Lloh1300:
adr x3, LFQH_l_.str.174
LFQH_Lloh1301:
nop
LFQH_Lloh1302:
adr x4, LFQH_MineConfiguredEntrances
LFQH_Lloh1303:
nop
bl	LFQH_Hook
LFQH_Lloh1304:
adr x0, LFQH_l_.str.175
LFQH_Lloh1305:
nop
LFQH_Lloh1306:
adr x1, LFQH_l_.str.176
LFQH_Lloh1307:
nop
LFQH_Lloh1308:
adr x2, LFQH_l_.str.177
LFQH_Lloh1309:
nop
LFQH_Lloh1310:
adr x3, LFQH_l_.str.101
LFQH_Lloh1311:
nop
LFQH_Lloh1312:
adr x4, LFQH_MineListObjects
LFQH_Lloh1313:
nop
bl	LFQH_Hook
LFQH_Lloh1314:
adr x23, LFQH_l_.str.21
LFQH_Lloh1315:
nop
LFQH_Lloh1316:
adr x1, LFQH_l_.str.178
LFQH_Lloh1317:
nop
LFQH_Lloh1318:
adr x2, LFQH_l_.str.179
LFQH_Lloh1319:
nop
LFQH_Lloh1320:
adr x4, LFQH_ShelfDurationVisible
LFQH_Lloh1321:
nop
mov	x0, x23
mov	x3, x22
bl	LFQH_Hook
LFQH_Lloh1322:
adr x2, LFQH_l_.str.59
LFQH_Lloh1323:
nop
LFQH_Lloh1324:
adr x4, LFQH_ShelfDurationLayout
LFQH_Lloh1325:
nop
mov	x0, x23
mov	x1, x20
mov	x3, x19
bl	LFQH_Hook
LFQH_Lloh1326:
adr x1, LFQH_l_.str.180
LFQH_Lloh1327:
nop
LFQH_Lloh1328:
adr x2, LFQH_l_.str.181
LFQH_Lloh1329:
nop
LFQH_Lloh1330:
adr x4, LFQH_ShelfStockEditLayout
LFQH_Lloh1331:
nop
mov	x0, x23
mov	x3, x19
bl	LFQH_Hook
LFQH_Lloh1332:
adr x19, LFQH_l_.str.182
LFQH_Lloh1333:
nop
LFQH_Lloh1334:
adr x1, LFQH_l_.str.183
LFQH_Lloh1335:
nop
LFQH_Lloh1336:
adr x2, LFQH_l_.str.184
LFQH_Lloh1337:
nop
LFQH_Lloh1338:
adr x4, LFQH_ShelfSaveOpeningData
LFQH_Lloh1339:
nop
mov	x0, x19
mov	x3, x21
bl	LFQH_Hook
LFQH_Lloh1340:
adr x1, LFQH_l_.str.185
LFQH_Lloh1341:
nop
LFQH_Lloh1342:
adr x2, LFQH_l_.str.186
LFQH_Lloh1343:
nop
LFQH_Lloh1344:
adr x3, LFQH_l_.str.187
LFQH_Lloh1345:
nop
LFQH_Lloh1346:
adr x4, LFQH_ShelfCoverTransitionInfo
LFQH_Lloh1347:
nop
mov	x0, x19
bl	LFQH_Hook
LFQH_Lloh1348:
adr x0, LFQH_l_.str.571
LFQH_Lloh1349:
nop
bl Lpatch + (0xa5b0 - PATCH_BASE)
mov	x20, x0
mov	x0, x19
bl Lpatch + (0xa5b0 - PATCH_BASE)
mov	x19, x0
LFQH_Lloh1350:
adr x0, LFQH_l_.str.572
LFQH_Lloh1351:
nop
bl Lpatch + (0xa5b0 - PATCH_BASE)
LFQH_Lloh1352:
adr x1, LFQH_l_.str.573
LFQH_Lloh1353:
nop
LFQH_Lloh1354:
adr x2, LFQH_l_.str.574
LFQH_Lloh1355:
nop
bl	LFQH_ClassABI
cbz	w0, LFQH_LBB60_7
LFQH_Lloh1356:
adr x0, LFQH_l_.str.21
LFQH_Lloh1357:
nop
bl Lpatch + (0xa5b0 - PATCH_BASE)
LFQH_Lloh1358:
adr x1, LFQH_l_.str.356
LFQH_Lloh1359:
nop
LFQH_Lloh1360:
adr x2, LFQH_l_.str.97
LFQH_Lloh1361:
nop
bl	LFQH_ClassABI
cbz	w0, LFQH_LBB60_7
LFQH_Lloh1362:
adr x1, LFQH_l_.str.575
LFQH_Lloh1363:
nop
LFQH_Lloh1364:
adr x2, LFQH_l_.str.97
LFQH_Lloh1365:
nop
mov	x0, x20
bl	LFQH_ClassABI
cbz	w0, LFQH_LBB60_7
mov	x0, x20
bl Lpatch + (0xa664 - PATCH_BASE)
LFQH_Lloh1366:
adr x1, LFQH_l_.str.576
LFQH_Lloh1367:
nop
LFQH_Lloh1368:
adr x2, LFQH_l_.str.577
LFQH_Lloh1369:
nop
bl	LFQH_ClassABI
cbz	w0, LFQH_LBB60_7
LFQH_Lloh1370:
adr x20, LFQH_l_.str.182
LFQH_Lloh1371:
nop
LFQH_Lloh1372:
adr x1, LFQH_l_.str.578
LFQH_Lloh1373:
nop
LFQH_Lloh1374:
adr x21, LFQH_l_.str.579
LFQH_Lloh1375:
nop
LFQH_Lloh1376:
adr x3, LFQH_l_.str.580
LFQH_Lloh1377:
nop
LFQH_Lloh1378:
adr x4, LFQH_ShelfFunctionSize
LFQH_Lloh1379:
nop
mov	x0, x20
mov	x2, x21
bl	LFQH_Hook
LFQH_Lloh1380:
adr x1, LFQH_l_.str.158
LFQH_Lloh1381:
nop
LFQH_Lloh1382:
adr x2, LFQH_l_.str.581
LFQH_Lloh1383:
nop
LFQH_Lloh1384:
adr x3, LFQH_l_.str.160
LFQH_Lloh1385:
nop
LFQH_Lloh1386:
adr x4, LFQH_ShelfFunctionInsets
LFQH_Lloh1387:
nop
mov	x0, x20
bl	LFQH_Hook
mov	x0, x21
bl Lpatch + (0xa5a4 - PATCH_BASE)
mov	x1, x0
mov	x0, x19
bl Lpatch + (0xa5f8 - PATCH_BASE)
cbz	x0, LFQH_LBB60_7
LFQH_Lloh1388:
adr x0, LFQH_l_.str.581
LFQH_Lloh1389:
nop
bl Lpatch + (0xa5a4 - PATCH_BASE)
mov	x1, x0
mov	x0, x19
bl Lpatch + (0xa5f8 - PATCH_BASE)
cbz	x0, LFQH_LBB60_7
LFQH_Lloh1390:
adr x0, LFQH_l_.str.571
LFQH_Lloh1391:
nop
LFQH_Lloh1392:
adr x1, LFQH_l_.str.582
LFQH_Lloh1393:
nop
LFQH_Lloh1394:
adr x2, LFQH_l_.str.359
LFQH_Lloh1395:
nop
LFQH_Lloh1396:
adr x3, LFQH_l_.str.9
LFQH_Lloh1397:
nop
LFQH_Lloh1398:
adr x4, LFQH_ShelfFunctionLayout
LFQH_Lloh1399:
nop
bl	LFQH_Hook
LFQH_LBB60_7:
LFQH_Lloh1400:
adr x19, LFQH_l_.str.188
LFQH_Lloh1401:
nop
LFQH_Lloh1402:
adr x1, LFQH_l_.str.189
LFQH_Lloh1403:
nop
LFQH_Lloh1404:
adr x2, LFQH_l_.str.190
LFQH_Lloh1405:
nop
LFQH_Lloh1406:
adr x3, LFQH_l_.str.11
LFQH_Lloh1407:
nop
LFQH_Lloh1408:
adr x4, LFQH_TabPlan
LFQH_Lloh1409:
nop
mov	x0, x19
bl	LFQH_Hook
LFQH_Lloh1410:
adr x1, LFQH_l_.str.191
LFQH_Lloh1411:
nop
LFQH_Lloh1412:
adr x2, LFQH_l_.str.192
LFQH_Lloh1413:
nop
LFQH_Lloh1414:
adr x3, LFQH_l_.str.67
LFQH_Lloh1415:
nop
LFQH_Lloh1416:
adr x4, LFQH_TabOwnerAppear
LFQH_Lloh1417:
nop
mov	x0, x19
ldp	x29, x30, [sp, #48]
ldp	x20, x19, [sp, #32]
ldp	x22, x21, [sp, #16]
ldp	x24, x23, [sp], #64
b	LFQH_Hook
.cfi_endproc
.p2align	2
LFQH_ReaderShelfWrapperLayout:
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
LFQH_Lloh1418:
adr x0, LFQH_l_.str.102
LFQH_Lloh1419:
nop
LFQH_Lloh1420:
adr x1, LFQH_l_.str.104
LFQH_Lloh1421:
nop
bl	LFQH_Original
mov	x8, x0
mov	x0, x19
mov	x1, x20
blr	x8
LFQH_Lloh1422:
adr x1, LFQH_l_.str.248
LFQH_Lloh1423:
nop
mov	x0, x19
bl	LFQH_Get
mov	x20, x0
LFQH_Lloh1424:
adr x0, LFQH_l_.str.20
LFQH_Lloh1425:
nop
bl Lpatch + (0xa5a4 - PATCH_BASE)
mov	x1, x0
mov	x0, x19
bl Lpatch + (0xa5d4 - PATCH_BASE)
LFQH_Lloh1426:
adr x1, LFQH_l_.str.240
LFQH_Lloh1427:
nop
bl	LFQH_Kind
cbz	w0, LFQH_LBB61_3
LFQH_Lloh1428:
adr x1, LFQH_l_.str.36
LFQH_Lloh1429:
nop
mov	x0, x20
bl	LFQH_Kind
cbz	w0, LFQH_LBB61_3
LFQH_Lloh1430:
adr x0, LFQH_l_.str.20
LFQH_Lloh1431:
nop
bl Lpatch + (0xa5a4 - PATCH_BASE)
mov	x1, x0
mov	x0, x20
bl Lpatch + (0xa5d4 - PATCH_BASE)
cmp	x20, #0
ccmp	x0, x19, #0, ne
b.eq	LFQH_LBB61_7
LFQH_LBB61_3:
mov	x20, #0
LFQH_LBB61_4:
LFQH_Lloh1432:
adr x1, LFQH_IconGlassKey
LFQH_Lloh1433:
nop
mov	x0, x20
bl Lpatch + (0xa628 - PATCH_BASE)
mov	x21, x0
cmp	x0, #0
csel	x2, xzr, x20, eq
LFQH_Lloh1434:
adr x1, LFQH_ReaderShelfLabelKey
LFQH_Lloh1435:
nop
mov	x0, x19
bl	LFQH_TrackReaderLabel
cbz	x21, LFQH_LBB61_6
LFQH_Lloh1436:
adr x0, LFQH_l_.str.251
LFQH_Lloh1437:
nop
bl Lpatch + (0xa5a4 - PATCH_BASE)
mov	x1, x0
mov	x0, x19
bl Lpatch + (0xa5d4 - PATCH_BASE)
mov	x20, x0
LFQH_Lloh1438:
adr x0, LFQH_l_.str.252
LFQH_Lloh1439:
nop
bl Lpatch + (0xa5a4 - PATCH_BASE)
mov	x1, x0
mov	x0, x19
bl Lpatch + (0xa5d4 - PATCH_BASE)
mov	x2, x0
mov	x0, x19
mov	x1, x20
bl	LFQH_PrepareOwner
LFQH_Lloh1440:
adr x0, LFQH_l_.str.249
LFQH_Lloh1441:
nop
bl Lpatch + (0xa5a4 - PATCH_BASE)
mov	x1, x0
mov	x0, x21
bl Lpatch + (0xa5d4 - PATCH_BASE)
mov	x0, x19
ldp	x29, x30, [sp, #32]
ldp	x20, x19, [sp, #16]
ldp	x22, x21, [sp], #48
b	LFQH_EnsureHit
LFQH_LBB61_6:
mov	x0, x19
bl	LFQH_RestoreOwner
mov	x0, x19
ldp	x29, x30, [sp, #32]
ldp	x20, x19, [sp, #16]
ldp	x22, x21, [sp], #48
b	LFQH_RestoreHit
LFQH_LBB61_7:
mov	x0, x20
mov	w1, #8
bl	LFQH_Icon
b	LFQH_LBB61_4
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
LFQH_Lloh1442:
adr x0, LFQH_l_.str.105
LFQH_Lloh1443:
nop
LFQH_Lloh1444:
adr x1, LFQH_l_.str.107
LFQH_Lloh1445:
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
LFQH_Lloh1446:
adr x0, LFQH_l_.str.105
LFQH_Lloh1447:
nop
LFQH_Lloh1448:
adr x1, LFQH_l_.str.109
LFQH_Lloh1449:
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
LFQH_PageReaderCommunityRefresh:
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
LFQH_Lloh1450:
adr x0, LFQH_l_.str.105
LFQH_Lloh1451:
nop
LFQH_Lloh1452:
adr x1, LFQH_l_.str.112
LFQH_Lloh1453:
nop
bl	LFQH_Original
mov	x8, x0
mov	x0, x20
mov	x1, x19
blr	x8
bl	LFQH_ReaderBottomBackgroundEnabled
mov	x1, x0
mov	x0, x20
ldp	x29, x30, [sp, #16]
ldp	x20, x19, [sp], #32
b	LFQH_ReaderCommunityBackdrop
.cfi_endproc
.p2align	2
LFQH_PageReaderCommunityLayout:
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
LFQH_Lloh1454:
adr x0, LFQH_l_.str.113
LFQH_Lloh1455:
nop
LFQH_Lloh1456:
adr x1, LFQH_l_.str.114
LFQH_Lloh1457:
nop
bl	LFQH_Original
mov	x8, x0
mov	x0, x19
mov	x1, x20
blr	x8
LFQH_Lloh1458:
adr x0, LFQH_l_.str.20
LFQH_Lloh1459:
nop
bl Lpatch + (0xa5a4 - PATCH_BASE)
mov	x1, x0
mov	x0, x19
bl Lpatch + (0xa5d4 - PATCH_BASE)
LFQH_Lloh1460:
adr x1, LFQH_l_.str.469
LFQH_Lloh1461:
nop
bl	LFQH_Kind
cbz	w0, LFQH_LBB65_2
mov	x0, x19
ldp	x29, x30, [sp, #16]
ldp	x20, x19, [sp], #32
b	LFQH_ReaderCommunityGlass
LFQH_LBB65_2:
LFQH_Lloh1462:
adr x1, LFQH_SurfaceKey
LFQH_Lloh1463:
nop
mov	x0, x19
bl Lpatch + (0xa628 - PATCH_BASE)
cbz	x0, LFQH_LBB65_4
mov	x0, x19
ldp	x29, x30, [sp, #16]
ldp	x20, x19, [sp], #32
b	LFQH_PageRestore
LFQH_LBB65_4:
ldp	x29, x30, [sp, #16]
ldp	x20, x19, [sp], #32
ret
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
LFQH_Lloh1464:
adr x0, LFQH_l_.str.57
LFQH_Lloh1465:
nop
LFQH_Lloh1466:
adr x1, LFQH_l_.str.115
LFQH_Lloh1467:
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
LFQH_Lloh1468:
adr x1, LFQH_l_.str.470
LFQH_Lloh1469:
nop
mov	x0, x19
bl	LFQH_Get
mov	x20, x0
LFQH_Lloh1470:
adr x0, LFQH_l_.str.34
LFQH_Lloh1471:
nop
bl Lpatch + (0xa5a4 - PATCH_BASE)
mov	x1, x0
mov	x0, x20
bl Lpatch + (0xa5d4 - PATCH_BASE)
mov	x21, x0
LFQH_Lloh1472:
adr x0, LFQH_l_.str.24
LFQH_Lloh1473:
nop
bl Lpatch + (0xa5a4 - PATCH_BASE)
mov	x1, x0
mov	x0, x19
bl Lpatch + (0xa5d4 - PATCH_BASE)
stp	d0, d1, [sp]
stp	d2, d3, [sp, #16]
cbz	x21, LFQH_LBB66_26
mov	x23, #0
mov	x22, #0
LFQH_Lloh1474:
adr x25, LFQH_l_.str.20
LFQH_Lloh1475:
nop
LFQH_LBB66_2:
LFQH_Lloh1476:
adr x0, LFQH_l_.str.327
LFQH_Lloh1477:
nop
bl Lpatch + (0xa5a4 - PATCH_BASE)
mov	x1, x0
mov	x0, x20
mov	x2, x22
bl Lpatch + (0xa5d4 - PATCH_BASE)
mov	x28, x0
LFQH_Lloh1478:
adr x1, LFQH_l_.str.56
LFQH_Lloh1479:
nop
bl	LFQH_Kind
cmp	w0, #0
ccmp	x28, #0, #4, ne
b.eq	LFQH_LBB66_23
mov	w24, #0
mov	x0, x28
LFQH_LBB66_4:
cmp	x0, x19
b.eq	LFQH_LBB66_7
mov	x1, x25
bl	LFQH_Get
cbz	x0, LFQH_LBB66_23
cmp	w24, #7
add	w24, w24, #1
b.lo	LFQH_LBB66_4
b	LFQH_LBB66_23
LFQH_LBB66_7:
mov	x0, x28
bl	LFQH_ReaderBottomType
sub	w8, w0, #1
cmp	w8, #3
b.hs	LFQH_LBB66_10
mov	x26, x0
mov	x0, x28
mov	x1, #0
bl	LFQH_ReaderBottomGlass
mov	x27, #0
cmp	w26, #1
b.ne	LFQH_LBB66_11
mov	x0, x28
LFQH_Lloh1480:
adr x1, LFQH_SurfaceKey
LFQH_Lloh1481:
nop
bl Lpatch + (0xa628 - PATCH_BASE)
mov	x27, x0
b	LFQH_LBB66_11
LFQH_LBB66_10:
mov	x0, x28
bl	LFQH_PageRestore
mov	x0, x28
bl	LFQH_RestoreHit
mov	x27, #0
LFQH_LBB66_11:
mov	x0, x28
LFQH_Lloh1482:
adr x1, LFQH_CatalogTapKey
LFQH_Lloh1483:
nop
bl Lpatch + (0xa628 - PATCH_BASE)
mov	x26, x0
cbnz	x27, LFQH_LBB66_14
cbz	x26, LFQH_LBB66_14
LFQH_Lloh1484:
adr x0, LFQH_l_.str.405
LFQH_Lloh1485:
nop
bl Lpatch + (0xa5a4 - PATCH_BASE)
mov	x1, x0
mov	x0, x28
mov	x2, x26
bl Lpatch + (0xa5d4 - PATCH_BASE)
mov	x0, x28
LFQH_Lloh1486:
adr x1, LFQH_CatalogTapKey
LFQH_Lloh1487:
nop
mov	x2, #0
mov	w3, #1
bl Lpatch + (0xa634 - PATCH_BASE)
b	LFQH_LBB66_23
LFQH_LBB66_14:
cbz	x27, LFQH_LBB66_21
cbnz	x26, LFQH_LBB66_21
mov	x0, x28
bl Lpatch + (0xa664 - PATCH_BASE)
LFQH_Lloh1488:
adr x1, LFQH_l_.str.475
LFQH_Lloh1489:
nop
LFQH_Lloh1490:
adr x2, LFQH_l_.str.120
LFQH_Lloh1491:
nop
bl	LFQH_ClassABI
cbz	w0, LFQH_LBB66_22
LFQH_Lloh1492:
adr x0, LFQH_l_.str.476
LFQH_Lloh1493:
nop
bl Lpatch + (0xa5b0 - PATCH_BASE)
mov	x26, x0
cbnz	x0, LFQH_LBB66_20
LFQH_Lloh1494:
adr x0, LFQH_l_.str.376
LFQH_Lloh1495:
nop
bl Lpatch + (0xa5b0 - PATCH_BASE)
LFQH_Lloh1496:
adr x1, LFQH_l_.str.476
LFQH_Lloh1497:
nop
mov	x2, #0
bl Lpatch + (0xa61c - PATCH_BASE)
cbz	x0, LFQH_LBB66_22
mov	x26, x0
LFQH_Lloh1498:
adr x0, LFQH_l_.str.477
LFQH_Lloh1499:
nop
bl Lpatch + (0xa5a4 - PATCH_BASE)
mov	x1, x0
mov	x0, x26
LFQH_Lloh1500:
adr x2, LFQH_CatalogTapped
LFQH_Lloh1501:
nop
LFQH_Lloh1502:
adr x3, LFQH_l_.str.120
LFQH_Lloh1503:
nop
bl Lpatch + (0xa58c - PATCH_BASE)
LFQH_Lloh1504:
adr x0, LFQH_l_.str.379
LFQH_Lloh1505:
nop
bl Lpatch + (0xa5a4 - PATCH_BASE)
mov	x1, x0
mov	x0, x26
LFQH_Lloh1506:
adr x2, LFQH_CatalogTouch
LFQH_Lloh1507:
nop
LFQH_Lloh1508:
adr x3, LFQH_l_.str.380
LFQH_Lloh1509:
nop
bl Lpatch + (0xa58c - PATCH_BASE)
mov	x0, x26
bl Lpatch + (0xa610 - PATCH_BASE)
LFQH_LBB66_20:
LFQH_Lloh1510:
adr x0, LFQH_l_.str.293
LFQH_Lloh1511:
nop
bl Lpatch + (0xa5a4 - PATCH_BASE)
mov	x1, x0
mov	x0, x26
bl Lpatch + (0xa5d4 - PATCH_BASE)
mov	x26, x0
LFQH_Lloh1512:
adr x0, LFQH_l_.str.478
LFQH_Lloh1513:
nop
bl Lpatch + (0xa5b0 - PATCH_BASE)
mov	x23, x0
LFQH_Lloh1514:
adr x0, LFQH_l_.str.76
LFQH_Lloh1515:
nop
bl Lpatch + (0xa5a4 - PATCH_BASE)
mov	x1, x0
mov	x0, x23
bl Lpatch + (0xa5d4 - PATCH_BASE)
mov	x23, x0
LFQH_Lloh1516:
adr x0, LFQH_l_.str.409
LFQH_Lloh1517:
nop
bl Lpatch + (0xa5a4 - PATCH_BASE)
mov	x24, x0
LFQH_Lloh1518:
adr x0, LFQH_l_.str.477
LFQH_Lloh1519:
nop
bl Lpatch + (0xa5a4 - PATCH_BASE)
mov	x3, x0
mov	x0, x23
mov	x1, x24
mov	x2, x26
bl Lpatch + (0xa5d4 - PATCH_BASE)
mov	x23, x0
LFQH_Lloh1520:
adr x0, LFQH_l_.str.411
LFQH_Lloh1521:
nop
bl Lpatch + (0xa5a4 - PATCH_BASE)
mov	x1, x0
mov	x0, x23
mov	x2, x26
bl Lpatch + (0xa5d4 - PATCH_BASE)
LFQH_Lloh1522:
adr x0, LFQH_l_.str.479
LFQH_Lloh1523:
nop
bl Lpatch + (0xa5a4 - PATCH_BASE)
mov	x1, x0
mov	x0, x23
mov	w2, #0
bl Lpatch + (0xa5d4 - PATCH_BASE)
mov	x0, x23
LFQH_Lloh1524:
adr x24, LFQH_CatalogTapKey
LFQH_Lloh1525:
nop
mov	x1, x24
mov	x2, x26
mov	w3, #1
bl Lpatch + (0xa634 - PATCH_BASE)
mov	x0, x28
mov	x1, x24
mov	x2, x23
mov	w3, #1
bl Lpatch + (0xa634 - PATCH_BASE)
LFQH_Lloh1526:
adr x0, LFQH_l_.str.412
LFQH_Lloh1527:
nop
bl Lpatch + (0xa5a4 - PATCH_BASE)
mov	x1, x0
mov	x0, x28
mov	x2, x23
bl Lpatch + (0xa5d4 - PATCH_BASE)
LFQH_Lloh1528:
adr x24, LFQH_l_.str.55
LFQH_Lloh1529:
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
b	LFQH_LBB66_22
LFQH_LBB66_21:
cbz	x27, LFQH_LBB66_23
LFQH_LBB66_22:
mov	x2, sp
mov	x0, x27
mov	x1, x19
bl	LFQH_IncludeMaterial
mov	x23, x28
LFQH_LBB66_23:
add	x22, x22, #1
cmp	x22, x21
b.ne	LFQH_LBB66_2
cbz	x23, LFQH_LBB66_26
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
LFQH_LBB66_26:
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
LFQH_Lloh1530:
adr x0, LFQH_l_.str.116
LFQH_Lloh1531:
nop
LFQH_Lloh1532:
adr x1, LFQH_l_.str.117
LFQH_Lloh1533:
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
LFQH_Lloh1534:
adr x0, LFQH_l_.str.116
LFQH_Lloh1535:
nop
LFQH_Lloh1536:
adr x1, LFQH_l_.str.119
LFQH_Lloh1537:
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
LFQH_Lloh1538:
adr x0, LFQH_l_.str.121
LFQH_Lloh1539:
nop
LFQH_Lloh1540:
adr x1, LFQH_l_.str.122
LFQH_Lloh1541:
nop
bl	LFQH_Original
mov	x8, x0
mov	x0, x19
mov	x1, x20
blr	x8
LFQH_Lloh1542:
adr x0, LFQH_l_.str.20
LFQH_Lloh1543:
nop
bl Lpatch + (0xa5a4 - PATCH_BASE)
mov	x1, x0
mov	x0, x19
bl Lpatch + (0xa5d4 - PATCH_BASE)
mov	x20, x0
LFQH_Lloh1544:
adr x1, LFQH_l_.str.57
LFQH_Lloh1545:
nop
bl	LFQH_Kind
cmp	w0, #0
csel	x20, xzr, x20, eq
cbnz	x20, LFQH_LBB69_2
LFQH_Lloh1546:
adr x1, LFQH_l_.str.57
LFQH_Lloh1547:
nop
mov	x0, x19
bl	LFQH_HasAncestor
cbz	w0, LFQH_LBB69_3
LFQH_LBB69_2:
mov	x0, x19
mov	x1, x20
ldp	x29, x30, [sp, #16]
ldp	x20, x19, [sp], #32
b	LFQH_ReaderBottomGlass
LFQH_LBB69_3:
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
LFQH_Lloh1548:
adr x0, LFQH_l_.str.123
LFQH_Lloh1549:
nop
LFQH_Lloh1550:
adr x1, LFQH_l_.str.124
LFQH_Lloh1551:
nop
bl	LFQH_Original
mov	x8, x0
mov	x0, x19
mov	x1, x20
blr	x8
LFQH_Lloh1552:
adr x1, LFQH_l_.str.488
LFQH_Lloh1553:
nop
mov	x0, x19
bl	LFQH_Get
cbz	x0, LFQH_LBB70_2
ldp	x29, x30, [sp, #16]
ldp	x20, x19, [sp], #32
b	LFQH_FQHApply
LFQH_LBB70_2:
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
LFQH_Lloh1554:
adr x0, LFQH_l_.str.125
LFQH_Lloh1555:
nop
LFQH_Lloh1556:
adr x1, LFQH_l_.str.126
LFQH_Lloh1557:
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
LFQH_PageCoverListenLayout:
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
mov	x21, x0
LFQH_Lloh1558:
adr x0, LFQH_l_.str.127
LFQH_Lloh1559:
nop
LFQH_Lloh1560:
adr x1, LFQH_l_.str.128
LFQH_Lloh1561:
nop
bl	LFQH_Original
mov	x8, x0
mov	x0, x21
mov	x1, x19
blr	x8
LFQH_Lloh1562:
adr x1, LFQH_l_.str.489
LFQH_Lloh1563:
nop
mov	x0, x21
bl	LFQH_Get
mov	x20, x0
LFQH_Lloh1564:
adr x1, LFQH_l_.str.311
LFQH_Lloh1565:
nop
mov	x0, x21
bl	LFQH_Get
mov	x19, x0
LFQH_Lloh1566:
adr x1, LFQH_l_.str.490
LFQH_Lloh1567:
nop
mov	x0, x21
bl	LFQH_Get
mov	x22, x0
LFQH_Lloh1568:
adr x1, LFQH_l_.str.290
LFQH_Lloh1569:
nop
mov	x0, x20
bl	LFQH_Kind
cbz	w0, LFQH_LBB72_3
LFQH_Lloh1570:
adr x1, LFQH_l_.str.20
LFQH_Lloh1571:
nop
mov	x0, x20
bl	LFQH_Get
cmp	x0, x21
b.ne	LFQH_LBB72_3
LFQH_Lloh1572:
adr x0, LFQH_l_.str.292
LFQH_Lloh1573:
nop
bl Lpatch + (0xa5a4 - PATCH_BASE)
mov	x1, x0
mov	x0, x20
bl Lpatch + (0xa5d4 - PATCH_BASE)
cbz	w0, LFQH_LBB72_12
LFQH_LBB72_3:
LFQH_Lloh1574:
adr x1, LFQH_l_.str.36
LFQH_Lloh1575:
nop
mov	x0, x22
bl	LFQH_Kind
cbz	w0, LFQH_LBB72_7
LFQH_Lloh1576:
adr x1, LFQH_l_.str.20
LFQH_Lloh1577:
nop
mov	x0, x22
bl	LFQH_Get
cmp	x0, x21
b.ne	LFQH_LBB72_7
LFQH_Lloh1578:
adr x0, LFQH_l_.str.292
LFQH_Lloh1579:
nop
bl Lpatch + (0xa5a4 - PATCH_BASE)
mov	x1, x0
mov	x0, x22
bl Lpatch + (0xa5d4 - PATCH_BASE)
cbnz	w0, LFQH_LBB72_7
LFQH_Lloh1580:
adr x1, LFQH_l_.str.20
LFQH_Lloh1581:
nop
mov	x0, x19
bl	LFQH_Get
cmp	x0, x21
b.eq	LFQH_LBB72_16
LFQH_LBB72_7:
mov	w21, #0
LFQH_LBB72_8:
LFQH_Lloh1582:
adr x1, LFQH_SurfaceKey
LFQH_Lloh1583:
nop
mov	x0, x20
bl Lpatch + (0xa628 - PATCH_BASE)
cbz	x0, LFQH_LBB72_10
mov	x0, x20
bl	LFQH_PageRestore
tbnz	w21, #0, LFQH_LBB72_11
b	LFQH_LBB72_13
LFQH_LBB72_10:
cbz	w21, LFQH_LBB72_13
LFQH_LBB72_11:
mov	x0, x19
ldp	x29, x30, [sp, #32]
ldp	x20, x19, [sp, #16]
ldp	x22, x21, [sp], #48
b	LFQH_FQHApply
LFQH_LBB72_12:
mov	x0, x20
bl	LFQH_FQHApply
LFQH_LBB72_13:
LFQH_Lloh1584:
adr x1, LFQH_SurfaceKey
LFQH_Lloh1585:
nop
mov	x0, x19
bl Lpatch + (0xa628 - PATCH_BASE)
cbz	x0, LFQH_LBB72_15
mov	x0, x19
ldp	x29, x30, [sp, #32]
ldp	x20, x19, [sp, #16]
ldp	x22, x21, [sp], #48
b	LFQH_PageRestore
LFQH_LBB72_15:
ldp	x29, x30, [sp, #32]
ldp	x20, x19, [sp, #16]
ldp	x22, x21, [sp], #48
ret
LFQH_LBB72_16:
LFQH_Lloh1586:
adr x0, LFQH_l_.str.292
LFQH_Lloh1587:
nop
bl Lpatch + (0xa5a4 - PATCH_BASE)
mov	x1, x0
mov	x0, x19
bl Lpatch + (0xa5d4 - PATCH_BASE)
cmp	w0, #0
cset	w21, eq
b	LFQH_LBB72_8
.cfi_endproc
.p2align	2
LFQH_PageCoverGuideSetup:
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
LFQH_Lloh1588:
adr x0, LFQH_l_.str.129
LFQH_Lloh1589:
nop
LFQH_Lloh1590:
adr x1, LFQH_l_.str.131
LFQH_Lloh1591:
nop
bl	LFQH_Original
mov	x8, x0
mov	x0, x20
mov	x1, x19
blr	x8
LFQH_Lloh1592:
adr x1, LFQH_l_.str.491
LFQH_Lloh1593:
nop
mov	x0, x20
bl	LFQH_Get
ldp	x29, x30, [sp, #16]
ldp	x20, x19, [sp], #32
b	LFQH_CoverGuideGlass
.cfi_endproc
.p2align	2
LFQH_PageCoverGuideLayout:
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
LFQH_Lloh1594:
adr x0, LFQH_l_.str.129
LFQH_Lloh1595:
nop
LFQH_Lloh1596:
adr x1, LFQH_l_.str.133
LFQH_Lloh1597:
nop
bl	LFQH_Original
mov	x8, x0
mov	x0, x20
mov	x1, x19
blr	x8
LFQH_Lloh1598:
adr x1, LFQH_l_.str.491
LFQH_Lloh1599:
nop
mov	x0, x20
bl	LFQH_Get
ldp	x29, x30, [sp, #16]
ldp	x20, x19, [sp], #32
b	LFQH_CoverGuideGlass
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
LFQH_Lloh1600:
adr x0, LFQH_l_.str.134
LFQH_Lloh1601:
nop
LFQH_Lloh1602:
adr x1, LFQH_l_.str.135
LFQH_Lloh1603:
nop
bl	LFQH_Original
mov	x8, x0
mov	x0, x19
mov	x1, x20
blr	x8
LFQH_Lloh1604:
adr x20, LFQH_l_.str.20
LFQH_Lloh1605:
nop
mov	x0, x19
mov	x1, x20
bl	LFQH_Get
mov	x1, x20
bl	LFQH_Get
mov	x20, x0
LFQH_Lloh1606:
adr x1, LFQH_l_.str.138
LFQH_Lloh1607:
nop
bl	LFQH_Kind
cbz	w0, LFQH_LBB75_2
mov	x0, x20
bl	LFQH_ChapterEntranceOnly
tbnz	w0, #0, LFQH_LBB75_3
LFQH_LBB75_2:
LFQH_Lloh1608:
adr x1, LFQH_l_.str.136
LFQH_Lloh1609:
nop
mov	x0, x19
bl	LFQH_HasAncestor
cbz	w0, LFQH_LBB75_6
LFQH_LBB75_3:
LFQH_Lloh1610:
adr x1, LFQH_SurfaceKey
LFQH_Lloh1611:
nop
mov	x0, x19
bl Lpatch + (0xa628 - PATCH_BASE)
cbz	x0, LFQH_LBB75_5
mov	x0, x19
ldp	x29, x30, [sp, #16]
ldp	x20, x19, [sp], #32
b	LFQH_PageRestore
LFQH_LBB75_5:
ldp	x29, x30, [sp, #16]
ldp	x20, x19, [sp], #32
ret
LFQH_LBB75_6:
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
LFQH_Lloh1612:
adr x0, LFQH_l_.str.136
LFQH_Lloh1613:
nop
LFQH_Lloh1614:
adr x1, LFQH_l_.str.137
LFQH_Lloh1615:
nop
bl	LFQH_Original
mov	x8, x0
mov	x0, x19
mov	x1, x20
blr	x8
LFQH_Lloh1616:
adr x1, LFQH_l_.str.134
LFQH_Lloh1617:
nop
mov	x0, x19
bl	LFQH_HasAncestor
cbz	w0, LFQH_LBB76_2
mov	x0, x19
ldp	x29, x30, [sp, #16]
ldp	x20, x19, [sp], #32
b	LFQH_PageRestore
LFQH_LBB76_2:
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
LFQH_Lloh1618:
adr x0, LFQH_l_.str.138
LFQH_Lloh1619:
nop
LFQH_Lloh1620:
adr x1, LFQH_l_.str.139
LFQH_Lloh1621:
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
LFQH_Lloh1622:
adr x0, LFQH_l_.str.138
LFQH_Lloh1623:
nop
LFQH_Lloh1624:
adr x1, LFQH_l_.str.141
LFQH_Lloh1625:
nop
bl	LFQH_Original
mov	x8, x0
mov	x0, x21
mov	x1, x20
mov	x2, x19
blr	x8
mov	x0, x21
bl	LFQH_ChapterDiscussionGlass
LFQH_Lloh1626:
adr x0, LFQH_l_.str.279
LFQH_Lloh1627:
nop
bl Lpatch + (0xa5a4 - PATCH_BASE)
mov	x1, x0
mov	x0, x21
bl Lpatch + (0xa5d4 - PATCH_BASE)
mov	x19, x0
LFQH_Lloh1628:
adr x0, LFQH_l_.str.34
LFQH_Lloh1629:
nop
bl Lpatch + (0xa5a4 - PATCH_BASE)
mov	x1, x0
mov	x0, x19
bl Lpatch + (0xa5d4 - PATCH_BASE)
cbz	x0, LFQH_LBB78_5
mov	x20, x0
mov	x21, #0
LFQH_Lloh1630:
adr x22, LFQH_l_.str.327
LFQH_Lloh1631:
nop
LFQH_Lloh1632:
adr x23, LFQH_l_.str.144
LFQH_Lloh1633:
nop
LFQH_LBB78_2:
mov	x0, x22
bl Lpatch + (0xa5a4 - PATCH_BASE)
mov	x1, x0
mov	x0, x19
mov	x2, x21
bl Lpatch + (0xa5d4 - PATCH_BASE)
mov	x24, x0
mov	x1, x23
bl	LFQH_Kind
cbz	w0, LFQH_LBB78_4
mov	x0, x24
bl	LFQH_ChapterRewardGlass
LFQH_LBB78_4:
add	x21, x21, #1
cmp	x20, x21
b.ne	LFQH_LBB78_2
LFQH_LBB78_5:
ldp	x29, x30, [sp, #48]
ldp	x20, x19, [sp, #32]
ldp	x22, x21, [sp, #16]
ldp	x24, x23, [sp], #64
ret
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
LFQH_Lloh1634:
adr x0, LFQH_l_.str.142
LFQH_Lloh1635:
nop
LFQH_Lloh1636:
adr x1, LFQH_l_.str.143
LFQH_Lloh1637:
nop
bl	LFQH_Original
mov	x8, x0
mov	x0, x19
mov	x1, x20
blr	x8
LFQH_Lloh1638:
adr x1, LFQH_l_.str.144
LFQH_Lloh1639:
nop
mov	x0, x19
bl	LFQH_Kind
cbz	w0, LFQH_LBB79_2
mov	x0, x19
ldp	x29, x30, [sp, #16]
ldp	x20, x19, [sp], #32
b	LFQH_ChapterRewardGlass
LFQH_LBB79_2:
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
LFQH_Lloh1640:
adr x0, LFQH_l_.str.144
LFQH_Lloh1641:
nop
LFQH_Lloh1642:
adr x1, LFQH_l_.str.146
LFQH_Lloh1643:
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
LFQH_Lloh1644:
adr x0, LFQH_l_.str.147
LFQH_Lloh1645:
nop
LFQH_Lloh1646:
adr x1, LFQH_l_.str.148
LFQH_Lloh1647:
nop
bl	LFQH_Original
mov	x8, x0
mov	x0, x20
mov	x1, x19
blr	x8
LFQH_Lloh1648:
adr x1, LFQH_l_.str.91
LFQH_Lloh1649:
nop
mov	x0, x20
bl	LFQH_Get
mov	x19, x0
LFQH_Lloh1650:
adr x1, LFQH_l_.str.296
LFQH_Lloh1651:
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
LFQH_Lloh1652:
adr x0, LFQH_l_.str.147
LFQH_Lloh1653:
nop
LFQH_Lloh1654:
adr x1, LFQH_l_.str.150
LFQH_Lloh1655:
nop
bl	LFQH_Original
mov	x8, x0
mov	x0, x21
mov	x1, x20
mov	x2, x19
blr	x8
LFQH_Lloh1656:
adr x1, LFQH_l_.str.296
LFQH_Lloh1657:
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
LFQH_Lloh1658:
adr x0, LFQH_l_.str.151
LFQH_Lloh1659:
nop
LFQH_Lloh1660:
adr x1, LFQH_l_.str.152
LFQH_Lloh1661:
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
LFQH_Lloh1662:
adr x0, LFQH_l_.str.151
LFQH_Lloh1663:
nop
LFQH_Lloh1664:
adr x1, LFQH_l_.str.154
LFQH_Lloh1665:
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
LFQH_Lloh1666:
adr x0, LFQH_l_.str.151
LFQH_Lloh1667:
nop
LFQH_Lloh1668:
adr x1, LFQH_l_.str.156
LFQH_Lloh1669:
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
stp	d15, d14, [sp, #-144]!
stp	d13, d12, [sp, #16]
stp	d11, d10, [sp, #32]
stp	d9, d8, [sp, #48]
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
LFQH_Lloh1670:
adr x0, LFQH_l_.str.63
LFQH_Lloh1671:
nop
LFQH_Lloh1672:
adr x1, LFQH_l_.str.64
LFQH_Lloh1673:
nop
bl	LFQH_Original
mov	x8, x0
mov	x0, x19
mov	x1, x20
blr	x8
LFQH_Lloh1674:
adr x1, LFQH_l_.str.61
LFQH_Lloh1675:
nop
mov	x0, x19
bl	LFQH_Get
cbz	x0, LFQH_LBB86_12
mov	x21, x0
mov	w22, #0
LFQH_Lloh1676:
adr x20, LFQH_l_.str.20
LFQH_Lloh1677:
nop
LFQH_LBB86_2:
cmp	x0, x19
b.eq	LFQH_LBB86_5
mov	x1, x20
bl	LFQH_Get
cbz	x0, LFQH_LBB86_12
cmp	w22, #7
add	w22, w22, #1
b.lo	LFQH_LBB86_2
b	LFQH_LBB86_12
LFQH_LBB86_5:
mov	x0, x21
mov	w1, #1
bl	LFQH_ShelfActionGlass
LFQH_Lloh1678:
adr x1, LFQH_SurfaceKey
LFQH_Lloh1679:
nop
mov	x0, x21
bl Lpatch + (0xa628 - PATCH_BASE)
cbz	x0, LFQH_LBB86_12
mov	x22, x0
LFQH_Lloh1680:
adr x1, LFQH_l_.str.504
LFQH_Lloh1681:
nop
mov	x0, x19
bl	LFQH_Get
mov	x20, x0
LFQH_Lloh1682:
adr x1, LFQH_l_.str.20
LFQH_Lloh1683:
nop
bl	LFQH_Get
cmp	x0, x19
b.ne	LFQH_LBB86_12
LFQH_Lloh1684:
adr x23, LFQH_l_.str.249
LFQH_Lloh1685:
nop
mov	x0, x23
bl Lpatch + (0xa5a4 - PATCH_BASE)
mov	x1, x0
mov	x0, x20
bl Lpatch + (0xa5d4 - PATCH_BASE)
mov.16b	v11, v0
mov.16b	v8, v1
mov.16b	v9, v2
mov.16b	v10, v3
fmov	x24, d9
fmov	x25, d8
fmov	x26, d11
mov	x0, x23
bl Lpatch + (0xa5a4 - PATCH_BASE)
mov	x1, x0
mov	x0, x22
bl Lpatch + (0xa5d4 - PATCH_BASE)
mov.16b	v12, v0
mov.16b	v13, v1
mov.16b	v14, v2
mov.16b	v15, v3
LFQH_Lloh1686:
adr x0, LFQH_l_.str.303
LFQH_Lloh1687:
nop
bl Lpatch + (0xa5a4 - PATCH_BASE)
mov	x1, x0
mov	x0, x21
mov.16b	v0, v12
mov.16b	v1, v13
mov.16b	v2, v14
mov.16b	v3, v15
mov	x2, x19
bl Lpatch + (0xa5d4 - PATCH_BASE)
ubfx	x8, x26, #52, #11
ubfx	x9, x25, #52, #11
ubfx	x10, x24, #52, #11
fmov	x11, d10
ubfx	x11, x11, #52, #11
cmp	x11, #2047
cset	w11, lo
cmp	x10, #2046
mov	w10, #2046
ccmp	x9, x10, #2, ls
ccmp	x8, x10, #2, ls
csel	w8, wzr, w11, hi
cbz	w8, LFQH_LBB86_12
fcmp	d9, #0.0
b.le	LFQH_LBB86_12
fcmp	d10, #0.0
b.le	LFQH_LBB86_12
fadd	d2, d0, d2
fadd	d4, d11, d9
fadd	d3, d1, d3
fadd	d5, d8, d10
fcmp	d11, d2
fccmp	d4, d0, #4, mi
fccmp	d8, d3, #0, gt
fccmp	d5, d1, #4, mi
b.le	LFQH_LBB86_12
fsub	d11, d0, d9
LFQH_Lloh1688:
adr x0, LFQH_l_.str.78
LFQH_Lloh1689:
nop
bl Lpatch + (0xa5a4 - PATCH_BASE)
mov	x1, x0
mov	x0, x20
mov.16b	v0, v11
mov.16b	v1, v8
mov.16b	v2, v9
mov.16b	v3, v10
ldp	x29, x30, [sp, #128]
ldp	x20, x19, [sp, #112]
ldp	x22, x21, [sp, #96]
ldp	x24, x23, [sp, #80]
ldp	x26, x25, [sp, #64]
ldp	d9, d8, [sp, #48]
ldp	d11, d10, [sp, #32]
ldp	d13, d12, [sp, #16]
ldp	d15, d14, [sp], #144
b Lpatch + (0xa5d4 - PATCH_BASE)
LFQH_LBB86_12:
ldp	x29, x30, [sp, #128]
ldp	x20, x19, [sp, #112]
ldp	x22, x21, [sp, #96]
ldp	x24, x23, [sp, #80]
ldp	x26, x25, [sp, #64]
ldp	d9, d8, [sp, #48]
ldp	d11, d10, [sp, #32]
ldp	d13, d12, [sp, #16]
ldp	d15, d14, [sp], #144
ret
.cfi_endproc
.p2align	2
LFQH_ShelfInlineFilterInsets:
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
mov	x20, x4
mov	x21, x3
mov	x22, x2
mov	x23, x1
mov	x19, x0
LFQH_Lloh1690:
adr x0, LFQH_l_.str.157
LFQH_Lloh1691:
nop
LFQH_Lloh1692:
adr x1, LFQH_l_.str.159
LFQH_Lloh1693:
nop
bl	LFQH_Original
mov	x8, x0
mov	x0, x19
mov	x1, x23
mov	x2, x22
mov	x3, x21
mov	x4, x20
blr	x8
mov.16b	v8, v0
mov.16b	v11, v1
mov.16b	v9, v2
mov.16b	v10, v3
LFQH_Lloh1694:
adr x1, LFQH_l_.str.20
LFQH_Lloh1695:
nop
mov	x0, x19
bl	LFQH_Get
mov	x20, x0
bl	LFQH_Enabled
cbz	w0, LFQH_LBB87_3
LFQH_Lloh1696:
adr x1, LFQH_l_.str.63
LFQH_Lloh1697:
nop
mov	x0, x20
bl	LFQH_Kind
cbz	w0, LFQH_LBB87_3
LFQH_Lloh1698:
adr x1, LFQH_l_.str.505
LFQH_Lloh1699:
nop
mov	x0, x20
bl	LFQH_Get
fmov	d0, #-4.00000000
fadd	d0, d11, d0
cmp	x0, x19
fcsel	d11, d0, d11, eq
LFQH_LBB87_3:
mov.16b	v0, v8
mov.16b	v1, v11
mov.16b	v2, v9
mov.16b	v3, v10
ldp	x29, x30, [sp, #80]
ldp	x20, x19, [sp, #64]
ldp	x22, x21, [sp, #48]
ldp	x24, x23, [sp, #32]
ldp	d9, d8, [sp, #16]
ldp	d11, d10, [sp], #96
ret
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
LFQH_Lloh1700:
adr x0, LFQH_l_.str.161
LFQH_Lloh1701:
nop
LFQH_Lloh1702:
adr x1, LFQH_l_.str.162
LFQH_Lloh1703:
nop
bl	LFQH_Original
mov	x8, x0
mov	x0, x19
mov	x1, x20
blr	x8
LFQH_Lloh1704:
adr x1, LFQH_l_.str.10
LFQH_Lloh1705:
nop
mov	x0, x19
bl	LFQH_Get
bl	LFQH_FQHHeader
bl	LFQH_Enabled
cbz	w0, LFQH_LBB88_3
bl	LFQH_FQHGlassAvailable
tbz	w0, #0, LFQH_LBB88_3
LFQH_Lloh1706:
adr x1, LFQH_l_.str.506
LFQH_Lloh1707:
nop
mov	x0, x19
bl	LFQH_Get
mov	x1, x0
LFQH_Lloh1708:
adr x2, LFQH_ProfileScanKey
LFQH_Lloh1709:
nop
mov	x0, x19
bl	LFQH_ProfileIconGlass
LFQH_Lloh1710:
adr x1, LFQH_l_.str.507
LFQH_Lloh1711:
nop
mov	x0, x19
bl	LFQH_Get
mov	x1, x0
LFQH_Lloh1712:
adr x2, LFQH_ProfileNightKey
LFQH_Lloh1713:
nop
mov	x0, x19
bl	LFQH_ProfileIconGlass
LFQH_Lloh1714:
adr x1, LFQH_l_.str.508
LFQH_Lloh1715:
nop
mov	x0, x19
bl	LFQH_Get
mov	x1, x0
b	LFQH_LBB88_4
LFQH_LBB88_3:
LFQH_Lloh1716:
adr x2, LFQH_ProfileScanKey
LFQH_Lloh1717:
nop
mov	x0, x19
mov	x1, #0
bl	LFQH_ProfileIconGlass
LFQH_Lloh1718:
adr x2, LFQH_ProfileNightKey
LFQH_Lloh1719:
nop
mov	x0, x19
mov	x1, #0
bl	LFQH_ProfileIconGlass
mov	x1, #0
LFQH_LBB88_4:
LFQH_Lloh1720:
adr x2, LFQH_ProfileMenuKey
LFQH_Lloh1721:
nop
mov	x0, x19
ldp	x29, x30, [sp, #16]
ldp	x20, x19, [sp], #32
b	LFQH_ProfileIconGlass
.cfi_endproc
.p2align	2
LFQH_ProfileCollectionLayout:
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
mov	x20, x1
mov	x19, x0
LFQH_Lloh1722:
adr x0, LFQH_l_.str.72
LFQH_Lloh1723:
nop
LFQH_Lloh1724:
adr x1, LFQH_l_.str.164
LFQH_Lloh1725:
nop
bl	LFQH_Original
mov	x8, x0
mov	x0, x19
mov	x1, x20
blr	x8
LFQH_Lloh1726:
adr x1, LFQH_l_.str.175
LFQH_Lloh1727:
nop
mov	x0, x19
bl	LFQH_Kind
cbz	w0, LFQH_LBB89_3
LFQH_Lloh1728:
adr x1, LFQH_l_.str.509
LFQH_Lloh1729:
nop
mov	x0, x19
bl	LFQH_Get
mov	x20, x0
LFQH_Lloh1730:
adr x1, LFQH_l_.str.510
LFQH_Lloh1731:
nop
bl	LFQH_BoolProp
cbnz	w0, LFQH_LBB89_3
LFQH_Lloh1732:
adr x1, LFQH_l_.str.511
LFQH_Lloh1733:
nop
mov	x0, x20
bl	LFQH_BoolProp
cbz	w0, LFQH_LBB89_4
LFQH_LBB89_3:
ldp	x29, x30, [sp, #80]
ldp	x20, x19, [sp, #64]
ldp	x22, x21, [sp, #48]
ldp	x24, x23, [sp, #32]
ldp	d9, d8, [sp, #16]
ldp	d11, d10, [sp], #96
ret
LFQH_LBB89_4:
LFQH_Lloh1734:
adr x1, LFQH_l_.str.404
LFQH_Lloh1735:
nop
mov	x0, x19
bl	LFQH_Get
mov	x20, x0
LFQH_Lloh1736:
adr x1, LFQH_l_.str.512
LFQH_Lloh1737:
nop
mov	x0, x19
bl	LFQH_Get
mov	x22, x0
LFQH_Lloh1738:
adr x1, LFQH_l_.str.364
LFQH_Lloh1739:
nop
mov	x0, x19
bl	LFQH_Get
mov	x21, x0
LFQH_Lloh1740:
adr x1, LFQH_l_.str.23
LFQH_Lloh1741:
nop
mov	x0, x20
bl	LFQH_Kind
cbz	w0, LFQH_LBB89_3
LFQH_Lloh1742:
adr x1, LFQH_l_.str.161
LFQH_Lloh1743:
nop
mov	x0, x22
bl	LFQH_Kind
cbz	w0, LFQH_LBB89_3
LFQH_Lloh1744:
adr x1, LFQH_l_.str.513
LFQH_Lloh1745:
nop
mov	x0, x21
bl	LFQH_Kind
cbz	w0, LFQH_LBB89_3
LFQH_Lloh1746:
adr x0, LFQH_l_.str.24
LFQH_Lloh1747:
nop
bl Lpatch + (0xa5a4 - PATCH_BASE)
mov	x1, x0
mov	x0, x20
bl Lpatch + (0xa5d4 - PATCH_BASE)
mov.16b	v9, v0
mov.16b	v8, v1
mov.16b	v10, v2
LFQH_Lloh1748:
adr x0, LFQH_l_.str.249
LFQH_Lloh1749:
nop
bl Lpatch + (0xa5a4 - PATCH_BASE)
mov	x1, x0
mov	x0, x22
bl Lpatch + (0xa5d4 - PATCH_BASE)
fadd	d0, d1, d3
fsub	d11, d0, d8
bl	LFQH_Enabled
cbz	w0, LFQH_LBB89_9
LFQH_Lloh1750:
adr x1, LFQH_l_.str.20
LFQH_Lloh1751:
nop
mov	x0, x21
bl	LFQH_Get
cmp	x0, x20
b.eq	LFQH_LBB89_10
LFQH_LBB89_9:
mov	w3, #0
b	LFQH_LBB89_11
LFQH_LBB89_10:
LFQH_Lloh1752:
adr x0, LFQH_l_.str.292
LFQH_Lloh1753:
nop
bl Lpatch + (0xa5a4 - PATCH_BASE)
mov	x1, x0
mov	x0, x22
bl Lpatch + (0xa5d4 - PATCH_BASE)
cmp	w0, #0
cset	w3, eq
LFQH_LBB89_11:
mov	x0, x20
mov	x1, x22
mov	x2, x21
mov.16b	v0, v9
mov.16b	v1, v8
mov.16b	v2, v10
mov.16b	v3, v11
bl	LFQH_TopChromePage
mov	x23, x0
mov	x0, x22
mov	x1, x23
bl	LFQH_TopChromeFill
mov	x0, x21
mov	x1, x21
mov.16b	v0, v8
mov	x2, x23
bl	LFQH_TopChromeUnderlap
LFQH_Lloh1754:
adr x1, LFQH_l_.str.514
LFQH_Lloh1755:
nop
mov	x0, x19
mov	x2, x20
mov	x3, x21
mov	x4, x21
mov	x5, x23
ldp	x29, x30, [sp, #80]
ldp	x20, x19, [sp, #64]
ldp	x22, x21, [sp, #48]
ldp	x24, x23, [sp, #32]
ldp	d9, d8, [sp, #16]
ldp	d11, d10, [sp], #96
b	LFQH_TopChromeDiagnostics
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
LFQH_Lloh1756:
adr x0, LFQH_l_.str.165
LFQH_Lloh1757:
nop
LFQH_Lloh1758:
adr x1, LFQH_l_.str.166
LFQH_Lloh1759:
nop
bl	LFQH_Original
mov	x8, x0
mov	x0, x19
mov	x1, x20
blr	x8
LFQH_Lloh1760:
adr x1, LFQH_l_.str.542
LFQH_Lloh1761:
nop
mov	x0, x19
bl	LFQH_Kind
tbz	w0, #0, LFQH_LBB90_2
ldp	x29, x30, [sp, #16]
ldp	x20, x19, [sp], #32
ret
LFQH_LBB90_2:
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
LFQH_Lloh1762:
adr x0, LFQH_l_.str.167
LFQH_Lloh1763:
nop
LFQH_Lloh1764:
adr x1, LFQH_l_.str.168
LFQH_Lloh1765:
nop
bl	LFQH_Original
mov	x8, x0
mov	x0, x19
mov	x1, x20
blr	x8
LFQH_Lloh1766:
adr x1, LFQH_l_.str.542
LFQH_Lloh1767:
nop
mov	x0, x19
bl	LFQH_Kind
cbz	w0, LFQH_LBB91_2
mov	x0, x19
mov	w1, #1
ldp	x29, x30, [sp, #16]
ldp	x20, x19, [sp], #32
b	LFQH_ProfileEntryGlass
LFQH_LBB91_2:
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
LFQH_Lloh1768:
adr x0, LFQH_l_.str.72
LFQH_Lloh1769:
nop
LFQH_Lloh1770:
adr x1, LFQH_l_.str.170
LFQH_Lloh1771:
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
mov	x20, x3
mov	x22, x2
mov	x21, x1
mov	x28, x0
LFQH_Lloh1772:
adr x1, LFQH_l_.str.33
LFQH_Lloh1773:
nop
mov	x0, x2
bl	LFQH_Kind
cbz	w0, LFQH_LBB93_10
LFQH_Lloh1774:
adr x0, LFQH_l_.str.549
LFQH_Lloh1775:
nop
bl Lpatch + (0xa5b0 - PATCH_BASE)
LFQH_Lloh1776:
adr x1, LFQH_l_.str.550
LFQH_Lloh1777:
nop
LFQH_Lloh1778:
adr x2, LFQH_l_.str.344
LFQH_Lloh1779:
nop
bl	LFQH_ClassABI
cbz	w0, LFQH_LBB93_10
LFQH_Lloh1780:
adr x0, LFQH_l_.str.34
LFQH_Lloh1781:
nop
bl Lpatch + (0xa5a4 - PATCH_BASE)
mov	x1, x0
mov	x0, x22
bl Lpatch + (0xa5d4 - PATCH_BASE)
cbz	x0, LFQH_LBB93_10
mov	x23, #0
sub	x24, x0, #1
LFQH_Lloh1782:
adr x25, LFQH_l_.str.327
LFQH_Lloh1783:
nop
LFQH_Lloh1784:
adr x26, LFQH_l_.str.549
LFQH_Lloh1785:
nop
LFQH_Lloh1786:
adr x27, LFQH_l_.str.550
LFQH_Lloh1787:
nop
LFQH_LBB93_4:
mov	x0, x25
bl Lpatch + (0xa5a4 - PATCH_BASE)
mov	x1, x0
mov	x0, x22
mov	x2, x24
bl Lpatch + (0xa5d4 - PATCH_BASE)
mov	x19, x0
mov	x1, x26
bl	LFQH_Kind
cbz	w0, LFQH_LBB93_9
mov	x0, x27
bl Lpatch + (0xa5a4 - PATCH_BASE)
mov	x1, x0
mov	x0, x19
bl Lpatch + (0xa5d4 - PATCH_BASE)
cmp	w0, #9
b.ne	LFQH_LBB93_9
cbnz	x23, LFQH_LBB93_8
LFQH_Lloh1788:
adr x0, LFQH_l_.str.551
LFQH_Lloh1789:
nop
bl Lpatch + (0xa5a4 - PATCH_BASE)
mov	x1, x0
mov	x0, x22
bl Lpatch + (0xa5d4 - PATCH_BASE)
mov	x19, x0
LFQH_Lloh1790:
adr x0, LFQH_l_.str.552
LFQH_Lloh1791:
nop
bl Lpatch + (0xa5a4 - PATCH_BASE)
mov	x1, x0
mov	x0, x19
bl Lpatch + (0xa5d4 - PATCH_BASE)
mov	x23, x0
LFQH_LBB93_8:
LFQH_Lloh1792:
adr x0, LFQH_l_.str.553
LFQH_Lloh1793:
nop
bl Lpatch + (0xa5a4 - PATCH_BASE)
mov	x1, x0
mov	x0, x23
mov	x2, x24
bl Lpatch + (0xa5d4 - PATCH_BASE)
LFQH_LBB93_9:
sub	x24, x24, #1
cmn	x24, #1
b.ne	LFQH_LBB93_4
b	LFQH_LBB93_11
LFQH_LBB93_10:
mov	x23, #0
LFQH_LBB93_11:
LFQH_Lloh1794:
adr x0, LFQH_l_.str.171
LFQH_Lloh1795:
nop
LFQH_Lloh1796:
adr x1, LFQH_l_.str.173
LFQH_Lloh1797:
nop
bl	LFQH_Original
mov	x8, x0
cmp	x23, #0
csel	x2, x22, x23, eq
mov	x0, x28
mov	x1, x21
mov	x3, x20
blr	x8
cbz	x23, LFQH_LBB93_13
LFQH_Lloh1798:
adr x0, LFQH_l_.str.171
LFQH_Lloh1799:
nop
LFQH_Lloh1800:
adr x1, LFQH_l_.str.554
LFQH_Lloh1801:
nop
ldp	x29, x30, [sp, #80]
ldp	x20, x19, [sp, #64]
ldp	x22, x21, [sp, #48]
ldp	x24, x23, [sp, #32]
ldp	x26, x25, [sp, #16]
ldp	x28, x27, [sp], #96
b	LFQH_RecordMineGameRemoval
LFQH_LBB93_13:
ldp	x29, x30, [sp, #80]
ldp	x20, x19, [sp, #64]
ldp	x22, x21, [sp, #48]
ldp	x24, x23, [sp, #32]
ldp	x26, x25, [sp, #16]
ldp	x28, x27, [sp], #96
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
LFQH_Lloh1802:
adr x0, LFQH_l_.str.175
LFQH_Lloh1803:
nop
LFQH_Lloh1804:
adr x1, LFQH_l_.str.177
LFQH_Lloh1805:
nop
bl	LFQH_Original
mov	x8, x0
mov	x0, x20
mov	x1, x21
mov	x2, x19
blr	x8
mov	x19, x0
LFQH_Lloh1806:
adr x1, LFQH_l_.str.33
LFQH_Lloh1807:
nop
bl	LFQH_Kind
cbz	w0, LFQH_LBB94_22
LFQH_Lloh1808:
adr x0, LFQH_l_.str.175
LFQH_Lloh1809:
nop
bl Lpatch + (0xa5b0 - PATCH_BASE)
mov	x21, x0
LFQH_Lloh1810:
adr x1, LFQH_MineControllersKey
LFQH_Lloh1811:
nop
bl Lpatch + (0xa628 - PATCH_BASE)
mov	x22, x0
cbnz	x0, LFQH_LBB94_3
LFQH_Lloh1812:
adr x0, LFQH_l_.str.406
LFQH_Lloh1813:
nop
bl Lpatch + (0xa5b0 - PATCH_BASE)
mov	x22, x0
LFQH_Lloh1814:
adr x0, LFQH_l_.str.407
LFQH_Lloh1815:
nop
bl Lpatch + (0xa5a4 - PATCH_BASE)
mov	x1, x0
mov	x0, x22
bl Lpatch + (0xa5d4 - PATCH_BASE)
mov	x22, x0
LFQH_Lloh1816:
adr x1, LFQH_MineControllersKey
LFQH_Lloh1817:
nop
mov	x0, x21
mov	x2, x22
mov	w3, #1
bl Lpatch + (0xa634 - PATCH_BASE)
LFQH_LBB94_3:
LFQH_Lloh1818:
adr x0, LFQH_l_.str.283
LFQH_Lloh1819:
nop
bl Lpatch + (0xa5a4 - PATCH_BASE)
mov	x1, x0
mov	x0, x22
mov	x2, x20
bl Lpatch + (0xa5d4 - PATCH_BASE)
LFQH_Lloh1820:
adr x0, LFQH_l_.str.244
LFQH_Lloh1821:
nop
bl Lpatch + (0xa5b0 - PATCH_BASE)
mov	x20, x0
LFQH_Lloh1822:
adr x0, LFQH_l_.str.245
LFQH_Lloh1823:
nop
bl Lpatch + (0xa5a4 - PATCH_BASE)
mov	x1, x0
LFQH_Lloh1824:
adr x2, LFQH_l_.str.437
LFQH_Lloh1825:
nop
mov	x0, x20
bl Lpatch + (0xa5d4 - PATCH_BASE)
bl	LFQH_DefaultEnabled
mov	x20, x0
LFQH_Lloh1826:
adr x0, LFQH_l_.str.34
LFQH_Lloh1827:
nop
bl Lpatch + (0xa5a4 - PATCH_BASE)
mov	x1, x0
mov	x0, x19
bl Lpatch + (0xa5d4 - PATCH_BASE)
cbz	x0, LFQH_LBB94_20
mov	w28, #0
mov	x22, #0
sub	x21, x0, #1
LFQH_Lloh1828:
adr x23, LFQH_l_.str.327
LFQH_Lloh1829:
nop
LFQH_Lloh1830:
adr x27, LFQH_l_.str.556
LFQH_Lloh1831:
nop
LFQH_Lloh1832:
adr x26, LFQH_l_.str.551
LFQH_Lloh1833:
nop
LFQH_LBB94_5:
mov	x0, x23
bl Lpatch + (0xa5a4 - PATCH_BASE)
mov	x1, x0
mov	x0, x19
mov	x2, x21
bl Lpatch + (0xa5d4 - PATCH_BASE)
mov	x25, x0
bl	LFQH_MineStandaloneGameRow
mov	x24, x0
tbz	w0, #0, LFQH_LBB94_9
LFQH_LBB94_6:
cbnz	x22, LFQH_LBB94_8
mov	x0, x26
bl Lpatch + (0xa5a4 - PATCH_BASE)
mov	x1, x0
mov	x0, x19
bl Lpatch + (0xa5d4 - PATCH_BASE)
mov	x22, x0
LFQH_Lloh1834:
adr x0, LFQH_l_.str.552
LFQH_Lloh1835:
nop
bl Lpatch + (0xa5a4 - PATCH_BASE)
mov	x1, x0
mov	x0, x22
bl Lpatch + (0xa5d4 - PATCH_BASE)
mov	x22, x0
LFQH_LBB94_8:
orr	w28, w24, w28
LFQH_Lloh1836:
adr x0, LFQH_l_.str.553
LFQH_Lloh1837:
nop
bl Lpatch + (0xa5a4 - PATCH_BASE)
mov	x1, x0
mov	x0, x22
mov	x2, x21
bl Lpatch + (0xa5d4 - PATCH_BASE)
b	LFQH_LBB94_10
LFQH_LBB94_9:
cbz	w20, LFQH_LBB94_11
LFQH_LBB94_10:
sub	x21, x21, #1
cmn	x21, #1
b.eq	LFQH_LBB94_18
b	LFQH_LBB94_5
LFQH_LBB94_11:
mov	x0, x25
LFQH_Lloh1838:
adr x1, LFQH_l_.str.171
LFQH_Lloh1839:
nop
bl	LFQH_Kind
cbz	w0, LFQH_LBB94_10
mov	x23, x20
mov	x20, x26
mov	x0, x25
bl Lpatch + (0xa664 - PATCH_BASE)
mov	x26, x27
mov	x1, x27
LFQH_Lloh1840:
adr x2, LFQH_l_.str.498
LFQH_Lloh1841:
nop
bl	LFQH_ClassABI
cbz	w0, LFQH_LBB94_17
mov	x0, x26
bl Lpatch + (0xa5a4 - PATCH_BASE)
mov	x1, x0
mov	x0, x25
bl Lpatch + (0xa5d4 - PATCH_BASE)
and	x8, x0, #0xfffffffffffffffe
cmp	x8, #4
mov	x26, x20
mov	x20, x23
LFQH_Lloh1842:
adr x23, LFQH_l_.str.327
LFQH_Lloh1843:
nop
b.eq	LFQH_LBB94_6
cbnz	x0, LFQH_LBB94_10
mov	x0, x25
LFQH_Lloh1844:
adr x1, LFQH_l_.str.557
LFQH_Lloh1845:
nop
bl	LFQH_BoolProp
cbnz	w0, LFQH_LBB94_6
mov	x0, x25
LFQH_Lloh1846:
adr x1, LFQH_l_.str.558
LFQH_Lloh1847:
nop
bl	LFQH_BoolProp
cbz	w0, LFQH_LBB94_6
b	LFQH_LBB94_10
LFQH_LBB94_17:
mov	x27, x26
mov	x26, x20
mov	x20, x23
LFQH_Lloh1848:
adr x23, LFQH_l_.str.327
LFQH_Lloh1849:
nop
b	LFQH_LBB94_10
LFQH_LBB94_18:
tst	w28, #0xff
b.eq	LFQH_LBB94_21
LFQH_Lloh1850:
adr x0, LFQH_l_.str.175
LFQH_Lloh1851:
nop
LFQH_Lloh1852:
adr x1, LFQH_l_.str.555
LFQH_Lloh1853:
nop
bl	LFQH_RecordMineGameRemoval
b	LFQH_LBB94_21
LFQH_LBB94_20:
mov	x22, #0
LFQH_LBB94_21:
cmp	x22, #0
csel	x19, x19, x22, eq
LFQH_LBB94_22:
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
mov	x19, x0
LFQH_Lloh1854:
adr x1, LFQH_ShelfDurationRequestedKey
LFQH_Lloh1855:
nop
bl Lpatch + (0xa628 - PATCH_BASE)
cbnz	x0, LFQH_LBB95_4
LFQH_Lloh1856:
adr x0, LFQH_l_.str.21
LFQH_Lloh1857:
nop
bl Lpatch + (0xa5b0 - PATCH_BASE)
mov	x21, x0
LFQH_Lloh1858:
adr x1, LFQH_ShelfDurationHeadersKey
LFQH_Lloh1859:
nop
bl Lpatch + (0xa628 - PATCH_BASE)
mov	x22, x0
cbnz	x0, LFQH_LBB95_3
LFQH_Lloh1860:
adr x0, LFQH_l_.str.406
LFQH_Lloh1861:
nop
bl Lpatch + (0xa5b0 - PATCH_BASE)
mov	x22, x0
LFQH_Lloh1862:
adr x0, LFQH_l_.str.407
LFQH_Lloh1863:
nop
bl Lpatch + (0xa5a4 - PATCH_BASE)
mov	x1, x0
mov	x0, x22
bl Lpatch + (0xa5d4 - PATCH_BASE)
mov	x22, x0
LFQH_Lloh1864:
adr x1, LFQH_ShelfDurationHeadersKey
LFQH_Lloh1865:
nop
mov	x0, x21
mov	x2, x22
mov	w3, #1
bl Lpatch + (0xa634 - PATCH_BASE)
LFQH_LBB95_3:
LFQH_Lloh1866:
adr x0, LFQH_l_.str.283
LFQH_Lloh1867:
nop
bl Lpatch + (0xa5a4 - PATCH_BASE)
mov	x1, x0
mov	x0, x22
mov	x2, x19
bl Lpatch + (0xa5d4 - PATCH_BASE)
LFQH_LBB95_4:
LFQH_Lloh1868:
adr x0, LFQH_l_.str.267
LFQH_Lloh1869:
nop
bl Lpatch + (0xa5b0 - PATCH_BASE)
mov	x21, x0
LFQH_Lloh1870:
adr x0, LFQH_l_.str.334
LFQH_Lloh1871:
nop
bl Lpatch + (0xa5a4 - PATCH_BASE)
mov	x1, x0
mov	x0, x21
mov	x2, x20
bl Lpatch + (0xa5d4 - PATCH_BASE)
mov	x2, x0
LFQH_Lloh1872:
adr x1, LFQH_ShelfDurationRequestedKey
LFQH_Lloh1873:
nop
mov	x0, x19
mov	w3, #1
bl Lpatch + (0xa634 - PATCH_BASE)
cbz	w20, LFQH_LBB95_6
LFQH_Lloh1874:
adr x0, LFQH_l_.str.244
LFQH_Lloh1875:
nop
bl Lpatch + (0xa5b0 - PATCH_BASE)
mov	x20, x0
LFQH_Lloh1876:
adr x0, LFQH_l_.str.245
LFQH_Lloh1877:
nop
bl Lpatch + (0xa5a4 - PATCH_BASE)
mov	x1, x0
LFQH_Lloh1878:
adr x2, LFQH_l_.str.436
LFQH_Lloh1879:
nop
mov	x0, x20
bl Lpatch + (0xa5d4 - PATCH_BASE)
bl	LFQH_DefaultEnabled
cmp	w0, #0
cset	w1, ne
b	LFQH_LBB95_7
LFQH_LBB95_6:
mov	w1, #0
LFQH_LBB95_7:
mov	x0, x19
ldp	x29, x30, [sp, #32]
ldp	x20, x19, [sp, #16]
ldp	x22, x21, [sp], #48
b	LFQH_ApplyShelfDuration
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
LFQH_Lloh1880:
adr x1, LFQH_ShelfDurationRequestedKey
LFQH_Lloh1881:
nop
bl Lpatch + (0xa628 - PATCH_BASE)
cbnz	x0, LFQH_LBB96_3
mov	x0, x19
bl Lpatch + (0xa664 - PATCH_BASE)
LFQH_Lloh1882:
adr x1, LFQH_l_.str.356
LFQH_Lloh1883:
nop
LFQH_Lloh1884:
adr x2, LFQH_l_.str.97
LFQH_Lloh1885:
nop
bl	LFQH_ClassABI
cbz	w0, LFQH_LBB96_3
LFQH_Lloh1886:
adr x0, LFQH_l_.str.356
LFQH_Lloh1887:
nop
bl Lpatch + (0xa5a4 - PATCH_BASE)
mov	x1, x0
mov	x0, x19
bl Lpatch + (0xa5d4 - PATCH_BASE)
mov	x2, x0
mov	x0, x19
bl	LFQH_ShelfDurationVisible
LFQH_LBB96_3:
LFQH_Lloh1888:
adr x0, LFQH_l_.str.21
LFQH_Lloh1889:
nop
LFQH_Lloh1890:
adr x1, LFQH_l_.str.59
LFQH_Lloh1891:
nop
bl	LFQH_Original
mov	x8, x0
mov	x0, x19
mov	x1, x20
blr	x8
LFQH_Lloh1892:
adr x1, LFQH_l_.str.369
LFQH_Lloh1893:
nop
mov	x0, x19
bl	LFQH_Get
mov	x20, x0
LFQH_Lloh1894:
adr x1, LFQH_l_.str.39
LFQH_Lloh1895:
nop
bl	LFQH_Get
mov	x21, x0
LFQH_Lloh1896:
adr x1, LFQH_l_.str.23
LFQH_Lloh1897:
nop
bl	LFQH_Kind
cbz	w0, LFQH_LBB96_5
mov	x0, x20
mov	x1, x21
bl	LFQH_ShelfEditPlacement
mov	x22, x0
LFQH_Lloh1898:
adr x1, LFQH_l_.str.37
LFQH_Lloh1899:
nop
mov	x0, x20
bl	LFQH_Get
mov	x23, x0
LFQH_Lloh1900:
adr x1, LFQH_l_.str.38
LFQH_Lloh1901:
nop
mov	x0, x20
bl	LFQH_Get
mov	x2, x0
mov	x0, x21
mov	x1, x23
mov	x3, x22
bl	LFQH_ShelfTopHit
cbnz	x22, LFQH_LBB96_6
LFQH_LBB96_5:
LFQH_Lloh1902:
adr x1, LFQH_l_.str.60
LFQH_Lloh1903:
nop
mov	x0, x19
bl	LFQH_Get
mov	w1, #0
bl	LFQH_ShelfActionGlass
LFQH_LBB96_6:
LFQH_Lloh1904:
adr x1, LFQH_l_.str.61
LFQH_Lloh1905:
nop
mov	x0, x19
bl	LFQH_Get
mov	w1, #1
bl	LFQH_ShelfActionGlass
LFQH_Lloh1906:
adr x1, LFQH_l_.str.62
LFQH_Lloh1907:
nop
mov	x0, x19
bl	LFQH_Get
mov	w1, #1
ldp	x29, x30, [sp, #48]
ldp	x20, x19, [sp, #32]
ldp	x22, x21, [sp, #16]
ldp	x24, x23, [sp], #64
b	LFQH_ShelfActionGlass
.cfi_endproc
.p2align	2
LFQH_ShelfStockEditLayout:
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
LFQH_Lloh1908:
adr x1, LFQH_l_.str.60
LFQH_Lloh1909:
nop
bl	LFQH_Get
mov	x21, x0
LFQH_Lloh1910:
adr x1, LFQH_l_.str.20
LFQH_Lloh1911:
nop
bl	LFQH_Get
cbz	x0, LFQH_LBB97_2
LFQH_Lloh1912:
adr x1, LFQH_ShelfEditHeaderKey
LFQH_Lloh1913:
nop
bl Lpatch + (0xa628 - PATCH_BASE)
cmp	x0, x20
b.eq	LFQH_LBB97_3
LFQH_LBB97_2:
mov	x0, x21
bl	LFQH_ShelfEditPadding
LFQH_Lloh1914:
adr x0, LFQH_l_.str.21
LFQH_Lloh1915:
nop
LFQH_Lloh1916:
adr x1, LFQH_l_.str.181
LFQH_Lloh1917:
nop
bl	LFQH_Original
mov	x2, x0
mov	x0, x20
mov	x1, x19
ldp	x29, x30, [sp, #32]
ldp	x20, x19, [sp, #16]
ldp	x22, x21, [sp], #48
br	x2
LFQH_LBB97_3:
ldp	x29, x30, [sp, #32]
ldp	x20, x19, [sp, #16]
ldp	x22, x21, [sp], #48
ret
.cfi_endproc
.p2align	2
LFQH_ShelfSaveOpeningData:
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
mov	x20, x2
mov	x21, x1
mov	x22, x0
LFQH_Lloh1918:
adr x1, LFQH_ShelfCompactKey
LFQH_Lloh1919:
nop
bl Lpatch + (0xa628 - PATCH_BASE)
cbz	x0, LFQH_LBB98_2
LFQH_Lloh1920:
adr x1, LFQH_l_.str.364
LFQH_Lloh1921:
nop
mov	x0, x22
bl	LFQH_Get
mov	x23, x0
LFQH_Lloh1922:
adr x0, LFQH_l_.str.559
LFQH_Lloh1923:
nop
bl Lpatch + (0xa5a4 - PATCH_BASE)
mov	x1, x0
mov	x0, x23
bl Lpatch + (0xa5d4 - PATCH_BASE)
LFQH_LBB98_2:
LFQH_Lloh1924:
adr x0, LFQH_l_.str.182
LFQH_Lloh1925:
nop
LFQH_Lloh1926:
adr x1, LFQH_l_.str.184
LFQH_Lloh1927:
nop
bl	LFQH_Original
mov	x4, x0
mov	x0, x22
mov	x1, x21
mov	x2, x20
mov	x3, x19
ldp	x29, x30, [sp, #48]
ldp	x20, x19, [sp, #32]
ldp	x22, x21, [sp, #16]
ldp	x24, x23, [sp], #64
br	x4
.cfi_endproc
.p2align	2
LFQH_ShelfCoverTransitionInfo:
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
mov	x19, x2
mov	x22, x1
mov	x20, x0
and	x8, x2, #0xfffffffffffffffe
cmp	x8, #2
b.ne	LFQH_LBB99_3
LFQH_Lloh1928:
adr x1, LFQH_ShelfCompactKey
LFQH_Lloh1929:
nop
mov	x0, x20
bl Lpatch + (0xa628 - PATCH_BASE)
cbz	x0, LFQH_LBB99_3
LFQH_Lloh1930:
adr x1, LFQH_l_.str.364
LFQH_Lloh1931:
nop
mov	x0, x20
bl	LFQH_Get
mov	x21, x0
LFQH_Lloh1932:
adr x0, LFQH_l_.str.559
LFQH_Lloh1933:
nop
bl Lpatch + (0xa5a4 - PATCH_BASE)
mov	x1, x0
mov	x0, x21
bl Lpatch + (0xa5d4 - PATCH_BASE)
mov	w23, #1
b	LFQH_LBB99_4
LFQH_LBB99_3:
mov	x21, #0
mov	w23, #0
LFQH_LBB99_4:
LFQH_Lloh1934:
adr x0, LFQH_l_.str.182
LFQH_Lloh1935:
nop
LFQH_Lloh1936:
adr x1, LFQH_l_.str.186
LFQH_Lloh1937:
nop
bl	LFQH_Original
mov	x8, x0
mov	x0, x20
mov	x1, x22
mov	x2, x19
blr	x8
mov	x19, x0
cbz	w23, LFQH_LBB99_22
LFQH_Lloh1938:
adr x1, LFQH_ShelfCompactKey
LFQH_Lloh1939:
nop
mov	x0, x20
bl Lpatch + (0xa628 - PATCH_BASE)
cbz	x0, LFQH_LBB99_22
LFQH_Lloh1940:
adr x1, LFQH_l_.str.560
LFQH_Lloh1941:
nop
mov	x0, x19
bl	LFQH_Kind
cbz	w0, LFQH_LBB99_22
mov	x0, x19
bl Lpatch + (0xa664 - PATCH_BASE)
LFQH_Lloh1942:
adr x1, LFQH_l_.str.561
LFQH_Lloh1943:
nop
LFQH_Lloh1944:
adr x2, LFQH_l_.str.562
LFQH_Lloh1945:
nop
bl	LFQH_ClassABI
cbz	w0, LFQH_LBB99_22
LFQH_Lloh1946:
adr x1, LFQH_l_.str.563
LFQH_Lloh1947:
nop
mov	x0, x20
bl	LFQH_Get
LFQH_Lloh1948:
adr x1, LFQH_l_.str.564
LFQH_Lloh1949:
nop
bl	LFQH_Get
LFQH_Lloh1950:
adr x1, LFQH_l_.str.565
LFQH_Lloh1951:
nop
bl	LFQH_Get
mov	x20, x0
LFQH_Lloh1952:
adr x1, LFQH_l_.str.373
LFQH_Lloh1953:
nop
mov	x0, x21
bl	LFQH_Get
mov	x21, x0
LFQH_Lloh1954:
adr x0, LFQH_l_.str.34
LFQH_Lloh1955:
nop
bl Lpatch + (0xa5a4 - PATCH_BASE)
mov	x1, x0
mov	x0, x21
bl Lpatch + (0xa5d4 - PATCH_BASE)
mov	x22, x0
mov	x0, #0
cbz	x20, LFQH_LBB99_23
cbz	x22, LFQH_LBB99_23
str	x19, [sp, #8]
mov	x23, #0
LFQH_Lloh1956:
adr x28, LFQH_l_.str.565
LFQH_Lloh1957:
nop
LFQH_Lloh1958:
adr x24, LFQH_l_.str.48
LFQH_Lloh1959:
nop
LFQH_LBB99_11:
LFQH_Lloh1960:
adr x0, LFQH_l_.str.327
LFQH_Lloh1961:
nop
bl Lpatch + (0xa5a4 - PATCH_BASE)
mov	x1, x0
mov	x0, x21
mov	x2, x23
bl Lpatch + (0xa5d4 - PATCH_BASE)
mov	x25, x0
LFQH_Lloh1962:
adr x1, LFQH_l_.str.91
LFQH_Lloh1963:
nop
bl	LFQH_Get
LFQH_Lloh1964:
adr x1, LFQH_l_.str.566
LFQH_Lloh1965:
nop
bl	LFQH_Get
mov	x26, x0
LFQH_Lloh1966:
adr x0, LFQH_l_.str.567
LFQH_Lloh1967:
nop
bl Lpatch + (0xa5a4 - PATCH_BASE)
mov	x1, x0
mov	x0, x26
bl Lpatch + (0xa5d4 - PATCH_BASE)
mov	x1, x28
bl	LFQH_Get
mov	x26, x0
mov	x0, x24
bl Lpatch + (0xa5a4 - PATCH_BASE)
mov	x1, x0
mov	x0, x20
mov	x2, x26
bl Lpatch + (0xa5d4 - PATCH_BASE)
cbz	w0, LFQH_LBB99_18
mov	x0, x25
LFQH_Lloh1968:
adr x1, LFQH_l_.str.568
LFQH_Lloh1969:
nop
bl	LFQH_Get
mov	x26, x0
LFQH_Lloh1970:
adr x1, LFQH_l_.str.312
LFQH_Lloh1971:
nop
bl	LFQH_Get
cbz	x0, LFQH_LBB99_18
mov	x27, x0
mov	x19, x22
mov	x22, x21
mov	x21, x20
mov	x20, x24
mov	x24, x28
mov	x0, x25
bl Lpatch + (0xa664 - PATCH_BASE)
LFQH_Lloh1972:
adr x28, LFQH_l_.str.569
LFQH_Lloh1973:
nop
mov	x1, x28
LFQH_Lloh1974:
adr x2, LFQH_l_.str.570
LFQH_Lloh1975:
nop
bl	LFQH_ClassABI
cbz	w0, LFQH_LBB99_20
LFQH_Lloh1976:
adr x0, LFQH_l_.str.24
LFQH_Lloh1977:
nop
bl Lpatch + (0xa5a4 - PATCH_BASE)
mov	x1, x0
mov	x0, x26
bl Lpatch + (0xa5d4 - PATCH_BASE)
mov.16b	v8, v0
mov.16b	v9, v1
mov.16b	v10, v2
mov.16b	v11, v3
LFQH_Lloh1978:
adr x0, LFQH_l_.str.303
LFQH_Lloh1979:
nop
bl Lpatch + (0xa5a4 - PATCH_BASE)
mov	x1, x0
mov	x0, x26
mov.16b	v0, v8
mov.16b	v1, v9
mov.16b	v2, v10
mov.16b	v3, v11
mov	x2, x27
bl Lpatch + (0xa5d4 - PATCH_BASE)
mov.16b	v8, v0
mov.16b	v9, v1
fmov	x26, d9
fmov	x27, d8
mov	x0, x28
bl Lpatch + (0xa5a4 - PATCH_BASE)
mov	x1, x0
mov	x0, x25
bl Lpatch + (0xa5d4 - PATCH_BASE)
mov.16b	v10, v0
fmov	x8, d10
ubfx	x9, x27, #52, #11
ubfx	x10, x26, #52, #11
ubfx	x8, x8, #52, #11
cmp	x8, #2046
mov	w8, #2046
ccmp	x10, x8, #2, ls
ccmp	x9, x8, #2, ls
mov	x28, x24
mov	x24, x20
mov	x20, x21
mov	x21, x22
mov	x22, x19
b.hi	LFQH_LBB99_18
mov.16b	v11, v1
fmov	x8, d11
ubfx	x8, x8, #52, #11
cmp	x8, #2046
b.hi	LFQH_LBB99_18
fcmp	d10, #0.0
b.le	LFQH_LBB99_18
fcmp	d11, #0.0
b.gt	LFQH_LBB99_21
LFQH_LBB99_18:
add	x23, x23, #1
cmp	x23, x22
b.lo	LFQH_LBB99_11
mov	x0, #0
b	LFQH_LBB99_23
LFQH_LBB99_20:
ldr	x0, [sp, #8]
b	LFQH_LBB99_23
LFQH_LBB99_21:
LFQH_Lloh1980:
adr x0, LFQH_l_.str.561
LFQH_Lloh1981:
nop
bl Lpatch + (0xa5a4 - PATCH_BASE)
mov	x1, x0
ldr	x19, [sp, #8]
mov	x0, x19
mov.16b	v0, v8
mov.16b	v1, v9
mov.16b	v2, v10
mov.16b	v3, v11
bl Lpatch + (0xa5d4 - PATCH_BASE)
LFQH_LBB99_22:
mov	x0, x19
LFQH_LBB99_23:
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
.cfi_endproc
.p2align	2
LFQH_TabPlan:
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
mov	x20, x1
mov	x19, x0
LFQH_Lloh1982:
adr x0, LFQH_l_.str.188
LFQH_Lloh1983:
nop
LFQH_Lloh1984:
adr x1, LFQH_l_.str.190
LFQH_Lloh1985:
nop
bl	LFQH_Original
mov	x8, x0
mov	x0, x19
mov	x1, x20
blr	x8
mov	x20, x0
LFQH_Lloh1986:
adr x1, LFQH_l_.str.383
LFQH_Lloh1987:
nop
mov	x0, x19
bl	LFQH_Get
mov	x23, x0
LFQH_Lloh1988:
adr x1, LFQH_l_.str.33
LFQH_Lloh1989:
nop
mov	x0, x20
bl	LFQH_Kind
cbz	w0, LFQH_LBB100_12
LFQH_Lloh1990:
adr x1, LFQH_l_.str.33
LFQH_Lloh1991:
nop
mov	x0, x23
bl	LFQH_Kind
cbz	w0, LFQH_LBB100_12
mov	x0, x19
bl Lpatch + (0xa664 - PATCH_BASE)
LFQH_Lloh1992:
adr x1, LFQH_l_.str.586
LFQH_Lloh1993:
nop
LFQH_Lloh1994:
adr x2, LFQH_l_.str.120
LFQH_Lloh1995:
nop
bl	LFQH_ClassABI
cbz	w0, LFQH_LBB100_12
mov	x0, x19
bl Lpatch + (0xa664 - PATCH_BASE)
LFQH_Lloh1996:
adr x1, LFQH_l_.str.587
LFQH_Lloh1997:
nop
LFQH_Lloh1998:
adr x2, LFQH_l_.str.120
LFQH_Lloh1999:
nop
bl	LFQH_ClassABI
cbz	w0, LFQH_LBB100_12
LFQH_Lloh2000:
adr x0, LFQH_l_.str.34
LFQH_Lloh2001:
nop
bl Lpatch + (0xa5a4 - PATCH_BASE)
mov	x1, x0
mov	x0, x23
bl Lpatch + (0xa5d4 - PATCH_BASE)
cbz	x0, LFQH_LBB100_12
mov	x27, x0
LFQH_Lloh2002:
adr x0, LFQH_l_.str.34
LFQH_Lloh2003:
nop
bl Lpatch + (0xa5a4 - PATCH_BASE)
mov	x1, x0
mov	x0, x20
bl Lpatch + (0xa5d4 - PATCH_BASE)
cmp	x0, x27
b.ne	LFQH_LBB100_12
LFQH_Lloh2004:
adr x21, LFQH_l_.str.70
LFQH_Lloh2005:
nop
mov	x0, x21
bl Lpatch + (0xa5b0 - PATCH_BASE)
mov	x22, x0
LFQH_Lloh2006:
adr x24, LFQH_l_.str.280
LFQH_Lloh2007:
nop
mov	x0, x24
bl Lpatch + (0xa5a4 - PATCH_BASE)
mov	x1, x0
mov	x0, x22
bl Lpatch + (0xa5d4 - PATCH_BASE)
str	x0, [sp, #8]
mov	x0, x21
bl Lpatch + (0xa5b0 - PATCH_BASE)
mov	x21, x0
mov	x0, x24
bl Lpatch + (0xa5a4 - PATCH_BASE)
mov	x1, x0
mov	x0, x21
bl Lpatch + (0xa5d4 - PATCH_BASE)
mov	x21, x0
LFQH_Lloh2008:
adr x0, LFQH_l_.str.273
LFQH_Lloh2009:
nop
bl Lpatch + (0xa5b0 - PATCH_BASE)
mov	x22, x0
LFQH_Lloh2010:
adr x0, LFQH_l_.str.274
LFQH_Lloh2011:
nop
bl Lpatch + (0xa5a4 - PATCH_BASE)
mov	x1, x0
mov	x0, x22
bl Lpatch + (0xa5d4 - PATCH_BASE)
str	x0, [sp]
mov	x28, #0
mov	x26, #0
LFQH_LBB100_7:
LFQH_Lloh2012:
adr x0, LFQH_l_.str.327
LFQH_Lloh2013:
nop
bl Lpatch + (0xa5a4 - PATCH_BASE)
mov	x1, x0
mov	x0, x23
mov	x2, x26
bl Lpatch + (0xa5d4 - PATCH_BASE)
mov	x24, x0
mov	x0, x19
mov	x1, x24
bl	LFQH_TabOption
bl	LFQH_PagePreference
cbz	x0, LFQH_LBB100_9
bl	LFQH_DefaultEnabled
cbz	w0, LFQH_LBB100_10
LFQH_LBB100_9:
LFQH_Lloh2014:
adr x0, LFQH_l_.str.267
LFQH_Lloh2015:
nop
bl Lpatch + (0xa5b0 - PATCH_BASE)
mov	x22, x0
LFQH_Lloh2016:
adr x0, LFQH_l_.str.588
LFQH_Lloh2017:
nop
bl Lpatch + (0xa5a4 - PATCH_BASE)
mov	x1, x0
add	x25, x28, #1
mov	x0, x22
mov	x2, x28
bl Lpatch + (0xa5d4 - PATCH_BASE)
mov	x22, x0
LFQH_Lloh2018:
adr x0, LFQH_l_.str.289
LFQH_Lloh2019:
nop
bl Lpatch + (0xa5a4 - PATCH_BASE)
mov	x1, x0
ldr	x0, [sp]
mov	x2, x22
mov	x3, x24
bl Lpatch + (0xa5d4 - PATCH_BASE)
LFQH_Lloh2020:
adr x22, LFQH_l_.str.283
LFQH_Lloh2021:
nop
mov	x0, x22
bl Lpatch + (0xa5a4 - PATCH_BASE)
mov	x1, x0
ldr	x0, [sp, #8]
mov	x2, x24
bl Lpatch + (0xa5d4 - PATCH_BASE)
mov	x0, x22
bl Lpatch + (0xa5a4 - PATCH_BASE)
mov	x22, x0
LFQH_Lloh2022:
adr x0, LFQH_l_.str.327
LFQH_Lloh2023:
nop
bl Lpatch + (0xa5a4 - PATCH_BASE)
mov	x1, x0
mov	x0, x20
mov	x2, x26
bl Lpatch + (0xa5d4 - PATCH_BASE)
mov	x2, x0
mov	x0, x21
mov	x1, x22
bl Lpatch + (0xa5d4 - PATCH_BASE)
mov	x28, x25
LFQH_LBB100_10:
add	x26, x26, #1
cmp	x27, x26
b.ne	LFQH_LBB100_7
cmp	x28, x27
b.ne	LFQH_LBB100_14
LFQH_LBB100_12:
mov	x21, x20
LFQH_LBB100_13:
mov	x0, x21
ldp	x29, x30, [sp, #96]
ldp	x20, x19, [sp, #80]
ldp	x22, x21, [sp, #64]
ldp	x24, x23, [sp, #48]
ldp	x26, x25, [sp, #32]
ldp	x28, x27, [sp, #16]
add	sp, sp, #112
ret
LFQH_LBB100_14:
cbnz	x28, LFQH_LBB100_16
LFQH_Lloh2024:
adr x24, LFQH_l_.str.327
LFQH_Lloh2025:
nop
mov	x0, x24
bl Lpatch + (0xa5a4 - PATCH_BASE)
mov	x1, x0
mov	x0, x23
mov	x2, #0
bl Lpatch + (0xa5d4 - PATCH_BASE)
mov	x22, x0
LFQH_Lloh2026:
adr x0, LFQH_l_.str.267
LFQH_Lloh2027:
nop
bl Lpatch + (0xa5b0 - PATCH_BASE)
mov	x23, x0
LFQH_Lloh2028:
adr x0, LFQH_l_.str.588
LFQH_Lloh2029:
nop
bl Lpatch + (0xa5a4 - PATCH_BASE)
mov	x1, x0
mov	x0, x23
mov	x2, #0
bl Lpatch + (0xa5d4 - PATCH_BASE)
mov	x23, x0
LFQH_Lloh2030:
adr x0, LFQH_l_.str.289
LFQH_Lloh2031:
nop
bl Lpatch + (0xa5a4 - PATCH_BASE)
mov	x1, x0
ldr	x0, [sp]
mov	x2, x23
mov	x3, x22
bl Lpatch + (0xa5d4 - PATCH_BASE)
LFQH_Lloh2032:
adr x23, LFQH_l_.str.283
LFQH_Lloh2033:
nop
mov	x0, x23
bl Lpatch + (0xa5a4 - PATCH_BASE)
mov	x1, x0
ldr	x0, [sp, #8]
mov	x2, x22
bl Lpatch + (0xa5d4 - PATCH_BASE)
mov	x0, x23
bl Lpatch + (0xa5a4 - PATCH_BASE)
mov	x23, x0
mov	x0, x24
bl Lpatch + (0xa5a4 - PATCH_BASE)
mov	x1, x0
mov	x0, x20
mov	x2, #0
bl Lpatch + (0xa5d4 - PATCH_BASE)
mov	x2, x0
mov	x0, x21
mov	x1, x23
bl Lpatch + (0xa5d4 - PATCH_BASE)
mov	x0, x19
mov	x1, x22
bl	LFQH_TabOption
bl	LFQH_PagePreference
mov	w1, #1
bl	LFQH_SetDefault
LFQH_LBB100_16:
LFQH_Lloh2034:
adr x0, LFQH_l_.str.586
LFQH_Lloh2035:
nop
bl Lpatch + (0xa5a4 - PATCH_BASE)
mov	x1, x0
mov	x0, x19
ldr	x2, [sp, #8]
bl Lpatch + (0xa5d4 - PATCH_BASE)
LFQH_Lloh2036:
adr x0, LFQH_l_.str.587
LFQH_Lloh2037:
nop
bl Lpatch + (0xa5a4 - PATCH_BASE)
mov	x1, x0
mov	x0, x19
ldr	x2, [sp]
bl Lpatch + (0xa5d4 - PATCH_BASE)
b	LFQH_LBB100_13
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
LFQH_Lloh2038:
adr x0, LFQH_l_.str.188
LFQH_Lloh2039:
nop
LFQH_Lloh2040:
adr x1, LFQH_l_.str.192
LFQH_Lloh2041:
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
bl	LFQH_FQHGlassAvailable
cbz	w0, LFQH_LBB102_8
LFQH_Lloh2042:
adr x0, LFQH_l_.str.43
LFQH_Lloh2043:
nop
LFQH_Lloh2044:
adr x19, LFQH_l_.str.103
LFQH_Lloh2045:
nop
LFQH_Lloh2046:
adr x2, LFQH_l_.str.193
LFQH_Lloh2047:
nop
LFQH_Lloh2048:
adr x20, LFQH_l_.str.9
LFQH_Lloh2049:
nop
LFQH_Lloh2050:
adr x4, LFQH_ListenLayout
LFQH_Lloh2051:
nop
mov	x1, x19
mov	x3, x20
bl	LFQH_Hook
LFQH_Lloh2052:
adr x21, LFQH_l_.str.58
LFQH_Lloh2053:
nop
LFQH_Lloh2054:
adr x2, LFQH_l_.str.194
LFQH_Lloh2055:
nop
LFQH_Lloh2056:
adr x4, LFQH_SpeechLayout
LFQH_Lloh2057:
nop
mov	x0, x21
mov	x1, x19
mov	x3, x20
bl	LFQH_Hook
LFQH_Lloh2058:
adr x1, LFQH_l_.str.195
LFQH_Lloh2059:
nop
LFQH_Lloh2060:
adr x2, LFQH_l_.str.196
LFQH_Lloh2061:
nop
LFQH_Lloh2062:
adr x3, LFQH_l_.str.120
LFQH_Lloh2063:
nop
LFQH_Lloh2064:
adr x4, LFQH_SpeechTheme
LFQH_Lloh2065:
nop
mov	x0, x21
bl	LFQH_Hook
LFQH_Lloh2066:
adr x0, LFQH_l_.str.7
LFQH_Lloh2067:
nop
bl Lpatch + (0xa5b0 - PATCH_BASE)
LFQH_Lloh2068:
adr x1, LFQH_l_.str.10
LFQH_Lloh2069:
nop
LFQH_Lloh2070:
adr x2, LFQH_l_.str.11
LFQH_Lloh2071:
nop
bl	LFQH_ClassABI
cbz	w0, LFQH_LBB102_4
LFQH_Lloh2072:
adr x19, LFQH_l_.str.7
LFQH_Lloh2073:
nop
LFQH_Lloh2074:
adr x1, LFQH_l_.str.8
LFQH_Lloh2075:
nop
LFQH_Lloh2076:
adr x2, LFQH_l_.str.197
LFQH_Lloh2077:
nop
LFQH_Lloh2078:
adr x4, LFQH_HomeLayout
LFQH_Lloh2079:
nop
mov	x0, x19
mov	x3, x20
bl	LFQH_Hook
LFQH_Lloh2080:
adr x1, LFQH_l_.str.191
LFQH_Lloh2081:
nop
LFQH_Lloh2082:
adr x2, LFQH_l_.str.198
LFQH_Lloh2083:
nop
LFQH_Lloh2084:
adr x3, LFQH_l_.str.67
LFQH_Lloh2085:
nop
LFQH_Lloh2086:
adr x4, LFQH_HomeAppear
LFQH_Lloh2087:
nop
mov	x0, x19
bl	LFQH_Hook
LFQH_Lloh2088:
adr x1, LFQH_l_.str.199
LFQH_Lloh2089:
nop
LFQH_Lloh2090:
adr x2, LFQH_l_.str.200
LFQH_Lloh2091:
nop
LFQH_Lloh2092:
adr x3, LFQH_l_.str.174
LFQH_Lloh2093:
nop
LFQH_Lloh2094:
adr x4, LFQH_BookstoreTabSelected
LFQH_Lloh2095:
nop
mov	x0, x19
bl	LFQH_Hook
LFQH_Lloh2096:
adr x0, LFQH_l_.str.201
LFQH_Lloh2097:
nop
LFQH_Lloh2098:
adr x1, LFQH_l_.str.202
LFQH_Lloh2099:
nop
LFQH_Lloh2100:
adr x2, LFQH_l_.str.203
LFQH_Lloh2101:
nop
LFQH_Lloh2102:
adr x4, LFQH_BookstoreCollectionLayout
LFQH_Lloh2103:
nop
mov	x3, x20
bl	LFQH_Hook
LFQH_Lloh2104:
adr x19, LFQH_l_.str.204
LFQH_Lloh2105:
nop
LFQH_Lloh2106:
adr x1, LFQH_l_.str.205
LFQH_Lloh2107:
nop
LFQH_Lloh2108:
adr x2, LFQH_l_.str.206
LFQH_Lloh2109:
nop
LFQH_Lloh2110:
adr x4, LFQH_BookstoreDoubleRowLayout
LFQH_Lloh2111:
nop
mov	x0, x19
mov	x3, x20
bl	LFQH_Hook
LFQH_Lloh2112:
adr x1, LFQH_l_.str.207
LFQH_Lloh2113:
nop
LFQH_Lloh2114:
adr x2, LFQH_l_.str.208
LFQH_Lloh2115:
nop
LFQH_Lloh2116:
adr x3, LFQH_l_.str.120
LFQH_Lloh2117:
nop
LFQH_Lloh2118:
adr x4, LFQH_BookstoreDoubleRowScroll
LFQH_Lloh2119:
nop
mov	x0, x19
bl	LFQH_Hook
LFQH_Lloh2120:
adr x0, LFQH_l_.str.209
LFQH_Lloh2121:
nop
bl Lpatch + (0xa5b0 - PATCH_BASE)
LFQH_Lloh2122:
adr x1, LFQH_l_.str.210
LFQH_Lloh2123:
nop
LFQH_Lloh2124:
adr x2, LFQH_l_.str.11
LFQH_Lloh2125:
nop
bl	LFQH_ClassABI
cbz	w0, LFQH_LBB102_4
LFQH_Lloh2126:
adr x0, LFQH_l_.str.209
LFQH_Lloh2127:
nop
LFQH_Lloh2128:
adr x1, LFQH_l_.str.211
LFQH_Lloh2129:
nop
LFQH_Lloh2130:
adr x2, LFQH_l_.str.212
LFQH_Lloh2131:
nop
LFQH_Lloh2132:
adr x3, LFQH_l_.str.213
LFQH_Lloh2133:
nop
LFQH_Lloh2134:
adr x4, LFQH_SearchColor
LFQH_Lloh2135:
nop
bl	LFQH_Hook
LFQH_LBB102_4:
LFQH_Lloh2136:
adr x20, LFQH_l_.str.25
LFQH_Lloh2137:
nop
LFQH_Lloh2138:
adr x21, LFQH_l_.str.103
LFQH_Lloh2139:
nop
LFQH_Lloh2140:
adr x2, LFQH_l_.str.214
LFQH_Lloh2141:
nop
LFQH_Lloh2142:
adr x19, LFQH_l_.str.9
LFQH_Lloh2143:
nop
LFQH_Lloh2144:
adr x4, LFQH_CategoryLayout
LFQH_Lloh2145:
nop
mov	x0, x20
mov	x1, x21
mov	x3, x19
bl	LFQH_Hook
LFQH_Lloh2146:
adr x1, LFQH_l_.str.215
LFQH_Lloh2147:
nop
LFQH_Lloh2148:
adr x2, LFQH_l_.str.216
LFQH_Lloh2149:
nop
LFQH_Lloh2150:
adr x3, LFQH_l_.str.213
LFQH_Lloh2151:
nop
LFQH_Lloh2152:
adr x4, LFQH_CategoryColor
LFQH_Lloh2153:
nop
mov	x0, x20
bl	LFQH_Hook
LFQH_Lloh2154:
adr x0, LFQH_l_.str.217
LFQH_Lloh2155:
nop
LFQH_Lloh2156:
adr x2, LFQH_l_.str.218
LFQH_Lloh2157:
nop
LFQH_Lloh2158:
adr x4, LFQH_ShelfButtonLayout
LFQH_Lloh2159:
nop
mov	x1, x21
mov	x3, x19
bl	LFQH_Hook
LFQH_Lloh2160:
adr x20, LFQH_l_.str.219
LFQH_Lloh2161:
nop
LFQH_Lloh2162:
adr x1, LFQH_l_.str.220
LFQH_Lloh2163:
nop
LFQH_Lloh2164:
adr x2, LFQH_l_.str.221
LFQH_Lloh2165:
nop
LFQH_Lloh2166:
adr x4, LFQH_BookshelfTopLayout
LFQH_Lloh2167:
nop
mov	x0, x20
mov	x3, x19
bl	LFQH_Hook
LFQH_Lloh2168:
adr x1, LFQH_l_.str.199
LFQH_Lloh2169:
nop
LFQH_Lloh2170:
adr x2, LFQH_l_.str.222
LFQH_Lloh2171:
nop
LFQH_Lloh2172:
adr x3, LFQH_l_.str.174
LFQH_Lloh2173:
nop
LFQH_Lloh2174:
adr x4, LFQH_BookshelfTabSelected
LFQH_Lloh2175:
nop
mov	x0, x20
bl	LFQH_Hook
LFQH_Lloh2176:
adr x20, LFQH_l_.str.182
LFQH_Lloh2177:
nop
LFQH_Lloh2178:
adr x1, LFQH_l_.str.223
LFQH_Lloh2179:
nop
LFQH_Lloh2180:
adr x2, LFQH_l_.str.224
LFQH_Lloh2181:
nop
LFQH_Lloh2182:
adr x4, LFQH_BookshelfUpdateInsets
LFQH_Lloh2183:
nop
mov	x0, x20
mov	x3, x19
bl	LFQH_Hook
LFQH_Lloh2184:
adr x1, LFQH_l_.str.225
LFQH_Lloh2185:
nop
LFQH_Lloh2186:
adr x2, LFQH_l_.str.226
LFQH_Lloh2187:
nop
LFQH_Lloh2188:
adr x3, LFQH_l_.str.120
LFQH_Lloh2189:
nop
LFQH_Lloh2190:
adr x4, LFQH_BookshelfFloatingLayout
LFQH_Lloh2191:
nop
mov	x0, x20
bl	LFQH_Hook
LFQH_Lloh2192:
adr x1, LFQH_l_.str.132
LFQH_Lloh2193:
nop
LFQH_Lloh2194:
adr x2, LFQH_l_.str.227
LFQH_Lloh2195:
nop
LFQH_Lloh2196:
adr x4, LFQH_ShelfLayout
LFQH_Lloh2197:
nop
mov	x0, x20
mov	x3, x19
bl	LFQH_Hook
LFQH_Lloh2198:
adr x0, LFQH_l_.str.228
LFQH_Lloh2199:
nop
bl Lpatch + (0xa5b0 - PATCH_BASE)
LFQH_Lloh2200:
adr x1, LFQH_l_.str.229
LFQH_Lloh2201:
nop
LFQH_Lloh2202:
adr x2, LFQH_l_.str.11
LFQH_Lloh2203:
nop
bl	LFQH_ClassABI
cbz	w0, LFQH_LBB102_7
LFQH_Lloh2204:
adr x0, LFQH_l_.str.228
LFQH_Lloh2205:
nop
bl Lpatch + (0xa5b0 - PATCH_BASE)
LFQH_Lloh2206:
adr x1, LFQH_l_.str.230
LFQH_Lloh2207:
nop
LFQH_Lloh2208:
adr x2, LFQH_l_.str.97
LFQH_Lloh2209:
nop
bl	LFQH_ClassABI
cbz	w0, LFQH_LBB102_7
LFQH_Lloh2210:
adr x19, LFQH_l_.str.228
LFQH_Lloh2211:
nop
LFQH_Lloh2212:
adr x1, LFQH_l_.str.231
LFQH_Lloh2213:
nop
LFQH_Lloh2214:
adr x2, LFQH_l_.str.232
LFQH_Lloh2215:
nop
LFQH_Lloh2216:
adr x3, LFQH_l_.str.67
LFQH_Lloh2217:
nop
LFQH_Lloh2218:
adr x4, LFQH_ShelfRefreshHostHidden
LFQH_Lloh2219:
nop
mov	x0, x19
bl	LFQH_Hook
LFQH_Lloh2220:
adr x1, LFQH_l_.str.233
LFQH_Lloh2221:
nop
LFQH_Lloh2222:
adr x2, LFQH_l_.str.234
LFQH_Lloh2223:
nop
LFQH_Lloh2224:
adr x3, LFQH_l_.str.235
LFQH_Lloh2225:
nop
LFQH_Lloh2226:
adr x4, LFQH_ShelfRefreshState
LFQH_Lloh2227:
nop
mov	x0, x19
bl	LFQH_Hook
LFQH_Lloh2228:
adr x1, LFQH_l_.str.236
LFQH_Lloh2229:
nop
LFQH_Lloh2230:
adr x2, LFQH_l_.str.237
LFQH_Lloh2231:
nop
LFQH_Lloh2232:
adr x3, LFQH_l_.str.9
LFQH_Lloh2233:
nop
LFQH_Lloh2234:
adr x4, LFQH_ShelfRefreshAnimationLayout
LFQH_Lloh2235:
nop
mov	x0, x19
bl	LFQH_Hook
LFQH_Lloh2236:
adr x0, LFQH_l_.str.182
LFQH_Lloh2237:
nop
LFQH_Lloh2238:
adr x1, LFQH_l_.str.238
LFQH_Lloh2239:
nop
LFQH_Lloh2240:
adr x2, LFQH_l_.str.239
LFQH_Lloh2241:
nop
LFQH_Lloh2242:
adr x3, LFQH_l_.str.120
LFQH_Lloh2243:
nop
LFQH_Lloh2244:
adr x4, LFQH_ShelfScroll
LFQH_Lloh2245:
nop
bl	LFQH_Hook
LFQH_LBB102_7:
LFQH_Lloh2246:
adr x19, LFQH_l_.str.240
LFQH_Lloh2247:
nop
LFQH_Lloh2248:
adr x1, LFQH_l_.str.103
LFQH_Lloh2249:
nop
LFQH_Lloh2250:
adr x2, LFQH_l_.str.241
LFQH_Lloh2251:
nop
LFQH_Lloh2252:
adr x3, LFQH_l_.str.9
LFQH_Lloh2253:
nop
LFQH_Lloh2254:
adr x4, LFQH_ReaderLayout
LFQH_Lloh2255:
nop
mov	x0, x19
bl	LFQH_Hook
LFQH_Lloh2256:
adr x1, LFQH_l_.str.242
LFQH_Lloh2257:
nop
LFQH_Lloh2258:
adr x2, LFQH_l_.str.243
LFQH_Lloh2259:
nop
LFQH_Lloh2260:
adr x3, LFQH_l_.str.120
LFQH_Lloh2261:
nop
LFQH_Lloh2262:
adr x4, LFQH_ReaderTheme
LFQH_Lloh2263:
nop
mov	x0, x19
ldp	x29, x30, [sp, #32]
ldp	x20, x19, [sp, #16]
ldp	x22, x21, [sp], #48
b	LFQH_Hook
LFQH_LBB102_8:
ldp	x29, x30, [sp, #32]
ldp	x20, x19, [sp, #16]
ldp	x22, x21, [sp], #48
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
LFQH_Lloh2264:
adr x0, LFQH_l_.str.43
LFQH_Lloh2265:
nop
LFQH_Lloh2266:
adr x1, LFQH_l_.str.193
LFQH_Lloh2267:
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
LFQH_Lloh2268:
adr x0, LFQH_l_.str.58
LFQH_Lloh2269:
nop
LFQH_Lloh2270:
adr x1, LFQH_l_.str.194
LFQH_Lloh2271:
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
LFQH_Lloh2272:
adr x0, LFQH_l_.str.58
LFQH_Lloh2273:
nop
LFQH_Lloh2274:
adr x1, LFQH_l_.str.196
LFQH_Lloh2275:
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
LFQH_Lloh2276:
adr x0, LFQH_l_.str.7
LFQH_Lloh2277:
nop
LFQH_Lloh2278:
adr x1, LFQH_l_.str.197
LFQH_Lloh2279:
nop
bl	LFQH_Original
mov	x8, x0
mov	x0, x20
mov	x1, x19
blr	x8
LFQH_Lloh2280:
adr x1, LFQH_l_.str.10
LFQH_Lloh2281:
nop
mov	x0, x20
bl	LFQH_Get
bl	LFQH_FQHHeader
mov	x0, x20
ldp	x29, x30, [sp, #16]
ldp	x20, x19, [sp], #32
b	LFQH_BookstoreTopChrome
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
LFQH_Lloh2282:
adr x0, LFQH_l_.str.7
LFQH_Lloh2283:
nop
LFQH_Lloh2284:
adr x1, LFQH_l_.str.198
LFQH_Lloh2285:
nop
bl	LFQH_Original
mov	x8, x0
mov	x0, x21
mov	x1, x20
mov	x2, x19
blr	x8
LFQH_Lloh2286:
adr x1, LFQH_l_.str.10
LFQH_Lloh2287:
nop
mov	x0, x21
bl	LFQH_Get
bl	LFQH_FQHHeader
mov	x0, x21
ldp	x29, x30, [sp, #32]
ldp	x20, x19, [sp, #16]
ldp	x22, x21, [sp], #48
b	LFQH_BookstoreTopChrome
.cfi_endproc
.p2align	2
LFQH_BookstoreTabSelected:
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
LFQH_Lloh2288:
adr x0, LFQH_l_.str.7
LFQH_Lloh2289:
nop
LFQH_Lloh2290:
adr x1, LFQH_l_.str.200
LFQH_Lloh2291:
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
b	LFQH_BookstoreTopChrome
.cfi_endproc
.p2align	2
LFQH_BookstoreCollectionLayout:
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
LFQH_Lloh2292:
adr x0, LFQH_l_.str.201
LFQH_Lloh2293:
nop
LFQH_Lloh2294:
adr x1, LFQH_l_.str.203
LFQH_Lloh2295:
nop
bl	LFQH_Original
mov	x8, x0
mov	x0, x19
mov	x1, x20
blr	x8
LFQH_Lloh2296:
adr x1, LFQH_l_.str.369
LFQH_Lloh2297:
nop
mov	x0, x19
bl	LFQH_Get
mov	x20, x0
LFQH_Lloh2298:
adr x1, LFQH_l_.str.7
LFQH_Lloh2299:
nop
bl	LFQH_Kind
cbz	w0, LFQH_LBB109_2
LFQH_Lloh2300:
adr x1, LFQH_l_.str.468
LFQH_Lloh2301:
nop
mov	x0, x20
bl	LFQH_Get
mov	x1, x0
mov	x0, x20
bl	LFQH_BookstoreCurrentTab
cmp	x0, x19
b.eq	LFQH_LBB109_3
LFQH_LBB109_2:
ldp	x29, x30, [sp, #16]
ldp	x20, x19, [sp], #32
ret
LFQH_LBB109_3:
mov	x0, x20
ldp	x29, x30, [sp, #16]
ldp	x20, x19, [sp], #32
b	LFQH_BookstoreTopChrome
.cfi_endproc
.p2align	2
LFQH_BookstoreDoubleRowLayout:
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
LFQH_Lloh2302:
adr x0, LFQH_l_.str.204
LFQH_Lloh2303:
nop
LFQH_Lloh2304:
adr x1, LFQH_l_.str.206
LFQH_Lloh2305:
nop
bl	LFQH_Original
mov	x8, x0
mov	x0, x19
mov	x1, x20
blr	x8
LFQH_Lloh2306:
adr x1, LFQH_l_.str.369
LFQH_Lloh2307:
nop
mov	x0, x19
bl	LFQH_Get
mov	x20, x0
LFQH_Lloh2308:
adr x1, LFQH_l_.str.468
LFQH_Lloh2309:
nop
bl	LFQH_Get
mov	x21, x0
LFQH_Lloh2310:
adr x1, LFQH_l_.str.7
LFQH_Lloh2311:
nop
mov	x0, x20
bl	LFQH_Kind
cbz	w0, LFQH_LBB110_2
mov	x0, x20
mov	x1, x21
bl	LFQH_BookstoreCurrentTab
cmp	x0, x19
b.eq	LFQH_LBB110_3
LFQH_LBB110_2:
ldp	x29, x30, [sp, #32]
ldp	x20, x19, [sp, #16]
ldp	x22, x21, [sp], #48
ret
LFQH_LBB110_3:
mov	x0, x20
ldp	x29, x30, [sp, #32]
ldp	x20, x19, [sp, #16]
ldp	x22, x21, [sp], #48
b	LFQH_BookstoreTopChrome
.cfi_endproc
.p2align	2
LFQH_BookstoreDoubleRowScroll:
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
mov	x20, x2
mov	x21, x1
mov	x19, x0
LFQH_Lloh2312:
adr x0, LFQH_l_.str.204
LFQH_Lloh2313:
nop
LFQH_Lloh2314:
adr x1, LFQH_l_.str.208
LFQH_Lloh2315:
nop
bl	LFQH_Original
mov	x8, x0
mov	x0, x19
mov	x1, x21
mov	x2, x20
blr	x8
LFQH_Lloh2316:
adr x1, LFQH_l_.str.369
LFQH_Lloh2317:
nop
mov	x0, x19
bl	LFQH_Get
mov	x20, x0
LFQH_Lloh2318:
adr x1, LFQH_l_.str.7
LFQH_Lloh2319:
nop
bl	LFQH_Kind
cbz	w0, LFQH_LBB111_4
LFQH_Lloh2320:
adr x1, LFQH_BookstoreViewportKey
LFQH_Lloh2321:
nop
mov	x0, x20
bl Lpatch + (0xa628 - PATCH_BASE)
mov	x22, x0
LFQH_Lloh2322:
adr x1, LFQH_TopChromeFrameKey
LFQH_Lloh2323:
nop
bl Lpatch + (0xa628 - PATCH_BASE)
cbz	x0, LFQH_LBB111_3
mov	x21, x0
LFQH_Lloh2324:
adr x0, LFQH_l_.str.249
LFQH_Lloh2325:
nop
bl Lpatch + (0xa5a4 - PATCH_BASE)
mov	x1, x0
mov	x0, x22
bl Lpatch + (0xa5d4 - PATCH_BASE)
mov.16b	v8, v0
mov.16b	v9, v1
mov.16b	v10, v2
mov.16b	v11, v3
LFQH_Lloh2326:
adr x0, LFQH_l_.str.286
LFQH_Lloh2327:
nop
bl Lpatch + (0xa5a4 - PATCH_BASE)
mov	x1, x0
mov	x0, x21
bl Lpatch + (0xa5d4 - PATCH_BASE)
fcmp	d8, d0
fccmp	d9, d1, #0, eq
fccmp	d10, d2, #0, eq
fccmp	d11, d3, #0, eq
b.eq	LFQH_LBB111_4
LFQH_LBB111_3:
LFQH_Lloh2328:
adr x1, LFQH_l_.str.468
LFQH_Lloh2329:
nop
mov	x0, x20
bl	LFQH_Get
mov	x1, x0
mov	x0, x20
bl	LFQH_BookstoreCurrentTab
cmp	x0, x19
b.eq	LFQH_LBB111_5
LFQH_LBB111_4:
ldp	x29, x30, [sp, #64]
ldp	x20, x19, [sp, #48]
ldp	x22, x21, [sp, #32]
ldp	d9, d8, [sp, #16]
ldp	d11, d10, [sp], #80
ret
LFQH_LBB111_5:
mov	x0, x20
ldp	x29, x30, [sp, #64]
ldp	x20, x19, [sp, #48]
ldp	x22, x21, [sp, #32]
ldp	d9, d8, [sp, #16]
ldp	d11, d10, [sp], #80
b	LFQH_BookstoreTopChrome
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
LFQH_Lloh2330:
adr x0, LFQH_l_.str.209
LFQH_Lloh2331:
nop
LFQH_Lloh2332:
adr x1, LFQH_l_.str.212
LFQH_Lloh2333:
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
LFQH_Lloh2334:
adr x1, LFQH_l_.str.210
LFQH_Lloh2335:
nop
mov	x0, x24
bl	LFQH_Get
LFQH_Lloh2336:
adr x1, LFQH_l_.str.10
LFQH_Lloh2337:
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
LFQH_Lloh2338:
adr x0, LFQH_l_.str.25
LFQH_Lloh2339:
nop
LFQH_Lloh2340:
adr x1, LFQH_l_.str.214
LFQH_Lloh2341:
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
LFQH_Lloh2342:
adr x0, LFQH_l_.str.25
LFQH_Lloh2343:
nop
LFQH_Lloh2344:
adr x1, LFQH_l_.str.216
LFQH_Lloh2345:
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
LFQH_Lloh2346:
adr x0, LFQH_l_.str.217
LFQH_Lloh2347:
nop
LFQH_Lloh2348:
adr x1, LFQH_l_.str.218
LFQH_Lloh2349:
nop
bl	LFQH_Original
mov	x8, x0
mov	x0, x19
mov	x1, x20
blr	x8
LFQH_Lloh2350:
adr x1, LFQH_ShelfRoleKey
LFQH_Lloh2351:
nop
mov	x0, x19
bl Lpatch + (0xa628 - PATCH_BASE)
cbz	x0, LFQH_LBB115_2
mov	x20, x0
LFQH_Lloh2352:
adr x0, LFQH_l_.str.40
LFQH_Lloh2353:
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
LFQH_LBB115_2:
ldp	x29, x30, [sp, #16]
ldp	x20, x19, [sp], #32
ret
.cfi_endproc
.p2align	2
LFQH_BookshelfTopLayout:
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
LFQH_Lloh2354:
adr x0, LFQH_l_.str.219
LFQH_Lloh2355:
nop
LFQH_Lloh2356:
adr x1, LFQH_l_.str.221
LFQH_Lloh2357:
nop
bl	LFQH_Original
mov	x8, x0
mov	x0, x20
mov	x1, x19
blr	x8
mov	x0, x20
ldp	x29, x30, [sp, #16]
ldp	x20, x19, [sp], #32
b	LFQH_BookshelfTopChrome
.cfi_endproc
.p2align	2
LFQH_BookshelfTabSelected:
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
LFQH_Lloh2358:
adr x0, LFQH_l_.str.219
LFQH_Lloh2359:
nop
LFQH_Lloh2360:
adr x1, LFQH_l_.str.222
LFQH_Lloh2361:
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
b	LFQH_BookshelfTopChrome
.cfi_endproc
.p2align	2
LFQH_BookshelfUpdateInsets:
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
LFQH_Lloh2362:
adr x0, LFQH_l_.str.182
LFQH_Lloh2363:
nop
LFQH_Lloh2364:
adr x1, LFQH_l_.str.224
LFQH_Lloh2365:
nop
bl	LFQH_Original
mov	x8, x0
mov	x0, x20
mov	x1, x19
blr	x8
mov	x0, x20
ldp	x29, x30, [sp, #16]
ldp	x20, x19, [sp], #32
b	LFQH_RestoreBookshelfTopInset
.cfi_endproc
.p2align	2
LFQH_BookshelfFloatingLayout:
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
LFQH_Lloh2366:
adr x0, LFQH_l_.str.182
LFQH_Lloh2367:
nop
LFQH_Lloh2368:
adr x1, LFQH_l_.str.226
LFQH_Lloh2369:
nop
bl	LFQH_Original
mov	x8, x0
mov	x0, x19
mov	x1, x21
mov	x2, x20
blr	x8
LFQH_Lloh2370:
adr x1, LFQH_l_.str.364
LFQH_Lloh2371:
nop
mov	x0, x19
bl	LFQH_Get
cmp	x20, x0
b.eq	LFQH_LBB119_2
ldp	x29, x30, [sp, #32]
ldp	x20, x19, [sp, #16]
ldp	x22, x21, [sp], #48
ret
LFQH_LBB119_2:
mov	x0, x20
bl	LFQH_TopChromeOverlap
mov	x0, x19
ldp	x29, x30, [sp, #32]
ldp	x20, x19, [sp, #16]
ldp	x22, x21, [sp], #48
b	LFQH_BookshelfFloatingChrome
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
LFQH_Lloh2372:
adr x0, LFQH_l_.str.182
LFQH_Lloh2373:
nop
LFQH_Lloh2374:
adr x1, LFQH_l_.str.227
LFQH_Lloh2375:
nop
bl	LFQH_Original
mov	x8, x0
mov	x0, x20
mov	x1, x19
blr	x8
mov	x0, x20
bl	LFQH_FQHShelf
mov	x0, x20
bl	LFQH_RestoreBookshelfTopInset
LFQH_Lloh2376:
adr x1, LFQH_l_.str.364
LFQH_Lloh2377:
nop
mov	x0, x20
bl	LFQH_Get
ldp	x29, x30, [sp, #16]
ldp	x20, x19, [sp], #32
b	LFQH_ShelfRefreshVisibility
.cfi_endproc
.p2align	2
LFQH_ShelfRefreshHostHidden:
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
mov	x19, x1
mov	x20, x0
LFQH_Lloh2378:
adr x1, LFQH_l_.str.229
LFQH_Lloh2379:
nop
bl	LFQH_Get
mov	x22, x0
LFQH_Lloh2380:
adr x1, LFQH_ShelfRefreshHiddenKey
LFQH_Lloh2381:
nop
bl Lpatch + (0xa628 - PATCH_BASE)
cbz	x0, LFQH_LBB121_2
LFQH_Lloh2382:
adr x0, LFQH_l_.str.267
LFQH_Lloh2383:
nop
bl Lpatch + (0xa5b0 - PATCH_BASE)
mov	x23, x0
LFQH_Lloh2384:
adr x0, LFQH_l_.str.334
LFQH_Lloh2385:
nop
bl Lpatch + (0xa5a4 - PATCH_BASE)
mov	x1, x0
mov	x0, x23
mov	x2, x21
bl Lpatch + (0xa5d4 - PATCH_BASE)
mov	x2, x0
LFQH_Lloh2386:
adr x1, LFQH_ShelfRefreshHiddenKey
LFQH_Lloh2387:
nop
mov	w21, #1
mov	x0, x22
mov	w3, #1
bl Lpatch + (0xa634 - PATCH_BASE)
LFQH_LBB121_2:
LFQH_Lloh2388:
adr x0, LFQH_l_.str.228
LFQH_Lloh2389:
nop
LFQH_Lloh2390:
adr x1, LFQH_l_.str.232
LFQH_Lloh2391:
nop
bl	LFQH_Original
mov	x3, x0
mov	x0, x20
mov	x1, x19
mov	x2, x21
ldp	x29, x30, [sp, #48]
ldp	x20, x19, [sp, #32]
ldp	x22, x21, [sp, #16]
ldp	x24, x23, [sp], #64
br	x3
.cfi_endproc
.p2align	2
LFQH_ShelfRefreshState:
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
LFQH_Lloh2392:
adr x0, LFQH_l_.str.228
LFQH_Lloh2393:
nop
LFQH_Lloh2394:
adr x1, LFQH_l_.str.234
LFQH_Lloh2395:
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
b	LFQH_ShelfRefreshHeaderVisibility
.cfi_endproc
.p2align	2
LFQH_ShelfRefreshAnimationLayout:
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
LFQH_Lloh2396:
adr x0, LFQH_l_.str.228
LFQH_Lloh2397:
nop
LFQH_Lloh2398:
adr x1, LFQH_l_.str.237
LFQH_Lloh2399:
nop
bl	LFQH_Original
mov	x8, x0
mov	x0, x20
mov	x1, x19
blr	x8
mov	x0, x20
ldp	x29, x30, [sp, #16]
ldp	x20, x19, [sp], #32
b	LFQH_ShelfRefreshHeaderVisibility
.cfi_endproc
.p2align	2
LFQH_ShelfScroll:
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
LFQH_Lloh2400:
adr x0, LFQH_l_.str.182
LFQH_Lloh2401:
nop
LFQH_Lloh2402:
adr x1, LFQH_l_.str.239
LFQH_Lloh2403:
nop
bl	LFQH_Original
mov	x8, x0
mov	x0, x21
mov	x1, x20
mov	x2, x19
blr	x8
LFQH_Lloh2404:
adr x1, LFQH_l_.str.364
LFQH_Lloh2405:
nop
mov	x0, x21
bl	LFQH_Get
cmp	x0, x19
b.eq	LFQH_LBB124_2
ldp	x29, x30, [sp, #32]
ldp	x20, x19, [sp, #16]
ldp	x22, x21, [sp], #48
ret
LFQH_LBB124_2:
mov	x0, x19
ldp	x29, x30, [sp, #32]
ldp	x20, x19, [sp, #16]
ldp	x22, x21, [sp], #48
b	LFQH_ShelfRefreshVisibility
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
LFQH_Lloh2406:
adr x0, LFQH_l_.str.240
LFQH_Lloh2407:
nop
LFQH_Lloh2408:
adr x1, LFQH_l_.str.241
LFQH_Lloh2409:
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
LFQH_Lloh2410:
adr x0, LFQH_l_.str.240
LFQH_Lloh2411:
nop
LFQH_Lloh2412:
adr x1, LFQH_l_.str.243
LFQH_Lloh2413:
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
LFQH_ClassABI:
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
mov	x20, x0
mov	x0, x1
bl Lpatch + (0xa5a4 - PATCH_BASE)
mov	x1, x0
mov	x0, x20
bl Lpatch + (0xa5f8 - PATCH_BASE)
cbz	x0, LFQH_LBB127_8
bl Lpatch + (0xa5ec - PATCH_BASE)
cbz	x0, LFQH_LBB127_8
ldrb	w9, [x19]
cbz	w9, LFQH_LBB127_6
add	x8, x19, #1
LFQH_LBB127_4:
ldrb	w10, [x0], #1
cmp	w10, w9
b.ne	LFQH_LBB127_7
ldrb	w9, [x8], #1
cbnz	w9, LFQH_LBB127_4
LFQH_LBB127_6:
ldrb	w8, [x0]
cmp	w8, #0
cset	w0, eq
b	LFQH_LBB127_8
LFQH_LBB127_7:
mov	w0, #0
LFQH_LBB127_8:
ldp	x29, x30, [sp, #16]
ldp	x20, x19, [sp], #32
ret
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
LFQH_Lloh2414:
adr x0, LFQH_l_.str.12
LFQH_Lloh2415:
nop
bl Lpatch + (0xa5b0 - PATCH_BASE)
mov	x19, x0
LFQH_Lloh2416:
adr x0, LFQH_l_.str.13
LFQH_Lloh2417:
nop
bl Lpatch + (0xa5a4 - PATCH_BASE)
mov	x1, x0
mov	x0, x19
mov	x2, #0
bl Lpatch + (0xa5d4 - PATCH_BASE)
mov	x19, x0
cbz	x0, LFQH_LBB129_3
LFQH_Lloh2418:
adr x0, LFQH_l_.str.18
LFQH_Lloh2419:
nop
bl Lpatch + (0xa5a4 - PATCH_BASE)
mov	x1, x0
mov	x0, x19
mov	w2, #1
bl Lpatch + (0xa5d4 - PATCH_BASE)
LFQH_Lloh2420:
adr x0, LFQH_l_.str.16
LFQH_Lloh2421:
nop
bl Lpatch + (0xa5b0 - PATCH_BASE)
mov	x20, x0
LFQH_Lloh2422:
adr x0, LFQH_l_.str.76
LFQH_Lloh2423:
nop
bl Lpatch + (0xa5a4 - PATCH_BASE)
mov	x1, x0
mov	x0, x20
bl Lpatch + (0xa5d4 - PATCH_BASE)
mov	x20, x0
LFQH_Lloh2424:
adr x0, LFQH_l_.str.258
LFQH_Lloh2425:
nop
bl Lpatch + (0xa5a4 - PATCH_BASE)
mov	x1, x0
mov	x0, x20
mov	x2, x19
bl Lpatch + (0xa5d4 - PATCH_BASE)
mov	x19, x0
cbz	x0, LFQH_LBB129_3
LFQH_Lloh2426:
adr x0, LFQH_l_.str.17
LFQH_Lloh2427:
nop
bl Lpatch + (0xa5a4 - PATCH_BASE)
mov	x20, x0
LFQH_Lloh2428:
adr x0, LFQH_l_.str.14
LFQH_Lloh2429:
nop
bl Lpatch + (0xa5b0 - PATCH_BASE)
mov	x21, x0
LFQH_Lloh2430:
adr x0, LFQH_l_.str.15
LFQH_Lloh2431:
nop
bl Lpatch + (0xa5a4 - PATCH_BASE)
mov	x1, x0
mov	x0, x21
bl Lpatch + (0xa5d4 - PATCH_BASE)
mov	x2, x0
mov	x0, x19
mov	x1, x20
bl Lpatch + (0xa5d4 - PATCH_BASE)
LFQH_Lloh2432:
adr x0, LFQH_l_.str.259
LFQH_Lloh2433:
nop
bl Lpatch + (0xa5a4 - PATCH_BASE)
mov	x1, x0
mov	x0, x19
mov	w2, #0
bl Lpatch + (0xa5d4 - PATCH_BASE)
LFQH_Lloh2434:
adr x0, LFQH_l_.str.260
LFQH_Lloh2435:
nop
bl Lpatch + (0xa5a4 - PATCH_BASE)
mov	x1, x0
mov	x0, x19
mov	w2, #1
bl Lpatch + (0xa5d4 - PATCH_BASE)
LFQH_Lloh2436:
adr x0, LFQH_l_.str.261
LFQH_Lloh2437:
nop
bl Lpatch + (0xa5a4 - PATCH_BASE)
mov	x1, x0
mov	x0, x19
mov	w2, #0
bl Lpatch + (0xa5d4 - PATCH_BASE)
LFQH_Lloh2438:
adr x0, LFQH_l_.str.262
LFQH_Lloh2439:
nop
bl Lpatch + (0xa5a4 - PATCH_BASE)
mov	x1, x0
mov	x0, x19
mov	w2, #0
bl Lpatch + (0xa5d4 - PATCH_BASE)
LFQH_LBB129_3:
mov	x0, x19
ldp	x29, x30, [sp, #32]
ldp	x20, x19, [sp, #16]
ldp	x22, x21, [sp], #48
ret
.cfi_endproc
.p2align	2
LFQH_Radius:
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
LFQH_Lloh2440:
adr x0, LFQH_l_.str.263
LFQH_Lloh2441:
nop
bl Lpatch + (0xa5a4 - PATCH_BASE)
mov	x1, x0
mov	x0, x19
bl Lpatch + (0xa5d4 - PATCH_BASE)
mov	x19, x0
LFQH_Lloh2442:
adr x0, LFQH_l_.str.264
LFQH_Lloh2443:
nop
bl Lpatch + (0xa5a4 - PATCH_BASE)
mov	x1, x0
mov	x0, x19
ldp	x29, x30, [sp, #16]
ldp	x20, x19, [sp], #32
b Lpatch + (0xa5d4 - PATCH_BASE)
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
mov.16b	v8, v1
mov.16b	v10, v0
mov	x20, x2
mov	x21, x1
mov	x19, x0
LFQH_Lloh2444:
adr x1, LFQH_HeaderAppliedRadiusKey
LFQH_Lloh2445:
nop
bl Lpatch + (0xa628 - PATCH_BASE)
mov	x22, x0
cbz	x0, LFQH_LBB132_2
LFQH_Lloh2446:
adr x0, LFQH_l_.str.266
LFQH_Lloh2447:
nop
bl Lpatch + (0xa5a4 - PATCH_BASE)
mov	x1, x0
mov	x0, x22
bl Lpatch + (0xa5d4 - PATCH_BASE)
mov.16b	v9, v0
b	LFQH_LBB132_3
LFQH_LBB132_2:
fmov	d9, xzr
LFQH_LBB132_3:
LFQH_Lloh2448:
adr x1, LFQH_HeaderClipsKey
LFQH_Lloh2449:
nop
mov	x0, x19
bl Lpatch + (0xa628 - PATCH_BASE)
cbz	w21, LFQH_LBB132_5
cbnz	x0, LFQH_LBB132_6
LFQH_LBB132_5:
LFQH_Lloh2450:
adr x0, LFQH_l_.str.267
LFQH_Lloh2451:
nop
bl Lpatch + (0xa5b0 - PATCH_BASE)
mov	x23, x0
LFQH_Lloh2452:
adr x0, LFQH_l_.str.334
LFQH_Lloh2453:
nop
bl Lpatch + (0xa5a4 - PATCH_BASE)
mov	x1, x0
mov	x0, x23
mov	x2, x21
bl Lpatch + (0xa5d4 - PATCH_BASE)
mov	x2, x0
LFQH_Lloh2454:
adr x1, LFQH_HeaderClipsKey
LFQH_Lloh2455:
nop
mov	x0, x19
mov	w3, #1
bl Lpatch + (0xa634 - PATCH_BASE)
LFQH_LBB132_6:
LFQH_Lloh2456:
adr x1, LFQH_HeaderOpaqueKey
LFQH_Lloh2457:
nop
mov	x0, x19
bl Lpatch + (0xa628 - PATCH_BASE)
cbnz	w20, LFQH_LBB132_8
cbnz	x0, LFQH_LBB132_9
LFQH_LBB132_8:
LFQH_Lloh2458:
adr x0, LFQH_l_.str.267
LFQH_Lloh2459:
nop
bl Lpatch + (0xa5b0 - PATCH_BASE)
mov	x23, x0
LFQH_Lloh2460:
adr x0, LFQH_l_.str.334
LFQH_Lloh2461:
nop
bl Lpatch + (0xa5a4 - PATCH_BASE)
mov	x1, x0
mov	x0, x23
mov	x2, x20
bl Lpatch + (0xa5d4 - PATCH_BASE)
mov	x2, x0
LFQH_Lloh2462:
adr x1, LFQH_HeaderOpaqueKey
LFQH_Lloh2463:
nop
mov	x0, x19
mov	w3, #1
bl Lpatch + (0xa634 - PATCH_BASE)
LFQH_LBB132_9:
cbz	x22, LFQH_LBB132_11
fcmp	d10, d9
b.eq	LFQH_LBB132_12
LFQH_LBB132_11:
LFQH_Lloh2464:
adr x0, LFQH_l_.str.267
LFQH_Lloh2465:
nop
bl Lpatch + (0xa5b0 - PATCH_BASE)
mov	x23, x0
LFQH_Lloh2466:
adr x0, LFQH_l_.str.268
LFQH_Lloh2467:
nop
bl Lpatch + (0xa5a4 - PATCH_BASE)
mov	x1, x0
mov	x0, x23
mov.16b	v0, v10
bl Lpatch + (0xa5d4 - PATCH_BASE)
mov	x2, x0
LFQH_Lloh2468:
adr x1, LFQH_HeaderRadiusKey
LFQH_Lloh2469:
nop
mov	x0, x19
mov	w3, #1
bl Lpatch + (0xa634 - PATCH_BASE)
LFQH_LBB132_12:
fcmp	d10, d8
b.eq	LFQH_LBB132_14
LFQH_Lloh2470:
adr x0, LFQH_l_.str.263
LFQH_Lloh2471:
nop
bl Lpatch + (0xa5a4 - PATCH_BASE)
mov	x1, x0
mov	x0, x19
bl Lpatch + (0xa5d4 - PATCH_BASE)
mov	x23, x0
LFQH_Lloh2472:
adr x0, LFQH_l_.str.269
LFQH_Lloh2473:
nop
bl Lpatch + (0xa5a4 - PATCH_BASE)
mov	x1, x0
mov	x0, x23
mov.16b	v0, v8
bl Lpatch + (0xa5d4 - PATCH_BASE)
LFQH_LBB132_14:
cbz	x22, LFQH_LBB132_19
fcmp	d9, d8
b.ne	LFQH_LBB132_19
cbz	w21, LFQH_LBB132_20
LFQH_LBB132_17:
cbz	w20, LFQH_LBB132_21
LFQH_LBB132_18:
LFQH_Lloh2474:
adr x0, LFQH_l_.str.262
LFQH_Lloh2475:
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
LFQH_LBB132_19:
LFQH_Lloh2476:
adr x0, LFQH_l_.str.267
LFQH_Lloh2477:
nop
bl Lpatch + (0xa5b0 - PATCH_BASE)
mov	x22, x0
LFQH_Lloh2478:
adr x0, LFQH_l_.str.268
LFQH_Lloh2479:
nop
bl Lpatch + (0xa5a4 - PATCH_BASE)
mov	x1, x0
mov	x0, x22
mov.16b	v0, v8
bl Lpatch + (0xa5d4 - PATCH_BASE)
mov	x2, x0
LFQH_Lloh2480:
adr x1, LFQH_HeaderAppliedRadiusKey
LFQH_Lloh2481:
nop
mov	x0, x19
mov	w3, #1
bl Lpatch + (0xa634 - PATCH_BASE)
cbnz	w21, LFQH_LBB132_17
LFQH_LBB132_20:
LFQH_Lloh2482:
adr x0, LFQH_l_.str.265
LFQH_Lloh2483:
nop
bl Lpatch + (0xa5a4 - PATCH_BASE)
mov	x1, x0
mov	x0, x19
mov	w2, #1
bl Lpatch + (0xa5d4 - PATCH_BASE)
cbnz	w20, LFQH_LBB132_18
LFQH_LBB132_21:
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
LFQH_Lloh2484:
adr x1, LFQH_ClipsKey
LFQH_Lloh2485:
nop
bl Lpatch + (0xa628 - PATCH_BASE)
cbnz	w21, LFQH_LBB133_2
cbnz	x0, LFQH_LBB133_3
LFQH_LBB133_2:
LFQH_Lloh2486:
adr x0, LFQH_l_.str.267
LFQH_Lloh2487:
nop
bl Lpatch + (0xa5b0 - PATCH_BASE)
mov	x22, x0
LFQH_Lloh2488:
adr x0, LFQH_l_.str.334
LFQH_Lloh2489:
nop
bl Lpatch + (0xa5a4 - PATCH_BASE)
mov	x1, x0
mov	x0, x22
mov	x2, x21
bl Lpatch + (0xa5d4 - PATCH_BASE)
mov	x2, x0
LFQH_Lloh2490:
adr x1, LFQH_ClipsKey
LFQH_Lloh2491:
nop
mov	x0, x19
mov	w3, #1
bl Lpatch + (0xa634 - PATCH_BASE)
LFQH_LBB133_3:
LFQH_Lloh2492:
adr x1, LFQH_OpaqueKey
LFQH_Lloh2493:
nop
mov	x0, x19
bl Lpatch + (0xa628 - PATCH_BASE)
cbnz	w20, LFQH_LBB133_5
cbnz	x0, LFQH_LBB133_6
LFQH_LBB133_5:
LFQH_Lloh2494:
adr x0, LFQH_l_.str.267
LFQH_Lloh2495:
nop
bl Lpatch + (0xa5b0 - PATCH_BASE)
mov	x22, x0
LFQH_Lloh2496:
adr x0, LFQH_l_.str.334
LFQH_Lloh2497:
nop
bl Lpatch + (0xa5a4 - PATCH_BASE)
mov	x1, x0
mov	x0, x22
mov	x2, x20
bl Lpatch + (0xa5d4 - PATCH_BASE)
mov	x2, x0
LFQH_Lloh2498:
adr x1, LFQH_OpaqueKey
LFQH_Lloh2499:
nop
mov	x0, x19
mov	w3, #1
bl Lpatch + (0xa634 - PATCH_BASE)
LFQH_LBB133_6:
cbz	w21, LFQH_LBB133_8
LFQH_Lloh2500:
adr x0, LFQH_l_.str.265
LFQH_Lloh2501:
nop
bl Lpatch + (0xa5a4 - PATCH_BASE)
mov	x1, x0
mov	x0, x19
mov	w2, #0
bl Lpatch + (0xa5d4 - PATCH_BASE)
LFQH_LBB133_8:
cbz	w20, LFQH_LBB133_10
LFQH_Lloh2502:
adr x0, LFQH_l_.str.262
LFQH_Lloh2503:
nop
bl Lpatch + (0xa5a4 - PATCH_BASE)
mov	x1, x0
mov	x0, x19
mov	w2, #0
ldp	x29, x30, [sp, #32]
ldp	x20, x19, [sp, #16]
ldp	x22, x21, [sp], #48
b Lpatch + (0xa5d4 - PATCH_BASE)
LFQH_LBB133_10:
ldp	x29, x30, [sp, #32]
ldp	x20, x19, [sp, #16]
ldp	x22, x21, [sp], #48
ret
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
LFQH_Lloh2504:
adr x0, LFQH_l_.str.267
LFQH_Lloh2505:
nop
bl Lpatch + (0xa5b0 - PATCH_BASE)
mov	x19, x0
LFQH_Lloh2506:
adr x0, LFQH_l_.str.268
LFQH_Lloh2507:
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
LFQH_Lloh2508:
adr x0, LFQH_l_.str.287
LFQH_Lloh2509:
nop
bl Lpatch + (0xa5b0 - PATCH_BASE)
mov	x19, x0
LFQH_Lloh2510:
adr x0, LFQH_l_.str.288
LFQH_Lloh2511:
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
LFQH_Lloh2512:
adr x0, LFQH_l_.str.289
LFQH_Lloh2513:
nop
bl Lpatch + (0xa5a4 - PATCH_BASE)
mov	x22, x0
LFQH_Lloh2514:
adr x0, LFQH_l_.str.244
LFQH_Lloh2515:
nop
bl Lpatch + (0xa5b0 - PATCH_BASE)
mov	x23, x0
LFQH_Lloh2516:
adr x0, LFQH_l_.str.245
LFQH_Lloh2517:
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
LFQH_Lloh2518:
adr x0, LFQH_l_.str.70
LFQH_Lloh2519:
nop
bl Lpatch + (0xa5b0 - PATCH_BASE)
mov	x19, x0
LFQH_Lloh2520:
adr x0, LFQH_l_.str.280
LFQH_Lloh2521:
nop
bl Lpatch + (0xa5a4 - PATCH_BASE)
mov	x1, x0
mov	x0, x19
bl Lpatch + (0xa5d4 - PATCH_BASE)
mov	x19, x0
LFQH_Lloh2522:
adr x20, LFQH_l_.str.283
LFQH_Lloh2523:
nop
mov	x0, x20
bl Lpatch + (0xa5a4 - PATCH_BASE)
mov	x23, x0
LFQH_Lloh2524:
adr x21, LFQH_l_.str.267
LFQH_Lloh2525:
nop
mov	x0, x21
bl Lpatch + (0xa5b0 - PATCH_BASE)
mov	x24, x0
LFQH_Lloh2526:
adr x22, LFQH_l_.str.268
LFQH_Lloh2527:
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
mov	x20, x1
mov	x19, x0
LFQH_Lloh2528:
adr x1, LFQH_ReaderShelfStyledFrameKey
LFQH_Lloh2529:
nop
bl Lpatch + (0xa628 - PATCH_BASE)
cbz	x0, LFQH_LBB147_4
mov	x21, x0
LFQH_Lloh2530:
adr x0, LFQH_l_.str.249
LFQH_Lloh2531:
nop
bl Lpatch + (0xa5a4 - PATCH_BASE)
mov	x1, x0
mov	x0, x19
bl Lpatch + (0xa5d4 - PATCH_BASE)
mov.16b	v8, v0
mov.16b	v9, v1
mov.16b	v10, v2
mov.16b	v11, v3
LFQH_Lloh2532:
adr x0, LFQH_l_.str.286
LFQH_Lloh2533:
nop
bl Lpatch + (0xa5a4 - PATCH_BASE)
mov	x1, x0
mov	x0, x21
bl Lpatch + (0xa5d4 - PATCH_BASE)
fcmp	d8, d0
fccmp	d9, d1, #0, eq
fccmp	d10, d2, #0, eq
fccmp	d11, d3, #0, eq
b.ne	LFQH_LBB147_3
LFQH_Lloh2534:
adr x1, LFQH_ReaderShelfStockFrameKey
LFQH_Lloh2535:
nop
mov	x0, x19
bl Lpatch + (0xa628 - PATCH_BASE)
mov	x21, x0
LFQH_Lloh2536:
adr x0, LFQH_l_.str.286
LFQH_Lloh2537:
nop
bl Lpatch + (0xa5a4 - PATCH_BASE)
mov	x1, x0
mov	x0, x21
bl Lpatch + (0xa5d4 - PATCH_BASE)
mov.16b	v8, v0
mov.16b	v9, v1
mov.16b	v10, v2
mov.16b	v11, v3
LFQH_Lloh2538:
adr x0, LFQH_l_.str.78
LFQH_Lloh2539:
nop
bl Lpatch + (0xa5a4 - PATCH_BASE)
mov	x1, x0
mov	x0, x19
mov.16b	v0, v8
mov.16b	v1, v9
mov.16b	v2, v10
mov.16b	v3, v11
bl Lpatch + (0xa5d4 - PATCH_BASE)
LFQH_LBB147_3:
LFQH_Lloh2540:
adr x1, LFQH_ReaderShelfStockFrameKey
LFQH_Lloh2541:
nop
mov	x0, x19
mov	x2, #0
mov	w3, #1
bl Lpatch + (0xa634 - PATCH_BASE)
LFQH_Lloh2542:
adr x1, LFQH_ReaderShelfStyledFrameKey
LFQH_Lloh2543:
nop
mov	x0, x19
mov	x2, #0
mov	w3, #1
bl Lpatch + (0xa634 - PATCH_BASE)
LFQH_LBB147_4:
mov	x0, x19
bl	LFQH_RestoreGlyph
cbz	x20, LFQH_LBB147_6
mov	x0, x19
mov	x1, x20
mov	w2, #0
bl	LFQH_ObservePress
LFQH_Lloh2544:
adr x0, LFQH_l_.str.302
LFQH_Lloh2545:
nop
bl Lpatch + (0xa5a4 - PATCH_BASE)
mov	x1, x0
mov	x0, x20
bl Lpatch + (0xa5d4 - PATCH_BASE)
LFQH_LBB147_6:
LFQH_Lloh2546:
adr x1, LFQH_IconGlassKey
LFQH_Lloh2547:
nop
mov	x0, x19
mov	x2, #0
mov	w3, #1
bl Lpatch + (0xa634 - PATCH_BASE)
LFQH_Lloh2548:
adr x1, LFQH_IconRectKey
LFQH_Lloh2549:
nop
mov	x0, x19
mov	x2, #0
mov	w3, #1
bl Lpatch + (0xa634 - PATCH_BASE)
LFQH_Lloh2550:
adr x1, LFQH_LayoutKey
LFQH_Lloh2551:
nop
mov	x0, x19
mov	x2, #0
mov	w3, #1
bl Lpatch + (0xa634 - PATCH_BASE)
LFQH_Lloh2552:
adr x1, LFQH_LayoutTimeKey
LFQH_Lloh2553:
nop
mov	x0, x19
mov	x2, #0
mov	w3, #1
bl Lpatch + (0xa634 - PATCH_BASE)
mov	x0, x19
bl	LFQH_RestoreHit
mov	x0, x19
ldp	x29, x30, [sp, #64]
ldp	x20, x19, [sp, #48]
ldp	x22, x21, [sp, #32]
ldp	d9, d8, [sp, #16]
ldp	d11, d10, [sp], #80
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
LFQH_Lloh2554:
adr x1, LFQH_GlyphViewKey
LFQH_Lloh2555:
nop
bl Lpatch + (0xa628 - PATCH_BASE)
mov	x20, x0
LFQH_Lloh2556:
adr x1, LFQH_GlyphOriginalKey
LFQH_Lloh2557:
nop
bl Lpatch + (0xa628 - PATCH_BASE)
cbz	x0, LFQH_LBB149_2
mov	x21, x0
LFQH_Lloh2558:
adr x0, LFQH_l_.str.286
LFQH_Lloh2559:
nop
bl Lpatch + (0xa5a4 - PATCH_BASE)
mov	x1, x0
mov	x0, x21
bl Lpatch + (0xa5d4 - PATCH_BASE)
mov.16b	v8, v0
mov.16b	v9, v1
mov.16b	v10, v2
mov.16b	v11, v3
LFQH_Lloh2560:
adr x0, LFQH_l_.str.78
LFQH_Lloh2561:
nop
bl Lpatch + (0xa5a4 - PATCH_BASE)
mov	x1, x0
mov	x0, x20
mov.16b	v0, v8
mov.16b	v1, v9
mov.16b	v2, v10
mov.16b	v3, v11
bl Lpatch + (0xa5d4 - PATCH_BASE)
LFQH_LBB149_2:
LFQH_Lloh2562:
adr x1, LFQH_GlyphOriginalKey
LFQH_Lloh2563:
nop
mov	x0, x20
mov	x2, #0
mov	w3, #1
bl Lpatch + (0xa634 - PATCH_BASE)
LFQH_Lloh2564:
adr x1, LFQH_GlyphAppliedKey
LFQH_Lloh2565:
nop
mov	x0, x20
mov	x2, #0
mov	w3, #1
bl Lpatch + (0xa634 - PATCH_BASE)
LFQH_Lloh2566:
adr x1, LFQH_GlyphViewKey
LFQH_Lloh2567:
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
LFQH_Lloh2568:
adr x1, LFQH_l_.str.304
LFQH_Lloh2569:
nop
bl	LFQH_Responds
cbz	w0, LFQH_LBB152_2
LFQH_Lloh2570:
adr x1, LFQH_l_.str.305
LFQH_Lloh2571:
nop
mov	x0, x19
bl	LFQH_Responds
LFQH_LBB152_2:
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
LFQH_Lloh2572:
adr x0, LFQH_l_.str.306
LFQH_Lloh2573:
nop
bl Lpatch + (0xa5b0 - PATCH_BASE)
mov	x19, x0
cbnz	x0, LFQH_LBB153_3
LFQH_Lloh2574:
adr x0, LFQH_l_.str.290
LFQH_Lloh2575:
nop
bl Lpatch + (0xa5b0 - PATCH_BASE)
LFQH_Lloh2576:
adr x1, LFQH_l_.str.306
LFQH_Lloh2577:
nop
mov	x2, #0
bl Lpatch + (0xa61c - PATCH_BASE)
mov	x19, x0
cbz	x0, LFQH_LBB153_3
LFQH_Lloh2578:
adr x0, LFQH_l_.str.307
LFQH_Lloh2579:
nop
bl Lpatch + (0xa5a4 - PATCH_BASE)
mov	x1, x0
LFQH_Lloh2580:
adr x2, LFQH_Press
LFQH_Lloh2581:
nop
LFQH_Lloh2582:
adr x20, LFQH_l_.str.120
LFQH_Lloh2583:
nop
mov	x0, x19
mov	x3, x20
bl Lpatch + (0xa58c - PATCH_BASE)
LFQH_Lloh2584:
adr x0, LFQH_l_.str.308
LFQH_Lloh2585:
nop
bl Lpatch + (0xa5a4 - PATCH_BASE)
mov	x1, x0
LFQH_Lloh2586:
adr x2, LFQH_ReleasePress
LFQH_Lloh2587:
nop
mov	x0, x19
mov	x3, x20
bl Lpatch + (0xa58c - PATCH_BASE)
mov	x0, x19
bl Lpatch + (0xa610 - PATCH_BASE)
LFQH_LBB153_3:
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
LFQH_Lloh2588:
adr x1, LFQH_l_.str.41
LFQH_Lloh2589:
nop
bl	LFQH_Kind
cbz	w0, LFQH_LBB154_2
LFQH_Lloh2590:
adr x8, LFQH_l_.str.309
LFQH_Lloh2591:
nop
LFQH_Lloh2592:
adr x9, LFQH_l_.str.310
LFQH_Lloh2593:
nop
cmp	w21, #0
csel	x0, x9, x8, eq
bl Lpatch + (0xa5a4 - PATCH_BASE)
mov	x21, x0
LFQH_Lloh2594:
adr x0, LFQH_l_.str.307
LFQH_Lloh2595:
nop
bl Lpatch + (0xa5a4 - PATCH_BASE)
mov	x3, x0
mov	x0, x20
mov	x1, x21
mov	x2, x19
mov	w4, #17
bl Lpatch + (0xa5d4 - PATCH_BASE)
LFQH_Lloh2596:
adr x0, LFQH_l_.str.308
LFQH_Lloh2597:
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
LFQH_LBB154_2:
ldp	x29, x30, [sp, #32]
ldp	x20, x19, [sp, #16]
ldp	x22, x21, [sp], #48
ret
.cfi_endproc
.p2align	2
LFQH_ReaderShelfMaterial:
.cfi_startproc
sub	sp, sp, #304
stp	d15, d14, [sp, #144]
stp	d13, d12, [sp, #160]
stp	d11, d10, [sp, #176]
stp	d9, d8, [sp, #192]
stp	x28, x27, [sp, #208]
stp	x26, x25, [sp, #224]
stp	x24, x23, [sp, #240]
stp	x22, x21, [sp, #256]
stp	x20, x19, [sp, #272]
stp	x29, x30, [sp, #288]
add	x29, sp, #288
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
stp	d3, d1, [sp, #48]
str	d2, [sp, #96]
mov.16b	v13, v0
mov	x21, x1
mov	x19, x0
LFQH_Lloh2598:
adr x0, LFQH_l_.str.249
LFQH_Lloh2599:
nop
bl Lpatch + (0xa5a4 - PATCH_BASE)
mov	x1, x0
mov	x0, x19
bl Lpatch + (0xa5d4 - PATCH_BASE)
mov.16b	v12, v0
mov.16b	v14, v1
mov.16b	v11, v2
mov.16b	v8, v3
LFQH_Lloh2600:
adr x1, LFQH_ReaderShelfStockFrameKey
LFQH_Lloh2601:
nop
mov	x0, x19
bl Lpatch + (0xa628 - PATCH_BASE)
mov	x20, x0
LFQH_Lloh2602:
adr x1, LFQH_ReaderShelfStyledFrameKey
LFQH_Lloh2603:
nop
mov	x0, x19
bl Lpatch + (0xa628 - PATCH_BASE)
mov	x22, x0
stp	d11, d8, [sp, #80]
stp	d12, d14, [sp, #64]
cbz	x0, LFQH_LBB155_2
LFQH_Lloh2604:
adr x0, LFQH_l_.str.286
LFQH_Lloh2605:
nop
bl Lpatch + (0xa5a4 - PATCH_BASE)
mov	x1, x0
mov	x0, x22
bl Lpatch + (0xa5d4 - PATCH_BASE)
fcmp	d12, d0
fccmp	d14, d1, #0, eq
fccmp	d11, d2, #0, eq
fccmp	d8, d3, #0, eq
b.eq	LFQH_LBB155_3
LFQH_LBB155_2:
mov	w23, #0
str	d12, [sp, #104]
str	d14, [sp, #128]
mov.16b	v14, v11
b	LFQH_LBB155_4
LFQH_LBB155_3:
LFQH_Lloh2606:
adr x0, LFQH_l_.str.286
LFQH_Lloh2607:
nop
bl Lpatch + (0xa5a4 - PATCH_BASE)
mov	x1, x0
mov	x0, x20
bl Lpatch + (0xa5d4 - PATCH_BASE)
str	d0, [sp, #104]
str	d1, [sp, #128]
mov.16b	v14, v2
mov.16b	v8, v3
mov	w23, #1
LFQH_LBB155_4:
LFQH_Lloh2608:
adr x0, LFQH_l_.str.247
LFQH_Lloh2609:
nop
bl Lpatch + (0xa5a4 - PATCH_BASE)
mov	x20, x0
LFQH_Lloh2610:
adr x0, LFQH_l_.str.240
LFQH_Lloh2611:
nop
bl Lpatch + (0xa5b0 - PATCH_BASE)
mov	x2, x0
mov	x0, x21
mov	x1, x20
bl Lpatch + (0xa5d4 - PATCH_BASE)
mov	x20, x21
cbnz	w0, LFQH_LBB155_6
LFQH_Lloh2612:
adr x0, LFQH_l_.str.20
LFQH_Lloh2613:
nop
bl Lpatch + (0xa5a4 - PATCH_BASE)
mov	x1, x0
mov	x0, x21
bl Lpatch + (0xa5d4 - PATCH_BASE)
mov	x20, x0
LFQH_LBB155_6:
LFQH_Lloh2614:
adr x1, LFQH_l_.str.240
LFQH_Lloh2615:
nop
mov	x0, x20
bl	LFQH_Kind
str	d8, [sp, #112]
cbz	w0, LFQH_LBB155_17
str	w23, [sp, #36]
str	x22, [sp, #40]
LFQH_Lloh2616:
adr x0, LFQH_l_.str.303
LFQH_Lloh2617:
nop
bl Lpatch + (0xa5a4 - PATCH_BASE)
mov	x1, x0
mov	x0, x21
ldr	d0, [sp, #104]
ldr	d1, [sp, #128]
mov.16b	v2, v14
mov.16b	v3, v8
mov	x2, x20
bl Lpatch + (0xa5d4 - PATCH_BASE)
mov.16b	v11, v0
mov.16b	v15, v1
mov.16b	v8, v3
LFQH_Lloh2618:
adr x0, LFQH_l_.str.24
LFQH_Lloh2619:
nop
bl Lpatch + (0xa5a4 - PATCH_BASE)
mov	x1, x0
mov	x0, x20
bl Lpatch + (0xa5d4 - PATCH_BASE)
fmov	d1, #8.00000000
fadd	d0, d0, d1
str	d0, [sp, #120]
LFQH_Lloh2620:
adr x0, LFQH_l_.str.279
LFQH_Lloh2621:
nop
bl Lpatch + (0xa5a4 - PATCH_BASE)
mov	x1, x0
mov	x0, x20
bl Lpatch + (0xa5d4 - PATCH_BASE)
mov	x23, x0
LFQH_Lloh2622:
adr x1, LFQH_l_.str.311
LFQH_Lloh2623:
nop
mov	x0, x20
bl	LFQH_Get
mov	x24, x0
LFQH_Lloh2624:
adr x1, LFQH_IconGlassKey
LFQH_Lloh2625:
nop
mov	x0, x19
bl Lpatch + (0xa628 - PATCH_BASE)
mov	x25, x0
LFQH_Lloh2626:
adr x0, LFQH_l_.str.34
LFQH_Lloh2627:
nop
bl Lpatch + (0xa5a4 - PATCH_BASE)
mov	x1, x0
mov	x0, x23
bl Lpatch + (0xa5d4 - PATCH_BASE)
cbz	x0, LFQH_LBB155_16
mov	x26, x0
str	x20, [sp, #8]
mov	x27, #0
fmov	d0, #0.50000000
fmul	d0, d8, d0
fadd	d0, d15, d0
fmov	d1, #18.00000000
fadd	d12, d0, d1
LFQH_Lloh2628:
adr x28, LFQH_l_.str.327
LFQH_Lloh2629:
nop
fmov	d1, #-18.00000000
LFQH_Lloh2630:
adr x22, LFQH_l_.str.292
LFQH_Lloh2631:
nop
fadd	d10, d0, d1
stp	d14, d13, [sp, #16]
LFQH_LBB155_9:
mov	x0, x28
bl Lpatch + (0xa5a4 - PATCH_BASE)
mov	x1, x0
mov	x0, x23
mov	x2, x27
bl Lpatch + (0xa5d4 - PATCH_BASE)
cmp	x0, x24
ccmp	x0, x25, #4, ne
ccmp	x0, x19, #4, ne
ccmp	x0, x21, #4, ne
b.eq	LFQH_LBB155_15
mov	x20, x0
mov	x0, x22
bl Lpatch + (0xa5a4 - PATCH_BASE)
mov	x1, x0
mov	x0, x20
bl Lpatch + (0xa5d4 - PATCH_BASE)
cbnz	w0, LFQH_LBB155_15
LFQH_Lloh2632:
adr x0, LFQH_l_.str.249
LFQH_Lloh2633:
nop
bl Lpatch + (0xa5a4 - PATCH_BASE)
mov	x1, x0
mov	x0, x20
bl Lpatch + (0xa5d4 - PATCH_BASE)
mov.16b	v8, v0
fadd	d0, d1, d3
fcmp	d8, d11
fccmp	d1, d12, #0, lt
fccmp	d0, d10, #0, lt
b.ls	LFQH_LBB155_15
mov.16b	v15, v2
mov.16b	v9, v12
mov.16b	v12, v11
mov	x0, x20
LFQH_Lloh2634:
adr x1, LFQH_IconGlassKey
LFQH_Lloh2635:
nop
bl Lpatch + (0xa628 - PATCH_BASE)
mov	x22, x0
fadd	d11, d8, d15
LFQH_Lloh2636:
adr x0, LFQH_l_.str.20
LFQH_Lloh2637:
nop
bl Lpatch + (0xa5a4 - PATCH_BASE)
mov	x1, x0
mov	x0, x22
bl Lpatch + (0xa5d4 - PATCH_BASE)
cmp	x0, x20
b.ne	LFQH_LBB155_14
LFQH_Lloh2638:
adr x0, LFQH_l_.str.249
LFQH_Lloh2639:
nop
bl Lpatch + (0xa5a4 - PATCH_BASE)
mov	x1, x0
mov	x0, x22
bl Lpatch + (0xa5d4 - PATCH_BASE)
mov.16b	v8, v0
mov.16b	v15, v1
mov.16b	v13, v2
mov.16b	v14, v3
LFQH_Lloh2640:
adr x0, LFQH_l_.str.303
LFQH_Lloh2641:
nop
bl Lpatch + (0xa5a4 - PATCH_BASE)
mov	x1, x0
mov	x0, x20
mov.16b	v0, v8
mov.16b	v1, v15
mov.16b	v2, v13
mov.16b	v3, v14
ldp	d14, d13, [sp, #16]
ldr	x2, [sp, #8]
bl Lpatch + (0xa5d4 - PATCH_BASE)
fadd	d0, d0, d2
fcmp	d0, d11
fcsel	d11, d0, d11, gt
LFQH_LBB155_14:
fmov	d0, #8.00000000
fadd	d0, d11, d0
ldr	d1, [sp, #120]
fcmp	d0, d1
fcsel	d1, d0, d1, gt
str	d1, [sp, #120]
mov.16b	v11, v12
mov.16b	v12, v9
LFQH_Lloh2642:
adr x22, LFQH_l_.str.292
LFQH_Lloh2643:
nop
LFQH_LBB155_15:
add	x27, x27, #1
cmp	x26, x27
b.ne	LFQH_LBB155_9
LFQH_LBB155_16:
fmov	d0, #-6.00000000
fadd	d0, d11, d0
ldr	d1, [sp, #120]
fsub	d0, d0, d1
fmov	d1, #0.50000000
fmul	d1, d0, d1
fmov	d2, #12.00000000
fcmp	d0, d2
fmov	d2, #6.00000000
fcsel	d1, d1, d2, mi
fcmp	d0, #0.0
fmov	d0, xzr
fcsel	d8, d1, d0, gt
ldr	x22, [sp, #40]
ldr	w23, [sp, #36]
b	LFQH_LBB155_18
LFQH_LBB155_17:
fmov	d8, xzr
LFQH_LBB155_18:
ldr	d0, [sp, #104]
fsub	d11, d0, d8
ldp	d1, d0, [sp, #64]
fcmp	d1, d11
cset	w8, ne
ldr	d1, [sp, #128]
fcmp	d0, d1
csinc	w8, w8, wzr, eq
ldp	d0, d1, [sp, #80]
fcmp	d0, d14
csinc	w8, w8, wzr, eq
ldr	d0, [sp, #112]
fcmp	d1, d0
csinc	w20, w8, wzr, eq
cbz	w20, LFQH_LBB155_20
LFQH_Lloh2644:
adr x0, LFQH_l_.str.78
LFQH_Lloh2645:
nop
bl Lpatch + (0xa5a4 - PATCH_BASE)
mov	x1, x0
mov	x0, x19
mov.16b	v0, v11
ldr	d1, [sp, #128]
mov.16b	v2, v14
ldr	d3, [sp, #112]
bl Lpatch + (0xa5d4 - PATCH_BASE)
LFQH_LBB155_20:
fcmp	d8, #0.0
b.le	LFQH_LBB155_23
tbz	w23, #0, LFQH_LBB155_25
ldr	d15, [sp, #112]
cbnz	w20, LFQH_LBB155_26
b	LFQH_LBB155_28
LFQH_LBB155_23:
cbz	x22, LFQH_LBB155_28
LFQH_Lloh2646:
adr x1, LFQH_ReaderShelfStockFrameKey
LFQH_Lloh2647:
nop
mov	x0, x19
mov	x2, #0
mov	w3, #1
bl Lpatch + (0xa634 - PATCH_BASE)
mov	x2, #0
b	LFQH_LBB155_27
LFQH_LBB155_25:
LFQH_Lloh2648:
adr x0, LFQH_l_.str.287
LFQH_Lloh2649:
nop
bl Lpatch + (0xa5b0 - PATCH_BASE)
mov	x20, x0
LFQH_Lloh2650:
adr x0, LFQH_l_.str.288
LFQH_Lloh2651:
nop
bl Lpatch + (0xa5a4 - PATCH_BASE)
mov	x1, x0
mov	x0, x20
ldp	d0, d15, [sp, #104]
ldr	d1, [sp, #128]
mov.16b	v2, v14
mov.16b	v3, v15
bl Lpatch + (0xa5d4 - PATCH_BASE)
mov	x2, x0
LFQH_Lloh2652:
adr x1, LFQH_ReaderShelfStockFrameKey
LFQH_Lloh2653:
nop
mov	x0, x19
mov	w3, #1
bl Lpatch + (0xa634 - PATCH_BASE)
LFQH_LBB155_26:
LFQH_Lloh2654:
adr x0, LFQH_l_.str.287
LFQH_Lloh2655:
nop
bl Lpatch + (0xa5b0 - PATCH_BASE)
mov	x20, x0
LFQH_Lloh2656:
adr x0, LFQH_l_.str.288
LFQH_Lloh2657:
nop
bl Lpatch + (0xa5a4 - PATCH_BASE)
mov	x1, x0
mov	x0, x20
mov.16b	v0, v11
ldr	d1, [sp, #128]
mov.16b	v2, v14
mov.16b	v3, v15
bl Lpatch + (0xa5d4 - PATCH_BASE)
mov	x2, x0
LFQH_LBB155_27:
LFQH_Lloh2658:
adr x1, LFQH_ReaderShelfStyledFrameKey
LFQH_Lloh2659:
nop
mov	x0, x19
mov	w3, #1
bl Lpatch + (0xa634 - PATCH_BASE)
LFQH_LBB155_28:
fmov	d0, #-6.00000000
fadd	d0, d13, d0
fsub	d0, d0, d8
mov	x8, #-4593108669964484608
fmov	d1, x8
ldr	d2, [sp, #48]
fadd	d1, d2, d1
fmov	d2, #0.50000000
fmul	d1, d1, d2
ldr	d2, [sp, #56]
fadd	d1, d2, d1
fmov	d2, #12.00000000
ldr	d3, [sp, #96]
fadd	d2, d3, d2
fadd	d3, d8, d8
fadd	d2, d2, d3
ldp	x29, x30, [sp, #288]
ldp	x20, x19, [sp, #272]
ldp	x22, x21, [sp, #256]
ldp	x24, x23, [sp, #240]
ldp	x26, x25, [sp, #224]
ldp	x28, x27, [sp, #208]
ldp	d9, d8, [sp, #192]
ldp	d11, d10, [sp, #176]
ldp	d13, d12, [sp, #160]
ldp	d15, d14, [sp, #144]
add	sp, sp, #304
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
LFQH_Lloh2660:
adr x22, LFQH_l_.str.249
LFQH_Lloh2661:
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
LFQH_Lloh2662:
adr x0, LFQH_l_.str.24
LFQH_Lloh2663:
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
LFQH_Lloh2664:
adr x0, LFQH_l_.str.20
LFQH_Lloh2665:
nop
bl Lpatch + (0xa5a4 - PATCH_BASE)
mov	x1, x0
mov	x0, x21
bl Lpatch + (0xa5d4 - PATCH_BASE)
cmp	x0, x20
b.eq	LFQH_LBB157_2
mov	x21, x0
LFQH_Lloh2666:
adr x0, LFQH_l_.str.303
LFQH_Lloh2667:
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
LFQH_LBB157_2:
LFQH_Lloh2668:
adr x1, LFQH_l_.str.312
LFQH_Lloh2669:
nop
mov	x0, x20
bl	LFQH_Get
mov.16b	v8, v10
stp	d13, d12, [sp, #80]
mov.16b	v3, v14
cbz	x0, LFQH_LBB157_4
mov	x21, x0
LFQH_Lloh2670:
adr x0, LFQH_l_.str.303
LFQH_Lloh2671:
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
LFQH_LBB157_4:
str	d3, [sp, #40]
LFQH_Lloh2672:
adr x1, LFQH_LayoutKey
LFQH_Lloh2673:
nop
mov	x0, x20
bl Lpatch + (0xa628 - PATCH_BASE)
cbz	x0, LFQH_LBB157_25
mov	x21, x0
LFQH_Lloh2674:
adr x0, LFQH_l_.str.327
LFQH_Lloh2675:
nop
bl Lpatch + (0xa5a4 - PATCH_BASE)
mov	x1, x0
mov	x0, x21
mov	x2, #0
bl Lpatch + (0xa5d4 - PATCH_BASE)
mov	x22, x0
LFQH_Lloh2676:
adr x0, LFQH_l_.str.286
LFQH_Lloh2677:
nop
bl Lpatch + (0xa5a4 - PATCH_BASE)
mov	x1, x0
mov	x0, x22
bl Lpatch + (0xa5d4 - PATCH_BASE)
fcmp	d8, d0
b.ne	LFQH_LBB157_25
ldr	d0, [sp, #88]
fcmp	d0, d1
b.ne	LFQH_LBB157_25
ldr	d0, [sp, #80]
fcmp	d0, d2
b.ne	LFQH_LBB157_25
fcmp	d14, d3
b.ne	LFQH_LBB157_25
LFQH_Lloh2678:
adr x0, LFQH_l_.str.327
LFQH_Lloh2679:
nop
bl Lpatch + (0xa5a4 - PATCH_BASE)
mov	x1, x0
mov	x0, x21
mov	w2, #1
bl Lpatch + (0xa5d4 - PATCH_BASE)
mov	x22, x0
LFQH_Lloh2680:
adr x0, LFQH_l_.str.286
LFQH_Lloh2681:
nop
bl Lpatch + (0xa5a4 - PATCH_BASE)
mov	x1, x0
mov	x0, x22
bl Lpatch + (0xa5d4 - PATCH_BASE)
fcmp	d9, d0
b.ne	LFQH_LBB157_25
ldr	d0, [sp, #144]
fcmp	d0, d1
b.ne	LFQH_LBB157_25
ldr	d0, [sp, #136]
fcmp	d0, d2
b.ne	LFQH_LBB157_25
ldr	d0, [sp, #128]
fcmp	d0, d3
b.ne	LFQH_LBB157_25
LFQH_Lloh2682:
adr x0, LFQH_l_.str.327
LFQH_Lloh2683:
nop
bl Lpatch + (0xa5a4 - PATCH_BASE)
mov	x1, x0
mov	x0, x21
mov	w2, #2
bl Lpatch + (0xa5d4 - PATCH_BASE)
mov	x22, x0
LFQH_Lloh2684:
adr x0, LFQH_l_.str.286
LFQH_Lloh2685:
nop
bl Lpatch + (0xa5a4 - PATCH_BASE)
mov	x1, x0
mov	x0, x22
bl Lpatch + (0xa5d4 - PATCH_BASE)
ldr	d4, [sp, #72]
fcmp	d4, d0
b.ne	LFQH_LBB157_25
ldr	d0, [sp, #64]
fcmp	d0, d1
b.ne	LFQH_LBB157_25
ldr	d0, [sp, #56]
fcmp	d0, d2
b.ne	LFQH_LBB157_25
ldr	d0, [sp, #48]
fcmp	d0, d3
b.ne	LFQH_LBB157_25
LFQH_Lloh2686:
adr x0, LFQH_l_.str.327
LFQH_Lloh2687:
nop
bl Lpatch + (0xa5a4 - PATCH_BASE)
mov	x1, x0
mov	x0, x21
mov	w2, #3
bl Lpatch + (0xa5d4 - PATCH_BASE)
mov	x22, x0
LFQH_Lloh2688:
adr x0, LFQH_l_.str.286
LFQH_Lloh2689:
nop
bl Lpatch + (0xa5a4 - PATCH_BASE)
mov	x1, x0
mov	x0, x22
bl Lpatch + (0xa5d4 - PATCH_BASE)
ldr	d4, [sp, #120]
fcmp	d4, d0
b.ne	LFQH_LBB157_25
ldr	d0, [sp, #112]
fcmp	d0, d1
b.ne	LFQH_LBB157_25
ldr	d0, [sp, #104]
fcmp	d0, d2
b.ne	LFQH_LBB157_25
ldr	d0, [sp, #96]
fcmp	d0, d3
b.ne	LFQH_LBB157_25
LFQH_Lloh2690:
adr x0, LFQH_l_.str.327
LFQH_Lloh2691:
nop
bl Lpatch + (0xa5a4 - PATCH_BASE)
mov	x1, x0
mov	x0, x21
mov	w2, #4
bl Lpatch + (0xa5d4 - PATCH_BASE)
mov	x21, x0
LFQH_Lloh2692:
adr x0, LFQH_l_.str.286
LFQH_Lloh2693:
nop
bl Lpatch + (0xa5a4 - PATCH_BASE)
mov	x1, x0
mov	x0, x21
bl Lpatch + (0xa5d4 - PATCH_BASE)
fcmp	d10, d0
b.ne	LFQH_LBB157_25
fcmp	d12, d1
b.ne	LFQH_LBB157_25
fcmp	d13, d2
b.ne	LFQH_LBB157_25
ldr	d0, [sp, #40]
fcmp	d0, d3
b.eq	LFQH_LBB157_28
LFQH_LBB157_25:
LFQH_Lloh2694:
adr x0, LFQH_l_.str.270
LFQH_Lloh2695:
nop
bl Lpatch + (0xa5b0 - PATCH_BASE)
mov	x21, x0
LFQH_Lloh2696:
adr x0, LFQH_l_.str.271
LFQH_Lloh2697:
nop
bl Lpatch + (0xa5a4 - PATCH_BASE)
mov	x1, x0
mov	x0, x21
bl Lpatch + (0xa5d4 - PATCH_BASE)
mov	x21, x0
LFQH_Lloh2698:
adr x0, LFQH_l_.str.272
LFQH_Lloh2699:
nop
bl Lpatch + (0xa5a4 - PATCH_BASE)
mov	x1, x0
mov	x0, x21
bl Lpatch + (0xa5d4 - PATCH_BASE)
mov.16b	v15, v0
LFQH_Lloh2700:
adr x1, LFQH_LayoutTimeKey
LFQH_Lloh2701:
nop
mov	x0, x20
bl Lpatch + (0xa628 - PATCH_BASE)
cbz	x0, LFQH_LBB157_27
mov	x21, x0
LFQH_Lloh2702:
adr x0, LFQH_l_.str.266
LFQH_Lloh2703:
nop
bl Lpatch + (0xa5a4 - PATCH_BASE)
mov	x1, x0
mov	x0, x21
bl Lpatch + (0xa5d4 - PATCH_BASE)
fsub	d0, d15, d0
fmov	d1, #1.00000000
fcmp	d0, d1
b.mi	LFQH_LBB157_28
LFQH_LBB157_27:
LFQH_Lloh2704:
adr x21, LFQH_l_.str.287
LFQH_Lloh2705:
nop
mov	x0, x21
bl Lpatch + (0xa5b0 - PATCH_BASE)
mov	x23, x0
LFQH_Lloh2706:
adr x22, LFQH_l_.str.288
LFQH_Lloh2707:
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
LFQH_Lloh2708:
adr x0, LFQH_l_.str.33
LFQH_Lloh2709:
nop
bl Lpatch + (0xa5b0 - PATCH_BASE)
mov	x21, x0
LFQH_Lloh2710:
adr x0, LFQH_l_.str.313
LFQH_Lloh2711:
nop
bl Lpatch + (0xa5a4 - PATCH_BASE)
mov	x1, x0
add	x2, sp, #152
mov	x0, x21
mov	w3, #5
bl Lpatch + (0xa5d4 - PATCH_BASE)
mov	x2, x0
LFQH_Lloh2712:
adr x1, LFQH_LayoutKey
LFQH_Lloh2713:
nop
mov	x0, x20
mov	w3, #1
bl Lpatch + (0xa634 - PATCH_BASE)
LFQH_Lloh2714:
adr x0, LFQH_l_.str.267
LFQH_Lloh2715:
nop
bl Lpatch + (0xa5b0 - PATCH_BASE)
mov	x21, x0
LFQH_Lloh2716:
adr x0, LFQH_l_.str.268
LFQH_Lloh2717:
nop
bl Lpatch + (0xa5a4 - PATCH_BASE)
mov	x1, x0
mov	x0, x21
mov.16b	v0, v15
bl Lpatch + (0xa5d4 - PATCH_BASE)
mov	x2, x0
LFQH_Lloh2718:
adr x1, LFQH_LayoutTimeKey
LFQH_Lloh2719:
nop
mov	x0, x20
mov	w3, #1
bl Lpatch + (0xa634 - PATCH_BASE)
LFQH_Lloh2720:
adr x0, LFQH_l_.str.273
LFQH_Lloh2721:
nop
bl Lpatch + (0xa5b0 - PATCH_BASE)
mov	x20, x0
LFQH_Lloh2722:
adr x0, LFQH_l_.str.274
LFQH_Lloh2723:
nop
bl Lpatch + (0xa5a4 - PATCH_BASE)
mov	x1, x0
mov	x0, x20
bl Lpatch + (0xa5d4 - PATCH_BASE)
mov	x20, x0
LFQH_Lloh2724:
adr x0, LFQH_l_.str.244
LFQH_Lloh2725:
nop
bl Lpatch + (0xa5b0 - PATCH_BASE)
mov	x21, x0
LFQH_Lloh2726:
adr x0, LFQH_l_.str.245
LFQH_Lloh2727:
nop
bl Lpatch + (0xa5a4 - PATCH_BASE)
mov	x1, x0
mov	x0, x21
mov	x2, x19
bl Lpatch + (0xa5d4 - PATCH_BASE)
mov	x2, x0
LFQH_Lloh2728:
adr x1, LFQH_l_.str.275
LFQH_Lloh2729:
nop
mov	x0, x20
bl	LFQH_Put
ldp	d3, d0, [sp, #24]
ldp	d2, d1, [sp, #80]
bl	LFQH_RectArray
mov	x2, x0
LFQH_Lloh2730:
adr x1, LFQH_l_.str.276
LFQH_Lloh2731:
nop
mov	x0, x20
bl	LFQH_Put
ldr	d0, [sp, #16]
ldp	d2, d1, [sp, #136]
ldr	d3, [sp, #128]
bl	LFQH_RectArray
mov	x2, x0
LFQH_Lloh2732:
adr x1, LFQH_l_.str.277
LFQH_Lloh2733:
nop
mov	x0, x20
bl	LFQH_Put
ldp	d1, d0, [sp, #64]
ldp	d3, d2, [sp, #48]
bl	LFQH_RectArray
mov	x2, x0
LFQH_Lloh2734:
adr x1, LFQH_l_.str.314
LFQH_Lloh2735:
nop
mov	x0, x20
bl	LFQH_Put
mov.16b	v0, v14
mov.16b	v1, v11
mov.16b	v2, v9
mov.16b	v3, v8
bl	LFQH_RectArray
mov	x2, x0
LFQH_Lloh2736:
adr x1, LFQH_l_.str.278
LFQH_Lloh2737:
nop
mov	x0, x20
bl	LFQH_Put
ldr	d0, [sp, #8]
mov.16b	v1, v10
mov.16b	v2, v13
mov.16b	v3, v12
bl	LFQH_RectArray
mov	x2, x0
LFQH_Lloh2738:
adr x1, LFQH_l_.str.315
LFQH_Lloh2739:
nop
mov	x0, x20
bl	LFQH_Put
LFQH_Lloh2740:
adr x0, LFQH_l_.str.316
LFQH_Lloh2741:
nop
mov	x1, x20
bl Lrecord_named
LFQH_LBB157_28:
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
b.le	LFQH_LBB158_6
cmp	w0, #7
b.le	LFQH_LBB158_13
cmp	w0, #8
b.eq	LFQH_LBB158_18
cmp	w0, #9
b.eq	LFQH_LBB158_20
cmp	w0, #10
b.ne	LFQH_LBB158_21
LFQH_Lloh2742:
adr x0, LFQH_l_.str.325
LFQH_Lloh2743:
nop
ret
LFQH_LBB158_6:
cmp	w0, #3
b.gt	LFQH_LBB158_10
cmp	w0, #2
b.eq	LFQH_LBB158_16
cmp	w0, #3
b.ne	LFQH_LBB158_21
LFQH_Lloh2744:
adr x0, LFQH_l_.str.318
LFQH_Lloh2745:
nop
ret
LFQH_LBB158_10:
cmp	w0, #4
b.eq	LFQH_LBB158_17
cmp	w0, #5
b.ne	LFQH_LBB158_21
LFQH_Lloh2746:
adr x0, LFQH_l_.str.320
LFQH_Lloh2747:
nop
ret
LFQH_LBB158_13:
cmp	w0, #6
b.eq	LFQH_LBB158_19
cmp	w0, #7
b.ne	LFQH_LBB158_21
LFQH_Lloh2748:
adr x0, LFQH_l_.str.322
LFQH_Lloh2749:
nop
ret
LFQH_LBB158_16:
LFQH_Lloh2750:
adr x0, LFQH_l_.str.317
LFQH_Lloh2751:
nop
ret
LFQH_LBB158_17:
LFQH_Lloh2752:
adr x0, LFQH_l_.str.319
LFQH_Lloh2753:
nop
ret
LFQH_LBB158_18:
LFQH_Lloh2754:
adr x0, LFQH_l_.str.323
LFQH_Lloh2755:
nop
ret
LFQH_LBB158_19:
LFQH_Lloh2756:
adr x0, LFQH_l_.str.321
LFQH_Lloh2757:
nop
ret
LFQH_LBB158_20:
LFQH_Lloh2758:
adr x0, LFQH_l_.str.324
LFQH_Lloh2759:
nop
ret
LFQH_LBB158_21:
LFQH_Lloh2760:
adr x0, LFQH_l_.str.326
LFQH_Lloh2761:
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
LFQH_Lloh2762:
adr x1, LFQH_ClipsKey
LFQH_Lloh2763:
nop
bl Lpatch + (0xa628 - PATCH_BASE)
mov	x21, x0
LFQH_Lloh2764:
adr x1, LFQH_OpaqueKey
LFQH_Lloh2765:
nop
mov	x0, x19
bl Lpatch + (0xa628 - PATCH_BASE)
mov	x20, x0
cbz	x21, LFQH_LBB161_3
LFQH_Lloh2766:
adr x0, LFQH_l_.str.251
LFQH_Lloh2767:
nop
bl Lpatch + (0xa5a4 - PATCH_BASE)
mov	x1, x0
mov	x0, x19
bl Lpatch + (0xa5d4 - PATCH_BASE)
cbnz	w0, LFQH_LBB161_3
LFQH_Lloh2768:
adr x0, LFQH_l_.str.265
LFQH_Lloh2769:
nop
bl Lpatch + (0xa5a4 - PATCH_BASE)
mov	x22, x0
LFQH_Lloh2770:
adr x0, LFQH_l_.str.40
LFQH_Lloh2771:
nop
bl Lpatch + (0xa5a4 - PATCH_BASE)
mov	x1, x0
mov	x0, x21
bl Lpatch + (0xa5d4 - PATCH_BASE)
mov	x2, x0
mov	x0, x19
mov	x1, x22
bl Lpatch + (0xa5d4 - PATCH_BASE)
LFQH_LBB161_3:
cbz	x20, LFQH_LBB161_6
LFQH_Lloh2772:
adr x0, LFQH_l_.str.252
LFQH_Lloh2773:
nop
bl Lpatch + (0xa5a4 - PATCH_BASE)
mov	x1, x0
mov	x0, x19
bl Lpatch + (0xa5d4 - PATCH_BASE)
cbnz	w0, LFQH_LBB161_6
LFQH_Lloh2774:
adr x0, LFQH_l_.str.262
LFQH_Lloh2775:
nop
bl Lpatch + (0xa5a4 - PATCH_BASE)
mov	x21, x0
LFQH_Lloh2776:
adr x0, LFQH_l_.str.40
LFQH_Lloh2777:
nop
bl Lpatch + (0xa5a4 - PATCH_BASE)
mov	x1, x0
mov	x0, x20
bl Lpatch + (0xa5d4 - PATCH_BASE)
mov	x2, x0
mov	x0, x19
mov	x1, x21
bl Lpatch + (0xa5d4 - PATCH_BASE)
LFQH_LBB161_6:
LFQH_Lloh2778:
adr x1, LFQH_ClipsKey
LFQH_Lloh2779:
nop
mov	x0, x19
mov	x2, #0
mov	w3, #1
bl Lpatch + (0xa634 - PATCH_BASE)
LFQH_Lloh2780:
adr x1, LFQH_OpaqueKey
LFQH_Lloh2781:
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
LFQH_ReaderShelfStyledFrameKey:
.cfi_startproc
ret
.cfi_endproc
.p2align	2
LFQH_ReaderShelfStockFrameKey:
.cfi_startproc
ret
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
LFQH_Lloh2782:
adr x0, LFQH_l_.str.301
LFQH_Lloh2783:
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
LFQH_Lloh2784:
adr x0, LFQH_l_.str.301
LFQH_Lloh2785:
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
LFQH_Lloh2786:
adr x1, LFQH_HeaderClipsKey
LFQH_Lloh2787:
nop
bl Lpatch + (0xa628 - PATCH_BASE)
mov	x23, x0
LFQH_Lloh2788:
adr x1, LFQH_HeaderOpaqueKey
LFQH_Lloh2789:
nop
mov	x0, x19
bl Lpatch + (0xa628 - PATCH_BASE)
mov	x22, x0
LFQH_Lloh2790:
adr x1, LFQH_HeaderRadiusKey
LFQH_Lloh2791:
nop
mov	x0, x19
bl Lpatch + (0xa628 - PATCH_BASE)
mov	x20, x0
LFQH_Lloh2792:
adr x1, LFQH_HeaderAppliedRadiusKey
LFQH_Lloh2793:
nop
mov	x0, x19
bl Lpatch + (0xa628 - PATCH_BASE)
mov	x21, x0
cbz	x23, LFQH_LBB169_3
LFQH_Lloh2794:
adr x0, LFQH_l_.str.251
LFQH_Lloh2795:
nop
bl Lpatch + (0xa5a4 - PATCH_BASE)
mov	x1, x0
mov	x0, x19
bl Lpatch + (0xa5d4 - PATCH_BASE)
cbz	w0, LFQH_LBB169_3
LFQH_Lloh2796:
adr x0, LFQH_l_.str.265
LFQH_Lloh2797:
nop
bl Lpatch + (0xa5a4 - PATCH_BASE)
mov	x24, x0
LFQH_Lloh2798:
adr x0, LFQH_l_.str.40
LFQH_Lloh2799:
nop
bl Lpatch + (0xa5a4 - PATCH_BASE)
mov	x1, x0
mov	x0, x23
bl Lpatch + (0xa5d4 - PATCH_BASE)
mov	x2, x0
mov	x0, x19
mov	x1, x24
bl Lpatch + (0xa5d4 - PATCH_BASE)
LFQH_LBB169_3:
cbz	x22, LFQH_LBB169_6
LFQH_Lloh2800:
adr x0, LFQH_l_.str.252
LFQH_Lloh2801:
nop
bl Lpatch + (0xa5a4 - PATCH_BASE)
mov	x1, x0
mov	x0, x19
bl Lpatch + (0xa5d4 - PATCH_BASE)
cbnz	w0, LFQH_LBB169_6
LFQH_Lloh2802:
adr x0, LFQH_l_.str.262
LFQH_Lloh2803:
nop
bl Lpatch + (0xa5a4 - PATCH_BASE)
mov	x23, x0
LFQH_Lloh2804:
adr x0, LFQH_l_.str.40
LFQH_Lloh2805:
nop
bl Lpatch + (0xa5a4 - PATCH_BASE)
mov	x1, x0
mov	x0, x22
bl Lpatch + (0xa5d4 - PATCH_BASE)
mov	x2, x0
mov	x0, x19
mov	x1, x23
bl Lpatch + (0xa5d4 - PATCH_BASE)
LFQH_LBB169_6:
cbz	x20, LFQH_LBB169_10
cbz	x21, LFQH_LBB169_10
LFQH_Lloh2806:
adr x0, LFQH_l_.str.263
LFQH_Lloh2807:
nop
bl Lpatch + (0xa5a4 - PATCH_BASE)
mov	x1, x0
mov	x0, x19
bl Lpatch + (0xa5d4 - PATCH_BASE)
mov	x22, x0
LFQH_Lloh2808:
adr x0, LFQH_l_.str.264
LFQH_Lloh2809:
nop
bl Lpatch + (0xa5a4 - PATCH_BASE)
mov	x1, x0
mov	x0, x22
bl Lpatch + (0xa5d4 - PATCH_BASE)
mov.16b	v8, v0
LFQH_Lloh2810:
adr x0, LFQH_l_.str.266
LFQH_Lloh2811:
nop
bl Lpatch + (0xa5a4 - PATCH_BASE)
mov	x1, x0
mov	x0, x21
bl Lpatch + (0xa5d4 - PATCH_BASE)
fcmp	d8, d0
b.ne	LFQH_LBB169_10
LFQH_Lloh2812:
adr x0, LFQH_l_.str.266
LFQH_Lloh2813:
nop
bl Lpatch + (0xa5a4 - PATCH_BASE)
mov	x1, x0
mov	x0, x20
bl Lpatch + (0xa5d4 - PATCH_BASE)
mov.16b	v8, v0
LFQH_Lloh2814:
adr x0, LFQH_l_.str.263
LFQH_Lloh2815:
nop
bl Lpatch + (0xa5a4 - PATCH_BASE)
mov	x1, x0
mov	x0, x19
bl Lpatch + (0xa5d4 - PATCH_BASE)
mov	x20, x0
LFQH_Lloh2816:
adr x0, LFQH_l_.str.269
LFQH_Lloh2817:
nop
bl Lpatch + (0xa5a4 - PATCH_BASE)
mov	x1, x0
mov	x0, x20
mov.16b	v0, v8
bl Lpatch + (0xa5d4 - PATCH_BASE)
LFQH_LBB169_10:
LFQH_Lloh2818:
adr x1, LFQH_HeaderClipsKey
LFQH_Lloh2819:
nop
mov	x0, x19
mov	x2, #0
mov	w3, #1
bl Lpatch + (0xa634 - PATCH_BASE)
LFQH_Lloh2820:
adr x1, LFQH_HeaderOpaqueKey
LFQH_Lloh2821:
nop
mov	x0, x19
mov	x2, #0
mov	w3, #1
bl Lpatch + (0xa634 - PATCH_BASE)
LFQH_Lloh2822:
adr x1, LFQH_HeaderRadiusKey
LFQH_Lloh2823:
nop
mov	x0, x19
mov	x2, #0
mov	w3, #1
bl Lpatch + (0xa634 - PATCH_BASE)
LFQH_Lloh2824:
adr x1, LFQH_HeaderAppliedRadiusKey
LFQH_Lloh2825:
nop
mov	x0, x19
mov	x2, #0
mov	w3, #1
bl Lpatch + (0xa634 - PATCH_BASE)
LFQH_Lloh2826:
adr x1, LFQH_HeaderLogKey
LFQH_Lloh2827:
nop
mov	x0, x19
mov	x2, #0
mov	w3, #1
bl Lpatch + (0xa634 - PATCH_BASE)
LFQH_Lloh2828:
adr x1, LFQH_HeaderLogTimeKey
LFQH_Lloh2829:
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
LFQH_Lloh2830:
adr x1, LFQH_l_.str.341
LFQH_Lloh2831:
nop
bl	LFQH_Get
mov	x19, x0
LFQH_Lloh2832:
adr x1, LFQH_l_.str.342
LFQH_Lloh2833:
nop
bl	LFQH_Kind
cbz	w0, LFQH_LBB170_3
mov	x0, x19
bl Lpatch + (0xa664 - PATCH_BASE)
LFQH_Lloh2834:
adr x1, LFQH_l_.str.343
LFQH_Lloh2835:
nop
LFQH_Lloh2836:
adr x2, LFQH_l_.str.344
LFQH_Lloh2837:
nop
bl	LFQH_ClassABI
cbz	w0, LFQH_LBB170_3
LFQH_Lloh2838:
adr x0, LFQH_l_.str.343
LFQH_Lloh2839:
nop
bl Lpatch + (0xa5a4 - PATCH_BASE)
mov	x1, x0
mov	x0, x19
ldp	x29, x30, [sp, #16]
ldp	x20, x19, [sp], #32
b Lpatch + (0xa5d4 - PATCH_BASE)
LFQH_LBB170_3:
mov	w0, #0
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
LFQH_ShelfEditPadding:
.cfi_startproc
sub	sp, sp, #128
stp	d15, d14, [sp, #16]
stp	d13, d12, [sp, #32]
stp	d11, d10, [sp, #48]
stp	d9, d8, [sp, #64]
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
.cfi_offset b8, -56
.cfi_offset b9, -64
.cfi_offset b10, -72
.cfi_offset b11, -80
.cfi_offset b12, -88
.cfi_offset b13, -96
.cfi_offset b14, -104
.cfi_offset b15, -112
mov	x19, x0
LFQH_Lloh2840:
adr x1, LFQH_l_.str.290
LFQH_Lloh2841:
nop
bl	LFQH_Kind
cbz	w0, LFQH_LBB172_28
LFQH_Lloh2842:
adr x1, LFQH_ShelfEditInsetsKey
LFQH_Lloh2843:
nop
mov	x0, x19
bl Lpatch + (0xa628 - PATCH_BASE)
mov	x20, x0
bl	LFQH_Enabled
cbz	w0, LFQH_LBB172_3
bl	LFQH_FQHGlassAvailable
mov	x21, x0
b	LFQH_LBB172_4
LFQH_LBB172_3:
mov	w21, #0
LFQH_LBB172_4:
cmp	x20, #0
cset	w8, ne
orr	w8, w8, w21
tbz	w8, #0, LFQH_LBB172_28
LFQH_Lloh2844:
adr x0, LFQH_l_.str.367
LFQH_Lloh2845:
nop
bl Lpatch + (0xa5a4 - PATCH_BASE)
mov	x1, x0
mov	x0, x19
bl Lpatch + (0xa5d4 - PATCH_BASE)
mov.16b	v11, v0
mov.16b	v8, v1
mov.16b	v9, v2
mov.16b	v14, v3
str	d3, [sp, #8]
cbz	x20, LFQH_LBB172_13
LFQH_Lloh2846:
adr x0, LFQH_l_.str.286
LFQH_Lloh2847:
nop
bl Lpatch + (0xa5a4 - PATCH_BASE)
mov	x1, x0
mov	x0, x20
bl Lpatch + (0xa5d4 - PATCH_BASE)
fcmp	d11, d0
b.ne	LFQH_LBB172_13
fmaxnm	d4, d1, d3
fmov	d5, #12.00000000
fmaxnm	d4, d4, d5
fcmp	d8, d4
fccmp	d9, d2, #0, eq
fccmp	d14, d4, #0, eq
mov.16b	v12, v11
mov.16b	v10, v8
mov.16b	v13, v9
b.ne	LFQH_LBB172_9
mov.16b	v12, v0
mov.16b	v10, v1
mov.16b	v13, v2
mov.16b	v14, v3
LFQH_LBB172_9:
cbz	w21, LFQH_LBB172_14
LFQH_LBB172_10:
fmaxnm	d0, d10, d14
fmov	d1, #12.00000000
fmaxnm	d15, d0, d1
fcmp	d12, d12
b.vs	LFQH_LBB172_16
fcmp	d10, d15
fccmp	d13, d13, #1, eq
fccmp	d14, d15, #0, vc
b.ne	LFQH_LBB172_16
mov.16b	v14, v15
cbnz	x20, LFQH_LBB172_15
b	LFQH_LBB172_24
LFQH_LBB172_13:
mov.16b	v12, v11
mov.16b	v10, v8
mov.16b	v13, v9
cbnz	w21, LFQH_LBB172_10
LFQH_LBB172_14:
mov.16b	v15, v10
cbz	x20, LFQH_LBB172_24
LFQH_LBB172_15:
mov	x2, #0
b	LFQH_LBB172_23
LFQH_LBB172_16:
cbz	x20, LFQH_LBB172_22
LFQH_Lloh2848:
adr x0, LFQH_l_.str.286
LFQH_Lloh2849:
nop
bl Lpatch + (0xa5a4 - PATCH_BASE)
mov	x1, x0
mov	x0, x20
bl Lpatch + (0xa5d4 - PATCH_BASE)
fcmp	d12, d0
b.ne	LFQH_LBB172_22
fcmp	d10, d1
b.ne	LFQH_LBB172_22
fcmp	d13, d2
b.ne	LFQH_LBB172_22
fcmp	d14, d3
b.ne	LFQH_LBB172_22
mov.16b	v14, v15
b	LFQH_LBB172_24
LFQH_LBB172_22:
LFQH_Lloh2850:
adr x0, LFQH_l_.str.287
LFQH_Lloh2851:
nop
bl Lpatch + (0xa5b0 - PATCH_BASE)
mov	x20, x0
LFQH_Lloh2852:
adr x0, LFQH_l_.str.288
LFQH_Lloh2853:
nop
bl Lpatch + (0xa5a4 - PATCH_BASE)
mov	x1, x0
mov	x0, x20
mov.16b	v0, v12
mov.16b	v1, v10
mov.16b	v2, v13
mov.16b	v3, v14
bl Lpatch + (0xa5d4 - PATCH_BASE)
mov	x2, x0
mov.16b	v14, v15
LFQH_LBB172_23:
LFQH_Lloh2854:
adr x1, LFQH_ShelfEditInsetsKey
LFQH_Lloh2855:
nop
mov	x0, x19
mov	w3, #1
bl Lpatch + (0xa634 - PATCH_BASE)
LFQH_LBB172_24:
fcmp	d11, d12
b.ne	LFQH_LBB172_29
fcmp	d8, d15
b.ne	LFQH_LBB172_29
fcmp	d9, d13
b.ne	LFQH_LBB172_29
ldr	d0, [sp, #8]
fcmp	d0, d14
b.ne	LFQH_LBB172_29
LFQH_LBB172_28:
ldp	x29, x30, [sp, #112]
ldp	x20, x19, [sp, #96]
ldp	x22, x21, [sp, #80]
ldp	d9, d8, [sp, #64]
ldp	d11, d10, [sp, #48]
ldp	d13, d12, [sp, #32]
ldp	d15, d14, [sp, #16]
add	sp, sp, #128
ret
LFQH_LBB172_29:
LFQH_Lloh2856:
adr x0, LFQH_l_.str.368
LFQH_Lloh2857:
nop
bl Lpatch + (0xa5a4 - PATCH_BASE)
mov	x1, x0
mov	x0, x19
mov.16b	v0, v12
mov.16b	v1, v15
mov.16b	v2, v13
mov.16b	v3, v14
ldp	x29, x30, [sp, #112]
ldp	x20, x19, [sp, #96]
ldp	x22, x21, [sp, #80]
ldp	d9, d8, [sp, #64]
ldp	d11, d10, [sp, #48]
ldp	d13, d12, [sp, #32]
ldp	d15, d14, [sp, #16]
add	sp, sp, #128
b Lpatch + (0xa5d4 - PATCH_BASE)
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
LFQH_Lloh2858:
adr x1, LFQH_l_.str.369
LFQH_Lloh2859:
nop
bl	LFQH_Get
mov	x22, x0
LFQH_Lloh2860:
adr x1, LFQH_l_.str.355
LFQH_Lloh2861:
nop
bl	LFQH_Get
mov	x19, x0
LFQH_Lloh2862:
adr x1, LFQH_l_.str.219
LFQH_Lloh2863:
nop
mov	x0, x22
bl	LFQH_Kind
fmov	d8, xzr
cbz	w0, LFQH_LBB173_5
LFQH_Lloh2864:
adr x1, LFQH_l_.str.370
LFQH_Lloh2865:
nop
mov	x0, x22
bl	LFQH_Get
cmp	x19, #0
ccmp	x0, x23, #0, ne
b.ne	LFQH_LBB173_5
LFQH_Lloh2866:
adr x1, LFQH_l_.str.371
LFQH_Lloh2867:
nop
mov	x0, x22
bl	LFQH_Get
cmp	x0, x20
b.ne	LFQH_LBB173_5
LFQH_Lloh2868:
adr x1, LFQH_l_.str.20
LFQH_Lloh2869:
nop
mov	x0, x20
bl	LFQH_Get
cmp	x0, x19
b.ne	LFQH_LBB173_5
LFQH_Lloh2870:
adr x0, LFQH_l_.str.251
LFQH_Lloh2871:
nop
bl Lpatch + (0xa5a4 - PATCH_BASE)
mov	x1, x0
mov	x0, x20
bl Lpatch + (0xa5d4 - PATCH_BASE)
cbz	w0, LFQH_LBB173_7
LFQH_LBB173_5:
fmov	d1, xzr
fmov	d2, xzr
fmov	d3, xzr
LFQH_LBB173_6:
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
LFQH_LBB173_7:
mov	x0, x20
bl	LFQH_CanExpandHit
cbz	w0, LFQH_LBB173_5
LFQH_Lloh2872:
adr x1, LFQH_l_.str.37
LFQH_Lloh2873:
nop
mov	x0, x23
bl	LFQH_Get
mov	x24, x0
LFQH_Lloh2874:
adr x1, LFQH_l_.str.38
LFQH_Lloh2875:
nop
mov	x0, x23
bl	LFQH_Get
mov	x23, x0
LFQH_Lloh2876:
adr x0, LFQH_l_.str.292
LFQH_Lloh2877:
nop
bl Lpatch + (0xa5a4 - PATCH_BASE)
mov	x1, x0
mov	x0, x24
bl Lpatch + (0xa5d4 - PATCH_BASE)
cmp	w0, #0
csel	x23, x24, x23, eq
LFQH_Lloh2878:
adr x1, LFQH_l_.str.372
LFQH_Lloh2879:
nop
mov	x0, x22
bl	LFQH_Get
mov	x22, x0
LFQH_Lloh2880:
adr x1, LFQH_l_.str.312
LFQH_Lloh2881:
nop
mov	x0, x20
bl	LFQH_Get
cbz	x0, LFQH_LBB173_5
mov	x24, x0
LFQH_Lloh2882:
adr x1, LFQH_l_.str.312
LFQH_Lloh2883:
nop
mov	x0, x22
bl	LFQH_Get
cmp	x0, x24
b.ne	LFQH_LBB173_5
LFQH_Lloh2884:
adr x0, LFQH_l_.str.292
LFQH_Lloh2885:
nop
bl Lpatch + (0xa5a4 - PATCH_BASE)
mov	x1, x0
mov	x0, x22
bl Lpatch + (0xa5d4 - PATCH_BASE)
cbnz	w0, LFQH_LBB173_5
cbz	x23, LFQH_LBB173_5
mov	w25, #0
LFQH_Lloh2886:
adr x24, LFQH_l_.str.20
LFQH_Lloh2887:
nop
mov	x0, x23
LFQH_LBB173_13:
cmp	x0, x20
b.eq	LFQH_LBB173_16
mov	x1, x24
bl	LFQH_Get
cbz	x0, LFQH_LBB173_5
cmp	w25, #7
add	w25, w25, #1
b.hs	LFQH_LBB173_5
b	LFQH_LBB173_13
LFQH_LBB173_16:
LFQH_Lloh2888:
adr x0, LFQH_l_.str.292
LFQH_Lloh2889:
nop
bl Lpatch + (0xa5a4 - PATCH_BASE)
mov	x1, x0
mov	x0, x23
bl Lpatch + (0xa5d4 - PATCH_BASE)
fmov	d1, xzr
fmov	d2, xzr
fmov	d3, xzr
cbnz	w0, LFQH_LBB173_6
LFQH_Lloh2890:
adr x0, LFQH_l_.str.24
LFQH_Lloh2891:
nop
bl Lpatch + (0xa5a4 - PATCH_BASE)
mov	x1, x0
mov	x0, x23
bl Lpatch + (0xa5d4 - PATCH_BASE)
mov.16b	v8, v0
mov.16b	v9, v1
mov.16b	v10, v2
mov.16b	v11, v3
LFQH_Lloh2892:
adr x0, LFQH_l_.str.303
LFQH_Lloh2893:
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
LFQH_Lloh2894:
adr x1, LFQH_IconGlassKey
LFQH_Lloh2895:
nop
mov	x0, x23
bl Lpatch + (0xa628 - PATCH_BASE)
cbz	x0, LFQH_LBB173_19
mov	x24, x0
LFQH_Lloh2896:
adr x0, LFQH_l_.str.249
LFQH_Lloh2897:
nop
bl Lpatch + (0xa5a4 - PATCH_BASE)
mov	x1, x0
mov	x0, x24
bl Lpatch + (0xa5d4 - PATCH_BASE)
mov.16b	v8, v0
mov.16b	v13, v1
mov.16b	v14, v2
mov.16b	v15, v3
LFQH_Lloh2898:
adr x0, LFQH_l_.str.303
LFQH_Lloh2899:
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
LFQH_LBB173_19:
LFQH_Lloh2900:
adr x1, LFQH_l_.str.364
LFQH_Lloh2901:
nop
mov	x0, x22
bl	LFQH_Get
LFQH_Lloh2902:
adr x1, LFQH_l_.str.373
LFQH_Lloh2903:
nop
bl	LFQH_Get
mov	x22, x0
LFQH_Lloh2904:
adr x0, LFQH_l_.str.34
LFQH_Lloh2905:
nop
bl Lpatch + (0xa5a4 - PATCH_BASE)
mov	x1, x0
mov	x0, x22
bl Lpatch + (0xa5d4 - PATCH_BASE)
fmov	d8, xzr
cbz	x0, LFQH_LBB173_26
mov	x23, x0
mov	w27, #0
mov	x24, #0
LFQH_Lloh2906:
adr x25, LFQH_l_.str.327
LFQH_Lloh2907:
nop
LFQH_Lloh2908:
adr x26, LFQH_l_.str.147
LFQH_Lloh2909:
nop
fmov	d9, xzr
fmov	d10, #4.00000000
LFQH_LBB173_21:
mov	x0, x25
bl Lpatch + (0xa5a4 - PATCH_BASE)
mov	x1, x0
mov	x0, x22
mov	x2, x24
bl Lpatch + (0xa5d4 - PATCH_BASE)
mov	x28, x0
mov	x1, x26
bl	LFQH_Kind
cbz	w0, LFQH_LBB173_24
LFQH_Lloh2910:
adr x0, LFQH_l_.str.292
LFQH_Lloh2911:
nop
bl Lpatch + (0xa5a4 - PATCH_BASE)
mov	x1, x0
mov	x0, x28
bl Lpatch + (0xa5d4 - PATCH_BASE)
cbnz	w0, LFQH_LBB173_24
LFQH_Lloh2912:
adr x0, LFQH_l_.str.24
LFQH_Lloh2913:
nop
bl Lpatch + (0xa5a4 - PATCH_BASE)
mov	x1, x0
mov	x0, x28
bl Lpatch + (0xa5d4 - PATCH_BASE)
mov.16b	v13, v0
mov.16b	v14, v1
mov.16b	v15, v2
mov.16b	v12, v3
LFQH_Lloh2914:
adr x0, LFQH_l_.str.303
LFQH_Lloh2915:
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
LFQH_LBB173_24:
add	x24, x24, #1
cmp	x23, x24
b.ne	LFQH_LBB173_21
cmp	w27, #0
cset	w22, eq
b	LFQH_LBB173_27
LFQH_LBB173_26:
mov	w22, #1
fmov	d9, xzr
LFQH_LBB173_27:
LFQH_Lloh2916:
adr x0, LFQH_l_.str.374
LFQH_Lloh2917:
nop
bl Lpatch + (0xa5a4 - PATCH_BASE)
mov	x1, x0
mov	x8, #9218868437227405311
fmov	d0, x8
mov	x0, x21
mov.16b	v1, v0
bl Lpatch + (0xa5d4 - PATCH_BASE)
tbnz	w22, #0, LFQH_LBB173_5
mov.16b	v14, v0
mov.16b	v13, v1
mov.16b	v0, v11
ldp	d3, d1, [sp, #16]
ldr	d2, [sp, #8]
bl	LFQH_VisibleRect
cbz	w0, LFQH_LBB173_5
mov	x8, #4631389266797133824
fmov	d0, x8
fmaxnm	d12, d14, d0
fsub	d0, d11, d9
fmov	d1, #20.00000000
fadd	d1, d12, d1
fcmp	d0, d1
b.mi	LFQH_LBB173_5
fmov	d0, #30.00000000
fmaxnm	d11, d13, d0
fmov	d0, #10.00000000
fadd	d13, d9, d0
ldr	d0, [sp, #16]
fsub	d0, d0, d11
fmov	d1, #0.50000000
fmul	d0, d0, d1
ldr	d1, [sp, #24]
fadd	d9, d1, d0
LFQH_Lloh2918:
adr x0, LFQH_l_.str.303
LFQH_Lloh2919:
nop
bl Lpatch + (0xa5a4 - PATCH_BASE)
mov	x1, x0
mov	x0, x20
mov.16b	v0, v13
mov.16b	v1, v9
mov.16b	v2, v12
mov.16b	v3, v11
mov	x2, x19
bl Lpatch + (0xa5d4 - PATCH_BASE)
mov.16b	v15, v0
mov.16b	v10, v1
mov.16b	v14, v2
str	d3, [sp, #24]
LFQH_Lloh2920:
adr x0, LFQH_l_.str.24
LFQH_Lloh2921:
nop
bl Lpatch + (0xa5a4 - PATCH_BASE)
mov	x1, x0
mov	x0, x19
bl Lpatch + (0xa5d4 - PATCH_BASE)
fcmp	d15, d0
fccmp	d10, d1, #8, pl
b.mi	LFQH_LBB173_5
fadd	d4, d15, d14
fadd	d0, d0, d2
fcmp	d4, d0
b.gt	LFQH_LBB173_5
ldr	d0, [sp, #24]
fadd	d0, d10, d0
fadd	d1, d1, d3
fcmp	d0, d1
fmov	d1, xzr
fmov	d2, xzr
fmov	d3, xzr
b.gt	LFQH_LBB173_6
mov.16b	v8, v13
mov.16b	v1, v9
mov.16b	v2, v12
mov.16b	v3, v11
b	LFQH_LBB173_6
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
mov	x20, x1
mov	x19, x0
LFQH_Lloh2922:
adr x1, LFQH_l_.str.290
LFQH_Lloh2923:
nop
bl	LFQH_Kind
cbz	w0, LFQH_LBB174_3
LFQH_Lloh2924:
adr x0, LFQH_l_.str.292
LFQH_Lloh2925:
nop
bl Lpatch + (0xa5a4 - PATCH_BASE)
mov	x1, x0
mov	x0, x19
bl Lpatch + (0xa5d4 - PATCH_BASE)
cbz	w0, LFQH_LBB174_4
mov	x0, x19
ldp	x29, x30, [sp, #16]
ldp	x20, x19, [sp], #32
b	LFQH_PageRestore
LFQH_LBB174_3:
ldp	x29, x30, [sp, #16]
ldp	x20, x19, [sp], #32
ret
LFQH_LBB174_4:
LFQH_Lloh2926:
adr x0, LFQH_l_.str.24
LFQH_Lloh2927:
nop
bl Lpatch + (0xa5a4 - PATCH_BASE)
mov	x1, x0
mov	x0, x19
bl Lpatch + (0xa5d4 - PATCH_BASE)
fmov	d4, #1.00000000
fadd	d1, d1, d4
fmov	d5, #-2.00000000
fadd	d3, d3, d5
fadd	d4, d0, d4
fadd	d5, d2, d5
cmp	w20, #0
fcsel	d2, d2, d5, eq
fcsel	d0, d0, d4, eq
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
LFQH_ShelfEditInsetsKey:
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
cbz	x0, LFQH_LBB177_3
mov	x19, x0
LFQH_Lloh2928:
adr x0, LFQH_l_.str.247
LFQH_Lloh2929:
nop
bl Lpatch + (0xa5a4 - PATCH_BASE)
mov	x20, x0
LFQH_Lloh2930:
adr x0, LFQH_l_.str.23
LFQH_Lloh2931:
nop
bl Lpatch + (0xa5b0 - PATCH_BASE)
mov	x2, x0
mov	x0, x19
mov	x1, x20
bl Lpatch + (0xa5d4 - PATCH_BASE)
cbz	w0, LFQH_LBB177_3
LFQH_Lloh2932:
adr x1, LFQH_SurfaceKey
LFQH_Lloh2933:
nop
mov	x0, x19
bl Lpatch + (0xa628 - PATCH_BASE)
mov	x1, x0
mov	x0, x19
ldp	x29, x30, [sp, #16]
ldp	x20, x19, [sp], #32
b	LFQH_Restore
LFQH_LBB177_3:
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
LFQH_Lloh2934:
adr x0, LFQH_l_.str.381
LFQH_Lloh2935:
nop
bl Lpatch + (0xa5a4 - PATCH_BASE)
mov	x1, x0
mov	x0, x21
bl Lpatch + (0xa5d4 - PATCH_BASE)
mov	x22, x0
bl	LFQH_PagePreference
cbz	x0, LFQH_LBB178_28
mov	x20, x0
LFQH_Lloh2936:
adr x1, LFQH_l_.str.382
LFQH_Lloh2937:
nop
mov	x0, x21
bl	LFQH_BoolProp
mov	x19, x0
cmp	x22, #6
b.lt	LFQH_LBB178_10
mov	x0, x20
mov	x1, x19
bl	LFQH_SetDefault
cmp	x22, #7
b.eq	LFQH_LBB178_24
cmp	x22, #6
b.ne	LFQH_LBB178_28
LFQH_Lloh2938:
adr x0, LFQH_l_.str.21
LFQH_Lloh2939:
nop
bl Lpatch + (0xa5b0 - PATCH_BASE)
LFQH_Lloh2940:
adr x1, LFQH_ShelfDurationHeadersKey
LFQH_Lloh2941:
nop
bl Lpatch + (0xa628 - PATCH_BASE)
mov	x20, x0
LFQH_Lloh2942:
adr x0, LFQH_l_.str.390
LFQH_Lloh2943:
nop
bl Lpatch + (0xa5a4 - PATCH_BASE)
mov	x1, x0
mov	x0, x20
bl Lpatch + (0xa5d4 - PATCH_BASE)
mov	x20, x0
LFQH_Lloh2944:
adr x0, LFQH_l_.str.34
LFQH_Lloh2945:
nop
bl Lpatch + (0xa5a4 - PATCH_BASE)
mov	x1, x0
mov	x0, x20
bl Lpatch + (0xa5d4 - PATCH_BASE)
cbz	x0, LFQH_LBB178_28
mov	x21, x0
mov	x22, #0
LFQH_Lloh2946:
adr x23, LFQH_l_.str.327
LFQH_Lloh2947:
nop
LFQH_Lloh2948:
adr x24, LFQH_ShelfDurationRequestedKey
LFQH_Lloh2949:
nop
LFQH_Lloh2950:
adr x25, LFQH_l_.str.363
LFQH_Lloh2951:
nop
LFQH_Lloh2952:
adr x26, LFQH_l_.str.40
LFQH_Lloh2953:
nop
LFQH_LBB178_6:
mov	x0, x23
bl Lpatch + (0xa5a4 - PATCH_BASE)
mov	x1, x0
mov	x0, x20
mov	x2, x22
bl Lpatch + (0xa5d4 - PATCH_BASE)
mov	x27, x0
mov	x1, x24
bl Lpatch + (0xa628 - PATCH_BASE)
cbz	w19, LFQH_LBB178_8
mov	x1, x26
bl	LFQH_BoolProp
cmp	w0, #0
cset	w1, ne
b	LFQH_LBB178_9
LFQH_LBB178_8:
mov	w1, #0
LFQH_LBB178_9:
mov	x0, x27
bl	LFQH_ApplyShelfDuration
mov	x0, x25
bl Lpatch + (0xa5a4 - PATCH_BASE)
mov	x1, x0
mov	x0, x27
bl Lpatch + (0xa5d4 - PATCH_BASE)
add	x22, x22, #1
cmp	x21, x22
b.ne	LFQH_LBB178_6
b	LFQH_LBB178_28
LFQH_LBB178_10:
LFQH_Lloh2954:
adr x0, LFQH_l_.str.392
LFQH_Lloh2955:
nop
bl Lpatch + (0xa5b0 - PATCH_BASE)
mov	x23, x0
LFQH_Lloh2956:
adr x0, LFQH_l_.str.393
LFQH_Lloh2957:
nop
bl Lpatch + (0xa5a4 - PATCH_BASE)
mov	x1, x0
mov	x0, x23
bl Lpatch + (0xa5d4 - PATCH_BASE)
mov	x24, x0
LFQH_Lloh2958:
adr x1, LFQH_l_.str.394
LFQH_Lloh2959:
nop
bl	LFQH_Get
LFQH_Lloh2960:
adr x1, LFQH_l_.str.395
LFQH_Lloh2961:
nop
bl	LFQH_Get
mov	w1, #5
bl	LFQH_FindTabOwner
cbz	x0, LFQH_LBB178_12
LFQH_LBB178_11:
mov	x23, x0
b	LFQH_LBB178_17
LFQH_LBB178_12:
LFQH_Lloh2962:
adr x1, LFQH_l_.str.396
LFQH_Lloh2963:
nop
mov	x0, x24
bl	LFQH_Get
mov	x24, x0
LFQH_Lloh2964:
adr x0, LFQH_l_.str.34
LFQH_Lloh2965:
nop
bl Lpatch + (0xa5a4 - PATCH_BASE)
mov	x1, x0
mov	x0, x24
bl Lpatch + (0xa5d4 - PATCH_BASE)
cbz	x0, LFQH_LBB178_16
mov	x25, x0
mov	x26, #0
LFQH_Lloh2966:
adr x27, LFQH_l_.str.327
LFQH_Lloh2967:
nop
LFQH_Lloh2968:
adr x28, LFQH_l_.str.395
LFQH_Lloh2969:
nop
LFQH_LBB178_14:
mov	x0, x27
bl Lpatch + (0xa5a4 - PATCH_BASE)
mov	x1, x0
mov	x0, x24
mov	x2, x26
bl Lpatch + (0xa5d4 - PATCH_BASE)
mov	x1, x28
bl	LFQH_Get
mov	w1, #5
bl	LFQH_FindTabOwner
cbnz	x0, LFQH_LBB178_11
add	x26, x26, #1
cmp	x25, x26
b.ne	LFQH_LBB178_14
LFQH_LBB178_16:
mov	x23, #0
LFQH_LBB178_17:
LFQH_Lloh2970:
adr x1, LFQH_l_.str.383
LFQH_Lloh2971:
nop
mov	x0, x23
bl	LFQH_Get
cbnz	w19, LFQH_LBB178_21
mov	x24, x0
LFQH_Lloh2972:
adr x0, LFQH_l_.str.34
LFQH_Lloh2973:
nop
bl Lpatch + (0xa5a4 - PATCH_BASE)
mov	x1, x0
mov	x0, x24
bl Lpatch + (0xa5d4 - PATCH_BASE)
cmp	x0, #1
b.ne	LFQH_LBB178_21
LFQH_Lloh2974:
adr x0, LFQH_l_.str.327
LFQH_Lloh2975:
nop
bl Lpatch + (0xa5a4 - PATCH_BASE)
mov	x1, x0
mov	x0, x24
mov	x2, #0
bl Lpatch + (0xa5d4 - PATCH_BASE)
mov	x1, x0
mov	x0, x23
bl	LFQH_TabOption
cmp	x0, x22
b.ne	LFQH_LBB178_21
LFQH_Lloh2976:
adr x0, LFQH_l_.str.384
LFQH_Lloh2977:
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
LFQH_LBB178_21:
mov	x0, x20
mov	x1, x19
bl	LFQH_SetDefault
cbz	x23, LFQH_LBB178_23
LFQH_Lloh2978:
adr x0, LFQH_l_.str.385
LFQH_Lloh2979:
nop
bl Lpatch + (0xa5a4 - PATCH_BASE)
mov	x1, x0
mov	x0, x23
bl Lpatch + (0xa5d4 - PATCH_BASE)
mov	x0, x23
bl	LFQH_InstallTabRecovery
LFQH_LBB178_23:
LFQH_Lloh2980:
adr x0, LFQH_l_.str.273
LFQH_Lloh2981:
nop
bl Lpatch + (0xa5b0 - PATCH_BASE)
mov	x21, x0
LFQH_Lloh2982:
adr x0, LFQH_l_.str.274
LFQH_Lloh2983:
nop
bl Lpatch + (0xa5a4 - PATCH_BASE)
mov	x1, x0
mov	x0, x21
bl Lpatch + (0xa5d4 - PATCH_BASE)
mov	x21, x0
LFQH_Lloh2984:
adr x0, LFQH_l_.str.244
LFQH_Lloh2985:
nop
bl Lpatch + (0xa5b0 - PATCH_BASE)
mov	x22, x0
LFQH_Lloh2986:
adr x0, LFQH_l_.str.245
LFQH_Lloh2987:
nop
bl Lpatch + (0xa5a4 - PATCH_BASE)
mov	x1, x0
LFQH_Lloh2988:
adr x23, LFQH_l_.str.386
LFQH_Lloh2989:
nop
mov	x0, x22
mov	x2, x23
bl Lpatch + (0xa5d4 - PATCH_BASE)
mov	x2, x0
LFQH_Lloh2990:
adr x1, LFQH_l_.str.347
LFQH_Lloh2991:
nop
mov	x0, x21
bl	LFQH_Put
LFQH_Lloh2992:
adr x1, LFQH_l_.str.387
LFQH_Lloh2993:
nop
mov	x0, x21
mov	x2, x20
bl	LFQH_Put
LFQH_Lloh2994:
adr x0, LFQH_l_.str.267
LFQH_Lloh2995:
nop
bl Lpatch + (0xa5b0 - PATCH_BASE)
mov	x20, x0
LFQH_Lloh2996:
adr x0, LFQH_l_.str.334
LFQH_Lloh2997:
nop
bl Lpatch + (0xa5a4 - PATCH_BASE)
mov	x1, x0
mov	x0, x20
mov	x2, x19
bl Lpatch + (0xa5d4 - PATCH_BASE)
mov	x2, x0
LFQH_Lloh2998:
adr x1, LFQH_l_.str.388
LFQH_Lloh2999:
nop
mov	x0, x21
bl	LFQH_Put
mov	x0, x23
mov	x1, x21
ldp	x29, x30, [sp, #80]
ldp	x20, x19, [sp, #64]
ldp	x22, x21, [sp, #48]
ldp	x24, x23, [sp, #32]
ldp	x26, x25, [sp, #16]
ldp	x28, x27, [sp], #96
b Lrecord_named
LFQH_LBB178_24:
LFQH_Lloh3000:
adr x0, LFQH_l_.str.175
LFQH_Lloh3001:
nop
bl Lpatch + (0xa5b0 - PATCH_BASE)
LFQH_Lloh3002:
adr x1, LFQH_l_.str.149
LFQH_Lloh3003:
nop
LFQH_Lloh3004:
adr x2, LFQH_l_.str.120
LFQH_Lloh3005:
nop
bl	LFQH_ClassABI
cbz	w0, LFQH_LBB178_28
LFQH_Lloh3006:
adr x0, LFQH_l_.str.175
LFQH_Lloh3007:
nop
bl Lpatch + (0xa5b0 - PATCH_BASE)
LFQH_Lloh3008:
adr x1, LFQH_MineControllersKey
LFQH_Lloh3009:
nop
bl Lpatch + (0xa628 - PATCH_BASE)
mov	x19, x0
LFQH_Lloh3010:
adr x0, LFQH_l_.str.390
LFQH_Lloh3011:
nop
bl Lpatch + (0xa5a4 - PATCH_BASE)
mov	x1, x0
mov	x0, x19
bl Lpatch + (0xa5d4 - PATCH_BASE)
mov	x19, x0
LFQH_Lloh3012:
adr x0, LFQH_l_.str.34
LFQH_Lloh3013:
nop
bl Lpatch + (0xa5a4 - PATCH_BASE)
mov	x1, x0
mov	x0, x19
bl Lpatch + (0xa5d4 - PATCH_BASE)
cbz	x0, LFQH_LBB178_28
mov	x20, x0
mov	x21, #0
LFQH_Lloh3014:
adr x23, LFQH_l_.str.149
LFQH_Lloh3015:
nop
LFQH_Lloh3016:
adr x24, LFQH_l_.str.244
LFQH_Lloh3017:
nop
LFQH_Lloh3018:
adr x25, LFQH_l_.str.245
LFQH_Lloh3019:
nop
LFQH_Lloh3020:
adr x26, LFQH_l_.str.391
LFQH_Lloh3021:
nop
LFQH_LBB178_27:
LFQH_Lloh3022:
adr x0, LFQH_l_.str.327
LFQH_Lloh3023:
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
b.ne	LFQH_LBB178_27
LFQH_LBB178_28:
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
LFQH_Lloh3024:
adr x0, LFQH_l_.str.413
LFQH_Lloh3025:
nop
bl Lpatch + (0xa5a4 - PATCH_BASE)
mov	x1, x0
mov	x0, x20
bl Lpatch + (0xa5d4 - PATCH_BASE)
cmp	x0, #1
b.ne	LFQH_LBB179_3
LFQH_Lloh3026:
adr x1, LFQH_RecoveryBarKey
LFQH_Lloh3027:
nop
mov	x0, x19
bl Lpatch + (0xa628 - PATCH_BASE)
mov	x19, x0
LFQH_Lloh3028:
adr x0, LFQH_l_.str.417
LFQH_Lloh3029:
nop
bl Lpatch + (0xa5a4 - PATCH_BASE)
mov	x1, x0
mov	x0, x19
bl Lpatch + (0xa5d4 - PATCH_BASE)
LFQH_Lloh3030:
adr x1, LFQH_l_.str.369
LFQH_Lloh3031:
nop
bl	LFQH_Get
mov	x19, x0
LFQH_Lloh3032:
adr x1, LFQH_l_.str.188
LFQH_Lloh3033:
nop
bl	LFQH_Kind
cbz	w0, LFQH_LBB179_3
LFQH_Lloh3034:
adr x1, LFQH_l_.str.414
LFQH_Lloh3035:
nop
mov	x0, x19
bl	LFQH_Get
cbz	x0, LFQH_LBB179_4
LFQH_LBB179_3:
ldp	x29, x30, [sp, #16]
ldp	x20, x19, [sp], #32
ret
LFQH_LBB179_4:
LFQH_Lloh3036:
adr x0, LFQH_l_.str.415
LFQH_Lloh3037:
nop
bl Lpatch + (0xa5a4 - PATCH_BASE)
mov	x20, x0
LFQH_Lloh3038:
adr x0, LFQH_l_.str.416
LFQH_Lloh3039:
nop
bl Lpatch + (0xa5b0 - PATCH_BASE)
mov	x1, x20
bl Lpatch + (0xa5f8 - PATCH_BASE)
cbz	x0, LFQH_LBB179_3
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
LFQH_Lloh3040:
adr x1, LFQH_RecoveryBarKey
LFQH_Lloh3041:
nop
bl Lpatch + (0xa628 - PATCH_BASE)
mov	x20, x0
LFQH_Lloh3042:
adr x0, LFQH_l_.str.417
LFQH_Lloh3043:
nop
bl Lpatch + (0xa5a4 - PATCH_BASE)
mov	x1, x0
mov	x0, x20
bl Lpatch + (0xa5d4 - PATCH_BASE)
cbz	x0, LFQH_LBB180_4
mov	x20, x0
LFQH_Lloh3044:
adr x0, LFQH_l_.str.292
LFQH_Lloh3045:
nop
bl Lpatch + (0xa5a4 - PATCH_BASE)
mov	x1, x0
mov	x0, x20
bl Lpatch + (0xa5d4 - PATCH_BASE)
cbnz	w0, LFQH_LBB180_3
LFQH_Lloh3046:
adr x0, LFQH_l_.str.244
LFQH_Lloh3047:
nop
bl Lpatch + (0xa5b0 - PATCH_BASE)
mov	x21, x0
LFQH_Lloh3048:
adr x0, LFQH_l_.str.245
LFQH_Lloh3049:
nop
bl Lpatch + (0xa5a4 - PATCH_BASE)
mov	x1, x0
LFQH_Lloh3050:
adr x2, LFQH_l_.str.434
LFQH_Lloh3051:
nop
mov	x0, x21
bl Lpatch + (0xa5d4 - PATCH_BASE)
bl	LFQH_DefaultEnabled
cbz	w0, LFQH_LBB180_5
LFQH_LBB180_3:
mov	w0, #0
LFQH_LBB180_4:
ldp	x29, x30, [sp, #48]
ldp	x20, x19, [sp, #32]
ldp	x22, x21, [sp, #16]
ldp	d9, d8, [sp], #64
ret
LFQH_LBB180_5:
LFQH_Lloh3052:
adr x0, LFQH_l_.str.418
LFQH_Lloh3053:
nop
bl Lpatch + (0xa5a4 - PATCH_BASE)
mov	x1, x0
mov	x0, x19
mov	x2, x20
bl Lpatch + (0xa5d4 - PATCH_BASE)
mov.16b	v8, v0
mov.16b	v9, v1
LFQH_Lloh3054:
adr x0, LFQH_l_.str.24
LFQH_Lloh3055:
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
b	LFQH_LBB180_4
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
cbz	w0, LFQH_LBB181_2
mov	x0, x20
bl Lpatch + (0xa5a4 - PATCH_BASE)
mov	x1, x0
mov	x0, x19
ldp	x29, x30, [sp, #16]
ldp	x20, x19, [sp], #32
b Lpatch + (0xa5d4 - PATCH_BASE)
LFQH_LBB181_2:
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
LFQH_Lloh3056:
adr x0, LFQH_l_.str.337
LFQH_Lloh3057:
nop
bl Lpatch + (0xa5b0 - PATCH_BASE)
mov	x21, x0
LFQH_Lloh3058:
adr x0, LFQH_l_.str.338
LFQH_Lloh3059:
nop
bl Lpatch + (0xa5a4 - PATCH_BASE)
mov	x1, x0
mov	x0, x21
bl Lpatch + (0xa5d4 - PATCH_BASE)
mov	x21, x0
LFQH_Lloh3060:
adr x0, LFQH_l_.str.389
LFQH_Lloh3061:
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
LFQH_Lloh3062:
adr x0, LFQH_l_.str.398
LFQH_Lloh3063:
nop
bl Lpatch + (0xa5a4 - PATCH_BASE)
mov	x1, x0
mov	x0, x20
bl Lpatch + (0xa5d4 - PATCH_BASE)
mov	x20, x0
cmp	w0, #3
b.gt	LFQH_LBB183_4
cbz	w20, LFQH_LBB183_9
cmp	w20, #3
b.ne	LFQH_LBB183_6
mov	w0, #3
b	LFQH_LBB183_13
LFQH_LBB183_4:
cmp	w20, #4
b.eq	LFQH_LBB183_10
cmp	w20, #7
b.eq	LFQH_LBB183_8
LFQH_LBB183_6:
mov	x0, x19
bl Lpatch + (0xa664 - PATCH_BASE)
LFQH_Lloh3064:
adr x1, LFQH_l_.str.399
LFQH_Lloh3065:
nop
LFQH_Lloh3066:
adr x2, LFQH_l_.str.400
LFQH_Lloh3067:
nop
bl	LFQH_ClassABI
cbz	w0, LFQH_LBB183_11
LFQH_Lloh3068:
adr x0, LFQH_l_.str.399
LFQH_Lloh3069:
nop
bl Lpatch + (0xa5a4 - PATCH_BASE)
mov	x1, x0
mov	x0, x19
mov	x2, x20
bl Lpatch + (0xa5d4 - PATCH_BASE)
mov	x19, x0
LFQH_Lloh3070:
adr x1, LFQH_l_.str.401
LFQH_Lloh3071:
nop
bl	LFQH_Equal
tbz	w0, #0, LFQH_LBB183_12
LFQH_LBB183_8:
mov	w0, #2
b	LFQH_LBB183_13
LFQH_LBB183_9:
mov	w0, #1
b	LFQH_LBB183_13
LFQH_LBB183_10:
mov	w0, #4
b	LFQH_LBB183_13
LFQH_LBB183_11:
mov	x0, #0
b	LFQH_LBB183_13
LFQH_LBB183_12:
LFQH_Lloh3072:
adr x1, LFQH_l_.str.402
LFQH_Lloh3073:
nop
mov	x0, x19
bl	LFQH_Equal
cmp	w0, #0
mov	w8, #5
csel	x0, xzr, x8, eq
LFQH_LBB183_13:
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
LFQH_Lloh3074:
adr x1, LFQH_l_.str.403
LFQH_Lloh3075:
nop
bl	LFQH_Get
mov	x22, x0
LFQH_Lloh3076:
adr x1, LFQH_l_.str.20
LFQH_Lloh3077:
nop
bl	LFQH_Get
mov	x20, x0
LFQH_Lloh3078:
adr x1, LFQH_TabRecoveryKey
LFQH_Lloh3079:
nop
mov	x0, x19
bl Lpatch + (0xa628 - PATCH_BASE)
mov	x21, x0
LFQH_Lloh3080:
adr x1, LFQH_l_.str.404
LFQH_Lloh3081:
nop
bl	LFQH_Get
mov	x23, x0
cbz	x20, LFQH_LBB184_3
LFQH_Lloh3082:
adr x0, LFQH_l_.str.244
LFQH_Lloh3083:
nop
bl Lpatch + (0xa5b0 - PATCH_BASE)
mov	x24, x0
LFQH_Lloh3084:
adr x0, LFQH_l_.str.245
LFQH_Lloh3085:
nop
bl Lpatch + (0xa5a4 - PATCH_BASE)
mov	x1, x0
LFQH_Lloh3086:
adr x2, LFQH_l_.str.434
LFQH_Lloh3087:
nop
mov	x0, x24
bl Lpatch + (0xa5d4 - PATCH_BASE)
bl	LFQH_DefaultEnabled
cmp	w0, #0
cset	w24, eq
cbnz	x21, LFQH_LBB184_4
LFQH_LBB184_2:
cbnz	w24, LFQH_LBB184_6
b	LFQH_LBB184_10
LFQH_LBB184_3:
mov	w24, #0
cbz	x21, LFQH_LBB184_2
LFQH_LBB184_4:
cmp	x23, x20
cset	w8, eq
and	w8, w8, w24
tbnz	w8, #0, LFQH_LBB184_10
LFQH_Lloh3088:
adr x0, LFQH_l_.str.405
LFQH_Lloh3089:
nop
bl Lpatch + (0xa5a4 - PATCH_BASE)
mov	x1, x0
mov	x0, x23
mov	x2, x21
bl Lpatch + (0xa5d4 - PATCH_BASE)
LFQH_Lloh3090:
adr x1, LFQH_TabRecoveryKey
LFQH_Lloh3091:
nop
mov	x0, x19
mov	x2, #0
mov	w3, #1
bl Lpatch + (0xa634 - PATCH_BASE)
cbz	w24, LFQH_LBB184_10
LFQH_LBB184_6:
bl	LFQH_ToggleObserver
mov	x21, x0
LFQH_Lloh3092:
adr x0, LFQH_l_.str.76
LFQH_Lloh3093:
nop
bl Lpatch + (0xa5a4 - PATCH_BASE)
mov	x1, x0
mov	x0, x21
bl Lpatch + (0xa5d4 - PATCH_BASE)
mov	x21, x0
LFQH_Lloh3094:
adr x0, LFQH_l_.str.77
LFQH_Lloh3095:
nop
bl Lpatch + (0xa5a4 - PATCH_BASE)
mov	x1, x0
mov	x0, x21
bl Lpatch + (0xa5d4 - PATCH_BASE)
cbz	x0, LFQH_LBB184_10
mov	x21, x0
LFQH_Lloh3096:
adr x0, LFQH_l_.str.406
LFQH_Lloh3097:
nop
bl Lpatch + (0xa5b0 - PATCH_BASE)
mov	x23, x0
LFQH_Lloh3098:
adr x0, LFQH_l_.str.407
LFQH_Lloh3099:
nop
bl Lpatch + (0xa5a4 - PATCH_BASE)
mov	x1, x0
mov	x0, x23
bl Lpatch + (0xa5d4 - PATCH_BASE)
mov	x23, x0
LFQH_Lloh3100:
adr x0, LFQH_l_.str.283
LFQH_Lloh3101:
nop
bl Lpatch + (0xa5a4 - PATCH_BASE)
mov	x1, x0
mov	x0, x23
mov	x2, x22
bl Lpatch + (0xa5d4 - PATCH_BASE)
LFQH_Lloh3102:
adr x1, LFQH_RecoveryBarKey
LFQH_Lloh3103:
nop
mov	x0, x21
mov	x2, x23
mov	w3, #1
bl Lpatch + (0xa634 - PATCH_BASE)
LFQH_Lloh3104:
adr x0, LFQH_l_.str.408
LFQH_Lloh3105:
nop
bl Lpatch + (0xa5b0 - PATCH_BASE)
mov	x22, x0
LFQH_Lloh3106:
adr x0, LFQH_l_.str.76
LFQH_Lloh3107:
nop
bl Lpatch + (0xa5a4 - PATCH_BASE)
mov	x1, x0
mov	x0, x22
bl Lpatch + (0xa5d4 - PATCH_BASE)
mov	x22, x0
LFQH_Lloh3108:
adr x0, LFQH_l_.str.409
LFQH_Lloh3109:
nop
bl Lpatch + (0xa5a4 - PATCH_BASE)
mov	x23, x0
LFQH_Lloh3110:
adr x0, LFQH_l_.str.378
LFQH_Lloh3111:
nop
bl Lpatch + (0xa5a4 - PATCH_BASE)
mov	x3, x0
mov	x0, x22
mov	x1, x23
mov	x2, x21
bl Lpatch + (0xa5d4 - PATCH_BASE)
cbz	x0, LFQH_LBB184_9
mov	x22, x0
LFQH_Lloh3112:
adr x0, LFQH_l_.str.410
LFQH_Lloh3113:
nop
bl Lpatch + (0xa5a4 - PATCH_BASE)
mov	x1, x0
fmov	d0, #0.75000000
mov	x0, x22
bl Lpatch + (0xa5d4 - PATCH_BASE)
LFQH_Lloh3114:
adr x0, LFQH_l_.str.411
LFQH_Lloh3115:
nop
bl Lpatch + (0xa5a4 - PATCH_BASE)
mov	x1, x0
mov	x0, x22
mov	x2, x21
bl Lpatch + (0xa5d4 - PATCH_BASE)
LFQH_Lloh3116:
adr x1, LFQH_ToggleObserverKey
LFQH_Lloh3117:
nop
mov	x0, x22
mov	x2, x21
mov	w3, #1
bl Lpatch + (0xa634 - PATCH_BASE)
LFQH_Lloh3118:
adr x1, LFQH_TabRecoveryKey
LFQH_Lloh3119:
nop
mov	x0, x19
mov	x2, x22
mov	w3, #1
bl Lpatch + (0xa634 - PATCH_BASE)
LFQH_Lloh3120:
adr x0, LFQH_l_.str.412
LFQH_Lloh3121:
nop
bl Lpatch + (0xa5a4 - PATCH_BASE)
mov	x1, x0
mov	x0, x20
mov	x2, x22
bl Lpatch + (0xa5d4 - PATCH_BASE)
LFQH_Lloh3122:
adr x0, LFQH_l_.str.55
LFQH_Lloh3123:
nop
bl Lpatch + (0xa5a4 - PATCH_BASE)
mov	x1, x0
mov	x0, x22
bl Lpatch + (0xa5d4 - PATCH_BASE)
LFQH_LBB184_9:
LFQH_Lloh3124:
adr x0, LFQH_l_.str.55
LFQH_Lloh3125:
nop
bl Lpatch + (0xa5a4 - PATCH_BASE)
mov	x1, x0
mov	x0, x21
ldp	x29, x30, [sp, #48]
ldp	x20, x19, [sp, #32]
ldp	x22, x21, [sp, #16]
ldp	x24, x23, [sp], #64
b Lpatch + (0xa5d4 - PATCH_BASE)
LFQH_LBB184_10:
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
LFQH_ApplyShelfDuration:
.cfi_startproc
sub	sp, sp, #48
stp	x20, x19, [sp, #16]
stp	x29, x30, [sp, #32]
add	x29, sp, #32
.cfi_def_cfa w29, 16
.cfi_offset w30, -8
.cfi_offset w29, -16
.cfi_offset w19, -24
.cfi_offset w20, -32
mov	x19, x1
mov	x20, x0
LFQH_Lloh3126:
adr x0, LFQH_l_.str.21
LFQH_Lloh3127:
nop
LFQH_Lloh3128:
adr x1, LFQH_l_.str.179
LFQH_Lloh3129:
nop
bl	LFQH_Original
cbz	x0, LFQH_LBB187_2
str	x0, [sp, #8]
LFQH_Lloh3130:
adr x0, LFQH_l_.str.178
LFQH_Lloh3131:
nop
bl Lpatch + (0xa5a4 - PATCH_BASE)
mov	x1, x0
mov	x0, x20
mov	x2, x19
ldr	x3, [sp, #8]
ldp	x29, x30, [sp, #32]
ldp	x20, x19, [sp, #16]
add	sp, sp, #48
br	x3
LFQH_LBB187_2:
ldp	x29, x30, [sp, #32]
ldp	x20, x19, [sp, #16]
add	sp, sp, #48
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
LFQH_Lloh3132:
adr x1, LFQH_l_.str.188
LFQH_Lloh3133:
nop
bl	LFQH_Kind
tbz	w0, #0, LFQH_LBB190_3
mov	x0, x19
LFQH_LBB190_2:
ldp	x29, x30, [sp, #48]
ldp	x20, x19, [sp, #32]
ldp	x22, x21, [sp, #16]
ldp	x24, x23, [sp], #64
ret
LFQH_LBB190_3:
mov	x0, #0
cbz	x19, LFQH_LBB190_2
cbz	w20, LFQH_LBB190_2
LFQH_Lloh3134:
adr x1, LFQH_l_.str.397
LFQH_Lloh3135:
nop
mov	x0, x19
bl	LFQH_Get
mov	x19, x0
LFQH_Lloh3136:
adr x0, LFQH_l_.str.34
LFQH_Lloh3137:
nop
bl Lpatch + (0xa5a4 - PATCH_BASE)
mov	x1, x0
mov	x0, x19
bl Lpatch + (0xa5d4 - PATCH_BASE)
cbz	x0, LFQH_LBB190_2
mov	x21, x0
mov	x22, #0
sub	w20, w20, #1
LFQH_Lloh3138:
adr x23, LFQH_l_.str.327
LFQH_Lloh3139:
nop
LFQH_LBB190_7:
mov	x0, x23
bl Lpatch + (0xa5a4 - PATCH_BASE)
mov	x1, x0
mov	x0, x19
mov	x2, x22
bl Lpatch + (0xa5d4 - PATCH_BASE)
mov	x1, x20
bl	LFQH_FindTabOwner
cbnz	x0, LFQH_LBB190_2
add	x22, x22, #1
cmp	x21, x22
b.ne	LFQH_LBB190_7
mov	x0, #0
b	LFQH_LBB190_2
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
cbz	x0, LFQH_LBB193_6
mov	x22, x2
mov	x20, x1
mov	x19, x0
LFQH_Lloh3140:
adr x1, LFQH_PageTintKey
LFQH_Lloh3141:
nop
bl Lpatch + (0xa628 - PATCH_BASE)
cbz	x0, LFQH_LBB193_3
LFQH_Lloh3142:
adr x1, LFQH_l_.str.40
LFQH_Lloh3143:
nop
bl	LFQH_BoolProp
cmp	w0, w20
b.eq	LFQH_LBB193_6
LFQH_LBB193_3:
LFQH_Lloh3144:
adr x1, LFQH_l_.str.51
LFQH_Lloh3145:
nop
mov	x0, x19
bl	LFQH_Get
mov	x21, x0
LFQH_Lloh3146:
adr x0, LFQH_l_.str.52
LFQH_Lloh3147:
nop
bl Lpatch + (0xa5a4 - PATCH_BASE)
mov	x1, x0
mov	x0, x21
bl Lpatch + (0xa5d4 - PATCH_BASE)
cbz	x0, LFQH_LBB193_6
mov	x21, x0
cbz	w20, LFQH_LBB193_7
LFQH_Lloh3148:
adr x0, LFQH_l_.str.46
LFQH_Lloh3149:
nop
bl Lpatch + (0xa5b0 - PATCH_BASE)
mov	x23, x0
LFQH_Lloh3150:
adr x8, LFQH_l_.str.443
LFQH_Lloh3151:
nop
LFQH_Lloh3152:
adr x9, LFQH_l_.str.47
LFQH_Lloh3153:
nop
cmp	w22, #0
csel	x0, x9, x8, eq
bl Lpatch + (0xa5a4 - PATCH_BASE)
mov	x1, x0
mov	x0, x23
bl Lpatch + (0xa5d4 - PATCH_BASE)
mov	x22, x0
b	LFQH_LBB193_8
LFQH_LBB193_6:
ldp	x29, x30, [sp, #48]
ldp	x20, x19, [sp, #32]
ldp	x22, x21, [sp, #16]
ldp	x24, x23, [sp], #64
ret
LFQH_LBB193_7:
mov	x22, #0
LFQH_LBB193_8:
LFQH_Lloh3154:
adr x0, LFQH_l_.str.50
LFQH_Lloh3155:
nop
bl Lpatch + (0xa5a4 - PATCH_BASE)
mov	x1, x0
fmov	d0, #0.12500000
mov	x0, x22
bl Lpatch + (0xa5d4 - PATCH_BASE)
mov	x22, x0
LFQH_Lloh3156:
adr x0, LFQH_l_.str.53
LFQH_Lloh3157:
nop
bl Lpatch + (0xa5a4 - PATCH_BASE)
mov	x1, x0
mov	x0, x21
mov	x2, x22
bl Lpatch + (0xa5d4 - PATCH_BASE)
LFQH_Lloh3158:
adr x0, LFQH_l_.str.54
LFQH_Lloh3159:
nop
bl Lpatch + (0xa5a4 - PATCH_BASE)
mov	x1, x0
mov	x0, x19
mov	x2, x21
bl Lpatch + (0xa5d4 - PATCH_BASE)
LFQH_Lloh3160:
adr x0, LFQH_l_.str.55
LFQH_Lloh3161:
nop
bl Lpatch + (0xa5a4 - PATCH_BASE)
mov	x1, x0
mov	x0, x21
bl Lpatch + (0xa5d4 - PATCH_BASE)
LFQH_Lloh3162:
adr x0, LFQH_l_.str.267
LFQH_Lloh3163:
nop
bl Lpatch + (0xa5b0 - PATCH_BASE)
mov	x21, x0
LFQH_Lloh3164:
adr x0, LFQH_l_.str.334
LFQH_Lloh3165:
nop
bl Lpatch + (0xa5a4 - PATCH_BASE)
mov	x1, x0
mov	x0, x21
mov	x2, x20
bl Lpatch + (0xa5d4 - PATCH_BASE)
mov	x2, x0
LFQH_Lloh3166:
adr x1, LFQH_PageTintKey
LFQH_Lloh3167:
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
cbz	x0, LFQH_LBB194_11
mov	x21, x1
mov	x19, x0
LFQH_Lloh3168:
adr x0, LFQH_l_.str.444
LFQH_Lloh3169:
nop
bl Lpatch + (0xa5a4 - PATCH_BASE)
mov	x1, x0
mov	x0, x19
bl Lpatch + (0xa5d4 - PATCH_BASE)
mov	x20, x0
LFQH_Lloh3170:
adr x1, LFQH_ShelfTitleGlassFontKey
LFQH_Lloh3171:
nop
mov	x0, x19
bl Lpatch + (0xa628 - PATCH_BASE)
cbz	x0, LFQH_LBB194_5
mov	x22, x0
cmp	x20, x0
b.eq	LFQH_LBB194_10
LFQH_Lloh3172:
adr x0, LFQH_l_.str.48
LFQH_Lloh3173:
nop
bl Lpatch + (0xa5a4 - PATCH_BASE)
mov	x1, x0
mov	x0, x20
mov	x2, x22
bl Lpatch + (0xa5d4 - PATCH_BASE)
cmp	w0, #0
cset	w8, ne
cbnz	w21, LFQH_LBB194_7
cbnz	w0, LFQH_LBB194_12
b	LFQH_LBB194_13
LFQH_LBB194_5:
cbz	w21, LFQH_LBB194_11
mov	w8, #0
LFQH_LBB194_7:
cmp	x20, #0
cset	w9, eq
orr	w8, w9, w8
tbnz	w8, #0, LFQH_LBB194_11
LFQH_Lloh3174:
adr x0, LFQH_l_.str.445
LFQH_Lloh3175:
nop
bl Lpatch + (0xa5a4 - PATCH_BASE)
mov	x1, x0
mov	x0, x20
bl Lpatch + (0xa5d4 - PATCH_BASE)
mov.16b	v8, v0
LFQH_Lloh3176:
adr x0, LFQH_l_.str.446
LFQH_Lloh3177:
nop
bl Lpatch + (0xa5a4 - PATCH_BASE)
mov	x1, x0
fmov	d0, #0.87500000
fmul	d0, d8, d0
mov	x0, x20
bl Lpatch + (0xa5d4 - PATCH_BASE)
cbz	x0, LFQH_LBB194_11
mov	x21, x0
LFQH_Lloh3178:
adr x1, LFQH_ShelfTitleHostFontKey
LFQH_Lloh3179:
nop
mov	x0, x19
mov	x2, x20
mov	w3, #1
bl Lpatch + (0xa634 - PATCH_BASE)
LFQH_Lloh3180:
adr x1, LFQH_ShelfTitleGlassFontKey
LFQH_Lloh3181:
nop
mov	x0, x19
mov	x2, x21
mov	w3, #1
bl Lpatch + (0xa634 - PATCH_BASE)
LFQH_Lloh3182:
adr x0, LFQH_l_.str.84
LFQH_Lloh3183:
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
LFQH_LBB194_10:
cbz	w21, LFQH_LBB194_12
LFQH_LBB194_11:
ldp	x29, x30, [sp, #48]
ldp	x20, x19, [sp, #32]
ldp	x22, x21, [sp, #16]
ldp	d9, d8, [sp], #64
ret
LFQH_LBB194_12:
LFQH_Lloh3184:
adr x0, LFQH_l_.str.84
LFQH_Lloh3185:
nop
bl Lpatch + (0xa5a4 - PATCH_BASE)
mov	x20, x0
LFQH_Lloh3186:
adr x1, LFQH_ShelfTitleHostFontKey
LFQH_Lloh3187:
nop
mov	x0, x19
bl Lpatch + (0xa628 - PATCH_BASE)
mov	x2, x0
mov	x0, x19
mov	x1, x20
bl Lpatch + (0xa5d4 - PATCH_BASE)
LFQH_LBB194_13:
LFQH_Lloh3188:
adr x1, LFQH_ShelfTitleHostFontKey
LFQH_Lloh3189:
nop
mov	x0, x19
mov	x2, #0
mov	w3, #1
bl Lpatch + (0xa634 - PATCH_BASE)
LFQH_Lloh3190:
adr x1, LFQH_ShelfTitleGlassFontKey
LFQH_Lloh3191:
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
bl	LFQH_ReaderBottomBackgroundEnabled
mov	x20, x0
LFQH_Lloh3192:
adr x1, LFQH_l_.str.458
LFQH_Lloh3193:
nop
mov	x0, x19
bl	LFQH_Get
mov	x21, x0
LFQH_Lloh3194:
adr x1, LFQH_l_.str.459
LFQH_Lloh3195:
nop
bl	LFQH_Kind
cbz	w0, LFQH_LBB198_5
LFQH_Lloh3196:
adr x1, LFQH_l_.str.248
LFQH_Lloh3197:
nop
mov	x0, x21
bl	LFQH_Get
LFQH_Lloh3198:
adr x1, LFQH_l_.str.240
LFQH_Lloh3199:
nop
bl	LFQH_Kind
cbz	w0, LFQH_LBB198_5
mov	x0, x21
bl Lpatch + (0xa664 - PATCH_BASE)
LFQH_Lloh3200:
adr x1, LFQH_l_.str.460
LFQH_Lloh3201:
nop
LFQH_Lloh3202:
adr x2, LFQH_l_.str.9
LFQH_Lloh3203:
nop
bl	LFQH_ClassABI
cbz	w0, LFQH_LBB198_5
mov	x0, x21
mov	x1, x20
bl	LFQH_ReaderBackdropFill
cbz	w0, LFQH_LBB198_5
LFQH_Lloh3204:
adr x0, LFQH_l_.str.460
LFQH_Lloh3205:
nop
bl Lpatch + (0xa5a4 - PATCH_BASE)
mov	x1, x0
mov	x0, x21
bl Lpatch + (0xa5d4 - PATCH_BASE)
LFQH_LBB198_5:
LFQH_Lloh3206:
adr x1, LFQH_l_.str.461
LFQH_Lloh3207:
nop
mov	x0, x19
bl	LFQH_Get
mov	x1, x20
bl	LFQH_ReaderBackdrop
LFQH_Lloh3208:
adr x1, LFQH_l_.str.462
LFQH_Lloh3209:
nop
mov	x0, x19
bl	LFQH_Get
mov	x1, x20
bl	LFQH_ReaderBackdrop
mov	x0, x19
mov	x1, x20
ldp	x29, x30, [sp, #32]
ldp	x20, x19, [sp, #16]
ldp	x22, x21, [sp], #48
b	LFQH_ReaderCommunityBackdrop
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
LFQH_Lloh3210:
adr x0, LFQH_l_.str.244
LFQH_Lloh3211:
nop
bl Lpatch + (0xa5b0 - PATCH_BASE)
mov	x19, x0
LFQH_Lloh3212:
adr x0, LFQH_l_.str.245
LFQH_Lloh3213:
nop
bl Lpatch + (0xa5a4 - PATCH_BASE)
mov	x1, x0
LFQH_Lloh3214:
adr x2, LFQH_l_.str.438
LFQH_Lloh3215:
nop
mov	x0, x19
bl Lpatch + (0xa5d4 - PATCH_BASE)
ldp	x29, x30, [sp, #16]
ldp	x20, x19, [sp], #32
b	LFQH_DefaultEnabled
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
LFQH_Lloh3216:
adr x1, LFQH_ReaderBackdropColorKey
LFQH_Lloh3217:
nop
bl Lpatch + (0xa628 - PATCH_BASE)
mov	x20, x0
cbz	w21, LFQH_LBB200_2
cbz	x20, LFQH_LBB200_9
LFQH_LBB200_2:
LFQH_Lloh3218:
adr x0, LFQH_l_.str.250
LFQH_Lloh3219:
nop
bl Lpatch + (0xa5a4 - PATCH_BASE)
mov	x1, x0
mov	x0, x19
bl Lpatch + (0xa5d4 - PATCH_BASE)
mov	x2, x0
cbz	w21, LFQH_LBB200_6
cbnz	x2, LFQH_LBB200_5
LFQH_Lloh3220:
adr x0, LFQH_l_.str.79
LFQH_Lloh3221:
nop
bl Lpatch + (0xa5a4 - PATCH_BASE)
mov	x1, x0
mov	x0, x19
mov	x2, x20
bl Lpatch + (0xa5d4 - PATCH_BASE)
LFQH_LBB200_5:
LFQH_Lloh3222:
adr x1, LFQH_ReaderBackdropColorKey
LFQH_Lloh3223:
nop
mov	w20, #1
mov	x0, x19
mov	x2, #0
mov	w3, #1
bl Lpatch + (0xa634 - PATCH_BASE)
b	LFQH_LBB200_9
LFQH_LBB200_6:
cbz	x2, LFQH_LBB200_8
LFQH_Lloh3224:
adr x1, LFQH_ReaderBackdropColorKey
LFQH_Lloh3225:
nop
mov	w20, #1
mov	x0, x19
mov	w3, #1
bl Lpatch + (0xa634 - PATCH_BASE)
LFQH_Lloh3226:
adr x0, LFQH_l_.str.79
LFQH_Lloh3227:
nop
bl Lpatch + (0xa5a4 - PATCH_BASE)
mov	x1, x0
mov	x0, x19
mov	x2, #0
bl Lpatch + (0xa5d4 - PATCH_BASE)
b	LFQH_LBB200_9
LFQH_LBB200_8:
mov	w20, #0
LFQH_LBB200_9:
mov	x0, x20
ldp	x29, x30, [sp, #32]
ldp	x20, x19, [sp, #16]
ldp	x22, x21, [sp], #48
ret
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
cbz	x0, LFQH_LBB201_13
mov	x19, x1
mov	x20, x0
LFQH_Lloh3228:
adr x1, LFQH_ReaderBackdropAppliedKey
LFQH_Lloh3229:
nop
bl Lpatch + (0xa628 - PATCH_BASE)
mov	x21, x0
cbz	w19, LFQH_LBB201_3
cbz	x21, LFQH_LBB201_13
LFQH_LBB201_3:
LFQH_Lloh3230:
adr x0, LFQH_l_.str.247
LFQH_Lloh3231:
nop
bl Lpatch + (0xa5a4 - PATCH_BASE)
mov	x22, x0
LFQH_Lloh3232:
adr x0, LFQH_l_.str.116
LFQH_Lloh3233:
nop
bl Lpatch + (0xa5b0 - PATCH_BASE)
mov	x2, x0
mov	x0, x20
mov	x1, x22
bl Lpatch + (0xa5d4 - PATCH_BASE)
mov	x22, x0
cbnz	w0, LFQH_LBB201_5
LFQH_Lloh3234:
adr x0, LFQH_l_.str.247
LFQH_Lloh3235:
nop
bl Lpatch + (0xa5a4 - PATCH_BASE)
mov	x23, x0
LFQH_Lloh3236:
adr x0, LFQH_l_.str.57
LFQH_Lloh3237:
nop
bl Lpatch + (0xa5b0 - PATCH_BASE)
mov	x2, x0
mov	x0, x20
mov	x1, x23
bl Lpatch + (0xa5d4 - PATCH_BASE)
cbz	w0, LFQH_LBB201_13
LFQH_LBB201_5:
LFQH_Lloh3238:
adr x0, LFQH_l_.str.20
LFQH_Lloh3239:
nop
bl Lpatch + (0xa5a4 - PATCH_BASE)
mov	x1, x0
mov	x0, x20
bl Lpatch + (0xa5d4 - PATCH_BASE)
mov	x23, x0
mov	x0, x20
mov	x1, x19
bl	LFQH_ReaderBackdropFill
LFQH_Lloh3240:
adr x1, LFQH_l_.str.463
LFQH_Lloh3241:
nop
mov	x0, x23
bl	LFQH_Kind
cbz	w0, LFQH_LBB201_8
LFQH_Lloh3242:
adr x1, LFQH_l_.str.248
LFQH_Lloh3243:
nop
mov	x0, x23
bl	LFQH_Get
cmp	x0, x20
b.ne	LFQH_LBB201_8
mov	x0, x23
mov	x1, x19
bl	LFQH_ReaderBackdropFill
LFQH_LBB201_8:
cmp	x21, #0
cset	w8, ne
cmp	w19, w8
b.ne	LFQH_LBB201_10
cmp	w19, #0
csel	x2, x20, xzr, eq
LFQH_Lloh3244:
adr x1, LFQH_ReaderBackdropAppliedKey
LFQH_Lloh3245:
nop
mov	x0, x20
mov	x3, #0
bl Lpatch + (0xa634 - PATCH_BASE)
LFQH_LBB201_10:
LFQH_Lloh3246:
adr x8, LFQH_l_.str.464
LFQH_Lloh3247:
nop
LFQH_Lloh3248:
adr x9, LFQH_l_.str.360
LFQH_Lloh3249:
nop
cmp	w22, #0
csel	x1, x9, x8, eq
mov	x0, x20
bl	LFQH_Get
mov	x21, x0
LFQH_Lloh3250:
adr x0, LFQH_l_.str.20
LFQH_Lloh3251:
nop
bl Lpatch + (0xa5a4 - PATCH_BASE)
mov	x1, x0
mov	x0, x21
bl Lpatch + (0xa5d4 - PATCH_BASE)
cmp	x0, x20
b.ne	LFQH_LBB201_13
LFQH_Lloh3252:
adr x1, LFQH_ReaderBackdropAlphaKey
LFQH_Lloh3253:
nop
mov	x0, x21
bl Lpatch + (0xa628 - PATCH_BASE)
mov	x20, x0
cbz	w19, LFQH_LBB201_14
cbnz	x20, LFQH_LBB201_14
LFQH_LBB201_13:
ldp	x29, x30, [sp, #48]
ldp	x20, x19, [sp, #32]
ldp	x22, x21, [sp, #16]
ldp	x24, x23, [sp], #64
ret
LFQH_LBB201_14:
LFQH_Lloh3254:
adr x0, LFQH_l_.str.362
LFQH_Lloh3255:
nop
bl Lpatch + (0xa5a4 - PATCH_BASE)
mov	x1, x0
mov	x0, x21
bl Lpatch + (0xa5d4 - PATCH_BASE)
cbz	w19, LFQH_LBB201_18
fcmp	d0, #0.0
b.ne	LFQH_LBB201_17
LFQH_Lloh3256:
adr x0, LFQH_l_.str.465
LFQH_Lloh3257:
nop
bl Lpatch + (0xa5a4 - PATCH_BASE)
mov	x19, x0
LFQH_Lloh3258:
adr x0, LFQH_l_.str.266
LFQH_Lloh3259:
nop
bl Lpatch + (0xa5a4 - PATCH_BASE)
mov	x1, x0
mov	x0, x20
bl Lpatch + (0xa5d4 - PATCH_BASE)
mov	x0, x21
mov	x1, x19
bl Lpatch + (0xa5d4 - PATCH_BASE)
LFQH_LBB201_17:
LFQH_Lloh3260:
adr x1, LFQH_ReaderBackdropAlphaKey
LFQH_Lloh3261:
nop
mov	x0, x21
mov	x2, #0
mov	w3, #1
ldp	x29, x30, [sp, #48]
ldp	x20, x19, [sp, #32]
ldp	x22, x21, [sp, #16]
ldp	x24, x23, [sp], #64
b Lpatch + (0xa634 - PATCH_BASE)
LFQH_LBB201_18:
fcmp	d0, #0.0
b.le	LFQH_LBB201_13
bl	LFQH_Number
mov	x2, x0
LFQH_Lloh3262:
adr x1, LFQH_ReaderBackdropAlphaKey
LFQH_Lloh3263:
nop
mov	x0, x21
mov	w3, #1
bl Lpatch + (0xa634 - PATCH_BASE)
LFQH_Lloh3264:
adr x0, LFQH_l_.str.465
LFQH_Lloh3265:
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
LFQH_ReaderCommunityBackdrop:
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
mov	x27, x1
mov	x20, x0
LFQH_Lloh3266:
adr x1, LFQH_l_.str.466
LFQH_Lloh3267:
nop
bl	LFQH_Get
mov	x19, x0
LFQH_Lloh3268:
adr x1, LFQH_l_.str.463
LFQH_Lloh3269:
nop
bl	LFQH_Kind
cbz	w0, LFQH_LBB202_17
LFQH_Lloh3270:
adr x1, LFQH_l_.str.248
LFQH_Lloh3271:
nop
mov	x0, x19
bl	LFQH_Get
mov	x23, x0
LFQH_Lloh3272:
adr x1, LFQH_l_.str.467
LFQH_Lloh3273:
nop
mov	x0, x20
bl	LFQH_Get
LFQH_Lloh3274:
adr x1, LFQH_l_.str.468
LFQH_Lloh3275:
nop
bl	LFQH_Get
mov	x24, x0
LFQH_Lloh3276:
adr x22, LFQH_l_.str.20
LFQH_Lloh3277:
nop
mov	x0, x22
bl Lpatch + (0xa5a4 - PATCH_BASE)
mov	x1, x0
mov	x0, x24
bl Lpatch + (0xa5d4 - PATCH_BASE)
mov	x21, x0
mov	x0, x22
bl Lpatch + (0xa5a4 - PATCH_BASE)
mov	x1, x0
mov	x0, x23
bl Lpatch + (0xa5d4 - PATCH_BASE)
mov	x22, x0
LFQH_Lloh3278:
adr x1, LFQH_l_.str.469
LFQH_Lloh3279:
nop
mov	x0, x24
bl	LFQH_Kind
cbz	w0, LFQH_LBB202_13
cmp	x21, x23
ccmp	x22, x19, #0, eq
ccmp	x21, x19, #4, ne
b.ne	LFQH_LBB202_13
LFQH_Lloh3280:
adr x1, LFQH_l_.str.470
LFQH_Lloh3281:
nop
mov	x0, x24
bl	LFQH_Get
mov	x25, x0
LFQH_Lloh3282:
adr x0, LFQH_l_.str.34
LFQH_Lloh3283:
nop
bl Lpatch + (0xa5a4 - PATCH_BASE)
mov	x1, x0
mov	x0, x25
bl Lpatch + (0xa5d4 - PATCH_BASE)
cbz	x0, LFQH_LBB202_13
mov	x26, x0
str	x22, [sp]
str	w27, [sp, #12]
stp	x23, x20, [sp, #16]
mov	x27, #0
mov	w20, #0
LFQH_Lloh3284:
adr x28, LFQH_l_.str.327
LFQH_Lloh3285:
nop
LFQH_Lloh3286:
adr x22, LFQH_l_.str.113
LFQH_Lloh3287:
nop
LFQH_Lloh3288:
adr x21, LFQH_l_.str.20
LFQH_Lloh3289:
nop
LFQH_LBB202_5:
mov	x0, x28
bl Lpatch + (0xa5a4 - PATCH_BASE)
mov	x1, x0
mov	x0, x25
mov	x2, x27
bl Lpatch + (0xa5d4 - PATCH_BASE)
mov	x23, x0
mov	x1, x22
bl	LFQH_Kind
cbz	w0, LFQH_LBB202_8
mov	x0, x21
bl Lpatch + (0xa5a4 - PATCH_BASE)
mov	x1, x0
mov	x0, x23
bl Lpatch + (0xa5d4 - PATCH_BASE)
cmp	x0, x24
b.ne	LFQH_LBB202_8
mov	x0, x23
bl	LFQH_ReaderCommunityGlass
orr	w20, w0, w20
LFQH_LBB202_8:
add	x27, x27, #1
cmp	x26, x27
b.ne	LFQH_LBB202_5
mov	w24, #1
ldr	w8, [sp, #12]
ldr	x22, [sp]
cbnz	w8, LFQH_LBB202_19
tst	w20, #0xff
ldp	x23, x20, [sp, #16]
b.eq	LFQH_LBB202_14
bl	LFQH_Enabled
cbz	w0, LFQH_LBB202_14
bl	LFQH_FQHGlassAvailable
cmp	w0, #0
cset	w24, eq
b	LFQH_LBB202_14
LFQH_LBB202_13:
mov	w24, #1
LFQH_LBB202_14:
mov	x0, x19
mov	x1, x24
bl	LFQH_ReaderBackdropFill
cmp	x22, x19
b.ne	LFQH_LBB202_16
mov	x0, x23
mov	x1, x24
bl	LFQH_ReaderBackdropFill
LFQH_LBB202_16:
LFQH_Lloh3290:
adr x1, LFQH_l_.str.471
LFQH_Lloh3291:
nop
mov	x0, x20
bl	LFQH_Get
mov	x20, x0
LFQH_Lloh3292:
adr x0, LFQH_l_.str.20
LFQH_Lloh3293:
nop
bl Lpatch + (0xa5a4 - PATCH_BASE)
mov	x1, x0
mov	x0, x20
bl Lpatch + (0xa5d4 - PATCH_BASE)
cmp	x0, x19
b.eq	LFQH_LBB202_18
LFQH_LBB202_17:
ldp	x29, x30, [sp, #112]
ldp	x20, x19, [sp, #96]
ldp	x22, x21, [sp, #80]
ldp	x24, x23, [sp, #64]
ldp	x26, x25, [sp, #48]
ldp	x28, x27, [sp, #32]
add	sp, sp, #128
ret
LFQH_LBB202_18:
mov	x0, x20
mov	x1, x24
ldp	x29, x30, [sp, #112]
ldp	x20, x19, [sp, #96]
ldp	x22, x21, [sp, #80]
ldp	x24, x23, [sp, #64]
ldp	x26, x25, [sp, #48]
ldp	x28, x27, [sp, #32]
add	sp, sp, #128
b	LFQH_ReaderBackdropFill
LFQH_LBB202_19:
ldp	x23, x20, [sp, #16]
b	LFQH_LBB202_14
.cfi_endproc
.p2align	2
LFQH_ReaderBackdropColorKey:
.cfi_startproc
ret
.cfi_endproc
.p2align	2
LFQH_ReaderBackdropAppliedKey:
.cfi_startproc
ret
.cfi_endproc
.p2align	2
LFQH_ReaderBackdropAlphaKey:
.cfi_startproc
ret
.cfi_endproc
.p2align	2
LFQH_ReaderCommunityGlass:
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
LFQH_Lloh3294:
adr x1, LFQH_l_.str.441
LFQH_Lloh3295:
nop
bl	LFQH_Get
LFQH_Lloh3296:
adr x1, LFQH_l_.str.335
LFQH_Lloh3297:
nop
bl	LFQH_Get
mov	x20, x0
LFQH_Lloh3298:
adr x1, LFQH_l_.str.472
LFQH_Lloh3299:
nop
bl	LFQH_Equal
tbnz	w0, #0, LFQH_LBB206_2
LFQH_Lloh3300:
adr x1, LFQH_l_.str.473
LFQH_Lloh3301:
nop
mov	x0, x20
bl	LFQH_Equal
cbz	w0, LFQH_LBB206_4
LFQH_LBB206_2:
mov	x0, x19
bl	LFQH_FQHApply
mov	w0, #1
LFQH_LBB206_3:
ldp	x29, x30, [sp, #16]
ldp	x20, x19, [sp], #32
ret
LFQH_LBB206_4:
LFQH_Lloh3302:
adr x1, LFQH_SurfaceKey
LFQH_Lloh3303:
nop
mov	x0, x19
bl Lpatch + (0xa628 - PATCH_BASE)
cbz	x0, LFQH_LBB206_3
mov	x0, x19
bl	LFQH_PageRestore
mov	w0, #0
b	LFQH_LBB206_3
.cfi_endproc
.p2align	2
LFQH_ReaderBottomGlass:
.cfi_startproc
stp	d15, d14, [sp, #-160]!
stp	d13, d12, [sp, #16]
stp	d11, d10, [sp, #32]
stp	d9, d8, [sp, #48]
stp	x28, x27, [sp, #64]
stp	x26, x25, [sp, #80]
stp	x24, x23, [sp, #96]
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
LFQH_Lloh3304:
adr x0, LFQH_l_.str.24
LFQH_Lloh3305:
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
b.ls	LFQH_LBB207_3
LFQH_LBB207_1:
mov	x0, x19
bl	LFQH_PageRestore
LFQH_LBB207_2:
mov	x0, x19
ldp	x29, x30, [sp, #144]
ldp	x20, x19, [sp, #128]
ldp	x22, x21, [sp, #112]
ldp	x24, x23, [sp, #96]
ldp	x26, x25, [sp, #80]
ldp	x28, x27, [sp, #64]
ldp	d9, d8, [sp, #48]
ldp	d11, d10, [sp, #32]
ldp	d13, d12, [sp, #16]
ldp	d15, d14, [sp], #160
b	LFQH_RestoreHit
LFQH_LBB207_3:
mov.16b	v11, v3
fmov	x8, d11
ubfx	x8, x8, #52, #11
cmp	x8, #2046
b.hi	LFQH_LBB207_1
fcmp	d10, #0.0
b.le	LFQH_LBB207_1
fcmp	d11, #0.0
b.le	LFQH_LBB207_1
cbz	x20, LFQH_LBB207_11
mov	x0, x19
bl Lpatch + (0xa664 - PATCH_BASE)
LFQH_Lloh3306:
adr x1, LFQH_l_.str.441
LFQH_Lloh3307:
nop
LFQH_Lloh3308:
adr x2, LFQH_l_.str.11
LFQH_Lloh3309:
nop
bl	LFQH_ClassABI
cbz	w0, LFQH_LBB207_11
LFQH_Lloh3310:
adr x0, LFQH_l_.str.441
LFQH_Lloh3311:
nop
bl Lpatch + (0xa5a4 - PATCH_BASE)
mov	x1, x0
mov	x0, x19
bl Lpatch + (0xa5d4 - PATCH_BASE)
mov	x21, x0
LFQH_Lloh3312:
adr x1, LFQH_l_.str.36
LFQH_Lloh3313:
nop
bl	LFQH_Kind
cbz	w0, LFQH_LBB207_11
LFQH_Lloh3314:
adr x0, LFQH_l_.str.20
LFQH_Lloh3315:
nop
bl Lpatch + (0xa5a4 - PATCH_BASE)
mov	x1, x0
mov	x0, x21
bl Lpatch + (0xa5d4 - PATCH_BASE)
cmp	x0, x19
b.ne	LFQH_LBB207_11
LFQH_Lloh3316:
adr x0, LFQH_l_.str.249
LFQH_Lloh3317:
nop
bl Lpatch + (0xa5a4 - PATCH_BASE)
mov	x1, x0
mov	x0, x21
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
b.ls	LFQH_LBB207_14
LFQH_LBB207_11:
mov	x8, #4634204016564240384
fmov	d12, x8
LFQH_LBB207_12:
fsub	d0, d10, d12
fmov	d1, #0.50000000
fmul	d0, d0, d1
fadd	d13, d8, d0
mov	x8, #-4591419820104220672
fmov	d0, x8
fadd	d0, d11, d0
fmul	d0, d0, d1
fadd	d14, d9, d0
mov	x8, #4631952216750555136
fmov	d15, x8
mov	x0, x19
mov.16b	v0, v13
mov.16b	v1, v14
mov.16b	v2, v12
mov.16b	v3, v15
mov	w1, #0
bl	LFQH_ApplySurface
LFQH_Lloh3318:
adr x1, LFQH_SurfaceKey
LFQH_Lloh3319:
nop
mov	x0, x19
bl Lpatch + (0xa628 - PATCH_BASE)
cbz	x0, LFQH_LBB207_2
mov	x20, x0
mov	x0, x19
mov.16b	v0, v13
mov.16b	v1, v14
mov.16b	v2, v12
mov.16b	v3, v15
bl	LFQH_EnsureHit
LFQH_Lloh3320:
adr x2, LFQH_l_.str.474
LFQH_Lloh3321:
nop
mov	x0, x19
mov	x1, x20
mov.16b	v0, v8
mov.16b	v1, v9
mov.16b	v2, v10
mov.16b	v3, v11
ldp	x29, x30, [sp, #144]
ldp	x20, x19, [sp, #128]
ldp	x22, x21, [sp, #112]
ldp	x24, x23, [sp, #96]
ldp	x26, x25, [sp, #80]
ldp	x28, x27, [sp, #64]
ldp	d9, d8, [sp, #48]
ldp	d11, d10, [sp, #32]
ldp	d13, d12, [sp, #16]
ldp	d15, d14, [sp], #160
b	LFQH_RecordLayout
LFQH_LBB207_14:
fmov	x8, d3
mov	x9, #4634204016564240384
fmov	d12, x9
ubfx	x8, x8, #52, #11
cmp	x8, #2046
b.hi	LFQH_LBB207_12
fcmp	d2, #0.0
b.le	LFQH_LBB207_12
fcmp	d3, #0.0
b.le	LFQH_LBB207_12
fmov	d15, #0.50000000
fmul	d1, d10, d15
fadd	d1, d8, d1
fsub	d3, d1, d0
fadd	d0, d0, d2
fsub	d0, d0, d1
fcmp	d3, d0
fcsel	d0, d3, d0, gt
fmov	d1, #18.00000000
fadd	d14, d0, d1
mov	x8, #4629700416936869888
fmov	d0, x8
fcmp	d14, d0
b.ls	LFQH_LBB207_11
LFQH_Lloh3322:
adr x0, LFQH_l_.str.249
LFQH_Lloh3323:
nop
bl Lpatch + (0xa5a4 - PATCH_BASE)
mov	x1, x0
mov	x0, x19
bl Lpatch + (0xa5d4 - PATCH_BASE)
mov.16b	v12, v0
mov.16b	v13, v2
LFQH_Lloh3324:
adr x0, LFQH_l_.str.24
LFQH_Lloh3325:
nop
bl Lpatch + (0xa5a4 - PATCH_BASE)
mov	x1, x0
mov	x0, x20
bl Lpatch + (0xa5d4 - PATCH_BASE)
fmul	d1, d13, d15
fadd	d13, d12, d1
fsub	d1, d13, d0
fmov	d3, #-8.00000000
fadd	d1, d1, d3
fadd	d0, d0, d2
fsub	d0, d0, d13
fadd	d0, d0, d3
fcmp	d1, d14
fcsel	d1, d1, d14, mi
fcmp	d0, d1
fcsel	d12, d0, d1, mi
LFQH_Lloh3326:
adr x1, LFQH_l_.str.470
LFQH_Lloh3327:
nop
mov	x0, x20
bl	LFQH_Get
mov	x21, x0
LFQH_Lloh3328:
adr x0, LFQH_l_.str.34
LFQH_Lloh3329:
nop
bl Lpatch + (0xa5a4 - PATCH_BASE)
mov	x1, x0
mov	x0, x21
bl Lpatch + (0xa5d4 - PATCH_BASE)
mov	x8, #4629700416936869888
fmov	d0, x8
fcmp	d12, d0
cset	w8, gt
cbz	x0, LFQH_LBB207_27
mov	x9, #4629700416936869888
fmov	d0, x9
fcmp	d12, d0
b.le	LFQH_LBB207_27
mov	x22, x0
mov	w28, #1
LFQH_Lloh3330:
adr x23, LFQH_l_.str.327
LFQH_Lloh3331:
nop
mov	x8, #4629700416936869888
fmov	d14, x8
LFQH_Lloh3332:
adr x24, LFQH_l_.str.20
LFQH_Lloh3333:
nop
LFQH_Lloh3334:
adr x25, LFQH_l_.str.292
LFQH_Lloh3335:
nop
mov	x8, #4634204016564240384
fmov	d15, x8
LFQH_Lloh3336:
adr x26, LFQH_l_.str.249
LFQH_Lloh3337:
nop
LFQH_LBB207_21:
mov	x0, x23
bl Lpatch + (0xa5a4 - PATCH_BASE)
mov	x1, x0
sub	x2, x28, #1
mov	x0, x21
bl Lpatch + (0xa5d4 - PATCH_BASE)
cmp	x0, x19
b.eq	LFQH_LBB207_25
mov	x27, x0
mov	x0, x24
bl Lpatch + (0xa5a4 - PATCH_BASE)
mov	x1, x0
mov	x0, x27
bl Lpatch + (0xa5d4 - PATCH_BASE)
cmp	x0, x20
b.ne	LFQH_LBB207_25
mov	x0, x25
bl Lpatch + (0xa5a4 - PATCH_BASE)
mov	x1, x0
mov	x0, x27
bl Lpatch + (0xa5d4 - PATCH_BASE)
cbnz	w0, LFQH_LBB207_25
mov	x0, x26
bl Lpatch + (0xa5a4 - PATCH_BASE)
mov	x1, x0
mov	x0, x27
bl Lpatch + (0xa5d4 - PATCH_BASE)
fmov	d1, #0.50000000
fmul	d1, d2, d1
fcmp	d2, d15
fcsel	d2, d1, d14, gt
fadd	d0, d0, d1
fabd	d0, d13, d0
fsub	d0, d0, d2
fmov	d1, #-8.00000000
fadd	d0, d0, d1
fcmp	d0, d12
fcsel	d12, d0, d12, mi
LFQH_LBB207_25:
fcmp	d12, d14
cset	w8, gt
cmp	x28, x22
b.hs	LFQH_LBB207_27
add	x28, x28, #1
fcmp	d12, d14
b.gt	LFQH_LBB207_21
LFQH_LBB207_27:
fadd	d0, d12, d12
cmp	w8, #0
mov	x8, #4634204016564240384
fmov	d1, x8
fcsel	d12, d0, d1, ne
b	LFQH_LBB207_12
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
LFQH_Lloh3338:
adr x0, LFQH_l_.str.413
LFQH_Lloh3339:
nop
bl Lpatch + (0xa5a4 - PATCH_BASE)
mov	x1, x0
mov	x0, x19
bl Lpatch + (0xa5d4 - PATCH_BASE)
cmp	x0, #3
b.ne	LFQH_LBB209_4
LFQH_Lloh3340:
adr x0, LFQH_l_.str.404
LFQH_Lloh3341:
nop
bl Lpatch + (0xa5a4 - PATCH_BASE)
mov	x1, x0
mov	x0, x19
bl Lpatch + (0xa5d4 - PATCH_BASE)
mov	x20, x0
LFQH_Lloh3342:
adr x1, LFQH_SurfaceKey
LFQH_Lloh3343:
nop
bl Lpatch + (0xa628 - PATCH_BASE)
cbz	x0, LFQH_LBB209_4
mov	x0, x20
bl	LFQH_ReaderBottomType
cmp	w0, #1
b.ne	LFQH_LBB209_4
LFQH_Lloh3344:
adr x0, LFQH_l_.str.475
LFQH_Lloh3345:
nop
bl Lpatch + (0xa5a4 - PATCH_BASE)
mov	x1, x0
mov	x0, x20
mov	x2, x19
ldp	x29, x30, [sp, #16]
ldp	x20, x19, [sp], #32
b Lpatch + (0xa5d4 - PATCH_BASE)
LFQH_LBB209_4:
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
LFQH_Lloh3346:
adr x0, LFQH_l_.str.404
LFQH_Lloh3347:
nop
bl Lpatch + (0xa5a4 - PATCH_BASE)
mov	x1, x0
mov	x0, x20
bl Lpatch + (0xa5d4 - PATCH_BASE)
mov	x21, x0
LFQH_Lloh3348:
adr x1, LFQH_SurfaceKey
LFQH_Lloh3349:
nop
bl Lpatch + (0xa628 - PATCH_BASE)
cbz	x0, LFQH_LBB210_4
mov	x20, x0
LFQH_Lloh3350:
adr x0, LFQH_l_.str.404
LFQH_Lloh3351:
nop
bl Lpatch + (0xa5a4 - PATCH_BASE)
mov	x1, x0
mov	x0, x19
bl Lpatch + (0xa5d4 - PATCH_BASE)
cmp	x0, x21
b.eq	LFQH_LBB210_3
mov	w0, #0
b	LFQH_LBB210_4
LFQH_LBB210_3:
LFQH_Lloh3352:
adr x0, LFQH_l_.str.418
LFQH_Lloh3353:
nop
bl Lpatch + (0xa5a4 - PATCH_BASE)
mov	x1, x0
mov	x0, x19
mov	x2, x21
bl Lpatch + (0xa5d4 - PATCH_BASE)
mov.16b	v8, v0
mov.16b	v9, v1
LFQH_Lloh3354:
adr x0, LFQH_l_.str.249
LFQH_Lloh3355:
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
LFQH_LBB210_4:
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
LFQH_Lloh3356:
adr x1, LFQH_l_.str.480
LFQH_Lloh3357:
nop
bl	LFQH_Get
mov	x21, x0
LFQH_Lloh3358:
adr x1, LFQH_l_.str.481
LFQH_Lloh3359:
nop
mov	x0, x19
bl	LFQH_Get
mov	x20, x0
LFQH_Lloh3360:
adr x1, LFQH_l_.str.290
LFQH_Lloh3361:
nop
mov	x0, x21
bl	LFQH_Kind
cbz	w0, LFQH_LBB211_3
LFQH_Lloh3362:
adr x0, LFQH_l_.str.20
LFQH_Lloh3363:
nop
bl Lpatch + (0xa5a4 - PATCH_BASE)
mov	x1, x0
mov	x0, x21
bl Lpatch + (0xa5d4 - PATCH_BASE)
cmp	x0, x19
b.ne	LFQH_LBB211_3
mov	x0, x21
mov	w1, #7
bl	LFQH_Icon
LFQH_LBB211_3:
LFQH_Lloh3364:
adr x1, LFQH_l_.str.290
LFQH_Lloh3365:
nop
mov	x0, x20
bl	LFQH_Kind
cbz	w0, LFQH_LBB211_6
LFQH_Lloh3366:
adr x0, LFQH_l_.str.20
LFQH_Lloh3367:
nop
bl Lpatch + (0xa5a4 - PATCH_BASE)
mov	x1, x0
mov	x0, x20
bl Lpatch + (0xa5d4 - PATCH_BASE)
cmp	x0, x19
b.ne	LFQH_LBB211_6
mov	x0, x20
mov	w1, #7
bl	LFQH_Icon
LFQH_LBB211_6:
LFQH_Lloh3368:
adr x1, LFQH_l_.str.482
LFQH_Lloh3369:
nop
mov	x0, x19
bl	LFQH_Get
mov	x20, x0
LFQH_Lloh3370:
adr x1, LFQH_l_.str.483
LFQH_Lloh3371:
nop
bl	LFQH_Kind
cbz	w0, LFQH_LBB211_12
LFQH_Lloh3372:
adr x1, LFQH_l_.str.484
LFQH_Lloh3373:
nop
mov	x0, x20
bl	LFQH_Get
mov	x19, x0
LFQH_Lloh3374:
adr x1, LFQH_l_.str.485
LFQH_Lloh3375:
nop
bl	LFQH_Kind
cbz	w0, LFQH_LBB211_9
LFQH_Lloh3376:
adr x0, LFQH_l_.str.20
LFQH_Lloh3377:
nop
bl Lpatch + (0xa5a4 - PATCH_BASE)
mov	x1, x0
mov	x0, x19
bl Lpatch + (0xa5d4 - PATCH_BASE)
cmp	x0, x20
b.eq	LFQH_LBB211_10
LFQH_LBB211_9:
mov	x0, x20
mov	w1, #0
ldp	x29, x30, [sp, #32]
ldp	x20, x19, [sp, #16]
ldp	x22, x21, [sp], #48
b	LFQH_ReaderProgressFill
LFQH_LBB211_10:
mov	x0, x19
bl	LFQH_FQHApply
LFQH_Lloh3378:
adr x1, LFQH_SurfaceKey
LFQH_Lloh3379:
nop
mov	x0, x19
bl Lpatch + (0xa628 - PATCH_BASE)
mov	x21, x0
cmp	x0, #0
cset	w1, ne
mov	x0, x20
bl	LFQH_ReaderProgressFill
cbz	x21, LFQH_LBB211_12
LFQH_Lloh3380:
adr x0, LFQH_l_.str.24
LFQH_Lloh3381:
nop
bl Lpatch + (0xa5a4 - PATCH_BASE)
mov	x1, x0
mov	x0, x19
bl Lpatch + (0xa5d4 - PATCH_BASE)
LFQH_Lloh3382:
adr x2, LFQH_l_.str.486
LFQH_Lloh3383:
nop
mov	x0, x19
mov	x1, x21
ldp	x29, x30, [sp, #32]
ldp	x20, x19, [sp, #16]
ldp	x22, x21, [sp], #48
b	LFQH_RecordLayout
LFQH_LBB211_12:
ldp	x29, x30, [sp, #32]
ldp	x20, x19, [sp, #16]
ldp	x22, x21, [sp], #48
ret
.cfi_endproc
.p2align	2
LFQH_ReaderProgressFill:
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
mov	x23, x1
mov	x20, x0
LFQH_Lloh3384:
adr x1, LFQH_l_.str.487
LFQH_Lloh3385:
nop
bl	LFQH_Get
mov	x19, x0
LFQH_Lloh3386:
adr x1, LFQH_l_.str.485
LFQH_Lloh3387:
nop
bl	LFQH_Kind
cbz	w0, LFQH_LBB212_4
LFQH_Lloh3388:
adr x0, LFQH_l_.str.20
LFQH_Lloh3389:
nop
bl Lpatch + (0xa5a4 - PATCH_BASE)
mov	x1, x0
mov	x0, x19
bl Lpatch + (0xa5d4 - PATCH_BASE)
cmp	x0, x20
b.ne	LFQH_LBB212_4
LFQH_Lloh3390:
adr x1, LFQH_ReaderProgressColorKey
LFQH_Lloh3391:
nop
mov	x0, x19
bl Lpatch + (0xa628 - PATCH_BASE)
mov	x20, x0
cbnz	w23, LFQH_LBB212_5
cbnz	x20, LFQH_LBB212_5
LFQH_LBB212_4:
ldp	x29, x30, [sp, #48]
ldp	x20, x19, [sp, #32]
ldp	x22, x21, [sp, #16]
ldp	x24, x23, [sp], #64
ret
LFQH_LBB212_5:
LFQH_Lloh3392:
adr x0, LFQH_l_.str.250
LFQH_Lloh3393:
nop
bl Lpatch + (0xa5a4 - PATCH_BASE)
mov	x1, x0
mov	x0, x19
bl Lpatch + (0xa5d4 - PATCH_BASE)
mov	x21, x0
LFQH_Lloh3394:
adr x1, LFQH_ReaderProgressStockKey
LFQH_Lloh3395:
nop
mov	x0, x19
bl Lpatch + (0xa628 - PATCH_BASE)
mov	x22, x0
cbz	w23, LFQH_LBB212_12
cmp	x21, x20
b.eq	LFQH_LBB212_4
LFQH_Lloh3396:
adr x0, LFQH_l_.str.48
LFQH_Lloh3397:
nop
bl Lpatch + (0xa5a4 - PATCH_BASE)
mov	x1, x0
mov	x0, x21
mov	x2, x20
bl Lpatch + (0xa5d4 - PATCH_BASE)
cbnz	w0, LFQH_LBB212_4
cbz	x21, LFQH_LBB212_11
LFQH_Lloh3398:
adr x0, LFQH_l_.str.46
LFQH_Lloh3399:
nop
bl Lpatch + (0xa5b0 - PATCH_BASE)
mov	x23, x0
LFQH_Lloh3400:
adr x0, LFQH_l_.str.80
LFQH_Lloh3401:
nop
bl Lpatch + (0xa5a4 - PATCH_BASE)
mov	x1, x0
mov	x0, x23
bl Lpatch + (0xa5d4 - PATCH_BASE)
cmp	x21, x0
b.eq	LFQH_LBB212_11
mov	x23, x0
LFQH_Lloh3402:
adr x0, LFQH_l_.str.48
LFQH_Lloh3403:
nop
bl Lpatch + (0xa5a4 - PATCH_BASE)
mov	x1, x0
mov	x0, x21
mov	x2, x23
bl Lpatch + (0xa5d4 - PATCH_BASE)
cbz	w0, LFQH_LBB212_17
LFQH_LBB212_11:
cbz	x20, LFQH_LBB212_4
b	LFQH_LBB212_16
LFQH_LBB212_12:
cbz	x20, LFQH_LBB212_4
cmp	x21, x20
b.eq	LFQH_LBB212_15
LFQH_Lloh3404:
adr x0, LFQH_l_.str.48
LFQH_Lloh3405:
nop
bl Lpatch + (0xa5a4 - PATCH_BASE)
mov	x1, x0
mov	x0, x21
mov	x2, x20
bl Lpatch + (0xa5d4 - PATCH_BASE)
cbz	w0, LFQH_LBB212_16
LFQH_LBB212_15:
LFQH_Lloh3406:
adr x0, LFQH_l_.str.79
LFQH_Lloh3407:
nop
bl Lpatch + (0xa5a4 - PATCH_BASE)
mov	x1, x0
mov	x0, x19
mov	x2, x22
bl Lpatch + (0xa5d4 - PATCH_BASE)
LFQH_LBB212_16:
LFQH_Lloh3408:
adr x1, LFQH_ReaderProgressStockKey
LFQH_Lloh3409:
nop
mov	x0, x19
mov	x2, #0
mov	w3, #1
bl Lpatch + (0xa634 - PATCH_BASE)
LFQH_Lloh3410:
adr x1, LFQH_ReaderProgressColorKey
LFQH_Lloh3411:
nop
mov	x0, x19
mov	x2, #0
mov	w3, #1
ldp	x29, x30, [sp, #48]
ldp	x20, x19, [sp, #32]
ldp	x22, x21, [sp, #16]
ldp	x24, x23, [sp], #64
b Lpatch + (0xa634 - PATCH_BASE)
LFQH_LBB212_17:
cbz	x20, LFQH_LBB212_20
cmp	x21, x22
b.eq	LFQH_LBB212_22
LFQH_Lloh3412:
adr x0, LFQH_l_.str.48
LFQH_Lloh3413:
nop
bl Lpatch + (0xa5a4 - PATCH_BASE)
mov	x1, x0
mov	x0, x21
mov	x2, x22
bl Lpatch + (0xa5d4 - PATCH_BASE)
cbnz	w0, LFQH_LBB212_22
LFQH_LBB212_20:
LFQH_Lloh3414:
adr x0, LFQH_l_.str.50
LFQH_Lloh3415:
nop
bl Lpatch + (0xa5a4 - PATCH_BASE)
mov	x1, x0
fmov	d0, #0.15625000
mov	x0, x21
bl Lpatch + (0xa5d4 - PATCH_BASE)
cbz	x0, LFQH_LBB212_4
mov	x20, x0
LFQH_Lloh3416:
adr x1, LFQH_ReaderProgressStockKey
LFQH_Lloh3417:
nop
mov	x0, x19
mov	x2, x21
mov	w3, #1
bl Lpatch + (0xa634 - PATCH_BASE)
LFQH_Lloh3418:
adr x1, LFQH_ReaderProgressColorKey
LFQH_Lloh3419:
nop
mov	x0, x19
mov	x2, x20
mov	w3, #1
bl Lpatch + (0xa634 - PATCH_BASE)
LFQH_LBB212_22:
LFQH_Lloh3420:
adr x0, LFQH_l_.str.79
LFQH_Lloh3421:
nop
bl Lpatch + (0xa5a4 - PATCH_BASE)
mov	x1, x0
mov	x0, x19
mov	x2, x20
ldp	x29, x30, [sp, #48]
ldp	x20, x19, [sp, #32]
ldp	x22, x21, [sp, #16]
ldp	x24, x23, [sp], #64
b Lpatch + (0xa5d4 - PATCH_BASE)
.cfi_endproc
.p2align	2
LFQH_ReaderProgressColorKey:
.cfi_startproc
ret
.cfi_endproc
.p2align	2
LFQH_ReaderProgressStockKey:
.cfi_startproc
ret
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
LFQH_Lloh3422:
adr x1, LFQH_l_.str.20
LFQH_Lloh3423:
nop
bl	LFQH_Get
cbz	x0, LFQH_LBB215_5
mov	x20, x0
mov	w24, #0
LFQH_Lloh3424:
adr x21, LFQH_l_.str.247
LFQH_Lloh3425:
nop
LFQH_Lloh3426:
adr x22, LFQH_l_.str.20
LFQH_Lloh3427:
nop
LFQH_LBB215_2:
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
cbnz	w0, LFQH_LBB215_6
mov	x0, x20
mov	x1, x22
bl	LFQH_Get
cbz	x0, LFQH_LBB215_6
mov	x20, x0
cmp	w24, #4
add	w24, w24, #1
b.lo	LFQH_LBB215_2
b	LFQH_LBB215_6
LFQH_LBB215_5:
mov	w23, #0
LFQH_LBB215_6:
mov	x0, x23
ldp	x29, x30, [sp, #48]
ldp	x20, x19, [sp, #32]
ldp	x22, x21, [sp, #16]
ldp	x24, x23, [sp], #64
ret
.cfi_endproc
.p2align	2
LFQH_CoverGuideGlass:
.cfi_startproc
sub	sp, sp, #128
stp	d9, d8, [sp, #16]
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
.cfi_offset b8, -104
.cfi_offset b9, -112
mov	x19, x0
bl Lpatch + (0xa664 - PATCH_BASE)
mov	x20, x0
LFQH_Lloh3428:
adr x0, LFQH_l_.str.23
LFQH_Lloh3429:
nop
bl Lpatch + (0xa5b0 - PATCH_BASE)
cmp	x20, x0
b.ne	LFQH_LBB216_17
LFQH_Lloh3430:
adr x0, LFQH_l_.str.279
LFQH_Lloh3431:
nop
bl Lpatch + (0xa5a4 - PATCH_BASE)
mov	x1, x0
str	x19, [sp, #8]
mov	x0, x19
bl Lpatch + (0xa5d4 - PATCH_BASE)
mov	x20, x0
LFQH_Lloh3432:
adr x0, LFQH_l_.str.34
LFQH_Lloh3433:
nop
bl Lpatch + (0xa5a4 - PATCH_BASE)
mov	x1, x0
mov	x0, x20
bl Lpatch + (0xa5d4 - PATCH_BASE)
cbz	x0, LFQH_LBB216_11
mov	x21, x0
mov	x28, #0
mov	w19, #1
LFQH_Lloh3434:
adr x22, LFQH_l_.str.327
LFQH_Lloh3435:
nop
LFQH_Lloh3436:
adr x23, LFQH_l_.str.36
LFQH_Lloh3437:
nop
LFQH_Lloh3438:
adr x24, LFQH_l_.str.335
LFQH_Lloh3439:
nop
LFQH_Lloh3440:
adr x25, LFQH_l_.str.492
LFQH_Lloh3441:
nop
LFQH_Lloh3442:
adr x26, LFQH_l_.str.493
LFQH_Lloh3443:
nop
LFQH_LBB216_3:
mov	x0, x22
bl Lpatch + (0xa5a4 - PATCH_BASE)
mov	x1, x0
sub	x2, x19, #1
mov	x0, x20
bl Lpatch + (0xa5d4 - PATCH_BASE)
mov	x27, x0
mov	x1, x23
bl	LFQH_Kind
cbz	w0, LFQH_LBB216_7
mov	x0, x24
bl Lpatch + (0xa5a4 - PATCH_BASE)
mov	x1, x0
mov	x0, x27
bl Lpatch + (0xa5d4 - PATCH_BASE)
mov	x27, x0
mov	x1, x25
bl	LFQH_Equal
tbnz	w0, #0, LFQH_LBB216_10
mov	x0, x27
mov	x1, x26
bl	LFQH_Equal
cmp	x19, x21
b.hs	LFQH_LBB216_9
tbnz	w0, #0, LFQH_LBB216_9
b	LFQH_LBB216_8
LFQH_LBB216_7:
cmp	x19, x21
b.hs	LFQH_LBB216_11
LFQH_LBB216_8:
add	x28, x28, #1
add	x19, x19, #1
b	LFQH_LBB216_3
LFQH_LBB216_9:
cbz	w0, LFQH_LBB216_11
LFQH_LBB216_10:
LFQH_Lloh3444:
adr x0, LFQH_l_.str.292
LFQH_Lloh3445:
nop
bl Lpatch + (0xa5a4 - PATCH_BASE)
mov	x1, x0
ldr	x0, [sp, #8]
bl Lpatch + (0xa5d4 - PATCH_BASE)
cbz	w0, LFQH_LBB216_13
LFQH_LBB216_11:
LFQH_Lloh3446:
adr x1, LFQH_SurfaceKey
LFQH_Lloh3447:
nop
ldr	x19, [sp, #8]
mov	x0, x19
bl Lpatch + (0xa628 - PATCH_BASE)
cbz	x0, LFQH_LBB216_14
mov	x0, x19
bl	LFQH_PageRestore
b	LFQH_LBB216_14
LFQH_LBB216_13:
ldr	x19, [sp, #8]
mov	x0, x19
bl	LFQH_FQHApply
LFQH_LBB216_14:
LFQH_Lloh3448:
adr x1, LFQH_CoverGuideBorderKey
LFQH_Lloh3449:
nop
mov	x0, x19
bl Lpatch + (0xa628 - PATCH_BASE)
mov	x21, x0
LFQH_Lloh3450:
adr x1, LFQH_SurfaceKey
LFQH_Lloh3451:
nop
mov	x0, x19
bl Lpatch + (0xa628 - PATCH_BASE)
orr	x8, x0, x21
cbz	x8, LFQH_LBB216_17
mov	x22, x0
LFQH_Lloh3452:
adr x0, LFQH_l_.str.263
LFQH_Lloh3453:
nop
bl Lpatch + (0xa5a4 - PATCH_BASE)
mov	x1, x0
mov	x0, x19
bl Lpatch + (0xa5d4 - PATCH_BASE)
mov	x20, x0
LFQH_Lloh3454:
adr x0, LFQH_l_.str.494
LFQH_Lloh3455:
nop
bl Lpatch + (0xa5a4 - PATCH_BASE)
mov	x1, x0
mov	x0, x20
bl Lpatch + (0xa5d4 - PATCH_BASE)
mov.16b	v8, v0
cbz	x22, LFQH_LBB216_18
fcmp	d8, #0.0
b.ne	LFQH_LBB216_21
LFQH_LBB216_17:
ldp	x29, x30, [sp, #112]
ldp	x20, x19, [sp, #96]
ldp	x22, x21, [sp, #80]
ldp	x24, x23, [sp, #64]
ldp	x26, x25, [sp, #48]
ldp	x28, x27, [sp, #32]
ldp	d9, d8, [sp, #16]
add	sp, sp, #128
ret
LFQH_LBB216_18:
fcmp	d8, #0.0
b.ne	LFQH_LBB216_20
LFQH_Lloh3456:
adr x0, LFQH_l_.str.495
LFQH_Lloh3457:
nop
bl Lpatch + (0xa5a4 - PATCH_BASE)
mov	x22, x0
LFQH_Lloh3458:
adr x0, LFQH_l_.str.266
LFQH_Lloh3459:
nop
bl Lpatch + (0xa5a4 - PATCH_BASE)
mov	x1, x0
mov	x0, x21
bl Lpatch + (0xa5d4 - PATCH_BASE)
mov	x0, x20
mov	x1, x22
bl Lpatch + (0xa5d4 - PATCH_BASE)
LFQH_LBB216_20:
LFQH_Lloh3460:
adr x1, LFQH_CoverGuideBorderKey
LFQH_Lloh3461:
nop
mov	x0, x19
mov	x2, #0
mov	w3, #1
ldp	x29, x30, [sp, #112]
ldp	x20, x19, [sp, #96]
ldp	x22, x21, [sp, #80]
ldp	x24, x23, [sp, #64]
ldp	x26, x25, [sp, #48]
ldp	x28, x27, [sp, #32]
ldp	d9, d8, [sp, #16]
add	sp, sp, #128
b Lpatch + (0xa634 - PATCH_BASE)
LFQH_LBB216_21:
LFQH_Lloh3462:
adr x0, LFQH_l_.str.267
LFQH_Lloh3463:
nop
bl Lpatch + (0xa5b0 - PATCH_BASE)
mov	x21, x0
LFQH_Lloh3464:
adr x0, LFQH_l_.str.268
LFQH_Lloh3465:
nop
bl Lpatch + (0xa5a4 - PATCH_BASE)
mov	x1, x0
mov	x0, x21
mov.16b	v0, v8
bl Lpatch + (0xa5d4 - PATCH_BASE)
mov	x2, x0
LFQH_Lloh3466:
adr x1, LFQH_CoverGuideBorderKey
LFQH_Lloh3467:
nop
mov	x0, x19
mov	w3, #1
bl Lpatch + (0xa634 - PATCH_BASE)
LFQH_Lloh3468:
adr x0, LFQH_l_.str.495
LFQH_Lloh3469:
nop
bl Lpatch + (0xa5a4 - PATCH_BASE)
mov	x1, x0
fmov	d0, xzr
mov	x0, x20
ldp	x29, x30, [sp, #112]
ldp	x20, x19, [sp, #96]
ldp	x22, x21, [sp, #80]
ldp	x24, x23, [sp, #64]
ldp	x26, x25, [sp, #48]
ldp	x28, x27, [sp, #32]
ldp	d9, d8, [sp, #16]
add	sp, sp, #128
b Lpatch + (0xa5d4 - PATCH_BASE)
.cfi_endproc
.p2align	2
LFQH_CoverGuideBorderKey:
.cfi_startproc
ret
.cfi_endproc
.p2align	2
LFQH_ChapterEntranceOnly:
.cfi_startproc
stp	x20, x19, [sp, #-32]!
stp	x29, x30, [sp, #16]
add	x29, sp, #16
.cfi_def_cfa w29, 16
.cfi_offset w30, -8
.cfi_offset w29, -16
.cfi_offset w19, -24
.cfi_offset w20, -32
LFQH_Lloh3470:
adr x1, LFQH_l_.str.496
LFQH_Lloh3471:
nop
bl	LFQH_Get
mov	x19, x0
bl Lpatch + (0xa664 - PATCH_BASE)
LFQH_Lloh3472:
adr x1, LFQH_l_.str.497
LFQH_Lloh3473:
nop
LFQH_Lloh3474:
adr x2, LFQH_l_.str.498
LFQH_Lloh3475:
nop
bl	LFQH_ClassABI
cbz	w0, LFQH_LBB218_2
LFQH_Lloh3476:
adr x0, LFQH_l_.str.497
LFQH_Lloh3477:
nop
bl Lpatch + (0xa5a4 - PATCH_BASE)
mov	x1, x0
mov	x0, x19
bl Lpatch + (0xa5d4 - PATCH_BASE)
cmp	x0, #1
cset	w0, eq
LFQH_LBB218_2:
ldp	x29, x30, [sp, #16]
ldp	x20, x19, [sp], #32
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
LFQH_Lloh3478:
adr x1, LFQH_ChapterDiscussionKey
LFQH_Lloh3479:
nop
bl Lpatch + (0xa628 - PATCH_BASE)
mov	x20, x0
LFQH_Lloh3480:
adr x1, LFQH_l_.str.499
LFQH_Lloh3481:
nop
mov	x0, x19
bl	LFQH_Get
mov	x21, x0
LFQH_Lloh3482:
adr x1, LFQH_l_.str.134
LFQH_Lloh3483:
nop
bl	LFQH_Kind
cbz	w0, LFQH_LBB219_3
mov	x0, x19
bl	LFQH_ChapterEntranceOnly
cbz	w0, LFQH_LBB219_3
LFQH_Lloh3484:
adr x0, LFQH_l_.str.292
LFQH_Lloh3485:
nop
bl Lpatch + (0xa5a4 - PATCH_BASE)
mov	x1, x0
mov	x0, x21
bl Lpatch + (0xa5d4 - PATCH_BASE)
cmp	w0, #0
cset	w23, eq
b	LFQH_LBB219_4
LFQH_LBB219_3:
mov	w23, #0
LFQH_LBB219_4:
cmp	x20, #0
csinc	w8, w23, wzr, eq
cbz	w8, LFQH_LBB219_12
LFQH_Lloh3486:
adr x1, LFQH_l_.str.500
LFQH_Lloh3487:
nop
mov	x0, x19
bl	LFQH_Get
mov	x22, x0
cbz	w23, LFQH_LBB219_8
LFQH_Lloh3488:
adr x1, LFQH_l_.str.20
LFQH_Lloh3489:
nop
mov	x0, x21
bl	LFQH_Get
cmp	x0, x22
b.ne	LFQH_LBB219_8
LFQH_Lloh3490:
adr x1, LFQH_l_.str.20
LFQH_Lloh3491:
nop
mov	x0, x22
bl	LFQH_Get
cmp	x0, x19
b.eq	LFQH_LBB219_13
LFQH_LBB219_8:
mov	x0, x22
bl	LFQH_PageRestore
LFQH_LBB219_9:
mov	x21, #0
LFQH_LBB219_10:
cmp	x20, x21
b.eq	LFQH_LBB219_12
mov	x0, x20
bl	LFQH_RestoreHit
LFQH_Lloh3492:
adr x1, LFQH_ChapterDiscussionKey
LFQH_Lloh3493:
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
LFQH_LBB219_12:
ldp	x29, x30, [sp, #80]
ldp	x20, x19, [sp, #64]
ldp	x22, x21, [sp, #48]
ldp	x24, x23, [sp, #32]
ldp	d9, d8, [sp, #16]
ldp	d11, d10, [sp], #96
ret
LFQH_LBB219_13:
LFQH_Lloh3494:
adr x1, LFQH_SurfaceKey
LFQH_Lloh3495:
nop
mov	x0, x21
bl Lpatch + (0xa628 - PATCH_BASE)
cbz	x0, LFQH_LBB219_15
mov	x0, x21
bl	LFQH_PageRestore
LFQH_LBB219_15:
mov	x0, x22
bl	LFQH_FQHApply
LFQH_Lloh3496:
adr x1, LFQH_SurfaceKey
LFQH_Lloh3497:
nop
mov	x0, x22
bl Lpatch + (0xa628 - PATCH_BASE)
cbz	x0, LFQH_LBB219_9
LFQH_Lloh3498:
adr x0, LFQH_l_.str.24
LFQH_Lloh3499:
nop
bl Lpatch + (0xa5a4 - PATCH_BASE)
mov	x1, x0
mov	x0, x22
bl Lpatch + (0xa5d4 - PATCH_BASE)
mov.16b	v8, v0
mov.16b	v9, v1
mov.16b	v10, v2
mov.16b	v11, v3
LFQH_Lloh3500:
adr x0, LFQH_l_.str.303
LFQH_Lloh3501:
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
b	LFQH_LBB219_10
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
mov	x19, x0
LFQH_Lloh3502:
adr x1, LFQH_l_.str.20
LFQH_Lloh3503:
nop
bl	LFQH_Get
mov	x21, x0
LFQH_Lloh3504:
adr x1, LFQH_l_.str.501
LFQH_Lloh3505:
nop
mov	x0, x19
bl	LFQH_Get
mov	x20, x0
LFQH_Lloh3506:
adr x1, LFQH_l_.str.138
LFQH_Lloh3507:
nop
mov	x0, x21
bl	LFQH_Kind
tbnz	w0, #0, LFQH_LBB221_2
LFQH_Lloh3508:
adr x1, LFQH_l_.str.502
LFQH_Lloh3509:
nop
mov	x0, x21
bl	LFQH_Kind
cbz	w0, LFQH_LBB221_4
LFQH_LBB221_2:
LFQH_Lloh3510:
adr x1, LFQH_l_.str.20
LFQH_Lloh3511:
nop
mov	x0, x20
bl	LFQH_Get
cmp	x0, x19
b.ne	LFQH_LBB221_4
LFQH_Lloh3512:
adr x0, LFQH_l_.str.292
LFQH_Lloh3513:
nop
bl Lpatch + (0xa5a4 - PATCH_BASE)
mov	x1, x0
mov	x0, x19
bl Lpatch + (0xa5d4 - PATCH_BASE)
cbz	w0, LFQH_LBB221_9
LFQH_LBB221_4:
LFQH_Lloh3514:
adr x1, LFQH_SurfaceKey
LFQH_Lloh3515:
nop
mov	x0, x20
bl Lpatch + (0xa628 - PATCH_BASE)
cbz	x0, LFQH_LBB221_6
mov	x0, x20
bl	LFQH_PageRestore
LFQH_LBB221_6:
LFQH_Lloh3516:
adr x1, LFQH_SurfaceKey
LFQH_Lloh3517:
nop
mov	x0, x20
bl Lpatch + (0xa628 - PATCH_BASE)
cbz	x0, LFQH_LBB221_8
LFQH_Lloh3518:
adr x0, LFQH_l_.str.251
LFQH_Lloh3519:
nop
bl Lpatch + (0xa5a4 - PATCH_BASE)
mov	x1, x0
mov	x0, x19
bl Lpatch + (0xa5d4 - PATCH_BASE)
mov	x20, x0
LFQH_Lloh3520:
adr x0, LFQH_l_.str.252
LFQH_Lloh3521:
nop
bl Lpatch + (0xa5a4 - PATCH_BASE)
mov	x1, x0
mov	x0, x19
bl Lpatch + (0xa5d4 - PATCH_BASE)
mov	x2, x0
mov	x0, x19
mov	x1, x20
ldp	x29, x30, [sp, #32]
ldp	x20, x19, [sp, #16]
ldp	x22, x21, [sp], #48
b	LFQH_PrepareOwner
LFQH_LBB221_8:
mov	x0, x19
ldp	x29, x30, [sp, #32]
ldp	x20, x19, [sp, #16]
ldp	x22, x21, [sp], #48
b	LFQH_RestoreOwner
LFQH_LBB221_9:
mov	x0, x20
bl	LFQH_FQHApply
b	LFQH_LBB221_6
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
LFQH_Lloh3522:
adr x1, LFQH_l_.str.157
LFQH_Lloh3523:
nop
bl	LFQH_HasAncestor
cbz	w0, LFQH_LBB222_3
LFQH_Lloh3524:
adr x1, LFQH_l_.str.63
LFQH_Lloh3525:
nop
mov	x0, x19
bl	LFQH_HasAncestor
tbz	w0, #0, LFQH_LBB222_3
LFQH_Lloh3526:
adr x0, LFQH_l_.str.24
LFQH_Lloh3527:
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
LFQH_Lloh3528:
adr x1, LFQH_SurfaceKey
LFQH_Lloh3529:
nop
mov	x0, x19
bl Lpatch + (0xa628 - PATCH_BASE)
mov	x20, x0
LFQH_Lloh3530:
adr x1, LFQH_l_.str.503
LFQH_Lloh3531:
nop
mov	x0, x19
bl	LFQH_BoolProp
mov	x1, x0
mov	x0, x20
mov	w2, #1
ldp	x29, x30, [sp, #16]
ldp	x20, x19, [sp], #32
b	LFQH_ShelfTint
LFQH_LBB222_3:
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
LFQH_Lloh3532:
adr x1, LFQH_l_.str.485
LFQH_Lloh3533:
nop
mov	x0, x23
bl	LFQH_Kind
fmov	d8, xzr
cmp	w0, #0
ccmp	x23, #0, #4, ne
b.ne	LFQH_LBB223_6
LFQH_LBB223_1:
mov	x21, #0
LFQH_LBB223_2:
fmov	d10, xzr
fmov	d9, xzr
fmov	d11, xzr
LFQH_LBB223_3:
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
b.ls	LFQH_LBB223_14
LFQH_LBB223_4:
LFQH_Lloh3534:
adr x0, LFQH_l_.str.302
LFQH_Lloh3535:
nop
bl Lpatch + (0xa5a4 - PATCH_BASE)
mov	x1, x0
mov	x0, x20
bl Lpatch + (0xa5d4 - PATCH_BASE)
mov	x0, x19
mov	x1, x22
mov	x2, #0
LFQH_LBB223_5:
mov	w3, #1
ldp	x29, x30, [sp, #96]
ldp	x20, x19, [sp, #80]
ldp	x22, x21, [sp, #64]
ldp	x24, x23, [sp, #48]
ldp	x26, x25, [sp, #32]
ldp	d9, d8, [sp, #16]
ldp	d11, d10, [sp], #112
b Lpatch + (0xa634 - PATCH_BASE)
LFQH_LBB223_6:
mov	w26, #0
LFQH_Lloh3536:
adr x24, LFQH_l_.str.292
LFQH_Lloh3537:
nop
mov	x21, x23
LFQH_Lloh3538:
adr x25, LFQH_l_.str.20
LFQH_Lloh3539:
nop
LFQH_LBB223_7:
mov	x0, x24
bl Lpatch + (0xa5a4 - PATCH_BASE)
mov	x1, x0
mov	x0, x21
bl Lpatch + (0xa5d4 - PATCH_BASE)
cbnz	w0, LFQH_LBB223_1
mov	x0, x21
mov	x1, x25
bl	LFQH_Get
cmp	x0, x19
b.eq	LFQH_LBB223_12
cbz	x0, LFQH_LBB223_11
mov	x21, x0
cmp	w26, #2
add	w26, w26, #1
b.ls	LFQH_LBB223_7
LFQH_LBB223_11:
mov	x21, x0
cbz	x0, LFQH_LBB223_2
LFQH_LBB223_12:
LFQH_Lloh3540:
adr x1, LFQH_l_.str.20
LFQH_Lloh3541:
nop
mov	x0, x21
bl	LFQH_Get
cmp	x0, x19
b.ne	LFQH_LBB223_2
LFQH_Lloh3542:
adr x0, LFQH_l_.str.24
LFQH_Lloh3543:
nop
bl Lpatch + (0xa5a4 - PATCH_BASE)
mov	x1, x0
mov	x0, x23
bl Lpatch + (0xa5d4 - PATCH_BASE)
mov.16b	v8, v0
mov.16b	v9, v1
mov.16b	v10, v2
mov.16b	v11, v3
LFQH_Lloh3544:
adr x0, LFQH_l_.str.303
LFQH_Lloh3545:
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
b	LFQH_LBB223_3
LFQH_LBB223_14:
fmov	x8, d8
ubfx	x8, x8, #52, #11
cmp	x8, #2046
b.hi	LFQH_LBB223_4
fcmp	d10, #0.0
b.le	LFQH_LBB223_4
fcmp	d8, #0.0
b.le	LFQH_LBB223_4
cbnz	x20, LFQH_LBB223_20
bl	LFQH_NewGlassSurface
cbz	x0, LFQH_LBB223_25
mov	x20, x0
mov	x0, x19
mov	x1, x22
mov	x2, x20
mov	w3, #1
bl Lpatch + (0xa634 - PATCH_BASE)
LFQH_Lloh3546:
adr x0, LFQH_l_.str.55
LFQH_Lloh3547:
nop
bl Lpatch + (0xa5a4 - PATCH_BASE)
mov	x1, x0
mov	x0, x20
bl Lpatch + (0xa5d4 - PATCH_BASE)
LFQH_LBB223_20:
mov	x8, #-4593108669964484608
fmov	d0, x8
fadd	d1, d10, d0
fmov	d2, #0.50000000
fmul	d1, d1, d2
fadd	d10, d11, d1
fadd	d0, d8, d0
fmul	d0, d0, d2
fadd	d8, d9, d0
LFQH_Lloh3548:
adr x0, LFQH_l_.str.249
LFQH_Lloh3549:
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
b.eq	LFQH_LBB223_22
LFQH_Lloh3550:
adr x0, LFQH_l_.str.78
LFQH_Lloh3551:
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
LFQH_LBB223_22:
LFQH_Lloh3552:
adr x1, LFQH_l_.str.20
LFQH_Lloh3553:
nop
mov	x0, x20
bl	LFQH_Get
cmp	x0, x19
b.ne	LFQH_LBB223_24
LFQH_Lloh3554:
adr x1, LFQH_ProfileAnchorKey
LFQH_Lloh3555:
nop
mov	x0, x20
bl Lpatch + (0xa628 - PATCH_BASE)
cmp	x0, x21
b.eq	LFQH_LBB223_25
LFQH_LBB223_24:
LFQH_Lloh3556:
adr x0, LFQH_l_.str.298
LFQH_Lloh3557:
nop
bl Lpatch + (0xa5a4 - PATCH_BASE)
mov	x1, x0
mov	x0, x19
mov	x2, x20
mov	x3, x21
bl Lpatch + (0xa5d4 - PATCH_BASE)
LFQH_Lloh3558:
adr x1, LFQH_ProfileAnchorKey
LFQH_Lloh3559:
nop
mov	x0, x20
mov	x2, x21
b	LFQH_LBB223_5
LFQH_LBB223_25:
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
LFQH_TopChromePage:
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
mov	x23, x3
mov.16b	v8, v3
mov.16b	v9, v2
mov.16b	v10, v1
mov.16b	v11, v0
mov	x22, x2
mov	x20, x1
mov	x19, x0
LFQH_Lloh3560:
adr x1, LFQH_TopChromeEdgeOwnerKey
LFQH_Lloh3561:
nop
bl Lpatch + (0xa628 - PATCH_BASE)
mov	x21, x0
cbz	w23, LFQH_LBB228_4
LFQH_Lloh3562:
adr x1, LFQH_l_.str.515
LFQH_Lloh3563:
nop
mov	x0, x22
bl	LFQH_Kind
cbz	w0, LFQH_LBB228_3
LFQH_Lloh3564:
adr x1, LFQH_l_.str.20
LFQH_Lloh3565:
nop
mov	x0, x20
bl	LFQH_Get
fmov	x8, d9
fmov	x9, d10
fmov	x10, d11
ubfx	x10, x10, #52, #11
ubfx	x9, x9, #52, #11
ubfx	x8, x8, #52, #11
fmov	x11, d8
ubfx	x11, x11, #52, #11
cmp	x11, #2047
cset	w11, lo
cmp	x8, #2046
mov	w8, #2046
ccmp	x9, x8, #2, ls
ccmp	x10, x8, #2, ls
csel	w8, wzr, w11, hi
fcmp	d9, #0.0
csel	w8, wzr, w8, le
fcmp	d8, #0.0
csel	w8, wzr, w8, le
cmp	x0, x19
csel	w23, wzr, w8, ne
b	LFQH_LBB228_4
LFQH_LBB228_3:
mov	w23, #0
LFQH_LBB228_4:
cmp	x21, x20
csel	w8, wzr, w23, ne
cbz	x21, LFQH_LBB228_7
tbnz	w8, #0, LFQH_LBB228_7
mov	x0, x21
mov	x1, #0
mov	w2, #0
bl	LFQH_TopChromeNativeEdge
mov	x0, x21
mov	w1, #0
bl	LFQH_TopChromeFill
LFQH_LBB228_7:
cbz	w23, LFQH_LBB228_9
mov	x0, x20
mov	x1, x22
mov	w2, #1
bl	LFQH_TopChromeNativeEdge
mov	x22, x0
b	LFQH_LBB228_10
LFQH_LBB228_9:
mov	w22, #0
LFQH_LBB228_10:
eor	w8, w22, #0x1
and	w2, w23, w8
mov	x0, x19
mov	x1, x20
mov.16b	v0, v11
mov.16b	v1, v10
mov.16b	v2, v9
mov.16b	v3, v8
bl	LFQH_TopChrome
tst	w0, #0xff
cset	w8, ne
orr	w22, w22, w8
tst	w22, #0x1
csel	x2, x20, xzr, ne
cmp	x21, x2
b.eq	LFQH_LBB228_12
LFQH_Lloh3566:
adr x1, LFQH_TopChromeEdgeOwnerKey
LFQH_Lloh3567:
nop
mov	x0, x19
mov	w3, #1
bl Lpatch + (0xa634 - PATCH_BASE)
LFQH_LBB228_12:
and	w0, w22, #0x1
ldp	x29, x30, [sp, #80]
ldp	x20, x19, [sp, #64]
ldp	x22, x21, [sp, #48]
ldp	x24, x23, [sp, #32]
ldp	d9, d8, [sp, #16]
ldp	d11, d10, [sp], #96
ret
.cfi_endproc
.p2align	2
LFQH_TopChromeFill:
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
mov	x23, x1
mov	x19, x0
LFQH_Lloh3568:
adr x1, LFQH_l_.str.23
LFQH_Lloh3569:
nop
bl	LFQH_Kind
cbz	w0, LFQH_LBB229_14
LFQH_Lloh3570:
adr x0, LFQH_l_.str.46
LFQH_Lloh3571:
nop
bl Lpatch + (0xa5b0 - PATCH_BASE)
mov	x20, x0
LFQH_Lloh3572:
adr x0, LFQH_l_.str.80
LFQH_Lloh3573:
nop
bl Lpatch + (0xa5a4 - PATCH_BASE)
mov	x1, x0
mov	x0, x20
bl Lpatch + (0xa5d4 - PATCH_BASE)
mov	x20, x0
LFQH_Lloh3574:
adr x0, LFQH_l_.str.250
LFQH_Lloh3575:
nop
bl Lpatch + (0xa5a4 - PATCH_BASE)
mov	x1, x0
mov	x0, x19
bl Lpatch + (0xa5d4 - PATCH_BASE)
mov	x21, x0
LFQH_Lloh3576:
adr x1, LFQH_TopChromeColorKey
LFQH_Lloh3577:
nop
mov	x0, x19
bl Lpatch + (0xa628 - PATCH_BASE)
mov	x22, x0
LFQH_Lloh3578:
adr x1, LFQH_TopChromeOpaqueKey
LFQH_Lloh3579:
nop
mov	x0, x19
bl Lpatch + (0xa628 - PATCH_BASE)
cbz	w23, LFQH_LBB229_7
LFQH_Lloh3580:
adr x0, LFQH_l_.str.252
LFQH_Lloh3581:
nop
bl Lpatch + (0xa5a4 - PATCH_BASE)
mov	x1, x0
mov	x0, x19
bl Lpatch + (0xa5d4 - PATCH_BASE)
cbz	w0, LFQH_LBB229_4
LFQH_Lloh3582:
adr x0, LFQH_l_.str.267
LFQH_Lloh3583:
nop
bl Lpatch + (0xa5b0 - PATCH_BASE)
mov	x22, x0
LFQH_Lloh3584:
adr x0, LFQH_l_.str.334
LFQH_Lloh3585:
nop
bl Lpatch + (0xa5a4 - PATCH_BASE)
mov	x1, x0
mov	x0, x22
mov	w2, #1
bl Lpatch + (0xa5d4 - PATCH_BASE)
mov	x2, x0
LFQH_Lloh3586:
adr x1, LFQH_TopChromeOpaqueKey
LFQH_Lloh3587:
nop
mov	x0, x19
mov	w3, #1
bl Lpatch + (0xa634 - PATCH_BASE)
LFQH_Lloh3588:
adr x0, LFQH_l_.str.262
LFQH_Lloh3589:
nop
bl Lpatch + (0xa5a4 - PATCH_BASE)
mov	x1, x0
mov	x0, x19
mov	w2, #0
bl Lpatch + (0xa5d4 - PATCH_BASE)
LFQH_LBB229_4:
cmp	x21, x20
ccmp	x21, #0, #4, ne
b.eq	LFQH_LBB229_14
LFQH_Lloh3590:
adr x0, LFQH_l_.str.48
LFQH_Lloh3591:
nop
bl Lpatch + (0xa5a4 - PATCH_BASE)
mov	x1, x0
mov	x0, x21
mov	x2, x20
bl Lpatch + (0xa5d4 - PATCH_BASE)
cbnz	w0, LFQH_LBB229_14
LFQH_Lloh3592:
adr x1, LFQH_TopChromeColorKey
LFQH_Lloh3593:
nop
mov	x0, x19
mov	x2, x21
mov	w3, #1
bl Lpatch + (0xa634 - PATCH_BASE)
LFQH_Lloh3594:
adr x0, LFQH_l_.str.79
LFQH_Lloh3595:
nop
bl Lpatch + (0xa5a4 - PATCH_BASE)
mov	x1, x0
mov	x0, x19
mov	x2, x20
ldp	x29, x30, [sp, #48]
ldp	x20, x19, [sp, #32]
ldp	x22, x21, [sp, #16]
ldp	x24, x23, [sp], #64
b Lpatch + (0xa5d4 - PATCH_BASE)
LFQH_LBB229_7:
cbz	x0, LFQH_LBB229_9
LFQH_Lloh3596:
adr x0, LFQH_l_.str.262
LFQH_Lloh3597:
nop
bl Lpatch + (0xa5a4 - PATCH_BASE)
mov	x1, x0
mov	x0, x19
mov	w2, #1
bl Lpatch + (0xa5d4 - PATCH_BASE)
LFQH_Lloh3598:
adr x1, LFQH_TopChromeOpaqueKey
LFQH_Lloh3599:
nop
mov	x0, x19
mov	x2, #0
mov	w3, #1
bl Lpatch + (0xa634 - PATCH_BASE)
LFQH_LBB229_9:
cbz	x22, LFQH_LBB229_14
cmp	x21, x20
b.eq	LFQH_LBB229_12
LFQH_Lloh3600:
adr x0, LFQH_l_.str.48
LFQH_Lloh3601:
nop
bl Lpatch + (0xa5a4 - PATCH_BASE)
mov	x1, x0
mov	x0, x21
mov	x2, x20
bl Lpatch + (0xa5d4 - PATCH_BASE)
cbz	w0, LFQH_LBB229_13
LFQH_LBB229_12:
LFQH_Lloh3602:
adr x0, LFQH_l_.str.79
LFQH_Lloh3603:
nop
bl Lpatch + (0xa5a4 - PATCH_BASE)
mov	x1, x0
mov	x0, x19
mov	x2, x22
bl Lpatch + (0xa5d4 - PATCH_BASE)
LFQH_LBB229_13:
LFQH_Lloh3604:
adr x1, LFQH_TopChromeColorKey
LFQH_Lloh3605:
nop
mov	x0, x19
mov	x2, #0
mov	w3, #1
ldp	x29, x30, [sp, #48]
ldp	x20, x19, [sp, #32]
ldp	x22, x21, [sp, #16]
ldp	x24, x23, [sp], #64
b Lpatch + (0xa634 - PATCH_BASE)
LFQH_LBB229_14:
ldp	x29, x30, [sp, #48]
ldp	x20, x19, [sp, #32]
ldp	x22, x21, [sp, #16]
ldp	x24, x23, [sp], #64
ret
.cfi_endproc
.p2align	2
LFQH_TopChromeUnderlap:
.cfi_startproc
sub	sp, sp, #160
stp	d15, d14, [sp, #32]
stp	d13, d12, [sp, #48]
stp	d11, d10, [sp, #64]
stp	d9, d8, [sp, #80]
stp	x24, x23, [sp, #96]
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
mov	x22, x2
mov.16b	v11, v0
mov	x19, x1
mov	x20, x0
LFQH_Lloh3606:
adr x1, LFQH_l_.str.23
LFQH_Lloh3607:
nop
bl	LFQH_Kind
cbz	w0, LFQH_LBB230_27
LFQH_Lloh3608:
adr x0, LFQH_l_.str.249
LFQH_Lloh3609:
nop
bl Lpatch + (0xa5a4 - PATCH_BASE)
mov	x1, x0
mov	x0, x20
bl Lpatch + (0xa5d4 - PATCH_BASE)
mov.16b	v14, v0
mov	x0, x20
stp	d1, d3, [sp, #8]
str	d2, [sp, #24]
bl	LFQH_TopChromeStockFrame
mov.16b	v8, v0
mov.16b	v15, v1
mov.16b	v9, v2
mov.16b	v10, v3
LFQH_Lloh3610:
adr x1, LFQH_TopChromeFrameKey
LFQH_Lloh3611:
nop
mov	x0, x20
bl Lpatch + (0xa628 - PATCH_BASE)
mov	x21, x0
fmov	d13, xzr
cbz	w22, LFQH_LBB230_8
mov	x0, x20
mov	x1, x19
bl	LFQH_TopChromeContains
cbz	w0, LFQH_LBB230_8
fmov	x8, d8
ubfx	x8, x8, #52, #11
fmov	x9, d15
ubfx	x9, x9, #52, #11
fmov	x10, d9
ubfx	x10, x10, #52, #11
cmp	x10, #2046
mov	w10, #2046
ccmp	x9, x10, #2, ls
ccmp	x8, x10, #2, ls
b.hi	LFQH_LBB230_8
fmov	x8, d10
ubfx	x8, x8, #52, #11
cmp	x8, #2046
b.hi	LFQH_LBB230_8
fcmp	d9, #0.0
b.le	LFQH_LBB230_8
fcmp	d10, #0.0
b.le	LFQH_LBB230_8
fsub	d0, d15, d11
fmov	d1, xzr
fmaxnm	d13, d0, d1
LFQH_LBB230_8:
LFQH_Lloh3612:
adr x1, LFQH_TopChromeScrollKey
LFQH_Lloh3613:
nop
mov	x0, x20
bl Lpatch + (0xa628 - PATCH_BASE)
cmp	x0, #0
ccmp	x21, #0, #4, eq
csel	x22, x0, x20, eq
cbz	x22, LFQH_LBB230_12
cmp	x22, x19
b.ne	LFQH_LBB230_11
fcmp	d13, #0.0
b.ne	LFQH_LBB230_12
LFQH_LBB230_11:
fmov	d0, xzr
mov	x0, x22
bl	LFQH_TopChromeInsets
LFQH_LBB230_12:
fsub	d12, d15, d13
fadd	d11, d10, d13
fcmp	d13, #0.0
b.le	LFQH_LBB230_19
cmp	x22, x19
b.eq	LFQH_LBB230_15
cmp	x19, x20
csel	x2, xzr, x19, eq
LFQH_Lloh3614:
adr x1, LFQH_TopChromeScrollKey
LFQH_Lloh3615:
nop
mov	x0, x20
mov	w3, #1
bl Lpatch + (0xa634 - PATCH_BASE)
LFQH_LBB230_15:
cbz	x21, LFQH_LBB230_18
LFQH_Lloh3616:
adr x0, LFQH_l_.str.286
LFQH_Lloh3617:
nop
bl Lpatch + (0xa5a4 - PATCH_BASE)
mov	x1, x0
mov	x0, x21
bl Lpatch + (0xa5d4 - PATCH_BASE)
fcmp	d0, d8
b.ne	LFQH_LBB230_18
fcmp	d1, d12
fccmp	d2, d9, #0, eq
fccmp	d3, d11, #0, eq
b.eq	LFQH_LBB230_22
LFQH_LBB230_18:
LFQH_Lloh3618:
adr x21, LFQH_l_.str.287
LFQH_Lloh3619:
nop
mov	x0, x21
bl Lpatch + (0xa5b0 - PATCH_BASE)
mov	x22, x0
LFQH_Lloh3620:
adr x23, LFQH_l_.str.288
LFQH_Lloh3621:
nop
mov	x0, x23
bl Lpatch + (0xa5a4 - PATCH_BASE)
mov	x1, x0
mov	x0, x22
mov.16b	v0, v8
mov.16b	v1, v15
mov.16b	v2, v9
mov.16b	v3, v10
bl Lpatch + (0xa5d4 - PATCH_BASE)
mov	x2, x0
LFQH_Lloh3622:
adr x1, LFQH_TopChromeStockFrameKey
LFQH_Lloh3623:
nop
mov	x0, x20
mov	w3, #1
bl Lpatch + (0xa634 - PATCH_BASE)
mov	x0, x21
bl Lpatch + (0xa5b0 - PATCH_BASE)
mov	x21, x0
mov	x0, x23
bl Lpatch + (0xa5a4 - PATCH_BASE)
mov	x1, x0
mov	x0, x21
mov.16b	v0, v8
mov.16b	v1, v12
mov.16b	v2, v9
mov.16b	v3, v11
bl Lpatch + (0xa5d4 - PATCH_BASE)
mov	x2, x0
LFQH_Lloh3624:
adr x1, LFQH_TopChromeFrameKey
LFQH_Lloh3625:
nop
mov	x0, x20
b	LFQH_LBB230_21
LFQH_LBB230_19:
cbz	x21, LFQH_LBB230_22
LFQH_Lloh3626:
adr x1, LFQH_TopChromeStockFrameKey
LFQH_Lloh3627:
nop
mov	x0, x20
mov	x2, #0
mov	w3, #1
bl Lpatch + (0xa634 - PATCH_BASE)
LFQH_Lloh3628:
adr x1, LFQH_TopChromeFrameKey
LFQH_Lloh3629:
nop
mov	x0, x20
mov	x2, #0
mov	w3, #1
bl Lpatch + (0xa634 - PATCH_BASE)
LFQH_Lloh3630:
adr x1, LFQH_TopChromeScrollKey
LFQH_Lloh3631:
nop
mov	x0, x20
mov	x2, #0
LFQH_LBB230_21:
mov	w3, #1
bl Lpatch + (0xa634 - PATCH_BASE)
LFQH_LBB230_22:
fcmp	d14, d8
b.ne	LFQH_LBB230_24
ldr	d0, [sp, #8]
fcmp	d0, d12
ldp	d0, d1, [sp, #16]
fccmp	d1, d9, #0, eq
fccmp	d0, d11, #0, eq
b.eq	LFQH_LBB230_25
LFQH_LBB230_24:
LFQH_Lloh3632:
adr x0, LFQH_l_.str.78
LFQH_Lloh3633:
nop
bl Lpatch + (0xa5a4 - PATCH_BASE)
mov	x1, x0
mov	x0, x20
mov.16b	v0, v8
mov.16b	v1, v12
mov.16b	v2, v9
mov.16b	v3, v11
bl Lpatch + (0xa5d4 - PATCH_BASE)
LFQH_LBB230_25:
fcmp	d13, #0.0
b.le	LFQH_LBB230_27
mov	x0, x19
mov.16b	v0, v13
ldp	x29, x30, [sp, #144]
ldp	x20, x19, [sp, #128]
ldp	x22, x21, [sp, #112]
ldp	x24, x23, [sp, #96]
ldp	d9, d8, [sp, #80]
ldp	d11, d10, [sp, #64]
ldp	d13, d12, [sp, #48]
ldp	d15, d14, [sp, #32]
add	sp, sp, #160
b	LFQH_TopChromeInsets
LFQH_LBB230_27:
ldp	x29, x30, [sp, #144]
ldp	x20, x19, [sp, #128]
ldp	x22, x21, [sp, #112]
ldp	x24, x23, [sp, #96]
ldp	d9, d8, [sp, #80]
ldp	d11, d10, [sp, #64]
ldp	d13, d12, [sp, #48]
ldp	d15, d14, [sp, #32]
add	sp, sp, #160
ret
.cfi_endproc
.p2align	2
LFQH_TopChromeDiagnostics:
.cfi_startproc
sub	sp, sp, #224
stp	d15, d14, [sp, #64]
stp	d13, d12, [sp, #80]
stp	d11, d10, [sp, #96]
stp	d9, d8, [sp, #112]
stp	x28, x27, [sp, #128]
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
cbz	x2, LFQH_LBB231_16
mov	x24, x3
cbz	x3, LFQH_LBB231_16
mov	x19, x5
mov	x23, x4
mov	x22, x2
mov	x20, x1
mov	x21, x0
LFQH_Lloh3634:
adr x1, LFQH_l_.str.312
LFQH_Lloh3635:
nop
mov	x0, x2
bl	LFQH_Get
cbz	x0, LFQH_LBB231_16
LFQH_Lloh3636:
adr x0, LFQH_l_.str.249
LFQH_Lloh3637:
nop
bl Lpatch + (0xa5a4 - PATCH_BASE)
mov	x1, x0
mov	x0, x24
bl Lpatch + (0xa5d4 - PATCH_BASE)
mov	x0, x24
bl	LFQH_TopChromeStockFrame
stp	d1, d0, [sp, #32]
stp	d3, d2, [sp, #16]
LFQH_Lloh3638:
adr x0, LFQH_l_.str.24
LFQH_Lloh3639:
nop
bl Lpatch + (0xa5a4 - PATCH_BASE)
mov	x1, x0
mov	x0, x24
bl Lpatch + (0xa5d4 - PATCH_BASE)
mov.16b	v8, v0
mov.16b	v9, v1
mov.16b	v10, v2
mov.16b	v11, v3
LFQH_Lloh3640:
adr x0, LFQH_l_.str.303
LFQH_Lloh3641:
nop
bl Lpatch + (0xa5a4 - PATCH_BASE)
mov	x1, x0
mov	x0, x24
mov.16b	v0, v8
mov.16b	v1, v9
mov.16b	v2, v10
mov.16b	v3, v11
mov	x2, x22
bl Lpatch + (0xa5d4 - PATCH_BASE)
stp	d2, d0, [sp]
stp	d1, d3, [sp, #48]
cbz	x23, LFQH_LBB231_10
LFQH_Lloh3642:
adr x0, LFQH_l_.str.24
LFQH_Lloh3643:
nop
bl Lpatch + (0xa5a4 - PATCH_BASE)
mov	x1, x0
mov	x0, x23
bl Lpatch + (0xa5d4 - PATCH_BASE)
mov.16b	v8, v0
mov.16b	v9, v1
mov.16b	v10, v2
mov.16b	v11, v3
LFQH_Lloh3644:
adr x0, LFQH_l_.str.303
LFQH_Lloh3645:
nop
bl Lpatch + (0xa5a4 - PATCH_BASE)
mov	x1, x0
mov	x0, x23
mov.16b	v0, v8
mov.16b	v1, v9
mov.16b	v2, v10
mov.16b	v3, v11
mov	x2, x22
bl Lpatch + (0xa5d4 - PATCH_BASE)
mov.16b	v11, v0
mov.16b	v10, v1
mov.16b	v9, v2
mov.16b	v14, v3
LFQH_Lloh3646:
adr x1, LFQH_l_.str.20
LFQH_Lloh3647:
nop
mov	x0, x23
bl	LFQH_Get
cmp	x0, x22
ccmp	x0, #0, #4, ne
b.eq	LFQH_LBB231_11
mov	x23, x0
LFQH_Lloh3648:
adr x24, LFQH_l_.str.251
LFQH_Lloh3649:
nop
LFQH_Lloh3650:
adr x25, LFQH_l_.str.20
LFQH_Lloh3651:
nop
LFQH_Lloh3652:
adr x26, LFQH_l_.str.24
LFQH_Lloh3653:
nop
LFQH_Lloh3654:
adr x27, LFQH_l_.str.303
LFQH_Lloh3655:
nop
LFQH_LBB231_6:
mov	x0, x24
bl Lpatch + (0xa5a4 - PATCH_BASE)
mov	x1, x0
mov	x0, x23
bl Lpatch + (0xa5d4 - PATCH_BASE)
cbz	w0, LFQH_LBB231_8
mov	x0, x26
bl Lpatch + (0xa5a4 - PATCH_BASE)
mov	x1, x0
mov	x0, x23
bl Lpatch + (0xa5d4 - PATCH_BASE)
mov.16b	v12, v0
mov.16b	v8, v14
mov.16b	v14, v1
mov.16b	v15, v2
mov.16b	v13, v3
mov	x0, x27
bl Lpatch + (0xa5a4 - PATCH_BASE)
mov	x1, x0
mov	x0, x23
mov.16b	v0, v12
mov.16b	v1, v14
mov.16b	v2, v15
mov.16b	v3, v13
mov	x2, x22
bl Lpatch + (0xa5d4 - PATCH_BASE)
fadd	d4, d9, d11
fmaxnm	d11, d0, d11
fadd	d5, d8, d10
fmaxnm	d10, d1, d10
fadd	d0, d0, d2
fminnm	d0, d0, d4
fadd	d1, d1, d3
fminnm	d1, d1, d5
fsub	d0, d0, d11
fmov	d2, xzr
fmaxnm	d9, d0, d2
fsub	d0, d1, d10
fmaxnm	d14, d0, d2
LFQH_LBB231_8:
mov	x0, x23
mov	x1, x25
bl	LFQH_Get
cbz	x0, LFQH_LBB231_11
mov	x23, x0
cmp	x0, x22
b.ne	LFQH_LBB231_6
b	LFQH_LBB231_11
LFQH_LBB231_10:
fmov	d14, xzr
fmov	d9, xzr
fmov	d10, xzr
fmov	d11, xzr
LFQH_LBB231_11:
LFQH_Lloh3656:
adr x1, LFQH_TopChromeEdgeOwnerKey
LFQH_Lloh3657:
nop
mov	x0, x22
bl Lpatch + (0xa628 - PATCH_BASE)
LFQH_Lloh3658:
adr x1, LFQH_TopChromeEdgeInteractionKey
LFQH_Lloh3659:
nop
bl Lpatch + (0xa628 - PATCH_BASE)
mov	x22, x0
and	w8, w19, #0xff
ucvtf	d0, w8
cmp	x0, #0
fmov	d1, #2.00000000
fcsel	d12, d0, d1, eq
LFQH_Lloh3660:
adr x1, LFQH_TopChromeGeometryKey
LFQH_Lloh3661:
nop
mov	x0, x21
bl Lpatch + (0xa628 - PATCH_BASE)
ldr	d8, [sp, #48]
cbz	x0, LFQH_LBB231_17
mov	x23, x0
LFQH_Lloh3662:
adr x0, LFQH_l_.str.286
LFQH_Lloh3663:
nop
bl Lpatch + (0xa5a4 - PATCH_BASE)
mov	x1, x0
mov	x0, x23
bl Lpatch + (0xa5d4 - PATCH_BASE)
fcmp	d8, d0
b.ne	LFQH_LBB231_17
fcmp	d10, d1
b.ne	LFQH_LBB231_17
ldr	d0, [sp, #56]
fcmp	d0, d2
b.ne	LFQH_LBB231_17
fcmp	d12, d3
b.ne	LFQH_LBB231_17
LFQH_LBB231_16:
ldp	x29, x30, [sp, #208]
ldp	x20, x19, [sp, #192]
ldp	x22, x21, [sp, #176]
ldp	x24, x23, [sp, #160]
ldp	x26, x25, [sp, #144]
ldp	x28, x27, [sp, #128]
ldp	d9, d8, [sp, #112]
ldp	d11, d10, [sp, #96]
ldp	d13, d12, [sp, #80]
ldp	d15, d14, [sp, #64]
add	sp, sp, #224
ret
LFQH_LBB231_17:
LFQH_Lloh3664:
adr x0, LFQH_l_.str.287
LFQH_Lloh3665:
nop
bl Lpatch + (0xa5b0 - PATCH_BASE)
mov	x23, x0
LFQH_Lloh3666:
adr x0, LFQH_l_.str.288
LFQH_Lloh3667:
nop
bl Lpatch + (0xa5a4 - PATCH_BASE)
mov	x1, x0
mov	x0, x23
mov.16b	v0, v8
mov.16b	v1, v10
ldr	d13, [sp, #56]
mov.16b	v2, v13
mov.16b	v3, v12
bl Lpatch + (0xa5d4 - PATCH_BASE)
mov	x2, x0
LFQH_Lloh3668:
adr x1, LFQH_TopChromeGeometryKey
LFQH_Lloh3669:
nop
mov	x0, x21
mov	w3, #1
bl Lpatch + (0xa634 - PATCH_BASE)
LFQH_Lloh3670:
adr x0, LFQH_l_.str.273
LFQH_Lloh3671:
nop
bl Lpatch + (0xa5b0 - PATCH_BASE)
mov	x21, x0
LFQH_Lloh3672:
adr x0, LFQH_l_.str.274
LFQH_Lloh3673:
nop
bl Lpatch + (0xa5a4 - PATCH_BASE)
mov	x1, x0
mov	x0, x21
bl Lpatch + (0xa5d4 - PATCH_BASE)
mov	x21, x0
LFQH_Lloh3674:
adr x23, LFQH_l_.str.244
LFQH_Lloh3675:
nop
mov	x0, x23
bl Lpatch + (0xa5b0 - PATCH_BASE)
mov	x24, x0
LFQH_Lloh3676:
adr x25, LFQH_l_.str.245
LFQH_Lloh3677:
nop
mov	x0, x25
bl Lpatch + (0xa5a4 - PATCH_BASE)
mov	x1, x0
mov	x0, x24
mov	x2, x20
bl Lpatch + (0xa5d4 - PATCH_BASE)
mov	x2, x0
LFQH_Lloh3678:
adr x1, LFQH_l_.str.275
LFQH_Lloh3679:
nop
mov	x0, x21
bl	LFQH_Put
LFQH_Lloh3680:
adr x8, LFQH_l_.str.536
LFQH_Lloh3681:
nop
LFQH_Lloh3682:
adr x9, LFQH_l_.str.537
LFQH_Lloh3683:
nop
cmp	w19, #0
csel	x8, x9, x8, eq
LFQH_Lloh3684:
adr x9, LFQH_l_.str.535
LFQH_Lloh3685:
nop
cmp	x22, #0
csel	x19, x8, x9, eq
mov	x0, x23
bl Lpatch + (0xa5b0 - PATCH_BASE)
mov	x20, x0
mov	x0, x25
bl Lpatch + (0xa5a4 - PATCH_BASE)
mov	x1, x0
mov	x0, x20
mov	x2, x19
bl Lpatch + (0xa5d4 - PATCH_BASE)
mov	x2, x0
LFQH_Lloh3686:
adr x1, LFQH_l_.str.534
LFQH_Lloh3687:
nop
mov	x0, x21
bl	LFQH_Put
ldp	d1, d0, [sp, #32]
ldp	d3, d2, [sp, #16]
bl	LFQH_RectArray
mov	x2, x0
LFQH_Lloh3688:
adr x1, LFQH_l_.str.538
LFQH_Lloh3689:
nop
mov	x0, x21
bl	LFQH_Put
ldp	d2, d0, [sp]
mov.16b	v1, v8
mov.16b	v3, v13
bl	LFQH_RectArray
mov	x2, x0
LFQH_Lloh3690:
adr x1, LFQH_l_.str.539
LFQH_Lloh3691:
nop
mov	x0, x21
bl	LFQH_Put
mov.16b	v0, v11
mov.16b	v1, v10
mov.16b	v2, v9
mov.16b	v3, v14
bl	LFQH_RectArray
mov	x2, x0
LFQH_Lloh3692:
adr x1, LFQH_l_.str.540
LFQH_Lloh3693:
nop
mov	x0, x21
bl	LFQH_Put
LFQH_Lloh3694:
adr x0, LFQH_l_.str.541
LFQH_Lloh3695:
nop
mov	x1, x21
ldp	x29, x30, [sp, #208]
ldp	x20, x19, [sp, #192]
ldp	x22, x21, [sp, #176]
ldp	x24, x23, [sp, #160]
ldp	x26, x25, [sp, #144]
ldp	x28, x27, [sp, #128]
ldp	d9, d8, [sp, #112]
ldp	d11, d10, [sp, #96]
ldp	d13, d12, [sp, #80]
ldp	d15, d14, [sp, #64]
add	sp, sp, #224
b Lrecord_named
.cfi_endproc
.p2align	2
LFQH_TopChromeEdgeOwnerKey:
.cfi_startproc
ret
.cfi_endproc
.p2align	2
LFQH_TopChromeNativeEdge:
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
mov	x24, x1
mov	x22, x0
LFQH_Lloh3696:
adr x1, LFQH_TopChromeEdgeInteractionKey
LFQH_Lloh3697:
nop
bl Lpatch + (0xa628 - PATCH_BASE)
mov	x20, x0
LFQH_Lloh3698:
adr x1, LFQH_l_.str.516
LFQH_Lloh3699:
nop
bl	LFQH_Get
mov	x26, x0
LFQH_Lloh3700:
adr x0, LFQH_l_.str.517
LFQH_Lloh3701:
nop
bl Lpatch + (0xa5b0 - PATCH_BASE)
LFQH_Lloh3702:
adr x1, LFQH_l_.str.518
LFQH_Lloh3703:
nop
bl	LFQH_Get
mov	x21, x0
cbz	w19, LFQH_LBB233_2
LFQH_Lloh3704:
adr x1, LFQH_l_.str.519
LFQH_Lloh3705:
nop
mov	x0, x24
bl	LFQH_Get
mov	x19, x0
b	LFQH_LBB233_3
LFQH_LBB233_2:
mov	x19, #0
LFQH_LBB233_3:
LFQH_Lloh3706:
adr x1, LFQH_l_.str.520
LFQH_Lloh3707:
nop
mov	x0, x19
bl	LFQH_Get
mov	x23, x0
mov	w25, #0
cbz	x0, LFQH_LBB233_7
cbz	x21, LFQH_LBB233_7
LFQH_Lloh3708:
adr x1, LFQH_l_.str.521
LFQH_Lloh3709:
nop
mov	x0, x19
bl	LFQH_Responds
cbz	w0, LFQH_LBB233_31
LFQH_Lloh3710:
adr x1, LFQH_l_.str.522
LFQH_Lloh3711:
nop
mov	x0, x19
bl	LFQH_Responds
mov	x25, x0
LFQH_LBB233_7:
cbz	x20, LFQH_LBB233_18
LFQH_LBB233_8:
cmp	x26, x24
csel	w8, wzr, w25, ne
tbnz	w8, #0, LFQH_LBB233_18
LFQH_Lloh3712:
adr x1, LFQH_l_.str.519
LFQH_Lloh3713:
nop
mov	x0, x26
bl	LFQH_Get
mov	x26, x0
LFQH_Lloh3714:
adr x1, LFQH_TopChromeEdgeStyleKey
LFQH_Lloh3715:
nop
mov	x0, x20
bl Lpatch + (0xa628 - PATCH_BASE)
cbz	x0, LFQH_LBB233_14
cbz	x21, LFQH_LBB233_14
mov	x27, x0
LFQH_Lloh3716:
adr x1, LFQH_l_.str.520
LFQH_Lloh3717:
nop
mov	x0, x26
bl	LFQH_Get
cmp	x0, x21
b.eq	LFQH_LBB233_13
mov	x28, x0
LFQH_Lloh3718:
adr x0, LFQH_l_.str.48
LFQH_Lloh3719:
nop
bl Lpatch + (0xa5a4 - PATCH_BASE)
mov	x1, x0
mov	x0, x28
mov	x2, x21
bl Lpatch + (0xa5d4 - PATCH_BASE)
cbz	w0, LFQH_LBB233_14
LFQH_LBB233_13:
LFQH_Lloh3720:
adr x0, LFQH_l_.str.521
LFQH_Lloh3721:
nop
bl Lpatch + (0xa5a4 - PATCH_BASE)
mov	x1, x0
mov	x0, x26
mov	x2, x27
bl Lpatch + (0xa5d4 - PATCH_BASE)
LFQH_LBB233_14:
LFQH_Lloh3722:
adr x1, LFQH_TopChromeEdgeHiddenKey
LFQH_Lloh3723:
nop
mov	x0, x20
bl Lpatch + (0xa628 - PATCH_BASE)
cbz	x0, LFQH_LBB233_17
LFQH_Lloh3724:
adr x0, LFQH_l_.str.292
LFQH_Lloh3725:
nop
bl Lpatch + (0xa5a4 - PATCH_BASE)
mov	x1, x0
mov	x0, x26
bl Lpatch + (0xa5d4 - PATCH_BASE)
cbnz	w0, LFQH_LBB233_17
LFQH_Lloh3726:
adr x0, LFQH_l_.str.522
LFQH_Lloh3727:
nop
bl Lpatch + (0xa5a4 - PATCH_BASE)
mov	x1, x0
mov	x0, x26
mov	w2, #1
bl Lpatch + (0xa5d4 - PATCH_BASE)
LFQH_LBB233_17:
LFQH_Lloh3728:
adr x0, LFQH_l_.str.523
LFQH_Lloh3729:
nop
bl Lpatch + (0xa5a4 - PATCH_BASE)
mov	x1, x0
mov	x0, x22
mov	x2, x20
bl Lpatch + (0xa5d4 - PATCH_BASE)
LFQH_Lloh3730:
adr x1, LFQH_TopChromeEdgeInteractionKey
LFQH_Lloh3731:
nop
mov	x0, x22
mov	x2, #0
mov	w3, #1
bl Lpatch + (0xa634 - PATCH_BASE)
mov	x20, #0
LFQH_LBB233_18:
cbz	w25, LFQH_LBB233_29
cbz	x20, LFQH_LBB233_25
LFQH_LBB233_20:
cmp	x23, x21
b.eq	LFQH_LBB233_23
LFQH_Lloh3732:
adr x0, LFQH_l_.str.48
LFQH_Lloh3733:
nop
bl Lpatch + (0xa5a4 - PATCH_BASE)
mov	x1, x0
mov	x0, x23
mov	x2, x21
bl Lpatch + (0xa5d4 - PATCH_BASE)
cbnz	w0, LFQH_LBB233_23
LFQH_Lloh3734:
adr x1, LFQH_TopChromeEdgeStyleKey
LFQH_Lloh3735:
nop
mov	x0, x20
mov	x2, x23
mov	w3, #1
bl Lpatch + (0xa634 - PATCH_BASE)
LFQH_Lloh3736:
adr x0, LFQH_l_.str.521
LFQH_Lloh3737:
nop
bl Lpatch + (0xa5a4 - PATCH_BASE)
mov	x1, x0
mov	x0, x19
mov	x2, x21
bl Lpatch + (0xa5d4 - PATCH_BASE)
LFQH_LBB233_23:
LFQH_Lloh3738:
adr x0, LFQH_l_.str.292
LFQH_Lloh3739:
nop
bl Lpatch + (0xa5a4 - PATCH_BASE)
mov	x1, x0
mov	x0, x19
bl Lpatch + (0xa5d4 - PATCH_BASE)
cbz	w0, LFQH_LBB233_32
LFQH_Lloh3740:
adr x0, LFQH_l_.str.267
LFQH_Lloh3741:
nop
bl Lpatch + (0xa5b0 - PATCH_BASE)
mov	x22, x0
LFQH_Lloh3742:
adr x0, LFQH_l_.str.334
LFQH_Lloh3743:
nop
bl Lpatch + (0xa5a4 - PATCH_BASE)
mov	x1, x0
mov	w21, #1
mov	x0, x22
mov	w2, #1
bl Lpatch + (0xa5d4 - PATCH_BASE)
mov	x2, x0
LFQH_Lloh3744:
adr x1, LFQH_TopChromeEdgeHiddenKey
LFQH_Lloh3745:
nop
mov	x0, x20
mov	w3, #1
bl Lpatch + (0xa634 - PATCH_BASE)
LFQH_Lloh3746:
adr x0, LFQH_l_.str.522
LFQH_Lloh3747:
nop
bl Lpatch + (0xa5a4 - PATCH_BASE)
mov	x1, x0
mov	x0, x19
mov	w2, #0
bl Lpatch + (0xa5d4 - PATCH_BASE)
b	LFQH_LBB233_30
LFQH_LBB233_25:
LFQH_Lloh3748:
adr x0, LFQH_l_.str.524
LFQH_Lloh3749:
nop
bl Lpatch + (0xa5b0 - PATCH_BASE)
cbz	x0, LFQH_LBB233_29
mov	x20, x0
LFQH_Lloh3750:
adr x1, LFQH_l_.str.525
LFQH_Lloh3751:
nop
mov	x0, x22
bl	LFQH_Responds
cbz	w0, LFQH_LBB233_29
LFQH_Lloh3752:
adr x0, LFQH_l_.str.76
LFQH_Lloh3753:
nop
bl Lpatch + (0xa5a4 - PATCH_BASE)
mov	x1, x0
mov	x0, x20
bl Lpatch + (0xa5d4 - PATCH_BASE)
mov	x20, x0
LFQH_Lloh3754:
adr x0, LFQH_l_.str.77
LFQH_Lloh3755:
nop
bl Lpatch + (0xa5a4 - PATCH_BASE)
mov	x1, x0
mov	x0, x20
bl Lpatch + (0xa5d4 - PATCH_BASE)
cbz	x0, LFQH_LBB233_29
mov	x20, x0
LFQH_Lloh3756:
adr x0, LFQH_l_.str.526
LFQH_Lloh3757:
nop
bl Lpatch + (0xa5a4 - PATCH_BASE)
mov	x1, x0
mov	x0, x20
mov	x2, x24
bl Lpatch + (0xa5d4 - PATCH_BASE)
LFQH_Lloh3758:
adr x0, LFQH_l_.str.527
LFQH_Lloh3759:
nop
bl Lpatch + (0xa5a4 - PATCH_BASE)
mov	x1, x0
mov	x0, x20
mov	w2, #1
bl Lpatch + (0xa5d4 - PATCH_BASE)
LFQH_Lloh3760:
adr x0, LFQH_l_.str.525
LFQH_Lloh3761:
nop
bl Lpatch + (0xa5a4 - PATCH_BASE)
mov	x1, x0
mov	x0, x22
mov	x2, x20
bl Lpatch + (0xa5d4 - PATCH_BASE)
LFQH_Lloh3762:
adr x1, LFQH_TopChromeEdgeInteractionKey
LFQH_Lloh3763:
nop
mov	x0, x22
mov	x2, x20
mov	w3, #1
bl Lpatch + (0xa634 - PATCH_BASE)
LFQH_Lloh3764:
adr x0, LFQH_l_.str.55
LFQH_Lloh3765:
nop
bl Lpatch + (0xa5a4 - PATCH_BASE)
mov	x1, x0
mov	x0, x20
bl Lpatch + (0xa5d4 - PATCH_BASE)
b	LFQH_LBB233_20
LFQH_LBB233_29:
mov	w21, #0
LFQH_LBB233_30:
mov	x0, x21
ldp	x29, x30, [sp, #80]
ldp	x20, x19, [sp, #64]
ldp	x22, x21, [sp, #48]
ldp	x24, x23, [sp, #32]
ldp	x26, x25, [sp, #16]
ldp	x28, x27, [sp], #96
ret
LFQH_LBB233_31:
mov	w25, #0
cbnz	x20, LFQH_LBB233_8
b	LFQH_LBB233_18
LFQH_LBB233_32:
mov	w21, #1
b	LFQH_LBB233_30
.cfi_endproc
.p2align	2
LFQH_TopChrome:
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
mov	x22, x2
mov.16b	v8, v3
mov.16b	v9, v2
mov.16b	v10, v1
mov.16b	v11, v0
mov	x20, x1
mov	x19, x0
LFQH_Lloh3766:
adr x1, LFQH_TopChromeSurfaceKey
LFQH_Lloh3767:
nop
bl Lpatch + (0xa628 - PATCH_BASE)
mov	x21, x0
cbz	x19, LFQH_LBB234_4
cbz	w22, LFQH_LBB234_4
LFQH_Lloh3768:
adr x1, LFQH_l_.str.20
LFQH_Lloh3769:
nop
mov	x0, x20
bl	LFQH_Get
cmp	x0, x19
b.ne	LFQH_LBB234_4
fmov	x8, d9
fmov	x9, d10
fmov	x10, d11
ubfx	x10, x10, #52, #11
ubfx	x9, x9, #52, #11
ubfx	x8, x8, #52, #11
cmp	x8, #2046
mov	w8, #2046
ccmp	x9, x8, #2, ls
ccmp	x10, x8, #2, ls
b.ls	LFQH_LBB234_7
LFQH_LBB234_4:
LFQH_Lloh3770:
adr x0, LFQH_l_.str.302
LFQH_Lloh3771:
nop
bl Lpatch + (0xa5a4 - PATCH_BASE)
mov	x1, x0
mov	x0, x21
bl Lpatch + (0xa5d4 - PATCH_BASE)
LFQH_Lloh3772:
adr x1, LFQH_TopChromeAnchorKey
LFQH_Lloh3773:
nop
mov	x0, x21
mov	x2, #0
mov	w3, #1
bl Lpatch + (0xa634 - PATCH_BASE)
LFQH_Lloh3774:
adr x1, LFQH_TopChromeSurfaceKey
LFQH_Lloh3775:
nop
mov	x0, x19
mov	x2, #0
mov	w3, #1
bl Lpatch + (0xa634 - PATCH_BASE)
LFQH_LBB234_5:
mov	w19, #0
LFQH_LBB234_6:
mov	x0, x19
ldp	x29, x30, [sp, #64]
ldp	x20, x19, [sp, #48]
ldp	x22, x21, [sp, #32]
ldp	d9, d8, [sp, #16]
ldp	d11, d10, [sp], #80
ret
LFQH_LBB234_7:
fmov	x8, d8
ubfx	x8, x8, #52, #11
cmp	x8, #2046
b.hi	LFQH_LBB234_4
fcmp	d9, #0.0
b.le	LFQH_LBB234_4
fcmp	d8, #0.0
b.le	LFQH_LBB234_4
cbz	x21, LFQH_LBB234_19
LFQH_LBB234_11:
LFQH_Lloh3776:
adr x0, LFQH_l_.str.249
LFQH_Lloh3777:
nop
bl Lpatch + (0xa5a4 - PATCH_BASE)
mov	x1, x0
mov	x0, x21
bl Lpatch + (0xa5d4 - PATCH_BASE)
fcmp	d0, d11
b.ne	LFQH_LBB234_15
fcmp	d1, d10
b.ne	LFQH_LBB234_15
fcmp	d2, d9
b.ne	LFQH_LBB234_15
fcmp	d3, d8
b.eq	LFQH_LBB234_16
LFQH_LBB234_15:
LFQH_Lloh3778:
adr x0, LFQH_l_.str.78
LFQH_Lloh3779:
nop
bl Lpatch + (0xa5a4 - PATCH_BASE)
mov	x1, x0
mov	x0, x21
mov.16b	v0, v11
mov.16b	v1, v10
mov.16b	v2, v9
mov.16b	v3, v8
bl Lpatch + (0xa5d4 - PATCH_BASE)
LFQH_LBB234_16:
LFQH_Lloh3780:
adr x1, LFQH_l_.str.20
LFQH_Lloh3781:
nop
mov	x0, x21
bl	LFQH_Get
cmp	x0, x19
b.ne	LFQH_LBB234_18
LFQH_Lloh3782:
adr x1, LFQH_TopChromeAnchorKey
LFQH_Lloh3783:
nop
mov	x0, x21
bl Lpatch + (0xa628 - PATCH_BASE)
cmp	x0, x20
b.eq	LFQH_LBB234_22
LFQH_LBB234_18:
LFQH_Lloh3784:
adr x0, LFQH_l_.str.298
LFQH_Lloh3785:
nop
bl Lpatch + (0xa5a4 - PATCH_BASE)
mov	x1, x0
mov	x0, x19
mov	x2, x21
mov	x3, x20
bl Lpatch + (0xa5d4 - PATCH_BASE)
LFQH_Lloh3786:
adr x1, LFQH_TopChromeAnchorKey
LFQH_Lloh3787:
nop
mov	w19, #1
mov	x0, x21
mov	x2, x20
mov	w3, #1
bl Lpatch + (0xa634 - PATCH_BASE)
b	LFQH_LBB234_6
LFQH_LBB234_19:
LFQH_Lloh3788:
adr x0, LFQH_l_.str.528
LFQH_Lloh3789:
nop
bl Lpatch + (0xa5b0 - PATCH_BASE)
mov	x21, x0
LFQH_Lloh3790:
adr x0, LFQH_l_.str.13
LFQH_Lloh3791:
nop
bl Lpatch + (0xa5a4 - PATCH_BASE)
mov	x1, x0
mov	x0, x21
mov	w2, #6
bl Lpatch + (0xa5d4 - PATCH_BASE)
cbz	x0, LFQH_LBB234_5
mov	x21, x0
LFQH_Lloh3792:
adr x0, LFQH_l_.str.16
LFQH_Lloh3793:
nop
bl Lpatch + (0xa5b0 - PATCH_BASE)
mov	x22, x0
LFQH_Lloh3794:
adr x0, LFQH_l_.str.76
LFQH_Lloh3795:
nop
bl Lpatch + (0xa5a4 - PATCH_BASE)
mov	x1, x0
mov	x0, x22
bl Lpatch + (0xa5d4 - PATCH_BASE)
mov	x22, x0
LFQH_Lloh3796:
adr x0, LFQH_l_.str.258
LFQH_Lloh3797:
nop
bl Lpatch + (0xa5a4 - PATCH_BASE)
mov	x1, x0
mov	x0, x22
mov	x2, x21
bl Lpatch + (0xa5d4 - PATCH_BASE)
cbz	x0, LFQH_LBB234_5
mov	x21, x0
LFQH_Lloh3798:
adr x0, LFQH_l_.str.259
LFQH_Lloh3799:
nop
bl Lpatch + (0xa5a4 - PATCH_BASE)
mov	x1, x0
mov	x0, x21
mov	w2, #0
bl Lpatch + (0xa5d4 - PATCH_BASE)
LFQH_Lloh3800:
adr x0, LFQH_l_.str.260
LFQH_Lloh3801:
nop
bl Lpatch + (0xa5a4 - PATCH_BASE)
mov	x1, x0
mov	x0, x21
mov	w2, #1
bl Lpatch + (0xa5d4 - PATCH_BASE)
LFQH_Lloh3802:
adr x0, LFQH_l_.str.262
LFQH_Lloh3803:
nop
bl Lpatch + (0xa5a4 - PATCH_BASE)
mov	x1, x0
mov	x0, x21
mov	w2, #0
bl Lpatch + (0xa5d4 - PATCH_BASE)
LFQH_Lloh3804:
adr x1, LFQH_TopChromeSurfaceKey
LFQH_Lloh3805:
nop
mov	x0, x19
mov	x2, x21
mov	w3, #1
bl Lpatch + (0xa634 - PATCH_BASE)
LFQH_Lloh3806:
adr x0, LFQH_l_.str.55
LFQH_Lloh3807:
nop
bl Lpatch + (0xa5a4 - PATCH_BASE)
mov	x1, x0
mov	x0, x21
bl Lpatch + (0xa5d4 - PATCH_BASE)
b	LFQH_LBB234_11
LFQH_LBB234_22:
mov	w19, #1
b	LFQH_LBB234_6
.cfi_endproc
.p2align	2
LFQH_TopChromeEdgeInteractionKey:
.cfi_startproc
ret
.cfi_endproc
.p2align	2
LFQH_TopChromeEdgeStyleKey:
.cfi_startproc
ret
.cfi_endproc
.p2align	2
LFQH_TopChromeEdgeHiddenKey:
.cfi_startproc
ret
.cfi_endproc
.p2align	2
LFQH_TopChromeSurfaceKey:
.cfi_startproc
ret
.cfi_endproc
.p2align	2
LFQH_TopChromeAnchorKey:
.cfi_startproc
ret
.cfi_endproc
.p2align	2
LFQH_TopChromeColorKey:
.cfi_startproc
ret
.cfi_endproc
.p2align	2
LFQH_TopChromeOpaqueKey:
.cfi_startproc
ret
.cfi_endproc
.p2align	2
LFQH_TopChromeStockFrame:
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
mov.16b	v11, v1
mov.16b	v10, v0
mov	x19, x0
LFQH_Lloh3808:
adr x1, LFQH_TopChromeFrameKey
LFQH_Lloh3809:
nop
bl Lpatch + (0xa628 - PATCH_BASE)
cbz	x0, LFQH_LBB242_3
mov	x20, x0
LFQH_Lloh3810:
adr x0, LFQH_l_.str.286
LFQH_Lloh3811:
nop
bl Lpatch + (0xa5a4 - PATCH_BASE)
mov	x1, x0
mov	x0, x20
bl Lpatch + (0xa5d4 - PATCH_BASE)
fcmp	d11, d1
b.ne	LFQH_LBB242_3
LFQH_Lloh3812:
adr x1, LFQH_TopChromeStockFrameKey
LFQH_Lloh3813:
nop
mov	x0, x19
bl Lpatch + (0xa628 - PATCH_BASE)
mov	x19, x0
LFQH_Lloh3814:
adr x0, LFQH_l_.str.286
LFQH_Lloh3815:
nop
bl Lpatch + (0xa5a4 - PATCH_BASE)
mov	x1, x0
mov	x0, x19
bl Lpatch + (0xa5d4 - PATCH_BASE)
fsub	d0, d11, d1
fadd	d8, d8, d0
mov.16b	v11, v1
LFQH_LBB242_3:
mov.16b	v0, v10
mov.16b	v1, v11
mov.16b	v2, v9
mov.16b	v3, v8
ldp	x29, x30, [sp, #48]
ldp	x20, x19, [sp, #32]
ldp	d9, d8, [sp, #16]
ldp	d11, d10, [sp], #64
ret
.cfi_endproc
.p2align	2
LFQH_TopChromeFrameKey:
.cfi_startproc
ret
.cfi_endproc
.p2align	2
LFQH_TopChromeContains:
.cfi_startproc
cbz	x0, LFQH_LBB244_8
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
LFQH_Lloh3816:
adr x1, LFQH_l_.str.515
LFQH_Lloh3817:
nop
mov	x0, x20
bl	LFQH_Kind
mov	x8, x0
mov	w0, #0
cbz	w8, LFQH_LBB244_7
cbz	x20, LFQH_LBB244_7
LFQH_Lloh3818:
adr x21, LFQH_l_.str.20
LFQH_Lloh3819:
nop
LFQH_LBB244_4:
cmp	x20, x19
b.eq	LFQH_LBB244_6
mov	x0, x20
mov	x1, x21
bl	LFQH_Get
mov	x20, x0
cbnz	x0, LFQH_LBB244_4
b	LFQH_LBB244_7
LFQH_LBB244_6:
mov	w0, #1
LFQH_LBB244_7:
ldp	x29, x30, [sp, #32]
ldp	x20, x19, [sp, #16]
ldp	x22, x21, [sp], #48
LFQH_LBB244_8:
ret
.cfi_endproc
.p2align	2
LFQH_TopChromeScrollKey:
.cfi_startproc
ret
.cfi_endproc
.p2align	2
LFQH_TopChromeInsets:
.cfi_startproc
sub	sp, sp, #128
stp	d15, d14, [sp, #16]
stp	d13, d12, [sp, #32]
stp	d11, d10, [sp, #48]
stp	d9, d8, [sp, #64]
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
.cfi_offset b8, -56
.cfi_offset b9, -64
.cfi_offset b10, -72
.cfi_offset b11, -80
.cfi_offset b12, -88
.cfi_offset b13, -96
.cfi_offset b14, -104
.cfi_offset b15, -112
cbz	x0, LFQH_LBB246_16
mov.16b	v11, v0
mov	x19, x0
LFQH_Lloh3820:
adr x0, LFQH_l_.str.529
LFQH_Lloh3821:
nop
bl Lpatch + (0xa5a4 - PATCH_BASE)
mov	x1, x0
mov	x0, x19
bl Lpatch + (0xa5d4 - PATCH_BASE)
mov.16b	v12, v0
mov.16b	v9, v1
mov.16b	v10, v2
str	d3, [sp, #8]
LFQH_Lloh3822:
adr x1, LFQH_TopChromeInsetKey
LFQH_Lloh3823:
nop
mov	x0, x19
bl Lpatch + (0xa628 - PATCH_BASE)
mov	x20, x0
LFQH_Lloh3824:
adr x1, LFQH_TopChromeStockInsetKey
LFQH_Lloh3825:
nop
mov	x0, x19
bl Lpatch + (0xa628 - PATCH_BASE)
mov	x21, x0
LFQH_Lloh3826:
adr x22, LFQH_l_.str.266
LFQH_Lloh3827:
nop
mov	x0, x22
bl Lpatch + (0xa5a4 - PATCH_BASE)
mov	x1, x0
mov	x0, x21
bl Lpatch + (0xa5d4 - PATCH_BASE)
mov.16b	v14, v0
mov	x0, x22
bl Lpatch + (0xa5a4 - PATCH_BASE)
mov	x1, x0
mov	x0, x20
bl Lpatch + (0xa5d4 - PATCH_BASE)
mov.16b	v15, v0
cmp	x20, #0
cset	w8, ne
cset	w9, eq
fcmp	d12, d0
csel	w22, wzr, w8, eq
csinc	w8, w9, wzr, eq
cmp	w8, #0
fcsel	d8, d12, d14, ne
fadd	d13, d11, d8
fcmp	d11, #0.0
b.le	LFQH_LBB246_8
cbz	x20, LFQH_LBB246_4
LFQH_Lloh3828:
adr x0, LFQH_l_.str.266
LFQH_Lloh3829:
nop
bl Lpatch + (0xa5a4 - PATCH_BASE)
mov	x1, x0
mov	x0, x20
bl Lpatch + (0xa5d4 - PATCH_BASE)
fcmp	d12, d0
b.eq	LFQH_LBB246_5
LFQH_LBB246_4:
LFQH_Lloh3830:
adr x0, LFQH_l_.str.267
LFQH_Lloh3831:
nop
bl Lpatch + (0xa5b0 - PATCH_BASE)
mov	x21, x0
LFQH_Lloh3832:
adr x0, LFQH_l_.str.268
LFQH_Lloh3833:
nop
bl Lpatch + (0xa5a4 - PATCH_BASE)
mov	x1, x0
mov	x0, x21
mov.16b	v0, v8
bl Lpatch + (0xa5d4 - PATCH_BASE)
mov	x2, x0
LFQH_Lloh3834:
adr x1, LFQH_TopChromeStockInsetKey
LFQH_Lloh3835:
nop
mov	x0, x19
mov	w3, #1
bl Lpatch + (0xa634 - PATCH_BASE)
LFQH_LBB246_5:
cbz	x20, LFQH_LBB246_7
fcmp	d13, d15
b.eq	LFQH_LBB246_8
LFQH_LBB246_7:
LFQH_Lloh3836:
adr x0, LFQH_l_.str.267
LFQH_Lloh3837:
nop
bl Lpatch + (0xa5b0 - PATCH_BASE)
mov	x21, x0
LFQH_Lloh3838:
adr x0, LFQH_l_.str.268
LFQH_Lloh3839:
nop
bl Lpatch + (0xa5a4 - PATCH_BASE)
mov	x1, x0
mov	x0, x21
mov.16b	v0, v13
bl Lpatch + (0xa5d4 - PATCH_BASE)
mov	x2, x0
LFQH_Lloh3840:
adr x1, LFQH_TopChromeInsetKey
LFQH_Lloh3841:
nop
mov	x0, x19
mov	w3, #1
bl Lpatch + (0xa634 - PATCH_BASE)
LFQH_LBB246_8:
fcmp	d11, #0.0
b.ne	LFQH_LBB246_11
cbz	x20, LFQH_LBB246_11
LFQH_Lloh3842:
adr x1, LFQH_TopChromeStockInsetKey
LFQH_Lloh3843:
nop
mov	x0, x19
mov	x2, #0
mov	w3, #1
bl Lpatch + (0xa634 - PATCH_BASE)
LFQH_Lloh3844:
adr x1, LFQH_TopChromeInsetKey
LFQH_Lloh3845:
nop
mov	x0, x19
mov	x2, #0
mov	w3, #1
bl Lpatch + (0xa634 - PATCH_BASE)
LFQH_LBB246_11:
fcmp	d11, #0.0
csel	w8, wzr, w22, ne
fcmp	d13, d12
ccmp	w8, #0, #0, eq
b.eq	LFQH_LBB246_16
str	d10, [sp]
mov.16b	v10, v9
LFQH_Lloh3846:
adr x0, LFQH_l_.str.530
LFQH_Lloh3847:
nop
bl Lpatch + (0xa5a4 - PATCH_BASE)
mov	x1, x0
mov	x0, x19
bl Lpatch + (0xa5d4 - PATCH_BASE)
mov.16b	v8, v0
mov.16b	v9, v1
LFQH_Lloh3848:
adr x0, LFQH_l_.str.531
LFQH_Lloh3849:
nop
bl Lpatch + (0xa5a4 - PATCH_BASE)
mov	x1, x0
mov	x0, x19
bl Lpatch + (0xa5d4 - PATCH_BASE)
fmov	d1, #0.50000000
fsub	d0, d1, d0
fcmp	d9, d0
cset	w8, hi
fsub	d0, d13, d12
fsub	d1, d15, d14
fsub	d1, d11, d1
tst	w22, w8
fcsel	d11, d1, d0, ne
fcmp	d13, d12
b.eq	LFQH_LBB246_14
LFQH_Lloh3850:
adr x0, LFQH_l_.str.532
LFQH_Lloh3851:
nop
bl Lpatch + (0xa5a4 - PATCH_BASE)
mov	x1, x0
mov	x0, x19
mov.16b	v0, v13
mov.16b	v1, v10
ldp	d2, d3, [sp]
bl Lpatch + (0xa5d4 - PATCH_BASE)
LFQH_LBB246_14:
fsub	d9, d9, d11
LFQH_Lloh3852:
adr x0, LFQH_l_.str.530
LFQH_Lloh3853:
nop
bl Lpatch + (0xa5a4 - PATCH_BASE)
mov	x1, x0
mov	x0, x19
bl Lpatch + (0xa5d4 - PATCH_BASE)
fcmp	d0, d8
b.ne	LFQH_LBB246_17
fcmp	d1, d9
b.ne	LFQH_LBB246_17
LFQH_LBB246_16:
ldp	x29, x30, [sp, #112]
ldp	x20, x19, [sp, #96]
ldp	x22, x21, [sp, #80]
ldp	d9, d8, [sp, #64]
ldp	d11, d10, [sp, #48]
ldp	d13, d12, [sp, #32]
ldp	d15, d14, [sp, #16]
add	sp, sp, #128
ret
LFQH_LBB246_17:
LFQH_Lloh3854:
adr x0, LFQH_l_.str.533
LFQH_Lloh3855:
nop
bl Lpatch + (0xa5a4 - PATCH_BASE)
mov	x1, x0
mov	x0, x19
mov.16b	v0, v8
mov.16b	v1, v9
ldp	x29, x30, [sp, #112]
ldp	x20, x19, [sp, #96]
ldp	x22, x21, [sp, #80]
ldp	d9, d8, [sp, #64]
ldp	d11, d10, [sp, #48]
ldp	d13, d12, [sp, #32]
ldp	d15, d14, [sp, #16]
add	sp, sp, #128
b Lpatch + (0xa5d4 - PATCH_BASE)
.cfi_endproc
.p2align	2
LFQH_TopChromeStockFrameKey:
.cfi_startproc
ret
.cfi_endproc
.p2align	2
LFQH_TopChromeInsetKey:
.cfi_startproc
ret
.cfi_endproc
.p2align	2
LFQH_TopChromeStockInsetKey:
.cfi_startproc
ret
.cfi_endproc
.p2align	2
LFQH_TopChromeGeometryKey:
.cfi_startproc
ret
.cfi_endproc
.p2align	2
LFQH_ProfileEntryGlass:
.cfi_startproc
sub	sp, sp, #320
stp	d15, d14, [sp, #176]
stp	d13, d12, [sp, #192]
stp	d11, d10, [sp, #208]
stp	d9, d8, [sp, #224]
stp	x28, x27, [sp, #240]
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
.cfi_offset w27, -72
.cfi_offset w28, -80
.cfi_offset b8, -88
.cfi_offset b9, -96
.cfi_offset b10, -104
.cfi_offset b11, -112
.cfi_offset b12, -120
.cfi_offset b13, -128
.cfi_offset b14, -136
.cfi_offset b15, -144
mov	x22, x1
mov	x21, x0
LFQH_Lloh3856:
adr x1, LFQH_l_.str.248
LFQH_Lloh3857:
nop
bl	LFQH_Get
cbz	x0, LFQH_LBB251_29
mov	x19, x0
LFQH_Lloh3858:
adr x1, LFQH_l_.str.543
LFQH_Lloh3859:
nop
mov	x0, x21
bl	LFQH_HasAncestor
tbnz	w0, #0, LFQH_LBB251_3
LFQH_Lloh3860:
adr x1, LFQH_l_.str.544
LFQH_Lloh3861:
nop
mov	x0, x21
bl	LFQH_HasAncestor
cbz	w0, LFQH_LBB251_7
LFQH_LBB251_3:
bl	LFQH_Enabled
cbz	w0, LFQH_LBB251_7
bl	LFQH_FQHGlassAvailable
cbz	w0, LFQH_LBB251_7
LFQH_Lloh3862:
adr x8, LFQH_l_.str.545
LFQH_Lloh3863:
nop
LFQH_Lloh3864:
adr x9, LFQH_l_.str.546
LFQH_Lloh3865:
nop
cmp	w22, #0
csel	x1, x9, x8, eq
mov	x0, x21
bl	LFQH_Get
mov	x20, x0
cbz	x0, LFQH_LBB251_8
LFQH_Lloh3866:
adr x8, LFQH_l_.str.547
LFQH_Lloh3867:
nop
LFQH_Lloh3868:
adr x9, LFQH_l_.str.548
LFQH_Lloh3869:
nop
cmp	w22, #0
csel	x1, x9, x8, eq
mov	x0, x21
bl	LFQH_Get
mov	x21, x0
b	LFQH_LBB251_9
LFQH_LBB251_7:
mov	x20, #0
LFQH_LBB251_8:
mov	x21, #0
LFQH_LBB251_9:
LFQH_Lloh3870:
adr x1, LFQH_l_.str.485
LFQH_Lloh3871:
nop
mov	x0, x20
bl	LFQH_Kind
cbz	w0, LFQH_LBB251_12
LFQH_Lloh3872:
adr x1, LFQH_l_.str.20
LFQH_Lloh3873:
nop
mov	x0, x20
bl	LFQH_Get
cmp	x0, x19
b.ne	LFQH_LBB251_12
LFQH_Lloh3874:
adr x0, LFQH_l_.str.292
LFQH_Lloh3875:
nop
bl Lpatch + (0xa5a4 - PATCH_BASE)
mov	x1, x0
mov	x0, x20
bl Lpatch + (0xa5d4 - PATCH_BASE)
cbz	w0, LFQH_LBB251_13
LFQH_LBB251_12:
mov	x0, x19
ldp	x29, x30, [sp, #304]
ldp	x20, x19, [sp, #288]
ldp	x22, x21, [sp, #272]
ldp	x24, x23, [sp, #256]
ldp	x28, x27, [sp, #240]
ldp	d9, d8, [sp, #224]
ldp	d11, d10, [sp, #208]
ldp	d13, d12, [sp, #192]
ldp	d15, d14, [sp, #176]
add	sp, sp, #320
b	LFQH_RestoreProfileEntry
LFQH_LBB251_13:
LFQH_Lloh3876:
adr x1, LFQH_l_.str.36
LFQH_Lloh3877:
nop
mov	x0, x21
bl	LFQH_Kind
cbz	w0, LFQH_LBB251_12
LFQH_Lloh3878:
adr x1, LFQH_l_.str.20
LFQH_Lloh3879:
nop
mov	x0, x21
bl	LFQH_Get
cmp	x0, x19
b.ne	LFQH_LBB251_12
LFQH_Lloh3880:
adr x1, LFQH_GlyphViewKey
LFQH_Lloh3881:
nop
mov	x0, x19
bl Lpatch + (0xa628 - PATCH_BASE)
mov	x23, x0
LFQH_Lloh3882:
adr x1, LFQH_ProfileCaptionKey
LFQH_Lloh3883:
nop
mov	x0, x19
bl Lpatch + (0xa628 - PATCH_BASE)
mov	x22, x0
cmp	x23, x20
b.eq	LFQH_LBB251_17
LFQH_Lloh3884:
adr x1, LFQH_GlyphViewKey
LFQH_Lloh3885:
nop
mov	x0, x19
bl	LFQH_RestoreProfileEntryFrame
LFQH_LBB251_17:
cmp	x22, x21
b.eq	LFQH_LBB251_19
LFQH_Lloh3886:
adr x1, LFQH_ProfileCaptionKey
LFQH_Lloh3887:
nop
mov	x0, x19
bl	LFQH_RestoreProfileEntryFrame
LFQH_LBB251_19:
LFQH_Lloh3888:
adr x0, LFQH_l_.str.24
LFQH_Lloh3889:
nop
bl Lpatch + (0xa5a4 - PATCH_BASE)
mov	x1, x0
mov	x0, x19
bl Lpatch + (0xa5d4 - PATCH_BASE)
str	d0, [sp, #152]
stp	d1, d2, [x29, #-144]
str	d3, [sp, #144]
LFQH_Lloh3890:
adr x24, LFQH_l_.str.249
LFQH_Lloh3891:
nop
mov	x0, x24
bl Lpatch + (0xa5a4 - PATCH_BASE)
mov	x1, x0
mov	x0, x21
bl Lpatch + (0xa5d4 - PATCH_BASE)
mov.16b	v10, v0
mov.16b	v13, v1
mov.16b	v14, v2
mov.16b	v15, v3
mov	x0, x24
bl Lpatch + (0xa5a4 - PATCH_BASE)
mov	x1, x0
mov	x0, x20
bl Lpatch + (0xa5d4 - PATCH_BASE)
mov.16b	v12, v0
mov.16b	v11, v1
mov.16b	v9, v2
mov.16b	v8, v3
mov	x0, x21
stp	d13, d10, [sp, #88]
mov.16b	v0, v10
mov.16b	v1, v13
stp	d15, d14, [sp, #72]
mov.16b	v2, v14
mov.16b	v3, v15
bl	LFQH_ProfileStockFrame
stp	d0, d2, [sp, #104]
mov.16b	v15, v1
mov.16b	v13, v3
mov	x0, x20
stp	d11, d12, [sp, #56]
mov.16b	v0, v12
mov.16b	v1, v11
stp	d9, d8, [sp, #40]
mov.16b	v2, v9
ldp	d9, d12, [sp, #144]
mov.16b	v3, v8
bl	LFQH_ProfileStockFrame
mov.16b	v8, v0
stp	d1, d2, [sp, #120]
str	d3, [sp, #136]
mov.16b	v0, v12
ldp	d1, d2, [x29, #-144]
mov.16b	v10, v1
mov.16b	v11, v2
mov.16b	v3, v9
bl	LFQH_VisibleRect
cbz	w0, LFQH_LBB251_12
fadd	d0, d15, d13
fsub	d0, d0, d10
fmov	d1, #5.00000000
fadd	d0, d0, d1
mov	x8, #4631389266797133824
fmov	d1, x8
fmaxnm	d0, d0, d1
fminnm	d9, d9, d0
fadd	d0, d10, d9
fsub	d0, d0, d13
fmov	d1, #-10.00000000
fadd	d0, d0, d1
fminnm	d3, d15, d0
fsub	d0, d15, d10
fadd	d0, d0, d1
fmov	d1, #24.00000000
fminnm	d0, d0, d1
str	d3, [sp, #144]
fsub	d1, d3, d10
fmov	d2, #-6.00000000
fadd	d1, d1, d2
fminnm	d14, d0, d1
fmov	d0, #12.00000000
fcmp	d14, d0
mov	x8, #4630826316843712512
fmov	d0, x8
fccmp	d11, d0, #8, ge
b.mi	LFQH_LBB251_12
mov.16b	v0, v8
ldp	d1, d2, [sp, #120]
ldr	d3, [sp, #136]
bl	LFQH_VisibleRect
cbz	w0, LFQH_LBB251_12
ldp	d0, d2, [sp, #104]
mov.16b	v1, v15
mov.16b	v3, v13
bl	LFQH_VisibleRect
tbz	w0, #0, LFQH_LBB251_12
mov	x0, x19
mov.16b	v0, v12
mov.16b	v1, v10
mov.16b	v2, v11
mov.16b	v3, v9
mov	w1, #1
bl	LFQH_ApplySurface
LFQH_Lloh3892:
adr x1, LFQH_SurfaceKey
LFQH_Lloh3893:
nop
mov	x0, x19
bl Lpatch + (0xa628 - PATCH_BASE)
cbz	x0, LFQH_LBB251_12
str	d8, [sp, #32]
ldp	d4, d5, [sp, #128]
fmaxnm	d0, d4, d5
fdiv	d0, d14, d0
fmov	d1, #5.00000000
fadd	d1, d10, d1
ldr	d10, [sp, #144]
fsub	d2, d10, d14
fmov	d3, #-3.00000000
fadd	d2, d2, d3
fminnm	d3, d1, d2
fmul	d8, d4, d0
fsub	d1, d11, d8
fmov	d2, #0.50000000
fmul	d1, d1, d2
fmul	d9, d5, d0
fsub	d0, d14, d9
fmul	d0, d0, d2
cmp	x23, x20
b.eq	LFQH_LBB251_26
LFQH_Lloh3894:
adr x1, LFQH_GlyphViewKey
LFQH_Lloh3895:
nop
mov	x0, x19
mov	x2, x20
mov	w3, #1
mov.16b	v11, v3
mov.16b	v14, v1
stur	d9, [x29, #-136]
mov.16b	v9, v8
mov.16b	v8, v10
mov.16b	v10, v0
bl Lpatch + (0xa634 - PATCH_BASE)
mov.16b	v0, v10
mov.16b	v10, v8
mov.16b	v8, v9
ldur	d9, [x29, #-136]
mov.16b	v1, v14
mov.16b	v3, v11
LFQH_LBB251_26:
fadd	d14, d12, d1
fadd	d12, d3, d0
cmp	x22, x21
b.eq	LFQH_LBB251_28
LFQH_Lloh3896:
adr x1, LFQH_ProfileCaptionKey
LFQH_Lloh3897:
nop
mov	x0, x19
mov	x2, x21
mov	w3, #1
bl Lpatch + (0xa634 - PATCH_BASE)
LFQH_LBB251_28:
stp	d8, d9, [sp, #16]
stp	d14, d12, [sp]
mov	x0, x20
ldp	d1, d0, [sp, #56]
ldp	d2, d3, [sp, #40]
ldr	d4, [sp, #32]
ldp	d5, d6, [sp, #120]
ldr	d7, [sp, #136]
bl	LFQH_ProfileSetFrame
ldp	d4, d6, [sp, #104]
stp	d6, d13, [sp, #16]
stp	d4, d10, [sp]
mov	x0, x21
ldp	d1, d0, [sp, #88]
ldp	d3, d2, [sp, #72]
mov.16b	v5, v15
mov.16b	v7, v13
bl	LFQH_ProfileSetFrame
LFQH_LBB251_29:
ldp	x29, x30, [sp, #304]
ldp	x20, x19, [sp, #288]
ldp	x22, x21, [sp, #272]
ldp	x24, x23, [sp, #256]
ldp	x28, x27, [sp, #240]
ldp	d9, d8, [sp, #224]
ldp	d11, d10, [sp, #208]
ldp	d13, d12, [sp, #192]
ldp	d15, d14, [sp, #176]
add	sp, sp, #320
ret
.cfi_endproc
.p2align	2
LFQH_RestoreProfileEntry:
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
LFQH_Lloh3898:
adr x1, LFQH_GlyphViewKey
LFQH_Lloh3899:
nop
bl	LFQH_RestoreProfileEntryFrame
LFQH_Lloh3900:
adr x1, LFQH_ProfileCaptionKey
LFQH_Lloh3901:
nop
mov	x0, x19
bl	LFQH_RestoreProfileEntryFrame
mov	x0, x19
ldp	x29, x30, [sp, #16]
ldp	x20, x19, [sp], #32
b	LFQH_PageRestore
.cfi_endproc
.p2align	2
LFQH_ProfileCaptionKey:
.cfi_startproc
ret
.cfi_endproc
.p2align	2
LFQH_RestoreProfileEntryFrame:
.cfi_startproc
stp	d15, d14, [sp, #-112]!
stp	d13, d12, [sp, #16]
stp	d11, d10, [sp, #32]
stp	d9, d8, [sp, #48]
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
.cfi_offset b8, -56
.cfi_offset b9, -64
.cfi_offset b10, -72
.cfi_offset b11, -80
.cfi_offset b12, -88
.cfi_offset b13, -96
.cfi_offset b14, -104
.cfi_offset b15, -112
mov	x19, x1
mov	x20, x0
bl Lpatch + (0xa628 - PATCH_BASE)
cbz	x0, LFQH_LBB254_4
mov	x21, x0
LFQH_Lloh3902:
adr x0, LFQH_l_.str.249
LFQH_Lloh3903:
nop
bl Lpatch + (0xa5a4 - PATCH_BASE)
mov	x1, x0
mov	x0, x21
bl Lpatch + (0xa5d4 - PATCH_BASE)
mov.16b	v12, v0
mov.16b	v13, v1
mov.16b	v14, v2
mov.16b	v15, v3
mov	x0, x21
bl	LFQH_ProfileStockFrame
fcmp	d12, d0
fccmp	d13, d1, #0, eq
fccmp	d14, d2, #0, eq
fccmp	d15, d3, #0, eq
b.eq	LFQH_LBB254_3
mov.16b	v8, v0
mov.16b	v9, v1
mov.16b	v10, v2
mov.16b	v11, v3
LFQH_Lloh3904:
adr x0, LFQH_l_.str.78
LFQH_Lloh3905:
nop
bl Lpatch + (0xa5a4 - PATCH_BASE)
mov	x1, x0
mov	x0, x21
mov.16b	v0, v8
mov.16b	v1, v9
mov.16b	v2, v10
mov.16b	v3, v11
bl Lpatch + (0xa5d4 - PATCH_BASE)
LFQH_LBB254_3:
LFQH_Lloh3906:
adr x1, LFQH_GlyphOriginalKey
LFQH_Lloh3907:
nop
mov	x0, x21
mov	x2, #0
mov	w3, #1
bl Lpatch + (0xa634 - PATCH_BASE)
LFQH_Lloh3908:
adr x1, LFQH_GlyphAppliedKey
LFQH_Lloh3909:
nop
mov	x0, x21
mov	x2, #0
mov	w3, #1
bl Lpatch + (0xa634 - PATCH_BASE)
mov	x0, x20
mov	x1, x19
mov	x2, #0
mov	w3, #1
ldp	x29, x30, [sp, #96]
ldp	x20, x19, [sp, #80]
ldp	x22, x21, [sp, #64]
ldp	d9, d8, [sp, #48]
ldp	d11, d10, [sp, #32]
ldp	d13, d12, [sp, #16]
ldp	d15, d14, [sp], #112
b Lpatch + (0xa634 - PATCH_BASE)
LFQH_LBB254_4:
ldp	x29, x30, [sp, #96]
ldp	x20, x19, [sp, #80]
ldp	x22, x21, [sp, #64]
ldp	d9, d8, [sp, #48]
ldp	d11, d10, [sp, #32]
ldp	d13, d12, [sp, #16]
ldp	d15, d14, [sp], #112
ret
.cfi_endproc
.p2align	2
LFQH_ProfileStockFrame:
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
mov	x19, x0
LFQH_Lloh3910:
adr x1, LFQH_GlyphAppliedKey
LFQH_Lloh3911:
nop
bl Lpatch + (0xa628 - PATCH_BASE)
cbz	x0, LFQH_LBB255_3
mov	x20, x0
LFQH_Lloh3912:
adr x0, LFQH_l_.str.286
LFQH_Lloh3913:
nop
bl Lpatch + (0xa5a4 - PATCH_BASE)
mov	x1, x0
mov	x0, x20
bl Lpatch + (0xa5d4 - PATCH_BASE)
fcmp	d11, d0
fccmp	d10, d1, #0, eq
fccmp	d9, d2, #0, eq
fccmp	d8, d3, #0, eq
b.ne	LFQH_LBB255_3
LFQH_Lloh3914:
adr x1, LFQH_GlyphOriginalKey
LFQH_Lloh3915:
nop
mov	x0, x19
bl Lpatch + (0xa628 - PATCH_BASE)
mov	x19, x0
LFQH_Lloh3916:
adr x0, LFQH_l_.str.286
LFQH_Lloh3917:
nop
bl Lpatch + (0xa5a4 - PATCH_BASE)
mov	x1, x0
mov	x0, x19
bl Lpatch + (0xa5d4 - PATCH_BASE)
mov.16b	v11, v0
mov.16b	v10, v1
mov.16b	v9, v2
mov.16b	v8, v3
LFQH_LBB255_3:
mov.16b	v0, v11
mov.16b	v1, v10
mov.16b	v2, v9
mov.16b	v3, v8
ldp	x29, x30, [sp, #48]
ldp	x20, x19, [sp, #32]
ldp	d9, d8, [sp, #16]
ldp	d11, d10, [sp], #64
ret
.cfi_endproc
.p2align	2
LFQH_ProfileSetFrame:
.cfi_startproc
stp	d15, d14, [sp, #-112]!
stp	d13, d12, [sp, #16]
stp	d11, d10, [sp, #32]
stp	d9, d8, [sp, #48]
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
.cfi_offset b8, -56
.cfi_offset b9, -64
.cfi_offset b10, -72
.cfi_offset b11, -80
.cfi_offset b12, -88
.cfi_offset b13, -96
.cfi_offset b14, -104
.cfi_offset b15, -112
ldp	d9, d8, [x29, #32]
ldp	d11, d10, [x29, #16]
fcmp	d0, d11
fccmp	d1, d10, #0, eq
fccmp	d2, d9, #0, eq
fccmp	d3, d8, #0, eq
b.eq	LFQH_LBB256_11
mov.16b	v12, v7
mov.16b	v13, v6
mov.16b	v14, v5
mov.16b	v15, v4
mov	x19, x0
LFQH_Lloh3918:
adr x1, LFQH_GlyphOriginalKey
LFQH_Lloh3919:
nop
bl Lpatch + (0xa628 - PATCH_BASE)
mov	x21, x0
LFQH_Lloh3920:
adr x1, LFQH_GlyphAppliedKey
LFQH_Lloh3921:
nop
mov	x0, x19
bl Lpatch + (0xa628 - PATCH_BASE)
mov	x20, x0
cbz	x21, LFQH_LBB256_3
LFQH_Lloh3922:
adr x0, LFQH_l_.str.286
LFQH_Lloh3923:
nop
bl Lpatch + (0xa5a4 - PATCH_BASE)
mov	x1, x0
mov	x0, x21
bl Lpatch + (0xa5d4 - PATCH_BASE)
fcmp	d15, d0
fccmp	d14, d1, #0, eq
fccmp	d13, d2, #0, eq
fccmp	d12, d3, #0, eq
b.eq	LFQH_LBB256_4
LFQH_LBB256_3:
LFQH_Lloh3924:
adr x0, LFQH_l_.str.287
LFQH_Lloh3925:
nop
bl Lpatch + (0xa5b0 - PATCH_BASE)
mov	x21, x0
LFQH_Lloh3926:
adr x0, LFQH_l_.str.288
LFQH_Lloh3927:
nop
bl Lpatch + (0xa5a4 - PATCH_BASE)
mov	x1, x0
mov	x0, x21
mov.16b	v0, v15
mov.16b	v1, v14
mov.16b	v2, v13
mov.16b	v3, v12
bl Lpatch + (0xa5d4 - PATCH_BASE)
mov	x2, x0
LFQH_Lloh3928:
adr x1, LFQH_GlyphOriginalKey
LFQH_Lloh3929:
nop
mov	x0, x19
mov	w3, #1
bl Lpatch + (0xa634 - PATCH_BASE)
LFQH_LBB256_4:
cbz	x20, LFQH_LBB256_9
LFQH_Lloh3930:
adr x0, LFQH_l_.str.286
LFQH_Lloh3931:
nop
bl Lpatch + (0xa5a4 - PATCH_BASE)
mov	x1, x0
mov	x0, x20
bl Lpatch + (0xa5d4 - PATCH_BASE)
fcmp	d11, d0
b.ne	LFQH_LBB256_9
fcmp	d10, d1
b.ne	LFQH_LBB256_9
fcmp	d9, d2
b.ne	LFQH_LBB256_9
fcmp	d8, d3
b.eq	LFQH_LBB256_10
LFQH_LBB256_9:
LFQH_Lloh3932:
adr x0, LFQH_l_.str.287
LFQH_Lloh3933:
nop
bl Lpatch + (0xa5b0 - PATCH_BASE)
mov	x20, x0
LFQH_Lloh3934:
adr x0, LFQH_l_.str.288
LFQH_Lloh3935:
nop
bl Lpatch + (0xa5a4 - PATCH_BASE)
mov	x1, x0
mov	x0, x20
mov.16b	v0, v11
mov.16b	v1, v10
mov.16b	v2, v9
mov.16b	v3, v8
bl Lpatch + (0xa5d4 - PATCH_BASE)
mov	x2, x0
LFQH_Lloh3936:
adr x1, LFQH_GlyphAppliedKey
LFQH_Lloh3937:
nop
mov	x0, x19
mov	w3, #1
bl Lpatch + (0xa634 - PATCH_BASE)
LFQH_LBB256_10:
LFQH_Lloh3938:
adr x0, LFQH_l_.str.78
LFQH_Lloh3939:
nop
bl Lpatch + (0xa5a4 - PATCH_BASE)
mov	x1, x0
mov	x0, x19
mov.16b	v0, v11
mov.16b	v1, v10
mov.16b	v2, v9
mov.16b	v3, v8
ldp	x29, x30, [sp, #96]
ldp	x20, x19, [sp, #80]
ldp	x22, x21, [sp, #64]
ldp	d9, d8, [sp, #48]
ldp	d11, d10, [sp, #32]
ldp	d13, d12, [sp, #16]
ldp	d15, d14, [sp], #112
b Lpatch + (0xa5d4 - PATCH_BASE)
LFQH_LBB256_11:
ldp	x29, x30, [sp, #96]
ldp	x20, x19, [sp, #80]
ldp	x22, x21, [sp, #64]
ldp	d9, d8, [sp, #48]
ldp	d11, d10, [sp, #32]
ldp	d13, d12, [sp, #16]
ldp	d15, d14, [sp], #112
ret
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
mov	x20, x4
mov	x21, x3
mov	x22, x2
mov	x23, x1
mov	x19, x0
LFQH_Lloh3940:
adr x0, LFQH_l_.str.182
LFQH_Lloh3941:
nop
LFQH_Lloh3942:
adr x1, LFQH_l_.str.579
LFQH_Lloh3943:
nop
bl	LFQH_Original
mov	x8, x0
mov	x0, x19
mov	x1, x23
mov	x2, x22
mov	x3, x21
mov	x4, x20
blr	x8
mov.16b	v8, v0
mov.16b	v9, v1
LFQH_Lloh3944:
adr x1, LFQH_ShelfCompactKey
LFQH_Lloh3945:
nop
mov	x0, x19
bl Lpatch + (0xa628 - PATCH_BASE)
cbz	x0, LFQH_LBB257_5
fmov	d0, #1.00000000
fcmp	d9, d0
b.le	LFQH_LBB257_5
LFQH_Lloh3946:
adr x0, LFQH_l_.str.583
LFQH_Lloh3947:
nop
bl Lpatch + (0xa5a4 - PATCH_BASE)
mov	x1, x0
mov	x0, x20
bl Lpatch + (0xa5d4 - PATCH_BASE)
mov	x1, x0
mov	x0, x19
bl	LFQH_ShelfFunctionSection
cbz	w0, LFQH_LBB257_5
LFQH_Lloh3948:
adr x0, LFQH_l_.str.571
LFQH_Lloh3949:
nop
bl Lpatch + (0xa5b0 - PATCH_BASE)
mov	x19, x0
bl Lpatch + (0xa664 - PATCH_BASE)
LFQH_Lloh3950:
adr x1, LFQH_l_.str.576
LFQH_Lloh3951:
nop
LFQH_Lloh3952:
adr x2, LFQH_l_.str.577
LFQH_Lloh3953:
nop
bl	LFQH_ClassABI
cbz	w0, LFQH_LBB257_5
LFQH_Lloh3954:
adr x0, LFQH_l_.str.576
LFQH_Lloh3955:
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
fmov	d0, #1.00000000
fcsel	d9, d1, d0, gt
LFQH_LBB257_5:
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
LFQH_ShelfFunctionInsets:
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
mov	x19, x4
mov	x21, x3
mov	x22, x2
mov	x23, x1
mov	x20, x0
LFQH_Lloh3956:
adr x0, LFQH_l_.str.182
LFQH_Lloh3957:
nop
LFQH_Lloh3958:
adr x1, LFQH_l_.str.581
LFQH_Lloh3959:
nop
bl	LFQH_Original
mov	x8, x0
mov	x0, x20
mov	x1, x23
mov	x2, x22
mov	x3, x21
mov	x4, x19
blr	x8
mov.16b	v10, v0
mov.16b	v8, v1
mov.16b	v11, v2
mov.16b	v9, v3
LFQH_Lloh3960:
adr x1, LFQH_ShelfCompactKey
LFQH_Lloh3961:
nop
mov	x0, x20
bl Lpatch + (0xa628 - PATCH_BASE)
cbz	x0, LFQH_LBB258_4
mov	x21, x0
bl Lpatch + (0xa664 - PATCH_BASE)
LFQH_Lloh3962:
adr x1, LFQH_l_.str.575
LFQH_Lloh3963:
nop
LFQH_Lloh3964:
adr x2, LFQH_l_.str.97
LFQH_Lloh3965:
nop
bl	LFQH_ClassABI
cbz	w0, LFQH_LBB258_4
LFQH_Lloh3966:
adr x0, LFQH_l_.str.575
LFQH_Lloh3967:
nop
bl Lpatch + (0xa5a4 - PATCH_BASE)
mov	x1, x0
mov	x0, x21
bl Lpatch + (0xa5d4 - PATCH_BASE)
cbnz	w0, LFQH_LBB258_4
mov	x0, x20
mov	x1, x19
bl	LFQH_ShelfFunctionSection
cmp	w0, #0
fmov	d0, xzr
fcsel	d10, d10, d0, eq
fcsel	d11, d11, d0, eq
LFQH_LBB258_4:
mov.16b	v0, v10
mov.16b	v1, v8
mov.16b	v2, v11
mov.16b	v3, v9
ldp	x29, x30, [sp, #80]
ldp	x20, x19, [sp, #64]
ldp	x22, x21, [sp, #48]
ldp	x24, x23, [sp, #32]
ldp	d9, d8, [sp, #16]
ldp	d11, d10, [sp], #96
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
LFQH_Lloh3968:
adr x0, LFQH_l_.str.571
LFQH_Lloh3969:
nop
LFQH_Lloh3970:
adr x1, LFQH_l_.str.359
LFQH_Lloh3971:
nop
bl	LFQH_Original
mov	x8, x0
mov	x0, x19
mov	x1, x20
blr	x8
LFQH_Lloh3972:
adr x1, LFQH_l_.str.369
LFQH_Lloh3973:
nop
mov	x0, x19
bl	LFQH_Get
LFQH_Lloh3974:
adr x1, LFQH_ShelfCompactKey
LFQH_Lloh3975:
nop
bl Lpatch + (0xa628 - PATCH_BASE)
cmp	x0, x19
b.eq	LFQH_LBB259_2
LFQH_LBB259_1:
ldp	x29, x30, [sp, #64]
ldp	x20, x19, [sp, #48]
ldp	d9, d8, [sp, #32]
ldp	d11, d10, [sp, #16]
ldp	d13, d12, [sp], #80
ret
LFQH_LBB259_2:
mov	x0, x19
bl Lpatch + (0xa664 - PATCH_BASE)
LFQH_Lloh3976:
adr x1, LFQH_l_.str.575
LFQH_Lloh3977:
nop
LFQH_Lloh3978:
adr x2, LFQH_l_.str.97
LFQH_Lloh3979:
nop
bl	LFQH_ClassABI
cbz	w0, LFQH_LBB259_1
LFQH_Lloh3980:
adr x1, LFQH_l_.str.585
LFQH_Lloh3981:
nop
mov	x0, x19
bl	LFQH_Get
mov	x20, x0
LFQH_Lloh3982:
adr x0, LFQH_l_.str.249
LFQH_Lloh3983:
nop
bl Lpatch + (0xa5a4 - PATCH_BASE)
mov	x1, x0
mov	x0, x20
bl Lpatch + (0xa5d4 - PATCH_BASE)
mov.16b	v8, v0
mov.16b	v12, v1
mov.16b	v9, v2
mov.16b	v10, v3
LFQH_Lloh3984:
adr x0, LFQH_l_.str.575
LFQH_Lloh3985:
nop
bl Lpatch + (0xa5a4 - PATCH_BASE)
mov	x1, x0
mov	x0, x19
bl Lpatch + (0xa5d4 - PATCH_BASE)
cmp	w0, #0
fmov	d0, #2.00000000
fmov	d1, #13.00000000
fcsel	d11, d1, d0, eq
fcmp	d12, d11
b.le	LFQH_LBB259_1
LFQH_Lloh3986:
adr x0, LFQH_l_.str.78
LFQH_Lloh3987:
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
.cfi_endproc
.p2align	2
LFQH_ShelfFunctionSection:
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
LFQH_Lloh3988:
adr x1, LFQH_l_.str.584
LFQH_Lloh3989:
nop
bl	LFQH_Get
mov	x20, x0
bl Lpatch + (0xa664 - PATCH_BASE)
LFQH_Lloh3990:
adr x1, LFQH_l_.str.573
LFQH_Lloh3991:
nop
LFQH_Lloh3992:
adr x2, LFQH_l_.str.574
LFQH_Lloh3993:
nop
bl	LFQH_ClassABI
cbz	w0, LFQH_LBB260_2
LFQH_Lloh3994:
adr x0, LFQH_l_.str.573
LFQH_Lloh3995:
nop
bl Lpatch + (0xa5a4 - PATCH_BASE)
mov	x1, x0
mov	x0, x20
mov	x2, x19
bl Lpatch + (0xa5d4 - PATCH_BASE)
cmp	x0, #1
cset	w0, eq
LFQH_LBB260_2:
ldp	x29, x30, [sp, #16]
ldp	x20, x19, [sp], #32
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
LFQH_Lloh3996:
adr x1, LFQH_l_.str.589
LFQH_Lloh3997:
nop
bl	LFQH_Get
mov	x19, x0
LFQH_Lloh3998:
adr x1, LFQH_l_.str.290
LFQH_Lloh3999:
nop
bl	LFQH_Kind
cmp	w0, #0
ccmp	x19, #0, #4, ne
b.ne	LFQH_LBB261_2
LFQH_LBB261_1:
ldp	x29, x30, [sp, #48]
ldp	x20, x19, [sp, #32]
ldp	x22, x21, [sp, #16]
ldp	x24, x23, [sp], #64
ret
LFQH_LBB261_2:
mov	w22, #0
LFQH_Lloh4000:
adr x21, LFQH_l_.str.20
LFQH_Lloh4001:
nop
mov	x0, x19
LFQH_LBB261_3:
cmp	x0, x20
b.eq	LFQH_LBB261_6
mov	x1, x21
bl	LFQH_Get
cbz	x0, LFQH_LBB261_1
cmp	w22, #7
add	w22, w22, #1
b.lo	LFQH_LBB261_3
b	LFQH_LBB261_1
LFQH_LBB261_6:
LFQH_Lloh4002:
adr x0, LFQH_l_.str.590
LFQH_Lloh4003:
nop
bl Lpatch + (0xa5a4 - PATCH_BASE)
mov	x1, x0
mov	x0, x19
mov	x2, #0
bl Lpatch + (0xa5d4 - PATCH_BASE)
mov	x20, x0
LFQH_Lloh4004:
adr x1, LFQH_SpeechGlyphKey
LFQH_Lloh4005:
nop
mov	x0, x19
bl Lpatch + (0xa628 - PATCH_BASE)
mov	x21, x0
LFQH_Lloh4006:
adr x0, LFQH_l_.str.46
LFQH_Lloh4007:
nop
bl Lpatch + (0xa5b0 - PATCH_BASE)
mov	x22, x0
LFQH_Lloh4008:
adr x0, LFQH_l_.str.47
LFQH_Lloh4009:
nop
bl Lpatch + (0xa5a4 - PATCH_BASE)
mov	x1, x0
mov	x0, x22
bl Lpatch + (0xa5d4 - PATCH_BASE)
mov	x22, x0
LFQH_Lloh4010:
adr x1, LFQH_l_.str.591
LFQH_Lloh4011:
nop
mov	x0, x19
bl	LFQH_Get
mov	x24, x0
LFQH_Lloh4012:
adr x0, LFQH_l_.str.48
LFQH_Lloh4013:
nop
bl Lpatch + (0xa5a4 - PATCH_BASE)
mov	x1, x0
mov	x0, x24
mov	x2, x22
bl Lpatch + (0xa5d4 - PATCH_BASE)
mov	x23, x0
bl	LFQH_Enabled
cbz	w0, LFQH_LBB261_9
bl	LFQH_FQHGlassAvailable
cbz	w0, LFQH_LBB261_9
LFQH_Lloh4014:
adr x0, LFQH_l_.str.24
LFQH_Lloh4015:
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
b.ls	LFQH_LBB261_17
LFQH_LBB261_9:
cbz	x21, LFQH_LBB261_16
cmp	x20, x21
b.ne	LFQH_LBB261_12
LFQH_Lloh4016:
adr x1, LFQH_SpeechImageKey
LFQH_Lloh4017:
nop
mov	x0, x19
bl Lpatch + (0xa628 - PATCH_BASE)
mov	x20, x0
LFQH_Lloh4018:
adr x0, LFQH_l_.str.595
LFQH_Lloh4019:
nop
bl Lpatch + (0xa5a4 - PATCH_BASE)
mov	x1, x0
mov	x0, x19
mov	x2, x20
mov	x3, #0
bl Lpatch + (0xa5d4 - PATCH_BASE)
LFQH_LBB261_12:
LFQH_Lloh4020:
adr x1, LFQH_SpeechTintKey
LFQH_Lloh4021:
nop
mov	x0, x19
bl Lpatch + (0xa628 - PATCH_BASE)
cbz	w23, LFQH_LBB261_15
mov	x20, x0
cbz	x0, LFQH_LBB261_15
LFQH_Lloh4022:
adr x0, LFQH_l_.str.53
LFQH_Lloh4023:
nop
bl Lpatch + (0xa5a4 - PATCH_BASE)
mov	x1, x0
mov	x0, x19
mov	x2, x20
bl Lpatch + (0xa5d4 - PATCH_BASE)
LFQH_LBB261_15:
LFQH_Lloh4024:
adr x1, LFQH_SpeechImageKey
LFQH_Lloh4025:
nop
mov	x0, x19
mov	x2, #0
mov	w3, #1
bl Lpatch + (0xa634 - PATCH_BASE)
LFQH_Lloh4026:
adr x1, LFQH_SpeechGlyphKey
LFQH_Lloh4027:
nop
mov	x0, x19
mov	x2, #0
mov	w3, #1
bl Lpatch + (0xa634 - PATCH_BASE)
LFQH_Lloh4028:
adr x1, LFQH_SpeechTintKey
LFQH_Lloh4029:
nop
mov	x0, x19
mov	x2, #0
mov	w3, #1
bl Lpatch + (0xa634 - PATCH_BASE)
LFQH_LBB261_16:
LFQH_Lloh4030:
adr x1, LFQH_SurfaceKey
LFQH_Lloh4031:
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
LFQH_LBB261_17:
fmov	x8, d3
ubfx	x8, x8, #52, #11
cmp	x8, #2046
b.hi	LFQH_LBB261_9
fcmp	d2, #0.0
b.le	LFQH_LBB261_9
fcmp	d3, #0.0
b.le	LFQH_LBB261_9
cbnz	x21, LFQH_LBB261_22
LFQH_Lloh4032:
adr x0, LFQH_l_.str.592
LFQH_Lloh4033:
nop
bl Lpatch + (0xa5b0 - PATCH_BASE)
LFQH_Lloh4034:
adr x1, LFQH_l_.str.593
LFQH_Lloh4035:
nop
bl	LFQH_Get
mov	x21, x0
LFQH_Lloh4036:
adr x0, LFQH_l_.str.594
LFQH_Lloh4037:
nop
bl Lpatch + (0xa5a4 - PATCH_BASE)
mov	x1, x0
mov	x0, x21
mov	w2, #2
bl Lpatch + (0xa5d4 - PATCH_BASE)
mov	x21, x0
cbz	x0, LFQH_LBB261_1
LFQH_LBB261_22:
mov	x0, x19
bl	LFQH_FQHApply
LFQH_Lloh4038:
adr x1, LFQH_SurfaceKey
LFQH_Lloh4039:
nop
mov	x0, x19
bl Lpatch + (0xa628 - PATCH_BASE)
cbz	x0, LFQH_LBB261_1
cbnz	w23, LFQH_LBB261_25
LFQH_Lloh4040:
adr x1, LFQH_SpeechTintKey
LFQH_Lloh4041:
nop
mov	x0, x19
mov	x2, x24
mov	w3, #1
bl Lpatch + (0xa634 - PATCH_BASE)
LFQH_Lloh4042:
adr x0, LFQH_l_.str.53
LFQH_Lloh4043:
nop
bl Lpatch + (0xa5a4 - PATCH_BASE)
mov	x1, x0
mov	x0, x19
mov	x2, x22
bl Lpatch + (0xa5d4 - PATCH_BASE)
LFQH_LBB261_25:
cmp	x20, x21
b.eq	LFQH_LBB261_1
LFQH_Lloh4044:
adr x1, LFQH_SpeechImageKey
LFQH_Lloh4045:
nop
mov	x0, x19
mov	x2, x20
mov	w3, #1
bl Lpatch + (0xa634 - PATCH_BASE)
LFQH_Lloh4046:
adr x1, LFQH_SpeechGlyphKey
LFQH_Lloh4047:
nop
mov	x0, x19
mov	x2, x21
mov	w3, #1
bl Lpatch + (0xa634 - PATCH_BASE)
LFQH_Lloh4048:
adr x0, LFQH_l_.str.595
LFQH_Lloh4049:
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
.p2align	2
LFQH_BookstoreTopChrome:
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
mov	x19, x0
LFQH_Lloh4050:
adr x1, LFQH_l_.str.596
LFQH_Lloh4051:
nop
bl	LFQH_Get
mov	x24, x0
LFQH_Lloh4052:
adr x1, LFQH_l_.str.20
LFQH_Lloh4053:
nop
bl	LFQH_Get
mov	x20, x0
LFQH_Lloh4054:
adr x1, LFQH_l_.str.468
LFQH_Lloh4055:
nop
mov	x0, x19
bl	LFQH_Get
mov	x22, x0
mov	x0, x19
mov	x1, x22
bl	LFQH_BookstoreCurrentTab
mov	x26, x0
LFQH_Lloh4056:
adr x1, LFQH_l_.str.597
LFQH_Lloh4057:
nop
mov	x0, x19
bl	LFQH_Get
mov	x23, x0
LFQH_Lloh4058:
adr x1, LFQH_l_.str.604
LFQH_Lloh4059:
nop
mov	x0, x26
bl	LFQH_Get
mov	x21, x0
mov	x0, x22
mov	x1, x21
bl	LFQH_TopChromeContains
tbnz	w0, #0, LFQH_LBB265_4
LFQH_Lloh4060:
adr x1, LFQH_l_.str.364
LFQH_Lloh4061:
nop
mov	x0, x26
bl	LFQH_Get
mov	x21, x0
mov	x0, x22
mov	x1, x21
bl	LFQH_TopChromeContains
tbnz	w0, #0, LFQH_LBB265_4
LFQH_Lloh4062:
adr x1, LFQH_l_.str.605
LFQH_Lloh4063:
nop
mov	x0, x26
bl	LFQH_Get
mov	x21, x0
mov	x0, x22
mov	x1, x21
bl	LFQH_TopChromeContains
tbnz	w0, #0, LFQH_LBB265_4
LFQH_Lloh4064:
adr x1, LFQH_l_.str.606
LFQH_Lloh4065:
nop
mov	x0, x26
bl	LFQH_Get
mov	x21, x0
mov	x0, x22
mov	x1, x21
bl	LFQH_TopChromeContains
cmp	w0, #0
csel	x21, xzr, x21, eq
LFQH_LBB265_4:
LFQH_Lloh4066:
adr x1, LFQH_l_.str.607
LFQH_Lloh4067:
nop
mov	x0, x26
bl	LFQH_Get
mov	x25, x0
LFQH_Lloh4068:
adr x1, LFQH_l_.str.608
LFQH_Lloh4069:
nop
bl	LFQH_Kind
cbz	w0, LFQH_LBB265_6
mov	x0, x25
mov	x1, x21
bl	LFQH_TopChromeContains
tbnz	w0, #0, LFQH_LBB265_10
LFQH_LBB265_6:
LFQH_Lloh4070:
adr x1, LFQH_l_.str.201
LFQH_Lloh4071:
nop
mov	x0, x26
bl	LFQH_Kind
cbz	x21, LFQH_LBB265_9
cbz	w0, LFQH_LBB265_9
LFQH_Lloh4072:
adr x1, LFQH_l_.str.20
LFQH_Lloh4073:
nop
mov	x0, x21
bl	LFQH_Get
mov	x25, x0
LFQH_Lloh4074:
adr x1, LFQH_l_.str.609
LFQH_Lloh4075:
nop
mov	x0, x26
bl	LFQH_Get
cmp	x25, x0
b.eq	LFQH_LBB265_26
LFQH_LBB265_9:
mov	x25, x22
LFQH_LBB265_10:
LFQH_Lloh4076:
adr x27, LFQH_l_.str.20
LFQH_Lloh4077:
nop
mov	x0, x25
mov	x1, x27
bl	LFQH_Get
str	x0, [sp, #24]
LFQH_Lloh4078:
adr x28, LFQH_l_.str.249
LFQH_Lloh4079:
nop
mov	x0, x28
bl Lpatch + (0xa5a4 - PATCH_BASE)
mov	x1, x0
mov	x0, x24
bl Lpatch + (0xa5d4 - PATCH_BASE)
mov.16b	v12, v1
mov.16b	v13, v3
LFQH_Lloh4080:
adr x26, LFQH_l_.str.24
LFQH_Lloh4081:
nop
mov	x0, x26
bl Lpatch + (0xa5a4 - PATCH_BASE)
mov	x1, x0
mov	x0, x20
bl Lpatch + (0xa5d4 - PATCH_BASE)
mov.16b	v11, v0
mov.16b	v10, v1
stp	d2, d3, [sp, #8]
mov	x0, x26
bl Lpatch + (0xa5a4 - PATCH_BASE)
mov	x1, x0
mov	x0, x23
bl Lpatch + (0xa5d4 - PATCH_BASE)
mov.16b	v14, v0
mov.16b	v15, v1
mov.16b	v8, v2
mov.16b	v9, v3
LFQH_Lloh4082:
adr x0, LFQH_l_.str.303
LFQH_Lloh4083:
nop
bl Lpatch + (0xa5a4 - PATCH_BASE)
mov	x1, x0
mov	x0, x23
mov.16b	v0, v14
mov.16b	v1, v15
mov.16b	v2, v8
mov.16b	v3, v9
mov	x2, x20
bl Lpatch + (0xa5d4 - PATCH_BASE)
mov.16b	v8, v1
mov.16b	v9, v3
mov	x0, x28
bl Lpatch + (0xa5a4 - PATCH_BASE)
mov	x1, x0
mov	x0, x22
bl Lpatch + (0xa5d4 - PATCH_BASE)
mov	x0, x22
bl	LFQH_TopChromeStockFrame
mov.16b	v14, v1
fadd	d0, d12, d13
fadd	d1, d8, d9
fmaxnm	d8, d0, d1
mov	x0, x22
mov	x1, x27
bl	LFQH_Get
fmaxnm	d0, d8, d14
cmp	x0, x20
fcsel	d8, d0, d8, eq
cbz	x20, LFQH_LBB265_19
bl	LFQH_Enabled
mov	w3, #0
cbz	w0, LFQH_LBB265_20
cbz	x22, LFQH_LBB265_20
mov	w26, #0
mov	x0, x22
LFQH_LBB265_14:
cmp	x0, x20
b.eq	LFQH_LBB265_17
mov	x1, x27
bl	LFQH_Get
mov	w3, #0
cbz	x0, LFQH_LBB265_20
cmp	w26, #7
add	w26, w26, #1
b.lo	LFQH_LBB265_14
b	LFQH_LBB265_20
LFQH_LBB265_17:
cbz	x21, LFQH_LBB265_19
LFQH_Lloh4084:
adr x0, LFQH_l_.str.292
LFQH_Lloh4085:
nop
bl Lpatch + (0xa5a4 - PATCH_BASE)
mov	x1, x0
mov	x0, x24
bl Lpatch + (0xa5d4 - PATCH_BASE)
cmp	w0, #0
cset	w3, eq
b	LFQH_LBB265_20
LFQH_LBB265_19:
mov	w3, #0
LFQH_LBB265_20:
fsub	d3, d8, d10
mov	x0, x20
mov	x1, x24
mov	x2, x21
mov.16b	v0, v11
mov.16b	v1, v10
ldr	d8, [sp, #8]
mov.16b	v2, v8
bl	LFQH_TopChromePage
mov	x27, x0
mov	x0, x24
mov	x1, x27
bl	LFQH_TopChromeFill
LFQH_Lloh4086:
adr x1, LFQH_l_.str.598
LFQH_Lloh4087:
nop
mov	x0, x19
bl	LFQH_Get
mov	x1, x27
bl	LFQH_TopChromeFill
LFQH_Lloh4088:
adr x1, LFQH_l_.str.599
LFQH_Lloh4089:
nop
mov	x0, x19
bl	LFQH_Get
mov	x1, x27
bl	LFQH_TopChromeFill
mov	x0, x23
mov	x1, x27
bl	LFQH_TopChromeFill
LFQH_Lloh4090:
adr x1, LFQH_l_.str.364
LFQH_Lloh4091:
nop
mov	x0, x23
bl	LFQH_Get
mov	x1, x27
bl	LFQH_TopChromeFill
LFQH_Lloh4092:
adr x1, LFQH_l_.str.600
LFQH_Lloh4093:
nop
mov	x0, x19
bl	LFQH_Get
mov	x1, x22
mov	x2, x27
bl	LFQH_TopChromeArtwork
LFQH_Lloh4094:
adr x1, LFQH_BookstoreViewportKey
LFQH_Lloh4095:
nop
mov	x0, x19
bl Lpatch + (0xa628 - PATCH_BASE)
cmp	w27, #0
csel	x23, xzr, x25, eq
cmp	x0, x23
b.eq	LFQH_LBB265_25
mov	x22, x0
LFQH_Lloh4096:
adr x0, LFQH_l_.str.601
LFQH_Lloh4097:
nop
bl Lpatch + (0xa5a4 - PATCH_BASE)
mov	x1, x0
mov	x0, x22
bl Lpatch + (0xa5d4 - PATCH_BASE)
LFQH_Lloh4098:
adr x1, LFQH_BookstoreViewportKey
LFQH_Lloh4099:
nop
mov	x0, x19
mov	x2, x23
mov	w3, #1
bl Lpatch + (0xa634 - PATCH_BASE)
cbz	x22, LFQH_LBB265_24
cmp	x22, x25
b.eq	LFQH_LBB265_24
fmov	d0, xzr
mov	x0, x22
mov	x1, #0
mov	w2, #0
bl	LFQH_TopChromeUnderlap
LFQH_LBB265_24:
LFQH_Lloh4100:
adr x0, LFQH_l_.str.55
LFQH_Lloh4101:
nop
bl Lpatch + (0xa5a4 - PATCH_BASE)
mov	x1, x0
mov	x0, x22
bl Lpatch + (0xa5d4 - PATCH_BASE)
LFQH_LBB265_25:
LFQH_Lloh4102:
adr x0, LFQH_l_.str.303
LFQH_Lloh4103:
nop
bl Lpatch + (0xa5a4 - PATCH_BASE)
mov	x1, x0
mov	x0, x20
mov.16b	v0, v11
mov.16b	v1, v10
mov.16b	v2, v8
ldr	d3, [sp, #16]
ldr	x2, [sp, #24]
bl Lpatch + (0xa5d4 - PATCH_BASE)
mov.16b	v0, v1
mov	x0, x25
mov	x1, x21
mov	x2, x27
bl	LFQH_TopChromeUnderlap
LFQH_Lloh4104:
adr x1, LFQH_l_.str.602
LFQH_Lloh4105:
nop
mov	x0, x19
mov	x2, x20
mov	x3, x25
mov	x4, x21
mov	x5, x27
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
b	LFQH_TopChromeDiagnostics
LFQH_LBB265_26:
LFQH_Lloh4106:
adr x25, LFQH_l_.str.24
LFQH_Lloh4107:
nop
mov	x0, x25
bl Lpatch + (0xa5a4 - PATCH_BASE)
mov	x1, x0
mov	x0, x22
bl Lpatch + (0xa5d4 - PATCH_BASE)
mov.16b	v8, v0
mov.16b	v9, v1
mov.16b	v10, v2
mov.16b	v11, v3
LFQH_Lloh4108:
adr x0, LFQH_l_.str.303
LFQH_Lloh4109:
nop
bl Lpatch + (0xa5a4 - PATCH_BASE)
mov	x1, x0
mov	x0, x22
mov.16b	v0, v8
mov.16b	v1, v9
mov.16b	v2, v10
mov.16b	v3, v11
mov	x2, x20
bl Lpatch + (0xa5d4 - PATCH_BASE)
mov.16b	v8, v1
mov	x0, x25
bl Lpatch + (0xa5a4 - PATCH_BASE)
mov	x1, x0
mov	x0, x20
bl Lpatch + (0xa5d4 - PATCH_BASE)
fcmp	d8, d1
mov	x25, x21
b.ne	LFQH_LBB265_9
b	LFQH_LBB265_10
.cfi_endproc
.p2align	2
LFQH_BookstoreCurrentTab:
.cfi_startproc
stp	x20, x19, [sp, #-32]!
stp	x29, x30, [sp, #16]
add	x29, sp, #16
.cfi_def_cfa w29, 16
.cfi_offset w30, -8
.cfi_offset w29, -16
.cfi_offset w19, -24
.cfi_offset w20, -32
mov	x8, x1
mov	x19, x0
LFQH_Lloh4110:
adr x1, LFQH_l_.str.603
LFQH_Lloh4111:
nop
mov	x0, x8
bl	LFQH_Get
cbz	x0, LFQH_LBB266_2
ldp	x29, x30, [sp, #16]
ldp	x20, x19, [sp], #32
ret
LFQH_LBB266_2:
LFQH_Lloh4112:
adr x1, LFQH_l_.str.370
LFQH_Lloh4113:
nop
mov	x0, x19
ldp	x29, x30, [sp, #16]
ldp	x20, x19, [sp], #32
b	LFQH_Get
.cfi_endproc
.p2align	2
LFQH_TopChromeArtwork:
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
mov	x21, x2
mov	x20, x1
mov	x19, x0
LFQH_Lloh4114:
adr x1, LFQH_l_.str.23
LFQH_Lloh4115:
nop
bl	LFQH_Kind
cbz	w0, LFQH_LBB267_14
LFQH_Lloh4116:
adr x1, LFQH_l_.str.20
LFQH_Lloh4117:
nop
mov	x0, x19
bl	LFQH_Get
mov	w23, #0
cbz	w21, LFQH_LBB267_6
mov	x22, x0
cbz	x0, LFQH_LBB267_6
LFQH_Lloh4118:
adr x1, LFQH_l_.str.20
LFQH_Lloh4119:
nop
mov	x0, x20
bl	LFQH_Get
cmp	x0, x22
b.eq	LFQH_LBB267_5
mov	w23, #0
b	LFQH_LBB267_6
LFQH_LBB267_5:
LFQH_Lloh4120:
adr x1, LFQH_l_.str.279
LFQH_Lloh4121:
nop
mov	x0, x22
bl	LFQH_Get
mov	x21, x0
LFQH_Lloh4122:
adr x0, LFQH_l_.str.610
LFQH_Lloh4123:
nop
bl Lpatch + (0xa5a4 - PATCH_BASE)
mov	x22, x0
mov	x0, x21
mov	x1, x22
mov	x2, x19
bl Lpatch + (0xa5d4 - PATCH_BASE)
mov	x23, x0
mov	x0, x21
mov	x1, x22
mov	x2, x20
bl Lpatch + (0xa5d4 - PATCH_BASE)
cmp	x23, x0
cset	w23, hi
LFQH_LBB267_6:
LFQH_Lloh4124:
adr x0, LFQH_l_.str.362
LFQH_Lloh4125:
nop
bl Lpatch + (0xa5a4 - PATCH_BASE)
mov	x1, x0
mov	x0, x19
bl Lpatch + (0xa5d4 - PATCH_BASE)
mov.16b	v8, v0
LFQH_Lloh4126:
adr x1, LFQH_TopChromeArtworkAlphaKey
LFQH_Lloh4127:
nop
mov	x0, x19
bl Lpatch + (0xa628 - PATCH_BASE)
mov	x20, x0
cbz	w23, LFQH_LBB267_9
fmov	d0, #0.25000000
fcmp	d8, d0
b.le	LFQH_LBB267_9
LFQH_Lloh4128:
adr x0, LFQH_l_.str.267
LFQH_Lloh4129:
nop
bl Lpatch + (0xa5b0 - PATCH_BASE)
mov	x20, x0
LFQH_Lloh4130:
adr x0, LFQH_l_.str.268
LFQH_Lloh4131:
nop
bl Lpatch + (0xa5a4 - PATCH_BASE)
mov	x1, x0
mov	x0, x20
mov.16b	v0, v8
bl Lpatch + (0xa5d4 - PATCH_BASE)
mov	x2, x0
LFQH_Lloh4132:
adr x1, LFQH_TopChromeArtworkAlphaKey
LFQH_Lloh4133:
nop
mov	x0, x19
mov	w3, #1
bl Lpatch + (0xa634 - PATCH_BASE)
LFQH_Lloh4134:
adr x0, LFQH_l_.str.465
LFQH_Lloh4135:
nop
bl Lpatch + (0xa5a4 - PATCH_BASE)
mov	x1, x0
fmov	d0, #0.25000000
mov	x0, x19
ldp	x29, x30, [sp, #64]
ldp	x20, x19, [sp, #48]
ldp	x22, x21, [sp, #32]
ldp	x24, x23, [sp, #16]
ldp	d9, d8, [sp], #80
b Lpatch + (0xa5d4 - PATCH_BASE)
LFQH_LBB267_9:
tbnz	w23, #0, LFQH_LBB267_14
cbz	x20, LFQH_LBB267_14
fmov	d0, #0.25000000
fcmp	d8, d0
b.ne	LFQH_LBB267_13
LFQH_Lloh4136:
adr x0, LFQH_l_.str.465
LFQH_Lloh4137:
nop
bl Lpatch + (0xa5a4 - PATCH_BASE)
mov	x21, x0
LFQH_Lloh4138:
adr x0, LFQH_l_.str.266
LFQH_Lloh4139:
nop
bl Lpatch + (0xa5a4 - PATCH_BASE)
mov	x1, x0
mov	x0, x20
bl Lpatch + (0xa5d4 - PATCH_BASE)
mov	x0, x19
mov	x1, x21
bl Lpatch + (0xa5d4 - PATCH_BASE)
LFQH_LBB267_13:
LFQH_Lloh4140:
adr x1, LFQH_TopChromeArtworkAlphaKey
LFQH_Lloh4141:
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
LFQH_LBB267_14:
ldp	x29, x30, [sp, #64]
ldp	x20, x19, [sp, #48]
ldp	x22, x21, [sp, #32]
ldp	x24, x23, [sp, #16]
ldp	d9, d8, [sp], #80
ret
.cfi_endproc
.p2align	2
LFQH_BookstoreViewportKey:
.cfi_startproc
ret
.cfi_endproc
.p2align	2
LFQH_TopChromeArtworkAlphaKey:
.cfi_startproc
ret
.cfi_endproc
.p2align	2
LFQH_BookshelfTopChrome:
.cfi_startproc
stp	d13, d12, [sp, #-128]!
stp	d11, d10, [sp, #16]
stp	d9, d8, [sp, #32]
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
.cfi_offset b8, -88
.cfi_offset b9, -96
.cfi_offset b10, -104
.cfi_offset b11, -112
.cfi_offset b12, -120
.cfi_offset b13, -128
mov	x19, x0
LFQH_Lloh4142:
adr x1, LFQH_l_.str.404
LFQH_Lloh4143:
nop
bl	LFQH_Get
mov	x20, x0
LFQH_Lloh4144:
adr x1, LFQH_l_.str.355
LFQH_Lloh4145:
nop
mov	x0, x19
bl	LFQH_Get
mov	x24, x0
LFQH_Lloh4146:
adr x1, LFQH_l_.str.468
LFQH_Lloh4147:
nop
mov	x0, x19
bl	LFQH_Get
mov	x21, x0
LFQH_Lloh4148:
adr x1, LFQH_l_.str.370
LFQH_Lloh4149:
nop
mov	x0, x19
bl	LFQH_Get
mov	x23, x0
LFQH_Lloh4150:
adr x1, LFQH_l_.str.364
LFQH_Lloh4151:
nop
bl	LFQH_Get
mov	x22, x0
LFQH_Lloh4152:
adr x25, LFQH_l_.str.249
LFQH_Lloh4153:
nop
mov	x0, x25
bl Lpatch + (0xa5a4 - PATCH_BASE)
mov	x1, x0
mov	x0, x24
bl Lpatch + (0xa5d4 - PATCH_BASE)
mov.16b	v11, v1
mov.16b	v12, v3
LFQH_Lloh4154:
adr x0, LFQH_l_.str.24
LFQH_Lloh4155:
nop
bl Lpatch + (0xa5a4 - PATCH_BASE)
mov	x1, x0
mov	x0, x20
bl Lpatch + (0xa5d4 - PATCH_BASE)
mov.16b	v9, v0
mov.16b	v8, v1
mov.16b	v10, v2
mov	x0, x25
bl Lpatch + (0xa5a4 - PATCH_BASE)
mov	x1, x0
mov	x0, x21
bl Lpatch + (0xa5d4 - PATCH_BASE)
mov	x0, x21
bl	LFQH_TopChromeStockFrame
fadd	d0, d11, d12
fmaxnm	d0, d0, d1
fsub	d11, d0, d8
bl	LFQH_Enabled
cbz	w0, LFQH_LBB270_3
LFQH_Lloh4156:
adr x1, LFQH_l_.str.182
LFQH_Lloh4157:
nop
mov	x0, x23
bl	LFQH_Kind
cbz	w0, LFQH_LBB270_3
LFQH_Lloh4158:
adr x1, LFQH_l_.str.20
LFQH_Lloh4159:
nop
mov	x0, x21
bl	LFQH_Get
cmp	x0, x20
b.eq	LFQH_LBB270_7
LFQH_LBB270_3:
mov	w3, #0
LFQH_LBB270_4:
mov	x0, x20
mov	x1, x24
mov	x2, x22
mov.16b	v0, v9
mov.16b	v1, v8
mov.16b	v2, v10
mov.16b	v3, v11
bl	LFQH_TopChromePage
mov	x25, x0
LFQH_Lloh4160:
adr x1, LFQH_l_.str.372
LFQH_Lloh4161:
nop
mov	x0, x19
bl	LFQH_Get
mov	x26, x0
mov	x0, x24
mov	x1, x25
bl	LFQH_TopChromeFill
mov	x0, x26
mov	x1, x25
bl	LFQH_TopChromeFill
LFQH_Lloh4162:
adr x1, LFQH_l_.str.364
LFQH_Lloh4163:
nop
mov	x0, x26
bl	LFQH_Get
mov	x1, x25
bl	LFQH_TopChromeFill
LFQH_Lloh4164:
adr x1, LFQH_l_.str.611
LFQH_Lloh4165:
nop
mov	x0, x19
bl	LFQH_Get
mov	x1, x25
bl	LFQH_TopChromeFill
LFQH_Lloh4166:
adr x1, LFQH_l_.str.612
LFQH_Lloh4167:
nop
mov	x0, x19
bl	LFQH_Get
mov	x1, x21
mov	x2, x25
bl	LFQH_TopChromeArtwork
mov	x0, x21
mov	x1, x22
mov.16b	v0, v8
mov	x2, x25
bl	LFQH_TopChromeUnderlap
LFQH_Lloh4168:
adr x1, LFQH_l_.str.182
LFQH_Lloh4169:
nop
mov	x0, x23
bl	LFQH_Kind
cbz	w0, LFQH_LBB270_6
mov	x0, x22
bl	LFQH_TopChromeOverlap
mov	x0, x23
bl	LFQH_BookshelfFloatingChrome
LFQH_LBB270_6:
LFQH_Lloh4170:
adr x1, LFQH_l_.str.613
LFQH_Lloh4171:
nop
mov	x0, x19
mov	x2, x20
mov	x3, x21
mov	x4, x22
mov	x5, x25
ldp	x29, x30, [sp, #112]
ldp	x20, x19, [sp, #96]
ldp	x22, x21, [sp, #80]
ldp	x24, x23, [sp, #64]
ldp	x26, x25, [sp, #48]
ldp	d9, d8, [sp, #32]
ldp	d11, d10, [sp, #16]
ldp	d13, d12, [sp], #128
b	LFQH_TopChromeDiagnostics
LFQH_LBB270_7:
mov	x0, x21
mov	x1, x22
bl	LFQH_TopChromeContains
mov	x3, x0
b	LFQH_LBB270_4
.cfi_endproc
.p2align	2
LFQH_BookshelfFloatingChrome:
.cfi_startproc
stp	d15, d14, [sp, #-144]!
stp	d13, d12, [sp, #16]
stp	d11, d10, [sp, #32]
stp	d9, d8, [sp, #48]
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
.cfi_offset b8, -88
.cfi_offset b9, -96
.cfi_offset b10, -104
.cfi_offset b11, -112
.cfi_offset b12, -120
.cfi_offset b13, -128
.cfi_offset b14, -136
.cfi_offset b15, -144
mov.16b	v8, v0
mov	x22, x0
LFQH_Lloh4172:
adr x1, LFQH_l_.str.614
LFQH_Lloh4173:
nop
bl	LFQH_Get
mov	x19, x0
LFQH_Lloh4174:
adr x1, LFQH_l_.str.23
LFQH_Lloh4175:
nop
bl	LFQH_Kind
cbz	w0, LFQH_LBB271_3
LFQH_Lloh4176:
adr x1, LFQH_l_.str.354
LFQH_Lloh4177:
nop
mov	x0, x22
bl	LFQH_Get
mov	x20, x0
LFQH_Lloh4178:
adr x1, LFQH_l_.str.615
LFQH_Lloh4179:
nop
bl	LFQH_Get
mov	x21, x0
LFQH_Lloh4180:
adr x1, LFQH_l_.str.20
LFQH_Lloh4181:
nop
mov	x0, x19
bl	LFQH_Get
mov	x23, x0
LFQH_Lloh4182:
adr x1, LFQH_l_.str.404
LFQH_Lloh4183:
nop
mov	x0, x22
bl	LFQH_Get
cmp	x23, x0
b.eq	LFQH_LBB271_4
mov	w22, #0
b	LFQH_LBB271_5
LFQH_LBB271_3:
ldp	x29, x30, [sp, #128]
ldp	x20, x19, [sp, #112]
ldp	x22, x21, [sp, #96]
ldp	x24, x23, [sp, #80]
ldp	x26, x25, [sp, #64]
ldp	d9, d8, [sp, #48]
ldp	d11, d10, [sp, #32]
ldp	d13, d12, [sp, #16]
ldp	d15, d14, [sp], #144
ret
LFQH_LBB271_4:
LFQH_Lloh4184:
adr x0, LFQH_l_.str.292
LFQH_Lloh4185:
nop
bl Lpatch + (0xa5a4 - PATCH_BASE)
mov	x1, x0
mov	x0, x19
bl Lpatch + (0xa5d4 - PATCH_BASE)
cmp	w0, #0
cset	w22, eq
LFQH_LBB271_5:
LFQH_Lloh4186:
adr x0, LFQH_l_.str.24
LFQH_Lloh4187:
nop
bl Lpatch + (0xa5a4 - PATCH_BASE)
mov	x1, x0
mov	x0, x19
bl Lpatch + (0xa5d4 - PATCH_BASE)
fcmp	d8, #0.0
csel	w2, wzr, w22, le
mov	x0, x19
mov	x1, x21
bl	LFQH_TopChrome
mov	x22, x0
LFQH_Lloh4188:
adr x0, LFQH_l_.str.249
LFQH_Lloh4189:
nop
bl Lpatch + (0xa5a4 - PATCH_BASE)
mov	x1, x0
mov	x0, x19
bl Lpatch + (0xa5d4 - PATCH_BASE)
mov.16b	v9, v0
mov.16b	v13, v1
mov.16b	v14, v2
mov.16b	v15, v3
LFQH_Lloh4190:
adr x1, LFQH_TopChromeFrameKey
LFQH_Lloh4191:
nop
mov	x0, x19
bl Lpatch + (0xa628 - PATCH_BASE)
mov	x23, x0
cbz	x0, LFQH_LBB271_11
LFQH_Lloh4192:
adr x0, LFQH_l_.str.286
LFQH_Lloh4193:
nop
bl Lpatch + (0xa5a4 - PATCH_BASE)
mov	x1, x0
mov	x0, x23
bl Lpatch + (0xa5d4 - PATCH_BASE)
fcmp	d9, d0
b.ne	LFQH_LBB271_11
fcmp	d13, d1
b.ne	LFQH_LBB271_11
fcmp	d14, d2
b.ne	LFQH_LBB271_11
fcmp	d15, d3
mov.16b	v0, v9
mov.16b	v12, v13
mov.16b	v10, v14
mov.16b	v11, v15
b.ne	LFQH_LBB271_12
LFQH_Lloh4194:
adr x1, LFQH_TopChromeStockFrameKey
LFQH_Lloh4195:
nop
mov	x0, x19
bl Lpatch + (0xa628 - PATCH_BASE)
mov	x24, x0
LFQH_Lloh4196:
adr x0, LFQH_l_.str.286
LFQH_Lloh4197:
nop
bl Lpatch + (0xa5a4 - PATCH_BASE)
mov	x1, x0
mov	x0, x24
bl Lpatch + (0xa5d4 - PATCH_BASE)
mov.16b	v12, v1
mov.16b	v10, v2
mov.16b	v11, v3
b	LFQH_LBB271_12
LFQH_LBB271_11:
mov.16b	v0, v9
mov.16b	v12, v13
mov.16b	v10, v14
mov.16b	v11, v15
LFQH_LBB271_12:
fadd	d8, d8, d12
cmp	w22, #0
fcsel	d1, d12, d8, eq
fcmp	d9, d0
mov.16b	v9, v0
b.ne	LFQH_LBB271_14
fcmp	d13, d1
fccmp	d14, d10, #0, eq
fccmp	d15, d11, #0, eq
b.eq	LFQH_LBB271_15
LFQH_LBB271_14:
LFQH_Lloh4198:
adr x0, LFQH_l_.str.78
LFQH_Lloh4199:
nop
mov.16b	v13, v1
bl Lpatch + (0xa5a4 - PATCH_BASE)
mov	x1, x0
mov	x0, x19
mov.16b	v0, v9
mov.16b	v1, v13
mov.16b	v2, v10
mov.16b	v3, v11
bl Lpatch + (0xa5d4 - PATCH_BASE)
mov.16b	v1, v13
LFQH_LBB271_15:
cbz	w22, LFQH_LBB271_22
mov.16b	v13, v1
cbz	x23, LFQH_LBB271_21
LFQH_Lloh4200:
adr x0, LFQH_l_.str.286
LFQH_Lloh4201:
nop
bl Lpatch + (0xa5a4 - PATCH_BASE)
mov	x1, x0
mov	x0, x23
bl Lpatch + (0xa5d4 - PATCH_BASE)
fcmp	d9, d0
b.ne	LFQH_LBB271_21
fcmp	d8, d1
b.ne	LFQH_LBB271_21
fcmp	d10, d2
b.ne	LFQH_LBB271_21
fcmp	d11, d3
b.eq	LFQH_LBB271_25
LFQH_LBB271_21:
LFQH_Lloh4202:
adr x23, LFQH_l_.str.287
LFQH_Lloh4203:
nop
mov	x0, x23
bl Lpatch + (0xa5b0 - PATCH_BASE)
mov	x24, x0
LFQH_Lloh4204:
adr x25, LFQH_l_.str.288
LFQH_Lloh4205:
nop
mov	x0, x25
bl Lpatch + (0xa5a4 - PATCH_BASE)
mov	x1, x0
mov	x0, x24
mov.16b	v0, v9
mov.16b	v1, v12
mov.16b	v2, v10
mov.16b	v3, v11
bl Lpatch + (0xa5d4 - PATCH_BASE)
mov	x2, x0
LFQH_Lloh4206:
adr x1, LFQH_TopChromeStockFrameKey
LFQH_Lloh4207:
nop
mov	x0, x19
mov	w3, #1
bl Lpatch + (0xa634 - PATCH_BASE)
mov	x0, x23
bl Lpatch + (0xa5b0 - PATCH_BASE)
mov	x23, x0
mov	x0, x25
bl Lpatch + (0xa5a4 - PATCH_BASE)
mov	x1, x0
mov	x0, x23
mov.16b	v0, v9
mov.16b	v1, v13
mov.16b	v2, v10
mov.16b	v3, v11
bl Lpatch + (0xa5d4 - PATCH_BASE)
mov	x2, x0
b	LFQH_LBB271_24
LFQH_LBB271_22:
cbz	x23, LFQH_LBB271_25
LFQH_Lloh4208:
adr x1, LFQH_TopChromeStockFrameKey
LFQH_Lloh4209:
nop
mov	x0, x19
mov	x2, #0
mov	w3, #1
bl Lpatch + (0xa634 - PATCH_BASE)
mov	x2, #0
LFQH_LBB271_24:
LFQH_Lloh4210:
adr x1, LFQH_TopChromeFrameKey
LFQH_Lloh4211:
nop
mov	x0, x19
mov	w3, #1
bl Lpatch + (0xa634 - PATCH_BASE)
LFQH_LBB271_25:
mov	x0, x19
mov	x1, x22
bl	LFQH_TopChromeFill
mov	x0, x21
mov	x1, x22
bl	LFQH_TopChromeFill
LFQH_Lloh4212:
adr x1, LFQH_l_.str.616
LFQH_Lloh4213:
nop
mov	x0, x20
bl	LFQH_Get
mov	x1, x22
ldp	x29, x30, [sp, #128]
ldp	x20, x19, [sp, #112]
ldp	x22, x21, [sp, #96]
ldp	x24, x23, [sp, #80]
ldp	x26, x25, [sp, #64]
ldp	d9, d8, [sp, #48]
ldp	d11, d10, [sp, #32]
ldp	d13, d12, [sp, #16]
ldp	d15, d14, [sp], #144
b	LFQH_TopChromeFill
.cfi_endproc
.p2align	2
LFQH_TopChromeOverlap:
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
mov	x19, x0
LFQH_Lloh4214:
adr x1, LFQH_TopChromeInsetKey
LFQH_Lloh4215:
nop
bl Lpatch + (0xa628 - PATCH_BASE)
mov	x20, x0
LFQH_Lloh4216:
adr x21, LFQH_l_.str.266
LFQH_Lloh4217:
nop
mov	x0, x21
bl Lpatch + (0xa5a4 - PATCH_BASE)
mov	x1, x0
mov	x0, x20
bl Lpatch + (0xa5d4 - PATCH_BASE)
mov.16b	v8, v0
LFQH_Lloh4218:
adr x1, LFQH_TopChromeStockInsetKey
LFQH_Lloh4219:
nop
mov	x0, x19
bl Lpatch + (0xa628 - PATCH_BASE)
mov	x19, x0
mov	x0, x21
bl Lpatch + (0xa5a4 - PATCH_BASE)
mov	x1, x0
mov	x0, x19
bl Lpatch + (0xa5d4 - PATCH_BASE)
fsub	d0, d8, d0
ldp	x29, x30, [sp, #48]
ldp	x20, x19, [sp, #32]
ldp	x22, x21, [sp, #16]
ldp	d9, d8, [sp], #64
ret
.cfi_endproc
.p2align	2
LFQH_RestoreBookshelfTopInset:
.cfi_startproc
stp	x20, x19, [sp, #-32]!
stp	x29, x30, [sp, #16]
add	x29, sp, #16
.cfi_def_cfa w29, 16
.cfi_offset w30, -8
.cfi_offset w29, -16
.cfi_offset w19, -24
.cfi_offset w20, -32
LFQH_Lloh4220:
adr x1, LFQH_l_.str.364
LFQH_Lloh4221:
nop
bl	LFQH_Get
mov	x19, x0
bl	LFQH_TopChromeOverlap
fcmp	d0, #0.0
b.le	LFQH_LBB273_2
mov	x0, x19
ldp	x29, x30, [sp, #16]
ldp	x20, x19, [sp], #32
b	LFQH_TopChromeInsets
LFQH_LBB273_2:
ldp	x29, x30, [sp, #16]
ldp	x20, x19, [sp], #32
ret
.cfi_endproc
.p2align	2
LFQH_ShelfRefreshVisibility:
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
mov	x20, x0
LFQH_Lloh4222:
adr x1, LFQH_l_.str.617
LFQH_Lloh4223:
nop
bl	LFQH_Get
mov	x22, x0
LFQH_Lloh4224:
adr x1, LFQH_l_.str.232
LFQH_Lloh4225:
nop
bl	LFQH_Responds
cbz	w0, LFQH_LBB274_2
LFQH_Lloh4226:
adr x1, LFQH_l_.str.20
LFQH_Lloh4227:
nop
mov	x0, x22
bl	LFQH_Get
cmp	x0, x20
b.eq	LFQH_LBB274_3
LFQH_LBB274_2:
ldp	x29, x30, [sp, #48]
ldp	x20, x19, [sp, #32]
ldp	x22, x21, [sp, #16]
ldp	d9, d8, [sp], #64
ret
LFQH_LBB274_3:
LFQH_Lloh4228:
adr x1, LFQH_l_.str.229
LFQH_Lloh4229:
nop
mov	x0, x22
bl	LFQH_Get
mov	x19, x0
LFQH_Lloh4230:
adr x1, LFQH_l_.str.23
LFQH_Lloh4231:
nop
bl	LFQH_Kind
cbz	w0, LFQH_LBB274_2
LFQH_Lloh4232:
adr x1, LFQH_l_.str.20
LFQH_Lloh4233:
nop
mov	x0, x19
bl	LFQH_Get
cmp	x0, x22
b.ne	LFQH_LBB274_2
LFQH_Lloh4234:
adr x1, LFQH_ShelfRefreshHiddenKey
LFQH_Lloh4235:
nop
mov	x0, x19
bl Lpatch + (0xa628 - PATCH_BASE)
mov	x21, x0
LFQH_Lloh4236:
adr x1, LFQH_TopChromeInsetKey
LFQH_Lloh4237:
nop
mov	x0, x20
bl Lpatch + (0xa628 - PATCH_BASE)
cbz	x0, LFQH_LBB274_7
LFQH_Lloh4238:
adr x0, LFQH_l_.str.230
LFQH_Lloh4239:
nop
bl Lpatch + (0xa5a4 - PATCH_BASE)
mov	x1, x0
mov	x0, x22
bl Lpatch + (0xa5d4 - PATCH_BASE)
cbz	w0, LFQH_LBB274_10
LFQH_LBB274_7:
cbz	x21, LFQH_LBB274_2
LFQH_Lloh4240:
adr x0, LFQH_l_.str.40
LFQH_Lloh4241:
nop
bl Lpatch + (0xa5a4 - PATCH_BASE)
mov	x1, x0
mov	x0, x21
bl Lpatch + (0xa5d4 - PATCH_BASE)
mov	x20, x0
LFQH_Lloh4242:
adr x1, LFQH_ShelfRefreshHiddenKey
LFQH_Lloh4243:
nop
mov	x0, x19
mov	x2, #0
mov	w3, #1
bl Lpatch + (0xa634 - PATCH_BASE)
LFQH_Lloh4244:
adr x0, LFQH_l_.str.292
LFQH_Lloh4245:
nop
bl Lpatch + (0xa5a4 - PATCH_BASE)
mov	x1, x0
mov	x0, x19
bl Lpatch + (0xa5d4 - PATCH_BASE)
cmp	w0, w20
b.eq	LFQH_LBB274_2
LFQH_LBB274_9:
LFQH_Lloh4246:
adr x0, LFQH_l_.str.522
LFQH_Lloh4247:
nop
bl Lpatch + (0xa5a4 - PATCH_BASE)
mov	x1, x0
mov	x0, x19
mov	x2, x20
ldp	x29, x30, [sp, #48]
ldp	x20, x19, [sp, #32]
ldp	x22, x21, [sp, #16]
ldp	d9, d8, [sp], #64
b Lpatch + (0xa5d4 - PATCH_BASE)
LFQH_LBB274_10:
LFQH_Lloh4248:
adr x0, LFQH_l_.str.618
LFQH_Lloh4249:
nop
bl Lpatch + (0xa5a4 - PATCH_BASE)
mov	x1, x0
mov	x0, x20
bl Lpatch + (0xa5d4 - PATCH_BASE)
cbz	w0, LFQH_LBB274_12
LFQH_Lloh4250:
adr x0, LFQH_l_.str.530
LFQH_Lloh4251:
nop
bl Lpatch + (0xa5a4 - PATCH_BASE)
mov	x1, x0
mov	x0, x20
bl Lpatch + (0xa5d4 - PATCH_BASE)
mov.16b	v8, v1
LFQH_Lloh4252:
adr x0, LFQH_l_.str.531
LFQH_Lloh4253:
nop
bl Lpatch + (0xa5a4 - PATCH_BASE)
mov	x1, x0
mov	x0, x20
bl Lpatch + (0xa5d4 - PATCH_BASE)
fneg	d0, d0
fcmp	d8, d0
b.lt	LFQH_LBB274_7
LFQH_LBB274_12:
LFQH_Lloh4254:
adr x0, LFQH_l_.str.292
LFQH_Lloh4255:
nop
bl Lpatch + (0xa5a4 - PATCH_BASE)
mov	x1, x0
mov	x0, x19
bl Lpatch + (0xa5d4 - PATCH_BASE)
mov	x20, x0
cbnz	x21, LFQH_LBB274_14
mov	x0, x20
bl	LFQH_BoolBox
mov	x2, x0
LFQH_Lloh4256:
adr x1, LFQH_ShelfRefreshHiddenKey
LFQH_Lloh4257:
nop
mov	x0, x19
mov	w3, #1
bl Lpatch + (0xa634 - PATCH_BASE)
LFQH_LBB274_14:
cbnz	w20, LFQH_LBB274_2
mov	w20, #1
b	LFQH_LBB274_9
.cfi_endproc
.p2align	2
LFQH_ShelfRefreshHiddenKey:
.cfi_startproc
ret
.cfi_endproc
.p2align	2
LFQH_ShelfRefreshHeaderVisibility:
.cfi_startproc
stp	x20, x19, [sp, #-32]!
stp	x29, x30, [sp, #16]
add	x29, sp, #16
.cfi_def_cfa w29, 16
.cfi_offset w30, -8
.cfi_offset w29, -16
.cfi_offset w19, -24
.cfi_offset w20, -32
LFQH_Lloh4258:
adr x1, LFQH_l_.str.20
LFQH_Lloh4259:
nop
bl	LFQH_Get
mov	x19, x0
LFQH_Lloh4260:
adr x1, LFQH_l_.str.369
LFQH_Lloh4261:
nop
bl	LFQH_Get
mov	x20, x0
LFQH_Lloh4262:
adr x1, LFQH_l_.str.182
LFQH_Lloh4263:
nop
bl	LFQH_Kind
cbz	w0, LFQH_LBB276_2
LFQH_Lloh4264:
adr x1, LFQH_l_.str.364
LFQH_Lloh4265:
nop
mov	x0, x20
bl	LFQH_Get
cmp	x0, x19
b.eq	LFQH_LBB276_3
LFQH_LBB276_2:
ldp	x29, x30, [sp, #16]
ldp	x20, x19, [sp], #32
ret
LFQH_LBB276_3:
mov	x0, x19
ldp	x29, x30, [sp, #16]
ldp	x20, x19, [sp], #32
b	LFQH_ShelfRefreshVisibility
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
.asciz	"fqx177_originalDurationLayout"
LFQH_l_.str.60:
.asciz	"editButton"
LFQH_l_.str.61:
.asciz	"filterButton"
LFQH_l_.str.62:
.asciz	"fullGenreFilterButton"
LFQH_l_.str.63:
.asciz	"SSBookShelfFilterHeaderView"
LFQH_l_.str.64:
.asciz	"fqx179_originalShelfFilterHeader"
LFQH_l_.str.65:
.asciz	"miniGameEntranceCellModel"
LFQH_l_.str.66:
.asciz	"setIsInvisible:"
LFQH_l_.str.67:
.asciz	"v20@0:8B16"
LFQH_l_.str.68:
.asciz	"setIsDisabled:"
LFQH_l_.str.69:
.asciz	"models"
LFQH_l_.str.70:
.asciz	"NSMutableArray"
LFQH_l_.str.71:
.asciz	"removeObjectIdenticalTo:"
LFQH_l_.str.72:
.asciz	"SSMyUser621BaseViewController"
LFQH_l_.str.73:
.asciz	"removeModelBeforeListAdapter"
LFQH_l_.str.74:
.asciz	"tableView"
LFQH_l_.str.75:
.asciz	"tableHeaderView"
LFQH_l_.str.76:
.asciz	"alloc"
LFQH_l_.str.77:
.asciz	"init"
LFQH_l_.str.78:
.asciz	"setFrame:"
LFQH_l_.str.79:
.asciz	"setBackgroundColor:"
LFQH_l_.str.80:
.asciz	"clearColor"
LFQH_l_.str.81:
.asciz	"setText:"
LFQH_l_.str.82:
.asciz	"\345\272\225\346\240\217\350\207\263\345\260\221\344\277\235\347\225\231\344\270\200\351\241\271\343\200\202\n\345\205\263\351\227\255\342\200\234\346\210\221\347\232\204\342\200\235\345\220\216\357\274\214\351\225\277\346\214\211\345\272\225\346\240\217\346\211\223\345\274\200 FanqieX \350\256\276\347\275\256\343\200\202"
LFQH_l_.str.83:
.asciz	"setNumberOfLines:"
LFQH_l_.str.84:
.asciz	"setFont:"
LFQH_l_.str.85:
.asciz	"UIFont"
LFQH_l_.str.86:
.asciz	"systemFontOfSize:"
LFQH_l_.str.87:
.asciz	"secondaryLabelColor"
LFQH_l_.str.88:
.asciz	"setAutoresizingMask:"
LFQH_l_.str.89:
.asciz	"addSubview:"
LFQH_l_.str.90:
.asciz	"setTableHeaderView:"
LFQH_l_.str.91:
.asciz	"cellModel"
LFQH_l_.str.92:
.asciz	"SSInsertScreenRecommendService"
LFQH_l_.str.93:
.asciz	"showInsertScreenOfNonstandardAdMessage:showBlock:"
LFQH_l_.str.94:
.asciz	"v32@0:8@16@?24"
LFQH_l_.str.95:
.asciz	"SSImcAdOperationMessage"
LFQH_l_.str.96:
.asciz	"enablePopup"
LFQH_l_.str.97:
.asciz	"B16@0:8"
LFQH_l_.str.98:
.asciz	"SSImcMessageService"
LFQH_l_.str.99:
.asciz	"getPopupWithDataGroup:"
LFQH_l_.str.100:
.asciz	"fqx185_originalIMCPopup:"
LFQH_l_.str.101:
.asciz	"@24@0:8@16"
LFQH_l_.str.102:
.asciz	"SSReaderFanClubEntryContainerView"
LFQH_l_.str.103:
.asciz	"layoutSubviews"
LFQH_l_.str.104:
.asciz	"fqx184_originalShelfWrapper"
LFQH_l_.str.105:
.asciz	"FQReaderUIManager"
LFQH_l_.str.106:
.asciz	"showBottomBarContainer:"
LFQH_l_.str.107:
.asciz	"fqx180_originalReaderMenu:"
LFQH_l_.str.108:
.asciz	"onConfigThemeChange:context:"
LFQH_l_.str.109:
.asciz	"fqx180_originalReaderTheme:context:"
LFQH_l_.str.110:
.asciz	"v32@0:8@16@24"
LFQH_l_.str.111:
.asciz	"refreshBottomToolbarInsertView"
LFQH_l_.str.112:
.asciz	"fqx181_originalReaderCommunityRefresh"
LFQH_l_.str.113:
.asciz	"SSReaderCommunityBottomToolbarItemView"
LFQH_l_.str.114:
.asciz	"fqx181_originalReaderCommunity"
LFQH_l_.str.115:
.asciz	"fqx175_originalBottom"
LFQH_l_.str.116:
.asciz	"FQReaderSaaSNewProgressView"
LFQH_l_.str.117:
.asciz	"fqx174_originalProgress"
LFQH_l_.str.118:
.asciz	"updateWithConfigData:"
LFQH_l_.str.119:
.asciz	"fqx176_originalProgressTheme:"
LFQH_l_.str.120:
.asciz	"v24@0:8@16"
LFQH_l_.str.121:
.asciz	"SSReaderBottomToolDivertView"
LFQH_l_.str.122:
.asciz	"fqx175_originalDivert"
LFQH_l_.str.123:
.asciz	"SSReaderGiftView"
LFQH_l_.str.124:
.asciz	"fqx174_originalGift"
LFQH_l_.str.125:
.asciz	"SSReaderBookEndUserGiftView"
LFQH_l_.str.126:
.asciz	"fqx174_originalBookGift"
LFQH_l_.str.127:
.asciz	"SSReaderCoverTopRightView"
LFQH_l_.str.128:
.asciz	"fqx186_originalCoverListen"
LFQH_l_.str.129:
.asciz	"FQReaderCoverMainContentViewController"
LFQH_l_.str.130:
.asciz	"setupGuideView"
LFQH_l_.str.131:
.asciz	"fqx186_originalCoverGuideSetup"
LFQH_l_.str.132:
.asciz	"viewDidLayoutSubviews"
LFQH_l_.str.133:
.asciz	"fqx186_originalCoverGuideLayout"
LFQH_l_.str.134:
.asciz	"SSReaderChapterEndDiscussionEntranceView"
LFQH_l_.str.135:
.asciz	"fqx174_originalDiscuss"
LFQH_l_.str.136:
.asciz	"SSReaderChapterEndDiscussionEntranceButton"
LFQH_l_.str.137:
.asciz	"fqx174_originalDiscussButton"
LFQH_l_.str.138:
.asciz	"SSReaderChapterEndCommunityCardView"
LFQH_l_.str.139:
.asciz	"fqx177_originalChapterCard"
LFQH_l_.str.140:
.asciz	"updateWithReaderConfig:"
LFQH_l_.str.141:
.asciz	"fqx177_originalChapterCardTheme:"
LFQH_l_.str.142:
.asciz	"SSReaderChapterEndBaseButton"
LFQH_l_.str.143:
.asciz	"fqx177_originalChapterButton"
LFQH_l_.str.144:
.asciz	"SSReaderChapterEndRewardButton"
LFQH_l_.str.145:
.asciz	"updateWithThemeConfigChange:"
LFQH_l_.str.146:
.asciz	"fqx177_originalChapterRewardTheme:"
LFQH_l_.str.147:
.asciz	"SSBookShelfTabSelectViewTitleCell"
LFQH_l_.str.148:
.asciz	"fqx174_originalShelfCategory"
LFQH_l_.str.149:
.asciz	"reloadData:"
LFQH_l_.str.150:
.asciz	"fqx175_originalShelfTabReload:"
LFQH_l_.str.151:
.asciz	"SSBookShelfFilter541Cell"
LFQH_l_.str.152:
.asciz	"fqx175_originalShelfFilterLayout"
LFQH_l_.str.153:
.asciz	"updateAppearance:"
LFQH_l_.str.154:
.asciz	"fqx175_originalShelfFilterAppearance:"
LFQH_l_.str.155:
.asciz	"updateCellBgColor:"
LFQH_l_.str.156:
.asciz	"fqx175_originalShelfFilterBackground:"
LFQH_l_.str.157:
.asciz	"SSBookShelfFilterMixRowCollectionView"
LFQH_l_.str.158:
.asciz	"collectionView:layout:insetForSectionAtIndex:"
LFQH_l_.str.159:
.asciz	"fqx185_originalInlineFilterInsets:layout:section:"
LFQH_l_.str.160:
.asciz	"{UIEdgeInsets=dddd}40@0:8@16@24q32"
LFQH_l_.str.161:
.asciz	"SSMyUserBar"
LFQH_l_.str.162:
.asciz	"fqx174_originalProfileBar"
LFQH_l_.str.163:
.asciz	"updateCollectionLayout"
LFQH_l_.str.164:
.asciz	"fqx186_originalProfileCollectionLayout"
LFQH_l_.str.165:
.asciz	"SSMyUserCollectionViewFunCell"
LFQH_l_.str.166:
.asciz	"fqx174_originalProfileEntry"
LFQH_l_.str.167:
.asciz	"SSMyUserCollectionViewOrderFunCell"
LFQH_l_.str.168:
.asciz	"fqx178_originalProfileOrder"
LFQH_l_.str.169:
.asciz	"setupCellMiniGameEntranceData"
LFQH_l_.str.170:
.asciz	"fqx174_originalMiniGameSetup"
LFQH_l_.str.171:
.asciz	"SSMyUserCell2Model"
LFQH_l_.str.172:
.asciz	"applyConfiguredMineEcomEntranceData:mineMonetizationStyle:"
LFQH_l_.str.173:
.asciz	"fqx176_originalMineEntrances:style:"
LFQH_l_.str.174:
.asciz	"v32@0:8@16q24"
LFQH_l_.str.175:
.asciz	"SSMyUser621ViewController"
LFQH_l_.str.176:
.asciz	"objectsForListAdapter:"
LFQH_l_.str.177:
.asciz	"fqx176_originalMineListObjects:"
LFQH_l_.str.178:
.asciz	"setShowReadTimeView:"
LFQH_l_.str.179:
.asciz	"fqx177_originalDurationVisible:"
LFQH_l_.str.180:
.asciz	"layoutEditButton"
LFQH_l_.str.181:
.asciz	"fqx185_originalStockEditLayout"
LFQH_l_.str.182:
.asciz	"SSBookShelfSubViewController"
LFQH_l_.str.183:
.asciz	"saveOpeningData:indexPath:"
LFQH_l_.str.184:
.asciz	"fqx185_originalSaveOpeningData:index:"
LFQH_l_.str.185:
.asciz	"fetchBookCoverTransitionInfo:"
LFQH_l_.str.186:
.asciz	"fqx185_originalCoverTransition:"
LFQH_l_.str.187:
.asciz	"@24@0:8Q16"
LFQH_l_.str.188:
.asciz	"SSTabBarController"
LFQH_l_.str.189:
.asciz	"tabbarVCAndAttributeInit"
LFQH_l_.str.190:
.asciz	"fqx176_originalTabPlan"
LFQH_l_.str.191:
.asciz	"viewDidAppear:"
LFQH_l_.str.192:
.asciz	"fqx176_originalTabAppear:"
LFQH_l_.str.193:
.asciz	"fqx171_originalLayout"
LFQH_l_.str.194:
.asciz	"fqx175_originalSpeechLayout"
LFQH_l_.str.195:
.asciz	"readerInsertedViewBackgroundConfigChange:"
LFQH_l_.str.196:
.asciz	"fqx175_originalSpeechTheme:"
LFQH_l_.str.197:
.asciz	"fqx165_originalRelayout"
LFQH_l_.str.198:
.asciz	"fqx165_originalAppear:"
LFQH_l_.str.199:
.asciz	"categoryView:didScrollSelectedItemAtIndex:"
LFQH_l_.str.200:
.asciz	"fqx186_originalStoreSelected:index:"
LFQH_l_.str.201:
.asciz	"SSBookStoreTabViewController"
LFQH_l_.str.202:
.asciz	"setupLayout"
LFQH_l_.str.203:
.asciz	"fqx186_originalStoreCollectionLayout"
LFQH_l_.str.204:
.asciz	"SSBookStoreDoubleRowViewController"
LFQH_l_.str.205:
.asciz	"viewWillLayoutSubviews"
LFQH_l_.str.206:
.asciz	"fqx187_originalStoreDoubleRowLayout"
LFQH_l_.str.207:
.asciz	"storeTabScrollViewDidScroll:"
LFQH_l_.str.208:
.asciz	"fqx187_originalStoreDoubleRowScroll:"
LFQH_l_.str.209:
.asciz	"SSBookStoreSearchBarComponent"
LFQH_l_.str.210:
.asciz	"bookStoreVCContext"
LFQH_l_.str.211:
.asciz	"resetTopTabSearchViewWithRatio:fromTab:toTab:fromTabTemplate:toTabTemplate:"
LFQH_l_.str.212:
.asciz	"fqx173_originalSearchColor:from:to:fromTemplate:toTemplate:"
LFQH_l_.str.213:
.asciz	"v40@0:8d16i24i28i32i36"
LFQH_l_.str.214:
.asciz	"fqx173_originalLayout"
LFQH_l_.str.215:
.asciz	"resetColorWithRatio:fromTab:toTab:fromTabTemplate:toTabTemplate:"
LFQH_l_.str.216:
.asciz	"fqx173_originalColor:from:to:fromTemplate:toTemplate:"
LFQH_l_.str.217:
.asciz	"FQReaderSaaSBaseButton"
LFQH_l_.str.218:
.asciz	"fqx170_originalLayout"
LFQH_l_.str.219:
.asciz	"SSBookShelf525ViewController"
LFQH_l_.str.220:
.asciz	"viewLayout"
LFQH_l_.str.221:
.asciz	"fqx186_originalShelfTopLayout"
LFQH_l_.str.222:
.asciz	"fqx186_originalShelfSelected:index:"
LFQH_l_.str.223:
.asciz	"updateCollectionViewInsets"
LFQH_l_.str.224:
.asciz	"fqx186_originalShelfUpdateInsets"
LFQH_l_.str.225:
.asciz	"updateFullGenreFloatingViewWithScrollView:"
LFQH_l_.str.226:
.asciz	"fqx186_originalShelfFloating:"
LFQH_l_.str.227:
.asciz	"fqx167_originalShelfLayout"
LFQH_l_.str.228:
.asciz	"SSNewRefreshHeader"
LFQH_l_.str.229:
.asciz	"animationView"
LFQH_l_.str.230:
.asciz	"isRefreshing"
LFQH_l_.str.231:
.asciz	"setAnimationHidden:"
LFQH_l_.str.232:
.asciz	"fqx187_originalShelfRefreshHidden:"
LFQH_l_.str.233:
.asciz	"setState:"
LFQH_l_.str.234:
.asciz	"fqx187_originalShelfRefreshState:"
LFQH_l_.str.235:
.asciz	"v24@0:8q16"
LFQH_l_.str.236:
.asciz	"placeSubviews"
LFQH_l_.str.237:
.asciz	"fqx187_originalShelfRefreshAnimationLayout"
LFQH_l_.str.238:
.asciz	"scrollViewDidScroll:"
LFQH_l_.str.239:
.asciz	"fqx187_originalShelfScroll:"
LFQH_l_.str.240:
.asciz	"FQReaderSaasNavigationView"
LFQH_l_.str.241:
.asciz	"fqx167_originalLayout"
LFQH_l_.str.242:
.asciz	"readerInsertedViewThemeConfigChange:"
LFQH_l_.str.243:
.asciz	"fqx167_originalTheme:"
LFQH_l_.str.244:
.asciz	"NSString"
LFQH_l_.str.245:
.asciz	"stringWithUTF8String:"
LFQH_l_.str.246:
.asciz	"respondsToSelector:"
LFQH_l_.str.247:
.asciz	"isKindOfClass:"
LFQH_l_.str.248:
.asciz	"contentView"
LFQH_l_.str.249:
.asciz	"frame"
LFQH_l_.str.250:
.asciz	"backgroundColor"
LFQH_l_.str.251:
.asciz	"clipsToBounds"
LFQH_l_.str.252:
.asciz	"isOpaque"
LFQH_l_.str.253:
.asciz	"CATransaction"
LFQH_l_.str.254:
.asciz	"begin"
LFQH_l_.str.255:
.asciz	"setDisableActions:"
LFQH_l_.str.256:
.asciz	"insertSubview:atIndex:"
LFQH_l_.str.257:
.asciz	"commit"
LFQH_l_.str.258:
.asciz	"initWithEffect:"
LFQH_l_.str.259:
.asciz	"setUserInteractionEnabled:"
LFQH_l_.str.260:
.asciz	"setAccessibilityElementsHidden:"
LFQH_l_.str.261:
.asciz	"setIsAccessibilityElement:"
LFQH_l_.str.262:
.asciz	"setOpaque:"
LFQH_l_.str.263:
.asciz	"layer"
LFQH_l_.str.264:
.asciz	"cornerRadius"
LFQH_l_.str.265:
.asciz	"setClipsToBounds:"
LFQH_l_.str.266:
.asciz	"doubleValue"
LFQH_l_.str.267:
.asciz	"NSNumber"
LFQH_l_.str.268:
.asciz	"numberWithDouble:"
LFQH_l_.str.269:
.asciz	"setCornerRadius:"
LFQH_l_.str.270:
.asciz	"NSProcessInfo"
LFQH_l_.str.271:
.asciz	"processInfo"
LFQH_l_.str.272:
.asciz	"systemUptime"
LFQH_l_.str.273:
.asciz	"NSMutableDictionary"
LFQH_l_.str.274:
.asciz	"dictionary"
LFQH_l_.str.275:
.asciz	"role"
LFQH_l_.str.276:
.asciz	"hostFrame"
LFQH_l_.str.277:
.asciz	"hostBounds"
LFQH_l_.str.278:
.asciz	"glassRect"
LFQH_l_.str.279:
.asciz	"subviews"
LFQH_l_.str.280:
.asciz	"array"
LFQH_l_.str.281:
.asciz	"childCount"
LFQH_l_.str.282:
.asciz	"childrenTruncated"
LFQH_l_.str.283:
.asciz	"addObject:"
LFQH_l_.str.284:
.asciz	"childFrames"
LFQH_l_.str.285:
.asciz	"headerLayout173"
LFQH_l_.str.286:
.asciz	"CGRectValue"
LFQH_l_.str.287:
.asciz	"NSValue"
LFQH_l_.str.288:
.asciz	"valueWithCGRect:"
LFQH_l_.str.289:
.asciz	"setObject:forKey:"
LFQH_l_.str.290:
.asciz	"UIButton"
LFQH_l_.str.291:
.asciz	"imageView"
LFQH_l_.str.292:
.asciz	"isHidden"
LFQH_l_.str.293:
.asciz	"new"
LFQH_l_.str.294:
.asciz	"setConfiguration:"
LFQH_l_.str.295:
.asciz	"isEnabled"
LFQH_l_.str.296:
.asciz	"isSelected"
LFQH_l_.str.297:
.asciz	"isHighlighted"
LFQH_l_.str.298:
.asciz	"insertSubview:belowSubview:"
LFQH_l_.str.299:
.asciz	"setEnabled:"
LFQH_l_.str.300:
.asciz	"setSelected:"
LFQH_l_.str.301:
.asciz	"setHighlighted:"
LFQH_l_.str.302:
.asciz	"removeFromSuperview"
LFQH_l_.str.303:
.asciz	"convertRect:toView:"
LFQH_l_.str.304:
.asciz	"btd_hitTestEdgeInsets"
LFQH_l_.str.305:
.asciz	"setBtd_hitTestEdgeInsets:"
LFQH_l_.str.306:
.asciz	"FQXGlassBackground167"
LFQH_l_.str.307:
.asciz	"fqx167_down:"
LFQH_l_.str.308:
.asciz	"fqx167_up:"
LFQH_l_.str.309:
.asciz	"addTarget:action:forControlEvents:"
LFQH_l_.str.310:
.asciz	"removeTarget:action:forControlEvents:"
LFQH_l_.str.311:
.asciz	"bgView"
LFQH_l_.str.312:
.asciz	"window"
LFQH_l_.str.313:
.asciz	"arrayWithObjects:count:"
LFQH_l_.str.314:
.asciz	"imageRect"
LFQH_l_.str.315:
.asciz	"windowRect"
LFQH_l_.str.316:
.asciz	"controlLayout167"
LFQH_l_.str.317:
.asciz	"readerBack"
LFQH_l_.str.318:
.asciz	"readerMore"
LFQH_l_.str.319:
.asciz	"readerSearch"
LFQH_l_.str.320:
.asciz	"readerDownload"
LFQH_l_.str.321:
.asciz	"readerCommunity"
LFQH_l_.str.322:
.asciz	"readerChapter"
LFQH_l_.str.323:
.asciz	"readerShelf"
LFQH_l_.str.324:
.asciz	"shelfSearch"
LFQH_l_.str.325:
.asciz	"shelfMore"
LFQH_l_.str.326:
.asciz	"icon"
LFQH_l_.str.327:
.asciz	"objectAtIndex:"
LFQH_l_.str.328:
.asciz	"FQReaderNavigationBarMoreBtnInsertObject"
LFQH_l_.str.329:
.asciz	"FQReaderNavigationBarSearchBtnInsertObject"
LFQH_l_.str.330:
.asciz	"SSReaderNavigationBarDownloadBtnInsertObject"
LFQH_l_.str.331:
.asciz	"SSReaderNavigationBarBookShelfBtnInsertObject"
LFQH_l_.str.332:
.asciz	"SSReaderNavigationBarCommunitySwitchBtnInsertObject"
LFQH_l_.str.333:
.asciz	"numberWithLongLong:"
LFQH_l_.str.334:
.asciz	"numberWithBool:"
LFQH_l_.str.335:
.asciz	"text"
LFQH_l_.str.336:
.asciz	"\345\220\254"
LFQH_l_.str.337:
.asciz	"NSUserDefaults"
LFQH_l_.str.338:
.asciz	"standardUserDefaults"
LFQH_l_.str.339:
.asciz	"FanqieAdBlock.GlassDisabled.1"
LFQH_l_.str.340:
.asciz	"integerForKey:"
LFQH_l_.str.341:
.asciz	"item"
LFQH_l_.str.342:
.asciz	"FQReaderSaaSBottomToolItem"
LFQH_l_.str.343:
.asciz	"type"
LFQH_l_.str.344:
.asciz	"i16@0:8"
LFQH_l_.str.345:
.asciz	"SSMyUserMiniGameEntranceCellModel"
LFQH_l_.str.346:
.asciz	"SSMyUserShopAndMiniGameEntranceCellModel"
LFQH_l_.str.347:
.asciz	"event"
LFQH_l_.str.348:
.asciz	"pageAdRemoved174"
LFQH_l_.str.349:
.asciz	"ownerClass"
LFQH_l_.str.350:
.asciz	"source"
LFQH_l_.str.351:
.asciz	"serverGameModel"
LFQH_l_.str.352:
.asciz	"action"
LFQH_l_.str.353:
.asciz	"pageAdFilter174"
LFQH_l_.str.354:
.asciz	"functionCell"
LFQH_l_.str.355:
.asciz	"headerView"
LFQH_l_.str.356:
.asciz	"showReadTimeView"
LFQH_l_.str.357:
.asciz	"isFiltering"
LFQH_l_.str.358:
.asciz	"secondaryView"
LFQH_l_.str.359:
.asciz	"fqx178_originalShelfFunctionLayout"
LFQH_l_.str.360:
.asciz	"lineView"
LFQH_l_.str.361:
.asciz	"lineView2"
LFQH_l_.str.362:
.asciz	"alpha"
LFQH_l_.str.363:
.asciz	"setNeedsLayout"
LFQH_l_.str.364:
.asciz	"collectionView"
LFQH_l_.str.365:
.asciz	"collectionViewLayout"
LFQH_l_.str.366:
.asciz	"invalidateLayout"
LFQH_l_.str.367:
.asciz	"contentEdgeInsets"
LFQH_l_.str.368:
.asciz	"setContentEdgeInsets:"
LFQH_l_.str.369:
.asciz	"delegate"
LFQH_l_.str.370:
.asciz	"currentTabVC"
LFQH_l_.str.371:
.asciz	"headerRightView"
LFQH_l_.str.372:
.asciz	"tabSelectView"
LFQH_l_.str.373:
.asciz	"visibleCells"
LFQH_l_.str.374:
.asciz	"sizeThatFits:"
LFQH_l_.str.375:
.asciz	"FanqieXBottomToggles176"
LFQH_l_.str.376:
.asciz	"NSObject"
LFQH_l_.str.377:
.asciz	"fqx176_toggle:"
LFQH_l_.str.378:
.asciz	"fqx176_recoverOptions:"
LFQH_l_.str.379:
.asciz	"gestureRecognizer:shouldReceiveTouch:"
LFQH_l_.str.380:
.asciz	"B32@0:8@16@24"
LFQH_l_.str.381:
.asciz	"tag"
LFQH_l_.str.382:
.asciz	"isOn"
LFQH_l_.str.383:
.asciz	"typeArray"
LFQH_l_.str.384:
.asciz	"setOn:animated:"
LFQH_l_.str.385:
.asciz	"refreshTabBar"
LFQH_l_.str.386:
.asciz	"bottomEntryToggle176"
LFQH_l_.str.387:
.asciz	"entry"
LFQH_l_.str.388:
.asciz	"enabled"
LFQH_l_.str.389:
.asciz	"setBool:forKey:"
LFQH_l_.str.390:
.asciz	"allObjects"
LFQH_l_.str.391:
.asciz	"FanqieXMineBenefits"
LFQH_l_.str.392:
.asciz	"UIApplication"
LFQH_l_.str.393:
.asciz	"sharedApplication"
LFQH_l_.str.394:
.asciz	"keyWindow"
LFQH_l_.str.395:
.asciz	"rootViewController"
LFQH_l_.str.396:
.asciz	"windows"
LFQH_l_.str.397:
.asciz	"children"
LFQH_l_.str.398:
.asciz	"intValue"
LFQH_l_.str.399:
.asciz	"titleStrWithType:"
LFQH_l_.str.400:
.asciz	"@20@0:8i16"
LFQH_l_.str.401:
.asciz	"\347\237\255\345\211\247"
LFQH_l_.str.402:
.asciz	"\345\225\206\345\237\216"
LFQH_l_.str.403:
.asciz	"customTabBar"
LFQH_l_.str.404:
.asciz	"view"
LFQH_l_.str.405:
.asciz	"removeGestureRecognizer:"
LFQH_l_.str.406:
.asciz	"NSHashTable"
LFQH_l_.str.407:
.asciz	"weakObjectsHashTable"
LFQH_l_.str.408:
.asciz	"UILongPressGestureRecognizer"
LFQH_l_.str.409:
.asciz	"initWithTarget:action:"
LFQH_l_.str.410:
.asciz	"setMinimumPressDuration:"
LFQH_l_.str.411:
.asciz	"setDelegate:"
LFQH_l_.str.412:
.asciz	"addGestureRecognizer:"
LFQH_l_.str.413:
.asciz	"state"
LFQH_l_.str.414:
.asciz	"presentedViewController"
LFQH_l_.str.415:
.asciz	"fqab_openMenu"
LFQH_l_.str.416:
.asciz	"SSSettingViewController"
LFQH_l_.str.417:
.asciz	"anyObject"
LFQH_l_.str.418:
.asciz	"locationInView:"
LFQH_l_.str.419:
.asciz	"UISwitch"
LFQH_l_.str.420:
.asciz	"setTag:"
LFQH_l_.str.421:
.asciz	"setAccessibilityLabel:"
LFQH_l_.str.422:
.asciz	"\345\272\225\346\240\217\346\230\276\347\244\272\357\274\232\344\271\246\345\237\216"
LFQH_l_.str.423:
.asciz	"\345\272\225\346\240\217\346\230\276\347\244\272\357\274\232\347\237\255\345\211\247"
LFQH_l_.str.424:
.asciz	"\345\272\225\346\240\217\346\230\276\347\244\272\357\274\232\344\271\246\346\236\266"
LFQH_l_.str.425:
.asciz	"\345\272\225\346\240\217\346\230\276\347\244\272\357\274\232\346\210\221\347\232\204"
LFQH_l_.str.426:
.asciz	"\345\272\225\346\240\217\346\230\276\347\244\272\357\274\232\345\225\206\345\237\216"
LFQH_l_.str.427:
.asciz	"\344\271\246\346\236\266\346\230\276\347\244\272\344\273\212\346\227\245\347\234\213\345\220\254\350\257\273\346\227\266\351\225\277"
LFQH_l_.str.428:
.asciz	"\346\210\221\347\232\204\346\230\276\347\244\272\351\207\221\345\270\201\344\270\216\347\246\217\345\210\251\345\215\241\347\211\207"
LFQH_l_.str.429:
.asciz	"\351\230\205\350\257\273\350\217\234\345\215\225\346\230\276\347\244\272\344\270\212\344\270\213\346\240\217\350\203\214\346\231\257"
LFQH_l_.str.430:
.asciz	"objectForKey:"
LFQH_l_.str.431:
.asciz	"FanqieX.BottomBookstore.1"
LFQH_l_.str.432:
.asciz	"FanqieX.BottomDrama.1"
LFQH_l_.str.433:
.asciz	"FanqieX.BottomBookshelf.1"
LFQH_l_.str.434:
.asciz	"FanqieX.BottomMine.1"
LFQH_l_.str.435:
.asciz	"FanqieX.BottomMall.1"
LFQH_l_.str.436:
.asciz	"FanqieX.ShelfReadingDuration.1"
LFQH_l_.str.437:
.asciz	"FanqieX.MineBenefitsCard.1"
LFQH_l_.str.438:
.asciz	"FanqieX.ReaderBottomBackground.1"
LFQH_l_.str.439:
.asciz	"cellSpacing"
LFQH_l_.str.440:
.asciz	"d16@0:8"
LFQH_l_.str.441:
.asciz	"titleLabel"
LFQH_l_.str.442:
.asciz	"maskTitleLabel"
LFQH_l_.str.443:
.asciz	"systemOrangeColor"
LFQH_l_.str.444:
.asciz	"font"
LFQH_l_.str.445:
.asciz	"pointSize"
LFQH_l_.str.446:
.asciz	"fontWithSize:"
LFQH_l_.str.447:
.asciz	"ruleId"
LFQH_l_.str.448:
.asciz	"bookstore_imc_popup"
LFQH_l_.str.449:
.asciz	"ruleType"
LFQH_l_.str.450:
.asciz	"exactHostSelector"
LFQH_l_.str.451:
.asciz	"class"
LFQH_l_.str.452:
.asciz	"selector"
LFQH_l_.str.453:
.asciz	"result"
LFQH_l_.str.454:
.asciz	"blocked"
LFQH_l_.str.455:
.asciz	"pageDisplay"
LFQH_l_.str.456:
.asciz	"unobserved"
LFQH_l_.str.457:
.asciz	"adRuleDecision"
LFQH_l_.str.458:
.asciz	"navigationContainer"
LFQH_l_.str.459:
.asciz	"BDReaderTopViewContainer"
LFQH_l_.str.460:
.asciz	"updateGradientLayer"
LFQH_l_.str.461:
.asciz	"nProgressView"
LFQH_l_.str.462:
.asciz	"tabBar"
LFQH_l_.str.463:
.asciz	"BDReaderViewContainer"
LFQH_l_.str.464:
.asciz	"horizonLineView"
LFQH_l_.str.465:
.asciz	"setAlpha:"
LFQH_l_.str.466:
.asciz	"bottomToolbarInsertContainer"
LFQH_l_.str.467:
.asciz	"currentBottomToolbarInsertObject"
LFQH_l_.str.468:
.asciz	"containerView"
LFQH_l_.str.469:
.asciz	"SSReaderBottomToolbarItemContainerView"
LFQH_l_.str.470:
.asciz	"itemViews"
LFQH_l_.str.471:
.asciz	"bottomToolbarInsertTopLineView"
LFQH_l_.str.472:
.asciz	"\345\217\221\350\256\250\350\256\272"
LFQH_l_.str.473:
.asciz	"\345\234\210\345\255\220"
LFQH_l_.str.474:
.asciz	"readerBottomTool"
LFQH_l_.str.475:
.asciz	"onBtnClick:"
LFQH_l_.str.476:
.asciz	"FQXReaderCatalogTap"
LFQH_l_.str.477:
.asciz	"fqx_catalogTapped:"
LFQH_l_.str.478:
.asciz	"UITapGestureRecognizer"
LFQH_l_.str.479:
.asciz	"setCancelsTouchesInView:"
LFQH_l_.str.480:
.asciz	"leftBtn"
LFQH_l_.str.481:
.asciz	"rightBtn"
LFQH_l_.str.482:
.asciz	"slider"
LFQH_l_.str.483:
.asciz	"BDReaderNewSlider"
LFQH_l_.str.484:
.asciz	"trackView"
LFQH_l_.str.485:
.asciz	"UIImageView"
LFQH_l_.str.486:
.asciz	"readerProgressTrack"
LFQH_l_.str.487:
.asciz	"progressView"
LFQH_l_.str.488:
.asciz	"giftButton"
LFQH_l_.str.489:
.asciz	"listenBtn"
LFQH_l_.str.490:
.asciz	"listenLabel"
LFQH_l_.str.491:
.asciz	"guideView"
LFQH_l_.str.492:
.asciz	"\345\267\246\346\273\221\345\274\200\345\247\213\351\230\205\350\257\273"
LFQH_l_.str.493:
.asciz	"\344\270\212\346\273\221\345\274\200\345\247\213\351\230\205\350\257\273"
LFQH_l_.str.494:
.asciz	"borderWidth"
LFQH_l_.str.495:
.asciz	"setBorderWidth:"
LFQH_l_.str.496:
.asciz	"model"
LFQH_l_.str.497:
.asciz	"displayMode"
LFQH_l_.str.498:
.asciz	"q16@0:8"
LFQH_l_.str.499:
.asciz	"activeEntranceView"
LFQH_l_.str.500:
.asciz	"contentBackgroundView"
LFQH_l_.str.501:
.asciz	"customBackgroundView"
LFQH_l_.str.502:
.asciz	"SSReaderChapterEndCombineContainerView"
LFQH_l_.str.503:
.asciz	"isSelect"
LFQH_l_.str.504:
.asciz	"filterGradientView"
LFQH_l_.str.505:
.asciz	"optionsView"
LFQH_l_.str.506:
.asciz	"scanQRCodeView"
LFQH_l_.str.507:
.asciz	"darkModeImageView"
LFQH_l_.str.508:
.asciz	"sideBarButtonView"
LFQH_l_.str.509:
.asciz	"sidebarAdapter"
LFQH_l_.str.510:
.asciz	"isSidebarOpen"
LFQH_l_.str.511:
.asciz	"isSidebarTransitioning"
LFQH_l_.str.512:
.asciz	"myUserBar"
LFQH_l_.str.513:
.asciz	"FQFeedListCollectionView"
LFQH_l_.str.514:
.asciz	"profile"
LFQH_l_.str.515:
.asciz	"UIScrollView"
LFQH_l_.str.516:
.asciz	"scrollView"
LFQH_l_.str.517:
.asciz	"UIScrollEdgeEffectStyle"
LFQH_l_.str.518:
.asciz	"softStyle"
LFQH_l_.str.519:
.asciz	"topEdgeEffect"
LFQH_l_.str.520:
.asciz	"style"
LFQH_l_.str.521:
.asciz	"setStyle:"
LFQH_l_.str.522:
.asciz	"setHidden:"
LFQH_l_.str.523:
.asciz	"removeInteraction:"
LFQH_l_.str.524:
.asciz	"UIScrollEdgeElementContainerInteraction"
LFQH_l_.str.525:
.asciz	"addInteraction:"
LFQH_l_.str.526:
.asciz	"setScrollView:"
LFQH_l_.str.527:
.asciz	"setEdge:"
LFQH_l_.str.528:
.asciz	"UIBlurEffect"
LFQH_l_.str.529:
.asciz	"contentInset"
LFQH_l_.str.530:
.asciz	"contentOffset"
LFQH_l_.str.531:
.asciz	"adjustedContentInset"
LFQH_l_.str.532:
.asciz	"setContentInset:"
LFQH_l_.str.533:
.asciz	"setContentOffset:"
LFQH_l_.str.534:
.asciz	"material"
LFQH_l_.str.535:
.asciz	"nativeScrollEdge"
LFQH_l_.str.536:
.asciz	"systemUltraThin"
LFQH_l_.str.537:
.asciz	"stock"
LFQH_l_.str.538:
.asciz	"stockViewportFrame"
LFQH_l_.str.539:
.asciz	"viewportRect"
LFQH_l_.str.540:
.asciz	"scrollClipRect"
LFQH_l_.str.541:
.asciz	"topChromeGeometry"
LFQH_l_.str.542:
.asciz	"SSMyUser621FunctionEntryItemCell"
LFQH_l_.str.543:
.asciz	"SSMyUserShortcutCell"
LFQH_l_.str.544:
.asciz	"SSMyUserCollectionView1Cell"
LFQH_l_.str.545:
.asciz	"productImage"
LFQH_l_.str.546:
.asciz	"image"
LFQH_l_.str.547:
.asciz	"functionType"
LFQH_l_.str.548:
.asciz	"label"
LFQH_l_.str.549:
.asciz	"SSMineEcomEntranceData"
LFQH_l_.str.550:
.asciz	"entranceType"
LFQH_l_.str.551:
.asciz	"mutableCopy"
LFQH_l_.str.552:
.asciz	"autorelease"
LFQH_l_.str.553:
.asciz	"removeObjectAtIndex:"
LFQH_l_.str.554:
.asciz	"filterConfiguredGameEntrances"
LFQH_l_.str.555:
.asciz	"filterStandaloneGameRows"
LFQH_l_.str.556:
.asciz	"businessStyle"
LFQH_l_.str.557:
.asciz	"isShowPersonalizedBar"
LFQH_l_.str.558:
.asciz	"isShowFriendView"
LFQH_l_.str.559:
.asciz	"layoutIfNeeded"
LFQH_l_.str.560:
.asciz	"SSCoverTransitionInfo"
LFQH_l_.str.561:
.asciz	"setCoverFrame:"
LFQH_l_.str.562:
.asciz	"v48@0:8{CGRect={CGPoint=dd}{CGSize=dd}}16"
LFQH_l_.str.563:
.asciz	"openingModel"
LFQH_l_.str.564:
.asciz	"data"
LFQH_l_.str.565:
.asciz	"bookId"
LFQH_l_.str.566:
.asciz	"collectDatas"
LFQH_l_.str.567:
.asciz	"firstObject"
LFQH_l_.str.568:
.asciz	"fetchCoverView"
LFQH_l_.str.569:
.asciz	"fetchCoverSize"
LFQH_l_.str.570:
.asciz	"{CGSize=dd}16@0:8"
LFQH_l_.str.571:
.asciz	"SSBookShelfFunctionCell"
LFQH_l_.str.572:
.asciz	"SSBookShelfViewModel"
LFQH_l_.str.573:
.asciz	"sectionTypeAtIndex:"
LFQH_l_.str.574:
.asciz	"q24@0:8q16"
LFQH_l_.str.575:
.asciz	"showsFilterExposure"
LFQH_l_.str.576:
.asciz	"cellHeightWithFilterExposure:"
LFQH_l_.str.577:
.asciz	"d20@0:8B16"
LFQH_l_.str.578:
.asciz	"collectionView:layout:sizeForItemAtIndexPath:"
LFQH_l_.str.579:
.asciz	"fqx178_originalShelfFunctionSize:layout:index:"
LFQH_l_.str.580:
.asciz	"{CGSize=dd}40@0:8@16@24@32"
LFQH_l_.str.581:
.asciz	"fqx181_originalShelfInsets:layout:section:"
LFQH_l_.str.582:
.asciz	"layoutContainerSubviews"
LFQH_l_.str.583:
.asciz	"section"
LFQH_l_.str.584:
.asciz	"viewModel"
LFQH_l_.str.585:
.asciz	"filterClipView"
LFQH_l_.str.586:
.asciz	"setTypeArray:"
LFQH_l_.str.587:
.asciz	"setTypeIndexMap:"
LFQH_l_.str.588:
.asciz	"numberWithUnsignedInteger:"
LFQH_l_.str.589:
.asciz	"speechBtn"
LFQH_l_.str.590:
.asciz	"imageForState:"
LFQH_l_.str.591:
.asciz	"tintColor"
LFQH_l_.str.592:
.asciz	"BDNovelNewAssetsGenerated"
LFQH_l_.str.593:
.asciz	"bdn_novelReaderListenButton"
LFQH_l_.str.594:
.asciz	"imageWithRenderingMode:"
LFQH_l_.str.595:
.asciz	"setImage:forState:"
LFQH_l_.str.596:
.asciz	"simpleHeader"
LFQH_l_.str.597:
.asciz	"simpleTabView"
LFQH_l_.str.598:
.asciz	"tabContainer"
LFQH_l_.str.599:
.asciz	"signBgView"
LFQH_l_.str.600:
.asciz	"backgroundView"
LFQH_l_.str.601:
.asciz	"retain"
LFQH_l_.str.602:
.asciz	"bookstore"
LFQH_l_.str.603:
.asciz	"currentSelectedListViewController"
LFQH_l_.str.604:
.asciz	"doubleRowNestContainerScrollView"
LFQH_l_.str.605:
.asciz	"doubleRowUnlimitedCollectionView"
LFQH_l_.str.606:
.asciz	"listView"
LFQH_l_.str.607:
.asciz	"nestedView"
LFQH_l_.str.608:
.asciz	"SSBookStoreNestedTabView"
LFQH_l_.str.609:
.asciz	"viewIfLoaded"
LFQH_l_.str.610:
.asciz	"indexOfObjectIdenticalTo:"
LFQH_l_.str.611:
.asciz	"headerBackgroundView"
LFQH_l_.str.612:
.asciz	"headerBgImgView"
LFQH_l_.str.613:
.asciz	"bookshelf"
LFQH_l_.str.614:
.asciz	"fullGenreFloatingContainerView"
LFQH_l_.str.615:
.asciz	"layoutContainerView"
LFQH_l_.str.616:
.asciz	"filterView"
LFQH_l_.str.617:
.asciz	"mj_header"
LFQH_l_.str.618:
.asciz	"isDragging"
