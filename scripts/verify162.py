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
import os
from pathlib import Path
import platform
import shutil
import subprocess
import sys
import time

from build_xcode27 import matches_apple_toolchain


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
                     if path.is_file() and path.suffix in (".py", ".s", ".m", ".c", ".h", ".yml"))
    paths.extend(path for path in (ROOT / "baseline").iterdir() if path.is_file())
    paths.extend(path for path in (ROOT / "tests/fixtures").rglob("*.json") if path.is_file())
    paths.append(ROOT / "VERSION")
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


def validated_xcode_bundle(candidate: Path, version: str, expected_commit: str):
    """Bind the Apple binary and its audit assembly to the same source commit.

    Apple and Linux Clang may schedule the generated component differently.
    Audit the composed assembly from the actual Apple build without replacing
    the committed source or treating a local rebuild as the Apple artifact.
    """
    validation_path = candidate.with_suffix('.validation.json')
    composed_path = candidate.with_suffix('.composed.s')
    build_report_path = candidate.parent / 'xcode-build-report.json'
    if not all(path.is_file() for path in
               (candidate, validation_path, composed_path, build_report_path)):
        raise RuntimeError('The Xcode candidate, validation, composed assembly and build report are required')
    validation = json.loads(validation_path.read_text())
    report = json.loads(build_report_path.read_text())
    candidate_hash = digest(candidate)
    if validation.get('version') != version or report.get('plugin_version') != version:
        raise RuntimeError('Xcode artifact version mismatch')
    if validation.get('candidate_sha256') != candidate_hash or report.get('candidate_sha256') != candidate_hash:
        raise RuntimeError('Xcode reports do not match candidate bytes')
    if not validation.get('native_unwind', {}).get('passed'):
        raise RuntimeError('Xcode candidate did not pass native unwind validation')
    if not report.get('passed') or not report.get('two_builds_identical'):
        raise RuntimeError('Xcode build did not pass reproducible-build checks')
    if not expected_commit or report.get('github_sha') != expected_commit:
        raise RuntimeError('Xcode build does not belong to the verified source commit')
    sdk_version = report.get('sdk_version', '')
    if not matches_apple_toolchain(report.get('xcode', ''), sdk_version, version):
        raise RuntimeError('Xcode artifact was not built with the required Apple toolchain')
    if version in ('1.78R15', '1.78R16', '1.78R25', "1.78R26", "1.78R27", "1.78R28", "1.78R29", "1.78R30", "1.78R31", "1.78R32", "1.78R33", "1.78R34", "1.78R35", "1.78R36", "1.79R1", "1.79R2", "1.79R3", "1.79R4", "1.79R5", "1.8R1", "1.8R2", "1.8R3", "1.8R4", "1.8R5", "1.8R6", "1.8R7") and report.get('sdk_typecheck_target') != f'arm64-apple-ios{sdk_version}':
        raise RuntimeError('Xcode type-check target does not match the reported iOS SDK')
    if version in ('1.78', '1.78R2', '1.78R3', '1.78R4', '1.78R5', '1.78R6', '1.78R7', '1.78R8', '1.78R9', '1.78R10', '1.78R11', '1.78R12', '1.78R13', '1.78R14', '1.78R15', '1.78R16', '1.78R25', "1.78R26", "1.78R27", "1.78R28", "1.78R29", "1.78R30", "1.78R31", "1.78R32", "1.78R33", "1.78R34", "1.78R35", "1.78R36", "1.79R1", "1.79R2", "1.79R3", "1.79R4", "1.79R5", "1.8R1", "1.8R2", "1.8R3", "1.8R4", "1.8R5", "1.8R6", "1.8R7"):
        if report.get('composed_assembly_sha256') != digest(composed_path):
            raise RuntimeError('Xcode composed assembly changed after the build')
        audit_hashes = report.get('audit_input_sha256', {})
        for suffix in ('.preextend', '.extension.bin'):
            path = candidate.with_suffix(suffix)
            if not path.is_file() or audit_hashes.get(suffix) != digest(path):
                raise RuntimeError('Xcode audit input changed or is missing: ' + suffix)
        source_hashes = report.get('native_source_sha256', {})
        for path in ('native/AlignedGlass.m', 'native/FanqieXDiagnostics.m'):
            if source_hashes.get(path) != digest(ROOT / path):
                raise RuntimeError('Xcode native source does not match the verified checkout: ' + path)
    return validation_path, composed_path, build_report_path


def main():
    parser = argparse.ArgumentParser(description=__doc__)
    parser.add_argument("--output", type=Path, default=ROOT / "build" / "ci162")
    parser.add_argument("--version", choices=("1.6.2", "1.6.3", "1.6.4", "1.6.5", "1.6.6", "1.6.7", "1.7.1", "1.7.2", "1.7.3", "1.7.4", "1.74", "1.75", "1.76", "1.78", "1.78R2", "1.78R3", "1.78R4", "1.78R5", "1.78R6", "1.78R7", "1.78R8", "1.78R9", "1.78R10", "1.78R11", "1.78R12", "1.78R13", "1.78R14", "1.78R15", "1.78R16", "1.78R25", "1.78R26", "1.78R27", "1.78R28", "1.78R29", "1.78R30", "1.78R31", "1.78R32", "1.78R33", "1.78R34", "1.78R35", "1.78R36", "1.79R1", "1.79R2", "1.79R3", "1.79R4", "1.79R5", "1.8R1", "1.8R2", "1.8R3", "1.8R4", "1.8R5", "1.8R6", "1.8R7"), default="1.6.2")
    parser.add_argument("--expect-candidate", type=Path,
                        help="Also require the rebuild to match this already-delivered dylib exactly")
    parser.add_argument("--xcode-candidate", type=Path,
                        help="Use a same-commit Xcode candidate for native unwind and runtime audits")
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
        if platform.system() == "Windows":
            compiler = os.environ.get("FQ_CLANG") or shutil.which("clang")
            if not compiler:
                raise RuntimeError("Windows verification requires clang; set FQ_CLANG")
            os.environ["FQ_ASSEMBLER"] = "clang"
            os.environ["FQ_CLANG"] = compiler
            os.environ["FQ_NATIVE_CLANG"] = compiler
            os.environ["PYTHONUTF8"] = "1"
            summary["assembler"] = {
                "name": "local clang (non-Apple workstation; not the Xcode release toolchain)",
                "path": compiler,
                "version": subprocess.run([compiler, "--version"], capture_output=True,
                                          text=True, check=True).stdout.splitlines()[0],
            }
        else:
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
        if args.version in ('1.78', '1.78R2', '1.78R3', '1.78R4', '1.78R5', '1.78R6', '1.78R7', '1.78R8', '1.78R9', '1.78R10', '1.78R11', '1.78R12', '1.78R13', '1.78R14', '1.78R15', '1.78R16', '1.78R25', "1.78R26", "1.78R27", "1.78R28", "1.78R29", "1.78R30", "1.78R31", "1.78R32", "1.78R33", "1.78R34", "1.78R35", "1.78R36", "1.79R1", "1.79R2", "1.79R3", "1.79R4", "1.79R5", "1.8R1", "1.8R2", "1.8R3", "1.8R4", "1.8R5", "1.8R6", "1.8R7"):
            run('neon-instruction-semantics178', ['-m', 'unittest', 'discover', '-s',
                'tests', '-p', 'test_neon178.py', '-v'])
            run('xcode-artifact-provenance', ['-m', 'unittest', 'discover', '-s',
                'tests', '-p', 'test_xcode_bundle.py', '-v'])
            run('release-capacity178', ['-m', 'unittest', 'discover', '-s',
                'tests', '-p', 'test_release_capacity178.py', '-v'])
        run("build", ["repair162/build_plugin.py", baseline, candidate, "--version", args.version])
        run("rebuild", ["repair162/build_plugin.py", baseline, rebuilt, "--version", args.version])
        if candidate.read_bytes() != rebuilt.read_bytes():
            raise RuntimeError("Two clean builds produced different bytes")
        linux_candidate_sha256 = digest(candidate)
        summary["candidate_sha256"] = linux_candidate_sha256
        summary["candidate_size"] = candidate.stat().st_size
        summary["two_builds_identical"] = True
        if args.xcode_candidate:
            xcode_candidate = args.xcode_candidate.resolve()
            validation_path, composed_path, build_report_path = validated_xcode_bundle(
                xcode_candidate, args.version, summary.get('git_head_at_start', ''))
            summary["linux_candidate_sha256"] = linux_candidate_sha256
            summary["xcode_validation_sha256"] = digest(validation_path)
            summary["xcode_build_report_sha256"] = digest(build_report_path)
            summary["xcode_composed_assembly_sha256"] = digest(composed_path)
            xcode_report = json.loads(build_report_path.read_text())
            summary["xcode_version"] = xcode_report["xcode"].splitlines()[0]
            summary["xcode_sdk_version"] = xcode_report["sdk_version"]
            summary["candidate_source"] = f'same-commit {summary["xcode_version"]} validated build'
            candidate.write_bytes(xcode_candidate.read_bytes())
            candidate.with_suffix('.validation.json').write_bytes(validation_path.read_bytes())
            candidate.with_suffix('.composed.s').write_bytes(composed_path.read_bytes())
            for suffix in ('.preextend', '.extension.bin'):
                artifact = xcode_candidate.with_suffix(suffix)
                if args.version in ('1.78', '1.78R2', '1.78R3', '1.78R4', '1.78R5', '1.78R6', '1.78R7', '1.78R8', '1.78R9', '1.78R10', '1.78R11', '1.78R12', '1.78R13', '1.78R14', '1.78R15', '1.78R16', '1.78R25', "1.78R26", "1.78R27", "1.78R28", "1.78R29", "1.78R30", "1.78R31", "1.78R32", "1.78R33", "1.78R34", "1.78R35", "1.78R36", "1.79R1", "1.79R2", "1.79R3", "1.79R4", "1.79R5", "1.8R1", "1.8R2", "1.8R3", "1.8R4", "1.8R5", "1.8R6", "1.8R7") or artifact.is_file():
                    candidate.with_suffix(suffix).write_bytes(artifact.read_bytes())
            summary["candidate_sha256"] = digest(candidate)
            summary["candidate_size"] = candidate.stat().st_size
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
        if args.version in ("1.6.3", "1.6.4", "1.6.5", "1.6.6", "1.6.7", "1.7.1", "1.7.2", "1.7.3", "1.7.4", "1.74", "1.75", "1.76", "1.78", "1.78R2", "1.78R3", "1.78R4", "1.78R5", "1.78R6", "1.78R7", "1.78R8", "1.78R9", "1.78R10", "1.78R11", "1.78R12", "1.78R13", "1.78R14", "1.78R15", "1.78R16", "1.78R25", "1.78R26", "1.78R27", "1.78R28", "1.78R29", "1.78R30", "1.78R31", "1.78R32", "1.78R33", "1.78R34", "1.78R35", "1.78R36", "1.79R1", "1.79R2", "1.79R3", "1.79R4", "1.79R5", "1.8R1", "1.8R2", "1.8R3", "1.8R4", "1.8R5", "1.8R6", "1.8R7"):
            run("hook-ownership163", ["audit162/test_hook_ownership163.py", candidate,
                "--report", output / "hook-ownership163-audit.json"])
        if args.version in ("1.6.4", "1.6.5", "1.6.6", "1.6.7", "1.7.1", "1.7.2", "1.7.3", "1.7.4", "1.74", "1.75", "1.76", "1.78", "1.78R2", "1.78R3", "1.78R4", "1.78R5", "1.78R6", "1.78R7", "1.78R8", "1.78R9", "1.78R10", "1.78R11", "1.78R12", "1.78R13", "1.78R14", "1.78R15", "1.78R16", "1.78R25", "1.78R26", "1.78R27", "1.78R28", "1.78R29", "1.78R30", "1.78R31", "1.78R32", "1.78R33", "1.78R34", "1.78R35", "1.78R36", "1.79R1", "1.79R2", "1.79R3", "1.79R4", "1.79R5", "1.8R1", "1.8R2", "1.8R3", "1.8R4", "1.8R5", "1.8R6", "1.8R7"):
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
        if args.version in ("1.6.5", "1.6.6", "1.6.7", "1.7.1", "1.7.2", "1.7.3", "1.7.4", "1.74", "1.75", "1.76", "1.78", "1.78R2", "1.78R3", "1.78R4", "1.78R5", "1.78R6", "1.78R7", "1.78R8", "1.78R9", "1.78R10", "1.78R11", "1.78R12", "1.78R13", "1.78R14", "1.78R15", "1.78R16", "1.78R25", "1.78R26", "1.78R27", "1.78R28", "1.78R29", "1.78R30", "1.78R31", "1.78R32", "1.78R33", "1.78R34", "1.78R35", "1.78R36", "1.79R1", "1.79R2", "1.79R3", "1.79R4", "1.79R5", "1.8R1", "1.8R2", "1.8R3", "1.8R4", "1.8R5", "1.8R6", "1.8R7"):
            run("home-glass165", ["audit162/test_home_glass165.py", candidate,
                "--report", output / "home-glass165.json"])
            run("home-compiler", ["-m", "unittest", "discover", "-s", "tests", "-p", "test_home_compiler.py", "-v"])
        if args.version == "1.6.6":
            run("control-glass166", ["audit162/test_control_glass166.py", candidate,
                "--baseline", ROOT / "dist/1.6.5/FanqieX-1.6.5.dylib",
                "--report", output / "control-glass166.json"])
        if args.version in ("1.7.1", "1.7.2", "1.7.3", "1.7.4", "1.74", "1.75", "1.76", "1.78", "1.78R2", "1.78R3", "1.78R4", "1.78R5", "1.78R6", "1.78R7", "1.78R8", "1.78R9", "1.78R10", "1.78R11", "1.78R12", "1.78R13", "1.78R14", "1.78R15", "1.78R16", "1.78R25", "1.78R26", "1.78R27", "1.78R28", "1.78R29", "1.78R30", "1.78R31", "1.78R32", "1.78R33", "1.78R34", "1.78R35", "1.78R36", "1.79R1", "1.79R2", "1.79R3", "1.79R4", "1.79R5", "1.8R1", "1.8R2", "1.8R3", "1.8R4", "1.8R5", "1.8R6", "1.8R7"):
            run("conditional-compare", ["-m", "unittest", "discover", "-s", "tests", "-p", "test_conditional_compare.py", "-v"])
            run("alignment167", ["audit162/test_alignment167.py", candidate,
                "--baseline", ROOT / "dist/1.6.6/FanqieX-1.6.6.dylib",
                "--report", output / "alignment167.json"])
        if args.version in ("1.7.1", "1.7.2", "1.7.3", "1.7.4", "1.74", "1.75", "1.76", "1.78", "1.78R2", "1.78R3", "1.78R4", "1.78R5", "1.78R6", "1.78R7", "1.78R8", "1.78R9", "1.78R10", "1.78R11", "1.78R12", "1.78R13", "1.78R14", "1.78R15", "1.78R16", "1.78R25", "1.78R26", "1.78R27", "1.78R28", "1.78R29", "1.78R30", "1.78R31", "1.78R32", "1.78R33", "1.78R34", "1.78R35", "1.78R36", "1.79R1", "1.79R2", "1.79R3", "1.79R4", "1.79R5", "1.8R1", "1.8R2", "1.8R3", "1.8R4", "1.8R5", "1.8R6", "1.8R7"):
            run("controls171", ["audit162/test_controls171.py", candidate,
                "--report", output / "controls171.json"])
        if args.version in ("1.7.3", "1.7.4", "1.74", "1.75", "1.76", "1.78", "1.78R2", "1.78R3", "1.78R4", "1.78R5", "1.78R6", "1.78R7", "1.78R8", "1.78R9", "1.78R10", "1.78R11", "1.78R12", "1.78R13", "1.78R14", "1.78R15", "1.78R16", "1.78R25", "1.78R26", "1.78R27", "1.78R28", "1.78R29", "1.78R30", "1.78R31", "1.78R32", "1.78R33", "1.78R34", "1.78R35", "1.78R36", "1.79R1", "1.79R2", "1.79R3", "1.79R4", "1.79R5", "1.8R1", "1.8R2", "1.8R3", "1.8R4", "1.8R5", "1.8R6", "1.8R7"):
            run("header173", ["audit162/test_header173.py", candidate,
                "--report", output / "header173.json"])
        if args.version in ("1.7.4", "1.74", "1.75", "1.76", "1.78", "1.78R2", "1.78R3", "1.78R4", "1.78R5", "1.78R6", "1.78R7", "1.78R8", "1.78R9", "1.78R10", "1.78R11", "1.78R12", "1.78R13", "1.78R14", "1.78R15", "1.78R16", "1.78R25", "1.78R26", "1.78R27", "1.78R28", "1.78R29", "1.78R30", "1.78R31", "1.78R32", "1.78R33", "1.78R34", "1.78R35", "1.78R36", "1.79R1", "1.79R2", "1.79R3", "1.79R4", "1.79R5", "1.8R1", "1.8R2", "1.8R3", "1.8R4", "1.8R5", "1.8R6", "1.8R7"):
            run("page-glass174", ["audit162/test_page_glass174.py", candidate,
                "--report", output / "page-glass174.json"])
            run("top-chrome", ["audit162/test_top_chrome.py", candidate,
                "--report", output / "top-chrome.json"])
        if args.version in ("1.75", "1.76", "1.78", "1.78R2", "1.78R3", "1.78R4", "1.78R5", "1.78R6", "1.78R7", "1.78R8", "1.78R9", "1.78R10", "1.78R11", "1.78R12", "1.78R13", "1.78R14", "1.78R15", "1.78R16", "1.78R25", "1.78R26", "1.78R27", "1.78R28", "1.78R29", "1.78R30", "1.78R31", "1.78R32", "1.78R33", "1.78R34", "1.78R35", "1.78R36", "1.79R1", "1.79R2", "1.79R3", "1.79R4", "1.79R5", "1.8R1", "1.8R2", "1.8R3", "1.8R4", "1.8R5", "1.8R6", "1.8R7"):
            run("tab-appearance175", ["audit162/test_tab_appearance175.py", candidate,
                "--report", output / "tab-appearance175.json"])
        if args.version in ('1.78', '1.78R2', '1.78R3', '1.78R4', '1.78R5', '1.78R6', '1.78R7', '1.78R8', '1.78R9', '1.78R10', '1.78R11', '1.78R12', '1.78R13', '1.78R14', '1.78R15', '1.78R16', '1.78R25', "1.78R26", "1.78R27", "1.78R28", "1.78R29", "1.78R30", "1.78R31", "1.78R32", "1.78R33", "1.78R34", "1.78R35", "1.78R36", "1.79R1", "1.79R2", "1.79R3", "1.79R4", "1.79R5", "1.8R1", "1.8R2", "1.8R3", "1.8R4", "1.8R5", "1.8R6", "1.8R7"):
            run('bottom-appearance178', ['audit162/test_bottom_appearance178.py', candidate,
                '--report', output / 'bottom-appearance178.json'])
            run('reader-controls178', ['audit162/test_reader_controls178.py', candidate,
                '--report', output / 'reader-controls178.json'])
        if args.version in ('1.78R2', '1.78R3', '1.78R4', '1.78R5', '1.78R6', '1.78R7', '1.78R8', '1.78R9', '1.78R10', '1.78R11', '1.78R12', '1.78R13', '1.78R14', '1.78R15', '1.78R16', '1.78R25', "1.78R26", "1.78R27", "1.78R28", "1.78R29", "1.78R30", "1.78R31", "1.78R32", "1.78R33", "1.78R34", "1.78R35", "1.78R36", "1.79R1", "1.79R2", "1.79R3", "1.79R4", "1.79R5", "1.8R1", "1.8R2", "1.8R3", "1.8R4", "1.8R5", "1.8R6", "1.8R7"):
            run('bottom-icons178r2', ['audit162/test_bottom_icons178r2.py', candidate,
                '--report', output / 'bottom-icons178r2.json'])
            run('drama-spacing178r2', ['audit162/test_drama_spacing178r2.py', candidate,
                '--report', output / 'drama-spacing178r2.json'])
        if args.version in ('1.78R7', '1.78R8', '1.78R9', '1.78R10', '1.78R11', '1.78R12', '1.78R13', '1.78R14', '1.78R15', '1.78R16', '1.78R25', "1.78R26", "1.78R27", "1.78R28", "1.78R29", "1.78R30", "1.78R31", "1.78R32", "1.78R33", "1.78R34", "1.78R35", "1.78R36", "1.79R1", "1.79R2", "1.79R3", "1.79R4", "1.79R5", "1.8R1", "1.8R2", "1.8R3", "1.8R4", "1.8R5", "1.8R6", "1.8R7"):
            run('drama-visibility178r7', ['audit162/test_drama_visibility178r7.py', candidate,
                '--report', output / 'drama-visibility178r7.json'])
        if args.version in ('1.78R8', '1.78R9', '1.78R10', '1.78R11', '1.78R12', '1.78R13', '1.78R14', '1.78R15', '1.78R16', '1.78R25', "1.78R26", "1.78R27", "1.78R28", "1.78R29", "1.78R30", "1.78R31", "1.78R32", "1.78R33", "1.78R34", "1.78R35", "1.78R36", "1.79R1", "1.79R2", "1.79R3", "1.79R4", "1.79R5", "1.8R1", "1.8R2", "1.8R3", "1.8R4", "1.8R5", "1.8R6", "1.8R7"):
            run('drama-controls178r8', ['audit162/test_drama_controls178r8.py', candidate,
                '--report', output / 'drama-controls178r8.json'])
        if args.version in ('1.78R9', '1.78R10', '1.78R11', '1.78R12', '1.78R13', '1.78R14', '1.78R15', '1.78R16', '1.78R25', "1.78R26", "1.78R27", "1.78R28", "1.78R29", "1.78R30", "1.78R31", "1.78R32", "1.78R33", "1.78R34", "1.78R35", "1.78R36", "1.79R1", "1.79R2", "1.79R3", "1.79R4", "1.79R5", "1.8R1", "1.8R2", "1.8R3", "1.8R4", "1.8R5", "1.8R6", "1.8R7"):
            for check in ('bottom_feedback178r9', 'landscape_feedback178r9', 'visibility178r9'):
                run(check, ['audit162/test_' + check + '.py', candidate,
                    '--report', output / (check + '.json')])
        if args.version in ('1.78R10', '1.78R11', '1.78R12', '1.78R13', '1.78R14', '1.78R15', '1.78R16', '1.78R25', "1.78R26", "1.78R27", "1.78R28", "1.78R29", "1.78R30", "1.78R31", "1.78R32", "1.78R33", "1.78R34", "1.78R35", "1.78R36", "1.79R1", "1.79R2", "1.79R3", "1.79R4", "1.79R5", "1.8R1", "1.8R2", "1.8R3", "1.8R4", "1.8R5", "1.8R6", "1.8R7"):
            for check in ('reader_back178r10', 'landscape_controls178r10'):
                run(check, ['audit162/test_' + check + '.py', candidate,
                    '--report', output / (check + '.json')])
        if args.version in ('1.78R11', '1.78R12', '1.78R13', '1.78R14', '1.78R15', '1.78R16', '1.78R25', "1.78R26", "1.78R27", "1.78R28", "1.78R29", "1.78R30", "1.78R31", "1.78R32", "1.78R33", "1.78R34", "1.78R35", "1.78R36", "1.79R1", "1.79R2", "1.79R3", "1.79R4", "1.79R5", "1.8R1", "1.8R2", "1.8R3", "1.8R4", "1.8R5", "1.8R6", "1.8R7"):
            for check in ('shelf_selection178r11', 'drama_actions178r11', 'drama_quality178r11', 'drama_clean178r11'):
                run(check, ['audit162/test_' + check + '.py', candidate,
                    '--report', output / (check + '.json')])
        if args.version in ('1.78R13', '1.78R14', '1.78R15', '1.78R16', '1.78R25', "1.78R26", "1.78R27", "1.78R28", "1.78R29", "1.78R30", "1.78R31", "1.78R32", "1.78R33", "1.78R34", "1.78R35", "1.78R36", "1.79R1", "1.79R2", "1.79R3", "1.79R4", "1.79R5", "1.8R1", "1.8R2", "1.8R3", "1.8R4", "1.8R5", "1.8R6", "1.8R7"):
            run('diagnostics-master178r13', ['audit162/test_diagnostics_master178r13.py',
                '--candidate', candidate, '--report', output / 'diagnostics-master178r13.json'])
        if args.version == '1.78R12':
            run('landscape-spacing178r12', ['audit162/test_landscape_spacing178r12.py', candidate,
                '--report', output / 'landscape-spacing178r12.json'])
        if args.version in ('1.78R4', '1.78R5', '1.78R6', '1.78R7', '1.78R8', '1.78R9', '1.78R10', '1.78R11', '1.78R12', '1.78R13', '1.78R14', '1.78R15', '1.78R16', '1.78R25', "1.78R26", "1.78R27", "1.78R28", "1.78R29", "1.78R30", "1.78R31", "1.78R32", "1.78R33", "1.78R34", "1.78R35", "1.78R36", "1.79R1", "1.79R2", "1.79R3", "1.79R4", "1.79R5", "1.8R1", "1.8R2", "1.8R3", "1.8R4", "1.8R5", "1.8R6", "1.8R7"):
            run('bottom-icons178r4', ['audit162/test_bottom_icons178r4.py', candidate,
                '--report', output / 'bottom-icons178r4.json'])
            run('drama-dock178r4', ['audit162/test_drama_dock178r4.py', candidate,
                '--report', output / 'drama-dock178r4.json'])
        if args.version in ('1.78R5', '1.78R6', '1.78R7', '1.78R8', '1.78R9', '1.78R10', '1.78R11', '1.78R12', '1.78R13', '1.78R14', '1.78R15', '1.78R16', '1.78R25', "1.78R26", "1.78R27", "1.78R28", "1.78R29", "1.78R30", "1.78R31", "1.78R32", "1.78R33", "1.78R34", "1.78R35", "1.78R36", "1.79R1", "1.79R2", "1.79R3", "1.79R4", "1.79R5", "1.8R1", "1.8R2", "1.8R3", "1.8R4", "1.8R5", "1.8R6", "1.8R7"):
            run('bottom-interaction178r5', ['audit162/test_bottom_interaction178r5.py', candidate,
                '--report', output / 'bottom-interaction178r5.json'])
        if args.version in ('1.78R25', '1.78R26', "1.78R27", "1.78R28", "1.78R29", "1.78R30", "1.78R31", "1.78R32", "1.78R33", "1.78R34", "1.78R35", "1.78R36", "1.79R1", "1.79R2", "1.79R3", "1.79R4", "1.79R5", "1.8R1", "1.8R2", "1.8R3", "1.8R4", "1.8R5", "1.8R6", "1.8R7"):
            run('drama-dock-touch178r17', ['audit162/test_drama_dock_touch178r17.py', candidate,
                '--report', output / 'drama-dock-touch178r17.json'])
        if args.version in ('1.78R27', '1.78R28', "1.78R29", "1.78R30", "1.78R31", "1.78R32", "1.78R33", "1.78R34", "1.78R35", "1.78R36", "1.79R1", "1.79R2", "1.79R3", "1.79R4", "1.79R5", "1.8R1", "1.8R2", "1.8R3", "1.8R4", "1.8R5", "1.8R6", "1.8R7"):
            run('settings-entry178r27', ['audit162/test_settings_entry178r27.py', candidate,
                '--report', output / 'settings-entry178r27.json'])
        if args.version == '1.78R29':
            run('drama-detail178r29', ['audit162/test_drama_detail178r29.py', candidate,
                '--report', output / 'drama-detail178r29.json'])
            run('settings-export178r29', ['audit162/test_settings_export178r29.py', candidate,
                '--report', output / 'settings-export178r29.json'])
        if args.version in ('1.78R30', '1.78R31'):
            run('drama-detail178r30', ['audit162/test_drama_detail178r30.py', candidate,
                '--report', output / 'drama-detail178r30.json'])
        if args.version in ('1.78R32', '1.78R33', '1.78R34', '1.78R35', '1.78R36', '1.79R1', '1.79R2', '1.79R3', '1.79R4', '1.79R5', '1.8R1', '1.8R2', '1.8R3', '1.8R4', '1.8R5', '1.8R6', '1.8R7'):
            for check in ('drama_header_state178r32', 'drama_navigation178r32'):
                run(check, ['audit162/test_' + check + '.py', candidate,
                    '--report', output / (check + '.json')])
        if args.version in ('1.78R34', '1.78R35', '1.78R36', '1.79R1', '1.79R2', '1.79R3', '1.79R4', '1.79R5', '1.8R1', '1.8R2', '1.8R3', '1.8R4', '1.8R5', '1.8R6', '1.8R7'):
            run('drama-title-spacing178r34', ['audit162/test_drama_title_spacing178r34.py', candidate,
                '--report', output / 'drama-title-spacing178r34.json'])
        if args.version in ('1.78R35', '1.78R36', '1.79R1', '1.79R2', '1.79R3', '1.79R4', '1.79R5', '1.8R1', '1.8R2', '1.8R3', '1.8R4', '1.8R5', '1.8R6', '1.8R7'):
            run('drama-header-palette178r35', ['audit162/test_drama_header_palette178r35.py', candidate,
                '--report', output / 'drama-header-palette178r35.json'])
        if args.version in ('1.78R31', '1.78R32', '1.78R33', '1.78R34', '1.78R35', '1.78R36', '1.79R1', '1.79R2', '1.79R3', '1.79R4', '1.79R5', '1.8R1', '1.8R2', '1.8R3', '1.8R4', '1.8R5', '1.8R6', '1.8R7'):
            run('diagnostic-service178r31', ['audit162/test_diagnostic_service178r31.py', candidate,
                '--report', output / 'diagnostic-service178r31.json'])
        if args.version in ('1.79R1', '1.79R2', '1.79R3', '1.79R4', '1.79R5', '1.8R1', '1.8R2', '1.8R3', '1.8R4', '1.8R5', '1.8R6', '1.8R7'):
            run('fixes-179r1', ['audit162/test_179r1.py', candidate,
                '--report', output / 'fixes-179r1.json'])
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
