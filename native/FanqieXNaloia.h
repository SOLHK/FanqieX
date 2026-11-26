#import <UIKit/UIKit.h>

typedef NS_ENUM(NSInteger, FQXNaloiaRole) {
    FQXNaloiaFavorite,
    FQXNaloiaComment,
    FQXNaloiaLike,
    FQXNaloiaShare,
    FQXNaloiaRoleCount
};

NSString *FQXNaloiaPreferenceKey(FQXNaloiaRole role);
BOOL FQXNaloiaEnabled(FQXNaloiaRole role);
void FQXNaloiaPanelDidOpen(UIView *owner, FQXNaloiaRole role);
void FQXNaloiaPanelDidClose(UIView *owner, FQXNaloiaRole role);
