#!/usr/bin/env python3
"""Execute the portrait episode-title constraint correction in the ARM64 core.

Reading 7.4.3.33 SHA-256:
8ddf85f4c490d595109f7a4352ce842e07f66e4802d7da6705610a4050abf271.
FQVShortVideoListVCNavBarComponent.navLeftLabel is @16@0:8 at 0x80C64A4.
Its updateNavgationBarLeftView block at 0x80C2E98--0x80C2EE0 installs
label.left == backBtn.right without an offset; centerY and maximum width
are separate native constraints. UIKit is modeled only at its API boundary:
this audit does not solve Auto Layout or render device pixels.
"""
import argparse
import copy
import hashlib
import json
from pathlib import Path

from arm64 import release_version, require
from test_control_glass166 import send
from test_controls171 import call
from test_drama_detail178r29 import DISABLED, NAV
from test_drama_navigation178r32 import Runtime as NavigationRuntime
from test_feed_viewport import labels_for
from test_page_glass174 import EXTRA, make


class Runtime(NavigationRuntime):
    def __init__(self, data):
        super().__init__(data)
        self._add(self.classes[NAV], "navLeftLabel", self.NATIVE, "@16@0:8")

    def responds(self, receiver, name):
        if receiver in self.objects and name == "constraints":
            return name in self.objects[receiver].state
        return super().responds(receiver, name)

    def handle(self, cpu, pc):
        receiver, selector = cpu.x[:2]
        name = self.selector_names.get(selector)
        if pc - self.slide == 0xa5d4 and receiver in self.objects:
            state = self.objects[receiver].state
            if name in ("navLeftLabel", "constraints", "firstItem", "secondItem",
                        "firstAttribute", "secondAttribute", "relation"):
                return self.finish(cpu, state.get(name, 0))
            if name == "multiplier":
                return self.finish(cpu, fp=(state.get(name, 1.),))
        return super().handle(cpu, pc)


def exercise(data, labels, negative=False):
    cpu, rt = make(data, Runtime)
    rt.labels = labels
    call(cpu, labels, "LFQH_FQHPageInstall")
    prefs = rt.objects[rt.DEFAULTS].state["values"]
    nav = rt.view("UIView", "native portrait nav", (0., 0., 440., 44.), rt.ROOT)
    back = rt.view("UIButton", "native back target", (19., 10., 24., 24.), nav,
                   clipsToBounds=True, native_action="backBtnClicked:", hitInsets=(-10.,)*4)
    image = rt.obj("UIImage", "native stock back artwork", size=(24., 24.))
    glyph = rt.view("UIImageView", "native back glyph", (0., 0., 24., 24.), back, image=image)
    rt.objects[back].state.update(imageView=glyph, images={0: image}, tintColor=rt.color("native white"))
    title = rt.view("UILabel", "native episode title", (43., 12., 90., 20.), nav,
                    text=rt.text_object("第1集"))
    config = rt.obj("NSObject", "native config", navBackImageName=0)
    context = rt.obj("NSObject", "native context", config=config)
    component = rt.obj(NAV, "native navigation component", navBar=nav, backBtn=back,
                       moreBtn=0, navLeftLabel=title, listVCContext=context,
                       navigationBarRightItems=rt.obj("NSArray", "no right items", items=[]))

    def constraint(first=title, second=back, left=1, right=2, constant=0., relation=0, multiplier=1.):
        return rt.obj("NSLayoutConstraint", "native constraint", firstItem=first, secondItem=second,
                      firstAttribute=left, secondAttribute=right, constant=constant,
                      relation=relation, multiplier=multiplier)

    leading = constraint()
    unrelated = [constraint(left=10, right=10),
                 constraint(second=0, left=7, right=0, constant=240., relation=-1),
                 constraint(first=back, second=title),
                 constraint(relation=1, constant=2.),
                 constraint(multiplier=2., constant=3.)]

    def install(current):
        rt.objects[nav].state["constraints"] = rt.obj("NSArray", "host constraint list",
                                                    items=[current, *unrelated])

    def value(current):
        return rt.objects[current].state["constant"]

    install(leading)
    unrelated_before = [copy.deepcopy(rt.objects[row].state) for row in unrelated]
    button_keys = ("frame", "bounds", "native_action", "hitInsets", "images", "tintColor", "clipsToBounds")
    button_before = {key: copy.deepcopy(rt.objects[back].state[key]) for key in button_keys}
    glyph_before = {key: copy.deepcopy(rt.objects[glyph].state[key]) for key in ("frame", "bounds", "image")}
    title_before = {key: copy.deepcopy(rt.objects[title].state[key]) for key in ("frame", "bounds", "text")}
    send(cpu, rt, component, "setupLayout:", nav)
    if negative:
        require(release_version(data) == "1.78R33", "Negative control is the delivered R33 core")
        require(value(leading) == 0., "R33 reproduces the native zero-gap title constraint")
        return {"passed": False, "negative_control_passed": True, "native_title_spacing_pt": 0.,
                "uikit_auto_layout_executed": False, "uikit_pixels_executed": False}

    require(value(leading) == 12., "R34 adds 12 points to the native title's leading constraint")
    # The new backing still has its initial frame here. The constraint fix must
    # work before UIKit resolves the backing's glyph-centered Auto Layout graph.
    for _ in range(3):
        send(cpu, rt, component, "updateNavgationBarLeftView")
    require(value(leading) == 12., "Repeated host updates do not accumulate spacing")
    rt.objects[back].state["hidden"] = True
    send(cpu, rt, component, "updateNavgationBarLeftView")
    require(value(leading) == 0., "A hidden back button restores the native zero-gap constraint")
    rt.objects[back].state["hidden"] = False
    send(cpu, rt, component, "updateNavgationBarLeftView")
    require(value(leading) == 12., "Reappearing back button reapplies the title spacing")
    prefs[DISABLED] = True
    send(cpu, rt, component, "updateNavgationBarLeftView")
    require(value(leading) == 0., "Disabling glass restores the original constraint")

    # Native navigation rebuilds install a different constraint object. A
    # leading/trailing pair exercises the equivalent directional attributes.
    replacement = constraint(left=5, right=6, constant=3.)
    install(replacement)
    prefs[DISABLED] = False
    send(cpu, rt, component, "updateNavgationBarLeftView")
    require(value(replacement) == 12., "A replacement native leading constraint receives spacing")
    prefs[DISABLED] = True
    send(cpu, rt, component, "updateNavgationBarLeftView")
    require(value(replacement) == 3., "Replacement constraint restores its own native value")

    wide = constraint(constant=20.)
    install(wide)
    prefs[DISABLED] = False
    send(cpu, rt, component, "updateNavgationBarLeftView")
    require(value(wide) == 20., "Existing spacing larger than 12 points is preserved")
    prefs[DISABLED] = True
    send(cpu, rt, component, "updateNavgationBarLeftView")
    require(value(wide) == 20., "Disabling leaves an unchanged native wider gap intact")
    require([rt.objects[row].state for row in unrelated] == unrelated_before,
            "CenterY, width, unrelated owners, inequality and scaled constraints are untouched")
    require({key: rt.objects[back].state[key] for key in button_keys} == button_before and
            {key: rt.objects[glyph].state[key] for key in glyph_before} == glyph_before,
            "Native back artwork, frame, target, hit insets and clipping remain unchanged")
    require({key: rt.objects[title].state[key] for key in title_before} == title_before,
            "The correction only changes the constraint, without rewriting label text or frames")
    return {"passed": True, "title_constraint_spacing_pt": 12., "before_auto_layout_supported": True,
            "repeated_updates_no_drift": True, "native_constraint_replacement": True,
            "larger_native_gap_preserved": True, "disable_and_hidden_restore": True,
            "unrelated_constraints_preserved": True, "native_glyph_targets_frames_preserved": True,
            "uikit_auto_layout_executed": False, "uikit_pixels_executed": False, "device_tested": False}


def main():
    parser = argparse.ArgumentParser(description=__doc__)
    parser.add_argument("candidate", type=Path)
    parser.add_argument("--report", type=Path, required=True)
    parser.add_argument("--negative-baseline", action="store_true")
    args = parser.parse_args()
    data = args.candidate.read_bytes()
    labels = labels_for(data, args.candidate.with_suffix(".composed.s"), EXTRA)
    result = {"candidate_sha256": hashlib.sha256(data).hexdigest(),
              **exercise(data, labels, args.negative_baseline)}
    args.report.parent.mkdir(parents=True, exist_ok=True)
    args.report.write_text(json.dumps(result, indent=2) + "\n", encoding="utf-8")
    print(json.dumps(result, indent=2))


if __name__ == "__main__":
    main()
