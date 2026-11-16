#!/usr/bin/env python3
"""Run R8 novel visibility and playback-control materials against candidate ARM64."""
import argparse
import json
from pathlib import Path

from arm64 import release_version, require
from test_control_glass166 import send
from test_controls171 import call
from test_drama_visibility178r7 import CONFIG, CONTEXT, Runtime as VisibilityRuntime
from test_feed_viewport import labels_for
from test_page_glass174 import EXTRA, make

ABOVE = "SSShortVideoAboveLeftContainerViewManager"
REASON = "SSShortVideoRcmdReasonViewManager"
REASON_VIEW = "SSShortVideoRcmdReasonView"
ENTRANCE = "FQCShortVideoDanmakuEntranceView"
DANMAKU = "SSShortVideoDanmakuLeftAboveView"
ASSETS = "FQCShortVideoDanmakuAsset"
PLAYER = "FQVShortVideoVPlayerControlView"
NOVEL_KEY = "FanqieX.DramaOriginalNovel.1"
DISABLED_KEY = "FanqieAdBlock.GlassDisabled.1"


class Runtime(VisibilityRuntime):
    HOST_VIEW = 0x33250030
    ASSET = 0x33250034

    def __init__(self, data):
        super().__init__(data)
        for name, parent in (
            (ABOVE, "NSObject"), (REASON, "NSObject"), (REASON_VIEW, "UIView"),
            (ENTRANCE, "UIView"), (DANMAKU, "UIView"), (ASSETS, "NSObject"), (PLAYER, "UIView"),
        ):
            self._class(name, parent)
        for cls, selector, encoding, implementation in (
            (ABOVE, "orderedAboveLeftViewsForCurrentState", "@16@0:8", self.HOST_VIEW),
            (ABOVE, "updateLayoutForContainerView", "v16@0:8", self.HOST_VIEW),
            (ENTRANCE, "layoutSubviews", "v16@0:8", self.LAYOUT_IMP),
            (ENTRANCE, "refreshIcon", "v16@0:8", self.HOST_VIEW),
            (PLAYER, "updateFullscreenBtnLayout", "v16@0:8", self.LAYOUT_IMP),
        ):
            self._add(self.classes[cls], selector, implementation, encoding)
        self._add(self.metaclasses[self.classes[ASSETS]], "imageNamed:", self.ASSET, "@24@0:8@16")
        self.assets = {f"fq_danmaku_entrance_v741_{state}": self.obj("UIImage", state) for state in ("on", "off")}

    def handle(self, cpu, pc):
        receiver, selector, argument = cpu.x[:3]
        name = self.selector_names.get(selector)
        if pc == self.ASSET:
            return self.finish(cpu, self.assets.get(self.string_value(argument), 0))
        if pc == self.HOST_VIEW:
            state = self.objects[receiver].state
            if name == "refreshIcon":
                self.objects[state["iconView"]].state["image"] = state["legacyImage"]
            elif name == "updateLayoutForContainerView":
                state["layoutUpdates"] = state.get("layoutUpdates", 0) + 1
            return self.finish(cpu, state.get(name, 0))
        if pc - self.slide == 0xa5d4 and receiver in self.objects:
            state = self.objects[receiver].state
            if name in ("rcmdReasonViewManager", "isRelateNovelReason", "decorationView", "danmakuEntranceView",
                        "combinedStyle", "capsuleView", "toggleButton", "iconView", "usesOverseaDanmaku",
                        "danmakuEnabled", "image", "contentMode", "fullscreenBtn") and name in state:
                return self.finish(cpu, int(state[name]))
            if name in ("setImage:", "setContentMode:") and "image" in state:
                state["image" if name == "setImage:" else "contentMode"] = argument
                return self.finish(cpu)
        return super().handle(cpu, pc)


def exercise(data, labels):
    cpu, rt = make(data, Runtime)
    rt.labels = labels
    call(cpu, labels, "LFQH_FQHPageInstall")
    prefs = rt.objects[rt.DEFAULTS].state["values"]
    config = rt.obj(CONFIG, "root feed", feedType=4)
    context = rt.obj(CONTEXT, "root context", config=config)
    novel = rt.view(REASON_VIEW, "read original")
    next_button = rt.view(REASON_VIEW, "unrelated recommend reason")
    reason = rt.obj(REASON, "novel app reason", isRelateNovelReason=True, decorationView=novel)
    order = rt.obj("NSArray", "host order", items=[novel, next_button])
    manager = rt.obj(ABOVE, "above-left owner", vcContext=context,
                     rcmdReasonViewManager=reason, orderedAboveLeftViewsForCurrentState=order)

    def ordered_views():
        result = send(cpu, rt, manager, "orderedAboveLeftViewsForCurrentState")["result"]
        return rt.objects[result].state["items"]

    require(ordered_views() == [novel, next_button], "Original-novel CTA is visible by default")
    settings = rt.obj("NSObject", "settings controller")
    switch = rt.view("UISwitch", "show original novel", tag=24, isOn=False)
    callback = rt.sel("fqx178_bottomOptionChanged:")
    call(cpu, labels, "LFQH_FQHBottomOptionChanged178", settings, callback, switch)
    require(prefs.get(NOVEL_KEY) is False and rt.objects[manager].state["layoutUpdates"] == 1,
            "The real setting stores the preference and refreshes the above-left layout")
    require(ordered_views() == [next_button] and rt.objects[order].state["items"] == [novel, next_button],
            "Only the original-novel identity is removed and the native list stays read-only")
    rt.objects[reason].state["isRelateNovelReason"] = False
    require(ordered_views() == [novel, next_button], "An unrelated recommendation is untouched")
    rt.objects[reason].state["isRelateNovelReason"] = True
    rt.objects[config].state["feedType"] = 5
    require(ordered_views() == [novel, next_button], "Original-novel CTA in another feed is untouched")
    rt.objects[config].state["feedType"] = 4
    rt.objects[switch].state["isOn"] = True
    call(cpu, labels, "LFQH_FQHBottomOptionChanged178", settings, callback, switch)
    require(ordered_views() == [novel, next_button], "Re-enabling restores the unmodified host CTA")

    shade = rt.color("stock dark pill")
    clear = rt.color("clearColor")
    outer = rt.view(DANMAKU, "above-left bullet comments")
    entrance = rt.view(ENTRANCE, "native entrance", (0., 0., 74., 32.), outer,
                       combinedStyle=False, danmakuEnabled=False, usesOverseaDanmaku=False)
    rt.objects[outer].state["danmakuEntranceView"] = entrance
    capsule = rt.view("UIView", "native publish capsule", (0., 0., 74., 32.), entrance, backgroundColor=shade)
    toggle = rt.view("UIButton", "native toggle target", (0., 0., 32., 32.), entrance,
                     backgroundColor=shade, originalAction="toggle")
    publish = rt.view("UIButton", "native publish target", (32., 0., 42., 32.), entrance,
                      originalAction="publish")
    legacy = rt.obj("UIImage", "legacy backed toggle")
    icon = rt.view("UIImageView", "native switch glyph", (0., 0., 32., 32.), toggle, image=legacy, contentMode=0)
    rt.objects[entrance].state.update(capsuleView=capsule, toggleButton=toggle, iconView=icon, legacyImage=legacy)

    def material(view):
        for child in rt.objects[view].state["subviews"]:
            states = rt.objects[child].state
            if states.get("configuration"):
                return child
        return None

    def check_material(view, expected):
        glass = material(view)
        require(glass is not None, "Visible host pill receives one glass backing")
        state = rt.objects[glass].state
        require(state["frame"] == expected and not state["userInteractionEnabled"],
                "Glass covers the exact native bounds and does not intercept touches")
        require(rt.objects[view].state["backgroundColor"] == clear and state["overrideUserInterfaceStyle"] == 2,
                "The original paint gives way to dark-page glass")
        require(rt.objects[state["configuration"]].state["style"] == "glass",
                "All new controls use the common regular glass configuration")
        return glass

    send(cpu, rt, entrance, "layoutSubviews")
    glass = check_material(toggle, (0., 0., 32., 32.))
    require(material(capsule) is None and rt.objects[icon].state["image"] == rt.assets["fq_danmaku_entrance_v741_off"],
            "Standalone toggle uses the exact translucent off glyph")
    rt.objects[entrance].state["danmakuEnabled"] = True
    send(cpu, rt, entrance, "refreshIcon")
    require(rt.objects[icon].state["image"] == rt.assets["fq_danmaku_entrance_v741_on"] and
            rt.objects[icon].state["contentMode"] == 4, "Toggle state preserves the native on glyph and size")
    send(cpu, rt, entrance, "layoutSubviews")
    require(material(toggle) == glass, "Repeated layout reuses one glass backing")
    rt.objects[entrance].state["combinedStyle"] = True
    send(cpu, rt, entrance, "layoutSubviews")
    check_material(capsule, (0., 0., 74., 32.))
    require(material(toggle) is None and rt.objects[icon].state["image"] == legacy and
            rt.objects[icon].state["contentMode"] == 0, "Switching to publish restores the native combined artwork")
    require(rt.objects[toggle].state["originalAction"] == "toggle" and
            rt.objects[publish].state["originalAction"] == "publish", "Both native targets stay intact")

    player = rt.view(PLAYER, "portrait drama player", (0., 0., 440., 876.))
    fullscreen = rt.view("UIButton", "fullscreen target", (176., 620., 88., 28.), player,
                         backgroundColor=shade, originalAction="fullscreen")
    rt.objects[player].state["fullscreenBtn"] = fullscreen
    send(cpu, rt, player, "updateFullscreenBtnLayout")
    check_material(fullscreen, (0., 0., 88., 28.))
    require(rt.objects[fullscreen].state["frame"] == (176., 620., 88., 28.) and
            rt.objects[fullscreen].state["originalAction"] == "fullscreen", "Fullscreen geometry and action stay native")
    prefs[DISABLED_KEY] = True
    send(cpu, rt, player, "updateFullscreenBtnLayout")
    send(cpu, rt, entrance, "layoutSubviews")
    require(material(fullscreen) is None and material(capsule) is None and
            rt.objects[fullscreen].state["backgroundColor"] == shade and
            rt.objects[capsule].state["backgroundColor"] == shade, "Disabling glass restores native paint")

    return {"novel_toggle": True, "native_tap_targets": True, "standalone_danmaku_states": 2,
            "publish_and_fullscreen_glass": True, "restored_native_paint": True}


def main():
    parser = argparse.ArgumentParser(description=__doc__)
    parser.add_argument("candidate", type=Path)
    parser.add_argument("--report", type=Path, required=True)
    args = parser.parse_args()
    data = args.candidate.read_bytes()
    require(release_version(data) == "1.78R8", "Use the 1.78R8 candidate")
    labels = labels_for(data, args.candidate.with_suffix(".composed.s"),
                        EXTRA + ["LFQH_FQHBottomOptionChanged178"])
    report = {"passed": True, **exercise(data, labels), "device_tested": False}
    args.report.write_text(json.dumps(report, indent=2) + "\n", encoding="utf-8")
    print(json.dumps(report, indent=2))


if __name__ == "__main__":
    main()
