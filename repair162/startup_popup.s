// Legacy dispatch interprets true as skip-and-mark-read. Cyber IMC interprets
// the same flag as permission to show the ad, so close that route first.
LStartupPopupInstall:
    stp x29, x30, [sp, #-48]!
    mov x29, sp
    str x0, [sp, #16]
    str x19, [sp, #32]
    adr x0, LStartupLoadEntry
    bl LFQD_FQDLoadStage
    bl LFQD_FQDInstall
    ldr x0, [sp, #16]
    .if FQ_VERSION >= 0x10704
    tbnz w0, #6, LStartupPopupBookstore  // bookstore ads and floating overlays
    tbz w0, #0, LStartupPopupLegacy     // launch ads
LStartupPopupBookstore:
    bl LFQH_FQHBookstoreAdInstall
    cbz w0, LStartupPopupLegacy
    .else
    tbz w0, #0, LStartupPopupLegacy
    .endif
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
    adr x0, LStartupLoadPopup
    bl LFQD_FQDLoadStage
LStartupPopupInstalled:
LStartupPopupLegacy:
    ldr x0, [sp, #16]
    bl LStartupPopupLegacyBody
    .if FQ_VERSION >= 0x10605
    bl LFQH_FQHInstall
    .endif
    .if FQ_VERSION >= 0x10704
    bl LFQH_FQHPageInstall
    .endif
    adr x0, LStartupLoadLegacy
    bl LFQD_FQDLoadStage
    ldr x19, [sp, #32]
    ldp x29, x30, [sp], #48
    ret
LStartupPopupLegacyBody:
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
LStartupLoadEntry:      .asciz "entry"
LStartupLoadPopup:      .asciz "startupPopupInstalled"
LStartupLoadLegacy:     .asciz "legacyHooksInstalled"
