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
    puts("Blur controls: 101 integer values, linear one-percent steps and endpoints passed");
    return 0;
}
