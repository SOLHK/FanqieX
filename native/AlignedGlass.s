// Source SHA-256: 92e70afeb5f389a2f8ba8e7f254c1d3bfa6dec701af7f8c84914ed96d0c7d61a
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
cbz	w0, LFQH_LBB0_6
LFQH_Lloh8:
adr x0, LFQH_l_.str.4
LFQH_Lloh9:
nop
bl Lpatch + (0xa5a4 - PATCH_BASE)
mov	x21, x0
LFQH_Lloh10:
adr x0, LFQH_l_.str.85
LFQH_Lloh11:
nop
bl Lpatch + (0xa5b0 - PATCH_BASE)
mov	x22, x0
LFQH_Lloh12:
adr x0, LFQH_l_.str.86
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
cbz	w0, LFQH_LBB0_6
LFQH_Lloh18:
adr x0, LFQH_l_.str.7
LFQH_Lloh19:
nop
LFQH_Lloh20:
adr x1, LFQH_l_.str.8
LFQH_Lloh21:
nop
LFQH_Lloh22:
adr x2, LFQH_l_.str.9
LFQH_Lloh23:
nop
bl	LFQH_Signature
cbz	w0, LFQH_LBB0_6
LFQH_Lloh24:
adr x0, LFQH_l_.str.7
LFQH_Lloh25:
nop
LFQH_Lloh26:
adr x1, LFQH_l_.str.10
LFQH_Lloh27:
nop
LFQH_Lloh28:
adr x2, LFQH_l_.str.11
LFQH_Lloh29:
nop
bl	LFQH_Signature
cbz	w0, LFQH_LBB0_6
LFQH_Lloh30:
adr x0, LFQH_l_.str.12
LFQH_Lloh31:
nop
LFQH_Lloh32:
adr x1, LFQH_l_.str.13
LFQH_Lloh33:
nop
LFQH_Lloh34:
adr x2, LFQH_l_.str.9
LFQH_Lloh35:
nop
bl	LFQH_Signature
cbz	w0, LFQH_LBB0_6
LFQH_Lloh36:
adr x0, LFQH_l_.str.12
LFQH_Lloh37:
nop
LFQH_Lloh38:
adr x1, LFQH_l_.str.14
LFQH_Lloh39:
nop
LFQH_Lloh40:
adr x2, LFQH_l_.str.15
LFQH_Lloh41:
nop
bl	LFQH_Signature
mov	x20, x0
b	LFQH_LBB0_7
LFQH_LBB0_6:
mov	w20, #0
LFQH_LBB0_7:
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
LFQH_Lloh42:
adr x0, LFQH_l_.str.40
LFQH_Lloh43:
nop
bl Lpatch + (0xa5a4 - PATCH_BASE)
mov	x21, x0
LFQH_Lloh44:
adr x0, LFQH_l_.str.85
LFQH_Lloh45:
nop
bl Lpatch + (0xa5b0 - PATCH_BASE)
mov	x22, x0
LFQH_Lloh46:
adr x0, LFQH_l_.str.86
LFQH_Lloh47:
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
LFQH_Lloh48:
adr x0, LFQH_l_.str.85
LFQH_Lloh49:
nop
bl Lpatch + (0xa5b0 - PATCH_BASE)
mov	x20, x0
LFQH_Lloh50:
adr x0, LFQH_l_.str.86
LFQH_Lloh51:
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
mov	x19, x2
mov	x20, x1
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
LFQH_Lloh52:
adr x0, LFQH_l_.str.16
LFQH_Lloh53:
nop
bl Lpatch + (0xa5b0 - PATCH_BASE)
LFQH_Lloh54:
adr x1, LFQH_l_.str.17
LFQH_Lloh55:
nop
bl	LFQH_Responds
cbz	w0, LFQH_LBB4_4
LFQH_Lloh56:
adr x0, LFQH_l_.str.18
LFQH_Lloh57:
nop
bl Lpatch + (0xa5b0 - PATCH_BASE)
LFQH_Lloh58:
adr x1, LFQH_l_.str.19
LFQH_Lloh59:
nop
bl	LFQH_Responds
cbz	w0, LFQH_LBB4_4
LFQH_Lloh60:
adr x0, LFQH_l_.str.20
LFQH_Lloh61:
nop
bl Lpatch + (0xa5b0 - PATCH_BASE)
mov	x19, x0
LFQH_Lloh62:
adr x0, LFQH_l_.str.21
LFQH_Lloh63:
nop
bl Lpatch + (0xa5a4 - PATCH_BASE)
mov	x1, x0
mov	x0, x19
bl Lpatch + (0xa5f8 - PATCH_BASE)
cbz	x0, LFQH_LBB4_4
LFQH_Lloh64:
adr x0, LFQH_l_.str.16
LFQH_Lloh65:
nop
bl Lpatch + (0xa5b0 - PATCH_BASE)
mov	x19, x0
LFQH_Lloh66:
adr x0, LFQH_l_.str.22
LFQH_Lloh67:
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
LFQH_Lloh68:
adr x0, LFQH_l_.str.87
LFQH_Lloh69:
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
LFQH_Lloh70:
adr x1, LFQH_l_.str.23
LFQH_Lloh71:
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
LFQH_Lloh72:
adr x1, LFQH_l_.str.24
LFQH_Lloh73:
nop
mov	x0, x19
bl	LFQH_Get
cbz	x0, LFQH_LBB6_2
mov	x20, x0
mov	w26, #0
LFQH_Lloh74:
adr x21, LFQH_l_.str.88
LFQH_Lloh75:
nop
LFQH_Lloh76:
adr x22, LFQH_l_.str.25
LFQH_Lloh77:
nop
LFQH_Lloh78:
adr x23, LFQH_l_.str.24
LFQH_Lloh79:
nop
LFQH_Lloh80:
adr x24, LFQH_l_.str.26
LFQH_Lloh81:
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
LFQH_Lloh82:
adr x0, LFQH_l_.str.88
LFQH_Lloh83:
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
LFQH_Lloh84:
adr x1, LFQH_SurfaceKey
LFQH_Lloh85:
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
LFQH_Lloh86:
adr x1, LFQH_l_.str.27
LFQH_Lloh87:
nop
bl	LFQH_Kind
cbz	w0, LFQH_LBB11_2
LFQH_Lloh88:
adr x1, LFQH_BusyKey
LFQH_Lloh89:
nop
mov	x0, x19
bl Lpatch + (0xa628 - PATCH_BASE)
cbz	x0, LFQH_LBB11_3
LFQH_LBB11_2:
ldp	x29, x30, [sp, #80]
ldp	x20, x19, [sp, #64]
ldp	x22, x21, [sp, #48]
ldp	x24, x23, [sp, #32]
ldp	d9, d8, [sp, #16]
ldp	d11, d10, [sp], #96
ret
LFQH_LBB11_3:
LFQH_Lloh90:
adr x1, LFQH_BusyKey
LFQH_Lloh91:
nop
mov	x0, x19
mov	x2, x19
mov	x3, #0
bl Lpatch + (0xa634 - PATCH_BASE)
LFQH_Lloh92:
adr x1, LFQH_SurfaceKey
LFQH_Lloh93:
nop
mov	x0, x19
bl Lpatch + (0xa628 - PATCH_BASE)
mov	x20, x0
LFQH_Lloh94:
adr x0, LFQH_l_.str.28
LFQH_Lloh95:
nop
bl Lpatch + (0xa5a4 - PATCH_BASE)
mov	x1, x0
mov	x0, x19
bl Lpatch + (0xa5d4 - PATCH_BASE)
mov.16b	v8, v0
mov.16b	v9, v1
mov.16b	v10, v2
mov.16b	v11, v3
bl	LFQH_Enabled
cbz	w0, LFQH_LBB11_18
bl	LFQH_FQHGlassAvailable
fmov	x8, d8
and	x8, x8, #0x7fffffffffffffff
mov	x10, #9218868437227405311
cmp	x8, x10
cset	w8, gt
fmov	x9, d9
and	x9, x9, #0x7fffffffffffffff
cmp	x9, x10
cset	w9, gt
fmov	x11, d10
and	x11, x11, #0x7fffffffffffffff
cmp	x11, x10
cset	w10, gt
cbz	w0, LFQH_LBB11_18
tbnz	w8, #0, LFQH_LBB11_18
tbnz	w9, #0, LFQH_LBB11_18
tbnz	w10, #0, LFQH_LBB11_18
fmov	x8, d11
and	x8, x8, #0x7fffffffffffffff
mov	x9, #9218868437227405311
cmp	x8, x9
b.gt	LFQH_LBB11_18
fcmp	d10, #0.0
b.le	LFQH_LBB11_18
fcmp	d11, #0.0
b.le	LFQH_LBB11_18
cbz	x20, LFQH_LBB11_25
LFQH_LBB11_12:
LFQH_Lloh96:
adr x0, LFQH_l_.str.38
LFQH_Lloh97:
nop
bl Lpatch + (0xa5b0 - PATCH_BASE)
mov	x21, x0
LFQH_Lloh98:
adr x0, LFQH_l_.str.39
LFQH_Lloh99:
nop
bl Lpatch + (0xa5a4 - PATCH_BASE)
mov	x1, x0
mov	x0, x21
bl Lpatch + (0xa5d4 - PATCH_BASE)
mov	x21, x0
LFQH_Lloh100:
adr x0, LFQH_l_.str.37
LFQH_Lloh101:
nop
bl Lpatch + (0xa5a4 - PATCH_BASE)
mov	x1, x0
mov	x0, x19
bl Lpatch + (0xa5d4 - PATCH_BASE)
cmp	x0, x21
b.eq	LFQH_LBB11_15
mov	x22, x0
LFQH_Lloh102:
adr x0, LFQH_l_.str.40
LFQH_Lloh103:
nop
bl Lpatch + (0xa5a4 - PATCH_BASE)
mov	x1, x0
mov	x0, x22
mov	x2, x21
bl Lpatch + (0xa5d4 - PATCH_BASE)
cbnz	w0, LFQH_LBB11_15
LFQH_Lloh104:
adr x1, LFQH_BackgroundKey
LFQH_Lloh105:
nop
mov	x0, x19
mov	x2, x22
mov	w3, #1
bl Lpatch + (0xa634 - PATCH_BASE)
LFQH_LBB11_15:
LFQH_Lloh106:
adr x0, LFQH_l_.str.41
LFQH_Lloh107:
nop
bl Lpatch + (0xa5b0 - PATCH_BASE)
mov	x22, x0
LFQH_Lloh108:
adr x0, LFQH_l_.str.42
LFQH_Lloh109:
nop
bl Lpatch + (0xa5a4 - PATCH_BASE)
mov	x1, x0
mov	x0, x22
bl Lpatch + (0xa5d4 - PATCH_BASE)
LFQH_Lloh110:
adr x0, LFQH_l_.str.43
LFQH_Lloh111:
nop
bl Lpatch + (0xa5a4 - PATCH_BASE)
mov	x1, x0
mov	x0, x22
mov	w2, #1
bl Lpatch + (0xa5d4 - PATCH_BASE)
mov	x0, x19
bl	LFQH_PrepareOwner
LFQH_Lloh112:
adr x0, LFQH_l_.str.44
LFQH_Lloh113:
nop
bl Lpatch + (0xa5a4 - PATCH_BASE)
mov	x1, x0
mov	x0, x20
mov.16b	v0, v8
mov.16b	v1, v9
mov.16b	v2, v10
mov.16b	v3, v11
bl Lpatch + (0xa5d4 - PATCH_BASE)
LFQH_Lloh114:
adr x23, LFQH_l_.str.45
LFQH_Lloh115:
nop
mov	x0, x23
bl Lpatch + (0xa5a4 - PATCH_BASE)
mov	x1, x0
mov	x0, x20
mov	x2, x21
bl Lpatch + (0xa5d4 - PATCH_BASE)
LFQH_Lloh116:
adr x0, LFQH_l_.str.46
LFQH_Lloh117:
nop
bl Lpatch + (0xa5a4 - PATCH_BASE)
mov	x1, x0
mov	x0, x20
bl Lpatch + (0xa5d4 - PATCH_BASE)
mov	x24, x0
mov	x0, x23
bl Lpatch + (0xa5a4 - PATCH_BASE)
mov	x1, x0
mov	x0, x24
mov	x2, x21
bl Lpatch + (0xa5d4 - PATCH_BASE)
mov	x0, x23
bl Lpatch + (0xa5a4 - PATCH_BASE)
mov	x1, x0
mov	x0, x19
mov	x2, x21
bl Lpatch + (0xa5d4 - PATCH_BASE)
LFQH_Lloh118:
adr x0, LFQH_l_.str.24
LFQH_Lloh119:
nop
bl Lpatch + (0xa5a4 - PATCH_BASE)
mov	x1, x0
mov	x0, x20
bl Lpatch + (0xa5d4 - PATCH_BASE)
cmp	x0, x19
b.eq	LFQH_LBB11_17
LFQH_Lloh120:
adr x0, LFQH_l_.str.47
LFQH_Lloh121:
nop
bl Lpatch + (0xa5a4 - PATCH_BASE)
mov	x1, x0
mov	x0, x19
mov	x2, x20
mov	x3, #0
bl Lpatch + (0xa5d4 - PATCH_BASE)
LFQH_LBB11_17:
LFQH_Lloh122:
adr x0, LFQH_l_.str.48
LFQH_Lloh123:
nop
bl Lpatch + (0xa5a4 - PATCH_BASE)
mov	x1, x0
mov	x0, x22
bl Lpatch + (0xa5d4 - PATCH_BASE)
b	LFQH_LBB11_24
LFQH_LBB11_18:
cbz	x20, LFQH_LBB11_23
LFQH_Lloh124:
adr x0, LFQH_l_.str.38
LFQH_Lloh125:
nop
bl Lpatch + (0xa5b0 - PATCH_BASE)
mov	x21, x0
LFQH_Lloh126:
adr x0, LFQH_l_.str.39
LFQH_Lloh127:
nop
bl Lpatch + (0xa5a4 - PATCH_BASE)
mov	x1, x0
mov	x0, x21
bl Lpatch + (0xa5d4 - PATCH_BASE)
mov	x21, x0
LFQH_Lloh128:
adr x0, LFQH_l_.str.37
LFQH_Lloh129:
nop
bl Lpatch + (0xa5a4 - PATCH_BASE)
mov	x1, x0
mov	x0, x19
bl Lpatch + (0xa5d4 - PATCH_BASE)
cmp	x0, x21
b.eq	LFQH_LBB11_21
mov	x22, x0
LFQH_Lloh130:
adr x0, LFQH_l_.str.40
LFQH_Lloh131:
nop
bl Lpatch + (0xa5a4 - PATCH_BASE)
mov	x1, x0
mov	x0, x22
mov	x2, x21
bl Lpatch + (0xa5d4 - PATCH_BASE)
cbz	w0, LFQH_LBB11_22
LFQH_LBB11_21:
LFQH_Lloh132:
adr x0, LFQH_l_.str.45
LFQH_Lloh133:
nop
bl Lpatch + (0xa5a4 - PATCH_BASE)
mov	x21, x0
LFQH_Lloh134:
adr x1, LFQH_BackgroundKey
LFQH_Lloh135:
nop
mov	x0, x19
bl Lpatch + (0xa628 - PATCH_BASE)
mov	x2, x0
mov	x0, x19
mov	x1, x21
bl Lpatch + (0xa5d4 - PATCH_BASE)
LFQH_LBB11_22:
LFQH_Lloh136:
adr x0, LFQH_l_.str.93
LFQH_Lloh137:
nop
bl Lpatch + (0xa5a4 - PATCH_BASE)
mov	x1, x0
mov	x0, x20
bl Lpatch + (0xa5d4 - PATCH_BASE)
LFQH_Lloh138:
adr x1, LFQH_SurfaceKey
LFQH_Lloh139:
nop
mov	x0, x19
mov	x2, #0
mov	w3, #1
bl Lpatch + (0xa634 - PATCH_BASE)
LFQH_Lloh140:
adr x1, LFQH_BackgroundKey
LFQH_Lloh141:
nop
mov	x0, x19
mov	x2, #0
mov	w3, #1
bl Lpatch + (0xa634 - PATCH_BASE)
LFQH_LBB11_23:
mov	x0, x19
bl	LFQH_RestoreOwner
LFQH_LBB11_24:
LFQH_Lloh142:
adr x1, LFQH_BusyKey
LFQH_Lloh143:
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
LFQH_LBB11_25:
LFQH_Lloh144:
adr x0, LFQH_l_.str.16
LFQH_Lloh145:
nop
bl Lpatch + (0xa5b0 - PATCH_BASE)
mov	x20, x0
LFQH_Lloh146:
adr x0, LFQH_l_.str.17
LFQH_Lloh147:
nop
bl Lpatch + (0xa5a4 - PATCH_BASE)
mov	x1, x0
mov	x0, x20
mov	x2, #0
bl Lpatch + (0xa5d4 - PATCH_BASE)
cbz	x0, LFQH_LBB11_24
mov	x20, x0
LFQH_Lloh148:
adr x0, LFQH_l_.str.22
LFQH_Lloh149:
nop
bl Lpatch + (0xa5a4 - PATCH_BASE)
mov	x1, x0
mov	x0, x20
mov	w2, #1
bl Lpatch + (0xa5d4 - PATCH_BASE)
LFQH_Lloh150:
adr x0, LFQH_l_.str.20
LFQH_Lloh151:
nop
bl Lpatch + (0xa5b0 - PATCH_BASE)
mov	x21, x0
LFQH_Lloh152:
adr x0, LFQH_l_.str.29
LFQH_Lloh153:
nop
bl Lpatch + (0xa5a4 - PATCH_BASE)
mov	x1, x0
mov	x0, x21
bl Lpatch + (0xa5d4 - PATCH_BASE)
mov	x21, x0
LFQH_Lloh154:
adr x0, LFQH_l_.str.30
LFQH_Lloh155:
nop
bl Lpatch + (0xa5a4 - PATCH_BASE)
mov	x1, x0
mov	x0, x21
mov	x2, x20
bl Lpatch + (0xa5d4 - PATCH_BASE)
cbz	x0, LFQH_LBB11_24
mov	x20, x0
LFQH_Lloh156:
adr x0, LFQH_l_.str.21
LFQH_Lloh157:
nop
bl Lpatch + (0xa5a4 - PATCH_BASE)
mov	x21, x0
LFQH_Lloh158:
adr x0, LFQH_l_.str.18
LFQH_Lloh159:
nop
bl Lpatch + (0xa5b0 - PATCH_BASE)
mov	x22, x0
LFQH_Lloh160:
adr x0, LFQH_l_.str.19
LFQH_Lloh161:
nop
bl Lpatch + (0xa5a4 - PATCH_BASE)
mov	x1, x0
mov	x0, x22
bl Lpatch + (0xa5d4 - PATCH_BASE)
mov	x2, x0
mov	x0, x20
mov	x1, x21
bl Lpatch + (0xa5d4 - PATCH_BASE)
LFQH_Lloh162:
adr x0, LFQH_l_.str.31
LFQH_Lloh163:
nop
bl Lpatch + (0xa5a4 - PATCH_BASE)
mov	x1, x0
mov	x0, x20
mov	w2, #0
bl Lpatch + (0xa5d4 - PATCH_BASE)
LFQH_Lloh164:
adr x0, LFQH_l_.str.32
LFQH_Lloh165:
nop
bl Lpatch + (0xa5a4 - PATCH_BASE)
mov	x1, x0
mov	x0, x20
mov	w2, #1
bl Lpatch + (0xa5d4 - PATCH_BASE)
LFQH_Lloh166:
adr x0, LFQH_l_.str.33
LFQH_Lloh167:
nop
bl Lpatch + (0xa5a4 - PATCH_BASE)
mov	x1, x0
mov	x0, x20
mov	w2, #0
bl Lpatch + (0xa5d4 - PATCH_BASE)
LFQH_Lloh168:
adr x0, LFQH_l_.str.34
LFQH_Lloh169:
nop
bl Lpatch + (0xa5a4 - PATCH_BASE)
mov	x1, x0
mov	x0, x20
mov	w2, #0
bl Lpatch + (0xa5d4 - PATCH_BASE)
LFQH_Lloh170:
adr x0, LFQH_l_.str.35
LFQH_Lloh171:
nop
bl Lpatch + (0xa5a4 - PATCH_BASE)
mov	x1, x0
mov	x0, x20
mov	w2, #18
bl Lpatch + (0xa5d4 - PATCH_BASE)
LFQH_Lloh172:
adr x1, LFQH_SurfaceKey
LFQH_Lloh173:
nop
mov	x0, x19
mov	x2, x20
mov	w3, #1
bl Lpatch + (0xa634 - PATCH_BASE)
LFQH_Lloh174:
adr x0, LFQH_l_.str.36
LFQH_Lloh175:
nop
bl Lpatch + (0xa5a4 - PATCH_BASE)
mov	x1, x0
mov	x0, x20
bl Lpatch + (0xa5d4 - PATCH_BASE)
LFQH_Lloh176:
adr x0, LFQH_l_.str.37
LFQH_Lloh177:
nop
bl Lpatch + (0xa5a4 - PATCH_BASE)
mov	x1, x0
mov	x0, x19
bl Lpatch + (0xa5d4 - PATCH_BASE)
mov	x2, x0
LFQH_Lloh178:
adr x1, LFQH_BackgroundKey
LFQH_Lloh179:
nop
mov	x0, x19
mov	w3, #1
bl Lpatch + (0xa634 - PATCH_BASE)
b	LFQH_LBB11_12
.cfi_endproc
.p2align	2
LFQH_BusyKey:
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
LFQH_Lloh180:
adr x0, LFQH_l_.str.89
LFQH_Lloh181:
nop
bl Lpatch + (0xa5b0 - PATCH_BASE)
mov	x19, x0
LFQH_Lloh182:
adr x0, LFQH_l_.str.90
LFQH_Lloh183:
nop
bl Lpatch + (0xa5a4 - PATCH_BASE)
mov	x1, x0
mov	x0, x19
bl Lpatch + (0xa5d4 - PATCH_BASE)
mov	x19, x0
LFQH_Lloh184:
adr x0, LFQH_l_.str.91
LFQH_Lloh185:
nop
bl Lpatch + (0xa5a4 - PATCH_BASE)
mov	x20, x0
LFQH_Lloh186:
adr x0, LFQH_l_.str.85
LFQH_Lloh187:
nop
bl Lpatch + (0xa5b0 - PATCH_BASE)
mov	x21, x0
LFQH_Lloh188:
adr x0, LFQH_l_.str.86
LFQH_Lloh189:
nop
bl Lpatch + (0xa5a4 - PATCH_BASE)
mov	x1, x0
LFQH_Lloh190:
adr x2, LFQH_l_.str.92
LFQH_Lloh191:
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
LFQH_BackgroundKey:
.cfi_startproc
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
LFQH_Lloh192:
adr x0, LFQH_l_.str.94
LFQH_Lloh193:
nop
bl Lpatch + (0xa5a4 - PATCH_BASE)
mov	x1, x0
mov	x0, x19
bl Lpatch + (0xa5d4 - PATCH_BASE)
mov	x21, x0
LFQH_Lloh194:
adr x0, LFQH_l_.str.97
LFQH_Lloh195:
nop
bl Lpatch + (0xa5a4 - PATCH_BASE)
mov	x1, x0
mov	x0, x19
bl Lpatch + (0xa5d4 - PATCH_BASE)
mov	x20, x0
LFQH_Lloh196:
adr x1, LFQH_ClipsKey
LFQH_Lloh197:
nop
mov	x0, x19
bl Lpatch + (0xa628 - PATCH_BASE)
cbz	x0, LFQH_LBB15_2
cbz	w21, LFQH_LBB15_3
LFQH_LBB15_2:
LFQH_Lloh198:
adr x0, LFQH_l_.str.98
LFQH_Lloh199:
nop
bl Lpatch + (0xa5b0 - PATCH_BASE)
mov	x22, x0
LFQH_Lloh200:
adr x0, LFQH_l_.str.99
LFQH_Lloh201:
nop
bl Lpatch + (0xa5a4 - PATCH_BASE)
mov	x1, x0
mov	x0, x22
mov	x2, x21
bl Lpatch + (0xa5d4 - PATCH_BASE)
mov	x2, x0
LFQH_Lloh202:
adr x1, LFQH_ClipsKey
LFQH_Lloh203:
nop
mov	x0, x19
mov	w3, #1
bl Lpatch + (0xa634 - PATCH_BASE)
LFQH_LBB15_3:
LFQH_Lloh204:
adr x1, LFQH_OpaqueKey
LFQH_Lloh205:
nop
mov	x0, x19
bl Lpatch + (0xa628 - PATCH_BASE)
cbz	x0, LFQH_LBB15_5
cbz	w20, LFQH_LBB15_6
LFQH_LBB15_5:
LFQH_Lloh206:
adr x0, LFQH_l_.str.98
LFQH_Lloh207:
nop
bl Lpatch + (0xa5b0 - PATCH_BASE)
mov	x22, x0
LFQH_Lloh208:
adr x0, LFQH_l_.str.99
LFQH_Lloh209:
nop
bl Lpatch + (0xa5a4 - PATCH_BASE)
mov	x1, x0
mov	x0, x22
mov	x2, x20
bl Lpatch + (0xa5d4 - PATCH_BASE)
mov	x2, x0
LFQH_Lloh210:
adr x1, LFQH_OpaqueKey
LFQH_Lloh211:
nop
mov	x0, x19
mov	w3, #1
bl Lpatch + (0xa634 - PATCH_BASE)
LFQH_LBB15_6:
cbz	w21, LFQH_LBB15_8
LFQH_Lloh212:
adr x0, LFQH_l_.str.95
LFQH_Lloh213:
nop
bl Lpatch + (0xa5a4 - PATCH_BASE)
mov	x1, x0
mov	x0, x19
mov	w2, #0
bl Lpatch + (0xa5d4 - PATCH_BASE)
LFQH_LBB15_8:
cbz	w20, LFQH_LBB15_10
LFQH_Lloh214:
adr x0, LFQH_l_.str.34
LFQH_Lloh215:
nop
bl Lpatch + (0xa5a4 - PATCH_BASE)
mov	x1, x0
mov	x0, x19
mov	w2, #0
ldp	x29, x30, [sp, #32]
ldp	x20, x19, [sp, #16]
ldp	x22, x21, [sp], #48
b Lpatch + (0xa5d4 - PATCH_BASE)
LFQH_LBB15_10:
ldp	x29, x30, [sp, #32]
ldp	x20, x19, [sp, #16]
ldp	x22, x21, [sp], #48
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
LFQH_Lloh216:
adr x0, LFQH_l_.str.49
LFQH_Lloh217:
nop
bl Lpatch + (0xa5b0 - PATCH_BASE)
LFQH_Lloh218:
adr x1, LFQH_l_.str.50
LFQH_Lloh219:
nop
ldp	x29, x30, [sp], #16
b	LFQH_Responds
.cfi_endproc
.p2align	2
LFQH_FQHIconGlass:
.cfi_startproc
LFQH_Lloh220:
adr x1, LFQH_IconGlassKey
LFQH_Lloh221:
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
LFQH_Lloh222:
adr x1, LFQH_l_.str.51
LFQH_Lloh223:
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
LFQH_Lloh224:
adr x1, LFQH_l_.str.27
LFQH_Lloh225:
nop
bl	LFQH_Kind
cbz	w0, LFQH_LBB20_2
LFQH_Lloh226:
adr x1, LFQH_BusyKey
LFQH_Lloh227:
nop
mov	x0, x19
bl Lpatch + (0xa628 - PATCH_BASE)
cbz	x0, LFQH_LBB20_3
LFQH_LBB20_2:
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
LFQH_LBB20_3:
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
adr x0, LFQH_l_.str.28
LFQH_Lloh233:
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
cbz	w0, LFQH_LBB20_45
LFQH_Lloh234:
adr x0, LFQH_l_.str.49
LFQH_Lloh235:
nop
bl Lpatch + (0xa5b0 - PATCH_BASE)
LFQH_Lloh236:
adr x1, LFQH_l_.str.50
LFQH_Lloh237:
nop
bl	LFQH_Responds
cbz	w0, LFQH_LBB20_45
fmov	x8, d12
and	x10, x8, #0x7fffffffffffffff
fmov	x8, d14
and	x8, x8, #0x7fffffffffffffff
mov	x11, #9218868437227405311
cmp	x8, x11
cset	w8, gt
fmov	x9, d13
and	x9, x9, #0x7fffffffffffffff
cmp	x9, x11
cset	w9, gt
cmp	x10, x11
b.gt	LFQH_LBB20_45
tbnz	w8, #0, LFQH_LBB20_45
tbnz	w9, #0, LFQH_LBB20_45
fmov	x8, d15
and	x8, x8, #0x7fffffffffffffff
mov	x9, #9218868437227405311
cmp	x8, x9
b.gt	LFQH_LBB20_45
fcmp	d13, #0.0
b.le	LFQH_LBB20_45
fcmp	d15, #0.0
b.le	LFQH_LBB20_45
LFQH_Lloh238:
adr x1, LFQH_l_.str.100
LFQH_Lloh239:
nop
mov	x0, x19
bl	LFQH_Kind
cbz	w0, LFQH_LBB20_17
LFQH_Lloh240:
adr x1, LFQH_l_.str.101
LFQH_Lloh241:
nop
mov	x0, x19
bl	LFQH_Get
mov	x22, x0
cbz	x0, LFQH_LBB20_18
mov	w24, #0
LFQH_Lloh242:
adr x23, LFQH_l_.str.24
LFQH_Lloh243:
nop
mov	x0, x22
mov	w26, #1
LFQH_LBB20_14:
cmp	x0, x19
b.eq	LFQH_LBB20_19
mov	x1, x23
bl	LFQH_Get
cbz	x0, LFQH_LBB20_21
cmp	w24, #7
add	w24, w24, #1
b.lo	LFQH_LBB20_14
b	LFQH_LBB20_21
LFQH_LBB20_17:
mov	w26, #0
mov	x22, #0
b	LFQH_LBB20_21
LFQH_LBB20_18:
mov	w26, #0
b	LFQH_LBB20_21
LFQH_LBB20_19:
LFQH_Lloh244:
adr x0, LFQH_l_.str.102
LFQH_Lloh245:
nop
bl Lpatch + (0xa5a4 - PATCH_BASE)
mov	x1, x0
mov	x0, x22
bl Lpatch + (0xa5d4 - PATCH_BASE)
cbz	w0, LFQH_LBB20_59
LFQH_LBB20_20:
mov	w26, #1
LFQH_LBB20_21:
mov.16b	v8, v12
mov.16b	v9, v14
mov.16b	v10, v13
mov.16b	v11, v15
LFQH_LBB20_22:
LFQH_Lloh246:
adr x24, LFQH_l_.str.85
LFQH_Lloh247:
nop
mov	x0, x24
bl Lpatch + (0xa5b0 - PATCH_BASE)
mov	x23, x0
LFQH_Lloh248:
adr x25, LFQH_l_.str.86
LFQH_Lloh249:
nop
mov	x0, x25
bl Lpatch + (0xa5a4 - PATCH_BASE)
mov	x1, x0
mov	x0, x23
mov	x2, x20
bl Lpatch + (0xa5d4 - PATCH_BASE)
LFQH_Lloh250:
adr x1, LFQH_l_.str.54
LFQH_Lloh251:
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
LFQH_Lloh252:
adr x1, LFQH_l_.str.64
LFQH_Lloh253:
nop
bl	LFQH_Equal
tbz	w0, #0, LFQH_LBB20_24
mov	w24, #1
b	LFQH_LBB20_25
LFQH_LBB20_24:
LFQH_Lloh254:
adr x0, LFQH_l_.str.85
LFQH_Lloh255:
nop
bl Lpatch + (0xa5b0 - PATCH_BASE)
mov	x24, x0
LFQH_Lloh256:
adr x0, LFQH_l_.str.86
LFQH_Lloh257:
nop
bl Lpatch + (0xa5a4 - PATCH_BASE)
mov	x1, x0
mov	x0, x24
mov	x2, x20
bl Lpatch + (0xa5d4 - PATCH_BASE)
LFQH_Lloh258:
adr x1, LFQH_l_.str.65
LFQH_Lloh259:
nop
bl	LFQH_Equal
mov	x24, x0
LFQH_LBB20_25:
orr	w8, w23, w24
and	w8, w26, w8
cmp	w8, #1
b.ne	LFQH_LBB20_43
LFQH_Lloh260:
adr x1, LFQH_GlyphViewKey
LFQH_Lloh261:
nop
mov	x0, x19
bl Lpatch + (0xa628 - PATCH_BASE)
cmp	x0, x22
b.eq	LFQH_LBB20_28
mov	x0, x19
bl	LFQH_RestoreGlyph
LFQH_LBB20_28:
stp	d11, d10, [sp, #32]
LFQH_Lloh262:
adr x0, LFQH_l_.str.114
LFQH_Lloh263:
nop
bl Lpatch + (0xa5a4 - PATCH_BASE)
mov	x1, x0
mov	x0, x22
bl Lpatch + (0xa5d4 - PATCH_BASE)
mov.16b	v10, v0
mov.16b	v11, v1
stp	d3, d2, [sp, #64]
LFQH_Lloh264:
adr x1, LFQH_GlyphOriginalKey
LFQH_Lloh265:
nop
mov	x0, x22
bl Lpatch + (0xa628 - PATCH_BASE)
mov	x25, x0
LFQH_Lloh266:
adr x1, LFQH_GlyphAppliedKey
LFQH_Lloh267:
nop
mov	x0, x22
bl Lpatch + (0xa628 - PATCH_BASE)
cbz	x25, LFQH_LBB20_34
mov	x26, x0
cbz	x0, LFQH_LBB20_34
LFQH_Lloh268:
adr x0, LFQH_l_.str.113
LFQH_Lloh269:
nop
bl Lpatch + (0xa5a4 - PATCH_BASE)
mov	x1, x0
mov	x0, x26
bl Lpatch + (0xa5d4 - PATCH_BASE)
fcmp	d10, d0
b.ne	LFQH_LBB20_34
fcmp	d11, d1
b.ne	LFQH_LBB20_34
ldr	d0, [sp, #72]
fcmp	d0, d2
b.ne	LFQH_LBB20_34
ldr	d0, [sp, #64]
fcmp	d0, d3
b.eq	LFQH_LBB20_35
LFQH_LBB20_34:
mov.16b	v0, v10
mov.16b	v1, v11
ldp	d3, d2, [sp, #64]
bl	LFQH_RectBox
mov	x25, x0
LFQH_Lloh270:
adr x1, LFQH_GlyphOriginalKey
LFQH_Lloh271:
nop
mov	x0, x22
mov	x2, x25
mov	w3, #1
bl Lpatch + (0xa634 - PATCH_BASE)
LFQH_LBB20_35:
stp	d11, d10, [sp, #16]
stp	d9, d8, [sp, #48]
LFQH_Lloh272:
adr x0, LFQH_l_.str.113
LFQH_Lloh273:
nop
bl Lpatch + (0xa5a4 - PATCH_BASE)
mov	x1, x0
mov	x0, x25
bl Lpatch + (0xa5d4 - PATCH_BASE)
mov.16b	v11, v1
mov.16b	v10, v2
cbz	w23, LFQH_LBB20_37
fmov	d1, #0.50000000
fmul	d1, d10, d1
fadd	d8, d0, d1
mov.16b	v9, v3
b	LFQH_LBB20_40
LFQH_LBB20_37:
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
LFQH_Lloh274:
adr x1, LFQH_l_.str.64
LFQH_Lloh275:
nop
bl	LFQH_Equal
fmov	d0, #-12.00000000
fadd	d0, d8, d0
cmp	w0, #0
fcsel	d8, d8, d0, eq
mov	x0, x20
bl	LFQH_Text
LFQH_Lloh276:
adr x1, LFQH_l_.str.65
LFQH_Lloh277:
nop
bl	LFQH_Equal
cbz	w0, LFQH_LBB20_39
fmov	d0, #-0.25000000
fmul	d0, d10, d0
fadd	d8, d8, d0
LFQH_LBB20_39:
ldr	d10, [sp, #8]
LFQH_LBB20_40:
ldp	d0, d1, [sp, #16]
fcmp	d1, d8
fccmp	d0, d11, #0, eq
ldp	d0, d1, [sp, #64]
fccmp	d1, d10, #0, eq
fccmp	d0, d9, #0, eq
b.eq	LFQH_LBB20_42
LFQH_Lloh278:
adr x0, LFQH_l_.str.44
LFQH_Lloh279:
nop
bl Lpatch + (0xa5a4 - PATCH_BASE)
mov	x1, x0
mov	x0, x22
mov.16b	v0, v8
mov.16b	v1, v11
mov.16b	v2, v10
mov.16b	v3, v9
bl Lpatch + (0xa5d4 - PATCH_BASE)
LFQH_LBB20_42:
LFQH_Lloh280:
adr x0, LFQH_l_.str.115
LFQH_Lloh281:
nop
bl Lpatch + (0xa5b0 - PATCH_BASE)
mov	x25, x0
LFQH_Lloh282:
adr x0, LFQH_l_.str.116
LFQH_Lloh283:
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
LFQH_Lloh284:
adr x1, LFQH_GlyphAppliedKey
LFQH_Lloh285:
nop
mov	x0, x22
mov	w3, #1
bl Lpatch + (0xa634 - PATCH_BASE)
LFQH_Lloh286:
adr x1, LFQH_GlyphViewKey
LFQH_Lloh287:
nop
mov	x0, x19
mov	x2, x22
mov	w3, #1
bl Lpatch + (0xa634 - PATCH_BASE)
ldp	d9, d8, [sp, #48]
ldp	d11, d10, [sp, #32]
LFQH_LBB20_43:
LFQH_Lloh288:
adr x0, LFQH_l_.str.85
LFQH_Lloh289:
nop
bl Lpatch + (0xa5b0 - PATCH_BASE)
mov	x22, x0
LFQH_Lloh290:
adr x0, LFQH_l_.str.86
LFQH_Lloh291:
nop
bl Lpatch + (0xa5a4 - PATCH_BASE)
mov	x1, x0
mov	x0, x22
mov	x2, x20
bl Lpatch + (0xa5d4 - PATCH_BASE)
LFQH_Lloh292:
adr x1, LFQH_l_.str.64
LFQH_Lloh293:
nop
bl	LFQH_Equal
mov	x22, x0
mov	x0, x19
bl	LFQH_CanExpandHit
tbz	w0, #0, LFQH_LBB20_45
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
and	x9, x9, #0x7fffffffffffffff
and	x8, x8, #0x7fffffffffffffff
mov	x10, #9218868437227405311
cmp	x8, x10
cset	w8, gt
cmp	x9, x10
ccmp	w8, #0, #0, le
b.eq	LFQH_LBB20_47
LFQH_LBB20_45:
mov	x0, x19
mov	x1, x21
bl	LFQH_RestoreIcon
LFQH_LBB20_46:
LFQH_Lloh294:
adr x1, LFQH_BusyKey
LFQH_Lloh295:
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
LFQH_LBB20_47:
cbz	x21, LFQH_LBB20_56
LFQH_LBB20_48:
LFQH_Lloh296:
adr x0, LFQH_l_.str.41
LFQH_Lloh297:
nop
bl Lpatch + (0xa5b0 - PATCH_BASE)
mov	x22, x0
LFQH_Lloh298:
adr x0, LFQH_l_.str.42
LFQH_Lloh299:
nop
bl Lpatch + (0xa5a4 - PATCH_BASE)
mov	x1, x0
mov	x0, x22
bl Lpatch + (0xa5d4 - PATCH_BASE)
LFQH_Lloh300:
adr x0, LFQH_l_.str.43
LFQH_Lloh301:
nop
bl Lpatch + (0xa5a4 - PATCH_BASE)
mov	x1, x0
mov	x0, x22
mov	w2, #1
bl Lpatch + (0xa5d4 - PATCH_BASE)
mov	x0, x19
bl	LFQH_PrepareOwner
LFQH_Lloh302:
adr x1, LFQH_IconRectKey
LFQH_Lloh303:
nop
mov	x0, x19
bl Lpatch + (0xa628 - PATCH_BASE)
cbz	x0, LFQH_LBB20_50
mov	x23, x0
LFQH_Lloh304:
adr x0, LFQH_l_.str.113
LFQH_Lloh305:
nop
bl Lpatch + (0xa5a4 - PATCH_BASE)
mov	x1, x0
mov	x0, x23
bl Lpatch + (0xa5d4 - PATCH_BASE)
fcmp	d0, d12
fccmp	d1, d15, #0, eq
fccmp	d2, d14, #0, eq
fccmp	d3, d14, #0, eq
b.eq	LFQH_LBB20_51
LFQH_LBB20_50:
LFQH_Lloh306:
adr x0, LFQH_l_.str.44
LFQH_Lloh307:
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
LFQH_Lloh308:
adr x1, LFQH_IconRectKey
LFQH_Lloh309:
nop
mov	x0, x19
mov	w3, #1
bl Lpatch + (0xa634 - PATCH_BASE)
LFQH_LBB20_51:
LFQH_Lloh310:
adr x0, LFQH_l_.str.24
LFQH_Lloh311:
nop
bl Lpatch + (0xa5a4 - PATCH_BASE)
mov	x1, x0
mov	x0, x21
bl Lpatch + (0xa5d4 - PATCH_BASE)
cmp	x0, x19
b.eq	LFQH_LBB20_53
LFQH_Lloh312:
adr x0, LFQH_l_.str.47
LFQH_Lloh313:
nop
bl Lpatch + (0xa5a4 - PATCH_BASE)
mov	x1, x0
mov	x0, x19
mov	x2, x21
mov	x3, #0
bl Lpatch + (0xa5d4 - PATCH_BASE)
LFQH_LBB20_53:
LFQH_Lloh314:
adr x1, LFQH_l_.str.105
LFQH_Lloh315:
nop
mov	x0, x19
bl	LFQH_Kind
cbz	w0, LFQH_LBB20_55
LFQH_Lloh316:
adr x0, LFQH_l_.str.106
LFQH_Lloh317:
nop
bl Lpatch + (0xa5a4 - PATCH_BASE)
mov	x23, x0
LFQH_Lloh318:
adr x0, LFQH_l_.str.107
LFQH_Lloh319:
nop
bl Lpatch + (0xa5a4 - PATCH_BASE)
mov	x1, x0
mov	x0, x19
bl Lpatch + (0xa5d4 - PATCH_BASE)
mov	x2, x0
mov	x0, x21
mov	x1, x23
bl Lpatch + (0xa5d4 - PATCH_BASE)
LFQH_Lloh320:
adr x0, LFQH_l_.str.108
LFQH_Lloh321:
nop
bl Lpatch + (0xa5a4 - PATCH_BASE)
mov	x23, x0
LFQH_Lloh322:
adr x0, LFQH_l_.str.109
LFQH_Lloh323:
nop
bl Lpatch + (0xa5a4 - PATCH_BASE)
mov	x1, x0
mov	x0, x19
bl Lpatch + (0xa5d4 - PATCH_BASE)
mov	x2, x0
mov	x0, x21
mov	x1, x23
bl Lpatch + (0xa5d4 - PATCH_BASE)
LFQH_Lloh324:
adr x0, LFQH_l_.str.110
LFQH_Lloh325:
nop
bl Lpatch + (0xa5a4 - PATCH_BASE)
mov	x23, x0
LFQH_Lloh326:
adr x0, LFQH_l_.str.111
LFQH_Lloh327:
nop
bl Lpatch + (0xa5a4 - PATCH_BASE)
mov	x1, x0
mov	x0, x19
bl Lpatch + (0xa5d4 - PATCH_BASE)
mov	x2, x0
mov	x0, x21
mov	x1, x23
bl Lpatch + (0xa5d4 - PATCH_BASE)
LFQH_LBB20_55:
mov	x0, x19
mov.16b	v0, v12
mov.16b	v1, v15
mov.16b	v2, v14
mov.16b	v3, v14
bl	LFQH_EnsureHit
LFQH_Lloh328:
adr x0, LFQH_l_.str.48
LFQH_Lloh329:
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
b	LFQH_LBB20_46
LFQH_LBB20_56:
LFQH_Lloh330:
adr x0, LFQH_l_.str.49
LFQH_Lloh331:
nop
bl Lpatch + (0xa5b0 - PATCH_BASE)
mov	x21, x0
LFQH_Lloh332:
adr x0, LFQH_l_.str.50
LFQH_Lloh333:
nop
bl Lpatch + (0xa5a4 - PATCH_BASE)
mov	x1, x0
mov	x0, x21
bl Lpatch + (0xa5d4 - PATCH_BASE)
cbz	x0, LFQH_LBB20_46
mov	x22, x0
bl	LFQH_GlassClass
mov	x21, x0
LFQH_Lloh334:
adr x0, LFQH_l_.str.103
LFQH_Lloh335:
nop
bl Lpatch + (0xa5a4 - PATCH_BASE)
mov	x1, x0
mov	x0, x21
bl Lpatch + (0xa5d4 - PATCH_BASE)
cbz	x0, LFQH_LBB20_46
mov	x21, x0
LFQH_Lloh336:
adr x0, LFQH_l_.str.104
LFQH_Lloh337:
nop
bl Lpatch + (0xa5a4 - PATCH_BASE)
mov	x1, x0
mov	x0, x21
mov	x2, x22
bl Lpatch + (0xa5d4 - PATCH_BASE)
LFQH_Lloh338:
adr x0, LFQH_l_.str.31
LFQH_Lloh339:
nop
bl Lpatch + (0xa5a4 - PATCH_BASE)
mov	x1, x0
mov	x0, x21
mov	w2, #0
bl Lpatch + (0xa5d4 - PATCH_BASE)
LFQH_Lloh340:
adr x0, LFQH_l_.str.32
LFQH_Lloh341:
nop
bl Lpatch + (0xa5a4 - PATCH_BASE)
mov	x1, x0
mov	x0, x21
mov	w2, #1
bl Lpatch + (0xa5d4 - PATCH_BASE)
LFQH_Lloh342:
adr x0, LFQH_l_.str.33
LFQH_Lloh343:
nop
bl Lpatch + (0xa5a4 - PATCH_BASE)
mov	x1, x0
mov	x0, x21
mov	w2, #0
bl Lpatch + (0xa5d4 - PATCH_BASE)
LFQH_Lloh344:
adr x0, LFQH_l_.str.34
LFQH_Lloh345:
nop
bl Lpatch + (0xa5a4 - PATCH_BASE)
mov	x1, x0
mov	x0, x21
mov	w2, #0
bl Lpatch + (0xa5d4 - PATCH_BASE)
LFQH_Lloh346:
adr x0, LFQH_l_.str.35
LFQH_Lloh347:
nop
bl Lpatch + (0xa5a4 - PATCH_BASE)
mov	x1, x0
mov	x0, x21
mov	x2, #0
bl Lpatch + (0xa5d4 - PATCH_BASE)
LFQH_Lloh348:
adr x1, LFQH_IconGlassKey
LFQH_Lloh349:
nop
mov	x0, x19
mov	x2, x21
mov	w3, #1
bl Lpatch + (0xa634 - PATCH_BASE)
LFQH_Lloh350:
adr x0, LFQH_l_.str.36
LFQH_Lloh351:
nop
bl Lpatch + (0xa5a4 - PATCH_BASE)
mov	x1, x0
mov	x0, x21
bl Lpatch + (0xa5d4 - PATCH_BASE)
mov	x0, x19
mov	x1, x21
mov	w2, #1
bl	LFQH_ObservePress
b	LFQH_LBB20_48
LFQH_LBB20_59:
LFQH_Lloh352:
adr x0, LFQH_l_.str.28
LFQH_Lloh353:
nop
bl Lpatch + (0xa5a4 - PATCH_BASE)
mov	x1, x0
mov	x0, x22
bl Lpatch + (0xa5d4 - PATCH_BASE)
bl	LFQH_VisibleRect
cbz	w0, LFQH_LBB20_20
LFQH_Lloh354:
adr x0, LFQH_l_.str.28
LFQH_Lloh355:
nop
bl Lpatch + (0xa5a4 - PATCH_BASE)
mov	x1, x0
mov	x0, x22
bl Lpatch + (0xa5d4 - PATCH_BASE)
mov.16b	v8, v0
mov.16b	v9, v1
mov.16b	v10, v2
mov.16b	v11, v3
LFQH_Lloh356:
adr x0, LFQH_l_.str.112
LFQH_Lloh357:
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
cbz	w0, LFQH_LBB20_20
mov	w26, #1
b	LFQH_LBB20_22
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
LFQH_Lloh358:
adr x1, LFQH_ReaderGlassKey
LFQH_Lloh359:
nop
bl Lpatch + (0xa628 - PATCH_BASE)
mov	x19, x0
LFQH_Lloh360:
adr x0, LFQH_l_.str.52
LFQH_Lloh361:
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
LFQH_Lloh362:
adr x1, LFQH_OwnerBusyKey
LFQH_Lloh363:
nop
bl Lpatch + (0xa628 - PATCH_BASE)
cbnz	x0, LFQH_LBB23_31
LFQH_Lloh364:
adr x1, LFQH_OwnerBusyKey
LFQH_Lloh365:
nop
mov	x0, x19
mov	x2, x19
mov	x3, #0
bl Lpatch + (0xa634 - PATCH_BASE)
LFQH_Lloh366:
adr x0, LFQH_l_.str.28
LFQH_Lloh367:
nop
bl Lpatch + (0xa5a4 - PATCH_BASE)
mov	x1, x0
mov	x0, x19
bl Lpatch + (0xa5d4 - PATCH_BASE)
stp	d0, d1, [sp]
stp	d2, d3, [sp, #16]
LFQH_Lloh368:
adr x1, LFQH_l_.str.53
LFQH_Lloh369:
nop
mov	x0, x19
bl	LFQH_Get
cbz	x0, LFQH_LBB23_6
mov	x21, x0
mov	w23, #0
LFQH_Lloh370:
adr x22, LFQH_l_.str.24
LFQH_Lloh371:
nop
LFQH_LBB23_3:
cmp	x0, x19
b.eq	LFQH_LBB23_7
mov	x1, x22
bl	LFQH_Get
mov	x20, #0
cbz	x0, LFQH_LBB23_8
cmp	w23, #7
add	w23, w23, #1
b.lo	LFQH_LBB23_3
b	LFQH_LBB23_8
LFQH_LBB23_6:
mov	x20, #0
b	LFQH_LBB23_8
LFQH_LBB23_7:
LFQH_Lloh372:
adr x1, LFQH_l_.str.54
LFQH_Lloh373:
nop
mov	x0, x21
bl	LFQH_Icon
mov	x2, sp
mov	x0, x21
mov	x1, x19
bl	LFQH_IncludeGlass
LFQH_Lloh374:
adr x1, LFQH_IconGlassKey
LFQH_Lloh375:
nop
mov	x0, x21
bl Lpatch + (0xa628 - PATCH_BASE)
cmp	x0, #0
cset	w20, ne
LFQH_LBB23_8:
LFQH_Lloh376:
adr x1, LFQH_l_.str.55
LFQH_Lloh377:
nop
mov	x0, x19
bl	LFQH_Get
mov	x21, x0
LFQH_Lloh378:
adr x1, LFQH_l_.str.56
LFQH_Lloh379:
nop
bl	LFQH_Kind
cbz	w0, LFQH_LBB23_22
LFQH_Lloh380:
adr x0, LFQH_l_.str.57
LFQH_Lloh381:
nop
bl Lpatch + (0xa5a4 - PATCH_BASE)
mov	x1, x0
mov	x0, x21
bl Lpatch + (0xa5d4 - PATCH_BASE)
cmp	x0, #16
mov	w8, #16
csel	x23, x0, x8, lo
cbz	x0, LFQH_LBB23_22
mov	x22, #0
LFQH_Lloh382:
adr x28, LFQH_l_.str.58
LFQH_Lloh383:
nop
LFQH_Lloh384:
adr x26, LFQH_l_.str.24
LFQH_Lloh385:
nop
LFQH_LBB23_11:
LFQH_Lloh386:
adr x0, LFQH_l_.str.144
LFQH_Lloh387:
nop
bl Lpatch + (0xa5a4 - PATCH_BASE)
mov	x1, x0
mov	x0, x21
mov	x2, x22
bl Lpatch + (0xa5d4 - PATCH_BASE)
mov	x25, x0
LFQH_Lloh388:
adr x1, LFQH_l_.str.145
LFQH_Lloh389:
nop
bl	LFQH_Kind
LFQH_Lloh390:
adr x27, LFQH_l_.str.146
LFQH_Lloh391:
nop
tbnz	w0, #0, LFQH_LBB23_15
mov	x0, x25
LFQH_Lloh392:
adr x1, LFQH_l_.str.147
LFQH_Lloh393:
nop
bl	LFQH_Kind
LFQH_Lloh394:
adr x27, LFQH_l_.str.148
LFQH_Lloh395:
nop
tbnz	w0, #0, LFQH_LBB23_15
mov	x0, x25
LFQH_Lloh396:
adr x1, LFQH_l_.str.149
LFQH_Lloh397:
nop
bl	LFQH_Kind
LFQH_Lloh398:
adr x27, LFQH_l_.str.150
LFQH_Lloh399:
nop
tbnz	w0, #0, LFQH_LBB23_15
mov	x0, x25
LFQH_Lloh400:
adr x1, LFQH_l_.str.151
LFQH_Lloh401:
nop
bl	LFQH_Kind
LFQH_Lloh402:
adr x27, LFQH_l_.str.152
LFQH_Lloh403:
nop
cbz	w0, LFQH_LBB23_21
LFQH_LBB23_15:
mov	x0, x25
mov	x1, x28
bl	LFQH_Get
cbz	x0, LFQH_LBB23_21
mov	x25, x0
mov	w24, #0
LFQH_LBB23_17:
cmp	x0, x19
b.eq	LFQH_LBB23_20
mov	x1, x26
bl	LFQH_Get
cbz	x0, LFQH_LBB23_21
cmp	w24, #7
add	w24, w24, #1
b.lo	LFQH_LBB23_17
b	LFQH_LBB23_21
LFQH_LBB23_20:
mov	x0, x25
mov	x1, x27
bl	LFQH_Icon
mov	x2, sp
mov	x0, x25
mov	x1, x19
bl	LFQH_IncludeGlass
mov	x0, x25
LFQH_Lloh404:
adr x1, LFQH_IconGlassKey
LFQH_Lloh405:
nop
bl Lpatch + (0xa628 - PATCH_BASE)
cmp	x0, #0
cinc	x20, x20, ne
LFQH_LBB23_21:
add	x22, x22, #1
cmp	x22, x23
b.ne	LFQH_LBB23_11
LFQH_LBB23_22:
cbz	x20, LFQH_LBB23_24
ldp	d0, d1, [sp]
ldp	d2, d3, [sp, #16]
mov	x0, x19
bl	LFQH_EnsureHit
b	LFQH_LBB23_25
LFQH_LBB23_24:
mov	x0, x19
bl	LFQH_RestoreHit
LFQH_LBB23_25:
LFQH_Lloh406:
adr x1, LFQH_ReaderGlassKey
LFQH_Lloh407:
nop
mov	x0, x19
bl Lpatch + (0xa628 - PATCH_BASE)
mov	x21, x0
LFQH_Lloh408:
adr x0, LFQH_l_.str.52
LFQH_Lloh409:
nop
bl Lpatch + (0xa5a4 - PATCH_BASE)
mov	x1, x0
mov	x0, x21
bl Lpatch + (0xa5d4 - PATCH_BASE)
cmp	x20, x0
b.eq	LFQH_LBB23_30
cbz	x20, LFQH_LBB23_28
LFQH_Lloh410:
adr x0, LFQH_l_.str.98
LFQH_Lloh411:
nop
bl Lpatch + (0xa5b0 - PATCH_BASE)
mov	x21, x0
LFQH_Lloh412:
adr x0, LFQH_l_.str.153
LFQH_Lloh413:
nop
bl Lpatch + (0xa5a4 - PATCH_BASE)
mov	x1, x0
mov	x0, x21
mov	x2, x20
bl Lpatch + (0xa5d4 - PATCH_BASE)
mov	x2, x0
b	LFQH_LBB23_29
LFQH_LBB23_28:
mov	x2, #0
LFQH_LBB23_29:
LFQH_Lloh414:
adr x1, LFQH_ReaderGlassKey
LFQH_Lloh415:
nop
mov	x0, x19
mov	w3, #1
bl Lpatch + (0xa634 - PATCH_BASE)
LFQH_LBB23_30:
LFQH_Lloh416:
adr x1, LFQH_OwnerBusyKey
LFQH_Lloh417:
nop
mov	x0, x19
mov	x2, #0
mov	x3, #0
bl Lpatch + (0xa634 - PATCH_BASE)
LFQH_LBB23_31:
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
LFQH_Lloh418:
adr x1, LFQH_IconGlassKey
LFQH_Lloh419:
nop
bl Lpatch + (0xa628 - PATCH_BASE)
cbz	x21, LFQH_LBB25_17
mov	x22, x0
cbz	x0, LFQH_LBB25_17
mov	w24, #0
LFQH_Lloh420:
adr x23, LFQH_l_.str.24
LFQH_Lloh421:
nop
mov	x0, x21
LFQH_LBB25_3:
cmp	x0, x20
b.eq	LFQH_LBB25_6
mov	x1, x23
bl	LFQH_Get
cbz	x0, LFQH_LBB25_17
cmp	w24, #7
add	w24, w24, #1
b.lo	LFQH_LBB25_3
b	LFQH_LBB25_17
LFQH_LBB25_6:
LFQH_Lloh422:
adr x0, LFQH_l_.str.114
LFQH_Lloh423:
nop
bl Lpatch + (0xa5a4 - PATCH_BASE)
mov	x1, x0
mov	x0, x22
bl Lpatch + (0xa5d4 - PATCH_BASE)
mov.16b	v8, v0
mov.16b	v9, v1
mov.16b	v10, v2
mov.16b	v11, v3
LFQH_Lloh424:
adr x0, LFQH_l_.str.112
LFQH_Lloh425:
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
b.gt	LFQH_LBB25_17
tbnz	w8, #0, LFQH_LBB25_17
tbnz	w9, #0, LFQH_LBB25_17
fmov	x8, d3
and	x8, x8, #0x7fffffffffffffff
mov	x9, #9218868437227405311
cmp	x8, x9
b.gt	LFQH_LBB25_17
fcmp	d2, #0.0
b.le	LFQH_LBB25_17
fcmp	d3, #0.0
b.le	LFQH_LBB25_17
ldp	d6, d4, [x19]
ldp	d7, d16, [x19, #16]
fcmp	d0, d6
mov.16b	v5, v6
b.pl	LFQH_LBB25_14
str	d0, [x19]
mov.16b	v5, v0
LFQH_LBB25_14:
fadd	d7, d6, d7
fadd	d6, d4, d16
fcmp	d1, d4
b.pl	LFQH_LBB25_16
str	d1, [x19, #8]
mov.16b	v4, v1
LFQH_LBB25_16:
fadd	d0, d0, d2
fcmp	d0, d7
fcsel	d0, d0, d7, gt
fadd	d1, d1, d3
fcmp	d1, d6
fcsel	d1, d1, d6, gt
fsub	d0, d0, d5
fsub	d1, d1, d4
stp	d0, d1, [x19, #16]
LFQH_LBB25_17:
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
mov.16b	v9, v3
str	d2, [sp, #24]
mov.16b	v11, v1
mov.16b	v10, v0
mov	x19, x0
bl	LFQH_CanExpandHit
cbz	w0, LFQH_LBB26_26
LFQH_Lloh426:
adr x0, LFQH_l_.str.28
LFQH_Lloh427:
nop
bl Lpatch + (0xa5a4 - PATCH_BASE)
mov	x1, x0
mov	x0, x19
bl Lpatch + (0xa5d4 - PATCH_BASE)
mov.16b	v14, v0
mov.16b	v13, v1
mov.16b	v15, v2
mov.16b	v12, v3
fmov	x20, d15
fmov	x21, d13
fmov	x22, d14
LFQH_Lloh428:
adr x0, LFQH_l_.str.117
LFQH_Lloh429:
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
b.gt	LFQH_LBB26_26
tbnz	w8, #0, LFQH_LBB26_26
tbnz	w9, #0, LFQH_LBB26_26
fmov	x8, d12
and	x8, x8, #0x7fffffffffffffff
mov	x9, #9218868437227405311
cmp	x8, x9
b.gt	LFQH_LBB26_26
fcmp	d15, #0.0
b.le	LFQH_LBB26_26
fcmp	d12, #0.0
b.le	LFQH_LBB26_26
mov.16b	v8, v0
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
b.gt	LFQH_LBB26_26
tbnz	w8, #0, LFQH_LBB26_26
tbnz	w9, #0, LFQH_LBB26_26
tbnz	w10, #0, LFQH_LBB26_26
stp	d2, d1, [sp, #8]
str	d3, [sp]
LFQH_Lloh430:
adr x1, LFQH_HitInsetsKey
LFQH_Lloh431:
nop
mov	x0, x19
bl Lpatch + (0xa628 - PATCH_BASE)
mov	x21, x0
LFQH_Lloh432:
adr x1, LFQH_AppliedHitInsetsKey
LFQH_Lloh433:
nop
mov	x0, x19
bl Lpatch + (0xa628 - PATCH_BASE)
mov	x20, x0
cbz	x21, LFQH_LBB26_17
cbz	x20, LFQH_LBB26_17
LFQH_Lloh434:
adr x0, LFQH_l_.str.113
LFQH_Lloh435:
nop
bl Lpatch + (0xa5a4 - PATCH_BASE)
mov	x1, x0
mov	x0, x20
bl Lpatch + (0xa5d4 - PATCH_BASE)
fcmp	d8, d0
b.ne	LFQH_LBB26_17
ldr	d0, [sp, #16]
fcmp	d0, d1
b.ne	LFQH_LBB26_17
ldr	d0, [sp, #8]
fcmp	d0, d2
b.ne	LFQH_LBB26_17
ldr	d0, [sp]
fcmp	d0, d3
b.eq	LFQH_LBB26_18
LFQH_LBB26_17:
LFQH_Lloh436:
adr x0, LFQH_l_.str.115
LFQH_Lloh437:
nop
bl Lpatch + (0xa5b0 - PATCH_BASE)
mov	x21, x0
LFQH_Lloh438:
adr x0, LFQH_l_.str.116
LFQH_Lloh439:
nop
bl Lpatch + (0xa5a4 - PATCH_BASE)
mov	x1, x0
mov	x0, x21
mov.16b	v0, v8
ldp	d2, d1, [sp, #8]
ldr	d3, [sp]
bl Lpatch + (0xa5d4 - PATCH_BASE)
mov	x21, x0
LFQH_Lloh440:
adr x1, LFQH_HitInsetsKey
LFQH_Lloh441:
nop
mov	x0, x19
mov	x2, x21
mov	w3, #1
bl Lpatch + (0xa634 - PATCH_BASE)
LFQH_LBB26_18:
LFQH_Lloh442:
adr x0, LFQH_l_.str.113
LFQH_Lloh443:
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
b.ne	LFQH_LBB26_21
ldr	d0, [sp, #16]
fcmp	d0, d10
b.ne	LFQH_LBB26_21
ldp	d0, d1, [sp]
fcmp	d1, d11
fccmp	d0, d12, #0, eq
b.eq	LFQH_LBB26_22
LFQH_LBB26_21:
LFQH_Lloh444:
adr x0, LFQH_l_.str.118
LFQH_Lloh445:
nop
bl Lpatch + (0xa5a4 - PATCH_BASE)
mov	x1, x0
mov	x0, x19
mov.16b	v0, v9
mov.16b	v1, v10
mov.16b	v2, v11
mov.16b	v3, v12
bl Lpatch + (0xa5d4 - PATCH_BASE)
LFQH_LBB26_22:
cbz	x20, LFQH_LBB26_27
LFQH_Lloh446:
adr x0, LFQH_l_.str.113
LFQH_Lloh447:
nop
bl Lpatch + (0xa5a4 - PATCH_BASE)
mov	x1, x0
mov	x0, x20
bl Lpatch + (0xa5d4 - PATCH_BASE)
fcmp	d9, d0
b.ne	LFQH_LBB26_27
fcmp	d10, d1
b.ne	LFQH_LBB26_27
fcmp	d11, d2
fccmp	d12, d3, #0, eq
b.ne	LFQH_LBB26_27
LFQH_LBB26_26:
ldp	x29, x30, [sp, #128]
ldp	x20, x19, [sp, #112]
ldp	x22, x21, [sp, #96]
ldp	d9, d8, [sp, #80]
ldp	d11, d10, [sp, #64]
ldp	d13, d12, [sp, #48]
ldp	d15, d14, [sp, #32]
add	sp, sp, #144
ret
LFQH_LBB26_27:
LFQH_Lloh448:
adr x0, LFQH_l_.str.115
LFQH_Lloh449:
nop
bl Lpatch + (0xa5b0 - PATCH_BASE)
mov	x20, x0
LFQH_Lloh450:
adr x0, LFQH_l_.str.116
LFQH_Lloh451:
nop
bl Lpatch + (0xa5a4 - PATCH_BASE)
mov	x1, x0
mov	x0, x20
mov.16b	v0, v9
mov.16b	v1, v10
mov.16b	v2, v11
mov.16b	v3, v12
bl Lpatch + (0xa5d4 - PATCH_BASE)
mov	x2, x0
LFQH_Lloh452:
adr x1, LFQH_AppliedHitInsetsKey
LFQH_Lloh453:
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
LFQH_Lloh454:
adr x1, LFQH_HitInsetsKey
LFQH_Lloh455:
nop
bl Lpatch + (0xa628 - PATCH_BASE)
mov	x20, x0
LFQH_Lloh456:
adr x1, LFQH_AppliedHitInsetsKey
LFQH_Lloh457:
nop
mov	x0, x19
bl Lpatch + (0xa628 - PATCH_BASE)
cmp	x20, #0
ccmp	x0, #0, #4, ne
b.eq	LFQH_LBB27_3
mov	x21, x0
LFQH_Lloh458:
adr x0, LFQH_l_.str.117
LFQH_Lloh459:
nop
bl Lpatch + (0xa5a4 - PATCH_BASE)
mov	x1, x0
mov	x0, x19
bl Lpatch + (0xa5d4 - PATCH_BASE)
mov.16b	v8, v0
mov.16b	v9, v1
mov.16b	v10, v2
mov.16b	v11, v3
LFQH_Lloh460:
adr x0, LFQH_l_.str.113
LFQH_Lloh461:
nop
bl Lpatch + (0xa5a4 - PATCH_BASE)
mov	x1, x0
mov	x0, x21
bl Lpatch + (0xa5d4 - PATCH_BASE)
fcmp	d8, d0
fccmp	d9, d1, #0, eq
fccmp	d10, d2, #0, eq
fccmp	d11, d3, #0, eq
b.ne	LFQH_LBB27_3
LFQH_Lloh462:
adr x0, LFQH_l_.str.113
LFQH_Lloh463:
nop
bl Lpatch + (0xa5a4 - PATCH_BASE)
mov	x1, x0
mov	x0, x20
bl Lpatch + (0xa5d4 - PATCH_BASE)
mov.16b	v8, v0
mov.16b	v9, v1
mov.16b	v10, v2
mov.16b	v11, v3
LFQH_Lloh464:
adr x0, LFQH_l_.str.118
LFQH_Lloh465:
nop
bl Lpatch + (0xa5a4 - PATCH_BASE)
mov	x1, x0
mov	x0, x19
mov.16b	v0, v8
mov.16b	v1, v9
mov.16b	v2, v10
mov.16b	v3, v11
bl Lpatch + (0xa5d4 - PATCH_BASE)
LFQH_LBB27_3:
LFQH_Lloh466:
adr x1, LFQH_HitInsetsKey
LFQH_Lloh467:
nop
mov	x0, x19
mov	x2, #0
mov	w3, #1
bl Lpatch + (0xa634 - PATCH_BASE)
LFQH_Lloh468:
adr x1, LFQH_AppliedHitInsetsKey
LFQH_Lloh469:
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
LFQH_Lloh470:
adr x1, LFQH_OwnerBusyKey
LFQH_Lloh471:
nop
bl Lpatch + (0xa628 - PATCH_BASE)
cbz	x0, LFQH_LBB28_2
ldp	x29, x30, [sp, #96]
ldp	x20, x19, [sp, #80]
ldp	x22, x21, [sp, #64]
ldp	x24, x23, [sp, #48]
ldp	x26, x25, [sp, #32]
add	sp, sp, #112
ret
LFQH_LBB28_2:
LFQH_Lloh472:
adr x1, LFQH_OwnerBusyKey
LFQH_Lloh473:
nop
mov	x0, x19
mov	x2, x19
mov	x3, #0
bl Lpatch + (0xa634 - PATCH_BASE)
LFQH_Lloh474:
adr x1, LFQH_l_.str.59
LFQH_Lloh475:
nop
mov	x0, x19
bl	LFQH_Get
mov	x22, x0
LFQH_Lloh476:
adr x1, LFQH_l_.str.60
LFQH_Lloh477:
nop
mov	x0, x19
bl	LFQH_Get
mov	x21, x0
LFQH_Lloh478:
adr x1, LFQH_l_.str.61
LFQH_Lloh479:
nop
mov	x0, x19
bl	LFQH_Get
mov	x20, x0
LFQH_Lloh480:
adr x23, LFQH_l_.str.85
LFQH_Lloh481:
nop
mov	x0, x23
bl Lpatch + (0xa5b0 - PATCH_BASE)
mov	x24, x0
LFQH_Lloh482:
adr x25, LFQH_l_.str.86
LFQH_Lloh483:
nop
mov	x0, x25
bl Lpatch + (0xa5a4 - PATCH_BASE)
mov	x1, x0
LFQH_Lloh484:
adr x2, LFQH_l_.str.62
LFQH_Lloh485:
nop
mov	x0, x24
bl Lpatch + (0xa5d4 - PATCH_BASE)
mov	x2, x0
LFQH_Lloh486:
adr x24, LFQH_ShelfRoleKey
LFQH_Lloh487:
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
LFQH_Lloh488:
adr x2, LFQH_l_.str.63
LFQH_Lloh489:
nop
mov	x0, x23
bl Lpatch + (0xa5d4 - PATCH_BASE)
mov	x2, x0
mov	x0, x21
mov	x1, x24
mov	w3, #1
bl Lpatch + (0xa634 - PATCH_BASE)
LFQH_Lloh490:
adr x1, LFQH_l_.str.64
LFQH_Lloh491:
nop
mov	x0, x22
bl	LFQH_Icon
LFQH_Lloh492:
adr x1, LFQH_l_.str.65
LFQH_Lloh493:
nop
mov	x0, x21
bl	LFQH_Icon
LFQH_Lloh494:
adr x1, LFQH_l_.str.27
LFQH_Lloh495:
nop
mov	x0, x20
bl	LFQH_Kind
cbz	w0, LFQH_LBB28_6
LFQH_Lloh496:
adr x0, LFQH_l_.str.28
LFQH_Lloh497:
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
LFQH_Lloh498:
adr x1, LFQH_IconGlassKey
LFQH_Lloh499:
nop
mov	x0, x22
bl Lpatch + (0xa628 - PATCH_BASE)
cbnz	x0, LFQH_LBB28_5
LFQH_Lloh500:
adr x1, LFQH_IconGlassKey
LFQH_Lloh501:
nop
mov	x0, x21
bl Lpatch + (0xa628 - PATCH_BASE)
cbz	x0, LFQH_LBB28_7
LFQH_LBB28_5:
ldp	d0, d1, [sp]
ldp	d2, d3, [sp, #16]
mov	x0, x20
bl	LFQH_EnsureHit
LFQH_LBB28_6:
LFQH_Lloh502:
adr x1, LFQH_OwnerBusyKey
LFQH_Lloh503:
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
LFQH_LBB28_7:
mov	x0, x20
bl	LFQH_RestoreHit
b	LFQH_LBB28_6
.cfi_endproc
.p2align	2
LFQH_ShelfRoleKey:
.cfi_startproc
ret
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
cbz	w0, LFQH_LBB30_2
LFQH_Lloh504:
adr x20, LFQH_l_.str.7
LFQH_Lloh505:
nop
LFQH_Lloh506:
adr x1, LFQH_l_.str.8
LFQH_Lloh507:
nop
LFQH_Lloh508:
adr x2, LFQH_l_.str.66
LFQH_Lloh509:
nop
LFQH_Lloh510:
adr x19, LFQH_l_.str.9
LFQH_Lloh511:
nop
LFQH_Lloh512:
adr x4, LFQH_HomeLayout
LFQH_Lloh513:
nop
mov	x0, x20
mov	x3, x19
bl	LFQH_Hook
LFQH_Lloh514:
adr x1, LFQH_l_.str.67
LFQH_Lloh515:
nop
LFQH_Lloh516:
adr x2, LFQH_l_.str.68
LFQH_Lloh517:
nop
LFQH_Lloh518:
adr x3, LFQH_l_.str.69
LFQH_Lloh519:
nop
LFQH_Lloh520:
adr x4, LFQH_HomeAppear
LFQH_Lloh521:
nop
mov	x0, x20
bl	LFQH_Hook
LFQH_Lloh522:
adr x21, LFQH_l_.str.12
LFQH_Lloh523:
nop
LFQH_Lloh524:
adr x20, LFQH_l_.str.13
LFQH_Lloh525:
nop
LFQH_Lloh526:
adr x2, LFQH_l_.str.70
LFQH_Lloh527:
nop
LFQH_Lloh528:
adr x4, LFQH_CategoryLayout
LFQH_Lloh529:
nop
mov	x0, x21
mov	x1, x20
mov	x3, x19
bl	LFQH_Hook
LFQH_Lloh530:
adr x1, LFQH_l_.str.14
LFQH_Lloh531:
nop
LFQH_Lloh532:
adr x2, LFQH_l_.str.71
LFQH_Lloh533:
nop
LFQH_Lloh534:
adr x22, LFQH_l_.str.15
LFQH_Lloh535:
nop
LFQH_Lloh536:
adr x4, LFQH_CategoryColor
LFQH_Lloh537:
nop
mov	x0, x21
mov	x3, x22
bl	LFQH_Hook
LFQH_Lloh538:
adr x0, LFQH_l_.str.72
LFQH_Lloh539:
nop
LFQH_Lloh540:
adr x1, LFQH_l_.str.73
LFQH_Lloh541:
nop
LFQH_Lloh542:
adr x2, LFQH_l_.str.74
LFQH_Lloh543:
nop
LFQH_Lloh544:
adr x4, LFQH_SearchColor
LFQH_Lloh545:
nop
mov	x3, x22
bl	LFQH_Hook
LFQH_Lloh546:
adr x0, LFQH_l_.str.75
LFQH_Lloh547:
nop
LFQH_Lloh548:
adr x2, LFQH_l_.str.76
LFQH_Lloh549:
nop
LFQH_Lloh550:
adr x4, LFQH_ShelfButtonLayout
LFQH_Lloh551:
nop
mov	x1, x20
mov	x3, x19
bl	LFQH_Hook
LFQH_Lloh552:
adr x0, LFQH_l_.str.77
LFQH_Lloh553:
nop
LFQH_Lloh554:
adr x1, LFQH_l_.str.78
LFQH_Lloh555:
nop
LFQH_Lloh556:
adr x2, LFQH_l_.str.79
LFQH_Lloh557:
nop
LFQH_Lloh558:
adr x4, LFQH_ShelfLayout
LFQH_Lloh559:
nop
mov	x3, x19
bl	LFQH_Hook
LFQH_Lloh560:
adr x21, LFQH_l_.str.80
LFQH_Lloh561:
nop
LFQH_Lloh562:
adr x2, LFQH_l_.str.81
LFQH_Lloh563:
nop
LFQH_Lloh564:
adr x4, LFQH_ReaderLayout
LFQH_Lloh565:
nop
mov	x0, x21
mov	x1, x20
mov	x3, x19
bl	LFQH_Hook
LFQH_Lloh566:
adr x1, LFQH_l_.str.82
LFQH_Lloh567:
nop
LFQH_Lloh568:
adr x2, LFQH_l_.str.83
LFQH_Lloh569:
nop
LFQH_Lloh570:
adr x3, LFQH_l_.str.84
LFQH_Lloh571:
nop
LFQH_Lloh572:
adr x4, LFQH_ReaderTheme
LFQH_Lloh573:
nop
mov	x0, x21
ldp	x29, x30, [sp, #32]
ldp	x20, x19, [sp, #16]
ldp	x22, x21, [sp], #48
b	LFQH_Hook
LFQH_LBB30_2:
ldp	x29, x30, [sp, #32]
ldp	x20, x19, [sp, #16]
ldp	x22, x21, [sp], #48
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
cbz	x0, LFQH_LBB31_2
mov	x21, x0
mov	x0, x22
bl Lpatch + (0xa5a4 - PATCH_BASE)
mov	x1, x0
mov	x0, x21
bl Lpatch + (0xa5f8 - PATCH_BASE)
cbz	x0, LFQH_LBB31_3
LFQH_LBB31_2:
ldp	x29, x30, [sp, #48]
ldp	x20, x19, [sp, #32]
ldp	x22, x21, [sp, #16]
ldp	x24, x23, [sp], #64
ret
LFQH_LBB31_3:
mov	x0, x23
bl Lpatch + (0xa5a4 - PATCH_BASE)
mov	x1, x0
mov	x0, x21
mov	w2, #0
mov	x3, x20
bl LHookOwned
cbz	x0, LFQH_LBB31_2
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
cbz	w0, LFQH_LBB31_2
mov	x0, x23
mov	x1, x19
ldp	x29, x30, [sp, #48]
ldp	x20, x19, [sp, #32]
ldp	x22, x21, [sp, #16]
ldp	x24, x23, [sp], #64
b Lpatch + (0xa580 - PATCH_BASE)
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
LFQH_Lloh574:
adr x0, LFQH_l_.str.7
LFQH_Lloh575:
nop
LFQH_Lloh576:
adr x1, LFQH_l_.str.66
LFQH_Lloh577:
nop
bl	LFQH_Original
mov	x8, x0
mov	x0, x20
mov	x1, x19
blr	x8
LFQH_Lloh578:
adr x1, LFQH_l_.str.10
LFQH_Lloh579:
nop
mov	x0, x20
bl	LFQH_Get
ldp	x29, x30, [sp, #16]
ldp	x20, x19, [sp], #32
b	LFQH_FQHApply
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
LFQH_Lloh580:
adr x0, LFQH_l_.str.7
LFQH_Lloh581:
nop
LFQH_Lloh582:
adr x1, LFQH_l_.str.68
LFQH_Lloh583:
nop
bl	LFQH_Original
mov	x8, x0
mov	x0, x21
mov	x1, x20
mov	x2, x19
blr	x8
LFQH_Lloh584:
adr x1, LFQH_l_.str.10
LFQH_Lloh585:
nop
mov	x0, x21
bl	LFQH_Get
ldp	x29, x30, [sp, #32]
ldp	x20, x19, [sp, #16]
ldp	x22, x21, [sp], #48
b	LFQH_FQHApply
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
LFQH_Lloh586:
adr x0, LFQH_l_.str.12
LFQH_Lloh587:
nop
LFQH_Lloh588:
adr x1, LFQH_l_.str.70
LFQH_Lloh589:
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
LFQH_Lloh590:
adr x0, LFQH_l_.str.12
LFQH_Lloh591:
nop
LFQH_Lloh592:
adr x1, LFQH_l_.str.71
LFQH_Lloh593:
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
b	LFQH_FQHApply
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
LFQH_Lloh594:
adr x0, LFQH_l_.str.72
LFQH_Lloh595:
nop
LFQH_Lloh596:
adr x1, LFQH_l_.str.74
LFQH_Lloh597:
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
LFQH_Lloh598:
adr x1, LFQH_l_.str.154
LFQH_Lloh599:
nop
mov	x0, x24
bl	LFQH_Get
LFQH_Lloh600:
adr x1, LFQH_l_.str.10
LFQH_Lloh601:
nop
bl	LFQH_Get
ldp	x29, x30, [sp, #64]
ldp	x20, x19, [sp, #48]
ldp	x22, x21, [sp, #32]
ldp	x24, x23, [sp, #16]
ldp	d9, d8, [sp], #80
b	LFQH_FQHApply
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
LFQH_Lloh602:
adr x0, LFQH_l_.str.75
LFQH_Lloh603:
nop
LFQH_Lloh604:
adr x1, LFQH_l_.str.76
LFQH_Lloh605:
nop
bl	LFQH_Original
mov	x8, x0
mov	x0, x19
mov	x1, x20
blr	x8
LFQH_Lloh606:
adr x1, LFQH_ShelfRoleKey
LFQH_Lloh607:
nop
mov	x0, x19
bl Lpatch + (0xa628 - PATCH_BASE)
cbz	x0, LFQH_LBB37_2
LFQH_Lloh608:
adr x1, LFQH_l_.str.62
LFQH_Lloh609:
nop
bl	LFQH_Equal
LFQH_Lloh610:
adr x8, LFQH_l_.str.64
LFQH_Lloh611:
nop
LFQH_Lloh612:
adr x9, LFQH_l_.str.65
LFQH_Lloh613:
nop
cmp	w0, #0
csel	x1, x9, x8, eq
mov	x0, x19
ldp	x29, x30, [sp, #16]
ldp	x20, x19, [sp], #32
b	LFQH_Icon
LFQH_LBB37_2:
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
LFQH_Lloh614:
adr x0, LFQH_l_.str.77
LFQH_Lloh615:
nop
LFQH_Lloh616:
adr x1, LFQH_l_.str.79
LFQH_Lloh617:
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
LFQH_Lloh618:
adr x0, LFQH_l_.str.80
LFQH_Lloh619:
nop
LFQH_Lloh620:
adr x1, LFQH_l_.str.81
LFQH_Lloh621:
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
LFQH_Lloh622:
adr x0, LFQH_l_.str.80
LFQH_Lloh623:
nop
LFQH_Lloh624:
adr x1, LFQH_l_.str.83
LFQH_Lloh625:
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
LFQH_Lloh626:
adr x1, LFQH_ClipsKey
LFQH_Lloh627:
nop
bl Lpatch + (0xa628 - PATCH_BASE)
mov	x21, x0
LFQH_Lloh628:
adr x1, LFQH_OpaqueKey
LFQH_Lloh629:
nop
mov	x0, x19
bl Lpatch + (0xa628 - PATCH_BASE)
mov	x20, x0
cbz	x21, LFQH_LBB41_3
LFQH_Lloh630:
adr x0, LFQH_l_.str.94
LFQH_Lloh631:
nop
bl Lpatch + (0xa5a4 - PATCH_BASE)
mov	x1, x0
mov	x0, x19
bl Lpatch + (0xa5d4 - PATCH_BASE)
cbnz	w0, LFQH_LBB41_3
LFQH_Lloh632:
adr x0, LFQH_l_.str.95
LFQH_Lloh633:
nop
bl Lpatch + (0xa5a4 - PATCH_BASE)
mov	x22, x0
LFQH_Lloh634:
adr x0, LFQH_l_.str.96
LFQH_Lloh635:
nop
bl Lpatch + (0xa5a4 - PATCH_BASE)
mov	x1, x0
mov	x0, x21
bl Lpatch + (0xa5d4 - PATCH_BASE)
mov	x2, x0
mov	x0, x19
mov	x1, x22
bl Lpatch + (0xa5d4 - PATCH_BASE)
LFQH_LBB41_3:
cbz	x20, LFQH_LBB41_6
LFQH_Lloh636:
adr x0, LFQH_l_.str.97
LFQH_Lloh637:
nop
bl Lpatch + (0xa5a4 - PATCH_BASE)
mov	x1, x0
mov	x0, x19
bl Lpatch + (0xa5d4 - PATCH_BASE)
cbnz	w0, LFQH_LBB41_6
LFQH_Lloh638:
adr x0, LFQH_l_.str.34
LFQH_Lloh639:
nop
bl Lpatch + (0xa5a4 - PATCH_BASE)
mov	x21, x0
LFQH_Lloh640:
adr x0, LFQH_l_.str.96
LFQH_Lloh641:
nop
bl Lpatch + (0xa5a4 - PATCH_BASE)
mov	x1, x0
mov	x0, x20
bl Lpatch + (0xa5d4 - PATCH_BASE)
mov	x2, x0
mov	x0, x19
mov	x1, x21
bl Lpatch + (0xa5d4 - PATCH_BASE)
LFQH_LBB41_6:
LFQH_Lloh642:
adr x1, LFQH_ClipsKey
LFQH_Lloh643:
nop
mov	x0, x19
mov	x2, #0
mov	w3, #1
bl Lpatch + (0xa634 - PATCH_BASE)
LFQH_Lloh644:
adr x1, LFQH_OpaqueKey
LFQH_Lloh645:
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
b.gt	LFQH_LBB44_3
tbnz	w9, #0, LFQH_LBB44_3
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
LFQH_LBB44_3:
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
cbz	x20, LFQH_LBB45_2
mov	x0, x19
mov	x1, x20
mov	w2, #0
bl	LFQH_ObservePress
LFQH_Lloh646:
adr x0, LFQH_l_.str.93
LFQH_Lloh647:
nop
bl Lpatch + (0xa5a4 - PATCH_BASE)
mov	x1, x0
mov	x0, x20
bl Lpatch + (0xa5d4 - PATCH_BASE)
LFQH_LBB45_2:
LFQH_Lloh648:
adr x1, LFQH_IconGlassKey
LFQH_Lloh649:
nop
mov	x0, x19
mov	x2, #0
mov	w3, #1
bl Lpatch + (0xa634 - PATCH_BASE)
LFQH_Lloh650:
adr x1, LFQH_IconRectKey
LFQH_Lloh651:
nop
mov	x0, x19
mov	x2, #0
mov	w3, #1
bl Lpatch + (0xa634 - PATCH_BASE)
LFQH_Lloh652:
adr x1, LFQH_LayoutKey
LFQH_Lloh653:
nop
mov	x0, x19
mov	x2, #0
mov	w3, #1
bl Lpatch + (0xa634 - PATCH_BASE)
LFQH_Lloh654:
adr x1, LFQH_LayoutTimeKey
LFQH_Lloh655:
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
LFQH_Lloh656:
adr x1, LFQH_GlyphViewKey
LFQH_Lloh657:
nop
bl Lpatch + (0xa628 - PATCH_BASE)
mov	x20, x0
LFQH_Lloh658:
adr x1, LFQH_GlyphOriginalKey
LFQH_Lloh659:
nop
bl Lpatch + (0xa628 - PATCH_BASE)
cbz	x0, LFQH_LBB47_2
mov	x21, x0
LFQH_Lloh660:
adr x0, LFQH_l_.str.113
LFQH_Lloh661:
nop
bl Lpatch + (0xa5a4 - PATCH_BASE)
mov	x1, x0
mov	x0, x21
bl Lpatch + (0xa5d4 - PATCH_BASE)
mov.16b	v8, v0
mov.16b	v9, v1
mov.16b	v10, v2
mov.16b	v11, v3
LFQH_Lloh662:
adr x0, LFQH_l_.str.44
LFQH_Lloh663:
nop
bl Lpatch + (0xa5a4 - PATCH_BASE)
mov	x1, x0
mov	x0, x20
mov.16b	v0, v8
mov.16b	v1, v9
mov.16b	v2, v10
mov.16b	v3, v11
bl Lpatch + (0xa5d4 - PATCH_BASE)
LFQH_LBB47_2:
LFQH_Lloh664:
adr x1, LFQH_GlyphOriginalKey
LFQH_Lloh665:
nop
mov	x0, x20
mov	x2, #0
mov	w3, #1
bl Lpatch + (0xa634 - PATCH_BASE)
LFQH_Lloh666:
adr x1, LFQH_GlyphAppliedKey
LFQH_Lloh667:
nop
mov	x0, x20
mov	x2, #0
mov	w3, #1
bl Lpatch + (0xa634 - PATCH_BASE)
LFQH_Lloh668:
adr x1, LFQH_GlyphViewKey
LFQH_Lloh669:
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
LFQH_Lloh670:
adr x0, LFQH_l_.str.115
LFQH_Lloh671:
nop
bl Lpatch + (0xa5b0 - PATCH_BASE)
mov	x19, x0
LFQH_Lloh672:
adr x0, LFQH_l_.str.116
LFQH_Lloh673:
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
LFQH_Lloh674:
adr x1, LFQH_l_.str.117
LFQH_Lloh675:
nop
bl	LFQH_Responds
cbz	w0, LFQH_LBB51_2
LFQH_Lloh676:
adr x1, LFQH_l_.str.118
LFQH_Lloh677:
nop
mov	x0, x19
bl	LFQH_Responds
LFQH_LBB51_2:
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
LFQH_Lloh678:
adr x0, LFQH_l_.str.119
LFQH_Lloh679:
nop
bl Lpatch + (0xa5b0 - PATCH_BASE)
mov	x19, x0
cbnz	x0, LFQH_LBB52_3
LFQH_Lloh680:
adr x0, LFQH_l_.str.100
LFQH_Lloh681:
nop
bl Lpatch + (0xa5b0 - PATCH_BASE)
LFQH_Lloh682:
adr x1, LFQH_l_.str.119
LFQH_Lloh683:
nop
mov	x2, #0
bl Lpatch + (0xa61c - PATCH_BASE)
mov	x19, x0
cbz	x0, LFQH_LBB52_3
LFQH_Lloh684:
adr x0, LFQH_l_.str.120
LFQH_Lloh685:
nop
bl Lpatch + (0xa5a4 - PATCH_BASE)
mov	x1, x0
LFQH_Lloh686:
adr x2, LFQH_Press
LFQH_Lloh687:
nop
LFQH_Lloh688:
adr x20, LFQH_l_.str.84
LFQH_Lloh689:
nop
mov	x0, x19
mov	x3, x20
bl Lpatch + (0xa58c - PATCH_BASE)
LFQH_Lloh690:
adr x0, LFQH_l_.str.121
LFQH_Lloh691:
nop
bl Lpatch + (0xa5a4 - PATCH_BASE)
mov	x1, x0
LFQH_Lloh692:
adr x2, LFQH_ReleasePress
LFQH_Lloh693:
nop
mov	x0, x19
mov	x3, x20
bl Lpatch + (0xa58c - PATCH_BASE)
mov	x0, x19
bl Lpatch + (0xa610 - PATCH_BASE)
LFQH_LBB52_3:
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
LFQH_Lloh694:
adr x1, LFQH_l_.str.105
LFQH_Lloh695:
nop
bl	LFQH_Kind
cbz	w0, LFQH_LBB53_2
LFQH_Lloh696:
adr x8, LFQH_l_.str.122
LFQH_Lloh697:
nop
LFQH_Lloh698:
adr x9, LFQH_l_.str.123
LFQH_Lloh699:
nop
cmp	w21, #0
csel	x0, x9, x8, eq
bl Lpatch + (0xa5a4 - PATCH_BASE)
mov	x21, x0
LFQH_Lloh700:
adr x0, LFQH_l_.str.120
LFQH_Lloh701:
nop
bl Lpatch + (0xa5a4 - PATCH_BASE)
mov	x3, x0
mov	x0, x20
mov	x1, x21
mov	x2, x19
mov	w4, #17
bl Lpatch + (0xa5d4 - PATCH_BASE)
LFQH_Lloh702:
adr x0, LFQH_l_.str.121
LFQH_Lloh703:
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
LFQH_LBB53_2:
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
LFQH_Lloh704:
adr x22, LFQH_l_.str.114
LFQH_Lloh705:
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
LFQH_Lloh706:
adr x0, LFQH_l_.str.28
LFQH_Lloh707:
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
LFQH_Lloh708:
adr x1, LFQH_l_.str.124
LFQH_Lloh709:
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
cbz	x0, LFQH_LBB55_2
mov	x21, x0
LFQH_Lloh710:
adr x0, LFQH_l_.str.112
LFQH_Lloh711:
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
LFQH_LBB55_2:
stp	d3, d2, [sp, #40]
str	d12, [sp, #56]
LFQH_Lloh712:
adr x1, LFQH_LayoutKey
LFQH_Lloh713:
nop
mov	x0, x20
bl Lpatch + (0xa628 - PATCH_BASE)
cbz	x0, LFQH_LBB55_23
mov	x21, x0
LFQH_Lloh714:
adr x0, LFQH_l_.str.144
LFQH_Lloh715:
nop
bl Lpatch + (0xa5a4 - PATCH_BASE)
mov	x1, x0
mov	x0, x21
mov	x2, #0
bl Lpatch + (0xa5d4 - PATCH_BASE)
mov	x22, x0
LFQH_Lloh716:
adr x0, LFQH_l_.str.113
LFQH_Lloh717:
nop
bl Lpatch + (0xa5a4 - PATCH_BASE)
mov	x1, x0
mov	x0, x22
bl Lpatch + (0xa5d4 - PATCH_BASE)
ldr	d4, [sp, #80]
fcmp	d4, d0
b.ne	LFQH_LBB55_23
ldr	d0, [sp, #144]
fcmp	d0, d1
b.ne	LFQH_LBB55_23
ldr	d0, [sp, #136]
fcmp	d0, d2
b.ne	LFQH_LBB55_23
fcmp	d11, d3
b.ne	LFQH_LBB55_23
LFQH_Lloh718:
adr x0, LFQH_l_.str.144
LFQH_Lloh719:
nop
bl Lpatch + (0xa5a4 - PATCH_BASE)
mov	x1, x0
mov	x0, x21
mov	w2, #1
bl Lpatch + (0xa5d4 - PATCH_BASE)
mov	x22, x0
LFQH_Lloh720:
adr x0, LFQH_l_.str.113
LFQH_Lloh721:
nop
bl Lpatch + (0xa5a4 - PATCH_BASE)
mov	x1, x0
mov	x0, x22
bl Lpatch + (0xa5d4 - PATCH_BASE)
fcmp	d8, d0
b.ne	LFQH_LBB55_23
fcmp	d9, d1
b.ne	LFQH_LBB55_23
fcmp	d13, d2
b.ne	LFQH_LBB55_23
fcmp	d10, d3
b.ne	LFQH_LBB55_23
LFQH_Lloh722:
adr x0, LFQH_l_.str.144
LFQH_Lloh723:
nop
bl Lpatch + (0xa5a4 - PATCH_BASE)
mov	x1, x0
mov	x0, x21
mov	w2, #2
bl Lpatch + (0xa5d4 - PATCH_BASE)
mov	x22, x0
LFQH_Lloh724:
adr x0, LFQH_l_.str.113
LFQH_Lloh725:
nop
bl Lpatch + (0xa5a4 - PATCH_BASE)
mov	x1, x0
mov	x0, x22
bl Lpatch + (0xa5d4 - PATCH_BASE)
ldr	d4, [sp, #128]
fcmp	d4, d0
b.ne	LFQH_LBB55_23
ldr	d0, [sp, #120]
fcmp	d0, d1
b.ne	LFQH_LBB55_23
ldr	d0, [sp, #112]
fcmp	d0, d2
b.ne	LFQH_LBB55_23
ldr	d0, [sp, #72]
fcmp	d0, d3
b.ne	LFQH_LBB55_23
LFQH_Lloh726:
adr x0, LFQH_l_.str.144
LFQH_Lloh727:
nop
bl Lpatch + (0xa5a4 - PATCH_BASE)
mov	x1, x0
mov	x0, x21
mov	w2, #3
bl Lpatch + (0xa5d4 - PATCH_BASE)
mov	x22, x0
LFQH_Lloh728:
adr x0, LFQH_l_.str.113
LFQH_Lloh729:
nop
bl Lpatch + (0xa5a4 - PATCH_BASE)
mov	x1, x0
mov	x0, x22
bl Lpatch + (0xa5d4 - PATCH_BASE)
ldr	d4, [sp, #64]
fcmp	d4, d0
b.ne	LFQH_LBB55_23
ldr	d0, [sp, #104]
fcmp	d0, d1
b.ne	LFQH_LBB55_23
ldr	d0, [sp, #96]
fcmp	d0, d2
b.ne	LFQH_LBB55_23
ldr	d0, [sp, #88]
fcmp	d0, d3
b.ne	LFQH_LBB55_23
LFQH_Lloh730:
adr x0, LFQH_l_.str.144
LFQH_Lloh731:
nop
bl Lpatch + (0xa5a4 - PATCH_BASE)
mov	x1, x0
mov	x0, x21
mov	w2, #4
bl Lpatch + (0xa5d4 - PATCH_BASE)
mov	x21, x0
LFQH_Lloh732:
adr x0, LFQH_l_.str.113
LFQH_Lloh733:
nop
bl Lpatch + (0xa5a4 - PATCH_BASE)
mov	x1, x0
mov	x0, x21
bl Lpatch + (0xa5d4 - PATCH_BASE)
ldr	d4, [sp, #56]
fcmp	d4, d0
b.ne	LFQH_LBB55_23
fcmp	d15, d1
b.ne	LFQH_LBB55_23
ldr	d0, [sp, #48]
fcmp	d0, d2
b.ne	LFQH_LBB55_23
ldr	d0, [sp, #40]
fcmp	d0, d3
b.eq	LFQH_LBB55_26
LFQH_LBB55_23:
LFQH_Lloh734:
adr x0, LFQH_l_.str.125
LFQH_Lloh735:
nop
bl Lpatch + (0xa5b0 - PATCH_BASE)
mov	x21, x0
LFQH_Lloh736:
adr x0, LFQH_l_.str.126
LFQH_Lloh737:
nop
bl Lpatch + (0xa5a4 - PATCH_BASE)
mov	x1, x0
mov	x0, x21
bl Lpatch + (0xa5d4 - PATCH_BASE)
mov	x21, x0
LFQH_Lloh738:
adr x0, LFQH_l_.str.127
LFQH_Lloh739:
nop
bl Lpatch + (0xa5a4 - PATCH_BASE)
mov	x1, x0
mov	x0, x21
bl Lpatch + (0xa5d4 - PATCH_BASE)
mov.16b	v12, v0
LFQH_Lloh740:
adr x1, LFQH_LayoutTimeKey
LFQH_Lloh741:
nop
mov	x0, x20
bl Lpatch + (0xa628 - PATCH_BASE)
cbz	x0, LFQH_LBB55_25
mov	x21, x0
LFQH_Lloh742:
adr x0, LFQH_l_.str.128
LFQH_Lloh743:
nop
bl Lpatch + (0xa5a4 - PATCH_BASE)
mov	x1, x0
mov	x0, x21
bl Lpatch + (0xa5d4 - PATCH_BASE)
fsub	d0, d12, d0
fmov	d1, #1.00000000
fcmp	d0, d1
b.mi	LFQH_LBB55_26
LFQH_LBB55_25:
LFQH_Lloh744:
adr x21, LFQH_l_.str.115
LFQH_Lloh745:
nop
mov	x0, x21
bl Lpatch + (0xa5b0 - PATCH_BASE)
mov	x23, x0
LFQH_Lloh746:
adr x22, LFQH_l_.str.116
LFQH_Lloh747:
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
LFQH_Lloh748:
adr x0, LFQH_l_.str.56
LFQH_Lloh749:
nop
bl Lpatch + (0xa5b0 - PATCH_BASE)
mov	x21, x0
LFQH_Lloh750:
adr x0, LFQH_l_.str.129
LFQH_Lloh751:
nop
bl Lpatch + (0xa5a4 - PATCH_BASE)
mov	x1, x0
add	x2, sp, #152
mov	x0, x21
mov	w3, #5
bl Lpatch + (0xa5d4 - PATCH_BASE)
mov	x2, x0
LFQH_Lloh752:
adr x1, LFQH_LayoutKey
LFQH_Lloh753:
nop
mov	x0, x20
mov	w3, #1
bl Lpatch + (0xa634 - PATCH_BASE)
LFQH_Lloh754:
adr x0, LFQH_l_.str.98
LFQH_Lloh755:
nop
bl Lpatch + (0xa5b0 - PATCH_BASE)
mov	x21, x0
LFQH_Lloh756:
adr x0, LFQH_l_.str.139
LFQH_Lloh757:
nop
bl Lpatch + (0xa5a4 - PATCH_BASE)
mov	x1, x0
mov	x0, x21
mov.16b	v0, v12
bl Lpatch + (0xa5d4 - PATCH_BASE)
mov	x2, x0
LFQH_Lloh758:
adr x1, LFQH_LayoutTimeKey
LFQH_Lloh759:
nop
mov	x0, x20
mov	w3, #1
bl Lpatch + (0xa634 - PATCH_BASE)
LFQH_Lloh760:
adr x0, LFQH_l_.str.130
LFQH_Lloh761:
nop
bl Lpatch + (0xa5b0 - PATCH_BASE)
mov	x20, x0
LFQH_Lloh762:
adr x0, LFQH_l_.str.131
LFQH_Lloh763:
nop
bl Lpatch + (0xa5a4 - PATCH_BASE)
mov	x1, x0
mov	x0, x20
bl Lpatch + (0xa5d4 - PATCH_BASE)
mov	x20, x0
LFQH_Lloh764:
adr x0, LFQH_l_.str.85
LFQH_Lloh765:
nop
bl Lpatch + (0xa5b0 - PATCH_BASE)
mov	x21, x0
LFQH_Lloh766:
adr x0, LFQH_l_.str.86
LFQH_Lloh767:
nop
bl Lpatch + (0xa5a4 - PATCH_BASE)
mov	x1, x0
mov	x0, x21
mov	x2, x19
bl Lpatch + (0xa5d4 - PATCH_BASE)
mov	x2, x0
LFQH_Lloh768:
adr x1, LFQH_l_.str.132
LFQH_Lloh769:
nop
mov	x0, x20
bl	LFQH_Put
mov.16b	v0, v14
ldp	d2, d1, [sp, #136]
ldr	d3, [sp, #32]
bl	LFQH_RectArray
mov	x2, x0
LFQH_Lloh770:
adr x1, LFQH_l_.str.133
LFQH_Lloh771:
nop
mov	x0, x20
bl	LFQH_Put
ldp	d1, d0, [sp, #16]
ldp	d2, d3, [sp]
bl	LFQH_RectArray
mov	x2, x0
LFQH_Lloh772:
adr x1, LFQH_l_.str.134
LFQH_Lloh773:
nop
mov	x0, x20
bl	LFQH_Put
ldp	d1, d0, [sp, #120]
ldr	d2, [sp, #112]
mov.16b	v3, v13
bl	LFQH_RectArray
mov	x2, x0
LFQH_Lloh774:
adr x1, LFQH_l_.str.135
LFQH_Lloh775:
nop
mov	x0, x20
bl	LFQH_Put
mov.16b	v0, v11
ldp	d2, d1, [sp, #96]
ldr	d3, [sp, #88]
bl	LFQH_RectArray
mov	x2, x0
LFQH_Lloh776:
adr x1, LFQH_l_.str.136
LFQH_Lloh777:
nop
mov	x0, x20
bl	LFQH_Put
mov.16b	v0, v8
mov.16b	v1, v15
mov.16b	v2, v9
mov.16b	v3, v10
bl	LFQH_RectArray
mov	x2, x0
LFQH_Lloh778:
adr x1, LFQH_l_.str.137
LFQH_Lloh779:
nop
mov	x0, x20
bl	LFQH_Put
LFQH_Lloh780:
adr x0, LFQH_l_.str.138
LFQH_Lloh781:
nop
mov	x1, x20
bl Lrecord_named
LFQH_LBB55_26:
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
LFQH_Lloh782:
adr x0, LFQH_l_.str.110
LFQH_Lloh783:
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
LFQH_Lloh784:
adr x0, LFQH_l_.str.110
LFQH_Lloh785:
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
LFQH_Lloh786:
adr x0, LFQH_l_.str.140
LFQH_Lloh787:
nop
bl Lpatch + (0xa5a4 - PATCH_BASE)
mov	x22, x0
LFQH_Lloh788:
adr x0, LFQH_l_.str.85
LFQH_Lloh789:
nop
bl Lpatch + (0xa5b0 - PATCH_BASE)
mov	x23, x0
LFQH_Lloh790:
adr x0, LFQH_l_.str.86
LFQH_Lloh791:
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
LFQH_Lloh792:
adr x0, LFQH_l_.str.141
LFQH_Lloh793:
nop
bl Lpatch + (0xa5b0 - PATCH_BASE)
mov	x19, x0
LFQH_Lloh794:
adr x0, LFQH_l_.str.142
LFQH_Lloh795:
nop
bl Lpatch + (0xa5a4 - PATCH_BASE)
mov	x1, x0
mov	x0, x19
bl Lpatch + (0xa5d4 - PATCH_BASE)
mov	x19, x0
LFQH_Lloh796:
adr x20, LFQH_l_.str.143
LFQH_Lloh797:
nop
mov	x0, x20
bl Lpatch + (0xa5a4 - PATCH_BASE)
mov	x23, x0
LFQH_Lloh798:
adr x21, LFQH_l_.str.98
LFQH_Lloh799:
nop
mov	x0, x21
bl Lpatch + (0xa5b0 - PATCH_BASE)
mov	x24, x0
LFQH_Lloh800:
adr x22, LFQH_l_.str.139
LFQH_Lloh801:
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
.asciz	"SSBookStoreCategorySignView"
LFQH_l_.str.13:
.asciz	"layoutSubviews"
LFQH_l_.str.14:
.asciz	"resetColorWithRatio:fromTab:toTab:fromTabTemplate:toTabTemplate:"
LFQH_l_.str.15:
.asciz	"v40@0:8d16i24i28i32i36"
LFQH_l_.str.16:
.asciz	"UIGlassEffect"
LFQH_l_.str.17:
.asciz	"effectWithStyle:"
LFQH_l_.str.18:
.asciz	"UICornerConfiguration"
LFQH_l_.str.19:
.asciz	"capsuleConfiguration"
LFQH_l_.str.20:
.asciz	"UIVisualEffectView"
LFQH_l_.str.21:
.asciz	"setCornerConfiguration:"
LFQH_l_.str.22:
.asciz	"setInteractive:"
LFQH_l_.str.23:
.asciz	"SSBookShelfProfileDurationTipButton"
LFQH_l_.str.24:
.asciz	"superview"
LFQH_l_.str.25:
.asciz	"SS525BookShelfSubHeaderView"
LFQH_l_.str.26:
.asciz	"coinButton"
LFQH_l_.str.27:
.asciz	"UIView"
LFQH_l_.str.28:
.asciz	"bounds"
LFQH_l_.str.29:
.asciz	"alloc"
LFQH_l_.str.30:
.asciz	"initWithEffect:"
LFQH_l_.str.31:
.asciz	"setUserInteractionEnabled:"
LFQH_l_.str.32:
.asciz	"setAccessibilityElementsHidden:"
LFQH_l_.str.33:
.asciz	"setIsAccessibilityElement:"
LFQH_l_.str.34:
.asciz	"setOpaque:"
LFQH_l_.str.35:
.asciz	"setAutoresizingMask:"
LFQH_l_.str.36:
.asciz	"release"
LFQH_l_.str.37:
.asciz	"backgroundColor"
LFQH_l_.str.38:
.asciz	"UIColor"
LFQH_l_.str.39:
.asciz	"clearColor"
LFQH_l_.str.40:
.asciz	"isEqual:"
LFQH_l_.str.41:
.asciz	"CATransaction"
LFQH_l_.str.42:
.asciz	"begin"
LFQH_l_.str.43:
.asciz	"setDisableActions:"
LFQH_l_.str.44:
.asciz	"setFrame:"
LFQH_l_.str.45:
.asciz	"setBackgroundColor:"
LFQH_l_.str.46:
.asciz	"contentView"
LFQH_l_.str.47:
.asciz	"insertSubview:atIndex:"
LFQH_l_.str.48:
.asciz	"commit"
LFQH_l_.str.49:
.asciz	"UIButtonConfiguration"
LFQH_l_.str.50:
.asciz	"glassButtonConfiguration"
LFQH_l_.str.51:
.asciz	"icon"
LFQH_l_.str.52:
.asciz	"integerValue"
LFQH_l_.str.53:
.asciz	"backBtn"
LFQH_l_.str.54:
.asciz	"readerBack"
LFQH_l_.str.55:
.asciz	"insertObjs"
LFQH_l_.str.56:
.asciz	"NSArray"
LFQH_l_.str.57:
.asciz	"count"
LFQH_l_.str.58:
.asciz	"getInsertView"
LFQH_l_.str.59:
.asciz	"searchButton"
LFQH_l_.str.60:
.asciz	"moreButton"
LFQH_l_.str.61:
.asciz	"searchAndMoreView"
LFQH_l_.str.62:
.asciz	"search"
LFQH_l_.str.63:
.asciz	"more"
LFQH_l_.str.64:
.asciz	"shelfSearch"
LFQH_l_.str.65:
.asciz	"shelfMore"
LFQH_l_.str.66:
.asciz	"fqx165_originalRelayout"
LFQH_l_.str.67:
.asciz	"viewDidAppear:"
LFQH_l_.str.68:
.asciz	"fqx165_originalAppear:"
LFQH_l_.str.69:
.asciz	"v20@0:8B16"
LFQH_l_.str.70:
.asciz	"fqx165_originalLayout"
LFQH_l_.str.71:
.asciz	"fqx165_originalColor:from:to:fromTemplate:toTemplate:"
LFQH_l_.str.72:
.asciz	"SSBookStoreSearchBarComponent"
LFQH_l_.str.73:
.asciz	"resetTopTabSearchViewWithRatio:fromTab:toTab:fromTabTemplate:toTabTemplate:"
LFQH_l_.str.74:
.asciz	"fqx165_originalSearchColor:from:to:fromTemplate:toTemplate:"
LFQH_l_.str.75:
.asciz	"FQReaderSaaSBaseButton"
LFQH_l_.str.76:
.asciz	"fqx170_originalLayout"
LFQH_l_.str.77:
.asciz	"SSBookShelfSubViewController"
LFQH_l_.str.78:
.asciz	"viewDidLayoutSubviews"
LFQH_l_.str.79:
.asciz	"fqx167_originalShelfLayout"
LFQH_l_.str.80:
.asciz	"FQReaderSaasNavigationView"
LFQH_l_.str.81:
.asciz	"fqx167_originalLayout"
LFQH_l_.str.82:
.asciz	"readerInsertedViewThemeConfigChange:"
LFQH_l_.str.83:
.asciz	"fqx167_originalTheme:"
LFQH_l_.str.84:
.asciz	"v24@0:8@16"
LFQH_l_.str.85:
.asciz	"NSString"
LFQH_l_.str.86:
.asciz	"stringWithUTF8String:"
LFQH_l_.str.87:
.asciz	"respondsToSelector:"
LFQH_l_.str.88:
.asciz	"isKindOfClass:"
LFQH_l_.str.89:
.asciz	"NSUserDefaults"
LFQH_l_.str.90:
.asciz	"standardUserDefaults"
LFQH_l_.str.91:
.asciz	"integerForKey:"
LFQH_l_.str.92:
.asciz	"FanqieAdBlock.GlassDisabled.1"
LFQH_l_.str.93:
.asciz	"removeFromSuperview"
LFQH_l_.str.94:
.asciz	"clipsToBounds"
LFQH_l_.str.95:
.asciz	"setClipsToBounds:"
LFQH_l_.str.96:
.asciz	"boolValue"
LFQH_l_.str.97:
.asciz	"isOpaque"
LFQH_l_.str.98:
.asciz	"NSNumber"
LFQH_l_.str.99:
.asciz	"numberWithBool:"
LFQH_l_.str.100:
.asciz	"UIButton"
LFQH_l_.str.101:
.asciz	"imageView"
LFQH_l_.str.102:
.asciz	"isHidden"
LFQH_l_.str.103:
.asciz	"new"
LFQH_l_.str.104:
.asciz	"setConfiguration:"
LFQH_l_.str.105:
.asciz	"UIControl"
LFQH_l_.str.106:
.asciz	"setEnabled:"
LFQH_l_.str.107:
.asciz	"isEnabled"
LFQH_l_.str.108:
.asciz	"setSelected:"
LFQH_l_.str.109:
.asciz	"isSelected"
LFQH_l_.str.110:
.asciz	"setHighlighted:"
LFQH_l_.str.111:
.asciz	"isHighlighted"
LFQH_l_.str.112:
.asciz	"convertRect:toView:"
LFQH_l_.str.113:
.asciz	"CGRectValue"
LFQH_l_.str.114:
.asciz	"frame"
LFQH_l_.str.115:
.asciz	"NSValue"
LFQH_l_.str.116:
.asciz	"valueWithCGRect:"
LFQH_l_.str.117:
.asciz	"btd_hitTestEdgeInsets"
LFQH_l_.str.118:
.asciz	"setBtd_hitTestEdgeInsets:"
LFQH_l_.str.119:
.asciz	"FQXGlassBackground167"
LFQH_l_.str.120:
.asciz	"fqx167_down:"
LFQH_l_.str.121:
.asciz	"fqx167_up:"
LFQH_l_.str.122:
.asciz	"addTarget:action:forControlEvents:"
LFQH_l_.str.123:
.asciz	"removeTarget:action:forControlEvents:"
LFQH_l_.str.124:
.asciz	"window"
LFQH_l_.str.125:
.asciz	"NSProcessInfo"
LFQH_l_.str.126:
.asciz	"processInfo"
LFQH_l_.str.127:
.asciz	"systemUptime"
LFQH_l_.str.128:
.asciz	"doubleValue"
LFQH_l_.str.129:
.asciz	"arrayWithObjects:count:"
LFQH_l_.str.130:
.asciz	"NSMutableDictionary"
LFQH_l_.str.131:
.asciz	"dictionary"
LFQH_l_.str.132:
.asciz	"role"
LFQH_l_.str.133:
.asciz	"hostFrame"
LFQH_l_.str.134:
.asciz	"hostBounds"
LFQH_l_.str.135:
.asciz	"imageRect"
LFQH_l_.str.136:
.asciz	"glassRect"
LFQH_l_.str.137:
.asciz	"windowRect"
LFQH_l_.str.138:
.asciz	"controlLayout167"
LFQH_l_.str.139:
.asciz	"numberWithDouble:"
LFQH_l_.str.140:
.asciz	"setObject:forKey:"
LFQH_l_.str.141:
.asciz	"NSMutableArray"
LFQH_l_.str.142:
.asciz	"array"
LFQH_l_.str.143:
.asciz	"addObject:"
LFQH_l_.str.144:
.asciz	"objectAtIndex:"
LFQH_l_.str.145:
.asciz	"FQReaderNavigationBarMoreBtnInsertObject"
LFQH_l_.str.146:
.asciz	"readerMore"
LFQH_l_.str.147:
.asciz	"FQReaderNavigationBarSearchBtnInsertObject"
LFQH_l_.str.148:
.asciz	"readerSearch"
LFQH_l_.str.149:
.asciz	"SSReaderNavigationBarDownloadBtnInsertObject"
LFQH_l_.str.150:
.asciz	"readerDownload"
LFQH_l_.str.151:
.asciz	"SSReaderNavigationBarCommunitySwitchBtnInsertObject"
LFQH_l_.str.152:
.asciz	"readerCommunity"
LFQH_l_.str.153:
.asciz	"numberWithLongLong:"
LFQH_l_.str.154:
.asciz	"bookStoreVCContext"
