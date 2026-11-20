#!/usr/bin/env python3
"""Execute R9 display switches in candidate ARM64; UIKit remains a boundary model."""
import argparse
import json
from pathlib import Path

from arm64 import release_version, require
from test_control_glass166 import send
from test_controls171 import call
from test_drama_visibility178r7 import Runtime as BaseRuntime
from test_feed_viewport import labels_for
from test_page_glass174 import EXTRA, make

HISTORY_MODEL = "SSMyUserExposedHistoryCellModel"
HISTORY_VIEW = "SSMyUser627HistoryExposeView"
READER = "FQReaderTopView"
COIN = "SSReaderTopViewCoinBtnInsertObject"
GAME = "SSMyUser621SideBarGameContainerCell"
SIDEBAR = "SSMyUser621SideBarViewController"
SHELF_MODEL = "SSBookShelfViewModel"
SHELF_ITEM = "SSBookShelfCellModel"
GROUP = "SSBookGroupModel"
SHELF_OWNER = "SSBookShelf525ViewController"
SHELF_CONTROLLER = "SSBookShelfSubViewController"
SHELF_SELECTION = "categoryView:didSelectedItemAtIndex:"
KEYS = ["FanqieX.MineContinueDrama.1", "FanqieX.ReaderEarnMore.1",
        "FanqieX.SidebarGames.1", "FanqieX.ShelfMotionComic.1"]


class Runtime(BaseRuntime):
    HOST_VISIBILITY = 0x33251000
    HOST_HEIGHT = 0x33251004
    HOST_SELECTION = 0x33251008

    def __init__(self, data):
        super().__init__(data)
        for name, parent in ((HISTORY_MODEL, "NSObject"), (HISTORY_VIEW, "UIView"),
                             (READER, "UIView"), (COIN, "NSObject"), (GAME, "UIView"),
                             (SIDEBAR, "UIViewController"), (SHELF_MODEL, "NSObject"),
                             (SHELF_ITEM, "NSObject"), (GROUP, "NSObject")):
            self._class(name, parent)
        for cls, name, signature in (
            (HISTORY_MODEL, "shouldShowHistory", "B16@0:8"),
            (HISTORY_VIEW, "layoutSubviews", "v16@0:8"),
            (READER, "configInsertObjs:", "v24@0:8@16"),
            (GAME, "layoutSubviews", "v16@0:8"),
            (SIDEBAR, "reloadData", "v16@0:8"),
            (SHELF_MODEL, "setShowCellModels:", "v24@0:8@16"),
            (SHELF_CONTROLLER, "reloadData:", "v24@0:8@16"),
        ):
            self._add(self.classes[cls], name, self.HOST_VISIBILITY, signature)
        self._add(self.classes[SHELF_OWNER], SHELF_SELECTION, self.HOST_SELECTION, "v32@0:8@16q24")
        self._add(self.metaclasses[self.classes[GAME]], "heightForModels:containerWidth:",
                  self.HOST_HEIGHT, "d32@0:8@16d24")

    def responds(self, receiver, name):
        if receiver in self.objects and name in self.objects[receiver].state:
            return True
        return super().responds(receiver, name)

    def handle(self, cpu, pc):
        receiver, selector, argument = cpu.x[:3]
        name = self.selector_names.get(selector)
        if pc == self.HOST_HEIGHT:
            return self.finish(cpu, fp=(204.,))
        if pc == self.HOST_SELECTION:
            state = self.objects[receiver].state
            state["currentTabVC"] = state["nativeTabs"][cpu.x[3]]
            return self.finish(cpu)
        if pc == self.HOST_VISIBILITY:
            state = self.objects[receiver].state
            if name == "configInsertObjs:":
                state["appliedItems"] = argument
            if name == "setShowCellModels:":
                state["showCellModels"] = argument
            if name in ("reloadData", "reloadData:"):
                state["reloads"] = state.get("reloads", 0) + 1
            return self.finish(cpu, int(state.get(name, 0)))
        if pc - self.slide == 0xa5d4 and receiver in self.objects:
            if name in ("groupModel", "isFakeMotionComicGroup", "showCellModels", "currentTabVC",
                        "viewModel", "delegate"):
                return self.finish(cpu, int(self.objects[receiver].state.get(name, 0)))
        return super().handle(cpu, pc)


def exercise(data, labels):
    cpu, rt = make(data, Runtime)
    rt.labels = labels
    call(cpu, labels, "LFQH_FQHPageInstall")
    prefs = rt.objects[rt.DEFAULTS].state["values"]
    history_model = rt.obj(HISTORY_MODEL, "native history model", shouldShowHistory=True)
    history = rt.view(HISTORY_VIEW, "continue native history", (0., 60., 360., 44.), rt.ROOT)
    reader = rt.view(READER, "reading top strip", (0., 0., 402., 50.), rt.ROOT)
    coin = rt.obj(COIN, "earn reward")
    battery = rt.obj("NSObject", "battery insert")
    coupon = rt.obj("NSObject", "unrelated insert")
    insert_array = rt.obj("NSArray", "native insertion list", items=[coin, battery, coupon])
    game = rt.view(GAME, "sidebar games", (0., 0., 320., 204.), rt.ROOT)
    message = rt.view("UIView", "independent sidebar messages", (0., 0., 320., 140.), rt.ROOT)
    game_models = rt.obj("NSArray", "native games", items=[coin])
    comic_group = rt.obj(GROUP, "fake motion comic group", isFakeMotionComicGroup=True)
    normal_group = rt.obj(GROUP, "user group named 漫剧", isFakeMotionComicGroup=False)
    comic_item = rt.obj(SHELF_ITEM, "automatic comic group", groupModel=comic_group, itemShowHeight=160.)
    normal_item = rt.obj(SHELF_ITEM, "user collection", groupModel=normal_group, itemShowHeight=205.)
    book = rt.obj(SHELF_ITEM, "normal book", groupModel=0, itemShowHeight=180.)
    native_items = rt.obj("NSArray", "unmodified shelf data", items=[book, comic_item, normal_item])
    shelf = rt.obj(SHELF_MODEL, "native shelf view model", showCellModels=native_items,
                   cacheCellModels=native_items)

    def items(array):
        return rt.objects[array].state["items"]

    def apply_views():
        send(cpu, rt, history, "layoutSubviews")
        send(cpu, rt, game, "layoutSubviews")
        send(cpu, rt, reader, "configInsertObjs:", insert_array)
        send(cpu, rt, shelf, "setShowCellModels:", native_items)

    apply_views()
    require(send(cpu, rt, history_model, "shouldShowHistory")["result"] == 1,
            "History remains visible by default")
    require(items(rt.objects[reader].state["appliedItems"]) == [coin, battery, coupon],
            "Default reader insert order remains untouched")
    require(rt.objects[shelf].state["showCellModels"] == native_items,
            "Default shelf uses its original display array")
    send(cpu, rt, rt.classes[GAME], "heightForModels:containerWidth:", game_models, fp=(320.,))
    require(cpu.fp(0) == 204., "Default sidebar returns its actual host height")

    for key in KEYS:
        prefs[key] = False
    apply_views()
    require(not send(cpu, rt, history_model, "shouldShowHistory")["result"] and
            rt.objects[history].state["hidden"], "Continue history model and view are both hidden")
    require(items(rt.objects[reader].state["appliedItems"]) == [battery, coupon] and
            items(insert_array) == [coin, battery, coupon],
            "Only the coin insert is removed from a copy; host data stays intact")
    send(cpu, rt, rt.classes[GAME], "heightForModels:containerWidth:", game_models, fp=(320.,))
    require(cpu.fp(0) == 0. and rt.objects[game].state["hidden"] and
            not rt.objects[message].state["hidden"] and items(game_models) == [coin],
            "Only game height and visibility change; messages and game data are preserved")
    result = rt.objects[shelf].state["showCellModels"]
    require(items(result) == [book, normal_item] and items(native_items) == [book, comic_item, normal_item],
            "Only the identified fake comic group is hidden, including preservation of a same-name user group")
    require(rt.objects[shelf].state["cacheCellModels"] == native_items,
            "Persistent/source cache is not replaced by the display filter")
    # Host binary 7.4.3.33: sections and item count derive from itemsInBookSection,
    # which derives from showCellModels. Cell creation and taps use section.items;
    # grid/double-column sizing uses the showCellModels backing ivar directly.
    # The actual setter hook must put the same filtered model into that backing
    # storage, not merely return a shorter temporary section list.
    display = items(rt.objects[shelf].state["showCellModels"])
    section_items = list(display)
    require(len(section_items) == 2 and section_items[1] == display[1] == normal_item and
            rt.objects[display[1]].state["itemShowHeight"] == 205.,
            "Section count, displayed cell, tap target and native sizing share the same row mapping")

    settings = rt.obj("NSObject", "settings controller")
    switch = rt.view("UISwitch", "visibility switch", isOn=True)
    for tag, key in zip(range(26, 30), KEYS):
        rt.objects[switch].state["tag"] = tag
        call(cpu, labels, "LFQH_FQHBottomOptionChanged178", settings,
             rt.sel("fqx178_bottomOptionChanged:"), switch)
        require(prefs[key] is True, "The settings callback persists each independent option")
    require(not rt.objects[history].state["hidden"] and not rt.objects[game].state["hidden"],
            "Existing native views are restored immediately")
    require(items(rt.objects[reader].state["appliedItems"]) == [coin, battery, coupon],
            "Existing reader restores the retained unfiltered input immediately")
    require(rt.objects[shelf].state["showCellModels"] == native_items,
            "Restored shelf retains the original group and items")
    newer_items = rt.obj("NSArray", "new host result after data refresh", items=[normal_item, comic_item])
    prefs[KEYS[3]] = False
    send(cpu, rt, shelf, "setShowCellModels:", newer_items)
    require(items(rt.objects[shelf].state["showCellModels"]) == [normal_item],
            "A host refresh while hidden replaces the saved source with its current array")
    rt.objects[switch].state["tag"] = 29
    call(cpu, labels, "LFQH_FQHBottomOptionChanged178", settings,
         rt.sel("fqx178_bottomOptionChanged:"), switch)
    require(rt.objects[shelf].state["showCellModels"] == newer_items,
            "Restoration uses the newest native array and does not revive removed books")
    if release_version(data) in ("1.78R19", "1.78R25", "1.78R26", "1.78R27", "1.78R28", "1.78R29", "1.78R30", "1.78R31", "1.78R32", "1.78R33", "1.78R34", "1.78R35", "1.78R36", "1.79R1", "1.79R2", "1.79R3", "1.79R4", "1.79R5", "1.8R1", "1.8R2", "1.8R3", "1.8R4", "1.8R5", "1.8R6", "1.8R7", "1.8R8", "1.8R9", "1.8R10", "1.8R11", "1.8R12", "1.8R13", "1.8R14", "1.8R15", "1.8R16", "1.8R17", "1.8R18", "1.8R19", "1.8R19", "1.9.1beta1", "1.9.1beta2", "1.9.1beta3", "1.9.1beta4", "1.9.1beta5", "1.9.1beta6", "1.9.1beta7", "1.9.1beta8", "1.9.1beta9", "1.9.1beta10", "1.9.1beta11", "1.9.1beta12", "1.9.1beta13"):
        call(cpu, labels, "LFQH_FQHInstall")
        controller = rt.obj(SHELF_CONTROLLER, "book grid", viewModel=shelf)
        history_page = rt.obj("UIViewController", "mixed History page", filterSelection="all")
        shelf_owner = rt.obj(SHELF_OWNER, "shelf container", view=rt.ROOT,
                             nativeTabs=(controller, history_page), currentTabVC=history_page)
        rt.objects[shelf].state["delegate"] = controller
        rt.objects[controller].state["delegate"] = shelf_owner
        state = rt.objects[switch].state
        state.update(tag=29, isOn=False)
        call(cpu, labels, "LFQH_FQHBottomOptionChanged178", settings,
             rt.sel("fqx178_bottomOptionChanged:"), switch)
        require(prefs[KEYS[3]] is False and rt.objects[shelf].state["showCellModels"] == newer_items and
                not rt.objects[controller].state.get("reloads"),
                "Disabling the comic group waits for the bookshelf when History is active")
        send(cpu, rt, shelf_owner, SHELF_SELECTION, 0, 0)
        require(items(rt.objects[shelf].state["showCellModels"]) == [normal_item] and
                rt.objects[controller].state["reloads"] == 1 and
                rt.objects[history_page].state["filterSelection"] == "all",
                "The next bookshelf selection applies the pending display change once")
        state.update(tag=28, isOn=False)
        call(cpu, labels, "LFQH_FQHBottomOptionChanged178", settings,
             rt.sel("fqx178_bottomOptionChanged:"), switch)
        require(rt.objects[controller].state["reloads"] == 1,
                "Changing the sidebar visibility never reloads the bookshelf")
    rt.objects[history_model].state["shouldShowHistory"] = False
    require(not send(cpu, rt, history_model, "shouldShowHistory")["result"],
            "Enabling the option does not invent native history")
    rt.objects[history].state["hidden"] = True
    prefs[KEYS[0]] = False
    send(cpu, rt, history, "layoutSubviews")
    prefs[KEYS[0]] = True
    send(cpu, rt, history, "layoutSubviews")
    require(rt.objects[history].state["hidden"], "A native-hidden view stays hidden after toggle restoration")
    return {"independent_visibility_switches": 4, "original_arrays_unchanged": True,
            "native_hidden_state_preserved": True, "settings_restore_live_views": True,
            "shared_shelf_display_and_size_mapping": True, "latest_host_array_restored": True,
            "defers_shelf_reload_while_history_is_active": release_version(data) in ("1.78R19", "1.78R25", "1.78R26", "1.78R27", "1.78R28", "1.78R29", "1.78R30", "1.78R31", "1.78R32", "1.78R33", "1.78R34", "1.78R35", "1.78R36", "1.79R1", "1.79R2", "1.79R3", "1.79R4", "1.79R5", "1.8R1", "1.8R2", "1.8R3", "1.8R4", "1.8R5", "1.8R6", "1.8R7", "1.8R8", "1.8R9", "1.8R10", "1.8R11", "1.8R12", "1.8R13", "1.8R14", "1.8R15", "1.8R16", "1.8R17", "1.8R18", "1.8R19", "1.8R19", "1.9.1beta1", "1.9.1beta2", "1.9.1beta3", "1.9.1beta4", "1.9.1beta5", "1.9.1beta6", "1.9.1beta7", "1.9.1beta8", "1.9.1beta9", "1.9.1beta10", "1.9.1beta11", "1.9.1beta12", "1.9.1beta13")}


def main():
    parser = argparse.ArgumentParser(description=__doc__)
    parser.add_argument("candidate", type=Path)
    parser.add_argument("--report", type=Path, required=True)
    args = parser.parse_args()
    data = args.candidate.read_bytes()
    require(release_version(data) in ("1.78R9", "1.78R10", "1.78R11", "1.78R12", "1.78R13", "1.78R14", "1.78R15", "1.78R16", "1.78R17", "1.78R18", "1.78R19", "1.78R25", "1.78R26", "1.78R27", "1.78R28", "1.78R29", "1.78R30", "1.78R31", "1.78R32", "1.78R33", "1.78R34", "1.78R35", "1.78R36", "1.79R1", "1.79R2", "1.79R3", "1.79R4", "1.79R5", "1.8R1", "1.8R2", "1.8R3", "1.8R4", "1.8R5", "1.8R6", "1.8R7", "1.8R8", "1.8R9", "1.8R10", "1.8R11", "1.8R12", "1.8R13", "1.8R14", "1.8R15", "1.8R16", "1.8R17", "1.8R18", "1.8R19", "1.8R19", "1.9.1beta1", "1.9.1beta2", "1.9.1beta3", "1.9.1beta4", "1.9.1beta5", "1.9.1beta6", "1.9.1beta7", "1.9.1beta8", "1.9.1beta9", "1.9.1beta10", "1.9.1beta11", "1.9.1beta12", "1.9.1beta13"), "Use an R9 or later candidate")
    labels = labels_for(data, args.candidate.with_suffix(".composed.s"),
                        EXTRA + ["LFQH_FQHBottomOptionChanged178", "LFQH_FQHInstall"])
    report = {"passed": True, **exercise(data, labels), "device_tested": False}
    args.report.write_text(json.dumps(report, indent=2) + "\n", encoding="utf-8")
    print(json.dumps(report, indent=2))


if __name__ == "__main__":
    main()
