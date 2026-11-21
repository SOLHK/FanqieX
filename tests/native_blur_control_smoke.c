#include <assert.h>
#include <math.h>
#include <stdio.h>
#include "FQXBlurControl.h"

int main(void) {
    /* Walk both ways through every setting, including a 100% -> 0% reset. */
    for (int p = 0; p <= 100; ++p) {
        assert(FQXBlurPercent(p) == p);
        assert(FQXBlurPercent(FQXBlurFraction(p) * 100.0) == p);
        if (p) assert(fabs(FQXBlurFraction(p) - FQXBlurFraction(p - 1) - 0.01) < 1e-12);
    }
    for (int p = 100; p > 0; --p) assert(FQXBlurPercent(p - 1.0) == p - 1);
    assert(FQXBlurPercent(0.49) == 0);
    assert(FQXBlurPercent(0.50) == 1);
    assert(FQXBlurPercent(5.49) == 5);
    assert(FQXBlurPercent(5.50) == 6);
    assert(FQXBlurPercent(99.50) == 100);
    assert(FQXBlurPercent(-1) == 0 && FQXBlurPercent(101) == 100);
    assert(FQXBlurPercent(NAN) == 0 && FQXBlurPercent(INFINITY) == 0);
    assert(FQXBlurFraction(-1) == 0.0 && FQXBlurFraction(101) == 1.0);
    assert(fabs(FQXBlurFraction(1) - 0.01) < 1e-12);
    assert(fabs(FQXBlurFraction(6) - 0.06) < 1e-12);
    assert(FQXBlurGaussianRadius(0) == 0.0);
    assert(FQXBlurGaussianRadius(1) > 0.0 && FQXBlurGaussianRadius(1) < 0.35);
    assert(fabs(FQXBlurGaussianRadius(100) - 30.0) < 1e-9);
    assert(FQXBlurSaturation(0) == 1.0 && fabs(FQXBlurSaturation(100) - 1.8) < 1e-9);
    assert(fabs(FQXBlurTintAlpha(0, 0.0, 0.64)) < 1e-12);
    assert(FQXBlurTintAlpha(1, 0.0, 0.64) > 0.0 && FQXBlurTintAlpha(1, 0.0, 0.64) < 0.02 * 0.64);
    assert(fabs(FQXBlurTintAlpha(100, 0.0, 0.64) - 0.64) < 1e-9);
    for (int p = 1; p <= 100; ++p) {
        assert(FQXBlurGaussianRadius(p) > FQXBlurGaussianRadius(p - 1));
        assert(FQXBlurTintAlpha(p, 0.0, 0.64) > FQXBlurTintAlpha(p - 1, 0.0, 0.64));
        assert(FQXBlurSaturation(p) > FQXBlurSaturation(p - 1));
    }
    puts("Blur controls: 101 integer values, progressive 100-step radius/tint curves and endpoints passed");
    return 0;
}
