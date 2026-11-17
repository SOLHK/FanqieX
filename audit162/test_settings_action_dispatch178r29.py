#!/usr/bin/env python3
"""Execute the linked menu action dispatcher against search-presentation states.

The callback block, row lookup, selector resolution and forwarding are the actual
ARM64 instructions in the merged dylib. UIKit search dismissal and original
router action effects are explicit boundaries; no device behavior is claimed.
"""
import argparse
import hashlib
import json
import struct
from pathlib import Path

from arm64 import require
from test_settings_menu_rows178r28 import HeapCPU, Runtime as MenuRuntime, macho


class Runtime(MenuRuntime):
    def __init__(self, data):
        super().__init__(data)
        self.dynamic_selectors = {}
        self.actions = []
        self.dismissals = 0
        self.associations = {}
        self.presenter_method = None
        for section in macho.sections(data):
            if section["name"] != "__objc_classlist":
                continue
            for address in range(section["offset"], section["offset"] + section["size"], 8):
                cls = self.ptr(address)
                ro = self.ptr(cls + 32) & ~7
                if self.string(self.ptr(ro + 24)) != "FQXSettingsMenu":
                    continue
                meta = self.ptr(cls)
                meta_ro = self.ptr(meta + 32) & ~7
                methods = self.ptr(meta_ro + 32)
                flags, count = struct.unpack_from("<II", data, methods)
                for index in range(count):
                    entry = methods + 8 + index * (flags & 0xfffc)
                    if flags & 0x80000000:
                        name_delta, _, imp_delta = struct.unpack_from("<iii", data, entry)
                        selector = entry + name_delta
                        if not flags & 0x40000000:
                            selector = self.ptr(selector)
                        imp = entry + 8 + imp_delta
                    else:
                        selector, imp = self.ptr(entry), self.ptr(entry + 16)
                    if self.string(selector) == "visibleControllerForController:":
                        self.presenter_method = cls, selector, imp

    def string(self, address):
        if address in getattr(self, "dynamic_selectors", {}):
            return self.dynamic_selectors[address]
        return super().string(address)

    def handle(self, cpu, pc):
        symbol = self.symbols.get(pc)
        args = cpu.x[:8]
        if symbol == "_objc_getAssociatedObject":
            return self.finish(cpu, self.associations.get(args[0], 0))
        if symbol == "_NSSelectorFromString":
            pointer = 0x60000000 + len(self.dynamic_selectors) * 0x100
            self.dynamic_selectors[pointer] = self.value(args[0])
            return self.finish(cpu, pointer)
        if symbol == "_objc_msgSend":
            receiver, selector, argument = args[:3]
            name = self.string(selector)
            obj = self.objects.get(receiver)
            if name == "class":
                return self.finish(cpu, receiver)
            if obj:
                if name == "isKindOfClass:":
                    return self.finish(cpu, self.symbols.get(argument) == "_OBJC_CLASS_$_" + obj["class"])
                if name == "objectForKeyedSubscript:" and obj["class"] == "NSDictionary":
                    return self.finish(cpu, obj["value"].get(self.value(argument), 0))
                if name == "anyObject" and obj["class"] == "NSHashTable":
                    return self.finish(cpu, obj["value"][0] if obj["value"] else 0)
                if name == "respondsToSelector:" and obj["class"] == "Router":
                    return self.finish(cpu, self.string(argument) in obj["selectors"])
                if obj["class"] == "Router" and name in obj["selectors"]:
                    self.actions.append((name, argument))
                    return self.finish(cpu)
                if name == "setActive:" and obj["class"] == "UISearchController":
                    obj["isActive"] = argument
                    return self.finish(cpu)
                if name == "dismissViewControllerAnimated:completion:" and obj["class"] == "UISearchController":
                    self.dismissals += 1
                    if obj["isActive"]:
                        obj["isActive"] = 0
                        obj["presentingViewController"] = 0
                        self.invoke_block(cpu, args[3], 0, 0)
                    # An inactive search with a retained presentation owner is
                    # not an active modal transition. The dispatcher must not
                    # depend on UIKit scheduling this completion at all.
                    return self.finish(cpu)
        return super().handle(cpu, pc)


def run_case(data, active, presenter, selector):
    rt = Runtime(data)
    cpu = HeapCPU(data, rt, ranges=rt.ranges)
    cpu.pointers.update(rt.pointers)

    def instance(name):
        result = rt.obj(name)
        for offset in rt.classes[name]["ivars"].values():
            cpu.write(result + offset, 8, 0)
        return result

    menu, row = instance("FQXSettingsMenu"), instance("FQXSettingRow")
    button = rt.obj("UIButton")
    router = rt.obj("Router", selectors={selector})
    action = rt.obj("NSDictionary", {"target": rt.obj("NSHashTable", [router]),
                                     "selector": rt.obj("NSString", selector)})
    for key, value in {"_content": button, "_actions": rt.obj("NSArray", [action])}.items():
        cpu.write(row + rt.classes["FQXSettingRow"]["ivars"][key], 8, value)
    search = rt.obj("UISearchController", isActive=int(active),
                    presentingViewController=rt.obj("UIViewController") if presenter else 0)
    for key, value in {"_catalog": rt.obj("NSArray", [row]), "_search": search, "_router": router}.items():
        cpu.write(menu + rt.classes["FQXSettingsMenu"]["ivars"][key], 8, value)
    sel, imp = rt.classes["FQXSettingsMenu"]["methods"]["performStoredAction:"]
    cpu.run(imp, menu, sel, button)
    require(rt.actions == [(selector, button)],
            f"The saved original action must run exactly once; actual={rt.actions}, dismissals={rt.dismissals}")
    require(rt.dismissals == int(active and presenter), "Only active, presented search waits for dismissal")
    return {"search_active": active, "has_presenter": presenter, "selector": selector,
            "forwarded_once": True, "dismissals": rt.dismissals,
            "native_instructions": len(cpu.executed | rt.executed)}


def run_presenter_case(data, weak, connected=True):
    rt = Runtime(data)
    require(rt.presenter_method is not None, "The linked menu contains its presenter bridge")
    cpu = HeapCPU(data, rt, ranges=rt.ranges)
    cpu.pointers.update(rt.pointers)
    owner = rt.obj("UIViewController", navigationController=0)
    visible = rt.obj("UIViewController")
    navigation = rt.obj("UINavigationController", topViewController=visible)
    root = rt.obj("FQXSettingsMenu", navigationController=navigation)
    if connected:
        rt.associations[owner] = rt.obj("NSHashTable", [root]) if weak else root
    cls, selector, imp = rt.presenter_method
    result = cpu.run(imp, cls, selector, owner)["result"]
    require(result == (visible if connected else 0), "Presenter comes from the associated root's live navigation stack")
    return {"association": "weak" if weak else "strong", "connected": connected,
            "hidden_owner_navigation": False, "correct_presenter": True,
            "native_instructions": len(cpu.executed | rt.executed)}


def main():
    parser = argparse.ArgumentParser(description=__doc__)
    parser.add_argument("candidate", type=Path)
    parser.add_argument("--report", type=Path, required=True)
    args = parser.parse_args()
    data = args.candidate.read_bytes()
    result = {"candidate_sha256": hashlib.sha256(data).hexdigest(), "passed": False,
              "actual_linked_dispatcher_executed": True, "uikit_device_tested": False,
              "original_target_capture": "fixture seeded from saved target-selector pairs", "cases": [], "presenter_cases": []}
    try:
        for selector in ("fqx178_export:", "fqx178_testListenReward:"):
            for active, presenter in ((False, True), (False, False), (True, True), (True, False)):
                result["cases"].append(run_case(data, active, presenter, selector))
        for weak, connected in ((True, True), (False, True), (True, False)):
            result["presenter_cases"].append(run_presenter_case(data, weak, connected))
        result["passed"] = True
    except Exception as error:
        result["error"] = str(error)
    args.report.parent.mkdir(parents=True, exist_ok=True)
    args.report.write_text(json.dumps(result, ensure_ascii=False, indent=2) + "\n", encoding="utf-8")
    print(json.dumps(result, ensure_ascii=False))
    raise SystemExit(0 if result["passed"] else 1)


if __name__ == "__main__":
    main()
