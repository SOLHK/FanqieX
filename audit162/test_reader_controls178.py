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


class Runtime(PageRuntime):
    def __init__(self, data):
        super().__init__(data)
        self._class("ObservedReaderShareInsert", "NSObject")
        self._class("ObservedReaderShareView", "UIView")
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
    require(release_version(data) in ("1.78", "1.78R2"), "These changed visual contracts apply only to 1.78")
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
        glyph_frame = runtime.objects[glyph].state["frame"]
        call(cpu, labels, "LFQH_FQHReader", nav)
        glass = call(cpu, labels, "LFQH_FQHIconGlass", share)["result"]
        require(glass and runtime.objects[glass].state["frame"] == (-6., -6., 36., 36.),
                "Only the existing share control receives a 36pt native glass background")
        require(runtime.objects[glyph].state["frame"] == (2., 2., 20., 20.),
                "Share artwork fits a 20pt optical box: "+route+" "+repr(runtime.objects[glyph].state["frame"]))
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
        require(runtime.objects[glyph].state["frame"] == (2., 2., 20., 20.), "Repeated layout never shrinks the glyph again")
        require(len([event for event, _ in runtime.records if event == "readerShareResolution178"]) <= count+1,
                "Share diagnostics settle without per-frame logging")
        runtime.objects[runtime.DEFAULTS].state["values"]["FanqieAdBlock.GlassDisabled.1"] = 1
        call(cpu, labels, "LFQH_FQHReader", nav)
        require(not call(cpu, labels, "LFQH_FQHIconGlass", share)["result"] and runtime.objects[glyph].state["frame"] == glyph_frame,
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
        pigment = runtime.color("reader dark pigment" if dark else "reader light pigment")
        runtime.objects[caption].state["textColor"] = pigment
        call(cpu, labels, "LFQH_ReaderBottomGlass", item, 0)
        surface = call(cpu, labels, "LFQH_FQHSurface", item)["result"]
        require(surface and runtime.objects[glyph].state["frame"] == (2., 2., 20., 20.), "Reader toolbar keeps compact 20pt artwork")
        fitted = runtime.objects[runtime.objects[caption].state["font"]].state
        require(fitted["pointSize"] == 11 and fitted["weight"] == "medium", "Toolbar captions retain font weight at 11pt")
        require(runtime.string_value(runtime.objects[caption].state["text"]) == "目录" and
                runtime.objects[caption].state["textColor"] == pigment, "Native text and theme pigment are preserved")
        require(hit_contains(runtime, item, (-10., -2., 44., 44.)), "Visual refinement retains the larger native touch area")
        runtime.objects[runtime.DEFAULTS].state["values"]["FanqieAdBlock.GlassDisabled.1"] = 1
        call(cpu, labels, "LFQH_ReaderBottomGlass", item, 0)
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
    call(cpu, labels, "LFQH_ProfileEntryGlass", cell, 0)
    require(call(cpu, labels, "LFQH_FQHSurface", content)["result"], "Known profile shortcut receives glass")
    require(runtime.objects[glyph].state["frame"][2:] == (20., 20.), "Profile large-row artwork is capped at 20pt")
    require(runtime.string_value(runtime.objects[caption].state["text"]) == "浏览历史" and
            not runtime.objects[caption].state.get("hidden", False), "Profile caption remains present and visible")
    require(runtime.objects[runtime.objects[caption].state["font"]].state["pointSize"] == 13., "Profile text has a 13pt cap")
    require(runtime.objects[cell].state["frame"] == (78, 0, 70, 60) and runtime.objects[cell].state["userInteractionEnabled"],
            "Native cell remains the unchanged touch target")
    runtime.objects[runtime.DEFAULTS].state["values"]["FanqieAdBlock.GlassDisabled.1"] = 1
    call(cpu, labels, "LFQH_ProfileEntryGlass", cell, 0)
    require(runtime.objects[caption].state["font"] == original_font and
            runtime.objects[caption].state["frame"] == (0, 35, 70, 18) and
            runtime.objects[glyph].state["frame"] == (25, 8, 20, 20), "Profile disable restores native font and geometry")
    runtime.objects[runtime.DEFAULTS].state["values"]["FanqieAdBlock.GlassDisabled.1"] = 0
    call(cpu, labels, "LFQH_ProfileEntryGlass", cell, 0)
    newer_font = font(runtime, caption, 15, "semibold")
    runtime.reparent(cell, runtime.ROOT)
    call(cpu, labels, "LFQH_ProfileEntryGlass", cell, 0)
    require(runtime.objects[caption].state["font"] == newer_font and
            not call(cpu, labels, "LFQH_FQHSurface", content)["result"], "Recycled non-shortcut cells keep newer host fonts and remove glass")
    cases.append("profile caption, 20pt artwork, 13pt text, touch identity, disable and reuse")
    return {"passed": True, "device_tested": False, "cases": cases,
            "limits": ["Actual candidate ARM64 code with explicit UIKit/Foundation boundaries.",
                       "No device share sheet, GPU rendering or optical screenshot comparison was performed."]}


def main():
    parser = argparse.ArgumentParser()
    parser.add_argument("candidate", type=Path)
    parser.add_argument("--report", type=Path, required=True)
    args = parser.parse_args()
    data = args.candidate.read_bytes()
    labels = labels_for(data, args.candidate.with_suffix(".composed.s"), list(dict.fromkeys(LABELS+EXTRA)))
    result = main_checks(data, labels)
    args.report.write_text(json.dumps(result, ensure_ascii=False, indent=2)+"\n")
    print(json.dumps(result, ensure_ascii=False, indent=2))


if __name__ == "__main__":
    main()
