//
//  RNNBottomTabsAnimatedController.m
//  ReactNativeNavigation
//
//  Created by Preeti . on 18/09/24.
//  Copyright © 2024 Wix. All rights reserved.
//
const int kAnimationViewExtraWidth = 6;
#import "RNNBottomTabsAnimatedController.h"
#import <UIKit/UIKit.h>
@interface RNNBottomTabsAnimatedController ()

@property(nonatomic, assign)AnimationType animationtype;
@property(nonatomic, strong)UIColor* backgroundColorForAnimationView;

@property (nonatomic, strong) UIView *highlightView; // View to animate as the background
@end

@implementation RNNBottomTabsAnimatedController
-(instancetype)initWithLayoutInfo:(RNNLayoutInfo *)layoutInfo creator:(id<RNNComponentViewCreator>)creator options:(RNNNavigationOptions *)options defaultOptions:(RNNNavigationOptions *)defaultOptions presenter:(RNNBasePresenter *)presenter bottomTabPresenter:(BottomTabPresenter *)bottomTabPresenter dotIndicatorPresenter:(RNNDotIndicatorPresenter *)dotIndicatorPresenter eventEmitter:(RNNEventEmitter *)eventEmitter childViewControllers:(NSArray *)childViewControllers bottomTabsAttacher:(BottomTabsBaseAttacher *)bottomTabsAttacher withAnimationType:(Text*)animationType
                 animatingBgColor:(Color*)bgColor{
    
    self=[super initWithLayoutInfo:layoutInfo creator:creator options:options defaultOptions:defaultOptions presenter:presenter bottomTabPresenter:bottomTabPresenter dotIndicatorPresenter:dotIndicatorPresenter eventEmitter:eventEmitter childViewControllers:childViewControllers bottomTabsAttacher:bottomTabsAttacher];
    if([animationType.get  isEqual: @"slide"]){
        self.animationtype = SLIDE;
    }
    else if ([animationType.get  isEqual: @"jump"]){
        self.animationtype = JUMP;
    }else{
        self.animationtype = NONE;
    }
    if(bgColor && bgColor.get){
        self.backgroundColorForAnimationView = [[bgColor get] colorWithAlphaComponent:0.2];
    }else{
        self.backgroundColorForAnimationView = [UIColor colorWithRed:0.0 green:0.0 blue:1.0 alpha:0.2];
    }
    
    return self;
}
- (void)viewDidAppear:(BOOL)animated{
    [super viewDidAppear:animated];
    if(self.animationtype == SLIDE){
        [self setInitialFrame];
    }
}

// Setup the highlight view under the tab bar items
- (void)setupHighlightView {
    // Define initial size and position for the highlight view
   
    // Create the highlight view with the size of one tab bar item
    if(!self.highlightView){
        self.highlightView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 40, 40)];
        [self.tabBar insertSubview:self.highlightView atIndex:0];
    }
    
}
- (void)setInitialFrame {
    UIView *tabBarButton = [self tabBarButtonAtIndex:0];
    
    // Check if the tab bar button is available
    if (!tabBarButton) {
        return;
    }
    CGRect imageFrame = [self getFrameFor:tabBarButton AnimationForIndex:0];
    CGFloat ImageSize = imageFrame.size.width;
    if(imageFrame.size.width < imageFrame.size.height){
        ImageSize = imageFrame.size.height;
    }
   
    // Calculate the new X position for the sliding background view
    CGFloat newY = imageFrame.origin.y-kAnimationViewExtraWidth/2;
    CGFloat newX = tabBarButton.frame.origin.x + imageFrame.origin.x - kAnimationViewExtraWidth/2;
    self.highlightView.layer.backgroundColor = self.backgroundColorForAnimationView.CGColor;
    self.highlightView.layer.cornerRadius=(ImageSize+2)/2;
    self.highlightView.layer.frame = CGRectMake(newX, newY, imageFrame.size.width+kAnimationViewExtraWidth, imageFrame.size.width+kAnimationViewExtraWidth);
}
- (void)viewDidLoad {
    [super viewDidLoad];
    [self setupHighlightView];
}


- (BOOL)tabBarController:(UITabBarController *)tabBarController
    shouldSelectViewController:(UIViewController *)viewController {
    NSUInteger _index = [tabBarController.viewControllers indexOfObject:viewController];
    BOOL isMoreTab = ![tabBarController.viewControllers containsObject:viewController];

    [self.eventEmitter sendBottomTabPressed:@(_index)];
    if(self.animationtype == JUMP){
        [self animateJump:_index withTabBarController:tabBarController];
    }else if (self.animationtype == SLIDE){
        [self animateTabBarItemAtIndex:_index withTabBarController:tabBarController];
    }
    
    if ([[viewController resolveOptions].bottomTab.selectTabOnPress withDefault:YES] || isMoreTab) {
        return YES;
    }

    return NO;
}
- (CGRect) getFrameFor:(UIView*)tabBarButton AnimationForIndex:(NSInteger)index{
    // Access the tab bar button's view
   
    self.highlightView.layer.backgroundColor = self.backgroundColorForAnimationView.CGColor;
    
    CGRect frame = CGRectZero;
    for (UIView *view1 in tabBarButton.subviews) {
        if([view1 isKindOfClass:[UIImageView class]]){
            frame = view1.frame;
        }
    }
    return frame;
}
-(void)animateJump:(NSInteger)index withTabBarController:(UITabBarController*)
tabBarController{
    UIView *tabBarButton = [self tabBarButtonAtIndex:index];
    
    // Check if the tab bar button is available
    if (!tabBarButton) {
        return;
    }
    UIView *popUp = nil;
    for (UIView *view1 in tabBarButton.subviews) {
        if([view1 isKindOfClass:[UIImageView class]]){
            popUp = view1;
        }
    }
    
    popUp.transform = CGAffineTransformScale(CGAffineTransformIdentity, 0.001, 0.001);


    [UIView animateWithDuration:0.6/1.5 animations:^{
        popUp.transform = CGAffineTransformScale(CGAffineTransformIdentity, 1.1, 1.1);
    } completion:^(BOOL finished) {
        [UIView animateWithDuration:0.3/2 animations:^{
            popUp.transform = CGAffineTransformScale(CGAffineTransformIdentity, 0.9, 0.9);
        } completion:^(BOOL finished) {
            [UIView animateWithDuration:0.3/2 animations:^{
                popUp.transform = CGAffineTransformIdentity;
            }];
        }];
    }];
   
}
// Method to apply the jump animation to a tab bar item
- (void)animateTabBarItemAtIndex:(NSInteger)index withTabBarController:(UITabBarController *)tabBarController {
    UIView *tabBarButton = [self tabBarButtonAtIndex:index];
    
    // Check if the tab bar button is available
    if (!tabBarButton) {
        return;
    }
    CGRect imageFrame = [self getFrameFor:tabBarButton AnimationForIndex:index];
    __weak typeof(self) weakSelf = self;
    [UIView cancelPreviousPerformRequestsWithTarget:self];
    // Create the jump animation
    // Calculate the new X position for the sliding background view
    CGFloat newY = imageFrame.origin.y-kAnimationViewExtraWidth/2;
    CGFloat newX = tabBarButton.frame.origin.x + imageFrame.origin.x - kAnimationViewExtraWidth/2;
    self.highlightView.layer.backgroundColor = self.backgroundColorForAnimationView.CGColor;
    CGFloat ImageSize = imageFrame.size.width;
    if(imageFrame.size.width < imageFrame.size.height){
        ImageSize = imageFrame.size.height;
    }
   
    
    [self.highlightView.layer removeAllAnimations];
        // Animate the movement of the sliding background view
        [UIView animateWithDuration:2.0
                              delay:0
             usingSpringWithDamping:1.0
              initialSpringVelocity:0.0
                            options:UIViewAnimationOptionCurveEaseInOut
                         animations:^{
            // Update the sliding background view's frame to move to the selected tab
            self.highlightView.layer.cornerRadius=(ImageSize+2)/2;
            self.highlightView.layer.frame = CGRectMake(newX, newY, imageFrame.size.width+kAnimationViewExtraWidth, imageFrame.size.width+kAnimationViewExtraWidth);
        }
                         completion:^(__unused BOOL finished) {
            // Create the jump animation for the tab bar button
            [weakSelf.highlightView.layer removeAllAnimations];
                [UIView animateKeyframesWithDuration:0.6
                                               delay:0
                                             options:UIViewKeyframeAnimationOptionCalculationModeCubic
                                          animations:^{
                    // First phase: Jump up
            
                    // Second phase: Fall back down
                    [UIView addKeyframeWithRelativeStartTime:0.0 relativeDuration:0.6 animations:^{
                        weakSelf.highlightView.layer.cornerRadius=kAnimationViewExtraWidth;
                        weakSelf.highlightView.layer.frame = CGRectMake(newX+ImageSize/2-kAnimationViewExtraWidth/2, imageFrame.origin.y+ImageSize/2-kAnimationViewExtraWidth/2, kAnimationViewExtraWidth*2, kAnimationViewExtraWidth*2);
                    }];
                }
                                          completion:nil];
        }];

}

// Helper method to access the tab bar button's view at a given index
- (UIView *)tabBarButtonAtIndex:(NSInteger)index {
    // Get all subviews of the tab bar
    NSArray<UIView *> *tabBarSubviews = self.tabBar.subviews;
    // Filter the subviews to find the tab bar buttons (private class "_UITabBarButton")
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"self isKindOfClass:%@", NSClassFromString(@"UITabBarButton")];
    NSArray<UIView *> *tabBarButtons = [tabBarSubviews filteredArrayUsingPredicate:predicate];
  
    // Check if the index is within bounds
    if (index < 0 || index >= tabBarButtons.count) {
        return nil;
    }
    
    // Return the tab bar button at the specified index
    return tabBarButtons[index];
}

@end
