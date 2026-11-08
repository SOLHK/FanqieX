#!/usr/bin/env python3
"""Exercise actual material ARM64 for first mounting and a tab hide/show.

The 1.5.9 binary is a required negative control. This measures setter ordering,
not the GPU's rendered frames or the user's device's elapsed transition time.
"""
import argparse
import hashlib
import json
from pathlib import Path
from execution_audit import directory, make
from arm64 import require


def exercise(data):
    entries = directory(data)
    cpu, runtime = make(data)
    cpu.run(entries['material_update'], runtime.BAR, runtime.PROXY)
    first = [e for e in runtime.events if e['event'] == 'setEffect']
    runtime.objects[runtime.ROOT].state['hidden'] = True
    cpu.run(entries['material_update'], runtime.BAR, runtime.PROXY)
    runtime.objects[runtime.ROOT].state.update(hidden=False, alpha=0.5)
    cpu.run(entries['material_update'], runtime.BAR, runtime.PROXY)
    runtime.objects[runtime.ROOT].state['alpha'] = 1.0
    cpu.run(entries['material_update'], runtime.BAR, runtime.PROXY)
    all_writes = [e for e in runtime.events if e['event'] == 'setEffect']
    return {'sha256': hashlib.sha256(data).hexdigest(),
            'first_mount_writes': len(first),
            'writes_after_hide_fade_show': len(all_writes) - len(first)}


def main():
    parser = argparse.ArgumentParser(description=__doc__)
    parser.add_argument('candidate', type=Path)
    parser.add_argument('--baseline', type=Path, required=True)
    parser.add_argument('--report', type=Path, required=True)
    args = parser.parse_args()
    current, previous = exercise(args.candidate.read_bytes()), exercise(args.baseline.read_bytes())
    require(current['first_mount_writes'] == 1, 'One final native material on first display')
    require(current['writes_after_hide_fade_show'] == 0, 'No material reset on a same-window tab transition')
    require(previous['first_mount_writes'] == 2 and previous['writes_after_hide_fade_show'] == 2,
            'The exact shipped 1.5.9 reproduces both regressions')
    report = {'passed': True, 'candidate': current, 'negative_control_159': previous,
              'device_tested': False, 'scope': 'Actual ARM64 setter order and cache lifecycle; UIKit modeled'}
    args.report.write_text(json.dumps(report, indent=2) + '\n')
    print(json.dumps(report, indent=2))


if __name__ == '__main__':
    main()
