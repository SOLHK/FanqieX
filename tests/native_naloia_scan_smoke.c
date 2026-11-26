#include <assert.h>
#include <stdio.h>
#include "FanqieXNaloiaScan.h"

static double PeakX(FQXNaloiaScanSample sample) {
    double peak = 34;
    for (double x = 34; x <= 75.5; x += .25)
        if (FQXNaloiaWaveHeight(x, sample) < FQXNaloiaWaveHeight(peak, sample)) peak = x;
    return peak;
}

static void AssertSweep(double left, double middle, double right, bool selected) {
    double a = PeakX(FQXNaloiaScanAt(left, selected));
    double b = PeakX(FQXNaloiaScanAt(middle, selected));
    double c = PeakX(FQXNaloiaScanAt(right, selected));
    assert(a >= 34 && a < 46);
    assert(b > 52 && b < 59);
    assert(c > 66 && c <= 75.5);
}

int main(void) {
    AssertSweep(.20, .29, .38, true);
    AssertSweep(.63, .715, .80, true);
    AssertSweep(.31, .48, .65, false);
    FQXNaloiaScanSample first = FQXNaloiaScanAt(.29, true);
    FQXNaloiaScanSample second = FQXNaloiaScanAt(.715, true);
    FQXNaloiaScanSample unlike = FQXNaloiaScanAt(.48, false);
    assert(FQXNaloiaWaveHeight(first.crest, first) < FQXNaloiaWaveHeight(second.crest, second));
    assert(FQXNaloiaWaveHeight(second.crest, second) < FQXNaloiaWaveHeight(unlike.crest, unlike));
    for (double x = 34; x <= 75.5; x += .5) {
        assert(FQXNaloiaWaveHeight(x, FQXNaloiaScanAt(.50, true)) == 54);
        assert(FQXNaloiaWaveHeight(x, FQXNaloiaScanAt(.51, true)) == 54);
    }
    assert(FQXNaloiaScanAt(0, true).blend < 1e-9);
    assert(FQXNaloiaScanAt(1, true).blend < 1e-9);
    assert(FQXNaloiaScanAt(0, false).blend < 1e-9);
    assert(FQXNaloiaScanAt(1, false).blend < 1e-9);
    puts("Naloia heart: two forward scans, one quieter unlike scan, flat crossover, static endpoints.");
}
