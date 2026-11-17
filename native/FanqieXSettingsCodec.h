#ifndef FANQIEX_SETTINGS_CODEC_H
#define FANQIEX_SETTINGS_CODEC_H

#include <stddef.h>
#include <stdint.h>

enum {
    FQXSettingsHeaderSize = 24,
    FQXSettingsPayloadLimit = 256 * 1024,
    FQXSettingsFileLimit = FQXSettingsPayloadLimit + 128 + FQXSettingsHeaderSize
};

typedef enum {
    FQXSettingsCodecOK,
    FQXSettingsCodecFormat,
    FQXSettingsCodecVersion,
    FQXSettingsCodecLength,
    FQXSettingsCodecCompression,
    FQXSettingsCodecChecksum,
    FQXSettingsCodecMemory
} FQXSettingsCodecStatus;

typedef struct {
    uint8_t *bytes;
    size_t length;
} FQXSettingsBuffer;

// On success the caller owns output.bytes and releases it with free().
FQXSettingsCodecStatus FQXSettingsEncode(const uint8_t *bytes, size_t length, FQXSettingsBuffer *output);
FQXSettingsCodecStatus FQXSettingsDecode(const uint8_t *bytes, size_t length, FQXSettingsBuffer *output);

#endif
