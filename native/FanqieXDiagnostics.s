// Source SHA-256: df42965822aaddcf8b7a44ed339b6761788189535cc510323b79e218319ee0e9
.p2align	2
LFQD_FQDLoadSummary:
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
bl	LFQD_LoadState
mov	x20, x0
LFQD_Lloh0:
adr x21, LFQD_l_.str
LFQD_Lloh1:
nop
mov	x1, x21
bl	LFQD_At
mov	x19, x0
mov	x0, x21
bl Lpatch + (0xa5a4 - PATCH_BASE)
mov	x1, x0
mov	x0, x19
bl Lpatch + (0xa5d4 - PATCH_BASE)
LFQD_Lloh2:
adr x1, LFQD_l_.str.1
LFQD_Lloh3:
nop
mov	x0, x20
bl	LFQD_At
mov	x20, x0
LFQD_Lloh4:
adr x0, LFQD_l_.str.2
LFQD_Lloh5:
nop
bl Lpatch + (0xa5a4 - PATCH_BASE)
mov	x1, x0
mov	x0, x20
bl Lpatch + (0xa5d4 - PATCH_BASE)
mov	x21, x0
LFQD_Lloh6:
adr x22, LFQD_l_.str.3
LFQD_Lloh7:
nop
mov	x0, x20
mov	x1, x22
bl	LFQD_At
mov	x20, x0
LFQD_Lloh8:
adr x0, LFQD_l_.str.4
LFQD_Lloh9:
nop
bl Lpatch + (0xa5a4 - PATCH_BASE)
mov	x1, x0
mov	x0, x20
bl Lpatch + (0xa5d4 - PATCH_BASE)
mov	x20, x0
mov	x0, x21
mov	x1, x22
mov	x2, x20
bl	LFQD_Put
LFQD_Lloh10:
adr x0, LFQD_l_.str.5
LFQD_Lloh11:
nop
bl Lpatch + (0xa5a4 - PATCH_BASE)
mov	x1, x0
mov	x0, x20
bl Lpatch + (0xa5d4 - PATCH_BASE)
LFQD_Lloh12:
adr x0, LFQD_l_.str.6
LFQD_Lloh13:
nop
bl Lpatch + (0xa5a4 - PATCH_BASE)
mov	x1, x0
mov	x0, x19
bl Lpatch + (0xa5d4 - PATCH_BASE)
LFQD_Lloh14:
adr x0, LFQD_l_.str.7
LFQD_Lloh15:
nop
bl Lpatch + (0xa5a4 - PATCH_BASE)
mov	x1, x0
mov	x0, x21
ldp	x29, x30, [sp, #32]
ldp	x20, x19, [sp, #16]
ldp	x22, x21, [sp], #48
b Lpatch + (0xa5d4 - PATCH_BASE)
.cfi_endproc
.p2align	2
LFQD_LoadState:
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
LFQD_Lloh16:
adr x0, LFQD_l_.str.161
LFQD_Lloh17:
nop
bl Lpatch + (0xa5b0 - PATCH_BASE)
mov	x19, x0
LFQD_Lloh18:
adr x1, LFQD_LoadStateKey
LFQD_Lloh19:
nop
bl Lpatch + (0xa628 - PATCH_BASE)
mov	x20, x0
cbnz	x0, LFQD_LBB1_17
LFQD_Lloh20:
adr x21, LFQD_l_.str.234
LFQD_Lloh21:
nop
mov	x0, x21
bl Lpatch + (0xa5b0 - PATCH_BASE)
mov	x20, x0
LFQD_Lloh22:
adr x22, LFQD_l_.str.235
LFQD_Lloh23:
nop
mov	x0, x22
bl Lpatch + (0xa5a4 - PATCH_BASE)
mov	x1, x0
mov	x0, x20
bl Lpatch + (0xa5d4 - PATCH_BASE)
mov	x20, x0
LFQD_Lloh24:
adr x0, LFQD_l_.str.32
LFQD_Lloh25:
nop
bl Lpatch + (0xa5b0 - PATCH_BASE)
mov	x23, x0
LFQD_Lloh26:
adr x0, LFQD_l_.str.24
LFQD_Lloh27:
nop
bl Lpatch + (0xa5a4 - PATCH_BASE)
mov	x1, x0
mov	x0, x23
bl Lpatch + (0xa5d4 - PATCH_BASE)
mov	x23, x0
LFQD_Lloh28:
adr x0, LFQD_l_.str.33
LFQD_Lloh29:
nop
bl Lpatch + (0xa5a4 - PATCH_BASE)
mov	x1, x0
mov	x0, x23
bl Lpatch + (0xa5d4 - PATCH_BASE)
mov	x23, x0
LFQD_Lloh30:
adr x1, LFQD_l_.str
LFQD_Lloh31:
nop
mov	x0, x20
mov	x2, x23
bl	LFQD_Put
LFQD_Lloh32:
adr x0, LFQD_l_.str.5
LFQD_Lloh33:
nop
bl Lpatch + (0xa5a4 - PATCH_BASE)
mov	x1, x0
mov	x0, x23
bl Lpatch + (0xa5d4 - PATCH_BASE)
mov	x0, x21
bl Lpatch + (0xa5b0 - PATCH_BASE)
mov	x21, x0
mov	x0, x22
bl Lpatch + (0xa5a4 - PATCH_BASE)
mov	x1, x0
mov	x0, x21
bl Lpatch + (0xa5d4 - PATCH_BASE)
mov	x21, x0
bl LDiagnosticVersion
mov	x2, x0
LFQD_Lloh34:
adr x1, LFQD_l_.str.162
LFQD_Lloh35:
nop
mov	x0, x21
bl	LFQD_Put
bl	LFQD_UUID
mov	x2, x0
LFQD_Lloh36:
adr x1, LFQD_l_.str.163
LFQD_Lloh37:
nop
mov	x0, x21
bl	LFQD_Put
LFQD_Lloh38:
adr x0, LFQD_l_.str.209
LFQD_Lloh39:
nop
bl Lpatch + (0xa5b0 - PATCH_BASE)
mov	x22, x0
LFQD_Lloh40:
adr x0, LFQD_l_.str.221
LFQD_Lloh41:
nop
bl Lpatch + (0xa5a4 - PATCH_BASE)
mov	x1, x0
mov	x0, x22
mov	x2, #0
bl Lpatch + (0xa5d4 - PATCH_BASE)
mov	x2, x0
LFQD_Lloh42:
adr x1, LFQD_l_.str.8
LFQD_Lloh43:
nop
mov	x0, x21
bl	LFQD_Put
bl	LFQD_LoadTime
mov	x2, x0
LFQD_Lloh44:
adr x1, LFQD_l_.str.164
LFQD_Lloh45:
nop
mov	x0, x21
bl	LFQD_Put
LFQD_Lloh46:
adr x0, LFQD_l_.str.161
LFQD_Lloh47:
nop
bl Lpatch + (0xa5b0 - PATCH_BASE)
mov	x22, x0
LFQD_Lloh48:
adr x0, LFQD_l_.str.166
LFQD_Lloh49:
nop
bl Lpatch + (0xa5a4 - PATCH_BASE)
mov	x1, x0
mov	x0, x22
bl Lpatch + (0xa5d4 - PATCH_BASE)
mov	x22, x0
LFQD_Lloh50:
adr x0, LFQD_l_.str.167
LFQD_Lloh51:
nop
bl Lpatch + (0xa5a4 - PATCH_BASE)
mov	x1, x0
mov	x0, x22
bl Lpatch + (0xa5d4 - PATCH_BASE)
mov	w1, #128
bl	LFQD_LoadMetadata
mov	x2, x0
LFQD_Lloh52:
adr x1, LFQD_l_.str.165
LFQD_Lloh53:
nop
mov	x0, x21
bl	LFQD_Put
LFQD_Lloh54:
adr x0, LFQD_l_.str.168
LFQD_Lloh55:
nop
bl Lpatch + (0xa5b0 - PATCH_BASE)
mov	x22, x0
LFQD_Lloh56:
adr x0, LFQD_l_.str.169
LFQD_Lloh57:
nop
bl Lpatch + (0xa5a4 - PATCH_BASE)
mov	x1, x0
mov	x0, x22
bl Lpatch + (0xa5d4 - PATCH_BASE)
mov	x22, x0
LFQD_Lloh58:
adr x23, LFQD_l_.str.171
LFQD_Lloh59:
nop
mov	x0, x23
bl Lpatch + (0xa5a4 - PATCH_BASE)
mov	x24, x0
LFQD_Lloh60:
adr x25, LFQD_l_.str.192
LFQD_Lloh61:
nop
mov	x0, x25
bl Lpatch + (0xa5b0 - PATCH_BASE)
mov	x26, x0
LFQD_Lloh62:
adr x27, LFQD_l_.str.215
LFQD_Lloh63:
nop
mov	x0, x27
bl Lpatch + (0xa5a4 - PATCH_BASE)
mov	x1, x0
LFQD_Lloh64:
adr x2, LFQD_l_.str.172
LFQD_Lloh65:
nop
mov	x0, x26
bl Lpatch + (0xa5d4 - PATCH_BASE)
mov	x2, x0
mov	x0, x22
mov	x1, x24
bl Lpatch + (0xa5d4 - PATCH_BASE)
mov	w1, #64
bl	LFQD_LoadMetadata
mov	x2, x0
LFQD_Lloh66:
adr x1, LFQD_l_.str.170
LFQD_Lloh67:
nop
mov	x0, x21
bl	LFQD_Put
mov	x0, x23
bl Lpatch + (0xa5a4 - PATCH_BASE)
mov	x23, x0
mov	x0, x25
bl Lpatch + (0xa5b0 - PATCH_BASE)
mov	x24, x0
mov	x0, x27
bl Lpatch + (0xa5a4 - PATCH_BASE)
mov	x1, x0
LFQD_Lloh68:
adr x2, LFQD_l_.str.174
LFQD_Lloh69:
nop
mov	x0, x24
bl Lpatch + (0xa5d4 - PATCH_BASE)
mov	x2, x0
mov	x0, x22
mov	x1, x23
bl Lpatch + (0xa5d4 - PATCH_BASE)
mov	w1, #64
bl	LFQD_LoadMetadata
mov	x2, x0
LFQD_Lloh70:
adr x1, LFQD_l_.str.173
LFQD_Lloh71:
nop
mov	x0, x21
bl	LFQD_Put
LFQD_Lloh72:
adr x0, LFQD_l_.str.175
LFQD_Lloh73:
nop
bl Lpatch + (0xa5b0 - PATCH_BASE)
mov	x22, x0
LFQD_Lloh74:
adr x0, LFQD_l_.str.176
LFQD_Lloh75:
nop
bl Lpatch + (0xa5a4 - PATCH_BASE)
mov	x1, x0
mov	x0, x22
bl Lpatch + (0xa5d4 - PATCH_BASE)
mov	x2, x0
LFQD_Lloh76:
adr x1, LFQD_l_.str.3
LFQD_Lloh77:
nop
mov	x0, x21
bl	LFQD_Put
LFQD_Lloh78:
adr x1, LFQD_l_.str.1
LFQD_Lloh79:
nop
mov	x0, x20
mov	x2, x21
bl	LFQD_Put
LFQD_Lloh80:
adr x0, LFQD_l_.str.177
LFQD_Lloh81:
nop
bl Lpatch + (0xa5b0 - PATCH_BASE)
mov	x22, x0
LFQD_Lloh82:
adr x0, LFQD_l_.str.178
LFQD_Lloh83:
nop
bl Lpatch + (0xa5a4 - PATCH_BASE)
mov	x1, x0
mov	x0, x22
bl Lpatch + (0xa5d4 - PATCH_BASE)
mov	x22, x0
LFQD_Lloh84:
adr x0, LFQD_l_.str.179
LFQD_Lloh85:
nop
bl Lpatch + (0xa5a4 - PATCH_BASE)
mov	x1, x0
mov	x0, x22
mov	w2, #9
mov	w3, #1
bl Lpatch + (0xa5d4 - PATCH_BASE)
mov	x22, x0
LFQD_Lloh86:
adr x0, LFQD_l_.str.180
LFQD_Lloh87:
nop
bl Lpatch + (0xa5a4 - PATCH_BASE)
mov	x1, x0
mov	x0, x22
bl Lpatch + (0xa5d4 - PATCH_BASE)
cbz	x0, LFQD_LBB1_8
mov	x22, x0
LFQD_Lloh88:
adr x23, LFQD_l_.str.181
LFQD_Lloh89:
nop
mov	x0, x23
bl Lpatch + (0xa5a4 - PATCH_BASE)
mov	x24, x0
mov	x0, x25
bl Lpatch + (0xa5b0 - PATCH_BASE)
mov	x26, x0
mov	x0, x27
bl Lpatch + (0xa5a4 - PATCH_BASE)
mov	x1, x0
LFQD_Lloh90:
adr x2, LFQD_l_.str.18
LFQD_Lloh91:
nop
mov	x0, x26
bl Lpatch + (0xa5d4 - PATCH_BASE)
mov	x2, x0
mov	x0, x22
mov	x1, x24
bl Lpatch + (0xa5d4 - PATCH_BASE)
mov	x24, x0
mov	x0, x23
bl Lpatch + (0xa5a4 - PATCH_BASE)
mov	x22, x0
mov	x0, x25
bl Lpatch + (0xa5b0 - PATCH_BASE)
mov	x23, x0
mov	x0, x27
bl Lpatch + (0xa5a4 - PATCH_BASE)
mov	x1, x0
LFQD_Lloh92:
adr x2, LFQD_l_.str.182
LFQD_Lloh93:
nop
mov	x0, x23
bl Lpatch + (0xa5d4 - PATCH_BASE)
mov	x2, x0
mov	x0, x24
mov	x1, x22
bl Lpatch + (0xa5d4 - PATCH_BASE)
mov	x22, x0
LFQD_Lloh94:
adr x1, LFQD_l_.str.183
LFQD_Lloh95:
nop
mov	x0, x20
mov	x2, x24
bl	LFQD_Put
LFQD_Lloh96:
adr x1, LFQD_l_.str.184
LFQD_Lloh97:
nop
mov	x0, x20
mov	x2, x22
bl	LFQD_Put
LFQD_Lloh98:
adr x0, LFQD_l_.str.177
LFQD_Lloh99:
nop
bl Lpatch + (0xa5b0 - PATCH_BASE)
mov	x23, x0
LFQD_Lloh100:
adr x0, LFQD_l_.str.178
LFQD_Lloh101:
nop
bl Lpatch + (0xa5a4 - PATCH_BASE)
mov	x1, x0
mov	x0, x23
bl Lpatch + (0xa5d4 - PATCH_BASE)
mov	x23, x0
LFQD_Lloh102:
adr x0, LFQD_l_.str.195
LFQD_Lloh103:
nop
bl Lpatch + (0xa5a4 - PATCH_BASE)
mov	x1, x0
mov	x0, x22
bl Lpatch + (0xa5d4 - PATCH_BASE)
mov	x24, x0
LFQD_Lloh104:
adr x0, LFQD_l_.str.196
LFQD_Lloh105:
nop
bl Lpatch + (0xa5a4 - PATCH_BASE)
mov	x1, x0
mov	x0, x23
mov	x2, x24
bl Lpatch + (0xa5d4 - PATCH_BASE)
cbz	w0, LFQD_LBB1_9
str	xzr, [sp, #8]
LFQD_Lloh106:
adr x0, LFQD_l_.str.198
LFQD_Lloh107:
nop
bl Lpatch + (0xa5a4 - PATCH_BASE)
mov	x1, x0
add	x3, sp, #8
mov	x0, x23
mov	x2, x24
bl Lpatch + (0xa5d4 - PATCH_BASE)
cbz	x0, LFQD_LBB1_11
LFQD_Lloh108:
adr x1, LFQD_l_.str.199
LFQD_Lloh109:
nop
bl	LFQD_At
mov	x23, x0
LFQD_Lloh110:
adr x0, LFQD_l_.str.200
LFQD_Lloh111:
nop
bl Lpatch + (0xa5a4 - PATCH_BASE)
mov	x1, x0
mov	x0, x23
bl Lpatch + (0xa5d4 - PATCH_BASE)
cmp	x0, #8, lsl #12
b.gt	LFQD_LBB1_7
LFQD_Lloh112:
adr x0, LFQD_l_.str.203
LFQD_Lloh113:
nop
bl Lpatch + (0xa5b0 - PATCH_BASE)
mov	x23, x0
LFQD_Lloh114:
adr x0, LFQD_l_.str.204
LFQD_Lloh115:
nop
bl Lpatch + (0xa5a4 - PATCH_BASE)
mov	x1, x0
add	x4, sp, #8
mov	x0, x23
mov	x2, x22
mov	w3, #1
bl Lpatch + (0xa5d4 - PATCH_BASE)
cbz	x0, LFQD_LBB1_12
mov	x22, x0
LFQD_Lloh116:
adr x0, LFQD_l_.str.193
LFQD_Lloh117:
nop
bl Lpatch + (0xa5a4 - PATCH_BASE)
mov	x1, x0
mov	x0, x22
bl Lpatch + (0xa5d4 - PATCH_BASE)
cmp	x0, #8, lsl #12
b.le	LFQD_LBB1_18
LFQD_LBB1_7:
LFQD_Lloh118:
adr x22, LFQD_l_.str.201
LFQD_Lloh119:
nop
b	LFQD_LBB1_13
LFQD_LBB1_8:
LFQD_Lloh120:
adr x22, LFQD_l_.str.192
LFQD_Lloh121:
nop
mov	x0, x22
bl Lpatch + (0xa5b0 - PATCH_BASE)
mov	x23, x0
LFQD_Lloh122:
adr x24, LFQD_l_.str.215
LFQD_Lloh123:
nop
mov	x0, x24
bl Lpatch + (0xa5a4 - PATCH_BASE)
mov	x1, x0
LFQD_Lloh124:
adr x25, LFQD_l_.str.186
LFQD_Lloh125:
nop
mov	x0, x23
mov	x2, x25
bl Lpatch + (0xa5d4 - PATCH_BASE)
mov	x2, x0
LFQD_Lloh126:
adr x1, LFQD_l_.str.185
LFQD_Lloh127:
nop
mov	x0, x21
bl	LFQD_Put
LFQD_Lloh128:
adr x0, LFQD_l_.str.209
LFQD_Lloh129:
nop
bl Lpatch + (0xa5b0 - PATCH_BASE)
mov	x23, x0
LFQD_Lloh130:
adr x0, LFQD_l_.str.221
LFQD_Lloh131:
nop
bl Lpatch + (0xa5a4 - PATCH_BASE)
mov	x1, x0
mov	x0, x23
mov	w2, #1
bl Lpatch + (0xa5d4 - PATCH_BASE)
mov	x2, x0
LFQD_Lloh132:
adr x1, LFQD_l_.str.187
LFQD_Lloh133:
nop
mov	x0, x21
bl	LFQD_Put
mov	x0, x22
bl Lpatch + (0xa5b0 - PATCH_BASE)
mov	x22, x0
mov	x0, x24
bl Lpatch + (0xa5a4 - PATCH_BASE)
mov	x1, x0
mov	x0, x22
mov	x2, x25
bl Lpatch + (0xa5d4 - PATCH_BASE)
mov	x2, x0
LFQD_Lloh134:
adr x1, LFQD_l_.str.188
LFQD_Lloh135:
nop
b	LFQD_LBB1_16
LFQD_LBB1_9:
LFQD_Lloh136:
adr x0, LFQD_l_.str.192
LFQD_Lloh137:
nop
bl Lpatch + (0xa5b0 - PATCH_BASE)
mov	x22, x0
LFQD_Lloh138:
adr x0, LFQD_l_.str.215
LFQD_Lloh139:
nop
bl Lpatch + (0xa5a4 - PATCH_BASE)
mov	x1, x0
LFQD_Lloh140:
adr x2, LFQD_l_.str.197
LFQD_Lloh141:
nop
LFQD_LBB1_10:
mov	x0, x22
b	LFQD_LBB1_14
LFQD_LBB1_11:
LFQD_Lloh142:
adr x22, LFQD_l_.str.202
LFQD_Lloh143:
nop
b	LFQD_LBB1_13
LFQD_LBB1_12:
LFQD_Lloh144:
adr x22, LFQD_l_.str.205
LFQD_Lloh145:
nop
LFQD_LBB1_13:
LFQD_Lloh146:
adr x0, LFQD_l_.str.192
LFQD_Lloh147:
nop
bl Lpatch + (0xa5b0 - PATCH_BASE)
mov	x23, x0
LFQD_Lloh148:
adr x0, LFQD_l_.str.215
LFQD_Lloh149:
nop
bl Lpatch + (0xa5a4 - PATCH_BASE)
mov	x1, x0
mov	x0, x23
mov	x2, x22
LFQD_LBB1_14:
bl Lpatch + (0xa5d4 - PATCH_BASE)
LFQD_LBB1_15:
mov	x2, x0
LFQD_Lloh150:
adr x1, LFQD_l_.str.185
LFQD_Lloh151:
nop
LFQD_LBB1_16:
mov	x0, x21
bl	LFQD_Put
LFQD_Lloh152:
adr x1, LFQD_LoadStateKey
LFQD_Lloh153:
nop
mov	x0, x19
mov	x2, x20
mov	w3, #769
bl Lpatch + (0xa634 - PATCH_BASE)
LFQD_LBB1_17:
mov	x0, x20
ldp	x29, x30, [sp, #96]
ldp	x20, x19, [sp, #80]
ldp	x22, x21, [sp, #64]
ldp	x24, x23, [sp, #48]
ldp	x26, x25, [sp, #32]
ldp	x28, x27, [sp, #16]
add	sp, sp, #112
ret
LFQD_LBB1_18:
LFQD_Lloh154:
adr x0, LFQD_l_.str.206
LFQD_Lloh155:
nop
bl Lpatch + (0xa5b0 - PATCH_BASE)
mov	x23, x0
LFQD_Lloh156:
adr x0, LFQD_l_.str.207
LFQD_Lloh157:
nop
bl Lpatch + (0xa5a4 - PATCH_BASE)
mov	x1, x0
add	x4, sp, #8
mov	x0, x23
mov	x2, x22
mov	x3, #0
bl Lpatch + (0xa5d4 - PATCH_BASE)
mov	x22, x0
LFQD_Lloh158:
adr x1, LFQD_l_.str.208
LFQD_Lloh159:
nop
bl	LFQD_Kind
cbz	w0, LFQD_LBB1_25
LFQD_Lloh160:
adr x1, LFQD_l_.str.162
LFQD_Lloh161:
nop
mov	x0, x22
bl	LFQD_At
LFQD_Lloh162:
adr x1, LFQD_l_.str.192
LFQD_Lloh163:
nop
bl	LFQD_Kind
cbz	w0, LFQD_LBB1_25
LFQD_Lloh164:
adr x1, LFQD_l_.str.162
LFQD_Lloh165:
nop
mov	x0, x22
bl	LFQD_At
mov	x23, x0
LFQD_Lloh166:
adr x0, LFQD_l_.str.10
LFQD_Lloh167:
nop
bl Lpatch + (0xa5a4 - PATCH_BASE)
mov	x24, x0
bl LDiagnosticVersion
mov	x2, x0
mov	x0, x23
mov	x1, x24
bl Lpatch + (0xa5d4 - PATCH_BASE)
cbz	w0, LFQD_LBB1_25
LFQD_Lloh168:
adr x1, LFQD_l_.str.11
LFQD_Lloh169:
nop
mov	x0, x22
bl	LFQD_At
bl	LFQD_LoadStageKnown
cbz	w0, LFQD_LBB1_25
LFQD_Lloh170:
adr x1, LFQD_l_.str.8
LFQD_Lloh171:
nop
mov	x0, x22
bl	LFQD_At
LFQD_Lloh172:
adr x1, LFQD_l_.str.209
LFQD_Lloh173:
nop
bl	LFQD_Kind
cbz	w0, LFQD_LBB1_25
LFQD_Lloh174:
adr x1, LFQD_l_.str.14
LFQD_Lloh175:
nop
mov	x0, x22
bl	LFQD_At
LFQD_Lloh176:
adr x1, LFQD_l_.str.209
LFQD_Lloh177:
nop
bl	LFQD_Kind
tbz	w0, #0, LFQD_LBB1_25
bl	LFQD_Dict
mov	x23, x0
LFQD_Lloh178:
adr x24, LFQD_l_.str.11
LFQD_Lloh179:
nop
mov	x0, x22
mov	x1, x24
bl	LFQD_At
mov	x2, x0
mov	x0, x23
mov	x1, x24
bl	LFQD_Put
LFQD_Lloh180:
adr x24, LFQD_l_.str.8
LFQD_Lloh181:
nop
mov	x0, x22
mov	x1, x24
bl	LFQD_At
mov	x25, x0
LFQD_Lloh182:
adr x0, LFQD_l_.str.9
LFQD_Lloh183:
nop
bl Lpatch + (0xa5a4 - PATCH_BASE)
mov	x1, x0
mov	x0, x25
bl Lpatch + (0xa5d4 - PATCH_BASE)
sxtw	x0, w0
bl	LFQD_Num
mov	x2, x0
mov	x0, x23
mov	x1, x24
bl	LFQD_Put
LFQD_Lloh184:
adr x24, LFQD_l_.str.14
LFQD_Lloh185:
nop
mov	x0, x22
mov	x1, x24
bl	LFQD_At
mov	x2, x0
mov	x0, x23
mov	x1, x24
bl	LFQD_Put
bl LDiagnosticVersion
mov	x2, x0
LFQD_Lloh186:
adr x1, LFQD_l_.str.162
LFQD_Lloh187:
nop
mov	x0, x23
bl	LFQD_Put
LFQD_Lloh188:
adr x1, LFQD_l_.str.211
LFQD_Lloh189:
nop
mov	x0, x21
mov	x2, x23
bl	LFQD_Put
LFQD_Lloh190:
adr x0, LFQD_l_.str.212
LFQD_Lloh191:
nop
bl	LFQD_Text
b	LFQD_LBB1_15
LFQD_LBB1_25:
LFQD_Lloh192:
adr x0, LFQD_l_.str.192
LFQD_Lloh193:
nop
bl Lpatch + (0xa5b0 - PATCH_BASE)
mov	x22, x0
LFQD_Lloh194:
adr x0, LFQD_l_.str.215
LFQD_Lloh195:
nop
bl Lpatch + (0xa5a4 - PATCH_BASE)
mov	x1, x0
LFQD_Lloh196:
adr x2, LFQD_l_.str.210
LFQD_Lloh197:
nop
b	LFQD_LBB1_10
.cfi_endproc
.p2align	2
LFQD_At:
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
LFQD_Lloh198:
adr x0, LFQD_l_.str.142
LFQD_Lloh199:
nop
bl Lpatch + (0xa5a4 - PATCH_BASE)
mov	x21, x0
LFQD_Lloh200:
adr x0, LFQD_l_.str.192
LFQD_Lloh201:
nop
bl Lpatch + (0xa5b0 - PATCH_BASE)
mov	x22, x0
LFQD_Lloh202:
adr x0, LFQD_l_.str.215
LFQD_Lloh203:
nop
bl Lpatch + (0xa5a4 - PATCH_BASE)
mov	x1, x0
mov	x0, x22
mov	x2, x19
bl Lpatch + (0xa5d4 - PATCH_BASE)
mov	x2, x0
mov	x0, x20
mov	x1, x21
ldp	x29, x30, [sp, #32]
ldp	x20, x19, [sp, #16]
ldp	x22, x21, [sp], #48
b Lpatch + (0xa5d4 - PATCH_BASE)
.cfi_endproc
.p2align	2
LFQD_Put:
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
cbnz	x2, LFQD_LBB3_2
LFQD_Lloh204:
adr x0, LFQD_l_.str.213
LFQD_Lloh205:
nop
bl Lpatch + (0xa5b0 - PATCH_BASE)
mov	x21, x0
LFQD_Lloh206:
adr x0, LFQD_l_.str.214
LFQD_Lloh207:
nop
bl Lpatch + (0xa5a4 - PATCH_BASE)
mov	x1, x0
mov	x0, x21
bl Lpatch + (0xa5d4 - PATCH_BASE)
mov	x21, x0
LFQD_LBB3_2:
LFQD_Lloh208:
adr x0, LFQD_l_.str.144
LFQD_Lloh209:
nop
bl Lpatch + (0xa5a4 - PATCH_BASE)
mov	x22, x0
LFQD_Lloh210:
adr x0, LFQD_l_.str.192
LFQD_Lloh211:
nop
bl Lpatch + (0xa5b0 - PATCH_BASE)
mov	x23, x0
LFQD_Lloh212:
adr x0, LFQD_l_.str.215
LFQD_Lloh213:
nop
bl Lpatch + (0xa5a4 - PATCH_BASE)
mov	x1, x0
mov	x0, x23
mov	x2, x20
bl Lpatch + (0xa5d4 - PATCH_BASE)
mov	x3, x0
mov	x0, x19
mov	x1, x22
mov	x2, x21
ldp	x29, x30, [sp, #48]
ldp	x20, x19, [sp, #32]
ldp	x22, x21, [sp, #16]
ldp	x24, x23, [sp], #64
b Lpatch + (0xa5d4 - PATCH_BASE)
.cfi_endproc
.p2align	2
LFQD_FQDLoadStage:
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
LFQD_Lloh214:
adr x0, LFQD_l_.str.192
LFQD_Lloh215:
nop
bl Lpatch + (0xa5b0 - PATCH_BASE)
mov	x20, x0
LFQD_Lloh216:
adr x0, LFQD_l_.str.215
LFQD_Lloh217:
nop
bl Lpatch + (0xa5a4 - PATCH_BASE)
mov	x1, x0
mov	x0, x20
mov	x2, x19
bl Lpatch + (0xa5d4 - PATCH_BASE)
mov	x22, x0
bl	LFQD_LoadStageKnown
cbz	w0, LFQD_LBB4_9
bl	LFQD_LoadState
mov	x20, x0
LFQD_Lloh218:
adr x21, LFQD_l_.str
LFQD_Lloh219:
nop
mov	x1, x21
bl	LFQD_At
mov	x19, x0
mov	x0, x21
bl Lpatch + (0xa5a4 - PATCH_BASE)
mov	x1, x0
mov	x0, x19
bl Lpatch + (0xa5d4 - PATCH_BASE)
LFQD_Lloh220:
adr x1, LFQD_l_.str.1
LFQD_Lloh221:
nop
mov	x0, x20
bl	LFQD_At
mov	x21, x0
LFQD_Lloh222:
adr x1, LFQD_l_.str.3
LFQD_Lloh223:
nop
bl	LFQD_At
mov	x23, x0
LFQD_Lloh224:
adr x1, LFQD_l_.str.8
LFQD_Lloh225:
nop
mov	x0, x21
bl	LFQD_At
mov	x24, x0
LFQD_Lloh226:
adr x0, LFQD_l_.str.9
LFQD_Lloh227:
nop
bl Lpatch + (0xa5a4 - PATCH_BASE)
mov	x1, x0
mov	x0, x24
bl Lpatch + (0xa5d4 - PATCH_BASE)
cbnz	w0, LFQD_LBB4_3
LFQD_Lloh228:
adr x0, LFQD_l_.str.10
LFQD_Lloh229:
nop
bl Lpatch + (0xa5a4 - PATCH_BASE)
mov	x24, x0
LFQD_Lloh230:
adr x1, LFQD_l_.str.11
LFQD_Lloh231:
nop
mov	x0, x21
bl	LFQD_At
mov	x2, x0
mov	x0, x22
mov	x1, x24
bl Lpatch + (0xa5d4 - PATCH_BASE)
cbz	w0, LFQD_LBB4_4
LFQD_LBB4_3:
LFQD_Lloh232:
adr x0, LFQD_l_.str.6
LFQD_Lloh233:
nop
bl Lpatch + (0xa5a4 - PATCH_BASE)
mov	x1, x0
mov	x0, x19
ldp	x29, x30, [sp, #80]
ldp	x20, x19, [sp, #64]
ldp	x22, x21, [sp, #48]
ldp	x24, x23, [sp, #32]
ldp	x26, x25, [sp, #16]
ldp	x28, x27, [sp], #96
b Lpatch + (0xa5d4 - PATCH_BASE)
LFQD_LBB4_4:
LFQD_Lloh234:
adr x0, LFQD_l_.str.12
LFQD_Lloh235:
nop
bl Lpatch + (0xa5a4 - PATCH_BASE)
mov	x1, x0
mov	x0, x23
bl Lpatch + (0xa5d4 - PATCH_BASE)
cmp	x0, #24
b.lt	LFQD_LBB4_7
LFQD_Lloh236:
adr x1, LFQD_l_.str.13
LFQD_Lloh237:
nop
mov	x0, x21
bl	LFQD_At
mov	x22, x0
LFQD_Lloh238:
adr x0, LFQD_l_.str.9
LFQD_Lloh239:
nop
bl Lpatch + (0xa5a4 - PATCH_BASE)
mov	x1, x0
mov	x0, x22
bl Lpatch + (0xa5d4 - PATCH_BASE)
cbnz	w0, LFQD_LBB4_3
mov	w0, #1
bl	LFQD_Num
mov	x2, x0
LFQD_Lloh240:
adr x1, LFQD_l_.str.13
LFQD_Lloh241:
nop
mov	x0, x21
bl	LFQD_Put
mov	x0, x20
bl	LFQD_LoadPersist
b	LFQD_LBB4_3
LFQD_LBB4_7:
bl	LFQD_LoadTime
mov	x24, x0
LFQD_Lloh242:
adr x0, LFQD_l_.str.234
LFQD_Lloh243:
nop
bl Lpatch + (0xa5b0 - PATCH_BASE)
mov	x25, x0
LFQD_Lloh244:
adr x0, LFQD_l_.str.235
LFQD_Lloh245:
nop
bl Lpatch + (0xa5a4 - PATCH_BASE)
mov	x1, x0
mov	x0, x25
bl Lpatch + (0xa5d4 - PATCH_BASE)
mov	x25, x0
LFQD_Lloh246:
adr x26, LFQD_l_.str.11
LFQD_Lloh247:
nop
mov	x1, x26
mov	x2, x22
bl	LFQD_Put
LFQD_Lloh248:
adr x27, LFQD_l_.str.14
LFQD_Lloh249:
nop
mov	x0, x25
mov	x1, x27
mov	x2, x24
bl	LFQD_Put
LFQD_Lloh250:
adr x0, LFQD_l_.str.15
LFQD_Lloh251:
nop
bl Lpatch + (0xa5a4 - PATCH_BASE)
mov	x1, x0
mov	x0, x23
mov	x2, x25
bl Lpatch + (0xa5d4 - PATCH_BASE)
mov	x0, x21
mov	x1, x26
mov	x2, x22
bl	LFQD_Put
mov	x0, x21
mov	x1, x27
mov	x2, x24
bl	LFQD_Put
LFQD_Lloh252:
adr x0, LFQD_l_.str.10
LFQD_Lloh253:
nop
bl Lpatch + (0xa5a4 - PATCH_BASE)
mov	x23, x0
LFQD_Lloh254:
adr x0, LFQD_l_.str.192
LFQD_Lloh255:
nop
bl Lpatch + (0xa5b0 - PATCH_BASE)
mov	x24, x0
LFQD_Lloh256:
adr x0, LFQD_l_.str.215
LFQD_Lloh257:
nop
bl Lpatch + (0xa5a4 - PATCH_BASE)
mov	x1, x0
LFQD_Lloh258:
adr x2, LFQD_l_.str.16
LFQD_Lloh259:
nop
mov	x0, x24
bl Lpatch + (0xa5d4 - PATCH_BASE)
mov	x2, x0
mov	x0, x22
mov	x1, x23
bl Lpatch + (0xa5d4 - PATCH_BASE)
mov	x22, x0
sxtw	x23, w22
LFQD_Lloh260:
adr x0, LFQD_l_.str.209
LFQD_Lloh261:
nop
bl Lpatch + (0xa5b0 - PATCH_BASE)
mov	x24, x0
LFQD_Lloh262:
adr x0, LFQD_l_.str.221
LFQD_Lloh263:
nop
bl Lpatch + (0xa5a4 - PATCH_BASE)
mov	x1, x0
mov	x0, x24
mov	x2, x23
bl Lpatch + (0xa5d4 - PATCH_BASE)
mov	x2, x0
LFQD_Lloh264:
adr x1, LFQD_l_.str.8
LFQD_Lloh265:
nop
mov	x0, x21
bl	LFQD_Put
mov	x0, x20
bl	LFQD_LoadPersist
LFQD_Lloh266:
adr x0, LFQD_l_.str.6
LFQD_Lloh267:
nop
bl Lpatch + (0xa5a4 - PATCH_BASE)
mov	x1, x0
mov	x0, x19
bl Lpatch + (0xa5d4 - PATCH_BASE)
cbz	w22, LFQD_LBB4_9
bl	LFQD_FQDLoadSummary
LFQD_Lloh268:
adr x8, LFQD_l_.str.17
LFQD_Lloh269:
nop
LFQD_Lloh270:
adr x1, LFQD_l_.str.18
LFQD_Lloh271:
nop
mov	x4, x0
mov	x0, x8
mov	x2, #0
mov	x3, #0
ldp	x29, x30, [sp, #80]
ldp	x20, x19, [sp, #64]
ldp	x22, x21, [sp, #48]
ldp	x24, x23, [sp, #32]
ldp	x26, x25, [sp, #16]
ldp	x28, x27, [sp], #96
b	LFQD_Emit
LFQD_LBB4_9:
ldp	x29, x30, [sp, #80]
ldp	x20, x19, [sp, #64]
ldp	x22, x21, [sp, #48]
ldp	x24, x23, [sp, #32]
ldp	x26, x25, [sp, #16]
ldp	x28, x27, [sp], #96
ret
.cfi_endproc
.p2align	2
LFQD_Text:
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
LFQD_Lloh272:
adr x0, LFQD_l_.str.192
LFQD_Lloh273:
nop
bl Lpatch + (0xa5b0 - PATCH_BASE)
mov	x20, x0
LFQD_Lloh274:
adr x0, LFQD_l_.str.215
LFQD_Lloh275:
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
LFQD_LoadStageKnown:
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
LFQD_Lloh276:
adr x1, LFQD_l_.str.192
LFQD_Lloh277:
nop
bl	LFQD_Kind
cbz	w0, LFQD_LBB6_9
LFQD_Lloh278:
adr x0, LFQD_l_.str.10
LFQD_Lloh279:
nop
bl Lpatch + (0xa5a4 - PATCH_BASE)
mov	x20, x0
LFQD_Lloh280:
adr x0, LFQD_l_.str.192
LFQD_Lloh281:
nop
bl Lpatch + (0xa5b0 - PATCH_BASE)
mov	x21, x0
LFQD_Lloh282:
adr x0, LFQD_l_.str.215
LFQD_Lloh283:
nop
bl Lpatch + (0xa5a4 - PATCH_BASE)
mov	x1, x0
LFQD_Lloh284:
adr x2, LFQD_l_.str.216
LFQD_Lloh285:
nop
mov	x0, x21
bl Lpatch + (0xa5d4 - PATCH_BASE)
mov	x2, x0
mov	x0, x19
mov	x1, x20
bl Lpatch + (0xa5d4 - PATCH_BASE)
cbnz	w0, LFQD_LBB6_8
LFQD_Lloh286:
adr x0, LFQD_l_.str.10
LFQD_Lloh287:
nop
bl Lpatch + (0xa5a4 - PATCH_BASE)
mov	x20, x0
LFQD_Lloh288:
adr x0, LFQD_l_.str.192
LFQD_Lloh289:
nop
bl Lpatch + (0xa5b0 - PATCH_BASE)
mov	x21, x0
LFQD_Lloh290:
adr x0, LFQD_l_.str.215
LFQD_Lloh291:
nop
bl Lpatch + (0xa5a4 - PATCH_BASE)
mov	x1, x0
LFQD_Lloh292:
adr x2, LFQD_l_.str.31
LFQD_Lloh293:
nop
mov	x0, x21
bl Lpatch + (0xa5d4 - PATCH_BASE)
mov	x2, x0
mov	x0, x19
mov	x1, x20
bl Lpatch + (0xa5d4 - PATCH_BASE)
cbnz	w0, LFQD_LBB6_8
LFQD_Lloh294:
adr x0, LFQD_l_.str.10
LFQD_Lloh295:
nop
bl Lpatch + (0xa5a4 - PATCH_BASE)
mov	x20, x0
LFQD_Lloh296:
adr x0, LFQD_l_.str.192
LFQD_Lloh297:
nop
bl Lpatch + (0xa5b0 - PATCH_BASE)
mov	x21, x0
LFQD_Lloh298:
adr x0, LFQD_l_.str.215
LFQD_Lloh299:
nop
bl Lpatch + (0xa5a4 - PATCH_BASE)
mov	x1, x0
LFQD_Lloh300:
adr x2, LFQD_l_.str.141
LFQD_Lloh301:
nop
mov	x0, x21
bl Lpatch + (0xa5d4 - PATCH_BASE)
mov	x2, x0
mov	x0, x19
mov	x1, x20
bl Lpatch + (0xa5d4 - PATCH_BASE)
cbnz	w0, LFQD_LBB6_8
LFQD_Lloh302:
adr x0, LFQD_l_.str.10
LFQD_Lloh303:
nop
bl Lpatch + (0xa5a4 - PATCH_BASE)
mov	x20, x0
LFQD_Lloh304:
adr x0, LFQD_l_.str.192
LFQD_Lloh305:
nop
bl Lpatch + (0xa5b0 - PATCH_BASE)
mov	x21, x0
LFQD_Lloh306:
adr x0, LFQD_l_.str.215
LFQD_Lloh307:
nop
bl Lpatch + (0xa5a4 - PATCH_BASE)
mov	x1, x0
LFQD_Lloh308:
adr x2, LFQD_l_.str.217
LFQD_Lloh309:
nop
mov	x0, x21
bl Lpatch + (0xa5d4 - PATCH_BASE)
mov	x2, x0
mov	x0, x19
mov	x1, x20
bl Lpatch + (0xa5d4 - PATCH_BASE)
cbnz	w0, LFQD_LBB6_8
LFQD_Lloh310:
adr x0, LFQD_l_.str.10
LFQD_Lloh311:
nop
bl Lpatch + (0xa5a4 - PATCH_BASE)
mov	x20, x0
LFQD_Lloh312:
adr x0, LFQD_l_.str.218
LFQD_Lloh313:
nop
bl	LFQD_Text
mov	x2, x0
mov	x0, x19
mov	x1, x20
bl Lpatch + (0xa5d4 - PATCH_BASE)
cbnz	w0, LFQD_LBB6_8
LFQD_Lloh314:
adr x0, LFQD_l_.str.10
LFQD_Lloh315:
nop
bl Lpatch + (0xa5a4 - PATCH_BASE)
mov	x20, x0
LFQD_Lloh316:
adr x0, LFQD_l_.str.16
LFQD_Lloh317:
nop
bl	LFQD_Text
mov	x2, x0
mov	x0, x19
mov	x1, x20
bl Lpatch + (0xa5d4 - PATCH_BASE)
cbnz	w0, LFQD_LBB6_8
LFQD_Lloh318:
adr x0, LFQD_l_.str.10
LFQD_Lloh319:
nop
bl Lpatch + (0xa5a4 - PATCH_BASE)
mov	x20, x0
LFQD_Lloh320:
adr x0, LFQD_l_.str.219
LFQD_Lloh321:
nop
bl	LFQD_Text
mov	x2, x0
mov	x0, x19
mov	x1, x20
bl Lpatch + (0xa5d4 - PATCH_BASE)
cbz	w0, LFQD_LBB6_10
LFQD_LBB6_8:
mov	w0, #1
LFQD_LBB6_9:
ldp	x29, x30, [sp, #32]
ldp	x20, x19, [sp, #16]
ldp	x22, x21, [sp], #48
ret
LFQD_LBB6_10:
LFQD_Lloh322:
adr x0, LFQD_l_.str.10
LFQD_Lloh323:
nop
bl Lpatch + (0xa5a4 - PATCH_BASE)
mov	x20, x0
LFQD_Lloh324:
adr x0, LFQD_l_.str.220
LFQD_Lloh325:
nop
bl	LFQD_Text
mov	x2, x0
mov	x0, x19
mov	x1, x20
bl Lpatch + (0xa5d4 - PATCH_BASE)
cmp	w0, #0
cset	w0, ne
b	LFQD_LBB6_9
.cfi_endproc
.p2align	2
LFQD_Num:
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
LFQD_Lloh326:
adr x0, LFQD_l_.str.209
LFQD_Lloh327:
nop
bl Lpatch + (0xa5b0 - PATCH_BASE)
mov	x20, x0
LFQD_Lloh328:
adr x0, LFQD_l_.str.221
LFQD_Lloh329:
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
LFQD_LoadPersist:
.cfi_startproc
sub	sp, sp, #80
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
mov	x21, x0
LFQD_Lloh330:
adr x1, LFQD_l_.str.1
LFQD_Lloh331:
nop
bl	LFQD_At
mov	x19, x0
LFQD_Lloh332:
adr x1, LFQD_l_.str.184
LFQD_Lloh333:
nop
mov	x0, x21
bl	LFQD_At
cbz	x0, LFQD_LBB8_12
mov	x20, x0
str	xzr, [sp, #8]
LFQD_Lloh334:
adr x1, LFQD_l_.str.222
LFQD_Lloh335:
nop
mov	x0, x21
bl	LFQD_At
mov	x22, x0
LFQD_Lloh336:
adr x0, LFQD_l_.str.9
LFQD_Lloh337:
nop
bl Lpatch + (0xa5a4 - PATCH_BASE)
mov	x1, x0
mov	x0, x22
bl Lpatch + (0xa5d4 - PATCH_BASE)
cbnz	w0, LFQD_LBB8_4
LFQD_Lloh338:
adr x0, LFQD_l_.str.177
LFQD_Lloh339:
nop
bl Lpatch + (0xa5b0 - PATCH_BASE)
mov	x22, x0
LFQD_Lloh340:
adr x0, LFQD_l_.str.178
LFQD_Lloh341:
nop
bl Lpatch + (0xa5a4 - PATCH_BASE)
mov	x1, x0
mov	x0, x22
bl Lpatch + (0xa5d4 - PATCH_BASE)
mov	x22, x0
LFQD_Lloh342:
adr x0, LFQD_l_.str.223
LFQD_Lloh343:
nop
bl Lpatch + (0xa5a4 - PATCH_BASE)
mov	x23, x0
LFQD_Lloh344:
adr x1, LFQD_l_.str.183
LFQD_Lloh345:
nop
mov	x0, x21
bl	LFQD_At
mov	x2, x0
add	x5, sp, #8
mov	x0, x22
mov	x1, x23
mov	w3, #1
mov	x4, #0
bl Lpatch + (0xa5d4 - PATCH_BASE)
cbz	w0, LFQD_LBB8_10
LFQD_Lloh346:
adr x0, LFQD_l_.str.209
LFQD_Lloh347:
nop
bl Lpatch + (0xa5b0 - PATCH_BASE)
mov	x22, x0
LFQD_Lloh348:
adr x0, LFQD_l_.str.221
LFQD_Lloh349:
nop
bl Lpatch + (0xa5a4 - PATCH_BASE)
mov	x1, x0
mov	x0, x22
mov	w2, #1
bl Lpatch + (0xa5d4 - PATCH_BASE)
mov	x2, x0
LFQD_Lloh350:
adr x1, LFQD_l_.str.222
LFQD_Lloh351:
nop
mov	x0, x21
bl	LFQD_Put
LFQD_LBB8_4:
LFQD_Lloh352:
adr x0, LFQD_l_.str.206
LFQD_Lloh353:
nop
bl Lpatch + (0xa5b0 - PATCH_BASE)
mov	x21, x0
LFQD_Lloh354:
adr x0, LFQD_l_.str.225
LFQD_Lloh355:
nop
bl Lpatch + (0xa5a4 - PATCH_BASE)
mov	x1, x0
add	x4, sp, #8
mov	x0, x21
mov	x2, x19
mov	x3, #0
bl Lpatch + (0xa5d4 - PATCH_BASE)
cbz	x0, LFQD_LBB8_7
mov	x21, x0
LFQD_Lloh356:
adr x0, LFQD_l_.str.193
LFQD_Lloh357:
nop
bl Lpatch + (0xa5a4 - PATCH_BASE)
mov	x1, x0
mov	x0, x21
bl Lpatch + (0xa5d4 - PATCH_BASE)
cmp	x0, #8, lsl #12
b.le	LFQD_LBB8_8
LFQD_Lloh358:
adr x1, LFQD_l_.str.201
LFQD_Lloh359:
nop
b	LFQD_LBB8_11
LFQD_LBB8_7:
LFQD_Lloh360:
adr x1, LFQD_l_.str.226
LFQD_Lloh361:
nop
b	LFQD_LBB8_11
LFQD_LBB8_8:
LFQD_Lloh362:
adr x0, LFQD_l_.str.227
LFQD_Lloh363:
nop
bl Lpatch + (0xa5a4 - PATCH_BASE)
mov	x1, x0
add	x4, sp, #8
mov	x0, x21
mov	x2, x20
mov	w3, #1
bl Lpatch + (0xa5d4 - PATCH_BASE)
cbnz	w0, LFQD_LBB8_12
LFQD_Lloh364:
adr x1, LFQD_l_.str.187
LFQD_Lloh365:
nop
b	LFQD_LBB8_11
LFQD_LBB8_10:
LFQD_Lloh366:
adr x1, LFQD_l_.str.224
LFQD_Lloh367:
nop
LFQD_LBB8_11:
ldr	x2, [sp, #8]
mov	x0, x19
bl	LFQD_LoadFailure
LFQD_LBB8_12:
ldp	x29, x30, [sp, #64]
ldp	x20, x19, [sp, #48]
ldp	x22, x21, [sp, #32]
ldp	x24, x23, [sp, #16]
add	sp, sp, #80
ret
.cfi_endproc
.p2align	2
LFQD_LoadTime:
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
LFQD_Lloh368:
adr x0, LFQD_l_.str.230
LFQD_Lloh369:
nop
bl Lpatch + (0xa5b0 - PATCH_BASE)
mov	x19, x0
LFQD_Lloh370:
adr x0, LFQD_l_.str.231
LFQD_Lloh371:
nop
bl Lpatch + (0xa5a4 - PATCH_BASE)
mov	x1, x0
mov	x0, x19
bl Lpatch + (0xa5d4 - PATCH_BASE)
mov	x19, x0
LFQD_Lloh372:
adr x0, LFQD_l_.str.232
LFQD_Lloh373:
nop
bl Lpatch + (0xa5a4 - PATCH_BASE)
mov	x1, x0
mov	x0, x19
bl Lpatch + (0xa5d4 - PATCH_BASE)
mov.16b	v8, v0
LFQD_Lloh374:
adr x0, LFQD_l_.str.209
LFQD_Lloh375:
nop
bl Lpatch + (0xa5b0 - PATCH_BASE)
mov	x19, x0
LFQD_Lloh376:
adr x0, LFQD_l_.str.233
LFQD_Lloh377:
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
LFQD_Dict:
.cfi_startproc
stp	x20, x19, [sp, #-32]!
stp	x29, x30, [sp, #16]
add	x29, sp, #16
.cfi_def_cfa w29, 16
.cfi_offset w30, -8
.cfi_offset w29, -16
.cfi_offset w19, -24
.cfi_offset w20, -32
LFQD_Lloh378:
adr x0, LFQD_l_.str.234
LFQD_Lloh379:
nop
bl Lpatch + (0xa5b0 - PATCH_BASE)
mov	x19, x0
LFQD_Lloh380:
adr x0, LFQD_l_.str.235
LFQD_Lloh381:
nop
bl Lpatch + (0xa5a4 - PATCH_BASE)
mov	x1, x0
mov	x0, x19
ldp	x29, x30, [sp, #16]
ldp	x20, x19, [sp], #32
b Lpatch + (0xa5d4 - PATCH_BASE)
.cfi_endproc
.p2align	2
LFQD_Emit:
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
mov	x20, x4
mov	x21, x3
mov	x22, x2
mov	x23, x1
str	x0, [sp, #8]
LFQD_Lloh382:
adr x0, LFQD_l_.str.2
LFQD_Lloh383:
nop
bl Lpatch + (0xa5a4 - PATCH_BASE)
mov	x1, x0
mov	x0, x20
bl Lpatch + (0xa5d4 - PATCH_BASE)
mov	x20, x0
LFQD_Lloh384:
adr x0, LFQD_l_.str.192
LFQD_Lloh385:
nop
bl Lpatch + (0xa5b0 - PATCH_BASE)
mov	x24, x0
LFQD_Lloh386:
adr x0, LFQD_l_.str.215
LFQD_Lloh387:
nop
bl Lpatch + (0xa5a4 - PATCH_BASE)
mov	x1, x0
mov	x0, x24
mov	x2, x23
bl Lpatch + (0xa5d4 - PATCH_BASE)
mov	x2, x0
LFQD_Lloh388:
adr x1, LFQD_l_.str.236
LFQD_Lloh389:
nop
mov	x0, x20
bl	LFQD_Put
mov	x0, x22
bl	LFQD_Id
mov	x2, x0
LFQD_Lloh390:
adr x1, LFQD_l_.str.237
LFQD_Lloh391:
nop
mov	x0, x20
bl	LFQD_Put
cbnz	x21, LFQD_LBB11_2
bl	LFQD_Context
mov	x21, x0
LFQD_LBB11_2:
LFQD_Lloh392:
adr x1, LFQD_l_.str.238
LFQD_Lloh393:
nop
mov	x0, x20
mov	x2, x21
bl	LFQD_Put
bl	LFQD_Clock
mov	x2, x0
LFQD_Lloh394:
adr x1, LFQD_l_.str.239
LFQD_Lloh395:
nop
mov	x0, x20
bl	LFQD_Put
bl	LFQD_Lock
mov	x24, x0
LFQD_Lloh396:
adr x0, LFQD_l_.str
LFQD_Lloh397:
nop
bl Lpatch + (0xa5a4 - PATCH_BASE)
mov	x1, x0
mov	x0, x24
bl Lpatch + (0xa5d4 - PATCH_BASE)
LFQD_Lloh398:
adr x22, LFQD_l_.str.70
LFQD_Lloh399:
nop
mov	x0, x22
bl Lpatch + (0xa5b0 - PATCH_BASE)
LFQD_Lloh400:
adr x23, LFQD_StateKey
LFQD_Lloh401:
nop
mov	x1, x23
bl Lpatch + (0xa628 - PATCH_BASE)
mov	x25, x0
LFQD_Lloh402:
adr x26, LFQD_l_.str.241
LFQD_Lloh403:
nop
mov	x1, x26
bl	LFQD_At
mov	x27, x0
LFQD_Lloh404:
adr x0, LFQD_l_.str.143
LFQD_Lloh405:
nop
bl Lpatch + (0xa5a4 - PATCH_BASE)
mov	x1, x0
mov	x0, x27
bl Lpatch + (0xa5d4 - PATCH_BASE)
mov	x27, x0
LFQD_Lloh406:
adr x28, LFQD_l_.str.209
LFQD_Lloh407:
nop
mov	x0, x28
bl Lpatch + (0xa5b0 - PATCH_BASE)
mov	x19, x0
LFQD_Lloh408:
adr x21, LFQD_l_.str.221
LFQD_Lloh409:
nop
mov	x0, x21
bl Lpatch + (0xa5a4 - PATCH_BASE)
mov	x1, x0
add	x2, x27, #1
mov	x0, x19
bl Lpatch + (0xa5d4 - PATCH_BASE)
mov	x2, x0
mov	x0, x25
mov	x1, x26
bl	LFQD_Put
LFQD_Lloh410:
adr x25, LFQD_l_.str.6
LFQD_Lloh411:
nop
mov	x0, x25
bl Lpatch + (0xa5a4 - PATCH_BASE)
mov	x1, x0
mov	x0, x24
bl Lpatch + (0xa5d4 - PATCH_BASE)
mov	x0, x28
bl Lpatch + (0xa5b0 - PATCH_BASE)
mov	x19, x0
mov	x0, x21
bl Lpatch + (0xa5a4 - PATCH_BASE)
mov	x1, x0
add	x2, x27, #1
mov	x0, x19
bl Lpatch + (0xa5d4 - PATCH_BASE)
mov	x2, x0
LFQD_Lloh412:
adr x1, LFQD_l_.str.240
LFQD_Lloh413:
nop
mov	x0, x20
bl	LFQD_Put
bl	LFQD_Lock
mov	x19, x0
LFQD_Lloh414:
adr x0, LFQD_l_.str
LFQD_Lloh415:
nop
bl Lpatch + (0xa5a4 - PATCH_BASE)
mov	x1, x0
mov	x0, x19
bl Lpatch + (0xa5d4 - PATCH_BASE)
mov	x0, x22
bl Lpatch + (0xa5b0 - PATCH_BASE)
mov	x1, x23
bl Lpatch + (0xa628 - PATCH_BASE)
LFQD_Lloh416:
adr x21, LFQD_l_.str.36
LFQD_Lloh417:
nop
mov	x1, x21
bl	LFQD_At
mov	x2, x0
mov	x0, x20
mov	x1, x21
bl	LFQD_Put
mov	x0, x25
bl Lpatch + (0xa5a4 - PATCH_BASE)
mov	x1, x0
mov	x0, x19
bl Lpatch + (0xa5d4 - PATCH_BASE)
ldr	x0, [sp, #8]
mov	x1, x20
bl Lrecord_named
LFQD_Lloh418:
adr x0, LFQD_l_.str.5
LFQD_Lloh419:
nop
bl Lpatch + (0xa5a4 - PATCH_BASE)
mov	x1, x0
mov	x0, x20
ldp	x29, x30, [sp, #96]
ldp	x20, x19, [sp, #80]
ldp	x22, x21, [sp, #64]
ldp	x24, x23, [sp, #48]
ldp	x26, x25, [sp, #32]
ldp	x28, x27, [sp, #16]
add	sp, sp, #112
b Lpatch + (0xa5d4 - PATCH_BASE)
.cfi_endproc
.p2align	2
LFQD_FQDSettings:
.cfi_startproc
sub	sp, sp, #96
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
mov	x20, x0
bl Lpatch + (0xa664 - PATCH_BASE)
mov	x19, x0
LFQD_Lloh420:
adr x21, LFQD_l_.str.19
LFQD_Lloh421:
nop
mov	x0, x21
bl Lpatch + (0xa5a4 - PATCH_BASE)
mov	x1, x0
LFQD_Lloh422:
adr x2, LFQD_Mode
LFQD_Lloh423:
nop
LFQD_Lloh424:
adr x3, LFQD_l_.str.20
LFQD_Lloh425:
nop
mov	x0, x19
bl Lpatch + (0xa58c - PATCH_BASE)
LFQD_Lloh426:
adr x1, LFQD_l_.str.21
LFQD_Lloh427:
nop
mov	x0, x20
bl	LFQD_Get
mov	x19, x0
LFQD_Lloh428:
adr x1, LFQD_l_.str.22
LFQD_Lloh429:
nop
bl	LFQD_Get
mov	x22, x0
LFQD_Lloh430:
adr x0, LFQD_l_.str.23
LFQD_Lloh431:
nop
bl Lpatch + (0xa5b0 - PATCH_BASE)
mov	x23, x0
LFQD_Lloh432:
adr x0, LFQD_l_.str.24
LFQD_Lloh433:
nop
bl Lpatch + (0xa5a4 - PATCH_BASE)
mov	x1, x0
mov	x0, x23
bl Lpatch + (0xa5d4 - PATCH_BASE)
mov	x23, x0
LFQD_Lloh434:
adr x0, LFQD_l_.str.25
LFQD_Lloh435:
nop
bl Lpatch + (0xa5a4 - PATCH_BASE)
mov	x24, x0
bl	LFQD_Enhanced
LFQD_Lloh436:
adr x8, LFQD_l_.str.26
LFQD_Lloh437:
nop
LFQD_Lloh438:
adr x9, LFQD_l_.str.27
LFQD_Lloh439:
nop
cmp	w0, #0
csel	x25, x9, x8, eq
LFQD_Lloh440:
adr x0, LFQD_l_.str.192
LFQD_Lloh441:
nop
bl Lpatch + (0xa5b0 - PATCH_BASE)
mov	x26, x0
LFQD_Lloh442:
adr x0, LFQD_l_.str.215
LFQD_Lloh443:
nop
bl Lpatch + (0xa5a4 - PATCH_BASE)
mov	x1, x0
mov	x0, x26
mov	x2, x25
bl Lpatch + (0xa5d4 - PATCH_BASE)
mov	x25, x0
mov	x0, x21
bl Lpatch + (0xa5a4 - PATCH_BASE)
mov	x5, x0
mov	x0, x23
mov	x1, x24
mov	x2, x25
mov	x3, #0
mov	x4, x20
bl Lpatch + (0xa5d4 - PATCH_BASE)
cbz	x0, LFQD_LBB12_2
mov	x20, x0
cmp	x22, #0
csel	x8, x0, x22, eq
stp	x8, x0, [sp]
LFQD_Lloh444:
adr x0, LFQD_l_.str.28
LFQD_Lloh445:
nop
mov	w8, #1
cinc	x21, x8, ne
bl Lpatch + (0xa5b0 - PATCH_BASE)
mov	x22, x0
LFQD_Lloh446:
adr x0, LFQD_l_.str.29
LFQD_Lloh447:
nop
bl Lpatch + (0xa5a4 - PATCH_BASE)
mov	x1, x0
mov	x2, sp
mov	x0, x22
mov	x3, x21
bl Lpatch + (0xa5d4 - PATCH_BASE)
mov	x21, x0
LFQD_Lloh448:
adr x0, LFQD_l_.str.30
LFQD_Lloh449:
nop
bl Lpatch + (0xa5a4 - PATCH_BASE)
mov	x1, x0
mov	x0, x19
mov	x2, x21
bl Lpatch + (0xa5d4 - PATCH_BASE)
LFQD_Lloh450:
adr x0, LFQD_l_.str.5
LFQD_Lloh451:
nop
bl Lpatch + (0xa5a4 - PATCH_BASE)
mov	x1, x0
mov	x0, x20
bl Lpatch + (0xa5d4 - PATCH_BASE)
LFQD_LBB12_2:
ldp	x29, x30, [sp, #80]
ldp	x20, x19, [sp, #64]
ldp	x22, x21, [sp, #48]
ldp	x24, x23, [sp, #32]
ldp	x26, x25, [sp, #16]
add	sp, sp, #96
ret
.cfi_endproc
.p2align	2
LFQD_Mode:
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
mov	x20, x2
mov	x19, x0
bl	LFQD_Enhanced
mov	x21, x0
LFQD_Lloh452:
adr x0, LFQD_l_.str.242
LFQD_Lloh453:
nop
bl Lpatch + (0xa5b0 - PATCH_BASE)
mov	x22, x0
LFQD_Lloh454:
adr x0, LFQD_l_.str.243
LFQD_Lloh455:
nop
bl Lpatch + (0xa5a4 - PATCH_BASE)
mov	x1, x0
mov	x0, x22
bl Lpatch + (0xa5d4 - PATCH_BASE)
mov	x22, x0
LFQD_Lloh456:
adr x0, LFQD_l_.str.244
LFQD_Lloh457:
nop
bl Lpatch + (0xa5a4 - PATCH_BASE)
mov	x23, x0
LFQD_Lloh458:
adr x24, LFQD_l_.str.192
LFQD_Lloh459:
nop
mov	x0, x24
bl Lpatch + (0xa5b0 - PATCH_BASE)
mov	x25, x0
LFQD_Lloh460:
adr x26, LFQD_l_.str.215
LFQD_Lloh461:
nop
mov	x0, x26
bl Lpatch + (0xa5a4 - PATCH_BASE)
mov	x1, x0
LFQD_Lloh462:
adr x2, LFQD_l_.str.245
LFQD_Lloh463:
nop
mov	x0, x25
bl Lpatch + (0xa5d4 - PATCH_BASE)
mov	x3, x0
cmp	w21, #0
cset	w21, eq
LFQD_Lloh464:
adr x8, LFQD_l_.str.27
LFQD_Lloh465:
nop
LFQD_Lloh466:
adr x9, LFQD_l_.str.26
LFQD_Lloh467:
nop
csel	x25, x9, x8, eq
mov	x0, x22
mov	x1, x23
mov	x2, x21
bl Lpatch + (0xa5d4 - PATCH_BASE)
LFQD_Lloh468:
adr x0, LFQD_l_.str.246
LFQD_Lloh469:
nop
bl Lpatch + (0xa5a4 - PATCH_BASE)
mov	x22, x0
mov	x0, x24
bl Lpatch + (0xa5b0 - PATCH_BASE)
mov	x23, x0
mov	x0, x26
bl Lpatch + (0xa5a4 - PATCH_BASE)
mov	x1, x0
mov	x0, x23
mov	x2, x25
bl Lpatch + (0xa5d4 - PATCH_BASE)
mov	x2, x0
mov	x0, x20
mov	x1, x22
bl Lpatch + (0xa5d4 - PATCH_BASE)
LFQD_Lloh470:
adr x0, LFQD_l_.str.234
LFQD_Lloh471:
nop
bl Lpatch + (0xa5b0 - PATCH_BASE)
mov	x20, x0
LFQD_Lloh472:
adr x0, LFQD_l_.str.235
LFQD_Lloh473:
nop
bl Lpatch + (0xa5a4 - PATCH_BASE)
mov	x1, x0
mov	x0, x20
bl Lpatch + (0xa5d4 - PATCH_BASE)
mov	x20, x0
LFQD_Lloh474:
adr x0, LFQD_l_.str.209
LFQD_Lloh475:
nop
bl Lpatch + (0xa5b0 - PATCH_BASE)
mov	x22, x0
LFQD_Lloh476:
adr x0, LFQD_l_.str.221
LFQD_Lloh477:
nop
bl Lpatch + (0xa5a4 - PATCH_BASE)
mov	x1, x0
mov	x0, x22
mov	x2, x21
bl Lpatch + (0xa5d4 - PATCH_BASE)
mov	x2, x0
LFQD_Lloh478:
adr x1, LFQD_l_.str.247
LFQD_Lloh479:
nop
mov	x0, x20
bl	LFQD_Put
LFQD_Lloh480:
adr x0, LFQD_l_.str.248
LFQD_Lloh481:
nop
LFQD_Lloh482:
adr x1, LFQD_l_.str.18
LFQD_Lloh483:
nop
mov	x2, x19
mov	x3, #0
mov	x4, x20
ldp	x29, x30, [sp, #64]
ldp	x20, x19, [sp, #48]
ldp	x22, x21, [sp, #32]
ldp	x24, x23, [sp, #16]
ldp	x26, x25, [sp], #80
b	LFQD_Emit
.cfi_endproc
.p2align	2
LFQD_Get:
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
bl	LFQD_Responds
cbz	w0, LFQD_LBB14_2
mov	x0, x20
bl Lpatch + (0xa5a4 - PATCH_BASE)
mov	x1, x0
mov	x0, x19
ldp	x29, x30, [sp, #16]
ldp	x20, x19, [sp], #32
b Lpatch + (0xa5d4 - PATCH_BASE)
LFQD_LBB14_2:
mov	x0, #0
ldp	x29, x30, [sp, #16]
ldp	x20, x19, [sp], #32
ret
.cfi_endproc
.p2align	2
LFQD_Enhanced:
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
LFQD_Lloh484:
adr x0, LFQD_l_.str.242
LFQD_Lloh485:
nop
bl Lpatch + (0xa5b0 - PATCH_BASE)
mov	x19, x0
LFQD_Lloh486:
adr x0, LFQD_l_.str.243
LFQD_Lloh487:
nop
bl Lpatch + (0xa5a4 - PATCH_BASE)
mov	x1, x0
mov	x0, x19
bl Lpatch + (0xa5d4 - PATCH_BASE)
mov	x19, x0
LFQD_Lloh488:
adr x0, LFQD_l_.str.250
LFQD_Lloh489:
nop
bl Lpatch + (0xa5a4 - PATCH_BASE)
mov	x20, x0
LFQD_Lloh490:
adr x0, LFQD_l_.str.192
LFQD_Lloh491:
nop
bl Lpatch + (0xa5b0 - PATCH_BASE)
mov	x21, x0
LFQD_Lloh492:
adr x0, LFQD_l_.str.215
LFQD_Lloh493:
nop
bl Lpatch + (0xa5a4 - PATCH_BASE)
mov	x1, x0
LFQD_Lloh494:
adr x2, LFQD_l_.str.245
LFQD_Lloh495:
nop
mov	x0, x21
bl Lpatch + (0xa5d4 - PATCH_BASE)
mov	x2, x0
mov	x0, x19
mov	x1, x20
ldp	x29, x30, [sp, #32]
ldp	x20, x19, [sp, #16]
ldp	x22, x21, [sp], #48
b Lpatch + (0xa5d4 - PATCH_BASE)
.cfi_endproc
.p2align	2
LFQD_FQDInstall:
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
LFQD_Lloh496:
adr x0, LFQD_l_.str.31
LFQD_Lloh497:
nop
bl	LFQD_FQDLoadStage
LFQD_Lloh498:
adr x0, LFQD_l_.str.70
LFQD_Lloh499:
nop
bl Lpatch + (0xa5b0 - PATCH_BASE)
LFQD_Lloh500:
adr x1, LFQD_StateKey
LFQD_Lloh501:
nop
bl Lpatch + (0xa628 - PATCH_BASE)
cbnz	x0, LFQD_LBB16_5
LFQD_Lloh502:
adr x20, LFQD_l_.str.234
LFQD_Lloh503:
nop
mov	x0, x20
bl Lpatch + (0xa5b0 - PATCH_BASE)
mov	x19, x0
LFQD_Lloh504:
adr x21, LFQD_l_.str.235
LFQD_Lloh505:
nop
mov	x0, x21
bl Lpatch + (0xa5a4 - PATCH_BASE)
mov	x1, x0
mov	x0, x19
bl Lpatch + (0xa5d4 - PATCH_BASE)
mov	x19, x0
LFQD_Lloh506:
adr x0, LFQD_l_.str.32
LFQD_Lloh507:
nop
bl Lpatch + (0xa5b0 - PATCH_BASE)
mov	x22, x0
LFQD_Lloh508:
adr x0, LFQD_l_.str.24
LFQD_Lloh509:
nop
bl Lpatch + (0xa5a4 - PATCH_BASE)
mov	x1, x0
mov	x0, x22
bl Lpatch + (0xa5d4 - PATCH_BASE)
mov	x22, x0
LFQD_Lloh510:
adr x0, LFQD_l_.str.33
LFQD_Lloh511:
nop
bl Lpatch + (0xa5a4 - PATCH_BASE)
mov	x1, x0
mov	x0, x22
bl Lpatch + (0xa5d4 - PATCH_BASE)
mov	x22, x0
LFQD_Lloh512:
adr x1, LFQD_l_.str
LFQD_Lloh513:
nop
mov	x0, x19
mov	x2, x22
bl	LFQD_Put
LFQD_Lloh514:
adr x0, LFQD_l_.str.5
LFQD_Lloh515:
nop
bl Lpatch + (0xa5a4 - PATCH_BASE)
mov	x1, x0
mov	x0, x22
bl Lpatch + (0xa5d4 - PATCH_BASE)
mov	x0, x20
bl Lpatch + (0xa5b0 - PATCH_BASE)
mov	x22, x0
mov	x0, x21
bl Lpatch + (0xa5a4 - PATCH_BASE)
mov	x1, x0
mov	x0, x22
bl Lpatch + (0xa5d4 - PATCH_BASE)
mov	x2, x0
LFQD_Lloh516:
adr x1, LFQD_l_.str.34
LFQD_Lloh517:
nop
mov	x0, x19
bl	LFQD_Put
mov	x0, x20
bl Lpatch + (0xa5b0 - PATCH_BASE)
mov	x20, x0
mov	x0, x21
bl Lpatch + (0xa5a4 - PATCH_BASE)
mov	x1, x0
mov	x0, x20
bl Lpatch + (0xa5d4 - PATCH_BASE)
mov	x2, x0
LFQD_Lloh518:
adr x1, LFQD_l_.str.35
LFQD_Lloh519:
nop
mov	x0, x19
bl	LFQD_Put
LFQD_Lloh520:
adr x0, LFQD_l_.str.209
LFQD_Lloh521:
nop
bl Lpatch + (0xa5b0 - PATCH_BASE)
mov	x20, x0
LFQD_Lloh522:
adr x0, LFQD_l_.str.221
LFQD_Lloh523:
nop
bl Lpatch + (0xa5a4 - PATCH_BASE)
mov	x1, x0
mov	x0, x20
mov	x2, #0
bl Lpatch + (0xa5d4 - PATCH_BASE)
mov	x2, x0
LFQD_Lloh524:
adr x1, LFQD_l_.str.36
LFQD_Lloh525:
nop
mov	x0, x19
bl	LFQD_Put
LFQD_Lloh526:
adr x0, LFQD_l_.str.37
LFQD_Lloh527:
nop
bl Lpatch + (0xa5b0 - PATCH_BASE)
mov	x20, x0
cbnz	x0, LFQD_LBB16_4
LFQD_Lloh528:
adr x0, LFQD_l_.str.38
LFQD_Lloh529:
nop
bl Lpatch + (0xa5b0 - PATCH_BASE)
LFQD_Lloh530:
adr x1, LFQD_l_.str.37
LFQD_Lloh531:
nop
mov	x2, #0
bl Lpatch + (0xa61c - PATCH_BASE)
mov	x20, x0
cbz	x0, LFQD_LBB16_4
LFQD_Lloh532:
adr x0, LFQD_l_.str.39
LFQD_Lloh533:
nop
bl Lpatch + (0xa5a4 - PATCH_BASE)
mov	x1, x0
LFQD_Lloh534:
adr x2, LFQD_ActionTimeout
LFQD_Lloh535:
nop
LFQD_Lloh536:
adr x3, LFQD_l_.str.20
LFQD_Lloh537:
nop
mov	x0, x20
bl Lpatch + (0xa58c - PATCH_BASE)
mov	x0, x20
bl Lpatch + (0xa610 - PATCH_BASE)
LFQD_LBB16_4:
LFQD_Lloh538:
adr x0, LFQD_l_.str.24
LFQD_Lloh539:
nop
bl Lpatch + (0xa5a4 - PATCH_BASE)
mov	x1, x0
mov	x0, x20
bl Lpatch + (0xa5d4 - PATCH_BASE)
mov	x20, x0
LFQD_Lloh540:
adr x0, LFQD_l_.str.33
LFQD_Lloh541:
nop
bl Lpatch + (0xa5a4 - PATCH_BASE)
mov	x1, x0
mov	x0, x20
bl Lpatch + (0xa5d4 - PATCH_BASE)
mov	x20, x0
LFQD_Lloh542:
adr x1, LFQD_l_.str.40
LFQD_Lloh543:
nop
mov	x0, x19
mov	x2, x20
bl	LFQD_Put
LFQD_Lloh544:
adr x0, LFQD_l_.str.5
LFQD_Lloh545:
nop
bl Lpatch + (0xa5a4 - PATCH_BASE)
mov	x1, x0
mov	x0, x20
bl Lpatch + (0xa5d4 - PATCH_BASE)
LFQD_Lloh546:
adr x0, LFQD_l_.str.70
LFQD_Lloh547:
nop
bl Lpatch + (0xa5b0 - PATCH_BASE)
LFQD_Lloh548:
adr x1, LFQD_StateKey
LFQD_Lloh549:
nop
mov	x2, x19
mov	w3, #769
bl Lpatch + (0xa634 - PATCH_BASE)
LFQD_LBB16_5:
LFQD_Lloh550:
adr x22, LFQD_l_.str.41
LFQD_Lloh551:
nop
LFQD_Lloh552:
adr x1, LFQD_l_.str.42
LFQD_Lloh553:
nop
LFQD_Lloh554:
adr x21, LFQD_l_.str.20
LFQD_Lloh555:
nop
LFQD_Lloh556:
adr x3, LFQD_l_.str.43
LFQD_Lloh557:
nop
LFQD_Lloh558:
adr x4, LFQD_Bind
LFQD_Lloh559:
nop
mov	x0, x22
mov	x2, x21
bl	LFQD_Install
LFQD_Lloh560:
adr x1, LFQD_l_.str.44
LFQD_Lloh561:
nop
LFQD_Lloh562:
adr x19, LFQD_l_.str.45
LFQD_Lloh563:
nop
LFQD_Lloh564:
adr x3, LFQD_l_.str.46
LFQD_Lloh565:
nop
LFQD_Lloh566:
adr x4, LFQD_BubbleUpdate
LFQD_Lloh567:
nop
mov	x0, x22
mov	x2, x19
bl	LFQD_Install
LFQD_Lloh568:
adr x1, LFQD_l_.str.47
LFQD_Lloh569:
nop
LFQD_Lloh570:
adr x3, LFQD_l_.str.48
LFQD_Lloh571:
nop
LFQD_Lloh572:
adr x4, LFQD_BubbleTap
LFQD_Lloh573:
nop
mov	x0, x22
mov	x2, x19
bl	LFQD_Install
LFQD_Lloh574:
adr x1, LFQD_l_.str.49
LFQD_Lloh575:
nop
LFQD_Lloh576:
adr x20, LFQD_l_.str.50
LFQD_Lloh577:
nop
LFQD_Lloh578:
adr x3, LFQD_l_.str.51
LFQD_Lloh579:
nop
LFQD_Lloh580:
adr x4, LFQD_Hidden
LFQD_Lloh581:
nop
mov	x0, x22
mov	x2, x20
bl	LFQD_Install
LFQD_Lloh582:
adr x1, LFQD_l_.str.52
LFQD_Lloh583:
nop
LFQD_Lloh584:
adr x3, LFQD_l_.str.53
LFQD_Lloh585:
nop
LFQD_Lloh586:
adr x4, LFQD_Removed
LFQD_Lloh587:
nop
mov	x0, x22
mov	x2, x19
bl	LFQD_Install
LFQD_Lloh588:
adr x1, LFQD_l_.str.54
LFQD_Lloh589:
nop
LFQD_Lloh590:
adr x3, LFQD_l_.str.55
LFQD_Lloh591:
nop
LFQD_Lloh592:
adr x4, LFQD_Window
LFQD_Lloh593:
nop
mov	x0, x22
mov	x2, x19
bl	LFQD_Install
LFQD_Lloh594:
adr x1, LFQD_l_.str.56
LFQD_Lloh595:
nop
LFQD_Lloh596:
adr x3, LFQD_l_.str.57
LFQD_Lloh597:
nop
LFQD_Lloh598:
adr x4, LFQD_Released
LFQD_Lloh599:
nop
mov	x0, x22
mov	x2, x19
bl	LFQD_Install
LFQD_Lloh600:
adr x22, LFQD_l_.str.58
LFQD_Lloh601:
nop
LFQD_Lloh602:
adr x23, LFQD_l_.str.59
LFQD_Lloh603:
nop
LFQD_Lloh604:
adr x24, LFQD_l_.str.60
LFQD_Lloh605:
nop
LFQD_Lloh606:
adr x3, LFQD_l_.str.61
LFQD_Lloh607:
nop
LFQD_Lloh608:
adr x4, LFQD_EntranceCount
LFQD_Lloh609:
nop
mov	x0, x22
mov	x1, x23
mov	x2, x24
bl	LFQD_Install
LFQD_Lloh610:
adr x1, LFQD_l_.str.62
LFQD_Lloh611:
nop
LFQD_Lloh612:
adr x3, LFQD_l_.str.63
LFQD_Lloh613:
nop
LFQD_Lloh614:
adr x4, LFQD_EntranceOrigin
LFQD_Lloh615:
nop
mov	x0, x22
mov	x2, x24
bl	LFQD_Install
LFQD_Lloh616:
adr x22, LFQD_l_.str.64
LFQD_Lloh617:
nop
LFQD_Lloh618:
adr x3, LFQD_l_.str.65
LFQD_Lloh619:
nop
LFQD_Lloh620:
adr x4, LFQD_DataCount
LFQD_Lloh621:
nop
mov	x0, x22
mov	x1, x23
mov	x2, x24
bl	LFQD_Install
LFQD_Lloh622:
adr x1, LFQD_l_.str.66
LFQD_Lloh623:
nop
LFQD_Lloh624:
adr x3, LFQD_l_.str.67
LFQD_Lloh625:
nop
LFQD_Lloh626:
adr x4, LFQD_DataRaw
LFQD_Lloh627:
nop
mov	x0, x22
mov	x2, x24
bl	LFQD_Install
LFQD_Lloh628:
adr x1, LFQD_l_.str.68
LFQD_Lloh629:
nop
LFQD_Lloh630:
adr x3, LFQD_l_.str.69
LFQD_Lloh631:
nop
LFQD_Lloh632:
adr x4, LFQD_BubbleData
LFQD_Lloh633:
nop
mov	x0, x22
mov	x2, x21
bl	LFQD_Install
LFQD_Lloh634:
adr x22, LFQD_l_.str.70
LFQD_Lloh635:
nop
LFQD_Lloh636:
adr x1, LFQD_l_.str.71
LFQD_Lloh637:
nop
LFQD_Lloh638:
adr x3, LFQD_l_.str.72
LFQD_Lloh639:
nop
LFQD_Lloh640:
adr x4, LFQD_Open
LFQD_Lloh641:
nop
mov	x0, x22
mov	x2, x21
bl	LFQD_Install
LFQD_Lloh642:
adr x1, LFQD_l_.str.73
LFQD_Lloh643:
nop
LFQD_Lloh644:
adr x3, LFQD_l_.str.74
LFQD_Lloh645:
nop
LFQD_Lloh646:
adr x4, LFQD_Dismiss
LFQD_Lloh647:
nop
mov	x0, x22
mov	x2, x21
bl	LFQD_Install
LFQD_Lloh648:
adr x23, LFQD_l_.str.75
LFQD_Lloh649:
nop
LFQD_Lloh650:
adr x21, LFQD_l_.str.76
LFQD_Lloh651:
nop
LFQD_Lloh652:
adr x3, LFQD_l_.str.77
LFQD_Lloh653:
nop
LFQD_Lloh654:
adr x4, LFQD_Appeared
LFQD_Lloh655:
nop
mov	x0, x23
mov	x1, x21
mov	x2, x20
bl	LFQD_Install
LFQD_Lloh656:
adr x1, LFQD_l_.str.78
LFQD_Lloh657:
nop
LFQD_Lloh658:
adr x3, LFQD_l_.str.79
LFQD_Lloh659:
nop
LFQD_Lloh660:
adr x4, LFQD_WillDisappear
LFQD_Lloh661:
nop
mov	x0, x23
mov	x2, x20
bl	LFQD_Install
LFQD_Lloh662:
adr x22, LFQD_l_.str.80
LFQD_Lloh663:
nop
LFQD_Lloh664:
adr x3, LFQD_l_.str.81
LFQD_Lloh665:
nop
LFQD_Lloh666:
adr x4, LFQD_Disappeared
LFQD_Lloh667:
nop
mov	x0, x23
mov	x1, x22
mov	x2, x20
bl	LFQD_Install
LFQD_Lloh668:
adr x0, LFQD_l_.str.82
LFQD_Lloh669:
nop
LFQD_Lloh670:
adr x1, LFQD_l_.str.83
LFQD_Lloh671:
nop
LFQD_Lloh672:
adr x2, LFQD_l_.str.84
LFQD_Lloh673:
nop
LFQD_Lloh674:
adr x3, LFQD_l_.str.85
LFQD_Lloh675:
nop
LFQD_Lloh676:
adr x4, LFQD_Commit
LFQD_Lloh677:
nop
bl	LFQD_Install
LFQD_Lloh678:
adr x0, LFQD_l_.str.86
LFQD_Lloh679:
nop
LFQD_Lloh680:
adr x1, LFQD_l_.str.87
LFQD_Lloh681:
nop
LFQD_Lloh682:
adr x23, LFQD_l_.str.88
LFQD_Lloh683:
nop
LFQD_Lloh684:
adr x3, LFQD_l_.str.89
LFQD_Lloh685:
nop
LFQD_Lloh686:
adr x4, LFQD_Cache
LFQD_Lloh687:
nop
mov	x2, x23
bl	LFQD_Install
LFQD_Lloh688:
adr x24, LFQD_l_.str.90
LFQD_Lloh689:
nop
LFQD_Lloh690:
adr x1, LFQD_l_.str.91
LFQD_Lloh691:
nop
LFQD_Lloh692:
adr x2, LFQD_l_.str.92
LFQD_Lloh693:
nop
LFQD_Lloh694:
adr x3, LFQD_l_.str.93
LFQD_Lloh695:
nop
LFQD_Lloh696:
adr x4, LFQD_RequestInit
LFQD_Lloh697:
nop
mov	x0, x24
bl	LFQD_Install
LFQD_Lloh698:
adr x1, LFQD_l_.str.94
LFQD_Lloh699:
nop
LFQD_Lloh700:
adr x3, LFQD_l_.str.95
LFQD_Lloh701:
nop
LFQD_Lloh702:
adr x4, LFQD_RequestSend
LFQD_Lloh703:
nop
mov	x0, x24
mov	x2, x19
bl	LFQD_Install
LFQD_Lloh704:
adr x1, LFQD_l_.str.96
LFQD_Lloh705:
nop
LFQD_Lloh706:
adr x3, LFQD_l_.str.97
LFQD_Lloh707:
nop
LFQD_Lloh708:
adr x4, LFQD_RequestCancel
LFQD_Lloh709:
nop
mov	x0, x24
mov	x2, x19
bl	LFQD_Install
LFQD_Lloh710:
adr x1, LFQD_l_.str.98
LFQD_Lloh711:
nop
LFQD_Lloh712:
adr x3, LFQD_l_.str.99
LFQD_Lloh713:
nop
LFQD_Lloh714:
adr x4, LFQD_RequestComplete
LFQD_Lloh715:
nop
mov	x0, x24
mov	x2, x19
bl	LFQD_Install
LFQD_Lloh716:
adr x1, LFQD_l_.str.100
LFQD_Lloh717:
nop
LFQD_Lloh718:
adr x3, LFQD_l_.str.101
LFQD_Lloh719:
nop
LFQD_Lloh720:
adr x4, LFQD_Response
LFQD_Lloh721:
nop
mov	x0, x24
mov	x2, x23
bl	LFQD_Install
LFQD_Lloh722:
adr x0, LFQD_l_.str.102
LFQD_Lloh723:
nop
LFQD_Lloh724:
adr x1, LFQD_l_.str.103
LFQD_Lloh725:
nop
LFQD_Lloh726:
adr x2, LFQD_l_.str.104
LFQD_Lloh727:
nop
LFQD_Lloh728:
adr x3, LFQD_l_.str.105
LFQD_Lloh729:
nop
LFQD_Lloh730:
adr x4, LFQD_TransportResponse
LFQD_Lloh731:
nop
bl	LFQD_Install
LFQD_Lloh732:
adr x0, LFQD_l_.str.106
LFQD_Lloh733:
nop
LFQD_Lloh734:
adr x1, LFQD_l_.str.107
LFQD_Lloh735:
nop
LFQD_Lloh736:
adr x2, LFQD_l_.str.108
LFQD_Lloh737:
nop
LFQD_Lloh738:
adr x3, LFQD_l_.str.109
LFQD_Lloh739:
nop
LFQD_Lloh740:
adr x4, LFQD_SendAction
LFQD_Lloh741:
nop
bl	LFQD_Install
LFQD_Lloh742:
adr x23, LFQD_l_.str.110
LFQD_Lloh743:
nop
LFQD_Lloh744:
adr x1, LFQD_l_.str.111
LFQD_Lloh745:
nop
LFQD_Lloh746:
adr x2, LFQD_l_.str.112
LFQD_Lloh747:
nop
LFQD_Lloh748:
adr x3, LFQD_l_.str.113
LFQD_Lloh749:
nop
LFQD_Lloh750:
adr x4, LFQD_Push
LFQD_Lloh751:
nop
mov	x0, x23
bl	LFQD_Install
LFQD_Lloh752:
adr x1, LFQD_l_.str.114
LFQD_Lloh753:
nop
LFQD_Lloh754:
adr x2, LFQD_l_.str.115
LFQD_Lloh755:
nop
LFQD_Lloh756:
adr x3, LFQD_l_.str.116
LFQD_Lloh757:
nop
LFQD_Lloh758:
adr x4, LFQD_Pop
LFQD_Lloh759:
nop
mov	x0, x23
bl	LFQD_Install
LFQD_Lloh760:
adr x0, LFQD_l_.str.117
LFQD_Lloh761:
nop
LFQD_Lloh762:
adr x1, LFQD_l_.str.118
LFQD_Lloh763:
nop
LFQD_Lloh764:
adr x3, LFQD_l_.str.119
LFQD_Lloh765:
nop
LFQD_Lloh766:
adr x4, LFQD_Exception
LFQD_Lloh767:
nop
mov	x2, x19
bl	LFQD_Install
LFQD_Lloh768:
adr x24, LFQD_l_.str.120
LFQD_Lloh769:
nop
LFQD_Lloh770:
adr x23, LFQD_l_.str.121
LFQD_Lloh771:
nop
LFQD_Lloh772:
adr x3, LFQD_l_.str.122
LFQD_Lloh773:
nop
LFQD_Lloh774:
adr x4, LFQD_ReaderLoad
LFQD_Lloh775:
nop
mov	x0, x24
mov	x1, x23
mov	x2, x19
bl	LFQD_Install
LFQD_Lloh776:
adr x3, LFQD_l_.str.123
LFQD_Lloh777:
nop
LFQD_Lloh778:
adr x4, LFQD_ReaderAppear
LFQD_Lloh779:
nop
mov	x0, x24
mov	x1, x21
mov	x2, x20
bl	LFQD_Install
LFQD_Lloh780:
adr x3, LFQD_l_.str.124
LFQD_Lloh781:
nop
LFQD_Lloh782:
adr x4, LFQD_ReaderDisappear
LFQD_Lloh783:
nop
mov	x0, x24
mov	x1, x22
mov	x2, x20
bl	LFQD_Install
LFQD_Lloh784:
adr x24, LFQD_l_.str.125
LFQD_Lloh785:
nop
LFQD_Lloh786:
adr x3, LFQD_l_.str.126
LFQD_Lloh787:
nop
LFQD_Lloh788:
adr x4, LFQD_StoreLoad
LFQD_Lloh789:
nop
mov	x0, x24
mov	x1, x23
mov	x2, x19
bl	LFQD_Install
LFQD_Lloh790:
adr x3, LFQD_l_.str.127
LFQD_Lloh791:
nop
LFQD_Lloh792:
adr x4, LFQD_StoreAppear
LFQD_Lloh793:
nop
mov	x0, x24
mov	x1, x21
mov	x2, x20
bl	LFQD_Install
LFQD_Lloh794:
adr x3, LFQD_l_.str.128
LFQD_Lloh795:
nop
LFQD_Lloh796:
adr x4, LFQD_StoreDisappear
LFQD_Lloh797:
nop
mov	x0, x24
mov	x1, x22
mov	x2, x20
bl	LFQD_Install
LFQD_Lloh798:
adr x24, LFQD_l_.str.129
LFQD_Lloh799:
nop
LFQD_Lloh800:
adr x3, LFQD_l_.str.130
LFQD_Lloh801:
nop
LFQD_Lloh802:
adr x4, LFQD_ShelfLoad
LFQD_Lloh803:
nop
mov	x0, x24
mov	x1, x23
mov	x2, x19
bl	LFQD_Install
LFQD_Lloh804:
adr x3, LFQD_l_.str.131
LFQD_Lloh805:
nop
LFQD_Lloh806:
adr x4, LFQD_ShelfAppear
LFQD_Lloh807:
nop
mov	x0, x24
mov	x1, x21
mov	x2, x20
bl	LFQD_Install
LFQD_Lloh808:
adr x3, LFQD_l_.str.132
LFQD_Lloh809:
nop
LFQD_Lloh810:
adr x4, LFQD_ShelfDisappear
LFQD_Lloh811:
nop
mov	x0, x24
mov	x1, x22
mov	x2, x20
bl	LFQD_Install
LFQD_Lloh812:
adr x24, LFQD_l_.str.133
LFQD_Lloh813:
nop
LFQD_Lloh814:
adr x3, LFQD_l_.str.134
LFQD_Lloh815:
nop
LFQD_Lloh816:
adr x4, LFQD_MineLoad
LFQD_Lloh817:
nop
mov	x0, x24
mov	x1, x23
mov	x2, x19
bl	LFQD_Install
LFQD_Lloh818:
adr x3, LFQD_l_.str.135
LFQD_Lloh819:
nop
LFQD_Lloh820:
adr x4, LFQD_MineAppear
LFQD_Lloh821:
nop
mov	x0, x24
mov	x1, x21
mov	x2, x20
bl	LFQD_Install
LFQD_Lloh822:
adr x3, LFQD_l_.str.136
LFQD_Lloh823:
nop
LFQD_Lloh824:
adr x4, LFQD_MineDisappear
LFQD_Lloh825:
nop
mov	x0, x24
mov	x1, x22
mov	x2, x20
bl	LFQD_Install
LFQD_Lloh826:
adr x24, LFQD_l_.str.137
LFQD_Lloh827:
nop
LFQD_Lloh828:
adr x3, LFQD_l_.str.138
LFQD_Lloh829:
nop
LFQD_Lloh830:
adr x4, LFQD_ShortVideoLoad
LFQD_Lloh831:
nop
mov	x0, x24
mov	x1, x23
mov	x2, x19
bl	LFQD_Install
LFQD_Lloh832:
adr x3, LFQD_l_.str.139
LFQD_Lloh833:
nop
LFQD_Lloh834:
adr x4, LFQD_ShortVideoAppear
LFQD_Lloh835:
nop
mov	x0, x24
mov	x1, x21
mov	x2, x20
bl	LFQD_Install
LFQD_Lloh836:
adr x3, LFQD_l_.str.140
LFQD_Lloh837:
nop
LFQD_Lloh838:
adr x4, LFQD_ShortVideoDisappear
LFQD_Lloh839:
nop
mov	x0, x24
mov	x1, x22
mov	x2, x20
bl	LFQD_Install
LFQD_Lloh840:
adr x0, LFQD_l_.str.141
LFQD_Lloh841:
nop
ldp	x29, x30, [sp, #48]
ldp	x20, x19, [sp, #32]
ldp	x22, x21, [sp, #16]
ldp	x24, x23, [sp], #64
b	LFQD_FQDLoadStage
.cfi_endproc
.p2align	2
LFQD_ActionTimeout:
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
bl	LFQD_Lock
mov	x20, x0
LFQD_Lloh842:
adr x0, LFQD_l_.str
LFQD_Lloh843:
nop
bl Lpatch + (0xa5a4 - PATCH_BASE)
mov	x1, x0
mov	x0, x20
bl Lpatch + (0xa5d4 - PATCH_BASE)
LFQD_Lloh844:
adr x22, LFQD_l_.str.70
LFQD_Lloh845:
nop
mov	x0, x22
bl Lpatch + (0xa5b0 - PATCH_BASE)
LFQD_Lloh846:
adr x23, LFQD_StateKey
LFQD_Lloh847:
nop
mov	x1, x23
bl Lpatch + (0xa628 - PATCH_BASE)
LFQD_Lloh848:
adr x1, LFQD_l_.str.241
LFQD_Lloh849:
nop
bl	LFQD_At
mov	x21, x0
LFQD_Lloh850:
adr x24, LFQD_l_.str.143
LFQD_Lloh851:
nop
mov	x0, x24
bl Lpatch + (0xa5a4 - PATCH_BASE)
mov	x1, x0
mov	x0, x21
bl Lpatch + (0xa5d4 - PATCH_BASE)
mov	x21, x0
mov	x0, x22
bl Lpatch + (0xa5b0 - PATCH_BASE)
mov	x1, x23
bl Lpatch + (0xa628 - PATCH_BASE)
LFQD_Lloh852:
adr x25, LFQD_l_.str.251
LFQD_Lloh853:
nop
mov	x1, x25
bl	LFQD_At
mov	x26, x0
mov	x0, x24
bl Lpatch + (0xa5a4 - PATCH_BASE)
mov	x1, x0
mov	x0, x26
bl Lpatch + (0xa5d4 - PATCH_BASE)
mov	x24, x0
mov	x0, x22
bl Lpatch + (0xa5b0 - PATCH_BASE)
mov	x1, x23
bl Lpatch + (0xa628 - PATCH_BASE)
mov	x22, x0
cmp	x24, #1
csinc	x8, x24, xzr, gt
sub	x23, x8, #1
LFQD_Lloh854:
adr x0, LFQD_l_.str.209
LFQD_Lloh855:
nop
bl Lpatch + (0xa5b0 - PATCH_BASE)
mov	x24, x0
LFQD_Lloh856:
adr x0, LFQD_l_.str.221
LFQD_Lloh857:
nop
bl Lpatch + (0xa5a4 - PATCH_BASE)
mov	x1, x0
mov	x0, x24
mov	x2, x23
bl Lpatch + (0xa5d4 - PATCH_BASE)
mov	x2, x0
mov	x0, x22
mov	x1, x25
bl	LFQD_Put
LFQD_Lloh858:
adr x0, LFQD_l_.str.6
LFQD_Lloh859:
nop
bl Lpatch + (0xa5a4 - PATCH_BASE)
mov	x1, x0
mov	x0, x20
bl Lpatch + (0xa5d4 - PATCH_BASE)
bl	LFQD_Enhanced
cbz	w0, LFQD_LBB17_3
LFQD_Lloh860:
adr x1, LFQD_l_.str.241
LFQD_Lloh861:
nop
mov	x0, x19
bl	LFQD_At
mov	x20, x0
LFQD_Lloh862:
adr x0, LFQD_l_.str.143
LFQD_Lloh863:
nop
bl Lpatch + (0xa5a4 - PATCH_BASE)
mov	x1, x0
mov	x0, x20
bl Lpatch + (0xa5d4 - PATCH_BASE)
cmp	x21, x0
b.ne	LFQD_LBB17_3
LFQD_Lloh864:
adr x0, LFQD_l_.str.2
LFQD_Lloh865:
nop
bl Lpatch + (0xa5a4 - PATCH_BASE)
mov	x1, x0
mov	x0, x19
bl Lpatch + (0xa5d4 - PATCH_BASE)
mov	x20, x0
LFQD_Lloh866:
adr x21, LFQD_l_.str.192
LFQD_Lloh867:
nop
mov	x0, x21
bl Lpatch + (0xa5b0 - PATCH_BASE)
mov	x22, x0
LFQD_Lloh868:
adr x23, LFQD_l_.str.215
LFQD_Lloh869:
nop
mov	x0, x23
bl Lpatch + (0xa5a4 - PATCH_BASE)
mov	x1, x0
LFQD_Lloh870:
adr x2, LFQD_l_.str.252
LFQD_Lloh871:
nop
mov	x0, x22
bl Lpatch + (0xa5d4 - PATCH_BASE)
mov	x2, x0
LFQD_Lloh872:
adr x1, LFQD_l_.str.150
LFQD_Lloh873:
nop
mov	x0, x20
bl	LFQD_Put
LFQD_Lloh874:
adr x0, LFQD_l_.str.209
LFQD_Lloh875:
nop
bl Lpatch + (0xa5b0 - PATCH_BASE)
mov	x22, x0
LFQD_Lloh876:
adr x0, LFQD_l_.str.221
LFQD_Lloh877:
nop
bl Lpatch + (0xa5a4 - PATCH_BASE)
mov	x1, x0
mov	x0, x22
mov	w2, #2
bl Lpatch + (0xa5d4 - PATCH_BASE)
mov	x2, x0
LFQD_Lloh878:
adr x1, LFQD_l_.str.253
LFQD_Lloh879:
nop
mov	x0, x20
bl	LFQD_Put
mov	x0, x21
bl Lpatch + (0xa5b0 - PATCH_BASE)
mov	x21, x0
mov	x0, x23
bl Lpatch + (0xa5a4 - PATCH_BASE)
mov	x1, x0
LFQD_Lloh880:
adr x2, LFQD_l_.str.255
LFQD_Lloh881:
nop
mov	x0, x21
bl Lpatch + (0xa5d4 - PATCH_BASE)
mov	x2, x0
LFQD_Lloh882:
adr x1, LFQD_l_.str.254
LFQD_Lloh883:
nop
mov	x0, x20
bl	LFQD_Put
LFQD_Lloh884:
adr x1, LFQD_l_.str.238
LFQD_Lloh885:
nop
mov	x0, x19
bl	LFQD_At
mov	x3, x0
LFQD_Lloh886:
adr x0, LFQD_l_.str.256
LFQD_Lloh887:
nop
LFQD_Lloh888:
adr x1, LFQD_l_.str.106
LFQD_Lloh889:
nop
mov	x2, #0
mov	x4, x20
bl	LFQD_Emit
LFQD_Lloh890:
adr x0, LFQD_l_.str.5
LFQD_Lloh891:
nop
bl Lpatch + (0xa5a4 - PATCH_BASE)
mov	x1, x0
mov	x0, x20
ldp	x29, x30, [sp, #64]
ldp	x20, x19, [sp, #48]
ldp	x22, x21, [sp, #32]
ldp	x24, x23, [sp, #16]
ldp	x26, x25, [sp], #80
b Lpatch + (0xa5d4 - PATCH_BASE)
LFQD_LBB17_3:
ldp	x29, x30, [sp, #64]
ldp	x20, x19, [sp, #48]
ldp	x22, x21, [sp, #32]
ldp	x24, x23, [sp, #16]
ldp	x26, x25, [sp], #80
ret
.cfi_endproc
.p2align	2
LFQD_StateKey:
.cfi_startproc
ret
.cfi_endproc
.p2align	2
LFQD_Install:
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
mov	x21, x3
mov	x20, x2
mov	x23, x1
bl Lpatch + (0xa5b0 - PATCH_BASE)
mov	x22, x0
mov	x0, x23
bl Lpatch + (0xa5a4 - PATCH_BASE)
mov	x1, x0
mov	x0, x22
mov	w2, #0
mov	x3, x20
bl LHookOwned
cbz	x0, LFQD_LBB19_3
mov	x23, x0
bl Lpatch + (0xa598 - PATCH_BASE)
mov	x24, x0
mov	x0, x21
bl Lpatch + (0xa5a4 - PATCH_BASE)
mov	x1, x0
mov	x0, x22
mov	x2, x24
mov	x3, x20
bl Lpatch + (0xa58c - PATCH_BASE)
cbz	w0, LFQD_LBB19_3
mov	x0, x23
mov	x1, x19
ldp	x29, x30, [sp, #48]
ldp	x20, x19, [sp, #32]
ldp	x22, x21, [sp, #16]
ldp	x24, x23, [sp], #64
b Lpatch + (0xa580 - PATCH_BASE)
LFQD_LBB19_3:
ldp	x29, x30, [sp, #48]
ldp	x20, x19, [sp, #32]
ldp	x22, x21, [sp, #16]
ldp	x24, x23, [sp], #64
ret
.cfi_endproc
.p2align	2
LFQD_Bind:
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
mov	x22, x1
mov	x19, x0
LFQD_Lloh892:
adr x0, LFQD_l_.str.234
LFQD_Lloh893:
nop
bl Lpatch + (0xa5b0 - PATCH_BASE)
mov	x20, x0
LFQD_Lloh894:
adr x0, LFQD_l_.str.235
LFQD_Lloh895:
nop
bl Lpatch + (0xa5a4 - PATCH_BASE)
mov	x1, x0
mov	x0, x20
bl Lpatch + (0xa5d4 - PATCH_BASE)
mov	x20, x0
LFQD_Lloh896:
adr x1, LFQD_l_.str.258
LFQD_Lloh897:
nop
mov	x0, x19
bl	LFQD_Get
bl	LFQD_Values
mov	x2, x0
LFQD_Lloh898:
adr x1, LFQD_l_.str.257
LFQD_Lloh899:
nop
mov	x0, x20
bl	LFQD_Put
mov	x0, x21
bl	LFQD_Values
mov	x2, x0
LFQD_Lloh900:
adr x1, LFQD_l_.str.259
LFQD_Lloh901:
nop
mov	x0, x20
bl	LFQD_Put
LFQD_Lloh902:
adr x1, LFQD_l_.str.43
LFQD_Lloh903:
nop
mov	x0, x19
bl	LFQD_Original
cbz	x0, LFQD_LBB20_2
mov	x8, x0
mov	x0, x19
mov	x1, x22
mov	x2, x21
blr	x8
LFQD_LBB20_2:
LFQD_Lloh904:
adr x1, LFQD_l_.str.258
LFQD_Lloh905:
nop
mov	x0, x19
bl	LFQD_Get
bl	LFQD_Values
mov	x2, x0
LFQD_Lloh906:
adr x1, LFQD_l_.str.260
LFQD_Lloh907:
nop
mov	x0, x20
bl	LFQD_Put
bl	LFQD_Context
LFQD_Lloh908:
adr x8, LFQD_l_.str.261
LFQD_Lloh909:
nop
LFQD_Lloh910:
adr x1, LFQD_l_.str.41
LFQD_Lloh911:
nop
mov	x3, x0
mov	x0, x8
mov	x2, x19
mov	x4, x20
ldp	x29, x30, [sp, #32]
ldp	x20, x19, [sp, #16]
ldp	x22, x21, [sp], #48
b	LFQD_Emit
.cfi_endproc
.p2align	2
LFQD_BubbleUpdate:
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
LFQD_Lloh912:
adr x0, LFQD_l_.str.234
LFQD_Lloh913:
nop
bl Lpatch + (0xa5b0 - PATCH_BASE)
mov	x20, x0
LFQD_Lloh914:
adr x0, LFQD_l_.str.235
LFQD_Lloh915:
nop
bl Lpatch + (0xa5a4 - PATCH_BASE)
mov	x1, x0
mov	x0, x20
bl Lpatch + (0xa5d4 - PATCH_BASE)
mov	x20, x0
LFQD_Lloh916:
adr x1, LFQD_l_.str.258
LFQD_Lloh917:
nop
mov	x0, x19
bl	LFQD_Get
bl	LFQD_Values
mov	x2, x0
LFQD_Lloh918:
adr x1, LFQD_l_.str.257
LFQD_Lloh919:
nop
mov	x0, x20
bl	LFQD_Put
LFQD_Lloh920:
adr x1, LFQD_l_.str.46
LFQD_Lloh921:
nop
mov	x0, x19
bl	LFQD_Original
cbz	x0, LFQD_LBB21_2
mov	x8, x0
mov	x0, x19
mov	x1, x21
blr	x8
LFQD_LBB21_2:
LFQD_Lloh922:
adr x1, LFQD_l_.str.258
LFQD_Lloh923:
nop
mov	x0, x19
bl	LFQD_Get
bl	LFQD_Values
mov	x2, x0
LFQD_Lloh924:
adr x1, LFQD_l_.str.260
LFQD_Lloh925:
nop
mov	x0, x20
bl	LFQD_Put
LFQD_Lloh926:
adr x0, LFQD_l_.str.282
LFQD_Lloh927:
nop
bl Lpatch + (0xa5a4 - PATCH_BASE)
mov	x1, x0
mov	x0, x19
bl Lpatch + (0xa5d4 - PATCH_BASE)
sxtw	x21, w0
LFQD_Lloh928:
adr x0, LFQD_l_.str.209
LFQD_Lloh929:
nop
bl Lpatch + (0xa5b0 - PATCH_BASE)
mov	x22, x0
LFQD_Lloh930:
adr x0, LFQD_l_.str.221
LFQD_Lloh931:
nop
bl Lpatch + (0xa5a4 - PATCH_BASE)
mov	x1, x0
mov	x0, x22
mov	x2, x21
bl Lpatch + (0xa5d4 - PATCH_BASE)
mov	x2, x0
LFQD_Lloh932:
adr x1, LFQD_l_.str.281
LFQD_Lloh933:
nop
mov	x0, x20
bl	LFQD_Put
bl	LFQD_Context
LFQD_Lloh934:
adr x8, LFQD_l_.str.283
LFQD_Lloh935:
nop
LFQD_Lloh936:
adr x1, LFQD_l_.str.41
LFQD_Lloh937:
nop
mov	x3, x0
mov	x0, x8
mov	x2, x19
mov	x4, x20
ldp	x29, x30, [sp, #32]
ldp	x20, x19, [sp, #16]
ldp	x22, x21, [sp], #48
b	LFQD_Emit
.cfi_endproc
.p2align	2
LFQD_BubbleTap:
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
bl	LFQD_UUID
mov	x21, x0
LFQD_Lloh938:
adr x0, LFQD_l_.str.70
LFQD_Lloh939:
nop
bl Lpatch + (0xa5b0 - PATCH_BASE)
LFQD_Lloh940:
adr x1, LFQD_ContextKey
LFQD_Lloh941:
nop
mov	x2, x21
mov	w3, #769
bl Lpatch + (0xa634 - PATCH_BASE)
LFQD_Lloh942:
adr x1, LFQD_l_.str.258
LFQD_Lloh943:
nop
mov	x0, x20
bl	LFQD_Get
bl	LFQD_Values
mov	x4, x0
LFQD_Lloh944:
adr x0, LFQD_l_.str.284
LFQD_Lloh945:
nop
LFQD_Lloh946:
adr x1, LFQD_l_.str.41
LFQD_Lloh947:
nop
mov	x2, x20
mov	x3, x21
bl	LFQD_Emit
LFQD_Lloh948:
adr x1, LFQD_l_.str.48
LFQD_Lloh949:
nop
mov	x0, x20
bl	LFQD_Original
cbz	x0, LFQD_LBB22_2
mov	x2, x0
mov	x0, x20
mov	x1, x19
ldp	x29, x30, [sp, #32]
ldp	x20, x19, [sp, #16]
ldp	x22, x21, [sp], #48
br	x2
LFQD_LBB22_2:
ldp	x29, x30, [sp, #32]
ldp	x20, x19, [sp, #16]
ldp	x22, x21, [sp], #48
ret
.cfi_endproc
.p2align	2
LFQD_Hidden:
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
mov	x21, x2
mov	x22, x1
mov	x19, x0
LFQD_Lloh950:
adr x1, LFQD_l_.str.258
LFQD_Lloh951:
nop
bl	LFQD_Get
bl	LFQD_Values
mov	x20, x0
LFQD_Lloh952:
adr x0, LFQD_l_.str.282
LFQD_Lloh953:
nop
bl Lpatch + (0xa5a4 - PATCH_BASE)
mov	x1, x0
mov	x0, x19
bl Lpatch + (0xa5d4 - PATCH_BASE)
sxtw	x23, w0
LFQD_Lloh954:
adr x24, LFQD_l_.str.209
LFQD_Lloh955:
nop
mov	x0, x24
bl Lpatch + (0xa5b0 - PATCH_BASE)
mov	x25, x0
LFQD_Lloh956:
adr x26, LFQD_l_.str.221
LFQD_Lloh957:
nop
mov	x0, x26
bl Lpatch + (0xa5a4 - PATCH_BASE)
mov	x1, x0
mov	x0, x25
mov	x2, x23
bl Lpatch + (0xa5d4 - PATCH_BASE)
mov	x2, x0
LFQD_Lloh958:
adr x1, LFQD_l_.str.285
LFQD_Lloh959:
nop
mov	x0, x20
bl	LFQD_Put
sxtw	x23, w21
mov	x0, x24
bl Lpatch + (0xa5b0 - PATCH_BASE)
mov	x24, x0
mov	x0, x26
bl Lpatch + (0xa5a4 - PATCH_BASE)
mov	x1, x0
mov	x0, x24
mov	x2, x23
bl Lpatch + (0xa5d4 - PATCH_BASE)
mov	x2, x0
LFQD_Lloh960:
adr x1, LFQD_l_.str.286
LFQD_Lloh961:
nop
mov	x0, x20
bl	LFQD_Put
LFQD_Lloh962:
adr x1, LFQD_l_.str.51
LFQD_Lloh963:
nop
mov	x0, x19
bl	LFQD_Original
cbz	x0, LFQD_LBB23_2
mov	x8, x0
mov	x0, x19
mov	x1, x22
mov	x2, x21
blr	x8
LFQD_LBB23_2:
LFQD_Lloh964:
adr x0, LFQD_l_.str.282
LFQD_Lloh965:
nop
bl Lpatch + (0xa5a4 - PATCH_BASE)
mov	x1, x0
mov	x0, x19
bl Lpatch + (0xa5d4 - PATCH_BASE)
sxtw	x21, w0
LFQD_Lloh966:
adr x0, LFQD_l_.str.209
LFQD_Lloh967:
nop
bl Lpatch + (0xa5b0 - PATCH_BASE)
mov	x22, x0
LFQD_Lloh968:
adr x0, LFQD_l_.str.221
LFQD_Lloh969:
nop
bl Lpatch + (0xa5a4 - PATCH_BASE)
mov	x1, x0
mov	x0, x22
mov	x2, x21
bl Lpatch + (0xa5d4 - PATCH_BASE)
mov	x2, x0
LFQD_Lloh970:
adr x1, LFQD_l_.str.287
LFQD_Lloh971:
nop
mov	x0, x20
bl	LFQD_Put
bl	LFQD_Context
LFQD_Lloh972:
adr x8, LFQD_l_.str.288
LFQD_Lloh973:
nop
LFQD_Lloh974:
adr x1, LFQD_l_.str.41
LFQD_Lloh975:
nop
mov	x3, x0
mov	x0, x8
mov	x2, x19
mov	x4, x20
ldp	x29, x30, [sp, #64]
ldp	x20, x19, [sp, #48]
ldp	x22, x21, [sp, #32]
ldp	x24, x23, [sp, #16]
ldp	x26, x25, [sp], #80
b	LFQD_Emit
.cfi_endproc
.p2align	2
LFQD_Removed:
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
LFQD_Lloh976:
adr x1, LFQD_l_.str.258
LFQD_Lloh977:
nop
bl	LFQD_Get
bl	LFQD_Values
mov	x20, x0
LFQD_Lloh978:
adr x1, LFQD_l_.str.53
LFQD_Lloh979:
nop
mov	x0, x19
bl	LFQD_Original
cbz	x0, LFQD_LBB24_2
mov	x8, x0
mov	x0, x19
mov	x1, x21
blr	x8
LFQD_LBB24_2:
bl	LFQD_Context
LFQD_Lloh980:
adr x8, LFQD_l_.str.289
LFQD_Lloh981:
nop
LFQD_Lloh982:
adr x1, LFQD_l_.str.41
LFQD_Lloh983:
nop
mov	x3, x0
mov	x0, x8
mov	x2, x19
mov	x4, x20
ldp	x29, x30, [sp, #32]
ldp	x20, x19, [sp, #16]
ldp	x22, x21, [sp], #48
b	LFQD_Emit
.cfi_endproc
.p2align	2
LFQD_Window:
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
LFQD_Lloh984:
adr x1, LFQD_l_.str.55
LFQD_Lloh985:
nop
bl	LFQD_Original
cbz	x0, LFQD_LBB25_2
mov	x8, x0
mov	x0, x19
mov	x1, x20
blr	x8
LFQD_LBB25_2:
LFQD_Lloh986:
adr x1, LFQD_l_.str.258
LFQD_Lloh987:
nop
mov	x0, x19
bl	LFQD_Get
bl	LFQD_Values
mov	x20, x0
LFQD_Lloh988:
adr x1, LFQD_l_.str.291
LFQD_Lloh989:
nop
mov	x0, x19
bl	LFQD_Get
cmp	x0, #0
cset	w21, ne
LFQD_Lloh990:
adr x0, LFQD_l_.str.209
LFQD_Lloh991:
nop
bl Lpatch + (0xa5b0 - PATCH_BASE)
mov	x22, x0
LFQD_Lloh992:
adr x0, LFQD_l_.str.221
LFQD_Lloh993:
nop
bl Lpatch + (0xa5a4 - PATCH_BASE)
mov	x1, x0
mov	x0, x22
mov	x2, x21
bl Lpatch + (0xa5d4 - PATCH_BASE)
mov	x2, x0
LFQD_Lloh994:
adr x1, LFQD_l_.str.290
LFQD_Lloh995:
nop
mov	x0, x20
bl	LFQD_Put
bl	LFQD_Context
LFQD_Lloh996:
adr x8, LFQD_l_.str.292
LFQD_Lloh997:
nop
LFQD_Lloh998:
adr x1, LFQD_l_.str.41
LFQD_Lloh999:
nop
mov	x3, x0
mov	x0, x8
mov	x2, x19
mov	x4, x20
ldp	x29, x30, [sp, #32]
ldp	x20, x19, [sp, #16]
ldp	x22, x21, [sp], #48
b	LFQD_Emit
.cfi_endproc
.p2align	2
LFQD_Released:
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
LFQD_Lloh1000:
adr x1, LFQD_ObjectKey
LFQD_Lloh1001:
nop
bl Lpatch + (0xa628 - PATCH_BASE)
cbz	x0, LFQD_LBB26_2
bl	LFQD_Context
mov	x21, x0
LFQD_Lloh1002:
adr x0, LFQD_l_.str.234
LFQD_Lloh1003:
nop
bl Lpatch + (0xa5b0 - PATCH_BASE)
mov	x22, x0
LFQD_Lloh1004:
adr x0, LFQD_l_.str.235
LFQD_Lloh1005:
nop
bl Lpatch + (0xa5a4 - PATCH_BASE)
mov	x1, x0
mov	x0, x22
bl Lpatch + (0xa5d4 - PATCH_BASE)
mov	x4, x0
LFQD_Lloh1006:
adr x0, LFQD_l_.str.293
LFQD_Lloh1007:
nop
LFQD_Lloh1008:
adr x1, LFQD_l_.str.41
LFQD_Lloh1009:
nop
mov	x2, x20
mov	x3, x21
bl	LFQD_Emit
LFQD_LBB26_2:
LFQD_Lloh1010:
adr x1, LFQD_l_.str.57
LFQD_Lloh1011:
nop
mov	x0, x20
bl	LFQD_Original
cbz	x0, LFQD_LBB26_4
mov	x2, x0
mov	x0, x20
mov	x1, x19
ldp	x29, x30, [sp, #32]
ldp	x20, x19, [sp, #16]
ldp	x22, x21, [sp], #48
br	x2
LFQD_LBB26_4:
ldp	x29, x30, [sp, #32]
ldp	x20, x19, [sp, #16]
ldp	x22, x21, [sp], #48
ret
.cfi_endproc
.p2align	2
LFQD_EntranceCount:
.cfi_startproc
LFQD_Lloh1012:
adr x3, LFQD_l_.str.61
LFQD_Lloh1013:
nop
LFQD_Lloh1014:
adr x4, LFQD_l_.str.58
LFQD_Lloh1015:
nop
b	LFQD_ModelCount
.cfi_endproc
.p2align	2
LFQD_EntranceOrigin:
.cfi_startproc
LFQD_Lloh1016:
adr x3, LFQD_l_.str.63
LFQD_Lloh1017:
nop
LFQD_Lloh1018:
adr x4, LFQD_l_.str.58
LFQD_Lloh1019:
nop
b	LFQD_ModelCount
.cfi_endproc
.p2align	2
LFQD_DataCount:
.cfi_startproc
LFQD_Lloh1020:
adr x3, LFQD_l_.str.65
LFQD_Lloh1021:
nop
LFQD_Lloh1022:
adr x4, LFQD_l_.str.64
LFQD_Lloh1023:
nop
b	LFQD_ModelCount
.cfi_endproc
.p2align	2
LFQD_DataRaw:
.cfi_startproc
LFQD_Lloh1024:
adr x3, LFQD_l_.str.67
LFQD_Lloh1025:
nop
LFQD_Lloh1026:
adr x4, LFQD_l_.str.64
LFQD_Lloh1027:
nop
b	LFQD_ModelCount
.cfi_endproc
.p2align	2
LFQD_BubbleData:
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
mov	x21, x2
mov	x22, x1
mov	x19, x0
LFQD_Lloh1028:
adr x0, LFQD_l_.str.234
LFQD_Lloh1029:
nop
bl Lpatch + (0xa5b0 - PATCH_BASE)
mov	x20, x0
LFQD_Lloh1030:
adr x0, LFQD_l_.str.235
LFQD_Lloh1031:
nop
bl Lpatch + (0xa5a4 - PATCH_BASE)
mov	x1, x0
mov	x0, x20
bl Lpatch + (0xa5d4 - PATCH_BASE)
mov	x20, x0
mov	x0, x19
bl	LFQD_Values
mov	x2, x0
LFQD_Lloh1032:
adr x1, LFQD_l_.str.257
LFQD_Lloh1033:
nop
mov	x0, x20
bl	LFQD_Put
cmp	x21, #0
cset	w23, ne
LFQD_Lloh1034:
adr x24, LFQD_l_.str.209
LFQD_Lloh1035:
nop
mov	x0, x24
bl Lpatch + (0xa5b0 - PATCH_BASE)
mov	x25, x0
LFQD_Lloh1036:
adr x26, LFQD_l_.str.221
LFQD_Lloh1037:
nop
mov	x0, x26
bl Lpatch + (0xa5a4 - PATCH_BASE)
mov	x1, x0
mov	x0, x25
mov	x2, x23
bl Lpatch + (0xa5d4 - PATCH_BASE)
mov	x2, x0
LFQD_Lloh1038:
adr x1, LFQD_l_.str.298
LFQD_Lloh1039:
nop
mov	x0, x20
bl	LFQD_Put
LFQD_Lloh1040:
adr x1, LFQD_l_.str.12
LFQD_Lloh1041:
nop
mov	x0, x21
bl	LFQD_Count
mov	x23, x0
mov	x0, x24
bl Lpatch + (0xa5b0 - PATCH_BASE)
mov	x24, x0
mov	x0, x26
bl Lpatch + (0xa5a4 - PATCH_BASE)
mov	x1, x0
mov	x0, x24
mov	x2, x23
bl Lpatch + (0xa5d4 - PATCH_BASE)
mov	x2, x0
LFQD_Lloh1042:
adr x1, LFQD_l_.str.299
LFQD_Lloh1043:
nop
mov	x0, x20
bl	LFQD_Put
LFQD_Lloh1044:
adr x1, LFQD_l_.str.69
LFQD_Lloh1045:
nop
mov	x0, x19
bl	LFQD_Original
cbz	x0, LFQD_LBB31_2
mov	x8, x0
mov	x0, x19
mov	x1, x22
mov	x2, x21
blr	x8
LFQD_LBB31_2:
mov	x0, x19
bl	LFQD_Values
mov	x2, x0
LFQD_Lloh1046:
adr x1, LFQD_l_.str.260
LFQD_Lloh1047:
nop
mov	x0, x20
bl	LFQD_Put
bl	LFQD_Context
LFQD_Lloh1048:
adr x8, LFQD_l_.str.300
LFQD_Lloh1049:
nop
LFQD_Lloh1050:
adr x1, LFQD_l_.str.64
LFQD_Lloh1051:
nop
mov	x3, x0
mov	x0, x8
mov	x2, x19
mov	x4, x20
ldp	x29, x30, [sp, #64]
ldp	x20, x19, [sp, #48]
ldp	x22, x21, [sp, #32]
ldp	x24, x23, [sp, #16]
ldp	x26, x25, [sp], #80
b	LFQD_Emit
.cfi_endproc
.p2align	2
LFQD_Open:
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
mov	x22, x1
mov	x19, x0
bl	LFQD_Context
mov	x20, x0
LFQD_Lloh1052:
adr x1, LFQD_ContextKey
LFQD_Lloh1053:
nop
mov	x0, x19
mov	x2, x20
mov	w3, #769
bl Lpatch + (0xa634 - PATCH_BASE)
LFQD_Lloh1054:
adr x0, LFQD_l_.str.234
LFQD_Lloh1055:
nop
bl Lpatch + (0xa5b0 - PATCH_BASE)
mov	x23, x0
LFQD_Lloh1056:
adr x0, LFQD_l_.str.235
LFQD_Lloh1057:
nop
bl Lpatch + (0xa5a4 - PATCH_BASE)
mov	x1, x0
mov	x0, x23
bl Lpatch + (0xa5d4 - PATCH_BASE)
mov	x4, x0
LFQD_Lloh1058:
adr x0, LFQD_l_.str.301
LFQD_Lloh1059:
nop
LFQD_Lloh1060:
adr x1, LFQD_l_.str.70
LFQD_Lloh1061:
nop
mov	x2, x19
mov	x3, x20
bl	LFQD_Emit
LFQD_Lloh1062:
adr x1, LFQD_l_.str.72
LFQD_Lloh1063:
nop
mov	x0, x19
bl	LFQD_Original
cbz	x0, LFQD_LBB32_2
mov	x8, x0
mov	x0, x19
mov	x1, x22
mov	x2, x21
blr	x8
LFQD_LBB32_2:
LFQD_Lloh1064:
adr x1, LFQD_l_.str.302
LFQD_Lloh1065:
nop
mov	x0, x19
bl	LFQD_Get
mov	x21, x0
LFQD_Lloh1066:
adr x1, LFQD_PanelKey
LFQD_Lloh1067:
nop
mov	x2, x20
mov	w3, #769
bl Lpatch + (0xa634 - PATCH_BASE)
LFQD_Lloh1068:
adr x0, LFQD_l_.str.234
LFQD_Lloh1069:
nop
bl Lpatch + (0xa5b0 - PATCH_BASE)
mov	x22, x0
LFQD_Lloh1070:
adr x0, LFQD_l_.str.235
LFQD_Lloh1071:
nop
bl Lpatch + (0xa5a4 - PATCH_BASE)
mov	x1, x0
mov	x0, x22
bl Lpatch + (0xa5d4 - PATCH_BASE)
mov	x22, x0
mov	x0, x21
bl	LFQD_Id
mov	x2, x0
LFQD_Lloh1072:
adr x1, LFQD_l_.str.303
LFQD_Lloh1073:
nop
mov	x0, x22
bl	LFQD_Put
LFQD_Lloh1074:
adr x0, LFQD_l_.str.304
LFQD_Lloh1075:
nop
LFQD_Lloh1076:
adr x1, LFQD_l_.str.70
LFQD_Lloh1077:
nop
mov	x2, x19
mov	x3, x20
mov	x4, x22
ldp	x29, x30, [sp, #48]
ldp	x20, x19, [sp, #32]
ldp	x22, x21, [sp, #16]
ldp	x24, x23, [sp], #64
b	LFQD_Emit
.cfi_endproc
.p2align	2
LFQD_Dismiss:
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
mov	x22, x1
mov	x19, x0
LFQD_Lloh1078:
adr x1, LFQD_PanelKey
LFQD_Lloh1079:
nop
mov	x0, x2
bl Lpatch + (0xa628 - PATCH_BASE)
mov	x20, x0
cbnz	x0, LFQD_LBB33_2
LFQD_Lloh1080:
adr x1, LFQD_ContextKey
LFQD_Lloh1081:
nop
mov	x0, x19
bl Lpatch + (0xa628 - PATCH_BASE)
mov	x20, x0
LFQD_LBB33_2:
LFQD_Lloh1082:
adr x0, LFQD_l_.str.234
LFQD_Lloh1083:
nop
bl Lpatch + (0xa5b0 - PATCH_BASE)
mov	x23, x0
LFQD_Lloh1084:
adr x0, LFQD_l_.str.235
LFQD_Lloh1085:
nop
bl Lpatch + (0xa5a4 - PATCH_BASE)
mov	x1, x0
mov	x0, x23
bl Lpatch + (0xa5d4 - PATCH_BASE)
mov	x4, x0
LFQD_Lloh1086:
adr x0, LFQD_l_.str.305
LFQD_Lloh1087:
nop
LFQD_Lloh1088:
adr x1, LFQD_l_.str.70
LFQD_Lloh1089:
nop
mov	x2, x19
mov	x3, x20
bl	LFQD_Emit
LFQD_Lloh1090:
adr x1, LFQD_l_.str.74
LFQD_Lloh1091:
nop
mov	x0, x19
bl	LFQD_Original
cbz	x0, LFQD_LBB33_4
mov	x8, x0
mov	x0, x19
mov	x1, x22
mov	x2, x21
blr	x8
LFQD_LBB33_4:
LFQD_Lloh1092:
adr x0, LFQD_l_.str.234
LFQD_Lloh1093:
nop
bl Lpatch + (0xa5b0 - PATCH_BASE)
mov	x21, x0
LFQD_Lloh1094:
adr x0, LFQD_l_.str.235
LFQD_Lloh1095:
nop
bl Lpatch + (0xa5a4 - PATCH_BASE)
mov	x1, x0
mov	x0, x21
bl Lpatch + (0xa5d4 - PATCH_BASE)
LFQD_Lloh1096:
adr x8, LFQD_l_.str.306
LFQD_Lloh1097:
nop
LFQD_Lloh1098:
adr x1, LFQD_l_.str.70
LFQD_Lloh1099:
nop
mov	x4, x0
mov	x0, x8
mov	x2, x19
mov	x3, x20
ldp	x29, x30, [sp, #48]
ldp	x20, x19, [sp, #32]
ldp	x22, x21, [sp, #16]
ldp	x24, x23, [sp], #64
b	LFQD_Emit
.cfi_endproc
.p2align	2
LFQD_Appeared:
.cfi_startproc
LFQD_Lloh1100:
adr x3, LFQD_l_.str.77
LFQD_Lloh1101:
nop
LFQD_Lloh1102:
adr x4, LFQD_l_.str.307
LFQD_Lloh1103:
nop
b	LFQD_Panel
.cfi_endproc
.p2align	2
LFQD_WillDisappear:
.cfi_startproc
LFQD_Lloh1104:
adr x3, LFQD_l_.str.79
LFQD_Lloh1105:
nop
LFQD_Lloh1106:
adr x4, LFQD_l_.str.308
LFQD_Lloh1107:
nop
b	LFQD_Panel
.cfi_endproc
.p2align	2
LFQD_Disappeared:
.cfi_startproc
LFQD_Lloh1108:
adr x3, LFQD_l_.str.81
LFQD_Lloh1109:
nop
LFQD_Lloh1110:
adr x4, LFQD_l_.str.309
LFQD_Lloh1111:
nop
b	LFQD_Panel
.cfi_endproc
.p2align	2
LFQD_Commit:
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
mov	x20, x5
mov	x21, x4
mov	x22, x3
mov	x23, x2
mov	x25, x1
mov	x19, x0
LFQD_Lloh1112:
adr x0, LFQD_l_.str.234
LFQD_Lloh1113:
nop
bl Lpatch + (0xa5b0 - PATCH_BASE)
mov	x24, x0
LFQD_Lloh1114:
adr x0, LFQD_l_.str.235
LFQD_Lloh1115:
nop
bl Lpatch + (0xa5a4 - PATCH_BASE)
mov	x1, x0
mov	x0, x24
bl Lpatch + (0xa5d4 - PATCH_BASE)
mov	x24, x0
mov	x0, x23
bl	LFQD_Pseudonym
mov	x2, x0
LFQD_Lloh1116:
adr x1, LFQD_l_.str.277
LFQD_Lloh1117:
nop
mov	x0, x24
bl	LFQD_Put
mov	x0, x22
bl	LFQD_Pseudonym
mov	x2, x0
LFQD_Lloh1118:
adr x1, LFQD_l_.str.310
LFQD_Lloh1119:
nop
mov	x0, x24
bl	LFQD_Put
LFQD_Lloh1120:
adr x26, LFQD_l_.str.209
LFQD_Lloh1121:
nop
mov	x0, x26
bl Lpatch + (0xa5b0 - PATCH_BASE)
mov	x27, x0
LFQD_Lloh1122:
adr x28, LFQD_l_.str.221
LFQD_Lloh1123:
nop
mov	x0, x28
bl Lpatch + (0xa5a4 - PATCH_BASE)
mov	x1, x0
mov	x0, x27
mov	x2, x21
bl Lpatch + (0xa5d4 - PATCH_BASE)
mov	x2, x0
LFQD_Lloh1124:
adr x1, LFQD_l_.str.311
LFQD_Lloh1125:
nop
mov	x0, x24
bl	LFQD_Put
mov	x0, x26
bl Lpatch + (0xa5b0 - PATCH_BASE)
mov	x26, x0
mov	x0, x28
bl Lpatch + (0xa5a4 - PATCH_BASE)
mov	x1, x0
mov	x0, x26
mov	x2, x20
bl Lpatch + (0xa5d4 - PATCH_BASE)
mov	x2, x0
LFQD_Lloh1126:
adr x1, LFQD_l_.str.12
LFQD_Lloh1127:
nop
mov	x0, x24
bl	LFQD_Put
LFQD_Lloh1128:
adr x0, LFQD_l_.str.192
LFQD_Lloh1129:
nop
bl Lpatch + (0xa5b0 - PATCH_BASE)
mov	x26, x0
LFQD_Lloh1130:
adr x0, LFQD_l_.str.215
LFQD_Lloh1131:
nop
bl Lpatch + (0xa5a4 - PATCH_BASE)
mov	x1, x0
LFQD_Lloh1132:
adr x2, LFQD_l_.str.312
LFQD_Lloh1133:
nop
mov	x0, x26
bl Lpatch + (0xa5d4 - PATCH_BASE)
mov	x2, x0
LFQD_Lloh1134:
adr x1, LFQD_l_.str.295
LFQD_Lloh1135:
nop
mov	x0, x24
bl	LFQD_Put
bl	LFQD_Context
mov	x3, x0
LFQD_Lloh1136:
adr x0, LFQD_l_.str.313
LFQD_Lloh1137:
nop
LFQD_Lloh1138:
adr x1, LFQD_l_.str.82
LFQD_Lloh1139:
nop
mov	x2, x19
mov	x4, x24
bl	LFQD_Emit
LFQD_Lloh1140:
adr x1, LFQD_l_.str.85
LFQD_Lloh1141:
nop
mov	x0, x19
bl	LFQD_Original
cbz	x0, LFQD_LBB37_2
mov	x8, x0
mov	x0, x19
mov	x1, x25
mov	x2, x23
mov	x3, x22
mov	x4, x21
mov	x5, x20
blr	x8
LFQD_LBB37_2:
bl	LFQD_Context
LFQD_Lloh1142:
adr x8, LFQD_l_.str.314
LFQD_Lloh1143:
nop
LFQD_Lloh1144:
adr x1, LFQD_l_.str.82
LFQD_Lloh1145:
nop
mov	x3, x0
mov	x0, x8
mov	x2, x19
mov	x4, x24
ldp	x29, x30, [sp, #80]
ldp	x20, x19, [sp, #64]
ldp	x22, x21, [sp, #48]
ldp	x24, x23, [sp, #32]
ldp	x26, x25, [sp, #16]
ldp	x28, x27, [sp], #96
b	LFQD_Emit
.cfi_endproc
.p2align	2
LFQD_Cache:
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
mov	x21, x3
mov	x22, x2
mov	x23, x1
mov	x19, x0
LFQD_Lloh1146:
adr x0, LFQD_l_.str.234
LFQD_Lloh1147:
nop
bl Lpatch + (0xa5b0 - PATCH_BASE)
mov	x20, x0
LFQD_Lloh1148:
adr x0, LFQD_l_.str.235
LFQD_Lloh1149:
nop
bl Lpatch + (0xa5a4 - PATCH_BASE)
mov	x1, x0
mov	x0, x20
bl Lpatch + (0xa5d4 - PATCH_BASE)
mov	x20, x0
mov	x0, x22
bl	LFQD_Pseudonym
mov	x2, x0
LFQD_Lloh1150:
adr x1, LFQD_l_.str.277
LFQD_Lloh1151:
nop
mov	x0, x20
bl	LFQD_Put
cmp	x21, #0
cset	w24, ne
LFQD_Lloh1152:
adr x0, LFQD_l_.str.209
LFQD_Lloh1153:
nop
bl Lpatch + (0xa5b0 - PATCH_BASE)
mov	x25, x0
LFQD_Lloh1154:
adr x0, LFQD_l_.str.221
LFQD_Lloh1155:
nop
bl Lpatch + (0xa5a4 - PATCH_BASE)
mov	x1, x0
mov	x0, x25
mov	x2, x24
bl Lpatch + (0xa5d4 - PATCH_BASE)
mov	x2, x0
LFQD_Lloh1156:
adr x1, LFQD_l_.str.315
LFQD_Lloh1157:
nop
mov	x0, x20
bl	LFQD_Put
LFQD_Lloh1158:
adr x0, LFQD_l_.str.192
LFQD_Lloh1159:
nop
bl Lpatch + (0xa5b0 - PATCH_BASE)
mov	x24, x0
LFQD_Lloh1160:
adr x0, LFQD_l_.str.215
LFQD_Lloh1161:
nop
bl Lpatch + (0xa5a4 - PATCH_BASE)
mov	x1, x0
LFQD_Lloh1162:
adr x2, LFQD_l_.str.316
LFQD_Lloh1163:
nop
mov	x0, x24
bl Lpatch + (0xa5d4 - PATCH_BASE)
mov	x2, x0
LFQD_Lloh1164:
adr x1, LFQD_l_.str.11
LFQD_Lloh1165:
nop
mov	x0, x20
bl	LFQD_Put
LFQD_Lloh1166:
adr x1, LFQD_l_.str.89
LFQD_Lloh1167:
nop
mov	x0, x19
bl	LFQD_Original
cbz	x0, LFQD_LBB38_2
mov	x8, x0
mov	x0, x19
mov	x1, x23
mov	x2, x22
mov	x3, x21
blr	x8
LFQD_LBB38_2:
LFQD_Lloh1168:
adr x0, LFQD_l_.str.192
LFQD_Lloh1169:
nop
bl Lpatch + (0xa5b0 - PATCH_BASE)
mov	x21, x0
LFQD_Lloh1170:
adr x0, LFQD_l_.str.215
LFQD_Lloh1171:
nop
bl Lpatch + (0xa5a4 - PATCH_BASE)
mov	x1, x0
LFQD_Lloh1172:
adr x2, LFQD_l_.str.317
LFQD_Lloh1173:
nop
mov	x0, x21
bl Lpatch + (0xa5d4 - PATCH_BASE)
mov	x2, x0
LFQD_Lloh1174:
adr x1, LFQD_l_.str.150
LFQD_Lloh1175:
nop
mov	x0, x20
bl	LFQD_Put
bl	LFQD_Context
LFQD_Lloh1176:
adr x8, LFQD_l_.str.318
LFQD_Lloh1177:
nop
LFQD_Lloh1178:
adr x1, LFQD_l_.str.86
LFQD_Lloh1179:
nop
mov	x3, x0
mov	x0, x8
mov	x2, x19
mov	x4, x20
ldp	x29, x30, [sp, #64]
ldp	x20, x19, [sp, #48]
ldp	x22, x21, [sp, #32]
ldp	x24, x23, [sp, #16]
ldp	x26, x25, [sp], #80
b	LFQD_Emit
.cfi_endproc
.p2align	2
LFQD_RequestInit:
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
mov	x21, x3
mov	x20, x2
mov	x22, x1
mov	x19, x0
LFQD_Lloh1180:
adr x1, LFQD_l_.str.93
LFQD_Lloh1181:
nop
bl	LFQD_Original
cbz	x0, LFQD_LBB39_2
mov	x8, x0
mov	x0, x19
mov	x1, x22
mov	x2, x20
mov	x3, x21
blr	x8
mov	x19, x0
LFQD_LBB39_2:
LFQD_Lloh1182:
adr x1, LFQD_l_.str.320
LFQD_Lloh1183:
nop
mov	x0, x20
bl	LFQD_Get
LFQD_Lloh1184:
adr x1, LFQD_l_.str.326
LFQD_Lloh1185:
nop
bl	LFQD_Get
mov	x21, x0
LFQD_Lloh1186:
adr x1, LFQD_l_.str.192
LFQD_Lloh1187:
nop
bl	LFQD_Kind
cbz	w0, LFQD_LBB39_8
LFQD_Lloh1188:
adr x0, LFQD_l_.str.10
LFQD_Lloh1189:
nop
bl Lpatch + (0xa5a4 - PATCH_BASE)
mov	x22, x0
LFQD_Lloh1190:
adr x0, LFQD_l_.str.192
LFQD_Lloh1191:
nop
bl Lpatch + (0xa5b0 - PATCH_BASE)
mov	x23, x0
LFQD_Lloh1192:
adr x0, LFQD_l_.str.215
LFQD_Lloh1193:
nop
bl Lpatch + (0xa5a4 - PATCH_BASE)
mov	x1, x0
LFQD_Lloh1194:
adr x2, LFQD_l_.str.327
LFQD_Lloh1195:
nop
mov	x0, x23
bl Lpatch + (0xa5d4 - PATCH_BASE)
mov	x2, x0
mov	x0, x21
mov	x1, x22
bl Lpatch + (0xa5d4 - PATCH_BASE)
cbz	w0, LFQD_LBB39_5
LFQD_Lloh1196:
adr x23, LFQD_l_.str.328
LFQD_Lloh1197:
nop
cbnz	x19, LFQD_LBB39_6
b	LFQD_LBB39_8
LFQD_LBB39_5:
LFQD_Lloh1198:
adr x0, LFQD_l_.str.10
LFQD_Lloh1199:
nop
bl Lpatch + (0xa5a4 - PATCH_BASE)
mov	x22, x0
LFQD_Lloh1200:
adr x0, LFQD_l_.str.192
LFQD_Lloh1201:
nop
bl Lpatch + (0xa5b0 - PATCH_BASE)
mov	x23, x0
LFQD_Lloh1202:
adr x0, LFQD_l_.str.215
LFQD_Lloh1203:
nop
bl Lpatch + (0xa5a4 - PATCH_BASE)
mov	x1, x0
LFQD_Lloh1204:
adr x2, LFQD_l_.str.329
LFQD_Lloh1205:
nop
mov	x0, x23
bl Lpatch + (0xa5d4 - PATCH_BASE)
mov	x2, x0
mov	x0, x21
mov	x1, x22
bl Lpatch + (0xa5d4 - PATCH_BASE)
LFQD_Lloh1206:
adr x8, LFQD_l_.str.330
LFQD_Lloh1207:
nop
cmp	w0, #0
csel	x23, xzr, x8, eq
cbz	x19, LFQD_LBB39_8
LFQD_LBB39_6:
cbz	x23, LFQD_LBB39_8
LFQD_Lloh1208:
adr x0, LFQD_l_.str.234
LFQD_Lloh1209:
nop
bl Lpatch + (0xa5b0 - PATCH_BASE)
mov	x21, x0
LFQD_Lloh1210:
adr x0, LFQD_l_.str.235
LFQD_Lloh1211:
nop
bl Lpatch + (0xa5a4 - PATCH_BASE)
mov	x1, x0
mov	x0, x21
bl Lpatch + (0xa5d4 - PATCH_BASE)
mov	x21, x0
bl	LFQD_UUID
mov	x2, x0
LFQD_Lloh1212:
adr x1, LFQD_l_.str.319
LFQD_Lloh1213:
nop
mov	x0, x21
bl	LFQD_Put
bl	LFQD_Context
mov	x2, x0
LFQD_Lloh1214:
adr x1, LFQD_l_.str.238
LFQD_Lloh1215:
nop
mov	x0, x21
bl	LFQD_Put
LFQD_Lloh1216:
adr x24, LFQD_l_.str.192
LFQD_Lloh1217:
nop
mov	x0, x24
bl Lpatch + (0xa5b0 - PATCH_BASE)
mov	x25, x0
LFQD_Lloh1218:
adr x26, LFQD_l_.str.215
LFQD_Lloh1219:
nop
mov	x0, x26
bl Lpatch + (0xa5a4 - PATCH_BASE)
mov	x1, x0
mov	x0, x25
mov	x2, x23
bl Lpatch + (0xa5d4 - PATCH_BASE)
mov	x2, x0
LFQD_Lloh1220:
adr x1, LFQD_l_.str.195
LFQD_Lloh1221:
nop
mov	x0, x21
bl	LFQD_Put
mov	x0, x24
bl Lpatch + (0xa5b0 - PATCH_BASE)
mov	x23, x0
mov	x0, x26
bl Lpatch + (0xa5a4 - PATCH_BASE)
mov	x1, x0
LFQD_Lloh1222:
adr x2, LFQD_l_.str.321
LFQD_Lloh1223:
nop
mov	x0, x23
bl Lpatch + (0xa5d4 - PATCH_BASE)
mov	x2, x0
LFQD_Lloh1224:
adr x1, LFQD_l_.str.320
LFQD_Lloh1225:
nop
mov	x0, x21
bl	LFQD_Put
bl	LFQD_Clock
mov	x2, x0
LFQD_Lloh1226:
adr x1, LFQD_l_.str.322
LFQD_Lloh1227:
nop
mov	x0, x21
bl	LFQD_Put
bl	LFQD_Lock
mov	x23, x0
LFQD_Lloh1228:
adr x0, LFQD_l_.str
LFQD_Lloh1229:
nop
bl Lpatch + (0xa5a4 - PATCH_BASE)
mov	x1, x0
mov	x0, x23
bl Lpatch + (0xa5d4 - PATCH_BASE)
LFQD_Lloh1230:
adr x24, LFQD_l_.str.70
LFQD_Lloh1231:
nop
mov	x0, x24
bl Lpatch + (0xa5b0 - PATCH_BASE)
LFQD_Lloh1232:
adr x25, LFQD_StateKey
LFQD_Lloh1233:
nop
mov	x1, x25
bl Lpatch + (0xa628 - PATCH_BASE)
LFQD_Lloh1234:
adr x26, LFQD_l_.str.323
LFQD_Lloh1235:
nop
mov	x1, x26
bl	LFQD_At
mov	x27, x0
LFQD_Lloh1236:
adr x0, LFQD_l_.str.143
LFQD_Lloh1237:
nop
bl Lpatch + (0xa5a4 - PATCH_BASE)
mov	x1, x0
mov	x0, x27
bl Lpatch + (0xa5d4 - PATCH_BASE)
mov	x27, x0
mov	x0, x24
bl Lpatch + (0xa5b0 - PATCH_BASE)
mov	x1, x25
bl Lpatch + (0xa628 - PATCH_BASE)
mov	x24, x0
LFQD_Lloh1238:
adr x25, LFQD_l_.str.209
LFQD_Lloh1239:
nop
mov	x0, x25
bl Lpatch + (0xa5b0 - PATCH_BASE)
mov	x28, x0
LFQD_Lloh1240:
adr x22, LFQD_l_.str.221
LFQD_Lloh1241:
nop
mov	x0, x22
bl Lpatch + (0xa5a4 - PATCH_BASE)
mov	x1, x0
add	x2, x27, #1
mov	x0, x28
bl Lpatch + (0xa5d4 - PATCH_BASE)
mov	x2, x0
mov	x0, x24
mov	x1, x26
bl	LFQD_Put
mov	x0, x25
bl Lpatch + (0xa5b0 - PATCH_BASE)
mov	x24, x0
mov	x0, x22
bl Lpatch + (0xa5a4 - PATCH_BASE)
mov	x1, x0
add	x2, x27, #1
mov	x0, x24
bl Lpatch + (0xa5d4 - PATCH_BASE)
mov	x2, x0
LFQD_Lloh1242:
adr x1, LFQD_l_.str.324
LFQD_Lloh1243:
nop
mov	x0, x21
bl	LFQD_Put
LFQD_Lloh1244:
adr x0, LFQD_l_.str.6
LFQD_Lloh1245:
nop
bl Lpatch + (0xa5a4 - PATCH_BASE)
mov	x1, x0
mov	x0, x23
bl Lpatch + (0xa5d4 - PATCH_BASE)
LFQD_Lloh1246:
adr x22, LFQD_RequestKey
LFQD_Lloh1247:
nop
mov	x0, x19
mov	x1, x22
mov	x2, x21
mov	w3, #769
bl Lpatch + (0xa634 - PATCH_BASE)
mov	x0, x20
mov	x1, x22
mov	x2, x21
mov	w3, #769
bl Lpatch + (0xa634 - PATCH_BASE)
mov	x0, x21
LFQD_Lloh1248:
adr x1, LFQD_l_.str.238
LFQD_Lloh1249:
nop
bl	LFQD_At
mov	x3, x0
LFQD_Lloh1250:
adr x0, LFQD_l_.str.325
LFQD_Lloh1251:
nop
LFQD_Lloh1252:
adr x1, LFQD_l_.str.90
LFQD_Lloh1253:
nop
mov	x2, x19
mov	x4, x21
bl	LFQD_Emit
LFQD_LBB39_8:
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
LFQD_RequestSend:
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
mov	x19, x1
mov	x20, x0
LFQD_Lloh1254:
adr x1, LFQD_RequestKey
LFQD_Lloh1255:
nop
bl Lpatch + (0xa628 - PATCH_BASE)
cbz	x0, LFQD_LBB40_2
mov	x21, x0
bl	LFQD_Lock
mov	x26, x0
LFQD_Lloh1256:
adr x0, LFQD_l_.str
LFQD_Lloh1257:
nop
bl Lpatch + (0xa5a4 - PATCH_BASE)
mov	x1, x0
mov	x0, x26
bl Lpatch + (0xa5d4 - PATCH_BASE)
LFQD_Lloh1258:
adr x22, LFQD_SendsKey
LFQD_Lloh1259:
nop
mov	x0, x20
mov	x1, x22
bl Lpatch + (0xa628 - PATCH_BASE)
mov	x23, x0
LFQD_Lloh1260:
adr x0, LFQD_l_.str.143
LFQD_Lloh1261:
nop
bl Lpatch + (0xa5a4 - PATCH_BASE)
mov	x1, x0
mov	x0, x23
bl Lpatch + (0xa5d4 - PATCH_BASE)
mov	x25, x0
LFQD_Lloh1262:
adr x23, LFQD_l_.str.209
LFQD_Lloh1263:
nop
mov	x0, x23
bl Lpatch + (0xa5b0 - PATCH_BASE)
mov	x27, x0
LFQD_Lloh1264:
adr x24, LFQD_l_.str.221
LFQD_Lloh1265:
nop
mov	x0, x24
bl Lpatch + (0xa5a4 - PATCH_BASE)
mov	x1, x0
add	x2, x25, #1
mov	x0, x27
bl Lpatch + (0xa5d4 - PATCH_BASE)
mov	x2, x0
mov	x0, x20
mov	x1, x22
mov	w3, #769
bl Lpatch + (0xa634 - PATCH_BASE)
LFQD_Lloh1266:
adr x0, LFQD_l_.str.2
LFQD_Lloh1267:
nop
bl Lpatch + (0xa5a4 - PATCH_BASE)
mov	x1, x0
mov	x0, x21
bl Lpatch + (0xa5d4 - PATCH_BASE)
mov	x22, x0
mov	x0, x23
bl Lpatch + (0xa5b0 - PATCH_BASE)
mov	x27, x0
mov	x0, x24
bl Lpatch + (0xa5a4 - PATCH_BASE)
mov	x1, x0
add	x2, x25, #1
mov	x0, x27
bl Lpatch + (0xa5d4 - PATCH_BASE)
mov	x2, x0
LFQD_Lloh1268:
adr x1, LFQD_l_.str.331
LFQD_Lloh1269:
nop
mov	x0, x22
bl	LFQD_Put
LFQD_Lloh1270:
adr x0, LFQD_l_.str.6
LFQD_Lloh1271:
nop
bl Lpatch + (0xa5a4 - PATCH_BASE)
mov	x1, x0
mov	x0, x26
bl Lpatch + (0xa5d4 - PATCH_BASE)
LFQD_Lloh1272:
adr x0, LFQD_l_.str.192
LFQD_Lloh1273:
nop
bl Lpatch + (0xa5b0 - PATCH_BASE)
mov	x26, x0
LFQD_Lloh1274:
adr x0, LFQD_l_.str.215
LFQD_Lloh1275:
nop
bl Lpatch + (0xa5a4 - PATCH_BASE)
mov	x1, x0
LFQD_Lloh1276:
adr x2, LFQD_l_.str.332
LFQD_Lloh1277:
nop
mov	x0, x26
bl Lpatch + (0xa5d4 - PATCH_BASE)
mov	x2, x0
LFQD_Lloh1278:
adr x1, LFQD_l_.str.11
LFQD_Lloh1279:
nop
mov	x0, x22
bl	LFQD_Put
cmp	x25, #0
cset	w25, gt
mov	x0, x23
bl Lpatch + (0xa5b0 - PATCH_BASE)
mov	x23, x0
mov	x0, x24
bl Lpatch + (0xa5a4 - PATCH_BASE)
mov	x1, x0
mov	x0, x23
mov	x2, x25
bl Lpatch + (0xa5d4 - PATCH_BASE)
mov	x2, x0
LFQD_Lloh1280:
adr x1, LFQD_l_.str.333
LFQD_Lloh1281:
nop
mov	x0, x22
bl	LFQD_Put
LFQD_Lloh1282:
adr x1, LFQD_l_.str.238
LFQD_Lloh1283:
nop
mov	x0, x21
bl	LFQD_At
mov	x3, x0
LFQD_Lloh1284:
adr x0, LFQD_l_.str.334
LFQD_Lloh1285:
nop
LFQD_Lloh1286:
adr x1, LFQD_l_.str.90
LFQD_Lloh1287:
nop
mov	x2, x20
mov	x4, x22
bl	LFQD_Emit
LFQD_Lloh1288:
adr x0, LFQD_l_.str.5
LFQD_Lloh1289:
nop
bl Lpatch + (0xa5a4 - PATCH_BASE)
mov	x1, x0
mov	x0, x22
bl Lpatch + (0xa5d4 - PATCH_BASE)
LFQD_LBB40_2:
LFQD_Lloh1290:
adr x1, LFQD_l_.str.95
LFQD_Lloh1291:
nop
mov	x0, x20
bl	LFQD_Original
cbz	x0, LFQD_LBB40_4
mov	x2, x0
mov	x0, x20
mov	x1, x19
ldp	x29, x30, [sp, #80]
ldp	x20, x19, [sp, #64]
ldp	x22, x21, [sp, #48]
ldp	x24, x23, [sp, #32]
ldp	x26, x25, [sp, #16]
ldp	x28, x27, [sp], #96
br	x2
LFQD_LBB40_4:
ldp	x29, x30, [sp, #80]
ldp	x20, x19, [sp, #64]
ldp	x22, x21, [sp, #48]
ldp	x24, x23, [sp, #32]
ldp	x26, x25, [sp, #16]
ldp	x28, x27, [sp], #96
ret
.cfi_endproc
.p2align	2
LFQD_RequestCancel:
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
LFQD_Lloh1292:
adr x1, LFQD_RequestKey
LFQD_Lloh1293:
nop
bl Lpatch + (0xa628 - PATCH_BASE)
cbz	x0, LFQD_LBB41_2
mov	x21, x0
LFQD_Lloh1294:
adr x1, LFQD_l_.str.238
LFQD_Lloh1295:
nop
bl	LFQD_At
mov	x3, x0
LFQD_Lloh1296:
adr x0, LFQD_l_.str.335
LFQD_Lloh1297:
nop
LFQD_Lloh1298:
adr x1, LFQD_l_.str.90
LFQD_Lloh1299:
nop
mov	x2, x20
mov	x4, x21
bl	LFQD_Emit
LFQD_LBB41_2:
LFQD_Lloh1300:
adr x1, LFQD_l_.str.97
LFQD_Lloh1301:
nop
mov	x0, x20
bl	LFQD_Original
cbz	x0, LFQD_LBB41_4
mov	x2, x0
mov	x0, x20
mov	x1, x19
ldp	x29, x30, [sp, #32]
ldp	x20, x19, [sp, #16]
ldp	x22, x21, [sp], #48
br	x2
LFQD_LBB41_4:
ldp	x29, x30, [sp, #32]
ldp	x20, x19, [sp, #16]
ldp	x22, x21, [sp], #48
ret
.cfi_endproc
.p2align	2
LFQD_RequestComplete:
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
mov	x19, x1
mov	x20, x0
LFQD_Lloh1302:
adr x1, LFQD_RequestKey
LFQD_Lloh1303:
nop
bl Lpatch + (0xa628 - PATCH_BASE)
cbz	x0, LFQD_LBB42_2
mov	x22, x0
LFQD_Lloh1304:
adr x0, LFQD_l_.str.2
LFQD_Lloh1305:
nop
bl Lpatch + (0xa5a4 - PATCH_BASE)
mov	x1, x0
mov	x0, x22
bl Lpatch + (0xa5d4 - PATCH_BASE)
mov	x21, x0
LFQD_Lloh1306:
adr x1, LFQD_l_.str.336
LFQD_Lloh1307:
nop
mov	x0, x20
bl	LFQD_Get
mov	x23, x0
cmp	x0, #0
cset	w24, ne
LFQD_Lloh1308:
adr x25, LFQD_l_.str.209
LFQD_Lloh1309:
nop
mov	x0, x25
bl Lpatch + (0xa5b0 - PATCH_BASE)
mov	x26, x0
LFQD_Lloh1310:
adr x27, LFQD_l_.str.221
LFQD_Lloh1311:
nop
mov	x0, x27
bl Lpatch + (0xa5a4 - PATCH_BASE)
mov	x1, x0
mov	x0, x26
mov	x2, x24
bl Lpatch + (0xa5d4 - PATCH_BASE)
mov	x2, x0
LFQD_Lloh1312:
adr x1, LFQD_l_.str.337
LFQD_Lloh1313:
nop
mov	x0, x21
bl	LFQD_Put
LFQD_Lloh1314:
adr x1, LFQD_l_.str.229
LFQD_Lloh1315:
nop
mov	x0, x23
bl	LFQD_Count
mov	x23, x0
mov	x0, x25
bl Lpatch + (0xa5b0 - PATCH_BASE)
mov	x24, x0
mov	x0, x27
bl Lpatch + (0xa5a4 - PATCH_BASE)
mov	x1, x0
mov	x0, x24
mov	x2, x23
bl Lpatch + (0xa5d4 - PATCH_BASE)
mov	x2, x0
LFQD_Lloh1316:
adr x1, LFQD_l_.str.338
LFQD_Lloh1317:
nop
mov	x0, x21
bl	LFQD_Put
LFQD_Lloh1318:
adr x0, LFQD_l_.str.192
LFQD_Lloh1319:
nop
bl Lpatch + (0xa5b0 - PATCH_BASE)
mov	x23, x0
LFQD_Lloh1320:
adr x0, LFQD_l_.str.215
LFQD_Lloh1321:
nop
bl Lpatch + (0xa5a4 - PATCH_BASE)
mov	x1, x0
LFQD_Lloh1322:
adr x2, LFQD_l_.str.339
LFQD_Lloh1323:
nop
mov	x0, x23
bl Lpatch + (0xa5d4 - PATCH_BASE)
mov	x2, x0
LFQD_Lloh1324:
adr x1, LFQD_l_.str.11
LFQD_Lloh1325:
nop
mov	x0, x21
bl	LFQD_Put
LFQD_Lloh1326:
adr x1, LFQD_l_.str.238
LFQD_Lloh1327:
nop
mov	x0, x22
bl	LFQD_At
mov	x3, x0
LFQD_Lloh1328:
adr x0, LFQD_l_.str.340
LFQD_Lloh1329:
nop
LFQD_Lloh1330:
adr x1, LFQD_l_.str.90
LFQD_Lloh1331:
nop
mov	x2, x20
mov	x4, x21
bl	LFQD_Emit
LFQD_Lloh1332:
adr x0, LFQD_l_.str.5
LFQD_Lloh1333:
nop
bl Lpatch + (0xa5a4 - PATCH_BASE)
mov	x1, x0
mov	x0, x21
bl Lpatch + (0xa5d4 - PATCH_BASE)
LFQD_LBB42_2:
LFQD_Lloh1334:
adr x1, LFQD_l_.str.99
LFQD_Lloh1335:
nop
mov	x0, x20
bl	LFQD_Original
cbz	x0, LFQD_LBB42_4
mov	x2, x0
mov	x0, x20
mov	x1, x19
ldp	x29, x30, [sp, #80]
ldp	x20, x19, [sp, #64]
ldp	x22, x21, [sp, #48]
ldp	x24, x23, [sp, #32]
ldp	x26, x25, [sp, #16]
ldp	x28, x27, [sp], #96
br	x2
LFQD_LBB42_4:
ldp	x29, x30, [sp, #80]
ldp	x20, x19, [sp, #64]
ldp	x22, x21, [sp, #48]
ldp	x24, x23, [sp, #32]
ldp	x26, x25, [sp, #16]
ldp	x28, x27, [sp], #96
ret
.cfi_endproc
.p2align	2
LFQD_Response:
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
mov	x26, x3
mov	x22, x2
mov	x23, x1
mov	x19, x0
LFQD_Lloh1336:
adr x1, LFQD_RequestKey
LFQD_Lloh1337:
nop
bl Lpatch + (0xa628 - PATCH_BASE)
mov	x20, x0
LFQD_Lloh1338:
adr x1, LFQD_l_.str.101
LFQD_Lloh1339:
nop
mov	x0, x19
bl	LFQD_Original
mov	x24, x0
LFQD_Lloh1340:
adr x0, LFQD_l_.str.341
LFQD_Lloh1341:
nop
bl Lpatch + (0xa5b0 - PATCH_BASE)
mov	x21, x0
LFQD_Lloh1342:
adr x0, LFQD_l_.str.342
LFQD_Lloh1343:
nop
bl Lpatch + (0xa5a4 - PATCH_BASE)
mov	x1, x0
mov	x0, x21
bl Lpatch + (0xa5d4 - PATCH_BASE)
mov	x25, x0
LFQD_Lloh1344:
adr x1, LFQD_ContextKey
LFQD_Lloh1345:
nop
bl Lpatch + (0xa628 - PATCH_BASE)
mov	x21, x0
LFQD_Lloh1346:
adr x0, LFQD_l_.str.280
LFQD_Lloh1347:
nop
bl Lpatch + (0xa5a4 - PATCH_BASE)
mov	x1, x0
mov	x0, x21
bl Lpatch + (0xa5d4 - PATCH_BASE)
cbz	x20, LFQD_LBB43_7
stp	x25, x21, [sp, #8]
stp	x24, x23, [sp, #24]
str	x26, [sp, #40]
LFQD_Lloh1348:
adr x0, LFQD_l_.str.2
LFQD_Lloh1349:
nop
bl Lpatch + (0xa5a4 - PATCH_BASE)
mov	x1, x0
mov	x0, x20
bl Lpatch + (0xa5d4 - PATCH_BASE)
mov	x27, x0
cmp	x22, #0
cset	w24, ne
LFQD_Lloh1350:
adr x23, LFQD_l_.str.209
LFQD_Lloh1351:
nop
mov	x0, x23
bl Lpatch + (0xa5b0 - PATCH_BASE)
mov	x28, x0
LFQD_Lloh1352:
adr x21, LFQD_l_.str.221
LFQD_Lloh1353:
nop
mov	x0, x21
bl Lpatch + (0xa5a4 - PATCH_BASE)
mov	x1, x0
mov	x0, x28
mov	x2, x24
bl Lpatch + (0xa5d4 - PATCH_BASE)
mov	x2, x0
LFQD_Lloh1354:
adr x1, LFQD_l_.str.343
LFQD_Lloh1355:
nop
mov	x0, x27
bl	LFQD_Put
LFQD_Lloh1356:
adr x1, LFQD_l_.str.322
LFQD_Lloh1357:
nop
mov	x0, x20
bl	LFQD_At
bl	LFQD_Elapsed
mov	x2, x0
LFQD_Lloh1358:
adr x1, LFQD_l_.str.154
LFQD_Lloh1359:
nop
mov	x0, x27
bl	LFQD_Put
bl	LFQD_Lock
mov	x28, x0
LFQD_Lloh1360:
adr x0, LFQD_l_.str
LFQD_Lloh1361:
nop
bl Lpatch + (0xa5a4 - PATCH_BASE)
mov	x1, x0
mov	x0, x28
bl Lpatch + (0xa5d4 - PATCH_BASE)
LFQD_Lloh1362:
adr x1, LFQD_l_.str.324
LFQD_Lloh1363:
nop
mov	x0, x20
bl	LFQD_At
mov	x24, x0
LFQD_Lloh1364:
adr x26, LFQD_l_.str.143
LFQD_Lloh1365:
nop
mov	x0, x26
bl Lpatch + (0xa5a4 - PATCH_BASE)
mov	x1, x0
mov	x0, x24
bl Lpatch + (0xa5d4 - PATCH_BASE)
mov	x24, x0
LFQD_Lloh1366:
adr x0, LFQD_l_.str.70
LFQD_Lloh1367:
nop
bl Lpatch + (0xa5b0 - PATCH_BASE)
LFQD_Lloh1368:
adr x1, LFQD_StateKey
LFQD_Lloh1369:
nop
bl Lpatch + (0xa628 - PATCH_BASE)
LFQD_Lloh1370:
adr x1, LFQD_l_.str.344
LFQD_Lloh1371:
nop
bl	LFQD_At
mov	x25, x0
mov	x0, x26
bl Lpatch + (0xa5a4 - PATCH_BASE)
mov	x1, x0
mov	x0, x25
bl Lpatch + (0xa5d4 - PATCH_BASE)
mov	x25, x0
cmp	x24, x0
cset	w26, lt
mov	x0, x23
bl Lpatch + (0xa5b0 - PATCH_BASE)
mov	x23, x0
mov	x0, x21
bl Lpatch + (0xa5a4 - PATCH_BASE)
mov	x1, x0
mov	x0, x23
mov	x2, x26
bl Lpatch + (0xa5d4 - PATCH_BASE)
mov	x2, x0
LFQD_Lloh1372:
adr x1, LFQD_l_.str.345
LFQD_Lloh1373:
nop
mov	x0, x27
bl	LFQD_Put
cmp	x24, x25
b.le	LFQD_LBB43_3
LFQD_Lloh1374:
adr x0, LFQD_l_.str.70
LFQD_Lloh1375:
nop
bl Lpatch + (0xa5b0 - PATCH_BASE)
LFQD_Lloh1376:
adr x1, LFQD_StateKey
LFQD_Lloh1377:
nop
bl Lpatch + (0xa628 - PATCH_BASE)
mov	x21, x0
LFQD_Lloh1378:
adr x0, LFQD_l_.str.209
LFQD_Lloh1379:
nop
bl Lpatch + (0xa5b0 - PATCH_BASE)
mov	x23, x0
LFQD_Lloh1380:
adr x0, LFQD_l_.str.221
LFQD_Lloh1381:
nop
bl Lpatch + (0xa5a4 - PATCH_BASE)
mov	x1, x0
mov	x0, x23
mov	x2, x24
bl Lpatch + (0xa5d4 - PATCH_BASE)
mov	x2, x0
LFQD_Lloh1382:
adr x1, LFQD_l_.str.344
LFQD_Lloh1383:
nop
mov	x0, x21
bl	LFQD_Put
LFQD_LBB43_3:
LFQD_Lloh1384:
adr x0, LFQD_l_.str.6
LFQD_Lloh1385:
nop
bl Lpatch + (0xa5a4 - PATCH_BASE)
mov	x1, x0
mov	x0, x28
bl Lpatch + (0xa5d4 - PATCH_BASE)
LFQD_Lloh1386:
adr x1, LFQD_l_.str.12
LFQD_Lloh1387:
nop
mov	x0, x22
bl	LFQD_Count
mov	x24, x0
LFQD_Lloh1388:
adr x21, LFQD_l_.str.209
LFQD_Lloh1389:
nop
mov	x0, x21
bl Lpatch + (0xa5b0 - PATCH_BASE)
mov	x25, x0
LFQD_Lloh1390:
adr x23, LFQD_l_.str.221
LFQD_Lloh1391:
nop
mov	x0, x23
bl Lpatch + (0xa5a4 - PATCH_BASE)
mov	x1, x0
mov	x0, x25
mov	x2, x24
bl Lpatch + (0xa5d4 - PATCH_BASE)
mov	x2, x0
LFQD_Lloh1392:
adr x1, LFQD_l_.str.346
LFQD_Lloh1393:
nop
mov	x0, x27
bl	LFQD_Put
ldr	x26, [sp, #40]
cmp	x26, #0
cset	w24, ne
mov	x0, x21
bl Lpatch + (0xa5b0 - PATCH_BASE)
mov	x25, x0
mov	x0, x23
bl Lpatch + (0xa5a4 - PATCH_BASE)
mov	x1, x0
mov	x0, x25
mov	x2, x24
bl Lpatch + (0xa5d4 - PATCH_BASE)
mov	x2, x0
LFQD_Lloh1394:
adr x1, LFQD_l_.str.347
LFQD_Lloh1395:
nop
mov	x0, x27
bl	LFQD_Put
LFQD_Lloh1396:
adr x24, LFQD_l_.str.208
LFQD_Lloh1397:
nop
mov	x0, x22
mov	x1, x24
bl	LFQD_Kind
mov	w25, w0
mov	x0, x21
bl Lpatch + (0xa5b0 - PATCH_BASE)
mov	x21, x0
mov	x0, x23
bl Lpatch + (0xa5a4 - PATCH_BASE)
mov	x1, x0
mov	x0, x21
mov	x2, x25
bl Lpatch + (0xa5d4 - PATCH_BASE)
mov	x2, x0
LFQD_Lloh1398:
adr x1, LFQD_l_.str.348
LFQD_Lloh1399:
nop
mov	x0, x27
bl	LFQD_Put
mov	x0, x22
mov	x1, x24
bl	LFQD_Kind
cbz	w0, LFQD_LBB43_6
LFQD_Lloh1400:
adr x1, LFQD_l_.str.349
LFQD_Lloh1401:
nop
mov	x0, x22
bl	LFQD_At
mov	x28, x0
cmp	x0, #0
cset	w21, ne
LFQD_Lloh1402:
adr x0, LFQD_l_.str.209
LFQD_Lloh1403:
nop
bl Lpatch + (0xa5b0 - PATCH_BASE)
mov	x23, x0
LFQD_Lloh1404:
adr x0, LFQD_l_.str.221
LFQD_Lloh1405:
nop
bl Lpatch + (0xa5a4 - PATCH_BASE)
mov	x1, x0
mov	x0, x23
mov	x2, x21
bl Lpatch + (0xa5d4 - PATCH_BASE)
mov	x2, x0
LFQD_Lloh1406:
adr x1, LFQD_l_.str.350
LFQD_Lloh1407:
nop
mov	x0, x27
bl	LFQD_Put
LFQD_Lloh1408:
adr x1, LFQD_l_.str.208
LFQD_Lloh1409:
nop
mov	x0, x28
bl	LFQD_Kind
cbz	w0, LFQD_LBB43_6
LFQD_Lloh1410:
adr x1, LFQD_l_.str.351
LFQD_Lloh1411:
nop
mov	x0, x28
bl	LFQD_At
mov	x24, x0
cmp	x0, #0
cset	w25, ne
LFQD_Lloh1412:
adr x21, LFQD_l_.str.209
LFQD_Lloh1413:
nop
mov	x0, x21
bl Lpatch + (0xa5b0 - PATCH_BASE)
mov	x26, x0
LFQD_Lloh1414:
adr x23, LFQD_l_.str.221
LFQD_Lloh1415:
nop
mov	x0, x23
bl Lpatch + (0xa5a4 - PATCH_BASE)
mov	x1, x0
mov	x0, x26
ldr	x26, [sp, #40]
mov	x2, x25
bl Lpatch + (0xa5d4 - PATCH_BASE)
mov	x2, x0
LFQD_Lloh1416:
adr x1, LFQD_l_.str.352
LFQD_Lloh1417:
nop
mov	x0, x27
bl	LFQD_Put
LFQD_Lloh1418:
adr x1, LFQD_l_.str.12
LFQD_Lloh1419:
nop
mov	x0, x24
bl	LFQD_Count
mov	x24, x0
mov	x0, x21
bl Lpatch + (0xa5b0 - PATCH_BASE)
mov	x25, x0
mov	x0, x23
bl Lpatch + (0xa5a4 - PATCH_BASE)
mov	x1, x0
mov	x0, x25
mov	x2, x24
bl Lpatch + (0xa5d4 - PATCH_BASE)
mov	x2, x0
LFQD_Lloh1420:
adr x1, LFQD_l_.str.353
LFQD_Lloh1421:
nop
mov	x0, x27
bl	LFQD_Put
LFQD_Lloh1422:
adr x1, LFQD_l_.str.355
LFQD_Lloh1423:
nop
mov	x0, x28
bl	LFQD_At
cmp	x0, #0
cset	w24, ne
mov	x0, x21
bl Lpatch + (0xa5b0 - PATCH_BASE)
mov	x25, x0
mov	x0, x23
bl Lpatch + (0xa5a4 - PATCH_BASE)
mov	x1, x0
mov	x0, x25
mov	x2, x24
bl Lpatch + (0xa5d4 - PATCH_BASE)
mov	x2, x0
LFQD_Lloh1424:
adr x1, LFQD_l_.str.354
LFQD_Lloh1425:
nop
mov	x0, x27
bl	LFQD_Put
LFQD_Lloh1426:
adr x1, LFQD_l_.str.357
LFQD_Lloh1427:
nop
mov	x0, x28
bl	LFQD_At
cmp	x0, #0
cset	w24, ne
mov	x0, x21
bl Lpatch + (0xa5b0 - PATCH_BASE)
mov	x21, x0
mov	x0, x23
bl Lpatch + (0xa5a4 - PATCH_BASE)
mov	x1, x0
mov	x0, x21
mov	x2, x24
bl Lpatch + (0xa5d4 - PATCH_BASE)
mov	x2, x0
LFQD_Lloh1428:
adr x1, LFQD_l_.str.356
LFQD_Lloh1429:
nop
mov	x0, x27
bl	LFQD_Put
LFQD_LBB43_6:
LFQD_Lloh1430:
adr x0, LFQD_l_.str.192
LFQD_Lloh1431:
nop
bl Lpatch + (0xa5b0 - PATCH_BASE)
mov	x21, x0
LFQD_Lloh1432:
adr x0, LFQD_l_.str.215
LFQD_Lloh1433:
nop
bl Lpatch + (0xa5a4 - PATCH_BASE)
mov	x1, x0
LFQD_Lloh1434:
adr x2, LFQD_l_.str.358
LFQD_Lloh1435:
nop
mov	x0, x21
bl Lpatch + (0xa5d4 - PATCH_BASE)
mov	x2, x0
LFQD_Lloh1436:
adr x1, LFQD_l_.str.11
LFQD_Lloh1437:
nop
mov	x0, x27
bl	LFQD_Put
LFQD_Lloh1438:
adr x21, LFQD_l_.str.238
LFQD_Lloh1439:
nop
mov	x0, x20
mov	x1, x21
bl	LFQD_At
mov	x3, x0
LFQD_Lloh1440:
adr x0, LFQD_l_.str.359
LFQD_Lloh1441:
nop
LFQD_Lloh1442:
adr x1, LFQD_l_.str.90
LFQD_Lloh1443:
nop
mov	x2, x19
mov	x4, x27
bl	LFQD_Emit
LFQD_Lloh1444:
adr x0, LFQD_l_.str.5
LFQD_Lloh1445:
nop
bl Lpatch + (0xa5a4 - PATCH_BASE)
mov	x1, x0
mov	x0, x27
bl Lpatch + (0xa5d4 - PATCH_BASE)
mov	x0, x20
mov	x1, x21
bl	LFQD_At
mov	x2, x0
LFQD_Lloh1446:
adr x1, LFQD_ContextKey
LFQD_Lloh1447:
nop
ldr	x25, [sp, #8]
mov	x0, x25
mov	w3, #769
bl Lpatch + (0xa634 - PATCH_BASE)
ldp	x24, x23, [sp, #24]
ldr	x21, [sp, #16]
LFQD_LBB43_7:
cbz	x24, LFQD_LBB43_9
mov	x0, x19
mov	x1, x23
mov	x2, x22
mov	x3, x26
blr	x24
LFQD_LBB43_9:
LFQD_Lloh1448:
adr x1, LFQD_ContextKey
LFQD_Lloh1449:
nop
mov	x0, x25
mov	x2, x21
mov	w3, #769
bl Lpatch + (0xa634 - PATCH_BASE)
LFQD_Lloh1450:
adr x0, LFQD_l_.str.5
LFQD_Lloh1451:
nop
bl Lpatch + (0xa5a4 - PATCH_BASE)
mov	x1, x0
mov	x0, x21
bl Lpatch + (0xa5d4 - PATCH_BASE)
cbz	x20, LFQD_LBB43_11
LFQD_Lloh1452:
adr x1, LFQD_l_.str.238
LFQD_Lloh1453:
nop
mov	x0, x20
bl	LFQD_At
LFQD_Lloh1454:
adr x8, LFQD_l_.str.360
LFQD_Lloh1455:
nop
LFQD_Lloh1456:
adr x1, LFQD_l_.str.90
LFQD_Lloh1457:
nop
mov	x3, x0
mov	x0, x8
mov	x2, x19
mov	x4, x20
ldp	x29, x30, [sp, #128]
ldp	x20, x19, [sp, #112]
ldp	x22, x21, [sp, #96]
ldp	x24, x23, [sp, #80]
ldp	x26, x25, [sp, #64]
ldp	x28, x27, [sp, #48]
add	sp, sp, #144
b	LFQD_Emit
LFQD_LBB43_11:
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
LFQD_TransportResponse:
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
mov	x21, x3
mov	x20, x2
mov	x22, x1
mov	x19, x0
LFQD_Lloh1458:
adr x1, LFQD_l_.str.105
LFQD_Lloh1459:
nop
bl	LFQD_Original
cbz	x0, LFQD_LBB44_2
mov	x8, x0
mov	x0, x19
mov	x1, x22
mov	x2, x20
mov	x3, x21
blr	x8
mov	x19, x0
LFQD_LBB44_2:
LFQD_Lloh1460:
adr x1, LFQD_RequestKey
LFQD_Lloh1461:
nop
mov	x0, x20
bl Lpatch + (0xa628 - PATCH_BASE)
cbz	x0, LFQD_LBB44_7
mov	x21, x0
LFQD_Lloh1462:
adr x0, LFQD_l_.str.2
LFQD_Lloh1463:
nop
bl Lpatch + (0xa5a4 - PATCH_BASE)
mov	x1, x0
mov	x0, x21
bl Lpatch + (0xa5d4 - PATCH_BASE)
mov	x20, x0
LFQD_Lloh1464:
adr x1, LFQD_l_.str.361
LFQD_Lloh1465:
nop
mov	x0, x19
bl	LFQD_Get
mov	x22, x0
LFQD_Lloh1466:
adr x1, LFQD_l_.str.336
LFQD_Lloh1467:
nop
mov	x0, x19
bl	LFQD_Get
mov	x23, x0
LFQD_Lloh1468:
adr x24, LFQD_l_.str.362
LFQD_Lloh1469:
nop
mov	x0, x19
mov	x1, x24
bl	LFQD_Count
mov	x25, x0
LFQD_Lloh1470:
adr x26, LFQD_l_.str.209
LFQD_Lloh1471:
nop
mov	x0, x26
bl Lpatch + (0xa5b0 - PATCH_BASE)
mov	x27, x0
LFQD_Lloh1472:
adr x28, LFQD_l_.str.221
LFQD_Lloh1473:
nop
mov	x0, x28
bl Lpatch + (0xa5a4 - PATCH_BASE)
mov	x1, x0
mov	x0, x27
mov	x2, x25
bl Lpatch + (0xa5d4 - PATCH_BASE)
mov	x2, x0
mov	x0, x20
mov	x1, x24
bl	LFQD_Put
LFQD_Lloh1474:
adr x1, LFQD_l_.str.229
LFQD_Lloh1475:
nop
mov	x0, x23
bl	LFQD_Count
mov	x23, x0
mov	x0, x26
bl Lpatch + (0xa5b0 - PATCH_BASE)
mov	x24, x0
mov	x0, x28
bl Lpatch + (0xa5a4 - PATCH_BASE)
mov	x1, x0
mov	x0, x24
mov	x2, x23
bl Lpatch + (0xa5d4 - PATCH_BASE)
mov	x2, x0
LFQD_Lloh1476:
adr x1, LFQD_l_.str.338
LFQD_Lloh1477:
nop
mov	x0, x20
bl	LFQD_Put
LFQD_Lloh1478:
adr x1, LFQD_l_.str.203
LFQD_Lloh1479:
nop
mov	x0, x22
bl	LFQD_Kind
cbz	w0, LFQD_LBB44_5
LFQD_Lloh1480:
adr x0, LFQD_l_.str.193
LFQD_Lloh1481:
nop
bl Lpatch + (0xa5a4 - PATCH_BASE)
mov	x1, x0
mov	x0, x22
bl Lpatch + (0xa5d4 - PATCH_BASE)
mov	x22, x0
b	LFQD_LBB44_6
LFQD_LBB44_5:
mov	x22, #-1
LFQD_LBB44_6:
LFQD_Lloh1482:
adr x0, LFQD_l_.str.209
LFQD_Lloh1483:
nop
bl Lpatch + (0xa5b0 - PATCH_BASE)
mov	x23, x0
LFQD_Lloh1484:
adr x0, LFQD_l_.str.221
LFQD_Lloh1485:
nop
bl Lpatch + (0xa5a4 - PATCH_BASE)
mov	x1, x0
mov	x0, x23
mov	x2, x22
bl Lpatch + (0xa5d4 - PATCH_BASE)
mov	x2, x0
LFQD_Lloh1486:
adr x1, LFQD_l_.str.363
LFQD_Lloh1487:
nop
mov	x0, x20
bl	LFQD_Put
LFQD_Lloh1488:
adr x0, LFQD_l_.str.192
LFQD_Lloh1489:
nop
bl Lpatch + (0xa5b0 - PATCH_BASE)
mov	x22, x0
LFQD_Lloh1490:
adr x0, LFQD_l_.str.215
LFQD_Lloh1491:
nop
bl Lpatch + (0xa5a4 - PATCH_BASE)
mov	x1, x0
LFQD_Lloh1492:
adr x2, LFQD_l_.str.364
LFQD_Lloh1493:
nop
mov	x0, x22
bl Lpatch + (0xa5d4 - PATCH_BASE)
mov	x2, x0
LFQD_Lloh1494:
adr x1, LFQD_l_.str.11
LFQD_Lloh1495:
nop
mov	x0, x20
bl	LFQD_Put
LFQD_Lloh1496:
adr x1, LFQD_l_.str.238
LFQD_Lloh1497:
nop
mov	x0, x21
bl	LFQD_At
mov	x3, x0
LFQD_Lloh1498:
adr x0, LFQD_l_.str.365
LFQD_Lloh1499:
nop
LFQD_Lloh1500:
adr x1, LFQD_l_.str.102
LFQD_Lloh1501:
nop
mov	x2, x19
mov	x4, x20
bl	LFQD_Emit
LFQD_Lloh1502:
adr x0, LFQD_l_.str.5
LFQD_Lloh1503:
nop
bl Lpatch + (0xa5a4 - PATCH_BASE)
mov	x1, x0
mov	x0, x20
bl Lpatch + (0xa5d4 - PATCH_BASE)
LFQD_LBB44_7:
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
LFQD_SendAction:
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
mov	x21, x5
mov	x19, x4
mov	x22, x3
mov	x23, x2
mov	x24, x1
mov	x25, x0
bl	LFQD_Context
mov	x27, x0
bl	LFQD_Enhanced
cbz	w0, LFQD_LBB45_10
stp	x24, x23, [sp]
mov	x24, x22
stp	x21, x27, [sp, #16]
LFQD_Lloh1504:
adr x1, LFQD_l_.str.366
LFQD_Lloh1505:
nop
mov	x0, x19
bl	LFQD_Kind
mov	x26, x0
mov	x27, x19
cbz	w0, LFQD_LBB45_7
mov	x27, x19
cbz	x19, LFQD_LBB45_7
mov	w23, #0
LFQD_Lloh1506:
adr x28, LFQD_l_.str.194
LFQD_Lloh1507:
nop
LFQD_Lloh1508:
adr x20, LFQD_l_.str.367
LFQD_Lloh1509:
nop
mov	x27, x19
LFQD_Lloh1510:
adr x21, LFQD_l_.str.368
LFQD_Lloh1511:
nop
LFQD_LBB45_4:
mov	x0, x28
bl Lpatch + (0xa5a4 - PATCH_BASE)
mov	x22, x0
mov	x0, x20
bl Lpatch + (0xa5b0 - PATCH_BASE)
mov	x2, x0
mov	x0, x27
mov	x1, x22
bl Lpatch + (0xa5d4 - PATCH_BASE)
cbnz	w0, LFQD_LBB45_7
mov	x0, x27
mov	x1, x21
bl	LFQD_Get
mov	x27, x0
cbz	x0, LFQD_LBB45_7
cmp	w23, #11
add	w23, w23, #1
b.lo	LFQD_LBB45_4
LFQD_LBB45_7:
tbz	w26, #0, LFQD_LBB45_11
LFQD_Lloh1512:
adr x1, LFQD_l_.str.367
LFQD_Lloh1513:
nop
mov	x0, x27
bl	LFQD_Kind
mov	x22, x24
cbz	w0, LFQD_LBB45_12
LFQD_Lloh1514:
adr x0, LFQD_l_.str.234
LFQD_Lloh1515:
nop
bl Lpatch + (0xa5b0 - PATCH_BASE)
mov	x20, x0
LFQD_Lloh1516:
adr x0, LFQD_l_.str.235
LFQD_Lloh1517:
nop
bl Lpatch + (0xa5a4 - PATCH_BASE)
mov	x1, x0
mov	x0, x20
bl Lpatch + (0xa5d4 - PATCH_BASE)
mov	x26, x0
mov	x0, x27
bl	LFQD_Id
mov	x2, x0
LFQD_Lloh1518:
adr x1, LFQD_l_.str.369
LFQD_Lloh1519:
nop
mov	x0, x26
bl	LFQD_Put
mov	x0, x19
bl	LFQD_Id
mov	x2, x0
LFQD_Lloh1520:
adr x1, LFQD_l_.str.370
LFQD_Lloh1521:
nop
mov	x0, x26
bl	LFQD_Put
LFQD_Lloh1522:
adr x0, LFQD_l_.str.372
LFQD_Lloh1523:
nop
bl Lpatch + (0xa5a4 - PATCH_BASE)
mov	x1, x0
mov	x0, x19
bl Lpatch + (0xa5d4 - PATCH_BASE)
sxtw	x20, w0
LFQD_Lloh1524:
adr x0, LFQD_l_.str.209
LFQD_Lloh1525:
nop
bl Lpatch + (0xa5b0 - PATCH_BASE)
mov	x21, x0
LFQD_Lloh1526:
adr x0, LFQD_l_.str.221
LFQD_Lloh1527:
nop
bl Lpatch + (0xa5a4 - PATCH_BASE)
mov	x1, x0
mov	x0, x21
mov	x2, x20
bl Lpatch + (0xa5d4 - PATCH_BASE)
mov	x2, x0
LFQD_Lloh1528:
adr x1, LFQD_l_.str.371
LFQD_Lloh1529:
nop
mov	x0, x26
bl	LFQD_Put
LFQD_Lloh1530:
adr x0, LFQD_l_.str.373
LFQD_Lloh1531:
nop
LFQD_Lloh1532:
adr x1, LFQD_l_.str.106
LFQD_Lloh1533:
nop
mov	x2, x19
ldr	x27, [sp, #24]
mov	x3, x27
mov	x4, x26
bl	LFQD_Emit
mov	w20, #1
b	LFQD_LBB45_13
LFQD_LBB45_10:
mov	x26, #0
mov	w20, #0
b	LFQD_LBB45_15
LFQD_LBB45_11:
mov	x26, #0
mov	w20, #0
ldp	x21, x27, [sp, #16]
mov	x22, x24
b	LFQD_LBB45_14
LFQD_LBB45_12:
mov	x26, #0
mov	w20, #0
ldr	x27, [sp, #24]
LFQD_LBB45_13:
ldr	x21, [sp, #16]
LFQD_LBB45_14:
ldp	x24, x23, [sp]
LFQD_LBB45_15:
LFQD_Lloh1534:
adr x1, LFQD_l_.str.109
LFQD_Lloh1535:
nop
mov	x0, x25
bl	LFQD_Original
cbz	x0, LFQD_LBB45_17
mov	x8, x0
mov	x0, x25
mov	x1, x24
mov	x2, x23
mov	x3, x22
mov	x4, x19
mov	x5, x21
blr	x8
mov	x21, x0
cbnz	w20, LFQD_LBB45_18
b	LFQD_LBB45_22
LFQD_LBB45_17:
mov	w21, #0
cbz	w20, LFQD_LBB45_22
LFQD_LBB45_18:
LFQD_Lloh1536:
adr x22, LFQD_l_.str.2
LFQD_Lloh1537:
nop
mov	x0, x22
bl Lpatch + (0xa5a4 - PATCH_BASE)
mov	x1, x0
mov	x0, x26
bl Lpatch + (0xa5d4 - PATCH_BASE)
mov	x20, x0
sxtw	x23, w21
LFQD_Lloh1538:
adr x0, LFQD_l_.str.209
LFQD_Lloh1539:
nop
bl Lpatch + (0xa5b0 - PATCH_BASE)
mov	x24, x0
LFQD_Lloh1540:
adr x0, LFQD_l_.str.221
LFQD_Lloh1541:
nop
bl Lpatch + (0xa5a4 - PATCH_BASE)
mov	x1, x0
mov	x0, x24
mov	x2, x23
bl Lpatch + (0xa5d4 - PATCH_BASE)
mov	x2, x0
LFQD_Lloh1542:
adr x1, LFQD_l_.str.374
LFQD_Lloh1543:
nop
mov	x0, x20
bl	LFQD_Put
LFQD_Lloh1544:
adr x0, LFQD_l_.str.375
LFQD_Lloh1545:
nop
LFQD_Lloh1546:
adr x1, LFQD_l_.str.106
LFQD_Lloh1547:
nop
mov	x2, x19
mov	x3, x27
mov	x4, x20
bl	LFQD_Emit
LFQD_Lloh1548:
adr x0, LFQD_l_.str.5
LFQD_Lloh1549:
nop
bl Lpatch + (0xa5a4 - PATCH_BASE)
mov	x1, x0
mov	x0, x20
bl Lpatch + (0xa5d4 - PATCH_BASE)
mov	x0, x22
bl Lpatch + (0xa5a4 - PATCH_BASE)
mov	x1, x0
mov	x0, x26
bl Lpatch + (0xa5d4 - PATCH_BASE)
mov	x22, x0
LFQD_Lloh1550:
adr x1, LFQD_l_.str.238
LFQD_Lloh1551:
nop
mov	x2, x27
bl	LFQD_Put
bl	LFQD_Lock
mov	x23, x0
LFQD_Lloh1552:
adr x0, LFQD_l_.str
LFQD_Lloh1553:
nop
bl Lpatch + (0xa5a4 - PATCH_BASE)
mov	x1, x0
mov	x0, x23
bl Lpatch + (0xa5d4 - PATCH_BASE)
LFQD_Lloh1554:
adr x20, LFQD_l_.str.70
LFQD_Lloh1555:
nop
mov	x0, x20
bl Lpatch + (0xa5b0 - PATCH_BASE)
LFQD_Lloh1556:
adr x24, LFQD_StateKey
LFQD_Lloh1557:
nop
mov	x1, x24
bl Lpatch + (0xa628 - PATCH_BASE)
LFQD_Lloh1558:
adr x25, LFQD_l_.str.241
LFQD_Lloh1559:
nop
mov	x1, x25
bl	LFQD_At
mov	x2, x0
mov	x0, x22
mov	x1, x25
bl	LFQD_Put
mov	x0, x20
bl Lpatch + (0xa5b0 - PATCH_BASE)
mov	x1, x24
bl Lpatch + (0xa628 - PATCH_BASE)
LFQD_Lloh1560:
adr x1, LFQD_l_.str.251
LFQD_Lloh1561:
nop
bl	LFQD_At
mov	x20, x0
LFQD_Lloh1562:
adr x0, LFQD_l_.str.143
LFQD_Lloh1563:
nop
bl Lpatch + (0xa5a4 - PATCH_BASE)
mov	x1, x0
mov	x0, x20
bl Lpatch + (0xa5d4 - PATCH_BASE)
cmp	x0, #63
b.gt	LFQD_LBB45_20
mov	x20, x0
LFQD_Lloh1564:
adr x19, LFQD_l_.str.70
LFQD_Lloh1565:
nop
mov	x0, x19
bl Lpatch + (0xa5b0 - PATCH_BASE)
mov	x1, x24
bl Lpatch + (0xa628 - PATCH_BASE)
mov	x25, x0
LFQD_Lloh1566:
adr x0, LFQD_l_.str.209
LFQD_Lloh1567:
nop
bl Lpatch + (0xa5b0 - PATCH_BASE)
mov	x26, x0
LFQD_Lloh1568:
adr x0, LFQD_l_.str.221
LFQD_Lloh1569:
nop
bl Lpatch + (0xa5a4 - PATCH_BASE)
mov	x1, x0
add	x2, x20, #1
mov	x0, x26
bl Lpatch + (0xa5d4 - PATCH_BASE)
mov	x2, x0
LFQD_Lloh1570:
adr x1, LFQD_l_.str.251
LFQD_Lloh1571:
nop
mov	x0, x25
bl	LFQD_Put
LFQD_Lloh1572:
adr x0, LFQD_l_.str.6
LFQD_Lloh1573:
nop
bl Lpatch + (0xa5a4 - PATCH_BASE)
mov	x1, x0
mov	x0, x23
bl Lpatch + (0xa5d4 - PATCH_BASE)
mov	x0, x19
bl Lpatch + (0xa5b0 - PATCH_BASE)
mov	x1, x24
bl Lpatch + (0xa628 - PATCH_BASE)
LFQD_Lloh1574:
adr x1, LFQD_l_.str.40
LFQD_Lloh1575:
nop
bl	LFQD_At
mov	x19, x0
LFQD_Lloh1576:
adr x0, LFQD_l_.str.376
LFQD_Lloh1577:
nop
bl Lpatch + (0xa5a4 - PATCH_BASE)
mov	x20, x0
LFQD_Lloh1578:
adr x0, LFQD_l_.str.39
LFQD_Lloh1579:
nop
bl Lpatch + (0xa5a4 - PATCH_BASE)
mov	x2, x0
fmov	d0, #2.00000000
mov	x0, x19
mov	x1, x20
mov	x3, x22
bl Lpatch + (0xa5d4 - PATCH_BASE)
b	LFQD_LBB45_21
LFQD_LBB45_20:
LFQD_Lloh1580:
adr x0, LFQD_l_.str.6
LFQD_Lloh1581:
nop
bl Lpatch + (0xa5a4 - PATCH_BASE)
mov	x1, x0
mov	x0, x23
bl Lpatch + (0xa5d4 - PATCH_BASE)
LFQD_Lloh1582:
adr x0, LFQD_l_.str.70
LFQD_Lloh1583:
nop
bl Lpatch + (0xa5b0 - PATCH_BASE)
LFQD_Lloh1584:
adr x1, LFQD_StateKey
LFQD_Lloh1585:
nop
bl Lpatch + (0xa628 - PATCH_BASE)
LFQD_Lloh1586:
adr x1, LFQD_l_.str.40
LFQD_Lloh1587:
nop
bl	LFQD_At
LFQD_Lloh1588:
adr x0, LFQD_l_.str.234
LFQD_Lloh1589:
nop
bl Lpatch + (0xa5b0 - PATCH_BASE)
mov	x20, x0
LFQD_Lloh1590:
adr x0, LFQD_l_.str.235
LFQD_Lloh1591:
nop
bl Lpatch + (0xa5a4 - PATCH_BASE)
mov	x1, x0
mov	x0, x20
bl Lpatch + (0xa5d4 - PATCH_BASE)
mov	x20, x0
LFQD_Lloh1592:
adr x0, LFQD_l_.str.192
LFQD_Lloh1593:
nop
bl Lpatch + (0xa5b0 - PATCH_BASE)
mov	x23, x0
LFQD_Lloh1594:
adr x0, LFQD_l_.str.215
LFQD_Lloh1595:
nop
bl Lpatch + (0xa5a4 - PATCH_BASE)
mov	x1, x0
LFQD_Lloh1596:
adr x2, LFQD_l_.str.377
LFQD_Lloh1597:
nop
mov	x0, x23
bl Lpatch + (0xa5d4 - PATCH_BASE)
mov	x2, x0
LFQD_Lloh1598:
adr x1, LFQD_l_.str.150
LFQD_Lloh1599:
nop
mov	x0, x20
bl	LFQD_Put
LFQD_Lloh1600:
adr x0, LFQD_l_.str.378
LFQD_Lloh1601:
nop
LFQD_Lloh1602:
adr x1, LFQD_l_.str.106
LFQD_Lloh1603:
nop
mov	x2, x19
mov	x3, x27
mov	x4, x20
bl	LFQD_Emit
LFQD_LBB45_21:
LFQD_Lloh1604:
adr x0, LFQD_l_.str.5
LFQD_Lloh1605:
nop
bl Lpatch + (0xa5a4 - PATCH_BASE)
mov	x1, x0
mov	x0, x22
bl Lpatch + (0xa5d4 - PATCH_BASE)
LFQD_LBB45_22:
mov	x0, x21
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
LFQD_Push:
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
mov	x21, x3
mov	x20, x2
mov	x22, x1
mov	x19, x0
bl	LFQD_Enhanced
cbz	w0, LFQD_LBB46_2
LFQD_Lloh1606:
adr x0, LFQD_l_.str.234
LFQD_Lloh1607:
nop
bl Lpatch + (0xa5b0 - PATCH_BASE)
mov	x23, x0
LFQD_Lloh1608:
adr x0, LFQD_l_.str.235
LFQD_Lloh1609:
nop
bl Lpatch + (0xa5a4 - PATCH_BASE)
mov	x1, x0
mov	x0, x23
bl Lpatch + (0xa5d4 - PATCH_BASE)
mov	x23, x0
mov	x0, x20
bl	LFQD_Id
mov	x2, x0
LFQD_Lloh1610:
adr x1, LFQD_l_.str.379
LFQD_Lloh1611:
nop
mov	x0, x23
bl	LFQD_Put
LFQD_Lloh1612:
adr x0, LFQD_l_.str.380
LFQD_Lloh1613:
nop
LFQD_Lloh1614:
adr x1, LFQD_l_.str.110
LFQD_Lloh1615:
nop
mov	x2, x19
mov	x3, #0
mov	x4, x23
bl	LFQD_Emit
LFQD_LBB46_2:
LFQD_Lloh1616:
adr x1, LFQD_l_.str.113
LFQD_Lloh1617:
nop
mov	x0, x19
bl	LFQD_Original
cbz	x0, LFQD_LBB46_4
mov	x8, x0
mov	x0, x19
mov	x1, x22
mov	x2, x20
mov	x3, x21
blr	x8
LFQD_LBB46_4:
bl	LFQD_Enhanced
cbz	w0, LFQD_LBB46_6
LFQD_Lloh1618:
adr x0, LFQD_l_.str.234
LFQD_Lloh1619:
nop
bl Lpatch + (0xa5b0 - PATCH_BASE)
mov	x21, x0
LFQD_Lloh1620:
adr x0, LFQD_l_.str.235
LFQD_Lloh1621:
nop
bl Lpatch + (0xa5a4 - PATCH_BASE)
mov	x1, x0
mov	x0, x21
bl Lpatch + (0xa5d4 - PATCH_BASE)
mov	x21, x0
mov	x0, x20
bl	LFQD_Id
mov	x2, x0
LFQD_Lloh1622:
adr x1, LFQD_l_.str.379
LFQD_Lloh1623:
nop
mov	x0, x21
bl	LFQD_Put
LFQD_Lloh1624:
adr x0, LFQD_l_.str.381
LFQD_Lloh1625:
nop
LFQD_Lloh1626:
adr x1, LFQD_l_.str.110
LFQD_Lloh1627:
nop
mov	x2, x19
mov	x3, #0
mov	x4, x21
ldp	x29, x30, [sp, #48]
ldp	x20, x19, [sp, #32]
ldp	x22, x21, [sp, #16]
ldp	x24, x23, [sp], #64
b	LFQD_Emit
LFQD_LBB46_6:
ldp	x29, x30, [sp, #48]
ldp	x20, x19, [sp, #32]
ldp	x22, x21, [sp, #16]
ldp	x24, x23, [sp], #64
ret
.cfi_endproc
.p2align	2
LFQD_Pop:
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
mov	x20, x2
mov	x21, x1
mov	x19, x0
LFQD_Lloh1628:
adr x1, LFQD_l_.str.116
LFQD_Lloh1629:
nop
bl	LFQD_Original
cbz	x0, LFQD_LBB47_2
mov	x8, x0
mov	x0, x19
mov	x1, x21
mov	x2, x20
blr	x8
mov	x20, x0
b	LFQD_LBB47_3
LFQD_LBB47_2:
mov	x20, #0
LFQD_LBB47_3:
bl	LFQD_Enhanced
cbz	w0, LFQD_LBB47_5
LFQD_Lloh1630:
adr x0, LFQD_l_.str.234
LFQD_Lloh1631:
nop
bl Lpatch + (0xa5b0 - PATCH_BASE)
mov	x21, x0
LFQD_Lloh1632:
adr x0, LFQD_l_.str.235
LFQD_Lloh1633:
nop
bl Lpatch + (0xa5a4 - PATCH_BASE)
mov	x1, x0
mov	x0, x21
bl Lpatch + (0xa5d4 - PATCH_BASE)
mov	x21, x0
mov	x0, x20
bl	LFQD_Id
mov	x2, x0
LFQD_Lloh1634:
adr x1, LFQD_l_.str.382
LFQD_Lloh1635:
nop
mov	x0, x21
bl	LFQD_Put
cmp	x20, #0
cset	w22, ne
LFQD_Lloh1636:
adr x0, LFQD_l_.str.209
LFQD_Lloh1637:
nop
bl Lpatch + (0xa5b0 - PATCH_BASE)
mov	x23, x0
LFQD_Lloh1638:
adr x0, LFQD_l_.str.221
LFQD_Lloh1639:
nop
bl Lpatch + (0xa5a4 - PATCH_BASE)
mov	x1, x0
mov	x0, x23
mov	x2, x22
bl Lpatch + (0xa5d4 - PATCH_BASE)
mov	x2, x0
LFQD_Lloh1640:
adr x1, LFQD_l_.str.343
LFQD_Lloh1641:
nop
mov	x0, x21
bl	LFQD_Put
LFQD_Lloh1642:
adr x0, LFQD_l_.str.383
LFQD_Lloh1643:
nop
LFQD_Lloh1644:
adr x1, LFQD_l_.str.110
LFQD_Lloh1645:
nop
mov	x2, x19
mov	x3, #0
mov	x4, x21
bl	LFQD_Emit
LFQD_LBB47_5:
mov	x0, x20
ldp	x29, x30, [sp, #48]
ldp	x20, x19, [sp, #32]
ldp	x22, x21, [sp, #16]
ldp	x24, x23, [sp], #64
ret
.cfi_endproc
.p2align	2
LFQD_Exception:
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
LFQD_Lloh1646:
adr x0, LFQD_l_.str.341
LFQD_Lloh1647:
nop
bl Lpatch + (0xa5b0 - PATCH_BASE)
mov	x21, x0
LFQD_Lloh1648:
adr x0, LFQD_l_.str.342
LFQD_Lloh1649:
nop
bl Lpatch + (0xa5a4 - PATCH_BASE)
mov	x1, x0
mov	x0, x21
bl Lpatch + (0xa5d4 - PATCH_BASE)
mov	x21, x0
LFQD_Lloh1650:
adr x1, LFQD_ExceptionKey
LFQD_Lloh1651:
nop
bl Lpatch + (0xa628 - PATCH_BASE)
cbnz	x0, LFQD_LBB48_2
LFQD_Lloh1652:
adr x22, LFQD_ExceptionKey
LFQD_Lloh1653:
nop
mov	x0, x21
mov	x1, x22
mov	x2, x20
mov	x3, #0
bl Lpatch + (0xa634 - PATCH_BASE)
LFQD_Lloh1654:
adr x0, LFQD_l_.str.234
LFQD_Lloh1655:
nop
bl Lpatch + (0xa5b0 - PATCH_BASE)
mov	x23, x0
LFQD_Lloh1656:
adr x0, LFQD_l_.str.235
LFQD_Lloh1657:
nop
bl Lpatch + (0xa5a4 - PATCH_BASE)
mov	x1, x0
mov	x0, x23
bl Lpatch + (0xa5d4 - PATCH_BASE)
mov	x23, x0
LFQD_Lloh1658:
adr x0, LFQD_l_.str.209
LFQD_Lloh1659:
nop
bl Lpatch + (0xa5b0 - PATCH_BASE)
mov	x24, x0
LFQD_Lloh1660:
adr x0, LFQD_l_.str.221
LFQD_Lloh1661:
nop
bl Lpatch + (0xa5a4 - PATCH_BASE)
mov	x1, x0
mov	x0, x24
mov	w2, #1
bl Lpatch + (0xa5d4 - PATCH_BASE)
mov	x2, x0
LFQD_Lloh1662:
adr x1, LFQD_l_.str.384
LFQD_Lloh1663:
nop
mov	x0, x23
bl	LFQD_Put
LFQD_Lloh1664:
adr x0, LFQD_l_.str.192
LFQD_Lloh1665:
nop
bl Lpatch + (0xa5b0 - PATCH_BASE)
mov	x24, x0
LFQD_Lloh1666:
adr x0, LFQD_l_.str.215
LFQD_Lloh1667:
nop
bl Lpatch + (0xa5a4 - PATCH_BASE)
mov	x1, x0
LFQD_Lloh1668:
adr x2, LFQD_l_.str.385
LFQD_Lloh1669:
nop
mov	x0, x24
bl Lpatch + (0xa5d4 - PATCH_BASE)
mov	x2, x0
LFQD_Lloh1670:
adr x1, LFQD_l_.str.254
LFQD_Lloh1671:
nop
mov	x0, x23
bl	LFQD_Put
LFQD_Lloh1672:
adr x0, LFQD_l_.str.386
LFQD_Lloh1673:
nop
LFQD_Lloh1674:
adr x1, LFQD_l_.str.117
LFQD_Lloh1675:
nop
mov	x2, x20
mov	x3, #0
mov	x4, x23
bl	LFQD_Emit
mov	x0, x21
mov	x1, x22
mov	x2, #0
mov	x3, #0
bl Lpatch + (0xa634 - PATCH_BASE)
LFQD_LBB48_2:
LFQD_Lloh1676:
adr x1, LFQD_ContextKey
LFQD_Lloh1677:
nop
mov	x0, x21
mov	x2, #0
mov	w3, #769
bl Lpatch + (0xa634 - PATCH_BASE)
LFQD_Lloh1678:
adr x1, LFQD_l_.str.119
LFQD_Lloh1679:
nop
mov	x0, x20
bl	LFQD_Original
cbz	x0, LFQD_LBB48_4
mov	x2, x0
mov	x0, x20
mov	x1, x19
ldp	x29, x30, [sp, #48]
ldp	x20, x19, [sp, #32]
ldp	x22, x21, [sp, #16]
ldp	x24, x23, [sp], #64
br	x2
LFQD_LBB48_4:
ldp	x29, x30, [sp, #48]
ldp	x20, x19, [sp, #32]
ldp	x22, x21, [sp, #16]
ldp	x24, x23, [sp], #64
ret
.cfi_endproc
.p2align	2
LFQD_ReaderLoad:
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
LFQD_Lloh1680:
adr x1, LFQD_l_.str.122
LFQD_Lloh1681:
nop
bl	LFQD_Original
cbz	x0, LFQD_LBB49_2
mov	x8, x0
mov	x0, x19
mov	x1, x20
blr	x8
LFQD_LBB49_2:
bl	LFQD_Context
mov	x20, x0
LFQD_Lloh1682:
adr x0, LFQD_l_.str.234
LFQD_Lloh1683:
nop
bl Lpatch + (0xa5b0 - PATCH_BASE)
mov	x21, x0
LFQD_Lloh1684:
adr x0, LFQD_l_.str.235
LFQD_Lloh1685:
nop
bl Lpatch + (0xa5a4 - PATCH_BASE)
mov	x1, x0
mov	x0, x21
bl Lpatch + (0xa5d4 - PATCH_BASE)
LFQD_Lloh1686:
adr x8, LFQD_l_.str.387
LFQD_Lloh1687:
nop
LFQD_Lloh1688:
adr x1, LFQD_l_.str.120
LFQD_Lloh1689:
nop
mov	x4, x0
mov	x0, x8
mov	x2, x19
mov	x3, x20
ldp	x29, x30, [sp, #32]
ldp	x20, x19, [sp, #16]
ldp	x22, x21, [sp], #48
b	LFQD_Emit
.cfi_endproc
.p2align	2
LFQD_ReaderAppear:
.cfi_startproc
LFQD_Lloh1690:
adr x3, LFQD_l_.str.123
LFQD_Lloh1691:
nop
LFQD_Lloh1692:
adr x4, LFQD_l_.str.120
LFQD_Lloh1693:
nop
LFQD_Lloh1694:
adr x5, LFQD_l_.str.388
LFQD_Lloh1695:
nop
b	LFQD_PageEvent
.cfi_endproc
.p2align	2
LFQD_ReaderDisappear:
.cfi_startproc
LFQD_Lloh1696:
adr x3, LFQD_l_.str.124
LFQD_Lloh1697:
nop
LFQD_Lloh1698:
adr x4, LFQD_l_.str.120
LFQD_Lloh1699:
nop
LFQD_Lloh1700:
adr x5, LFQD_l_.str.389
LFQD_Lloh1701:
nop
b	LFQD_PageEvent
.cfi_endproc
.p2align	2
LFQD_StoreLoad:
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
LFQD_Lloh1702:
adr x1, LFQD_l_.str.126
LFQD_Lloh1703:
nop
bl	LFQD_Original
cbz	x0, LFQD_LBB52_2
mov	x8, x0
mov	x0, x19
mov	x1, x20
blr	x8
LFQD_LBB52_2:
bl	LFQD_Context
mov	x20, x0
LFQD_Lloh1704:
adr x0, LFQD_l_.str.234
LFQD_Lloh1705:
nop
bl Lpatch + (0xa5b0 - PATCH_BASE)
mov	x21, x0
LFQD_Lloh1706:
adr x0, LFQD_l_.str.235
LFQD_Lloh1707:
nop
bl Lpatch + (0xa5a4 - PATCH_BASE)
mov	x1, x0
mov	x0, x21
bl Lpatch + (0xa5d4 - PATCH_BASE)
LFQD_Lloh1708:
adr x8, LFQD_l_.str.387
LFQD_Lloh1709:
nop
LFQD_Lloh1710:
adr x1, LFQD_l_.str.125
LFQD_Lloh1711:
nop
mov	x4, x0
mov	x0, x8
mov	x2, x19
mov	x3, x20
ldp	x29, x30, [sp, #32]
ldp	x20, x19, [sp, #16]
ldp	x22, x21, [sp], #48
b	LFQD_Emit
.cfi_endproc
.p2align	2
LFQD_StoreAppear:
.cfi_startproc
LFQD_Lloh1712:
adr x3, LFQD_l_.str.127
LFQD_Lloh1713:
nop
LFQD_Lloh1714:
adr x4, LFQD_l_.str.125
LFQD_Lloh1715:
nop
LFQD_Lloh1716:
adr x5, LFQD_l_.str.388
LFQD_Lloh1717:
nop
b	LFQD_PageEvent
.cfi_endproc
.p2align	2
LFQD_StoreDisappear:
.cfi_startproc
LFQD_Lloh1718:
adr x3, LFQD_l_.str.128
LFQD_Lloh1719:
nop
LFQD_Lloh1720:
adr x4, LFQD_l_.str.125
LFQD_Lloh1721:
nop
LFQD_Lloh1722:
adr x5, LFQD_l_.str.389
LFQD_Lloh1723:
nop
b	LFQD_PageEvent
.cfi_endproc
.p2align	2
LFQD_ShelfLoad:
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
LFQD_Lloh1724:
adr x1, LFQD_l_.str.130
LFQD_Lloh1725:
nop
bl	LFQD_Original
cbz	x0, LFQD_LBB55_2
mov	x8, x0
mov	x0, x19
mov	x1, x20
blr	x8
LFQD_LBB55_2:
bl	LFQD_Context
mov	x20, x0
LFQD_Lloh1726:
adr x0, LFQD_l_.str.234
LFQD_Lloh1727:
nop
bl Lpatch + (0xa5b0 - PATCH_BASE)
mov	x21, x0
LFQD_Lloh1728:
adr x0, LFQD_l_.str.235
LFQD_Lloh1729:
nop
bl Lpatch + (0xa5a4 - PATCH_BASE)
mov	x1, x0
mov	x0, x21
bl Lpatch + (0xa5d4 - PATCH_BASE)
LFQD_Lloh1730:
adr x8, LFQD_l_.str.387
LFQD_Lloh1731:
nop
LFQD_Lloh1732:
adr x1, LFQD_l_.str.129
LFQD_Lloh1733:
nop
mov	x4, x0
mov	x0, x8
mov	x2, x19
mov	x3, x20
ldp	x29, x30, [sp, #32]
ldp	x20, x19, [sp, #16]
ldp	x22, x21, [sp], #48
b	LFQD_Emit
.cfi_endproc
.p2align	2
LFQD_ShelfAppear:
.cfi_startproc
LFQD_Lloh1734:
adr x3, LFQD_l_.str.131
LFQD_Lloh1735:
nop
LFQD_Lloh1736:
adr x4, LFQD_l_.str.129
LFQD_Lloh1737:
nop
LFQD_Lloh1738:
adr x5, LFQD_l_.str.388
LFQD_Lloh1739:
nop
b	LFQD_PageEvent
.cfi_endproc
.p2align	2
LFQD_ShelfDisappear:
.cfi_startproc
LFQD_Lloh1740:
adr x3, LFQD_l_.str.132
LFQD_Lloh1741:
nop
LFQD_Lloh1742:
adr x4, LFQD_l_.str.129
LFQD_Lloh1743:
nop
LFQD_Lloh1744:
adr x5, LFQD_l_.str.389
LFQD_Lloh1745:
nop
b	LFQD_PageEvent
.cfi_endproc
.p2align	2
LFQD_MineLoad:
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
LFQD_Lloh1746:
adr x1, LFQD_l_.str.134
LFQD_Lloh1747:
nop
bl	LFQD_Original
cbz	x0, LFQD_LBB58_2
mov	x8, x0
mov	x0, x19
mov	x1, x20
blr	x8
LFQD_LBB58_2:
bl	LFQD_Context
mov	x20, x0
LFQD_Lloh1748:
adr x0, LFQD_l_.str.234
LFQD_Lloh1749:
nop
bl Lpatch + (0xa5b0 - PATCH_BASE)
mov	x21, x0
LFQD_Lloh1750:
adr x0, LFQD_l_.str.235
LFQD_Lloh1751:
nop
bl Lpatch + (0xa5a4 - PATCH_BASE)
mov	x1, x0
mov	x0, x21
bl Lpatch + (0xa5d4 - PATCH_BASE)
LFQD_Lloh1752:
adr x8, LFQD_l_.str.387
LFQD_Lloh1753:
nop
LFQD_Lloh1754:
adr x1, LFQD_l_.str.133
LFQD_Lloh1755:
nop
mov	x4, x0
mov	x0, x8
mov	x2, x19
mov	x3, x20
ldp	x29, x30, [sp, #32]
ldp	x20, x19, [sp, #16]
ldp	x22, x21, [sp], #48
b	LFQD_Emit
.cfi_endproc
.p2align	2
LFQD_MineAppear:
.cfi_startproc
LFQD_Lloh1756:
adr x3, LFQD_l_.str.135
LFQD_Lloh1757:
nop
LFQD_Lloh1758:
adr x4, LFQD_l_.str.133
LFQD_Lloh1759:
nop
LFQD_Lloh1760:
adr x5, LFQD_l_.str.388
LFQD_Lloh1761:
nop
b	LFQD_PageEvent
.cfi_endproc
.p2align	2
LFQD_MineDisappear:
.cfi_startproc
LFQD_Lloh1762:
adr x3, LFQD_l_.str.136
LFQD_Lloh1763:
nop
LFQD_Lloh1764:
adr x4, LFQD_l_.str.133
LFQD_Lloh1765:
nop
LFQD_Lloh1766:
adr x5, LFQD_l_.str.389
LFQD_Lloh1767:
nop
b	LFQD_PageEvent
.cfi_endproc
.p2align	2
LFQD_ShortVideoLoad:
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
LFQD_Lloh1768:
adr x1, LFQD_l_.str.138
LFQD_Lloh1769:
nop
bl	LFQD_Original
cbz	x0, LFQD_LBB61_2
mov	x8, x0
mov	x0, x19
mov	x1, x20
blr	x8
LFQD_LBB61_2:
bl	LFQD_Context
mov	x20, x0
LFQD_Lloh1770:
adr x0, LFQD_l_.str.234
LFQD_Lloh1771:
nop
bl Lpatch + (0xa5b0 - PATCH_BASE)
mov	x21, x0
LFQD_Lloh1772:
adr x0, LFQD_l_.str.235
LFQD_Lloh1773:
nop
bl Lpatch + (0xa5a4 - PATCH_BASE)
mov	x1, x0
mov	x0, x21
bl Lpatch + (0xa5d4 - PATCH_BASE)
LFQD_Lloh1774:
adr x8, LFQD_l_.str.387
LFQD_Lloh1775:
nop
LFQD_Lloh1776:
adr x1, LFQD_l_.str.137
LFQD_Lloh1777:
nop
mov	x4, x0
mov	x0, x8
mov	x2, x19
mov	x3, x20
ldp	x29, x30, [sp, #32]
ldp	x20, x19, [sp, #16]
ldp	x22, x21, [sp], #48
b	LFQD_Emit
.cfi_endproc
.p2align	2
LFQD_ShortVideoAppear:
.cfi_startproc
LFQD_Lloh1778:
adr x3, LFQD_l_.str.139
LFQD_Lloh1779:
nop
LFQD_Lloh1780:
adr x4, LFQD_l_.str.137
LFQD_Lloh1781:
nop
LFQD_Lloh1782:
adr x5, LFQD_l_.str.388
LFQD_Lloh1783:
nop
b	LFQD_PageEvent
.cfi_endproc
.p2align	2
LFQD_ShortVideoDisappear:
.cfi_startproc
LFQD_Lloh1784:
adr x3, LFQD_l_.str.140
LFQD_Lloh1785:
nop
LFQD_Lloh1786:
adr x4, LFQD_l_.str.137
LFQD_Lloh1787:
nop
LFQD_Lloh1788:
adr x5, LFQD_l_.str.389
LFQD_Lloh1789:
nop
b	LFQD_PageEvent
.cfi_endproc
.p2align	2
LFQD_FQDAdDecision:
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
str	x5, [sp]
mov	x24, x4
stp	x0, x3, [sp, #16]
mov	x26, x2
bl	LFQD_Clock
str	x0, [sp, #8]
bl	LFQD_Lock
mov	x19, x0
LFQD_Lloh1790:
adr x0, LFQD_l_.str
LFQD_Lloh1791:
nop
bl Lpatch + (0xa5a4 - PATCH_BASE)
mov	x1, x0
mov	x0, x19
bl Lpatch + (0xa5d4 - PATCH_BASE)
LFQD_Lloh1792:
adr x0, LFQD_l_.str.70
LFQD_Lloh1793:
nop
bl Lpatch + (0xa5b0 - PATCH_BASE)
LFQD_Lloh1794:
adr x1, LFQD_StateKey
LFQD_Lloh1795:
nop
bl Lpatch + (0xa628 - PATCH_BASE)
LFQD_Lloh1796:
adr x1, LFQD_l_.str.34
LFQD_Lloh1797:
nop
bl	LFQD_At
mov	x23, x0
LFQD_Lloh1798:
adr x27, LFQD_l_.str.209
LFQD_Lloh1799:
nop
mov	x0, x27
bl Lpatch + (0xa5b0 - PATCH_BASE)
mov	x25, x0
LFQD_Lloh1800:
adr x28, LFQD_l_.str.221
LFQD_Lloh1801:
nop
mov	x0, x28
bl Lpatch + (0xa5a4 - PATCH_BASE)
mov	x1, x0
mov	x0, x25
mov	x2, x26
bl Lpatch + (0xa5d4 - PATCH_BASE)
mov	x20, x0
LFQD_Lloh1802:
adr x0, LFQD_l_.str.142
LFQD_Lloh1803:
nop
bl Lpatch + (0xa5a4 - PATCH_BASE)
mov	x1, x0
mov	x0, x23
mov	x2, x20
bl Lpatch + (0xa5d4 - PATCH_BASE)
mov	x25, x0
LFQD_Lloh1804:
adr x0, LFQD_l_.str.143
LFQD_Lloh1805:
nop
bl Lpatch + (0xa5a4 - PATCH_BASE)
mov	x1, x0
mov	x0, x25
bl Lpatch + (0xa5d4 - PATCH_BASE)
mov	x21, x0
add	x25, x0, #1
LFQD_Lloh1806:
adr x0, LFQD_l_.str.144
LFQD_Lloh1807:
nop
bl Lpatch + (0xa5a4 - PATCH_BASE)
mov	x22, x0
mov	x0, x27
bl Lpatch + (0xa5b0 - PATCH_BASE)
mov	x27, x0
mov	x0, x28
bl Lpatch + (0xa5a4 - PATCH_BASE)
mov	x1, x0
add	x2, x21, #1
mov	x0, x27
bl Lpatch + (0xa5d4 - PATCH_BASE)
mov	x2, x0
mov	x0, x23
mov	x1, x22
mov	x3, x20
bl Lpatch + (0xa5d4 - PATCH_BASE)
LFQD_Lloh1808:
adr x0, LFQD_l_.str.6
LFQD_Lloh1809:
nop
bl Lpatch + (0xa5a4 - PATCH_BASE)
mov	x1, x0
mov	x0, x19
bl Lpatch + (0xa5d4 - PATCH_BASE)
cmp	x21, #2
b.lt	LFQD_LBB64_3
and	x8, x25, #0x3f
cbz	x8, LFQD_LBB64_3
ldp	x29, x30, [sp, #112]
ldp	x20, x19, [sp, #96]
ldp	x22, x21, [sp, #80]
ldp	x24, x23, [sp, #64]
ldp	x26, x25, [sp, #48]
ldp	x28, x27, [sp, #32]
add	sp, sp, #128
ret
LFQD_LBB64_3:
LFQD_Lloh1810:
adr x0, LFQD_l_.str.234
LFQD_Lloh1811:
nop
bl Lpatch + (0xa5b0 - PATCH_BASE)
mov	x19, x0
LFQD_Lloh1812:
adr x0, LFQD_l_.str.235
LFQD_Lloh1813:
nop
bl Lpatch + (0xa5a4 - PATCH_BASE)
mov	x1, x0
mov	x0, x19
bl Lpatch + (0xa5d4 - PATCH_BASE)
mov	x23, x0
LFQD_Lloh1814:
adr x28, LFQD_l_.str.209
LFQD_Lloh1815:
nop
mov	x0, x28
bl Lpatch + (0xa5b0 - PATCH_BASE)
mov	x20, x0
LFQD_Lloh1816:
adr x19, LFQD_l_.str.221
LFQD_Lloh1817:
nop
mov	x0, x19
bl Lpatch + (0xa5a4 - PATCH_BASE)
mov	x1, x0
mov	x0, x20
mov	x2, x26
bl Lpatch + (0xa5d4 - PATCH_BASE)
mov	x2, x0
LFQD_Lloh1818:
adr x1, LFQD_l_.str.145
LFQD_Lloh1819:
nop
mov	x0, x23
bl	LFQD_Put
LFQD_Lloh1820:
adr x26, LFQD_l_.str.192
LFQD_Lloh1821:
nop
mov	x0, x26
bl Lpatch + (0xa5b0 - PATCH_BASE)
mov	x20, x0
LFQD_Lloh1822:
adr x27, LFQD_l_.str.215
LFQD_Lloh1823:
nop
mov	x0, x27
bl Lpatch + (0xa5a4 - PATCH_BASE)
mov	x1, x0
LFQD_Lloh1824:
adr x2, LFQD_l_.str.147
LFQD_Lloh1825:
nop
mov	x0, x20
bl Lpatch + (0xa5d4 - PATCH_BASE)
mov	x2, x0
LFQD_Lloh1826:
adr x1, LFQD_l_.str.146
LFQD_Lloh1827:
nop
mov	x0, x23
bl	LFQD_Put
mov	x0, x26
bl Lpatch + (0xa5b0 - PATCH_BASE)
mov	x20, x0
mov	x0, x27
bl Lpatch + (0xa5a4 - PATCH_BASE)
mov	x1, x0
mov	x0, x20
mov	x2, x24
bl Lpatch + (0xa5d4 - PATCH_BASE)
mov	x2, x0
LFQD_Lloh1828:
adr x1, LFQD_l_.str.148
LFQD_Lloh1829:
nop
mov	x0, x23
bl	LFQD_Put
mov	x0, x28
bl Lpatch + (0xa5b0 - PATCH_BASE)
mov	x20, x0
mov	x0, x19
bl Lpatch + (0xa5a4 - PATCH_BASE)
mov	x1, x0
mov	x0, x20
mov	w2, #1
bl Lpatch + (0xa5d4 - PATCH_BASE)
mov	x2, x0
LFQD_Lloh1830:
adr x1, LFQD_l_.str.149
LFQD_Lloh1831:
nop
mov	x0, x23
bl	LFQD_Put
LFQD_Lloh1832:
adr x8, LFQD_l_.str.152
LFQD_Lloh1833:
nop
LFQD_Lloh1834:
adr x9, LFQD_l_.str.151
LFQD_Lloh1835:
nop
ldr	x10, [sp]
cmp	x10, #8
csel	x20, x9, x8, lt
mov	x0, x26
bl Lpatch + (0xa5b0 - PATCH_BASE)
mov	x21, x0
mov	x0, x27
bl Lpatch + (0xa5a4 - PATCH_BASE)
mov	x1, x0
mov	x0, x21
mov	x2, x20
bl Lpatch + (0xa5d4 - PATCH_BASE)
mov	x2, x0
LFQD_Lloh1836:
adr x1, LFQD_l_.str.150
LFQD_Lloh1837:
nop
mov	x0, x23
bl	LFQD_Put
mov	x0, x28
bl Lpatch + (0xa5b0 - PATCH_BASE)
mov	x20, x0
mov	x0, x19
bl Lpatch + (0xa5a4 - PATCH_BASE)
mov	x1, x0
mov	x0, x20
mov	x2, x25
bl Lpatch + (0xa5d4 - PATCH_BASE)
mov	x2, x0
LFQD_Lloh1838:
adr x1, LFQD_l_.str.153
LFQD_Lloh1839:
nop
mov	x0, x23
bl	LFQD_Put
ldr	x0, [sp, #8]
bl	LFQD_Elapsed
mov	x2, x0
LFQD_Lloh1840:
adr x1, LFQD_l_.str.154
LFQD_Lloh1841:
nop
mov	x0, x23
bl	LFQD_Put
mov	x0, x28
bl Lpatch + (0xa5b0 - PATCH_BASE)
mov	x20, x0
mov	x0, x19
bl Lpatch + (0xa5a4 - PATCH_BASE)
mov	x1, x0
mov	x0, x20
mov	w2, #1
bl Lpatch + (0xa5d4 - PATCH_BASE)
mov	x2, x0
LFQD_Lloh1842:
adr x1, LFQD_l_.str.155
LFQD_Lloh1843:
nop
mov	x0, x23
bl	LFQD_Put
mov	x0, x26
bl Lpatch + (0xa5b0 - PATCH_BASE)
mov	x19, x0
mov	x0, x27
bl Lpatch + (0xa5a4 - PATCH_BASE)
mov	x1, x0
LFQD_Lloh1844:
adr x2, LFQD_l_.str.157
LFQD_Lloh1845:
nop
mov	x0, x19
bl Lpatch + (0xa5d4 - PATCH_BASE)
mov	x2, x0
LFQD_Lloh1846:
adr x1, LFQD_l_.str.156
LFQD_Lloh1847:
nop
mov	x0, x23
bl	LFQD_Put
mov	x0, x26
bl Lpatch + (0xa5b0 - PATCH_BASE)
mov	x19, x0
mov	x0, x27
bl Lpatch + (0xa5a4 - PATCH_BASE)
mov	x1, x0
LFQD_Lloh1848:
adr x2, LFQD_l_.str.159
LFQD_Lloh1849:
nop
mov	x0, x19
bl Lpatch + (0xa5d4 - PATCH_BASE)
mov	x2, x0
LFQD_Lloh1850:
adr x1, LFQD_l_.str.158
LFQD_Lloh1851:
nop
mov	x0, x23
bl	LFQD_Put
bl	LFQD_Context
LFQD_Lloh1852:
adr x8, LFQD_l_.str.160
LFQD_Lloh1853:
nop
mov	x3, x0
mov	x0, x8
ldp	x2, x1, [sp, #16]
mov	x4, x23
ldp	x29, x30, [sp, #112]
ldp	x20, x19, [sp, #96]
ldp	x22, x21, [sp, #80]
ldp	x24, x23, [sp, #64]
ldp	x26, x25, [sp, #48]
ldp	x28, x27, [sp, #32]
add	sp, sp, #128
b	LFQD_Emit
.cfi_endproc
.p2align	2
LFQD_Clock:
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
LFQD_Lloh1854:
adr x0, LFQD_l_.str.161
LFQD_Lloh1855:
nop
bl Lpatch + (0xa5b0 - PATCH_BASE)
mov	x19, x0
LFQD_Lloh1856:
adr x0, LFQD_l_.str.166
LFQD_Lloh1857:
nop
bl Lpatch + (0xa5a4 - PATCH_BASE)
mov	x1, x0
mov	x0, x19
bl Lpatch + (0xa5d4 - PATCH_BASE)
mov	x19, x0
LFQD_Lloh1858:
adr x0, LFQD_l_.str.390
LFQD_Lloh1859:
nop
bl Lpatch + (0xa5a4 - PATCH_BASE)
mov	x1, x0
mov	x0, x19
bl Lpatch + (0xa5d4 - PATCH_BASE)
mov.16b	v8, v0
LFQD_Lloh1860:
adr x0, LFQD_l_.str.209
LFQD_Lloh1861:
nop
bl Lpatch + (0xa5b0 - PATCH_BASE)
mov	x19, x0
LFQD_Lloh1862:
adr x0, LFQD_l_.str.233
LFQD_Lloh1863:
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
LFQD_Lock:
.cfi_startproc
stp	x29, x30, [sp, #-16]!
mov	x29, sp
.cfi_def_cfa w29, 16
.cfi_offset w30, -8
.cfi_offset w29, -16
LFQD_Lloh1864:
adr x0, LFQD_l_.str.70
LFQD_Lloh1865:
nop
bl Lpatch + (0xa5b0 - PATCH_BASE)
LFQD_Lloh1866:
adr x1, LFQD_StateKey
LFQD_Lloh1867:
nop
bl Lpatch + (0xa628 - PATCH_BASE)
LFQD_Lloh1868:
adr x1, LFQD_l_.str
LFQD_Lloh1869:
nop
ldp	x29, x30, [sp], #16
b	LFQD_At
.cfi_endproc
.p2align	2
LFQD_Elapsed:
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
bl	LFQD_Clock
mov	x20, x0
LFQD_Lloh1870:
adr x21, LFQD_l_.str.391
LFQD_Lloh1871:
nop
mov	x0, x21
bl Lpatch + (0xa5a4 - PATCH_BASE)
mov	x1, x0
mov	x0, x20
bl Lpatch + (0xa5d4 - PATCH_BASE)
mov.16b	v8, v0
mov	x0, x21
bl Lpatch + (0xa5a4 - PATCH_BASE)
mov	x1, x0
mov	x0, x19
bl Lpatch + (0xa5d4 - PATCH_BASE)
mov.16b	v9, v0
LFQD_Lloh1872:
adr x0, LFQD_l_.str.209
LFQD_Lloh1873:
nop
bl Lpatch + (0xa5b0 - PATCH_BASE)
mov	x19, x0
LFQD_Lloh1874:
adr x0, LFQD_l_.str.233
LFQD_Lloh1875:
nop
bl Lpatch + (0xa5a4 - PATCH_BASE)
mov	x1, x0
fsub	d0, d8, d9
mov	x0, x19
ldp	x29, x30, [sp, #48]
ldp	x20, x19, [sp, #32]
ldp	x22, x21, [sp, #16]
ldp	d9, d8, [sp], #64
b Lpatch + (0xa5d4 - PATCH_BASE)
.cfi_endproc
.p2align	2
LFQD_Context:
.cfi_startproc
stp	x20, x19, [sp, #-32]!
stp	x29, x30, [sp, #16]
add	x29, sp, #16
.cfi_def_cfa w29, 16
.cfi_offset w30, -8
.cfi_offset w29, -16
.cfi_offset w19, -24
.cfi_offset w20, -32
LFQD_Lloh1876:
adr x0, LFQD_l_.str.341
LFQD_Lloh1877:
nop
bl Lpatch + (0xa5b0 - PATCH_BASE)
mov	x19, x0
LFQD_Lloh1878:
adr x0, LFQD_l_.str.342
LFQD_Lloh1879:
nop
bl Lpatch + (0xa5a4 - PATCH_BASE)
mov	x1, x0
mov	x0, x19
bl Lpatch + (0xa5d4 - PATCH_BASE)
LFQD_Lloh1880:
adr x1, LFQD_ContextKey
LFQD_Lloh1881:
nop
bl Lpatch + (0xa628 - PATCH_BASE)
cbnz	x0, LFQD_LBB68_2
LFQD_Lloh1882:
adr x0, LFQD_l_.str.70
LFQD_Lloh1883:
nop
bl Lpatch + (0xa5b0 - PATCH_BASE)
LFQD_Lloh1884:
adr x1, LFQD_ContextKey
LFQD_Lloh1885:
nop
bl Lpatch + (0xa628 - PATCH_BASE)
cbz	x0, LFQD_LBB68_3
LFQD_LBB68_2:
ldp	x29, x30, [sp, #16]
ldp	x20, x19, [sp], #32
ret
LFQD_LBB68_3:
LFQD_Lloh1886:
adr x0, LFQD_l_.str.70
LFQD_Lloh1887:
nop
bl Lpatch + (0xa5b0 - PATCH_BASE)
ldp	x29, x30, [sp, #16]
ldp	x20, x19, [sp], #32
b	LFQD_Id
.cfi_endproc
.p2align	2
LFQD_LoadStateKey:
.cfi_startproc
ret
.cfi_endproc
.p2align	2
LFQD_UUID:
.cfi_startproc
stp	x20, x19, [sp, #-32]!
stp	x29, x30, [sp, #16]
add	x29, sp, #16
.cfi_def_cfa w29, 16
.cfi_offset w30, -8
.cfi_offset w29, -16
.cfi_offset w19, -24
.cfi_offset w20, -32
LFQD_Lloh1888:
adr x0, LFQD_l_.str.189
LFQD_Lloh1889:
nop
bl Lpatch + (0xa5b0 - PATCH_BASE)
mov	x19, x0
LFQD_Lloh1890:
adr x0, LFQD_l_.str.190
LFQD_Lloh1891:
nop
bl Lpatch + (0xa5a4 - PATCH_BASE)
mov	x1, x0
mov	x0, x19
bl Lpatch + (0xa5d4 - PATCH_BASE)
mov	x19, x0
LFQD_Lloh1892:
adr x0, LFQD_l_.str.191
LFQD_Lloh1893:
nop
bl Lpatch + (0xa5a4 - PATCH_BASE)
mov	x1, x0
mov	x0, x19
ldp	x29, x30, [sp, #16]
ldp	x20, x19, [sp], #32
b Lpatch + (0xa5d4 - PATCH_BASE)
.cfi_endproc
.p2align	2
LFQD_LoadMetadata:
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
LFQD_Lloh1894:
adr x1, LFQD_l_.str.192
LFQD_Lloh1895:
nop
bl	LFQD_Kind
cbz	w0, LFQD_LBB71_2
LFQD_Lloh1896:
adr x0, LFQD_l_.str.193
LFQD_Lloh1897:
nop
bl Lpatch + (0xa5a4 - PATCH_BASE)
mov	x1, x0
mov	x0, x19
bl Lpatch + (0xa5d4 - PATCH_BASE)
cmp	x0, x20
csel	x0, xzr, x19, gt
b	LFQD_LBB71_3
LFQD_LBB71_2:
mov	x0, #0
LFQD_LBB71_3:
ldp	x29, x30, [sp, #16]
ldp	x20, x19, [sp], #32
ret
.cfi_endproc
.p2align	2
LFQD_Kind:
.cfi_startproc
cbz	x0, LFQD_LBB72_2
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
LFQD_Lloh1898:
adr x0, LFQD_l_.str.194
LFQD_Lloh1899:
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
LFQD_LBB72_2:
ret
.cfi_endproc
.p2align	2
LFQD_LoadFailure:
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
LFQD_Lloh1900:
adr x0, LFQD_l_.str.209
LFQD_Lloh1901:
nop
bl Lpatch + (0xa5b0 - PATCH_BASE)
mov	x22, x0
LFQD_Lloh1902:
adr x0, LFQD_l_.str.221
LFQD_Lloh1903:
nop
bl Lpatch + (0xa5a4 - PATCH_BASE)
mov	x1, x0
mov	x0, x22
mov	w2, #1
bl Lpatch + (0xa5d4 - PATCH_BASE)
mov	x2, x0
LFQD_Lloh1904:
adr x1, LFQD_l_.str.187
LFQD_Lloh1905:
nop
mov	x0, x19
bl	LFQD_Put
LFQD_Lloh1906:
adr x0, LFQD_l_.str.192
LFQD_Lloh1907:
nop
bl Lpatch + (0xa5b0 - PATCH_BASE)
mov	x22, x0
LFQD_Lloh1908:
adr x0, LFQD_l_.str.215
LFQD_Lloh1909:
nop
bl Lpatch + (0xa5a4 - PATCH_BASE)
mov	x1, x0
mov	x0, x22
mov	x2, x21
bl Lpatch + (0xa5d4 - PATCH_BASE)
mov	x2, x0
LFQD_Lloh1910:
adr x1, LFQD_l_.str.188
LFQD_Lloh1911:
nop
mov	x0, x19
bl	LFQD_Put
cbz	x20, LFQD_LBB73_2
LFQD_Lloh1912:
adr x0, LFQD_l_.str.229
LFQD_Lloh1913:
nop
bl Lpatch + (0xa5a4 - PATCH_BASE)
mov	x1, x0
mov	x0, x20
bl Lpatch + (0xa5d4 - PATCH_BASE)
mov	x20, x0
LFQD_LBB73_2:
LFQD_Lloh1914:
adr x0, LFQD_l_.str.209
LFQD_Lloh1915:
nop
bl Lpatch + (0xa5b0 - PATCH_BASE)
mov	x21, x0
LFQD_Lloh1916:
adr x0, LFQD_l_.str.221
LFQD_Lloh1917:
nop
bl Lpatch + (0xa5a4 - PATCH_BASE)
mov	x1, x0
mov	x0, x21
mov	x2, x20
bl Lpatch + (0xa5d4 - PATCH_BASE)
mov	x2, x0
LFQD_Lloh1918:
adr x1, LFQD_l_.str.228
LFQD_Lloh1919:
nop
mov	x0, x19
ldp	x29, x30, [sp, #32]
ldp	x20, x19, [sp, #16]
ldp	x22, x21, [sp], #48
b	LFQD_Put
.cfi_endproc
.p2align	2
LFQD_Id:
.cfi_startproc
stp	x20, x19, [sp, #-32]!
stp	x29, x30, [sp, #16]
add	x29, sp, #16
.cfi_def_cfa w29, 16
.cfi_offset w30, -8
.cfi_offset w29, -16
.cfi_offset w19, -24
.cfi_offset w20, -32
cbz	x0, LFQD_LBB74_3
mov	x19, x0
LFQD_Lloh1920:
adr x1, LFQD_ObjectKey
LFQD_Lloh1921:
nop
bl Lpatch + (0xa628 - PATCH_BASE)
mov	x20, x0
cbnz	x0, LFQD_LBB74_4
bl	LFQD_UUID
mov	x20, x0
LFQD_Lloh1922:
adr x1, LFQD_ObjectKey
LFQD_Lloh1923:
nop
mov	x0, x19
mov	x2, x20
mov	w3, #769
bl Lpatch + (0xa634 - PATCH_BASE)
b	LFQD_LBB74_4
LFQD_LBB74_3:
mov	x20, #0
LFQD_LBB74_4:
mov	x0, x20
ldp	x29, x30, [sp, #16]
ldp	x20, x19, [sp], #32
ret
.cfi_endproc
.p2align	2
LFQD_ObjectKey:
.cfi_startproc
ret
.cfi_endproc
.p2align	2
LFQD_Responds:
.cfi_startproc
cbz	x0, LFQD_LBB76_2
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
LFQD_Lloh1924:
adr x0, LFQD_l_.str.249
LFQD_Lloh1925:
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
LFQD_LBB76_2:
ret
.cfi_endproc
.p2align	2
LFQD_Values:
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
LFQD_Lloh1926:
adr x0, LFQD_l_.str.234
LFQD_Lloh1927:
nop
bl Lpatch + (0xa5b0 - PATCH_BASE)
mov	x20, x0
LFQD_Lloh1928:
adr x0, LFQD_l_.str.235
LFQD_Lloh1929:
nop
bl Lpatch + (0xa5a4 - PATCH_BASE)
mov	x1, x0
mov	x0, x20
bl Lpatch + (0xa5d4 - PATCH_BASE)
mov	x20, x0
cmp	x19, #0
cset	w23, ne
LFQD_Lloh1930:
adr x21, LFQD_l_.str.209
LFQD_Lloh1931:
nop
mov	x0, x21
bl Lpatch + (0xa5b0 - PATCH_BASE)
mov	x24, x0
LFQD_Lloh1932:
adr x22, LFQD_l_.str.221
LFQD_Lloh1933:
nop
mov	x0, x22
bl Lpatch + (0xa5a4 - PATCH_BASE)
mov	x1, x0
mov	x0, x24
mov	x2, x23
bl Lpatch + (0xa5d4 - PATCH_BASE)
mov	x2, x0
LFQD_Lloh1934:
adr x1, LFQD_l_.str.262
LFQD_Lloh1935:
nop
mov	x0, x20
bl	LFQD_Put
mov	x0, x19
bl	LFQD_Id
mov	x2, x0
LFQD_Lloh1936:
adr x1, LFQD_l_.str.263
LFQD_Lloh1937:
nop
mov	x0, x20
bl	LFQD_Put
LFQD_Lloh1938:
adr x1, LFQD_l_.str.264
LFQD_Lloh1939:
nop
mov	x0, x19
bl	LFQD_Count
mov	x23, x0
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
LFQD_Lloh1940:
adr x1, LFQD_l_.str.12
LFQD_Lloh1941:
nop
mov	x0, x20
bl	LFQD_Put
LFQD_Lloh1942:
adr x1, LFQD_l_.str.266
LFQD_Lloh1943:
nop
mov	x0, x19
bl	LFQD_Count
mov	x23, x0
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
LFQD_Lloh1944:
adr x1, LFQD_l_.str.265
LFQD_Lloh1945:
nop
mov	x0, x20
bl	LFQD_Put
LFQD_Lloh1946:
adr x1, LFQD_l_.str.268
LFQD_Lloh1947:
nop
mov	x0, x19
bl	LFQD_Count
mov	x23, x0
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
LFQD_Lloh1948:
adr x1, LFQD_l_.str.267
LFQD_Lloh1949:
nop
mov	x0, x20
bl	LFQD_Put
LFQD_Lloh1950:
adr x23, LFQD_l_.str.270
LFQD_Lloh1951:
nop
mov	x0, x19
mov	x1, x23
bl	LFQD_Responds
mov	w24, w0
mov	x0, x21
bl Lpatch + (0xa5b0 - PATCH_BASE)
mov	x21, x0
mov	x0, x22
bl Lpatch + (0xa5a4 - PATCH_BASE)
mov	x1, x0
mov	x0, x21
mov	x2, x24
bl Lpatch + (0xa5d4 - PATCH_BASE)
mov	x2, x0
LFQD_Lloh1952:
adr x1, LFQD_l_.str.269
LFQD_Lloh1953:
nop
mov	x0, x20
bl	LFQD_Put
mov	x0, x19
mov	x1, x23
bl	LFQD_Responds
cbz	w0, LFQD_LBB77_2
LFQD_Lloh1954:
adr x0, LFQD_l_.str.270
LFQD_Lloh1955:
nop
bl Lpatch + (0xa5a4 - PATCH_BASE)
mov	x1, x0
mov	x0, x19
bl Lpatch + (0xa5d4 - PATCH_BASE)
sxtw	x23, w0
b	LFQD_LBB77_3
LFQD_LBB77_2:
mov	x23, #0
LFQD_LBB77_3:
LFQD_Lloh1956:
adr x21, LFQD_l_.str.209
LFQD_Lloh1957:
nop
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
LFQD_Lloh1958:
adr x1, LFQD_l_.str.271
LFQD_Lloh1959:
nop
mov	x0, x20
bl	LFQD_Put
LFQD_Lloh1960:
adr x1, LFQD_l_.str.272
LFQD_Lloh1961:
nop
mov	x0, x19
bl	LFQD_Get
mov	x23, x0
cmp	x0, #0
cset	w24, ne
mov	x0, x21
bl Lpatch + (0xa5b0 - PATCH_BASE)
mov	x25, x0
mov	x0, x22
bl Lpatch + (0xa5a4 - PATCH_BASE)
mov	x1, x0
mov	x0, x25
mov	x2, x24
bl Lpatch + (0xa5d4 - PATCH_BASE)
mov	x2, x0
LFQD_Lloh1962:
adr x1, LFQD_l_.str.273
LFQD_Lloh1963:
nop
mov	x0, x20
bl	LFQD_Put
LFQD_Lloh1964:
adr x1, LFQD_l_.str.12
LFQD_Lloh1965:
nop
mov	x0, x23
bl	LFQD_Count
mov	x23, x0
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
LFQD_Lloh1966:
adr x1, LFQD_l_.str.274
LFQD_Lloh1967:
nop
mov	x0, x20
bl	LFQD_Put
LFQD_Lloh1968:
adr x1, LFQD_l_.str.276
LFQD_Lloh1969:
nop
mov	x0, x19
bl	LFQD_Get
cmp	x0, #0
cset	w23, ne
mov	x0, x21
bl Lpatch + (0xa5b0 - PATCH_BASE)
mov	x21, x0
mov	x0, x22
bl Lpatch + (0xa5a4 - PATCH_BASE)
mov	x1, x0
mov	x0, x21
mov	x2, x23
bl Lpatch + (0xa5d4 - PATCH_BASE)
mov	x2, x0
LFQD_Lloh1970:
adr x1, LFQD_l_.str.275
LFQD_Lloh1971:
nop
mov	x0, x20
bl	LFQD_Put
LFQD_Lloh1972:
adr x21, LFQD_l_.str.277
LFQD_Lloh1973:
nop
mov	x0, x19
mov	x1, x21
bl	LFQD_Get
bl	LFQD_Pseudonym
mov	x2, x0
mov	x0, x20
mov	x1, x21
bl	LFQD_Put
LFQD_Lloh1974:
adr x21, LFQD_l_.str.278
LFQD_Lloh1975:
nop
mov	x0, x19
mov	x1, x21
bl	LFQD_Get
bl	LFQD_Pseudonym
mov	x2, x0
mov	x0, x20
mov	x1, x21
bl	LFQD_Put
mov	x0, x20
ldp	x29, x30, [sp, #64]
ldp	x20, x19, [sp, #48]
ldp	x22, x21, [sp, #32]
ldp	x24, x23, [sp, #16]
ldp	x26, x25, [sp], #80
ret
.cfi_endproc
.p2align	2
LFQD_Original:
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
bl Lpatch + (0xa664 - PATCH_BASE)
mov	x20, x0
mov	x0, x19
bl Lpatch + (0xa5a4 - PATCH_BASE)
mov	x1, x0
mov	x0, x20
bl Lpatch + (0xa5f8 - PATCH_BASE)
cbz	x0, LFQD_LBB78_2
ldp	x29, x30, [sp, #16]
ldp	x20, x19, [sp], #32
b Lpatch + (0xa598 - PATCH_BASE)
LFQD_LBB78_2:
ldp	x29, x30, [sp, #16]
ldp	x20, x19, [sp], #32
ret
.cfi_endproc
.p2align	2
LFQD_Count:
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
bl	LFQD_Responds
cbz	w0, LFQD_LBB79_2
mov	x0, x20
bl Lpatch + (0xa5a4 - PATCH_BASE)
mov	x1, x0
mov	x0, x19
ldp	x29, x30, [sp, #16]
ldp	x20, x19, [sp], #32
b Lpatch + (0xa5d4 - PATCH_BASE)
LFQD_LBB79_2:
mov	x0, #-1
ldp	x29, x30, [sp, #16]
ldp	x20, x19, [sp], #32
ret
.cfi_endproc
.p2align	2
LFQD_Pseudonym:
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
LFQD_Lloh1976:
adr x1, LFQD_l_.str.192
LFQD_Lloh1977:
nop
bl	LFQD_Kind
cbz	w0, LFQD_LBB80_2
LFQD_Lloh1978:
adr x0, LFQD_l_.str.193
LFQD_Lloh1979:
nop
bl Lpatch + (0xa5a4 - PATCH_BASE)
mov	x1, x0
mov	x0, x19
bl Lpatch + (0xa5d4 - PATCH_BASE)
cmp	x0, #256
b.le	LFQD_LBB80_3
LFQD_LBB80_2:
mov	x0, #0
ldp	x29, x30, [sp, #64]
ldp	x20, x19, [sp, #48]
ldp	x22, x21, [sp, #32]
ldp	x24, x23, [sp, #16]
ldp	x26, x25, [sp], #80
ret
LFQD_LBB80_3:
bl	LFQD_Lock
mov	x20, x0
LFQD_Lloh1980:
adr x0, LFQD_l_.str
LFQD_Lloh1981:
nop
bl Lpatch + (0xa5a4 - PATCH_BASE)
mov	x1, x0
mov	x0, x20
bl Lpatch + (0xa5d4 - PATCH_BASE)
LFQD_Lloh1982:
adr x0, LFQD_l_.str.70
LFQD_Lloh1983:
nop
bl Lpatch + (0xa5b0 - PATCH_BASE)
LFQD_Lloh1984:
adr x1, LFQD_StateKey
LFQD_Lloh1985:
nop
bl Lpatch + (0xa628 - PATCH_BASE)
LFQD_Lloh1986:
adr x1, LFQD_l_.str.35
LFQD_Lloh1987:
nop
bl	LFQD_At
mov	x21, x0
LFQD_Lloh1988:
adr x0, LFQD_l_.str.142
LFQD_Lloh1989:
nop
bl Lpatch + (0xa5a4 - PATCH_BASE)
mov	x1, x0
mov	x0, x21
mov	x2, x19
bl Lpatch + (0xa5d4 - PATCH_BASE)
mov	x22, x0
cbnz	x0, LFQD_LBB80_7
LFQD_Lloh1990:
adr x0, LFQD_l_.str.12
LFQD_Lloh1991:
nop
bl Lpatch + (0xa5a4 - PATCH_BASE)
mov	x1, x0
mov	x0, x21
bl Lpatch + (0xa5d4 - PATCH_BASE)
cmp	x0, #2048
b.lt	LFQD_LBB80_6
LFQD_Lloh1992:
adr x0, LFQD_l_.str.279
LFQD_Lloh1993:
nop
bl Lpatch + (0xa5a4 - PATCH_BASE)
mov	x1, x0
mov	x0, x21
bl Lpatch + (0xa5d4 - PATCH_BASE)
LFQD_Lloh1994:
adr x22, LFQD_l_.str.70
LFQD_Lloh1995:
nop
mov	x0, x22
bl Lpatch + (0xa5b0 - PATCH_BASE)
LFQD_Lloh1996:
adr x23, LFQD_StateKey
LFQD_Lloh1997:
nop
mov	x1, x23
bl Lpatch + (0xa628 - PATCH_BASE)
mov	x24, x0
mov	x0, x22
bl Lpatch + (0xa5b0 - PATCH_BASE)
mov	x1, x23
bl Lpatch + (0xa628 - PATCH_BASE)
LFQD_Lloh1998:
adr x22, LFQD_l_.str.36
LFQD_Lloh1999:
nop
mov	x1, x22
bl	LFQD_At
mov	x23, x0
LFQD_Lloh2000:
adr x0, LFQD_l_.str.143
LFQD_Lloh2001:
nop
bl Lpatch + (0xa5a4 - PATCH_BASE)
mov	x1, x0
mov	x0, x23
bl Lpatch + (0xa5d4 - PATCH_BASE)
mov	x23, x0
LFQD_Lloh2002:
adr x0, LFQD_l_.str.209
LFQD_Lloh2003:
nop
bl Lpatch + (0xa5b0 - PATCH_BASE)
mov	x25, x0
LFQD_Lloh2004:
adr x0, LFQD_l_.str.221
LFQD_Lloh2005:
nop
bl Lpatch + (0xa5a4 - PATCH_BASE)
mov	x1, x0
add	x2, x23, #1
mov	x0, x25
bl Lpatch + (0xa5d4 - PATCH_BASE)
mov	x2, x0
mov	x0, x24
mov	x1, x22
bl	LFQD_Put
LFQD_LBB80_6:
bl	LFQD_UUID
mov	x22, x0
LFQD_Lloh2006:
adr x0, LFQD_l_.str.144
LFQD_Lloh2007:
nop
bl Lpatch + (0xa5a4 - PATCH_BASE)
mov	x1, x0
mov	x0, x21
mov	x2, x22
mov	x3, x19
bl Lpatch + (0xa5d4 - PATCH_BASE)
LFQD_LBB80_7:
LFQD_Lloh2008:
adr x0, LFQD_l_.str.280
LFQD_Lloh2009:
nop
bl Lpatch + (0xa5a4 - PATCH_BASE)
mov	x1, x0
mov	x0, x22
bl Lpatch + (0xa5d4 - PATCH_BASE)
LFQD_Lloh2010:
adr x0, LFQD_l_.str.6
LFQD_Lloh2011:
nop
bl Lpatch + (0xa5a4 - PATCH_BASE)
mov	x1, x0
mov	x0, x20
bl Lpatch + (0xa5d4 - PATCH_BASE)
LFQD_Lloh2012:
adr x0, LFQD_l_.str.7
LFQD_Lloh2013:
nop
bl Lpatch + (0xa5a4 - PATCH_BASE)
mov	x1, x0
mov	x0, x22
ldp	x29, x30, [sp, #64]
ldp	x20, x19, [sp, #48]
ldp	x22, x21, [sp, #32]
ldp	x24, x23, [sp, #16]
ldp	x26, x25, [sp], #80
b Lpatch + (0xa5d4 - PATCH_BASE)
.cfi_endproc
.p2align	2
LFQD_ContextKey:
.cfi_startproc
ret
.cfi_endproc
.p2align	2
LFQD_ModelCount:
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
mov	x20, x4
mov	x23, x3
mov	x21, x2
mov	x22, x1
mov	x19, x0
LFQD_Lloh2014:
adr x24, LFQD_l_.str.192
LFQD_Lloh2015:
nop
mov	x0, x24
bl Lpatch + (0xa5b0 - PATCH_BASE)
mov	x25, x0
LFQD_Lloh2016:
adr x26, LFQD_l_.str.215
LFQD_Lloh2017:
nop
mov	x0, x26
bl Lpatch + (0xa5a4 - PATCH_BASE)
mov	x1, x0
mov	x0, x25
mov	x2, x23
bl Lpatch + (0xa5d4 - PATCH_BASE)
mov	x25, x0
LFQD_Lloh2018:
adr x0, LFQD_l_.str.10
LFQD_Lloh2019:
nop
bl Lpatch + (0xa5a4 - PATCH_BASE)
mov	x27, x0
mov	x0, x24
bl Lpatch + (0xa5b0 - PATCH_BASE)
mov	x24, x0
mov	x0, x26
bl Lpatch + (0xa5a4 - PATCH_BASE)
mov	x1, x0
LFQD_Lloh2020:
adr x2, LFQD_l_.str.63
LFQD_Lloh2021:
nop
mov	x0, x24
bl Lpatch + (0xa5d4 - PATCH_BASE)
mov	x2, x0
mov	x0, x25
mov	x1, x27
bl Lpatch + (0xa5d4 - PATCH_BASE)
cbz	w0, LFQD_LBB82_2
LFQD_Lloh2022:
adr x1, LFQD_l_.str.266
LFQD_Lloh2023:
nop
b	LFQD_LBB82_3
LFQD_LBB82_2:
LFQD_Lloh2024:
adr x24, LFQD_l_.str.192
LFQD_Lloh2025:
nop
mov	x0, x24
bl Lpatch + (0xa5b0 - PATCH_BASE)
mov	x25, x0
mov	x0, x26
bl Lpatch + (0xa5a4 - PATCH_BASE)
mov	x1, x0
mov	x0, x25
mov	x2, x23
bl Lpatch + (0xa5d4 - PATCH_BASE)
mov	x25, x0
LFQD_Lloh2026:
adr x0, LFQD_l_.str.10
LFQD_Lloh2027:
nop
bl Lpatch + (0xa5a4 - PATCH_BASE)
mov	x27, x0
mov	x0, x24
bl Lpatch + (0xa5b0 - PATCH_BASE)
mov	x24, x0
mov	x0, x26
bl Lpatch + (0xa5a4 - PATCH_BASE)
mov	x1, x0
LFQD_Lloh2028:
adr x2, LFQD_l_.str.67
LFQD_Lloh2029:
nop
mov	x0, x24
bl Lpatch + (0xa5d4 - PATCH_BASE)
mov	x2, x0
mov	x0, x25
mov	x1, x27
bl Lpatch + (0xa5d4 - PATCH_BASE)
LFQD_Lloh2030:
adr x8, LFQD_l_.str.268
LFQD_Lloh2031:
nop
LFQD_Lloh2032:
adr x9, LFQD_l_.str.264
LFQD_Lloh2033:
nop
cmp	w0, #0
csel	x1, x9, x8, eq
LFQD_LBB82_3:
mov	x0, x19
bl	LFQD_Count
cmp	x0, x21
b.ne	LFQD_LBB82_6
mov	x0, x19
mov	x1, x23
bl	LFQD_Original
cbz	x0, LFQD_LBB82_9
mov	x3, x0
mov	x0, x19
mov	x1, x22
mov	x2, x21
ldp	x29, x30, [sp, #80]
ldp	x20, x19, [sp, #64]
ldp	x22, x21, [sp, #48]
ldp	x24, x23, [sp, #32]
ldp	x26, x25, [sp, #16]
ldp	x28, x27, [sp], #96
br	x3
LFQD_LBB82_6:
LFQD_Lloh2034:
adr x0, LFQD_l_.str.234
LFQD_Lloh2035:
nop
bl Lpatch + (0xa5b0 - PATCH_BASE)
mov	x24, x0
LFQD_Lloh2036:
adr x0, LFQD_l_.str.235
LFQD_Lloh2037:
nop
bl Lpatch + (0xa5a4 - PATCH_BASE)
mov	x1, x0
mov	x0, x24
bl Lpatch + (0xa5d4 - PATCH_BASE)
mov	x24, x0
mov	x0, x19
bl	LFQD_Values
mov	x2, x0
LFQD_Lloh2038:
adr x1, LFQD_l_.str.257
LFQD_Lloh2039:
nop
mov	x0, x24
bl	LFQD_Put
LFQD_Lloh2040:
adr x0, LFQD_l_.str.209
LFQD_Lloh2041:
nop
bl Lpatch + (0xa5b0 - PATCH_BASE)
mov	x25, x0
LFQD_Lloh2042:
adr x0, LFQD_l_.str.221
LFQD_Lloh2043:
nop
bl Lpatch + (0xa5a4 - PATCH_BASE)
mov	x1, x0
mov	x0, x25
mov	x2, x21
bl Lpatch + (0xa5d4 - PATCH_BASE)
mov	x2, x0
LFQD_Lloh2044:
adr x1, LFQD_l_.str.294
LFQD_Lloh2045:
nop
mov	x0, x24
bl	LFQD_Put
mov	x0, x19
mov	x1, x23
bl	LFQD_Original
cbz	x0, LFQD_LBB82_8
mov	x8, x0
mov	x0, x19
mov	x1, x22
mov	x2, x21
blr	x8
LFQD_LBB82_8:
mov	x0, x19
bl	LFQD_Values
mov	x2, x0
LFQD_Lloh2046:
adr x1, LFQD_l_.str.260
LFQD_Lloh2047:
nop
mov	x0, x24
bl	LFQD_Put
LFQD_Lloh2048:
adr x0, LFQD_l_.str.192
LFQD_Lloh2049:
nop
bl Lpatch + (0xa5b0 - PATCH_BASE)
mov	x21, x0
LFQD_Lloh2050:
adr x0, LFQD_l_.str.215
LFQD_Lloh2051:
nop
bl Lpatch + (0xa5a4 - PATCH_BASE)
mov	x1, x0
LFQD_Lloh2052:
adr x2, LFQD_l_.str.296
LFQD_Lloh2053:
nop
mov	x0, x21
bl Lpatch + (0xa5d4 - PATCH_BASE)
mov	x2, x0
LFQD_Lloh2054:
adr x1, LFQD_l_.str.295
LFQD_Lloh2055:
nop
mov	x0, x24
bl	LFQD_Put
bl	LFQD_Context
LFQD_Lloh2056:
adr x8, LFQD_l_.str.297
LFQD_Lloh2057:
nop
mov	x3, x0
mov	x0, x8
mov	x1, x20
mov	x2, x19
mov	x4, x24
ldp	x29, x30, [sp, #80]
ldp	x20, x19, [sp, #64]
ldp	x22, x21, [sp, #48]
ldp	x24, x23, [sp, #32]
ldp	x26, x25, [sp, #16]
ldp	x28, x27, [sp], #96
b	LFQD_Emit
LFQD_LBB82_9:
ldp	x29, x30, [sp, #80]
ldp	x20, x19, [sp, #64]
ldp	x22, x21, [sp, #48]
ldp	x24, x23, [sp, #32]
ldp	x26, x25, [sp, #16]
ldp	x28, x27, [sp], #96
ret
.cfi_endproc
.p2align	2
LFQD_PanelKey:
.cfi_startproc
ret
.cfi_endproc
.p2align	2
LFQD_Panel:
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
mov	x24, x3
mov	x22, x2
mov	x23, x1
mov	x20, x0
LFQD_Lloh2058:
adr x1, LFQD_ContextKey
LFQD_Lloh2059:
nop
bl Lpatch + (0xa628 - PATCH_BASE)
mov	x21, x0
cbnz	x0, LFQD_LBB84_2
bl	LFQD_Context
mov	x21, x0
LFQD_Lloh2060:
adr x1, LFQD_ContextKey
LFQD_Lloh2061:
nop
mov	x0, x20
mov	x2, x21
mov	w3, #769
bl Lpatch + (0xa634 - PATCH_BASE)
LFQD_LBB84_2:
mov	x0, x20
mov	x1, x24
bl	LFQD_Original
cbz	x0, LFQD_LBB84_4
mov	x8, x0
mov	x0, x20
mov	x1, x23
mov	x2, x22
blr	x8
LFQD_LBB84_4:
LFQD_Lloh2062:
adr x0, LFQD_l_.str.234
LFQD_Lloh2063:
nop
bl Lpatch + (0xa5b0 - PATCH_BASE)
mov	x22, x0
LFQD_Lloh2064:
adr x0, LFQD_l_.str.235
LFQD_Lloh2065:
nop
bl Lpatch + (0xa5a4 - PATCH_BASE)
mov	x1, x0
mov	x0, x22
bl Lpatch + (0xa5d4 - PATCH_BASE)
LFQD_Lloh2066:
adr x1, LFQD_l_.str.75
LFQD_Lloh2067:
nop
mov	x4, x0
mov	x0, x19
mov	x2, x20
mov	x3, x21
ldp	x29, x30, [sp, #48]
ldp	x20, x19, [sp, #32]
ldp	x22, x21, [sp, #16]
ldp	x24, x23, [sp], #64
b	LFQD_Emit
.cfi_endproc
.p2align	2
LFQD_RequestKey:
.cfi_startproc
ret
.cfi_endproc
.p2align	2
LFQD_SendsKey:
.cfi_startproc
ret
.cfi_endproc
.p2align	2
LFQD_ExceptionKey:
.cfi_startproc
ret
.cfi_endproc
.p2align	2
LFQD_PageEvent:
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
mov	x20, x5
mov	x19, x4
mov	x25, x3
mov	x23, x2
mov	x24, x1
mov	x21, x0
LFQD_Lloh2068:
adr x1, LFQD_ContextKey
LFQD_Lloh2069:
nop
bl Lpatch + (0xa628 - PATCH_BASE)
mov	x22, x0
cbnz	x0, LFQD_LBB88_2
bl	LFQD_Context
mov	x22, x0
LFQD_Lloh2070:
adr x1, LFQD_ContextKey
LFQD_Lloh2071:
nop
mov	x0, x21
mov	x2, x22
mov	w3, #769
bl Lpatch + (0xa634 - PATCH_BASE)
LFQD_LBB88_2:
mov	x0, x21
mov	x1, x25
bl	LFQD_Original
cbz	x0, LFQD_LBB88_4
mov	x8, x0
mov	x0, x21
mov	x1, x24
mov	x2, x23
blr	x8
LFQD_LBB88_4:
LFQD_Lloh2072:
adr x23, LFQD_l_.str.192
LFQD_Lloh2073:
nop
mov	x0, x23
bl Lpatch + (0xa5b0 - PATCH_BASE)
mov	x24, x0
LFQD_Lloh2074:
adr x25, LFQD_l_.str.215
LFQD_Lloh2075:
nop
mov	x0, x25
bl Lpatch + (0xa5a4 - PATCH_BASE)
mov	x1, x0
mov	x0, x24
mov	x2, x20
bl Lpatch + (0xa5d4 - PATCH_BASE)
mov	x24, x0
LFQD_Lloh2076:
adr x0, LFQD_l_.str.10
LFQD_Lloh2077:
nop
bl Lpatch + (0xa5a4 - PATCH_BASE)
mov	x26, x0
mov	x0, x23
bl Lpatch + (0xa5b0 - PATCH_BASE)
mov	x23, x0
mov	x0, x25
bl Lpatch + (0xa5a4 - PATCH_BASE)
mov	x1, x0
LFQD_Lloh2078:
adr x2, LFQD_l_.str.388
LFQD_Lloh2079:
nop
mov	x0, x23
bl Lpatch + (0xa5d4 - PATCH_BASE)
mov	x2, x0
mov	x0, x24
mov	x1, x26
bl Lpatch + (0xa5d4 - PATCH_BASE)
cbz	w0, LFQD_LBB88_6
LFQD_Lloh2080:
adr x0, LFQD_l_.str.16
LFQD_Lloh2081:
nop
bl	LFQD_FQDLoadStage
LFQD_LBB88_6:
LFQD_Lloh2082:
adr x0, LFQD_l_.str.234
LFQD_Lloh2083:
nop
bl Lpatch + (0xa5b0 - PATCH_BASE)
mov	x23, x0
LFQD_Lloh2084:
adr x0, LFQD_l_.str.235
LFQD_Lloh2085:
nop
bl Lpatch + (0xa5a4 - PATCH_BASE)
mov	x1, x0
mov	x0, x23
bl Lpatch + (0xa5d4 - PATCH_BASE)
mov	x4, x0
mov	x0, x20
mov	x1, x19
mov	x2, x21
mov	x3, x22
ldp	x29, x30, [sp, #64]
ldp	x20, x19, [sp, #48]
ldp	x22, x21, [sp, #32]
ldp	x24, x23, [sp, #16]
ldp	x26, x25, [sp], #80
b	LFQD_Emit
.cfi_endproc
// @COMPONENT_DATA
LFQD_l_.str:
.asciz	"lock"
LFQD_l_.str.1:
.asciz	"report"
LFQD_l_.str.2:
.asciz	"mutableCopy"
LFQD_l_.str.3:
.asciz	"stages"
LFQD_l_.str.4:
.asciz	"copy"
LFQD_l_.str.5:
.asciz	"release"
LFQD_l_.str.6:
.asciz	"unlock"
LFQD_l_.str.7:
.asciz	"autorelease"
LFQD_l_.str.8:
.asciz	"complete"
LFQD_l_.str.9:
.asciz	"boolValue"
LFQD_l_.str.10:
.asciz	"isEqualToString:"
LFQD_l_.str.11:
.asciz	"stage"
LFQD_l_.str.12:
.asciz	"count"
LFQD_l_.str.13:
.asciz	"stagesTruncated"
LFQD_l_.str.14:
.asciz	"time"
LFQD_l_.str.15:
.asciz	"addObject:"
LFQD_l_.str.16:
.asciz	"firstPageDidAppear"
LFQD_l_.str.17:
.asciz	"pluginLoad"
LFQD_l_.str.18:
.asciz	"FanqieX"
LFQD_l_.str.19:
.asciz	"fqx164_diagnosticMode:"
LFQD_l_.str.20:
.asciz	"v24@0:8@16"
LFQD_l_.str.21:
.asciz	"navigationItem"
LFQD_l_.str.22:
.asciz	"rightBarButtonItem"
LFQD_l_.str.23:
.asciz	"UIBarButtonItem"
LFQD_l_.str.24:
.asciz	"alloc"
LFQD_l_.str.25:
.asciz	"initWithTitle:style:target:action:"
LFQD_l_.str.26:
.asciz	"\345\242\236\345\274\272\350\257\212\346\226\255\345\274\200"
LFQD_l_.str.27:
.asciz	"\345\242\236\345\274\272\350\257\212\346\226\255\345\205\263"
LFQD_l_.str.28:
.asciz	"NSArray"
LFQD_l_.str.29:
.asciz	"arrayWithObjects:count:"
LFQD_l_.str.30:
.asciz	"setRightBarButtonItems:"
LFQD_l_.str.31:
.asciz	"diagnosticsInstallBegin"
LFQD_l_.str.32:
.asciz	"NSLock"
LFQD_l_.str.33:
.asciz	"init"
LFQD_l_.str.34:
.asciz	"ruleCounts"
LFQD_l_.str.35:
.asciz	"identityLabels"
LFQD_l_.str.36:
.asciz	"identityGeneration"
LFQD_l_.str.37:
.asciz	"FanqieXDiagnosticsObserver"
LFQD_l_.str.38:
.asciz	"NSObject"
LFQD_l_.str.39:
.asciz	"fqx164_actionTimeout:"
LFQD_l_.str.40:
.asciz	"observer"
LFQD_l_.str.41:
.asciz	"FQCReaderParagraphEndView"
LFQD_l_.str.42:
.asciz	"setModel:"
LFQD_l_.str.43:
.asciz	"fqx164_bind"
LFQD_l_.str.44:
.asciz	"updateIdeaLabelCount"
LFQD_l_.str.45:
.asciz	"v16@0:8"
LFQD_l_.str.46:
.asciz	"fqx164_bubbleUpdate"
LFQD_l_.str.47:
.asciz	"ideaCountTap"
LFQD_l_.str.48:
.asciz	"fqx164_bubbleTap"
LFQD_l_.str.49:
.asciz	"setHidden:"
LFQD_l_.str.50:
.asciz	"v20@0:8B16"
LFQD_l_.str.51:
.asciz	"fqx164_hidden"
LFQD_l_.str.52:
.asciz	"removeFromSuperview"
LFQD_l_.str.53:
.asciz	"fqx164_removed"
LFQD_l_.str.54:
.asciz	"didMoveToWindow"
LFQD_l_.str.55:
.asciz	"fqx164_window"
LFQD_l_.str.56:
.asciz	"dealloc"
LFQD_l_.str.57:
.asciz	"fqx164_dealloc"
LFQD_l_.str.58:
.asciz	"FQCParagraphEntranceViewModel"
LFQD_l_.str.59:
.asciz	"setIdeaCount:"
LFQD_l_.str.60:
.asciz	"v24@0:8q16"
LFQD_l_.str.61:
.asciz	"fqx164_entranceCount"
LFQD_l_.str.62:
.asciz	"setIdeaOriginCount:"
LFQD_l_.str.63:
.asciz	"fqx164_entranceOrigin"
LFQD_l_.str.64:
.asciz	"SSParagraphIdeaDataVal"
LFQD_l_.str.65:
.asciz	"fqx164_dataCount"
LFQD_l_.str.66:
.asciz	"set_ideaCount:"
LFQD_l_.str.67:
.asciz	"fqx164_dataRaw"
LFQD_l_.str.68:
.asciz	"setBubbleData:"
LFQD_l_.str.69:
.asciz	"fqx164_bubbleData"
LFQD_l_.str.70:
.asciz	"SSReaderParagraphCommentAdapter"
LFQD_l_.str.71:
.asciz	"showParagraphCommentVCWithOpenParams:"
LFQD_l_.str.72:
.asciz	"fqx164_open"
LFQD_l_.str.73:
.asciz	"paragraphCommentPanelDidDismissForSessionToken:"
LFQD_l_.str.74:
.asciz	"fqx164_dismiss"
LFQD_l_.str.75:
.asciz	"FQCParagraphCommentListViewController"
LFQD_l_.str.76:
.asciz	"viewDidAppear:"
LFQD_l_.str.77:
.asciz	"fqx164_appeared"
LFQD_l_.str.78:
.asciz	"viewWillDisappear:"
LFQD_l_.str.79:
.asciz	"fqx164_willDisappear"
LFQD_l_.str.80:
.asciz	"viewDidDisappear:"
LFQD_l_.str.81:
.asciz	"fqx164_disappeared"
LFQD_l_.str.82:
.asciz	"SSReaderCommunityDataManager"
LFQD_l_.str.83:
.asciz	"paragraphIdeaUpdateCountWithChapterId:bookId:paraIndex:count:"
LFQD_l_.str.84:
.asciz	"v48@0:8@16@24q32q40"
LFQD_l_.str.85:
.asciz	"fqx164_commit"
LFQD_l_.str.86:
.asciz	"FQCCommunityReaderDataDispatcher"
LFQD_l_.str.87:
.asciz	"saveParagraphIdeaListIntoCacheWithChapterId:paragraphListData:"
LFQD_l_.str.88:
.asciz	"v32@0:8@16@24"
LFQD_l_.str.89:
.asciz	"fqx164_cache"
LFQD_l_.str.90:
.asciz	"BDRpcAsyncOperation"
LFQD_l_.str.91:
.asciz	"initWithRequest:completion:"
LFQD_l_.str.92:
.asciz	"@32@0:8@16@?24"
LFQD_l_.str.93:
.asciz	"fqx164_requestInit"
LFQD_l_.str.94:
.asciz	"sendRequest"
LFQD_l_.str.95:
.asciz	"fqx164_send"
LFQD_l_.str.96:
.asciz	"cancel"
LFQD_l_.str.97:
.asciz	"fqx164_cancel"
LFQD_l_.str.98:
.asciz	"completeOperation"
LFQD_l_.str.99:
.asciz	"fqx164_complete"
LFQD_l_.str.100:
.asciz	"_postHandleResult:headerFields:"
LFQD_l_.str.101:
.asciz	"fqx164_response"
LFQD_l_.str.102:
.asciz	"BDRpcResponse"
LFQD_l_.str.103:
.asciz	"initWithRequest:response:"
LFQD_l_.str.104:
.asciz	"@32@0:8@16@24"
LFQD_l_.str.105:
.asciz	"fqx164_transport"
LFQD_l_.str.106:
.asciz	"UIApplication"
LFQD_l_.str.107:
.asciz	"sendAction:to:from:forEvent:"
LFQD_l_.str.108:
.asciz	"B48@0:8:16@24@32@40"
LFQD_l_.str.109:
.asciz	"fqx164_sendAction"
LFQD_l_.str.110:
.asciz	"UINavigationController"
LFQD_l_.str.111:
.asciz	"pushViewController:animated:"
LFQD_l_.str.112:
.asciz	"v28@0:8@16B24"
LFQD_l_.str.113:
.asciz	"fqx164_push"
LFQD_l_.str.114:
.asciz	"popViewControllerAnimated:"
LFQD_l_.str.115:
.asciz	"@20@0:8B16"
LFQD_l_.str.116:
.asciz	"fqx164_pop"
LFQD_l_.str.117:
.asciz	"NSException"
LFQD_l_.str.118:
.asciz	"raise"
LFQD_l_.str.119:
.asciz	"fqx164_exception"
LFQD_l_.str.120:
.asciz	"BDReaderViewController"
LFQD_l_.str.121:
.asciz	"viewDidLoad"
LFQD_l_.str.122:
.asciz	"fqx164_ReaderLoad"
LFQD_l_.str.123:
.asciz	"fqx164_ReaderAppear"
LFQD_l_.str.124:
.asciz	"fqx164_ReaderDisappear"
LFQD_l_.str.125:
.asciz	"SSBookStoreNewViewController"
LFQD_l_.str.126:
.asciz	"fqx164_StoreLoad"
LFQD_l_.str.127:
.asciz	"fqx164_StoreAppear"
LFQD_l_.str.128:
.asciz	"fqx164_StoreDisappear"
LFQD_l_.str.129:
.asciz	"SSBookShelf525ViewController"
LFQD_l_.str.130:
.asciz	"fqx164_ShelfLoad"
LFQD_l_.str.131:
.asciz	"fqx164_ShelfAppear"
LFQD_l_.str.132:
.asciz	"fqx164_ShelfDisappear"
LFQD_l_.str.133:
.asciz	"SSMine737KMPViewController"
LFQD_l_.str.134:
.asciz	"fqx164_MineLoad"
LFQD_l_.str.135:
.asciz	"fqx164_MineAppear"
LFQD_l_.str.136:
.asciz	"fqx164_MineDisappear"
LFQD_l_.str.137:
.asciz	"SSShortVideoRcmdMainViewController"
LFQD_l_.str.138:
.asciz	"fqx164_ShortVideoLoad"
LFQD_l_.str.139:
.asciz	"fqx164_ShortVideoAppear"
LFQD_l_.str.140:
.asciz	"fqx164_ShortVideoDisappear"
LFQD_l_.str.141:
.asciz	"diagnosticsInstallComplete"
LFQD_l_.str.142:
.asciz	"objectForKey:"
LFQD_l_.str.143:
.asciz	"longLongValue"
LFQD_l_.str.144:
.asciz	"setObject:forKey:"
LFQD_l_.str.145:
.asciz	"ruleId"
LFQD_l_.str.146:
.asciz	"ruleType"
LFQD_l_.str.147:
.asciz	"exactHostMethod"
LFQD_l_.str.148:
.asciz	"selector"
LFQD_l_.str.149:
.asciz	"matched"
LFQD_l_.str.150:
.asciz	"result"
LFQD_l_.str.151:
.asciz	"blocked"
LFQD_l_.str.152:
.asciz	"skipped"
LFQD_l_.str.153:
.asciz	"callCount"
LFQD_l_.str.154:
.asciz	"duration"
LFQD_l_.str.155:
.asciz	"methodOwnedByTarget"
LFQD_l_.str.156:
.asciz	"inputSummary"
LFQD_l_.str.157:
.asciz	"argumentsOmitted"
LFQD_l_.str.158:
.asciz	"pageDisplay"
LFQD_l_.str.159:
.asciz	"unobserved"
LFQD_l_.str.160:
.asciz	"adRuleDecision"
LFQD_l_.str.161:
.asciz	"NSProcessInfo"
LFQD_l_.str.162:
.asciz	"version"
LFQD_l_.str.163:
.asciz	"sessionId"
LFQD_l_.str.164:
.asciz	"startedAt"
LFQD_l_.str.165:
.asciz	"osVersion"
LFQD_l_.str.166:
.asciz	"processInfo"
LFQD_l_.str.167:
.asciz	"operatingSystemVersionString"
LFQD_l_.str.168:
.asciz	"NSBundle"
LFQD_l_.str.169:
.asciz	"mainBundle"
LFQD_l_.str.170:
.asciz	"hostVersion"
LFQD_l_.str.171:
.asciz	"objectForInfoDictionaryKey:"
LFQD_l_.str.172:
.asciz	"CFBundleShortVersionString"
LFQD_l_.str.173:
.asciz	"hostBuild"
LFQD_l_.str.174:
.asciz	"CFBundleVersion"
LFQD_l_.str.175:
.asciz	"NSMutableArray"
LFQD_l_.str.176:
.asciz	"array"
LFQD_l_.str.177:
.asciz	"NSFileManager"
LFQD_l_.str.178:
.asciz	"defaultManager"
LFQD_l_.str.179:
.asciz	"URLsForDirectory:inDomains:"
LFQD_l_.str.180:
.asciz	"firstObject"
LFQD_l_.str.181:
.asciz	"URLByAppendingPathComponent:"
LFQD_l_.str.182:
.asciz	"load-diagnostics.json"
LFQD_l_.str.183:
.asciz	"directory"
LFQD_l_.str.184:
.asciz	"url"
LFQD_l_.str.185:
.asciz	"previousRead"
LFQD_l_.str.186:
.asciz	"documentsUnavailable"
LFQD_l_.str.187:
.asciz	"writeFailed"
LFQD_l_.str.188:
.asciz	"writeFailure"
LFQD_l_.str.189:
.asciz	"NSUUID"
LFQD_l_.str.190:
.asciz	"UUID"
LFQD_l_.str.191:
.asciz	"UUIDString"
LFQD_l_.str.192:
.asciz	"NSString"
LFQD_l_.str.193:
.asciz	"length"
LFQD_l_.str.194:
.asciz	"isKindOfClass:"
LFQD_l_.str.195:
.asciz	"path"
LFQD_l_.str.196:
.asciz	"fileExistsAtPath:"
LFQD_l_.str.197:
.asciz	"absent"
LFQD_l_.str.198:
.asciz	"attributesOfItemAtPath:error:"
LFQD_l_.str.199:
.asciz	"NSFileSize"
LFQD_l_.str.200:
.asciz	"unsignedLongLongValue"
LFQD_l_.str.201:
.asciz	"oversized"
LFQD_l_.str.202:
.asciz	"statFailed"
LFQD_l_.str.203:
.asciz	"NSData"
LFQD_l_.str.204:
.asciz	"dataWithContentsOfURL:options:error:"
LFQD_l_.str.205:
.asciz	"readFailed"
LFQD_l_.str.206:
.asciz	"NSJSONSerialization"
LFQD_l_.str.207:
.asciz	"JSONObjectWithData:options:error:"
LFQD_l_.str.208:
.asciz	"NSDictionary"
LFQD_l_.str.209:
.asciz	"NSNumber"
LFQD_l_.str.210:
.asciz	"invalid"
LFQD_l_.str.211:
.asciz	"previous"
LFQD_l_.str.212:
.asciz	"loaded"
LFQD_l_.str.213:
.asciz	"NSNull"
LFQD_l_.str.214:
.asciz	"null"
LFQD_l_.str.215:
.asciz	"stringWithUTF8String:"
LFQD_l_.str.216:
.asciz	"entry"
LFQD_l_.str.217:
.asciz	"startupPopupInstalled"
LFQD_l_.str.218:
.asciz	"legacyHooksInstalled"
LFQD_l_.str.219:
.asciz	"loadFinished"
LFQD_l_.str.220:
.asciz	"loggerReady"
LFQD_l_.str.221:
.asciz	"numberWithLongLong:"
LFQD_l_.str.222:
.asciz	"directoryReady"
LFQD_l_.str.223:
.asciz	"createDirectoryAtURL:withIntermediateDirectories:attributes:error:"
LFQD_l_.str.224:
.asciz	"directoryFailed"
LFQD_l_.str.225:
.asciz	"dataWithJSONObject:options:error:"
LFQD_l_.str.226:
.asciz	"serializationFailed"
LFQD_l_.str.227:
.asciz	"writeToURL:options:error:"
LFQD_l_.str.228:
.asciz	"writeErrorCode"
LFQD_l_.str.229:
.asciz	"code"
LFQD_l_.str.230:
.asciz	"NSDate"
LFQD_l_.str.231:
.asciz	"date"
LFQD_l_.str.232:
.asciz	"timeIntervalSince1970"
LFQD_l_.str.233:
.asciz	"numberWithDouble:"
LFQD_l_.str.234:
.asciz	"NSMutableDictionary"
LFQD_l_.str.235:
.asciz	"dictionary"
LFQD_l_.str.236:
.asciz	"class"
LFQD_l_.str.237:
.asciz	"objectId"
LFQD_l_.str.238:
.asciz	"correlationId"
LFQD_l_.str.239:
.asciz	"uptime"
LFQD_l_.str.240:
.asciz	"activityOrdinal"
LFQD_l_.str.241:
.asciz	"activity"
LFQD_l_.str.242:
.asciz	"NSUserDefaults"
LFQD_l_.str.243:
.asciz	"standardUserDefaults"
LFQD_l_.str.244:
.asciz	"setBool:forKey:"
LFQD_l_.str.245:
.asciz	"FanqieX.EnhancedDiagnostics.1"
LFQD_l_.str.246:
.asciz	"setTitle:"
LFQD_l_.str.247:
.asciz	"enhanced"
LFQD_l_.str.248:
.asciz	"diagnosticModeChanged"
LFQD_l_.str.249:
.asciz	"respondsToSelector:"
LFQD_l_.str.250:
.asciz	"boolForKey:"
LFQD_l_.str.251:
.asciz	"watchdogs"
LFQD_l_.str.252:
.asciz	"noObservedTransition"
LFQD_l_.str.253:
.asciz	"timeoutSeconds"
LFQD_l_.str.254:
.asciz	"coverage"
LFQD_l_.str.255:
.asciz	"monitoredHostEventsOnly"
LFQD_l_.str.256:
.asciz	"uiActionObservationTimeout"
LFQD_l_.str.257:
.asciz	"before"
LFQD_l_.str.258:
.asciz	"model"
LFQD_l_.str.259:
.asciz	"afterInput"
LFQD_l_.str.260:
.asciz	"after"
LFQD_l_.str.261:
.asciz	"commentBubbleBind"
LFQD_l_.str.262:
.asciz	"modelPresent"
LFQD_l_.str.263:
.asciz	"modelId"
LFQD_l_.str.264:
.asciz	"ideaCount"
LFQD_l_.str.265:
.asciz	"originalCount"
LFQD_l_.str.266:
.asciz	"ideaOriginCount"
LFQD_l_.str.267:
.asciz	"rawCount"
LFQD_l_.str.268:
.asciz	"_ideaCount"
LFQD_l_.str.269:
.asciz	"cacheFlagKnown"
LFQD_l_.str.270:
.asciz	"isFromCache"
LFQD_l_.str.271:
.asciz	"fromCache"
LFQD_l_.str.272:
.asciz	"bubbleData"
LFQD_l_.str.273:
.asciz	"bubbleDataPresent"
LFQD_l_.str.274:
.asciz	"bubbleDataCount"
LFQD_l_.str.275:
.asciz	"currentBubblePresent"
LFQD_l_.str.276:
.asciz	"currentBubbleData"
LFQD_l_.str.277:
.asciz	"chapterId"
LFQD_l_.str.278:
.asciz	"paragraphId"
LFQD_l_.str.279:
.asciz	"removeAllObjects"
LFQD_l_.str.280:
.asciz	"retain"
LFQD_l_.str.281:
.asciz	"hidden"
LFQD_l_.str.282:
.asciz	"isHidden"
LFQD_l_.str.283:
.asciz	"commentBubbleCountUI"
LFQD_l_.str.284:
.asciz	"commentBubbleTap"
LFQD_l_.str.285:
.asciz	"beforeHidden"
LFQD_l_.str.286:
.asciz	"requestedHidden"
LFQD_l_.str.287:
.asciz	"afterHidden"
LFQD_l_.str.288:
.asciz	"commentBubbleHidden"
LFQD_l_.str.289:
.asciz	"commentBubbleRemoved"
LFQD_l_.str.290:
.asciz	"attached"
LFQD_l_.str.291:
.asciz	"window"
LFQD_l_.str.292:
.asciz	"commentBubbleAttachment"
LFQD_l_.str.293:
.asciz	"commentBubbleDealloc"
LFQD_l_.str.294:
.asciz	"newValue"
LFQD_l_.str.295:
.asciz	"source"
LFQD_l_.str.296:
.asciz	"modelSetter"
LFQD_l_.str.297:
.asciz	"commentCountChanged"
LFQD_l_.str.298:
.asciz	"incomingPresent"
LFQD_l_.str.299:
.asciz	"incomingCount"
LFQD_l_.str.300:
.asciz	"commentDataReplaced"
LFQD_l_.str.301:
.asciz	"commentPanelOpenBegin"
LFQD_l_.str.302:
.asciz	"paragraphCommentPanelSessionToken"
LFQD_l_.str.303:
.asciz	"sessionTokenId"
LFQD_l_.str.304:
.asciz	"commentPanelOpenReturned"
LFQD_l_.str.305:
.asciz	"commentPanelDismissBegin"
LFQD_l_.str.306:
.asciz	"commentPanelDismissReturned"
LFQD_l_.str.307:
.asciz	"commentPanelDidAppear"
LFQD_l_.str.308:
.asciz	"commentPanelWillDisappear"
LFQD_l_.str.309:
.asciz	"commentPanelDidDisappear"
LFQD_l_.str.310:
.asciz	"bookId"
LFQD_l_.str.311:
.asciz	"paragraphIndex"
LFQD_l_.str.312:
.asciz	"commentListCompletion"
LFQD_l_.str.313:
.asciz	"commentCountCommitBegin"
LFQD_l_.str.314:
.asciz	"commentCountCommitReturned"
LFQD_l_.str.315:
.asciz	"dataPresent"
LFQD_l_.str.316:
.asciz	"cacheWriteCall"
LFQD_l_.str.317:
.asciz	"returned"
LFQD_l_.str.318:
.asciz	"commentCacheWrite"
LFQD_l_.str.319:
.asciz	"requestId"
LFQD_l_.str.320:
.asciz	"method"
LFQD_l_.str.321:
.asciz	"POST"
LFQD_l_.str.322:
.asciz	"startedUptime"
LFQD_l_.str.323:
.asciz	"requestsIssued"
LFQD_l_.str.324:
.asciz	"requestOrdinal"
LFQD_l_.str.325:
.asciz	"commentRequestCreated"
LFQD_l_.str.326:
.asciz	"operationType"
LFQD_l_.str.327:
.asciz	"$POST /novel/commentapi/idea/list/:item_id/v1/"
LFQD_l_.str.328:
.asciz	"idea/list/:item_id/v1"
LFQD_l_.str.329:
.asciz	"$POST /novel/commentapi/comment/list/:group_id/v1/"
LFQD_l_.str.330:
.asciz	"comment/list/:group_id/v1"
LFQD_l_.str.331:
.asciz	"sendCount"
LFQD_l_.str.332:
.asciz	"send"
LFQD_l_.str.333:
.asciz	"retry"
LFQD_l_.str.334:
.asciz	"commentRequestSend"
LFQD_l_.str.335:
.asciz	"commentRequestCancel"
LFQD_l_.str.336:
.asciz	"error"
LFQD_l_.str.337:
.asciz	"errorPresent"
LFQD_l_.str.338:
.asciz	"errorCode"
LFQD_l_.str.339:
.asciz	"operationComplete"
LFQD_l_.str.340:
.asciz	"commentRequestComplete"
LFQD_l_.str.341:
.asciz	"NSThread"
LFQD_l_.str.342:
.asciz	"currentThread"
LFQD_l_.str.343:
.asciz	"resultPresent"
LFQD_l_.str.344:
.asciz	"lastResponseOrdinal"
LFQD_l_.str.345:
.asciz	"responseOutOfOrder"
LFQD_l_.str.346:
.asciz	"resultCount"
LFQD_l_.str.347:
.asciz	"headersPresent"
LFQD_l_.str.348:
.asciz	"jsonStructurePresent"
LFQD_l_.str.349:
.asciz	"data"
LFQD_l_.str.350:
.asciz	"dataFieldPresent"
LFQD_l_.str.351:
.asciz	"data_list"
LFQD_l_.str.352:
.asciz	"listFieldPresent"
LFQD_l_.str.353:
.asciz	"listCount"
LFQD_l_.str.354:
.asciz	"totalFieldPresent"
LFQD_l_.str.355:
.asciz	"total"
LFQD_l_.str.356:
.asciz	"paginationFieldPresent"
LFQD_l_.str.357:
.asciz	"has_more"
LFQD_l_.str.358:
.asciz	"parsedResultBeforeCompletion"
LFQD_l_.str.359:
.asciz	"commentResponseParsed"
LFQD_l_.str.360:
.asciz	"commentResponseDelivered"
LFQD_l_.str.361:
.asciz	"rawData"
LFQD_l_.str.362:
.asciz	"statusCode"
LFQD_l_.str.363:
.asciz	"responseBytes"
LFQD_l_.str.364:
.asciz	"transportResponse"
LFQD_l_.str.365:
.asciz	"commentNetworkResponse"
LFQD_l_.str.366:
.asciz	"UIControl"
LFQD_l_.str.367:
.asciz	"UIViewController"
LFQD_l_.str.368:
.asciz	"nextResponder"
LFQD_l_.str.369:
.asciz	"pageId"
LFQD_l_.str.370:
.asciz	"controlId"
LFQD_l_.str.371:
.asciz	"enabled"
LFQD_l_.str.372:
.asciz	"isEnabled"
LFQD_l_.str.373:
.asciz	"uiActionBegin"
LFQD_l_.str.374:
.asciz	"handled"
LFQD_l_.str.375:
.asciz	"uiActionReturned"
LFQD_l_.str.376:
.asciz	"performSelector:withObject:afterDelay:"
LFQD_l_.str.377:
.asciz	"watchdogCapacityReached"
LFQD_l_.str.378:
.asciz	"uiActionObservationSkipped"
LFQD_l_.str.379:
.asciz	"targetPageId"
LFQD_l_.str.380:
.asciz	"navigationPushBegin"
LFQD_l_.str.381:
.asciz	"navigationPushReturned"
LFQD_l_.str.382:
.asciz	"poppedPageId"
LFQD_l_.str.383:
.asciz	"navigationPopReturned"
LFQD_l_.str.384:
.asciz	"exceptionPresent"
LFQD_l_.str.385:
.asciz	"ObjectiveCExceptionRaise"
LFQD_l_.str.386:
.asciz	"exceptionRaise"
LFQD_l_.str.387:
.asciz	"pageDidLoad"
LFQD_l_.str.388:
.asciz	"pageDidAppear"
LFQD_l_.str.389:
.asciz	"pageDidDisappear"
LFQD_l_.str.390:
.asciz	"systemUptime"
LFQD_l_.str.391:
.asciz	"doubleValue"
