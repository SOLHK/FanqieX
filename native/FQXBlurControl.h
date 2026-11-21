#ifndef FQX_BLUR_CONTROL_H
#define FQX_BLUR_CONTROL_H

#include <math.h>

/* One integer percentage is shared by the control, persisted preference and renderer. */
static inline int FQXBlurPercent(double value) {
    if (!isfinite(value) || value <= 0.0) return 0;
    if (value >= 100.0) return 100;
    return (int)floor(value + 0.5);
}

static inline double FQXBlurFraction(int percent) {
    return (percent <= 0 ? 0 : (percent >= 100 ? 100 : percent)) / 100.0;
}

#endif
