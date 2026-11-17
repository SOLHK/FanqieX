#!/usr/bin/env python3
"""Execute the candidate ARM64 episode/seek spacing at UIKit boundaries.

The screenshots establish the collision, not a particular private progress
getter. Fixtures expose only subviews, geometry, class identity and existing
host actions. The production code performs discovery and all layout decisions.
R3 also reproduces the submitted R2 log's exact window-space rectangles. Its
unreported parent hierarchy remains an explicit synthetic UIKit boundary.
"""
import argparse
import copy
import hashlib
import json
from pathlib import Path

from arm64 import require, release_version
from test_control_glass166 import send
from test_controls171 import call
from test_feed_viewport import labels_for
from test_home_glass165 import LABELS
from test_page_glass174 import make
from test_reader_controls178 import Runtime as ReaderRuntime

EXTRA = ["LFQH_FQHPageInstall", "LFQH_FQHDramaSpacing178R2"]
DISABLED = "FanqieAdBlock.GlassDisabled.1"


class Runtime(ReaderRuntime):
    DID_DISPLAY = 0x330f3300
    PROGRESS_LAYOUT = 0x330f3400
    PROGRESS_PLAYING = 0x330f3500
    PROGRESS_ACTIVATED = 0x330f3600
    MASONRY_GETTER = 0x330f3700
    MASONRY_CONSTANT = 0x330f3708

    def __init__(self, data):
        super().__init__(data)
        for name, parent in (
            ("FQVShortVideoVPlayerControlView", "UIView"),
            ("FQVShortVideoVPlayerSeriesControlView", "FQVShortVideoVPlayerControlView"),
            ("ObservedHostVideoProgressView", "UIView"),
            ("FQVShortVideoProgressView", "UIView"),
            ("NSLayoutConstraint", "NSObject"),
            ("MASViewConstraint", "NSObject"),
            ("NSSet", "NSObject"),
            ("NativeInsertContainerView", "UIView"),
        ):
            self._class(name, parent)
        owner = "UIView" if release_version(data) in ("1.78R6", "1.78R7", "1.78R8", "1.78R9", "1.78R10", "1.78R11", "1.78R12", "1.78R13", "1.78R14", "1.78R15", "1.78R16", "1.78R25", "1.78R26", "1.78R27", "1.78R28", "1.78R29", "1.78R30", "1.78R31", "1.78R32") else "FQVShortVideoVPlayerControlView"
        self._add(self.classes[owner], "layoutSubviews",
                  self.LAYOUT_IMP, "v16@0:8")
        self._add(self.classes["FQVShortVideoVPlayerControlView"], "controlViewDidDisplay", self.DID_DISPLAY, "v16@0:8")
        progress = self.classes["FQVShortVideoProgressView"]
        self._add(progress, "layoutProgressView", self.PROGRESS_LAYOUT, "v16@0:8")
        self._add(progress, "updateProgressViewWithPlaying:animate:", self.PROGRESS_PLAYING, "v24@0:8B16B20")
        self._add(progress, "updateProgressViewWithActivatedState:", self.PROGRESS_ACTIVATED, "v24@0:8Q16")
        self._add(self.classes["UIView"], "mas_installedConstraints", self.MASONRY_GETTER, "@16@0:8")
        self._add(self.classes["MASViewConstraint"], "layoutConstraint", self.MASONRY_GETTER, "@16@0:8")
        self._add(self.classes["MASViewConstraint"], "setLayoutConstant:", self.MASONRY_CONSTANT, "v24@0:8d16")
        self.display_mutator = None
        self.progress_mutator = None

    def responds(self, receiver, name):
        if receiver in self.objects and self.is_kind(receiver, self.classes["NSHashTable"]) and name in ("anyObject", "allObjects"):
            return True
        if receiver in self.objects and self.objects[receiver].cls == self.classes["NSSet"] and name == "allObjects":
            return True
        return super().responds(receiver, name)

    def handle(self, cpu, pc):
        if pc == self.MASONRY_GETTER:
            return self.finish(cpu, self.objects[cpu.x[0]].state.get(self.selector_names[cpu.x[1]], 0))
        if pc == self.MASONRY_CONSTANT:
            state = self.objects[cpu.x[0]].state
            state["layoutConstant"] = cpu.fp(0)
            self.objects[state["layoutConstraint"]].state["constant"] = cpu.fp(0)
            self.event("masonryConstant", cpu.x[0], value=cpu.fp(0))
            return self.finish(cpu)
        if pc == self.DID_DISPLAY:
            if self.display_mutator:
                self.display_mutator()
            return self.finish(cpu)
        if pc in (self.PROGRESS_LAYOUT, self.PROGRESS_PLAYING, self.PROGRESS_ACTIVATED):
            if self.progress_mutator:
                self.progress_mutator(pc, *cpu.x[2:4])
            return self.finish(cpu)
        if pc-self.slide == 0xa5d4:
            receiver, selector, other = cpu.x[:3]
            name = self.selector_names.get(selector)
            if name == "isCleanMode" and self.is_kind(receiver, self.classes["FQVShortVideoVPlayerControlView"]):
                return self.finish(cpu, 0)
            if receiver in self.objects and name in ("constraints", "insertAboveProgressView", "progressBarBackgroundView",
                                                     "customizedProgressBarBackgroundView"):
                return self.finish(cpu, self.objects[receiver].state.get(name, 0))
            if receiver in self.objects and self.objects[receiver].cls == self.classes["NSLayoutConstraint"]:
                state = self.objects[receiver].state
                if name in ("constant", "multiplier"):
                    return self.finish(cpu, fp=(state[name],))
                if name == "setConstant:":
                    state["constant"] = cpu.fp(0)
                    self.event("constraintConstant", receiver, value=state["constant"])
                    return self.finish(cpu, 0)
                if name in ("firstItem", "secondItem", "isActive", "firstAttribute", "secondAttribute", "relation"):
                    return self.finish(cpu, state[name])
            if receiver in self.objects and self.selector_names.get(selector) == "isEqual:" and not self.is_kind(receiver, self.classes["UIColor"]):
                # NSDictionary/NSArray use recursive Foundation value equality.
                return self.finish(cpu, int(self.object_equal(receiver, other)))
        return super().handle(cpu, pc)


def fixture(data, labels, width=440., height=956., kind="distribution"):
    cpu, runtime = make(data, Runtime)
    runtime.labels = labels
    call(cpu, labels, "LFQH_FQHPageInstall")
    window = runtime.view("UIWindow", "portrait window", (0., 0., width, height))
    root = runtime.view("FQVShortVideoVPlayerSeriesControlView", "portrait controls",
                        (0., 0., width, height-74), window)
    player = runtime.view("UIView", "native video surface", (0., 0., width, height-74), root)
    info = runtime.view("UIView", "native information group", (0., height-284, width, 200.), root)
    caption = runtime.label("native title", info, (16., 8., width-32, 30.), "Host video title")
    cls = "SSShortVideoAlbumSeriesBottomInsertView" if kind == "album" else "SSShortVideoBottomDistributionView"
    entry = runtime.view(cls, "native episode entry", (0., 160., width, 40.), info,
                         gestureRecognizers=["host open series gesture"],
                         userInteractionEnabled=True)
    content = runtime.view("UIView" if kind == "album" else "SSShortVideoDistributionContentView",
                           "native episode content", (0., 0., width, 40.), entry,
                           backgroundColor=runtime.color("host episode paint"),
                           gestureRecognizers=["host episode tap"], userInteractionEnabled=True)
    runtime.label("native episode title", content, (16., 0., width-32, 40.), "Host episode title")
    progress = runtime.view("ObservedHostVideoProgressView", "native seek region",
                            (16., height-102, width-32, 40.), root,
                            userInteractionEnabled=True,
                            gestureRecognizers=["host seek pan"], progress=0.2)
    track = runtime.view("UIView", "native seek track", (0., 19., width-32, 2.), progress)
    runtime.view("UIView", "native seek fill", (0., 19., (width-32)*0.2, 2.), progress)
    if kind == "album":
        runtime.objects[entry].state.update(containerView=content,
            albumDetailInfo=runtime.obj("NSObject", "native album model"))
        send(cpu, runtime, entry, "layoutSubviews")
    else:
        runtime.objects[entry].state["defaultContentView"] = content
        bar = runtime.obj("NSObject", "native episode bar", bottomBarType=runtime.text_object("unreal_short_play"))
        model = runtime.obj("NSObject", "native render model", bottomBar=bar)
        send(cpu, runtime, entry, "renderWithModel:", model)
    return cpu, runtime, dict(window=window, root=root, player=player, info=info,
                              caption=caption, entry=entry, content=content, progress=progress, track=track)


def global_rect(runtime, view):
    state = runtime.objects[view].state
    x, y = runtime.origin(view)
    return x, y, *state["bounds"][2:]


def glass_rect(runtime, content):
    glass = next(child for child in runtime.objects[content].state["subviews"]
                 if runtime.objects[child].cls == runtime.classes["UIButton"])
    return global_rect(runtime, glass)


def verify_native_constraint(data, labels, reference_attribute):
    cpu, rt, v = fixture(data, labels)
    root, insert, progress, track = (v[key] for key in ("root", "info", "progress", "track"))
    root_state = rt.objects[root].state
    root_state.update(frame=(0., 0., 440., 876.), bounds=(0., 0., 440., 876.), insertAboveProgressView=insert)
    rt.objects[progress].cls = rt.classes["FQVShortVideoProgressView"]
    progress_state = rt.objects[progress].state
    progress_state.update(frame=(0., 851., 440., 30.), bounds=(0., 0., 440., 30.), progressBarBackgroundView=track)
    rt.objects[track].state["frame"] = (16., 22., 408., 2.)
    other_line = rt.view("UIView", "thin unrelated subview", (0., 24., 440., 1.), progress)
    reference = root if reference_attribute == 4 else progress
    stock = 0. if reference_attribute == 4 else 10.
    anchor = rt.obj("NSLayoutConstraint", "host insert bottom anchor", firstItem=insert, secondItem=reference,
                    firstAttribute=4, secondAttribute=reference_attribute, relation=0, multiplier=1.,
                    constant=stock, isActive=1)
    root_state["constraints"] = rt.obj("NSArray", "installed constraints", items=[anchor])
    anchor_state = rt.objects[anchor].state
    insert_state = rt.objects[insert].state

    def native_layout(runtime, view):
        if view == root:
            x, _, width, height = insert_state["frame"]
            reference_y = 876. if reference_attribute == 4 else 866.
            insert_state["frame"] = (x, reference_y+anchor_state["constant"]-height, width, height)

    rt.layout_mutator = native_layout
    for _ in range(5):
        send(cpu, rt, root, "layoutSubviews")
    glass = glass_rect(rt, v["content"])
    require(anchor_state["constant"] == stock-8. and 873.-glass[1]-glass[3] == 8.,
            "The installed constraint retains the exact glass gap after UIKit recalculates the row")
    record = [r for event, r in rt.records if event == "dramaControlSpacing178R2"][-1]
    require(record["usesEpisodeConstraint"] and record["episodeGlassWindowRect"] == list(glass) and
            record["progressWindowRect"] == [16., 873., 408., 2.] and record["trackGap"] == 8.,
            "The exact host playback background wins over an unrelated thinner sibling")
    require(not rt.objects[other_line].state["hidden"] and progress_state["gestureRecognizers"] == ["host seek pan"],
            "Spacing leaves native playback visuals and gestures alone")
    require(rt.methods[rt.get_method(rt.classes["UIView"], rt.sel("layoutSubviews"))]["imp"] == rt.LAYOUT_IMP,
            "The inherited layout override is installed on controls only")
    anchor_state["constant"] = stock+2.
    for _ in range(2):
        send(cpu, rt, root, "layoutSubviews")
    require(anchor_state["constant"] == stock-8., "A host rewrite still resolves to the desired visual gap")
    rt.objects[rt.DEFAULTS].state["values"][DISABLED] = True
    send(cpu, rt, root, "layoutSubviews")
    require(anchor_state["constant"] == stock+2., "Disabling restores the latest stock constraint constant")
    if release_version(data) not in ("1.78R8", "1.78R14", "1.78R15", "1.78R16", "1.78R25", "1.78R26", "1.78R27", "1.78R28", "1.78R29", "1.78R30", "1.78R31", "1.78R32"):
        return

    rt.objects[rt.DEFAULTS].state["values"][DISABLED] = False
    send(cpu, rt, root, "layoutSubviews")
    native_layout(rt, root)
    root_state["frame"] = (0., 956., 440., 876.)
    send(cpu, rt, root, "layoutSubviews")
    require(anchor_state["constant"] == stock-8., "An attached offscreen page keeps its spacing during vertical paging")
    root_state["frame"] = (0., 0., 440., 876.)
    glass = glass_rect(rt, v["content"])
    require(873.-glass[1]-glass[3] == 8., "Page translation alone keeps the settled visual gap")

    previous_anchor_state = anchor_state
    replacement = rt.obj("NSLayoutConstraint", "replacement native anchor", **dict(anchor_state, constant=stock))

    def native_display():
        nonlocal anchor_state
        previous_anchor_state["isActive"] = 0
        anchor_state = rt.objects[replacement].state
        root_state["constraints"] = rt.obj("NSArray", "replacement constraints", items=[replacement])
        native_layout(rt, root)

    rt.display_mutator = native_display
    send(cpu, rt, root, "controlViewDidDisplay")
    require(previous_anchor_state["constant"] == stock+2. and anchor_state["constant"] == stock-8.,
            "After host display, the replacement anchor owns the gap and the old anchor is restored")
    native_layout(rt, root)

    def native_progress(callback, playing, animate):
        if callback == rt.PROGRESS_LAYOUT:
            frame = (16., 20., 408., 4.)
        else:
            require(playing == 1 and animate == 1, "Native progress playback arguments are forwarded")
            frame = (16., 22., 408., 2.)
        rt.objects[track].state.update(frame=frame, bounds=(0., 0., *frame[2:]))

    rt.progress_mutator = native_progress
    for selector, args, track_y in (("layoutProgressView", (), 871.),
                                     ("updateProgressViewWithPlaying:animate:", (1, 1), 873.)):
        send(cpu, rt, progress, selector, *args)
        if release_version(data) in ("1.78R14", "1.78R15", "1.78R16", "1.78R25", "1.78R26", "1.78R27", "1.78R28", "1.78R29", "1.78R30", "1.78R31", "1.78R32"):
            glass = glass_rect(rt, v["content"])
            require(track_y-glass[1]-glass[3] == 8.,
                    "A changed track leaves the full gap before the parent constraint layout: "+selector)
        native_layout(rt, root)
        glass = glass_rect(rt, v["content"])
        require(track_y-glass[1]-glass[3] == 8. and anchor_state["constant"] == stock-8.+(track_y-873.),
                "The changed track updates the episode gap without a parent callback: "+selector)
    if "LFQH_DramaProgressActivated" in labels:
        other = rt.view("SSShortVideoAlbumSeriesBottomInsertView", "outgoing episode", (0., 760., 440., 40.), root,
                        albumDetailInfo=rt.obj("NSObject", "outgoing model"))
        other_content = rt.view("UIView", "retiring episode content", (0., 0., 440., 40.), other)
        rt.objects[other].state["containerView"] = other_content
        send(cpu, rt, other, "layoutSubviews")

        def pause_rail(callback, state, ignored):
            require(callback == rt.PROGRESS_ACTIVATED and state == 3, "Original receives the activated state")
            rt.objects[track].state.update(frame=(16., 20., 408., 4.), bounds=(0., 0., 408., 4.))

        rt.progress_mutator = pause_rail
        send(cpu, rt, progress, "updateProgressViewWithActivatedState:", 3)
        glass = glass_rect(rt, v["content"])
        require(871.-glass[1]-glass[3] == 8., "Pause keeps the active insert above the thicker rail")
        rt.objects[v["entry"]].state["hidden"] = True
        send(cpu, rt, root, "layoutSubviews")
        require(anchor_state["constant"] == stock-10.,
                "A temporarily hidden owned insert is not reset by an outgoing episode")
        rt.objects[v["entry"]].state["hidden"] = False
        send(cpu, rt, root, "layoutSubviews")
        require(871.-glass_rect(rt, v["content"])[1]-glass_rect(rt, v["content"])[3] == 8.,
                "The same row is still separated after its foreground returns")
    rt.reparent(root, 0)
    send(cpu, rt, root, "layoutSubviews")
    require(anchor_state["constant"] == stock, "Detaching the page restores the native constraint")


def logged_geometry(data, labels):
    """Use only the observed geometry; do not infer an unreported host tree."""
    cpu, rt, v = fixture(data, labels)
    rt.objects[rt.DEFAULTS].state["values"][DISABLED] = True
    send(cpu, rt, v["root"], "layoutSubviews")
    rt.reparent(v["entry"], v["root"])
    rt.objects[v["entry"]].state.update(frame=(0., 832., 440., 44.),
                                         bounds=(0., 0., 440., 44.))
    rt.objects[v["content"]].state.update(frame=(0., 0., 440., 44.),
                                           bounds=(0., 0., 440., 44.))
    rt.objects[v["progress"]].state.update(frame=(0., 851., 440., 30.),
                                            bounds=(0., 0., 440., 30.))
    rt.objects[v["track"]].state["frame"] = (16., 22., 408., 2.)
    # A fill narrower than half the control width is not the full seek track.
    for child in rt.objects[v["progress"]].state["subviews"]:
        if child != v["track"]:
            rt.objects[child].state["frame"] = (16., 22., 81.6, 2.)
    rt.objects[rt.DEFAULTS].state["values"][DISABLED] = False
    return cpu, rt, v


def verify_masonry_reapply(data, labels, related=False):
    """Host wrapper reapply occurs after the correction/logging callback returns."""
    fixed = release_version(data) == "1.78R32"
    cpu, rt, v = fixture(data, labels)
    root, insert, progress, track = (v[key] for key in ("root", "info", "progress", "track"))
    rt.objects[rt.DEFAULTS].state["values"][DISABLED] = True
    send(cpu, rt, root, "layoutSubviews")
    rt.objects[rt.DEFAULTS].state["values"][DISABLED] = False
    rt.objects[insert].cls = rt.classes["NativeInsertContainerView"]
    rt.objects[root].state.update(frame=(0., 0., 440., 876.), bounds=(0., 0., 440., 876.),
                                  insertAboveProgressView=insert)
    rt.objects[progress].cls = rt.classes["FQVShortVideoProgressView"]
    rt.objects[progress].state.update(frame=(0., 851., 440., 30.), bounds=(0., 0., 440., 30.),
                                      progressBarBackgroundView=track)
    rt.objects[track].state.update(frame=(16., 22., 408., 2.), bounds=(0., 0., 408., 2.))
    anchor = rt.obj("NSLayoutConstraint", "native bottom anchor", firstItem=insert, secondItem=root,
                    firstAttribute=4, secondAttribute=4, relation=0, multiplier=1., constant=0., isActive=1)
    unrelated = rt.obj("NSLayoutConstraint", "unrelated width anchor", firstItem=insert, secondItem=root,
                       firstAttribute=7, secondAttribute=7, relation=0, multiplier=1., constant=22., isActive=1)
    wrapper = rt.obj("MASViewConstraint", "host wrapper", layoutConstraint=anchor, layoutConstant=0.)
    decoy = rt.obj("MASViewConstraint", "unrelated wrapper", layoutConstraint=unrelated, layoutConstant=22.)
    rt.objects[insert].state["mas_installedConstraints"] = rt.obj("NSSet", "native installed wrappers", items=[decoy, wrapper])
    rt.objects[root].state["constraints"] = rt.obj("NSArray", "native constraints", items=[unrelated, anchor])
    require(rt.sel("mas_installedConstraints") not in rt.own[rt.classes["NativeInsertContainerView"]],
            "The native installed-constraint getter is inherited from UIView")

    if related:
        entry, content = v["entry"], v["content"]
        rt.associations.pop((entry, labels["LFQH_DramaWatchContentKey"]), None)
        rt.objects[entry].state["defaultContentView"] = 0
        bar = rt.obj("NSObject", "native related-book bar", bottomBarType=rt.text_object("original_novel"))
        rt.objects[entry].state["lastRenderModel"] = rt.obj("NSObject", "related-book render", bottomBar=bar)
        rt.associations[(entry, labels["LFQH_DramaDetailRelatedContentKey"])] = content
        require((content, labels["LFQH_DramaGlassKey"]) in rt.associations,
                "The related-row fixture retains its actual existing owned glass")

    def solve_native_frame():
        state = rt.objects[insert].state
        x, _, width, height = state["frame"]
        state["frame"] = (x, 876. + rt.objects[anchor].state["constant"] - height, width, height)

    def late_masonry_pass():
        # Host MASViewConstraint reapply uses its own cached constant. Do not
        # invoke the plugin again before reading the final visible geometry.
        rt.objects[anchor].state["constant"] = rt.objects[wrapper].state["layoutConstant"]
        solve_native_frame()

    solve_native_frame()
    send(cpu, rt, root, "layoutSubviews")
    before = glass_rect(rt, v["content"])
    measured_gap = 873. - before[1] - before[3]
    late_masonry_pass()
    after = glass_rect(rt, v["content"])
    settled_gap = 873. - after[1] - after[3]
    expected_measured = 8. if fixed or not related else 0.
    require(measured_gap == expected_measured and settled_gap == (8. if fixed else 0.),
            "The final host pass preserves R32 spacing and reproduces the R31 stale-wrapper/related-row gap")
    require(rt.objects[wrapper].state["layoutConstant"] == (-8. if fixed else 0.) and
            rt.objects[decoy].state["layoutConstant"] == 22. and rt.objects[unrelated].state["constant"] == 22.,
            "Only the exact native anchor's Masonry wrapper changes")
    if fixed:
        for _ in range(3):
            send(cpu, rt, root, "layoutSubviews")
            late_masonry_pass()
            glass = glass_rect(rt, v["content"])
            require(873. - glass[1] - glass[3] == 8. and rt.objects[wrapper].state["layoutConstant"] == -8.,
                    "Repeated native wrapper passes do not accumulate the correction")
        rt.objects[rt.DEFAULTS].state["values"][DISABLED] = True
        send(cpu, rt, root, "layoutSubviews")
        late_masonry_pass()
        require(rt.objects[wrapper].state["layoutConstant"] == rt.objects[anchor].state["constant"] == 0.,
                "Disabling restores both the wrapper and UIKit anchor baseline")
    return {"related_row": related, "measured_gap": measured_gap, "after_wrapper_reapply_gap": settled_gap,
            "r31_gap_reproduced": not fixed, "masonry_wrapper_persists": fixed,
            "unrelated_wrapper_unchanged": True}


def verify(data, labels):
    cases = []
    masonry_cases = []
    glass_spacing = release_version(data) in ("1.78R6", "1.78R7", "1.78R8", "1.78R9", "1.78R10", "1.78R11", "1.78R12", "1.78R13", "1.78R14", "1.78R15", "1.78R16", "1.78R25", "1.78R26", "1.78R27", "1.78R28", "1.78R29", "1.78R30", "1.78R31", "1.78R32")
    visible_track_spacing = glass_spacing or release_version(data) in ("1.78R3", "1.78R4", "1.78R5")
    expected_shift = 4. if glass_spacing else 7. if visible_track_spacing else 26.
    for width, height in ((440., 956.), (390., 844.), (375., 812.)):
        for kind in ("distribution", "album"):
            cpu, rt, views = fixture(data, labels, width, height, kind)
            states = {key: rt.objects[value].state for key, value in views.items()}
            root, info, entry, progress, track = (views[k] for k in ("root", "info", "entry", "progress", "track"))
            row_rect = global_rect(rt, entry)
            spacing_reference = global_rect(rt, track if visible_track_spacing else progress)
            painted_rect = glass_rect(rt, views["content"]) if glass_spacing else row_rect
            require(spacing_reference[1] - painted_rect[1] - painted_rect[3] == 8.,
                    "Episode entry has the intended gap to its version's spacing reference")
            require(states["info"]["frame"] == (0., height-284-expected_shift, width, 200.),
                    "The complete information group moves once, preserving title-to-entry spacing")
            preserved = {key: copy.deepcopy(states[key]) for key in ("player", "progress", "track", "caption", "entry", "content")}
            info_frame = states["info"]["frame"]
            records = len([r for event, r in rt.records if event == "dramaControlSpacing178R2"])
            for _ in range(5):
                send(cpu, rt, root, "layoutSubviews")
                send(cpu, rt, entry, "layoutSubviews")
            require(states["info"]["frame"] == info_frame, "Repeated child and parent layouts never accumulate an offset")
            for key in preserved:
                for prop in ("frame", "bounds", "gestureRecognizers", "userInteractionEnabled", "progress"):
                    require(states[key].get(prop) == preserved[key].get(prop), "Native geometry and actions survive: "+key+" "+prop)
            require(len([r for event, r in rt.records if event == "dramaControlSpacing178R2"]) == records,
                    "Settled layouts do not emit repeated diagnostics")
            record = [r for event, r in rt.records if event == "dramaControlSpacing178R2"][-1]
            require(record["status"] == "separated" and record["shiftY"] == expected_shift and
                    record["episodeWindowRect"] == list(row_rect) and record["progressWindowRect"] == list(global_rect(rt, track)),
                    "Diagnostics report actual converted geometry and displacement")
            rt.objects[rt.DEFAULTS].state["values"][DISABLED] = True
            send(cpu, rt, root, "layoutSubviews")
            require(states["info"]["frame"] == (0., height-284, width, 200.), "Disabling restores the exact host group frame")
            rt.objects[rt.DEFAULTS].state["values"][DISABLED] = False
            send(cpu, rt, root, "layoutSubviews")
            # A newer native layout owns the baseline for subsequent restoration.
            newer = (0., height-280, width, 200.)
            states["info"]["frame"] = newer
            send(cpu, rt, root, "layoutSubviews")
            require(states["info"]["frame"] == info_frame, "A newer host frame is separated without using the stale baseline")
            rt.objects[rt.DEFAULTS].state["values"][DISABLED] = True
            send(cpu, rt, root, "layoutSubviews")
            require(states["info"]["frame"] == newer, "Disabling preserves the latest host layout")
            cases.append(f"{int(width)}x{int(height)} {kind}: collision, exact actions, repeated layouts, disable, host rewrite")

    cpu, rt, v = logged_geometry(data, labels)
    states = {key: rt.objects[value].state for key, value in v.items()}
    preserved = {key: copy.deepcopy(states[key]) for key in ("player", "progress", "track", "info", "caption")}
    for _ in range(5):
        send(cpu, rt, v["root"], "layoutSubviews")
        send(cpu, rt, v["entry"], "layoutSubviews")
        require(global_rect(rt, v["entry"]) == (0., 821. + (3. if glass_spacing else 0.) if visible_track_spacing else 799., 440., 44.),
                "The observed 440pt screen gets only the necessary lift, without cumulative movement")
    record = [r for event, r in rt.records if event == "dramaControlSpacing178R2"][-1]
    require(record["shiftY"] == (8. if glass_spacing else 11. if visible_track_spacing else 33.) and
            record["progressWindowRect"] == [16., 873., 408., 2.] and
            record["seekOwnerWindowRect"] == [0., 851., 440., 30.],
            "The regression reproduces the R2 log's actual visible track and native owner geometry")
    if glass_spacing:
        revision = "episode-glass-178R8" if release_version(data) in ("1.78R8", "1.78R9", "1.78R10", "1.78R11", "1.78R12", "1.78R13", "1.78R14", "1.78R15", "1.78R16", "1.78R25", "1.78R26", "1.78R27", "1.78R28", "1.78R29", "1.78R30", "1.78R31", "1.78R32") else "episode-glass-178R6"
        require(record["revision"] == revision and
                record["spacingReference"] == "episodeGlassToTrack" and record["trackGap"] == 8. and
                record["episodeGlassWindowRect"] == list(glass_rect(rt, v["content"])),
                "Diagnostics report the visible material edge and track gap")
    elif visible_track_spacing:
        require(record["revision"] == "visible-track-178R3" and
                record["spacingReference"] == "visibleTrack" and record["trackGap"] == 8. and
                "seekRegionHeight" not in record,
                "Diagnostics distinguish visible spacing from the unchanged native touch region")
    for key in preserved:
        for prop in ("frame", "bounds", "gestureRecognizers", "userInteractionEnabled", "progress", "subviews"):
            require(states[key].get(prop) == preserved[key].get(prop),
                    "Logged geometry preserves host geometry, actions and ordering: "+key+" "+prop)
    rt.objects[rt.DEFAULTS].state["values"][DISABLED] = True
    send(cpu, rt, v["root"], "layoutSubviews")
    require(global_rect(rt, v["entry"]) == (0., 832., 440., 44.),
            "Disabling restores the original episode entry from the log")
    cases.append("submitted geometry: 8pt from glass to track" if glass_spacing else
                 "submitted R2 geometry: minimal 11pt lift to 8pt visible gap" if visible_track_spacing else
                 "submitted R2 geometry: reproduces 33pt lift and 30pt visible gap")
    if glass_spacing:
        for attribute in (4, 10):
            verify_native_constraint(data, labels, attribute)
        cases.append("native bottom and seek-center constraints: geometry persists across host layouts and restores on disable")
        if release_version(data) in ("1.78R8", "1.78R9", "1.78R10", "1.78R11", "1.78R12", "1.78R13", "1.78R14", "1.78R15", "1.78R16", "1.78R25", "1.78R26", "1.78R27", "1.78R28", "1.78R29", "1.78R30", "1.78R31", "1.78R32"):
            cases.append("attached offscreen paging, replacement at display, progress-only changes and detach restoration")
        if "LFQH_DramaProgressActivated" in labels:
            cases.append("paused rail, retiring episode and temporarily hidden current insert")
        if release_version(data) in ("1.78R31", "1.78R32"):
            masonry_cases = [verify_masonry_reapply(data, labels), verify_masonry_reapply(data, labels, related=True)]
            cases.append("Masonry wrapper reapply and independently decorated related-book row")

    for scenario in ("landscape", "hidden_progress", "unrelated_divider", "offscreen", "missing_entry", "already_separated", "ambiguous_entries"):
        cpu, rt, v = fixture(data, labels)
        root, info = v["root"], v["info"]
        original = (0., 672., 440., 200.)
        if scenario == "landscape":
            rt.objects[v["window"]].state["bounds"] = (0., 0., 956., 440.)
        elif scenario == "hidden_progress":
            rt.objects[v["progress"]].state["hidden"] = True
        elif scenario == "unrelated_divider":
            rt.objects[v["progress"]].cls = rt.classes["UIView"]
        elif scenario == "offscreen":
            rt.objects[root].state["frame"] = (440., 0., 440., 882.)
        elif scenario == "missing_entry":
            rt.objects[v["entry"]].state["hidden"] = True
        elif scenario == "already_separated":
            original = (0., 600., 440., 200.)
            rt.objects[info].state["frame"] = original
        elif scenario == "ambiguous_entries":
            other = rt.view("SSShortVideoAlbumSeriesBottomInsertView", "second visible entry", (0., 760., 440., 40.), root,
                            albumDetailInfo=rt.obj("NSObject", "second model"))
            require(other, "negative fixture has a second visible entry")
        send(cpu, rt, root, "layoutSubviews")
        require(rt.objects[info].state["frame"] == original, "Unsupported or no-longer-needed separation restores: "+scenario)
        cases.append(scenario+": native frame restored, no speculative repositioning")

    cpu, rt, v = fixture(data, labels)
    rt.objects[v["progress"]].state.update(frame=(16., 842., 408., 64.), bounds=(0., 0., 408., 64.))
    rt.objects[v["track"]].state["frame"] = (0., 31., 408., 2.)
    send(cpu, rt, v["root"], "layoutSubviews")
    row = glass_rect(rt, v["content"]) if glass_spacing else global_rect(rt, v["entry"])
    reference_top = 873. if visible_track_spacing else 842.
    require(reference_top-row[1]-row[3] == 8. and
            rt.objects[v["progress"]].state["frame"] == (16., 842., 408., 64.) and
            rt.objects[v["progress"]].state["gestureRecognizers"] == ["host seek pan"],
            "A 64pt native seek owner remains unchanged and cannot inflate the visible gap in R3")
    cases.append("64pt seek owner: native geometry and gestures preserved; version-specific gap checked")

    if visible_track_spacing:
        for scenario in ("hidden_track", "missing_track", "thick_track"):
            cpu, rt, v = fixture(data, labels)
            progress_state = rt.objects[v["progress"]].state
            for child in list(progress_state["subviews"]):
                if scenario == "hidden_track":
                    rt.objects[child].state["hidden"] = True
                elif scenario == "missing_track":
                    rt.reparent(child, 0)
                else:
                    old = rt.objects[child].state["frame"]
                    rt.objects[child].state.update(frame=(*old[:3], 12.), bounds=(0., 0., old[2], 12.))
            owner = copy.deepcopy(progress_state)
            send(cpu, rt, v["root"], "layoutSubviews")
            require(rt.objects[v["info"]].state["frame"] == (0., 672., 440., 200.) and
                    global_rect(rt, v["entry"])[1:] == (832., 440., 40.),
                    "An unresolved thin track cannot turn its native seek container into a visual boundary")
            require([r for event, r in rt.records if event == "dramaControlSpacing178R2"][-1]["status"] ==
                    "progressTrackUnresolved", "Unknown visual track is explicitly diagnosed")
            require(progress_state == owner, "An unresolved track leaves the native seek owner untouched")
            cases.append(scenario+": restore episode frame; never guess from the large seek owner")

    cpu, rt, v = fixture(data, labels)
    shared = rt.view("UIView", "short shared parent", (0., 780., 440., 90.), v["root"], clipsToBounds=True)
    rt.reparent(v["entry"], shared)
    rt.objects[v["entry"]].state["frame"] = (0., 10., 440., 40.)
    rt.reparent(v["progress"], shared)
    rt.objects[v["progress"]].state["frame"] = (16., 16., 408., 40.)
    send(cpu, rt, v["root"], "layoutSubviews")
    require(rt.objects[v["entry"]].state["frame"] == (0., 10., 440., 40.) and
            rt.objects[v["info"]].state["frame"] == (0., 672., 440., 200.),
            "A shorter shared parent cannot lose its episode hit target outside its bounds")
    require([record for event,record in rt.records if event == "dramaControlSpacing178R2"][-1]["status"] == "unsupportedGeometry",
            "Unsafe geometry is diagnosed rather than changing clipping or hitTest")
    cases.append("shared clipped parent: preserves the complete native hit target")

    cpu, rt, v = fixture(data, labels)
    rt.objects[v["info"]].state.update(frame=(0., 280., 440., 500.), bounds=(0., 0., 440., 500.))
    rt.objects[v["entry"]].state["frame"] = (0., 460., 440., 40.)
    rt.objects[v["progress"]].state["frame"] = (16., 730., 408., 40.)
    for _ in range(4):
        send(cpu, rt, v["root"], "layoutSubviews")
        require(rt.objects[v["info"]].state["frame"] == (0., 244. if glass_spacing else 241. if visible_track_spacing else 222., 440., 500.),
                "Stock projection prevents oscillation when the applied group crosses the discovery threshold")
    cases.append("threshold crossing: stable stock-based discovery on repeated layouts")

    cpu, rt, v = fixture(data, labels)
    for _ in range(130):
        rt.view("UIView", "unrelated host child", (0., 10., 20., 20.), v["root"])
    send(cpu, rt, v["root"], "layoutSubviews")
    require(rt.objects[v["info"]].state["frame"] == (0., 672., 440., 200.) and
            [record for event,record in rt.records if event == "dramaControlSpacing178R2"][-1]["status"] == "scanLimit",
            "An incomplete bounded traversal cannot claim a unique episode entry")
    cases.append("scan budget: incomplete discovery restores the host frame")
    return {"passed": True, "device_tested": False, "cases": cases, "masonry_cases": masonry_cases,
            "limits": ["Candidate ARM64 executes against explicit UIKit/Foundation boundaries.",
                       "Real progress-class discovery, clipping, touch delivery and rendering need device acceptance."]}


def main():
    parser = argparse.ArgumentParser()
    parser.add_argument("candidate", type=Path)
    parser.add_argument("--report", type=Path, required=True)
    args = parser.parse_args()
    data = args.candidate.read_bytes()
    composed = args.candidate.with_suffix(".composed.s")
    pause = "LFQH_DramaProgressActivated"
    direct_pause = [pause] if f"\n{pause}:" in composed.read_text(encoding="utf-8") else []
    related = ["LFQH_DramaWatchContentKey", "LFQH_DramaDetailRelatedContentKey", "LFQH_DramaGlassKey"] \
        if release_version(data) in ("1.78R31", "1.78R32") else []
    labels = labels_for(data, composed, list(dict.fromkeys(LABELS + EXTRA + direct_pause + related)))
    result = verify(data, labels)
    result["candidate_sha256"] = hashlib.sha256(data).hexdigest()
    args.report.write_text(json.dumps(result, ensure_ascii=False, indent=2)+"\n")
    print(json.dumps(result, ensure_ascii=False, indent=2))


if __name__ == "__main__":
    main()
