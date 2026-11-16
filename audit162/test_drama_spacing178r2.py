#!/usr/bin/env python3
"""Execute the candidate ARM64 episode/seek spacing at UIKit boundaries.

The screenshots establish the collision, not a particular private progress
getter. Fixtures expose only subviews, geometry, class identity and existing
host actions. The production code performs discovery and all layout decisions.
"""
import argparse
import copy
import json
from pathlib import Path

from arm64 import require
from test_control_glass166 import send
from test_controls171 import call
from test_feed_viewport import labels_for
from test_home_glass165 import LABELS
from test_page_glass174 import make
from test_reader_controls178 import Runtime as ReaderRuntime

EXTRA = ["LFQH_FQHPageInstall", "LFQH_FQHDramaSpacing178R2"]
DISABLED = "FanqieAdBlock.GlassDisabled.1"


class Runtime(ReaderRuntime):
    def __init__(self, data):
        super().__init__(data)
        for name, parent in (
            ("FQVShortVideoVPlayerControlView", "UIView"),
            ("FQVShortVideoVPlayerSeriesControlView", "FQVShortVideoVPlayerControlView"),
            ("ObservedHostVideoProgressView", "UIView"),
        ):
            self._class(name, parent)
        self._add(self.classes["FQVShortVideoVPlayerControlView"], "layoutSubviews",
                  self.LAYOUT_IMP, "v16@0:8")

    def responds(self, receiver, name):
        if receiver in self.objects and self.is_kind(receiver, self.classes["NSHashTable"]) and name in ("anyObject", "allObjects"):
            return True
        return super().responds(receiver, name)

    def handle(self, cpu, pc):
        if pc-self.slide == 0xa5d4:
            receiver, selector, other = cpu.x[:3]
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


def verify(data, labels):
    cases = []
    for width, height in ((440., 956.), (390., 844.), (375., 812.)):
        for kind in ("distribution", "album"):
            cpu, rt, views = fixture(data, labels, width, height, kind)
            states = {key: rt.objects[value].state for key, value in views.items()}
            root, info, entry, progress, track = (views[k] for k in ("root", "info", "entry", "progress", "track"))
            row_rect = global_rect(rt, entry)
            progress_rect = global_rect(rt, progress)
            require(progress_rect[1] - row_rect[1] - row_rect[3] == 8.,
                    "Episode tap region is separated from the unchanged 40pt seek region")
            require(states["info"]["frame"] == (0., height-310, width, 200.),
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
            require(record["status"] == "separated" and record["shiftY"] == 26. and
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
    row = global_rect(rt, v["entry"])
    require(842.-row[1]-row[3] == 8., "A 64pt native seek owner keeps its complete touch region despite its 2pt track")
    cases.append("64pt seek owner: native touch region survives thin-track discovery")

    cpu, rt, v = fixture(data, labels)
    shared = rt.view("UIView", "short shared parent", (0., 780., 440., 90.), v["root"], clipsToBounds=True)
    rt.reparent(v["entry"], shared)
    rt.objects[v["entry"]].state["frame"] = (0., 10., 440., 40.)
    rt.reparent(v["progress"], shared)
    rt.objects[v["progress"]].state["frame"] = (16., 38., 408., 40.)
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
        require(rt.objects[v["info"]].state["frame"] == (0., 222., 440., 500.),
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
    return {"passed": True, "device_tested": False, "cases": cases,
            "limits": ["Candidate ARM64 executes against explicit UIKit/Foundation boundaries.",
                       "Real progress-class discovery, clipping, touch delivery and rendering need device acceptance."]}


def main():
    parser = argparse.ArgumentParser()
    parser.add_argument("candidate", type=Path)
    parser.add_argument("--report", type=Path, required=True)
    args = parser.parse_args()
    data = args.candidate.read_bytes()
    labels = labels_for(data, args.candidate.with_suffix(".composed.s"), list(dict.fromkeys(LABELS+EXTRA)))
    result = verify(data, labels)
    args.report.write_text(json.dumps(result, ensure_ascii=False, indent=2)+"\n")
    print(json.dumps(result, ensure_ascii=False, indent=2))


if __name__ == "__main__":
    main()
