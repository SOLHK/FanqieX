#!/usr/bin/env python3
"""Run core diagnostic routing, export action, worker and main-thread presenter.

No export or completion IMP is replaced. The optional separately linked menu
lookup is a boundary returning its visible submenu; Foundation/UIKit and queue
operations use the existing explicit model. JSON file bytes are real. This does
not establish the live device's reason for a silent tap or render its share sheet.
"""
import argparse
import hashlib
import json
import struct
from pathlib import Path

from arm64 import CPU, require
from execution_audit import directory
from legacy_runtime import Runtime as LegacyRuntime
from test_feed_viewport import labels_for


class Runtime(LegacyRuntime):
    VISIBLE_MENU = 0x33390000

    def __init__(self, data):
        super().__init__(data)
        self.visible_menu = 0
        self.route_lookups = []
        menu = self._class("FQXSettingsMenu", "UITableViewController")
        self._add(self.metaclasses[menu], "visibleControllerForController:", self.VISIBLE_MENU, "@24@0:8@16")

    def responds(self, receiver, name):
        if receiver in self.objects and name in ("navigationController", "topViewController", "anyObject"):
            return name in self.objects[receiver].state or name == "anyObject"
        return super().responds(receiver, name)

    def handle(self, cpu, pc):
        if pc == self.VISIBLE_MENU:
            self.route_lookups.append(cpu.x[2])
            return self.finish(cpu, self.visible_menu)
        if pc - self.slide == 0xa5d4:
            receiver, selector = cpu.x[:2]
            name = self.selector_names.get(selector)
            if receiver in self.objects and name in ("navigationController", "topViewController"):
                return self.finish(cpu, self.objects[receiver].state.get(name, 0))
        return super().handle(cpu, pc)


def exercise(data, labels, hidden_owner, expect_gap=False):
    rt = Runtime(data)
    d = directory(data)
    words = struct.unpack_from("<64I", data, 0x800)
    cpu = CPU(data, rt, ranges=[(d['ratio'], d['code_end']), (0x4338, 0x43fc), (0x4704, 0x48d0),
                               (0x4958, 0x4d78), (0x5168, 0x5204), (0x5688, 0x56c0),
                               (0x5b94, 0x5c24), (0x60b8, 0x62ac), (0x14080, 0x800 + words[61]),
                               (0x6c14, 0x6c4c), (0x6db4, 0x702c), (0x711c, 0x746c)])
    cpu.pointers.update(rt.rebase_pointers)
    rt._class("FanqieAdBlockOptionsController", "UITableViewController")
    owner_class = rt.classes["FanqieAdBlockOptionsController"]
    rt._add(owner_class, "fqab_156_exportDiagnostics:", d["ui_export"], "v24@0:8@16")
    rt._add(owner_class, "fqab_156_presentDiagnostics:", d["ui_present"], "v24@0:8@16")
    owner_view = rt.view("UIView", "legacy source view", (0., 0., 390., 844.), 0 if hidden_owner else rt.ROOT)
    owner = rt.obj("FanqieAdBlockOptionsController", "legacy source controller", view=owner_view,
                   navigationController=0, presentedViewController=0)
    visible_view = rt.view("UIView", "visible diagnostic submenu view", (0., 0., 390., 844.), rt.ROOT)
    visible = rt.obj("FQXSettingsMenu", "diagnostic submenu", view=visible_view, presentedViewController=0)
    nav = rt.obj("UINavigationController", "settings stack", topViewController=visible)
    rt.objects[visible].state["navigationController"] = nav
    rt.visible_menu = visible if hidden_owner else 0
    presenter = visible if hidden_owner else owner
    button = rt.view("UIButton", "export log button", (20., 20., 180., 48.),
                     visible_view if hidden_owner else owner_view, enabled=True)
    router = rt.obj("NSObject", "native settings router")
    weak = rt.obj("NSHashTable", "weak legacy owner", items=[owner])
    rt.associations[(router, labels["LFQH_BottomOptionsOwner178Key"])] = weak

    cpu.run(labels["LFQH_SettingsExport178R13"], router, rt.sel("fqx178_export:"), button)
    require(d["ui_export"] in cpu.executed, "Routing executes the real original diagnostic export action")
    if expect_gap:
        require(not rt.queued_operations and rt.objects[button].state["enabled"],
                "The old owner-only route silently returns at the offscreen view guard")
        return {"hidden_owner": True, "expected_routing_gap_reproduced": True,
                "real_export_handler_executed": True, "queued_export": False}
    require(rt.queued_operations and not rt.objects[button].state["enabled"],
            "The real export action reaches the queue and disables its sender")
    require((presenter, d["ui_sender_key"]) in rt.associations,
            "Export request state belongs to the visible presenter")
    rt.drain_operations(cpu)
    callbacks = [job for job in rt.main_jobs if job[0] == presenter and
                 rt.selector_names[job[1]] == "fqab_156_presentDiagnostics:"]
    require(len(callbacks) == 1, "The worker schedules exactly one real main-thread completion")
    payload = rt.objects[callbacks[0][2]].state["items"]
    require("url" in payload and "error" not in payload, "The worker writes a successful JSON export")
    output = Path(rt.string_value(payload["url"]))
    document = json.loads(output.read_text(encoding="utf-8"))
    require(document["recordCount"] == len(document["entries"]), "Export JSON contains its declared records")
    require(not rt.objects[presenter].state["presentedViewController"], "The worker does not present UIKit")
    rt.flush_main(cpu)
    require(d["ui_present"] in cpu.executed, "The actual main-thread completion runs")
    shared = rt.objects[presenter].state["presentedViewController"]
    require(shared and rt.class_names[rt.objects[shared].cls] == "UIActivityViewController",
            "The actual completion presents the share sheet on the visible controller")
    require(rt.objects[button].state["enabled"] and
            (presenter, d["ui_busy_key"]) not in rt.associations and
            (presenter, d["ui_sender_key"]) not in rt.associations,
            "Completion restores the button and clears busy/sender state")
    if hidden_owner:
        require(not rt.objects[owner].state["presentedViewController"], "The offscreen owner presents nothing")
    anchor = rt.objects[rt.objects[shared].state["popover"]].state
    require(anchor["source_view"] == button and anchor["source_rect"] == (0., 0., 180., 48.),
            "Popover anchors to the real tapped button")
    return {"hidden_owner": hidden_owner, "menu_route_lookups": len(rt.route_lookups),
            "presenter_class": rt.class_names[rt.objects[presenter].cls],
            "real_export_handler_executed": True, "real_worker_and_main_completion_executed": True,
            "json_bytes": output.stat().st_size, "share_sheet_presented": True,
            "button_reenabled": True, "busy_state_cleared": True, "instructions": cpu.steps}


def main():
    parser = argparse.ArgumentParser(description=__doc__)
    parser.add_argument("candidate", type=Path)
    parser.add_argument("--expect-routing-gap", action="store_true")
    parser.add_argument("--report", type=Path, required=True)
    args = parser.parse_args()
    data = args.candidate.read_bytes()
    labels = labels_for(data, args.candidate.with_suffix(".composed.s"),
                        ["LFQH_SettingsExport178R13", "LFQH_BottomOptionsOwner178Key"])
    report = {"passed": True, "sha256": hashlib.sha256(data).hexdigest(),
              "cases": [exercise(data, labels, True, args.expect_routing_gap), exercise(data, labels, False)],
              "runtime_boundaries_modeled": True, "device_tested": False}
    args.report.parent.mkdir(parents=True, exist_ok=True)
    args.report.write_text(json.dumps(report, indent=2) + "\n", encoding="utf-8")
    print(json.dumps(report, indent=2))


if __name__ == "__main__":
    main()
