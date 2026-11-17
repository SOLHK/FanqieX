#include "FanqieXSettingsCodec.h"

#include <assert.h>
#include <stdio.h>
#include <stdlib.h>
#include <string.h>

static void WriteWord(uint8_t *p, uint32_t value) {
    for (unsigned int index = 0; index < 4; ++index) p[index] = (uint8_t)(value >> (8 * index));
}

static void Reject(const uint8_t *file, size_t size, FQXSettingsCodecStatus status) {
    FQXSettingsBuffer decoded = {0};
    assert(FQXSettingsDecode(file, size, &decoded) == status);
    assert(!decoded.bytes && !decoded.length);
}

int main(void) {
    const uint8_t source[] = "{\"FanqieX.BottomDramaCompact.1\":true,\"FanqieX.BottomLengthScale.1\":74.5}";
    FQXSettingsBuffer file, decoded;
    assert(FQXSettingsEncode(source, sizeof(source) - 1, &file) == FQXSettingsCodecOK);
    assert(FQXSettingsDecode(file.bytes, file.length, &decoded) == FQXSettingsCodecOK);
    assert(decoded.length == sizeof(source) - 1 && !memcmp(decoded.bytes, source, decoded.length));
    free(decoded.bytes);

    uint8_t *damaged = malloc(file.length + 1);
    assert(damaged);
    for (size_t length = 0; length < file.length; ++length) {
        Reject(file.bytes, length, length < 8 ? FQXSettingsCodecFormat : FQXSettingsCodecLength);
    }
    memcpy(damaged, file.bytes, file.length);
    damaged[0] ^= 1;
    Reject(damaged, file.length, FQXSettingsCodecFormat);
    damaged[0] ^= 1;
    damaged[8] = 2;
    Reject(damaged, file.length, FQXSettingsCodecVersion);
    damaged[8] = 1;
    damaged[10] = 2;
    Reject(damaged, file.length, FQXSettingsCodecVersion);
    damaged[10] = 1;
    damaged[20] ^= 1;
    Reject(damaged, file.length, FQXSettingsCodecChecksum);
    damaged[20] ^= 1;
    damaged[FQXSettingsHeaderSize] = 0;
    Reject(damaged, file.length, FQXSettingsCodecCompression);
    memcpy(damaged, file.bytes, file.length);
    WriteWord(damaged + 12, FQXSettingsPayloadLimit + 1);
    Reject(damaged, file.length, FQXSettingsCodecLength);
    WriteWord(damaged + 12, sizeof(source));
    Reject(damaged, file.length, FQXSettingsCodecCompression);
    memcpy(damaged, file.bytes, file.length);
    WriteWord(damaged + 16, (uint32_t)(file.length - FQXSettingsHeaderSize - 1));
    Reject(damaged, file.length, FQXSettingsCodecLength);
    damaged[file.length] = 0;
    WriteWord(damaged + 16, (uint32_t)(file.length - FQXSettingsHeaderSize + 1));
    Reject(damaged, file.length + 1, FQXSettingsCodecCompression);
    free(damaged);
    free(file.bytes);

    uint8_t *large = calloc(1, FQXSettingsPayloadLimit);
    assert(large);
    assert(FQXSettingsEncode(large, FQXSettingsPayloadLimit, &file) == FQXSettingsCodecOK);
    assert(FQXSettingsDecode(file.bytes, file.length, &decoded) == FQXSettingsCodecOK);
    assert(decoded.length == FQXSettingsPayloadLimit && !memcmp(decoded.bytes, large, decoded.length));
    free(decoded.bytes);
    WriteWord(file.bytes + 12, 8);
    Reject(file.bytes, file.length, FQXSettingsCodecCompression);
    free(file.bytes);
    assert(FQXSettingsEncode(large, FQXSettingsPayloadLimit + 1, &file) == FQXSettingsCodecLength);
    assert(!file.bytes && !file.length);
    free(large);
    puts("FanqieX settings codec round-trip and invalid-file tests passed");
    return 0;
}
