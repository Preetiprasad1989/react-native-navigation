#import "BottomTabsAttachMode.h"
#import "RNNOptions.h"
#import "RNNShadowOptions.h"

@interface RNNBottomTabsOptions : RNNOptions

@property(nonatomic, strong) Bool *visible;
@property(nonatomic, strong) IntNumber *currentTabIndex;
@property(nonatomic, strong) Bool *drawBehind;
@property(nonatomic, strong) Bool *animate;
@property(nonatomic, strong) Color *tabColor;
@property(nonatomic, strong) Color *selectedTabColor;
@property(nonatomic, strong) Bool *translucent;
@property(nonatomic, strong) Bool *hideShadow;
@property(nonatomic, strong) Color *backgroundColor;
@property(nonatomic, strong) Number *fontSize;
@property(nonatomic, strong) Text *testID;
@property(nonatomic, strong) Text *currentTabId;
@property(nonatomic, strong) Text *barStyle;
@property(nonatomic, strong) Text *fontFamily;
@property(nonatomic, strong) Text *titleDisplayMode;
@property(nonatomic, strong) Color *borderColor;
@property(nonatomic, strong) Number *borderWidth;
@property(nonatomic, strong) RNNShadowOptions *shadow;
@property(nonatomic, strong) BottomTabsAttachMode *tabsAttachMode;
@property(nonatomic, strong) Text *animationType;
@property(nonatomic, strong) Bool *animateTabBarButton;
@property(nonatomic, strong) Color *colorForAnimatingBackground;

- (BOOL)shouldDrawBehind;

@end
