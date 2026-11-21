#ifndef FQX_MINE_SHORTCUT_GEOMETRY_H
#define FQX_MINE_SHORTCUT_GEOMETRY_H

#include <math.h>
#include <stddef.h>

typedef struct {
    int valid;
    size_t columns;
    size_t pages;
    double itemWidth;
    double itemHeight;
} FQXMineShortcutPlan;

// A horizontal native flow layout advances by itemWidth + lineSpacing.
// Make that pitch divide the actual viewport exactly, so page N starts at
// N * viewportWidth even when a final page contains fewer shortcuts.
static inline FQXMineShortcutPlan FQXPlanMineShortcuts(double width, double height,
    double nativeItemWidth, double lineSpacing, double top, double bottom, size_t count) {
    FQXMineShortcutPlan plan = {0};
    if (!isfinite(width) || !isfinite(height) || !isfinite(nativeItemWidth) ||
        !isfinite(lineSpacing) || !isfinite(top) || !isfinite(bottom) ||
        width < 44.0 || height < 44.0 || nativeItemWidth < 20.0 ||
        lineSpacing < 0.0 || top < 0.0 || bottom < 0.0 || !count) return plan;
    double columns = floor(width / (nativeItemWidth + lineSpacing) + 0.5);
    if (columns < 1.0) columns = 1.0;
    if (columns > 4.0) columns = 4.0;
    // The existing profile controls need at least a 44pt tappable slot.
    if (columns > floor(width / (44.0 + lineSpacing)))
        columns = floor(width / (44.0 + lineSpacing));
    if (columns < 1.0) return plan;
    plan.columns = (size_t)columns;
    plan.pages = count / plan.columns + (count % plan.columns != 0);
    plan.itemWidth = width / columns - lineSpacing;
    plan.itemHeight = height - top - bottom;
    plan.valid = plan.itemWidth >= 44.0 && plan.itemHeight >= 44.0;
    return plan;
}
#endif
