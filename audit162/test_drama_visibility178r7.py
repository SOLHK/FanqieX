#!/usr/bin/env python3
"""Run the three short-drama visibility switches against the candidate ARM64."""
import argparse
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
MANAGER = "SSShortVideoBelowLeftContainerViewManager"
CONFIG = "FQVShortVideoListConfig"
CONTEXT = "FQVShortVideoContextModel"
CATEGORIES_KEY = "FanqieX.DramaCategories.1"
SEARCH_KEY = "FanqieX.DramaSearch.1"
AUTHOR_KEY = "FanqieX.DramaAuthorDeclaration.1"


class Runtime(PageRuntime):
    HOST_GETTER = 0x33250028

    def __init__(self, data):
        super().__init__(data)
        for name, parent in (
            (HEADER, "UIView"), (SEARCH, "UIView"), (CONTROLLER, "UIViewController"),
            (MANAGER, "NSObject"), (CONFIG, "NSObject"), (CONTEXT, "NSObject"),
        ):
            self._class(name, parent)
        for cls, selector, encoding, implementation in (
            (HEADER, "didMoveToWindow", "v16@0:8", self.LAYOUT_IMP),
            (HEADER, "updateTabViewWithContentSize:", "v32@0:8{CGSize=dd}16", self.LAYOUT_IMP),
            (CONTROLLER, "relayoutHeaderView", "v16@0:8", self.LAYOUT_IMP),
            (MANAGER, "shouldAddAiUsageView", "B16@0:8", self.HOST_GETTER),
            (MANAGER, "updateSubViews", "v16@0:8", self.HOST_GETTER),
            (CONFIG, "feedType", "q16@0:8", self.HOST_GETTER),
        ):
            self._add(self.classes[cls], selector, implementation, encoding)

    def responds(self, receiver, name):
        if name == "allObjects" and self.is_kind(receiver, self.classes["NSHashTable"]):
            return True
        return super().responds(receiver, name)

    def handle(self, cpu, pc):
        receiver, selector = cpu.x[:2]
        name = self.selector_names.get(selector)
        if pc == self.HOST_GETTER:
            state = self.objects[receiver].state
            if name == "updateSubViews":
                state["updates"] = state.get("updates", 0) + 1
                return self.finish(cpu)
            return self.finish(cpu, int(state.get(name, 0)))
        if pc - self.slide == 0xa5d4 and name in (
            "headerView", "tabContainer", "searchViewContainer",
            "searchButtonSlotView", "searchButtonView", "vcContext", "config",
        ) and receiver in self.objects:
            return self.finish(cpu, self.objects[receiver].state.get(name, 0))
        return super().handle(cpu, pc)


def exercise(data, labels):
    cpu, rt = make(data, Runtime)
    rt.labels = labels
    call(cpu, labels, "LFQH_FQHPageInstall")
    header = rt.view(HEADER, "drama header", (0., 62., 440., 60.), rt.ROOT)
    controller = rt.obj(CONTROLLER, "drama feed owner", headerView=header)
    categories = rt.view("UIView", "three category tabs", (8., 0., 140., 44.), header)
    search = rt.view(SEARCH, "drama search container", (0., 0., 440., 44.), header)
    slot = rt.view("UIView", "native magnifier slot", (392., 0., 44., 44.), search)
    icon = rt.view("UIImageView", "native magnifier", (9., 9., 26., 26.), slot)
    bar = rt.view("UIView", "separate find-drama search bar", (12., 0., 340., 44.), search)
    rt.objects[header].state.update(delegate=controller, tabContainer=categories, searchViewContainer=search)
    rt.objects[search].state.update(searchButtonSlotView=slot, searchButtonView=icon)
    config = rt.obj(CONFIG, "root drama feed config", feedType=4)
    context = rt.obj(CONTEXT, "native video context", config=config)
    manager = rt.obj(MANAGER, "native AI declaration owner", vcContext=context, shouldAddAiUsageView=True)
    options = rt.objects[rt.DEFAULTS].state["values"]

    def hidden(view):
        return rt.objects[view].state["hidden"]

    def native_declares():
        return bool(send(cpu, rt, manager, "shouldAddAiUsageView")["result"])

    send(cpu, rt, header, "didMoveToWindow")
    require(not hidden(categories) and not hidden(slot) and native_declares(),
            "Unset preferences defer to all three native visible states")

    for flags in range(8):
        show_categories, show_search, show_author = (bool(flags & bit) for bit in (1, 2, 4))
        options.update({CATEGORIES_KEY: show_categories, SEARCH_KEY: show_search, AUTHOR_KEY: show_author})
        send(cpu, rt, header, "updateTabViewWithContentSize:", fp=(140., 44.))
        require(hidden(categories) != show_categories and hidden(slot) != show_search,
                "The two separately owned header controls respond independently")
        require(native_declares() == show_author, "The author row follows only its own switch")
        require(not hidden(bar) and not hidden(header) and not hidden(search),
                "Top switches preserve the header and separate search field")

    options[SEARCH_KEY] = False
    send(cpu, rt, controller, "relayoutHeaderView")
    rt.objects[slot].state["hidden"] = False
    send(cpu, rt, controller, "relayoutHeaderView")
    require(hidden(slot) and not hidden(categories), "A native layout cannot reveal a disabled search slot")
    options[SEARCH_KEY] = True
    send(cpu, rt, controller, "relayoutHeaderView")
    require(not hidden(slot), "Restoring search removes only the plugin-owned hide")
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
    require(rt.objects[manager].state.get("updates") == 3,
            "The visible declaration manager reruns native layout when settings change")

    return {"independent_combinations": 8, "native_hidden_state_unchanged": True,
            "non_root_declaration_unchanged": True, "settings_apply_immediately": True,
            "device_tested": False}


def main():
    parser = argparse.ArgumentParser(description=__doc__)
    parser.add_argument("candidate", type=Path)
    parser.add_argument("--report", type=Path, required=True)
    args = parser.parse_args()
    data = args.candidate.read_bytes()
    require(release_version(data) in ("1.78R7", "1.78R8"), "Use the 1.78R7 or later candidate")
    labels = labels_for(data, args.candidate.with_suffix(".composed.s"),
                        EXTRA + ["LFQH_FQHBottomOptionChanged178"])
    report = {"passed": True, **exercise(data, labels)}
    args.report.write_text(json.dumps(report, indent=2) + "\n", encoding="utf-8")
    print(json.dumps(report, indent=2))


if __name__ == "__main__":
    main()
