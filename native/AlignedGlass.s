// Source SHA-256: 26835c6faf5234f873e987bdad77bace53ac12cffa41384ed1d4d4a6e1b8d6d8
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
adr x0, LFQH_l_.str.49
LFQH_Lloh9:
nop
bl Lpatch + (0xa5a4 - PATCH_BASE)
mov	x21, x0
LFQH_Lloh10:
adr x0, LFQH_l_.str.361
LFQH_Lloh11:
nop
bl Lpatch + (0xa5b0 - PATCH_BASE)
mov	x22, x0
LFQH_Lloh12:
adr x0, LFQH_l_.str.387
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
adr x0, LFQH_l_.str.361
LFQH_Lloh25:
nop
bl Lpatch + (0xa5b0 - PATCH_BASE)
mov	x22, x0
LFQH_Lloh26:
adr x0, LFQH_l_.str.387
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
cmp	w0, #0
cset	w20, ne
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
adr x0, LFQH_l_.str.388
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
cbz	w0, LFQH_LBB5_3
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
adr x21, LFQH_l_.str.389
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
add	w8, w26, #1
cmp	w26, #3
mov	x26, x8
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
adr x0, LFQH_l_.str.389
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
fmov	d8, d3
fmov	d9, d2
fmov	d10, d1
fmov	d11, d0
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
cbz	w0, LFQH_LBB11_19
bl	LFQH_FQHGlassAvailable
fmov	x8, d11
and	x8, x8, #0x7fffffffffffffff
mov	x10, #9218868437227405311
cmp	x8, x10
cset	w8, gt
fmov	x9, d10
and	x9, x9, #0x7fffffffffffffff
cmp	x9, x10
cset	w9, gt
fmov	x11, d9
and	x11, x11, #0x7fffffffffffffff
cmp	x11, x10
cset	w10, gt
cbz	w0, LFQH_LBB11_19
tbnz	w8, #0, LFQH_LBB11_19
tbnz	w9, #0, LFQH_LBB11_19
tbnz	w10, #0, LFQH_LBB11_19
fmov	x8, d8
and	x8, x8, #0x7fffffffffffffff
mov	x9, #9218868437227405311
cmp	x8, x9
b.gt	LFQH_LBB11_19
fcmp	d9, #0.0
b.le	LFQH_LBB11_19
fcmp	d8, #0.0
b.le	LFQH_LBB11_19
mov	x20, x22
cbnz	x22, LFQH_LBB11_13
bl	LFQH_NewGlassSurface
cbz	x0, LFQH_LBB11_20
mov	x20, x0
LFQH_Lloh88:
adr x0, LFQH_l_.str.166
LFQH_Lloh89:
nop
bl Lpatch + (0xa5a4 - PATCH_BASE)
mov	x1, x0
mov	x0, x20
mov	w2, #18
bl Lpatch + (0xa5d4 - PATCH_BASE)
LFQH_Lloh90:
adr x1, LFQH_SurfaceKey
LFQH_Lloh91:
nop
mov	x0, x19
mov	x2, x20
mov	w3, #1
bl Lpatch + (0xa634 - PATCH_BASE)
LFQH_Lloh92:
adr x0, LFQH_l_.str.56
LFQH_Lloh93:
nop
bl Lpatch + (0xa5a4 - PATCH_BASE)
mov	x1, x0
mov	x0, x20
bl Lpatch + (0xa5d4 - PATCH_BASE)
LFQH_LBB11_13:
LFQH_Lloh94:
adr x0, LFQH_l_.str.47
LFQH_Lloh95:
nop
bl Lpatch + (0xa5b0 - PATCH_BASE)
mov	x23, x0
LFQH_Lloh96:
adr x0, LFQH_l_.str.158
LFQH_Lloh97:
nop
bl Lpatch + (0xa5a4 - PATCH_BASE)
mov	x1, x0
mov	x0, x23
bl Lpatch + (0xa5d4 - PATCH_BASE)
mov	x23, x0
LFQH_Lloh98:
adr x0, LFQH_l_.str.363
LFQH_Lloh99:
nop
bl Lpatch + (0xa5a4 - PATCH_BASE)
mov	x1, x0
mov	x0, x20
bl Lpatch + (0xa5d4 - PATCH_BASE)
mov	x28, x0
LFQH_Lloh100:
adr x0, LFQH_l_.str.20
LFQH_Lloh101:
nop
bl Lpatch + (0xa5a4 - PATCH_BASE)
mov	x1, x0
mov	x0, x20
bl Lpatch + (0xa5d4 - PATCH_BASE)
str	x0, [sp, #32]
LFQH_Lloh102:
adr x0, LFQH_l_.str.372
LFQH_Lloh103:
nop
bl Lpatch + (0xa5a4 - PATCH_BASE)
mov	x1, x0
mov	x0, x20
bl Lpatch + (0xa5d4 - PATCH_BASE)
mov	w8, #1
str	w8, [sp, #44]
fcmp	d0, d11
b.ne	LFQH_LBB11_17
fcmp	d1, d10
b.ne	LFQH_LBB11_17
fcmp	d2, d9
b.ne	LFQH_LBB11_17
fcmp	d3, d8
cset	w8, ne
str	w8, [sp, #44]
LFQH_LBB11_17:
LFQH_Lloh104:
adr x0, LFQH_l_.str.390
LFQH_Lloh105:
nop
bl Lpatch + (0xa5a4 - PATCH_BASE)
mov	x1, x0
mov	x0, x20
bl Lpatch + (0xa5d4 - PATCH_BASE)
cmp	x0, x23
b.eq	LFQH_LBB11_21
mov	x24, x0
LFQH_Lloh106:
adr x0, LFQH_l_.str.49
LFQH_Lloh107:
nop
bl Lpatch + (0xa5a4 - PATCH_BASE)
mov	x1, x0
mov	x0, x24
mov	x2, x23
bl Lpatch + (0xa5d4 - PATCH_BASE)
cmp	w0, #0
cset	w8, eq
str	w8, [sp, #28]
b	LFQH_LBB11_22
LFQH_LBB11_19:
mov	x0, x19
mov	x1, x22
bl	LFQH_Restore
LFQH_LBB11_20:
LFQH_Lloh108:
adr x1, LFQH_BusyKey
LFQH_Lloh109:
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
LFQH_LBB11_21:
str	wzr, [sp, #28]
LFQH_LBB11_22:
LFQH_Lloh110:
adr x0, LFQH_l_.str.390
LFQH_Lloh111:
nop
bl Lpatch + (0xa5a4 - PATCH_BASE)
mov	x1, x0
mov	x0, x28
bl Lpatch + (0xa5d4 - PATCH_BASE)
cmp	x0, x23
b.eq	LFQH_LBB11_24
mov	x24, x0
LFQH_Lloh112:
adr x0, LFQH_l_.str.49
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
b	LFQH_LBB11_25
LFQH_LBB11_24:
str	wzr, [sp, #24]
LFQH_LBB11_25:
fmov	d12, xzr
cbz	w21, LFQH_LBB11_27
str	xzr, [sp, #8]
mov	w8, #0
mov	w27, #0
mov	w24, #0
mov	w25, #0
fmov	d13, xzr
mov	w26, #1
b	LFQH_LBB11_33
LFQH_LBB11_27:
LFQH_Lloh114:
adr x0, LFQH_l_.str.390
LFQH_Lloh115:
nop
bl Lpatch + (0xa5a4 - PATCH_BASE)
mov	x1, x0
mov	x0, x19
bl Lpatch + (0xa5d4 - PATCH_BASE)
cmp	x0, x23
str	x0, [sp, #8]
b.eq	LFQH_LBB11_29
mov	x24, x0
LFQH_Lloh116:
adr x0, LFQH_l_.str.49
LFQH_Lloh117:
nop
bl Lpatch + (0xa5a4 - PATCH_BASE)
mov	x1, x0
mov	x0, x24
mov	x2, x23
bl Lpatch + (0xa5d4 - PATCH_BASE)
cmp	w0, #0
cset	w25, eq
b	LFQH_LBB11_30
LFQH_LBB11_29:
mov	w25, #0
LFQH_LBB11_30:
LFQH_Lloh118:
adr x0, LFQH_l_.str.391
LFQH_Lloh119:
nop
bl Lpatch + (0xa5a4 - PATCH_BASE)
mov	x1, x0
mov	x0, x19
bl Lpatch + (0xa5d4 - PATCH_BASE)
mov	x27, x0
LFQH_Lloh120:
adr x0, LFQH_l_.str.392
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
cbz	x0, LFQH_LBB11_32
mov	x0, x19
bl	LFQH_Radius
fmov	d12, d0
mov	w26, #0
fcmp	d9, d8
fcsel	d0, d9, d8, mi
fmov	d1, #0.50000000
fmul	d13, d0, d1
mov	w8, #1
b	LFQH_LBB11_33
LFQH_LBB11_32:
mov	w8, #0
mov	w26, #1
fmov	d13, xzr
LFQH_LBB11_33:
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
tbnz	w9, #0, LFQH_LBB11_39
tbnz	w25, #0, LFQH_LBB11_39
cbnz	w24, LFQH_LBB11_39
cmp	w27, w8
b.ne	LFQH_LBB11_39
fcmp	d12, d13
b.ne	LFQH_LBB11_39
mov	x28, #0
b	LFQH_LBB11_40
LFQH_LBB11_39:
LFQH_Lloh124:
adr x0, LFQH_l_.str.393
LFQH_Lloh125:
nop
bl Lpatch + (0xa5b0 - PATCH_BASE)
mov	x28, x0
LFQH_Lloh126:
adr x0, LFQH_l_.str.394
LFQH_Lloh127:
nop
bl Lpatch + (0xa5a4 - PATCH_BASE)
mov	x1, x0
mov	x0, x28
bl Lpatch + (0xa5d4 - PATCH_BASE)
LFQH_Lloh128:
adr x0, LFQH_l_.str.395
LFQH_Lloh129:
nop
bl Lpatch + (0xa5a4 - PATCH_BASE)
mov	x1, x0
mov	x0, x28
mov	w2, #1
bl Lpatch + (0xa5d4 - PATCH_BASE)
LFQH_LBB11_40:
cbnz	w21, LFQH_LBB11_48
cmp	x22, #0
cset	w8, eq
orr	w8, w8, w25
tbz	w8, #0, LFQH_LBB11_43
LFQH_Lloh130:
adr x1, LFQH_BackgroundKey
LFQH_Lloh131:
nop
mov	x0, x19
ldr	x2, [sp, #8]
mov	w3, #1
bl Lpatch + (0xa634 - PATCH_BASE)
LFQH_LBB11_43:
mov	x0, x19
mov	x1, x27
mov	x2, x24
tbz	w26, #0, LFQH_LBB11_45
bl	LFQH_PrepareOwner
b	LFQH_LBB11_46
LFQH_LBB11_45:
fmov	d0, d12
fmov	d1, d13
bl	LFQH_PrepareHeaderOwner
LFQH_LBB11_46:
cbz	w25, LFQH_LBB11_48
LFQH_Lloh132:
adr x0, LFQH_l_.str.157
LFQH_Lloh133:
nop
bl Lpatch + (0xa5a4 - PATCH_BASE)
mov	x1, x0
mov	x0, x19
mov	x2, x23
bl Lpatch + (0xa5d4 - PATCH_BASE)
LFQH_LBB11_48:
ldr	w8, [sp, #44]
cbz	w8, LFQH_LBB11_50
LFQH_Lloh134:
adr x0, LFQH_l_.str.156
LFQH_Lloh135:
nop
bl Lpatch + (0xa5a4 - PATCH_BASE)
mov	x1, x0
mov	x0, x20
fmov	d0, d11
fmov	d1, d10
fmov	d2, d9
fmov	d3, d8
bl Lpatch + (0xa5d4 - PATCH_BASE)
LFQH_LBB11_50:
ldr	w8, [sp, #28]
cbz	w8, LFQH_LBB11_52
LFQH_Lloh136:
adr x0, LFQH_l_.str.157
LFQH_Lloh137:
nop
bl Lpatch + (0xa5a4 - PATCH_BASE)
mov	x1, x0
mov	x0, x20
mov	x2, x23
bl Lpatch + (0xa5d4 - PATCH_BASE)
LFQH_LBB11_52:
ldr	w8, [sp, #24]
cbz	w8, LFQH_LBB11_54
LFQH_Lloh138:
adr x0, LFQH_l_.str.157
LFQH_Lloh139:
nop
bl Lpatch + (0xa5a4 - PATCH_BASE)
mov	x1, x0
ldr	x0, [sp, #16]
mov	x2, x23
bl Lpatch + (0xa5d4 - PATCH_BASE)
LFQH_LBB11_54:
ldr	x8, [sp, #32]
cmp	x8, x19
b.eq	LFQH_LBB11_56
LFQH_Lloh140:
adr x0, LFQH_l_.str.396
LFQH_Lloh141:
nop
bl Lpatch + (0xa5a4 - PATCH_BASE)
mov	x1, x0
mov	x0, x19
mov	x2, x20
mov	x3, #0
bl Lpatch + (0xa5d4 - PATCH_BASE)
LFQH_LBB11_56:
cbz	x28, LFQH_LBB11_20
LFQH_Lloh142:
adr x0, LFQH_l_.str.397
LFQH_Lloh143:
nop
bl Lpatch + (0xa5a4 - PATCH_BASE)
mov	x1, x0
mov	x0, x28
bl Lpatch + (0xa5d4 - PATCH_BASE)
b	LFQH_LBB11_20
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
adr x0, LFQH_l_.str.361
LFQH_Lloh155:
nop
bl Lpatch + (0xa5b0 - PATCH_BASE)
mov	x21, x0
LFQH_Lloh156:
adr x0, LFQH_l_.str.387
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
fmov	d8, d0
fmov	d9, d1
fmov	d10, d2
fmov	d11, d3
LFQH_Lloh164:
adr x1, LFQH_HeaderLogKey
LFQH_Lloh165:
nop
mov	x0, x19
bl Lpatch + (0xa628 - PATCH_BASE)
cbz	x0, LFQH_LBB12_9
mov	x20, x0
LFQH_Lloh166:
adr x0, LFQH_l_.str.432
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
adr x0, LFQH_l_.str.407
LFQH_Lloh169:
nop
bl Lpatch + (0xa5b0 - PATCH_BASE)
mov	x20, x0
LFQH_Lloh170:
adr x0, LFQH_l_.str.408
LFQH_Lloh171:
nop
bl Lpatch + (0xa5a4 - PATCH_BASE)
mov	x1, x0
mov	x0, x20
bl Lpatch + (0xa5d4 - PATCH_BASE)
mov	x20, x0
LFQH_Lloh172:
adr x0, LFQH_l_.str.409
LFQH_Lloh173:
nop
bl Lpatch + (0xa5a4 - PATCH_BASE)
mov	x1, x0
mov	x0, x20
bl Lpatch + (0xa5d4 - PATCH_BASE)
fmov	d12, d0
LFQH_Lloh174:
adr x1, LFQH_HeaderLogTimeKey
LFQH_Lloh175:
nop
mov	x0, x19
bl Lpatch + (0xa628 - PATCH_BASE)
cbz	x0, LFQH_LBB12_12
mov	x20, x0
LFQH_Lloh176:
adr x0, LFQH_l_.str.445
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
adr x0, LFQH_l_.str.512
LFQH_Lloh179:
nop
bl Lpatch + (0xa5b0 - PATCH_BASE)
mov	x20, x0
LFQH_Lloh180:
adr x0, LFQH_l_.str.513
LFQH_Lloh181:
nop
bl Lpatch + (0xa5a4 - PATCH_BASE)
mov	x1, x0
mov	x0, x20
fmov	d0, d8
fmov	d1, d9
fmov	d2, d10
fmov	d3, d11
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
adr x21, LFQH_l_.str.497
LFQH_Lloh185:
nop
mov	x0, x21
bl Lpatch + (0xa5b0 - PATCH_BASE)
mov	x20, x0
LFQH_Lloh186:
adr x22, LFQH_l_.str.515
LFQH_Lloh187:
nop
mov	x0, x22
bl Lpatch + (0xa5a4 - PATCH_BASE)
mov	x1, x0
mov	x0, x20
fmov	d0, d12
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
adr x0, LFQH_l_.str.88
LFQH_Lloh191:
nop
bl Lpatch + (0xa5b0 - PATCH_BASE)
mov	x20, x0
LFQH_Lloh192:
adr x0, LFQH_l_.str.89
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
adr x1, LFQH_l_.str.410
LFQH_Lloh197:
nop
mov	x0, x20
bl	LFQH_Put
LFQH_Lloh198:
adr x23, LFQH_l_.str.372
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
adr x1, LFQH_l_.str.411
LFQH_Lloh201:
nop
mov	x0, x20
bl	LFQH_Put
fmov	d0, d8
fmov	d1, d9
fmov	d2, d10
fmov	d3, d11
bl	LFQH_RectArray
mov	x2, x0
LFQH_Lloh202:
adr x1, LFQH_l_.str.412
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
adr x1, LFQH_l_.str.413
LFQH_Lloh207:
nop
mov	x0, x20
bl	LFQH_Put
LFQH_Lloh208:
adr x23, LFQH_l_.str.391
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
adr x24, LFQH_l_.str.499
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
adr x0, LFQH_l_.str.403
LFQH_Lloh213:
nop
bl Lpatch + (0xa5a4 - PATCH_BASE)
mov	x1, x0
mov	x0, x19
bl Lpatch + (0xa5d4 - PATCH_BASE)
mov	x23, x0
LFQH_Lloh214:
adr x25, LFQH_l_.str.404
LFQH_Lloh215:
nop
mov	x0, x25
bl Lpatch + (0xa5a4 - PATCH_BASE)
mov	x1, x0
mov	x0, x23
bl Lpatch + (0xa5d4 - PATCH_BASE)
fmov	d8, d0
mov	x0, x21
bl Lpatch + (0xa5b0 - PATCH_BASE)
mov	x23, x0
mov	x0, x22
bl Lpatch + (0xa5a4 - PATCH_BASE)
mov	x1, x0
mov	x0, x23
fmov	d0, d8
bl Lpatch + (0xa5d4 - PATCH_BASE)
mov	x2, x0
mov	x0, x20
mov	x1, x25
bl	LFQH_Put
LFQH_Lloh216:
adr x1, LFQH_l_.str.414
LFQH_Lloh217:
nop
mov	x0, x19
bl	LFQH_Get
mov	x19, x0
LFQH_Lloh218:
adr x0, LFQH_l_.str.116
LFQH_Lloh219:
nop
bl Lpatch + (0xa5b0 - PATCH_BASE)
mov	x23, x0
LFQH_Lloh220:
adr x0, LFQH_l_.str.415
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
fmov	d0, d8
bl Lpatch + (0xa5d4 - PATCH_BASE)
mov	x2, x0
LFQH_Lloh224:
adr x1, LFQH_l_.str.416
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
adr x1, LFQH_l_.str.417
LFQH_Lloh227:
nop
mov	x0, x20
bl	LFQH_Put
cbz	x25, LFQH_LBB12_15
mov	x21, #0
LFQH_Lloh228:
adr x22, LFQH_l_.str.84
LFQH_Lloh229:
nop
LFQH_Lloh230:
adr x24, LFQH_l_.str.461
LFQH_Lloh231:
nop
LFQH_Lloh232:
adr x25, LFQH_l_.str.372
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
adr x1, LFQH_l_.str.418
LFQH_Lloh235:
nop
mov	x0, x20
mov	x2, x23
bl	LFQH_Put
LFQH_Lloh236:
adr x0, LFQH_l_.str.419
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
sub	sp, sp, #288
stp	d15, d14, [sp, #128]
stp	d13, d12, [sp, #144]
stp	d11, d10, [sp, #160]
stp	d9, d8, [sp, #176]
stp	x28, x27, [sp, #192]
stp	x26, x25, [sp, #208]
stp	x24, x23, [sp, #224]
stp	x22, x21, [sp, #240]
stp	x20, x19, [sp, #256]
stp	x29, x30, [sp, #272]
add	x29, sp, #272
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
ldp	x29, x30, [sp, #272]
ldp	x20, x19, [sp, #256]
ldp	x22, x21, [sp, #240]
ldp	x24, x23, [sp, #224]
ldp	x26, x25, [sp, #208]
ldp	x28, x27, [sp, #192]
ldp	d9, d8, [sp, #176]
ldp	d11, d10, [sp, #160]
ldp	d13, d12, [sp, #144]
ldp	d15, d14, [sp, #128]
add	sp, sp, #288
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
fmov	d12, d0
fmov	d13, d1
fmov	d14, d2
fmov	d15, d3
bl	LFQH_Enabled
cbz	w0, LFQH_LBB18_13
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
cbz	w0, LFQH_LBB18_13
fmov	x8, d12
fmov	x9, d13
fmov	x10, d14
and	x11, x8, #0x7fffffffffffffff
and	x8, x9, #0x7fffffffffffffff
mov	x12, #9218868437227405311
cmp	x8, x12
cset	w8, gt
and	x9, x10, #0x7fffffffffffffff
cmp	x9, x12
cset	w9, gt
cmp	x11, x12
b.gt	LFQH_LBB18_13
tbnz	w8, #0, LFQH_LBB18_13
tbnz	w9, #0, LFQH_LBB18_13
fmov	x8, d15
and	x8, x8, #0x7fffffffffffffff
mov	x9, #9218868437227405311
cmp	x8, x9
b.gt	LFQH_LBB18_13
fcmp	d14, #0.0
b.le	LFQH_LBB18_13
fcmp	d15, #0.0
b.le	LFQH_LBB18_13
LFQH_Lloh258:
adr x1, LFQH_l_.str.138
LFQH_Lloh259:
nop
mov	x0, x19
bl	LFQH_Kind
cbz	w0, LFQH_LBB18_16
LFQH_Lloh260:
adr x1, LFQH_l_.str.420
LFQH_Lloh261:
nop
mov	x0, x19
bl	LFQH_Get
mov	x28, x0
b	LFQH_LBB18_17
LFQH_LBB18_13:
mov	x0, x19
mov	x1, x21
LFQH_LBB18_14:
bl	LFQH_RestoreIcon
LFQH_LBB18_15:
LFQH_Lloh262:
adr x1, LFQH_BusyKey
LFQH_Lloh263:
nop
mov	x0, x19
mov	x2, #0
mov	x3, #0
ldp	x29, x30, [sp, #272]
ldp	x20, x19, [sp, #256]
ldp	x22, x21, [sp, #240]
ldp	x24, x23, [sp, #224]
ldp	x26, x25, [sp, #208]
ldp	x28, x27, [sp, #192]
ldp	d9, d8, [sp, #176]
ldp	d11, d10, [sp, #160]
ldp	d13, d12, [sp, #144]
ldp	d15, d14, [sp, #128]
add	sp, sp, #288
b Lpatch + (0xa634 - PATCH_BASE)
LFQH_LBB18_16:
mov	x28, #0
LFQH_LBB18_17:
str	x21, [sp, #112]
cmp	w20, #11
b.ne	LFQH_LBB18_33
cbnz	x28, LFQH_LBB18_33
LFQH_Lloh264:
adr x1, LFQH_l_.str.414
LFQH_Lloh265:
nop
mov	x0, x19
bl	LFQH_Get
mov	x23, x0
LFQH_Lloh266:
adr x0, LFQH_l_.str.34
LFQH_Lloh267:
nop
bl Lpatch + (0xa5a4 - PATCH_BASE)
mov	x1, x0
mov	x0, x23
bl Lpatch + (0xa5d4 - PATCH_BASE)
sub	x8, x0, #9
cmn	x8, #8
b.hs	LFQH_LBB18_21
LFQH_LBB18_20:
mov	w27, #0
mov	x28, #0
b	LFQH_LBB18_41
LFQH_LBB18_21:
mov	x24, x0
mov	x22, #0
mov	x25, #0
LFQH_Lloh268:
adr x26, LFQH_l_.str.461
LFQH_Lloh269:
nop
LFQH_Lloh270:
adr x27, LFQH_l_.str.70
LFQH_Lloh271:
nop
mov	x21, #9218868437227405311
LFQH_LBB18_22:
mov	x0, x26
bl Lpatch + (0xa5a4 - PATCH_BASE)
mov	x1, x0
mov	x0, x23
mov	x2, x25
bl Lpatch + (0xa5d4 - PATCH_BASE)
mov	x28, x0
mov	x1, x27
bl	LFQH_Kind
cbz	w0, LFQH_LBB18_24
LFQH_Lloh272:
adr x0, LFQH_l_.str.71
LFQH_Lloh273:
nop
bl Lpatch + (0xa5a4 - PATCH_BASE)
mov	x1, x0
mov	x0, x28
bl Lpatch + (0xa5d4 - PATCH_BASE)
cbz	w0, LFQH_LBB18_26
LFQH_LBB18_24:
mov	x28, x22
LFQH_LBB18_25:
add	x25, x25, #1
mov	x22, x28
cmp	x24, x25
b.ne	LFQH_LBB18_22
b	LFQH_LBB18_33
LFQH_LBB18_26:
LFQH_Lloh274:
adr x0, LFQH_l_.str.24
LFQH_Lloh275:
nop
bl Lpatch + (0xa5a4 - PATCH_BASE)
mov	x1, x0
mov	x0, x28
bl Lpatch + (0xa5d4 - PATCH_BASE)
fmov	x9, d2
fmov	x8, d1
fmov	x10, d0
and	x10, x10, #0x7fffffffffffffff
and	x8, x8, #0x7fffffffffffffff
cmp	x8, x21
cset	w8, gt
and	x9, x9, #0x7fffffffffffffff
cmp	x9, x21
cset	w9, gt
cmp	x10, x21
b.gt	LFQH_LBB18_24
tbnz	w8, #0, LFQH_LBB18_24
tbnz	w9, #0, LFQH_LBB18_24
fmov	x8, d3
and	x8, x8, #0x7fffffffffffffff
cmp	x8, x21
b.gt	LFQH_LBB18_24
fcmp	d2, #0.0
b.le	LFQH_LBB18_24
fcmp	d3, #0.0
b.le	LFQH_LBB18_24
cbz	x22, LFQH_LBB18_25
b	LFQH_LBB18_20
LFQH_LBB18_33:
cbz	x28, LFQH_LBB18_38
mov	w21, #0
LFQH_Lloh276:
adr x23, LFQH_l_.str.20
LFQH_Lloh277:
nop
mov	x0, x28
mov	w27, #1
LFQH_LBB18_35:
cmp	x0, x19
b.eq	LFQH_LBB18_39
mov	x1, x23
bl	LFQH_Get
cbz	x0, LFQH_LBB18_41
add	w8, w21, #1
cmp	w21, #7
mov	x21, x8
b.lo	LFQH_LBB18_35
b	LFQH_LBB18_41
LFQH_LBB18_38:
mov	w27, #0
b	LFQH_LBB18_41
LFQH_LBB18_39:
LFQH_Lloh278:
adr x0, LFQH_l_.str.71
LFQH_Lloh279:
nop
bl Lpatch + (0xa5a4 - PATCH_BASE)
mov	x1, x0
mov	x0, x28
bl Lpatch + (0xa5d4 - PATCH_BASE)
cbz	w0, LFQH_LBB18_89
LFQH_LBB18_40:
mov	w27, #1
LFQH_LBB18_41:
fmov	d8, d12
fmov	d9, d13
fmov	d10, d14
fmov	d11, d15
LFQH_LBB18_42:
sub	w26, w20, #9
sub	w21, w20, #2
cmp	w26, #2
ccmp	w21, #4, #0, hi
b.hi	LFQH_LBB18_68
cbz	x28, LFQH_LBB18_68
cbz	w27, LFQH_LBB18_68
mov	w22, #0
LFQH_Lloh280:
adr x23, LFQH_l_.str.20
LFQH_Lloh281:
nop
mov	x0, x28
LFQH_LBB18_46:
cmp	x0, x19
b.eq	LFQH_LBB18_49
mov	x1, x23
bl	LFQH_Get
cbz	x0, LFQH_LBB18_68
add	w8, w22, #1
cmp	w22, #7
mov	x22, x8
b.lo	LFQH_LBB18_46
b	LFQH_LBB18_68
LFQH_LBB18_49:
LFQH_Lloh282:
adr x1, LFQH_GlyphViewKey
LFQH_Lloh283:
nop
mov	x0, x19
bl Lpatch + (0xa628 - PATCH_BASE)
mov	x23, x0
cmp	x0, x28
b.eq	LFQH_LBB18_51
mov	x0, x19
bl	LFQH_RestoreGlyph
LFQH_LBB18_51:
LFQH_Lloh284:
adr x0, LFQH_l_.str.372
LFQH_Lloh285:
nop
bl Lpatch + (0xa5a4 - PATCH_BASE)
mov	x1, x0
mov	x0, x28
bl Lpatch + (0xa5d4 - PATCH_BASE)
stp	d1, d0, [sp, #64]
stp	d3, d2, [sp, #48]
LFQH_Lloh286:
adr x1, LFQH_GlyphOriginalKey
LFQH_Lloh287:
nop
mov	x0, x28
bl Lpatch + (0xa628 - PATCH_BASE)
mov	x25, x0
LFQH_Lloh288:
adr x1, LFQH_GlyphAppliedKey
LFQH_Lloh289:
nop
mov	x0, x28
bl Lpatch + (0xa628 - PATCH_BASE)
mov	x24, x0
cbz	x0, LFQH_LBB18_57
LFQH_Lloh290:
adr x0, LFQH_l_.str.432
LFQH_Lloh291:
nop
bl Lpatch + (0xa5a4 - PATCH_BASE)
mov	x1, x0
mov	x0, x24
bl Lpatch + (0xa5d4 - PATCH_BASE)
stp	d3, d2, [sp, #24]
str	d0, [sp, #40]
str	d1, [sp, #16]
cbz	x25, LFQH_LBB18_58
fmov	d4, d0
ldr	d0, [sp, #72]
fcmp	d0, d4
b.ne	LFQH_LBB18_58
ldr	d0, [sp, #64]
fcmp	d0, d1
b.ne	LFQH_LBB18_58
ldr	d0, [sp, #56]
ldr	d1, [sp, #32]
fcmp	d0, d1
b.ne	LFQH_LBB18_58
ldr	d0, [sp, #48]
ldr	d1, [sp, #24]
fcmp	d0, d1
b.eq	LFQH_LBB18_59
b	LFQH_LBB18_58
LFQH_LBB18_57:
fmov	d0, xzr
stp	d0, d0, [sp, #32]
stp	d0, d0, [sp, #16]
LFQH_LBB18_58:
ldp	d1, d0, [sp, #64]
ldp	d3, d2, [sp, #48]
bl	LFQH_RectBox
mov	x25, x0
LFQH_Lloh292:
adr x1, LFQH_GlyphOriginalKey
LFQH_Lloh293:
nop
mov	x0, x28
mov	x2, x25
mov	w3, #1
bl Lpatch + (0xa634 - PATCH_BASE)
LFQH_LBB18_59:
stp	d11, d10, [sp, #80]
str	d9, [sp, #96]
LFQH_Lloh294:
adr x0, LFQH_l_.str.432
LFQH_Lloh295:
nop
bl Lpatch + (0xa5a4 - PATCH_BASE)
mov	x1, x0
mov	x0, x25
bl Lpatch + (0xa5d4 - PATCH_BASE)
cmp	w21, #5
str	d8, [sp, #104]
b.hs	LFQH_LBB18_92
LFQH_LBB18_60:
fmaxnm	d4, d2, d3
fmov	d5, #20.00000000
fdiv	d6, d5, d4
fcmp	d4, d5
fmov	d4, #1.00000000
fcsel	d4, d6, d4, gt
fmul	d11, d2, d4
fmul	d10, d3, d4
fsub	d4, d2, d11
fmov	d5, #0.50000000
fmul	d4, d4, d5
fmul	d2, d2, d5
cmp	w20, #2
fmov	d6, xzr
fcsel	d2, d2, d6, eq
fadd	d2, d2, d4
fadd	d9, d0, d2
fsub	d0, d3, d10
fmul	d0, d0, d5
LFQH_LBB18_61:
fadd	d8, d1, d0
ldp	d0, d1, [sp, #64]
fcmp	d1, d9
fccmp	d0, d8, #0, eq
ldp	d0, d1, [sp, #48]
fccmp	d1, d11, #0, eq
fccmp	d0, d10, #0, eq
b.eq	LFQH_LBB18_63
LFQH_Lloh296:
adr x0, LFQH_l_.str.156
LFQH_Lloh297:
nop
bl Lpatch + (0xa5a4 - PATCH_BASE)
mov	x1, x0
mov	x0, x28
fmov	d0, d9
fmov	d1, d8
fmov	d2, d11
fmov	d3, d10
bl Lpatch + (0xa5d4 - PATCH_BASE)
LFQH_LBB18_63:
ldr	d0, [sp, #40]
cbz	x24, LFQH_LBB18_65
fcmp	d0, d9
ldr	d0, [sp, #16]
fccmp	d0, d8, #0, eq
ldp	d0, d1, [sp, #24]
fccmp	d1, d11, #0, eq
fccmp	d0, d10, #0, eq
b.eq	LFQH_LBB18_66
LFQH_LBB18_65:
fmov	d0, d9
fmov	d1, d8
fmov	d2, d11
fmov	d3, d10
bl	LFQH_RectBox
mov	x2, x0
LFQH_Lloh298:
adr x1, LFQH_GlyphAppliedKey
LFQH_Lloh299:
nop
mov	x0, x28
mov	w3, #1
bl Lpatch + (0xa634 - PATCH_BASE)
LFQH_LBB18_66:
cmp	x23, x28
ldp	d9, d8, [sp, #96]
ldp	d11, d10, [sp, #80]
b.eq	LFQH_LBB18_68
LFQH_Lloh300:
adr x1, LFQH_GlyphViewKey
LFQH_Lloh301:
nop
mov	x0, x19
mov	x2, x28
mov	w3, #1
bl Lpatch + (0xa634 - PATCH_BASE)
LFQH_LBB18_68:
cmp	w26, #2
mov	w8, #36
mov	w9, #28
csel	w21, w9, w8, lo
subs	w26, w20, #2
mov	w8, #6
csel	w22, w8, wzr, eq
cmp	w20, #9
mov	w8, #12
csel	w24, w8, wzr, eq
cmp	w20, #8
b.eq	LFQH_LBB18_70
cmp	w20, #5
b.ne	LFQH_LBB18_72
LFQH_LBB18_70:
LFQH_Lloh302:
adr x1, LFQH_l_.str.36
LFQH_Lloh303:
nop
mov	x0, x19
bl	LFQH_Kind
cbz	w0, LFQH_LBB18_72
LFQH_Lloh304:
adr x0, LFQH_l_.str.20
LFQH_Lloh305:
nop
bl Lpatch + (0xa5a4 - PATCH_BASE)
mov	x1, x0
mov	x0, x19
bl Lpatch + (0xa5d4 - PATCH_BASE)
mov	x23, x0
mov	w25, #1
b	LFQH_LBB18_73
LFQH_LBB18_72:
mov	w25, #0
mov	x23, x19
LFQH_LBB18_73:
cbz	x23, LFQH_LBB18_88
mov	x0, x19
bl	LFQH_CanExpandHit
cbz	w0, LFQH_LBB18_88
cbz	w25, LFQH_LBB18_78
LFQH_Lloh306:
adr x0, LFQH_l_.str.71
LFQH_Lloh307:
nop
bl Lpatch + (0xa5a4 - PATCH_BASE)
mov	x1, x0
mov	x0, x19
bl Lpatch + (0xa5d4 - PATCH_BASE)
cbnz	w0, LFQH_LBB18_88
stp	d11, d10, [sp, #80]
stp	d9, d8, [sp, #96]
fmov	d0, #-6.00000000
fadd	d8, d12, d0
fmov	d0, #-5.00000000
fadd	d9, d13, d0
fmov	d0, #12.00000000
fadd	d10, d14, d0
fmov	d0, #10.00000000
fadd	d11, d15, d0
b	LFQH_LBB18_79
LFQH_LBB18_78:
stp	d11, d10, [sp, #80]
stp	d9, d8, [sp, #96]
fmov	d0, #0.50000000
fmul	d1, d14, d0
ucvtf	d2, w22
fadd	d1, d12, d1
fadd	d1, d1, d2
ucvtf	d2, w24
fmul	d0, d15, d0
fsub	d1, d1, d2
ucvtf	d2, w21, #1
fadd	d0, d13, d0
ucvtf	d3, w21
fsub	d1, d1, d2
fsub	d0, d0, d2
cmp	w20, #7
fmov	d2, #6.00000000
fadd	d2, d15, d2
fmov	d4, #30.00000000
fmaxnm	d2, d2, d4
fmov	d4, #-6.00000000
fadd	d4, d12, d4
fsub	d5, d15, d2
fmov	d6, #0.50000000
fmul	d5, d5, d6
fadd	d5, d13, d5
fmov	d6, #12.00000000
fadd	d6, d14, d6
fcsel	d8, d1, d4, ne
fcsel	d9, d0, d5, ne
fcsel	d10, d3, d6, ne
fcsel	d11, d3, d2, ne
LFQH_LBB18_79:
fmov	d0, d8
fmov	d1, d9
fmov	d2, d10
fmov	d3, d11
bl	LFQH_VisibleRect
cbz	w0, LFQH_LBB18_88
ldr	x8, [sp, #112]
cbz	x8, LFQH_LBB18_94
LFQH_LBB18_81:
cmp	w20, #8
eor	w8, w25, #0x1
csinc	w8, w8, wzr, eq
tbnz	w8, #0, LFQH_LBB18_83
mov	x0, x19
mov	x1, x23
fmov	d0, d12
fmov	d1, d13
fmov	d2, d14
fmov	d3, d15
bl	LFQH_ReaderShelfMaterial
fmov	d8, d0
fmov	d9, d1
fmov	d10, d2
mov	x8, #4630263366890291200
fmov	d11, x8
LFQH_LBB18_83:
fmov	d12, d10
fmov	d13, d9
fmov	d14, d8
fmov	d15, d11
cbz	w25, LFQH_LBB18_85
LFQH_Lloh308:
adr x0, LFQH_l_.str.507
LFQH_Lloh309:
nop
bl Lpatch + (0xa5a4 - PATCH_BASE)
mov	x1, x0
mov	x0, x19
fmov	d0, d8
fmov	d1, d9
fmov	d2, d10
fmov	d3, d11
mov	x2, x23
bl Lpatch + (0xa5d4 - PATCH_BASE)
fmov	d14, d0
fmov	d13, d1
fmov	d12, d2
fmov	d15, d3
LFQH_LBB18_85:
LFQH_Lloh310:
adr x1, LFQH_IconRectKey
LFQH_Lloh311:
nop
mov	x0, x19
bl Lpatch + (0xa628 - PATCH_BASE)
cbz	x0, LFQH_LBB18_97
mov	x24, x0
LFQH_Lloh312:
adr x0, LFQH_l_.str.432
LFQH_Lloh313:
nop
bl Lpatch + (0xa5a4 - PATCH_BASE)
mov	x1, x0
mov	x0, x24
bl Lpatch + (0xa5d4 - PATCH_BASE)
fcmp	d0, d14
fccmp	d1, d13, #0, eq
fccmp	d2, d12, #0, eq
b.eq	LFQH_LBB18_98
mov	w8, #0
b	LFQH_LBB18_99
LFQH_LBB18_88:
mov	x0, x19
ldr	x1, [sp, #112]
b	LFQH_LBB18_14
LFQH_LBB18_89:
LFQH_Lloh314:
adr x0, LFQH_l_.str.24
LFQH_Lloh315:
nop
bl Lpatch + (0xa5a4 - PATCH_BASE)
mov	x1, x0
mov	x0, x28
bl Lpatch + (0xa5d4 - PATCH_BASE)
bl	LFQH_VisibleRect
cbz	w0, LFQH_LBB18_40
LFQH_Lloh316:
adr x0, LFQH_l_.str.24
LFQH_Lloh317:
nop
bl Lpatch + (0xa5a4 - PATCH_BASE)
mov	x1, x0
mov	x0, x28
bl Lpatch + (0xa5d4 - PATCH_BASE)
fmov	d8, d0
fmov	d9, d1
fmov	d10, d2
fmov	d11, d3
LFQH_Lloh318:
adr x0, LFQH_l_.str.507
LFQH_Lloh319:
nop
bl Lpatch + (0xa5a4 - PATCH_BASE)
mov	x1, x0
mov	x0, x28
fmov	d0, d8
fmov	d1, d9
fmov	d2, d10
fmov	d3, d11
mov	x2, x19
bl Lpatch + (0xa5d4 - PATCH_BASE)
fmov	d8, d0
fmov	d9, d1
fmov	d10, d2
fmov	d11, d3
bl	LFQH_VisibleRect
cbz	w0, LFQH_LBB18_40
mov	w27, #1
b	LFQH_LBB18_42
LFQH_LBB18_92:
cmp	w20, #11
b.eq	LFQH_LBB18_60
fmov	d4, #0.75000000
fmul	d11, d2, d4
fmul	d10, d3, d4
fmov	d4, #0.12500000
fmul	d5, d2, d4
fadd	d5, d0, d5
fmul	d0, d3, d4
fmov	d3, #-12.00000000
fadd	d3, d5, d3
cmp	w20, #9
fcsel	d3, d3, d5, eq
cmp	w20, #10
fmov	d4, #-0.25000000
fmul	d2, d2, d4
fadd	d2, d5, d2
fcsel	d9, d3, d2, ne
b	LFQH_LBB18_61
LFQH_LBB18_94:
LFQH_Lloh320:
adr x0, LFQH_l_.str.28
LFQH_Lloh321:
nop
bl Lpatch + (0xa5b0 - PATCH_BASE)
mov	x21, x0
LFQH_Lloh322:
adr x0, LFQH_l_.str.29
LFQH_Lloh323:
nop
bl Lpatch + (0xa5a4 - PATCH_BASE)
mov	x1, x0
mov	x0, x21
bl Lpatch + (0xa5d4 - PATCH_BASE)
cbz	x0, LFQH_LBB18_140
mov	x24, x0
bl	LFQH_GlassClass
mov	x21, x0
LFQH_Lloh324:
adr x0, LFQH_l_.str.421
LFQH_Lloh325:
nop
bl Lpatch + (0xa5a4 - PATCH_BASE)
mov	x1, x0
mov	x0, x21
bl Lpatch + (0xa5d4 - PATCH_BASE)
str	x0, [sp, #112]
cbz	x0, LFQH_LBB18_140
LFQH_Lloh326:
adr x0, LFQH_l_.str.422
LFQH_Lloh327:
nop
bl Lpatch + (0xa5a4 - PATCH_BASE)
mov	x1, x0
ldr	x21, [sp, #112]
mov	x0, x21
mov	x2, x24
bl Lpatch + (0xa5d4 - PATCH_BASE)
LFQH_Lloh328:
adr x0, LFQH_l_.str.399
LFQH_Lloh329:
nop
bl Lpatch + (0xa5a4 - PATCH_BASE)
mov	x1, x0
mov	x0, x21
mov	w2, #0
bl Lpatch + (0xa5d4 - PATCH_BASE)
LFQH_Lloh330:
adr x0, LFQH_l_.str.400
LFQH_Lloh331:
nop
bl Lpatch + (0xa5a4 - PATCH_BASE)
mov	x1, x0
mov	x0, x21
mov	w2, #1
bl Lpatch + (0xa5d4 - PATCH_BASE)
LFQH_Lloh332:
adr x0, LFQH_l_.str.401
LFQH_Lloh333:
nop
bl Lpatch + (0xa5a4 - PATCH_BASE)
mov	x1, x0
mov	x0, x21
mov	w2, #0
bl Lpatch + (0xa5d4 - PATCH_BASE)
LFQH_Lloh334:
adr x0, LFQH_l_.str.402
LFQH_Lloh335:
nop
bl Lpatch + (0xa5a4 - PATCH_BASE)
mov	x1, x0
mov	x0, x21
mov	w2, #0
bl Lpatch + (0xa5d4 - PATCH_BASE)
LFQH_Lloh336:
adr x0, LFQH_l_.str.166
LFQH_Lloh337:
nop
bl Lpatch + (0xa5a4 - PATCH_BASE)
mov	x1, x0
mov	x0, x21
mov	x2, #0
bl Lpatch + (0xa5d4 - PATCH_BASE)
LFQH_Lloh338:
adr x1, LFQH_IconGlassKey
LFQH_Lloh339:
nop
mov	x0, x19
mov	x2, x21
mov	w3, #1
bl Lpatch + (0xa634 - PATCH_BASE)
LFQH_Lloh340:
adr x0, LFQH_l_.str.56
LFQH_Lloh341:
nop
bl Lpatch + (0xa5a4 - PATCH_BASE)
mov	x1, x0
mov	x0, x21
bl Lpatch + (0xa5d4 - PATCH_BASE)
mov	x0, x19
mov	x1, x21
mov	w2, #1
bl	LFQH_ObservePress
b	LFQH_LBB18_81
LFQH_LBB18_97:
mov	w8, #1
b	LFQH_LBB18_100
LFQH_LBB18_98:
fcmp	d3, d15
cset	w8, eq
LFQH_LBB18_99:
eor	w8, w8, #0x1
LFQH_LBB18_100:
str	w8, [sp, #64]
LFQH_Lloh342:
adr x0, LFQH_l_.str.20
LFQH_Lloh343:
nop
bl Lpatch + (0xa5a4 - PATCH_BASE)
mov	x1, x0
ldr	x0, [sp, #112]
bl Lpatch + (0xa5d4 - PATCH_BASE)
str	x0, [sp, #72]
tbz	w25, #0, LFQH_LBB18_102
str	wzr, [sp, #12]
str	wzr, [sp, #40]
mov	w22, #0
b	LFQH_LBB18_103
LFQH_LBB18_102:
LFQH_Lloh344:
adr x0, LFQH_l_.str.391
LFQH_Lloh345:
nop
bl Lpatch + (0xa5a4 - PATCH_BASE)
mov	x1, x0
mov	x0, x19
bl Lpatch + (0xa5d4 - PATCH_BASE)
cmp	w0, #0
cset	w21, ne
LFQH_Lloh346:
adr x0, LFQH_l_.str.392
LFQH_Lloh347:
nop
bl Lpatch + (0xa5a4 - PATCH_BASE)
mov	x1, x0
mov	x0, x19
bl Lpatch + (0xa5d4 - PATCH_BASE)
cmp	w0, #0
cset	w22, ne
str	w21, [sp, #12]
str	w21, [sp, #40]
LFQH_LBB18_103:
str	w26, [sp, #48]
LFQH_Lloh348:
adr x1, LFQH_l_.str.42
LFQH_Lloh349:
nop
mov	x0, x19
bl	LFQH_Kind
str	w22, [sp, #56]
cbz	w0, LFQH_LBB18_105
LFQH_Lloh350:
adr x0, LFQH_l_.str.423
LFQH_Lloh351:
nop
bl Lpatch + (0xa5a4 - PATCH_BASE)
mov	x1, x0
mov	x0, x19
bl Lpatch + (0xa5d4 - PATCH_BASE)
ldr	x24, [sp, #112]
mov	x22, x0
LFQH_Lloh352:
adr x0, LFQH_l_.str.424
LFQH_Lloh353:
nop
bl Lpatch + (0xa5a4 - PATCH_BASE)
mov	x1, x0
mov	x0, x19
bl Lpatch + (0xa5d4 - PATCH_BASE)
mov	x21, x0
LFQH_Lloh354:
adr x0, LFQH_l_.str.425
LFQH_Lloh355:
nop
bl Lpatch + (0xa5a4 - PATCH_BASE)
mov	x1, x0
mov	x0, x19
bl Lpatch + (0xa5d4 - PATCH_BASE)
mov	x26, x0
LFQH_Lloh356:
adr x0, LFQH_l_.str.423
LFQH_Lloh357:
nop
bl Lpatch + (0xa5a4 - PATCH_BASE)
mov	x1, x0
mov	x0, x24
bl Lpatch + (0xa5d4 - PATCH_BASE)
str	w22, [sp, #16]
cmp	w0, w22
mov	x22, x24
cset	w24, ne
LFQH_Lloh358:
adr x0, LFQH_l_.str.424
LFQH_Lloh359:
nop
bl Lpatch + (0xa5a4 - PATCH_BASE)
mov	x1, x0
mov	x0, x22
bl Lpatch + (0xa5d4 - PATCH_BASE)
str	w21, [sp, #24]
cmp	w0, w21
cset	w21, ne
LFQH_Lloh360:
adr x0, LFQH_l_.str.425
LFQH_Lloh361:
nop
bl Lpatch + (0xa5a4 - PATCH_BASE)
mov	x1, x0
mov	x0, x22
ldr	w22, [sp, #56]
bl Lpatch + (0xa5d4 - PATCH_BASE)
str	w26, [sp, #32]
cmp	w0, w26
cset	w26, ne
b	LFQH_LBB18_106
LFQH_LBB18_105:
mov	w24, #0
mov	w21, #0
mov	w26, #0
str	wzr, [sp, #16]
str	wzr, [sp, #24]
str	wzr, [sp, #32]
LFQH_LBB18_106:
ldr	x8, [sp, #72]
cmp	x8, x23
ldr	w8, [sp, #64]
csinc	w8, w8, wzr, eq
ldr	w9, [sp, #40]
orr	w8, w8, w9
tbnz	w8, #0, LFQH_LBB18_112
tbnz	w22, #0, LFQH_LBB18_112
tbnz	w24, #0, LFQH_LBB18_112
tbnz	w21, #0, LFQH_LBB18_112
cbnz	w26, LFQH_LBB18_112
str	xzr, [sp, #40]
b	LFQH_LBB18_113
LFQH_LBB18_112:
LFQH_Lloh362:
adr x0, LFQH_l_.str.393
LFQH_Lloh363:
nop
bl Lpatch + (0xa5b0 - PATCH_BASE)
mov	x22, x24
mov	x24, x21
mov	x21, x26
mov	x26, x0
LFQH_Lloh364:
adr x0, LFQH_l_.str.394
LFQH_Lloh365:
nop
bl Lpatch + (0xa5a4 - PATCH_BASE)
mov	x1, x0
mov	x0, x26
bl Lpatch + (0xa5d4 - PATCH_BASE)
LFQH_Lloh366:
adr x0, LFQH_l_.str.395
LFQH_Lloh367:
nop
bl Lpatch + (0xa5a4 - PATCH_BASE)
mov	x1, x0
str	x26, [sp, #40]
mov	x0, x26
mov	x26, x21
mov	x21, x24
mov	x24, x22
ldr	w22, [sp, #56]
mov	w2, #1
bl Lpatch + (0xa5d4 - PATCH_BASE)
LFQH_LBB18_113:
tbnz	w25, #0, LFQH_LBB18_115
mov	x0, x19
ldr	w1, [sp, #12]
mov	x2, x22
bl	LFQH_PrepareOwner
LFQH_LBB18_115:
ldr	w8, [sp, #64]
cbz	w8, LFQH_LBB18_117
LFQH_Lloh368:
adr x0, LFQH_l_.str.156
LFQH_Lloh369:
nop
bl Lpatch + (0xa5a4 - PATCH_BASE)
mov	x1, x0
ldr	x0, [sp, #112]
fmov	d0, d14
fmov	d1, d13
fmov	d2, d12
fmov	d3, d15
bl Lpatch + (0xa5d4 - PATCH_BASE)
fmov	d0, d14
fmov	d1, d13
fmov	d2, d12
fmov	d3, d15
bl	LFQH_RectBox
mov	x2, x0
LFQH_Lloh370:
adr x1, LFQH_IconRectKey
LFQH_Lloh371:
nop
mov	x0, x19
mov	w3, #1
bl Lpatch + (0xa634 - PATCH_BASE)
LFQH_LBB18_117:
ldr	x8, [sp, #72]
cmp	x8, x23
b.eq	LFQH_LBB18_122
cbz	w25, LFQH_LBB18_120
LFQH_Lloh372:
adr x0, LFQH_l_.str.426
LFQH_Lloh373:
nop
bl Lpatch + (0xa5a4 - PATCH_BASE)
mov	x1, x0
mov	x0, x23
ldr	x2, [sp, #112]
mov	x3, x19
b	LFQH_LBB18_121
LFQH_LBB18_120:
LFQH_Lloh374:
adr x0, LFQH_l_.str.396
LFQH_Lloh375:
nop
bl Lpatch + (0xa5a4 - PATCH_BASE)
mov	x1, x0
mov	x0, x23
ldr	x2, [sp, #112]
mov	x3, #0
LFQH_LBB18_121:
bl Lpatch + (0xa5d4 - PATCH_BASE)
LFQH_LBB18_122:
cbz	w24, LFQH_LBB18_138
LFQH_Lloh376:
adr x0, LFQH_l_.str.427
LFQH_Lloh377:
nop
bl Lpatch + (0xa5a4 - PATCH_BASE)
mov	x1, x0
ldr	x0, [sp, #112]
ldr	w2, [sp, #16]
bl Lpatch + (0xa5d4 - PATCH_BASE)
cbnz	w21, LFQH_LBB18_139
LFQH_LBB18_124:
cbz	w26, LFQH_LBB18_126
LFQH_LBB18_125:
LFQH_Lloh378:
adr x0, LFQH_l_.str.429
LFQH_Lloh379:
nop
bl Lpatch + (0xa5a4 - PATCH_BASE)
mov	x1, x0
ldr	x0, [sp, #112]
ldr	w2, [sp, #32]
bl Lpatch + (0xa5d4 - PATCH_BASE)
LFQH_LBB18_126:
ldr	w21, [sp, #48]
cmp	w21, #7
b.hs	LFQH_LBB18_144
LFQH_LBB18_127:
LFQH_Lloh380:
adr x1, LFQH_l_.str.36
LFQH_Lloh381:
nop
mov	x0, x19
bl	LFQH_Kind
mov	x23, x19
cbnz	w0, LFQH_LBB18_129
LFQH_Lloh382:
adr x1, LFQH_l_.str.430
LFQH_Lloh383:
nop
mov	x0, x19
bl	LFQH_Get
mov	x23, x0
LFQH_LBB18_129:
LFQH_Lloh384:
adr x1, LFQH_l_.str.36
LFQH_Lloh385:
nop
mov	x0, x23
bl	LFQH_Kind
cmp	w0, #0
csel	x1, xzr, x23, eq
cmp	w20, #7
mov	w8, #13
cinc	w8, w8, ne
ucvtf	d0, w8
mov	x0, x19
bl	LFQH_TrackAppearanceLabel
cmp	w21, #7
b.hs	LFQH_LBB18_145
LFQH_LBB18_130:
mov	x8, #4631389266797133824
fmov	d0, x8
fsub	d1, d0, d10
fmov	d2, #0.50000000
fmul	d1, d1, d2
fsub	d1, d8, d1
fcmp	d10, d0
fcsel	d10, d0, d10, mi
fcsel	d8, d1, d8, mi
fsub	d1, d0, d11
fmul	d1, d1, d2
fsub	d1, d9, d1
fcmp	d11, d0
fcsel	d9, d1, d9, mi
fcsel	d11, d0, d11, mi
LFQH_LBB18_131:
ldr	x21, [sp, #40]
mov	x0, x19
fmov	d0, d8
fmov	d1, d9
fmov	d2, d10
fmov	d3, d11
bl	LFQH_EnsureHit
cbz	x21, LFQH_LBB18_133
LFQH_Lloh386:
adr x0, LFQH_l_.str.397
LFQH_Lloh387:
nop
bl Lpatch + (0xa5a4 - PATCH_BASE)
mov	x1, x0
mov	x0, x21
bl Lpatch + (0xa5d4 - PATCH_BASE)
LFQH_LBB18_133:
cmp	x28, #0
eor	w8, w27, #0x1
csinc	w8, w8, wzr, ne
ldp	d9, d8, [sp, #96]
ldp	d11, d10, [sp, #80]
tbnz	w8, #0, LFQH_LBB18_143
mov	w21, #0
LFQH_Lloh388:
adr x23, LFQH_l_.str.20
LFQH_Lloh389:
nop
mov	x0, x28
LFQH_LBB18_135:
cmp	x0, x19
b.eq	LFQH_LBB18_141
mov	x1, x23
bl	LFQH_Get
cbz	x0, LFQH_LBB18_143
add	w8, w21, #1
cmp	w21, #7
mov	x21, x8
b.lo	LFQH_LBB18_135
b	LFQH_LBB18_143
LFQH_LBB18_138:
cbz	w21, LFQH_LBB18_124
LFQH_LBB18_139:
LFQH_Lloh390:
adr x0, LFQH_l_.str.428
LFQH_Lloh391:
nop
bl Lpatch + (0xa5a4 - PATCH_BASE)
mov	x1, x0
ldr	x0, [sp, #112]
ldr	w2, [sp, #24]
bl Lpatch + (0xa5d4 - PATCH_BASE)
cbnz	w26, LFQH_LBB18_125
b	LFQH_LBB18_126
LFQH_LBB18_140:
mov	x0, x19
mov	x1, #0
b	LFQH_LBB18_14
LFQH_LBB18_141:
LFQH_Lloh392:
adr x0, LFQH_l_.str.24
LFQH_Lloh393:
nop
bl Lpatch + (0xa5a4 - PATCH_BASE)
mov	x1, x0
mov	x0, x28
bl Lpatch + (0xa5d4 - PATCH_BASE)
bl	LFQH_VisibleRect
cbz	w0, LFQH_LBB18_143
LFQH_Lloh394:
adr x0, LFQH_l_.str.24
LFQH_Lloh395:
nop
bl Lpatch + (0xa5a4 - PATCH_BASE)
mov	x1, x0
mov	x0, x28
bl Lpatch + (0xa5d4 - PATCH_BASE)
fmov	d8, d0
fmov	d9, d1
fmov	d10, d2
fmov	d11, d3
LFQH_Lloh396:
adr x0, LFQH_l_.str.507
LFQH_Lloh397:
nop
bl Lpatch + (0xa5a4 - PATCH_BASE)
mov	x1, x0
mov	x0, x28
fmov	d0, d8
fmov	d1, d9
fmov	d2, d10
fmov	d3, d11
mov	x2, x19
bl Lpatch + (0xa5d4 - PATCH_BASE)
fmov	d8, d0
fmov	d9, d1
fmov	d10, d2
fmov	d11, d3
LFQH_LBB18_143:
mov	x0, x20
bl	LFQH_IconRoleName
mov	x2, x0
mov	x0, x19
ldr	x1, [sp, #112]
fmov	d0, d8
fmov	d1, d9
fmov	d2, d10
fmov	d3, d11
bl	LFQH_RecordLayout
b	LFQH_LBB18_15
LFQH_LBB18_144:
cmp	w20, #11
b.eq	LFQH_LBB18_127
b	LFQH_LBB18_131
LFQH_LBB18_145:
cmp	w20, #11
b.eq	LFQH_LBB18_130
b	LFQH_LBB18_131
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
LFQH_Lloh398:
adr x1, LFQH_ReaderGlassKey
LFQH_Lloh399:
nop
bl Lpatch + (0xa628 - PATCH_BASE)
mov	x19, x0
LFQH_Lloh400:
adr x0, LFQH_l_.str.30
LFQH_Lloh401:
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
sub	sp, sp, #224
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
mov	x19, x0
LFQH_Lloh402:
adr x1, LFQH_OwnerBusyKey
LFQH_Lloh403:
nop
bl Lpatch + (0xa628 - PATCH_BASE)
cbnz	x0, LFQH_LBB21_100
LFQH_Lloh404:
adr x1, LFQH_OwnerBusyKey
LFQH_Lloh405:
nop
mov	x0, x19
mov	x2, x19
mov	x3, #0
bl Lpatch + (0xa634 - PATCH_BASE)
LFQH_Lloh406:
adr x0, LFQH_l_.str.24
LFQH_Lloh407:
nop
bl Lpatch + (0xa5a4 - PATCH_BASE)
mov	x1, x0
mov	x0, x19
bl Lpatch + (0xa5d4 - PATCH_BASE)
stp	d0, d1, [sp, #48]
stp	d2, d3, [sp, #64]
LFQH_Lloh408:
adr x1, LFQH_l_.str.31
LFQH_Lloh409:
nop
mov	x0, x19
bl	LFQH_Get
cbz	x0, LFQH_LBB21_6
mov	x21, x0
mov	w20, #0
LFQH_Lloh410:
adr x22, LFQH_l_.str.20
LFQH_Lloh411:
nop
LFQH_LBB21_3:
cmp	x0, x19
b.eq	LFQH_LBB21_7
mov	x1, x22
bl	LFQH_Get
mov	x23, #0
cbz	x0, LFQH_LBB21_8
add	w8, w20, #1
cmp	w20, #7
mov	x20, x8
b.lo	LFQH_LBB21_3
b	LFQH_LBB21_8
LFQH_LBB21_6:
mov	x23, #0
b	LFQH_LBB21_8
LFQH_LBB21_7:
mov	x0, x21
mov	w1, #2
bl	LFQH_Icon
LFQH_Lloh412:
adr x20, LFQH_IconGlassKey
LFQH_Lloh413:
nop
mov	x0, x21
mov	x1, x20
bl Lpatch + (0xa628 - PATCH_BASE)
add	x2, sp, #48
mov	x1, x19
bl	LFQH_IncludeMaterial
mov	x0, x21
mov	x1, x20
bl Lpatch + (0xa628 - PATCH_BASE)
cmp	x0, #0
cset	w23, ne
LFQH_LBB21_8:
LFQH_Lloh414:
adr x1, LFQH_l_.str.32
LFQH_Lloh415:
nop
mov	x0, x19
bl	LFQH_Get
mov	x22, x0
LFQH_Lloh416:
adr x1, LFQH_l_.str.33
LFQH_Lloh417:
nop
bl	LFQH_Kind
str	x23, [sp, #24]
cbz	w0, LFQH_LBB21_22
LFQH_Lloh418:
adr x0, LFQH_l_.str.34
LFQH_Lloh419:
nop
bl Lpatch + (0xa5a4 - PATCH_BASE)
mov	x1, x0
mov	x0, x22
bl Lpatch + (0xa5d4 - PATCH_BASE)
cmp	x0, #16
mov	w8, #16
csel	x21, x0, x8, lo
cbz	x0, LFQH_LBB21_22
mov	x23, #0
str	xzr, [sp, #32]
mov	x24, #0
LFQH_Lloh420:
adr x25, LFQH_l_.str.461
LFQH_Lloh421:
nop
LFQH_Lloh422:
adr x28, LFQH_l_.str.20
LFQH_Lloh423:
nop
LFQH_LBB21_11:
mov	x0, x25
bl Lpatch + (0xa5a4 - PATCH_BASE)
mov	x1, x0
mov	x0, x22
mov	x2, x24
bl Lpatch + (0xa5d4 - PATCH_BASE)
mov	x20, x0
bl	LFQH_InsertRole
cbz	w0, LFQH_LBB21_21
mov	x27, x0
mov	x0, x20
LFQH_Lloh424:
adr x1, LFQH_l_.str.35
LFQH_Lloh425:
nop
bl	LFQH_Get
cbz	x0, LFQH_LBB21_21
mov	x26, x0
mov	w20, #0
LFQH_LBB21_14:
cmp	x0, x19
b.eq	LFQH_LBB21_17
mov	x1, x28
bl	LFQH_Get
cbz	x0, LFQH_LBB21_21
add	w8, w20, #1
cmp	w20, #7
mov	x20, x8
b.lo	LFQH_LBB21_14
b	LFQH_LBB21_21
LFQH_LBB21_17:
mov	x0, x26
mov	x1, x27
bl	LFQH_Icon
mov	x0, x26
LFQH_Lloh426:
adr x1, LFQH_IconGlassKey
LFQH_Lloh427:
nop
bl Lpatch + (0xa628 - PATCH_BASE)
mov	x20, x0
add	x2, sp, #48
mov	x1, x19
bl	LFQH_IncludeMaterial
cmp	x20, #0
ldr	x8, [sp, #24]
cinc	x8, x8, ne
str	x8, [sp, #24]
cbz	x20, LFQH_LBB21_21
cmp	w27, #8
b.eq	LFQH_LBB21_20
cmp	w27, #5
b.ne	LFQH_LBB21_21
LFQH_LBB21_20:
mov	x0, x26
LFQH_Lloh428:
adr x1, LFQH_l_.str.36
LFQH_Lloh429:
nop
bl	LFQH_Kind
cmp	w27, #5
ldr	x10, [sp, #32]
csel	x8, x10, x26, eq
csel	x9, x26, x23, eq
cmp	w0, #0
csel	x10, x10, x8, eq
str	x10, [sp, #32]
csel	x23, x23, x9, eq
LFQH_LBB21_21:
add	x24, x24, #1
cmp	x24, x21
b.ne	LFQH_LBB21_11
b	LFQH_LBB21_23
LFQH_LBB21_22:
str	xzr, [sp, #32]
mov	x23, #0
LFQH_LBB21_23:
LFQH_Lloh430:
adr x1, LFQH_ReaderDownloadLabelKey
LFQH_Lloh431:
nop
mov	x0, x19
mov	x2, x23
bl	LFQH_TrackReaderLabel
LFQH_Lloh432:
adr x1, LFQH_ReaderShelfLabelKey
LFQH_Lloh433:
nop
mov	x0, x19
ldr	x2, [sp, #32]
bl	LFQH_TrackReaderLabel
str	xzr, [sp, #40]
LFQH_Lloh434:
adr x1, LFQH_l_.str.37
LFQH_Lloh435:
nop
mov	x0, x19
bl	LFQH_Kind
cbz	w0, LFQH_LBB21_34
bl	LFQH_Enabled
cbz	w0, LFQH_LBB21_34
LFQH_Lloh436:
adr x0, LFQH_l_.str.28
LFQH_Lloh437:
nop
bl Lpatch + (0xa5b0 - PATCH_BASE)
LFQH_Lloh438:
adr x1, LFQH_l_.str.29
LFQH_Lloh439:
nop
bl	LFQH_Responds
cbz	w0, LFQH_LBB21_34
LFQH_Lloh440:
adr x1, LFQH_l_.str.33
LFQH_Lloh441:
nop
mov	x0, x22
bl	LFQH_Kind
cbz	w0, LFQH_LBB21_70
LFQH_Lloh442:
adr x0, LFQH_l_.str.34
LFQH_Lloh443:
nop
bl Lpatch + (0xa5a4 - PATCH_BASE)
mov	x1, x0
mov	x0, x22
bl Lpatch + (0xa5d4 - PATCH_BASE)
cmp	x0, #16
mov	w8, #16
csel	x20, x0, x8, lo
cbz	x0, LFQH_LBB21_70
mov	x21, #0
mov	x23, #0
LFQH_Lloh444:
adr x24, LFQH_l_.str.461
LFQH_Lloh445:
nop
LFQH_Lloh446:
adr x25, LFQH_l_.str.35
LFQH_Lloh447:
nop
LFQH_LBB21_29:
mov	x0, x24
bl Lpatch + (0xa5a4 - PATCH_BASE)
mov	x1, x0
mov	x0, x22
mov	x2, x23
bl Lpatch + (0xa5d4 - PATCH_BASE)
mov	x27, x0
bl	LFQH_InsertRole
cbnz	w0, LFQH_LBB21_33
mov	x0, x27
mov	x1, x25
bl	LFQH_Get
mov	x28, x0
add	x21, x21, #1
add	x2, sp, #40
mov	x1, x19
bl	LFQH_ReaderShareControl
cbnz	w0, LFQH_LBB21_102
mov	x26, x28
mov	x0, x28
mov	x1, x19
bl	LFQH_ReaderShareCandidate
cbz	w0, LFQH_LBB21_33
mov	x0, x27
bl Lpatch + (0xa664 - PATCH_BASE)
LFQH_Lloh448:
adr x1, LFQH_l_.str.101
LFQH_Lloh449:
nop
bl	LFQH_Get
mov	w1, #1
bl	LFQH_ReaderShareText
cbnz	w0, LFQH_LBB21_103
LFQH_LBB21_33:
add	x23, x23, #1
cmp	x20, x23
b.ne	LFQH_LBB21_29
b	LFQH_LBB21_71
LFQH_LBB21_34:
mov	x20, #0
LFQH_LBB21_35:
LFQH_Lloh450:
adr x1, LFQH_ReaderShareViewKey
LFQH_Lloh451:
nop
mov	x0, x19
mov	x2, #0
bl	LFQH_TrackReaderLabel
mov	x26, #0
mov	x21, x20
LFQH_LBB21_36:
LFQH_Lloh452:
adr x1, LFQH_IconGlassKey
LFQH_Lloh453:
nop
mov	x0, x26
bl Lpatch + (0xa628 - PATCH_BASE)
mov	x20, x0
LFQH_Lloh454:
adr x1, LFQH_ReaderShareHitParentsKey
LFQH_Lloh455:
nop
mov	x0, x19
bl Lpatch + (0xa628 - PATCH_BASE)
str	x0, [sp, #32]
cmp	x26, #0
ccmp	x20, #0, #4, ne
cset	w8, eq
str	w8, [sp, #4]
stp	x21, x26, [sp, #8]
b.ne	LFQH_LBB21_38
mov	x23, #0
b	LFQH_LBB21_45
LFQH_LBB21_38:
LFQH_Lloh456:
adr x0, LFQH_l_.str.116
LFQH_Lloh457:
nop
bl Lpatch + (0xa5b0 - PATCH_BASE)
mov	x20, x0
LFQH_Lloh458:
adr x0, LFQH_l_.str.415
LFQH_Lloh459:
nop
bl Lpatch + (0xa5a4 - PATCH_BASE)
mov	x1, x0
mov	x0, x20
bl Lpatch + (0xa5d4 - PATCH_BASE)
mov	x23, x0
LFQH_Lloh460:
adr x0, LFQH_l_.str.24
LFQH_Lloh461:
nop
bl Lpatch + (0xa5a4 - PATCH_BASE)
mov	x1, x0
mov	x0, x26
bl Lpatch + (0xa5d4 - PATCH_BASE)
fmov	d10, d0
fmov	d9, d1
fmov	d11, d2
fmov	d12, d3
LFQH_Lloh462:
adr x1, LFQH_l_.str.20
LFQH_Lloh463:
nop
mov	x0, x26
bl	LFQH_Get
cbz	x0, LFQH_LBB21_45
mov	x24, x0
mov	w20, #0
mov	x8, #4631389266797133824
fmov	d0, x8
fcmp	d12, d0
fcsel	d8, d0, d12, mi
fsub	d1, d0, d12
fmov	d2, #0.50000000
fmul	d1, d1, d2
fsub	d1, d9, d1
fcsel	d9, d1, d9, mi
fsub	d1, d0, d11
fmul	d1, d1, d2
fsub	d1, d10, d1
fcmp	d11, d0
fcsel	d10, d1, d10, mi
fcsel	d11, d0, d11, mi
LFQH_Lloh464:
adr x25, LFQH_l_.str.20
LFQH_Lloh465:
nop
LFQH_Lloh466:
adr x26, LFQH_l_.str.507
LFQH_Lloh467:
nop
LFQH_Lloh468:
adr x27, LFQH_l_.str.84
LFQH_Lloh469:
nop
LFQH_LBB21_40:
cmp	x24, x19
b.eq	LFQH_LBB21_45
cmp	w20, #5
b.hi	LFQH_LBB21_45
mov	x0, x24
bl	LFQH_CanExpandHit
cbz	w0, LFQH_LBB21_44
mov	x0, x26
bl Lpatch + (0xa5a4 - PATCH_BASE)
mov	x1, x0
ldr	x0, [sp, #16]
fmov	d0, d10
fmov	d1, d9
fmov	d2, d11
fmov	d3, d8
mov	x2, x24
bl Lpatch + (0xa5d4 - PATCH_BASE)
mov	x0, x24
bl	LFQH_EnsureHit
mov	x0, x27
bl Lpatch + (0xa5a4 - PATCH_BASE)
mov	x1, x0
mov	x0, x23
mov	x2, x24
bl Lpatch + (0xa5d4 - PATCH_BASE)
LFQH_LBB21_44:
add	w20, w20, #1
mov	x0, x24
mov	x1, x25
bl	LFQH_Get
mov	x24, x0
cbnz	x0, LFQH_LBB21_40
LFQH_LBB21_45:
LFQH_Lloh470:
adr x20, LFQH_l_.str.34
LFQH_Lloh471:
nop
mov	x0, x20
bl Lpatch + (0xa5a4 - PATCH_BASE)
mov	x1, x0
ldr	x0, [sp, #32]
bl Lpatch + (0xa5d4 - PATCH_BASE)
mov	x24, x0
mov	x0, x20
bl Lpatch + (0xa5a4 - PATCH_BASE)
mov	x1, x0
mov	x0, x23
bl Lpatch + (0xa5d4 - PATCH_BASE)
cmp	x24, x0
cset	w21, eq
cbz	x24, LFQH_LBB21_56
mov	x25, x0
mov	x26, #0
LFQH_Lloh472:
adr x27, LFQH_l_.str.461
LFQH_Lloh473:
nop
LFQH_LBB21_47:
mov	x0, x27
bl Lpatch + (0xa5a4 - PATCH_BASE)
mov	x1, x0
ldr	x0, [sp, #32]
mov	x2, x26
bl Lpatch + (0xa5d4 - PATCH_BASE)
mov	x28, x0
cbz	x25, LFQH_LBB21_51
mov	x20, #0
mov	w22, #0
LFQH_LBB21_49:
mov	x0, x27
bl Lpatch + (0xa5a4 - PATCH_BASE)
mov	x1, x0
mov	x0, x23
mov	x2, x20
bl Lpatch + (0xa5d4 - PATCH_BASE)
cmp	x0, x28
csinc	w22, w22, wzr, ne
add	x20, x20, #1
cmp	x25, x20
b.ne	LFQH_LBB21_49
cbnz	w22, LFQH_LBB21_52
LFQH_LBB21_51:
mov	x0, x28
bl	LFQH_RestoreHit
LFQH_LBB21_52:
tst	w21, #0xff
b.eq	LFQH_LBB21_54
mov	x0, x27
bl Lpatch + (0xa5a4 - PATCH_BASE)
mov	x1, x0
mov	x0, x23
mov	x2, x26
bl Lpatch + (0xa5d4 - PATCH_BASE)
cmp	x0, x28
csel	w21, w21, wzr, eq
b	LFQH_LBB21_55
LFQH_LBB21_54:
mov	w21, #0
LFQH_LBB21_55:
add	x26, x26, #1
cmp	x26, x24
b.ne	LFQH_LBB21_47
LFQH_LBB21_56:
ldr	x8, [sp, #32]
cmp	x8, #0
ldr	w8, [sp, #4]
csel	w8, wzr, w8, eq
and	w9, w21, #0xff
cbz	w9, LFQH_LBB21_58
tbz	w8, #0, LFQH_LBB21_59
LFQH_LBB21_58:
LFQH_Lloh474:
adr x1, LFQH_ReaderShareHitParentsKey
LFQH_Lloh475:
nop
mov	x0, x19
mov	x2, x23
mov	w3, #1
bl Lpatch + (0xa634 - PATCH_BASE)
LFQH_LBB21_59:
bl	LFQH_Enabled
ldr	x23, [sp, #16]
cbz	w0, LFQH_LBB21_91
ldr	x27, [sp, #40]
LFQH_Lloh476:
adr x1, LFQH_IconGlassKey
LFQH_Lloh477:
nop
mov	x0, x23
bl Lpatch + (0xa628 - PATCH_BASE)
cmp	x0, #0
cset	w22, ne
cmp	x23, #0
cset	w8, ne
orr	x8, x8, x22, lsl #1
ldr	x9, [sp, #8]
lsl	x9, x9, #6
add	x9, x9, x27, lsl #2
orr	x21, x8, x9
LFQH_Lloh478:
adr x1, LFQH_ReaderShareResolutionKey
LFQH_Lloh479:
nop
mov	x0, x19
bl Lpatch + (0xa628 - PATCH_BASE)
cbz	x0, LFQH_LBB21_62
mov	x20, x0
LFQH_Lloh480:
adr x0, LFQH_l_.str.30
LFQH_Lloh481:
nop
bl Lpatch + (0xa5a4 - PATCH_BASE)
mov	x1, x0
mov	x0, x20
bl Lpatch + (0xa5d4 - PATCH_BASE)
cmp	x0, x21
b.eq	LFQH_LBB21_91
LFQH_LBB21_62:
cmp	x23, #0
cset	w25, ne
scvtf	d8, x21
LFQH_Lloh482:
adr x23, LFQH_l_.str.497
LFQH_Lloh483:
nop
mov	x0, x23
bl Lpatch + (0xa5b0 - PATCH_BASE)
mov	x20, x0
LFQH_Lloh484:
adr x24, LFQH_l_.str.515
LFQH_Lloh485:
nop
mov	x0, x24
bl Lpatch + (0xa5a4 - PATCH_BASE)
mov	x1, x0
mov	x0, x20
fmov	d0, d8
bl Lpatch + (0xa5d4 - PATCH_BASE)
mov	x2, x0
LFQH_Lloh486:
adr x1, LFQH_ReaderShareResolutionKey
LFQH_Lloh487:
nop
mov	x0, x19
mov	w3, #1
bl Lpatch + (0xa634 - PATCH_BASE)
LFQH_Lloh488:
adr x0, LFQH_l_.str.88
LFQH_Lloh489:
nop
bl Lpatch + (0xa5b0 - PATCH_BASE)
mov	x20, x0
LFQH_Lloh490:
adr x0, LFQH_l_.str.89
LFQH_Lloh491:
nop
bl Lpatch + (0xa5a4 - PATCH_BASE)
mov	x1, x0
mov	x0, x20
bl Lpatch + (0xa5d4 - PATCH_BASE)
mov	x21, x0
mov	x0, x23
bl Lpatch + (0xa5b0 - PATCH_BASE)
mov	x20, x0
LFQH_Lloh492:
adr x26, LFQH_l_.str.499
LFQH_Lloh493:
nop
mov	x0, x26
bl Lpatch + (0xa5a4 - PATCH_BASE)
mov	x1, x0
mov	x0, x20
mov	x2, x25
bl Lpatch + (0xa5d4 - PATCH_BASE)
mov	x2, x0
LFQH_Lloh494:
adr x1, LFQH_l_.str.485
LFQH_Lloh495:
nop
mov	x0, x21
bl	LFQH_Put
mov	x0, x23
bl Lpatch + (0xa5b0 - PATCH_BASE)
mov	x20, x0
mov	x0, x26
bl Lpatch + (0xa5a4 - PATCH_BASE)
mov	x1, x0
mov	x0, x20
mov	x2, x22
bl Lpatch + (0xa5d4 - PATCH_BASE)
mov	x2, x0
LFQH_Lloh496:
adr x1, LFQH_l_.str.486
LFQH_Lloh497:
nop
mov	x0, x21
bl	LFQH_Put
ldr	x8, [sp, #8]
ucvtf	d8, x8
mov	x0, x23
bl Lpatch + (0xa5b0 - PATCH_BASE)
mov	x20, x0
mov	x0, x24
bl Lpatch + (0xa5a4 - PATCH_BASE)
mov	x1, x0
mov	x0, x20
fmov	d0, d8
bl Lpatch + (0xa5d4 - PATCH_BASE)
mov	x2, x0
LFQH_Lloh498:
adr x1, LFQH_l_.str.487
LFQH_Lloh499:
nop
mov	x0, x21
bl	LFQH_Put
LFQH_Lloh500:
adr x0, LFQH_l_.str.361
LFQH_Lloh501:
nop
bl Lpatch + (0xa5b0 - PATCH_BASE)
mov	x20, x0
LFQH_Lloh502:
adr x0, LFQH_l_.str.387
LFQH_Lloh503:
nop
bl Lpatch + (0xa5a4 - PATCH_BASE)
mov	x1, x0
LFQH_Lloh504:
adr x2, LFQH_l_.str.37
LFQH_Lloh505:
nop
mov	x0, x20
bl Lpatch + (0xa5d4 - PATCH_BASE)
mov	x2, x0
LFQH_Lloh506:
adr x1, LFQH_l_.str.488
LFQH_Lloh507:
nop
mov	x0, x21
bl	LFQH_Put
cmp	x27, #2
b.le	LFQH_LBB21_67
cmp	x27, #3
b.eq	LFQH_LBB21_86
cmp	x27, #4
b.eq	LFQH_LBB21_87
cmp	x27, #5
b.ne	LFQH_LBB21_89
LFQH_Lloh508:
adr x22, LFQH_l_.str.494
LFQH_Lloh509:
nop
b	LFQH_LBB21_90
LFQH_LBB21_67:
cmp	x27, #1
b.eq	LFQH_LBB21_88
cmp	x27, #2
b.ne	LFQH_LBB21_89
LFQH_Lloh510:
adr x22, LFQH_l_.str.491
LFQH_Lloh511:
nop
b	LFQH_LBB21_90
LFQH_LBB21_70:
mov	x21, #0
LFQH_LBB21_71:
LFQH_Lloh512:
adr x1, LFQH_l_.str.414
LFQH_Lloh513:
nop
mov	x0, x19
bl	LFQH_Get
mov	x22, x0
LFQH_Lloh514:
adr x0, LFQH_l_.str.34
LFQH_Lloh515:
nop
bl Lpatch + (0xa5a4 - PATCH_BASE)
mov	x1, x0
mov	x0, x22
bl Lpatch + (0xa5d4 - PATCH_BASE)
cbz	x0, LFQH_LBB21_85
mov	x23, x0
mov	x24, #0
LFQH_Lloh516:
adr x25, LFQH_l_.str.461
LFQH_Lloh517:
nop
LFQH_Lloh518:
adr x27, LFQH_l_.str.16
LFQH_Lloh519:
nop
LFQH_LBB21_73:
cmp	x21, #31
b.hi	LFQH_LBB21_85
mov	x0, x25
bl Lpatch + (0xa5a4 - PATCH_BASE)
mov	x1, x0
mov	x0, x22
mov	x2, x24
bl Lpatch + (0xa5d4 - PATCH_BASE)
mov	x26, x0
add	x20, x21, #1
add	x2, sp, #40
mov	x1, x19
bl	LFQH_ReaderShareControl
cbnz	w0, LFQH_LBB21_101
mov	x0, x26
mov	x1, x27
bl	LFQH_Kind
cbnz	w0, LFQH_LBB21_78
mov	x0, x26
LFQH_Lloh520:
adr x1, LFQH_l_.str.42
LFQH_Lloh521:
nop
bl	LFQH_Kind
cbnz	w0, LFQH_LBB21_78
LFQH_Lloh522:
adr x0, LFQH_l_.str.71
LFQH_Lloh523:
nop
bl Lpatch + (0xa5a4 - PATCH_BASE)
mov	x1, x0
mov	x0, x26
bl Lpatch + (0xa5d4 - PATCH_BASE)
cbz	w0, LFQH_LBB21_79
LFQH_LBB21_78:
add	x24, x24, #1
mov	x21, x20
cmp	x24, x23
b.ne	LFQH_LBB21_73
b	LFQH_LBB21_35
LFQH_LBB21_79:
mov	x0, x26
LFQH_Lloh524:
adr x1, LFQH_l_.str.414
LFQH_Lloh525:
nop
bl	LFQH_Get
mov	x26, x0
LFQH_Lloh526:
adr x0, LFQH_l_.str.34
LFQH_Lloh527:
nop
bl Lpatch + (0xa5a4 - PATCH_BASE)
mov	x1, x0
str	x26, [sp, #32]
mov	x0, x26
bl Lpatch + (0xa5d4 - PATCH_BASE)
cbz	x0, LFQH_LBB21_78
mov	x26, #0
add	x8, x0, x21
add	x20, x8, #1
add	x21, x21, #2
str	x23, [sp, #16]
LFQH_LBB21_81:
cmp	x21, #33
b.eq	LFQH_LBB21_84
mov	x23, x22
mov	x22, x0
mov	x28, x25
mov	x0, x25
bl Lpatch + (0xa5a4 - PATCH_BASE)
mov	x1, x0
ldr	x0, [sp, #32]
mov	x2, x26
bl Lpatch + (0xa5d4 - PATCH_BASE)
mov	x25, x0
add	x2, sp, #40
mov	x1, x19
bl	LFQH_ReaderShareControl
cbnz	w0, LFQH_LBB21_104
add	x26, x26, #1
add	x21, x21, #1
mov	x0, x22
cmp	x22, x26
mov	x25, x28
mov	x22, x23
ldr	x23, [sp, #16]
b.ne	LFQH_LBB21_81
b	LFQH_LBB21_78
LFQH_LBB21_84:
mov	w20, #32
b	LFQH_LBB21_78
LFQH_LBB21_85:
mov	x20, x21
b	LFQH_LBB21_35
LFQH_LBB21_86:
LFQH_Lloh528:
adr x22, LFQH_l_.str.492
LFQH_Lloh529:
nop
b	LFQH_LBB21_90
LFQH_LBB21_87:
LFQH_Lloh530:
adr x22, LFQH_l_.str.493
LFQH_Lloh531:
nop
b	LFQH_LBB21_90
LFQH_LBB21_88:
LFQH_Lloh532:
adr x22, LFQH_l_.str.490
LFQH_Lloh533:
nop
b	LFQH_LBB21_90
LFQH_LBB21_89:
LFQH_Lloh534:
adr x22, LFQH_l_.str.489
LFQH_Lloh535:
nop
LFQH_LBB21_90:
LFQH_Lloh536:
adr x0, LFQH_l_.str.361
LFQH_Lloh537:
nop
bl Lpatch + (0xa5b0 - PATCH_BASE)
mov	x20, x0
LFQH_Lloh538:
adr x0, LFQH_l_.str.387
LFQH_Lloh539:
nop
bl Lpatch + (0xa5a4 - PATCH_BASE)
mov	x1, x0
mov	x0, x20
mov	x2, x22
bl Lpatch + (0xa5d4 - PATCH_BASE)
mov	x2, x0
LFQH_Lloh540:
adr x1, LFQH_l_.str.495
LFQH_Lloh541:
nop
mov	x0, x21
bl	LFQH_Put
LFQH_Lloh542:
adr x0, LFQH_l_.str.496
LFQH_Lloh543:
nop
mov	x1, x21
bl Lrecord_named
LFQH_LBB21_91:
ldr	x21, [sp, #24]
cbz	x21, LFQH_LBB21_93
ldp	d0, d1, [sp, #48]
ldp	d2, d3, [sp, #64]
mov	x0, x19
bl	LFQH_EnsureHit
b	LFQH_LBB21_94
LFQH_LBB21_93:
mov	x0, x19
bl	LFQH_RestoreHit
LFQH_LBB21_94:
LFQH_Lloh544:
adr x1, LFQH_ReaderGlassKey
LFQH_Lloh545:
nop
mov	x0, x19
bl Lpatch + (0xa628 - PATCH_BASE)
mov	x20, x0
LFQH_Lloh546:
adr x0, LFQH_l_.str.30
LFQH_Lloh547:
nop
bl Lpatch + (0xa5a4 - PATCH_BASE)
mov	x1, x0
mov	x0, x20
bl Lpatch + (0xa5d4 - PATCH_BASE)
cmp	x0, x21
b.eq	LFQH_LBB21_99
cbz	x21, LFQH_LBB21_97
LFQH_Lloh548:
adr x0, LFQH_l_.str.497
LFQH_Lloh549:
nop
bl Lpatch + (0xa5b0 - PATCH_BASE)
mov	x20, x0
LFQH_Lloh550:
adr x0, LFQH_l_.str.498
LFQH_Lloh551:
nop
bl Lpatch + (0xa5a4 - PATCH_BASE)
mov	x1, x0
mov	x0, x20
mov	x2, x21
bl Lpatch + (0xa5d4 - PATCH_BASE)
mov	x2, x0
b	LFQH_LBB21_98
LFQH_LBB21_97:
mov	x2, #0
LFQH_LBB21_98:
LFQH_Lloh552:
adr x1, LFQH_ReaderGlassKey
LFQH_Lloh553:
nop
mov	x0, x19
mov	w3, #1
bl Lpatch + (0xa634 - PATCH_BASE)
LFQH_LBB21_99:
LFQH_Lloh554:
adr x1, LFQH_OwnerBusyKey
LFQH_Lloh555:
nop
mov	x0, x19
mov	x2, #0
mov	x3, #0
bl Lpatch + (0xa634 - PATCH_BASE)
LFQH_LBB21_100:
ldp	x29, x30, [sp, #208]
ldp	x20, x19, [sp, #192]
ldp	x22, x21, [sp, #176]
ldp	x24, x23, [sp, #160]
ldp	x26, x25, [sp, #144]
ldp	x28, x27, [sp, #128]
ldp	d9, d8, [sp, #112]
ldp	d11, d10, [sp, #96]
ldp	d13, d12, [sp, #80]
add	sp, sp, #224
ret
LFQH_LBB21_101:
mov	x22, x20
b	LFQH_LBB21_105
LFQH_LBB21_102:
mov	x22, x21
mov	x26, x28
b	LFQH_LBB21_105
LFQH_LBB21_103:
mov	x22, x21
mov	w8, #4
str	x8, [sp, #40]
b	LFQH_LBB21_105
LFQH_LBB21_104:
mov	x22, x21
mov	x26, x25
LFQH_LBB21_105:
LFQH_Lloh556:
adr x1, LFQH_ReaderShareViewKey
LFQH_Lloh557:
nop
mov	x0, x19
mov	x2, x26
bl	LFQH_TrackReaderLabel
ldr	x21, [sp, #24]
cbz	x26, LFQH_LBB21_107
mov	x0, x26
mov	w1, #11
bl	LFQH_Icon
LFQH_Lloh558:
adr x1, LFQH_IconGlassKey
LFQH_Lloh559:
nop
mov	x0, x26
bl Lpatch + (0xa628 - PATCH_BASE)
mov	x20, x0
add	x2, sp, #48
mov	x1, x19
bl	LFQH_IncludeMaterial
cmp	x20, #0
cinc	x21, x21, ne
str	x21, [sp, #24]
LFQH_LBB21_107:
mov	x21, x22
b	LFQH_LBB21_36
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
LFQH_Lloh560:
adr x0, LFQH_l_.str.20
LFQH_Lloh561:
nop
bl Lpatch + (0xa5a4 - PATCH_BASE)
mov	x1, x0
mov	x0, x22
bl Lpatch + (0xa5d4 - PATCH_BASE)
cbz	x0, LFQH_LBB23_16
mov	x21, x0
mov	w24, #0
LFQH_Lloh562:
adr x23, LFQH_l_.str.20
LFQH_Lloh563:
nop
LFQH_LBB23_2:
cmp	x0, x20
b.eq	LFQH_LBB23_5
mov	x1, x23
bl	LFQH_Get
cbz	x0, LFQH_LBB23_16
add	w8, w24, #1
cmp	w24, #7
mov	x24, x8
b.lo	LFQH_LBB23_2
b	LFQH_LBB23_16
LFQH_LBB23_5:
LFQH_Lloh564:
adr x0, LFQH_l_.str.372
LFQH_Lloh565:
nop
bl Lpatch + (0xa5a4 - PATCH_BASE)
mov	x1, x0
mov	x0, x22
bl Lpatch + (0xa5d4 - PATCH_BASE)
fmov	d8, d0
fmov	d9, d1
fmov	d10, d2
fmov	d11, d3
LFQH_Lloh566:
adr x0, LFQH_l_.str.507
LFQH_Lloh567:
nop
bl Lpatch + (0xa5a4 - PATCH_BASE)
mov	x1, x0
mov	x0, x21
fmov	d0, d8
fmov	d1, d9
fmov	d2, d10
fmov	d3, d11
mov	x2, x20
bl Lpatch + (0xa5d4 - PATCH_BASE)
fmov	x9, d2
fmov	x8, d1
fmov	x10, d0
and	x10, x10, #0x7fffffffffffffff
and	x8, x8, #0x7fffffffffffffff
mov	x11, #9218868437227405311
cmp	x8, x11
cset	w8, gt
and	x9, x9, #0x7fffffffffffffff
cmp	x9, x11
cset	w9, gt
cmp	x10, x11
b.gt	LFQH_LBB23_16
tbnz	w8, #0, LFQH_LBB23_16
tbnz	w9, #0, LFQH_LBB23_16
fmov	x8, d3
and	x8, x8, #0x7fffffffffffffff
mov	x9, #9218868437227405311
cmp	x8, x9
b.gt	LFQH_LBB23_16
fcmp	d2, #0.0
b.le	LFQH_LBB23_16
fcmp	d3, #0.0
b.le	LFQH_LBB23_16
ldp	d6, d4, [x19]
ldp	d7, d16, [x19, #16]
fcmp	d0, d6
fmov	d5, d6
b.pl	LFQH_LBB23_13
str	d0, [x19]
fmov	d5, d0
LFQH_LBB23_13:
fadd	d7, d6, d7
fadd	d6, d4, d16
fcmp	d1, d4
b.pl	LFQH_LBB23_15
str	d1, [x19, #8]
fmov	d4, d1
LFQH_LBB23_15:
fadd	d0, d0, d2
fcmp	d0, d7
fcsel	d0, d0, d7, gt
fadd	d1, d1, d3
fcmp	d1, d6
fcsel	d1, d1, d6, gt
fsub	d0, d0, d5
fsub	d1, d1, d4
stp	d0, d1, [x19, #16]
LFQH_LBB23_16:
ldp	x29, x30, [sp, #80]
ldp	x20, x19, [sp, #64]
ldp	x22, x21, [sp, #48]
ldp	x24, x23, [sp, #32]
ldp	d9, d8, [sp, #16]
ldp	d11, d10, [sp], #96
ret
.cfi_endproc
.p2align	2
LFQH_InsertRole:
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
LFQH_Lloh568:
adr x1, LFQH_l_.str.462
LFQH_Lloh569:
nop
bl	LFQH_Kind
cbz	w0, LFQH_LBB24_2
mov	w0, #3
b	LFQH_LBB24_9
LFQH_LBB24_2:
LFQH_Lloh570:
adr x1, LFQH_l_.str.463
LFQH_Lloh571:
nop
mov	x0, x19
bl	LFQH_Kind
cbz	w0, LFQH_LBB24_4
mov	w0, #4
b	LFQH_LBB24_9
LFQH_LBB24_4:
LFQH_Lloh572:
adr x1, LFQH_l_.str.464
LFQH_Lloh573:
nop
mov	x0, x19
bl	LFQH_Kind
cbz	w0, LFQH_LBB24_6
mov	w0, #5
b	LFQH_LBB24_9
LFQH_LBB24_6:
LFQH_Lloh574:
adr x1, LFQH_l_.str.465
LFQH_Lloh575:
nop
mov	x0, x19
bl	LFQH_Kind
cbz	w0, LFQH_LBB24_8
mov	w0, #8
b	LFQH_LBB24_9
LFQH_LBB24_8:
LFQH_Lloh576:
adr x1, LFQH_l_.str.466
LFQH_Lloh577:
nop
mov	x0, x19
bl	LFQH_Kind
cmp	w0, #0
mov	w8, #6
csel	w0, wzr, w8, eq
LFQH_LBB24_9:
ldp	x29, x30, [sp, #16]
ldp	x20, x19, [sp], #32
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
b.eq	LFQH_LBB25_4
mov	x22, x0
cbz	x0, LFQH_LBB25_3
LFQH_Lloh578:
adr x1, LFQH_IconGlassKey
LFQH_Lloh579:
nop
mov	x0, x22
bl Lpatch + (0xa628 - PATCH_BASE)
mov	x1, x0
mov	x0, x22
bl	LFQH_RestoreIcon
LFQH_LBB25_3:
mov	x0, x21
mov	x1, x20
mov	x2, x19
mov	w3, #1
ldp	x29, x30, [sp, #32]
ldp	x20, x19, [sp, #16]
ldp	x22, x21, [sp], #48
b Lpatch + (0xa634 - PATCH_BASE)
LFQH_LBB25_4:
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
LFQH_Lloh580:
adr x0, LFQH_l_.str.467
LFQH_Lloh581:
nop
bl Lpatch + (0xa5b0 - PATCH_BASE)
mov	x19, x0
LFQH_Lloh582:
adr x0, LFQH_l_.str.468
LFQH_Lloh583:
nop
bl Lpatch + (0xa5a4 - PATCH_BASE)
mov	x1, x0
mov	x0, x19
bl Lpatch + (0xa5d4 - PATCH_BASE)
mov	x19, x0
LFQH_Lloh584:
adr x1, LFQH_GlassPreferenceKey
LFQH_Lloh585:
nop
bl Lpatch + (0xa628 - PATCH_BASE)
mov	x20, x0
cbnz	x0, LFQH_LBB28_2
LFQH_Lloh586:
adr x0, LFQH_l_.str.361
LFQH_Lloh587:
nop
bl Lpatch + (0xa5b0 - PATCH_BASE)
mov	x20, x0
LFQH_Lloh588:
adr x0, LFQH_l_.str.387
LFQH_Lloh589:
nop
bl Lpatch + (0xa5a4 - PATCH_BASE)
mov	x1, x0
LFQH_Lloh590:
adr x2, LFQH_l_.str.469
LFQH_Lloh591:
nop
mov	x0, x20
bl Lpatch + (0xa5d4 - PATCH_BASE)
mov	x20, x0
LFQH_Lloh592:
adr x1, LFQH_GlassPreferenceKey
LFQH_Lloh593:
nop
mov	x0, x19
mov	x2, x20
mov	w3, #1
bl Lpatch + (0xa634 - PATCH_BASE)
LFQH_LBB28_2:
LFQH_Lloh594:
adr x0, LFQH_l_.str.470
LFQH_Lloh595:
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
LFQH_ReaderShareViewKey:
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
fmov	d9, d3
str	d2, [sp, #24]
fmov	d11, d1
fmov	d10, d0
mov	x19, x0
bl	LFQH_CanExpandHit
cbz	w0, LFQH_LBB30_26
LFQH_Lloh596:
adr x0, LFQH_l_.str.24
LFQH_Lloh597:
nop
bl Lpatch + (0xa5a4 - PATCH_BASE)
mov	x1, x0
mov	x0, x19
bl Lpatch + (0xa5d4 - PATCH_BASE)
fmov	d14, d0
fmov	d13, d1
fmov	d15, d2
fmov	d12, d3
fmov	x20, d15
fmov	x21, d13
fmov	x22, d14
LFQH_Lloh598:
adr x0, LFQH_l_.str.433
LFQH_Lloh599:
nop
bl Lpatch + (0xa5a4 - PATCH_BASE)
mov	x1, x0
mov	x0, x19
bl Lpatch + (0xa5d4 - PATCH_BASE)
and	x10, x22, #0x7fffffffffffffff
and	x8, x21, #0x7fffffffffffffff
mov	x11, #9218868437227405311
cmp	x8, x11
cset	w8, gt
and	x9, x20, #0x7fffffffffffffff
cmp	x9, x11
cset	w9, gt
cmp	x10, x11
b.gt	LFQH_LBB30_26
tbnz	w8, #0, LFQH_LBB30_26
tbnz	w9, #0, LFQH_LBB30_26
fmov	x8, d12
and	x8, x8, #0x7fffffffffffffff
mov	x9, #9218868437227405311
cmp	x8, x9
b.gt	LFQH_LBB30_26
fcmp	d15, #0.0
b.le	LFQH_LBB30_26
fcmp	d12, #0.0
b.le	LFQH_LBB30_26
fmov	d8, d0
fmov	x10, d3
fmov	x9, d2
fmov	x8, d1
fmov	x11, d8
and	x11, x11, #0x7fffffffffffffff
and	x8, x8, #0x7fffffffffffffff
mov	x12, #9218868437227405311
cmp	x8, x12
cset	w8, gt
and	x9, x9, #0x7fffffffffffffff
cmp	x9, x12
cset	w9, gt
and	x10, x10, #0x7fffffffffffffff
cmp	x10, x12
cset	w10, gt
cmp	x11, x12
b.gt	LFQH_LBB30_26
tbnz	w8, #0, LFQH_LBB30_26
tbnz	w9, #0, LFQH_LBB30_26
tbnz	w10, #0, LFQH_LBB30_26
stp	d2, d1, [sp, #8]
str	d3, [sp]
LFQH_Lloh600:
adr x1, LFQH_HitInsetsKey
LFQH_Lloh601:
nop
mov	x0, x19
bl Lpatch + (0xa628 - PATCH_BASE)
mov	x21, x0
LFQH_Lloh602:
adr x1, LFQH_AppliedHitInsetsKey
LFQH_Lloh603:
nop
mov	x0, x19
bl Lpatch + (0xa628 - PATCH_BASE)
mov	x20, x0
cbz	x21, LFQH_LBB30_17
cbz	x20, LFQH_LBB30_17
LFQH_Lloh604:
adr x0, LFQH_l_.str.432
LFQH_Lloh605:
nop
bl Lpatch + (0xa5a4 - PATCH_BASE)
mov	x1, x0
mov	x0, x20
bl Lpatch + (0xa5d4 - PATCH_BASE)
fcmp	d8, d0
b.ne	LFQH_LBB30_17
ldr	d0, [sp, #16]
fcmp	d0, d1
b.ne	LFQH_LBB30_17
ldr	d0, [sp, #8]
fcmp	d0, d2
b.ne	LFQH_LBB30_17
ldr	d0, [sp]
fcmp	d0, d3
b.eq	LFQH_LBB30_18
LFQH_LBB30_17:
LFQH_Lloh606:
adr x0, LFQH_l_.str.512
LFQH_Lloh607:
nop
bl Lpatch + (0xa5b0 - PATCH_BASE)
mov	x21, x0
LFQH_Lloh608:
adr x0, LFQH_l_.str.513
LFQH_Lloh609:
nop
bl Lpatch + (0xa5a4 - PATCH_BASE)
mov	x1, x0
mov	x0, x21
fmov	d0, d8
ldp	d2, d1, [sp, #8]
ldr	d3, [sp]
bl Lpatch + (0xa5d4 - PATCH_BASE)
mov	x21, x0
LFQH_Lloh610:
adr x1, LFQH_HitInsetsKey
LFQH_Lloh611:
nop
mov	x0, x19
mov	x2, x21
mov	w3, #1
bl Lpatch + (0xa634 - PATCH_BASE)
LFQH_LBB30_18:
LFQH_Lloh612:
adr x0, LFQH_l_.str.432
LFQH_Lloh613:
nop
bl Lpatch + (0xa5a4 - PATCH_BASE)
mov	x1, x0
mov	x0, x21
bl Lpatch + (0xa5d4 - PATCH_BASE)
fsub	d4, d11, d13
fsub	d5, d10, d14
fadd	d6, d13, d12
fsub	d6, d6, d11
fsub	d6, d6, d9
fadd	d7, d14, d15
fsub	d7, d7, d10
ldr	d16, [sp, #24]
fsub	d7, d7, d16
fcmp	d4, d0
fcsel	d9, d4, d0, mi
fcmp	d5, d1
fcsel	d10, d5, d1, mi
fcmp	d6, d2
fcsel	d11, d6, d2, mi
fcmp	d7, d3
fcsel	d12, d7, d3, mi
fcmp	d8, d9
b.ne	LFQH_LBB30_21
ldr	d0, [sp, #16]
fcmp	d0, d10
b.ne	LFQH_LBB30_21
ldp	d0, d1, [sp]
fcmp	d1, d11
fccmp	d0, d12, #0, eq
b.eq	LFQH_LBB30_22
LFQH_LBB30_21:
LFQH_Lloh614:
adr x0, LFQH_l_.str.434
LFQH_Lloh615:
nop
bl Lpatch + (0xa5a4 - PATCH_BASE)
mov	x1, x0
mov	x0, x19
fmov	d0, d9
fmov	d1, d10
fmov	d2, d11
fmov	d3, d12
bl Lpatch + (0xa5d4 - PATCH_BASE)
LFQH_LBB30_22:
cbz	x20, LFQH_LBB30_27
LFQH_Lloh616:
adr x0, LFQH_l_.str.432
LFQH_Lloh617:
nop
bl Lpatch + (0xa5a4 - PATCH_BASE)
mov	x1, x0
mov	x0, x20
bl Lpatch + (0xa5d4 - PATCH_BASE)
fcmp	d9, d0
b.ne	LFQH_LBB30_27
fcmp	d10, d1
b.ne	LFQH_LBB30_27
fcmp	d11, d2
fccmp	d12, d3, #0, eq
b.ne	LFQH_LBB30_27
LFQH_LBB30_26:
ldp	x29, x30, [sp, #128]
ldp	x20, x19, [sp, #112]
ldp	x22, x21, [sp, #96]
ldp	d9, d8, [sp, #80]
ldp	d11, d10, [sp, #64]
ldp	d13, d12, [sp, #48]
ldp	d15, d14, [sp, #32]
add	sp, sp, #144
ret
LFQH_LBB30_27:
LFQH_Lloh618:
adr x0, LFQH_l_.str.512
LFQH_Lloh619:
nop
bl Lpatch + (0xa5b0 - PATCH_BASE)
mov	x20, x0
LFQH_Lloh620:
adr x0, LFQH_l_.str.513
LFQH_Lloh621:
nop
bl Lpatch + (0xa5a4 - PATCH_BASE)
mov	x1, x0
mov	x0, x20
fmov	d0, d9
fmov	d1, d10
fmov	d2, d11
fmov	d3, d12
bl Lpatch + (0xa5d4 - PATCH_BASE)
mov	x2, x0
LFQH_Lloh622:
adr x1, LFQH_AppliedHitInsetsKey
LFQH_Lloh623:
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
LFQH_Lloh624:
adr x1, LFQH_HitInsetsKey
LFQH_Lloh625:
nop
bl Lpatch + (0xa628 - PATCH_BASE)
mov	x20, x0
LFQH_Lloh626:
adr x1, LFQH_AppliedHitInsetsKey
LFQH_Lloh627:
nop
mov	x0, x19
bl Lpatch + (0xa628 - PATCH_BASE)
cmp	x20, #0
ccmp	x0, #0, #4, ne
b.eq	LFQH_LBB31_3
mov	x21, x0
LFQH_Lloh628:
adr x0, LFQH_l_.str.433
LFQH_Lloh629:
nop
bl Lpatch + (0xa5a4 - PATCH_BASE)
mov	x1, x0
mov	x0, x19
bl Lpatch + (0xa5d4 - PATCH_BASE)
fmov	d8, d0
fmov	d9, d1
fmov	d10, d2
fmov	d11, d3
LFQH_Lloh630:
adr x0, LFQH_l_.str.432
LFQH_Lloh631:
nop
bl Lpatch + (0xa5a4 - PATCH_BASE)
mov	x1, x0
mov	x0, x21
bl Lpatch + (0xa5d4 - PATCH_BASE)
fcmp	d8, d0
fccmp	d9, d1, #0, eq
fccmp	d10, d2, #0, eq
fccmp	d11, d3, #0, eq
b.ne	LFQH_LBB31_3
LFQH_Lloh632:
adr x0, LFQH_l_.str.432
LFQH_Lloh633:
nop
bl Lpatch + (0xa5a4 - PATCH_BASE)
mov	x1, x0
mov	x0, x20
bl Lpatch + (0xa5d4 - PATCH_BASE)
fmov	d8, d0
fmov	d9, d1
fmov	d10, d2
fmov	d11, d3
LFQH_Lloh634:
adr x0, LFQH_l_.str.434
LFQH_Lloh635:
nop
bl Lpatch + (0xa5a4 - PATCH_BASE)
mov	x1, x0
mov	x0, x19
fmov	d0, d8
fmov	d1, d9
fmov	d2, d10
fmov	d3, d11
bl Lpatch + (0xa5d4 - PATCH_BASE)
LFQH_LBB31_3:
LFQH_Lloh636:
adr x1, LFQH_HitInsetsKey
LFQH_Lloh637:
nop
mov	x0, x19
mov	x2, #0
mov	w3, #1
bl Lpatch + (0xa634 - PATCH_BASE)
LFQH_Lloh638:
adr x1, LFQH_AppliedHitInsetsKey
LFQH_Lloh639:
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
LFQH_Lloh640:
adr x1, LFQH_OwnerBusyKey
LFQH_Lloh641:
nop
bl Lpatch + (0xa628 - PATCH_BASE)
cbz	x0, LFQH_LBB32_2
ldp	x29, x30, [sp, #48]
ldp	x20, x19, [sp, #32]
ldp	x22, x21, [sp, #16]
ldp	x24, x23, [sp], #64
ret
LFQH_LBB32_2:
LFQH_Lloh642:
adr x1, LFQH_OwnerBusyKey
LFQH_Lloh643:
nop
mov	x0, x19
mov	x2, x19
mov	x3, #0
bl Lpatch + (0xa634 - PATCH_BASE)
LFQH_Lloh644:
adr x1, LFQH_l_.str.38
LFQH_Lloh645:
nop
mov	x0, x19
bl	LFQH_Get
mov	x20, x0
LFQH_Lloh646:
adr x1, LFQH_l_.str.39
LFQH_Lloh647:
nop
mov	x0, x19
bl	LFQH_Get
mov	x21, x0
LFQH_Lloh648:
adr x1, LFQH_l_.str.40
LFQH_Lloh649:
nop
mov	x0, x19
bl	LFQH_Get
mov	x22, x0
LFQH_Lloh650:
adr x23, LFQH_ShelfRoleKey
LFQH_Lloh651:
nop
mov	x0, x20
mov	x1, x23
bl Lpatch + (0xa628 - PATCH_BASE)
mov	x24, x0
mov	x0, x21
mov	x1, x23
bl Lpatch + (0xa628 - PATCH_BASE)
mov	x23, x0
cbz	x20, LFQH_LBB32_6
cbz	x24, LFQH_LBB32_5
LFQH_Lloh652:
adr x0, LFQH_l_.str.41
LFQH_Lloh653:
nop
bl Lpatch + (0xa5a4 - PATCH_BASE)
mov	x1, x0
mov	x0, x24
bl Lpatch + (0xa5d4 - PATCH_BASE)
cbnz	w0, LFQH_LBB32_6
LFQH_LBB32_5:
LFQH_Lloh654:
adr x0, LFQH_l_.str.497
LFQH_Lloh655:
nop
bl Lpatch + (0xa5b0 - PATCH_BASE)
mov	x24, x0
LFQH_Lloh656:
adr x0, LFQH_l_.str.499
LFQH_Lloh657:
nop
bl Lpatch + (0xa5a4 - PATCH_BASE)
mov	x1, x0
mov	x0, x24
mov	w2, #1
bl Lpatch + (0xa5d4 - PATCH_BASE)
mov	x2, x0
LFQH_Lloh658:
adr x1, LFQH_ShelfRoleKey
LFQH_Lloh659:
nop
mov	x0, x20
mov	w3, #1
bl Lpatch + (0xa634 - PATCH_BASE)
LFQH_LBB32_6:
cbz	x21, LFQH_LBB32_10
cbz	x23, LFQH_LBB32_9
LFQH_Lloh660:
adr x0, LFQH_l_.str.41
LFQH_Lloh661:
nop
bl Lpatch + (0xa5a4 - PATCH_BASE)
mov	x1, x0
mov	x0, x23
bl Lpatch + (0xa5d4 - PATCH_BASE)
cbz	w0, LFQH_LBB32_10
LFQH_LBB32_9:
LFQH_Lloh662:
adr x0, LFQH_l_.str.497
LFQH_Lloh663:
nop
bl Lpatch + (0xa5b0 - PATCH_BASE)
mov	x23, x0
LFQH_Lloh664:
adr x0, LFQH_l_.str.499
LFQH_Lloh665:
nop
bl Lpatch + (0xa5a4 - PATCH_BASE)
mov	x1, x0
mov	x0, x23
mov	w2, #0
bl Lpatch + (0xa5d4 - PATCH_BASE)
mov	x2, x0
LFQH_Lloh666:
adr x1, LFQH_ShelfRoleKey
LFQH_Lloh667:
nop
mov	x0, x21
mov	w3, #1
bl Lpatch + (0xa634 - PATCH_BASE)
LFQH_LBB32_10:
mov	x0, x20
mov	w1, #9
bl	LFQH_Icon
mov	x0, x21
mov	w1, #10
bl	LFQH_Icon
LFQH_Lloh668:
adr x1, LFQH_l_.str.23
LFQH_Lloh669:
nop
mov	x0, x22
bl	LFQH_Kind
cbz	w0, LFQH_LBB32_12
mov	x0, x19
mov	x1, x22
bl	LFQH_ShelfEditPlacement
mov	x3, x0
mov	x0, x22
mov	x1, x20
mov	x2, x21
bl	LFQH_ShelfTopHit
LFQH_LBB32_12:
LFQH_Lloh670:
adr x1, LFQH_OwnerBusyKey
LFQH_Lloh671:
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
LFQH_Lloh672:
adr x0, LFQH_l_.str.497
LFQH_Lloh673:
nop
bl Lpatch + (0xa5b0 - PATCH_BASE)
mov	x20, x0
LFQH_Lloh674:
adr x0, LFQH_l_.str.499
LFQH_Lloh675:
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
LFQH_Lloh676:
adr x0, LFQH_l_.str.24
LFQH_Lloh677:
nop
bl Lpatch + (0xa5a4 - PATCH_BASE)
mov	x1, x0
mov	x0, x19
bl Lpatch + (0xa5d4 - PATCH_BASE)
stp	d0, d1, [sp]
stp	d2, d3, [sp, #16]
LFQH_Lloh678:
adr x23, LFQH_IconGlassKey
LFQH_Lloh679:
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
cbnz	x20, LFQH_LBB35_4
cbnz	x21, LFQH_LBB35_4
cbnz	x22, LFQH_LBB35_4
mov	x0, x19
ldp	x29, x30, [sp, #80]
ldp	x20, x19, [sp, #64]
ldp	x22, x21, [sp, #48]
ldp	x24, x23, [sp, #32]
add	sp, sp, #96
b	LFQH_RestoreHit
LFQH_LBB35_4:
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
LFQH_Lloh680:
adr x1, LFQH_l_.str.525
LFQH_Lloh681:
nop
bl	LFQH_Get
mov	x27, x0
LFQH_Lloh682:
adr x1, LFQH_l_.str.526
LFQH_Lloh683:
nop
bl	LFQH_Get
mov	x22, x0
LFQH_Lloh684:
adr x1, LFQH_ShelfEditHeaderKey
LFQH_Lloh685:
nop
mov	x0, x23
bl Lpatch + (0xa628 - PATCH_BASE)
mov	x24, x0
LFQH_Lloh686:
adr x0, LFQH_l_.str.361
LFQH_Lloh687:
nop
bl Lpatch + (0xa5b0 - PATCH_BASE)
mov	x20, x0
LFQH_Lloh688:
adr x0, LFQH_l_.str.387
LFQH_Lloh689:
nop
bl Lpatch + (0xa5a4 - PATCH_BASE)
mov	x1, x0
LFQH_Lloh690:
adr x2, LFQH_l_.str.542
LFQH_Lloh691:
nop
mov	x0, x20
bl Lpatch + (0xa5d4 - PATCH_BASE)
bl	LFQH_DefaultEnabled
fmov	d8, xzr
cbz	w0, LFQH_LBB36_41
LFQH_LBB36_1:
mov	x25, #0
mov	x21, #0
LFQH_LBB36_2:
fmov	d9, xzr
fmov	d10, xzr
fmov	d11, xzr
LFQH_LBB36_3:
mov	w28, #0
fmov	x8, d11
fmov	x9, d10
fmov	x10, d9
and	x11, x8, #0x7fffffffffffffff
and	x8, x9, #0x7fffffffffffffff
mov	x12, #9218868437227405311
cmp	x8, x12
cset	w8, gt
and	x9, x10, #0x7fffffffffffffff
cmp	x9, x12
cset	w9, gt
cmp	x11, x12
b.gt	LFQH_LBB36_7
tbnz	w8, #0, LFQH_LBB36_7
tbnz	w9, #0, LFQH_LBB36_7
fmov	x8, d8
and	x8, x8, #0x7fffffffffffffff
fcmp	d9, #0.0
cset	w9, gt
fcmp	d8, #0.0
csel	w9, wzr, w9, le
mov	x10, #9218868437227405312
cmp	x8, x10
csel	w28, wzr, w9, ge
LFQH_LBB36_7:
cmp	x24, x22
csel	w8, wzr, w28, ne
cbz	x24, LFQH_LBB36_12
tbnz	w8, #0, LFQH_LBB36_12
LFQH_Lloh692:
adr x1, LFQH_l_.str.106
LFQH_Lloh693:
nop
mov	x0, x24
bl	LFQH_Get
mov	x20, x0
LFQH_Lloh694:
adr x1, LFQH_l_.str.20
LFQH_Lloh695:
nop
bl	LFQH_Get
cmp	x0, x23
b.ne	LFQH_LBB36_11
LFQH_Lloh696:
adr x1, LFQH_l_.str.529
LFQH_Lloh697:
nop
mov	x0, x24
bl	LFQH_Get
mov	x26, x0
LFQH_Lloh698:
adr x0, LFQH_l_.str.167
LFQH_Lloh699:
nop
bl Lpatch + (0xa5a4 - PATCH_BASE)
mov	x1, x0
mov	x0, x26
mov	x2, x20
bl Lpatch + (0xa5d4 - PATCH_BASE)
LFQH_Lloh700:
adr x0, LFQH_l_.str.286
LFQH_Lloh701:
nop
bl Lpatch + (0xa5a4 - PATCH_BASE)
mov	x1, x0
mov	x0, x24
bl Lpatch + (0xa5d4 - PATCH_BASE)
LFQH_LBB36_11:
LFQH_Lloh702:
adr x1, LFQH_ShelfEditHeaderKey
LFQH_Lloh703:
nop
mov	x0, x23
mov	x2, #0
mov	w3, #1
bl Lpatch + (0xa634 - PATCH_BASE)
LFQH_LBB36_12:
cbz	w28, LFQH_LBB36_37
LFQH_Lloh704:
adr x1, LFQH_l_.str.20
LFQH_Lloh705:
nop
mov	x0, x21
bl	LFQH_Get
cmp	x0, x23
b.eq	LFQH_LBB36_15
LFQH_Lloh706:
adr x0, LFQH_l_.str.167
LFQH_Lloh707:
nop
bl Lpatch + (0xa5a4 - PATCH_BASE)
mov	x1, x0
mov	x0, x23
mov	x2, x21
bl Lpatch + (0xa5d4 - PATCH_BASE)
LFQH_LBB36_15:
LFQH_Lloh708:
adr x0, LFQH_l_.str.372
LFQH_Lloh709:
nop
bl Lpatch + (0xa5a4 - PATCH_BASE)
mov	x1, x0
mov	x0, x21
bl Lpatch + (0xa5d4 - PATCH_BASE)
fcmp	d0, d11
b.ne	LFQH_LBB36_19
fcmp	d1, d10
b.ne	LFQH_LBB36_19
fcmp	d2, d9
b.ne	LFQH_LBB36_19
fcmp	d3, d8
b.eq	LFQH_LBB36_20
LFQH_LBB36_19:
LFQH_Lloh710:
adr x0, LFQH_l_.str.156
LFQH_Lloh711:
nop
bl Lpatch + (0xa5a4 - PATCH_BASE)
mov	x1, x0
mov	x0, x21
fmov	d0, d11
fmov	d1, d10
fmov	d2, d9
fmov	d3, d8
bl Lpatch + (0xa5d4 - PATCH_BASE)
LFQH_LBB36_20:
mov	x0, x21
mov	w1, #0
bl	LFQH_ShelfActionGlass
cmp	x24, x22
b.eq	LFQH_LBB36_22
LFQH_Lloh712:
adr x1, LFQH_ShelfEditHeaderKey
LFQH_Lloh713:
nop
mov	x0, x23
mov	x2, x22
mov	w3, #1
bl Lpatch + (0xa634 - PATCH_BASE)
LFQH_LBB36_22:
mov	x0, x27
bl Lpatch + (0xa664 - PATCH_BASE)
mov	x20, x0
LFQH_Lloh714:
adr x0, LFQH_l_.str.530
LFQH_Lloh715:
nop
bl Lpatch + (0xa5a4 - PATCH_BASE)
mov	x1, x0
mov	x0, x20
bl Lpatch + (0xa5f8 - PATCH_BASE)
cbz	x0, LFQH_LBB36_37
LFQH_Lloh716:
adr x0, LFQH_l_.str.71
LFQH_Lloh717:
nop
bl Lpatch + (0xa5a4 - PATCH_BASE)
mov	x1, x0
mov	x0, x25
bl Lpatch + (0xa5d4 - PATCH_BASE)
mov	x20, x27
cbnz	w0, LFQH_LBB36_38
LFQH_Lloh718:
adr x1, LFQH_l_.str.531
LFQH_Lloh719:
nop
mov	x0, x22
bl	LFQH_Get
mov	x23, x0
LFQH_Lloh720:
adr x1, LFQH_l_.str.532
LFQH_Lloh721:
nop
mov	x0, x22
bl	LFQH_Get
mov	x22, x0
LFQH_Lloh722:
adr x1, LFQH_l_.str.414
LFQH_Lloh723:
nop
mov	x0, x25
bl	LFQH_Get
mov	x24, x0
LFQH_Lloh724:
adr x0, LFQH_l_.str.34
LFQH_Lloh725:
nop
bl Lpatch + (0xa5a4 - PATCH_BASE)
mov	x1, x0
mov	x0, x24
bl Lpatch + (0xa5d4 - PATCH_BASE)
mov	x20, x27
cbz	x0, LFQH_LBB36_38
mov	x25, x0
str	x27, [sp, #8]
mov	x26, #0
LFQH_Lloh726:
adr x27, LFQH_l_.str.461
LFQH_Lloh727:
nop
LFQH_LBB36_26:
mov	x0, x27
bl Lpatch + (0xa5a4 - PATCH_BASE)
mov	x1, x0
mov	x0, x24
mov	x2, x26
bl Lpatch + (0xa5d4 - PATCH_BASE)
cmp	x0, x23
ccmp	x0, x22, #4, ne
b.eq	LFQH_LBB36_35
mov	x20, x0
LFQH_Lloh728:
adr x0, LFQH_l_.str.71
LFQH_Lloh729:
nop
bl Lpatch + (0xa5a4 - PATCH_BASE)
mov	x1, x0
mov	x0, x20
bl Lpatch + (0xa5d4 - PATCH_BASE)
cbnz	w0, LFQH_LBB36_35
LFQH_Lloh730:
adr x0, LFQH_l_.str.477
LFQH_Lloh731:
nop
bl Lpatch + (0xa5a4 - PATCH_BASE)
mov	x1, x0
mov	x0, x20
bl Lpatch + (0xa5d4 - PATCH_BASE)
fcmp	d0, #0.0
b.le	LFQH_LBB36_35
LFQH_Lloh732:
adr x0, LFQH_l_.str.372
LFQH_Lloh733:
nop
bl Lpatch + (0xa5a4 - PATCH_BASE)
mov	x1, x0
mov	x0, x20
bl Lpatch + (0xa5d4 - PATCH_BASE)
fmov	x9, d2
fmov	x8, d1
fmov	x10, d0
and	x10, x10, #0x7fffffffffffffff
and	x8, x8, #0x7fffffffffffffff
mov	x12, #9218868437227405311
cmp	x8, x12
cset	w8, gt
and	x9, x9, #0x7fffffffffffffff
cmp	x9, x12
cset	w9, gt
mov	x11, #9218868437227405311
cmp	x10, x12
b.gt	LFQH_LBB36_35
tbnz	w8, #0, LFQH_LBB36_35
tbnz	w9, #0, LFQH_LBB36_35
fmov	x8, d3
and	x8, x8, #0x7fffffffffffffff
cmp	x8, x11
b.gt	LFQH_LBB36_35
fcmp	d2, #0.0
b.le	LFQH_LBB36_35
fcmp	d3, #0.0
b.gt	LFQH_LBB36_54
LFQH_LBB36_35:
add	x26, x26, #1
cmp	x25, x26
b.ne	LFQH_LBB36_26
ldr	x27, [sp, #8]
mov	x20, x27
b	LFQH_LBB36_38
LFQH_LBB36_37:
mov	x20, #0
LFQH_LBB36_38:
LFQH_Lloh734:
adr x1, LFQH_ShelfCompactKey
LFQH_Lloh735:
nop
mov	x0, x19
bl Lpatch + (0xa628 - PATCH_BASE)
cmp	x0, x20
b.eq	LFQH_LBB36_40
LFQH_Lloh736:
adr x1, LFQH_ShelfCompactKey
LFQH_Lloh737:
nop
mov	x0, x19
mov	x2, x20
mov	w3, #1
bl Lpatch + (0xa634 - PATCH_BASE)
LFQH_Lloh738:
adr x0, LFQH_l_.str.356
LFQH_Lloh739:
nop
bl Lpatch + (0xa5a4 - PATCH_BASE)
mov	x1, x0
mov	x0, x27
bl Lpatch + (0xa5d4 - PATCH_BASE)
LFQH_Lloh740:
adr x1, LFQH_l_.str.533
LFQH_Lloh741:
nop
mov	x0, x19
bl	LFQH_Get
LFQH_Lloh742:
adr x1, LFQH_l_.str.534
LFQH_Lloh743:
nop
bl	LFQH_Get
mov	x19, x0
LFQH_Lloh744:
adr x0, LFQH_l_.str.535
LFQH_Lloh745:
nop
bl Lpatch + (0xa5a4 - PATCH_BASE)
mov	x1, x0
mov	x0, x19
bl Lpatch + (0xa5d4 - PATCH_BASE)
LFQH_LBB36_40:
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
LFQH_LBB36_41:
LFQH_Lloh746:
adr x1, LFQH_l_.str.21
LFQH_Lloh747:
nop
mov	x0, x22
bl	LFQH_Kind
cbz	w0, LFQH_LBB36_1
mov	x0, x22
bl Lpatch + (0xa664 - PATCH_BASE)
LFQH_Lloh748:
adr x1, LFQH_l_.str.527
LFQH_Lloh749:
nop
LFQH_Lloh750:
adr x2, LFQH_l_.str.149
LFQH_Lloh751:
nop
bl	LFQH_ClassABI
cbz	w0, LFQH_LBB36_1
LFQH_Lloh752:
adr x0, LFQH_l_.str.527
LFQH_Lloh753:
nop
bl Lpatch + (0xa5a4 - PATCH_BASE)
mov	x1, x0
mov	x0, x22
bl Lpatch + (0xa5d4 - PATCH_BASE)
cbnz	w0, LFQH_LBB36_1
mov	x0, x22
bl Lpatch + (0xa664 - PATCH_BASE)
LFQH_Lloh754:
adr x1, LFQH_l_.str.528
LFQH_Lloh755:
nop
LFQH_Lloh756:
adr x2, LFQH_l_.str.149
LFQH_Lloh757:
nop
bl	LFQH_ClassABI
cbz	w0, LFQH_LBB36_1
LFQH_Lloh758:
adr x0, LFQH_l_.str.528
LFQH_Lloh759:
nop
bl Lpatch + (0xa5a4 - PATCH_BASE)
mov	x1, x0
mov	x0, x22
bl Lpatch + (0xa5d4 - PATCH_BASE)
cbnz	w0, LFQH_LBB36_1
mov	x0, x22
bl Lpatch + (0xa664 - PATCH_BASE)
LFQH_Lloh760:
adr x1, LFQH_l_.str.286
LFQH_Lloh761:
nop
LFQH_Lloh762:
adr x2, LFQH_l_.str.9
LFQH_Lloh763:
nop
bl	LFQH_ClassABI
cbz	w0, LFQH_LBB36_1
LFQH_Lloh764:
adr x0, LFQH_l_.str.71
LFQH_Lloh765:
nop
bl Lpatch + (0xa5a4 - PATCH_BASE)
mov	x1, x0
mov	x0, x22
bl Lpatch + (0xa5d4 - PATCH_BASE)
cbnz	w0, LFQH_LBB36_1
LFQH_Lloh766:
adr x1, LFQH_l_.str.106
LFQH_Lloh767:
nop
mov	x0, x22
bl	LFQH_Get
mov	x21, x0
LFQH_Lloh768:
adr x1, LFQH_l_.str.529
LFQH_Lloh769:
nop
mov	x0, x22
bl	LFQH_Get
mov	x25, x0
LFQH_Lloh770:
adr x1, LFQH_l_.str.20
LFQH_Lloh771:
nop
mov	x0, x21
bl	LFQH_Get
cbz	x25, LFQH_LBB36_2
cmp	x0, x25
b.eq	LFQH_LBB36_51
cmp	x0, x23
b.ne	LFQH_LBB36_2
LFQH_LBB36_51:
LFQH_Lloh772:
adr x1, LFQH_l_.str.138
LFQH_Lloh773:
nop
mov	x0, x21
bl	LFQH_Kind
cbz	w0, LFQH_LBB36_2
LFQH_Lloh774:
adr x0, LFQH_l_.str.71
LFQH_Lloh775:
nop
bl Lpatch + (0xa5a4 - PATCH_BASE)
mov	x1, x0
mov	x0, x21
bl Lpatch + (0xa5d4 - PATCH_BASE)
cbnz	w0, LFQH_LBB36_2
mov	x0, x21
bl	LFQH_ShelfEditPadding
mov	x0, x19
mov	x1, x23
mov	x2, x21
bl	LFQH_ShelfEditFrame
fmov	d11, d0
fmov	d10, d1
fmov	d9, d2
fmov	d8, d3
b	LFQH_LBB36_3
LFQH_LBB36_54:
mov	x20, #0
ldr	x27, [sp, #8]
b	LFQH_LBB36_38
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
LFQH_Lloh776:
adr x1, LFQH_l_.str.42
LFQH_Lloh777:
nop
bl	LFQH_Kind
cbz	w0, LFQH_LBB37_2
LFQH_Lloh778:
adr x1, LFQH_l_.str.20
LFQH_Lloh779:
nop
mov	x0, x19
bl	LFQH_Get
LFQH_Lloh780:
adr x1, LFQH_l_.str.43
LFQH_Lloh781:
nop
bl	LFQH_Kind
cmp	w0, #0
cset	w0, ne
LFQH_LBB37_2:
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
LFQH_Lloh782:
adr x0, LFQH_l_.str.24
LFQH_Lloh783:
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
b.le	LFQH_LBB38_2
fmov	d4, #6.00000000
fadd	d0, d0, d4
fmov	d4, #-12.00000000
fadd	d2, d2, d4
fmov	d4, #4.00000000
fadd	d1, d1, d4
fmov	d4, #-8.00000000
fadd	d3, d3, d4
LFQH_LBB38_2:
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
LFQH_Lloh784:
adr x1, LFQH_l_.str.44
LFQH_Lloh785:
nop
bl	LFQH_Kind
cbz	w0, LFQH_LBB39_12
mov	x0, x19
mov	w1, #2
bl	LFQH_ListenCaption
mov	x21, x0
LFQH_Lloh786:
adr x1, LFQH_ListenLabelKey
LFQH_Lloh787:
nop
mov	x0, x19
bl Lpatch + (0xa628 - PATCH_BASE)
mov	x22, x0
bl	LFQH_Enabled
cbz	w0, LFQH_LBB39_13
cbz	x21, LFQH_LBB39_13
bl	LFQH_FQHGlassAvailable
cbz	w0, LFQH_LBB39_13
mov	x0, x19
bl	LFQH_FQHApply
LFQH_Lloh788:
adr x1, LFQH_SurfaceKey
LFQH_Lloh789:
nop
mov	x0, x19
bl Lpatch + (0xa628 - PATCH_BASE)
cbz	x0, LFQH_LBB39_12
mov	x20, x0
cmp	x22, x21
b.eq	LFQH_LBB39_9
cbz	x22, LFQH_LBB39_8
LFQH_Lloh790:
adr x0, LFQH_l_.str.45
LFQH_Lloh791:
nop
bl Lpatch + (0xa5a4 - PATCH_BASE)
mov	x23, x0
LFQH_Lloh792:
adr x1, LFQH_ListenColorKey
LFQH_Lloh793:
nop
mov	x0, x19
bl Lpatch + (0xa628 - PATCH_BASE)
mov	x2, x0
mov	x0, x22
mov	x1, x23
bl Lpatch + (0xa5d4 - PATCH_BASE)
LFQH_LBB39_8:
LFQH_Lloh794:
adr x1, LFQH_ListenLabelKey
LFQH_Lloh795:
nop
mov	x0, x19
mov	x2, x21
mov	w3, #1
bl Lpatch + (0xa634 - PATCH_BASE)
LFQH_Lloh796:
adr x1, LFQH_l_.str.46
LFQH_Lloh797:
nop
mov	x0, x21
bl	LFQH_Get
mov	x2, x0
LFQH_Lloh798:
adr x1, LFQH_ListenColorKey
LFQH_Lloh799:
nop
mov	x0, x19
mov	w3, #1
bl Lpatch + (0xa634 - PATCH_BASE)
LFQH_LBB39_9:
LFQH_Lloh800:
adr x0, LFQH_l_.str.47
LFQH_Lloh801:
nop
bl Lpatch + (0xa5b0 - PATCH_BASE)
mov	x22, x0
LFQH_Lloh802:
adr x0, LFQH_l_.str.48
LFQH_Lloh803:
nop
bl Lpatch + (0xa5a4 - PATCH_BASE)
mov	x1, x0
mov	x0, x22
bl Lpatch + (0xa5d4 - PATCH_BASE)
mov	x22, x0
LFQH_Lloh804:
adr x1, LFQH_l_.str.46
LFQH_Lloh805:
nop
mov	x0, x21
bl	LFQH_Get
mov	x23, x0
LFQH_Lloh806:
adr x0, LFQH_l_.str.49
LFQH_Lloh807:
nop
bl Lpatch + (0xa5a4 - PATCH_BASE)
mov	x1, x0
mov	x0, x23
mov	x2, x22
bl Lpatch + (0xa5d4 - PATCH_BASE)
cbnz	w0, LFQH_LBB39_11
LFQH_Lloh808:
adr x0, LFQH_l_.str.45
LFQH_Lloh809:
nop
bl Lpatch + (0xa5a4 - PATCH_BASE)
mov	x1, x0
mov	x0, x21
mov	x2, x22
bl Lpatch + (0xa5d4 - PATCH_BASE)
LFQH_LBB39_11:
LFQH_Lloh810:
adr x1, LFQH_ListenTintKey
LFQH_Lloh811:
nop
mov	x0, x19
bl Lpatch + (0xa628 - PATCH_BASE)
cbz	x0, LFQH_LBB39_16
LFQH_LBB39_12:
ldp	x29, x30, [sp, #48]
ldp	x20, x19, [sp, #32]
ldp	x22, x21, [sp, #16]
ldp	x24, x23, [sp], #64
ret
LFQH_LBB39_13:
cbz	x22, LFQH_LBB39_15
LFQH_Lloh812:
adr x0, LFQH_l_.str.45
LFQH_Lloh813:
nop
bl Lpatch + (0xa5a4 - PATCH_BASE)
mov	x20, x0
LFQH_Lloh814:
adr x1, LFQH_ListenColorKey
LFQH_Lloh815:
nop
mov	x0, x19
bl Lpatch + (0xa628 - PATCH_BASE)
mov	x2, x0
mov	x0, x22
mov	x1, x20
bl Lpatch + (0xa5d4 - PATCH_BASE)
LFQH_LBB39_15:
LFQH_Lloh816:
adr x1, LFQH_ListenLabelKey
LFQH_Lloh817:
nop
mov	x0, x19
mov	x2, #0
mov	w3, #1
bl Lpatch + (0xa634 - PATCH_BASE)
LFQH_Lloh818:
adr x1, LFQH_ListenColorKey
LFQH_Lloh819:
nop
mov	x0, x19
mov	x2, #0
mov	w3, #1
bl Lpatch + (0xa634 - PATCH_BASE)
LFQH_Lloh820:
adr x1, LFQH_ListenTintKey
LFQH_Lloh821:
nop
mov	x0, x19
mov	x2, #0
mov	w3, #1
bl Lpatch + (0xa634 - PATCH_BASE)
LFQH_Lloh822:
adr x1, LFQH_SurfaceKey
LFQH_Lloh823:
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
LFQH_LBB39_16:
LFQH_Lloh824:
adr x0, LFQH_l_.str.47
LFQH_Lloh825:
nop
bl Lpatch + (0xa5b0 - PATCH_BASE)
mov	x21, x0
LFQH_Lloh826:
adr x0, LFQH_l_.str.50
LFQH_Lloh827:
nop
bl Lpatch + (0xa5a4 - PATCH_BASE)
mov	x1, x0
mov	x0, x21
bl Lpatch + (0xa5d4 - PATCH_BASE)
mov	x21, x0
LFQH_Lloh828:
adr x0, LFQH_l_.str.51
LFQH_Lloh829:
nop
bl Lpatch + (0xa5a4 - PATCH_BASE)
mov	x1, x0
fmov	d0, #0.50000000
mov	x0, x21
bl Lpatch + (0xa5d4 - PATCH_BASE)
mov	x21, x0
LFQH_Lloh830:
adr x1, LFQH_l_.str.52
LFQH_Lloh831:
nop
mov	x0, x20
bl	LFQH_Get
mov	x22, x0
LFQH_Lloh832:
adr x0, LFQH_l_.str.53
LFQH_Lloh833:
nop
bl Lpatch + (0xa5a4 - PATCH_BASE)
mov	x1, x0
mov	x0, x22
bl Lpatch + (0xa5d4 - PATCH_BASE)
mov	x22, x0
LFQH_Lloh834:
adr x0, LFQH_l_.str.54
LFQH_Lloh835:
nop
bl Lpatch + (0xa5a4 - PATCH_BASE)
mov	x1, x0
mov	x0, x22
mov	x2, x21
bl Lpatch + (0xa5d4 - PATCH_BASE)
LFQH_Lloh836:
adr x0, LFQH_l_.str.55
LFQH_Lloh837:
nop
bl Lpatch + (0xa5a4 - PATCH_BASE)
mov	x1, x0
mov	x0, x20
mov	x2, x22
bl Lpatch + (0xa5d4 - PATCH_BASE)
LFQH_Lloh838:
adr x0, LFQH_l_.str.56
LFQH_Lloh839:
nop
bl Lpatch + (0xa5a4 - PATCH_BASE)
mov	x1, x0
mov	x0, x22
bl Lpatch + (0xa5d4 - PATCH_BASE)
LFQH_Lloh840:
adr x1, LFQH_ListenTintKey
LFQH_Lloh841:
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
LFQH_Lloh842:
adr x1, LFQH_l_.str.36
LFQH_Lloh843:
nop
bl	LFQH_Kind
cbz	w0, LFQH_LBB40_2
LFQH_Lloh844:
adr x1, LFQH_l_.str.500
LFQH_Lloh845:
nop
mov	x0, x20
bl	LFQH_Get
LFQH_Lloh846:
adr x1, LFQH_l_.str.501
LFQH_Lloh847:
nop
bl	LFQH_Equal
cbnz	w0, LFQH_LBB40_5
LFQH_LBB40_2:
cbz	w19, LFQH_LBB40_4
LFQH_Lloh848:
adr x1, LFQH_l_.str.16
LFQH_Lloh849:
nop
mov	x0, x20
bl	LFQH_Kind
cbz	w0, LFQH_LBB40_6
LFQH_LBB40_4:
mov	x20, #0
LFQH_LBB40_5:
mov	x0, x20
ldp	x29, x30, [sp, #48]
ldp	x20, x19, [sp, #32]
ldp	x22, x21, [sp, #16]
ldp	x24, x23, [sp], #64
ret
LFQH_LBB40_6:
LFQH_Lloh850:
adr x1, LFQH_l_.str.414
LFQH_Lloh851:
nop
mov	x0, x20
bl	LFQH_Get
mov	x21, x0
LFQH_Lloh852:
adr x0, LFQH_l_.str.34
LFQH_Lloh853:
nop
bl Lpatch + (0xa5a4 - PATCH_BASE)
mov	x1, x0
mov	x0, x21
bl Lpatch + (0xa5d4 - PATCH_BASE)
cmp	x0, #12
mov	w8, #12
csel	x24, x0, x8, lo
cbz	x0, LFQH_LBB40_4
mov	x22, #0
sub	w19, w19, #1
LFQH_Lloh854:
adr x23, LFQH_l_.str.461
LFQH_Lloh855:
nop
LFQH_LBB40_8:
mov	x0, x23
bl Lpatch + (0xa5a4 - PATCH_BASE)
mov	x1, x0
mov	x0, x21
mov	x2, x22
bl Lpatch + (0xa5d4 - PATCH_BASE)
mov	x1, x19
bl	LFQH_ListenCaption
cbnz	x0, LFQH_LBB40_10
add	x22, x22, #1
cmp	x24, x22
b.ne	LFQH_LBB40_8
b	LFQH_LBB40_4
LFQH_LBB40_10:
mov	x20, x0
b	LFQH_LBB40_5
.cfi_endproc
.p2align	2
LFQH_ListenLabelKey:
.cfi_startproc
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
cbz	x1, LFQH_LBB44_7
mov	x20, x1
LFQH_Lloh856:
adr x1, LFQH_ClipsKey
LFQH_Lloh857:
nop
mov	x0, x19
bl Lpatch + (0xa628 - PATCH_BASE)
cbnz	x0, LFQH_LBB44_3
LFQH_Lloh858:
adr x1, LFQH_HeaderClipsKey
LFQH_Lloh859:
nop
mov	x0, x19
bl Lpatch + (0xa628 - PATCH_BASE)
cbz	x0, LFQH_LBB44_6
LFQH_LBB44_3:
LFQH_Lloh860:
adr x0, LFQH_l_.str.47
LFQH_Lloh861:
nop
bl Lpatch + (0xa5b0 - PATCH_BASE)
mov	x21, x0
LFQH_Lloh862:
adr x0, LFQH_l_.str.158
LFQH_Lloh863:
nop
bl Lpatch + (0xa5a4 - PATCH_BASE)
mov	x1, x0
mov	x0, x21
bl Lpatch + (0xa5d4 - PATCH_BASE)
mov	x21, x0
LFQH_Lloh864:
adr x0, LFQH_l_.str.390
LFQH_Lloh865:
nop
bl Lpatch + (0xa5a4 - PATCH_BASE)
mov	x1, x0
mov	x0, x19
bl Lpatch + (0xa5d4 - PATCH_BASE)
cmp	x0, x21
b.eq	LFQH_LBB44_5
mov	x22, x0
LFQH_Lloh866:
adr x0, LFQH_l_.str.49
LFQH_Lloh867:
nop
bl Lpatch + (0xa5a4 - PATCH_BASE)
mov	x1, x0
mov	x0, x22
mov	x2, x21
bl Lpatch + (0xa5d4 - PATCH_BASE)
cbz	w0, LFQH_LBB44_6
LFQH_LBB44_5:
LFQH_Lloh868:
adr x0, LFQH_l_.str.157
LFQH_Lloh869:
nop
bl Lpatch + (0xa5a4 - PATCH_BASE)
mov	x21, x0
LFQH_Lloh870:
adr x1, LFQH_BackgroundKey
LFQH_Lloh871:
nop
mov	x0, x19
bl Lpatch + (0xa628 - PATCH_BASE)
mov	x2, x0
mov	x0, x19
mov	x1, x21
bl Lpatch + (0xa5d4 - PATCH_BASE)
LFQH_LBB44_6:
LFQH_Lloh872:
adr x0, LFQH_l_.str.431
LFQH_Lloh873:
nop
bl Lpatch + (0xa5a4 - PATCH_BASE)
mov	x1, x0
mov	x0, x20
bl Lpatch + (0xa5d4 - PATCH_BASE)
LFQH_Lloh874:
adr x1, LFQH_SurfaceKey
LFQH_Lloh875:
nop
mov	x0, x19
mov	x2, #0
mov	w3, #1
bl Lpatch + (0xa634 - PATCH_BASE)
LFQH_Lloh876:
adr x1, LFQH_BackgroundKey
LFQH_Lloh877:
nop
mov	x0, x19
mov	x2, #0
mov	w3, #1
bl Lpatch + (0xa634 - PATCH_BASE)
LFQH_LBB44_7:
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
cbz	x0, LFQH_LBB45_11
mov	x19, x0
mov	w25, #0
LFQH_Lloh878:
adr x20, LFQH_l_.str.389
LFQH_Lloh879:
nop
LFQH_Lloh880:
adr x21, LFQH_l_.str.57
LFQH_Lloh881:
nop
LFQH_Lloh882:
adr x22, LFQH_l_.str.59
LFQH_Lloh883:
nop
LFQH_Lloh884:
adr x23, LFQH_l_.str.20
LFQH_Lloh885:
nop
LFQH_LBB45_2:
mov	x0, x20
bl Lpatch + (0xa5a4 - PATCH_BASE)
mov	x24, x0
mov	x0, x21
bl Lpatch + (0xa5b0 - PATCH_BASE)
mov	x2, x0
mov	x0, x19
mov	x1, x24
bl Lpatch + (0xa5d4 - PATCH_BASE)
cbnz	w0, LFQH_LBB45_6
mov	x0, x20
bl Lpatch + (0xa5a4 - PATCH_BASE)
mov	x24, x0
mov	x0, x22
bl Lpatch + (0xa5b0 - PATCH_BASE)
mov	x2, x0
mov	x0, x19
mov	x1, x24
bl Lpatch + (0xa5d4 - PATCH_BASE)
cbnz	w0, LFQH_LBB45_9
mov	x0, x19
mov	x1, x23
bl	LFQH_Get
mov	x19, x0
mov	w0, #0
cbz	x19, LFQH_LBB45_11
add	w8, w25, #1
cmp	w25, #3
mov	x25, x8
b.lo	LFQH_LBB45_2
b	LFQH_LBB45_11
LFQH_LBB45_6:
LFQH_Lloh886:
adr x1, LFQH_l_.str.20
LFQH_Lloh887:
nop
mov	x0, x19
bl	LFQH_Get
LFQH_Lloh888:
adr x1, LFQH_l_.str.58
LFQH_Lloh889:
nop
bl	LFQH_Kind
cbz	w0, LFQH_LBB45_11
mov	x0, x19
bl	LFQH_ReaderBottomType
sub	w8, w0, #4
cmn	w8, #3
b.hs	LFQH_LBB45_10
mov	w0, #0
b	LFQH_LBB45_11
LFQH_LBB45_9:
ldp	x29, x30, [sp, #64]
ldp	x20, x19, [sp, #48]
ldp	x22, x21, [sp, #32]
ldp	x24, x23, [sp, #16]
ldp	x26, x25, [sp], #80
b	LFQH_FQHGlassAvailable
LFQH_LBB45_10:
bl	LFQH_FQHGlassAvailable
cmp	w0, #0
cset	w0, ne
LFQH_LBB45_11:
ldp	x29, x30, [sp, #64]
ldp	x20, x19, [sp, #48]
ldp	x22, x21, [sp, #32]
ldp	x24, x23, [sp, #16]
ldp	x26, x25, [sp], #80
ret
.cfi_endproc
.p2align	2
LFQH_FQHDramaGlyph:
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
mov	x0, x1
bl Lpatch + (0xa5a4 - PATCH_BASE)
mov	x21, x0
LFQH_Lloh890:
adr x0, LFQH_l_.str.60
LFQH_Lloh891:
nop
bl Lpatch + (0xa5a4 - PATCH_BASE)
cmp	x21, x0
b.eq	LFQH_LBB46_5
LFQH_LBB46_1:
LFQH_Lloh892:
adr x0, LFQH_l_.str.62
LFQH_Lloh893:
nop
bl Lpatch + (0xa5a4 - PATCH_BASE)
cmp	x21, x0
b.eq	LFQH_LBB46_6
LFQH_LBB46_2:
LFQH_Lloh894:
adr x0, LFQH_l_.str.65
LFQH_Lloh895:
nop
bl Lpatch + (0xa5a4 - PATCH_BASE)
cmp	x21, x0
b.eq	LFQH_LBB46_8
LFQH_LBB46_3:
LFQH_Lloh896:
adr x0, LFQH_l_.str.67
LFQH_Lloh897:
nop
bl Lpatch + (0xa5a4 - PATCH_BASE)
cmp	x21, x0
b.eq	LFQH_LBB46_9
mov	w0, #0
b	LFQH_LBB46_26
LFQH_LBB46_5:
LFQH_Lloh898:
adr x1, LFQH_l_.str.61
LFQH_Lloh899:
nop
mov	x0, x19
bl	LFQH_Kind
cbnz	w0, LFQH_LBB46_10
b	LFQH_LBB46_1
LFQH_LBB46_6:
LFQH_Lloh900:
adr x1, LFQH_l_.str.63
LFQH_Lloh901:
nop
mov	x0, x19
bl	LFQH_Kind
cbnz	w0, LFQH_LBB46_10
LFQH_Lloh902:
adr x1, LFQH_l_.str.64
LFQH_Lloh903:
nop
mov	x0, x19
bl	LFQH_Kind
cbnz	w0, LFQH_LBB46_10
b	LFQH_LBB46_2
LFQH_LBB46_8:
LFQH_Lloh904:
adr x1, LFQH_l_.str.66
LFQH_Lloh905:
nop
mov	x0, x19
bl	LFQH_Kind
cbnz	w0, LFQH_LBB46_10
b	LFQH_LBB46_3
LFQH_LBB46_9:
LFQH_Lloh906:
adr x1, LFQH_l_.str.68
LFQH_Lloh907:
nop
mov	x0, x19
bl	LFQH_Kind
cbz	w0, LFQH_LBB46_26
LFQH_LBB46_10:
bl	LFQH_FQHGlassAvailable
cbz	w0, LFQH_LBB46_26
LFQH_Lloh908:
adr x0, LFQH_l_.str.28
LFQH_Lloh909:
nop
bl Lpatch + (0xa5b0 - PATCH_BASE)
LFQH_Lloh910:
adr x1, LFQH_l_.str.69
LFQH_Lloh911:
nop
bl	LFQH_Responds
cbz	w0, LFQH_LBB46_26
bl	LFQH_Enabled
cbz	w0, LFQH_LBB46_24
mov	x0, x19
mov	x1, x20
bl	LFQH_Get
mov	x20, x0
LFQH_Lloh912:
adr x1, LFQH_l_.str.70
LFQH_Lloh913:
nop
bl	LFQH_Kind
cbz	w0, LFQH_LBB46_24
LFQH_Lloh914:
adr x0, LFQH_l_.str.20
LFQH_Lloh915:
nop
bl Lpatch + (0xa5a4 - PATCH_BASE)
mov	x1, x0
mov	x0, x20
bl Lpatch + (0xa5d4 - PATCH_BASE)
cbz	x0, LFQH_LBB46_24
mov	x21, x0
LFQH_Lloh916:
adr x0, LFQH_l_.str.372
LFQH_Lloh917:
nop
bl Lpatch + (0xa5a4 - PATCH_BASE)
mov	x1, x0
mov	x0, x20
bl Lpatch + (0xa5d4 - PATCH_BASE)
fmov	x9, d2
fmov	x8, d1
fmov	x10, d0
and	x10, x10, #0x7fffffffffffffff
and	x8, x8, #0x7fffffffffffffff
mov	x11, #9218868437227405311
cmp	x8, x11
cset	w8, gt
and	x9, x9, #0x7fffffffffffffff
cmp	x9, x11
cset	w9, gt
cmp	x10, x11
b.gt	LFQH_LBB46_24
tbnz	w8, #0, LFQH_LBB46_24
tbnz	w9, #0, LFQH_LBB46_24
fmov	x8, d3
and	x8, x8, #0x7fffffffffffffff
mov	x9, #9218868437227405311
cmp	x8, x9
b.gt	LFQH_LBB46_24
fcmp	d2, #0.0
b.le	LFQH_LBB46_24
fcmp	d3, #0.0
b.le	LFQH_LBB46_24
fcmp	d2, d3
fcsel	d4, d2, d3, gt
fmov	d5, #4.00000000
fadd	d4, d4, d5
fsub	d2, d2, d4
fmov	d5, #0.50000000
fmul	d2, d2, d5
fadd	d0, d0, d2
fsub	d2, d3, d4
fmul	d2, d2, d5
fadd	d1, d1, d2
mov	x0, x19
mov	x1, x21
mov	x2, x20
fmov	d2, d4
fmov	d3, d4
bl	LFQH_PlaceDramaGlass
cbz	x0, LFQH_LBB46_26
mov	x19, x0
LFQH_Lloh918:
adr x21, LFQH_l_.str.71
LFQH_Lloh919:
nop
mov	x0, x21
bl Lpatch + (0xa5a4 - PATCH_BASE)
mov	x1, x0
mov	x0, x20
bl Lpatch + (0xa5d4 - PATCH_BASE)
mov	x20, x0
mov	x0, x21
bl Lpatch + (0xa5a4 - PATCH_BASE)
mov	x1, x0
mov	x0, x19
bl Lpatch + (0xa5d4 - PATCH_BASE)
cmp	w20, w0
b.eq	LFQH_LBB46_25
LFQH_Lloh920:
adr x0, LFQH_l_.str.72
LFQH_Lloh921:
nop
bl Lpatch + (0xa5a4 - PATCH_BASE)
mov	x1, x0
mov	x0, x19
mov	x2, x20
bl Lpatch + (0xa5d4 - PATCH_BASE)
b	LFQH_LBB46_25
LFQH_LBB46_24:
mov	x0, x19
bl	LFQH_RemoveDramaGlass
LFQH_LBB46_25:
mov	w0, #1
LFQH_LBB46_26:
ldp	x29, x30, [sp, #32]
ldp	x20, x19, [sp, #16]
ldp	x22, x21, [sp], #48
ret
.cfi_endproc
.p2align	2
LFQH_RemoveDramaGlass:
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
LFQH_Lloh922:
adr x1, LFQH_DramaGlassKey
LFQH_Lloh923:
nop
bl Lpatch + (0xa628 - PATCH_BASE)
cbz	x0, LFQH_LBB47_2
mov	x20, x0
LFQH_Lloh924:
adr x0, LFQH_l_.str.431
LFQH_Lloh925:
nop
bl Lpatch + (0xa5a4 - PATCH_BASE)
mov	x1, x0
mov	x0, x20
bl Lpatch + (0xa5d4 - PATCH_BASE)
LFQH_Lloh926:
adr x1, LFQH_DramaGlassKey
LFQH_Lloh927:
nop
mov	x0, x19
mov	x2, #0
mov	w3, #1
ldp	x29, x30, [sp, #16]
ldp	x20, x19, [sp], #32
b Lpatch + (0xa634 - PATCH_BASE)
LFQH_LBB47_2:
ldp	x29, x30, [sp, #16]
ldp	x20, x19, [sp], #32
ret
.cfi_endproc
.p2align	2
LFQH_VisibleRect:
.cfi_startproc
mov	w0, #0
fmov	x8, d2
fmov	x9, d1
fmov	x10, d0
and	x10, x10, #0x7fffffffffffffff
and	x9, x9, #0x7fffffffffffffff
mov	x11, #9218868437227405311
cmp	x9, x11
cset	w9, gt
and	x8, x8, #0x7fffffffffffffff
cmp	x8, x11
cset	w8, gt
cmp	x10, x11
b.gt	LFQH_LBB48_3
tbnz	w9, #0, LFQH_LBB48_3
fmov	x9, d3
and	x9, x9, #0x7fffffffffffffff
fcmp	d2, #0.0
cset	w10, gt
fcmp	d3, #0.0
csel	w10, wzr, w10, le
mov	x11, #9218868437227405312
cmp	x9, x11
csel	w9, wzr, w10, ge
tst	w8, #0x1
csel	w0, wzr, w9, ne
LFQH_LBB48_3:
ret
.cfi_endproc
.p2align	2
LFQH_PlaceDramaGlass:
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
fmov	d8, d3
fmov	d9, d2
fmov	d10, d1
fmov	d11, d0
mov	x20, x2
mov	x19, x1
mov	x22, x0
LFQH_Lloh928:
adr x1, LFQH_DramaGlassKey
LFQH_Lloh929:
nop
bl Lpatch + (0xa628 - PATCH_BASE)
mov	x21, x0
cbz	x0, LFQH_LBB49_11
LFQH_LBB49_1:
LFQH_Lloh930:
adr x0, LFQH_l_.str.372
LFQH_Lloh931:
nop
bl Lpatch + (0xa5a4 - PATCH_BASE)
mov	x1, x0
mov	x0, x21
bl Lpatch + (0xa5d4 - PATCH_BASE)
fcmp	d0, d11
fccmp	d1, d10, #0, eq
fccmp	d2, d9, #0, eq
b.eq	LFQH_LBB49_3
mov	w24, #1
b	LFQH_LBB49_4
LFQH_LBB49_3:
fcmp	d3, d8
cset	w24, ne
LFQH_LBB49_4:
LFQH_Lloh932:
adr x0, LFQH_l_.str.20
LFQH_Lloh933:
nop
bl Lpatch + (0xa5a4 - PATCH_BASE)
mov	x1, x0
mov	x0, x21
bl Lpatch + (0xa5d4 - PATCH_BASE)
mov	x23, x0
tbnz	w24, #0, LFQH_LBB49_6
cmp	x23, x19
b.eq	LFQH_LBB49_18
LFQH_LBB49_6:
LFQH_Lloh934:
adr x0, LFQH_l_.str.393
LFQH_Lloh935:
nop
bl Lpatch + (0xa5b0 - PATCH_BASE)
mov	x22, x0
LFQH_Lloh936:
adr x0, LFQH_l_.str.394
LFQH_Lloh937:
nop
bl Lpatch + (0xa5a4 - PATCH_BASE)
mov	x1, x0
mov	x0, x22
bl Lpatch + (0xa5d4 - PATCH_BASE)
LFQH_Lloh938:
adr x0, LFQH_l_.str.395
LFQH_Lloh939:
nop
bl Lpatch + (0xa5a4 - PATCH_BASE)
mov	x1, x0
mov	x0, x22
mov	w2, #1
bl Lpatch + (0xa5d4 - PATCH_BASE)
cbz	w24, LFQH_LBB49_8
LFQH_Lloh940:
adr x0, LFQH_l_.str.156
LFQH_Lloh941:
nop
bl Lpatch + (0xa5a4 - PATCH_BASE)
mov	x1, x0
mov	x0, x21
fmov	d0, d11
fmov	d1, d10
fmov	d2, d9
fmov	d3, d8
bl Lpatch + (0xa5d4 - PATCH_BASE)
LFQH_LBB49_8:
cmp	x23, x19
b.eq	LFQH_LBB49_17
cbz	x20, LFQH_LBB49_15
LFQH_Lloh942:
adr x0, LFQH_l_.str.426
LFQH_Lloh943:
nop
bl Lpatch + (0xa5a4 - PATCH_BASE)
mov	x1, x0
mov	x0, x19
mov	x2, x21
mov	x3, x20
b	LFQH_LBB49_16
LFQH_LBB49_11:
LFQH_Lloh944:
adr x0, LFQH_l_.str.28
LFQH_Lloh945:
nop
bl Lpatch + (0xa5b0 - PATCH_BASE)
LFQH_Lloh946:
adr x1, LFQH_l_.str.69
LFQH_Lloh947:
nop
bl	LFQH_Get
cbz	x0, LFQH_LBB49_14
mov	x23, x0
LFQH_Lloh948:
adr x0, LFQH_l_.str.138
LFQH_Lloh949:
nop
bl Lpatch + (0xa5b0 - PATCH_BASE)
mov	x21, x0
LFQH_Lloh950:
adr x0, LFQH_l_.str.154
LFQH_Lloh951:
nop
bl Lpatch + (0xa5a4 - PATCH_BASE)
mov	x1, x0
mov	x0, x21
bl Lpatch + (0xa5d4 - PATCH_BASE)
mov	x21, x0
LFQH_Lloh952:
adr x0, LFQH_l_.str.506
LFQH_Lloh953:
nop
bl Lpatch + (0xa5a4 - PATCH_BASE)
mov	x1, x0
mov	x0, x21
fmov	d0, d11
fmov	d1, d10
fmov	d2, d9
fmov	d3, d8
bl Lpatch + (0xa5d4 - PATCH_BASE)
mov	x21, x0
cbz	x0, LFQH_LBB49_18
LFQH_Lloh954:
adr x0, LFQH_l_.str.422
LFQH_Lloh955:
nop
bl Lpatch + (0xa5a4 - PATCH_BASE)
mov	x1, x0
mov	x0, x21
mov	x2, x23
bl Lpatch + (0xa5d4 - PATCH_BASE)
LFQH_Lloh956:
adr x0, LFQH_l_.str.17
LFQH_Lloh957:
nop
bl Lpatch + (0xa5a4 - PATCH_BASE)
mov	x23, x0
LFQH_Lloh958:
adr x0, LFQH_l_.str.14
LFQH_Lloh959:
nop
bl Lpatch + (0xa5b0 - PATCH_BASE)
mov	x24, x0
LFQH_Lloh960:
adr x0, LFQH_l_.str.15
LFQH_Lloh961:
nop
bl Lpatch + (0xa5a4 - PATCH_BASE)
mov	x1, x0
mov	x0, x24
bl Lpatch + (0xa5d4 - PATCH_BASE)
mov	x2, x0
mov	x0, x21
mov	x1, x23
bl Lpatch + (0xa5d4 - PATCH_BASE)
LFQH_Lloh962:
adr x0, LFQH_l_.str.399
LFQH_Lloh963:
nop
bl Lpatch + (0xa5a4 - PATCH_BASE)
mov	x1, x0
mov	x0, x21
mov	w2, #0
bl Lpatch + (0xa5d4 - PATCH_BASE)
LFQH_Lloh964:
adr x0, LFQH_l_.str.400
LFQH_Lloh965:
nop
bl Lpatch + (0xa5a4 - PATCH_BASE)
mov	x1, x0
mov	x0, x21
mov	w2, #1
bl Lpatch + (0xa5d4 - PATCH_BASE)
LFQH_Lloh966:
adr x0, LFQH_l_.str.401
LFQH_Lloh967:
nop
bl Lpatch + (0xa5a4 - PATCH_BASE)
mov	x1, x0
mov	x0, x21
mov	w2, #0
bl Lpatch + (0xa5d4 - PATCH_BASE)
LFQH_Lloh968:
adr x1, LFQH_DramaGlassKey
LFQH_Lloh969:
nop
mov	x0, x22
mov	x2, x21
mov	w3, #1
bl Lpatch + (0xa634 - PATCH_BASE)
LFQH_Lloh970:
adr x0, LFQH_l_.str.56
LFQH_Lloh971:
nop
bl Lpatch + (0xa5a4 - PATCH_BASE)
mov	x1, x0
mov	x0, x21
bl Lpatch + (0xa5d4 - PATCH_BASE)
b	LFQH_LBB49_1
LFQH_LBB49_14:
mov	x21, #0
b	LFQH_LBB49_18
LFQH_LBB49_15:
LFQH_Lloh972:
adr x0, LFQH_l_.str.396
LFQH_Lloh973:
nop
bl Lpatch + (0xa5a4 - PATCH_BASE)
mov	x1, x0
mov	x0, x19
mov	x2, x21
mov	x3, #0
LFQH_LBB49_16:
bl Lpatch + (0xa5d4 - PATCH_BASE)
LFQH_LBB49_17:
LFQH_Lloh974:
adr x0, LFQH_l_.str.397
LFQH_Lloh975:
nop
bl Lpatch + (0xa5a4 - PATCH_BASE)
mov	x1, x0
mov	x0, x22
bl Lpatch + (0xa5d4 - PATCH_BASE)
LFQH_LBB49_18:
mov	x0, x21
ldp	x29, x30, [sp, #80]
ldp	x20, x19, [sp, #64]
ldp	x22, x21, [sp, #48]
ldp	x24, x23, [sp, #32]
ldp	d9, d8, [sp, #16]
ldp	d11, d10, [sp], #96
ret
.cfi_endproc
.p2align	2
LFQH_FQHDramaSpacing178R2:
.cfi_startproc
sub	sp, sp, #416
stp	d15, d14, [sp, #256]
stp	d13, d12, [sp, #272]
stp	d11, d10, [sp, #288]
stp	d9, d8, [sp, #304]
stp	x28, x27, [sp, #320]
stp	x26, x25, [sp, #336]
stp	x24, x23, [sp, #352]
stp	x22, x21, [sp, #368]
stp	x20, x19, [sp, #384]
stp	x29, x30, [sp, #400]
add	x29, sp, #400
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
LFQH_Lloh976:
adr x1, LFQH_l_.str.73
LFQH_Lloh977:
nop
bl	LFQH_Kind
cbz	w0, LFQH_LBB50_98
LFQH_Lloh978:
adr x1, LFQH_DramaSpacingBusy178R2Key
LFQH_Lloh979:
nop
mov	x0, x19
bl Lpatch + (0xa628 - PATCH_BASE)
cbnz	x0, LFQH_LBB50_98
LFQH_Lloh980:
adr x1, LFQH_DramaSpacingBusy178R2Key
LFQH_Lloh981:
nop
mov	x0, x19
mov	x2, x19
mov	x3, #0
bl Lpatch + (0xa634 - PATCH_BASE)
LFQH_Lloh982:
adr x1, LFQH_l_.str.74
LFQH_Lloh983:
nop
mov	x0, x19
bl	LFQH_Get
mov	x28, x0
stp	xzr, xzr, [x29, #-168]
LFQH_Lloh984:
adr x0, LFQH_l_.str.24
LFQH_Lloh985:
nop
bl Lpatch + (0xa5a4 - PATCH_BASE)
mov	x1, x0
mov	x0, x19
bl Lpatch + (0xa5d4 - PATCH_BASE)
fmov	d12, d0
fmov	d14, d1
fmov	d10, d2
fmov	d15, d3
cbz	x28, LFQH_LBB50_4
LFQH_Lloh986:
adr x0, LFQH_l_.str.24
LFQH_Lloh987:
nop
bl Lpatch + (0xa5a4 - PATCH_BASE)
mov	x1, x0
mov	x0, x28
bl Lpatch + (0xa5d4 - PATCH_BASE)
fmov	d8, d0
fmov	d9, d1
fmov	d13, d2
fmov	d11, d3
b	LFQH_LBB50_5
LFQH_LBB50_4:
fmov	d11, xzr
fmov	d13, xzr
fmov	d9, xzr
fmov	d8, xzr
LFQH_LBB50_5:
movi.16b	v0, #0
stp	q0, q0, [sp, #192]
bl	LFQH_Enabled
mov	x21, #0
mov	w20, #0
LFQH_Lloh988:
adr x24, LFQH_l_.str.75
LFQH_Lloh989:
nop
cbz	x28, LFQH_LBB50_50
cbz	w0, LFQH_LBB50_50
mov	x0, x19
bl	LFQH_DramaSpacingVisible178R2
mov	x21, #0
mov	w20, #0
cbz	w0, LFQH_LBB50_50
fcmp	d11, d13
b.le	LFQH_LBB50_50
fcmp	d15, d10
b.le	LFQH_LBB50_50
fmov	d0, #-4.00000000
fadd	d0, d13, d0
fcmp	d10, d0
b.lt	LFQH_LBB50_50
LFQH_Lloh990:
adr x0, LFQH_l_.str.507
LFQH_Lloh991:
nop
bl Lpatch + (0xa5a4 - PATCH_BASE)
mov	x1, x0
mov	x0, x19
fmov	d0, d12
fmov	d1, d14
fmov	d2, d10
fmov	d3, d15
mov	x2, x28
bl Lpatch + (0xa5d4 - PATCH_BASE)
mov	x21, #0
mov	w20, #0
fmov	x8, d2
fmov	x9, d1
fmov	x10, d0
and	x10, x10, #0x7fffffffffffffff
and	x9, x9, #0x7fffffffffffffff
mov	x11, #9218868437227405311
cmp	x9, x11
cset	w9, gt
and	x8, x8, #0x7fffffffffffffff
cmp	x8, x11
cset	w8, gt
cmp	x10, x11
b.gt	LFQH_LBB50_50
tbnz	w9, #0, LFQH_LBB50_50
tbnz	w8, #0, LFQH_LBB50_50
mov	x21, #0
mov	w20, #0
fmov	x8, d3
and	x8, x8, #0x7fffffffffffffff
mov	x9, #9218868437227405311
cmp	x8, x9
b.gt	LFQH_LBB50_50
fcmp	d2, #0.0
b.le	LFQH_LBB50_50
fcmp	d3, #0.0
b.le	LFQH_LBB50_50
fadd	d4, d11, d9
fcmp	d1, d4
b.pl	LFQH_LBB50_50
fadd	d1, d1, d3
fcmp	d1, d9
b.le	LFQH_LBB50_50
fabd	d0, d0, d8
fmov	d1, #2.00000000
fcmp	d0, d1
b.pl	LFQH_LBB50_49
fabd	d1, d2, d10
fmov	d0, #0.50000000
fcmp	d1, d0
b.pl	LFQH_LBB50_49
fabd	d1, d3, d15
fcmp	d1, d0
b.pl	LFQH_LBB50_49
str	xzr, [sp, #184]
mov	w8, #128
str	w8, [sp, #180]
add	x8, sp, #192
str	x8, [sp]
add	x3, sp, #180
sub	x5, x29, #160
add	x6, sp, #184
sub	x7, x29, #168
mov	x0, x19
mov	x1, x19
mov	w2, #8
mov	w4, #0
bl	LFQH_DramaSpacingScan178R2
ldr	w8, [sp, #180]
cmp	w8, #1
b.lt	LFQH_LBB50_115
mov	x21, #0
ldur	x20, [x29, #-168]
cmp	x20, #0
cset	w8, ne
ldr	d0, [sp, #216]
fmov	d1, #8.00000000
fcmp	d0, d1
LFQH_Lloh992:
adr x9, LFQH_l_.str.79
LFQH_Lloh993:
nop
LFQH_Lloh994:
adr x10, LFQH_l_.str.80
LFQH_Lloh995:
nop
cset	w11, ls
ands	w8, w8, w11
csel	x9, x10, x9, ne
cmp	x20, #0
LFQH_Lloh996:
adr x10, LFQH_l_.str.78
LFQH_Lloh997:
nop
ldr	x11, [sp, #184]
csel	x9, x9, x10, ne
LFQH_Lloh998:
adr x10, LFQH_l_.str.77
LFQH_Lloh999:
nop
cmp	x11, #1
csel	x24, x9, x10, eq
b.ne	LFQH_LBB50_116
tbz	w8, #0, LFQH_LBB50_116
ldur	x21, [x29, #-160]
mov	x0, x21
mov	x1, x19
bl	LFQH_DramaSpacingMeasure178R2
fmov	d8, d1
fmov	d11, d2
fmov	d9, d3
LFQH_Lloh1000:
adr x1, LFQH_l_.str.20
LFQH_Lloh1001:
nop
mov	x0, x21
bl	LFQH_Get
cbz	x0, LFQH_LBB50_116
cmp	x0, x19
b.eq	LFQH_LBB50_116
LFQH_Lloh1002:
adr x8, LFQH_lCPI50_0
LFQH_Lloh1003:
ldr d0, [x8]
and x8, x8, #0xfffffffffffff000
fmul	d1, d15, d0
fmov	d0, #0.75000000
fmul	d0, d11, d0
stp	d0, d1, [sp, #160]
LFQH_Lloh1004:
adr x8, LFQH_lCPI50_1
LFQH_Lloh1005:
ldr d0, [x8]
and x8, x8, #0xfffffffffffff000
fmov	d13, d15
fmul	d0, d15, d0
fadd	d0, d14, d0
str	d0, [sp, #152]
fadd	d0, d8, d9
fmov	d1, #16.00000000
fadd	d15, d0, d1
LFQH_Lloh1006:
adr x22, LFQH_l_.str.20
LFQH_Lloh1007:
nop
mov	x25, #9218868437227405311
mov	x26, #9218868437227405312
LFQH_LBB50_28:
mov	x23, x0
mov	x1, x19
bl	LFQH_DramaSpacingMeasure178R2
fmov	d12, d0
fmov	d8, d1
fmov	d11, d2
fmov	d9, d3
mov	w27, #0
mov	x0, x23
LFQH_LBB50_29:
cmp	x0, x19
b.eq	LFQH_LBB50_32
mov	x1, x22
bl	LFQH_Get
cbz	x0, LFQH_LBB50_48
add	w8, w27, #1
cmp	w27, #7
mov	x27, x8
b.lo	LFQH_LBB50_29
b	LFQH_LBB50_48
LFQH_LBB50_32:
mov	w27, #0
mov	x0, x20
LFQH_LBB50_33:
cmp	x0, x23
b.eq	LFQH_LBB50_48
mov	x1, x22
bl	LFQH_Get
cbz	x0, LFQH_LBB50_36
add	w8, w27, #1
cmp	w27, #7
mov	x27, x8
b.lo	LFQH_LBB50_33
LFQH_LBB50_36:
mov	w8, #0
fmov	x9, d12
and	x11, x9, #0x7fffffffffffffff
fmov	x9, d8
and	x9, x9, #0x7fffffffffffffff
cmp	x9, x25
cset	w9, gt
fmov	x10, d11
and	x10, x10, #0x7fffffffffffffff
cmp	x10, x25
cset	w10, gt
cmp	x11, x25
b.gt	LFQH_LBB50_40
tbnz	w9, #0, LFQH_LBB50_40
tbnz	w10, #0, LFQH_LBB50_40
fmov	x8, d9
and	x8, x8, #0x7fffffffffffffff
fcmp	d11, #0.0
cset	w9, gt
fcmp	d9, #0.0
csel	w9, wzr, w9, le
cmp	x8, x26
csel	w8, wzr, w9, ge
LFQH_LBB50_40:
cbz	w8, LFQH_LBB50_48
ldr	d0, [sp, #168]
fcmp	d9, d0
b.gt	LFQH_LBB50_48
ldr	d0, [sp, #160]
fcmp	d11, d0
b.mi	LFQH_LBB50_48
ldr	d0, [sp, #152]
fcmp	d8, d0
b.mi	LFQH_LBB50_48
fadd	d0, d8, d9
fcmp	d0, d15
b.gt	LFQH_LBB50_48
mov	x0, x23
mov	x1, x22
bl	LFQH_Get
cbz	x0, LFQH_LBB50_47
mov	x21, x23
cmp	x0, x19
b.ne	LFQH_LBB50_28
LFQH_LBB50_47:
mov	x21, x23
LFQH_LBB50_48:
fmov	d15, d13
b	LFQH_LBB50_116
LFQH_LBB50_49:
mov	w20, #0
mov	x21, #0
LFQH_LBB50_50:
LFQH_Lloh1008:
adr x1, LFQH_DramaSpacingTarget178R2Key
LFQH_Lloh1009:
nop
mov	x0, x19
bl Lpatch + (0xa628 - PATCH_BASE)
LFQH_Lloh1010:
adr x1, LFQH_l_.str.81
LFQH_Lloh1011:
nop
bl	LFQH_Get
mov	x23, x0
cmp	x0, x21
ccmp	x0, #0, #4, ne
b.eq	LFQH_LBB50_52
mov	x0, x19
bl	LFQH_DramaSpacingRestore178R2
LFQH_LBB50_52:
cbz	x21, LFQH_LBB50_82
str	d14, [sp, #88]
LFQH_Lloh1012:
adr x0, LFQH_l_.str.372
LFQH_Lloh1013:
nop
bl Lpatch + (0xa5a4 - PATCH_BASE)
mov	x1, x0
mov	x0, x21
bl Lpatch + (0xa5d4 - PATCH_BASE)
stp	d0, d1, [sp, #160]
fmov	d13, d2
fmov	d12, d3
LFQH_Lloh1014:
adr x0, LFQH_l_.str.24
LFQH_Lloh1015:
nop
bl Lpatch + (0xa5a4 - PATCH_BASE)
mov	x1, x0
mov	x0, x21
bl Lpatch + (0xa5d4 - PATCH_BASE)
fmov	d8, d0
fmov	d9, d1
fmov	d14, d2
str	d3, [sp, #128]
LFQH_Lloh1016:
adr x1, LFQH_DramaSpacingApplied178R2Key
LFQH_Lloh1017:
nop
mov	x0, x21
bl Lpatch + (0xa628 - PATCH_BASE)
mov	x22, x0
LFQH_Lloh1018:
adr x1, LFQH_DramaSpacingStock178R2Key
LFQH_Lloh1019:
nop
mov	x0, x21
bl Lpatch + (0xa628 - PATCH_BASE)
mov	x24, x0
str	w20, [sp, #108]
str	x23, [sp, #96]
stp	d12, d13, [sp, #16]
str	x22, [sp, #40]
cbz	x22, LFQH_LBB50_60
cbz	x24, LFQH_LBB50_60
LFQH_Lloh1020:
adr x0, LFQH_l_.str.432
LFQH_Lloh1021:
nop
bl Lpatch + (0xa5a4 - PATCH_BASE)
mov	x1, x0
mov	x0, x22
bl Lpatch + (0xa5d4 - PATCH_BASE)
ldr	d4, [sp, #160]
fcmp	d4, d0
b.ne	LFQH_LBB50_60
ldr	d0, [sp, #168]
fcmp	d0, d1
b.ne	LFQH_LBB50_60
fcmp	d13, d2
b.ne	LFQH_LBB50_60
fmov	d11, d15
fcmp	d12, d3
ldp	d1, d0, [sp, #160]
stp	d1, d0, [sp, #144]
str	d12, [sp, #136]
b.ne	LFQH_LBB50_61
LFQH_Lloh1022:
adr x0, LFQH_l_.str.432
LFQH_Lloh1023:
nop
bl Lpatch + (0xa5a4 - PATCH_BASE)
mov	x1, x0
mov	x0, x24
bl Lpatch + (0xa5d4 - PATCH_BASE)
stp	d0, d1, [sp, #144]
fmov	d13, d2
str	d3, [sp, #136]
b	LFQH_LBB50_61
LFQH_LBB50_60:
fmov	d11, d15
ldp	d1, d0, [sp, #160]
stp	d1, d0, [sp, #144]
str	d12, [sp, #136]
LFQH_LBB50_61:
str	x24, [sp, #32]
str	d13, [sp, #120]
LFQH_Lloh1024:
adr x22, LFQH_l_.str.507
LFQH_Lloh1025:
nop
mov	x0, x22
bl Lpatch + (0xa5a4 - PATCH_BASE)
mov	x1, x0
mov	x0, x21
fmov	d0, d8
fmov	d1, d9
fmov	d2, d14
ldr	d3, [sp, #128]
mov	x2, x19
bl Lpatch + (0xa5d4 - PATCH_BASE)
stp	d1, d3, [sp, #64]
str	d2, [sp, #80]
ldur	x25, [x29, #-160]
LFQH_Lloh1026:
adr x0, LFQH_l_.str.24
LFQH_Lloh1027:
nop
bl Lpatch + (0xa5a4 - PATCH_BASE)
mov	x1, x0
mov	x0, x25
bl Lpatch + (0xa5d4 - PATCH_BASE)
fmov	d8, d0
fmov	d12, d1
fmov	d13, d2
fmov	d15, d3
mov	x0, x22
bl Lpatch + (0xa5a4 - PATCH_BASE)
mov	x1, x0
mov	x0, x25
fmov	d0, d8
fmov	d1, d12
fmov	d2, d13
fmov	d3, d15
mov	x2, x19
bl Lpatch + (0xa5d4 - PATCH_BASE)
stp	d3, d1, [sp, #48]
mov	x22, #0
ldur	x26, [x29, #-168]
str	x28, [sp, #112]
cbz	x26, LFQH_LBB50_71
cmp	x26, x19
b.eq	LFQH_LBB50_71
mov	x22, #0
fmov	d0, #0.50000000
fmul	d12, d10, d0
LFQH_Lloh1028:
adr x8, LFQH_lCPI50_0
LFQH_Lloh1029:
ldr d0, [x8]
and x8, x8, #0xfffffffffffff000
fmul	d0, d11, d0
ldr	d1, [sp, #88]
fadd	d9, d1, d0
LFQH_Lloh1030:
adr x27, LFQH_l_.str.24
LFQH_Lloh1031:
nop
LFQH_Lloh1032:
adr x28, LFQH_l_.str.507
LFQH_Lloh1033:
nop
LFQH_Lloh1034:
adr x25, LFQH_l_.str.20
LFQH_Lloh1035:
nop
mov	x24, #9218868437227405311
mov	x20, #4634204016564240384
fmov	d11, xzr
mov	x23, #9218868437227405312
LFQH_LBB50_64:
mov	x0, x27
bl Lpatch + (0xa5a4 - PATCH_BASE)
mov	x1, x0
mov	x0, x26
bl Lpatch + (0xa5d4 - PATCH_BASE)
fmov	d8, d0
fmov	d10, d1
fmov	d13, d2
fmov	d15, d3
mov	x0, x28
bl Lpatch + (0xa5a4 - PATCH_BASE)
mov	x1, x0
mov	x0, x26
fmov	d0, d8
fmov	d1, d10
fmov	d2, d13
fmov	d3, d15
mov	x2, x19
bl Lpatch + (0xa5d4 - PATCH_BASE)
fmov	d8, d0
fmov	d15, d1
fmov	d10, d2
fmov	d13, d3
mov	x0, x26
bl	LFQH_DramaProgressName178R2
cbz	w0, LFQH_LBB50_69
fmov	x8, d8
and	x10, x8, #0x7fffffffffffffff
fmov	x8, d15
and	x8, x8, #0x7fffffffffffffff
cmp	x8, x24
cset	w8, gt
fmov	x9, d10
and	x9, x9, #0x7fffffffffffffff
cmp	x9, x24
cset	w9, gt
cmp	x10, x24
b.gt	LFQH_LBB50_69
tbnz	w8, #0, LFQH_LBB50_69
tbnz	w9, #0, LFQH_LBB50_69
fmov	x8, d13
and	x8, x8, #0x7fffffffffffffff
fcmp	d15, d9
fccmp	d10, d12, #8, gt
fmov	d0, x20
fccmp	d13, d0, #2, ge
fccmp	d13, d11, #4, ls
fccmp	d10, d11, #4, gt
ccmp	x8, x23, #0, gt
csel	x22, x26, x22, lt
LFQH_LBB50_69:
mov	x0, x26
mov	x1, x25
bl	LFQH_Get
cbz	x0, LFQH_LBB50_71
mov	x26, x0
cmp	x0, x19
b.ne	LFQH_LBB50_64
LFQH_LBB50_71:
fmov	d10, xzr
ldp	x8, x9, [sp, #144]
ldr	d0, [sp, #120]
fmov	x10, d0
and	x11, x8, #0x7fffffffffffffff
and	x8, x9, #0x7fffffffffffffff
mov	x12, #9218868437227405311
cmp	x8, x12
cset	w8, gt
and	x9, x10, #0x7fffffffffffffff
cmp	x9, x12
cset	w9, gt
cmp	x11, x12
b.gt	LFQH_LBB50_80
tbnz	w8, #0, LFQH_LBB50_80
tbnz	w9, #0, LFQH_LBB50_80
ldr	x8, [sp, #136]
and	x8, x8, #0x7fffffffffffffff
mov	x9, #9218868437227405311
cmp	x8, x9
b.gt	LFQH_LBB50_80
fcmp	d0, #0.0
b.le	LFQH_LBB50_80
ldr	d0, [sp, #136]
fcmp	d0, #0.0
b.le	LFQH_LBB50_80
ldr	d0, [sp, #80]
fabd	d1, d0, d14
fmov	d0, #0.50000000
fcmp	d1, d0
b.pl	LFQH_LBB50_80
ldr	d1, [sp, #128]
ldr	d2, [sp, #72]
fabd	d1, d2, d1
fcmp	d1, d0
b.pl	LFQH_LBB50_80
ldr	d0, [sp, #168]
ldr	d1, [sp, #152]
fsub	d0, d1, d0
ldp	d2, d1, [sp, #48]
fadd	d1, d0, d1
fadd	d1, d2, d1
fmov	d2, #8.00000000
fadd	d1, d1, d2
ldr	d2, [sp, #200]
fsub	d1, d1, d2
fmaxnm	d13, d1, d10
mov	x8, #4635329916471083008
fmov	d1, x8
fcmp	d13, d1
ldr	d1, [sp, #64]
fadd	d0, d0, d1
fsub	d0, d0, d13
fmov	d1, #8.00000000
ldr	d2, [sp, #88]
fadd	d1, d2, d1
fccmp	d0, d1, #8, ls
b.ge	LFQH_LBB50_99
LFQH_LBB50_80:
mov	x0, x19
bl	LFQH_DramaSpacingRestore178R2
LFQH_Lloh1036:
adr x24, LFQH_l_.str.87
LFQH_Lloh1037:
nop
ldr	x28, [sp, #112]
LFQH_LBB50_81:
ldr	w20, [sp, #108]
ldr	x23, [sp, #96]
b	LFQH_LBB50_83
LFQH_LBB50_82:
mov	x22, #0
fmov	d10, xzr
LFQH_LBB50_83:
cmp	x23, #0
cset	w8, eq
bic	w8, w8, w20
tbnz	w8, #0, LFQH_LBB50_97
LFQH_Lloh1038:
adr x0, LFQH_l_.str.88
LFQH_Lloh1039:
nop
bl Lpatch + (0xa5b0 - PATCH_BASE)
mov	x21, x0
LFQH_Lloh1040:
adr x0, LFQH_l_.str.89
LFQH_Lloh1041:
nop
bl Lpatch + (0xa5a4 - PATCH_BASE)
mov	x1, x0
mov	x0, x21
bl Lpatch + (0xa5d4 - PATCH_BASE)
mov	x21, x0
LFQH_Lloh1042:
adr x23, LFQH_l_.str.361
LFQH_Lloh1043:
nop
mov	x0, x23
bl Lpatch + (0xa5b0 - PATCH_BASE)
mov	x26, x0
LFQH_Lloh1044:
adr x25, LFQH_l_.str.387
LFQH_Lloh1045:
nop
mov	x0, x25
bl Lpatch + (0xa5a4 - PATCH_BASE)
mov	x1, x0
mov	x0, x26
mov	x2, x24
bl Lpatch + (0xa5d4 - PATCH_BASE)
mov	x2, x0
LFQH_Lloh1046:
adr x1, LFQH_l_.str.90
LFQH_Lloh1047:
nop
mov	x0, x21
bl	LFQH_Put
LFQH_Lloh1048:
adr x24, LFQH_l_.str.497
LFQH_Lloh1049:
nop
mov	x0, x24
bl Lpatch + (0xa5b0 - PATCH_BASE)
mov	x27, x0
LFQH_Lloh1050:
adr x26, LFQH_l_.str.515
LFQH_Lloh1051:
nop
mov	x0, x26
bl Lpatch + (0xa5a4 - PATCH_BASE)
mov	x1, x0
mov	x0, x27
fmov	d0, d10
bl Lpatch + (0xa5d4 - PATCH_BASE)
mov	x2, x0
LFQH_Lloh1052:
adr x1, LFQH_l_.str.91
LFQH_Lloh1053:
nop
mov	x0, x21
bl	LFQH_Put
mov	x0, x23
bl Lpatch + (0xa5b0 - PATCH_BASE)
mov	x27, x0
mov	x0, x25
bl Lpatch + (0xa5a4 - PATCH_BASE)
mov	x1, x0
LFQH_Lloh1054:
adr x2, LFQH_l_.str.93
LFQH_Lloh1055:
nop
mov	x0, x27
bl Lpatch + (0xa5d4 - PATCH_BASE)
mov	x2, x0
LFQH_Lloh1056:
adr x1, LFQH_l_.str.92
LFQH_Lloh1057:
nop
mov	x0, x21
bl	LFQH_Put
mov	x0, x23
bl Lpatch + (0xa5b0 - PATCH_BASE)
mov	x23, x0
mov	x0, x25
bl Lpatch + (0xa5a4 - PATCH_BASE)
mov	x1, x0
LFQH_Lloh1058:
adr x2, LFQH_l_.str.95
LFQH_Lloh1059:
nop
mov	x0, x23
bl Lpatch + (0xa5d4 - PATCH_BASE)
mov	x2, x0
LFQH_Lloh1060:
adr x1, LFQH_l_.str.94
LFQH_Lloh1061:
nop
mov	x0, x21
bl	LFQH_Put
mov	x0, x24
bl Lpatch + (0xa5b0 - PATCH_BASE)
mov	x23, x0
mov	x0, x26
bl Lpatch + (0xa5a4 - PATCH_BASE)
mov	x1, x0
fmov	d0, #8.00000000
mov	x0, x23
bl Lpatch + (0xa5d4 - PATCH_BASE)
mov	x2, x0
LFQH_Lloh1062:
adr x1, LFQH_l_.str.96
LFQH_Lloh1063:
nop
mov	x0, x21
bl	LFQH_Put
ldp	x23, x24, [x29, #-168]
cbz	x24, LFQH_LBB50_88
cbz	x23, LFQH_LBB50_88
ldr	d0, [sp, #216]
fmov	d1, #8.00000000
fcmp	d0, d1
b.hi	LFQH_LBB50_88
LFQH_Lloh1064:
adr x0, LFQH_l_.str.24
LFQH_Lloh1065:
nop
bl Lpatch + (0xa5a4 - PATCH_BASE)
mov	x1, x0
mov	x0, x24
bl Lpatch + (0xa5d4 - PATCH_BASE)
fmov	d8, d0
fmov	d9, d1
fmov	d10, d2
fmov	d11, d3
LFQH_Lloh1066:
adr x0, LFQH_l_.str.507
LFQH_Lloh1067:
nop
bl Lpatch + (0xa5a4 - PATCH_BASE)
mov	x1, x0
mov	x0, x24
fmov	d0, d8
fmov	d1, d9
fmov	d2, d10
fmov	d3, d11
mov	x2, x19
bl Lpatch + (0xa5d4 - PATCH_BASE)
ldr	d0, [sp, #200]
fsub	d0, d0, d1
fsub	d8, d0, d3
LFQH_Lloh1068:
adr x0, LFQH_l_.str.497
LFQH_Lloh1069:
nop
bl Lpatch + (0xa5b0 - PATCH_BASE)
mov	x25, x0
LFQH_Lloh1070:
adr x0, LFQH_l_.str.515
LFQH_Lloh1071:
nop
bl Lpatch + (0xa5a4 - PATCH_BASE)
mov	x1, x0
mov	x0, x25
fmov	d0, d8
bl Lpatch + (0xa5d4 - PATCH_BASE)
mov	x2, x0
LFQH_Lloh1072:
adr x1, LFQH_l_.str.97
LFQH_Lloh1073:
nop
mov	x0, x21
bl	LFQH_Put
b	LFQH_LBB50_89
LFQH_LBB50_88:
cbz	x24, LFQH_LBB50_90
LFQH_LBB50_89:
LFQH_Lloh1074:
adr x0, LFQH_l_.str.24
LFQH_Lloh1075:
nop
bl Lpatch + (0xa5a4 - PATCH_BASE)
mov	x1, x0
mov	x0, x24
bl Lpatch + (0xa5d4 - PATCH_BASE)
fmov	d8, d0
fmov	d9, d1
fmov	d10, d2
fmov	d11, d3
LFQH_Lloh1076:
adr x0, LFQH_l_.str.507
LFQH_Lloh1077:
nop
bl Lpatch + (0xa5a4 - PATCH_BASE)
mov	x1, x0
mov	x0, x24
fmov	d0, d8
fmov	d1, d9
fmov	d2, d10
fmov	d3, d11
mov	x2, x28
bl Lpatch + (0xa5d4 - PATCH_BASE)
bl	LFQH_RectArray
mov	x2, x0
LFQH_Lloh1078:
adr x1, LFQH_l_.str.98
LFQH_Lloh1079:
nop
mov	x0, x21
bl	LFQH_Put
LFQH_LBB50_90:
cbz	x23, LFQH_LBB50_92
LFQH_Lloh1080:
adr x0, LFQH_l_.str.24
LFQH_Lloh1081:
nop
bl Lpatch + (0xa5a4 - PATCH_BASE)
mov	x1, x0
mov	x0, x23
bl Lpatch + (0xa5d4 - PATCH_BASE)
fmov	d8, d0
fmov	d9, d1
fmov	d10, d2
fmov	d11, d3
LFQH_Lloh1082:
adr x0, LFQH_l_.str.507
LFQH_Lloh1083:
nop
bl Lpatch + (0xa5a4 - PATCH_BASE)
mov	x1, x0
mov	x0, x23
fmov	d0, d8
fmov	d1, d9
fmov	d2, d10
fmov	d3, d11
mov	x2, x28
bl Lpatch + (0xa5d4 - PATCH_BASE)
bl	LFQH_RectArray
mov	x2, x0
LFQH_Lloh1084:
adr x1, LFQH_l_.str.99
LFQH_Lloh1085:
nop
mov	x0, x21
bl	LFQH_Put
mov	x0, x23
bl Lpatch + (0xa664 - PATCH_BASE)
LFQH_Lloh1086:
adr x1, LFQH_l_.str.101
LFQH_Lloh1087:
nop
bl	LFQH_Get
mov	x2, x0
LFQH_Lloh1088:
adr x1, LFQH_l_.str.100
LFQH_Lloh1089:
nop
mov	x0, x21
bl	LFQH_Put
LFQH_LBB50_92:
cbz	x22, LFQH_LBB50_94
mov	x0, x22
bl Lpatch + (0xa664 - PATCH_BASE)
LFQH_Lloh1090:
adr x1, LFQH_l_.str.101
LFQH_Lloh1091:
nop
bl	LFQH_Get
mov	x2, x0
LFQH_Lloh1092:
adr x1, LFQH_l_.str.102
LFQH_Lloh1093:
nop
mov	x0, x21
bl	LFQH_Put
LFQH_Lloh1094:
adr x0, LFQH_l_.str.24
LFQH_Lloh1095:
nop
bl Lpatch + (0xa5a4 - PATCH_BASE)
mov	x1, x0
mov	x0, x22
bl Lpatch + (0xa5d4 - PATCH_BASE)
fmov	d8, d0
fmov	d9, d1
fmov	d10, d2
fmov	d11, d3
LFQH_Lloh1096:
adr x0, LFQH_l_.str.507
LFQH_Lloh1097:
nop
bl Lpatch + (0xa5a4 - PATCH_BASE)
mov	x1, x0
mov	x0, x22
fmov	d0, d8
fmov	d1, d9
fmov	d2, d10
fmov	d3, d11
mov	x2, x28
bl Lpatch + (0xa5d4 - PATCH_BASE)
bl	LFQH_RectArray
mov	x2, x0
LFQH_Lloh1098:
adr x1, LFQH_l_.str.103
LFQH_Lloh1099:
nop
mov	x0, x21
bl	LFQH_Put
LFQH_LBB50_94:
LFQH_Lloh1100:
adr x1, LFQH_DramaSpacingLog178R2Key
LFQH_Lloh1101:
nop
mov	x0, x19
bl Lpatch + (0xa628 - PATCH_BASE)
cbz	x0, LFQH_LBB50_96
mov	x20, x0
LFQH_Lloh1102:
adr x0, LFQH_l_.str.49
LFQH_Lloh1103:
nop
bl Lpatch + (0xa5a4 - PATCH_BASE)
mov	x1, x0
mov	x0, x20
mov	x2, x21
bl Lpatch + (0xa5d4 - PATCH_BASE)
cbnz	w0, LFQH_LBB50_97
LFQH_LBB50_96:
LFQH_Lloh1104:
adr x0, LFQH_l_.str.104
LFQH_Lloh1105:
nop
mov	x1, x21
bl Lrecord_named
LFQH_Lloh1106:
adr x1, LFQH_DramaSpacingLog178R2Key
LFQH_Lloh1107:
nop
mov	x0, x19
mov	x2, x21
mov	w3, #1
bl Lpatch + (0xa634 - PATCH_BASE)
LFQH_LBB50_97:
LFQH_Lloh1108:
adr x1, LFQH_DramaSpacingBusy178R2Key
LFQH_Lloh1109:
nop
mov	x0, x19
mov	x2, #0
mov	x3, #0
bl Lpatch + (0xa634 - PATCH_BASE)
LFQH_LBB50_98:
ldp	x29, x30, [sp, #400]
ldp	x20, x19, [sp, #384]
ldp	x22, x21, [sp, #368]
ldp	x24, x23, [sp, #352]
ldp	x26, x25, [sp, #336]
ldp	x28, x27, [sp, #320]
ldp	d9, d8, [sp, #304]
ldp	d11, d10, [sp, #288]
ldp	d13, d12, [sp, #272]
ldp	d15, d14, [sp, #256]
add	sp, sp, #416
ret
LFQH_LBB50_99:
LFQH_Lloh1110:
adr x1, LFQH_l_.str.20
LFQH_Lloh1111:
nop
mov	x0, x21
bl	LFQH_Get
cbz	x0, LFQH_LBB50_80
mov	x27, x0
ldr	d0, [sp, #152]
fsub	d0, d0, d13
str	d0, [sp, #128]
LFQH_Lloh1112:
adr x28, LFQH_l_.str.24
LFQH_Lloh1113:
nop
mov	x25, #9218868437227405311
fmov	d15, #-0.50000000
fmov	d9, #0.50000000
mov	x26, x0
LFQH_LBB50_101:
LFQH_Lloh1114:
adr x0, LFQH_l_.str.507
LFQH_Lloh1115:
nop
bl Lpatch + (0xa5a4 - PATCH_BASE)
mov	x1, x0
mov	x0, x27
ldp	d3, d0, [sp, #136]
ldp	d2, d1, [sp, #120]
mov	x2, x26
bl Lpatch + (0xa5d4 - PATCH_BASE)
fmov	d12, d0
fmov	d8, d1
fmov	d14, d2
fmov	d11, d3
fmov	x20, d14
fmov	x23, d8
fmov	x24, d12
mov	x0, x28
bl Lpatch + (0xa5a4 - PATCH_BASE)
mov	x1, x0
mov	x0, x26
bl Lpatch + (0xa5d4 - PATCH_BASE)
and	x10, x24, #0x7fffffffffffffff
and	x8, x23, #0x7fffffffffffffff
cmp	x8, x25
cset	w8, gt
and	x9, x20, #0x7fffffffffffffff
cmp	x9, x25
cset	w9, gt
cmp	x10, x25
b.gt	LFQH_LBB50_80
tbnz	w8, #0, LFQH_LBB50_80
tbnz	w9, #0, LFQH_LBB50_80
fmov	x8, d11
and	x8, x8, #0x7fffffffffffffff
cmp	x8, x25
b.gt	LFQH_LBB50_80
fcmp	d14, #0.0
b.le	LFQH_LBB50_80
fcmp	d11, #0.0
b.le	LFQH_LBB50_80
fmov	x8, d0
and	x10, x8, #0x7fffffffffffffff
fmov	x8, d1
and	x8, x8, #0x7fffffffffffffff
cmp	x8, x25
cset	w9, gt
fmov	x8, d2
and	x8, x8, #0x7fffffffffffffff
cmp	x8, x25
cset	w8, gt
cmp	x10, x25
b.gt	LFQH_LBB50_114
mov	w10, #0
tbnz	w9, #0, LFQH_LBB50_110
fmov	x9, d3
and	x9, x9, #0x7fffffffffffffff
fcmp	d2, #0.0
cset	w10, gt
fcmp	d3, #0.0
csel	w10, wzr, w10, le
mov	x11, #9218868437227405312
cmp	x9, x11
csel	w9, wzr, w10, ge
tst	w8, #0x1
csel	w10, wzr, w9, ne
LFQH_LBB50_110:
cbz	w10, LFQH_LBB50_80
LFQH_LBB50_111:
fadd	d4, d0, d15
fadd	d5, d1, d15
fcmp	d12, d4
fccmp	d8, d5, #8, pl
fadd	d4, d12, d14
fadd	d0, d0, d2
fadd	d0, d0, d9
fccmp	d4, d0, #0, pl
fadd	d0, d8, d11
fadd	d1, d1, d3
fadd	d1, d1, d9
fccmp	d0, d1, #0, le
b.gt	LFQH_LBB50_80
cmp	x26, x19
b.eq	LFQH_LBB50_117
mov	x0, x26
LFQH_Lloh1116:
adr x1, LFQH_l_.str.20
LFQH_Lloh1117:
nop
bl	LFQH_Get
mov	x26, x0
cbnz	x0, LFQH_LBB50_101
b	LFQH_LBB50_80
LFQH_LBB50_114:
mov	w10, #0
cbnz	w10, LFQH_LBB50_111
b	LFQH_LBB50_80
LFQH_LBB50_115:
mov	x21, #0
LFQH_Lloh1118:
adr x24, LFQH_l_.str.76
LFQH_Lloh1119:
nop
LFQH_LBB50_116:
mov	w20, #1
b	LFQH_LBB50_50
LFQH_LBB50_117:
fcmp	d13, #0.0
ldr	x28, [sp, #112]
b.le	LFQH_LBB50_138
ldr	x20, [sp, #32]
cbz	x20, LFQH_LBB50_123
LFQH_Lloh1120:
adr x0, LFQH_l_.str.432
LFQH_Lloh1121:
nop
bl Lpatch + (0xa5a4 - PATCH_BASE)
mov	x1, x0
mov	x0, x20
bl Lpatch + (0xa5d4 - PATCH_BASE)
ldr	d4, [sp, #144]
fcmp	d4, d0
b.ne	LFQH_LBB50_123
ldr	d0, [sp, #152]
fcmp	d0, d1
b.ne	LFQH_LBB50_123
ldr	d0, [sp, #120]
fcmp	d0, d2
b.ne	LFQH_LBB50_123
ldr	d0, [sp, #136]
fcmp	d0, d3
b.eq	LFQH_LBB50_124
LFQH_LBB50_123:
LFQH_Lloh1122:
adr x0, LFQH_l_.str.512
LFQH_Lloh1123:
nop
bl Lpatch + (0xa5b0 - PATCH_BASE)
mov	x25, x0
LFQH_Lloh1124:
adr x0, LFQH_l_.str.513
LFQH_Lloh1125:
nop
bl Lpatch + (0xa5a4 - PATCH_BASE)
mov	x1, x0
mov	x0, x25
ldp	d0, d1, [sp, #144]
ldr	d2, [sp, #120]
ldr	d3, [sp, #136]
bl Lpatch + (0xa5d4 - PATCH_BASE)
mov	x2, x0
LFQH_Lloh1126:
adr x1, LFQH_DramaSpacingStock178R2Key
LFQH_Lloh1127:
nop
mov	x0, x21
mov	w3, #1
bl Lpatch + (0xa634 - PATCH_BASE)
LFQH_LBB50_124:
ldr	x23, [sp, #96]
ldr	x20, [sp, #40]
cbz	x20, LFQH_LBB50_129
LFQH_Lloh1128:
adr x0, LFQH_l_.str.432
LFQH_Lloh1129:
nop
bl Lpatch + (0xa5a4 - PATCH_BASE)
mov	x1, x0
mov	x0, x20
bl Lpatch + (0xa5d4 - PATCH_BASE)
ldr	d4, [sp, #144]
fcmp	d4, d0
b.ne	LFQH_LBB50_129
ldr	d0, [sp, #128]
fcmp	d0, d1
b.ne	LFQH_LBB50_129
ldr	d0, [sp, #120]
fcmp	d0, d2
b.ne	LFQH_LBB50_129
ldr	d0, [sp, #136]
fcmp	d0, d3
b.eq	LFQH_LBB50_130
LFQH_LBB50_129:
LFQH_Lloh1130:
adr x0, LFQH_l_.str.512
LFQH_Lloh1131:
nop
bl Lpatch + (0xa5b0 - PATCH_BASE)
mov	x24, x0
LFQH_Lloh1132:
adr x0, LFQH_l_.str.513
LFQH_Lloh1133:
nop
bl Lpatch + (0xa5a4 - PATCH_BASE)
mov	x1, x0
mov	x0, x24
ldp	d3, d0, [sp, #136]
ldp	d2, d1, [sp, #120]
bl Lpatch + (0xa5d4 - PATCH_BASE)
mov	x2, x0
LFQH_Lloh1134:
adr x1, LFQH_DramaSpacingApplied178R2Key
LFQH_Lloh1135:
nop
mov	x0, x21
mov	w3, #1
bl Lpatch + (0xa634 - PATCH_BASE)
LFQH_LBB50_130:
cmp	x23, x21
ldr	w20, [sp, #108]
b.eq	LFQH_LBB50_132
LFQH_Lloh1136:
adr x0, LFQH_l_.str.82
LFQH_Lloh1137:
nop
bl Lpatch + (0xa5b0 - PATCH_BASE)
mov	x24, x0
LFQH_Lloh1138:
adr x0, LFQH_l_.str.83
LFQH_Lloh1139:
nop
bl Lpatch + (0xa5a4 - PATCH_BASE)
mov	x1, x0
mov	x0, x24
bl Lpatch + (0xa5d4 - PATCH_BASE)
mov	x24, x0
LFQH_Lloh1140:
adr x0, LFQH_l_.str.84
LFQH_Lloh1141:
nop
bl Lpatch + (0xa5a4 - PATCH_BASE)
mov	x1, x0
mov	x0, x24
mov	x2, x21
bl Lpatch + (0xa5d4 - PATCH_BASE)
LFQH_Lloh1142:
adr x1, LFQH_DramaSpacingTarget178R2Key
LFQH_Lloh1143:
nop
mov	x0, x19
mov	x2, x24
mov	w3, #1
bl Lpatch + (0xa634 - PATCH_BASE)
LFQH_LBB50_132:
ldr	d0, [sp, #160]
ldr	d1, [sp, #144]
fcmp	d0, d1
ldr	d8, [sp, #120]
b.ne	LFQH_LBB50_136
ldr	d0, [sp, #168]
ldr	d1, [sp, #128]
fcmp	d0, d1
b.ne	LFQH_LBB50_136
ldr	d0, [sp, #24]
fcmp	d0, d8
b.ne	LFQH_LBB50_136
ldr	d0, [sp, #16]
ldr	d1, [sp, #136]
fcmp	d0, d1
b.eq	LFQH_LBB50_137
LFQH_LBB50_136:
LFQH_Lloh1144:
adr x0, LFQH_l_.str.156
LFQH_Lloh1145:
nop
bl Lpatch + (0xa5a4 - PATCH_BASE)
mov	x1, x0
mov	x0, x21
ldp	d3, d0, [sp, #136]
ldr	d1, [sp, #128]
fmov	d2, d8
bl Lpatch + (0xa5d4 - PATCH_BASE)
LFQH_LBB50_137:
LFQH_Lloh1146:
adr x24, LFQH_l_.str.85
LFQH_Lloh1147:
nop
fmov	d10, d13
b	LFQH_LBB50_83
LFQH_LBB50_138:
mov	x0, x19
bl	LFQH_DramaSpacingRestore178R2
fmov	d10, xzr
LFQH_Lloh1148:
adr x24, LFQH_l_.str.86
LFQH_Lloh1149:
nop
b	LFQH_LBB50_81
.cfi_endproc
.p2align	2
LFQH_DramaSpacingBusy178R2Key:
.cfi_startproc
ret
.cfi_endproc
.p2align	2
LFQH_DramaSpacingVisible178R2:
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
LFQH_Lloh1150:
adr x1, LFQH_l_.str.23
LFQH_Lloh1151:
nop
bl	LFQH_Kind
cbz	w0, LFQH_LBB52_8
LFQH_Lloh1152:
adr x0, LFQH_l_.str.71
LFQH_Lloh1153:
nop
bl Lpatch + (0xa5a4 - PATCH_BASE)
mov	x1, x0
mov	x0, x19
bl Lpatch + (0xa5d4 - PATCH_BASE)
cbnz	w0, LFQH_LBB52_7
LFQH_Lloh1154:
adr x0, LFQH_l_.str.477
LFQH_Lloh1155:
nop
bl Lpatch + (0xa5a4 - PATCH_BASE)
mov	x1, x0
mov	x0, x19
bl Lpatch + (0xa5d4 - PATCH_BASE)
LFQH_Lloh1156:
adr x8, LFQH_lCPI52_0
LFQH_Lloh1157:
ldr d1, [x8]
and x8, x8, #0xfffffffffffff000
fcmp	d0, d1
b.le	LFQH_LBB52_7
LFQH_Lloh1158:
adr x0, LFQH_l_.str.24
LFQH_Lloh1159:
nop
bl Lpatch + (0xa5a4 - PATCH_BASE)
mov	x1, x0
mov	x0, x19
bl Lpatch + (0xa5d4 - PATCH_BASE)
mov	w0, #0
fmov	x9, d2
fmov	x8, d1
fmov	x10, d0
and	x10, x10, #0x7fffffffffffffff
and	x8, x8, #0x7fffffffffffffff
mov	x11, #9218868437227405311
cmp	x8, x11
cset	w8, gt
and	x9, x9, #0x7fffffffffffffff
cmp	x9, x11
cset	w9, gt
cmp	x10, x11
b.gt	LFQH_LBB52_8
tbnz	w8, #0, LFQH_LBB52_8
tbnz	w9, #0, LFQH_LBB52_8
fmov	x8, d3
and	x8, x8, #0x7fffffffffffffff
fcmp	d2, #0.0
cset	w9, gt
fcmp	d3, #0.0
csel	w9, wzr, w9, le
mov	x10, #9218868437227405312
cmp	x8, x10
csel	w0, wzr, w9, ge
b	LFQH_LBB52_8
LFQH_LBB52_7:
mov	w0, #0
LFQH_LBB52_8:
ldp	x29, x30, [sp, #16]
ldp	x20, x19, [sp], #32
ret
.cfi_endproc
.p2align	2
LFQH_DramaSpacingScan178R2:
.cfi_startproc
cbz	w2, LFQH_LBB53_37
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
mov	x22, x3
ldr	w8, [x3]
cmp	w8, #1
b.lt	LFQH_LBB53_36
mov	x21, x7
mov	x19, x6
mov	x20, x5
mov	x26, x4
mov	x25, x2
mov	x23, x1
mov	x24, x0
bl	LFQH_DramaSpacingVisible178R2
cbz	w0, LFQH_LBB53_36
ldr	w8, [x22]
sub	w8, w8, #1
str	w8, [x22]
LFQH_Lloh1160:
adr x0, LFQH_l_.str.24
LFQH_Lloh1161:
nop
bl Lpatch + (0xa5a4 - PATCH_BASE)
mov	x1, x0
mov	x0, x23
bl Lpatch + (0xa5d4 - PATCH_BASE)
fmov	d11, d1
fmov	d14, d2
fmov	d12, d3
mov	x0, x24
mov	x1, x23
bl	LFQH_DramaSpacingMeasure178R2
fmov	d13, d0
fmov	d8, d1
fmov	d10, d2
fmov	x9, d10
fmov	x8, d8
fmov	x10, d13
and	x10, x10, #0x7fffffffffffffff
and	x8, x8, #0x7fffffffffffffff
mov	x11, #9218868437227405311
cmp	x8, x11
cset	w8, gt
and	x9, x9, #0x7fffffffffffffff
cmp	x9, x11
cset	w9, gt
cmp	x10, x11
b.gt	LFQH_LBB53_36
tbnz	w8, #0, LFQH_LBB53_36
tbnz	w9, #0, LFQH_LBB53_36
fmov	d9, d3
fmov	x8, d9
and	x8, x8, #0x7fffffffffffffff
mov	x9, #9218868437227405311
cmp	x8, x9
b.gt	LFQH_LBB53_36
fcmp	d10, #0.0
b.le	LFQH_LBB53_36
fcmp	d9, #0.0
b.le	LFQH_LBB53_36
fadd	d0, d11, d12
fadd	d1, d8, d9
fcmp	d8, d0
fccmp	d1, d11, #0, lt
b.ls	LFQH_LBB53_36
LFQH_Lloh1162:
adr x1, LFQH_l_.str.182
LFQH_Lloh1163:
nop
mov	x0, x24
bl	LFQH_Kind
cbz	w0, LFQH_LBB53_12
LFQH_Lloh1164:
adr x1, LFQH_DramaWatchContentKey
LFQH_Lloh1165:
nop
mov	x0, x24
bl Lpatch + (0xa628 - PATCH_BASE)
cbnz	x0, LFQH_LBB53_14
LFQH_LBB53_12:
LFQH_Lloh1166:
adr x1, LFQH_l_.str.187
LFQH_Lloh1167:
nop
mov	x0, x24
bl	LFQH_Kind
cbz	w0, LFQH_LBB53_19
LFQH_Lloh1168:
adr x1, LFQH_l_.str.508
LFQH_Lloh1169:
nop
mov	x0, x24
bl	LFQH_Get
cbz	x0, LFQH_LBB53_19
LFQH_LBB53_14:
fmov	d0, #0.50000000
fmul	d0, d14, d0
fcmp	d10, d0
b.lt	LFQH_LBB53_36
fmov	d0, #24.00000000
fcmp	d9, d0
b.lt	LFQH_LBB53_36
mov	x8, #4636737291354636288
fmov	d0, x8
fcmp	d9, d0
b.hi	LFQH_LBB53_36
fmov	d0, #0.50000000
fmul	d0, d12, d0
fadd	d0, d11, d0
fcmp	d8, d0
b.le	LFQH_LBB53_36
str	x24, [x20]
ldr	x8, [x19]
add	x8, x8, #1
str	x8, [x19]
b	LFQH_LBB53_36
LFQH_LBB53_19:
ldr	x8, [x29, #16]
str	x8, [sp, #8]
cbnz	w26, LFQH_LBB53_21
mov	x0, x24
bl	LFQH_DramaProgressName178R2
cbz	w0, LFQH_LBB53_31
LFQH_LBB53_21:
LFQH_Lloh1170:
adr x1, LFQH_l_.str.36
LFQH_Lloh1171:
nop
mov	x0, x24
bl	LFQH_Kind
cbz	w0, LFQH_LBB53_23
mov	w26, #1
b	LFQH_LBB53_32
LFQH_LBB53_23:
fmov	d0, #0.50000000
fmul	d0, d14, d0
mov	w26, #1
fcmp	d10, d0
b.lt	LFQH_LBB53_32
mov	x8, #4634204016564240384
fmov	d0, x8
fcmp	d9, d0
b.hi	LFQH_LBB53_32
LFQH_Lloh1172:
adr x8, LFQH_lCPI53_0
LFQH_Lloh1173:
ldr d0, [x8]
and x8, x8, #0xfffffffffffff000
fmul	d0, d12, d0
fadd	d0, d11, d0
fcmp	d8, d0
b.le	LFQH_LBB53_32
ldr	x8, [x21]
cbz	x8, LFQH_LBB53_30
ldr	x8, [sp, #8]
ldr	d0, [x8, #24]
fcmp	d9, d0
b.mi	LFQH_LBB53_30
b.ne	LFQH_LBB53_32
ldr	x8, [sp, #8]
ldr	d0, [x8, #8]
fcmp	d8, d0
b.le	LFQH_LBB53_32
LFQH_LBB53_30:
str	x24, [x21]
ldr	x8, [sp, #8]
stp	d13, d8, [x8]
stp	d10, d9, [x8, #16]
b	LFQH_LBB53_32
LFQH_LBB53_31:
mov	w26, #0
LFQH_LBB53_32:
LFQH_Lloh1174:
adr x1, LFQH_l_.str.414
LFQH_Lloh1175:
nop
mov	x0, x24
bl	LFQH_Get
mov	x24, x0
LFQH_Lloh1176:
adr x0, LFQH_l_.str.34
LFQH_Lloh1177:
nop
bl Lpatch + (0xa5a4 - PATCH_BASE)
mov	x1, x0
mov	x0, x24
bl Lpatch + (0xa5d4 - PATCH_BASE)
cbz	x0, LFQH_LBB53_36
mov	x27, x0
mov	x28, #0
sub	w25, w25, #1
LFQH_LBB53_34:
ldr	w8, [x22]
cmp	w8, #1
b.lt	LFQH_LBB53_36
LFQH_Lloh1178:
adr x0, LFQH_l_.str.461
LFQH_Lloh1179:
nop
bl Lpatch + (0xa5a4 - PATCH_BASE)
mov	x1, x0
mov	x0, x24
mov	x2, x28
bl Lpatch + (0xa5d4 - PATCH_BASE)
ldr	x8, [sp, #8]
str	x8, [sp]
mov	x1, x23
mov	x2, x25
mov	x3, x22
mov	x4, x26
mov	x5, x20
mov	x6, x19
mov	x7, x21
bl	LFQH_DramaSpacingScan178R2
add	x28, x28, #1
cmp	x27, x28
b.ne	LFQH_LBB53_34
LFQH_LBB53_36:
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
LFQH_LBB53_37:
ret
.cfi_endproc
.p2align	2
LFQH_DramaSpacingMeasure178R2:
.cfi_startproc
stp	d15, d14, [sp, #-128]!
stp	d13, d12, [sp, #16]
stp	d11, d10, [sp, #32]
stp	d9, d8, [sp, #48]
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
.cfi_offset b8, -72
.cfi_offset b9, -80
.cfi_offset b10, -88
.cfi_offset b11, -96
.cfi_offset b12, -104
.cfi_offset b13, -112
.cfi_offset b14, -120
.cfi_offset b15, -128
mov	x19, x1
mov	x20, x0
LFQH_Lloh1180:
adr x0, LFQH_l_.str.24
LFQH_Lloh1181:
nop
bl Lpatch + (0xa5a4 - PATCH_BASE)
mov	x1, x0
mov	x0, x20
bl Lpatch + (0xa5d4 - PATCH_BASE)
fmov	d8, d0
fmov	d9, d1
fmov	d10, d2
fmov	d11, d3
LFQH_Lloh1182:
adr x0, LFQH_l_.str.507
LFQH_Lloh1183:
nop
bl Lpatch + (0xa5a4 - PATCH_BASE)
mov	x1, x0
mov	x0, x20
fmov	d0, d8
fmov	d1, d9
fmov	d2, d10
fmov	d3, d11
mov	x2, x19
bl Lpatch + (0xa5d4 - PATCH_BASE)
fmov	d8, d0
fmov	d11, d1
fmov	d9, d2
fmov	d10, d3
LFQH_Lloh1184:
adr x1, LFQH_DramaSpacingTarget178R2Key
LFQH_Lloh1185:
nop
mov	x0, x19
bl Lpatch + (0xa628 - PATCH_BASE)
LFQH_Lloh1186:
adr x1, LFQH_l_.str.81
LFQH_Lloh1187:
nop
bl	LFQH_Get
mov	x22, x0
LFQH_Lloh1188:
adr x1, LFQH_DramaSpacingStock178R2Key
LFQH_Lloh1189:
nop
bl Lpatch + (0xa628 - PATCH_BASE)
mov	x21, x0
LFQH_Lloh1190:
adr x1, LFQH_DramaSpacingApplied178R2Key
LFQH_Lloh1191:
nop
mov	x0, x22
bl Lpatch + (0xa628 - PATCH_BASE)
cbz	x21, LFQH_LBB54_9
mov	x19, x0
cbz	x0, LFQH_LBB54_9
cbz	x20, LFQH_LBB54_9
mov	w24, #0
LFQH_Lloh1192:
adr x23, LFQH_l_.str.20
LFQH_Lloh1193:
nop
LFQH_LBB54_4:
cmp	x20, x22
b.eq	LFQH_LBB54_7
mov	x0, x20
mov	x1, x23
bl	LFQH_Get
cbz	x0, LFQH_LBB54_9
mov	x20, x0
add	w8, w24, #1
cmp	w24, #7
mov	x24, x8
b.lo	LFQH_LBB54_4
b	LFQH_LBB54_9
LFQH_LBB54_7:
LFQH_Lloh1194:
adr x0, LFQH_l_.str.372
LFQH_Lloh1195:
nop
bl Lpatch + (0xa5a4 - PATCH_BASE)
mov	x1, x0
mov	x0, x22
bl Lpatch + (0xa5d4 - PATCH_BASE)
fmov	d12, d0
fmov	d13, d1
fmov	d14, d2
fmov	d15, d3
LFQH_Lloh1196:
adr x0, LFQH_l_.str.432
LFQH_Lloh1197:
nop
bl Lpatch + (0xa5a4 - PATCH_BASE)
mov	x1, x0
mov	x0, x19
bl Lpatch + (0xa5d4 - PATCH_BASE)
fcmp	d12, d0
fccmp	d13, d1, #0, eq
fccmp	d14, d2, #0, eq
fccmp	d15, d3, #0, eq
b.ne	LFQH_LBB54_9
LFQH_Lloh1198:
adr x20, LFQH_l_.str.432
LFQH_Lloh1199:
nop
mov	x0, x20
bl Lpatch + (0xa5a4 - PATCH_BASE)
mov	x1, x0
mov	x0, x21
bl Lpatch + (0xa5d4 - PATCH_BASE)
fmov	d12, d1
mov	x0, x20
bl Lpatch + (0xa5a4 - PATCH_BASE)
mov	x1, x0
mov	x0, x19
bl Lpatch + (0xa5d4 - PATCH_BASE)
fsub	d0, d12, d1
fadd	d11, d11, d0
LFQH_LBB54_9:
fmov	d0, d8
fmov	d1, d11
fmov	d2, d9
fmov	d3, d10
ldp	x29, x30, [sp, #112]
ldp	x20, x19, [sp, #96]
ldp	x22, x21, [sp, #80]
ldp	x24, x23, [sp, #64]
ldp	d9, d8, [sp, #48]
ldp	d11, d10, [sp, #32]
ldp	d13, d12, [sp, #16]
ldp	d15, d14, [sp], #128
ret
.cfi_endproc
.p2align	2
LFQH_DramaSpacingTarget178R2Key:
.cfi_startproc
ret
.cfi_endproc
.p2align	2
LFQH_DramaSpacingRestore178R2:
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
LFQH_Lloh1200:
adr x1, LFQH_DramaSpacingTarget178R2Key
LFQH_Lloh1201:
nop
bl Lpatch + (0xa628 - PATCH_BASE)
LFQH_Lloh1202:
adr x1, LFQH_l_.str.81
LFQH_Lloh1203:
nop
bl	LFQH_Get
mov	x20, x0
LFQH_Lloh1204:
adr x1, LFQH_DramaSpacingStock178R2Key
LFQH_Lloh1205:
nop
bl Lpatch + (0xa628 - PATCH_BASE)
mov	x21, x0
LFQH_Lloh1206:
adr x1, LFQH_DramaSpacingApplied178R2Key
LFQH_Lloh1207:
nop
mov	x0, x20
bl Lpatch + (0xa628 - PATCH_BASE)
cmp	x21, #0
ccmp	x0, #0, #4, ne
b.eq	LFQH_LBB56_3
mov	x22, x0
LFQH_Lloh1208:
adr x0, LFQH_l_.str.372
LFQH_Lloh1209:
nop
bl Lpatch + (0xa5a4 - PATCH_BASE)
mov	x1, x0
mov	x0, x20
bl Lpatch + (0xa5d4 - PATCH_BASE)
fmov	d8, d0
fmov	d9, d1
fmov	d10, d2
fmov	d11, d3
LFQH_Lloh1210:
adr x0, LFQH_l_.str.432
LFQH_Lloh1211:
nop
bl Lpatch + (0xa5a4 - PATCH_BASE)
mov	x1, x0
mov	x0, x22
bl Lpatch + (0xa5d4 - PATCH_BASE)
fcmp	d8, d0
fccmp	d9, d1, #0, eq
fccmp	d10, d2, #0, eq
fccmp	d11, d3, #0, eq
b.ne	LFQH_LBB56_3
LFQH_Lloh1212:
adr x0, LFQH_l_.str.432
LFQH_Lloh1213:
nop
bl Lpatch + (0xa5a4 - PATCH_BASE)
mov	x1, x0
mov	x0, x21
bl Lpatch + (0xa5d4 - PATCH_BASE)
fmov	d8, d0
fmov	d9, d1
fmov	d10, d2
fmov	d11, d3
LFQH_Lloh1214:
adr x0, LFQH_l_.str.156
LFQH_Lloh1215:
nop
bl Lpatch + (0xa5a4 - PATCH_BASE)
mov	x1, x0
mov	x0, x20
fmov	d0, d8
fmov	d1, d9
fmov	d2, d10
fmov	d3, d11
bl Lpatch + (0xa5d4 - PATCH_BASE)
LFQH_LBB56_3:
LFQH_Lloh1216:
adr x1, LFQH_DramaSpacingStock178R2Key
LFQH_Lloh1217:
nop
mov	x0, x20
mov	x2, #0
mov	w3, #1
bl Lpatch + (0xa634 - PATCH_BASE)
LFQH_Lloh1218:
adr x1, LFQH_DramaSpacingApplied178R2Key
LFQH_Lloh1219:
nop
mov	x0, x20
mov	x2, #0
mov	w3, #1
bl Lpatch + (0xa634 - PATCH_BASE)
LFQH_Lloh1220:
adr x1, LFQH_DramaSpacingTarget178R2Key
LFQH_Lloh1221:
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
LFQH_DramaSpacingApplied178R2Key:
.cfi_startproc
ret
.cfi_endproc
.p2align	2
LFQH_DramaSpacingStock178R2Key:
.cfi_startproc
ret
.cfi_endproc
.p2align	2
LFQH_DramaProgressName178R2:
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
LFQH_Lloh1222:
adr x1, LFQH_l_.str.509
LFQH_Lloh1223:
nop
bl	LFQH_Kind
cbz	w0, LFQH_LBB59_3
LFQH_LBB59_1:
mov	w0, #1
LFQH_LBB59_2:
ldp	x29, x30, [sp, #32]
ldp	x20, x19, [sp, #16]
ldp	x22, x21, [sp], #48
ret
LFQH_LBB59_3:
mov	x0, x19
bl Lpatch + (0xa664 - PATCH_BASE)
LFQH_Lloh1224:
adr x1, LFQH_l_.str.101
LFQH_Lloh1225:
nop
bl	LFQH_Get
mov	x19, x0
LFQH_Lloh1226:
adr x1, LFQH_l_.str.361
LFQH_Lloh1227:
nop
bl	LFQH_Kind
cbz	w0, LFQH_LBB59_2
LFQH_Lloh1228:
adr x0, LFQH_l_.str.478
LFQH_Lloh1229:
nop
bl Lpatch + (0xa5a4 - PATCH_BASE)
mov	x1, x0
mov	x0, x19
bl Lpatch + (0xa5d4 - PATCH_BASE)
mov	x19, x0
LFQH_Lloh1230:
adr x0, LFQH_l_.str.479
LFQH_Lloh1231:
nop
bl Lpatch + (0xa5a4 - PATCH_BASE)
mov	x20, x0
LFQH_Lloh1232:
adr x0, LFQH_l_.str.361
LFQH_Lloh1233:
nop
bl Lpatch + (0xa5b0 - PATCH_BASE)
mov	x21, x0
LFQH_Lloh1234:
adr x0, LFQH_l_.str.387
LFQH_Lloh1235:
nop
bl Lpatch + (0xa5a4 - PATCH_BASE)
mov	x1, x0
LFQH_Lloh1236:
adr x2, LFQH_l_.str.510
LFQH_Lloh1237:
nop
mov	x0, x21
bl Lpatch + (0xa5d4 - PATCH_BASE)
mov	x2, x0
mov	x0, x19
mov	x1, x20
bl Lpatch + (0xa5d4 - PATCH_BASE)
cbnz	w0, LFQH_LBB59_1
LFQH_Lloh1238:
adr x0, LFQH_l_.str.479
LFQH_Lloh1239:
nop
bl Lpatch + (0xa5a4 - PATCH_BASE)
mov	x20, x0
LFQH_Lloh1240:
adr x0, LFQH_l_.str.361
LFQH_Lloh1241:
nop
bl Lpatch + (0xa5b0 - PATCH_BASE)
mov	x21, x0
LFQH_Lloh1242:
adr x0, LFQH_l_.str.387
LFQH_Lloh1243:
nop
bl Lpatch + (0xa5a4 - PATCH_BASE)
mov	x1, x0
LFQH_Lloh1244:
adr x2, LFQH_l_.str.511
LFQH_Lloh1245:
nop
mov	x0, x21
bl Lpatch + (0xa5d4 - PATCH_BASE)
mov	x2, x0
mov	x0, x19
mov	x1, x20
bl Lpatch + (0xa5d4 - PATCH_BASE)
cmp	w0, #0
cset	w0, ne
b	LFQH_LBB59_2
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
fmov	d8, d3
fmov	d9, d2
fmov	d10, d1
fmov	d11, d0
LFQH_Lloh1246:
adr x0, LFQH_l_.str.512
LFQH_Lloh1247:
nop
bl Lpatch + (0xa5b0 - PATCH_BASE)
mov	x19, x0
LFQH_Lloh1248:
adr x0, LFQH_l_.str.513
LFQH_Lloh1249:
nop
bl Lpatch + (0xa5a4 - PATCH_BASE)
mov	x1, x0
mov	x0, x19
fmov	d0, d11
fmov	d1, d10
fmov	d2, d9
fmov	d3, d8
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
LFQH_Lloh1250:
adr x0, LFQH_l_.str.514
LFQH_Lloh1251:
nop
bl Lpatch + (0xa5a4 - PATCH_BASE)
mov	x22, x0
LFQH_Lloh1252:
adr x0, LFQH_l_.str.361
LFQH_Lloh1253:
nop
bl Lpatch + (0xa5b0 - PATCH_BASE)
mov	x23, x0
LFQH_Lloh1254:
adr x0, LFQH_l_.str.387
LFQH_Lloh1255:
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
fmov	d8, d0
LFQH_Lloh1256:
adr x0, LFQH_l_.str.497
LFQH_Lloh1257:
nop
bl Lpatch + (0xa5b0 - PATCH_BASE)
mov	x19, x0
LFQH_Lloh1258:
adr x0, LFQH_l_.str.515
LFQH_Lloh1259:
nop
bl Lpatch + (0xa5a4 - PATCH_BASE)
mov	x1, x0
mov	x0, x19
fmov	d0, d8
ldp	x29, x30, [sp, #32]
ldp	x20, x19, [sp, #16]
ldp	d9, d8, [sp], #48
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
fmov	d8, d3
fmov	d9, d2
fmov	d10, d1
fmov	d11, d0
LFQH_Lloh1260:
adr x0, LFQH_l_.str.116
LFQH_Lloh1261:
nop
bl Lpatch + (0xa5b0 - PATCH_BASE)
mov	x19, x0
LFQH_Lloh1262:
adr x0, LFQH_l_.str.415
LFQH_Lloh1263:
nop
bl Lpatch + (0xa5a4 - PATCH_BASE)
mov	x1, x0
mov	x0, x19
bl Lpatch + (0xa5d4 - PATCH_BASE)
mov	x19, x0
LFQH_Lloh1264:
adr x20, LFQH_l_.str.84
LFQH_Lloh1265:
nop
mov	x0, x20
bl Lpatch + (0xa5a4 - PATCH_BASE)
mov	x23, x0
LFQH_Lloh1266:
adr x21, LFQH_l_.str.497
LFQH_Lloh1267:
nop
mov	x0, x21
bl Lpatch + (0xa5b0 - PATCH_BASE)
mov	x24, x0
LFQH_Lloh1268:
adr x22, LFQH_l_.str.515
LFQH_Lloh1269:
nop
mov	x0, x22
bl Lpatch + (0xa5a4 - PATCH_BASE)
mov	x1, x0
mov	x0, x24
fmov	d0, d11
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
fmov	d0, d10
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
fmov	d0, d9
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
fmov	d0, d8
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
LFQH_DramaSpacingLog178R2Key:
.cfi_startproc
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
LFQH_Lloh1270:
adr x1, LFQH_l_.str.21
LFQH_Lloh1271:
nop
mov	x0, x20
bl	LFQH_Kind
cbz	w0, LFQH_LBB65_5
LFQH_Lloh1272:
adr x1, LFQH_l_.str.105
LFQH_Lloh1273:
nop
mov	x0, x20
bl	LFQH_Responds
cbz	w0, LFQH_LBB65_10
LFQH_Lloh1274:
adr x1, LFQH_l_.str.106
LFQH_Lloh1275:
nop
mov	x0, x20
bl	LFQH_Get
cmp	x0, x19
b.eq	LFQH_LBB65_9
LFQH_Lloh1276:
adr x1, LFQH_l_.str.107
LFQH_Lloh1277:
nop
mov	x0, x20
bl	LFQH_Get
cmp	x0, x19
b.eq	LFQH_LBB65_9
LFQH_Lloh1278:
adr x1, LFQH_l_.str.108
LFQH_Lloh1279:
nop
b	LFQH_LBB65_8
LFQH_LBB65_5:
LFQH_Lloh1280:
adr x1, LFQH_l_.str.109
LFQH_Lloh1281:
nop
mov	x0, x20
bl	LFQH_Kind
cbz	w0, LFQH_LBB65_10
LFQH_Lloh1282:
adr x1, LFQH_l_.str.110
LFQH_Lloh1283:
nop
mov	x0, x20
bl	LFQH_Responds
cbz	w0, LFQH_LBB65_10
LFQH_Lloh1284:
adr x1, LFQH_l_.str.107
LFQH_Lloh1285:
nop
LFQH_LBB65_8:
mov	x0, x20
bl	LFQH_Get
cmp	x0, x19
cset	w0, eq
b	LFQH_LBB65_10
LFQH_LBB65_9:
mov	w0, #1
LFQH_LBB65_10:
ldp	x29, x30, [sp, #16]
ldp	x20, x19, [sp], #32
ret
.cfi_endproc
.p2align	2
LFQH_FQHPageFilterMiniGame:
.cfi_startproc
cbz	x0, LFQH_LBB66_9
stp	x20, x19, [sp, #-32]!
stp	x29, x30, [sp, #16]
add	x29, sp, #16
.cfi_def_cfa w29, 16
.cfi_offset w30, -8
.cfi_offset w29, -16
.cfi_offset w19, -24
.cfi_offset w20, -32
mov	x20, x0
LFQH_Lloh1286:
adr x1, LFQH_l_.str.111
LFQH_Lloh1287:
nop
bl	LFQH_Get
mov	x19, x0
bl	LFQH_MineStandaloneGameRow
cbz	w0, LFQH_LBB66_8
mov	x0, x19
bl Lpatch + (0xa664 - PATCH_BASE)
LFQH_Lloh1288:
adr x1, LFQH_l_.str.112
LFQH_Lloh1289:
nop
LFQH_Lloh1290:
adr x2, LFQH_l_.str.113
LFQH_Lloh1291:
nop
bl	LFQH_ClassABI
cbz	w0, LFQH_LBB66_8
mov	x0, x19
bl Lpatch + (0xa664 - PATCH_BASE)
LFQH_Lloh1292:
adr x1, LFQH_l_.str.114
LFQH_Lloh1293:
nop
LFQH_Lloh1294:
adr x2, LFQH_l_.str.113
LFQH_Lloh1295:
nop
bl	LFQH_ClassABI
cbz	w0, LFQH_LBB66_8
LFQH_Lloh1296:
adr x0, LFQH_l_.str.112
LFQH_Lloh1297:
nop
bl Lpatch + (0xa5a4 - PATCH_BASE)
mov	x1, x0
mov	x0, x19
mov	w2, #1
bl Lpatch + (0xa5d4 - PATCH_BASE)
LFQH_Lloh1298:
adr x0, LFQH_l_.str.114
LFQH_Lloh1299:
nop
bl Lpatch + (0xa5a4 - PATCH_BASE)
mov	x1, x0
mov	x0, x19
mov	w2, #1
bl Lpatch + (0xa5d4 - PATCH_BASE)
LFQH_Lloh1300:
adr x1, LFQH_l_.str.115
LFQH_Lloh1301:
nop
mov	x0, x20
bl	LFQH_Get
mov	x20, x0
LFQH_Lloh1302:
adr x1, LFQH_l_.str.116
LFQH_Lloh1303:
nop
bl	LFQH_Kind
cbz	w0, LFQH_LBB66_7
LFQH_Lloh1304:
adr x1, LFQH_l_.str.117
LFQH_Lloh1305:
nop
mov	x0, x20
bl	LFQH_Responds
cbz	w0, LFQH_LBB66_7
LFQH_Lloh1306:
adr x0, LFQH_l_.str.117
LFQH_Lloh1307:
nop
bl Lpatch + (0xa5a4 - PATCH_BASE)
mov	x1, x0
mov	x0, x20
mov	x2, x19
bl Lpatch + (0xa5d4 - PATCH_BASE)
LFQH_LBB66_7:
LFQH_Lloh1308:
adr x0, LFQH_l_.str.118
LFQH_Lloh1309:
nop
LFQH_Lloh1310:
adr x1, LFQH_l_.str.119
LFQH_Lloh1311:
nop
bl	LFQH_RecordMineGameRemoval
mov	w0, #1
LFQH_LBB66_8:
ldp	x29, x30, [sp, #16]
ldp	x20, x19, [sp], #32
LFQH_LBB66_9:
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
LFQH_Lloh1312:
adr x1, LFQH_l_.str.516
LFQH_Lloh1313:
nop
bl	LFQH_Kind
cbz	w0, LFQH_LBB67_2
LFQH_Lloh1314:
adr x1, LFQH_l_.str.517
LFQH_Lloh1315:
nop
mov	x0, x19
bl	LFQH_Kind
cmp	w0, #0
cset	w0, eq
LFQH_LBB67_2:
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
LFQH_Lloh1316:
adr x0, LFQH_l_.str.88
LFQH_Lloh1317:
nop
bl Lpatch + (0xa5b0 - PATCH_BASE)
mov	x20, x0
LFQH_Lloh1318:
adr x0, LFQH_l_.str.89
LFQH_Lloh1319:
nop
bl Lpatch + (0xa5a4 - PATCH_BASE)
mov	x1, x0
mov	x0, x20
bl Lpatch + (0xa5d4 - PATCH_BASE)
mov	x20, x0
LFQH_Lloh1320:
adr x21, LFQH_l_.str.361
LFQH_Lloh1321:
nop
mov	x0, x21
bl Lpatch + (0xa5b0 - PATCH_BASE)
mov	x24, x0
LFQH_Lloh1322:
adr x22, LFQH_l_.str.387
LFQH_Lloh1323:
nop
mov	x0, x22
bl Lpatch + (0xa5a4 - PATCH_BASE)
mov	x1, x0
LFQH_Lloh1324:
adr x2, LFQH_l_.str.519
LFQH_Lloh1325:
nop
mov	x0, x24
bl Lpatch + (0xa5d4 - PATCH_BASE)
mov	x2, x0
LFQH_Lloh1326:
adr x1, LFQH_l_.str.518
LFQH_Lloh1327:
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
LFQH_Lloh1328:
adr x1, LFQH_l_.str.520
LFQH_Lloh1329:
nop
mov	x0, x20
bl	LFQH_Put
mov	x0, x21
bl Lpatch + (0xa5b0 - PATCH_BASE)
mov	x23, x0
mov	x0, x22
bl Lpatch + (0xa5a4 - PATCH_BASE)
mov	x1, x0
LFQH_Lloh1330:
adr x2, LFQH_l_.str.522
LFQH_Lloh1331:
nop
mov	x0, x23
bl Lpatch + (0xa5d4 - PATCH_BASE)
mov	x2, x0
LFQH_Lloh1332:
adr x1, LFQH_l_.str.521
LFQH_Lloh1333:
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
LFQH_Lloh1334:
adr x1, LFQH_l_.str.523
LFQH_Lloh1335:
nop
mov	x0, x20
bl	LFQH_Put
LFQH_Lloh1336:
adr x0, LFQH_l_.str.524
LFQH_Lloh1337:
nop
mov	x1, x20
ldp	x29, x30, [sp, #48]
ldp	x20, x19, [sp, #32]
ldp	x22, x21, [sp, #16]
ldp	x24, x23, [sp], #64
b Lrecord_named
.cfi_endproc
.p2align	2
LFQH_FQHUpdateTabAppearance:
.cfi_startproc
sub	sp, sp, #160
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
str	x2, [sp]
mov	x20, x1
mov	x22, x0
LFQH_Lloh1338:
adr x1, LFQH_l_.str.120
LFQH_Lloh1339:
nop
bl	LFQH_Get
mov	x21, x0
LFQH_Lloh1340:
adr x1, LFQH_l_.str.121
LFQH_Lloh1341:
nop
bl	LFQH_Kind
cbz	w0, LFQH_LBB69_27
mov	x0, x21
bl Lpatch + (0xa664 - PATCH_BASE)
LFQH_Lloh1342:
adr x1, LFQH_l_.str.122
LFQH_Lloh1343:
nop
LFQH_Lloh1344:
adr x2, LFQH_l_.str.123
LFQH_Lloh1345:
nop
bl	LFQH_ClassABI
cbz	w0, LFQH_LBB69_27
LFQH_Lloh1346:
adr x1, LFQH_l_.str.124
LFQH_Lloh1347:
nop
mov	x0, x21
bl	LFQH_Get
mov	x23, x0
LFQH_Lloh1348:
adr x1, LFQH_l_.str.125
LFQH_Lloh1349:
nop
bl	LFQH_Get
mov	x19, x0
cbnz	x0, LFQH_LBB69_4
LFQH_Lloh1350:
adr x1, LFQH_l_.str.126
LFQH_Lloh1351:
nop
mov	x0, x23
bl	LFQH_Get
LFQH_Lloh1352:
adr x1, LFQH_l_.str.127
LFQH_Lloh1353:
nop
bl	LFQH_Get
LFQH_Lloh1354:
adr x1, LFQH_l_.str.128
LFQH_Lloh1355:
nop
bl	LFQH_Get
mov	x19, x0
LFQH_LBB69_4:
LFQH_Lloh1356:
adr x0, LFQH_l_.str.122
LFQH_Lloh1357:
nop
bl Lpatch + (0xa5a4 - PATCH_BASE)
mov	x1, x0
mov	x0, x21
mov	x2, x19
bl Lpatch + (0xa5d4 - PATCH_BASE)
mov	x21, x0
LFQH_Lloh1358:
adr x1, LFQH_l_.str.129
LFQH_Lloh1359:
nop
mov	x0, x22
bl	LFQH_Get
mov	x19, x0
LFQH_Lloh1360:
adr x1, LFQH_l_.str.130
LFQH_Lloh1361:
nop
mov	x0, x21
bl	LFQH_Responds
cbz	w0, LFQH_LBB69_6
LFQH_Lloh1362:
adr x0, LFQH_l_.str.130
LFQH_Lloh1363:
nop
bl Lpatch + (0xa5a4 - PATCH_BASE)
mov	x1, x0
mov	x0, x21
mov	x2, x19
bl Lpatch + (0xa5d4 - PATCH_BASE)
mov	x21, x0
LFQH_LBB69_6:
stp	xzr, xzr, [sp, #32]
stp	xzr, xzr, [sp, #16]
str	xzr, [sp, #8]
LFQH_Lloh1364:
adr x1, LFQH_l_.str.47
LFQH_Lloh1365:
nop
mov	x0, x21
bl	LFQH_Kind
cbz	w0, LFQH_LBB69_11
LFQH_Lloh1366:
adr x0, LFQH_l_.str.131
LFQH_Lloh1367:
nop
bl Lpatch + (0xa5a4 - PATCH_BASE)
mov	x1, x0
add	x2, sp, #40
add	x3, sp, #32
add	x4, sp, #24
add	x5, sp, #16
mov	x0, x21
bl Lpatch + (0xa5d4 - PATCH_BASE)
cbz	w0, LFQH_LBB69_9
ldp	d1, d0, [sp, #32]
fadd	d1, d1, d1
fadd	d0, d0, d1
ldr	d1, [sp, #24]
fadd	d0, d1, d0
fmov	d1, #0.25000000
fmul	d0, d0, d1
str	d0, [sp, #8]
b	LFQH_LBB69_10
LFQH_LBB69_9:
LFQH_Lloh1368:
adr x0, LFQH_l_.str.132
LFQH_Lloh1369:
nop
bl Lpatch + (0xa5a4 - PATCH_BASE)
mov	x1, x0
add	x2, sp, #8
add	x3, sp, #16
mov	x0, x21
bl Lpatch + (0xa5d4 - PATCH_BASE)
LFQH_LBB69_10:
ldr	d1, [sp, #16]
fmov	d0, #0.50000000
fcmp	d1, d0
b.ge	LFQH_LBB69_12
LFQH_LBB69_11:
mov	x19, #0
b	LFQH_LBB69_13
LFQH_LBB69_12:
ldr	d1, [sp, #8]
fcmp	d1, d0
mov	w8, #2
csinc	x19, x8, xzr, mi
LFQH_LBB69_13:
LFQH_Lloh1370:
adr x0, LFQH_l_.str.133
LFQH_Lloh1371:
nop
bl Lpatch + (0xa5a4 - PATCH_BASE)
mov	x1, x0
mov	x0, x20
bl Lpatch + (0xa5d4 - PATCH_BASE)
cmp	x0, x19
b.eq	LFQH_LBB69_15
LFQH_Lloh1372:
adr x0, LFQH_l_.str.134
LFQH_Lloh1373:
nop
bl Lpatch + (0xa5a4 - PATCH_BASE)
mov	x1, x0
mov	x0, x20
mov	x2, x19
bl Lpatch + (0xa5d4 - PATCH_BASE)
LFQH_Lloh1374:
adr x0, LFQH_l_.str.88
LFQH_Lloh1375:
nop
bl Lpatch + (0xa5b0 - PATCH_BASE)
mov	x20, x0
LFQH_Lloh1376:
adr x0, LFQH_l_.str.89
LFQH_Lloh1377:
nop
bl Lpatch + (0xa5a4 - PATCH_BASE)
mov	x1, x0
mov	x0, x20
bl Lpatch + (0xa5d4 - PATCH_BASE)
mov	x20, x0
ucvtf	d8, x19
LFQH_Lloh1378:
adr x0, LFQH_l_.str.497
LFQH_Lloh1379:
nop
bl Lpatch + (0xa5b0 - PATCH_BASE)
mov	x19, x0
LFQH_Lloh1380:
adr x0, LFQH_l_.str.515
LFQH_Lloh1381:
nop
bl Lpatch + (0xa5a4 - PATCH_BASE)
mov	x1, x0
mov	x0, x19
fmov	d0, d8
bl Lpatch + (0xa5d4 - PATCH_BASE)
mov	x2, x0
LFQH_Lloh1382:
adr x1, LFQH_l_.str.135
LFQH_Lloh1383:
nop
mov	x0, x20
bl	LFQH_Put
LFQH_Lloh1384:
adr x1, LFQH_l_.str.101
LFQH_Lloh1385:
nop
mov	x0, x21
bl	LFQH_Get
mov	x2, x0
LFQH_Lloh1386:
adr x1, LFQH_l_.str.136
LFQH_Lloh1387:
nop
mov	x0, x20
bl	LFQH_Put
LFQH_Lloh1388:
adr x0, LFQH_l_.str.137
LFQH_Lloh1389:
nop
mov	x1, x20
bl Lrecord_named
LFQH_LBB69_15:
LFQH_Lloh1390:
adr x0, LFQH_l_.str.47
LFQH_Lloh1391:
nop
bl Lpatch + (0xa5b0 - PATCH_BASE)
mov	x19, x0
LFQH_Lloh1392:
adr x0, LFQH_l_.str.48
LFQH_Lloh1393:
nop
bl Lpatch + (0xa5a4 - PATCH_BASE)
mov	x1, x0
mov	x0, x19
bl Lpatch + (0xa5d4 - PATCH_BASE)
mov	x20, x0
LFQH_Lloh1394:
adr x0, LFQH_l_.str.34
LFQH_Lloh1395:
nop
bl Lpatch + (0xa5a4 - PATCH_BASE)
mov	x1, x0
ldr	x0, [sp]
bl Lpatch + (0xa5d4 - PATCH_BASE)
cbz	x0, LFQH_LBB69_27
mov	x21, x0
mov	x22, #0
LFQH_Lloh1396:
adr x24, LFQH_l_.str.138
LFQH_Lloh1397:
nop
LFQH_Lloh1398:
adr x25, LFQH_l_.str.139
LFQH_Lloh1399:
nop
LFQH_Lloh1400:
adr x27, LFQH_l_.str.49
LFQH_Lloh1401:
nop
LFQH_Lloh1402:
adr x28, LFQH_l_.str.140
LFQH_Lloh1403:
nop
LFQH_LBB69_17:
LFQH_Lloh1404:
adr x0, LFQH_l_.str.461
LFQH_Lloh1405:
nop
bl Lpatch + (0xa5a4 - PATCH_BASE)
mov	x1, x0
ldr	x0, [sp]
mov	x2, x22
bl Lpatch + (0xa5d4 - PATCH_BASE)
mov	x26, x0
mov	x1, x24
bl	LFQH_Kind
cbz	w0, LFQH_LBB69_26
mov	x19, #0
LFQH_LBB69_19:
mov	x0, x25
bl Lpatch + (0xa5a4 - PATCH_BASE)
mov	x1, x0
mov	x0, x26
mov	x2, x19
bl Lpatch + (0xa5d4 - PATCH_BASE)
cmp	x0, x20
b.eq	LFQH_LBB69_22
mov	x23, x0
mov	x0, x27
bl Lpatch + (0xa5a4 - PATCH_BASE)
mov	x1, x0
mov	x0, x23
mov	x2, x20
bl Lpatch + (0xa5d4 - PATCH_BASE)
cbnz	w0, LFQH_LBB69_22
mov	x0, x28
bl Lpatch + (0xa5a4 - PATCH_BASE)
mov	x1, x0
mov	x0, x26
mov	x2, x20
mov	x3, x19
bl Lpatch + (0xa5d4 - PATCH_BASE)
LFQH_LBB69_22:
add	x19, x19, #1
cmp	x19, #8
b.ne	LFQH_LBB69_19
mov	x0, x26
LFQH_Lloh1406:
adr x1, LFQH_l_.str.141
LFQH_Lloh1407:
nop
bl	LFQH_Get
cmp	x0, x20
b.eq	LFQH_LBB69_26
mov	x19, x0
mov	x0, x27
bl Lpatch + (0xa5a4 - PATCH_BASE)
mov	x1, x0
mov	x0, x19
mov	x2, x20
bl Lpatch + (0xa5d4 - PATCH_BASE)
cbnz	w0, LFQH_LBB69_26
LFQH_Lloh1408:
adr x0, LFQH_l_.str.54
LFQH_Lloh1409:
nop
bl Lpatch + (0xa5a4 - PATCH_BASE)
mov	x1, x0
mov	x0, x26
mov	x2, x20
bl Lpatch + (0xa5d4 - PATCH_BASE)
LFQH_LBB69_26:
add	x22, x22, #1
cmp	x22, x21
b.ne	LFQH_LBB69_17
LFQH_LBB69_27:
ldp	x29, x30, [sp, #144]
ldp	x20, x19, [sp, #128]
ldp	x22, x21, [sp, #112]
ldp	x24, x23, [sp, #96]
ldp	x26, x25, [sp, #80]
ldp	x28, x27, [sp, #64]
ldp	d9, d8, [sp, #48]
add	sp, sp, #160
ret
.cfi_endproc
.p2align	2
LFQH_FQHApplyReaderThemeIsolation:
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
LFQH_Lloh1410:
adr x0, LFQH_l_.str.142
LFQH_Lloh1411:
nop
bl Lpatch + (0xa5b0 - PATCH_BASE)
mov	x19, x0
LFQH_Lloh1412:
adr x0, LFQH_l_.str.143
LFQH_Lloh1413:
nop
bl Lpatch + (0xa5b0 - PATCH_BASE)
mov	x20, x0
mov	w0, #11
bl	LFQH_PageOptionEnabled
cbz	w0, LFQH_LBB70_7
LFQH_Lloh1414:
adr x0, LFQH_l_.str.144
LFQH_Lloh1415:
nop
bl Lpatch + (0xa5b0 - PATCH_BASE)
mov	x21, x0
LFQH_Lloh1416:
adr x0, LFQH_l_.str.145
LFQH_Lloh1417:
nop
bl Lpatch + (0xa5a4 - PATCH_BASE)
mov	x1, x0
mov	x0, x21
bl Lpatch + (0xa5f8 - PATCH_BASE)
cbz	x0, LFQH_LBB70_7
LFQH_Lloh1418:
adr x0, LFQH_l_.str.143
LFQH_Lloh1419:
nop
bl Lpatch + (0xa5b0 - PATCH_BASE)
LFQH_Lloh1420:
adr x1, LFQH_l_.str.146
LFQH_Lloh1421:
nop
LFQH_Lloh1422:
adr x2, LFQH_l_.str.147
LFQH_Lloh1423:
nop
bl	LFQH_ClassABI
cbz	w0, LFQH_LBB70_7
LFQH_Lloh1424:
adr x0, LFQH_l_.str.142
LFQH_Lloh1425:
nop
bl Lpatch + (0xa5b0 - PATCH_BASE)
LFQH_Lloh1426:
adr x1, LFQH_l_.str.148
LFQH_Lloh1427:
nop
LFQH_Lloh1428:
adr x2, LFQH_l_.str.149
LFQH_Lloh1429:
nop
bl	LFQH_ClassABI
cbz	w0, LFQH_LBB70_7
LFQH_Lloh1430:
adr x0, LFQH_l_.str.142
LFQH_Lloh1431:
nop
bl Lpatch + (0xa5b0 - PATCH_BASE)
LFQH_Lloh1432:
adr x1, LFQH_l_.str.150
LFQH_Lloh1433:
nop
LFQH_Lloh1434:
adr x2, LFQH_l_.str.113
LFQH_Lloh1435:
nop
bl	LFQH_ClassABI
cbz	w0, LFQH_LBB70_7
LFQH_Lloh1436:
adr x1, LFQH_l_.str.151
LFQH_Lloh1437:
nop
mov	x0, x20
bl	LFQH_Get
mov	x20, x0
LFQH_Lloh1438:
adr x0, LFQH_l_.str.146
LFQH_Lloh1439:
nop
bl Lpatch + (0xa5a4 - PATCH_BASE)
mov	x1, x0
mov	x0, x20
mov	x2, x19
bl Lpatch + (0xa5d4 - PATCH_BASE)
mov	x19, x0
LFQH_Lloh1440:
adr x1, LFQH_l_.str.142
LFQH_Lloh1441:
nop
bl	LFQH_Kind
cbz	w0, LFQH_LBB70_7
LFQH_Lloh1442:
adr x0, LFQH_l_.str.148
LFQH_Lloh1443:
nop
bl Lpatch + (0xa5a4 - PATCH_BASE)
mov	x1, x0
mov	x0, x19
bl Lpatch + (0xa5d4 - PATCH_BASE)
cbz	w0, LFQH_LBB70_8
LFQH_LBB70_7:
ldp	x29, x30, [sp, #32]
ldp	x20, x19, [sp, #16]
ldp	x22, x21, [sp], #48
ret
LFQH_LBB70_8:
LFQH_Lloh1444:
adr x0, LFQH_l_.str.150
LFQH_Lloh1445:
nop
bl Lpatch + (0xa5a4 - PATCH_BASE)
mov	x1, x0
mov	x0, x19
mov	w2, #1
ldp	x29, x30, [sp, #32]
ldp	x20, x19, [sp, #16]
ldp	x22, x21, [sp], #48
b Lpatch + (0xa5d4 - PATCH_BASE)
.cfi_endproc
.p2align	2
LFQH_FQHInstallOptionsToggles:
.cfi_startproc
sub	sp, sp, #176
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
mov	x22, x0
LFQH_Lloh1446:
adr x1, LFQH_l_.str.152
LFQH_Lloh1447:
nop
bl	LFQH_Get
cbz	x0, LFQH_LBB71_2
mov	x19, x0
LFQH_Lloh1448:
adr x1, LFQH_l_.str.153
LFQH_Lloh1449:
nop
bl	LFQH_Get
cbz	x0, LFQH_LBB71_3
LFQH_LBB71_2:
ldp	x29, x30, [sp, #160]
ldp	x20, x19, [sp, #144]
ldp	x22, x21, [sp, #128]
ldp	x24, x23, [sp, #112]
ldp	x26, x25, [sp, #96]
ldp	x28, x27, [sp, #80]
ldp	d9, d8, [sp, #64]
ldp	d11, d10, [sp, #48]
ldp	d13, d12, [sp, #32]
add	sp, sp, #176
ret
LFQH_LBB71_3:
bl	LFQH_ToggleObserver
cbz	x0, LFQH_LBB71_2
mov	x20, x0
LFQH_Lloh1450:
adr x0, LFQH_l_.str.154
LFQH_Lloh1451:
nop
bl Lpatch + (0xa5a4 - PATCH_BASE)
mov	x1, x0
mov	x0, x20
bl Lpatch + (0xa5d4 - PATCH_BASE)
mov	x20, x0
LFQH_Lloh1452:
adr x0, LFQH_l_.str.155
LFQH_Lloh1453:
nop
bl Lpatch + (0xa5a4 - PATCH_BASE)
mov	x1, x0
mov	x0, x20
bl Lpatch + (0xa5d4 - PATCH_BASE)
str	x0, [sp, #24]
cbz	x0, LFQH_LBB71_2
LFQH_Lloh1454:
adr x0, LFQH_l_.str.23
LFQH_Lloh1455:
nop
bl Lpatch + (0xa5b0 - PATCH_BASE)
mov	x20, x0
LFQH_Lloh1456:
adr x0, LFQH_l_.str.154
LFQH_Lloh1457:
nop
bl Lpatch + (0xa5a4 - PATCH_BASE)
mov	x1, x0
mov	x0, x20
bl Lpatch + (0xa5d4 - PATCH_BASE)
mov	x20, x0
LFQH_Lloh1458:
adr x0, LFQH_l_.str.155
LFQH_Lloh1459:
nop
bl Lpatch + (0xa5a4 - PATCH_BASE)
mov	x1, x0
mov	x0, x20
bl Lpatch + (0xa5d4 - PATCH_BASE)
cbz	x0, LFQH_LBB71_39
mov	x21, x0
str	x22, [sp, #8]
LFQH_Lloh1460:
adr x0, LFQH_l_.str.24
LFQH_Lloh1461:
nop
bl Lpatch + (0xa5a4 - PATCH_BASE)
mov	x1, x0
str	x19, [sp, #16]
mov	x0, x19
bl Lpatch + (0xa5d4 - PATCH_BASE)
fcmp	d2, #0.0
mov	x8, #4644337115725824000
fmov	d0, x8
fcsel	d8, d2, d0, gt
LFQH_Lloh1462:
adr x0, LFQH_l_.str.156
LFQH_Lloh1463:
nop
bl Lpatch + (0xa5a4 - PATCH_BASE)
mov	x1, x0
mov	x8, #4647714815446351872
fmov	d3, x8
fmov	d0, xzr
fmov	d1, xzr
mov	x0, x21
fmov	d2, d8
bl Lpatch + (0xa5d4 - PATCH_BASE)
LFQH_Lloh1464:
adr x0, LFQH_l_.str.157
LFQH_Lloh1465:
nop
bl Lpatch + (0xa5a4 - PATCH_BASE)
mov	x20, x0
LFQH_Lloh1466:
adr x0, LFQH_l_.str.47
LFQH_Lloh1467:
nop
bl Lpatch + (0xa5b0 - PATCH_BASE)
mov	x23, x0
LFQH_Lloh1468:
adr x0, LFQH_l_.str.158
LFQH_Lloh1469:
nop
bl Lpatch + (0xa5a4 - PATCH_BASE)
mov	x1, x0
mov	x0, x23
bl Lpatch + (0xa5d4 - PATCH_BASE)
mov	x2, x0
mov	x0, x21
mov	x1, x20
bl Lpatch + (0xa5d4 - PATCH_BASE)
mov	w26, #1
mov	w19, #8
LFQH_Lloh1470:
adr x25, LFQH_l_.str.154
LFQH_Lloh1471:
nop
LFQH_Lloh1472:
adr x23, LFQH_l_.str.155
LFQH_Lloh1473:
nop
fmov	d12, #2.00000000
LFQH_LBB71_7:
cmp	x26, #5
b.gt	LFQH_LBB71_13
cmp	x26, #2
b.le	LFQH_LBB71_18
cmp	x26, #3
b.eq	LFQH_LBB71_25
cmp	x26, #4
b.eq	LFQH_LBB71_27
cmp	x26, #5
b.ne	LFQH_LBB71_29
LFQH_Lloh1474:
adr x20, LFQH_l_.str.615
LFQH_Lloh1475:
nop
b	LFQH_LBB71_30
LFQH_LBB71_13:
cmp	x26, #8
b.le	LFQH_LBB71_21
cmp	x26, #9
b.eq	LFQH_LBB71_26
cmp	x26, #10
b.eq	LFQH_LBB71_28
cmp	x26, #11
b.ne	LFQH_LBB71_29
LFQH_Lloh1476:
adr x20, LFQH_l_.str.620
LFQH_Lloh1477:
nop
b	LFQH_LBB71_30
LFQH_LBB71_18:
LFQH_Lloh1478:
adr x20, LFQH_l_.str.611
LFQH_Lloh1479:
nop
cmp	x26, #1
b.eq	LFQH_LBB71_30
cmp	x26, #2
b.ne	LFQH_LBB71_29
LFQH_Lloh1480:
adr x20, LFQH_l_.str.612
LFQH_Lloh1481:
nop
b	LFQH_LBB71_30
LFQH_LBB71_21:
cmp	x26, #6
b.eq	LFQH_LBB71_24
cmp	x26, #7
b.ne	LFQH_LBB71_29
LFQH_Lloh1482:
adr x20, LFQH_l_.str.617
LFQH_Lloh1483:
nop
b	LFQH_LBB71_30
LFQH_LBB71_24:
LFQH_Lloh1484:
adr x20, LFQH_l_.str.616
LFQH_Lloh1485:
nop
b	LFQH_LBB71_30
LFQH_LBB71_25:
LFQH_Lloh1486:
adr x20, LFQH_l_.str.613
LFQH_Lloh1487:
nop
b	LFQH_LBB71_30
LFQH_LBB71_26:
LFQH_Lloh1488:
adr x20, LFQH_l_.str.618
LFQH_Lloh1489:
nop
b	LFQH_LBB71_30
LFQH_LBB71_27:
LFQH_Lloh1490:
adr x20, LFQH_l_.str.614
LFQH_Lloh1491:
nop
b	LFQH_LBB71_30
LFQH_LBB71_28:
LFQH_Lloh1492:
adr x20, LFQH_l_.str.619
LFQH_Lloh1493:
nop
b	LFQH_LBB71_30
LFQH_LBB71_29:
LFQH_Lloh1494:
adr x20, LFQH_l_.str.621
LFQH_Lloh1495:
nop
LFQH_LBB71_30:
LFQH_Lloh1496:
adr x0, LFQH_l_.str.361
LFQH_Lloh1497:
nop
bl Lpatch + (0xa5b0 - PATCH_BASE)
mov	x24, x0
LFQH_Lloh1498:
adr x0, LFQH_l_.str.387
LFQH_Lloh1499:
nop
bl Lpatch + (0xa5a4 - PATCH_BASE)
mov	x1, x0
mov	x0, x24
mov	x2, x20
bl Lpatch + (0xa5d4 - PATCH_BASE)
mov	x20, x0
mov	x0, x26
bl	LFQH_PageOptionEnabled
mov	x24, x0
LFQH_Lloh1500:
adr x0, LFQH_l_.str.24
LFQH_Lloh1501:
nop
bl Lpatch + (0xa5a4 - PATCH_BASE)
mov	x1, x0
mov	x0, x21
bl Lpatch + (0xa5d4 - PATCH_BASE)
fmov	d9, d2
LFQH_Lloh1502:
adr x0, LFQH_l_.str.36
LFQH_Lloh1503:
nop
bl Lpatch + (0xa5b0 - PATCH_BASE)
mov	x27, x0
mov	x0, x25
bl Lpatch + (0xa5a4 - PATCH_BASE)
mov	x1, x0
mov	x0, x27
bl Lpatch + (0xa5d4 - PATCH_BASE)
mov	x27, x0
mov	x0, x23
bl Lpatch + (0xa5a4 - PATCH_BASE)
mov	x1, x0
mov	x0, x27
bl Lpatch + (0xa5d4 - PATCH_BASE)
cbz	x0, LFQH_LBB71_33
mov	x27, x0
scvtf	d10, x19
mov	x8, #-4586916220476850176
fmov	d0, x8
fadd	d11, d9, d0
LFQH_Lloh1504:
adr x0, LFQH_l_.str.156
LFQH_Lloh1505:
nop
bl Lpatch + (0xa5a4 - PATCH_BASE)
mov	x1, x0
fmov	d0, #16.00000000
fmov	d3, #30.00000000
mov	x0, x27
fmov	d1, d10
fmov	d2, d11
bl Lpatch + (0xa5d4 - PATCH_BASE)
LFQH_Lloh1506:
adr x0, LFQH_l_.str.159
LFQH_Lloh1507:
nop
bl Lpatch + (0xa5a4 - PATCH_BASE)
mov	x1, x0
mov	x0, x27
mov	x2, x20
bl Lpatch + (0xa5d4 - PATCH_BASE)
LFQH_Lloh1508:
adr x0, LFQH_l_.str.162
LFQH_Lloh1509:
nop
bl Lpatch + (0xa5a4 - PATCH_BASE)
mov	x28, x0
LFQH_Lloh1510:
adr x0, LFQH_l_.str.163
LFQH_Lloh1511:
nop
bl Lpatch + (0xa5b0 - PATCH_BASE)
mov	x22, x0
LFQH_Lloh1512:
adr x0, LFQH_l_.str.164
LFQH_Lloh1513:
nop
bl Lpatch + (0xa5a4 - PATCH_BASE)
mov	x1, x0
fmov	d0, #15.00000000
mov	x0, x22
bl Lpatch + (0xa5d4 - PATCH_BASE)
mov	x2, x0
mov	x0, x27
mov	x1, x28
bl Lpatch + (0xa5d4 - PATCH_BASE)
LFQH_Lloh1514:
adr x0, LFQH_l_.str.45
LFQH_Lloh1515:
nop
bl Lpatch + (0xa5a4 - PATCH_BASE)
mov	x22, x0
LFQH_Lloh1516:
adr x0, LFQH_l_.str.47
LFQH_Lloh1517:
nop
bl Lpatch + (0xa5b0 - PATCH_BASE)
mov	x28, x0
LFQH_Lloh1518:
adr x0, LFQH_l_.str.48
LFQH_Lloh1519:
nop
bl Lpatch + (0xa5a4 - PATCH_BASE)
mov	x1, x0
mov	x0, x28
bl Lpatch + (0xa5d4 - PATCH_BASE)
mov	x2, x0
mov	x0, x27
mov	x1, x22
bl Lpatch + (0xa5d4 - PATCH_BASE)
LFQH_Lloh1520:
adr x0, LFQH_l_.str.166
LFQH_Lloh1521:
nop
bl Lpatch + (0xa5a4 - PATCH_BASE)
mov	x1, x0
mov	x0, x27
mov	w2, #2
bl Lpatch + (0xa5d4 - PATCH_BASE)
LFQH_Lloh1522:
adr x0, LFQH_l_.str.167
LFQH_Lloh1523:
nop
bl Lpatch + (0xa5a4 - PATCH_BASE)
mov	x1, x0
mov	x0, x21
mov	x2, x27
bl Lpatch + (0xa5d4 - PATCH_BASE)
LFQH_Lloh1524:
adr x0, LFQH_l_.str.56
LFQH_Lloh1525:
nop
bl Lpatch + (0xa5a4 - PATCH_BASE)
mov	x1, x0
mov	x0, x27
bl Lpatch + (0xa5d4 - PATCH_BASE)
LFQH_Lloh1526:
adr x0, LFQH_l_.str.608
LFQH_Lloh1527:
nop
bl Lpatch + (0xa5b0 - PATCH_BASE)
mov	x22, x0
mov	x0, x25
bl Lpatch + (0xa5a4 - PATCH_BASE)
mov	x1, x0
mov	x0, x22
bl Lpatch + (0xa5d4 - PATCH_BASE)
mov	x22, x0
mov	x0, x23
bl Lpatch + (0xa5a4 - PATCH_BASE)
mov	x1, x0
mov	x0, x22
bl Lpatch + (0xa5d4 - PATCH_BASE)
cbz	x0, LFQH_LBB71_33
mov	x27, x0
mov	x8, #-4588042120383692800
fmov	d0, x8
fadd	d9, d9, d0
fadd	d10, d10, d12
LFQH_Lloh1528:
adr x0, LFQH_l_.str.156
LFQH_Lloh1529:
nop
bl Lpatch + (0xa5a4 - PATCH_BASE)
mov	x1, x0
mov	x8, #4634204016564240384
fmov	d2, x8
fmov	d3, #31.00000000
mov	x0, x27
fmov	d0, d9
fmov	d1, d10
bl Lpatch + (0xa5d4 - PATCH_BASE)
LFQH_Lloh1530:
adr x0, LFQH_l_.str.609
LFQH_Lloh1531:
nop
bl Lpatch + (0xa5a4 - PATCH_BASE)
mov	x1, x0
mov	x0, x27
mov	x2, x26
bl Lpatch + (0xa5d4 - PATCH_BASE)
LFQH_Lloh1532:
adr x0, LFQH_l_.str.166
LFQH_Lloh1533:
nop
bl Lpatch + (0xa5a4 - PATCH_BASE)
mov	x1, x0
mov	x0, x27
mov	w2, #17
bl Lpatch + (0xa5d4 - PATCH_BASE)
LFQH_Lloh1534:
adr x0, LFQH_l_.str.385
LFQH_Lloh1535:
nop
bl Lpatch + (0xa5a4 - PATCH_BASE)
mov	x1, x0
mov	x0, x27
mov	x2, x24
mov	w3, #0
bl Lpatch + (0xa5d4 - PATCH_BASE)
LFQH_Lloh1536:
adr x0, LFQH_l_.str.438
LFQH_Lloh1537:
nop
bl Lpatch + (0xa5a4 - PATCH_BASE)
mov	x22, x0
LFQH_Lloh1538:
adr x0, LFQH_l_.str.557
LFQH_Lloh1539:
nop
bl Lpatch + (0xa5a4 - PATCH_BASE)
mov	x3, x0
mov	x0, x27
mov	x1, x22
ldr	x2, [sp, #24]
mov	w4, #4096
bl Lpatch + (0xa5d4 - PATCH_BASE)
LFQH_Lloh1540:
adr x0, LFQH_l_.str.610
LFQH_Lloh1541:
nop
bl Lpatch + (0xa5a4 - PATCH_BASE)
mov	x1, x0
mov	x0, x27
mov	x2, x20
bl Lpatch + (0xa5d4 - PATCH_BASE)
LFQH_Lloh1542:
adr x0, LFQH_l_.str.167
LFQH_Lloh1543:
nop
bl Lpatch + (0xa5a4 - PATCH_BASE)
mov	x1, x0
mov	x0, x21
mov	x2, x27
bl Lpatch + (0xa5d4 - PATCH_BASE)
LFQH_Lloh1544:
adr x0, LFQH_l_.str.56
LFQH_Lloh1545:
nop
bl Lpatch + (0xa5a4 - PATCH_BASE)
mov	x1, x0
mov	x0, x27
bl Lpatch + (0xa5d4 - PATCH_BASE)
LFQH_LBB71_33:
add	x26, x26, #1
add	x19, x19, #42
cmp	x19, #470
b.ne	LFQH_LBB71_7
LFQH_Lloh1546:
adr x0, LFQH_l_.str.36
LFQH_Lloh1547:
nop
bl Lpatch + (0xa5b0 - PATCH_BASE)
mov	x20, x0
LFQH_Lloh1548:
adr x0, LFQH_l_.str.154
LFQH_Lloh1549:
nop
bl Lpatch + (0xa5a4 - PATCH_BASE)
mov	x1, x0
mov	x0, x20
bl Lpatch + (0xa5d4 - PATCH_BASE)
mov	x20, x0
LFQH_Lloh1550:
adr x0, LFQH_l_.str.155
LFQH_Lloh1551:
nop
bl Lpatch + (0xa5a4 - PATCH_BASE)
mov	x1, x0
mov	x0, x20
bl Lpatch + (0xa5d4 - PATCH_BASE)
mov	x20, x0
mov	x8, #-4593671619917905920
fmov	d0, x8
fadd	d8, d8, d0
LFQH_Lloh1552:
adr x0, LFQH_l_.str.156
LFQH_Lloh1553:
nop
bl Lpatch + (0xa5a4 - PATCH_BASE)
mov	x1, x0
mov	x8, #4646870390516219904
fmov	d1, x8
mov	x8, #4630826316843712512
fmov	d3, x8
fmov	d0, #16.00000000
mov	x0, x20
fmov	d2, d8
bl Lpatch + (0xa5d4 - PATCH_BASE)
LFQH_Lloh1554:
adr x0, LFQH_l_.str.159
LFQH_Lloh1555:
nop
bl Lpatch + (0xa5a4 - PATCH_BASE)
mov	x23, x0
LFQH_Lloh1556:
adr x0, LFQH_l_.str.361
LFQH_Lloh1557:
nop
bl Lpatch + (0xa5b0 - PATCH_BASE)
mov	x24, x0
LFQH_Lloh1558:
adr x0, LFQH_l_.str.387
LFQH_Lloh1559:
nop
bl Lpatch + (0xa5a4 - PATCH_BASE)
mov	x1, x0
LFQH_Lloh1560:
adr x2, LFQH_l_.str.160
LFQH_Lloh1561:
nop
mov	x0, x24
bl Lpatch + (0xa5d4 - PATCH_BASE)
mov	x2, x0
mov	x0, x20
mov	x1, x23
bl Lpatch + (0xa5d4 - PATCH_BASE)
LFQH_Lloh1562:
adr x0, LFQH_l_.str.161
LFQH_Lloh1563:
nop
bl Lpatch + (0xa5a4 - PATCH_BASE)
mov	x1, x0
mov	x0, x20
mov	w2, #2
bl Lpatch + (0xa5d4 - PATCH_BASE)
LFQH_Lloh1564:
adr x0, LFQH_l_.str.162
LFQH_Lloh1565:
nop
bl Lpatch + (0xa5a4 - PATCH_BASE)
mov	x23, x0
LFQH_Lloh1566:
adr x0, LFQH_l_.str.163
LFQH_Lloh1567:
nop
bl Lpatch + (0xa5b0 - PATCH_BASE)
mov	x24, x0
LFQH_Lloh1568:
adr x0, LFQH_l_.str.164
LFQH_Lloh1569:
nop
bl Lpatch + (0xa5a4 - PATCH_BASE)
mov	x1, x0
fmov	d0, #12.00000000
mov	x0, x24
bl Lpatch + (0xa5d4 - PATCH_BASE)
mov	x2, x0
mov	x0, x20
mov	x1, x23
bl Lpatch + (0xa5d4 - PATCH_BASE)
LFQH_Lloh1570:
adr x0, LFQH_l_.str.45
LFQH_Lloh1571:
nop
bl Lpatch + (0xa5a4 - PATCH_BASE)
mov	x23, x0
LFQH_Lloh1572:
adr x0, LFQH_l_.str.47
LFQH_Lloh1573:
nop
bl Lpatch + (0xa5b0 - PATCH_BASE)
mov	x24, x0
LFQH_Lloh1574:
adr x0, LFQH_l_.str.165
LFQH_Lloh1575:
nop
bl Lpatch + (0xa5a4 - PATCH_BASE)
mov	x1, x0
mov	x0, x24
bl Lpatch + (0xa5d4 - PATCH_BASE)
mov	x2, x0
mov	x0, x20
mov	x1, x23
bl Lpatch + (0xa5d4 - PATCH_BASE)
LFQH_Lloh1576:
adr x0, LFQH_l_.str.166
LFQH_Lloh1577:
nop
bl Lpatch + (0xa5a4 - PATCH_BASE)
mov	x1, x0
mov	x0, x20
mov	w2, #2
bl Lpatch + (0xa5d4 - PATCH_BASE)
LFQH_Lloh1578:
adr x0, LFQH_l_.str.167
LFQH_Lloh1579:
nop
bl Lpatch + (0xa5a4 - PATCH_BASE)
mov	x1, x0
mov	x0, x21
mov	x2, x20
bl Lpatch + (0xa5d4 - PATCH_BASE)
LFQH_Lloh1580:
adr x0, LFQH_l_.str.56
LFQH_Lloh1581:
nop
bl Lpatch + (0xa5a4 - PATCH_BASE)
mov	x1, x0
mov	x0, x20
bl Lpatch + (0xa5d4 - PATCH_BASE)
LFQH_Lloh1582:
adr x0, LFQH_l_.str.935
LFQH_Lloh1583:
nop
bl Lpatch + (0xa5b0 - PATCH_BASE)
mov	x20, x0
ldr	x19, [sp, #16]
cbnz	x0, LFQH_LBB71_37
LFQH_Lloh1584:
adr x0, LFQH_l_.str.556
LFQH_Lloh1585:
nop
bl Lpatch + (0xa5b0 - PATCH_BASE)
LFQH_Lloh1586:
adr x1, LFQH_l_.str.935
LFQH_Lloh1587:
nop
mov	x2, #0
bl Lpatch + (0xa61c - PATCH_BASE)
cbz	x0, LFQH_LBB71_38
mov	x20, x0
LFQH_Lloh1588:
adr x0, LFQH_l_.str.936
LFQH_Lloh1589:
nop
bl Lpatch + (0xa5a4 - PATCH_BASE)
mov	x1, x0
LFQH_Lloh1590:
adr x2, LFQH_BottomOpenSettings178
LFQH_Lloh1591:
nop
LFQH_Lloh1592:
adr x3, LFQH_l_.str.186
LFQH_Lloh1593:
nop
mov	x0, x20
bl Lpatch + (0xa58c - PATCH_BASE)
mov	x0, x20
bl Lpatch + (0xa610 - PATCH_BASE)
LFQH_LBB71_37:
LFQH_Lloh1594:
adr x0, LFQH_l_.str.421
LFQH_Lloh1595:
nop
bl Lpatch + (0xa5a4 - PATCH_BASE)
mov	x1, x0
mov	x0, x20
bl Lpatch + (0xa5d4 - PATCH_BASE)
mov	x20, x0
LFQH_Lloh1596:
adr x23, LFQH_BottomOptionsOwner178Key
LFQH_Lloh1597:
nop
mov	x1, x23
ldr	x2, [sp, #8]
bl	LFQH_BottomSetWeak178
LFQH_Lloh1598:
adr x0, LFQH_l_.str.138
LFQH_Lloh1599:
nop
bl Lpatch + (0xa5b0 - PATCH_BASE)
mov	x22, x0
LFQH_Lloh1600:
adr x0, LFQH_l_.str.937
LFQH_Lloh1601:
nop
bl Lpatch + (0xa5a4 - PATCH_BASE)
mov	x1, x0
mov	x0, x22
mov	w2, #1
bl Lpatch + (0xa5d4 - PATCH_BASE)
mov	x22, x0
LFQH_Lloh1602:
adr x0, LFQH_l_.str.372
LFQH_Lloh1603:
nop
bl Lpatch + (0xa5a4 - PATCH_BASE)
mov	x1, x0
mov	x0, x21
bl Lpatch + (0xa5d4 - PATCH_BASE)
fmov	d8, d0
fmov	d9, d1
fmov	d10, d2
fmov	d11, d3
fmov	d0, #4.00000000
fadd	d12, d3, d0
mov	x8, #-4593671619917905920
fmov	d0, x8
fadd	d13, d2, d0
LFQH_Lloh1604:
adr x24, LFQH_l_.str.156
LFQH_Lloh1605:
nop
mov	x0, x24
bl Lpatch + (0xa5a4 - PATCH_BASE)
mov	x1, x0
mov	x8, #4631952216750555136
fmov	d3, x8
fmov	d0, #16.00000000
mov	x0, x22
fmov	d1, d12
fmov	d2, d13
bl Lpatch + (0xa5d4 - PATCH_BASE)
LFQH_Lloh1606:
adr x0, LFQH_l_.str.166
LFQH_Lloh1607:
nop
bl Lpatch + (0xa5a4 - PATCH_BASE)
mov	x1, x0
mov	x0, x22
mov	w2, #2
bl Lpatch + (0xa5d4 - PATCH_BASE)
LFQH_Lloh1608:
adr x0, LFQH_l_.str.886
LFQH_Lloh1609:
nop
bl Lpatch + (0xa5a4 - PATCH_BASE)
mov	x25, x0
LFQH_Lloh1610:
adr x26, LFQH_l_.str.361
LFQH_Lloh1611:
nop
mov	x0, x26
bl Lpatch + (0xa5b0 - PATCH_BASE)
mov	x27, x0
LFQH_Lloh1612:
adr x28, LFQH_l_.str.387
LFQH_Lloh1613:
nop
mov	x0, x28
bl Lpatch + (0xa5a4 - PATCH_BASE)
mov	x1, x0
LFQH_Lloh1614:
adr x2, LFQH_l_.str.938
LFQH_Lloh1615:
nop
mov	x0, x27
bl Lpatch + (0xa5d4 - PATCH_BASE)
mov	x2, x0
mov	x0, x22
mov	x1, x25
mov	x3, #0
bl Lpatch + (0xa5d4 - PATCH_BASE)
LFQH_Lloh1616:
adr x0, LFQH_l_.str.610
LFQH_Lloh1617:
nop
bl Lpatch + (0xa5a4 - PATCH_BASE)
mov	x25, x0
mov	x0, x26
bl Lpatch + (0xa5b0 - PATCH_BASE)
mov	x26, x0
mov	x0, x28
bl Lpatch + (0xa5a4 - PATCH_BASE)
mov	x1, x0
LFQH_Lloh1618:
adr x2, LFQH_l_.str.939
LFQH_Lloh1619:
nop
mov	x0, x26
bl Lpatch + (0xa5d4 - PATCH_BASE)
mov	x2, x0
mov	x0, x22
mov	x1, x25
bl Lpatch + (0xa5d4 - PATCH_BASE)
LFQH_Lloh1620:
adr x0, LFQH_l_.str.438
LFQH_Lloh1621:
nop
bl Lpatch + (0xa5a4 - PATCH_BASE)
mov	x25, x0
LFQH_Lloh1622:
adr x0, LFQH_l_.str.936
LFQH_Lloh1623:
nop
bl Lpatch + (0xa5a4 - PATCH_BASE)
mov	x3, x0
mov	x0, x22
mov	x1, x25
mov	x2, x20
mov	w4, #64
bl Lpatch + (0xa5d4 - PATCH_BASE)
mov	x0, x22
mov	x1, x23
mov	x2, x20
mov	w3, #1
bl Lpatch + (0xa634 - PATCH_BASE)
LFQH_Lloh1624:
adr x0, LFQH_l_.str.167
LFQH_Lloh1625:
nop
bl Lpatch + (0xa5a4 - PATCH_BASE)
mov	x1, x0
mov	x0, x21
mov	x2, x22
bl Lpatch + (0xa5d4 - PATCH_BASE)
LFQH_Lloh1626:
adr x0, LFQH_l_.str.56
LFQH_Lloh1627:
nop
bl Lpatch + (0xa5a4 - PATCH_BASE)
mov	x1, x0
mov	x0, x20
bl Lpatch + (0xa5d4 - PATCH_BASE)
mov	x8, #4633641066610819072
fmov	d0, x8
fadd	d11, d11, d0
mov	x0, x24
bl Lpatch + (0xa5a4 - PATCH_BASE)
mov	x1, x0
mov	x0, x21
fmov	d0, d8
fmov	d1, d9
fmov	d2, d10
fmov	d3, d11
bl Lpatch + (0xa5d4 - PATCH_BASE)
LFQH_LBB71_38:
LFQH_Lloh1628:
adr x1, LFQH_ToggleObserverKey
LFQH_Lloh1629:
nop
mov	x0, x21
ldr	x2, [sp, #24]
mov	w3, #1
bl Lpatch + (0xa634 - PATCH_BASE)
LFQH_Lloh1630:
adr x0, LFQH_l_.str.168
LFQH_Lloh1631:
nop
bl Lpatch + (0xa5a4 - PATCH_BASE)
mov	x1, x0
mov	x0, x19
mov	x2, x21
bl Lpatch + (0xa5d4 - PATCH_BASE)
LFQH_Lloh1632:
adr x0, LFQH_l_.str.56
LFQH_Lloh1633:
nop
bl Lpatch + (0xa5a4 - PATCH_BASE)
mov	x1, x0
mov	x0, x21
bl Lpatch + (0xa5d4 - PATCH_BASE)
LFQH_LBB71_39:
LFQH_Lloh1634:
adr x0, LFQH_l_.str.56
LFQH_Lloh1635:
nop
bl Lpatch + (0xa5a4 - PATCH_BASE)
mov	x1, x0
ldr	x0, [sp, #24]
ldp	x29, x30, [sp, #160]
ldp	x20, x19, [sp, #144]
ldp	x22, x21, [sp, #128]
ldp	x24, x23, [sp, #112]
ldp	x26, x25, [sp, #96]
ldp	x28, x27, [sp, #80]
ldp	d9, d8, [sp, #64]
ldp	d11, d10, [sp, #48]
ldp	d13, d12, [sp, #32]
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
LFQH_Lloh1636:
adr x0, LFQH_l_.str.555
LFQH_Lloh1637:
nop
bl Lpatch + (0xa5b0 - PATCH_BASE)
mov	x19, x0
cbnz	x0, LFQH_LBB72_3
LFQH_Lloh1638:
adr x0, LFQH_l_.str.556
LFQH_Lloh1639:
nop
bl Lpatch + (0xa5b0 - PATCH_BASE)
LFQH_Lloh1640:
adr x1, LFQH_l_.str.555
LFQH_Lloh1641:
nop
mov	x2, #0
bl Lpatch + (0xa61c - PATCH_BASE)
mov	x19, x0
cbz	x0, LFQH_LBB72_3
LFQH_Lloh1642:
adr x0, LFQH_l_.str.557
LFQH_Lloh1643:
nop
bl Lpatch + (0xa5a4 - PATCH_BASE)
mov	x1, x0
LFQH_Lloh1644:
adr x2, LFQH_ToggleChanged
LFQH_Lloh1645:
nop
LFQH_Lloh1646:
adr x20, LFQH_l_.str.186
LFQH_Lloh1647:
nop
mov	x0, x19
mov	x3, x20
bl Lpatch + (0xa58c - PATCH_BASE)
LFQH_Lloh1648:
adr x0, LFQH_l_.str.558
LFQH_Lloh1649:
nop
bl Lpatch + (0xa5a4 - PATCH_BASE)
mov	x1, x0
LFQH_Lloh1650:
adr x2, LFQH_RecoverOptions
LFQH_Lloh1651:
nop
mov	x0, x19
mov	x3, x20
bl Lpatch + (0xa58c - PATCH_BASE)
LFQH_Lloh1652:
adr x0, LFQH_l_.str.559
LFQH_Lloh1653:
nop
bl Lpatch + (0xa5a4 - PATCH_BASE)
mov	x1, x0
LFQH_Lloh1654:
adr x2, LFQH_RecoveryTouch
LFQH_Lloh1655:
nop
LFQH_Lloh1656:
adr x3, LFQH_l_.str.560
LFQH_Lloh1657:
nop
mov	x0, x19
bl Lpatch + (0xa58c - PATCH_BASE)
mov	x0, x19
bl Lpatch + (0xa610 - PATCH_BASE)
LFQH_LBB72_3:
mov	x0, x19
ldp	x29, x30, [sp, #16]
ldp	x20, x19, [sp], #32
ret
.cfi_endproc
.p2align	2
LFQH_PageOptionEnabled:
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
LFQH_Lloh1658:
adr x0, LFQH_l_.str.467
LFQH_Lloh1659:
nop
bl Lpatch + (0xa5b0 - PATCH_BASE)
mov	x20, x0
LFQH_Lloh1660:
adr x0, LFQH_l_.str.468
LFQH_Lloh1661:
nop
bl Lpatch + (0xa5a4 - PATCH_BASE)
mov	x1, x0
mov	x0, x20
bl Lpatch + (0xa5d4 - PATCH_BASE)
mov	x20, x0
LFQH_Lloh1662:
adr x0, LFQH_l_.str.536
LFQH_Lloh1663:
nop
bl Lpatch + (0xa5a4 - PATCH_BASE)
mov	x21, x0
mov	x0, x19
bl	LFQH_PagePreference
mov	x2, x0
mov	x0, x20
mov	x1, x21
bl Lpatch + (0xa5d4 - PATCH_BASE)
cbz	x0, LFQH_LBB73_2
LFQH_Lloh1664:
adr x1, LFQH_l_.str.41
LFQH_Lloh1665:
nop
ldp	x29, x30, [sp, #32]
ldp	x20, x19, [sp, #16]
ldp	x22, x21, [sp], #48
b	LFQH_BoolProp
LFQH_LBB73_2:
and	x8, x19, #0xfffffffffffffffd
cmp	x8, #9
cset	w0, ne
ldp	x29, x30, [sp, #32]
ldp	x20, x19, [sp, #16]
ldp	x22, x21, [sp], #48
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
LFQH_Lloh1666:
adr x1, LFQH_l_.str.169
LFQH_Lloh1667:
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
LFQH_Lloh1668:
adr x0, LFQH_l_.str.24
LFQH_Lloh1669:
nop
bl Lpatch + (0xa5a4 - PATCH_BASE)
mov	x1, x0
mov	x0, x19
bl Lpatch + (0xa5d4 - PATCH_BASE)
fmov	d9, d0
fmov	d8, d1
fmov	d11, d2
fmov	d10, d3
mov	x0, x21
bl Lpatch + (0xa664 - PATCH_BASE)
LFQH_Lloh1670:
adr x1, LFQH_l_.str.622
LFQH_Lloh1671:
nop
LFQH_Lloh1672:
adr x2, LFQH_l_.str.623
LFQH_Lloh1673:
nop
bl	LFQH_ClassABI
fmov	d12, xzr
fmov	d0, xzr
cbz	w0, LFQH_LBB77_2
LFQH_Lloh1674:
adr x0, LFQH_l_.str.622
LFQH_Lloh1675:
nop
bl Lpatch + (0xa5a4 - PATCH_BASE)
mov	x1, x0
mov	x0, x21
bl Lpatch + (0xa5d4 - PATCH_BASE)
LFQH_LBB77_2:
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
LFQH_Lloh1676:
adr x1, LFQH_SurfaceKey
LFQH_Lloh1677:
nop
mov	x0, x19
bl Lpatch + (0xa628 - PATCH_BASE)
mov	x21, x0
mov	x1, x20
mov	w2, #0
bl	LFQH_ShelfTint
LFQH_Lloh1678:
adr x1, LFQH_l_.str.430
LFQH_Lloh1679:
nop
mov	x0, x19
bl	LFQH_Get
cmp	x21, #0
cset	w20, ne
mov	x1, x20
bl	LFQH_ShelfTitleFont
LFQH_Lloh1680:
adr x1, LFQH_l_.str.624
LFQH_Lloh1681:
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
LFQH_Lloh1682:
adr x0, LFQH_l_.str.170
LFQH_Lloh1683:
nop
bl Lpatch + (0xa5b0 - PATCH_BASE)
LFQH_Lloh1684:
adr x1, LFQH_l_.str.171
LFQH_Lloh1685:
nop
LFQH_Lloh1686:
adr x2, LFQH_l_.str.172
LFQH_Lloh1687:
nop
bl	LFQH_ClassABI
mov	x19, x0
LFQH_Lloh1688:
adr x0, LFQH_l_.str.173
LFQH_Lloh1689:
nop
bl Lpatch + (0xa5b0 - PATCH_BASE)
cbz	x0, LFQH_LBB78_5
mov	x20, x0
LFQH_Lloh1690:
adr x0, LFQH_l_.str.174
LFQH_Lloh1691:
nop
bl Lpatch + (0xa5a4 - PATCH_BASE)
mov	x1, x0
LFQH_Lloh1692:
adr x3, LFQH_l_.str.149
LFQH_Lloh1693:
nop
mov	x0, x20
mov	w2, #0
bl LHookOwned
cbz	x0, LFQH_LBB78_4
mov	x20, x0
LFQH_Lloh1694:
adr x21, LFQH_l_.str.175
LFQH_Lloh1695:
nop
LFQH_Lloh1696:
adr x1, LFQH_l_.str.176
LFQH_Lloh1697:
nop
LFQH_Lloh1698:
adr x22, LFQH_l_.str.177
LFQH_Lloh1699:
nop
LFQH_Lloh1700:
adr x23, LFQH_l_.str.123
LFQH_Lloh1701:
nop
LFQH_Lloh1702:
adr x4, LFQH_BookstorePopupHandler
LFQH_Lloh1703:
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
cbz	w0, LFQH_LBB78_4
LFQH_Lloh1704:
adr x1, LFQH_DenyBookstorePopup
LFQH_Lloh1705:
nop
mov	x0, x20
bl Lpatch + (0xa580 - PATCH_BASE)
b	LFQH_LBB78_5
LFQH_LBB78_4:
mov	w19, #0
LFQH_LBB78_5:
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
cbz	x0, LFQH_LBB79_2
mov	x21, x0
mov	x0, x22
bl Lpatch + (0xa5a4 - PATCH_BASE)
mov	x1, x0
mov	x0, x21
bl Lpatch + (0xa5f8 - PATCH_BASE)
cbz	x0, LFQH_LBB79_3
LFQH_LBB79_2:
ldp	x29, x30, [sp, #48]
ldp	x20, x19, [sp, #32]
ldp	x22, x21, [sp, #16]
ldp	x24, x23, [sp], #64
ret
LFQH_LBB79_3:
mov	x0, x23
bl Lpatch + (0xa5a4 - PATCH_BASE)
mov	x1, x0
mov	x0, x21
mov	w2, #0
mov	x3, x20
bl LHookOwned
cbz	x0, LFQH_LBB79_2
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
cbz	w0, LFQH_LBB79_2
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
LFQH_Lloh1706:
adr x0, LFQH_l_.str.175
LFQH_Lloh1707:
nop
LFQH_Lloh1708:
adr x1, LFQH_l_.str.177
LFQH_Lloh1709:
nop
bl	LFQH_Original
mov	x8, x0
mov	x0, x21
mov	x1, x20
mov	x2, x19
blr	x8
mov	x19, x0
LFQH_Lloh1710:
adr x1, LFQH_l_.str.173
LFQH_Lloh1711:
nop
bl	LFQH_Kind
cbz	w0, LFQH_LBB80_2
LFQH_Lloh1712:
adr x0, LFQH_l_.str.88
LFQH_Lloh1713:
nop
bl Lpatch + (0xa5b0 - PATCH_BASE)
mov	x19, x0
LFQH_Lloh1714:
adr x0, LFQH_l_.str.89
LFQH_Lloh1715:
nop
bl Lpatch + (0xa5a4 - PATCH_BASE)
mov	x1, x0
mov	x0, x19
bl Lpatch + (0xa5d4 - PATCH_BASE)
mov	x19, x0
LFQH_Lloh1716:
adr x20, LFQH_l_.str.361
LFQH_Lloh1717:
nop
mov	x0, x20
bl Lpatch + (0xa5b0 - PATCH_BASE)
mov	x22, x0
LFQH_Lloh1718:
adr x21, LFQH_l_.str.387
LFQH_Lloh1719:
nop
mov	x0, x21
bl Lpatch + (0xa5a4 - PATCH_BASE)
mov	x1, x0
LFQH_Lloh1720:
adr x2, LFQH_l_.str.627
LFQH_Lloh1721:
nop
mov	x0, x22
bl Lpatch + (0xa5d4 - PATCH_BASE)
mov	x2, x0
LFQH_Lloh1722:
adr x1, LFQH_l_.str.626
LFQH_Lloh1723:
nop
mov	x0, x19
bl	LFQH_Put
mov	x0, x20
bl Lpatch + (0xa5b0 - PATCH_BASE)
mov	x22, x0
mov	x0, x21
bl Lpatch + (0xa5a4 - PATCH_BASE)
mov	x1, x0
LFQH_Lloh1724:
adr x2, LFQH_l_.str.629
LFQH_Lloh1725:
nop
mov	x0, x22
bl Lpatch + (0xa5d4 - PATCH_BASE)
mov	x2, x0
LFQH_Lloh1726:
adr x1, LFQH_l_.str.628
LFQH_Lloh1727:
nop
mov	x0, x19
bl	LFQH_Put
mov	x0, x20
bl Lpatch + (0xa5b0 - PATCH_BASE)
mov	x22, x0
mov	x0, x21
bl Lpatch + (0xa5a4 - PATCH_BASE)
mov	x1, x0
LFQH_Lloh1728:
adr x2, LFQH_l_.str.175
LFQH_Lloh1729:
nop
mov	x0, x22
bl Lpatch + (0xa5d4 - PATCH_BASE)
mov	x2, x0
LFQH_Lloh1730:
adr x1, LFQH_l_.str.630
LFQH_Lloh1731:
nop
mov	x0, x19
bl	LFQH_Put
mov	x0, x20
bl Lpatch + (0xa5b0 - PATCH_BASE)
mov	x22, x0
mov	x0, x21
bl Lpatch + (0xa5a4 - PATCH_BASE)
mov	x1, x0
LFQH_Lloh1732:
adr x2, LFQH_l_.str.176
LFQH_Lloh1733:
nop
mov	x0, x22
bl Lpatch + (0xa5d4 - PATCH_BASE)
mov	x2, x0
LFQH_Lloh1734:
adr x1, LFQH_l_.str.631
LFQH_Lloh1735:
nop
mov	x0, x19
bl	LFQH_Put
mov	x0, x20
bl Lpatch + (0xa5b0 - PATCH_BASE)
mov	x22, x0
mov	x0, x21
bl Lpatch + (0xa5a4 - PATCH_BASE)
mov	x1, x0
LFQH_Lloh1736:
adr x2, LFQH_l_.str.633
LFQH_Lloh1737:
nop
mov	x0, x22
bl Lpatch + (0xa5d4 - PATCH_BASE)
mov	x2, x0
LFQH_Lloh1738:
adr x1, LFQH_l_.str.632
LFQH_Lloh1739:
nop
mov	x0, x19
bl	LFQH_Put
mov	x0, x20
bl Lpatch + (0xa5b0 - PATCH_BASE)
mov	x20, x0
mov	x0, x21
bl Lpatch + (0xa5a4 - PATCH_BASE)
mov	x1, x0
LFQH_Lloh1740:
adr x2, LFQH_l_.str.635
LFQH_Lloh1741:
nop
mov	x0, x20
bl Lpatch + (0xa5d4 - PATCH_BASE)
mov	x2, x0
LFQH_Lloh1742:
adr x1, LFQH_l_.str.634
LFQH_Lloh1743:
nop
mov	x0, x19
bl	LFQH_Put
LFQH_Lloh1744:
adr x0, LFQH_l_.str.636
LFQH_Lloh1745:
nop
mov	x1, x19
bl Lrecord_named
mov	x19, #0
LFQH_LBB80_2:
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
bl	LFQH_FQHGlassAvailable
cbz	w0, LFQH_LBB82_5
LFQH_Lloh1746:
adr x0, LFQH_l_.str.638
LFQH_Lloh1747:
nop
bl Lpatch + (0xa5b0 - PATCH_BASE)
LFQH_Lloh1748:
adr x1, LFQH_l_.str.639
LFQH_Lloh1749:
nop
LFQH_Lloh1750:
adr x2, LFQH_l_.str.640
LFQH_Lloh1751:
nop
bl	LFQH_ClassABI
cbz	w0, LFQH_LBB82_5
LFQH_Lloh1752:
adr x0, LFQH_l_.str.637
LFQH_Lloh1753:
nop
bl Lpatch + (0xa5b0 - PATCH_BASE)
LFQH_Lloh1754:
adr x1, LFQH_l_.str.133
LFQH_Lloh1755:
nop
LFQH_Lloh1756:
adr x2, LFQH_l_.str.641
LFQH_Lloh1757:
nop
bl	LFQH_ClassABI
cbz	w0, LFQH_LBB82_5
LFQH_Lloh1758:
adr x0, LFQH_l_.str.637
LFQH_Lloh1759:
nop
bl Lpatch + (0xa5b0 - PATCH_BASE)
LFQH_Lloh1760:
adr x1, LFQH_l_.str.134
LFQH_Lloh1761:
nop
LFQH_Lloh1762:
adr x2, LFQH_l_.str.344
LFQH_Lloh1763:
nop
bl	LFQH_ClassABI
cbz	w0, LFQH_LBB82_5
LFQH_Lloh1764:
adr x19, LFQH_l_.str.637
LFQH_Lloh1765:
nop
LFQH_Lloh1766:
adr x1, LFQH_l_.str.642
LFQH_Lloh1767:
nop
LFQH_Lloh1768:
adr x2, LFQH_l_.str.643
LFQH_Lloh1769:
nop
LFQH_Lloh1770:
adr x3, LFQH_l_.str.113
LFQH_Lloh1771:
nop
LFQH_Lloh1772:
adr x4, LFQH_ReaderGlassWillAppear
LFQH_Lloh1773:
nop
mov	x0, x19
bl	LFQH_Hook
LFQH_Lloh1774:
adr x1, LFQH_l_.str.644
LFQH_Lloh1775:
nop
LFQH_Lloh1776:
adr x2, LFQH_l_.str.645
LFQH_Lloh1777:
nop
LFQH_Lloh1778:
adr x3, LFQH_l_.str.186
LFQH_Lloh1779:
nop
LFQH_Lloh1780:
adr x4, LFQH_ReaderGlassThemeChanged
LFQH_Lloh1781:
nop
mov	x0, x19
bl	LFQH_Hook
LFQH_LBB82_5:
LFQH_Lloh1782:
adr x0, LFQH_l_.str.144
LFQH_Lloh1783:
nop
bl Lpatch + (0xa5b0 - PATCH_BASE)
LFQH_Lloh1784:
adr x1, LFQH_l_.str.649
LFQH_Lloh1785:
nop
LFQH_Lloh1786:
adr x2, LFQH_l_.str.652
LFQH_Lloh1787:
nop
bl	LFQH_ClassABI
cbz	w0, LFQH_LBB82_15
LFQH_Lloh1788:
adr x0, LFQH_l_.str.144
LFQH_Lloh1789:
nop
bl Lpatch + (0xa5b0 - PATCH_BASE)
LFQH_Lloh1790:
adr x1, LFQH_l_.str.650
LFQH_Lloh1791:
nop
LFQH_Lloh1792:
adr x2, LFQH_l_.str.652
LFQH_Lloh1793:
nop
bl	LFQH_ClassABI
cbz	w0, LFQH_LBB82_15
LFQH_Lloh1794:
adr x0, LFQH_l_.str.144
LFQH_Lloh1795:
nop
bl Lpatch + (0xa5b0 - PATCH_BASE)
LFQH_Lloh1796:
adr x1, LFQH_l_.str.651
LFQH_Lloh1797:
nop
LFQH_Lloh1798:
adr x2, LFQH_l_.str.652
LFQH_Lloh1799:
nop
bl	LFQH_ClassABI
cbz	w0, LFQH_LBB82_15
LFQH_Lloh1800:
adr x0, LFQH_l_.str.144
LFQH_Lloh1801:
nop
bl Lpatch + (0xa5b0 - PATCH_BASE)
LFQH_Lloh1802:
adr x1, LFQH_l_.str.653
LFQH_Lloh1803:
nop
LFQH_Lloh1804:
adr x2, LFQH_l_.str.113
LFQH_Lloh1805:
nop
bl	LFQH_ClassABI
cbz	w0, LFQH_LBB82_15
LFQH_Lloh1806:
adr x0, LFQH_l_.str.638
LFQH_Lloh1807:
nop
bl Lpatch + (0xa5b0 - PATCH_BASE)
LFQH_Lloh1808:
adr x1, LFQH_l_.str.639
LFQH_Lloh1809:
nop
LFQH_Lloh1810:
adr x2, LFQH_l_.str.640
LFQH_Lloh1811:
nop
bl	LFQH_ClassABI
cbz	w0, LFQH_LBB82_15
LFQH_Lloh1812:
adr x0, LFQH_l_.str.142
LFQH_Lloh1813:
nop
bl Lpatch + (0xa5b0 - PATCH_BASE)
LFQH_Lloh1814:
adr x1, LFQH_l_.str.654
LFQH_Lloh1815:
nop
LFQH_Lloh1816:
adr x2, LFQH_l_.str.196
LFQH_Lloh1817:
nop
bl	LFQH_ClassABI
cbz	w0, LFQH_LBB82_15
LFQH_Lloh1818:
adr x19, LFQH_l_.str.144
LFQH_Lloh1819:
nop
LFQH_Lloh1820:
adr x1, LFQH_l_.str.650
LFQH_Lloh1821:
nop
LFQH_Lloh1822:
adr x2, LFQH_l_.str.145
LFQH_Lloh1823:
nop
LFQH_Lloh1824:
adr x20, LFQH_l_.str.652
LFQH_Lloh1825:
nop
LFQH_Lloh1826:
adr x21, LFQH_ReaderLocalTheme
LFQH_Lloh1827:
nop
mov	x0, x19
mov	x3, x20
mov	x4, x21
bl	LFQH_Hook
LFQH_Lloh1828:
adr x1, LFQH_l_.str.651
LFQH_Lloh1829:
nop
LFQH_Lloh1830:
adr x2, LFQH_l_.str.655
LFQH_Lloh1831:
nop
mov	x0, x19
mov	x3, x20
mov	x4, x21
bl	LFQH_Hook
LFQH_Lloh1832:
adr x0, LFQH_l_.str.142
LFQH_Lloh1833:
nop
LFQH_Lloh1834:
adr x1, LFQH_l_.str.654
LFQH_Lloh1835:
nop
LFQH_Lloh1836:
adr x2, LFQH_l_.str.656
LFQH_Lloh1837:
nop
LFQH_Lloh1838:
adr x3, LFQH_l_.str.196
LFQH_Lloh1839:
nop
LFQH_Lloh1840:
adr x4, LFQH_ReaderThemeToApp
LFQH_Lloh1841:
nop
bl	LFQH_Hook
LFQH_Lloh1842:
adr x1, LFQH_l_.str.657
LFQH_Lloh1843:
nop
LFQH_Lloh1844:
adr x2, LFQH_l_.str.658
LFQH_Lloh1845:
nop
LFQH_Lloh1846:
adr x20, LFQH_l_.str.113
LFQH_Lloh1847:
nop
LFQH_Lloh1848:
adr x21, LFQH_ReaderThemeFromApp
LFQH_Lloh1849:
nop
mov	x0, x19
mov	x3, x20
mov	x4, x21
bl	LFQH_Hook
LFQH_Lloh1850:
adr x1, LFQH_l_.str.659
LFQH_Lloh1851:
nop
LFQH_Lloh1852:
adr x2, LFQH_l_.str.660
LFQH_Lloh1853:
nop
mov	x0, x19
mov	x3, x20
mov	x4, x21
bl	LFQH_Hook
LFQH_Lloh1854:
adr x0, LFQH_l_.str.661
LFQH_Lloh1855:
nop
bl Lpatch + (0xa5b0 - PATCH_BASE)
LFQH_Lloh1856:
adr x1, LFQH_l_.str.662
LFQH_Lloh1857:
nop
LFQH_Lloh1858:
adr x2, LFQH_l_.str.149
LFQH_Lloh1859:
nop
bl	LFQH_ClassABI
cbz	w0, LFQH_LBB82_15
LFQH_Lloh1860:
adr x0, LFQH_l_.str.663
LFQH_Lloh1861:
nop
bl Lpatch + (0xa5b0 - PATCH_BASE)
LFQH_Lloh1862:
adr x1, LFQH_l_.str.664
LFQH_Lloh1863:
nop
LFQH_Lloh1864:
adr x2, LFQH_l_.str.123
LFQH_Lloh1865:
nop
bl	LFQH_ClassABI
cbz	w0, LFQH_LBB82_15
LFQH_Lloh1866:
adr x0, LFQH_l_.str.191
LFQH_Lloh1867:
nop
bl Lpatch + (0xa5b0 - PATCH_BASE)
LFQH_Lloh1868:
adr x1, LFQH_l_.str.644
LFQH_Lloh1869:
nop
LFQH_Lloh1870:
adr x2, LFQH_l_.str.186
LFQH_Lloh1871:
nop
bl	LFQH_ClassABI
cbz	w0, LFQH_LBB82_15
LFQH_Lloh1872:
adr x0, LFQH_l_.str.191
LFQH_Lloh1873:
nop
LFQH_Lloh1874:
adr x1, LFQH_l_.str.665
LFQH_Lloh1875:
nop
LFQH_Lloh1876:
adr x2, LFQH_l_.str.666
LFQH_Lloh1877:
nop
LFQH_Lloh1878:
adr x3, LFQH_l_.str.196
LFQH_Lloh1879:
nop
LFQH_Lloh1880:
adr x4, LFQH_ReaderThemePaletteChoice
LFQH_Lloh1881:
nop
bl	LFQH_Hook
LFQH_Lloh1882:
adr x0, LFQH_l_.str.667
LFQH_Lloh1883:
nop
LFQH_Lloh1884:
adr x1, LFQH_l_.str.668
LFQH_Lloh1885:
nop
LFQH_Lloh1886:
adr x2, LFQH_l_.str.669
LFQH_Lloh1887:
nop
LFQH_Lloh1888:
adr x3, LFQH_l_.str.186
LFQH_Lloh1889:
nop
LFQH_Lloh1890:
adr x4, LFQH_ReaderThemeWillAppear
LFQH_Lloh1891:
nop
bl	LFQH_Hook
LFQH_LBB82_15:
LFQH_Lloh1892:
adr x21, LFQH_l_.str.73
LFQH_Lloh1893:
nop
mov	x0, x21
bl Lpatch + (0xa5b0 - PATCH_BASE)
mov	x19, x0
LFQH_Lloh1894:
adr x22, LFQH_l_.str.178
LFQH_Lloh1895:
nop
mov	x0, x22
bl Lpatch + (0xa5a4 - PATCH_BASE)
mov	x1, x0
mov	x0, x19
bl Lpatch + (0xa5f8 - PATCH_BASE)
mov	x19, x0
LFQH_Lloh1896:
adr x0, LFQH_l_.str.675
LFQH_Lloh1897:
nop
bl Lpatch + (0xa5b0 - PATCH_BASE)
mov	x20, x0
mov	x0, x22
bl Lpatch + (0xa5a4 - PATCH_BASE)
mov	x1, x0
mov	x0, x20
bl Lpatch + (0xa5f8 - PATCH_BASE)
mov	x20, x0
LFQH_Lloh1898:
adr x2, LFQH_l_.str.676
LFQH_Lloh1899:
nop
LFQH_Lloh1900:
adr x3, LFQH_l_.str.9
LFQH_Lloh1901:
nop
LFQH_Lloh1902:
adr x4, LFQH_DramaControlsLayout178R2
LFQH_Lloh1903:
nop
mov	x0, x21
mov	x1, x22
bl	LFQH_Hook
cbz	x20, LFQH_LBB82_18
cmp	x20, x19
b.eq	LFQH_LBB82_18
LFQH_Lloh1904:
adr x0, LFQH_l_.str.675
LFQH_Lloh1905:
nop
LFQH_Lloh1906:
adr x1, LFQH_l_.str.178
LFQH_Lloh1907:
nop
LFQH_Lloh1908:
adr x2, LFQH_l_.str.677
LFQH_Lloh1909:
nop
LFQH_Lloh1910:
adr x3, LFQH_l_.str.9
LFQH_Lloh1911:
nop
LFQH_Lloh1912:
adr x4, LFQH_DramaSeriesControlsLayout178R2
LFQH_Lloh1913:
nop
bl	LFQH_Hook
LFQH_LBB82_18:
LFQH_Lloh1914:
adr x0, LFQH_l_.str.64
LFQH_Lloh1915:
nop
LFQH_Lloh1916:
adr x19, LFQH_l_.str.178
LFQH_Lloh1917:
nop
LFQH_Lloh1918:
adr x2, LFQH_l_.str.179
LFQH_Lloh1919:
nop
LFQH_Lloh1920:
adr x20, LFQH_l_.str.9
LFQH_Lloh1921:
nop
LFQH_Lloh1922:
adr x4, LFQH_DramaCommentLayout
LFQH_Lloh1923:
nop
mov	x1, x19
mov	x3, x20
bl	LFQH_Hook
LFQH_Lloh1924:
adr x0, LFQH_l_.str.66
LFQH_Lloh1925:
nop
LFQH_Lloh1926:
adr x1, LFQH_l_.str.180
LFQH_Lloh1927:
nop
LFQH_Lloh1928:
adr x2, LFQH_l_.str.181
LFQH_Lloh1929:
nop
LFQH_Lloh1930:
adr x3, LFQH_l_.str.113
LFQH_Lloh1931:
nop
LFQH_Lloh1932:
adr x4, LFQH_DramaLikeVisibility
LFQH_Lloh1933:
nop
bl	LFQH_Hook
LFQH_Lloh1934:
adr x21, LFQH_l_.str.182
LFQH_Lloh1935:
nop
LFQH_Lloh1936:
adr x2, LFQH_l_.str.183
LFQH_Lloh1937:
nop
LFQH_Lloh1938:
adr x4, LFQH_DramaWatchLayout
LFQH_Lloh1939:
nop
mov	x0, x21
mov	x1, x19
mov	x3, x20
bl	LFQH_Hook
LFQH_Lloh1940:
adr x1, LFQH_l_.str.184
LFQH_Lloh1941:
nop
LFQH_Lloh1942:
adr x2, LFQH_l_.str.185
LFQH_Lloh1943:
nop
LFQH_Lloh1944:
adr x3, LFQH_l_.str.186
LFQH_Lloh1945:
nop
LFQH_Lloh1946:
adr x4, LFQH_DramaWatchRender
LFQH_Lloh1947:
nop
mov	x0, x21
bl	LFQH_Hook
LFQH_Lloh1948:
adr x0, LFQH_l_.str.187
LFQH_Lloh1949:
nop
LFQH_Lloh1950:
adr x2, LFQH_l_.str.188
LFQH_Lloh1951:
nop
LFQH_Lloh1952:
adr x4, LFQH_DramaWatchAlbumLayout
LFQH_Lloh1953:
nop
mov	x1, x19
mov	x3, x20
bl	LFQH_Hook
LFQH_Lloh1954:
adr x0, LFQH_l_.str.568
LFQH_Lloh1955:
nop
bl Lpatch + (0xa5b0 - PATCH_BASE)
LFQH_Lloh1956:
adr x1, LFQH_l_.str.570
LFQH_Lloh1957:
nop
LFQH_Lloh1958:
adr x2, LFQH_l_.str.149
LFQH_Lloh1959:
nop
bl	LFQH_ClassABI
cbz	w0, LFQH_LBB82_34
LFQH_Lloh1960:
adr x0, LFQH_l_.str.568
LFQH_Lloh1961:
nop
bl Lpatch + (0xa5b0 - PATCH_BASE)
LFQH_Lloh1962:
adr x1, LFQH_l_.str.569
LFQH_Lloh1963:
nop
LFQH_Lloh1964:
adr x2, LFQH_l_.str.11
LFQH_Lloh1965:
nop
bl	LFQH_ClassABI
cbz	w0, LFQH_LBB82_34
LFQH_Lloh1966:
adr x0, LFQH_l_.str.568
LFQH_Lloh1967:
nop
bl Lpatch + (0xa5b0 - PATCH_BASE)
LFQH_Lloh1968:
adr x1, LFQH_l_.str.688
LFQH_Lloh1969:
nop
LFQH_Lloh1970:
adr x2, LFQH_l_.str.689
LFQH_Lloh1971:
nop
bl	LFQH_ClassABI
cbz	w0, LFQH_LBB82_34
LFQH_Lloh1972:
adr x0, LFQH_l_.str.568
LFQH_Lloh1973:
nop
bl Lpatch + (0xa5b0 - PATCH_BASE)
LFQH_Lloh1974:
adr x1, LFQH_l_.str.178
LFQH_Lloh1975:
nop
LFQH_Lloh1976:
adr x2, LFQH_l_.str.9
LFQH_Lloh1977:
nop
bl	LFQH_ClassABI
cbz	w0, LFQH_LBB82_34
LFQH_Lloh1978:
adr x0, LFQH_l_.str.568
LFQH_Lloh1979:
nop
bl Lpatch + (0xa5b0 - PATCH_BASE)
LFQH_Lloh1980:
adr x1, LFQH_l_.str.690
LFQH_Lloh1981:
nop
LFQH_Lloh1982:
adr x2, LFQH_l_.str.113
LFQH_Lloh1983:
nop
bl	LFQH_ClassABI
cbz	w0, LFQH_LBB82_34
LFQH_Lloh1984:
adr x0, LFQH_l_.str.568
LFQH_Lloh1985:
nop
bl Lpatch + (0xa5b0 - PATCH_BASE)
LFQH_Lloh1986:
adr x1, LFQH_l_.str.691
LFQH_Lloh1987:
nop
LFQH_Lloh1988:
adr x2, LFQH_l_.str.186
LFQH_Lloh1989:
nop
bl	LFQH_ClassABI
cbz	w0, LFQH_LBB82_34
LFQH_Lloh1990:
adr x0, LFQH_l_.str.568
LFQH_Lloh1991:
nop
bl Lpatch + (0xa5b0 - PATCH_BASE)
LFQH_Lloh1992:
adr x1, LFQH_l_.str.567
LFQH_Lloh1993:
nop
LFQH_Lloh1994:
adr x2, LFQH_l_.str.9
LFQH_Lloh1995:
nop
bl	LFQH_ClassABI
cbz	w0, LFQH_LBB82_34
LFQH_Lloh1996:
adr x0, LFQH_l_.str.568
LFQH_Lloh1997:
nop
bl Lpatch + (0xa5b0 - PATCH_BASE)
LFQH_Lloh1998:
adr x1, LFQH_l_.str.692
LFQH_Lloh1999:
nop
LFQH_Lloh2000:
adr x2, LFQH_l_.str.693
LFQH_Lloh2001:
nop
bl	LFQH_ClassABI
cbz	w0, LFQH_LBB82_34
LFQH_Lloh2002:
adr x0, LFQH_l_.str.568
LFQH_Lloh2003:
nop
bl Lpatch + (0xa5b0 - PATCH_BASE)
LFQH_Lloh2004:
adr x1, LFQH_l_.str.694
LFQH_Lloh2005:
nop
LFQH_Lloh2006:
adr x2, LFQH_l_.str.186
LFQH_Lloh2007:
nop
bl	LFQH_ClassABI
cbz	w0, LFQH_LBB82_34
LFQH_Lloh2008:
adr x0, LFQH_l_.str.571
LFQH_Lloh2009:
nop
bl Lpatch + (0xa5b0 - PATCH_BASE)
LFQH_Lloh2010:
adr x1, LFQH_l_.str.695
LFQH_Lloh2011:
nop
LFQH_Lloh2012:
adr x2, LFQH_l_.str.11
LFQH_Lloh2013:
nop
bl	LFQH_ClassABI
cbz	w0, LFQH_LBB82_34
LFQH_Lloh2014:
adr x0, LFQH_l_.str.571
LFQH_Lloh2015:
nop
bl Lpatch + (0xa5b0 - PATCH_BASE)
LFQH_Lloh2016:
adr x1, LFQH_l_.str.573
LFQH_Lloh2017:
nop
LFQH_Lloh2018:
adr x2, LFQH_l_.str.11
LFQH_Lloh2019:
nop
bl	LFQH_ClassABI
cbz	w0, LFQH_LBB82_34
LFQH_Lloh2020:
adr x0, LFQH_l_.str.571
LFQH_Lloh2021:
nop
bl Lpatch + (0xa5b0 - PATCH_BASE)
LFQH_Lloh2022:
adr x1, LFQH_l_.str.572
LFQH_Lloh2023:
nop
LFQH_Lloh2024:
adr x2, LFQH_l_.str.149
LFQH_Lloh2025:
nop
bl	LFQH_ClassABI
cbz	w0, LFQH_LBB82_34
LFQH_Lloh2026:
adr x0, LFQH_l_.str.571
LFQH_Lloh2027:
nop
bl Lpatch + (0xa5b0 - PATCH_BASE)
LFQH_Lloh2028:
adr x1, LFQH_l_.str.696
LFQH_Lloh2029:
nop
LFQH_Lloh2030:
adr x2, LFQH_l_.str.9
LFQH_Lloh2031:
nop
bl	LFQH_ClassABI
cbz	w0, LFQH_LBB82_34
LFQH_Lloh2032:
adr x0, LFQH_l_.str.697
LFQH_Lloh2033:
nop
bl Lpatch + (0xa5b0 - PATCH_BASE)
LFQH_Lloh2034:
adr x1, LFQH_l_.str.574
LFQH_Lloh2035:
nop
LFQH_Lloh2036:
adr x2, LFQH_l_.str.641
LFQH_Lloh2037:
nop
bl	LFQH_ClassABI
cbz	w0, LFQH_LBB82_34
LFQH_Lloh2038:
adr x0, LFQH_l_.str.697
LFQH_Lloh2039:
nop
bl Lpatch + (0xa5b0 - PATCH_BASE)
LFQH_Lloh2040:
adr x1, LFQH_l_.str.576
LFQH_Lloh2041:
nop
LFQH_Lloh2042:
adr x2, LFQH_l_.str.344
LFQH_Lloh2043:
nop
bl	LFQH_ClassABI
cbz	w0, LFQH_LBB82_34
LFQH_Lloh2044:
adr x19, LFQH_l_.str.568
LFQH_Lloh2045:
nop
LFQH_Lloh2046:
adr x1, LFQH_l_.str.688
LFQH_Lloh2047:
nop
LFQH_Lloh2048:
adr x2, LFQH_l_.str.698
LFQH_Lloh2049:
nop
LFQH_Lloh2050:
adr x3, LFQH_l_.str.689
LFQH_Lloh2051:
nop
LFQH_Lloh2052:
adr x4, LFQH_FullscreenPlayerFrame
LFQH_Lloh2053:
nop
mov	x0, x19
bl	LFQH_Hook
LFQH_Lloh2054:
adr x1, LFQH_l_.str.178
LFQH_Lloh2055:
nop
LFQH_Lloh2056:
adr x2, LFQH_l_.str.699
LFQH_Lloh2057:
nop
LFQH_Lloh2058:
adr x4, LFQH_FullscreenPlayerLayout
LFQH_Lloh2059:
nop
mov	x0, x19
mov	x3, x20
bl	LFQH_Hook
LFQH_Lloh2060:
adr x1, LFQH_l_.str.690
LFQH_Lloh2061:
nop
LFQH_Lloh2062:
adr x2, LFQH_l_.str.700
LFQH_Lloh2063:
nop
LFQH_Lloh2064:
adr x3, LFQH_l_.str.113
LFQH_Lloh2065:
nop
LFQH_Lloh2066:
adr x4, LFQH_FullscreenPlayerState
LFQH_Lloh2067:
nop
mov	x0, x19
bl	LFQH_Hook
LFQH_Lloh2068:
adr x1, LFQH_l_.str.691
LFQH_Lloh2069:
nop
LFQH_Lloh2070:
adr x2, LFQH_l_.str.701
LFQH_Lloh2071:
nop
LFQH_Lloh2072:
adr x21, LFQH_l_.str.186
LFQH_Lloh2073:
nop
LFQH_Lloh2074:
adr x4, LFQH_FullscreenPlayerEngine
LFQH_Lloh2075:
nop
mov	x0, x19
mov	x3, x21
bl	LFQH_Hook
LFQH_Lloh2076:
adr x1, LFQH_l_.str.692
LFQH_Lloh2077:
nop
LFQH_Lloh2078:
adr x2, LFQH_l_.str.702
LFQH_Lloh2079:
nop
LFQH_Lloh2080:
adr x3, LFQH_l_.str.693
LFQH_Lloh2081:
nop
LFQH_Lloh2082:
adr x4, LFQH_FullscreenPlayerPrepare
LFQH_Lloh2083:
nop
mov	x0, x19
bl	LFQH_Hook
LFQH_Lloh2084:
adr x1, LFQH_l_.str.694
LFQH_Lloh2085:
nop
LFQH_Lloh2086:
adr x2, LFQH_l_.str.703
LFQH_Lloh2087:
nop
LFQH_Lloh2088:
adr x4, LFQH_FullscreenPlayerReady
LFQH_Lloh2089:
nop
mov	x0, x19
mov	x3, x21
bl	LFQH_Hook
LFQH_Lloh2090:
adr x0, LFQH_l_.str.571
LFQH_Lloh2091:
nop
LFQH_Lloh2092:
adr x1, LFQH_l_.str.696
LFQH_Lloh2093:
nop
LFQH_Lloh2094:
adr x2, LFQH_l_.str.704
LFQH_Lloh2095:
nop
LFQH_Lloh2096:
adr x4, LFQH_FullscreenCellDisplay
LFQH_Lloh2097:
nop
mov	x3, x20
bl	LFQH_Hook
LFQH_LBB82_34:
LFQH_Lloh2098:
adr x0, LFQH_l_.str.189
LFQH_Lloh2099:
nop
LFQH_Lloh2100:
adr x21, LFQH_l_.str.178
LFQH_Lloh2101:
nop
LFQH_Lloh2102:
adr x2, LFQH_l_.str.190
LFQH_Lloh2103:
nop
LFQH_Lloh2104:
adr x19, LFQH_l_.str.9
LFQH_Lloh2105:
nop
LFQH_Lloh2106:
adr x4, LFQH_ReaderShelfWrapperLayout
LFQH_Lloh2107:
nop
mov	x1, x21
mov	x3, x19
bl	LFQH_Hook
LFQH_Lloh2108:
adr x23, LFQH_l_.str.191
LFQH_Lloh2109:
nop
LFQH_Lloh2110:
adr x1, LFQH_l_.str.192
LFQH_Lloh2111:
nop
LFQH_Lloh2112:
adr x2, LFQH_l_.str.193
LFQH_Lloh2113:
nop
LFQH_Lloh2114:
adr x22, LFQH_l_.str.113
LFQH_Lloh2115:
nop
LFQH_Lloh2116:
adr x4, LFQH_ReaderMenuShow
LFQH_Lloh2117:
nop
mov	x0, x23
mov	x3, x22
bl	LFQH_Hook
LFQH_Lloh2118:
adr x1, LFQH_l_.str.194
LFQH_Lloh2119:
nop
LFQH_Lloh2120:
adr x2, LFQH_l_.str.195
LFQH_Lloh2121:
nop
LFQH_Lloh2122:
adr x3, LFQH_l_.str.196
LFQH_Lloh2123:
nop
LFQH_Lloh2124:
adr x4, LFQH_ReaderBackdropTheme
LFQH_Lloh2125:
nop
mov	x0, x23
mov	x20, x3
bl	LFQH_Hook
LFQH_Lloh2126:
adr x1, LFQH_l_.str.197
LFQH_Lloh2127:
nop
LFQH_Lloh2128:
adr x2, LFQH_l_.str.198
LFQH_Lloh2129:
nop
LFQH_Lloh2130:
adr x4, LFQH_PageReaderCommunityRefresh
LFQH_Lloh2131:
nop
mov	x0, x23
mov	x3, x19
bl	LFQH_Hook
LFQH_Lloh2132:
adr x0, LFQH_l_.str.199
LFQH_Lloh2133:
nop
LFQH_Lloh2134:
adr x2, LFQH_l_.str.200
LFQH_Lloh2135:
nop
LFQH_Lloh2136:
adr x4, LFQH_PageReaderCommunityLayout
LFQH_Lloh2137:
nop
mov	x1, x21
mov	x3, x19
bl	LFQH_Hook
LFQH_Lloh2138:
adr x0, LFQH_l_.str.58
LFQH_Lloh2139:
nop
LFQH_Lloh2140:
adr x2, LFQH_l_.str.201
LFQH_Lloh2141:
nop
LFQH_Lloh2142:
adr x4, LFQH_PageBottomLayout
LFQH_Lloh2143:
nop
mov	x1, x21
mov	x3, x19
bl	LFQH_Hook
LFQH_Lloh2144:
adr x24, LFQH_l_.str.202
LFQH_Lloh2145:
nop
LFQH_Lloh2146:
adr x2, LFQH_l_.str.203
LFQH_Lloh2147:
nop
LFQH_Lloh2148:
adr x4, LFQH_PageProgressLayout
LFQH_Lloh2149:
nop
mov	x0, x24
mov	x1, x21
mov	x3, x19
bl	LFQH_Hook
LFQH_Lloh2150:
adr x1, LFQH_l_.str.204
LFQH_Lloh2151:
nop
LFQH_Lloh2152:
adr x2, LFQH_l_.str.205
LFQH_Lloh2153:
nop
LFQH_Lloh2154:
adr x23, LFQH_l_.str.186
LFQH_Lloh2155:
nop
LFQH_Lloh2156:
adr x4, LFQH_PageProgressTheme
LFQH_Lloh2157:
nop
mov	x0, x24
mov	x3, x23
bl	LFQH_Hook
LFQH_Lloh2158:
adr x0, LFQH_l_.str.206
LFQH_Lloh2159:
nop
LFQH_Lloh2160:
adr x2, LFQH_l_.str.207
LFQH_Lloh2161:
nop
LFQH_Lloh2162:
adr x4, LFQH_PageDivertLayout
LFQH_Lloh2163:
nop
mov	x1, x21
mov	x3, x19
bl	LFQH_Hook
LFQH_Lloh2164:
adr x0, LFQH_l_.str.208
LFQH_Lloh2165:
nop
LFQH_Lloh2166:
adr x2, LFQH_l_.str.209
LFQH_Lloh2167:
nop
LFQH_Lloh2168:
adr x4, LFQH_PageGiftLayout
LFQH_Lloh2169:
nop
mov	x1, x21
mov	x3, x19
bl	LFQH_Hook
LFQH_Lloh2170:
adr x0, LFQH_l_.str.210
LFQH_Lloh2171:
nop
LFQH_Lloh2172:
adr x2, LFQH_l_.str.211
LFQH_Lloh2173:
nop
LFQH_Lloh2174:
adr x4, LFQH_PageBookGiftLayout
LFQH_Lloh2175:
nop
mov	x1, x21
mov	x3, x19
bl	LFQH_Hook
LFQH_Lloh2176:
adr x0, LFQH_l_.str.212
LFQH_Lloh2177:
nop
LFQH_Lloh2178:
adr x2, LFQH_l_.str.213
LFQH_Lloh2179:
nop
LFQH_Lloh2180:
adr x4, LFQH_PageCoverListenLayout
LFQH_Lloh2181:
nop
mov	x1, x21
mov	x3, x19
bl	LFQH_Hook
LFQH_Lloh2182:
adr x24, LFQH_l_.str.214
LFQH_Lloh2183:
nop
LFQH_Lloh2184:
adr x1, LFQH_l_.str.215
LFQH_Lloh2185:
nop
LFQH_Lloh2186:
adr x2, LFQH_l_.str.216
LFQH_Lloh2187:
nop
LFQH_Lloh2188:
adr x4, LFQH_PageCoverGuideSetup
LFQH_Lloh2189:
nop
mov	x0, x24
mov	x3, x19
bl	LFQH_Hook
LFQH_Lloh2190:
adr x1, LFQH_l_.str.217
LFQH_Lloh2191:
nop
LFQH_Lloh2192:
adr x2, LFQH_l_.str.218
LFQH_Lloh2193:
nop
LFQH_Lloh2194:
adr x4, LFQH_PageCoverGuideLayout
LFQH_Lloh2195:
nop
mov	x0, x24
mov	x3, x19
bl	LFQH_Hook
LFQH_Lloh2196:
adr x0, LFQH_l_.str.219
LFQH_Lloh2197:
nop
LFQH_Lloh2198:
adr x2, LFQH_l_.str.220
LFQH_Lloh2199:
nop
LFQH_Lloh2200:
adr x4, LFQH_PageDiscussLayout
LFQH_Lloh2201:
nop
mov	x1, x21
mov	x3, x19
bl	LFQH_Hook
LFQH_Lloh2202:
adr x0, LFQH_l_.str.221
LFQH_Lloh2203:
nop
LFQH_Lloh2204:
adr x2, LFQH_l_.str.222
LFQH_Lloh2205:
nop
LFQH_Lloh2206:
adr x4, LFQH_PageDiscussButtonLayout
LFQH_Lloh2207:
nop
mov	x1, x21
mov	x3, x19
bl	LFQH_Hook
LFQH_Lloh2208:
adr x24, LFQH_l_.str.223
LFQH_Lloh2209:
nop
LFQH_Lloh2210:
adr x2, LFQH_l_.str.224
LFQH_Lloh2211:
nop
LFQH_Lloh2212:
adr x4, LFQH_PageChapterCardLayout
LFQH_Lloh2213:
nop
mov	x0, x24
mov	x1, x21
mov	x3, x19
bl	LFQH_Hook
LFQH_Lloh2214:
adr x1, LFQH_l_.str.225
LFQH_Lloh2215:
nop
LFQH_Lloh2216:
adr x2, LFQH_l_.str.226
LFQH_Lloh2217:
nop
LFQH_Lloh2218:
adr x4, LFQH_PageChapterCardTheme
LFQH_Lloh2219:
nop
mov	x0, x24
mov	x3, x23
bl	LFQH_Hook
LFQH_Lloh2220:
adr x0, LFQH_l_.str.227
LFQH_Lloh2221:
nop
LFQH_Lloh2222:
adr x2, LFQH_l_.str.228
LFQH_Lloh2223:
nop
LFQH_Lloh2224:
adr x4, LFQH_PageChapterButtonLayout
LFQH_Lloh2225:
nop
mov	x1, x21
mov	x3, x19
bl	LFQH_Hook
LFQH_Lloh2226:
adr x0, LFQH_l_.str.229
LFQH_Lloh2227:
nop
LFQH_Lloh2228:
adr x1, LFQH_l_.str.230
LFQH_Lloh2229:
nop
LFQH_Lloh2230:
adr x2, LFQH_l_.str.231
LFQH_Lloh2231:
nop
LFQH_Lloh2232:
adr x4, LFQH_PageChapterRewardTheme
LFQH_Lloh2233:
nop
mov	x3, x23
bl	LFQH_Hook
LFQH_Lloh2234:
adr x24, LFQH_l_.str.232
LFQH_Lloh2235:
nop
LFQH_Lloh2236:
adr x2, LFQH_l_.str.233
LFQH_Lloh2237:
nop
LFQH_Lloh2238:
adr x4, LFQH_PageShelfTabLayout
LFQH_Lloh2239:
nop
mov	x0, x24
mov	x1, x21
mov	x3, x19
bl	LFQH_Hook
LFQH_Lloh2240:
adr x1, LFQH_l_.str.234
LFQH_Lloh2241:
nop
LFQH_Lloh2242:
adr x2, LFQH_l_.str.235
LFQH_Lloh2243:
nop
LFQH_Lloh2244:
adr x4, LFQH_PageShelfTabReload
LFQH_Lloh2245:
nop
mov	x0, x24
mov	x3, x23
bl	LFQH_Hook
LFQH_Lloh2246:
adr x24, LFQH_l_.str.236
LFQH_Lloh2247:
nop
LFQH_Lloh2248:
adr x2, LFQH_l_.str.237
LFQH_Lloh2249:
nop
LFQH_Lloh2250:
adr x4, LFQH_PageShelfFilterLayout
LFQH_Lloh2251:
nop
mov	x0, x24
mov	x1, x21
mov	x3, x19
bl	LFQH_Hook
LFQH_Lloh2252:
adr x1, LFQH_l_.str.238
LFQH_Lloh2253:
nop
LFQH_Lloh2254:
adr x2, LFQH_l_.str.239
LFQH_Lloh2255:
nop
LFQH_Lloh2256:
adr x4, LFQH_PageShelfFilterAppearance
LFQH_Lloh2257:
nop
mov	x0, x24
mov	x3, x22
bl	LFQH_Hook
LFQH_Lloh2258:
adr x1, LFQH_l_.str.240
LFQH_Lloh2259:
nop
LFQH_Lloh2260:
adr x2, LFQH_l_.str.241
LFQH_Lloh2261:
nop
LFQH_Lloh2262:
adr x4, LFQH_PageShelfFilterBackground
LFQH_Lloh2263:
nop
mov	x0, x24
mov	x3, x23
bl	LFQH_Hook
LFQH_Lloh2264:
adr x24, LFQH_l_.str.109
LFQH_Lloh2265:
nop
LFQH_Lloh2266:
adr x2, LFQH_l_.str.110
LFQH_Lloh2267:
nop
LFQH_Lloh2268:
adr x4, LFQH_ShelfFilterHeaderLayout
LFQH_Lloh2269:
nop
mov	x0, x24
mov	x1, x21
mov	x3, x19
bl	LFQH_Hook
LFQH_Lloh2270:
adr x1, LFQH_l_.str.242
LFQH_Lloh2271:
nop
LFQH_Lloh2272:
adr x2, LFQH_l_.str.243
LFQH_Lloh2273:
nop
LFQH_Lloh2274:
adr x25, LFQH_ShelfFilterHeaderConfigure
LFQH_Lloh2275:
nop
mov	x0, x24
mov	x3, x20
mov	x4, x25
bl	LFQH_Hook
LFQH_Lloh2276:
adr x1, LFQH_l_.str.244
LFQH_Lloh2277:
nop
LFQH_Lloh2278:
adr x2, LFQH_l_.str.245
LFQH_Lloh2279:
nop
mov	x0, x24
mov	x3, x20
mov	x4, x25
bl	LFQH_Hook
LFQH_Lloh2280:
adr x0, LFQH_l_.str.246
LFQH_Lloh2281:
nop
LFQH_Lloh2282:
adr x1, LFQH_l_.str.247
LFQH_Lloh2283:
nop
LFQH_Lloh2284:
adr x2, LFQH_l_.str.248
LFQH_Lloh2285:
nop
LFQH_Lloh2286:
adr x3, LFQH_l_.str.249
LFQH_Lloh2287:
nop
LFQH_Lloh2288:
adr x4, LFQH_ShelfInlineFilterInsets
LFQH_Lloh2289:
nop
bl	LFQH_Hook
LFQH_Lloh2290:
adr x0, LFQH_l_.str.250
LFQH_Lloh2291:
nop
LFQH_Lloh2292:
adr x2, LFQH_l_.str.251
LFQH_Lloh2293:
nop
LFQH_Lloh2294:
adr x4, LFQH_PageProfileBarLayout
LFQH_Lloh2295:
nop
mov	x1, x21
mov	x3, x19
bl	LFQH_Hook
LFQH_Lloh2296:
adr x24, LFQH_l_.str.252
LFQH_Lloh2297:
nop
LFQH_Lloh2298:
adr x25, LFQH_l_.str.253
LFQH_Lloh2299:
nop
LFQH_Lloh2300:
adr x26, LFQH_PublishLayout
LFQH_Lloh2301:
nop
mov	x0, x24
mov	x1, x21
mov	x2, x25
mov	x3, x19
mov	x4, x26
bl	LFQH_Hook
LFQH_Lloh2302:
adr x27, LFQH_l_.str.254
LFQH_Lloh2303:
nop
LFQH_Lloh2304:
adr x28, LFQH_l_.str.255
LFQH_Lloh2305:
nop
LFQH_Lloh2306:
adr x20, LFQH_PublishTheme
LFQH_Lloh2307:
nop
mov	x0, x24
mov	x1, x27
mov	x2, x28
mov	x3, x23
mov	x4, x20
bl	LFQH_Hook
LFQH_Lloh2308:
adr x24, LFQH_l_.str.256
LFQH_Lloh2309:
nop
mov	x0, x24
mov	x1, x21
mov	x2, x25
mov	x3, x19
mov	x4, x26
bl	LFQH_Hook
mov	x0, x24
mov	x1, x27
mov	x2, x28
mov	x3, x23
mov	x4, x20
bl	LFQH_Hook
LFQH_Lloh2310:
adr x20, LFQH_l_.str.257
LFQH_Lloh2311:
nop
LFQH_Lloh2312:
adr x1, LFQH_l_.str.258
LFQH_Lloh2313:
nop
LFQH_Lloh2314:
adr x2, LFQH_l_.str.259
LFQH_Lloh2315:
nop
LFQH_Lloh2316:
adr x4, LFQH_BookstorePublishButton
LFQH_Lloh2317:
nop
mov	x0, x20
mov	x3, x23
bl	LFQH_Hook
LFQH_Lloh2318:
adr x1, LFQH_l_.str.260
LFQH_Lloh2319:
nop
LFQH_Lloh2320:
adr x2, LFQH_l_.str.261
LFQH_Lloh2321:
nop
LFQH_Lloh2322:
adr x4, LFQH_BookstoreProduceEntrance
LFQH_Lloh2323:
nop
mov	x0, x20
mov	x3, x23
bl	LFQH_Hook
LFQH_Lloh2324:
adr x0, LFQH_l_.str.262
LFQH_Lloh2325:
nop
LFQH_Lloh2326:
adr x1, LFQH_l_.str.263
LFQH_Lloh2327:
nop
LFQH_Lloh2328:
adr x2, LFQH_l_.str.264
LFQH_Lloh2329:
nop
LFQH_Lloh2330:
adr x4, LFQH_BookstoreComponentPublishButton
LFQH_Lloh2331:
nop
mov	x3, x23
bl	LFQH_Hook
LFQH_Lloh2332:
adr x23, LFQH_l_.str.265
LFQH_Lloh2333:
nop
LFQH_Lloh2334:
adr x1, LFQH_l_.str.266
LFQH_Lloh2335:
nop
LFQH_Lloh2336:
adr x2, LFQH_l_.str.267
LFQH_Lloh2337:
nop
LFQH_Lloh2338:
adr x3, LFQH_l_.str.11
LFQH_Lloh2339:
nop
LFQH_Lloh2340:
adr x4, LFQH_ProfilePublishButton
LFQH_Lloh2341:
nop
mov	x0, x23
bl	LFQH_Hook
LFQH_Lloh2342:
adr x20, LFQH_l_.str.118
LFQH_Lloh2343:
nop
LFQH_Lloh2344:
adr x1, LFQH_l_.str.268
LFQH_Lloh2345:
nop
LFQH_Lloh2346:
adr x2, LFQH_l_.str.269
LFQH_Lloh2347:
nop
LFQH_Lloh2348:
adr x4, LFQH_ProfileCollectionLayout
LFQH_Lloh2349:
nop
mov	x0, x20
mov	x3, x19
bl	LFQH_Hook
LFQH_Lloh2350:
adr x0, LFQH_l_.str.270
LFQH_Lloh2351:
nop
LFQH_Lloh2352:
adr x2, LFQH_l_.str.271
LFQH_Lloh2353:
nop
LFQH_Lloh2354:
adr x4, LFQH_PageProfileEntryLayout
LFQH_Lloh2355:
nop
mov	x1, x21
mov	x3, x19
bl	LFQH_Hook
LFQH_Lloh2356:
adr x0, LFQH_l_.str.272
LFQH_Lloh2357:
nop
LFQH_Lloh2358:
adr x2, LFQH_l_.str.273
LFQH_Lloh2359:
nop
LFQH_Lloh2360:
adr x4, LFQH_PageProfileOrderLayout
LFQH_Lloh2361:
nop
mov	x1, x21
mov	x3, x19
bl	LFQH_Hook
LFQH_Lloh2362:
adr x1, LFQH_l_.str.274
LFQH_Lloh2363:
nop
LFQH_Lloh2364:
adr x2, LFQH_l_.str.275
LFQH_Lloh2365:
nop
LFQH_Lloh2366:
adr x4, LFQH_MiniGameSetup
LFQH_Lloh2367:
nop
mov	x0, x20
mov	x3, x19
bl	LFQH_Hook
LFQH_Lloh2368:
adr x0, LFQH_l_.str.276
LFQH_Lloh2369:
nop
LFQH_Lloh2370:
adr x1, LFQH_l_.str.277
LFQH_Lloh2371:
nop
LFQH_Lloh2372:
adr x2, LFQH_l_.str.278
LFQH_Lloh2373:
nop
LFQH_Lloh2374:
adr x3, LFQH_l_.str.279
LFQH_Lloh2375:
nop
LFQH_Lloh2376:
adr x4, LFQH_MineConfiguredEntrances
LFQH_Lloh2377:
nop
bl	LFQH_Hook
LFQH_Lloh2378:
adr x1, LFQH_l_.str.280
LFQH_Lloh2379:
nop
LFQH_Lloh2380:
adr x2, LFQH_l_.str.281
LFQH_Lloh2381:
nop
LFQH_Lloh2382:
adr x3, LFQH_l_.str.123
LFQH_Lloh2383:
nop
LFQH_Lloh2384:
adr x4, LFQH_MineListObjects
LFQH_Lloh2385:
nop
mov	x0, x23
bl	LFQH_Hook
LFQH_Lloh2386:
adr x20, LFQH_l_.str.21
LFQH_Lloh2387:
nop
LFQH_Lloh2388:
adr x1, LFQH_l_.str.282
LFQH_Lloh2389:
nop
LFQH_Lloh2390:
adr x2, LFQH_l_.str.283
LFQH_Lloh2391:
nop
LFQH_Lloh2392:
adr x4, LFQH_ShelfDurationVisible
LFQH_Lloh2393:
nop
mov	x0, x20
mov	x3, x22
bl	LFQH_Hook
LFQH_Lloh2394:
adr x2, LFQH_l_.str.105
LFQH_Lloh2395:
nop
LFQH_Lloh2396:
adr x4, LFQH_ShelfDurationLayout
LFQH_Lloh2397:
nop
mov	x0, x20
mov	x1, x21
mov	x3, x19
bl	LFQH_Hook
LFQH_Lloh2398:
adr x1, LFQH_l_.str.284
LFQH_Lloh2399:
nop
LFQH_Lloh2400:
adr x2, LFQH_l_.str.285
LFQH_Lloh2401:
nop
LFQH_Lloh2402:
adr x4, LFQH_ShelfLegacyFilterShow
LFQH_Lloh2403:
nop
mov	x0, x20
mov	x3, x22
bl	LFQH_Hook
LFQH_Lloh2404:
adr x1, LFQH_l_.str.286
LFQH_Lloh2405:
nop
LFQH_Lloh2406:
adr x2, LFQH_l_.str.287
LFQH_Lloh2407:
nop
LFQH_Lloh2408:
adr x4, LFQH_ShelfStockEditLayout
LFQH_Lloh2409:
nop
mov	x0, x20
mov	x3, x19
bl	LFQH_Hook
LFQH_Lloh2410:
adr x19, LFQH_l_.str.288
LFQH_Lloh2411:
nop
LFQH_Lloh2412:
adr x1, LFQH_l_.str.289
LFQH_Lloh2413:
nop
LFQH_Lloh2414:
adr x2, LFQH_l_.str.290
LFQH_Lloh2415:
nop
LFQH_Lloh2416:
adr x4, LFQH_ShelfSaveOpeningData
LFQH_Lloh2417:
nop
mov	x0, x19
LFQH_Lloh2418:
adr x3, LFQH_l_.str.196
LFQH_Lloh2419:
nop
bl	LFQH_Hook
LFQH_Lloh2420:
adr x1, LFQH_l_.str.291
LFQH_Lloh2421:
nop
LFQH_Lloh2422:
adr x2, LFQH_l_.str.292
LFQH_Lloh2423:
nop
LFQH_Lloh2424:
adr x3, LFQH_l_.str.293
LFQH_Lloh2425:
nop
LFQH_Lloh2426:
adr x4, LFQH_ShelfCoverTransitionInfo
LFQH_Lloh2427:
nop
mov	x0, x19
bl	LFQH_Hook
LFQH_Lloh2428:
adr x0, LFQH_l_.str.820
LFQH_Lloh2429:
nop
bl Lpatch + (0xa5b0 - PATCH_BASE)
mov	x20, x0
mov	x0, x19
bl Lpatch + (0xa5b0 - PATCH_BASE)
mov	x19, x0
LFQH_Lloh2430:
adr x0, LFQH_l_.str.821
LFQH_Lloh2431:
nop
bl Lpatch + (0xa5b0 - PATCH_BASE)
LFQH_Lloh2432:
adr x1, LFQH_l_.str.822
LFQH_Lloh2433:
nop
LFQH_Lloh2434:
adr x2, LFQH_l_.str.823
LFQH_Lloh2435:
nop
bl	LFQH_ClassABI
cbz	w0, LFQH_LBB82_41
LFQH_Lloh2436:
adr x0, LFQH_l_.str.21
LFQH_Lloh2437:
nop
bl Lpatch + (0xa5b0 - PATCH_BASE)
LFQH_Lloh2438:
adr x1, LFQH_l_.str.527
LFQH_Lloh2439:
nop
LFQH_Lloh2440:
adr x2, LFQH_l_.str.149
LFQH_Lloh2441:
nop
bl	LFQH_ClassABI
cbz	w0, LFQH_LBB82_41
LFQH_Lloh2442:
adr x1, LFQH_l_.str.824
LFQH_Lloh2443:
nop
LFQH_Lloh2444:
adr x2, LFQH_l_.str.149
LFQH_Lloh2445:
nop
mov	x0, x20
bl	LFQH_ClassABI
cbz	w0, LFQH_LBB82_41
mov	x0, x20
bl Lpatch + (0xa664 - PATCH_BASE)
LFQH_Lloh2446:
adr x1, LFQH_l_.str.825
LFQH_Lloh2447:
nop
LFQH_Lloh2448:
adr x2, LFQH_l_.str.826
LFQH_Lloh2449:
nop
bl	LFQH_ClassABI
cbz	w0, LFQH_LBB82_41
LFQH_Lloh2450:
adr x20, LFQH_l_.str.288
LFQH_Lloh2451:
nop
LFQH_Lloh2452:
adr x1, LFQH_l_.str.827
LFQH_Lloh2453:
nop
LFQH_Lloh2454:
adr x21, LFQH_l_.str.828
LFQH_Lloh2455:
nop
LFQH_Lloh2456:
adr x3, LFQH_l_.str.829
LFQH_Lloh2457:
nop
LFQH_Lloh2458:
adr x4, LFQH_ShelfFunctionSize
LFQH_Lloh2459:
nop
mov	x0, x20
mov	x2, x21
bl	LFQH_Hook
LFQH_Lloh2460:
adr x1, LFQH_l_.str.247
LFQH_Lloh2461:
nop
LFQH_Lloh2462:
adr x2, LFQH_l_.str.830
LFQH_Lloh2463:
nop
LFQH_Lloh2464:
adr x3, LFQH_l_.str.249
LFQH_Lloh2465:
nop
LFQH_Lloh2466:
adr x4, LFQH_ShelfFunctionInsets
LFQH_Lloh2467:
nop
mov	x0, x20
bl	LFQH_Hook
mov	x0, x21
bl Lpatch + (0xa5a4 - PATCH_BASE)
mov	x1, x0
mov	x0, x19
bl Lpatch + (0xa5f8 - PATCH_BASE)
cbz	x0, LFQH_LBB82_41
LFQH_Lloh2468:
adr x0, LFQH_l_.str.830
LFQH_Lloh2469:
nop
bl Lpatch + (0xa5a4 - PATCH_BASE)
mov	x1, x0
mov	x0, x19
bl Lpatch + (0xa5f8 - PATCH_BASE)
cbz	x0, LFQH_LBB82_41
LFQH_Lloh2470:
adr x0, LFQH_l_.str.820
LFQH_Lloh2471:
nop
LFQH_Lloh2472:
adr x1, LFQH_l_.str.831
LFQH_Lloh2473:
nop
LFQH_Lloh2474:
adr x2, LFQH_l_.str.530
LFQH_Lloh2475:
nop
LFQH_Lloh2476:
adr x3, LFQH_l_.str.9
LFQH_Lloh2477:
nop
LFQH_Lloh2478:
adr x4, LFQH_ShelfFunctionLayout
LFQH_Lloh2479:
nop
bl	LFQH_Hook
LFQH_LBB82_41:
LFQH_Lloh2480:
adr x0, LFQH_l_.str.835
LFQH_Lloh2481:
nop
bl Lpatch + (0xa5b0 - PATCH_BASE)
cbz	x0, LFQH_LBB82_46
mov	x20, x0
bl	LFQH_FQHGlassAvailable
cbz	w0, LFQH_LBB82_45
LFQH_Lloh2482:
adr x0, LFQH_l_.str.835
LFQH_Lloh2483:
nop
bl Lpatch + (0xa5b0 - PATCH_BASE)
LFQH_Lloh2484:
adr x1, LFQH_l_.str.837
LFQH_Lloh2485:
nop
LFQH_Lloh2486:
adr x2, LFQH_l_.str.641
LFQH_Lloh2487:
nop
bl	LFQH_ClassABI
cbz	w0, LFQH_LBB82_45
LFQH_Lloh2488:
adr x0, LFQH_l_.str.835
LFQH_Lloh2489:
nop
LFQH_Lloh2490:
adr x1, LFQH_l_.str.838
LFQH_Lloh2491:
nop
LFQH_Lloh2492:
adr x2, LFQH_l_.str.836
LFQH_Lloh2493:
nop
LFQH_Lloh2494:
adr x3, LFQH_l_.str.11
LFQH_Lloh2495:
nop
LFQH_Lloh2496:
adr x4, LFQH_DramaDockBackground
LFQH_Lloh2497:
nop
bl	LFQH_Hook
LFQH_LBB82_45:
LFQH_Lloh2498:
adr x0, LFQH_l_.str.88
LFQH_Lloh2499:
nop
bl Lpatch + (0xa5b0 - PATCH_BASE)
mov	x19, x0
LFQH_Lloh2500:
adr x0, LFQH_l_.str.89
LFQH_Lloh2501:
nop
bl Lpatch + (0xa5a4 - PATCH_BASE)
mov	x1, x0
mov	x0, x19
bl Lpatch + (0xa5d4 - PATCH_BASE)
mov	x19, x0
LFQH_Lloh2502:
adr x0, LFQH_l_.str.836
LFQH_Lloh2503:
nop
bl Lpatch + (0xa5a4 - PATCH_BASE)
mov	x1, x0
mov	x0, x20
bl Lpatch + (0xa5f8 - PATCH_BASE)
cmp	x0, #0
cset	w20, ne
LFQH_Lloh2504:
adr x21, LFQH_l_.str.497
LFQH_Lloh2505:
nop
mov	x0, x21
bl Lpatch + (0xa5b0 - PATCH_BASE)
mov	x22, x0
LFQH_Lloh2506:
adr x23, LFQH_l_.str.499
LFQH_Lloh2507:
nop
mov	x0, x23
bl Lpatch + (0xa5a4 - PATCH_BASE)
mov	x1, x0
mov	x0, x22
mov	x2, x20
bl Lpatch + (0xa5d4 - PATCH_BASE)
mov	x2, x0
LFQH_Lloh2508:
adr x1, LFQH_l_.str.839
LFQH_Lloh2509:
nop
mov	x0, x19
bl	LFQH_Put
LFQH_Lloh2510:
adr x0, LFQH_l_.str.361
LFQH_Lloh2511:
nop
bl Lpatch + (0xa5b0 - PATCH_BASE)
mov	x20, x0
LFQH_Lloh2512:
adr x0, LFQH_l_.str.387
LFQH_Lloh2513:
nop
bl Lpatch + (0xa5a4 - PATCH_BASE)
mov	x1, x0
LFQH_Lloh2514:
adr x2, LFQH_l_.str.840
LFQH_Lloh2515:
nop
mov	x0, x20
bl Lpatch + (0xa5d4 - PATCH_BASE)
mov	x2, x0
LFQH_Lloh2516:
adr x1, LFQH_l_.str.92
LFQH_Lloh2517:
nop
mov	x0, x19
bl	LFQH_Put
mov	x0, x21
bl Lpatch + (0xa5b0 - PATCH_BASE)
mov	x20, x0
mov	x0, x23
bl Lpatch + (0xa5a4 - PATCH_BASE)
mov	x1, x0
mov	x0, x20
mov	w2, #0
bl Lpatch + (0xa5d4 - PATCH_BASE)
mov	x2, x0
LFQH_Lloh2518:
adr x1, LFQH_l_.str.841
LFQH_Lloh2519:
nop
mov	x0, x19
bl	LFQH_Put
LFQH_Lloh2520:
adr x0, LFQH_l_.str.842
LFQH_Lloh2521:
nop
mov	x1, x19
bl Lrecord_named
LFQH_LBB82_46:
LFQH_Lloh2522:
adr x19, LFQH_l_.str.121
LFQH_Lloh2523:
nop
LFQH_Lloh2524:
adr x1, LFQH_l_.str.294
LFQH_Lloh2525:
nop
LFQH_Lloh2526:
adr x2, LFQH_l_.str.295
LFQH_Lloh2527:
nop
LFQH_Lloh2528:
adr x3, LFQH_l_.str.11
LFQH_Lloh2529:
nop
LFQH_Lloh2530:
adr x4, LFQH_TabPlan
LFQH_Lloh2531:
nop
mov	x0, x19
bl	LFQH_Hook
LFQH_Lloh2532:
adr x1, LFQH_l_.str.296
LFQH_Lloh2533:
nop
LFQH_Lloh2534:
adr x2, LFQH_l_.str.297
LFQH_Lloh2535:
nop
LFQH_Lloh2536:
adr x3, LFQH_l_.str.113
LFQH_Lloh2537:
nop
LFQH_Lloh2538:
adr x4, LFQH_TabOwnerAppear
LFQH_Lloh2539:
nop
mov	x0, x19
ldp	x29, x30, [sp, #80]
ldp	x20, x19, [sp, #64]
ldp	x22, x21, [sp, #48]
ldp	x24, x23, [sp, #32]
ldp	x26, x25, [sp, #16]
ldp	x28, x27, [sp], #96
b	LFQH_Hook
.cfi_endproc
.p2align	2
LFQH_DramaCommentLayout:
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
LFQH_Lloh2540:
adr x0, LFQH_l_.str.64
LFQH_Lloh2541:
nop
LFQH_Lloh2542:
adr x1, LFQH_l_.str.179
LFQH_Lloh2543:
nop
bl	LFQH_Original
mov	x8, x0
mov	x0, x20
mov	x1, x19
blr	x8
LFQH_Lloh2544:
adr x1, LFQH_l_.str.62
LFQH_Lloh2545:
nop
mov	x0, x20
ldp	x29, x30, [sp, #16]
ldp	x20, x19, [sp], #32
b	LFQH_FQHDramaGlyph
.cfi_endproc
.p2align	2
LFQH_DramaLikeVisibility:
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
LFQH_Lloh2546:
adr x0, LFQH_l_.str.66
LFQH_Lloh2547:
nop
LFQH_Lloh2548:
adr x1, LFQH_l_.str.181
LFQH_Lloh2549:
nop
bl	LFQH_Original
mov	x8, x0
mov	x0, x21
mov	x1, x20
mov	x2, x19
blr	x8
LFQH_Lloh2550:
adr x1, LFQH_DramaGlassKey
LFQH_Lloh2551:
nop
mov	x0, x21
bl Lpatch + (0xa628 - PATCH_BASE)
cbz	x0, LFQH_LBB84_2
mov	x20, x0
LFQH_Lloh2552:
adr x0, LFQH_l_.str.72
LFQH_Lloh2553:
nop
bl Lpatch + (0xa5a4 - PATCH_BASE)
mov	x1, x0
mov	x0, x20
mov	x2, x19
ldp	x29, x30, [sp, #32]
ldp	x20, x19, [sp, #16]
ldp	x22, x21, [sp], #48
b Lpatch + (0xa5d4 - PATCH_BASE)
LFQH_LBB84_2:
ldp	x29, x30, [sp, #32]
ldp	x20, x19, [sp, #16]
ldp	x22, x21, [sp], #48
ret
.cfi_endproc
.p2align	2
LFQH_DramaWatchLayout:
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
LFQH_Lloh2554:
adr x0, LFQH_l_.str.182
LFQH_Lloh2555:
nop
LFQH_Lloh2556:
adr x1, LFQH_l_.str.183
LFQH_Lloh2557:
nop
bl	LFQH_Original
mov	x8, x0
mov	x0, x20
mov	x1, x19
blr	x8
LFQH_Lloh2558:
adr x1, LFQH_l_.str.678
LFQH_Lloh2559:
nop
mov	x0, x20
bl	LFQH_Get
mov	x1, x0
mov	x0, x20
bl	LFQH_DramaWatchGlass
mov	x0, x20
ldp	x29, x30, [sp, #16]
ldp	x20, x19, [sp], #32
b	LFQH_DramaSpacingForEntry178R2
.cfi_endproc
.p2align	2
LFQH_DramaWatchRender:
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
LFQH_Lloh2560:
adr x0, LFQH_l_.str.182
LFQH_Lloh2561:
nop
LFQH_Lloh2562:
adr x1, LFQH_l_.str.185
LFQH_Lloh2563:
nop
bl	LFQH_Original
mov	x8, x0
mov	x0, x21
mov	x1, x20
mov	x2, x19
blr	x8
mov	x0, x21
mov	x1, x19
bl	LFQH_DramaWatchGlass
mov	x0, x21
ldp	x29, x30, [sp, #32]
ldp	x20, x19, [sp, #16]
ldp	x22, x21, [sp], #48
b	LFQH_DramaSpacingForEntry178R2
.cfi_endproc
.p2align	2
LFQH_DramaWatchAlbumLayout:
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
mov	x20, x1
mov	x19, x0
LFQH_Lloh2564:
adr x0, LFQH_l_.str.187
LFQH_Lloh2565:
nop
LFQH_Lloh2566:
adr x1, LFQH_l_.str.188
LFQH_Lloh2567:
nop
bl	LFQH_Original
mov	x8, x0
mov	x0, x19
mov	x1, x20
blr	x8
LFQH_Lloh2568:
adr x1, LFQH_l_.str.687
LFQH_Lloh2569:
nop
mov	x0, x19
bl	LFQH_Get
mov	x20, x0
LFQH_Lloh2570:
adr x0, LFQH_l_.str.20
LFQH_Lloh2571:
nop
bl Lpatch + (0xa5a4 - PATCH_BASE)
mov	x1, x0
mov	x0, x20
bl Lpatch + (0xa5d4 - PATCH_BASE)
cmp	x0, x19
b.eq	LFQH_LBB87_2
ldp	x29, x30, [sp, #48]
ldp	x20, x19, [sp, #32]
ldp	d9, d8, [sp, #16]
ldp	d11, d10, [sp], #64
ret
LFQH_LBB87_2:
LFQH_Lloh2572:
adr x0, LFQH_l_.str.24
LFQH_Lloh2573:
nop
bl Lpatch + (0xa5a4 - PATCH_BASE)
mov	x1, x0
mov	x0, x20
bl Lpatch + (0xa5d4 - PATCH_BASE)
fmov	d11, d0
fmov	d10, d1
fmov	d9, d2
fmov	d8, d3
bl	LFQH_Enabled
cbz	w0, LFQH_LBB87_13
bl	LFQH_FQHGlassAvailable
cbz	w0, LFQH_LBB87_13
LFQH_Lloh2574:
adr x1, LFQH_l_.str.508
LFQH_Lloh2575:
nop
mov	x0, x19
bl	LFQH_Get
cbz	x0, LFQH_LBB87_13
fmov	d0, #8.00000000
fadd	d0, d11, d0
fmov	d1, #3.00000000
fadd	d1, d10, d1
fmov	d2, #-16.00000000
fadd	d2, d9, d2
fmov	x8, d0
fmov	x9, d1
fmov	x10, d2
and	x11, x8, #0x7fffffffffffffff
and	x8, x9, #0x7fffffffffffffff
mov	x12, #9218868437227405311
cmp	x8, x12
cset	w8, gt
and	x9, x10, #0x7fffffffffffffff
cmp	x9, x12
cset	w9, gt
cmp	x11, x12
b.gt	LFQH_LBB87_13
tbnz	w8, #0, LFQH_LBB87_13
tbnz	w9, #0, LFQH_LBB87_13
fmov	d3, #-6.00000000
fadd	d3, d8, d3
fmov	x8, d3
and	x8, x8, #0x7fffffffffffffff
mov	x9, #9218868437227405311
cmp	x8, x9
b.gt	LFQH_LBB87_13
fcmp	d2, #0.0
b.le	LFQH_LBB87_13
fcmp	d3, #0.0
b.le	LFQH_LBB87_13
mov	x0, x20
mov	x1, x20
mov	x2, #0
bl	LFQH_PlaceDramaGlass
cbz	x0, LFQH_LBB87_15
mov	w1, #1
b	LFQH_LBB87_14
LFQH_LBB87_13:
mov	x0, x20
bl	LFQH_RemoveDramaGlass
mov	w1, #0
LFQH_LBB87_14:
mov	x0, x20
bl	LFQH_DramaClearBackground
LFQH_LBB87_15:
mov	x0, x19
ldp	x29, x30, [sp, #48]
ldp	x20, x19, [sp, #32]
ldp	d9, d8, [sp, #16]
ldp	d11, d10, [sp], #64
b	LFQH_DramaSpacingForEntry178R2
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
LFQH_Lloh2576:
adr x0, LFQH_l_.str.189
LFQH_Lloh2577:
nop
LFQH_Lloh2578:
adr x1, LFQH_l_.str.190
LFQH_Lloh2579:
nop
bl	LFQH_Original
mov	x8, x0
mov	x0, x19
mov	x1, x20
blr	x8
LFQH_Lloh2580:
adr x1, LFQH_l_.str.363
LFQH_Lloh2581:
nop
mov	x0, x19
bl	LFQH_Get
mov	x20, x0
LFQH_Lloh2582:
adr x0, LFQH_l_.str.20
LFQH_Lloh2583:
nop
bl Lpatch + (0xa5a4 - PATCH_BASE)
mov	x1, x0
mov	x0, x19
bl Lpatch + (0xa5d4 - PATCH_BASE)
LFQH_Lloh2584:
adr x1, LFQH_l_.str.37
LFQH_Lloh2585:
nop
bl	LFQH_Kind
cbz	w0, LFQH_LBB88_5
LFQH_Lloh2586:
adr x1, LFQH_l_.str.36
LFQH_Lloh2587:
nop
mov	x0, x20
bl	LFQH_Kind
cbz	w0, LFQH_LBB88_5
LFQH_Lloh2588:
adr x0, LFQH_l_.str.20
LFQH_Lloh2589:
nop
bl Lpatch + (0xa5a4 - PATCH_BASE)
mov	x1, x0
mov	x0, x20
bl Lpatch + (0xa5d4 - PATCH_BASE)
mov	x21, #0
cmp	x0, x19
b.ne	LFQH_LBB88_6
cbz	x20, LFQH_LBB88_6
mov	x0, x20
mov	w1, #8
bl	LFQH_Icon
mov	x21, x20
b	LFQH_LBB88_6
LFQH_LBB88_5:
mov	x21, #0
LFQH_LBB88_6:
LFQH_Lloh2590:
adr x1, LFQH_IconGlassKey
LFQH_Lloh2591:
nop
mov	x0, x21
bl Lpatch + (0xa628 - PATCH_BASE)
mov	x20, x0
cmp	x0, #0
csel	x2, xzr, x21, eq
LFQH_Lloh2592:
adr x1, LFQH_ReaderShelfLabelKey
LFQH_Lloh2593:
nop
mov	x0, x19
bl	LFQH_TrackReaderLabel
cbz	x20, LFQH_LBB88_8
LFQH_Lloh2594:
adr x0, LFQH_l_.str.391
LFQH_Lloh2595:
nop
bl Lpatch + (0xa5a4 - PATCH_BASE)
mov	x1, x0
mov	x0, x19
bl Lpatch + (0xa5d4 - PATCH_BASE)
mov	x21, x0
LFQH_Lloh2596:
adr x0, LFQH_l_.str.392
LFQH_Lloh2597:
nop
bl Lpatch + (0xa5a4 - PATCH_BASE)
mov	x1, x0
mov	x0, x19
bl Lpatch + (0xa5d4 - PATCH_BASE)
mov	x2, x0
mov	x0, x19
mov	x1, x21
bl	LFQH_PrepareOwner
LFQH_Lloh2598:
adr x0, LFQH_l_.str.372
LFQH_Lloh2599:
nop
bl Lpatch + (0xa5a4 - PATCH_BASE)
mov	x1, x0
mov	x0, x20
bl Lpatch + (0xa5d4 - PATCH_BASE)
mov	x0, x19
ldp	x29, x30, [sp, #32]
ldp	x20, x19, [sp, #16]
ldp	x22, x21, [sp], #48
b	LFQH_EnsureHit
LFQH_LBB88_8:
mov	x0, x19
bl	LFQH_RestoreOwner
mov	x0, x19
ldp	x29, x30, [sp, #32]
ldp	x20, x19, [sp, #16]
ldp	x22, x21, [sp], #48
b	LFQH_RestoreHit
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
LFQH_Lloh2600:
adr x0, LFQH_l_.str.191
LFQH_Lloh2601:
nop
LFQH_Lloh2602:
adr x1, LFQH_l_.str.193
LFQH_Lloh2603:
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
mov	x22, x3
mov	x21, x2
mov	x20, x1
mov	x19, x0
LFQH_Lloh2604:
adr x0, LFQH_l_.str.191
LFQH_Lloh2605:
nop
LFQH_Lloh2606:
adr x1, LFQH_l_.str.195
LFQH_Lloh2607:
nop
bl	LFQH_Original
mov	x8, x0
mov	x0, x19
mov	x1, x20
mov	x2, x21
mov	x3, x22
blr	x8
LFQH_Lloh2608:
adr x1, LFQH_ReaderThemePendingKey
LFQH_Lloh2609:
nop
mov	x0, x19
bl Lpatch + (0xa628 - PATCH_BASE)
cbz	x0, LFQH_LBB90_7
mov	x20, x0
mov	w0, #11
bl	LFQH_PageOptionEnabled
cbz	w0, LFQH_LBB90_7
LFQH_Lloh2610:
adr x1, LFQH_l_.str.661
LFQH_Lloh2611:
nop
mov	x0, x22
bl	LFQH_Kind
cbz	w0, LFQH_LBB90_7
LFQH_Lloh2612:
adr x0, LFQH_l_.str.662
LFQH_Lloh2613:
nop
bl Lpatch + (0xa5a4 - PATCH_BASE)
mov	x1, x0
mov	x0, x22
bl Lpatch + (0xa5d4 - PATCH_BASE)
cbz	w0, LFQH_LBB90_7
LFQH_Lloh2614:
adr x1, LFQH_l_.str.672
LFQH_Lloh2615:
nop
mov	x0, x21
bl	LFQH_Get
cmp	x20, x0
b.eq	LFQH_LBB90_6
mov	x21, x0
LFQH_Lloh2616:
adr x0, LFQH_l_.str.49
LFQH_Lloh2617:
nop
bl Lpatch + (0xa5a4 - PATCH_BASE)
mov	x1, x0
mov	x0, x20
mov	x2, x21
bl Lpatch + (0xa5d4 - PATCH_BASE)
cbz	w0, LFQH_LBB90_7
LFQH_LBB90_6:
LFQH_Lloh2618:
adr x0, LFQH_l_.str.467
LFQH_Lloh2619:
nop
bl Lpatch + (0xa5b0 - PATCH_BASE)
mov	x21, x0
LFQH_Lloh2620:
adr x0, LFQH_l_.str.468
LFQH_Lloh2621:
nop
bl Lpatch + (0xa5a4 - PATCH_BASE)
mov	x1, x0
mov	x0, x21
bl Lpatch + (0xa5d4 - PATCH_BASE)
mov	x21, x0
LFQH_Lloh2622:
adr x0, LFQH_l_.str.514
LFQH_Lloh2623:
nop
bl Lpatch + (0xa5a4 - PATCH_BASE)
mov	x22, x0
LFQH_Lloh2624:
adr x0, LFQH_l_.str.361
LFQH_Lloh2625:
nop
bl Lpatch + (0xa5b0 - PATCH_BASE)
mov	x23, x0
LFQH_Lloh2626:
adr x0, LFQH_l_.str.387
LFQH_Lloh2627:
nop
bl Lpatch + (0xa5a4 - PATCH_BASE)
mov	x1, x0
LFQH_Lloh2628:
adr x2, LFQH_l_.str.674
LFQH_Lloh2629:
nop
mov	x0, x23
bl Lpatch + (0xa5d4 - PATCH_BASE)
mov	x3, x0
mov	x0, x21
mov	x1, x22
mov	x2, x20
bl Lpatch + (0xa5d4 - PATCH_BASE)
LFQH_Lloh2630:
adr x1, LFQH_ReaderThemePendingKey
LFQH_Lloh2631:
nop
mov	x0, x19
mov	x2, #0
mov	w3, #1
bl Lpatch + (0xa634 - PATCH_BASE)
LFQH_LBB90_7:
mov	x0, x19
ldp	x29, x30, [sp, #48]
ldp	x20, x19, [sp, #32]
ldp	x22, x21, [sp, #16]
ldp	x24, x23, [sp], #64
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
LFQH_Lloh2632:
adr x0, LFQH_l_.str.191
LFQH_Lloh2633:
nop
LFQH_Lloh2634:
adr x1, LFQH_l_.str.198
LFQH_Lloh2635:
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
LFQH_Lloh2636:
adr x0, LFQH_l_.str.199
LFQH_Lloh2637:
nop
LFQH_Lloh2638:
adr x1, LFQH_l_.str.200
LFQH_Lloh2639:
nop
bl	LFQH_Original
mov	x8, x0
mov	x0, x19
mov	x1, x20
blr	x8
LFQH_Lloh2640:
adr x0, LFQH_l_.str.20
LFQH_Lloh2641:
nop
bl Lpatch + (0xa5a4 - PATCH_BASE)
mov	x1, x0
mov	x0, x19
bl Lpatch + (0xa5d4 - PATCH_BASE)
LFQH_Lloh2642:
adr x1, LFQH_l_.str.715
LFQH_Lloh2643:
nop
bl	LFQH_Kind
cbz	w0, LFQH_LBB92_2
mov	x0, x19
ldp	x29, x30, [sp, #16]
ldp	x20, x19, [sp], #32
b	LFQH_ReaderCommunityGlass
LFQH_LBB92_2:
LFQH_Lloh2644:
adr x1, LFQH_SurfaceKey
LFQH_Lloh2645:
nop
mov	x0, x19
bl Lpatch + (0xa628 - PATCH_BASE)
cbz	x0, LFQH_LBB92_4
mov	x0, x19
ldp	x29, x30, [sp, #16]
ldp	x20, x19, [sp], #32
b	LFQH_PageRestore
LFQH_LBB92_4:
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
LFQH_Lloh2646:
adr x0, LFQH_l_.str.58
LFQH_Lloh2647:
nop
LFQH_Lloh2648:
adr x1, LFQH_l_.str.201
LFQH_Lloh2649:
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
LFQH_Lloh2650:
adr x1, LFQH_l_.str.716
LFQH_Lloh2651:
nop
mov	x0, x19
bl	LFQH_Get
mov	x20, x0
LFQH_Lloh2652:
adr x0, LFQH_l_.str.34
LFQH_Lloh2653:
nop
bl Lpatch + (0xa5a4 - PATCH_BASE)
mov	x1, x0
mov	x0, x20
bl Lpatch + (0xa5d4 - PATCH_BASE)
mov	x21, x0
LFQH_Lloh2654:
adr x0, LFQH_l_.str.24
LFQH_Lloh2655:
nop
bl Lpatch + (0xa5a4 - PATCH_BASE)
mov	x1, x0
mov	x0, x19
bl Lpatch + (0xa5d4 - PATCH_BASE)
stp	d0, d1, [sp]
stp	d2, d3, [sp, #16]
cbz	x21, LFQH_LBB93_26
mov	x23, #0
mov	x22, #0
LFQH_Lloh2656:
adr x25, LFQH_l_.str.20
LFQH_Lloh2657:
nop
LFQH_LBB93_2:
LFQH_Lloh2658:
adr x0, LFQH_l_.str.461
LFQH_Lloh2659:
nop
bl Lpatch + (0xa5a4 - PATCH_BASE)
mov	x1, x0
mov	x0, x20
mov	x2, x22
bl Lpatch + (0xa5d4 - PATCH_BASE)
mov	x28, x0
LFQH_Lloh2660:
adr x1, LFQH_l_.str.57
LFQH_Lloh2661:
nop
bl	LFQH_Kind
cmp	w0, #0
ccmp	x28, #0, #4, ne
b.eq	LFQH_LBB93_23
mov	w24, #0
mov	x0, x28
LFQH_LBB93_4:
cmp	x0, x19
b.eq	LFQH_LBB93_7
mov	x1, x25
bl	LFQH_Get
cbz	x0, LFQH_LBB93_23
add	w8, w24, #1
cmp	w24, #7
mov	x24, x8
b.lo	LFQH_LBB93_4
b	LFQH_LBB93_23
LFQH_LBB93_7:
mov	x0, x28
bl	LFQH_ReaderBottomType
sub	w8, w0, #1
cmp	w8, #3
b.hs	LFQH_LBB93_10
mov	x26, x0
mov	x0, x28
mov	x1, #0
bl	LFQH_ReaderBottomGlass
mov	x27, #0
cmp	w26, #1
b.ne	LFQH_LBB93_11
mov	x0, x28
LFQH_Lloh2662:
adr x1, LFQH_SurfaceKey
LFQH_Lloh2663:
nop
bl Lpatch + (0xa628 - PATCH_BASE)
mov	x27, x0
b	LFQH_LBB93_11
LFQH_LBB93_10:
mov	x0, x28
mov	w1, #0
bl	LFQH_ReaderBottomOptics
mov	x0, x28
bl	LFQH_PageRestore
mov	x0, x28
bl	LFQH_RestoreHit
mov	x27, #0
LFQH_LBB93_11:
mov	x0, x28
LFQH_Lloh2664:
adr x1, LFQH_CatalogTapKey
LFQH_Lloh2665:
nop
bl Lpatch + (0xa628 - PATCH_BASE)
mov	x26, x0
cbnz	x27, LFQH_LBB93_14
cbz	x26, LFQH_LBB93_14
LFQH_Lloh2666:
adr x0, LFQH_l_.str.599
LFQH_Lloh2667:
nop
bl Lpatch + (0xa5a4 - PATCH_BASE)
mov	x1, x0
mov	x0, x28
mov	x2, x26
bl Lpatch + (0xa5d4 - PATCH_BASE)
mov	x0, x28
LFQH_Lloh2668:
adr x1, LFQH_CatalogTapKey
LFQH_Lloh2669:
nop
mov	x2, #0
mov	w3, #1
bl Lpatch + (0xa634 - PATCH_BASE)
b	LFQH_LBB93_23
LFQH_LBB93_14:
cbz	x27, LFQH_LBB93_21
cbnz	x26, LFQH_LBB93_21
mov	x0, x28
bl Lpatch + (0xa664 - PATCH_BASE)
LFQH_Lloh2670:
adr x1, LFQH_l_.str.721
LFQH_Lloh2671:
nop
LFQH_Lloh2672:
adr x2, LFQH_l_.str.186
LFQH_Lloh2673:
nop
bl	LFQH_ClassABI
cbz	w0, LFQH_LBB93_22
LFQH_Lloh2674:
adr x0, LFQH_l_.str.722
LFQH_Lloh2675:
nop
bl Lpatch + (0xa5b0 - PATCH_BASE)
mov	x26, x0
cbnz	x0, LFQH_LBB93_20
LFQH_Lloh2676:
adr x0, LFQH_l_.str.556
LFQH_Lloh2677:
nop
bl Lpatch + (0xa5b0 - PATCH_BASE)
LFQH_Lloh2678:
adr x1, LFQH_l_.str.722
LFQH_Lloh2679:
nop
mov	x2, #0
bl Lpatch + (0xa61c - PATCH_BASE)
cbz	x0, LFQH_LBB93_22
mov	x26, x0
LFQH_Lloh2680:
adr x0, LFQH_l_.str.723
LFQH_Lloh2681:
nop
bl Lpatch + (0xa5a4 - PATCH_BASE)
mov	x1, x0
mov	x0, x26
LFQH_Lloh2682:
adr x2, LFQH_CatalogTapped
LFQH_Lloh2683:
nop
LFQH_Lloh2684:
adr x3, LFQH_l_.str.186
LFQH_Lloh2685:
nop
bl Lpatch + (0xa58c - PATCH_BASE)
LFQH_Lloh2686:
adr x0, LFQH_l_.str.559
LFQH_Lloh2687:
nop
bl Lpatch + (0xa5a4 - PATCH_BASE)
mov	x1, x0
mov	x0, x26
LFQH_Lloh2688:
adr x2, LFQH_CatalogTouch
LFQH_Lloh2689:
nop
LFQH_Lloh2690:
adr x3, LFQH_l_.str.560
LFQH_Lloh2691:
nop
bl Lpatch + (0xa58c - PATCH_BASE)
mov	x0, x26
bl Lpatch + (0xa610 - PATCH_BASE)
LFQH_LBB93_20:
LFQH_Lloh2692:
adr x0, LFQH_l_.str.421
LFQH_Lloh2693:
nop
bl Lpatch + (0xa5a4 - PATCH_BASE)
mov	x1, x0
mov	x0, x26
bl Lpatch + (0xa5d4 - PATCH_BASE)
mov	x26, x0
LFQH_Lloh2694:
adr x0, LFQH_l_.str.724
LFQH_Lloh2695:
nop
bl Lpatch + (0xa5b0 - PATCH_BASE)
mov	x23, x0
LFQH_Lloh2696:
adr x0, LFQH_l_.str.154
LFQH_Lloh2697:
nop
bl Lpatch + (0xa5a4 - PATCH_BASE)
mov	x1, x0
mov	x0, x23
bl Lpatch + (0xa5d4 - PATCH_BASE)
mov	x23, x0
LFQH_Lloh2698:
adr x0, LFQH_l_.str.601
LFQH_Lloh2699:
nop
bl Lpatch + (0xa5a4 - PATCH_BASE)
mov	x24, x0
LFQH_Lloh2700:
adr x0, LFQH_l_.str.723
LFQH_Lloh2701:
nop
bl Lpatch + (0xa5a4 - PATCH_BASE)
mov	x3, x0
mov	x0, x23
mov	x1, x24
mov	x2, x26
bl Lpatch + (0xa5d4 - PATCH_BASE)
mov	x23, x0
LFQH_Lloh2702:
adr x0, LFQH_l_.str.603
LFQH_Lloh2703:
nop
bl Lpatch + (0xa5a4 - PATCH_BASE)
mov	x1, x0
mov	x0, x23
mov	x2, x26
bl Lpatch + (0xa5d4 - PATCH_BASE)
LFQH_Lloh2704:
adr x0, LFQH_l_.str.725
LFQH_Lloh2705:
nop
bl Lpatch + (0xa5a4 - PATCH_BASE)
mov	x1, x0
mov	x0, x23
mov	w2, #0
bl Lpatch + (0xa5d4 - PATCH_BASE)
mov	x0, x23
LFQH_Lloh2706:
adr x24, LFQH_CatalogTapKey
LFQH_Lloh2707:
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
LFQH_Lloh2708:
adr x0, LFQH_l_.str.604
LFQH_Lloh2709:
nop
bl Lpatch + (0xa5a4 - PATCH_BASE)
mov	x1, x0
mov	x0, x28
mov	x2, x23
bl Lpatch + (0xa5d4 - PATCH_BASE)
LFQH_Lloh2710:
adr x24, LFQH_l_.str.56
LFQH_Lloh2711:
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
b	LFQH_LBB93_22
LFQH_LBB93_21:
cbz	x27, LFQH_LBB93_23
LFQH_LBB93_22:
mov	x2, sp
mov	x0, x27
mov	x1, x19
bl	LFQH_IncludeMaterial
mov	x23, x28
LFQH_LBB93_23:
add	x22, x22, #1
cmp	x22, x21
b.ne	LFQH_LBB93_2
cbz	x23, LFQH_LBB93_26
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
LFQH_LBB93_26:
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
LFQH_Lloh2712:
adr x0, LFQH_l_.str.202
LFQH_Lloh2713:
nop
LFQH_Lloh2714:
adr x1, LFQH_l_.str.203
LFQH_Lloh2715:
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
LFQH_Lloh2716:
adr x0, LFQH_l_.str.202
LFQH_Lloh2717:
nop
LFQH_Lloh2718:
adr x1, LFQH_l_.str.205
LFQH_Lloh2719:
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
LFQH_Lloh2720:
adr x0, LFQH_l_.str.206
LFQH_Lloh2721:
nop
LFQH_Lloh2722:
adr x1, LFQH_l_.str.207
LFQH_Lloh2723:
nop
bl	LFQH_Original
mov	x8, x0
mov	x0, x19
mov	x1, x20
blr	x8
LFQH_Lloh2724:
adr x0, LFQH_l_.str.20
LFQH_Lloh2725:
nop
bl Lpatch + (0xa5a4 - PATCH_BASE)
mov	x1, x0
mov	x0, x19
bl Lpatch + (0xa5d4 - PATCH_BASE)
mov	x20, x0
LFQH_Lloh2726:
adr x1, LFQH_l_.str.58
LFQH_Lloh2727:
nop
bl	LFQH_Kind
cmp	w0, #0
csel	x20, xzr, x20, eq
cbnz	x20, LFQH_LBB96_2
LFQH_Lloh2728:
adr x1, LFQH_l_.str.58
LFQH_Lloh2729:
nop
mov	x0, x19
bl	LFQH_HasAncestor
cbz	w0, LFQH_LBB96_3
LFQH_LBB96_2:
mov	x0, x19
mov	x1, x20
ldp	x29, x30, [sp, #16]
ldp	x20, x19, [sp], #32
b	LFQH_ReaderBottomGlass
LFQH_LBB96_3:
mov	x0, x19
mov	w1, #0
bl	LFQH_ReaderBottomOptics
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
LFQH_Lloh2730:
adr x0, LFQH_l_.str.208
LFQH_Lloh2731:
nop
LFQH_Lloh2732:
adr x1, LFQH_l_.str.209
LFQH_Lloh2733:
nop
bl	LFQH_Original
mov	x8, x0
mov	x0, x19
mov	x1, x20
blr	x8
LFQH_Lloh2734:
adr x1, LFQH_l_.str.732
LFQH_Lloh2735:
nop
mov	x0, x19
bl	LFQH_Get
cbz	x0, LFQH_LBB97_2
ldp	x29, x30, [sp, #16]
ldp	x20, x19, [sp], #32
b	LFQH_FQHApply
LFQH_LBB97_2:
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
LFQH_Lloh2736:
adr x0, LFQH_l_.str.210
LFQH_Lloh2737:
nop
LFQH_Lloh2738:
adr x1, LFQH_l_.str.211
LFQH_Lloh2739:
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
LFQH_Lloh2740:
adr x0, LFQH_l_.str.212
LFQH_Lloh2741:
nop
LFQH_Lloh2742:
adr x1, LFQH_l_.str.213
LFQH_Lloh2743:
nop
bl	LFQH_Original
mov	x8, x0
mov	x0, x21
mov	x1, x19
blr	x8
LFQH_Lloh2744:
adr x1, LFQH_l_.str.733
LFQH_Lloh2745:
nop
mov	x0, x21
bl	LFQH_Get
mov	x20, x0
LFQH_Lloh2746:
adr x1, LFQH_l_.str.440
LFQH_Lloh2747:
nop
mov	x0, x21
bl	LFQH_Get
mov	x19, x0
LFQH_Lloh2748:
adr x1, LFQH_l_.str.734
LFQH_Lloh2749:
nop
mov	x0, x21
bl	LFQH_Get
mov	x22, x0
LFQH_Lloh2750:
adr x1, LFQH_l_.str.138
LFQH_Lloh2751:
nop
mov	x0, x20
bl	LFQH_Kind
cbz	w0, LFQH_LBB99_3
LFQH_Lloh2752:
adr x1, LFQH_l_.str.20
LFQH_Lloh2753:
nop
mov	x0, x20
bl	LFQH_Get
cmp	x0, x21
b.ne	LFQH_LBB99_3
LFQH_Lloh2754:
adr x0, LFQH_l_.str.71
LFQH_Lloh2755:
nop
bl Lpatch + (0xa5a4 - PATCH_BASE)
mov	x1, x0
mov	x0, x20
bl Lpatch + (0xa5d4 - PATCH_BASE)
cbz	w0, LFQH_LBB99_12
LFQH_LBB99_3:
LFQH_Lloh2756:
adr x1, LFQH_l_.str.36
LFQH_Lloh2757:
nop
mov	x0, x22
bl	LFQH_Kind
cbz	w0, LFQH_LBB99_7
LFQH_Lloh2758:
adr x1, LFQH_l_.str.20
LFQH_Lloh2759:
nop
mov	x0, x22
bl	LFQH_Get
cmp	x0, x21
b.ne	LFQH_LBB99_7
LFQH_Lloh2760:
adr x0, LFQH_l_.str.71
LFQH_Lloh2761:
nop
bl Lpatch + (0xa5a4 - PATCH_BASE)
mov	x1, x0
mov	x0, x22
bl Lpatch + (0xa5d4 - PATCH_BASE)
cbnz	w0, LFQH_LBB99_7
LFQH_Lloh2762:
adr x1, LFQH_l_.str.20
LFQH_Lloh2763:
nop
mov	x0, x19
bl	LFQH_Get
cmp	x0, x21
b.eq	LFQH_LBB99_16
LFQH_LBB99_7:
mov	w21, #0
LFQH_LBB99_8:
LFQH_Lloh2764:
adr x1, LFQH_SurfaceKey
LFQH_Lloh2765:
nop
mov	x0, x20
bl Lpatch + (0xa628 - PATCH_BASE)
cbz	x0, LFQH_LBB99_10
mov	x0, x20
bl	LFQH_PageRestore
tbnz	w21, #0, LFQH_LBB99_11
b	LFQH_LBB99_13
LFQH_LBB99_10:
cbz	w21, LFQH_LBB99_13
LFQH_LBB99_11:
mov	x0, x19
ldp	x29, x30, [sp, #32]
ldp	x20, x19, [sp, #16]
ldp	x22, x21, [sp], #48
b	LFQH_FQHApply
LFQH_LBB99_12:
mov	x0, x20
bl	LFQH_FQHApply
LFQH_LBB99_13:
LFQH_Lloh2766:
adr x1, LFQH_SurfaceKey
LFQH_Lloh2767:
nop
mov	x0, x19
bl Lpatch + (0xa628 - PATCH_BASE)
cbz	x0, LFQH_LBB99_15
mov	x0, x19
ldp	x29, x30, [sp, #32]
ldp	x20, x19, [sp, #16]
ldp	x22, x21, [sp], #48
b	LFQH_PageRestore
LFQH_LBB99_15:
ldp	x29, x30, [sp, #32]
ldp	x20, x19, [sp, #16]
ldp	x22, x21, [sp], #48
ret
LFQH_LBB99_16:
LFQH_Lloh2768:
adr x0, LFQH_l_.str.71
LFQH_Lloh2769:
nop
bl Lpatch + (0xa5a4 - PATCH_BASE)
mov	x1, x0
mov	x0, x19
bl Lpatch + (0xa5d4 - PATCH_BASE)
cmp	w0, #0
cset	w21, eq
b	LFQH_LBB99_8
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
LFQH_Lloh2770:
adr x0, LFQH_l_.str.214
LFQH_Lloh2771:
nop
LFQH_Lloh2772:
adr x1, LFQH_l_.str.216
LFQH_Lloh2773:
nop
bl	LFQH_Original
mov	x8, x0
mov	x0, x20
mov	x1, x19
blr	x8
LFQH_Lloh2774:
adr x1, LFQH_l_.str.735
LFQH_Lloh2775:
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
LFQH_Lloh2776:
adr x0, LFQH_l_.str.214
LFQH_Lloh2777:
nop
LFQH_Lloh2778:
adr x1, LFQH_l_.str.218
LFQH_Lloh2779:
nop
bl	LFQH_Original
mov	x8, x0
mov	x0, x20
mov	x1, x19
blr	x8
LFQH_Lloh2780:
adr x1, LFQH_l_.str.735
LFQH_Lloh2781:
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
LFQH_Lloh2782:
adr x0, LFQH_l_.str.219
LFQH_Lloh2783:
nop
LFQH_Lloh2784:
adr x1, LFQH_l_.str.220
LFQH_Lloh2785:
nop
bl	LFQH_Original
mov	x8, x0
mov	x0, x19
mov	x1, x20
blr	x8
LFQH_Lloh2786:
adr x21, LFQH_l_.str.20
LFQH_Lloh2787:
nop
mov	x0, x19
mov	x1, x21
bl	LFQH_Get
mov	x20, x0
mov	x1, x21
bl	LFQH_Get
mov	x21, x0
LFQH_Lloh2788:
adr x1, LFQH_l_.str.223
LFQH_Lloh2789:
nop
bl	LFQH_Kind
cbz	w0, LFQH_LBB102_2
LFQH_Lloh2790:
adr x1, LFQH_l_.str.740
LFQH_Lloh2791:
nop
mov	x0, x21
bl	LFQH_Get
cmp	x0, x19
b.eq	LFQH_LBB102_4
LFQH_LBB102_2:
LFQH_Lloh2792:
adr x1, LFQH_l_.str.221
LFQH_Lloh2793:
nop
mov	x0, x19
bl	LFQH_HasAncestor
cbnz	w0, LFQH_LBB102_5
mov	x0, x19
ldp	x29, x30, [sp, #32]
ldp	x20, x19, [sp, #16]
ldp	x22, x21, [sp], #48
b	LFQH_FQHApply
LFQH_LBB102_4:
mov	x0, x21
mov	x1, x19
mov	x2, x20
bl	LFQH_ChapterDiscussionMode
cbz	x0, LFQH_LBB102_2
LFQH_LBB102_5:
LFQH_Lloh2794:
adr x1, LFQH_SurfaceKey
LFQH_Lloh2795:
nop
mov	x0, x19
bl Lpatch + (0xa628 - PATCH_BASE)
cbz	x0, LFQH_LBB102_7
mov	x0, x19
ldp	x29, x30, [sp, #32]
ldp	x20, x19, [sp, #16]
ldp	x22, x21, [sp], #48
b	LFQH_PageRestore
LFQH_LBB102_7:
ldp	x29, x30, [sp, #32]
ldp	x20, x19, [sp, #16]
ldp	x22, x21, [sp], #48
ret
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
LFQH_Lloh2796:
adr x0, LFQH_l_.str.221
LFQH_Lloh2797:
nop
LFQH_Lloh2798:
adr x1, LFQH_l_.str.222
LFQH_Lloh2799:
nop
bl	LFQH_Original
mov	x8, x0
mov	x0, x19
mov	x1, x20
blr	x8
LFQH_Lloh2800:
adr x1, LFQH_l_.str.219
LFQH_Lloh2801:
nop
mov	x0, x19
bl	LFQH_HasAncestor
cbz	w0, LFQH_LBB103_2
mov	x0, x19
ldp	x29, x30, [sp, #16]
ldp	x20, x19, [sp], #32
b	LFQH_PageRestore
LFQH_LBB103_2:
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
LFQH_Lloh2802:
adr x0, LFQH_l_.str.223
LFQH_Lloh2803:
nop
LFQH_Lloh2804:
adr x1, LFQH_l_.str.224
LFQH_Lloh2805:
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
LFQH_Lloh2806:
adr x0, LFQH_l_.str.223
LFQH_Lloh2807:
nop
LFQH_Lloh2808:
adr x1, LFQH_l_.str.226
LFQH_Lloh2809:
nop
bl	LFQH_Original
mov	x8, x0
mov	x0, x21
mov	x1, x20
mov	x2, x19
blr	x8
mov	x0, x21
bl	LFQH_ChapterDiscussionGlass
LFQH_Lloh2810:
adr x0, LFQH_l_.str.414
LFQH_Lloh2811:
nop
bl Lpatch + (0xa5a4 - PATCH_BASE)
mov	x1, x0
mov	x0, x21
bl Lpatch + (0xa5d4 - PATCH_BASE)
mov	x19, x0
LFQH_Lloh2812:
adr x0, LFQH_l_.str.34
LFQH_Lloh2813:
nop
bl Lpatch + (0xa5a4 - PATCH_BASE)
mov	x1, x0
mov	x0, x19
bl Lpatch + (0xa5d4 - PATCH_BASE)
cbz	x0, LFQH_LBB105_5
mov	x20, x0
mov	x21, #0
LFQH_Lloh2814:
adr x22, LFQH_l_.str.461
LFQH_Lloh2815:
nop
LFQH_Lloh2816:
adr x23, LFQH_l_.str.229
LFQH_Lloh2817:
nop
LFQH_LBB105_2:
mov	x0, x22
bl Lpatch + (0xa5a4 - PATCH_BASE)
mov	x1, x0
mov	x0, x19
mov	x2, x21
bl Lpatch + (0xa5d4 - PATCH_BASE)
mov	x24, x0
mov	x1, x23
bl	LFQH_Kind
cbz	w0, LFQH_LBB105_4
mov	x0, x24
bl	LFQH_ChapterRewardGlass
LFQH_LBB105_4:
add	x21, x21, #1
cmp	x20, x21
b.ne	LFQH_LBB105_2
LFQH_LBB105_5:
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
LFQH_Lloh2818:
adr x0, LFQH_l_.str.227
LFQH_Lloh2819:
nop
LFQH_Lloh2820:
adr x1, LFQH_l_.str.228
LFQH_Lloh2821:
nop
bl	LFQH_Original
mov	x8, x0
mov	x0, x19
mov	x1, x20
blr	x8
LFQH_Lloh2822:
adr x1, LFQH_l_.str.229
LFQH_Lloh2823:
nop
mov	x0, x19
bl	LFQH_Kind
cbz	w0, LFQH_LBB106_2
mov	x0, x19
ldp	x29, x30, [sp, #16]
ldp	x20, x19, [sp], #32
b	LFQH_ChapterRewardGlass
LFQH_LBB106_2:
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
LFQH_Lloh2824:
adr x0, LFQH_l_.str.229
LFQH_Lloh2825:
nop
LFQH_Lloh2826:
adr x1, LFQH_l_.str.231
LFQH_Lloh2827:
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
LFQH_Lloh2828:
adr x0, LFQH_l_.str.232
LFQH_Lloh2829:
nop
LFQH_Lloh2830:
adr x1, LFQH_l_.str.233
LFQH_Lloh2831:
nop
bl	LFQH_Original
mov	x8, x0
mov	x0, x20
mov	x1, x19
blr	x8
LFQH_Lloh2832:
adr x1, LFQH_l_.str.169
LFQH_Lloh2833:
nop
mov	x0, x20
bl	LFQH_Get
mov	x19, x0
LFQH_Lloh2834:
adr x1, LFQH_l_.str.424
LFQH_Lloh2835:
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
LFQH_Lloh2836:
adr x0, LFQH_l_.str.232
LFQH_Lloh2837:
nop
LFQH_Lloh2838:
adr x1, LFQH_l_.str.235
LFQH_Lloh2839:
nop
bl	LFQH_Original
mov	x8, x0
mov	x0, x21
mov	x1, x20
mov	x2, x19
blr	x8
LFQH_Lloh2840:
adr x1, LFQH_l_.str.424
LFQH_Lloh2841:
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
LFQH_Lloh2842:
adr x0, LFQH_l_.str.236
LFQH_Lloh2843:
nop
LFQH_Lloh2844:
adr x1, LFQH_l_.str.237
LFQH_Lloh2845:
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
LFQH_Lloh2846:
adr x0, LFQH_l_.str.236
LFQH_Lloh2847:
nop
LFQH_Lloh2848:
adr x1, LFQH_l_.str.239
LFQH_Lloh2849:
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
LFQH_Lloh2850:
adr x0, LFQH_l_.str.236
LFQH_Lloh2851:
nop
LFQH_Lloh2852:
adr x1, LFQH_l_.str.241
LFQH_Lloh2853:
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
LFQH_Lloh2854:
adr x0, LFQH_l_.str.109
LFQH_Lloh2855:
nop
LFQH_Lloh2856:
adr x1, LFQH_l_.str.110
LFQH_Lloh2857:
nop
bl	LFQH_Original
mov	x8, x0
mov	x0, x19
mov	x1, x20
blr	x8
LFQH_Lloh2858:
adr x1, LFQH_l_.str.107
LFQH_Lloh2859:
nop
mov	x0, x19
bl	LFQH_Get
cbz	x0, LFQH_LBB113_12
mov	x21, x0
mov	w22, #0
LFQH_Lloh2860:
adr x20, LFQH_l_.str.20
LFQH_Lloh2861:
nop
LFQH_LBB113_2:
cmp	x0, x19
b.eq	LFQH_LBB113_5
mov	x1, x20
bl	LFQH_Get
cbz	x0, LFQH_LBB113_12
add	w8, w22, #1
cmp	w22, #7
mov	x22, x8
b.lo	LFQH_LBB113_2
b	LFQH_LBB113_12
LFQH_LBB113_5:
mov	x0, x19
bl	LFQH_ShelfRememberFilterHeader
mov	w0, #10
bl	LFQH_PageOptionEnabled
mov	x1, x0
mov	x0, x21
bl	LFQH_ApplyShelfFilterButton
LFQH_Lloh2862:
adr x1, LFQH_SurfaceKey
LFQH_Lloh2863:
nop
mov	x0, x21
bl Lpatch + (0xa628 - PATCH_BASE)
cbz	x0, LFQH_LBB113_12
mov	x22, x0
LFQH_Lloh2864:
adr x1, LFQH_l_.str.750
LFQH_Lloh2865:
nop
mov	x0, x19
bl	LFQH_Get
mov	x20, x0
LFQH_Lloh2866:
adr x1, LFQH_l_.str.20
LFQH_Lloh2867:
nop
bl	LFQH_Get
cmp	x0, x19
b.ne	LFQH_LBB113_12
LFQH_Lloh2868:
adr x23, LFQH_l_.str.372
LFQH_Lloh2869:
nop
mov	x0, x23
bl Lpatch + (0xa5a4 - PATCH_BASE)
mov	x1, x0
mov	x0, x20
bl Lpatch + (0xa5d4 - PATCH_BASE)
fmov	d11, d0
fmov	d8, d1
fmov	d9, d2
fmov	d10, d3
fmov	x24, d9
fmov	x25, d8
fmov	x26, d11
mov	x0, x23
bl Lpatch + (0xa5a4 - PATCH_BASE)
mov	x1, x0
mov	x0, x22
bl Lpatch + (0xa5d4 - PATCH_BASE)
fmov	d12, d0
fmov	d13, d1
fmov	d14, d2
fmov	d15, d3
LFQH_Lloh2870:
adr x0, LFQH_l_.str.507
LFQH_Lloh2871:
nop
bl Lpatch + (0xa5a4 - PATCH_BASE)
mov	x1, x0
mov	x0, x21
fmov	d0, d12
fmov	d1, d13
fmov	d2, d14
fmov	d3, d15
mov	x2, x19
bl Lpatch + (0xa5d4 - PATCH_BASE)
and	x10, x26, #0x7fffffffffffffff
and	x8, x25, #0x7fffffffffffffff
mov	x11, #9218868437227405311
cmp	x8, x11
cset	w8, gt
and	x9, x24, #0x7fffffffffffffff
cmp	x9, x11
cset	w9, gt
cmp	x10, x11
b.gt	LFQH_LBB113_11
fmov	x10, d10
and	x10, x10, #0x7fffffffffffffff
fcmp	d9, #0.0
cset	w11, gt
fcmp	d10, #0.0
csel	w11, wzr, w11, le
mov	x12, #9218868437227405312
cmp	x10, x12
csel	w10, wzr, w11, ge
tst	w9, #0x1
csel	w9, wzr, w10, ne
tst	w8, #0x1
csel	w8, wzr, w9, ne
cbz	w8, LFQH_LBB113_12
LFQH_LBB113_9:
fadd	d2, d0, d2
fadd	d4, d11, d9
fadd	d3, d1, d3
fadd	d5, d8, d10
fcmp	d11, d2
fccmp	d4, d0, #4, mi
fccmp	d8, d3, #0, gt
fccmp	d5, d1, #4, mi
b.le	LFQH_LBB113_12
fsub	d11, d0, d9
LFQH_Lloh2872:
adr x0, LFQH_l_.str.156
LFQH_Lloh2873:
nop
bl Lpatch + (0xa5a4 - PATCH_BASE)
mov	x1, x0
mov	x0, x20
fmov	d0, d11
fmov	d1, d8
fmov	d2, d9
fmov	d3, d10
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
LFQH_LBB113_11:
mov	w8, #0
cbnz	w8, LFQH_LBB113_9
LFQH_LBB113_12:
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
LFQH_ShelfFilterHeaderConfigure:
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
mov	x20, x3
mov	x21, x2
mov	x22, x1
mov	x19, x0
LFQH_Lloh2874:
adr x0, LFQH_l_.str.244
LFQH_Lloh2875:
nop
bl Lpatch + (0xa5a4 - PATCH_BASE)
LFQH_Lloh2876:
adr x8, LFQH_l_.str.243
LFQH_Lloh2877:
nop
LFQH_Lloh2878:
adr x9, LFQH_l_.str.245
LFQH_Lloh2879:
nop
cmp	x0, x22
csel	x23, x9, x8, eq
LFQH_Lloh2880:
adr x24, LFQH_l_.str.107
LFQH_Lloh2881:
nop
mov	x0, x19
mov	x1, x24
bl	LFQH_Get
bl	LFQH_RestoreShelfFilterButton
LFQH_Lloh2882:
adr x0, LFQH_l_.str.109
LFQH_Lloh2883:
nop
mov	x1, x23
bl	LFQH_Original
mov	x8, x0
mov	x0, x19
mov	x1, x22
mov	x2, x21
mov	x3, x20
blr	x8
mov	x0, x19
mov	x1, x24
bl	LFQH_Get
cbz	x0, LFQH_LBB114_5
mov	x20, x0
mov	w22, #0
LFQH_Lloh2884:
adr x21, LFQH_l_.str.20
LFQH_Lloh2885:
nop
LFQH_LBB114_2:
cmp	x0, x19
b.eq	LFQH_LBB114_6
mov	x1, x21
bl	LFQH_Get
cbz	x0, LFQH_LBB114_5
add	w8, w22, #1
cmp	w22, #7
mov	x22, x8
b.lo	LFQH_LBB114_2
LFQH_LBB114_5:
ldp	x29, x30, [sp, #48]
ldp	x20, x19, [sp, #32]
ldp	x22, x21, [sp, #16]
ldp	x24, x23, [sp], #64
ret
LFQH_LBB114_6:
mov	x0, x19
bl	LFQH_ShelfRememberFilterHeader
mov	w0, #10
bl	LFQH_PageOptionEnabled
mov	x1, x0
mov	x0, x20
ldp	x29, x30, [sp, #48]
ldp	x20, x19, [sp, #32]
ldp	x22, x21, [sp, #16]
ldp	x24, x23, [sp], #64
b	LFQH_ApplyShelfFilterButton
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
LFQH_Lloh2886:
adr x0, LFQH_l_.str.246
LFQH_Lloh2887:
nop
LFQH_Lloh2888:
adr x1, LFQH_l_.str.248
LFQH_Lloh2889:
nop
bl	LFQH_Original
mov	x8, x0
mov	x0, x19
mov	x1, x23
mov	x2, x22
mov	x3, x21
mov	x4, x20
blr	x8
fmov	d8, d0
fmov	d11, d1
fmov	d9, d2
fmov	d10, d3
LFQH_Lloh2890:
adr x1, LFQH_l_.str.20
LFQH_Lloh2891:
nop
mov	x0, x19
bl	LFQH_Get
mov	x20, x0
bl	LFQH_Enabled
cbz	w0, LFQH_LBB115_3
LFQH_Lloh2892:
adr x1, LFQH_l_.str.109
LFQH_Lloh2893:
nop
mov	x0, x20
bl	LFQH_Kind
cbz	w0, LFQH_LBB115_3
LFQH_Lloh2894:
adr x1, LFQH_l_.str.751
LFQH_Lloh2895:
nop
mov	x0, x20
bl	LFQH_Get
fmov	d0, #-4.00000000
fadd	d0, d11, d0
cmp	x0, x19
fcsel	d11, d0, d11, eq
LFQH_LBB115_3:
fmov	d0, d8
fmov	d1, d11
fmov	d2, d9
fmov	d3, d10
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
LFQH_Lloh2896:
adr x0, LFQH_l_.str.250
LFQH_Lloh2897:
nop
LFQH_Lloh2898:
adr x1, LFQH_l_.str.251
LFQH_Lloh2899:
nop
bl	LFQH_Original
mov	x8, x0
mov	x0, x19
mov	x1, x20
blr	x8
LFQH_Lloh2900:
adr x1, LFQH_l_.str.10
LFQH_Lloh2901:
nop
mov	x0, x19
bl	LFQH_Get
bl	LFQH_FQHHeader
bl	LFQH_Enabled
cbz	w0, LFQH_LBB116_3
bl	LFQH_FQHGlassAvailable
cbz	w0, LFQH_LBB116_3
LFQH_Lloh2902:
adr x1, LFQH_l_.str.752
LFQH_Lloh2903:
nop
mov	x0, x19
bl	LFQH_Get
mov	x1, x0
LFQH_Lloh2904:
adr x2, LFQH_ProfileScanKey
LFQH_Lloh2905:
nop
mov	x0, x19
bl	LFQH_ProfileIconGlass
LFQH_Lloh2906:
adr x1, LFQH_l_.str.753
LFQH_Lloh2907:
nop
mov	x0, x19
bl	LFQH_Get
mov	x1, x0
LFQH_Lloh2908:
adr x2, LFQH_ProfileNightKey
LFQH_Lloh2909:
nop
mov	x0, x19
bl	LFQH_ProfileIconGlass
LFQH_Lloh2910:
adr x1, LFQH_l_.str.754
LFQH_Lloh2911:
nop
mov	x0, x19
bl	LFQH_Get
mov	x1, x0
b	LFQH_LBB116_4
LFQH_LBB116_3:
LFQH_Lloh2912:
adr x2, LFQH_ProfileScanKey
LFQH_Lloh2913:
nop
mov	x0, x19
mov	x1, #0
bl	LFQH_ProfileIconGlass
LFQH_Lloh2914:
adr x2, LFQH_ProfileNightKey
LFQH_Lloh2915:
nop
mov	x0, x19
mov	x1, #0
bl	LFQH_ProfileIconGlass
mov	x1, #0
LFQH_LBB116_4:
LFQH_Lloh2916:
adr x2, LFQH_ProfileMenuKey
LFQH_Lloh2917:
nop
mov	x0, x19
ldp	x29, x30, [sp, #16]
ldp	x20, x19, [sp], #32
b	LFQH_ProfileIconGlass
.cfi_endproc
.p2align	2
LFQH_PublishLayout:
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
LFQH_Lloh2918:
adr x21, LFQH_l_.str.256
LFQH_Lloh2919:
nop
mov	x1, x21
bl	LFQH_Kind
LFQH_Lloh2920:
adr x8, LFQH_l_.str.252
LFQH_Lloh2921:
nop
cmp	w0, #0
csel	x0, x8, x21, eq
LFQH_Lloh2922:
adr x1, LFQH_l_.str.253
LFQH_Lloh2923:
nop
bl	LFQH_Original
mov	x8, x0
mov	x0, x20
mov	x1, x19
blr	x8
mov	x0, x20
ldp	x29, x30, [sp, #32]
ldp	x20, x19, [sp, #16]
ldp	x22, x21, [sp], #48
b	LFQH_PublishGlass
.cfi_endproc
.p2align	2
LFQH_PublishTheme:
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
LFQH_Lloh2924:
adr x22, LFQH_l_.str.256
LFQH_Lloh2925:
nop
mov	x1, x22
bl	LFQH_Kind
LFQH_Lloh2926:
adr x8, LFQH_l_.str.252
LFQH_Lloh2927:
nop
cmp	w0, #0
csel	x0, x8, x22, eq
LFQH_Lloh2928:
adr x1, LFQH_l_.str.255
LFQH_Lloh2929:
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
b	LFQH_PublishGlass
.cfi_endproc
.p2align	2
LFQH_BookstorePublishButton:
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
LFQH_Lloh2930:
adr x0, LFQH_l_.str.257
LFQH_Lloh2931:
nop
LFQH_Lloh2932:
adr x1, LFQH_l_.str.259
LFQH_Lloh2933:
nop
bl	LFQH_Original
mov	x8, x0
mov	x0, x21
mov	x1, x20
mov	x2, x19
blr	x8
mov	x0, x19
ldp	x29, x30, [sp, #32]
ldp	x20, x19, [sp, #16]
ldp	x22, x21, [sp], #48
b	LFQH_PublishMark
.cfi_endproc
.p2align	2
LFQH_BookstoreProduceEntrance:
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
LFQH_Lloh2934:
adr x0, LFQH_l_.str.257
LFQH_Lloh2935:
nop
LFQH_Lloh2936:
adr x1, LFQH_l_.str.261
LFQH_Lloh2937:
nop
bl	LFQH_Original
mov	x8, x0
mov	x0, x21
mov	x1, x20
mov	x2, x19
blr	x8
mov	x0, x19
ldp	x29, x30, [sp, #32]
ldp	x20, x19, [sp, #16]
ldp	x22, x21, [sp], #48
b	LFQH_PublishMark
.cfi_endproc
.p2align	2
LFQH_BookstoreComponentPublishButton:
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
LFQH_Lloh2938:
adr x0, LFQH_l_.str.262
LFQH_Lloh2939:
nop
LFQH_Lloh2940:
adr x1, LFQH_l_.str.264
LFQH_Lloh2941:
nop
bl	LFQH_Original
mov	x8, x0
mov	x0, x21
mov	x1, x20
mov	x2, x19
blr	x8
mov	x0, x19
ldp	x29, x30, [sp, #32]
ldp	x20, x19, [sp, #16]
ldp	x22, x21, [sp], #48
b	LFQH_PublishMark
.cfi_endproc
.p2align	2
LFQH_ProfilePublishButton:
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
LFQH_Lloh2942:
adr x0, LFQH_l_.str.265
LFQH_Lloh2943:
nop
LFQH_Lloh2944:
adr x1, LFQH_l_.str.267
LFQH_Lloh2945:
nop
bl	LFQH_Original
mov	x8, x0
mov	x0, x20
mov	x1, x19
blr	x8
mov	x19, x0
bl	LFQH_PublishMark
mov	x0, x19
ldp	x29, x30, [sp, #16]
ldp	x20, x19, [sp], #32
ret
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
LFQH_Lloh2946:
adr x0, LFQH_l_.str.118
LFQH_Lloh2947:
nop
LFQH_Lloh2948:
adr x1, LFQH_l_.str.269
LFQH_Lloh2949:
nop
bl	LFQH_Original
mov	x8, x0
mov	x0, x19
mov	x1, x20
blr	x8
LFQH_Lloh2950:
adr x1, LFQH_l_.str.265
LFQH_Lloh2951:
nop
mov	x0, x19
bl	LFQH_Kind
cbz	w0, LFQH_LBB123_3
LFQH_Lloh2952:
adr x1, LFQH_l_.str.768
LFQH_Lloh2953:
nop
mov	x0, x19
bl	LFQH_Get
mov	x20, x0
LFQH_Lloh2954:
adr x1, LFQH_l_.str.769
LFQH_Lloh2955:
nop
bl	LFQH_BoolProp
cbnz	w0, LFQH_LBB123_3
LFQH_Lloh2956:
adr x1, LFQH_l_.str.770
LFQH_Lloh2957:
nop
mov	x0, x20
bl	LFQH_BoolProp
cbz	w0, LFQH_LBB123_4
LFQH_LBB123_3:
ldp	x29, x30, [sp, #80]
ldp	x20, x19, [sp, #64]
ldp	x22, x21, [sp, #48]
ldp	x24, x23, [sp, #32]
ldp	d9, d8, [sp, #16]
ldp	d11, d10, [sp], #96
ret
LFQH_LBB123_4:
LFQH_Lloh2958:
adr x1, LFQH_l_.str.351
LFQH_Lloh2959:
nop
mov	x0, x19
bl	LFQH_Get
mov	x20, x0
LFQH_Lloh2960:
adr x1, LFQH_l_.str.771
LFQH_Lloh2961:
nop
mov	x0, x19
bl	LFQH_Get
mov	x22, x0
LFQH_Lloh2962:
adr x1, LFQH_l_.str.533
LFQH_Lloh2963:
nop
mov	x0, x19
bl	LFQH_Get
mov	x21, x0
LFQH_Lloh2964:
adr x1, LFQH_l_.str.23
LFQH_Lloh2965:
nop
mov	x0, x20
bl	LFQH_Kind
cbz	w0, LFQH_LBB123_3
LFQH_Lloh2966:
adr x1, LFQH_l_.str.250
LFQH_Lloh2967:
nop
mov	x0, x22
bl	LFQH_Kind
cbz	w0, LFQH_LBB123_3
LFQH_Lloh2968:
adr x1, LFQH_l_.str.772
LFQH_Lloh2969:
nop
mov	x0, x21
bl	LFQH_Kind
cbz	w0, LFQH_LBB123_3
LFQH_Lloh2970:
adr x0, LFQH_l_.str.24
LFQH_Lloh2971:
nop
bl Lpatch + (0xa5a4 - PATCH_BASE)
mov	x1, x0
mov	x0, x20
bl Lpatch + (0xa5d4 - PATCH_BASE)
fmov	d9, d0
fmov	d8, d1
fmov	d10, d2
LFQH_Lloh2972:
adr x0, LFQH_l_.str.372
LFQH_Lloh2973:
nop
bl Lpatch + (0xa5a4 - PATCH_BASE)
mov	x1, x0
mov	x0, x22
bl Lpatch + (0xa5d4 - PATCH_BASE)
fadd	d0, d1, d3
fsub	d11, d0, d8
bl	LFQH_Enabled
cbz	w0, LFQH_LBB123_9
LFQH_Lloh2974:
adr x1, LFQH_l_.str.20
LFQH_Lloh2975:
nop
mov	x0, x21
bl	LFQH_Get
cmp	x0, x20
b.eq	LFQH_LBB123_10
LFQH_LBB123_9:
mov	w3, #0
b	LFQH_LBB123_11
LFQH_LBB123_10:
LFQH_Lloh2976:
adr x0, LFQH_l_.str.71
LFQH_Lloh2977:
nop
bl Lpatch + (0xa5a4 - PATCH_BASE)
mov	x1, x0
mov	x0, x22
bl Lpatch + (0xa5d4 - PATCH_BASE)
cmp	w0, #0
cset	w3, eq
LFQH_LBB123_11:
mov	x0, x20
mov	x1, x22
mov	x2, x21
fmov	d0, d9
fmov	d1, d8
fmov	d2, d10
fmov	d3, d11
bl	LFQH_TopChromePage
mov	x23, x0
mov	x0, x22
mov	x1, x23
bl	LFQH_TopChromeFill
mov	x0, x21
mov	x1, x21
fmov	d0, d8
mov	x2, x23
bl	LFQH_TopChromeUnderlap
LFQH_Lloh2978:
adr x1, LFQH_l_.str.773
LFQH_Lloh2979:
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
LFQH_Lloh2980:
adr x0, LFQH_l_.str.270
LFQH_Lloh2981:
nop
LFQH_Lloh2982:
adr x1, LFQH_l_.str.271
LFQH_Lloh2983:
nop
bl	LFQH_Original
mov	x8, x0
mov	x0, x19
mov	x1, x20
blr	x8
LFQH_Lloh2984:
adr x1, LFQH_l_.str.793
LFQH_Lloh2985:
nop
mov	x0, x19
bl	LFQH_Kind
cbz	w0, LFQH_LBB124_2
ldp	x29, x30, [sp, #16]
ldp	x20, x19, [sp], #32
ret
LFQH_LBB124_2:
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
LFQH_Lloh2986:
adr x0, LFQH_l_.str.272
LFQH_Lloh2987:
nop
LFQH_Lloh2988:
adr x1, LFQH_l_.str.273
LFQH_Lloh2989:
nop
bl	LFQH_Original
mov	x8, x0
mov	x0, x19
mov	x1, x20
blr	x8
LFQH_Lloh2990:
adr x1, LFQH_l_.str.793
LFQH_Lloh2991:
nop
mov	x0, x19
bl	LFQH_Kind
cbz	w0, LFQH_LBB125_2
mov	x0, x19
mov	w1, #1
ldp	x29, x30, [sp, #16]
ldp	x20, x19, [sp], #32
b	LFQH_ProfileEntryGlass
LFQH_LBB125_2:
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
LFQH_Lloh2992:
adr x0, LFQH_l_.str.118
LFQH_Lloh2993:
nop
LFQH_Lloh2994:
adr x1, LFQH_l_.str.275
LFQH_Lloh2995:
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
LFQH_Lloh2996:
adr x1, LFQH_l_.str.33
LFQH_Lloh2997:
nop
mov	x0, x2
bl	LFQH_Kind
cbz	w0, LFQH_LBB127_10
LFQH_Lloh2998:
adr x0, LFQH_l_.str.800
LFQH_Lloh2999:
nop
bl Lpatch + (0xa5b0 - PATCH_BASE)
LFQH_Lloh3000:
adr x1, LFQH_l_.str.801
LFQH_Lloh3001:
nop
LFQH_Lloh3002:
adr x2, LFQH_l_.str.505
LFQH_Lloh3003:
nop
bl	LFQH_ClassABI
cbz	w0, LFQH_LBB127_10
LFQH_Lloh3004:
adr x0, LFQH_l_.str.34
LFQH_Lloh3005:
nop
bl Lpatch + (0xa5a4 - PATCH_BASE)
mov	x1, x0
mov	x0, x22
bl Lpatch + (0xa5d4 - PATCH_BASE)
cbz	x0, LFQH_LBB127_10
mov	x23, #0
sub	x24, x0, #1
LFQH_Lloh3006:
adr x25, LFQH_l_.str.461
LFQH_Lloh3007:
nop
LFQH_Lloh3008:
adr x26, LFQH_l_.str.800
LFQH_Lloh3009:
nop
LFQH_Lloh3010:
adr x27, LFQH_l_.str.801
LFQH_Lloh3011:
nop
LFQH_Lloh3012:
adr x28, LFQH_l_.str.804
LFQH_Lloh3013:
nop
LFQH_LBB127_4:
mov	x0, x25
bl Lpatch + (0xa5a4 - PATCH_BASE)
mov	x1, x0
mov	x0, x22
mov	x2, x24
bl Lpatch + (0xa5d4 - PATCH_BASE)
mov	x19, x0
mov	x1, x26
bl	LFQH_Kind
cbz	w0, LFQH_LBB127_9
mov	x0, x27
bl Lpatch + (0xa5a4 - PATCH_BASE)
mov	x1, x0
mov	x0, x19
bl Lpatch + (0xa5d4 - PATCH_BASE)
cmp	w0, #9
b.ne	LFQH_LBB127_9
cbnz	x23, LFQH_LBB127_8
LFQH_Lloh3014:
adr x0, LFQH_l_.str.802
LFQH_Lloh3015:
nop
bl Lpatch + (0xa5a4 - PATCH_BASE)
mov	x1, x0
mov	x0, x22
bl Lpatch + (0xa5d4 - PATCH_BASE)
mov	x19, x0
LFQH_Lloh3016:
adr x0, LFQH_l_.str.803
LFQH_Lloh3017:
nop
bl Lpatch + (0xa5a4 - PATCH_BASE)
mov	x1, x0
mov	x0, x19
bl Lpatch + (0xa5d4 - PATCH_BASE)
mov	x23, x0
LFQH_LBB127_8:
mov	x0, x28
bl Lpatch + (0xa5a4 - PATCH_BASE)
mov	x1, x0
mov	x0, x23
mov	x2, x24
bl Lpatch + (0xa5d4 - PATCH_BASE)
LFQH_LBB127_9:
sub	x24, x24, #1
cmn	x24, #1
b.ne	LFQH_LBB127_4
b	LFQH_LBB127_11
LFQH_LBB127_10:
mov	x23, #0
LFQH_LBB127_11:
LFQH_Lloh3018:
adr x0, LFQH_l_.str.276
LFQH_Lloh3019:
nop
LFQH_Lloh3020:
adr x1, LFQH_l_.str.278
LFQH_Lloh3021:
nop
bl	LFQH_Original
mov	x8, x0
cmp	x23, #0
csel	x2, x22, x23, eq
mov	x0, x21
mov	x1, x20
ldr	x3, [sp, #8]
blr	x8
cbz	x23, LFQH_LBB127_13
LFQH_Lloh3022:
adr x0, LFQH_l_.str.276
LFQH_Lloh3023:
nop
LFQH_Lloh3024:
adr x1, LFQH_l_.str.805
LFQH_Lloh3025:
nop
ldp	x29, x30, [sp, #96]
ldp	x20, x19, [sp, #80]
ldp	x22, x21, [sp, #64]
ldp	x24, x23, [sp, #48]
ldp	x26, x25, [sp, #32]
ldp	x28, x27, [sp, #16]
add	sp, sp, #112
b	LFQH_RecordMineGameRemoval
LFQH_LBB127_13:
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
LFQH_Lloh3026:
adr x0, LFQH_l_.str.265
LFQH_Lloh3027:
nop
LFQH_Lloh3028:
adr x1, LFQH_l_.str.281
LFQH_Lloh3029:
nop
bl	LFQH_Original
mov	x8, x0
mov	x0, x20
mov	x1, x21
mov	x2, x19
blr	x8
mov	x19, x0
LFQH_Lloh3030:
adr x1, LFQH_l_.str.33
LFQH_Lloh3031:
nop
bl	LFQH_Kind
cbz	w0, LFQH_LBB128_22
LFQH_Lloh3032:
adr x0, LFQH_l_.str.265
LFQH_Lloh3033:
nop
bl Lpatch + (0xa5b0 - PATCH_BASE)
mov	x21, x0
LFQH_Lloh3034:
adr x1, LFQH_MineControllersKey
LFQH_Lloh3035:
nop
bl Lpatch + (0xa628 - PATCH_BASE)
mov	x22, x0
cbnz	x0, LFQH_LBB128_3
LFQH_Lloh3036:
adr x0, LFQH_l_.str.82
LFQH_Lloh3037:
nop
bl Lpatch + (0xa5b0 - PATCH_BASE)
mov	x22, x0
LFQH_Lloh3038:
adr x0, LFQH_l_.str.83
LFQH_Lloh3039:
nop
bl Lpatch + (0xa5a4 - PATCH_BASE)
mov	x1, x0
mov	x0, x22
bl Lpatch + (0xa5d4 - PATCH_BASE)
mov	x22, x0
LFQH_Lloh3040:
adr x1, LFQH_MineControllersKey
LFQH_Lloh3041:
nop
mov	x0, x21
mov	x2, x22
mov	w3, #1
bl Lpatch + (0xa634 - PATCH_BASE)
LFQH_LBB128_3:
LFQH_Lloh3042:
adr x0, LFQH_l_.str.84
LFQH_Lloh3043:
nop
bl Lpatch + (0xa5a4 - PATCH_BASE)
mov	x1, x0
mov	x0, x22
mov	x2, x20
bl Lpatch + (0xa5d4 - PATCH_BASE)
LFQH_Lloh3044:
adr x0, LFQH_l_.str.361
LFQH_Lloh3045:
nop
bl Lpatch + (0xa5b0 - PATCH_BASE)
mov	x20, x0
LFQH_Lloh3046:
adr x0, LFQH_l_.str.387
LFQH_Lloh3047:
nop
bl Lpatch + (0xa5a4 - PATCH_BASE)
mov	x1, x0
LFQH_Lloh3048:
adr x2, LFQH_l_.str.543
LFQH_Lloh3049:
nop
mov	x0, x20
bl Lpatch + (0xa5d4 - PATCH_BASE)
bl	LFQH_DefaultEnabled
mov	x20, x0
LFQH_Lloh3050:
adr x0, LFQH_l_.str.34
LFQH_Lloh3051:
nop
bl Lpatch + (0xa5a4 - PATCH_BASE)
mov	x1, x0
mov	x0, x19
bl Lpatch + (0xa5d4 - PATCH_BASE)
cbz	x0, LFQH_LBB128_20
mov	w28, #0
mov	x22, #0
sub	x21, x0, #1
LFQH_Lloh3052:
adr x23, LFQH_l_.str.461
LFQH_Lloh3053:
nop
LFQH_Lloh3054:
adr x27, LFQH_l_.str.807
LFQH_Lloh3055:
nop
LFQH_Lloh3056:
adr x26, LFQH_l_.str.802
LFQH_Lloh3057:
nop
LFQH_LBB128_5:
mov	x0, x23
bl Lpatch + (0xa5a4 - PATCH_BASE)
mov	x1, x0
mov	x0, x19
mov	x2, x21
bl Lpatch + (0xa5d4 - PATCH_BASE)
mov	x25, x0
bl	LFQH_MineStandaloneGameRow
mov	x24, x0
cbz	w0, LFQH_LBB128_9
LFQH_LBB128_6:
cbnz	x22, LFQH_LBB128_8
mov	x0, x26
bl Lpatch + (0xa5a4 - PATCH_BASE)
mov	x1, x0
mov	x0, x19
bl Lpatch + (0xa5d4 - PATCH_BASE)
mov	x22, x0
LFQH_Lloh3058:
adr x0, LFQH_l_.str.803
LFQH_Lloh3059:
nop
bl Lpatch + (0xa5a4 - PATCH_BASE)
mov	x1, x0
mov	x0, x22
bl Lpatch + (0xa5d4 - PATCH_BASE)
mov	x22, x0
LFQH_LBB128_8:
orr	w28, w24, w28
LFQH_Lloh3060:
adr x0, LFQH_l_.str.804
LFQH_Lloh3061:
nop
bl Lpatch + (0xa5a4 - PATCH_BASE)
mov	x1, x0
mov	x0, x22
mov	x2, x21
bl Lpatch + (0xa5d4 - PATCH_BASE)
b	LFQH_LBB128_10
LFQH_LBB128_9:
cbz	w20, LFQH_LBB128_11
LFQH_LBB128_10:
sub	x21, x21, #1
cmn	x21, #1
b.ne	LFQH_LBB128_5
b	LFQH_LBB128_18
LFQH_LBB128_11:
mov	x0, x25
LFQH_Lloh3062:
adr x1, LFQH_l_.str.276
LFQH_Lloh3063:
nop
bl	LFQH_Kind
cbz	w0, LFQH_LBB128_10
mov	x23, x20
mov	x20, x26
mov	x0, x25
bl Lpatch + (0xa664 - PATCH_BASE)
mov	x26, x27
mov	x1, x27
LFQH_Lloh3064:
adr x2, LFQH_l_.str.641
LFQH_Lloh3065:
nop
bl	LFQH_ClassABI
cbz	w0, LFQH_LBB128_17
mov	x0, x26
bl Lpatch + (0xa5a4 - PATCH_BASE)
mov	x1, x0
mov	x0, x25
bl Lpatch + (0xa5d4 - PATCH_BASE)
and	x8, x0, #0xfffffffffffffffe
cmp	x8, #4
mov	x26, x20
mov	x20, x23
LFQH_Lloh3066:
adr x23, LFQH_l_.str.461
LFQH_Lloh3067:
nop
b.eq	LFQH_LBB128_6
cbnz	x0, LFQH_LBB128_10
mov	x0, x25
LFQH_Lloh3068:
adr x1, LFQH_l_.str.808
LFQH_Lloh3069:
nop
bl	LFQH_BoolProp
cbnz	w0, LFQH_LBB128_6
mov	x0, x25
LFQH_Lloh3070:
adr x1, LFQH_l_.str.809
LFQH_Lloh3071:
nop
bl	LFQH_BoolProp
cbnz	w0, LFQH_LBB128_10
b	LFQH_LBB128_6
LFQH_LBB128_17:
mov	x27, x26
mov	x26, x20
mov	x20, x23
LFQH_Lloh3072:
adr x23, LFQH_l_.str.461
LFQH_Lloh3073:
nop
b	LFQH_LBB128_10
LFQH_LBB128_18:
tst	w28, #0xff
b.eq	LFQH_LBB128_21
LFQH_Lloh3074:
adr x0, LFQH_l_.str.265
LFQH_Lloh3075:
nop
LFQH_Lloh3076:
adr x1, LFQH_l_.str.806
LFQH_Lloh3077:
nop
bl	LFQH_RecordMineGameRemoval
b	LFQH_LBB128_21
LFQH_LBB128_20:
mov	x22, #0
LFQH_LBB128_21:
cmp	x22, #0
csel	x19, x19, x22, eq
LFQH_LBB128_22:
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
LFQH_Lloh3078:
adr x1, LFQH_ShelfDurationRequestedKey
LFQH_Lloh3079:
nop
bl Lpatch + (0xa628 - PATCH_BASE)
cbnz	x0, LFQH_LBB129_4
LFQH_Lloh3080:
adr x0, LFQH_l_.str.21
LFQH_Lloh3081:
nop
bl Lpatch + (0xa5b0 - PATCH_BASE)
mov	x21, x0
LFQH_Lloh3082:
adr x1, LFQH_ShelfDurationHeadersKey
LFQH_Lloh3083:
nop
bl Lpatch + (0xa628 - PATCH_BASE)
mov	x22, x0
cbnz	x0, LFQH_LBB129_3
LFQH_Lloh3084:
adr x0, LFQH_l_.str.82
LFQH_Lloh3085:
nop
bl Lpatch + (0xa5b0 - PATCH_BASE)
mov	x22, x0
LFQH_Lloh3086:
adr x0, LFQH_l_.str.83
LFQH_Lloh3087:
nop
bl Lpatch + (0xa5a4 - PATCH_BASE)
mov	x1, x0
mov	x0, x22
bl Lpatch + (0xa5d4 - PATCH_BASE)
mov	x22, x0
LFQH_Lloh3088:
adr x1, LFQH_ShelfDurationHeadersKey
LFQH_Lloh3089:
nop
mov	x0, x21
mov	x2, x22
mov	w3, #1
bl Lpatch + (0xa634 - PATCH_BASE)
LFQH_LBB129_3:
LFQH_Lloh3090:
adr x0, LFQH_l_.str.84
LFQH_Lloh3091:
nop
bl Lpatch + (0xa5a4 - PATCH_BASE)
mov	x1, x0
mov	x0, x22
mov	x2, x19
bl Lpatch + (0xa5d4 - PATCH_BASE)
LFQH_LBB129_4:
LFQH_Lloh3092:
adr x0, LFQH_l_.str.497
LFQH_Lloh3093:
nop
bl Lpatch + (0xa5b0 - PATCH_BASE)
mov	x21, x0
LFQH_Lloh3094:
adr x0, LFQH_l_.str.499
LFQH_Lloh3095:
nop
bl Lpatch + (0xa5a4 - PATCH_BASE)
mov	x1, x0
mov	x0, x21
mov	x2, x20
bl Lpatch + (0xa5d4 - PATCH_BASE)
mov	x2, x0
LFQH_Lloh3096:
adr x1, LFQH_ShelfDurationRequestedKey
LFQH_Lloh3097:
nop
mov	x0, x19
mov	w3, #1
bl Lpatch + (0xa634 - PATCH_BASE)
cbz	w20, LFQH_LBB129_6
LFQH_Lloh3098:
adr x0, LFQH_l_.str.361
LFQH_Lloh3099:
nop
bl Lpatch + (0xa5b0 - PATCH_BASE)
mov	x20, x0
LFQH_Lloh3100:
adr x0, LFQH_l_.str.387
LFQH_Lloh3101:
nop
bl Lpatch + (0xa5a4 - PATCH_BASE)
mov	x1, x0
LFQH_Lloh3102:
adr x2, LFQH_l_.str.542
LFQH_Lloh3103:
nop
mov	x0, x20
bl Lpatch + (0xa5d4 - PATCH_BASE)
bl	LFQH_DefaultEnabled
cmp	w0, #0
cset	w1, ne
b	LFQH_LBB129_7
LFQH_LBB129_6:
mov	w1, #0
LFQH_LBB129_7:
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
LFQH_Lloh3104:
adr x1, LFQH_ShelfDurationRequestedKey
LFQH_Lloh3105:
nop
bl Lpatch + (0xa628 - PATCH_BASE)
cbnz	x0, LFQH_LBB130_3
mov	x0, x19
bl Lpatch + (0xa664 - PATCH_BASE)
LFQH_Lloh3106:
adr x1, LFQH_l_.str.527
LFQH_Lloh3107:
nop
LFQH_Lloh3108:
adr x2, LFQH_l_.str.149
LFQH_Lloh3109:
nop
bl	LFQH_ClassABI
cbz	w0, LFQH_LBB130_3
LFQH_Lloh3110:
adr x0, LFQH_l_.str.527
LFQH_Lloh3111:
nop
bl Lpatch + (0xa5a4 - PATCH_BASE)
mov	x1, x0
mov	x0, x19
bl Lpatch + (0xa5d4 - PATCH_BASE)
mov	x2, x0
mov	x0, x19
bl	LFQH_ShelfDurationVisible
LFQH_LBB130_3:
LFQH_Lloh3112:
adr x0, LFQH_l_.str.21
LFQH_Lloh3113:
nop
LFQH_Lloh3114:
adr x1, LFQH_l_.str.105
LFQH_Lloh3115:
nop
bl	LFQH_Original
mov	x8, x0
mov	x0, x19
mov	x1, x20
blr	x8
LFQH_Lloh3116:
adr x1, LFQH_l_.str.120
LFQH_Lloh3117:
nop
mov	x0, x19
bl	LFQH_Get
mov	x20, x0
LFQH_Lloh3118:
adr x1, LFQH_l_.str.40
LFQH_Lloh3119:
nop
bl	LFQH_Get
mov	x21, x0
LFQH_Lloh3120:
adr x1, LFQH_l_.str.23
LFQH_Lloh3121:
nop
bl	LFQH_Kind
cbz	w0, LFQH_LBB130_5
mov	x0, x20
mov	x1, x21
bl	LFQH_ShelfEditPlacement
mov	x22, x0
LFQH_Lloh3122:
adr x1, LFQH_l_.str.38
LFQH_Lloh3123:
nop
mov	x0, x20
bl	LFQH_Get
mov	x23, x0
LFQH_Lloh3124:
adr x1, LFQH_l_.str.39
LFQH_Lloh3125:
nop
mov	x0, x20
bl	LFQH_Get
mov	x2, x0
mov	x0, x21
mov	x1, x23
mov	x3, x22
bl	LFQH_ShelfTopHit
cbnz	x22, LFQH_LBB130_6
LFQH_LBB130_5:
LFQH_Lloh3126:
adr x1, LFQH_l_.str.106
LFQH_Lloh3127:
nop
mov	x0, x19
bl	LFQH_Get
mov	w1, #0
bl	LFQH_ShelfActionGlass
LFQH_LBB130_6:
mov	x0, x19
bl	LFQH_ShelfRememberFilterHeader
mov	w0, #10
bl	LFQH_PageOptionEnabled
mov	x20, x0
LFQH_Lloh3128:
adr x1, LFQH_l_.str.107
LFQH_Lloh3129:
nop
mov	x0, x19
bl	LFQH_Get
mov	x1, x20
bl	LFQH_ApplyShelfFilterButton
LFQH_Lloh3130:
adr x1, LFQH_l_.str.108
LFQH_Lloh3131:
nop
mov	x0, x19
bl	LFQH_Get
mov	x1, x20
ldp	x29, x30, [sp, #48]
ldp	x20, x19, [sp, #32]
ldp	x22, x21, [sp, #16]
ldp	x24, x23, [sp], #64
b	LFQH_ApplyShelfFilterButton
.cfi_endproc
.p2align	2
LFQH_ShelfLegacyFilterShow:
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
LFQH_Lloh3132:
adr x22, LFQH_l_.str.107
LFQH_Lloh3133:
nop
mov	x1, x22
bl	LFQH_Get
bl	LFQH_RestoreShelfFilterButton
LFQH_Lloh3134:
adr x0, LFQH_l_.str.21
LFQH_Lloh3135:
nop
LFQH_Lloh3136:
adr x1, LFQH_l_.str.285
LFQH_Lloh3137:
nop
bl	LFQH_Original
mov	x8, x0
mov	x0, x21
mov	x1, x20
mov	x2, x19
blr	x8
mov	x0, x21
mov	x1, x22
bl	LFQH_Get
mov	x19, x0
mov	w0, #10
bl	LFQH_PageOptionEnabled
mov	x1, x0
mov	x0, x19
ldp	x29, x30, [sp, #32]
ldp	x20, x19, [sp, #16]
ldp	x22, x21, [sp], #48
b	LFQH_ApplyShelfFilterButton
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
LFQH_Lloh3138:
adr x1, LFQH_l_.str.106
LFQH_Lloh3139:
nop
bl	LFQH_Get
mov	x21, x0
LFQH_Lloh3140:
adr x1, LFQH_l_.str.20
LFQH_Lloh3141:
nop
bl	LFQH_Get
cbz	x0, LFQH_LBB132_2
LFQH_Lloh3142:
adr x1, LFQH_ShelfEditHeaderKey
LFQH_Lloh3143:
nop
bl Lpatch + (0xa628 - PATCH_BASE)
cmp	x0, x20
b.eq	LFQH_LBB132_3
LFQH_LBB132_2:
mov	x0, x21
bl	LFQH_ShelfEditPadding
LFQH_Lloh3144:
adr x0, LFQH_l_.str.21
LFQH_Lloh3145:
nop
LFQH_Lloh3146:
adr x1, LFQH_l_.str.287
LFQH_Lloh3147:
nop
bl	LFQH_Original
mov	x2, x0
mov	x0, x20
mov	x1, x19
ldp	x29, x30, [sp, #32]
ldp	x20, x19, [sp, #16]
ldp	x22, x21, [sp], #48
br	x2
LFQH_LBB132_3:
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
LFQH_Lloh3148:
adr x1, LFQH_ShelfCompactKey
LFQH_Lloh3149:
nop
bl Lpatch + (0xa628 - PATCH_BASE)
cbz	x0, LFQH_LBB133_2
LFQH_Lloh3150:
adr x1, LFQH_l_.str.533
LFQH_Lloh3151:
nop
mov	x0, x22
bl	LFQH_Get
mov	x23, x0
LFQH_Lloh3152:
adr x0, LFQH_l_.str.357
LFQH_Lloh3153:
nop
bl Lpatch + (0xa5a4 - PATCH_BASE)
mov	x1, x0
mov	x0, x23
bl Lpatch + (0xa5d4 - PATCH_BASE)
LFQH_LBB133_2:
LFQH_Lloh3154:
adr x0, LFQH_l_.str.288
LFQH_Lloh3155:
nop
LFQH_Lloh3156:
adr x1, LFQH_l_.str.290
LFQH_Lloh3157:
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
stp	d11, d10, [sp, #-128]!
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
.cfi_offset b10, -120
.cfi_offset b11, -128
mov	x19, x2
mov	x22, x1
mov	x20, x0
and	x8, x2, #0xfffffffffffffffe
cmp	x8, #2
b.ne	LFQH_LBB134_3
LFQH_Lloh3158:
adr x1, LFQH_ShelfCompactKey
LFQH_Lloh3159:
nop
mov	x0, x20
bl Lpatch + (0xa628 - PATCH_BASE)
cbz	x0, LFQH_LBB134_3
LFQH_Lloh3160:
adr x1, LFQH_l_.str.533
LFQH_Lloh3161:
nop
mov	x0, x20
bl	LFQH_Get
mov	x21, x0
LFQH_Lloh3162:
adr x0, LFQH_l_.str.357
LFQH_Lloh3163:
nop
bl Lpatch + (0xa5a4 - PATCH_BASE)
mov	x1, x0
mov	x0, x21
bl Lpatch + (0xa5d4 - PATCH_BASE)
mov	w23, #1
b	LFQH_LBB134_4
LFQH_LBB134_3:
mov	x21, #0
mov	w23, #0
LFQH_LBB134_4:
LFQH_Lloh3164:
adr x0, LFQH_l_.str.288
LFQH_Lloh3165:
nop
LFQH_Lloh3166:
adr x1, LFQH_l_.str.292
LFQH_Lloh3167:
nop
bl	LFQH_Original
mov	x8, x0
mov	x0, x20
mov	x1, x22
mov	x2, x19
blr	x8
mov	x19, x0
cbz	w23, LFQH_LBB134_23
LFQH_Lloh3168:
adr x1, LFQH_ShelfCompactKey
LFQH_Lloh3169:
nop
mov	x0, x20
bl Lpatch + (0xa628 - PATCH_BASE)
cbz	x0, LFQH_LBB134_23
LFQH_Lloh3170:
adr x1, LFQH_l_.str.810
LFQH_Lloh3171:
nop
mov	x0, x19
bl	LFQH_Kind
cbz	w0, LFQH_LBB134_23
mov	x0, x19
bl Lpatch + (0xa664 - PATCH_BASE)
LFQH_Lloh3172:
adr x1, LFQH_l_.str.811
LFQH_Lloh3173:
nop
LFQH_Lloh3174:
adr x2, LFQH_l_.str.812
LFQH_Lloh3175:
nop
bl	LFQH_ClassABI
cbz	w0, LFQH_LBB134_23
LFQH_Lloh3176:
adr x1, LFQH_l_.str.813
LFQH_Lloh3177:
nop
mov	x0, x20
bl	LFQH_Get
LFQH_Lloh3178:
adr x1, LFQH_l_.str.814
LFQH_Lloh3179:
nop
bl	LFQH_Get
LFQH_Lloh3180:
adr x1, LFQH_l_.str.815
LFQH_Lloh3181:
nop
bl	LFQH_Get
mov	x20, x0
LFQH_Lloh3182:
adr x1, LFQH_l_.str.553
LFQH_Lloh3183:
nop
mov	x0, x21
bl	LFQH_Get
mov	x21, x0
LFQH_Lloh3184:
adr x0, LFQH_l_.str.34
LFQH_Lloh3185:
nop
bl Lpatch + (0xa5a4 - PATCH_BASE)
mov	x1, x0
mov	x0, x21
bl Lpatch + (0xa5d4 - PATCH_BASE)
mov	x22, x0
mov	x0, #0
cbz	x20, LFQH_LBB134_24
cbz	x22, LFQH_LBB134_24
mov	x23, #0
LFQH_Lloh3186:
adr x28, LFQH_l_.str.49
LFQH_Lloh3187:
nop
LFQH_LBB134_11:
LFQH_Lloh3188:
adr x0, LFQH_l_.str.461
LFQH_Lloh3189:
nop
bl Lpatch + (0xa5a4 - PATCH_BASE)
mov	x1, x0
mov	x0, x21
mov	x2, x23
bl Lpatch + (0xa5d4 - PATCH_BASE)
mov	x25, x0
LFQH_Lloh3190:
adr x1, LFQH_l_.str.169
LFQH_Lloh3191:
nop
bl	LFQH_Get
LFQH_Lloh3192:
adr x1, LFQH_l_.str.816
LFQH_Lloh3193:
nop
bl	LFQH_Get
mov	x26, x0
LFQH_Lloh3194:
adr x0, LFQH_l_.str.686
LFQH_Lloh3195:
nop
bl Lpatch + (0xa5a4 - PATCH_BASE)
mov	x1, x0
mov	x0, x26
bl Lpatch + (0xa5d4 - PATCH_BASE)
LFQH_Lloh3196:
adr x1, LFQH_l_.str.815
LFQH_Lloh3197:
nop
bl	LFQH_Get
mov	x26, x0
mov	x0, x28
bl Lpatch + (0xa5a4 - PATCH_BASE)
mov	x1, x0
mov	x0, x20
mov	x2, x26
bl Lpatch + (0xa5d4 - PATCH_BASE)
cbz	w0, LFQH_LBB134_20
mov	x0, x25
LFQH_Lloh3198:
adr x1, LFQH_l_.str.817
LFQH_Lloh3199:
nop
bl	LFQH_Get
mov	x26, x0
LFQH_Lloh3200:
adr x1, LFQH_l_.str.74
LFQH_Lloh3201:
nop
bl	LFQH_Get
cbz	x0, LFQH_LBB134_20
mov	x27, x0
mov	x0, x25
bl Lpatch + (0xa664 - PATCH_BASE)
LFQH_Lloh3202:
adr x24, LFQH_l_.str.818
LFQH_Lloh3203:
nop
mov	x1, x24
LFQH_Lloh3204:
adr x2, LFQH_l_.str.819
LFQH_Lloh3205:
nop
bl	LFQH_ClassABI
cbz	w0, LFQH_LBB134_23
LFQH_Lloh3206:
adr x0, LFQH_l_.str.24
LFQH_Lloh3207:
nop
bl Lpatch + (0xa5a4 - PATCH_BASE)
mov	x1, x0
mov	x0, x26
bl Lpatch + (0xa5d4 - PATCH_BASE)
fmov	d8, d0
fmov	d9, d1
fmov	d10, d2
fmov	d11, d3
LFQH_Lloh3208:
adr x0, LFQH_l_.str.507
LFQH_Lloh3209:
nop
bl Lpatch + (0xa5a4 - PATCH_BASE)
mov	x1, x0
mov	x0, x26
fmov	d0, d8
fmov	d1, d9
fmov	d2, d10
fmov	d3, d11
mov	x2, x27
bl Lpatch + (0xa5d4 - PATCH_BASE)
fmov	d8, d0
fmov	d9, d1
fmov	x26, d9
fmov	x27, d8
mov	x0, x24
bl Lpatch + (0xa5a4 - PATCH_BASE)
mov	x1, x0
mov	x0, x25
bl Lpatch + (0xa5d4 - PATCH_BASE)
fmov	d10, d0
fmov	x9, d10
and	x10, x27, #0x7fffffffffffffff
and	x8, x26, #0x7fffffffffffffff
mov	x12, #9218868437227405311
cmp	x8, x12
cset	w8, gt
and	x9, x9, #0x7fffffffffffffff
cmp	x9, x12
cset	w9, gt
mov	x11, #9218868437227405311
cmp	x10, x12
b.gt	LFQH_LBB134_20
tbnz	w8, #0, LFQH_LBB134_20
tbnz	w9, #0, LFQH_LBB134_20
fmov	d11, d1
fmov	x8, d11
and	x8, x8, #0x7fffffffffffffff
cmp	x8, x11
b.gt	LFQH_LBB134_20
fcmp	d10, #0.0
b.le	LFQH_LBB134_20
fcmp	d11, #0.0
b.gt	LFQH_LBB134_22
LFQH_LBB134_20:
add	x23, x23, #1
cmp	x23, x22
b.lo	LFQH_LBB134_11
mov	x0, #0
b	LFQH_LBB134_24
LFQH_LBB134_22:
LFQH_Lloh3210:
adr x0, LFQH_l_.str.811
LFQH_Lloh3211:
nop
bl Lpatch + (0xa5a4 - PATCH_BASE)
mov	x1, x0
mov	x0, x19
fmov	d0, d8
fmov	d1, d9
fmov	d2, d10
fmov	d3, d11
bl Lpatch + (0xa5d4 - PATCH_BASE)
LFQH_LBB134_23:
mov	x0, x19
LFQH_LBB134_24:
ldp	x29, x30, [sp, #112]
ldp	x20, x19, [sp, #96]
ldp	x22, x21, [sp, #80]
ldp	x24, x23, [sp, #64]
ldp	x26, x25, [sp, #48]
ldp	x28, x27, [sp, #32]
ldp	d9, d8, [sp, #16]
ldp	d11, d10, [sp], #128
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
LFQH_Lloh3212:
adr x0, LFQH_l_.str.121
LFQH_Lloh3213:
nop
LFQH_Lloh3214:
adr x1, LFQH_l_.str.295
LFQH_Lloh3215:
nop
bl	LFQH_Original
mov	x8, x0
mov	x0, x19
mov	x1, x20
blr	x8
mov	x20, x0
LFQH_Lloh3216:
adr x1, LFQH_l_.str.561
LFQH_Lloh3217:
nop
mov	x0, x19
bl	LFQH_Get
mov	x23, x0
LFQH_Lloh3218:
adr x1, LFQH_l_.str.33
LFQH_Lloh3219:
nop
mov	x0, x20
bl	LFQH_Kind
cbz	w0, LFQH_LBB135_12
LFQH_Lloh3220:
adr x1, LFQH_l_.str.33
LFQH_Lloh3221:
nop
mov	x0, x23
bl	LFQH_Kind
cbz	w0, LFQH_LBB135_12
mov	x0, x19
bl Lpatch + (0xa664 - PATCH_BASE)
LFQH_Lloh3222:
adr x1, LFQH_l_.str.847
LFQH_Lloh3223:
nop
LFQH_Lloh3224:
adr x2, LFQH_l_.str.186
LFQH_Lloh3225:
nop
bl	LFQH_ClassABI
cbz	w0, LFQH_LBB135_12
mov	x0, x19
bl Lpatch + (0xa664 - PATCH_BASE)
LFQH_Lloh3226:
adr x1, LFQH_l_.str.848
LFQH_Lloh3227:
nop
LFQH_Lloh3228:
adr x2, LFQH_l_.str.186
LFQH_Lloh3229:
nop
bl	LFQH_ClassABI
cbz	w0, LFQH_LBB135_12
LFQH_Lloh3230:
adr x0, LFQH_l_.str.34
LFQH_Lloh3231:
nop
bl Lpatch + (0xa5a4 - PATCH_BASE)
mov	x1, x0
mov	x0, x23
bl Lpatch + (0xa5d4 - PATCH_BASE)
cbz	x0, LFQH_LBB135_12
mov	x27, x0
LFQH_Lloh3232:
adr x0, LFQH_l_.str.34
LFQH_Lloh3233:
nop
bl Lpatch + (0xa5a4 - PATCH_BASE)
mov	x1, x0
mov	x0, x20
bl Lpatch + (0xa5d4 - PATCH_BASE)
cmp	x0, x27
b.ne	LFQH_LBB135_12
LFQH_Lloh3234:
adr x21, LFQH_l_.str.116
LFQH_Lloh3235:
nop
mov	x0, x21
bl Lpatch + (0xa5b0 - PATCH_BASE)
mov	x22, x0
LFQH_Lloh3236:
adr x24, LFQH_l_.str.415
LFQH_Lloh3237:
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
LFQH_Lloh3238:
adr x0, LFQH_l_.str.88
LFQH_Lloh3239:
nop
bl Lpatch + (0xa5b0 - PATCH_BASE)
mov	x22, x0
LFQH_Lloh3240:
adr x0, LFQH_l_.str.89
LFQH_Lloh3241:
nop
bl Lpatch + (0xa5a4 - PATCH_BASE)
mov	x1, x0
mov	x0, x22
bl Lpatch + (0xa5d4 - PATCH_BASE)
str	x0, [sp]
mov	x28, #0
mov	x26, #0
LFQH_LBB135_7:
LFQH_Lloh3242:
adr x0, LFQH_l_.str.461
LFQH_Lloh3243:
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
cbz	x0, LFQH_LBB135_9
bl	LFQH_DefaultEnabled
cbz	w0, LFQH_LBB135_10
LFQH_LBB135_9:
LFQH_Lloh3244:
adr x0, LFQH_l_.str.497
LFQH_Lloh3245:
nop
bl Lpatch + (0xa5b0 - PATCH_BASE)
mov	x22, x0
LFQH_Lloh3246:
adr x0, LFQH_l_.str.849
LFQH_Lloh3247:
nop
bl Lpatch + (0xa5a4 - PATCH_BASE)
mov	x1, x0
add	x25, x28, #1
mov	x0, x22
mov	x2, x28
bl Lpatch + (0xa5d4 - PATCH_BASE)
mov	x22, x0
LFQH_Lloh3248:
adr x0, LFQH_l_.str.514
LFQH_Lloh3249:
nop
bl Lpatch + (0xa5a4 - PATCH_BASE)
mov	x1, x0
ldr	x0, [sp]
mov	x2, x22
mov	x3, x24
bl Lpatch + (0xa5d4 - PATCH_BASE)
LFQH_Lloh3250:
adr x22, LFQH_l_.str.84
LFQH_Lloh3251:
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
LFQH_Lloh3252:
adr x0, LFQH_l_.str.461
LFQH_Lloh3253:
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
LFQH_LBB135_10:
add	x26, x26, #1
cmp	x27, x26
b.ne	LFQH_LBB135_7
cmp	x28, x27
b.ne	LFQH_LBB135_14
LFQH_LBB135_12:
mov	x21, x20
LFQH_LBB135_13:
mov	x0, x21
ldp	x29, x30, [sp, #96]
ldp	x20, x19, [sp, #80]
ldp	x22, x21, [sp, #64]
ldp	x24, x23, [sp, #48]
ldp	x26, x25, [sp, #32]
ldp	x28, x27, [sp, #16]
add	sp, sp, #112
ret
LFQH_LBB135_14:
cbnz	x28, LFQH_LBB135_16
LFQH_Lloh3254:
adr x24, LFQH_l_.str.461
LFQH_Lloh3255:
nop
mov	x0, x24
bl Lpatch + (0xa5a4 - PATCH_BASE)
mov	x1, x0
mov	x0, x23
mov	x2, #0
bl Lpatch + (0xa5d4 - PATCH_BASE)
mov	x22, x0
LFQH_Lloh3256:
adr x0, LFQH_l_.str.497
LFQH_Lloh3257:
nop
bl Lpatch + (0xa5b0 - PATCH_BASE)
mov	x23, x0
LFQH_Lloh3258:
adr x0, LFQH_l_.str.849
LFQH_Lloh3259:
nop
bl Lpatch + (0xa5a4 - PATCH_BASE)
mov	x1, x0
mov	x0, x23
mov	x2, #0
bl Lpatch + (0xa5d4 - PATCH_BASE)
mov	x23, x0
LFQH_Lloh3260:
adr x0, LFQH_l_.str.514
LFQH_Lloh3261:
nop
bl Lpatch + (0xa5a4 - PATCH_BASE)
mov	x1, x0
ldr	x0, [sp]
mov	x2, x23
mov	x3, x22
bl Lpatch + (0xa5d4 - PATCH_BASE)
LFQH_Lloh3262:
adr x23, LFQH_l_.str.84
LFQH_Lloh3263:
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
LFQH_LBB135_16:
LFQH_Lloh3264:
adr x0, LFQH_l_.str.847
LFQH_Lloh3265:
nop
bl Lpatch + (0xa5a4 - PATCH_BASE)
mov	x1, x0
mov	x0, x19
ldr	x2, [sp, #8]
bl Lpatch + (0xa5d4 - PATCH_BASE)
LFQH_Lloh3266:
adr x0, LFQH_l_.str.848
LFQH_Lloh3267:
nop
bl Lpatch + (0xa5a4 - PATCH_BASE)
mov	x1, x0
mov	x0, x19
ldr	x2, [sp]
bl Lpatch + (0xa5d4 - PATCH_BASE)
b	LFQH_LBB135_13
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
mov	x20, x2
mov	x21, x1
mov	x19, x0
LFQH_Lloh3268:
adr x0, LFQH_l_.str.121
LFQH_Lloh3269:
nop
LFQH_Lloh3270:
adr x1, LFQH_l_.str.297
LFQH_Lloh3271:
nop
bl	LFQH_Original
mov	x8, x0
mov	x0, x19
mov	x1, x21
mov	x2, x20
blr	x8
mov	x0, x19
bl	LFQH_InstallTabRecovery
LFQH_Lloh3272:
adr x1, LFQH_ReaderThemeLaunchKey
LFQH_Lloh3273:
nop
mov	x0, x19
bl Lpatch + (0xa628 - PATCH_BASE)
cbz	x0, LFQH_LBB136_2
ldp	x29, x30, [sp, #32]
ldp	x20, x19, [sp, #16]
ldp	x22, x21, [sp], #48
ret
LFQH_LBB136_2:
LFQH_Lloh3274:
adr x1, LFQH_ReaderThemeLaunchKey
LFQH_Lloh3275:
nop
mov	x0, x19
mov	x2, x19
mov	x3, #0
bl Lpatch + (0xa634 - PATCH_BASE)
ldp	x29, x30, [sp, #32]
ldp	x20, x19, [sp, #16]
ldp	x22, x21, [sp], #48
b	LFQH_FQHApplyReaderThemeIsolation
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
cbz	w0, LFQH_LBB137_8
LFQH_Lloh3276:
adr x0, LFQH_l_.str.44
LFQH_Lloh3277:
nop
LFQH_Lloh3278:
adr x19, LFQH_l_.str.178
LFQH_Lloh3279:
nop
LFQH_Lloh3280:
adr x2, LFQH_l_.str.298
LFQH_Lloh3281:
nop
LFQH_Lloh3282:
adr x20, LFQH_l_.str.9
LFQH_Lloh3283:
nop
LFQH_Lloh3284:
adr x4, LFQH_ListenLayout
LFQH_Lloh3285:
nop
mov	x1, x19
mov	x3, x20
bl	LFQH_Hook
LFQH_Lloh3286:
adr x21, LFQH_l_.str.59
LFQH_Lloh3287:
nop
LFQH_Lloh3288:
adr x2, LFQH_l_.str.299
LFQH_Lloh3289:
nop
LFQH_Lloh3290:
adr x4, LFQH_SpeechLayout
LFQH_Lloh3291:
nop
mov	x0, x21
mov	x1, x19
mov	x3, x20
bl	LFQH_Hook
LFQH_Lloh3292:
adr x1, LFQH_l_.str.300
LFQH_Lloh3293:
nop
LFQH_Lloh3294:
adr x2, LFQH_l_.str.301
LFQH_Lloh3295:
nop
LFQH_Lloh3296:
adr x3, LFQH_l_.str.186
LFQH_Lloh3297:
nop
LFQH_Lloh3298:
adr x4, LFQH_SpeechTheme
LFQH_Lloh3299:
nop
mov	x0, x21
bl	LFQH_Hook
LFQH_Lloh3300:
adr x0, LFQH_l_.str.7
LFQH_Lloh3301:
nop
bl Lpatch + (0xa5b0 - PATCH_BASE)
LFQH_Lloh3302:
adr x1, LFQH_l_.str.10
LFQH_Lloh3303:
nop
LFQH_Lloh3304:
adr x2, LFQH_l_.str.11
LFQH_Lloh3305:
nop
bl	LFQH_ClassABI
cbz	w0, LFQH_LBB137_4
LFQH_Lloh3306:
adr x19, LFQH_l_.str.7
LFQH_Lloh3307:
nop
LFQH_Lloh3308:
adr x1, LFQH_l_.str.8
LFQH_Lloh3309:
nop
LFQH_Lloh3310:
adr x2, LFQH_l_.str.302
LFQH_Lloh3311:
nop
LFQH_Lloh3312:
adr x4, LFQH_HomeLayout
LFQH_Lloh3313:
nop
mov	x0, x19
mov	x3, x20
bl	LFQH_Hook
LFQH_Lloh3314:
adr x1, LFQH_l_.str.296
LFQH_Lloh3315:
nop
LFQH_Lloh3316:
adr x2, LFQH_l_.str.303
LFQH_Lloh3317:
nop
LFQH_Lloh3318:
adr x3, LFQH_l_.str.113
LFQH_Lloh3319:
nop
LFQH_Lloh3320:
adr x4, LFQH_HomeAppear
LFQH_Lloh3321:
nop
mov	x0, x19
bl	LFQH_Hook
LFQH_Lloh3322:
adr x1, LFQH_l_.str.304
LFQH_Lloh3323:
nop
LFQH_Lloh3324:
adr x2, LFQH_l_.str.305
LFQH_Lloh3325:
nop
LFQH_Lloh3326:
adr x3, LFQH_l_.str.279
LFQH_Lloh3327:
nop
LFQH_Lloh3328:
adr x4, LFQH_BookstoreTabSelected
LFQH_Lloh3329:
nop
mov	x0, x19
bl	LFQH_Hook
LFQH_Lloh3330:
adr x0, LFQH_l_.str.306
LFQH_Lloh3331:
nop
LFQH_Lloh3332:
adr x1, LFQH_l_.str.307
LFQH_Lloh3333:
nop
LFQH_Lloh3334:
adr x2, LFQH_l_.str.308
LFQH_Lloh3335:
nop
LFQH_Lloh3336:
adr x4, LFQH_BookstoreCollectionLayout
LFQH_Lloh3337:
nop
mov	x3, x20
bl	LFQH_Hook
LFQH_Lloh3338:
adr x19, LFQH_l_.str.309
LFQH_Lloh3339:
nop
LFQH_Lloh3340:
adr x1, LFQH_l_.str.310
LFQH_Lloh3341:
nop
LFQH_Lloh3342:
adr x2, LFQH_l_.str.311
LFQH_Lloh3343:
nop
LFQH_Lloh3344:
adr x4, LFQH_BookstoreDoubleRowLayout
LFQH_Lloh3345:
nop
mov	x0, x19
mov	x3, x20
bl	LFQH_Hook
LFQH_Lloh3346:
adr x1, LFQH_l_.str.312
LFQH_Lloh3347:
nop
LFQH_Lloh3348:
adr x2, LFQH_l_.str.313
LFQH_Lloh3349:
nop
LFQH_Lloh3350:
adr x3, LFQH_l_.str.186
LFQH_Lloh3351:
nop
LFQH_Lloh3352:
adr x4, LFQH_BookstoreDoubleRowScroll
LFQH_Lloh3353:
nop
mov	x0, x19
bl	LFQH_Hook
LFQH_Lloh3354:
adr x0, LFQH_l_.str.314
LFQH_Lloh3355:
nop
bl Lpatch + (0xa5b0 - PATCH_BASE)
LFQH_Lloh3356:
adr x1, LFQH_l_.str.315
LFQH_Lloh3357:
nop
LFQH_Lloh3358:
adr x2, LFQH_l_.str.11
LFQH_Lloh3359:
nop
bl	LFQH_ClassABI
cbz	w0, LFQH_LBB137_4
LFQH_Lloh3360:
adr x0, LFQH_l_.str.314
LFQH_Lloh3361:
nop
LFQH_Lloh3362:
adr x1, LFQH_l_.str.316
LFQH_Lloh3363:
nop
LFQH_Lloh3364:
adr x2, LFQH_l_.str.317
LFQH_Lloh3365:
nop
LFQH_Lloh3366:
adr x3, LFQH_l_.str.318
LFQH_Lloh3367:
nop
LFQH_Lloh3368:
adr x4, LFQH_SearchColor
LFQH_Lloh3369:
nop
bl	LFQH_Hook
LFQH_LBB137_4:
LFQH_Lloh3370:
adr x20, LFQH_l_.str.25
LFQH_Lloh3371:
nop
LFQH_Lloh3372:
adr x21, LFQH_l_.str.178
LFQH_Lloh3373:
nop
LFQH_Lloh3374:
adr x2, LFQH_l_.str.319
LFQH_Lloh3375:
nop
LFQH_Lloh3376:
adr x19, LFQH_l_.str.9
LFQH_Lloh3377:
nop
LFQH_Lloh3378:
adr x4, LFQH_CategoryLayout
LFQH_Lloh3379:
nop
mov	x0, x20
mov	x1, x21
mov	x3, x19
bl	LFQH_Hook
LFQH_Lloh3380:
adr x1, LFQH_l_.str.320
LFQH_Lloh3381:
nop
LFQH_Lloh3382:
adr x2, LFQH_l_.str.321
LFQH_Lloh3383:
nop
LFQH_Lloh3384:
adr x3, LFQH_l_.str.318
LFQH_Lloh3385:
nop
LFQH_Lloh3386:
adr x4, LFQH_CategoryColor
LFQH_Lloh3387:
nop
mov	x0, x20
bl	LFQH_Hook
LFQH_Lloh3388:
adr x0, LFQH_l_.str.322
LFQH_Lloh3389:
nop
LFQH_Lloh3390:
adr x2, LFQH_l_.str.323
LFQH_Lloh3391:
nop
LFQH_Lloh3392:
adr x4, LFQH_ShelfButtonLayout
LFQH_Lloh3393:
nop
mov	x1, x21
mov	x3, x19
bl	LFQH_Hook
LFQH_Lloh3394:
adr x20, LFQH_l_.str.324
LFQH_Lloh3395:
nop
LFQH_Lloh3396:
adr x1, LFQH_l_.str.325
LFQH_Lloh3397:
nop
LFQH_Lloh3398:
adr x2, LFQH_l_.str.326
LFQH_Lloh3399:
nop
LFQH_Lloh3400:
adr x4, LFQH_BookshelfTopLayout
LFQH_Lloh3401:
nop
mov	x0, x20
mov	x3, x19
bl	LFQH_Hook
LFQH_Lloh3402:
adr x1, LFQH_l_.str.304
LFQH_Lloh3403:
nop
LFQH_Lloh3404:
adr x2, LFQH_l_.str.327
LFQH_Lloh3405:
nop
LFQH_Lloh3406:
adr x3, LFQH_l_.str.279
LFQH_Lloh3407:
nop
LFQH_Lloh3408:
adr x4, LFQH_BookshelfTabSelected
LFQH_Lloh3409:
nop
mov	x0, x20
bl	LFQH_Hook
LFQH_Lloh3410:
adr x20, LFQH_l_.str.288
LFQH_Lloh3411:
nop
LFQH_Lloh3412:
adr x1, LFQH_l_.str.328
LFQH_Lloh3413:
nop
LFQH_Lloh3414:
adr x2, LFQH_l_.str.329
LFQH_Lloh3415:
nop
LFQH_Lloh3416:
adr x4, LFQH_BookshelfUpdateInsets
LFQH_Lloh3417:
nop
mov	x0, x20
mov	x3, x19
bl	LFQH_Hook
LFQH_Lloh3418:
adr x1, LFQH_l_.str.330
LFQH_Lloh3419:
nop
LFQH_Lloh3420:
adr x2, LFQH_l_.str.331
LFQH_Lloh3421:
nop
LFQH_Lloh3422:
adr x4, LFQH_BookshelfFlowLayout
LFQH_Lloh3423:
nop
mov	x0, x20
mov	x3, x19
bl	LFQH_Hook
LFQH_Lloh3424:
adr x1, LFQH_l_.str.332
LFQH_Lloh3425:
nop
LFQH_Lloh3426:
adr x2, LFQH_l_.str.333
LFQH_Lloh3427:
nop
LFQH_Lloh3428:
adr x21, LFQH_l_.str.186
LFQH_Lloh3429:
nop
LFQH_Lloh3430:
adr x4, LFQH_BookshelfFloatingLayout
LFQH_Lloh3431:
nop
mov	x0, x20
mov	x3, x21
bl	LFQH_Hook
LFQH_Lloh3432:
adr x1, LFQH_l_.str.217
LFQH_Lloh3433:
nop
LFQH_Lloh3434:
adr x2, LFQH_l_.str.334
LFQH_Lloh3435:
nop
LFQH_Lloh3436:
adr x4, LFQH_ShelfLayout
LFQH_Lloh3437:
nop
mov	x0, x20
mov	x3, x19
bl	LFQH_Hook
LFQH_Lloh3438:
adr x1, LFQH_l_.str.335
LFQH_Lloh3439:
nop
LFQH_Lloh3440:
adr x2, LFQH_l_.str.336
LFQH_Lloh3441:
nop
LFQH_Lloh3442:
adr x4, LFQH_ShelfScroll
LFQH_Lloh3443:
nop
mov	x0, x20
mov	x3, x21
bl	LFQH_Hook
LFQH_Lloh3444:
adr x0, LFQH_l_.str.337
LFQH_Lloh3445:
nop
bl Lpatch + (0xa5b0 - PATCH_BASE)
LFQH_Lloh3446:
adr x1, LFQH_l_.str.338
LFQH_Lloh3447:
nop
LFQH_Lloh3448:
adr x2, LFQH_l_.str.11
LFQH_Lloh3449:
nop
bl	LFQH_ClassABI
cbz	w0, LFQH_LBB137_7
LFQH_Lloh3450:
adr x0, LFQH_l_.str.337
LFQH_Lloh3451:
nop
bl Lpatch + (0xa5b0 - PATCH_BASE)
LFQH_Lloh3452:
adr x1, LFQH_l_.str.339
LFQH_Lloh3453:
nop
LFQH_Lloh3454:
adr x2, LFQH_l_.str.149
LFQH_Lloh3455:
nop
bl	LFQH_ClassABI
cbz	w0, LFQH_LBB137_7
LFQH_Lloh3456:
adr x19, LFQH_l_.str.337
LFQH_Lloh3457:
nop
LFQH_Lloh3458:
adr x1, LFQH_l_.str.340
LFQH_Lloh3459:
nop
LFQH_Lloh3460:
adr x2, LFQH_l_.str.341
LFQH_Lloh3461:
nop
LFQH_Lloh3462:
adr x3, LFQH_l_.str.113
LFQH_Lloh3463:
nop
LFQH_Lloh3464:
adr x4, LFQH_TopChromeRefreshHostHidden
LFQH_Lloh3465:
nop
mov	x0, x19
bl	LFQH_Hook
LFQH_Lloh3466:
adr x1, LFQH_l_.str.342
LFQH_Lloh3467:
nop
LFQH_Lloh3468:
adr x2, LFQH_l_.str.343
LFQH_Lloh3469:
nop
LFQH_Lloh3470:
adr x3, LFQH_l_.str.344
LFQH_Lloh3471:
nop
LFQH_Lloh3472:
adr x4, LFQH_TopChromeRefreshState
LFQH_Lloh3473:
nop
mov	x0, x19
bl	LFQH_Hook
LFQH_Lloh3474:
adr x1, LFQH_l_.str.345
LFQH_Lloh3475:
nop
LFQH_Lloh3476:
adr x2, LFQH_l_.str.346
LFQH_Lloh3477:
nop
LFQH_Lloh3478:
adr x3, LFQH_l_.str.9
LFQH_Lloh3479:
nop
LFQH_Lloh3480:
adr x4, LFQH_TopChromeRefreshAnimationLayout
LFQH_Lloh3481:
nop
mov	x0, x19
bl	LFQH_Hook
LFQH_Lloh3482:
adr x0, LFQH_l_.str.306
LFQH_Lloh3483:
nop
LFQH_Lloh3484:
adr x1, LFQH_l_.str.335
LFQH_Lloh3485:
nop
LFQH_Lloh3486:
adr x2, LFQH_l_.str.347
LFQH_Lloh3487:
nop
LFQH_Lloh3488:
adr x3, LFQH_l_.str.186
LFQH_Lloh3489:
nop
LFQH_Lloh3490:
adr x4, LFQH_BookstoreCollectionScroll
LFQH_Lloh3491:
nop
bl	LFQH_Hook
LFQH_LBB137_7:
LFQH_Lloh3492:
adr x19, LFQH_l_.str.37
LFQH_Lloh3493:
nop
LFQH_Lloh3494:
adr x1, LFQH_l_.str.178
LFQH_Lloh3495:
nop
LFQH_Lloh3496:
adr x2, LFQH_l_.str.348
LFQH_Lloh3497:
nop
LFQH_Lloh3498:
adr x3, LFQH_l_.str.9
LFQH_Lloh3499:
nop
LFQH_Lloh3500:
adr x4, LFQH_ReaderLayout
LFQH_Lloh3501:
nop
mov	x0, x19
bl	LFQH_Hook
LFQH_Lloh3502:
adr x1, LFQH_l_.str.349
LFQH_Lloh3503:
nop
LFQH_Lloh3504:
adr x2, LFQH_l_.str.350
LFQH_Lloh3505:
nop
LFQH_Lloh3506:
adr x3, LFQH_l_.str.186
LFQH_Lloh3507:
nop
LFQH_Lloh3508:
adr x4, LFQH_ReaderTheme
LFQH_Lloh3509:
nop
mov	x0, x19
ldp	x29, x30, [sp, #32]
ldp	x20, x19, [sp, #16]
ldp	x22, x21, [sp], #48
b	LFQH_Hook
LFQH_LBB137_8:
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
LFQH_Lloh3510:
adr x0, LFQH_l_.str.44
LFQH_Lloh3511:
nop
LFQH_Lloh3512:
adr x1, LFQH_l_.str.298
LFQH_Lloh3513:
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
LFQH_Lloh3514:
adr x0, LFQH_l_.str.59
LFQH_Lloh3515:
nop
LFQH_Lloh3516:
adr x1, LFQH_l_.str.299
LFQH_Lloh3517:
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
LFQH_Lloh3518:
adr x0, LFQH_l_.str.59
LFQH_Lloh3519:
nop
LFQH_Lloh3520:
adr x1, LFQH_l_.str.301
LFQH_Lloh3521:
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
LFQH_Lloh3522:
adr x0, LFQH_l_.str.7
LFQH_Lloh3523:
nop
LFQH_Lloh3524:
adr x1, LFQH_l_.str.302
LFQH_Lloh3525:
nop
bl	LFQH_Original
mov	x8, x0
mov	x0, x20
mov	x1, x19
blr	x8
LFQH_Lloh3526:
adr x1, LFQH_l_.str.10
LFQH_Lloh3527:
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
LFQH_Lloh3528:
adr x0, LFQH_l_.str.7
LFQH_Lloh3529:
nop
LFQH_Lloh3530:
adr x1, LFQH_l_.str.303
LFQH_Lloh3531:
nop
bl	LFQH_Original
mov	x8, x0
mov	x0, x21
mov	x1, x20
mov	x2, x19
blr	x8
LFQH_Lloh3532:
adr x1, LFQH_l_.str.10
LFQH_Lloh3533:
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
LFQH_Lloh3534:
adr x0, LFQH_l_.str.7
LFQH_Lloh3535:
nop
LFQH_Lloh3536:
adr x1, LFQH_l_.str.305
LFQH_Lloh3537:
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
LFQH_Lloh3538:
adr x0, LFQH_l_.str.306
LFQH_Lloh3539:
nop
LFQH_Lloh3540:
adr x1, LFQH_l_.str.308
LFQH_Lloh3541:
nop
bl	LFQH_Original
mov	x8, x0
mov	x0, x19
mov	x1, x20
blr	x8
LFQH_Lloh3542:
adr x1, LFQH_l_.str.120
LFQH_Lloh3543:
nop
mov	x0, x19
bl	LFQH_Get
mov	x20, x0
LFQH_Lloh3544:
adr x1, LFQH_l_.str.7
LFQH_Lloh3545:
nop
bl	LFQH_Kind
cbz	w0, LFQH_LBB144_2
LFQH_Lloh3546:
adr x1, LFQH_l_.str.687
LFQH_Lloh3547:
nop
mov	x0, x20
bl	LFQH_Get
mov	x1, x0
mov	x0, x20
bl	LFQH_BookstoreCurrentTab
cmp	x0, x19
b.eq	LFQH_LBB144_3
LFQH_LBB144_2:
ldp	x29, x30, [sp, #16]
ldp	x20, x19, [sp], #32
ret
LFQH_LBB144_3:
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
LFQH_Lloh3548:
adr x0, LFQH_l_.str.309
LFQH_Lloh3549:
nop
LFQH_Lloh3550:
adr x1, LFQH_l_.str.311
LFQH_Lloh3551:
nop
bl	LFQH_Original
mov	x8, x0
mov	x0, x19
mov	x1, x20
blr	x8
LFQH_Lloh3552:
adr x1, LFQH_l_.str.120
LFQH_Lloh3553:
nop
mov	x0, x19
bl	LFQH_Get
mov	x20, x0
LFQH_Lloh3554:
adr x1, LFQH_l_.str.687
LFQH_Lloh3555:
nop
bl	LFQH_Get
mov	x21, x0
LFQH_Lloh3556:
adr x1, LFQH_l_.str.7
LFQH_Lloh3557:
nop
mov	x0, x20
bl	LFQH_Kind
cbz	w0, LFQH_LBB145_2
mov	x0, x20
mov	x1, x21
bl	LFQH_BookstoreCurrentTab
cmp	x0, x19
b.eq	LFQH_LBB145_3
LFQH_LBB145_2:
ldp	x29, x30, [sp, #32]
ldp	x20, x19, [sp, #16]
ldp	x22, x21, [sp], #48
ret
LFQH_LBB145_3:
mov	x0, x20
ldp	x29, x30, [sp, #32]
ldp	x20, x19, [sp, #16]
ldp	x22, x21, [sp], #48
b	LFQH_BookstoreTopChrome
.cfi_endproc
.p2align	2
LFQH_BookstoreDoubleRowScroll:
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
mov	x21, x1
mov	x20, x0
LFQH_Lloh3558:
adr x0, LFQH_l_.str.309
LFQH_Lloh3559:
nop
LFQH_Lloh3560:
adr x1, LFQH_l_.str.313
LFQH_Lloh3561:
nop
bl	LFQH_Original
mov	x8, x0
mov	x0, x20
mov	x1, x21
mov	x2, x19
blr	x8
LFQH_Lloh3562:
adr x1, LFQH_l_.str.120
LFQH_Lloh3563:
nop
mov	x0, x20
bl	LFQH_Get
mov	x21, x0
LFQH_Lloh3564:
adr x1, LFQH_l_.str.7
LFQH_Lloh3565:
nop
bl	LFQH_Kind
cbz	w0, LFQH_LBB146_18
LFQH_Lloh3566:
adr x1, LFQH_l_.str.864
LFQH_Lloh3567:
nop
mov	x0, x20
bl	LFQH_Get
mov	x22, x0
LFQH_Lloh3568:
adr x1, LFQH_BookstoreViewportKey
LFQH_Lloh3569:
nop
mov	x0, x21
bl Lpatch + (0xa628 - PATCH_BASE)
mov	x23, x0
LFQH_Lloh3570:
adr x1, LFQH_TopChromeFrameKey
LFQH_Lloh3571:
nop
bl Lpatch + (0xa628 - PATCH_BASE)
cbz	x0, LFQH_LBB146_4
mov	x24, x0
LFQH_Lloh3572:
adr x0, LFQH_l_.str.372
LFQH_Lloh3573:
nop
bl Lpatch + (0xa5a4 - PATCH_BASE)
mov	x1, x0
mov	x0, x23
bl Lpatch + (0xa5d4 - PATCH_BASE)
fmov	d9, d0
fmov	d10, d1
fmov	d11, d2
fmov	d8, d3
LFQH_Lloh3574:
adr x0, LFQH_l_.str.432
LFQH_Lloh3575:
nop
bl Lpatch + (0xa5a4 - PATCH_BASE)
mov	x1, x0
mov	x0, x24
bl Lpatch + (0xa5d4 - PATCH_BASE)
fcmp	d9, d0
fccmp	d10, d1, #0, eq
fccmp	d11, d2, #0, eq
b.eq	LFQH_LBB146_13
LFQH_LBB146_3:
mov	w0, #1
cbnz	w0, LFQH_LBB146_15
b	LFQH_LBB146_17
LFQH_LBB146_4:
cbz	x23, LFQH_LBB146_20
LFQH_Lloh3576:
adr x1, LFQH_BookstoreUnexpandedFrameKey
LFQH_Lloh3577:
nop
mov	x0, x21
bl Lpatch + (0xa628 - PATCH_BASE)
mov	x24, x0
mov	w0, #1
cbz	x24, LFQH_LBB146_14
cbz	x22, LFQH_LBB146_14
LFQH_Lloh3578:
adr x1, LFQH_BookstoreUnexpandedScrollKey
LFQH_Lloh3579:
nop
mov	x0, x21
bl Lpatch + (0xa628 - PATCH_BASE)
cmp	x22, x0
b.ne	LFQH_LBB146_3
LFQH_Lloh3580:
adr x0, LFQH_l_.str.372
LFQH_Lloh3581:
nop
bl Lpatch + (0xa5a4 - PATCH_BASE)
mov	x1, x0
mov	x0, x23
bl Lpatch + (0xa5d4 - PATCH_BASE)
fmov	d11, d0
fmov	d10, d1
fmov	d9, d2
fmov	d8, d3
LFQH_Lloh3582:
adr x0, LFQH_l_.str.432
LFQH_Lloh3583:
nop
bl Lpatch + (0xa5a4 - PATCH_BASE)
mov	x1, x0
mov	x0, x24
bl Lpatch + (0xa5d4 - PATCH_BASE)
mov	w0, #1
fcmp	d11, d0
b.ne	LFQH_LBB146_14
fcmp	d10, d1
b.ne	LFQH_LBB146_14
fcmp	d9, d2
b.ne	LFQH_LBB146_14
fcmp	d8, d3
b.ne	LFQH_LBB146_14
bl	LFQH_Enabled
cmp	w0, #0
cset	w0, eq
cbnz	w0, LFQH_LBB146_15
b	LFQH_LBB146_17
LFQH_LBB146_13:
fcmp	d8, d3
cset	w0, ne
LFQH_LBB146_14:
cbz	w0, LFQH_LBB146_17
LFQH_LBB146_15:
LFQH_Lloh3584:
adr x1, LFQH_l_.str.687
LFQH_Lloh3585:
nop
mov	x0, x21
bl	LFQH_Get
mov	x1, x0
mov	x0, x21
bl	LFQH_BookstoreCurrentTab
cmp	x0, x20
b.ne	LFQH_LBB146_17
mov	x0, x21
bl	LFQH_BookstoreTopChrome
LFQH_Lloh3586:
adr x1, LFQH_l_.str.864
LFQH_Lloh3587:
nop
mov	x0, x20
bl	LFQH_Get
mov	x22, x0
LFQH_LBB146_17:
cmp	x22, x19
b.eq	LFQH_LBB146_19
LFQH_LBB146_18:
ldp	x29, x30, [sp, #80]
ldp	x20, x19, [sp, #64]
ldp	x22, x21, [sp, #48]
ldp	x24, x23, [sp, #32]
ldp	d9, d8, [sp, #16]
ldp	d11, d10, [sp], #96
ret
LFQH_LBB146_19:
mov	x0, x19
ldp	x29, x30, [sp, #80]
ldp	x20, x19, [sp, #64]
ldp	x22, x21, [sp, #48]
ldp	x24, x23, [sp, #32]
ldp	d9, d8, [sp, #16]
ldp	d11, d10, [sp], #96
b	LFQH_TopChromeRefreshVisibility
LFQH_LBB146_20:
bl	LFQH_Enabled
cbnz	w0, LFQH_LBB146_15
b	LFQH_LBB146_17
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
fmov	d8, d0
mov	x23, x1
mov	x24, x0
LFQH_Lloh3588:
adr x0, LFQH_l_.str.314
LFQH_Lloh3589:
nop
LFQH_Lloh3590:
adr x1, LFQH_l_.str.317
LFQH_Lloh3591:
nop
bl	LFQH_Original
mov	x8, x0
mov	x0, x24
mov	x1, x23
fmov	d0, d8
mov	x2, x22
mov	x3, x21
mov	x4, x20
mov	x5, x19
blr	x8
LFQH_Lloh3592:
adr x1, LFQH_l_.str.315
LFQH_Lloh3593:
nop
mov	x0, x24
bl	LFQH_Get
LFQH_Lloh3594:
adr x1, LFQH_l_.str.10
LFQH_Lloh3595:
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
LFQH_Lloh3596:
adr x0, LFQH_l_.str.25
LFQH_Lloh3597:
nop
LFQH_Lloh3598:
adr x1, LFQH_l_.str.319
LFQH_Lloh3599:
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
fmov	d8, d0
mov	x23, x1
mov	x24, x0
LFQH_Lloh3600:
adr x0, LFQH_l_.str.25
LFQH_Lloh3601:
nop
LFQH_Lloh3602:
adr x1, LFQH_l_.str.321
LFQH_Lloh3603:
nop
bl	LFQH_Original
mov	x8, x0
mov	x0, x24
mov	x1, x23
fmov	d0, d8
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
LFQH_Lloh3604:
adr x0, LFQH_l_.str.322
LFQH_Lloh3605:
nop
LFQH_Lloh3606:
adr x1, LFQH_l_.str.323
LFQH_Lloh3607:
nop
bl	LFQH_Original
mov	x8, x0
mov	x0, x19
mov	x1, x20
blr	x8
LFQH_Lloh3608:
adr x1, LFQH_ShelfRoleKey
LFQH_Lloh3609:
nop
mov	x0, x19
bl Lpatch + (0xa628 - PATCH_BASE)
cbz	x0, LFQH_LBB150_2
mov	x20, x0
LFQH_Lloh3610:
adr x0, LFQH_l_.str.41
LFQH_Lloh3611:
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
LFQH_LBB150_2:
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
LFQH_Lloh3612:
adr x0, LFQH_l_.str.324
LFQH_Lloh3613:
nop
LFQH_Lloh3614:
adr x1, LFQH_l_.str.326
LFQH_Lloh3615:
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
LFQH_Lloh3616:
adr x0, LFQH_l_.str.324
LFQH_Lloh3617:
nop
LFQH_Lloh3618:
adr x1, LFQH_l_.str.327
LFQH_Lloh3619:
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
LFQH_Lloh3620:
adr x0, LFQH_l_.str.288
LFQH_Lloh3621:
nop
LFQH_Lloh3622:
adr x1, LFQH_l_.str.329
LFQH_Lloh3623:
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
LFQH_BookshelfFlowLayout:
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
LFQH_Lloh3624:
adr x0, LFQH_l_.str.288
LFQH_Lloh3625:
nop
LFQH_Lloh3626:
adr x1, LFQH_l_.str.331
LFQH_Lloh3627:
nop
bl	LFQH_Original
mov	x8, x0
mov	x0, x20
mov	x1, x19
blr	x8
mov	x0, x20
ldp	x29, x30, [sp, #16]
ldp	x20, x19, [sp], #32
b	LFQH_BookshelfSectionPinning
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
mov	x19, x1
mov	x21, x0
cbz	x2, LFQH_LBB155_4
LFQH_Lloh3628:
adr x1, LFQH_TopChromeInsetKey
LFQH_Lloh3629:
nop
mov	x0, x20
bl Lpatch + (0xa628 - PATCH_BASE)
cbz	x0, LFQH_LBB155_4
LFQH_Lloh3630:
adr x1, LFQH_l_.str.533
LFQH_Lloh3631:
nop
mov	x0, x21
bl	LFQH_Get
cmp	x0, x20
b.ne	LFQH_LBB155_4
bl	LFQH_Enabled
cmp	w0, #0
csel	x20, x20, xzr, eq
LFQH_LBB155_4:
LFQH_Lloh3632:
adr x0, LFQH_l_.str.288
LFQH_Lloh3633:
nop
LFQH_Lloh3634:
adr x1, LFQH_l_.str.333
LFQH_Lloh3635:
nop
bl	LFQH_Original
mov	x3, x0
mov	x0, x21
mov	x1, x19
mov	x2, x20
ldp	x29, x30, [sp, #32]
ldp	x20, x19, [sp, #16]
ldp	x22, x21, [sp], #48
br	x3
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
LFQH_Lloh3636:
adr x0, LFQH_l_.str.288
LFQH_Lloh3637:
nop
LFQH_Lloh3638:
adr x1, LFQH_l_.str.334
LFQH_Lloh3639:
nop
bl	LFQH_Original
mov	x8, x0
mov	x0, x20
mov	x1, x19
blr	x8
mov	x0, x20
bl	LFQH_BookshelfSectionPinning
mov	x0, x20
bl	LFQH_FQHShelf
mov	x0, x20
bl	LFQH_RestoreBookshelfTopInset
LFQH_Lloh3640:
adr x1, LFQH_l_.str.533
LFQH_Lloh3641:
nop
mov	x0, x20
bl	LFQH_Get
mov	x19, x0
bl	LFQH_TopChromeRefreshVisibility
mov	x0, x20
mov	x1, x19
ldp	x29, x30, [sp, #16]
ldp	x20, x19, [sp], #32
b	LFQH_BookshelfRestingTint
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
mov	x21, x1
mov	x20, x0
LFQH_Lloh3642:
adr x0, LFQH_l_.str.288
LFQH_Lloh3643:
nop
LFQH_Lloh3644:
adr x1, LFQH_l_.str.336
LFQH_Lloh3645:
nop
bl	LFQH_Original
mov	x8, x0
mov	x0, x20
mov	x1, x21
mov	x2, x19
blr	x8
LFQH_Lloh3646:
adr x1, LFQH_l_.str.533
LFQH_Lloh3647:
nop
mov	x0, x20
bl	LFQH_Get
cmp	x0, x19
b.eq	LFQH_LBB157_2
ldp	x29, x30, [sp, #32]
ldp	x20, x19, [sp, #16]
ldp	x22, x21, [sp], #48
ret
LFQH_LBB157_2:
mov	x0, x19
bl	LFQH_TopChromeRefreshVisibility
mov	x0, x20
mov	x1, x19
ldp	x29, x30, [sp, #32]
ldp	x20, x19, [sp, #16]
ldp	x22, x21, [sp], #48
b	LFQH_BookshelfRestingTint
.cfi_endproc
.p2align	2
LFQH_TopChromeRefreshHostHidden:
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
LFQH_Lloh3648:
adr x1, LFQH_l_.str.338
LFQH_Lloh3649:
nop
bl	LFQH_Get
mov	x22, x0
LFQH_Lloh3650:
adr x1, LFQH_TopChromeRefreshHiddenKey
LFQH_Lloh3651:
nop
bl Lpatch + (0xa628 - PATCH_BASE)
cbz	x0, LFQH_LBB158_2
LFQH_Lloh3652:
adr x0, LFQH_l_.str.497
LFQH_Lloh3653:
nop
bl Lpatch + (0xa5b0 - PATCH_BASE)
mov	x23, x0
LFQH_Lloh3654:
adr x0, LFQH_l_.str.499
LFQH_Lloh3655:
nop
bl Lpatch + (0xa5a4 - PATCH_BASE)
mov	x1, x0
mov	x0, x23
mov	x2, x21
bl Lpatch + (0xa5d4 - PATCH_BASE)
mov	x2, x0
LFQH_Lloh3656:
adr x1, LFQH_TopChromeRefreshHiddenKey
LFQH_Lloh3657:
nop
mov	w21, #1
mov	x0, x22
mov	w3, #1
bl Lpatch + (0xa634 - PATCH_BASE)
LFQH_LBB158_2:
LFQH_Lloh3658:
adr x0, LFQH_l_.str.337
LFQH_Lloh3659:
nop
LFQH_Lloh3660:
adr x1, LFQH_l_.str.341
LFQH_Lloh3661:
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
LFQH_TopChromeRefreshState:
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
LFQH_Lloh3662:
adr x0, LFQH_l_.str.337
LFQH_Lloh3663:
nop
LFQH_Lloh3664:
adr x1, LFQH_l_.str.343
LFQH_Lloh3665:
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
b	LFQH_TopChromeRefreshHeaderVisibility
.cfi_endproc
.p2align	2
LFQH_TopChromeRefreshAnimationLayout:
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
LFQH_Lloh3666:
adr x0, LFQH_l_.str.337
LFQH_Lloh3667:
nop
LFQH_Lloh3668:
adr x1, LFQH_l_.str.346
LFQH_Lloh3669:
nop
bl	LFQH_Original
mov	x8, x0
mov	x0, x20
mov	x1, x19
blr	x8
mov	x0, x20
ldp	x29, x30, [sp, #16]
ldp	x20, x19, [sp], #32
b	LFQH_TopChromeRefreshHeaderVisibility
.cfi_endproc
.p2align	2
LFQH_BookstoreCollectionScroll:
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
LFQH_Lloh3670:
adr x0, LFQH_l_.str.306
LFQH_Lloh3671:
nop
LFQH_Lloh3672:
adr x1, LFQH_l_.str.347
LFQH_Lloh3673:
nop
bl	LFQH_Original
mov	x8, x0
mov	x0, x21
mov	x1, x20
mov	x2, x19
blr	x8
LFQH_Lloh3674:
adr x1, LFQH_l_.str.533
LFQH_Lloh3675:
nop
mov	x0, x21
bl	LFQH_Get
cmp	x0, x19
b.eq	LFQH_LBB161_2
ldp	x29, x30, [sp, #32]
ldp	x20, x19, [sp, #16]
ldp	x22, x21, [sp], #48
ret
LFQH_LBB161_2:
mov	x0, x19
ldp	x29, x30, [sp, #32]
ldp	x20, x19, [sp, #16]
ldp	x22, x21, [sp], #48
b	LFQH_TopChromeRefreshVisibility
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
LFQH_Lloh3676:
adr x0, LFQH_l_.str.37
LFQH_Lloh3677:
nop
LFQH_Lloh3678:
adr x1, LFQH_l_.str.348
LFQH_Lloh3679:
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
LFQH_Lloh3680:
adr x0, LFQH_l_.str.37
LFQH_Lloh3681:
nop
LFQH_Lloh3682:
adr x1, LFQH_l_.str.350
LFQH_Lloh3683:
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
LFQH_FQHBottomPan178:
.cfi_startproc
stp	d11, d10, [sp, #-128]!
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
.cfi_offset b10, -120
.cfi_offset b11, -128
mov	x21, x2
mov	x20, x0
LFQH_Lloh3684:
adr x1, LFQH_BottomBarBox178Key
LFQH_Lloh3685:
nop
bl Lpatch + (0xa628 - PATCH_BASE)
LFQH_Lloh3686:
adr x1, LFQH_l_.str.81
LFQH_Lloh3687:
nop
bl	LFQH_Get
mov	x19, x0
LFQH_Lloh3688:
adr x1, LFQH_l_.str.120
LFQH_Lloh3689:
nop
bl	LFQH_Get
mov	x24, x0
LFQH_Lloh3690:
adr x1, LFQH_l_.str.74
LFQH_Lloh3691:
nop
mov	x0, x19
bl	LFQH_Get
cbz	x19, LFQH_LBB164_28
mov	x23, x0
LFQH_Lloh3692:
adr x1, LFQH_BottomPanBox178Key
LFQH_Lloh3693:
nop
mov	x0, x20
bl Lpatch + (0xa628 - PATCH_BASE)
LFQH_Lloh3694:
adr x1, LFQH_l_.str.81
LFQH_Lloh3695:
nop
bl	LFQH_Get
cmp	x0, x21
b.ne	LFQH_LBB164_28
LFQH_Lloh3696:
adr x1, LFQH_l_.str.351
LFQH_Lloh3697:
nop
mov	x0, x21
bl	LFQH_Get
mov	x22, x0
LFQH_Lloh3698:
adr x1, LFQH_l_.str.124
LFQH_Lloh3699:
nop
mov	x0, x24
bl	LFQH_Get
mov	x25, x0
bl	LFQH_Enabled
cbz	w0, LFQH_LBB164_6
mov	w0, #2
bl	LFQH_BottomFlag178
cbz	w0, LFQH_LBB164_6
mov	x0, x24
bl	LFQH_BottomIsDrama178
cbz	w0, LFQH_LBB164_6
LFQH_Lloh3700:
adr x1, LFQH_l_.str.352
LFQH_Lloh3701:
nop
mov	x0, x24
bl	LFQH_Get
cbz	x0, LFQH_LBB164_30
LFQH_LBB164_6:
mov	w26, #0
LFQH_LBB164_7:
LFQH_Lloh3702:
adr x0, LFQH_l_.str.354
LFQH_Lloh3703:
nop
bl Lpatch + (0xa5a4 - PATCH_BASE)
mov	x1, x0
mov	x0, x21
bl Lpatch + (0xa5d4 - PATCH_BASE)
mov	x24, x0
LFQH_Lloh3704:
adr x1, LFQH_BottomCompact178Key
LFQH_Lloh3705:
nop
mov	x0, x19
bl Lpatch + (0xa628 - PATCH_BASE)
LFQH_Lloh3706:
adr x1, LFQH_l_.str.41
LFQH_Lloh3707:
nop
bl	LFQH_BoolProp
mov	x23, x0
cbz	w26, LFQH_LBB164_14
and	x8, x24, #0xfffffffffffffffe
cmp	x8, #4
b.eq	LFQH_LBB164_14
cmp	x24, #3
b.eq	LFQH_LBB164_25
cmp	x24, #2
b.eq	LFQH_LBB164_15
cmp	x24, #1
b.ne	LFQH_LBB164_27
LFQH_Lloh3708:
adr x21, LFQH_l_.str.497
LFQH_Lloh3709:
nop
mov	x0, x21
bl Lpatch + (0xa5b0 - PATCH_BASE)
mov	x22, x0
LFQH_Lloh3710:
adr x0, LFQH_l_.str.499
LFQH_Lloh3711:
nop
bl Lpatch + (0xa5a4 - PATCH_BASE)
mov	x1, x0
mov	x0, x22
mov	w2, #1
bl Lpatch + (0xa5d4 - PATCH_BASE)
mov	x2, x0
LFQH_Lloh3712:
adr x1, LFQH_BottomPanActive178Key
LFQH_Lloh3713:
nop
mov	x0, x20
mov	w3, #1
bl Lpatch + (0xa634 - PATCH_BASE)
LFQH_Lloh3714:
adr x1, LFQH_BottomPanVertical178Key
LFQH_Lloh3715:
nop
mov	x0, x20
mov	x2, #0
mov	w3, #1
bl Lpatch + (0xa634 - PATCH_BASE)
mov	x0, x21
bl Lpatch + (0xa5b0 - PATCH_BASE)
mov	x21, x0
LFQH_Lloh3716:
adr x0, LFQH_l_.str.515
LFQH_Lloh3717:
nop
bl Lpatch + (0xa5a4 - PATCH_BASE)
mov	x1, x0
fmov	d0, xzr
mov	x0, x21
bl Lpatch + (0xa5d4 - PATCH_BASE)
LFQH_LBB164_13:
mov	x2, x0
LFQH_Lloh3718:
adr x1, LFQH_BottomPanY178Key
LFQH_Lloh3719:
nop
mov	x0, x20
b	LFQH_LBB164_26
LFQH_LBB164_14:
LFQH_Lloh3720:
adr x1, LFQH_BottomPanActive178Key
LFQH_Lloh3721:
nop
mov	x0, x20
mov	x2, #0
mov	w3, #1
bl Lpatch + (0xa634 - PATCH_BASE)
mov	x0, x19
mov	w1, #0
bl	LFQH_BottomSetCompact178
b	LFQH_LBB164_27
LFQH_LBB164_15:
LFQH_Lloh3722:
adr x1, LFQH_BottomPanActive178Key
LFQH_Lloh3723:
nop
mov	x0, x20
bl Lpatch + (0xa628 - PATCH_BASE)
cbz	x0, LFQH_LBB164_27
LFQH_Lloh3724:
adr x0, LFQH_l_.str.355
LFQH_Lloh3725:
nop
bl Lpatch + (0xa5a4 - PATCH_BASE)
mov	x1, x0
mov	x0, x21
mov	x2, x22
bl Lpatch + (0xa5d4 - PATCH_BASE)
fmov	d9, d0
fmov	d8, d1
fmov	x8, d8
fmov	x9, d9
and	x9, x9, #0x7fffffffffffffff
and	x8, x8, #0x7fffffffffffffff
mov	x10, #9218868437227405311
cmp	x8, x10
cset	w8, gt
cmp	x9, x10
b.gt	LFQH_LBB164_28
tbnz	w8, #0, LFQH_LBB164_28
LFQH_Lloh3726:
adr x1, LFQH_BottomPanVertical178Key
LFQH_Lloh3727:
nop
mov	x0, x20
bl Lpatch + (0xa628 - PATCH_BASE)
cbnz	x0, LFQH_LBB164_22
fabs	d0, d8
fmov	d1, #24.00000000
fcmp	d0, d1
b.mi	LFQH_LBB164_28
fabs	d1, d9
LFQH_Lloh3728:
adr x8, LFQH_lCPI164_0
LFQH_Lloh3729:
ldr d2, [x8]
and x8, x8, #0xfffffffffffff000
fmul	d0, d0, d2
fcmp	d1, d0
b.gt	LFQH_LBB164_28
mov	w0, #1
bl	LFQH_BoolBox
mov	x2, x0
LFQH_Lloh3730:
adr x1, LFQH_BottomPanVertical178Key
LFQH_Lloh3731:
nop
mov	x0, x20
mov	w3, #1
bl Lpatch + (0xa634 - PATCH_BASE)
LFQH_LBB164_22:
LFQH_Lloh3732:
adr x1, LFQH_BottomPanY178Key
LFQH_Lloh3733:
nop
mov	x0, x20
bl Lpatch + (0xa628 - PATCH_BASE)
mov	x21, x0
LFQH_Lloh3734:
adr x0, LFQH_l_.str.445
LFQH_Lloh3735:
nop
bl Lpatch + (0xa5a4 - PATCH_BASE)
mov	x1, x0
mov	x0, x21
bl Lpatch + (0xa5d4 - PATCH_BASE)
fmov	d9, d0
fsub	d0, d8, d0
fmov	d1, #-24.00000000
fcmp	d0, d1
b.ls	LFQH_LBB164_37
mov	x8, #4629700416936869888
fmov	d1, x8
fcmp	d0, d1
b.lt	LFQH_LBB164_39
mov	w1, #0
b	LFQH_LBB164_38
LFQH_LBB164_25:
LFQH_Lloh3736:
adr x1, LFQH_BottomPanActive178Key
LFQH_Lloh3737:
nop
mov	x0, x20
mov	x2, #0
LFQH_LBB164_26:
mov	w3, #1
bl Lpatch + (0xa634 - PATCH_BASE)
LFQH_LBB164_27:
LFQH_Lloh3738:
adr x1, LFQH_BottomCompact178Key
LFQH_Lloh3739:
nop
mov	x0, x19
bl Lpatch + (0xa628 - PATCH_BASE)
LFQH_Lloh3740:
adr x1, LFQH_l_.str.41
LFQH_Lloh3741:
nop
bl	LFQH_BoolProp
cmp	w23, w0
b.ne	LFQH_LBB164_29
LFQH_LBB164_28:
ldp	x29, x30, [sp, #112]
ldp	x20, x19, [sp, #96]
ldp	x22, x21, [sp, #80]
ldp	x24, x23, [sp, #64]
ldp	x26, x25, [sp, #48]
ldp	x28, x27, [sp, #32]
ldp	d9, d8, [sp, #16]
ldp	d11, d10, [sp], #128
ret
LFQH_LBB164_29:
LFQH_Lloh3742:
adr x0, LFQH_l_.str.356
LFQH_Lloh3743:
nop
bl Lpatch + (0xa5a4 - PATCH_BASE)
mov	x1, x0
mov	x0, x19
bl Lpatch + (0xa5d4 - PATCH_BASE)
LFQH_Lloh3744:
adr x0, LFQH_l_.str.357
LFQH_Lloh3745:
nop
bl Lpatch + (0xa5a4 - PATCH_BASE)
mov	x1, x0
mov	x0, x19
ldp	x29, x30, [sp, #112]
ldp	x20, x19, [sp, #96]
ldp	x22, x21, [sp, #80]
ldp	x24, x23, [sp, #64]
ldp	x26, x25, [sp, #48]
ldp	x28, x27, [sp, #32]
ldp	d9, d8, [sp, #16]
ldp	d11, d10, [sp], #128
b Lpatch + (0xa5d4 - PATCH_BASE)
LFQH_LBB164_30:
mov	x0, x19
mov	x1, x23
bl	LFQH_BottomVisible178
cbz	w0, LFQH_LBB164_6
mov	x0, x22
mov	x1, x23
bl	LFQH_BottomVisible178
cbz	w0, LFQH_LBB164_6
LFQH_Lloh3746:
adr x1, LFQH_l_.str.353
LFQH_Lloh3747:
nop
mov	x0, x25
bl	LFQH_Get
cbz	x22, LFQH_LBB164_6
mov	x24, x0
mov	w27, #0
LFQH_Lloh3748:
adr x25, LFQH_l_.str.20
LFQH_Lloh3749:
nop
mov	x0, x22
LFQH_LBB164_34:
cmp	x0, x24
b.eq	LFQH_LBB164_45
mov	x1, x25
bl	LFQH_Get
mov	w26, #0
cbz	x0, LFQH_LBB164_7
add	w8, w27, #1
cmp	w27, #7
mov	x27, x8
b.lo	LFQH_LBB164_34
b	LFQH_LBB164_7
LFQH_LBB164_37:
mov	w1, #1
LFQH_LBB164_38:
mov	x0, x19
bl	LFQH_BottomSetCompact178
LFQH_LBB164_39:
LFQH_Lloh3750:
adr x1, LFQH_BottomCompact178Key
LFQH_Lloh3751:
nop
mov	x0, x19
bl Lpatch + (0xa628 - PATCH_BASE)
LFQH_Lloh3752:
adr x1, LFQH_l_.str.41
LFQH_Lloh3753:
nop
bl	LFQH_BoolProp
cmp	w23, w0
b.ne	LFQH_LBB164_44
cbz	w23, LFQH_LBB164_42
fcmp	d8, d9
b.mi	LFQH_LBB164_44
LFQH_LBB164_42:
cbnz	w23, LFQH_LBB164_27
fcmp	d8, d9
b.le	LFQH_LBB164_27
LFQH_LBB164_44:
fmov	d0, d8
bl	LFQH_Number
b	LFQH_LBB164_13
LFQH_LBB164_45:
LFQH_Lloh3754:
adr x24, LFQH_l_.str.24
LFQH_Lloh3755:
nop
mov	x0, x24
bl Lpatch + (0xa5a4 - PATCH_BASE)
mov	x1, x0
mov	x0, x22
bl Lpatch + (0xa5d4 - PATCH_BASE)
fmov	d8, d0
fmov	d9, d1
fmov	d10, d2
fmov	d11, d3
LFQH_Lloh3756:
adr x0, LFQH_l_.str.507
LFQH_Lloh3757:
nop
bl Lpatch + (0xa5a4 - PATCH_BASE)
mov	x1, x0
mov	x0, x22
fmov	d0, d8
fmov	d1, d9
fmov	d2, d10
fmov	d3, d11
mov	x2, x23
bl Lpatch + (0xa5d4 - PATCH_BASE)
fmov	d9, d0
fmov	d8, d2
fmov	d10, d3
fmov	x25, d8
fmov	x27, d1
fmov	x28, d9
mov	x0, x24
bl Lpatch + (0xa5a4 - PATCH_BASE)
mov	x1, x0
mov	x0, x23
bl Lpatch + (0xa5d4 - PATCH_BASE)
mov	w26, #0
and	x10, x28, #0x7fffffffffffffff
and	x8, x27, #0x7fffffffffffffff
mov	x11, #9218868437227405311
cmp	x8, x11
cset	w8, gt
and	x9, x25, #0x7fffffffffffffff
cmp	x9, x11
cset	w9, gt
cmp	x10, x11
b.gt	LFQH_LBB164_7
tbnz	w8, #0, LFQH_LBB164_7
tbnz	w9, #0, LFQH_LBB164_7
mov	w26, #0
fmov	x8, d10
and	x8, x8, #0x7fffffffffffffff
mov	x9, #9218868437227405311
cmp	x8, x9
b.gt	LFQH_LBB164_7
fcmp	d8, #0.0
b.le	LFQH_LBB164_7
fcmp	d10, #0.0
b.le	LFQH_LBB164_7
fcmp	d10, d8
b.le	LFQH_LBB164_7
fabd	d0, d9, d0
fmov	d1, #2.00000000
fmov	d3, #-4.00000000
fadd	d2, d2, d3
fcmp	d8, d2
cset	w8, ge
fcmp	d0, d1
csel	w26, wzr, w8, pl
b	LFQH_LBB164_7
.cfi_endproc
.p2align	2
LFQH_BottomBarBox178Key:
.cfi_startproc
ret
.cfi_endproc
.p2align	2
LFQH_BottomPanBox178Key:
.cfi_startproc
ret
.cfi_endproc
.p2align	2
LFQH_BottomFlag178:
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
LFQH_Lloh3758:
adr x0, LFQH_l_.str.467
LFQH_Lloh3759:
nop
bl Lpatch + (0xa5b0 - PATCH_BASE)
mov	x20, x0
LFQH_Lloh3760:
adr x0, LFQH_l_.str.468
LFQH_Lloh3761:
nop
bl Lpatch + (0xa5a4 - PATCH_BASE)
mov	x1, x0
mov	x0, x20
bl Lpatch + (0xa5d4 - PATCH_BASE)
mov	x20, x0
LFQH_Lloh3762:
adr x0, LFQH_l_.str.536
LFQH_Lloh3763:
nop
bl Lpatch + (0xa5a4 - PATCH_BASE)
mov	x21, x0
mov	x0, x19
bl	LFQH_BottomPreference178
mov	x2, x0
mov	x0, x20
mov	x1, x21
bl Lpatch + (0xa5d4 - PATCH_BASE)
cbz	x0, LFQH_LBB167_3
mov	x19, x0
LFQH_Lloh3764:
adr x0, LFQH_l_.str.388
LFQH_Lloh3765:
nop
bl Lpatch + (0xa5a4 - PATCH_BASE)
mov	x20, x0
LFQH_Lloh3766:
adr x0, LFQH_l_.str.41
LFQH_Lloh3767:
nop
bl Lpatch + (0xa5a4 - PATCH_BASE)
mov	x2, x0
mov	x0, x19
mov	x1, x20
bl Lpatch + (0xa5d4 - PATCH_BASE)
cbz	w0, LFQH_LBB167_3
LFQH_Lloh3768:
adr x0, LFQH_l_.str.41
LFQH_Lloh3769:
nop
bl Lpatch + (0xa5a4 - PATCH_BASE)
mov	x1, x0
mov	x0, x19
bl Lpatch + (0xa5d4 - PATCH_BASE)
cmp	w0, #0
cset	w0, ne
LFQH_LBB167_3:
ldp	x29, x30, [sp, #32]
ldp	x20, x19, [sp, #16]
ldp	x22, x21, [sp], #48
ret
.cfi_endproc
.p2align	2
LFQH_BottomIsDrama178:
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
LFQH_Lloh3770:
adr x1, LFQH_l_.str.121
LFQH_Lloh3771:
nop
bl	LFQH_Kind
cbz	w0, LFQH_LBB168_10
LFQH_Lloh3772:
adr x1, LFQH_l_.str.561
LFQH_Lloh3773:
nop
mov	x0, x19
bl	LFQH_Get
mov	x20, x0
LFQH_Lloh3774:
adr x1, LFQH_l_.str.124
LFQH_Lloh3775:
nop
mov	x0, x19
bl	LFQH_Get
mov	x21, x0
LFQH_Lloh3776:
adr x0, LFQH_l_.str.34
LFQH_Lloh3777:
nop
bl Lpatch + (0xa5a4 - PATCH_BASE)
mov	x1, x0
mov	x0, x20
bl Lpatch + (0xa5d4 - PATCH_BASE)
sub	x8, x0, #1
cmp	x8, #7
ccmp	x21, #0, #4, ls
b.eq	LFQH_LBB168_9
mov	x22, x0
LFQH_Lloh3778:
adr x1, LFQH_l_.str.879
LFQH_Lloh3779:
nop
mov	x0, x19
bl	LFQH_Responds
cbz	w0, LFQH_LBB168_5
LFQH_Lloh3780:
adr x0, LFQH_l_.str.879
LFQH_Lloh3781:
nop
bl Lpatch + (0xa5a4 - PATCH_BASE)
mov	x1, x0
mov	x0, x19
bl Lpatch + (0xa5d4 - PATCH_BASE)
mov	x23, x0
cmp	x0, x22
b.hs	LFQH_LBB168_5
LFQH_LBB168_4:
LFQH_Lloh3782:
adr x0, LFQH_l_.str.461
LFQH_Lloh3783:
nop
bl Lpatch + (0xa5a4 - PATCH_BASE)
mov	x1, x0
mov	x0, x20
mov	x2, x23
bl Lpatch + (0xa5d4 - PATCH_BASE)
mov	x1, x0
mov	x0, x19
bl	LFQH_TabOption
cmp	x0, #2
cset	w0, eq
b	LFQH_LBB168_10
LFQH_LBB168_5:
LFQH_Lloh3784:
adr x1, LFQH_l_.str.880
LFQH_Lloh3785:
nop
mov	x0, x19
bl	LFQH_Get
mov	x24, x0
LFQH_Lloh3786:
adr x0, LFQH_l_.str.34
LFQH_Lloh3787:
nop
bl Lpatch + (0xa5a4 - PATCH_BASE)
mov	x1, x0
mov	x0, x24
bl Lpatch + (0xa5d4 - PATCH_BASE)
cmp	x0, x22
b.ne	LFQH_LBB168_9
mov	x23, #0
LFQH_Lloh3788:
adr x25, LFQH_l_.str.461
LFQH_Lloh3789:
nop
LFQH_LBB168_7:
mov	x0, x25
bl Lpatch + (0xa5a4 - PATCH_BASE)
mov	x1, x0
mov	x0, x24
mov	x2, x23
bl Lpatch + (0xa5d4 - PATCH_BASE)
cmp	x0, x21
b.eq	LFQH_LBB168_4
add	x23, x23, #1
cmp	x22, x23
b.ne	LFQH_LBB168_7
LFQH_LBB168_9:
mov	w0, #0
LFQH_LBB168_10:
ldp	x29, x30, [sp, #64]
ldp	x20, x19, [sp, #48]
ldp	x22, x21, [sp, #32]
ldp	x24, x23, [sp, #16]
ldp	x26, x25, [sp], #80
ret
.cfi_endproc
.p2align	2
LFQH_BottomVisible178:
.cfi_startproc
stp	d9, d8, [sp, #-96]!
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
.cfi_offset b8, -88
.cfi_offset b9, -96
mov	x20, x0
mov	w0, #0
cbz	x20, LFQH_LBB169_4
mov	x19, x1
cbz	x1, LFQH_LBB169_4
LFQH_Lloh3790:
adr x1, LFQH_l_.str.74
LFQH_Lloh3791:
nop
mov	x0, x20
bl	LFQH_Get
cmp	x0, x19
b.eq	LFQH_LBB169_5
LFQH_LBB169_3:
mov	w0, #0
LFQH_LBB169_4:
ldp	x29, x30, [sp, #80]
ldp	x20, x19, [sp, #64]
ldp	x22, x21, [sp, #48]
ldp	x24, x23, [sp, #32]
ldp	x26, x25, [sp, #16]
ldp	d9, d8, [sp], #96
ret
LFQH_LBB169_5:
mov	w24, #0
LFQH_Lloh3792:
adr x21, LFQH_l_.str.71
LFQH_Lloh3793:
nop
LFQH_Lloh3794:
adr x22, LFQH_l_.str.477
LFQH_Lloh3795:
nop
mov	x25, #9218868437227405311
LFQH_Lloh3796:
adr x8, LFQH_lCPI169_0
LFQH_Lloh3797:
ldr d8, [x8]
and x8, x8, #0xfffffffffffff000
LFQH_Lloh3798:
adr x23, LFQH_l_.str.20
LFQH_Lloh3799:
nop
LFQH_LBB169_6:
mov	x0, x21
bl Lpatch + (0xa5a4 - PATCH_BASE)
mov	x1, x0
mov	x0, x20
bl Lpatch + (0xa5d4 - PATCH_BASE)
cbnz	w0, LFQH_LBB169_3
mov	x0, x22
bl Lpatch + (0xa5a4 - PATCH_BASE)
mov	x1, x0
mov	x0, x20
bl Lpatch + (0xa5d4 - PATCH_BASE)
mov	w0, #0
fmov	x8, d0
and	x8, x8, #0x7fffffffffffffff
cmp	x8, x25
b.gt	LFQH_LBB169_4
fcmp	d0, d8
b.mi	LFQH_LBB169_4
cmp	x20, x19
b.eq	LFQH_LBB169_12
mov	x0, x20
mov	x1, x23
bl	LFQH_Get
mov	x20, x0
mov	w0, #0
cbz	x20, LFQH_LBB169_4
add	w8, w24, #1
cmp	w24, #23
mov	x24, x8
b.lo	LFQH_LBB169_6
b	LFQH_LBB169_4
LFQH_LBB169_12:
mov	w0, #1
b	LFQH_LBB169_4
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
cbz	w0, LFQH_LBB170_2
mov	x0, x20
bl Lpatch + (0xa5a4 - PATCH_BASE)
mov	x1, x0
mov	x0, x19
ldp	x29, x30, [sp, #16]
ldp	x20, x19, [sp], #32
b Lpatch + (0xa5d4 - PATCH_BASE)
LFQH_LBB170_2:
ldp	x29, x30, [sp, #16]
ldp	x20, x19, [sp], #32
ret
.cfi_endproc
.p2align	2
LFQH_BottomCompact178Key:
.cfi_startproc
ret
.cfi_endproc
.p2align	2
LFQH_BottomPanActive178Key:
.cfi_startproc
ret
.cfi_endproc
.p2align	2
LFQH_BottomSetCompact178:
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
LFQH_Lloh3800:
adr x1, LFQH_BottomCompact178Key
LFQH_Lloh3801:
nop
bl Lpatch + (0xa628 - PATCH_BASE)
LFQH_Lloh3802:
adr x1, LFQH_l_.str.41
LFQH_Lloh3803:
nop
bl	LFQH_BoolProp
cmp	w0, w19
b.ne	LFQH_LBB173_2
ldp	x29, x30, [sp, #48]
ldp	x20, x19, [sp, #32]
ldp	x22, x21, [sp, #16]
ldp	x24, x23, [sp], #64
ret
LFQH_LBB173_2:
cbz	w19, LFQH_LBB173_4
LFQH_Lloh3804:
adr x0, LFQH_l_.str.497
LFQH_Lloh3805:
nop
bl Lpatch + (0xa5b0 - PATCH_BASE)
mov	x21, x0
LFQH_Lloh3806:
adr x0, LFQH_l_.str.499
LFQH_Lloh3807:
nop
bl Lpatch + (0xa5a4 - PATCH_BASE)
mov	x1, x0
mov	x0, x21
mov	w2, #1
bl Lpatch + (0xa5d4 - PATCH_BASE)
mov	x2, x0
b	LFQH_LBB173_5
LFQH_LBB173_4:
mov	x2, #0
LFQH_LBB173_5:
LFQH_Lloh3808:
adr x1, LFQH_BottomCompact178Key
LFQH_Lloh3809:
nop
mov	x0, x20
mov	w3, #1
bl Lpatch + (0xa634 - PATCH_BASE)
LFQH_Lloh3810:
adr x0, LFQH_l_.str.88
LFQH_Lloh3811:
nop
bl Lpatch + (0xa5b0 - PATCH_BASE)
mov	x20, x0
LFQH_Lloh3812:
adr x0, LFQH_l_.str.89
LFQH_Lloh3813:
nop
bl Lpatch + (0xa5a4 - PATCH_BASE)
mov	x1, x0
mov	x0, x20
bl Lpatch + (0xa5d4 - PATCH_BASE)
mov	x20, x0
LFQH_Lloh3814:
adr x21, LFQH_l_.str.497
LFQH_Lloh3815:
nop
mov	x0, x21
bl Lpatch + (0xa5b0 - PATCH_BASE)
mov	x22, x0
LFQH_Lloh3816:
adr x23, LFQH_l_.str.499
LFQH_Lloh3817:
nop
mov	x0, x23
bl Lpatch + (0xa5a4 - PATCH_BASE)
mov	x1, x0
mov	x0, x22
mov	x2, x19
bl Lpatch + (0xa5d4 - PATCH_BASE)
mov	x2, x0
LFQH_Lloh3818:
adr x1, LFQH_l_.str.371
LFQH_Lloh3819:
nop
mov	x0, x20
bl	LFQH_Put
mov	x0, x21
bl Lpatch + (0xa5b0 - PATCH_BASE)
mov	x19, x0
mov	x0, x23
bl Lpatch + (0xa5a4 - PATCH_BASE)
mov	x1, x0
mov	x0, x19
mov	w2, #0
bl Lpatch + (0xa5d4 - PATCH_BASE)
mov	x2, x0
LFQH_Lloh3820:
adr x1, LFQH_l_.str.881
LFQH_Lloh3821:
nop
mov	x0, x20
bl	LFQH_Put
LFQH_Lloh3822:
adr x0, LFQH_l_.str.882
LFQH_Lloh3823:
nop
mov	x1, x20
ldp	x29, x30, [sp, #48]
ldp	x20, x19, [sp, #32]
ldp	x22, x21, [sp, #16]
ldp	x24, x23, [sp], #64
b Lrecord_named
.cfi_endproc
.p2align	2
LFQH_BottomPanVertical178Key:
.cfi_startproc
ret
.cfi_endproc
.p2align	2
LFQH_BottomPanY178Key:
.cfi_startproc
ret
.cfi_endproc
.p2align	2
LFQH_FQHBottomNativeRect178:
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
fmov	d8, d3
fmov	d10, d2
fmov	d9, d1
fmov	d11, d0
mov	x19, x0
bl	LFQH_Enabled
cbz	w0, LFQH_LBB176_2
mov	w0, #13
bl	LFQH_BottomValue178
mov	x8, #4636737291354636288
fmov	d1, x8
fcmp	d0, d1
b.ne	LFQH_LBB176_3
LFQH_LBB176_2:
fmov	d0, d11
fmov	d1, d9
fmov	d2, d10
fmov	d3, d8
ldp	x29, x30, [sp, #48]
ldp	x20, x19, [sp, #32]
ldp	d9, d8, [sp, #16]
ldp	d11, d10, [sp], #64
ret
LFQH_LBB176_3:
fmov	x8, d11
and	x10, x8, #0x7fffffffffffffff
fmov	x8, d9
and	x8, x8, #0x7fffffffffffffff
mov	x11, #9218868437227405311
cmp	x8, x11
cset	w8, gt
fmov	x9, d10
and	x9, x9, #0x7fffffffffffffff
cmp	x9, x11
cset	w9, gt
cmp	x10, x11
b.gt	LFQH_LBB176_2
tbnz	w8, #0, LFQH_LBB176_2
tbnz	w9, #0, LFQH_LBB176_2
fmov	x8, d8
and	x8, x8, #0x7fffffffffffffff
mov	x9, #9218868437227405311
cmp	x8, x9
b.gt	LFQH_LBB176_2
fcmp	d10, #0.0
b.le	LFQH_LBB176_2
fcmp	d8, #0.0
b.le	LFQH_LBB176_2
LFQH_Lloh3824:
adr x1, LFQH_BottomButtons178Key
LFQH_Lloh3825:
nop
mov	x0, x19
bl Lpatch + (0xa628 - PATCH_BASE)
mov	x19, x0
LFQH_Lloh3826:
adr x0, LFQH_l_.str.34
LFQH_Lloh3827:
nop
bl Lpatch + (0xa5a4 - PATCH_BASE)
mov	x1, x0
mov	x0, x19
bl Lpatch + (0xa5d4 - PATCH_BASE)
sub	x8, x0, #9
cmn	x8, #8
b.lo	LFQH_LBB176_2
mov	x19, x0
mov	w0, #1
bl	LFQH_BottomFlag178
mov	x1, x0
fmov	d0, d11
fmov	d1, d9
fmov	d2, d10
fmov	d3, d8
mov	x0, x19
bl	LFQH_BottomTrack178
fmov	d1, #-4.00000000
fadd	d11, d0, d1
fmov	d0, #8.00000000
fadd	d10, d2, d0
b	LFQH_LBB176_2
.cfi_endproc
.p2align	2
LFQH_BottomValue178:
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
cmp	x0, #14
mov	x8, #4636737291354636288
fmov	d0, x8
fmov	d1, #20.00000000
fcsel	d8, d1, d0, eq
LFQH_Lloh3828:
adr x0, LFQH_l_.str.467
LFQH_Lloh3829:
nop
bl Lpatch + (0xa5b0 - PATCH_BASE)
mov	x20, x0
LFQH_Lloh3830:
adr x0, LFQH_l_.str.468
LFQH_Lloh3831:
nop
bl Lpatch + (0xa5a4 - PATCH_BASE)
mov	x1, x0
mov	x0, x20
bl Lpatch + (0xa5d4 - PATCH_BASE)
mov	x20, x0
LFQH_Lloh3832:
adr x0, LFQH_l_.str.536
LFQH_Lloh3833:
nop
bl Lpatch + (0xa5a4 - PATCH_BASE)
mov	x21, x0
mov	x0, x19
bl	LFQH_BottomPreference178
mov	x2, x0
mov	x0, x20
mov	x1, x21
bl Lpatch + (0xa5d4 - PATCH_BASE)
mov	x20, x0
LFQH_Lloh3834:
adr x1, LFQH_l_.str.445
LFQH_Lloh3835:
nop
bl	LFQH_Responds
cbz	w0, LFQH_LBB177_9
LFQH_Lloh3836:
adr x0, LFQH_l_.str.445
LFQH_Lloh3837:
nop
bl Lpatch + (0xa5a4 - PATCH_BASE)
mov	x1, x0
mov	x0, x20
bl Lpatch + (0xa5d4 - PATCH_BASE)
fmov	x8, d0
and	x8, x8, #0x7fffffffffffffff
mov	x9, #9218868437227405311
cmp	x8, x9
b.gt	LFQH_LBB177_9
cmp	x19, #11
b.eq	LFQH_LBB177_5
cmp	x19, #12
b.ne	LFQH_LBB177_7
mov	x8, #4635329916471083008
b	LFQH_LBB177_6
LFQH_LBB177_5:
mov	x8, #4632233691727265792
LFQH_LBB177_6:
fmov	d1, x8
b	LFQH_LBB177_8
LFQH_LBB177_7:
cmp	x19, #13
LFQH_Lloh3838:
adr x8, LFQH_lCPI177_0
LFQH_Lloh3839:
ldr d1, [x8]
and x8, x8, #0xfffffffffffff000
fmov	d2, #16.00000000
fcsel	d1, d1, d2, eq
LFQH_LBB177_8:
cmp	x19, #14
mov	x8, #4636737291354636288
fmov	d2, x8
fmov	d3, #26.00000000
fcsel	d2, d3, d2, eq
cmp	x19, #12
LFQH_Lloh3840:
adr x8, LFQH_lCPI177_1
LFQH_Lloh3841:
ldr d3, [x8]
and x8, x8, #0xfffffffffffff000
fcsel	d2, d3, d2, eq
fcmp	d0, d2
fcsel	d2, d2, d0, gt
fcmp	d0, d1
fcsel	d8, d1, d2, mi
LFQH_LBB177_9:
fmov	d0, d8
ldp	x29, x30, [sp, #48]
ldp	x20, x19, [sp, #32]
ldp	x22, x21, [sp, #16]
ldp	d9, d8, [sp], #64
ret
.cfi_endproc
.p2align	2
LFQH_BottomButtons178Key:
.cfi_startproc
ret
.cfi_endproc
.p2align	2
LFQH_BottomTrack178:
.cfi_startproc
stp	d15, d14, [sp, #-80]!
stp	d13, d12, [sp, #16]
stp	d11, d10, [sp, #32]
stp	d9, d8, [sp, #48]
stp	x29, x30, [sp, #64]
add	x29, sp, #64
.cfi_def_cfa w29, 16
.cfi_offset w30, -8
.cfi_offset w29, -16
.cfi_offset b8, -24
.cfi_offset b9, -32
.cfi_offset b10, -40
.cfi_offset b11, -48
.cfi_offset b12, -56
.cfi_offset b13, -64
.cfi_offset b14, -72
.cfi_offset b15, -80
fmov	d8, d3
fmov	d9, d2
fmov	d10, d1
fmov	d11, d0
cmp	w1, #0
mov	x8, #4631389266797133824
fmov	d12, x8
mov	x8, #4632515166703976448
fmov	d0, x8
fcsel	d0, d0, d12, eq
fmov	d13, #-8.00000000
fadd	d1, d2, d13
fmov	d2, xzr
fmaxnm	d14, d1, d2
ucvtf	d1, x0
fmul	d15, d0, d1
mov	w0, #13
bl	LFQH_BottomValue178
fmul	d0, d14, d0
LFQH_Lloh3842:
adr x8, LFQH_lCPI179_0
LFQH_Lloh3843:
ldr d1, [x8]
and x8, x8, #0xfffffffffffff000
fmul	d0, d0, d1
fmaxnm	d0, d15, d0
fminnm	d2, d14, d0
fadd	d0, d8, d13
fmaxnm	d0, d0, d12
fminnm	d3, d8, d0
fsub	d0, d9, d2
fmov	d1, #0.50000000
fmul	d0, d0, d1
fadd	d0, d11, d0
fsub	d4, d8, d3
fmul	d1, d4, d1
fadd	d1, d10, d1
ldp	x29, x30, [sp, #64]
ldp	d9, d8, [sp, #48]
ldp	d11, d10, [sp, #32]
ldp	d13, d12, [sp, #16]
ldp	d15, d14, [sp], #80
ret
.cfi_endproc
.p2align	2
LFQH_FQHBottomPrepare:
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
mov	x19, x2
mov	x20, x1
mov	x21, x0
LFQH_Lloh3844:
adr x1, LFQH_l_.str.358
LFQH_Lloh3845:
nop
bl	LFQH_Kind
cbz	w0, LFQH_LBB180_2
LFQH_Lloh3846:
adr x1, LFQH_l_.str.20
LFQH_Lloh3847:
nop
mov	x0, x20
bl	LFQH_Get
cmp	x0, x21
b.eq	LFQH_LBB180_3
LFQH_LBB180_2:
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
LFQH_LBB180_3:
bl	LFQH_Enabled
cbz	w0, LFQH_LBB180_62
LFQH_Lloh3848:
adr x0, LFQH_l_.str.34
LFQH_Lloh3849:
nop
bl Lpatch + (0xa5a4 - PATCH_BASE)
mov	x1, x0
mov	x0, x19
bl Lpatch + (0xa5d4 - PATCH_BASE)
sub	x8, x0, #9
cmn	x8, #8
b.lo	LFQH_LBB180_2
mov	x22, x0
LFQH_Lloh3850:
adr x0, LFQH_l_.str.372
LFQH_Lloh3851:
nop
bl Lpatch + (0xa5a4 - PATCH_BASE)
mov	x1, x0
mov	x0, x20
bl Lpatch + (0xa5d4 - PATCH_BASE)
fmov	x9, d2
fmov	x8, d1
fmov	x10, d0
and	x10, x10, #0x7fffffffffffffff
and	x8, x8, #0x7fffffffffffffff
mov	x11, #9218868437227405311
cmp	x8, x11
cset	w8, gt
and	x9, x9, #0x7fffffffffffffff
cmp	x9, x11
cset	w9, gt
cmp	x10, x11
b.gt	LFQH_LBB180_2
tbnz	w8, #0, LFQH_LBB180_2
tbnz	w9, #0, LFQH_LBB180_2
fmov	x8, d3
and	x8, x8, #0x7fffffffffffffff
mov	x9, #9218868437227405311
cmp	x8, x9
b.gt	LFQH_LBB180_2
fcmp	d2, #0.0
b.le	LFQH_LBB180_2
fcmp	d3, #0.0
b.le	LFQH_LBB180_2
LFQH_Lloh3852:
adr x0, LFQH_l_.str.24
LFQH_Lloh3853:
nop
bl Lpatch + (0xa5a4 - PATCH_BASE)
mov	x1, x0
mov	x0, x21
bl Lpatch + (0xa5d4 - PATCH_BASE)
fmov	x9, d2
fmov	x8, d1
fmov	x10, d0
and	x10, x10, #0x7fffffffffffffff
and	x8, x8, #0x7fffffffffffffff
mov	x11, #9218868437227405311
cmp	x8, x11
cset	w8, gt
and	x9, x9, #0x7fffffffffffffff
cmp	x9, x11
cset	w9, gt
cmp	x10, x11
b.gt	LFQH_LBB180_2
tbnz	w8, #0, LFQH_LBB180_2
tbnz	w9, #0, LFQH_LBB180_2
fmov	x8, d3
and	x8, x8, #0x7fffffffffffffff
mov	x9, #9218868437227405311
cmp	x8, x9
b.gt	LFQH_LBB180_2
fcmp	d2, #0.0
b.le	LFQH_LBB180_2
fcmp	d3, #0.0
b.le	LFQH_LBB180_2
LFQH_Lloh3854:
adr x1, LFQH_BottomButtons178Key
LFQH_Lloh3855:
nop
mov	x0, x20
bl Lpatch + (0xa628 - PATCH_BASE)
mov	x23, x0
LFQH_Lloh3856:
adr x0, LFQH_l_.str.34
LFQH_Lloh3857:
nop
bl Lpatch + (0xa5a4 - PATCH_BASE)
mov	x1, x0
str	x23, [sp, #80]
mov	x0, x23
bl Lpatch + (0xa5d4 - PATCH_BASE)
cmp	x0, #8
mov	w8, #8
csel	x28, x0, x8, lo
cbz	x0, LFQH_LBB180_24
mov	x24, #0
LFQH_Lloh3858:
adr x25, LFQH_l_.str.461
LFQH_Lloh3859:
nop
LFQH_LBB180_19:
mov	x0, x25
bl Lpatch + (0xa5a4 - PATCH_BASE)
mov	x1, x0
ldr	x0, [sp, #80]
mov	x2, x24
bl Lpatch + (0xa5d4 - PATCH_BASE)
mov	x26, x0
mov	w23, #0
mov	x27, #0
LFQH_LBB180_20:
mov	x0, x25
bl Lpatch + (0xa5a4 - PATCH_BASE)
mov	x1, x0
mov	x0, x19
mov	x2, x27
bl Lpatch + (0xa5d4 - PATCH_BASE)
cmp	x0, x26
csinc	w23, w23, wzr, ne
add	x27, x27, #1
cmp	x22, x27
b.ne	LFQH_LBB180_20
cbnz	w23, LFQH_LBB180_23
mov	x0, x26
bl	LFQH_BottomRestoreSymbol178
LFQH_LBB180_23:
add	x24, x24, #1
cmp	x24, x28
b.ne	LFQH_LBB180_19
LFQH_LBB180_24:
LFQH_Lloh3860:
adr x1, LFQH_l_.str.359
LFQH_Lloh3861:
nop
mov	x0, x21
bl	LFQH_Get
mov	x23, x0
LFQH_Lloh3862:
adr x0, LFQH_l_.str.34
LFQH_Lloh3863:
nop
bl Lpatch + (0xa5a4 - PATCH_BASE)
mov	x1, x0
str	x23, [sp, #80]
mov	x0, x23
bl Lpatch + (0xa5d4 - PATCH_BASE)
cbz	x22, LFQH_LBB180_34
mov	x24, x0
mov	x25, #0
LFQH_Lloh3864:
adr x26, LFQH_l_.str.461
LFQH_Lloh3865:
nop
LFQH_Lloh3866:
adr x28, LFQH_l_.str.361
LFQH_Lloh3867:
nop
LFQH_LBB180_26:
mov	x0, x26
bl Lpatch + (0xa5a4 - PATCH_BASE)
mov	x1, x0
mov	x0, x19
mov	x2, x25
bl Lpatch + (0xa5d4 - PATCH_BASE)
mov	x27, x0
cmp	x24, x22
b.ne	LFQH_LBB180_28
mov	x0, x26
bl Lpatch + (0xa5a4 - PATCH_BASE)
mov	x1, x0
ldr	x0, [sp, #80]
mov	x2, x25
bl Lpatch + (0xa5d4 - PATCH_BASE)
LFQH_Lloh3868:
adr x1, LFQH_l_.str.360
LFQH_Lloh3869:
nop
bl	LFQH_Get
mov	x23, x0
b	LFQH_LBB180_29
LFQH_LBB180_28:
mov	x23, #0
LFQH_LBB180_29:
mov	x0, x23
mov	x1, x28
bl	LFQH_Kind
cbz	w0, LFQH_LBB180_31
LFQH_Lloh3870:
adr x0, LFQH_l_.str.362
LFQH_Lloh3871:
nop
bl Lpatch + (0xa5a4 - PATCH_BASE)
mov	x1, x0
mov	x0, x23
bl Lpatch + (0xa5d4 - PATCH_BASE)
cbnz	x0, LFQH_LBB180_33
LFQH_LBB180_31:
mov	x0, x27
mov	x1, x20
mov	x2, x21
bl	LFQH_BottomOwnsButton178
cbz	w0, LFQH_LBB180_33
mov	x0, x27
bl	LFQH_BottomRestoreTitles178R2
LFQH_LBB180_33:
add	x25, x25, #1
cmp	x22, x25
b.ne	LFQH_LBB180_26
LFQH_LBB180_34:
LFQH_Lloh3872:
adr x1, LFQH_BottomBarBox178Key
LFQH_Lloh3873:
nop
mov	x0, x20
mov	x2, x21
bl	LFQH_BottomSetWeak178
LFQH_Lloh3874:
adr x1, LFQH_BottomProxyBox178Key
LFQH_Lloh3875:
nop
mov	x0, x21
mov	x2, x20
bl	LFQH_BottomSetWeak178
LFQH_Lloh3876:
adr x1, LFQH_BottomButtons178Key
LFQH_Lloh3877:
nop
mov	x0, x20
mov	x2, x19
mov	w3, #1
bl Lpatch + (0xa634 - PATCH_BASE)
bl	LFQH_BottomBars178
mov	x23, x0
LFQH_Lloh3878:
adr x0, LFQH_l_.str.84
LFQH_Lloh3879:
nop
bl Lpatch + (0xa5a4 - PATCH_BASE)
mov	x1, x0
mov	x0, x23
mov	x2, x21
bl Lpatch + (0xa5d4 - PATCH_BASE)
LFQH_Lloh3880:
adr x1, LFQH_l_.str.120
LFQH_Lloh3881:
nop
mov	x0, x21
bl	LFQH_Get
mov	x25, x0
LFQH_Lloh3882:
adr x1, LFQH_l_.str.74
LFQH_Lloh3883:
nop
mov	x0, x21
bl	LFQH_Get
mov	x23, x0
LFQH_Lloh3884:
adr x1, LFQH_l_.str.124
LFQH_Lloh3885:
nop
mov	x0, x25
bl	LFQH_Get
mov	x24, x0
LFQH_Lloh3886:
adr x1, LFQH_BottomSelectedBox178Key
LFQH_Lloh3887:
nop
mov	x0, x21
bl Lpatch + (0xa628 - PATCH_BASE)
LFQH_Lloh3888:
adr x1, LFQH_l_.str.81
LFQH_Lloh3889:
nop
bl	LFQH_Get
cmp	x0, x24
b.eq	LFQH_LBB180_36
mov	x0, x21
bl	LFQH_BottomDetachPan178
LFQH_Lloh3890:
adr x1, LFQH_BottomSelectedBox178Key
LFQH_Lloh3891:
nop
mov	x0, x21
mov	x2, x24
bl	LFQH_BottomSetWeak178
LFQH_LBB180_36:
bl	LFQH_Enabled
cbz	w0, LFQH_LBB180_40
mov	w0, #2
bl	LFQH_BottomFlag178
cbz	w0, LFQH_LBB180_40
mov	x0, x25
bl	LFQH_BottomIsDrama178
cbz	w0, LFQH_LBB180_40
LFQH_Lloh3892:
adr x1, LFQH_l_.str.352
LFQH_Lloh3893:
nop
mov	x0, x25
bl	LFQH_Get
cbz	x0, LFQH_LBB180_90
LFQH_LBB180_40:
mov	x0, x21
bl	LFQH_BottomDetachPan178
LFQH_LBB180_41:
mov	w0, #1
bl	LFQH_BottomFlag178
mov	x23, x0
LFQH_Lloh3894:
adr x1, LFQH_BottomCompact178Key
LFQH_Lloh3895:
nop
mov	x0, x21
bl Lpatch + (0xa628 - PATCH_BASE)
LFQH_Lloh3896:
adr x1, LFQH_l_.str.41
LFQH_Lloh3897:
nop
bl	LFQH_BoolProp
mov	x24, x0
mov	w0, #11
bl	LFQH_BottomValue178
fmov	d11, d0
mov	w0, #12
bl	LFQH_BottomValue178
fmov	d10, d0
mov	w0, #13
bl	LFQH_BottomValue178
fmov	d12, d0
LFQH_Lloh3898:
adr x1, LFQH_BottomBaseFrame178Key
LFQH_Lloh3899:
nop
mov	x0, x20
bl Lpatch + (0xa628 - PATCH_BASE)
mov	x26, x0
LFQH_Lloh3900:
adr x1, LFQH_BottomAppliedFrame178Key
LFQH_Lloh3901:
nop
mov	x0, x20
bl Lpatch + (0xa628 - PATCH_BASE)
mov	x25, x0
LFQH_Lloh3902:
adr x0, LFQH_l_.str.372
LFQH_Lloh3903:
nop
bl Lpatch + (0xa5a4 - PATCH_BASE)
mov	x1, x0
mov	x0, x20
bl Lpatch + (0xa5d4 - PATCH_BASE)
stp	q2, q1, [sp, #64]
fmov	d8, d1
fmov	d14, d2
stp	q0, q3, [sp, #32]
fmov	d9, d3
cbz	x26, LFQH_LBB180_43
LFQH_Lloh3904:
adr x0, LFQH_l_.str.432
LFQH_Lloh3905:
nop
bl Lpatch + (0xa5a4 - PATCH_BASE)
mov	x1, x0
mov	x0, x26
bl Lpatch + (0xa5d4 - PATCH_BASE)
fmov	d8, d1
fmov	d14, d2
fmov	d9, d3
LFQH_LBB180_43:
cbz	x25, LFQH_LBB180_48
LFQH_Lloh3906:
adr x0, LFQH_l_.str.432
LFQH_Lloh3907:
nop
bl Lpatch + (0xa5a4 - PATCH_BASE)
mov	x1, x0
mov	x0, x25
bl Lpatch + (0xa5d4 - PATCH_BASE)
ldr	q4, [sp, #32]
fcmp	d4, d0
b.ne	LFQH_LBB180_48
ldr	q0, [sp, #80]
fcmp	d0, d1
b.ne	LFQH_LBB180_48
ldr	q0, [sp, #64]
fcmp	d0, d2
b.ne	LFQH_LBB180_48
ldr	q0, [sp, #48]
fcmp	d0, d3
b.eq	LFQH_LBB180_49
LFQH_LBB180_48:
ldp	q0, q3, [sp, #32]
ldp	q2, q1, [sp, #64]
bl	LFQH_RectBox
mov	x2, x0
LFQH_Lloh3908:
adr x1, LFQH_BottomBaseFrame178Key
LFQH_Lloh3909:
nop
mov	x0, x20
mov	w3, #1
bl Lpatch + (0xa634 - PATCH_BASE)
ldr	q0, [sp, #80]
fmov	d8, d0
ldr	q0, [sp, #64]
fmov	d14, d0
ldr	q0, [sp, #48]
fmov	d9, d0
LFQH_LBB180_49:
mov	x8, #4636737291354636288
fmov	d0, x8
fcmp	d11, d0
b.ne	LFQH_LBB180_63
fmov	d0, x8
fcmp	d10, d0
b.ne	LFQH_LBB180_63
fmov	d0, x8
fcmp	d12, d0
b.ne	LFQH_LBB180_63
cbnz	w24, LFQH_LBB180_63
LFQH_Lloh3910:
adr x1, LFQH_BottomBaseFrame178Key
LFQH_Lloh3911:
nop
LFQH_Lloh3912:
adr x2, LFQH_BottomAppliedFrame178Key
LFQH_Lloh3913:
nop
mov	x0, x20
bl	LFQH_BottomRestoreFrame178
LFQH_Lloh3914:
adr x1, LFQH_l_.str.363
LFQH_Lloh3915:
nop
mov	x0, x20
bl	LFQH_Get
cbz	x0, LFQH_LBB180_59
mov	x21, x0
LFQH_Lloh3916:
adr x0, LFQH_l_.str.372
LFQH_Lloh3917:
nop
bl Lpatch + (0xa5a4 - PATCH_BASE)
mov	x1, x0
mov	x0, x21
bl Lpatch + (0xa5d4 - PATCH_BASE)
fmov	d11, d0
fmov	d10, d1
fmov	d9, d2
fmov	d8, d3
LFQH_Lloh3918:
adr x0, LFQH_l_.str.24
LFQH_Lloh3919:
nop
bl Lpatch + (0xa5a4 - PATCH_BASE)
mov	x1, x0
mov	x0, x20
bl Lpatch + (0xa5d4 - PATCH_BASE)
fcmp	d11, d0
b.ne	LFQH_LBB180_58
fcmp	d10, d1
b.ne	LFQH_LBB180_58
fcmp	d9, d2
b.ne	LFQH_LBB180_58
fcmp	d8, d3
b.eq	LFQH_LBB180_59
LFQH_LBB180_58:
LFQH_Lloh3920:
adr x0, LFQH_l_.str.24
LFQH_Lloh3921:
nop
bl Lpatch + (0xa5a4 - PATCH_BASE)
mov	x1, x0
mov	x0, x20
bl Lpatch + (0xa5d4 - PATCH_BASE)
fmov	d8, d0
fmov	d9, d1
fmov	d10, d2
fmov	d11, d3
LFQH_Lloh3922:
adr x0, LFQH_l_.str.156
LFQH_Lloh3923:
nop
bl Lpatch + (0xa5a4 - PATCH_BASE)
mov	x1, x0
mov	x0, x21
fmov	d0, d8
fmov	d1, d9
fmov	d2, d10
fmov	d3, d11
bl Lpatch + (0xa5d4 - PATCH_BASE)
LFQH_LBB180_59:
cbz	x22, LFQH_LBB180_2
mov	x20, #0
LFQH_Lloh3924:
adr x21, LFQH_l_.str.461
LFQH_Lloh3925:
nop
LFQH_Lloh3926:
adr x23, LFQH_BottomButtonStock178Key
LFQH_Lloh3927:
nop
LFQH_Lloh3928:
adr x24, LFQH_BottomButtonApplied178Key
LFQH_Lloh3929:
nop
LFQH_LBB180_61:
mov	x0, x21
bl Lpatch + (0xa5a4 - PATCH_BASE)
mov	x1, x0
mov	x0, x19
mov	x2, x20
bl Lpatch + (0xa5d4 - PATCH_BASE)
mov	x1, x23
mov	x2, x24
bl	LFQH_BottomRestoreFrame178
add	x20, x20, #1
cmp	x22, x20
b.ne	LFQH_LBB180_61
b	LFQH_LBB180_2
LFQH_LBB180_62:
mov	x0, x21
mov	x1, x20
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
b	LFQH_FQHBottomReset178
LFQH_LBB180_63:
LFQH_Lloh3930:
adr x0, LFQH_l_.str.24
LFQH_Lloh3931:
nop
bl Lpatch + (0xa5a4 - PATCH_BASE)
mov	x1, x0
mov	x0, x21
bl Lpatch + (0xa5d4 - PATCH_BASE)
fmov	d12, d1
fmov	d15, d2
fmov	d13, d3
fmov	d1, #-8.00000000
fadd	d1, d2, d1
fminnm	d6, d14, d1
cmp	w23, #0
mov	w8, #44
mov	w9, #52
csel	x8, x9, x8, eq
mov	x9, #8
madd	x8, x8, x22, x9
ucvtf	d1, x8
fmul	d2, d11, d14
LFQH_Lloh3932:
adr x8, LFQH_lCPI180_0
LFQH_Lloh3933:
ldr d3, [x8]
and x8, x8, #0xfffffffffffff000
fmul	d2, d2, d3
cmp	w24, #0
LFQH_Lloh3934:
adr x8, LFQH_lCPI180_1
LFQH_Lloh3935:
ldr d4, [x8]
and x8, x8, #0xfffffffffffff000
fmov	d5, #1.00000000
fcsel	d4, d5, d4, eq
fmul	d2, d4, d2
fminnm	d1, d1, d6
LFQH_Lloh3936:
adr x8, LFQH_lCPI180_2
LFQH_Lloh3937:
ldr d4, [x8]
and x8, x8, #0xfffffffffffff000
fcsel	d4, d5, d4, eq
fcmp	d2, d6
fcsel	d5, d6, d2, gt
fcmp	d2, d1
fcsel	d5, d1, d5, mi
LFQH_Lloh3938:
adr x8, LFQH_lCPI180_3
LFQH_Lloh3939:
ldr d1, [x8]
and x8, x8, #0xfffffffffffff000
fminnm	d1, d13, d1
fmul	d2, d10, d9
fmul	d2, d2, d3
fmul	d2, d4, d2
mov	x8, #4631952216750555136
fmov	d3, x8
fminnm	d3, d13, d3
fcmp	d2, d1
fcsel	d4, d1, d2, gt
fcmp	d2, d3
fcsel	d3, d3, d4, mi
mov	x8, #4631389266797133824
fmov	d2, x8
fcmp	d1, d2
b.mi	LFQH_LBB180_2
fcmp	d6, #0.0
b.ls	LFQH_LBB180_2
stp	q3, q5, [sp]
fmov	d11, d0
LFQH_Lloh3940:
adr x1, LFQH_l_.str.74
LFQH_Lloh3941:
nop
mov	x0, x21
bl	LFQH_Get
LFQH_Lloh3942:
adr x1, LFQH_l_.str.364
LFQH_Lloh3943:
nop
bl	LFQH_Get
mov	x24, x0
LFQH_Lloh3944:
adr x0, LFQH_l_.str.365
LFQH_Lloh3945:
nop
bl Lpatch + (0xa5a4 - PATCH_BASE)
mov	x1, x0
mov	x0, x24
bl Lpatch + (0xa5d4 - PATCH_BASE)
fmov	d10, #1.00000000
fcmp	d0, d10
b.pl	LFQH_LBB180_67
LFQH_Lloh3946:
adr x1, LFQH_l_.str.129
LFQH_Lloh3947:
nop
mov	x0, x21
bl	LFQH_Get
mov	x24, x0
LFQH_Lloh3948:
adr x0, LFQH_l_.str.366
LFQH_Lloh3949:
nop
bl Lpatch + (0xa5a4 - PATCH_BASE)
mov	x1, x0
mov	x0, x24
bl Lpatch + (0xa5d4 - PATCH_BASE)
LFQH_LBB180_67:
ldp	q5, q4, [sp]
fsub	d1, d15, d4
fmov	d2, #0.50000000
fmul	d1, d1, d2
fadd	d1, d11, d1
fmov	x8, d0
and	x8, x8, #0x7fffffffffffffff
mov	x9, #9218868437227405311
cmp	x8, x9
fccmp	d0, d10, #8, le
fmov	d2, #4.00000000
fccmp	d0, d2, #0, pl
fcsel	d0, d10, d0, gt
fadd	d2, d8, d9
fsub	d2, d2, d5
fadd	d3, d12, d13
fsub	d3, d3, d5
fcmp	d2, d3
fcsel	d3, d3, d2, gt
fcmp	d2, d12
fcsel	d2, d12, d3, mi
mov.d	v1[1], v2[0]
mov.d	v4[1], v5[0]
dup.2d	v2, v0[0]
fmul.2d	v3, v4, v0[0]
fmul.2d	v0, v1, v0[0]
fcmlt.2d	v1, v0, #0.0
fcmlt.2d	v4, v3, #0.0
fmov.2d	v5, #0.50000000
fmov.2d	v6, #-0.50000000
bsl.16b	v4, v6, v5
bsl.16b	v1, v6, v5
fadd.2d	v0, v0, v1
fadd.2d	v1, v3, v4
fcvtzs.2d	v1, v1
fcvtzs.2d	v0, v0
scvtf.2d	v0, v0
scvtf.2d	v1, v1
fdiv.2d	v3, v1, v2
fdiv.2d	v4, v0, v2
mov	d8, v4[1]
mov	d9, v3[1]
ldp	q1, q2, [sp, #32]
ldp	q0, q5, [sp, #64]
mov.d	v1[1], v5[0]
mov.d	v0[1], v2[0]
fcmeq.2d	v0, v0, v3
fcmeq.2d	v1, v1, v4
uzp1.4s	v0, v1, v0
mvn.16b	v0, v0
xtn.4h	v0, v0
umaxv.4h	h0, v0
fmov	w8, s0
tbz	w8, #0, LFQH_LBB180_69
LFQH_Lloh3950:
adr x0, LFQH_l_.str.156
LFQH_Lloh3951:
nop
stp	q4, q3, [sp, #64]
bl Lpatch + (0xa5a4 - PATCH_BASE)
mov	x1, x0
mov	x0, x20
ldp	q0, q2, [sp, #64]
fmov	d1, d8
fmov	d3, d9
bl Lpatch + (0xa5d4 - PATCH_BASE)
ldp	q4, q3, [sp, #64]
LFQH_LBB180_69:
fmov	d0, d4
fmov	d1, d8
fmov	d2, d3
fmov	d3, d9
bl	LFQH_RectBox
mov	x2, x0
LFQH_Lloh3952:
adr x1, LFQH_BottomAppliedFrame178Key
LFQH_Lloh3953:
nop
mov	x0, x20
mov	w3, #1
bl Lpatch + (0xa634 - PATCH_BASE)
LFQH_Lloh3954:
adr x1, LFQH_l_.str.363
LFQH_Lloh3955:
nop
mov	x0, x20
bl	LFQH_Get
mov	x24, x0
LFQH_Lloh3956:
adr x0, LFQH_l_.str.24
LFQH_Lloh3957:
nop
bl Lpatch + (0xa5a4 - PATCH_BASE)
mov	x1, x0
mov	x0, x20
bl Lpatch + (0xa5d4 - PATCH_BASE)
fmov	d8, d0
fmov	d9, d1
fmov	d10, d2
fmov	d11, d3
cbz	x24, LFQH_LBB180_75
LFQH_Lloh3958:
adr x0, LFQH_l_.str.372
LFQH_Lloh3959:
nop
bl Lpatch + (0xa5a4 - PATCH_BASE)
mov	x1, x0
mov	x0, x24
bl Lpatch + (0xa5d4 - PATCH_BASE)
fcmp	d0, d8
b.ne	LFQH_LBB180_74
fcmp	d1, d9
b.ne	LFQH_LBB180_74
fcmp	d2, d10
b.ne	LFQH_LBB180_74
fcmp	d3, d11
b.eq	LFQH_LBB180_75
LFQH_LBB180_74:
LFQH_Lloh3960:
adr x0, LFQH_l_.str.156
LFQH_Lloh3961:
nop
bl Lpatch + (0xa5a4 - PATCH_BASE)
mov	x1, x0
mov	x0, x24
fmov	d0, d8
fmov	d1, d9
fmov	d2, d10
fmov	d3, d11
bl Lpatch + (0xa5d4 - PATCH_BASE)
LFQH_LBB180_75:
fmov	d0, d8
fmov	d1, d9
fmov	d2, d10
fmov	d3, d11
mov	x0, x22
mov	x1, x23
bl	LFQH_BottomTrack178
str	d0, [sp, #48]
fmov	d9, d1
fmov	d11, d2
fmov	d10, d3
LFQH_Lloh3962:
adr x24, LFQH_l_.str.461
LFQH_Lloh3963:
nop
mov	x0, x24
bl Lpatch + (0xa5a4 - PATCH_BASE)
mov	x1, x0
mov	x0, x19
mov	x2, #0
bl Lpatch + (0xa5d4 - PATCH_BASE)
mov	x23, x0
LFQH_Lloh3964:
adr x25, LFQH_l_.str.372
LFQH_Lloh3965:
nop
mov	x0, x25
bl Lpatch + (0xa5a4 - PATCH_BASE)
mov	x1, x0
mov	x0, x23
bl Lpatch + (0xa5d4 - PATCH_BASE)
fmov	d8, d0
fmov	d12, d2
sub	x23, x22, #1
mov	x0, x24
bl Lpatch + (0xa5a4 - PATCH_BASE)
mov	x1, x0
mov	x0, x19
mov	x2, x23
bl Lpatch + (0xa5d4 - PATCH_BASE)
mov	x24, x0
mov	x0, x25
bl Lpatch + (0xa5a4 - PATCH_BASE)
mov	x1, x0
mov	x0, x24
bl Lpatch + (0xa5d4 - PATCH_BASE)
cmp	x22, #2
b.lo	LFQH_LBB180_77
fmov	d1, #0.50000000
fmul	d3, d12, d1
fadd	d3, d8, d3
fmul	d1, d2, d1
fadd	d0, d0, d1
fcmp	d3, d0
cset	w8, le
b	LFQH_LBB180_79
LFQH_LBB180_77:
cbz	x22, LFQH_LBB180_2
mov	w8, #1
LFQH_LBB180_79:
str	w8, [sp, #32]
mov	x24, #0
ucvtf	d0, x22
LFQH_Lloh3966:
adr x28, LFQH_l_.str.461
LFQH_Lloh3967:
nop
LFQH_Lloh3968:
adr x26, LFQH_BottomButtonApplied178Key
LFQH_Lloh3969:
nop
LFQH_Lloh3970:
adr x22, LFQH_l_.str.512
LFQH_Lloh3971:
nop
fdiv	d11, d11, d0
LFQH_LBB180_80:
mov	x0, x28
bl Lpatch + (0xa5a4 - PATCH_BASE)
mov	x1, x0
mov	x0, x19
mov	x2, x24
bl Lpatch + (0xa5d4 - PATCH_BASE)
mov	x25, x0
mov	x1, x20
mov	x2, x21
bl	LFQH_BottomOwnsButton178
cbz	w0, LFQH_LBB180_89
ldr	w8, [sp, #32]
cmp	w8, #0
csel	x8, x24, x23, ne
str	x8, [sp, #80]
LFQH_Lloh3972:
adr x0, LFQH_l_.str.372
LFQH_Lloh3973:
nop
bl Lpatch + (0xa5a4 - PATCH_BASE)
mov	x1, x0
mov	x0, x25
bl Lpatch + (0xa5d4 - PATCH_BASE)
fmov	d12, d0
fmov	d13, d1
fmov	d14, d2
fmov	d15, d3
mov	x0, x25
mov	x1, x26
bl Lpatch + (0xa628 - PATCH_BASE)
mov	x27, x0
cbz	x0, LFQH_LBB180_83
LFQH_Lloh3974:
adr x0, LFQH_l_.str.432
LFQH_Lloh3975:
nop
bl Lpatch + (0xa5a4 - PATCH_BASE)
mov	x1, x0
mov	x0, x27
bl Lpatch + (0xa5d4 - PATCH_BASE)
fcmp	d12, d0
fccmp	d13, d1, #0, eq
fccmp	d14, d2, #0, eq
fccmp	d15, d3, #0, eq
b.eq	LFQH_LBB180_84
LFQH_LBB180_83:
mov	x0, x22
bl Lpatch + (0xa5b0 - PATCH_BASE)
str	x25, [sp, #64]
mov	x25, x27
mov	x27, x22
mov	x22, x26
mov	x26, x28
mov	x28, x0
LFQH_Lloh3976:
adr x0, LFQH_l_.str.513
LFQH_Lloh3977:
nop
bl Lpatch + (0xa5a4 - PATCH_BASE)
mov	x1, x0
mov	x0, x28
mov	x28, x26
mov	x26, x22
mov	x22, x27
mov	x27, x25
ldr	x25, [sp, #64]
fmov	d0, d12
fmov	d1, d13
fmov	d2, d14
fmov	d3, d15
bl Lpatch + (0xa5d4 - PATCH_BASE)
mov	x2, x0
mov	x0, x25
LFQH_Lloh3978:
adr x1, LFQH_BottomButtonStock178Key
LFQH_Lloh3979:
nop
mov	w3, #1
bl Lpatch + (0xa634 - PATCH_BASE)
LFQH_LBB180_84:
ldr	x8, [sp, #80]
ucvtf	d0, x8
fmul	d0, d11, d0
ldr	d1, [sp, #48]
fadd	d8, d1, d0
fcmp	d12, d8
fccmp	d13, d9, #0, eq
fccmp	d14, d11, #0, eq
fccmp	d15, d10, #0, eq
b.eq	LFQH_LBB180_86
LFQH_Lloh3980:
adr x0, LFQH_l_.str.156
LFQH_Lloh3981:
nop
bl Lpatch + (0xa5a4 - PATCH_BASE)
mov	x1, x0
mov	x0, x25
fmov	d0, d8
fmov	d1, d9
fmov	d2, d11
fmov	d3, d10
bl Lpatch + (0xa5d4 - PATCH_BASE)
LFQH_LBB180_86:
cbz	x27, LFQH_LBB180_88
LFQH_Lloh3982:
adr x0, LFQH_l_.str.432
LFQH_Lloh3983:
nop
bl Lpatch + (0xa5a4 - PATCH_BASE)
mov	x1, x0
mov	x0, x27
bl Lpatch + (0xa5d4 - PATCH_BASE)
fcmp	d8, d0
fccmp	d9, d1, #0, eq
fccmp	d11, d2, #0, eq
fccmp	d10, d3, #0, eq
b.eq	LFQH_LBB180_89
LFQH_LBB180_88:
mov	x0, x22
bl Lpatch + (0xa5b0 - PATCH_BASE)
mov	x27, x0
LFQH_Lloh3984:
adr x0, LFQH_l_.str.513
LFQH_Lloh3985:
nop
bl Lpatch + (0xa5a4 - PATCH_BASE)
mov	x1, x0
mov	x0, x27
fmov	d0, d8
fmov	d1, d9
fmov	d2, d11
fmov	d3, d10
bl Lpatch + (0xa5d4 - PATCH_BASE)
mov	x2, x0
mov	x0, x25
mov	x1, x26
mov	w3, #1
bl Lpatch + (0xa634 - PATCH_BASE)
LFQH_LBB180_89:
add	x24, x24, #1
sub	x23, x23, #1
cmn	x23, #1
b.ne	LFQH_LBB180_80
b	LFQH_LBB180_2
LFQH_LBB180_90:
mov	x0, x21
mov	x1, x23
bl	LFQH_BottomVisible178
cbz	w0, LFQH_LBB180_40
mov	w8, #160
str	w8, [sp, #100]
LFQH_Lloh3986:
adr x1, LFQH_l_.str.353
LFQH_Lloh3987:
nop
mov	x0, x24
bl	LFQH_Get
add	x3, sp, #100
mov	x1, x23
mov	w2, #8
bl	LFQH_BottomFindFeed178
LFQH_Lloh3988:
adr x1, LFQH_l_.str.888
LFQH_Lloh3989:
nop
bl	LFQH_Get
mov	x23, x0
LFQH_Lloh3990:
adr x1, LFQH_BottomObserver178Key
LFQH_Lloh3991:
nop
mov	x0, x21
bl Lpatch + (0xa628 - PATCH_BASE)
cbz	x23, LFQH_LBB180_40
mov	x24, x0
LFQH_Lloh3992:
adr x0, LFQH_l_.str.388
LFQH_Lloh3993:
nop
bl Lpatch + (0xa5a4 - PATCH_BASE)
mov	x25, x0
LFQH_Lloh3994:
adr x0, LFQH_l_.str.889
LFQH_Lloh3995:
nop
bl Lpatch + (0xa5a4 - PATCH_BASE)
mov	x2, x0
mov	x0, x23
mov	x1, x25
bl Lpatch + (0xa5d4 - PATCH_BASE)
cbz	w0, LFQH_LBB180_40
LFQH_Lloh3996:
adr x1, LFQH_BottomPanBox178Key
LFQH_Lloh3997:
nop
mov	x0, x24
bl Lpatch + (0xa628 - PATCH_BASE)
LFQH_Lloh3998:
adr x1, LFQH_l_.str.81
LFQH_Lloh3999:
nop
bl	LFQH_Get
cmp	x0, x23
b.eq	LFQH_LBB180_41
mov	x0, x21
bl	LFQH_BottomDetachPan178
bl	LFQH_BottomPanClass178
mov	x24, x0
LFQH_Lloh4000:
adr x0, LFQH_l_.str.421
LFQH_Lloh4001:
nop
bl Lpatch + (0xa5a4 - PATCH_BASE)
mov	x1, x0
mov	x0, x24
bl Lpatch + (0xa5d4 - PATCH_BASE)
cbz	x0, LFQH_LBB180_41
mov	x24, x0
LFQH_Lloh4002:
adr x1, LFQH_BottomBarBox178Key
LFQH_Lloh4003:
nop
mov	x2, x21
bl	LFQH_BottomSetWeak178
LFQH_Lloh4004:
adr x1, LFQH_BottomPanBox178Key
LFQH_Lloh4005:
nop
mov	x0, x24
mov	x2, x23
bl	LFQH_BottomSetWeak178
LFQH_Lloh4006:
adr x0, LFQH_l_.str.889
LFQH_Lloh4007:
nop
bl Lpatch + (0xa5a4 - PATCH_BASE)
mov	x25, x0
LFQH_Lloh4008:
adr x0, LFQH_l_.str.890
LFQH_Lloh4009:
nop
bl Lpatch + (0xa5a4 - PATCH_BASE)
mov	x3, x0
mov	x0, x23
mov	x1, x25
mov	x2, x24
bl Lpatch + (0xa5d4 - PATCH_BASE)
LFQH_Lloh4010:
adr x1, LFQH_BottomObserver178Key
LFQH_Lloh4011:
nop
mov	x0, x21
mov	x2, x24
mov	w3, #1
bl Lpatch + (0xa634 - PATCH_BASE)
LFQH_Lloh4012:
adr x0, LFQH_l_.str.56
LFQH_Lloh4013:
nop
bl Lpatch + (0xa5a4 - PATCH_BASE)
mov	x1, x0
mov	x0, x24
bl Lpatch + (0xa5d4 - PATCH_BASE)
b	LFQH_LBB180_41
.cfi_endproc
.p2align	2
LFQH_FQHBottomReset178:
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
mov	x19, x1
bl	LFQH_BottomDetachPan178
LFQH_Lloh4014:
adr x1, LFQH_BottomButtons178Key
LFQH_Lloh4015:
nop
mov	x0, x19
bl Lpatch + (0xa628 - PATCH_BASE)
mov	x20, x0
LFQH_Lloh4016:
adr x0, LFQH_l_.str.34
LFQH_Lloh4017:
nop
bl Lpatch + (0xa5a4 - PATCH_BASE)
mov	x1, x0
mov	x0, x20
bl Lpatch + (0xa5d4 - PATCH_BASE)
cmp	x0, #8
mov	w8, #8
csel	x26, x0, x8, lo
cbz	x0, LFQH_LBB181_3
mov	x21, #0
LFQH_Lloh4018:
adr x22, LFQH_l_.str.461
LFQH_Lloh4019:
nop
LFQH_Lloh4020:
adr x23, LFQH_BottomButtonStock178Key
LFQH_Lloh4021:
nop
LFQH_Lloh4022:
adr x24, LFQH_BottomButtonApplied178Key
LFQH_Lloh4023:
nop
LFQH_LBB181_2:
mov	x0, x22
bl Lpatch + (0xa5a4 - PATCH_BASE)
mov	x1, x0
mov	x0, x20
mov	x2, x21
bl Lpatch + (0xa5d4 - PATCH_BASE)
mov	x25, x0
bl	LFQH_BottomRestoreSymbol178
mov	x0, x25
mov	x1, x23
mov	x2, x24
bl	LFQH_BottomRestoreFrame178
add	x21, x21, #1
cmp	x26, x21
b.ne	LFQH_LBB181_2
LFQH_LBB181_3:
LFQH_Lloh4024:
adr x1, LFQH_BottomBaseFrame178Key
LFQH_Lloh4025:
nop
LFQH_Lloh4026:
adr x2, LFQH_BottomAppliedFrame178Key
LFQH_Lloh4027:
nop
mov	x0, x19
bl	LFQH_BottomRestoreFrame178
LFQH_Lloh4028:
adr x1, LFQH_l_.str.363
LFQH_Lloh4029:
nop
mov	x0, x19
bl	LFQH_Get
cbz	x0, LFQH_LBB181_15
mov	x20, x0
LFQH_Lloh4030:
adr x0, LFQH_l_.str.24
LFQH_Lloh4031:
nop
bl Lpatch + (0xa5a4 - PATCH_BASE)
mov	x1, x0
mov	x0, x19
bl Lpatch + (0xa5d4 - PATCH_BASE)
fmov	x9, d2
fmov	x8, d1
fmov	x10, d0
and	x10, x10, #0x7fffffffffffffff
and	x8, x8, #0x7fffffffffffffff
mov	x11, #9218868437227405311
cmp	x8, x11
cset	w8, gt
and	x9, x9, #0x7fffffffffffffff
cmp	x9, x11
cset	w9, gt
cmp	x10, x11
b.gt	LFQH_LBB181_15
tbnz	w8, #0, LFQH_LBB181_15
tbnz	w9, #0, LFQH_LBB181_15
fmov	x8, d3
and	x8, x8, #0x7fffffffffffffff
mov	x9, #9218868437227405311
cmp	x8, x9
b.gt	LFQH_LBB181_15
fcmp	d2, #0.0
b.le	LFQH_LBB181_15
fcmp	d3, #0.0
b.le	LFQH_LBB181_15
LFQH_Lloh4032:
adr x0, LFQH_l_.str.372
LFQH_Lloh4033:
nop
bl Lpatch + (0xa5a4 - PATCH_BASE)
mov	x1, x0
mov	x0, x20
bl Lpatch + (0xa5d4 - PATCH_BASE)
fmov	d11, d0
fmov	d10, d1
fmov	d9, d2
fmov	d8, d3
LFQH_Lloh4034:
adr x0, LFQH_l_.str.24
LFQH_Lloh4035:
nop
bl Lpatch + (0xa5a4 - PATCH_BASE)
mov	x1, x0
mov	x0, x19
bl Lpatch + (0xa5d4 - PATCH_BASE)
fcmp	d11, d0
b.ne	LFQH_LBB181_14
fcmp	d10, d1
b.ne	LFQH_LBB181_14
fcmp	d9, d2
b.ne	LFQH_LBB181_14
fcmp	d8, d3
b.eq	LFQH_LBB181_15
LFQH_LBB181_14:
LFQH_Lloh4036:
adr x0, LFQH_l_.str.24
LFQH_Lloh4037:
nop
bl Lpatch + (0xa5a4 - PATCH_BASE)
mov	x1, x0
mov	x0, x19
bl Lpatch + (0xa5d4 - PATCH_BASE)
fmov	d8, d0
fmov	d9, d1
fmov	d10, d2
fmov	d11, d3
LFQH_Lloh4038:
adr x0, LFQH_l_.str.156
LFQH_Lloh4039:
nop
bl Lpatch + (0xa5a4 - PATCH_BASE)
mov	x1, x0
mov	x0, x20
fmov	d0, d8
fmov	d1, d9
fmov	d2, d10
fmov	d3, d11
bl Lpatch + (0xa5d4 - PATCH_BASE)
LFQH_LBB181_15:
LFQH_Lloh4040:
adr x1, LFQH_BottomButtons178Key
LFQH_Lloh4041:
nop
mov	x0, x19
mov	x2, #0
mov	w3, #1
bl Lpatch + (0xa634 - PATCH_BASE)
LFQH_Lloh4042:
adr x1, LFQH_BottomLayoutLog178Key
LFQH_Lloh4043:
nop
mov	x0, x19
mov	x2, #0
mov	w3, #1
ldp	x29, x30, [sp, #96]
ldp	x20, x19, [sp, #80]
ldp	x22, x21, [sp, #64]
ldp	x24, x23, [sp, #48]
ldp	x26, x25, [sp, #32]
ldp	d9, d8, [sp, #16]
ldp	d11, d10, [sp], #112
b Lpatch + (0xa634 - PATCH_BASE)
.cfi_endproc
.p2align	2
LFQH_BottomRestoreSymbol178:
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
bl	LFQH_BottomRestoreTitles178R2
LFQH_Lloh4044:
adr x1, LFQH_BottomSymbol178Key
LFQH_Lloh4045:
nop
mov	x0, x19
bl Lpatch + (0xa628 - PATCH_BASE)
mov	x20, x0
LFQH_Lloh4046:
adr x1, LFQH_l_.str.20
LFQH_Lloh4047:
nop
bl	LFQH_Get
cmp	x0, x19
b.ne	LFQH_LBB182_2
LFQH_Lloh4048:
adr x0, LFQH_l_.str.431
LFQH_Lloh4049:
nop
bl Lpatch + (0xa5a4 - PATCH_BASE)
mov	x1, x0
mov	x0, x20
bl Lpatch + (0xa5d4 - PATCH_BASE)
LFQH_LBB182_2:
LFQH_Lloh4050:
adr x20, LFQH_BottomLabel178Key
LFQH_Lloh4051:
nop
mov	x0, x19
mov	x1, x20
bl Lpatch + (0xa628 - PATCH_BASE)
bl	LFQH_BottomRestoreHidden178
LFQH_Lloh4052:
adr x21, LFQH_BottomStockImage178Key
LFQH_Lloh4053:
nop
mov	x0, x19
mov	x1, x21
bl Lpatch + (0xa628 - PATCH_BASE)
bl	LFQH_BottomRestoreHidden178
LFQH_Lloh4054:
adr x1, LFQH_BottomSymbol178Key
LFQH_Lloh4055:
nop
mov	x0, x19
mov	x2, #0
mov	w3, #1
bl Lpatch + (0xa634 - PATCH_BASE)
LFQH_Lloh4056:
adr x1, LFQH_BottomSymbolName178Key
LFQH_Lloh4057:
nop
mov	x0, x19
mov	x2, #0
mov	w3, #1
bl Lpatch + (0xa634 - PATCH_BASE)
LFQH_Lloh4058:
adr x1, LFQH_BottomSymbolSize178Key
LFQH_Lloh4059:
nop
mov	x0, x19
mov	x2, #0
mov	w3, #1
bl Lpatch + (0xa634 - PATCH_BASE)
mov	x0, x19
mov	x1, x20
mov	x2, #0
mov	w3, #1
bl Lpatch + (0xa634 - PATCH_BASE)
mov	x0, x19
mov	x1, x21
mov	x2, #0
mov	w3, #1
bl Lpatch + (0xa634 - PATCH_BASE)
LFQH_Lloh4060:
adr x1, LFQH_BottomTitleFallback178R2Key
LFQH_Lloh4061:
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
LFQH_BottomOwnsButton178:
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
LFQH_Lloh4062:
adr x1, LFQH_l_.str.138
LFQH_Lloh4063:
nop
bl	LFQH_Kind
cbz	w0, LFQH_LBB183_6
LFQH_Lloh4064:
adr x1, LFQH_l_.str.20
LFQH_Lloh4065:
nop
mov	x0, x21
bl	LFQH_Get
cmp	x0, x20
b.eq	LFQH_LBB183_5
mov	x21, x0
LFQH_Lloh4066:
adr x1, LFQH_l_.str.363
LFQH_Lloh4067:
nop
mov	x0, x20
bl	LFQH_Get
cmp	x21, x0
b.eq	LFQH_LBB183_5
cbz	x21, LFQH_LBB183_7
LFQH_Lloh4068:
adr x1, LFQH_l_.str.20
LFQH_Lloh4069:
nop
mov	x0, x21
bl	LFQH_Get
cmp	x0, x19
cset	w0, eq
b	LFQH_LBB183_6
LFQH_LBB183_5:
mov	w0, #1
LFQH_LBB183_6:
ldp	x29, x30, [sp, #32]
ldp	x20, x19, [sp, #16]
ldp	x22, x21, [sp], #48
ret
LFQH_LBB183_7:
mov	w0, #0
b	LFQH_LBB183_6
.cfi_endproc
.p2align	2
LFQH_BottomRestoreTitles178R2:
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
mov	x19, x0
LFQH_Lloh4070:
adr x1, LFQH_BottomTitles178R2Key
LFQH_Lloh4071:
nop
bl Lpatch + (0xa628 - PATCH_BASE)
mov	x20, x0
LFQH_Lloh4072:
adr x0, LFQH_l_.str.34
LFQH_Lloh4073:
nop
bl Lpatch + (0xa5a4 - PATCH_BASE)
mov	x1, x0
mov	x0, x20
bl Lpatch + (0xa5d4 - PATCH_BASE)
cmp	x0, #32
b.ne	LFQH_LBB184_10
LFQH_Lloh4074:
adr x0, LFQH_l_.str.883
LFQH_Lloh4075:
nop
bl Lpatch + (0xa5a4 - PATCH_BASE)
mov	x1, x0
mov	x0, x19
mov	x2, #0
bl Lpatch + (0xa5d4 - PATCH_BASE)
str	x0, [sp, #8]
mov	w23, #30
mov	w24, #15
LFQH_Lloh4076:
adr x26, LFQH_l_.str.885
LFQH_Lloh4077:
nop
LFQH_Lloh4078:
adr x27, LFQH_l_.str.461
LFQH_Lloh4079:
nop
LFQH_Lloh4080:
adr x22, LFQH_l_.str.476
LFQH_Lloh4081:
nop
LFQH_LBB184_2:
LFQH_Lloh4082:
adr x0, LFQH_l_.str.884
LFQH_Lloh4083:
nop
bl Lpatch + (0xa5a4 - PATCH_BASE)
mov	x1, x0
mov	x0, x19
mov	x2, x24
bl Lpatch + (0xa5d4 - PATCH_BASE)
mov	x21, x0
LFQH_Lloh4084:
adr x0, LFQH_l_.str.883
LFQH_Lloh4085:
nop
bl Lpatch + (0xa5a4 - PATCH_BASE)
mov	x1, x0
mov	x0, x19
mov	x2, x24
bl Lpatch + (0xa5d4 - PATCH_BASE)
mov	x28, x0
mov	x0, x21
mov	x1, x26
bl	LFQH_Equal
cbz	w0, LFQH_LBB184_8
mov	x0, x27
bl Lpatch + (0xa5a4 - PATCH_BASE)
mov	x1, x0
mov	x0, x20
mov	x2, x23
bl Lpatch + (0xa5d4 - PATCH_BASE)
mov	x21, x0
LFQH_Lloh4086:
adr x0, LFQH_l_.str.886
LFQH_Lloh4087:
nop
bl Lpatch + (0xa5a4 - PATCH_BASE)
mov	x25, x0
mov	x0, x21
mov	x1, x22
bl	LFQH_Kind
cmp	w0, #0
csel	x2, x21, xzr, eq
mov	x0, x19
mov	x1, x25
mov	x3, x24
bl Lpatch + (0xa5d4 - PATCH_BASE)
cbz	x28, LFQH_LBB184_6
cbz	x23, LFQH_LBB184_8
ldr	x8, [sp, #8]
cmp	x28, x8
b.ne	LFQH_LBB184_8
LFQH_LBB184_6:
mov	x0, x27
bl Lpatch + (0xa5a4 - PATCH_BASE)
mov	x1, x0
add	x2, x23, #1
mov	x0, x20
bl Lpatch + (0xa5d4 - PATCH_BASE)
mov	x28, x0
mov	x1, x22
bl	LFQH_Kind
cbnz	w0, LFQH_LBB184_8
LFQH_Lloh4088:
adr x0, LFQH_l_.str.887
LFQH_Lloh4089:
nop
bl Lpatch + (0xa5a4 - PATCH_BASE)
mov	x1, x0
mov	x0, x19
mov	x2, x28
mov	x3, x24
bl Lpatch + (0xa5d4 - PATCH_BASE)
LFQH_LBB184_8:
sub	x23, x23, #2
sub	x24, x24, #1
cmn	x23, #2
b.ne	LFQH_LBB184_2
LFQH_Lloh4090:
adr x1, LFQH_BottomTitles178R2Key
LFQH_Lloh4091:
nop
mov	x0, x19
mov	x2, #0
mov	w3, #1
ldp	x29, x30, [sp, #96]
ldp	x20, x19, [sp, #80]
ldp	x22, x21, [sp, #64]
ldp	x24, x23, [sp, #48]
ldp	x26, x25, [sp, #32]
ldp	x28, x27, [sp, #16]
add	sp, sp, #112
b Lpatch + (0xa634 - PATCH_BASE)
LFQH_LBB184_10:
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
LFQH_BottomSetWeak178:
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
bl Lpatch + (0xa628 - PATCH_BASE)
LFQH_Lloh4092:
adr x1, LFQH_l_.str.81
LFQH_Lloh4093:
nop
bl	LFQH_Get
cmp	x0, x21
b.eq	LFQH_LBB185_3
cbz	x21, LFQH_LBB185_4
mov	x0, x21
bl	LFQH_BottomWeak178
mov	x2, x0
b	LFQH_LBB185_5
LFQH_LBB185_3:
ldp	x29, x30, [sp, #32]
ldp	x20, x19, [sp, #16]
ldp	x22, x21, [sp], #48
ret
LFQH_LBB185_4:
mov	x2, #0
LFQH_LBB185_5:
mov	x0, x20
mov	x1, x19
mov	w3, #1
ldp	x29, x30, [sp, #32]
ldp	x20, x19, [sp, #16]
ldp	x22, x21, [sp], #48
b Lpatch + (0xa634 - PATCH_BASE)
.cfi_endproc
.p2align	2
LFQH_BottomProxyBox178Key:
.cfi_startproc
ret
.cfi_endproc
.p2align	2
LFQH_BottomBars178:
.cfi_startproc
stp	x20, x19, [sp, #-32]!
stp	x29, x30, [sp, #16]
add	x29, sp, #16
.cfi_def_cfa w29, 16
.cfi_offset w30, -8
.cfi_offset w29, -16
.cfi_offset w19, -24
.cfi_offset w20, -32
LFQH_Lloh4094:
adr x0, LFQH_l_.str.467
LFQH_Lloh4095:
nop
bl Lpatch + (0xa5b0 - PATCH_BASE)
mov	x19, x0
LFQH_Lloh4096:
adr x0, LFQH_l_.str.468
LFQH_Lloh4097:
nop
bl Lpatch + (0xa5a4 - PATCH_BASE)
mov	x1, x0
mov	x0, x19
bl Lpatch + (0xa5d4 - PATCH_BASE)
mov	x19, x0
LFQH_Lloh4098:
adr x1, LFQH_BottomBars178Key
LFQH_Lloh4099:
nop
bl Lpatch + (0xa628 - PATCH_BASE)
mov	x20, x0
cbnz	x0, LFQH_LBB187_2
LFQH_Lloh4100:
adr x0, LFQH_l_.str.82
LFQH_Lloh4101:
nop
bl Lpatch + (0xa5b0 - PATCH_BASE)
mov	x20, x0
LFQH_Lloh4102:
adr x0, LFQH_l_.str.83
LFQH_Lloh4103:
nop
bl Lpatch + (0xa5a4 - PATCH_BASE)
mov	x1, x0
mov	x0, x20
bl Lpatch + (0xa5d4 - PATCH_BASE)
mov	x20, x0
LFQH_Lloh4104:
adr x1, LFQH_BottomBars178Key
LFQH_Lloh4105:
nop
mov	x0, x19
mov	x2, x20
mov	w3, #1
bl Lpatch + (0xa634 - PATCH_BASE)
LFQH_LBB187_2:
mov	x0, x20
ldp	x29, x30, [sp, #16]
ldp	x20, x19, [sp], #32
ret
.cfi_endproc
.p2align	2
LFQH_BottomBaseFrame178Key:
.cfi_startproc
ret
.cfi_endproc
.p2align	2
LFQH_BottomAppliedFrame178Key:
.cfi_startproc
ret
.cfi_endproc
.p2align	2
LFQH_BottomRestoreFrame178:
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
mov	x21, x1
mov	x20, x0
bl Lpatch + (0xa628 - PATCH_BASE)
mov	x22, x0
mov	x0, x20
mov	x1, x19
bl Lpatch + (0xa628 - PATCH_BASE)
cbz	x22, LFQH_LBB190_4
mov	x23, x0
cbz	x0, LFQH_LBB190_4
LFQH_Lloh4106:
adr x0, LFQH_l_.str.372
LFQH_Lloh4107:
nop
bl Lpatch + (0xa5a4 - PATCH_BASE)
mov	x1, x0
mov	x0, x20
bl Lpatch + (0xa5d4 - PATCH_BASE)
fmov	d8, d0
fmov	d9, d1
fmov	d10, d2
fmov	d11, d3
LFQH_Lloh4108:
adr x0, LFQH_l_.str.432
LFQH_Lloh4109:
nop
bl Lpatch + (0xa5a4 - PATCH_BASE)
mov	x1, x0
mov	x0, x23
bl Lpatch + (0xa5d4 - PATCH_BASE)
fcmp	d8, d0
fccmp	d9, d1, #0, eq
fccmp	d10, d2, #0, eq
fccmp	d11, d3, #0, eq
b.ne	LFQH_LBB190_4
LFQH_Lloh4110:
adr x0, LFQH_l_.str.432
LFQH_Lloh4111:
nop
bl Lpatch + (0xa5a4 - PATCH_BASE)
mov	x1, x0
mov	x0, x22
bl Lpatch + (0xa5d4 - PATCH_BASE)
fmov	d8, d0
fmov	d9, d1
fmov	d10, d2
fmov	d11, d3
LFQH_Lloh4112:
adr x0, LFQH_l_.str.156
LFQH_Lloh4113:
nop
bl Lpatch + (0xa5a4 - PATCH_BASE)
mov	x1, x0
mov	x0, x20
fmov	d0, d8
fmov	d1, d9
fmov	d2, d10
fmov	d3, d11
bl Lpatch + (0xa5d4 - PATCH_BASE)
LFQH_LBB190_4:
mov	x0, x20
mov	x1, x21
mov	x2, #0
mov	w3, #1
bl Lpatch + (0xa634 - PATCH_BASE)
mov	x0, x20
mov	x1, x19
mov	x2, #0
mov	w3, #1
ldp	x29, x30, [sp, #80]
ldp	x20, x19, [sp, #64]
ldp	x22, x21, [sp, #48]
ldp	x24, x23, [sp, #32]
ldp	d9, d8, [sp, #16]
ldp	d11, d10, [sp], #96
b Lpatch + (0xa634 - PATCH_BASE)
.cfi_endproc
.p2align	2
LFQH_BottomButtonStock178Key:
.cfi_startproc
ret
.cfi_endproc
.p2align	2
LFQH_BottomButtonApplied178Key:
.cfi_startproc
ret
.cfi_endproc
.p2align	2
LFQH_FQHBottomFinish:
.cfi_startproc
sub	sp, sp, #208
stp	d11, d10, [sp, #80]
stp	d9, d8, [sp, #96]
stp	x28, x27, [sp, #112]
stp	x26, x25, [sp, #128]
stp	x24, x23, [sp, #144]
stp	x22, x21, [sp, #160]
stp	x20, x19, [sp, #176]
stp	x29, x30, [sp, #192]
add	x29, sp, #192
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
mov	x19, x3
mov	x20, x2
mov	x25, x1
mov	x21, x0
bl	LFQH_Enabled
cbz	w0, LFQH_LBB193_4
LFQH_Lloh4114:
adr x0, LFQH_l_.str.34
LFQH_Lloh4115:
nop
bl Lpatch + (0xa5a4 - PATCH_BASE)
mov	x1, x0
mov	x0, x20
bl Lpatch + (0xa5d4 - PATCH_BASE)
str	x0, [sp, #72]
sub	x8, x0, #9
cmn	x8, #8
b.lo	LFQH_LBB193_3
LFQH_Lloh4116:
adr x1, LFQH_l_.str.20
LFQH_Lloh4117:
nop
mov	x0, x25
bl	LFQH_Get
cmp	x0, x21
b.eq	LFQH_LBB193_5
LFQH_LBB193_3:
ldp	x29, x30, [sp, #192]
ldp	x20, x19, [sp, #176]
ldp	x22, x21, [sp, #160]
ldp	x24, x23, [sp, #144]
ldp	x26, x25, [sp, #128]
ldp	x28, x27, [sp, #112]
ldp	d9, d8, [sp, #96]
ldp	d11, d10, [sp, #80]
add	sp, sp, #208
ret
LFQH_LBB193_4:
mov	x0, x21
mov	x1, x25
ldp	x29, x30, [sp, #192]
ldp	x20, x19, [sp, #176]
ldp	x22, x21, [sp, #160]
ldp	x24, x23, [sp, #144]
ldp	x26, x25, [sp, #128]
ldp	x28, x27, [sp, #112]
ldp	d9, d8, [sp, #96]
ldp	d11, d10, [sp, #80]
add	sp, sp, #208
b	LFQH_FQHBottomReset178
LFQH_LBB193_5:
bl	LFQH_Enabled
str	x21, [sp, #56]
str	x19, [sp, #24]
cbz	w0, LFQH_LBB193_19
mov	w0, #1
bl	LFQH_BottomFlag178
str	w0, [sp, #52]
cbz	w0, LFQH_LBB193_19
LFQH_Lloh4118:
adr x1, LFQH_l_.str.892
LFQH_Lloh4119:
nop
mov	x0, x19
bl	LFQH_Kind
cbz	w0, LFQH_LBB193_20
LFQH_Lloh4120:
adr x1, LFQH_l_.str.893
LFQH_Lloh4121:
nop
mov	x0, x19
bl	LFQH_Responds
cbz	w0, LFQH_LBB193_20
str	x20, [sp, #64]
str	x25, [sp, #16]
LFQH_Lloh4122:
adr x0, LFQH_l_.str.47
LFQH_Lloh4123:
nop
bl Lpatch + (0xa5b0 - PATCH_BASE)
mov	x19, x0
LFQH_Lloh4124:
adr x0, LFQH_l_.str.158
LFQH_Lloh4125:
nop
bl Lpatch + (0xa5a4 - PATCH_BASE)
mov	x1, x0
mov	x0, x19
bl Lpatch + (0xa5d4 - PATCH_BASE)
mov	x20, x0
LFQH_Lloh4126:
adr x0, LFQH_l_.str.361
LFQH_Lloh4127:
nop
bl Lpatch + (0xa5b0 - PATCH_BASE)
mov	x19, x0
LFQH_Lloh4128:
adr x0, LFQH_l_.str.387
LFQH_Lloh4129:
nop
bl Lpatch + (0xa5a4 - PATCH_BASE)
mov	x1, x0
LFQH_Lloh4130:
adr x2, LFQH_l_.str.894
LFQH_Lloh4131:
nop
mov	x0, x19
bl Lpatch + (0xa5d4 - PATCH_BASE)
mov	x21, x0
mov	x22, #0
LFQH_Lloh4132:
adr x23, LFQH_l_.str.893
LFQH_Lloh4133:
nop
LFQH_Lloh4134:
adr x25, LFQH_l_.str.536
LFQH_Lloh4135:
nop
LFQH_Lloh4136:
adr x26, LFQH_l_.str.49
LFQH_Lloh4137:
nop
LFQH_Lloh4138:
adr x27, LFQH_l_.str.56
LFQH_Lloh4139:
nop
LFQH_Lloh4140:
adr x28, LFQH_l_.str.802
LFQH_Lloh4141:
nop
LFQH_LBB193_10:
mov	x0, x23
bl Lpatch + (0xa5a4 - PATCH_BASE)
mov	x1, x0
ldr	x0, [sp, #24]
mov	x2, x22
bl Lpatch + (0xa5d4 - PATCH_BASE)
mov	x19, x0
mov	x0, x25
bl Lpatch + (0xa5a4 - PATCH_BASE)
mov	x1, x0
mov	x0, x19
mov	x2, x21
bl Lpatch + (0xa5d4 - PATCH_BASE)
cmp	x0, x20
b.eq	LFQH_LBB193_17
mov	x24, x0
mov	x0, x26
bl Lpatch + (0xa5a4 - PATCH_BASE)
mov	x1, x0
mov	x0, x24
mov	x2, x20
bl Lpatch + (0xa5d4 - PATCH_BASE)
cbnz	w0, LFQH_LBB193_17
cbz	x19, LFQH_LBB193_14
mov	x0, x28
b	LFQH_LBB193_15
LFQH_LBB193_14:
LFQH_Lloh4142:
adr x0, LFQH_l_.str.88
LFQH_Lloh4143:
nop
bl Lpatch + (0xa5b0 - PATCH_BASE)
mov	x19, x0
LFQH_Lloh4144:
adr x0, LFQH_l_.str.421
LFQH_Lloh4145:
nop
LFQH_LBB193_15:
bl Lpatch + (0xa5a4 - PATCH_BASE)
mov	x1, x0
mov	x0, x19
bl Lpatch + (0xa5d4 - PATCH_BASE)
mov	x19, x0
cbz	x0, LFQH_LBB193_17
LFQH_Lloh4146:
adr x0, LFQH_l_.str.514
LFQH_Lloh4147:
nop
bl Lpatch + (0xa5a4 - PATCH_BASE)
mov	x1, x0
mov	x0, x19
mov	x2, x20
mov	x3, x21
bl Lpatch + (0xa5d4 - PATCH_BASE)
LFQH_Lloh4148:
adr x0, LFQH_l_.str.895
LFQH_Lloh4149:
nop
bl Lpatch + (0xa5a4 - PATCH_BASE)
mov	x1, x0
ldr	x0, [sp, #24]
mov	x2, x19
mov	x3, x22
bl Lpatch + (0xa5d4 - PATCH_BASE)
mov	x0, x27
bl Lpatch + (0xa5a4 - PATCH_BASE)
mov	x1, x0
mov	x0, x19
bl Lpatch + (0xa5d4 - PATCH_BASE)
LFQH_LBB193_17:
add	x22, x22, #1
cmp	x22, #16
b.ne	LFQH_LBB193_10
mov	w8, #1
str	w8, [sp, #12]
ldr	x25, [sp, #16]
ldp	x21, x20, [sp, #56]
b	LFQH_LBB193_21
LFQH_LBB193_19:
str	wzr, [sp, #52]
str	wzr, [sp, #12]
b	LFQH_LBB193_21
LFQH_LBB193_20:
mov	w8, #1
str	w8, [sp, #52]
str	w8, [sp, #12]
LFQH_LBB193_21:
LFQH_Lloh4150:
adr x1, LFQH_l_.str.359
LFQH_Lloh4151:
nop
mov	x0, x21
bl	LFQH_Get
str	x0, [sp, #40]
mov	w0, #14
bl	LFQH_BottomValue178
fmov	d8, d0
LFQH_Lloh4152:
adr x0, LFQH_l_.str.133
LFQH_Lloh4153:
nop
bl Lpatch + (0xa5a4 - PATCH_BASE)
mov	x1, x0
mov	x0, x25
bl Lpatch + (0xa5d4 - PATCH_BASE)
str	x0, [sp, #32]
ldr	x8, [sp, #72]
cbz	x8, LFQH_LBB193_104
mov	x27, #0
fmov	d11, #0.50000000
str	x25, [sp, #16]
str	x20, [sp, #64]
LFQH_LBB193_23:
LFQH_Lloh4154:
adr x0, LFQH_l_.str.461
LFQH_Lloh4155:
nop
bl Lpatch + (0xa5a4 - PATCH_BASE)
mov	x1, x0
mov	x0, x20
mov	x2, x27
bl Lpatch + (0xa5d4 - PATCH_BASE)
mov	x23, x0
mov	x1, x25
mov	x2, x21
bl	LFQH_BottomOwnsButton178
cbz	w0, LFQH_LBB193_103
mov	x0, x23
LFQH_Lloh4156:
adr x1, LFQH_l_.str.20
LFQH_Lloh4157:
nop
bl	LFQH_Get
cmp	x0, x25
b.eq	LFQH_LBB193_26
mov	x19, x0
mov	x0, x25
LFQH_Lloh4158:
adr x1, LFQH_l_.str.363
LFQH_Lloh4159:
nop
bl	LFQH_Get
cmp	x19, x0
ldr	x8, [sp, #32]
csel	x19, xzr, x8, eq
b	LFQH_LBB193_27
LFQH_LBB193_26:
mov	x19, #0
LFQH_LBB193_27:
LFQH_Lloh4160:
adr x0, LFQH_l_.str.133
LFQH_Lloh4161:
nop
bl Lpatch + (0xa5a4 - PATCH_BASE)
mov	x1, x0
mov	x0, x23
bl Lpatch + (0xa5d4 - PATCH_BASE)
cmp	x0, x19
b.eq	LFQH_LBB193_29
LFQH_Lloh4162:
adr x0, LFQH_l_.str.134
LFQH_Lloh4163:
nop
bl Lpatch + (0xa5a4 - PATCH_BASE)
mov	x1, x0
mov	x0, x23
mov	x2, x19
bl Lpatch + (0xa5d4 - PATCH_BASE)
LFQH_LBB193_29:
LFQH_Lloh4164:
adr x0, LFQH_l_.str.34
LFQH_Lloh4165:
nop
bl Lpatch + (0xa5a4 - PATCH_BASE)
mov	x1, x0
ldr	x19, [sp, #40]
mov	x0, x19
bl Lpatch + (0xa5d4 - PATCH_BASE)
ldr	x8, [sp, #72]
cmp	x0, x8
b.ne	LFQH_LBB193_31
LFQH_Lloh4166:
adr x0, LFQH_l_.str.461
LFQH_Lloh4167:
nop
bl Lpatch + (0xa5a4 - PATCH_BASE)
mov	x1, x0
mov	x0, x19
mov	x2, x27
bl Lpatch + (0xa5d4 - PATCH_BASE)
b	LFQH_LBB193_32
LFQH_LBB193_31:
mov	x0, #0
LFQH_LBB193_32:
ldr	w8, [sp, #52]
cbz	w8, LFQH_LBB193_102
LFQH_Lloh4168:
adr x1, LFQH_l_.str.360
LFQH_Lloh4169:
nop
bl	LFQH_Get
mov	x26, x0
LFQH_Lloh4170:
adr x21, LFQH_l_.str.361
LFQH_Lloh4171:
nop
mov	x1, x21
bl	LFQH_Kind
cbz	w0, LFQH_LBB193_35
LFQH_Lloh4172:
adr x0, LFQH_l_.str.362
LFQH_Lloh4173:
nop
bl Lpatch + (0xa5a4 - PATCH_BASE)
mov	x1, x0
mov	x0, x26
bl Lpatch + (0xa5d4 - PATCH_BASE)
cbnz	x0, LFQH_LBB193_36
LFQH_LBB193_35:
mov	x0, x23
LFQH_Lloh4174:
adr x1, LFQH_l_.str.903
LFQH_Lloh4175:
nop
bl	LFQH_Get
mov	x26, x0
LFQH_LBB193_36:
mov	x0, x26
mov	x1, x21
bl	LFQH_Kind
cbz	w0, LFQH_LBB193_38
LFQH_Lloh4176:
adr x0, LFQH_l_.str.362
LFQH_Lloh4177:
nop
bl Lpatch + (0xa5a4 - PATCH_BASE)
mov	x1, x0
mov	x0, x26
bl Lpatch + (0xa5d4 - PATCH_BASE)
cbnz	x0, LFQH_LBB193_39
LFQH_LBB193_38:
mov	x0, x23
LFQH_Lloh4178:
adr x1, LFQH_BottomTitleFallback178R2Key
LFQH_Lloh4179:
nop
bl Lpatch + (0xa628 - PATCH_BASE)
mov	x26, x0
LFQH_LBB193_39:
cbnz	x26, LFQH_LBB193_41
mov	x0, x23
LFQH_Lloh4180:
adr x1, LFQH_l_.str.430
LFQH_Lloh4181:
nop
bl	LFQH_Get
LFQH_Lloh4182:
adr x1, LFQH_l_.str.500
LFQH_Lloh4183:
nop
bl	LFQH_Get
mov	x26, x0
LFQH_LBB193_41:
mov	x0, x23
LFQH_Lloh4184:
adr x1, LFQH_l_.str.424
LFQH_Lloh4185:
nop
bl	LFQH_BoolProp
mov	x19, x0
mov	x0, x26
LFQH_Lloh4186:
adr x1, LFQH_l_.str.904
LFQH_Lloh4187:
nop
bl	LFQH_Equal
cbnz	w0, LFQH_LBB193_43
mov	x0, x26
LFQH_Lloh4188:
adr x1, LFQH_l_.str.905
LFQH_Lloh4189:
nop
bl	LFQH_Equal
cbz	w0, LFQH_LBB193_55
LFQH_LBB193_43:
cmp	w19, #0
LFQH_Lloh4190:
adr x8, LFQH_l_.str.906
LFQH_Lloh4191:
nop
LFQH_Lloh4192:
adr x9, LFQH_l_.str.907
LFQH_Lloh4193:
nop
LFQH_LBB193_44:
csel	x19, x9, x8, eq
mov	x0, x23
LFQH_Lloh4194:
adr x1, LFQH_BottomSymbol178Key
LFQH_Lloh4195:
nop
bl Lpatch + (0xa628 - PATCH_BASE)
mov	x20, x0
mov	x0, x21
bl Lpatch + (0xa5b0 - PATCH_BASE)
mov	x24, x0
LFQH_Lloh4196:
adr x0, LFQH_l_.str.387
LFQH_Lloh4197:
nop
bl Lpatch + (0xa5a4 - PATCH_BASE)
mov	x1, x0
mov	x0, x24
mov	x2, x19
bl Lpatch + (0xa5d4 - PATCH_BASE)
mov	x28, x0
mov	w21, #0
cbz	x28, LFQH_LBB193_102
LFQH_LBB193_45:
cbz	x20, LFQH_LBB193_48
LFQH_Lloh4198:
adr x0, LFQH_l_.str.49
LFQH_Lloh4199:
nop
bl Lpatch + (0xa5a4 - PATCH_BASE)
mov	x19, x0
mov	x0, x23
LFQH_Lloh4200:
adr x1, LFQH_BottomSymbolName178Key
LFQH_Lloh4201:
nop
bl Lpatch + (0xa628 - PATCH_BASE)
mov	x2, x0
mov	x0, x28
mov	x1, x19
bl Lpatch + (0xa5d4 - PATCH_BASE)
cbz	w0, LFQH_LBB193_48
mov	x0, x23
LFQH_Lloh4202:
adr x1, LFQH_BottomSymbolSize178Key
LFQH_Lloh4203:
nop
bl Lpatch + (0xa628 - PATCH_BASE)
mov	x19, x0
LFQH_Lloh4204:
adr x0, LFQH_l_.str.445
LFQH_Lloh4205:
nop
bl Lpatch + (0xa5a4 - PATCH_BASE)
mov	x1, x0
mov	x0, x19
bl Lpatch + (0xa5d4 - PATCH_BASE)
fcmp	d0, d8
b.eq	LFQH_LBB193_58
LFQH_LBB193_48:
mov	x19, x28
tbnz	w21, #0, LFQH_LBB193_51
LFQH_Lloh4206:
adr x0, LFQH_l_.str.897
LFQH_Lloh4207:
nop
bl Lpatch + (0xa5b0 - PATCH_BASE)
mov	x19, x0
LFQH_Lloh4208:
adr x0, LFQH_l_.str.898
LFQH_Lloh4209:
nop
bl Lpatch + (0xa5a4 - PATCH_BASE)
mov	x1, x0
mov	x0, x19
fmov	d0, d8
mov	w2, #5
mov	w3, #2
bl Lpatch + (0xa5d4 - PATCH_BASE)
mov	x19, x0
LFQH_Lloh4210:
adr x0, LFQH_l_.str.899
LFQH_Lloh4211:
nop
bl Lpatch + (0xa5b0 - PATCH_BASE)
LFQH_Lloh4212:
adr x1, LFQH_l_.str.900
LFQH_Lloh4213:
nop
bl	LFQH_Responds
cbz	w0, LFQH_LBB193_102
LFQH_Lloh4214:
adr x0, LFQH_l_.str.899
LFQH_Lloh4215:
nop
bl Lpatch + (0xa5b0 - PATCH_BASE)
mov	x24, x0
LFQH_Lloh4216:
adr x0, LFQH_l_.str.900
LFQH_Lloh4217:
nop
bl Lpatch + (0xa5a4 - PATCH_BASE)
mov	x1, x0
mov	x0, x24
mov	x2, x28
mov	x3, x19
bl Lpatch + (0xa5d4 - PATCH_BASE)
mov	x19, x0
cbz	x0, LFQH_LBB193_102
LFQH_LBB193_51:
LFQH_Lloh4218:
adr x0, LFQH_l_.str.854
LFQH_Lloh4219:
nop
bl Lpatch + (0xa5a4 - PATCH_BASE)
mov	x1, x0
mov	x0, x19
mov	w2, #2
bl Lpatch + (0xa5d4 - PATCH_BASE)
mov	x24, x0
ldr	x21, [sp, #56]
cbnz	x20, LFQH_LBB193_54
LFQH_Lloh4220:
adr x0, LFQH_l_.str.70
LFQH_Lloh4221:
nop
bl Lpatch + (0xa5b0 - PATCH_BASE)
mov	x19, x0
LFQH_Lloh4222:
adr x0, LFQH_l_.str.421
LFQH_Lloh4223:
nop
bl Lpatch + (0xa5a4 - PATCH_BASE)
mov	x1, x0
mov	x0, x19
bl Lpatch + (0xa5d4 - PATCH_BASE)
cbz	x0, LFQH_LBB193_103
mov	x20, x0
LFQH_Lloh4224:
adr x0, LFQH_l_.str.399
LFQH_Lloh4225:
nop
bl Lpatch + (0xa5a4 - PATCH_BASE)
mov	x1, x0
mov	x0, x20
mov	w2, #0
bl Lpatch + (0xa5d4 - PATCH_BASE)
LFQH_Lloh4226:
adr x0, LFQH_l_.str.401
LFQH_Lloh4227:
nop
bl Lpatch + (0xa5a4 - PATCH_BASE)
mov	x1, x0
mov	x0, x20
mov	w2, #0
bl Lpatch + (0xa5d4 - PATCH_BASE)
LFQH_Lloh4228:
adr x0, LFQH_l_.str.400
LFQH_Lloh4229:
nop
bl Lpatch + (0xa5a4 - PATCH_BASE)
mov	x1, x0
mov	x0, x20
mov	w2, #1
bl Lpatch + (0xa5d4 - PATCH_BASE)
LFQH_Lloh4230:
adr x0, LFQH_l_.str.901
LFQH_Lloh4231:
nop
bl Lpatch + (0xa5a4 - PATCH_BASE)
mov	x1, x0
mov	x0, x20
mov	w2, #1
bl Lpatch + (0xa5d4 - PATCH_BASE)
LFQH_Lloh4232:
adr x0, LFQH_l_.str.167
LFQH_Lloh4233:
nop
bl Lpatch + (0xa5a4 - PATCH_BASE)
mov	x1, x0
mov	x0, x23
mov	x2, x20
bl Lpatch + (0xa5d4 - PATCH_BASE)
mov	x0, x23
LFQH_Lloh4234:
adr x1, LFQH_BottomSymbol178Key
LFQH_Lloh4235:
nop
mov	x2, x20
mov	w3, #1
bl Lpatch + (0xa634 - PATCH_BASE)
LFQH_Lloh4236:
adr x0, LFQH_l_.str.56
LFQH_Lloh4237:
nop
bl Lpatch + (0xa5a4 - PATCH_BASE)
mov	x1, x0
mov	x0, x20
bl Lpatch + (0xa5d4 - PATCH_BASE)
LFQH_LBB193_54:
LFQH_Lloh4238:
adr x0, LFQH_l_.str.902
LFQH_Lloh4239:
nop
bl Lpatch + (0xa5a4 - PATCH_BASE)
mov	x1, x0
mov	x0, x20
mov	x2, x24
bl Lpatch + (0xa5d4 - PATCH_BASE)
mov	x0, x23
LFQH_Lloh4240:
adr x1, LFQH_BottomSymbolName178Key
LFQH_Lloh4241:
nop
mov	x2, x28
mov	w3, #1
bl Lpatch + (0xa634 - PATCH_BASE)
LFQH_Lloh4242:
adr x0, LFQH_l_.str.497
LFQH_Lloh4243:
nop
bl Lpatch + (0xa5b0 - PATCH_BASE)
mov	x19, x0
LFQH_Lloh4244:
adr x0, LFQH_l_.str.515
LFQH_Lloh4245:
nop
bl Lpatch + (0xa5a4 - PATCH_BASE)
mov	x1, x0
mov	x0, x19
fmov	d0, d8
bl Lpatch + (0xa5d4 - PATCH_BASE)
mov	x2, x0
mov	x0, x23
LFQH_Lloh4246:
adr x1, LFQH_BottomSymbolSize178Key
LFQH_Lloh4247:
nop
mov	w3, #1
bl Lpatch + (0xa634 - PATCH_BASE)
b	LFQH_LBB193_59
LFQH_LBB193_55:
mov	x0, x26
LFQH_Lloh4248:
adr x1, LFQH_l_.str.596
LFQH_Lloh4249:
nop
bl	LFQH_Equal
cbnz	w0, LFQH_LBB193_57
mov	x0, x26
LFQH_Lloh4250:
adr x1, LFQH_l_.str.908
LFQH_Lloh4251:
nop
bl	LFQH_Equal
cbz	w0, LFQH_LBB193_93
LFQH_LBB193_57:
cmp	w19, #0
LFQH_Lloh4252:
adr x8, LFQH_l_.str.909
LFQH_Lloh4253:
nop
LFQH_Lloh4254:
adr x9, LFQH_l_.str.910
LFQH_Lloh4255:
nop
b	LFQH_LBB193_44
LFQH_LBB193_58:
ldr	x21, [sp, #56]
LFQH_LBB193_59:
mov	x0, x23
LFQH_Lloh4256:
adr x1, LFQH_l_.str.430
LFQH_Lloh4257:
nop
bl	LFQH_Get
mov	x19, x0
mov	x0, x23
LFQH_Lloh4258:
adr x1, LFQH_l_.str.420
LFQH_Lloh4259:
nop
bl	LFQH_Get
mov	x24, x0
mov	x0, x23
LFQH_Lloh4260:
adr x28, LFQH_BottomLabel178Key
LFQH_Lloh4261:
nop
mov	x1, x28
bl Lpatch + (0xa628 - PATCH_BASE)
cmp	x0, x19
b.eq	LFQH_LBB193_61
bl	LFQH_BottomRestoreHidden178
mov	x0, x23
mov	x1, x28
mov	x2, x19
mov	w3, #1
bl Lpatch + (0xa634 - PATCH_BASE)
LFQH_LBB193_61:
mov	x0, x23
LFQH_Lloh4262:
adr x28, LFQH_BottomStockImage178Key
LFQH_Lloh4263:
nop
mov	x1, x28
bl Lpatch + (0xa628 - PATCH_BASE)
cmp	x0, x24
b.eq	LFQH_LBB193_63
bl	LFQH_BottomRestoreHidden178
mov	x0, x23
mov	x1, x28
mov	x2, x24
mov	w3, #1
bl Lpatch + (0xa634 - PATCH_BASE)
LFQH_LBB193_63:
mov	x0, x19
bl	LFQH_BottomHide178
mov	x0, x24
bl	LFQH_BottomHide178
LFQH_Lloh4264:
adr x0, LFQH_l_.str.24
LFQH_Lloh4265:
nop
bl Lpatch + (0xa5a4 - PATCH_BASE)
mov	x1, x0
mov	x0, x23
bl Lpatch + (0xa5d4 - PATCH_BASE)
fsub	d2, d2, d8
fmul	d2, d2, d11
fadd	d9, d0, d2
fsub	d0, d3, d8
fmul	d0, d0, d11
fadd	d10, d1, d0
LFQH_Lloh4266:
adr x0, LFQH_l_.str.372
LFQH_Lloh4267:
nop
bl Lpatch + (0xa5a4 - PATCH_BASE)
mov	x1, x0
mov	x0, x20
bl Lpatch + (0xa5d4 - PATCH_BASE)
fcmp	d0, d9
b.ne	LFQH_LBB193_67
fcmp	d1, d10
b.ne	LFQH_LBB193_67
fcmp	d2, d8
b.ne	LFQH_LBB193_67
fcmp	d3, d8
b.eq	LFQH_LBB193_68
LFQH_LBB193_67:
LFQH_Lloh4268:
adr x0, LFQH_l_.str.156
LFQH_Lloh4269:
nop
bl Lpatch + (0xa5a4 - PATCH_BASE)
mov	x1, x0
mov	x0, x20
fmov	d0, d9
fmov	d1, d10
fmov	d2, d8
fmov	d3, d8
bl Lpatch + (0xa5d4 - PATCH_BASE)
LFQH_LBB193_68:
LFQH_Lloh4270:
adr x0, LFQH_l_.str.47
LFQH_Lloh4271:
nop
bl Lpatch + (0xa5b0 - PATCH_BASE)
mov	x19, x0
LFQH_Lloh4272:
adr x0, LFQH_l_.str.48
LFQH_Lloh4273:
nop
bl Lpatch + (0xa5a4 - PATCH_BASE)
mov	x1, x0
mov	x0, x19
bl Lpatch + (0xa5d4 - PATCH_BASE)
mov	x19, x0
mov	x0, x20
LFQH_Lloh4274:
adr x1, LFQH_l_.str.141
LFQH_Lloh4275:
nop
bl	LFQH_Get
cmp	x0, x19
LFQH_Lloh4276:
adr x28, LFQH_l_.str.884
LFQH_Lloh4277:
nop
b.eq	LFQH_LBB193_71
mov	x24, x0
LFQH_Lloh4278:
adr x0, LFQH_l_.str.49
LFQH_Lloh4279:
nop
bl Lpatch + (0xa5a4 - PATCH_BASE)
mov	x1, x0
mov	x0, x24
mov	x2, x19
bl Lpatch + (0xa5d4 - PATCH_BASE)
cbnz	w0, LFQH_LBB193_71
LFQH_Lloh4280:
adr x0, LFQH_l_.str.54
LFQH_Lloh4281:
nop
bl Lpatch + (0xa5a4 - PATCH_BASE)
mov	x1, x0
mov	x0, x20
mov	x2, x19
bl Lpatch + (0xa5d4 - PATCH_BASE)
LFQH_LBB193_71:
cbz	x26, LFQH_LBB193_74
LFQH_Lloh4282:
adr x0, LFQH_l_.str.49
LFQH_Lloh4283:
nop
bl Lpatch + (0xa5a4 - PATCH_BASE)
mov	x19, x0
mov	x0, x23
LFQH_Lloh4284:
adr x1, LFQH_l_.str.471
LFQH_Lloh4285:
nop
bl	LFQH_Get
mov	x2, x0
mov	x0, x26
mov	x1, x19
bl Lpatch + (0xa5d4 - PATCH_BASE)
cbnz	w0, LFQH_LBB193_74
LFQH_Lloh4286:
adr x0, LFQH_l_.str.610
LFQH_Lloh4287:
nop
bl Lpatch + (0xa5a4 - PATCH_BASE)
mov	x1, x0
mov	x0, x23
mov	x2, x26
bl Lpatch + (0xa5d4 - PATCH_BASE)
LFQH_LBB193_74:
mov	x0, x23
LFQH_Lloh4288:
adr x1, LFQH_BottomTitles178R2Key
LFQH_Lloh4289:
nop
bl Lpatch + (0xa628 - PATCH_BASE)
mov	x19, x0
LFQH_Lloh4290:
adr x0, LFQH_l_.str.34
LFQH_Lloh4291:
nop
bl Lpatch + (0xa5a4 - PATCH_BASE)
mov	x1, x0
mov	x0, x19
bl Lpatch + (0xa5d4 - PATCH_BASE)
cmp	x0, #32
b.ne	LFQH_LBB193_79
LFQH_Lloh4292:
adr x22, LFQH_l_.str.883
LFQH_Lloh4293:
nop
mov	w21, #0
mov	x19, #0
LFQH_Lloh4294:
adr x25, LFQH_l_.str.885
LFQH_Lloh4295:
nop
LFQH_LBB193_76:
mov	x0, x28
bl Lpatch + (0xa5a4 - PATCH_BASE)
mov	x1, x0
mov	x0, x23
mov	x2, x19
bl Lpatch + (0xa5d4 - PATCH_BASE)
mov	x20, x0
mov	x0, x22
bl Lpatch + (0xa5a4 - PATCH_BASE)
mov	x1, x0
mov	x0, x23
mov	x2, x19
bl Lpatch + (0xa5d4 - PATCH_BASE)
mov	x24, x0
mov	x0, x20
mov	x1, x25
bl	LFQH_Equal
cmp	x24, #0
ccmp	w0, #0, #4, eq
csinc	w21, w21, wzr, ne
add	x19, x19, #1
cmp	x19, #16
b.ne	LFQH_LBB193_76
tst	w21, #0xff
ldr	x21, [sp, #56]
ldr	x25, [sp, #16]
b.eq	LFQH_LBB193_103
mov	x0, x23
bl	LFQH_BottomRestoreTitles178R2
LFQH_LBB193_79:
LFQH_Lloh4296:
adr x0, LFQH_l_.str.116
LFQH_Lloh4297:
nop
bl Lpatch + (0xa5b0 - PATCH_BASE)
mov	x19, x0
LFQH_Lloh4298:
adr x0, LFQH_l_.str.415
LFQH_Lloh4299:
nop
bl Lpatch + (0xa5a4 - PATCH_BASE)
mov	x1, x0
mov	x0, x19
bl Lpatch + (0xa5d4 - PATCH_BASE)
mov	x20, x0
LFQH_Lloh4300:
adr x0, LFQH_l_.str.476
LFQH_Lloh4301:
nop
bl Lpatch + (0xa5b0 - PATCH_BASE)
mov	x19, x0
LFQH_Lloh4302:
adr x0, LFQH_l_.str.922
LFQH_Lloh4303:
nop
bl Lpatch + (0xa5a4 - PATCH_BASE)
mov	x1, x0
mov	x0, x19
bl Lpatch + (0xa5d4 - PATCH_BASE)
mov	x24, x0
LFQH_Lloh4304:
adr x0, LFQH_l_.str.361
LFQH_Lloh4305:
nop
bl Lpatch + (0xa5b0 - PATCH_BASE)
mov	x19, x0
LFQH_Lloh4306:
adr x0, LFQH_l_.str.387
LFQH_Lloh4307:
nop
bl Lpatch + (0xa5a4 - PATCH_BASE)
mov	x1, x0
mov	x0, x19
LFQH_Lloh4308:
adr x2, LFQH_l_.str.885
LFQH_Lloh4309:
nop
bl Lpatch + (0xa5d4 - PATCH_BASE)
cbz	x20, LFQH_LBB193_103
cbz	x24, LFQH_LBB193_103
mov	x28, x0
cbz	x0, LFQH_LBB193_103
mov	x19, #0
LFQH_LBB193_83:
LFQH_Lloh4310:
adr x0, LFQH_l_.str.884
LFQH_Lloh4311:
nop
bl Lpatch + (0xa5a4 - PATCH_BASE)
mov	x1, x0
mov	x0, x23
mov	x2, x19
bl Lpatch + (0xa5d4 - PATCH_BASE)
mov	x21, x0
LFQH_Lloh4312:
adr x0, LFQH_l_.str.883
LFQH_Lloh4313:
nop
bl Lpatch + (0xa5a4 - PATCH_BASE)
mov	x1, x0
mov	x0, x23
mov	x2, x19
bl Lpatch + (0xa5d4 - PATCH_BASE)
mov	x25, x0
LFQH_Lloh4314:
adr x22, LFQH_l_.str.84
LFQH_Lloh4315:
nop
mov	x0, x22
bl Lpatch + (0xa5a4 - PATCH_BASE)
mov	x1, x0
cmp	x21, #0
csel	x2, x24, x21, eq
mov	x0, x20
bl Lpatch + (0xa5d4 - PATCH_BASE)
mov	x0, x22
bl Lpatch + (0xa5a4 - PATCH_BASE)
mov	x1, x0
cmp	x25, #0
csel	x2, x24, x25, eq
mov	x0, x20
bl Lpatch + (0xa5d4 - PATCH_BASE)
cbnz	x19, LFQH_LBB193_86
LFQH_Lloh4316:
adr x0, LFQH_l_.str.886
LFQH_Lloh4317:
nop
bl Lpatch + (0xa5a4 - PATCH_BASE)
mov	x1, x0
mov	x0, x23
mov	x2, #0
mov	x3, #0
bl Lpatch + (0xa5d4 - PATCH_BASE)
cbz	x25, LFQH_LBB193_86
LFQH_Lloh4318:
adr x0, LFQH_l_.str.887
LFQH_Lloh4319:
nop
bl Lpatch + (0xa5a4 - PATCH_BASE)
mov	x1, x0
mov	x0, x23
mov	x2, #0
mov	x3, #0
bl Lpatch + (0xa5d4 - PATCH_BASE)
LFQH_LBB193_86:
add	x19, x19, #1
cmp	x19, #16
b.ne	LFQH_LBB193_83
mov	x0, x23
LFQH_Lloh4320:
adr x1, LFQH_BottomTitles178R2Key
LFQH_Lloh4321:
nop
mov	x2, x20
mov	w3, #1
bl Lpatch + (0xa634 - PATCH_BASE)
cbz	x26, LFQH_LBB193_89
mov	x0, x23
LFQH_Lloh4322:
adr x1, LFQH_BottomTitleFallback178R2Key
LFQH_Lloh4323:
nop
mov	x2, x26
mov	w3, #1
bl Lpatch + (0xa634 - PATCH_BASE)
LFQH_LBB193_89:
mov	x19, #0
mov	w24, #1
ldr	x25, [sp, #16]
ldr	x21, [sp, #56]
LFQH_Lloh4324:
adr x22, LFQH_l_.str.887
LFQH_Lloh4325:
nop
LFQH_LBB193_90:
LFQH_Lloh4326:
adr x0, LFQH_l_.str.886
LFQH_Lloh4327:
nop
bl Lpatch + (0xa5a4 - PATCH_BASE)
mov	x1, x0
mov	x0, x23
mov	x2, x28
mov	x3, x19
bl Lpatch + (0xa5d4 - PATCH_BASE)
LFQH_Lloh4328:
adr x0, LFQH_l_.str.461
LFQH_Lloh4329:
nop
bl Lpatch + (0xa5a4 - PATCH_BASE)
mov	x1, x0
mov	x0, x20
mov	x2, x24
bl Lpatch + (0xa5d4 - PATCH_BASE)
LFQH_Lloh4330:
adr x1, LFQH_l_.str.476
LFQH_Lloh4331:
nop
bl	LFQH_Kind
cbnz	w0, LFQH_LBB193_92
mov	x0, x22
bl Lpatch + (0xa5a4 - PATCH_BASE)
mov	x1, x0
mov	x0, x23
mov	x2, #0
mov	x3, x19
bl Lpatch + (0xa5d4 - PATCH_BASE)
LFQH_LBB193_92:
add	x19, x19, #1
add	x24, x24, #2
cmp	x19, #16
b.ne	LFQH_LBB193_90
b	LFQH_LBB193_103
LFQH_LBB193_93:
mov	x0, x26
LFQH_Lloh4332:
adr x1, LFQH_l_.str.911
LFQH_Lloh4333:
nop
bl	LFQH_Equal
cbz	w0, LFQH_LBB193_95
cmp	w19, #0
LFQH_Lloh4334:
adr x8, LFQH_l_.str.912
LFQH_Lloh4335:
nop
LFQH_Lloh4336:
adr x9, LFQH_l_.str.913
LFQH_Lloh4337:
nop
b	LFQH_LBB193_44
LFQH_LBB193_95:
mov	x0, x26
LFQH_Lloh4338:
adr x1, LFQH_l_.str.914
LFQH_Lloh4339:
nop
bl	LFQH_Equal
cbz	w0, LFQH_LBB193_97
cmp	w19, #0
LFQH_Lloh4340:
adr x8, LFQH_l_.str.915
LFQH_Lloh4341:
nop
LFQH_Lloh4342:
adr x9, LFQH_l_.str.916
LFQH_Lloh4343:
nop
b	LFQH_LBB193_44
LFQH_LBB193_97:
mov	x0, x26
LFQH_Lloh4344:
adr x1, LFQH_l_.str.597
LFQH_Lloh4345:
nop
bl	LFQH_Equal
cbz	w0, LFQH_LBB193_99
cmp	w19, #0
LFQH_Lloh4346:
adr x8, LFQH_l_.str.917
LFQH_Lloh4347:
nop
LFQH_Lloh4348:
adr x9, LFQH_l_.str.918
LFQH_Lloh4349:
nop
b	LFQH_LBB193_44
LFQH_LBB193_99:
mov	x0, x26
LFQH_Lloh4350:
adr x1, LFQH_l_.str.919
LFQH_Lloh4351:
nop
bl	LFQH_Equal
cbz	w0, LFQH_LBB193_101
cmp	w19, #0
LFQH_Lloh4352:
adr x8, LFQH_l_.str.920
LFQH_Lloh4353:
nop
LFQH_Lloh4354:
adr x9, LFQH_l_.str.921
LFQH_Lloh4355:
nop
b	LFQH_LBB193_44
LFQH_LBB193_101:
mov	x0, x23
LFQH_Lloh4356:
adr x1, LFQH_BottomSymbol178Key
LFQH_Lloh4357:
nop
bl Lpatch + (0xa628 - PATCH_BASE)
mov	x20, x0
mov	x0, x23
LFQH_Lloh4358:
adr x1, LFQH_l_.str.896
LFQH_Lloh4359:
nop
bl	LFQH_Get
mov	x28, x0
mov	w21, #1
cbnz	x28, LFQH_LBB193_45
LFQH_LBB193_102:
mov	x0, x23
bl	LFQH_BottomRestoreSymbol178
ldr	x21, [sp, #56]
LFQH_LBB193_103:
add	x27, x27, #1
ldp	x20, x8, [sp, #64]
cmp	x27, x8
b.ne	LFQH_LBB193_23
LFQH_LBB193_104:
ldr	x26, [sp, #24]
ldr	w23, [sp, #12]
tbnz	w23, #0, LFQH_LBB193_109
mov	w0, #11
bl	LFQH_BottomValue178
mov	x8, #4636737291354636288
fmov	d1, x8
fcmp	d0, d1
b.ne	LFQH_LBB193_109
mov	w0, #12
bl	LFQH_BottomValue178
mov	x8, #4636737291354636288
fmov	d1, x8
fcmp	d0, d1
b.ne	LFQH_LBB193_109
mov	w0, #13
bl	LFQH_BottomValue178
mov	x8, #4636737291354636288
fmov	d1, x8
fcmp	d0, d1
b.ne	LFQH_LBB193_109
mov	w0, #2
bl	LFQH_BottomFlag178
cbz	w0, LFQH_LBB193_3
LFQH_LBB193_109:
LFQH_Lloh4360:
adr x0, LFQH_l_.str.88
LFQH_Lloh4361:
nop
bl Lpatch + (0xa5b0 - PATCH_BASE)
mov	x19, x0
LFQH_Lloh4362:
adr x0, LFQH_l_.str.89
LFQH_Lloh4363:
nop
bl Lpatch + (0xa5a4 - PATCH_BASE)
mov	x1, x0
mov	x0, x19
bl Lpatch + (0xa5d4 - PATCH_BASE)
mov	x20, x0
LFQH_Lloh4364:
adr x19, LFQH_l_.str.497
LFQH_Lloh4365:
nop
mov	x0, x19
bl Lpatch + (0xa5b0 - PATCH_BASE)
mov	x21, x0
LFQH_Lloh4366:
adr x22, LFQH_l_.str.499
LFQH_Lloh4367:
nop
mov	x0, x22
bl Lpatch + (0xa5a4 - PATCH_BASE)
mov	x1, x0
mov	x0, x21
ldr	w2, [sp, #52]
bl Lpatch + (0xa5d4 - PATCH_BASE)
mov	x2, x0
LFQH_Lloh4368:
adr x1, LFQH_l_.str.367
LFQH_Lloh4369:
nop
mov	x0, x20
bl	LFQH_Put
mov	w0, #2
bl	LFQH_BottomFlag178
mov	x21, x0
mov	x0, x19
bl Lpatch + (0xa5b0 - PATCH_BASE)
mov	x19, x0
mov	x0, x22
bl Lpatch + (0xa5a4 - PATCH_BASE)
mov	x1, x0
mov	x0, x19
mov	x2, x21
bl Lpatch + (0xa5d4 - PATCH_BASE)
mov	x2, x0
LFQH_Lloh4370:
adr x1, LFQH_l_.str.368
LFQH_Lloh4371:
nop
mov	x0, x20
bl	LFQH_Put
cbz	w23, LFQH_LBB193_111
LFQH_Lloh4372:
adr x0, LFQH_l_.str.361
LFQH_Lloh4373:
nop
bl Lpatch + (0xa5b0 - PATCH_BASE)
mov	x19, x0
LFQH_Lloh4374:
adr x0, LFQH_l_.str.387
LFQH_Lloh4375:
nop
bl Lpatch + (0xa5a4 - PATCH_BASE)
mov	x1, x0
LFQH_Lloh4376:
adr x2, LFQH_l_.str.370
LFQH_Lloh4377:
nop
mov	x0, x19
bl Lpatch + (0xa5d4 - PATCH_BASE)
mov	x2, x0
LFQH_Lloh4378:
adr x1, LFQH_l_.str.369
LFQH_Lloh4379:
nop
mov	x0, x20
bl	LFQH_Put
LFQH_LBB193_111:
LFQH_Lloh4380:
adr x1, LFQH_BottomCompact178Key
LFQH_Lloh4381:
nop
ldr	x24, [sp, #56]
mov	x0, x24
bl Lpatch + (0xa628 - PATCH_BASE)
LFQH_Lloh4382:
adr x1, LFQH_l_.str.41
LFQH_Lloh4383:
nop
bl	LFQH_BoolProp
mov	x19, x0
LFQH_Lloh4384:
adr x21, LFQH_l_.str.497
LFQH_Lloh4385:
nop
mov	x0, x21
bl Lpatch + (0xa5b0 - PATCH_BASE)
mov	x23, x0
mov	x0, x22
bl Lpatch + (0xa5a4 - PATCH_BASE)
mov	x1, x0
mov	x0, x23
mov	x2, x19
bl Lpatch + (0xa5d4 - PATCH_BASE)
mov	x2, x0
LFQH_Lloh4386:
adr x1, LFQH_l_.str.371
LFQH_Lloh4387:
nop
mov	x0, x20
bl	LFQH_Put
LFQH_Lloh4388:
adr x19, LFQH_l_.str.372
LFQH_Lloh4389:
nop
mov	x0, x19
bl Lpatch + (0xa5a4 - PATCH_BASE)
mov	x1, x0
mov	x0, x25
bl Lpatch + (0xa5d4 - PATCH_BASE)
bl	LFQH_RectArray
mov	x2, x0
mov	x0, x20
mov	x1, x19
bl	LFQH_Put
mov	x0, x21
bl Lpatch + (0xa5b0 - PATCH_BASE)
mov	x19, x0
LFQH_Lloh4390:
adr x23, LFQH_l_.str.515
LFQH_Lloh4391:
nop
mov	x0, x23
bl Lpatch + (0xa5a4 - PATCH_BASE)
mov	x1, x0
mov	x0, x19
fmov	d0, d8
bl Lpatch + (0xa5d4 - PATCH_BASE)
mov	x2, x0
LFQH_Lloh4392:
adr x1, LFQH_l_.str.373
LFQH_Lloh4393:
nop
mov	x0, x20
bl	LFQH_Put
mov	w0, #13
bl	LFQH_BottomValue178
fmov	d8, d0
mov	x0, x21
bl Lpatch + (0xa5b0 - PATCH_BASE)
mov	x19, x0
mov	x0, x23
bl Lpatch + (0xa5a4 - PATCH_BASE)
mov	x1, x0
mov	x0, x19
fmov	d0, d8
bl Lpatch + (0xa5d4 - PATCH_BASE)
mov	x2, x0
LFQH_Lloh4394:
adr x1, LFQH_l_.str.374
LFQH_Lloh4395:
nop
mov	x0, x20
bl	LFQH_Put
LFQH_Lloh4396:
adr x8, LFQH_l_.str.376
LFQH_Lloh4397:
nop
LFQH_Lloh4398:
adr x9, LFQH_l_.str.377
LFQH_Lloh4399:
nop
cmp	x26, #0
csel	x19, x9, x8, eq
LFQH_Lloh4400:
adr x0, LFQH_l_.str.361
LFQH_Lloh4401:
nop
bl Lpatch + (0xa5b0 - PATCH_BASE)
mov	x23, x0
LFQH_Lloh4402:
adr x0, LFQH_l_.str.387
LFQH_Lloh4403:
nop
bl Lpatch + (0xa5a4 - PATCH_BASE)
mov	x1, x0
mov	x0, x23
mov	x2, x19
bl Lpatch + (0xa5d4 - PATCH_BASE)
mov	x2, x0
LFQH_Lloh4404:
adr x1, LFQH_l_.str.375
LFQH_Lloh4405:
nop
mov	x0, x20
bl	LFQH_Put
LFQH_Lloh4406:
adr x1, LFQH_BottomObserver178Key
LFQH_Lloh4407:
nop
mov	x0, x24
bl Lpatch + (0xa628 - PATCH_BASE)
LFQH_Lloh4408:
adr x1, LFQH_BottomPanBox178Key
LFQH_Lloh4409:
nop
bl Lpatch + (0xa628 - PATCH_BASE)
LFQH_Lloh4410:
adr x1, LFQH_l_.str.81
LFQH_Lloh4411:
nop
bl	LFQH_Get
cmp	x0, #0
cset	w19, ne
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
LFQH_Lloh4412:
adr x1, LFQH_l_.str.378
LFQH_Lloh4413:
nop
mov	x0, x20
bl	LFQH_Put
LFQH_Lloh4414:
adr x1, LFQH_BottomLayoutLog178Key
LFQH_Lloh4415:
nop
mov	x0, x25
bl Lpatch + (0xa628 - PATCH_BASE)
cbz	x0, LFQH_LBB193_113
mov	x19, x0
LFQH_Lloh4416:
adr x0, LFQH_l_.str.49
LFQH_Lloh4417:
nop
bl Lpatch + (0xa5a4 - PATCH_BASE)
mov	x1, x0
mov	x0, x19
mov	x2, x20
bl Lpatch + (0xa5d4 - PATCH_BASE)
cbnz	w0, LFQH_LBB193_3
LFQH_LBB193_113:
LFQH_Lloh4418:
adr x0, LFQH_l_.str.379
LFQH_Lloh4419:
nop
mov	x1, x20
bl Lrecord_named
LFQH_Lloh4420:
adr x1, LFQH_BottomLayoutLog178Key
LFQH_Lloh4421:
nop
mov	x0, x25
mov	x2, x20
mov	w3, #1
ldp	x29, x30, [sp, #192]
ldp	x20, x19, [sp, #176]
ldp	x22, x21, [sp, #160]
ldp	x24, x23, [sp, #144]
ldp	x26, x25, [sp, #128]
ldp	x28, x27, [sp, #112]
ldp	d9, d8, [sp, #96]
ldp	d11, d10, [sp, #80]
add	sp, sp, #208
b Lpatch + (0xa634 - PATCH_BASE)
.cfi_endproc
.p2align	2
LFQH_BottomObserver178Key:
.cfi_startproc
ret
.cfi_endproc
.p2align	2
LFQH_BottomLayoutLog178Key:
.cfi_startproc
ret
.cfi_endproc
.p2align	2
LFQH_BottomDetachPan178:
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
LFQH_Lloh4422:
adr x1, LFQH_BottomObserver178Key
LFQH_Lloh4423:
nop
bl Lpatch + (0xa628 - PATCH_BASE)
mov	x20, x0
LFQH_Lloh4424:
adr x1, LFQH_BottomPanBox178Key
LFQH_Lloh4425:
nop
bl Lpatch + (0xa628 - PATCH_BASE)
LFQH_Lloh4426:
adr x1, LFQH_l_.str.81
LFQH_Lloh4427:
nop
bl	LFQH_Get
cbz	x0, LFQH_LBB196_2
mov	x21, x0
LFQH_Lloh4428:
adr x0, LFQH_l_.str.923
LFQH_Lloh4429:
nop
bl Lpatch + (0xa5a4 - PATCH_BASE)
mov	x22, x0
LFQH_Lloh4430:
adr x0, LFQH_l_.str.890
LFQH_Lloh4431:
nop
bl Lpatch + (0xa5a4 - PATCH_BASE)
mov	x3, x0
mov	x0, x21
mov	x1, x22
mov	x2, x20
bl Lpatch + (0xa5d4 - PATCH_BASE)
LFQH_LBB196_2:
LFQH_Lloh4432:
adr x1, LFQH_BottomPanActive178Key
LFQH_Lloh4433:
nop
mov	x0, x20
mov	x2, #0
mov	w3, #1
bl Lpatch + (0xa634 - PATCH_BASE)
LFQH_Lloh4434:
adr x1, LFQH_BottomPanVertical178Key
LFQH_Lloh4435:
nop
mov	x0, x20
mov	x2, #0
mov	w3, #1
bl Lpatch + (0xa634 - PATCH_BASE)
LFQH_Lloh4436:
adr x1, LFQH_BottomPanBox178Key
LFQH_Lloh4437:
nop
mov	x0, x20
mov	x2, #0
mov	w3, #1
bl Lpatch + (0xa634 - PATCH_BASE)
LFQH_Lloh4438:
adr x1, LFQH_BottomObserver178Key
LFQH_Lloh4439:
nop
mov	x0, x19
mov	x2, #0
mov	w3, #1
bl Lpatch + (0xa634 - PATCH_BASE)
mov	x0, x19
mov	w1, #0
ldp	x29, x30, [sp, #32]
ldp	x20, x19, [sp, #16]
ldp	x22, x21, [sp], #48
b	LFQH_BottomSetCompact178
.cfi_endproc
.p2align	2
LFQH_FQHBottomOptionChanged178:
.cfi_startproc
stp	d9, d8, [sp, #-96]!
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
.cfi_offset b8, -88
.cfi_offset b9, -96
mov	x19, x2
LFQH_Lloh4440:
adr x0, LFQH_l_.str.380
LFQH_Lloh4441:
nop
bl Lpatch + (0xa5a4 - PATCH_BASE)
mov	x1, x0
mov	x0, x19
bl Lpatch + (0xa5d4 - PATCH_BASE)
mov	x20, x0
bl	LFQH_BottomPreference178
cbz	x0, LFQH_LBB197_4
mov	x21, x0
sub	x8, x20, #1
cmp	x8, #1
b.hi	LFQH_LBB197_3
LFQH_Lloh4442:
adr x1, LFQH_l_.str.381
LFQH_Lloh4443:
nop
mov	x0, x19
bl	LFQH_BoolProp
mov	x1, x0
mov	x0, x21
bl	LFQH_SetDefault
b	LFQH_LBB197_6
LFQH_LBB197_3:
LFQH_Lloh4444:
adr x0, LFQH_l_.str.382
LFQH_Lloh4445:
nop
bl Lpatch + (0xa5a4 - PATCH_BASE)
mov	x1, x0
mov	x0, x19
bl Lpatch + (0xa5d4 - PATCH_BASE)
fmov	w8, s0
and	w8, w8, #0x7fffffff
mov	w9, #2139095039
cmp	w8, w9
b.le	LFQH_LBB197_5
LFQH_LBB197_4:
ldp	x29, x30, [sp, #80]
ldp	x20, x19, [sp, #64]
ldp	x22, x21, [sp, #48]
ldp	x24, x23, [sp, #32]
ldp	x26, x25, [sp, #16]
ldp	d9, d8, [sp], #96
ret
LFQH_LBB197_5:
fcvt	d0, s0
fmov	d1, #0.50000000
fadd	d0, d0, d1
fcvtzs	d0, d0
scvtf	d8, d0
LFQH_Lloh4446:
adr x22, LFQH_l_.str.467
LFQH_Lloh4447:
nop
mov	x0, x22
bl Lpatch + (0xa5b0 - PATCH_BASE)
mov	x23, x0
LFQH_Lloh4448:
adr x24, LFQH_l_.str.468
LFQH_Lloh4449:
nop
mov	x0, x24
bl Lpatch + (0xa5a4 - PATCH_BASE)
mov	x1, x0
mov	x0, x23
bl Lpatch + (0xa5d4 - PATCH_BASE)
mov	x23, x0
LFQH_Lloh4450:
adr x25, LFQH_l_.str.383
LFQH_Lloh4451:
nop
mov	x0, x25
bl Lpatch + (0xa5a4 - PATCH_BASE)
mov	x1, x0
mov	x0, x23
fmov	d0, d8
mov	x2, x21
bl Lpatch + (0xa5d4 - PATCH_BASE)
mov	x0, x20
bl	LFQH_BottomValue178
fmov	d8, d0
mov	x0, x22
bl Lpatch + (0xa5b0 - PATCH_BASE)
mov	x22, x0
mov	x0, x24
bl Lpatch + (0xa5a4 - PATCH_BASE)
mov	x1, x0
mov	x0, x22
bl Lpatch + (0xa5d4 - PATCH_BASE)
mov	x22, x0
mov	x0, x25
bl Lpatch + (0xa5a4 - PATCH_BASE)
mov	x1, x0
mov	x0, x22
fmov	d0, d8
mov	x2, x21
bl Lpatch + (0xa5d4 - PATCH_BASE)
LFQH_Lloh4452:
adr x1, LFQH_BottomOptionValue178Key
LFQH_Lloh4453:
nop
mov	x0, x19
bl Lpatch + (0xa628 - PATCH_BASE)
mov	x19, x0
LFQH_Lloh4454:
adr x0, LFQH_l_.str.159
LFQH_Lloh4455:
nop
bl Lpatch + (0xa5a4 - PATCH_BASE)
mov	x21, x0
mov	x0, x20
bl	LFQH_BottomValueText178
mov	x2, x0
mov	x0, x19
mov	x1, x21
bl Lpatch + (0xa5d4 - PATCH_BASE)
LFQH_LBB197_6:
ldp	x29, x30, [sp, #80]
ldp	x20, x19, [sp, #64]
ldp	x22, x21, [sp, #48]
ldp	x24, x23, [sp, #32]
ldp	x26, x25, [sp, #16]
ldp	d9, d8, [sp], #96
b	LFQH_BottomRefresh178
.cfi_endproc
.p2align	2
LFQH_BottomPreference178:
.cfi_startproc
stp	x20, x19, [sp, #-32]!
stp	x29, x30, [sp, #16]
add	x29, sp, #16
.cfi_def_cfa w29, 16
.cfi_offset w30, -8
.cfi_offset w29, -16
.cfi_offset w19, -24
.cfi_offset w20, -32
cmp	x0, #11
b.gt	LFQH_LBB198_5
cmp	x0, #1
b.eq	LFQH_LBB198_9
cmp	x0, #2
b.eq	LFQH_LBB198_12
cmp	x0, #11
b.ne	LFQH_LBB198_11
LFQH_Lloh4456:
adr x19, LFQH_l_.str.926
LFQH_Lloh4457:
nop
b	LFQH_LBB198_14
LFQH_LBB198_5:
cmp	x0, #12
b.eq	LFQH_LBB198_10
cmp	x0, #13
b.eq	LFQH_LBB198_13
cmp	x0, #14
b.ne	LFQH_LBB198_11
LFQH_Lloh4458:
adr x19, LFQH_l_.str.929
LFQH_Lloh4459:
nop
b	LFQH_LBB198_14
LFQH_LBB198_9:
LFQH_Lloh4460:
adr x19, LFQH_l_.str.924
LFQH_Lloh4461:
nop
b	LFQH_LBB198_14
LFQH_LBB198_10:
LFQH_Lloh4462:
adr x19, LFQH_l_.str.927
LFQH_Lloh4463:
nop
b	LFQH_LBB198_14
LFQH_LBB198_11:
mov	x0, #0
ldp	x29, x30, [sp, #16]
ldp	x20, x19, [sp], #32
ret
LFQH_LBB198_12:
LFQH_Lloh4464:
adr x19, LFQH_l_.str.925
LFQH_Lloh4465:
nop
b	LFQH_LBB198_14
LFQH_LBB198_13:
LFQH_Lloh4466:
adr x19, LFQH_l_.str.928
LFQH_Lloh4467:
nop
LFQH_LBB198_14:
LFQH_Lloh4468:
adr x0, LFQH_l_.str.361
LFQH_Lloh4469:
nop
bl Lpatch + (0xa5b0 - PATCH_BASE)
mov	x20, x0
LFQH_Lloh4470:
adr x0, LFQH_l_.str.387
LFQH_Lloh4471:
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
LFQH_Lloh4472:
adr x0, LFQH_l_.str.467
LFQH_Lloh4473:
nop
bl Lpatch + (0xa5b0 - PATCH_BASE)
mov	x21, x0
LFQH_Lloh4474:
adr x0, LFQH_l_.str.468
LFQH_Lloh4475:
nop
bl Lpatch + (0xa5a4 - PATCH_BASE)
mov	x1, x0
mov	x0, x21
bl Lpatch + (0xa5d4 - PATCH_BASE)
mov	x21, x0
LFQH_Lloh4476:
adr x0, LFQH_l_.str.930
LFQH_Lloh4477:
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
LFQH_BottomOptionValue178Key:
.cfi_startproc
ret
.cfi_endproc
.p2align	2
LFQH_BottomValueText178:
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
bl	LFQH_BottomValue178
fmov	d8, d0
LFQH_Lloh4478:
adr x0, LFQH_l_.str.497
LFQH_Lloh4479:
nop
bl Lpatch + (0xa5b0 - PATCH_BASE)
mov	x20, x0
LFQH_Lloh4480:
adr x0, LFQH_l_.str.515
LFQH_Lloh4481:
nop
bl Lpatch + (0xa5a4 - PATCH_BASE)
mov	x1, x0
mov	x0, x20
fmov	d0, d8
bl Lpatch + (0xa5d4 - PATCH_BASE)
LFQH_Lloh4482:
adr x1, LFQH_l_.str.931
LFQH_Lloh4483:
nop
bl	LFQH_Get
mov	x20, x0
LFQH_Lloh4484:
adr x0, LFQH_l_.str.932
LFQH_Lloh4485:
nop
bl Lpatch + (0xa5a4 - PATCH_BASE)
mov	x21, x0
LFQH_Lloh4486:
adr x8, LFQH_l_.str.934
LFQH_Lloh4487:
nop
LFQH_Lloh4488:
adr x9, LFQH_l_.str.933
LFQH_Lloh4489:
nop
cmp	x19, #14
csel	x19, x9, x8, eq
LFQH_Lloh4490:
adr x0, LFQH_l_.str.361
LFQH_Lloh4491:
nop
bl Lpatch + (0xa5b0 - PATCH_BASE)
mov	x22, x0
LFQH_Lloh4492:
adr x0, LFQH_l_.str.387
LFQH_Lloh4493:
nop
bl Lpatch + (0xa5a4 - PATCH_BASE)
mov	x1, x0
mov	x0, x22
mov	x2, x19
bl Lpatch + (0xa5d4 - PATCH_BASE)
mov	x2, x0
mov	x0, x20
mov	x1, x21
ldp	x29, x30, [sp, #48]
ldp	x20, x19, [sp, #32]
ldp	x22, x21, [sp, #16]
ldp	d9, d8, [sp], #64
b Lpatch + (0xa5d4 - PATCH_BASE)
.cfi_endproc
.p2align	2
LFQH_BottomRefresh178:
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
bl	LFQH_BottomBars178
LFQH_Lloh4494:
adr x1, LFQH_l_.str.475
LFQH_Lloh4495:
nop
bl	LFQH_Get
mov	x19, x0
LFQH_Lloh4496:
adr x0, LFQH_l_.str.34
LFQH_Lloh4497:
nop
bl Lpatch + (0xa5a4 - PATCH_BASE)
mov	x1, x0
mov	x0, x19
bl Lpatch + (0xa5d4 - PATCH_BASE)
cbz	x0, LFQH_LBB202_7
mov	x20, x0
mov	x21, #0
LFQH_Lloh4498:
adr x22, LFQH_l_.str.461
LFQH_Lloh4499:
nop
LFQH_Lloh4500:
adr x23, LFQH_l_.str.356
LFQH_Lloh4501:
nop
LFQH_Lloh4502:
adr x24, LFQH_l_.str.74
LFQH_Lloh4503:
nop
LFQH_Lloh4504:
adr x25, LFQH_l_.str.357
LFQH_Lloh4505:
nop
LFQH_LBB202_2:
mov	x0, x22
bl Lpatch + (0xa5a4 - PATCH_BASE)
mov	x1, x0
mov	x0, x19
mov	x2, x21
bl Lpatch + (0xa5d4 - PATCH_BASE)
mov	x26, x0
mov	w0, #2
bl	LFQH_BottomFlag178
cbnz	w0, LFQH_LBB202_4
mov	x0, x26
bl	LFQH_BottomDetachPan178
LFQH_LBB202_4:
mov	x0, x23
bl Lpatch + (0xa5a4 - PATCH_BASE)
mov	x1, x0
mov	x0, x26
bl Lpatch + (0xa5d4 - PATCH_BASE)
mov	x0, x26
mov	x1, x24
bl	LFQH_Get
cbz	x0, LFQH_LBB202_6
mov	x0, x25
bl Lpatch + (0xa5a4 - PATCH_BASE)
mov	x1, x0
mov	x0, x26
bl Lpatch + (0xa5d4 - PATCH_BASE)
LFQH_LBB202_6:
add	x21, x21, #1
cmp	x20, x21
b.ne	LFQH_LBB202_2
LFQH_LBB202_7:
ldp	x29, x30, [sp, #64]
ldp	x20, x19, [sp, #48]
ldp	x22, x21, [sp, #32]
ldp	x24, x23, [sp, #16]
ldp	x26, x25, [sp], #80
ret
.cfi_endproc
.p2align	2
LFQH_FQHBottomOptionsReset178:
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
LFQH_Lloh4506:
adr x0, LFQH_l_.str.467
LFQH_Lloh4507:
nop
bl Lpatch + (0xa5b0 - PATCH_BASE)
mov	x20, x0
LFQH_Lloh4508:
adr x0, LFQH_l_.str.468
LFQH_Lloh4509:
nop
bl Lpatch + (0xa5a4 - PATCH_BASE)
mov	x1, x0
mov	x0, x20
bl Lpatch + (0xa5d4 - PATCH_BASE)
mov	x20, x0
mov	w21, #1
LFQH_Lloh4510:
adr x22, LFQH_l_.str.384
LFQH_Lloh4511:
nop
LFQH_LBB203_1:
mov	x0, x21
bl	LFQH_BottomPreference178
cbz	x0, LFQH_LBB203_3
mov	x23, x0
mov	x0, x22
bl Lpatch + (0xa5a4 - PATCH_BASE)
mov	x1, x0
mov	x0, x20
mov	x2, x23
bl Lpatch + (0xa5d4 - PATCH_BASE)
LFQH_LBB203_3:
add	x21, x21, #1
cmp	x21, #15
b.ne	LFQH_LBB203_1
LFQH_Lloh4512:
adr x1, LFQH_BottomSettingViews178Key
LFQH_Lloh4513:
nop
mov	x0, x19
bl Lpatch + (0xa628 - PATCH_BASE)
mov	x19, x0
LFQH_Lloh4514:
adr x0, LFQH_l_.str.34
LFQH_Lloh4515:
nop
bl Lpatch + (0xa5a4 - PATCH_BASE)
mov	x1, x0
mov	x0, x19
bl Lpatch + (0xa5d4 - PATCH_BASE)
cbz	x0, LFQH_LBB203_10
mov	x20, x0
mov	x21, #0
LFQH_Lloh4516:
adr x22, LFQH_l_.str.461
LFQH_Lloh4517:
nop
LFQH_Lloh4518:
adr x23, LFQH_l_.str.380
LFQH_Lloh4519:
nop
LFQH_Lloh4520:
adr x26, LFQH_BottomOptionValue178Key
LFQH_Lloh4521:
nop
LFQH_Lloh4522:
adr x27, LFQH_l_.str.159
LFQH_Lloh4523:
nop
LFQH_LBB203_6:
mov	x0, x22
bl Lpatch + (0xa5a4 - PATCH_BASE)
mov	x1, x0
mov	x0, x19
mov	x2, x21
bl Lpatch + (0xa5d4 - PATCH_BASE)
mov	x28, x0
mov	x0, x23
bl Lpatch + (0xa5a4 - PATCH_BASE)
mov	x1, x0
mov	x0, x28
bl Lpatch + (0xa5d4 - PATCH_BASE)
cmp	x0, #9
b.gt	LFQH_LBB203_8
LFQH_Lloh4524:
adr x0, LFQH_l_.str.385
LFQH_Lloh4525:
nop
bl Lpatch + (0xa5a4 - PATCH_BASE)
mov	x1, x0
mov	x0, x28
mov	w2, #0
mov	w3, #1
bl Lpatch + (0xa5d4 - PATCH_BASE)
b	LFQH_LBB203_9
LFQH_LBB203_8:
mov	x24, x0
LFQH_Lloh4526:
adr x0, LFQH_l_.str.386
LFQH_Lloh4527:
nop
bl Lpatch + (0xa5a4 - PATCH_BASE)
mov	x25, x0
mov	x0, x24
bl	LFQH_BottomValue178
fcvt	s0, d0
mov	x0, x28
mov	x1, x25
mov	w2, #1
bl Lpatch + (0xa5d4 - PATCH_BASE)
mov	x0, x28
mov	x1, x26
bl Lpatch + (0xa628 - PATCH_BASE)
mov	x25, x0
mov	x0, x27
bl Lpatch + (0xa5a4 - PATCH_BASE)
mov	x28, x0
mov	x0, x24
bl	LFQH_BottomValueText178
mov	x2, x0
mov	x0, x25
mov	x1, x28
bl Lpatch + (0xa5d4 - PATCH_BASE)
LFQH_LBB203_9:
add	x21, x21, #1
cmp	x20, x21
b.ne	LFQH_LBB203_6
LFQH_LBB203_10:
ldp	x29, x30, [sp, #80]
ldp	x20, x19, [sp, #64]
ldp	x22, x21, [sp, #48]
ldp	x24, x23, [sp, #32]
ldp	x26, x25, [sp, #16]
ldp	x28, x27, [sp], #96
b	LFQH_BottomRefresh178
.cfi_endproc
.p2align	2
LFQH_BottomSettingViews178Key:
.cfi_startproc
ret
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
cbz	x0, LFQH_LBB205_9
bl Lpatch + (0xa5ec - PATCH_BASE)
cbz	x0, LFQH_LBB205_9
ldrb	w9, [x19]
cbz	w9, LFQH_LBB205_6
add	x8, x19, #1
LFQH_LBB205_4:
ldrb	w10, [x0]
cmp	w10, w9
b.ne	LFQH_LBB205_7
add	x0, x0, #1
ldrb	w9, [x8], #1
cbnz	w9, LFQH_LBB205_4
LFQH_LBB205_6:
mov	w8, #0
ldrb	w10, [x0]
b	LFQH_LBB205_8
LFQH_LBB205_7:
mov	w8, #1
LFQH_LBB205_8:
orr	w8, w10, w8
cmp	w8, #0
cset	w0, eq
LFQH_LBB205_9:
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
LFQH_Lloh4528:
adr x0, LFQH_l_.str.12
LFQH_Lloh4529:
nop
bl Lpatch + (0xa5b0 - PATCH_BASE)
mov	x19, x0
LFQH_Lloh4530:
adr x0, LFQH_l_.str.13
LFQH_Lloh4531:
nop
bl Lpatch + (0xa5a4 - PATCH_BASE)
mov	x1, x0
mov	x0, x19
mov	x2, #0
bl Lpatch + (0xa5d4 - PATCH_BASE)
mov	x19, x0
cbz	x0, LFQH_LBB207_3
LFQH_Lloh4532:
adr x0, LFQH_l_.str.18
LFQH_Lloh4533:
nop
bl Lpatch + (0xa5a4 - PATCH_BASE)
mov	x1, x0
mov	x0, x19
mov	w2, #1
bl Lpatch + (0xa5d4 - PATCH_BASE)
LFQH_Lloh4534:
adr x0, LFQH_l_.str.16
LFQH_Lloh4535:
nop
bl Lpatch + (0xa5b0 - PATCH_BASE)
mov	x20, x0
LFQH_Lloh4536:
adr x0, LFQH_l_.str.154
LFQH_Lloh4537:
nop
bl Lpatch + (0xa5a4 - PATCH_BASE)
mov	x1, x0
mov	x0, x20
bl Lpatch + (0xa5d4 - PATCH_BASE)
mov	x20, x0
LFQH_Lloh4538:
adr x0, LFQH_l_.str.398
LFQH_Lloh4539:
nop
bl Lpatch + (0xa5a4 - PATCH_BASE)
mov	x1, x0
mov	x0, x20
mov	x2, x19
bl Lpatch + (0xa5d4 - PATCH_BASE)
mov	x19, x0
cbz	x0, LFQH_LBB207_3
LFQH_Lloh4540:
adr x0, LFQH_l_.str.17
LFQH_Lloh4541:
nop
bl Lpatch + (0xa5a4 - PATCH_BASE)
mov	x20, x0
LFQH_Lloh4542:
adr x0, LFQH_l_.str.14
LFQH_Lloh4543:
nop
bl Lpatch + (0xa5b0 - PATCH_BASE)
mov	x21, x0
LFQH_Lloh4544:
adr x0, LFQH_l_.str.15
LFQH_Lloh4545:
nop
bl Lpatch + (0xa5a4 - PATCH_BASE)
mov	x1, x0
mov	x0, x21
bl Lpatch + (0xa5d4 - PATCH_BASE)
mov	x2, x0
mov	x0, x19
mov	x1, x20
bl Lpatch + (0xa5d4 - PATCH_BASE)
LFQH_Lloh4546:
adr x0, LFQH_l_.str.399
LFQH_Lloh4547:
nop
bl Lpatch + (0xa5a4 - PATCH_BASE)
mov	x1, x0
mov	x0, x19
mov	w2, #0
bl Lpatch + (0xa5d4 - PATCH_BASE)
LFQH_Lloh4548:
adr x0, LFQH_l_.str.400
LFQH_Lloh4549:
nop
bl Lpatch + (0xa5a4 - PATCH_BASE)
mov	x1, x0
mov	x0, x19
mov	w2, #1
bl Lpatch + (0xa5d4 - PATCH_BASE)
LFQH_Lloh4550:
adr x0, LFQH_l_.str.401
LFQH_Lloh4551:
nop
bl Lpatch + (0xa5a4 - PATCH_BASE)
mov	x1, x0
mov	x0, x19
mov	w2, #0
bl Lpatch + (0xa5d4 - PATCH_BASE)
LFQH_Lloh4552:
adr x0, LFQH_l_.str.402
LFQH_Lloh4553:
nop
bl Lpatch + (0xa5a4 - PATCH_BASE)
mov	x1, x0
mov	x0, x19
mov	w2, #0
bl Lpatch + (0xa5d4 - PATCH_BASE)
LFQH_LBB207_3:
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
LFQH_Lloh4554:
adr x0, LFQH_l_.str.403
LFQH_Lloh4555:
nop
bl Lpatch + (0xa5a4 - PATCH_BASE)
mov	x1, x0
mov	x0, x19
bl Lpatch + (0xa5d4 - PATCH_BASE)
mov	x19, x0
LFQH_Lloh4556:
adr x0, LFQH_l_.str.404
LFQH_Lloh4557:
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
fmov	d8, d1
fmov	d10, d0
mov	x20, x2
mov	x21, x1
mov	x19, x0
LFQH_Lloh4558:
adr x1, LFQH_HeaderAppliedRadiusKey
LFQH_Lloh4559:
nop
bl Lpatch + (0xa628 - PATCH_BASE)
mov	x22, x0
cbz	x0, LFQH_LBB210_2
LFQH_Lloh4560:
adr x0, LFQH_l_.str.445
LFQH_Lloh4561:
nop
bl Lpatch + (0xa5a4 - PATCH_BASE)
mov	x1, x0
mov	x0, x22
bl Lpatch + (0xa5d4 - PATCH_BASE)
fmov	d9, d0
b	LFQH_LBB210_3
LFQH_LBB210_2:
fmov	d9, xzr
LFQH_LBB210_3:
LFQH_Lloh4562:
adr x1, LFQH_HeaderClipsKey
LFQH_Lloh4563:
nop
mov	x0, x19
bl Lpatch + (0xa628 - PATCH_BASE)
cbz	w21, LFQH_LBB210_5
cbnz	x0, LFQH_LBB210_6
LFQH_LBB210_5:
LFQH_Lloh4564:
adr x0, LFQH_l_.str.497
LFQH_Lloh4565:
nop
bl Lpatch + (0xa5b0 - PATCH_BASE)
mov	x23, x0
LFQH_Lloh4566:
adr x0, LFQH_l_.str.499
LFQH_Lloh4567:
nop
bl Lpatch + (0xa5a4 - PATCH_BASE)
mov	x1, x0
mov	x0, x23
mov	x2, x21
bl Lpatch + (0xa5d4 - PATCH_BASE)
mov	x2, x0
LFQH_Lloh4568:
adr x1, LFQH_HeaderClipsKey
LFQH_Lloh4569:
nop
mov	x0, x19
mov	w3, #1
bl Lpatch + (0xa634 - PATCH_BASE)
LFQH_LBB210_6:
LFQH_Lloh4570:
adr x1, LFQH_HeaderOpaqueKey
LFQH_Lloh4571:
nop
mov	x0, x19
bl Lpatch + (0xa628 - PATCH_BASE)
cbnz	w20, LFQH_LBB210_8
cbnz	x0, LFQH_LBB210_9
LFQH_LBB210_8:
LFQH_Lloh4572:
adr x0, LFQH_l_.str.497
LFQH_Lloh4573:
nop
bl Lpatch + (0xa5b0 - PATCH_BASE)
mov	x23, x0
LFQH_Lloh4574:
adr x0, LFQH_l_.str.499
LFQH_Lloh4575:
nop
bl Lpatch + (0xa5a4 - PATCH_BASE)
mov	x1, x0
mov	x0, x23
mov	x2, x20
bl Lpatch + (0xa5d4 - PATCH_BASE)
mov	x2, x0
LFQH_Lloh4576:
adr x1, LFQH_HeaderOpaqueKey
LFQH_Lloh4577:
nop
mov	x0, x19
mov	w3, #1
bl Lpatch + (0xa634 - PATCH_BASE)
LFQH_LBB210_9:
cbz	x22, LFQH_LBB210_11
fcmp	d9, d10
b.eq	LFQH_LBB210_12
LFQH_LBB210_11:
LFQH_Lloh4578:
adr x0, LFQH_l_.str.497
LFQH_Lloh4579:
nop
bl Lpatch + (0xa5b0 - PATCH_BASE)
mov	x23, x0
LFQH_Lloh4580:
adr x0, LFQH_l_.str.515
LFQH_Lloh4581:
nop
bl Lpatch + (0xa5a4 - PATCH_BASE)
mov	x1, x0
mov	x0, x23
fmov	d0, d10
bl Lpatch + (0xa5d4 - PATCH_BASE)
mov	x2, x0
LFQH_Lloh4582:
adr x1, LFQH_HeaderRadiusKey
LFQH_Lloh4583:
nop
mov	x0, x19
mov	w3, #1
bl Lpatch + (0xa634 - PATCH_BASE)
LFQH_LBB210_12:
fcmp	d10, d8
b.eq	LFQH_LBB210_14
LFQH_Lloh4584:
adr x0, LFQH_l_.str.403
LFQH_Lloh4585:
nop
bl Lpatch + (0xa5a4 - PATCH_BASE)
mov	x1, x0
mov	x0, x19
bl Lpatch + (0xa5d4 - PATCH_BASE)
mov	x23, x0
LFQH_Lloh4586:
adr x0, LFQH_l_.str.406
LFQH_Lloh4587:
nop
bl Lpatch + (0xa5a4 - PATCH_BASE)
mov	x1, x0
mov	x0, x23
fmov	d0, d8
bl Lpatch + (0xa5d4 - PATCH_BASE)
LFQH_LBB210_14:
cbz	x22, LFQH_LBB210_19
fcmp	d9, d8
b.ne	LFQH_LBB210_19
cbz	w21, LFQH_LBB210_20
LFQH_LBB210_17:
cbz	w20, LFQH_LBB210_21
LFQH_LBB210_18:
LFQH_Lloh4588:
adr x0, LFQH_l_.str.402
LFQH_Lloh4589:
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
LFQH_LBB210_19:
LFQH_Lloh4590:
adr x0, LFQH_l_.str.497
LFQH_Lloh4591:
nop
bl Lpatch + (0xa5b0 - PATCH_BASE)
mov	x22, x0
LFQH_Lloh4592:
adr x0, LFQH_l_.str.515
LFQH_Lloh4593:
nop
bl Lpatch + (0xa5a4 - PATCH_BASE)
mov	x1, x0
mov	x0, x22
fmov	d0, d8
bl Lpatch + (0xa5d4 - PATCH_BASE)
mov	x2, x0
LFQH_Lloh4594:
adr x1, LFQH_HeaderAppliedRadiusKey
LFQH_Lloh4595:
nop
mov	x0, x19
mov	w3, #1
bl Lpatch + (0xa634 - PATCH_BASE)
cbnz	w21, LFQH_LBB210_17
LFQH_LBB210_20:
LFQH_Lloh4596:
adr x0, LFQH_l_.str.405
LFQH_Lloh4597:
nop
bl Lpatch + (0xa5a4 - PATCH_BASE)
mov	x1, x0
mov	x0, x19
mov	w2, #1
bl Lpatch + (0xa5d4 - PATCH_BASE)
cbnz	w20, LFQH_LBB210_18
LFQH_LBB210_21:
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
LFQH_Lloh4598:
adr x1, LFQH_ClipsKey
LFQH_Lloh4599:
nop
bl Lpatch + (0xa628 - PATCH_BASE)
cbnz	w21, LFQH_LBB211_2
cbnz	x0, LFQH_LBB211_3
LFQH_LBB211_2:
LFQH_Lloh4600:
adr x0, LFQH_l_.str.497
LFQH_Lloh4601:
nop
bl Lpatch + (0xa5b0 - PATCH_BASE)
mov	x22, x0
LFQH_Lloh4602:
adr x0, LFQH_l_.str.499
LFQH_Lloh4603:
nop
bl Lpatch + (0xa5a4 - PATCH_BASE)
mov	x1, x0
mov	x0, x22
mov	x2, x21
bl Lpatch + (0xa5d4 - PATCH_BASE)
mov	x2, x0
LFQH_Lloh4604:
adr x1, LFQH_ClipsKey
LFQH_Lloh4605:
nop
mov	x0, x19
mov	w3, #1
bl Lpatch + (0xa634 - PATCH_BASE)
LFQH_LBB211_3:
LFQH_Lloh4606:
adr x1, LFQH_OpaqueKey
LFQH_Lloh4607:
nop
mov	x0, x19
bl Lpatch + (0xa628 - PATCH_BASE)
cbnz	w20, LFQH_LBB211_5
cbnz	x0, LFQH_LBB211_6
LFQH_LBB211_5:
LFQH_Lloh4608:
adr x0, LFQH_l_.str.497
LFQH_Lloh4609:
nop
bl Lpatch + (0xa5b0 - PATCH_BASE)
mov	x22, x0
LFQH_Lloh4610:
adr x0, LFQH_l_.str.499
LFQH_Lloh4611:
nop
bl Lpatch + (0xa5a4 - PATCH_BASE)
mov	x1, x0
mov	x0, x22
mov	x2, x20
bl Lpatch + (0xa5d4 - PATCH_BASE)
mov	x2, x0
LFQH_Lloh4612:
adr x1, LFQH_OpaqueKey
LFQH_Lloh4613:
nop
mov	x0, x19
mov	w3, #1
bl Lpatch + (0xa634 - PATCH_BASE)
LFQH_LBB211_6:
cbz	w21, LFQH_LBB211_8
LFQH_Lloh4614:
adr x0, LFQH_l_.str.405
LFQH_Lloh4615:
nop
bl Lpatch + (0xa5a4 - PATCH_BASE)
mov	x1, x0
mov	x0, x19
mov	w2, #0
bl Lpatch + (0xa5d4 - PATCH_BASE)
LFQH_LBB211_8:
cbz	w20, LFQH_LBB211_10
LFQH_Lloh4616:
adr x0, LFQH_l_.str.402
LFQH_Lloh4617:
nop
bl Lpatch + (0xa5a4 - PATCH_BASE)
mov	x1, x0
mov	x0, x19
mov	w2, #0
ldp	x29, x30, [sp, #32]
ldp	x20, x19, [sp, #16]
ldp	x22, x21, [sp], #48
b Lpatch + (0xa5d4 - PATCH_BASE)
LFQH_LBB211_10:
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
fmov	d0, xzr
mov	x1, #0
bl	LFQH_TrackAppearanceLabel
LFQH_Lloh4618:
adr x1, LFQH_ReaderShelfStyledFrameKey
LFQH_Lloh4619:
nop
mov	x0, x19
bl Lpatch + (0xa628 - PATCH_BASE)
cbz	x0, LFQH_LBB220_4
mov	x21, x0
LFQH_Lloh4620:
adr x0, LFQH_l_.str.372
LFQH_Lloh4621:
nop
bl Lpatch + (0xa5a4 - PATCH_BASE)
mov	x1, x0
mov	x0, x19
bl Lpatch + (0xa5d4 - PATCH_BASE)
fmov	d8, d0
fmov	d9, d1
fmov	d10, d2
fmov	d11, d3
LFQH_Lloh4622:
adr x0, LFQH_l_.str.432
LFQH_Lloh4623:
nop
bl Lpatch + (0xa5a4 - PATCH_BASE)
mov	x1, x0
mov	x0, x21
bl Lpatch + (0xa5d4 - PATCH_BASE)
fcmp	d8, d0
fccmp	d9, d1, #0, eq
fccmp	d10, d2, #0, eq
fccmp	d11, d3, #0, eq
b.ne	LFQH_LBB220_3
LFQH_Lloh4624:
adr x1, LFQH_ReaderShelfStockFrameKey
LFQH_Lloh4625:
nop
mov	x0, x19
bl Lpatch + (0xa628 - PATCH_BASE)
mov	x21, x0
LFQH_Lloh4626:
adr x0, LFQH_l_.str.432
LFQH_Lloh4627:
nop
bl Lpatch + (0xa5a4 - PATCH_BASE)
mov	x1, x0
mov	x0, x21
bl Lpatch + (0xa5d4 - PATCH_BASE)
fmov	d8, d0
fmov	d9, d1
fmov	d10, d2
fmov	d11, d3
LFQH_Lloh4628:
adr x0, LFQH_l_.str.156
LFQH_Lloh4629:
nop
bl Lpatch + (0xa5a4 - PATCH_BASE)
mov	x1, x0
mov	x0, x19
fmov	d0, d8
fmov	d1, d9
fmov	d2, d10
fmov	d3, d11
bl Lpatch + (0xa5d4 - PATCH_BASE)
LFQH_LBB220_3:
LFQH_Lloh4630:
adr x1, LFQH_ReaderShelfStockFrameKey
LFQH_Lloh4631:
nop
mov	x0, x19
mov	x2, #0
mov	w3, #1
bl Lpatch + (0xa634 - PATCH_BASE)
LFQH_Lloh4632:
adr x1, LFQH_ReaderShelfStyledFrameKey
LFQH_Lloh4633:
nop
mov	x0, x19
mov	x2, #0
mov	w3, #1
bl Lpatch + (0xa634 - PATCH_BASE)
LFQH_LBB220_4:
mov	x0, x19
bl	LFQH_RestoreGlyph
cbz	x20, LFQH_LBB220_6
mov	x0, x19
mov	x1, x20
mov	w2, #0
bl	LFQH_ObservePress
LFQH_Lloh4634:
adr x0, LFQH_l_.str.431
LFQH_Lloh4635:
nop
bl Lpatch + (0xa5a4 - PATCH_BASE)
mov	x1, x0
mov	x0, x20
bl Lpatch + (0xa5d4 - PATCH_BASE)
LFQH_LBB220_6:
LFQH_Lloh4636:
adr x1, LFQH_IconGlassKey
LFQH_Lloh4637:
nop
mov	x0, x19
mov	x2, #0
mov	w3, #1
bl Lpatch + (0xa634 - PATCH_BASE)
LFQH_Lloh4638:
adr x1, LFQH_IconRectKey
LFQH_Lloh4639:
nop
mov	x0, x19
mov	x2, #0
mov	w3, #1
bl Lpatch + (0xa634 - PATCH_BASE)
LFQH_Lloh4640:
adr x1, LFQH_LayoutKey
LFQH_Lloh4641:
nop
mov	x0, x19
mov	x2, #0
mov	w3, #1
bl Lpatch + (0xa634 - PATCH_BASE)
LFQH_Lloh4642:
adr x1, LFQH_LayoutTimeKey
LFQH_Lloh4643:
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
stp	d15, d14, [sp, #-128]!
stp	d13, d12, [sp, #16]
stp	d11, d10, [sp, #32]
stp	d9, d8, [sp, #48]
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
.cfi_offset b8, -72
.cfi_offset b9, -80
.cfi_offset b10, -88
.cfi_offset b11, -96
.cfi_offset b12, -104
.cfi_offset b13, -112
.cfi_offset b14, -120
.cfi_offset b15, -128
mov	x19, x0
LFQH_Lloh4644:
adr x1, LFQH_GlyphViewKey
LFQH_Lloh4645:
nop
bl Lpatch + (0xa628 - PATCH_BASE)
mov	x20, x0
LFQH_Lloh4646:
adr x1, LFQH_GlyphOriginalKey
LFQH_Lloh4647:
nop
bl Lpatch + (0xa628 - PATCH_BASE)
mov	x22, x0
LFQH_Lloh4648:
adr x1, LFQH_GlyphAppliedKey
LFQH_Lloh4649:
nop
mov	x0, x20
bl Lpatch + (0xa628 - PATCH_BASE)
cmp	x22, #0
ccmp	x0, #0, #4, ne
b.eq	LFQH_LBB222_3
mov	x21, x0
LFQH_Lloh4650:
adr x23, LFQH_l_.str.432
LFQH_Lloh4651:
nop
mov	x0, x23
bl Lpatch + (0xa5a4 - PATCH_BASE)
mov	x1, x0
mov	x0, x22
bl Lpatch + (0xa5d4 - PATCH_BASE)
fmov	d8, d0
fmov	d9, d1
fmov	d10, d2
fmov	d11, d3
mov	x0, x23
bl Lpatch + (0xa5a4 - PATCH_BASE)
mov	x1, x0
mov	x0, x21
bl Lpatch + (0xa5d4 - PATCH_BASE)
fmov	d12, d0
fmov	d13, d1
fmov	d14, d2
fmov	d15, d3
LFQH_Lloh4652:
adr x0, LFQH_l_.str.372
LFQH_Lloh4653:
nop
bl Lpatch + (0xa5a4 - PATCH_BASE)
mov	x1, x0
mov	x0, x20
bl Lpatch + (0xa5d4 - PATCH_BASE)
fcmp	d0, d12
fccmp	d1, d13, #0, eq
fccmp	d2, d14, #0, eq
fccmp	d3, d15, #0, eq
b.ne	LFQH_LBB222_3
LFQH_Lloh4654:
adr x0, LFQH_l_.str.156
LFQH_Lloh4655:
nop
bl Lpatch + (0xa5a4 - PATCH_BASE)
mov	x1, x0
mov	x0, x20
fmov	d0, d8
fmov	d1, d9
fmov	d2, d10
fmov	d3, d11
bl Lpatch + (0xa5d4 - PATCH_BASE)
LFQH_LBB222_3:
LFQH_Lloh4656:
adr x1, LFQH_GlyphOriginalKey
LFQH_Lloh4657:
nop
mov	x0, x20
mov	x2, #0
mov	w3, #1
bl Lpatch + (0xa634 - PATCH_BASE)
LFQH_Lloh4658:
adr x1, LFQH_GlyphAppliedKey
LFQH_Lloh4659:
nop
mov	x0, x20
mov	x2, #0
mov	w3, #1
bl Lpatch + (0xa634 - PATCH_BASE)
LFQH_Lloh4660:
adr x1, LFQH_GlyphViewKey
LFQH_Lloh4661:
nop
mov	x0, x19
mov	x2, #0
mov	w3, #1
ldp	x29, x30, [sp, #112]
ldp	x20, x19, [sp, #96]
ldp	x22, x21, [sp, #80]
ldp	x24, x23, [sp, #64]
ldp	d9, d8, [sp, #48]
ldp	d11, d10, [sp, #32]
ldp	d13, d12, [sp, #16]
ldp	d15, d14, [sp], #128
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
LFQH_Lloh4662:
adr x1, LFQH_l_.str.433
LFQH_Lloh4663:
nop
bl	LFQH_Responds
cbz	w0, LFQH_LBB225_2
LFQH_Lloh4664:
adr x1, LFQH_l_.str.434
LFQH_Lloh4665:
nop
mov	x0, x19
bl	LFQH_Responds
cmp	w0, #0
cset	w0, ne
LFQH_LBB225_2:
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
LFQH_Lloh4666:
adr x0, LFQH_l_.str.435
LFQH_Lloh4667:
nop
bl Lpatch + (0xa5b0 - PATCH_BASE)
mov	x19, x0
cbnz	x0, LFQH_LBB226_3
LFQH_Lloh4668:
adr x0, LFQH_l_.str.138
LFQH_Lloh4669:
nop
bl Lpatch + (0xa5b0 - PATCH_BASE)
LFQH_Lloh4670:
adr x1, LFQH_l_.str.435
LFQH_Lloh4671:
nop
mov	x2, #0
bl Lpatch + (0xa61c - PATCH_BASE)
mov	x19, x0
cbz	x0, LFQH_LBB226_3
LFQH_Lloh4672:
adr x0, LFQH_l_.str.436
LFQH_Lloh4673:
nop
bl Lpatch + (0xa5a4 - PATCH_BASE)
mov	x1, x0
LFQH_Lloh4674:
adr x2, LFQH_Press
LFQH_Lloh4675:
nop
LFQH_Lloh4676:
adr x20, LFQH_l_.str.186
LFQH_Lloh4677:
nop
mov	x0, x19
mov	x3, x20
bl Lpatch + (0xa58c - PATCH_BASE)
LFQH_Lloh4678:
adr x0, LFQH_l_.str.437
LFQH_Lloh4679:
nop
bl Lpatch + (0xa5a4 - PATCH_BASE)
mov	x1, x0
LFQH_Lloh4680:
adr x2, LFQH_ReleasePress
LFQH_Lloh4681:
nop
mov	x0, x19
mov	x3, x20
bl Lpatch + (0xa58c - PATCH_BASE)
mov	x0, x19
bl Lpatch + (0xa610 - PATCH_BASE)
LFQH_LBB226_3:
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
LFQH_Lloh4682:
adr x1, LFQH_l_.str.42
LFQH_Lloh4683:
nop
bl	LFQH_Kind
cbz	w0, LFQH_LBB227_2
LFQH_Lloh4684:
adr x8, LFQH_l_.str.438
LFQH_Lloh4685:
nop
LFQH_Lloh4686:
adr x9, LFQH_l_.str.439
LFQH_Lloh4687:
nop
cmp	w21, #0
csel	x0, x9, x8, eq
bl Lpatch + (0xa5a4 - PATCH_BASE)
mov	x21, x0
LFQH_Lloh4688:
adr x0, LFQH_l_.str.436
LFQH_Lloh4689:
nop
bl Lpatch + (0xa5a4 - PATCH_BASE)
mov	x3, x0
mov	x0, x20
mov	x1, x21
mov	x2, x19
mov	w4, #17
bl Lpatch + (0xa5d4 - PATCH_BASE)
LFQH_Lloh4690:
adr x0, LFQH_l_.str.437
LFQH_Lloh4691:
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
LFQH_LBB227_2:
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
fmov	d13, d0
mov	x21, x1
mov	x19, x0
LFQH_Lloh4692:
adr x0, LFQH_l_.str.372
LFQH_Lloh4693:
nop
bl Lpatch + (0xa5a4 - PATCH_BASE)
mov	x1, x0
mov	x0, x19
bl Lpatch + (0xa5d4 - PATCH_BASE)
fmov	d12, d0
fmov	d14, d1
fmov	d11, d2
fmov	d8, d3
LFQH_Lloh4694:
adr x1, LFQH_ReaderShelfStockFrameKey
LFQH_Lloh4695:
nop
mov	x0, x19
bl Lpatch + (0xa628 - PATCH_BASE)
mov	x20, x0
LFQH_Lloh4696:
adr x1, LFQH_ReaderShelfStyledFrameKey
LFQH_Lloh4697:
nop
mov	x0, x19
bl Lpatch + (0xa628 - PATCH_BASE)
mov	x22, x0
stp	d11, d8, [sp, #80]
stp	d12, d14, [sp, #64]
cbz	x0, LFQH_LBB228_2
LFQH_Lloh4698:
adr x0, LFQH_l_.str.432
LFQH_Lloh4699:
nop
bl Lpatch + (0xa5a4 - PATCH_BASE)
mov	x1, x0
mov	x0, x22
bl Lpatch + (0xa5d4 - PATCH_BASE)
fcmp	d12, d0
fccmp	d14, d1, #0, eq
fccmp	d11, d2, #0, eq
fccmp	d8, d3, #0, eq
b.eq	LFQH_LBB228_3
LFQH_LBB228_2:
mov	w23, #0
str	d12, [sp, #104]
str	d14, [sp, #128]
fmov	d14, d11
b	LFQH_LBB228_4
LFQH_LBB228_3:
LFQH_Lloh4700:
adr x0, LFQH_l_.str.432
LFQH_Lloh4701:
nop
bl Lpatch + (0xa5a4 - PATCH_BASE)
mov	x1, x0
mov	x0, x20
bl Lpatch + (0xa5d4 - PATCH_BASE)
str	d0, [sp, #104]
str	d1, [sp, #128]
fmov	d14, d2
fmov	d8, d3
mov	w23, #1
LFQH_LBB228_4:
LFQH_Lloh4702:
adr x1, LFQH_l_.str.37
LFQH_Lloh4703:
nop
mov	x0, x21
bl	LFQH_Kind
mov	x20, x21
cbnz	w0, LFQH_LBB228_6
LFQH_Lloh4704:
adr x0, LFQH_l_.str.20
LFQH_Lloh4705:
nop
bl Lpatch + (0xa5a4 - PATCH_BASE)
mov	x1, x0
mov	x0, x21
bl Lpatch + (0xa5d4 - PATCH_BASE)
mov	x20, x0
LFQH_LBB228_6:
LFQH_Lloh4706:
adr x1, LFQH_l_.str.37
LFQH_Lloh4707:
nop
mov	x0, x20
bl	LFQH_Kind
str	d8, [sp, #112]
cbz	w0, LFQH_LBB228_17
str	w23, [sp, #36]
str	x22, [sp, #40]
LFQH_Lloh4708:
adr x0, LFQH_l_.str.507
LFQH_Lloh4709:
nop
bl Lpatch + (0xa5a4 - PATCH_BASE)
mov	x1, x0
mov	x0, x21
ldr	d0, [sp, #104]
ldr	d1, [sp, #128]
fmov	d2, d14
fmov	d3, d8
mov	x2, x20
bl Lpatch + (0xa5d4 - PATCH_BASE)
fmov	d11, d0
fmov	d15, d1
fmov	d8, d3
LFQH_Lloh4710:
adr x0, LFQH_l_.str.24
LFQH_Lloh4711:
nop
bl Lpatch + (0xa5a4 - PATCH_BASE)
mov	x1, x0
mov	x0, x20
bl Lpatch + (0xa5d4 - PATCH_BASE)
fmov	d1, #8.00000000
fadd	d0, d0, d1
str	d0, [sp, #120]
LFQH_Lloh4712:
adr x0, LFQH_l_.str.414
LFQH_Lloh4713:
nop
bl Lpatch + (0xa5a4 - PATCH_BASE)
mov	x1, x0
mov	x0, x20
bl Lpatch + (0xa5d4 - PATCH_BASE)
mov	x23, x0
LFQH_Lloh4714:
adr x1, LFQH_l_.str.440
LFQH_Lloh4715:
nop
mov	x0, x20
bl	LFQH_Get
mov	x24, x0
LFQH_Lloh4716:
adr x1, LFQH_IconGlassKey
LFQH_Lloh4717:
nop
mov	x0, x19
bl Lpatch + (0xa628 - PATCH_BASE)
mov	x25, x0
LFQH_Lloh4718:
adr x0, LFQH_l_.str.34
LFQH_Lloh4719:
nop
bl Lpatch + (0xa5a4 - PATCH_BASE)
mov	x1, x0
mov	x0, x23
bl Lpatch + (0xa5d4 - PATCH_BASE)
cbz	x0, LFQH_LBB228_16
mov	x26, x0
str	x20, [sp, #8]
mov	x27, #0
fmov	d0, #0.50000000
fmul	d0, d8, d0
fadd	d0, d15, d0
fmov	d1, #18.00000000
fadd	d12, d0, d1
LFQH_Lloh4720:
adr x28, LFQH_l_.str.461
LFQH_Lloh4721:
nop
fmov	d1, #-18.00000000
LFQH_Lloh4722:
adr x22, LFQH_l_.str.71
LFQH_Lloh4723:
nop
fadd	d10, d0, d1
stp	d14, d13, [sp, #16]
LFQH_LBB228_9:
mov	x0, x28
bl Lpatch + (0xa5a4 - PATCH_BASE)
mov	x1, x0
mov	x0, x23
mov	x2, x27
bl Lpatch + (0xa5d4 - PATCH_BASE)
cmp	x0, x21
ccmp	x0, x19, #4, ne
ccmp	x0, x25, #4, ne
ccmp	x0, x24, #4, ne
b.eq	LFQH_LBB228_15
mov	x20, x0
mov	x0, x22
bl Lpatch + (0xa5a4 - PATCH_BASE)
mov	x1, x0
mov	x0, x20
bl Lpatch + (0xa5d4 - PATCH_BASE)
cbnz	w0, LFQH_LBB228_15
LFQH_Lloh4724:
adr x0, LFQH_l_.str.372
LFQH_Lloh4725:
nop
bl Lpatch + (0xa5a4 - PATCH_BASE)
mov	x1, x0
mov	x0, x20
bl Lpatch + (0xa5d4 - PATCH_BASE)
fmov	d8, d0
fadd	d0, d1, d3
fcmp	d8, d11
fccmp	d1, d12, #0, lt
fccmp	d0, d10, #0, lt
b.ls	LFQH_LBB228_15
fmov	d15, d2
fmov	d9, d12
fmov	d12, d11
mov	x0, x20
LFQH_Lloh4726:
adr x1, LFQH_IconGlassKey
LFQH_Lloh4727:
nop
bl Lpatch + (0xa628 - PATCH_BASE)
mov	x22, x0
fadd	d11, d8, d15
LFQH_Lloh4728:
adr x0, LFQH_l_.str.20
LFQH_Lloh4729:
nop
bl Lpatch + (0xa5a4 - PATCH_BASE)
mov	x1, x0
mov	x0, x22
bl Lpatch + (0xa5d4 - PATCH_BASE)
cmp	x0, x20
b.ne	LFQH_LBB228_14
LFQH_Lloh4730:
adr x0, LFQH_l_.str.372
LFQH_Lloh4731:
nop
bl Lpatch + (0xa5a4 - PATCH_BASE)
mov	x1, x0
mov	x0, x22
bl Lpatch + (0xa5d4 - PATCH_BASE)
fmov	d8, d0
fmov	d15, d1
fmov	d13, d2
fmov	d14, d3
LFQH_Lloh4732:
adr x0, LFQH_l_.str.507
LFQH_Lloh4733:
nop
bl Lpatch + (0xa5a4 - PATCH_BASE)
mov	x1, x0
mov	x0, x20
fmov	d0, d8
fmov	d1, d15
fmov	d2, d13
fmov	d3, d14
ldp	d14, d13, [sp, #16]
ldr	x2, [sp, #8]
bl Lpatch + (0xa5d4 - PATCH_BASE)
fadd	d0, d0, d2
fcmp	d0, d11
fcsel	d11, d0, d11, gt
LFQH_LBB228_14:
fmov	d0, #8.00000000
fadd	d0, d11, d0
ldr	d1, [sp, #120]
fcmp	d0, d1
fcsel	d1, d0, d1, gt
str	d1, [sp, #120]
fmov	d11, d12
fmov	d12, d9
LFQH_Lloh4734:
adr x22, LFQH_l_.str.71
LFQH_Lloh4735:
nop
LFQH_LBB228_15:
add	x27, x27, #1
cmp	x26, x27
b.ne	LFQH_LBB228_9
LFQH_LBB228_16:
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
b	LFQH_LBB228_18
LFQH_LBB228_17:
fmov	d8, xzr
LFQH_LBB228_18:
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
cmp	w20, #1
b.ne	LFQH_LBB228_20
LFQH_Lloh4736:
adr x0, LFQH_l_.str.156
LFQH_Lloh4737:
nop
bl Lpatch + (0xa5a4 - PATCH_BASE)
mov	x1, x0
mov	x0, x19
fmov	d0, d11
ldr	d1, [sp, #128]
fmov	d2, d14
ldr	d3, [sp, #112]
bl Lpatch + (0xa5d4 - PATCH_BASE)
LFQH_LBB228_20:
fcmp	d8, #0.0
b.le	LFQH_LBB228_23
tbz	w23, #0, LFQH_LBB228_25
ldr	d15, [sp, #112]
cbnz	w20, LFQH_LBB228_26
b	LFQH_LBB228_28
LFQH_LBB228_23:
cbz	x22, LFQH_LBB228_28
LFQH_Lloh4738:
adr x1, LFQH_ReaderShelfStockFrameKey
LFQH_Lloh4739:
nop
mov	x0, x19
mov	x2, #0
mov	w3, #1
bl Lpatch + (0xa634 - PATCH_BASE)
mov	x2, #0
b	LFQH_LBB228_27
LFQH_LBB228_25:
LFQH_Lloh4740:
adr x0, LFQH_l_.str.512
LFQH_Lloh4741:
nop
bl Lpatch + (0xa5b0 - PATCH_BASE)
mov	x20, x0
LFQH_Lloh4742:
adr x0, LFQH_l_.str.513
LFQH_Lloh4743:
nop
bl Lpatch + (0xa5a4 - PATCH_BASE)
mov	x1, x0
mov	x0, x20
ldp	d0, d15, [sp, #104]
ldr	d1, [sp, #128]
fmov	d2, d14
fmov	d3, d15
bl Lpatch + (0xa5d4 - PATCH_BASE)
mov	x2, x0
LFQH_Lloh4744:
adr x1, LFQH_ReaderShelfStockFrameKey
LFQH_Lloh4745:
nop
mov	x0, x19
mov	w3, #1
bl Lpatch + (0xa634 - PATCH_BASE)
LFQH_LBB228_26:
LFQH_Lloh4746:
adr x0, LFQH_l_.str.512
LFQH_Lloh4747:
nop
bl Lpatch + (0xa5b0 - PATCH_BASE)
mov	x20, x0
LFQH_Lloh4748:
adr x0, LFQH_l_.str.513
LFQH_Lloh4749:
nop
bl Lpatch + (0xa5a4 - PATCH_BASE)
mov	x1, x0
mov	x0, x20
fmov	d0, d11
ldr	d1, [sp, #128]
fmov	d2, d14
fmov	d3, d15
bl Lpatch + (0xa5d4 - PATCH_BASE)
mov	x2, x0
LFQH_LBB228_27:
LFQH_Lloh4750:
adr x1, LFQH_ReaderShelfStyledFrameKey
LFQH_Lloh4751:
nop
mov	x0, x19
mov	w3, #1
bl Lpatch + (0xa634 - PATCH_BASE)
LFQH_LBB228_28:
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
LFQH_TrackAppearanceLabel:
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
fmov	d8, d0
mov	x19, x1
mov	x20, x0
LFQH_Lloh4752:
adr x1, LFQH_AppearanceLabelKey
LFQH_Lloh4753:
nop
bl Lpatch + (0xa628 - PATCH_BASE)
cmp	x0, x19
b.eq	LFQH_LBB230_2
bl	LFQH_RestoreAppearanceFont
cmp	x19, x20
cset	w3, ne
LFQH_Lloh4754:
adr x1, LFQH_AppearanceLabelKey
LFQH_Lloh4755:
nop
mov	x0, x20
mov	x2, x19
bl Lpatch + (0xa634 - PATCH_BASE)
LFQH_LBB230_2:
cbz	x19, LFQH_LBB230_4
mov	x0, x19
fmov	d0, d8
ldp	x29, x30, [sp, #32]
ldp	x20, x19, [sp, #16]
ldp	d9, d8, [sp], #48
b	LFQH_AppearanceFont
LFQH_LBB230_4:
ldp	x29, x30, [sp, #32]
ldp	x20, x19, [sp, #16]
ldp	d9, d8, [sp], #48
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
LFQH_Lloh4756:
adr x22, LFQH_l_.str.372
LFQH_Lloh4757:
nop
mov	x0, x22
bl Lpatch + (0xa5a4 - PATCH_BASE)
mov	x1, x0
mov	x0, x20
bl Lpatch + (0xa5d4 - PATCH_BASE)
fmov	d10, d0
fmov	d12, d1
fmov	d13, d2
fmov	d14, d3
LFQH_Lloh4758:
adr x0, LFQH_l_.str.24
LFQH_Lloh4759:
nop
bl Lpatch + (0xa5a4 - PATCH_BASE)
mov	x1, x0
mov	x0, x20
bl Lpatch + (0xa5d4 - PATCH_BASE)
fmov	d9, d0
stp	d2, d1, [sp, #136]
str	d3, [sp, #128]
mov	x0, x22
bl Lpatch + (0xa5a4 - PATCH_BASE)
mov	x1, x0
mov	x0, x21
bl Lpatch + (0xa5d4 - PATCH_BASE)
stp	d1, d0, [sp, #112]
stp	d3, d2, [sp, #96]
LFQH_Lloh4760:
adr x0, LFQH_l_.str.20
LFQH_Lloh4761:
nop
bl Lpatch + (0xa5a4 - PATCH_BASE)
mov	x1, x0
mov	x0, x21
bl Lpatch + (0xa5d4 - PATCH_BASE)
cmp	x0, x20
b.eq	LFQH_LBB231_2
mov	x21, x0
LFQH_Lloh4762:
adr x0, LFQH_l_.str.507
LFQH_Lloh4763:
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
LFQH_LBB231_2:
LFQH_Lloh4764:
adr x1, LFQH_l_.str.74
LFQH_Lloh4765:
nop
mov	x0, x20
bl	LFQH_Get
fmov	d8, d10
stp	d13, d12, [sp, #80]
fmov	d3, d14
cbz	x0, LFQH_LBB231_4
mov	x21, x0
LFQH_Lloh4766:
adr x0, LFQH_l_.str.507
LFQH_Lloh4767:
nop
bl Lpatch + (0xa5a4 - PATCH_BASE)
mov	x1, x0
mov	x0, x20
fmov	d0, d9
ldp	d2, d1, [sp, #136]
ldr	d3, [sp, #128]
mov	x2, x21
bl Lpatch + (0xa5d4 - PATCH_BASE)
fmov	d10, d0
fmov	d12, d1
fmov	d13, d2
LFQH_LBB231_4:
str	d3, [sp, #40]
LFQH_Lloh4768:
adr x1, LFQH_LayoutKey
LFQH_Lloh4769:
nop
mov	x0, x20
bl Lpatch + (0xa628 - PATCH_BASE)
cbz	x0, LFQH_LBB231_25
mov	x21, x0
LFQH_Lloh4770:
adr x0, LFQH_l_.str.461
LFQH_Lloh4771:
nop
bl Lpatch + (0xa5a4 - PATCH_BASE)
mov	x1, x0
mov	x0, x21
mov	x2, #0
bl Lpatch + (0xa5d4 - PATCH_BASE)
mov	x22, x0
LFQH_Lloh4772:
adr x0, LFQH_l_.str.432
LFQH_Lloh4773:
nop
bl Lpatch + (0xa5a4 - PATCH_BASE)
mov	x1, x0
mov	x0, x22
bl Lpatch + (0xa5d4 - PATCH_BASE)
fcmp	d8, d0
b.ne	LFQH_LBB231_25
ldr	d0, [sp, #88]
fcmp	d0, d1
b.ne	LFQH_LBB231_25
ldr	d0, [sp, #80]
fcmp	d0, d2
b.ne	LFQH_LBB231_25
fcmp	d14, d3
b.ne	LFQH_LBB231_25
LFQH_Lloh4774:
adr x0, LFQH_l_.str.461
LFQH_Lloh4775:
nop
bl Lpatch + (0xa5a4 - PATCH_BASE)
mov	x1, x0
mov	x0, x21
mov	w2, #1
bl Lpatch + (0xa5d4 - PATCH_BASE)
mov	x22, x0
LFQH_Lloh4776:
adr x0, LFQH_l_.str.432
LFQH_Lloh4777:
nop
bl Lpatch + (0xa5a4 - PATCH_BASE)
mov	x1, x0
mov	x0, x22
bl Lpatch + (0xa5d4 - PATCH_BASE)
fcmp	d9, d0
b.ne	LFQH_LBB231_25
ldr	d0, [sp, #144]
fcmp	d0, d1
b.ne	LFQH_LBB231_25
ldr	d0, [sp, #136]
fcmp	d0, d2
b.ne	LFQH_LBB231_25
ldr	d0, [sp, #128]
fcmp	d0, d3
b.ne	LFQH_LBB231_25
LFQH_Lloh4778:
adr x0, LFQH_l_.str.461
LFQH_Lloh4779:
nop
bl Lpatch + (0xa5a4 - PATCH_BASE)
mov	x1, x0
mov	x0, x21
mov	w2, #2
bl Lpatch + (0xa5d4 - PATCH_BASE)
mov	x22, x0
LFQH_Lloh4780:
adr x0, LFQH_l_.str.432
LFQH_Lloh4781:
nop
bl Lpatch + (0xa5a4 - PATCH_BASE)
mov	x1, x0
mov	x0, x22
bl Lpatch + (0xa5d4 - PATCH_BASE)
ldr	d4, [sp, #72]
fcmp	d4, d0
b.ne	LFQH_LBB231_25
ldr	d0, [sp, #64]
fcmp	d0, d1
b.ne	LFQH_LBB231_25
ldr	d0, [sp, #56]
fcmp	d0, d2
b.ne	LFQH_LBB231_25
ldr	d0, [sp, #48]
fcmp	d0, d3
b.ne	LFQH_LBB231_25
LFQH_Lloh4782:
adr x0, LFQH_l_.str.461
LFQH_Lloh4783:
nop
bl Lpatch + (0xa5a4 - PATCH_BASE)
mov	x1, x0
mov	x0, x21
mov	w2, #3
bl Lpatch + (0xa5d4 - PATCH_BASE)
mov	x22, x0
LFQH_Lloh4784:
adr x0, LFQH_l_.str.432
LFQH_Lloh4785:
nop
bl Lpatch + (0xa5a4 - PATCH_BASE)
mov	x1, x0
mov	x0, x22
bl Lpatch + (0xa5d4 - PATCH_BASE)
ldr	d4, [sp, #120]
fcmp	d4, d0
b.ne	LFQH_LBB231_25
ldr	d0, [sp, #112]
fcmp	d0, d1
b.ne	LFQH_LBB231_25
ldr	d0, [sp, #104]
fcmp	d0, d2
b.ne	LFQH_LBB231_25
ldr	d0, [sp, #96]
fcmp	d0, d3
b.ne	LFQH_LBB231_25
LFQH_Lloh4786:
adr x0, LFQH_l_.str.461
LFQH_Lloh4787:
nop
bl Lpatch + (0xa5a4 - PATCH_BASE)
mov	x1, x0
mov	x0, x21
mov	w2, #4
bl Lpatch + (0xa5d4 - PATCH_BASE)
mov	x21, x0
LFQH_Lloh4788:
adr x0, LFQH_l_.str.432
LFQH_Lloh4789:
nop
bl Lpatch + (0xa5a4 - PATCH_BASE)
mov	x1, x0
mov	x0, x21
bl Lpatch + (0xa5d4 - PATCH_BASE)
fcmp	d10, d0
b.ne	LFQH_LBB231_25
fcmp	d12, d1
b.ne	LFQH_LBB231_25
fcmp	d13, d2
b.ne	LFQH_LBB231_25
ldr	d0, [sp, #40]
fcmp	d0, d3
b.eq	LFQH_LBB231_28
LFQH_LBB231_25:
LFQH_Lloh4790:
adr x0, LFQH_l_.str.407
LFQH_Lloh4791:
nop
bl Lpatch + (0xa5b0 - PATCH_BASE)
mov	x21, x0
LFQH_Lloh4792:
adr x0, LFQH_l_.str.408
LFQH_Lloh4793:
nop
bl Lpatch + (0xa5a4 - PATCH_BASE)
mov	x1, x0
mov	x0, x21
bl Lpatch + (0xa5d4 - PATCH_BASE)
mov	x21, x0
LFQH_Lloh4794:
adr x0, LFQH_l_.str.409
LFQH_Lloh4795:
nop
bl Lpatch + (0xa5a4 - PATCH_BASE)
mov	x1, x0
mov	x0, x21
bl Lpatch + (0xa5d4 - PATCH_BASE)
fmov	d15, d0
LFQH_Lloh4796:
adr x1, LFQH_LayoutTimeKey
LFQH_Lloh4797:
nop
mov	x0, x20
bl Lpatch + (0xa628 - PATCH_BASE)
cbz	x0, LFQH_LBB231_27
mov	x21, x0
LFQH_Lloh4798:
adr x0, LFQH_l_.str.445
LFQH_Lloh4799:
nop
bl Lpatch + (0xa5a4 - PATCH_BASE)
mov	x1, x0
mov	x0, x21
bl Lpatch + (0xa5d4 - PATCH_BASE)
fsub	d0, d15, d0
fmov	d1, #1.00000000
fcmp	d0, d1
b.mi	LFQH_LBB231_28
LFQH_LBB231_27:
LFQH_Lloh4800:
adr x21, LFQH_l_.str.512
LFQH_Lloh4801:
nop
mov	x0, x21
bl Lpatch + (0xa5b0 - PATCH_BASE)
mov	x23, x0
LFQH_Lloh4802:
adr x22, LFQH_l_.str.513
LFQH_Lloh4803:
nop
mov	x0, x22
bl Lpatch + (0xa5a4 - PATCH_BASE)
mov	x1, x0
mov	x0, x23
stp	d14, d8, [sp, #24]
fmov	d0, d8
ldp	d2, d1, [sp, #80]
str	d9, [sp, #16]
fmov	d3, d14
bl Lpatch + (0xa5d4 - PATCH_BASE)
str	x0, [sp, #152]
mov	x0, x21
bl Lpatch + (0xa5b0 - PATCH_BASE)
mov	x23, x0
mov	x0, x22
bl Lpatch + (0xa5a4 - PATCH_BASE)
mov	x1, x0
mov	x0, x23
fmov	d0, d9
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
fmov	d0, d14
fmov	d1, d11
fmov	d2, d9
fmov	d3, d8
bl Lpatch + (0xa5d4 - PATCH_BASE)
str	x0, [sp, #176]
mov	x0, x21
bl Lpatch + (0xa5b0 - PATCH_BASE)
mov	x21, x0
mov	x0, x22
bl Lpatch + (0xa5a4 - PATCH_BASE)
mov	x1, x0
mov	x0, x21
fmov	d0, d10
fmov	d1, d12
fmov	d10, d12
fmov	d2, d13
ldr	d12, [sp, #40]
fmov	d3, d12
bl Lpatch + (0xa5d4 - PATCH_BASE)
str	x0, [sp, #184]
LFQH_Lloh4804:
adr x0, LFQH_l_.str.33
LFQH_Lloh4805:
nop
bl Lpatch + (0xa5b0 - PATCH_BASE)
mov	x21, x0
LFQH_Lloh4806:
adr x0, LFQH_l_.str.446
LFQH_Lloh4807:
nop
bl Lpatch + (0xa5a4 - PATCH_BASE)
mov	x1, x0
add	x2, sp, #152
mov	x0, x21
mov	w3, #5
bl Lpatch + (0xa5d4 - PATCH_BASE)
mov	x2, x0
LFQH_Lloh4808:
adr x1, LFQH_LayoutKey
LFQH_Lloh4809:
nop
mov	x0, x20
mov	w3, #1
bl Lpatch + (0xa634 - PATCH_BASE)
LFQH_Lloh4810:
adr x0, LFQH_l_.str.497
LFQH_Lloh4811:
nop
bl Lpatch + (0xa5b0 - PATCH_BASE)
mov	x21, x0
LFQH_Lloh4812:
adr x0, LFQH_l_.str.515
LFQH_Lloh4813:
nop
bl Lpatch + (0xa5a4 - PATCH_BASE)
mov	x1, x0
mov	x0, x21
fmov	d0, d15
bl Lpatch + (0xa5d4 - PATCH_BASE)
mov	x2, x0
LFQH_Lloh4814:
adr x1, LFQH_LayoutTimeKey
LFQH_Lloh4815:
nop
mov	x0, x20
mov	w3, #1
bl Lpatch + (0xa634 - PATCH_BASE)
LFQH_Lloh4816:
adr x0, LFQH_l_.str.88
LFQH_Lloh4817:
nop
bl Lpatch + (0xa5b0 - PATCH_BASE)
mov	x20, x0
LFQH_Lloh4818:
adr x0, LFQH_l_.str.89
LFQH_Lloh4819:
nop
bl Lpatch + (0xa5a4 - PATCH_BASE)
mov	x1, x0
mov	x0, x20
bl Lpatch + (0xa5d4 - PATCH_BASE)
mov	x20, x0
LFQH_Lloh4820:
adr x0, LFQH_l_.str.361
LFQH_Lloh4821:
nop
bl Lpatch + (0xa5b0 - PATCH_BASE)
mov	x21, x0
LFQH_Lloh4822:
adr x0, LFQH_l_.str.387
LFQH_Lloh4823:
nop
bl Lpatch + (0xa5a4 - PATCH_BASE)
mov	x1, x0
mov	x0, x21
mov	x2, x19
bl Lpatch + (0xa5d4 - PATCH_BASE)
mov	x2, x0
LFQH_Lloh4824:
adr x1, LFQH_l_.str.410
LFQH_Lloh4825:
nop
mov	x0, x20
bl	LFQH_Put
ldp	d3, d0, [sp, #24]
ldp	d2, d1, [sp, #80]
bl	LFQH_RectArray
mov	x2, x0
LFQH_Lloh4826:
adr x1, LFQH_l_.str.411
LFQH_Lloh4827:
nop
mov	x0, x20
bl	LFQH_Put
ldr	d0, [sp, #16]
ldp	d2, d1, [sp, #136]
ldr	d3, [sp, #128]
bl	LFQH_RectArray
mov	x2, x0
LFQH_Lloh4828:
adr x1, LFQH_l_.str.412
LFQH_Lloh4829:
nop
mov	x0, x20
bl	LFQH_Put
ldp	d1, d0, [sp, #64]
ldp	d3, d2, [sp, #48]
bl	LFQH_RectArray
mov	x2, x0
LFQH_Lloh4830:
adr x1, LFQH_l_.str.447
LFQH_Lloh4831:
nop
mov	x0, x20
bl	LFQH_Put
fmov	d0, d14
fmov	d1, d11
fmov	d2, d9
fmov	d3, d8
bl	LFQH_RectArray
mov	x2, x0
LFQH_Lloh4832:
adr x1, LFQH_l_.str.413
LFQH_Lloh4833:
nop
mov	x0, x20
bl	LFQH_Put
ldr	d0, [sp, #8]
fmov	d1, d10
fmov	d2, d13
fmov	d3, d12
bl	LFQH_RectArray
mov	x2, x0
LFQH_Lloh4834:
adr x1, LFQH_l_.str.448
LFQH_Lloh4835:
nop
mov	x0, x20
bl	LFQH_Put
LFQH_Lloh4836:
adr x0, LFQH_l_.str.449
LFQH_Lloh4837:
nop
mov	x1, x20
bl Lrecord_named
LFQH_LBB231_28:
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
cmp	w0, #6
b.gt	LFQH_LBB232_6
cmp	w0, #3
b.le	LFQH_LBB232_11
cmp	w0, #4
b.eq	LFQH_LBB232_19
cmp	w0, #5
b.eq	LFQH_LBB232_21
cmp	w0, #6
b.ne	LFQH_LBB232_23
LFQH_Lloh4838:
adr x0, LFQH_l_.str.454
LFQH_Lloh4839:
nop
ret
LFQH_LBB232_6:
cmp	w0, #8
b.le	LFQH_LBB232_14
cmp	w0, #9
b.eq	LFQH_LBB232_20
cmp	w0, #10
b.eq	LFQH_LBB232_22
cmp	w0, #11
b.ne	LFQH_LBB232_23
LFQH_Lloh4840:
adr x0, LFQH_l_.str.455
LFQH_Lloh4841:
nop
ret
LFQH_LBB232_11:
cmp	w0, #2
b.eq	LFQH_LBB232_17
cmp	w0, #3
b.ne	LFQH_LBB232_23
LFQH_Lloh4842:
adr x0, LFQH_l_.str.451
LFQH_Lloh4843:
nop
ret
LFQH_LBB232_14:
cmp	w0, #7
b.eq	LFQH_LBB232_18
cmp	w0, #8
b.ne	LFQH_LBB232_23
LFQH_Lloh4844:
adr x0, LFQH_l_.str.457
LFQH_Lloh4845:
nop
ret
LFQH_LBB232_17:
LFQH_Lloh4846:
adr x0, LFQH_l_.str.450
LFQH_Lloh4847:
nop
ret
LFQH_LBB232_18:
LFQH_Lloh4848:
adr x0, LFQH_l_.str.456
LFQH_Lloh4849:
nop
ret
LFQH_LBB232_19:
LFQH_Lloh4850:
adr x0, LFQH_l_.str.452
LFQH_Lloh4851:
nop
ret
LFQH_LBB232_20:
LFQH_Lloh4852:
adr x0, LFQH_l_.str.458
LFQH_Lloh4853:
nop
ret
LFQH_LBB232_21:
LFQH_Lloh4854:
adr x0, LFQH_l_.str.453
LFQH_Lloh4855:
nop
ret
LFQH_LBB232_22:
LFQH_Lloh4856:
adr x0, LFQH_l_.str.459
LFQH_Lloh4857:
nop
ret
LFQH_LBB232_23:
LFQH_Lloh4858:
adr x0, LFQH_l_.str.460
LFQH_Lloh4859:
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
LFQH_Lloh4860:
adr x1, LFQH_ClipsKey
LFQH_Lloh4861:
nop
bl Lpatch + (0xa628 - PATCH_BASE)
mov	x21, x0
LFQH_Lloh4862:
adr x1, LFQH_OpaqueKey
LFQH_Lloh4863:
nop
mov	x0, x19
bl Lpatch + (0xa628 - PATCH_BASE)
mov	x20, x0
cbz	x21, LFQH_LBB235_3
LFQH_Lloh4864:
adr x0, LFQH_l_.str.391
LFQH_Lloh4865:
nop
bl Lpatch + (0xa5a4 - PATCH_BASE)
mov	x1, x0
mov	x0, x19
bl Lpatch + (0xa5d4 - PATCH_BASE)
cbnz	w0, LFQH_LBB235_3
LFQH_Lloh4866:
adr x0, LFQH_l_.str.405
LFQH_Lloh4867:
nop
bl Lpatch + (0xa5a4 - PATCH_BASE)
mov	x22, x0
LFQH_Lloh4868:
adr x0, LFQH_l_.str.41
LFQH_Lloh4869:
nop
bl Lpatch + (0xa5a4 - PATCH_BASE)
mov	x1, x0
mov	x0, x21
bl Lpatch + (0xa5d4 - PATCH_BASE)
mov	x2, x0
mov	x0, x19
mov	x1, x22
bl Lpatch + (0xa5d4 - PATCH_BASE)
LFQH_LBB235_3:
cbz	x20, LFQH_LBB235_6
LFQH_Lloh4870:
adr x0, LFQH_l_.str.392
LFQH_Lloh4871:
nop
bl Lpatch + (0xa5a4 - PATCH_BASE)
mov	x1, x0
mov	x0, x19
bl Lpatch + (0xa5d4 - PATCH_BASE)
cbnz	w0, LFQH_LBB235_6
LFQH_Lloh4872:
adr x0, LFQH_l_.str.402
LFQH_Lloh4873:
nop
bl Lpatch + (0xa5a4 - PATCH_BASE)
mov	x21, x0
LFQH_Lloh4874:
adr x0, LFQH_l_.str.41
LFQH_Lloh4875:
nop
bl Lpatch + (0xa5a4 - PATCH_BASE)
mov	x1, x0
mov	x0, x20
bl Lpatch + (0xa5d4 - PATCH_BASE)
mov	x2, x0
mov	x0, x19
mov	x1, x21
bl Lpatch + (0xa5d4 - PATCH_BASE)
LFQH_LBB235_6:
LFQH_Lloh4876:
adr x1, LFQH_ClipsKey
LFQH_Lloh4877:
nop
mov	x0, x19
mov	x2, #0
mov	w3, #1
bl Lpatch + (0xa634 - PATCH_BASE)
LFQH_Lloh4878:
adr x1, LFQH_OpaqueKey
LFQH_Lloh4879:
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
LFQH_Lloh4880:
adr x0, LFQH_l_.str.429
LFQH_Lloh4881:
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
LFQH_Lloh4882:
adr x0, LFQH_l_.str.429
LFQH_Lloh4883:
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
LFQH_AppearanceLabelKey:
.cfi_startproc
ret
.cfi_endproc
.p2align	2
LFQH_RestoreAppearanceFont:
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
LFQH_Lloh4884:
adr x1, LFQH_AppearanceFontAppliedKey
LFQH_Lloh4885:
nop
bl Lpatch + (0xa628 - PATCH_BASE)
cbz	x0, LFQH_LBB241_3
mov	x21, x0
LFQH_Lloh4886:
adr x1, LFQH_l_.str.441
LFQH_Lloh4887:
nop
mov	x0, x19
bl	LFQH_Get
mov	x22, x0
LFQH_Lloh4888:
adr x1, LFQH_AppearanceFontStockKey
LFQH_Lloh4889:
nop
mov	x0, x19
bl Lpatch + (0xa628 - PATCH_BASE)
mov	x20, x0
cmp	x22, x21
b.eq	LFQH_LBB241_4
LFQH_Lloh4890:
adr x0, LFQH_l_.str.49
LFQH_Lloh4891:
nop
bl Lpatch + (0xa5a4 - PATCH_BASE)
mov	x1, x0
mov	x0, x22
mov	x2, x21
bl Lpatch + (0xa5d4 - PATCH_BASE)
cmp	w0, #0
cset	w8, ne
cbnz	w8, LFQH_LBB241_5
b	LFQH_LBB241_7
LFQH_LBB241_3:
ldp	x29, x30, [sp, #32]
ldp	x20, x19, [sp, #16]
ldp	x22, x21, [sp], #48
ret
LFQH_LBB241_4:
mov	w8, #1
cbz	w8, LFQH_LBB241_7
LFQH_LBB241_5:
cbz	x20, LFQH_LBB241_7
LFQH_Lloh4892:
adr x0, LFQH_l_.str.162
LFQH_Lloh4893:
nop
bl Lpatch + (0xa5a4 - PATCH_BASE)
mov	x1, x0
mov	x0, x19
mov	x2, x20
bl Lpatch + (0xa5d4 - PATCH_BASE)
LFQH_LBB241_7:
LFQH_Lloh4894:
adr x1, LFQH_AppearanceFontStockKey
LFQH_Lloh4895:
nop
mov	x0, x19
mov	x2, #0
mov	w3, #1
bl Lpatch + (0xa634 - PATCH_BASE)
LFQH_Lloh4896:
adr x1, LFQH_AppearanceFontAppliedKey
LFQH_Lloh4897:
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
LFQH_AppearanceFont:
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
fmov	d8, d0
mov	x19, x0
LFQH_Lloh4898:
adr x1, LFQH_l_.str.36
LFQH_Lloh4899:
nop
bl	LFQH_Kind
cbz	w0, LFQH_LBB242_11
LFQH_Lloh4900:
adr x1, LFQH_l_.str.162
LFQH_Lloh4901:
nop
mov	x0, x19
bl	LFQH_Responds
cbz	w0, LFQH_LBB242_11
LFQH_Lloh4902:
adr x1, LFQH_l_.str.441
LFQH_Lloh4903:
nop
mov	x0, x19
bl	LFQH_Get
cbz	x0, LFQH_LBB242_11
mov	x20, x0
LFQH_Lloh4904:
adr x0, LFQH_l_.str.388
LFQH_Lloh4905:
nop
bl Lpatch + (0xa5a4 - PATCH_BASE)
mov	x21, x0
LFQH_Lloh4906:
adr x0, LFQH_l_.str.442
LFQH_Lloh4907:
nop
bl Lpatch + (0xa5a4 - PATCH_BASE)
mov	x2, x0
mov	x0, x20
mov	x1, x21
bl Lpatch + (0xa5d4 - PATCH_BASE)
cbz	w0, LFQH_LBB242_11
LFQH_Lloh4908:
adr x0, LFQH_l_.str.388
LFQH_Lloh4909:
nop
bl Lpatch + (0xa5a4 - PATCH_BASE)
mov	x21, x0
LFQH_Lloh4910:
adr x0, LFQH_l_.str.443
LFQH_Lloh4911:
nop
bl Lpatch + (0xa5a4 - PATCH_BASE)
mov	x2, x0
mov	x0, x20
mov	x1, x21
bl Lpatch + (0xa5d4 - PATCH_BASE)
cbz	w0, LFQH_LBB242_11
LFQH_Lloh4912:
adr x1, LFQH_AppearanceFontAppliedKey
LFQH_Lloh4913:
nop
mov	x0, x19
bl Lpatch + (0xa628 - PATCH_BASE)
cbz	x0, LFQH_LBB242_9
mov	x21, x0
cmp	x20, x0
b.eq	LFQH_LBB242_8
LFQH_Lloh4914:
adr x0, LFQH_l_.str.49
LFQH_Lloh4915:
nop
bl Lpatch + (0xa5a4 - PATCH_BASE)
mov	x1, x0
mov	x0, x20
mov	x2, x21
bl Lpatch + (0xa5d4 - PATCH_BASE)
cbz	w0, LFQH_LBB242_9
LFQH_LBB242_8:
LFQH_Lloh4916:
adr x1, LFQH_AppearanceFontStockKey
LFQH_Lloh4917:
nop
mov	x0, x19
bl Lpatch + (0xa628 - PATCH_BASE)
mov	x21, x0
mov	w22, #1
b	LFQH_LBB242_10
LFQH_LBB242_9:
mov	w22, #0
mov	x21, x20
LFQH_LBB242_10:
LFQH_Lloh4918:
adr x0, LFQH_l_.str.442
LFQH_Lloh4919:
nop
bl Lpatch + (0xa5a4 - PATCH_BASE)
mov	x1, x0
mov	x0, x21
bl Lpatch + (0xa5d4 - PATCH_BASE)
fmov	d9, d0
fmov	x8, d9
ands	x9, x8, #0x7fffffffffffffff
sub	x10, x9, #1
mov	x11, #4503599627370495
cmp	x10, x11
cset	w10, lo
mov	x11, #-4503599627370496
add	x9, x9, x11
lsr	x9, x9, #53
cmp	x9, #1023
cset	w9, lo
cmp	x8, #0
csel	w9, wzr, w9, ge
csel	w10, wzr, w10, ge
ands	x8, x8, #0x7fffffffffffffff
csinc	w10, w10, wzr, ne
mov	x11, #9218868437227405312
cmp	x8, x11
csinc	w8, w10, wzr, ne
csinc	w8, w8, wzr, le
orr	w8, w8, w9
tbz	w8, #0, LFQH_LBB242_12
LFQH_LBB242_11:
ldp	x29, x30, [sp, #48]
ldp	x20, x19, [sp, #32]
ldp	x22, x21, [sp, #16]
ldp	d9, d8, [sp], #64
ret
LFQH_LBB242_12:
LFQH_Lloh4920:
adr x1, LFQH_l_.str.444
LFQH_Lloh4921:
nop
mov	x0, x19
bl	LFQH_Get
cbnz	x0, LFQH_LBB242_20
fcmp	d9, d8
b.ls	LFQH_LBB242_20
cbz	w22, LFQH_LBB242_16
LFQH_Lloh4922:
adr x0, LFQH_l_.str.442
LFQH_Lloh4923:
nop
bl Lpatch + (0xa5a4 - PATCH_BASE)
mov	x1, x0
mov	x0, x20
bl Lpatch + (0xa5d4 - PATCH_BASE)
fcmp	d0, d8
b.eq	LFQH_LBB242_11
LFQH_LBB242_16:
LFQH_Lloh4924:
adr x0, LFQH_l_.str.443
LFQH_Lloh4925:
nop
bl Lpatch + (0xa5a4 - PATCH_BASE)
mov	x1, x0
mov	x0, x21
fmov	d0, d8
bl Lpatch + (0xa5d4 - PATCH_BASE)
cbz	x0, LFQH_LBB242_11
mov	x21, x0
tbnz	w22, #0, LFQH_LBB242_19
LFQH_Lloh4926:
adr x1, LFQH_AppearanceFontStockKey
LFQH_Lloh4927:
nop
mov	x0, x19
mov	x2, x20
mov	w3, #1
bl Lpatch + (0xa634 - PATCH_BASE)
LFQH_LBB242_19:
LFQH_Lloh4928:
adr x1, LFQH_AppearanceFontAppliedKey
LFQH_Lloh4929:
nop
mov	x0, x19
mov	x2, x21
mov	w3, #1
bl Lpatch + (0xa634 - PATCH_BASE)
LFQH_Lloh4930:
adr x0, LFQH_l_.str.162
LFQH_Lloh4931:
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
LFQH_LBB242_20:
mov	x0, x19
ldp	x29, x30, [sp, #48]
ldp	x20, x19, [sp, #32]
ldp	x22, x21, [sp, #16]
ldp	d9, d8, [sp], #64
b	LFQH_RestoreAppearanceFont
.cfi_endproc
.p2align	2
LFQH_AppearanceFontAppliedKey:
.cfi_startproc
ret
.cfi_endproc
.p2align	2
LFQH_AppearanceFontStockKey:
.cfi_startproc
ret
.cfi_endproc
.p2align	2
LFQH_GlassPreferenceKey:
.cfi_startproc
ret
.cfi_endproc
.p2align	2
LFQH_ReaderShareControl:
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
mov	x20, x0
bl	LFQH_ReaderShareCandidate
cbz	w0, LFQH_LBB246_19
LFQH_Lloh4932:
adr x1, LFQH_l_.str.471
LFQH_Lloh4933:
nop
mov	x0, x20
bl	LFQH_Get
mov	w1, #0
bl	LFQH_ReaderShareText
cbz	w0, LFQH_LBB246_3
mov	w24, #1
b	LFQH_LBB246_18
LFQH_LBB246_3:
LFQH_Lloh4934:
adr x1, LFQH_l_.str.472
LFQH_Lloh4935:
nop
mov	x0, x20
bl	LFQH_Get
mov	w1, #1
bl	LFQH_ReaderShareText
cbz	w0, LFQH_LBB246_5
mov	w24, #2
b	LFQH_LBB246_18
LFQH_LBB246_5:
LFQH_Lloh4936:
adr x1, LFQH_l_.str.42
LFQH_Lloh4937:
nop
mov	x0, x20
bl	LFQH_Kind
cbz	w0, LFQH_LBB246_16
LFQH_Lloh4938:
adr x1, LFQH_l_.str.473
LFQH_Lloh4939:
nop
mov	x0, x20
bl	LFQH_Responds
cbz	w0, LFQH_LBB246_16
LFQH_Lloh4940:
adr x1, LFQH_l_.str.474
LFQH_Lloh4941:
nop
mov	x0, x20
bl	LFQH_Get
LFQH_Lloh4942:
adr x1, LFQH_l_.str.475
LFQH_Lloh4943:
nop
bl	LFQH_Get
mov	x21, x0
LFQH_Lloh4944:
adr x1, LFQH_l_.str.33
LFQH_Lloh4945:
nop
bl	LFQH_Kind
cbz	w0, LFQH_LBB246_16
LFQH_Lloh4946:
adr x0, LFQH_l_.str.34
LFQH_Lloh4947:
nop
bl Lpatch + (0xa5a4 - PATCH_BASE)
mov	x1, x0
mov	x0, x21
bl Lpatch + (0xa5d4 - PATCH_BASE)
cmp	x0, #8
mov	w8, #8
csel	x25, x0, x8, lo
cbz	x0, LFQH_LBB246_16
mov	x22, #0
LFQH_Lloh4948:
adr x23, LFQH_l_.str.461
LFQH_Lloh4949:
nop
mov	w24, #3
LFQH_LBB246_10:
mov	x0, x23
bl Lpatch + (0xa5a4 - PATCH_BASE)
mov	x1, x0
mov	x0, x21
mov	x2, x22
bl Lpatch + (0xa5d4 - PATCH_BASE)
mov	x27, x0
LFQH_Lloh4950:
adr x1, LFQH_l_.str.476
LFQH_Lloh4951:
nop
bl	LFQH_Kind
cmp	w0, #0
csel	x27, x27, xzr, eq
LFQH_Lloh4952:
adr x0, LFQH_l_.str.473
LFQH_Lloh4953:
nop
bl Lpatch + (0xa5a4 - PATCH_BASE)
mov	x1, x0
mov	x0, x20
mov	x2, x27
mov	w3, #64
bl Lpatch + (0xa5d4 - PATCH_BASE)
mov	x28, x0
LFQH_Lloh4954:
adr x1, LFQH_l_.str.33
LFQH_Lloh4955:
nop
bl	LFQH_Kind
cbz	w0, LFQH_LBB246_15
LFQH_Lloh4956:
adr x0, LFQH_l_.str.34
LFQH_Lloh4957:
nop
bl Lpatch + (0xa5a4 - PATCH_BASE)
mov	x1, x0
mov	x0, x28
bl Lpatch + (0xa5d4 - PATCH_BASE)
cmp	x0, #8
mov	w8, #8
csel	x26, x0, x8, lo
cbz	x0, LFQH_LBB246_15
mov	x27, #0
LFQH_LBB246_13:
mov	x0, x23
bl Lpatch + (0xa5a4 - PATCH_BASE)
mov	x1, x0
mov	x0, x28
mov	x2, x27
bl Lpatch + (0xa5d4 - PATCH_BASE)
mov	w1, #1
bl	LFQH_ReaderShareText
cbnz	w0, LFQH_LBB246_18
add	x27, x27, #1
cmp	x26, x27
b.ne	LFQH_LBB246_13
LFQH_LBB246_15:
add	x22, x22, #1
cmp	x22, x25
b.ne	LFQH_LBB246_10
LFQH_LBB246_16:
mov	x0, x20
bl Lpatch + (0xa664 - PATCH_BASE)
LFQH_Lloh4958:
adr x1, LFQH_l_.str.101
LFQH_Lloh4959:
nop
bl	LFQH_Get
mov	w1, #1
bl	LFQH_ReaderShareText
cbz	w0, LFQH_LBB246_19
mov	w24, #5
LFQH_LBB246_18:
str	x24, [x19]
mov	w0, #1
LFQH_LBB246_19:
ldp	x29, x30, [sp, #80]
ldp	x20, x19, [sp, #64]
ldp	x22, x21, [sp, #48]
ldp	x24, x23, [sp, #32]
ldp	x26, x25, [sp, #16]
ldp	x28, x27, [sp], #96
ret
.cfi_endproc
.p2align	2
LFQH_ReaderShareCandidate:
.cfi_startproc
stp	d15, d14, [sp, #-128]!
stp	d13, d12, [sp, #16]
stp	d11, d10, [sp, #32]
stp	d9, d8, [sp, #48]
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
.cfi_offset b8, -72
.cfi_offset b9, -80
.cfi_offset b10, -88
.cfi_offset b11, -96
.cfi_offset b12, -104
.cfi_offset b13, -112
.cfi_offset b14, -120
.cfi_offset b15, -128
mov	x19, x1
mov	x20, x0
LFQH_Lloh4960:
adr x1, LFQH_l_.str.23
LFQH_Lloh4961:
nop
bl	LFQH_Kind
cmp	w0, #0
ccmp	x20, #0, #4, ne
b.eq	LFQH_LBB247_6
mov	w22, #0
LFQH_Lloh4962:
adr x21, LFQH_l_.str.20
LFQH_Lloh4963:
nop
mov	x8, x20
LFQH_LBB247_2:
cmp	x8, x19
b.eq	LFQH_LBB247_5
mov	x0, x8
mov	x1, x21
bl	LFQH_Get
mov	x8, x0
mov	w0, #0
cbz	x8, LFQH_LBB247_7
add	w9, w22, #1
cmp	w22, #7
mov	x22, x9
b.lo	LFQH_LBB247_2
b	LFQH_LBB247_7
LFQH_LBB247_5:
LFQH_Lloh4964:
adr x0, LFQH_l_.str.71
LFQH_Lloh4965:
nop
bl Lpatch + (0xa5a4 - PATCH_BASE)
mov	x1, x0
mov	x0, x20
bl Lpatch + (0xa5d4 - PATCH_BASE)
cbz	w0, LFQH_LBB247_8
LFQH_LBB247_6:
mov	w0, #0
LFQH_LBB247_7:
ldp	x29, x30, [sp, #112]
ldp	x20, x19, [sp, #96]
ldp	x22, x21, [sp, #80]
ldp	x24, x23, [sp, #64]
ldp	d9, d8, [sp, #48]
ldp	d11, d10, [sp, #32]
ldp	d13, d12, [sp, #16]
ldp	d15, d14, [sp], #128
ret
LFQH_LBB247_8:
LFQH_Lloh4966:
adr x21, LFQH_l_.str.71
LFQH_Lloh4967:
nop
LFQH_Lloh4968:
adr x22, LFQH_l_.str.477
LFQH_Lloh4969:
nop
LFQH_Lloh4970:
adr x8, LFQH_lCPI247_0
LFQH_Lloh4971:
ldr d8, [x8]
and x8, x8, #0xfffffffffffff000
LFQH_Lloh4972:
adr x23, LFQH_l_.str.20
LFQH_Lloh4973:
nop
mov	x24, x20
LFQH_LBB247_9:
mov	x0, x21
bl Lpatch + (0xa5a4 - PATCH_BASE)
mov	x1, x0
mov	x0, x24
bl Lpatch + (0xa5d4 - PATCH_BASE)
cbnz	w0, LFQH_LBB247_6
mov	x0, x22
bl Lpatch + (0xa5a4 - PATCH_BASE)
mov	x1, x0
mov	x0, x24
bl Lpatch + (0xa5d4 - PATCH_BASE)
fcmp	d0, d8
b.ls	LFQH_LBB247_6
cmp	x24, x19
b.eq	LFQH_LBB247_13
mov	x0, x24
mov	x1, x23
bl	LFQH_Get
mov	x24, x0
cbnz	x0, LFQH_LBB247_9
LFQH_LBB247_13:
LFQH_Lloh4974:
adr x0, LFQH_l_.str.24
LFQH_Lloh4975:
nop
bl Lpatch + (0xa5a4 - PATCH_BASE)
mov	x1, x0
mov	x0, x20
bl Lpatch + (0xa5d4 - PATCH_BASE)
fmov	d12, d0
fmov	d13, d1
fmov	d14, d2
fmov	d15, d3
fmov	x8, d14
fmov	x9, d13
fmov	x10, d12
and	x11, x10, #0x7fffffffffffffff
and	x9, x9, #0x7fffffffffffffff
mov	x12, #9218868437227405311
cmp	x9, x12
cset	w9, gt
and	x8, x8, #0x7fffffffffffffff
cmp	x8, x12
cset	w10, gt
mov	w8, #1
cmp	x11, x12
b.gt	LFQH_LBB247_17
tbnz	w9, #0, LFQH_LBB247_17
tbnz	w10, #0, LFQH_LBB247_17
fmov	x8, d15
and	x8, x8, #0x7fffffffffffffff
fcmp	d14, #0.0
cset	w9, le
fcmp	d15, #0.0
csinc	w9, w9, wzr, gt
mov	x10, #9218868437227405311
cmp	x8, x10
csinc	w8, w9, wzr, le
LFQH_LBB247_17:
mov	w0, #0
tbnz	w8, #0, LFQH_LBB247_7
fmov	d0, #16.00000000
fcmp	d14, d0
b.mi	LFQH_LBB247_7
fcmp	d15, d0
b.mi	LFQH_LBB247_7
mov	x8, #4634204016564240384
fmov	d0, x8
fcmp	d14, d0
b.gt	LFQH_LBB247_7
fmov	d0, x8
fcmp	d15, d0
b.gt	LFQH_LBB247_7
LFQH_Lloh4976:
adr x0, LFQH_l_.str.24
LFQH_Lloh4977:
nop
bl Lpatch + (0xa5a4 - PATCH_BASE)
mov	x1, x0
mov	x0, x19
bl Lpatch + (0xa5d4 - PATCH_BASE)
fmov	d9, d0
fmov	d8, d1
fmov	d11, d2
fmov	d10, d3
fmov	x21, d11
fmov	x22, d8
fmov	x23, d9
LFQH_Lloh4978:
adr x0, LFQH_l_.str.507
LFQH_Lloh4979:
nop
bl Lpatch + (0xa5a4 - PATCH_BASE)
mov	x1, x0
mov	x0, x20
fmov	d0, d12
fmov	d1, d13
fmov	d2, d14
fmov	d3, d15
mov	x2, x19
bl Lpatch + (0xa5d4 - PATCH_BASE)
mov	w0, #0
and	x10, x23, #0x7fffffffffffffff
and	x8, x22, #0x7fffffffffffffff
mov	x11, #9218868437227405311
cmp	x8, x11
cset	w8, gt
and	x9, x21, #0x7fffffffffffffff
cmp	x9, x11
cset	w9, gt
cmp	x10, x11
b.gt	LFQH_LBB247_7
tbnz	w8, #0, LFQH_LBB247_7
tbnz	w9, #0, LFQH_LBB247_7
mov	w0, #0
fmov	x8, d10
and	x8, x8, #0x7fffffffffffffff
mov	x9, #9218868437227405311
cmp	x8, x9
b.gt	LFQH_LBB247_7
fcmp	d11, #0.0
b.le	LFQH_LBB247_7
fcmp	d10, #0.0
b.le	LFQH_LBB247_7
mov	w8, #0
fmov	x9, d0
and	x11, x9, #0x7fffffffffffffff
fmov	x9, d1
and	x9, x9, #0x7fffffffffffffff
mov	x12, #9218868437227405311
cmp	x9, x12
cset	w9, gt
fmov	x10, d2
and	x10, x10, #0x7fffffffffffffff
cmp	x10, x12
cset	w10, gt
cmp	x11, x12
b.gt	LFQH_LBB247_32
tbnz	w9, #0, LFQH_LBB247_32
tbnz	w10, #0, LFQH_LBB247_32
fmov	x8, d3
and	x8, x8, #0x7fffffffffffffff
fcmp	d2, #0.0
cset	w9, gt
fcmp	d3, #0.0
csel	w9, wzr, w9, le
mov	x10, #9218868437227405312
cmp	x8, x10
csel	w8, wzr, w9, ge
LFQH_LBB247_32:
mov	w0, #0
cbz	w8, LFQH_LBB247_7
fadd	d4, d9, d11
fcmp	d0, d4
b.pl	LFQH_LBB247_7
fadd	d4, d8, d10
fcmp	d1, d4
b.pl	LFQH_LBB247_7
fadd	d0, d0, d2
fcmp	d0, d9
b.le	LFQH_LBB247_7
fadd	d0, d1, d3
fcmp	d0, d8
cset	w0, gt
b	LFQH_LBB247_7
.cfi_endproc
.p2align	2
LFQH_ReaderShareText:
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
LFQH_Lloh4980:
adr x1, LFQH_l_.str.361
LFQH_Lloh4981:
nop
bl	LFQH_Kind
cbz	w0, LFQH_LBB248_10
LFQH_Lloh4982:
adr x0, LFQH_l_.str.478
LFQH_Lloh4983:
nop
bl Lpatch + (0xa5a4 - PATCH_BASE)
mov	x1, x0
mov	x0, x19
bl Lpatch + (0xa5d4 - PATCH_BASE)
mov	x19, x0
cbz	w20, LFQH_LBB248_5
LFQH_Lloh4984:
adr x0, LFQH_l_.str.479
LFQH_Lloh4985:
nop
bl Lpatch + (0xa5a4 - PATCH_BASE)
mov	x20, x0
LFQH_Lloh4986:
adr x0, LFQH_l_.str.361
LFQH_Lloh4987:
nop
bl Lpatch + (0xa5b0 - PATCH_BASE)
mov	x21, x0
LFQH_Lloh4988:
adr x0, LFQH_l_.str.387
LFQH_Lloh4989:
nop
bl Lpatch + (0xa5a4 - PATCH_BASE)
mov	x1, x0
LFQH_Lloh4990:
adr x2, LFQH_l_.str.480
LFQH_Lloh4991:
nop
mov	x0, x21
bl Lpatch + (0xa5d4 - PATCH_BASE)
mov	x2, x0
mov	x0, x19
mov	x1, x20
bl Lpatch + (0xa5d4 - PATCH_BASE)
cbnz	w0, LFQH_LBB248_9
LFQH_Lloh4992:
adr x0, LFQH_l_.str.479
LFQH_Lloh4993:
nop
bl Lpatch + (0xa5a4 - PATCH_BASE)
mov	x20, x0
LFQH_Lloh4994:
adr x0, LFQH_l_.str.361
LFQH_Lloh4995:
nop
bl Lpatch + (0xa5b0 - PATCH_BASE)
mov	x21, x0
LFQH_Lloh4996:
adr x0, LFQH_l_.str.387
LFQH_Lloh4997:
nop
bl Lpatch + (0xa5a4 - PATCH_BASE)
mov	x1, x0
LFQH_Lloh4998:
adr x2, LFQH_l_.str.481
LFQH_Lloh4999:
nop
mov	x0, x21
bl Lpatch + (0xa5d4 - PATCH_BASE)
mov	x2, x0
mov	x0, x19
mov	x1, x20
bl Lpatch + (0xa5d4 - PATCH_BASE)
LFQH_LBB248_4:
cmp	w0, #0
cset	w0, ne
b	LFQH_LBB248_10
LFQH_LBB248_5:
LFQH_Lloh5000:
adr x1, LFQH_l_.str.481
LFQH_Lloh5001:
nop
mov	x0, x19
bl	LFQH_Equal
cbnz	w0, LFQH_LBB248_9
LFQH_Lloh5002:
adr x1, LFQH_l_.str.482
LFQH_Lloh5003:
nop
mov	x0, x19
bl	LFQH_Equal
cbnz	w0, LFQH_LBB248_9
LFQH_Lloh5004:
adr x1, LFQH_l_.str.483
LFQH_Lloh5005:
nop
mov	x0, x19
bl	LFQH_Equal
cbnz	w0, LFQH_LBB248_9
LFQH_Lloh5006:
adr x1, LFQH_l_.str.480
LFQH_Lloh5007:
nop
mov	x0, x19
bl	LFQH_Equal
cbz	w0, LFQH_LBB248_11
LFQH_LBB248_9:
mov	w0, #1
LFQH_LBB248_10:
ldp	x29, x30, [sp, #32]
ldp	x20, x19, [sp, #16]
ldp	x22, x21, [sp], #48
ret
LFQH_LBB248_11:
LFQH_Lloh5008:
adr x1, LFQH_l_.str.484
LFQH_Lloh5009:
nop
mov	x0, x19
bl	LFQH_Equal
b	LFQH_LBB248_4
.cfi_endproc
.p2align	2
LFQH_ReaderShareHitParentsKey:
.cfi_startproc
ret
.cfi_endproc
.p2align	2
LFQH_ReaderShareResolutionKey:
.cfi_startproc
ret
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
LFQH_Lloh5010:
adr x1, LFQH_HeaderClipsKey
LFQH_Lloh5011:
nop
bl Lpatch + (0xa628 - PATCH_BASE)
mov	x23, x0
LFQH_Lloh5012:
adr x1, LFQH_HeaderOpaqueKey
LFQH_Lloh5013:
nop
mov	x0, x19
bl Lpatch + (0xa628 - PATCH_BASE)
mov	x22, x0
LFQH_Lloh5014:
adr x1, LFQH_HeaderRadiusKey
LFQH_Lloh5015:
nop
mov	x0, x19
bl Lpatch + (0xa628 - PATCH_BASE)
mov	x20, x0
LFQH_Lloh5016:
adr x1, LFQH_HeaderAppliedRadiusKey
LFQH_Lloh5017:
nop
mov	x0, x19
bl Lpatch + (0xa628 - PATCH_BASE)
mov	x21, x0
cbz	x23, LFQH_LBB253_3
LFQH_Lloh5018:
adr x0, LFQH_l_.str.391
LFQH_Lloh5019:
nop
bl Lpatch + (0xa5a4 - PATCH_BASE)
mov	x1, x0
mov	x0, x19
bl Lpatch + (0xa5d4 - PATCH_BASE)
cbz	w0, LFQH_LBB253_3
LFQH_Lloh5020:
adr x0, LFQH_l_.str.405
LFQH_Lloh5021:
nop
bl Lpatch + (0xa5a4 - PATCH_BASE)
mov	x24, x0
LFQH_Lloh5022:
adr x0, LFQH_l_.str.41
LFQH_Lloh5023:
nop
bl Lpatch + (0xa5a4 - PATCH_BASE)
mov	x1, x0
mov	x0, x23
bl Lpatch + (0xa5d4 - PATCH_BASE)
mov	x2, x0
mov	x0, x19
mov	x1, x24
bl Lpatch + (0xa5d4 - PATCH_BASE)
LFQH_LBB253_3:
cbz	x22, LFQH_LBB253_6
LFQH_Lloh5024:
adr x0, LFQH_l_.str.392
LFQH_Lloh5025:
nop
bl Lpatch + (0xa5a4 - PATCH_BASE)
mov	x1, x0
mov	x0, x19
bl Lpatch + (0xa5d4 - PATCH_BASE)
cbnz	w0, LFQH_LBB253_6
LFQH_Lloh5026:
adr x0, LFQH_l_.str.402
LFQH_Lloh5027:
nop
bl Lpatch + (0xa5a4 - PATCH_BASE)
mov	x23, x0
LFQH_Lloh5028:
adr x0, LFQH_l_.str.41
LFQH_Lloh5029:
nop
bl Lpatch + (0xa5a4 - PATCH_BASE)
mov	x1, x0
mov	x0, x22
bl Lpatch + (0xa5d4 - PATCH_BASE)
mov	x2, x0
mov	x0, x19
mov	x1, x23
bl Lpatch + (0xa5d4 - PATCH_BASE)
LFQH_LBB253_6:
cbz	x20, LFQH_LBB253_10
cbz	x21, LFQH_LBB253_10
LFQH_Lloh5030:
adr x0, LFQH_l_.str.403
LFQH_Lloh5031:
nop
bl Lpatch + (0xa5a4 - PATCH_BASE)
mov	x1, x0
mov	x0, x19
bl Lpatch + (0xa5d4 - PATCH_BASE)
mov	x22, x0
LFQH_Lloh5032:
adr x0, LFQH_l_.str.404
LFQH_Lloh5033:
nop
bl Lpatch + (0xa5a4 - PATCH_BASE)
mov	x1, x0
mov	x0, x22
bl Lpatch + (0xa5d4 - PATCH_BASE)
fmov	d8, d0
LFQH_Lloh5034:
adr x0, LFQH_l_.str.445
LFQH_Lloh5035:
nop
bl Lpatch + (0xa5a4 - PATCH_BASE)
mov	x1, x0
mov	x0, x21
bl Lpatch + (0xa5d4 - PATCH_BASE)
fcmp	d8, d0
b.ne	LFQH_LBB253_10
LFQH_Lloh5036:
adr x0, LFQH_l_.str.445
LFQH_Lloh5037:
nop
bl Lpatch + (0xa5a4 - PATCH_BASE)
mov	x1, x0
mov	x0, x20
bl Lpatch + (0xa5d4 - PATCH_BASE)
fmov	d8, d0
LFQH_Lloh5038:
adr x0, LFQH_l_.str.403
LFQH_Lloh5039:
nop
bl Lpatch + (0xa5a4 - PATCH_BASE)
mov	x1, x0
mov	x0, x19
bl Lpatch + (0xa5d4 - PATCH_BASE)
mov	x20, x0
LFQH_Lloh5040:
adr x0, LFQH_l_.str.406
LFQH_Lloh5041:
nop
bl Lpatch + (0xa5a4 - PATCH_BASE)
mov	x1, x0
mov	x0, x20
fmov	d0, d8
bl Lpatch + (0xa5d4 - PATCH_BASE)
LFQH_LBB253_10:
LFQH_Lloh5042:
adr x1, LFQH_HeaderClipsKey
LFQH_Lloh5043:
nop
mov	x0, x19
mov	x2, #0
mov	w3, #1
bl Lpatch + (0xa634 - PATCH_BASE)
LFQH_Lloh5044:
adr x1, LFQH_HeaderOpaqueKey
LFQH_Lloh5045:
nop
mov	x0, x19
mov	x2, #0
mov	w3, #1
bl Lpatch + (0xa634 - PATCH_BASE)
LFQH_Lloh5046:
adr x1, LFQH_HeaderRadiusKey
LFQH_Lloh5047:
nop
mov	x0, x19
mov	x2, #0
mov	w3, #1
bl Lpatch + (0xa634 - PATCH_BASE)
LFQH_Lloh5048:
adr x1, LFQH_HeaderAppliedRadiusKey
LFQH_Lloh5049:
nop
mov	x0, x19
mov	x2, #0
mov	w3, #1
bl Lpatch + (0xa634 - PATCH_BASE)
LFQH_Lloh5050:
adr x1, LFQH_HeaderLogKey
LFQH_Lloh5051:
nop
mov	x0, x19
mov	x2, #0
mov	w3, #1
bl Lpatch + (0xa634 - PATCH_BASE)
LFQH_Lloh5052:
adr x1, LFQH_HeaderLogTimeKey
LFQH_Lloh5053:
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
LFQH_Lloh5054:
adr x1, LFQH_l_.str.502
LFQH_Lloh5055:
nop
bl	LFQH_Get
mov	x19, x0
LFQH_Lloh5056:
adr x1, LFQH_l_.str.503
LFQH_Lloh5057:
nop
bl	LFQH_Kind
cbz	w0, LFQH_LBB254_3
mov	x0, x19
bl Lpatch + (0xa664 - PATCH_BASE)
LFQH_Lloh5058:
adr x1, LFQH_l_.str.504
LFQH_Lloh5059:
nop
LFQH_Lloh5060:
adr x2, LFQH_l_.str.505
LFQH_Lloh5061:
nop
bl	LFQH_ClassABI
cbz	w0, LFQH_LBB254_3
LFQH_Lloh5062:
adr x0, LFQH_l_.str.504
LFQH_Lloh5063:
nop
bl Lpatch + (0xa5a4 - PATCH_BASE)
mov	x1, x0
mov	x0, x19
ldp	x29, x30, [sp, #16]
ldp	x20, x19, [sp], #32
b Lpatch + (0xa5d4 - PATCH_BASE)
LFQH_LBB254_3:
mov	w0, #0
ldp	x29, x30, [sp, #16]
ldp	x20, x19, [sp], #32
ret
.cfi_endproc
.p2align	2
LFQH_DramaGlassKey:
.cfi_startproc
ret
.cfi_endproc
.p2align	2
LFQH_DramaWatchContentKey:
.cfi_startproc
ret
.cfi_endproc
.p2align	2
LFQH_ShelfEditHeaderKey:
.cfi_startproc
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
LFQH_Lloh5064:
adr x0, LFQH_l_.str.467
LFQH_Lloh5065:
nop
bl Lpatch + (0xa5b0 - PATCH_BASE)
mov	x20, x0
LFQH_Lloh5066:
adr x0, LFQH_l_.str.468
LFQH_Lloh5067:
nop
bl Lpatch + (0xa5a4 - PATCH_BASE)
mov	x1, x0
mov	x0, x20
bl Lpatch + (0xa5d4 - PATCH_BASE)
mov	x20, x0
LFQH_Lloh5068:
adr x0, LFQH_l_.str.536
LFQH_Lloh5069:
nop
bl Lpatch + (0xa5a4 - PATCH_BASE)
mov	x1, x0
mov	x0, x20
mov	x2, x19
bl Lpatch + (0xa5d4 - PATCH_BASE)
cbz	x0, LFQH_LBB258_2
LFQH_Lloh5070:
adr x1, LFQH_l_.str.41
LFQH_Lloh5071:
nop
ldp	x29, x30, [sp, #16]
ldp	x20, x19, [sp], #32
b	LFQH_BoolProp
LFQH_LBB258_2:
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
cmp	x0, #5
b.le	LFQH_LBB259_6
cmp	x0, #8
b.gt	LFQH_LBB259_11
cmp	x0, #6
b.eq	LFQH_LBB259_23
cmp	x0, #7
b.eq	LFQH_LBB259_20
cmp	x0, #8
b.ne	LFQH_LBB259_26
LFQH_Lloh5072:
adr x19, LFQH_l_.str.544
LFQH_Lloh5073:
nop
b	LFQH_LBB259_25
LFQH_LBB259_6:
cmp	x0, #2
b.le	LFQH_LBB259_15
cmp	x0, #3
b.eq	LFQH_LBB259_22
cmp	x0, #4
b.eq	LFQH_LBB259_19
cmp	x0, #5
b.ne	LFQH_LBB259_26
LFQH_Lloh5074:
adr x19, LFQH_l_.str.541
LFQH_Lloh5075:
nop
b	LFQH_LBB259_25
LFQH_LBB259_11:
cmp	x0, #9
b.eq	LFQH_LBB259_24
cmp	x0, #10
b.eq	LFQH_LBB259_21
cmp	x0, #11
b.ne	LFQH_LBB259_26
LFQH_Lloh5076:
adr x19, LFQH_l_.str.547
LFQH_Lloh5077:
nop
b	LFQH_LBB259_25
LFQH_LBB259_15:
cmp	x0, #1
b.eq	LFQH_LBB259_18
cmp	x0, #2
b.ne	LFQH_LBB259_26
LFQH_Lloh5078:
adr x19, LFQH_l_.str.538
LFQH_Lloh5079:
nop
b	LFQH_LBB259_25
LFQH_LBB259_18:
LFQH_Lloh5080:
adr x19, LFQH_l_.str.537
LFQH_Lloh5081:
nop
b	LFQH_LBB259_25
LFQH_LBB259_19:
LFQH_Lloh5082:
adr x19, LFQH_l_.str.540
LFQH_Lloh5083:
nop
b	LFQH_LBB259_25
LFQH_LBB259_20:
LFQH_Lloh5084:
adr x19, LFQH_l_.str.543
LFQH_Lloh5085:
nop
b	LFQH_LBB259_25
LFQH_LBB259_21:
LFQH_Lloh5086:
adr x19, LFQH_l_.str.546
LFQH_Lloh5087:
nop
b	LFQH_LBB259_25
LFQH_LBB259_22:
LFQH_Lloh5088:
adr x19, LFQH_l_.str.539
LFQH_Lloh5089:
nop
b	LFQH_LBB259_25
LFQH_LBB259_23:
LFQH_Lloh5090:
adr x19, LFQH_l_.str.542
LFQH_Lloh5091:
nop
b	LFQH_LBB259_25
LFQH_LBB259_24:
LFQH_Lloh5092:
adr x19, LFQH_l_.str.545
LFQH_Lloh5093:
nop
LFQH_LBB259_25:
LFQH_Lloh5094:
adr x0, LFQH_l_.str.361
LFQH_Lloh5095:
nop
bl Lpatch + (0xa5b0 - PATCH_BASE)
mov	x20, x0
LFQH_Lloh5096:
adr x0, LFQH_l_.str.387
LFQH_Lloh5097:
nop
bl Lpatch + (0xa5a4 - PATCH_BASE)
mov	x1, x0
mov	x0, x20
mov	x2, x19
ldp	x29, x30, [sp, #16]
ldp	x20, x19, [sp], #32
b Lpatch + (0xa5d4 - PATCH_BASE)
LFQH_LBB259_26:
mov	x0, #0
ldp	x29, x30, [sp, #16]
ldp	x20, x19, [sp], #32
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
LFQH_Lloh5098:
adr x1, LFQH_l_.str.138
LFQH_Lloh5099:
nop
bl	LFQH_Kind
cbz	w0, LFQH_LBB260_26
LFQH_Lloh5100:
adr x1, LFQH_ShelfEditInsetsKey
LFQH_Lloh5101:
nop
mov	x0, x19
bl Lpatch + (0xa628 - PATCH_BASE)
mov	x20, x0
bl	LFQH_Enabled
cbz	w0, LFQH_LBB260_3
bl	LFQH_FQHGlassAvailable
cmp	w0, #0
cset	w21, ne
cbz	x20, LFQH_LBB260_4
b	LFQH_LBB260_5
LFQH_LBB260_3:
mov	w21, #0
cbnz	x20, LFQH_LBB260_5
LFQH_LBB260_4:
cbz	w21, LFQH_LBB260_26
LFQH_LBB260_5:
LFQH_Lloh5102:
adr x0, LFQH_l_.str.548
LFQH_Lloh5103:
nop
bl Lpatch + (0xa5a4 - PATCH_BASE)
mov	x1, x0
mov	x0, x19
bl Lpatch + (0xa5d4 - PATCH_BASE)
fmov	d8, d0
fmov	d9, d1
fmov	d12, d2
fmov	d13, d3
stp	d3, d2, [sp]
cbz	x20, LFQH_LBB260_16
LFQH_Lloh5104:
adr x0, LFQH_l_.str.432
LFQH_Lloh5105:
nop
bl Lpatch + (0xa5a4 - PATCH_BASE)
mov	x1, x0
mov	x0, x20
bl Lpatch + (0xa5d4 - PATCH_BASE)
fmaxnm	d4, d1, d3
fmov	d5, #12.00000000
fmaxnm	d4, d4, d5
fmaxnm	d5, d0, d2
fmov	d6, #7.00000000
fmaxnm	d5, d5, d6
fcmp	d8, d5
fccmp	d9, d4, #0, eq
fccmp	d12, d5, #0, eq
fccmp	d13, d4, #0, eq
fmov	d11, d8
fmov	d10, d9
b.ne	LFQH_LBB260_8
fmov	d11, d0
fmov	d10, d1
fmov	d12, d2
fmov	d13, d3
LFQH_LBB260_8:
cbz	w21, LFQH_LBB260_17
LFQH_LBB260_9:
fmaxnm	d0, d10, d13
fmov	d1, #12.00000000
fmaxnm	d14, d0, d1
fmaxnm	d0, d11, d12
fmov	d1, #7.00000000
fmaxnm	d15, d0, d1
fcmp	d11, d15
fccmp	d10, d14, #0, eq
fccmp	d12, d15, #0, eq
fccmp	d13, d14, #0, eq
b.eq	LFQH_LBB260_18
cbz	x20, LFQH_LBB260_20
LFQH_Lloh5106:
adr x0, LFQH_l_.str.432
LFQH_Lloh5107:
nop
bl Lpatch + (0xa5a4 - PATCH_BASE)
mov	x1, x0
mov	x0, x20
bl Lpatch + (0xa5d4 - PATCH_BASE)
fcmp	d11, d0
b.ne	LFQH_LBB260_20
fcmp	d10, d1
b.ne	LFQH_LBB260_20
fcmp	d12, d2
b.ne	LFQH_LBB260_20
fcmp	d13, d3
b.ne	LFQH_LBB260_20
fmov	d12, d15
fmov	d13, d14
b	LFQH_LBB260_22
LFQH_LBB260_16:
fmov	d11, d8
fmov	d10, d9
cbnz	w21, LFQH_LBB260_9
LFQH_LBB260_17:
fmov	d15, d11
fmov	d14, d10
cbnz	x20, LFQH_LBB260_19
b	LFQH_LBB260_22
LFQH_LBB260_18:
fmov	d12, d15
fmov	d13, d14
cbz	x20, LFQH_LBB260_22
LFQH_LBB260_19:
mov	x2, #0
b	LFQH_LBB260_21
LFQH_LBB260_20:
LFQH_Lloh5108:
adr x0, LFQH_l_.str.512
LFQH_Lloh5109:
nop
bl Lpatch + (0xa5b0 - PATCH_BASE)
mov	x20, x0
LFQH_Lloh5110:
adr x0, LFQH_l_.str.513
LFQH_Lloh5111:
nop
bl Lpatch + (0xa5a4 - PATCH_BASE)
mov	x1, x0
mov	x0, x20
fmov	d0, d11
fmov	d1, d10
fmov	d2, d12
fmov	d3, d13
bl Lpatch + (0xa5d4 - PATCH_BASE)
mov	x2, x0
fmov	d12, d15
fmov	d13, d14
LFQH_LBB260_21:
LFQH_Lloh5112:
adr x1, LFQH_ShelfEditInsetsKey
LFQH_Lloh5113:
nop
mov	x0, x19
mov	w3, #1
bl Lpatch + (0xa634 - PATCH_BASE)
LFQH_LBB260_22:
fcmp	d8, d15
b.ne	LFQH_LBB260_27
fcmp	d9, d14
b.ne	LFQH_LBB260_27
ldr	d0, [sp, #8]
fcmp	d0, d12
b.ne	LFQH_LBB260_27
ldr	d0, [sp]
fcmp	d0, d13
b.ne	LFQH_LBB260_27
LFQH_LBB260_26:
ldp	x29, x30, [sp, #112]
ldp	x20, x19, [sp, #96]
ldp	x22, x21, [sp, #80]
ldp	d9, d8, [sp, #64]
ldp	d11, d10, [sp, #48]
ldp	d13, d12, [sp, #32]
ldp	d15, d14, [sp, #16]
add	sp, sp, #128
ret
LFQH_LBB260_27:
LFQH_Lloh5114:
adr x0, LFQH_l_.str.549
LFQH_Lloh5115:
nop
bl Lpatch + (0xa5a4 - PATCH_BASE)
mov	x1, x0
mov	x0, x19
fmov	d0, d15
fmov	d1, d14
fmov	d2, d12
fmov	d3, d13
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
LFQH_Lloh5116:
adr x1, LFQH_l_.str.120
LFQH_Lloh5117:
nop
bl	LFQH_Get
mov	x22, x0
LFQH_Lloh5118:
adr x1, LFQH_l_.str.526
LFQH_Lloh5119:
nop
bl	LFQH_Get
mov	x19, x0
LFQH_Lloh5120:
adr x1, LFQH_l_.str.324
LFQH_Lloh5121:
nop
mov	x0, x22
bl	LFQH_Kind
fmov	d8, xzr
cbz	w0, LFQH_LBB261_5
LFQH_Lloh5122:
adr x1, LFQH_l_.str.550
LFQH_Lloh5123:
nop
mov	x0, x22
bl	LFQH_Get
cmp	x0, x23
ccmp	x19, #0, #4, eq
b.eq	LFQH_LBB261_5
LFQH_Lloh5124:
adr x1, LFQH_l_.str.551
LFQH_Lloh5125:
nop
mov	x0, x22
bl	LFQH_Get
cmp	x0, x20
b.ne	LFQH_LBB261_5
LFQH_Lloh5126:
adr x1, LFQH_l_.str.20
LFQH_Lloh5127:
nop
mov	x0, x20
bl	LFQH_Get
cmp	x0, x19
b.ne	LFQH_LBB261_5
LFQH_Lloh5128:
adr x0, LFQH_l_.str.391
LFQH_Lloh5129:
nop
bl Lpatch + (0xa5a4 - PATCH_BASE)
mov	x1, x0
mov	x0, x20
bl Lpatch + (0xa5d4 - PATCH_BASE)
cbz	w0, LFQH_LBB261_7
LFQH_LBB261_5:
fmov	d1, xzr
fmov	d2, xzr
fmov	d3, xzr
LFQH_LBB261_6:
fmov	d0, d8
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
LFQH_LBB261_7:
mov	x0, x20
bl	LFQH_CanExpandHit
cbz	w0, LFQH_LBB261_5
LFQH_Lloh5130:
adr x1, LFQH_l_.str.38
LFQH_Lloh5131:
nop
mov	x0, x23
bl	LFQH_Get
mov	x24, x0
LFQH_Lloh5132:
adr x1, LFQH_l_.str.39
LFQH_Lloh5133:
nop
mov	x0, x23
bl	LFQH_Get
mov	x23, x0
LFQH_Lloh5134:
adr x0, LFQH_l_.str.71
LFQH_Lloh5135:
nop
bl Lpatch + (0xa5a4 - PATCH_BASE)
mov	x1, x0
mov	x0, x24
bl Lpatch + (0xa5d4 - PATCH_BASE)
cmp	w0, #0
csel	x23, x24, x23, eq
LFQH_Lloh5136:
adr x1, LFQH_l_.str.552
LFQH_Lloh5137:
nop
mov	x0, x22
bl	LFQH_Get
mov	x22, x0
LFQH_Lloh5138:
adr x1, LFQH_l_.str.74
LFQH_Lloh5139:
nop
mov	x0, x20
bl	LFQH_Get
cbz	x0, LFQH_LBB261_5
mov	x24, x0
LFQH_Lloh5140:
adr x1, LFQH_l_.str.74
LFQH_Lloh5141:
nop
mov	x0, x22
bl	LFQH_Get
cmp	x0, x24
b.ne	LFQH_LBB261_5
LFQH_Lloh5142:
adr x0, LFQH_l_.str.71
LFQH_Lloh5143:
nop
bl Lpatch + (0xa5a4 - PATCH_BASE)
mov	x1, x0
mov	x0, x22
bl Lpatch + (0xa5d4 - PATCH_BASE)
cbnz	w0, LFQH_LBB261_5
cbz	x23, LFQH_LBB261_5
mov	w25, #0
LFQH_Lloh5144:
adr x24, LFQH_l_.str.20
LFQH_Lloh5145:
nop
mov	x0, x23
LFQH_LBB261_13:
cmp	x0, x20
b.eq	LFQH_LBB261_16
mov	x1, x24
bl	LFQH_Get
cbz	x0, LFQH_LBB261_5
add	w8, w25, #1
cmp	w25, #7
mov	x25, x8
b.lo	LFQH_LBB261_13
b	LFQH_LBB261_5
LFQH_LBB261_16:
LFQH_Lloh5146:
adr x0, LFQH_l_.str.71
LFQH_Lloh5147:
nop
bl Lpatch + (0xa5a4 - PATCH_BASE)
mov	x1, x0
mov	x0, x23
bl Lpatch + (0xa5d4 - PATCH_BASE)
fmov	d1, xzr
fmov	d2, xzr
fmov	d3, xzr
cbnz	w0, LFQH_LBB261_6
LFQH_Lloh5148:
adr x0, LFQH_l_.str.24
LFQH_Lloh5149:
nop
bl Lpatch + (0xa5a4 - PATCH_BASE)
mov	x1, x0
mov	x0, x23
bl Lpatch + (0xa5d4 - PATCH_BASE)
fmov	d8, d0
fmov	d9, d1
fmov	d10, d2
fmov	d11, d3
LFQH_Lloh5150:
adr x0, LFQH_l_.str.507
LFQH_Lloh5151:
nop
bl Lpatch + (0xa5a4 - PATCH_BASE)
mov	x1, x0
mov	x0, x23
fmov	d0, d8
fmov	d1, d9
fmov	d2, d10
fmov	d3, d11
mov	x2, x20
bl Lpatch + (0xa5d4 - PATCH_BASE)
fmov	d11, d0
stp	d3, d1, [sp, #16]
str	d2, [sp, #8]
LFQH_Lloh5152:
adr x1, LFQH_IconGlassKey
LFQH_Lloh5153:
nop
mov	x0, x23
bl Lpatch + (0xa628 - PATCH_BASE)
cbz	x0, LFQH_LBB261_19
mov	x24, x0
LFQH_Lloh5154:
adr x0, LFQH_l_.str.372
LFQH_Lloh5155:
nop
bl Lpatch + (0xa5a4 - PATCH_BASE)
mov	x1, x0
mov	x0, x24
bl Lpatch + (0xa5d4 - PATCH_BASE)
fmov	d8, d0
fmov	d13, d1
fmov	d14, d2
fmov	d15, d3
LFQH_Lloh5156:
adr x0, LFQH_l_.str.507
LFQH_Lloh5157:
nop
bl Lpatch + (0xa5a4 - PATCH_BASE)
mov	x1, x0
mov	x0, x23
fmov	d0, d8
fmov	d1, d13
fmov	d2, d14
fmov	d3, d15
mov	x2, x20
bl Lpatch + (0xa5d4 - PATCH_BASE)
fcmp	d0, d11
fcsel	d11, d0, d11, mi
LFQH_LBB261_19:
LFQH_Lloh5158:
adr x1, LFQH_l_.str.533
LFQH_Lloh5159:
nop
mov	x0, x22
bl	LFQH_Get
LFQH_Lloh5160:
adr x1, LFQH_l_.str.553
LFQH_Lloh5161:
nop
bl	LFQH_Get
mov	x22, x0
LFQH_Lloh5162:
adr x0, LFQH_l_.str.34
LFQH_Lloh5163:
nop
bl Lpatch + (0xa5a4 - PATCH_BASE)
mov	x1, x0
mov	x0, x22
bl Lpatch + (0xa5d4 - PATCH_BASE)
fmov	d8, xzr
cbz	x0, LFQH_LBB261_26
mov	x23, x0
mov	w27, #0
mov	x24, #0
LFQH_Lloh5164:
adr x25, LFQH_l_.str.461
LFQH_Lloh5165:
nop
LFQH_Lloh5166:
adr x26, LFQH_l_.str.232
LFQH_Lloh5167:
nop
fmov	d9, xzr
fmov	d10, #4.00000000
LFQH_LBB261_21:
mov	x0, x25
bl Lpatch + (0xa5a4 - PATCH_BASE)
mov	x1, x0
mov	x0, x22
mov	x2, x24
bl Lpatch + (0xa5d4 - PATCH_BASE)
mov	x28, x0
mov	x1, x26
bl	LFQH_Kind
cbz	w0, LFQH_LBB261_24
LFQH_Lloh5168:
adr x0, LFQH_l_.str.71
LFQH_Lloh5169:
nop
bl Lpatch + (0xa5a4 - PATCH_BASE)
mov	x1, x0
mov	x0, x28
bl Lpatch + (0xa5d4 - PATCH_BASE)
cbnz	w0, LFQH_LBB261_24
LFQH_Lloh5170:
adr x0, LFQH_l_.str.24
LFQH_Lloh5171:
nop
bl Lpatch + (0xa5a4 - PATCH_BASE)
mov	x1, x0
mov	x0, x28
bl Lpatch + (0xa5d4 - PATCH_BASE)
fmov	d13, d0
fmov	d14, d1
fmov	d15, d2
fmov	d12, d3
LFQH_Lloh5172:
adr x0, LFQH_l_.str.507
LFQH_Lloh5173:
nop
bl Lpatch + (0xa5a4 - PATCH_BASE)
mov	x1, x0
mov	x0, x28
fmov	d0, d13
fmov	d1, d14
fmov	d2, d15
fmov	d3, d12
mov	x2, x20
bl Lpatch + (0xa5d4 - PATCH_BASE)
fadd	d0, d0, d2
fadd	d0, d0, d10
fcmp	d0, d9
ccmp	w27, #0, #4, le
fcsel	d9, d0, d9, eq
mov	w27, #1
LFQH_LBB261_24:
add	x24, x24, #1
cmp	x23, x24
b.ne	LFQH_LBB261_21
cmp	w27, #0
cset	w22, eq
b	LFQH_LBB261_27
LFQH_LBB261_26:
mov	w22, #1
fmov	d9, xzr
LFQH_LBB261_27:
LFQH_Lloh5174:
adr x0, LFQH_l_.str.554
LFQH_Lloh5175:
nop
bl Lpatch + (0xa5a4 - PATCH_BASE)
mov	x1, x0
mov	x8, #9218868437227405311
fmov	d0, x8
mov	x0, x21
fmov	d1, d0
bl Lpatch + (0xa5d4 - PATCH_BASE)
tbnz	w22, #0, LFQH_LBB261_5
fmov	d14, d0
fmov	d13, d1
fmov	d0, d11
ldp	d3, d1, [sp, #16]
ldr	d2, [sp, #8]
bl	LFQH_VisibleRect
cbz	w0, LFQH_LBB261_5
mov	x8, #4631389266797133824
fmov	d0, x8
fmaxnm	d12, d14, d0
fsub	d0, d11, d9
fmov	d1, #20.00000000
fadd	d1, d12, d1
fcmp	d0, d1
b.mi	LFQH_LBB261_5
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
LFQH_Lloh5176:
adr x0, LFQH_l_.str.507
LFQH_Lloh5177:
nop
bl Lpatch + (0xa5a4 - PATCH_BASE)
mov	x1, x0
mov	x0, x20
fmov	d0, d13
fmov	d1, d9
fmov	d2, d12
fmov	d3, d11
mov	x2, x19
bl Lpatch + (0xa5d4 - PATCH_BASE)
fmov	d15, d0
fmov	d10, d1
fmov	d14, d2
str	d3, [sp, #24]
LFQH_Lloh5178:
adr x0, LFQH_l_.str.24
LFQH_Lloh5179:
nop
bl Lpatch + (0xa5a4 - PATCH_BASE)
mov	x1, x0
mov	x0, x19
bl Lpatch + (0xa5d4 - PATCH_BASE)
fcmp	d15, d0
fccmp	d10, d1, #8, pl
b.mi	LFQH_LBB261_5
fadd	d4, d15, d14
fadd	d0, d0, d2
fcmp	d4, d0
b.gt	LFQH_LBB261_5
ldr	d0, [sp, #24]
fadd	d0, d10, d0
fadd	d1, d1, d3
fcmp	d0, d1
fmov	d1, xzr
fmov	d2, xzr
fmov	d3, xzr
b.gt	LFQH_LBB261_6
fmov	d8, d13
fmov	d1, d9
fmov	d2, d12
fmov	d3, d11
b	LFQH_LBB261_6
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
LFQH_Lloh5180:
adr x1, LFQH_l_.str.138
LFQH_Lloh5181:
nop
bl	LFQH_Kind
cbz	w0, LFQH_LBB262_3
LFQH_Lloh5182:
adr x0, LFQH_l_.str.71
LFQH_Lloh5183:
nop
bl Lpatch + (0xa5a4 - PATCH_BASE)
mov	x1, x0
mov	x0, x19
bl Lpatch + (0xa5d4 - PATCH_BASE)
cbz	w0, LFQH_LBB262_4
mov	x0, x19
ldp	x29, x30, [sp, #16]
ldp	x20, x19, [sp], #32
b	LFQH_PageRestore
LFQH_LBB262_3:
ldp	x29, x30, [sp, #16]
ldp	x20, x19, [sp], #32
ret
LFQH_LBB262_4:
LFQH_Lloh5184:
adr x0, LFQH_l_.str.24
LFQH_Lloh5185:
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
cbz	x0, LFQH_LBB265_3
mov	x19, x0
LFQH_Lloh5186:
adr x0, LFQH_l_.str.389
LFQH_Lloh5187:
nop
bl Lpatch + (0xa5a4 - PATCH_BASE)
mov	x20, x0
LFQH_Lloh5188:
adr x0, LFQH_l_.str.23
LFQH_Lloh5189:
nop
bl Lpatch + (0xa5b0 - PATCH_BASE)
mov	x2, x0
mov	x0, x19
mov	x1, x20
bl Lpatch + (0xa5d4 - PATCH_BASE)
cbz	w0, LFQH_LBB265_3
LFQH_Lloh5190:
adr x1, LFQH_SurfaceKey
LFQH_Lloh5191:
nop
mov	x0, x19
bl Lpatch + (0xa628 - PATCH_BASE)
mov	x1, x0
mov	x0, x19
ldp	x29, x30, [sp, #16]
ldp	x20, x19, [sp], #32
b	LFQH_Restore
LFQH_LBB265_3:
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
mov	x22, x2
LFQH_Lloh5192:
adr x0, LFQH_l_.str.380
LFQH_Lloh5193:
nop
bl Lpatch + (0xa5a4 - PATCH_BASE)
mov	x1, x0
mov	x0, x22
bl Lpatch + (0xa5d4 - PATCH_BASE)
mov	x21, x0
bl	LFQH_PagePreference
cbz	x0, LFQH_LBB266_37
mov	x20, x0
LFQH_Lloh5194:
adr x1, LFQH_l_.str.381
LFQH_Lloh5195:
nop
mov	x0, x22
bl	LFQH_BoolProp
mov	x19, x0
cmp	x21, #6
b.lt	LFQH_LBB266_11
mov	x0, x20
mov	x1, x19
bl	LFQH_SetDefault
cmp	x21, #10
b.eq	LFQH_LBB266_29
cmp	x21, #7
b.eq	LFQH_LBB266_25
cmp	x21, #6
b.ne	LFQH_LBB266_32
LFQH_Lloh5196:
adr x0, LFQH_l_.str.21
LFQH_Lloh5197:
nop
bl Lpatch + (0xa5b0 - PATCH_BASE)
LFQH_Lloh5198:
adr x1, LFQH_ShelfDurationHeadersKey
LFQH_Lloh5199:
nop
bl Lpatch + (0xa628 - PATCH_BASE)
mov	x20, x0
LFQH_Lloh5200:
adr x0, LFQH_l_.str.475
LFQH_Lloh5201:
nop
bl Lpatch + (0xa5a4 - PATCH_BASE)
mov	x1, x0
mov	x0, x20
bl Lpatch + (0xa5d4 - PATCH_BASE)
mov	x20, x0
LFQH_Lloh5202:
adr x0, LFQH_l_.str.34
LFQH_Lloh5203:
nop
bl Lpatch + (0xa5a4 - PATCH_BASE)
mov	x1, x0
mov	x0, x20
bl Lpatch + (0xa5d4 - PATCH_BASE)
cbz	x0, LFQH_LBB266_37
mov	x21, x0
mov	x22, #0
LFQH_Lloh5204:
adr x23, LFQH_l_.str.461
LFQH_Lloh5205:
nop
LFQH_Lloh5206:
adr x24, LFQH_ShelfDurationRequestedKey
LFQH_Lloh5207:
nop
LFQH_Lloh5208:
adr x25, LFQH_l_.str.356
LFQH_Lloh5209:
nop
LFQH_Lloh5210:
adr x26, LFQH_l_.str.41
LFQH_Lloh5211:
nop
LFQH_LBB266_7:
mov	x0, x23
bl Lpatch + (0xa5a4 - PATCH_BASE)
mov	x1, x0
mov	x0, x20
mov	x2, x22
bl Lpatch + (0xa5d4 - PATCH_BASE)
mov	x27, x0
mov	x1, x24
bl Lpatch + (0xa628 - PATCH_BASE)
cbz	w19, LFQH_LBB266_9
mov	x1, x26
bl	LFQH_BoolProp
cmp	w0, #0
cset	w1, ne
b	LFQH_LBB266_10
LFQH_LBB266_9:
mov	w1, #0
LFQH_LBB266_10:
mov	x0, x27
bl	LFQH_ApplyShelfDuration
mov	x0, x25
bl Lpatch + (0xa5a4 - PATCH_BASE)
mov	x1, x0
mov	x0, x27
bl Lpatch + (0xa5d4 - PATCH_BASE)
add	x22, x22, #1
cmp	x21, x22
b.ne	LFQH_LBB266_7
b	LFQH_LBB266_37
LFQH_LBB266_11:
LFQH_Lloh5212:
adr x0, LFQH_l_.str.587
LFQH_Lloh5213:
nop
bl Lpatch + (0xa5b0 - PATCH_BASE)
mov	x23, x0
LFQH_Lloh5214:
adr x0, LFQH_l_.str.588
LFQH_Lloh5215:
nop
bl Lpatch + (0xa5a4 - PATCH_BASE)
mov	x1, x0
mov	x0, x23
bl Lpatch + (0xa5d4 - PATCH_BASE)
mov	x24, x0
LFQH_Lloh5216:
adr x1, LFQH_l_.str.589
LFQH_Lloh5217:
nop
bl	LFQH_Get
LFQH_Lloh5218:
adr x1, LFQH_l_.str.590
LFQH_Lloh5219:
nop
bl	LFQH_Get
mov	w1, #5
bl	LFQH_FindTabOwner
cbz	x0, LFQH_LBB266_13
LFQH_LBB266_12:
mov	x23, x0
b	LFQH_LBB266_18
LFQH_LBB266_13:
LFQH_Lloh5220:
adr x1, LFQH_l_.str.591
LFQH_Lloh5221:
nop
mov	x0, x24
bl	LFQH_Get
mov	x24, x0
LFQH_Lloh5222:
adr x0, LFQH_l_.str.34
LFQH_Lloh5223:
nop
bl Lpatch + (0xa5a4 - PATCH_BASE)
mov	x1, x0
mov	x0, x24
bl Lpatch + (0xa5d4 - PATCH_BASE)
cbz	x0, LFQH_LBB266_17
mov	x25, x0
mov	x26, #0
LFQH_Lloh5224:
adr x27, LFQH_l_.str.461
LFQH_Lloh5225:
nop
LFQH_Lloh5226:
adr x28, LFQH_l_.str.590
LFQH_Lloh5227:
nop
LFQH_LBB266_15:
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
cbnz	x0, LFQH_LBB266_12
add	x26, x26, #1
cmp	x25, x26
b.ne	LFQH_LBB266_15
LFQH_LBB266_17:
mov	x23, #0
LFQH_LBB266_18:
LFQH_Lloh5228:
adr x1, LFQH_l_.str.561
LFQH_Lloh5229:
nop
mov	x0, x23
bl	LFQH_Get
cbnz	w19, LFQH_LBB266_22
mov	x24, x0
LFQH_Lloh5230:
adr x0, LFQH_l_.str.34
LFQH_Lloh5231:
nop
bl Lpatch + (0xa5a4 - PATCH_BASE)
mov	x1, x0
mov	x0, x24
bl Lpatch + (0xa5d4 - PATCH_BASE)
cmp	x0, #1
b.ne	LFQH_LBB266_22
LFQH_Lloh5232:
adr x0, LFQH_l_.str.461
LFQH_Lloh5233:
nop
bl Lpatch + (0xa5a4 - PATCH_BASE)
mov	x1, x0
mov	x0, x24
mov	x2, #0
bl Lpatch + (0xa5d4 - PATCH_BASE)
mov	x1, x0
mov	x0, x23
bl	LFQH_TabOption
cmp	x0, x21
b.ne	LFQH_LBB266_22
LFQH_Lloh5234:
adr x0, LFQH_l_.str.385
LFQH_Lloh5235:
nop
bl Lpatch + (0xa5a4 - PATCH_BASE)
mov	x1, x0
mov	x0, x22
mov	w2, #1
mov	w3, #1
ldp	x29, x30, [sp, #80]
ldp	x20, x19, [sp, #64]
ldp	x22, x21, [sp, #48]
ldp	x24, x23, [sp, #32]
ldp	x26, x25, [sp, #16]
ldp	x28, x27, [sp], #96
b Lpatch + (0xa5d4 - PATCH_BASE)
LFQH_LBB266_22:
mov	x0, x20
mov	x1, x19
bl	LFQH_SetDefault
cbz	x23, LFQH_LBB266_24
LFQH_Lloh5236:
adr x0, LFQH_l_.str.562
LFQH_Lloh5237:
nop
bl Lpatch + (0xa5a4 - PATCH_BASE)
mov	x1, x0
mov	x0, x23
bl Lpatch + (0xa5d4 - PATCH_BASE)
mov	x0, x23
bl	LFQH_InstallTabRecovery
LFQH_LBB266_24:
LFQH_Lloh5238:
adr x0, LFQH_l_.str.88
LFQH_Lloh5239:
nop
bl Lpatch + (0xa5b0 - PATCH_BASE)
mov	x21, x0
LFQH_Lloh5240:
adr x0, LFQH_l_.str.89
LFQH_Lloh5241:
nop
bl Lpatch + (0xa5a4 - PATCH_BASE)
mov	x1, x0
mov	x0, x21
bl Lpatch + (0xa5d4 - PATCH_BASE)
mov	x21, x0
LFQH_Lloh5242:
adr x0, LFQH_l_.str.361
LFQH_Lloh5243:
nop
bl Lpatch + (0xa5b0 - PATCH_BASE)
mov	x22, x0
LFQH_Lloh5244:
adr x0, LFQH_l_.str.387
LFQH_Lloh5245:
nop
bl Lpatch + (0xa5a4 - PATCH_BASE)
mov	x1, x0
LFQH_Lloh5246:
adr x23, LFQH_l_.str.563
LFQH_Lloh5247:
nop
mov	x0, x22
mov	x2, x23
bl Lpatch + (0xa5d4 - PATCH_BASE)
mov	x2, x0
LFQH_Lloh5248:
adr x1, LFQH_l_.str.518
LFQH_Lloh5249:
nop
mov	x0, x21
bl	LFQH_Put
LFQH_Lloh5250:
adr x1, LFQH_l_.str.564
LFQH_Lloh5251:
nop
mov	x0, x21
mov	x2, x20
bl	LFQH_Put
LFQH_Lloh5252:
adr x0, LFQH_l_.str.497
LFQH_Lloh5253:
nop
bl Lpatch + (0xa5b0 - PATCH_BASE)
mov	x20, x0
LFQH_Lloh5254:
adr x0, LFQH_l_.str.499
LFQH_Lloh5255:
nop
bl Lpatch + (0xa5a4 - PATCH_BASE)
mov	x1, x0
mov	x0, x20
mov	x2, x19
bl Lpatch + (0xa5d4 - PATCH_BASE)
mov	x2, x0
LFQH_Lloh5256:
adr x1, LFQH_l_.str.565
LFQH_Lloh5257:
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
LFQH_LBB266_25:
LFQH_Lloh5258:
adr x0, LFQH_l_.str.265
LFQH_Lloh5259:
nop
bl Lpatch + (0xa5b0 - PATCH_BASE)
LFQH_Lloh5260:
adr x1, LFQH_l_.str.234
LFQH_Lloh5261:
nop
LFQH_Lloh5262:
adr x2, LFQH_l_.str.186
LFQH_Lloh5263:
nop
bl	LFQH_ClassABI
cbz	w0, LFQH_LBB266_37
LFQH_Lloh5264:
adr x0, LFQH_l_.str.265
LFQH_Lloh5265:
nop
bl Lpatch + (0xa5b0 - PATCH_BASE)
LFQH_Lloh5266:
adr x1, LFQH_MineControllersKey
LFQH_Lloh5267:
nop
bl Lpatch + (0xa628 - PATCH_BASE)
mov	x19, x0
LFQH_Lloh5268:
adr x0, LFQH_l_.str.475
LFQH_Lloh5269:
nop
bl Lpatch + (0xa5a4 - PATCH_BASE)
mov	x1, x0
mov	x0, x19
bl Lpatch + (0xa5d4 - PATCH_BASE)
mov	x19, x0
LFQH_Lloh5270:
adr x0, LFQH_l_.str.34
LFQH_Lloh5271:
nop
bl Lpatch + (0xa5a4 - PATCH_BASE)
mov	x1, x0
mov	x0, x19
bl Lpatch + (0xa5d4 - PATCH_BASE)
cbz	x0, LFQH_LBB266_37
mov	x20, x0
mov	x21, #0
LFQH_Lloh5272:
adr x23, LFQH_l_.str.234
LFQH_Lloh5273:
nop
LFQH_Lloh5274:
adr x24, LFQH_l_.str.361
LFQH_Lloh5275:
nop
LFQH_Lloh5276:
adr x25, LFQH_l_.str.387
LFQH_Lloh5277:
nop
LFQH_Lloh5278:
adr x26, LFQH_l_.str.566
LFQH_Lloh5279:
nop
LFQH_LBB266_28:
LFQH_Lloh5280:
adr x0, LFQH_l_.str.461
LFQH_Lloh5281:
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
b.ne	LFQH_LBB266_28
b	LFQH_LBB266_37
LFQH_LBB266_29:
bl	LFQH_ShelfFilterHeaders
mov	x19, x0
LFQH_Lloh5282:
adr x0, LFQH_l_.str.475
LFQH_Lloh5283:
nop
bl Lpatch + (0xa5a4 - PATCH_BASE)
mov	x1, x0
mov	x0, x19
bl Lpatch + (0xa5d4 - PATCH_BASE)
mov	x19, x0
LFQH_Lloh5284:
adr x0, LFQH_l_.str.34
LFQH_Lloh5285:
nop
bl Lpatch + (0xa5a4 - PATCH_BASE)
mov	x1, x0
mov	x0, x19
bl Lpatch + (0xa5d4 - PATCH_BASE)
mov	x20, x0
mov	w0, #10
bl	LFQH_PageOptionEnabled
cbz	x20, LFQH_LBB266_37
mov	x21, x0
mov	x22, #0
LFQH_Lloh5286:
adr x23, LFQH_l_.str.461
LFQH_Lloh5287:
nop
LFQH_Lloh5288:
adr x24, LFQH_l_.str.107
LFQH_Lloh5289:
nop
LFQH_Lloh5290:
adr x25, LFQH_l_.str.108
LFQH_Lloh5291:
nop
LFQH_Lloh5292:
adr x26, LFQH_l_.str.356
LFQH_Lloh5293:
nop
LFQH_LBB266_31:
mov	x0, x23
bl Lpatch + (0xa5a4 - PATCH_BASE)
mov	x1, x0
mov	x0, x19
mov	x2, x22
bl Lpatch + (0xa5d4 - PATCH_BASE)
mov	x27, x0
mov	x1, x24
bl	LFQH_Get
mov	x1, x21
bl	LFQH_ApplyShelfFilterButton
mov	x0, x27
mov	x1, x25
bl	LFQH_Get
mov	x1, x21
bl	LFQH_ApplyShelfFilterButton
mov	x0, x26
bl Lpatch + (0xa5a4 - PATCH_BASE)
mov	x1, x0
mov	x0, x27
bl Lpatch + (0xa5d4 - PATCH_BASE)
add	x22, x22, #1
cmp	x20, x22
b.ne	LFQH_LBB266_31
b	LFQH_LBB266_37
LFQH_LBB266_32:
cmp	x21, #11
b.ne	LFQH_LBB266_35
cbz	w19, LFQH_LBB266_35
ldp	x29, x30, [sp, #80]
ldp	x20, x19, [sp, #64]
ldp	x22, x21, [sp, #48]
ldp	x24, x23, [sp, #32]
ldp	x26, x25, [sp, #16]
ldp	x28, x27, [sp], #96
b	LFQH_FQHApplyReaderThemeIsolation
LFQH_LBB266_35:
cmp	x21, #9
b.ne	LFQH_LBB266_37
ldp	x29, x30, [sp, #80]
ldp	x20, x19, [sp, #64]
ldp	x22, x21, [sp, #48]
ldp	x24, x23, [sp, #32]
ldp	x26, x25, [sp, #16]
ldp	x28, x27, [sp], #96
b	LFQH_RefreshFullscreenFill
LFQH_LBB266_37:
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
LFQH_Lloh5294:
adr x0, LFQH_l_.str.354
LFQH_Lloh5295:
nop
bl Lpatch + (0xa5a4 - PATCH_BASE)
mov	x1, x0
mov	x0, x20
bl Lpatch + (0xa5d4 - PATCH_BASE)
cmp	x0, #1
b.ne	LFQH_LBB267_3
LFQH_Lloh5296:
adr x1, LFQH_RecoveryBarKey
LFQH_Lloh5297:
nop
mov	x0, x19
bl Lpatch + (0xa628 - PATCH_BASE)
mov	x19, x0
LFQH_Lloh5298:
adr x0, LFQH_l_.str.81
LFQH_Lloh5299:
nop
bl Lpatch + (0xa5a4 - PATCH_BASE)
mov	x1, x0
mov	x0, x19
bl Lpatch + (0xa5d4 - PATCH_BASE)
LFQH_Lloh5300:
adr x1, LFQH_l_.str.120
LFQH_Lloh5301:
nop
bl	LFQH_Get
mov	x19, x0
LFQH_Lloh5302:
adr x1, LFQH_l_.str.121
LFQH_Lloh5303:
nop
bl	LFQH_Kind
cbz	w0, LFQH_LBB267_3
LFQH_Lloh5304:
adr x1, LFQH_l_.str.352
LFQH_Lloh5305:
nop
mov	x0, x19
bl	LFQH_Get
cbz	x0, LFQH_LBB267_4
LFQH_LBB267_3:
ldp	x29, x30, [sp, #16]
ldp	x20, x19, [sp], #32
ret
LFQH_LBB267_4:
LFQH_Lloh5306:
adr x0, LFQH_l_.str.605
LFQH_Lloh5307:
nop
bl Lpatch + (0xa5a4 - PATCH_BASE)
mov	x20, x0
LFQH_Lloh5308:
adr x0, LFQH_l_.str.606
LFQH_Lloh5309:
nop
bl Lpatch + (0xa5b0 - PATCH_BASE)
mov	x1, x20
bl Lpatch + (0xa5f8 - PATCH_BASE)
cbz	x0, LFQH_LBB267_3
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
LFQH_Lloh5310:
adr x1, LFQH_RecoveryBarKey
LFQH_Lloh5311:
nop
bl Lpatch + (0xa628 - PATCH_BASE)
mov	x20, x0
LFQH_Lloh5312:
adr x0, LFQH_l_.str.81
LFQH_Lloh5313:
nop
bl Lpatch + (0xa5a4 - PATCH_BASE)
mov	x1, x0
mov	x0, x20
bl Lpatch + (0xa5d4 - PATCH_BASE)
cbz	x0, LFQH_LBB268_4
mov	x20, x0
LFQH_Lloh5314:
adr x0, LFQH_l_.str.71
LFQH_Lloh5315:
nop
bl Lpatch + (0xa5a4 - PATCH_BASE)
mov	x1, x0
mov	x0, x20
bl Lpatch + (0xa5d4 - PATCH_BASE)
cbnz	w0, LFQH_LBB268_3
LFQH_Lloh5316:
adr x0, LFQH_l_.str.361
LFQH_Lloh5317:
nop
bl Lpatch + (0xa5b0 - PATCH_BASE)
mov	x21, x0
LFQH_Lloh5318:
adr x0, LFQH_l_.str.387
LFQH_Lloh5319:
nop
bl Lpatch + (0xa5a4 - PATCH_BASE)
mov	x1, x0
LFQH_Lloh5320:
adr x2, LFQH_l_.str.540
LFQH_Lloh5321:
nop
mov	x0, x21
bl Lpatch + (0xa5d4 - PATCH_BASE)
bl	LFQH_DefaultEnabled
cbz	w0, LFQH_LBB268_5
LFQH_LBB268_3:
mov	w0, #0
LFQH_LBB268_4:
ldp	x29, x30, [sp, #48]
ldp	x20, x19, [sp, #32]
ldp	x22, x21, [sp, #16]
ldp	d9, d8, [sp], #64
ret
LFQH_LBB268_5:
LFQH_Lloh5322:
adr x0, LFQH_l_.str.607
LFQH_Lloh5323:
nop
bl Lpatch + (0xa5a4 - PATCH_BASE)
mov	x1, x0
mov	x0, x19
mov	x2, x20
bl Lpatch + (0xa5d4 - PATCH_BASE)
fmov	d9, d0
fmov	d8, d1
LFQH_Lloh5324:
adr x0, LFQH_l_.str.24
LFQH_Lloh5325:
nop
bl Lpatch + (0xa5a4 - PATCH_BASE)
mov	x1, x0
mov	x0, x20
bl Lpatch + (0xa5d4 - PATCH_BASE)
mov	w0, #0
fcmp	d9, d0
b.lt	LFQH_LBB268_4
fadd	d0, d0, d2
fcmp	d9, d0
fccmp	d8, d1, #8, mi
b.lt	LFQH_LBB268_4
fadd	d0, d1, d3
fcmp	d8, d0
cset	w0, mi
b	LFQH_LBB268_4
.cfi_endproc
.p2align	2
LFQH_RefreshFullscreenFill:
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
bl	LFQH_FullscreenPlayers
mov	x19, x0
LFQH_Lloh5326:
adr x0, LFQH_l_.str.475
LFQH_Lloh5327:
nop
bl Lpatch + (0xa5a4 - PATCH_BASE)
mov	x1, x0
mov	x0, x19
bl Lpatch + (0xa5d4 - PATCH_BASE)
mov	x19, x0
LFQH_Lloh5328:
adr x0, LFQH_l_.str.34
LFQH_Lloh5329:
nop
bl Lpatch + (0xa5a4 - PATCH_BASE)
mov	x1, x0
mov	x0, x19
bl Lpatch + (0xa5d4 - PATCH_BASE)
cbz	x0, LFQH_LBB269_5
mov	x20, x0
mov	x21, #0
LFQH_Lloh5330:
adr x22, LFQH_l_.str.461
LFQH_Lloh5331:
nop
LFQH_Lloh5332:
adr x23, LFQH_l_.str.74
LFQH_Lloh5333:
nop
LFQH_Lloh5334:
adr x24, LFQH_l_.str.567
LFQH_Lloh5335:
nop
LFQH_LBB269_2:
mov	x0, x22
bl Lpatch + (0xa5a4 - PATCH_BASE)
mov	x1, x0
mov	x0, x19
mov	x2, x21
bl Lpatch + (0xa5d4 - PATCH_BASE)
mov	x25, x0
bl	LFQH_FullscreenApplyPlayer
mov	x0, x25
mov	x1, x23
bl	LFQH_Get
cbz	x0, LFQH_LBB269_4
mov	x0, x24
bl Lpatch + (0xa5a4 - PATCH_BASE)
mov	x1, x0
mov	x0, x25
bl Lpatch + (0xa5d4 - PATCH_BASE)
LFQH_LBB269_4:
add	x21, x21, #1
cmp	x20, x21
b.ne	LFQH_LBB269_2
LFQH_LBB269_5:
ldp	x29, x30, [sp, #64]
ldp	x20, x19, [sp, #48]
ldp	x22, x21, [sp, #32]
ldp	x24, x23, [sp, #16]
ldp	x26, x25, [sp], #80
ret
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
LFQH_Lloh5336:
adr x0, LFQH_l_.str.593
LFQH_Lloh5337:
nop
bl Lpatch + (0xa5a4 - PATCH_BASE)
mov	x1, x0
mov	x0, x20
bl Lpatch + (0xa5d4 - PATCH_BASE)
mov	x20, x0
cmp	w0, #3
b.gt	LFQH_LBB270_4
cbz	w20, LFQH_LBB270_9
cmp	w20, #3
b.ne	LFQH_LBB270_6
mov	w0, #3
b	LFQH_LBB270_13
LFQH_LBB270_4:
cmp	w20, #4
b.eq	LFQH_LBB270_10
cmp	w20, #7
b.eq	LFQH_LBB270_8
LFQH_LBB270_6:
mov	x0, x19
bl Lpatch + (0xa664 - PATCH_BASE)
LFQH_Lloh5338:
adr x1, LFQH_l_.str.594
LFQH_Lloh5339:
nop
LFQH_Lloh5340:
adr x2, LFQH_l_.str.595
LFQH_Lloh5341:
nop
bl	LFQH_ClassABI
cbz	w0, LFQH_LBB270_11
LFQH_Lloh5342:
adr x0, LFQH_l_.str.594
LFQH_Lloh5343:
nop
bl Lpatch + (0xa5a4 - PATCH_BASE)
mov	x1, x0
mov	x0, x19
mov	x2, x20
bl Lpatch + (0xa5d4 - PATCH_BASE)
mov	x19, x0
LFQH_Lloh5344:
adr x1, LFQH_l_.str.596
LFQH_Lloh5345:
nop
bl	LFQH_Equal
cbz	w0, LFQH_LBB270_12
LFQH_LBB270_8:
mov	w0, #2
b	LFQH_LBB270_13
LFQH_LBB270_9:
mov	w0, #1
b	LFQH_LBB270_13
LFQH_LBB270_10:
mov	w0, #4
b	LFQH_LBB270_13
LFQH_LBB270_11:
mov	x0, #0
b	LFQH_LBB270_13
LFQH_LBB270_12:
LFQH_Lloh5346:
adr x1, LFQH_l_.str.597
LFQH_Lloh5347:
nop
mov	x0, x19
bl	LFQH_Equal
cmp	w0, #0
mov	w8, #5
csel	x0, xzr, x8, eq
LFQH_LBB270_13:
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
LFQH_Lloh5348:
adr x1, LFQH_l_.str.598
LFQH_Lloh5349:
nop
bl	LFQH_Get
mov	x22, x0
LFQH_Lloh5350:
adr x1, LFQH_l_.str.20
LFQH_Lloh5351:
nop
bl	LFQH_Get
mov	x20, x0
LFQH_Lloh5352:
adr x1, LFQH_TabRecoveryKey
LFQH_Lloh5353:
nop
mov	x0, x19
bl Lpatch + (0xa628 - PATCH_BASE)
mov	x21, x0
LFQH_Lloh5354:
adr x1, LFQH_l_.str.351
LFQH_Lloh5355:
nop
bl	LFQH_Get
mov	x23, x0
cbz	x20, LFQH_LBB271_3
LFQH_Lloh5356:
adr x0, LFQH_l_.str.361
LFQH_Lloh5357:
nop
bl Lpatch + (0xa5b0 - PATCH_BASE)
mov	x24, x0
LFQH_Lloh5358:
adr x0, LFQH_l_.str.387
LFQH_Lloh5359:
nop
bl Lpatch + (0xa5a4 - PATCH_BASE)
mov	x1, x0
LFQH_Lloh5360:
adr x2, LFQH_l_.str.540
LFQH_Lloh5361:
nop
mov	x0, x24
bl Lpatch + (0xa5d4 - PATCH_BASE)
bl	LFQH_DefaultEnabled
cmp	w0, #0
cset	w24, eq
cbnz	x21, LFQH_LBB271_4
LFQH_LBB271_2:
cbnz	w24, LFQH_LBB271_6
b	LFQH_LBB271_10
LFQH_LBB271_3:
mov	w24, #0
cbz	x21, LFQH_LBB271_2
LFQH_LBB271_4:
cmp	x23, x20
cset	w8, eq
and	w8, w8, w24
tbnz	w8, #0, LFQH_LBB271_10
LFQH_Lloh5362:
adr x0, LFQH_l_.str.599
LFQH_Lloh5363:
nop
bl Lpatch + (0xa5a4 - PATCH_BASE)
mov	x1, x0
mov	x0, x23
mov	x2, x21
bl Lpatch + (0xa5d4 - PATCH_BASE)
LFQH_Lloh5364:
adr x1, LFQH_TabRecoveryKey
LFQH_Lloh5365:
nop
mov	x0, x19
mov	x2, #0
mov	w3, #1
bl Lpatch + (0xa634 - PATCH_BASE)
cbz	w24, LFQH_LBB271_10
LFQH_LBB271_6:
bl	LFQH_ToggleObserver
mov	x21, x0
LFQH_Lloh5366:
adr x0, LFQH_l_.str.154
LFQH_Lloh5367:
nop
bl Lpatch + (0xa5a4 - PATCH_BASE)
mov	x1, x0
mov	x0, x21
bl Lpatch + (0xa5d4 - PATCH_BASE)
mov	x21, x0
LFQH_Lloh5368:
adr x0, LFQH_l_.str.155
LFQH_Lloh5369:
nop
bl Lpatch + (0xa5a4 - PATCH_BASE)
mov	x1, x0
mov	x0, x21
bl Lpatch + (0xa5d4 - PATCH_BASE)
cbz	x0, LFQH_LBB271_10
mov	x21, x0
LFQH_Lloh5370:
adr x0, LFQH_l_.str.82
LFQH_Lloh5371:
nop
bl Lpatch + (0xa5b0 - PATCH_BASE)
mov	x23, x0
LFQH_Lloh5372:
adr x0, LFQH_l_.str.83
LFQH_Lloh5373:
nop
bl Lpatch + (0xa5a4 - PATCH_BASE)
mov	x1, x0
mov	x0, x23
bl Lpatch + (0xa5d4 - PATCH_BASE)
mov	x23, x0
LFQH_Lloh5374:
adr x0, LFQH_l_.str.84
LFQH_Lloh5375:
nop
bl Lpatch + (0xa5a4 - PATCH_BASE)
mov	x1, x0
mov	x0, x23
mov	x2, x22
bl Lpatch + (0xa5d4 - PATCH_BASE)
LFQH_Lloh5376:
adr x1, LFQH_RecoveryBarKey
LFQH_Lloh5377:
nop
mov	x0, x21
mov	x2, x23
mov	w3, #1
bl Lpatch + (0xa634 - PATCH_BASE)
LFQH_Lloh5378:
adr x0, LFQH_l_.str.600
LFQH_Lloh5379:
nop
bl Lpatch + (0xa5b0 - PATCH_BASE)
mov	x22, x0
LFQH_Lloh5380:
adr x0, LFQH_l_.str.154
LFQH_Lloh5381:
nop
bl Lpatch + (0xa5a4 - PATCH_BASE)
mov	x1, x0
mov	x0, x22
bl Lpatch + (0xa5d4 - PATCH_BASE)
mov	x22, x0
LFQH_Lloh5382:
adr x0, LFQH_l_.str.601
LFQH_Lloh5383:
nop
bl Lpatch + (0xa5a4 - PATCH_BASE)
mov	x23, x0
LFQH_Lloh5384:
adr x0, LFQH_l_.str.558
LFQH_Lloh5385:
nop
bl Lpatch + (0xa5a4 - PATCH_BASE)
mov	x3, x0
mov	x0, x22
mov	x1, x23
mov	x2, x21
bl Lpatch + (0xa5d4 - PATCH_BASE)
cbz	x0, LFQH_LBB271_9
mov	x22, x0
LFQH_Lloh5386:
adr x0, LFQH_l_.str.602
LFQH_Lloh5387:
nop
bl Lpatch + (0xa5a4 - PATCH_BASE)
mov	x1, x0
fmov	d0, #0.75000000
mov	x0, x22
bl Lpatch + (0xa5d4 - PATCH_BASE)
LFQH_Lloh5388:
adr x0, LFQH_l_.str.603
LFQH_Lloh5389:
nop
bl Lpatch + (0xa5a4 - PATCH_BASE)
mov	x1, x0
mov	x0, x22
mov	x2, x21
bl Lpatch + (0xa5d4 - PATCH_BASE)
LFQH_Lloh5390:
adr x1, LFQH_ToggleObserverKey
LFQH_Lloh5391:
nop
mov	x0, x22
mov	x2, x21
mov	w3, #1
bl Lpatch + (0xa634 - PATCH_BASE)
LFQH_Lloh5392:
adr x1, LFQH_TabRecoveryKey
LFQH_Lloh5393:
nop
mov	x0, x19
mov	x2, x22
mov	w3, #1
bl Lpatch + (0xa634 - PATCH_BASE)
LFQH_Lloh5394:
adr x0, LFQH_l_.str.604
LFQH_Lloh5395:
nop
bl Lpatch + (0xa5a4 - PATCH_BASE)
mov	x1, x0
mov	x0, x20
mov	x2, x22
bl Lpatch + (0xa5d4 - PATCH_BASE)
LFQH_Lloh5396:
adr x0, LFQH_l_.str.56
LFQH_Lloh5397:
nop
bl Lpatch + (0xa5a4 - PATCH_BASE)
mov	x1, x0
mov	x0, x22
bl Lpatch + (0xa5d4 - PATCH_BASE)
LFQH_LBB271_9:
LFQH_Lloh5398:
adr x0, LFQH_l_.str.56
LFQH_Lloh5399:
nop
bl Lpatch + (0xa5a4 - PATCH_BASE)
mov	x1, x0
mov	x0, x21
ldp	x29, x30, [sp, #48]
ldp	x20, x19, [sp, #32]
ldp	x22, x21, [sp, #16]
ldp	x24, x23, [sp], #64
b Lpatch + (0xa5d4 - PATCH_BASE)
LFQH_LBB271_10:
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
LFQH_Lloh5400:
adr x0, LFQH_l_.str.21
LFQH_Lloh5401:
nop
LFQH_Lloh5402:
adr x1, LFQH_l_.str.283
LFQH_Lloh5403:
nop
bl	LFQH_Original
cbz	x0, LFQH_LBB274_2
str	x0, [sp, #8]
LFQH_Lloh5404:
adr x0, LFQH_l_.str.282
LFQH_Lloh5405:
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
LFQH_LBB274_2:
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
LFQH_ShelfFilterHeaders:
.cfi_startproc
stp	x20, x19, [sp, #-32]!
stp	x29, x30, [sp, #16]
add	x29, sp, #16
.cfi_def_cfa w29, 16
.cfi_offset w30, -8
.cfi_offset w29, -16
.cfi_offset w19, -24
.cfi_offset w20, -32
LFQH_Lloh5406:
adr x0, LFQH_l_.str.82
LFQH_Lloh5407:
nop
bl Lpatch + (0xa5b0 - PATCH_BASE)
mov	x19, x0
LFQH_Lloh5408:
adr x1, LFQH_ShelfFilterHeadersKey
LFQH_Lloh5409:
nop
bl Lpatch + (0xa628 - PATCH_BASE)
mov	x20, x0
cbnz	x0, LFQH_LBB277_2
LFQH_Lloh5410:
adr x0, LFQH_l_.str.83
LFQH_Lloh5411:
nop
bl Lpatch + (0xa5a4 - PATCH_BASE)
mov	x1, x0
mov	x0, x19
bl Lpatch + (0xa5d4 - PATCH_BASE)
mov	x20, x0
LFQH_Lloh5412:
adr x1, LFQH_ShelfFilterHeadersKey
LFQH_Lloh5413:
nop
mov	x0, x19
mov	x2, x20
mov	w3, #1
bl Lpatch + (0xa634 - PATCH_BASE)
LFQH_LBB277_2:
mov	x0, x20
ldp	x29, x30, [sp, #16]
ldp	x20, x19, [sp], #32
ret
.cfi_endproc
.p2align	2
LFQH_ApplyShelfFilterButton:
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
LFQH_Lloh5414:
adr x1, LFQH_l_.str.138
LFQH_Lloh5415:
nop
bl	LFQH_Kind
cbz	w0, LFQH_LBB278_3
cbz	w20, LFQH_LBB278_4
mov	x0, x19
bl	LFQH_RestoreShelfFilterButton
b	LFQH_LBB278_6
LFQH_LBB278_3:
ldp	x29, x30, [sp, #16]
ldp	x20, x19, [sp], #32
ret
LFQH_LBB278_4:
LFQH_Lloh5416:
adr x0, LFQH_l_.str.71
LFQH_Lloh5417:
nop
bl Lpatch + (0xa5a4 - PATCH_BASE)
mov	x1, x0
mov	x0, x19
bl Lpatch + (0xa5d4 - PATCH_BASE)
cbnz	w0, LFQH_LBB278_6
LFQH_Lloh5418:
adr x1, LFQH_ShelfFilterHiddenKey
LFQH_Lloh5419:
nop
mov	x0, x19
mov	x2, x19
mov	x3, #0
bl Lpatch + (0xa634 - PATCH_BASE)
LFQH_Lloh5420:
adr x0, LFQH_l_.str.72
LFQH_Lloh5421:
nop
bl Lpatch + (0xa5a4 - PATCH_BASE)
mov	x1, x0
mov	x0, x19
mov	w2, #1
bl Lpatch + (0xa5d4 - PATCH_BASE)
LFQH_LBB278_6:
mov	x0, x19
mov	w1, #1
ldp	x29, x30, [sp, #16]
ldp	x20, x19, [sp], #32
b	LFQH_ShelfActionGlass
.cfi_endproc
.p2align	2
LFQH_ShelfFilterHeadersKey:
.cfi_startproc
ret
.cfi_endproc
.p2align	2
LFQH_RestoreShelfFilterButton:
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
LFQH_Lloh5422:
adr x1, LFQH_ShelfFilterHiddenKey
LFQH_Lloh5423:
nop
bl Lpatch + (0xa628 - PATCH_BASE)
cbz	x0, LFQH_LBB280_3
LFQH_Lloh5424:
adr x1, LFQH_ShelfFilterHiddenKey
LFQH_Lloh5425:
nop
mov	x0, x19
mov	x2, #0
mov	x3, #0
bl Lpatch + (0xa634 - PATCH_BASE)
LFQH_Lloh5426:
adr x0, LFQH_l_.str.71
LFQH_Lloh5427:
nop
bl Lpatch + (0xa5a4 - PATCH_BASE)
mov	x1, x0
mov	x0, x19
bl Lpatch + (0xa5d4 - PATCH_BASE)
cbz	w0, LFQH_LBB280_3
LFQH_Lloh5428:
adr x0, LFQH_l_.str.72
LFQH_Lloh5429:
nop
bl Lpatch + (0xa5a4 - PATCH_BASE)
mov	x1, x0
mov	x0, x19
mov	w2, #0
ldp	x29, x30, [sp, #16]
ldp	x20, x19, [sp], #32
b Lpatch + (0xa5d4 - PATCH_BASE)
LFQH_LBB280_3:
ldp	x29, x30, [sp, #16]
ldp	x20, x19, [sp], #32
ret
.cfi_endproc
.p2align	2
LFQH_ShelfFilterHiddenKey:
.cfi_startproc
ret
.cfi_endproc
.p2align	2
LFQH_FullscreenPlayers:
.cfi_startproc
stp	x20, x19, [sp, #-32]!
stp	x29, x30, [sp, #16]
add	x29, sp, #16
.cfi_def_cfa w29, 16
.cfi_offset w30, -8
.cfi_offset w29, -16
.cfi_offset w19, -24
.cfi_offset w20, -32
LFQH_Lloh5430:
adr x0, LFQH_l_.str.568
LFQH_Lloh5431:
nop
bl Lpatch + (0xa5b0 - PATCH_BASE)
mov	x19, x0
LFQH_Lloh5432:
adr x1, LFQH_FullscreenPlayersKey
LFQH_Lloh5433:
nop
bl Lpatch + (0xa628 - PATCH_BASE)
mov	x20, x0
cbnz	x0, LFQH_LBB282_2
LFQH_Lloh5434:
adr x0, LFQH_l_.str.82
LFQH_Lloh5435:
nop
bl Lpatch + (0xa5b0 - PATCH_BASE)
mov	x20, x0
LFQH_Lloh5436:
adr x0, LFQH_l_.str.83
LFQH_Lloh5437:
nop
bl Lpatch + (0xa5a4 - PATCH_BASE)
mov	x1, x0
mov	x0, x20
bl Lpatch + (0xa5d4 - PATCH_BASE)
mov	x20, x0
LFQH_Lloh5438:
adr x1, LFQH_FullscreenPlayersKey
LFQH_Lloh5439:
nop
mov	x0, x19
mov	x2, x20
mov	w3, #1
bl Lpatch + (0xa634 - PATCH_BASE)
LFQH_LBB282_2:
mov	x0, x20
ldp	x29, x30, [sp, #16]
ldp	x20, x19, [sp], #32
ret
.cfi_endproc
.p2align	2
LFQH_FullscreenApplyPlayer:
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
mov	x20, x0
add	x1, sp, #16
bl	LFQH_FullscreenFillViewport
mov	x19, x0
LFQH_Lloh5440:
adr x0, LFQH_l_.str.569
LFQH_Lloh5441:
nop
bl Lpatch + (0xa5a4 - PATCH_BASE)
mov	x1, x0
mov	x0, x20
bl Lpatch + (0xa5d4 - PATCH_BASE)
mov	x1, x19
bl	LFQH_FullscreenScale
LFQH_Lloh5442:
adr x1, LFQH_FullscreenLogStateKey
LFQH_Lloh5443:
nop
mov	x0, x20
bl Lpatch + (0xa628 - PATCH_BASE)
mov	x25, x0
LFQH_Lloh5444:
adr x0, LFQH_l_.str.570
LFQH_Lloh5445:
nop
bl Lpatch + (0xa5a4 - PATCH_BASE)
mov	x1, x0
mov	x0, x20
bl Lpatch + (0xa5d4 - PATCH_BASE)
mov	x23, x0
cbnz	x25, LFQH_LBB283_2
cbz	w23, LFQH_LBB283_17
LFQH_LBB283_2:
mov	w0, #9
bl	LFQH_PageOptionEnabled
mov	x24, x0
cbnz	x25, LFQH_LBB283_4
cbz	w24, LFQH_LBB283_17
LFQH_LBB283_4:
LFQH_Lloh5446:
adr x0, LFQH_l_.str.569
LFQH_Lloh5447:
nop
bl Lpatch + (0xa5a4 - PATCH_BASE)
mov	x1, x0
mov	x0, x20
bl Lpatch + (0xa5d4 - PATCH_BASE)
mov	x26, x0
LFQH_Lloh5448:
adr x1, LFQH_l_.str.74
LFQH_Lloh5449:
nop
mov	x0, x20
bl	LFQH_Get
mov	x22, x0
cbz	x26, LFQH_LBB283_6
LFQH_Lloh5450:
adr x0, LFQH_l_.str.574
LFQH_Lloh5451:
nop
bl Lpatch + (0xa5a4 - PATCH_BASE)
mov	x1, x0
mov	x0, x26
bl Lpatch + (0xa5d4 - PATCH_BASE)
mov	x28, x0
b	LFQH_LBB283_7
LFQH_LBB283_6:
mov	x28, #-1
LFQH_LBB283_7:
cmp	w19, #0
cset	w8, ne
ubfiz	x8, x8, #3, #32
orr	x8, x8, x28, lsl #4
cmp	w23, #0
cset	w9, ne
orr	x8, x8, x9, lsl #2
cmp	w24, #0
cset	w9, ne
orr	x8, x8, x9, lsl #1
cmp	x22, #0
cinc	x8, x8, ne
add	x21, x8, #16
LFQH_Lloh5452:
adr x0, LFQH_l_.str.24
LFQH_Lloh5453:
nop
bl Lpatch + (0xa5a4 - PATCH_BASE)
mov	x1, x0
mov	x0, x20
bl Lpatch + (0xa5d4 - PATCH_BASE)
fmov	d8, d0
fmov	d9, d1
fmov	d10, d2
fmov	d11, d3
LFQH_Lloh5454:
adr x1, LFQH_FullscreenLogBoundsKey
LFQH_Lloh5455:
nop
mov	x0, x20
bl Lpatch + (0xa628 - PATCH_BASE)
cbz	x25, LFQH_LBB283_14
mov	x27, x0
LFQH_Lloh5456:
adr x0, LFQH_l_.str.30
LFQH_Lloh5457:
nop
bl Lpatch + (0xa5a4 - PATCH_BASE)
mov	x1, x0
mov	x0, x25
bl Lpatch + (0xa5d4 - PATCH_BASE)
cmp	x0, x21
b.ne	LFQH_LBB283_14
cbz	x27, LFQH_LBB283_14
LFQH_Lloh5458:
adr x0, LFQH_l_.str.432
LFQH_Lloh5459:
nop
bl Lpatch + (0xa5a4 - PATCH_BASE)
mov	x1, x0
mov	x0, x27
bl Lpatch + (0xa5d4 - PATCH_BASE)
fcmp	d0, d8
b.ne	LFQH_LBB283_14
fcmp	d1, d9
b.ne	LFQH_LBB283_14
fcmp	d2, d10
b.ne	LFQH_LBB283_14
fcmp	d3, d11
b.eq	LFQH_LBB283_17
LFQH_LBB283_14:
scvtf	d12, x21
LFQH_Lloh5460:
adr x0, LFQH_l_.str.497
LFQH_Lloh5461:
nop
bl Lpatch + (0xa5b0 - PATCH_BASE)
mov	x25, x0
LFQH_Lloh5462:
adr x0, LFQH_l_.str.515
LFQH_Lloh5463:
nop
bl Lpatch + (0xa5a4 - PATCH_BASE)
mov	x1, x0
mov	x0, x25
fmov	d0, d12
bl Lpatch + (0xa5d4 - PATCH_BASE)
mov	x2, x0
LFQH_Lloh5464:
adr x1, LFQH_FullscreenLogStateKey
LFQH_Lloh5465:
nop
mov	x0, x20
mov	w3, #1
bl Lpatch + (0xa634 - PATCH_BASE)
LFQH_Lloh5466:
adr x0, LFQH_l_.str.512
LFQH_Lloh5467:
nop
bl Lpatch + (0xa5b0 - PATCH_BASE)
mov	x25, x0
LFQH_Lloh5468:
adr x0, LFQH_l_.str.513
LFQH_Lloh5469:
nop
bl Lpatch + (0xa5a4 - PATCH_BASE)
mov	x1, x0
mov	x0, x25
fmov	d0, d8
fmov	d1, d9
fmov	d2, d10
fmov	d3, d11
bl Lpatch + (0xa5d4 - PATCH_BASE)
mov	x2, x0
LFQH_Lloh5470:
adr x1, LFQH_FullscreenLogBoundsKey
LFQH_Lloh5471:
nop
mov	x0, x20
mov	w3, #1
bl Lpatch + (0xa634 - PATCH_BASE)
LFQH_Lloh5472:
adr x0, LFQH_l_.str.88
LFQH_Lloh5473:
nop
bl Lpatch + (0xa5b0 - PATCH_BASE)
mov	x25, x0
LFQH_Lloh5474:
adr x0, LFQH_l_.str.89
LFQH_Lloh5475:
nop
bl Lpatch + (0xa5a4 - PATCH_BASE)
mov	x1, x0
mov	x0, x25
bl Lpatch + (0xa5d4 - PATCH_BASE)
mov	x25, x0
str	x28, [sp, #8]
str	w24, [sp]
LFQH_Lloh5476:
adr x24, LFQH_l_.str.361
LFQH_Lloh5477:
nop
mov	x0, x24
bl Lpatch + (0xa5b0 - PATCH_BASE)
mov	x21, x0
LFQH_Lloh5478:
adr x27, LFQH_l_.str.387
LFQH_Lloh5479:
nop
mov	x0, x27
bl Lpatch + (0xa5a4 - PATCH_BASE)
mov	x1, x0
LFQH_Lloh5480:
adr x2, LFQH_l_.str.577
LFQH_Lloh5481:
nop
mov	x0, x21
bl Lpatch + (0xa5d4 - PATCH_BASE)
mov	x2, x0
LFQH_Lloh5482:
adr x1, LFQH_l_.str.92
LFQH_Lloh5483:
nop
mov	x0, x25
bl	LFQH_Put
cmp	w19, #0
ccmp	x26, #0, #4, ne
cset	w8, ne
cmp	x28, #2
cset	w9, eq
LFQH_Lloh5484:
adr x10, LFQH_l_.str.376
LFQH_Lloh5485:
nop
LFQH_Lloh5486:
adr x11, LFQH_l_.str.579
LFQH_Lloh5487:
nop
ands	w8, w8, w9
str	w8, [sp, #4]
csel	x21, x11, x10, ne
mov	x0, x24
bl Lpatch + (0xa5b0 - PATCH_BASE)
mov	x28, x0
mov	x0, x27
bl Lpatch + (0xa5a4 - PATCH_BASE)
mov	x1, x0
mov	x0, x28
mov	x2, x21
bl Lpatch + (0xa5d4 - PATCH_BASE)
mov	x2, x0
LFQH_Lloh5488:
adr x1, LFQH_l_.str.578
LFQH_Lloh5489:
nop
mov	x0, x25
bl	LFQH_Put
LFQH_Lloh5490:
adr x24, LFQH_l_.str.497
LFQH_Lloh5491:
nop
mov	x0, x24
bl Lpatch + (0xa5b0 - PATCH_BASE)
mov	x21, x0
LFQH_Lloh5492:
adr x28, LFQH_l_.str.499
LFQH_Lloh5493:
nop
mov	x0, x28
bl Lpatch + (0xa5a4 - PATCH_BASE)
mov	x1, x0
mov	x0, x21
ldr	w2, [sp]
bl Lpatch + (0xa5d4 - PATCH_BASE)
mov	x2, x0
LFQH_Lloh5494:
adr x1, LFQH_l_.str.565
LFQH_Lloh5495:
nop
mov	x0, x25
bl	LFQH_Put
mov	x0, x24
bl Lpatch + (0xa5b0 - PATCH_BASE)
mov	x21, x0
mov	x0, x28
bl Lpatch + (0xa5a4 - PATCH_BASE)
mov	x1, x0
mov	x0, x21
mov	x2, x23
bl Lpatch + (0xa5d4 - PATCH_BASE)
mov	x2, x0
LFQH_Lloh5496:
adr x1, LFQH_l_.str.580
LFQH_Lloh5497:
nop
mov	x0, x25
bl	LFQH_Put
mov	x0, x24
bl Lpatch + (0xa5b0 - PATCH_BASE)
mov	x21, x0
mov	x0, x28
bl Lpatch + (0xa5a4 - PATCH_BASE)
mov	x1, x0
mov	x0, x21
mov	x2, x19
bl Lpatch + (0xa5d4 - PATCH_BASE)
mov	x2, x0
LFQH_Lloh5498:
adr x1, LFQH_l_.str.581
LFQH_Lloh5499:
nop
mov	x0, x25
bl	LFQH_Put
mov	x0, x24
bl Lpatch + (0xa5b0 - PATCH_BASE)
mov	x21, x0
mov	x0, x28
bl Lpatch + (0xa5a4 - PATCH_BASE)
mov	x1, x0
mov	x0, x21
ldr	w2, [sp, #4]
bl Lpatch + (0xa5d4 - PATCH_BASE)
mov	x2, x0
LFQH_Lloh5500:
adr x1, LFQH_l_.str.582
LFQH_Lloh5501:
nop
mov	x0, x25
bl	LFQH_Put
ldr	x8, [sp, #8]
scvtf	d12, x8
mov	x0, x24
bl Lpatch + (0xa5b0 - PATCH_BASE)
mov	x21, x0
LFQH_Lloh5502:
adr x0, LFQH_l_.str.515
LFQH_Lloh5503:
nop
bl Lpatch + (0xa5a4 - PATCH_BASE)
mov	x1, x0
mov	x0, x21
fmov	d0, d12
bl Lpatch + (0xa5d4 - PATCH_BASE)
mov	x2, x0
LFQH_Lloh5504:
adr x1, LFQH_l_.str.574
LFQH_Lloh5505:
nop
mov	x0, x25
bl	LFQH_Put
fmov	d0, d8
fmov	d1, d9
fmov	d2, d10
fmov	d3, d11
bl	LFQH_RectArray
mov	x2, x0
LFQH_Lloh5506:
adr x1, LFQH_l_.str.583
LFQH_Lloh5507:
nop
mov	x0, x25
bl	LFQH_Put
cbz	x22, LFQH_LBB283_16
LFQH_Lloh5508:
adr x0, LFQH_l_.str.24
LFQH_Lloh5509:
nop
bl Lpatch + (0xa5a4 - PATCH_BASE)
mov	x1, x0
mov	x0, x22
bl Lpatch + (0xa5d4 - PATCH_BASE)
bl	LFQH_RectArray
mov	x2, x0
LFQH_Lloh5510:
adr x1, LFQH_l_.str.584
LFQH_Lloh5511:
nop
mov	x0, x25
bl	LFQH_Put
LFQH_Lloh5512:
adr x0, LFQH_l_.str.507
LFQH_Lloh5513:
nop
bl Lpatch + (0xa5a4 - PATCH_BASE)
mov	x1, x0
mov	x0, x20
fmov	d0, d8
fmov	d1, d9
fmov	d2, d10
fmov	d3, d11
mov	x2, x22
bl Lpatch + (0xa5d4 - PATCH_BASE)
bl	LFQH_RectArray
mov	x2, x0
LFQH_Lloh5514:
adr x1, LFQH_l_.str.585
LFQH_Lloh5515:
nop
mov	x0, x25
bl	LFQH_Put
LFQH_LBB283_16:
LFQH_Lloh5516:
adr x0, LFQH_l_.str.586
LFQH_Lloh5517:
nop
mov	x1, x25
bl Lrecord_named
LFQH_LBB283_17:
mov	x0, x19
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
.cfi_endproc
.p2align	2
LFQH_FullscreenPlayersKey:
.cfi_startproc
ret
.cfi_endproc
.p2align	2
LFQH_FullscreenFillViewport:
.cfi_startproc
sub	sp, sp, #160
stp	d15, d14, [sp, #16]
stp	d13, d12, [sp, #32]
stp	d11, d10, [sp, #48]
stp	d9, d8, [sp, #64]
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
.cfi_offset b8, -88
.cfi_offset b9, -96
.cfi_offset b10, -104
.cfi_offset b11, -112
.cfi_offset b12, -120
.cfi_offset b13, -128
.cfi_offset b14, -136
.cfi_offset b15, -144
mov	x19, x1
mov	x20, x0
LFQH_Lloh5518:
adr x0, LFQH_l_.str.570
LFQH_Lloh5519:
nop
bl Lpatch + (0xa5a4 - PATCH_BASE)
mov	x1, x0
mov	x0, x20
bl Lpatch + (0xa5d4 - PATCH_BASE)
cbz	w0, LFQH_LBB285_18
mov	w0, #9
bl	LFQH_PageOptionEnabled
cbz	w0, LFQH_LBB285_18
LFQH_Lloh5520:
adr x21, LFQH_l_.str.20
LFQH_Lloh5521:
nop
mov	x0, x20
mov	x1, x21
bl	LFQH_Get
mov	x22, x0
mov	x1, x21
bl	LFQH_Get
mov	x21, x0
LFQH_Lloh5522:
adr x1, LFQH_l_.str.571
LFQH_Lloh5523:
nop
bl	LFQH_Kind
mov	x23, x0
cbz	w0, LFQH_LBB285_5
LFQH_Lloh5524:
adr x0, LFQH_l_.str.572
LFQH_Lloh5525:
nop
bl Lpatch + (0xa5a4 - PATCH_BASE)
mov	x1, x0
mov	x0, x21
bl Lpatch + (0xa5d4 - PATCH_BASE)
cbz	w0, LFQH_LBB285_5
LFQH_LBB285_4:
mov	w0, #0
b	LFQH_LBB285_18
LFQH_LBB285_5:
LFQH_Lloh5526:
adr x1, LFQH_l_.str.74
LFQH_Lloh5527:
nop
mov	x0, x20
bl	LFQH_Get
cbz	x0, LFQH_LBB285_18
mov	x24, x0
LFQH_Lloh5528:
adr x25, LFQH_l_.str.24
LFQH_Lloh5529:
nop
mov	x0, x25
bl Lpatch + (0xa5a4 - PATCH_BASE)
mov	x1, x0
mov	x0, x20
bl Lpatch + (0xa5d4 - PATCH_BASE)
fmov	d10, d0
fmov	d11, d1
fmov	d8, d2
fmov	d9, d3
mov	x0, x25
bl Lpatch + (0xa5a4 - PATCH_BASE)
mov	x1, x0
mov	x0, x24
bl Lpatch + (0xa5d4 - PATCH_BASE)
mov	w0, #0
fcmp	d8, d9
b.ls	LFQH_LBB285_18
fcmp	d9, #0.0
b.ls	LFQH_LBB285_18
fmov	d13, d0
fmov	d12, d1
fmov	d15, d2
fmov	d14, d3
LFQH_Lloh5530:
adr x0, LFQH_l_.str.507
LFQH_Lloh5531:
nop
bl Lpatch + (0xa5a4 - PATCH_BASE)
mov	x1, x0
mov	x0, x20
fmov	d0, d10
fmov	d1, d11
fmov	d2, d8
fmov	d3, d9
mov	x2, x24
bl Lpatch + (0xa5d4 - PATCH_BASE)
fabd	d2, d2, d15
fmov	d4, #1.00000000
fcmp	d2, d4
b.gt	LFQH_LBB285_4
fabd	d2, d3, d14
fcmp	d2, d4
b.gt	LFQH_LBB285_4
cbz	w23, LFQH_LBB285_15
LFQH_Lloh5532:
adr x1, LFQH_l_.str.573
LFQH_Lloh5533:
nop
mov	x0, x21
bl	LFQH_Get
cmp	x0, x22
b.ne	LFQH_LBB285_4
LFQH_Lloh5534:
adr x0, LFQH_l_.str.507
LFQH_Lloh5535:
nop
bl Lpatch + (0xa5a4 - PATCH_BASE)
mov	x1, x0
mov	x0, x20
fmov	d0, d10
fmov	d1, d11
fmov	d2, d8
fmov	d3, d9
mov	x2, x21
bl Lpatch + (0xa5d4 - PATCH_BASE)
stp	d0, d1, [sp]
fmov	d15, d2
fmov	d14, d3
LFQH_Lloh5536:
adr x0, LFQH_l_.str.24
LFQH_Lloh5537:
nop
bl Lpatch + (0xa5a4 - PATCH_BASE)
mov	x1, x0
mov	x0, x21
bl Lpatch + (0xa5d4 - PATCH_BASE)
fmov	d13, d0
fmov	d12, d1
fabd	d1, d15, d2
fmov	d0, #1.00000000
fcmp	d1, d0
b.gt	LFQH_LBB285_4
fabd	d1, d14, d3
fcmp	d1, d0
b.gt	LFQH_LBB285_4
ldp	d0, d1, [sp]
LFQH_LBB285_15:
fabd	d2, d0, d13
fmov	d0, #1.00000000
fcmp	d2, d0
b.gt	LFQH_LBB285_4
fabd	d1, d1, d12
fcmp	d1, d0
b.gt	LFQH_LBB285_4
stp	d10, d11, [x19]
mov	w0, #1
stp	d8, d9, [x19, #16]
LFQH_LBB285_18:
ldp	x29, x30, [sp, #144]
ldp	x20, x19, [sp, #128]
ldp	x22, x21, [sp, #112]
ldp	x24, x23, [sp, #96]
ldp	x26, x25, [sp, #80]
ldp	d9, d8, [sp, #64]
ldp	d11, d10, [sp, #48]
ldp	d13, d12, [sp, #32]
ldp	d15, d14, [sp, #16]
add	sp, sp, #160
ret
.cfi_endproc
.p2align	2
LFQH_FullscreenScale:
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
cbz	x0, LFQH_LBB286_9
mov	x21, x1
mov	x19, x0
LFQH_Lloh5538:
adr x1, LFQH_FullscreenScaleBaselineKey
LFQH_Lloh5539:
nop
bl Lpatch + (0xa628 - PATCH_BASE)
mov	x22, x0
cbnz	w21, LFQH_LBB286_3
cbz	x22, LFQH_LBB286_9
LFQH_LBB286_3:
LFQH_Lloh5540:
adr x0, LFQH_l_.str.574
LFQH_Lloh5541:
nop
bl Lpatch + (0xa5a4 - PATCH_BASE)
mov	x1, x0
mov	x0, x19
bl Lpatch + (0xa5d4 - PATCH_BASE)
mov	x20, x0
cbz	w21, LFQH_LBB286_7
cmp	x20, #2
b.eq	LFQH_LBB286_7
LFQH_Lloh5542:
adr x0, LFQH_l_.str.497
LFQH_Lloh5543:
nop
bl Lpatch + (0xa5b0 - PATCH_BASE)
mov	x21, x0
LFQH_Lloh5544:
adr x0, LFQH_l_.str.575
LFQH_Lloh5545:
nop
bl Lpatch + (0xa5a4 - PATCH_BASE)
mov	x1, x0
mov	x0, x21
mov	x2, x20
bl Lpatch + (0xa5d4 - PATCH_BASE)
mov	x2, x0
LFQH_Lloh5546:
adr x1, LFQH_FullscreenScaleBaselineKey
LFQH_Lloh5547:
nop
mov	x0, x19
mov	w3, #1
bl Lpatch + (0xa634 - PATCH_BASE)
mov	w21, #2
LFQH_LBB286_6:
LFQH_Lloh5548:
adr x0, LFQH_l_.str.576
LFQH_Lloh5549:
nop
bl Lpatch + (0xa5a4 - PATCH_BASE)
mov	x1, x0
mov	x0, x19
mov	x2, x21
ldp	x29, x30, [sp, #32]
ldp	x20, x19, [sp, #16]
ldp	x22, x21, [sp], #48
b Lpatch + (0xa5d4 - PATCH_BASE)
LFQH_LBB286_7:
cbnz	w21, LFQH_LBB286_9
LFQH_Lloh5550:
adr x0, LFQH_l_.str.30
LFQH_Lloh5551:
nop
bl Lpatch + (0xa5a4 - PATCH_BASE)
mov	x1, x0
mov	x0, x22
bl Lpatch + (0xa5d4 - PATCH_BASE)
mov	x21, x0
LFQH_Lloh5552:
adr x1, LFQH_FullscreenScaleBaselineKey
LFQH_Lloh5553:
nop
mov	x0, x19
mov	x2, #0
mov	w3, #1
bl Lpatch + (0xa634 - PATCH_BASE)
cmp	x20, #2
b.eq	LFQH_LBB286_6
LFQH_LBB286_9:
ldp	x29, x30, [sp, #32]
ldp	x20, x19, [sp, #16]
ldp	x22, x21, [sp], #48
ret
.cfi_endproc
.p2align	2
LFQH_FullscreenScaleBaselineKey:
.cfi_startproc
ret
.cfi_endproc
.p2align	2
LFQH_FullscreenLogStateKey:
.cfi_startproc
ret
.cfi_endproc
.p2align	2
LFQH_FullscreenLogBoundsKey:
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
LFQH_Lloh5554:
adr x1, LFQH_l_.str.121
LFQH_Lloh5555:
nop
bl	LFQH_Kind
cbz	w0, LFQH_LBB290_3
mov	x0, x19
LFQH_LBB290_2:
ldp	x29, x30, [sp, #48]
ldp	x20, x19, [sp, #32]
ldp	x22, x21, [sp, #16]
ldp	x24, x23, [sp], #64
ret
LFQH_LBB290_3:
mov	x0, #0
cbz	x19, LFQH_LBB290_2
cbz	w20, LFQH_LBB290_2
LFQH_Lloh5556:
adr x1, LFQH_l_.str.592
LFQH_Lloh5557:
nop
mov	x0, x19
bl	LFQH_Get
mov	x19, x0
LFQH_Lloh5558:
adr x0, LFQH_l_.str.34
LFQH_Lloh5559:
nop
bl Lpatch + (0xa5a4 - PATCH_BASE)
mov	x1, x0
mov	x0, x19
bl Lpatch + (0xa5d4 - PATCH_BASE)
cbz	x0, LFQH_LBB290_2
mov	x21, x0
mov	x22, #0
sub	w20, w20, #1
LFQH_Lloh5560:
adr x23, LFQH_l_.str.461
LFQH_Lloh5561:
nop
LFQH_LBB290_7:
mov	x0, x23
bl Lpatch + (0xa5a4 - PATCH_BASE)
mov	x1, x0
mov	x0, x19
mov	x2, x22
bl Lpatch + (0xa5d4 - PATCH_BASE)
mov	x1, x20
bl	LFQH_FindTabOwner
cbnz	x0, LFQH_LBB290_2
add	x22, x22, #1
cmp	x21, x22
b.ne	LFQH_LBB290_7
mov	x0, #0
b	LFQH_LBB290_2
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
cbz	x0, LFQH_LBB293_6
mov	x22, x2
mov	x20, x1
mov	x19, x0
LFQH_Lloh5562:
adr x1, LFQH_PageTintKey
LFQH_Lloh5563:
nop
bl Lpatch + (0xa628 - PATCH_BASE)
cbz	x0, LFQH_LBB293_3
LFQH_Lloh5564:
adr x1, LFQH_l_.str.41
LFQH_Lloh5565:
nop
bl	LFQH_BoolProp
cmp	w0, w20
b.eq	LFQH_LBB293_6
LFQH_LBB293_3:
LFQH_Lloh5566:
adr x1, LFQH_l_.str.52
LFQH_Lloh5567:
nop
mov	x0, x19
bl	LFQH_Get
mov	x21, x0
LFQH_Lloh5568:
adr x0, LFQH_l_.str.53
LFQH_Lloh5569:
nop
bl Lpatch + (0xa5a4 - PATCH_BASE)
mov	x1, x0
mov	x0, x21
bl Lpatch + (0xa5d4 - PATCH_BASE)
cbz	x0, LFQH_LBB293_6
mov	x21, x0
cbz	w20, LFQH_LBB293_7
LFQH_Lloh5570:
adr x0, LFQH_l_.str.47
LFQH_Lloh5571:
nop
bl Lpatch + (0xa5b0 - PATCH_BASE)
mov	x23, x0
LFQH_Lloh5572:
adr x8, LFQH_l_.str.625
LFQH_Lloh5573:
nop
LFQH_Lloh5574:
adr x9, LFQH_l_.str.48
LFQH_Lloh5575:
nop
cmp	w22, #0
csel	x0, x9, x8, eq
bl Lpatch + (0xa5a4 - PATCH_BASE)
mov	x1, x0
mov	x0, x23
bl Lpatch + (0xa5d4 - PATCH_BASE)
mov	x22, x0
b	LFQH_LBB293_8
LFQH_LBB293_6:
ldp	x29, x30, [sp, #48]
ldp	x20, x19, [sp, #32]
ldp	x22, x21, [sp, #16]
ldp	x24, x23, [sp], #64
ret
LFQH_LBB293_7:
mov	x22, #0
LFQH_LBB293_8:
LFQH_Lloh5576:
adr x0, LFQH_l_.str.51
LFQH_Lloh5577:
nop
bl Lpatch + (0xa5a4 - PATCH_BASE)
mov	x1, x0
fmov	d0, #0.12500000
mov	x0, x22
bl Lpatch + (0xa5d4 - PATCH_BASE)
mov	x22, x0
LFQH_Lloh5578:
adr x0, LFQH_l_.str.54
LFQH_Lloh5579:
nop
bl Lpatch + (0xa5a4 - PATCH_BASE)
mov	x1, x0
mov	x0, x21
mov	x2, x22
bl Lpatch + (0xa5d4 - PATCH_BASE)
LFQH_Lloh5580:
adr x0, LFQH_l_.str.55
LFQH_Lloh5581:
nop
bl Lpatch + (0xa5a4 - PATCH_BASE)
mov	x1, x0
mov	x0, x19
mov	x2, x21
bl Lpatch + (0xa5d4 - PATCH_BASE)
LFQH_Lloh5582:
adr x0, LFQH_l_.str.56
LFQH_Lloh5583:
nop
bl Lpatch + (0xa5a4 - PATCH_BASE)
mov	x1, x0
mov	x0, x21
bl Lpatch + (0xa5d4 - PATCH_BASE)
LFQH_Lloh5584:
adr x0, LFQH_l_.str.497
LFQH_Lloh5585:
nop
bl Lpatch + (0xa5b0 - PATCH_BASE)
mov	x21, x0
LFQH_Lloh5586:
adr x0, LFQH_l_.str.499
LFQH_Lloh5587:
nop
bl Lpatch + (0xa5a4 - PATCH_BASE)
mov	x1, x0
mov	x0, x21
mov	x2, x20
bl Lpatch + (0xa5d4 - PATCH_BASE)
mov	x2, x0
LFQH_Lloh5588:
adr x1, LFQH_PageTintKey
LFQH_Lloh5589:
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
cbz	x0, LFQH_LBB294_12
mov	x21, x1
mov	x19, x0
LFQH_Lloh5590:
adr x0, LFQH_l_.str.441
LFQH_Lloh5591:
nop
bl Lpatch + (0xa5a4 - PATCH_BASE)
mov	x1, x0
mov	x0, x19
bl Lpatch + (0xa5d4 - PATCH_BASE)
mov	x20, x0
LFQH_Lloh5592:
adr x1, LFQH_ShelfTitleGlassFontKey
LFQH_Lloh5593:
nop
mov	x0, x19
bl Lpatch + (0xa628 - PATCH_BASE)
cbz	x0, LFQH_LBB294_5
mov	x22, x0
cmp	x20, x0
b.eq	LFQH_LBB294_11
LFQH_Lloh5594:
adr x0, LFQH_l_.str.49
LFQH_Lloh5595:
nop
bl Lpatch + (0xa5a4 - PATCH_BASE)
mov	x1, x0
mov	x0, x20
mov	x2, x22
bl Lpatch + (0xa5d4 - PATCH_BASE)
cmp	w0, #0
cset	w8, ne
cbnz	w21, LFQH_LBB294_7
cbnz	w0, LFQH_LBB294_13
b	LFQH_LBB294_14
LFQH_LBB294_5:
cbz	w21, LFQH_LBB294_12
mov	w8, #0
LFQH_LBB294_7:
cbz	x20, LFQH_LBB294_12
tbnz	w8, #0, LFQH_LBB294_12
LFQH_Lloh5596:
adr x0, LFQH_l_.str.442
LFQH_Lloh5597:
nop
bl Lpatch + (0xa5a4 - PATCH_BASE)
mov	x1, x0
mov	x0, x20
bl Lpatch + (0xa5d4 - PATCH_BASE)
fmov	d8, d0
LFQH_Lloh5598:
adr x0, LFQH_l_.str.443
LFQH_Lloh5599:
nop
bl Lpatch + (0xa5a4 - PATCH_BASE)
mov	x1, x0
fmov	d0, #0.87500000
fmul	d0, d8, d0
mov	x0, x20
bl Lpatch + (0xa5d4 - PATCH_BASE)
cbz	x0, LFQH_LBB294_12
mov	x21, x0
LFQH_Lloh5600:
adr x1, LFQH_ShelfTitleHostFontKey
LFQH_Lloh5601:
nop
mov	x0, x19
mov	x2, x20
mov	w3, #1
bl Lpatch + (0xa634 - PATCH_BASE)
LFQH_Lloh5602:
adr x1, LFQH_ShelfTitleGlassFontKey
LFQH_Lloh5603:
nop
mov	x0, x19
mov	x2, x21
mov	w3, #1
bl Lpatch + (0xa634 - PATCH_BASE)
LFQH_Lloh5604:
adr x0, LFQH_l_.str.162
LFQH_Lloh5605:
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
LFQH_LBB294_11:
cbz	w21, LFQH_LBB294_13
LFQH_LBB294_12:
ldp	x29, x30, [sp, #48]
ldp	x20, x19, [sp, #32]
ldp	x22, x21, [sp, #16]
ldp	d9, d8, [sp], #64
ret
LFQH_LBB294_13:
LFQH_Lloh5606:
adr x0, LFQH_l_.str.162
LFQH_Lloh5607:
nop
bl Lpatch + (0xa5a4 - PATCH_BASE)
mov	x20, x0
LFQH_Lloh5608:
adr x1, LFQH_ShelfTitleHostFontKey
LFQH_Lloh5609:
nop
mov	x0, x19
bl Lpatch + (0xa628 - PATCH_BASE)
mov	x2, x0
mov	x0, x19
mov	x1, x20
bl Lpatch + (0xa5d4 - PATCH_BASE)
LFQH_LBB294_14:
LFQH_Lloh5610:
adr x1, LFQH_ShelfTitleHostFontKey
LFQH_Lloh5611:
nop
mov	x0, x19
mov	x2, #0
mov	w3, #1
bl Lpatch + (0xa634 - PATCH_BASE)
LFQH_Lloh5612:
adr x1, LFQH_ShelfTitleGlassFontKey
LFQH_Lloh5613:
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
LFQH_ReaderGlassWillAppear:
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
LFQH_Lloh5614:
adr x1, LFQH_l_.str.646
LFQH_Lloh5615:
nop
bl	LFQH_Get
LFQH_Lloh5616:
adr x1, LFQH_l_.str.647
LFQH_Lloh5617:
nop
bl	LFQH_Get
LFQH_Lloh5618:
adr x1, LFQH_l_.str.648
LFQH_Lloh5619:
nop
bl	LFQH_Get
mov	x1, x0
mov	x0, x21
bl	LFQH_ApplyReaderGlassStyle
LFQH_Lloh5620:
adr x0, LFQH_l_.str.637
LFQH_Lloh5621:
nop
LFQH_Lloh5622:
adr x1, LFQH_l_.str.643
LFQH_Lloh5623:
nop
bl	LFQH_Original
mov	x3, x0
mov	x0, x21
mov	x1, x20
mov	x2, x19
ldp	x29, x30, [sp, #32]
ldp	x20, x19, [sp, #16]
ldp	x22, x21, [sp], #48
br	x3
.cfi_endproc
.p2align	2
LFQH_ReaderGlassThemeChanged:
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
mov	x1, x2
bl	LFQH_ApplyReaderGlassStyle
LFQH_Lloh5624:
adr x0, LFQH_l_.str.637
LFQH_Lloh5625:
nop
LFQH_Lloh5626:
adr x1, LFQH_l_.str.645
LFQH_Lloh5627:
nop
bl	LFQH_Original
mov	x3, x0
mov	x0, x21
mov	x1, x20
mov	x2, x19
ldp	x29, x30, [sp, #32]
ldp	x20, x19, [sp, #16]
ldp	x22, x21, [sp], #48
br	x3
.cfi_endproc
.p2align	2
LFQH_ApplyReaderGlassStyle:
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
mov	x21, x1
mov	x19, x0
LFQH_Lloh5628:
adr x1, LFQH_ReaderStyleAppliedKey
LFQH_Lloh5629:
nop
bl Lpatch + (0xa628 - PATCH_BASE)
mov	x22, x0
bl	LFQH_Enabled
cbz	w0, LFQH_LBB300_2
LFQH_Lloh5630:
adr x1, LFQH_l_.str.638
LFQH_Lloh5631:
nop
mov	x0, x21
bl	LFQH_Kind
cmp	w0, #0
cset	w24, ne
cbz	x22, LFQH_LBB300_3
b	LFQH_LBB300_5
LFQH_LBB300_2:
mov	w24, #0
cbnz	x22, LFQH_LBB300_5
LFQH_LBB300_3:
cbnz	w24, LFQH_LBB300_5
LFQH_LBB300_4:
ldp	x29, x30, [sp, #64]
ldp	x20, x19, [sp, #48]
ldp	x22, x21, [sp, #32]
ldp	x24, x23, [sp, #16]
ldp	x26, x25, [sp], #80
ret
LFQH_LBB300_5:
LFQH_Lloh5632:
adr x0, LFQH_l_.str.133
LFQH_Lloh5633:
nop
bl Lpatch + (0xa5a4 - PATCH_BASE)
mov	x1, x0
mov	x0, x19
bl Lpatch + (0xa5d4 - PATCH_BASE)
mov	x20, x0
LFQH_Lloh5634:
adr x0, LFQH_l_.str.30
LFQH_Lloh5635:
nop
bl Lpatch + (0xa5a4 - PATCH_BASE)
mov	x1, x0
mov	x0, x22
bl Lpatch + (0xa5d4 - PATCH_BASE)
mov	x23, x0
tbz	w24, #0, LFQH_LBB300_11
LFQH_Lloh5636:
adr x0, LFQH_l_.str.639
LFQH_Lloh5637:
nop
bl Lpatch + (0xa5a4 - PATCH_BASE)
mov	x1, x0
mov	x0, x21
bl Lpatch + (0xa5d4 - PATCH_BASE)
cmp	x0, #1
mov	w8, #1
cinc	x21, x8, eq
cmp	x20, x21
b.eq	LFQH_LBB300_4
LFQH_Lloh5638:
adr x0, LFQH_l_.str.497
LFQH_Lloh5639:
nop
bl Lpatch + (0xa5b0 - PATCH_BASE)
mov	x24, x0
LFQH_Lloh5640:
adr x0, LFQH_l_.str.575
LFQH_Lloh5641:
nop
bl Lpatch + (0xa5a4 - PATCH_BASE)
mov	x25, x0
cbz	x22, LFQH_LBB300_9
cmp	x20, x23
b.eq	LFQH_LBB300_10
LFQH_LBB300_9:
mov	x0, x24
mov	x1, x25
mov	x2, x20
bl Lpatch + (0xa5d4 - PATCH_BASE)
mov	x2, x0
LFQH_Lloh5642:
adr x1, LFQH_ReaderStyleOriginalKey
LFQH_Lloh5643:
nop
mov	x0, x19
mov	w3, #1
bl Lpatch + (0xa634 - PATCH_BASE)
LFQH_LBB300_10:
mov	x0, x24
mov	x1, x25
mov	x2, x21
bl Lpatch + (0xa5d4 - PATCH_BASE)
mov	x2, x0
LFQH_Lloh5644:
adr x1, LFQH_ReaderStyleAppliedKey
LFQH_Lloh5645:
nop
mov	x0, x19
mov	w3, #1
bl Lpatch + (0xa634 - PATCH_BASE)
b	LFQH_LBB300_12
LFQH_LBB300_11:
LFQH_Lloh5646:
adr x22, LFQH_ReaderStyleOriginalKey
LFQH_Lloh5647:
nop
mov	x0, x19
mov	x1, x22
bl Lpatch + (0xa628 - PATCH_BASE)
mov	x21, x0
LFQH_Lloh5648:
adr x0, LFQH_l_.str.30
LFQH_Lloh5649:
nop
bl Lpatch + (0xa5a4 - PATCH_BASE)
mov	x1, x0
mov	x0, x21
bl Lpatch + (0xa5d4 - PATCH_BASE)
mov	x21, x0
LFQH_Lloh5650:
adr x1, LFQH_ReaderStyleAppliedKey
LFQH_Lloh5651:
nop
mov	x0, x19
mov	x2, #0
mov	w3, #1
bl Lpatch + (0xa634 - PATCH_BASE)
mov	x0, x19
mov	x1, x22
mov	x2, #0
mov	w3, #1
bl Lpatch + (0xa634 - PATCH_BASE)
cmp	x20, x23
b.ne	LFQH_LBB300_4
LFQH_LBB300_12:
LFQH_Lloh5652:
adr x0, LFQH_l_.str.134
LFQH_Lloh5653:
nop
bl Lpatch + (0xa5a4 - PATCH_BASE)
mov	x1, x0
mov	x0, x19
mov	x2, x21
ldp	x29, x30, [sp, #64]
ldp	x20, x19, [sp, #48]
ldp	x22, x21, [sp, #32]
ldp	x24, x23, [sp, #16]
ldp	x26, x25, [sp], #80
b Lpatch + (0xa5d4 - PATCH_BASE)
.cfi_endproc
.p2align	2
LFQH_ReaderStyleAppliedKey:
.cfi_startproc
ret
.cfi_endproc
.p2align	2
LFQH_ReaderStyleOriginalKey:
.cfi_startproc
ret
.cfi_endproc
.p2align	2
LFQH_ReaderLocalTheme:
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
mov	x21, x2
mov	x23, x1
mov	x22, x0
mov	w0, #11
bl	LFQH_PageOptionEnabled
cbz	w0, LFQH_LBB303_4
LFQH_Lloh5654:
adr x0, LFQH_l_.str.639
LFQH_Lloh5655:
nop
bl Lpatch + (0xa5a4 - PATCH_BASE)
mov	x1, x0
mov	x0, x21
bl Lpatch + (0xa5d4 - PATCH_BASE)
mov	x23, x0
LFQH_Lloh5656:
adr x0, LFQH_l_.str.653
LFQH_Lloh5657:
nop
bl Lpatch + (0xa5a4 - PATCH_BASE)
mov	x1, x0
cmp	x23, #1
cset	w2, eq
mov	x0, x22
bl Lpatch + (0xa5d4 - PATCH_BASE)
LFQH_Lloh5658:
adr x1, LFQH_l_.str.670
LFQH_Lloh5659:
nop
mov	x0, x22
bl	LFQH_Get
LFQH_Lloh5660:
adr x1, LFQH_l_.str.671
LFQH_Lloh5661:
nop
bl	LFQH_Get
cbz	x0, LFQH_LBB303_3
mov	x1, x21
bl	LFQH_TrackReaderThemePreset
LFQH_LBB303_3:
LFQH_Lloh5662:
adr x0, LFQH_l_.str.649
LFQH_Lloh5663:
nop
bl Lpatch + (0xa5a4 - PATCH_BASE)
mov	x1, x0
mov	x0, x22
mov	x2, x21
mov	x3, x20
mov	x4, x19
ldp	x29, x30, [sp, #48]
ldp	x20, x19, [sp, #32]
ldp	x22, x21, [sp, #16]
ldp	x24, x23, [sp], #64
b Lpatch + (0xa5d4 - PATCH_BASE)
LFQH_LBB303_4:
LFQH_Lloh5664:
adr x0, LFQH_l_.str.650
LFQH_Lloh5665:
nop
bl Lpatch + (0xa5a4 - PATCH_BASE)
LFQH_Lloh5666:
adr x8, LFQH_l_.str.655
LFQH_Lloh5667:
nop
LFQH_Lloh5668:
adr x9, LFQH_l_.str.145
LFQH_Lloh5669:
nop
cmp	x0, x23
csel	x1, x9, x8, eq
LFQH_Lloh5670:
adr x0, LFQH_l_.str.144
LFQH_Lloh5671:
nop
bl	LFQH_Original
mov	x5, x0
mov	x0, x22
mov	x1, x23
mov	x2, x21
mov	x3, x20
mov	x4, x19
ldp	x29, x30, [sp, #48]
ldp	x20, x19, [sp, #32]
ldp	x22, x21, [sp, #16]
ldp	x24, x23, [sp], #64
br	x5
.cfi_endproc
.p2align	2
LFQH_ReaderThemeToApp:
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
mov	w0, #11
bl	LFQH_PageOptionEnabled
cbz	w0, LFQH_LBB304_2
ldp	x29, x30, [sp, #32]
ldp	x20, x19, [sp, #16]
ldp	x22, x21, [sp], #48
ret
LFQH_LBB304_2:
LFQH_Lloh5672:
adr x0, LFQH_l_.str.142
LFQH_Lloh5673:
nop
LFQH_Lloh5674:
adr x1, LFQH_l_.str.656
LFQH_Lloh5675:
nop
bl	LFQH_Original
mov	x4, x0
mov	x0, x22
mov	x1, x21
mov	x2, x20
mov	x3, x19
ldp	x29, x30, [sp, #32]
ldp	x20, x19, [sp, #16]
ldp	x22, x21, [sp], #48
br	x4
.cfi_endproc
.p2align	2
LFQH_ReaderThemeFromApp:
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
mov	w0, #11
bl	LFQH_PageOptionEnabled
cbz	w0, LFQH_LBB305_2
ldp	x29, x30, [sp, #32]
ldp	x20, x19, [sp, #16]
ldp	x22, x21, [sp], #48
ret
LFQH_LBB305_2:
LFQH_Lloh5676:
adr x0, LFQH_l_.str.657
LFQH_Lloh5677:
nop
bl Lpatch + (0xa5a4 - PATCH_BASE)
LFQH_Lloh5678:
adr x8, LFQH_l_.str.660
LFQH_Lloh5679:
nop
LFQH_Lloh5680:
adr x9, LFQH_l_.str.658
LFQH_Lloh5681:
nop
cmp	x0, x20
csel	x1, x9, x8, eq
LFQH_Lloh5682:
adr x0, LFQH_l_.str.144
LFQH_Lloh5683:
nop
bl	LFQH_Original
mov	x3, x0
mov	x0, x21
mov	x1, x20
mov	x2, x19
ldp	x29, x30, [sp, #32]
ldp	x20, x19, [sp, #16]
ldp	x22, x21, [sp], #48
br	x3
.cfi_endproc
.p2align	2
LFQH_ReaderThemePaletteChoice:
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
mov	w0, #11
bl	LFQH_PageOptionEnabled
cbz	w0, LFQH_LBB306_2
mov	x0, x22
mov	x1, x19
bl	LFQH_TrackReaderThemePreset
LFQH_LBB306_2:
LFQH_Lloh5684:
adr x0, LFQH_l_.str.191
LFQH_Lloh5685:
nop
LFQH_Lloh5686:
adr x1, LFQH_l_.str.666
LFQH_Lloh5687:
nop
bl	LFQH_Original
mov	x4, x0
mov	x0, x22
mov	x1, x21
mov	x2, x20
mov	x3, x19
ldp	x29, x30, [sp, #32]
ldp	x20, x19, [sp, #16]
ldp	x22, x21, [sp], #48
br	x4
.cfi_endproc
.p2align	2
LFQH_ReaderThemeWillAppear:
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
LFQH_Lloh5688:
adr x0, LFQH_l_.str.667
LFQH_Lloh5689:
nop
LFQH_Lloh5690:
adr x1, LFQH_l_.str.669
LFQH_Lloh5691:
nop
bl	LFQH_Original
mov	x8, x0
mov	x0, x19
mov	x1, x20
mov	x2, x21
blr	x8
mov	w0, #11
bl	LFQH_PageOptionEnabled
cbz	w0, LFQH_LBB307_11
LFQH_Lloh5692:
adr x0, LFQH_l_.str.467
LFQH_Lloh5693:
nop
bl Lpatch + (0xa5b0 - PATCH_BASE)
mov	x20, x0
LFQH_Lloh5694:
adr x0, LFQH_l_.str.468
LFQH_Lloh5695:
nop
bl Lpatch + (0xa5a4 - PATCH_BASE)
mov	x1, x0
mov	x0, x20
bl Lpatch + (0xa5d4 - PATCH_BASE)
mov	x20, x0
LFQH_Lloh5696:
adr x0, LFQH_l_.str.536
LFQH_Lloh5697:
nop
bl Lpatch + (0xa5a4 - PATCH_BASE)
mov	x22, x0
LFQH_Lloh5698:
adr x23, LFQH_l_.str.361
LFQH_Lloh5699:
nop
mov	x0, x23
bl Lpatch + (0xa5b0 - PATCH_BASE)
mov	x24, x0
LFQH_Lloh5700:
adr x0, LFQH_l_.str.387
LFQH_Lloh5701:
nop
bl Lpatch + (0xa5a4 - PATCH_BASE)
mov	x1, x0
LFQH_Lloh5702:
adr x2, LFQH_l_.str.674
LFQH_Lloh5703:
nop
mov	x0, x24
bl Lpatch + (0xa5d4 - PATCH_BASE)
mov	x2, x0
mov	x0, x20
mov	x1, x22
bl Lpatch + (0xa5d4 - PATCH_BASE)
mov	x20, x0
mov	x1, x23
bl	LFQH_Kind
cbz	w0, LFQH_LBB307_11
LFQH_Lloh5704:
adr x1, LFQH_l_.str.647
LFQH_Lloh5705:
nop
mov	x0, x21
bl	LFQH_Get
LFQH_Lloh5706:
adr x1, LFQH_l_.str.648
LFQH_Lloh5707:
nop
bl	LFQH_Get
LFQH_Lloh5708:
adr x1, LFQH_l_.str.672
LFQH_Lloh5709:
nop
bl	LFQH_Get
cbz	x20, LFQH_LBB307_5
mov	x21, x0
cmp	x20, x0
b.eq	LFQH_LBB307_11
LFQH_Lloh5710:
adr x0, LFQH_l_.str.49
LFQH_Lloh5711:
nop
bl Lpatch + (0xa5a4 - PATCH_BASE)
mov	x1, x0
mov	x0, x20
mov	x2, x21
bl Lpatch + (0xa5d4 - PATCH_BASE)
cbnz	w0, LFQH_LBB307_11
LFQH_LBB307_5:
LFQH_Lloh5712:
adr x1, LFQH_l_.str.673
LFQH_Lloh5713:
nop
mov	x0, x19
bl	LFQH_Get
mov	x21, x0
LFQH_Lloh5714:
adr x1, LFQH_l_.str.671
LFQH_Lloh5715:
nop
mov	x0, x19
bl	LFQH_Get
mov	x19, x0
LFQH_Lloh5716:
adr x1, LFQH_l_.str.663
LFQH_Lloh5717:
nop
mov	x0, x21
bl	LFQH_Kind
cbz	w0, LFQH_LBB307_11
LFQH_Lloh5718:
adr x1, LFQH_l_.str.191
LFQH_Lloh5719:
nop
mov	x0, x19
bl	LFQH_Kind
cbz	w0, LFQH_LBB307_11
LFQH_Lloh5720:
adr x0, LFQH_l_.str.664
LFQH_Lloh5721:
nop
bl Lpatch + (0xa5a4 - PATCH_BASE)
mov	x1, x0
mov	x0, x21
mov	x2, x20
bl Lpatch + (0xa5d4 - PATCH_BASE)
mov	x21, x0
LFQH_Lloh5722:
adr x1, LFQH_l_.str.672
LFQH_Lloh5723:
nop
bl	LFQH_Get
cbz	x20, LFQH_LBB307_11
mov	x22, x0
cmp	x20, x0
b.eq	LFQH_LBB307_10
LFQH_Lloh5724:
adr x0, LFQH_l_.str.49
LFQH_Lloh5725:
nop
bl Lpatch + (0xa5a4 - PATCH_BASE)
mov	x1, x0
mov	x0, x20
mov	x2, x22
bl Lpatch + (0xa5d4 - PATCH_BASE)
cbz	w0, LFQH_LBB307_11
LFQH_LBB307_10:
LFQH_Lloh5726:
adr x0, LFQH_l_.str.644
LFQH_Lloh5727:
nop
bl Lpatch + (0xa5a4 - PATCH_BASE)
mov	x1, x0
mov	x0, x19
mov	x2, x21
ldp	x29, x30, [sp, #48]
ldp	x20, x19, [sp, #32]
ldp	x22, x21, [sp, #16]
ldp	x24, x23, [sp], #64
b Lpatch + (0xa5d4 - PATCH_BASE)
LFQH_LBB307_11:
ldp	x29, x30, [sp, #48]
ldp	x20, x19, [sp, #32]
ldp	x22, x21, [sp, #16]
ldp	x24, x23, [sp], #64
ret
.cfi_endproc
.p2align	2
LFQH_TrackReaderThemePreset:
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
LFQH_Lloh5728:
adr x1, LFQH_l_.str.672
LFQH_Lloh5729:
nop
mov	x0, x8
bl	LFQH_Get
mov	x20, x0
LFQH_Lloh5730:
adr x1, LFQH_l_.str.361
LFQH_Lloh5731:
nop
bl	LFQH_Kind
cbz	w0, LFQH_LBB308_2
LFQH_Lloh5732:
adr x0, LFQH_l_.str.362
LFQH_Lloh5733:
nop
bl Lpatch + (0xa5a4 - PATCH_BASE)
mov	x1, x0
mov	x0, x20
bl Lpatch + (0xa5d4 - PATCH_BASE)
cbnz	x0, LFQH_LBB308_3
LFQH_LBB308_2:
mov	x20, #0
LFQH_LBB308_3:
LFQH_Lloh5734:
adr x1, LFQH_ReaderThemePendingKey
LFQH_Lloh5735:
nop
mov	x0, x19
mov	x2, x20
mov	w3, #1
ldp	x29, x30, [sp, #16]
ldp	x20, x19, [sp], #32
b Lpatch + (0xa634 - PATCH_BASE)
.cfi_endproc
.p2align	2
LFQH_ReaderThemePendingKey:
.cfi_startproc
ret
.cfi_endproc
.p2align	2
LFQH_DramaControlsLayout178R2:
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
LFQH_Lloh5736:
adr x0, LFQH_l_.str.73
LFQH_Lloh5737:
nop
LFQH_Lloh5738:
adr x1, LFQH_l_.str.676
LFQH_Lloh5739:
nop
bl	LFQH_Original
mov	x8, x0
mov	x0, x20
mov	x1, x19
blr	x8
mov	x0, x20
ldp	x29, x30, [sp, #16]
ldp	x20, x19, [sp], #32
b	LFQH_FQHDramaSpacing178R2
.cfi_endproc
.p2align	2
LFQH_DramaSeriesControlsLayout178R2:
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
LFQH_Lloh5740:
adr x0, LFQH_l_.str.675
LFQH_Lloh5741:
nop
LFQH_Lloh5742:
adr x1, LFQH_l_.str.677
LFQH_Lloh5743:
nop
bl	LFQH_Original
mov	x8, x0
mov	x0, x20
mov	x1, x19
blr	x8
mov	x0, x20
ldp	x29, x30, [sp, #16]
ldp	x20, x19, [sp], #32
b	LFQH_FQHDramaSpacing178R2
.cfi_endproc
.p2align	2
LFQH_DramaWatchGlass:
.cfi_startproc
sub	sp, sp, #112
stp	d11, d10, [sp, #16]
stp	d9, d8, [sp, #32]
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
.cfi_offset b8, -72
.cfi_offset b9, -80
.cfi_offset b10, -88
.cfi_offset b11, -96
mov	x20, x1
mov	x19, x0
LFQH_Lloh5744:
adr x1, LFQH_DramaWatchContentKey
LFQH_Lloh5745:
nop
bl Lpatch + (0xa628 - PATCH_BASE)
mov	x21, x0
LFQH_Lloh5746:
adr x1, LFQH_l_.str.679
LFQH_Lloh5747:
nop
mov	x0, x20
bl	LFQH_Get
LFQH_Lloh5748:
adr x1, LFQH_l_.str.680
LFQH_Lloh5749:
nop
bl	LFQH_Get
mov	x20, x0
LFQH_Lloh5750:
adr x1, LFQH_l_.str.681
LFQH_Lloh5751:
nop
bl	LFQH_Equal
cbnz	w0, LFQH_LBB312_3
LFQH_Lloh5752:
adr x1, LFQH_l_.str.682
LFQH_Lloh5753:
nop
mov	x0, x20
bl	LFQH_Equal
cbnz	w0, LFQH_LBB312_3
LFQH_Lloh5754:
adr x1, LFQH_l_.str.683
LFQH_Lloh5755:
nop
mov	x0, x20
bl	LFQH_Equal
cbz	w0, LFQH_LBB312_11
LFQH_LBB312_3:
bl	LFQH_Enabled
cbz	w0, LFQH_LBB312_11
bl	LFQH_FQHGlassAvailable
cbz	w0, LFQH_LBB312_11
LFQH_Lloh5756:
adr x1, LFQH_l_.str.684
LFQH_Lloh5757:
nop
mov	x0, x19
bl	LFQH_Get
mov	x20, x0
cmp	x0, x21
b.eq	LFQH_LBB312_7
mov	x0, x19
mov	x1, x21
bl	LFQH_RestoreDramaWatch
LFQH_LBB312_7:
LFQH_Lloh5758:
adr x1, LFQH_l_.str.685
LFQH_Lloh5759:
nop
mov	x0, x20
bl	LFQH_Kind
cbz	w0, LFQH_LBB312_9
LFQH_Lloh5760:
adr x0, LFQH_l_.str.20
LFQH_Lloh5761:
nop
bl Lpatch + (0xa5a4 - PATCH_BASE)
mov	x1, x0
mov	x0, x20
bl Lpatch + (0xa5d4 - PATCH_BASE)
cmp	x0, x19
b.eq	LFQH_LBB312_14
LFQH_LBB312_9:
cmp	x20, x21
b.eq	LFQH_LBB312_13
LFQH_LBB312_10:
ldp	x29, x30, [sp, #96]
ldp	x20, x19, [sp, #80]
ldp	x22, x21, [sp, #64]
ldp	x24, x23, [sp, #48]
ldp	d9, d8, [sp, #32]
ldp	d11, d10, [sp, #16]
add	sp, sp, #112
ret
LFQH_LBB312_11:
mov	x0, x19
mov	x1, x21
LFQH_LBB312_12:
ldp	x29, x30, [sp, #96]
ldp	x20, x19, [sp, #80]
ldp	x22, x21, [sp, #64]
ldp	x24, x23, [sp, #48]
ldp	d9, d8, [sp, #32]
ldp	d11, d10, [sp, #16]
add	sp, sp, #112
b	LFQH_RestoreDramaWatch
LFQH_LBB312_13:
mov	x0, x19
mov	x1, x20
b	LFQH_LBB312_12
LFQH_LBB312_14:
LFQH_Lloh5762:
adr x0, LFQH_l_.str.24
LFQH_Lloh5763:
nop
bl Lpatch + (0xa5a4 - PATCH_BASE)
mov	x1, x0
mov	x0, x20
bl Lpatch + (0xa5d4 - PATCH_BASE)
fmov	d4, #8.00000000
fadd	d8, d0, d4
fmov	x8, d8
fmov	d0, #3.00000000
fadd	d9, d1, d0
fmov	x9, d9
fmov	d0, #-16.00000000
fadd	d10, d2, d0
fmov	x10, d10
and	x11, x8, #0x7fffffffffffffff
and	x8, x9, #0x7fffffffffffffff
mov	x12, #9218868437227405311
cmp	x8, x12
cset	w8, gt
and	x9, x10, #0x7fffffffffffffff
cmp	x9, x12
cset	w9, gt
cmp	x11, x12
b.gt	LFQH_LBB312_9
tbnz	w8, #0, LFQH_LBB312_9
tbnz	w9, #0, LFQH_LBB312_9
fmov	d0, #-6.00000000
fadd	d11, d3, d0
fmov	x8, d11
and	x8, x8, #0x7fffffffffffffff
mov	x9, #9218868437227405311
cmp	x8, x9
b.gt	LFQH_LBB312_9
fcmp	d10, #0.0
b.le	LFQH_LBB312_9
fcmp	d11, #0.0
b.le	LFQH_LBB312_9
LFQH_Lloh5764:
adr x1, LFQH_DramaShadeKey
LFQH_Lloh5765:
nop
mov	x0, x20
bl Lpatch + (0xa628 - PATCH_BASE)
mov	x22, x0
cmp	x20, x21
b.eq	LFQH_LBB312_27
LFQH_Lloh5766:
adr x0, LFQH_l_.str.414
LFQH_Lloh5767:
nop
bl Lpatch + (0xa5a4 - PATCH_BASE)
mov	x1, x0
mov	x0, x20
bl Lpatch + (0xa5d4 - PATCH_BASE)
mov	x21, x0
LFQH_Lloh5768:
adr x0, LFQH_l_.str.686
LFQH_Lloh5769:
nop
bl Lpatch + (0xa5a4 - PATCH_BASE)
mov	x1, x0
mov	x0, x21
bl Lpatch + (0xa5d4 - PATCH_BASE)
cbz	x0, LFQH_LBB312_24
mov	x21, x0
bl Lpatch + (0xa664 - PATCH_BASE)
mov	x23, x0
LFQH_Lloh5770:
adr x0, LFQH_l_.str.23
LFQH_Lloh5771:
nop
bl Lpatch + (0xa5b0 - PATCH_BASE)
cmp	x23, x0
b.ne	LFQH_LBB312_24
stp	xzr, xzr, [sp]
LFQH_Lloh5772:
adr x0, LFQH_l_.str.390
LFQH_Lloh5773:
nop
bl Lpatch + (0xa5a4 - PATCH_BASE)
mov	x1, x0
mov	x0, x21
bl Lpatch + (0xa5d4 - PATCH_BASE)
mov	x23, x0
LFQH_Lloh5774:
adr x0, LFQH_l_.str.132
LFQH_Lloh5775:
nop
bl Lpatch + (0xa5a4 - PATCH_BASE)
mov	x1, x0
add	x2, sp, #8
mov	x3, sp
mov	x0, x23
bl Lpatch + (0xa5d4 - PATCH_BASE)
ldp	d0, d2, [sp]
fmov	d1, #1.00000000
fcmp	d2, d1
ccmp	w0, #0, #4, eq
cset	w8, ne
fmov	d1, #0.12500000
fcmp	d0, d1
cset	w9, gt
fmov	d1, #0.15625000
fcmp	d0, d1
csel	w9, wzr, w9, hi
tst	w8, w9
csel	x22, x21, x22, ne
LFQH_LBB312_24:
mov	x0, x20
mov	x1, x20
mov	x2, #0
fmov	d0, d8
fmov	d1, d9
fmov	d2, d10
fmov	d3, d11
bl	LFQH_PlaceDramaGlass
cbz	x0, LFQH_LBB312_10
LFQH_Lloh5776:
adr x1, LFQH_DramaWatchContentKey
LFQH_Lloh5777:
nop
mov	x0, x19
mov	x2, x20
mov	w3, #1
bl Lpatch + (0xa634 - PATCH_BASE)
cbz	x22, LFQH_LBB312_30
LFQH_Lloh5778:
adr x1, LFQH_DramaShadeKey
LFQH_Lloh5779:
nop
mov	x0, x20
mov	x2, x22
mov	w3, #1
bl Lpatch + (0xa634 - PATCH_BASE)
mov	x0, x20
mov	w1, #1
bl	LFQH_DramaClearBackground
b	LFQH_LBB312_29
LFQH_LBB312_27:
mov	x0, x20
mov	x1, x20
mov	x2, #0
fmov	d0, d8
fmov	d1, d9
fmov	d2, d10
fmov	d3, d11
bl	LFQH_PlaceDramaGlass
cbz	x0, LFQH_LBB312_10
mov	x0, x20
mov	w1, #1
bl	LFQH_DramaClearBackground
cbz	x22, LFQH_LBB312_10
LFQH_LBB312_29:
mov	x0, x22
b	LFQH_LBB312_31
LFQH_LBB312_30:
mov	x0, x20
LFQH_LBB312_31:
mov	w1, #1
bl	LFQH_DramaClearBackground
b	LFQH_LBB312_10
.cfi_endproc
.p2align	2
LFQH_DramaSpacingForEntry178R2:
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
LFQH_Lloh5780:
adr x1, LFQH_l_.str.20
LFQH_Lloh5781:
nop
bl	LFQH_Get
cbz	x0, LFQH_LBB313_5
mov	x19, x0
mov	w24, #0
LFQH_Lloh5782:
adr x20, LFQH_l_.str.389
LFQH_Lloh5783:
nop
LFQH_Lloh5784:
adr x21, LFQH_l_.str.73
LFQH_Lloh5785:
nop
LFQH_Lloh5786:
adr x22, LFQH_l_.str.20
LFQH_Lloh5787:
nop
LFQH_LBB313_2:
mov	x0, x20
bl Lpatch + (0xa5a4 - PATCH_BASE)
mov	x23, x0
mov	x0, x21
bl Lpatch + (0xa5b0 - PATCH_BASE)
mov	x2, x0
mov	x0, x19
mov	x1, x23
bl Lpatch + (0xa5d4 - PATCH_BASE)
cbnz	w0, LFQH_LBB313_6
mov	x0, x19
mov	x1, x22
bl	LFQH_Get
cbz	x0, LFQH_LBB313_5
mov	x19, x0
add	w8, w24, #1
cmp	w24, #7
mov	x24, x8
b.lo	LFQH_LBB313_2
LFQH_LBB313_5:
ldp	x29, x30, [sp, #48]
ldp	x20, x19, [sp, #32]
ldp	x22, x21, [sp, #16]
ldp	x24, x23, [sp], #64
ret
LFQH_LBB313_6:
mov	x0, x19
ldp	x29, x30, [sp, #48]
ldp	x20, x19, [sp, #32]
ldp	x22, x21, [sp, #16]
ldp	x24, x23, [sp], #64
b	LFQH_FQHDramaSpacing178R2
.cfi_endproc
.p2align	2
LFQH_RestoreDramaWatch:
.cfi_startproc
cbz	x1, LFQH_LBB314_4
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
LFQH_Lloh5788:
adr x1, LFQH_DramaShadeKey
LFQH_Lloh5789:
nop
mov	x0, x20
bl Lpatch + (0xa628 - PATCH_BASE)
mov	x21, x0
mov	x0, x20
bl	LFQH_RemoveDramaGlass
mov	x0, x20
mov	w1, #0
bl	LFQH_DramaClearBackground
cbz	x21, LFQH_LBB314_3
mov	x0, x21
mov	w1, #0
bl	LFQH_DramaClearBackground
LFQH_LBB314_3:
LFQH_Lloh5790:
adr x1, LFQH_DramaShadeKey
LFQH_Lloh5791:
nop
mov	x0, x20
mov	x2, #0
mov	w3, #1
bl Lpatch + (0xa634 - PATCH_BASE)
LFQH_Lloh5792:
adr x1, LFQH_DramaWatchContentKey
LFQH_Lloh5793:
nop
mov	x0, x19
mov	x2, #0
mov	w3, #1
ldp	x29, x30, [sp, #32]
ldp	x20, x19, [sp, #16]
ldp	x22, x21, [sp], #48
b Lpatch + (0xa634 - PATCH_BASE)
LFQH_LBB314_4:
ret
.cfi_endproc
.p2align	2
LFQH_DramaShadeKey:
.cfi_startproc
ret
.cfi_endproc
.p2align	2
LFQH_DramaClearBackground:
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
LFQH_Lloh5794:
adr x0, LFQH_l_.str.390
LFQH_Lloh5795:
nop
bl Lpatch + (0xa5a4 - PATCH_BASE)
mov	x1, x0
mov	x0, x19
bl Lpatch + (0xa5d4 - PATCH_BASE)
mov	x20, x0
LFQH_Lloh5796:
adr x1, LFQH_DramaBackgroundKey
LFQH_Lloh5797:
nop
mov	x0, x19
bl Lpatch + (0xa628 - PATCH_BASE)
mov	x22, x0
LFQH_Lloh5798:
adr x0, LFQH_l_.str.47
LFQH_Lloh5799:
nop
bl Lpatch + (0xa5b0 - PATCH_BASE)
mov	x21, x0
LFQH_Lloh5800:
adr x0, LFQH_l_.str.158
LFQH_Lloh5801:
nop
bl Lpatch + (0xa5a4 - PATCH_BASE)
mov	x1, x0
mov	x0, x21
bl Lpatch + (0xa5d4 - PATCH_BASE)
mov	x21, x0
cbz	w23, LFQH_LBB316_5
cbz	x20, LFQH_LBB316_5
cmp	x20, x21
b.eq	LFQH_LBB316_11
LFQH_Lloh5802:
adr x0, LFQH_l_.str.49
LFQH_Lloh5803:
nop
bl Lpatch + (0xa5a4 - PATCH_BASE)
mov	x1, x0
mov	x0, x20
mov	x2, x21
bl Lpatch + (0xa5d4 - PATCH_BASE)
cbnz	w0, LFQH_LBB316_11
LFQH_Lloh5804:
adr x1, LFQH_DramaBackgroundKey
LFQH_Lloh5805:
nop
mov	x0, x19
mov	x2, x20
mov	w3, #1
bl Lpatch + (0xa634 - PATCH_BASE)
LFQH_Lloh5806:
adr x0, LFQH_l_.str.157
LFQH_Lloh5807:
nop
bl Lpatch + (0xa5a4 - PATCH_BASE)
mov	x1, x0
mov	x0, x19
mov	x2, x21
ldp	x29, x30, [sp, #48]
ldp	x20, x19, [sp, #32]
ldp	x22, x21, [sp, #16]
ldp	x24, x23, [sp], #64
b Lpatch + (0xa5d4 - PATCH_BASE)
LFQH_LBB316_5:
cbnz	w23, LFQH_LBB316_11
cbz	x22, LFQH_LBB316_11
cmp	x20, x21
b.eq	LFQH_LBB316_9
LFQH_Lloh5808:
adr x0, LFQH_l_.str.49
LFQH_Lloh5809:
nop
bl Lpatch + (0xa5a4 - PATCH_BASE)
mov	x1, x0
mov	x0, x20
mov	x2, x21
bl Lpatch + (0xa5d4 - PATCH_BASE)
cbz	w0, LFQH_LBB316_10
LFQH_LBB316_9:
LFQH_Lloh5810:
adr x0, LFQH_l_.str.157
LFQH_Lloh5811:
nop
bl Lpatch + (0xa5a4 - PATCH_BASE)
mov	x1, x0
mov	x0, x19
mov	x2, x22
bl Lpatch + (0xa5d4 - PATCH_BASE)
LFQH_LBB316_10:
LFQH_Lloh5812:
adr x1, LFQH_DramaBackgroundKey
LFQH_Lloh5813:
nop
mov	x0, x19
mov	x2, #0
mov	w3, #1
ldp	x29, x30, [sp, #48]
ldp	x20, x19, [sp, #32]
ldp	x22, x21, [sp, #16]
ldp	x24, x23, [sp], #64
b Lpatch + (0xa634 - PATCH_BASE)
LFQH_LBB316_11:
ldp	x29, x30, [sp, #48]
ldp	x20, x19, [sp, #32]
ldp	x22, x21, [sp, #16]
ldp	x24, x23, [sp], #64
ret
.cfi_endproc
.p2align	2
LFQH_DramaBackgroundKey:
.cfi_startproc
ret
.cfi_endproc
.p2align	2
LFQH_FullscreenPlayerFrame:
.cfi_startproc
sub	sp, sp, #64
stp	x20, x19, [sp, #32]
stp	x29, x30, [sp, #48]
add	x29, sp, #48
.cfi_def_cfa w29, 16
.cfi_offset w30, -8
.cfi_offset w29, -16
.cfi_offset w19, -24
.cfi_offset w20, -32
mov	x19, x1
mov	x20, x0
mov	x1, sp
bl	LFQH_FullscreenFillViewport
cbz	w0, LFQH_LBB318_2
ldp	d0, d1, [sp]
ldp	d2, d3, [sp, #16]
b	LFQH_LBB318_3
LFQH_LBB318_2:
LFQH_Lloh5814:
adr x0, LFQH_l_.str.568
LFQH_Lloh5815:
nop
LFQH_Lloh5816:
adr x1, LFQH_l_.str.698
LFQH_Lloh5817:
nop
bl	LFQH_Original
mov	x8, x0
mov	x0, x20
mov	x1, x19
blr	x8
LFQH_LBB318_3:
ldp	x29, x30, [sp, #48]
ldp	x20, x19, [sp, #32]
add	sp, sp, #64
ret
.cfi_endproc
.p2align	2
LFQH_FullscreenPlayerLayout:
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
LFQH_Lloh5818:
adr x0, LFQH_l_.str.568
LFQH_Lloh5819:
nop
LFQH_Lloh5820:
adr x1, LFQH_l_.str.699
LFQH_Lloh5821:
nop
bl	LFQH_Original
mov	x8, x0
mov	x0, x19
mov	x1, x20
blr	x8
LFQH_Lloh5822:
adr x0, LFQH_l_.str.570
LFQH_Lloh5823:
nop
bl Lpatch + (0xa5a4 - PATCH_BASE)
mov	x1, x0
mov	x0, x19
bl Lpatch + (0xa5d4 - PATCH_BASE)
cbz	w0, LFQH_LBB319_2
bl	LFQH_FullscreenPlayers
mov	x20, x0
LFQH_Lloh5824:
adr x0, LFQH_l_.str.84
LFQH_Lloh5825:
nop
bl Lpatch + (0xa5a4 - PATCH_BASE)
mov	x1, x0
mov	x0, x20
mov	x2, x19
bl Lpatch + (0xa5d4 - PATCH_BASE)
LFQH_LBB319_2:
mov	x0, x19
ldp	x29, x30, [sp, #16]
ldp	x20, x19, [sp], #32
b	LFQH_FullscreenApplyPlayer
.cfi_endproc
.p2align	2
LFQH_FullscreenPlayerState:
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
cbz	w2, LFQH_LBB320_3
mov	x21, x2
LFQH_Lloh5826:
adr x0, LFQH_l_.str.568
LFQH_Lloh5827:
nop
LFQH_Lloh5828:
adr x1, LFQH_l_.str.700
LFQH_Lloh5829:
nop
bl	LFQH_Original
mov	x8, x0
mov	x0, x19
mov	x1, x20
mov	x2, x21
blr	x8
mov	w0, #9
bl	LFQH_PageOptionEnabled
cbz	w0, LFQH_LBB320_4
LFQH_Lloh5830:
adr x0, LFQH_l_.str.356
LFQH_Lloh5831:
nop
bl Lpatch + (0xa5a4 - PATCH_BASE)
mov	x1, x0
mov	x0, x19
ldp	x29, x30, [sp, #32]
ldp	x20, x19, [sp, #16]
ldp	x22, x21, [sp], #48
b Lpatch + (0xa5d4 - PATCH_BASE)
LFQH_LBB320_3:
LFQH_Lloh5832:
adr x0, LFQH_l_.str.569
LFQH_Lloh5833:
nop
bl Lpatch + (0xa5a4 - PATCH_BASE)
mov	x1, x0
mov	x0, x19
bl Lpatch + (0xa5d4 - PATCH_BASE)
mov	w1, #0
bl	LFQH_FullscreenScale
LFQH_Lloh5834:
adr x0, LFQH_l_.str.568
LFQH_Lloh5835:
nop
LFQH_Lloh5836:
adr x1, LFQH_l_.str.700
LFQH_Lloh5837:
nop
bl	LFQH_Original
mov	x3, x0
mov	x0, x19
mov	x1, x20
mov	w2, #0
ldp	x29, x30, [sp, #32]
ldp	x20, x19, [sp, #16]
ldp	x22, x21, [sp], #48
br	x3
LFQH_LBB320_4:
ldp	x29, x30, [sp, #32]
ldp	x20, x19, [sp, #16]
ldp	x22, x21, [sp], #48
ret
.cfi_endproc
.p2align	2
LFQH_FullscreenPlayerEngine:
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
LFQH_Lloh5838:
adr x0, LFQH_l_.str.569
LFQH_Lloh5839:
nop
bl Lpatch + (0xa5a4 - PATCH_BASE)
mov	x1, x0
mov	x0, x19
bl Lpatch + (0xa5d4 - PATCH_BASE)
cmp	x0, x20
b.eq	LFQH_LBB321_2
mov	w1, #0
bl	LFQH_FullscreenScale
LFQH_LBB321_2:
LFQH_Lloh5840:
adr x0, LFQH_l_.str.568
LFQH_Lloh5841:
nop
LFQH_Lloh5842:
adr x1, LFQH_l_.str.701
LFQH_Lloh5843:
nop
bl	LFQH_Original
mov	x8, x0
mov	x0, x19
mov	x1, x21
mov	x2, x20
blr	x8
mov	x0, x19
ldp	x29, x30, [sp, #32]
ldp	x20, x19, [sp, #16]
ldp	x22, x21, [sp], #48
b	LFQH_FullscreenApplyPlayer
.cfi_endproc
.p2align	2
LFQH_FullscreenPlayerPrepare:
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
mov	x19, x3
mov	x20, x2
mov	x21, x1
mov	x22, x0
LFQH_Lloh5844:
adr x0, LFQH_l_.str.569
LFQH_Lloh5845:
nop
bl Lpatch + (0xa5a4 - PATCH_BASE)
mov	x1, x0
mov	x0, x22
bl Lpatch + (0xa5d4 - PATCH_BASE)
mov	x23, x0
mov	x1, sp
mov	x0, x22
bl	LFQH_FullscreenFillViewport
mov	x1, x0
mov	x0, x23
bl	LFQH_FullscreenScale
LFQH_Lloh5846:
adr x0, LFQH_l_.str.568
LFQH_Lloh5847:
nop
LFQH_Lloh5848:
adr x1, LFQH_l_.str.702
LFQH_Lloh5849:
nop
bl	LFQH_Original
mov	x8, x0
mov	x0, x22
mov	x1, x21
mov	x2, x20
mov	x3, x19
blr	x8
mov	x0, x22
ldp	x29, x30, [sp, #80]
ldp	x20, x19, [sp, #64]
ldp	x22, x21, [sp, #48]
ldp	x24, x23, [sp, #32]
add	sp, sp, #96
b	LFQH_FullscreenRefresh
.cfi_endproc
.p2align	2
LFQH_FullscreenPlayerReady:
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
cbz	x2, LFQH_LBB323_5
mov	x20, x2
LFQH_Lloh5850:
adr x0, LFQH_l_.str.569
LFQH_Lloh5851:
nop
bl Lpatch + (0xa5a4 - PATCH_BASE)
mov	x1, x0
mov	x0, x19
bl Lpatch + (0xa5d4 - PATCH_BASE)
cmp	x0, x20
b.ne	LFQH_LBB323_3
mov	x0, x19
bl	LFQH_FullscreenRefresh
LFQH_LBB323_3:
LFQH_Lloh5852:
adr x0, LFQH_l_.str.568
LFQH_Lloh5853:
nop
LFQH_Lloh5854:
adr x1, LFQH_l_.str.703
LFQH_Lloh5855:
nop
bl	LFQH_Original
mov	x8, x0
mov	x0, x19
mov	x1, x21
mov	x2, x20
blr	x8
LFQH_Lloh5856:
adr x0, LFQH_l_.str.569
LFQH_Lloh5857:
nop
bl Lpatch + (0xa5a4 - PATCH_BASE)
mov	x1, x0
mov	x0, x19
bl Lpatch + (0xa5d4 - PATCH_BASE)
cmp	x0, x20
b.eq	LFQH_LBB323_6
ldp	x29, x30, [sp, #32]
ldp	x20, x19, [sp, #16]
ldp	x22, x21, [sp], #48
ret
LFQH_LBB323_5:
LFQH_Lloh5858:
adr x0, LFQH_l_.str.568
LFQH_Lloh5859:
nop
LFQH_Lloh5860:
adr x1, LFQH_l_.str.703
LFQH_Lloh5861:
nop
bl	LFQH_Original
mov	x3, x0
mov	x0, x19
mov	x1, x21
mov	x2, #0
ldp	x29, x30, [sp, #32]
ldp	x20, x19, [sp, #16]
ldp	x22, x21, [sp], #48
br	x3
LFQH_LBB323_6:
mov	x0, x19
ldp	x29, x30, [sp, #32]
ldp	x20, x19, [sp, #16]
ldp	x22, x21, [sp], #48
b	LFQH_FullscreenApplyPlayer
.cfi_endproc
.p2align	2
LFQH_FullscreenCellDisplay:
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
LFQH_Lloh5862:
adr x0, LFQH_l_.str.571
LFQH_Lloh5863:
nop
LFQH_Lloh5864:
adr x1, LFQH_l_.str.704
LFQH_Lloh5865:
nop
bl	LFQH_Original
mov	x8, x0
mov	x0, x20
mov	x1, x19
blr	x8
LFQH_Lloh5866:
adr x0, LFQH_l_.str.695
LFQH_Lloh5867:
nop
bl Lpatch + (0xa5a4 - PATCH_BASE)
mov	x1, x0
mov	x0, x20
bl Lpatch + (0xa5d4 - PATCH_BASE)
cbz	x0, LFQH_LBB324_2
ldp	x29, x30, [sp, #16]
ldp	x20, x19, [sp], #32
b	LFQH_FullscreenRefresh
LFQH_LBB324_2:
ldp	x29, x30, [sp, #16]
ldp	x20, x19, [sp], #32
ret
.cfi_endproc
.p2align	2
LFQH_FullscreenRefresh:
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
LFQH_Lloh5868:
adr x0, LFQH_l_.str.570
LFQH_Lloh5869:
nop
bl Lpatch + (0xa5a4 - PATCH_BASE)
mov	x1, x0
mov	x0, x19
bl Lpatch + (0xa5d4 - PATCH_BASE)
cbz	w0, LFQH_LBB325_2
bl	LFQH_FullscreenPlayers
mov	x20, x0
LFQH_Lloh5870:
adr x0, LFQH_l_.str.84
LFQH_Lloh5871:
nop
bl Lpatch + (0xa5a4 - PATCH_BASE)
mov	x1, x0
mov	x0, x20
mov	x2, x19
bl Lpatch + (0xa5d4 - PATCH_BASE)
LFQH_LBB325_2:
mov	x0, x19
bl	LFQH_FullscreenApplyPlayer
cbz	w0, LFQH_LBB325_4
LFQH_Lloh5872:
adr x0, LFQH_l_.str.567
LFQH_Lloh5873:
nop
bl Lpatch + (0xa5a4 - PATCH_BASE)
mov	x1, x0
mov	x0, x19
ldp	x29, x30, [sp, #16]
ldp	x20, x19, [sp], #32
b Lpatch + (0xa5d4 - PATCH_BASE)
LFQH_LBB325_4:
ldp	x29, x30, [sp, #16]
ldp	x20, x19, [sp], #32
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
LFQH_Lloh5874:
adr x1, LFQH_l_.str.705
LFQH_Lloh5875:
nop
mov	x0, x19
bl	LFQH_Get
mov	x21, x0
LFQH_Lloh5876:
adr x1, LFQH_l_.str.706
LFQH_Lloh5877:
nop
bl	LFQH_Kind
cbz	w0, LFQH_LBB326_5
LFQH_Lloh5878:
adr x1, LFQH_l_.str.363
LFQH_Lloh5879:
nop
mov	x0, x21
bl	LFQH_Get
LFQH_Lloh5880:
adr x1, LFQH_l_.str.37
LFQH_Lloh5881:
nop
bl	LFQH_Kind
cbz	w0, LFQH_LBB326_5
mov	x0, x21
bl Lpatch + (0xa664 - PATCH_BASE)
LFQH_Lloh5882:
adr x1, LFQH_l_.str.707
LFQH_Lloh5883:
nop
LFQH_Lloh5884:
adr x2, LFQH_l_.str.9
LFQH_Lloh5885:
nop
bl	LFQH_ClassABI
cbz	w0, LFQH_LBB326_5
mov	x0, x21
mov	x1, x20
bl	LFQH_ReaderBackdropFill
cbz	w0, LFQH_LBB326_5
LFQH_Lloh5886:
adr x0, LFQH_l_.str.707
LFQH_Lloh5887:
nop
bl Lpatch + (0xa5a4 - PATCH_BASE)
mov	x1, x0
mov	x0, x21
bl Lpatch + (0xa5d4 - PATCH_BASE)
LFQH_LBB326_5:
LFQH_Lloh5888:
adr x1, LFQH_l_.str.708
LFQH_Lloh5889:
nop
mov	x0, x19
bl	LFQH_Get
mov	x1, x20
bl	LFQH_ReaderBackdrop
LFQH_Lloh5890:
adr x1, LFQH_l_.str.709
LFQH_Lloh5891:
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
LFQH_Lloh5892:
adr x0, LFQH_l_.str.361
LFQH_Lloh5893:
nop
bl Lpatch + (0xa5b0 - PATCH_BASE)
mov	x19, x0
LFQH_Lloh5894:
adr x0, LFQH_l_.str.387
LFQH_Lloh5895:
nop
bl Lpatch + (0xa5a4 - PATCH_BASE)
mov	x1, x0
LFQH_Lloh5896:
adr x2, LFQH_l_.str.544
LFQH_Lloh5897:
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
LFQH_Lloh5898:
adr x1, LFQH_ReaderBackdropColorKey
LFQH_Lloh5899:
nop
bl Lpatch + (0xa628 - PATCH_BASE)
mov	x20, x0
cbz	w21, LFQH_LBB328_2
cbz	x20, LFQH_LBB328_9
LFQH_LBB328_2:
LFQH_Lloh5900:
adr x0, LFQH_l_.str.390
LFQH_Lloh5901:
nop
bl Lpatch + (0xa5a4 - PATCH_BASE)
mov	x1, x0
mov	x0, x19
bl Lpatch + (0xa5d4 - PATCH_BASE)
mov	x2, x0
cbz	w21, LFQH_LBB328_6
cbnz	x2, LFQH_LBB328_5
LFQH_Lloh5902:
adr x0, LFQH_l_.str.157
LFQH_Lloh5903:
nop
bl Lpatch + (0xa5a4 - PATCH_BASE)
mov	x1, x0
mov	x0, x19
mov	x2, x20
bl Lpatch + (0xa5d4 - PATCH_BASE)
LFQH_LBB328_5:
LFQH_Lloh5904:
adr x1, LFQH_ReaderBackdropColorKey
LFQH_Lloh5905:
nop
mov	w20, #1
mov	x0, x19
mov	x2, #0
mov	w3, #1
bl Lpatch + (0xa634 - PATCH_BASE)
b	LFQH_LBB328_9
LFQH_LBB328_6:
cbz	x2, LFQH_LBB328_8
LFQH_Lloh5906:
adr x1, LFQH_ReaderBackdropColorKey
LFQH_Lloh5907:
nop
mov	w20, #1
mov	x0, x19
mov	w3, #1
bl Lpatch + (0xa634 - PATCH_BASE)
LFQH_Lloh5908:
adr x0, LFQH_l_.str.157
LFQH_Lloh5909:
nop
bl Lpatch + (0xa5a4 - PATCH_BASE)
mov	x1, x0
mov	x0, x19
mov	x2, #0
bl Lpatch + (0xa5d4 - PATCH_BASE)
b	LFQH_LBB328_9
LFQH_LBB328_8:
mov	w20, #0
LFQH_LBB328_9:
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
cbz	x0, LFQH_LBB329_13
mov	x19, x1
mov	x20, x0
LFQH_Lloh5910:
adr x1, LFQH_ReaderBackdropAppliedKey
LFQH_Lloh5911:
nop
bl Lpatch + (0xa628 - PATCH_BASE)
mov	x21, x0
cbz	w19, LFQH_LBB329_3
cbz	x21, LFQH_LBB329_13
LFQH_LBB329_3:
LFQH_Lloh5912:
adr x0, LFQH_l_.str.389
LFQH_Lloh5913:
nop
bl Lpatch + (0xa5a4 - PATCH_BASE)
mov	x22, x0
LFQH_Lloh5914:
adr x0, LFQH_l_.str.202
LFQH_Lloh5915:
nop
bl Lpatch + (0xa5b0 - PATCH_BASE)
mov	x2, x0
mov	x0, x20
mov	x1, x22
bl Lpatch + (0xa5d4 - PATCH_BASE)
mov	x22, x0
cbnz	w0, LFQH_LBB329_5
LFQH_Lloh5916:
adr x0, LFQH_l_.str.389
LFQH_Lloh5917:
nop
bl Lpatch + (0xa5a4 - PATCH_BASE)
mov	x23, x0
LFQH_Lloh5918:
adr x0, LFQH_l_.str.58
LFQH_Lloh5919:
nop
bl Lpatch + (0xa5b0 - PATCH_BASE)
mov	x2, x0
mov	x0, x20
mov	x1, x23
bl Lpatch + (0xa5d4 - PATCH_BASE)
cbz	w0, LFQH_LBB329_13
LFQH_LBB329_5:
LFQH_Lloh5920:
adr x0, LFQH_l_.str.20
LFQH_Lloh5921:
nop
bl Lpatch + (0xa5a4 - PATCH_BASE)
mov	x1, x0
mov	x0, x20
bl Lpatch + (0xa5d4 - PATCH_BASE)
mov	x23, x0
mov	x0, x20
mov	x1, x19
bl	LFQH_ReaderBackdropFill
LFQH_Lloh5922:
adr x1, LFQH_l_.str.710
LFQH_Lloh5923:
nop
mov	x0, x23
bl	LFQH_Kind
cbz	w0, LFQH_LBB329_8
LFQH_Lloh5924:
adr x1, LFQH_l_.str.363
LFQH_Lloh5925:
nop
mov	x0, x23
bl	LFQH_Get
cmp	x0, x20
b.ne	LFQH_LBB329_8
mov	x0, x23
mov	x1, x19
bl	LFQH_ReaderBackdropFill
LFQH_LBB329_8:
cmp	x21, #0
cset	w8, ne
cmp	w19, w8
b.ne	LFQH_LBB329_10
cmp	w19, #0
csel	x2, x20, xzr, eq
LFQH_Lloh5926:
adr x1, LFQH_ReaderBackdropAppliedKey
LFQH_Lloh5927:
nop
mov	x0, x20
mov	x3, #0
bl Lpatch + (0xa634 - PATCH_BASE)
LFQH_LBB329_10:
LFQH_Lloh5928:
adr x8, LFQH_l_.str.711
LFQH_Lloh5929:
nop
LFQH_Lloh5930:
adr x9, LFQH_l_.str.531
LFQH_Lloh5931:
nop
cmp	w22, #0
csel	x1, x9, x8, eq
mov	x0, x20
bl	LFQH_Get
mov	x21, x0
LFQH_Lloh5932:
adr x0, LFQH_l_.str.20
LFQH_Lloh5933:
nop
bl Lpatch + (0xa5a4 - PATCH_BASE)
mov	x1, x0
mov	x0, x21
bl Lpatch + (0xa5d4 - PATCH_BASE)
cmp	x0, x20
b.ne	LFQH_LBB329_13
LFQH_Lloh5934:
adr x1, LFQH_ReaderBackdropAlphaKey
LFQH_Lloh5935:
nop
mov	x0, x21
bl Lpatch + (0xa628 - PATCH_BASE)
mov	x20, x0
cbz	w19, LFQH_LBB329_14
cbnz	x20, LFQH_LBB329_14
LFQH_LBB329_13:
ldp	x29, x30, [sp, #48]
ldp	x20, x19, [sp, #32]
ldp	x22, x21, [sp, #16]
ldp	x24, x23, [sp], #64
ret
LFQH_LBB329_14:
LFQH_Lloh5936:
adr x0, LFQH_l_.str.477
LFQH_Lloh5937:
nop
bl Lpatch + (0xa5a4 - PATCH_BASE)
mov	x1, x0
mov	x0, x21
bl Lpatch + (0xa5d4 - PATCH_BASE)
cbz	w19, LFQH_LBB329_18
fcmp	d0, #0.0
b.ne	LFQH_LBB329_17
LFQH_Lloh5938:
adr x0, LFQH_l_.str.712
LFQH_Lloh5939:
nop
bl Lpatch + (0xa5a4 - PATCH_BASE)
mov	x19, x0
LFQH_Lloh5940:
adr x0, LFQH_l_.str.445
LFQH_Lloh5941:
nop
bl Lpatch + (0xa5a4 - PATCH_BASE)
mov	x1, x0
mov	x0, x20
bl Lpatch + (0xa5d4 - PATCH_BASE)
mov	x0, x21
mov	x1, x19
bl Lpatch + (0xa5d4 - PATCH_BASE)
LFQH_LBB329_17:
LFQH_Lloh5942:
adr x1, LFQH_ReaderBackdropAlphaKey
LFQH_Lloh5943:
nop
mov	x0, x21
mov	x2, #0
mov	w3, #1
ldp	x29, x30, [sp, #48]
ldp	x20, x19, [sp, #32]
ldp	x22, x21, [sp, #16]
ldp	x24, x23, [sp], #64
b Lpatch + (0xa634 - PATCH_BASE)
LFQH_LBB329_18:
fcmp	d0, #0.0
b.le	LFQH_LBB329_13
bl	LFQH_Number
mov	x2, x0
LFQH_Lloh5944:
adr x1, LFQH_ReaderBackdropAlphaKey
LFQH_Lloh5945:
nop
mov	x0, x21
mov	w3, #1
bl Lpatch + (0xa634 - PATCH_BASE)
LFQH_Lloh5946:
adr x0, LFQH_l_.str.712
LFQH_Lloh5947:
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
LFQH_Lloh5948:
adr x1, LFQH_l_.str.713
LFQH_Lloh5949:
nop
bl	LFQH_Get
mov	x19, x0
LFQH_Lloh5950:
adr x1, LFQH_l_.str.710
LFQH_Lloh5951:
nop
bl	LFQH_Kind
cbz	w0, LFQH_LBB330_18
LFQH_Lloh5952:
adr x1, LFQH_l_.str.363
LFQH_Lloh5953:
nop
mov	x0, x19
bl	LFQH_Get
mov	x23, x0
LFQH_Lloh5954:
adr x1, LFQH_l_.str.714
LFQH_Lloh5955:
nop
mov	x0, x20
bl	LFQH_Get
LFQH_Lloh5956:
adr x1, LFQH_l_.str.687
LFQH_Lloh5957:
nop
bl	LFQH_Get
mov	x24, x0
LFQH_Lloh5958:
adr x22, LFQH_l_.str.20
LFQH_Lloh5959:
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
LFQH_Lloh5960:
adr x1, LFQH_l_.str.715
LFQH_Lloh5961:
nop
mov	x0, x24
bl	LFQH_Kind
cbz	w0, LFQH_LBB330_14
cmp	x22, x19
ccmp	x21, x23, #0, eq
cset	w8, eq
cmp	x21, x19
b.eq	LFQH_LBB330_4
cbz	w8, LFQH_LBB330_14
LFQH_LBB330_4:
LFQH_Lloh5962:
adr x1, LFQH_l_.str.716
LFQH_Lloh5963:
nop
mov	x0, x24
bl	LFQH_Get
mov	x25, x0
LFQH_Lloh5964:
adr x0, LFQH_l_.str.34
LFQH_Lloh5965:
nop
bl Lpatch + (0xa5a4 - PATCH_BASE)
mov	x1, x0
mov	x0, x25
bl Lpatch + (0xa5d4 - PATCH_BASE)
cbz	x0, LFQH_LBB330_14
mov	x26, x0
str	x22, [sp]
str	w27, [sp, #12]
stp	x23, x20, [sp, #16]
mov	x27, #0
mov	w20, #0
LFQH_Lloh5966:
adr x28, LFQH_l_.str.461
LFQH_Lloh5967:
nop
LFQH_Lloh5968:
adr x22, LFQH_l_.str.199
LFQH_Lloh5969:
nop
LFQH_Lloh5970:
adr x21, LFQH_l_.str.20
LFQH_Lloh5971:
nop
LFQH_LBB330_6:
mov	x0, x28
bl Lpatch + (0xa5a4 - PATCH_BASE)
mov	x1, x0
mov	x0, x25
mov	x2, x27
bl Lpatch + (0xa5d4 - PATCH_BASE)
mov	x23, x0
mov	x1, x22
bl	LFQH_Kind
cbz	w0, LFQH_LBB330_9
mov	x0, x21
bl Lpatch + (0xa5a4 - PATCH_BASE)
mov	x1, x0
mov	x0, x23
bl Lpatch + (0xa5d4 - PATCH_BASE)
cmp	x0, x24
b.ne	LFQH_LBB330_9
mov	x0, x23
bl	LFQH_ReaderCommunityGlass
orr	w20, w0, w20
LFQH_LBB330_9:
add	x27, x27, #1
cmp	x26, x27
b.ne	LFQH_LBB330_6
mov	w24, #1
ldr	w8, [sp, #12]
ldr	x22, [sp]
cbnz	w8, LFQH_LBB330_20
tst	w20, #0xff
ldp	x23, x20, [sp, #16]
b.eq	LFQH_LBB330_15
bl	LFQH_Enabled
cbz	w0, LFQH_LBB330_15
bl	LFQH_FQHGlassAvailable
cmp	w0, #0
cset	w24, eq
b	LFQH_LBB330_15
LFQH_LBB330_14:
mov	w24, #1
LFQH_LBB330_15:
mov	x0, x19
mov	x1, x24
bl	LFQH_ReaderBackdropFill
cmp	x22, x19
b.ne	LFQH_LBB330_17
mov	x0, x23
mov	x1, x24
bl	LFQH_ReaderBackdropFill
LFQH_LBB330_17:
LFQH_Lloh5972:
adr x1, LFQH_l_.str.717
LFQH_Lloh5973:
nop
mov	x0, x20
bl	LFQH_Get
mov	x20, x0
LFQH_Lloh5974:
adr x0, LFQH_l_.str.20
LFQH_Lloh5975:
nop
bl Lpatch + (0xa5a4 - PATCH_BASE)
mov	x1, x0
mov	x0, x20
bl Lpatch + (0xa5d4 - PATCH_BASE)
cmp	x0, x19
b.eq	LFQH_LBB330_19
LFQH_LBB330_18:
ldp	x29, x30, [sp, #112]
ldp	x20, x19, [sp, #96]
ldp	x22, x21, [sp, #80]
ldp	x24, x23, [sp, #64]
ldp	x26, x25, [sp, #48]
ldp	x28, x27, [sp, #32]
add	sp, sp, #128
ret
LFQH_LBB330_19:
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
LFQH_LBB330_20:
ldp	x23, x20, [sp, #16]
b	LFQH_LBB330_15
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
LFQH_Lloh5976:
adr x1, LFQH_l_.str.430
LFQH_Lloh5977:
nop
bl	LFQH_Get
LFQH_Lloh5978:
adr x1, LFQH_l_.str.500
LFQH_Lloh5979:
nop
bl	LFQH_Get
mov	x20, x0
LFQH_Lloh5980:
adr x1, LFQH_l_.str.718
LFQH_Lloh5981:
nop
bl	LFQH_Equal
cbnz	w0, LFQH_LBB334_2
LFQH_Lloh5982:
adr x1, LFQH_l_.str.719
LFQH_Lloh5983:
nop
mov	x0, x20
bl	LFQH_Equal
cbz	w0, LFQH_LBB334_4
LFQH_LBB334_2:
mov	x0, x19
bl	LFQH_FQHApply
mov	w0, #1
LFQH_LBB334_3:
ldp	x29, x30, [sp, #16]
ldp	x20, x19, [sp], #32
ret
LFQH_LBB334_4:
LFQH_Lloh5984:
adr x1, LFQH_SurfaceKey
LFQH_Lloh5985:
nop
mov	x0, x19
bl Lpatch + (0xa628 - PATCH_BASE)
cbz	x0, LFQH_LBB334_3
mov	x0, x19
bl	LFQH_PageRestore
mov	w0, #0
b	LFQH_LBB334_3
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
LFQH_Lloh5986:
adr x0, LFQH_l_.str.24
LFQH_Lloh5987:
nop
bl Lpatch + (0xa5a4 - PATCH_BASE)
mov	x1, x0
mov	x0, x19
bl Lpatch + (0xa5d4 - PATCH_BASE)
fmov	d8, d0
fmov	d9, d1
fmov	d10, d2
fmov	x9, d10
fmov	x8, d9
fmov	x10, d8
and	x10, x10, #0x7fffffffffffffff
and	x8, x8, #0x7fffffffffffffff
mov	x11, #9218868437227405311
cmp	x8, x11
cset	w8, gt
and	x9, x9, #0x7fffffffffffffff
cmp	x9, x11
cset	w9, gt
cmp	x10, x11
b.gt	LFQH_LBB335_13
tbnz	w8, #0, LFQH_LBB335_13
tbnz	w9, #0, LFQH_LBB335_13
fmov	d11, d3
fmov	x8, d11
and	x8, x8, #0x7fffffffffffffff
mov	x9, #9218868437227405311
cmp	x8, x9
b.gt	LFQH_LBB335_13
fcmp	d10, #0.0
b.le	LFQH_LBB335_13
fcmp	d11, #0.0
b.le	LFQH_LBB335_13
cbz	x20, LFQH_LBB335_10
mov	x0, x19
bl Lpatch + (0xa664 - PATCH_BASE)
LFQH_Lloh5988:
adr x1, LFQH_l_.str.430
LFQH_Lloh5989:
nop
LFQH_Lloh5990:
adr x2, LFQH_l_.str.11
LFQH_Lloh5991:
nop
bl	LFQH_ClassABI
cbz	w0, LFQH_LBB335_10
LFQH_Lloh5992:
adr x0, LFQH_l_.str.430
LFQH_Lloh5993:
nop
bl Lpatch + (0xa5a4 - PATCH_BASE)
mov	x1, x0
mov	x0, x19
bl Lpatch + (0xa5d4 - PATCH_BASE)
mov	x21, x0
LFQH_Lloh5994:
adr x1, LFQH_l_.str.36
LFQH_Lloh5995:
nop
bl	LFQH_Kind
cbz	w0, LFQH_LBB335_10
LFQH_Lloh5996:
adr x0, LFQH_l_.str.20
LFQH_Lloh5997:
nop
bl Lpatch + (0xa5a4 - PATCH_BASE)
mov	x1, x0
mov	x0, x21
bl Lpatch + (0xa5d4 - PATCH_BASE)
cmp	x0, x19
b.eq	LFQH_LBB335_16
LFQH_LBB335_10:
mov	x8, #4634204016564240384
fmov	d12, x8
LFQH_LBB335_11:
fsub	d0, d10, d12
fmov	d1, #0.50000000
fmul	d0, d0, d1
fadd	d14, d8, d0
mov	x8, #-4591419820104220672
fmov	d0, x8
fadd	d0, d11, d0
fmul	d0, d0, d1
fadd	d13, d9, d0
mov	x8, #4631952216750555136
fmov	d3, x8
mov	x0, x19
fmov	d0, d14
fmov	d1, d13
fmov	d2, d12
mov	w1, #0
bl	LFQH_ApplySurface
LFQH_Lloh5998:
adr x1, LFQH_SurfaceKey
LFQH_Lloh5999:
nop
mov	x0, x19
bl Lpatch + (0xa628 - PATCH_BASE)
cbz	x0, LFQH_LBB335_15
mov	x20, x0
mov	x0, x19
mov	w1, #1
bl	LFQH_ReaderBottomOptics
mov	x8, #4631389266797133824
fmov	d0, x8
fsub	d1, d0, d12
fmov	d2, #-0.50000000
fmul	d1, d1, d2
fadd	d1, d14, d1
fcmp	d12, d0
fcsel	d2, d0, d12, mi
fcsel	d0, d1, d14, mi
mov	x8, #4631952216750555136
fmov	d3, x8
mov	x0, x19
fmov	d1, d13
bl	LFQH_EnsureHit
LFQH_Lloh6000:
adr x2, LFQH_l_.str.720
LFQH_Lloh6001:
nop
mov	x0, x19
mov	x1, x20
fmov	d0, d8
fmov	d1, d9
fmov	d2, d10
fmov	d3, d11
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
LFQH_LBB335_13:
mov	x0, x19
mov	w1, #0
bl	LFQH_ReaderBottomOptics
mov	x0, x19
bl	LFQH_PageRestore
LFQH_LBB335_14:
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
LFQH_LBB335_15:
mov	x0, x19
mov	w1, #0
bl	LFQH_ReaderBottomOptics
b	LFQH_LBB335_14
LFQH_LBB335_16:
LFQH_Lloh6002:
adr x0, LFQH_l_.str.372
LFQH_Lloh6003:
nop
bl Lpatch + (0xa5a4 - PATCH_BASE)
mov	x1, x0
mov	x0, x21
bl Lpatch + (0xa5d4 - PATCH_BASE)
fmov	x9, d2
fmov	x8, d1
fmov	x10, d0
and	x10, x10, #0x7fffffffffffffff
and	x8, x8, #0x7fffffffffffffff
mov	x11, #9218868437227405311
cmp	x8, x11
cset	w8, gt
and	x9, x9, #0x7fffffffffffffff
cmp	x9, x11
cset	w9, gt
mov	x12, #4634204016564240384
fmov	d12, x12
cmp	x10, x11
b.gt	LFQH_LBB335_11
tbnz	w8, #0, LFQH_LBB335_11
tbnz	w9, #0, LFQH_LBB335_11
fmov	x8, d3
and	x8, x8, #0x7fffffffffffffff
mov	x9, #4634204016564240384
fmov	d12, x9
mov	x9, #9218868437227405311
cmp	x8, x9
b.gt	LFQH_LBB335_11
fcmp	d2, #0.0
b.le	LFQH_LBB335_11
fcmp	d3, #0.0
b.le	LFQH_LBB335_11
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
b.ls	LFQH_LBB335_10
LFQH_Lloh6004:
adr x0, LFQH_l_.str.372
LFQH_Lloh6005:
nop
bl Lpatch + (0xa5a4 - PATCH_BASE)
mov	x1, x0
mov	x0, x19
bl Lpatch + (0xa5d4 - PATCH_BASE)
fmov	d12, d0
fmov	d13, d2
LFQH_Lloh6006:
adr x0, LFQH_l_.str.24
LFQH_Lloh6007:
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
LFQH_Lloh6008:
adr x1, LFQH_l_.str.716
LFQH_Lloh6009:
nop
mov	x0, x20
bl	LFQH_Get
mov	x21, x0
LFQH_Lloh6010:
adr x0, LFQH_l_.str.34
LFQH_Lloh6011:
nop
bl Lpatch + (0xa5a4 - PATCH_BASE)
mov	x1, x0
mov	x0, x21
bl Lpatch + (0xa5d4 - PATCH_BASE)
mov	x8, #4629700416936869888
fmov	d0, x8
fcmp	d12, d0
cset	w8, gt
cbz	x0, LFQH_LBB335_32
mov	x9, #4629700416936869888
fmov	d0, x9
fcmp	d12, d0
b.le	LFQH_LBB335_32
mov	x22, x0
LFQH_Lloh6012:
adr x23, LFQH_l_.str.461
LFQH_Lloh6013:
nop
mov	w28, #1
mov	x8, #4629700416936869888
LFQH_Lloh6014:
adr x24, LFQH_l_.str.20
LFQH_Lloh6015:
nop
LFQH_Lloh6016:
adr x25, LFQH_l_.str.71
LFQH_Lloh6017:
nop
fmov	d14, x8
fmov	d15, #-8.00000000
LFQH_Lloh6018:
adr x26, LFQH_l_.str.372
LFQH_Lloh6019:
nop
LFQH_LBB335_26:
sub	x27, x28, #1
mov	x0, x23
bl Lpatch + (0xa5a4 - PATCH_BASE)
mov	x1, x0
mov	x0, x21
mov	x2, x27
bl Lpatch + (0xa5d4 - PATCH_BASE)
cmp	x0, x19
b.eq	LFQH_LBB335_30
mov	x27, x0
mov	x0, x24
bl Lpatch + (0xa5a4 - PATCH_BASE)
mov	x1, x0
mov	x0, x27
bl Lpatch + (0xa5d4 - PATCH_BASE)
cmp	x0, x20
b.ne	LFQH_LBB335_30
mov	x0, x25
bl Lpatch + (0xa5a4 - PATCH_BASE)
mov	x1, x0
mov	x0, x27
bl Lpatch + (0xa5d4 - PATCH_BASE)
cbnz	w0, LFQH_LBB335_30
mov	x0, x26
bl Lpatch + (0xa5a4 - PATCH_BASE)
mov	x1, x0
mov	x0, x27
bl Lpatch + (0xa5d4 - PATCH_BASE)
fmov	d1, #0.50000000
fmul	d1, d2, d1
mov	x8, #4634204016564240384
fmov	d3, x8
fcmp	d2, d3
fcsel	d2, d1, d14, gt
fadd	d0, d0, d1
fabd	d0, d13, d0
fsub	d0, d0, d2
fadd	d0, d0, d15
fcmp	d0, d12
fcsel	d12, d0, d12, mi
LFQH_LBB335_30:
fcmp	d12, d14
cset	w8, gt
cmp	x28, x22
b.hs	LFQH_LBB335_32
add	x28, x28, #1
fcmp	d12, d14
b.gt	LFQH_LBB335_26
LFQH_LBB335_32:
fadd	d0, d12, d12
cmp	w8, #0
mov	x8, #4634204016564240384
fmov	d1, x8
fcsel	d12, d0, d1, ne
b	LFQH_LBB335_11
.cfi_endproc
.p2align	2
LFQH_ReaderBottomOptics:
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
mov	x20, x1
mov	x19, x0
LFQH_Lloh6020:
adr x1, LFQH_ReaderOpticalChildrenKey
LFQH_Lloh6021:
nop
bl Lpatch + (0xa628 - PATCH_BASE)
mov	x21, x0
str	w20, [sp, #28]
cbz	w20, LFQH_LBB336_44
LFQH_Lloh6022:
adr x0, LFQH_l_.str.116
LFQH_Lloh6023:
nop
bl Lpatch + (0xa5b0 - PATCH_BASE)
mov	x20, x0
LFQH_Lloh6024:
adr x0, LFQH_l_.str.415
LFQH_Lloh6025:
nop
bl Lpatch + (0xa5a4 - PATCH_BASE)
mov	x1, x0
mov	x0, x20
bl Lpatch + (0xa5d4 - PATCH_BASE)
mov	x22, x0
LFQH_Lloh6026:
adr x0, LFQH_l_.str.414
LFQH_Lloh6027:
nop
bl Lpatch + (0xa5a4 - PATCH_BASE)
mov	x1, x0
mov	x0, x19
bl Lpatch + (0xa5d4 - PATCH_BASE)
mov	x23, x0
LFQH_Lloh6028:
adr x0, LFQH_l_.str.34
LFQH_Lloh6029:
nop
bl Lpatch + (0xa5a4 - PATCH_BASE)
mov	x1, x0
mov	x0, x23
bl Lpatch + (0xa5d4 - PATCH_BASE)
cmp	x0, #16
mov	w8, #16
csel	x27, x0, x8, lo
cbz	x0, LFQH_LBB336_45
mov	x24, #0
LFQH_Lloh6030:
adr x25, LFQH_l_.str.461
LFQH_Lloh6031:
nop
LFQH_Lloh6032:
adr x26, LFQH_l_.str.71
LFQH_Lloh6033:
nop
LFQH_LBB336_3:
mov	x0, x25
bl Lpatch + (0xa5a4 - PATCH_BASE)
mov	x1, x0
mov	x0, x23
mov	x2, x24
bl Lpatch + (0xa5d4 - PATCH_BASE)
mov	x20, x0
mov	x0, x26
bl Lpatch + (0xa5a4 - PATCH_BASE)
mov	x1, x0
mov	x0, x20
bl Lpatch + (0xa5d4 - PATCH_BASE)
cbz	w0, LFQH_LBB336_5
LFQH_LBB336_4:
add	x24, x24, #1
cmp	x24, x27
b.ne	LFQH_LBB336_3
b	LFQH_LBB336_45
LFQH_LBB336_5:
mov	x0, x19
LFQH_Lloh6034:
adr x1, LFQH_SurfaceKey
LFQH_Lloh6035:
nop
bl Lpatch + (0xa628 - PATCH_BASE)
cmp	x20, x0
b.eq	LFQH_LBB336_4
mov	x0, x20
LFQH_Lloh6036:
adr x1, LFQH_l_.str.36
LFQH_Lloh6037:
nop
bl	LFQH_Kind
cbz	w0, LFQH_LBB336_9
fmov	d0, #11.00000000
mov	x0, x20
bl	LFQH_AppearanceFont
LFQH_LBB336_8:
LFQH_Lloh6038:
adr x0, LFQH_l_.str.84
LFQH_Lloh6039:
nop
bl Lpatch + (0xa5a4 - PATCH_BASE)
mov	x1, x0
mov	x0, x22
mov	x2, x20
bl Lpatch + (0xa5d4 - PATCH_BASE)
b	LFQH_LBB336_4
LFQH_LBB336_9:
mov	x0, x20
LFQH_Lloh6040:
adr x1, LFQH_l_.str.70
LFQH_Lloh6041:
nop
bl	LFQH_Kind
cbnz	w0, LFQH_LBB336_13
mov	x0, x20
LFQH_Lloh6042:
adr x1, LFQH_l_.str.138
LFQH_Lloh6043:
nop
bl	LFQH_Kind
cbz	w0, LFQH_LBB336_12
mov	x0, x20
LFQH_Lloh6044:
adr x1, LFQH_l_.str.420
LFQH_Lloh6045:
nop
bl	LFQH_Get
mov	x20, x0
b	LFQH_LBB336_13
LFQH_LBB336_12:
mov	x20, #0
LFQH_LBB336_13:
mov	x0, x20
LFQH_Lloh6046:
adr x1, LFQH_l_.str.70
LFQH_Lloh6047:
nop
bl	LFQH_Kind
cbz	w0, LFQH_LBB336_4
cbz	x20, LFQH_LBB336_4
mov	w28, #0
mov	x0, x20
LFQH_LBB336_16:
cmp	x0, x19
b.eq	LFQH_LBB336_19
LFQH_Lloh6048:
adr x1, LFQH_l_.str.20
LFQH_Lloh6049:
nop
bl	LFQH_Get
cbz	x0, LFQH_LBB336_4
add	w8, w28, #1
cmp	w28, #7
mov	x28, x8
b.lo	LFQH_LBB336_16
b	LFQH_LBB336_4
LFQH_LBB336_19:
mov	x0, x26
bl Lpatch + (0xa5a4 - PATCH_BASE)
mov	x1, x0
mov	x0, x20
bl Lpatch + (0xa5d4 - PATCH_BASE)
cbnz	w0, LFQH_LBB336_4
mov	x0, x20
LFQH_Lloh6050:
adr x1, LFQH_l_.str.70
LFQH_Lloh6051:
nop
bl	LFQH_Kind
cbz	w0, LFQH_LBB336_8
LFQH_Lloh6052:
adr x0, LFQH_l_.str.372
LFQH_Lloh6053:
nop
bl Lpatch + (0xa5a4 - PATCH_BASE)
mov	x1, x0
mov	x0, x20
bl Lpatch + (0xa5d4 - PATCH_BASE)
fmov	d8, d0
fmov	d9, d1
fmov	d10, d2
fmov	d11, d3
mov	x0, x20
LFQH_Lloh6054:
adr x1, LFQH_OpticalFrameAppliedKey
LFQH_Lloh6055:
nop
bl Lpatch + (0xa628 - PATCH_BASE)
mov	x28, x0
mov	x0, x20
LFQH_Lloh6056:
adr x1, LFQH_OpticalFrameStockKey
LFQH_Lloh6057:
nop
bl Lpatch + (0xa628 - PATCH_BASE)
mov	w8, #0
cbz	x28, LFQH_LBB336_28
cbz	x0, LFQH_LBB336_28
str	x0, [sp, #16]
LFQH_Lloh6058:
adr x0, LFQH_l_.str.432
LFQH_Lloh6059:
nop
bl Lpatch + (0xa5a4 - PATCH_BASE)
mov	x1, x0
mov	x0, x28
bl Lpatch + (0xa5d4 - PATCH_BASE)
mov	w8, #0
fcmp	d8, d0
b.ne	LFQH_LBB336_28
fcmp	d9, d1
b.ne	LFQH_LBB336_28
fcmp	d10, d2
b.ne	LFQH_LBB336_28
fcmp	d11, d3
fmov	d12, d8
fmov	d13, d9
fmov	d14, d10
fmov	d15, d11
b.ne	LFQH_LBB336_29
LFQH_Lloh6060:
adr x0, LFQH_l_.str.432
LFQH_Lloh6061:
nop
bl Lpatch + (0xa5a4 - PATCH_BASE)
mov	x1, x0
ldr	x0, [sp, #16]
bl Lpatch + (0xa5d4 - PATCH_BASE)
fmov	d12, d0
fmov	d13, d1
fmov	d14, d2
fmov	d15, d3
mov	w8, #1
b	LFQH_LBB336_29
LFQH_LBB336_28:
fmov	d12, d8
fmov	d13, d9
fmov	d14, d10
fmov	d15, d11
LFQH_LBB336_29:
fmov	x9, d12
fmov	x10, d13
fmov	x11, d14
and	x12, x9, #0x7fffffffffffffff
and	x9, x10, #0x7fffffffffffffff
mov	x13, #9218868437227405311
cmp	x9, x13
cset	w9, gt
and	x10, x11, #0x7fffffffffffffff
cmp	x10, x13
cset	w10, gt
mov	x11, #9218868437227405311
cmp	x12, x13
b.gt	LFQH_LBB336_8
tbnz	w9, #0, LFQH_LBB336_8
tbnz	w10, #0, LFQH_LBB336_8
fmov	x9, d15
and	x9, x9, #0x7fffffffffffffff
cmp	x9, x11
b.gt	LFQH_LBB336_8
fcmp	d14, #0.0
b.le	LFQH_LBB336_8
fcmp	d15, #0.0
b.le	LFQH_LBB336_8
str	d11, [sp, #16]
fmov	d0, #20.00000000
fmaxnm	d11, d14, d15
fcmp	d11, d0
b.ls	LFQH_LBB336_43
tbnz	w8, #0, LFQH_LBB336_38
LFQH_Lloh6062:
adr x0, LFQH_l_.str.512
LFQH_Lloh6063:
nop
bl Lpatch + (0xa5b0 - PATCH_BASE)
str	x0, [sp, #8]
LFQH_Lloh6064:
adr x0, LFQH_l_.str.513
LFQH_Lloh6065:
nop
bl Lpatch + (0xa5a4 - PATCH_BASE)
mov	x1, x0
ldr	x0, [sp, #8]
fmov	d0, d12
fmov	d1, d13
fmov	d2, d14
fmov	d3, d15
bl Lpatch + (0xa5d4 - PATCH_BASE)
mov	x2, x0
mov	x0, x20
LFQH_Lloh6066:
adr x1, LFQH_OpticalFrameStockKey
LFQH_Lloh6067:
nop
mov	w3, #1
bl Lpatch + (0xa634 - PATCH_BASE)
LFQH_LBB336_38:
fmov	d0, #20.00000000
fdiv	d0, d0, d11
fmul	d11, d14, d0
fsub	d1, d14, d11
fmov	d2, #0.50000000
fmul	d1, d1, d2
fadd	d14, d12, d1
fmul	d12, d15, d0
fsub	d0, d15, d12
fmul	d0, d0, d2
fadd	d13, d13, d0
cbz	x28, LFQH_LBB336_40
LFQH_Lloh6068:
adr x0, LFQH_l_.str.432
LFQH_Lloh6069:
nop
bl Lpatch + (0xa5a4 - PATCH_BASE)
mov	x1, x0
mov	x0, x28
bl Lpatch + (0xa5d4 - PATCH_BASE)
fcmp	d14, d0
fccmp	d13, d1, #0, eq
fccmp	d11, d2, #0, eq
fccmp	d12, d3, #0, eq
b.eq	LFQH_LBB336_41
LFQH_LBB336_40:
LFQH_Lloh6070:
adr x0, LFQH_l_.str.512
LFQH_Lloh6071:
nop
bl Lpatch + (0xa5b0 - PATCH_BASE)
mov	x28, x0
LFQH_Lloh6072:
adr x0, LFQH_l_.str.513
LFQH_Lloh6073:
nop
bl Lpatch + (0xa5a4 - PATCH_BASE)
mov	x1, x0
mov	x0, x28
fmov	d0, d14
fmov	d1, d13
fmov	d2, d11
fmov	d3, d12
bl Lpatch + (0xa5d4 - PATCH_BASE)
mov	x2, x0
mov	x0, x20
LFQH_Lloh6074:
adr x1, LFQH_OpticalFrameAppliedKey
LFQH_Lloh6075:
nop
mov	w3, #1
bl Lpatch + (0xa634 - PATCH_BASE)
LFQH_LBB336_41:
fcmp	d8, d14
fccmp	d9, d13, #0, eq
fccmp	d10, d11, #0, eq
ldr	d0, [sp, #16]
fccmp	d0, d12, #0, eq
b.eq	LFQH_LBB336_8
LFQH_Lloh6076:
adr x0, LFQH_l_.str.156
LFQH_Lloh6077:
nop
bl Lpatch + (0xa5a4 - PATCH_BASE)
mov	x1, x0
mov	x0, x20
fmov	d0, d14
fmov	d1, d13
fmov	d2, d11
fmov	d3, d12
bl Lpatch + (0xa5d4 - PATCH_BASE)
b	LFQH_LBB336_8
LFQH_LBB336_43:
mov	x0, x20
bl	LFQH_RestoreOpticalFrame
b	LFQH_LBB336_8
LFQH_LBB336_44:
mov	x22, #0
LFQH_LBB336_45:
LFQH_Lloh6078:
adr x0, LFQH_l_.str.34
LFQH_Lloh6079:
nop
bl Lpatch + (0xa5a4 - PATCH_BASE)
mov	x1, x0
mov	x0, x21
bl Lpatch + (0xa5d4 - PATCH_BASE)
mov	x20, x0
cbz	x0, LFQH_LBB336_55
mov	x23, #0
LFQH_Lloh6080:
adr x24, LFQH_l_.str.461
LFQH_Lloh6081:
nop
LFQH_Lloh6082:
adr x25, LFQH_l_.str.34
LFQH_Lloh6083:
nop
LFQH_LBB336_47:
mov	x0, x24
bl Lpatch + (0xa5a4 - PATCH_BASE)
mov	x1, x0
mov	x0, x21
mov	x2, x23
bl Lpatch + (0xa5d4 - PATCH_BASE)
mov	x26, x0
mov	x0, x25
bl Lpatch + (0xa5a4 - PATCH_BASE)
mov	x1, x0
mov	x0, x22
bl Lpatch + (0xa5d4 - PATCH_BASE)
cbz	x0, LFQH_LBB336_53
mov	x27, x0
mov	x0, x24
bl Lpatch + (0xa5a4 - PATCH_BASE)
mov	x1, x0
mov	x0, x22
mov	x2, #0
bl Lpatch + (0xa5d4 - PATCH_BASE)
cmp	x0, x26
b.eq	LFQH_LBB336_54
mov	w8, #1
LFQH_LBB336_50:
mov	x28, x8
cmp	x27, x8
b.eq	LFQH_LBB336_52
mov	x0, x24
bl Lpatch + (0xa5a4 - PATCH_BASE)
mov	x1, x0
mov	x0, x22
mov	x2, x28
bl Lpatch + (0xa5d4 - PATCH_BASE)
add	x8, x28, #1
cmp	x0, x26
b.ne	LFQH_LBB336_50
LFQH_LBB336_52:
cmp	x28, x27
b.lo	LFQH_LBB336_54
LFQH_LBB336_53:
mov	x0, x26
bl	LFQH_RestoreOpticalFrame
mov	x0, x26
bl	LFQH_RestoreAppearanceFont
LFQH_LBB336_54:
add	x23, x23, #1
cmp	x23, x20
b.ne	LFQH_LBB336_47
LFQH_LBB336_55:
LFQH_Lloh6084:
adr x0, LFQH_l_.str.34
LFQH_Lloh6085:
nop
bl Lpatch + (0xa5a4 - PATCH_BASE)
mov	x1, x0
mov	x0, x22
bl Lpatch + (0xa5d4 - PATCH_BASE)
cmp	x20, x0
cset	w27, eq
cbz	x0, LFQH_LBB336_61
b.ne	LFQH_LBB336_61
mov	x23, x0
mov	w28, #1
LFQH_Lloh6086:
adr x24, LFQH_l_.str.461
LFQH_Lloh6087:
nop
LFQH_LBB336_58:
sub	x26, x28, #1
mov	x0, x24
bl Lpatch + (0xa5a4 - PATCH_BASE)
mov	x1, x0
mov	x0, x21
mov	x2, x26
bl Lpatch + (0xa5d4 - PATCH_BASE)
mov	x25, x0
mov	x0, x24
bl Lpatch + (0xa5a4 - PATCH_BASE)
mov	x1, x0
mov	x0, x22
mov	x2, x26
bl Lpatch + (0xa5d4 - PATCH_BASE)
cmp	x28, x20
b.hs	LFQH_LBB336_60
add	x28, x28, #1
cmp	x25, x0
ccmp	x20, x23, #0, eq
b.eq	LFQH_LBB336_58
LFQH_LBB336_60:
cmp	x25, x0
csel	w27, w27, wzr, eq
LFQH_LBB336_61:
ldr	w8, [sp, #28]
cmp	w8, #0
ccmp	x21, #0, #4, eq
cset	w8, ne
cbz	w27, LFQH_LBB336_64
tbnz	w8, #0, LFQH_LBB336_64
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
LFQH_LBB336_64:
LFQH_Lloh6088:
adr x1, LFQH_ReaderOpticalChildrenKey
LFQH_Lloh6089:
nop
mov	x0, x19
mov	x2, x22
mov	w3, #1
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
b Lpatch + (0xa634 - PATCH_BASE)
.cfi_endproc
.p2align	2
LFQH_ReaderOpticalChildrenKey:
.cfi_startproc
ret
.cfi_endproc
.p2align	2
LFQH_RestoreOpticalFrame:
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
LFQH_Lloh6090:
adr x1, LFQH_OpticalFrameAppliedKey
LFQH_Lloh6091:
nop
bl Lpatch + (0xa628 - PATCH_BASE)
mov	x21, x0
LFQH_Lloh6092:
adr x1, LFQH_OpticalFrameStockKey
LFQH_Lloh6093:
nop
mov	x0, x19
bl Lpatch + (0xa628 - PATCH_BASE)
cmp	x21, #0
ccmp	x0, #0, #4, ne
b.eq	LFQH_LBB338_3
mov	x20, x0
LFQH_Lloh6094:
adr x0, LFQH_l_.str.372
LFQH_Lloh6095:
nop
bl Lpatch + (0xa5a4 - PATCH_BASE)
mov	x1, x0
mov	x0, x19
bl Lpatch + (0xa5d4 - PATCH_BASE)
fmov	d8, d0
fmov	d9, d1
fmov	d10, d2
fmov	d11, d3
LFQH_Lloh6096:
adr x0, LFQH_l_.str.432
LFQH_Lloh6097:
nop
bl Lpatch + (0xa5a4 - PATCH_BASE)
mov	x1, x0
mov	x0, x21
bl Lpatch + (0xa5d4 - PATCH_BASE)
fcmp	d8, d0
fccmp	d9, d1, #0, eq
fccmp	d10, d2, #0, eq
fccmp	d11, d3, #0, eq
b.ne	LFQH_LBB338_3
LFQH_Lloh6098:
adr x0, LFQH_l_.str.432
LFQH_Lloh6099:
nop
bl Lpatch + (0xa5a4 - PATCH_BASE)
mov	x1, x0
mov	x0, x20
bl Lpatch + (0xa5d4 - PATCH_BASE)
fmov	d8, d0
fmov	d9, d1
fmov	d10, d2
fmov	d11, d3
LFQH_Lloh6100:
adr x0, LFQH_l_.str.156
LFQH_Lloh6101:
nop
bl Lpatch + (0xa5a4 - PATCH_BASE)
mov	x1, x0
mov	x0, x19
fmov	d0, d8
fmov	d1, d9
fmov	d2, d10
fmov	d3, d11
bl Lpatch + (0xa5d4 - PATCH_BASE)
LFQH_LBB338_3:
LFQH_Lloh6102:
adr x1, LFQH_OpticalFrameStockKey
LFQH_Lloh6103:
nop
mov	x0, x19
mov	x2, #0
mov	w3, #1
bl Lpatch + (0xa634 - PATCH_BASE)
LFQH_Lloh6104:
adr x1, LFQH_OpticalFrameAppliedKey
LFQH_Lloh6105:
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
LFQH_OpticalFrameAppliedKey:
.cfi_startproc
ret
.cfi_endproc
.p2align	2
LFQH_OpticalFrameStockKey:
.cfi_startproc
ret
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
LFQH_Lloh6106:
adr x0, LFQH_l_.str.354
LFQH_Lloh6107:
nop
bl Lpatch + (0xa5a4 - PATCH_BASE)
mov	x1, x0
mov	x0, x19
bl Lpatch + (0xa5d4 - PATCH_BASE)
cmp	x0, #3
b.ne	LFQH_LBB342_4
LFQH_Lloh6108:
adr x0, LFQH_l_.str.351
LFQH_Lloh6109:
nop
bl Lpatch + (0xa5a4 - PATCH_BASE)
mov	x1, x0
mov	x0, x19
bl Lpatch + (0xa5d4 - PATCH_BASE)
mov	x20, x0
LFQH_Lloh6110:
adr x1, LFQH_SurfaceKey
LFQH_Lloh6111:
nop
bl Lpatch + (0xa628 - PATCH_BASE)
cbz	x0, LFQH_LBB342_4
mov	x0, x20
bl	LFQH_ReaderBottomType
cmp	w0, #1
b.ne	LFQH_LBB342_4
LFQH_Lloh6112:
adr x0, LFQH_l_.str.721
LFQH_Lloh6113:
nop
bl Lpatch + (0xa5a4 - PATCH_BASE)
mov	x1, x0
mov	x0, x20
mov	x2, x19
ldp	x29, x30, [sp, #16]
ldp	x20, x19, [sp], #32
b Lpatch + (0xa5d4 - PATCH_BASE)
LFQH_LBB342_4:
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
LFQH_Lloh6114:
adr x0, LFQH_l_.str.351
LFQH_Lloh6115:
nop
bl Lpatch + (0xa5a4 - PATCH_BASE)
mov	x1, x0
mov	x0, x20
bl Lpatch + (0xa5d4 - PATCH_BASE)
mov	x21, x0
LFQH_Lloh6116:
adr x1, LFQH_SurfaceKey
LFQH_Lloh6117:
nop
bl Lpatch + (0xa628 - PATCH_BASE)
cbz	x0, LFQH_LBB343_4
mov	x20, x0
LFQH_Lloh6118:
adr x0, LFQH_l_.str.351
LFQH_Lloh6119:
nop
bl Lpatch + (0xa5a4 - PATCH_BASE)
mov	x1, x0
mov	x0, x19
bl Lpatch + (0xa5d4 - PATCH_BASE)
cmp	x0, x21
b.eq	LFQH_LBB343_3
mov	w0, #0
b	LFQH_LBB343_4
LFQH_LBB343_3:
LFQH_Lloh6120:
adr x0, LFQH_l_.str.607
LFQH_Lloh6121:
nop
bl Lpatch + (0xa5a4 - PATCH_BASE)
mov	x1, x0
mov	x0, x19
mov	x2, x21
bl Lpatch + (0xa5d4 - PATCH_BASE)
fmov	d8, d0
fmov	d9, d1
LFQH_Lloh6122:
adr x0, LFQH_l_.str.372
LFQH_Lloh6123:
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
LFQH_LBB343_4:
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
LFQH_Lloh6124:
adr x1, LFQH_l_.str.726
LFQH_Lloh6125:
nop
bl	LFQH_Get
mov	x21, x0
LFQH_Lloh6126:
adr x1, LFQH_l_.str.727
LFQH_Lloh6127:
nop
mov	x0, x19
bl	LFQH_Get
mov	x20, x0
LFQH_Lloh6128:
adr x1, LFQH_l_.str.138
LFQH_Lloh6129:
nop
mov	x0, x21
bl	LFQH_Kind
cbz	w0, LFQH_LBB344_3
LFQH_Lloh6130:
adr x0, LFQH_l_.str.20
LFQH_Lloh6131:
nop
bl Lpatch + (0xa5a4 - PATCH_BASE)
mov	x1, x0
mov	x0, x21
bl Lpatch + (0xa5d4 - PATCH_BASE)
cmp	x0, x19
b.ne	LFQH_LBB344_3
mov	x0, x21
mov	w1, #7
bl	LFQH_Icon
LFQH_LBB344_3:
LFQH_Lloh6132:
adr x1, LFQH_l_.str.138
LFQH_Lloh6133:
nop
mov	x0, x20
bl	LFQH_Kind
cbz	w0, LFQH_LBB344_6
LFQH_Lloh6134:
adr x0, LFQH_l_.str.20
LFQH_Lloh6135:
nop
bl Lpatch + (0xa5a4 - PATCH_BASE)
mov	x1, x0
mov	x0, x20
bl Lpatch + (0xa5d4 - PATCH_BASE)
cmp	x0, x19
b.ne	LFQH_LBB344_6
mov	x0, x20
mov	w1, #7
bl	LFQH_Icon
LFQH_LBB344_6:
LFQH_Lloh6136:
adr x1, LFQH_l_.str.511
LFQH_Lloh6137:
nop
mov	x0, x19
bl	LFQH_Get
mov	x20, x0
LFQH_Lloh6138:
adr x1, LFQH_l_.str.728
LFQH_Lloh6139:
nop
bl	LFQH_Kind
cbz	w0, LFQH_LBB344_12
LFQH_Lloh6140:
adr x1, LFQH_l_.str.729
LFQH_Lloh6141:
nop
mov	x0, x20
bl	LFQH_Get
mov	x19, x0
LFQH_Lloh6142:
adr x1, LFQH_l_.str.70
LFQH_Lloh6143:
nop
bl	LFQH_Kind
cbz	w0, LFQH_LBB344_9
LFQH_Lloh6144:
adr x0, LFQH_l_.str.20
LFQH_Lloh6145:
nop
bl Lpatch + (0xa5a4 - PATCH_BASE)
mov	x1, x0
mov	x0, x19
bl Lpatch + (0xa5d4 - PATCH_BASE)
cmp	x0, x20
b.eq	LFQH_LBB344_10
LFQH_LBB344_9:
mov	x0, x20
mov	w1, #0
ldp	x29, x30, [sp, #32]
ldp	x20, x19, [sp, #16]
ldp	x22, x21, [sp], #48
b	LFQH_ReaderProgressFill
LFQH_LBB344_10:
mov	x0, x19
bl	LFQH_FQHApply
LFQH_Lloh6146:
adr x1, LFQH_SurfaceKey
LFQH_Lloh6147:
nop
mov	x0, x19
bl Lpatch + (0xa628 - PATCH_BASE)
mov	x21, x0
cmp	x0, #0
cset	w1, ne
mov	x0, x20
bl	LFQH_ReaderProgressFill
cbz	x21, LFQH_LBB344_12
LFQH_Lloh6148:
adr x0, LFQH_l_.str.24
LFQH_Lloh6149:
nop
bl Lpatch + (0xa5a4 - PATCH_BASE)
mov	x1, x0
mov	x0, x19
bl Lpatch + (0xa5d4 - PATCH_BASE)
LFQH_Lloh6150:
adr x2, LFQH_l_.str.730
LFQH_Lloh6151:
nop
mov	x0, x19
mov	x1, x21
ldp	x29, x30, [sp, #32]
ldp	x20, x19, [sp, #16]
ldp	x22, x21, [sp], #48
b	LFQH_RecordLayout
LFQH_LBB344_12:
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
LFQH_Lloh6152:
adr x1, LFQH_l_.str.731
LFQH_Lloh6153:
nop
bl	LFQH_Get
mov	x19, x0
LFQH_Lloh6154:
adr x1, LFQH_l_.str.70
LFQH_Lloh6155:
nop
bl	LFQH_Kind
cbz	w0, LFQH_LBB345_4
LFQH_Lloh6156:
adr x0, LFQH_l_.str.20
LFQH_Lloh6157:
nop
bl Lpatch + (0xa5a4 - PATCH_BASE)
mov	x1, x0
mov	x0, x19
bl Lpatch + (0xa5d4 - PATCH_BASE)
cmp	x0, x20
b.ne	LFQH_LBB345_4
LFQH_Lloh6158:
adr x1, LFQH_ReaderProgressColorKey
LFQH_Lloh6159:
nop
mov	x0, x19
bl Lpatch + (0xa628 - PATCH_BASE)
mov	x20, x0
cbnz	w23, LFQH_LBB345_5
cbnz	x20, LFQH_LBB345_5
LFQH_LBB345_4:
ldp	x29, x30, [sp, #48]
ldp	x20, x19, [sp, #32]
ldp	x22, x21, [sp, #16]
ldp	x24, x23, [sp], #64
ret
LFQH_LBB345_5:
LFQH_Lloh6160:
adr x0, LFQH_l_.str.390
LFQH_Lloh6161:
nop
bl Lpatch + (0xa5a4 - PATCH_BASE)
mov	x1, x0
mov	x0, x19
bl Lpatch + (0xa5d4 - PATCH_BASE)
mov	x21, x0
LFQH_Lloh6162:
adr x1, LFQH_ReaderProgressStockKey
LFQH_Lloh6163:
nop
mov	x0, x19
bl Lpatch + (0xa628 - PATCH_BASE)
mov	x22, x0
cbz	w23, LFQH_LBB345_12
cmp	x21, x20
b.eq	LFQH_LBB345_4
LFQH_Lloh6164:
adr x0, LFQH_l_.str.49
LFQH_Lloh6165:
nop
bl Lpatch + (0xa5a4 - PATCH_BASE)
mov	x1, x0
mov	x0, x21
mov	x2, x20
bl Lpatch + (0xa5d4 - PATCH_BASE)
cbnz	w0, LFQH_LBB345_4
cbz	x21, LFQH_LBB345_11
LFQH_Lloh6166:
adr x0, LFQH_l_.str.47
LFQH_Lloh6167:
nop
bl Lpatch + (0xa5b0 - PATCH_BASE)
mov	x23, x0
LFQH_Lloh6168:
adr x0, LFQH_l_.str.158
LFQH_Lloh6169:
nop
bl Lpatch + (0xa5a4 - PATCH_BASE)
mov	x1, x0
mov	x0, x23
bl Lpatch + (0xa5d4 - PATCH_BASE)
cmp	x21, x0
b.eq	LFQH_LBB345_11
mov	x23, x0
LFQH_Lloh6170:
adr x0, LFQH_l_.str.49
LFQH_Lloh6171:
nop
bl Lpatch + (0xa5a4 - PATCH_BASE)
mov	x1, x0
mov	x0, x21
mov	x2, x23
bl Lpatch + (0xa5d4 - PATCH_BASE)
cbz	w0, LFQH_LBB345_17
LFQH_LBB345_11:
cbnz	x20, LFQH_LBB345_16
b	LFQH_LBB345_4
LFQH_LBB345_12:
cbz	x20, LFQH_LBB345_4
cmp	x21, x20
b.eq	LFQH_LBB345_15
LFQH_Lloh6172:
adr x0, LFQH_l_.str.49
LFQH_Lloh6173:
nop
bl Lpatch + (0xa5a4 - PATCH_BASE)
mov	x1, x0
mov	x0, x21
mov	x2, x20
bl Lpatch + (0xa5d4 - PATCH_BASE)
cbz	w0, LFQH_LBB345_16
LFQH_LBB345_15:
LFQH_Lloh6174:
adr x0, LFQH_l_.str.157
LFQH_Lloh6175:
nop
bl Lpatch + (0xa5a4 - PATCH_BASE)
mov	x1, x0
mov	x0, x19
mov	x2, x22
bl Lpatch + (0xa5d4 - PATCH_BASE)
LFQH_LBB345_16:
LFQH_Lloh6176:
adr x1, LFQH_ReaderProgressStockKey
LFQH_Lloh6177:
nop
mov	x0, x19
mov	x2, #0
mov	w3, #1
bl Lpatch + (0xa634 - PATCH_BASE)
LFQH_Lloh6178:
adr x1, LFQH_ReaderProgressColorKey
LFQH_Lloh6179:
nop
mov	x0, x19
mov	x2, #0
mov	w3, #1
ldp	x29, x30, [sp, #48]
ldp	x20, x19, [sp, #32]
ldp	x22, x21, [sp, #16]
ldp	x24, x23, [sp], #64
b Lpatch + (0xa634 - PATCH_BASE)
LFQH_LBB345_17:
cbz	x20, LFQH_LBB345_20
cmp	x21, x22
b.eq	LFQH_LBB345_22
LFQH_Lloh6180:
adr x0, LFQH_l_.str.49
LFQH_Lloh6181:
nop
bl Lpatch + (0xa5a4 - PATCH_BASE)
mov	x1, x0
mov	x0, x21
mov	x2, x22
bl Lpatch + (0xa5d4 - PATCH_BASE)
cbnz	w0, LFQH_LBB345_22
LFQH_LBB345_20:
LFQH_Lloh6182:
adr x0, LFQH_l_.str.51
LFQH_Lloh6183:
nop
bl Lpatch + (0xa5a4 - PATCH_BASE)
mov	x1, x0
fmov	d0, #0.15625000
mov	x0, x21
bl Lpatch + (0xa5d4 - PATCH_BASE)
cbz	x0, LFQH_LBB345_4
mov	x20, x0
LFQH_Lloh6184:
adr x1, LFQH_ReaderProgressStockKey
LFQH_Lloh6185:
nop
mov	x0, x19
mov	x2, x21
mov	w3, #1
bl Lpatch + (0xa634 - PATCH_BASE)
LFQH_Lloh6186:
adr x1, LFQH_ReaderProgressColorKey
LFQH_Lloh6187:
nop
mov	x0, x19
mov	x2, x20
mov	w3, #1
bl Lpatch + (0xa634 - PATCH_BASE)
LFQH_LBB345_22:
LFQH_Lloh6188:
adr x0, LFQH_l_.str.157
LFQH_Lloh6189:
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
LFQH_Lloh6190:
adr x1, LFQH_l_.str.20
LFQH_Lloh6191:
nop
bl	LFQH_Get
cbz	x0, LFQH_LBB348_5
mov	x20, x0
mov	w24, #0
LFQH_Lloh6192:
adr x21, LFQH_l_.str.389
LFQH_Lloh6193:
nop
LFQH_Lloh6194:
adr x22, LFQH_l_.str.20
LFQH_Lloh6195:
nop
LFQH_LBB348_2:
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
cbnz	w0, LFQH_LBB348_6
mov	x0, x20
mov	x1, x22
bl	LFQH_Get
cbz	x0, LFQH_LBB348_6
mov	x20, x0
add	w8, w24, #1
cmp	w24, #4
mov	x24, x8
b.lo	LFQH_LBB348_2
b	LFQH_LBB348_6
LFQH_LBB348_5:
mov	w23, #0
LFQH_LBB348_6:
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
stp	d9, d8, [sp, #-112]!
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
.cfi_offset b8, -104
.cfi_offset b9, -112
mov	x19, x0
bl Lpatch + (0xa664 - PATCH_BASE)
mov	x20, x0
LFQH_Lloh6196:
adr x0, LFQH_l_.str.23
LFQH_Lloh6197:
nop
bl Lpatch + (0xa5b0 - PATCH_BASE)
cmp	x20, x0
b.ne	LFQH_LBB349_18
LFQH_Lloh6198:
adr x0, LFQH_l_.str.414
LFQH_Lloh6199:
nop
bl Lpatch + (0xa5a4 - PATCH_BASE)
mov	x1, x0
mov	x0, x19
bl Lpatch + (0xa5d4 - PATCH_BASE)
mov	x20, x0
LFQH_Lloh6200:
adr x0, LFQH_l_.str.34
LFQH_Lloh6201:
nop
bl Lpatch + (0xa5a4 - PATCH_BASE)
mov	x1, x0
mov	x0, x20
bl Lpatch + (0xa5d4 - PATCH_BASE)
cbz	x0, LFQH_LBB349_12
mov	x21, x0
mov	w28, #1
LFQH_Lloh6202:
adr x22, LFQH_l_.str.461
LFQH_Lloh6203:
nop
LFQH_Lloh6204:
adr x23, LFQH_l_.str.36
LFQH_Lloh6205:
nop
LFQH_Lloh6206:
adr x24, LFQH_l_.str.500
LFQH_Lloh6207:
nop
LFQH_Lloh6208:
adr x25, LFQH_l_.str.736
LFQH_Lloh6209:
nop
LFQH_Lloh6210:
adr x26, LFQH_l_.str.737
LFQH_Lloh6211:
nop
LFQH_LBB349_3:
sub	x27, x28, #1
mov	x0, x22
bl Lpatch + (0xa5a4 - PATCH_BASE)
mov	x1, x0
mov	x0, x20
mov	x2, x27
bl Lpatch + (0xa5d4 - PATCH_BASE)
mov	x27, x0
mov	x1, x23
bl	LFQH_Kind
cbz	w0, LFQH_LBB349_6
mov	x0, x24
bl Lpatch + (0xa5a4 - PATCH_BASE)
mov	x1, x0
mov	x0, x27
bl Lpatch + (0xa5d4 - PATCH_BASE)
mov	x27, x0
mov	x1, x25
bl	LFQH_Equal
cbz	w0, LFQH_LBB349_7
mov	w8, #1
b	LFQH_LBB349_8
LFQH_LBB349_6:
mov	w8, #0
b	LFQH_LBB349_8
LFQH_LBB349_7:
mov	x0, x27
mov	x1, x26
bl	LFQH_Equal
cmp	w0, #0
cset	w8, ne
LFQH_LBB349_8:
cmp	x28, x21
b.hs	LFQH_LBB349_10
add	x28, x28, #1
cbz	w8, LFQH_LBB349_3
LFQH_LBB349_10:
cbz	w8, LFQH_LBB349_12
LFQH_Lloh6212:
adr x0, LFQH_l_.str.71
LFQH_Lloh6213:
nop
bl Lpatch + (0xa5a4 - PATCH_BASE)
mov	x1, x0
mov	x0, x19
bl Lpatch + (0xa5d4 - PATCH_BASE)
cbz	w0, LFQH_LBB349_14
LFQH_LBB349_12:
LFQH_Lloh6214:
adr x1, LFQH_SurfaceKey
LFQH_Lloh6215:
nop
mov	x0, x19
bl Lpatch + (0xa628 - PATCH_BASE)
cbz	x0, LFQH_LBB349_15
mov	x0, x19
bl	LFQH_PageRestore
b	LFQH_LBB349_15
LFQH_LBB349_14:
mov	x0, x19
bl	LFQH_FQHApply
LFQH_LBB349_15:
LFQH_Lloh6216:
adr x1, LFQH_CoverGuideBorderKey
LFQH_Lloh6217:
nop
mov	x0, x19
bl Lpatch + (0xa628 - PATCH_BASE)
mov	x21, x0
LFQH_Lloh6218:
adr x1, LFQH_SurfaceKey
LFQH_Lloh6219:
nop
mov	x0, x19
bl Lpatch + (0xa628 - PATCH_BASE)
orr	x8, x0, x21
cbz	x8, LFQH_LBB349_18
mov	x22, x0
LFQH_Lloh6220:
adr x0, LFQH_l_.str.403
LFQH_Lloh6221:
nop
bl Lpatch + (0xa5a4 - PATCH_BASE)
mov	x1, x0
mov	x0, x19
bl Lpatch + (0xa5d4 - PATCH_BASE)
mov	x20, x0
LFQH_Lloh6222:
adr x0, LFQH_l_.str.738
LFQH_Lloh6223:
nop
bl Lpatch + (0xa5a4 - PATCH_BASE)
mov	x1, x0
mov	x0, x20
bl Lpatch + (0xa5d4 - PATCH_BASE)
fmov	d8, d0
cbz	x22, LFQH_LBB349_19
fcmp	d8, #0.0
b.ne	LFQH_LBB349_22
LFQH_LBB349_18:
ldp	x29, x30, [sp, #96]
ldp	x20, x19, [sp, #80]
ldp	x22, x21, [sp, #64]
ldp	x24, x23, [sp, #48]
ldp	x26, x25, [sp, #32]
ldp	x28, x27, [sp, #16]
ldp	d9, d8, [sp], #112
ret
LFQH_LBB349_19:
fcmp	d8, #0.0
b.ne	LFQH_LBB349_21
LFQH_Lloh6224:
adr x0, LFQH_l_.str.739
LFQH_Lloh6225:
nop
bl Lpatch + (0xa5a4 - PATCH_BASE)
mov	x22, x0
LFQH_Lloh6226:
adr x0, LFQH_l_.str.445
LFQH_Lloh6227:
nop
bl Lpatch + (0xa5a4 - PATCH_BASE)
mov	x1, x0
mov	x0, x21
bl Lpatch + (0xa5d4 - PATCH_BASE)
mov	x0, x20
mov	x1, x22
bl Lpatch + (0xa5d4 - PATCH_BASE)
LFQH_LBB349_21:
LFQH_Lloh6228:
adr x1, LFQH_CoverGuideBorderKey
LFQH_Lloh6229:
nop
mov	x0, x19
mov	x2, #0
mov	w3, #1
ldp	x29, x30, [sp, #96]
ldp	x20, x19, [sp, #80]
ldp	x22, x21, [sp, #64]
ldp	x24, x23, [sp, #48]
ldp	x26, x25, [sp, #32]
ldp	x28, x27, [sp, #16]
ldp	d9, d8, [sp], #112
b Lpatch + (0xa634 - PATCH_BASE)
LFQH_LBB349_22:
LFQH_Lloh6230:
adr x0, LFQH_l_.str.497
LFQH_Lloh6231:
nop
bl Lpatch + (0xa5b0 - PATCH_BASE)
mov	x21, x0
LFQH_Lloh6232:
adr x0, LFQH_l_.str.515
LFQH_Lloh6233:
nop
bl Lpatch + (0xa5a4 - PATCH_BASE)
mov	x1, x0
mov	x0, x21
fmov	d0, d8
bl Lpatch + (0xa5d4 - PATCH_BASE)
mov	x2, x0
LFQH_Lloh6234:
adr x1, LFQH_CoverGuideBorderKey
LFQH_Lloh6235:
nop
mov	x0, x19
mov	w3, #1
bl Lpatch + (0xa634 - PATCH_BASE)
LFQH_Lloh6236:
adr x0, LFQH_l_.str.739
LFQH_Lloh6237:
nop
bl Lpatch + (0xa5a4 - PATCH_BASE)
mov	x1, x0
fmov	d0, xzr
mov	x0, x20
ldp	x29, x30, [sp, #96]
ldp	x20, x19, [sp, #80]
ldp	x22, x21, [sp, #64]
ldp	x24, x23, [sp, #48]
ldp	x26, x25, [sp, #32]
ldp	x28, x27, [sp, #16]
ldp	d9, d8, [sp], #112
b Lpatch + (0xa5d4 - PATCH_BASE)
.cfi_endproc
.p2align	2
LFQH_CoverGuideBorderKey:
.cfi_startproc
ret
.cfi_endproc
.p2align	2
LFQH_ChapterDiscussionMode:
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
mov	x21, x1
mov	x20, x0
LFQH_Lloh6238:
adr x1, LFQH_l_.str.219
LFQH_Lloh6239:
nop
mov	x0, x21
bl	LFQH_Kind
cbz	w0, LFQH_LBB351_4
LFQH_Lloh6240:
adr x0, LFQH_l_.str.71
LFQH_Lloh6241:
nop
bl Lpatch + (0xa5a4 - PATCH_BASE)
mov	x1, x0
mov	x0, x21
bl Lpatch + (0xa5d4 - PATCH_BASE)
cbnz	w0, LFQH_LBB351_4
LFQH_Lloh6242:
adr x1, LFQH_l_.str.20
LFQH_Lloh6243:
nop
mov	x0, x19
bl	LFQH_Get
cmp	x0, x20
b.ne	LFQH_LBB351_4
LFQH_Lloh6244:
adr x1, LFQH_l_.str.741
LFQH_Lloh6245:
nop
mov	x0, x20
bl	LFQH_Get
cmp	x0, x19
b.eq	LFQH_LBB351_6
LFQH_LBB351_4:
mov	x0, #0
LFQH_LBB351_5:
ldp	x29, x30, [sp, #32]
ldp	x20, x19, [sp, #16]
ldp	x22, x21, [sp], #48
ret
LFQH_LBB351_6:
LFQH_Lloh6246:
adr x1, LFQH_l_.str.742
LFQH_Lloh6247:
nop
mov	x0, x20
bl	LFQH_Get
mov	x21, x0
bl Lpatch + (0xa664 - PATCH_BASE)
LFQH_Lloh6248:
adr x1, LFQH_l_.str.743
LFQH_Lloh6249:
nop
LFQH_Lloh6250:
adr x2, LFQH_l_.str.641
LFQH_Lloh6251:
nop
bl	LFQH_ClassABI
cbz	w0, LFQH_LBB351_4
LFQH_Lloh6252:
adr x0, LFQH_l_.str.743
LFQH_Lloh6253:
nop
bl Lpatch + (0xa5a4 - PATCH_BASE)
mov	x1, x0
mov	x0, x21
bl Lpatch + (0xa5d4 - PATCH_BASE)
cmp	x0, #1
b.eq	LFQH_LBB351_5
cmp	x0, #2
b.ne	LFQH_LBB351_4
LFQH_Lloh6254:
adr x0, LFQH_l_.str.14
LFQH_Lloh6255:
nop
bl Lpatch + (0xa5b0 - PATCH_BASE)
LFQH_Lloh6256:
adr x1, LFQH_l_.str.744
LFQH_Lloh6257:
nop
bl	LFQH_Responds
cbz	w0, LFQH_LBB351_4
LFQH_Lloh6258:
adr x1, LFQH_l_.str.745
LFQH_Lloh6259:
nop
mov	x0, x20
bl	LFQH_Get
mov	x20, x0
LFQH_Lloh6260:
adr x1, LFQH_l_.str.746
LFQH_Lloh6261:
nop
bl	LFQH_Kind
cbz	w0, LFQH_LBB351_4
LFQH_Lloh6262:
adr x1, LFQH_l_.str.20
LFQH_Lloh6263:
nop
mov	x0, x20
bl	LFQH_Get
cmp	x0, x19
b.ne	LFQH_LBB351_4
LFQH_Lloh6264:
adr x0, LFQH_l_.str.71
LFQH_Lloh6265:
nop
bl Lpatch + (0xa5a4 - PATCH_BASE)
mov	x1, x0
mov	x0, x20
bl Lpatch + (0xa5d4 - PATCH_BASE)
cmp	w0, #0
cset	w8, eq
ubfiz	x0, x8, #1, #32
b	LFQH_LBB351_5
.cfi_endproc
.p2align	2
LFQH_ChapterDiscussionGlass:
.cfi_startproc
stp	d11, d10, [sp, #-128]!
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
.cfi_offset b10, -120
.cfi_offset b11, -128
mov	x20, x0
LFQH_Lloh6266:
adr x1, LFQH_ChapterDiscussionKey
LFQH_Lloh6267:
nop
bl Lpatch + (0xa628 - PATCH_BASE)
mov	x21, x0
LFQH_Lloh6268:
adr x1, LFQH_ChapterCardBackingKey
LFQH_Lloh6269:
nop
mov	x0, x20
bl Lpatch + (0xa628 - PATCH_BASE)
mov	x23, x0
LFQH_Lloh6270:
adr x1, LFQH_l_.str.740
LFQH_Lloh6271:
nop
mov	x0, x20
bl	LFQH_Get
mov	x22, x0
LFQH_Lloh6272:
adr x1, LFQH_l_.str.20
LFQH_Lloh6273:
nop
bl	LFQH_Get
mov	x19, x0
mov	x0, x20
mov	x1, x22
mov	x2, x19
bl	LFQH_ChapterDiscussionMode
mov	x24, x0
cbz	x0, LFQH_LBB352_7
LFQH_Lloh6274:
adr x1, LFQH_SurfaceKey
LFQH_Lloh6275:
nop
mov	x0, x22
bl Lpatch + (0xa628 - PATCH_BASE)
cbz	x0, LFQH_LBB352_3
mov	x0, x22
bl	LFQH_PageRestore
LFQH_LBB352_3:
mov	x0, x19
bl	LFQH_FQHApply
LFQH_Lloh6276:
adr x1, LFQH_SurfaceKey
LFQH_Lloh6277:
nop
mov	x0, x19
bl Lpatch + (0xa628 - PATCH_BASE)
cbz	x0, LFQH_LBB352_7
mov	x25, x0
cmp	x24, #2
cset	w26, eq
LFQH_Lloh6278:
adr x1, LFQH_ChapterCardRoundedKey
LFQH_Lloh6279:
nop
bl Lpatch + (0xa628 - PATCH_BASE)
cmp	x0, #0
cset	w8, eq
eor	w8, w26, w8
mov	x26, x19
tbnz	w8, #0, LFQH_LBB352_10
LFQH_Lloh6280:
adr x0, LFQH_l_.str.14
LFQH_Lloh6281:
nop
bl Lpatch + (0xa5b0 - PATCH_BASE)
mov	x26, x0
cmp	x24, #2
b.ne	LFQH_LBB352_8
LFQH_Lloh6282:
adr x0, LFQH_l_.str.744
LFQH_Lloh6283:
nop
bl Lpatch + (0xa5a4 - PATCH_BASE)
mov	x1, x0
fmov	d0, #18.00000000
mov	x0, x26
bl Lpatch + (0xa5d4 - PATCH_BASE)
mov	x27, x0
mov	x26, x25
b	LFQH_LBB352_9
LFQH_LBB352_7:
mov	x26, #0
b	LFQH_LBB352_10
LFQH_LBB352_8:
LFQH_Lloh6284:
adr x0, LFQH_l_.str.15
LFQH_Lloh6285:
nop
bl Lpatch + (0xa5a4 - PATCH_BASE)
mov	x1, x0
mov	x0, x26
bl Lpatch + (0xa5d4 - PATCH_BASE)
mov	x27, x0
mov	x26, #0
LFQH_LBB352_9:
LFQH_Lloh6286:
adr x0, LFQH_l_.str.17
LFQH_Lloh6287:
nop
bl Lpatch + (0xa5a4 - PATCH_BASE)
mov	x1, x0
mov	x0, x25
mov	x2, x27
bl Lpatch + (0xa5d4 - PATCH_BASE)
LFQH_Lloh6288:
adr x1, LFQH_ChapterCardRoundedKey
LFQH_Lloh6289:
nop
mov	x0, x25
mov	x2, x26
mov	x3, #0
bl Lpatch + (0xa634 - PATCH_BASE)
mov	x26, x19
LFQH_LBB352_10:
cmp	x23, x26
b.eq	LFQH_LBB352_12
mov	x0, x23
bl	LFQH_PageRestore
LFQH_Lloh6290:
adr x1, LFQH_ChapterCardBackingKey
LFQH_Lloh6291:
nop
mov	x0, x20
mov	x2, x26
mov	w3, #1
bl Lpatch + (0xa634 - PATCH_BASE)
LFQH_LBB352_12:
cmp	x26, #0
ccmp	x24, #1, #0, ne
csel	x22, x22, xzr, eq
cmp	x21, x22
b.eq	LFQH_LBB352_14
mov	x0, x21
bl	LFQH_RestoreHit
LFQH_Lloh6292:
adr x1, LFQH_ChapterDiscussionKey
LFQH_Lloh6293:
nop
mov	x0, x20
mov	x2, x22
mov	w3, #1
bl Lpatch + (0xa634 - PATCH_BASE)
LFQH_LBB352_14:
cbz	x22, LFQH_LBB352_16
LFQH_Lloh6294:
adr x0, LFQH_l_.str.24
LFQH_Lloh6295:
nop
bl Lpatch + (0xa5a4 - PATCH_BASE)
mov	x1, x0
mov	x0, x19
bl Lpatch + (0xa5d4 - PATCH_BASE)
fmov	d8, d0
fmov	d9, d1
fmov	d10, d2
fmov	d11, d3
LFQH_Lloh6296:
adr x0, LFQH_l_.str.507
LFQH_Lloh6297:
nop
bl Lpatch + (0xa5a4 - PATCH_BASE)
mov	x1, x0
mov	x0, x19
fmov	d0, d8
fmov	d1, d9
fmov	d2, d10
fmov	d3, d11
mov	x2, x22
bl Lpatch + (0xa5d4 - PATCH_BASE)
mov	x0, x22
ldp	x29, x30, [sp, #112]
ldp	x20, x19, [sp, #96]
ldp	x22, x21, [sp, #80]
ldp	x24, x23, [sp, #64]
ldp	x26, x25, [sp, #48]
ldp	x28, x27, [sp, #32]
ldp	d9, d8, [sp, #16]
ldp	d11, d10, [sp], #128
b	LFQH_EnsureHit
LFQH_LBB352_16:
ldp	x29, x30, [sp, #112]
ldp	x20, x19, [sp, #96]
ldp	x22, x21, [sp, #80]
ldp	x24, x23, [sp, #64]
ldp	x26, x25, [sp, #48]
ldp	x28, x27, [sp, #32]
ldp	d9, d8, [sp, #16]
ldp	d11, d10, [sp], #128
ret
.cfi_endproc
.p2align	2
LFQH_ChapterDiscussionKey:
.cfi_startproc
ret
.cfi_endproc
.p2align	2
LFQH_ChapterCardBackingKey:
.cfi_startproc
ret
.cfi_endproc
.p2align	2
LFQH_ChapterCardRoundedKey:
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
LFQH_Lloh6298:
adr x1, LFQH_l_.str.20
LFQH_Lloh6299:
nop
bl	LFQH_Get
mov	x21, x0
LFQH_Lloh6300:
adr x1, LFQH_l_.str.747
LFQH_Lloh6301:
nop
mov	x0, x19
bl	LFQH_Get
mov	x20, x0
LFQH_Lloh6302:
adr x1, LFQH_l_.str.223
LFQH_Lloh6303:
nop
mov	x0, x21
bl	LFQH_Kind
cbnz	w0, LFQH_LBB356_2
LFQH_Lloh6304:
adr x1, LFQH_l_.str.748
LFQH_Lloh6305:
nop
mov	x0, x21
bl	LFQH_Kind
cbz	w0, LFQH_LBB356_4
LFQH_LBB356_2:
LFQH_Lloh6306:
adr x1, LFQH_l_.str.20
LFQH_Lloh6307:
nop
mov	x0, x20
bl	LFQH_Get
cmp	x0, x19
b.ne	LFQH_LBB356_4
LFQH_Lloh6308:
adr x0, LFQH_l_.str.71
LFQH_Lloh6309:
nop
bl Lpatch + (0xa5a4 - PATCH_BASE)
mov	x1, x0
mov	x0, x19
bl Lpatch + (0xa5d4 - PATCH_BASE)
cbz	w0, LFQH_LBB356_9
LFQH_LBB356_4:
LFQH_Lloh6310:
adr x1, LFQH_SurfaceKey
LFQH_Lloh6311:
nop
mov	x0, x20
bl Lpatch + (0xa628 - PATCH_BASE)
cbz	x0, LFQH_LBB356_6
mov	x0, x20
bl	LFQH_PageRestore
LFQH_LBB356_6:
LFQH_Lloh6312:
adr x1, LFQH_SurfaceKey
LFQH_Lloh6313:
nop
mov	x0, x20
bl Lpatch + (0xa628 - PATCH_BASE)
cbz	x0, LFQH_LBB356_8
LFQH_Lloh6314:
adr x0, LFQH_l_.str.391
LFQH_Lloh6315:
nop
bl Lpatch + (0xa5a4 - PATCH_BASE)
mov	x1, x0
mov	x0, x19
bl Lpatch + (0xa5d4 - PATCH_BASE)
mov	x20, x0
LFQH_Lloh6316:
adr x0, LFQH_l_.str.392
LFQH_Lloh6317:
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
LFQH_LBB356_8:
mov	x0, x19
ldp	x29, x30, [sp, #32]
ldp	x20, x19, [sp, #16]
ldp	x22, x21, [sp], #48
b	LFQH_RestoreOwner
LFQH_LBB356_9:
mov	x0, x20
bl	LFQH_FQHApply
b	LFQH_LBB356_6
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
LFQH_Lloh6318:
adr x1, LFQH_l_.str.246
LFQH_Lloh6319:
nop
bl	LFQH_HasAncestor
cbz	w0, LFQH_LBB357_3
LFQH_Lloh6320:
adr x1, LFQH_l_.str.109
LFQH_Lloh6321:
nop
mov	x0, x19
bl	LFQH_HasAncestor
cbz	w0, LFQH_LBB357_3
LFQH_Lloh6322:
adr x0, LFQH_l_.str.24
LFQH_Lloh6323:
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
LFQH_Lloh6324:
adr x1, LFQH_SurfaceKey
LFQH_Lloh6325:
nop
mov	x0, x19
bl Lpatch + (0xa628 - PATCH_BASE)
mov	x20, x0
LFQH_Lloh6326:
adr x1, LFQH_l_.str.749
LFQH_Lloh6327:
nop
mov	x0, x19
bl	LFQH_BoolProp
mov	x1, x0
mov	x0, x20
mov	w2, #1
ldp	x29, x30, [sp, #16]
ldp	x20, x19, [sp], #32
b	LFQH_ShelfTint
LFQH_LBB357_3:
mov	x0, x19
ldp	x29, x30, [sp, #16]
ldp	x20, x19, [sp], #32
b	LFQH_PageRestore
.cfi_endproc
.p2align	2
LFQH_ShelfRememberFilterHeader:
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
LFQH_Lloh6328:
adr x1, LFQH_ShelfFilterHeadersKey
LFQH_Lloh6329:
nop
bl Lpatch + (0xa628 - PATCH_BASE)
cbz	x0, LFQH_LBB358_2
ldp	x29, x30, [sp, #16]
ldp	x20, x19, [sp], #32
ret
LFQH_LBB358_2:
bl	LFQH_ShelfFilterHeaders
mov	x20, x0
LFQH_Lloh6330:
adr x0, LFQH_l_.str.84
LFQH_Lloh6331:
nop
bl Lpatch + (0xa5a4 - PATCH_BASE)
mov	x1, x0
mov	x0, x20
mov	x2, x19
bl Lpatch + (0xa5d4 - PATCH_BASE)
LFQH_Lloh6332:
adr x1, LFQH_ShelfFilterHeadersKey
LFQH_Lloh6333:
nop
mov	x0, x19
mov	x2, x19
mov	x3, #0
ldp	x29, x30, [sp, #16]
ldp	x20, x19, [sp], #32
b Lpatch + (0xa634 - PATCH_BASE)
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
LFQH_Lloh6334:
adr x1, LFQH_l_.str.70
LFQH_Lloh6335:
nop
mov	x0, x23
bl	LFQH_Kind
fmov	d8, xzr
cmp	w0, #0
ccmp	x23, #0, #4, ne
b.ne	LFQH_LBB359_19
LFQH_LBB359_1:
mov	x21, #0
LFQH_LBB359_2:
fmov	d10, xzr
fmov	d9, xzr
fmov	d11, xzr
LFQH_LBB359_3:
fmov	x8, d11
and	x10, x8, #0x7fffffffffffffff
fmov	x8, d9
and	x8, x8, #0x7fffffffffffffff
mov	x11, #9218868437227405311
cmp	x8, x11
cset	w8, gt
fmov	x9, d10
and	x9, x9, #0x7fffffffffffffff
cmp	x9, x11
cset	w9, gt
cmp	x10, x11
b.gt	LFQH_LBB359_17
tbnz	w8, #0, LFQH_LBB359_17
tbnz	w9, #0, LFQH_LBB359_17
fmov	x8, d8
and	x8, x8, #0x7fffffffffffffff
mov	x9, #9218868437227405311
cmp	x8, x9
b.gt	LFQH_LBB359_17
fcmp	d10, #0.0
b.le	LFQH_LBB359_17
fcmp	d8, #0.0
b.le	LFQH_LBB359_17
cbnz	x20, LFQH_LBB359_12
bl	LFQH_NewGlassSurface
cbz	x0, LFQH_LBB359_27
mov	x20, x0
mov	x0, x19
mov	x1, x22
mov	x2, x20
mov	w3, #1
bl Lpatch + (0xa634 - PATCH_BASE)
LFQH_Lloh6336:
adr x0, LFQH_l_.str.56
LFQH_Lloh6337:
nop
bl Lpatch + (0xa5a4 - PATCH_BASE)
mov	x1, x0
mov	x0, x20
bl Lpatch + (0xa5d4 - PATCH_BASE)
LFQH_LBB359_12:
mov	x8, #-4593108669964484608
fmov	d0, x8
fadd	d1, d10, d0
fmov	d2, #0.50000000
fmul	d1, d1, d2
fadd	d10, d11, d1
fadd	d0, d8, d0
fmul	d0, d0, d2
fadd	d8, d9, d0
LFQH_Lloh6338:
adr x0, LFQH_l_.str.372
LFQH_Lloh6339:
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
b.eq	LFQH_LBB359_14
LFQH_Lloh6340:
adr x0, LFQH_l_.str.156
LFQH_Lloh6341:
nop
bl Lpatch + (0xa5a4 - PATCH_BASE)
mov	x1, x0
mov	x8, #4630263366890291200
fmov	d2, x8
mov	x0, x20
fmov	d0, d10
fmov	d1, d8
fmov	d3, d2
bl Lpatch + (0xa5d4 - PATCH_BASE)
LFQH_LBB359_14:
LFQH_Lloh6342:
adr x1, LFQH_l_.str.20
LFQH_Lloh6343:
nop
mov	x0, x20
bl	LFQH_Get
cmp	x0, x19
b.ne	LFQH_LBB359_16
LFQH_Lloh6344:
adr x1, LFQH_ProfileAnchorKey
LFQH_Lloh6345:
nop
mov	x0, x20
bl Lpatch + (0xa628 - PATCH_BASE)
cmp	x0, x21
b.eq	LFQH_LBB359_27
LFQH_LBB359_16:
LFQH_Lloh6346:
adr x0, LFQH_l_.str.426
LFQH_Lloh6347:
nop
bl Lpatch + (0xa5a4 - PATCH_BASE)
mov	x1, x0
mov	x0, x19
mov	x2, x20
mov	x3, x21
bl Lpatch + (0xa5d4 - PATCH_BASE)
LFQH_Lloh6348:
adr x1, LFQH_ProfileAnchorKey
LFQH_Lloh6349:
nop
mov	x0, x20
mov	x2, x21
b	LFQH_LBB359_18
LFQH_LBB359_17:
LFQH_Lloh6350:
adr x0, LFQH_l_.str.431
LFQH_Lloh6351:
nop
bl Lpatch + (0xa5a4 - PATCH_BASE)
mov	x1, x0
mov	x0, x20
bl Lpatch + (0xa5d4 - PATCH_BASE)
mov	x0, x19
mov	x1, x22
mov	x2, #0
LFQH_LBB359_18:
mov	w3, #1
ldp	x29, x30, [sp, #96]
ldp	x20, x19, [sp, #80]
ldp	x22, x21, [sp, #64]
ldp	x24, x23, [sp, #48]
ldp	x26, x25, [sp, #32]
ldp	d9, d8, [sp, #16]
ldp	d11, d10, [sp], #112
b Lpatch + (0xa634 - PATCH_BASE)
LFQH_LBB359_19:
mov	w26, #0
LFQH_Lloh6352:
adr x24, LFQH_l_.str.71
LFQH_Lloh6353:
nop
mov	x21, x23
LFQH_Lloh6354:
adr x25, LFQH_l_.str.20
LFQH_Lloh6355:
nop
LFQH_LBB359_20:
mov	x0, x24
bl Lpatch + (0xa5a4 - PATCH_BASE)
mov	x1, x0
mov	x0, x21
bl Lpatch + (0xa5d4 - PATCH_BASE)
cbnz	w0, LFQH_LBB359_1
mov	x0, x21
mov	x1, x25
bl	LFQH_Get
cmp	x0, x19
b.eq	LFQH_LBB359_25
cbz	x0, LFQH_LBB359_24
add	w8, w26, #1
mov	x21, x0
cmp	w26, #2
mov	x26, x8
b.ls	LFQH_LBB359_20
LFQH_LBB359_24:
mov	x21, x0
cbz	x0, LFQH_LBB359_2
LFQH_LBB359_25:
LFQH_Lloh6356:
adr x1, LFQH_l_.str.20
LFQH_Lloh6357:
nop
mov	x0, x21
bl	LFQH_Get
cmp	x0, x19
b.ne	LFQH_LBB359_2
LFQH_Lloh6358:
adr x0, LFQH_l_.str.24
LFQH_Lloh6359:
nop
bl Lpatch + (0xa5a4 - PATCH_BASE)
mov	x1, x0
mov	x0, x23
bl Lpatch + (0xa5d4 - PATCH_BASE)
fmov	d8, d0
fmov	d9, d1
fmov	d10, d2
fmov	d11, d3
LFQH_Lloh6360:
adr x0, LFQH_l_.str.507
LFQH_Lloh6361:
nop
bl Lpatch + (0xa5a4 - PATCH_BASE)
mov	x1, x0
mov	x0, x23
fmov	d0, d8
fmov	d1, d9
fmov	d2, d10
fmov	d3, d11
mov	x2, x19
bl Lpatch + (0xa5d4 - PATCH_BASE)
fmov	d11, d0
fmov	d9, d1
fmov	d10, d2
fmov	d8, d3
b	LFQH_LBB359_3
LFQH_LBB359_27:
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
LFQH_PublishGlass:
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
LFQH_Lloh6362:
adr x1, LFQH_PublishOwnerKey
LFQH_Lloh6363:
nop
bl Lpatch + (0xa628 - PATCH_BASE)
cbz	x0, LFQH_LBB364_9
LFQH_Lloh6364:
adr x1, LFQH_l_.str.256
LFQH_Lloh6365:
nop
mov	x0, x19
bl	LFQH_Kind
mov	x22, x0
mov	x20, x19
cbz	w0, LFQH_LBB364_3
LFQH_Lloh6366:
adr x1, LFQH_l_.str.755
LFQH_Lloh6367:
nop
mov	x0, x19
bl	LFQH_Get
mov	x20, x0
LFQH_LBB364_3:
LFQH_Lloh6368:
adr x1, LFQH_l_.str.23
LFQH_Lloh6369:
nop
mov	x0, x20
bl	LFQH_Kind
cbz	w0, LFQH_LBB364_9
cbz	x20, LFQH_LBB364_9
mov	w23, #0
LFQH_Lloh6370:
adr x21, LFQH_l_.str.20
LFQH_Lloh6371:
nop
mov	x0, x20
LFQH_LBB364_6:
cmp	x0, x19
b.eq	LFQH_LBB364_10
mov	x1, x21
bl	LFQH_Get
cbz	x0, LFQH_LBB364_9
add	w8, w23, #1
cmp	w23, #7
mov	x23, x8
b.lo	LFQH_LBB364_6
LFQH_LBB364_9:
ldp	x29, x30, [sp, #48]
ldp	x20, x19, [sp, #32]
ldp	x22, x21, [sp, #16]
ldp	x24, x23, [sp], #64
ret
LFQH_LBB364_10:
mov	x0, x20
bl	LFQH_FQHApply
LFQH_Lloh6372:
adr x1, LFQH_SurfaceKey
LFQH_Lloh6373:
nop
mov	x0, x20
bl Lpatch + (0xa628 - PATCH_BASE)
cmp	x0, #0
cset	w21, ne
cbz	w22, LFQH_LBB364_12
LFQH_Lloh6374:
adr x1, LFQH_l_.str.756
LFQH_Lloh6375:
nop
mov	x0, x19
bl	LFQH_Get
mov	x1, x21
bl	LFQH_PublishGradient
LFQH_Lloh6376:
adr x22, LFQH_l_.str.758
LFQH_Lloh6377:
nop
LFQH_Lloh6378:
adr x1, LFQH_l_.str.757
LFQH_Lloh6379:
nop
b	LFQH_LBB364_18
LFQH_LBB364_12:
LFQH_Lloh6380:
adr x1, LFQH_l_.str.759
LFQH_Lloh6381:
nop
mov	x0, x19
bl	LFQH_Get
mov	x1, x21
bl	LFQH_PublishGradient
LFQH_Lloh6382:
adr x1, LFQH_l_.str.742
LFQH_Lloh6383:
nop
mov	x0, x19
bl	LFQH_Get
LFQH_Lloh6384:
adr x1, LFQH_l_.str.760
LFQH_Lloh6385:
nop
bl	LFQH_BoolProp
cbz	w0, LFQH_LBB364_15
LFQH_Lloh6386:
adr x1, LFQH_l_.str.761
LFQH_Lloh6387:
nop
mov	x0, x19
bl	LFQH_Get
mov	x22, x0
LFQH_Lloh6388:
adr x1, LFQH_l_.str.20
LFQH_Lloh6389:
nop
bl	LFQH_Get
cmp	x0, x20
b.ne	LFQH_LBB364_15
mov	x0, x22
mov	x1, x21
bl	LFQH_PublishBacking
LFQH_LBB364_15:
LFQH_Lloh6390:
adr x1, LFQH_l_.str.762
LFQH_Lloh6391:
nop
mov	x0, x19
bl	LFQH_Get
mov	x22, x0
LFQH_Lloh6392:
adr x1, LFQH_l_.str.20
LFQH_Lloh6393:
nop
bl	LFQH_Get
cmp	x0, x20
b.ne	LFQH_LBB364_17
mov	x0, x22
mov	x1, x21
bl	LFQH_PublishBacking
LFQH_LBB364_17:
LFQH_Lloh6394:
adr x22, LFQH_l_.str.764
LFQH_Lloh6395:
nop
LFQH_Lloh6396:
adr x1, LFQH_l_.str.763
LFQH_Lloh6397:
nop
LFQH_LBB364_18:
mov	x0, x19
bl	LFQH_Get
mov	x1, x20
mov	x2, x21
bl	LFQH_PublishForeground
mov	x0, x19
mov	x1, x22
bl	LFQH_Get
mov	x1, x20
mov	x2, x21
ldp	x29, x30, [sp, #48]
ldp	x20, x19, [sp, #32]
ldp	x22, x21, [sp, #16]
ldp	x24, x23, [sp], #64
b	LFQH_PublishForeground
.cfi_endproc
.p2align	2
LFQH_PublishOwnerKey:
.cfi_startproc
ret
.cfi_endproc
.p2align	2
LFQH_PublishGradient:
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
LFQH_Lloh6398:
adr x1, LFQH_l_.str.765
LFQH_Lloh6399:
nop
bl	LFQH_Kind
cbz	w0, LFQH_LBB366_9
LFQH_Lloh6400:
adr x1, LFQH_l_.str.766
LFQH_Lloh6401:
nop
mov	x0, x19
bl	LFQH_Get
mov	x21, x0
LFQH_Lloh6402:
adr x1, LFQH_PublishBackingKey
LFQH_Lloh6403:
nop
mov	x0, x19
bl Lpatch + (0xa628 - PATCH_BASE)
mov	x22, x0
cbz	w20, LFQH_LBB366_4
cbz	x21, LFQH_LBB366_4
LFQH_Lloh6404:
adr x1, LFQH_PublishBackingKey
LFQH_Lloh6405:
nop
mov	x0, x19
mov	x2, x21
mov	w3, #1
bl Lpatch + (0xa634 - PATCH_BASE)
LFQH_Lloh6406:
adr x0, LFQH_l_.str.767
LFQH_Lloh6407:
nop
bl Lpatch + (0xa5a4 - PATCH_BASE)
mov	x1, x0
mov	x0, x19
mov	x2, #0
ldp	x29, x30, [sp, #32]
ldp	x20, x19, [sp, #16]
ldp	x22, x21, [sp], #48
b Lpatch + (0xa5d4 - PATCH_BASE)
LFQH_LBB366_4:
cbnz	w20, LFQH_LBB366_9
cbz	x22, LFQH_LBB366_9
cbnz	x21, LFQH_LBB366_8
LFQH_Lloh6408:
adr x0, LFQH_l_.str.767
LFQH_Lloh6409:
nop
bl Lpatch + (0xa5a4 - PATCH_BASE)
mov	x1, x0
mov	x0, x19
mov	x2, x22
bl Lpatch + (0xa5d4 - PATCH_BASE)
LFQH_LBB366_8:
LFQH_Lloh6410:
adr x1, LFQH_PublishBackingKey
LFQH_Lloh6411:
nop
mov	x0, x19
mov	x2, #0
mov	w3, #1
ldp	x29, x30, [sp, #32]
ldp	x20, x19, [sp, #16]
ldp	x22, x21, [sp], #48
b Lpatch + (0xa634 - PATCH_BASE)
LFQH_LBB366_9:
ldp	x29, x30, [sp, #32]
ldp	x20, x19, [sp, #16]
ldp	x22, x21, [sp], #48
ret
.cfi_endproc
.p2align	2
LFQH_PublishForeground:
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
cbz	x0, LFQH_LBB367_16
mov	x21, x2
mov	x20, x1
mov	x19, x0
mov	w23, #0
LFQH_Lloh6412:
adr x22, LFQH_l_.str.20
LFQH_Lloh6413:
nop
LFQH_LBB367_2:
cmp	x0, x20
b.eq	LFQH_LBB367_5
mov	x1, x22
bl	LFQH_Get
cbz	x0, LFQH_LBB367_16
add	w8, w23, #1
cmp	w23, #7
mov	x23, x8
b.lo	LFQH_LBB367_2
b	LFQH_LBB367_16
LFQH_LBB367_5:
LFQH_Lloh6414:
adr x0, LFQH_l_.str.389
LFQH_Lloh6415:
nop
bl Lpatch + (0xa5a4 - PATCH_BASE)
mov	x20, x0
LFQH_Lloh6416:
adr x0, LFQH_l_.str.36
LFQH_Lloh6417:
nop
bl Lpatch + (0xa5b0 - PATCH_BASE)
mov	x2, x0
mov	x0, x19
mov	x1, x20
bl Lpatch + (0xa5d4 - PATCH_BASE)
LFQH_Lloh6418:
adr x8, LFQH_l_.str.45
LFQH_Lloh6419:
nop
LFQH_Lloh6420:
adr x9, LFQH_l_.str.54
LFQH_Lloh6421:
nop
cmp	w0, #0
csel	x20, x9, x8, eq
LFQH_Lloh6422:
adr x8, LFQH_l_.str.46
LFQH_Lloh6423:
nop
LFQH_Lloh6424:
adr x9, LFQH_l_.str.141
LFQH_Lloh6425:
nop
csel	x1, x9, x8, eq
mov	x0, x19
bl	LFQH_Get
mov	x22, x0
LFQH_Lloh6426:
adr x0, LFQH_l_.str.47
LFQH_Lloh6427:
nop
bl Lpatch + (0xa5b0 - PATCH_BASE)
mov	x23, x0
LFQH_Lloh6428:
adr x0, LFQH_l_.str.48
LFQH_Lloh6429:
nop
bl Lpatch + (0xa5a4 - PATCH_BASE)
mov	x1, x0
mov	x0, x23
bl Lpatch + (0xa5d4 - PATCH_BASE)
mov	x23, x0
LFQH_Lloh6430:
adr x1, LFQH_PublishColorKey
LFQH_Lloh6431:
nop
mov	x0, x19
bl Lpatch + (0xa628 - PATCH_BASE)
mov	x24, x0
cbz	w21, LFQH_LBB367_10
cbz	x22, LFQH_LBB367_10
cmp	x22, x23
b.eq	LFQH_LBB367_16
LFQH_Lloh6432:
adr x0, LFQH_l_.str.49
LFQH_Lloh6433:
nop
bl Lpatch + (0xa5a4 - PATCH_BASE)
mov	x1, x0
mov	x0, x22
mov	x2, x23
bl Lpatch + (0xa5d4 - PATCH_BASE)
cbnz	w0, LFQH_LBB367_16
LFQH_Lloh6434:
adr x1, LFQH_PublishColorKey
LFQH_Lloh6435:
nop
mov	x0, x19
mov	x2, x22
mov	w3, #1
bl Lpatch + (0xa634 - PATCH_BASE)
mov	x0, x20
bl Lpatch + (0xa5a4 - PATCH_BASE)
mov	x1, x0
mov	x0, x19
mov	x2, x23
ldp	x29, x30, [sp, #48]
ldp	x20, x19, [sp, #32]
ldp	x22, x21, [sp, #16]
ldp	x24, x23, [sp], #64
b Lpatch + (0xa5d4 - PATCH_BASE)
LFQH_LBB367_10:
cbnz	w21, LFQH_LBB367_16
cbz	x24, LFQH_LBB367_16
cmp	x22, x23
b.eq	LFQH_LBB367_14
LFQH_Lloh6436:
adr x0, LFQH_l_.str.49
LFQH_Lloh6437:
nop
bl Lpatch + (0xa5a4 - PATCH_BASE)
mov	x1, x0
mov	x0, x22
mov	x2, x23
bl Lpatch + (0xa5d4 - PATCH_BASE)
cbz	w0, LFQH_LBB367_15
LFQH_LBB367_14:
mov	x0, x20
bl Lpatch + (0xa5a4 - PATCH_BASE)
mov	x1, x0
mov	x0, x19
mov	x2, x24
bl Lpatch + (0xa5d4 - PATCH_BASE)
LFQH_LBB367_15:
LFQH_Lloh6438:
adr x1, LFQH_PublishColorKey
LFQH_Lloh6439:
nop
mov	x0, x19
mov	x2, #0
mov	w3, #1
ldp	x29, x30, [sp, #48]
ldp	x20, x19, [sp, #32]
ldp	x22, x21, [sp, #16]
ldp	x24, x23, [sp], #64
b Lpatch + (0xa634 - PATCH_BASE)
LFQH_LBB367_16:
ldp	x29, x30, [sp, #48]
ldp	x20, x19, [sp, #32]
ldp	x22, x21, [sp, #16]
ldp	x24, x23, [sp], #64
ret
.cfi_endproc
.p2align	2
LFQH_PublishBacking:
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
cbz	x0, LFQH_LBB368_11
mov	x20, x1
mov	x19, x0
LFQH_Lloh6440:
adr x1, LFQH_PublishBackingKey
LFQH_Lloh6441:
nop
bl Lpatch + (0xa628 - PATCH_BASE)
mov	x21, x0
LFQH_Lloh6442:
adr x0, LFQH_l_.str.71
LFQH_Lloh6443:
nop
bl Lpatch + (0xa5a4 - PATCH_BASE)
mov	x1, x0
mov	x0, x19
bl Lpatch + (0xa5d4 - PATCH_BASE)
cbz	w20, LFQH_LBB368_6
cbnz	w0, LFQH_LBB368_6
cbnz	x21, LFQH_LBB368_5
LFQH_Lloh6444:
adr x0, LFQH_l_.str.497
LFQH_Lloh6445:
nop
bl Lpatch + (0xa5b0 - PATCH_BASE)
mov	x20, x0
LFQH_Lloh6446:
adr x0, LFQH_l_.str.499
LFQH_Lloh6447:
nop
bl Lpatch + (0xa5a4 - PATCH_BASE)
mov	x1, x0
mov	x0, x20
mov	w2, #1
bl Lpatch + (0xa5d4 - PATCH_BASE)
mov	x2, x0
LFQH_Lloh6448:
adr x1, LFQH_PublishBackingKey
LFQH_Lloh6449:
nop
mov	x0, x19
mov	w3, #1
bl Lpatch + (0xa634 - PATCH_BASE)
LFQH_LBB368_5:
LFQH_Lloh6450:
adr x0, LFQH_l_.str.72
LFQH_Lloh6451:
nop
bl Lpatch + (0xa5a4 - PATCH_BASE)
mov	x1, x0
mov	x0, x19
mov	w2, #1
ldp	x29, x30, [sp, #32]
ldp	x20, x19, [sp, #16]
ldp	x22, x21, [sp], #48
b Lpatch + (0xa5d4 - PATCH_BASE)
LFQH_LBB368_6:
cbnz	w20, LFQH_LBB368_11
cbz	x21, LFQH_LBB368_11
cbz	w0, LFQH_LBB368_10
LFQH_Lloh6452:
adr x0, LFQH_l_.str.72
LFQH_Lloh6453:
nop
bl Lpatch + (0xa5a4 - PATCH_BASE)
mov	x1, x0
mov	x0, x19
mov	w2, #0
bl Lpatch + (0xa5d4 - PATCH_BASE)
LFQH_LBB368_10:
LFQH_Lloh6454:
adr x1, LFQH_PublishBackingKey
LFQH_Lloh6455:
nop
mov	x0, x19
mov	x2, #0
mov	w3, #1
ldp	x29, x30, [sp, #32]
ldp	x20, x19, [sp, #16]
ldp	x22, x21, [sp], #48
b Lpatch + (0xa634 - PATCH_BASE)
LFQH_LBB368_11:
ldp	x29, x30, [sp, #32]
ldp	x20, x19, [sp, #16]
ldp	x22, x21, [sp], #48
ret
.cfi_endproc
.p2align	2
LFQH_PublishBackingKey:
.cfi_startproc
ret
.cfi_endproc
.p2align	2
LFQH_PublishColorKey:
.cfi_startproc
ret
.cfi_endproc
.p2align	2
LFQH_PublishMark:
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
LFQH_Lloh6456:
adr x1, LFQH_l_.str.252
LFQH_Lloh6457:
nop
bl	LFQH_Kind
cbnz	w0, LFQH_LBB371_2
LFQH_Lloh6458:
adr x1, LFQH_l_.str.256
LFQH_Lloh6459:
nop
mov	x0, x19
bl	LFQH_Kind
cbz	w0, LFQH_LBB371_5
LFQH_LBB371_2:
LFQH_Lloh6460:
adr x1, LFQH_PublishOwnerKey
LFQH_Lloh6461:
nop
mov	x0, x19
bl Lpatch + (0xa628 - PATCH_BASE)
cbnz	x0, LFQH_LBB371_4
LFQH_Lloh6462:
adr x0, LFQH_l_.str.497
LFQH_Lloh6463:
nop
bl Lpatch + (0xa5b0 - PATCH_BASE)
mov	x20, x0
LFQH_Lloh6464:
adr x0, LFQH_l_.str.499
LFQH_Lloh6465:
nop
bl Lpatch + (0xa5a4 - PATCH_BASE)
mov	x1, x0
mov	x0, x20
mov	w2, #1
bl Lpatch + (0xa5d4 - PATCH_BASE)
mov	x2, x0
LFQH_Lloh6466:
adr x1, LFQH_PublishOwnerKey
LFQH_Lloh6467:
nop
mov	x0, x19
mov	w3, #1
bl Lpatch + (0xa634 - PATCH_BASE)
LFQH_LBB371_4:
mov	x0, x19
ldp	x29, x30, [sp, #16]
ldp	x20, x19, [sp], #32
b	LFQH_PublishGlass
LFQH_LBB371_5:
ldp	x29, x30, [sp, #16]
ldp	x20, x19, [sp], #32
ret
.cfi_endproc
.p2align	2
LFQH_TopChromePage:
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
mov	x23, x3
fmov	d8, d3
fmov	d9, d2
fmov	d10, d1
fmov	d11, d0
mov	x20, x2
mov	x22, x1
mov	x19, x0
LFQH_Lloh6468:
adr x1, LFQH_TopChromeOwnerKey
LFQH_Lloh6469:
nop
bl Lpatch + (0xa628 - PATCH_BASE)
mov	x21, x0
cbz	w23, LFQH_LBB372_19
LFQH_Lloh6470:
adr x1, LFQH_l_.str.774
LFQH_Lloh6471:
nop
mov	x0, x20
bl	LFQH_Kind
mov	x24, x0
LFQH_Lloh6472:
adr x1, LFQH_TopChromeSurfaceKey
LFQH_Lloh6473:
nop
mov	x0, x19
bl Lpatch + (0xa628 - PATCH_BASE)
mov	x23, x0
cbz	x19, LFQH_LBB372_20
cbz	w24, LFQH_LBB372_20
LFQH_Lloh6474:
adr x1, LFQH_l_.str.20
LFQH_Lloh6475:
nop
mov	x0, x22
bl	LFQH_Get
cmp	x0, x19
b.ne	LFQH_LBB372_20
fmov	x9, d9
fmov	x8, d10
fmov	x10, d11
and	x10, x10, #0x7fffffffffffffff
and	x8, x8, #0x7fffffffffffffff
mov	x11, #9218868437227405311
cmp	x8, x11
cset	w8, gt
and	x9, x9, #0x7fffffffffffffff
cmp	x9, x11
cset	w9, gt
cmp	x10, x11
b.gt	LFQH_LBB372_20
tbnz	w8, #0, LFQH_LBB372_20
tbnz	w9, #0, LFQH_LBB372_20
fmov	x8, d8
and	x8, x8, #0x7fffffffffffffff
mov	x9, #9218868437227405311
cmp	x8, x9
b.gt	LFQH_LBB372_20
fcmp	d9, #0.0
b.le	LFQH_LBB372_20
fcmp	d8, #0.0
b.le	LFQH_LBB372_20
cbz	x23, LFQH_LBB372_33
LFQH_LBB372_11:
LFQH_Lloh6476:
adr x0, LFQH_l_.str.372
LFQH_Lloh6477:
nop
bl Lpatch + (0xa5a4 - PATCH_BASE)
mov	x1, x0
mov	x0, x23
bl Lpatch + (0xa5d4 - PATCH_BASE)
fcmp	d0, d11
b.ne	LFQH_LBB372_15
fcmp	d1, d10
b.ne	LFQH_LBB372_15
fcmp	d2, d9
b.ne	LFQH_LBB372_15
fcmp	d3, d8
b.eq	LFQH_LBB372_16
LFQH_LBB372_15:
LFQH_Lloh6478:
adr x0, LFQH_l_.str.156
LFQH_Lloh6479:
nop
bl Lpatch + (0xa5a4 - PATCH_BASE)
mov	x1, x0
mov	x0, x23
fmov	d0, d11
fmov	d1, d10
fmov	d2, d9
fmov	d3, d8
bl Lpatch + (0xa5d4 - PATCH_BASE)
LFQH_LBB372_16:
LFQH_Lloh6480:
adr x1, LFQH_l_.str.20
LFQH_Lloh6481:
nop
mov	x0, x23
bl	LFQH_Get
cmp	x0, x19
b.ne	LFQH_LBB372_18
LFQH_Lloh6482:
adr x1, LFQH_TopChromeAnchorKey
LFQH_Lloh6483:
nop
mov	x0, x23
bl Lpatch + (0xa628 - PATCH_BASE)
cmp	x0, x22
b.eq	LFQH_LBB372_37
LFQH_LBB372_18:
LFQH_Lloh6484:
adr x0, LFQH_l_.str.426
LFQH_Lloh6485:
nop
bl Lpatch + (0xa5a4 - PATCH_BASE)
mov	x1, x0
mov	x0, x19
mov	x2, x23
mov	x3, x22
bl Lpatch + (0xa5d4 - PATCH_BASE)
LFQH_Lloh6486:
adr x1, LFQH_TopChromeAnchorKey
LFQH_Lloh6487:
nop
mov	w24, #1
mov	x0, x23
mov	x2, x22
mov	w3, #1
bl Lpatch + (0xa634 - PATCH_BASE)
mov	w25, #0
b	LFQH_LBB372_21
LFQH_LBB372_19:
LFQH_Lloh6488:
adr x1, LFQH_TopChromeSurfaceKey
LFQH_Lloh6489:
nop
mov	x0, x19
bl Lpatch + (0xa628 - PATCH_BASE)
mov	x23, x0
LFQH_LBB372_20:
LFQH_Lloh6490:
adr x0, LFQH_l_.str.431
LFQH_Lloh6491:
nop
bl Lpatch + (0xa5a4 - PATCH_BASE)
mov	x1, x0
mov	x0, x23
bl Lpatch + (0xa5d4 - PATCH_BASE)
LFQH_Lloh6492:
adr x1, LFQH_TopChromeAnchorKey
LFQH_Lloh6493:
nop
mov	w25, #1
mov	x0, x23
mov	x2, #0
mov	w3, #1
bl Lpatch + (0xa634 - PATCH_BASE)
LFQH_Lloh6494:
adr x1, LFQH_TopChromeSurfaceKey
LFQH_Lloh6495:
nop
mov	x0, x19
mov	x2, #0
mov	w3, #1
bl Lpatch + (0xa634 - PATCH_BASE)
mov	w24, #0
mov	x22, #0
LFQH_LBB372_21:
cmp	x21, x22
b.eq	LFQH_LBB372_23
mov	x0, x21
mov	w1, #0
bl	LFQH_TopChromeFill
LFQH_Lloh6496:
adr x1, LFQH_TopChromeOwnerKey
LFQH_Lloh6497:
nop
mov	x0, x19
mov	x2, x22
mov	w3, #1
bl Lpatch + (0xa634 - PATCH_BASE)
LFQH_LBB372_23:
tbz	w25, #0, LFQH_LBB372_25
mov	x20, #0
b	LFQH_LBB372_26
LFQH_LBB372_25:
LFQH_Lloh6498:
adr x1, LFQH_l_.str.775
LFQH_Lloh6499:
nop
mov	x0, x20
bl	LFQH_Get
mov	x20, x0
LFQH_LBB372_26:
LFQH_Lloh6500:
adr x1, LFQH_TopChromeEdgeHiddenKey
LFQH_Lloh6501:
nop
mov	x0, x19
bl Lpatch + (0xa628 - PATCH_BASE)
cbz	x0, LFQH_LBB372_29
mov	x21, x0
cmp	x0, x20
b.eq	LFQH_LBB372_29
LFQH_Lloh6502:
adr x0, LFQH_l_.str.72
LFQH_Lloh6503:
nop
bl Lpatch + (0xa5a4 - PATCH_BASE)
mov	x1, x0
mov	x0, x21
mov	w2, #0
bl Lpatch + (0xa5d4 - PATCH_BASE)
LFQH_Lloh6504:
adr x1, LFQH_TopChromeEdgeHiddenKey
LFQH_Lloh6505:
nop
mov	x0, x19
mov	x2, #0
mov	w3, #1
bl Lpatch + (0xa634 - PATCH_BASE)
LFQH_LBB372_29:
LFQH_Lloh6506:
adr x1, LFQH_l_.str.72
LFQH_Lloh6507:
nop
mov	x0, x20
bl	LFQH_Responds
cbz	w0, LFQH_LBB372_32
LFQH_Lloh6508:
adr x0, LFQH_l_.str.71
LFQH_Lloh6509:
nop
bl Lpatch + (0xa5a4 - PATCH_BASE)
mov	x1, x0
mov	x0, x20
bl Lpatch + (0xa5d4 - PATCH_BASE)
cbnz	w0, LFQH_LBB372_32
LFQH_Lloh6510:
adr x1, LFQH_TopChromeEdgeHiddenKey
LFQH_Lloh6511:
nop
mov	x0, x19
mov	x2, x20
mov	w3, #1
bl Lpatch + (0xa634 - PATCH_BASE)
LFQH_Lloh6512:
adr x0, LFQH_l_.str.72
LFQH_Lloh6513:
nop
bl Lpatch + (0xa5a4 - PATCH_BASE)
mov	x1, x0
mov	x0, x20
mov	w2, #1
bl Lpatch + (0xa5d4 - PATCH_BASE)
LFQH_LBB372_32:
mov	x0, x24
ldp	x29, x30, [sp, #96]
ldp	x20, x19, [sp, #80]
ldp	x22, x21, [sp, #64]
ldp	x24, x23, [sp, #48]
ldp	x26, x25, [sp, #32]
ldp	d9, d8, [sp, #16]
ldp	d11, d10, [sp], #112
ret
LFQH_LBB372_33:
LFQH_Lloh6514:
adr x0, LFQH_l_.str.776
LFQH_Lloh6515:
nop
bl Lpatch + (0xa5b0 - PATCH_BASE)
mov	x23, x0
LFQH_Lloh6516:
adr x0, LFQH_l_.str.13
LFQH_Lloh6517:
nop
bl Lpatch + (0xa5a4 - PATCH_BASE)
mov	x1, x0
mov	x0, x23
mov	w2, #6
bl Lpatch + (0xa5d4 - PATCH_BASE)
cbz	x0, LFQH_LBB372_36
mov	x23, x0
LFQH_Lloh6518:
adr x0, LFQH_l_.str.16
LFQH_Lloh6519:
nop
bl Lpatch + (0xa5b0 - PATCH_BASE)
mov	x24, x0
LFQH_Lloh6520:
adr x0, LFQH_l_.str.154
LFQH_Lloh6521:
nop
bl Lpatch + (0xa5a4 - PATCH_BASE)
mov	x1, x0
mov	x0, x24
bl Lpatch + (0xa5d4 - PATCH_BASE)
mov	x24, x0
LFQH_Lloh6522:
adr x0, LFQH_l_.str.398
LFQH_Lloh6523:
nop
bl Lpatch + (0xa5a4 - PATCH_BASE)
mov	x1, x0
mov	x0, x24
mov	x2, x23
bl Lpatch + (0xa5d4 - PATCH_BASE)
cbz	x0, LFQH_LBB372_36
mov	x23, x0
LFQH_Lloh6524:
adr x0, LFQH_l_.str.399
LFQH_Lloh6525:
nop
bl Lpatch + (0xa5a4 - PATCH_BASE)
mov	x1, x0
mov	x0, x23
mov	w2, #0
bl Lpatch + (0xa5d4 - PATCH_BASE)
LFQH_Lloh6526:
adr x0, LFQH_l_.str.400
LFQH_Lloh6527:
nop
bl Lpatch + (0xa5a4 - PATCH_BASE)
mov	x1, x0
mov	x0, x23
mov	w2, #1
bl Lpatch + (0xa5d4 - PATCH_BASE)
LFQH_Lloh6528:
adr x0, LFQH_l_.str.402
LFQH_Lloh6529:
nop
bl Lpatch + (0xa5a4 - PATCH_BASE)
mov	x1, x0
mov	x0, x23
mov	w2, #0
bl Lpatch + (0xa5d4 - PATCH_BASE)
LFQH_Lloh6530:
adr x0, LFQH_l_.str.47
LFQH_Lloh6531:
nop
bl Lpatch + (0xa5b0 - PATCH_BASE)
mov	x24, x0
LFQH_Lloh6532:
adr x0, LFQH_l_.str.777
LFQH_Lloh6533:
nop
bl Lpatch + (0xa5a4 - PATCH_BASE)
mov	x1, x0
mov	x0, x24
bl Lpatch + (0xa5d4 - PATCH_BASE)
mov	x24, x0
LFQH_Lloh6534:
adr x0, LFQH_l_.str.51
LFQH_Lloh6535:
nop
bl Lpatch + (0xa5a4 - PATCH_BASE)
mov	x1, x0
mov	x8, #4589168020290535424
fmov	d0, x8
mov	x0, x24
bl Lpatch + (0xa5d4 - PATCH_BASE)
mov	x24, x0
LFQH_Lloh6536:
adr x1, LFQH_l_.str.363
LFQH_Lloh6537:
nop
mov	x0, x23
bl	LFQH_Get
mov	x25, x0
LFQH_Lloh6538:
adr x0, LFQH_l_.str.157
LFQH_Lloh6539:
nop
bl Lpatch + (0xa5a4 - PATCH_BASE)
mov	x1, x0
mov	x0, x25
mov	x2, x24
bl Lpatch + (0xa5d4 - PATCH_BASE)
LFQH_Lloh6540:
adr x1, LFQH_TopChromeTintKey
LFQH_Lloh6541:
nop
mov	x0, x23
mov	x2, x24
mov	w3, #1
bl Lpatch + (0xa634 - PATCH_BASE)
LFQH_Lloh6542:
adr x1, LFQH_TopChromeSurfaceKey
LFQH_Lloh6543:
nop
mov	x0, x19
mov	x2, x23
mov	w3, #1
bl Lpatch + (0xa634 - PATCH_BASE)
LFQH_Lloh6544:
adr x0, LFQH_l_.str.56
LFQH_Lloh6545:
nop
bl Lpatch + (0xa5a4 - PATCH_BASE)
mov	x1, x0
mov	x0, x23
bl Lpatch + (0xa5d4 - PATCH_BASE)
b	LFQH_LBB372_11
LFQH_LBB372_36:
mov	w24, #0
mov	x22, #0
mov	w25, #1
b	LFQH_LBB372_21
LFQH_LBB372_37:
mov	w25, #0
mov	w24, #1
b	LFQH_LBB372_21
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
LFQH_Lloh6546:
adr x1, LFQH_l_.str.23
LFQH_Lloh6547:
nop
bl	LFQH_Kind
cbz	w0, LFQH_LBB373_15
LFQH_Lloh6548:
adr x0, LFQH_l_.str.47
LFQH_Lloh6549:
nop
bl Lpatch + (0xa5b0 - PATCH_BASE)
mov	x20, x0
LFQH_Lloh6550:
adr x0, LFQH_l_.str.158
LFQH_Lloh6551:
nop
bl Lpatch + (0xa5a4 - PATCH_BASE)
mov	x1, x0
mov	x0, x20
bl Lpatch + (0xa5d4 - PATCH_BASE)
mov	x20, x0
LFQH_Lloh6552:
adr x0, LFQH_l_.str.390
LFQH_Lloh6553:
nop
bl Lpatch + (0xa5a4 - PATCH_BASE)
mov	x1, x0
mov	x0, x19
bl Lpatch + (0xa5d4 - PATCH_BASE)
mov	x21, x0
LFQH_Lloh6554:
adr x1, LFQH_TopChromeColorKey
LFQH_Lloh6555:
nop
mov	x0, x19
bl Lpatch + (0xa628 - PATCH_BASE)
mov	x22, x0
LFQH_Lloh6556:
adr x1, LFQH_TopChromeOpaqueKey
LFQH_Lloh6557:
nop
mov	x0, x19
bl Lpatch + (0xa628 - PATCH_BASE)
cbz	w23, LFQH_LBB373_8
LFQH_Lloh6558:
adr x0, LFQH_l_.str.392
LFQH_Lloh6559:
nop
bl Lpatch + (0xa5a4 - PATCH_BASE)
mov	x1, x0
mov	x0, x19
bl Lpatch + (0xa5d4 - PATCH_BASE)
cbz	w0, LFQH_LBB373_4
LFQH_Lloh6560:
adr x0, LFQH_l_.str.497
LFQH_Lloh6561:
nop
bl Lpatch + (0xa5b0 - PATCH_BASE)
mov	x22, x0
LFQH_Lloh6562:
adr x0, LFQH_l_.str.499
LFQH_Lloh6563:
nop
bl Lpatch + (0xa5a4 - PATCH_BASE)
mov	x1, x0
mov	x0, x22
mov	w2, #1
bl Lpatch + (0xa5d4 - PATCH_BASE)
mov	x2, x0
LFQH_Lloh6564:
adr x1, LFQH_TopChromeOpaqueKey
LFQH_Lloh6565:
nop
mov	x0, x19
mov	w3, #1
bl Lpatch + (0xa634 - PATCH_BASE)
LFQH_Lloh6566:
adr x0, LFQH_l_.str.402
LFQH_Lloh6567:
nop
bl Lpatch + (0xa5a4 - PATCH_BASE)
mov	x1, x0
mov	x0, x19
mov	w2, #0
bl Lpatch + (0xa5d4 - PATCH_BASE)
LFQH_LBB373_4:
cbz	x21, LFQH_LBB373_15
cmp	x21, x20
b.eq	LFQH_LBB373_15
LFQH_Lloh6568:
adr x0, LFQH_l_.str.49
LFQH_Lloh6569:
nop
bl Lpatch + (0xa5a4 - PATCH_BASE)
mov	x1, x0
mov	x0, x21
mov	x2, x20
bl Lpatch + (0xa5d4 - PATCH_BASE)
cbnz	w0, LFQH_LBB373_15
LFQH_Lloh6570:
adr x1, LFQH_TopChromeColorKey
LFQH_Lloh6571:
nop
mov	x0, x19
mov	x2, x21
mov	w3, #1
bl Lpatch + (0xa634 - PATCH_BASE)
LFQH_Lloh6572:
adr x0, LFQH_l_.str.157
LFQH_Lloh6573:
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
LFQH_LBB373_8:
cbz	x0, LFQH_LBB373_10
LFQH_Lloh6574:
adr x0, LFQH_l_.str.402
LFQH_Lloh6575:
nop
bl Lpatch + (0xa5a4 - PATCH_BASE)
mov	x1, x0
mov	x0, x19
mov	w2, #1
bl Lpatch + (0xa5d4 - PATCH_BASE)
LFQH_Lloh6576:
adr x1, LFQH_TopChromeOpaqueKey
LFQH_Lloh6577:
nop
mov	x0, x19
mov	x2, #0
mov	w3, #1
bl Lpatch + (0xa634 - PATCH_BASE)
LFQH_LBB373_10:
cbz	x22, LFQH_LBB373_15
cmp	x21, x20
b.eq	LFQH_LBB373_13
LFQH_Lloh6578:
adr x0, LFQH_l_.str.49
LFQH_Lloh6579:
nop
bl Lpatch + (0xa5a4 - PATCH_BASE)
mov	x1, x0
mov	x0, x21
mov	x2, x20
bl Lpatch + (0xa5d4 - PATCH_BASE)
cbz	w0, LFQH_LBB373_14
LFQH_LBB373_13:
LFQH_Lloh6580:
adr x0, LFQH_l_.str.157
LFQH_Lloh6581:
nop
bl Lpatch + (0xa5a4 - PATCH_BASE)
mov	x1, x0
mov	x0, x19
mov	x2, x22
bl Lpatch + (0xa5d4 - PATCH_BASE)
LFQH_LBB373_14:
LFQH_Lloh6582:
adr x1, LFQH_TopChromeColorKey
LFQH_Lloh6583:
nop
mov	x0, x19
mov	x2, #0
mov	w3, #1
ldp	x29, x30, [sp, #48]
ldp	x20, x19, [sp, #32]
ldp	x22, x21, [sp, #16]
ldp	x24, x23, [sp], #64
b Lpatch + (0xa634 - PATCH_BASE)
LFQH_LBB373_15:
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
fmov	d11, d0
mov	x19, x1
mov	x20, x0
LFQH_Lloh6584:
adr x1, LFQH_l_.str.23
LFQH_Lloh6585:
nop
bl	LFQH_Kind
cbz	w0, LFQH_LBB374_29
LFQH_Lloh6586:
adr x0, LFQH_l_.str.372
LFQH_Lloh6587:
nop
bl Lpatch + (0xa5a4 - PATCH_BASE)
mov	x1, x0
mov	x0, x20
bl Lpatch + (0xa5d4 - PATCH_BASE)
fmov	d14, d0
mov	x0, x20
stp	d1, d3, [sp, #8]
str	d2, [sp, #24]
bl	LFQH_TopChromeStockFrame
fmov	d8, d0
fmov	d15, d1
fmov	d9, d2
fmov	d10, d3
LFQH_Lloh6588:
adr x1, LFQH_TopChromeFrameKey
LFQH_Lloh6589:
nop
mov	x0, x20
bl Lpatch + (0xa628 - PATCH_BASE)
mov	x21, x0
fmov	d13, xzr
cbz	w22, LFQH_LBB374_10
mov	x0, x20
mov	x1, x19
bl	LFQH_TopChromeContains
cbz	w0, LFQH_LBB374_10
fmov	x8, d8
and	x10, x8, #0x7fffffffffffffff
fmov	x8, d15
and	x8, x8, #0x7fffffffffffffff
mov	x11, #9218868437227405311
cmp	x8, x11
cset	w8, gt
fmov	x9, d9
and	x9, x9, #0x7fffffffffffffff
cmp	x9, x11
cset	w9, gt
cmp	x10, x11
b.gt	LFQH_LBB374_10
tbnz	w8, #0, LFQH_LBB374_10
tbnz	w9, #0, LFQH_LBB374_10
fmov	x8, d10
and	x8, x8, #0x7fffffffffffffff
mov	x9, #9218868437227405311
cmp	x8, x9
b.gt	LFQH_LBB374_10
fcmp	d9, #0.0
b.le	LFQH_LBB374_10
fcmp	d10, #0.0
b.le	LFQH_LBB374_10
fsub	d0, d15, d11
fmov	d1, xzr
fmaxnm	d13, d0, d1
LFQH_LBB374_10:
LFQH_Lloh6590:
adr x1, LFQH_TopChromeScrollKey
LFQH_Lloh6591:
nop
mov	x0, x20
bl Lpatch + (0xa628 - PATCH_BASE)
cmp	x0, #0
ccmp	x21, #0, #4, eq
csel	x22, x0, x20, eq
cbz	x22, LFQH_LBB374_14
cmp	x22, x19
b.ne	LFQH_LBB374_13
fcmp	d13, #0.0
b.ne	LFQH_LBB374_14
LFQH_LBB374_13:
fmov	d0, xzr
mov	x0, x22
bl	LFQH_TopChromeInsets
mov	x0, x22
bl	LFQH_TopChromeRefreshVisibility
LFQH_LBB374_14:
fsub	d12, d15, d13
fadd	d11, d10, d13
fcmp	d13, #0.0
b.le	LFQH_LBB374_21
cmp	x22, x19
b.eq	LFQH_LBB374_17
cmp	x19, x20
csel	x2, xzr, x19, eq
LFQH_Lloh6592:
adr x1, LFQH_TopChromeScrollKey
LFQH_Lloh6593:
nop
mov	x0, x20
mov	w3, #1
bl Lpatch + (0xa634 - PATCH_BASE)
LFQH_LBB374_17:
cbz	x21, LFQH_LBB374_20
LFQH_Lloh6594:
adr x0, LFQH_l_.str.432
LFQH_Lloh6595:
nop
bl Lpatch + (0xa5a4 - PATCH_BASE)
mov	x1, x0
mov	x0, x21
bl Lpatch + (0xa5d4 - PATCH_BASE)
fcmp	d0, d8
b.ne	LFQH_LBB374_20
fcmp	d1, d12
fccmp	d2, d9, #0, eq
fccmp	d3, d11, #0, eq
b.eq	LFQH_LBB374_24
LFQH_LBB374_20:
LFQH_Lloh6596:
adr x21, LFQH_l_.str.512
LFQH_Lloh6597:
nop
mov	x0, x21
bl Lpatch + (0xa5b0 - PATCH_BASE)
mov	x22, x0
LFQH_Lloh6598:
adr x23, LFQH_l_.str.513
LFQH_Lloh6599:
nop
mov	x0, x23
bl Lpatch + (0xa5a4 - PATCH_BASE)
mov	x1, x0
mov	x0, x22
fmov	d0, d8
fmov	d1, d15
fmov	d2, d9
fmov	d3, d10
bl Lpatch + (0xa5d4 - PATCH_BASE)
mov	x2, x0
LFQH_Lloh6600:
adr x1, LFQH_TopChromeStockFrameKey
LFQH_Lloh6601:
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
fmov	d0, d8
fmov	d1, d12
fmov	d2, d9
fmov	d3, d11
bl Lpatch + (0xa5d4 - PATCH_BASE)
mov	x2, x0
LFQH_Lloh6602:
adr x1, LFQH_TopChromeFrameKey
LFQH_Lloh6603:
nop
mov	x0, x20
b	LFQH_LBB374_23
LFQH_LBB374_21:
cbz	x21, LFQH_LBB374_24
LFQH_Lloh6604:
adr x1, LFQH_TopChromeStockFrameKey
LFQH_Lloh6605:
nop
mov	x0, x20
mov	x2, #0
mov	w3, #1
bl Lpatch + (0xa634 - PATCH_BASE)
LFQH_Lloh6606:
adr x1, LFQH_TopChromeFrameKey
LFQH_Lloh6607:
nop
mov	x0, x20
mov	x2, #0
mov	w3, #1
bl Lpatch + (0xa634 - PATCH_BASE)
LFQH_Lloh6608:
adr x1, LFQH_TopChromeScrollKey
LFQH_Lloh6609:
nop
mov	x0, x20
mov	x2, #0
LFQH_LBB374_23:
mov	w3, #1
bl Lpatch + (0xa634 - PATCH_BASE)
LFQH_LBB374_24:
fcmp	d14, d8
b.ne	LFQH_LBB374_26
ldr	d0, [sp, #8]
fcmp	d0, d12
ldp	d0, d1, [sp, #16]
fccmp	d1, d9, #0, eq
fccmp	d0, d11, #0, eq
b.eq	LFQH_LBB374_27
LFQH_LBB374_26:
LFQH_Lloh6610:
adr x0, LFQH_l_.str.156
LFQH_Lloh6611:
nop
bl Lpatch + (0xa5a4 - PATCH_BASE)
mov	x1, x0
mov	x0, x20
fmov	d0, d8
fmov	d1, d12
fmov	d2, d9
fmov	d3, d11
bl Lpatch + (0xa5d4 - PATCH_BASE)
LFQH_LBB374_27:
fcmp	d13, #0.0
b.le	LFQH_LBB374_29
mov	x0, x19
fmov	d0, d13
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
LFQH_LBB374_29:
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
cbz	x2, LFQH_LBB375_15
mov	x24, x3
cbz	x3, LFQH_LBB375_15
mov	x19, x5
mov	x23, x4
mov	x22, x2
mov	x20, x1
mov	x21, x0
LFQH_Lloh6612:
adr x1, LFQH_l_.str.74
LFQH_Lloh6613:
nop
mov	x0, x2
bl	LFQH_Get
cbz	x0, LFQH_LBB375_15
LFQH_Lloh6614:
adr x0, LFQH_l_.str.372
LFQH_Lloh6615:
nop
bl Lpatch + (0xa5a4 - PATCH_BASE)
mov	x1, x0
mov	x0, x24
bl Lpatch + (0xa5d4 - PATCH_BASE)
mov	x0, x24
bl	LFQH_TopChromeStockFrame
stp	d1, d0, [sp, #32]
stp	d3, d2, [sp, #16]
LFQH_Lloh6616:
adr x0, LFQH_l_.str.24
LFQH_Lloh6617:
nop
bl Lpatch + (0xa5a4 - PATCH_BASE)
mov	x1, x0
mov	x0, x24
bl Lpatch + (0xa5d4 - PATCH_BASE)
fmov	d8, d0
fmov	d9, d1
fmov	d10, d2
fmov	d11, d3
LFQH_Lloh6618:
adr x0, LFQH_l_.str.507
LFQH_Lloh6619:
nop
bl Lpatch + (0xa5a4 - PATCH_BASE)
mov	x1, x0
mov	x0, x24
fmov	d0, d8
fmov	d1, d9
fmov	d2, d10
fmov	d3, d11
mov	x2, x22
bl Lpatch + (0xa5d4 - PATCH_BASE)
stp	d2, d0, [sp]
stp	d1, d3, [sp, #48]
cbz	x23, LFQH_LBB375_11
LFQH_Lloh6620:
adr x0, LFQH_l_.str.24
LFQH_Lloh6621:
nop
bl Lpatch + (0xa5a4 - PATCH_BASE)
mov	x1, x0
mov	x0, x23
bl Lpatch + (0xa5d4 - PATCH_BASE)
fmov	d8, d0
fmov	d9, d1
fmov	d10, d2
fmov	d11, d3
LFQH_Lloh6622:
adr x0, LFQH_l_.str.507
LFQH_Lloh6623:
nop
bl Lpatch + (0xa5a4 - PATCH_BASE)
mov	x1, x0
mov	x0, x23
fmov	d0, d8
fmov	d1, d9
fmov	d2, d10
fmov	d3, d11
mov	x2, x22
bl Lpatch + (0xa5d4 - PATCH_BASE)
fmov	d11, d0
fmov	d10, d1
fmov	d9, d2
fmov	d14, d3
LFQH_Lloh6624:
adr x1, LFQH_l_.str.20
LFQH_Lloh6625:
nop
mov	x0, x23
bl	LFQH_Get
cbz	x0, LFQH_LBB375_12
mov	x23, x0
cmp	x0, x22
b.eq	LFQH_LBB375_12
LFQH_Lloh6626:
adr x24, LFQH_l_.str.391
LFQH_Lloh6627:
nop
LFQH_Lloh6628:
adr x25, LFQH_l_.str.20
LFQH_Lloh6629:
nop
LFQH_Lloh6630:
adr x26, LFQH_l_.str.24
LFQH_Lloh6631:
nop
LFQH_Lloh6632:
adr x27, LFQH_l_.str.507
LFQH_Lloh6633:
nop
LFQH_LBB375_7:
mov	x0, x24
bl Lpatch + (0xa5a4 - PATCH_BASE)
mov	x1, x0
mov	x0, x23
bl Lpatch + (0xa5d4 - PATCH_BASE)
cbz	w0, LFQH_LBB375_9
mov	x0, x26
bl Lpatch + (0xa5a4 - PATCH_BASE)
mov	x1, x0
mov	x0, x23
bl Lpatch + (0xa5d4 - PATCH_BASE)
fmov	d12, d0
fmov	d8, d14
fmov	d14, d1
fmov	d13, d2
fmov	d15, d3
mov	x0, x27
bl Lpatch + (0xa5a4 - PATCH_BASE)
mov	x1, x0
mov	x0, x23
fmov	d0, d12
fmov	d1, d14
fmov	d2, d13
fmov	d3, d15
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
LFQH_LBB375_9:
mov	x0, x23
mov	x1, x25
bl	LFQH_Get
cbz	x0, LFQH_LBB375_12
mov	x23, x0
cmp	x0, x22
b.ne	LFQH_LBB375_7
b	LFQH_LBB375_12
LFQH_LBB375_11:
fmov	d14, xzr
fmov	d9, xzr
fmov	d10, xzr
fmov	d11, xzr
LFQH_LBB375_12:
and	w8, w19, #0xff
ucvtf	d12, w8
LFQH_Lloh6634:
adr x1, LFQH_TopChromeGeometryKey
LFQH_Lloh6635:
nop
mov	x0, x21
bl Lpatch + (0xa628 - PATCH_BASE)
ldr	d8, [sp, #48]
cbz	x0, LFQH_LBB375_14
mov	x22, x0
LFQH_Lloh6636:
adr x0, LFQH_l_.str.432
LFQH_Lloh6637:
nop
bl Lpatch + (0xa5a4 - PATCH_BASE)
mov	x1, x0
mov	x0, x22
bl Lpatch + (0xa5d4 - PATCH_BASE)
fcmp	d8, d0
fccmp	d10, d1, #0, eq
ldr	d0, [sp, #56]
fccmp	d0, d2, #0, eq
fccmp	d3, d12, #0, eq
b.eq	LFQH_LBB375_15
LFQH_LBB375_14:
LFQH_Lloh6638:
adr x0, LFQH_l_.str.512
LFQH_Lloh6639:
nop
bl Lpatch + (0xa5b0 - PATCH_BASE)
mov	x22, x0
LFQH_Lloh6640:
adr x0, LFQH_l_.str.513
LFQH_Lloh6641:
nop
bl Lpatch + (0xa5a4 - PATCH_BASE)
mov	x1, x0
mov	x0, x22
fmov	d0, d8
fmov	d1, d10
ldr	d13, [sp, #56]
fmov	d2, d13
fmov	d3, d12
bl Lpatch + (0xa5d4 - PATCH_BASE)
mov	x2, x0
LFQH_Lloh6642:
adr x1, LFQH_TopChromeGeometryKey
LFQH_Lloh6643:
nop
mov	x0, x21
mov	w3, #1
bl Lpatch + (0xa634 - PATCH_BASE)
LFQH_Lloh6644:
adr x0, LFQH_l_.str.88
LFQH_Lloh6645:
nop
bl Lpatch + (0xa5b0 - PATCH_BASE)
mov	x21, x0
LFQH_Lloh6646:
adr x0, LFQH_l_.str.89
LFQH_Lloh6647:
nop
bl Lpatch + (0xa5a4 - PATCH_BASE)
mov	x1, x0
mov	x0, x21
bl Lpatch + (0xa5d4 - PATCH_BASE)
mov	x21, x0
LFQH_Lloh6648:
adr x22, LFQH_l_.str.361
LFQH_Lloh6649:
nop
mov	x0, x22
bl Lpatch + (0xa5b0 - PATCH_BASE)
mov	x23, x0
LFQH_Lloh6650:
adr x24, LFQH_l_.str.387
LFQH_Lloh6651:
nop
mov	x0, x24
bl Lpatch + (0xa5a4 - PATCH_BASE)
mov	x1, x0
mov	x0, x23
mov	x2, x20
bl Lpatch + (0xa5d4 - PATCH_BASE)
mov	x2, x0
LFQH_Lloh6652:
adr x1, LFQH_l_.str.410
LFQH_Lloh6653:
nop
mov	x0, x21
bl	LFQH_Put
LFQH_Lloh6654:
adr x8, LFQH_l_.str.787
LFQH_Lloh6655:
nop
LFQH_Lloh6656:
adr x9, LFQH_l_.str.788
LFQH_Lloh6657:
nop
cmp	w19, #0
csel	x19, x9, x8, eq
mov	x0, x22
bl Lpatch + (0xa5b0 - PATCH_BASE)
mov	x20, x0
mov	x0, x24
bl Lpatch + (0xa5a4 - PATCH_BASE)
mov	x1, x0
mov	x0, x20
mov	x2, x19
bl Lpatch + (0xa5d4 - PATCH_BASE)
mov	x2, x0
LFQH_Lloh6658:
adr x1, LFQH_l_.str.786
LFQH_Lloh6659:
nop
mov	x0, x21
bl	LFQH_Put
ldp	d1, d0, [sp, #32]
ldp	d3, d2, [sp, #16]
bl	LFQH_RectArray
mov	x2, x0
LFQH_Lloh6660:
adr x1, LFQH_l_.str.789
LFQH_Lloh6661:
nop
mov	x0, x21
bl	LFQH_Put
ldp	d2, d0, [sp]
fmov	d1, d8
fmov	d3, d13
bl	LFQH_RectArray
mov	x2, x0
LFQH_Lloh6662:
adr x1, LFQH_l_.str.790
LFQH_Lloh6663:
nop
mov	x0, x21
bl	LFQH_Put
fmov	d0, d11
fmov	d1, d10
fmov	d2, d9
fmov	d3, d14
bl	LFQH_RectArray
mov	x2, x0
LFQH_Lloh6664:
adr x1, LFQH_l_.str.791
LFQH_Lloh6665:
nop
mov	x0, x21
bl	LFQH_Put
LFQH_Lloh6666:
adr x0, LFQH_l_.str.792
LFQH_Lloh6667:
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
LFQH_LBB375_15:
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
.cfi_endproc
.p2align	2
LFQH_TopChromeOwnerKey:
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
LFQH_TopChromeTintKey:
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
fmov	d8, d3
fmov	d9, d2
fmov	d11, d1
fmov	d10, d0
mov	x19, x0
LFQH_Lloh6668:
adr x1, LFQH_TopChromeFrameKey
LFQH_Lloh6669:
nop
bl Lpatch + (0xa628 - PATCH_BASE)
cbz	x0, LFQH_LBB383_3
mov	x20, x0
LFQH_Lloh6670:
adr x0, LFQH_l_.str.432
LFQH_Lloh6671:
nop
bl Lpatch + (0xa5a4 - PATCH_BASE)
mov	x1, x0
mov	x0, x20
bl Lpatch + (0xa5d4 - PATCH_BASE)
fcmp	d11, d1
b.ne	LFQH_LBB383_3
LFQH_Lloh6672:
adr x1, LFQH_TopChromeStockFrameKey
LFQH_Lloh6673:
nop
mov	x0, x19
bl Lpatch + (0xa628 - PATCH_BASE)
mov	x19, x0
LFQH_Lloh6674:
adr x0, LFQH_l_.str.432
LFQH_Lloh6675:
nop
bl Lpatch + (0xa5a4 - PATCH_BASE)
mov	x1, x0
mov	x0, x19
bl Lpatch + (0xa5d4 - PATCH_BASE)
fsub	d0, d11, d1
fadd	d8, d8, d0
fmov	d11, d1
LFQH_LBB383_3:
fmov	d0, d10
fmov	d1, d11
fmov	d2, d9
fmov	d3, d8
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
cbz	x0, LFQH_LBB385_7
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
LFQH_Lloh6676:
adr x1, LFQH_l_.str.774
LFQH_Lloh6677:
nop
mov	x0, x20
bl	LFQH_Kind
cbz	w0, LFQH_LBB385_6
cmp	x20, #0
cset	w0, ne
cmp	x20, x19
b.eq	LFQH_LBB385_6
cbz	x20, LFQH_LBB385_6
LFQH_Lloh6678:
adr x21, LFQH_l_.str.20
LFQH_Lloh6679:
nop
LFQH_LBB385_5:
mov	x0, x20
mov	x1, x21
bl	LFQH_Get
mov	x20, x0
cmp	x0, #0
cset	w0, ne
cmp	x20, x19
ccmp	x20, #0, #4, ne
b.ne	LFQH_LBB385_5
LFQH_LBB385_6:
ldp	x29, x30, [sp, #32]
ldp	x20, x19, [sp, #16]
ldp	x22, x21, [sp], #48
LFQH_LBB385_7:
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
cbz	x0, LFQH_LBB387_20
fmov	d11, d0
mov	x19, x0
LFQH_Lloh6680:
adr x0, LFQH_l_.str.778
LFQH_Lloh6681:
nop
bl Lpatch + (0xa5a4 - PATCH_BASE)
mov	x1, x0
mov	x0, x19
bl Lpatch + (0xa5d4 - PATCH_BASE)
fmov	d12, d0
stp	d2, d1, [sp]
fmov	d10, d3
LFQH_Lloh6682:
adr x1, LFQH_TopChromeInsetKey
LFQH_Lloh6683:
nop
mov	x0, x19
bl Lpatch + (0xa628 - PATCH_BASE)
mov	x20, x0
LFQH_Lloh6684:
adr x1, LFQH_TopChromeStockInsetKey
LFQH_Lloh6685:
nop
mov	x0, x19
bl Lpatch + (0xa628 - PATCH_BASE)
mov	x21, x0
LFQH_Lloh6686:
adr x22, LFQH_l_.str.445
LFQH_Lloh6687:
nop
mov	x0, x22
bl Lpatch + (0xa5a4 - PATCH_BASE)
mov	x1, x0
mov	x0, x21
bl Lpatch + (0xa5d4 - PATCH_BASE)
fmov	d13, d0
mov	x0, x22
bl Lpatch + (0xa5a4 - PATCH_BASE)
mov	x1, x0
mov	x0, x20
bl Lpatch + (0xa5d4 - PATCH_BASE)
fmov	d14, d0
fcmp	d12, d0
ccmp	x20, #0, #4, ne
cset	w22, ne
cmp	w22, #1
fccmp	d12, d13, #4, eq
b.eq	LFQH_LBB387_5
LFQH_Lloh6688:
adr x1, LFQH_l_.str.120
LFQH_Lloh6689:
nop
mov	x0, x19
bl	LFQH_Get
mov	x21, x0
LFQH_Lloh6690:
adr x1, LFQH_l_.str.257
LFQH_Lloh6691:
nop
bl	LFQH_Kind
cbz	w0, LFQH_LBB387_4
LFQH_Lloh6692:
adr x1, LFQH_l_.str.779
LFQH_Lloh6693:
nop
mov	x0, x21
bl	LFQH_Get
cmp	x0, x19
cset	w22, ne
b	LFQH_LBB387_5
LFQH_LBB387_4:
mov	w22, #1
LFQH_LBB387_5:
cmp	x20, #0
csinc	w8, w22, wzr, ne
cmp	w8, #0
fcsel	d9, d12, d13, ne
fadd	d8, d9, d11
fsub	d0, d8, d14
fadd	d0, d12, d0
fcsel	d15, d8, d0, ne
fcmp	d11, #0.0
b.le	LFQH_LBB387_8
cbz	w8, LFQH_LBB387_8
LFQH_Lloh6694:
adr x0, LFQH_l_.str.497
LFQH_Lloh6695:
nop
bl Lpatch + (0xa5b0 - PATCH_BASE)
mov	x21, x0
LFQH_Lloh6696:
adr x0, LFQH_l_.str.515
LFQH_Lloh6697:
nop
bl Lpatch + (0xa5a4 - PATCH_BASE)
mov	x1, x0
mov	x0, x21
fmov	d0, d9
bl Lpatch + (0xa5d4 - PATCH_BASE)
mov	x2, x0
LFQH_Lloh6698:
adr x1, LFQH_TopChromeStockInsetKey
LFQH_Lloh6699:
nop
mov	x0, x19
mov	w3, #1
bl Lpatch + (0xa634 - PATCH_BASE)
LFQH_LBB387_8:
fcmp	d8, d14
ccmp	x20, #0, #4, eq
cset	w8, ne
fcmp	d11, #0.0
b.le	LFQH_LBB387_11
tbnz	w8, #0, LFQH_LBB387_11
LFQH_Lloh6700:
adr x0, LFQH_l_.str.497
LFQH_Lloh6701:
nop
bl Lpatch + (0xa5b0 - PATCH_BASE)
mov	x21, x0
LFQH_Lloh6702:
adr x0, LFQH_l_.str.515
LFQH_Lloh6703:
nop
bl Lpatch + (0xa5a4 - PATCH_BASE)
mov	x1, x0
mov	x0, x21
fmov	d0, d8
bl Lpatch + (0xa5d4 - PATCH_BASE)
mov	x2, x0
LFQH_Lloh6704:
adr x1, LFQH_TopChromeInsetKey
LFQH_Lloh6705:
nop
mov	x0, x19
mov	w3, #1
bl Lpatch + (0xa634 - PATCH_BASE)
LFQH_LBB387_11:
fcmp	d11, #0.0
b.ne	LFQH_LBB387_14
cbz	x20, LFQH_LBB387_14
LFQH_Lloh6706:
adr x1, LFQH_TopChromeStockInsetKey
LFQH_Lloh6707:
nop
mov	x0, x19
mov	x2, #0
mov	w3, #1
bl Lpatch + (0xa634 - PATCH_BASE)
LFQH_Lloh6708:
adr x1, LFQH_TopChromeInsetKey
LFQH_Lloh6709:
nop
mov	x0, x19
mov	x2, #0
mov	w3, #1
bl Lpatch + (0xa634 - PATCH_BASE)
LFQH_LBB387_14:
fcmp	d11, #0.0
csel	w8, wzr, w22, ne
tbnz	w8, #0, LFQH_LBB387_16
fcmp	d15, d12
b.eq	LFQH_LBB387_20
LFQH_LBB387_16:
LFQH_Lloh6710:
adr x0, LFQH_l_.str.780
LFQH_Lloh6711:
nop
bl Lpatch + (0xa5a4 - PATCH_BASE)
mov	x1, x0
mov	x0, x19
bl Lpatch + (0xa5d4 - PATCH_BASE)
fmov	d8, d0
fmov	d9, d1
LFQH_Lloh6712:
adr x0, LFQH_l_.str.781
LFQH_Lloh6713:
nop
bl Lpatch + (0xa5a4 - PATCH_BASE)
mov	x1, x0
mov	x0, x19
bl Lpatch + (0xa5d4 - PATCH_BASE)
fmov	d1, #0.50000000
fsub	d0, d1, d0
fcmp	d9, d0
cset	w8, hi
fsub	d0, d15, d12
fsub	d1, d14, d13
fsub	d1, d11, d1
tst	w22, w8
fcsel	d11, d1, d0, ne
fcmp	d15, d12
b.eq	LFQH_LBB387_18
LFQH_Lloh6714:
adr x0, LFQH_l_.str.782
LFQH_Lloh6715:
nop
bl Lpatch + (0xa5a4 - PATCH_BASE)
mov	x1, x0
mov	x0, x19
fmov	d0, d15
ldp	d2, d1, [sp]
fmov	d3, d10
bl Lpatch + (0xa5d4 - PATCH_BASE)
LFQH_LBB387_18:
fsub	d9, d9, d11
LFQH_Lloh6716:
adr x0, LFQH_l_.str.780
LFQH_Lloh6717:
nop
bl Lpatch + (0xa5a4 - PATCH_BASE)
mov	x1, x0
mov	x0, x19
bl Lpatch + (0xa5d4 - PATCH_BASE)
fcmp	d0, d8
b.ne	LFQH_LBB387_21
fcmp	d1, d9
b.ne	LFQH_LBB387_21
LFQH_LBB387_20:
ldp	x29, x30, [sp, #112]
ldp	x20, x19, [sp, #96]
ldp	x22, x21, [sp, #80]
ldp	d9, d8, [sp, #64]
ldp	d11, d10, [sp, #48]
ldp	d13, d12, [sp, #32]
ldp	d15, d14, [sp, #16]
add	sp, sp, #128
ret
LFQH_LBB387_21:
LFQH_Lloh6718:
adr x0, LFQH_l_.str.783
LFQH_Lloh6719:
nop
bl Lpatch + (0xa5a4 - PATCH_BASE)
mov	x1, x0
mov	x0, x19
fmov	d0, d8
fmov	d1, d9
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
LFQH_TopChromeRefreshVisibility:
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
LFQH_Lloh6720:
adr x1, LFQH_l_.str.784
LFQH_Lloh6721:
nop
bl	LFQH_Get
mov	x22, x0
LFQH_Lloh6722:
adr x1, LFQH_l_.str.341
LFQH_Lloh6723:
nop
bl	LFQH_Responds
cbz	w0, LFQH_LBB388_2
LFQH_Lloh6724:
adr x1, LFQH_l_.str.20
LFQH_Lloh6725:
nop
mov	x0, x22
bl	LFQH_Get
cmp	x0, x20
b.eq	LFQH_LBB388_3
LFQH_LBB388_2:
ldp	x29, x30, [sp, #48]
ldp	x20, x19, [sp, #32]
ldp	x22, x21, [sp, #16]
ldp	d9, d8, [sp], #64
ret
LFQH_LBB388_3:
LFQH_Lloh6726:
adr x1, LFQH_l_.str.338
LFQH_Lloh6727:
nop
mov	x0, x22
bl	LFQH_Get
mov	x19, x0
LFQH_Lloh6728:
adr x1, LFQH_l_.str.23
LFQH_Lloh6729:
nop
bl	LFQH_Kind
cbz	w0, LFQH_LBB388_2
LFQH_Lloh6730:
adr x1, LFQH_l_.str.20
LFQH_Lloh6731:
nop
mov	x0, x19
bl	LFQH_Get
cmp	x0, x22
b.ne	LFQH_LBB388_2
LFQH_Lloh6732:
adr x1, LFQH_TopChromeRefreshHiddenKey
LFQH_Lloh6733:
nop
mov	x0, x19
bl Lpatch + (0xa628 - PATCH_BASE)
mov	x21, x0
LFQH_Lloh6734:
adr x1, LFQH_TopChromeInsetKey
LFQH_Lloh6735:
nop
mov	x0, x20
bl Lpatch + (0xa628 - PATCH_BASE)
cbz	x0, LFQH_LBB388_7
LFQH_Lloh6736:
adr x0, LFQH_l_.str.339
LFQH_Lloh6737:
nop
bl Lpatch + (0xa5a4 - PATCH_BASE)
mov	x1, x0
mov	x0, x22
bl Lpatch + (0xa5d4 - PATCH_BASE)
cbz	w0, LFQH_LBB388_10
LFQH_LBB388_7:
cbz	x21, LFQH_LBB388_2
LFQH_Lloh6738:
adr x0, LFQH_l_.str.41
LFQH_Lloh6739:
nop
bl Lpatch + (0xa5a4 - PATCH_BASE)
mov	x1, x0
mov	x0, x21
bl Lpatch + (0xa5d4 - PATCH_BASE)
mov	x20, x0
LFQH_Lloh6740:
adr x1, LFQH_TopChromeRefreshHiddenKey
LFQH_Lloh6741:
nop
mov	x0, x19
mov	x2, #0
mov	w3, #1
bl Lpatch + (0xa634 - PATCH_BASE)
LFQH_Lloh6742:
adr x0, LFQH_l_.str.71
LFQH_Lloh6743:
nop
bl Lpatch + (0xa5a4 - PATCH_BASE)
mov	x1, x0
mov	x0, x19
bl Lpatch + (0xa5d4 - PATCH_BASE)
cmp	w0, w20
b.eq	LFQH_LBB388_2
LFQH_LBB388_9:
LFQH_Lloh6744:
adr x0, LFQH_l_.str.72
LFQH_Lloh6745:
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
LFQH_LBB388_10:
LFQH_Lloh6746:
adr x0, LFQH_l_.str.785
LFQH_Lloh6747:
nop
bl Lpatch + (0xa5a4 - PATCH_BASE)
mov	x1, x0
mov	x0, x20
bl Lpatch + (0xa5d4 - PATCH_BASE)
cbz	w0, LFQH_LBB388_12
LFQH_Lloh6748:
adr x0, LFQH_l_.str.780
LFQH_Lloh6749:
nop
bl Lpatch + (0xa5a4 - PATCH_BASE)
mov	x1, x0
mov	x0, x20
bl Lpatch + (0xa5d4 - PATCH_BASE)
fmov	d8, d1
LFQH_Lloh6750:
adr x0, LFQH_l_.str.781
LFQH_Lloh6751:
nop
bl Lpatch + (0xa5a4 - PATCH_BASE)
mov	x1, x0
mov	x0, x20
bl Lpatch + (0xa5d4 - PATCH_BASE)
fneg	d0, d0
fcmp	d8, d0
b.lt	LFQH_LBB388_7
LFQH_LBB388_12:
LFQH_Lloh6752:
adr x0, LFQH_l_.str.71
LFQH_Lloh6753:
nop
bl Lpatch + (0xa5a4 - PATCH_BASE)
mov	x1, x0
mov	x0, x19
bl Lpatch + (0xa5d4 - PATCH_BASE)
mov	x20, x0
cbnz	x21, LFQH_LBB388_14
mov	x0, x20
bl	LFQH_BoolBox
mov	x2, x0
LFQH_Lloh6754:
adr x1, LFQH_TopChromeRefreshHiddenKey
LFQH_Lloh6755:
nop
mov	x0, x19
mov	w3, #1
bl Lpatch + (0xa634 - PATCH_BASE)
LFQH_LBB388_14:
cbnz	w20, LFQH_LBB388_2
mov	w20, #1
b	LFQH_LBB388_9
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
LFQH_TopChromeRefreshHiddenKey:
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
LFQH_Lloh6756:
adr x1, LFQH_l_.str.363
LFQH_Lloh6757:
nop
bl	LFQH_Get
cbz	x0, LFQH_LBB394_29
mov	x19, x0
LFQH_Lloh6758:
adr x1, LFQH_l_.str.794
LFQH_Lloh6759:
nop
mov	x0, x21
bl	LFQH_HasAncestor
cbnz	w0, LFQH_LBB394_3
LFQH_Lloh6760:
adr x1, LFQH_l_.str.795
LFQH_Lloh6761:
nop
mov	x0, x21
bl	LFQH_HasAncestor
cbz	w0, LFQH_LBB394_7
LFQH_LBB394_3:
bl	LFQH_Enabled
cbz	w0, LFQH_LBB394_7
bl	LFQH_FQHGlassAvailable
cbz	w0, LFQH_LBB394_7
LFQH_Lloh6762:
adr x8, LFQH_l_.str.796
LFQH_Lloh6763:
nop
LFQH_Lloh6764:
adr x9, LFQH_l_.str.797
LFQH_Lloh6765:
nop
cmp	w22, #0
csel	x1, x9, x8, eq
mov	x0, x21
bl	LFQH_Get
mov	x20, x0
cbz	x0, LFQH_LBB394_8
LFQH_Lloh6766:
adr x8, LFQH_l_.str.798
LFQH_Lloh6767:
nop
LFQH_Lloh6768:
adr x9, LFQH_l_.str.799
LFQH_Lloh6769:
nop
cmp	w22, #0
csel	x1, x9, x8, eq
mov	x0, x21
bl	LFQH_Get
mov	x21, x0
b	LFQH_LBB394_9
LFQH_LBB394_7:
mov	x20, #0
LFQH_LBB394_8:
mov	x21, #0
LFQH_LBB394_9:
LFQH_Lloh6770:
adr x1, LFQH_l_.str.70
LFQH_Lloh6771:
nop
mov	x0, x20
bl	LFQH_Kind
cbz	w0, LFQH_LBB394_12
LFQH_Lloh6772:
adr x1, LFQH_l_.str.20
LFQH_Lloh6773:
nop
mov	x0, x20
bl	LFQH_Get
cmp	x0, x19
b.ne	LFQH_LBB394_12
LFQH_Lloh6774:
adr x0, LFQH_l_.str.71
LFQH_Lloh6775:
nop
bl Lpatch + (0xa5a4 - PATCH_BASE)
mov	x1, x0
mov	x0, x20
bl Lpatch + (0xa5d4 - PATCH_BASE)
cbz	w0, LFQH_LBB394_13
LFQH_LBB394_12:
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
LFQH_LBB394_13:
LFQH_Lloh6776:
adr x1, LFQH_l_.str.36
LFQH_Lloh6777:
nop
mov	x0, x21
bl	LFQH_Kind
cbz	w0, LFQH_LBB394_12
LFQH_Lloh6778:
adr x1, LFQH_l_.str.20
LFQH_Lloh6779:
nop
mov	x0, x21
bl	LFQH_Get
cmp	x0, x19
b.ne	LFQH_LBB394_12
LFQH_Lloh6780:
adr x1, LFQH_GlyphViewKey
LFQH_Lloh6781:
nop
mov	x0, x19
bl Lpatch + (0xa628 - PATCH_BASE)
mov	x23, x0
LFQH_Lloh6782:
adr x1, LFQH_ProfileCaptionKey
LFQH_Lloh6783:
nop
mov	x0, x19
bl Lpatch + (0xa628 - PATCH_BASE)
mov	x22, x0
cmp	x23, x20
b.eq	LFQH_LBB394_17
LFQH_Lloh6784:
adr x1, LFQH_GlyphViewKey
LFQH_Lloh6785:
nop
mov	x0, x19
bl	LFQH_RestoreProfileEntryFrame
LFQH_LBB394_17:
cmp	x22, x21
b.eq	LFQH_LBB394_19
LFQH_Lloh6786:
adr x1, LFQH_ProfileCaptionKey
LFQH_Lloh6787:
nop
mov	x0, x19
bl	LFQH_RestoreProfileEntryFrame
LFQH_LBB394_19:
LFQH_Lloh6788:
adr x0, LFQH_l_.str.24
LFQH_Lloh6789:
nop
bl Lpatch + (0xa5a4 - PATCH_BASE)
mov	x1, x0
mov	x0, x19
bl Lpatch + (0xa5d4 - PATCH_BASE)
str	d0, [sp, #152]
stp	d1, d2, [x29, #-144]
str	d3, [sp, #144]
LFQH_Lloh6790:
adr x24, LFQH_l_.str.372
LFQH_Lloh6791:
nop
mov	x0, x24
bl Lpatch + (0xa5a4 - PATCH_BASE)
mov	x1, x0
mov	x0, x21
bl Lpatch + (0xa5d4 - PATCH_BASE)
fmov	d10, d0
fmov	d13, d1
fmov	d14, d2
fmov	d15, d3
mov	x0, x24
bl Lpatch + (0xa5a4 - PATCH_BASE)
mov	x1, x0
mov	x0, x20
bl Lpatch + (0xa5d4 - PATCH_BASE)
fmov	d12, d0
fmov	d11, d1
fmov	d9, d2
fmov	d8, d3
mov	x0, x21
stp	d13, d10, [sp, #88]
fmov	d0, d10
fmov	d1, d13
stp	d15, d14, [sp, #72]
fmov	d2, d14
fmov	d3, d15
bl	LFQH_ProfileStockFrame
stp	d2, d0, [sp, #104]
fmov	d13, d1
fmov	d15, d3
mov	x0, x20
stp	d11, d12, [sp, #56]
fmov	d0, d12
fmov	d1, d11
stp	d9, d8, [sp, #40]
fmov	d2, d9
ldp	d9, d12, [sp, #144]
fmov	d3, d8
bl	LFQH_ProfileStockFrame
fmov	d8, d0
stp	d1, d2, [sp, #120]
str	d3, [sp, #136]
fmov	d0, d12
ldp	d1, d2, [x29, #-144]
fmov	d10, d1
fmov	d11, d2
fmov	d3, d9
bl	LFQH_VisibleRect
cbz	w0, LFQH_LBB394_12
fadd	d0, d13, d15
fsub	d0, d0, d10
fmov	d1, #5.00000000
fadd	d0, d0, d1
mov	x8, #4631389266797133824
fmov	d1, x8
fmaxnm	d0, d0, d1
fminnm	d9, d9, d0
fadd	d0, d10, d9
fsub	d0, d0, d15
fmov	d1, #-10.00000000
fadd	d0, d0, d1
fminnm	d3, d13, d0
fsub	d0, d13, d10
fadd	d0, d0, d1
fmov	d1, #20.00000000
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
fccmp	d11, d0, #8, pl
b.mi	LFQH_LBB394_12
fmov	d0, d8
ldp	d1, d2, [sp, #120]
ldr	d3, [sp, #136]
bl	LFQH_VisibleRect
cbz	w0, LFQH_LBB394_12
ldp	d2, d0, [sp, #104]
fmov	d1, d13
fmov	d3, d15
bl	LFQH_VisibleRect
cbz	w0, LFQH_LBB394_12
mov	x0, x19
fmov	d0, d12
fmov	d1, d10
fmov	d2, d11
fmov	d3, d9
mov	w1, #1
bl	LFQH_ApplySurface
LFQH_Lloh6792:
adr x1, LFQH_SurfaceKey
LFQH_Lloh6793:
nop
mov	x0, x19
bl Lpatch + (0xa628 - PATCH_BASE)
cbz	x0, LFQH_LBB394_12
str	d8, [sp, #32]
fmov	d0, #13.00000000
mov	x0, x19
mov	x1, x21
bl	LFQH_TrackAppearanceLabel
ldp	d4, d5, [sp, #128]
fmaxnm	d0, d4, d5
fdiv	d0, d14, d0
fmov	d1, #1.00000000
fminnm	d0, d0, d1
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
b.eq	LFQH_LBB394_26
LFQH_Lloh6794:
adr x1, LFQH_GlyphViewKey
LFQH_Lloh6795:
nop
mov	x0, x19
mov	x2, x20
mov	w3, #1
fmov	d11, d3
fmov	d14, d1
stur	d9, [x29, #-136]
fmov	d9, d8
fmov	d8, d10
fmov	d10, d0
bl Lpatch + (0xa634 - PATCH_BASE)
fmov	d0, d10
fmov	d10, d8
fmov	d8, d9
ldur	d9, [x29, #-136]
fmov	d1, d14
fmov	d3, d11
LFQH_LBB394_26:
fadd	d14, d12, d1
fadd	d12, d3, d0
cmp	x22, x21
b.eq	LFQH_LBB394_28
LFQH_Lloh6796:
adr x1, LFQH_ProfileCaptionKey
LFQH_Lloh6797:
nop
mov	x0, x19
mov	x2, x21
mov	w3, #1
bl Lpatch + (0xa634 - PATCH_BASE)
LFQH_LBB394_28:
stp	d8, d9, [sp, #16]
stp	d14, d12, [sp]
mov	x0, x20
ldp	d1, d0, [sp, #56]
ldp	d2, d3, [sp, #40]
ldr	d4, [sp, #32]
ldp	d5, d6, [sp, #120]
ldr	d7, [sp, #136]
bl	LFQH_ProfileSetFrame
ldp	d6, d4, [sp, #104]
stp	d6, d15, [sp, #16]
stp	d4, d10, [sp]
mov	x0, x21
ldp	d1, d0, [sp, #88]
ldp	d3, d2, [sp, #72]
fmov	d5, d13
fmov	d7, d15
bl	LFQH_ProfileSetFrame
LFQH_LBB394_29:
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
fmov	d0, xzr
mov	x1, #0
bl	LFQH_TrackAppearanceLabel
LFQH_Lloh6798:
adr x1, LFQH_GlyphViewKey
LFQH_Lloh6799:
nop
mov	x0, x19
bl	LFQH_RestoreProfileEntryFrame
LFQH_Lloh6800:
adr x1, LFQH_ProfileCaptionKey
LFQH_Lloh6801:
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
cbz	x0, LFQH_LBB397_4
mov	x21, x0
LFQH_Lloh6802:
adr x0, LFQH_l_.str.372
LFQH_Lloh6803:
nop
bl Lpatch + (0xa5a4 - PATCH_BASE)
mov	x1, x0
mov	x0, x21
bl Lpatch + (0xa5d4 - PATCH_BASE)
fmov	d12, d0
fmov	d13, d1
fmov	d14, d2
fmov	d15, d3
mov	x0, x21
bl	LFQH_ProfileStockFrame
fcmp	d12, d0
fccmp	d13, d1, #0, eq
fccmp	d14, d2, #0, eq
fccmp	d15, d3, #0, eq
b.eq	LFQH_LBB397_3
fmov	d8, d0
fmov	d9, d1
fmov	d10, d2
fmov	d11, d3
LFQH_Lloh6804:
adr x0, LFQH_l_.str.156
LFQH_Lloh6805:
nop
bl Lpatch + (0xa5a4 - PATCH_BASE)
mov	x1, x0
mov	x0, x21
fmov	d0, d8
fmov	d1, d9
fmov	d2, d10
fmov	d3, d11
bl Lpatch + (0xa5d4 - PATCH_BASE)
LFQH_LBB397_3:
LFQH_Lloh6806:
adr x1, LFQH_GlyphOriginalKey
LFQH_Lloh6807:
nop
mov	x0, x21
mov	x2, #0
mov	w3, #1
bl Lpatch + (0xa634 - PATCH_BASE)
LFQH_Lloh6808:
adr x1, LFQH_GlyphAppliedKey
LFQH_Lloh6809:
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
LFQH_LBB397_4:
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
fmov	d8, d3
fmov	d9, d2
fmov	d10, d1
fmov	d11, d0
mov	x19, x0
LFQH_Lloh6810:
adr x1, LFQH_GlyphAppliedKey
LFQH_Lloh6811:
nop
bl Lpatch + (0xa628 - PATCH_BASE)
cbz	x0, LFQH_LBB398_3
mov	x20, x0
LFQH_Lloh6812:
adr x0, LFQH_l_.str.432
LFQH_Lloh6813:
nop
bl Lpatch + (0xa5a4 - PATCH_BASE)
mov	x1, x0
mov	x0, x20
bl Lpatch + (0xa5d4 - PATCH_BASE)
fcmp	d11, d0
fccmp	d10, d1, #0, eq
fccmp	d9, d2, #0, eq
fccmp	d8, d3, #0, eq
b.ne	LFQH_LBB398_3
LFQH_Lloh6814:
adr x1, LFQH_GlyphOriginalKey
LFQH_Lloh6815:
nop
mov	x0, x19
bl Lpatch + (0xa628 - PATCH_BASE)
mov	x19, x0
LFQH_Lloh6816:
adr x0, LFQH_l_.str.432
LFQH_Lloh6817:
nop
bl Lpatch + (0xa5a4 - PATCH_BASE)
mov	x1, x0
mov	x0, x19
bl Lpatch + (0xa5d4 - PATCH_BASE)
fmov	d11, d0
fmov	d10, d1
fmov	d9, d2
fmov	d8, d3
LFQH_LBB398_3:
fmov	d0, d11
fmov	d1, d10
fmov	d2, d9
fmov	d3, d8
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
b.eq	LFQH_LBB399_11
fmov	d12, d7
fmov	d13, d6
fmov	d14, d5
fmov	d15, d4
mov	x19, x0
LFQH_Lloh6818:
adr x1, LFQH_GlyphOriginalKey
LFQH_Lloh6819:
nop
bl Lpatch + (0xa628 - PATCH_BASE)
mov	x21, x0
LFQH_Lloh6820:
adr x1, LFQH_GlyphAppliedKey
LFQH_Lloh6821:
nop
mov	x0, x19
bl Lpatch + (0xa628 - PATCH_BASE)
mov	x20, x0
cbz	x21, LFQH_LBB399_3
LFQH_Lloh6822:
adr x0, LFQH_l_.str.432
LFQH_Lloh6823:
nop
bl Lpatch + (0xa5a4 - PATCH_BASE)
mov	x1, x0
mov	x0, x21
bl Lpatch + (0xa5d4 - PATCH_BASE)
fcmp	d15, d0
fccmp	d14, d1, #0, eq
fccmp	d13, d2, #0, eq
fccmp	d12, d3, #0, eq
b.eq	LFQH_LBB399_4
LFQH_LBB399_3:
LFQH_Lloh6824:
adr x0, LFQH_l_.str.512
LFQH_Lloh6825:
nop
bl Lpatch + (0xa5b0 - PATCH_BASE)
mov	x21, x0
LFQH_Lloh6826:
adr x0, LFQH_l_.str.513
LFQH_Lloh6827:
nop
bl Lpatch + (0xa5a4 - PATCH_BASE)
mov	x1, x0
mov	x0, x21
fmov	d0, d15
fmov	d1, d14
fmov	d2, d13
fmov	d3, d12
bl Lpatch + (0xa5d4 - PATCH_BASE)
mov	x2, x0
LFQH_Lloh6828:
adr x1, LFQH_GlyphOriginalKey
LFQH_Lloh6829:
nop
mov	x0, x19
mov	w3, #1
bl Lpatch + (0xa634 - PATCH_BASE)
LFQH_LBB399_4:
cbz	x20, LFQH_LBB399_9
LFQH_Lloh6830:
adr x0, LFQH_l_.str.432
LFQH_Lloh6831:
nop
bl Lpatch + (0xa5a4 - PATCH_BASE)
mov	x1, x0
mov	x0, x20
bl Lpatch + (0xa5d4 - PATCH_BASE)
fcmp	d11, d0
b.ne	LFQH_LBB399_9
fcmp	d10, d1
b.ne	LFQH_LBB399_9
fcmp	d9, d2
b.ne	LFQH_LBB399_9
fcmp	d8, d3
b.eq	LFQH_LBB399_10
LFQH_LBB399_9:
LFQH_Lloh6832:
adr x0, LFQH_l_.str.512
LFQH_Lloh6833:
nop
bl Lpatch + (0xa5b0 - PATCH_BASE)
mov	x20, x0
LFQH_Lloh6834:
adr x0, LFQH_l_.str.513
LFQH_Lloh6835:
nop
bl Lpatch + (0xa5a4 - PATCH_BASE)
mov	x1, x0
mov	x0, x20
fmov	d0, d11
fmov	d1, d10
fmov	d2, d9
fmov	d3, d8
bl Lpatch + (0xa5d4 - PATCH_BASE)
mov	x2, x0
LFQH_Lloh6836:
adr x1, LFQH_GlyphAppliedKey
LFQH_Lloh6837:
nop
mov	x0, x19
mov	w3, #1
bl Lpatch + (0xa634 - PATCH_BASE)
LFQH_LBB399_10:
LFQH_Lloh6838:
adr x0, LFQH_l_.str.156
LFQH_Lloh6839:
nop
bl Lpatch + (0xa5a4 - PATCH_BASE)
mov	x1, x0
mov	x0, x19
fmov	d0, d11
fmov	d1, d10
fmov	d2, d9
fmov	d3, d8
ldp	x29, x30, [sp, #96]
ldp	x20, x19, [sp, #80]
ldp	x22, x21, [sp, #64]
ldp	d9, d8, [sp, #48]
ldp	d11, d10, [sp, #32]
ldp	d13, d12, [sp, #16]
ldp	d15, d14, [sp], #112
b Lpatch + (0xa5d4 - PATCH_BASE)
LFQH_LBB399_11:
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
LFQH_Lloh6840:
adr x0, LFQH_l_.str.288
LFQH_Lloh6841:
nop
LFQH_Lloh6842:
adr x1, LFQH_l_.str.828
LFQH_Lloh6843:
nop
bl	LFQH_Original
mov	x8, x0
mov	x0, x19
mov	x1, x23
mov	x2, x22
mov	x3, x21
mov	x4, x20
blr	x8
fmov	d8, d0
fmov	d9, d1
LFQH_Lloh6844:
adr x1, LFQH_ShelfCompactKey
LFQH_Lloh6845:
nop
mov	x0, x19
bl Lpatch + (0xa628 - PATCH_BASE)
cbz	x0, LFQH_LBB400_5
fmov	d0, #1.00000000
fcmp	d9, d0
b.le	LFQH_LBB400_5
LFQH_Lloh6846:
adr x0, LFQH_l_.str.832
LFQH_Lloh6847:
nop
bl Lpatch + (0xa5a4 - PATCH_BASE)
mov	x1, x0
mov	x0, x20
bl Lpatch + (0xa5d4 - PATCH_BASE)
mov	x1, x0
mov	x0, x19
bl	LFQH_ShelfFunctionSection
cbz	w0, LFQH_LBB400_5
LFQH_Lloh6848:
adr x0, LFQH_l_.str.820
LFQH_Lloh6849:
nop
bl Lpatch + (0xa5b0 - PATCH_BASE)
mov	x19, x0
bl Lpatch + (0xa664 - PATCH_BASE)
LFQH_Lloh6850:
adr x1, LFQH_l_.str.825
LFQH_Lloh6851:
nop
LFQH_Lloh6852:
adr x2, LFQH_l_.str.826
LFQH_Lloh6853:
nop
bl	LFQH_ClassABI
cbz	w0, LFQH_LBB400_5
LFQH_Lloh6854:
adr x0, LFQH_l_.str.825
LFQH_Lloh6855:
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
LFQH_LBB400_5:
fmov	d0, d8
fmov	d1, d9
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
LFQH_Lloh6856:
adr x0, LFQH_l_.str.288
LFQH_Lloh6857:
nop
LFQH_Lloh6858:
adr x1, LFQH_l_.str.830
LFQH_Lloh6859:
nop
bl	LFQH_Original
mov	x8, x0
mov	x0, x20
mov	x1, x23
mov	x2, x22
mov	x3, x21
mov	x4, x19
blr	x8
fmov	d10, d0
fmov	d8, d1
fmov	d11, d2
fmov	d9, d3
LFQH_Lloh6860:
adr x1, LFQH_ShelfCompactKey
LFQH_Lloh6861:
nop
mov	x0, x20
bl Lpatch + (0xa628 - PATCH_BASE)
cbz	x0, LFQH_LBB401_4
mov	x21, x0
bl Lpatch + (0xa664 - PATCH_BASE)
LFQH_Lloh6862:
adr x1, LFQH_l_.str.824
LFQH_Lloh6863:
nop
LFQH_Lloh6864:
adr x2, LFQH_l_.str.149
LFQH_Lloh6865:
nop
bl	LFQH_ClassABI
cbz	w0, LFQH_LBB401_4
LFQH_Lloh6866:
adr x0, LFQH_l_.str.824
LFQH_Lloh6867:
nop
bl Lpatch + (0xa5a4 - PATCH_BASE)
mov	x1, x0
mov	x0, x21
bl Lpatch + (0xa5d4 - PATCH_BASE)
cbnz	w0, LFQH_LBB401_4
mov	x0, x20
mov	x1, x19
bl	LFQH_ShelfFunctionSection
cmp	w0, #0
fmov	d0, xzr
fcsel	d10, d10, d0, eq
fcsel	d11, d11, d0, eq
LFQH_LBB401_4:
fmov	d0, d10
fmov	d1, d8
fmov	d2, d11
fmov	d3, d9
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
LFQH_Lloh6868:
adr x0, LFQH_l_.str.820
LFQH_Lloh6869:
nop
LFQH_Lloh6870:
adr x1, LFQH_l_.str.530
LFQH_Lloh6871:
nop
bl	LFQH_Original
mov	x8, x0
mov	x0, x19
mov	x1, x20
blr	x8
LFQH_Lloh6872:
adr x1, LFQH_l_.str.120
LFQH_Lloh6873:
nop
mov	x0, x19
bl	LFQH_Get
LFQH_Lloh6874:
adr x1, LFQH_ShelfCompactKey
LFQH_Lloh6875:
nop
bl Lpatch + (0xa628 - PATCH_BASE)
cmp	x0, x19
b.eq	LFQH_LBB402_2
LFQH_LBB402_1:
ldp	x29, x30, [sp, #64]
ldp	x20, x19, [sp, #48]
ldp	d9, d8, [sp, #32]
ldp	d11, d10, [sp, #16]
ldp	d13, d12, [sp], #80
ret
LFQH_LBB402_2:
mov	x0, x19
bl Lpatch + (0xa664 - PATCH_BASE)
LFQH_Lloh6876:
adr x1, LFQH_l_.str.824
LFQH_Lloh6877:
nop
LFQH_Lloh6878:
adr x2, LFQH_l_.str.149
LFQH_Lloh6879:
nop
bl	LFQH_ClassABI
cbz	w0, LFQH_LBB402_1
LFQH_Lloh6880:
adr x1, LFQH_l_.str.834
LFQH_Lloh6881:
nop
mov	x0, x19
bl	LFQH_Get
mov	x20, x0
LFQH_Lloh6882:
adr x0, LFQH_l_.str.372
LFQH_Lloh6883:
nop
bl Lpatch + (0xa5a4 - PATCH_BASE)
mov	x1, x0
mov	x0, x20
bl Lpatch + (0xa5d4 - PATCH_BASE)
fmov	d8, d0
fmov	d12, d1
fmov	d9, d2
fmov	d10, d3
LFQH_Lloh6884:
adr x0, LFQH_l_.str.824
LFQH_Lloh6885:
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
b.le	LFQH_LBB402_1
LFQH_Lloh6886:
adr x0, LFQH_l_.str.156
LFQH_Lloh6887:
nop
bl Lpatch + (0xa5a4 - PATCH_BASE)
mov	x1, x0
mov	x0, x20
fmov	d0, d8
fmov	d1, d11
fmov	d2, d9
fmov	d3, d10
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
LFQH_Lloh6888:
adr x1, LFQH_l_.str.833
LFQH_Lloh6889:
nop
bl	LFQH_Get
mov	x20, x0
bl Lpatch + (0xa664 - PATCH_BASE)
LFQH_Lloh6890:
adr x1, LFQH_l_.str.822
LFQH_Lloh6891:
nop
LFQH_Lloh6892:
adr x2, LFQH_l_.str.823
LFQH_Lloh6893:
nop
bl	LFQH_ClassABI
cbz	w0, LFQH_LBB403_2
LFQH_Lloh6894:
adr x0, LFQH_l_.str.822
LFQH_Lloh6895:
nop
bl Lpatch + (0xa5a4 - PATCH_BASE)
mov	x1, x0
mov	x0, x20
mov	x2, x19
bl Lpatch + (0xa5d4 - PATCH_BASE)
cmp	x0, #1
cset	w0, eq
LFQH_LBB403_2:
ldp	x29, x30, [sp, #16]
ldp	x20, x19, [sp], #32
ret
.cfi_endproc
.p2align	2
LFQH_DramaDockBackground:
.cfi_startproc
sub	sp, sp, #96
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
mov	x20, x1
mov	x19, x0
LFQH_Lloh6896:
adr x0, LFQH_l_.str.835
LFQH_Lloh6897:
nop
LFQH_Lloh6898:
adr x1, LFQH_l_.str.836
LFQH_Lloh6899:
nop
bl	LFQH_Original
mov	x8, x0
mov	x0, x19
mov	x1, x20
blr	x8
mov	x20, x0
cbz	x0, LFQH_LBB404_21
LFQH_Lloh6900:
adr x0, LFQH_l_.str.837
LFQH_Lloh6901:
nop
bl Lpatch + (0xa5a4 - PATCH_BASE)
mov	x1, x0
mov	x0, x19
bl Lpatch + (0xa5d4 - PATCH_BASE)
cmp	x0, #4
b.ne	LFQH_LBB404_21
stp	xzr, xzr, [sp, #32]
stp	xzr, xzr, [sp, #16]
LFQH_Lloh6902:
adr x0, LFQH_l_.str.131
LFQH_Lloh6903:
nop
bl Lpatch + (0xa5a4 - PATCH_BASE)
mov	x1, x0
add	x2, sp, #40
add	x3, sp, #32
add	x4, sp, #24
add	x5, sp, #16
mov	x0, x20
bl Lpatch + (0xa5d4 - PATCH_BASE)
cbz	w0, LFQH_LBB404_12
ldr	d0, [sp, #16]
fmov	d1, #1.00000000
fcmp	d0, d1
b.ne	LFQH_LBB404_21
ldr	d0, [sp, #40]
fcmp	d0, #0.0
b.lt	LFQH_LBB404_21
fcmp	d0, d1
b.hi	LFQH_LBB404_21
mov	x8, #4643211215818981376
fmov	d1, x8
fmul	d0, d0, d1
fmov	d1, #0.50000000
fadd	d0, d0, d1
fcvtzs	w8, d0
cmp	w8, #29
b.ne	LFQH_LBB404_21
ldr	d0, [sp, #32]
fcmp	d0, #0.0
b.lt	LFQH_LBB404_21
fmov	d1, #1.00000000
fcmp	d0, d1
b.hi	LFQH_LBB404_21
mov	x8, #4643211215818981376
fmov	d1, x8
fmul	d0, d0, d1
fmov	d1, #0.50000000
fadd	d0, d0, d1
fcvtzs	w8, d0
cmp	w8, #29
b.ne	LFQH_LBB404_21
ldr	d0, [sp, #24]
fcmp	d0, #0.0
b.lt	LFQH_LBB404_21
fmov	d1, #1.00000000
b	LFQH_LBB404_15
LFQH_LBB404_12:
str	xzr, [sp, #8]
LFQH_Lloh6904:
adr x0, LFQH_l_.str.132
LFQH_Lloh6905:
nop
bl Lpatch + (0xa5a4 - PATCH_BASE)
mov	x1, x0
add	x2, sp, #8
add	x3, sp, #16
mov	x0, x20
bl Lpatch + (0xa5d4 - PATCH_BASE)
cbz	w0, LFQH_LBB404_21
ldr	d0, [sp, #16]
fmov	d1, #1.00000000
fcmp	d0, d1
b.ne	LFQH_LBB404_21
ldr	d0, [sp, #8]
fcmp	d0, #0.0
b.lt	LFQH_LBB404_21
LFQH_LBB404_15:
fcmp	d0, d1
b.hi	LFQH_LBB404_21
mov	x8, #4643211215818981376
fmov	d1, x8
fmul	d0, d0, d1
fmov	d1, #0.50000000
fadd	d0, d0, d1
fcvtzs	w8, d0
cmp	w8, #29
b.ne	LFQH_LBB404_21
bl	LFQH_Enabled
cbz	w0, LFQH_LBB404_21
LFQH_Lloh6906:
adr x1, LFQH_DramaDockLogKey
LFQH_Lloh6907:
nop
mov	x0, x19
bl Lpatch + (0xa628 - PATCH_BASE)
cbnz	x0, LFQH_LBB404_20
LFQH_Lloh6908:
adr x20, LFQH_l_.str.497
LFQH_Lloh6909:
nop
mov	x0, x20
bl Lpatch + (0xa5b0 - PATCH_BASE)
mov	x21, x0
LFQH_Lloh6910:
adr x0, LFQH_l_.str.499
LFQH_Lloh6911:
nop
bl Lpatch + (0xa5a4 - PATCH_BASE)
mov	x1, x0
mov	x0, x21
mov	w2, #1
bl Lpatch + (0xa5d4 - PATCH_BASE)
mov	x2, x0
LFQH_Lloh6912:
adr x1, LFQH_DramaDockLogKey
LFQH_Lloh6913:
nop
mov	x0, x19
mov	w3, #1
bl Lpatch + (0xa634 - PATCH_BASE)
LFQH_Lloh6914:
adr x0, LFQH_l_.str.88
LFQH_Lloh6915:
nop
bl Lpatch + (0xa5b0 - PATCH_BASE)
mov	x19, x0
LFQH_Lloh6916:
adr x0, LFQH_l_.str.89
LFQH_Lloh6917:
nop
bl Lpatch + (0xa5a4 - PATCH_BASE)
mov	x1, x0
mov	x0, x19
bl Lpatch + (0xa5d4 - PATCH_BASE)
mov	x19, x0
mov	x0, x20
bl Lpatch + (0xa5b0 - PATCH_BASE)
mov	x20, x0
LFQH_Lloh6918:
adr x0, LFQH_l_.str.515
LFQH_Lloh6919:
nop
bl Lpatch + (0xa5a4 - PATCH_BASE)
mov	x1, x0
fmov	d0, #4.00000000
mov	x0, x20
bl Lpatch + (0xa5d4 - PATCH_BASE)
mov	x2, x0
LFQH_Lloh6920:
adr x1, LFQH_l_.str.837
LFQH_Lloh6921:
nop
mov	x0, x19
bl	LFQH_Put
LFQH_Lloh6922:
adr x20, LFQH_l_.str.361
LFQH_Lloh6923:
nop
mov	x0, x20
bl Lpatch + (0xa5b0 - PATCH_BASE)
mov	x21, x0
LFQH_Lloh6924:
adr x22, LFQH_l_.str.387
LFQH_Lloh6925:
nop
mov	x0, x22
bl Lpatch + (0xa5a4 - PATCH_BASE)
mov	x1, x0
LFQH_Lloh6926:
adr x2, LFQH_l_.str.843
LFQH_Lloh6927:
nop
mov	x0, x21
bl Lpatch + (0xa5d4 - PATCH_BASE)
mov	x2, x0
LFQH_Lloh6928:
adr x1, LFQH_l_.str.788
LFQH_Lloh6929:
nop
mov	x0, x19
bl	LFQH_Put
mov	x0, x20
bl Lpatch + (0xa5b0 - PATCH_BASE)
mov	x20, x0
mov	x0, x22
bl Lpatch + (0xa5a4 - PATCH_BASE)
mov	x1, x0
LFQH_Lloh6930:
adr x2, LFQH_l_.str.844
LFQH_Lloh6931:
nop
mov	x0, x20
bl Lpatch + (0xa5d4 - PATCH_BASE)
mov	x2, x0
LFQH_Lloh6932:
adr x1, LFQH_l_.str.582
LFQH_Lloh6933:
nop
mov	x0, x19
bl	LFQH_Put
LFQH_Lloh6934:
adr x0, LFQH_l_.str.845
LFQH_Lloh6935:
nop
mov	x1, x19
bl Lrecord_named
LFQH_LBB404_20:
LFQH_Lloh6936:
adr x0, LFQH_l_.str.47
LFQH_Lloh6937:
nop
bl Lpatch + (0xa5b0 - PATCH_BASE)
mov	x19, x0
LFQH_Lloh6938:
adr x0, LFQH_l_.str.846
LFQH_Lloh6939:
nop
bl Lpatch + (0xa5a4 - PATCH_BASE)
mov	x1, x0
mov	x0, x19
bl Lpatch + (0xa5d4 - PATCH_BASE)
mov	x20, x0
LFQH_LBB404_21:
mov	x0, x20
ldp	x29, x30, [sp, #80]
ldp	x20, x19, [sp, #64]
ldp	x22, x21, [sp, #48]
add	sp, sp, #96
ret
.cfi_endproc
.p2align	2
LFQH_DramaDockLogKey:
.cfi_startproc
ret
.cfi_endproc
.p2align	2
LFQH_ReaderThemeLaunchKey:
.cfi_startproc
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
LFQH_Lloh6940:
adr x1, LFQH_l_.str.850
LFQH_Lloh6941:
nop
bl	LFQH_Get
mov	x19, x0
LFQH_Lloh6942:
adr x1, LFQH_l_.str.138
LFQH_Lloh6943:
nop
bl	LFQH_Kind
cmp	w0, #0
ccmp	x19, #0, #4, ne
b.ne	LFQH_LBB407_2
LFQH_LBB407_1:
ldp	x29, x30, [sp, #48]
ldp	x20, x19, [sp, #32]
ldp	x22, x21, [sp, #16]
ldp	x24, x23, [sp], #64
ret
LFQH_LBB407_2:
mov	w22, #0
LFQH_Lloh6944:
adr x21, LFQH_l_.str.20
LFQH_Lloh6945:
nop
mov	x0, x19
LFQH_LBB407_3:
cmp	x0, x20
b.eq	LFQH_LBB407_6
mov	x1, x21
bl	LFQH_Get
cbz	x0, LFQH_LBB407_1
add	w8, w22, #1
cmp	w22, #7
mov	x22, x8
b.lo	LFQH_LBB407_3
b	LFQH_LBB407_1
LFQH_LBB407_6:
LFQH_Lloh6946:
adr x0, LFQH_l_.str.851
LFQH_Lloh6947:
nop
bl Lpatch + (0xa5a4 - PATCH_BASE)
mov	x1, x0
mov	x0, x19
mov	x2, #0
bl Lpatch + (0xa5d4 - PATCH_BASE)
mov	x20, x0
LFQH_Lloh6948:
adr x1, LFQH_SpeechGlyphKey
LFQH_Lloh6949:
nop
mov	x0, x19
bl Lpatch + (0xa628 - PATCH_BASE)
mov	x21, x0
LFQH_Lloh6950:
adr x0, LFQH_l_.str.47
LFQH_Lloh6951:
nop
bl Lpatch + (0xa5b0 - PATCH_BASE)
mov	x22, x0
LFQH_Lloh6952:
adr x0, LFQH_l_.str.48
LFQH_Lloh6953:
nop
bl Lpatch + (0xa5a4 - PATCH_BASE)
mov	x1, x0
mov	x0, x22
bl Lpatch + (0xa5d4 - PATCH_BASE)
mov	x22, x0
LFQH_Lloh6954:
adr x1, LFQH_l_.str.141
LFQH_Lloh6955:
nop
mov	x0, x19
bl	LFQH_Get
mov	x24, x0
LFQH_Lloh6956:
adr x0, LFQH_l_.str.49
LFQH_Lloh6957:
nop
bl Lpatch + (0xa5a4 - PATCH_BASE)
mov	x1, x0
mov	x0, x24
mov	x2, x22
bl Lpatch + (0xa5d4 - PATCH_BASE)
mov	x23, x0
bl	LFQH_Enabled
cbz	w0, LFQH_LBB407_21
bl	LFQH_FQHGlassAvailable
cbz	w0, LFQH_LBB407_21
LFQH_Lloh6958:
adr x0, LFQH_l_.str.24
LFQH_Lloh6959:
nop
bl Lpatch + (0xa5a4 - PATCH_BASE)
mov	x1, x0
mov	x0, x19
bl Lpatch + (0xa5d4 - PATCH_BASE)
fmov	x9, d2
fmov	x8, d1
fmov	x10, d0
and	x10, x10, #0x7fffffffffffffff
and	x8, x8, #0x7fffffffffffffff
mov	x11, #9218868437227405311
cmp	x8, x11
cset	w8, gt
and	x9, x9, #0x7fffffffffffffff
cmp	x9, x11
cset	w9, gt
cmp	x10, x11
b.gt	LFQH_LBB407_21
tbnz	w8, #0, LFQH_LBB407_21
tbnz	w9, #0, LFQH_LBB407_21
fmov	x8, d3
and	x8, x8, #0x7fffffffffffffff
mov	x9, #9218868437227405311
cmp	x8, x9
b.gt	LFQH_LBB407_21
fcmp	d2, #0.0
b.le	LFQH_LBB407_21
fcmp	d3, #0.0
b.le	LFQH_LBB407_21
cbnz	x21, LFQH_LBB407_16
LFQH_Lloh6960:
adr x0, LFQH_l_.str.852
LFQH_Lloh6961:
nop
bl Lpatch + (0xa5b0 - PATCH_BASE)
LFQH_Lloh6962:
adr x1, LFQH_l_.str.853
LFQH_Lloh6963:
nop
bl	LFQH_Get
mov	x21, x0
LFQH_Lloh6964:
adr x0, LFQH_l_.str.854
LFQH_Lloh6965:
nop
bl Lpatch + (0xa5a4 - PATCH_BASE)
mov	x1, x0
mov	x0, x21
mov	w2, #2
bl Lpatch + (0xa5d4 - PATCH_BASE)
mov	x21, x0
cbz	x0, LFQH_LBB407_1
LFQH_LBB407_16:
mov	x0, x19
bl	LFQH_FQHApply
LFQH_Lloh6966:
adr x1, LFQH_SurfaceKey
LFQH_Lloh6967:
nop
mov	x0, x19
bl Lpatch + (0xa628 - PATCH_BASE)
cbz	x0, LFQH_LBB407_1
cbnz	w23, LFQH_LBB407_19
LFQH_Lloh6968:
adr x1, LFQH_SpeechTintKey
LFQH_Lloh6969:
nop
mov	x0, x19
mov	x2, x24
mov	w3, #1
bl Lpatch + (0xa634 - PATCH_BASE)
LFQH_Lloh6970:
adr x0, LFQH_l_.str.54
LFQH_Lloh6971:
nop
bl Lpatch + (0xa5a4 - PATCH_BASE)
mov	x1, x0
mov	x0, x19
mov	x2, x22
bl Lpatch + (0xa5d4 - PATCH_BASE)
LFQH_LBB407_19:
cmp	x20, x21
b.eq	LFQH_LBB407_1
LFQH_Lloh6972:
adr x1, LFQH_SpeechImageKey
LFQH_Lloh6973:
nop
mov	x0, x19
mov	x2, x20
mov	w3, #1
bl Lpatch + (0xa634 - PATCH_BASE)
LFQH_Lloh6974:
adr x1, LFQH_SpeechGlyphKey
LFQH_Lloh6975:
nop
mov	x0, x19
mov	x2, x21
mov	w3, #1
bl Lpatch + (0xa634 - PATCH_BASE)
LFQH_Lloh6976:
adr x0, LFQH_l_.str.855
LFQH_Lloh6977:
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
LFQH_LBB407_21:
cbz	x21, LFQH_LBB407_28
cmp	x20, x21
b.ne	LFQH_LBB407_24
LFQH_Lloh6978:
adr x1, LFQH_SpeechImageKey
LFQH_Lloh6979:
nop
mov	x0, x19
bl Lpatch + (0xa628 - PATCH_BASE)
mov	x20, x0
LFQH_Lloh6980:
adr x0, LFQH_l_.str.855
LFQH_Lloh6981:
nop
bl Lpatch + (0xa5a4 - PATCH_BASE)
mov	x1, x0
mov	x0, x19
mov	x2, x20
mov	x3, #0
bl Lpatch + (0xa5d4 - PATCH_BASE)
LFQH_LBB407_24:
LFQH_Lloh6982:
adr x1, LFQH_SpeechTintKey
LFQH_Lloh6983:
nop
mov	x0, x19
bl Lpatch + (0xa628 - PATCH_BASE)
cbz	w23, LFQH_LBB407_27
mov	x20, x0
cbz	x0, LFQH_LBB407_27
LFQH_Lloh6984:
adr x0, LFQH_l_.str.54
LFQH_Lloh6985:
nop
bl Lpatch + (0xa5a4 - PATCH_BASE)
mov	x1, x0
mov	x0, x19
mov	x2, x20
bl Lpatch + (0xa5d4 - PATCH_BASE)
LFQH_LBB407_27:
LFQH_Lloh6986:
adr x1, LFQH_SpeechImageKey
LFQH_Lloh6987:
nop
mov	x0, x19
mov	x2, #0
mov	w3, #1
bl Lpatch + (0xa634 - PATCH_BASE)
LFQH_Lloh6988:
adr x1, LFQH_SpeechGlyphKey
LFQH_Lloh6989:
nop
mov	x0, x19
mov	x2, #0
mov	w3, #1
bl Lpatch + (0xa634 - PATCH_BASE)
LFQH_Lloh6990:
adr x1, LFQH_SpeechTintKey
LFQH_Lloh6991:
nop
mov	x0, x19
mov	x2, #0
mov	w3, #1
bl Lpatch + (0xa634 - PATCH_BASE)
LFQH_LBB407_28:
LFQH_Lloh6992:
adr x1, LFQH_SurfaceKey
LFQH_Lloh6993:
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
LFQH_Lloh6994:
adr x1, LFQH_l_.str.856
LFQH_Lloh6995:
nop
bl	LFQH_Get
mov	x25, x0
LFQH_Lloh6996:
adr x1, LFQH_l_.str.20
LFQH_Lloh6997:
nop
bl	LFQH_Get
mov	x20, x0
LFQH_Lloh6998:
adr x1, LFQH_l_.str.687
LFQH_Lloh6999:
nop
mov	x0, x19
bl	LFQH_Get
mov	x23, x0
mov	x0, x19
mov	x1, x23
bl	LFQH_BookstoreCurrentTab
mov	x26, x0
LFQH_Lloh7000:
adr x1, LFQH_l_.str.857
LFQH_Lloh7001:
nop
mov	x0, x19
bl	LFQH_Get
str	x0, [sp, #24]
LFQH_Lloh7002:
adr x1, LFQH_l_.str.864
LFQH_Lloh7003:
nop
mov	x0, x26
bl	LFQH_Get
mov	x21, x0
mov	x0, x23
mov	x1, x21
bl	LFQH_TopChromeContains
cbnz	w0, LFQH_LBB411_4
LFQH_Lloh7004:
adr x1, LFQH_l_.str.533
LFQH_Lloh7005:
nop
mov	x0, x26
bl	LFQH_Get
mov	x21, x0
mov	x0, x23
mov	x1, x21
bl	LFQH_TopChromeContains
cbnz	w0, LFQH_LBB411_4
LFQH_Lloh7006:
adr x1, LFQH_l_.str.865
LFQH_Lloh7007:
nop
mov	x0, x26
bl	LFQH_Get
mov	x21, x0
mov	x0, x23
mov	x1, x21
bl	LFQH_TopChromeContains
cbnz	w0, LFQH_LBB411_4
LFQH_Lloh7008:
adr x1, LFQH_l_.str.866
LFQH_Lloh7009:
nop
mov	x0, x26
bl	LFQH_Get
mov	x21, x0
mov	x0, x23
mov	x1, x21
bl	LFQH_TopChromeContains
cmp	w0, #0
csel	x21, xzr, x21, eq
LFQH_LBB411_4:
LFQH_Lloh7010:
adr x1, LFQH_l_.str.867
LFQH_Lloh7011:
nop
mov	x0, x26
bl	LFQH_Get
mov	x22, x0
LFQH_Lloh7012:
adr x1, LFQH_l_.str.257
LFQH_Lloh7013:
nop
bl	LFQH_Kind
cbz	w0, LFQH_LBB411_6
mov	x0, x22
mov	x1, x21
bl	LFQH_TopChromeContains
cbnz	w0, LFQH_LBB411_10
LFQH_LBB411_6:
LFQH_Lloh7014:
adr x1, LFQH_l_.str.306
LFQH_Lloh7015:
nop
mov	x0, x26
bl	LFQH_Kind
cbz	x21, LFQH_LBB411_9
cbz	w0, LFQH_LBB411_9
LFQH_Lloh7016:
adr x1, LFQH_l_.str.20
LFQH_Lloh7017:
nop
mov	x0, x21
bl	LFQH_Get
mov	x22, x0
LFQH_Lloh7018:
adr x1, LFQH_l_.str.353
LFQH_Lloh7019:
nop
mov	x0, x26
bl	LFQH_Get
cmp	x22, x0
b.eq	LFQH_LBB411_38
LFQH_LBB411_9:
mov	x22, x23
LFQH_LBB411_10:
LFQH_Lloh7020:
adr x27, LFQH_l_.str.20
LFQH_Lloh7021:
nop
mov	x0, x22
mov	x1, x27
bl	LFQH_Get
mov	x24, x0
LFQH_Lloh7022:
adr x28, LFQH_l_.str.372
LFQH_Lloh7023:
nop
mov	x0, x28
bl Lpatch + (0xa5a4 - PATCH_BASE)
mov	x1, x0
mov	x0, x25
bl Lpatch + (0xa5d4 - PATCH_BASE)
fmov	d12, d1
fmov	d13, d3
LFQH_Lloh7024:
adr x26, LFQH_l_.str.24
LFQH_Lloh7025:
nop
mov	x0, x26
bl Lpatch + (0xa5a4 - PATCH_BASE)
mov	x1, x0
mov	x0, x20
bl Lpatch + (0xa5d4 - PATCH_BASE)
stp	d1, d0, [sp, #8]
fmov	d10, d2
fmov	d11, d3
mov	x0, x26
bl Lpatch + (0xa5a4 - PATCH_BASE)
mov	x1, x0
ldr	x26, [sp, #24]
mov	x0, x26
bl Lpatch + (0xa5d4 - PATCH_BASE)
fmov	d14, d0
fmov	d15, d1
fmov	d8, d2
fmov	d9, d3
LFQH_Lloh7026:
adr x0, LFQH_l_.str.507
LFQH_Lloh7027:
nop
bl Lpatch + (0xa5a4 - PATCH_BASE)
mov	x1, x0
mov	x0, x26
fmov	d0, d14
fmov	d1, d15
fmov	d2, d8
fmov	d3, d9
mov	x2, x20
bl Lpatch + (0xa5d4 - PATCH_BASE)
fmov	d8, d1
fmov	d9, d3
mov	x0, x28
bl Lpatch + (0xa5a4 - PATCH_BASE)
mov	x1, x0
mov	x0, x23
bl Lpatch + (0xa5d4 - PATCH_BASE)
mov	x0, x23
bl	LFQH_TopChromeStockFrame
fmov	d14, d1
fadd	d0, d12, d13
fadd	d1, d8, d9
fmaxnm	d8, d0, d1
mov	x0, x23
mov	x1, x27
bl	LFQH_Get
fmaxnm	d0, d8, d14
cmp	x0, x20
fcsel	d8, d0, d8, eq
cbz	x20, LFQH_LBB411_17
bl	LFQH_Enabled
mov	w3, #0
cbz	w0, LFQH_LBB411_18
mov	x28, x24
fmov	d9, d11
ldp	d13, d11, [sp, #8]
cbz	x23, LFQH_LBB411_19
mov	w26, #0
mov	x0, x23
LFQH_LBB411_14:
cmp	x0, x20
b.eq	LFQH_LBB411_36
mov	x1, x27
bl	LFQH_Get
mov	w3, #0
cbz	x0, LFQH_LBB411_19
add	w8, w26, #1
cmp	w26, #7
mov	x26, x8
b.lo	LFQH_LBB411_14
b	LFQH_LBB411_19
LFQH_LBB411_17:
mov	w3, #0
LFQH_LBB411_18:
mov	x28, x24
fmov	d9, d11
ldp	d13, d11, [sp, #8]
LFQH_LBB411_19:
fsub	d3, d8, d13
mov	x0, x20
mov	x1, x25
mov	x2, x21
fmov	d0, d11
fmov	d1, d13
fmov	d2, d10
bl	LFQH_TopChromePage
mov	x27, x0
mov	x0, x25
mov	x1, x27
bl	LFQH_TopChromeFill
LFQH_Lloh7028:
adr x1, LFQH_l_.str.858
LFQH_Lloh7029:
nop
mov	x0, x19
bl	LFQH_Get
mov	x1, x27
bl	LFQH_TopChromeFill
LFQH_Lloh7030:
adr x1, LFQH_l_.str.859
LFQH_Lloh7031:
nop
mov	x0, x19
bl	LFQH_Get
mov	x1, x27
bl	LFQH_TopChromeFill
ldr	x24, [sp, #24]
mov	x0, x24
mov	x1, x27
bl	LFQH_TopChromeFill
LFQH_Lloh7032:
adr x1, LFQH_l_.str.533
LFQH_Lloh7033:
nop
mov	x0, x24
bl	LFQH_Get
mov	x1, x27
bl	LFQH_TopChromeFill
LFQH_Lloh7034:
adr x1, LFQH_l_.str.860
LFQH_Lloh7035:
nop
mov	x0, x19
bl	LFQH_Get
mov	x1, x23
mov	x2, x27
bl	LFQH_TopChromeArtwork
LFQH_Lloh7036:
adr x1, LFQH_BookstoreViewportKey
LFQH_Lloh7037:
nop
mov	x0, x19
bl Lpatch + (0xa628 - PATCH_BASE)
cmp	w27, #0
csel	x24, xzr, x22, eq
cmp	x0, x24
b.eq	LFQH_LBB411_23
mov	x23, x0
LFQH_Lloh7038:
adr x0, LFQH_l_.str.861
LFQH_Lloh7039:
nop
bl Lpatch + (0xa5a4 - PATCH_BASE)
mov	x1, x0
mov	x0, x23
bl Lpatch + (0xa5d4 - PATCH_BASE)
LFQH_Lloh7040:
adr x1, LFQH_BookstoreViewportKey
LFQH_Lloh7041:
nop
mov	x0, x19
mov	x2, x24
mov	w3, #1
bl Lpatch + (0xa634 - PATCH_BASE)
cbz	x23, LFQH_LBB411_22
fmov	d0, xzr
mov	x0, x23
mov	x1, #0
mov	w2, #0
bl	LFQH_TopChromeUnderlap
LFQH_LBB411_22:
LFQH_Lloh7042:
adr x0, LFQH_l_.str.56
LFQH_Lloh7043:
nop
bl Lpatch + (0xa5a4 - PATCH_BASE)
mov	x1, x0
mov	x0, x23
bl Lpatch + (0xa5d4 - PATCH_BASE)
LFQH_LBB411_23:
LFQH_Lloh7044:
adr x0, LFQH_l_.str.507
LFQH_Lloh7045:
nop
bl Lpatch + (0xa5a4 - PATCH_BASE)
mov	x1, x0
mov	x0, x20
fmov	d0, d11
fmov	d1, d13
fmov	d2, d10
fmov	d3, d9
mov	x2, x28
bl Lpatch + (0xa5d4 - PATCH_BASE)
fmov	d0, d1
mov	x0, x22
mov	x1, x21
mov	x2, x27
bl	LFQH_TopChromeUnderlap
LFQH_Lloh7046:
adr x1, LFQH_BookstoreUnexpandedScrollKey
LFQH_Lloh7047:
nop
mov	x0, x19
bl Lpatch + (0xa628 - PATCH_BASE)
mov	x23, x0
cbz	w27, LFQH_LBB411_25
LFQH_Lloh7048:
adr x1, LFQH_TopChromeFrameKey
LFQH_Lloh7049:
nop
mov	x0, x22
bl Lpatch + (0xa628 - PATCH_BASE)
cbz	x0, LFQH_LBB411_27
LFQH_LBB411_25:
cbz	x23, LFQH_LBB411_35
LFQH_Lloh7050:
adr x1, LFQH_BookstoreUnexpandedFrameKey
LFQH_Lloh7051:
nop
mov	x0, x19
mov	x2, #0
mov	w3, #1
bl Lpatch + (0xa634 - PATCH_BASE)
mov	x2, #0
b	LFQH_LBB411_34
LFQH_LBB411_27:
LFQH_Lloh7052:
adr x0, LFQH_l_.str.372
LFQH_Lloh7053:
nop
bl Lpatch + (0xa5a4 - PATCH_BASE)
mov	x1, x0
mov	x0, x22
bl Lpatch + (0xa5d4 - PATCH_BASE)
fmov	d8, d0
fmov	d9, d1
fmov	d10, d2
fmov	d11, d3
LFQH_Lloh7054:
adr x1, LFQH_BookstoreUnexpandedFrameKey
LFQH_Lloh7055:
nop
mov	x0, x19
bl Lpatch + (0xa628 - PATCH_BASE)
cbz	x0, LFQH_LBB411_32
mov	x24, x0
LFQH_Lloh7056:
adr x0, LFQH_l_.str.432
LFQH_Lloh7057:
nop
bl Lpatch + (0xa5a4 - PATCH_BASE)
mov	x1, x0
mov	x0, x24
bl Lpatch + (0xa5d4 - PATCH_BASE)
fcmp	d8, d0
b.ne	LFQH_LBB411_32
fcmp	d9, d1
b.ne	LFQH_LBB411_32
fcmp	d10, d2
b.ne	LFQH_LBB411_32
fcmp	d11, d3
b.eq	LFQH_LBB411_33
LFQH_LBB411_32:
LFQH_Lloh7058:
adr x0, LFQH_l_.str.512
LFQH_Lloh7059:
nop
bl Lpatch + (0xa5b0 - PATCH_BASE)
mov	x24, x0
LFQH_Lloh7060:
adr x0, LFQH_l_.str.513
LFQH_Lloh7061:
nop
bl Lpatch + (0xa5a4 - PATCH_BASE)
mov	x1, x0
mov	x0, x24
fmov	d0, d8
fmov	d1, d9
fmov	d2, d10
fmov	d3, d11
bl Lpatch + (0xa5d4 - PATCH_BASE)
mov	x2, x0
LFQH_Lloh7062:
adr x1, LFQH_BookstoreUnexpandedFrameKey
LFQH_Lloh7063:
nop
mov	x0, x19
mov	w3, #1
bl Lpatch + (0xa634 - PATCH_BASE)
LFQH_LBB411_33:
mov	x2, x21
cmp	x23, x21
b.eq	LFQH_LBB411_35
LFQH_LBB411_34:
LFQH_Lloh7064:
adr x1, LFQH_BookstoreUnexpandedScrollKey
LFQH_Lloh7065:
nop
mov	x0, x19
mov	w3, #1
bl Lpatch + (0xa634 - PATCH_BASE)
LFQH_LBB411_35:
mov	x0, x21
bl	LFQH_TopChromeRefreshVisibility
LFQH_Lloh7066:
adr x1, LFQH_l_.str.862
LFQH_Lloh7067:
nop
mov	x0, x19
mov	x2, x20
mov	x3, x22
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
LFQH_LBB411_36:
cbz	x21, LFQH_LBB411_39
LFQH_Lloh7068:
adr x0, LFQH_l_.str.71
LFQH_Lloh7069:
nop
bl Lpatch + (0xa5a4 - PATCH_BASE)
mov	x1, x0
mov	x0, x25
bl Lpatch + (0xa5d4 - PATCH_BASE)
cmp	w0, #0
cset	w3, eq
b	LFQH_LBB411_19
LFQH_LBB411_38:
LFQH_Lloh7070:
adr x22, LFQH_l_.str.24
LFQH_Lloh7071:
nop
mov	x0, x22
bl Lpatch + (0xa5a4 - PATCH_BASE)
mov	x1, x0
mov	x0, x23
bl Lpatch + (0xa5d4 - PATCH_BASE)
fmov	d8, d0
fmov	d9, d1
fmov	d10, d2
fmov	d11, d3
LFQH_Lloh7072:
adr x0, LFQH_l_.str.507
LFQH_Lloh7073:
nop
bl Lpatch + (0xa5a4 - PATCH_BASE)
mov	x1, x0
mov	x0, x23
fmov	d0, d8
fmov	d1, d9
fmov	d2, d10
fmov	d3, d11
mov	x2, x20
bl Lpatch + (0xa5d4 - PATCH_BASE)
fmov	d8, d1
mov	x0, x22
bl Lpatch + (0xa5a4 - PATCH_BASE)
mov	x1, x0
mov	x0, x20
bl Lpatch + (0xa5d4 - PATCH_BASE)
fcmp	d8, d1
mov	x22, x21
b.eq	LFQH_LBB411_10
b	LFQH_LBB411_9
LFQH_LBB411_39:
mov	w3, #0
b	LFQH_LBB411_19
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
LFQH_Lloh7074:
adr x1, LFQH_l_.str.863
LFQH_Lloh7075:
nop
mov	x0, x8
bl	LFQH_Get
cbz	x0, LFQH_LBB412_2
ldp	x29, x30, [sp, #16]
ldp	x20, x19, [sp], #32
ret
LFQH_LBB412_2:
LFQH_Lloh7076:
adr x1, LFQH_l_.str.550
LFQH_Lloh7077:
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
LFQH_Lloh7078:
adr x1, LFQH_l_.str.23
LFQH_Lloh7079:
nop
bl	LFQH_Kind
cbz	w0, LFQH_LBB413_14
LFQH_Lloh7080:
adr x1, LFQH_l_.str.20
LFQH_Lloh7081:
nop
mov	x0, x19
bl	LFQH_Get
mov	w23, #0
cbz	w21, LFQH_LBB413_6
mov	x22, x0
cbz	x0, LFQH_LBB413_6
LFQH_Lloh7082:
adr x1, LFQH_l_.str.20
LFQH_Lloh7083:
nop
mov	x0, x20
bl	LFQH_Get
cmp	x0, x22
b.eq	LFQH_LBB413_5
mov	w23, #0
b	LFQH_LBB413_6
LFQH_LBB413_5:
LFQH_Lloh7084:
adr x1, LFQH_l_.str.414
LFQH_Lloh7085:
nop
mov	x0, x22
bl	LFQH_Get
mov	x21, x0
LFQH_Lloh7086:
adr x0, LFQH_l_.str.868
LFQH_Lloh7087:
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
LFQH_LBB413_6:
LFQH_Lloh7088:
adr x0, LFQH_l_.str.477
LFQH_Lloh7089:
nop
bl Lpatch + (0xa5a4 - PATCH_BASE)
mov	x1, x0
mov	x0, x19
bl Lpatch + (0xa5d4 - PATCH_BASE)
fmov	d8, d0
LFQH_Lloh7090:
adr x1, LFQH_TopChromeArtworkAlphaKey
LFQH_Lloh7091:
nop
mov	x0, x19
bl Lpatch + (0xa628 - PATCH_BASE)
mov	x20, x0
cbz	w23, LFQH_LBB413_9
fmov	d0, #0.25000000
fcmp	d8, d0
b.le	LFQH_LBB413_9
LFQH_Lloh7092:
adr x0, LFQH_l_.str.497
LFQH_Lloh7093:
nop
bl Lpatch + (0xa5b0 - PATCH_BASE)
mov	x20, x0
LFQH_Lloh7094:
adr x0, LFQH_l_.str.515
LFQH_Lloh7095:
nop
bl Lpatch + (0xa5a4 - PATCH_BASE)
mov	x1, x0
mov	x0, x20
fmov	d0, d8
bl Lpatch + (0xa5d4 - PATCH_BASE)
mov	x2, x0
LFQH_Lloh7096:
adr x1, LFQH_TopChromeArtworkAlphaKey
LFQH_Lloh7097:
nop
mov	x0, x19
mov	w3, #1
bl Lpatch + (0xa634 - PATCH_BASE)
LFQH_Lloh7098:
adr x0, LFQH_l_.str.712
LFQH_Lloh7099:
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
LFQH_LBB413_9:
tbnz	w23, #0, LFQH_LBB413_14
cbz	x20, LFQH_LBB413_14
fmov	d0, #0.25000000
fcmp	d8, d0
b.ne	LFQH_LBB413_13
LFQH_Lloh7100:
adr x0, LFQH_l_.str.712
LFQH_Lloh7101:
nop
bl Lpatch + (0xa5a4 - PATCH_BASE)
mov	x21, x0
LFQH_Lloh7102:
adr x0, LFQH_l_.str.445
LFQH_Lloh7103:
nop
bl Lpatch + (0xa5a4 - PATCH_BASE)
mov	x1, x0
mov	x0, x20
bl Lpatch + (0xa5d4 - PATCH_BASE)
mov	x0, x19
mov	x1, x21
bl Lpatch + (0xa5d4 - PATCH_BASE)
LFQH_LBB413_13:
LFQH_Lloh7104:
adr x1, LFQH_TopChromeArtworkAlphaKey
LFQH_Lloh7105:
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
LFQH_LBB413_14:
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
LFQH_BookstoreUnexpandedScrollKey:
.cfi_startproc
ret
.cfi_endproc
.p2align	2
LFQH_BookstoreUnexpandedFrameKey:
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
LFQH_Lloh7106:
adr x1, LFQH_l_.str.351
LFQH_Lloh7107:
nop
bl	LFQH_Get
mov	x20, x0
LFQH_Lloh7108:
adr x1, LFQH_l_.str.526
LFQH_Lloh7109:
nop
mov	x0, x19
bl	LFQH_Get
mov	x24, x0
LFQH_Lloh7110:
adr x1, LFQH_l_.str.687
LFQH_Lloh7111:
nop
mov	x0, x19
bl	LFQH_Get
mov	x21, x0
LFQH_Lloh7112:
adr x1, LFQH_l_.str.550
LFQH_Lloh7113:
nop
mov	x0, x19
bl	LFQH_Get
mov	x23, x0
LFQH_Lloh7114:
adr x1, LFQH_l_.str.533
LFQH_Lloh7115:
nop
bl	LFQH_Get
mov	x22, x0
mov	x0, x23
bl	LFQH_BookshelfSectionPinning
LFQH_Lloh7116:
adr x25, LFQH_l_.str.372
LFQH_Lloh7117:
nop
mov	x0, x25
bl Lpatch + (0xa5a4 - PATCH_BASE)
mov	x1, x0
mov	x0, x24
bl Lpatch + (0xa5d4 - PATCH_BASE)
fmov	d11, d1
fmov	d12, d3
LFQH_Lloh7118:
adr x0, LFQH_l_.str.24
LFQH_Lloh7119:
nop
bl Lpatch + (0xa5a4 - PATCH_BASE)
mov	x1, x0
mov	x0, x20
bl Lpatch + (0xa5d4 - PATCH_BASE)
fmov	d9, d0
fmov	d8, d1
fmov	d10, d2
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
cbz	w0, LFQH_LBB418_3
LFQH_Lloh7120:
adr x1, LFQH_l_.str.288
LFQH_Lloh7121:
nop
mov	x0, x23
bl	LFQH_Kind
cbz	w0, LFQH_LBB418_3
LFQH_Lloh7122:
adr x1, LFQH_l_.str.20
LFQH_Lloh7123:
nop
mov	x0, x21
bl	LFQH_Get
cmp	x0, x20
b.eq	LFQH_LBB418_10
LFQH_LBB418_3:
mov	w3, #0
LFQH_LBB418_4:
mov	x0, x20
mov	x1, x24
mov	x2, x22
fmov	d0, d9
fmov	d1, d8
fmov	d2, d10
fmov	d3, d11
bl	LFQH_TopChromePage
mov	x25, x0
LFQH_Lloh7124:
adr x1, LFQH_l_.str.552
LFQH_Lloh7125:
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
LFQH_Lloh7126:
adr x1, LFQH_l_.str.533
LFQH_Lloh7127:
nop
mov	x0, x26
bl	LFQH_Get
mov	x1, x25
bl	LFQH_TopChromeFill
LFQH_Lloh7128:
adr x1, LFQH_l_.str.869
LFQH_Lloh7129:
nop
mov	x0, x19
bl	LFQH_Get
mov	x1, x25
bl	LFQH_TopChromeFill
LFQH_Lloh7130:
adr x1, LFQH_l_.str.870
LFQH_Lloh7131:
nop
mov	x0, x19
bl	LFQH_Get
mov	x1, x21
mov	x2, x25
bl	LFQH_TopChromeArtwork
LFQH_Lloh7132:
adr x24, LFQH_TopChromeInsetKey
LFQH_Lloh7133:
nop
mov	x0, x22
mov	x1, x24
bl Lpatch + (0xa628 - PATCH_BASE)
cmp	x0, #0
cset	w26, ne
mov	x0, x21
mov	x1, x22
fmov	d0, d8
mov	x2, x25
bl	LFQH_TopChromeUnderlap
mov	x0, x22
mov	x1, x24
bl Lpatch + (0xa628 - PATCH_BASE)
cmp	x0, #0
cset	w8, eq
eor	w8, w26, w8
tbnz	w8, #0, LFQH_LBB418_7
LFQH_Lloh7134:
adr x1, LFQH_l_.str.333
LFQH_Lloh7135:
nop
mov	x0, x23
bl	LFQH_Responds
cbz	w0, LFQH_LBB418_7
LFQH_Lloh7136:
adr x0, LFQH_l_.str.332
LFQH_Lloh7137:
nop
bl Lpatch + (0xa5a4 - PATCH_BASE)
mov	x1, x0
mov	x0, x23
mov	x2, x22
bl Lpatch + (0xa5d4 - PATCH_BASE)
LFQH_LBB418_7:
cbz	w25, LFQH_LBB418_9
mov	x0, x23
mov	x1, x22
bl	LFQH_BookshelfRestingTint
LFQH_LBB418_9:
LFQH_Lloh7138:
adr x1, LFQH_l_.str.871
LFQH_Lloh7139:
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
LFQH_LBB418_10:
mov	x0, x21
mov	x1, x22
bl	LFQH_TopChromeContains
cmp	w0, #0
cset	w3, ne
b	LFQH_LBB418_4
.cfi_endproc
.p2align	2
LFQH_BookshelfSectionPinning:
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
LFQH_Lloh7140:
adr x1, LFQH_l_.str.288
LFQH_Lloh7141:
nop
bl	LFQH_Kind
cbz	w0, LFQH_LBB419_13
LFQH_Lloh7142:
adr x1, LFQH_l_.str.534
LFQH_Lloh7143:
nop
mov	x0, x20
bl	LFQH_Get
mov	x19, x0
LFQH_Lloh7144:
adr x1, LFQH_ShelfPinnedLayoutKey
LFQH_Lloh7145:
nop
mov	x0, x20
bl Lpatch + (0xa628 - PATCH_BASE)
mov	x21, x0
bl	LFQH_Enabled
cbz	w0, LFQH_LBB419_4
bl	LFQH_FQHGlassAvailable
cbz	w0, LFQH_LBB419_4
LFQH_Lloh7146:
adr x1, LFQH_l_.str.872
LFQH_Lloh7147:
nop
mov	x0, x19
bl	LFQH_Kind
cmp	w0, #0
cset	w22, ne
b	LFQH_LBB419_5
LFQH_LBB419_4:
mov	w22, #0
LFQH_LBB419_5:
cmp	x21, x19
csel	w8, wzr, w22, ne
cbz	x21, LFQH_LBB419_10
tbnz	w8, #0, LFQH_LBB419_10
LFQH_Lloh7148:
adr x0, LFQH_l_.str.873
LFQH_Lloh7149:
nop
bl Lpatch + (0xa5a4 - PATCH_BASE)
mov	x1, x0
mov	x0, x21
bl Lpatch + (0xa5d4 - PATCH_BASE)
cbnz	w0, LFQH_LBB419_9
LFQH_Lloh7150:
adr x0, LFQH_l_.str.874
LFQH_Lloh7151:
nop
bl Lpatch + (0xa5a4 - PATCH_BASE)
mov	x1, x0
mov	x0, x21
mov	w2, #1
bl Lpatch + (0xa5d4 - PATCH_BASE)
LFQH_Lloh7152:
adr x0, LFQH_l_.str.535
LFQH_Lloh7153:
nop
bl Lpatch + (0xa5a4 - PATCH_BASE)
mov	x1, x0
mov	x0, x21
bl Lpatch + (0xa5d4 - PATCH_BASE)
LFQH_LBB419_9:
LFQH_Lloh7154:
adr x1, LFQH_ShelfPinnedLayoutKey
LFQH_Lloh7155:
nop
mov	x0, x20
mov	x2, #0
mov	w3, #1
bl Lpatch + (0xa634 - PATCH_BASE)
LFQH_LBB419_10:
cbz	w22, LFQH_LBB419_13
LFQH_Lloh7156:
adr x0, LFQH_l_.str.873
LFQH_Lloh7157:
nop
bl Lpatch + (0xa5a4 - PATCH_BASE)
mov	x1, x0
mov	x0, x19
bl Lpatch + (0xa5d4 - PATCH_BASE)
cbz	w0, LFQH_LBB419_13
LFQH_Lloh7158:
adr x1, LFQH_ShelfPinnedLayoutKey
LFQH_Lloh7159:
nop
mov	x0, x20
mov	x2, x19
mov	w3, #1
bl Lpatch + (0xa634 - PATCH_BASE)
LFQH_Lloh7160:
adr x0, LFQH_l_.str.874
LFQH_Lloh7161:
nop
bl Lpatch + (0xa5a4 - PATCH_BASE)
mov	x1, x0
mov	x0, x19
mov	w2, #0
bl Lpatch + (0xa5d4 - PATCH_BASE)
LFQH_Lloh7162:
adr x0, LFQH_l_.str.535
LFQH_Lloh7163:
nop
bl Lpatch + (0xa5a4 - PATCH_BASE)
mov	x1, x0
mov	x0, x19
ldp	x29, x30, [sp, #32]
ldp	x20, x19, [sp, #16]
ldp	x22, x21, [sp], #48
b Lpatch + (0xa5d4 - PATCH_BASE)
LFQH_LBB419_13:
ldp	x29, x30, [sp, #32]
ldp	x20, x19, [sp, #16]
ldp	x22, x21, [sp], #48
ret
.cfi_endproc
.p2align	2
LFQH_BookshelfRestingTint:
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
mov	x21, x1
mov	x20, x0
LFQH_Lloh7164:
adr x1, LFQH_l_.str.120
LFQH_Lloh7165:
nop
bl	LFQH_Get
mov	x19, x0
LFQH_Lloh7166:
adr x1, LFQH_l_.str.324
LFQH_Lloh7167:
nop
bl	LFQH_Kind
cbz	w0, LFQH_LBB420_10
LFQH_Lloh7168:
adr x1, LFQH_l_.str.550
LFQH_Lloh7169:
nop
mov	x0, x19
bl	LFQH_Get
cbz	x21, LFQH_LBB420_10
cmp	x0, x20
b.ne	LFQH_LBB420_10
LFQH_Lloh7170:
adr x1, LFQH_l_.str.351
LFQH_Lloh7171:
nop
mov	x0, x19
bl	LFQH_Get
LFQH_Lloh7172:
adr x1, LFQH_TopChromeSurfaceKey
LFQH_Lloh7173:
nop
bl Lpatch + (0xa628 - PATCH_BASE)
mov	x22, x0
LFQH_Lloh7174:
adr x1, LFQH_l_.str.363
LFQH_Lloh7175:
nop
bl	LFQH_Get
cbz	x0, LFQH_LBB420_10
mov	x19, x0
LFQH_Lloh7176:
adr x0, LFQH_l_.str.780
LFQH_Lloh7177:
nop
bl Lpatch + (0xa5a4 - PATCH_BASE)
mov	x1, x0
mov	x0, x21
bl Lpatch + (0xa5d4 - PATCH_BASE)
fmov	d8, d1
LFQH_Lloh7178:
adr x0, LFQH_l_.str.781
LFQH_Lloh7179:
nop
bl Lpatch + (0xa5a4 - PATCH_BASE)
mov	x1, x0
mov	x0, x21
bl Lpatch + (0xa5d4 - PATCH_BASE)
fadd	d0, d8, d0
fabs	d8, d0
fmov	d0, #16.00000000
fcmp	d8, d0
b.pl	LFQH_LBB420_6
LFQH_Lloh7180:
adr x1, LFQH_l_.str.784
LFQH_Lloh7181:
nop
mov	x0, x21
bl	LFQH_Get
mov	x21, x0
LFQH_Lloh7182:
adr x0, LFQH_l_.str.339
LFQH_Lloh7183:
nop
bl Lpatch + (0xa5a4 - PATCH_BASE)
mov	x1, x0
mov	x0, x21
bl Lpatch + (0xa5d4 - PATCH_BASE)
cbz	w0, LFQH_LBB420_12
LFQH_LBB420_6:
LFQH_Lloh7184:
adr x1, LFQH_TopChromeTintKey
LFQH_Lloh7185:
nop
mov	x0, x22
bl Lpatch + (0xa628 - PATCH_BASE)
LFQH_LBB420_7:
mov	x21, x0
LFQH_LBB420_8:
LFQH_Lloh7186:
adr x1, LFQH_l_.str.390
LFQH_Lloh7187:
nop
mov	x0, x19
bl	LFQH_Get
cmp	x0, x21
b.eq	LFQH_LBB420_10
mov	x20, x0
LFQH_Lloh7188:
adr x0, LFQH_l_.str.49
LFQH_Lloh7189:
nop
bl Lpatch + (0xa5a4 - PATCH_BASE)
mov	x1, x0
mov	x0, x20
mov	x2, x21
bl Lpatch + (0xa5d4 - PATCH_BASE)
cbz	w0, LFQH_LBB420_11
LFQH_LBB420_10:
ldp	x29, x30, [sp, #48]
ldp	x20, x19, [sp, #32]
ldp	x22, x21, [sp, #16]
ldp	d9, d8, [sp], #64
ret
LFQH_LBB420_11:
LFQH_Lloh7190:
adr x0, LFQH_l_.str.157
LFQH_Lloh7191:
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
LFQH_LBB420_12:
mov	x8, #-4634204016564240384
fmov	d0, x8
fmul	d0, d8, d0
fmov	d1, #1.00000000
fadd	d8, d0, d1
LFQH_Lloh7192:
adr x1, LFQH_TopChromeTintKey
LFQH_Lloh7193:
nop
mov	x0, x22
bl Lpatch + (0xa628 - PATCH_BASE)
fcmp	d8, #0.0
b.le	LFQH_LBB420_7
LFQH_Lloh7194:
adr x0, LFQH_l_.str.47
LFQH_Lloh7195:
nop
bl Lpatch + (0xa5b0 - PATCH_BASE)
mov	x22, x0
LFQH_Lloh7196:
adr x1, LFQH_l_.str.833
LFQH_Lloh7197:
nop
mov	x0, x20
bl	LFQH_Get
LFQH_Lloh7198:
adr x1, LFQH_l_.str.875
LFQH_Lloh7199:
nop
bl	LFQH_Get
LFQH_Lloh7200:
adr x1, LFQH_l_.str.390
LFQH_Lloh7201:
nop
bl	LFQH_Get
cbnz	x0, LFQH_LBB420_17
LFQH_Lloh7202:
adr x1, LFQH_l_.str.876
LFQH_Lloh7203:
nop
mov	x0, x22
bl	LFQH_Responds
cbz	w0, LFQH_LBB420_16
LFQH_Lloh7204:
adr x0, LFQH_l_.str.876
LFQH_Lloh7205:
nop
bl Lpatch + (0xa5a4 - PATCH_BASE)
mov	x20, x0
LFQH_Lloh7206:
adr x0, LFQH_l_.str.361
LFQH_Lloh7207:
nop
bl Lpatch + (0xa5b0 - PATCH_BASE)
mov	x21, x0
LFQH_Lloh7208:
adr x0, LFQH_l_.str.387
LFQH_Lloh7209:
nop
bl Lpatch + (0xa5a4 - PATCH_BASE)
mov	x1, x0
LFQH_Lloh7210:
adr x2, LFQH_l_.str.877
LFQH_Lloh7211:
nop
mov	x0, x21
bl Lpatch + (0xa5d4 - PATCH_BASE)
mov	x2, x0
mov	x0, x22
mov	x1, x20
bl Lpatch + (0xa5d4 - PATCH_BASE)
cbnz	x0, LFQH_LBB420_17
LFQH_LBB420_16:
LFQH_Lloh7212:
adr x0, LFQH_l_.str.777
LFQH_Lloh7213:
nop
bl Lpatch + (0xa5a4 - PATCH_BASE)
mov	x1, x0
mov	x0, x22
bl Lpatch + (0xa5d4 - PATCH_BASE)
LFQH_LBB420_17:
mov	x21, x0
fmov	d0, #1.00000000
fcmp	d8, d0
b.eq	LFQH_LBB420_8
LFQH_Lloh7214:
adr x0, LFQH_l_.str.51
LFQH_Lloh7215:
nop
bl Lpatch + (0xa5a4 - PATCH_BASE)
mov	x1, x0
fmov	d0, #0.93750000
fmul	d0, d8, d0
mov	x8, #4589168020290535424
fmov	d1, x8
fadd	d0, d0, d1
mov	x0, x21
bl Lpatch + (0xa5d4 - PATCH_BASE)
b	LFQH_LBB420_7
.cfi_endproc
.p2align	2
LFQH_ShelfPinnedLayoutKey:
.cfi_startproc
ret
.cfi_endproc
.p2align	2
LFQH_RestoreBookshelfTopInset:
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
LFQH_Lloh7216:
adr x1, LFQH_l_.str.533
LFQH_Lloh7217:
nop
bl	LFQH_Get
mov	x19, x0
LFQH_Lloh7218:
adr x1, LFQH_TopChromeInsetKey
LFQH_Lloh7219:
nop
bl Lpatch + (0xa628 - PATCH_BASE)
mov	x20, x0
LFQH_Lloh7220:
adr x21, LFQH_l_.str.445
LFQH_Lloh7221:
nop
mov	x0, x21
bl Lpatch + (0xa5a4 - PATCH_BASE)
mov	x1, x0
mov	x0, x20
bl Lpatch + (0xa5d4 - PATCH_BASE)
fmov	d8, d0
LFQH_Lloh7222:
adr x1, LFQH_TopChromeStockInsetKey
LFQH_Lloh7223:
nop
mov	x0, x19
bl Lpatch + (0xa628 - PATCH_BASE)
mov	x20, x0
mov	x0, x21
bl Lpatch + (0xa5a4 - PATCH_BASE)
mov	x1, x0
mov	x0, x20
bl Lpatch + (0xa5d4 - PATCH_BASE)
fsub	d0, d8, d0
fcmp	d0, #0.0
b.le	LFQH_LBB422_2
mov	x0, x19
ldp	x29, x30, [sp, #48]
ldp	x20, x19, [sp, #32]
ldp	x22, x21, [sp, #16]
ldp	d9, d8, [sp], #64
b	LFQH_TopChromeInsets
LFQH_LBB422_2:
ldp	x29, x30, [sp, #48]
ldp	x20, x19, [sp, #32]
ldp	x22, x21, [sp, #16]
ldp	d9, d8, [sp], #64
ret
.cfi_endproc
.p2align	2
LFQH_TopChromeRefreshHeaderVisibility:
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
LFQH_Lloh7224:
adr x1, LFQH_l_.str.20
LFQH_Lloh7225:
nop
bl	LFQH_Get
mov	x19, x0
LFQH_Lloh7226:
adr x1, LFQH_l_.str.120
LFQH_Lloh7227:
nop
bl	LFQH_Get
mov	x21, x0
LFQH_Lloh7228:
adr x1, LFQH_l_.str.784
LFQH_Lloh7229:
nop
mov	x0, x19
bl	LFQH_Get
cmp	x0, x20
b.eq	LFQH_LBB423_2
LFQH_LBB423_1:
ldp	x29, x30, [sp, #32]
ldp	x20, x19, [sp, #16]
ldp	x22, x21, [sp], #48
ret
LFQH_LBB423_2:
LFQH_Lloh7230:
adr x1, LFQH_l_.str.288
LFQH_Lloh7231:
nop
mov	x0, x21
bl	LFQH_Kind
cbnz	w0, LFQH_LBB423_4
LFQH_Lloh7232:
adr x1, LFQH_l_.str.306
LFQH_Lloh7233:
nop
mov	x0, x21
bl	LFQH_Kind
cbz	w0, LFQH_LBB423_5
LFQH_LBB423_4:
LFQH_Lloh7234:
adr x1, LFQH_l_.str.533
LFQH_Lloh7235:
nop
mov	x0, x21
bl	LFQH_Get
cmp	x0, x19
b.eq	LFQH_LBB423_9
LFQH_LBB423_5:
LFQH_Lloh7236:
adr x1, LFQH_l_.str.257
LFQH_Lloh7237:
nop
mov	x0, x21
bl	LFQH_Kind
cbz	w0, LFQH_LBB423_1
LFQH_Lloh7238:
adr x1, LFQH_l_.str.779
LFQH_Lloh7239:
nop
mov	x0, x21
bl	LFQH_Get
cmp	x0, x19
b.ne	LFQH_LBB423_1
LFQH_Lloh7240:
adr x1, LFQH_l_.str.878
LFQH_Lloh7241:
nop
mov	x0, x21
bl	LFQH_Get
cmp	x0, x20
b.ne	LFQH_LBB423_1
mov	x0, x19
ldp	x29, x30, [sp, #32]
ldp	x20, x19, [sp, #16]
ldp	x22, x21, [sp], #48
b	LFQH_TopChromeRefreshVisibility
LFQH_LBB423_9:
mov	x0, x19
bl	LFQH_TopChromeRefreshVisibility
LFQH_Lloh7242:
adr x1, LFQH_l_.str.288
LFQH_Lloh7243:
nop
mov	x0, x21
bl	LFQH_Kind
cbz	w0, LFQH_LBB423_1
mov	x0, x21
mov	x1, x19
ldp	x29, x30, [sp, #32]
ldp	x20, x19, [sp, #16]
ldp	x22, x21, [sp], #48
b	LFQH_BookshelfRestingTint
.cfi_endproc
.p2align	2
LFQH_BottomSymbol178Key:
.cfi_startproc
ret
.cfi_endproc
.p2align	2
LFQH_BottomRestoreHidden178:
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
LFQH_Lloh7244:
adr x1, LFQH_BottomHidden178Key
LFQH_Lloh7245:
nop
bl Lpatch + (0xa628 - PATCH_BASE)
cbz	x0, LFQH_LBB425_3
mov	x20, x0
LFQH_Lloh7246:
adr x0, LFQH_l_.str.71
LFQH_Lloh7247:
nop
bl Lpatch + (0xa5a4 - PATCH_BASE)
mov	x1, x0
mov	x0, x19
bl Lpatch + (0xa5d4 - PATCH_BASE)
cbz	w0, LFQH_LBB425_3
LFQH_Lloh7248:
adr x0, LFQH_l_.str.72
LFQH_Lloh7249:
nop
bl Lpatch + (0xa5a4 - PATCH_BASE)
mov	x21, x0
LFQH_Lloh7250:
adr x0, LFQH_l_.str.41
LFQH_Lloh7251:
nop
bl Lpatch + (0xa5a4 - PATCH_BASE)
mov	x1, x0
mov	x0, x20
bl Lpatch + (0xa5d4 - PATCH_BASE)
mov	x2, x0
mov	x0, x19
mov	x1, x21
bl Lpatch + (0xa5d4 - PATCH_BASE)
LFQH_LBB425_3:
LFQH_Lloh7252:
adr x1, LFQH_BottomHidden178Key
LFQH_Lloh7253:
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
LFQH_BottomLabel178Key:
.cfi_startproc
ret
.cfi_endproc
.p2align	2
LFQH_BottomStockImage178Key:
.cfi_startproc
ret
.cfi_endproc
.p2align	2
LFQH_BottomSymbolName178Key:
.cfi_startproc
ret
.cfi_endproc
.p2align	2
LFQH_BottomSymbolSize178Key:
.cfi_startproc
ret
.cfi_endproc
.p2align	2
LFQH_BottomTitleFallback178R2Key:
.cfi_startproc
ret
.cfi_endproc
.p2align	2
LFQH_BottomHidden178Key:
.cfi_startproc
ret
.cfi_endproc
.p2align	2
LFQH_BottomTitles178R2Key:
.cfi_startproc
ret
.cfi_endproc
.p2align	2
LFQH_BottomWeak178:
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
LFQH_Lloh7254:
adr x0, LFQH_l_.str.82
LFQH_Lloh7255:
nop
bl Lpatch + (0xa5b0 - PATCH_BASE)
mov	x20, x0
LFQH_Lloh7256:
adr x0, LFQH_l_.str.83
LFQH_Lloh7257:
nop
bl Lpatch + (0xa5a4 - PATCH_BASE)
mov	x1, x0
mov	x0, x20
bl Lpatch + (0xa5d4 - PATCH_BASE)
mov	x20, x0
cbz	x19, LFQH_LBB433_2
LFQH_Lloh7258:
adr x0, LFQH_l_.str.84
LFQH_Lloh7259:
nop
bl Lpatch + (0xa5a4 - PATCH_BASE)
mov	x1, x0
mov	x0, x20
mov	x2, x19
bl Lpatch + (0xa5d4 - PATCH_BASE)
LFQH_LBB433_2:
mov	x0, x20
ldp	x29, x30, [sp, #16]
ldp	x20, x19, [sp], #32
ret
.cfi_endproc
.p2align	2
LFQH_BottomBars178Key:
.cfi_startproc
ret
.cfi_endproc
.p2align	2
LFQH_BottomSelectedBox178Key:
.cfi_startproc
ret
.cfi_endproc
.p2align	2
LFQH_BottomFindFeed178:
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
mov	x20, x0
mov	x0, #0
cbz	x20, LFQH_LBB436_17
subs	w22, w2, #1
b.lt	LFQH_LBB436_17
mov	x21, x3
ldr	w8, [x3]
cmp	w8, #1
b.lt	LFQH_LBB436_16
mov	x19, x1
mov	x0, x20
bl	LFQH_BottomVisible178
cbz	w0, LFQH_LBB436_16
ldr	w8, [x21]
sub	w8, w8, #1
str	w8, [x21]
LFQH_Lloh7260:
adr x1, LFQH_l_.str.772
LFQH_Lloh7261:
nop
mov	x0, x20
bl	LFQH_Kind
cbz	w0, LFQH_LBB436_18
LFQH_Lloh7262:
adr x21, LFQH_l_.str.24
LFQH_Lloh7263:
nop
mov	x0, x21
bl Lpatch + (0xa5a4 - PATCH_BASE)
mov	x1, x0
mov	x0, x20
bl Lpatch + (0xa5d4 - PATCH_BASE)
fmov	d8, d0
fmov	d9, d1
fmov	d10, d2
fmov	d11, d3
LFQH_Lloh7264:
adr x0, LFQH_l_.str.507
LFQH_Lloh7265:
nop
bl Lpatch + (0xa5a4 - PATCH_BASE)
mov	x1, x0
mov	x0, x20
fmov	d0, d8
fmov	d1, d9
fmov	d2, d10
fmov	d3, d11
mov	x2, x19
bl Lpatch + (0xa5d4 - PATCH_BASE)
fmov	d11, d0
fmov	d8, d1
fmov	d10, d2
fmov	d9, d3
fmov	x22, d10
fmov	x23, d8
fmov	x24, d11
mov	x0, x21
bl Lpatch + (0xa5a4 - PATCH_BASE)
mov	x1, x0
mov	x0, x19
bl Lpatch + (0xa5d4 - PATCH_BASE)
and	x10, x24, #0x7fffffffffffffff
and	x8, x23, #0x7fffffffffffffff
mov	x11, #9218868437227405311
cmp	x8, x11
cset	w8, gt
and	x9, x22, #0x7fffffffffffffff
cmp	x9, x11
cset	w9, gt
cmp	x10, x11
b.gt	LFQH_LBB436_16
tbnz	w8, #0, LFQH_LBB436_16
tbnz	w9, #0, LFQH_LBB436_16
fmov	x8, d9
and	x8, x8, #0x7fffffffffffffff
mov	x9, #9218868437227405311
cmp	x8, x9
b.gt	LFQH_LBB436_16
fcmp	d10, #0.0
b.le	LFQH_LBB436_16
fcmp	d9, #0.0
b.le	LFQH_LBB436_16
fcmp	d9, d10
b.le	LFQH_LBB436_16
fabd	d0, d11, d0
fmov	d4, #2.00000000
fcmp	d0, d4
b.pl	LFQH_LBB436_16
fmov	d0, #-4.00000000
fadd	d0, d2, d0
fcmp	d10, d0
b.lt	LFQH_LBB436_16
fadd	d0, d1, d3
fcmp	d8, d0
b.pl	LFQH_LBB436_16
fadd	d0, d8, d9
fcmp	d0, d1
mov	x0, x20
b.gt	LFQH_LBB436_17
LFQH_LBB436_16:
mov	x0, #0
LFQH_LBB436_17:
ldp	x29, x30, [sp, #96]
ldp	x20, x19, [sp, #80]
ldp	x22, x21, [sp, #64]
ldp	x24, x23, [sp, #48]
ldp	x26, x25, [sp, #32]
ldp	d9, d8, [sp, #16]
ldp	d11, d10, [sp], #112
ret
LFQH_LBB436_18:
LFQH_Lloh7266:
adr x1, LFQH_l_.str.414
LFQH_Lloh7267:
nop
mov	x0, x20
bl	LFQH_Get
mov	x20, x0
LFQH_Lloh7268:
adr x0, LFQH_l_.str.34
LFQH_Lloh7269:
nop
bl Lpatch + (0xa5a4 - PATCH_BASE)
mov	x1, x0
mov	x0, x20
bl Lpatch + (0xa5d4 - PATCH_BASE)
cbz	x0, LFQH_LBB436_17
mov	x23, x0
mov	x24, #0
LFQH_Lloh7270:
adr x25, LFQH_l_.str.461
LFQH_Lloh7271:
nop
LFQH_LBB436_20:
ldr	w8, [x21]
cmp	w8, #1
b.lt	LFQH_LBB436_16
mov	x0, x25
bl Lpatch + (0xa5a4 - PATCH_BASE)
mov	x1, x0
mov	x0, x20
mov	x2, x24
bl Lpatch + (0xa5d4 - PATCH_BASE)
mov	x1, x19
mov	x2, x22
mov	x3, x21
bl	LFQH_BottomFindFeed178
cbnz	x0, LFQH_LBB436_17
add	x24, x24, #1
cmp	x23, x24
b.ne	LFQH_LBB436_20
b	LFQH_LBB436_17
.cfi_endproc
.p2align	2
LFQH_BottomPanClass178:
.cfi_startproc
stp	x20, x19, [sp, #-32]!
stp	x29, x30, [sp, #16]
add	x29, sp, #16
.cfi_def_cfa w29, 16
.cfi_offset w30, -8
.cfi_offset w29, -16
.cfi_offset w19, -24
.cfi_offset w20, -32
LFQH_Lloh7272:
adr x0, LFQH_l_.str.891
LFQH_Lloh7273:
nop
bl Lpatch + (0xa5b0 - PATCH_BASE)
mov	x19, x0
cbnz	x0, LFQH_LBB437_3
LFQH_Lloh7274:
adr x0, LFQH_l_.str.556
LFQH_Lloh7275:
nop
bl Lpatch + (0xa5b0 - PATCH_BASE)
LFQH_Lloh7276:
adr x1, LFQH_l_.str.891
LFQH_Lloh7277:
nop
mov	x2, #0
bl Lpatch + (0xa61c - PATCH_BASE)
mov	x19, x0
cbz	x0, LFQH_LBB437_3
LFQH_Lloh7278:
adr x0, LFQH_l_.str.890
LFQH_Lloh7279:
nop
bl Lpatch + (0xa5a4 - PATCH_BASE)
mov	x1, x0
LFQH_Lloh7280:
adr x2, LFQH_FQHBottomPan178
LFQH_Lloh7281:
nop
LFQH_Lloh7282:
adr x3, LFQH_l_.str.186
LFQH_Lloh7283:
nop
mov	x0, x19
bl Lpatch + (0xa58c - PATCH_BASE)
mov	x0, x19
bl Lpatch + (0xa610 - PATCH_BASE)
LFQH_LBB437_3:
mov	x0, x19
ldp	x29, x30, [sp, #16]
ldp	x20, x19, [sp], #32
ret
.cfi_endproc
.p2align	2
LFQH_BottomHide178:
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
cbz	x0, LFQH_LBB438_4
mov	x19, x0
LFQH_Lloh7284:
adr x1, LFQH_BottomHidden178Key
LFQH_Lloh7285:
nop
bl Lpatch + (0xa628 - PATCH_BASE)
cbnz	x0, LFQH_LBB438_3
LFQH_Lloh7286:
adr x0, LFQH_l_.str.71
LFQH_Lloh7287:
nop
bl Lpatch + (0xa5a4 - PATCH_BASE)
mov	x1, x0
mov	x0, x19
bl Lpatch + (0xa5d4 - PATCH_BASE)
mov	x20, x0
LFQH_Lloh7288:
adr x0, LFQH_l_.str.497
LFQH_Lloh7289:
nop
bl Lpatch + (0xa5b0 - PATCH_BASE)
mov	x21, x0
LFQH_Lloh7290:
adr x0, LFQH_l_.str.499
LFQH_Lloh7291:
nop
bl Lpatch + (0xa5a4 - PATCH_BASE)
mov	x1, x0
mov	x0, x21
mov	x2, x20
bl Lpatch + (0xa5d4 - PATCH_BASE)
mov	x2, x0
LFQH_Lloh7292:
adr x1, LFQH_BottomHidden178Key
LFQH_Lloh7293:
nop
mov	x0, x19
mov	w3, #1
bl Lpatch + (0xa634 - PATCH_BASE)
LFQH_LBB438_3:
LFQH_Lloh7294:
adr x0, LFQH_l_.str.71
LFQH_Lloh7295:
nop
bl Lpatch + (0xa5a4 - PATCH_BASE)
mov	x1, x0
mov	x0, x19
bl Lpatch + (0xa5d4 - PATCH_BASE)
cbz	w0, LFQH_LBB438_5
LFQH_LBB438_4:
ldp	x29, x30, [sp, #32]
ldp	x20, x19, [sp, #16]
ldp	x22, x21, [sp], #48
ret
LFQH_LBB438_5:
LFQH_Lloh7296:
adr x0, LFQH_l_.str.72
LFQH_Lloh7297:
nop
bl Lpatch + (0xa5a4 - PATCH_BASE)
mov	x1, x0
mov	x0, x19
mov	w2, #1
ldp	x29, x30, [sp, #32]
ldp	x20, x19, [sp, #16]
ldp	x22, x21, [sp], #48
b Lpatch + (0xa5d4 - PATCH_BASE)
.cfi_endproc
.p2align	2
LFQH_BottomOpenSettings178:
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
LFQH_Lloh7298:
adr x1, LFQH_BottomOptionsOwner178Key
LFQH_Lloh7299:
nop
bl Lpatch + (0xa628 - PATCH_BASE)
LFQH_Lloh7300:
adr x1, LFQH_l_.str.81
LFQH_Lloh7301:
nop
bl	LFQH_Get
mov	x20, x0
LFQH_Lloh7302:
adr x1, LFQH_l_.str.940
LFQH_Lloh7303:
nop
bl	LFQH_Get
cbz	x0, LFQH_LBB439_2
mov	x19, x0
LFQH_Lloh7304:
adr x1, LFQH_l_.str.352
LFQH_Lloh7305:
nop
mov	x0, x20
bl	LFQH_Get
cbz	x0, LFQH_LBB439_3
LFQH_LBB439_2:
ldp	x29, x30, [sp, #32]
ldp	x20, x19, [sp, #16]
ldp	x22, x21, [sp], #48
ret
LFQH_LBB439_3:
LFQH_Lloh7306:
adr x0, LFQH_l_.str.943
LFQH_Lloh7307:
nop
bl Lpatch + (0xa5b0 - PATCH_BASE)
mov	x20, x0
cbnz	x0, LFQH_LBB439_6
LFQH_Lloh7308:
adr x0, LFQH_l_.str.944
LFQH_Lloh7309:
nop
bl Lpatch + (0xa5b0 - PATCH_BASE)
LFQH_Lloh7310:
adr x1, LFQH_l_.str.943
LFQH_Lloh7311:
nop
mov	x2, #0
bl Lpatch + (0xa61c - PATCH_BASE)
mov	x20, x0
cbz	x0, LFQH_LBB439_6
LFQH_Lloh7312:
adr x0, LFQH_l_.str.945
LFQH_Lloh7313:
nop
bl Lpatch + (0xa5a4 - PATCH_BASE)
mov	x1, x0
LFQH_Lloh7314:
adr x2, LFQH_BottomSettingsLoad178
LFQH_Lloh7315:
nop
LFQH_Lloh7316:
adr x21, LFQH_l_.str.9
LFQH_Lloh7317:
nop
mov	x0, x20
mov	x3, x21
bl Lpatch + (0xa58c - PATCH_BASE)
LFQH_Lloh7318:
adr x0, LFQH_l_.str.217
LFQH_Lloh7319:
nop
bl Lpatch + (0xa5a4 - PATCH_BASE)
mov	x1, x0
LFQH_Lloh7320:
adr x2, LFQH_BottomSettingsLayout178
LFQH_Lloh7321:
nop
mov	x0, x20
mov	x3, x21
bl Lpatch + (0xa58c - PATCH_BASE)
LFQH_Lloh7322:
adr x0, LFQH_l_.str.946
LFQH_Lloh7323:
nop
bl Lpatch + (0xa5a4 - PATCH_BASE)
mov	x1, x0
LFQH_Lloh7324:
adr x2, LFQH_FQHBottomOptionChanged178
LFQH_Lloh7325:
nop
LFQH_Lloh7326:
adr x21, LFQH_l_.str.186
LFQH_Lloh7327:
nop
mov	x0, x20
mov	x3, x21
bl Lpatch + (0xa58c - PATCH_BASE)
LFQH_Lloh7328:
adr x0, LFQH_l_.str.947
LFQH_Lloh7329:
nop
bl Lpatch + (0xa5a4 - PATCH_BASE)
mov	x1, x0
LFQH_Lloh7330:
adr x2, LFQH_FQHBottomOptionsReset178
LFQH_Lloh7331:
nop
mov	x0, x20
mov	x3, x21
bl Lpatch + (0xa58c - PATCH_BASE)
mov	x0, x20
bl Lpatch + (0xa610 - PATCH_BASE)
LFQH_LBB439_6:
LFQH_Lloh7332:
adr x0, LFQH_l_.str.421
LFQH_Lloh7333:
nop
bl Lpatch + (0xa5a4 - PATCH_BASE)
mov	x1, x0
mov	x0, x20
bl Lpatch + (0xa5d4 - PATCH_BASE)
cbz	x0, LFQH_LBB439_2
mov	x20, x0
LFQH_Lloh7334:
adr x0, LFQH_l_.str.941
LFQH_Lloh7335:
nop
bl Lpatch + (0xa5a4 - PATCH_BASE)
mov	x21, x0
LFQH_Lloh7336:
adr x0, LFQH_l_.str.361
LFQH_Lloh7337:
nop
bl Lpatch + (0xa5b0 - PATCH_BASE)
mov	x22, x0
LFQH_Lloh7338:
adr x0, LFQH_l_.str.387
LFQH_Lloh7339:
nop
bl Lpatch + (0xa5a4 - PATCH_BASE)
mov	x1, x0
LFQH_Lloh7340:
adr x2, LFQH_l_.str.939
LFQH_Lloh7341:
nop
mov	x0, x22
bl Lpatch + (0xa5d4 - PATCH_BASE)
mov	x2, x0
mov	x0, x20
mov	x1, x21
bl Lpatch + (0xa5d4 - PATCH_BASE)
LFQH_Lloh7342:
adr x0, LFQH_l_.str.942
LFQH_Lloh7343:
nop
bl Lpatch + (0xa5a4 - PATCH_BASE)
mov	x1, x0
mov	x0, x19
mov	x2, x20
mov	w3, #1
bl Lpatch + (0xa5d4 - PATCH_BASE)
LFQH_Lloh7344:
adr x0, LFQH_l_.str.56
LFQH_Lloh7345:
nop
bl Lpatch + (0xa5a4 - PATCH_BASE)
mov	x1, x0
mov	x0, x20
ldp	x29, x30, [sp, #32]
ldp	x20, x19, [sp, #16]
ldp	x22, x21, [sp], #48
b Lpatch + (0xa5d4 - PATCH_BASE)
.cfi_endproc
.p2align	2
LFQH_BottomOptionsOwner178Key:
.cfi_startproc
ret
.cfi_endproc
.p2align	2
LFQH_BottomSettingsLoad178:
.cfi_startproc
stp	d11, d10, [sp, #-128]!
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
.cfi_offset b10, -120
.cfi_offset b11, -128
mov	x20, x1
mov	x19, x0
LFQH_Lloh7346:
adr x0, LFQH_l_.str.944
LFQH_Lloh7347:
nop
bl Lpatch + (0xa5b0 - PATCH_BASE)
mov	x21, x0
LFQH_Lloh7348:
adr x0, LFQH_l_.str.945
LFQH_Lloh7349:
nop
bl Lpatch + (0xa5a4 - PATCH_BASE)
mov	x1, x0
mov	x0, x21
bl Lpatch + (0xa5f8 - PATCH_BASE)
cbz	x0, LFQH_LBB441_2
bl Lpatch + (0xa598 - PATCH_BASE)
mov	x8, x0
mov	x0, x19
mov	x1, x20
blr	x8
LFQH_LBB441_2:
LFQH_Lloh7350:
adr x1, LFQH_l_.str.351
LFQH_Lloh7351:
nop
mov	x0, x19
bl	LFQH_Get
mov	x24, x0
LFQH_Lloh7352:
adr x0, LFQH_l_.str.24
LFQH_Lloh7353:
nop
bl Lpatch + (0xa5a4 - PATCH_BASE)
mov	x1, x0
mov	x0, x24
bl Lpatch + (0xa5d4 - PATCH_BASE)
fmov	d9, d0
mov	x8, #4642648265865560064
fmov	d0, x8
fcmp	d2, d0
b.pl	LFQH_LBB441_4
LFQH_Lloh7354:
adr x0, LFQH_l_.str.948
LFQH_Lloh7355:
nop
bl Lpatch + (0xa5b0 - PATCH_BASE)
mov	x20, x0
LFQH_Lloh7356:
adr x0, LFQH_l_.str.949
LFQH_Lloh7357:
nop
bl Lpatch + (0xa5a4 - PATCH_BASE)
mov	x1, x0
mov	x0, x20
bl Lpatch + (0xa5d4 - PATCH_BASE)
mov	x20, x0
LFQH_Lloh7358:
adr x0, LFQH_l_.str.24
LFQH_Lloh7359:
nop
bl Lpatch + (0xa5a4 - PATCH_BASE)
mov	x1, x0
mov	x0, x20
bl Lpatch + (0xa5d4 - PATCH_BASE)
fmov	d9, d0
LFQH_LBB441_4:
fmov	d11, d1
fmov	d8, d2
fmov	d10, d3
mov	x8, #4642648265865560064
fmov	d0, x8
fcmp	d2, d0
b.pl	LFQH_LBB441_6
fmov	d9, xzr
LFQH_Lloh7360:
adr x8, LFQH_lCPI441_0
LFQH_Lloh7361:
ldr d10, [x8]
and x8, x8, #0xfffffffffffff000
LFQH_Lloh7362:
adr x8, LFQH_lCPI441_1
LFQH_Lloh7363:
ldr d8, [x8]
and x8, x8, #0xfffffffffffff000
fmov	d11, xzr
LFQH_LBB441_6:
LFQH_Lloh7364:
adr x0, LFQH_l_.str.157
LFQH_Lloh7365:
nop
bl Lpatch + (0xa5a4 - PATCH_BASE)
mov	x20, x0
LFQH_Lloh7366:
adr x0, LFQH_l_.str.47
LFQH_Lloh7367:
nop
bl Lpatch + (0xa5b0 - PATCH_BASE)
mov	x21, x0
LFQH_Lloh7368:
adr x0, LFQH_l_.str.950
LFQH_Lloh7369:
nop
bl Lpatch + (0xa5a4 - PATCH_BASE)
mov	x1, x0
mov	x0, x21
bl Lpatch + (0xa5d4 - PATCH_BASE)
mov	x2, x0
mov	x0, x24
mov	x1, x20
bl Lpatch + (0xa5d4 - PATCH_BASE)
LFQH_Lloh7370:
adr x0, LFQH_l_.str.941
LFQH_Lloh7371:
nop
bl Lpatch + (0xa5a4 - PATCH_BASE)
mov	x20, x0
LFQH_Lloh7372:
adr x21, LFQH_l_.str.361
LFQH_Lloh7373:
nop
mov	x0, x21
bl Lpatch + (0xa5b0 - PATCH_BASE)
mov	x23, x0
LFQH_Lloh7374:
adr x22, LFQH_l_.str.387
LFQH_Lloh7375:
nop
mov	x0, x22
bl Lpatch + (0xa5a4 - PATCH_BASE)
mov	x1, x0
LFQH_Lloh7376:
adr x2, LFQH_l_.str.939
LFQH_Lloh7377:
nop
mov	x0, x23
bl Lpatch + (0xa5d4 - PATCH_BASE)
mov	x2, x0
mov	x0, x19
mov	x1, x20
bl Lpatch + (0xa5d4 - PATCH_BASE)
LFQH_Lloh7378:
adr x0, LFQH_l_.str.116
LFQH_Lloh7379:
nop
bl Lpatch + (0xa5b0 - PATCH_BASE)
mov	x20, x0
LFQH_Lloh7380:
adr x0, LFQH_l_.str.415
LFQH_Lloh7381:
nop
bl Lpatch + (0xa5a4 - PATCH_BASE)
mov	x1, x0
mov	x0, x20
bl Lpatch + (0xa5d4 - PATCH_BASE)
mov	x2, x0
LFQH_Lloh7382:
adr x1, LFQH_BottomSettingViews178Key
LFQH_Lloh7383:
nop
mov	x0, x19
mov	w3, #1
bl Lpatch + (0xa634 - PATCH_BASE)
LFQH_Lloh7384:
adr x0, LFQH_l_.str.774
LFQH_Lloh7385:
nop
bl Lpatch + (0xa5b0 - PATCH_BASE)
mov	x20, x0
LFQH_Lloh7386:
adr x27, LFQH_l_.str.421
LFQH_Lloh7387:
nop
mov	x0, x27
bl Lpatch + (0xa5a4 - PATCH_BASE)
mov	x1, x0
mov	x0, x20
bl Lpatch + (0xa5d4 - PATCH_BASE)
mov	x20, x0
LFQH_Lloh7388:
adr x1, LFQH_BottomSettingsScroll178Key
LFQH_Lloh7389:
nop
mov	x0, x19
mov	x2, x20
mov	w3, #1
bl Lpatch + (0xa634 - PATCH_BASE)
LFQH_Lloh7390:
adr x26, LFQH_l_.str.156
LFQH_Lloh7391:
nop
mov	x0, x26
bl Lpatch + (0xa5a4 - PATCH_BASE)
mov	x1, x0
mov	x0, x20
fmov	d0, d9
fmov	d1, d11
fmov	d2, d8
fmov	d3, d10
bl Lpatch + (0xa5d4 - PATCH_BASE)
LFQH_Lloh7392:
adr x25, LFQH_l_.str.166
LFQH_Lloh7393:
nop
mov	x0, x25
bl Lpatch + (0xa5a4 - PATCH_BASE)
mov	x1, x0
mov	x0, x20
mov	w2, #18
bl Lpatch + (0xa5d4 - PATCH_BASE)
LFQH_Lloh7394:
adr x0, LFQH_l_.str.951
LFQH_Lloh7395:
nop
bl Lpatch + (0xa5a4 - PATCH_BASE)
mov	x1, x0
mov	x0, x20
mov	w2, #1
bl Lpatch + (0xa5d4 - PATCH_BASE)
LFQH_Lloh7396:
adr x23, LFQH_l_.str.167
LFQH_Lloh7397:
nop
mov	x0, x23
bl Lpatch + (0xa5a4 - PATCH_BASE)
mov	x1, x0
mov	x0, x24
mov	x2, x20
bl Lpatch + (0xa5d4 - PATCH_BASE)
LFQH_Lloh7398:
adr x0, LFQH_l_.str.23
LFQH_Lloh7399:
nop
bl Lpatch + (0xa5b0 - PATCH_BASE)
mov	x24, x0
mov	x0, x27
bl Lpatch + (0xa5a4 - PATCH_BASE)
mov	x1, x0
mov	x0, x24
bl Lpatch + (0xa5d4 - PATCH_BASE)
mov	x24, x0
mov	x0, x26
bl Lpatch + (0xa5a4 - PATCH_BASE)
mov	x1, x0
LFQH_Lloh7400:
adr x8, LFQH_lCPI441_2
LFQH_Lloh7401:
ldr d9, [x8]
and x8, x8, #0xfffffffffffff000
fmov	d0, xzr
fmov	d1, xzr
mov	x0, x24
fmov	d2, d8
fmov	d3, d9
bl Lpatch + (0xa5d4 - PATCH_BASE)
mov	x0, x25
bl Lpatch + (0xa5a4 - PATCH_BASE)
mov	x1, x0
mov	x0, x24
mov	w2, #2
bl Lpatch + (0xa5d4 - PATCH_BASE)
mov	x0, x23
bl Lpatch + (0xa5a4 - PATCH_BASE)
mov	x1, x0
mov	x0, x20
mov	x2, x24
bl Lpatch + (0xa5d4 - PATCH_BASE)
LFQH_Lloh7402:
adr x0, LFQH_l_.str.952
LFQH_Lloh7403:
nop
bl Lpatch + (0xa5a4 - PATCH_BASE)
mov	x1, x0
mov	x0, x20
fmov	d0, d8
fmov	d1, d9
bl Lpatch + (0xa5d4 - PATCH_BASE)
mov	x8, #-4592545720011063296
fmov	d0, x8
fadd	d8, d8, d0
LFQH_Lloh7404:
adr x1, LFQH_l_.str.953
LFQH_Lloh7405:
nop
fmov	d0, #20.00000000
fmov	d1, #18.00000000
fmov	d3, #28.00000000
fmov	d4, #19.00000000
mov	x0, x24
fmov	d2, d8
mov	w2, #0
bl	LFQH_BottomSettingsLabel178
LFQH_Lloh7406:
adr x3, LFQH_l_.str.954
LFQH_Lloh7407:
nop
LFQH_Lloh7408:
adr x4, LFQH_l_.str.955
LFQH_Lloh7409:
nop
LFQH_Lloh7410:
adr x8, LFQH_lCPI441_3
LFQH_Lloh7411:
ldr d0, [x8]
and x8, x8, #0xfffffffffffff000
mov	x0, x19
mov	x1, x24
mov	w2, #1
bl	LFQH_BottomSettingsSwitch178
LFQH_Lloh7412:
adr x3, LFQH_l_.str.956
LFQH_Lloh7413:
nop
LFQH_Lloh7414:
adr x4, LFQH_l_.str.957
LFQH_Lloh7415:
nop
mov	x8, #4639552041121742848
fmov	d0, x8
mov	x0, x19
mov	x1, x24
mov	w2, #2
bl	LFQH_BottomSettingsSwitch178
LFQH_Lloh7416:
adr x1, LFQH_l_.str.958
LFQH_Lloh7417:
nop
LFQH_Lloh7418:
adr x8, LFQH_lCPI441_4
LFQH_Lloh7419:
ldr d1, [x8]
and x8, x8, #0xfffffffffffff000
fmov	d0, #20.00000000
fmov	d3, #28.00000000
fmov	d4, #19.00000000
mov	x0, x24
fmov	d2, d8
mov	w2, #0
bl	LFQH_BottomSettingsLabel178
LFQH_Lloh7420:
adr x3, LFQH_l_.str.959
LFQH_Lloh7421:
nop
LFQH_Lloh7422:
adr x8, LFQH_lCPI441_5
LFQH_Lloh7423:
ldr d0, [x8]
and x8, x8, #0xfffffffffffff000
mov	w8, #1112014848
fmov	s1, w8
mov	w8, #1120403456
fmov	s9, w8
mov	x0, x19
mov	x1, x24
mov	w2, #11
fmov	s2, s9
bl	LFQH_BottomSettingsSlider178
LFQH_Lloh7424:
adr x3, LFQH_l_.str.960
LFQH_Lloh7425:
nop
LFQH_Lloh7426:
adr x8, LFQH_lCPI441_6
LFQH_Lloh7427:
ldr d0, [x8]
and x8, x8, #0xfffffffffffff000
mov	w8, #1117782016
fmov	s1, w8
mov	w8, #1123680256
fmov	s2, w8
mov	x0, x19
mov	x1, x24
mov	w2, #12
bl	LFQH_BottomSettingsSlider178
LFQH_Lloh7428:
adr x3, LFQH_l_.str.961
LFQH_Lloh7429:
nop
LFQH_Lloh7430:
adr x8, LFQH_lCPI441_7
LFQH_Lloh7431:
ldr d0, [x8]
and x8, x8, #0xfffffffffffff000
mov	w8, #1116471296
fmov	s1, w8
mov	x0, x19
mov	x1, x24
mov	w2, #13
fmov	s2, s9
bl	LFQH_BottomSettingsSlider178
LFQH_Lloh7432:
adr x3, LFQH_l_.str.962
LFQH_Lloh7433:
nop
LFQH_Lloh7434:
adr x8, LFQH_lCPI441_8
LFQH_Lloh7435:
ldr d0, [x8]
and x8, x8, #0xfffffffffffff000
fmov	s1, #16.00000000
fmov	s2, #26.00000000
mov	x0, x19
mov	x1, x24
mov	w2, #14
bl	LFQH_BottomSettingsSlider178
LFQH_Lloh7436:
adr x1, LFQH_l_.str.963
LFQH_Lloh7437:
nop
LFQH_Lloh7438:
adr x8, LFQH_lCPI441_9
LFQH_Lloh7439:
ldr d1, [x8]
and x8, x8, #0xfffffffffffff000
mov	x8, #4633641066610819072
fmov	d3, x8
fmov	d0, #20.00000000
fmov	d4, #12.00000000
mov	x0, x24
fmov	d2, d8
mov	w2, #1
bl	LFQH_BottomSettingsLabel178
LFQH_Lloh7440:
adr x0, LFQH_l_.str.138
LFQH_Lloh7441:
nop
bl Lpatch + (0xa5b0 - PATCH_BASE)
mov	x27, x0
LFQH_Lloh7442:
adr x0, LFQH_l_.str.937
LFQH_Lloh7443:
nop
bl Lpatch + (0xa5a4 - PATCH_BASE)
mov	x1, x0
mov	x0, x27
mov	w2, #1
bl Lpatch + (0xa5d4 - PATCH_BASE)
mov	x27, x0
mov	x0, x26
bl Lpatch + (0xa5a4 - PATCH_BASE)
mov	x1, x0
LFQH_Lloh7444:
adr x8, LFQH_lCPI441_10
LFQH_Lloh7445:
ldr d1, [x8]
and x8, x8, #0xfffffffffffff000
mov	x8, #4631952216750555136
fmov	d3, x8
fmov	d0, #20.00000000
mov	x0, x27
fmov	d2, d8
bl Lpatch + (0xa5d4 - PATCH_BASE)
mov	x0, x25
bl Lpatch + (0xa5a4 - PATCH_BASE)
mov	x1, x0
mov	x0, x27
mov	w2, #2
bl Lpatch + (0xa5d4 - PATCH_BASE)
LFQH_Lloh7446:
adr x0, LFQH_l_.str.886
LFQH_Lloh7447:
nop
bl Lpatch + (0xa5a4 - PATCH_BASE)
mov	x25, x0
mov	x0, x21
bl Lpatch + (0xa5b0 - PATCH_BASE)
mov	x21, x0
mov	x0, x22
bl Lpatch + (0xa5a4 - PATCH_BASE)
mov	x1, x0
LFQH_Lloh7448:
adr x2, LFQH_l_.str.964
LFQH_Lloh7449:
nop
mov	x0, x21
bl Lpatch + (0xa5d4 - PATCH_BASE)
mov	x2, x0
mov	x0, x27
mov	x1, x25
mov	x3, #0
bl Lpatch + (0xa5d4 - PATCH_BASE)
LFQH_Lloh7450:
adr x0, LFQH_l_.str.438
LFQH_Lloh7451:
nop
bl Lpatch + (0xa5a4 - PATCH_BASE)
mov	x21, x0
LFQH_Lloh7452:
adr x0, LFQH_l_.str.947
LFQH_Lloh7453:
nop
bl Lpatch + (0xa5a4 - PATCH_BASE)
mov	x3, x0
mov	x0, x27
mov	x1, x21
mov	x2, x19
mov	w4, #64
bl Lpatch + (0xa5d4 - PATCH_BASE)
mov	x0, x23
bl Lpatch + (0xa5a4 - PATCH_BASE)
mov	x1, x0
mov	x0, x24
mov	x2, x27
bl Lpatch + (0xa5d4 - PATCH_BASE)
LFQH_Lloh7454:
adr x19, LFQH_l_.str.56
LFQH_Lloh7455:
nop
mov	x0, x19
bl Lpatch + (0xa5a4 - PATCH_BASE)
mov	x1, x0
mov	x0, x24
bl Lpatch + (0xa5d4 - PATCH_BASE)
mov	x0, x19
bl Lpatch + (0xa5a4 - PATCH_BASE)
mov	x1, x0
mov	x0, x20
ldp	x29, x30, [sp, #112]
ldp	x20, x19, [sp, #96]
ldp	x22, x21, [sp, #80]
ldp	x24, x23, [sp, #64]
ldp	x26, x25, [sp, #48]
ldp	x28, x27, [sp, #32]
ldp	d9, d8, [sp, #16]
ldp	d11, d10, [sp], #128
b Lpatch + (0xa5d4 - PATCH_BASE)
.cfi_endproc
.p2align	2
LFQH_BottomSettingsLayout178:
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
mov	x19, x1
mov	x20, x0
LFQH_Lloh7456:
adr x0, LFQH_l_.str.944
LFQH_Lloh7457:
nop
bl Lpatch + (0xa5b0 - PATCH_BASE)
mov	x21, x0
LFQH_Lloh7458:
adr x0, LFQH_l_.str.217
LFQH_Lloh7459:
nop
bl Lpatch + (0xa5a4 - PATCH_BASE)
mov	x1, x0
mov	x0, x21
bl Lpatch + (0xa5f8 - PATCH_BASE)
cbz	x0, LFQH_LBB442_2
bl Lpatch + (0xa598 - PATCH_BASE)
mov	x8, x0
mov	x0, x20
mov	x1, x19
blr	x8
LFQH_LBB442_2:
LFQH_Lloh7460:
adr x1, LFQH_BottomSettingsScroll178Key
LFQH_Lloh7461:
nop
mov	x0, x20
bl Lpatch + (0xa628 - PATCH_BASE)
mov	x19, x0
LFQH_Lloh7462:
adr x1, LFQH_l_.str.351
LFQH_Lloh7463:
nop
mov	x0, x20
bl	LFQH_Get
mov	x20, x0
LFQH_Lloh7464:
adr x0, LFQH_l_.str.24
LFQH_Lloh7465:
nop
bl Lpatch + (0xa5a4 - PATCH_BASE)
mov	x1, x0
mov	x0, x20
bl Lpatch + (0xa5d4 - PATCH_BASE)
cbz	x19, LFQH_LBB442_15
fmov	d10, d0
fmov	d11, d1
fmov	d8, d2
fmov	x8, d11
fmov	x9, d10
fmov	x10, d8
and	x11, x9, #0x7fffffffffffffff
and	x8, x8, #0x7fffffffffffffff
mov	x12, #9218868437227405311
cmp	x8, x12
cset	w8, gt
and	x9, x10, #0x7fffffffffffffff
cmp	x9, x12
cset	w9, gt
cmp	x11, x12
b.gt	LFQH_LBB442_15
tbnz	w8, #0, LFQH_LBB442_15
tbnz	w9, #0, LFQH_LBB442_15
fmov	d9, d3
fmov	x8, d9
and	x8, x8, #0x7fffffffffffffff
mov	x9, #9218868437227405311
cmp	x8, x9
b.gt	LFQH_LBB442_15
fcmp	d8, #0.0
b.le	LFQH_LBB442_15
fcmp	d9, #0.0
b.le	LFQH_LBB442_15
LFQH_Lloh7466:
adr x0, LFQH_l_.str.372
LFQH_Lloh7467:
nop
bl Lpatch + (0xa5a4 - PATCH_BASE)
mov	x1, x0
mov	x0, x19
bl Lpatch + (0xa5d4 - PATCH_BASE)
fcmp	d0, d10
b.ne	LFQH_LBB442_13
fcmp	d1, d11
b.ne	LFQH_LBB442_13
fcmp	d2, d8
b.ne	LFQH_LBB442_13
fcmp	d3, d9
b.eq	LFQH_LBB442_14
LFQH_LBB442_13:
LFQH_Lloh7468:
adr x0, LFQH_l_.str.156
LFQH_Lloh7469:
nop
bl Lpatch + (0xa5a4 - PATCH_BASE)
mov	x1, x0
mov	x0, x19
fmov	d0, d10
fmov	d1, d11
fmov	d2, d8
fmov	d3, d9
bl Lpatch + (0xa5d4 - PATCH_BASE)
LFQH_LBB442_14:
LFQH_Lloh7470:
adr x0, LFQH_l_.str.952
LFQH_Lloh7471:
nop
bl Lpatch + (0xa5a4 - PATCH_BASE)
mov	x1, x0
LFQH_Lloh7472:
adr x8, LFQH_lCPI442_0
LFQH_Lloh7473:
ldr d1, [x8]
and x8, x8, #0xfffffffffffff000
mov	x0, x19
fmov	d0, d8
ldp	x29, x30, [sp, #64]
ldp	x20, x19, [sp, #48]
ldp	x22, x21, [sp, #32]
ldp	d9, d8, [sp, #16]
ldp	d11, d10, [sp], #80
b Lpatch + (0xa5d4 - PATCH_BASE)
LFQH_LBB442_15:
ldp	x29, x30, [sp, #64]
ldp	x20, x19, [sp, #48]
ldp	x22, x21, [sp, #32]
ldp	d9, d8, [sp, #16]
ldp	d11, d10, [sp], #80
ret
.cfi_endproc
.p2align	2
LFQH_BottomSettingsScroll178Key:
.cfi_startproc
ret
.cfi_endproc
.p2align	2
LFQH_BottomSettingsLabel178:
.cfi_startproc
stp	d13, d12, [sp, #-112]!
stp	d11, d10, [sp, #16]
stp	d9, d8, [sp, #32]
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
.cfi_offset b8, -72
.cfi_offset b9, -80
.cfi_offset b10, -88
.cfi_offset b11, -96
.cfi_offset b12, -104
.cfi_offset b13, -112
mov	x21, x2
fmov	d8, d4
mov	x22, x1
fmov	d9, d3
fmov	d10, d2
fmov	d11, d1
fmov	d12, d0
mov	x19, x0
LFQH_Lloh7474:
adr x0, LFQH_l_.str.36
LFQH_Lloh7475:
nop
bl Lpatch + (0xa5b0 - PATCH_BASE)
mov	x20, x0
LFQH_Lloh7476:
adr x0, LFQH_l_.str.421
LFQH_Lloh7477:
nop
bl Lpatch + (0xa5a4 - PATCH_BASE)
mov	x1, x0
mov	x0, x20
bl Lpatch + (0xa5d4 - PATCH_BASE)
mov	x20, x0
LFQH_Lloh7478:
adr x0, LFQH_l_.str.156
LFQH_Lloh7479:
nop
bl Lpatch + (0xa5a4 - PATCH_BASE)
mov	x1, x0
mov	x0, x20
fmov	d0, d12
fmov	d1, d11
fmov	d2, d10
fmov	d3, d9
bl Lpatch + (0xa5d4 - PATCH_BASE)
LFQH_Lloh7480:
adr x0, LFQH_l_.str.159
LFQH_Lloh7481:
nop
bl Lpatch + (0xa5a4 - PATCH_BASE)
mov	x23, x0
LFQH_Lloh7482:
adr x0, LFQH_l_.str.361
LFQH_Lloh7483:
nop
bl Lpatch + (0xa5b0 - PATCH_BASE)
mov	x24, x0
LFQH_Lloh7484:
adr x0, LFQH_l_.str.387
LFQH_Lloh7485:
nop
bl Lpatch + (0xa5a4 - PATCH_BASE)
mov	x1, x0
mov	x0, x24
mov	x2, x22
bl Lpatch + (0xa5d4 - PATCH_BASE)
mov	x2, x0
mov	x0, x20
mov	x1, x23
bl Lpatch + (0xa5d4 - PATCH_BASE)
LFQH_Lloh7486:
adr x0, LFQH_l_.str.162
LFQH_Lloh7487:
nop
bl Lpatch + (0xa5a4 - PATCH_BASE)
mov	x22, x0
LFQH_Lloh7488:
adr x0, LFQH_l_.str.163
LFQH_Lloh7489:
nop
bl Lpatch + (0xa5b0 - PATCH_BASE)
mov	x23, x0
LFQH_Lloh7490:
adr x0, LFQH_l_.str.164
LFQH_Lloh7491:
nop
bl Lpatch + (0xa5a4 - PATCH_BASE)
mov	x1, x0
mov	x0, x23
fmov	d0, d8
bl Lpatch + (0xa5d4 - PATCH_BASE)
mov	x2, x0
mov	x0, x20
mov	x1, x22
bl Lpatch + (0xa5d4 - PATCH_BASE)
LFQH_Lloh7492:
adr x0, LFQH_l_.str.45
LFQH_Lloh7493:
nop
bl Lpatch + (0xa5a4 - PATCH_BASE)
mov	x22, x0
LFQH_Lloh7494:
adr x0, LFQH_l_.str.47
LFQH_Lloh7495:
nop
bl Lpatch + (0xa5b0 - PATCH_BASE)
mov	x23, x0
LFQH_Lloh7496:
adr x8, LFQH_l_.str.165
LFQH_Lloh7497:
nop
LFQH_Lloh7498:
adr x9, LFQH_l_.str.48
LFQH_Lloh7499:
nop
cmp	w21, #0
csel	x0, x9, x8, eq
bl Lpatch + (0xa5a4 - PATCH_BASE)
mov	x1, x0
mov	x0, x23
bl Lpatch + (0xa5d4 - PATCH_BASE)
mov	x2, x0
mov	x0, x20
mov	x1, x22
bl Lpatch + (0xa5d4 - PATCH_BASE)
LFQH_Lloh7500:
adr x0, LFQH_l_.str.161
LFQH_Lloh7501:
nop
bl Lpatch + (0xa5a4 - PATCH_BASE)
mov	x1, x0
mov	x0, x20
mov	x2, #0
bl Lpatch + (0xa5d4 - PATCH_BASE)
LFQH_Lloh7502:
adr x0, LFQH_l_.str.166
LFQH_Lloh7503:
nop
bl Lpatch + (0xa5a4 - PATCH_BASE)
mov	x1, x0
mov	x0, x20
mov	w2, #2
bl Lpatch + (0xa5d4 - PATCH_BASE)
LFQH_Lloh7504:
adr x0, LFQH_l_.str.167
LFQH_Lloh7505:
nop
bl Lpatch + (0xa5a4 - PATCH_BASE)
mov	x1, x0
mov	x0, x19
mov	x2, x20
bl Lpatch + (0xa5d4 - PATCH_BASE)
LFQH_Lloh7506:
adr x0, LFQH_l_.str.56
LFQH_Lloh7507:
nop
bl Lpatch + (0xa5a4 - PATCH_BASE)
mov	x1, x0
mov	x0, x20
bl Lpatch + (0xa5d4 - PATCH_BASE)
mov	x0, x20
ldp	x29, x30, [sp, #96]
ldp	x20, x19, [sp, #80]
ldp	x22, x21, [sp, #64]
ldp	x24, x23, [sp, #48]
ldp	d9, d8, [sp, #32]
ldp	d11, d10, [sp, #16]
ldp	d13, d12, [sp], #112
ret
.cfi_endproc
.p2align	2
LFQH_BottomSettingsSwitch178:
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
mov	x22, x4
mov	x21, x3
mov	x23, x2
fmov	d8, d0
mov	x20, x1
mov	x19, x0
LFQH_Lloh7508:
adr x0, LFQH_l_.str.24
LFQH_Lloh7509:
nop
bl Lpatch + (0xa5a4 - PATCH_BASE)
mov	x1, x0
mov	x0, x20
bl Lpatch + (0xa5d4 - PATCH_BASE)
fmov	d9, d2
LFQH_Lloh7510:
adr x8, LFQH_lCPI445_0
LFQH_Lloh7511:
ldr d0, [x8]
and x8, x8, #0xfffffffffffff000
fadd	d2, d2, d0
fmov	d0, #20.00000000
fmov	d3, #28.00000000
fmov	d4, #16.00000000
mov	x0, x20
fmov	d1, d8
mov	x1, x21
mov	w2, #0
bl	LFQH_BottomSettingsLabel178
LFQH_Lloh7512:
adr x8, LFQH_lCPI445_1
LFQH_Lloh7513:
ldr d0, [x8]
and x8, x8, #0xfffffffffffff000
fadd	d1, d8, d0
mov	x8, #-4592545720011063296
fmov	d0, x8
fadd	d2, d9, d0
mov	x8, #4630544841867001856
fmov	d3, x8
fmov	d0, #20.00000000
fmov	d4, #12.00000000
mov	x0, x20
mov	x1, x22
mov	w2, #1
bl	LFQH_BottomSettingsLabel178
LFQH_Lloh7514:
adr x0, LFQH_l_.str.608
LFQH_Lloh7515:
nop
bl Lpatch + (0xa5b0 - PATCH_BASE)
mov	x22, x0
LFQH_Lloh7516:
adr x0, LFQH_l_.str.421
LFQH_Lloh7517:
nop
bl Lpatch + (0xa5a4 - PATCH_BASE)
mov	x1, x0
mov	x0, x22
bl Lpatch + (0xa5d4 - PATCH_BASE)
mov	x22, x0
mov	x8, #-4588605070337114112
fmov	d0, x8
fadd	d9, d9, d0
fmov	d0, #-1.00000000
fadd	d8, d8, d0
LFQH_Lloh7518:
adr x0, LFQH_l_.str.156
LFQH_Lloh7519:
nop
bl Lpatch + (0xa5a4 - PATCH_BASE)
mov	x1, x0
LFQH_Lloh7520:
adr x8, LFQH_lCPI445_2
LFQH_Lloh7521:
ldr d2, [x8]
and x8, x8, #0xfffffffffffff000
fmov	d3, #31.00000000
mov	x0, x22
fmov	d0, d9
fmov	d1, d8
bl Lpatch + (0xa5d4 - PATCH_BASE)
LFQH_Lloh7522:
adr x0, LFQH_l_.str.166
LFQH_Lloh7523:
nop
bl Lpatch + (0xa5a4 - PATCH_BASE)
mov	x1, x0
mov	x0, x22
mov	w2, #1
bl Lpatch + (0xa5d4 - PATCH_BASE)
LFQH_Lloh7524:
adr x0, LFQH_l_.str.609
LFQH_Lloh7525:
nop
bl Lpatch + (0xa5a4 - PATCH_BASE)
mov	x1, x0
mov	x0, x22
mov	x2, x23
bl Lpatch + (0xa5d4 - PATCH_BASE)
LFQH_Lloh7526:
adr x0, LFQH_l_.str.385
LFQH_Lloh7527:
nop
bl Lpatch + (0xa5a4 - PATCH_BASE)
mov	x24, x0
mov	x0, x23
bl	LFQH_BottomFlag178
mov	x2, x0
mov	x0, x22
mov	x1, x24
mov	w3, #0
bl Lpatch + (0xa5d4 - PATCH_BASE)
LFQH_Lloh7528:
adr x0, LFQH_l_.str.610
LFQH_Lloh7529:
nop
bl Lpatch + (0xa5a4 - PATCH_BASE)
mov	x23, x0
LFQH_Lloh7530:
adr x0, LFQH_l_.str.361
LFQH_Lloh7531:
nop
bl Lpatch + (0xa5b0 - PATCH_BASE)
mov	x24, x0
LFQH_Lloh7532:
adr x0, LFQH_l_.str.387
LFQH_Lloh7533:
nop
bl Lpatch + (0xa5a4 - PATCH_BASE)
mov	x1, x0
mov	x0, x24
mov	x2, x21
bl Lpatch + (0xa5d4 - PATCH_BASE)
mov	x2, x0
mov	x0, x22
mov	x1, x23
bl Lpatch + (0xa5d4 - PATCH_BASE)
LFQH_Lloh7534:
adr x0, LFQH_l_.str.438
LFQH_Lloh7535:
nop
bl Lpatch + (0xa5a4 - PATCH_BASE)
mov	x21, x0
LFQH_Lloh7536:
adr x0, LFQH_l_.str.946
LFQH_Lloh7537:
nop
bl Lpatch + (0xa5a4 - PATCH_BASE)
mov	x3, x0
mov	x0, x22
mov	x1, x21
mov	x2, x19
mov	w4, #4096
bl Lpatch + (0xa5d4 - PATCH_BASE)
LFQH_Lloh7538:
adr x0, LFQH_l_.str.167
LFQH_Lloh7539:
nop
bl Lpatch + (0xa5a4 - PATCH_BASE)
mov	x1, x0
mov	x0, x20
mov	x2, x22
bl Lpatch + (0xa5d4 - PATCH_BASE)
LFQH_Lloh7540:
adr x1, LFQH_BottomSettingViews178Key
LFQH_Lloh7541:
nop
mov	x0, x19
bl Lpatch + (0xa628 - PATCH_BASE)
mov	x19, x0
LFQH_Lloh7542:
adr x0, LFQH_l_.str.84
LFQH_Lloh7543:
nop
bl Lpatch + (0xa5a4 - PATCH_BASE)
mov	x1, x0
mov	x0, x19
mov	x2, x22
bl Lpatch + (0xa5d4 - PATCH_BASE)
LFQH_Lloh7544:
adr x0, LFQH_l_.str.56
LFQH_Lloh7545:
nop
bl Lpatch + (0xa5a4 - PATCH_BASE)
mov	x1, x0
mov	x0, x22
ldp	x29, x30, [sp, #64]
ldp	x20, x19, [sp, #48]
ldp	x22, x21, [sp, #32]
ldp	x24, x23, [sp, #16]
ldp	d9, d8, [sp], #80
b Lpatch + (0xa5d4 - PATCH_BASE)
.cfi_endproc
.p2align	2
LFQH_BottomSettingsSlider178:
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
fmov	s8, s2
fmov	s9, s1
mov	x21, x3
mov	x22, x2
fmov	d10, d0
mov	x20, x1
mov	x19, x0
LFQH_Lloh7546:
adr x0, LFQH_l_.str.24
LFQH_Lloh7547:
nop
bl Lpatch + (0xa5a4 - PATCH_BASE)
mov	x1, x0
mov	x0, x20
bl Lpatch + (0xa5d4 - PATCH_BASE)
fmov	d11, d2
LFQH_Lloh7548:
adr x8, LFQH_lCPI446_0
LFQH_Lloh7549:
ldr d0, [x8]
and x8, x8, #0xfffffffffffff000
fadd	d2, d2, d0
fmov	d0, #20.00000000
fmov	d3, #24.00000000
fmov	d4, #15.00000000
mov	x0, x20
fmov	d1, d10
mov	x1, x21
mov	w2, #0
bl	LFQH_BottomSettingsLabel178
LFQH_Lloh7550:
adr x8, LFQH_lCPI446_1
LFQH_Lloh7551:
ldr d0, [x8]
and x8, x8, #0xfffffffffffff000
fadd	d0, d11, d0
LFQH_Lloh7552:
adr x1, LFQH_l_.str.885
LFQH_Lloh7553:
nop
LFQH_Lloh7554:
adr x8, LFQH_lCPI446_2
LFQH_Lloh7555:
ldr d2, [x8]
and x8, x8, #0xfffffffffffff000
fmov	d3, #24.00000000
fmov	d4, #14.00000000
mov	x0, x20
fmov	d1, d10
mov	w2, #1
bl	LFQH_BottomSettingsLabel178
mov	x24, x0
LFQH_Lloh7556:
adr x0, LFQH_l_.str.965
LFQH_Lloh7557:
nop
bl Lpatch + (0xa5a4 - PATCH_BASE)
mov	x1, x0
mov	x0, x24
mov	w2, #2
bl Lpatch + (0xa5d4 - PATCH_BASE)
LFQH_Lloh7558:
adr x25, LFQH_l_.str.166
LFQH_Lloh7559:
nop
mov	x0, x25
bl Lpatch + (0xa5a4 - PATCH_BASE)
mov	x1, x0
mov	x0, x24
mov	w2, #1
bl Lpatch + (0xa5d4 - PATCH_BASE)
LFQH_Lloh7560:
adr x0, LFQH_l_.str.159
LFQH_Lloh7561:
nop
bl Lpatch + (0xa5a4 - PATCH_BASE)
mov	x23, x0
mov	x0, x22
bl	LFQH_BottomValueText178
mov	x2, x0
mov	x0, x24
mov	x1, x23
bl Lpatch + (0xa5d4 - PATCH_BASE)
LFQH_Lloh7562:
adr x0, LFQH_l_.str.509
LFQH_Lloh7563:
nop
bl Lpatch + (0xa5b0 - PATCH_BASE)
mov	x23, x0
LFQH_Lloh7564:
adr x0, LFQH_l_.str.421
LFQH_Lloh7565:
nop
bl Lpatch + (0xa5a4 - PATCH_BASE)
mov	x1, x0
mov	x0, x23
bl Lpatch + (0xa5d4 - PATCH_BASE)
mov	x23, x0
fmov	d0, #29.00000000
fadd	d10, d10, d0
mov	x8, #-4592545720011063296
fmov	d0, x8
fadd	d11, d11, d0
LFQH_Lloh7566:
adr x0, LFQH_l_.str.156
LFQH_Lloh7567:
nop
bl Lpatch + (0xa5a4 - PATCH_BASE)
mov	x1, x0
mov	x8, #4631389266797133824
fmov	d3, x8
fmov	d0, #20.00000000
mov	x0, x23
fmov	d1, d10
fmov	d2, d11
bl Lpatch + (0xa5d4 - PATCH_BASE)
mov	x0, x25
bl Lpatch + (0xa5a4 - PATCH_BASE)
mov	x1, x0
mov	x0, x23
mov	w2, #2
bl Lpatch + (0xa5d4 - PATCH_BASE)
LFQH_Lloh7568:
adr x0, LFQH_l_.str.609
LFQH_Lloh7569:
nop
bl Lpatch + (0xa5a4 - PATCH_BASE)
mov	x1, x0
mov	x0, x23
mov	x2, x22
bl Lpatch + (0xa5d4 - PATCH_BASE)
LFQH_Lloh7570:
adr x0, LFQH_l_.str.966
LFQH_Lloh7571:
nop
bl Lpatch + (0xa5a4 - PATCH_BASE)
mov	x1, x0
mov	x0, x23
fmov	s0, s9
bl Lpatch + (0xa5d4 - PATCH_BASE)
LFQH_Lloh7572:
adr x0, LFQH_l_.str.967
LFQH_Lloh7573:
nop
bl Lpatch + (0xa5a4 - PATCH_BASE)
mov	x1, x0
mov	x0, x23
fmov	s0, s8
bl Lpatch + (0xa5d4 - PATCH_BASE)
LFQH_Lloh7574:
adr x0, LFQH_l_.str.386
LFQH_Lloh7575:
nop
bl Lpatch + (0xa5a4 - PATCH_BASE)
mov	x25, x0
mov	x0, x22
bl	LFQH_BottomValue178
fcvt	s0, d0
mov	x0, x23
mov	x1, x25
mov	w2, #0
bl Lpatch + (0xa5d4 - PATCH_BASE)
LFQH_Lloh7576:
adr x0, LFQH_l_.str.610
LFQH_Lloh7577:
nop
bl Lpatch + (0xa5a4 - PATCH_BASE)
mov	x22, x0
LFQH_Lloh7578:
adr x0, LFQH_l_.str.361
LFQH_Lloh7579:
nop
bl Lpatch + (0xa5b0 - PATCH_BASE)
mov	x25, x0
LFQH_Lloh7580:
adr x0, LFQH_l_.str.387
LFQH_Lloh7581:
nop
bl Lpatch + (0xa5a4 - PATCH_BASE)
mov	x1, x0
mov	x0, x25
mov	x2, x21
bl Lpatch + (0xa5d4 - PATCH_BASE)
mov	x2, x0
mov	x0, x23
mov	x1, x22
bl Lpatch + (0xa5d4 - PATCH_BASE)
LFQH_Lloh7582:
adr x1, LFQH_BottomOptionValue178Key
LFQH_Lloh7583:
nop
mov	x0, x23
mov	x2, x24
mov	w3, #1
bl Lpatch + (0xa634 - PATCH_BASE)
LFQH_Lloh7584:
adr x0, LFQH_l_.str.438
LFQH_Lloh7585:
nop
bl Lpatch + (0xa5a4 - PATCH_BASE)
mov	x21, x0
LFQH_Lloh7586:
adr x0, LFQH_l_.str.946
LFQH_Lloh7587:
nop
bl Lpatch + (0xa5a4 - PATCH_BASE)
mov	x3, x0
mov	x0, x23
mov	x1, x21
mov	x2, x19
mov	w4, #4096
bl Lpatch + (0xa5d4 - PATCH_BASE)
LFQH_Lloh7588:
adr x0, LFQH_l_.str.167
LFQH_Lloh7589:
nop
bl Lpatch + (0xa5a4 - PATCH_BASE)
mov	x1, x0
mov	x0, x20
mov	x2, x23
bl Lpatch + (0xa5d4 - PATCH_BASE)
LFQH_Lloh7590:
adr x1, LFQH_BottomSettingViews178Key
LFQH_Lloh7591:
nop
mov	x0, x19
bl Lpatch + (0xa628 - PATCH_BASE)
mov	x19, x0
LFQH_Lloh7592:
adr x0, LFQH_l_.str.84
LFQH_Lloh7593:
nop
bl Lpatch + (0xa5a4 - PATCH_BASE)
mov	x1, x0
mov	x0, x19
mov	x2, x23
bl Lpatch + (0xa5d4 - PATCH_BASE)
LFQH_Lloh7594:
adr x0, LFQH_l_.str.56
LFQH_Lloh7595:
nop
bl Lpatch + (0xa5a4 - PATCH_BASE)
mov	x1, x0
mov	x0, x23
ldp	x29, x30, [sp, #96]
ldp	x20, x19, [sp, #80]
ldp	x22, x21, [sp, #64]
ldp	x24, x23, [sp, #48]
ldp	x26, x25, [sp, #32]
ldp	d9, d8, [sp, #16]
ldp	d11, d10, [sp], #112
b Lpatch + (0xa5d4 - PATCH_BASE)
.cfi_endproc
// @COMPONENT_DATA
.p2align 3
.p2align 3
LFQH_lCPI50_0:
.quad	0x3fe3333333333333
LFQH_lCPI50_1:
.quad	0x3fd3333333333333
.p2align 3
.p2align 3
LFQH_lCPI52_0:
.quad	0x3f847ae147ae147b
.p2align 3
.p2align 3
LFQH_lCPI53_0:
.quad	0x3fe3333333333333
.p2align 3
.p2align 3
LFQH_lCPI164_0:
.quad	0x3fe6666666666666
.p2align 3
.p2align 3
LFQH_lCPI169_0:
.quad	0x3fefae147ae147ae
.p2align 3
.p2align 3
LFQH_lCPI177_0:
.quad	0x4051800000000000
LFQH_lCPI177_1:
.quad	0x405f400000000000
.p2align 3
.p2align 3
LFQH_lCPI179_0:
.quad	0x3f847ae147ae147b
.p2align 3
.p2align 3
LFQH_lCPI180_0:
.quad	0x3f847ae147ae147b
LFQH_lCPI180_1:
.quad	0x3fe8f5c28f5c28f6
LFQH_lCPI180_2:
.quad	0x3feb851eb851eb85
LFQH_lCPI180_3:
.quad	0x4051800000000000
.p2align 3
.p2align 3
LFQH_lCPI247_0:
.quad	0x3f847ae147ae147b
.p2align 3
.p2align 3
LFQH_lCPI441_0:
.quad	0x408a600000000000
LFQH_lCPI441_1:
.quad	0x4078600000000000
LFQH_lCPI441_2:
.quad	0x4089100000000000
LFQH_lCPI441_3:
.quad	0x4050800000000000
LFQH_lCPI441_4:
.quad	0x406f800000000000
LFQH_lCPI441_5:
.quad	0x4072800000000000
LFQH_lCPI441_6:
.quad	0x4077e00000000000
LFQH_lCPI441_7:
.quad	0x407d400000000000
LFQH_lCPI441_8:
.quad	0x4081500000000000
LFQH_lCPI441_9:
.quad	0x4083f00000000000
LFQH_lCPI441_10:
.quad	0x4086500000000000
.p2align 3
.p2align 3
LFQH_lCPI442_0:
.quad	0x4089100000000000
.p2align 3
.p2align 3
LFQH_lCPI445_0:
.quad	0xc05a800000000000
LFQH_lCPI445_1:
.quad	0x4040800000000000
LFQH_lCPI445_2:
.quad	0x4049800000000000
.p2align 3
.p2align 3
LFQH_lCPI446_0:
.quad	0xc05f800000000000
LFQH_lCPI446_1:
.quad	0xc05a800000000000
LFQH_lCPI446_2:
.quad	0x4055800000000000
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
.asciz	"FQReaderSaasNavigationView"
LFQH_l_.str.38:
.asciz	"searchButton"
LFQH_l_.str.39:
.asciz	"moreButton"
LFQH_l_.str.40:
.asciz	"searchAndMoreView"
LFQH_l_.str.41:
.asciz	"boolValue"
LFQH_l_.str.42:
.asciz	"UIControl"
LFQH_l_.str.43:
.asciz	"SSBookshelfEditBottomView"
LFQH_l_.str.44:
.asciz	"SSReaderFloatingCommonButton"
LFQH_l_.str.45:
.asciz	"setTextColor:"
LFQH_l_.str.46:
.asciz	"textColor"
LFQH_l_.str.47:
.asciz	"UIColor"
LFQH_l_.str.48:
.asciz	"labelColor"
LFQH_l_.str.49:
.asciz	"isEqual:"
LFQH_l_.str.50:
.asciz	"secondarySystemBackgroundColor"
LFQH_l_.str.51:
.asciz	"colorWithAlphaComponent:"
LFQH_l_.str.52:
.asciz	"effect"
LFQH_l_.str.53:
.asciz	"copy"
LFQH_l_.str.54:
.asciz	"setTintColor:"
LFQH_l_.str.55:
.asciz	"setEffect:"
LFQH_l_.str.56:
.asciz	"release"
LFQH_l_.str.57:
.asciz	"FQReaderSaaSBottomToolItemView"
LFQH_l_.str.58:
.asciz	"FQReaderSaaSBottomToolView"
LFQH_l_.str.59:
.asciz	"FQReaderSaaSReaderSpeechButton"
LFQH_l_.str.60:
.asciz	"starIcon"
LFQH_l_.str.61:
.asciz	"SSShortVideoRightInteractionCollectView"
LFQH_l_.str.62:
.asciz	"commentIcon"
LFQH_l_.str.63:
.asciz	"SSShortVideoRightInteractionCommentView"
LFQH_l_.str.64:
.asciz	"SSShortVideoHostRightInteractionCommentView"
LFQH_l_.str.65:
.asciz	"likeIcon"
LFQH_l_.str.66:
.asciz	"SSShortVideoRightInteractionLikeView"
LFQH_l_.str.67:
.asciz	"shareIcon"
LFQH_l_.str.68:
.asciz	"SSShortVideoRightInteractionShareView"
LFQH_l_.str.69:
.asciz	"clearGlassButtonConfiguration"
LFQH_l_.str.70:
.asciz	"UIImageView"
LFQH_l_.str.71:
.asciz	"isHidden"
LFQH_l_.str.72:
.asciz	"setHidden:"
LFQH_l_.str.73:
.asciz	"FQVShortVideoVPlayerControlView"
LFQH_l_.str.74:
.asciz	"window"
LFQH_l_.str.75:
.asciz	"inactive"
LFQH_l_.str.76:
.asciz	"scanLimit"
LFQH_l_.str.77:
.asciz	"noUniqueEpisodeEntry"
LFQH_l_.str.78:
.asciz	"progressNotResolved"
LFQH_l_.str.79:
.asciz	"progressTrackUnresolved"
LFQH_l_.str.80:
.asciz	"measured"
LFQH_l_.str.81:
.asciz	"anyObject"
LFQH_l_.str.82:
.asciz	"NSHashTable"
LFQH_l_.str.83:
.asciz	"weakObjectsHashTable"
LFQH_l_.str.84:
.asciz	"addObject:"
LFQH_l_.str.85:
.asciz	"separated"
LFQH_l_.str.86:
.asciz	"alreadySeparated"
LFQH_l_.str.87:
.asciz	"unsupportedGeometry"
LFQH_l_.str.88:
.asciz	"NSMutableDictionary"
LFQH_l_.str.89:
.asciz	"dictionary"
LFQH_l_.str.90:
.asciz	"status"
LFQH_l_.str.91:
.asciz	"shiftY"
LFQH_l_.str.92:
.asciz	"revision"
LFQH_l_.str.93:
.asciz	"visible-track-178R3"
LFQH_l_.str.94:
.asciz	"spacingReference"
LFQH_l_.str.95:
.asciz	"visibleTrack"
LFQH_l_.str.96:
.asciz	"gap"
LFQH_l_.str.97:
.asciz	"trackGap"
LFQH_l_.str.98:
.asciz	"episodeWindowRect"
LFQH_l_.str.99:
.asciz	"progressWindowRect"
LFQH_l_.str.100:
.asciz	"progressClass"
LFQH_l_.str.101:
.asciz	"description"
LFQH_l_.str.102:
.asciz	"seekOwnerClass"
LFQH_l_.str.103:
.asciz	"seekOwnerWindowRect"
LFQH_l_.str.104:
.asciz	"dramaControlSpacing178R2"
LFQH_l_.str.105:
.asciz	"fqx177_originalDurationLayout"
LFQH_l_.str.106:
.asciz	"editButton"
LFQH_l_.str.107:
.asciz	"filterButton"
LFQH_l_.str.108:
.asciz	"fullGenreFilterButton"
LFQH_l_.str.109:
.asciz	"SSBookShelfFilterHeaderView"
LFQH_l_.str.110:
.asciz	"fqx179_originalShelfFilterHeader"
LFQH_l_.str.111:
.asciz	"miniGameEntranceCellModel"
LFQH_l_.str.112:
.asciz	"setIsInvisible:"
LFQH_l_.str.113:
.asciz	"v20@0:8B16"
LFQH_l_.str.114:
.asciz	"setIsDisabled:"
LFQH_l_.str.115:
.asciz	"models"
LFQH_l_.str.116:
.asciz	"NSMutableArray"
LFQH_l_.str.117:
.asciz	"removeObjectIdenticalTo:"
LFQH_l_.str.118:
.asciz	"SSMyUser621BaseViewController"
LFQH_l_.str.119:
.asciz	"removeModelBeforeListAdapter"
LFQH_l_.str.120:
.asciz	"delegate"
LFQH_l_.str.121:
.asciz	"SSTabBarController"
LFQH_l_.str.122:
.asciz	"bottomTabBackgroundColorWithTabModel:"
LFQH_l_.str.123:
.asciz	"@24@0:8@16"
LFQH_l_.str.124:
.asciz	"selectedViewController"
LFQH_l_.str.125:
.asciz	"currentTabModel"
LFQH_l_.str.126:
.asciz	"bookStoreTabContext"
LFQH_l_.str.127:
.asciz	"containerProvider"
LFQH_l_.str.128:
.asciz	"currentCategoryTabModel"
LFQH_l_.str.129:
.asciz	"traitCollection"
LFQH_l_.str.130:
.asciz	"resolvedColorWithTraitCollection:"
LFQH_l_.str.131:
.asciz	"getRed:green:blue:alpha:"
LFQH_l_.str.132:
.asciz	"getWhite:alpha:"
LFQH_l_.str.133:
.asciz	"overrideUserInterfaceStyle"
LFQH_l_.str.134:
.asciz	"setOverrideUserInterfaceStyle:"
LFQH_l_.str.135:
.asciz	"style"
LFQH_l_.str.136:
.asciz	"background"
LFQH_l_.str.137:
.asciz	"tabGlassAppearance"
LFQH_l_.str.138:
.asciz	"UIButton"
LFQH_l_.str.139:
.asciz	"titleColorForState:"
LFQH_l_.str.140:
.asciz	"setTitleColor:forState:"
LFQH_l_.str.141:
.asciz	"tintColor"
LFQH_l_.str.142:
.asciz	"SSUIColorAdaptedManager"
LFQH_l_.str.143:
.asciz	"HTSServiceCenter"
LFQH_l_.str.144:
.asciz	"FQReaderThemeManager"
LFQH_l_.str.145:
.asciz	"fqx191_originalReaderTheme:success:failure:"
LFQH_l_.str.146:
.asciz	"getService:"
LFQH_l_.str.147:
.asciz	"@24@0:8#16"
LFQH_l_.str.148:
.asciz	"isCurrentDarkModeFollowSystem"
LFQH_l_.str.149:
.asciz	"B16@0:8"
LFQH_l_.str.150:
.asciz	"setCurrentDarkModeFollowSystemWithEnable:"
LFQH_l_.str.151:
.asciz	"defaultCenter"
LFQH_l_.str.152:
.asciz	"tableView"
LFQH_l_.str.153:
.asciz	"tableHeaderView"
LFQH_l_.str.154:
.asciz	"alloc"
LFQH_l_.str.155:
.asciz	"init"
LFQH_l_.str.156:
.asciz	"setFrame:"
LFQH_l_.str.157:
.asciz	"setBackgroundColor:"
LFQH_l_.str.158:
.asciz	"clearColor"
LFQH_l_.str.159:
.asciz	"setText:"
LFQH_l_.str.160:
.asciz	"\345\272\225\346\240\217\350\207\263\345\260\221\344\277\235\347\225\231\344\270\200\351\241\271\343\200\202\n\345\205\263\351\227\255\342\200\234\346\210\221\347\232\204\342\200\235\345\220\216\357\274\214\351\225\277\346\214\211\345\272\225\346\240\217\346\211\223\345\274\200 FanqieX \350\256\276\347\275\256\343\200\202"
LFQH_l_.str.161:
.asciz	"setNumberOfLines:"
LFQH_l_.str.162:
.asciz	"setFont:"
LFQH_l_.str.163:
.asciz	"UIFont"
LFQH_l_.str.164:
.asciz	"systemFontOfSize:"
LFQH_l_.str.165:
.asciz	"secondaryLabelColor"
LFQH_l_.str.166:
.asciz	"setAutoresizingMask:"
LFQH_l_.str.167:
.asciz	"addSubview:"
LFQH_l_.str.168:
.asciz	"setTableHeaderView:"
LFQH_l_.str.169:
.asciz	"cellModel"
LFQH_l_.str.170:
.asciz	"SSInsertScreenRecommendService"
LFQH_l_.str.171:
.asciz	"showInsertScreenOfNonstandardAdMessage:showBlock:"
LFQH_l_.str.172:
.asciz	"v32@0:8@16@?24"
LFQH_l_.str.173:
.asciz	"SSImcAdOperationMessage"
LFQH_l_.str.174:
.asciz	"enablePopup"
LFQH_l_.str.175:
.asciz	"SSImcMessageService"
LFQH_l_.str.176:
.asciz	"getPopupWithDataGroup:"
LFQH_l_.str.177:
.asciz	"fqx185_originalIMCPopup:"
LFQH_l_.str.178:
.asciz	"layoutSubviews"
LFQH_l_.str.179:
.asciz	"fqx190_originalDramaCommentLayout"
LFQH_l_.str.180:
.asciz	"updateLikeIconHidden:"
LFQH_l_.str.181:
.asciz	"fqx190_originalDramaLikeVisibility:"
LFQH_l_.str.182:
.asciz	"SSShortVideoBottomDistributionView"
LFQH_l_.str.183:
.asciz	"fqx190_originalDramaWatchLayout"
LFQH_l_.str.184:
.asciz	"renderWithModel:"
LFQH_l_.str.185:
.asciz	"fqx190_originalDramaWatchRender:"
LFQH_l_.str.186:
.asciz	"v24@0:8@16"
LFQH_l_.str.187:
.asciz	"SSShortVideoAlbumSeriesBottomInsertView"
LFQH_l_.str.188:
.asciz	"fqx192_originalDramaWatchAlbumLayout"
LFQH_l_.str.189:
.asciz	"SSReaderFanClubEntryContainerView"
LFQH_l_.str.190:
.asciz	"fqx184_originalShelfWrapper"
LFQH_l_.str.191:
.asciz	"FQReaderUIManager"
LFQH_l_.str.192:
.asciz	"showBottomBarContainer:"
LFQH_l_.str.193:
.asciz	"fqx180_originalReaderMenu:"
LFQH_l_.str.194:
.asciz	"onConfigThemeChange:context:"
LFQH_l_.str.195:
.asciz	"fqx180_originalReaderTheme:context:"
LFQH_l_.str.196:
.asciz	"v32@0:8@16@24"
LFQH_l_.str.197:
.asciz	"refreshBottomToolbarInsertView"
LFQH_l_.str.198:
.asciz	"fqx181_originalReaderCommunityRefresh"
LFQH_l_.str.199:
.asciz	"SSReaderCommunityBottomToolbarItemView"
LFQH_l_.str.200:
.asciz	"fqx181_originalReaderCommunity"
LFQH_l_.str.201:
.asciz	"fqx175_originalBottom"
LFQH_l_.str.202:
.asciz	"FQReaderSaaSNewProgressView"
LFQH_l_.str.203:
.asciz	"fqx174_originalProgress"
LFQH_l_.str.204:
.asciz	"updateWithConfigData:"
LFQH_l_.str.205:
.asciz	"fqx176_originalProgressTheme:"
LFQH_l_.str.206:
.asciz	"SSReaderBottomToolDivertView"
LFQH_l_.str.207:
.asciz	"fqx175_originalDivert"
LFQH_l_.str.208:
.asciz	"SSReaderGiftView"
LFQH_l_.str.209:
.asciz	"fqx174_originalGift"
LFQH_l_.str.210:
.asciz	"SSReaderBookEndUserGiftView"
LFQH_l_.str.211:
.asciz	"fqx174_originalBookGift"
LFQH_l_.str.212:
.asciz	"SSReaderCoverTopRightView"
LFQH_l_.str.213:
.asciz	"fqx186_originalCoverListen"
LFQH_l_.str.214:
.asciz	"FQReaderCoverMainContentViewController"
LFQH_l_.str.215:
.asciz	"setupGuideView"
LFQH_l_.str.216:
.asciz	"fqx186_originalCoverGuideSetup"
LFQH_l_.str.217:
.asciz	"viewDidLayoutSubviews"
LFQH_l_.str.218:
.asciz	"fqx186_originalCoverGuideLayout"
LFQH_l_.str.219:
.asciz	"SSReaderChapterEndDiscussionEntranceView"
LFQH_l_.str.220:
.asciz	"fqx174_originalDiscuss"
LFQH_l_.str.221:
.asciz	"SSReaderChapterEndDiscussionEntranceButton"
LFQH_l_.str.222:
.asciz	"fqx174_originalDiscussButton"
LFQH_l_.str.223:
.asciz	"SSReaderChapterEndCommunityCardView"
LFQH_l_.str.224:
.asciz	"fqx177_originalChapterCard"
LFQH_l_.str.225:
.asciz	"updateWithReaderConfig:"
LFQH_l_.str.226:
.asciz	"fqx177_originalChapterCardTheme:"
LFQH_l_.str.227:
.asciz	"SSReaderChapterEndBaseButton"
LFQH_l_.str.228:
.asciz	"fqx177_originalChapterButton"
LFQH_l_.str.229:
.asciz	"SSReaderChapterEndRewardButton"
LFQH_l_.str.230:
.asciz	"updateWithThemeConfigChange:"
LFQH_l_.str.231:
.asciz	"fqx177_originalChapterRewardTheme:"
LFQH_l_.str.232:
.asciz	"SSBookShelfTabSelectViewTitleCell"
LFQH_l_.str.233:
.asciz	"fqx174_originalShelfCategory"
LFQH_l_.str.234:
.asciz	"reloadData:"
LFQH_l_.str.235:
.asciz	"fqx175_originalShelfTabReload:"
LFQH_l_.str.236:
.asciz	"SSBookShelfFilter541Cell"
LFQH_l_.str.237:
.asciz	"fqx175_originalShelfFilterLayout"
LFQH_l_.str.238:
.asciz	"updateAppearance:"
LFQH_l_.str.239:
.asciz	"fqx175_originalShelfFilterAppearance:"
LFQH_l_.str.240:
.asciz	"updateCellBgColor:"
LFQH_l_.str.241:
.asciz	"fqx175_originalShelfFilterBackground:"
LFQH_l_.str.242:
.asciz	"configFullGenreSelectedModel:categoryOrder:"
LFQH_l_.str.243:
.asciz	"fqx191_originalShelfFilterConfig:order:"
LFQH_l_.str.244:
.asciz	"configOptionModel:filterOption:"
LFQH_l_.str.245:
.asciz	"fqx192_originalShelfFilterOption:filter:"
LFQH_l_.str.246:
.asciz	"SSBookShelfFilterMixRowCollectionView"
LFQH_l_.str.247:
.asciz	"collectionView:layout:insetForSectionAtIndex:"
LFQH_l_.str.248:
.asciz	"fqx185_originalInlineFilterInsets:layout:section:"
LFQH_l_.str.249:
.asciz	"{UIEdgeInsets=dddd}40@0:8@16@24q32"
LFQH_l_.str.250:
.asciz	"SSMyUserBar"
LFQH_l_.str.251:
.asciz	"fqx174_originalProfileBar"
LFQH_l_.str.252:
.asciz	"SSCommunityPublishButton"
LFQH_l_.str.253:
.asciz	"fqx188_originalPublishLayout"
LFQH_l_.str.254:
.asciz	"traitCollectionDidChange:"
LFQH_l_.str.255:
.asciz	"fqx188_originalPublishTheme:"
LFQH_l_.str.256:
.asciz	"SSDoubleRowUgcProduceEntranceView"
LFQH_l_.str.257:
.asciz	"SSBookStoreNestedTabView"
LFQH_l_.str.258:
.asciz	"setPublishButtonView:"
LFQH_l_.str.259:
.asciz	"fqx188_originalStorePublishButton:"
LFQH_l_.str.260:
.asciz	"setProduceEntranceView:"
LFQH_l_.str.261:
.asciz	"fqx189_originalStoreProduceEntrance:"
LFQH_l_.str.262:
.asciz	"SSBookStoreCommunityPublishEntranceComponent"
LFQH_l_.str.263:
.asciz	"setPublishButton:"
LFQH_l_.str.264:
.asciz	"fqx188_originalStoreComponentPublish:"
LFQH_l_.str.265:
.asciz	"SSMyUser621ViewController"
LFQH_l_.str.266:
.asciz	"publishButton"
LFQH_l_.str.267:
.asciz	"fqx188_originalMinePublishButton"
LFQH_l_.str.268:
.asciz	"updateCollectionLayout"
LFQH_l_.str.269:
.asciz	"fqx186_originalProfileCollectionLayout"
LFQH_l_.str.270:
.asciz	"SSMyUserCollectionViewFunCell"
LFQH_l_.str.271:
.asciz	"fqx174_originalProfileEntry"
LFQH_l_.str.272:
.asciz	"SSMyUserCollectionViewOrderFunCell"
LFQH_l_.str.273:
.asciz	"fqx178_originalProfileOrder"
LFQH_l_.str.274:
.asciz	"setupCellMiniGameEntranceData"
LFQH_l_.str.275:
.asciz	"fqx174_originalMiniGameSetup"
LFQH_l_.str.276:
.asciz	"SSMyUserCell2Model"
LFQH_l_.str.277:
.asciz	"applyConfiguredMineEcomEntranceData:mineMonetizationStyle:"
LFQH_l_.str.278:
.asciz	"fqx176_originalMineEntrances:style:"
LFQH_l_.str.279:
.asciz	"v32@0:8@16q24"
LFQH_l_.str.280:
.asciz	"objectsForListAdapter:"
LFQH_l_.str.281:
.asciz	"fqx176_originalMineListObjects:"
LFQH_l_.str.282:
.asciz	"setShowReadTimeView:"
LFQH_l_.str.283:
.asciz	"fqx177_originalDurationVisible:"
LFQH_l_.str.284:
.asciz	"updateFilterShow:"
LFQH_l_.str.285:
.asciz	"fqx191_originalShelfFilterShow:"
LFQH_l_.str.286:
.asciz	"layoutEditButton"
LFQH_l_.str.287:
.asciz	"fqx185_originalStockEditLayout"
LFQH_l_.str.288:
.asciz	"SSBookShelfSubViewController"
LFQH_l_.str.289:
.asciz	"saveOpeningData:indexPath:"
LFQH_l_.str.290:
.asciz	"fqx185_originalSaveOpeningData:index:"
LFQH_l_.str.291:
.asciz	"fetchBookCoverTransitionInfo:"
LFQH_l_.str.292:
.asciz	"fqx185_originalCoverTransition:"
LFQH_l_.str.293:
.asciz	"@24@0:8Q16"
LFQH_l_.str.294:
.asciz	"tabbarVCAndAttributeInit"
LFQH_l_.str.295:
.asciz	"fqx176_originalTabPlan"
LFQH_l_.str.296:
.asciz	"viewDidAppear:"
LFQH_l_.str.297:
.asciz	"fqx176_originalTabAppear:"
LFQH_l_.str.298:
.asciz	"fqx171_originalLayout"
LFQH_l_.str.299:
.asciz	"fqx175_originalSpeechLayout"
LFQH_l_.str.300:
.asciz	"readerInsertedViewBackgroundConfigChange:"
LFQH_l_.str.301:
.asciz	"fqx175_originalSpeechTheme:"
LFQH_l_.str.302:
.asciz	"fqx165_originalRelayout"
LFQH_l_.str.303:
.asciz	"fqx165_originalAppear:"
LFQH_l_.str.304:
.asciz	"categoryView:didScrollSelectedItemAtIndex:"
LFQH_l_.str.305:
.asciz	"fqx186_originalStoreSelected:index:"
LFQH_l_.str.306:
.asciz	"SSBookStoreTabViewController"
LFQH_l_.str.307:
.asciz	"setupLayout"
LFQH_l_.str.308:
.asciz	"fqx186_originalStoreCollectionLayout"
LFQH_l_.str.309:
.asciz	"SSBookStoreDoubleRowViewController"
LFQH_l_.str.310:
.asciz	"viewWillLayoutSubviews"
LFQH_l_.str.311:
.asciz	"fqx187_originalStoreDoubleRowLayout"
LFQH_l_.str.312:
.asciz	"storeTabScrollViewDidScroll:"
LFQH_l_.str.313:
.asciz	"fqx187_originalStoreDoubleRowScroll:"
LFQH_l_.str.314:
.asciz	"SSBookStoreSearchBarComponent"
LFQH_l_.str.315:
.asciz	"bookStoreVCContext"
LFQH_l_.str.316:
.asciz	"resetTopTabSearchViewWithRatio:fromTab:toTab:fromTabTemplate:toTabTemplate:"
LFQH_l_.str.317:
.asciz	"fqx173_originalSearchColor:from:to:fromTemplate:toTemplate:"
LFQH_l_.str.318:
.asciz	"v40@0:8d16i24i28i32i36"
LFQH_l_.str.319:
.asciz	"fqx173_originalLayout"
LFQH_l_.str.320:
.asciz	"resetColorWithRatio:fromTab:toTab:fromTabTemplate:toTabTemplate:"
LFQH_l_.str.321:
.asciz	"fqx173_originalColor:from:to:fromTemplate:toTemplate:"
LFQH_l_.str.322:
.asciz	"FQReaderSaaSBaseButton"
LFQH_l_.str.323:
.asciz	"fqx170_originalLayout"
LFQH_l_.str.324:
.asciz	"SSBookShelf525ViewController"
LFQH_l_.str.325:
.asciz	"viewLayout"
LFQH_l_.str.326:
.asciz	"fqx186_originalShelfTopLayout"
LFQH_l_.str.327:
.asciz	"fqx186_originalShelfSelected:index:"
LFQH_l_.str.328:
.asciz	"updateCollectionViewInsets"
LFQH_l_.str.329:
.asciz	"fqx186_originalShelfUpdateInsets"
LFQH_l_.str.330:
.asciz	"configFlowLayout"
LFQH_l_.str.331:
.asciz	"fqx186_originalShelfFlowLayout"
LFQH_l_.str.332:
.asciz	"updateFullGenreFloatingViewWithScrollView:"
LFQH_l_.str.333:
.asciz	"fqx186_originalShelfFloating:"
LFQH_l_.str.334:
.asciz	"fqx167_originalShelfLayout"
LFQH_l_.str.335:
.asciz	"scrollViewDidScroll:"
LFQH_l_.str.336:
.asciz	"fqx187_originalShelfScroll:"
LFQH_l_.str.337:
.asciz	"SSNewRefreshHeader"
LFQH_l_.str.338:
.asciz	"animationView"
LFQH_l_.str.339:
.asciz	"isRefreshing"
LFQH_l_.str.340:
.asciz	"setAnimationHidden:"
LFQH_l_.str.341:
.asciz	"fqx188_originalRefreshHidden:"
LFQH_l_.str.342:
.asciz	"setState:"
LFQH_l_.str.343:
.asciz	"fqx188_originalRefreshState:"
LFQH_l_.str.344:
.asciz	"v24@0:8q16"
LFQH_l_.str.345:
.asciz	"placeSubviews"
LFQH_l_.str.346:
.asciz	"fqx188_originalRefreshAnimationLayout"
LFQH_l_.str.347:
.asciz	"fqx188_originalStoreCollectionScroll:"
LFQH_l_.str.348:
.asciz	"fqx167_originalLayout"
LFQH_l_.str.349:
.asciz	"readerInsertedViewThemeConfigChange:"
LFQH_l_.str.350:
.asciz	"fqx167_originalTheme:"
LFQH_l_.str.351:
.asciz	"view"
LFQH_l_.str.352:
.asciz	"presentedViewController"
LFQH_l_.str.353:
.asciz	"viewIfLoaded"
LFQH_l_.str.354:
.asciz	"state"
LFQH_l_.str.355:
.asciz	"translationInView:"
LFQH_l_.str.356:
.asciz	"setNeedsLayout"
LFQH_l_.str.357:
.asciz	"layoutIfNeeded"
LFQH_l_.str.358:
.asciz	"SSTabBar"
LFQH_l_.str.359:
.asciz	"items"
LFQH_l_.str.360:
.asciz	"title"
LFQH_l_.str.361:
.asciz	"NSString"
LFQH_l_.str.362:
.asciz	"length"
LFQH_l_.str.363:
.asciz	"contentView"
LFQH_l_.str.364:
.asciz	"screen"
LFQH_l_.str.365:
.asciz	"scale"
LFQH_l_.str.366:
.asciz	"displayScale"
LFQH_l_.str.367:
.asciz	"iconsOnly"
LFQH_l_.str.368:
.asciz	"autoCompact"
LFQH_l_.str.369:
.asciz	"titleSuppression"
LFQH_l_.str.370:
.asciz	"controlStates178R2"
LFQH_l_.str.371:
.asciz	"compact"
LFQH_l_.str.372:
.asciz	"frame"
LFQH_l_.str.373:
.asciz	"iconPointSize"
LFQH_l_.str.374:
.asciz	"buttonWidthPercent"
LFQH_l_.str.375:
.asciz	"renderer"
LFQH_l_.str.376:
.asciz	"native"
LFQH_l_.str.377:
.asciz	"buttons"
LFQH_l_.str.378:
.asciz	"scrollPanAttached"
LFQH_l_.str.379:
.asciz	"bottomAppearance178"
LFQH_l_.str.380:
.asciz	"tag"
LFQH_l_.str.381:
.asciz	"isOn"
LFQH_l_.str.382:
.asciz	"value"
LFQH_l_.str.383:
.asciz	"setDouble:forKey:"
LFQH_l_.str.384:
.asciz	"removeObjectForKey:"
LFQH_l_.str.385:
.asciz	"setOn:animated:"
LFQH_l_.str.386:
.asciz	"setValue:animated:"
LFQH_l_.str.387:
.asciz	"stringWithUTF8String:"
LFQH_l_.str.388:
.asciz	"respondsToSelector:"
LFQH_l_.str.389:
.asciz	"isKindOfClass:"
LFQH_l_.str.390:
.asciz	"backgroundColor"
LFQH_l_.str.391:
.asciz	"clipsToBounds"
LFQH_l_.str.392:
.asciz	"isOpaque"
LFQH_l_.str.393:
.asciz	"CATransaction"
LFQH_l_.str.394:
.asciz	"begin"
LFQH_l_.str.395:
.asciz	"setDisableActions:"
LFQH_l_.str.396:
.asciz	"insertSubview:atIndex:"
LFQH_l_.str.397:
.asciz	"commit"
LFQH_l_.str.398:
.asciz	"initWithEffect:"
LFQH_l_.str.399:
.asciz	"setUserInteractionEnabled:"
LFQH_l_.str.400:
.asciz	"setAccessibilityElementsHidden:"
LFQH_l_.str.401:
.asciz	"setIsAccessibilityElement:"
LFQH_l_.str.402:
.asciz	"setOpaque:"
LFQH_l_.str.403:
.asciz	"layer"
LFQH_l_.str.404:
.asciz	"cornerRadius"
LFQH_l_.str.405:
.asciz	"setClipsToBounds:"
LFQH_l_.str.406:
.asciz	"setCornerRadius:"
LFQH_l_.str.407:
.asciz	"NSProcessInfo"
LFQH_l_.str.408:
.asciz	"processInfo"
LFQH_l_.str.409:
.asciz	"systemUptime"
LFQH_l_.str.410:
.asciz	"role"
LFQH_l_.str.411:
.asciz	"hostFrame"
LFQH_l_.str.412:
.asciz	"hostBounds"
LFQH_l_.str.413:
.asciz	"glassRect"
LFQH_l_.str.414:
.asciz	"subviews"
LFQH_l_.str.415:
.asciz	"array"
LFQH_l_.str.416:
.asciz	"childCount"
LFQH_l_.str.417:
.asciz	"childrenTruncated"
LFQH_l_.str.418:
.asciz	"childFrames"
LFQH_l_.str.419:
.asciz	"headerLayout173"
LFQH_l_.str.420:
.asciz	"imageView"
LFQH_l_.str.421:
.asciz	"new"
LFQH_l_.str.422:
.asciz	"setConfiguration:"
LFQH_l_.str.423:
.asciz	"isEnabled"
LFQH_l_.str.424:
.asciz	"isSelected"
LFQH_l_.str.425:
.asciz	"isHighlighted"
LFQH_l_.str.426:
.asciz	"insertSubview:belowSubview:"
LFQH_l_.str.427:
.asciz	"setEnabled:"
LFQH_l_.str.428:
.asciz	"setSelected:"
LFQH_l_.str.429:
.asciz	"setHighlighted:"
LFQH_l_.str.430:
.asciz	"titleLabel"
LFQH_l_.str.431:
.asciz	"removeFromSuperview"
LFQH_l_.str.432:
.asciz	"CGRectValue"
LFQH_l_.str.433:
.asciz	"btd_hitTestEdgeInsets"
LFQH_l_.str.434:
.asciz	"setBtd_hitTestEdgeInsets:"
LFQH_l_.str.435:
.asciz	"FQXGlassBackground167"
LFQH_l_.str.436:
.asciz	"fqx167_down:"
LFQH_l_.str.437:
.asciz	"fqx167_up:"
LFQH_l_.str.438:
.asciz	"addTarget:action:forControlEvents:"
LFQH_l_.str.439:
.asciz	"removeTarget:action:forControlEvents:"
LFQH_l_.str.440:
.asciz	"bgView"
LFQH_l_.str.441:
.asciz	"font"
LFQH_l_.str.442:
.asciz	"pointSize"
LFQH_l_.str.443:
.asciz	"fontWithSize:"
LFQH_l_.str.444:
.asciz	"attributedText"
LFQH_l_.str.445:
.asciz	"doubleValue"
LFQH_l_.str.446:
.asciz	"arrayWithObjects:count:"
LFQH_l_.str.447:
.asciz	"imageRect"
LFQH_l_.str.448:
.asciz	"windowRect"
LFQH_l_.str.449:
.asciz	"controlLayout167"
LFQH_l_.str.450:
.asciz	"readerBack"
LFQH_l_.str.451:
.asciz	"readerMore"
LFQH_l_.str.452:
.asciz	"readerSearch"
LFQH_l_.str.453:
.asciz	"readerDownload"
LFQH_l_.str.454:
.asciz	"readerCommunity"
LFQH_l_.str.455:
.asciz	"readerShare"
LFQH_l_.str.456:
.asciz	"readerChapter"
LFQH_l_.str.457:
.asciz	"readerShelf"
LFQH_l_.str.458:
.asciz	"shelfSearch"
LFQH_l_.str.459:
.asciz	"shelfMore"
LFQH_l_.str.460:
.asciz	"icon"
LFQH_l_.str.461:
.asciz	"objectAtIndex:"
LFQH_l_.str.462:
.asciz	"FQReaderNavigationBarMoreBtnInsertObject"
LFQH_l_.str.463:
.asciz	"FQReaderNavigationBarSearchBtnInsertObject"
LFQH_l_.str.464:
.asciz	"SSReaderNavigationBarDownloadBtnInsertObject"
LFQH_l_.str.465:
.asciz	"SSReaderNavigationBarBookShelfBtnInsertObject"
LFQH_l_.str.466:
.asciz	"SSReaderNavigationBarCommunitySwitchBtnInsertObject"
LFQH_l_.str.467:
.asciz	"NSUserDefaults"
LFQH_l_.str.468:
.asciz	"standardUserDefaults"
LFQH_l_.str.469:
.asciz	"FanqieAdBlock.GlassDisabled.1"
LFQH_l_.str.470:
.asciz	"integerForKey:"
LFQH_l_.str.471:
.asciz	"accessibilityLabel"
LFQH_l_.str.472:
.asciz	"accessibilityIdentifier"
LFQH_l_.str.473:
.asciz	"actionsForTarget:forControlEvent:"
LFQH_l_.str.474:
.asciz	"allTargets"
LFQH_l_.str.475:
.asciz	"allObjects"
LFQH_l_.str.476:
.asciz	"NSNull"
LFQH_l_.str.477:
.asciz	"alpha"
LFQH_l_.str.478:
.asciz	"lowercaseString"
LFQH_l_.str.479:
.asciz	"containsString:"
LFQH_l_.str.480:
.asciz	"share"
LFQH_l_.str.481:
.asciz	"\345\210\206\344\272\253"
LFQH_l_.str.482:
.asciz	"\345\210\206\344\272\253\346\234\254\344\271\246"
LFQH_l_.str.483:
.asciz	"\345\210\206\344\272\253\344\271\246\347\261\215"
LFQH_l_.str.484:
.asciz	"share book"
LFQH_l_.str.485:
.asciz	"matched"
LFQH_l_.str.486:
.asciz	"styled"
LFQH_l_.str.487:
.asciz	"inspectedViews"
LFQH_l_.str.488:
.asciz	"scope"
LFQH_l_.str.489:
.asciz	"unresolved"
LFQH_l_.str.490:
.asciz	"accessibility-label"
LFQH_l_.str.491:
.asciz	"accessibility-identifier"
LFQH_l_.str.492:
.asciz	"registered-control-action"
LFQH_l_.str.493:
.asciz	"runtime-insert-class"
LFQH_l_.str.494:
.asciz	"runtime-view-class"
LFQH_l_.str.495:
.asciz	"strategy"
LFQH_l_.str.496:
.asciz	"readerShareResolution178"
LFQH_l_.str.497:
.asciz	"NSNumber"
LFQH_l_.str.498:
.asciz	"numberWithLongLong:"
LFQH_l_.str.499:
.asciz	"numberWithBool:"
LFQH_l_.str.500:
.asciz	"text"
LFQH_l_.str.501:
.asciz	"\345\220\254"
LFQH_l_.str.502:
.asciz	"item"
LFQH_l_.str.503:
.asciz	"FQReaderSaaSBottomToolItem"
LFQH_l_.str.504:
.asciz	"type"
LFQH_l_.str.505:
.asciz	"i16@0:8"
LFQH_l_.str.506:
.asciz	"initWithFrame:"
LFQH_l_.str.507:
.asciz	"convertRect:toView:"
LFQH_l_.str.508:
.asciz	"albumDetailInfo"
LFQH_l_.str.509:
.asciz	"UISlider"
LFQH_l_.str.510:
.asciz	"progress"
LFQH_l_.str.511:
.asciz	"slider"
LFQH_l_.str.512:
.asciz	"NSValue"
LFQH_l_.str.513:
.asciz	"valueWithCGRect:"
LFQH_l_.str.514:
.asciz	"setObject:forKey:"
LFQH_l_.str.515:
.asciz	"numberWithDouble:"
LFQH_l_.str.516:
.asciz	"SSMyUserMiniGameEntranceCellModel"
LFQH_l_.str.517:
.asciz	"SSMyUserShopAndMiniGameEntranceCellModel"
LFQH_l_.str.518:
.asciz	"event"
LFQH_l_.str.519:
.asciz	"pageAdRemoved174"
LFQH_l_.str.520:
.asciz	"ownerClass"
LFQH_l_.str.521:
.asciz	"source"
LFQH_l_.str.522:
.asciz	"serverGameModel"
LFQH_l_.str.523:
.asciz	"action"
LFQH_l_.str.524:
.asciz	"pageAdFilter174"
LFQH_l_.str.525:
.asciz	"functionCell"
LFQH_l_.str.526:
.asciz	"headerView"
LFQH_l_.str.527:
.asciz	"showReadTimeView"
LFQH_l_.str.528:
.asciz	"isFiltering"
LFQH_l_.str.529:
.asciz	"secondaryView"
LFQH_l_.str.530:
.asciz	"fqx178_originalShelfFunctionLayout"
LFQH_l_.str.531:
.asciz	"lineView"
LFQH_l_.str.532:
.asciz	"lineView2"
LFQH_l_.str.533:
.asciz	"collectionView"
LFQH_l_.str.534:
.asciz	"collectionViewLayout"
LFQH_l_.str.535:
.asciz	"invalidateLayout"
LFQH_l_.str.536:
.asciz	"objectForKey:"
LFQH_l_.str.537:
.asciz	"FanqieX.BottomBookstore.1"
LFQH_l_.str.538:
.asciz	"FanqieX.BottomDrama.1"
LFQH_l_.str.539:
.asciz	"FanqieX.BottomBookshelf.1"
LFQH_l_.str.540:
.asciz	"FanqieX.BottomMine.1"
LFQH_l_.str.541:
.asciz	"FanqieX.BottomMall.1"
LFQH_l_.str.542:
.asciz	"FanqieX.ShelfReadingDuration.1"
LFQH_l_.str.543:
.asciz	"FanqieX.MineBenefitsCard.1"
LFQH_l_.str.544:
.asciz	"FanqieX.ReaderBottomBackground.1"
LFQH_l_.str.545:
.asciz	"FanqieX.FullscreenFill.1"
LFQH_l_.str.546:
.asciz	"FanqieX.ShelfFilterButton.1"
LFQH_l_.str.547:
.asciz	"FanqieX.ReaderThemeIsolation.1"
LFQH_l_.str.548:
.asciz	"contentEdgeInsets"
LFQH_l_.str.549:
.asciz	"setContentEdgeInsets:"
LFQH_l_.str.550:
.asciz	"currentTabVC"
LFQH_l_.str.551:
.asciz	"headerRightView"
LFQH_l_.str.552:
.asciz	"tabSelectView"
LFQH_l_.str.553:
.asciz	"visibleCells"
LFQH_l_.str.554:
.asciz	"sizeThatFits:"
LFQH_l_.str.555:
.asciz	"FanqieXBottomToggles176"
LFQH_l_.str.556:
.asciz	"NSObject"
LFQH_l_.str.557:
.asciz	"fqx176_toggle:"
LFQH_l_.str.558:
.asciz	"fqx176_recoverOptions:"
LFQH_l_.str.559:
.asciz	"gestureRecognizer:shouldReceiveTouch:"
LFQH_l_.str.560:
.asciz	"B32@0:8@16@24"
LFQH_l_.str.561:
.asciz	"typeArray"
LFQH_l_.str.562:
.asciz	"refreshTabBar"
LFQH_l_.str.563:
.asciz	"bottomEntryToggle176"
LFQH_l_.str.564:
.asciz	"entry"
LFQH_l_.str.565:
.asciz	"enabled"
LFQH_l_.str.566:
.asciz	"FanqieXMineBenefits"
LFQH_l_.str.567:
.asciz	"updatePlayerLayout"
LFQH_l_.str.568:
.asciz	"FQVPlayer"
LFQH_l_.str.569:
.asciz	"videoEngine"
LFQH_l_.str.570:
.asciz	"isFullScreen"
LFQH_l_.str.571:
.asciz	"FQVShortVideoLandscapePlayerCellView"
LFQH_l_.str.572:
.asciz	"isInPlayerScaleMode"
LFQH_l_.str.573:
.asciz	"playerSuperView"
LFQH_l_.str.574:
.asciz	"scaleMode"
LFQH_l_.str.575:
.asciz	"numberWithInteger:"
LFQH_l_.str.576:
.asciz	"setScaleMode:"
LFQH_l_.str.577:
.asciz	"aspect-fill-178R2"
LFQH_l_.str.578:
.asciz	"mode"
LFQH_l_.str.579:
.asciz	"aspectFill"
LFQH_l_.str.580:
.asciz	"isFullscreen"
LFQH_l_.str.581:
.asciz	"eligibleViewport"
LFQH_l_.str.582:
.asciz	"applied"
LFQH_l_.str.583:
.asciz	"playerBounds"
LFQH_l_.str.584:
.asciz	"windowBounds"
LFQH_l_.str.585:
.asciz	"playerInWindow"
LFQH_l_.str.586:
.asciz	"dramaFullscreenMode"
LFQH_l_.str.587:
.asciz	"UIApplication"
LFQH_l_.str.588:
.asciz	"sharedApplication"
LFQH_l_.str.589:
.asciz	"keyWindow"
LFQH_l_.str.590:
.asciz	"rootViewController"
LFQH_l_.str.591:
.asciz	"windows"
LFQH_l_.str.592:
.asciz	"children"
LFQH_l_.str.593:
.asciz	"intValue"
LFQH_l_.str.594:
.asciz	"titleStrWithType:"
LFQH_l_.str.595:
.asciz	"@20@0:8i16"
LFQH_l_.str.596:
.asciz	"\347\237\255\345\211\247"
LFQH_l_.str.597:
.asciz	"\345\225\206\345\237\216"
LFQH_l_.str.598:
.asciz	"customTabBar"
LFQH_l_.str.599:
.asciz	"removeGestureRecognizer:"
LFQH_l_.str.600:
.asciz	"UILongPressGestureRecognizer"
LFQH_l_.str.601:
.asciz	"initWithTarget:action:"
LFQH_l_.str.602:
.asciz	"setMinimumPressDuration:"
LFQH_l_.str.603:
.asciz	"setDelegate:"
LFQH_l_.str.604:
.asciz	"addGestureRecognizer:"
LFQH_l_.str.605:
.asciz	"fqab_openMenu"
LFQH_l_.str.606:
.asciz	"SSSettingViewController"
LFQH_l_.str.607:
.asciz	"locationInView:"
LFQH_l_.str.608:
.asciz	"UISwitch"
LFQH_l_.str.609:
.asciz	"setTag:"
LFQH_l_.str.610:
.asciz	"setAccessibilityLabel:"
LFQH_l_.str.611:
.asciz	"\345\272\225\346\240\217\346\230\276\347\244\272\357\274\232\344\271\246\345\237\216"
LFQH_l_.str.612:
.asciz	"\345\272\225\346\240\217\346\230\276\347\244\272\357\274\232\347\237\255\345\211\247"
LFQH_l_.str.613:
.asciz	"\345\272\225\346\240\217\346\230\276\347\244\272\357\274\232\344\271\246\346\236\266"
LFQH_l_.str.614:
.asciz	"\345\272\225\346\240\217\346\230\276\347\244\272\357\274\232\346\210\221\347\232\204"
LFQH_l_.str.615:
.asciz	"\345\272\225\346\240\217\346\230\276\347\244\272\357\274\232\345\225\206\345\237\216"
LFQH_l_.str.616:
.asciz	"\344\271\246\346\236\266\346\230\276\347\244\272\344\273\212\346\227\245\347\234\213\345\220\254\350\257\273\346\227\266\351\225\277"
LFQH_l_.str.617:
.asciz	"\346\210\221\347\232\204\346\230\276\347\244\272\351\207\221\345\270\201\344\270\216\347\246\217\345\210\251\345\215\241\347\211\207"
LFQH_l_.str.618:
.asciz	"\346\250\252\345\261\217\347\224\273\351\235\242\351\223\272\346\273\241\357\274\210\347\255\211\346\257\224\350\243\201\345\210\207\357\274\211"
LFQH_l_.str.619:
.asciz	"\344\271\246\346\236\266\346\230\276\347\244\272\347\255\233\351\200\211\346\214\211\351\222\256"
LFQH_l_.str.620:
.asciz	"\344\271\246\345\244\226\344\270\273\351\242\230\350\267\237\351\232\217\347\263\273\347\273\237"
LFQH_l_.str.621:
.asciz	"\351\230\205\350\257\273\350\217\234\345\215\225\346\230\276\347\244\272\344\270\212\344\270\213\346\240\217\350\203\214\346\231\257"
LFQH_l_.str.622:
.asciz	"cellSpacing"
LFQH_l_.str.623:
.asciz	"d16@0:8"
LFQH_l_.str.624:
.asciz	"maskTitleLabel"
LFQH_l_.str.625:
.asciz	"systemOrangeColor"
LFQH_l_.str.626:
.asciz	"ruleId"
LFQH_l_.str.627:
.asciz	"bookstore_imc_popup"
LFQH_l_.str.628:
.asciz	"ruleType"
LFQH_l_.str.629:
.asciz	"exactHostSelector"
LFQH_l_.str.630:
.asciz	"class"
LFQH_l_.str.631:
.asciz	"selector"
LFQH_l_.str.632:
.asciz	"result"
LFQH_l_.str.633:
.asciz	"blocked"
LFQH_l_.str.634:
.asciz	"pageDisplay"
LFQH_l_.str.635:
.asciz	"unobserved"
LFQH_l_.str.636:
.asciz	"adRuleDecision"
LFQH_l_.str.637:
.asciz	"BDReaderViewController"
LFQH_l_.str.638:
.asciz	"BDReaderThemeConfig"
LFQH_l_.str.639:
.asciz	"themeStyle"
LFQH_l_.str.640:
.asciz	"Q16@0:8"
LFQH_l_.str.641:
.asciz	"q16@0:8"
LFQH_l_.str.642:
.asciz	"viewWillAppear:"
LFQH_l_.str.643:
.asciz	"fqx192_originalReaderWillAppear:"
LFQH_l_.str.644:
.asciz	"onConfigThemeChange:"
LFQH_l_.str.645:
.asciz	"fqx192_originalReaderTheme:"
LFQH_l_.str.646:
.asciz	"readerModel"
LFQH_l_.str.647:
.asciz	"config"
LFQH_l_.str.648:
.asciz	"themeConfig"
LFQH_l_.str.649:
.asciz	"tryChangeSameThemeConfig:successCallback:failedCallback:"
LFQH_l_.str.650:
.asciz	"tryChangethemeConfig:successCallback:failedCallback:"
LFQH_l_.str.651:
.asciz	"tryChangeDiffThemeConfig:successCallback:failedCallback:"
LFQH_l_.str.652:
.asciz	"v40@0:8@16@?24@?32"
LFQH_l_.str.653:
.asciz	"setTargetIsDark:"
LFQH_l_.str.654:
.asciz	"readerClientDidChangeSetting:bookId:"
LFQH_l_.str.655:
.asciz	"fqx191_originalReaderDiffTheme:success:failure:"
LFQH_l_.str.656:
.asciz	"fqx191_originalReaderSetting:book:"
LFQH_l_.str.657:
.asciz	"onDarkModeChange:"
LFQH_l_.str.658:
.asciz	"fqx191_originalReaderDarkMode:"
LFQH_l_.str.659:
.asciz	"onDarkModeSwitchChange:"
LFQH_l_.str.660:
.asciz	"fqx191_originalReaderDarkModeSwitch:"
LFQH_l_.str.661:
.asciz	"FQReaderThemeConfigChangeContext"
LFQH_l_.str.662:
.asciz	"needSaveConfig"
LFQH_l_.str.663:
.asciz	"FQReaderSaaSUIConfig"
LFQH_l_.str.664:
.asciz	"themeConfigForKey:"
LFQH_l_.str.665:
.asciz	"onSelectSettingView:themeConfig:"
LFQH_l_.str.666:
.asciz	"fqx191_originalReaderPalette:theme:"
LFQH_l_.str.667:
.asciz	"FQReaderManager"
LFQH_l_.str.668:
.asciz	"onBDReaderVCWillAppearWithReadModel:"
LFQH_l_.str.669:
.asciz	"fqx191_originalReaderWillAppear:"
LFQH_l_.str.670:
.asciz	"readerMgr"
LFQH_l_.str.671:
.asciz	"UIMgr"
LFQH_l_.str.672:
.asciz	"themeKey"
LFQH_l_.str.673:
.asciz	"UIConfig"
LFQH_l_.str.674:
.asciz	"FanqieX.ReaderThemePreset.1"
LFQH_l_.str.675:
.asciz	"FQVShortVideoVPlayerSeriesControlView"
LFQH_l_.str.676:
.asciz	"fqx178R2_originalControlsLayout"
LFQH_l_.str.677:
.asciz	"fqx178R2_originalSeriesControlsLayout"
LFQH_l_.str.678:
.asciz	"lastRenderModel"
LFQH_l_.str.679:
.asciz	"bottomBar"
LFQH_l_.str.680:
.asciz	"bottomBarType"
LFQH_l_.str.681:
.asciz	"short_play"
LFQH_l_.str.682:
.asciz	"unreal_short_play"
LFQH_l_.str.683:
.asciz	"album"
LFQH_l_.str.684:
.asciz	"defaultContentView"
LFQH_l_.str.685:
.asciz	"SSShortVideoDistributionContentView"
LFQH_l_.str.686:
.asciz	"firstObject"
LFQH_l_.str.687:
.asciz	"containerView"
LFQH_l_.str.688:
.asciz	"landscapePlayerViewFrame"
LFQH_l_.str.689:
.asciz	"{CGRect={CGPoint=dd}{CGSize=dd}}16@0:8"
LFQH_l_.str.690:
.asciz	"setIsFullScreen:"
LFQH_l_.str.691:
.asciz	"setVideoEngine:"
LFQH_l_.str.692:
.asciz	"prepareWithVideoInfo:async:"
LFQH_l_.str.693:
.asciz	"v28@0:8@16B24"
LFQH_l_.str.694:
.asciz	"videoEngineReadyToDisPlay:"
LFQH_l_.str.695:
.asciz	"vPlayer"
LFQH_l_.str.696:
.asciz	"modelDidDisplay"
LFQH_l_.str.697:
.asciz	"TTVideoEngine"
LFQH_l_.str.698:
.asciz	"fqx190_originalLandscapeFrame"
LFQH_l_.str.699:
.asciz	"fqx190_originalPlayerLayout"
LFQH_l_.str.700:
.asciz	"fqx190_originalPlayerFullscreen:"
LFQH_l_.str.701:
.asciz	"fqx190_originalPlayerEngine:"
LFQH_l_.str.702:
.asciz	"fqx190_originalPlayerPrepare:async:"
LFQH_l_.str.703:
.asciz	"fqx190_originalPlayerReady:"
LFQH_l_.str.704:
.asciz	"fqx190_originalLandscapeDisplay"
LFQH_l_.str.705:
.asciz	"navigationContainer"
LFQH_l_.str.706:
.asciz	"BDReaderTopViewContainer"
LFQH_l_.str.707:
.asciz	"updateGradientLayer"
LFQH_l_.str.708:
.asciz	"nProgressView"
LFQH_l_.str.709:
.asciz	"tabBar"
LFQH_l_.str.710:
.asciz	"BDReaderViewContainer"
LFQH_l_.str.711:
.asciz	"horizonLineView"
LFQH_l_.str.712:
.asciz	"setAlpha:"
LFQH_l_.str.713:
.asciz	"bottomToolbarInsertContainer"
LFQH_l_.str.714:
.asciz	"currentBottomToolbarInsertObject"
LFQH_l_.str.715:
.asciz	"SSReaderBottomToolbarItemContainerView"
LFQH_l_.str.716:
.asciz	"itemViews"
LFQH_l_.str.717:
.asciz	"bottomToolbarInsertTopLineView"
LFQH_l_.str.718:
.asciz	"\345\217\221\350\256\250\350\256\272"
LFQH_l_.str.719:
.asciz	"\345\234\210\345\255\220"
LFQH_l_.str.720:
.asciz	"readerBottomTool"
LFQH_l_.str.721:
.asciz	"onBtnClick:"
LFQH_l_.str.722:
.asciz	"FQXReaderCatalogTap"
LFQH_l_.str.723:
.asciz	"fqx_catalogTapped:"
LFQH_l_.str.724:
.asciz	"UITapGestureRecognizer"
LFQH_l_.str.725:
.asciz	"setCancelsTouchesInView:"
LFQH_l_.str.726:
.asciz	"leftBtn"
LFQH_l_.str.727:
.asciz	"rightBtn"
LFQH_l_.str.728:
.asciz	"BDReaderNewSlider"
LFQH_l_.str.729:
.asciz	"trackView"
LFQH_l_.str.730:
.asciz	"readerProgressTrack"
LFQH_l_.str.731:
.asciz	"progressView"
LFQH_l_.str.732:
.asciz	"giftButton"
LFQH_l_.str.733:
.asciz	"listenBtn"
LFQH_l_.str.734:
.asciz	"listenLabel"
LFQH_l_.str.735:
.asciz	"guideView"
LFQH_l_.str.736:
.asciz	"\345\267\246\346\273\221\345\274\200\345\247\213\351\230\205\350\257\273"
LFQH_l_.str.737:
.asciz	"\344\270\212\346\273\221\345\274\200\345\247\213\351\230\205\350\257\273"
LFQH_l_.str.738:
.asciz	"borderWidth"
LFQH_l_.str.739:
.asciz	"setBorderWidth:"
LFQH_l_.str.740:
.asciz	"activeEntranceView"
LFQH_l_.str.741:
.asciz	"contentBackgroundView"
LFQH_l_.str.742:
.asciz	"model"
LFQH_l_.str.743:
.asciz	"displayMode"
LFQH_l_.str.744:
.asciz	"capsuleConfigurationWithMaximumRadius:"
LFQH_l_.str.745:
.asciz	"authorInfoView"
LFQH_l_.str.746:
.asciz	"SSReaderChapterEndAuthorInfoView"
LFQH_l_.str.747:
.asciz	"customBackgroundView"
LFQH_l_.str.748:
.asciz	"SSReaderChapterEndCombineContainerView"
LFQH_l_.str.749:
.asciz	"isSelect"
LFQH_l_.str.750:
.asciz	"filterGradientView"
LFQH_l_.str.751:
.asciz	"optionsView"
LFQH_l_.str.752:
.asciz	"scanQRCodeView"
LFQH_l_.str.753:
.asciz	"darkModeImageView"
LFQH_l_.str.754:
.asciz	"sideBarButtonView"
LFQH_l_.str.755:
.asciz	"entranceView"
LFQH_l_.str.756:
.asciz	"entranceBgLayer"
LFQH_l_.str.757:
.asciz	"publishIcon"
LFQH_l_.str.758:
.asciz	"closeIcon"
LFQH_l_.str.759:
.asciz	"gradientLayer"
LFQH_l_.str.760:
.asciz	"backgroundStyleOptV697"
LFQH_l_.str.761:
.asciz	"publishImageBackgroundView"
LFQH_l_.str.762:
.asciz	"darkModeMaskView"
LFQH_l_.str.763:
.asciz	"publishImageView"
LFQH_l_.str.764:
.asciz	"publishTintLabel"
LFQH_l_.str.765:
.asciz	"CAGradientLayer"
LFQH_l_.str.766:
.asciz	"colors"
LFQH_l_.str.767:
.asciz	"setColors:"
LFQH_l_.str.768:
.asciz	"sidebarAdapter"
LFQH_l_.str.769:
.asciz	"isSidebarOpen"
LFQH_l_.str.770:
.asciz	"isSidebarTransitioning"
LFQH_l_.str.771:
.asciz	"myUserBar"
LFQH_l_.str.772:
.asciz	"FQFeedListCollectionView"
LFQH_l_.str.773:
.asciz	"profile"
LFQH_l_.str.774:
.asciz	"UIScrollView"
LFQH_l_.str.775:
.asciz	"topEdgeEffect"
LFQH_l_.str.776:
.asciz	"UIBlurEffect"
LFQH_l_.str.777:
.asciz	"systemBackgroundColor"
LFQH_l_.str.778:
.asciz	"contentInset"
LFQH_l_.str.779:
.asciz	"containerScrollView"
LFQH_l_.str.780:
.asciz	"contentOffset"
LFQH_l_.str.781:
.asciz	"adjustedContentInset"
LFQH_l_.str.782:
.asciz	"setContentInset:"
LFQH_l_.str.783:
.asciz	"setContentOffset:"
LFQH_l_.str.784:
.asciz	"mj_header"
LFQH_l_.str.785:
.asciz	"isDragging"
LFQH_l_.str.786:
.asciz	"material"
LFQH_l_.str.787:
.asciz	"systemUltraThin"
LFQH_l_.str.788:
.asciz	"stock"
LFQH_l_.str.789:
.asciz	"stockViewportFrame"
LFQH_l_.str.790:
.asciz	"viewportRect"
LFQH_l_.str.791:
.asciz	"scrollClipRect"
LFQH_l_.str.792:
.asciz	"topChromeGeometry"
LFQH_l_.str.793:
.asciz	"SSMyUser621FunctionEntryItemCell"
LFQH_l_.str.794:
.asciz	"SSMyUserShortcutCell"
LFQH_l_.str.795:
.asciz	"SSMyUserCollectionView1Cell"
LFQH_l_.str.796:
.asciz	"productImage"
LFQH_l_.str.797:
.asciz	"image"
LFQH_l_.str.798:
.asciz	"functionType"
LFQH_l_.str.799:
.asciz	"label"
LFQH_l_.str.800:
.asciz	"SSMineEcomEntranceData"
LFQH_l_.str.801:
.asciz	"entranceType"
LFQH_l_.str.802:
.asciz	"mutableCopy"
LFQH_l_.str.803:
.asciz	"autorelease"
LFQH_l_.str.804:
.asciz	"removeObjectAtIndex:"
LFQH_l_.str.805:
.asciz	"filterConfiguredGameEntrances"
LFQH_l_.str.806:
.asciz	"filterStandaloneGameRows"
LFQH_l_.str.807:
.asciz	"businessStyle"
LFQH_l_.str.808:
.asciz	"isShowPersonalizedBar"
LFQH_l_.str.809:
.asciz	"isShowFriendView"
LFQH_l_.str.810:
.asciz	"SSCoverTransitionInfo"
LFQH_l_.str.811:
.asciz	"setCoverFrame:"
LFQH_l_.str.812:
.asciz	"v48@0:8{CGRect={CGPoint=dd}{CGSize=dd}}16"
LFQH_l_.str.813:
.asciz	"openingModel"
LFQH_l_.str.814:
.asciz	"data"
LFQH_l_.str.815:
.asciz	"bookId"
LFQH_l_.str.816:
.asciz	"collectDatas"
LFQH_l_.str.817:
.asciz	"fetchCoverView"
LFQH_l_.str.818:
.asciz	"fetchCoverSize"
LFQH_l_.str.819:
.asciz	"{CGSize=dd}16@0:8"
LFQH_l_.str.820:
.asciz	"SSBookShelfFunctionCell"
LFQH_l_.str.821:
.asciz	"SSBookShelfViewModel"
LFQH_l_.str.822:
.asciz	"sectionTypeAtIndex:"
LFQH_l_.str.823:
.asciz	"q24@0:8q16"
LFQH_l_.str.824:
.asciz	"showsFilterExposure"
LFQH_l_.str.825:
.asciz	"cellHeightWithFilterExposure:"
LFQH_l_.str.826:
.asciz	"d20@0:8B16"
LFQH_l_.str.827:
.asciz	"collectionView:layout:sizeForItemAtIndexPath:"
LFQH_l_.str.828:
.asciz	"fqx178_originalShelfFunctionSize:layout:index:"
LFQH_l_.str.829:
.asciz	"{CGSize=dd}40@0:8@16@24@32"
LFQH_l_.str.830:
.asciz	"fqx181_originalShelfInsets:layout:section:"
LFQH_l_.str.831:
.asciz	"layoutContainerSubviews"
LFQH_l_.str.832:
.asciz	"section"
LFQH_l_.str.833:
.asciz	"viewModel"
LFQH_l_.str.834:
.asciz	"filterClipView"
LFQH_l_.str.835:
.asciz	"FQVShortVideoListConfig"
LFQH_l_.str.836:
.asciz	"fqx193_originalDramaDockColor"
LFQH_l_.str.837:
.asciz	"feedType"
LFQH_l_.str.838:
.asciz	"listVCBackgroundColor"
LFQH_l_.str.839:
.asciz	"installed"
LFQH_l_.str.840:
.asciz	"native-video-size-178"
LFQH_l_.str.841:
.asciz	"videoSizeOverridden"
LFQH_l_.str.842:
.asciz	"dramaDockBackdropInstall"
LFQH_l_.str.843:
.asciz	"#1D1D1D"
LFQH_l_.str.844:
.asciz	"#000000"
LFQH_l_.str.845:
.asciz	"dramaDockBackdrop"
LFQH_l_.str.846:
.asciz	"blackColor"
LFQH_l_.str.847:
.asciz	"setTypeArray:"
LFQH_l_.str.848:
.asciz	"setTypeIndexMap:"
LFQH_l_.str.849:
.asciz	"numberWithUnsignedInteger:"
LFQH_l_.str.850:
.asciz	"speechBtn"
LFQH_l_.str.851:
.asciz	"imageForState:"
LFQH_l_.str.852:
.asciz	"BDNovelNewAssetsGenerated"
LFQH_l_.str.853:
.asciz	"bdn_novelReaderListenButton"
LFQH_l_.str.854:
.asciz	"imageWithRenderingMode:"
LFQH_l_.str.855:
.asciz	"setImage:forState:"
LFQH_l_.str.856:
.asciz	"simpleHeader"
LFQH_l_.str.857:
.asciz	"simpleTabView"
LFQH_l_.str.858:
.asciz	"tabContainer"
LFQH_l_.str.859:
.asciz	"signBgView"
LFQH_l_.str.860:
.asciz	"backgroundView"
LFQH_l_.str.861:
.asciz	"retain"
LFQH_l_.str.862:
.asciz	"bookstore"
LFQH_l_.str.863:
.asciz	"currentSelectedListViewController"
LFQH_l_.str.864:
.asciz	"doubleRowNestContainerScrollView"
LFQH_l_.str.865:
.asciz	"doubleRowUnlimitedCollectionView"
LFQH_l_.str.866:
.asciz	"listView"
LFQH_l_.str.867:
.asciz	"nestedView"
LFQH_l_.str.868:
.asciz	"indexOfObjectIdenticalTo:"
LFQH_l_.str.869:
.asciz	"headerBackgroundView"
LFQH_l_.str.870:
.asciz	"headerBgImgView"
LFQH_l_.str.871:
.asciz	"bookshelf"
LFQH_l_.str.872:
.asciz	"UICollectionViewFlowLayout"
LFQH_l_.str.873:
.asciz	"sectionHeadersPinToVisibleBounds"
LFQH_l_.str.874:
.asciz	"setSectionHeadersPinToVisibleBounds:"
LFQH_l_.str.875:
.asciz	"uiConfigParams"
LFQH_l_.str.876:
.asciz	"fq_reader_saas_ColorWithName:"
LFQH_l_.str.877:
.asciz	"SS_COLOR_BG_FF"
LFQH_l_.str.878:
.asciz	"refreshHeader"
LFQH_l_.str.879:
.asciz	"selectedIndex"
LFQH_l_.str.880:
.asciz	"viewControllers"
LFQH_l_.str.881:
.asciz	"videoGeometryChanged"
LFQH_l_.str.882:
.asciz	"bottomCompact178"
LFQH_l_.str.883:
.asciz	"attributedTitleForState:"
LFQH_l_.str.884:
.asciz	"titleForState:"
LFQH_l_.str.885:
.asciz ""
LFQH_l_.str.886:
.asciz	"setTitle:forState:"
LFQH_l_.str.887:
.asciz	"setAttributedTitle:forState:"
LFQH_l_.str.888:
.asciz	"panGestureRecognizer"
LFQH_l_.str.889:
.asciz	"addTarget:action:"
LFQH_l_.str.890:
.asciz	"fqx178_bottomPan:"
LFQH_l_.str.891:
.asciz	"FanqieXBottomPan178"
LFQH_l_.str.892:
.asciz	"UISegmentedControl"
LFQH_l_.str.893:
.asciz	"titleTextAttributesForState:"
LFQH_l_.str.894:
.asciz	"NSColor"
LFQH_l_.str.895:
.asciz	"setTitleTextAttributes:forState:"
LFQH_l_.str.896:
.asciz	"currentImage"
LFQH_l_.str.897:
.asciz	"UIImageSymbolConfiguration"
LFQH_l_.str.898:
.asciz	"configurationWithPointSize:weight:scale:"
LFQH_l_.str.899:
.asciz	"UIImage"
LFQH_l_.str.900:
.asciz	"systemImageNamed:withConfiguration:"
LFQH_l_.str.901:
.asciz	"setContentMode:"
LFQH_l_.str.902:
.asciz	"setImage:"
LFQH_l_.str.903:
.asciz	"currentTitle"
LFQH_l_.str.904:
.asciz	"\344\271\246\345\237\216"
LFQH_l_.str.905:
.asciz	"\351\246\226\351\241\265"
LFQH_l_.str.906:
.asciz	"house.fill"
LFQH_l_.str.907:
.asciz	"house"
LFQH_l_.str.908:
.asciz	"\350\247\206\351\242\221"
LFQH_l_.str.909:
.asciz	"play.rectangle.fill"
LFQH_l_.str.910:
.asciz	"play.rectangle"
LFQH_l_.str.911:
.asciz	"\344\271\246\346\236\266"
LFQH_l_.str.912:
.asciz	"books.vertical.fill"
LFQH_l_.str.913:
.asciz	"books.vertical"
LFQH_l_.str.914:
.asciz	"\346\210\221\347\232\204"
LFQH_l_.str.915:
.asciz	"person.fill"
LFQH_l_.str.916:
.asciz	"person"
LFQH_l_.str.917:
.asciz	"bag.fill"
LFQH_l_.str.918:
.asciz	"bag"
LFQH_l_.str.919:
.asciz	"\347\237\255\345\217\245"
LFQH_l_.str.920:
.asciz	"text.bubble.fill"
LFQH_l_.str.921:
.asciz	"text.bubble"
LFQH_l_.str.922:
.asciz	"null"
LFQH_l_.str.923:
.asciz	"removeTarget:action:"
LFQH_l_.str.924:
.asciz	"FanqieX.BottomIconsOnly.1"
LFQH_l_.str.925:
.asciz	"FanqieX.BottomDramaCompact.1"
LFQH_l_.str.926:
.asciz	"FanqieX.BottomLengthScale.1"
LFQH_l_.str.927:
.asciz	"FanqieX.BottomHeightScale.1"
LFQH_l_.str.928:
.asciz	"FanqieX.BottomButtonWidthScale.1"
LFQH_l_.str.929:
.asciz	"FanqieX.BottomIconPointSize.1"
LFQH_l_.str.930:
.asciz	"setBool:forKey:"
LFQH_l_.str.931:
.asciz	"stringValue"
LFQH_l_.str.932:
.asciz	"stringByAppendingString:"
LFQH_l_.str.933:
.asciz	" pt"
LFQH_l_.str.934:
.asciz	"%"
LFQH_l_.str.935:
.asciz	"FanqieXBottomOptionsRouter178"
LFQH_l_.str.936:
.asciz	"fqx178_openBottom:"
LFQH_l_.str.937:
.asciz	"buttonWithType:"
LFQH_l_.str.938:
.asciz	"\345\272\225\346\240\217\345\244\226\350\247\202\344\270\216\345\260\272\345\257\270  \342\200\272"
LFQH_l_.str.939:
.asciz	"\345\272\225\346\240\217\345\244\226\350\247\202\344\270\216\345\260\272\345\257\270"
LFQH_l_.str.940:
.asciz	"navigationController"
LFQH_l_.str.941:
.asciz	"setTitle:"
LFQH_l_.str.942:
.asciz	"pushViewController:animated:"
LFQH_l_.str.943:
.asciz	"FanqieXBottomAppearance178Controller"
LFQH_l_.str.944:
.asciz	"UIViewController"
LFQH_l_.str.945:
.asciz	"viewDidLoad"
LFQH_l_.str.946:
.asciz	"fqx178_bottomOptionChanged:"
LFQH_l_.str.947:
.asciz	"fqx178_resetBottom:"
LFQH_l_.str.948:
.asciz	"UIScreen"
LFQH_l_.str.949:
.asciz	"mainScreen"
LFQH_l_.str.950:
.asciz	"systemGroupedBackgroundColor"
LFQH_l_.str.951:
.asciz	"setAlwaysBounceVertical:"
LFQH_l_.str.952:
.asciz	"setContentSize:"
LFQH_l_.str.953:
.asciz	"\346\230\276\347\244\272\346\226\271\345\274\217"
LFQH_l_.str.954:
.asciz	"\345\272\225\346\240\217\344\273\205\346\230\276\347\244\272\345\233\276\346\240\207"
LFQH_l_.str.955:
.asciz	"\345\274\200\345\220\257\345\220\216\351\232\220\350\227\217\346\226\207\345\255\227\357\274\214\344\277\235\347\225\231\345\216\237\345\205\245\345\217\243\345\222\214\346\234\227\350\257\273\345\220\215\347\247\260\343\200\202"
LFQH_l_.str.956:
.asciz	"\347\237\255\345\211\247\346\273\232\345\212\250\350\207\252\345\212\250\346\224\266\347\274\251"
LFQH_l_.str.957:
.asciz	"\346\265\217\350\247\210\344\270\213\344\270\200\346\235\241\346\227\266\346\224\266\347\274\251\357\274\214\345\217\215\345\220\221\346\273\221\345\212\250\345\261\225\345\274\200\357\274\233\345\210\207\346\215\242\351\241\265\351\235\242\346\201\242\345\244\215\343\200\202"
LFQH_l_.str.958:
.asciz	"\345\260\272\345\257\270"
LFQH_l_.str.959:
.asciz	"\350\203\266\345\233\212\351\225\277\345\272\246"
LFQH_l_.str.960:
.asciz	"\350\203\266\345\233\212\351\253\230\345\272\246"
LFQH_l_.str.961:
.asciz	"\346\214\211\351\222\256\345\256\275\345\272\246"
LFQH_l_.str.962:
.asciz	"\345\233\276\346\240\207\345\244\247\345\260\217"
LFQH_l_.str.963:
.asciz	"\346\214\211\351\222\256\345\256\275\345\272\246\350\260\203\346\225\264\350\203\266\345\233\212\345\206\205\347\232\204\346\214\211\351\222\256\345\214\272\345\237\237\343\200\202\350\277\207\345\260\217\347\232\204\345\260\272\345\257\270\344\274\232\350\207\252\345\212\250\344\277\235\347\225\231\347\202\271\345\207\273\347\251\272\351\227\264\357\274\233\345\260\272\345\257\270\345\215\263\346\227\266\347\224\237\346\225\210\343\200\202"
LFQH_l_.str.964:
.asciz	"\346\201\242\345\244\215\345\272\225\346\240\217\351\273\230\350\256\244\350\256\276\347\275\256"
LFQH_l_.str.965:
.asciz	"setTextAlignment:"
LFQH_l_.str.966:
.asciz	"setMinimumValue:"
LFQH_l_.str.967:
.asciz	"setMaximumValue:"
