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
from top_chrome_runtime import TopChromeRuntime

ROOT = Path(__file__).resolve().parents[1]
EXTRA = [
    "LFQH_FQHPageInstall", "LFQH_FQHPageStyle", "LFQH_FQHPageTint",
    "LFQH_FQHInstallOptionsToggles", "LFQH_FQHPageFilterMiniGame",
    "LFQH_FQHSurface", "LFQH_FQHIconGlass", "Lrecord_named", "LGstyle_control", "LGshelf_material",
]
HOOKS = [
    ("SSReaderFanClubEntryContainerView", "layoutSubviews"),
    ("FQReaderUIManager", "showBottomBarContainer:"),
    ("FQReaderUIManager", "onConfigThemeChange:context:"),
    ("FQReaderUIManager", "refreshBottomToolbarInsertView"),
    ("SSReaderCommunityBottomToolbarItemView", "layoutSubviews"),
    ("FQReaderSaaSBottomToolView", "layoutSubviews"),
    ("FQReaderSaaSNewProgressView", "layoutSubviews"),
    ("FQReaderSaaSNewProgressView", "updateWithConfigData:"),
    ("SSReaderBottomToolDivertView", "layoutSubviews"),
    ("SSReaderGiftView", "layoutSubviews"),
    ("SSReaderBookEndUserGiftView", "layoutSubviews"),
    ("SSReaderCoverTopRightView", "layoutSubviews"),
    ("FQReaderCoverMainContentViewController", "setupGuideView"),
    ("FQReaderCoverMainContentViewController", "viewDidLayoutSubviews"),
    ("SSReaderChapterEndDiscussionEntranceView", "layoutSubviews"),
    ("SSReaderChapterEndDiscussionEntranceButton", "layoutSubviews"),
    ("SSReaderChapterEndCommunityCardView", "layoutSubviews"),
    ("SSReaderChapterEndCommunityCardView", "updateWithReaderConfig:"),
    ("SSReaderChapterEndBaseButton", "layoutSubviews"),
    ("SSReaderChapterEndRewardButton", "updateWithThemeConfigChange:"),
    ("SSBookShelfTabSelectViewTitleCell", "layoutSubviews"),
    ("SSBookShelfTabSelectViewTitleCell", "reloadData:"),
    ("SSBookShelfFilter541Cell", "layoutSubviews"),
    ("SSBookShelfFilter541Cell", "updateAppearance:"),
    ("SSBookShelfFilter541Cell", "updateCellBgColor:"),
    ("SSBookShelfFilterHeaderView", "layoutSubviews"),
    ("SSBookShelfFilterMixRowCollectionView", "collectionView:layout:insetForSectionAtIndex:"),
    ("SS525BookShelfSubHeaderView", "setShowReadTimeView:"),
    ("SS525BookShelfSubHeaderView", "layoutSubviews"),
    ("SS525BookShelfSubHeaderView", "layoutEditButton"),
    ("SSBookShelfSubViewController", "collectionView:layout:sizeForItemAtIndexPath:"),
    ("SSBookShelfSubViewController", "collectionView:layout:insetForSectionAtIndex:"),
    ("SSBookShelfSubViewController", "saveOpeningData:indexPath:"),
    ("SSBookShelfSubViewController", "fetchBookCoverTransitionInfo:"),
    ("SSBookShelfFunctionCell", "layoutContainerSubviews"),
    ("SSMyUserBar", "layoutSubviews"),
    ("SSMyUser621BaseViewController", "updateCollectionLayout"),
    ("SSMyUserCollectionViewFunCell", "layoutSubviews"),
    ("SSMyUserCollectionViewOrderFunCell", "layoutSubviews"),
    ("SSMyUser621BaseViewController", "setupCellMiniGameEntranceData"),
    ("SSMyUserCell2Model", "applyConfiguredMineEcomEntranceData:mineMonetizationStyle:"),
    ("SSMyUser621ViewController", "objectsForListAdapter:"),
    ("SSTabBarController", "tabbarVCAndAttributeInit"),
    ("SSTabBarController", "viewDidAppear:"),
]


class Runtime(TopChromeRuntime, GlassRuntime):
    SHELF_RELOAD = 0x330c1000
    SHELF_APPEARANCE = 0x330c1100
    SHELF_BACKGROUND = 0x330c1200
    BOTTOM_ORIGINAL = 0x330c0000
    CATALOG_CLICK = 0x330c0008
    TAB_PLAN = 0x330c0100
    TAB_APPEAR = 0x330c0200
    TAB_OPEN_OPTIONS = 0x330c0d00
    SHELF_DURATION_VISIBLE = 0x330c3100
    SHELF_FUNCTION_SIZE = 0x330c3110
    SHELF_FUNCTION_LAYOUT = 0x330c3120
    SHELF_EDIT_LAYOUT = 0x330c3130
    SHELF_FUNCTION_HEIGHT = 0x330c3140
    SHELF_FUNCTION_INSETS = 0x330c3150
    SHELF_INLINE_FILTER_INSETS = 0x330c3160
    SHELF_SAVE_OPENING = 0x330c3170
    SHELF_COVER_TRANSITION = 0x330c3180
    SHELF_FILTER_HEADER_LAYOUT = 0x330c3190
    MODEL_INVISIBLE = 0x330c0300
    MODEL_DISABLED = 0x330c0400
    MODEL_REMOVE = 0x330c0500
    MODEL_SETUP = 0x330c0600
    MODEL_CONFIGURED_GAME = 0x330c2400
    MODEL_LIST_OBJECTS = 0x330c2500
    MINE_ORDER_LAYOUT = 0x330c2600
    SPEECH_THEME = 0x330c0700
    PROGRESS_THEME = 0x330c0b00
    CHAPTER_CARD_THEME = 0x330c0b40
    CHAPTER_REWARD_THEME = 0x330c0b50
    READER_MENU_SHOW = 0x330c0b10
    READER_MENU_THEME = 0x330c0b20
    READER_COMMUNITY_REFRESH = 0x330c0b70

    def __init__(self, data):
        super().__init__(data)
        for name, parent in (
            ("FQReaderUIManager", "NSObject"),
            ("BDReaderViewContainer", "UIView"),
            ("BDReaderTopViewContainer", "BDReaderViewContainer"),
            ("BDReaderBottomViewContainer", "BDReaderViewContainer"),
            ("SSReaderBottomToolbarItemContainerView", "UIView"),
            ("SSReaderBottomToolbarItemContainerInsertObject", "NSObject"),
            ("SSReaderCommunityBottomToolbarItemView", "UIView"),
            ("SSReaderFanClubEntryContainerView", "UIView"),
            ("FQReaderSaaSBottomToolView", "UIView"),
            ("FQReaderSaaSBottomToolItemView", "UIView"),
            ("FQReaderSaaSBottomToolItem", "NSObject"),
            ("FQReaderSaaSReaderSpeechButton", "UIView"),
            ("BDNovelNewAssetsGenerated", "NSObject"),
            ("FQReaderSaaSNewProgressView", "UIView"),
            ("SSReaderBottomToolDivertView", "UIView"),
            ("BDReaderNewSlider", "UIView"),
            ("SSReaderGiftView", "UIView"),
            ("SSReaderBookEndUserGiftView", "UIView"),
            ("SSReaderCoverTopRightView", "UIView"),
            ("FQReaderCoverMainContentViewController", "UIViewController"),
            ("SSReaderChapterEndDiscussionEntranceView", "UIView"),
            ("SSReaderChapterEndDiscussionEntranceButton", "UIButton"),
            ("SSReaderChapterEndCommunityCardView", "UIView"),
            ("SSReaderChapterEndCombineContainerView", "UIView"),
            ("SSReaderChapterEndCommunityCardViewModel", "NSObject"),
            ("SSReaderChapterEndBaseButton", "UIView"),
            ("SSReaderChapterEndRewardButton", "SSReaderChapterEndBaseButton"),
            ("SSBookShelfTabSelectViewTitleCell", "UIView"),
            ("SSBookShelfTabSelectViewTitleCellModel", "NSObject"),
            ("SSBookShelfFilterHeaderView", "UIView"),
            ("SSBookShelfFilterMixRowCollectionView", "UIView"),
            ("SSBookShelfFilter541Cell", "UIView"),
            ("SS525BookShelfSubHeaderView", "UIView"),
            ("SSBookShelf525ViewController", "UIViewController"),
            ("SSBookShelfSubViewController", "UIViewController"),
            ("SSBookShelfFunctionCell", "UIView"),
            ("SSBookShelfViewModel", "NSObject"),
            ("SSBookShelfBaseCell", "UIView"),
            ("SSCoverTransitionInfo", "NSObject"),
            ("SSMyUserBar", "UIView"),
            ("UICollectionView", "UIScrollView"),
            ("FQFeedListCollectionView", "UICollectionView"),
            ("FQReaderSaaSBaseImageView", "UIImageView"),
            ("SSMyUserCollectionViewFunCell", "UIView"),
            ("SSMyUserCollectionViewOrderFunCell", "SSMyUserCollectionViewFunCell"),
            ("SSMyUser621FunctionEntryItemCell", "SSMyUserCollectionViewOrderFunCell"),
            ("SSMyUserShortcutCell", "UIView"),
            ("SSMyUserCollectionView1Cell", "UIView"),
            ("SSMyUser621BaseViewController", "NSObject"),
            ("SSMyUser621ViewController", "SSMyUser621BaseViewController"),
            ("SSMyUserCell2Model", "NSObject"),
            ("SSMyUserMiniGameEntranceCellModel", "NSObject"),
            ("SSMyUserShopAndMiniGameEntranceCellModel", "SSMyUserMiniGameEntranceCellModel"),
            ("SSSSTimorCellInfo", "NSObject"),
            ("SSMineEcomEntranceData", "NSObject"),
            ("SSMineGameEntranceData", "NSObject"),
            ("SSTabBarButtonItem", "NSObject"),
            ("SSTabBarController", "UIViewController"),
            ("UIApplication", "NSObject"),
            ("SSSettingViewController", "UIViewController"),
            ("UIGestureRecognizer", "NSObject"),
            ("UILongPressGestureRecognizer", "UIGestureRecognizer"),
            ("UITapGestureRecognizer", "UIGestureRecognizer"),
            ("UISwitch", "UIControl"),
            ("UITableView", "UIScrollView"),
        ):
            if name not in self.classes:
                self._class(name, parent)
        self.bottom_original_calls = 0
        self.reader_menu_calls = []
        self.catalog_clicks = []
        self.mine_reloads = []
        self.tab_refreshes = 0
        self.tab_settings_presenters = []
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
        self._add(self.classes["FQReaderSaaSBottomToolItemView"], "onBtnClick:",
                  self.CATALOG_CLICK, "v24@0:8@16")
        self._add(self.classes["FQReaderSaaSNewProgressView"], "updateWithConfigData:",
                  self.PROGRESS_THEME, "v24@0:8@16")
        self._add(self.classes["SSReaderChapterEndCommunityCardView"], "updateWithReaderConfig:",
                  self.CHAPTER_CARD_THEME, "v24@0:8@16")
        self._add(self.classes["SSReaderChapterEndRewardButton"], "updateWithThemeConfigChange:",
                  self.CHAPTER_REWARD_THEME, "v24@0:8@16")
        self._add(self.classes["FQReaderUIManager"], "showBottomBarContainer:",
                  self.READER_MENU_SHOW, "v20@0:8B16")
        self._add(self.classes["FQReaderUIManager"], "onConfigThemeChange:context:",
                  self.READER_MENU_THEME, "v32@0:8@16@24")
        self._add(self.classes["FQReaderUIManager"], "refreshBottomToolbarInsertView",
                  self.READER_COMMUNITY_REFRESH, "v16@0:8")
        self._add(self.classes["FQReaderSaaSReaderSpeechButton"],
                  "readerInsertedViewBackgroundConfigChange:", self.SPEECH_THEME, "v24@0:8@16")
        self.speech_artwork = self.obj("UIImage", "transparent speech glyph")
        self.speech_template = self.obj("UIImage", "template speech glyph")
        self._add(self.classes["SSTabBarController"], "tabbarVCAndAttributeInit", self.TAB_PLAN, "@16@0:8")
        self._add(self.classes["SSTabBarController"], "viewDidAppear:", self.TAB_APPEAR, "v20@0:8B16")
        self._add(self.classes["SSSettingViewController"], "fqab_openMenu", self.TAB_OPEN_OPTIONS, "v16@0:8")
        self._add(self.classes["SS525BookShelfSubHeaderView"], "setShowReadTimeView:",
                  self.SHELF_DURATION_VISIBLE, "v20@0:8B16")
        self._add(self.classes["SS525BookShelfSubHeaderView"], "layoutEditButton",
                  self.SHELF_EDIT_LAYOUT, "v16@0:8")
        self._add(self.classes["SSBookShelfSubViewController"], "collectionView:layout:sizeForItemAtIndexPath:",
                  self.SHELF_FUNCTION_SIZE, "{CGSize=dd}40@0:8@16@24@32")
        self._add(self.classes["SSBookShelfSubViewController"], "collectionView:layout:insetForSectionAtIndex:",
                  self.SHELF_FUNCTION_INSETS, "{UIEdgeInsets=dddd}40@0:8@16@24q32")
        self._add(self.classes["SSBookShelfFilterMixRowCollectionView"], "collectionView:layout:insetForSectionAtIndex:",
                  self.SHELF_INLINE_FILTER_INSETS, "{UIEdgeInsets=dddd}40@0:8@16@24q32")
        self._add(self.classes["SSBookShelfFilterHeaderView"], "layoutSubviews",
                  self.SHELF_FILTER_HEADER_LAYOUT, "v16@0:8")
        self._add(self.classes["SSBookShelfSubViewController"], "saveOpeningData:indexPath:",
                  self.SHELF_SAVE_OPENING, "v32@0:8@16@24")
        self._add(self.classes["SSBookShelfSubViewController"], "fetchBookCoverTransitionInfo:",
                  self.SHELF_COVER_TRANSITION, "@24@0:8Q16")
        self._add(self.classes["SSBookShelfFunctionCell"], "layoutContainerSubviews",
                  self.SHELF_FUNCTION_LAYOUT, "v16@0:8")
        self._add(self.metaclasses[self.classes["SSBookShelfFunctionCell"]], "cellHeightWithFilterExposure:",
                  self.SHELF_FUNCTION_HEIGHT, "d20@0:8B16")
        for cls, selector, encoding in (
                ("FQReaderSaaSBottomToolItem", "type", "i16@0:8"),
                ("SSReaderBottomToolDivertView", "titleLabel", "@16@0:8"),
                ("BDReaderTopViewContainer", "updateGradientLayer", "v16@0:8"),
                ("SSReaderChapterEndCommunityCardViewModel", "displayMode", "q16@0:8"),
                ("FQReaderCoverMainContentViewController", "setupGuideView", "v16@0:8"),
                ("FQReaderCoverMainContentViewController", "viewDidLayoutSubviews", "v16@0:8"),
                ("SSBookShelfTabSelectViewTitleCellModel", "cellSpacing", "d16@0:8"),
                ("SSBookShelfViewModel", "sectionTypeAtIndex:", "q24@0:8q16"),
                ("SSBookShelfBaseCell", "fetchCoverSize", "{CGSize=dd}16@0:8"),
                ("SSCoverTransitionInfo", "setCoverFrame:", "v48@0:8{CGRect={CGPoint=dd}{CGSize=dd}}16"),
                ("SSBookShelfFunctionCell", "showsFilterExposure", "B16@0:8"),
                ("SS525BookShelfSubHeaderView", "isFiltering", "B16@0:8"),
                ("SS525BookShelfSubHeaderView", "showReadTimeView", "B16@0:8"),
                ("SSMineEcomEntranceData", "entranceType", "i16@0:8"),
                ("SSMyUserCell2Model", "businessStyle", "q16@0:8"),
                ("SSMyUser621ViewController", "reloadData:", "v24@0:8@16"),
                ("SSMyUser621BaseViewController", "updateCollectionLayout", "v16@0:8"),
                ("SSTabBarController", "titleStrWithType:", "@20@0:8i16"),
                ("SSTabBarController", "setTypeArray:", "v24@0:8@16"),
                ("SSTabBarController", "setTypeIndexMap:", "v24@0:8@16")):
            self._add(self.classes[cls], selector, self.LAYOUT_IMP, encoding)
        self.shelf_base_height = 30.
        self.shelf_function_height = 70.
        for selector, imp in (("setIsInvisible:", self.MODEL_INVISIBLE),
                              ("setIsDisabled:", self.MODEL_DISABLED)):
            self._add(self.classes["SSMyUserMiniGameEntranceCellModel"], selector, imp,
                      "v20@0:8B16")
        self._add(self.classes["NSMutableArray"], "removeObjectIdenticalTo:",
                  self.MODEL_REMOVE, "v24@0:8@16")
        self._add(self.classes["SSMyUser621BaseViewController"], "setupCellMiniGameEntranceData",
                  self.MODEL_SETUP, "v16@0:8")
        self._add(self.classes["SSMyUserCell2Model"],
                  "applyConfiguredMineEcomEntranceData:mineMonetizationStyle:",
                  self.MODEL_CONFIGURED_GAME, "v32@0:8@16q24")
        self._add(self.classes["SSMyUser621ViewController"], "objectsForListAdapter:",
                  self.MODEL_LIST_OBJECTS, "@24@0:8@16")
        self._add(self.classes["SSMyUserCollectionViewOrderFunCell"], "layoutSubviews",
                  self.MINE_ORDER_LAYOUT, "v16@0:8")

    def handle(self, cpu, pc):
        self.current_cpu = cpu
        receiver, selector = cpu.x[:2]
        name = self.selector_names.get(selector)
        if pc == self.SHELF_RELOAD:
            cell = self.objects[receiver].state
            cell["cellModel"] = cpu.x[2]
            model = self.objects[cpu.x[2]].state
            for key in ("titleLabel", "maskTitleLabel"):
                self.objects[cell[key]].state["font"] = model["fonts"][model["isSelected"]]
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
        if pc == self.CATALOG_CLICK:
            self.catalog_clicks.append((receiver, cpu.x[2]))
            return self.finish(cpu)
        if pc == self.TAB_PLAN:
            state = self.objects[receiver].state
            state.update(typeArray=state["host_types"], typeIndexMap=state["host_indexes"])
            return self.finish(cpu, state["host_plan"])
        if pc == self.TAB_APPEAR:
            return self.finish(cpu)
        if pc == self.TAB_OPEN_OPTIONS:
            self.tab_settings_presenters.append(receiver)
            return self.finish(cpu)
        if pc == self.SHELF_DURATION_VISIBLE:
            state = self.objects[receiver].state
            state["showReadTimeView"] = bool(cpu.x[2])
            self.objects[state["coinButton"]].state["hidden"] = not state["showReadTimeView"]
            return self.finish(cpu)
        if pc == self.SHELF_FUNCTION_SIZE:
            return self.finish(cpu, fp=(440., self.shelf_function_height))
        if pc == self.SHELF_FUNCTION_INSETS:
            return self.finish(cpu, fp=(0., 11., 12., 11.))
        if pc == self.SHELF_INLINE_FILTER_INSETS:
            return self.finish(cpu, fp=(0., 20., 0., 24.))
        if pc == self.SHELF_FILTER_HEADER_LAYOUT:
            state = self.objects[receiver].state
            if "filterGradientView" in state:
                self.objects[state["filterGradientView"]].state["frame"] = state["host_filter_fade_frame"]
            return self.finish(cpu)
        if pc == self.SHELF_SAVE_OPENING:
            state = self.objects[receiver].state
            state["capture"] = (cpu.x[2], cpu.x[3], self.objects[state["collectionView"]].state["layout_passes"])
            return self.finish(cpu)
        if pc == self.SHELF_COVER_TRANSITION:
            state = self.objects[receiver].state
            state["lookup_layout_passes"] = self.objects[state["collectionView"]].state["layout_passes"]
            return self.finish(cpu, state["cover_transition"])
        if pc == self.SHELF_FUNCTION_HEIGHT:
            require(cpu.x[2] == 0, "the compact size reads the unexposed native row height")
            return self.finish(cpu, fp=(self.shelf_base_height,))
        if pc == self.SHELF_FUNCTION_LAYOUT:
            frame = (0., self.shelf_base_height + 12., 440., 28.)
            self.objects[self.objects[receiver].state["filterClipView"]].state["frame"] = frame
            return self.finish(cpu)
        if pc == self.SHELF_EDIT_LAYOUT:
            self.objects[self.objects[receiver].state["editButton"]].state["frame"] = (380., 4., 44., 30.)
            return self.finish(cpu)
        if pc in (self.MODEL_INVISIBLE, self.MODEL_DISABLED):
            key = "isInvisible" if pc == self.MODEL_INVISIBLE else "isDisabled"
            self.objects[receiver].state[key] = bool(cpu.x[2])
            return self.finish(cpu)
        if pc == self.MODEL_SETUP:
            state = self.objects[receiver].state
            self.objects[state["models"]].state["items"].append(state["miniGameEntranceCellModel"])
            return self.finish(cpu)
        if pc == self.MODEL_CONFIGURED_GAME:
            self.objects[receiver].state.update(configured_entries=cpu.x[2], configured_style=cpu.x[3])
            return self.finish(cpu)
        if pc == self.MODEL_LIST_OBJECTS:
            return self.finish(cpu, self.objects[receiver].state["list_objects"])
        if pc == self.MINE_ORDER_LAYOUT:
            method = self.get_method(self.classes["SSMyUserCollectionViewFunCell"], selector)
            saved_x, saved_v = cpu.x.copy(), cpu.v.copy()
            cpu.run(self.methods[method]["imp"] - self.slide, args=(receiver, selector))
            cpu.x[:], cpu.v[:] = saved_x, saved_v
            state = self.objects[receiver].state
            if "image" in state and "productImage" in state:
                image = self.objects[state["image"]].state
                self.objects[state["productImage"]].state.update(frame=image["frame"], bounds=image["bounds"])
            return self.finish(cpu)
        if pc == self.SPEECH_THEME:
            button = self.objects[receiver].state["speechBtn"]
            self.objects[button].state["images"][0] = cpu.x[2]
            return self.finish(cpu)
        if pc == self.PROGRESS_THEME:
            slider = self.objects[receiver].state["slider"]
            slider_state = self.objects[slider].state
            theme = self.objects[cpu.x[2]].state
            self.objects[slider_state["trackView"]].state["backgroundColor"] = theme["trackColor"]
            self.objects[slider_state["progressView"]].state["backgroundColor"] = theme["fillColor"]
            return self.finish(cpu)
        if pc in (self.CHAPTER_CARD_THEME, self.CHAPTER_REWARD_THEME):
            state = self.objects[receiver].state
            key = "contentBackgroundView" if pc == self.CHAPTER_CARD_THEME else "customBackgroundView"
            self.objects[state[key]].state["backgroundColor"] = cpu.x[2]
            if pc == self.CHAPTER_CARD_THEME and "standaloneGiftButton" in state:
                gift = self.objects[state["standaloneGiftButton"]].state
                self.objects[gift["customBackgroundView"]].state["backgroundColor"] = cpu.x[2]
            return self.finish(cpu)
        if pc == self.READER_MENU_SHOW:
            self.reader_menu_calls.append(cpu.x[2])
            return self.finish(cpu)
        if pc == self.READER_MENU_THEME:
            state = self.objects[receiver].state
            for view in (state["nProgressView"], state["tabBar"]):
                self.objects[view].state["backgroundColor"] = cpu.x[2]
                self.objects[self.objects[view].state["superview"]].state["backgroundColor"] = cpu.x[3]
            if state.get("navigationContainer"):
                top = self.objects[state["navigationContainer"]].state
                top.update(backgroundColor=cpu.x[3], gradientVisible=True)
            if state.get("bottomToolbarInsertContainer"):
                lane = self.objects[state["bottomToolbarInsertContainer"]].state
                lane["backgroundColor"] = cpu.x[3]
                self.objects[lane["contentView"]].state["backgroundColor"] = cpu.x[3]
                self.objects[state["bottomToolbarInsertTopLineView"]].state["backgroundColor"] = cpu.x[2]
            return self.finish(cpu)
        if pc == self.READER_COMMUNITY_REFRESH:
            state = self.objects[receiver].state
            state["currentBottomToolbarInsertObject"] = state["nextBottomToolbarInsertObject"]
            return self.finish(cpu)
        if pc - self.slide == 0xa5d4:
            if receiver == self.classes["UIFont"] and name == "systemFontOfSize:":
                return self.finish(cpu, self.obj("UIFont", "settings font", pointSize=cpu.fp(0)))
            if receiver == self.classes["UIColor"] and name == "secondaryLabelColor":
                return self.finish(cpu, self.color("secondaryLabelColor"))
            if receiver == self.classes["UIApplication"] and name == "sharedApplication" and hasattr(self, "tab_app"):
                return self.finish(cpu, self.tab_app)
            if receiver in self.metaclasses and name == "alloc" and self.class_names[receiver] in (
                    "UIView", "UILabel", "UISwitch"):
                return self.finish(cpu, self.view(self.class_names[receiver], "settings control"))
            if receiver in self.objects:
                state = self.objects[receiver].state
                if name == "setAlpha:":
                    state["alpha"] = cpu.fp(0)
                    return self.finish(cpu)
                if name == "borderWidth":
                    return self.finish(cpu, fp=(state.get("borderWidth", 0.0),))
                if name == "setBorderWidth:":
                    state["borderWidth"] = cpu.fp(0)
                    return self.finish(cpu)
                if name in ("listenBtn", "listenLabel", "bgView", "guideView") and name in state:
                    return self.finish(cpu, state[name])
                if name == "updateGradientLayer":
                    state["gradientVisible"] = bool(state["backgroundColor"] and state["gradientBg"])
                    return self.finish(cpu)
                if name == "sectionTypeAtIndex:" and "section_types" in state:
                    return self.finish(cpu, state["section_types"][cpu.x[2]])
                if name in ("section", "functionCell", "headerView", "headerRightView", "secondaryView", "editButton", "filterButton", "filterGradientView", "lineView",
                            "filterClipView", "currentTabVC", "tabSelectView", "collectionView", "collectionViewLayout",
                            "visibleCells", "viewModel", "isFiltering", "showsFilterExposure", "optionsView",
                            "openingModel", "data", "bookId", "collectDatas", "fetchCoverView") and name in state:
                    return self.finish(cpu, state[name])
                if name == "layoutIfNeeded" and "layout_passes" in state:
                    state["layout_passes"] += 1
                    return self.finish(cpu)
                if name == "firstObject" and "items" in state:
                    return self.finish(cpu, next(iter(state["items"]), 0))
                if name == "fetchCoverSize" and "cover_size" in state:
                    return self.finish(cpu, fp=state["cover_size"])
                if name == "setCoverFrame:":
                    state["cover_frame"] = tuple(cpu.fp(i) for i in range(4))
                    return self.finish(cpu)
                if name in ("model", "displayMode", "activeEntranceView", "contentBackgroundView",
                            "customBackgroundView") and name in state:
                    return self.finish(cpu, state[name])
                if name in ("bottomToolbarInsertContainer", "bottomToolbarInsertTopLineView",
                            "currentBottomToolbarInsertObject", "containerView") and name in state:
                    return self.finish(cpu, state[name])
                if name == "invalidateLayout" and "invalidations" in state:
                    state["invalidations"] += 1
                    return self.finish(cpu)
                if name in ("typeArray", "tableView", "tableHeaderView", "keyWindow", "rootViewController"):
                    return self.finish(cpu, state.get(name, 0))
                if name == "showReadTimeView":
                    return self.finish(cpu, int(state["showReadTimeView"]))
                if name in ("customTabBar", "delegate", "state", "view", "myUserBar") and name in state:
                    return self.finish(cpu, state[name])
                if name == "initWithTarget:action:" and self.is_kind(receiver, self.classes["UIGestureRecognizer"]):
                    state.update(target=cpu.x[2], action=cpu.x[3], state=0)
                    return self.finish(cpu, receiver)
                if name == "setMinimumPressDuration:":
                    return self.finish(cpu)
                if name == "setDelegate:" and self.is_kind(receiver, self.classes["UIGestureRecognizer"]):
                    state["delegate"] = cpu.x[2]
                    return self.finish(cpu)
                if name == "setCancelsTouchesInView:":
                    state["cancelsTouchesInView"] = bool(cpu.x[2])
                    return self.finish(cpu)
                if name in ("addGestureRecognizer:", "removeGestureRecognizer:") and self.is_kind(cpu.x[2], self.classes["UIGestureRecognizer"]):
                    gesture = self.objects[cpu.x[2]].state
                    key = "recovery_gestures" if self.is_kind(cpu.x[2], self.classes["UILongPressGestureRecognizer"]) else "catalog_gestures"
                    if name == "addGestureRecognizer:":
                        state.setdefault(key, []).append(cpu.x[2])
                        gesture["view"] = receiver
                    else:
                        state[key].remove(cpu.x[2])
                        gesture["view"] = 0
                    return self.finish(cpu)
                if name == "locationInView:" and "touch_point" in state:
                    return self.finish(cpu, fp=state["touch_point"])
                if name in ("setTypeArray:", "setTypeIndexMap:", "setTableHeaderView:", "setText:",
                            "setTag:", "setNumberOfLines:", "setAccessibilityLabel:", "setOn:animated:"):
                    field = "isOn" if name == "setOn:animated:" else name[3].lower() + name[4:-1]
                    state[field] = cpu.x[2]
                    return self.finish(cpu)
                if name in ("tag", "isOn", "intValue"):
                    return self.finish(cpu, state.get("value" if name == "intValue" else name, 0))
                if name == "titleStrWithType:":
                    return self.finish(cpu, state.get("titles", {}).get(cpu.x[2], 0))
                if name == "refreshTabBar":
                    self.tab_refreshes += 1
                    return self.finish(cpu)
                if name == "reloadData:" and self.is_kind(receiver, self.classes["SSMyUser621ViewController"]):
                    self.mine_reloads.append((receiver, self.string_value(cpu.x[2])))
                    return self.finish(cpu)
                if name == "setObject:forKey:" and self.objects[cpu.x[3]].cls == self.classes["NSNumber"]:
                    state["items"][self.objects[cpu.x[3]].state["value"]] = cpu.x[2]
                    return self.finish(cpu)
            if receiver in self.objects and name in ("font", "maskTitleLabel"):
                return self.finish(cpu, self.objects[receiver].state.get(name, 0))
            if receiver in self.objects and name == "setFont:":
                self.objects[receiver].state["font"] = cpu.x[2]
                return self.finish(cpu)
            if receiver in self.objects and self.is_kind(receiver, self.classes["UIFont"]):
                font = self.objects[receiver].state
                if name == "pointSize":
                    return self.finish(cpu, fp=(font["pointSize"],))
                if name == "fontWithSize:":
                    return self.finish(cpu, self.obj("UIFont", "resized shelf font",
                                                     **dict(font, pointSize=cpu.fp(0))))
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
                    "itemViews", "item", "type", "trackView", "progressView", "speechBtn", "tintColor", "titleLabel",
                    "leftBtn", "rightBtn", "horizonLineView", "lineView", "nProgressView", "tabBar", "navigationContainer"):
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
            if name == "colorWithAlphaComponent:" and receiver in self.objects:
                color = self.objects[receiver].state
                if "pigment" in color:
                    return self.finish(cpu, self.obj("UIColor", "adjusted reader fill",
                                                     pigment=color["pigment"], opacity=cpu.fp(0)))
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
                    "scanQRCodeView", "darkModeImageView", "sideBarButtonView", "entranceType",
                    "businessStyle", "isShowPersonalizedBar", "isShowFriendView", "productImage", "text"):
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
    settings = (ROOT / "repair162" / "diagnostic_ui.s").read_text(encoding="utf-8")
    require("bl LFQH_FQHInstallOptionsToggles" in settings and "SetDefault(key,on)" in source,
            "real settings entry installs the bottom-entry switches")
    return {"exact_hooks": len(HOOKS), "global_uiview_layout_hook": False,
            "startup_wired": True, "model_boundary_deletion": True}


def exercise(data, labels):
    runtime = Runtime(data)
    runtime.labels = labels
    words = struct.unpack_from("<64I", data, 0x800)
    cpu = CPU(data, runtime, 0,
              ranges=[(0x800, 0x4000), (0x4878, 0x48d0), (0x6274, 0x62ac),
                      (0x702c, 0x7d00), (0x7fb0, 0x7ffc),
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
    require(installed_hooks == set(HOOKS),
            f"exact hook mismatch, missing {set(HOOKS) - installed_hooks}, unexpected {installed_hooks - set(HOOKS)}")
    require(runtime.methods[runtime.get_method(
        runtime.classes["UIView"], runtime.sel("layoutSubviews"))]["imp"] == uiview_before,
        "UIView layout implementation is untouched")

    # The real setItems: builds itemViews without populating the legacy view properties.
    toolbar = runtime.view("FQReaderSaaSBottomToolView", "toolbar", (0, 80, 440, 56), runtime.ROOT)
    saved_background = runtime.color("hostGray")
    stock_hit_insets = (0.0, -10.0, 0.0, -10.0)
    items = []
    captions = []
    for index, title in enumerate(("目录", "白天", "设置", "进度")):
        model = runtime.obj("FQReaderSaaSBottomToolItem", "toolbar item", type=index+1)
        button = runtime.view("FQReaderSaaSBottomToolItemView", "tool", (55 + index * 102, 2, 24, 40),
                              toolbar, backgroundColor=saved_background, item=model,
                              hitInsets=stock_hit_insets, hidden=index==3)
        captions.append(runtime.label("caption", button, (0, 26, 24, 14), title))
        items.append(button)
    runtime.objects[toolbar].state["itemViews"] = runtime.obj("NSArray", "toolbar items", items=items)
    nested_button = runtime.view("UIButton", "original click target", (0, 0, 24, 24), items[0])
    require(not call(cpu, labels, "LGstyle_control", nested_button, 0)["result"],
            "legacy walker skips the nested button even before the item material is created")
    # The host attaches the adaptation extra view to the toolbar separately.
    divert = runtime.view("SSReaderBottomToolDivertView", "adaptations", (353, 2, 40, 40),
                          toolbar, backgroundColor=saved_background)
    divert_caption = runtime.label("adaptations caption", divert, (0, 27, 40, 12), "改编剧场")
    runtime.objects[divert].state["titleLabel"] = divert_caption
    send(cpu, runtime, toolbar, "layoutSubviews")
    send(cpu, runtime, divert, "layoutSubviews")
    require(runtime.bottom_original_calls == 1, "host layout runs exactly once")
    styled_items = [*items[:3], divert]
    surfaces = [call(cpu, labels, "LFQH_FQHSurface", item)["result"] for item in styled_items]
    require(all(surfaces) and not call(cpu, labels, "LFQH_FQHSurface", items[3])["result"],
            "only the four requested tools get glass")
    for item, caption, surface in zip(styled_items, [*captions[:3], divert_caption], surfaces):
        width = 40.0 if item == divert else 24.0
        material_width = 76.0 if item == divert else 64.0
        left = (width - material_width) * 0.5
        require(runtime.objects[surface].state["frame"] == (left, -4.0, material_width, 48.0) and
                runtime.objects[item].state["frame"][2:] == (width, 40.0),
                "the adaptations caption gets extra width in the shared 48-point toolbar row")
        require(runtime.objects[surface].state["userInteractionEnabled"] == 0,
                "decorative material cannot steal touches")
        require(runtime.objects[item].state["hitInsets"] == (-4.0, left, -4.0, left),
                "the item can receive touches across its padded material")
        require(runtime.objects[item].state["subviews"][:2] == [surface, caption],
                "material is behind the original content")
        effect = runtime.objects[surface].state["effect"]
        require(not runtime.objects[effect].state.get("tintColor"),
                "the reader tools use standard untinted glass")
    runtime.objects[divert_caption].state["text"] = runtime.text_object("更多改编")
    send(cpu, runtime, divert, "layoutSubviews")
    divert_state = runtime.objects[divert].state
    caption_state = runtime.objects[divert_caption].state
    material_state = runtime.objects[surfaces[-1]].state
    require(call(cpu, labels, "LFQH_FQHSurface", divert)["result"] == surfaces[-1] and
            caption_state["frame"] == (0, 27, 40, 12) and material_state["frame"] == (-18, -4, 76, 48),
            "both native captions retain their frame and reuse the same padded glass")
    # A neighboring pill and the toolbar edge each cap the optional expansion.
    settings = runtime.objects[items[2]].state
    settings["frame"] = (288, 2, 24, 40)
    send(cpu, runtime, divert, "layoutSubviews")
    require(material_state["frame"] == (-13, -4, 66, 48) and
            divert_state["hitInsets"] == (-4, -13, -4, -13),
            "close neighbors leave eight points before the enlarged hit area")
    settings["frame"] = (259, 2, 24, 40)
    runtime.objects[toolbar].state["bounds"] = (0, 0, 413, 56)
    send(cpu, runtime, divert, "layoutSubviews")
    require(material_state["frame"] == (-12, -4, 64, 48),
            "narrow layout retains the standard capsule and its stock row alignment")
    runtime.objects[toolbar].state["bounds"] = (0, 0, 440, 56)
    send(cpu, runtime, divert, "layoutSubviews")
    transactions = sum(event["event"] == "transaction_begin" for event in runtime.events)
    send(cpu, runtime, divert, "layoutSubviews")
    require(material_state["frame"] == (-18, -4, 76, 48) and
            sum(event["event"] == "transaction_begin" for event in runtime.events) == transactions,
            "expanded capsule returns after rotation and settled relayout makes no glass writes")
    runtime.reparent(divert, runtime.ROOT)
    send(cpu, runtime, divert, "layoutSubviews")
    require(not call(cpu, labels, "LFQH_FQHSurface", divert)["result"] and
            runtime.objects[divert].state["backgroundColor"] == saved_background,
            "the same adaptation class outside the reader tools retains its stock appearance")
    runtime.reparent(divert, toolbar)
    send(cpu, runtime, divert, "layoutSubviews")
    for _ in range(20):
        send(cpu, runtime, toolbar, "layoutSubviews")
    require(call(cpu, labels, "LFQH_FQHSurface", items[0])["result"] == surfaces[0],
            "settled layouts reuse one material")
    require(runtime.objects[toolbar].state["hitInsets"] == (-2.0, 0.0, 0.0, 0.0),
            "the toolbar admits the catalog glass above its stock top edge")
    catalog_state = runtime.objects[items[0]].state
    catalog_gestures = catalog_state["catalog_gestures"]
    require(len(catalog_gestures) == 1 and all("catalog_gestures" not in runtime.objects[item].state
                                               for item in items[1:]),
            "only the catalog item gets one auxiliary recognizer across layouts")
    tap = catalog_gestures[0]
    tap_state = runtime.objects[tap].state
    require(not tap_state["cancelsTouchesInView"], "catalog recognizer does not cancel host touches")
    accept = "gestureRecognizer:shouldReceiveTouch:"
    touch = runtime.obj("NSObject", "modeled touch", view=items[0], touch_point=(-14.0, 20.0))
    def accepts(target, point):
        runtime.objects[touch].state.update(view=target, touch_point=point)
        return send(cpu, runtime, tap_state["delegate"], accept, tap, touch)["result"]
    require(accepts(items[0], (-14.0, 20.0)) and accepts(items[0], (36.0, 20.0)) and
            accepts(items[0], (12.0, -3.0)),
            "the visible left, right and top of the catalog capsule accept otherwise unhandled taps")
    require(not accepts(nested_button, (12.0, 12.0)) and not accepts(captions[0], (12.0, 33.0)) and
            not accepts(items[0], (-19.0, -3.0)),
            "native icon, native caption and points outside the capsule bypass the new handler")
    action = runtime.selector_names[tap_state["action"]]
    send(cpu, runtime, tap_state["target"], action, tap)
    require(not runtime.catalog_clicks, "an unfinished gesture does not open the catalog")
    require(accepts(items[0], (-14.0, 20.0)), "left wing gesture starts on the item")
    tap_state["state"] = 3
    send(cpu, runtime, tap_state["target"], action, tap)
    require(runtime.catalog_clicks == [(items[0], tap)], "recognized wing tap calls the exact host catalog action once")
    runtime.objects[runtime.DEFAULTS].state["values"]["FanqieAdBlock.GlassDisabled.1"] = 1
    send(cpu, runtime, toolbar, "layoutSubviews")
    send(cpu, runtime, divert, "layoutSubviews")
    require(not catalog_gestures and runtime.objects[toolbar].state["hitInsets"] == (0.0, 0.0, 0.0, 0.0),
            "glass switch removes the auxiliary recognizer and restores the toolbar hit area")
    for item in styled_items:
        require(not call(cpu, labels, "LFQH_FQHSurface", item)["result"],
                "glass switch removes the material")
        require(runtime.objects[item].state["backgroundColor"] == saved_background,
                "glass switch restores the host background")
        require(runtime.objects[item].state["hitInsets"] ==
                ((0.0, 0.0, 0.0, 0.0) if item == divert else stock_hit_insets),
                "glass switch restores the host touch insets")
    runtime.objects[runtime.DEFAULTS].state["values"]["FanqieAdBlock.GlassDisabled.1"] = 0

    # Shelf tabs use the live model and consistent capsules across title zoom.
    def surface_for(view):
        return call(cpu, labels, "LFQH_FQHSurface", view)["result"]

    def tint_for(surface):
        effect = runtime.objects[surface].state["effect"]
        return runtime.objects[effect].state.get("tintColor", 0)

    def shelf_fonts(tab):
        cell = runtime.objects[tab].state
        return tuple(runtime.objects[cell[key]].state["font"]
                     for key in ("titleLabel", "maskTitleLabel"))

    host_fonts = (runtime.obj("UIFont", "normal shelf font", pointSize=18.0, weight="regular"),
                  runtime.obj("UIFont", "selected shelf font", pointSize=20.0, weight="semibold"))
    tabs = []
    for index, (title, width) in enumerate(zip(("书架", "历史", "收藏", "圈子"), (34, 32, 33, 32))):
        model = runtime.obj("SSBookShelfTabSelectViewTitleCellModel", "tab model",
                            isSelected=index == 0, cellSpacing=18.0, fonts=host_fonts)
        tab = runtime.view("SSBookShelfTabSelectViewTitleCell", title,
                           (index * 50, 0, width, 34), runtime.ROOT,
                           hasSelected=index == 3, cellModel=model)
        for key in ("titleLabel", "maskTitleLabel"):
            label = runtime.label(key, tab, (0, 0, width, 34), title)
            runtime.objects[tab].state[key] = label
            runtime.objects[label].state["font"] = host_fonts[index == 0]
        send(cpu, runtime, tab, "layoutSubviews")
        material = surface_for(tab)
        state = runtime.objects[material].state
        require(state["frame"] == ((width - 42) * 0.5, 3.0, 42.0, 28.0),
                "shelf tab capsule is padded, centered and consistent")
        require(tint_for(material) == (runtime.color("shelfNeutralTint") if index == 0 else 0),
                "live selection selects neutral material and ignores stale hasSelected")
        fitted_fonts = shelf_fonts(tab)
        require(all(runtime.objects[font].state["pointSize"] == (17.5 if index == 0 else 15.75)
                    for font in fitted_fonts), "both title layers have extra padding in each state")
        send(cpu, runtime, tab, "layoutSubviews")
        require(shelf_fonts(tab) == fitted_fonts, "repeated layout does not shrink the titles again")
        tabs.append((tab, model, material))

    for index, (tab, model, material) in enumerate(tabs):
        runtime.objects[model].state["isSelected"] = index == 3
        send(cpu, runtime, tab, "reloadData:", model)
        require(surface_for(tab) == material, "selection updates reuse the tab material")
        require(bool(tint_for(material)) == (index == 3), "selection moves with the host model")
        require(runtime.objects[tab].state["hasSelected"] == (index == 3),
                "host-owned messaging flag is unchanged")
        expected_font = {"pointSize": 17.5, "weight": "semibold"} if index == 3 else {
            "pointSize": 15.75, "weight": "regular"}
        require(all(runtime.objects[font].state == expected_font for font in shelf_fonts(tab)),
                "selection refits the latest host fonts without changing their weight")

    header = runtime.view("SSBookShelfFilterHeaderView", "filter header", (0, 100, 390, 44), runtime.ROOT)
    filter_action = [(header, runtime.sel("filterBtnClick"), 64)]
    filter_button = runtime.view("UIButton", "open all shelf filters", (324, 2, 58, 30), header,
                                 control_targets=filter_action[:])
    fade_frame = (308., 0., 24., 44.)
    filter_fade = runtime.view("UIView", "native filter fade above the capsule", fade_frame, header)
    runtime.objects[header].state.update(filterButton=filter_button, filterGradientView=filter_fade,
                                         host_filter_fade_frame=fade_frame)
    require(not call(cpu, labels, "LGstyle_control", filter_button, 0)["result"],
            "the inline filter action does not acquire an earlier legacy capsule")
    send(cpu, runtime, header, "layoutSubviews")
    filter_glass = surface_for(filter_button)
    require(filter_glass and runtime.objects[filter_glass].state["frame"] == (1., 1., 56., 28.) and
            not runtime.objects[filter_glass].state["userInteractionEnabled"] and
            runtime.objects[filter_button].state["control_targets"] == filter_action and
            runtime.objects[filter_button].state["frame"] == (324., 2., 58., 30.),
            "the filter capsule has clearance without changing the native button or tap")
    require(runtime.objects[filter_fade].state["frame"] == (301., 0., 24., 44.),
            "the overlapping native fade stops before the capsule's left edge")
    send(cpu, runtime, header, "layoutSubviews")
    require(runtime.objects[filter_fade].state["frame"] == (301., 0., 24., 44.) and
            surface_for(filter_button) == filter_glass,
            "native relayout keeps the same capsule and preserves the full fade")
    row = runtime.view("SSBookShelfFilterMixRowCollectionView", "filter row", (0, 0, 270, 40), header)
    collection = runtime.view("UIView", "filter collection", (0, 0, 270, 40), row)
    runtime.objects[header].state["optionsView"] = row
    inline_insets = "collectionView:layout:insetForSectionAtIndex:"
    send(cpu, runtime, row, inline_insets, collection, 0, 0)
    require(tuple(cpu.fp(i) for i in range(4)) == (0., 16., 0., 24.),
            "the entire inline row starts at the upper bookshelf title gutter")
    panel_row = runtime.view("SSBookShelfFilterMixRowCollectionView", "separate filter panel", parent=runtime.ROOT)
    send(cpu, runtime, panel_row, inline_insets, 0, 0, 0)
    require(tuple(cpu.fp(i) for i in range(4)) == (0., 20., 0., 24.),
            "the standalone filter panel keeps its native insets")
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
    send(cpu, runtime, header, "layoutSubviews")
    require(not surface_for(filter_button) and runtime.objects[filter_button].state["control_targets"] == filter_action and
            runtime.objects[filter_fade].state["frame"] == fade_frame,
            "disabling glass restores the native filter fade and tap")
    tab, _, _ = tabs[3]
    send(cpu, runtime, tab, "layoutSubviews")
    require(shelf_fonts(tab) == (host_fonts[1], host_fonts[1]),
            "disabling glass restores both host title fonts")
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

    cover_top = runtime.view("SSReaderCoverTopRightView", "cover listen entry", (326, 0, 44, 24), runtime.ROOT)
    cover_fill = runtime.color("stock cover button fill")
    cover_listen_action = (cover_top, runtime.sel("onListenBtnClick"), 64)
    cover_listen = runtime.view("UIButton", "native 听书 button", (0, 0, 44, 24), cover_top,
                                backgroundColor=cover_fill, control_targets=[cover_listen_action])
    cover_background = runtime.view("UIView", "shared cover backing", (0, 0, 44, 24), cover_top,
                                    hidden=True, backgroundColor=cover_fill, clipsToBounds=True)
    cover_label = runtime.label("cover listen caption", cover_top, (4, 4, 36, 16), "听书")
    runtime.objects[cover_label].state["hidden"] = True
    runtime.objects[cover_top].state.update(listenBtn=cover_listen, listenLabel=cover_label, bgView=cover_background)
    send(cpu, runtime, cover_top, "layoutSubviews")
    legacy_glass = surface_for(cover_listen)
    require(legacy_glass and not surface_for(cover_background) and
            runtime.objects[cover_listen].state["control_targets"] == [cover_listen_action],
            "the cover's legacy Listen button keeps its native action under one glass surface")
    runtime.objects[cover_listen].state["hidden"] = True
    runtime.objects[cover_background].state["hidden"] = False
    runtime.objects[cover_label].state["hidden"] = False
    send(cpu, runtime, cover_top, "layoutSubviews")
    cover_glass = surface_for(cover_background)
    require(cover_glass and not surface_for(cover_listen) and
            runtime.objects[cover_listen].state["backgroundColor"] == cover_fill and
            runtime.objects[cover_glass].state["frame"] == (0, 0, 44, 24),
            "the new Listen layout styles its existing visible backing and restores the hidden legacy button")

    guide = runtime.view("UIView", "native left swipe guide", (134, 795, 122, 33), runtime.ROOT,
                         backgroundColor=cover_fill, gesture_action="onClickGuideView")
    guide_layer = runtime.objects[runtime.layer(guide)].state
    guide_layer["borderWidth"] = 1.0
    guide_arrow = runtime.view("UIImageView", "native guide arrow", (18, 9, 15, 15), guide)
    guide_label = runtime.label("native guide caption", guide, (34, 7, 70, 19), "左滑开始阅读")
    cover_main = runtime.obj("FQReaderCoverMainContentViewController", "cover page", guideView=guide)
    send(cpu, runtime, cover_main, "setupGuideView")
    guide_glass = surface_for(guide)
    require(guide_glass and guide_layer["borderWidth"] == 0 and
            runtime.objects[guide].state["subviews"] == [guide_glass, guide_arrow, guide_label] and
            runtime.objects[guide].state["gesture_action"] == "onClickGuideView" and
            not runtime.objects[guide_glass].state["userInteractionEnabled"],
            "the guide replaces its stock fill and border while preserving the host arrow, caption and gesture")
    runtime.objects[guide_label].state["text"] = runtime.text_object("上滑开始阅读")
    send(cpu, runtime, cover_main, "viewDidLayoutSubviews")
    require(surface_for(guide) == guide_glass, "vertical reading uses the same guide surface on layout")
    runtime.objects[runtime.DEFAULTS].state["values"]["FanqieAdBlock.GlassDisabled.1"] = 1
    send(cpu, runtime, cover_main, "viewDidLayoutSubviews")
    send(cpu, runtime, cover_top, "layoutSubviews")
    require(not surface_for(guide) and guide_layer["borderWidth"] == 1.0 and
            runtime.objects[guide].state["backgroundColor"] == cover_fill and
            not surface_for(cover_background) and runtime.objects[cover_background].state["backgroundColor"] == cover_fill,
            "disabling glass restores the original guide border and both stock fills")
    runtime.objects[runtime.DEFAULTS].state["values"]["FanqieAdBlock.GlassDisabled.1"] = 0
    runtime.objects[guide_label].state["text"] = runtime.text_object("继续阅读")
    send(cpu, runtime, cover_main, "setupGuideView")
    require(not surface_for(guide), "a different host guide is left alone")

    backdrop = runtime.color("reader panel theme")
    wrapper_backdrop = runtime.color("reader outer panel theme")
    progress_wrapper = runtime.view("BDReaderViewContainer", "progress wrapper", (0, 700, 390, 48),
                                    runtime.ROOT, backgroundColor=wrapper_backdrop)
    progress = runtime.view("FQReaderSaaSNewProgressView", "progress", (0, 0, 390, 48),
                            progress_wrapper, backgroundColor=backdrop)
    runtime.objects[progress_wrapper].state["contentView"] = progress
    tool_wrapper = runtime.view("BDReaderBottomViewContainer", "tool wrapper", (0, 80, 400, 56),
                                runtime.ROOT, backgroundColor=wrapper_backdrop, contentView=toolbar)
    runtime.reparent(toolbar, tool_wrapper)
    runtime.objects[toolbar].state.update(frame=(0, 0, 400, 56), bounds=(0, 0, 400, 56), backgroundColor=backdrop)
    progress_line = runtime.view("UIView", "progress separator", (0, 0, 390, 1), progress, alpha=0.75)
    tool_line = runtime.view("UIView", "tools separator", (0, 0, 400, 1), toolbar, alpha=1., hidden=True)
    runtime.objects[progress].state["horizonLineView"] = progress_line
    runtime.objects[toolbar].state["lineView"] = tool_line
    top = runtime.view("BDReaderTopViewContainer", "reader menu navigation wrapper", (0, 0, 390, 90),
                       runtime.ROOT, backgroundColor=wrapper_backdrop, gradientBg=True, gradientVisible=True)
    nav = runtime.view("FQReaderSaasNavigationView", "reader navigation", (0, 46, 390, 44), top)
    top_state = runtime.objects[top].state
    top_state["contentView"] = nav
    manager = runtime.obj("FQReaderUIManager", "reader menu owner", nProgressView=progress, tabBar=toolbar,
                          navigationContainer=top)
    fan_wrapper = runtime.view("SSReaderFanClubEntryContainerView", "combined native shelf/fan club insert",
                               (132, 11, 64, 22), nav, clipsToBounds=True)
    fan_state = runtime.objects[fan_wrapper].state
    bookmark = runtime.label("native shelf label", fan_wrapper, (0, 0, 64, 22), "已加书架")
    bookmark_state = runtime.objects[bookmark].state
    bookmark_target = (nav, runtime.sel("onBookShelfBtnClick:"))
    bookmark_state.update(gestureRecognizers=[bookmark_target], userInteractionEnabled=True)
    fan_state["contentView"] = bookmark
    send(cpu, runtime, fan_wrapper, "layoutSubviews")
    shelf_glass = call(cpu, labels, "LFQH_FQHIconGlass", bookmark)["result"]
    require(shelf_glass and fan_state["subviews"] == [shelf_glass, bookmark] and
            runtime.objects[shelf_glass].state["frame"] == (-18, -7, 88, 36) and
            bookmark_state["frame"] == (-6, 0, 64, 22) and
            fan_state["hitInsets"] == (-7, -18, -7, -6) and not fan_state["clipsToBounds"],
            "the combined insert exposes the centered shelf label and its left-widened capsule")
    bookmark_state["text"] = runtime.text_object("加入书架")
    bookmark_state["frame"] = (0, 0, 64, 22)
    for _ in range(10):
        send(cpu, runtime, fan_wrapper, "layoutSubviews")
    require(call(cpu, labels, "LFQH_FQHIconGlass", bookmark)["result"] == shelf_glass and
            bookmark_state["frame"] == (-6, 0, 64, 22) and bookmark_state["gestureRecognizers"] == [bookmark_target],
            "wrapped shelf label remains centered after host relayout without drifting or losing its gesture")
    runtime.reparent(bookmark, 0)
    fan = runtime.view("UIView", "native fan club control", (0, 0, 64, 22), fan_wrapper)
    fan_state["contentView"] = fan
    send(cpu, runtime, fan_wrapper, "layoutSubviews")
    require(fan_state["subviews"] == [fan] and fan_state["clipsToBounds"] and
            fan_state["hitInsets"] == (0, 0, 0, 0) and bookmark_state["frame"] == (0, 0, 64, 22),
            "switching to fan club removes the shelf decoration and restores the host geometry")
    chapter_controls = []
    for key, x, title, action in (("leftBtn", 16, "上一章", "onLastChapterBtnClick:"),
                                  ("rightBtn", 332, "下一章", "onNextChapterBtnClick:")):
        host_target = (progress, runtime.sel(action), 64)
        button = runtime.view("UIButton", title, (x, 15, 42, 18), progress, control_targets=[host_target])
        caption = runtime.label(title, button, (0, 0, 42, 18), title)
        runtime.objects[progress].state[key] = button
        chapter_controls.append((button, caption, x, host_target))
    clear = runtime.color("clearColor")
    slider = runtime.view("BDReaderNewSlider", "slider", (74, 4, 242, 40), progress,
                          clipsToBounds=True, backgroundColor=clear)
    track_color = runtime.color("hostTrack")
    track = runtime.view("UIImageView", "track", (0, 12, 242, 16), slider,
                         clipsToBounds=True, backgroundColor=track_color)
    fill_color = runtime.obj("UIColor", "host daylight fill", pigment="day text", opacity=0.10)
    fill = runtime.view("UIImageView", "progress fill", (0, 12, 165, 16), slider,
                        backgroundColor=fill_color)
    thumb = runtime.view("UIImageView", "thumb", (154, 9, 22, 22), slider)
    runtime.objects[progress].state["slider"] = slider
    runtime.objects[slider].state.update(trackView=track, progressView=fill)
    send(cpu, runtime, progress, "layoutSubviews")
    material = surface_for(track)
    require(material and not surface_for(slider) and
            runtime.objects[material].state["frame"] == (0.0, 0.0, 242.0, 16.0) and
            runtime.objects[track].state["backgroundColor"] == clear,
            "the material replaces the host paint along the complete progress track")
    require(runtime.objects[slider].state["frame"] == (74, 4, 242, 40) and
            runtime.objects[track].state["frame"] == (0, 12, 242, 16) and
            runtime.objects[fill].state["frame"] == (0, 12, 165, 16) and
            runtime.objects[thumb].state["frame"] == (154, 9, 22, 22),
            "slider, track, active fill and thumb remain in host coordinates")
    tuned_fill = runtime.objects[fill].state["backgroundColor"]
    require(runtime.objects[tuned_fill].state == {"pigment": "day text", "opacity": 0.15625},
            "daylight glass fill keeps the host pigment and slightly deepens its opacity")
    settled_transactions = sum(event["event"] == "transaction_begin" for event in runtime.events)
    settled_colors = sum(obj.name == "adjusted reader fill" for obj in runtime.objects.values())
    for _ in range(10):
        send(cpu, runtime, progress, "layoutSubviews")
    require(sum(event["event"] == "transaction_begin" for event in runtime.events) == settled_transactions and
            sum(obj.name == "adjusted reader fill" for obj in runtime.objects.values()) == settled_colors and
            runtime.objects[fill].state["backgroundColor"] == tuned_fill,
            "settled slider layouts neither start empty transactions nor regenerate fill color")
    chapter_glasses = []
    for button, caption, x, target in chapter_controls:
        glass = call(cpu, labels, "LFQH_FQHIconGlass", button)["result"]
        button_state = runtime.objects[button].state
        require(glass and runtime.objects[glass].state["frame"] == (-6, -6, 54, 30) and
                button_state["subviews"][:2] == [glass, caption] and button_state["frame"] == (x, 15, 42, 18) and
                target in button_state["control_targets"],
                "chapter buttons get equal padded glass below their native captions and keep their original targets")
        chapter_glasses.append(glass)
    panel_states = [runtime.objects[v].state for v in (progress, toolbar, progress_wrapper, tool_wrapper)]
    def backgrounds():
        return [state["backgroundColor"] for state in panel_states]

    send(cpu, runtime, manager, "showBottomBarContainer:", 1)
    require(backgrounds() == [backdrop, backdrop, wrapper_backdrop, wrapper_backdrop],
            "first native menu show preserves the stock panel colors by default")
    require(top_state["backgroundColor"] == wrapper_backdrop and top_state["gradientVisible"],
            "the visible preference leaves the native top theme intact")
    menu_preferences = runtime.objects[runtime.DEFAULTS].state["values"]
    menu_key = "FanqieX.ReaderBottomBackground.1"
    menu_preferences[menu_key] = False
    panel_frames = [state["frame"] for state in panel_states]
    send(cpu, runtime, manager, "showBottomBarContainer:", 1)
    require(backgrounds() == [0] * 4 and
            runtime.objects[progress_line].state["alpha"] == 0 and runtime.objects[tool_line].state["alpha"] == 0,
            "off clears all four themed fills and only the two stock separators")
    require(not top_state["backgroundColor"] and not top_state["gradientVisible"] and
            runtime.objects[nav].state["frame"] == (0, 46, 390, 44),
            "off removes the exact top mask and gradient without moving navigation past its safe area")
    require(runtime.objects[tool_line].state["hidden"] and [state["frame"] for state in panel_states] == panel_frames and
            surface_for(track) == material and
            all(call(cpu, labels, "LFQH_FQHIconGlass", row[0])["result"] == glass
                for row, glass in zip(chapter_controls, chapter_glasses)),
            "transparent menu preserves the host frames, hidden flags and all glass controls")
    night_backdrop = runtime.color("reader night panel theme")
    night_wrapper = runtime.color("reader night outer theme")
    send(cpu, runtime, manager, "onConfigThemeChange:context:", night_backdrop, night_wrapper)
    require(backgrounds() == [0] * 4 and not top_state["backgroundColor"] and not top_state["gradientVisible"],
            "manager theme writes stay transparent for the exact top and bottom panels while off")
    menu_preferences[menu_key] = True
    send(cpu, runtime, manager, "showBottomBarContainer:", 0)
    require(backgrounds() == [night_backdrop, night_backdrop, night_wrapper, night_wrapper] and
            runtime.objects[progress_line].state["alpha"] == 0.75 and runtime.objects[tool_line].state["alpha"] == 1. and
            runtime.reader_menu_calls == [1, 1, 0],
            "on restores the latest native theme and separator alpha and forwards each native menu show")
    require(top_state["backgroundColor"] == night_wrapper and top_state["gradientVisible"],
            "on restores latest top theme color and lets native gradient update run")
    del menu_preferences[menu_key]

    community_lane = runtime.view("BDReaderViewContainer", "community menu backing",
                                  (0, 0, 440, 52), runtime.ROOT, backgroundColor=wrapper_backdrop)
    community_holder = runtime.view("UIView", "community insertion holder",
                                    (0, 0, 440, 52), community_lane, backgroundColor=wrapper_backdrop)
    community_line = runtime.view("UIView", "community separator", (0, 0, 440, 1),
                                  community_lane, backgroundColor=backdrop)
    community_row = runtime.view("SSReaderBottomToolbarItemContainerView", "reader community row",
                                 (0, 0, 440, 52), community_holder)
    insert_object = runtime.obj("SSReaderBottomToolbarItemContainerInsertObject", "community insert",
                                containerView=community_row)
    runtime.objects[community_lane].state["contentView"] = community_holder
    manager_state = runtime.objects[manager].state
    manager_state.update(bottomToolbarInsertContainer=community_lane, bottomToolbarInsertTopLineView=community_line,
                         currentBottomToolbarInsertObject=0, nextBottomToolbarInsertObject=insert_object)
    community_items = []
    for x, title in ((16, "发讨论"), (224, "圈子")):
        tap = runtime.obj("NSObject", title + " original onTap")
        item = runtime.view("SSReaderCommunityBottomToolbarItemView", title, (x, 10, 200, 32),
                            community_row, clipsToBounds=True, backgroundColor=backdrop, onTap=tap)
        wrapper = runtime.view("UIView", "icon and title", (66, 6, 68, 20), item)
        caption = runtime.label("community item caption", wrapper, (20, 0, 48, 20), title)
        runtime.objects[item].state["titleLabel"] = caption
        community_items.append((item, wrapper, tap))
    runtime.objects[community_row].state["itemViews"] = runtime.obj(
        "NSArray", "host community items", items=[row[0] for row in community_items])
    first_item = runtime.objects[community_items[0][0]].state
    first_item["bounds"] = (0, 0, 0, 0)
    menu_preferences[menu_key] = False
    send(cpu, runtime, manager, "refreshBottomToolbarInsertView")
    lane_states = [runtime.objects[v].state for v in (community_lane, community_holder, community_line)]
    require(all(not state["backgroundColor"] for state in lane_states),
            "inserting the community row clears the dedicated wide lane and separator with backdrop off")
    require(not surface_for(community_items[0][0]), "an item gets glass after its host establishes valid bounds")
    first_item["bounds"] = (0, 0, 200, 32)
    community_surfaces = []
    for item, wrapper, tap in community_items:
        send(cpu, runtime, item, "layoutSubviews")
        surface = surface_for(item)
        state = runtime.objects[item].state
        require(surface and runtime.objects[surface].state["frame"] == (0, 0, 200, 32) and
                not runtime.objects[surface].state["userInteractionEnabled"] and
                state["subviews"] == [surface, wrapper] and state["onTap"] == tap and
                not surface_for(wrapper),
                "each community tap surface owns full glass behind the native title and icon")
        community_surfaces.append(surface)
    other_row = runtime.view("SSReaderBottomToolbarItemContainerView", "other reader insert row",
                             (0, 60, 440, 52), runtime.ROOT)
    character = runtime.view("SSReaderCommunityBottomToolbarItemView", "optional character item",
                             (16, 10, 200, 32), other_row, backgroundColor=backdrop)
    character_title = runtime.label("optional character title", character, (20, 0, 48, 20), "角色")
    runtime.objects[character].state["titleLabel"] = character_title
    send(cpu, runtime, character, "layoutSubviews")
    require(not surface_for(character) and runtime.objects[character].state["backgroundColor"] == backdrop,
            "another helper using the same item class keeps its stock appearance")
    send(cpu, runtime, manager, "onConfigThemeChange:context:", night_backdrop, night_wrapper)
    require(all(not state["backgroundColor"] for state in lane_states) and
            [surface_for(item) for item, _, _ in community_items] == community_surfaces,
            "theme repaint stays transparent and does not replace either glass surface")
    menu_preferences[menu_key] = True
    send(cpu, runtime, manager, "showBottomBarContainer:", 0)
    require([state["backgroundColor"] for state in lane_states] == [night_wrapper, night_wrapper, night_backdrop] and
            [surface_for(item) for item, _, _ in community_items] == community_surfaces,
            "turning the backdrop on restores the latest themed lane and keeps both native glasses")
    menu_preferences[menu_key] = False
    runtime.objects[runtime.DEFAULTS].state["values"]["FanqieAdBlock.GlassDisabled.1"] = 1
    send(cpu, runtime, manager, "showBottomBarContainer:", 0)
    require([state["backgroundColor"] for state in lane_states] == [night_wrapper, night_wrapper, night_backdrop] and
            all(not surface_for(item) and runtime.objects[item].state["backgroundColor"] == backdrop
                for item, _, _ in community_items),
            "turning glass off restores the stock lane and the original two item fills")
    runtime.objects[runtime.DEFAULTS].state["values"]["FanqieAdBlock.GlassDisabled.1"] = 0
    del menu_preferences[menu_key]

    next_track_color = runtime.color("hostTrackNight")
    next_fill_color = runtime.obj("UIColor", "host night fill", pigment="night text", opacity=0.10)
    slider_theme = runtime.obj("NSObject", "native night slider theme", trackColor=next_track_color, fillColor=next_fill_color)
    send(cpu, runtime, progress, "updateWithConfigData:", slider_theme)
    require(surface_for(track) == material and runtime.objects[track].state["backgroundColor"] == clear,
            "theme repaint reuses the track material and removes the updated stock paint")
    tuned_night = runtime.objects[fill].state["backgroundColor"]
    require(runtime.objects[tuned_night].state == {"pigment": "night text", "opacity": 0.15625},
            "night mode retains its separate text pigment at the same modest contrast increase")
    send(cpu, runtime, progress, "updateWithConfigData:", slider_theme)
    require(runtime.objects[fill].state["backgroundColor"] == tuned_night,
            "reapplying the same stock night color reuses its already tuned fill")
    runtime.objects[runtime.DEFAULTS].state["values"]["FanqieAdBlock.GlassDisabled.1"] = 1
    send(cpu, runtime, progress, "layoutSubviews")
    require(not surface_for(track) and runtime.objects[track].state["clipsToBounds"] and
            runtime.objects[track].state["backgroundColor"] == next_track_color and
            runtime.objects[fill].state["backgroundColor"] == next_fill_color and
            runtime.objects[slider].state["clipsToBounds"] and
            runtime.objects[slider].state["backgroundColor"] == clear,
            "removing glass restores the latest stock track while preserving the slider owner")
    for button, _, _, target in chapter_controls:
        require(not call(cpu, labels, "LFQH_FQHIconGlass", button)["result"] and
                runtime.objects[button].state["control_targets"] == [target],
                "glass disable removes only the chapter materials and their press observers")
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

    # The entrance-only community card pins the native 20pt gesture view
    # inside a 50pt card, alongside a separate 50pt gift with its own backing.
    card = runtime.view("SSReaderChapterEndCommunityCardView", "chapter community",
                        (0, 0, 400, 50), runtime.ROOT)
    model = runtime.obj("SSReaderChapterEndCommunityCardViewModel", "entrance only", displayMode=1)
    stock_fill = runtime.color("chapter stock fill")
    card_fill = runtime.view("UIView", "white chapter card", (0, 0, 342, 50), card,
                             clipsToBounds=True, backgroundColor=stock_fill)
    entry_frame = (16, 15, 310, 20)
    entry = runtime.view("SSReaderChapterEndDiscussionEntranceView", "本章讨论", entry_frame, card_fill,
                         hitInsets=(0., 0., 0., 0.), gesture_action="handleTap")
    caption = runtime.label("chapter caption", entry, (0, 0, 68, 20), "本章讨论")
    reward = runtime.view("SSReaderChapterEndRewardButton", "standalone gift",
                          (350, 0, 50, 50), card, clipsToBounds=True, gesture_action="handleStandaloneGift")
    reward_fill = runtime.view("UIView", "white gift backing", (0, 0, 50, 50), reward,
                               clipsToBounds=True, backgroundColor=stock_fill)
    glyph = runtime.view("UIImageView", "gift icon", (14, 14, 22, 22), reward)
    runtime.objects[card].state.update(model=model, activeEntranceView=entry, contentBackgroundView=card_fill,
                                       standaloneGiftButton=reward)
    runtime.objects[reward].state["customBackgroundView"] = reward_fill
    send(cpu, runtime, card, "layoutSubviews")
    send(cpu, runtime, entry, "layoutSubviews")
    send(cpu, runtime, reward, "layoutSubviews")
    entry_state = runtime.objects[entry].state
    reward_state = runtime.objects[reward].state
    card_surface, reward_surface = surface_for(card_fill), surface_for(reward_fill)
    require(card_surface and reward_surface and not surface_for(entry) and not surface_for(reward),
            "both stock backings are replaced by one material each, with no nested strip")
    require(not reward_state["clipsToBounds"] and not runtime.objects[reward_fill].state["clipsToBounds"],
            "both gift wrappers allow the glass rim to render past the stock rounded mask")
    for backing, surface in ((card_fill, card_surface), (reward_fill, reward_surface)):
        owner, glass = runtime.objects[backing].state, runtime.objects[surface].state
        require(glass["frame"] == owner["bounds"] and owner["backgroundColor"] == clear and
                not glass["userInteractionEnabled"] and owner["subviews"][0] == surface,
                "material covers the native full-size backing without intercepting touch")
    require(entry_state["frame"] == entry_frame and entry_state["hitInsets"] == (-15, -16, -15, -16) and
            entry_state["gesture_action"] == "handleTap" and caption in entry_state["subviews"] and
            reward_state["gesture_action"] == "handleStandaloneGift" and glyph in reward_state["subviews"],
            "discussion expands to the card and each original gesture and foreground is retained")
    chapter_theme = runtime.color("chapter after theme change")
    send(cpu, runtime, reward, "updateWithThemeConfigChange:", runtime.color("gift after own theme change"))
    send(cpu, runtime, card, "updateWithReaderConfig:", chapter_theme)
    require(surface_for(card_fill) == card_surface and surface_for(reward_fill) == reward_surface and
            runtime.objects[card_fill].state["backgroundColor"] == clear and
            runtime.objects[reward_fill].state["backgroundColor"] == clear,
            "the card's final gift fill write is cleared before another layout without allocating another surface")
    runtime.objects[model].state["displayMode"] = 2
    send(cpu, runtime, card, "layoutSubviews")
    require(not surface_for(card_fill) and entry_state["hitInsets"] == (0, 0, 0, 0) and
            runtime.objects[card_fill].state["backgroundColor"] == chapter_theme,
            "author-talk reuse restores the card and original discussion tap bounds")
    runtime.objects[model].state["displayMode"] = 1
    send(cpu, runtime, card, "layoutSubviews")
    runtime.objects[runtime.DEFAULTS].state["values"]["FanqieAdBlock.GlassDisabled.1"] = 1
    send(cpu, runtime, card, "layoutSubviews")
    send(cpu, runtime, reward, "layoutSubviews")
    require(not surface_for(card_fill) and not surface_for(reward_fill) and
            entry_state["hitInsets"] == (0, 0, 0, 0) and
            runtime.objects[reward_fill].state["backgroundColor"] == chapter_theme and reward_state["clipsToBounds"],
            "disabling glass restores both native backgrounds, the gift mask and original hit bounds")
    runtime.objects[runtime.DEFAULTS].state["values"]["FanqieAdBlock.GlassDisabled.1"] = 0

    profile = runtime.view("SSMyUserBar", "bar", (0, 0, 390, 96), runtime.ROOT)
    search = runtime.view("UIView", "searchBgView", (16, 20, 260, 40), profile,
                          clipsToBounds=True)
    carousel = runtime.view("UIView", "carouseView", (32, 0, 220, 40), search)
    current = runtime.label("currentCue", carousel, (0, 0, 220, 40), "当前提示词")
    upcoming = runtime.label("nextCue", carousel, (0, 40, 220, 40), "下一条提示词")
    left_stack = runtime.view("UIView", "scan stack", (12, 16, 24, 24), profile)
    scan = runtime.view("FQReaderSaaSBaseImageView", "scan", (0, 0, 24, 24), left_stack,
                        userInteractionEnabled=True)
    night = runtime.view("FQReaderSaaSBaseImageView", "night", (319, 16, 24, 24), profile,
                         userInteractionEnabled=True)
    menu = runtime.view("FQReaderSaaSBaseImageView", "menu", (360, 16, 24, 24), profile,
                        userInteractionEnabled=True)
    profile_state = runtime.objects[profile].state
    profile_state.update(searchBgView=search, scanQRCodeView=scan, darkModeImageView=night,
                         sideBarButtonView=menu)
    send(cpu, runtime, profile, "layoutSubviews")
    require(call(cpu, labels, "LFQH_FQHSurface", search)["result"], "profile search glass")
    require(runtime.objects[search].state["clipsToBounds"],
            "profile search glass clips the outgoing and incoming cue words to the pill")
    require(runtime.objects[carousel].state["subviews"] == [current, upcoming] and
            runtime.objects[upcoming].state["frame"] == (0, 40, 220, 40),
            "profile carousel retains both native labels and their frames")
    mounted = profile_state["subviews"]
    icons = [mounted[mounted.index(anchor) - 1] for anchor in (left_stack, night, menu)]
    for surface, frame in zip(icons, [(6, 10, 36, 36), (313, 10, 36, 36), (354, 10, 36, 36)]):
        state = runtime.objects[surface].state
        require(runtime.is_kind(surface, runtime.classes["UIVisualEffectView"]) and
                state["frame"] == frame and not state["userInteractionEnabled"],
                "passive glass sits behind each original UIImageView, including the nested scan icon")
    send(cpu, runtime, profile, "layoutSubviews")
    require([mounted[mounted.index(anchor) - 1] for anchor in (left_stack, night, menu)] == icons and
            all(runtime.objects[icon].state["userInteractionEnabled"] for icon in (scan, night, menu)),
            "profile layout reuses the three materials and preserves native tap targets")
    runtime.objects[runtime.DEFAULTS].state["values"]["FanqieAdBlock.GlassDisabled.1"] = 1
    send(cpu, runtime, profile, "layoutSubviews")
    require(not any(surface in mounted for surface in icons), "disabling glass removes the three siblings")
    runtime.objects[runtime.DEFAULTS].state["values"]["FanqieAdBlock.GlassDisabled.1"] = 0

    profile_root = runtime.view("UIView", "Mine root", (0, 0, 440, 956), runtime.ROOT)
    profile_feed = runtime.view("FQFeedListCollectionView", "Mine outer feed", (0, 106, 440, 850), profile_root,
                                contentInset=(0, 0, 57, 0), contentOffset=(0, 230), clipsToBounds=True)
    feed_state = runtime.objects[profile_feed].state
    nested_feed = runtime.view("FQFeedListCollectionView", "Mine nested recommendations",
                               (0, 200, 440, 750), profile_feed, contentInset=(0, 0, 0, 0))
    nested_frame = runtime.objects[nested_feed].state["frame"]
    original_bar_color = runtime.color("stock Mine bar color")
    profile_chrome = runtime.view("SSMyUserBar", "Mine top bar", (0, 0, 440, 106), profile_root,
                                  backgroundColor=original_bar_color, opaque=True, userInteractionEnabled=True)
    profile_controller = runtime.obj("SSMyUser621ViewController", "Mine controller", view=profile_root,
                                     myUserBar=profile_chrome, collectionView=profile_feed)
    send(cpu, runtime, profile_controller, "updateCollectionLayout")
    siblings = runtime.objects[profile_root].state["subviews"]
    require(len(siblings) == 3 and siblings[0] == profile_feed and siblings[2] == profile_chrome,
            "Mine blur samples the outer list and sits behind the native top controls")
    profile_blur = siblings[1]
    blur_state = runtime.objects[profile_blur].state
    require(blur_state["frame"] == (0, 0, 440, 106) and not blur_state["userInteractionEnabled"] and
            runtime.objects[blur_state["effect"]].state["style"] == 7,
            "Mine bar uses one passive adaptive thin blur from the status area to the header bottom")
    require(feed_state["frame"] == (0, 50, 440, 906) and feed_state["contentOffset"] == (0, 174) and
            feed_state["contentInset"] == (56, 0, 57, 0) and feed_state["clipsToBounds"] and
            runtime.objects[nested_feed].state["frame"] == nested_frame,
            "Only the outer viewport expands, preserving the scroll anchor, lower edge and nested feed")
    require(runtime.objects[profile_chrome].state["backgroundColor"] == clear and
            not runtime.objects[profile_chrome].state["opaque"] and
            runtime.objects[profile_chrome].state["userInteractionEnabled"],
            "The host bar retains touch while its opaque backing is removed")
    send(cpu, runtime, profile_controller, "updateCollectionLayout")
    require(siblings == [profile_feed, profile_blur, profile_chrome] and feed_state["contentOffset"] == (0, 174),
            "Repeated profile layout reuses blur and never reapplies the scroll delta")
    runtime.objects[runtime.DEFAULTS].state["values"]["FanqieAdBlock.GlassDisabled.1"] = 1
    send(cpu, runtime, profile_controller, "updateCollectionLayout")
    require(siblings == [profile_feed, profile_chrome] and feed_state["frame"] == (0, 106, 440, 850) and
            feed_state["contentInset"] == (0, 0, 57, 0) and feed_state["contentOffset"] == (0, 230) and
            runtime.objects[profile_chrome].state["backgroundColor"] == original_bar_color and
            runtime.objects[profile_chrome].state["opaque"],
            "Disabling glass restores Mine geometry, scroll position, and native bar color")
    runtime.objects[runtime.DEFAULTS].state["values"]["FanqieAdBlock.GlassDisabled.1"] = 0

    shortcut_count = 0
    shortcut_background = runtime.color("original shortcut content")
    for row_class, item_class in (
        ("SSMyUserShortcutCell", "SSMyUser621FunctionEntryItemCell"),
        ("SSMyUserCollectionView1Cell", "SSMyUserCollectionViewFunCell"),
    ):
        row = runtime.view(row_class, "Mine shortcut row", (0, 0, 390, 64), runtime.ROOT)
        collection = runtime.view("UIView", "Mine shortcut scroller", (0, 0, 390, 64), row)
        compact = row_class == "SSMyUserShortcutCell"
        width, height = (60, 47) if compact else (70, 60)
        for index, title in enumerate(("我的订单", "浏览历史", "我的消息", "创作中心", "游戏中心")):
            legacy_order = compact and index == 0
            cell_class = "SSMyUserCollectionViewOrderFunCell" if legacy_order else item_class
            cell_frame = (index * 78, 0, width, height)
            cell = runtime.view(cell_class, title, cell_frame, collection,
                                userInteractionEnabled=True)
            content = runtime.view("UIView", "opaque contentView", (0, 0, width, height), cell,
                                   backgroundColor=shortcut_background)
            stock_glyph = (17, 5, 26, 26) if legacy_order else ((width - 20) / 2, 8, 20, 20)
            if compact:
                caption_frame = (4, 29, 52, 14)
                material_frame = (0, 0, 60, 47)
                adjusted_glyph = (21.5, 3, 17, 17)
            elif index == 4:
                caption_frame = (0, 29, 70, 18)
                material_frame = (0, 0, 70, 52)
                adjusted_glyph = (26, 3, 18, 18)
            else:
                caption_frame = (0, 35, 70, 18)
                material_frame = (0, 0, 70, 58)
                adjusted_glyph = (23, 3, 24, 24)
            x, _, label_width, label_height = caption_frame
            adjusted_caption = (x, material_frame[3] - label_height - 10, label_width, label_height)
            image = runtime.view("UIImageView", "original icon", stock_glyph, content)
            label = runtime.label("original caption", content, caption_frame, title)
            cell_state = runtime.objects[cell].state
            cell_state["contentView"] = content
            foreground = [image, label]
            if legacy_order:
                overlay = runtime.view("UIImageView", "optional product image", stock_glyph, content, alpha=0)
                cell_state.update(image=image, productImage=overlay, label=label)
                foreground.append(overlay)
            elif item_class == "SSMyUser621FunctionEntryItemCell":
                cell_state.update(productImage=image, functionType=label)
            else:
                cell_state.update(image=image, label=label)
            send(cpu, runtime, cell, "layoutSubviews")
            surface = call(cpu, labels, "LFQH_FQHSurface", content)["result"]
            require(surface and runtime.objects[content].state["subviews"] == [surface] + foreground and
                    runtime.objects[surface].state["frame"] == material_frame and
                    runtime.objects[image].state["frame"] == adjusted_glyph and
                    runtime.objects[label].state["frame"] == adjusted_caption and
                    runtime.string_value(runtime.objects[label].state["text"]) == title and
                    runtime.objects[content].state["backgroundColor"] == shortcut_background and
                    not runtime.objects[surface].state["userInteractionEnabled"] and
                    cell_state["userInteractionEnabled"] and cell_state["frame"] == cell_frame,
                    "one full-size capsule leaves 10pt below the full native caption without changing its hit area")
            effect = runtime.objects[runtime.objects[surface].state["effect"]].state
            require(effect["style"] == 0 and not effect.get("tintColor"),
                    "shortcut material has no forced gray tint")
            if legacy_order:
                require(runtime.objects[overlay].state["frame"] == adjusted_glyph,
                        "the native layout copies the normalized order glyph frame to its product overlay")
            send(cpu, runtime, cell, "layoutSubviews")
            require(call(cpu, labels, "LFQH_FQHSurface", content)["result"] == surface and
                    runtime.objects[image].state["frame"] == adjusted_glyph and
                    runtime.objects[label].state["frame"] == adjusted_caption,
                    "shortcut layouts reuse the native material and settle the foreground once")
            snapshots = sum(obj.name == "rect_snapshot" for obj in runtime.objects.values())
            for _ in range(5):
                runtime.objects[image].state["frame"] = stock_glyph
                runtime.objects[label].state["frame"] = caption_frame
                send(cpu, runtime, cell, "layoutSubviews")
            require(sum(obj.name == "rect_snapshot" for obj in runtime.objects.values()) == snapshots and
                    runtime.objects[image].state["frame"] == adjusted_glyph and
                    runtime.objects[label].state["frame"] == adjusted_caption,
                    "native relayout reuses the saved original and applied foreground rectangles")
            shortcut_count += 1

    glass_preferences = runtime.objects[runtime.DEFAULTS].state["values"]
    glass_preferences["FanqieAdBlock.GlassDisabled.1"] = 1
    send(cpu, runtime, cell, "layoutSubviews")
    require(runtime.objects[label].state["frame"] == caption_frame and
            runtime.objects[image].state["frame"] == stock_glyph,
            "disabling the shortcut material restores its native icon and caption frames")
    glass_preferences["FanqieAdBlock.GlassDisabled.1"] = 0
    send(cpu, runtime, cell, "layoutSubviews")
    runtime.reparent(cell, runtime.ROOT)
    send(cpu, runtime, cell, "layoutSubviews")
    require(not call(cpu, labels, "LFQH_FQHSurface", content)["result"] and
            runtime.objects[image].state["frame"] == stock_glyph and
            runtime.objects[label].state["frame"] == caption_frame and
            runtime.objects[content].state["backgroundColor"] == shortcut_background,
            "reusing the same class outside the shortcut row restores the host foreground and background")

    # Standalone promotions are excluded regardless of title or metadata timing.
    owner = runtime.view("SSMyUser621BaseViewController", "profile",
                         (0, 0, 390, 844), runtime.ROOT)
    models = runtime.obj("NSMutableArray", "models", items=[])
    runtime.objects[owner].state["models"] = models
    target = runtime.obj("SSMyUserMiniGameEntranceCellModel", "target",
                         info=runtime.obj("SSSSTimorCellInfo", "target_info",
                                          title=runtime.text_object("抓大鹅")),
                         isInvisible=False, isDisabled=False)
    shortcut_row = runtime.obj("NSObject", "original shortcuts row")
    runtime.objects[models].state["items"] = [shortcut_row]
    runtime.objects[owner].state["miniGameEntranceCellModel"] = target
    send(cpu, runtime, owner, "setupCellMiniGameEntranceData")
    require(runtime.objects[target].state["isInvisible"] is True and
            runtime.objects[target].state["isDisabled"] is True and
            runtime.objects[models].state["items"] == [shortcut_row],
            "only the standalone promotion is removed from the host plan")

    # Modern Mine monetization cards arrive through the typed server-plan entries.
    configured = runtime.obj("SSMyUserCell2Model", "configured Mine card")
    old_title = runtime.text_object("抓大鹅")
    new_title = runtime.text_object("疯狂水世界")
    old_game = runtime.obj("SSMineGameEntranceData", "old campaign", title=old_title)
    new_game = runtime.obj("SSMineGameEntranceData", "current campaign", title=new_title)
    pure_promotion = runtime.obj("SSMineEcomEntranceData", "single-game entry", entranceType=9,
                                 gameEntranceData=old_game)
    rotating_promotion = runtime.obj("SSMineEcomEntranceData", "rotated game entry", entranceType=9,
                                     gameEntranceData=new_game)
    placeholder = runtime.obj("SSMineEcomEntranceData", "game slot before payload", entranceType=9)
    unrelated_entry = runtime.obj("SSMineEcomEntranceData", "coupon entry", entranceType=2,
                                  gameEntranceData=new_game)
    response_items = [unrelated_entry, pure_promotion, rotating_promotion, placeholder]
    response = runtime.obj("NSArray", "cached Mine response", items=response_items[:])
    apply_entrances = "applyConfiguredMineEcomEntranceData:mineMonetizationStyle:"
    send(cpu, runtime, configured, apply_entrances, response, 3)
    state = runtime.objects[configured].state
    entries = runtime.objects[state["configured_entries"]].state["items"]
    require(state["configured_style"] == 3 and entries == [unrelated_entry],
            "native layout receives the coupon and no rotating game slot, independent of title or payload")
    require(runtime.objects[response].state["items"] == response_items and
            runtime.objects[old_game].state["title"] == old_title and
            runtime.objects[new_game].state["title"] == new_title,
            "cached server plans remain intact")
    unchanged = runtime.obj("NSArray", "no target", items=[unrelated_entry])
    send(cpu, runtime, configured, apply_entrances, unchanged, 2)
    require(state["configured_entries"] == unchanged and state["configured_style"] == 2,
            "unrelated server plans pass through by identity")

    # Legacy card metadata can be absent during setup and filled before the next native diff.
    late_target = runtime.obj("SSMyUserMiniGameEntranceCellModel", "late model", info=0)
    combined = runtime.obj("SSMyUserShopAndMiniGameEntranceCellModel", "combined shop and game row",
                           info=runtime.objects[target].state["info"])
    legacy_plan = runtime.obj("NSArray", "legacy adapter plan", items=[late_target, shortcut_row, combined])
    legacy_owner = runtime.obj("SSMyUser621ViewController", "native Mine list", list_objects=legacy_plan)
    filtered_rows = send(cpu, runtime, legacy_owner, "objectsForListAdapter:", 0)["result"]
    require(runtime.objects[filtered_rows].state["items"] == [shortcut_row, combined] and
            runtime.objects[legacy_plan].state["items"] == [late_target, shortcut_row, combined],
            "the list diff excludes standalone game rows even before metadata, preserving shortcuts and shop")

    wallet = runtime.obj("SSMyUserCell2Model", "coins, cash and benefits", businessStyle=4)
    treasure = runtime.obj("SSMyUserCell2Model", "coin task with cooldown", businessStyle=5)
    legacy_wallet = runtime.obj("SSMyUserCell2Model", "legacy balance", businessStyle=0)
    personalized = runtime.obj("SSMyUserCell2Model", "legacy balance and daily benefits", businessStyle=0,
                               isShowPersonalizedBar=True, isShowFriendView=True)
    referral = runtime.obj("SSMyUserCell2Model", "legacy referral", businessStyle=0, isShowFriendView=True)
    coupon = runtime.obj("SSMyUserCell2Model", "mixed commerce", businessStyle=3)
    original_mine_rows = [shortcut_row, wallet, coupon, treasure, legacy_wallet, personalized, referral, combined]
    mine_plan = runtime.obj("NSArray", "Mine section plan", items=original_mine_rows[:])
    runtime.objects[legacy_owner].state["list_objects"] = mine_plan
    require(send(cpu, runtime, legacy_owner, "objectsForListAdapter:", 0)["result"] == mine_plan,
            "the benefits section stays visible by default")
    mine_benefits_key = "FanqieX.MineBenefitsCard.1"
    mine_prefs = runtime.objects[runtime.DEFAULTS].state["values"]
    mine_prefs[mine_benefits_key] = False
    filtered_rows = send(cpu, runtime, legacy_owner, "objectsForListAdapter:", 0)["result"]
    require(runtime.objects[filtered_rows].state["items"] == [shortcut_row, coupon, referral, combined] and
            runtime.objects[mine_plan].state["items"] == original_mine_rows,
            "disabling benefits removes both legacy personalized and modern wallet sections from the diff")
    mine_prefs[mine_benefits_key] = True
    require(send(cpu, runtime, legacy_owner, "objectsForListAdapter:", 0)["result"] == mine_plan,
            "re-enabling benefits restores the same section objects in their original order")

    # The production hook filters the host controller's parallel plan and index map.
    tab_types = (0, 7, 3, 4, 9)
    keys = [f"FanqieX.Bottom{key}.1" for key in (
        "Bookstore", "Drama", "Bookshelf", "Mine", "Mall")]
    titles = ("书城", "短剧", "书架", "我的", "商城")
    models = [runtime.obj("NSObject", title) for title in titles]
    boxed_types = [runtime.box(value) for value in tab_types]
    plan = runtime.obj("NSArray", "native child plan", items=models)
    types = runtime.obj("NSArray", "native tab types", items=boxed_types)
    indexes = runtime.obj("NSDictionary", "native indexes",
                          items={value: runtime.box(i) for i, value in enumerate(tab_types)})
    tab_owner = runtime.obj("SSTabBarController", "host tabs", host_plan=plan, host_types=types,
                            host_indexes=indexes, titles={value: runtime.text_object(title)
                                                          for value, title in zip(tab_types, titles)})
    tab_state = runtime.objects[tab_owner].state
    prefs = runtime.objects[runtime.DEFAULTS].state["values"]
    require(send(cpu, runtime, tab_owner, "tabbarVCAndAttributeInit")["result"] == plan,
            "all entries remain enabled by default")
    for hidden, key in enumerate(keys):
        prefs[key] = False
        result = send(cpu, runtime, tab_owner, "tabbarVCAndAttributeInit")["result"]
        require(runtime.objects[result].state["items"] == models[:hidden] + models[hidden + 1:] and
                runtime.objects[tab_state["typeArray"]].state["items"] ==
                boxed_types[:hidden] + boxed_types[hidden + 1:],
                "each switch hides only its controller and the corresponding visible item")
        kept_types = tab_types[:hidden] + tab_types[hidden + 1:]
        compacted = {key: runtime.objects[value].state["value"] for key, value in
                     runtime.objects[tab_state["typeIndexMap"]].state["items"].items()}
        require(compacted == dict(zip(kept_types, range(len(kept_types)))),
                "tab selection indexes are compacted with the plan")
        prefs[key] = True
    require(send(cpu, runtime, tab_owner, "tabbarVCAndAttributeInit")["result"] == plan,
            "restoring preferences reuses the original plan")

    # Settings are installed on the real lazily-created table and persist before refreshing.
    table = runtime.view("UITableView", "plugin settings", (0, 0, 0, 0), runtime.ROOT)
    options = runtime.obj("UIViewController", "dynamic options", tableView=table)
    call(cpu, labels, "LFQH_FQHInstallOptionsToggles", options)
    header = runtime.objects[table].state["tableHeaderView"]
    require(runtime.objects[header].state["frame"] == (0.0, 0.0, 320.0, 400.0),
            "an unsized table starts with a consistent header and control width")
    switches = [item for item in runtime.objects[header].state["subviews"]
                if runtime.is_kind(item, runtime.classes["UISwitch"])]
    switch_labels = [runtime.string_value(runtime.objects[item].state["accessibilityLabel"])
                     for item in switches]
    require(switch_labels == [f"底栏显示：{title}" for title in titles] +
            ["书架显示今日看听读时长", "我的显示金币与福利卡片", "阅读菜单显示上下栏背景"] and
            all(runtime.objects[item].state["isOn"] for item in switches),
            "settings expose the current bottom entries and the shelf duration switch")

    # Duration uses the host visibility setter and keeps the latest requested state.
    duration_switch = switches[-3]
    duration_observer, duration_action, _ = runtime.objects[duration_switch].state["control_targets"][0]
    duration_selector = runtime.selector_names[duration_action]
    shelf_header = runtime.view("SS525BookShelfSubHeaderView", "live shelf header", (0, 0, 390, 64),
                                runtime.ROOT, showReadTimeView=True)
    duration = runtime.view("UIButton", "reading duration", (20, 4, 150, 32), shelf_header)
    runtime.objects[shelf_header].state["coinButton"] = duration
    send(cpu, runtime, shelf_header, "layoutSubviews")
    runtime.objects[duration_switch].state["isOn"] = False
    send(cpu, runtime, duration_observer, duration_selector, duration_switch)
    require(prefs["FanqieX.ShelfReadingDuration.1"] is False and
            runtime.objects[duration].state["hidden"] and not runtime.tab_refreshes,
            "disabling duration updates the mounted control without rebuilding tabs")
    send(cpu, runtime, shelf_header, "setShowReadTimeView:", 1)
    require(runtime.objects[duration].state["hidden"], "host refresh respects the off preference")
    runtime.objects[duration_switch].state["isOn"] = True
    send(cpu, runtime, duration_observer, duration_selector, duration_switch)
    require(not runtime.objects[duration].state["hidden"], "enabling restores the host-visible control")
    send(cpu, runtime, shelf_header, "setShowReadTimeView:", 0)
    send(cpu, runtime, duration_observer, duration_selector, duration_switch)
    require(runtime.objects[duration].state["hidden"], "plugin respects the host's own hidden state")
    # Edit follows the duration preference while retaining the native control.
    shelf_controller = runtime.obj("SSBookShelfSubViewController", "native shelf subcontroller")
    shelf_owner = runtime.obj("SSBookShelf525ViewController", "shelf tabs", currentTabVC=shelf_controller)
    top = runtime.view("UIView", "top shelf chrome", (0, 64, 440, 44), runtime.ROOT)
    title_collection = runtime.view("UIView", "shelf title collection", (0, 0, 440, 44), top)
    category = runtime.view("SSBookShelfTabSelectViewTitleCell", "rightmost shelf title",
                            (178, 6, 40, 32), title_collection)
    runtime.objects[title_collection].state.update(
        collectionView=title_collection, visibleCells=runtime.obj("NSArray", "visible titles", items=[category]))
    holder = runtime.view("UIView", "search and more", (364, 10, 56, 24), top)
    runtime.objects[shelf_owner].state.update(tabSelectView=title_collection, headerView=top, headerRightView=holder)
    search = runtime.view("UIButton", "shelf search", (0, 0, 24, 24), holder)
    more = runtime.view("UIButton", "shelf more", (32, 0, 24, 24), holder)
    cell = runtime.view("SSBookShelfFunctionCell", "shelf function row", (0, 110, 440, 70),
                        runtime.ROOT, delegate=shelf_controller, headerView=shelf_header, showsFilterExposure=True)
    clip = runtime.view("UIView", "filter exposure", (0, 42, 440, 28), cell)
    runtime.objects[cell].state["filterClipView"] = clip
    secondary = runtime.view("UIView", "secondary buttons", (0, 0, 440, 42), shelf_header)
    runtime.objects[duration].state["superview"] = secondary
    runtime.objects[secondary].state["subviews"].append(duration)
    edit_targets = [(shelf_header, runtime.sel("onClickEdit"), 64)]
    edit = runtime.view("UIButton", "original edit", (380, 4, 44, 30), secondary, control_targets=edit_targets[:])
    edit_title = runtime.label("native edit title", edit, (0, 5, 30, 20), "编辑")
    separator = runtime.view("UIView", "native secondary divider", (320, 4, 1, 22), secondary)
    runtime.objects[shelf_header].state.update(
        delegate=shelf_controller, editButton=edit, secondaryView=secondary, lineView=separator, isFiltering=False)
    size_layout = runtime.obj("NSObject", "shelf collection layout", invalidations=0)
    shelf_list = runtime.view("UIView", "shelf collection", (0, 108, 440, 700), runtime.ROOT,
                             collectionViewLayout=size_layout)
    shelf_model = runtime.obj("SSBookShelfViewModel", "shelf section types", section_types=[0, 1, 2, 3, 4])
    runtime.objects[shelf_controller].state.update(
        delegate=shelf_owner, functionCell=cell, searchAndMoreView=holder, searchButton=search,
        moreButton=more, collectionView=shelf_list, viewModel=shelf_model)
    legacy = cpu.run(labels["LGshelf_material"], args=(edit,), fp_args=(-8., 0., 44., 30.),
                     max_steps=1_500_000)["result"]
    require(legacy in runtime.objects[edit].state["subviews"], "an already-mounted legacy capsule exercises cleanup")
    runtime._add(runtime.classes["SS525BookShelfSubHeaderView"], "fqab_v4_shelf_subheader", runtime.LAYOUT_IMP, "v16@0:8")
    # The compiled inherited layout recursively styles the button in its old row before the modern hook.
    cpu.run(0x7fb0, args=(shelf_header, runtime.sel("layoutSubviews")), max_steps=1_500_000)
    require(runtime.objects[edit].state["subviews"] == [edit_title],
            "the inherited layout releases its Edit material and keeps the native title")
    edit_background = runtime.color("native shelf edit background")
    runtime.objects[edit].state["backgroundColor"] = edit_background
    send(cpu, runtime, shelf_header, "setShowReadTimeView:", 1)
    send(cpu, runtime, shelf_header, "layoutSubviews")
    edit_state = runtime.objects[edit].state
    require(edit_state["superview"] == secondary and edit_state["frame"] == (380., 4., 44., 30.) and
            runtime.objects[size_layout].state["invalidations"] == 0,
            "duration on keeps Edit at the right of its original row")
    edit_glass = surface_for(edit)
    send(cpu, runtime, shelf_header, "setShowReadTimeView:", 0)
    send(cpu, runtime, shelf_header, "layoutSubviews")
    require(edit_state["superview"] == secondary and surface_for(edit) == edit_glass,
            "a temporary host hide does not move Edit while the preference is on")
    send(cpu, runtime, shelf_header, "setShowReadTimeView:", 1)
    runtime.objects[duration_switch].state["isOn"] = False
    send(cpu, runtime, duration_observer, duration_selector, duration_switch)
    send(cpu, runtime, shelf_header, "layoutSubviews")
    require(edit_state["superview"] == holder and edit_state["frame"] == (-132., -3., 44., 30.) and
            runtime.objects[holder].state["hitInsets"][1] <= -132.,
            "the original edit sits between measured category and search with its entire hit rectangle")
    require(edit_glass and surface_for(edit) == edit_glass and
            runtime.objects[edit_glass].state["frame"] == (0., 1., 44., 28.) and
            not runtime.objects[edit_glass].state["userInteractionEnabled"] and edit_state["control_targets"] == edit_targets,
            "the moved edit uses the matching capsule without intercepting or replacing the tap")
    edit_frame = edit_state["frame"]
    send(cpu, runtime, shelf_header, "layoutEditButton")
    require(edit_state["frame"] == edit_frame and edit_state["subviews"].count(edit_glass) == 1,
            "native secondary-row layout cannot reposition the moved edit or its glass")
    require(edit_state["subviews"] == [edit_glass, edit_title], "the moved edit has exactly one capsule")
    require(runtime.objects[size_layout].state["invalidations"] == 1,
            "only the transition to a compact row invalidates the list")
    function = runtime.obj("NSObject", "function index", section=1)
    book = runtime.obj("NSObject", "book index", section=4)
    size_selector = "collectionView:layout:sizeForItemAtIndexPath:"
    inset_selector = "collectionView:layout:insetForSectionAtIndex:"
    model_type = runtime.get_method(runtime.classes["SSBookShelfViewModel"], runtime.sel("sectionTypeAtIndex:"))
    runtime.methods[model_type]["encoding"] = "@24@0:8q16"
    send(cpu, runtime, shelf_controller, size_selector, shelf_list, size_layout, function)
    require(cpu.fp(1) == 70., "a changed private section type accessor leaves native geometry")
    runtime.methods[model_type]["encoding"] = "q24@0:8q16"
    send(cpu, runtime, shelf_controller, size_selector, shelf_list, size_layout, function)
    require(cpu.fp(1) == 30., "the exposed row keeps its full 28pt filter and a 2pt top inset")
    send(cpu, runtime, shelf_controller, size_selector, shelf_list, size_layout, book)
    require(cpu.fp(1) == 70., "book row geometry stays at the native size")
    send(cpu, runtime, cell, "layoutContainerSubviews")
    require(runtime.objects[clip].state["frame"] == (0., 2., 440., 28.),
            "exposed filter follows the compact row without clipping")
    send(cpu, runtime, shelf_controller, inset_selector, shelf_list, size_layout, 1)
    require(tuple(cpu.fp(i) for i in range(4)) == (0., 11., 12., 11.),
            "the exposed filter retains the section's stock insets")
    runtime.shelf_base_height = 34.
    runtime.shelf_function_height = 74.
    send(cpu, runtime, shelf_controller, size_selector, shelf_list, size_layout, function)
    require(cpu.fp(1) == 30., "the native font-scaled spacer is removed without changing the filter height")
    runtime.objects[cell].state["showsFilterExposure"] = False
    runtime.shelf_function_height = 34.
    send(cpu, runtime, shelf_controller, size_selector, shelf_list, size_layout, function)
    require(cpu.fp(1) == 1., "only a one-point edit owner remains when the filter is a separate header")
    send(cpu, runtime, shelf_controller, inset_selector, shelf_list, size_layout, 1)
    require(tuple(cpu.fp(i) for i in range(4)) == (0., 11., 0., 11.),
            "the empty section drops the 12pt spacer before the independent filter header")
    send(cpu, runtime, shelf_controller, inset_selector, shelf_list, size_layout, 4)
    require(tuple(cpu.fp(i) for i in range(4)) == (0., 11., 12., 11.),
            "the book section keeps its native insets")
    book_data = runtime.obj("NSObject", "opened book", bookId=runtime.text_object("book-1"))
    tile_model = runtime.obj("NSObject", "visible book model",
                             collectDatas=runtime.obj("NSArray", "book data", items=[book_data]))
    tile = runtime.view("SSBookShelfBaseCell", "book tile", (20, 40, 100, 175), shelf_list,
                        cellModel=tile_model, cover_size=(96., 138.))
    cover = runtime.view("UIView", "live book cover", (0, 2, 96, 138), tile)
    runtime.objects[tile].state["fetchCoverView"] = cover
    list_state = runtime.objects[shelf_list].state
    list_state.update(layout_passes=0, visibleCells=runtime.obj("NSArray", "visible book cells", items=[tile]))
    info = runtime.obj("SSCoverTransitionInfo", "native detached cover snapshot", cover_frame=(20., 199., 96., 138.))
    controller_state = runtime.objects[shelf_controller].state
    controller_state.update(openingModel=runtime.obj("NSObject", "opening model", data=book_data), cover_transition=info)
    send(cpu, runtime, shelf_controller, "saveOpeningData:indexPath:", book_data, book)
    require(controller_state["capture"] == (book_data, book, 1), "native capture follows the compact layout pass")
    transition_selector = "fetchBookCoverTransitionInfo:"
    require(send(cpu, runtime, shelf_controller, transition_selector, 2)["result"] == info and
            runtime.objects[info].state["cover_frame"] == (20., 150., 96., 138.) and
            controller_state["lookup_layout_passes"] == 2,
            "push reuses the snapshot at the live compact cover origin")
    runtime.objects[tile].state.update(frame=(180, 40, 104, 181), cover_size=(100., 144.))
    require(send(cpu, runtime, shelf_controller, transition_selector, 3)["result"] == info and
            runtime.objects[info].state["cover_frame"] == (180., 150., 100., 144.) and
            controller_state["lookup_layout_passes"] == 3,
            "pop follows the matching book's current position and native cover size after a reorder")
    cover_size = runtime.get_method(runtime.classes["SSBookShelfBaseCell"], runtime.sel("fetchCoverSize"))
    runtime.methods[cover_size]["encoding"] = "d16@0:8"
    runtime.objects[tile].state["frame"] = (240, 40, 104, 181)
    require(send(cpu, runtime, shelf_controller, transition_selector, 3)["result"] == info and
            runtime.objects[info].state["cover_frame"] == (180., 150., 100., 144.),
            "an incompatible cover size getter keeps the host transition untouched")
    runtime.methods[cover_size]["encoding"] = "{CGSize=dd}16@0:8"
    runtime.objects[tile_model].state["collectDatas"] = runtime.obj("NSArray", "reused cell data", items=[])
    require(send(cpu, runtime, shelf_controller, transition_selector, 3)["result"] == 0,
            "without the matching live book, the host uses its ordinary page animation")
    runtime.shelf_base_height = 30.
    runtime.shelf_function_height = 70.
    runtime.objects[cell].state["showsFilterExposure"] = True
    runtime.objects[duration_switch].state["isOn"] = True
    send(cpu, runtime, duration_observer, duration_selector, duration_switch)
    send(cpu, runtime, shelf_header, "layoutSubviews")
    require(edit_state["superview"] == secondary and edit_state["frame"] == (380., 4., 44., 30.) and
            runtime.objects[size_layout].state["invalidations"] == 2,
            "re-enabling duration restores Edit and the stock row in the same layout pass")
    require(send(cpu, runtime, shelf_controller, transition_selector, 3)["result"] == info,
            "uncompacted shelf keeps the stock transition info")
    send(cpu, runtime, shelf_controller, size_selector, shelf_list, size_layout, function)
    require(cpu.fp(1) == 70., "visible duration restores the native function height")
    send(cpu, runtime, shelf_controller, inset_selector, shelf_list, size_layout, 1)
    require(tuple(cpu.fp(i) for i in range(4)) == (0., 11., 12., 11.),
            "visible duration also restores the native function insets")
    send(cpu, runtime, cell, "layoutContainerSubviews")
    require(runtime.objects[clip].state["frame"] == (0., 42., 440., 28.),
            "visible duration leaves the native function and filter geometry intact")
    runtime.objects[category].state["frame"] = (292., 6., 40., 32.)
    runtime.objects[duration_switch].state["isOn"] = False
    send(cpu, runtime, duration_observer, duration_selector, duration_switch)
    send(cpu, runtime, shelf_header, "layoutSubviews")
    require(edit_state["superview"] == secondary and edit_state["frame"] == (380., 4., 44., 30.),
            "a narrower title/search gap restores the original position")
    require(surface_for(edit) == edit_glass and edit_state["control_targets"] == edit_targets,
            "the original lower placement keeps its glass and edit target")
    cpu.run(0x7fb0, args=(shelf_header, runtime.sel("layoutSubviews")), max_steps=1_500_000)
    require(edit_state["subviews"] == [edit_glass, edit_title], "returning to the stock row does not re-create old glass")
    glass_preferences = runtime.objects[runtime.DEFAULTS].state["values"]
    glass_preferences["FanqieAdBlock.GlassDisabled.1"] = 1
    cpu.run(0x7fb0, args=(shelf_header, runtime.sel("layoutSubviews")), max_steps=1_500_000)
    send(cpu, runtime, shelf_header, "layoutSubviews")
    require(edit_state["subviews"] == [edit_title] and edit_state["backgroundColor"] == edit_background and
            edit_state["control_targets"] == edit_targets, "glass off restores native Edit with neither material")
    glass_preferences["FanqieAdBlock.GlassDisabled.1"] = 0

    benefits_switch = switches[-2]
    benefits_observer, benefits_action, _ = runtime.objects[benefits_switch].state["control_targets"][0]
    benefits_selector = runtime.selector_names[benefits_action]
    for on in (False, True):
        runtime.objects[benefits_switch].state["isOn"] = on
        send(cpu, runtime, benefits_observer, benefits_selector, benefits_switch)
        require(mine_prefs[mine_benefits_key] is on, "the benefits switch persists its setting")
    require(runtime.mine_reloads == [(legacy_owner, "FanqieXMineBenefits")] * 2 and not runtime.tab_refreshes,
            "each benefits change refreshes the mounted native Mine list without rebuilding tabs")
    backdrop_switch = switches[-1]
    backdrop_observer, backdrop_action, _ = runtime.objects[backdrop_switch].state["control_targets"][0]
    for on in (False, True):
        runtime.objects[backdrop_switch].state["isOn"] = on
        send(cpu, runtime, backdrop_observer, runtime.selector_names[backdrop_action], backdrop_switch)
        require(prefs["FanqieX.ReaderBottomBackground.1"] is on and not runtime.tab_refreshes,
                "the reader background switch persists independently of the main tab bar")
    window = runtime.obj("UIView", "tab window", rootViewController=tab_owner)
    runtime.tab_app = runtime.obj("UIApplication", "active app", keyWindow=window)
    bar_parent = runtime.view("UIView", "bar parent", (0, 0, 390, 844), runtime.ROOT)
    tab_state["customTabBar"] = runtime.view("SSTabBar", "glass bar", (0, 760, 390, 84),
                                             bar_parent, delegate=tab_owner)
    mine_switch = switches[3]
    observer, action, _ = runtime.objects[mine_switch].state["control_targets"][0]
    runtime.objects[mine_switch].state["isOn"] = False
    send(cpu, runtime, observer, runtime.selector_names[action], mine_switch)
    require(prefs[keys[3]] is False and runtime.tab_refreshes == 1,
            "switch action persists and refreshes the real controller")
    send(cpu, runtime, tab_owner, "viewDidAppear:", 0)
    gestures = runtime.objects[bar_parent].state["recovery_gestures"]
    require(len(gestures) == 1, "hiding Mine gives the glass bar one recovery gesture")
    recovery = runtime.objects[gestures[0]].state
    touch = runtime.obj("NSObject", "test touch", touch_point=(195.0, 40.0))
    touch_method = "gestureRecognizer:shouldReceiveTouch:"
    require(send(cpu, runtime, recovery["delegate"], touch_method, gestures[0], touch)["result"],
            "recovery accepts a press within the bar")
    runtime.objects[touch].state["touch_point"] = (195.0, -40.0)
    require(not send(cpu, runtime, recovery["delegate"], touch_method, gestures[0], touch)["result"],
            "recovery does not intercept page touches above the bar")
    recovery["state"] = 1
    send(cpu, runtime, recovery["target"], runtime.selector_names[recovery["action"]], gestures[0])
    require(runtime.tab_settings_presenters == [tab_owner], "recovery opens the existing options action")
    prefs.update({key: False for key in keys})
    result = send(cpu, runtime, tab_owner, "tabbarVCAndAttributeInit")["result"]
    require(runtime.objects[result].state["items"] == models[:1] and prefs[keys[0]] is True,
            "invalid all-hidden persisted state recovers to one host controller")
    store_switch = switches[0]
    runtime.objects[store_switch].state["isOn"] = False
    send(cpu, runtime, observer, runtime.selector_names[action], store_switch)
    require(prefs[keys[0]] is True and runtime.objects[store_switch].state["isOn"] and runtime.tab_refreshes == 1,
            "the final navigation tab cannot be switched off")
    prefs[keys[3]] = True
    send(cpu, runtime, tab_owner, "viewDidAppear:", 0)
    require(not gestures, "recovery is removed when Mine becomes available again")

    return {
        "reader_controls": ["FQReaderSaaSBottomToolView", "SSReaderBottomToolDivertView",
                            "FQReaderSaaSReaderSpeechButton", "BDReaderNewSlider"],
        "reader_backdrop_and_chapter_controls": True,
        "reader_community_full_item_surfaces": True,
        "full_chapter_discussion_and_gift_surfaces": True,
        "shelf_tabs": len(tabs),
        "shelf_filters": len(filters),
        "profile_shortcuts": shortcut_count,
        "mine_benefits_section_toggle": True,
        "profile_search_clips_carousel": True,
        "profile_top_blur_and_feed_underlap": True,
        "profile_header_glass": len(icons),
        "target_game_deleted": True,
        "nonpromotion_mine_rows_retained": True,
        "configured_game_plan_filtered_before_layout": True,
        "late_game_filtered_before_list_diff": True,
        "bottom_entries_default_on": True,
        "bottom_entries_restored": True,
        "shelf_duration_toggle": True,
        "shelf_edit_top_placement_and_compaction": True,
        "shelf_edit_single_material_owner": True,
        "shelf_inline_filter_alignment": True,
        "shelf_cover_transition_geometry": True,
        "surface_reuse": True,
        "disable_restores_host": True,
        "host_layout_calls": 22,
        "exact_installed_hooks": installed,
    }


def incompatible_shelf_compaction(data, labels):
    cpu, runtime = make(data)
    runtime.labels = labels
    runtime.objects[runtime.DEFAULTS].state["values"]["FanqieX.ShelfReadingDuration.1"] = False
    model_cls = runtime.classes["SSBookShelfViewModel"]
    runtime.methods[runtime.get_method(model_cls, runtime.sel("sectionTypeAtIndex:"))]["encoding"] = "@24@0:8q16"
    call(cpu, labels, "LFQH_FQHPageInstall")
    controller = runtime.obj("SSBookShelfSubViewController", "alternate shelf controller")
    owner = runtime.obj("SSBookShelf525ViewController", "shelf root", currentTabVC=controller)
    top = runtime.view("UIView", "top shelf chrome", (0, 64, 440, 44), runtime.ROOT)
    title_collection = runtime.view("UIView", "shelf titles", (0, 0, 440, 44), top)
    title = runtime.view("SSBookShelfTabSelectViewTitleCell", "rightmost category",
                         (178, 6, 40, 32), title_collection)
    runtime.objects[title_collection].state.update(
        collectionView=title_collection, visibleCells=runtime.obj("NSArray", "visible titles", items=[title]))
    holder = runtime.view("UIView", "search and more", (364, 10, 56, 24), top)
    runtime.objects[owner].state.update(tabSelectView=title_collection, headerView=top, headerRightView=holder)
    search = runtime.view("UIButton", "search", (0, 0, 24, 24), holder)
    header = runtime.view("SS525BookShelfSubHeaderView", "shelf header", (0, 0, 440, 64),
                          runtime.ROOT, delegate=controller, isFiltering=False, showReadTimeView=False)
    secondary = runtime.view("UIView", "secondary row", (0, 0, 440, 42), header)
    edit = runtime.view("UIButton", "edit", (380, 4, 44, 30), secondary)
    duration = runtime.view("UIButton", "duration", (20, 4, 150, 32), secondary)
    runtime.objects[header].state.update(secondaryView=secondary, editButton=edit, coinButton=duration)
    cell = runtime.view("SSBookShelfFunctionCell", "function cell", (0, 110, 440, 70), runtime.ROOT,
                        headerView=header, delegate=controller, showsFilterExposure=True)
    clip = runtime.view("UIView", "filter clip", (0, 42, 440, 28), cell)
    runtime.objects[cell].state["filterClipView"] = clip
    layout = runtime.obj("NSObject", "shelf collection layout", invalidations=0)
    collection = runtime.view("UIView", "shelf collection", (0, 108, 440, 700), runtime.ROOT,
                              collectionViewLayout=layout)
    runtime.objects[controller].state.update(
        delegate=owner, functionCell=cell, searchAndMoreView=holder, searchButton=search,
        collectionView=collection, viewModel=runtime.obj("SSBookShelfViewModel", "changed model", section_types=[0, 1]))
    send(cpu, runtime, header, "layoutSubviews")
    require(runtime.objects[edit].state["superview"] == holder, "independent edit placement remains available")
    index = runtime.obj("NSObject", "function index", section=1)
    send(cpu, runtime, controller, "collectionView:layout:sizeForItemAtIndexPath:", collection, layout, index)
    require(cpu.fp(1) == 70., "an incompatible compact group keeps native row height")
    send(cpu, runtime, cell, "layoutContainerSubviews")
    require(runtime.objects[clip].state["frame"] == (0., 42., 440., 28.) and
            runtime.objects[layout].state["invalidations"] == 0,
            "the moved edit does not partially compact the native clip or invalidate the collection")
    return True


def main():
    parser = argparse.ArgumentParser(description=__doc__)
    parser.add_argument("candidate", type=Path)
    parser.add_argument("--report", type=Path, required=True)
    args = parser.parse_args()
    data = args.candidate.read_bytes()
    labels = labels_for(data, args.candidate.with_suffix(".composed.s"), LABELS + EXTRA)
    runtime = exercise(data, labels)
    runtime["incompatible_shelf_compaction_skipped"] = incompatible_shelf_compaction(data, labels)
    result = {"passed": True, "device_tested": False, "pixel_rendering_tested": False,
              "scope": "Actual candidate ARM64 instructions with explicit UIKit/Foundation boundaries",
              "static": static_checks(), "runtime": runtime}
    args.report.write_text(json.dumps(result, ensure_ascii=False, indent=2) + "\n",
                           encoding="utf-8")
    print(json.dumps(result, ensure_ascii=False, indent=2))


if __name__ == "__main__":
    main()
