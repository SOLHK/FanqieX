#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

FOUNDATION_EXPORT NSString *const FQXDockDetachedEnabledPrefKey;
FOUNDATION_EXPORT NSString *const FQXDockDetachedModulePrefKey;

BOOL FQXDockDetachedIsEnabled(void);
NSString *FQXDockDetachedStoredModule(void);
NSString * _Nullable FQXDockBottomPrefKeyForModuleTitle(NSString *title);
BOOL FQXDockIsModuleAllowedByBottomPrefs(NSString *title);
BOOL FQXDockRestoreBottomEntryForModule(NSString *title);
void FQXDockDetachedUpdateHostModules(NSArray<NSString *> *visibleTitles);
NSArray<NSString *> *FQXDockDetachedAvailableModules(void);
NSArray<NSString *> *FQXDockDetachedAllKnownModules(void);
NSInteger FQXDockDetachedResolveIndex(NSArray<NSString *> *visibleTitles);
NSInteger FQXDockDetachedResolveIndexWithReason(NSArray<NSString *> *visibleTitles,
                                                NSString * _Nullable __autoreleasing * _Nullable outReason);

@interface FQXDetachedDockButtonView : UIView
@property(nonatomic, strong, readonly) UIVisualEffectView *glassView;
@property(nonatomic, strong, readonly) UIView *selectionLens;
@property(nonatomic, strong, readonly) UIButton *hitButton;
@property(nonatomic, weak, nullable) UIButton *targetHostButton;
@property(nonatomic, copy, nullable) NSString *moduleTitle;
@property(nonatomic, copy, nullable) void (^onTapModule)(UIButton * _Nullable hostButton);
@property(nonatomic, copy, nullable) void (^onTouchDiagnostic)(NSString *stage, NSDictionary<NSString *, id> *info);
@property(nonatomic, readonly, getter=isModuleSelected) BOOL moduleSelected;
@property(nonatomic) CGFloat feedGlyphScale;

- (void)setModuleSelected:(BOOL)selected animated:(BOOL)animated;
- (void)updateImagesNormal:(nullable UIImage *)normalImage
                  selected:(nullable UIImage *)selectedImage;
- (void)applyGlassEffect:(nullable UIVisualEffect *)effect
          interfaceStyle:(UIUserInterfaceStyle)style
          selectionColor:(UIColor *)selectionColor
      reduceTransparency:(BOOL)reduceTransparency
              styleStamp:(NSInteger)styleStamp;
- (void)applyVideoSurfaceBase:(BOOL)videoBase
            videoSelectedPill:(BOOL)videoSelectedPill;
- (void)syncUnreadBadgeFromHostButton:(nullable UIButton *)hostButton;
@end

NS_ASSUME_NONNULL_END
