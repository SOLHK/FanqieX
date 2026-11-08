// Host 7.4.3 uses this flag in the homepage_not_standard_ad dispatch.
// A true result follows the native skip-and-mark-read path. Other startup
// popups use separate paths. Installation uses the existing launch-ad option.
LStartupPopupInstall:
    stp x29, x30, [sp, #-32]!
    mov x29, sp
    str x0, [sp, #16]
    bl LFQD_FQDInstall
    ldr x0, [sp, #16]
    ldp x29, x30, [sp], #32
    tbz w0, #0, LStartupPopupLegacy
    stp x29, x30, [sp, #-48]!
    mov x29, sp
    stp x19, x20, [sp, #16]
    str w0, [sp, #32]
    adr x0, LStartupPopupClass
    bl Lpatch + (0xa5b0 - PATCH_BASE)     // objc_getClass
    cbz x0, LStartupPopupInstalled
    mov x19, x0
    adr x0, LStartupPopupSelector
    bl Lpatch + (0xa5a4 - PATCH_BASE)     // sel_registerName
    mov x1, x0
    mov x0, x19
    mov w2, #1
    adr x3, LStartupPopupEncoding
    bl LHookOwned
    cbz x0, LStartupPopupInstalled
    adr x1, LStartupPopupSuppress
    bl Lpatch + (0xa580 - PATCH_BASE)     // method_setImplementation
LStartupPopupInstalled:
    ldr w0, [sp, #32]
    ldp x19, x20, [sp, #16]
    ldp x29, x30, [sp], #48
LStartupPopupLegacy:
    stp x26, x25, [sp, #-80]!             // replay the original entry word
    b Lpatch + (0x4654 - PATCH_BASE)

.macro POPUP_FIELD key, value
    adr x0, \value
    bl Lstr
    mov x2, x0
    mov x0, x19
    adr x1, \key
    bl Ldict_set
.endmacro

LStartupPopupSuppress:
    // The caller handles skip bookkeeping. Report the decision only.
    stp x29, x30, [sp, #-32]!
    mov x29, sp
    stp x19, x20, [sp, #16]
    bl Lnewdict
    mov x19, x0
    cbz x19, LStartupPopupDone
    POPUP_FIELD LStartupRuleIdKey, LStartupPopupRuleId
    POPUP_FIELD LStartupRuleTypeKey, LStartupPopupRuleType
    POPUP_FIELD LStartupClassKey, LStartupPopupClass
    POPUP_FIELD LStartupSelectorKey, LStartupPopupSelector
    POPUP_FIELD LStartupResultKey, LStartupPopupBlocked
    POPUP_FIELD LStartupDisplayKey, LStartupDisplayUnknown
    adr x0, LStartupPopupEvent
    mov x1, x19
    bl Lrecord_named
LStartupPopupDone:
    mov w0, #1
    ldp x19, x20, [sp, #16]
    ldp x29, x30, [sp], #32
    ret

// @COMPONENT_DATA
LStartupPopupClass:    .asciz "SSCommonABTestHelper"
LStartupPopupSelector: .asciz "insert_screen_ad_pop_cfg"
LStartupPopupEncoding: .asciz "B16@0:8"
LStartupPopupEvent:    .asciz "adRuleDecision"
LStartupRuleIdKey:     .asciz "ruleId"
LStartupPopupRuleId:   .asciz "homepage_nonstandard_popup"
LStartupRuleTypeKey:   .asciz "ruleType"
LStartupPopupRuleType: .asciz "exactHostSelector"
LStartupClassKey:      .asciz "class"
LStartupSelectorKey:   .asciz "selector"
LStartupResultKey:     .asciz "result"
LStartupPopupBlocked:  .asciz "blocked"
LStartupDisplayKey:    .asciz "pageDisplay"
LStartupDisplayUnknown: .asciz "unobserved"
