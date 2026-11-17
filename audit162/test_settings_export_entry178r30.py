#!/usr/bin/env python3
"""Run _open_menu registration and its actual created diagnostic export action.

The owner class and both export methods are created only by the original opener
and LUIinstall/LUIadd_method instructions. No export/present methods are preseeded.
The separate menu UI factory remains an explicit boundary; the original footer
button/router are obtained from the real core-generated controls. Foundation and
UIKit use the existing model; this is not a device-acceptance test.
"""
import argparse
import hashlib
import json
import struct
from pathlib import Path

from arm64 import CPU, require
from execution_audit import directory
from test_settings_entry178r27 import Runtime as EntryRuntime, labels_for, EXTRA
from test_settings_action_dispatch178r29 import Runtime as ActionRuntime, HeapCPU


class CaptureCPU(HeapCPU):
    def geometry_simd(self, op):
        if op & 0xffeffc00 == 0x4e081c00:  # INS Vd.D[lane], Xn
            target, source, lane = op & 31, (op >> 5) & 31, (op >> 20) & 1
            mask = ((1 << 64) - 1) << (lane * 64)
            self.v[target] = (self.v[target] & ~mask) | (self.x[source] << (lane * 64))
            return True
        return super().geometry_simd(op)


class CaptureRuntime(ActionRuntime):
    def __init__(self, data, forward, dismissed):
        super().__init__(data)
        self.forward = forward
        self.dismissed = dismissed

    def handle(self, cpu, pc):
        symbol, args = self.symbols.get(pc), cpu.x[:8]
        if symbol == "_CGRectGetWidth":
            cpu.wf(0, cpu.fp(2))
            return self.finish(cpu)
        if symbol == "_objc_alloc":
            return self.finish(cpu, self.obj(self.symbols[args[0]].split("$_")[1]))
        if symbol == "_objc_msgSend":
            obj, name = self.objects.get(args[0]), self.string(args[1])
            class_symbol = self.symbols.get(args[0], "")
            if class_symbol.startswith("_OBJC_CLASS_$_"):
                if name == "weakObjectsHashTable":
                    return self.finish(cpu, self.obj("NSHashTable", []))
                if name == "dictionaryWithObjects:forKeys:count:":
                    values = {self.value(cpu.read(args[3] + i * 8, 8)): cpu.read(args[2] + i * 8, 8)
                              for i in range(args[4])}
                    return self.finish(cpu, self.obj("NSDictionary", values))
            if obj:
                if name == "dismissViewControllerAnimated:completion:":
                    self.dismissals += 1
                    # Model UIKit's actual presenter/child relation. A stale
                    # presenting getter alone does not promise a completion.
                    presenter = obj.get("presentingViewController", 0) if obj["class"] == "UISearchController" else args[0]
                    parent = self.objects.get(presenter, {})
                    child = parent.get("presentedViewController", 0)
                    if child and self.objects[child]["class"] == "UISearchController":
                        parent["presentedViewController"] = 0
                        self.objects[child].update(isActive=0, presentingViewController=0)
                        self.dismissed()
                        self.invoke_block(cpu, args[3], 0, 0)
                    return self.finish(cpu)
                if obj["class"] == "Router" and name in obj["selectors"]:
                    self.forward()
                    self.actions.append((name, args[2]))
                    return self.finish(cpu)
                if name == "initWithStyle:reuseIdentifier:":
                    obj.update(contentView=self.obj("UIView"), textLabel=self.obj("UILabel"))
                    return self.finish(cpu, args[0])
                if name in ("setSelectionStyle:", "setNumberOfLines:", "setHidden:", "setFrame:",
                            "setAutoresizingMask:", "addSubview:"):
                    return self.finish(cpu)
                if name == "bounds":
                    for index, value in enumerate((0., 0., 350., 52.)):
                        cpu.wf(index, value)
                    return self.finish(cpu)
                if name == "allTargets":
                    return self.finish(cpu, self.obj("NSSet", list(dict.fromkeys(target[0] for target in obj["targets"]))))
                if name == "actionsForTarget:forControlEvent:":
                    return self.finish(cpu, self.obj("NSArray", [self.obj("NSString", action)
                        for target, action, event in obj["targets"] if target == args[2] and event == args[3]]))
                if name == "removeTarget:action:forControlEvents:":
                    action = self.string(args[3])
                    obj["targets"] = [(target, name, event) for target, name, event in obj["targets"]
                                      if not ((not args[2] or target == args[2]) and name == action and event == args[4])]
                    return self.finish(cpu)
                if name == "addTarget:action:forControlEvents:":
                    obj["targets"].append((args[2], self.string(args[3]), args[4]))
                    return self.finish(cpu)
        return super().handle(cpu, pc)


def capture_and_forward(merged, action_name, events, forward, dismissed, presented_search, active):
    rt = CaptureRuntime(merged, forward, dismissed)
    cpu = CaptureCPU(merged, rt, ranges=rt.ranges)
    cpu.pointers.update(rt.pointers)

    def instance(name):
        value = rt.obj(name)
        for offset in rt.classes[name]["ivars"].values():
            cpu.write(value + offset, 8, 0)
        return value

    menu, row = instance("FQXSettingsMenu"), instance("FQXSettingRow")
    router = rt.obj("Router", selectors={action_name})
    button = rt.obj("UIButton", targets=[(router, action_name, events)], subviews=rt.obj("NSArray", []))
    search = rt.obj("UISearchController", isActive=int(active),
                    presentingViewController=menu,
                    searchBar=rt.obj("UISearchBar", text=rt.obj("NSString", "")))
    rt.objects[menu]["presentedViewController"] = search if presented_search else 0
    for key, value in {"_catalog": rt.obj("NSArray", [row]), "_visibleRows": rt.obj("NSArray", [row]),
                       "_folders": rt.obj("NSArray", []), "_search": search, "_router": router}.items():
        cpu.write(menu + rt.classes["FQXSettingsMenu"]["ivars"][key], 8, value)
    for key, value in {"_content": button, "_height": 0x404a000000000000}.items():
        cpu.write(row + rt.classes["FQXSettingRow"]["ivars"][key], 8, value)
    selector, imp = rt.classes["FQXSettingsMenu"]["methods"]["tableView:cellForRowAtIndexPath:"]
    cpu.run(imp, args=[menu, selector, rt.obj("UITableView"), rt.obj("NSIndexPath", row=0)])
    actions = rt.value(cpu.read(row + rt.classes["FQXSettingRow"]["ivars"]["_actions"], 8))
    require(len(actions) == 1 and rt.objects[button]["targets"] == [(menu, "performStoredAction:", events)],
            "The actual linked cell method captures the core-produced action and installs one menu target")
    selector, imp = rt.classes["FQXSettingsMenu"]["methods"]["performStoredAction:"]
    cpu.run(imp, menu, selector, button)
    require(len(rt.actions) == 1, "The actual linked dispatcher forwards the captured core action once")
    return {"original_actions_captured": len(actions), "dispatches": len(rt.actions),
            "search_dismissals": rt.dismissals,
            "native_menu_instructions": len(cpu.executed | rt.executed)}


class Runtime(EntryRuntime):
    VISIBLE_MENU = 0x333a0000

    def __init__(self, data):
        super().__init__(data)
        self.visible_menu = 0
        self._add(self.metaclasses[self.classes["FQXSettingsMenu"]], "visibleControllerForController:",
                  self.VISIBLE_MENU, "@24@0:8@16")

    def handle(self, cpu, pc):
        if pc == self.VISIBLE_MENU:
            return self.finish(cpu, self.visible_menu)
        return super().handle(cpu, pc)


def exercise(data, labels, merged, presented_search=False, active=False, expect_gap=False):
    rt = Runtime(data)
    rt.labels = labels
    d = directory(data)
    words = struct.unpack_from("<64I", data, 0x800)
    cpu = CPU(data, rt, ranges=[(0x800, 0x4000), (0x4338, 0x43fc), (0x4704, 0x48d0),
                               (0x4958, 0x4d78), (0x5168, 0x5204), (0x5688, 0x56c0),
                               (0x5b94, 0x5c24), (0x60b8, 0x62ac), (0x14080, 0x800 + words[61]),
                               (0x6c14, 0x6c4c), (0x6db4, 0x702c), (0x711c, 0x746c)])
    cpu.pointers.update(rt.rebase_pointers)
    host = rt.obj("UIViewController", "host settings", presentedViewController=0)
    require("FanqieAdBlockOptionsController" not in rt.classes, "The native options class starts absent")
    cpu.run(0x4958, host)
    owner = rt.owner
    owner_cls = rt.objects[owner].cls
    installed = {}
    for selector, expected in (("fqab_156_exportDiagnostics:", d["ui_export"]),
                               ("fqab_156_presentDiagnostics:", d["ui_present"])):
        method = rt.get_method(owner_cls, rt.sel(selector))
        require(method and rt.methods[method]["imp"] == expected and
                rt.methods[method]["encoding"] == "v24@0:8@16",
                "Actual LUIinstall registers the exact export/completion IMP and ABI")
        installed[selector] = hex(expected)
    require(0x4cbc in cpu.executed and d["ui_install"] in cpu.executed,
            "The whole original opener reaches its real install trampoline")
    table = rt.objects[owner].state["tableView"]
    footer = rt.objects[table].state["tableFooterView"]

    def descendants(view):
        for child in rt.objects[view].state.get("subviews", []):
            yield child
            yield from descendants(child)

    button = next(child for child in descendants(footer)
                  if rt.string_value(rt.objects[child].state.get("accessibilityLabel", 0)) == "导出日志")
    targets = rt.objects[button].state["control_targets"]
    require(len(targets) == 1 and rt.selector_names[targets[0][1]] == "fqx178_export:",
            "The real footer button contains its actual native router action")
    router, action, events = targets[0]
    require(events == 64, "The real action is registered for touch-up-inside")
    view = rt.view("UIView", "visible diagnostics page", (0., 0., 390., 844.), rt.ROOT)
    visible = rt.obj("FQXSettingsMenu", "visible diagnostics submenu", view=view, presentedViewController=0)
    rt.visible_menu = visible
    rt.reparent(button, view)
    if presented_search:
        if "UISearchController" not in rt.classes:
            rt._class("UISearchController", "UIViewController")
        search = rt.obj("UISearchController", "attached search", isActive=active, presentingViewController=visible)
        rt.objects[visible].state["presentedViewController"] = search
    dispatch = capture_and_forward(merged, rt.selector_names[action], events,
                                   lambda: rt.invoke(cpu, router, action, button, "main"),
                                   lambda: rt.objects[visible].state.update(presentedViewController=0),
                                   presented_search, active)
    require(d["ui_export"] in cpu.executed, "The actual captured router action reaches LUIexport")
    for selector, expected in (("fqab_156_exportDiagnostics:", d["ui_export"]),
                               ("fqab_156_presentDiagnostics:", d["ui_present"])):
        method = rt.get_method(rt.objects[visible].cls, rt.sel(selector))
        require(method and rt.methods[method]["imp"] == expected,
                "Core routing copies the methods registered by the original opener to the visible menu")
    if expect_gap:
        require(not rt.queued_operations, "A nonnil presented controller causes the original silent guard to return")
        return {"search_active": active, "real_presented_search": presented_search, "real_registration": installed,
                "linked_menu_capture_and_dispatch": dispatch,
                "real_footer_action_and_export_executed": True, "queued_export": False,
                "scope": "Reproduces the documented input state; does not prove the device has that state."}
    require(rt.queued_operations, "The real original export action queues its work")
    require(dispatch["search_dismissals"] == int(presented_search),
            "The actual dispatcher dismisses only a real occupying search presentation")
    rt.drain_operations(cpu)
    callback = next(job for job in rt.main_jobs if job[0] == visible and
                    rt.selector_names[job[1]] == "fqab_156_presentDiagnostics:")
    payload = rt.objects[callback[2]].state["items"]
    require("url" in payload and "error" not in payload, "The real worker succeeds")
    path = Path(rt.string_value(payload["url"]))
    document = json.loads(path.read_text(encoding="utf-8"))
    require(document["recordCount"] == len(document["entries"]), "Real JSON file contains its records")
    rt.flush_main(cpu)
    shared = rt.objects[visible].state["presentedViewController"]
    require(shared and rt.class_names[rt.objects[shared].cls] == "UIActivityViewController",
            "The completion installed by the original opener presents the actual share controller")
    require(d["ui_present"] in cpu.executed and (visible, d["ui_busy_key"]) not in rt.associations,
            "Real completion clears the busy state")
    return {"search_active": active, "real_presented_search": presented_search, "real_registration": installed,
            "linked_menu_capture_and_dispatch": dispatch,
            "real_footer_action_and_export_executed": True, "queued_export": True,
            "json_bytes": path.stat().st_size, "share_sheet_presented": True, "instructions": cpu.steps}


def main():
    parser = argparse.ArgumentParser(description=__doc__)
    parser.add_argument("candidate", type=Path)
    parser.add_argument("--merged", type=Path, required=True)
    parser.add_argument("--expect-presented-search-gap", action="store_true")
    parser.add_argument("--report", type=Path, required=True)
    args = parser.parse_args()
    data = args.candidate.read_bytes()
    merged = args.merged.read_bytes()
    labels = labels_for(data, args.candidate.with_suffix(".composed.s"), EXTRA)
    result = {"passed": True, "sha256": hashlib.sha256(data).hexdigest(),
              "merged_sha256": hashlib.sha256(merged).hexdigest(),
              "export_methods_preseeded": False, "menu_factory_modeled": True,
              "cases": [exercise(data, labels, merged),
                        exercise(data, labels, merged, True, expect_gap=args.expect_presented_search_gap),
                        exercise(data, labels, merged, True, True)], "device_tested": False}
    args.report.parent.mkdir(parents=True, exist_ok=True)
    args.report.write_text(json.dumps(result, indent=2) + "\n", encoding="utf-8")
    print(json.dumps(result, indent=2))


if __name__ == "__main__":
    main()
