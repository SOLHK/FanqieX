#include "FanqieXSettingsCodec.h"

#include <stdlib.h>
#include <string.h>
#include <zlib.h>

// FQXCFG CR LF, little-endian version and compression method, decoded size,
// compressed size, CRC-32 of the decoded bytes, then one complete zlib stream.
static const uint8_t Magic[8] = {'F', 'Q', 'X', 'C', 'F', 'G', '\r', '\n'};
enum { VersionAndZlib = 1 | (1 << 16) };

static uint32_t ReadWord(const uint8_t *p) {
    return (uint32_t)p[0] | ((uint32_t)p[1] << 8) | ((uint32_t)p[2] << 16) | ((uint32_t)p[3] << 24);
}

static void WriteWord(uint8_t *p, uint32_t value) {
    for (unsigned int index = 0; index < 4; ++index) {
        p[index] = (uint8_t)(value >> (8 * index));
    }
}

FQXSettingsCodecStatus FQXSettingsEncode(const uint8_t *bytes, size_t length, FQXSettingsBuffer *output) {
    *output = (FQXSettingsBuffer){0};
    if (!length || length > FQXSettingsPayloadLimit) return FQXSettingsCodecLength;

    uLongf compressed = compressBound((uLong)length);
    uint8_t *file = malloc(FQXSettingsHeaderSize + compressed);
    if (!file) return FQXSettingsCodecMemory;
    if (compress2(file + FQXSettingsHeaderSize, &compressed, bytes, (uLong)length, Z_DEFAULT_COMPRESSION) != Z_OK ||
        compressed > FQXSettingsFileLimit - FQXSettingsHeaderSize) {
        free(file);
        return FQXSettingsCodecCompression;
    }

    memcpy(file, Magic, sizeof(Magic));
    WriteWord(file + 8, VersionAndZlib);
    WriteWord(file + 12, (uint32_t)length);
    WriteWord(file + 16, (uint32_t)compressed);
    WriteWord(file + 20, (uint32_t)crc32(0, bytes, (uInt)length));
    *output = (FQXSettingsBuffer){file, FQXSettingsHeaderSize + compressed};
    return FQXSettingsCodecOK;
}

FQXSettingsCodecStatus FQXSettingsDecode(const uint8_t *bytes, size_t length, FQXSettingsBuffer *output) {
    *output = (FQXSettingsBuffer){0};
    if (length < sizeof(Magic) || memcmp(bytes, Magic, sizeof(Magic))) return FQXSettingsCodecFormat;
    if (length < FQXSettingsHeaderSize || length > FQXSettingsFileLimit) return FQXSettingsCodecLength;
    if (ReadWord(bytes + 8) != VersionAndZlib) return FQXSettingsCodecVersion;

    uint32_t rawSize = ReadWord(bytes + 12);
    uint32_t storedSize = ReadWord(bytes + 16);
    if (!rawSize || rawSize > FQXSettingsPayloadLimit || !storedSize || storedSize != length - FQXSettingsHeaderSize) {
        return FQXSettingsCodecLength;
    }

    uint8_t *decoded = malloc(rawSize);
    if (!decoded) return FQXSettingsCodecMemory;
    uLongf outputLength = rawSize;
    uLong inputLength = storedSize;
    if (uncompress2(decoded, &outputLength, bytes + FQXSettingsHeaderSize, &inputLength) != Z_OK ||
        outputLength != rawSize || inputLength != storedSize) {
        free(decoded);
        return FQXSettingsCodecCompression;
    }
    if ((uint32_t)crc32(0, decoded, (uInt)outputLength) != ReadWord(bytes + 20)) {
        free(decoded);
        return FQXSettingsCodecChecksum;
    }

    *output = (FQXSettingsBuffer){decoded, outputLength};
    return FQXSettingsCodecOK;
}
