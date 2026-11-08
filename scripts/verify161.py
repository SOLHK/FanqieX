#!/usr/bin/env python3
"""Rebuild 1.6.1 twice and verify the exact resulting bytes on Linux.

Run from any directory. No third-party Python packages are needed. The assembly
builder requires the LLVM 19 shared library; the independent binary audit does
not. This script neither executes the dylib in a native process nor publishes it.
"""
from __future__ import annotations

import argparse
import ctypes
import hashlib
import json
from pathlib import Path
import platform
import subprocess
import sys
import time


ROOT = Path(__file__).resolve().parents[1]
PINNED = {
    "1.5.6": "918313ffab725b9b4c53d030fac463f836032b164b9b30b9815720418e8d36d4",
    "1.5.7": "6031d37a2d4e41038338eb0d5730bb6f30833fb0c3499bf4f5b781a88a64a7a1",
    "1.5.8": "55a2c02e5962ad740816aaf2f8f2f6d9269eb9ecce37c69402897ff3776a4354",
}


def digest(path: Path):
    value = hashlib.sha256()
    with path.open("rb") as stream:
        for block in iter(lambda: stream.read(1024 * 1024), b""):
            value.update(block)
    return value.hexdigest()


def source_manifest():
    """Pin the files actually used to build and exercise the candidate.

    A branch's HEAD alone does not identify an uncommitted working tree. Record
    byte hashes as well, and reject an edit made while verification is running.
    Generated reports and caches are deliberately outside this inventory.
    """
    paths = []
    for directory in ("repair159", "repair160", "repair161", "audit160", "audit161", "scripts", "native", ".github/workflows"):
        paths.extend(path for path in (ROOT / directory).rglob("*")
                     if path.is_file() and path.suffix in (".py", ".s", ".m", ".yml"))
    paths.extend(path for path in (ROOT / "baseline").iterdir() if path.is_file())
    paths.append(ROOT / "dist/1.5.9/FanqieAdBlock-1.5.9.dylib")
    paths.append(ROOT / "verification/1.5.9/FanqieAdBlock-1.5.9.validation.json")
    paths.append(ROOT / "dist/1.6.0/FanqieAdBlock-1.6.0.dylib")
    paths.append(ROOT / "verification/1.6.0/FanqieAdBlock-1.6.0.validation.json")
    return {path.relative_to(ROOT).as_posix(): digest(path)
            for path in sorted(paths)}


def main():
    parser = argparse.ArgumentParser(description=__doc__)
    parser.add_argument("--output", type=Path, default=ROOT / "build" / "ci161")
    parser.add_argument("--expect-candidate", type=Path,
                        help="Also require the rebuild to match this already-delivered dylib exactly")
    args = parser.parse_args()
    output = args.output.resolve()
    if output.exists() and any(output.iterdir()):
        raise SystemExit('Verification output must be empty; choose a fresh --output directory')
    output.mkdir(parents=True, exist_ok=True)
    logs = output / "logs"
    logs.mkdir(exist_ok=True)
    summary = {"passed": False, "device_tested": False, "python": sys.version.split()[0],
               "platform": platform.platform(), "steps": [], "scope":
               "Reproducible ARM64 build, binary integrity and explicit Objective-C boundary models"}

    def save():
        (output / "ci-summary.json").write_text(json.dumps(summary, ensure_ascii=False, indent=2) + "\n")

    def run(name, arguments):
        print(f"RUN  {name}", flush=True)
        before = time.monotonic()
        process = subprocess.run([sys.executable, *map(str, arguments)], cwd=ROOT,
                                 stdout=subprocess.PIPE, stderr=subprocess.STDOUT, text=True)
        (logs / f"{name}.log").write_text(process.stdout)
        step = {"name": name, "passed": process.returncode == 0,
                "returncode": process.returncode, "seconds": round(time.monotonic() - before, 3),
                "log": f"logs/{name}.log"}
        summary["steps"].append(step)
        save()
        if process.returncode:
            print(process.stdout[-16000:], end="", flush=True)
            raise RuntimeError(f"Verification failed: {name} (full log: {logs / (name + '.log')})")
        print(f"PASS {name} ({step['seconds']:.3f}s)", flush=True)

    try:
        inputs = source_manifest()
        manifest_bytes = (json.dumps(inputs, sort_keys=True, indent=2) + "\n").encode()
        (output / "source-manifest.json").write_bytes(manifest_bytes)
        summary["source_manifest_sha256"] = hashlib.sha256(manifest_bytes).hexdigest()
        summary["source_file_count"] = len(inputs)
        for version, expected in PINNED.items():
            path = ROOT / "baseline" / f"FanqieAdBlock-{version}.dylib"
            if digest(path) != expected:
                raise RuntimeError(f"Pinned baseline {version} was modified")
        library_path = Path("/lib/x86_64-linux-gnu/libLLVM.so.19.1")
        library = ctypes.CDLL(str(library_path))
        version = [ctypes.c_uint() for _ in range(3)]
        library.LLVMGetVersion.argtypes = [ctypes.POINTER(ctypes.c_uint)] * 3
        library.LLVMGetVersion(*(ctypes.byref(value) for value in version))
        summary["llvm"] = {"version": ".".join(str(value.value) for value in version),
                           "library_sha256": digest(library_path)}
        commit = subprocess.run(["git", "rev-parse", "HEAD"], cwd=ROOT,
                                capture_output=True, text=True)
        if commit.returncode == 0:
            summary["git_head_at_start"] = commit.stdout.strip()
            status = subprocess.run(["git", "status", "--porcelain", "--untracked-files=all"],
                                    cwd=ROOT, capture_output=True, text=True)
            summary["git_working_tree_clean_at_start"] = (
                status.returncode == 0 and not status.stdout.strip())
        save()
        candidate = output / "FanqieAdBlock-1.6.1.dylib"
        rebuilt = output / "rebuild" / candidate.name
        baseline = ROOT / "baseline" / "FanqieAdBlock-1.5.8.dylib"
        baseline157 = ROOT / "baseline" / "FanqieAdBlock-1.5.7.dylib"
        validation = candidate.with_suffix(".validation.json")
        run("build", ["repair161/build_plugin.py", baseline, candidate])
        run("rebuild", ["repair161/build_plugin.py", baseline, rebuilt])
        if candidate.read_bytes() != rebuilt.read_bytes():
            raise RuntimeError("Two clean builds produced different bytes")
        summary["candidate_sha256"] = digest(candidate)
        summary["candidate_size"] = candidate.stat().st_size
        summary["two_builds_identical"] = True
        if args.expect_candidate:
            if candidate.read_bytes() != args.expect_candidate.resolve().read_bytes():
                raise RuntimeError("Rebuild differs from the supplied delivery candidate")
            summary["delivery_candidate_identical"] = True
        save()
        run("extension-layout-selftest", ["repair161/audit_extend.py",
            ROOT / "baseline" / "FanqieAdBlock-1.5.6.dylib", "--selftest"])
        run("independent-binary", ["audit161/independent159.py", "--baseline", baseline,
            "--candidate", candidate, "--report", output / "independent-audit.json"])
        run("independent-faults", ["audit161/test_independent_faults.py", candidate,
            "--baseline", baseline, "--report", output / "independent-fault-tests.json"])
        run("native-surface", ["audit161/test_native_surface.py", candidate,
            "--report", output / "native-audit.json"])
        run("glass-interaction", ["audit161/test_glass_interaction.py", candidate,
            "--output", output / "interaction-audit.json"])
        run("integration", ["audit161/test_integration.py", candidate,
            "--output", output / "integration-audit.json"])
        run("diagnostic-dedup", ["audit161/test_diagnostic_dedup.py", candidate,
            "--baseline", baseline157, "--baseline158", baseline,
            "--output", output / "diagnostic-dedup-report.json"])
        run("legacy-execution", ["audit161/execution_audit.py", candidate,
            "--report", output / "execution-audit.json"])
        run("material-transitions160", ["audit161/test_material_transitions.py", candidate,
            "--baseline", ROOT / "dist/1.5.9/FanqieAdBlock-1.5.9.dylib",
            "--report", output / "material-transitions160.json"])
        run("feed-viewport", ["audit161/test_feed_viewport.py", candidate,
            "--report", output / "feed-audit.json"])
        run("feed-integration", ["audit161/test_feed_integration.py", candidate,
            "--report", output / "feed-integration-audit.json"])
        run("feed-realistic159", ["audit161/test_feed_realistic159.py", candidate,
            "--baseline", baseline, "--baseline-composed", baseline.with_suffix(".composed.s"),
            "--report", output / "feed-realistic159-audit.json"])
        run("first-frame160", ["audit161/test_first_frame160.py", candidate,
            "--baseline", ROOT / "dist/1.5.9/FanqieAdBlock-1.5.9.dylib",
            "--report", output / "first-frame160-audit.json"])
        run("reader-diagnostics160", ["audit161/test_reader_diagnostics160.py",
            "--candidate", candidate, "--report", output / "reader-diagnostics160-audit.json"])
        run("reader-original161", ["audit161/test_reader_original161.py", "--candidate", candidate,
            "--validation", validation, "--report", output / "reader-original161-audit.json"])
        run("glass-readability161", ["audit161/test_glass_readability161.py", candidate,
            "--baseline", ROOT / "dist/1.6.0/FanqieAdBlock-1.6.0.dylib",
            "--report", output / "glass-readability161-audit.json"])
        run("interaction-diagnostics161", ["audit161/test_interaction_diagnostics161.py",
            "--candidate", candidate, "--report", output / "interaction-diagnostics161-audit.json"])
        run("native-selection161", ["audit161/test_native_selection161.py",
            "--candidate", candidate, "--report", output / "native-selection161-audit.json"])
        run("native-orchestration161", ["audit161/test_native_orchestration161.py",
            "--candidate", candidate, "--report", output / "native-orchestration161-audit.json"])
        # Fail if any step replaced the binary underneath the recorded reports.
        if digest(candidate) != summary["candidate_sha256"]:
            raise RuntimeError("Candidate bytes changed during verification")
        if source_manifest() != inputs:
            raise RuntimeError("Build/test source files changed during verification; rerun on a frozen tree")
        summary["source_files_unchanged_during_verification"] = True
        (output / "SHA256SUMS.txt").write_text(f"{summary['candidate_sha256']}  {candidate.name}\n")
        summary["passed"] = True
        save()
        print(json.dumps({key: summary[key] for key in
                          ("passed", "candidate_sha256", "candidate_size", "two_builds_identical", "device_tested")},
                         indent=2))
        return 0
    except Exception as error:
        summary["error"] = str(error)
        save()
        print(str(error), file=sys.stderr)
        return 1


if __name__ == "__main__":
    raise SystemExit(main())
