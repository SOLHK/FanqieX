"""Run the production defaults observer with a blocked main thread on Darwin."""
from pathlib import Path
import os
import platform
import re
import shutil
import subprocess
import tempfile
import unittest


TESTS = Path(__file__).resolve().parent
SOURCE = TESTS.parent / "native" / "FQXContentCleanup.m"


class PendantStartupNotificationTests(unittest.TestCase):
    def test_background_delivery_and_coalescing(self):
        source = SOURCE.read_text(encoding="utf-8")
        installer = source[source.index("void FQXInstallContentCleanupHooks(void){"):]
        start = installer.index("atomic_store_explicit(&sLastObservedGateStateMask")
        end = installer.index("}];", start) + len("}];")
        observer = installer[start:end]

        darwin = platform.system() == "Darwin"
        if darwin:
            compiler = ["xcrun", "--sdk", "macosx", "clang", "-fobjc-arc",
                        "-framework", "Foundation", "-DREAL_FOUNDATION", "-x", "objective-c"]
        else:
            # Substitute only Foundation's registration message. The posted block,
            # atomic state and queued block are compiled from the shipping source.
            observer, replaced = re.subn(
                r"\[NSNotificationCenter\.defaultCenter\s+addObserverForName:"
                r"NSUserDefaultsDidChangeNotification\s+object:nil\s+queue:nil\s+"
                r"usingBlock:\^\(__unused NSNotification \*note\)",
                "onNotification = ^(void)", observer)
            self.assertEqual(replaced, 1, "Posting must not wait for a main-queue observer")
            observer = observer.removesuffix("}];") + "};"
            clang = shutil.which("clang")
            if not clang and os.name == "nt":
                clang = Path(os.environ["ProgramFiles"]) / "LLVM/bin/clang.exe"
            if not clang or not Path(clang).is_file():
                self.skipTest("Clang with blocks support is required for the queue fixture")
            compiler = [str(clang), "-x", "c"]

        with tempfile.TemporaryDirectory() as directory:
            folder = Path(directory)
            (folder / "defaults_observer.inc").write_text(observer, encoding="utf-8")
            program = folder / ("startup-test.exe" if os.name == "nt" else "startup-test")
            subprocess.run([*compiler, "-std=c11", "-fblocks", "-Wall", "-Wextra", "-Werror",
                            "-I", directory, str(TESTS / "pendant_notification_smoke.m"),
                            "-o", str(program)], check=True)
            subprocess.run([str(program)], timeout=10, check=True)


if __name__ == "__main__":
    unittest.main()
