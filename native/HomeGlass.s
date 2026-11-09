// Source SHA-256: 7dba86a7a221e588f18e7b1de557b5329617865d3b457faa60a2e0e4b68675c2
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
adr x0, LFQH_l_.str.55
LFQH_Lloh11:
nop
bl Lpatch + (0xa5b0 - PATCH_BASE)
mov	x22, x0
LFQH_Lloh12:
adr x0, LFQH_l_.str.56
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
adr x0, LFQH_l_.str.36
LFQH_Lloh43:
nop
bl Lpatch + (0xa5a4 - PATCH_BASE)
mov	x21, x0
LFQH_Lloh44:
adr x0, LFQH_l_.str.55
LFQH_Lloh45:
nop
bl Lpatch + (0xa5b0 - PATCH_BASE)
mov	x22, x0
LFQH_Lloh46:
adr x0, LFQH_l_.str.56
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
LFQH_Lloh48:
adr x0, LFQH_l_.str.16
LFQH_Lloh49:
nop
bl Lpatch + (0xa5b0 - PATCH_BASE)
LFQH_Lloh50:
adr x1, LFQH_l_.str.17
LFQH_Lloh51:
nop
bl	LFQH_Responds
cbz	w0, LFQH_LBB3_4
LFQH_Lloh52:
adr x0, LFQH_l_.str.18
LFQH_Lloh53:
nop
bl Lpatch + (0xa5b0 - PATCH_BASE)
LFQH_Lloh54:
adr x1, LFQH_l_.str.19
LFQH_Lloh55:
nop
bl	LFQH_Responds
cbz	w0, LFQH_LBB3_4
LFQH_Lloh56:
adr x0, LFQH_l_.str.20
LFQH_Lloh57:
nop
bl Lpatch + (0xa5b0 - PATCH_BASE)
mov	x19, x0
LFQH_Lloh58:
adr x0, LFQH_l_.str.21
LFQH_Lloh59:
nop
bl Lpatch + (0xa5a4 - PATCH_BASE)
mov	x1, x0
mov	x0, x19
bl Lpatch + (0xa5f8 - PATCH_BASE)
cbz	x0, LFQH_LBB3_4
LFQH_Lloh60:
adr x0, LFQH_l_.str.16
LFQH_Lloh61:
nop
bl Lpatch + (0xa5b0 - PATCH_BASE)
mov	x19, x0
LFQH_Lloh62:
adr x0, LFQH_l_.str.22
LFQH_Lloh63:
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
LFQH_Lloh64:
adr x0, LFQH_l_.str.57
LFQH_Lloh65:
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
cbz	x0, LFQH_LBB5_3
mov	x19, x0
LFQH_Lloh66:
adr x0, LFQH_l_.str.58
LFQH_Lloh67:
nop
bl Lpatch + (0xa5a4 - PATCH_BASE)
mov	x20, x0
LFQH_Lloh68:
adr x0, LFQH_l_.str.23
LFQH_Lloh69:
nop
bl Lpatch + (0xa5b0 - PATCH_BASE)
mov	x2, x0
mov	x0, x19
mov	x1, x20
bl Lpatch + (0xa5d4 - PATCH_BASE)
cbz	w0, LFQH_LBB5_3
LFQH_Lloh70:
adr x1, LFQH_BusyKey
LFQH_Lloh71:
nop
mov	x0, x19
bl Lpatch + (0xa628 - PATCH_BASE)
cbz	x0, LFQH_LBB5_4
LFQH_LBB5_3:
ldp	x29, x30, [sp, #80]
ldp	x20, x19, [sp, #64]
ldp	x22, x21, [sp, #48]
ldp	x24, x23, [sp, #32]
ldp	d9, d8, [sp, #16]
ldp	d11, d10, [sp], #96
ret
LFQH_LBB5_4:
LFQH_Lloh72:
adr x1, LFQH_BusyKey
LFQH_Lloh73:
nop
mov	x0, x19
mov	x2, x19
mov	x3, #0
bl Lpatch + (0xa634 - PATCH_BASE)
LFQH_Lloh74:
adr x1, LFQH_SurfaceKey
LFQH_Lloh75:
nop
mov	x0, x19
bl Lpatch + (0xa628 - PATCH_BASE)
mov	x20, x0
LFQH_Lloh76:
adr x0, LFQH_l_.str.24
LFQH_Lloh77:
nop
bl Lpatch + (0xa5a4 - PATCH_BASE)
mov	x1, x0
mov	x0, x19
bl Lpatch + (0xa5d4 - PATCH_BASE)
mov.16b	v8, v0
mov.16b	v9, v1
mov.16b	v10, v2
mov.16b	v11, v3
LFQH_Lloh78:
adr x0, LFQH_l_.str.59
LFQH_Lloh79:
nop
bl Lpatch + (0xa5b0 - PATCH_BASE)
mov	x21, x0
LFQH_Lloh80:
adr x0, LFQH_l_.str.60
LFQH_Lloh81:
nop
bl Lpatch + (0xa5a4 - PATCH_BASE)
mov	x1, x0
mov	x0, x21
bl Lpatch + (0xa5d4 - PATCH_BASE)
mov	x21, x0
LFQH_Lloh82:
adr x0, LFQH_l_.str.61
LFQH_Lloh83:
nop
bl Lpatch + (0xa5a4 - PATCH_BASE)
mov	x22, x0
LFQH_Lloh84:
adr x0, LFQH_l_.str.55
LFQH_Lloh85:
nop
bl Lpatch + (0xa5b0 - PATCH_BASE)
mov	x23, x0
LFQH_Lloh86:
adr x0, LFQH_l_.str.56
LFQH_Lloh87:
nop
bl Lpatch + (0xa5a4 - PATCH_BASE)
mov	x1, x0
LFQH_Lloh88:
adr x2, LFQH_l_.str.62
LFQH_Lloh89:
nop
mov	x0, x23
bl Lpatch + (0xa5d4 - PATCH_BASE)
mov	x2, x0
mov	x0, x21
mov	x1, x22
bl Lpatch + (0xa5d4 - PATCH_BASE)
cbz	x0, LFQH_LBB5_11
LFQH_LBB5_5:
cbz	x20, LFQH_LBB5_10
LFQH_Lloh90:
adr x0, LFQH_l_.str.34
LFQH_Lloh91:
nop
bl Lpatch + (0xa5b0 - PATCH_BASE)
mov	x21, x0
LFQH_Lloh92:
adr x0, LFQH_l_.str.35
LFQH_Lloh93:
nop
bl Lpatch + (0xa5a4 - PATCH_BASE)
mov	x1, x0
mov	x0, x21
bl Lpatch + (0xa5d4 - PATCH_BASE)
mov	x21, x0
LFQH_Lloh94:
adr x0, LFQH_l_.str.33
LFQH_Lloh95:
nop
bl Lpatch + (0xa5a4 - PATCH_BASE)
mov	x1, x0
mov	x0, x19
bl Lpatch + (0xa5d4 - PATCH_BASE)
cmp	x0, x21
b.eq	LFQH_LBB5_8
mov	x22, x0
LFQH_Lloh96:
adr x0, LFQH_l_.str.36
LFQH_Lloh97:
nop
bl Lpatch + (0xa5a4 - PATCH_BASE)
mov	x1, x0
mov	x0, x22
mov	x2, x21
bl Lpatch + (0xa5d4 - PATCH_BASE)
cbz	w0, LFQH_LBB5_9
LFQH_LBB5_8:
LFQH_Lloh98:
adr x0, LFQH_l_.str.41
LFQH_Lloh99:
nop
bl Lpatch + (0xa5a4 - PATCH_BASE)
mov	x21, x0
LFQH_Lloh100:
adr x1, LFQH_BackgroundKey
LFQH_Lloh101:
nop
mov	x0, x19
bl Lpatch + (0xa628 - PATCH_BASE)
mov	x2, x0
mov	x0, x19
mov	x1, x21
bl Lpatch + (0xa5d4 - PATCH_BASE)
LFQH_LBB5_9:
LFQH_Lloh102:
adr x0, LFQH_l_.str.63
LFQH_Lloh103:
nop
bl Lpatch + (0xa5a4 - PATCH_BASE)
mov	x1, x0
mov	x0, x20
bl Lpatch + (0xa5d4 - PATCH_BASE)
LFQH_Lloh104:
adr x1, LFQH_SurfaceKey
LFQH_Lloh105:
nop
mov	x0, x19
mov	x2, #0
mov	w3, #1
bl Lpatch + (0xa634 - PATCH_BASE)
LFQH_Lloh106:
adr x1, LFQH_BackgroundKey
LFQH_Lloh107:
nop
mov	x0, x19
mov	x2, #0
mov	w3, #1
bl Lpatch + (0xa634 - PATCH_BASE)
LFQH_LBB5_10:
LFQH_Lloh108:
adr x1, LFQH_BusyKey
LFQH_Lloh109:
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
LFQH_LBB5_11:
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
cbz	w0, LFQH_LBB5_5
tbnz	w8, #0, LFQH_LBB5_5
tbnz	w9, #0, LFQH_LBB5_5
tbnz	w10, #0, LFQH_LBB5_5
fmov	x8, d11
and	x8, x8, #0x7fffffffffffffff
mov	x9, #9218868437227405311
cmp	x8, x9
b.gt	LFQH_LBB5_5
fcmp	d10, #0.0
b.le	LFQH_LBB5_5
fcmp	d11, #0.0
b.le	LFQH_LBB5_5
cbz	x20, LFQH_LBB5_25
LFQH_LBB5_19:
LFQH_Lloh110:
adr x0, LFQH_l_.str.34
LFQH_Lloh111:
nop
bl Lpatch + (0xa5b0 - PATCH_BASE)
mov	x21, x0
LFQH_Lloh112:
adr x0, LFQH_l_.str.35
LFQH_Lloh113:
nop
bl Lpatch + (0xa5a4 - PATCH_BASE)
mov	x1, x0
mov	x0, x21
bl Lpatch + (0xa5d4 - PATCH_BASE)
mov	x21, x0
LFQH_Lloh114:
adr x0, LFQH_l_.str.33
LFQH_Lloh115:
nop
bl Lpatch + (0xa5a4 - PATCH_BASE)
mov	x1, x0
mov	x0, x19
bl Lpatch + (0xa5d4 - PATCH_BASE)
cmp	x0, x21
b.eq	LFQH_LBB5_22
mov	x22, x0
LFQH_Lloh116:
adr x0, LFQH_l_.str.36
LFQH_Lloh117:
nop
bl Lpatch + (0xa5a4 - PATCH_BASE)
mov	x1, x0
mov	x0, x22
mov	x2, x21
bl Lpatch + (0xa5d4 - PATCH_BASE)
cbnz	w0, LFQH_LBB5_22
LFQH_Lloh118:
adr x1, LFQH_BackgroundKey
LFQH_Lloh119:
nop
mov	x0, x19
mov	x2, x22
mov	w3, #1
bl Lpatch + (0xa634 - PATCH_BASE)
LFQH_LBB5_22:
LFQH_Lloh120:
adr x0, LFQH_l_.str.37
LFQH_Lloh121:
nop
bl Lpatch + (0xa5b0 - PATCH_BASE)
mov	x22, x0
LFQH_Lloh122:
adr x0, LFQH_l_.str.38
LFQH_Lloh123:
nop
bl Lpatch + (0xa5a4 - PATCH_BASE)
mov	x1, x0
mov	x0, x22
bl Lpatch + (0xa5d4 - PATCH_BASE)
LFQH_Lloh124:
adr x0, LFQH_l_.str.39
LFQH_Lloh125:
nop
bl Lpatch + (0xa5a4 - PATCH_BASE)
mov	x1, x0
mov	x0, x22
mov	w2, #1
bl Lpatch + (0xa5d4 - PATCH_BASE)
LFQH_Lloh126:
adr x0, LFQH_l_.str.40
LFQH_Lloh127:
nop
bl Lpatch + (0xa5a4 - PATCH_BASE)
mov	x1, x0
mov	x0, x20
mov.16b	v0, v8
mov.16b	v1, v9
mov.16b	v2, v10
mov.16b	v3, v11
bl Lpatch + (0xa5d4 - PATCH_BASE)
LFQH_Lloh128:
adr x23, LFQH_l_.str.41
LFQH_Lloh129:
nop
mov	x0, x23
bl Lpatch + (0xa5a4 - PATCH_BASE)
mov	x1, x0
mov	x0, x20
mov	x2, x21
bl Lpatch + (0xa5d4 - PATCH_BASE)
LFQH_Lloh130:
adr x0, LFQH_l_.str.42
LFQH_Lloh131:
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
LFQH_Lloh132:
adr x0, LFQH_l_.str.43
LFQH_Lloh133:
nop
bl Lpatch + (0xa5a4 - PATCH_BASE)
mov	x1, x0
mov	x0, x20
bl Lpatch + (0xa5d4 - PATCH_BASE)
cmp	x0, x19
b.eq	LFQH_LBB5_24
LFQH_Lloh134:
adr x0, LFQH_l_.str.44
LFQH_Lloh135:
nop
bl Lpatch + (0xa5a4 - PATCH_BASE)
mov	x1, x0
mov	x0, x19
mov	x2, x20
mov	x3, #0
bl Lpatch + (0xa5d4 - PATCH_BASE)
LFQH_LBB5_24:
LFQH_Lloh136:
adr x0, LFQH_l_.str.45
LFQH_Lloh137:
nop
bl Lpatch + (0xa5a4 - PATCH_BASE)
mov	x1, x0
mov	x0, x22
bl Lpatch + (0xa5d4 - PATCH_BASE)
b	LFQH_LBB5_10
LFQH_LBB5_25:
LFQH_Lloh138:
adr x0, LFQH_l_.str.16
LFQH_Lloh139:
nop
bl Lpatch + (0xa5b0 - PATCH_BASE)
mov	x20, x0
LFQH_Lloh140:
adr x0, LFQH_l_.str.17
LFQH_Lloh141:
nop
bl Lpatch + (0xa5a4 - PATCH_BASE)
mov	x1, x0
mov	x0, x20
mov	x2, #0
bl Lpatch + (0xa5d4 - PATCH_BASE)
cbz	x0, LFQH_LBB5_10
mov	x20, x0
LFQH_Lloh142:
adr x0, LFQH_l_.str.22
LFQH_Lloh143:
nop
bl Lpatch + (0xa5a4 - PATCH_BASE)
mov	x1, x0
mov	x0, x20
mov	w2, #1
bl Lpatch + (0xa5d4 - PATCH_BASE)
LFQH_Lloh144:
adr x0, LFQH_l_.str.20
LFQH_Lloh145:
nop
bl Lpatch + (0xa5b0 - PATCH_BASE)
mov	x21, x0
LFQH_Lloh146:
adr x0, LFQH_l_.str.25
LFQH_Lloh147:
nop
bl Lpatch + (0xa5a4 - PATCH_BASE)
mov	x1, x0
mov	x0, x21
bl Lpatch + (0xa5d4 - PATCH_BASE)
mov	x21, x0
LFQH_Lloh148:
adr x0, LFQH_l_.str.26
LFQH_Lloh149:
nop
bl Lpatch + (0xa5a4 - PATCH_BASE)
mov	x1, x0
mov	x0, x21
mov	x2, x20
bl Lpatch + (0xa5d4 - PATCH_BASE)
cbz	x0, LFQH_LBB5_10
mov	x20, x0
LFQH_Lloh150:
adr x0, LFQH_l_.str.21
LFQH_Lloh151:
nop
bl Lpatch + (0xa5a4 - PATCH_BASE)
mov	x21, x0
LFQH_Lloh152:
adr x0, LFQH_l_.str.18
LFQH_Lloh153:
nop
bl Lpatch + (0xa5b0 - PATCH_BASE)
mov	x22, x0
LFQH_Lloh154:
adr x0, LFQH_l_.str.19
LFQH_Lloh155:
nop
bl Lpatch + (0xa5a4 - PATCH_BASE)
mov	x1, x0
mov	x0, x22
bl Lpatch + (0xa5d4 - PATCH_BASE)
mov	x2, x0
mov	x0, x20
mov	x1, x21
bl Lpatch + (0xa5d4 - PATCH_BASE)
LFQH_Lloh156:
adr x0, LFQH_l_.str.27
LFQH_Lloh157:
nop
bl Lpatch + (0xa5a4 - PATCH_BASE)
mov	x1, x0
mov	x0, x20
mov	w2, #0
bl Lpatch + (0xa5d4 - PATCH_BASE)
LFQH_Lloh158:
adr x0, LFQH_l_.str.28
LFQH_Lloh159:
nop
bl Lpatch + (0xa5a4 - PATCH_BASE)
mov	x1, x0
mov	x0, x20
mov	w2, #1
bl Lpatch + (0xa5d4 - PATCH_BASE)
LFQH_Lloh160:
adr x0, LFQH_l_.str.29
LFQH_Lloh161:
nop
bl Lpatch + (0xa5a4 - PATCH_BASE)
mov	x1, x0
mov	x0, x20
mov	w2, #0
bl Lpatch + (0xa5d4 - PATCH_BASE)
LFQH_Lloh162:
adr x0, LFQH_l_.str.30
LFQH_Lloh163:
nop
bl Lpatch + (0xa5a4 - PATCH_BASE)
mov	x1, x0
mov	x0, x20
mov	w2, #0
bl Lpatch + (0xa5d4 - PATCH_BASE)
LFQH_Lloh164:
adr x0, LFQH_l_.str.31
LFQH_Lloh165:
nop
bl Lpatch + (0xa5a4 - PATCH_BASE)
mov	x1, x0
mov	x0, x20
mov	w2, #18
bl Lpatch + (0xa5d4 - PATCH_BASE)
LFQH_Lloh166:
adr x1, LFQH_SurfaceKey
LFQH_Lloh167:
nop
mov	x0, x19
mov	x2, x20
mov	w3, #1
bl Lpatch + (0xa634 - PATCH_BASE)
LFQH_Lloh168:
adr x0, LFQH_l_.str.32
LFQH_Lloh169:
nop
bl Lpatch + (0xa5a4 - PATCH_BASE)
mov	x1, x0
mov	x0, x20
bl Lpatch + (0xa5d4 - PATCH_BASE)
LFQH_Lloh170:
adr x0, LFQH_l_.str.33
LFQH_Lloh171:
nop
bl Lpatch + (0xa5a4 - PATCH_BASE)
mov	x1, x0
mov	x0, x19
bl Lpatch + (0xa5d4 - PATCH_BASE)
mov	x2, x0
LFQH_Lloh172:
adr x1, LFQH_BackgroundKey
LFQH_Lloh173:
nop
mov	x0, x19
mov	w3, #1
bl Lpatch + (0xa634 - PATCH_BASE)
b	LFQH_LBB5_19
.cfi_endproc
.p2align	2
LFQH_BusyKey:
.cfi_startproc
ret
.cfi_endproc
.p2align	2
LFQH_SurfaceKey:
.cfi_startproc
ret
.cfi_endproc
.p2align	2
LFQH_BackgroundKey:
.cfi_startproc
ret
.cfi_endproc
.p2align	2
LFQH_FQHInstall:
.cfi_startproc
stp	x20, x19, [sp, #-32]!
stp	x29, x30, [sp, #16]
add	x29, sp, #16
.cfi_def_cfa w29, 16
.cfi_offset w30, -8
.cfi_offset w29, -16
.cfi_offset w19, -24
.cfi_offset w20, -32
bl	LFQH_FQHGlassAvailable
cbz	w0, LFQH_LBB9_2
LFQH_Lloh174:
adr x19, LFQH_l_.str.7
LFQH_Lloh175:
nop
LFQH_Lloh176:
adr x1, LFQH_l_.str.8
LFQH_Lloh177:
nop
LFQH_Lloh178:
adr x2, LFQH_l_.str.46
LFQH_Lloh179:
nop
LFQH_Lloh180:
adr x20, LFQH_l_.str.9
LFQH_Lloh181:
nop
LFQH_Lloh182:
adr x4, LFQH_HomeLayout
LFQH_Lloh183:
nop
mov	x0, x19
mov	x3, x20
bl	LFQH_Hook
LFQH_Lloh184:
adr x1, LFQH_l_.str.47
LFQH_Lloh185:
nop
LFQH_Lloh186:
adr x2, LFQH_l_.str.48
LFQH_Lloh187:
nop
LFQH_Lloh188:
adr x3, LFQH_l_.str.49
LFQH_Lloh189:
nop
LFQH_Lloh190:
adr x4, LFQH_HomeAppear
LFQH_Lloh191:
nop
mov	x0, x19
bl	LFQH_Hook
LFQH_Lloh192:
adr x19, LFQH_l_.str.12
LFQH_Lloh193:
nop
LFQH_Lloh194:
adr x1, LFQH_l_.str.13
LFQH_Lloh195:
nop
LFQH_Lloh196:
adr x2, LFQH_l_.str.50
LFQH_Lloh197:
nop
LFQH_Lloh198:
adr x4, LFQH_CategoryLayout
LFQH_Lloh199:
nop
mov	x0, x19
mov	x3, x20
bl	LFQH_Hook
LFQH_Lloh200:
adr x1, LFQH_l_.str.14
LFQH_Lloh201:
nop
LFQH_Lloh202:
adr x2, LFQH_l_.str.51
LFQH_Lloh203:
nop
LFQH_Lloh204:
adr x20, LFQH_l_.str.15
LFQH_Lloh205:
nop
LFQH_Lloh206:
adr x4, LFQH_CategoryColor
LFQH_Lloh207:
nop
mov	x0, x19
mov	x3, x20
bl	LFQH_Hook
LFQH_Lloh208:
adr x0, LFQH_l_.str.52
LFQH_Lloh209:
nop
LFQH_Lloh210:
adr x1, LFQH_l_.str.53
LFQH_Lloh211:
nop
LFQH_Lloh212:
adr x2, LFQH_l_.str.54
LFQH_Lloh213:
nop
LFQH_Lloh214:
adr x4, LFQH_SearchColor
LFQH_Lloh215:
nop
mov	x3, x20
ldp	x29, x30, [sp, #16]
ldp	x20, x19, [sp], #32
b	LFQH_Hook
LFQH_LBB9_2:
ldp	x29, x30, [sp, #16]
ldp	x20, x19, [sp], #32
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
cbz	x0, LFQH_LBB10_2
mov	x21, x0
mov	x0, x22
bl Lpatch + (0xa5a4 - PATCH_BASE)
mov	x1, x0
mov	x0, x21
bl Lpatch + (0xa5f8 - PATCH_BASE)
cbz	x0, LFQH_LBB10_3
LFQH_LBB10_2:
ldp	x29, x30, [sp, #48]
ldp	x20, x19, [sp, #32]
ldp	x22, x21, [sp, #16]
ldp	x24, x23, [sp], #64
ret
LFQH_LBB10_3:
mov	x0, x23
bl Lpatch + (0xa5a4 - PATCH_BASE)
mov	x1, x0
mov	x0, x21
mov	w2, #0
mov	x3, x20
bl LHookOwned
cbz	x0, LFQH_LBB10_2
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
cbz	w0, LFQH_LBB10_2
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
LFQH_Lloh216:
adr x0, LFQH_l_.str.7
LFQH_Lloh217:
nop
LFQH_Lloh218:
adr x1, LFQH_l_.str.46
LFQH_Lloh219:
nop
bl	LFQH_Original
mov	x8, x0
mov	x0, x20
mov	x1, x19
blr	x8
LFQH_Lloh220:
adr x1, LFQH_l_.str.10
LFQH_Lloh221:
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
LFQH_Lloh222:
adr x0, LFQH_l_.str.7
LFQH_Lloh223:
nop
LFQH_Lloh224:
adr x1, LFQH_l_.str.48
LFQH_Lloh225:
nop
bl	LFQH_Original
mov	x8, x0
mov	x0, x21
mov	x1, x20
mov	x2, x19
blr	x8
LFQH_Lloh226:
adr x1, LFQH_l_.str.10
LFQH_Lloh227:
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
LFQH_Lloh228:
adr x0, LFQH_l_.str.12
LFQH_Lloh229:
nop
LFQH_Lloh230:
adr x1, LFQH_l_.str.50
LFQH_Lloh231:
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
LFQH_Lloh232:
adr x0, LFQH_l_.str.12
LFQH_Lloh233:
nop
LFQH_Lloh234:
adr x1, LFQH_l_.str.51
LFQH_Lloh235:
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
LFQH_Lloh236:
adr x0, LFQH_l_.str.52
LFQH_Lloh237:
nop
LFQH_Lloh238:
adr x1, LFQH_l_.str.54
LFQH_Lloh239:
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
LFQH_Lloh240:
adr x1, LFQH_l_.str.64
LFQH_Lloh241:
nop
mov	x0, x24
bl	LFQH_Get
LFQH_Lloh242:
adr x1, LFQH_l_.str.10
LFQH_Lloh243:
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
cbz	w0, LFQH_LBB17_2
mov	x0, x20
bl Lpatch + (0xa5a4 - PATCH_BASE)
mov	x1, x0
mov	x0, x19
ldp	x29, x30, [sp, #16]
ldp	x20, x19, [sp], #32
b Lpatch + (0xa5d4 - PATCH_BASE)
LFQH_LBB17_2:
mov	x0, #0
ldp	x29, x30, [sp, #16]
ldp	x20, x19, [sp], #32
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
.asciz	"UIView"
LFQH_l_.str.24:
.asciz	"bounds"
LFQH_l_.str.25:
.asciz	"alloc"
LFQH_l_.str.26:
.asciz	"initWithEffect:"
LFQH_l_.str.27:
.asciz	"setUserInteractionEnabled:"
LFQH_l_.str.28:
.asciz	"setAccessibilityElementsHidden:"
LFQH_l_.str.29:
.asciz	"setIsAccessibilityElement:"
LFQH_l_.str.30:
.asciz	"setOpaque:"
LFQH_l_.str.31:
.asciz	"setAutoresizingMask:"
LFQH_l_.str.32:
.asciz	"release"
LFQH_l_.str.33:
.asciz	"backgroundColor"
LFQH_l_.str.34:
.asciz	"UIColor"
LFQH_l_.str.35:
.asciz	"clearColor"
LFQH_l_.str.36:
.asciz	"isEqual:"
LFQH_l_.str.37:
.asciz	"CATransaction"
LFQH_l_.str.38:
.asciz	"begin"
LFQH_l_.str.39:
.asciz	"setDisableActions:"
LFQH_l_.str.40:
.asciz	"setFrame:"
LFQH_l_.str.41:
.asciz	"setBackgroundColor:"
LFQH_l_.str.42:
.asciz	"contentView"
LFQH_l_.str.43:
.asciz	"superview"
LFQH_l_.str.44:
.asciz	"insertSubview:atIndex:"
LFQH_l_.str.45:
.asciz	"commit"
LFQH_l_.str.46:
.asciz	"fqx165_originalRelayout"
LFQH_l_.str.47:
.asciz	"viewDidAppear:"
LFQH_l_.str.48:
.asciz	"fqx165_originalAppear:"
LFQH_l_.str.49:
.asciz	"v20@0:8B16"
LFQH_l_.str.50:
.asciz	"fqx165_originalLayout"
LFQH_l_.str.51:
.asciz	"fqx165_originalColor:from:to:fromTemplate:toTemplate:"
LFQH_l_.str.52:
.asciz	"SSBookStoreSearchBarComponent"
LFQH_l_.str.53:
.asciz	"resetTopTabSearchViewWithRatio:fromTab:toTab:fromTabTemplate:toTabTemplate:"
LFQH_l_.str.54:
.asciz	"fqx165_originalSearchColor:from:to:fromTemplate:toTemplate:"
LFQH_l_.str.55:
.asciz	"NSString"
LFQH_l_.str.56:
.asciz	"stringWithUTF8String:"
LFQH_l_.str.57:
.asciz	"respondsToSelector:"
LFQH_l_.str.58:
.asciz	"isKindOfClass:"
LFQH_l_.str.59:
.asciz	"NSUserDefaults"
LFQH_l_.str.60:
.asciz	"standardUserDefaults"
LFQH_l_.str.61:
.asciz	"integerForKey:"
LFQH_l_.str.62:
.asciz	"FanqieAdBlock.GlassDisabled.1"
LFQH_l_.str.63:
.asciz	"removeFromSuperview"
LFQH_l_.str.64:
.asciz	"bookStoreVCContext"
