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
CATEGORY_VIEW = "SSHGBookStoreCategoryTitleView"
CATEGORY_BASE = "FQRJXCategoryBaseView"
CATEGORY_CELL = "collectionView:cellForItemAtIndexPath:"
CATEGORY_TAP = "collectionView:didSelectItemAtIndexPath:"
CATEGORY_SIZE = "collectionView:layout:sizeForItemAtIndexPath:"
CATEGORY_SPACING = "innerCellSpacing"
HEADER_SELECTED = "finalizeTabSelectionUIStateWithTabModel:"
SEARCH_ICON_VISIBILITY = "applySearchIconVisible:tabContainerTop:"
SEARCH_ICON_RETURN = "finishColdStartSearchPresentation"
SEARCH_ACTION = "simpleSearchViewDidClicked"
SEARCH_TRANSITION = "finishSearchIconVisibilityTransition:"


class Runtime(PageRuntime):
    HOST_GETTER = 0x33250028
    SEARCH_HIDDEN = 0x33250030
    CATEGORY_NATIVE = 0x33250038

    def __init__(self, data):
        super().__init__(data)
        for name, parent in (
            (HEADER, "UIView"), (SEARCH, "UIView"), (CONTROLLER, "UIViewController"),
            (COORDINATOR, "NSObject"), (MANAGER, "NSObject"), (CONFIG, "NSObject"), (CONTEXT, "NSObject"),
            (MODEL, "NSObject"), ("NSMutableSet", "NSObject"), (CATEGORY_BASE, "UIView"),
            (CATEGORY_VIEW, CATEGORY_BASE), ("NSIndexPath", "NSObject"), ("UICollectionViewCell", "UIView"),
        ):
            self._class(name, parent)
        for name in ("UIImageSymbolConfiguration", "UICollectionViewLayoutAttributes"):
            if name not in self.classes:
                self._class(name, "NSObject")
        for cls, selector, encoding, implementation in (
            (HEADER, "setupSubViews", "v16@0:8", self.LAYOUT_IMP),
            (COORDINATOR, "prepareColdStartSearchButtonIfNeeded", "v16@0:8", self.HOST_GETTER),
            (COORDINATOR, SEARCH_ICON_RETURN, "v16@0:8", self.HOST_GETTER),
            (HEADER, "didMoveToWindow", "v16@0:8", self.LAYOUT_IMP),
            (HEADER, "layoutSubviews", "v16@0:8", self.LAYOUT_IMP),
            (HEADER, "updateTabViewWithContentSize:", "v32@0:8{CGSize=dd}16", self.LAYOUT_IMP),
            (HEADER, "applySearchBarVisibilityForCurrentLayout", "d16@0:8", self.HOST_GETTER),
            (HEADER, "updateFindDramaSearchAlphaV731:", "v24@0:8d16", self.HOST_GETTER),
            (HEADER, SEARCH_ICON_VISIBILITY, "v28@0:8B16d20", self.HOST_GETTER),
            (HEADER, SEARCH_TRANSITION, "v20@0:8B16", self.HOST_GETTER),
            (SEARCH, "setupNewSearchBar", "v16@0:8", self.LAYOUT_IMP),
            (SEARCH, "setSearchBgView:", "v24@0:8@16", self.HOST_GETTER),
            (SEARCH, "searchBgView", "@16@0:8", self.HOST_GETTER),
            ("UIView", "setHidden:", "v20@0:8B16", self.SEARCH_HIDDEN),
            (CONTROLLER, "relayoutHeaderView", "v16@0:8", self.LAYOUT_IMP),
            (CONTROLLER, "viewDidAppear:", "v20@0:8B16", self.HOST_GETTER),
            (CONTROLLER, SEARCH_ACTION, "v16@0:8", self.HOST_GETTER),
            (MANAGER, "shouldAddAiUsageView", "B16@0:8", self.HOST_GETTER),
            (MANAGER, "updateSubViews", "v16@0:8", self.HOST_GETTER),
            (CONFIG, "feedType", "q16@0:8", self.HOST_GETTER),
            (MODEL, "tabType", "i16@0:8", self.HOST_GETTER),
            (CONTROLLER, "tabModels", "@16@0:8", self.HOST_GETTER),
            (CONTROLLER, "currentTabModel", "@16@0:8", self.HOST_GETTER),
            (CONTROLLER, CATEGORY_SETUP, "v44@0:8@16q24B32q36", self.CATEGORY_NATIVE),
            (CONTROLLER, CATEGORY_REFRESH, "v40@0:8@16q24q32", self.CATEGORY_NATIVE),
            (CONTROLLER, CATEGORY_SELECTED, "v32@0:8@16q24", self.CATEGORY_NATIVE),
            (CONTROLLER, HEADER_SELECTED, "v24@0:8@16", self.HOST_GETTER),
            (CATEGORY_VIEW, "collectionView", "@16@0:8", self.HOST_GETTER),
            (CATEGORY_VIEW, "dataSource", "@16@0:8", self.HOST_GETTER),
            (CATEGORY_VIEW, "selectedIndex", "q16@0:8", self.HOST_GETTER),
            (CATEGORY_VIEW, "getTargetCellFrame:", "{CGRect={CGPoint=dd}{CGSize=dd}}24@0:8q16", self.HOST_GETTER),
            (CATEGORY_VIEW, CATEGORY_CELL, "@32@0:8@16@24", self.HOST_GETTER),
            (CATEGORY_BASE, CATEGORY_TAP, "v32@0:8@16@24", self.HOST_GETTER),
            (CATEGORY_BASE, CATEGORY_SIZE, "{CGSize=dd}40@0:8@16@24@32", self.HOST_GETTER),
            (CATEGORY_BASE, CATEGORY_SPACING, "d16@0:8", self.HOST_GETTER),
            ("NSIndexPath", "item", "q16@0:8", self.HOST_GETTER),
            ("UICollectionView", "cellForItemAtIndexPath:", "@24@0:8@16", self.HOST_GETTER),
            ("UICollectionView", "layoutAttributesForItemAtIndexPath:", "@24@0:8@16", self.HOST_GETTER),
            ("UICollectionView", "layoutIfNeeded", "v16@0:8", self.HOST_GETTER),
        ):
            self._add(self.classes[cls], selector, implementation, encoding)
        self.category_title_rows = 0
        self.category_writes = []
        self.category_inputs = []
        self.category_reenter = False
        self.category_taps = []
        self.category_paths = {}
        self.keep_stale_category_index = False
        self.search_actions = 0
        self.secondary_fill_style = "dark"
        self.native_title_models = release_version(data) in ("1.78R32", "1.78R33", "1.78R34", "1.78R35", "1.78R36", "1.79R1", "1.79R2", "1.79R3", "1.79R4", "1.79R5", "1.8R1", "1.8R2", "1.8R3", "1.8R4", "1.8R5", "1.8R6")
        if self.native_title_models:
            self._class("FQRJXCategoryTitleCellModel", "NSObject")
            self._add(self.classes["FQRJXCategoryTitleCellModel"], "isSelected", self.HOST_GETTER, "B16@0:8")

    def sync_title_selection(self, tabs, selected):
        """Model the native title-model update alongside each fixture commit.

        R32's independent header-state test deliberately disagrees these values;
        this broader visibility fixture continues to model synchronized commits.
        """
        if not self.native_title_models:
            return
        state = self.objects[tabs].state
        owner = self.objects[state["delegate"]].state
        models = self.objects[owner["tabModels"]].state["items"]
        current = self.objects[selected].state if selected else {}
        data_source = self.objects[state["dataSource"]].state["items"]
        cell_class = self.classes["FQRJXCategoryTitleCellModel"]
        if len(data_source) != len(models) or any(self.objects[item].cls != cell_class for item in data_source):
            data_source = [self.obj("FQRJXCategoryTitleCellModel", "native title selection", isSelected=False) for _ in models]
            state["dataSource"] = self.obj("NSArray", "native title models", items=data_source)
        for model, cell in zip(models, data_source):
            self.objects[cell].state["isSelected"] = bool(selected) and (
                model == selected or self.objects[model].state.get("tabType") == current.get("tabType"))

    def responds(self, receiver, name):
        if ((name == "allObjects" and self.is_kind(receiver, self.classes["NSHashTable"])) or
                (name == "stringValue" and self.is_kind(receiver, self.classes["NSNumber"]))):
            return True
        return super().responds(receiver, name)

    def handle(self, cpu, pc):
        receiver, selector = cpu.x[:2]
        name = self.selector_names.get(selector)
        if pc - self.slide == 0xa5d4:
            if receiver == self.classes["UIImageSymbolConfiguration"] and name == "configurationWithPointSize:weight:scale:":
                return self.finish(cpu, self.obj("UIImageSymbolConfiguration", "search config", size=cpu.fp(0)))
            if receiver == self.classes["UIImage"] and name == "systemImageNamed:withConfiguration:":
                config = self.objects[cpu.x[3]].state
                return self.finish(cpu, self.obj("UIImage", self.string_value(cpu.x[2]), symbolSize=config["size"]))
            if receiver in self.objects:
                state = self.objects[receiver].state
                if name == "setImage:" and self.is_kind(receiver, self.classes["UIButtonConfiguration"]):
                    state["image"] = cpu.x[2]
                    return self.finish(cpu)
                if name == "setContentInsets:" and self.is_kind(receiver, self.classes["UIButtonConfiguration"]):
                    state["contentInsets"] = tuple(cpu.fp(i) for i in range(4))
                    return self.finish(cpu)
                if name == "setAccessibilityLabel:" and self.is_kind(receiver, self.classes["UIButton"]):
                    state["accessibilityLabel"] = self.string_value(cpu.x[2])
                    return self.finish(cpu)
                if name == "addTarget:action:forControlEvents:" and self.selector_names.get(cpu.x[3]) == SEARCH_ACTION:
                    state["nativeSearchAction"] = tuple(cpu.x[2:5])
                    return self.finish(cpu)
                if name == "sendActionsForControlEvents:" and "nativeSearchAction" in state:
                    target, action, events = state["nativeSearchAction"]
                    if not (cpu.x[2] & events):
                        return self.finish(cpu)
                    cpu.x[0], cpu.x[1] = target, action
                    cpu.pc = self.HOST_GETTER
                    return True
                if name == "imageWithTintColor:renderingMode:":
                    return self.finish(cpu, receiver)
                if name == "contentMode" and "image" in state:
                    return self.finish(cpu, state["contentMode"])
                if name == "setContentMode:" and "image" in state:
                    state["contentMode"] = cpu.x[2]
                    return self.finish(cpu)
                if name == "setImage:" and "image" in state:
                    state["image"] = cpu.x[2]
                    return self.finish(cpu)
            if receiver == self.classes["NSIndexPath"] and name == "indexPathForItem:inSection:":
                item, section = cpu.x[2:4]
                if (item, section) not in self.category_paths:
                    self.category_paths[item, section] = self.obj("NSIndexPath", "native category position", item=item)
                return self.finish(cpu, self.category_paths[item, section])
            if receiver == self.classes["UIView"] and name == "new":
                return self.finish(cpu, self.view("UIView", "header selection"))
            if receiver == self.classes["UIColor"] and name == "colorWithWhite:alpha:":
                return self.finish(cpu, self.color("dark category selection"))
            if receiver == self.classes["UIColor"] and name == "secondarySystemFillColor":
                # UIKit's semantic color is the boundary: distinguish two
                # returned palette values without pretending to render traits.
                return self.finish(cpu, self.color("secondarySystemFillColor:" + self.secondary_fill_style))
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
            self.category_inputs.append(models)
            self.category_writes.append((name, tuple(entries), index, arg4, arg5))
            state.update(tabModels=models, currentTabModel=entries[index])
            tabs = state.get("simpleTabView")
            if tabs:
                self.objects[tabs].state.update(dataSource=models, selectedIndex=index)
                self.sync_title_selection(tabs, entries[index])
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
            if name == SEARCH_ICON_RETURN:
                self.reparent(state["icon"], state["slot"])
                self.objects[state["slot"]].state.update(hidden=True, alpha=0.)
                return self.finish(cpu)
            if name == SEARCH_ICON_VISIBILITY:
                search = self.objects[state["searchViewContainer"]].state
                self.objects[search["searchButtonSlotView"]].state.update(hidden=not cpu.x[2], alpha=float(cpu.x[2]))
                return self.finish(cpu)
            if name == SEARCH_TRANSITION:
                search = self.objects[state["searchViewContainer"]].state
                self.objects[search["searchButtonSlotView"]].state.update(hidden=False, alpha=0.)
                self.objects[search["searchButtonView"]].state["hidden"] = False
                return self.finish(cpu)
            if name == "viewDidAppear:":
                return self.finish(cpu)
            if name == SEARCH_ACTION:
                self.search_actions += 1
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
            if name == "getTargetCellFrame:":
                return self.finish(cpu, fp=state["cellFrames"][cpu.x[2]])
            if name == CATEGORY_SIZE:
                index = self.objects[cpu.x[4]].state["item"]
                return self.finish(cpu, fp=state["cellFrames"][index][2:])
            if name == CATEGORY_SPACING:
                return self.finish(cpu, fp=(10.,))
            if name == "layoutAttributesForItemAtIndexPath:":
                return self.finish(cpu, state.get("attributesByPath", {}).get(cpu.x[2], 0))
            if name == "cellForItemAtIndexPath:":
                return self.finish(cpu, state.get("cellsByPath", {}).get(cpu.x[2], 0))
            if name == CATEGORY_CELL:
                return self.finish(cpu, self.objects[cpu.x[2]].state["cellsByPath"][cpu.x[3]])
            if name == CATEGORY_TAP:
                self.category_taps.append(self.objects[cpu.x[3]].state["item"])
                return self.finish(cpu)
            if name == HEADER_SELECTED:
                state["currentTabModel"] = cpu.x[2]
                if not self.keep_stale_category_index:
                    self.objects[state["simpleTabView"]].state["selectedIndex"] = self.objects[cpu.x[2]].state["index"]
                self.sync_title_selection(state["simpleTabView"], cpu.x[2])
                return self.finish(cpu)
            return self.finish(cpu, int(state.get(name, 0)))
        if pc - self.slide == 0xa5d4 and name in (
            "headerView", "tabContainer", "searchViewContainer",
            "searchButtonSlotView", "searchButtonView", "searchBgView", "searchView",
            "vcContext", "config", "host", "simpleTabView",
        ) and receiver in self.objects:
            return self.finish(cpu, self.objects[receiver].state.get(name, 0))
        return super().handle(cpu, pc)


def exercise(data, labels):
    cpu, rt = make(data, Runtime)
    rt.labels = labels
    call(cpu, labels, "LFQH_FQHPageInstall")
    header = rt.view(HEADER, "drama header", (0., 62., 440., 60.))
    controller = rt.obj(CONTROLLER, "drama feed owner", headerView=header)
    simple_header = rt.view("UIView", "native nested header row", (12., 0., 416., 60.), header)
    categories = rt.view("UIView", "three category tabs", (8., 0., 140., 44.), simple_header)
    search = rt.view(SEARCH, "drama search container", (0., 0., 440., 44.), header)
    version = release_version(data)
    native_category_geometry = version in ("1.78R26", "1.78R27", "1.78R28", "1.78R29", "1.78R30", "1.78R31", "1.78R32", "1.78R33", "1.78R34", "1.78R35", "1.78R36", "1.79R1", "1.79R2", "1.79R3", "1.79R4", "1.79R5", "1.8R1", "1.8R2", "1.8R3", "1.8R4", "1.8R5", "1.8R6")
    unified_selection = version in ("1.78R27", "1.78R28", "1.78R29", "1.78R30", "1.78R31", "1.78R32", "1.78R33", "1.78R34", "1.78R35", "1.78R36", "1.79R1", "1.79R2", "1.79R3", "1.79R4", "1.79R5", "1.8R1", "1.8R2", "1.8R3", "1.8R4", "1.8R5", "1.8R6")
    regular_header_material = version in ("1.78R34", "1.78R35", "1.78R36", "1.79R1", "1.79R2", "1.79R3", "1.79R4", "1.79R5", "1.8R1", "1.8R2", "1.8R3", "1.8R4", "1.8R5", "1.8R6")
    safe_area_header = version in ("1.8R1", "1.8R2", "1.8R3", "1.8R4", "1.8R5", "1.8R6")
    search_y = 4. if safe_area_header else 1.
    category_regressions = []
    synchronized_search = version in ("1.78R22", "1.78R25", "1.78R26", "1.78R27", "1.78R28", "1.78R29", "1.78R30", "1.78R31", "1.78R32", "1.78R33", "1.78R34", "1.78R35", "1.78R36", "1.79R1", "1.79R2", "1.79R3", "1.79R4", "1.79R5", "1.8R1", "1.8R2", "1.8R3", "1.8R4", "1.8R5", "1.8R6")
    anchored_search = version in {"1.78R21", "1.78R22", "1.78R25", "1.78R26", "1.78R27", "1.78R28", "1.78R29", "1.78R30", "1.78R31", "1.78R32", "1.78R33", "1.78R34", "1.78R35", "1.78R36", "1.79R1", "1.79R2", "1.79R3", "1.79R4", "1.79R5", "1.8R1", "1.8R2", "1.8R3", "1.8R4", "1.8R5", "1.8R6"}
    compact_header = version in {"1.78R20", "1.78R21", "1.78R22", "1.78R25", "1.78R26", "1.78R27", "1.78R28", "1.78R29", "1.78R30", "1.78R31", "1.78R32", "1.78R33", "1.78R34", "1.78R35", "1.78R36", "1.79R1", "1.79R2", "1.79R3", "1.79R4", "1.79R5", "1.8R1", "1.8R2", "1.8R3", "1.8R4", "1.8R5", "1.8R6"}
    search_stock_frame = (402., 8., 26., 26.) if compact_header else (392., 0., 44., 44.)
    slot = rt.view("UIView", "native magnifier slot", search_stock_frame, search)
    image = rt.obj("UIImage", "app magnifier")
    icon = rt.view("UIImageView", "native magnifier", (0., 0., 26., 26.) if compact_header else (9., 9., 26., 26.),
                   slot, image=image, contentMode=0, nativeAction="search")
    bar = rt.view("UIView", "fresh find-drama search background")
    always_visible_search = version in {"1.78R19", "1.78R20", "1.78R21", "1.78R22", "1.78R25", "1.78R26", "1.78R27", "1.78R28", "1.78R29", "1.78R30", "1.78R31", "1.78R32", "1.78R33", "1.78R34", "1.78R35", "1.78R36", "1.79R1", "1.79R2", "1.79R3", "1.79R4", "1.79R5", "1.8R1", "1.8R2", "1.8R3", "1.8R4", "1.8R5", "1.8R6"}
    first_frame_checked = version in {"1.78R15", "1.78R16", "1.78R17", "1.78R18", "1.78R19", "1.78R20", "1.78R21", "1.78R22", "1.78R25", "1.78R26", "1.78R27", "1.78R28", "1.78R29", "1.78R30", "1.78R31", "1.78R32", "1.78R33", "1.78R34", "1.78R35", "1.78R36", "1.79R1", "1.79R2", "1.79R3", "1.79R4", "1.79R5", "1.8R1", "1.8R2", "1.8R3", "1.8R4", "1.8R5", "1.8R6"}
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

    def material(view):
        return next((child for child in rt.objects[view].state["subviews"]
                     if rt.objects[child].state.get("configuration") or
                     (rt.is_kind(child, rt.classes["UIVisualEffectView"]) and rt.objects[child].state.get("effect"))), 0)

    def selections(group):
        parent = rt.objects[group].state["contentView"] if regular_header_material else group
        return rt.objects[parent].state["subviews"]

    search_surface = header if anchored_search else slot

    def search_shown():
        return bool(material(header)) if anchored_search else not hidden(slot)

    def native_declares():
        return bool(send(cpu, rt, manager, "shouldAddAiUsageView")["result"])

    if anchored_search:
        options[SEARCH_KEY] = True
        send(cpu, rt, header, "setupSubViews")
        require(search_shown() != synchronized_search and hidden(slot) and hidden(icon),
                "The saved search option honors first-header readiness")

    if first_frame_checked:
        options.update({CATEGORIES_KEY: False, SEARCH_KEY: False})
        send(cpu, rt, header, "setupSubViews")
        require(hidden(categories) and hidden(slot) and hidden(bar),
                "Saved switches hide both search forms before mounting")
        overlay = rt.view("UIView", "cold-start search overlay", (0., 0., 440., 956.), rt.ROOT)
        coordinator = rt.obj(COORDINATOR, "native search coordinator", host=controller, icon=icon, overlay=overlay, slot=slot)
        send(cpu, rt, coordinator, "prepareColdStartSearchButtonIfNeeded")
        require(rt.objects[icon].state["superview"] == slot,
                "A disabled magnifier never enters the cold-start overlay")
        del options[SEARCH_KEY]
        send(cpu, rt, coordinator, "prepareColdStartSearchButtonIfNeeded")
        require(rt.objects[icon].state["superview"] == (slot if anchored_search else overlay),
                "The stock fly-in is only used when the magnifier is not anchored to the header")
        if anchored_search:
            require(not search_shown(), "Cold-start preparation leaves drawing to the mounted header lifecycle")
        elif always_visible_search:
            send(cpu, rt, coordinator, SEARCH_ICON_RETURN)
            require(rt.objects[icon].state["superview"] == slot and not hidden(slot) and
                    rt.objects[slot].state["alpha"] == 1., "The returned native search icon is visible after its cold-start move")
        else:
            rt.reparent(icon, slot)
        del options[CATEGORIES_KEY]

    rt.reparent(header, rt.ROOT)
    send(cpu, rt, header, "didMoveToWindow")
    require(not hidden(categories) and search_shown() != synchronized_search and
            hidden(bar) == first_frame_checked and native_declares(),
            "Header attachment keeps loading search aligned with category readiness")
    if synchronized_search:
        send(cpu, rt, controller, "viewDidAppear:", 1)
        require(not search_shown() and hidden(slot) and hidden(icon),
                "Feed appearance with a pending title row cannot reveal either search surface")

    glass_checked = version in {"1.78R17", "1.78R18", "1.78R19", "1.78R20", "1.78R21", "1.78R22", "1.78R25", "1.78R26", "1.78R27", "1.78R28", "1.78R29", "1.78R30", "1.78R31", "1.78R32", "1.78R33", "1.78R34", "1.78R35", "1.78R36", "1.79R1", "1.79R2", "1.79R3", "1.79R4", "1.79R5", "1.8R1", "1.8R2", "1.8R3", "1.8R4", "1.8R5", "1.8R6"}
    if glass_checked:
        models = [rt.obj(MODEL, f"category {index}", index=index, tabType=kind)
                  for index, kind in enumerate((7, 11, 103))]
        rows = rt.obj("NSArray", "native category data source", items=models)
        tabs = rt.view(CATEGORY_VIEW, "native category selection targets", (0., 0., 140., 44.), categories,
                       delegate=controller, dataSource=rows, selectedIndex=0, cellFrames=[(8., 0., 36., 44.),
                       (54., 0., 36., 44.), (100., 0., 32., 44.)])
        collection = rt.view("UICollectionView", "native category collection", (0., 0., 140., 44.), tabs)
        rt.objects[tabs].state["collectionView"] = collection
        rt.objects[controller].state.update(simpleTabView=tabs, tabModels=rows, currentTabModel=models[0])
        rt.sync_title_selection(tabs, models[0])

        send(cpu, rt, controller, "relayoutHeaderView")
        group, search_glass = material(categories), material(search_surface)
        require(group and search_glass and rt.objects[categories].state["subviews"] == [group, tabs],
                "One category capsule sits behind native category controls")
        if anchored_search:
            state = rt.objects[search_glass].state
            search_config = rt.objects[state["configuration"]].state
            require(rt.objects[header].state["subviews"][-1] == search_glass and hidden(slot) and hidden(icon) and
                    state["frame"] == (386., search_y, 42., 42.) and rt.origin(search_glass)[1] == rt.origin(group)[1] and
                    search_config["contentInsets"] == (0., 0., 0., 0.) and rt.objects[search_config["image"]].state["symbolSize"] == 23. and
                    state["accessibilityLabel"] == "搜索", "The anchored search button contains its own centered glass and glyph")
            if safe_area_header:
                rt.objects[rt.ROOT].state["safeAreaInsets"] = (62., 0., 34., 0.)
                category_state = rt.objects[categories].state
                x, _, width, height = category_state["frame"]
                category_state["frame"] = (x, 24., width, height)
                for _ in range(2):
                    send(cpu, rt, controller, "relayoutHeaderView")
                require(rt.origin(group)[1] == rt.origin(search_glass)[1] == 66.,
                        "A lower native category row moves to the window safe area without accumulating offsets")
                category_regressions.append("two relayouts align the search button and category row to the safe area")
            original_icon = rt.objects[icon].state
            original_icon.update(frame=(-9., -9., 24., 24.), bounds=(0., 0., 24., 24.))
            rt.objects[slot].state.update(frame=(418., 10., 24., 24.), bounds=(0., 0., 24., 24.), hidden=False, alpha=0.)
            rt.reparent(icon, overlay)
            send(cpu, rt, header, SEARCH_TRANSITION, 1)
            for _ in range(2):
                send(cpu, rt, controller, "viewDidAppear:", 1)
            require(material(header) == search_glass and state["frame"] == (386., search_y, 42., 42.) and hidden(icon) and hidden(slot) and
                    sum(bool(rt.objects[view].state.get("configuration")) for view in rt.objects[header].state["subviews"]) == 1,
                    "Late stock geometry, a reparented stock image, and re-entry preserve one fully visible button without toggles")
            send(cpu, rt, search_glass, "sendActionsForControlEvents:", 64)
            require(rt.search_actions == 1, "The new button dispatches one call to the native search action")
            rt.reparent(icon, slot)
            rt.objects[slot].state.update(frame=search_stock_frame, bounds=(0., 0., 26., 26.))
        else:
            require(rt.objects[slot].state["subviews"] == [search_glass, icon] and
                    all(not rt.objects[glass].state["userInteractionEnabled"] for glass in (group, search_glass)) and
                    rt.objects[search_glass].state["frame"] == ((0., 0., 42., 42.) if compact_header else (1., 1., 42., 42.)),
                    "Search glass follows the native glyph and both backings pass through touches")
        if compact_header and not anchored_search:
            icon_state = rt.objects[icon].state
            require(rt.origin(search_glass)[1] == rt.origin(group)[1] and rt.origin(search_glass)[0] + 42. == 428. and
                    icon_state["frame"] == (0., 0., 42., 42.) and icon_state["nativeAction"] == "search" and
                    rt.objects[icon_state["image"]].state["symbolSize"] == 23.,
                    "Both materials share the centerline, and the original full-circle search target displays its larger glyph")
        lens, = selections(group)
        if unified_selection:
            if regular_header_material:
                state = rt.objects[group].state
                effect = rt.objects[state["effect"]]
                require(rt.is_kind(group, rt.classes["UIVisualEffectView"]) and
                        effect.cls == rt.classes["UIGlassEffect"] and effect.state["style"] == 0 and
                        effect.state["interactive"] and not effect.state.get("tintColor"),
                        "The category uses the dock's untinted Regular UIGlassEffect")
                require(state["backgroundColor"] == rt.color("clearColor") and
                        rt.objects[state["contentView"]].state["backgroundColor"] == rt.color("clearColor") and
                        rt.objects[lens].state["superview"] == state["contentView"],
                        "The selection sits in the effect contentView with both backdrops clear")
                require(not state["userInteractionEnabled"] and state["accessibilityElementsHidden"] and
                        not state["isAccessibilityElement"] and not state["opaque"],
                        "The material remains transparent and passes native input and accessibility through")
                category_regressions.append("Regular dock material with clear content and native input preserved")
            else:
                require(rt.is_kind(group, rt.classes["UIButton"]) and
                        rt.objects[lens].state["superview"] == group,
                        "The historical selection attaches to the real glass UIButton")
            require(not rt.objects[lens].state["userInteractionEnabled"] and
                    rt.objects[lens].state["accessibilityElementsHidden"] and
                    rt.objects[lens].state["clipsToBounds"],
                    "Selection decoration keeps native input/accessibility and clips its capsule")
            for style in ("light", "dark"):
                rt.secondary_fill_style = style
                send(cpu, rt, header, "layoutSubviews")
                require(rt.objects[lens].state["backgroundColor"] == rt.color("secondarySystemFillColor:" + style),
                        "Header refresh uses the current system fill value, not a cached fixed black color")
            expected_slots = ((4., 4., 47., 34.), (51., 4., 45., 34.), (96., 4., 44., 34.))
            for model, expected in zip(models, expected_slots):
                send(cpu, rt, controller, HEADER_SELECTED, model)
                require(rt.objects[lens].state["frame"] == expected and
                        rt.objects[rt.layer(lens)].state["cornerRadius"] == 17.,
                        "Selected fill spans the full neighboring-center slot with four-point capsule insets")
            send(cpu, rt, controller, HEADER_SELECTED, models[0])
            category_regressions.append("semantic system fill refresh and full-width selection slots")
        if always_visible_search:
            send(cpu, rt, header, SEARCH_ICON_VISIBILITY, 0, fp=(0.,))
            x, _, width, _ = rt.objects[group].state["frame"]
            require(rt.origin(categories)[0] + x + width / 2 == 220. and search_shown() and
                    (anchored_search or rt.objects[slot].state["alpha"] == 1.) and material(search_surface) == search_glass,
                    "Native search fades leave enabled search visible and the native title strip centered")
        first_x = rt.objects[lens].state["frame"][0]
        send(cpu, rt, controller, HEADER_SELECTED, models[2])
        require(rt.objects[lens].state["frame"][0] > first_x and rt.objects[tabs].state["selectedIndex"] == 2,
                "The selected pill follows the native selection callback")
        if native_category_geometry:
            # Playback has committed 推荐 while the separate title strip still
            # carries its earlier 看剧 index. This is the reported mismatch.
            rt.keep_stale_category_index = True
            send(cpu, rt, controller, HEADER_SELECTED, models[0])
            require(rt.objects[lens].state["frame"][0] == first_x and
                    rt.objects[tabs].state["selectedIndex"] == 2,
                    "The pill follows the committed feed model without rewriting a stale title-strip index")
            category_regressions.append("committed model wins over stale title-strip index")

            # A horizontal page transition may commit its model before another
            # controller callback; header layout must redraw that same selection.
            rt.objects[controller].state["currentTabModel"] = models[1]
            rt.sync_title_selection(tabs, models[1])
            send(cpu, rt, header, "layoutSubviews")
            middle_x = rt.objects[lens].state["frame"][0]
            require(first_x < middle_x < 96. and rt.objects[tabs].state["selectedIndex"] == 2,
                    "Header layout refreshes the current feed selection after paging")
            replacement = rt.obj(MODEL, "replacement current model", tabType=11, index=1)
            rt.objects[controller].state["currentTabModel"] = replacement
            rt.sync_title_selection(tabs, replacement)
            send(cpu, rt, header, "layoutSubviews")
            require(rt.objects[lens].state["frame"][0] == middle_x,
                    "A replaced current model resolves the same native tab type")
            category_regressions.append("layout and replaced models preserve visible-page selection")

            # Reproduce a native container whose bounds still reflect an older
            # content-size callback. The last item's real layout ends at x=132.
            category_state = rt.objects[categories].state
            x, y, _, height = category_state["frame"]
            category_state.update(frame=(x, y, 96., height), bounds=(0., 0., 96., 44.))
            rt.objects[controller].state["currentTabModel"] = models[2]
            rt.sync_title_selection(tabs, models[2])
            send(cpu, rt, header, "layoutSubviews")
            gx, _, gw, _ = rt.objects[group].state["frame"]
            lx, _, lw, _ = rt.objects[lens].state["frame"]
            require(gx == -2. and gx + gw == 142. and gx + lx + lw == (138. if unified_selection else 130.),
                    "The capsule and selection fully cover the last item beyond stale container bounds")
            require(not rt.objects[group].state["userInteractionEnabled"],
                    "The category material leaves native touch dispatch in control")
            x, y, _, height = category_state["frame"]
            category_state.update(frame=(x, y, 140., height), bounds=(0., 0., 140., 44.))
            send(cpu, rt, header, "layoutSubviews")
            category_regressions.append("last item remains fully covered with stale container width")

            paths = [send(cpu, rt, rt.classes["NSIndexPath"], "indexPathForItem:inSection:", index, 0)["result"]
                     for index in range(3)]
            native_widths = []
            for path in paths:
                send(cpu, rt, tabs, CATEGORY_SIZE, collection, 0, path)
                native_widths.append(cpu.fp(0))
                send(cpu, rt, tabs, CATEGORY_TAP, collection, path)
            send(cpu, rt, tabs, CATEGORY_SPACING)
            require(native_widths == [36., 36., 32.] and cpu.fp(0) == 10. and rt.category_taps == [0, 1, 2],
                    "Visible cell widths, spacing and all native click indices are unchanged")
            rt.category_taps.clear()
            rt.keep_stale_category_index = False
            category_regressions.append("native cell sizing spacing and click indices preserved")
        options[SEARCH_KEY] = False
        send(cpu, rt, controller, "relayoutHeaderView")
        x, _, width, _ = rt.objects[group].state["frame"]
        require(rt.origin(categories)[0] + x + width / 2 == 220. and not material(search_surface),
                "The interactive category capsule centers when only search is off")
        options[SEARCH_KEY] = True
        send(cpu, rt, controller, "relayoutHeaderView")
        expected_center = 220. if always_visible_search else 12. + 8. + x + width / 2
        require(rt.origin(categories)[0] + x + width / 2 == expected_center and
                material(categories) == group and material(search_surface),
                "Re-enabling search preserves the intended category position and reuses its capsule")
        if compact_header:
            options["FanqieX.DramaCategory.11.1"] = False
            paths = [send(cpu, rt, rt.classes["NSIndexPath"], "indexPathForItem:inSection:", index, 0)["result"]
                     for index in range(3)]
            attributes = {}
            x = 8.
            widths = []
            send(cpu, rt, tabs, CATEGORY_SPACING)
            spacing = cpu.fp(0)
            for path in paths:
                send(cpu, rt, tabs, CATEGORY_SIZE, collection, 0, path)
                width, height = cpu.fp(0), cpu.fp(1)
                widths.append(width)
                attributes[path] = rt.obj("UICollectionViewLayoutAttributes", "native flow geometry",
                                          frame=(x, 0., width, height))
                x += width + spacing
            send(cpu, rt, tabs, CATEGORY_SPACING)
            expected_widths = [36., 0.5, 32.] if native_category_geometry else [48., 0.5, 44.]
            require(widths == expected_widths and cpu.fp(0) == (10. if native_category_geometry else 0.),
                    "Hiding the middle category collapses its width with the intended flow spacing")
            state = rt.objects[collection].state
            state["attributesByPath"] = attributes
            send(cpu, rt, controller, "relayoutHeaderView")
            x, _, width, _ = rt.objects[group].state["frame"]
            require(width == sum(widths) + 2 * spacing + 20. and rt.origin(categories)[0] + x + width / 2 == 220.,
                    "The compact capsule keeps ten points of inset on both ends and stays centered")
            if unified_selection:
                for model, expected in ((models[0], (4., 4., 51.25, 34.)),
                                        (models[2], (55.25, 4., 49.25, 34.))):
                    rt.objects[controller].state["currentTabModel"] = model
                    rt.sync_title_selection(tabs, model)
                    send(cpu, rt, header, "layoutSubviews")
                    require(rt.objects[lens].state["frame"] == expected,
                            "A hidden middle label is skipped when choosing adjacent visible slot boundaries")
                require(rt.objects[tabs].state["selectedIndex"] == 2,
                        "Selection decoration does not mutate the native title index")
                unmatched = rt.obj(MODEL, "unmatched committed page", tabType=999, index=2)
                for model in (models[1], unmatched, 0):
                    rt.objects[controller].state["currentTabModel"] = model
                    rt.sync_title_selection(tabs, model)
                    send(cpu, rt, header, "layoutSubviews")
                    require(hidden(lens) and rt.objects[tabs].state["selectedIndex"] == 2,
                            "Hidden, unknown or absent committed models never fall back to the stale native index")
                rt.objects[controller].state["currentTabModel"] = models[2]
                rt.sync_title_selection(tabs, models[2])
                send(cpu, rt, header, "layoutSubviews")
                require(not hidden(lens), "Restoring the committed visible model restores its selection fill")
                category_regressions.append("hidden neighbors skipped; hidden or missing current model never falls back")
            del options["FanqieX.DramaCategory.11.1"]
            del state["attributesByPath"]
        options["FanqieAdBlock.GlassDisabled.1"] = True
        send(cpu, rt, controller, "relayoutHeaderView")
        require(not material(categories) and not material(search_surface) and not hidden(categories) and not hidden(slot),
                "Turning off glass restores native appearances and preserves controls")
        require(rt.objects[categories].state["frame"][0] == 8., "Disabling glass restores the native category frame")
        if compact_header:
            require(rt.objects[slot].state["frame"] == search_stock_frame and rt.objects[icon].state["image"] == image,
                    "Turning off glass restores native search art and slot size")
        del options["FanqieAdBlock.GlassDisabled.1"]

    for flags in range(8):
        show_categories, show_search, show_author = (bool(flags & bit) for bit in (1, 2, 4))
        options.update({CATEGORIES_KEY: show_categories, SEARCH_KEY: show_search, AUTHOR_KEY: show_author})
        send(cpu, rt, header, "updateTabViewWithContentSize:", fp=(140., 44.))
        require(hidden(categories) != show_categories and search_shown() == show_search,
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
    require(search_shown() and hidden(bar) == first_frame_checked,
            "Restoring the magnifier keeps the full Find Drama field hidden")
    rt.objects[slot].state["hidden"] = True
    options[SEARCH_KEY] = False
    send(cpu, rt, controller, "relayoutHeaderView")
    options[SEARCH_KEY] = True
    send(cpu, rt, controller, "relayoutHeaderView")
    require(hidden(slot) == (anchored_search or not always_visible_search) and
            (not anchored_search or search_shown()), "The search switch controls the current search appearance")

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
    if version in {"1.78R16", "1.78R17"}:
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

    if version in {"1.78R18", "1.78R19", "1.78R20", "1.78R21", "1.78R22", "1.78R25", "1.78R26", "1.78R27", "1.78R28", "1.78R29", "1.78R30", "1.78R31", "1.78R32", "1.78R33", "1.78R34", "1.78R35", "1.78R36", "1.79R1", "1.79R2", "1.79R3", "1.79R4", "1.79R5", "1.8R1", "1.8R2", "1.8R3", "1.8R4", "1.8R5", "1.8R6"}:
        titles = ["推荐", "漫剧", "看剧"]
        source = [rt.obj(MODEL, title, tabType=kind, title=rt.text_object(title), index=index)
                  for index, (kind, title) in enumerate(zip((7, 11, 103), titles))]
        all_models = rt.obj("NSArray", "complete server categories", items=source)
        controller_state = rt.objects[controller].state
        paths = [send(cpu, rt, rt.classes["NSIndexPath"], "indexPathForItem:inSection:", index, 0)["result"]
                 for index in range(3)]
        cells = [rt.view("UICollectionViewCell", title, rt.objects[tabs].state["cellFrames"][index], collection)
                 for index, title in enumerate(titles)]
        collection_state = rt.objects[collection].state
        native_path_cells = dict(zip(paths, cells))
        collection_state["cellsByPath"] = native_path_cells
        options[CATEGORIES_KEY] = True
        options["FanqieX.DramaCategory.7.1"] = False
        send(cpu, rt, controller, CATEGORY_SETUP, all_models, 0, 1, 16)
        require(rt.category_inputs[-1] == all_models and rt.category_writes[-1] == (CATEGORY_SETUP, tuple(source), 0, 1, 16),
                "Cold start passes the exact server models and 推荐 selected index even with its button disabled")
        rows = rt.native(rt.category_title_rows)
        require([row["title"] for row in rows] == titles,
                "Settings discover every title including disabled categories")
        require([hidden(cell) for cell in cells] == [True, False, False],
                "Only the disabled native label disappears even while its video keeps the native selection")
        group = material(categories)
        require(group and rt.objects[group].state["frame"][0] > 8. and
                all(hidden(child) for child in selections(group)),
                "Glass begins at the first visible category and omits the hidden active tab lens")
        category_cases.append("saved hidden button leaves the default playback tab intact")

        send(cpu, rt, tabs, CATEGORY_TAP, collection, paths[0])
        send(cpu, rt, tabs, CATEGORY_TAP, collection, paths[2])
        require(rt.category_taps == [2], "Hidden category taps stop while visible taps retain their exact native index")
        native_path_cells[paths[2]] = cells[0]
        send(cpu, rt, tabs, CATEGORY_CELL, collection, paths[2])
        require(not hidden(cells[0]), "A previously hidden cell is restored when reused for a visible category")
        native_path_cells[paths[2]] = cells[2]
        send(cpu, rt, tabs, CATEGORY_CELL, collection, paths[0])
        require(hidden(cells[0]), "The same cell is hidden when configured again for the disabled category")
        category_cases.append("cell reuse restores the visible category and hidden taps are ignored")

        def select(tag, enabled):
            rt.objects[switch].state.update(tag=tag, isOn=enabled)
            call(cpu, labels, "LFQH_FQHBottomOptionChanged178", settings, action, switch)

        writes = len(rt.category_writes)
        select(1007, True)
        require(not hidden(cells[0]) and any(not hidden(child) for child in selections(group)),
                "The live toggle restores the title and the original selected lens")
        select(1007, False)
        require(hidden(cells[0]), "Disabling an individual category hides its already visible cell immediately")
        select(21, False)
        require(hidden(categories), "The master switch hides the category row")
        select(21, True)
        require(not hidden(categories), "Restoring the master switch reveals remaining category buttons")
        require(len(rt.category_writes) == writes and controller_state["tabModels"] == all_models and
                controller_state["currentTabModel"] == source[0],
                "Live individual and master changes leave the currently playing 推荐 tab on the native controller")
        category_cases.append("individual and master hide and restore do not refresh feed data")

        for tag in (1011, 1103):
            select(tag, False)
        require(hidden(categories) and len(rt.category_writes) == writes and controller_state["currentTabModel"] == source[0],
                "Hiding the final button collapses the header without reselecting or rebuilding the active feed")
        select(1103, True)
        require(not hidden(categories) and len(rt.category_writes) == writes,
                "Restoring a single different category does not move playback to that tab")
        category_cases.append("all buttons hidden preserves the active feed")

        new_order = (source[2], source[0], source[1])
        reordered = rt.obj("NSArray", "new native server order", items=list(new_order))
        send(cpu, rt, controller, CATEGORY_REFRESH, reordered, 1, 17)
        require(rt.category_inputs[-1] == reordered and rt.category_writes[-1][:4] == (CATEGORY_REFRESH, new_order, 1, 17),
                "Native refresh receives unfiltered ordering, server index and reason")
        send(cpu, rt, controller, CATEGORY_SELECTED, reordered, 2)
        require(rt.category_inputs[-1] == reordered and rt.category_writes[-1][:3] == (CATEGORY_SELECTED, new_order, 2),
                "Selected-model refresh preserves its own callback and exact original arguments")
        category_cases.append("reordered refresh and selected-model callback preserve host indices")

    if synchronized_search:
        options.update({CATEGORIES_KEY: False, SEARCH_KEY: True})
        search_only_header = rt.view(HEADER, "fresh search-only header", (0., 62., 440., 60.))
        search_only_feed = rt.obj(CONTROLLER, "fresh search-only feed", headerView=search_only_header)
        rt.objects[search_only_header].state["delegate"] = search_only_feed
        send(cpu, rt, search_only_header, "setupSubViews")
        rt.reparent(search_only_header, rt.ROOT)
        send(cpu, rt, search_only_header, "didMoveToWindow")
        require(not material(search_only_header), "Search-only headers wait for the feed lifecycle")
        send(cpu, rt, search_only_feed, "viewDidAppear:", 1)
        button = material(search_only_header)
        require(button and rt.objects[button].state["frame"] == (386., 4. if safe_area_header else 9., 42., 42.),
                "Search is accessible when the master category switch is off")
        options[SEARCH_KEY] = False
        send(cpu, rt, search_only_feed, "viewDidAppear:", 1)
        require(not material(search_only_header), "The saved OFF state stays hidden after feed appearance")

    return {"independent_combinations": 8, "native_hidden_state_unchanged": True,
            "independent_category_cases": category_cases,
            "category_selection_geometry_regressions": category_regressions,
            "unified_selection_palette_and_slots_checked": unified_selection,
            "header_glass_and_search_centering_checked": glass_checked,
            "native_search_fade_and_return_checked": always_visible_search,
            "matching_search_and_compact_categories_checked": compact_header,
            "anchored_search_reentry_and_action_checked": anchored_search,
            "first_search_reveal_synchronized": synchronized_search,
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
    require(release_version(data) in ("1.78R7", "1.78R8", "1.78R9", "1.78R10", "1.78R11", "1.78R12", "1.78R13", "1.78R14", "1.78R15", "1.78R16", "1.78R17", "1.78R18", "1.78R19", "1.78R20", "1.78R21", "1.78R22", "1.78R25", "1.78R26", "1.78R27", "1.78R28", "1.78R29", "1.78R30", "1.78R31", "1.78R32", "1.78R33", "1.78R34", "1.78R35", "1.78R36", "1.79R1", "1.79R2", "1.79R3", "1.79R4", "1.79R5", "1.8R1", "1.8R2", "1.8R3", "1.8R4", "1.8R5", "1.8R6"),
            "Use the 1.78R7 or later candidate")
    labels = labels_for(data, args.candidate.with_suffix(".composed.s"),
                        EXTRA + ["LFQH_FQHBottomOptionChanged178"])
    report = {"passed": True, "candidate_sha256": hashlib.sha256(data).hexdigest(), **exercise(data, labels)}
    args.report.write_text(json.dumps(report, indent=2) + "\n", encoding="utf-8")
    print(json.dumps(report, indent=2))


if __name__ == "__main__":
    main()
