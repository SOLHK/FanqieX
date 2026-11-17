#!/usr/bin/env python3
"""Run the ARM64 dock touch hooks with native UIView/gesture boundaries modelled."""
import argparse
import hashlib
import json
from pathlib import Path

from arm64 import release_version, require
from test_drama_spacing178r2 import Runtime as SpacingRuntime, LABELS, call, labels_for, make, send


INNER = "FQVShortVideoVPlayerControlView"
OUTER = "SSShortVideoOutterMultiGenreFeedControlView"
HIT = "hitTest:withEvent:"
TOUCH = "gestureRecognizer:shouldReceiveTouch:"
BEGIN = "gestureRecognizerShouldBegin:"
EXTRA = ["LFQH_FQHPageInstall", "LFQH_BottomProxyBox178Key", "LFQH_BottomWindowBarKey", "LFQH_FQHDramaSpacing178R2"]
COMPACT = "LFQH_BottomCompact178Key"
BASE = "LFQH_BottomBaseFrame178Key"
BUTTONS = "LFQH_BottomButtons178Key"


class Runtime(SpacingRuntime):
    NATIVE_HIT = 0x33901400
    NATIVE_ALLOW = 0x33901410

    def __init__(self, data):
        super().__init__(data)
        for name, parent in ((OUTER, "UIView"), ("SSTabBar", "UIView"),
                             ("SSShortVideoOutterMultiGenreProgressView", "UIView"),
                             ("UITouch", "NSObject"), ("UIPanGestureRecognizer", "NSObject"),
                             ("SSTabBarController", "NSObject"),
                             ("SSShortVideoRcmdMainViewController", "NSObject")):
            if name not in self.classes:
                self._class(name, parent)
        for name in ("UIWindow", OUTER, "SSTabBar"):
            self._add(self.classes[name], HIT, self.NATIVE_HIT, "@40@0:8{CGPoint=dd}16@32")
        for name in (INNER, OUTER):
            self._add(self.classes[name], "progressPanGesture", self.NATIVE_ALLOW, "@16@0:8")
        self._add(self.classes[INNER], BEGIN, self.NATIVE_ALLOW, "B24@0:8@16")
        self._add(self.classes[OUTER], TOUCH, self.NATIVE_ALLOW, "B32@0:8@16@24")
        self.hit_calls = []

    def handle(self, cpu, pc):
        receiver, selector = cpu.x[:2]
        name = self.selector_names.get(selector)
        state = self.objects[receiver].state if receiver in self.objects else {}
        if pc == self.NATIVE_HIT:
            self.hit_calls.append((receiver, cpu.fp(0), cpu.fp(1), cpu.x[2]))
            return self.finish(cpu, state.get("nativeHit", 0))
        if pc == self.NATIVE_ALLOW:
            return self.finish(cpu, state[name] if name == "progressPanGesture" else 1)
        if pc-self.slide == 0xa5d4:
            if name in ("locationInView:", "translationInView:") and name in state:
                return self.finish(cpu, fp=state[name])
            if name in ("viewIfLoaded", "selectedViewController", "presentedViewController", "progressContainer", "progressView") and name in state:
                return self.finish(cpu, state[name])
            if name in ("setNeedsLayout", "layoutIfNeeded") and "nativeTrack" in state:
                if name == "layoutIfNeeded":
                    track = self.objects[state["nativeTrack"]].state
                    x, y, _, height = track["frame"]
                    width = state["bounds"][2] - 32.
                    track.update(frame=(x, y, width, height), bounds=(0., 0., width, height))
                return self.finish(cpu)
        return super().handle(cpu, pc)


def verify_alignment(cpu, runtime, labels, controls, kind, proxy):
    inner = kind == INNER
    rail_kind = "FQVShortVideoProgressView" if inner else "SSShortVideoOutterMultiGenreProgressView"
    rail = runtime.view(rail_kind, "native seek owner", (0., 851., 440., 30.), controls)
    track = runtime.view("UIView", "native track", (16., 22., 408., 2.), rail)
    runtime.objects[controls].state["progressContainer" if inner else "progressView"] = rail
    runtime.objects[rail].state.update(nativeTrack=track, progressBarBackgroundView=track)
    entry = entry_content = 0
    if inner:
        entry = runtime.view("SSShortVideoBottomDistributionView", "watch all episodes", (0., 818., 440., 44.), controls)
        entry_content = runtime.view("SSShortVideoDistributionContentView", "native episode tap surface",
                                     (0., 0., 440., 44.), entry, nativeAction="open series")
        runtime.objects[entry].state["defaultContentView"] = entry_content
        model_bar = runtime.obj("NSObject", "series model", bottomBarType=runtime.text_object("short_play"))
        model = runtime.obj("NSObject", "native episode data", bottomBar=model_bar)
        send(cpu, runtime, entry, "renderWithModel:", model)

    proxy_state = runtime.objects[proxy].state
    r24 = release_version(runtime.data) in ("1.78R24", "1.78R25", "1.78R26", "1.78R27", "1.78R28", "1.78R29", "1.78R30", "1.78R31", "1.78R32", "1.78R33", "1.78R34", "1.78R35")
    bar = proxy_state["superview"]
    for dock_x, dock_width, expected_x, expected_width in ((20., 400., 20., 400.),
                                                           (34., 372., 34., 372.),
                                                           (370., 50., 16., 408.)):
        proxy_state.update(frame=(dock_x, 0., dock_width, 62.), bounds=(0., 0., dock_width, 62.))
        if r24 and dock_width < 220.:
            runtime.objects[runtime.DEFAULTS].state["values"]["FanqieX.BottomLengthScale.1"] = 93
            runtime.associations[bar, labels[COMPACT]] = runtime.box(True)
            runtime.associations[proxy, labels[BASE]] = runtime.obj("NSValue", "expanded stock frame", rect=(20., 0., 400., 62.))
            runtime.associations[proxy, labels[BUTTONS]] = runtime.box([0, 1, 2, 3])
        if entry:
            send(cpu, runtime, entry, "layoutSubviews")
        call(cpu, labels, "LFQH_FQHDramaSpacing178R2", controls)
        require(runtime.origin(track) == (expected_x, 873.) and runtime.objects[track].state["frame"][2] == expected_width,
                f"{kind} rail follows the full dock width and retains its vertical level")
        if entry_content:
            state = runtime.objects[entry_content].state
            material = next(child for child in state["subviews"] if runtime.objects[child].state.get("configuration"))
            cta_x, cta_width = ((expected_x, expected_width) if dock_width >= 220.
                               else (34., 372.) if r24 else (8., 424.))
            require(runtime.origin(material)[0] == cta_x and runtime.objects[material].state["frame"][2] == cta_width
                    and state["nativeAction"] == "open series", "CTA matches dock edges with its native tap surface intact")
    if r24:
        runtime.associations.pop((bar, labels[COMPACT]), None)
        runtime.associations.pop((proxy, labels[BASE]), None)
        runtime.associations.pop((proxy, labels[BUTTONS]), None)
        runtime.objects[runtime.DEFAULTS].state["values"].pop("FanqieX.BottomLengthScale.1")
    proxy_state.update(frame=(20., 0., 400., 62.), bounds=(0., 0., 400., 62.))


def verify(data, labels):
    cpu, runtime = make(data, Runtime)
    runtime.labels = labels
    call(cpu, labels, "LFQH_FQHPageInstall")
    window = runtime.view("UIWindow", "host window", (0., 0., 440., 956.))
    content = runtime.view("UIView", "drama page", (0., 0., 440., 956.), window)
    page = runtime.obj("SSShortVideoRcmdMainViewController", "selected drama", viewIfLoaded=content)
    owner = runtime.obj("SSTabBarController", "tab owner", selectedViewController=page)
    bar = runtime.view("SSTabBar", "tab bar", (0., 882., 440., 74.), window, delegate=owner)
    proxy = runtime.view("UIView", "visible dock", (20., 0., 400., 62.), bar)
    overlay = runtime.view("UIView", "dock interaction overlay", (20., 0., 400., 62.), bar)
    button = runtime.view("UIButton", "native tab target", (8., 4., 80., 54.), overlay)
    runtime.objects[bar].state["nativeHit"] = button
    for host, key, target in ((window, EXTRA[2], bar), (bar, EXTRA[1], proxy)):
        runtime.associations[host, labels[key]] = runtime.obj("NSHashTable", "weak target", items=[target])
    event = runtime.obj("NSObject", "touch event")
    touch = runtime.obj("UITouch", "touch origin")
    other = runtime.obj("UIPanGestureRecognizer", "other recognizer")
    cases = []
    for kind in (INNER, OUTER):
        gesture = runtime.obj("UIPanGestureRecognizer", f"{kind} seek pan")
        controls = runtime.view(kind, "video controls", (0., 0., 440., 940.), content,
                                progressPanGesture=gesture)
        progress = runtime.view("UIView", "progress child", (16., 849., 408., 66.), controls)
        runtime.objects[window].state["nativeHit"] = progress
        require(send(cpu, runtime, window, HIT, event, fp=(60., 884.))["result"] == button,
                f"{kind} cannot steal an initial hit inside the capsule")
        require(runtime.hit_calls[-1] == (bar, 60., 2., event), "Dock receives its own coordinates and event")
        for point in ((60., 873.), (10., 885.)):
            require(send(cpu, runtime, window, HIT, event, fp=point)["result"] == progress,
                    f"{kind} still receives points outside the dock")
        runtime.objects[touch].state["locationInView:"] = (40., 2.)
        require(send(cpu, runtime, controls, TOUCH, gesture, touch)["result"] == 0,
                f"{kind} progress rejects a touch from the dock")
        require(send(cpu, runtime, controls, TOUCH, other, touch)["result"] == 1,
                f"{kind} leaves unrelated gestures to UIKit")
        runtime.objects[touch].state["locationInView:"] = (40., -9.)
        require(send(cpu, runtime, controls, TOUCH, gesture, touch)["result"] == 1,
                f"{kind} progress accepts an initial touch from the track")
        if kind == INNER:
            pan = runtime.objects[gesture].state
            pan.update({"locationInView:": (48., -1.), "translationInView:": (8., -3.)})
            require(send(cpu, runtime, controls, BEGIN, gesture)["result"] == 0,
                    "A dock-origin pan cannot begin after moving above the dock")
            pan.update({"locationInView:": (48., 2.), "translationInView:": (8., 11.)})
            require(send(cpu, runtime, controls, BEGIN, gesture)["result"] == 1,
                    "A track-origin pan keeps the native delegate after moving down")
        if release_version(data) in ("1.78R19", "1.78R25", "1.78R26", "1.78R27", "1.78R28", "1.78R29", "1.78R30", "1.78R31", "1.78R32", "1.78R33", "1.78R34", "1.78R35"):
            verify_alignment(cpu, runtime, labels, controls, kind, proxy)
            cases.append(f"{kind} rail and available episode CTA align to native dock edges")
        cases.append(f"{kind} initial dock and track separation")
    for property_name, value in (("hidden", True), ("alpha", 0.0)):
        stock = runtime.objects[proxy].state[property_name]
        runtime.objects[proxy].state[property_name] = value
        require(send(cpu, runtime, window, HIT, event, fp=(60., 884.))["result"] == progress,
                "An unavailable dock cannot intercept playback")
        runtime.objects[proxy].state[property_name] = stock
    runtime.objects[owner].state["presentedViewController"] = runtime.obj("NSObject", "presented controller")
    require(send(cpu, runtime, window, HIT, event, fp=(60., 884.))["result"] == progress,
            "A presented controller retains the window hit")
    runtime.objects[owner].state["presentedViewController"] = 0
    runtime.objects[runtime.DEFAULTS].state["values"]["FanqieAdBlock.GlassDisabled.1"] = True
    require(send(cpu, runtime, window, HIT, event, fp=(60., 884.))["result"] == progress,
            "Disabling glass restores the native hit")
    cases.extend(("hidden, transparent dock fallthrough", "presented controller fallthrough",
                  "disabled glass fallthrough"))
    return cases


if __name__ == "__main__":
    parser = argparse.ArgumentParser()
    parser.add_argument("candidate", type=Path)
    parser.add_argument("--report", type=Path, required=True)
    args = parser.parse_args()
    binary = args.candidate.read_bytes()
    extra = [COMPACT, BASE, BUTTONS] if release_version(binary) in ("1.78R24", "1.78R25", "1.78R26", "1.78R27", "1.78R28", "1.78R29", "1.78R30", "1.78R31", "1.78R32", "1.78R33", "1.78R34", "1.78R35") else []
    symbols = labels_for(binary, args.candidate.with_suffix(".composed.s"), list(dict.fromkeys(LABELS + EXTRA + extra)))
    report = {"passed": True, "candidate_sha256": hashlib.sha256(binary).hexdigest(),
              "cases": verify(binary, symbols), "device_tested": False}
    output = json.dumps(report, indent=2)
    args.report.write_text(output + "\n", encoding="utf-8")
    print(output)
