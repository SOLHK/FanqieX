#!/usr/bin/env python3
"""Execute header selection and the palette fallback without a native root owner.

The host setters and UIColor decomposition are boundaries. Candidate ARM64
installs the exact hooks, reads native isSelected flags and builds the lens frame.
This fixture lacks rootTabBarController, so R35 must retain the already-set
content background fallback. No pixels are rendered.
"""
import argparse
import hashlib
import json
import struct
from pathlib import Path

from arm64 import release_version, require
from test_control_glass166 import send
from test_controls171 import call
from test_feed_viewport import labels_for
from test_page_glass174 import EXTRA, make
from test_drama_visibility178r7 import Runtime as VisibilityRuntime, HEADER, CONTROLLER, MODEL, CATEGORY_VIEW

CELL = "FQRJXCategoryTitleCellModel"
SELECT = "refreshSelectedCellModel:unselectedCellModel:"
BACKGROUND = "updateContentBackgroundColorWithTabModel:"


class Runtime(VisibilityRuntime):
    SELECT_NATIVE = 0x33320000
    BACKGROUND_NATIVE = 0x33320008
    OLD_PALETTE = 0x33320010

    def __init__(self, data):
        super().__init__(data)
        if CELL not in self.classes:
            self._class(CELL, "NSObject")
            self._add(self.classes[CELL], "isSelected", self.HOST_GETTER, "B16@0:8")
        self._add(self.classes[CATEGORY_VIEW], SELECT, self.SELECT_NATIVE, "v32@0:8@16@24")
        self._add(self.classes[CONTROLLER], BACKGROUND, self.BACKGROUND_NATIVE, "v24@0:8@16")
        self._add(self.classes["SSTabBarController"], "bottomTabBackgroundColorWithTabModel:", self.OLD_PALETTE, "@24@0:8@16")
        self.selection_calls = 0
        self.background_calls = 0
        self.old_palette_reads = 0
        self.next_background = 0

    def responds(self, receiver, name):
        if receiver in self.objects:
            state = self.objects[receiver].state
            if name in ("contentView", "tabBarController", "tabBar", "selectedViewController"):
                return name in state
            if name in ("resolvedColorWithTraitCollection:", "description"):
                return self.is_kind(receiver, self.classes["UIColor"])
        return super().responds(receiver, name)

    def handle(self, cpu, pc):
        receiver, selector = cpu.x[:2]
        name = self.selector_names.get(selector)
        if pc == self.SELECT_NATIVE:
            self.selection_calls += 1
            self.objects[cpu.x[2]].state["isSelected"] = True
            self.objects[cpu.x[3]].state["isSelected"] = False
            return self.finish(cpu)
        if pc == self.BACKGROUND_NATIVE:
            self.background_calls += 1
            content = self.objects[receiver].state["contentView"]
            self.objects[content].state["backgroundColor"] = self.next_background
            return self.finish(cpu)
        if pc == self.OLD_PALETTE:
            self.old_palette_reads += 1
            return self.finish(cpu, self.next_background)
        if pc - self.slide == 0xa5d4 and receiver in self.objects:
            state = self.objects[receiver].state
            if name in ("contentView", "tabBarController", "tabBar", "selectedViewController", "overrideUserInterfaceStyle"):
                return self.finish(cpu, state.get(name, 0))
            if name == "setOverrideUserInterfaceStyle:":
                state["overrideUserInterfaceStyle"] = cpu.x[2]
                return self.finish(cpu)
            if name == "resolvedColorWithTraitCollection:":
                return self.finish(cpu, receiver)
            if name == "description":
                return self.finish(cpu, self.text_object(str(state.get("rgba"))))
            if name == "getRed:green:blue:alpha:":
                for address, value in zip(cpu.x[2:6], state["rgba"]):
                    cpu.write(address, 8, struct.unpack("<Q", struct.pack("<d", value))[0])
                return self.finish(cpu, 1)
        return super().handle(cpu, pc)


def exercise(data, labels, expect_old=False, expect_button_material_baseline=False):
    cpu, rt = make(data, Runtime)
    rt.labels = labels
    call(cpu, labels, "LFQH_FQHPageInstall")
    header = rt.view(HEADER, "visible drama header", (0., 62., 440., 60.), rt.ROOT)
    categories = rt.view("UIView", "category container", (20., 0., 140., 44.), header)
    controller = rt.obj(CONTROLLER, "feed with lagging currentTabModel", headerView=header)
    models = [rt.obj(MODEL, "feed model", tabType=kind, index=i) for i, kind in enumerate((7, 11, 103))]
    titles = [rt.obj(CELL, "rendered title model", isSelected=(i == 1)) for i in range(3)]
    model_array = rt.obj("NSArray", "feed models", items=models)
    title_array = rt.obj("NSArray", "native title data source", items=titles)
    tabs = rt.view(CATEGORY_VIEW, "title strip", (0., 0., 140., 44.), categories,
                   delegate=controller, dataSource=title_array, selectedIndex=2,
                   cellFrames=[(8., 0., 36., 44.), (54., 0., 36., 44.), (100., 0., 32., 44.)])
    collection = rt.view("UICollectionView", "title collection", (0., 0., 140., 44.), tabs)
    rt.objects[tabs].state["collectionView"] = collection
    rt.objects[header].state.update(delegate=controller, tabContainer=categories)
    black, white = rt.color("actual black page"), rt.color("old white model palette")
    rt.objects[black].state["rgba"] = (0., 0., 0., 1.)
    rt.objects[white].state["rgba"] = (1., 1., 1., 1.)
    content = rt.view("UIView", "host contentView", (0., 0., 440., 956.), rt.ROOT, backgroundColor=black)
    tab_owner = rt.obj("SSTabBarController", "main tabs", selectedViewController=controller)
    bar = rt.view("UIView", "bottom tab bar", delegate=tab_owner)
    rt.objects[tab_owner].state["tabBar"] = bar
    rt.objects[controller].state.update(simpleTabView=tabs, tabModels=model_array, currentTabModel=models[0],
                                       contentView=content, tabBarController=tab_owner)
    rt.next_background = white
    send(cpu, rt, header, "layoutSubviews")
    glass = next(v for v in rt.objects[categories].state["subviews"]
                 if rt.objects[v].state.get("configuration") or rt.objects[v].state.get("effect"))
    regular = rt.is_kind(glass, rt.classes["UIVisualEffectView"])
    content_parent = rt.objects[glass].state["contentView"] if regular else glass
    lens, = rt.objects[content_parent].state["subviews"]
    initial = {"lens_frame": rt.objects[lens].state["frame"],
               "glass_style": rt.objects[glass].state.get("overrideUserInterfaceStyle", 0)}
    if expect_old:
        require(initial["lens_frame"][0] == 4. and initial["glass_style"] == 1,
                "R31 follows the stale recommended model and its white palette despite native comic selection on black")
        return {"expected_r31_mismatch_reproduced": True, **initial}
    if expect_button_material_baseline:
        require(release_version(data) == "1.78R33" and not regular and
                rt.is_kind(glass, rt.classes["UIButton"]) and rt.objects[glass].state.get("configuration"),
                "R33 reproduces the category-wide glass-button material instead of the dock's Regular effect view")
        return {"expected_r33_button_material_mismatch_reproduced": True, **initial}
    if release_version(data) in ("1.78R34", "1.78R35", "1.78R36", "1.79R1", "1.79R2", "1.79R3", "1.79R4", "1.79R5", "1.8R1", "1.8R2", "1.8R3", "1.8R4", "1.8R5", "1.8R6", "1.8R7", "1.8R8", "1.8R9", "1.8R10", "1.8R11", "1.8R12", "1.8R13", "1.8R14", "1.8R15", "1.8R16", "1.8R17", "1.8R18", "1.8R19", "1.8R19", "1.9.1beta1", "1.9.1beta2", "1.9.1beta3", "1.9.1beta4", "1.9.1beta5", "1.9.1beta6", "1.9.1beta7", "1.9.1beta8", "1.9.1beta9", "1.9.1beta10", "1.9.1beta11", "1.9.1beta12", "1.9.1beta13", "1.9.1beta14", "1.9.1beta15", "1.9.1beta16", "1.9.1beta17", "1.9.1beta18", "1.9.1beta19", "1.9.1beta20", "1.9.1beta21", "1.9.1beta22", "1.9.1beta23", "1.9.1beta24", "1.9.1beta25", "1.9.1beta26", "1.9.5beta1", "1.9.5beta2", "1.9.5beta3", "1.9.5beta4", "1.9.5beta5", "1.9.5beta6", "1.9.5beta7", "1.9.5beta8", "1.9.5beta9", "1.9.6beta1", "1.9.6beta2", "1.9.6beta3", "1.9.6beta4", "1.9.6beta5", "1.9.6beta6", "1.9.6beta7", "1.9.6beta8", "1.9.6beta9", "1.9.7beta1", "1.9.7beta2", "1.9.7beta3", "1.9.7beta4", "1.9.7beta5", "1.9.7beta6", "1.9.7beta7", "1.9.7beta8", "1.9.7beta9", "1.9.7beta10", "1.9.8beta", "1.9.8beta2", "2.0", "2.0.1beta1", "2.0.1beta2", "2.0.1beta3", "2.0.1beta4", "2.0.1beta5", "2.0.1beta6", "2.0.1beta7"):
        require(regular, "R34 and later use the same effect-view material family as the bottom dock")
    require(initial["lens_frame"] == (51., 4., 45., 34.) and initial["glass_style"] == 2,
            "The lens follows the actual comic title and dark content even when both cached indices disagree")
    require(rt.old_palette_reads == 0, "Without rootTabBarController, the header uses content background and does not call the unrelated tabBarController resolver")

    send(cpu, rt, tabs, SELECT, titles[0], titles[1])
    require(rt.selection_calls == 1 and rt.objects[lens].state["frame"] == (4., 4., 47., 34.),
            "Native title selection commits first, then the hooked lens redraws immediately")
    require(rt.objects[tabs].state["selectedIndex"] == 2 and rt.objects[controller].state["currentTabModel"] == models[0],
            "The plugin does not rewrite any host selection index or feed model")
    send(cpu, rt, tabs, SELECT, titles[1], titles[0])
    require(rt.objects[lens].state["frame"][0] == 51., "The same native refresh path covers scroll-committed selection")
    send(cpu, rt, controller, BACKGROUND, models[2])
    require(rt.background_calls == 1 and rt.objects[glass].state["overrideUserInterfaceStyle"] == 1,
            "After the host applies a white page, the header updates to light appearance")
    rt.next_background = black
    send(cpu, rt, controller, BACKGROUND, models[1])
    require(rt.objects[glass].state["overrideUserInterfaceStyle"] == 2,
            "Returning to actual black content restores dark glass")

    rt.objects[titles[1]].state["isSelected"] = False
    send(cpu, rt, header, "layoutSubviews")
    require(rt.objects[lens].state["hidden"], "No host-selected title never invents a selection from stale feed data")
    rt.objects[titles[0]].state["isSelected"] = True
    rt.objects[titles[1]].state["isSelected"] = True
    send(cpu, rt, header, "layoutSubviews")
    require(rt.objects[lens].state["hidden"], "An incomplete multiple-selection transition does not draw the wrong lens")
    rt.objects[titles[0]].state["isSelected"] = False
    send(cpu, rt, header, "layoutSubviews")
    require(not rt.objects[lens].state["hidden"] and rt.objects[lens].state["frame"][0] == 51.,
            "A resolved native selection restores its lens")
    if regular:
        rt.reparent(glass, 0)
        send(cpu, rt, header, "layoutSubviews")
        send(cpu, rt, header, "layoutSubviews")
        require(rt.objects[categories].state["subviews"] == [glass, tabs] and
                rt.objects[content_parent].state["subviews"] == [lens] and
                rt.objects[glass].state["overrideUserInterfaceStyle"] == 2,
                "Remount and repeated layout reuse one dark material and one selection below the original title strip")
    return {"native_title_state_wins_over_cached_indices": True, "original_selection_calls": rt.selection_calls,
            "original_background_calls": rt.background_calls, "actual_content_palette_checked": True,
            "no_host_selection_mutation": True, "missing_or_ambiguous_selection_hides_lens": True,
            "regular_material_remount_checked": regular}


def main():
    parser = argparse.ArgumentParser(description=__doc__)
    parser.add_argument("candidate", type=Path)
    baseline = parser.add_mutually_exclusive_group()
    baseline.add_argument("--expect-old", action="store_true")
    baseline.add_argument("--expect-button-material-baseline", action="store_true")
    parser.add_argument("--report", type=Path, required=True)
    args = parser.parse_args()
    data = args.candidate.read_bytes()
    labels = labels_for(data, args.candidate.with_suffix(".composed.s"), EXTRA)
    result = {"candidate_sha256": hashlib.sha256(data).hexdigest(), "passed": False, "device_tested": False}
    try:
        result.update(exercise(data, labels, args.expect_old, args.expect_button_material_baseline))
        result["passed"] = True
    except Exception as error:
        result["error"] = str(error)
    args.report.parent.mkdir(parents=True, exist_ok=True)
    args.report.write_text(json.dumps(result, indent=2) + "\n", encoding="utf-8")
    print(json.dumps(result))
    raise SystemExit(0 if result["passed"] else 1)


if __name__ == "__main__":
    main()
