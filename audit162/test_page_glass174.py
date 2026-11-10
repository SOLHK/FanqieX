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
    "LFQH_FQHSurface", "Lrecord_named", "LGstyle_control",
]
HOOKS = [
    ("FQReaderSaaSBottomToolView", "layoutSubviews"),
    ("FQReaderSaaSNewProgressView", "layoutSubviews"),
    ("SSReaderBottomToolDivertView", "layoutSubviews"),
    ("SSReaderGiftView", "layoutSubviews"),
    ("SSReaderBookEndUserGiftView", "layoutSubviews"),
    ("SSReaderChapterEndDiscussionEntranceView", "layoutSubviews"),
    ("SSReaderChapterEndDiscussionEntranceButton", "layoutSubviews"),
    ("SSBookShelfTabSelectViewTitleCell", "layoutSubviews"),
    ("SSBookShelfTabSelectViewTitleCell", "reloadData:"),
    ("SSBookShelfFilter541Cell", "layoutSubviews"),
    ("SSBookShelfFilter541Cell", "updateAppearance:"),
    ("SSBookShelfFilter541Cell", "updateCellBgColor:"),
    ("SSMyUserBar", "layoutSubviews"),
    ("SSMyUserCollectionViewFunCell", "layoutSubviews"),
    ("SSMyUser621FunctionEntryItemCell", "layoutSubviews"),
    ("SSMyUser621BaseViewController", "setupCellMiniGameEntranceData"),
    ("SSTabBar", "setItems:"),
    ("SSTabBar", "setItems:animated:"),
]


class Runtime(GlassRuntime):
    SHELF_RELOAD = 0x330c1000
    SHELF_APPEARANCE = 0x330c1100
    SHELF_BACKGROUND = 0x330c1200
    BOTTOM_ORIGINAL = 0x330c0000
    TAB_ITEMS = 0x330c0100
    TAB_ANIMATED = 0x330c0200
    MODEL_INVISIBLE = 0x330c0300
    MODEL_DISABLED = 0x330c0400
    MODEL_REMOVE = 0x330c0500
    MODEL_SETUP = 0x330c0600
    SPEECH_THEME = 0x330c0700

    def __init__(self, data):
        super().__init__(data)
        for name, parent in (
            ("FQReaderSaaSBottomToolView", "UIView"),
            ("FQReaderSaaSBottomToolItemView", "UIView"),
            ("FQReaderSaaSReaderSpeechButton", "UIView"),
            ("BDNovelNewAssetsGenerated", "NSObject"),
            ("FQReaderSaaSNewProgressView", "UIView"),
            ("SSReaderBottomToolDivertView", "UIView"),
            ("BDReaderNewSlider", "UIView"),
            ("SSReaderGiftView", "UIView"),
            ("SSReaderBookEndUserGiftView", "UIView"),
            ("SSReaderChapterEndDiscussionEntranceView", "UIView"),
            ("SSReaderChapterEndDiscussionEntranceButton", "UIButton"),
            ("SSBookShelfTabSelectViewTitleCell", "UIView"),
            ("SSBookShelfTabSelectViewTitleCellModel", "NSObject"),
            ("SSBookShelfFilterHeaderView", "UIView"),
            ("SSBookShelfFilterMixRowCollectionView", "UIView"),
            ("SSBookShelfFilter541Cell", "UIView"),
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
        self.colors["systemOrangeColor"] = self.color("systemOrangeColor")
        for cls, selector, imp, encoding in (
                ("SSBookShelfTabSelectViewTitleCell", "reloadData:",
                 self.SHELF_RELOAD, "v24@0:8@16"),
                ("SSBookShelfFilter541Cell", "updateAppearance:",
                 self.SHELF_APPEARANCE, "v20@0:8B16"),
                ("SSBookShelfFilter541Cell", "updateCellBgColor:",
                 self.SHELF_BACKGROUND, "v24@0:8@16")):
            self._add(self.classes[cls], selector, imp, encoding)
        self._add(self.classes["FQReaderSaaSBottomToolView"], "layoutSubviews",
                  self.BOTTOM_ORIGINAL, "v16@0:8")
        self._add(self.classes["FQReaderSaaSReaderSpeechButton"],
                  "readerInsertedViewBackgroundConfigChange:", self.SPEECH_THEME, "v24@0:8@16")
        self.speech_artwork = self.obj("UIImage", "transparent speech glyph")
        self.speech_template = self.obj("UIImage", "template speech glyph")
        self._add(self.classes["SSTabBar"], "setItems:", self.TAB_ITEMS, "v24@0:8@16")
        self._add(self.classes["SSTabBar"], "setItems:animated:", self.TAB_ANIMATED,
                  "v28@0:8@16B24")
        for selector, imp in (("setIsInvisible:", self.MODEL_INVISIBLE),
                              ("setIsDisabled:", self.MODEL_DISABLED)):
            self._add(self.classes["SSMyUserMiniGameEntranceCellModel"], selector, imp,
                      "v20@0:8B16")
        self._add(self.classes["NSMutableArray"], "removeObjectIdenticalTo:",
                  self.MODEL_REMOVE, "v24@0:8@16")
        self._add(self.classes["SSMyUser621BaseViewController"], "setupCellMiniGameEntranceData",
                  self.MODEL_SETUP, "v16@0:8")

    def handle(self, cpu, pc):
        self.current_cpu = cpu
        receiver, selector = cpu.x[:2]
        name = self.selector_names.get(selector)
        if pc == self.SHELF_RELOAD:
            self.objects[receiver].state["cellModel"] = cpu.x[2]
            return self.finish(cpu)
        if pc == self.SHELF_APPEARANCE:
            self.objects[receiver].state["backgroundColor"] = self.color("hostSelection")
            return self.finish(cpu)
        if pc == self.SHELF_BACKGROUND:
            self.objects[receiver].state["backgroundColor"] = cpu.x[2]
            return self.finish(cpu)
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
        if pc == self.MODEL_SETUP:
            state = self.objects[receiver].state
            self.objects[state["models"]].state["items"].append(state["miniGameEntranceCellModel"])
            return self.finish(cpu)
        if pc == self.SPEECH_THEME:
            button = self.objects[receiver].state["speechBtn"]
            self.objects[button].state["images"][0] = cpu.x[2]
            return self.finish(cpu)
        if pc - self.slide == 0xa5d4:
            if receiver == self.classes["BDNovelNewAssetsGenerated"]:
                if name == "respondsToSelector:":
                    return self.finish(cpu, int(cpu.x[2] == self.sel("bdn_novelReaderListenButton")))
                if name == "bdn_novelReaderListenButton":
                    return self.finish(cpu, self.speech_artwork)
            if receiver == self.speech_artwork and name == "imageWithRenderingMode:":
                require(cpu.x[2] == 2, "listen glyph uses UIKit template rendering")
                return self.finish(cpu, self.speech_template)
            if receiver in self.objects and name == "setImage:forState:":
                self.objects[receiver].state["images"][cpu.x[3]] = cpu.x[2]
                return self.finish(cpu)
            if receiver in self.objects and name == "setTintColor:":
                self.objects[receiver].state["tintColor"] = cpu.x[2]
                return self.finish(cpu)
            if receiver in self.objects and name in (
                    "chapterView", "darkModeView", "setttingView", "itemViews", "item",
                    "speechBtn", "tintColor", "titleLabel"):
                return self.finish(cpu, self.objects[receiver].state.get(name, 0))
            if name == "removeObjectIdenticalTo:":
                items = self.objects[receiver].state["items"]
                items[:] = [item for item in items if item != cpu.x[2]]
                return self.finish(cpu)
            if name == "colorWithAlphaComponent:" and cpu.fp(0) == 0.125:
                if receiver == self.colors["labelColor"]:
                    return self.finish(cpu, self.color("shelfNeutralTint"))
                if receiver == self.colors["systemOrangeColor"]:
                    return self.finish(cpu, self.color("shelfWarmTint"))
            if receiver in self.objects and name in ("cellModel", "cellSpacing", "isSelect", "isSelected"):
                state = self.objects[receiver].state
                if name in state:
                    if name == "cellSpacing":
                        return self.finish(cpu, fp=(state[name],))
                    return self.finish(cpu, int(state[name]))
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
    installed_hooks = {(runtime.class_names[event["self"]], event["selector"])
                       for event in runtime.events if event["event"] == "method_setImplementation"}
    installed = len(installed_hooks)
    call(cpu, labels, "LFQH_FQHPageInstall")
    require(len([event for event in runtime.events
                 if event["event"] == "method_setImplementation"]) == installed,
            "second install is idempotent")
    require(installed_hooks == set(HOOKS), "all reviewed hook selectors are localized to their owners")
    require(runtime.methods[runtime.get_method(
        runtime.classes["UIView"], runtime.sel("layoutSubviews"))]["imp"] == uiview_before,
        "UIView layout implementation is untouched")

    # Real toolbar owner lays out the item views. No hook on their inherited layout.
    toolbar = runtime.view("FQReaderSaaSBottomToolView", "toolbar", (0, 80, 400, 56), runtime.ROOT)
    saved_background = runtime.color("hostGray")
    items = []
    captions = []
    for index, title in enumerate(("目录", "白天", "设置", "进度")):
        model = runtime.obj("NSObject", "toolbar item", title=runtime.text_object(title))
        button = runtime.view("FQReaderSaaSBottomToolItemView", "tool", (index * 80, 0, 80, 56),
                              toolbar, backgroundColor=saved_background, item=model)
        captions.append(runtime.label("caption", button, (10, 34, 60, 18), title))
        items.append(button)
    runtime.objects[toolbar].state.update(
        chapterView=items[0], darkModeView=items[1], setttingView=items[2],
        itemViews=runtime.obj("NSArray", "toolbar items", items=items))
    nested_button = runtime.view("UIButton", "original click target", (24, 4, 32, 28), items[0])
    require(not call(cpu, labels, "LGstyle_control", nested_button, 0)["result"],
            "legacy walker skips the nested button even before the item material is created")
    # The host attaches the adaptation extra view to the toolbar separately.
    divert = runtime.view("SSReaderBottomToolDivertView", "adaptations", (320, 0, 80, 56),
                          toolbar, backgroundColor=saved_background)
    divert_caption = runtime.label("adaptations caption", divert, (10, 34, 60, 18), "改编剧场")
    runtime.objects[divert].state["titleLabel"] = divert_caption
    send(cpu, runtime, toolbar, "layoutSubviews")
    send(cpu, runtime, divert, "layoutSubviews")
    require(runtime.bottom_original_calls == 1, "host layout runs exactly once")
    styled_items = [*items[:3], divert]
    surfaces = [call(cpu, labels, "LFQH_FQHSurface", item)["result"] for item in styled_items]
    require(all(surfaces) and not call(cpu, labels, "LFQH_FQHSurface", items[3])["result"],
            "only the four requested tools get glass")
    for item, caption, surface in zip(styled_items, [*captions[:3], divert_caption], surfaces):
        require(runtime.objects[surface].state["frame"] == (6.0, 4.0, 68.0, 48.0),
                "tools share an inset material without resizing the host")
        require(runtime.objects[surface].state["userInteractionEnabled"] == 0,
                "decorative material cannot steal touches")
        require(runtime.objects[item].state["subviews"][:2] == [surface, caption],
                "material is behind the original content")
    for _ in range(20):
        send(cpu, runtime, toolbar, "layoutSubviews")
    require(call(cpu, labels, "LFQH_FQHSurface", items[0])["result"] == surfaces[0],
            "settled layouts reuse one material")
    runtime.objects[runtime.DEFAULTS].state["values"]["FanqieAdBlock.GlassDisabled.1"] = 1
    send(cpu, runtime, toolbar, "layoutSubviews")
    send(cpu, runtime, divert, "layoutSubviews")
    for item in styled_items:
        require(not call(cpu, labels, "LFQH_FQHSurface", item)["result"],
                "glass switch removes the material")
        require(runtime.objects[item].state["backgroundColor"] == saved_background,
                "glass switch restores the host background")
    runtime.objects[runtime.DEFAULTS].state["values"]["FanqieAdBlock.GlassDisabled.1"] = 0

    # Shelf tabs use the live model and consistent capsules across title zoom.
    def surface_for(view):
        return call(cpu, labels, "LFQH_FQHSurface", view)["result"]

    def tint_for(surface):
        effect = runtime.objects[surface].state["effect"]
        return runtime.objects[effect].state.get("tintColor", 0)

    tabs = []
    for index, (title, width) in enumerate(zip(("书架", "历史", "收藏", "圈子"), (34, 32, 33, 32))):
        model = runtime.obj("SSBookShelfTabSelectViewTitleCellModel", "tab model",
                            isSelected=index == 0, cellSpacing=18.0)
        tab = runtime.view("SSBookShelfTabSelectViewTitleCell", title,
                           (index * 50, 0, width, 34), runtime.ROOT,
                           hasSelected=index == 3, cellModel=model)
        send(cpu, runtime, tab, "layoutSubviews")
        material = surface_for(tab)
        state = runtime.objects[material].state
        require(state["frame"] == ((width - 42) * 0.5, 3.0, 42.0, 28.0),
                "shelf tab capsule is padded, centered and consistent")
        require(tint_for(material) == (runtime.color("shelfNeutralTint") if index == 0 else 0),
                "live selection selects neutral material and ignores stale hasSelected")
        tabs.append((tab, model, material))

    for index, (tab, model, material) in enumerate(tabs):
        runtime.objects[model].state["isSelected"] = index == 3
        send(cpu, runtime, tab, "reloadData:", model)
        require(surface_for(tab) == material, "selection updates reuse the tab material")
        require(bool(tint_for(material)) == (index == 3), "selection moves with the host model")
        require(runtime.objects[tab].state["hasSelected"] == (index == 3),
                "host-owned messaging flag is unchanged")

    header = runtime.view("SSBookShelfFilterHeaderView", "filter header", (0, 100, 390, 44), runtime.ROOT)
    row = runtime.view("SSBookShelfFilterMixRowCollectionView", "filter row", (0, 0, 270, 40), header)
    collection = runtime.view("UIView", "filter collection", (0, 0, 270, 40), row)
    filters = []
    for index, title in enumerate(("全部", "阅读", "听书", "星标")):
        cell = runtime.view("SSBookShelfFilter541Cell", title, (index * 65, 0, 58, 30), collection,
                            backgroundColor=runtime.color("hostFilter"), isSelect=index == 0)
        label = runtime.label("filter caption", cell, (10, 5, 38, 20), title)
        send(cpu, runtime, cell, "layoutSubviews")
        material = surface_for(cell)
        state = runtime.objects[material].state
        require(state["frame"] == (1.0, 1.0, 56.0, 28.0) and not state["userInteractionEnabled"],
                "bookshelf filter receives a separate passive inset glass capsule")
        require(runtime.objects[cell].state["subviews"] == [material, label] and
                runtime.string_value(runtime.objects[label].state["text"]) == title,
                "filter glass stays behind the host label and leaves it untouched")
        require(tint_for(material) == (runtime.color("shelfWarmTint") if index == 0 else 0),
                "filter tint follows its live selection")
        filters.append((cell, material))

    other = runtime.view("SSBookShelfFilter541Cell", "filter panel cell", (0, 0, 58, 30), runtime.ROOT)
    send(cpu, runtime, other, "layoutSubviews")
    require(not surface_for(other), "same class outside the inline bookshelf row is unchanged")
    cell, material = filters[0]
    runtime.objects[cell].state["isSelect"] = False
    send(cpu, runtime, cell, "updateAppearance:", 0)
    require(surface_for(cell) == material and not tint_for(material), "appearance update keeps one untinted surface")
    theme = runtime.color("hostNewTheme")
    send(cpu, runtime, cell, "updateCellBgColor:", theme)
    require(runtime.objects[cell].state["backgroundColor"] == runtime.color("clearColor"),
            "host background repaint cannot cover the glass")
    runtime.objects[runtime.DEFAULTS].state["values"]["FanqieAdBlock.GlassDisabled.1"] = 1
    send(cpu, runtime, cell, "layoutSubviews")
    require(not surface_for(cell) and runtime.objects[cell].state["backgroundColor"] == theme,
            "disabling glass restores the latest host filter background")
    tab, _, _ = tabs[3]
    send(cpu, runtime, tab, "layoutSubviews")
    runtime.objects[runtime.DEFAULTS].state["values"]["FanqieAdBlock.GlassDisabled.1"] = 0
    send(cpu, runtime, tab, "layoutSubviews")
    require(tint_for(surface_for(tab)) == runtime.color("shelfNeutralTint"),
            "selected tint is reapplied when the glass surface is recreated")

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
    clear = runtime.color("clearColor")
    slider = runtime.view("BDReaderNewSlider", "slider", (20, 4, 350, 40), progress,
                          clipsToBounds=True, backgroundColor=clear)
    track = runtime.view("UIImageView", "track", (0, 12, 350, 16), slider)
    thumb = runtime.view("UIImageView", "thumb", (154, 9, 22, 22), slider)
    runtime.objects[progress].state["slider"] = slider
    send(cpu, runtime, progress, "layoutSubviews")
    material = call(cpu, labels, "LFQH_FQHSurface", slider)["result"]
    require(material and runtime.objects[material].state["frame"] == (6.0, 5.0, 338.0, 30.0),
            "chapter progress glass leaves room at the four edges")
    require(runtime.objects[slider].state["frame"] == (20, 4, 350, 40) and
            runtime.objects[track].state["frame"] == (0, 12, 350, 16) and
            runtime.objects[thumb].state["frame"] == (154, 9, 22, 22),
            "slider, track and thumb remain in host coordinates")
    runtime.objects[runtime.DEFAULTS].state["values"]["FanqieAdBlock.GlassDisabled.1"] = 1
    send(cpu, runtime, progress, "layoutSubviews")
    require(not call(cpu, labels, "LFQH_FQHSurface", slider)["result"] and
            runtime.objects[slider].state["clipsToBounds"] and
            runtime.objects[slider].state["backgroundColor"] == clear,
            "removing glass preserves the slider owner's original visual properties")
    runtime.objects[runtime.DEFAULTS].state["values"]["FanqieAdBlock.GlassDisabled.1"] = 0

    call(cpu, labels, "LFQH_FQHInstall")
    listen = runtime.view("FQReaderSaaSReaderSpeechButton", "listen", (0, 0, 56, 56), runtime.ROOT)
    default_image = runtime.obj("UIImage", "host disc image")
    theme_image = runtime.obj("UIImage", "host disc image after theme change")
    highlighted_image = runtime.obj("UIImage", "highlighted state image")
    host_tint = runtime.color("hostTint")
    targets = [(listen, runtime.sel("onSpeechBtnClick"), 64)]
    speech = runtime.view("UIButton", "speechBtn", (0, 0, 56, 56), listen, tintColor=host_tint,
                          images={0: default_image, 1: highlighted_image}, control_targets=targets[:])
    runtime.objects[listen].state["speechBtn"] = speech
    send(cpu, runtime, listen, "layoutSubviews")
    speech_state = runtime.objects[speech].state
    speech_glass = call(cpu, labels, "LFQH_FQHSurface", speech)["result"]
    require(speech_glass and speech_state["images"][0] == runtime.speech_template,
            "the actual reader speech button replaces the opaque disc with native glass and transparent artwork")
    require(speech_state["control_targets"] == targets and speech_state["images"][1] == highlighted_image,
            "original tap and other button states stay intact")
    send(cpu, runtime, listen, "readerInsertedViewBackgroundConfigChange:", theme_image)
    require(speech_state["images"][0] == runtime.speech_template and
            call(cpu, labels, "LFQH_FQHSurface", speech)["result"] == speech_glass,
            "the new theme reapplies the glyph and reuses the same material")
    runtime.objects[runtime.DEFAULTS].state["values"]["FanqieAdBlock.GlassDisabled.1"] = 1
    send(cpu, runtime, listen, "layoutSubviews")
    require(not call(cpu, labels, "LFQH_FQHSurface", speech)["result"] and
            speech_state["images"][0] == theme_image and speech_state["tintColor"] == host_tint,
            "disabling glass restores the latest host image and original tint")
    speech_state["tintColor"] = runtime.colors["labelColor"]
    runtime.objects[runtime.DEFAULTS].state["values"]["FanqieAdBlock.GlassDisabled.1"] = 0
    send(cpu, runtime, listen, "layoutSubviews")
    runtime.objects[runtime.DEFAULTS].state["values"]["FanqieAdBlock.GlassDisabled.1"] = 1
    send(cpu, runtime, listen, "layoutSubviews")
    require(speech_state["tintColor"] == runtime.colors["labelColor"],
            "restoration leaves an equivalent tint originally set by the host intact")
    runtime.objects[runtime.DEFAULTS].state["values"]["FanqieAdBlock.GlassDisabled.1"] = 0

    discuss = runtime.view("SSReaderChapterEndDiscussionEntranceView", "discuss",
                           (0, 0, 320, 64), runtime.ROOT)
    send(cpu, runtime, discuss, "layoutSubviews")
    require(call(cpu, labels, "LFQH_FQHSurface", discuss)["result"], "chapter discussion glass")

    profile = runtime.view("SSMyUserBar", "bar", (0, 0, 390, 96), runtime.ROOT)
    search = runtime.view("UIView", "searchBgView", (16, 20, 260, 40), profile,
                          clipsToBounds=True)
    carousel = runtime.view("UIView", "carouseView", (32, 0, 220, 40), search)
    current = runtime.label("currentCue", carousel, (0, 0, 220, 40), "当前提示词")
    upcoming = runtime.label("nextCue", carousel, (0, 40, 220, 40), "下一条提示词")
    runtime.objects[profile].state["searchBgView"] = search
    send(cpu, runtime, profile, "layoutSubviews")
    require(call(cpu, labels, "LFQH_FQHSurface", search)["result"], "profile search glass")
    require(runtime.objects[search].state["clipsToBounds"],
            "profile search glass clips the outgoing and incoming cue words to the pill")
    require(runtime.objects[carousel].state["subviews"] == [current, upcoming] and
            runtime.objects[upcoming].state["frame"] == (0, 40, 220, 40),
            "profile carousel retains both native labels and their frames")

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
                                          title=runtime.text_object("抓大鹅")),
                         isInvisible=False, isDisabled=False)
    normal = runtime.obj("SSMyUserMiniGameEntranceCellModel", "normal",
                         info=runtime.obj("SSSSTimorCellInfo", "normal_info",
                                          title=runtime.text_object("抓大鹅攻略")),
                         isInvisible=False, isDisabled=False)
    runtime.objects[models].state["items"] = [normal]
    runtime.objects[owner].state["miniGameEntranceCellModel"] = target
    send(cpu, runtime, owner, "setupCellMiniGameEntranceData")
    require(runtime.objects[target].state["isInvisible"] is True and
            runtime.objects[target].state["isDisabled"] is True and
            runtime.objects[models].state["items"] == [normal],
            "only the target card is removed from the host plan")
    runtime.objects[owner].state["miniGameEntranceCellModel"] = normal
    runtime.objects[models].state["items"] = []
    send(cpu, runtime, owner, "setupCellMiniGameEntranceData")
    require(not runtime.objects[normal].state["isInvisible"] and
            runtime.objects[models].state["items"] == [normal],
            "a similar title remains in the plan after native setup")
    require(call(cpu, labels, "LFQH_FQHPageTargetGame",
                 runtime.text_object("羊了个羊：星球"))["result"] == 1,
            "the previously targeted game remains filtered")

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
        "reader_controls": ["FQReaderSaaSBottomToolView", "SSReaderBottomToolDivertView",
                            "FQReaderSaaSReaderSpeechButton", "BDReaderNewSlider"],
        "shelf_tabs": len(tabs),
        "shelf_filters": len(filters),
        "profile_shortcuts": 5,
        "profile_search_clips_carousel": True,
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
