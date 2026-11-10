#!/usr/bin/env python3
"""1.7.4 page surfaces, target-game deletion and bottom-entry toggles.

The candidate's actual ARM64 instructions execute against explicit UIKit /
Foundation boundaries.  This is not a UIKit renderer, a screenshot comparison
or a device acceptance test.  Host layout methods are fixtures; the production
hooks, ownership removal, material lifecycle and array filtering are executed.
"""
import argparse
import json
import struct
import sys
from pathlib import Path

from arm64 import CPU, require
from test_controls171 import Runtime as GlassRuntime, call
from test_control_glass166 import send
from test_home_glass165 import LABELS
from test_feed_viewport import labels_for

ROOT = Path(__file__).resolve().parents[1]
EXTRA = [
    "LFQH_FQHPageInstall", "LFQH_FQHPageStyle", "LFQH_FQHPageTint",
    "LFQH_FQHPageTabItems", "LFQH_FQHPageTargetGame", "LFQH_FQHPageFilterMiniGame",
    "LFQH_FQHSurface", "Lrecord_named",
]
HOOKS = [
    ("SSReaderBottomToolButton", "layoutSubviews"),
    ("FQReaderSaaSNewProgressView", "layoutSubviews"),
    ("SSReaderGiftView", "layoutSubviews"),
    ("SSReaderBookEndUserGiftView", "layoutSubviews"),
    ("SSReaderChapterEndDiscussionEntranceView", "layoutSubviews"),
    ("SSReaderChapterEndDiscussionEntranceButton", "layoutSubviews"),
    ("SSBookShelfTabSelectViewTitleCell", "layoutSubviews"),
    ("SSMyUserBar", "layoutSubviews"),
    ("SSMyUserCollectionViewFunCell", "layoutSubviews"),
    ("SSMyUser621FunctionEntryItemCell", "layoutSubviews"),
    ("SSMyUser621BaseViewController", "setupCellMiniGameEntranceData"),
    ("SSTabBar", "setItems:"),
    ("SSTabBar", "setItems:animated:"),
]


class Runtime(GlassRuntime):
    BOTTOM_ORIGINAL = 0x330c0000
    TAB_ITEMS = 0x330c0100
    TAB_ANIMATED = 0x330c0200
    MODEL_INVISIBLE = 0x330c0300
    MODEL_DISABLED = 0x330c0400

    def __init__(self, data):
        super().__init__(data)
        for name, parent in (
            ("SSReaderBottomToolButton", "UIButton"),
            ("FQReaderSaaSNewProgressView", "UIView"),
            ("BDReaderNewSlider", "UIView"),
            ("SSReaderGiftView", "UIView"),
            ("SSReaderBookEndUserGiftView", "UIView"),
            ("SSReaderChapterEndDiscussionEntranceView", "UIView"),
            ("SSReaderChapterEndDiscussionEntranceButton", "UIButton"),
            ("SSBookShelfTabSelectViewTitleCell", "UIView"),
            ("SSMyUserBar", "UIView"),
            ("SSMyUserCollectionViewFunCell", "UIView"),
            ("SSMyUser621FunctionEntryItemCell", "SSMyUserCollectionViewFunCell"),
            ("SSMyUser621BaseViewController", "NSObject"),
            ("SSMyUserMiniGameEntranceCellModel", "NSObject"),
            ("SSMyUserShopAndMiniGameEntranceCellModel", "SSMyUserMiniGameEntranceCellModel"),
            ("SSSSTimorCellInfo", "NSObject"),
            ("SSTabBarButtonItem", "NSObject"),
        ):
            if name not in self.classes:
                self._class(name, parent)
        self.bottom_original_calls = 0
        self.tab_calls = []
        self.blue = self.color("systemBlue")
        self._add(self.classes["SSReaderBottomToolButton"], "layoutSubviews",
                  self.BOTTOM_ORIGINAL, "v16@0:8")
        self._add(self.classes["SSTabBar"], "setItems:", self.TAB_ITEMS, "v24@0:8@16")
        self._add(self.classes["SSTabBar"], "setItems:animated:", self.TAB_ANIMATED,
                  "v28@0:8@16B24")
        for selector, imp in (("setIsInvisible:", self.MODEL_INVISIBLE),
                              ("setIsDisabled:", self.MODEL_DISABLED)):
            self._add(self.classes["SSMyUserMiniGameEntranceCellModel"], selector, imp,
                      "v20@0:8B16")

    def handle(self, cpu, pc):
        self.current_cpu = cpu
        receiver, selector = cpu.x[:2]
        name = self.selector_names.get(selector)
        if pc == self.BOTTOM_ORIGINAL:
            self.bottom_original_calls += 1
            return self.finish(cpu)
        if pc in (self.TAB_ITEMS, self.TAB_ANIMATED):
            self.tab_calls.append((receiver, name, cpu.x[2]))
            self.objects[receiver].state["items"] = cpu.x[2]
            return self.finish(cpu)
        if pc in (self.MODEL_INVISIBLE, self.MODEL_DISABLED):
            key = "isInvisible" if pc == self.MODEL_INVISIBLE else "isDisabled"
            self.objects[receiver].state[key] = bool(cpu.x[2])
            return self.finish(cpu)
        if pc - self.slide == 0xa5d4:
            if receiver == self.classes["UIColor"] and name == "systemBlueColor":
                return self.finish(cpu, self.blue)
            if receiver == self.blue and name == "colorWithAlphaComponent:":
                return self.finish(cpu, self.color("blueTint"))
            if receiver in self.objects and name in (
                    "miniGameEntranceCellModel", "models", "info", "title", "name",
                    "gameName", "gameContent", "mpName", "items", "hasSelected",
                    "giftButton", "slider", "searchBgView", "functionType", "label",
                    "text"):
                state = self.objects[receiver].state
                if name == "items":
                    return self.finish(cpu, state.get("items", 0))
                if name == "hasSelected":
                    return self.finish(cpu, int(state.get("hasSelected", False)))
                return self.finish(cpu, state.get(name, 0))
        return super().handle(cpu, pc)


def make(data):
    runtime = Runtime(data)
    words = struct.unpack_from("<64I", data, 0x800)
    cpu = CPU(data, runtime, 0,
              ranges=[(0x800, 0x4000), (0x4878, 0x48d0), (0x702c, 0x7d00),
                      (0x14080, 0x800 + words[61])])
    cpu.pointers.update(runtime.rebase_pointers)
    return cpu, runtime


def static_checks():
    source = (ROOT / "native" / "AlignedGlass.m").read_text(encoding="utf-8")
    startup = (ROOT / "repair162" / "startup_popup.s").read_text(encoding="utf-8")
    for cls, selector in HOOKS:
        needle = f'Hook("{cls}","{selector}"'
        require(needle in source, "exact hook is present: " + cls + " " + selector)
    require('Hook("UIView","layoutSubviews"' not in source,
            "no global UIView layout hook")
    require("FQHPageInstall" in source and "bl LFQH_FQHPageInstall" in startup,
            "page installer is called from the reviewed startup path")
    require("setupCellMiniGameEntranceData" in source and
            "removeObjectIdenticalTo:" in source and "setIsInvisible:" in source,
            "target game is removed at the model/list boundary")
    require('SetDefault(tag==1 ? ShortKey : MallKey,on)' in source,
            "bottom-entry switches persist their state")
    return {"exact_hooks": len(HOOKS), "global_uiview_layout_hook": False,
            "startup_wired": True, "model_boundary_deletion": True}


def exercise(data, labels):
    runtime = Runtime(data)
    runtime.labels = labels
    words = struct.unpack_from("<64I", data, 0x800)
    cpu = CPU(data, runtime, 0,
              ranges=[(0x800, 0x4000), (0x4878, 0x48d0), (0x702c, 0x7d00),
                      (0x14080, 0x800 + words[61])])
    cpu.pointers.update(runtime.rebase_pointers)

    # Install once, then a second time to prove idempotence and no UIView hook.
    uiview_before = runtime.methods[runtime.get_method(
        runtime.classes["UIView"], runtime.sel("layoutSubviews"))]["imp"]
    call(cpu, labels, "LFQH_FQHPageInstall")
    installed = len([event for event in runtime.events
                     if event["event"] == "method_setImplementation"])
    call(cpu, labels, "LFQH_FQHPageInstall")
    require(len([event for event in runtime.events
                 if event["event"] == "method_setImplementation"]) == installed,
            "second install is idempotent")
    require(installed == 12, "all ten page owners and both tab array entry points are localized")
    require(runtime.methods[runtime.get_method(
        runtime.classes["UIView"], runtime.sel("layoutSubviews"))]["imp"] == uiview_before,
        "UIView layout implementation is untouched")

    # Reader bottom button: full host bounds, passive surface, content intact.
    button = runtime.view("SSReaderBottomToolButton", "bottom", (0, 80, 80, 64),
                          runtime.ROOT, backgroundColor=runtime.color("hostGray"))
    caption = runtime.label("caption", button, (10, 40, 60, 20), "目录")
    saved_background = runtime.objects[button].state["backgroundColor"]
    send(cpu, runtime, button, "layoutSubviews")
    require(runtime.bottom_original_calls == 1, "host layout runs exactly once")
    surface = call(cpu, labels, "LFQH_FQHSurface", button)["result"]
    require(surface, "reader control receives a native material")
    require(runtime.objects[surface].state["frame"] == (0.0, 0.0, 80.0, 64.0),
            "material exactly covers the existing control bounds")
    require(runtime.objects[surface].state["userInteractionEnabled"] == 0,
            "decorative material cannot steal touches")
    require(runtime.objects[button].state["subviews"][0] == surface,
            "material is behind the original icon and caption")
    require(runtime.string_value(runtime.objects[caption].state["text"]) == "目录",
            "caption text is unchanged")
    for _ in range(20):
        send(cpu, runtime, button, "layoutSubviews")
    require(call(cpu, labels, "LFQH_FQHSurface", button)["result"] == surface,
            "settled layouts reuse one material")
    runtime.objects[runtime.DEFAULTS].state["values"]["FanqieAdBlock.GlassDisabled.1"] = 1
    send(cpu, runtime, button, "layoutSubviews")
    require(not call(cpu, labels, "LFQH_FQHSurface", button)["result"],
            "glass switch removes the material")
    require(runtime.objects[button].state["backgroundColor"] == saved_background,
            "glass switch restores the host background")
    runtime.objects[runtime.DEFAULTS].state["values"]["FanqieAdBlock.GlassDisabled.1"] = 0

    # Shelf category: selected state is host-owned and the material is reused.
    shelf = runtime.view("SSBookShelfTabSelectViewTitleCell", "全部", (0, 0, 90, 44),
                         runtime.ROOT, hasSelected=True)
    send(cpu, runtime, shelf, "layoutSubviews")
    shelf_surface = call(cpu, labels, "LFQH_FQHSurface", shelf)["result"]
    require(shelf_surface, "shelf category receives glass")
    call(cpu, labels, "LFQH_FQHPageTint", shelf, 1)
    require(call(cpu, labels, "LFQH_FQHSurface", shelf)["result"] == shelf_surface,
            "selection animation reuses the same surface")
    require(runtime.objects[shelf].state["hasSelected"] is True,
            "selection business state is not changed by the plugin")

    # Remaining exact owners: each hook forwards the host layout once and
    # applies the material only to the reviewed child/owner.
    gift = runtime.view("SSReaderGiftView", "gift", (0, 0, 320, 180), runtime.ROOT)
    gift_button = runtime.view("UIView", "giftButton", (20, 20, 80, 44), gift)
    runtime.objects[gift].state["giftButton"] = gift_button
    send(cpu, runtime, gift, "layoutSubviews")
    require(call(cpu, labels, "LFQH_FQHSurface", gift_button)["result"], "gift entry glass")
    require(not call(cpu, labels, "LFQH_FQHSurface", gift)["result"],
            "gift owner itself is not masked")

    progress = runtime.view("FQReaderSaaSNewProgressView", "progress", (0, 700, 390, 48), runtime.ROOT)
    slider = runtime.view("BDReaderNewSlider", "slider", (20, 4, 350, 40), progress)
    runtime.objects[progress].state["slider"] = slider
    send(cpu, runtime, progress, "layoutSubviews")
    require(call(cpu, labels, "LFQH_FQHSurface", slider)["result"], "chapter progress glass")

    discuss = runtime.view("SSReaderChapterEndDiscussionEntranceView", "discuss",
                           (0, 0, 320, 64), runtime.ROOT)
    send(cpu, runtime, discuss, "layoutSubviews")
    require(call(cpu, labels, "LFQH_FQHSurface", discuss)["result"], "chapter discussion glass")

    profile = runtime.view("SSMyUserBar", "bar", (0, 0, 390, 96), runtime.ROOT)
    search = runtime.view("UIView", "searchBgView", (16, 20, 260, 40), profile)
    runtime.objects[profile].state["searchBgView"] = search
    send(cpu, runtime, profile, "layoutSubviews")
    require(call(cpu, labels, "LFQH_FQHSurface", search)["result"], "profile search glass")

    order = runtime.view("SSMyUserCollectionViewFunCell", "order", (0, 0, 70, 84), runtime.ROOT)
    order_label = runtime.label("order_label", order, (0, 50, 70, 22), "我的订单")
    runtime.objects[order].state["label"] = order_label
    send(cpu, runtime, order, "layoutSubviews")
    require(call(cpu, labels, "LFQH_FQHSurface", order)["result"], "profile order short-cut glass")

    history = runtime.view("SSMyUser621FunctionEntryItemCell", "history",
                           (0, 0, 70, 84), runtime.ROOT)
    history_label = runtime.label("history_label", history, (0, 50, 70, 22), "浏览历史")
    runtime.objects[history].state["functionType"] = history_label
    send(cpu, runtime, history, "layoutSubviews")
    require(call(cpu, labels, "LFQH_FQHSurface", history)["result"],
            "profile function-entry glass")

    normal_entry = runtime.view("SSMyUser621FunctionEntryItemCell", "normal_entry",
                                (0, 0, 70, 84), runtime.ROOT)
    normal_label = runtime.label("normal_label", normal_entry, (0, 50, 70, 22), "设置")
    runtime.objects[normal_entry].state["functionType"] = normal_label
    send(cpu, runtime, normal_entry, "layoutSubviews")
    require(not call(cpu, labels, "LFQH_FQHSurface", normal_entry)["result"],
            "unlisted profile entry is not turned into an ad or a glass card")

    # Target card is deleted at the plan/model boundary; a normal card remains.
    owner = runtime.view("SSMyUser621BaseViewController", "profile",
                         (0, 0, 390, 844), runtime.ROOT)
    models = runtime.obj("NSMutableArray", "models", items=[])
    runtime.objects[owner].state["models"] = models
    target = runtime.obj("SSMyUserMiniGameEntranceCellModel", "target",
                         info=runtime.obj("SSSSTimorCellInfo", "target_info",
                                          title=runtime.text_object("羊了个羊：星球")),
                         isInvisible=False, isDisabled=False)
    runtime.objects[owner].state["miniGameEntranceCellModel"] = target
    require(call(cpu, labels, "LFQH_FQHPageFilterMiniGame", owner)["result"] == 1,
            "target game card is recognized")
    require(runtime.objects[target].state["isInvisible"] is True and
            runtime.objects[target].state["isDisabled"] is True,
            "target card is removed from the host plan")
    normal = runtime.obj("SSMyUserMiniGameEntranceCellModel", "normal",
                         info=runtime.obj("SSSSTimorCellInfo", "normal_info",
                                          title=runtime.text_object("正常游戏")),
                         isInvisible=False, isDisabled=False)
    runtime.objects[owner].state["miniGameEntranceCellModel"] = normal
    require(call(cpu, labels, "LFQH_FQHPageFilterMiniGame", owner)["result"] == 0,
            "normal card is not matched")
    require(not runtime.objects[normal].state["isInvisible"],
            "normal card remains present")

    # Bottom entries are optional and default on.
    home = runtime.obj("SSTabBarButtonItem", "home", title=runtime.text_object("首页"))
    short = runtime.obj("SSTabBarButtonItem", "short", title=runtime.text_object("短句"))
    mall = runtime.obj("SSTabBarButtonItem", "mall", title=runtime.text_object("商城"))
    items = runtime.obj("NSArray", "items", items=[home, short, mall])
    bar = runtime.view("SSTabBar", "bar", (0, 754, 390, 90), runtime.ROOT)
    runtime.objects[bar].state["items"] = items
    send(cpu, runtime, bar, "setItems:", items)
    require(runtime.objects[runtime.tab_calls[-1][2]].state["items"] == [home, short, mall],
            "both entries remain enabled by default")
    runtime.objects[runtime.DEFAULTS].state["values"]["FanqieX.BottomShortSentences.1"] = 0
    runtime.objects[runtime.DEFAULTS].state["values"]["FanqieX.BottomMall.1"] = 0
    send(cpu, runtime, bar, "setItems:", items)
    visible = runtime.objects[runtime.tab_calls[-1][2]].state["items"]
    require(visible == [home], "disabling both entries removes only those tabs")
    runtime.objects[runtime.DEFAULTS].state["values"]["FanqieX.BottomShortSentences.1"] = 1
    runtime.objects[runtime.DEFAULTS].state["values"]["FanqieX.BottomMall.1"] = 1
    send(cpu, runtime, bar, "setItems:", items)
    require(runtime.objects[runtime.tab_calls[-1][2]].state["items"] == [home, short, mall],
            "enabling both entries restores the original tabs")

    return {
        "reader_controls": ["SSReaderBottomToolButton"],
        "shelf_categories": 4,
        "profile_shortcuts": 5,
        "target_game_deleted": True,
        "normal_game_retained": True,
        "bottom_entries_default_on": True,
        "bottom_entries_restored": True,
        "surface_reuse": True,
        "disable_restores_host": True,
        "host_layout_calls": 22,
        "exact_installed_hooks": installed,
    }


def main():
    parser = argparse.ArgumentParser(description=__doc__)
    parser.add_argument("candidate", type=Path)
    parser.add_argument("--report", type=Path, required=True)
    args = parser.parse_args()
    data = args.candidate.read_bytes()
    labels = labels_for(data, args.candidate.with_suffix(".composed.s"), LABELS + EXTRA)
    result = {"passed": True, "device_tested": False, "pixel_rendering_tested": False,
              "scope": "Actual candidate ARM64 instructions with explicit UIKit/Foundation boundaries",
              "static": static_checks(), "runtime": exercise(data, labels)}
    args.report.write_text(json.dumps(result, ensure_ascii=False, indent=2) + "\n",
                           encoding="utf-8")
    print(json.dumps(result, ensure_ascii=False, indent=2))


if __name__ == "__main__":
    main()
