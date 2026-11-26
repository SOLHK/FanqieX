#ifndef FANQIEX_NALOIA_SCAN_H
#define FANQIEX_NALOIA_SCAN_H

#include <math.h>
#include <stdbool.h>

typedef struct {
    double crest;
    double amplitude;
    double blend;
} FQXNaloiaScanSample;

static inline double FQXNaloiaUnitInterval(double value) {
    return fmin(1, fmax(0, value));
}

static inline double FQXNaloiaEase(double value) {
    double t = FQXNaloiaUnitInterval(value);
    return t * t * (3 - 2 * t);
}

static inline FQXNaloiaScanSample FQXNaloiaScanAt(double progress, bool selected) {
    bool second = selected && progress >= 0.51;
    double start = second ? 0.51 : 0.09;
    double end = selected ? (second ? 0.92 : 0.49) : 0.87;
    double phase = FQXNaloiaUnitInterval((progress - start) / (end - start));
    return (FQXNaloiaScanSample){
        .crest = 17 + 78 * phase,
        .amplitude = selected ? (second ? 0.72 : 1.0) : 0.48,
        .blend = FQXNaloiaEase(progress / 0.09) * (1 - FQXNaloiaEase((progress - 0.93) / 0.07)),
    };
}

static inline double FQXNaloiaWaveBump(double x, double width) {
    double t = x / width;
    return fabs(t) < 1 ? 0.5 + 0.5 * cos(3.14159265358979323846 * t) : 0;
}

static inline double FQXNaloiaWaveHeight(double x, FQXNaloiaScanSample sample) {
    double d = x - sample.crest;
    return 54 + sample.amplitude * (2.5 * FQXNaloiaWaveBump(d + 9, 4) -
        12 * FQXNaloiaWaveBump(d, 5.5) + 8 * FQXNaloiaWaveBump(d - 6, 5));
}

#endif
