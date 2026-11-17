#!/usr/bin/env python3
"""Execute R29 episode-detail decoration at explicit host/UIKit boundaries."""
import argparse
import copy
import hashlib
import json
from pathlib import Path

from arm64 import require
from test_control_glass166 import send
from test_controls171 import call
from test_feed_viewport import labels_for
from test_page_glass174 import EXTRA, Runtime as PageRuntime, make

NAV = "FQVShortVideoListVCNavBarComponent"
MORE = "FQVShortVideoMoreBtnNavBarItem"
NOVEL = "SSShortVideoOriginalNovelEntranceView"
BASE = "SSShortVideoBottomInsertView"
SINGLE = "SSShortVideoSingleBottomInsertView"
TAGS = "SSShortVideoTagListBottomInsertView"
DISABLED = "FanqieAdBlock.GlassDisabled.1"


class Runtime(PageRuntime):
    NATIVE = 0x33290000

    def __init__(self, data):
        super().__init__(data)
        for name, parent in ((NAV, "NSObject"), (MORE, "NSObject"), (NOVEL, "UIView"),
                             (BASE, "UIView"), (SINGLE, BASE), (TAGS, BASE)):
            self._class(name, parent)
        methods = [
            (NAV, "setupLayout:", "v24@0:8@16"),
            (NAV, "updateNavgationBarLeftView", "v16@0:8"),
            (NAV, "updateNavgationBarRightViewWithRightItems:", "v24@0:8@16"),
            (MORE, "setUp", "v16@0:8"),
            (NOVEL, "layoutSubviews", "v16@0:8"),
            (TAGS, "layoutSubviews", "v16@0:8"),
        ]
        for cls, getters in ((NAV, ("navBar", "backBtn", "moreBtn", "navigationBarRightItems")),
                             (MORE, ("moreBtn", "view")), (BASE, ("cleanScreenView",)),
                             (SINGLE, ("episodeInfoView",)),
                             (TAGS, ("episodeInfoView", "relateBookEntranceView"))):
            methods.extend((cls, getter, "@16@0:8") for getter in getters)
        for cls, selector, encoding in methods:
            self._add(self.classes[cls], selector, self.NATIVE, encoding)
        self.native_calls = []

    def responds(self, receiver, name):
        if receiver in self.objects and name == "arrowImageView" and name in self.objects[receiver].state:
            return True
        return super().responds(receiver, name)

    def handle(self, cpu, pc):
        receiver, selector = cpu.x[:2]
        name = self.selector_names.get(selector)
        if pc == self.NATIVE:
            state = self.objects[receiver].state
            self.native_calls.append((receiver, name, cpu.x[2]))
            return self.finish(cpu, state.get(name, 0))
        if pc - self.slide == 0xa5d4 and receiver in self.objects and name == "arrowImageView":
            return self.finish(cpu, self.objects[receiver].state.get(name, 0))
        return super().handle(cpu, pc)


def exercise(data, labels):
    cpu, rt = make(data, Runtime)
    rt.labels = labels
    call(cpu, labels, "LFQH_FQHPageInstall")
    prefs = rt.objects[rt.DEFAULTS].state["values"]
    stock = rt.color("native detail backing")
    clear = rt.color("clearColor")

    def backing(view):
        return [child for child in rt.objects[view].state["subviews"]
                if rt.objects[child].state.get("configuration")]

    def passive_glass(view, frame):
        surfaces = backing(view)
        require(len(surfaces) == 1, "One material is attached to the inspected native target")
        glass = rt.objects[surfaces[0]].state
        require(glass["frame"] == frame and not glass["userInteractionEnabled"] and
                glass["accessibilityElementsHidden"], "Glass is correctly bounded and never handles native actions")
        return surfaces[0]

    # Only the main watch-all-episodes arrow is removed, not every chevron.
    owner = rt.view("SSShortVideoBottomDistributionView", "watch all episodes", (0, 0, 440, 40), rt.ROOT)
    content = rt.view("SSShortVideoDistributionContentView", "watch tap target", (0, 0, 440, 40), owner,
                      backgroundColor=stock, gesture_action="native-watch-episodes")
    right = rt.view("UIView", "native right stack", (410, 0, 30, 40), content)
    arrow = rt.view("UIImageView", "episode chevron", (12, 12, 8, 16), right)
    unrelated = rt.view("UIImageView", "unrelated arrow", (0, 0, 8, 16), content)
    rt.objects[content].state["arrowImageView"] = arrow
    rt.objects[owner].state["defaultContentView"] = content
    bar = rt.obj("NSObject", "episode bar", bottomBarType=rt.text_object("unreal_short_play"))
    model = rt.obj("NSObject", "episode model", bottomBar=bar)
    send(cpu, rt, owner, "renderWithModel:", model)
    passive_glass(content, (8., 3., 424., 34.))
    require(rt.objects[arrow].state["hidden"] and not rt.objects[unrelated].state["hidden"],
            "Only the owned episode arrow disappears")
    require(rt.objects[content].state["gesture_action"] == "native-watch-episodes",
            "The watch-all-episodes gesture remains native")
    replacement = rt.view("UIImageView", "replacement episode arrow", (12, 12, 8, 16), right)
    rt.objects[content].state["arrowImageView"] = replacement
    send(cpu, rt, owner, "layoutSubviews")
    require(not rt.objects[arrow].state["hidden"] and rt.objects[replacement].state["hidden"],
            "Replacing a native arrow restores the prior owned view")
    rt.objects[bar].state["bottomBarType"] = rt.text_object("original_novel")
    send(cpu, rt, owner, "renderWithModel:", model)
    require(not rt.objects[replacement].state["hidden"] and not backing(content),
            "Reusing distribution content for an original-novel row restores its arrow")
    rt.objects[bar].state["bottomBarType"] = rt.text_object("short_play")
    send(cpu, rt, owner, "renderWithModel:", model)
    prefs[DISABLED] = True
    send(cpu, rt, owner, "layoutSubviews")
    require(not rt.objects[replacement].state["hidden"] and rt.objects[content].state["backgroundColor"] == stock,
            "Disabling glass restores the episode arrow and background")
    prefs[DISABLED] = False
    rt.objects[replacement].state["hidden"] = True
    send(cpu, rt, owner, "layoutSubviews")
    prefs[DISABLED] = True
    send(cpu, rt, owner, "layoutSubviews")
    require(rt.objects[replacement].state["hidden"], "An arrow originally hidden by the host stays hidden")
    prefs[DISABLED] = False

    # setupViews at 0xF307ACC/0xF307AE4/0xF307AF0 adds the album arrow
    # to containerView. It is not a sibling of that native tap container.
    album = rt.view("SSShortVideoAlbumSeriesBottomInsertView", "album entry", (0, 0, 440, 40), rt.ROOT)
    album_content = rt.view("UIView", "album container", (0, 0, 440, 40), album, backgroundColor=stock)
    album_arrow = rt.view("UIImageView", "native album arrow", (420, 12, 8, 16), album_content)
    rt.objects[album].state.update(containerView=album_content, arrowImageView=album_arrow,
                                   albumDetailInfo=rt.obj("NSObject", "album model"))
    send(cpu, rt, album, "layoutSubviews")
    passive_glass(album_content, (8., 3., 424., 34.))
    require(rt.objects[album_arrow].state["hidden"], "The inspected album container's own arrow is hidden")
    rt.objects[album].state["albumDetailInfo"] = 0
    send(cpu, rt, album, "layoutSubviews")
    require(not rt.objects[album_arrow].state["hidden"] and not backing(album_content),
            "Removing the album model restores its owned arrow")

    # Portrait navigation has real UIButtons, including the newer item object.
    nav = rt.view("UIView", "native portrait navbar", (0, 0, 440, 44), rt.ROOT)
    buttons = [rt.view("UIButton", name, frame, nav, backgroundColor=stock, clipsToBounds=True,
                       native_target="host", native_action=action, hitInsets=(-10., -10., -10., -10.))
               for name, frame, action in (("back", (16, 10, 24, 24), "backBtnClicked:"),
                                           ("more", (400, 10, 24, 24), "moreBtnClicked:"),
                                           ("item more", (400, 10, 24, 24), "moreBtnClicked"))]
    item = rt.obj(MORE, "native more nav item", moreBtn=buttons[2], view=buttons[2])
    items = rt.obj("NSArray", "right items", items=[item])
    component = rt.obj(NAV, "native navbar component", navBar=nav, backBtn=buttons[0],
                       moreBtn=buttons[1], navigationBarRightItems=items)
    before = {button: {key: copy.deepcopy(rt.objects[button].state[key])
                       for key in ("frame", "native_target", "native_action", "hitInsets")}
              for button in buttons}
    send(cpu, rt, component, "setupLayout:", nav)
    for button in buttons:
        passive_glass(button, (-6., -6., 36., 36.))
    send(cpu, rt, component, "updateNavgationBarLeftView")
    send(cpu, rt, component, "updateNavgationBarRightViewWithRightItems:", items)
    send(cpu, rt, item, "setUp")
    for button in buttons:
        passive_glass(button, (-6., -6., 36., 36.))
        require({key: rt.objects[button].state[key] for key in before[button]} == before[button],
                "Navigation decoration preserves original frames, native targets and expanded hit insets")
    prefs[DISABLED] = True
    send(cpu, rt, component, "setupLayout:", nav)
    require(all(not backing(button) and rt.objects[button].state["backgroundColor"] == stock and
                rt.objects[button].state["clipsToBounds"] for button in buttons),
            "Disabling glass restores all native navigation paint and clipping")
    prefs[DISABLED] = False

    # The detail original-novel row is a separate class and keeps its arrow.
    novel = rt.view(NOVEL, "original chapter row", (0, 780, 440, 42), rt.ROOT,
                    backgroundColor=stock, native_click="original chapter")
    label = rt.label("original label", novel, (16, 0, 380, 42), "原著 · 第2章")
    novel_arrow = rt.view("UIImageView", "original navigation arrow", (416, 14, 8, 14), novel)
    send(cpu, rt, novel, "layoutSubviews")
    surface = passive_glass(novel, (8., 3., 424., 36.))
    require(rt.objects[novel].state["subviews"] == [surface, label, novel_arrow] and
            not rt.objects[novel_arrow].state["hidden"] and rt.objects[novel].state["native_click"] == "original chapter",
            "The whole original-novel row has glass with text, chevron and native action intact")
    prefs[DISABLED] = True
    send(cpu, rt, novel, "layoutSubviews")
    require(not backing(novel) and rt.objects[novel].state["backgroundColor"] == stock,
            "Disabling restores the original-novel row")
    prefs[DISABLED] = False

    bottom_cases = []
    for cls in (SINGLE, TAGS):
        bottom = rt.view(cls, "portrait bottom insert", (0, 840, 440, 60), rt.ROOT)
        episode = rt.view("UIView", "native episode picker", (16, 4, 360, 40), bottom,
                          backgroundColor=stock, native_click="episodeInfoViewDidClickBlock")
        clean = rt.view("UIView", "native clean-screen tap region", (396, 4, 32, 40), bottom,
                        backgroundColor=stock, clipsToBounds=True, native_click="didClickedCleanScreenView")
        toggle = rt.view("UIView", "native clean switch", (4, 8, 24, 24), clean, native_delegate=bottom)
        arrow = rt.view("UIImageView", "episode expand arrow", (336, 13, 12, 14), episode)
        rt.objects[bottom].state.update(episodeInfoView=episode, cleanScreenView=clean)
        before = {view: rt.objects[view].state["frame"] for view in (bottom, episode, clean, toggle, arrow)}
        send(cpu, rt, bottom, "layoutSubviews")
        passive_glass(episode, (0., 0., 360., 40.))
        passive_glass(clean, (-2., 2., 36., 36.))
        send(cpu, rt, bottom, "layoutSubviews")
        require(all(rt.objects[view].state["frame"] == frame for view, frame in before.items()) and
                not rt.objects[arrow].state["hidden"] and rt.objects[toggle].state["native_delegate"] == bottom and
                rt.objects[episode].state["native_click"] == "episodeInfoViewDidClickBlock" and
                rt.objects[clean].state["native_click"] == "didClickedCleanScreenView",
                "Episode and clean-screen controls keep host geometry, arrow, delegate and action blocks")
        prefs[DISABLED] = True
        send(cpu, rt, bottom, "layoutSubviews")
        require(not backing(episode) and not backing(clean) and
                all(rt.objects[view].state["backgroundColor"] == stock for view in (episode, clean)) and
                rt.objects[clean].state["clipsToBounds"], "Both detail bottom paths restore native appearance")
        prefs[DISABLED] = False
        bottom_cases.append(cls)
    return {"episode_arrow_scoped_and_restored": True, "native_navigation_preserved": True,
            "original_novel_row_and_arrow_preserved": True, "bottom_paths": bottom_cases,
            "device_tested": False, "pixel_rendering_tested": False}


def main():
    parser = argparse.ArgumentParser(description=__doc__)
    parser.add_argument("candidate", type=Path)
    parser.add_argument("--report", type=Path, required=True)
    args = parser.parse_args()
    data = args.candidate.read_bytes()
    labels = labels_for(data, args.candidate.with_suffix(".composed.s"), EXTRA)
    report = {"passed": True, "candidate_sha256": hashlib.sha256(data).hexdigest(), **exercise(data, labels)}
    args.report.parent.mkdir(parents=True, exist_ok=True)
    args.report.write_text(json.dumps(report, indent=2) + "\n", encoding="utf-8")
    print(json.dumps(report, indent=2))


if __name__ == "__main__":
    main()
