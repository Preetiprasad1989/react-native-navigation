//
//  RNNBottomTabsAnimatedController.m
//  ReactNativeNavigation
//
//  Created by Preeti . on 18/09/24.
//  Copyright © 2024 Wix. All rights reserved.
//

#import "RNNBottomTabsAnimatedController.h"
#import <UIKit/UIKit.h>
@interface RNNBottomTabsAnimatedController ()

@property(nonatomic, assign)AnimationType animationtype;

@property (nonatomic, strong) UIView *highlightView; // View to animate as the background
@end

@implementation RNNBottomTabsAnimatedController
-(instancetype)initWithLayoutInfo:(RNNLayoutInfo *)layoutInfo creator:(id<RNNComponentViewCreator>)creator options:(RNNNavigationOptions *)options defaultOptions:(RNNNavigationOptions *)defaultOptions presenter:(RNNBasePresenter *)presenter bottomTabPresenter:(BottomTabPresenter *)bottomTabPresenter dotIndicatorPresenter:(RNNDotIndicatorPresenter *)dotIndicatorPresenter eventEmitter:(RNNEventEmitter *)eventEmitter childViewControllers:(NSArray *)childViewControllers bottomTabsAttacher:(BottomTabsBaseAttacher *)bottomTabsAttacher withAnimationType:(AnimationType)animationType{
    self=[super initWithLayoutInfo:layoutInfo creator:creator options:options defaultOptions:defaultOptions presenter:presenter bottomTabPresenter:bottomTabPresenter dotIndicatorPresenter:dotIndicatorPresenter eventEmitter:eventEmitter childViewControllers:childViewControllers bottomTabsAttacher:bottomTabsAttacher];
    return self;
}


// Setup the highlight view under the tab bar items
- (void)setupHighlightView {
    // Define initial size and position for the highlight view
   
    // Create the highlight view with the size of one tab bar item
    self.highlightView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 100, 100)];
 // Set the desired color and opacity
    //self.highlightView.layer.frame = CGRectMake(0+35, 10, 30, 30);
    
    // Insert the highlight view below the tab bar items
   
    [self.tabBar insertSubview:self.highlightView atIndex:0];
}
- (void)setInitialFrame {
    UIView *tabBarButton = [self tabBarButtonAtIndex:0];
    
    // Check if the tab bar button is available
    if (!tabBarButton) {
        return;
    }
    NSLog(@"%@",tabBarButton.subviews);
    CGRect frame = CGRectMake(0, 0, 0, 0);
    for (UIView *subView in tabBarButton.subviews) {
        if([subView isKindOfClass:NSClassFromString(@"UITabBarSwappableImageView")]){
            frame = subView.frame;
        }
    }
    if(frame.size.width == 0){
        CGFloat tabBarItemWidth = self.tabBar.frame.size.width / self.tabBar.items.count;
        CGFloat newX = (tabBarItemWidth/2)-15;
        self.highlightView.layer.backgroundColor = [UIColor colorWithRed:0.0 green:0.0 blue:1.0 alpha:0.2].CGColor;
        self.highlightView.layer.cornerRadius=15;
        self.highlightView.layer.frame = CGRectMake(newX, tabBarButton.frame.size.height/2-20, 30, 30);
    }
    //[UIView cancelPreviousPerformRequestsWithTarget:self];
    // Create the jump animation
    // Calculate the new X position for the sliding background view
   
}
- (void)viewDidLoad {
    [super viewDidLoad];
    [self setupHighlightView];
}

- (void)viewDidLayoutSubviews {
    [super viewDidLayoutSubviews];
    [self setInitialFrame];
}

- (BOOL)tabBarController:(UITabBarController *)tabBarController
    shouldSelectViewController:(UIViewController *)viewController {
    NSUInteger _index = [tabBarController.viewControllers indexOfObject:viewController];
    BOOL isMoreTab = ![tabBarController.viewControllers containsObject:viewController];

    [self.eventEmitter sendBottomTabPressed:@(_index)];
    [self animateTabBarItemAtIndex:_index withTabBarController:tabBarController];
    if ([[viewController resolveOptions].bottomTab.selectTabOnPress withDefault:YES] || isMoreTab) {
        return YES;
    }

    return NO;
}
// Method to apply the jump animation to a tab bar item
- (void)animateTabBarItemAtIndex:(NSInteger)index withTabBarController:(UITabBarController *)tabBarController {
    // Access the tab bar button's view
    UIView *tabBarButton = [self tabBarButtonAtIndex:index];
    
    // Check if the tab bar button is available
    if (!tabBarButton) {
        return;
    }
    self.highlightView.layer.backgroundColor = [UIColor colorWithRed:1.0 green:0.0 blue:1.0 alpha:0.2].CGColor;
    
    CGRect frame = CGRectMake(0, 0, 0, 0);
    for (UIView *view1 in tabBarButton.subviews) {
        if([view1 isKindOfClass:[UIImageView class]]){
            frame = view1.frame;
        }
    }
    __weak typeof(self) weakSelf = self;
    //[UIView cancelPreviousPerformRequestsWithTarget:self];
    // Create the jump animation
    // Calculate the new X position for the sliding background view
    CGFloat newY = tabBarButton.frame.size.height/2-20;
    CGFloat newX = tabBarButton.frame.origin.x + frame.origin.x;
    [self.highlightView.layer removeAllAnimations];
        // Animate the movement of the sliding background view
        [UIView animateWithDuration:2.0
                              delay:0
             usingSpringWithDamping:1.0
              initialSpringVelocity:0.0
                            options:UIViewAnimationOptionCurveEaseInOut
                         animations:^{
            // Update the sliding background view's frame to move to the selected tab
            weakSelf.highlightView.layer.cornerRadius=(frame.size.height/2 + 3);
            weakSelf.highlightView.layer.frame =  CGRectMake(newX-1, newY, frame.size.width+6, (frame.size.height+6));
            weakSelf.highlightView.layer.backgroundColor = [UIColor colorWithRed:0.4 green:0.5 blue:0.4 alpha:0.5].CGColor;
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
                        weakSelf.highlightView.layer.cornerRadius=8;
                        weakSelf.highlightView.layer.frame = CGRectMake(newX+4, frame.origin.y+8, 16, 16);
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