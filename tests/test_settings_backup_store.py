"""Run the production backup snapshot and import against Apple Foundation."""

from pathlib import Path
import platform
import subprocess
import tempfile
import unittest


NATIVE = Path(__file__).resolve().parents[1] / "native"

ROUND_TRIP = r"""
#include <assert.h>
#include <stdlib.h>

@interface FQXCleanup : NSObject
+ (NSArray *)optionRows;
@end

@implementation FQXCleanup
+ (NSArray *)optionRows {
    return @[@{@"key": @"FanqieX.DramaHideFullscreenButton.1", @"default": @NO}];
}
@end

int main(void) {
    @autoreleasepool {
        NSString *domain = [@"FanqieX.BackupTests." stringByAppendingString:NSUUID.UUID.UUIDString];
        NSUserDefaults *storage = [[NSUserDefaults alloc] initWithSuiteName:domain];
        NSString *hostKey = @"Reading.HostPreference";
        NSString *hiddenFullscreen = @"FanqieX.DramaHideFullscreenButton.1";
        NSString *category = @"FanqieX.DramaCategory.7.1";
        [storage setObject:@"host value" forKey:hostKey];
        [storage setBool:YES forKey:BottomIconsOnly];
        [storage setInteger:4 forKey:CommentMaterialStyle];
        [storage setBool:YES forKey:hiddenFullscreen];
        [storage setBool:NO forKey:category];

        NSDictionary *snapshot = BackupSnapshot(storage);
        assert([snapshot[BottomDisplayMode] isEqual:@1]);
        assert([snapshot[CommentComposerStyle] isEqual:@1]);
        assert([snapshot[hiddenFullscreen] isEqual:@YES]);
        assert([snapshot[category] isEqual:@NO]);
        assert(!snapshot[hostKey]);

        NSData *json = [NSJSONSerialization dataWithJSONObject:snapshot options:0 error:NULL];
        FQXSettingsBuffer encoded, decoded;
        assert(FQXSettingsEncode(json.bytes, json.length, &encoded) == FQXSettingsCodecOK);
        assert(FQXSettingsDecode(encoded.bytes, encoded.length, &decoded) == FQXSettingsCodecOK);
        free(encoded.bytes);
        NSData *payload = [NSData dataWithBytesNoCopy:decoded.bytes length:decoded.length freeWhenDone:YES];
        NSDictionary *imported = [NSJSONSerialization JSONObjectWithData:payload options:0 error:NULL];
        assert([imported isEqualToDictionary:snapshot]);

        [storage setInteger:2 forKey:BottomDisplayMode];
        [storage setInteger:2 forKey:CommentComposerStyle];
        [storage setBool:NO forKey:hiddenFullscreen];
        [storage setBool:YES forKey:category];
        [storage setObject:@"extra preset" forKey:ReaderThemePreset];
        assert(ApplySettings(storage, domain, imported, NO));
        assert([storage integerForKey:BottomDisplayMode] == 1);
        assert([storage integerForKey:CommentComposerStyle] == 1);
        assert([storage boolForKey:hiddenFullscreen]);
        assert(![storage boolForKey:category]);
        assert([[storage stringForKey:ReaderThemePreset] isEqual:@"extra preset"]);

        assert(ApplySettings(storage, domain, imported, YES));
        assert(![storage objectForKey:ReaderThemePreset]);
        assert([[storage stringForKey:hostKey] isEqual:@"host value"]);
        NSUserDefaults *reopened = [[NSUserDefaults alloc] initWithSuiteName:domain];
        assert([reopened boolForKey:hiddenFullscreen]);
        assert([reopened integerForKey:BottomDisplayMode] == 1);
        assert(![reopened objectForKey:ReaderThemePreset]);
        assert(ApplySettings(storage, domain, @{}, YES));
        assert(![storage objectForKey:BottomDisplayMode]);
        assert(![storage objectForKey:CommentComposerStyle]);
        assert(![storage objectForKey:hiddenFullscreen]);
        assert(![storage objectForKey:category]);
        assert([[storage stringForKey:hostKey] isEqual:@"host value"]);
        assert([BackupSnapshot(storage)[CommentComposerStyle] isEqual:@0]);
        [storage removePersistentDomainForName:domain];
    }
    return 0;
}
"""


class SettingsBackupStoreTests(unittest.TestCase):
    @unittest.skipUnless(platform.system() == "Darwin", "Apple Foundation is required")
    def test_backup_round_trip(self):
        source = (NATIVE / "FanqieXSettingsBackup.m").read_text(encoding="utf-8")
        # The settings store has no UIKit dependency. Compile the production
        # functions directly with Foundation on the macOS runner.
        store = source[source.index("#import <math.h>"):source.index("static NSString *CodecError")]
        with tempfile.TemporaryDirectory() as directory:
            path = Path(directory)
            program = path / "settings-backup-store"
            smoke = path / "settings-backup-store.m"
            smoke.write_text("#import <Foundation/Foundation.h>\n" + store + ROUND_TRIP, encoding="utf-8")
            subprocess.run([
                "xcrun", "--sdk", "macosx", "clang", "-fobjc-arc", "-fblocks",
                "-Wall", "-Wextra", "-Werror", "-I", str(NATIVE), str(smoke),
                str(NATIVE / "FanqieXSettingsCodec.c"), "-framework", "Foundation", "-lz", "-o", str(program),
            ], check=True)
            subprocess.run([str(program)], timeout=10, check=True)


if __name__ == "__main__":
    unittest.main()
