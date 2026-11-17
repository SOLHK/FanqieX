#include "../native/VideoContainer.h"
#include <assert.h>
#include <stdio.h>

static void match(const uint8_t *bytes, size_t length, const char *extension) {
    const char *actual = FQXVideoContainerExtension(bytes, length);
    assert(actual && strcmp(actual, extension) == 0);
}

int main(void) {
    uint8_t ftyp[20] = {0, 0, 0, 20, 'f', 't', 'y', 'p'};
    const char *brands[][2] = {
        {"isom", "mp4"}, {"qt  ", "mov"}, {"M4V ", "m4v"}, {"3gp6", "3gp"},
        {"3g2a", "3g2"}, {"f4v ", "f4v"},
    };
    for (size_t index = 0; index < sizeof(brands) / sizeof(brands[0]); ++index) {
        memcpy(ftyp + 8, brands[index][0], 4);
        match(ftyp, sizeof(ftyp), brands[index][1]);
        assert(!FQXVideoContainerExtension(ftyp, sizeof(ftyp) - 1));
    }
    memcpy(ftyp + 8, "avif", 4);
    assert(!FQXVideoContainerExtension(ftyp, sizeof(ftyp)));

    const uint8_t quicktime[] = "\x00\x00\x00\x08" "wide" "\x00\x00\x00\x24" "mdat";
    const uint8_t avi[] = "RIFF\x40\x00\x00\x00" "AVI ";
    const uint8_t webm[] = "\x1A\x45\xDF\xA3\x87\x42\x82\x84" "webm";
    const uint8_t mkv[] = "\x1A\x45\xDF\xA3\x8B\x42\x82\x88" "matroska";
    const uint8_t flv[] = "FLV\x01\x05\x00\x00\x00\x09\x00\x00\x00\x00";
    const uint8_t mpg[] = {0, 0, 1, 0xBA, 0x44, 0, 4, 0, 4, 1, 0, 0, 3, 0xf8};
    match(quicktime, sizeof(quicktime) - 1, "mov");
    match(avi, sizeof(avi) - 1, "avi");
    match(webm, sizeof(webm) - 1, "webm");
    match(mkv, sizeof(mkv) - 1, "mkv");
    match(flv, sizeof(flv) - 1, "flv");
    match(mpg, sizeof(mpg), "mpg");
    assert(!FQXVideoContainerExtension(mkv, sizeof(mkv) - 2));
    assert(!FQXVideoContainerExtension(flv, sizeof(flv) - 2));

    uint8_t ts[612] = {0};
    for (size_t index = 0; index < 3; ++index) {
        ts[index * 188] = 0x47;
        ts[index * 188 + 3] = 0x10;
    }
    match(ts, sizeof(ts), "ts");
    ts[376] = 0;
    assert(!FQXVideoContainerExtension(ts, sizeof(ts)));
    memset(ts, 0, sizeof(ts));
    for (size_t index = 0; index < 3; ++index) {
        ts[index * 192 + 4] = 0x47;
        ts[index * 192 + 7] = 0x10;
    }
    match(ts, sizeof(ts), "m2ts");

    const uint8_t html[] = "<html>Video link unavailable</html>";
    const uint8_t hls[] = "#EXTM3U\n#EXT-X-TARGETDURATION:3\n";
    assert(!FQXVideoContainerExtension(html, sizeof(html) - 1));
    assert(!FQXVideoContainerExtension(hls, sizeof(hls) - 1));
    assert(!FQXVideoContainerExtension(NULL, 0));
    puts("PASS: video container signatures, distinct original formats and invalid input rejection");
    return 0;
}
