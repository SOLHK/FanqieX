#!/usr/bin/env python3
"""Run novel visibility and playback-control materials against candidate ARM64."""
import argparse
import json
from pathlib import Path
import struct

from arm64 import release_version, require
from test_control_glass166 import send
from test_controls171 import call
from test_drama_visibility178r7 import CONFIG, CONTEXT, Runtime as VisibilityRuntime
from test_feed_viewport import labels_for
from test_page_glass174 import EXTRA, make

ABOVE = "SSShortVideoAboveLeftContainerViewManager"
REASON = "SSShortVideoRcmdReasonViewManager"
REASON_VIEW = "SSShortVideoRcmdReasonView"
REASON_MODEL = "SSShortVideoRcmdReasonModel"
ENTRANCE = "FQCShortVideoDanmakuEntranceView"
DANMAKU = "SSShortVideoDanmakuLeftAboveView"
ASSETS = "FQCShortVideoDanmakuAsset"
PLAYER = "FQVShortVideoVPlayerControlView"
NOVEL_KEY = "FanqieX.DramaOriginalNovel.1"
DISABLED_KEY = "FanqieAdBlock.GlassDisabled.1"


class Runtime(VisibilityRuntime):
    HOST_VIEW = 0x3325003C
    ASSET = 0x33250034

    def __init__(self, data):
        super().__init__(data)
        self.novel_restyles = struct.unpack_from("<I", data, 0x818)[0] >= 0x14e19
        for name, parent in (
            (ABOVE, "NSObject"), (REASON, "NSObject"), (REASON_VIEW, "UIView"), (REASON_MODEL, "NSObject"),
            (ENTRANCE, "UIView"), (DANMAKU, "UIView"), (ASSETS, "NSObject"), (PLAYER, "UIView"),
        ):
            self._class(name, parent)
        for cls, selector, encoding, implementation in (
            (ABOVE, "orderedAboveLeftViewsForCurrentState", "@16@0:8", self.HOST_VIEW),
            (ABOVE, "updateLayoutForContainerView", "v16@0:8", self.HOST_VIEW),
            (REASON_VIEW, "dataModel", "@16@0:8", self.HOST_VIEW),
            (REASON_VIEW, "gradientBackgroundView", "@16@0:8", self.HOST_VIEW),
            (REASON_VIEW, "layoutSubviews", "v16@0:8", self.LAYOUT_IMP),
            (REASON_VIEW, "setDataModel:", "v24@0:8@16", self.HOST_VIEW),
            (REASON_VIEW, "modelDidUpdate", "v16@0:8", self.HOST_VIEW),
            (REASON_MODEL, "recType", "i16@0:8", self.HOST_VIEW),
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
            elif name == "setDataModel:":
                state["dataModel"] = argument
                if self.novel_restyles:
                    # The host's setDataModel: invokes this method after assigning the new model.
                    update = self.sel("modelDidUpdate")
                    method = self.get_method(self.classes[REASON_VIEW], update)
                    cpu.x[1] = update
                    cpu.pc = self.methods[method]["imp"]
                    return True
                state["backgroundColor"] = self.objects[argument].state["backgroundColor"]
            elif name == "modelDidUpdate":
                state["backgroundColor"] = self.objects[state["dataModel"]].state["backgroundColor"]
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


def exercise(data, labels, novel_glass):
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
    centered_danmaku = release_version(data) in ("1.78R24", "1.78R25", "1.78R26", "1.78R27", "1.78R28", "1.78R29", "1.78R30", "1.78R31", "1.78R32", "1.78R33", "1.78R34", "1.78R35", "1.78R36", "1.79R1", "1.79R2", "1.79R3", "1.79R4", "1.79R5", "1.8R1", "1.8R2")
    icon_stock = (1., 3., 24., 24.) if centered_danmaku else (0., 0., 32., 32.)
    icon = rt.view("UIImageView", "native switch glyph", icon_stock, toggle, image=legacy, contentMode=0)
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

    if novel_glass:
        pill = rt.view(REASON_VIEW, "original novel CTA", (16., 612., 132., 28.), originalAction="read novel")
        gradient = rt.view("UIView", "native gradient", (0., 0., 132., 28.), pill)
        book_icon = rt.view("UIImageView", "native book icon", (8., 8., 12., 12.), pill)
        text = rt.view("UILabel", "native novel text", (24., 0., 84., 28.), pill)
        arrow = rt.view("UIImageView", "native CTA arrow", (116., 10., 8., 8.), pill)
        foreground = [book_icon, text, arrow]
        rt.objects[pill].state["gradientBackgroundView"] = gradient
        related_book = rt.obj(REASON_MODEL, "original novel model", recType=25, backgroundColor=shade)
        other_color = rt.color("recommendation paint")
        other_reason = rt.obj(REASON_MODEL, "other recommendation", recType=21, backgroundColor=other_color)
        send(cpu, rt, pill, "setDataModel:", related_book)
        glass = check_material(pill, (0., 0., 132., 28.))
        require(rt.objects[gradient].state["hidden"] and rt.objects[pill].state["subviews"] == [glass, gradient, *foreground],
                "Only the stock gradient is hidden and native foreground stays above glass")
        if rt.novel_restyles:
            adapted_color = rt.color("adaptive native pill paint")
            rt.objects[related_book].state["backgroundColor"] = adapted_color
            send(cpu, rt, pill, "modelDidUpdate")
            require(check_material(pill, (0., 0., 132., 28.)) == glass and
                    rt.objects[gradient].state["hidden"] and
                    all(not rt.objects[view].state["hidden"] for view in foreground) and
                    rt.objects[pill].state["originalAction"] == "read novel",
                    "A native restyle clears the background corners before layout, retaining the same glass and click target")
        else:
            adapted_color = shade
        rt.objects[pill].state["bounds"] = (0., 0., 154., 28.)
        send(cpu, rt, pill, "layoutSubviews")
        require(check_material(pill, (0., 0., 154., 28.)) == glass,
                "Resizing the existing CTA updates its one glass backing")
        send(cpu, rt, pill, "setDataModel:", other_reason)
        require(material(pill) is None and not rt.objects[gradient].state["hidden"] and
                rt.objects[pill].state["backgroundColor"] == other_color and
                rt.objects[pill].state["originalAction"] == "read novel",
                "A recycled recommendation restores its own paint and retains the native tap handler")
        send(cpu, rt, pill, "setDataModel:", related_book)
        prefs[DISABLED_KEY] = True
        send(cpu, rt, pill, "layoutSubviews")
        require(material(pill) is None and not rt.objects[gradient].state["hidden"] and
                rt.objects[pill].state["backgroundColor"] == adapted_color,
                "Disabling glass restores the latest original-novel CTA paint")
        del prefs[DISABLED_KEY]

    send(cpu, rt, entrance, "layoutSubviews")
    glass = check_material(toggle, (0., 0., 32., 32.))
    require(material(capsule) is None and rt.objects[icon].state["image"] == rt.assets["fq_danmaku_entrance_v741_off"],
            "Standalone toggle uses the exact translucent off glyph")
    if centered_danmaku:
        require(rt.objects[icon].state["frame"] == (4., 4., 24., 24.) and
                rt.objects[toggle].state["frame"] == (0., 0., 32., 32.),
                "The standalone glyph is centered without changing its artwork size or tap target")
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
            rt.objects[icon].state["contentMode"] == 0 and rt.objects[icon].state["frame"] == icon_stock,
            "Switching to publish restores the native combined artwork and placement")
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
            "publish_and_fullscreen_glass": True, "restored_native_paint": True,
            **({"original_novel_glass": True} if novel_glass else {}),
            **({"cleared_background_after_native_restyle": True} if rt.novel_restyles else {})}


def main():
    parser = argparse.ArgumentParser(description=__doc__)
    parser.add_argument("candidate", type=Path)
    parser.add_argument("--report", type=Path, required=True)
    args = parser.parse_args()
    data = args.candidate.read_bytes()
    version = release_version(data)
    require(version in ("1.78R8", "1.78R9", "1.78R10", "1.78R11", "1.78R12", "1.78R13", "1.78R14", "1.78R15", "1.78R16", "1.78R17", "1.78R25", "1.78R26", "1.78R27", "1.78R28", "1.78R29", "1.78R30", "1.78R31", "1.78R32", "1.78R33", "1.78R34", "1.78R35", "1.78R36", "1.79R1", "1.79R2", "1.79R3", "1.79R4", "1.79R5", "1.8R1", "1.8R2"),
            "Use a supported FanqieX candidate")
    labels = labels_for(data, args.candidate.with_suffix(".composed.s"),
                        EXTRA + ["LFQH_FQHBottomOptionChanged178"])
    report = {"passed": True, **exercise(data, labels, version in ("1.78R17", "1.78R25", "1.78R26", "1.78R27", "1.78R28", "1.78R29", "1.78R30", "1.78R31", "1.78R32", "1.78R33", "1.78R34", "1.78R35", "1.78R36", "1.79R1", "1.79R2", "1.79R3", "1.79R4", "1.79R5", "1.8R1", "1.8R2")), "device_tested": False}
    args.report.write_text(json.dumps(report, indent=2) + "\n", encoding="utf-8")
    print(json.dumps(report, indent=2))


if __name__ == "__main__":
    main()
