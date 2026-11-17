#!/usr/bin/env python3
"""Execute the final ARC diagnostic row selection and completion instructions.

The core enqueue bridge and UIKit share presentation are named boundaries. The
real row route, pending guard, retry state, saved URL and completion body execute
from the supplied merged image. No UIButton target or legacy owner is provided.
"""
import argparse
import hashlib
import json
from pathlib import Path

from arm64 import require
from test_settings_action_dispatch178r29 import HeapCPU, Runtime as ActionRuntime


class Runtime(ActionRuntime):
    def __init__(self, data):
        super().__init__(data)
        self.requests = []
        self.shares = []
        self.reloads = 0
        self.selections = 0

    def handle(self, cpu, pc):
        if self.symbols.get(pc) == "_objc_msgSend":
            receiver, selector, argument = cpu.x[:3]
            name = self.string(selector)
            obj = self.objects.get(receiver)
            if obj:
                if name == "deselectRowAtIndexPath:animated:":
                    self.selections += 1
                    return self.finish(cpu)
                if name == "reloadData":
                    self.reloads += 1
                    return self.finish(cpu)
                if obj["class"] == "FQXSettingsMenu":
                    if name == "respondsToSelector:":
                        return self.finish(cpu, self.string(argument) == "fqx_enqueueDiagnosticExport:")
                    if name == "fqx_enqueueDiagnosticExport:":
                        self.requests.append((receiver, argument))
                        return self.finish(cpu)
                    if name == "shareDiagnosticFile":
                        offset = self.classes["FQXSettingsMenu"]["ivars"]["_diagnosticFile"]
                        self.shares.append(cpu.read(receiver + offset, 8))
                        return self.finish(cpu)
        return super().handle(cpu, pc)


def exercise(data):
    rt = Runtime(data)
    cpu = HeapCPU(data, rt, ranges=rt.ranges)
    cpu.pointers.update(rt.pointers)

    def instance(name):
        value = rt.obj(name)
        for offset in rt.classes[name]["ivars"].values():
            cpu.write(value + offset, 8, 0)
        return value

    menu, row = instance("FQXSettingsMenu"), instance("FQXSettingRow")
    menu_ivars = rt.classes["FQXSettingsMenu"]["ivars"]
    row_ivars = rt.classes["FQXSettingRow"]["ivars"]
    table, path = rt.obj("UITableView"), rt.obj("NSIndexPath", row=0)
    rt.objects[menu]["tableView"] = table
    cpu.write(menu + menu_ivars["_folders"], 8, rt.obj("NSArray", []))
    cpu.write(menu + menu_ivars["_visibleRows"], 8, rt.obj("NSArray", [row]))
    cpu.write(row + row_ivars["_diagnosticExport"], 1, 1)
    require(not cpu.read(row + row_ivars["_content"], 8) and not cpu.read(row + row_ivars["_actions"], 8),
            "The export entry is a native row with no old UIButton or saved targets")

    def call(name, *arguments):
        selector, imp = rt.classes["FQXSettingsMenu"]["methods"][name]
        cpu.run(imp, args=[menu, selector, *arguments])

    def pending():
        return bool(cpu.read(menu + menu_ivars["_diagnosticExportPending"], 1))

    call("tableView:didSelectRowAtIndexPath:", table, path)
    require(rt.requests == [(menu, menu)] and pending() and rt.reloads == 1,
            "First row selection starts the bridge directly and immediately updates pending status")
    call("tableView:didSelectRowAtIndexPath:", table, path)
    require(len(rt.requests) == 1 and rt.reloads == 1, "A pending request is not duplicated")

    file = rt.obj("NSURL", "file:///tmp/FanqieX-export.json")
    call("fqab_156_presentDiagnostics:", rt.obj("NSDictionary", {"url": file}))
    require(not pending() and cpu.read(menu + menu_ivars["_diagnosticFile"], 8) == file and
            not cpu.read(menu + menu_ivars["_diagnosticError"], 8) and rt.shares == [file] and rt.reloads == 2,
            "Successful completion keeps the URL, clears pending status and requests sharing")
    call("tableView:didSelectRowAtIndexPath:", table, path)
    require(rt.shares == [file, file] and len(rt.requests) == 1,
            "If presentation is unavailable, another tap shares the saved file without regenerating it")

    error = rt.obj("NSString", "Unable to write diagnostics")
    call("fqab_156_presentDiagnostics:", rt.obj("NSDictionary", {"error": error}))
    require(not pending() and not cpu.read(menu + menu_ivars["_diagnosticFile"], 8) and
            cpu.read(menu + menu_ivars["_diagnosticError"], 8) == error and len(rt.shares) == 2,
            "Failure clears pending state and exposes the worker's readable error")
    call("tableView:didSelectRowAtIndexPath:", table, path)
    require(pending() and len(rt.requests) == 2 and not cpu.read(menu + menu_ivars["_diagnosticError"], 8),
            "A user-initiated tap after failure starts one new request and clears the old error")
    return {"native_row_without_button": True, "actual_did_select_and_begin_executed": True,
            "actual_completion_body_executed": True, "pending_guard": True,
            "successful_url_retained": True, "manual_share_without_regeneration": True,
            "error_visible_and_manual_retry": True, "row_selections": rt.selections,
            "native_instructions": len(cpu.executed | rt.executed)}


def main():
    parser = argparse.ArgumentParser(description=__doc__)
    parser.add_argument("candidate", type=Path)
    parser.add_argument("--report", type=Path, required=True)
    args = parser.parse_args()
    data = args.candidate.read_bytes()
    result = {"candidate_sha256": hashlib.sha256(data).hexdigest(), "passed": False,
              "enqueue_bridge": "explicit boundary; covered by separate core regression",
              "share_presentation": "explicit boundary; only request recorded", "uikit_device_tested": False}
    try:
        result.update(exercise(data))
        result["passed"] = True
    except Exception as error:
        result["error"] = str(error)
    args.report.parent.mkdir(parents=True, exist_ok=True)
    args.report.write_text(json.dumps(result, ensure_ascii=False, indent=2) + "\n", encoding="utf-8")
    print(json.dumps(result, ensure_ascii=False))
    raise SystemExit(0 if result["passed"] else 1)


if __name__ == "__main__":
    main()
