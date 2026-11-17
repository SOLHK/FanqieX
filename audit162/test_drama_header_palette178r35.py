#!/usr/bin/env python3
"""Run the header palette decision with a light container and dark video tab.

Reading 7.4.3.33's feed paints contentView from COLOR_BG_F6 unless a tab
supplies getVCBackgroundColor (updateContentBackgroundColorWithTabModel:
at 0x10FC9804C). SSTabBarController.bottomTabBackgroundColorWithTabModel:
at 0x10A3C56EC has ABI @24@0:8@16 and resolves the page's bottom palette.
These colors need not match. The host's rootTabBarController getter and its
resolver are modeled API boundaries; selection and palette decisions execute
from the candidate ARM64. This is not an execution of UIKit pixel rendering.
"""
import argparse
import hashlib
import json
from pathlib import Path

from arm64 import release_version, require
from test_control_glass166 import send
from test_controls171 import call
from test_drama_header_state178r32 import Runtime as HeaderRuntime, CELL, SELECT, BACKGROUND
from test_drama_visibility178r7 import HEADER, CONTROLLER, MODEL, CATEGORY_VIEW
from test_feed_viewport import labels_for
from test_page_glass174 import EXTRA, make


class Runtime(HeaderRuntime):
    def __init__(self, data):
        super().__init__(data)
        self._add(self.classes[CONTROLLER], "rootTabBarController", self.HOST_GETTER, "@16@0:8")
        self.palette_by_model = {}
        self.palette_calls = []

    def handle(self, cpu, pc):
        if pc == self.OLD_PALETTE:
            self.palette_calls.append((cpu.x[0], cpu.x[2]))
            return self.finish(cpu, self.palette_by_model.get(cpu.x[2], 0))
        if pc - self.slide == 0xa5d4 and cpu.x[0] in self.objects:
            if self.selector_names.get(cpu.x[1]) == "rootTabBarController":
                return self.finish(cpu, self.objects[cpu.x[0]].state.get("rootTabBarController", 0))
        return super().handle(cpu, pc)


def exercise(data, labels, negative=False):
    cpu, rt = make(data, Runtime)
    rt.labels = labels
    call(cpu, labels, "LFQH_FQHPageInstall")
    header = rt.view(HEADER, "native feed header", (0., 62., 440., 60.), rt.ROOT)
    categories = rt.view("UIView", "native category container", (20., 0., 140., 44.), header)
    feed = rt.obj(CONTROLLER, "feed with stale cached selection", headerView=header)
    models = [rt.obj(MODEL, "native feed model", tabType=kind, index=i)
              for i, kind in enumerate((7, 11, 103))]
    titles = [rt.obj(CELL, "native title model", isSelected=(i == 1)) for i in range(3)]
    tabs = rt.view(CATEGORY_VIEW, "native titles", (0., 0., 140., 44.), categories,
                   delegate=feed, dataSource=rt.obj("NSArray", "title models", items=titles),
                   selectedIndex=2,
                   cellFrames=[(8., 0., 36., 44.), (54., 0., 36., 44.), (100., 0., 32., 44.)])
    collection = rt.view("UICollectionView", "native title collection", (0., 0., 140., 44.), tabs)
    rt.objects[tabs].state["collectionView"] = collection
    rt.objects[header].state.update(delegate=feed, tabContainer=categories)
    light = rt.color("COLOR_BG_F6 light container")
    dark = rt.color("native bottom video #222222")
    transparent = rt.color("transparent container")
    rt.objects[light].state["rgba"] = (246 / 255.,) * 3 + (1.,)
    rt.objects[dark].state["rgba"] = (34 / 255.,) * 3 + (1.,)
    rt.objects[transparent].state["rgba"] = (0., 0., 0., 0.)
    content = rt.view("UIView", "light outer content around dark player", (0., 0., 440., 956.),
                      rt.ROOT, backgroundColor=light)
    owner = rt.obj("SSTabBarController", "actual root tabs", selectedViewController=feed)
    rt.objects[feed].state.update(simpleTabView=tabs, tabModels=rt.obj("NSArray", "feed models", items=models),
                                 currentTabModel=models[0], contentView=content, rootTabBarController=owner)
    # Native resolver semantics are explicit here, independent from contentView
    # paint and intentionally different from both stale cached selections.
    rt.palette_by_model = {models[0]: light, models[1]: dark, models[2]: light}
    rt.next_background = light
    send(cpu, rt, header, "layoutSubviews")
    glass, = [child for child in rt.objects[categories].state["subviews"]
              if rt.objects[child].state.get("effect")]
    content_parent = rt.objects[glass].state["contentView"]
    lens, = rt.objects[content_parent].state["subviews"]

    def style():
        return rt.objects[glass].state.get("overrideUserInterfaceStyle", 0)

    if negative:
        require(release_version(data) == "1.78R34" and style() == 1 and not rt.palette_calls,
                "R34 follows the light outer container even though the native selected video's bottom palette is dark")
        return {"passed": False, "negative_control_passed": True, "header_style": style(),
                "selected_video_bottom_style": 2, "uikit_pixels_executed": False}

    require(style() == 2 and rt.palette_calls[-1] == (owner, models[1]),
            "The actual selected title model resolves the same dark palette as the bottom bar")
    require(rt.objects[lens].state["frame"] == (51., 4., 45., 34.),
            "The selected lens and material palette refer to the same native title")
    for _ in range(3):
        send(cpu, rt, header, "layoutSubviews")
    require(style() == 2 and rt.objects[categories].state["subviews"] == [glass, tabs] and
            rt.objects[content_parent].state["subviews"] == [lens],
            "Repeated layout reuses one material and one lens without palette drift")

    # The host may repaint the outer container without changing the active
    # native video category. Neither light nor transparent paint changes that
    # category's bottom-bar appearance.
    for paint in (transparent, light):
        rt.next_background = paint
        send(cpu, rt, feed, BACKGROUND, models[0])
        require(style() == 2 and rt.palette_calls[-1] == (owner, models[1]),
                "Content repaint callbacks preserve the selected video's semantic dark palette")

    send(cpu, rt, tabs, SELECT, titles[2], titles[1])
    require(style() == 1 and rt.palette_calls[-1] == (owner, models[2]),
            "Selecting a native light page immediately updates the header to light appearance")
    rt.next_background = dark
    send(cpu, rt, feed, BACKGROUND, models[1])
    require(style() == 1 and rt.palette_calls[-1] == (owner, models[2]),
            "An unrelated dark container update does not recolor the selected native light page")
    send(cpu, rt, tabs, SELECT, titles[1], titles[2])
    require(style() == 2 and rt.palette_calls[-1] == (owner, models[1]),
            "Selecting the native video category restores the matching dark header")
    require(rt.objects[tabs].state["selectedIndex"] == 2 and
            rt.objects[feed].state["currentTabModel"] == models[0] and
            all(model != models[0] for _, model in rt.palette_calls),
            "Stale currentTabModel and selectedIndex neither choose the palette nor get rewritten")

    # When no root owner is available, the established content-based behavior
    # remains available without asking a different controller for a palette.
    rt.objects[feed].state["rootTabBarController"] = 0
    rt.next_background = light
    calls_before = len(rt.palette_calls)
    send(cpu, rt, feed, BACKGROUND, models[1])
    require(style() == 1 and len(rt.palette_calls) == calls_before,
            "A missing root tab owner falls back to the actual content color")
    rt.objects[feed].state["rootTabBarController"] = owner
    send(cpu, rt, header, "layoutSubviews")
    require(style() == 2 and rt.palette_calls[-1] == (owner, models[1]),
            "Reattached root owner restores the selected video's bottom palette")
    return {"passed": True, "light_container_dark_video_header_style": 2,
            "native_selected_model_drives_bottom_resolver": True, "stale_cached_selection_ignored": True,
            "selection_and_background_callbacks_checked": True, "light_page_style": 1,
            "arbitrary_container_paint_does_not_override_page_palette": True,
            "missing_root_owner_content_fallback": True, "repeated_layout_reuses_material": True,
            "uikit_pixels_executed": False, "device_tested": False}


def main():
    parser = argparse.ArgumentParser(description=__doc__)
    parser.add_argument("candidate", type=Path)
    parser.add_argument("--report", type=Path, required=True)
    parser.add_argument("--negative-baseline", action="store_true")
    args = parser.parse_args()
    data = args.candidate.read_bytes()
    labels = labels_for(data, args.candidate.with_suffix(".composed.s"), EXTRA)
    result = {"candidate_sha256": hashlib.sha256(data).hexdigest(),
              **exercise(data, labels, args.negative_baseline)}
    args.report.parent.mkdir(parents=True, exist_ok=True)
    args.report.write_text(json.dumps(result, indent=2) + "\n", encoding="utf-8")
    print(json.dumps(result, indent=2))


if __name__ == "__main__":
    main()
