#!/usr/bin/env python3
"""Build multi-format distribution packages from a verified FanqieX dylib.

Produces without modifying any Mach-O payload bytes:
  - FanqieX-<version>-rootless.deb  (iphoneos-arm64, /var/jb/Library/MobileSubstrate/DynamicLibraries/)
  - FanqieX-<version>-rootful.deb   (iphoneos-arm,   /Library/MobileSubstrate/DynamicLibraries/)
  - FanqieX-<version>.framework.zip (FanqieX.framework/FanqieX + Info.plist)
"""
from __future__ import annotations

import argparse
import gzip
import hashlib
import io
import json
import plistlib
import tarfile
import zipfile
from pathlib import Path


def sha256_bytes(data: bytes) -> str:
    return hashlib.sha256(data).hexdigest()


def make_filter_plist(bundles: list[str] | None = None) -> bytes:
    payload = {"Filter": {"Bundles": bundles or ["com.dragon.read"]}}
    return plistlib.dumps(payload, fmt=plistlib.FMT_XML, sort_keys=True)


def make_framework_info_plist(version: str) -> bytes:
    short = version.split("R", 1)[0].split("beta", 1)[0].split("-", 1)[0]
    payload = {
        "CFBundleDevelopmentRegion": "en",
        "CFBundleExecutable": "FanqieX",
        "CFBundleIdentifier": "com.solhk.fanqiex.framework",
        "CFBundleInfoDictionaryVersion": "6.0",
        "CFBundleName": "FanqieX",
        "CFBundlePackageType": "FMWK",
        "CFBundleShortVersionString": short,
        "CFBundleVersion": version,
        "MinimumOSVersion": "15.0.1",
    }
    return plistlib.dumps(payload, fmt=plistlib.FMT_XML, sort_keys=True)


def make_tgz(files: dict[str, bytes], executable: set[str] | None = None) -> bytes:
    executable = executable or set()
    tar_buf = io.BytesIO()
    with tarfile.open(fileobj=tar_buf, mode="w", format=tarfile.USTAR_FORMAT) as archive:
        # Emit explicit parent directories so dpkg/Sileo/Zebra extract permissions cleanly.
        dirs: set[str] = set()
        for path in files:
            parts = path.split("/")
            for i in range(1, len(parts)):
                parent = "/".join(parts[:i])
                if parent and parent != ".":
                    dirs.add(parent)
        for d in sorted(dirs):
            info = tarfile.TarInfo(d)
            info.type = tarfile.DIRTYPE
            info.mode = 0o755
            info.mtime = 0
            info.uid = 0
            info.gid = 0
            info.uname = "root"
            info.gname = "wheel"
            archive.addfile(info)
        for name, content in sorted(files.items()):
            info = tarfile.TarInfo(name)
            info.size = len(content)
            info.mode = 0o755 if name in executable else 0o644
            info.mtime = 0
            info.uid = 0
            info.gid = 0
            info.uname = "root"
            info.gname = "wheel"
            archive.addfile(info, io.BytesIO(content))
    gz_buf = io.BytesIO()
    with gzip.GzipFile(fileobj=gz_buf, mode="wb", filename="", mtime=0) as gz:
        gz.write(tar_buf.getvalue())
    return gz_buf.getvalue()


def make_ar(members: list[tuple[str, bytes]]) -> bytes:
    out = bytearray(b"!<arch>\n")
    for name, body in members:
        header = f"{name:<16}{0:<12}{0:<6}{0:<6}{'100644':<8}{len(body):<10}`\n".encode("ascii")
        if len(header) != 60:
            raise ValueError(f"Invalid ar header length for {name}: {len(header)}")
        out.extend(header)
        out.extend(body)
        if len(body) % 2:
            out.extend(b"\n")
    return bytes(out)


def make_deb(dylib_bytes: bytes, version: str, *, rootless: bool) -> bytes:
    arch = "iphoneos-arm64" if rootless else "iphoneos-arm"
    prefix = "./var/jb/Library/MobileSubstrate/DynamicLibraries" if rootless else "./Library/MobileSubstrate/DynamicLibraries"
    dylib_member = f"{prefix}/FanqieX.dylib"
    plist_member = f"{prefix}/FanqieX.plist"
    deb_version = version.replace("R", ".r").replace("beta", "~beta")
    control = (
        f"Package: com.solhk.fanqiex\n"
        f"Name: FanqieX\n"
        f"Version: {deb_version}\n"
        f"Architecture: {arch}\n"
        f"Maintainer: FanqieX\n"
        f"Author: FanqieX\n"
        f"Section: Tweaks\n"
        f"Priority: optional\n"
        f"Depends: mobilesubstrate | ellekit\n"
        f"Description: FanqieX {version} ({'rootless' if rootless else 'rootful'}) enhancement plugin for Fanqie Novel (all versions).\n"
    ).encode("utf-8")
    control_tgz = make_tgz({"./control": control})
    data_tgz = make_tgz(
        {dylib_member: dylib_bytes, plist_member: make_filter_plist()},
        executable={dylib_member},
    )
    return make_ar([
        ("debian-binary", b"2.0\n"),
        ("control.tar.gz", control_tgz),
        ("data.tar.gz", data_tgz),
    ])


def make_framework_zip(dylib_bytes: bytes, version: str) -> bytes:
    out = io.BytesIO()
    files = {
        "FanqieX.framework/FanqieX": (dylib_bytes, 0o100755),
        "FanqieX.framework/Info.plist": (make_framework_info_plist(version), 0o100644),
    }
    with zipfile.ZipFile(out, "w", compression=zipfile.ZIP_DEFLATED, compresslevel=9) as zf:
        for name, (body, mode) in sorted(files.items()):
            info = zipfile.ZipInfo(name, (1980, 1, 1, 0, 0, 0))
            info.compress_type = zipfile.ZIP_DEFLATED
            info.create_system = 3
            info.external_attr = mode << 16
            zf.writestr(info, body)
    return out.getvalue()


def verify_deb(deb_bytes: bytes, expected_dylib_sha: str, expected_member: str) -> dict:
    if not deb_bytes.startswith(b"!<arch>\n"):
        raise ValueError("Invalid deb ar magic")
    pos = 8
    members: dict[str, bytes] = {}
    while pos < len(deb_bytes):
        hdr = deb_bytes[pos : pos + 60]
        if len(hdr) != 60 or hdr[58:60] != b"`\n":
            raise ValueError(f"Invalid ar member header at {pos}")
        name = hdr[:16].decode("ascii").strip().rstrip("/")
        size = int(hdr[48:58].decode("ascii").strip())
        body = deb_bytes[pos + 60 : pos + 60 + size]
        if len(body) != size:
            raise ValueError(f"Truncated ar member {name}")
        members[name] = body
        pos += 60 + size + (size % 2)
    if members.get("debian-binary") != b"2.0\n":
        raise ValueError("Unexpected debian-binary")
    with tarfile.open(fileobj=io.BytesIO(members["control.tar.gz"]), mode="r:gz") as ctar:
        control_text = ctar.extractfile("./control").read().decode("utf-8")
    with tarfile.open(fileobj=io.BytesIO(members["data.tar.gz"]), mode="r:gz") as dtar:
        dylib = dtar.extractfile(expected_member).read()
        plist_member = expected_member.rsplit(".", 1)[0] + ".plist"
        plist_data = plistlib.loads(dtar.extractfile(plist_member).read())
    actual_sha = sha256_bytes(dylib)
    if actual_sha != expected_dylib_sha:
        raise ValueError(f"Embedded dylib SHA mismatch: {actual_sha} != {expected_dylib_sha}")
    if "com.dragon.read" not in plist_data.get("Filter", {}).get("Bundles", []):
        raise ValueError("Missing com.dragon.read in FanqieX.plist")
    return {"control": control_text.strip(), "member": expected_member, "embedded_dylib_sha256": actual_sha}


def verify_framework_zip(zip_bytes: bytes, expected_dylib_sha: str) -> dict:
    with zipfile.ZipFile(io.BytesIO(zip_bytes), "r") as zf:
        bin_bytes = zf.read("FanqieX.framework/FanqieX")
        info = plistlib.loads(zf.read("FanqieX.framework/Info.plist"))
    actual_sha = sha256_bytes(bin_bytes)
    if actual_sha != expected_dylib_sha:
        raise ValueError(f"Framework binary SHA mismatch: {actual_sha} != {expected_dylib_sha}")
    return {"bundle_id": info["CFBundleIdentifier"], "version": info["CFBundleVersion"], "embedded_dylib_sha256": actual_sha}


def package_all(dylib_path: Path, version: str, out_dir: Path) -> dict:
    dylib_bytes = dylib_path.read_bytes()
    dylib_sha = sha256_bytes(dylib_bytes)
    out_dir.mkdir(parents=True, exist_ok=True)

    rootless_bytes = make_deb(dylib_bytes, version, rootless=True)
    rootful_bytes = make_deb(dylib_bytes, version, rootless=False)
    fw_bytes = make_framework_zip(dylib_bytes, version)

    v_rootless = verify_deb(rootless_bytes, dylib_sha, "./var/jb/Library/MobileSubstrate/DynamicLibraries/FanqieX.dylib")
    v_rootful = verify_deb(rootful_bytes, dylib_sha, "./Library/MobileSubstrate/DynamicLibraries/FanqieX.dylib")
    v_fw = verify_framework_zip(fw_bytes, dylib_sha)

    outputs = {
        f"FanqieX-{version}-rootless.deb": rootless_bytes,
        f"FanqieX-{version}-rootful.deb": rootful_bytes,
        f"FanqieX-{version}.framework.zip": fw_bytes,
    }
    report = {"version": version, "source_dylib_sha256": dylib_sha, "packages": {}}
    for fname, body in outputs.items():
        target = out_dir / fname
        target.write_bytes(body)
        report["packages"][fname] = {"size": len(body), "sha256": sha256_bytes(body)}
    report["verification"] = {"rootless": v_rootless, "rootful": v_rootful, "framework": v_fw}
    return report


def main() -> int:
    parser = argparse.ArgumentParser(description=__doc__)
    parser.add_argument("--dylib", type=Path, required=True)
    parser.add_argument("--version", required=True)
    parser.add_argument("--output", type=Path, required=True)
    args = parser.parse_args()
    report = package_all(args.dylib, args.version, args.output)
    print(json.dumps(report, ensure_ascii=False, indent=2))
    return 0


if __name__ == "__main__":
    raise SystemExit(main())
