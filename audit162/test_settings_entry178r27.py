#!/usr/bin/env python3
"""Execute the real settings opener and its owned-root handoff in candidate ARM64.

The separately linked menu implementation is represented by an explicit boundary:
its registered class methods build/return a distinct menu. This test exercises the
core's table/header setup, bridge call, ownership transfers, LUIinstall register
handoff and original UINavigationController presentation; it does not render UIKit
or execute the Objective-C menu body.
"""
import argparse
import hashlib
import json
import struct
from pathlib import Path

from arm64 import CPU, require
from test_feed_viewport import labels_for
from test_page_glass174 import Runtime as PageRuntime, EXTRA


class Runtime(PageRuntime):
    MENU_INSTALL = 0x33370000
    MENU_ROOT = 0x33370008

    def __init__(self, data, available=True, returns_root=True):
        super().__init__(data)
        self.settings_boundary = True
        self.settings_layout_calls = 0
        self.menu_calls = []
        self.menu_roots = {}
        self.returns_root = returns_root
        self.root_arguments = []
        self.presentations = []
        self.table_reads = []
        self.owner_allocations = []
        self.owner = 0
        for name, parent in (("UITableViewController", "UIViewController"),
                             ("UINavigationController", "UIViewController"),
                             ("UINavigationItem", "NSObject"), ("UIBarButtonItem", "NSObject"),
                             ("UISearchBar", "UIView"), ("NSCharacterSet", "NSObject")):
            if name not in self.classes:
                self._class(name, parent)
        if available:
            cls = self._class("FQXSettingsMenu", "UITableViewController")
            self._add(self.metaclasses[cls], "installOnController:router:ads:", self.MENU_INSTALL,
                      "v40@0:8@16@24@32")
            self._add(self.metaclasses[cls], "controllerForController:", self.MENU_ROOT, "@24@0:8@16")

    def responds(self, receiver, name):
        if receiver in self.objects and name in ("tableView", "tableHeaderView", "tableFooterView"):
            return name in self.objects[receiver].state
        return super().responds(receiver, name)

    def handle(self, cpu, pc):
        receiver, selector = cpu.x[:2]
        name = self.selector_names.get(selector)
        if pc == self.MENU_INSTALL:
            owner, router, ads = cpu.x[2:5]
            table = self.objects[owner].state["tableView"]
            state = self.objects[table].state
            require(state.get("tableHeaderView") and state.get("tableFooterView"),
                    "The real core builds both legacy panels before invoking the menu bridge")
            require(router and ads and ads != owner, "Menu receives its router and separate native-ad owner")
            root = self.obj("FQXSettingsMenu", "independent settings root", settingsOwner=owner,
                            navigationItem=self.obj("UINavigationItem", "menu navigation"),
                            presentedViewController=0)
            # The menu is retained by the associated owner and holds its sources.
            # Caller +1 is separately tracked by explicit retain/release messages.
            self.menu_roots[owner] = root
            self.menu_calls.append((owner, router, ads))
            return self.finish(cpu)
        if pc == self.MENU_ROOT:
            return self.finish(cpu, self.menu_roots.get(cpu.x[2], 0) if self.returns_root else 0)
        if pc - self.slide == 0xa5d4:
            if receiver in self.metaclasses and name == "alloc":
                cls = self.class_names[receiver]
                if cls == "FanqieAdBlockOptionsController":
                    table = self.view("UITableView", "native options table", (0., 0., 390., 844.),
                                      tableHeaderView=0, tableFooterView=0)
                    value = self.obj(cls, "native options controller", tableView=table, view=table,
                                     navigationItem=self.obj("UINavigationItem", "options navigation"),
                                     presentedViewController=0)
                    self.retain_balance[value] = 1
                    self.owner_allocations.append(value)
                    if not self.owner:
                        self.owner = value
                    return self.finish(cpu, value)
            if receiver in self.objects:
                state = self.objects[receiver].state
                if name == "tableView" and "tableView" in state:
                    self.table_reads.append(receiver)
                    return self.finish(cpu, state["tableView"])
                if name == "initWithRootViewController:":
                    root = cpu.x[2]
                    state["rootViewController"] = root
                    self.root_arguments.append(root)
                    return self.finish(cpu, receiver)
                if name == "presentViewController:animated:completion:":
                    require(cpu.x[3] == 1 and cpu.x[4] == 0,
                            "Original presentation keeps animated YES and nil completion")
                    state["presentedViewController"] = cpu.x[2]
                    self.presentations.append(cpu.x[2])
                    return self.finish(cpu)
        return super().handle(cpu, pc)


def exercise(data, labels, available=True, returns_root=True):
    runtime = Runtime(data, available, returns_root)
    runtime.labels = labels
    words = struct.unpack_from("<64I", data, 0x800)
    cpu = CPU(data, runtime, 0, ranges=[(0x800, 0x4000), (0x4338, 0x43fc), (0x4704, 0x48d0),
                                       (0x4958, 0x4d78), (0x5168, 0x5204),
                                       (0x14080, 0x800 + words[61])])
    cpu.pointers.update(runtime.rebase_pointers)
    host = runtime.obj("UIViewController", "host settings page", presentedViewController=0)
    preserved = {index: cpu.x[index] for index in range(19, 29)}
    original_sp = cpu.sp
    cpu.run(0x4958, host)
    require(0x4cbc in cpu.executed, "The full original opener reaches its injected install call")
    require(runtime.owner in runtime.table_reads, "The actual core reads the real owner table")
    require(len(runtime.presentations) == len(runtime.root_arguments) == 1,
            "The original opener presents exactly one navigation controller")
    expected = runtime.menu_roots[runtime.owner] if available and returns_root else runtime.owner
    require(runtime.root_arguments[0] == expected,
            "The original navigation initializer receives the independent settings menu root")
    require(runtime.retain_balance.get(runtime.owner, 0) == 0,
            "The original controller allocation is released exactly once")
    if available and returns_root:
        require(runtime.retain_balance.get(expected, 0) == 0,
                "The bridged menu root is retained once and released by the original caller")
    require(cpu.sp == original_sp and all(cpu.x[index] == value for index, value in preserved.items()),
            "The complete opener restores its caller stack and callee-saved registers")
    return {"bridge_available": available, "bridge_returns_root": returns_root,
            "root_class": runtime.class_names[runtime.objects[expected].cls],
            "table_reads": len(runtime.table_reads), "bridge_calls": len(runtime.menu_calls),
            "balanced_root_handoff": True, "caller_registers_preserved": True}


def main():
    parser = argparse.ArgumentParser(description=__doc__)
    parser.add_argument("candidate", type=Path)
    parser.add_argument("--report", type=Path, required=True)
    args = parser.parse_args()
    data = args.candidate.read_bytes()
    labels = labels_for(data, args.candidate.with_suffix(".composed.s"), EXTRA)
    report = {"passed": True, "sha256": hashlib.sha256(data).hexdigest(),
              "cases": [exercise(data, labels), exercise(data, labels, available=False),
                        exercise(data, labels, returns_root=False)],
              "native_menu_body_executed": False, "device_tested": False}
    args.report.write_text(json.dumps(report, indent=2) + "\n", encoding="utf-8")
    print(json.dumps(report, indent=2))


if __name__ == "__main__":
    main()
