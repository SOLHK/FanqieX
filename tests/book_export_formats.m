#import <Foundation/Foundation.h>
#import "BookExportFormats.h"

static void Check(BOOL condition, NSString *reason) {
    if (condition) return;
    fprintf(stderr, "%s\n", reason.UTF8String);
    exit(1);
}

int main(int argc, const char *argv[]) {
    @autoreleasepool {
        Check(argc == 2, @"Supply a scratch directory");
        NSURL *folder = [NSURL fileURLWithFileSystemRepresentation:argv[1] isDirectory:YES relativeToURL:nil];
        NSFileManager *files = NSFileManager.defaultManager;
        NSError *error;
        NSArray *paragraphs = FQXParagraphsFromContent(
            @"<?xml version=\"1.0\"?><body><p>第一段 &amp; &#x1F680;</p><p><![CDATA[第二段 <正文>]]></p><p>段落&nbsp;尾<img alt=\"题图\" src=\"https://invalid.example/image\"></p></body>", &error);
        Check([paragraphs isEqual:@[@"第一段 & 🚀", @"第二段 <正文>", @"段落\u00a0尾[图片：题图]"]], error.localizedDescription ?: @"Preserve XML, CDATA, entities and paragraph order");
        NSArray *plain = FQXParagraphsFromContent(@" 第一行\r\n\r\n第二行 &mdash; 结尾", &error);
        Check([plain isEqual:@[@"第一行", @"第二行 — 结尾"]], @"Plain cached text retains its paragraphs");
        for (NSString *invalid in @[@"", @"<p>未闭合", @"<p>&bogus;</p>",
            @"<!DOCTYPE body [<!ENTITY x SYSTEM 'file:///private/book'>]><body>&x;</body>",
            @"<body><?resource url='https://invalid.example/'?><p>正文</p></body>"]) {
            error = nil;
            Check(FQXParagraphsFromContent(invalid, &error) == nil && error != nil, @"Malformed or external markup must fail");
        }
        NSDictionary *book = @{@"id": @"test-book", @"title": @"小说 & <标题>", @"author": @"测试 作者"};
        NSDictionary *first = @{@"id": @"chapter-a", @"title": @"第一章 *标记* & 内容", @"paragraphs": paragraphs};
        NSDictionary *last = @{@"id": @"chapter-b", @"title": @"第二章", @"paragraphs": plain};
        NSArray<NSString *> *extensions = @[@"txt", @"md", @"html", @"epub", @"json"];
        for (NSUInteger index = 0; index < extensions.count; index++) {
            NSURL *destination = [folder URLByAppendingPathComponent:[@"fixture" stringByAppendingPathExtension:extensions[index]]];
            error = nil;
            FQXBookExportWriter *writer = [[FQXBookExportWriter alloc] initWithBook:book
                format:(FQXBookExportFormat)index destination:destination error:&error];
            Check(writer != nil, error.localizedDescription ?: @"Initialize writer");
            Check([writer appendChapter:first error:&error] && [writer appendChapter:last error:&error],
                  error.localizedDescription ?: @"Write both chapters");
            Check(![files fileExistsAtPath:destination.path], @"Publish only the completed book");
            Check([writer finish:&error] && [files fileExistsAtPath:destination.path], error.localizedDescription ?: @"Finish writer");
            if (index == FQXBookExportFormatHTML) {
                NSString *text = [NSString stringWithContentsOfURL:destination encoding:NSUTF8StringEncoding error:&error];
                Check([text containsString:@"第二段 &lt;正文&gt;"], @"Escape chapter text in HTML");
            }
            if (index == FQXBookExportFormatJSON) {
                NSData *data = [NSData dataWithContentsOfURL:destination];
                NSDictionary *json = [NSJSONSerialization JSONObjectWithData:data options:0 error:&error];
                Check([json[@"chapters"][0][@"paragraphs"] isEqual:paragraphs] &&
                      [json[@"chapters"][1][@"id"] isEqual:@"chapter-b"], @"Preserve JSON ordering and original text");
            }
        }
        NSURL *cancelled = [folder URLByAppendingPathComponent:@"cancelled.epub"];
        FQXBookExportWriter *writer = [[FQXBookExportWriter alloc] initWithBook:book
            format:FQXBookExportFormatEPUB destination:cancelled error:&error];
        Check(writer && [writer appendChapter:first error:&error], @"Prepare a cancellable export");
        [writer cancel];
        Check(![files fileExistsAtPath:cancelled.path], @"Cancellation cleans partial EPUB");
        NSURL *failed = [folder URLByAppendingPathComponent:@"failure.txt"];
        writer = [[FQXBookExportWriter alloc] initWithBook:book format:FQXBookExportFormatTXT destination:failed error:&error];
        Check(writer && [writer appendChapter:first error:&error], @"Prepare partial export");
        Check(![writer appendChapter:@{@"title": @"缺章", @"paragraphs": @[]} error:&error] &&
              ![files fileExistsAtPath:failed.path], @"Writer failure cleans partial output");
        NSArray *remaining = [files contentsOfDirectoryAtPath:folder.path error:&error];
        Check(remaining.count == 5, @"Only the five finished artifacts remain");
        puts("Book export format checks passed");
    }
    return 0;
}
