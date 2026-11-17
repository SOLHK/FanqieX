#!/usr/bin/env python3
"""R30 regression using host-declared ownership and actual detail view classes.

Reading SHA-256: 8ddf85f4c490d595109f7a4352ce842e07f66e4802d7da6705610a4050abf271.
FQVShortVideoPlayerBottomView inherits UIView.layoutSubviews; its setup at
0x8107364 mounts episodeInfoView + cleanSwitchView, or episodeNewInfoView.
The original-chapter caption is constructed by the distribution view's related
info path (0xF218930 / 0xF218E00), not SSShortVideoOriginalNovelEntranceView.

The candidate core executes. UIKit constraint creation/activation and host
render callbacks are boundaries; this does not execute Auto Layout or pixels.
"""
import argparse
import copy
import hashlib
import json
from pathlib import Path

from arm64 import release_version, require
from test_control_glass166 import send
from test_controls171 import call
from test_drama_detail178r29 import Runtime as R29Runtime, NAV, MORE, DISABLED
from test_feed_viewport import labels_for
from test_page_glass174 import EXTRA, make

BOTTOM = "FQVShortVideoPlayerBottomView"
EPISODE = "FQVShortVideoVPlayerEpisodeInfoView"
NEW_INFO = "FQVShortVideoVPlayerContainBottomEpisodeInfoView"
CLEAN = "FQVShortVideoControlCleanSwitchView"
DISTRIBUTION = "SSShortVideoBottomDistributionView"
CONTENT_BASE = "SSShortVideoDistributionContentBaseView"
RELATED = "applyRelatedInfoUIToContentView:textArray:showTag:recommendTagText:bookInfo:canShowReadTip:"


class Runtime(R29Runtime):
    RELATED_NATIVE = 0x33300000

    def __init__(self, data):
        super().__init__(data)
        for name in (BOTTOM, EPISODE, NEW_INFO, CLEAN, CONTENT_BASE):
            self._class(name, "UIView")
        content_class = self.classes["SSShortVideoDistributionContentView"]
        self.parents[content_class] = self.classes[CONTENT_BASE]
        self.parents[self.metaclasses[content_class]] = self.metaclasses[self.classes[CONTENT_BASE]]
        for name in ("NSLayoutAnchor", "NSLayoutConstraint"):
            if name not in self.classes:
                self._class(name, "NSObject")
        # Only the methods in Reading's class_ro list are installed here.
        # In particular, none of these four host UIView subclasses owns layout.
        for cls, getters in ((BOTTOM, ("episodeInfoView", "cleanSwitchView", "episodeNewInfoView")),
                             (NEW_INFO, ("cleanScreenEntrance",))):
            for getter in getters:
                self._add(self.classes[cls], getter, self.NATIVE, "@16@0:8")
        self._add(self.classes[BOTTOM], "isNewSingleSeriesControlViewStyle", self.NATIVE, "B16@0:8")
        self._add(self.classes[DISTRIBUTION], RELATED, self.RELATED_NATIVE, "v60@0:8@16@24@32@40@48B56")
        self.anchor_objects = {}
        self.activated = []
        self.related_native_calls = []

    def responds(self, receiver, name):
        if receiver in self.objects and self.is_kind(receiver, self.classes["UIView"]) and name in (
                "centerXAnchor", "centerYAnchor", "widthAnchor", "heightAnchor"):
            return True
        return super().responds(receiver, name)

    def handle(self, cpu, pc):
        receiver, selector = cpu.x[:2]
        name = self.selector_names.get(selector)
        if pc == self.DRAMA_WATCH_RENDER:
            owner = self.objects[receiver].state
            model = self.objects[cpu.x[2]].state
            owner["lastRenderModel"] = cpu.x[2]
            if model.get("related"):
                target = self.get_method(self.classes[DISTRIBUTION], self.sel(RELATED))
                cpu.x[1] = self.sel(RELATED)
                cpu.x[2:8] = [owner["defaultContentView"], model["text"], 0, 0, model["book"], 1]
                cpu.pc = self.methods[target]["imp"]
                return True
            return self.finish(cpu)
        if pc == self.RELATED_NATIVE:
            self.related_native_calls.append(tuple(cpu.x[:8]))
            content = self.objects[cpu.x[2]].state
            content["backgroundColor"] = content["hostPaint"]
            self.objects[content["hostShade"]].state["backgroundColor"] = content["hostShadePaint"]
            return self.finish(cpu)
        if pc - self.slide == 0xa5d4:
            if receiver == self.classes["NSLayoutConstraint"] and name == "activateConstraints:":
                self.activated.append(tuple(self.objects[cpu.x[2]].state["items"]))
                return self.finish(cpu)
            if receiver in self.objects:
                state = self.objects[receiver].state
                if name in ("centerXAnchor", "centerYAnchor", "widthAnchor", "heightAnchor"):
                    key = receiver, name
                    if key not in self.anchor_objects:
                        self.anchor_objects[key] = self.obj("NSLayoutAnchor", name, owner=receiver, attribute=name)
                    return self.finish(cpu, self.anchor_objects[key])
                if self.is_kind(receiver, self.classes["NSLayoutAnchor"]):
                    if name == "constraintEqualToAnchor:":
                        return self.finish(cpu, self.obj("NSLayoutConstraint", "anchor equality", first=receiver, second=cpu.x[2]))
                    if name == "constraintEqualToConstant:":
                        return self.finish(cpu, self.obj("NSLayoutConstraint", "dimension equality", first=receiver, constant=cpu.fp(0)))
                if name == "setTranslatesAutoresizingMaskIntoConstraints:":
                    state["translatesAutoresizingMaskIntoConstraints"] = bool(cpu.x[2])
                    return self.finish(cpu)
        return super().handle(cpu, pc)


def exercise(data, labels):
    cpu, rt = make(data, Runtime)
    rt.labels = labels
    layout = rt.sel("layoutSubviews")
    base_method = rt.get_method(rt.classes["UIView"], layout)
    base_before = copy.deepcopy(rt.methods[base_method])
    require(layout not in rt.own[rt.classes[BOTTOM]], "Fixture matches the real inherited layout method")
    call(cpu, labels, "LFQH_FQHPageInstall")
    require(layout in rt.own[rt.classes[BOTTOM]], "The actual playback bottom view gets its own layout override")
    require(rt.methods[base_method] == base_before, "No global UIView implementation is modified")
    prefs = rt.objects[rt.DEFAULTS].state["values"]
    stock = rt.color("native detail fill")
    clear = rt.color("clearColor")

    def backing(view):
        return [child for child in rt.objects[view].state["subviews"]
                if rt.objects[child].state.get("configuration")]

    # Real screenshot path: native episode view and separate clean-switch view.
    bottom = rt.view(BOTTOM, "actual player bottom", (0, 840, 440, 60), rt.ROOT,
                     isNewSingleSeriesControlViewStyle=False)
    episode = rt.view(EPISODE, "选集 · 全103集 · 免费观看", (16, 4, 360, 40), bottom,
                      backgroundColor=stock, native_click="episodeInfoViewDidClickBlock")
    clean = rt.view(CLEAN, "independent clean-screen switch", (396, 4, 24, 40), bottom,
                    backgroundColor=stock, native_delegate=bottom)
    original_arrow = rt.view("UIImageView", "episode upward arrow", (336, 12, 12, 16), episode)
    rt.objects[bottom].state.update(episodeInfoView=episode, cleanSwitchView=clean)
    geometry = {view: rt.objects[view].state["frame"] for view in (bottom, episode, clean, original_arrow)}
    send(cpu, rt, bottom, "layoutSubviews")
    require(len(backing(episode)) == len(backing(clean)) == 1 and
            rt.objects[episode].state["backgroundColor"] == clear and
            not rt.objects[original_arrow].state["hidden"], "The real episode and clean controls have passive glass")
    require(all(rt.objects[view].state["frame"] == frame for view, frame in geometry.items()) and
            rt.objects[clean].state["native_delegate"] == bottom and
            rt.objects[episode].state["native_click"] == "episodeInfoViewDidClickBlock",
            "Actual playback geometry and native control actions remain unchanged")
    prefs[DISABLED] = True
    send(cpu, rt, bottom, "layoutSubviews")
    require(not backing(episode) and not backing(clean) and rt.objects[episode].state["backgroundColor"] == stock,
            "Disabling restores the actual playback bottom view")
    prefs[DISABLED] = False

    # Nav creation occurs while constraints are being installed, before frames.
    nav = rt.view("UIView", "native nav before Auto Layout", (0, 0, 440, 44), rt.ROOT)
    button = rt.view("UIButton", "zero-bounds native back", (0, 0, 0, 0), nav,
                     native_action="backBtnClicked:", hitInsets=(-10., -10., -10., -10.))
    item_button = rt.view("UIButton", "zero-bounds native more", (0, 0, 0, 0), nav, native_action="moreBtnClicked")
    item = rt.obj(MORE, "actual more item", moreBtn=item_button, view=item_button)
    component = rt.obj(NAV, "actual navbar component", navBar=nav, backBtn=button, moreBtn=0,
                        navigationBarRightItems=rt.obj("NSArray", "native items", items=[item]))
    send(cpu, rt, component, "setupLayout:", nav)
    require(len(rt.activated) == 2 and len(backing(button)) == len(backing(item_button)) == 1,
            "Zero initial bounds still create both navigation materials")
    for native_button, constraints in zip((button, item_button), rt.activated):
        glass, = backing(native_button)
        require(len(constraints) == 4 and not rt.objects[glass].state["translatesAutoresizingMaskIntoConstraints"],
                "One public four-constraint graph replaces autoresizing on the decorative view")
        actual = []
        for constraint in constraints:
            row = rt.objects[constraint].state
            first = rt.objects[row["first"]].state
            require(first["owner"] == glass, "Constraints affect only the plugin material")
            second = rt.objects[row["second"]].state if "second" in row else None
            actual.append((first["attribute"], second["owner"] if second else None,
                           second["attribute"] if second else None, row.get("constant")))
        require(actual == [("centerXAnchor", native_button, "centerXAnchor", None),
                           ("centerYAnchor", native_button, "centerYAnchor", None),
                           ("widthAnchor", None, None, 36.), ("heightAnchor", None, None, 36.)],
                "The material is centered on its real target at a fixed 36-point diameter")
    for native_button in (button, item_button):
        rt.objects[native_button].state.update(frame=(16., 10., 24., 24.), bounds=(0., 0., 24., 24.))
    send(cpu, rt, component, "updateNavgationBarLeftView")
    send(cpu, rt, item, "setUp")
    require(len(rt.activated) == 2 and rt.objects[button].state["frame"] == (16., 10., 24., 24.) and
            rt.objects[button].state["native_action"] == "backBtnClicked:",
            "Later host frames reuse constraints without moving or replacing the native button")

    # The actual related-info render callback paints an opaque stock shade.
    owner = rt.view(DISTRIBUTION, "original chapter distribution", (0, 780, 440, 42), rt.ROOT)
    content = rt.view("SSShortVideoDistributionContentView", "related-info target", (0, 0, 440, 42), owner,
                      backgroundColor=stock, hostPaint=stock, native_action="original chapter")
    shade_color = rt.obj("UIColor", "native 15 percent white", white=1., alpha=.15)
    shade = rt.view("UIView", "native opaque backing", (0, 0, 440, 42), content, backgroundColor=shade_color)
    arrow = rt.view("UIImageView", "original chapter arrow", (418, 12, 8, 16), content)
    rt.objects[content].state.update(hostShade=shade, hostShadePaint=shade_color, arrowImageView=arrow)
    rt.objects[owner].state["defaultContentView"] = content
    bar = rt.obj("NSObject", "related original model", bottomBarType=rt.text_object("original_novel"))
    text = rt.obj("NSArray", "native original chapter text", items=[])
    book = rt.obj("NSObject", "native original book")
    model = rt.obj("NSObject", "related-info render model", bottomBar=bar, related=True, text=text, book=book)
    send(cpu, rt, owner, "renderWithModel:", model)
    require(rt.related_native_calls and rt.related_native_calls[-1][2:] == (content, text, 0, 0, book, 1),
            "The real related-info callback forwards every object and BOOL argument")
    require(len(backing(content)) == 1 and
            all(rt.objects[view].state["backgroundColor"] == clear for view in (content, shade)) and
            not rt.objects[arrow].state["hidden"] and rt.objects[content].state["native_action"] == "original chapter",
            "Original-chapter glass clears both stock fills while keeping its arrow and native action")
    send(cpu, rt, owner, "renderWithModel:", model)
    require(len(backing(content)) == 1 and rt.objects[shade].state["backgroundColor"] == clear,
            "Native repaint is followed by one current related-info glass surface")
    rt.objects[model].state["related"] = False
    send(cpu, rt, owner, "renderWithModel:", model)
    require(not backing(content) and rt.objects[content].state["backgroundColor"] == stock and
            rt.objects[shade].state["backgroundColor"] == shade_color and not rt.objects[arrow].state["hidden"],
            "Reusing the row outside the related-info path restores both native fills")
    return {"real_inherited_bottom_layout": True, "global_uiview_unchanged": True,
            "zero_bounds_navigation_constraint_graph": True, "real_related_info_callback": True,
            "opaque_original_row_backing_cleared": True,
            "uikit_auto_layout_executed": False, "pixel_rendering_tested": False, "device_tested": False}


def negative_baseline(data, labels):
    require(release_version(data) == "1.78R29", "The negative control must be the delivered R29 core")
    cpu, rt = make(data, Runtime)
    rt.labels = labels
    call(cpu, labels, "LFQH_FQHPageInstall")
    missing_bottom = rt.sel("layoutSubviews") not in rt.own[rt.classes[BOTTOM]]
    nav = rt.view("UIView", "native nav before Auto Layout", (0, 0, 440, 44), rt.ROOT)
    button = rt.view("UIButton", "actual zero-bounds native back", parent=nav)
    component = rt.obj(NAV, "navbar component", navBar=nav, backBtn=button, moreBtn=0,
                        navigationBarRightItems=rt.obj("NSArray", "right items", items=[]))
    send(cpu, rt, component, "setupLayout:", nav)
    missing_nav = not rt.activated and not any(rt.objects[child].state.get("configuration")
                                              for child in rt.objects[button].state["subviews"])
    stock = rt.color("native original fill")
    owner = rt.view(DISTRIBUTION, "original chapter distribution", (0, 780, 440, 42), rt.ROOT)
    content = rt.view("SSShortVideoDistributionContentView", "real related-info target", (0, 0, 440, 42), owner,
                      backgroundColor=stock, hostPaint=stock)
    shade_color = rt.obj("UIColor", "stock white shade", white=1., alpha=.15)
    shade = rt.view("UIView", "native shade", (0, 0, 440, 42), content, backgroundColor=shade_color)
    rt.objects[content].state.update(hostShade=shade, hostShadePaint=shade_color)
    rt.objects[owner].state["defaultContentView"] = content
    model = rt.obj("NSObject", "related-info render", related=True,
                   bottomBar=rt.obj("NSObject", "bar", bottomBarType=rt.text_object("original_novel")),
                   text=rt.obj("NSArray", "native text", items=[]), book=rt.obj("NSObject", "original book"))
    send(cpu, rt, owner, "renderWithModel:", model)
    missing_related = bool(rt.related_native_calls) and not any(rt.objects[child].state.get("configuration")
                                                                for child in rt.objects[content].state["subviews"])
    require(missing_bottom and missing_nav and missing_related,
            "Delivered R29 reproduces all three missing detail-decoration paths")
    return {"passed": False, "negative_control_passed": True,
            "missing_real_bottom_override": missing_bottom, "zero_bounds_nav_missing_material": missing_nav,
            "actual_original_row_missing_material": missing_related,
            "uikit_auto_layout_executed": False, "pixel_rendering_tested": False, "device_tested": False}


def main():
    parser = argparse.ArgumentParser(description=__doc__)
    parser.add_argument("candidate", type=Path)
    parser.add_argument("--report", type=Path, required=True)
    parser.add_argument("--negative-baseline", action="store_true")
    args = parser.parse_args()
    data = args.candidate.read_bytes()
    labels = labels_for(data, args.candidate.with_suffix(".composed.s"), EXTRA)
    result = negative_baseline(data, labels) if args.negative_baseline else {"passed": True, **exercise(data, labels)}
    report = {"candidate_sha256": hashlib.sha256(data).hexdigest(), **result}
    args.report.parent.mkdir(parents=True, exist_ok=True)
    args.report.write_text(json.dumps(report, indent=2) + "\n", encoding="utf-8")
    print(json.dumps(report, indent=2))


if __name__ == "__main__":
    main()
