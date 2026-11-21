#include "../native/FQXMineShortcutGeometry.h"
#include <assert.h>
#include <stdio.h>

static void check_pages(double width, double nativeWidth, double spacing, size_t count) {
    FQXMineShortcutPlan p = FQXPlanMineShortcuts(width, 72, nativeWidth, spacing, 6, 6, count);
    assert(p.valid);
    size_t visited = 0;
    for (size_t page = 0; page < p.pages; ++page) {
        for (size_t column = 0; column < p.columns; ++column) {
            size_t index = page * p.columns + column;
            if (index >= count) break;
            double x = index * (p.itemWidth + spacing) - page * width;
            assert(x >= -1e-9);
            assert(x + p.itemWidth <= width + 1e-9);
            assert(fabs(6 + p.itemHeight + 6 - 72) < 1e-9);
            assert(index == visited++);
        }
    }
    assert(visited == count); // Every model remains reachable, including page 2.
}

int main(void) {
    // 440pt screen with inset card / stale screen-sized native slots.
    FQXMineShortcutPlan p = FQXPlanMineShortcuts(408, 72, 86.7, 0, 6, 6, 6);
    assert(p.valid && p.columns == 5 && p.pages == 2);
    assert(fabs(p.itemWidth - 81.6) < 1e-9 && p.itemHeight == 60);
    // Native 6th item begins on page 2 rather than wrapping below page 1.
    assert(fabs(5 * p.itemWidth - 408) < 1e-9);
    double widths[] = {288, 343, 376, 408, 440, 596};
    for (size_t i = 0; i < sizeof(widths) / sizeof(widths[0]); ++i)
        for (size_t n = 1; n <= 25; ++n) {
            check_pages(widths[i], 86.7, 0, n);
            check_pages(widths[i], 74, 6, n);
        }
    assert(!FQXPlanMineShortcuts(NAN, 72, 80, 0, 0, 0, 6).valid);
    assert(!FQXPlanMineShortcuts(408, 40, 80, 0, 0, 0, 6).valid);
    assert(!FQXPlanMineShortcuts(408, 72, 80, 0, 20, 20, 6).valid);
    assert(!FQXPlanMineShortcuts(408, 72, 80, 0, 0, 0, 0).valid);
    puts("Mine shortcut geometry: 300 page/model coverage scenarios passed; UIKit not exercised.");
}
