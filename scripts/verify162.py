#!/usr/bin/env python3
"""Rebuild FanqieX twice and verify the exact resulting bytes on Linux.

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
    for directory in ("repair159", "repair160", "repair161", "repair162", "audit160", "audit161", "audit162", "scripts", "tests", "native", ".github/workflows"):
        paths.extend(path for path in (ROOT / directory).rglob("*")
                     if path.is_file() and path.suffix in (".py", ".s", ".m", ".yml"))
    paths.extend(path for path in (ROOT / "baseline").iterdir() if path.is_file())
    paths.append(ROOT / "dist/1.5.9/FanqieAdBlock-1.5.9.dylib")
    paths.append(ROOT / "verification/1.5.9/FanqieAdBlock-1.5.9.validation.json")
    paths.append(ROOT / "dist/1.6.0/FanqieAdBlock-1.6.0.dylib")
    paths.append(ROOT / "verification/1.6.0/FanqieAdBlock-1.6.0.validation.json")
    paths.append(ROOT / "dist/1.6.1/FanqieAdBlock-1.6.1.dylib")
    paths.append(ROOT / "verification/1.6.1/FanqieAdBlock-1.6.1.validation.json")
    paths.append(ROOT / "dist/1.6.5/FanqieX-1.6.5.dylib")
    paths.append(ROOT / "dist/1.6.6/FanqieX-1.6.6.dylib")
    return {path.relative_to(ROOT).as_posix(): digest(path)
            for path in sorted(paths)}


def main():
    parser = argparse.ArgumentParser(description=__doc__)
    parser.add_argument("--output", type=Path, default=ROOT / "build" / "ci162")
    parser.add_argument("--version", choices=("1.6.2", "1.6.3", "1.6.4", "1.6.5", "1.6.6", "1.6.7"), default="1.6.2")
    parser.add_argument("--expect-candidate", type=Path,
                        help="Also require the rebuild to match this already-delivered dylib exactly")
    args = parser.parse_args()
    output = args.output.resolve()
    if output.exists() and any(output.iterdir()):
        raise SystemExit('Verification output must be empty; choose a fresh --output directory')
    output.mkdir(parents=True, exist_ok=True)
    logs = output / "logs"
    logs.mkdir(exist_ok=True)
    summary = {"passed": False, "version": args.version, "device_tested": False, "python": sys.version.split()[0],
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
        candidate = output / f"FanqieX-{args.version}.dylib"
        rebuilt = output / "rebuild" / candidate.name
        baseline = ROOT / "baseline" / "FanqieAdBlock-1.5.8.dylib"
        baseline157 = ROOT / "baseline" / "FanqieAdBlock-1.5.7.dylib"
        validation = candidate.with_suffix(".validation.json")
        run("build", ["repair162/build_plugin.py", baseline, candidate, "--version", args.version])
        run("rebuild", ["repair162/build_plugin.py", baseline, rebuilt, "--version", args.version])
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
        run("extension-layout-selftest", ["repair162/audit_extend.py",
            ROOT / "baseline" / "FanqieAdBlock-1.5.6.dylib", "--selftest"])
        run("independent-binary", ["audit162/independent159.py", "--baseline", baseline,
            "--candidate", candidate, "--expected-version", args.version,
            "--report", output / "independent-audit.json"])
        run("independent-faults", ["audit162/test_independent_faults.py", candidate,
            "--baseline", baseline, "--expected-version", args.version,
            "--report", output / "independent-fault-tests.json"])
        run("native-surface", ["audit162/test_native_surface.py", candidate,
            "--report", output / "native-audit.json"])
        run("glass-interaction", ["audit162/test_glass_interaction.py", candidate,
            "--output", output / "interaction-audit.json"])
        run("integration", ["audit162/test_integration.py", candidate,
            "--output", output / "integration-audit.json"])
        run("diagnostic-dedup", ["audit162/test_diagnostic_dedup.py", candidate,
            "--baseline", baseline157, "--baseline158", baseline,
            "--output", output / "diagnostic-dedup-report.json"])
        run("legacy-execution", ["audit162/execution_audit.py", candidate,
            "--report", output / "execution-audit.json"])
        run("material-transitions160", ["audit162/test_material_transitions.py", candidate,
            "--baseline", ROOT / "dist/1.5.9/FanqieAdBlock-1.5.9.dylib",
            "--report", output / "material-transitions160.json"])
        run("feed-viewport", ["audit162/test_feed_viewport.py", candidate,
            "--report", output / "feed-audit.json"])
        run("feed-integration", ["audit162/test_feed_integration.py", candidate,
            "--report", output / "feed-integration-audit.json"])
        run("feed-realistic159", ["audit162/test_feed_realistic159.py", candidate,
            "--baseline", baseline, "--baseline-composed", baseline.with_suffix(".composed.s"),
            "--report", output / "feed-realistic159-audit.json"])
        run("first-frame160", ["audit162/test_first_frame160.py", candidate,
            "--baseline", ROOT / "dist/1.5.9/FanqieAdBlock-1.5.9.dylib",
            "--report", output / "first-frame160-audit.json"])
        run("reader-diagnostics160", ["audit162/test_reader_diagnostics160.py",
            "--candidate", candidate, "--report", output / "reader-diagnostics160-audit.json"])
        run("reader-original162", ["audit162/test_reader_original162.py", "--candidate", candidate,
            "--validation", validation, "--report", output / "reader-original162-audit.json"])
        run("shelf-first-frame162", ["audit162/test_shelf_first_frame162.py", "--candidate", candidate,
            "--validation", validation, "--report", output / "shelf-first-frame162-audit.json"])
        run("glass-readability162", ["audit162/test_glass_readability162.py", candidate,
            "--baseline", ROOT / "dist/1.6.0/FanqieAdBlock-1.6.0.dylib",
            "--report", output / "glass-readability162-audit.json"])
        run("interaction-diagnostics162", ["audit162/test_interaction_diagnostics162.py",
            "--candidate", candidate, "--report", output / "interaction-diagnostics162-audit.json"])
        run("native-selection162", ["audit162/test_native_selection162.py",
            "--candidate", candidate, "--report", output / "native-selection162-audit.json"])
        run("native-readability162", ["audit162/test_native_readability162.py",
            "--candidate", candidate, "--baseline", ROOT / "dist/1.6.1/FanqieAdBlock-1.6.1.dylib",
            "--report", output / "native-readability162-audit.json"])
        run("native-orchestration162", ["audit162/test_native_orchestration162.py",
            "--candidate", candidate, "--report", output / "native-orchestration162-audit.json"])
        if args.version in ("1.6.3", "1.6.4", "1.6.5", "1.6.6", "1.6.7"):
            run("hook-ownership163", ["audit162/test_hook_ownership163.py", candidate,
                "--report", output / "hook-ownership163-audit.json"])
        if args.version in ("1.6.4", "1.6.5", "1.6.6", "1.6.7"):
            run("ad-decisions164", ["audit162/test_ad_decisions164.py", candidate,
                "--report", output / "ad-decisions164-audit.json"])
            run("startup-popup164", ["audit162/test_startup_popup164.py", candidate,
                "--report", output / "startup-popup164-audit.json"])
            run("tabbar-spacing164", ["audit162/test_tabbar_spacing164.py", candidate,
                "--baseline", ROOT / "dist/1.6.3/FanqieX-1.6.3.dylib",
                "--report", output / "tabbar-spacing164-audit.json"])
            run("native-diagnostics164", ["audit162/test_native_diagnostics164.py", "--candidate", candidate,
                "--report", output / "native-diagnostics164-audit.json"])
            run("diagnostic-limits164", ["audit162/test_diagnostic_limits164.py", candidate,
                "--report", output / "diagnostic-limits164-audit.json"])
            run("load-diagnostics164", ["audit162/test_load_diagnostics164.py", "--candidate", candidate,
                "--report", output / "load-diagnostics164-audit.json"])
            run("native-compiler-boundaries", ["-m", "unittest", "discover", "-s", "tests", "-p", "test_compile_diagnostics.py", "-v"])
            run("native-unwind", ["-m", "unittest", "discover", "-s", "tests", "-p", "test_native_unwind.py", "-v"])
        if args.version in ("1.6.5", "1.6.6", "1.6.7"):
            run("home-glass165", ["audit162/test_home_glass165.py", candidate,
                "--report", output / "home-glass165.json"])
            run("home-compiler", ["-m", "unittest", "discover", "-s", "tests", "-p", "test_home_compiler.py", "-v"])
        if args.version == "1.6.6":
            run("control-glass166", ["audit162/test_control_glass166.py", candidate,
                "--baseline", ROOT / "dist/1.6.5/FanqieX-1.6.5.dylib",
                "--report", output / "control-glass166.json"])
        if args.version == "1.6.7":
            run("conditional-compare", ["-m", "unittest", "discover", "-s", "tests", "-p", "test_conditional_compare.py", "-v"])
            run("alignment167", ["audit162/test_alignment167.py", candidate,
                "--baseline", ROOT / "dist/1.6.6/FanqieX-1.6.6.dylib",
                "--report", output / "alignment167.json"])
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
