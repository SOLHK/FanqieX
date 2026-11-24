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

enum { FQXSheetFrostedBlurMinimum = 40, FQXSheetGaussianBlurMinimum = 70 };

static inline int FQXSheetBlurPercent(double value, int minimum) {
    int percent = FQXBlurPercent(value);
    return minimum + ((100 - minimum) * percent + 50) / 100;
}

/* Smooth 100-step Gaussian radius curve: 0 at 0%, barely perceptible 0.25pt at 1%, 30pt at 100%. */
static inline double FQXBlurGaussianRadius(int percent) {
    int p = percent <= 0 ? 0 : (percent >= 100 ? 100 : percent);
    if (p == 0) return 0.0;
    return 0.25 + 29.75 * pow((double)(p - 1) / 99.0, 1.30);
}

/* Progressive tint veil alpha matching the 100 blur steps without snapping at 1%. */
static inline double FQXBlurTintAlpha(int percent, double baseAlpha, double maxAlpha) {
    if (!isfinite(baseAlpha) || baseAlpha < 0.0) baseAlpha = 0.0;
    if (!isfinite(maxAlpha) || maxAlpha < baseAlpha) maxAlpha = baseAlpha;
    int p = percent <= 0 ? 0 : (percent >= 100 ? 100 : percent);
    if (p == 0) return baseAlpha;
    double span = maxAlpha - baseAlpha;
    return baseAlpha + span * (0.01 + 0.99 * pow((double)(p - 1) / 99.0, 1.15));
}

/* Gentle color-saturation boost accompanying Gaussian blur steps. */
static inline double FQXBlurSaturation(int percent) {
    int p = percent <= 0 ? 0 : (percent >= 100 ? 100 : percent);
    return 1.0 + 0.80 * ((double)p / 100.0);
}

#endif
