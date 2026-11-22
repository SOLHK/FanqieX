#!/usr/bin/env python3
"""Execute 1.78 reader/profile appearance code from the candidate ARM64 dylib.

UIKit drawing and device gestures remain external boundaries. These checks run
the production control discovery, layout, lifecycle and ownership restoration;
they do not assert that a screenshot or a real host share action was exercised.
"""
import argparse
import copy
import json
from pathlib import Path

from arm64 import require, release_version
from test_alignment167 import icon as stock_icon, hit_contains
from test_control_glass166 import send
from test_controls171 import call
from test_feed_viewport import labels_for
from test_home_glass165 import LABELS
from test_page_glass174 import Runtime as PageRuntime, make

EXTRA = ["LFQH_FQHReader", "LFQH_FQHReaderCount", "LFQH_FQHIconGlass",
         "LFQH_FQHSurface", "LFQH_ReaderBottomGlass", "LFQH_ProfileEntryGlass"]
TOOLBAR_LAYOUT = "LFQH_ReaderToolbarGlass"


class Runtime(PageRuntime):
    def __init__(self, data):
        super().__init__(data)
        self._class("ObservedReaderShareInsert", "NSObject")
        self._class("ObservedReaderShareView", "UIView")
        self._class("NSAttributedString", "NSObject")
        self.original_target = self.obj("NSObject", "original reader action target")

    def responds(self, receiver, name):
        if receiver in self.objects:
            if self.is_kind(receiver, self.classes["UIFont"]) and name in ("pointSize", "fontWithSize:"):
                return "pointSize" in self.objects[receiver].state
            if self.is_kind(receiver, self.classes["UILabel"]) and name in ("setFont:", "attributedText"):
                return True
            if self.is_kind(receiver, self.classes["UIControl"]) and name in ("allTargets", "actionsForTarget:forControlEvent:"):
                return True
        return super().responds(receiver, name)

    def handle(self, cpu, pc):
        if pc-self.slide == 0xa5d4:
            receiver, selector = cpu.x[:2]
            name = self.selector_names.get(selector)
            if receiver in self.classes.values():
                if name == "respondsToSelector:" and self.selector_names[cpu.x[2]] == "description":
                    return self.finish(cpu, 1)
                if name == "description":
                    return self.finish(cpu, self.text_object(self.class_names[receiver]))
            if receiver in self.objects:
                state = self.objects[receiver].state
                if name in ("accessibilityLabel", "accessibilityIdentifier", "attributedText"):
                    return self.finish(cpu, state.get(name, 0))
                if self.is_kind(receiver, self.classes["NSAttributedString"]):
                    if name == "length":
                        return self.finish(cpu, state["length"])
                    if name == "attributesAtIndex:effectiveRange:":
                        cpu.write(cpu.x[3], 8, 0)
                        cpu.write(cpu.x[3]+8, 8, state["firstRunLength"])
                        return self.finish(cpu, state["attributes"])
                if self.is_kind(receiver, self.classes["NSString"]):
                    value = self.string_value(receiver)
                    if name == "lowercaseString":
                        return self.finish(cpu, self.text_object(value.lower()))
                    if name == "containsString:":
                        return self.finish(cpu, int(self.string_value(cpu.x[2]) in value))
                if name == "allTargets":
                    targets = list(dict.fromkeys(t[0] for t in state.get("control_targets", [])))
                    values = self.obj("NSArray", "registered targets", items=targets)
                    return self.finish(cpu, self.obj("NSObject", "target set", allObjects=values))
                if name == "allObjects" and "allObjects" in state:
                    return self.finish(cpu, state["allObjects"])
                if name == "actionsForTarget:forControlEvent:":
                    values = [self.text_object(self.selector_names[action])
                              for target, action, events in state.get("control_targets", [])
                              if target == cpu.x[2] and events & cpu.x[3]]
                    return self.finish(cpu, self.obj("NSArray", "registered actions", items=values))
        return super().handle(cpu, pc)


def build_fixture(data, labels):
    cpu, runtime = make(data, Runtime)
    runtime.labels = labels
    return cpu, runtime


def font(runtime, label, size, weight="regular"):
    value = runtime.obj("UIFont", "native control font", pointSize=float(size), weight=weight)
    runtime.objects[label].state["font"] = value
    return value


def icon(runtime, *args, **kwargs):
    control = stock_icon(runtime, *args, **kwargs)
    runtime.objects[control].state["control_targets"] = [
        (runtime.original_target, action, events)
        for _, action, events in runtime.objects[control].state["control_targets"]]
    return control


def main_checks(data, labels):
    cases = []
    compact_reader = release_version(data) in ("1.78R7", "1.78R8", "1.78R9", "1.78R10", "1.78R11", "1.78R12", "1.78R13", "1.78R14", "1.78R15", "1.78R16", "1.78R25", "1.78R26", "1.78R27", "1.78R28", "1.78R29", "1.78R30", "1.78R31", "1.78R32", "1.78R33", "1.78R34", "1.78R35", "1.78R36", "1.79R1", "1.79R2", "1.79R3", "1.79R4", "1.79R5", "1.8R1", "1.8R2", "1.8R3", "1.8R4", "1.8R5", "1.8R6", "1.8R7", "1.8R8", "1.8R9", "1.8R10", "1.8R11", "1.8R12", "1.8R13", "1.8R14", "1.8R15", "1.8R16", "1.8R17", "1.8R18", "1.8R19", "1.8R19", "1.9.1beta1", "1.9.1beta2", "1.9.1beta3", "1.9.1beta4", "1.9.1beta5", "1.9.1beta6", "1.9.1beta7", "1.9.1beta8", "1.9.1beta9", "1.9.1beta10", "1.9.1beta11", "1.9.1beta12", "1.9.1beta13", "1.9.1beta14", "1.9.1beta15", "1.9.1beta16", "1.9.1beta17", "1.9.1beta18", "1.9.1beta19", "1.9.1beta20", "1.9.1beta21", "1.9.1beta22")
    nav_glass_frame = (-5., -5., 34., 34.) if compact_reader else (-6., -6., 36., 36.)
    glyph_frame = (3., 3., 18., 18.) if compact_reader else (2., 2., 20., 20.)
    require(release_version(data) in ("1.78", "1.78R2", "1.78R3", "1.78R4", "1.78R5", "1.78R6", "1.78R7", "1.78R8", "1.78R9", "1.78R10", "1.78R11", "1.78R12", "1.78R13", "1.78R14", "1.78R15", "1.78R16", "1.78R25", "1.78R26", "1.78R27", "1.78R28", "1.78R29", "1.78R30", "1.78R31", "1.78R32", "1.78R33", "1.78R34", "1.78R35", "1.78R36", "1.79R1", "1.79R2", "1.79R3", "1.79R4", "1.79R5", "1.8R1", "1.8R2", "1.8R3", "1.8R4", "1.8R5", "1.8R6", "1.8R7", "1.8R8", "1.8R9", "1.8R10", "1.8R11", "1.8R12", "1.8R13", "1.8R14", "1.8R15", "1.8R16", "1.8R17", "1.8R18", "1.8R19", "1.8R19", "1.9.1beta1", "1.9.1beta2", "1.9.1beta3", "1.9.1beta4", "1.9.1beta5", "1.9.1beta6", "1.9.1beta7", "1.9.1beta8", "1.9.1beta9", "1.9.1beta10", "1.9.1beta11", "1.9.1beta12", "1.9.1beta13", "1.9.1beta14", "1.9.1beta15", "1.9.1beta16", "1.9.1beta17", "1.9.1beta18", "1.9.1beta19", "1.9.1beta20", "1.9.1beta21", "1.9.1beta22"), "These changed visual contracts apply only to 1.78")
    for route in ("insert_accessibility", "direct_action", "nested_identifier", "runtime_insert_class", "runtime_view_class"):
        cpu, runtime = build_fixture(data, labels)
        nav = runtime.view("FQReaderSaasNavigationView", "reader navigation", (0, 62, 402, 44), runtime.ROOT)
        back = icon(runtime, nav, "reader_back", (16, 10, 24, 24))
        holder = runtime.view("UIView", "native share wrapper", (302, 10, 24, 24), nav) if route == "nested_identifier" else nav
        share_frame = (0, 0, 24, 24) if holder != nav else (302, 10, 24, 24)
        if route.startswith("runtime_"):
            share = runtime.view("ObservedReaderShareView" if route == "runtime_view_class" else "UIView",
                                 "native gesture share", share_frame, holder,
                                 userInteractionEnabled=True, gestureRecognizers=["host share recognizer"],
                                 control_targets=[], images={})
            glyph = runtime.view("UIImageView", "native share artwork", (0, 0, 24, 24), share)
            runtime.objects[share].state["imageView"] = glyph
        else:
            share = icon(runtime, holder, "reader_share", share_frame)
        share_state = runtime.objects[share].state
        original_targets = copy.deepcopy(share_state["control_targets"])
        if route == "direct_action":
            share_state["control_targets"] = [(runtime.original_target, runtime.sel("onShareBookTapped:"), 64)]
            original_targets = copy.deepcopy(share_state["control_targets"])
        elif route == "nested_identifier":
            share_state["accessibilityIdentifier"] = runtime.text_object("reader.share.button")
        elif route == "insert_accessibility":
            share_state["accessibilityLabel"] = runtime.text_object("分享")
        insert_class = "ObservedReaderShareInsert" if route == "runtime_insert_class" else "NSObject"
        items = [runtime.obj(insert_class, "unknown native insert", getInsertView=share)] if route in ("insert_accessibility", "runtime_insert_class") else []
        runtime.objects[nav].state.update(backBtn=back, insertObjs=runtime.obj("NSArray", "native inserts", items=items))
        original_frame, original_image = share_state["frame"], share_state["images"]
        glyph = share_state["imageView"]
        stock_glyph_frame = runtime.objects[glyph].state["frame"]
        call(cpu, labels, "LFQH_FQHReader", nav)
        glass = call(cpu, labels, "LFQH_FQHIconGlass", share)["result"]
        require(glass and runtime.objects[glass].state["frame"] == nav_glass_frame,
                "Only the existing share control receives native glass")
        require(runtime.objects[glyph].state["frame"] == glyph_frame,
                "Share artwork fits its optical box: "+route+" "+repr(runtime.objects[glyph].state["frame"]))
        require(share_state["frame"] == original_frame and share_state["images"] == original_image,
                "Share host frame, image states and native control identity remain intact")
        require(all(target in share_state["control_targets"] for target in original_targets), "Original share targets survive")
        require(hit_contains(runtime, share, (-10., -10., 44., 44.)), "Share retains at least a 44pt hit area")
        if holder != nav:
            require(hit_contains(runtime, holder, (-10., -10., 44., 44.)), "A small native wrapper does not clip the expanded share hit area")
        require(not runtime.objects[glass].state["userInteractionEnabled"], "Share background cannot steal touches")
        if route.startswith("runtime_"):
            require(share_state["gestureRecognizers"] == ["host share recognizer"], "Runtime share discovery retains the original gesture recognizer")
        resolved = [record for event, record in runtime.records if event == "readerShareResolution178"][-1]
        expected_strategy = {"insert_accessibility": "accessibility-label", "direct_action": "registered-control-action",
                             "nested_identifier": "accessibility-identifier", "runtime_insert_class": "runtime-insert-class",
                             "runtime_view_class": "runtime-view-class"}[route]
        require(resolved["strategy"] == expected_strategy, "Diagnostics identify the observed matching strategy")
        count = len([event for event, _ in runtime.records if event == "readerShareResolution178"])
        for _ in range(6):
            call(cpu, labels, "LFQH_FQHReader", nav)
        require(call(cpu, labels, "LFQH_FQHIconGlass", share)["result"] == glass, "Repeated layout reuses one share glass")
        require(runtime.objects[glyph].state["frame"] == glyph_frame, "Repeated layout never shrinks the glyph again")
        require(len([event for event, _ in runtime.records if event == "readerShareResolution178"]) <= count+1,
                "Share diagnostics settle without per-frame logging")
        runtime.objects[runtime.DEFAULTS].state["values"]["FanqieAdBlock.GlassDisabled.1"] = 1
        call(cpu, labels, "LFQH_FQHReader", nav)
        require(not call(cpu, labels, "LFQH_FQHIconGlass", share)["result"] and runtime.objects[glyph].state["frame"] == stock_glyph_frame,
                "Disabling glass removes the material and restores the original share glyph")
        require(share_state["control_targets"] == original_targets, "Disabling glass removes only plugin highlight observers")
        if holder != nav:
            require(runtime.objects[holder].state["hitInsets"] == (0., 0., 0., 0.), "Share wrapper touch insets restore on disable")
        cases.append(route+": material, action ownership, optical size, hit target, repeat and disable")

    cpu, runtime = build_fixture(data, labels)
    nav = runtime.view("FQReaderSaasNavigationView", "reader navigation", (0, 62, 402, 44), runtime.ROOT)
    unknown = icon(runtime, nav, "unidentified icon", (302, 10, 24, 24))
    outside = icon(runtime, runtime.ROOT, "outside share", (300, 500, 24, 24))
    runtime.objects[outside].state["accessibilityLabel"] = runtime.text_object("分享")
    call(cpu, labels, "LFQH_FQHReader", nav)
    require(not call(cpu, labels, "LFQH_FQHIconGlass", unknown)["result"] and
            not call(cpu, labels, "LFQH_FQHIconGlass", outside)["result"], "Unknown and out-of-nav controls are untouched")
    records = [record for event, record in runtime.records if event == "readerShareResolution178"]
    require(records and not records[-1]["matched"], "Unresolved share is diagnosed instead of inventing a selector")
    require(set(records[-1]) == {"matched", "styled", "inspectedViews", "scope", "strategy"},
            "Diagnostics contain no book text, target descriptions or accessibility contents")
    hidden_holder = runtime.view("UIView", "hidden native row", (200, 0, 40, 44), nav, hidden=True)
    hidden_share = runtime.view("ObservedReaderShareView", "hidden share", (0, 8, 24, 24), hidden_holder)
    runtime.objects[nav].state["insertObjs"] = runtime.obj("NSArray", "hidden insert", items=[
        runtime.obj("ObservedReaderShareInsert", "hidden native sharing insert", getInsertView=hidden_share)])
    call(cpu, labels, "LFQH_FQHReader", nav)
    require(not call(cpu, labels, "LFQH_FQHIconGlass", hidden_share)["result"], "A hidden ancestor prevents share decoration")
    cases.append("bounded share scope and unresolved diagnostics")

    # A themed host write after decoration wins over the saved old glyph frame.
    runtime.objects[unknown].state["accessibilityLabel"] = runtime.text_object("分享")
    call(cpu, labels, "LFQH_FQHReader", nav)
    glyph = runtime.objects[unknown].state["imageView"]
    newer = (3., 4., 22., 22.)
    runtime.objects[glyph].state["frame"] = newer
    runtime.objects[runtime.DEFAULTS].state["values"]["FanqieAdBlock.GlassDisabled.1"] = 1
    call(cpu, labels, "LFQH_FQHReader", nav)
    require(runtime.objects[glyph].state["frame"] == newer, "Restore never overwrites a later host glyph layout")
    cases.append("later host glyph layout ownership")

    cpu, runtime = build_fixture(data, labels)
    nav = runtime.view("FQReaderSaasNavigationView", "reader navigation", (0, 62, 402, 44), runtime.ROOT)
    share = icon(runtime, nav, "reader_share", (302, 10, 24, 24))
    runtime.objects[share].state["accessibilityLabel"] = runtime.text_object("分享")
    runtime.nil_button_factory = True
    call(cpu, labels, "LFQH_FQHReader", nav)
    require(not call(cpu, labels, "LFQH_FQHIconGlass", share)["result"] and
            runtime.objects[runtime.objects[share].state["imageView"]].state["frame"] == (0, 0, 24, 24),
            "A nil native glass factory leaves no partially resized glyph")
    cases.append("unavailable native material leaves original artwork")

    for dark in (False, True):
        cpu, runtime = build_fixture(data, labels)
        toolbar = runtime.view("FQReaderSaaSBottomToolView", "reader tools", (0, 760, 402, 56), runtime.ROOT)
        model = runtime.obj("FQReaderSaaSBottomToolItem", "catalog model", type=1)
        item = runtime.view("FQReaderSaaSBottomToolItemView", "catalog", (55, 2, 24, 40), toolbar,
                            item=model, hitInsets=(0., -15., 0., -15.))
        glyph = runtime.view("UIImageView", "original catalog icon", (0, 0, 24, 24), item)
        caption = runtime.label("catalog caption", item, (0, 26, 24, 14), "目录")
        original_font = font(runtime, caption, 14, "medium")
        if compact_reader:
            plain = runtime.obj("NSAttributedString", "UIKit plain text representation", length=2, firstRunLength=2,
                                attributes=runtime.obj("NSDictionary", "no explicit styles", items={}))
            runtime.objects[caption].state["attributedText"] = plain
        pigment = runtime.color("reader dark pigment" if dark else "reader light pigment")
        runtime.objects[caption].state["textColor"] = pigment
        def layout():
            if TOOLBAR_LAYOUT in labels:
                call(cpu, labels, TOOLBAR_LAYOUT, toolbar)
            else:
                call(cpu, labels, "LFQH_ReaderBottomGlass", item, 0)

        layout()
        surface = call(cpu, labels, "LFQH_FQHSurface", item)["result"]
        require(surface and runtime.objects[glyph].state["frame"] == glyph_frame, "Reader toolbar keeps compact artwork")
        if TOOLBAR_LAYOUT in labels:
            require(runtime.objects[surface].state["frame"] == (-26., -2., 76., 44.), "Reader toolbar lays out the catalog glass")
        elif compact_reader:
            require(runtime.objects[surface].state["frame"] == (-18., -2., 60., 44.), "Reader tool uses smaller glass")
        fitted = runtime.objects[runtime.objects[caption].state["font"]].state
        require(fitted["pointSize"] == 11 and fitted["weight"] == "medium", "Toolbar captions retain font weight at 11pt")
        require(runtime.string_value(runtime.objects[caption].state["text"]) == "目录" and
                runtime.objects[caption].state["textColor"] == pigment, "Native text and theme pigment are preserved")
        require(hit_contains(runtime, item, (-10., -2., 44., 44.)), "Visual refinement retains the larger native touch area")
        if compact_reader:
            runtime.objects[plain].state["firstRunLength"] = 1
            layout()
            require(runtime.objects[caption].state["font"] == original_font,
                    "A later styled caption run preserves the host font")
            runtime.objects[plain].state.update(firstRunLength=2,
                attributes=runtime.obj("NSDictionary", "explicit caption styles", items={"NSFont": original_font}))
            layout()
            require(runtime.objects[caption].state["font"] == original_font and runtime.objects[caption].state["attributedText"] == plain,
                    "An explicitly styled caption remains intact")
            runtime.objects[caption].state["attributedText"] = 0
            layout()
        runtime.objects[runtime.DEFAULTS].state["values"]["FanqieAdBlock.GlassDisabled.1"] = 1
        layout()
        require(runtime.objects[caption].state["font"] == original_font and
                runtime.objects[glyph].state["frame"] == (0., 0., 24., 24.) and
                runtime.objects[item].state["hitInsets"] == (0., -15., 0., -15.), "Toolbar disable restores font, glyph and original touch insets")
        cases.append(("dark" if dark else "light")+" reader toolbar text, pigment and restoration")

    cpu, runtime = build_fixture(data, labels)
    row = runtime.view("SSMyUserCollectionView1Cell", "profile shortcut row", (0, 240, 390, 64), runtime.ROOT)
    scroller = runtime.view("UIView", "shortcut container", (0, 0, 390, 64), row)
    cell = runtime.view("SSMyUserCollectionViewFunCell", "profile history", (78, 0, 70, 60), scroller,
                        userInteractionEnabled=True)
    content = runtime.view("UIView", "shortcut content", (0, 0, 70, 60), cell)
    glyph = runtime.view("UIImageView", "history artwork", (25, 8, 20, 20), content)
    caption = runtime.label("history caption", content, (0, 35, 70, 18), "浏览历史")
    original_font = font(runtime, caption, 16, "regular")
    runtime.objects[cell].state.update(contentView=content, image=glyph, label=caption)
    runtime.objects[runtime.DEFAULTS].state["values"]["FanqieX.ProfileIconsOnly.1"] = True
    call(cpu, labels, "LFQH_ProfileEntryGlass", cell, 0)
    unified_card = release_version(data) in ("1.79R1", "1.79R2", "1.79R3", "1.79R4", "1.79R5", "1.8R1", "1.8R2", "1.8R3", "1.8R4", "1.8R5", "1.8R6", "1.8R7", "1.8R8", "1.8R9", "1.8R10", "1.8R11", "1.8R12", "1.8R13", "1.8R14", "1.8R15", "1.8R16", "1.8R17", "1.8R18", "1.8R19", "1.8R19", "1.9.1beta1", "1.9.1beta2", "1.9.1beta3", "1.9.1beta4", "1.9.1beta5", "1.9.1beta6", "1.9.1beta7", "1.9.1beta8", "1.9.1beta9", "1.9.1beta10", "1.9.1beta11", "1.9.1beta12", "1.9.1beta13", "1.9.1beta14", "1.9.1beta15", "1.9.1beta16", "1.9.1beta17", "1.9.1beta18", "1.9.1beta19", "1.9.1beta20", "1.9.1beta21", "1.9.1beta22")
    layered_buttons = release_version(data) in ("1.79R3", "1.79R4", "1.79R5", "1.8R1", "1.8R2", "1.8R3", "1.8R4", "1.8R5", "1.8R6", "1.8R7", "1.8R8", "1.8R9", "1.8R10", "1.8R11", "1.8R12", "1.8R13", "1.8R14", "1.8R15", "1.8R16", "1.8R17", "1.8R18", "1.8R19", "1.8R19", "1.9.1beta1", "1.9.1beta2", "1.9.1beta3", "1.9.1beta4", "1.9.1beta5", "1.9.1beta6", "1.9.1beta7", "1.9.1beta8", "1.9.1beta9", "1.9.1beta10", "1.9.1beta11", "1.9.1beta12", "1.9.1beta13", "1.9.1beta14", "1.9.1beta15", "1.9.1beta16", "1.9.1beta17", "1.9.1beta18", "1.9.1beta19", "1.9.1beta20", "1.9.1beta21", "1.9.1beta22")
    surface = call(cpu, labels, "LFQH_FQHSurface", row if unified_card else content)["result"]
    require(surface, "Known profile shortcut receives glass")
    if layered_buttons:
        item_surface = call(cpu, labels, "LFQH_FQHSurface", content)["result"]
        expected_item = {
            "1.8R1": (10., 5., 50., 50.),
            "1.8R2": (10., 5., 50., 50.),
            "1.8R3": (10., 5., 50., 50.),
            "1.8R4": (10., 5., 50., 50.),
            "1.8R5": (10., 5., 50., 50.),
            "1.8R6": (10., 5., 50., 50.),
        "1.8R7": (10., 5., 50., 50.),
        "1.8R8": (10., 5., 50., 50.),
        "1.8R9": (10., 5., 50., 50.),
        "1.8R10": (10., 5., 50., 50.),
        "1.8R11": (10., 5., 50., 50.),
        "1.8R12": (10., 5., 50., 50.),
        "1.8R13": (10., 5., 50., 50.),
        "1.8R14": (10., 5., 50., 50.),
        "1.8R15": (10., 5., 50., 50.),
        "1.8R16": (10., 5., 50., 50.),
        "1.8R17": (10., 5., 50., 50.),
        "1.8R18": (10., 5., 50., 50.),
        "1.8R19": (10., 5., 50., 50.),
        "1.9.1beta1": (10., 5., 50., 50.),
        "1.9.1beta2": (10., 5., 50., 50.),
        "1.9.1beta3": (10., 5., 50., 50.),
        "1.9.1beta4": (10., 5., 50., 50.),
        "1.9.1beta5": (10., 5., 50., 50.),
        "1.9.1beta6": (10., 5., 50., 50.),
        "1.9.1beta7": (10., 5., 50., 50.),
        "1.9.1beta8": (10., 5., 50., 50.),
        "1.9.1beta9": (10., 5., 50., 50.),
        "1.9.1beta10": (10., 5., 50., 50.),
        "1.9.1beta11": (10., 5., 50., 50.),
        "1.9.1beta12": (10., 5., 50., 50.),
        "1.9.1beta13": (10., 5., 50., 50.),
        "1.9.1beta14": (10., 5., 50., 50.),
        "1.9.1beta15": (10., 5., 50., 50.),
        "1.9.1beta16": (10., 5., 50., 50.),
        "1.9.1beta17": (10., 5., 50., 50.),
        "1.9.1beta18": (10., 5., 50., 50.),
        "1.9.1beta19": (10., 5., 50., 50.),
        "1.9.1beta20": (10., 5., 50., 50.),
        "1.9.1beta21": (10., 5., 50., 50.),
        "1.9.1beta22": (10., 5., 50., 50.),
            "1.79R5": (2., 1., 66., 58.),
        }.get(release_version(data), (4., 2., 62., 56.))
        require(item_surface and runtime.objects[item_surface].state["frame"] == expected_item,
                "1.79R3+ shortcut retains coordinated per-item liquid glass button inside outer card")
    elif unified_card:
        require(not call(cpu, labels, "LFQH_FQHSurface", content)["result"],
                "Unified profile card removes per-item glass")
    glyph_size = 21. if release_version(data) in ("1.8R1", "1.8R2", "1.8R3", "1.8R4", "1.8R5", "1.8R6", "1.8R7", "1.8R8", "1.8R9", "1.8R10", "1.8R11", "1.8R12", "1.8R13", "1.8R14", "1.8R15", "1.8R16", "1.8R17", "1.8R18", "1.8R19", "1.8R19", "1.9.1beta1", "1.9.1beta2", "1.9.1beta3", "1.9.1beta4", "1.9.1beta5", "1.9.1beta6", "1.9.1beta7", "1.9.1beta8", "1.9.1beta9", "1.9.1beta10", "1.9.1beta11", "1.9.1beta12", "1.9.1beta13", "1.9.1beta14", "1.9.1beta15", "1.9.1beta16", "1.9.1beta17", "1.9.1beta18", "1.9.1beta19", "1.9.1beta20", "1.9.1beta21", "1.9.1beta22") else 25. if release_version(data) == "1.79R5" else 24. if layered_buttons else 20. if release_version(data) in ("1.78R9","1.78R10", "1.78R11", "1.78R12", "1.78R13", "1.78R14", "1.78R15", "1.78R16", "1.78R25", "1.78R26", "1.78R27", "1.78R28", "1.78R29", "1.78R30", "1.78R31", "1.78R32", "1.78R33", "1.78R34", "1.78R35", "1.78R36", "1.79R1", "1.79R2") else 18. if compact_reader else 20.
    if release_version(data) in ("1.78R10", "1.78R11", "1.78R12", "1.78R13", "1.78R14", "1.78R15", "1.78R16", "1.78R25", "1.78R26", "1.78R27", "1.78R28", "1.78R29", "1.78R30", "1.78R31", "1.78R32", "1.78R33", "1.78R34", "1.78R35", "1.78R36", "1.79R1", "1.79R2", "1.79R3", "1.79R4", "1.79R5", "1.8R1", "1.8R2", "1.8R3", "1.8R4", "1.8R5", "1.8R6", "1.8R7", "1.8R8", "1.8R9", "1.8R10", "1.8R11", "1.8R12", "1.8R13", "1.8R14", "1.8R15", "1.8R16", "1.8R17", "1.8R18", "1.8R19", "1.8R19", "1.9.1beta1", "1.9.1beta2", "1.9.1beta3", "1.9.1beta4", "1.9.1beta5", "1.9.1beta6", "1.9.1beta7", "1.9.1beta8", "1.9.1beta9", "1.9.1beta10", "1.9.1beta11", "1.9.1beta12", "1.9.1beta13", "1.9.1beta14", "1.9.1beta15", "1.9.1beta16", "1.9.1beta17", "1.9.1beta18", "1.9.1beta19", "1.9.1beta20", "1.9.1beta21", "1.9.1beta22"):
        expected_surface = (0., 0., 390., 64.) if unified_card else (-1., 0., 72., 60.)
        expected_caption = (12., 33., 46., 18.) if release_version(data) in ("1.8R1", "1.8R2", "1.8R3", "1.8R4", "1.8R5", "1.8R6", "1.8R7", "1.8R8", "1.8R9", "1.8R10", "1.8R11", "1.8R12", "1.8R13", "1.8R14", "1.8R15", "1.8R16", "1.8R17", "1.8R18", "1.8R19", "1.8R19", "1.9.1beta1", "1.9.1beta2", "1.9.1beta3", "1.9.1beta4", "1.9.1beta5", "1.9.1beta6", "1.9.1beta7", "1.9.1beta8", "1.9.1beta9", "1.9.1beta10", "1.9.1beta11", "1.9.1beta12", "1.9.1beta13", "1.9.1beta14", "1.9.1beta15", "1.9.1beta16", "1.9.1beta17", "1.9.1beta18", "1.9.1beta19", "1.9.1beta20", "1.9.1beta21", "1.9.1beta22") else (6., 35., 58., 18.) if release_version(data) == "1.79R5" else (6., 34.5, 58., 18.) if layered_buttons else (7., 32., 56., 20.)
        require(runtime.objects[surface].state["frame"] == expected_surface,
                "Profile glass expands with padded captions and covers the configured container")
        require(runtime.objects[caption].state["frame"] == expected_caption and
                runtime.objects[caption].state["textAlignment"] == 1,
                "Profile caption is centered with balanced horizontal padding")
    elif compact_reader:
        profile_height = 52. if release_version(data) == "1.78R9" else 58.
        require(runtime.objects[surface].state["frame"] == (3., 0., 64., profile_height), "Profile glass leaves room between shortcuts")
    require(runtime.objects[glyph].state["frame"][2:] == (glyph_size, glyph_size), "Profile large-row artwork is capped")
    require(runtime.string_value(runtime.objects[caption].state["text"]) == "浏览历史" and
            not runtime.objects[caption].state.get("hidden", False), "A saved 1.77r3 icon-only setting leaves the native caption visible")
    require(runtime.objects[runtime.objects[caption].state["font"]].state["pointSize"] == (13. if release_version(data) in ("1.78R10", "1.78R11", "1.78R12", "1.78R13", "1.78R14", "1.78R15", "1.78R16", "1.78R25", "1.78R26", "1.78R27", "1.78R28", "1.78R29", "1.78R30", "1.78R31", "1.78R32", "1.78R33", "1.78R34", "1.78R35", "1.78R36", "1.79R1", "1.79R2", "1.79R3", "1.79R4", "1.79R5", "1.8R1", "1.8R2", "1.8R3", "1.8R4", "1.8R5", "1.8R6", "1.8R7", "1.8R8", "1.8R9", "1.8R10", "1.8R11", "1.8R12", "1.8R13", "1.8R14", "1.8R15", "1.8R16", "1.8R17", "1.8R18", "1.8R19", "1.8R19", "1.9.1beta1", "1.9.1beta2", "1.9.1beta3", "1.9.1beta4", "1.9.1beta5", "1.9.1beta6", "1.9.1beta7", "1.9.1beta8", "1.9.1beta9", "1.9.1beta10", "1.9.1beta11", "1.9.1beta12", "1.9.1beta13", "1.9.1beta14", "1.9.1beta15", "1.9.1beta16", "1.9.1beta17", "1.9.1beta18", "1.9.1beta19", "1.9.1beta20", "1.9.1beta21", "1.9.1beta22") else 12. if compact_reader else 13.),
            "Profile text uses its compact font cap")
    require(runtime.objects[cell].state["frame"] == (78, 0, 70, 60) and runtime.objects[cell].state["userInteractionEnabled"],
            "Native cell remains the unchanged touch target")
    runtime.objects[runtime.DEFAULTS].state["values"]["FanqieAdBlock.GlassDisabled.1"] = 1
    call(cpu, labels, "LFQH_ProfileEntryGlass", cell, 0)
    require(runtime.objects[caption].state["font"] == original_font and
            runtime.objects[caption].state["frame"] == (0, 35, 70, 18) and
            runtime.objects[glyph].state["frame"] == (25, 8, 20, 20) and
            (not unified_card or not call(cpu, labels, "LFQH_FQHSurface", row)["result"]),
            "Profile disable restores native font and geometry")
    runtime.objects[runtime.DEFAULTS].state["values"]["FanqieAdBlock.GlassDisabled.1"] = 0
    call(cpu, labels, "LFQH_ProfileEntryGlass", cell, 0)
    newer_font = font(runtime, caption, 15, "semibold")
    runtime.reparent(cell, runtime.ROOT)
    call(cpu, labels, "LFQH_ProfileEntryGlass", cell, 0)
    require(runtime.objects[caption].state["font"] == newer_font and
            not call(cpu, labels, "LFQH_FQHSurface", content)["result"], "Recycled non-shortcut cells keep newer host fonts and remove glass")
    cases.append("profile caption with an old icon preference, compact artwork and text, touch identity, disable and reuse")
    return {"passed": True, "device_tested": False, "cases": cases,
            "limits": ["Actual candidate ARM64 code with explicit UIKit/Foundation boundaries.",
                       "No device share sheet, GPU rendering or optical screenshot comparison was performed."]}


def main():
    parser = argparse.ArgumentParser()
    parser.add_argument("candidate", type=Path)
    parser.add_argument("--report", type=Path, required=True)
    args = parser.parse_args()
    data = args.candidate.read_bytes()
    composed = args.candidate.with_suffix(".composed.s")
    toolbar_labels = [TOOLBAR_LAYOUT] if f"\n{TOOLBAR_LAYOUT}:" in composed.read_text(encoding="utf-8") else []
    labels = labels_for(data, composed, list(dict.fromkeys(LABELS + EXTRA + toolbar_labels)))
    result = main_checks(data, labels)
    args.report.write_text(json.dumps(result, ensure_ascii=False, indent=2)+"\n")
    print(json.dumps(result, ensure_ascii=False, indent=2))


if __name__ == "__main__":
    main()
