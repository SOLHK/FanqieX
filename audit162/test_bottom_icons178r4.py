#!/usr/bin/env python3
"""Exercise larger dock symbols in the emitted ARM64 on UIKit boundaries.

Check the visible symbol containers, both navigation renderers, saved user
preferences and compact layout. The fixture is not an SF Symbols renderer;
optical glyph shape, GPU glass composition and touch feel need device review.
"""
from __future__ import annotations

import argparse
import hashlib
import json
from pathlib import Path

from arm64 import release_version, require
from test_bottom_appearance178 import (
    COMPACT, ICONS, ICON_SIZE, PAGE_HOOK, bottom_labels, call, check_input,
    compact_button, fixture, host_geometry, overlay_image, overlays, page_drag,
    repair, send_pan, tap_expand,
)
from test_feed_viewport import labels_for


def check_symbols(runtime, expected):
    frames = []
    for button in runtime.buttons:
        image = overlay_image(runtime, button)
        symbol = overlays(runtime, button)[0]
        state = runtime.objects[symbol].state
        rect = state["frame"]
        bounds = runtime.objects[button].state["bounds"]
        require(rect[2:] == (expected, expected),
                "Visible icon container uses the requested point size")
        require(abs(rect[0] + rect[2] / 2 - bounds[0] - bounds[2] / 2) < 0.001 and
                abs(rect[1] + rect[3] / 2 - bounds[1] - bounds[3] / 2) < 0.001,
                "A larger symbol remains centered inside its own navigation target")
        require(rect[0] >= bounds[0] and rect[1] >= bounds[1] and
                rect[0] + rect[2] <= bounds[0] + bounds[2] and
                rect[1] + rect[3] <= bounds[1] + bounds[3],
                "Larger icons stay inside their target even when the dock compacts")
        require(state.get("contentMode") == 1,
                "Symbols retain aspect fit instead of distortion or clipping")
        configuration = runtime.objects[image["configuration"]].state
        require(configuration["pointSize"] == expected,
                "The system-symbol configuration grows with its visible container")
        require(bounds[2] >= 44 and bounds[3] >= 44,
                "Changing artwork size preserves the existing minimum tap target")
        frames.append(list(rect))
    return frames


def default_and_saved_sizes(data, labels):
    cases = []
    for fallback in (False, True):
        for saved, expected in ((None, 28), (20, 20), (22, 22), (32, 32),
                                (1000, 32), (float("nan"), 28)):
            cpu, runtime, entries = fixture(data, labels, selected=1, fallback=fallback)
            runtime.defaults(**{ICONS: True})
            if saved is not None:
                runtime.defaults(**{ICON_SIZE: saved})
            original = host_geometry(runtime)
            repair(cpu, runtime, entries)
            frames = check_symbols(runtime, expected)
            owned = [overlays(runtime, button)[0] for button in runtime.buttons]
            for _ in range(4):
                repair(cpu, runtime, entries)
                require(check_symbols(runtime, expected) == frames,
                        "Repeated layout does not accumulate symbol growth or movement")
            require(owned == [overlays(runtime, button)[0] for button in runtime.buttons],
                    "Stable larger symbols reuse their existing image views")
            # Real routing entry points execute in the candidate; the fixture
            # only exposes the original host selection boundary.
            for selected in (0, 3, 1):
                check_input(runtime, cpu, fallback, selected)
                repair(cpu, runtime, entries)
                check_symbols(runtime, expected)
            require(host_geometry(runtime) == original,
                    "Larger artwork does not resize the host bar, page or scroll view")
            cases.append({"renderer": "fallback" if fallback else "native",
                          "saved_size": "unset" if saved is None else str(saved),
                          "visible_points": expected, "centered_and_reused": True,
                          "selection_routes": runtime.route_calls})
    return cases


def compact_centering(data, labels):
    cases = []
    for fallback in (False, True):
        for size in (28, 32):
            cpu, runtime, entries = fixture(data, labels, selected=1, fallback=fallback)
            feed, pan, _ = runtime.add_feed()
            runtime.defaults(**{ICONS: True, COMPACT: True, ICON_SIZE: size})
            original = host_geometry(runtime, (feed,))
            repair(cpu, runtime, entries)
            expanded = runtime.objects[runtime.PROXY].state["frame"]
            expanded_symbols = check_symbols(runtime, size)
            is_r7 = PAGE_HOOK in labels
            if is_r7:
                page_drag(cpu, runtime, feed, 1, 2)
            else:
                send_pan(cpu, runtime, pan, 1)
                send_pan(cpu, runtime, pan, 2, (0., -48.))
            repair(cpu, runtime, entries)
            compact = runtime.objects[runtime.PROXY].state["frame"]
            if is_r7:
                button = compact_button(runtime)
                require(compact[2:] == (60., 60.) and button and
                        runtime.objects[button].state["frame"] == compact,
                        "The compact circle has one full-sized input for either saved expanded glyph size")
                for _ in range(3):
                    repair(cpu, runtime, entries)
                    require(compact_button(runtime) == button, "The compact symbol remains stable")
                tap_expand(cpu, runtime)
            else:
                require(compact[2] < expanded[2] and compact[3] < expanded[3],
                        "This case actually reaches the smaller drama dock")
                compact_symbols = check_symbols(runtime, size)
                for _ in range(3):
                    repair(cpu, runtime, entries)
                    require(check_symbols(runtime, size) == compact_symbols,
                            "Compact re-layout keeps larger icons centered without drift")
                send_pan(cpu, runtime, pan, 2, (0., -15.))
            repair(cpu, runtime, entries)
            require(runtime.objects[runtime.PROXY].state["frame"] == expanded and
                    check_symbols(runtime, size) == expanded_symbols,
                    "Expanding the dock restores the original icon centers")
            require(host_geometry(runtime, (feed,)) == original,
                    "Artwork resizing leaves video geometry and the host pan untouched")
            cases.append({"renderer": "fallback" if fallback else "native",
                          "points": size, "expanded": list(expanded),
                          "compact": list(compact), "restored": True})
    return cases


def setting_limit_and_reset(data, labels):
    cpu, runtime, entries = fixture(data, labels)
    runtime.defaults(**{ICONS: True})
    repair(cpu, runtime, entries)
    owner = runtime.obj("NSObject", "settings owner")
    slider = runtime.view("UISlider", "icon size", tag=14, value=1000.)
    call(cpu, labels, "FQHBottomOptionChanged178", owner,
         runtime.sel("fqx178_bottomOptionChanged:"), slider)
    values = runtime.objects[runtime.DEFAULTS].state["values"]
    require(values[ICON_SIZE] == 32, "The settings callback persists the new 32pt upper limit")
    repair(cpu, runtime, entries)
    check_symbols(runtime, 32)
    call(cpu, labels, "FQHBottomOptionsReset178", owner, runtime.sel("fqx178_resetBottom:"), 0)
    require(ICON_SIZE not in values, "Reset removes the stored icon size")
    runtime.defaults(**{ICONS: True})
    repair(cpu, runtime, entries)
    check_symbols(runtime, 28)
    return {"upper_limit": 32, "default_after_reset": 28}


def main():
    parser = argparse.ArgumentParser(description=__doc__)
    parser.add_argument("candidate", type=Path)
    parser.add_argument("--report", type=Path, required=True)
    args = parser.parse_args()
    data = args.candidate.read_bytes()
    require(release_version(data) in ("1.78R4", "1.78R5", "1.78R6", "1.78R7", "1.78R8", "1.78R9", "1.78R10", "1.78R11", "1.78R12", "1.78R13", "1.78R14", "1.78R15", "1.78R16", "1.78R25", "1.78R26", "1.78R27", "1.78R28", "1.78R29", "1.78R30", "1.78R31", "1.78R32", "1.78R33", "1.78R34", "1.78R35", "1.78R36", "1.79R1", "1.79R2", "1.79R3", "1.79R4", "1.79R5", "1.8R1", "1.8R2", "1.8R3", "1.8R4", "1.8R5", "1.8R6", "1.8R7", "1.8R8", "1.8R9", "1.8R10"), "This regression targets the R4 symbol sizes")
    labels = labels_for(data, args.candidate.with_suffix(".composed.s"), bottom_labels(data))
    report = {"passed": True, "sha256": hashlib.sha256(data).hexdigest(),
              "sizes": default_and_saved_sizes(data, labels),
              "compact": compact_centering(data, labels),
              "settings": setting_limit_and_reset(data, labels),
              "device_tested": False, "pixel_rendering_tested": False,
              "boundary": "Candidate ARM64; explicit Foundation/UIKit fixtures"}
    args.report.parent.mkdir(parents=True, exist_ok=True)
    args.report.write_text(json.dumps(report, ensure_ascii=False, indent=2) + "\n")
    print(json.dumps(report, ensure_ascii=False, indent=2))


if __name__ == "__main__":
    main()
