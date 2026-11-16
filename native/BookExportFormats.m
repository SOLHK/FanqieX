#import "BookExportFormats.h"

#include <errno.h>
#include <fcntl.h>
#include <limits.h>
#include <stdint.h>
#include <string.h>
#include <unistd.h>

NSString *const FQXBookExportErrorDomain = @"FQXBookExportErrorDomain";

typedef NS_ENUM(NSInteger, FQXExportError) {
    FQXExportInvalidInput = 1,
    FQXExportInvalidState,
    FQXExportIOError,
    FQXExportUnsafeContent,
    FQXExportMalformedContent,
    FQXExportTooLarge,
};

static BOOL FQXError(NSError **error, FQXExportError code, NSString *message) {
    if (error) *error = [NSError errorWithDomain:FQXBookExportErrorDomain code:code
                                      userInfo:@{NSLocalizedDescriptionKey: message}];
    return NO;
}

static BOOL FQXValidText(id value) {
    if (![value isKindOfClass:NSString.class]) return NO;
    NSString *text = value;
    for (NSUInteger i = 0; i < text.length; i++) {
        unichar c = [text characterAtIndex:i];
        if ((c < 0x20 && c != '\t' && c != '\n' && c != '\r') || c == 0xfffe || c == 0xffff)
            return NO;
        if (c >= 0xd800 && c <= 0xdbff) {
            if (++i >= text.length) return NO;
            unichar next = [text characterAtIndex:i];
            if (next < 0xdc00 || next > 0xdfff) return NO;
        } else if (c >= 0xdc00 && c <= 0xdfff) {
            return NO;
        }
    }
    return YES;
}

static NSString *FQXTrim(NSString *text) {
    return [text stringByTrimmingCharactersInSet:
            [NSCharacterSet characterSetWithCharactersInString:@" \t\r\n"]];
}

static NSString *FQXNormalizeNewlines(NSString *text) {
    return [[text stringByReplacingOccurrencesOfString:@"\r\n" withString:@"\n"]
            stringByReplacingOccurrencesOfString:@"\r" withString:@"\n"];
}

static NSString *FQXXML(NSString *text) {
    NSMutableString *result = [text mutableCopy];
    [result replaceOccurrencesOfString:@"&" withString:@"&amp;" options:0 range:NSMakeRange(0, result.length)];
    [result replaceOccurrencesOfString:@"<" withString:@"&lt;" options:0 range:NSMakeRange(0, result.length)];
    [result replaceOccurrencesOfString:@">" withString:@"&gt;" options:0 range:NSMakeRange(0, result.length)];
    [result replaceOccurrencesOfString:@"\"" withString:@"&quot;" options:0 range:NSMakeRange(0, result.length)];
    [result replaceOccurrencesOfString:@"'" withString:@"&apos;" options:0 range:NSMakeRange(0, result.length)];
    return result;
}

static NSString *FQXMarkdown(NSString *text) {
    NSMutableString *result = [NSMutableString string];
    NSCharacterSet *special = [NSCharacterSet characterSetWithCharactersInString:@"\\`*_{}[]()#+-.!|><&"];
    for (NSUInteger i = 0; i < text.length; i++) {
        unichar c = [text characterAtIndex:i];
        if ([special characterIsMember:c]) [result appendString:@"\\"];
        [result appendString:[text substringWithRange:NSMakeRange(i, 1)]];
    }
    return result;
}

static NSString *FQXHTMLParagraph(NSString *text) {
    return [FQXXML(FQXNormalizeNewlines(text)) stringByReplacingOccurrencesOfString:@"\n" withString:@"<br/>"];
}

static NSDictionary<NSString *, NSString *> *FQXEntities(void) {
    // Deliberately a fixed table: content cannot declare or recursively expand entities.
    return @{@"amp": @"&", @"lt": @"<", @"gt": @">", @"quot": @"\"", @"apos": @"'",
             @"nbsp": @"\u00a0", @"ensp": @"\u2002", @"emsp": @"\u2003", @"thinsp": @"\u2009",
             @"ndash": @"\u2013", @"mdash": @"\u2014", @"hellip": @"\u2026", @"bull": @"\u2022",
             @"middot": @"\u00b7", @"lsquo": @"\u2018", @"rsquo": @"\u2019", @"ldquo": @"\u201c",
             @"rdquo": @"\u201d", @"laquo": @"\u00ab", @"raquo": @"\u00bb", @"copy": @"\u00a9",
             @"reg": @"\u00ae", @"trade": @"\u2122", @"times": @"\u00d7", @"divide": @"\u00f7"};
}

static NSString * _Nullable FQXDecodeEntities(NSString *text, BOOL markup, NSError **error) {
    NSMutableString *result = [NSMutableString string];
    NSDictionary *entities = FQXEntities();
    NSUInteger cursor = 0;
    while (cursor < text.length) {
        NSRange amp = [text rangeOfString:@"&" options:0 range:NSMakeRange(cursor, text.length - cursor)];
        if (amp.location == NSNotFound) {
            [result appendString:[text substringFromIndex:cursor]];
            break;
        }
        [result appendString:[text substringWithRange:NSMakeRange(cursor, amp.location - cursor)]];
        NSRange semicolon = [text rangeOfString:@";" options:0
                                         range:NSMakeRange(amp.location + 1, text.length - amp.location - 1)];
        if (semicolon.location == NSNotFound || semicolon.location - amp.location > 32) {
            [result appendString:@"&"];
            cursor = amp.location + 1;
            continue;
        }
        NSString *name = [text substringWithRange:NSMakeRange(amp.location + 1, semicolon.location - amp.location - 1)];
        NSString *decoded = entities[name];
        if ([name hasPrefix:@"#"]) {
            NSString *digits = [name substringFromIndex:1];
            unsigned base = 10;
            if ([digits hasPrefix:@"x"] || [digits hasPrefix:@"X"]) {
                base = 16;
                digits = [digits substringFromIndex:1];
            }
            uint32_t scalar = 0;
            BOOL valid = digits.length > 0;
            for (NSUInteger i = 0; i < digits.length && valid; i++) {
                unichar c = [digits characterAtIndex:i];
                unsigned digit = c >= '0' && c <= '9' ? c - '0' :
                                 c >= 'a' && c <= 'f' ? c - 'a' + 10 :
                                 c >= 'A' && c <= 'F' ? c - 'A' + 10 : UINT_MAX;
                if (digit >= base || scalar > (0x10ffffU - digit) / base) valid = NO;
                else scalar = scalar * base + digit;
            }
            if (!valid || scalar > 0x10ffff || (scalar >= 0xd800 && scalar <= 0xdfff) ||
                (scalar < 0x20 && scalar != '\t' && scalar != '\r' && scalar != '\n') ||
                scalar == 0xfffe || scalar == 0xffff) {
                FQXError(error, FQXExportMalformedContent, @"正文包含无效字符实体。");
                return nil;
            }
            if (scalar <= 0xffff) {
                unichar c = (unichar)scalar;
                decoded = [NSString stringWithCharacters:&c length:1];
            } else {
                unichar pair[] = {(unichar)(0xd800 + ((scalar - 0x10000) >> 10)),
                                  (unichar)(0xdc00 + ((scalar - 0x10000) & 0x3ff))};
                decoded = [NSString stringWithCharacters:pair length:2];
            }
        }
        if (!decoded) {
            NSCharacterSet *letters = [NSCharacterSet letterCharacterSet];
            if (name.length && [letters characterIsMember:[name characterAtIndex:0]] &&
                [name rangeOfCharacterFromSet:[[NSCharacterSet alphanumericCharacterSet] invertedSet]].location == NSNotFound) {
                FQXError(error, FQXExportMalformedContent, @"正文包含未知字符实体。");
                return nil;
            }
            [result appendString:@"&"];
            cursor = amp.location + 1;
            continue;
        }
        // XMLParser performs exactly one decode. Re-escape the decoded value for it.
        [result appendString:markup ? FQXXML(decoded) : decoded];
        cursor = NSMaxRange(semicolon);
    }
    return result;
}

static BOOL FQXLooksLikeMarkup(NSString *text) {
    NSString *trimmed = FQXTrim(text);
    if (trimmed.length < 2 || [trimmed characterAtIndex:0] != '<') return NO;
    unichar next = [trimmed characterAtIndex:1];
    return [[NSCharacterSet letterCharacterSet] characterIsMember:next] || next == '_' ||
           next == '/' || next == '!' || next == '?';
}

static NSString * _Nullable FQXPrepareMarkup(NSString *content, NSError **error) {
    NSMutableString *result = [NSMutableString stringWithString:@"<fqx-export-root>"];
    NSSet *voidElements = [NSSet setWithArray:@[@"br", @"hr", @"img", @"meta", @"link", @"input",
                                               @"source", @"track", @"wbr", @"area", @"base", @"col",
                                               @"embed", @"param"]];
    NSUInteger cursor = 0;
    while (cursor < content.length) {
        NSRange opening = [content rangeOfString:@"<" options:0 range:NSMakeRange(cursor, content.length - cursor)];
        NSUInteger textEnd = opening.location == NSNotFound ? content.length : opening.location;
        NSString *text = FQXDecodeEntities([content substringWithRange:NSMakeRange(cursor, textEnd - cursor)], YES, error);
        if (!text) return nil;
        [result appendString:text];
        if (opening.location == NSNotFound) break;
        cursor = opening.location;
        if (content.length - cursor >= 9 && [[content substringWithRange:NSMakeRange(cursor, 9)] isEqualToString:@"<![CDATA["]) {
            NSRange ending = [content rangeOfString:@"]]>" options:0 range:NSMakeRange(cursor + 9, content.length - cursor - 9)];
            if (ending.location == NSNotFound) {
                FQXError(error, FQXExportMalformedContent, @"正文 CDATA 未结束。");
                return nil;
            }
            [result appendString:[content substringWithRange:NSMakeRange(cursor, NSMaxRange(ending) - cursor)]];
            cursor = NSMaxRange(ending);
            continue;
        }
        if (content.length - cursor >= 4 && [[content substringWithRange:NSMakeRange(cursor, 4)] isEqualToString:@"<!--"]) {
            NSRange ending = [content rangeOfString:@"-->" options:0 range:NSMakeRange(cursor + 4, content.length - cursor - 4)];
            if (ending.location == NSNotFound) {
                FQXError(error, FQXExportMalformedContent, @"正文注释未结束。");
                return nil;
            }
            [result appendString:[content substringWithRange:NSMakeRange(cursor, NSMaxRange(ending) - cursor)]];
            cursor = NSMaxRange(ending);
            continue;
        }
        if (content.length - cursor >= 2 && [content characterAtIndex:cursor + 1] == '!') {
            NSRange doctype = [content rangeOfString:@"\\A<!doctype[ \\t\\r\\n]+html[ \\t\\r\\n]*>"
                                            options:NSRegularExpressionSearch | NSCaseInsensitiveSearch
                                              range:NSMakeRange(cursor, content.length - cursor)];
            if (doctype.location == cursor) { cursor = NSMaxRange(doctype); continue; }
            // No DTD, internal entity declarations, or external entity expansion.
            FQXError(error, FQXExportUnsafeContent, @"正文不允许 DTD 或实体声明。");
            return nil;
        }
        if (content.length - cursor >= 2 && [content characterAtIndex:cursor + 1] == '?') {
            NSRange ending = [content rangeOfString:@"?>" options:0 range:NSMakeRange(cursor + 2, content.length - cursor - 2)];
            if (ending.location == NSNotFound) {
                FQXError(error, FQXExportMalformedContent, @"正文处理指令未结束。");
                return nil;
            }
            NSString *declaration = [content substringWithRange:NSMakeRange(cursor, NSMaxRange(ending) - cursor)];
            BOOL initial = FQXTrim([content substringToIndex:cursor]).length == 0;
            if (!initial || ![declaration hasPrefix:@"<?xml "]) {
                FQXError(error, FQXExportUnsafeContent, @"正文不允许外部资源处理指令。");
                return nil;
            }
            NSString *probe = [declaration stringByAppendingString:@"<root/>"];
            NSXMLParser *declarationParser = [[NSXMLParser alloc] initWithData:[probe dataUsingEncoding:NSUTF8StringEncoding]];
            declarationParser.shouldResolveExternalEntities = NO;
            if (![declarationParser parse]) {
                FQXError(error, FQXExportMalformedContent, @"正文 XML 声明无效。");
                return nil;
            }
            cursor = NSMaxRange(ending);
            continue;
        }
        NSUInteger end = cursor + 1;
        unichar quote = 0;
        for (; end < content.length; end++) {
            unichar c = [content characterAtIndex:end];
            if (quote) { if (c == quote) quote = 0; }
            else if (c == '\'' || c == '"') quote = c;
            else if (c == '>') break;
        }
        if (end == content.length) {
            FQXError(error, FQXExportMalformedContent, @"正文标签未结束。");
            return nil;
        }
        NSString *tag = [content substringWithRange:NSMakeRange(cursor, end - cursor + 1)];
        NSUInteger nameStart = [tag hasPrefix:@"</"] ? 2 : 1;
        NSUInteger nameEnd = nameStart;
        NSCharacterSet *nameCharacters = [NSCharacterSet characterSetWithCharactersInString:
                                         @"abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ0123456789_:-."];
        while (nameEnd < tag.length && [nameCharacters characterIsMember:[tag characterAtIndex:nameEnd]]) nameEnd++;
        NSString *name = [[tag substringWithRange:NSMakeRange(nameStart, nameEnd - nameStart)] lowercaseString];
        if (![tag hasPrefix:@"</"] && ([name isEqualToString:@"script"] || [name isEqualToString:@"style"]) &&
            ![FQXTrim([tag substringToIndex:tag.length - 1]) hasSuffix:@"/"]) {
            NSString *pattern = [NSString stringWithFormat:@"</%@[ \\t\\r\\n]*>", name];
            NSRange closing = [content rangeOfString:pattern options:NSRegularExpressionSearch | NSCaseInsensitiveSearch
                                              range:NSMakeRange(end + 1, content.length - end - 1)];
            if (closing.location == NSNotFound) {
                FQXError(error, FQXExportMalformedContent, @"正文脚本或样式标签未结束。");
                return nil;
            }
            cursor = NSMaxRange(closing);
            continue;
        }
        NSString *decodedTag = FQXDecodeEntities(tag, YES, error);
        if (!decodedTag) return nil;
        if (![tag hasPrefix:@"</"] && [voidElements containsObject:name] && ![FQXTrim([tag substringToIndex:tag.length - 1]) hasSuffix:@"/"]) {
            decodedTag = [[decodedTag substringToIndex:decodedTag.length - 1] stringByAppendingString:@"/>"];
        }
        [result appendString:decodedTag];
        cursor = end + 1;
    }
    [result appendString:@"</fqx-export-root>"];
    return result;
}

@interface FQXContentParser : NSObject <NSXMLParserDelegate>
@property(nonatomic, strong) NSMutableArray<NSString *> *paragraphs;
@property(nonatomic, strong) NSMutableString *current;
@property(nonatomic) NSUInteger skippedDepth;
@property(nonatomic, strong, nullable) NSError *error;
- (void)flush;
@end

@implementation FQXContentParser
- (instancetype)init {
    self = [super init];
    if (self) { _paragraphs = [NSMutableArray array]; _current = [NSMutableString string]; }
    return self;
}
- (void)flush {
    NSString *paragraph = FQXTrim(FQXNormalizeNewlines(self.current));
    if (paragraph.length) [self.paragraphs addObject:paragraph];
    [self.current setString:@""];
}
- (BOOL)isBlock:(NSString *)name {
    return [@[@"p", @"para", @"paragraph", @"div", @"section", @"article", @"h1", @"h2", @"h3", @"h4",
               @"h5", @"h6", @"li", @"blockquote", @"pre", @"tr", @"td", @"th", @"figure", @"figcaption",
               @"chapter", @"title", @"content"] containsObject:name];
}
- (void)reject:(NSXMLParser *)parser message:(NSString *)message {
    NSError *error;
    FQXError(&error, FQXExportUnsafeContent, message);
    self.error = error;
    [parser abortParsing];
}
- (void)parser:(NSXMLParser *)parser didStartElement:(NSString *)elementName
  namespaceURI:(NSString *)namespaceURI qualifiedName:(NSString *)qName
    attributes:(NSDictionary<NSString *, NSString *> *)attributes {
    (void)qName;
    if (self.skippedDepth) { self.skippedDepth++; return; }
    NSString *name = elementName.lowercaseString;
    if ([name isEqualToString:@"script"] || [name isEqualToString:@"style"] || [name isEqualToString:@"head"]) {
        self.skippedDepth = 1;
        return;
    }
    if ([namespaceURI isEqualToString:@"http://www.w3.org/2001/XInclude"] ||
        [@[@"iframe", @"object", @"embed", @"base", @"link"] containsObject:name]) {
        [self reject:parser message:@"正文包含不支持的外部资源。"]; return;
    }
    if ([name isEqualToString:@"img"]) {
        NSString *alt = attributes[@"alt"];
        [self.current appendString:alt.length ? [NSString stringWithFormat:@"[图片：%@]", alt] : @"[图片]"];
    } else if ([name isEqualToString:@"br"] || [name isEqualToString:@"hr"] || [self isBlock:name]) {
        [self flush];
    }
}
- (void)parser:(NSXMLParser *)parser didEndElement:(NSString *)elementName
  namespaceURI:(NSString *)namespaceURI qualifiedName:(NSString *)qName {
    (void)parser; (void)namespaceURI; (void)qName;
    if (self.skippedDepth) { self.skippedDepth--; return; }
    if ([self isBlock:elementName.lowercaseString]) [self flush];
}
- (void)parser:(NSXMLParser *)parser foundCharacters:(NSString *)string {
    (void)parser;
    if (!self.skippedDepth) [self.current appendString:string];
}
- (void)parser:(NSXMLParser *)parser foundCDATA:(NSData *)CDATABlock {
    if (self.skippedDepth) return;
    NSString *text = [[NSString alloc] initWithData:CDATABlock encoding:NSUTF8StringEncoding];
    if (!text) [self reject:parser message:@"正文 CDATA 编码无效。"];
    else [self.current appendString:text];
}
- (NSData *)parser:(NSXMLParser *)parser resolveExternalEntityName:(NSString *)name systemID:(NSString *)systemID {
    (void)name; (void)systemID;
    [self reject:parser message:@"正文不允许外部实体。"];
    return nil;
}
- (void)parser:(NSXMLParser *)parser foundInternalEntityDeclarationWithName:(NSString *)name value:(NSString *)value {
    (void)name; (void)value;
    [self reject:parser message:@"正文不允许实体声明。"];
}
- (void)parser:(NSXMLParser *)parser parseErrorOccurred:(NSError *)parseError {
    (void)parser;
    if (!self.error) self.error = [NSError errorWithDomain:FQXBookExportErrorDomain code:FQXExportMalformedContent
                                                userInfo:@{NSLocalizedDescriptionKey: @"正文 XML/HTML 格式无效。",
                                                           NSUnderlyingErrorKey: parseError}];
}
@end

NSArray<NSString *> *FQXParagraphsFromContent(NSString *content, NSError **error) {
    if (!FQXValidText(content) || !FQXTrim(content).length) {
        FQXError(error, FQXExportInvalidInput, @"章节正文为空或包含无效字符。");
        return nil;
    }
    NSString *normalized = FQXNormalizeNewlines(content);
    if (!FQXLooksLikeMarkup(normalized)) {
        normalized = FQXDecodeEntities(normalized, NO, error);
        if (!normalized) return nil;
    }
    NSArray<NSString *> *paragraphs;
    if (FQXLooksLikeMarkup(normalized)) {
        NSString *markup = FQXPrepareMarkup(normalized, error);
        if (!markup) return nil;
        FQXContentParser *delegate = [[FQXContentParser alloc] init];
        NSXMLParser *parser = [[NSXMLParser alloc] initWithData:[markup dataUsingEncoding:NSUTF8StringEncoding]];
        parser.shouldResolveExternalEntities = NO;
        parser.shouldProcessNamespaces = YES;
        parser.delegate = delegate;
        BOOL parsed = [parser parse];
        if (!parsed || delegate.error) {
            if (error) *error = delegate.error ?: parser.parserError;
            return nil;
        }
        [delegate flush];
        paragraphs = [delegate.paragraphs copy];
    } else {
        NSMutableArray *lines = [NSMutableArray array];
        for (NSString *line in [normalized componentsSeparatedByString:@"\n"]) {
            NSString *paragraph = FQXTrim(line);
            if (paragraph.length) [lines addObject:paragraph];
        }
        paragraphs = lines;
    }
    if (!paragraphs.count) {
        FQXError(error, FQXExportInvalidInput, @"章节正文没有可导出的文字。");
        return nil;
    }
    return paragraphs;
}

static void FQXLE16(NSMutableData *data, uint16_t value) {
    uint8_t bytes[] = {(uint8_t)value, (uint8_t)(value >> 8)};
    [data appendBytes:bytes length:sizeof(bytes)];
}
static void FQXLE32(NSMutableData *data, uint32_t value) {
    uint8_t bytes[] = {(uint8_t)value, (uint8_t)(value >> 8), (uint8_t)(value >> 16), (uint8_t)(value >> 24)};
    [data appendBytes:bytes length:sizeof(bytes)];
}
static uint32_t FQXCRC32(uint32_t crc, NSData *data) {
    const uint8_t *bytes = data.bytes;
    for (NSUInteger i = 0; i < data.length; i++) {
        crc ^= bytes[i];
        for (unsigned bit = 0; bit < 8; bit++) crc = (crc >> 1) ^ ((crc & 1) ? 0xedb88320U : 0);
    }
    return crc;
}

typedef NS_ENUM(NSUInteger, FQXWriterState) {
    FQXWriterReady, FQXWriterFinished, FQXWriterCancelled, FQXWriterFailed
};

@interface FQXBookExportWriter () {
    int _fd;
    FQXWriterState _state;
    FQXBookExportFormat _format;
    NSURL *_destination;
    NSURL *_staging;
    NSDictionary<NSString *, NSString *> *_book;
    NSUInteger _chapterCount;
    uint64_t _offset;
    NSMutableArray<NSDictionary *> *_chapters;
    NSMutableArray<NSDictionary *> *_zipEntries;
    NSString *_zipName;
    uint64_t _zipStart;
    uint64_t _zipSize;
    uint32_t _zipCRC;
}
@end

@implementation FQXBookExportWriter
- (BOOL)fail:(NSError **)error code:(FQXExportError)code message:(NSString *)message {
    [self cancel];
    _state = FQXWriterFailed;
    return FQXError(error, code, message);
}
- (BOOL)writeData:(NSData *)data error:(NSError **)error {
    if (_format == FQXBookExportFormatEPUB && (data.length > UINT32_MAX || _offset > UINT32_MAX - data.length))
        return [self fail:error code:FQXExportTooLarge message:@"EPUB 超出当前 ZIP 格式的容量限制。"];
    const uint8_t *bytes = data.bytes;
    NSUInteger remaining = data.length;
    while (remaining) {
        ssize_t written = write(_fd, bytes, MIN(remaining, (NSUInteger)SSIZE_MAX));
        if (written < 0 && errno == EINTR) continue;
        if (written <= 0) return [self fail:error code:FQXExportIOError message:@"无法写入导出文件，请检查可用空间。"];
        bytes += written;
        remaining -= (NSUInteger)written;
        _offset += (uint64_t)written;
    }
    return YES;
}
- (BOOL)writeString:(NSString *)string error:(NSError **)error {
    NSData *data = [string dataUsingEncoding:NSUTF8StringEncoding allowLossyConversion:NO];
    if (!data) return [self fail:error code:FQXExportInvalidInput message:@"文字无法编码为 UTF-8。"];
    return [self writeData:data error:error];
}
- (BOOL)beginZIPEntry:(NSString *)name error:(NSError **)error {
    if (_zipName || _zipEntries.count == UINT16_MAX)
        return [self fail:error code:FQXExportTooLarge message:@"EPUB 条目数量超出限制。"];
    NSData *nameData = [name dataUsingEncoding:NSUTF8StringEncoding];
    _zipStart = _offset;
    _zipSize = 0;
    _zipCRC = UINT32_MAX;
    _zipName = name;
    NSMutableData *header = [NSMutableData data];
    FQXLE32(header, 0x04034b50); FQXLE16(header, 20); FQXLE16(header, 8);
    FQXLE16(header, 0); FQXLE16(header, 0); FQXLE16(header, 0x21);
    FQXLE32(header, 0); FQXLE32(header, 0); FQXLE32(header, 0);
    FQXLE16(header, (uint16_t)nameData.length); FQXLE16(header, 0);
    [header appendData:nameData];
    return [self writeData:header error:error];
}
- (BOOL)writeZIPString:(NSString *)string error:(NSError **)error {
    NSData *data = [string dataUsingEncoding:NSUTF8StringEncoding allowLossyConversion:NO];
    if (!data) return [self fail:error code:FQXExportInvalidInput message:@"文字无法编码为 UTF-8。"];
    if (data.length > UINT32_MAX || _zipSize > UINT32_MAX - data.length)
        return [self fail:error code:FQXExportTooLarge message:@"EPUB 章节大小超出限制。"];
    _zipCRC = FQXCRC32(_zipCRC, data);
    _zipSize += data.length;
    return [self writeData:data error:error];
}
- (BOOL)endZIPEntry:(NSError **)error {
    uint32_t crc = _zipCRC ^ UINT32_MAX;
    NSMutableData *descriptor = [NSMutableData data];
    FQXLE32(descriptor, 0x08074b50); FQXLE32(descriptor, crc);
    FQXLE32(descriptor, (uint32_t)_zipSize); FQXLE32(descriptor, (uint32_t)_zipSize);
    if (![self writeData:descriptor error:error]) return NO;
    [_zipEntries addObject:@{@"name": _zipName, @"offset": @(_zipStart), @"size": @(_zipSize),
                            @"crc": @(crc), @"flags": @8}];
    _zipName = nil;
    return YES;
}
- (BOOL)addZIPEntry:(NSString *)name string:(NSString *)string error:(NSError **)error {
    return [self beginZIPEntry:name error:error] && [self writeZIPString:string error:error] && [self endZIPEntry:error];
}
- (BOOL)startEPUB:(NSError **)error {
    // The EPUB mimetype entry is first, stored, with no extra field or descriptor.
    NSData *name = [@"mimetype" dataUsingEncoding:NSASCIIStringEncoding];
    NSData *content = [@"application/epub+zip" dataUsingEncoding:NSASCIIStringEncoding];
    uint32_t crc = FQXCRC32(UINT32_MAX, content) ^ UINT32_MAX;
    NSMutableData *header = [NSMutableData data];
    FQXLE32(header, 0x04034b50); FQXLE16(header, 20); FQXLE16(header, 0);
    FQXLE16(header, 0); FQXLE16(header, 0); FQXLE16(header, 0x21);
    FQXLE32(header, crc); FQXLE32(header, (uint32_t)content.length); FQXLE32(header, (uint32_t)content.length);
    FQXLE16(header, (uint16_t)name.length); FQXLE16(header, 0); [header appendData:name];
    if (![self writeData:header error:error] || ![self writeData:content error:error]) return NO;
    [_zipEntries addObject:@{@"name": @"mimetype", @"offset": @0, @"size": @(content.length), @"crc": @(crc), @"flags": @0}];
    return [self addZIPEntry:@"META-INF/container.xml"
                      string:@"<?xml version=\"1.0\" encoding=\"UTF-8\"?><container version=\"1.0\" xmlns=\"urn:oasis:names:tc:opendocument:xmlns:container\"><rootfiles><rootfile full-path=\"OEBPS/package.opf\" media-type=\"application/oebps-package+xml\"/></rootfiles></container>"
                       error:error];
}
- (instancetype)initWithBook:(NSDictionary *)book format:(FQXBookExportFormat)format
                 destination:(NSURL *)destination error:(NSError **)error {
    self = [super init];
    if (!self) return nil;
    _fd = -1;
    if (![book isKindOfClass:NSDictionary.class] || !FQXValidText(book[@"title"]) || !FQXTrim(book[@"title"]).length ||
        (book[@"author"] && !FQXValidText(book[@"author"])) || (book[@"id"] && !FQXValidText(book[@"id"])) ||
        format < FQXBookExportFormatTXT || format > FQXBookExportFormatJSON ||
        ![destination isKindOfClass:NSURL.class] || !destination.isFileURL || !destination.path.length) {
        FQXError(error, FQXExportInvalidInput, @"书籍信息、格式或导出位置无效。");
        return nil;
    }
    _format = format;
    _book = @{@"id": [book[@"id"] ?: @"" copy], @"title": [book[@"title"] copy], @"author": [book[@"author"] ?: @"" copy]};
    _destination = [destination URLByStandardizingPath];
    NSFileManager *manager = NSFileManager.defaultManager;
    BOOL directory = NO;
    NSURL *parent = [_destination URLByDeletingLastPathComponent];
    if ([manager fileExistsAtPath:_destination.path] ||
        ![manager fileExistsAtPath:parent.path isDirectory:&directory] || !directory) {
        FQXError(error, FQXExportIOError, @"导出文件已存在，或目标文件夹不可用。");
        return nil;
    }
    NSString *scratchName = [NSString stringWithFormat:@".fqx-export-%@.tmp", NSUUID.UUID.UUIDString];
    NSURL *staging = [parent URLByAppendingPathComponent:scratchName];
    _fd = open(staging.fileSystemRepresentation, O_WRONLY | O_CREAT | O_EXCL, 0600);
    if (_fd < 0) {
        FQXError(error, FQXExportIOError, @"无法创建导出暂存文件。");
        return nil;
    }
    _staging = staging;
    _chapters = [NSMutableArray array];
    _zipEntries = [NSMutableArray array];
    NSString *title = _book[@"title"], *author = _book[@"author"];
    BOOL started = YES;
    switch (format) {
        case FQXBookExportFormatTXT:
            started = [self writeString:[NSString stringWithFormat:@"%@\n%@\n", title,
                                        author.length ? [NSString stringWithFormat:@"作者：%@\n", author] : @""] error:error];
            break;
        case FQXBookExportFormatMarkdown:
            started = [self writeString:[NSString stringWithFormat:@"# %@\n\n%@", FQXMarkdown(title),
                                        author.length ? [NSString stringWithFormat:@"作者：%@\n\n", FQXMarkdown(author)] : @""] error:error];
            break;
        case FQXBookExportFormatHTML:
            started = [self writeString:[NSString stringWithFormat:
                         @"<!DOCTYPE html>\n<html lang=\"zh-CN\"><head><meta charset=\"utf-8\"/><meta name=\"viewport\" content=\"width=device-width, initial-scale=1\"/><title>%@</title><meta name=\"author\" content=\"%@\"/></head><body><header><h1>%@</h1><p class=\"author\">%@</p></header>\n",
                         FQXXML(title), FQXXML(author), FQXXML(title), FQXXML(author)] error:error];
            break;
        case FQXBookExportFormatEPUB: started = [self startEPUB:error]; break;
        case FQXBookExportFormatJSON: {
            NSData *metadata = [NSJSONSerialization dataWithJSONObject:_book options:0 error:error];
            if (!metadata) { [self cancel]; return nil; }
            started = [self writeData:[metadata subdataWithRange:NSMakeRange(0, metadata.length - 1)] error:error] &&
                      [self writeString:@",\"chapters\":[" error:error];
            break;
        }
    }
    return started ? self : nil;
}
- (BOOL)appendChapter:(NSDictionary *)chapter error:(NSError **)error {
    if (_state != FQXWriterReady) return FQXError(error, FQXExportInvalidState, @"导出已结束或已取消。");
    if (![chapter isKindOfClass:NSDictionary.class] || !FQXValidText(chapter[@"title"]) || !FQXTrim(chapter[@"title"]).length ||
        (chapter[@"id"] && !FQXValidText(chapter[@"id"])) || ![chapter[@"paragraphs"] isKindOfClass:NSArray.class])
        return [self fail:error code:FQXExportInvalidInput message:@"章节信息或正文无效。"];
    NSArray *paragraphs = chapter[@"paragraphs"];
    BOOL hasText = NO;
    for (id paragraph in paragraphs) {
        if (!FQXValidText(paragraph)) return [self fail:error code:FQXExportInvalidInput message:@"章节正文包含无效字符。"];
        if (FQXTrim(paragraph).length) hasText = YES;
    }
    if (!hasText) return [self fail:error code:FQXExportInvalidInput message:@"章节正文为空。"];
    NSString *title = chapter[@"title"];
    NSUInteger index = _chapterCount + 1;
    BOOL written = YES;
    switch (_format) {
        case FQXBookExportFormatTXT:
            written = [self writeString:[NSString stringWithFormat:@"%@\n\n", title] error:error];
            for (NSString *paragraph in paragraphs) {
                if (!written) break;
                written = [self writeString:[paragraph stringByAppendingString:@"\n\n"] error:error];
            }
            break;
        case FQXBookExportFormatMarkdown:
            written = [self writeString:[NSString stringWithFormat:@"## %@\n\n", FQXMarkdown(title)] error:error];
            for (NSString *paragraph in paragraphs) {
                if (!written) break;
                written = [self writeString:[FQXMarkdown(paragraph) stringByAppendingString:@"\n\n"] error:error];
            }
            break;
        case FQXBookExportFormatHTML:
            written = [self writeString:[NSString stringWithFormat:@"<section id=\"chapter-%lu\"><h2>%@</h2>\n", (unsigned long)index, FQXXML(title)] error:error];
            for (NSString *paragraph in paragraphs) {
                if (!written) break;
                written = [self writeString:[NSString stringWithFormat:@"<p>%@</p>\n", FQXHTMLParagraph(paragraph)] error:error];
            }
            if (written) written = [self writeString:@"</section>\n" error:error];
            break;
        case FQXBookExportFormatEPUB: {
            NSString *entry = [NSString stringWithFormat:@"chapter-%06lu.xhtml", (unsigned long)index];
            written = [self beginZIPEntry:[@"OEBPS/" stringByAppendingString:entry] error:error] &&
                      [self writeZIPString:[NSString stringWithFormat:@"<?xml version=\"1.0\" encoding=\"UTF-8\"?><html xmlns=\"http://www.w3.org/1999/xhtml\" lang=\"zh-CN\" xml:lang=\"zh-CN\"><head><title>%@</title></head><body><h1>%@</h1>", FQXXML(title), FQXXML(title)] error:error];
            for (NSString *paragraph in paragraphs) {
                if (!written) break;
                written = [self writeZIPString:[NSString stringWithFormat:@"<p>%@</p>\n", FQXHTMLParagraph(paragraph)] error:error];
            }
            if (written) written = [self writeZIPString:@"</body></html>" error:error] && [self endZIPEntry:error];
            if (written) [_chapters addObject:@{@"title": [title copy], @"entry": entry}];
            break;
        }
        case FQXBookExportFormatJSON: {
            NSDictionary *record = @{@"id": chapter[@"id"] ?: @"", @"title": title, @"paragraphs": paragraphs};
            NSData *data = [NSJSONSerialization dataWithJSONObject:record options:0 error:error];
            if (!data) return [self fail:error code:FQXExportInvalidInput message:@"章节无法写入 JSON。"];
            if (_chapterCount) written = [self writeString:@"," error:error];
            if (written) written = [self writeData:data error:error];
            break;
        }
    }
    if (written) _chapterCount = index;
    return written;
}
- (BOOL)finishEPUB:(NSError **)error {
    NSString *title = FQXXML(_book[@"title"]), *author = FQXXML(_book[@"author"]);
    NSString *identifier = _book[@"id"].length ? [@"urn:fanqiex:" stringByAppendingString:_book[@"id"]] : [@"urn:uuid:" stringByAppendingString:NSUUID.UUID.UUIDString];
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    formatter.locale = [[NSLocale alloc] initWithLocaleIdentifier:@"en_US_POSIX"];
    formatter.timeZone = [NSTimeZone timeZoneForSecondsFromGMT:0];
    formatter.dateFormat = @"yyyy-MM-dd'T'HH:mm:ss'Z'";
    NSString *modified = [formatter stringFromDate:NSDate.date];
    if (![self beginZIPEntry:@"OEBPS/package.opf" error:error] ||
        ![self writeZIPString:[NSString stringWithFormat:
          @"<?xml version=\"1.0\" encoding=\"UTF-8\"?><package xmlns=\"http://www.idpf.org/2007/opf\" version=\"3.0\" unique-identifier=\"book-id\" xml:lang=\"zh-CN\"><metadata xmlns:dc=\"http://purl.org/dc/elements/1.1/\"><dc:identifier id=\"book-id\">%@</dc:identifier><dc:title>%@</dc:title><dc:creator>%@</dc:creator><dc:language>zh-CN</dc:language><meta property=\"dcterms:modified\">%@</meta></metadata><manifest><item id=\"nav\" href=\"nav.xhtml\" media-type=\"application/xhtml+xml\" properties=\"nav\"/>",
          FQXXML(identifier), title, author, modified] error:error]) return NO;
    NSUInteger index = 0;
    for (NSDictionary *chapter in _chapters) {
        index++;
        if (![self writeZIPString:[NSString stringWithFormat:@"<item id=\"c%lu\" href=\"%@\" media-type=\"application/xhtml+xml\"/>", (unsigned long)index, chapter[@"entry"]] error:error]) return NO;
    }
    if (![self writeZIPString:@"</manifest><spine>" error:error]) return NO;
    for (NSUInteger i = 1; i <= _chapters.count; i++) {
        if (![self writeZIPString:[NSString stringWithFormat:@"<itemref idref=\"c%lu\"/>", (unsigned long)i] error:error]) return NO;
    }
    if (![self writeZIPString:@"</spine></package>" error:error] || ![self endZIPEntry:error] ||
        ![self beginZIPEntry:@"OEBPS/nav.xhtml" error:error] ||
        ![self writeZIPString:[NSString stringWithFormat:@"<?xml version=\"1.0\" encoding=\"UTF-8\"?><html xmlns=\"http://www.w3.org/1999/xhtml\" xmlns:epub=\"http://www.idpf.org/2007/ops\" lang=\"zh-CN\" xml:lang=\"zh-CN\"><head><title>%@</title></head><body><nav epub:type=\"toc\" id=\"toc\"><h1>目录</h1><ol>", title] error:error]) return NO;
    for (NSDictionary *chapter in _chapters) {
        if (![self writeZIPString:[NSString stringWithFormat:@"<li><a href=\"%@\">%@</a></li>", chapter[@"entry"], FQXXML(chapter[@"title"])] error:error]) return NO;
    }
    if (![self writeZIPString:@"</ol></nav></body></html>" error:error] || ![self endZIPEntry:error]) return NO;
    uint64_t centralOffset = _offset;
    for (NSDictionary *entry in _zipEntries) {
        NSData *name = [entry[@"name"] dataUsingEncoding:NSUTF8StringEncoding];
        NSMutableData *header = [NSMutableData data];
        FQXLE32(header, 0x02014b50); FQXLE16(header, 20); FQXLE16(header, 20);
        FQXLE16(header, [entry[@"flags"] unsignedShortValue]); FQXLE16(header, 0);
        FQXLE16(header, 0); FQXLE16(header, 0x21); FQXLE32(header, [entry[@"crc"] unsignedIntValue]);
        FQXLE32(header, [entry[@"size"] unsignedIntValue]); FQXLE32(header, [entry[@"size"] unsignedIntValue]);
        FQXLE16(header, (uint16_t)name.length); FQXLE16(header, 0); FQXLE16(header, 0);
        FQXLE16(header, 0); FQXLE16(header, 0); FQXLE32(header, 0);
        FQXLE32(header, [entry[@"offset"] unsignedIntValue]); [header appendData:name];
        if (![self writeData:header error:error]) return NO;
    }
    uint64_t centralSize = _offset - centralOffset;
    NSMutableData *end = [NSMutableData data];
    FQXLE32(end, 0x06054b50); FQXLE16(end, 0); FQXLE16(end, 0);
    FQXLE16(end, (uint16_t)_zipEntries.count); FQXLE16(end, (uint16_t)_zipEntries.count);
    FQXLE32(end, (uint32_t)centralSize); FQXLE32(end, (uint32_t)centralOffset); FQXLE16(end, 0);
    return [self writeData:end error:error];
}
- (BOOL)finish:(NSError **)error {
    if (_state != FQXWriterReady) return FQXError(error, FQXExportInvalidState, @"导出已结束或已取消。");
    if (!_chapterCount) return [self fail:error code:FQXExportInvalidInput message:@"没有可导出的章节。"];
    switch (_format) {
        case FQXBookExportFormatHTML:
            if (![self writeString:@"</body></html>\n" error:error]) return NO;
            break;
        case FQXBookExportFormatJSON:
            if (![self writeString:@"]}\n" error:error]) return NO;
            break;
        case FQXBookExportFormatEPUB:
            if (![self finishEPUB:error]) return NO;
            break;
        case FQXBookExportFormatTXT: case FQXBookExportFormatMarkdown: break;
    }
    int descriptor = _fd;
    _fd = -1;
    if (close(descriptor) != 0) return [self fail:error code:FQXExportIOError message:@"无法完成导出文件写入。"];
    NSError *moveError;
    if (![NSFileManager.defaultManager moveItemAtURL:_staging toURL:_destination error:&moveError]) {
        [self cancel]; _state = FQXWriterFailed;
        if (error) *error = [NSError errorWithDomain:FQXBookExportErrorDomain code:FQXExportIOError
                                           userInfo:@{NSLocalizedDescriptionKey: @"无法保存导出文件，目标可能已存在。",
                                                      NSUnderlyingErrorKey: moveError}];
        return NO;
    }
    _staging = nil;
    _state = FQXWriterFinished;
    return YES;
}
- (void)cancel {
    if (_state == FQXWriterFinished) return;
    if (_fd >= 0) { close(_fd); _fd = -1; }
    if (_staging) { [NSFileManager.defaultManager removeItemAtURL:_staging error:NULL]; _staging = nil; }
    _state = FQXWriterCancelled;
}
- (void)dealloc { [self cancel]; }
@end
