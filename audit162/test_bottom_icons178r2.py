#!/usr/bin/env python3
"""Exercise late UIButton layout/content refreshes in the candidate ARM64.

UIKit is an explicit message boundary. This validates persisted content states,
selection/a11y ownership and restoration, not native pixels on an iPhone.
"""
from __future__ import annotations

import argparse
import hashlib
import json
from pathlib import Path

from arm64 import release_version, require
from test_feed_viewport import labels_for
from test_bottom_appearance178 import (
    ICONS, Runtime, bottom_labels, button_contents, call, check_input, fixture,
    overlay_image, overlays, repair,
)


def assert_captionless(runtime):
    for button in runtime.buttons:
        if not overlays(runtime, button):
            continue
        state = runtime.objects[button].state
        # UIKit can independently reveal its titleLabel after the bar's final
        # layout. No setter/repair is invoked here: persistent content itself
        # must prevent a caption in every selected/highlighted/focused state.
        runtime.objects[state["titleLabel"]].state.update(hidden=False, alpha=1.0)
        for control_state in range(16):
            require(runtime.string_value(state["titles"].get(control_state, 0)) == "",
                    "A late UIButton label reveal cannot expose a plain caption")
            require(not state["attributedTitles"].get(control_state),
                    "A late UIButton label reveal cannot expose an attributed caption")
        overlay_image(runtime, button)
    control = runtime.control()
    if control:
        attributes = runtime.objects[control].state["titleTextAttributes"]
        require(all(attributes[state]["NSColor"] == runtime.color("clearColor")
                    for state in range(16)),
                "Native captions are transparent in all sixteen control states")


def late_layout_and_restore(data, labels):
    cases = []
    for fallback in (False, True):
        cpu, runtime, entries = fixture(data, labels, fallback=fallback)
        if "NSAttributedString" not in runtime.classes:
            runtime._class("NSAttributedString", "NSObject")
        button = runtime.buttons[0]
        state = runtime.objects[button].state
        for control_state in (1, 2, 4, 8, 15):
            state["titles"][control_state] = runtime.text_object("alternate-" + str(control_state))
        attributed = runtime.obj("NSAttributedString", "selected caption", value="selected-caption")
        state["attributedTitles"][5] = attributed
        original = button_contents(runtime)
        runtime.defaults(**{ICONS: True})
        repair(cpu, runtime, entries)
        control = runtime.control()
        assert_captionless(runtime)
        content_write_count = len(runtime.content_writes)
        for _ in range(3):
            repair(cpu, runtime, entries)
            assert_captionless(runtime)
        require(len(runtime.content_writes) == content_write_count,
                "Settled layouts do not toggle title states or invalidate button intrinsic sizes")
        if control:
            native = runtime.objects[control].state
            extra = runtime.text_object("host font attribute")
            native["titleTextAttributes"][4] = {"NSColor": runtime.color("labelColor"), "NSFont": extra}
            repair(cpu, runtime, entries)
            require(runtime.control() == control, "Appearance refresh reuses the native control")
            assert_captionless(runtime)
            require(native["titleTextAttributes"][4]["NSFont"] == extra,
                    "Caption suppression preserves unrelated native title attributes")
            require([runtime.string_value(x) for x in native["segments"]] == ["书城", "短剧", "书架", "我的"],
                    "Segment titles remain available for VoiceOver")
        check_input(runtime, cpu, fallback, 2)
        repair(cpu, runtime, entries)
        assert_captionless(runtime)
        runtime.defaults(**{ICONS: False})
        repair(cpu, runtime, entries)
        require(button_contents(runtime) == original,
                "Disabling icons restores every plain and attributed title state")
        require(not any(overlays(runtime, b) for b in runtime.buttons), "Disable removes all owned symbol views")
        cases.append({"renderer": "native" if control else "buttons", "late_layout_captionless": True,
                      "all_title_states_restored": True, "route_calls": runtime.route_calls})
    return cases


def host_updates_and_native_fallback(data, labels):
    cases = []
    for fallback in (False, True):
        cpu, runtime, entries = fixture(data, labels, fallback=fallback)
        runtime.defaults(**{ICONS: True})
        repair(cpu, runtime, entries)
        # A later authoritative host sync may replace titles while icons are
        # active; that newer content must be the value restored on disable.
        button = runtime.buttons[0]
        replacement = runtime.text_object("首页")
        state = runtime.objects[button].state
        state["titles"][0] = state["title"] = replacement
        runtime.objects[runtime.items[0]].state["title"] = replacement
        repair(cpu, runtime, entries)
        assert_captionless(runtime)
        # If the item model temporarily omits its title, the native renderer
        # still obtains the actual original button caption during Prepare.
        runtime.objects[runtime.items[0]].state["title"] = 0
        repair(cpu, runtime, entries)
        assert_captionless(runtime)
        control = runtime.control()
        if not fallback and release_version(data) not in ('1.78R14', '1.78R15', '1.78R16', '1.78R25', "1.78R26", "1.78R27", "1.78R28", "1.78R29", "1.78R30", "1.78R31", "1.78R32", "1.78R33", "1.78R34", "1.78R35", "1.78R36", "1.79R1", "1.79R2", "1.79R3", "1.79R4", "1.79R5", "1.8R1", "1.8R2", "1.8R3", "1.8R4", "1.8R5", "1.8R6", "1.8R7", "1.8R8", "1.8R9", "1.8R10", "1.8R11", "1.8R12", "1.8R13", "1.8R14", "1.8R15", "1.8R16", "1.8R17", "1.8R18", "1.8R19", "1.8R19", "1.9.1beta1", "1.9.1beta2", "1.9.1beta3", "1.9.1beta4", "1.9.1beta5", "1.9.1beta6", "1.9.1beta7", "1.9.1beta8", "1.9.1beta9", "1.9.1beta10", "1.9.1beta11", "1.9.1beta12", "1.9.1beta13", "1.9.1beta14", "1.9.1beta15", "1.9.1beta16", "1.9.1beta17", "1.9.1beta18", "1.9.1beta19", "1.9.1beta20", "1.9.1beta21", "1.9.1beta22", "1.9.1beta23", "1.9.1beta24", "1.9.1beta25", "1.9.1beta26", "1.9.5beta1", "1.9.5beta2", "1.9.5beta3", "1.9.5beta4", "1.9.5beta5", "1.9.5beta6", "1.9.5beta7", "1.9.5beta8", "1.9.5beta9", "1.9.6beta1", "1.9.6beta2", "1.9.6beta3", "1.9.6beta4", "1.9.6beta5", "1.9.6beta6", "1.9.6beta7", "1.9.6beta8", "1.9.6beta9", "1.9.7beta1"):
            require(control and runtime.string_value(runtime.objects[control].state["segments"][0]) == "首页",
                    "Suppression cannot invalidate native segment construction when an item title is missing")
        else:
            require(overlay_image(runtime, button) and runtime.objects[button].state['userInteractionEnabled'],
                    "An item temporarily missing its title keeps its icon and button input")
        runtime.defaults(**{ICONS: False})
        repair(cpu, runtime, entries)
        require(runtime.objects[button].state["titles"][0] == replacement,
                "Disable restores the latest host title rather than the stale snapshot")
        cases.append({"renderer": "native" if control else "buttons", "latest_host_title_preserved": True,
                      "missing_item_title_supported": True})
    return cases


def renderer_transition(data, labels):
    cpu, runtime, entries = fixture(data, labels, fallback=True)
    original = button_contents(runtime)
    runtime.defaults(**{ICONS: True})
    repair(cpu, runtime, entries)
    assert_captionless(runtime)
    if release_version(data) in ('1.78R14', '1.78R15', '1.78R16', '1.78R25', "1.78R26", "1.78R27", "1.78R28", "1.78R29", "1.78R30", "1.78R31", "1.78R32", "1.78R33", "1.78R34", "1.78R35", "1.78R36", "1.79R1", "1.79R2", "1.79R3", "1.79R4", "1.79R5", "1.8R1", "1.8R2", "1.8R3", "1.8R4", "1.8R5", "1.8R6", "1.8R7", "1.8R8", "1.8R9", "1.8R10", "1.8R11", "1.8R12", "1.8R13", "1.8R14", "1.8R15", "1.8R16", "1.8R17", "1.8R18", "1.8R19", "1.8R19", "1.9.1beta1", "1.9.1beta2", "1.9.1beta3", "1.9.1beta4", "1.9.1beta5", "1.9.1beta6", "1.9.1beta7", "1.9.1beta8", "1.9.1beta9", "1.9.1beta10", "1.9.1beta11", "1.9.1beta12", "1.9.1beta13", "1.9.1beta14", "1.9.1beta15", "1.9.1beta16", "1.9.1beta17", "1.9.1beta18", "1.9.1beta19", "1.9.1beta20", "1.9.1beta21", "1.9.1beta22", "1.9.1beta23", "1.9.1beta24", "1.9.1beta25", "1.9.1beta26", "1.9.5beta1", "1.9.5beta2", "1.9.5beta3", "1.9.5beta4", "1.9.5beta5", "1.9.5beta6", "1.9.5beta7", "1.9.5beta8", "1.9.5beta9", "1.9.6beta1", "1.9.6beta2", "1.9.6beta3", "1.9.6beta4", "1.9.6beta5", "1.9.6beta6", "1.9.6beta7", "1.9.6beta8", "1.9.6beta9", "1.9.7beta1"):
        pan = runtime.associated(runtime.PROXY, 'pan')
        require(pan and not runtime.control(), 'Icon mode mounts the drag renderer')
        runtime.missing_classes.remove("UISegmentedControl")
        repair(cpu, runtime, entries)
        require(runtime.associated(runtime.PROXY, 'pan') == pan and not runtime.control(),
                'Availability of UISegmentedControl does not replace the active drag renderer')
        assert_captionless(runtime)
        runtime.defaults(**{ICONS: False})
        repair(cpu, runtime, entries)
        require(button_contents(runtime) == original, 'Icon mode restores all original titles')
        return {"stable_drag_renderer": True, "restored": True}
    runtime.missing_classes.remove("UISegmentedControl")
    repair(cpu, runtime, entries)
    require(bool(runtime.control()), "Fallback can become a native selector while icon mode stays enabled")
    assert_captionless(runtime)
    runtime.missing_classes.add("UISegmentedControl")
    repair(cpu, runtime, entries)
    require(not runtime.control(), "Native selector can fall back without exposing duplicate content")
    assert_captionless(runtime)
    runtime.defaults(**{ICONS: False})
    repair(cpu, runtime, entries)
    require(button_contents(runtime) == original, "Renderer transitions preserve all original titles")
    return {"buttons_to_native_to_buttons": True, "restored": True}


def tab_replacement(data, labels):
    cpu, runtime, entries = fixture(data, labels)
    removed = runtime.buttons[-1]
    original = button_contents(runtime)[removed]
    runtime.defaults(**{ICONS: True})
    repair(cpu, runtime, entries)
    runtime.configure_tabs(("书城", "书架", "我的"), selected=1)
    repair(cpu, runtime, entries)
    assert_captionless(runtime)
    require(not overlays(runtime, removed), "An orphaned tab button loses its owned icon overlay")
    state = runtime.objects[removed].state
    require(all(state.get(key) == value for key, value in original.items()),
            "Replacing the tab plan restores the removed button's original titles and routes")
    runtime.defaults(**{ICONS: False})
    repair(cpu, runtime, entries)
    require([runtime.string_value(runtime.objects[b].state["titles"][0]) for b in runtime.buttons] ==
            ["书城", "书架", "我的"], "The new tab plan retains its own captions on disable")
    return {"removed_button_restored": True, "new_plan_captions_preserved": True}


def main():
    parser = argparse.ArgumentParser(description=__doc__)
    parser.add_argument("candidate", type=Path)
    parser.add_argument("--report", type=Path, required=True)
    args = parser.parse_args()
    data = args.candidate.read_bytes()
    labels = labels_for(data, args.candidate.with_suffix(".composed.s"), bottom_labels(data))
    report = {"passed": True, "sha256": hashlib.sha256(data).hexdigest(),
              "late_layout": late_layout_and_restore(data, labels),
              "host_updates": host_updates_and_native_fallback(data, labels),
              "renderer_transition": renderer_transition(data, labels),
              "tab_replacement": tab_replacement(data, labels),
              "device_tested": False, "pixel_rendering_tested": False,
              "boundary": "Candidate ARM64; explicit Foundation/UIKit fixtures"}
    args.report.parent.mkdir(parents=True, exist_ok=True)
    args.report.write_text(json.dumps(report, ensure_ascii=False, indent=2) + "\n")
    print(json.dumps(report, ensure_ascii=False, indent=2))


if __name__ == "__main__":
    main()
