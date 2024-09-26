//
//  RNNBottomTabsAnimatedController.h
//  ReactNativeNavigation
//
//  Created by Preeti . on 18/09/24.
//  Copyright © 2024 Wix. All rights reserved.
//

#import "RNNBottomTabsController.h"
#import "RNNEnums.h"

@interface RNNBottomTabsAnimatedController : RNNBottomTabsController


- (instancetype)initWithLayoutInfo:(RNNLayoutInfo *)layoutInfo
						   creator:(id<RNNComponentViewCreator>)creator
						   options:(RNNNavigationOptions *)options
					defaultOptions:(RNNNavigationOptions *)defaultOptions
						 presenter:(RNNBasePresenter *)presenter
				bottomTabPresenter:(BottomTabPresenter *)bottomTabPresenter
			 dotIndicatorPresenter:(RNNDotIndicatorPresenter *)dotIndicatorPresenter
					  eventEmitter:(RNNEventEmitter *)eventEmitter
			  childViewControllers:(NSArray *)childViewControllers
				bottomTabsAttacher:(BottomTabsBaseAttacher*)bottomTabsAttacher withAnimationType:(Text*)animationType
                  animatingBgColor:(Color*)bgColor;
@end
