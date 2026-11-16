#!/usr/bin/env python3
"""Run the three short-drama visibility switches against the candidate ARM64."""
import argparse
import hashlib
import json
from pathlib import Path

from arm64 import release_version, require
from test_control_glass166 import send
from test_controls171 import call
from test_feed_viewport import labels_for
from test_page_glass174 import EXTRA, Runtime as PageRuntime, make

HEADER = "SSVideoSeriesFeedHeaderView"
SEARCH = "SSVideoSeriesFeedHeaderSearchView"
CONTROLLER = "SSVideoSeriesFeedViewController"
COORDINATOR = "SSVideoSeriesFeedSearchIconCoordinator"
MANAGER = "SSShortVideoBelowLeftContainerViewManager"
CONFIG = "FQVShortVideoListConfig"
CONTEXT = "FQVShortVideoContextModel"
CATEGORIES_KEY = "FanqieX.DramaCategories.1"
SEARCH_KEY = "FanqieX.DramaSearch.1"
AUTHOR_KEY = "FanqieX.DramaAuthorDeclaration.1"
MODEL = "SSBookStoreTabModel"
CATEGORY_TITLES_KEY = "FanqieX.DramaCategoryTitles.1"
CATEGORY_SETUP = "setupDataWithTabModels:serverSelectedIndex:reportFirstScreenDataFinish:reason:"
CATEGORY_REFRESH = "refreshSingleTabViewWithTabModels:serverSelectedIndex:reason:"
CATEGORY_SELECTED = "refreshSelectedTabModelWithTabModels:serverSelectedIndex:"


class Runtime(PageRuntime):
    HOST_GETTER = 0x33250028
    SEARCH_HIDDEN = 0x33250030
    CATEGORY_NATIVE = 0x33250038

    def __init__(self, data):
        super().__init__(data)
        for name, parent in (
            (HEADER, "UIView"), (SEARCH, "UIView"), (CONTROLLER, "UIViewController"),
            (COORDINATOR, "NSObject"), (MANAGER, "NSObject"), (CONFIG, "NSObject"), (CONTEXT, "NSObject"),
            (MODEL, "NSObject"), ("NSMutableSet", "NSObject"),
        ):
            self._class(name, parent)
        for cls, selector, encoding, implementation in (
            (HEADER, "setupSubViews", "v16@0:8", self.LAYOUT_IMP),
            (COORDINATOR, "prepareColdStartSearchButtonIfNeeded", "v16@0:8", self.HOST_GETTER),
            (HEADER, "didMoveToWindow", "v16@0:8", self.LAYOUT_IMP),
            (HEADER, "updateTabViewWithContentSize:", "v32@0:8{CGSize=dd}16", self.LAYOUT_IMP),
            (HEADER, "applySearchBarVisibilityForCurrentLayout", "d16@0:8", self.HOST_GETTER),
            (HEADER, "updateFindDramaSearchAlphaV731:", "v24@0:8d16", self.HOST_GETTER),
            (SEARCH, "setupNewSearchBar", "v16@0:8", self.LAYOUT_IMP),
            (SEARCH, "setSearchBgView:", "v24@0:8@16", self.HOST_GETTER),
            (SEARCH, "searchBgView", "@16@0:8", self.HOST_GETTER),
            ("UIView", "setHidden:", "v20@0:8B16", self.SEARCH_HIDDEN),
            (CONTROLLER, "relayoutHeaderView", "v16@0:8", self.LAYOUT_IMP),
            (MANAGER, "shouldAddAiUsageView", "B16@0:8", self.HOST_GETTER),
            (MANAGER, "updateSubViews", "v16@0:8", self.HOST_GETTER),
            (CONFIG, "feedType", "q16@0:8", self.HOST_GETTER),
            (MODEL, "tabType", "i16@0:8", self.HOST_GETTER),
            (CONTROLLER, "tabModels", "@16@0:8", self.HOST_GETTER),
            (CONTROLLER, "currentTabModel", "@16@0:8", self.HOST_GETTER),
            (CONTROLLER, CATEGORY_SETUP, "v44@0:8@16q24B32q36", self.CATEGORY_NATIVE),
            (CONTROLLER, CATEGORY_REFRESH, "v40@0:8@16q24q32", self.CATEGORY_NATIVE),
            (CONTROLLER, CATEGORY_SELECTED, "v32@0:8@16q24", self.CATEGORY_NATIVE),
        ):
            self._add(self.classes[cls], selector, implementation, encoding)
        self.category_title_rows = 0
        self.category_writes = []
        self.category_reenter = False

    def responds(self, receiver, name):
        if ((name == "allObjects" and self.is_kind(receiver, self.classes["NSHashTable"])) or
                (name == "stringValue" and self.is_kind(receiver, self.classes["NSNumber"]))):
            return True
        return super().responds(receiver, name)

    def handle(self, cpu, pc):
        receiver, selector = cpu.x[:2]
        name = self.selector_names.get(selector)
        if pc - self.slide == 0xa5d4:
            if name == "stringValue" and self.is_kind(receiver, self.classes["NSNumber"]):
                return self.finish(cpu, self.text_object(str(int(self.objects[receiver].state["value"]))))
            if receiver == self.classes["NSMutableSet"] and name == "set":
                return self.finish(cpu, self.obj("NSMutableSet", "modeled category types", items=[]))
            if receiver == self.DEFAULTS and name in ("setObject:forKey:", "objectForKey:"):
                key = self.string_value(cpu.x[3 if name == "setObject:forKey:" else 2])
                if key == CATEGORY_TITLES_KEY:
                    if name == "setObject:forKey:":
                        self.category_title_rows = cpu.x[2]
                        return self.finish(cpu)
                    return self.finish(cpu, self.category_title_rows)
            if name == "title" and self.is_kind(receiver, self.classes[MODEL]):
                return self.finish(cpu, self.objects[receiver].state["title"])
        if pc == self.CATEGORY_NATIVE:
            if name == CATEGORY_SETUP and self.category_reenter:
                # Model a synchronous native call into the refresh method using
                # the list already forwarded into the original setup handler.
                self.category_reenter = False
                refresh = self.sel(CATEGORY_REFRESH)
                method = self.get_method(self.classes[CONTROLLER], refresh)
                cpu.x[1] = refresh
                cpu.x[4] = 16
                cpu.pc = self.methods[method]["imp"]
                return True
            state = self.objects[receiver].state
            models, index, arg4, arg5 = cpu.x[2:6]
            entries = self.objects[models].state["items"]
            require(index < len(entries), "Native category selection only sees a matching list and index")
            self.category_writes.append((name, tuple(entries), index, arg4, arg5))
            state.update(tabModels=models, currentTabModel=entries[index])
            return self.finish(cpu)
        if pc == self.SEARCH_HIDDEN:
            self.objects[receiver].state["hidden"] = bool(cpu.x[2])
            return self.finish(cpu)
        if (pc - self.slide == 0xa5d4 and name == "new" and receiver and
                receiver == self.classes.get("FQXDramaSearchBackground")):
            return self.finish(cpu, self.view("FQXDramaSearchBackground", "fixed search background"))
        if pc == self.HOST_GETTER:
            state = self.objects[receiver].state
            if name == "setSearchBgView:":
                state["searchBgView"] = cpu.x[2]
                return self.finish(cpu)
            if name == "prepareColdStartSearchButtonIfNeeded":
                self.reparent(state["icon"], state["overlay"])
                return self.finish(cpu)
            if name in ("applySearchBarVisibilityForCurrentLayout", "updateFindDramaSearchAlphaV731:"):
                search = self.objects[state["searchViewContainer"]].state
                background = self.objects[search["searchBgView"]].state
                background["hidden"] = False
                if name == "applySearchBarVisibilityForCurrentLayout":
                    return self.finish(cpu, fp=(0.625,))
                background["alpha"] = cpu.fp(0)
                return self.finish(cpu)
            if name == "updateSubViews":
                state["updates"] = state.get("updates", 0) + 1
                return self.finish(cpu)
            return self.finish(cpu, int(state.get(name, 0)))
        if pc - self.slide == 0xa5d4 and name in (
            "headerView", "tabContainer", "searchViewContainer",
            "searchButtonSlotView", "searchButtonView", "searchBgView", "searchView",
            "vcContext", "config", "host",
        ) and receiver in self.objects:
            return self.finish(cpu, self.objects[receiver].state.get(name, 0))
        return super().handle(cpu, pc)


def exercise(data, labels):
    cpu, rt = make(data, Runtime)
    rt.labels = labels
    call(cpu, labels, "LFQH_FQHPageInstall")
    header = rt.view(HEADER, "drama header", (0., 62., 440., 60.))
    controller = rt.obj(CONTROLLER, "drama feed owner", headerView=header)
    categories = rt.view("UIView", "three category tabs", (8., 0., 140., 44.), header)
    search = rt.view(SEARCH, "drama search container", (0., 0., 440., 44.), header)
    slot = rt.view("UIView", "native magnifier slot", (392., 0., 44., 44.), search)
    icon = rt.view("UIImageView", "native magnifier", (9., 9., 26., 26.), slot)
    bar = rt.view("UIView", "fresh find-drama search background")
    first_frame_checked = release_version(data) in ("1.78R15", "1.78R16")
    if first_frame_checked:
        original = bar
        send(cpu, rt, search, "setSearchBgView:", original)
        bar = rt.objects[search].state["searchBgView"]
        require(bar != original and rt.objects[bar].state["hidden"],
                "The newly assigned standalone background is hidden before attachment")
    rt.reparent(bar, search)
    field = rt.view("UIView", "find-drama search cue", (12., 0., 316., 44.), bar)
    pip = rt.view("UIView", "unrelated picture-in-picture control", (392., 0., 44., 44.), header)
    rt.objects[header].state.update(delegate=controller, tabContainer=categories, searchViewContainer=search)
    rt.objects[search].state.update(searchButtonSlotView=slot, searchButtonView=icon, searchBgView=bar, searchView=field)
    config = rt.obj(CONFIG, "root drama feed config", feedType=4)
    context = rt.obj(CONTEXT, "native video context", config=config)
    manager = rt.obj(MANAGER, "native AI declaration owner", vcContext=context, shouldAddAiUsageView=True)
    options = rt.objects[rt.DEFAULTS].state["values"]

    def hidden(view):
        return rt.objects[view].state["hidden"]

    def native_declares():
        return bool(send(cpu, rt, manager, "shouldAddAiUsageView")["result"])

    if first_frame_checked:
        options.update({CATEGORIES_KEY: False, SEARCH_KEY: False})
        send(cpu, rt, header, "setupSubViews")
        require(hidden(categories) and hidden(slot) and hidden(bar),
                "Saved switches hide both search forms before mounting")
        overlay = rt.view("UIView", "cold-start search overlay", (0., 0., 440., 956.), rt.ROOT)
        coordinator = rt.obj(COORDINATOR, "native search coordinator", host=controller, icon=icon, overlay=overlay)
        send(cpu, rt, coordinator, "prepareColdStartSearchButtonIfNeeded")
        require(rt.objects[icon].state["superview"] == slot,
                "A disabled magnifier never enters the cold-start overlay")
        del options[SEARCH_KEY]
        send(cpu, rt, coordinator, "prepareColdStartSearchButtonIfNeeded")
        require(rt.objects[icon].state["superview"] == overlay,
                "The enabled magnifier keeps its original cold-start presentation")
        rt.reparent(icon, slot)
        del options[CATEGORIES_KEY]

    rt.reparent(header, rt.ROOT)
    send(cpu, rt, header, "didMoveToWindow")
    require(not hidden(categories) and not hidden(slot) and hidden(bar) == first_frame_checked and native_declares(),
            "Unset preferences preserve the native categories, magnifier and declaration")

    for flags in range(8):
        show_categories, show_search, show_author = (bool(flags & bit) for bit in (1, 2, 4))
        options.update({CATEGORIES_KEY: show_categories, SEARCH_KEY: show_search, AUTHOR_KEY: show_author})
        send(cpu, rt, header, "updateTabViewWithContentSize:", fp=(140., 44.))
        require(hidden(categories) != show_categories and hidden(slot) != show_search,
                "The two separately owned header controls respond independently")
        require(native_declares() == show_author, "The author row follows only its own switch")
        require(hidden(bar) == first_frame_checked,
                "The full Find Drama field stays hidden independently of the magnifier")
        require(not hidden(header) and not hidden(search) and not hidden(pip),
                "Top switches preserve other header controls")

    options[SEARCH_KEY] = False
    send(cpu, rt, controller, "relayoutHeaderView")
    rt.objects[slot].state["hidden"] = False
    send(cpu, rt, controller, "relayoutHeaderView")
    require(hidden(slot) and not hidden(categories), "A native layout cannot reveal a disabled search slot")
    if first_frame_checked:
        row = rt.view("UIView", "migrated Find Drama search row", (0., 62., 440., 44.), rt.ROOT)
        rt.reparent(bar, row)
        send(cpu, rt, bar, "setHidden:", 0)
        require(hidden(bar) and not hidden(row) and not hidden(pip),
                "A direct native unhide cannot revive only the migrated field")
        send(cpu, rt, header, "applySearchBarVisibilityForCurrentLayout")
        require(hidden(bar) and cpu.fp(0) == 0.625,
                "Native layout preserves both field suppression and its alpha return value")
        send(cpu, rt, header, "updateFindDramaSearchAlphaV731:", fp=(0.5,))
        require(hidden(bar) and rt.objects[bar].state["alpha"] == 0.5 and not hidden(row),
                "Scrolling keeps the migrated field hidden without hiding its entire row")
    options[SEARCH_KEY] = True
    send(cpu, rt, controller, "relayoutHeaderView")
    require(not hidden(slot) and hidden(bar) == first_frame_checked,
            "Restoring the magnifier keeps the full Find Drama field hidden")
    rt.objects[slot].state["hidden"] = True
    options[SEARCH_KEY] = False
    send(cpu, rt, controller, "relayoutHeaderView")
    options[SEARCH_KEY] = True
    send(cpu, rt, controller, "relayoutHeaderView")
    require(hidden(slot), "A genuinely hidden native slot remains hidden when the option is enabled")

    options[AUTHOR_KEY] = False
    rt.objects[config].state["feedType"] = 5
    require(native_declares(), "A reused non-root feed retains its native AI declaration")
    options[AUTHOR_KEY] = True
    rt.objects[config].state["feedType"] = 4
    rt.objects[manager].state["shouldAddAiUsageView"] = False
    require(not native_declares(), "Enabling the switch never creates missing declaration data")

    rt.objects[manager].state["shouldAddAiUsageView"] = True
    rt.objects[slot].state["hidden"] = False
    options.update({CATEGORIES_KEY: True, SEARCH_KEY: True, AUTHOR_KEY: True})
    settings = rt.obj("NSObject", "drama visibility setting owner")
    switch = rt.view("UISwitch", "visibility switch", isOn=False)
    action = rt.sel("fqx178_bottomOptionChanged:")
    for tag, key in ((21, CATEGORIES_KEY), (22, SEARCH_KEY), (23, AUTHOR_KEY)):
        rt.objects[switch].state["tag"] = tag
        call(cpu, labels, "LFQH_FQHBottomOptionChanged178", settings, action, switch)
        require(options[key] is False, "The actual settings handler persists the selected option")
    require(hidden(categories) and hidden(slot) and not native_declares(),
            "Existing header and feed reflect settings changes without relaunch")
    require(hidden(bar) == first_frame_checked, "The actual settings callback updates the mounted search field")
    require(rt.objects[manager].state.get("updates") == 3,
            "The visible declaration manager reruns native layout when settings change")

    category_cases = []
    if release_version(data) == "1.78R16":
        source = [
            rt.obj(MODEL, "native category " + str(number), tabType=number,
                   title=rt.text_object(title))
            for number, title in ((7, "原生分类 A"), (11, "原生分类 B"), (103, "原生分类 C"))
        ]
        all_models = rt.obj("NSArray", "server category set", items=source)
        options[CATEGORIES_KEY] = True

        def select(tag, enabled):
            rt.objects[switch].state.update(tag=tag, isOn=enabled)
            call(cpu, labels, "LFQH_FQHBottomOptionChanged178", settings, action, switch)

        def native_state(entries, index, expected_hidden=False):
            require(rt.category_writes[-1][1:3] == (tuple(entries), index),
                    "The native controllers receive the effective models and remapped selection")
            require(hidden(categories) == expected_hidden, "The header row follows actual visible-category count")

        options["FanqieX.DramaCategory.11.1"] = False
        send(cpu, rt, controller, CATEGORY_SETUP, all_models, 2, 1, 16)
        native_state([source[0], source[2]], 1)
        require(rt.category_writes[-1][-2:] == (1, 16), "Cold-start flags are forwarded")
        rows = rt.native(rt.category_title_rows)
        require([row["title"] for row in rows] == ["原生分类 A", "原生分类 B", "原生分类 C"],
                "Settings titles use the complete native catalog")
        category_cases.append("cold start remap and complete discovery")

        rt.category_reenter = True
        send(cpu, rt, controller, CATEGORY_SETUP, all_models, 2, 1, 16)
        native_state([source[0], source[2]], 1)
        select(1011, True)
        native_state(source, 2)
        category_cases.append("nested native refresh preserves the complete settings source")
        select(1007, False)
        native_state(source[1:], 1)
        select(1103, False)
        native_state([source[1]], 0)
        category_cases.append("live independent category toggles")

        select(1011, False)
        native_state(source, 1, True)
        category_cases.append("hide all buttons with the selected feed retained")
        select(1103, True)
        native_state([source[2]], 0)
        select(21, False)
        native_state(source, 2, True)
        select(21, True)
        native_state([source[2]], 0)
        category_cases.append("master keeps individual choices")

        reordered = rt.obj("NSArray", "reordered native server tabs", items=[source[2], source[0], source[1]])
        send(cpu, rt, controller, CATEGORY_REFRESH, reordered, 0, 17)
        native_state([source[2]], 0)
        require(rt.category_writes[-1][3] == 17, "Refresh reason passes through")
        select(1011, True)
        native_state([source[2], source[1]], 0)
        send(cpu, rt, controller, CATEGORY_SELECTED, reordered, 2)
        native_state([source[2], source[1]], 1)
        category_cases.append("native ordering and original selected refresh preserved")

    return {"independent_combinations": 8, "native_hidden_state_unchanged": True,
            "independent_category_cases": category_cases,
            "direct_migrated_search_unhide_blocked": first_frame_checked,
            "non_root_declaration_unchanged": True, "settings_apply_immediately": True,
            "first_frame_and_cold_start_overlay_checked": first_frame_checked,
            "device_tested": False}


def main():
    parser = argparse.ArgumentParser(description=__doc__)
    parser.add_argument("candidate", type=Path)
    parser.add_argument("--report", type=Path, required=True)
    args = parser.parse_args()
    data = args.candidate.read_bytes()
    require(release_version(data) in ("1.78R7", "1.78R8", "1.78R9", "1.78R10", "1.78R11", "1.78R12", "1.78R13", "1.78R14", "1.78R15", "1.78R16"), "Use the 1.78R7 or later candidate")
    labels = labels_for(data, args.candidate.with_suffix(".composed.s"),
                        EXTRA + ["LFQH_FQHBottomOptionChanged178"])
    report = {"passed": True, "candidate_sha256": hashlib.sha256(data).hexdigest(), **exercise(data, labels)}
    args.report.write_text(json.dumps(report, indent=2) + "\n", encoding="utf-8")
    print(json.dumps(report, indent=2))


if __name__ == "__main__":
    main()
