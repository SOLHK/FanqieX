#!/usr/bin/env python3
"""Build the independent ARC Objective-C novel export companion."""
from __future__ import annotations

import argparse
import hashlib
import json
import os
from pathlib import Path
import platform
import re
import struct
import subprocess
import sys


ROOT = Path(__file__).resolve().parents[1]
INSTALL_NAME = "@rpath/FanqieXExport.dylib"
SOURCE_FILES = ("native/BookExport.m", "native/BookExportFormats.m", "native/BookExportFormats.h",
                "native/BookExportSource.m", "native/BookExportSource.h")
FRAMEWORKS = ("Foundation", "UIKit", "CoreGraphics")


def source_manifest():
    paths = [*SOURCE_FILES, "scripts/build_book_export.py"]
    return {name: hashlib.sha256((ROOT / name).read_bytes()).hexdigest() for name in paths}


def command(arguments):
    result = subprocess.run([str(value) for value in arguments], check=True,
                            capture_output=True, text=True, encoding="utf-8")
    return result.stdout.strip()


def validate_binary(path):
    sys.path.insert(0, str(ROOT / "repair162"))
    from macho_tools import macho_commands, sections, verify_signature
    data = path.read_bytes()
    if struct.unpack_from("<4I", data)[:4] != (0xFEEDFACF, 0x100000C, 0, 6):
        raise ValueError("Export companion must be an ARM64 Mach-O dylib")
    identity = []
    libraries = []
    for kind, offset, _ in macho_commands(data):
        if kind in (0xD, 0xC, 0x80000018):
            relative = struct.unpack_from("<I", data, offset + 8)[0]
            name = data[offset + relative:data.index(b"\0", offset + relative)].decode()
            (identity if kind == 0xD else libraries).append(name)
    if identity != [INSTALL_NAME]:
        raise ValueError("Unexpected export companion install name")
    if any(not name.startswith(("/usr/lib/", "/System/Library/")) for name in libraries):
        raise ValueError("Export companion has a non-system dynamic dependency")
    names = {section["name"] for section in sections(data)}
    if not {"__objc_classlist", "__objc_imageinfo", "__text"} <= names:
        raise ValueError("Export companion lacks linked Objective-C metadata")
    signature = verify_signature(data)
    if not signature["page_hashes_valid"]:
        raise ValueError("Export companion signature page hashes failed")
    return {"sha256": hashlib.sha256(data).hexdigest(), "size_bytes": len(data),
            "install_name": INSTALL_NAME, "libraries": libraries,
            "objc_metadata": True, "signature_page_hashes_valid": True}


def validated_bundle(folder, expected_commit=None):
    report = json.loads((folder / "book-export-build-report.json").read_text(encoding="utf-8"))
    binary = folder / "FanqieXExport.dylib"
    if not report.get("passed") or not report.get("two_builds_identical"):
        raise ValueError("Export companion lacks a successful reproducible build")
    if expected_commit and report.get("github_sha") != expected_commit:
        raise ValueError("Export companion belongs to a different source commit")
    if report.get("source_sha256") != source_manifest():
        raise ValueError("Export companion sources differ from the current checkout")
    validation = validate_binary(binary)
    if report.get("binary") != validation:
        raise ValueError("Export companion differs from its build report")
    smoke = json.loads((folder / "book-export-smoke.json").read_text(encoding="utf-8"))
    if not smoke.get("passed") or not smoke.get("real_foundation_executed"):
        raise ValueError("Export companion lacks real Foundation format and source tests")
    if expected_commit and smoke.get("github_sha") != expected_commit:
        raise ValueError("Export tests belong to a different source commit")
    smoke_sources = ["native/BookExport" + suffix
                     for suffix in ("Formats.m", "Formats.h", "Source.m", "Source.h")]
    smoke_sources.extend("tests/" + name for name in
                         ("book_export_formats.m", "book_export_source.m", "run_book_export_formats.py"))
    smoke_hashes = smoke.get("source_sha256", {})
    if set(smoke_hashes) != set(smoke_sources) or any(
            hashlib.sha256((ROOT / name).read_bytes()).hexdigest() != digest or
            (name in report["source_sha256"] and report["source_sha256"][name] != digest)
            for name, digest in smoke_hashes.items()):
        raise ValueError("Export format and source tests do not match the built sources")
    return binary, report


def build(output, sdk, link_sdk, compiler, linker, sdk_version):
    objects = []
    for name in SOURCE_FILES:
        if not name.endswith(".m"):
            continue
        target = output / (Path(name).stem + ".o")
        command([*compiler, "-target", "arm64-apple-ios15.0", "-isysroot", sdk,
                 "-fobjc-arc", "-fblocks", "-fvisibility=hidden",
                 "-Wall", "-Wextra", "-Werror", "-Os", "-c", ROOT / name, "-o", target])
        objects.append(target)
    binary = output / "FanqieXExport.dylib"
    arguments = [*linker, "-dylib", "-arch", "arm64", "-platform_version", "ios", "15.0",
                 sdk_version, "-syslibroot", link_sdk, "-install_name", INSTALL_NAME,
                 "-no_uuid", "-adhoc_codesign", "-o", binary, *objects]
    for name in FRAMEWORKS:
        arguments.extend(("-framework", name))
    command([*arguments, "-lobjc", "-lSystem"])
    return binary


def main():
    parser = argparse.ArgumentParser(description=__doc__)
    parser.add_argument("--output", type=Path, default=ROOT / "build/xcode27")
    parser.add_argument("--sdk", type=Path)
    parser.add_argument("--link-sdk", type=Path,
                        help="Resolved SDK linker stubs for a Windows SDK checkout")
    parser.add_argument("--clang", type=Path)
    parser.add_argument("--linker", type=Path)
    args = parser.parse_args()
    output = args.output.resolve()
    output.mkdir(parents=True, exist_ok=True)
    report = {"passed": False, "github_sha": os.environ.get("GITHUB_SHA"),
              "device_tested": False, "platform": platform.platform()}
    try:
        if platform.system() == "Darwin":
            sdk = args.sdk or Path(command(["xcrun", "--sdk", "iphoneos", "--show-sdk-path"]))
            compiler = [args.clang] if args.clang else ["xcrun", "--sdk", "iphoneos", "clang"]
            linker = [args.linker] if args.linker else ["xcrun", "--sdk", "iphoneos", "ld"]
            report["toolchain"] = command(["xcodebuild", "-version"])
        else:
            if not all((args.sdk, args.clang, args.linker)):
                parser.error("Local cross-builds require --sdk, --clang and --linker")
            sdk, compiler, linker = args.sdk, [args.clang], [args.linker]
            report["toolchain"] = command([args.clang, "--version"]).splitlines()[0]
        sdk = sdk.resolve()
        settings = json.loads((sdk / "SDKSettings.json").read_text(encoding="utf-8"))
        sdk_version = settings["Version"]
        if not re.fullmatch(r"\d+\.\d+(?:\.\d+)?", sdk_version):
            raise ValueError("Unexpected SDK version")
        report["sdk_version"] = sdk_version
        sources = source_manifest()
        binary = build(output, sdk, args.link_sdk or sdk, compiler, linker, sdk_version)
        rebuilt_dir = output / "export-rebuild"
        rebuilt_dir.mkdir(exist_ok=True)
        rebuilt = build(rebuilt_dir, sdk, args.link_sdk or sdk, compiler, linker, sdk_version)
        if binary.read_bytes() != rebuilt.read_bytes():
            raise ValueError("Two export companion builds produced different bytes")
        if source_manifest() != sources:
            raise ValueError("Export companion sources changed during the build")
        report.update(binary=validate_binary(binary), source_sha256=sources,
                      two_builds_identical=True, passed=True)
        return 0
    except Exception as error:
        report["error"] = str(error)
        if isinstance(error, subprocess.CalledProcessError):
            report["compiler_output"] = error.stdout + error.stderr
        return 1
    finally:
        (output / "book-export-build-report.json").write_text(
            json.dumps(report, ensure_ascii=False, indent=2) + "\n", encoding="utf-8")
        print(json.dumps(report, ensure_ascii=False, indent=2))


if __name__ == "__main__":
    raise SystemExit(main())
