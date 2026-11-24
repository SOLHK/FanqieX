#!/usr/bin/env python3
"""Exercise custom dock sizes across the real legacy frame adapters.

The unavailable host supplies stock CGRect proposals at its audited callsites.
The candidate's ARM64 executes Lbutton_frame, LMproxy_frame, the original frame
setter and the full repair. Unlike the older final-state-only geometry checks,
this suite records every UIKit frame write and synchronous layout request.
It is not a UIKit run loop, physical gesture test or device acceptance.
"""
from __future__ import annotations

import argparse
import hashlib
import json
from pathlib import Path

from arm64 import release_version, require
from test_bottom_appearance178 import (
    BUTTON_WIDTH, COMPACT, HEIGHT, ICONS, ICON_SIZE, LENGTH, PAGE_HOOK,
    Runtime as AppearanceRuntime, bottom_labels, call, check_input, host_geometry,
    page_drag, send_pan, tap_expand,
)
from test_feed_viewport import labels_for
from test_native_orchestration162 import make, repair, send_interaction_pan


FRAME_LABELS = ["Lbutton_frame", "LMproxy_frame"]


class Runtime(AppearanceRuntime):
    def __init__(self, *args, **kwargs):
        self.frame_changes = []
        self.frame_writes = []
        self.round_trip_frames = False
        self.synchronous_layouts = []
        self.requested_layouts = []
        super().__init__(*args, **kwargs)

    def handle(self, cpu, pc):
        if pc - self.slide == 0xa5d4 and cpu.x[0] in self.objects:
            receiver = cpu.x[0]
            selector = self.selector_names.get(cpu.x[1])
            if self.round_trip_frames and selector == "frame" and receiver in (
                self.PROXY, self.PROXY_CONTENT, *self.buttons, self.control()
            ):
                # UIView derives this origin from center and bounds even
                # when its visual frame was unchanged since the last setter.
                x, y, width, height = self.objects[receiver].state["frame"]
                return self.finish(cpu, fp=((x + width / 2) - width / 2,
                                            (y + height / 2) - height / 2,
                                            width, height))
            if selector == "setFrame:":
                self.frame_writes.append(receiver)
                before = self.objects[receiver].state["frame"]
                after = tuple(cpu.fp(index) for index in range(4))
                if before != after:
                    self.frame_changes.append((receiver, before, after))
            elif selector == "layoutIfNeeded":
                self.synchronous_layouts.append(receiver)
            elif selector == "setNeedsLayout":
                self.requested_layouts.append(receiver)
        return super().handle(cpu, pc)


def stock_buttons(stock, count, reversed_order=False):
    width = (stock[2] - 8) / count
    return [(4 + width * (count - 1 - index if reversed_order else index),
             4, width, stock[3] - 8)
            for index in range(count)]


def fixture(data, labels, *, fallback=False, selected=1, stock=(20., 0., 400., 56.)):
    cpu, runtime, entries = make(data, runtime_class=Runtime,
                                 missing_segment_class=fallback)
    runtime.labels = runtime.new_labels = labels
    runtime.configure_tabs(("书城", "短剧", "书架", "我的"), selected=selected)
    runtime.objects[runtime.PROXY].state.update(frame=stock, bounds=(0., 0., *stock[2:]))
    runtime.objects[runtime.PROXY_CONTENT].state.update(
        frame=(0., 0., *stock[2:]), bounds=(0., 0., *stock[2:]))
    for button, frame in zip(runtime.buttons, stock_buttons(stock, len(runtime.buttons))):
        runtime.objects[button].state.update(frame=frame, bounds=(0., 0., *frame[2:]))
    if PAGE_HOOK in labels:
        cpu.run(labels[PAGE_HOOK], max_steps=3000000)
    return cpu, runtime, entries


def host_layout(cpu, runtime, entries, labels, stock, reversed_order=False):
    # The pinned legacy builder at 0x62ac..0x6db0 proposes button frames at
    # 0x6c84, then the capsule frame at 0x6ce8, then runs selection repair.
    # No policy is reproduced here: these inputs are the old stock proposal.
    for button, frame in zip(runtime.buttons, stock_buttons(stock, len(runtime.buttons), reversed_order)):
        cpu.run(labels["Lbutton_frame"], args=(button,), fp_args=frame,
                max_steps=3000000)
    cpu.run(labels["LMproxy_frame"], args=(runtime.PROXY,), fp_args=stock,
            max_steps=3000000)
    repair(cpu, runtime, entries)


def changes_for(runtime, start, views):
    return [change for change in runtime.frame_changes[start:] if change[0] in views]


def stable_custom_layout(data, labels):
    cases = []
    for fallback in (False, True):
        for length, height, width in ((100, 110, 100), (75, 90, 75),
                                      (50, 80, 70), (100, 125, 100)):
            cpu, runtime, entries = fixture(data, labels, fallback=fallback)
            feed, pan, host_target = runtime.add_feed()
            stock = runtime.objects[runtime.PROXY].state["frame"]
            before_host = host_geometry(runtime, (feed,))
            runtime.defaults(**{ICONS: True, COMPACT: True, ICON_SIZE: 28,
                                LENGTH: length, HEIGHT: height, BUTTON_WIDTH: width})
            repair(cpu, runtime, entries)
            expected = {view: runtime.objects[view].state["frame"]
                        for view in (runtime.PROXY, *runtime.buttons)}
            control = runtime.control()
            if control:
                # Host remains on short drama, while UIKit previews another
                # tab under the user's finger. Maintenance must keep it.
                runtime.objects[control].state.update(tracking=True, selectedSegmentIndex=3)
            before_allocations = sum(event["event"] == "native_alloc" for event in runtime.events)
            before_tints = sum(event["event"] == "native_selected_tint" for event in runtime.events)
            initial_routes = len(runtime.route_calls)
            start = len(runtime.frame_changes)
            for _ in range(3):
                host_layout(cpu, runtime, entries, labels, stock)
                repair(cpu, runtime, entries)
            mutations = changes_for(runtime, start, (runtime.PROXY, runtime.PROXY_CONTENT,
                                                     *runtime.buttons, control))
            require(not mutations,
                    "Stable custom host layout must not toggle stock/custom CGRects; "
                    f"{len(mutations)} transient writes at {length}/{height}/{width}")
            require(expected == {view: runtime.objects[view].state["frame"] for view in expected},
                    "Repeated host proposals keep the chosen custom geometry")
            require(runtime.control() == control,
                    "Maintenance reuses the active native selector")
            require(sum(event["event"] == "native_alloc" for event in runtime.events) ==
                    before_allocations,
                    "Maintenance does not reallocate UIKit's tracking control")
            if control:
                if PAGE_HOOK in labels:
                    require(sum(event["event"] == "native_selected_tint" for event in runtime.events) == before_tints,
                            "Maintenance does not reapply the selected tint during native touch tracking")
                require(runtime.objects[control].state["selectedSegmentIndex"] == 3 and
                        runtime.objects[control].state["tracking"],
                        "An active drag preview survives stock host layout callbacks")
                runtime.objects[control].state["tracking"] = False
            require(len(runtime.route_calls) == initial_routes,
                    "Layout is never a synthetic navigation action")
            check_input(runtime, cpu, not runtime.control(), 3)
            require(host_geometry(runtime, (feed,)) == before_host,
                    "Custom dock layout cannot move the host page or scroll view")
            require(runtime.objects[pan].state["delegate"] == host_target,
                    "The original scroll gesture keeps its host delegate")
            cases.append({"renderer": "native" if control else "explicit pan",
                          "length_percent": length, "height_percent": height,
                          "button_width_percent": width, "stable_frame_writes": 0,
                          "one_original_route": True})
    return cases


def settings_yield_before_layout(data, labels):
    cpu, runtime, entries = fixture(data, labels)
    runtime.defaults(**{ICONS: True, COMPACT: True})
    repair(cpu, runtime, entries)
    owner = runtime.obj("NSObject", "settings controller")
    runtime.objects[runtime.owner].state["presentedViewController"] = owner
    sliders = []
    for tag, value in ((11, 80.), (12, 110.), (13, 75.), (14, 28.)):
        sender = runtime.view("UISlider", "dimension setting", tag=tag, value=value)
        sliders.append(sender)
    sync_start = len(runtime.synchronous_layouts)
    requested_start = len(runtime.requested_layouts)
    frames_start = len(runtime.frame_changes)
    for sender in sliders:
        for _ in range(3):
            call(cpu, labels, "FQHBottomOptionChanged178", owner,
                 runtime.sel("fqx178_bottomOptionChanged:"), sender)
    require(not runtime.synchronous_layouts[sync_start:],
            "Slider tracking returns without recursively forcing the host bar to layout")
    require(not changes_for(runtime, frames_start, (runtime.PROXY, runtime.PROXY_CONTENT,
                                                    *runtime.buttons, runtime.control())),
            "A continuous settings callback only schedules layout; it does not resize synchronously")
    require(runtime.BAR in runtime.requested_layouts,
            "Settings still schedule the next normal UIKit layout")
    require(runtime.requested_layouts[requested_start:].count(runtime.BAR) == 3,
            "Repeated rounded samples and an unchanged icon size do not schedule extra layouts")
    values = runtime.objects[runtime.DEFAULTS].state["values"]
    require(all(values[key] == expected for key, expected in
                ((LENGTH, 80), (HEIGHT, 110), (BUTTON_WIDTH, 75), (ICON_SIZE, 28))),
            "Deferred presentation preserves immediately saved canonical settings")
    # A normal UIKit opportunity still applies the final saved value.
    repair(cpu, runtime, entries)
    require(runtime.objects[runtime.PROXY].state["frame"][3] > 56,
            "The next layout displays the saved 110 percent capsule height")
    sync_start = len(runtime.synchronous_layouts)
    call(cpu, labels, "FQHBottomOptionsReset178", owner,
         runtime.sel("fqx178_resetBottom:"), 0)
    require(not runtime.synchronous_layouts[sync_start:],
            "Reset also returns to UIKit without synchronous host layout")
    repair(cpu, runtime, entries)
    require(runtime.objects[runtime.PROXY].state["frame"] == (20., 0., 400., 56.),
            "Reset restores the original capsule on the next layout")
    return {"continuous_samples": 12, "synchronous_layout_calls": 0,
            "persisted_immediately": True, "applied_on_normal_layout": True}


def viewport_and_restore(data, labels):
    cases = []
    for fallback in (False, True):
        cpu, runtime, entries = fixture(data, labels, fallback=fallback)
        runtime.defaults(**{ICONS: True, LENGTH: 80, HEIGHT: 110, BUTTON_WIDTH: 75})
        repair(cpu, runtime, entries)
        # A later host proposal from a different viewport must become the new
        # stock baseline; the customization may never accumulate on itself.
        runtime.objects[runtime.BAR].state.update(frame=(0., 770., 390., 74.),
                                                 bounds=(0., 0., 390., 74.))
        stock = (12., 1., 366., 56.)
        host_layout(cpu, runtime, entries, labels, stock)
        target = runtime.objects[runtime.PROXY].state["frame"]
        require(abs(target[0] + target[2] / 2 - 195) < 0.5 and
                target[2] < stock[2] and 56 < target[3] <= 70,
                "A changed host viewport receives fresh centered custom geometry")
        start = len(runtime.frame_changes)
        host_layout(cpu, runtime, entries, labels, stock)
        require(not changes_for(runtime, start, (runtime.PROXY, runtime.PROXY_CONTENT,
                                                 *runtime.buttons, runtime.control())),
                "The new viewport stabilizes after one layout")
        call(cpu, labels, "FQHBottomReset178", runtime.BAR, runtime.PROXY)
        require(runtime.objects[runtime.PROXY].state["frame"] == stock,
                "Teardown restores the newest host proposal, not a stale portrait frame")
        cases.append({"renderer": "native" if runtime.control() else "explicit pan",
                      "new_stock": list(stock), "custom": list(target),
                      "restored_current_host_geometry": True})
    return cases


def maximum_height_clearance(data, labels):
    cpu, runtime, entries = fixture(data, labels, selected=3)
    runtime.defaults(**{ICONS: True, HEIGHT: 125})
    cases = []
    for bar_height, stock_y, expected_height, expected_gap in (
        (74., 0., 62., 12.),  # 440 x 956 iPhone geometry from device export
        (90., 20., 70., 14.),  # a taller host can fit the full requested height
        (62., 0., 56., 6.),  # a tighter host still keeps the stock clearance
    ):
        stock = (20., stock_y, 400., 56.)
        bar = runtime.objects[runtime.BAR].state
        bar.update(frame=(0., 956. - bar_height, 440., bar_height),
                   bounds=(0., 0., 440., bar_height))
        host_layout(cpu, runtime, entries, labels, stock)
        _, y, _, height = runtime.objects[runtime.PROXY].state["frame"]
        gap = 956. - (bar["frame"][1] + y + height)
        require(y >= 0 and height == expected_height and gap == expected_gap,
                f"The tallest dock must fit the {bar_height:g} pt host bar "
                f"with {expected_gap:g} pt of bottom clearance; got {height:g} pt and {gap:g} pt")
        cases.append({"host_height": bar_height, "dock_height": height, "screen_bottom_gap": gap})
    runtime.defaults(**{HEIGHT: 100})
    host_layout(cpu, runtime, entries, labels, stock)
    require(runtime.objects[runtime.PROXY].state["frame"] == stock,
            "Resetting the height restores the host's original dock geometry")
    return cases


def pan_does_not_force_layout(data, labels):
    cpu, runtime, entries = fixture(data, labels)
    feed, pan, _ = runtime.add_feed()
    runtime.defaults(**{ICONS: True, COMPACT: True, HEIGHT: 110})
    repair(cpu, runtime, entries)
    expanded = runtime.objects[runtime.PROXY].state["frame"]
    start = len(runtime.synchronous_layouts)
    if PAGE_HOOK in labels:
        page_drag(cpu, runtime, feed, 1, 2)
    else:
        send_pan(cpu, runtime, pan, 1)
        send_pan(cpu, runtime, pan, 2, (0., -48.))
    require(not runtime.synchronous_layouts[start:],
            "The host feed pan callback does not synchronously recurse into bar layout")
    repair(cpu, runtime, entries)
    compact = runtime.objects[runtime.PROXY].state["frame"]
    require(compact[2] < expanded[2], "Deferred pan layout still compacts the dock")
    if PAGE_HOOK in labels:
        tap_expand(cpu, runtime)
    else:
        send_pan(cpu, runtime, pan, 2, (0., -15.))
    repair(cpu, runtime, entries)
    require(runtime.objects[runtime.PROXY].state["frame"] == expanded,
            "Expansion restores the custom expanded size")
    return {"synchronous_layout_calls": 0, "compact_and_expand": True}


def layout_direction_change(data, labels):
    cases = []
    for fallback in (False, True):
        cpu, runtime, entries = fixture(data, labels, fallback=fallback)
        stock = runtime.objects[runtime.PROXY].state["frame"]
        runtime.defaults(**{ICONS: True, LENGTH: 75, HEIGHT: 110, BUTTON_WIDTH: 75})
        repair(cpu, runtime, entries)
        for reversed_order in (True, False):
            host_layout(cpu, runtime, entries, labels, stock, reversed_order)
            centers = [runtime.objects[button].state["frame"][0] +
                       runtime.objects[button].state["frame"][2] / 2
                       for button in runtime.buttons]
            require(centers == sorted(centers, reverse=reversed_order) and
                    len(set(centers)) == len(runtime.buttons),
                    "A changed host LTR/RTL order is correct on the very first layout")
            start = len(runtime.frame_changes)
            for _ in range(2):
                host_layout(cpu, runtime, entries, labels, stock, reversed_order)
            require(not changes_for(runtime, start, (runtime.PROXY, runtime.PROXY_CONTENT,
                                                     *runtime.buttons, runtime.control())),
                    "The changed host order remains stable without transient frame writes")
            cases.append({"renderer": "native" if runtime.control() else "explicit pan",
                          "direction": "RTL" if reversed_order else "LTR",
                          "correct_after_one_layout": True,
                          "stable_frame_writes": 0})
    return cases


def fractional_frame_round_trip(data, labels):
    cpu, runtime, entries = fixture(data, labels, selected=2)
    runtime.round_trip_frames = True
    runtime.defaults(**{ICONS: True, LENGTH: 80, HEIGHT: 90, BUTTON_WIDTH: 80})
    stock = runtime.objects[runtime.PROXY].state["frame"]
    repair(cpu, runtime, entries)
    overlay = runtime.associated(runtime.PROXY, "overlay")
    lens = runtime.associated(runtime.PROXY, "lens")
    pan = runtime.associated(runtime.PROXY, "pan")
    require(overlay and lens and pan and not runtime.control(),
            "Resized four-tab capsule keeps the actual drag gesture")
    frame = runtime.objects[runtime.PROXY].state["frame"]
    require(frame == (60., 17 / 3, 320., 151 / 3),
            "The device's 3x fractional-height setup applies the requested width once")
    require((frame[1] + frame[3] / 2) - frame[3] / 2 != frame[1],
            "Fixture genuinely exercises UIView fractional frame roundoff")
    resting = runtime.objects[lens].state["frame"]
    center = resting[0] + resting[2] / 2
    send_interaction_pan(cpu, runtime, 1, center)
    send_interaction_pan(cpu, runtime, 2, center - 30)
    preview = runtime.objects[lens].state["frame"]
    if release_version(data) in ("1.78R15", "1.78R16", "1.78R25", "1.78R26", "1.78R27", "1.78R28", "1.78R29", "1.78R30", "1.78R31", "1.78R32", "1.78R33", "1.78R34", "1.78R35", "1.78R36", "1.79R1", "1.79R2", "1.79R3", "1.79R4", "1.79R5", "1.8R1", "1.8R2", "1.8R3", "1.8R4", "1.8R5", "1.8R6", "1.8R7", "1.8R8", "1.8R9", "1.8R10", "1.8R11", "1.8R12", "1.8R13", "1.8R14", "1.8R15", "1.8R16", "1.8R17", "1.8R18", "1.8R19", "1.8R19", "1.9.1beta1", "1.9.1beta2", "1.9.1beta3", "1.9.1beta4", "1.9.1beta5", "1.9.1beta6", "1.9.1beta7", "1.9.1beta8", "1.9.1beta9", "1.9.1beta10", "1.9.1beta11", "1.9.1beta12", "1.9.1beta13", "1.9.1beta14", "1.9.1beta15", "1.9.1beta16", "1.9.1beta17", "1.9.1beta18", "1.9.1beta19", "1.9.1beta20", "1.9.1beta21", "1.9.1beta22", "1.9.1beta23", "1.9.1beta24", "1.9.1beta25", "1.9.1beta26", "1.9.5beta1", "1.9.5beta2", "1.9.5beta3", "1.9.5beta4", "1.9.5beta5", "1.9.5beta6", "1.9.5beta7", "1.9.5beta8", "1.9.5beta9", "1.9.6beta1", "1.9.6beta2", "1.9.6beta3", "1.9.6beta4", "1.9.6beta5", "1.9.6beta6", "1.9.6beta7", "1.9.6beta8", "1.9.6beta9", "1.9.7beta1", "1.9.7beta2", "1.9.7beta3"):
        require(preview[2] > resting[2] and preview[3] > resting[3],
                "The selected glass lens stays lifted while it tracks across the resized dock")
    effect = runtime.objects[lens].state["effect"]
    require(effect, "A drag on the resized capsule uses the refracting lens")
    start = len(runtime.frame_writes)
    for _ in range(3):
        repair(cpu, runtime, entries)
    require(runtime.objects[runtime.PROXY].state["frame"] == frame and
            not any(view in (runtime.PROXY, runtime.PROXY_CONTENT, overlay, lens, *runtime.buttons)
                    for view in runtime.frame_writes[start:]),
            "Presentation roundoff neither shrinks the capsule twice nor touches an active selector frame")
    require(runtime.associated(runtime.PROXY, "pan") == pan and
            runtime.objects[lens].state["frame"] == preview and
            runtime.objects[lens].state["effect"] == effect and runtime.cancel_callbacks == 0,
            "Repeated no-op layouts preserve the refracting preview under the finger")
    last = runtime.objects[runtime.buttons[3]].state["frame"]
    send_interaction_pan(cpu, runtime, 3, last[0] + last[2] / 2)
    require(runtime.route_calls == [3] and not runtime.objects[lens].state["effect"],
            "The fractional frame still routes to the visible target and rests with plain fill")

    call(cpu, labels, "FQHBottomReset178", runtime.BAR, runtime.PROXY)
    require(runtime.objects[runtime.PROXY].state["frame"] == stock,
            "Reset restores the true stock capsule after fractional-size layout")
    return {"proxy_width": frame[2], "no_geometry_writes_during_tracking": True,
            "stock_restored": True, "refracting_preview_preserved": True}


def main():
    parser = argparse.ArgumentParser(description=__doc__)
    parser.add_argument("candidate", type=Path)
    parser.add_argument("--report", type=Path, required=True)
    args = parser.parse_args()
    data = args.candidate.read_bytes()
    require(release_version(data) in ("1.78R4", "1.78R5", "1.78R6", "1.78R7", "1.78R8", "1.78R9", "1.78R10", "1.78R11", "1.78R12", "1.78R13", "1.78R14", "1.78R15", "1.78R16", "1.78R25", "1.78R26", "1.78R27", "1.78R28", "1.78R29", "1.78R30", "1.78R31", "1.78R32", "1.78R33", "1.78R34", "1.78R35", "1.78R36", "1.79R1", "1.79R2", "1.79R3", "1.79R4", "1.79R5", "1.8R1", "1.8R2", "1.8R3", "1.8R4", "1.8R5", "1.8R6", "1.8R7", "1.8R8", "1.8R9", "1.8R10", "1.8R11", "1.8R12", "1.8R13", "1.8R14", "1.8R15", "1.8R16", "1.8R17", "1.8R18", "1.8R19", "1.8R19", "1.9.1beta1", "1.9.1beta2", "1.9.1beta3", "1.9.1beta4", "1.9.1beta5", "1.9.1beta6", "1.9.1beta7", "1.9.1beta8", "1.9.1beta9", "1.9.1beta10", "1.9.1beta11", "1.9.1beta12", "1.9.1beta13", "1.9.1beta14", "1.9.1beta15", "1.9.1beta16", "1.9.1beta17", "1.9.1beta18", "1.9.1beta19", "1.9.1beta20", "1.9.1beta21", "1.9.1beta22", "1.9.1beta23", "1.9.1beta24", "1.9.1beta25", "1.9.1beta26", "1.9.5beta1", "1.9.5beta2", "1.9.5beta3", "1.9.5beta4", "1.9.5beta5", "1.9.5beta6", "1.9.5beta7", "1.9.5beta8", "1.9.5beta9", "1.9.6beta1", "1.9.6beta2", "1.9.6beta3", "1.9.6beta4", "1.9.6beta5", "1.9.6beta6", "1.9.6beta7", "1.9.6beta8", "1.9.6beta9", "1.9.7beta1", "1.9.7beta2", "1.9.7beta3"),
            "This regression targets the R4 custom geometry fault and its R5 repair")
    labels = labels_for(data, args.candidate.with_suffix(".composed.s"), [*bottom_labels(data), *FRAME_LABELS])
    version = release_version(data)
    fractional_frames = fractional_frame_round_trip(data, labels) if version in ("1.78R14", "1.78R15", "1.78R16", "1.78R25", "1.78R26", "1.78R27", "1.78R28", "1.78R29", "1.78R30", "1.78R31", "1.78R32", "1.78R33", "1.78R34", "1.78R35", "1.78R36", "1.79R1", "1.79R2", "1.79R3", "1.79R4", "1.79R5", "1.8R1", "1.8R2", "1.8R3", "1.8R4", "1.8R5", "1.8R6", "1.8R7", "1.8R8", "1.8R9", "1.8R10", "1.8R11", "1.8R12", "1.8R13", "1.8R14", "1.8R15", "1.8R16", "1.8R17", "1.8R18", "1.8R19", "1.8R19", "1.9.1beta1", "1.9.1beta2", "1.9.1beta3", "1.9.1beta4", "1.9.1beta5", "1.9.1beta6", "1.9.1beta7", "1.9.1beta8", "1.9.1beta9", "1.9.1beta10", "1.9.1beta11", "1.9.1beta12", "1.9.1beta13", "1.9.1beta14", "1.9.1beta15", "1.9.1beta16", "1.9.1beta17", "1.9.1beta18", "1.9.1beta19", "1.9.1beta20", "1.9.1beta21", "1.9.1beta22", "1.9.1beta23", "1.9.1beta24", "1.9.1beta25", "1.9.1beta26", "1.9.5beta1", "1.9.5beta2", "1.9.5beta3", "1.9.5beta4", "1.9.5beta5", "1.9.5beta6", "1.9.5beta7", "1.9.5beta8", "1.9.5beta9", "1.9.6beta1", "1.9.6beta2", "1.9.6beta3", "1.9.6beta4", "1.9.6beta5", "1.9.6beta6", "1.9.6beta7", "1.9.6beta8", "1.9.6beta9", "1.9.7beta1", "1.9.7beta2", "1.9.7beta3") else None
    report = {"passed": True, "sha256": hashlib.sha256(data).hexdigest(),
              "fractional_frame_and_track": fractional_frames,
              "stable_custom_layout": stable_custom_layout(data, labels),
              "settings": settings_yield_before_layout(data, labels),
              "viewport_and_restore": viewport_and_restore(data, labels),
              "maximum_height_clearance": maximum_height_clearance(data, labels)
              if version in ("1.78R15", "1.78R16", "1.78R25", "1.78R26", "1.78R27", "1.78R28", "1.78R29", "1.78R30", "1.78R31", "1.78R32", "1.78R33", "1.78R34", "1.78R35", "1.78R36", "1.79R1", "1.79R2", "1.79R3", "1.79R4", "1.79R5", "1.8R1", "1.8R2", "1.8R3", "1.8R4", "1.8R5", "1.8R6", "1.8R7", "1.8R8", "1.8R9", "1.8R10", "1.8R11", "1.8R12", "1.8R13", "1.8R14", "1.8R15", "1.8R16", "1.8R17", "1.8R18", "1.8R19", "1.8R19", "1.9.1beta1", "1.9.1beta2", "1.9.1beta3", "1.9.1beta4", "1.9.1beta5", "1.9.1beta6", "1.9.1beta7", "1.9.1beta8", "1.9.1beta9", "1.9.1beta10", "1.9.1beta11", "1.9.1beta12", "1.9.1beta13", "1.9.1beta14", "1.9.1beta15", "1.9.1beta16", "1.9.1beta17", "1.9.1beta18", "1.9.1beta19", "1.9.1beta20", "1.9.1beta21", "1.9.1beta22", "1.9.1beta23", "1.9.1beta24", "1.9.1beta25", "1.9.1beta26", "1.9.5beta1", "1.9.5beta2", "1.9.5beta3", "1.9.5beta4", "1.9.5beta5", "1.9.5beta6", "1.9.5beta7", "1.9.5beta8", "1.9.5beta9", "1.9.6beta1", "1.9.6beta2", "1.9.6beta3", "1.9.6beta4", "1.9.6beta5", "1.9.6beta6", "1.9.6beta7", "1.9.6beta8", "1.9.6beta9", "1.9.7beta1", "1.9.7beta2", "1.9.7beta3") else None,
              "scroll_callback": pan_does_not_force_layout(data, labels),
              "layout_direction": layout_direction_change(data, labels),
              "device_tested": False, "pixel_rendering_tested": False,
              "boundary": "Candidate ARM64 adapters; explicit UIKit frame and layout messages"}
    args.report.parent.mkdir(parents=True, exist_ok=True)
    args.report.write_text(json.dumps(report, ensure_ascii=False, indent=2) + "\n")
    print(json.dumps(report, ensure_ascii=False, indent=2))


if __name__ == "__main__":
    main()
