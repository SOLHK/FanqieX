#!/usr/bin/env python3
"""Portrait nav regressions: actual glyph anchors and legacy more-item mounting.

Reading 7.4.3.33 owns the legacy selector at 0x80C397C (v32@0:8@16Q24).
The dispatcher at 0x80C38A4 selects that path independently of the newer
updateNavgationBarRightViewWithRightItems: path. UIKit constraints remain an
explicit API boundary here; no claim is made about rendered UIKit pixels.
"""
import argparse
import copy
import hashlib
import json
from pathlib import Path

from arm64 import require, release_version
from test_control_glass166 import send
from test_controls171 import call
from test_drama_detail178r29 import NAV, MORE, DISABLED
from test_drama_detail178r30 import Runtime as DetailRuntime
from test_feed_viewport import labels_for
from test_page_glass174 import EXTRA, make

LEGACY = "updateNavgationBarRightView:showItemValue:"


class Runtime(DetailRuntime):
    LEGACY_NATIVE = 0x33320000

    def __init__(self, data):
        super().__init__(data)
        self._add(self.classes[NAV], LEGACY, self.LEGACY_NATIVE, "v32@0:8@16Q24")
        self.legacy_calls = []
        self.deactivated = []

    def handle(self, cpu, pc):
        receiver, selector = cpu.x[:2]
        name = self.selector_names.get(selector)
        if pc == self.LEGACY_NATIVE:
            self.legacy_calls.append(tuple(cpu.x[:4]))
            state = self.objects[receiver].state
            # The native implementation adds moreBtn before installing its
            # constraints. It can be absent during the earlier setupLayout:.
            self.reparent(state["moreBtn"], state["navBarRightView"])
            return self.finish(cpu)
        if pc - self.slide == 0xa5d4 and receiver == self.classes["NSLayoutConstraint"]:
            if name == "deactivateConstraints:":
                self.deactivated.append(tuple(self.objects[cpu.x[2]].state["items"]))
                return self.finish(cpu)
        return super().handle(cpu, pc)


def fixture(data, labels):
    cpu, rt = make(data, Runtime)
    rt.labels = labels
    call(cpu, labels, "LFQH_FQHPageInstall")
    nav = rt.view("UIView", "native portrait nav", (0, 0, 440, 44), rt.ROOT)
    right = rt.view("UIView", "native right container", (396, 0, 28, 44), nav)
    back = rt.view("UIButton", "native back target", (16, 0, 40, 44), nav,
                   clipsToBounds=True, native_action="backBtnClicked:", hitInsets=(-10.,)*4)
    more = rt.view("UIButton", "later mounted legacy more", (0, 0, 0, 0),
                   native_action="moreBtnClicked:", hitInsets=(-10., -10., -10., -20.))
    for button, frame in ((back, (0, 10, 24, 24)), (more, (0, 0, 0, 0))):
        image = rt.obj("UIImage", "unchanged host white glyph")
        glyph = rt.view("UIImageView", "native off-center image", frame, button, image=image)
        rt.objects[button].state.update(imageView=glyph, images={0:image}, tintColor=rt.color("native white"))
    component = rt.obj(NAV, "native component", navBar=nav, backBtn=back, moreBtn=more,
                        navBarRightView=right, navigationBarRightItems=rt.obj("NSArray", "no modern items", items=[]))
    return cpu, rt, nav, right, back, more, component


def material_for(rt, parent):
    return [child for child in rt.objects[parent].state["subviews"] if rt.objects[child].state.get("configuration")]


def graph(rt, glass):
    for constraints in reversed(rt.activated):
        if rt.objects[rt.objects[constraints[0]].state["first"]].state["owner"] == glass:
            return [rt.objects[constraint].state for constraint in constraints]
    return []


def exercise(data, labels, negative=False):
    cpu, rt, nav, right, back, more, component = fixture(data, labels)
    before = {button: {key: copy.deepcopy(rt.objects[button].state[key])
                       for key in ("frame", "native_action", "hitInsets", "images", "tintColor")}
              for button in (back, more)}
    send(cpu, rt, component, "setupLayout:", nav)
    context = rt.obj("NSObject", "native legacy context")
    flags = (1 << 32) + 2
    send(cpu, rt, component, LEGACY, context, flags)
    require(rt.legacy_calls == [(component, rt.sel(LEGACY), context, flags)],
            "The exact legacy owner, context and 64-bit show mask reach the native implementation")
    if negative:
        require(release_version(data) == "1.78R31", "Negative control is the delivered R31 core")
        wrong_layer = bool(material_for(rt, back)) and not material_for(rt, nav)
        wrong_center = False
        if wrong_layer:
            rows = graph(rt, material_for(rt, back)[0])
            wrong_center = all(rt.objects[row["second"]].state["owner"] == back for row in rows[:2])
        missing_legacy = not material_for(rt, more) and not material_for(rt, right)
        require(wrong_layer and wrong_center and missing_legacy,
                "R31 reproduces the internal button-center backing and misses the legacy more callback")
        return {"passed":False, "negative_control_passed":True, "back_internal_layer_and_wrong_center":True,
                "legacy_more_missing_glass":True, "uikit_pixels_executed":False}
    for button, parent in ((back, nav), (more, right)):
        glass, = material_for(rt, parent)
        require(not material_for(rt, button), "No glass is inside the native button's private content order")
        siblings = rt.objects[parent].state["subviews"]
        require(siblings.index(glass) < siblings.index(button), "Material remains behind the whole native button")
        require(not rt.objects[glass].state["userInteractionEnabled"] and
                rt.objects[glass].state["accessibilityElementsHidden"], "Decoration never intercepts actions or accessibility")
        rows = graph(rt, glass)
        require(len(rows) == 4 and all(rt.objects[row["second"]].state["owner"] == rt.objects[button].state["imageView"]
                                       for row in rows[:2]) and [row["constant"] for row in rows[2:]] == [36., 36.],
                "Center constraints follow the actual native glyph, with a fixed 36-point backing")
        require({key: rt.objects[button].state[key] for key in before[button]} == before[button],
                "Button geometry, hit insets, white image states, tint and actions are unchanged")
    require(rt.objects[back].state["clipsToBounds"], "Sibling decoration does not change native button clipping")
    count = len(rt.activated)
    send(cpu, rt, component, "updateNavgationBarLeftView")
    send(cpu, rt, component, LEGACY, context, flags)
    require(len(rt.activated) == count, "Repeated native updates do not duplicate constraints")
    old_glass, = material_for(rt, right)
    rt.reparent(old_glass, 0)
    rt.reparent(more, 0)
    send(cpu, rt, component, LEGACY, context, flags)
    require(material_for(rt, right) == [old_glass] and len(rt.deactivated) == 1 and len(rt.activated) == count + 1,
            "A native right-container rebuild reattaches one backing and reinstalls its constraint graph")
    rt.objects[more].state["hidden"] = True
    send(cpu, rt, component, LEGACY, context, flags)
    require(rt.objects[old_glass].state["hidden"], "Native hidden state also hides the sibling material")
    rt.objects[rt.DEFAULTS].state["values"][DISABLED] = True
    send(cpu, rt, component, "updateNavgationBarLeftView")
    require(not material_for(rt, nav) and not material_for(rt, right), "Disabling glass removes both navigation backings")
    return {"passed":True, "actual_glyph_center_constraints":True, "glass_behind_native_button":True,
            "legacy_more_update_covered":True, "native_targets_assets_frames_preserved":True,
            "container_rebuild_and_visibility":True, "uikit_auto_layout_executed":False,
            "uikit_pixels_executed":False, "device_tested":False}


def main():
    parser = argparse.ArgumentParser(description=__doc__)
    parser.add_argument("candidate", type=Path)
    parser.add_argument("--report", type=Path, required=True)
    parser.add_argument("--negative-baseline", action="store_true")
    args = parser.parse_args()
    data = args.candidate.read_bytes()
    labels = labels_for(data, args.candidate.with_suffix(".composed.s"), EXTRA)
    result = {"candidate_sha256":hashlib.sha256(data).hexdigest(), **exercise(data, labels, args.negative_baseline)}
    args.report.parent.mkdir(parents=True, exist_ok=True)
    args.report.write_text(json.dumps(result, indent=2) + "\n", encoding="utf-8")
    print(json.dumps(result, indent=2))


if __name__ == "__main__":
    main()
