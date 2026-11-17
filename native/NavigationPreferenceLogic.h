#ifndef FANQIEX_NAVIGATION_PREFERENCE_LOGIC_H
#define FANQIEX_NAVIGATION_PREFERENCE_LOGIC_H

#include <stdbool.h>
#include <stddef.h>

static inline int FQXResolveColdLanding(int chosen, int requested, bool requestedVisible, int firstVisible) {
    if (chosen >= 0) return chosen;
    return requestedVisible || firstVisible < 0 ? requested : firstVisible;
}

static inline bool FQXUseBookstoreSubset(size_t visible, size_t total) {
    return visible > 0 && visible < total;
}

static inline size_t FQXProjectedBookstoreIndex(size_t matchingIndex, size_t visibleCount) {
    return matchingIndex < visibleCount ? matchingIndex : 0;
}

#endif
