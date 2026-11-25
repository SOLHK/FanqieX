"""Exercise the shipping shelf banner filter against 7.4.5 model signatures."""
from pathlib import Path
import os
import re
import shutil
import subprocess
import tempfile
import unittest


ROOT = Path(__file__).resolve().parents[1]
SOURCE = ROOT / "native" / "FanqieXCleanup.m"


class ShelfAdaptationTests(unittest.TestCase):
    def test_show_setting_and_host_types(self):
        code = SOURCE.read_text(encoding="utf-8")
        start = code.index("static BOOL ShelfHidesAdaptationBanner(")
        classifier = code[start:code.index("\n}", start) + 2]
        # Translate Objective-C message syntax only. Keep the shipping branch
        # conditions, class/selector names, title strings and ABI checks intact.
        classifier = re.sub(r'@selector\((\w+)\)', r'"\1"', classifier)
        classifier = re.sub(r'\[(\w+) isKindOfClass:objc_lookUpClass\((".*?")\)\]',
                            r'isKindOfClass(\1, \2)', classifier)
        classifier = re.sub(r'\[@"([^"]+)" isEqual:(HostObject\([^)]*\))\]',
                            r'stringEqual("\1", \2)', classifier)
        harness = r"""
#include <assert.h>
#include <string.h>
typedef struct { const char *encoding, *cls, *category, *title; int type; } Banner;
typedef const void *id;
typedef const char *SEL;
typedef int BOOL;
#define YES 1
#define NO 0
#define nil NULL
#define ShelfAdaptationCardKey "FanqieX.ShelfAdaptationCard.1"
#define sel_registerName(name) (name)
#define object_getClass(banner) (banner)
static int show = -1;
static BOOL Option(const char *key, BOOL fallback) {
    assert(strcmp(key, ShelfAdaptationCardKey) == 0);
    return show < 0 ? fallback : show;
}
static BOOL HostMethod(id banner, SEL selector, const char *encoding) {
    const Banner *b = banner;
    return b && b->encoding && strcmp(selector, "chaseBookUpdateType") == 0 &&
        strcmp(b->encoding, encoding) == 0;
}
static int objc_msgSend(id banner, SEL selector) {
    assert(HostMethod(banner, selector, "i16@0:8"));
    return ((const Banner *)banner)->type;
}
static BOOL stringEqual(const char *literal, const char *value) {
    return value && strcmp(literal, value) == 0;
}
static BOOL isKindOfClass(id object, const char *cls) {
    return object && stringEqual(cls, ((const Banner *)object)->cls);
}
static id HostObject(id object, SEL selector) {
    const Banner *b = object;
    if (!b) return NULL;
    if (strcmp(selector, "payload") == 0 || strcmp(selector, "videoData") == 0) return b;
    if (strcmp(selector, "bannerTitle") == 0) return b->title;
    if (strcmp(selector, "videoCategoryType") == 0) return b->category;
    return NULL;
}
CLASSIFIER
int main(void) {
    Banner models[] = {
        {.encoding="i16@0:8", .type=13},
        {.cls="SeriesOriginalBanner", .title="你看过的小说上架改编剧了"},
        {.encoding="i16@0:8", .type=18}, {.encoding="i16@0:8", .type=19},
        {.encoding="i16@0:8", .type=1234}, {.encoding="q16@0:8", .type=13}, {.type=13},
        {.encoding="i16@0:8", .type=13, .category="interactive_game"},
        {.cls="SeriesOriginalBanner", .encoding="i16@0:8", .type=13, .title="另一张推荐卡"}
    };
    for (show = -1; show <= 1; ++show) {
        assert(!ShelfHidesAdaptationBanner(NULL));
        for (size_t i = 0; i < sizeof(models) / sizeof(models[0]); ++i)
            assert(ShelfHidesAdaptationBanner(&models[i]) == (show == 0 && i < 2));
    }
}
"""
        compiler = shutil.which("clang") or shutil.which("cc")
        if not compiler and os.name == "nt":
            compiler = Path(os.environ["ProgramFiles"]) / "LLVM/bin/clang.exe"
        if not compiler or not Path(compiler).is_file():
            self.skipTest("A C compiler is required to execute the production filter")
        with tempfile.TemporaryDirectory() as folder:
            fixture = Path(folder) / "filter.c"
            fixture.write_text(harness.replace("CLASSIFIER", classifier), encoding="utf-8")
            exe = Path(folder) / ("filter.exe" if os.name == "nt" else "filter")
            subprocess.run([str(compiler), "-std=c11", "-Wall", "-Wextra", "-Werror",
                            str(fixture), "-o", str(exe)], check=True)
            subprocess.run([str(exe)], check=True)

    def test_model_selection_and_settings_refresh(self):
        code = SOURCE.read_text(encoding="utf-8")
        for selector, hook in (("bookEndRelateVideoBanner", "RelatedBanner"),
                               ("unconsumedVideoBanner", "ShelfVideoBanner"),
                               ("unconsumedIpStableEntranceBanner", "ShelfIPBanner"),
                               ("canShowLegacyIpBanner:", "ShelfCanShowLegacyIPBanner"),
                               ("hasUnconsumedVideoBanner", "HasUnconsumedBanner")):
            with self.subTest(selector=selector):
                self.assertRegex(code, rf'"{selector}"[^;]+\b{hook}\b')
                body = re.search(rf'static (?:id|BOOL) {hook}\([^{{]+\) \{{(.*?)\n\}}', code, re.S)
                self.assertIsNotNone(body)
                self.assertIn("ShelfHidesAdaptationBanner(banner)", body.group(1))
        refresh = code[code.rindex("+ (void)refreshForKey:"):]
        self.assertRegex(refresh, r'(?s)if \(utilityChanged \|\| \[key isEqualToString:'
                                  r'ShelfAdaptationCardKey\]\).*?"rebuildShelfPipeline:".*?"reloadData:"')


if __name__ == "__main__":
    unittest.main()
