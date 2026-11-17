#include "../native/NavigationPreferenceLogic.h"

#include <assert.h>

int main(void) {
    assert(FQXResolveColdLanding(0, 7, true, 3) == 0);
    assert(FQXResolveColdLanding(7, 0, false, 3) == 7);
    assert(FQXResolveColdLanding(-1, 4, true, 3) == 4);
    assert(FQXResolveColdLanding(-1, 4, false, 3) == 3);
    assert(FQXResolveColdLanding(-1, 4, false, -1) == 4);
    assert(!FQXUseBookstoreSubset(0, 3));
    assert(!FQXUseBookstoreSubset(3, 3));
    assert(FQXUseBookstoreSubset(2, 3));
    assert(FQXProjectedBookstoreIndex(1, 2) == 1);
    assert(FQXProjectedBookstoreIndex(2, 2) == 0);
    assert(FQXProjectedBookstoreIndex((size_t)-1, 2) == 0);
    return 0;
}
