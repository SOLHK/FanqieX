#!/usr/bin/env python3
"""Execute real _open_menu registration and the UI-independent export service.

The enqueue method is never pre-registered: actual LUIinstall/LUIadd_method must
install it. The separate ARC menu factory and its existing completion method are
explicit boundaries; the latter records delivery, while real core instructions
initialize the store, enqueue, write JSON and schedule the main-thread callback.
No UIKit hit testing, presentation or device execution is claimed by this test.
"""
import argparse
import hashlib
import json
import struct
from pathlib import Path

from arm64 import CPU, require
from test_settings_entry178r27 import Runtime as EntryRuntime, labels_for, EXTRA


class Runtime(EntryRuntime):
    ARC_CALLBACK = 0x333b0000

    def __init__(self, data, logger_unavailable=False):
        super().__init__(data)
        self.logger_unavailable = logger_unavailable
        self.deliveries = []
        # This method belongs to the linked ARC class, not the dynamic core
        # bridge under test. Its real body is covered by the menu service test.
        self._add(self.classes["FQXSettingsMenu"], "fqab_156_presentDiagnostics:",
                  self.ARC_CALLBACK, "v24@0:8@16")

    def handle(self, cpu, pc):
        if pc == self.ARC_CALLBACK:
            require(self.thread == "main", "Export results are delivered on main")
            self.deliveries.append((cpu.x[0], cpu.x[2]))
            return self.finish(cpu)
        if pc - self.slide == 0xa61c and self.logger_unavailable and self.string(cpu.x[1]) == "FQABDiagnosticsV155":
            return self.finish(cpu, 0)
        return super().handle(cpu, pc)


def exercise(data, labels, *, diagnostics=True, fail_write=False, logger_unavailable=False):
    rt = Runtime(data, logger_unavailable)
    rt.labels = labels
    rt.objects[rt.DEFAULTS].state["values"]["FanqieX.DiagnosticsEnabled"] = diagnostics
    words = struct.unpack_from("<64I", data, 0x800)
    cpu = CPU(data, rt, ranges=[(0x800, 0x4000), (0x4338, 0x43fc), (0x4704, 0x48d0),
                               (0x4958, 0x4d78), (0x5168, 0x5204), (0x5688, 0x56c0),
                               (0x5b94, 0x5c24), (0x60b8, 0x62ac), (0x14080, 0x800 + words[61]),
                               (0x6c14, 0x6c4c), (0x6db4, 0x702c), (0x711c, 0x746c)])
    cpu.pointers.update(rt.rebase_pointers)
    cls = rt.classes["FQXSettingsMenu"]
    selector = rt.sel("fqx_enqueueDiagnosticExport:")
    require(not rt.get_method(cls, selector), "The export service bridge starts absent")
    host = rt.obj("UIViewController", "host settings", presentedViewController=0)
    cpu.run(0x4958, host)
    method = rt.get_method(cls, selector)
    require(method and rt.methods[method]["imp"] == labels["LUIenqueue"] and
            rt.methods[method]["encoding"] == "v24@0:8@16",
            "The actual original opener installs the new service IMP with its exact ABI")
    menu = rt.menu_roots[rt.owner]
    # A loaded view, visible window or free modal slot is intentionally absent:
    # producing the file must succeed independently of future presentation.
    rt.objects[menu].state.update(view=0, presentedViewController=rt.obj("UIViewController", "existing modal"))
    rt.fail_write = fail_write
    before = len(rt.deliveries)
    rt.invoke(cpu, menu, selector, menu, "main")
    require(labels["LUIenqueue"] in cpu.executed, "The newly installed service executes candidate instructions")
    if logger_unavailable:
        require(not rt.queued_operations and len(rt.deliveries) == before + 1,
                "An unavailable logger immediately delivers an error instead of silently returning")
    else:
        require(rt.queued_operations and len(rt.deliveries) == before,
                "The real service enqueues before any result is delivered")
        rt.drain_operations(cpu)
        callbacks = [job for job in rt.main_jobs if job[0] == menu and
                     rt.selector_names[job[1]] == "fqab_156_presentDiagnostics:"]
        require(len(callbacks) == 1 and len(rt.deliveries) == before,
                "The real worker schedules exactly one completion without delivering on worker")
        rt.flush_main(cpu)
        require(len(rt.deliveries) == before + 1, "The real scheduled callback reaches the original ARC target once")
    receiver, payload = rt.deliveries[-1]
    require(receiver == menu, "The command keeps the requested callback target")
    values = rt.objects[payload].state["items"]
    error_expected = fail_write or logger_unavailable
    if error_expected:
        require("error" in values and "url" not in values and rt.string_value(values["error"]),
                "Every modeled failure delivers readable error data and no false success URL")
        size = 0
    else:
        require("url" in values and "error" not in values, "Successful export returns a file URL")
        path = Path(rt.string_value(values["url"]))
        content = json.loads(path.read_text(encoding="utf-8"))
        require(content["recordCount"] == len(content["entries"]), "The actual exported JSON matches its declared record count")
        size = path.stat().st_size
    return {"diagnostics_enabled": diagnostics, "file_write_failure": fail_write,
            "logger_unavailable": logger_unavailable, "bridge_registered_by_actual_open_menu": True,
            "service_imp": hex(rt.methods[method]["imp"]), "view_required": False,
            "modal_slot_required": False, "main_callback_deliveries": 1,
            "error_delivered": error_expected, "json_bytes": size, "instructions": cpu.steps}


def main():
    parser = argparse.ArgumentParser(description=__doc__)
    parser.add_argument("candidate", type=Path)
    parser.add_argument("--report", type=Path, required=True)
    args = parser.parse_args()
    data = args.candidate.read_bytes()
    labels = labels_for(data, args.candidate.with_suffix(".composed.s"), EXTRA + ["LUIenqueue"])
    report = {"passed": True, "candidate_sha256": hashlib.sha256(data).hexdigest(),
              "enqueue_method_preseeded": False, "arc_callback_body_modeled": True,
              "cases": [exercise(data, labels), exercise(data, labels, diagnostics=False),
                        exercise(data, labels, fail_write=True), exercise(data, labels, logger_unavailable=True)],
              "device_tested": False}
    args.report.parent.mkdir(parents=True, exist_ok=True)
    args.report.write_text(json.dumps(report, indent=2) + "\n", encoding="utf-8")
    print(json.dumps(report, indent=2))


if __name__ == "__main__":
    main()
