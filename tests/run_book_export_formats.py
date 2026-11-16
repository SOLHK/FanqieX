#!/usr/bin/env python3
"""Run novel export format and local source fixtures on real Foundation."""
from __future__ import annotations

import argparse
import hashlib
import json
import os
from pathlib import Path
import platform
import posixpath
import struct
import subprocess
import tempfile
import xml.etree.ElementTree as ET
import zipfile


ROOT = Path(__file__).resolve().parents[1]


def validate_format_artifacts(folder):
    for suffix in ("txt", "md", "html", "epub", "json"):
        if not (folder / ("fixture." + suffix)).is_file():
            raise ValueError("The Foundation test omitted an export format: " + suffix)
    for suffix in ("txt", "md", "html"):
        if not (folder / ("fixture." + suffix)).read_text(encoding="utf-8").strip():
            raise ValueError("The exported text file is empty: " + suffix)
    document = json.loads((folder / "fixture.json").read_text(encoding="utf-8"))
    chapters = document.get("chapters")
    if not isinstance(chapters, list) or len(chapters) != 2:
        raise ValueError("The JSON fixture must contain both ordered chapters")
    if any(not isinstance(chapter.get("title"), str) or
           not isinstance(chapter.get("paragraphs"), list) or
           any(not isinstance(paragraph, str) for paragraph in chapter["paragraphs"])
           for chapter in chapters):
        raise ValueError("The JSON chapter or paragraph schema is invalid")
    epub = folder / "fixture.epub"
    with zipfile.ZipFile(epub) as archive:
        infos = archive.infolist()
        names = archive.namelist()
        if archive.testzip() is not None or len(names) != len(set(names)):
            raise ValueError("The EPUB has corrupt CRCs or duplicate entries")
        first = infos[0]
        if (first.filename != "mimetype" or first.header_offset != 0 or
                first.compress_type != zipfile.ZIP_STORED or first.extra or first.flag_bits & 8 or
                archive.read(first) != b"application/epub+zip"):
            raise ValueError("The EPUB mimetype entry violates its required stored-first layout")
        header = struct.unpack_from("<IHHHHHIIIHH", epub.read_bytes())
        if header[0] != 0x04034B50 or header[2] & 8 or header[3] != 0 or header[9:] != (8, 0):
            raise ValueError("The EPUB mimetype local header contains compression or extra fields")
        xml = {name: ET.fromstring(archive.read(name))
               for name in names if name.endswith((".xml", ".xhtml", ".opf"))}
        container = xml["META-INF/container.xml"]
        rootfile = container.find(".//{urn:oasis:names:tc:opendocument:xmlns:container}rootfile")
        if rootfile is None:
            raise ValueError("The EPUB container omits its package")
        package_name = rootfile.attrib["full-path"]
        package = xml[package_name]
        namespace = {"opf": "http://www.idpf.org/2007/opf",
                     "xhtml": "http://www.w3.org/1999/xhtml"}
        items = {item.attrib["id"]: item for item in package.findall("opf:manifest/opf:item", namespace)}
        if not items or not any("nav" in item.attrib.get("properties", "").split()
                                for item in items.values()):
            raise ValueError("The EPUB manifest omits navigation")
        spine = package.findall("opf:spine/opf:itemref", namespace)
        if len(spine) != len(chapters):
            raise ValueError("The EPUB spine loses chapter ordering or content")
        base = posixpath.dirname(package_name)
        for item in items.values():
            target = posixpath.normpath(posixpath.join(base, item.attrib["href"]))
            if target not in names:
                raise ValueError("The EPUB manifest points to a missing item")
        for reference, chapter in zip(spine, chapters):
            item = items[reference.attrib["idref"]]
            target = posixpath.normpath(posixpath.join(base, item.attrib["href"]))
            title = xml[target].find("xhtml:head/xhtml:title", namespace)
            if title is None or title.text != chapter["title"]:
                raise ValueError("The EPUB chapter title differs from the JSON export")
    return {"json_chapters": len(chapters), "epub_entries": len(names),
            "epub_crc_and_xml": True, "mimetype_stored_first": True}


def main():
    parser = argparse.ArgumentParser(description=__doc__)
    parser.add_argument("--output", type=Path, default=ROOT / "build/book-export-smoke")
    args = parser.parse_args()
    output = args.output.resolve()
    output.mkdir(parents=True, exist_ok=True)
    report = {"passed": False, "real_foundation_executed": False,
              "github_sha": os.environ.get("GITHUB_SHA"),
              "device_tested": False, "cases": []}
    try:
        if platform.system() != "Darwin":
            raise RuntimeError("Real Foundation export tests require macOS")
        source_paths = [ROOT / ("native/BookExport" + suffix)
                        for suffix in ("Formats.m", "Formats.h", "Source.m", "Source.h")]
        source_paths.extend(ROOT / ("tests/" + name)
                            for name in ("book_export_formats.m", "book_export_source.m",
                                         "run_book_export_formats.py"))
        source_hashes = {path.relative_to(ROOT).as_posix(): hashlib.sha256(path.read_bytes()).hexdigest()
                         for path in source_paths}
        for name in ("formats", "source"):
            binary = output / ("book-export-" + name)
            sources = [ROOT / "native/BookExportFormats.m", ROOT / f"tests/book_export_{name}.m"]
            if name == "source":
                sources.append(ROOT / "native/BookExportSource.m")
            compile_log = output / (name + "-compile.log")
            compile_result = subprocess.run(
                ["xcrun", "--sdk", "macosx", "clang", "-fobjc-arc", "-fblocks",
                 "-Wall", "-Wextra", "-Werror", "-Os", "-I", str(ROOT / "native"),
                 *map(str, sources), "-framework", "Foundation", "-o", str(binary)],
                capture_output=True, text=True, encoding="utf-8")
            compile_log.write_text(compile_result.stdout + compile_result.stderr, encoding="utf-8")
            compile_result.check_returncode()
            with tempfile.TemporaryDirectory(prefix=name + "-", dir=output) as scratch:
                result = subprocess.run([str(binary), scratch], cwd=scratch,
                                        capture_output=True, text=True, encoding="utf-8")
                (output / (name + "-run.log")).write_text(result.stdout + result.stderr,
                                                        encoding="utf-8")
                result.check_returncode()
                validation = validate_format_artifacts(Path(scratch)) if name == "formats" else None
                artifacts = {
                    path.relative_to(scratch).as_posix(): hashlib.sha256(path.read_bytes()).hexdigest()
                    for path in sorted(Path(scratch).rglob("*")) if path.is_file()
                }
            report["cases"].append({"name": name, "passed": True, "artifacts": artifacts,
                                    "independent_format_validation": validation})
        if any(hashlib.sha256((ROOT / name).read_bytes()).hexdigest() != digest
               for name, digest in source_hashes.items()):
            raise ValueError("Export test sources changed during execution")
        report.update(passed=True, real_foundation_executed=True, source_sha256=source_hashes)
        return 0
    except Exception as error:
        report["error"] = str(error)
        return 1
    finally:
        (output / "book-export-smoke.json").write_text(
            json.dumps(report, ensure_ascii=False, indent=2) + "\n", encoding="utf-8")
        print(json.dumps(report, ensure_ascii=False, indent=2))


if __name__ == "__main__":
    raise SystemExit(main())
