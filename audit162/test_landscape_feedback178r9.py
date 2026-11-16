#!/usr/bin/env python3
"""Execute landscape control decoration and recommendation filtering in ARM64."""
import argparse
import hashlib
import json
from pathlib import Path

from arm64 import release_version, require
from test_controls171 import call
from test_control_glass166 import send
from test_drama_controls178r8 import Runtime as BaseRuntime, ABOVE, REASON, REASON_VIEW, CONFIG, CONTEXT
from test_feed_viewport import labels_for
from test_page_glass174 import EXTRA, make

INFO = "FQVShortVideoPlayerLandscapeBaseInfoView"
CONTROL = "FQVShortVideoPlayerLandscapeBaseControlView"
NAV = "FQVShortVideoLandscapeNavBar"
RIGHT = "FQVShortVideoLandscapeBottomRightView"
SOCIAL = "SSShortVideoLandscapeBizInteractionView"
ENTRY = "SSShortVideoLandscapeAutoInflowTipView"
ADJUST = "FQVLandscapeAdjustButtonBase"
ITEM = "FQVShortVideoLandscapeNavBarItem"


class Runtime(BaseRuntime):
    NATIVE_LAYOUT = 0x33270000
    NATIVE_REFRESH = 0x33270004

    def __init__(self, data):
        super().__init__(data)
        for cls in (INFO, CONTROL, NAV, RIGHT, SOCIAL, ENTRY, ADJUST):
            self._class(cls, "UIView")
        self._class(ITEM, "NSObject")
        self._add(self.classes["UIView"], "layoutSubviews", self.NATIVE_LAYOUT, "v16@0:8")
        for cls in (CONTROL, ADJUST):
            self._add(self.classes[cls], "layoutSubviews", self.NATIVE_LAYOUT, "v16@0:8")
        self._add(self.classes[NAV], "refreshLayout", self.NATIVE_LAYOUT, "v16@0:8")
        self._add(self.classes[SOCIAL], "refreshUI", self.NATIVE_REFRESH, "v16@0:8")
        self._add(self.classes[SOCIAL], "danmakuSwitchDidChange:", self.NATIVE_REFRESH, "v20@0:8B16")

    def handle(self, cpu, pc):
        receiver, selector = cpu.x[:2]
        name = self.selector_names.get(selector)
        if pc == self.NATIVE_LAYOUT:
            state = self.objects[receiver].state
            state["nativeLayouts"] = state.get("nativeLayouts", 0) + 1
            return self.finish(cpu)
        if pc == self.NATIVE_REFRESH:
            state = self.objects[receiver].state
            icon = self.objects[state["danmakuBtnView"]].state
            icon["hidden"] = state.get("hideDanmaku", False)
            icon["alpha"] = state.get("danmakuAlpha", 1.)
            return self.finish(cpu)
        if pc - self.slide == 0xa5d4 and receiver in self.objects:
            state = self.objects[receiver].state
            if name == "contentEdgeInsets":
                return self.finish(cpu, fp=state.get(name, (0., 0., 0., 0.)))
            if name == "setContentEdgeInsets:":
                state["contentEdgeInsets"] = tuple(cpu.fp(i) for i in range(4))
                return self.finish(cpu)
            if name == "spacing":
                return self.finish(cpu, fp=(state.get(name, 0.),))
            if name == "setSpacing:":
                state["spacing"] = cpu.fp(0)
                return self.finish(cpu)
            if name == "clipsToBounds":
                return self.finish(cpu, int(state.get(name, False)))
            if name == "setClipsToBounds:":
                state["clipsToBounds"] = bool(cpu.x[2])
                return self.finish(cpu)
            if name in ("navBackImageView", "playBtn", "nextBtn", "moreBtn", "muteView", "screenLockBtn",
                        "landingMuteView", "seriesBtn", "playRateBtn", "resolutionBtn", "likeBtnView",
                        "commentBtnView", "starBtnView", "danmakuBtnView", "danmakuInputView",
                        "danmakuInputBGView", "danmakuPublishBtn", "itemList", "rcmdReasonModel",
                        "content", "recommendReason", "reasonText") and name in state:
                return self.finish(cpu, state[name])
        return super().handle(cpu, pc)


def exercise(data, labels):
    cpu, rt = make(data, Runtime)
    rt.labels = labels
    call(cpu, labels, "LFQH_FQHPageInstall")
    prefs = rt.objects[rt.DEFAULTS].state["values"]
    shade = rt.color("native player paint")
    targets = []
    owners = []

    def target(owner, key, image=False, size=(44., 44.)):
        view = rt.view("UIImageView" if image else "UIButton", key, (60., 60., *size), owner,
                       backgroundColor=shade, originalAction=key)
        rt.objects[owner].state[key] = view
        targets.append(view)
        return view

    for cls, keys in (
        (INFO, ("navBackImageView", "playBtn", "nextBtn", "moreBtn", "muteView")),
        (CONTROL, ("screenLockBtn", "landingMuteView")),
        (RIGHT, ("seriesBtn", "playRateBtn", "resolutionBtn")),
        (SOCIAL, ("likeBtnView", "commentBtnView", "starBtnView", "danmakuBtnView", "danmakuInputView", "danmakuPublishBtn")),
    ):
        owner = rt.view(cls, cls, (0., 0., 844., 390.))
        owners.append((owner, "layoutSubviews"))
        for key in keys:
            target(owner, key, key in ("navBackImageView", "danmakuBtnView"))
    for cls in (ENTRY, ADJUST):
        owner = rt.view(cls, cls, (0., 0., 96., 36.), backgroundColor=shade)
        owners.append((owner, "layoutSubviews"))
        targets.append(owner)
    nav = rt.view(NAV, "navigation", (0., 0., 250., 48.))
    share = target(nav, "share", size=(0., 0.))
    item = rt.obj(ITEM, "share entry", view=share)
    rt.objects[nav].state["itemList"] = rt.obj("NSArray", "items", items=[item])
    send(cpu, rt, nav, "refreshLayout")
    require(not rt.objects[share].state["subviews"], "Zero-sized new navigation entry waits for native layout")
    rt.objects[share].state.update(frame=(60., 60., 44., 44.), bounds=(0., 0., 44., 44.))
    owners.append((nav, "layoutSubviews"))
    before = {v: rt.objects[v].state["frame"] for v in targets}

    def materials():
        return {v: [c for c in rt.objects[v].state["subviews"] if rt.objects[c].state.get("configuration")]
                for v in targets if not rt.is_kind(v, rt.classes["UIImageView"])}

    for owner, selector in owners:
        send(cpu, rt, owner, selector)
    first = materials()
    require(all(len(items) == 1 for items in first.values()), "Each inspected control receives exactly one material")
    for items in first.values():
        state = rt.objects[items[0]].state
        require(not state["userInteractionEnabled"] and state["overrideUserInterfaceStyle"] == 2,
                "Glass stays behind native actions and uses the white-ink player palette")
    for owner, selector in owners:
        send(cpu, rt, owner, selector)
    require(first == materials(), "Repeated host layout reuses every glass control")
    require(all(rt.objects[v].state["frame"] == before[v] for v in targets), "Native tap rectangles are unchanged")
    social = next(owner for owner, _ in owners if rt.is_kind(owner, rt.classes[SOCIAL]))
    state = rt.objects[social].state
    image_glasses = [c for c in state["subviews"] if rt.objects[c].state.get("configuration")]
    require(len(image_glasses) == 1, "The image-only danmaku glyph has one sibling glass backing")
    glass = image_glasses[0]
    layouts = state["nativeLayouts"]
    state.update(hideDanmaku=True, danmakuAlpha=0.)
    send(cpu, rt, social, "refreshUI")
    require(rt.objects[glass].state["hidden"] and rt.objects[glass].state["alpha"] == 0.,
            "Native refresh hides the sibling without needing a layout pass")
    state.update(hideDanmaku=False, danmakuAlpha=1.)
    send(cpu, rt, social, "danmakuSwitchDidChange:", 1)
    require(not rt.objects[glass].state["hidden"] and rt.objects[glass].state["alpha"] == 1. and
            state["nativeLayouts"] == layouts, "Danmaku state restores its glass without forcing host layout")
    probe = rt.view("UIView", "unrelated host view")
    send(cpu, rt, probe, "layoutSubviews")
    require(rt.objects[probe].state["nativeLayouts"] == 1 and not rt.objects[probe].state["subviews"],
            "Inherited layout overrides leave UIView and unrelated screens unchanged")
    prefs["FanqieAdBlock.GlassDisabled.1"] = True
    for owner, selector in owners:
        send(cpu, rt, owner, selector)
    require(all(not items for items in materials().values()), "Disabling glass removes every owned material")
    require(glass not in state["subviews"], "Disabling glass also removes the image-only sibling")
    require(all(rt.objects[v].state["backgroundColor"] == shade for v in targets), "Native paint restores")

    config = rt.obj(CONFIG, "root feed", feedType=4)
    context = rt.obj(CONTEXT, "root", config=config)
    reason_view = rt.view(REASON_VIEW, "interest tag")
    other = rt.view("UIView", "unrelated control")
    model = rt.obj("NSObject", "reason", content=rt.text_object("根据小说兴趣推荐"))
    reason = rt.obj(REASON, "reason owner", isRelateNovelReason=False, decorationView=reason_view, rcmdReasonModel=model)
    order = rt.obj("NSArray", "order", items=[reason_view, other])
    manager = rt.obj(ABOVE, "above left", vcContext=context, rcmdReasonViewManager=reason,
                     orderedAboveLeftViewsForCurrentState=order)
    prefs["FanqieX.DramaRecommendationReason.1"] = False
    result = send(cpu, rt, manager, "orderedAboveLeftViewsForCurrentState")["result"]
    require(rt.objects[result].state["items"] == [other] and rt.objects[order].state["items"] == [reason_view, other],
            "Interest toggle removes only its display entry without mutating host data")
    rt.objects[model].state["content"] = rt.text_object("其他推荐")
    result = send(cpu, rt, manager, "orderedAboveLeftViewsForCurrentState")["result"]
    require(result == order, "Unrelated recommendation content remains visible")
    return {"landscape_controls": len(targets), "reuse_and_restore": True, "native_targets_preserved": True,
            "unrelated_layout_preserved": True, "interest_toggle": True, "danmaku_hidden_without_layout": True,
            "navigation_first_layout": True}


def main():
    parser = argparse.ArgumentParser(description=__doc__)
    parser.add_argument("candidate", type=Path)
    parser.add_argument("--report", type=Path, required=True)
    args = parser.parse_args()
    data = args.candidate.read_bytes()
    require(release_version(data) in ("1.78R9", "1.78R10", "1.78R11", "1.78R12"), "Use R9 through R12")
    labels = labels_for(data, args.candidate.with_suffix(".composed.s"), EXTRA)
    report = {"passed": True, "candidate_sha256": hashlib.sha256(data).hexdigest(),
              **exercise(data, labels), "device_tested": False}
    args.report.write_text(json.dumps(report, ensure_ascii=False, indent=2) + "\n", encoding="utf8")
    print(json.dumps(report, indent=2))


if __name__ == "__main__":
    main()
