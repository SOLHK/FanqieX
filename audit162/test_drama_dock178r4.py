#!/usr/bin/env python3
"""Execute the R4 dock viewport policy at explicit host/UIKit boundaries.

The uploaded R3 log reports a 440x876 player in a 440x956 window and a
transparent navigation bar at y=882. This fixture supplies those observed
dimensions; it does not invent or simulate a video compositor. All eligibility,
size selection and reversible control-frame decisions run in candidate ARM64.
"""
import argparse
import copy
import hashlib
import json
import math
from pathlib import Path

from arm64 import require, release_version
from test_control_glass166 import send
from test_feed_viewport import labels_for
from test_home_glass165 import LABELS
from test_page_glass174 import EXTRA, make_drama_dock_runtime

DISABLED = "FanqieAdBlock.GlassDisabled.1"
CONFIG = "FQVShortVideoListConfig"
CONTROLS = "FQVShortVideoVPlayerSeriesControlView"
RGB = "getRed:green:blue:alpha:"


def config(rt, width=0., height=876., feed_type=4, name="native feed"):
    offsets = {"infoViewOffsetY": -8., "bottomGradientOffsetY": 0., "progressContainerViewOffsetY": -2.}
    ui = rt.obj("FQVShortVideoListUIConfig", name + " UI", safeBottom=6.,
                **{key: rt.obj("NSNumber", key, value=value) for key, value in offsets.items()})
    color = rt.obj("UIColor", name + " dock paint", **{RGB: (29/255,)*3+(1.,)})
    return rt.obj(CONFIG, name, feedType=feed_type, uiConfig=ui,
                  portraitVideoSize=(width, height), listVCBackgroundColor=color)


def size(cpu, rt, item):
    send(cpu, rt, item, "portraitVideoSize")
    return cpu.fp(0), cpu.fp(1)


def controls(rt, owning_config, local_config=None):
    context = rt.obj("FQVShortVideoListContext", "owning native feed", config=owning_config)
    local_config = local_config or owning_config
    return rt.view(CONTROLS, "native controls", (0., 0., 440., 956.), rt.ROOT,
                   listVCConfig=local_config, listVCContext=context, isCleanMode=False,
                   gestureRecognizers=["original seek", "original series tap", "original long press"])


def same_numbers(left, right):
    return all((math.isnan(a) and math.isnan(b)) or a == b for a, b in zip(left, right))


def observed_geometry(data, labels):
    cpu, rt = make_drama_dock_runtime(data, labels)
    owning = config(rt)
    native_state = copy.deepcopy(rt.objects[owning].state)
    local = config(rt, width=440., height=956., name="resolved control copy")
    overlay = controls(rt, owning, local)
    state = rt.objects[overlay].state
    gestures = state["gestureRecognizers"][:]
    full = (0., 0., 440., 956.)
    native = (0., 0., 440., 876.)
    stock_color = native_state["listVCBackgroundColor"]
    for _ in range(5):
        require(size(cpu, rt, owning) == (0., 956.),
                "The observed 80pt dock reservation becomes drawable video viewport; automatic width stays zero")
        require(rt.objects[owning].state == native_state,
                "Viewport getter leaves the authoritative native config storage unchanged")
        require(send(cpu, rt, owning, "listVCBackgroundColor")["result"] == rt.color("clearColor"),
                "The canvas and corner artwork receive transparent paint instead of opaque black")
        send(cpu, rt, overlay, "setFrame:", fp=full)
        require(state["frame"] == native,
                "Controls stay at the 876pt host height above the floating capsule")
        send(cpu, rt, overlay, "setFrame:", fp=state["frame"])
        require(state["frame"] == native,
                "Reusing the already applied frame cannot subtract the reservation twice")
    require(state["gestureRecognizers"] == gestures, "Original seek, episode and long-press gestures are retained")
    require(rt.methods[rt.get_method(rt.classes["UIView"], rt.sel("setFrame:"))]["imp"] == rt.COLOR_METHOD,
            "The frame hook is local to the player controls and cannot replace UIView's setter")
    rt.objects[rt.DEFAULTS].state["values"][DISABLED] = True
    send(cpu, rt, overlay, "setFrame:", fp=state["frame"])
    require(state["frame"] == native,
            "Disabling glass preserves a fresh native-height host request even when it equals the former applied frame")
    send(cpu, rt, overlay, "setFrame:", fp=full)
    require(state["frame"] == full, "Disabling glass also preserves an explicit full-height host request")
    require(size(cpu, rt, owning) == (0., 876.), "Disabling glass restores native paging size")
    require(send(cpu, rt, owning, "listVCBackgroundColor")["result"] == stock_color,
            "Disabling glass restores the original canvas/corner color")
    return {"window": [0., 0., 440., 956.], "native_player": list(native),
            "viewport": [0., 956.], "controls": list(native), "repeat_count": 5,
            "config_storage_unchanged": True, "gesture_identity_retained": True}


def host_updates_and_reuse(data, labels):
    cpu, rt = make_drama_dock_runtime(data, labels)
    owning = config(rt, width=440.)
    overlay = controls(rt, owning)
    state = rt.objects[overlay].state
    full = (0., 0., 440., 956.)
    size(cpu, rt, owning)
    send(cpu, rt, overlay, "setFrame:", fp=full)
    require(state["frame"] == (0., 0., 440., 876.), "Initial full frame preserves native controls")
    rt.objects[owning].state["portraitVideoSize"] = (440., 882.)
    require(size(cpu, rt, owning) == (440., 956.), "A host change to a 74pt reservation is re-read")
    send(cpu, rt, overlay, "setFrame:", fp=full)
    require(state["frame"] == (0., 0., 440., 882.), "New native control height wins over a stale 80pt snapshot")
    custom = (0., 0., 440., 900.)
    send(cpu, rt, overlay, "setFrame:", fp=custom)
    require(state["frame"] == custom, "An unrelated native canvas height is not treated as a dock reservation")
    rt.objects[rt.DEFAULTS].state["values"][DISABLED] = True
    send(cpu, rt, overlay, "setFrame:", fp=custom)
    require(state["frame"] == custom, "Disabling after a host layout change preserves its newer frame")
    rt.objects[rt.DEFAULTS].state["values"][DISABLED] = False
    send(cpu, rt, overlay, "setFrame:", fp=full)
    rt.objects[owning].state["feedType"] = 5
    send(cpu, rt, overlay, "setFrame:", fp=state["frame"])
    require(state["frame"] == (0., 0., 440., 882.),
            "A reused control preserves the new feed's native-height request without inferring a stale full-height baseline")
    send(cpu, rt, overlay, "setFrame:", fp=full)
    require(state["frame"] == full, "A reused control also preserves a new full-height request from the new feed")
    require(size(cpu, rt, owning) == (440., 882.), "Detail feeds retain their native paging size")
    rt.objects[owning].state["feedType"] = 4
    landscape = (0., 0., 956., 440.)
    send(cpu, rt, overlay, "setFrame:", fp=landscape)
    require(state["frame"] == landscape, "Landscape controls retain their native requested frame")
    # Native controls can already be at their final height; do not shrink them
    # solely because the owning feed has a drawable extension below them.
    native = (0., 0., 440., 882.)
    send(cpu, rt, overlay, "setFrame:", fp=native)
    require(state["frame"] == native, "Already-native control bounds are never reduced again")
    local_only = rt.view(CONTROLS, "controls with original local configuration", full, rt.ROOT,
                         listVCContext=0, listVCConfig=owning)
    send(cpu, rt, local_only, "setFrame:", fp=full)
    require(rt.objects[local_only].state["frame"] == native,
            "A control without a context can use its original native local configuration")
    unresolved = rt.view(CONTROLS, "unresolved native configuration", full, rt.ROOT,
                         listVCContext=0, listVCConfig=0)
    send(cpu, rt, unresolved, "setFrame:", fp=full)
    require(rt.objects[unresolved].state["frame"] == full,
            "Missing native configuration cannot cause a guessed control inset")
    narrow = (0., 0., 320., 956.)
    send(cpu, rt, local_only, "setFrame:", fp=narrow)
    require(rt.objects[local_only].state["frame"] == narrow,
            "A narrow or embedded control canvas does not receive the full-width dock inset")
    return {"latest_host_geometry": True, "custom_frame_preserved": True,
            "feed_reuse_restored": True, "landscape_unchanged": True,
            "local_config_fallback": True, "missing_config_and_narrow_canvas_preserved": True}


def bounded_geometry(data, labels):
    cpu, rt = make_drama_dock_runtime(data, labels)
    accepted = [(440., 956., 440., 916.), (440., 956., 0., 836.),
                (375., 812., 375., 738.), (956., 440., 0., 876.)]
    for screen_width, screen_height, width, height in accepted:
        rt.objects[rt.screen].state["bounds"] = (0., 0., screen_width, screen_height)
        item = config(rt, width, height)
        require(size(cpu, rt, item) == (width, max(screen_width, screen_height)),
                "Only the bounded portrait dock gap is added, including auto width and rotated screen bounds")
    rt.objects[rt.screen].state["bounds"] = (0., 0., 440., 956.)
    rejected = [(440., 917.), (440., 835.), (440., 956.), (375., 876.),
                (956., 440.), (-1., 876.), (440., -1.),
                (math.nan, 876.), (0., math.nan), (math.inf, 876.), (0., math.inf)]
    for width, height in rejected:
        item = config(rt, width, height)
        require(same_numbers(size(cpu, rt, item), (width, height)),
                "Malformed, unrelated, landscape and already-full native canvas sizes remain unchanged")
    item = config(rt, feed_type=5)
    require(size(cpu, rt, item) == (0., 876.), "A different feed type cannot obtain the main-tab dock extension")
    return {"eligible_sizes": len(accepted), "rejected_sizes": len(rejected), "other_feed_rejected": True}


def incompatible_abi(data, labels):
    cases = [(CONFIG, "portraitVideoSize", "@16@0:8"),
             (CONFIG, "feedType", "@16@0:8"),
             (CONFIG, "listVCBackgroundColor", "q16@0:8"),
             ("FQVShortVideoVPlayerControlView", "listVCConfig", "q16@0:8"),
             ("FQVShortVideoVPlayerControlView", "setFrame:", "v24@0:8@16")]
    for cls, selector, changed in cases:
        def mutate(rt):
            method = rt.get_method(rt.classes[cls], rt.sel(selector))
            rt.methods[method]["encoding"] = changed
        cpu, rt = make_drama_dock_runtime(data, labels, before_install=mutate)
        for check_cls, check_selector in [(CONFIG, "portraitVideoSize"),
                                           (CONFIG, "listVCBackgroundColor"),
                                           ("FQVShortVideoVPlayerControlView", "setFrame:")]:
            require(rt.methods[rt.get_method(rt.classes[check_cls], rt.sel(check_selector))]["imp"] == rt.COLOR_METHOD,
                    "An incompatible viewport/control ABI cannot install a partial dock repair")
        installed = [record for event, record in rt.records if event == "dramaDockBackdropInstall"]
        require(len(installed) == 1 and not installed[0]["installed"] and
                not installed[0]["videoSizeOverridden"], "Skipped dock ABI is reported accurately")
    return {"rejected_abi_groups": len(cases), "partial_color_or_geometry_hook": False}


def bounded_color(data, labels):
    cpu, rt = make_drama_dock_runtime(data, labels)
    cases = [(0., 876., 4, True), (440., 876., 4, True),
             (0., 956., 4, True), (440., 956., 4, True),
             (440., 917., 4, False), (440., 835., 4, False),
             (320., 876., 4, False), (956., 440., 4, False),
             (0., 876., 5, False), (0., math.nan, 4, False)]
    for width, height, feed_type, clear in cases:
        item = config(rt, width, height, feed_type)
        stock = rt.objects[item].state["listVCBackgroundColor"]
        result = send(cpu, rt, item, "listVCBackgroundColor")["result"]
        require(result == (rt.color("clearColor") if clear else stock),
                "Only a matching root dock canvas or its full-height resolved copy loses stock opaque paint")
    return {"matched_native_or_resolved": 4, "unrelated_native_paint_preserved": len(cases)-4}


def gradient_feather(data, labels):
    cpu, rt = make_drama_dock_runtime(data, labels)
    rt._class("FQVShortVideoGradientLayerView", "UIView")
    original_handle = rt.handle

    def handle(cpu, pc):
        if pc - rt.slide == 0xa5d4:
            receiver, selector, value = cpu.x[:3]
            obj = rt.objects.get(receiver)
            name = rt.selector_names[selector]
            if obj and obj.cls == rt.classes["CAGradientLayer"]:
                if name == "locations":
                    return rt.finish(cpu, obj.state["locations"])
                if name == "setLocations:":
                    obj.state["locations"] = value
                    return rt.finish(cpu)
            if obj and name in ("bottomGradientView", "isCleanMode") and name in obj.state:
                return rt.finish(cpu, obj.state[name])
            if obj and obj.cls == rt.classes["NSArray"] and name == "isEqual:":
                return rt.finish(cpu, int(rt.object_equal(receiver, value)))
        return original_handle(cpu, pc)

    rt.handle = handle
    owning = config(rt)
    overlay = controls(rt, owning)
    top = rt.color("transparent mask stop")
    bottom = rt.color("opaque mask stop")
    colors = rt.obj("NSArray", "stock gradient colors", items=[top, bottom])
    locations = rt.obj("NSArray", "stock gradient locations", items=[
        rt.obj("NSNumber", "top", value=0.), rt.obj("NSNumber", "bottom", value=1.)])
    layer = rt.obj("CAGradientLayer", "native bottom gradient", colors=colors, locations=locations)
    frame = (0., 596., 440., 280.)
    gradient = rt.view("FQVShortVideoGradientLayerView", "native caption shading", frame, overlay,
                       gradientLayer=layer)
    rt.objects[overlay].state["bottomGradientView"] = gradient
    state = rt.objects[layer].state
    send(cpu, rt, overlay, "setFrame:", fp=(0., 0., 440., 956.))
    send(cpu, rt, overlay, "layoutSubviews")
    applied = dict(state)
    require(rt.objects[applied["colors"]].state["items"] == [top, bottom, top],
            "The full-width bottom gradient fades to the transparent stop")
    require([rt.objects[item].state["value"] for item in
             rt.objects[applied["locations"]].state["items"]] == [0., 1 - 10 / 280, 1.],
            "The last ten points feather into the video canvas")
    require(rt.objects[gradient].state["frame"] == frame,
            "Feathering leaves the native gradient frame in place")
    send(cpu, rt, overlay, "setFrame:", fp=(0., 0., 440., 876.))
    send(cpu, rt, overlay, "layoutSubviews")
    require(state == applied, "An already-native frame request keeps the existing fade")

    new_bottom = rt.color("updated native shade")
    new_colors = rt.obj("NSArray", "host contrast update", items=[top, new_bottom])
    state["colors"] = new_colors
    send(cpu, rt, overlay, "layoutSubviews")
    require(rt.objects[state["colors"]].state["items"] == [top, new_bottom, top],
            "Use the newer host gradient palette when it changes")
    rt.objects[rt.DEFAULTS].state["values"][DISABLED] = True
    send(cpu, rt, overlay, "layoutSubviews")
    require(state["colors"] == new_colors and state["locations"] == locations,
            "Disabling glass restores the most recent host gradient stops")
    rt.objects[rt.DEFAULTS].state["values"][DISABLED] = False
    rt.objects[owning].state["feedType"] = 5
    send(cpu, rt, overlay, "layoutSubviews")
    require(state["colors"] == new_colors and state["locations"] == locations,
            "The detail feed retains its native gradient")
    return {"fade_points": 10, "reused_native_frame": True, "host_palette_retained": True}


def main():
    parser = argparse.ArgumentParser(description=__doc__)
    parser.add_argument("candidate", type=Path)
    parser.add_argument("--report", type=Path, required=True)
    args = parser.parse_args()
    data = args.candidate.read_bytes()
    require(release_version(data) in ("1.78R4", "1.78R5", "1.78R6", "1.78R7", "1.78R8", "1.78R9", "1.78R10", "1.78R11", "1.78R12", "1.78R13", "1.78R14", "1.78R15", "1.78R16", "1.78R25", "1.78R26", "1.78R27", "1.78R28", "1.78R29", "1.78R30", "1.78R31", "1.78R32", "1.78R33", "1.78R34", "1.78R35", "1.78R36", "1.79R1", "1.79R2", "1.79R3", "1.79R4", "1.79R5", "1.8R1", "1.8R2", "1.8R3", "1.8R4", "1.8R5", "1.8R6", "1.8R7", "1.8R8", "1.8R9", "1.8R10", "1.8R11", "1.8R12", "1.8R13", "1.8R14", "1.8R15", "1.8R16", "1.8R17", "1.8R18", "1.8R19", "1.8R19", "1.9.1beta1", "1.9.1beta2", "1.9.1beta3", "1.9.1beta4", "1.9.1beta5", "1.9.1beta6", "1.9.1beta7", "1.9.1beta8", "1.9.1beta9", "1.9.1beta10", "1.9.1beta11", "1.9.1beta12", "1.9.1beta13", "1.9.1beta14"), "This regression must execute the actual R4-or-later candidate")
    labels = labels_for(data, args.candidate.with_suffix(".composed.s"), LABELS + EXTRA)
    report = {"passed": True, "sha256": hashlib.sha256(data).hexdigest(),
              "observed_geometry": observed_geometry(data, labels),
              "host_updates_and_reuse": host_updates_and_reuse(data, labels),
              "bounded_geometry": bounded_geometry(data, labels),
              "bounded_color": bounded_color(data, labels),
              "incompatible_abi": incompatible_abi(data, labels),
              "device_tested": False, "pixel_rendering_tested": False,
              "boundary": "Candidate ARM64 with explicit native ABI/geometry and UIKit/Foundation fixtures"}
    if release_version(data) in ("1.78R6", "1.78R7", "1.78R8", "1.78R9", "1.78R10", "1.78R11", "1.78R12", "1.78R13", "1.78R14", "1.78R15", "1.78R16", "1.78R25", "1.78R26", "1.78R27", "1.78R28", "1.78R29", "1.78R30", "1.78R31", "1.78R32", "1.78R33", "1.78R34", "1.78R35", "1.78R36", "1.79R1", "1.79R2", "1.79R3", "1.79R4", "1.79R5", "1.8R1", "1.8R2", "1.8R3", "1.8R4", "1.8R5", "1.8R6", "1.8R7", "1.8R8", "1.8R9", "1.8R10", "1.8R11", "1.8R12", "1.8R13", "1.8R14", "1.8R15", "1.8R16", "1.8R17", "1.8R18", "1.8R19", "1.8R19", "1.9.1beta1", "1.9.1beta2", "1.9.1beta3", "1.9.1beta4", "1.9.1beta5", "1.9.1beta6", "1.9.1beta7", "1.9.1beta8", "1.9.1beta9", "1.9.1beta10", "1.9.1beta11", "1.9.1beta12", "1.9.1beta13", "1.9.1beta14"):
        report["gradient_feather"] = gradient_feather(data, labels)
    args.report.parent.mkdir(parents=True, exist_ok=True)
    args.report.write_text(json.dumps(report, ensure_ascii=False, indent=2) + "\n")
    print(json.dumps(report, ensure_ascii=False, indent=2))


if __name__ == "__main__":
    main()
