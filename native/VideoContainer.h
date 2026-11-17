#ifndef FQX_VIDEO_CONTAINER_H
#define FQX_VIDEO_CONTAINER_H

#include <stdbool.h>
#include <stddef.h>
#include <stdint.h>
#include <string.h>

static inline bool FQXVideoIsHLSPlaylist(const uint8_t *bytes, size_t length) {
    size_t start = length >= 3 && !memcmp(bytes, "\xEF\xBB\xBF", 3) ? 3 : 0;
    if (length - start < 8 || memcmp(bytes + start, "#EXTM3U", 7) ||
        (bytes[start + 7] != '\n' && bytes[start + 7] != '\r')) return false;
    for (size_t cursor = start + 8; cursor + 7 <= length; ++cursor) {
        if (bytes[cursor - 1] == '\n' && !memcmp(bytes + cursor, "#EXT-X-", 7)) return true;
    }
    return false;
}

static inline uint32_t FQXVideoBE32(const uint8_t *bytes) {
    return (uint32_t)bytes[0] << 24 | (uint32_t)bytes[1] << 16 |
           (uint32_t)bytes[2] << 8 | bytes[3];
}

static inline const char *FQXVideoISOBrand(const uint8_t *bytes) {
    if (!memcmp(bytes, "qt  ", 4)) return "mov";
    if (!memcmp(bytes, "M4V", 3)) return "m4v";
    if (!memcmp(bytes, "3gp", 3)) return "3gp";
    if (!memcmp(bytes, "3g2", 3)) return "3g2";
    if (!memcmp(bytes, "f4v ", 4)) return "f4v";
    if (!memcmp(bytes, "iso", 3) || !memcmp(bytes, "mp4", 3) ||
        !memcmp(bytes, "avc1", 4) || !memcmp(bytes, "dash", 4) ||
        !memcmp(bytes, "MSNV", 4)) return "mp4";
    return NULL;
}

static inline size_t FQXVideoEBMLWidth(uint8_t first) {
    for (uint8_t mask = 0x80, width = 1; mask; mask >>= 1, ++width) {
        if (first & mask) return width;
    }
    return 0;
}

static inline bool FQXVideoEBMLSize(const uint8_t *bytes, size_t remaining, size_t *width, uint64_t *value) {
    *width = remaining ? FQXVideoEBMLWidth(bytes[0]) : 0;
    if (!*width || *width > remaining) return false;
    *value = bytes[0] & (0xff >> *width);
    for (size_t index = 1; index < *width; ++index) *value = (*value << 8) | bytes[index];
    return *value != (UINT64_C(1) << (7 * *width)) - 1 && *value <= remaining - *width;
}

static inline const char *FQXVideoEBMLType(const uint8_t *bytes, size_t length) {
    size_t width;
    uint64_t headerSize;
    if (!FQXVideoEBMLSize(bytes, length, &width, &headerSize)) return NULL;
    size_t headerEnd = width + (size_t)headerSize;
    for (size_t cursor = width; cursor < headerEnd;) {
        size_t idWidth = FQXVideoEBMLWidth(bytes[cursor]);
        if (!idWidth || idWidth > 4 || idWidth > headerEnd - cursor) return NULL;
        bool docType = idWidth == 2 && bytes[cursor] == 0x42 && bytes[cursor + 1] == 0x82;
        cursor += idWidth;
        uint64_t size;
        if (!FQXVideoEBMLSize(bytes + cursor, headerEnd - cursor, &width, &size)) return NULL;
        cursor += width;
        if (docType) {
            if (size == 4 && !memcmp(bytes + cursor, "webm", 4)) return "webm";
            if (size == 8 && !memcmp(bytes + cursor, "matroska", 8)) return "mkv";
            return NULL;
        }
        cursor += (size_t)size;
    }
    return NULL;
}

static inline bool FQXVideoTransportPackets(const uint8_t *bytes, size_t length, size_t start, size_t stride) {
    if (length < start + 2 * stride + 4) return false;
    for (size_t index = 0; index < 3; ++index) {
        const uint8_t *packet = bytes + start + index * stride;
        if (packet[0] != 0x47 || !(packet[3] & 0x30)) return false;
    }
    return true;
}

// Determine a file extension from media bytes. The URL suffix and HTTP
// content type are insufficient when a CDN returns an error document.
static inline const char *FQXVideoContainerExtension(const uint8_t *bytes, size_t length) {
    if (length < 12) return NULL;
    if (!memcmp(bytes + 4, "ftyp", 4)) {
        uint32_t size = FQXVideoBE32(bytes);
        if (size < 16 || size > length || (size % 4)) return NULL;
        const char *brand = FQXVideoISOBrand(bytes + 8);
        if (brand) return brand;
        for (size_t offset = 16; offset < size; offset += 4) {
            brand = FQXVideoISOBrand(bytes + offset);
            if (brand) return brand;
        }
        return NULL;
    }
    if (length >= 16 && ((!memcmp(bytes + 4, "moov", 4) && !memcmp(bytes + 12, "mvhd", 4)) ||
        (FQXVideoBE32(bytes) == 8 && !memcmp(bytes + 4, "wide", 4) && !memcmp(bytes + 12, "mdat", 4)))) return "mov";
    if (!memcmp(bytes, "RIFF", 4) && !memcmp(bytes + 8, "AVI ", 4)) return "avi";
    if (!memcmp(bytes, "\x1A\x45\xDF\xA3", 4)) return FQXVideoEBMLType(bytes + 4, length - 4);
    if (length >= 13 && !memcmp(bytes, "FLV\x01", 4) && (bytes[4] & 1) && !(bytes[4] & ~5)) {
        uint32_t offset = FQXVideoBE32(bytes + 5);
        if (offset >= 9 && offset <= length - 4 && !FQXVideoBE32(bytes + offset)) return "flv";
        return NULL;
    }
    if (length >= 14 && !memcmp(bytes, "\x00\x00\x01\xBA", 4) &&
        ((bytes[4] & 0xc4) == 0x44 || (bytes[4] & 0xf1) == 0x21)) return "mpg";
    if (FQXVideoTransportPackets(bytes, length, 0, 188) ||
        FQXVideoTransportPackets(bytes, length, 0, 204)) return "ts";
    if (FQXVideoTransportPackets(bytes, length, 4, 192)) return "m2ts";
    return NULL;
}

#endif
