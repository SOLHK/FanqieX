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
from uuid import UUID


ROOT = Path(__file__).resolve().parents[1]
INSTALL_NAME = "@rpath/FanqieXExport.dylib"
INTEGRATED_RELEASES = {0x14E0F: "1.78R15", 0x14E10: "1.78R16", 0x14E13: "1.78R19", 0x14E14: "1.78R20", 0x14E15: "1.78R21", 0x14E16: "1.78R22", 0x14E17: "1.78R23", 0x14E18: "1.78R24", 0x14E19: "1.78R25", 0x14E1A: "1.78R26", 0x14E1B: "1.78R27", 0x14E1C: "1.78R28", 0x14E1D: "1.78R29", 0x14E1E: "1.78R30", 0x14E1F: "1.78R31", 0x14E20: "1.78R32", 0x14E21: "1.78R33", 0x14E22: "1.78R34", 0x14E23: "1.78R35", 0x14E24: "1.78R36", 0x14F01: "1.79R1", 0x14F02: "1.79R2", 0x14F03: "1.79R3", 0x14F04: "1.79R4", 0x14F05: "1.79R5", 0x15001: "1.8R1", 0x15002: "1.8R2", 0x15003: "1.8R3", 0x15004: "1.8R4", 0x15005: "1.8R5", 0x15006: "1.8R6", 0x15007: "1.8R7", 0x15008: "1.8R8", 0x15009: "1.8R9", 0x1500A: "1.8R10", 0x1500B: "1.8R11", 0x1500C: "1.8R12", 0x1500D: "1.8R13", 0x1500E: "1.8R14", 0x1500F: "1.8R15", 0x15010: "1.8R16", 0x15011: "1.8R17", 0x15012: "1.8R18", 0x15013: "1.8R19", 0x15101: "1.9.1beta1", 0x15102: "1.9.1beta2", 0x15103: "1.9.1beta3", 0x15104: "1.9.1beta4", 0x15105: "1.9.1beta5", 0x15106: "1.9.1beta6", 0x15107: "1.9.1beta7", 0x15108: "1.9.1beta8", 0x15109: "1.9.1beta9", 0x1510A: "1.9.1beta10", 0x1510B: "1.9.1beta11", 0x1510C: "1.9.1beta12", 0x1510D: "1.9.1beta13", 0x1510E: "1.9.1beta14", 0x1510F: "1.9.1beta15", 0x15110: "1.9.1beta16", 0x15111: "1.9.1beta17"}
SOURCE_FILES = ("native/BookExport.m", "native/BookExportFormats.m", "native/BookExportFormats.h",
                "native/BookExportSource.m", "native/BookExportSource.h", "native/FQXHookInstaller.m", "native/FQXHookInstaller.h")
SETTINGS_FILES = ("native/FanqieXSettingsBackup.m", "native/FanqieXSettingsCodec.c", "native/FanqieXSettingsCodec.h",
                  "native/FanqieXNavigationPreferences.m", "native/NavigationPreferenceLogic.h")
SETTINGS_INSTALL_NAME = "@rpath/FanqieX-1.78R23.dylib"
VIDEO_EXPORT_INSTALL_NAMES = ("@rpath/FanqieX-1.78R24.dylib", "@rpath/FanqieX-1.78R25.dylib", "@rpath/FanqieX-1.78R26.dylib", "@rpath/FanqieX-1.78R27.dylib", "@rpath/FanqieX-1.78R28.dylib", "@rpath/FanqieX-1.78R29.dylib", "@rpath/FanqieX-1.78R30.dylib", "@rpath/FanqieX-1.78R31.dylib", "@rpath/FanqieX-1.78R32.dylib", "@rpath/FanqieX-1.78R33.dylib", "@rpath/FanqieX-1.78R34.dylib", "@rpath/FanqieX-1.78R35.dylib", "@rpath/FanqieX-1.78R36.dylib", "@rpath/FanqieX-1.79R1.dylib", "@rpath/FanqieX-1.79R2.dylib", "@rpath/FanqieX-1.79R3.dylib", "@rpath/FanqieX-1.79R4.dylib", "@rpath/FanqieX-1.79R5.dylib", "@rpath/FanqieX-1.8R1.dylib", "@rpath/FanqieX-1.8R2.dylib", "@rpath/FanqieX-1.8R3.dylib", "@rpath/FanqieX-1.8R4.dylib", "@rpath/FanqieX-1.8R5.dylib", "@rpath/FanqieX-1.8R6.dylib", "@rpath/FanqieX-1.8R7.dylib", "@rpath/FanqieX-1.8R8.dylib", "@rpath/FanqieX-1.8R9.dylib", "@rpath/FanqieX-1.8R10.dylib", "@rpath/FanqieX-1.8R11.dylib", "@rpath/FanqieX-1.8R12.dylib", "@rpath/FanqieX-1.8R13.dylib", "@rpath/FanqieX-1.8R14.dylib", "@rpath/FanqieX-1.8R15.dylib", "@rpath/FanqieX-1.8R16.dylib", "@rpath/FanqieX-1.8R17.dylib", "@rpath/FanqieX-1.8R18.dylib", "@rpath/FanqieX-1.8R19.dylib", "@rpath/FanqieX-1.9.1beta1.dylib", "@rpath/FanqieX-1.9.1beta2.dylib", "@rpath/FanqieX-1.9.1beta3.dylib", "@rpath/FanqieX-1.9.1beta4.dylib", "@rpath/FanqieX-1.9.1beta5.dylib", "@rpath/FanqieX-1.9.1beta6.dylib", "@rpath/FanqieX-1.9.1beta7.dylib", "@rpath/FanqieX-1.9.1beta8.dylib", "@rpath/FanqieX-1.9.1beta9.dylib", "@rpath/FanqieX-1.9.1beta10.dylib", "@rpath/FanqieX-1.9.1beta11.dylib", "@rpath/FanqieX-1.9.1beta12.dylib", "@rpath/FanqieX-1.9.1beta13.dylib", "@rpath/FanqieX-1.9.1beta14.dylib", "@rpath/FanqieX-1.9.1beta15.dylib", "@rpath/FanqieX-1.9.1beta16.dylib", "@rpath/FanqieX-1.9.1beta17.dylib")
VIDEO_EXPORT_FILES = ("native/FanqieXSettingsMenu.m", "native/FanqieXCleanup.m",
                      "native/FanqieXVideoExport.m", "native/VideoContainer.h", "native/FanqieXMotion.m", "native/FQXContentCleanup.m",
                      "native/FQXBlurControl.h", "native/FQXMineShortcutGeometry.h")
FRAMEWORKS = ("Foundation", "UIKit", "CoreGraphics")


def integrated_release(core):
    if len(core) < 0x81C:
        raise ValueError("Truncated FanqieX core")
    word, = struct.unpack_from("<I", core, 0x818)
    release = INTEGRATED_RELEASES.get(word)
    if not release:
        raise ValueError("Unsupported FanqieX core release for integrated export")
    return release


def source_files(install_name):
    if install_name in VIDEO_EXPORT_INSTALL_NAMES:
        return SOURCE_FILES + SETTINGS_FILES + VIDEO_EXPORT_FILES
    return SOURCE_FILES + SETTINGS_FILES if install_name == SETTINGS_INSTALL_NAME else SOURCE_FILES


def source_manifest(install_name=INSTALL_NAME):
    paths = [*source_files(install_name), "scripts/build_book_export.py", "scripts/merge_book_export.py"]
    return {name: hashlib.sha256((ROOT / name).read_bytes()).hexdigest() for name in paths}


def command(arguments):
    result = subprocess.run([str(value) for value in arguments], check=True,
                            capture_output=True, text=True, encoding="utf-8")
    return result.stdout.strip()


def validate_binary(path, install_name=INSTALL_NAME):
    sys.path.insert(0, str(ROOT / "repair162"))
    from macho_tools import macho_commands, sections, verify_signature
    data = path.read_bytes()
    if struct.unpack_from("<4I", data)[:4] != (0xFEEDFACF, 0x100000C, 0, 6):
        raise ValueError("Export companion must be an ARM64 Mach-O dylib")
    identity = []
    libraries = []
    uuids = []
    for kind, offset, size in macho_commands(data):
        if kind in (0xD, 0xC, 0x80000018):
            relative = struct.unpack_from("<I", data, offset + 8)[0]
            name = data[offset + relative:data.index(b"\0", offset + relative)].decode()
            (identity if kind == 0xD else libraries).append(name)
        elif kind == 0x1B and size == 24:
            uuids.append(data[offset + 8:offset + size])
    if len(uuids) != 1 or not any(uuids[0]):
        raise ValueError("Missing or invalid LC_UUID required by dyld")
    if identity != [install_name]:
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
            "install_name": install_name, "uuid": str(UUID(bytes=uuids[0])), "libraries": libraries,
            "objc_metadata": True, "signature_page_hashes_valid": True}


def validated_bundle(folder, expected_commit=None, *, expected_core_sha256=None, expected_version=None):
    build = folder / "integrated" if expected_core_sha256 else folder
    if expected_core_sha256 and expected_version not in INTEGRATED_RELEASES.values():
        raise ValueError("Expected a supported integrated FanqieX release")
    install = f"@rpath/FanqieX-{expected_version}.dylib" if expected_core_sha256 else INSTALL_NAME
    report = json.loads((build / "book-export-build-report.json").read_text(encoding="utf-8"))
    binary = build / install.rsplit("/", 1)[-1]
    if not report.get("passed") or not report.get("two_builds_identical"):
        raise ValueError("Export companion lacks a successful reproducible build")
    if expected_commit and report.get("github_sha") != expected_commit:
        raise ValueError("Export companion belongs to a different source commit")
    if report.get("source_sha256") != source_manifest(install):
        raise ValueError("Export companion sources differ from the current checkout")
    validation = validate_binary(binary, install)
    if report.get("binary") != validation:
        raise ValueError("Export companion differs from its build report")
    if expected_core_sha256:
        combined = report.get("combined_image", {})
        if (not combined.get("passed") or combined.get("version") != expected_version
                or combined.get("core_input_sha256") != expected_core_sha256
                or combined.get("sha256") != validation["sha256"]):
            raise ValueError("Combined export image does not contain the verified FanqieX core")
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


def build(output, sdk, link_sdk, compiler, linker, sdk_version, install_name=INSTALL_NAME):
    objects = []
    for name in source_files(install_name):
        extension = Path(name).suffix
        if extension not in (".m", ".c"):
            continue
        target = output / (Path(name).stem + ".o")
        flags = ("-fobjc-arc", "-fblocks") if extension == ".m" else ("-std=c11",)
        command([*compiler, "-target", "arm64-apple-ios15.0.1", "-isysroot", sdk,
                 *flags, "-fvisibility=hidden",
                 "-Wall", "-Wextra", "-Werror", "-Oz", "-c", ROOT / name, "-o", target])
        objects.append(target)
    binary = output / install_name.rsplit("/", 1)[-1]
    arguments = [*linker, "-dylib", "-arch", "arm64", "-x", "-platform_version", "ios", "15.0.1",
                 sdk_version, "-syslibroot", link_sdk, "-install_name", install_name,
                 "-adhoc_codesign", "-o", binary, *objects]
    if install_name != INSTALL_NAME:
        reserve = output / "unwind-reserve.bin"
        reserve.write_bytes(bytes(0x8000))
        arguments.extend(("-headerpad", "0x2000", "-sectcreate", "__TEXT", "__fq_unwind", reserve))
    for name in FRAMEWORKS:
        arguments.extend(("-framework", name))
    if install_name == SETTINGS_INSTALL_NAME or install_name in VIDEO_EXPORT_INSTALL_NAMES:
        arguments.extend(("-framework", "CoreFoundation", "-framework", "UniformTypeIdentifiers", "-lz"))
    if install_name in VIDEO_EXPORT_INSTALL_NAMES:
        arguments.extend(("-framework", "AVFoundation", "-framework", "QuartzCore"))
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
    parser.add_argument("--core", type=Path, help="Combine this supported FanqieX core into one dylib")
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
        if args.core:
            core = args.core.read_bytes()
            version = integrated_release(core)
            install_name = f"@rpath/FanqieX-{version}.dylib"
            build_dir = output / "export-link"
            build_dir.mkdir(exist_ok=True)
        else:
            install_name, build_dir = INSTALL_NAME, output
        sources = source_manifest(install_name)
        binary = build(build_dir, sdk, args.link_sdk or sdk, compiler, linker, sdk_version, install_name)
        rebuilt_dir = output / "export-rebuild"
        rebuilt_dir.mkdir(exist_ok=True)
        rebuilt = build(rebuilt_dir, sdk, args.link_sdk or sdk, compiler, linker, sdk_version, install_name)
        if binary.read_bytes() != rebuilt.read_bytes():
            raise ValueError("Two export companion builds produced different bytes")
        if source_manifest(install_name) != sources:
            raise ValueError("Export companion sources changed during the build")
        if args.core:
            from merge_book_export import merge, segments
            # Keep the linker's real segment layout in failed build reports.
            # The integration checks rely on both VM and file coordinates;
            # recording them does not relax any input or output validation.
            report["input_mappings"] = {
                label: {
                    "sha256": hashlib.sha256(data).hexdigest(),
                    "size_bytes": len(data),
                    "segments": [
                        {key: item[key] for key in
                         ("name", "vmaddr", "vmsize", "fileoff", "filesize",
                          "maxprot", "initprot")}
                        for item in segments(data)
                    ],
                }
                for label, data in (("core", core), ("export", binary.read_bytes()))
            }
            merged, verification = merge(core, binary.read_bytes())
            rebuilt_image, _ = merge(core, rebuilt.read_bytes())
            if merged != rebuilt_image:
                raise ValueError("Two combined builds produced different bytes")
            binary = output / binary.name
            binary.write_bytes(merged)
            report["combined_image"] = verification
        report.update(binary=validate_binary(binary, install_name),
                      source_sha256=sources, two_builds_identical=True, passed=True)
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
